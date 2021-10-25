import argparse
import dpkt
import socket


parser = argparse.ArgumentParser()
parser.add_argument('-f', required=True)
args = parser.parse_args()
filename = args.f


def main():
    get_init_num(filename)
    get_from_tcp_flow(filename)
    get_retrans_num(filename)
    
#calculate number of TCP flows
def get_init_num(file):
    f = open(file, 'rb')
    pcap = dpkt.pcap.Reader(f)
    cnt = 0
    for _, buf in pcap:
        eth = dpkt.ethernet.Ethernet(buf)
        if not isinstance(eth.data, dpkt.ip.IP):
            continue
        ip = eth.data
        if ip.p != dpkt.ip.IP_PROTO_TCP:
            continue
        tcp = ip.data
        if (tcp.flags & dpkt.tcp.TH_FIN) and (tcp.flags & dpkt.tcp.TH_ACK):
            cnt += 1
    print(f'The number of TCP flows initiated from the sender is {cnt}')
    f.close()

#calculate IP, Sequence number, Ack number and Receive Window Size, also throughput after calculating previous value.
def get_from_tcp_flow(file):
    f = open(file, 'rb')
    pcap = dpkt.pcap.Reader(f)
    ready = False
    cnt = 0
    total = 0.
    start, end = 0, 0
    n = 0
    for idx, (ts, buf) in enumerate(pcap):
        eth = dpkt.ethernet.Ethernet(buf)
        if not isinstance(eth.data, dpkt.ip.IP):
            continue
        ip = eth.data  
        src_ip = inet_to_str(ip.src)
        dst_ip = inet_to_str(ip.dst)      
        if ip.p != dpkt.ip.IP_PROTO_TCP:
            # We are only interested in TCP
            continue
        tcp = ip.data
        src_port = tcp.sport
        dst_port = tcp.dport
        if (tcp.flags & dpkt.tcp.TH_FIN) and (tcp.flags & dpkt.tcp.TH_ACK):
            if n != 0 and total > 0:
                print(f'Throughput is {total/(end-start)} byte/s')
            n += 1
            total = 0.
            start = ts
            ready = True
            print(f'src ip:port is {src_ip}:{src_port}, dst ip:port is {dst_ip}:{dst_port}')
        elif ready and cnt < 2:
            print(f'Sequence number {tcp.seq}, Ack number {tcp.ack}, and Receive Window size {tcp.win}')
            cnt += 1
        elif cnt >= 2:
            ready = False
            cnt = 0
        else:
            total += len(tcp.data)
            end = ts
    f.close()

def inet_to_str(inet):
    try:
        return socket.inet_ntop(socket.AF_INET, inet)
    except:
        return False

#calculate retransmission 
def get_retrans_num(file):
    f = open(file, 'rb')
    pcap = dpkt.pcap.Reader(f)
    send_acks = set([])
    cnt = 0
    for _, buf in pcap:
        eth = dpkt.ethernet.Ethernet(buf)
        if not isinstance(eth.data, dpkt.ip.IP):
            continue
        ip = eth.data
        if ip.p != dpkt.ip.IP_PROTO_TCP:
            # We are only interested in TCP
            continue
        tcp = ip.data
        if tcp.ack in send_acks:
            cnt += 1
        send_acks.add(tcp.ack)
    print(f'The number of times a retransmission is {cnt}')
    f.close()


if __name__ == '__main__':
    # run python analysis_pcap_tcp -f your_filename
    main()