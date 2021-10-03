/**
 * Top5ListController.js
 * 
 * This file provides responses for all user interface interactions.
 * 
 * @author McKilla Gorilla
 * @author ?
 */
export default class Top5Controller {
    constructor() {

    }

    setModel(initModel) {
        this.model = initModel;
        this.initHandlers();
    }

    initHandlers() {
        // SETUP THE TOOLBAR BUTTON HANDLERS
        this.model.view.disableButton("close-button");
        this.model.view.disableButton("undo-button");
        this.model.view.disableButton("redo-button");
        document.getElementById("add-list-button").onmousedown = (event) => {
            let button = document.getElementById("add-list-button");
            if(!button.classList.contains("disabled")){
            let newList = this.model.addNewList("Untitled", ["?","?","?","?","?"]);            
            this.model.loadList(newList.id);
            this.model.saveLists();
            }
        }
        document.getElementById("undo-button").onmousedown = (event) => {
            this.model.undo();
        }

        document.getElementById("redo-button").onmousedown = (event) => {
            this.model.redo();
        }

        document.getElementById("close-button").onmousedown = (event) => {
            let statusbar = document.getElementById("top5-statusbar");
            statusbar.innerHTML="";
            this.model.unselectAll();
            this.model.view.enableButton("add-list-button");
            this.model.view.disableButton("close-button");
            for(let i = 1; i<=5; i++){
                let item = document.getElementById("item-" + i);
                item.textContent = "";
            }

        }
        

        // SETUP THE ITEM HANDLERS
        for (let i = 1; i <= 5; i++) {
            let item = document.getElementById("item-" + i);

            // AND FOR TEXT EDITING
            item.ondblclick = (ev) => {
                if (this.model.hasCurrentList()) {
                    // CLEAR THE TEXT
                    item.innerHTML = "";
                
                    // ADD A TEXT FIELD
                    let textInput = document.createElement("input");
                    textInput.setAttribute("type", "text");
                    textInput.setAttribute("id", "item-text-input-" + i);
                    textInput.setAttribute("value", this.model.currentList.getItemAt(i-1));

                    item.appendChild(textInput);

                    textInput.ondblclick = (event) => {
                        this.ignoreParentClick(event);
                    }
                    textInput.onkeydown = (event) => {
                        if (event.key === 'Enter') {
                            this.model.addChangeItemTransaction(i-1, event.target.value);
                            this.model.view.enableButton("undo-button");
                        }
                    }
                    textInput.onblur = (event) => {
                        this.model.addChangeItemTransaction(i-1, event.target.value);
                        this.model.view.enableButton("undo-button");
                    }
                }
            }
        }
    }

    registerListSelectHandlers(id) {
        // FOR SELECTING THE LIST
        document.getElementById("top5-list-" + id).onmousedown = (event) => {
        
            this.model.unselectAll();
            // GET THE SELECTED LIST
            this.model.loadList(id);
            this.model.updateStatusbar();
            this.model.view.enableButton("close-button");
            this.model.view.disableButton("add-list-button");
        }
        document.getElementById("top5-list-" + id).ondblclick =(event) =>{
            let statusbar = document.getElementById("top5-statusbar");
            statusbar.innerHTML="";
            let card = document.getElementById("list-card-text-"+id);
            card.innerHTML="";
            let textInput = document.createElement("input");
            textInput.setAttribute("type", "text");
            textInput.setAttribute("id", "list-card-text-" + id);
            textInput.setAttribute("value", this.model.getList(id).getName());
            card.appendChild(textInput);
            textInput.onkeydown =(event)=>{
                if(event.key == 'Enter'){
                    card.innerHTML=event.target.value;               
                    this.model.top5Lists[id].setName(event.target.value);
                    console.log(event.target.value);
                    this.model.sortLists();
                    this.model.view.refreshLists(this.model.top5Lists);
                    this.model.saveLists();
                }
            }
            textInput.onblur =(event)=>{
                    card.innerHTML=event.target.value;               
                    this.model.top5Lists[id].setName(event.target.value);
                    this.model.sortLists();
                    this.model.view.refreshLists(this.model.top5Lists);
                    this.model.saveLists();
            }
        

        }
        // FOR DELETING THE LIST
        document.getElementById("delete-list-" + id).onmousedown = (event) => {
            this.ignoreParentClick(event);
            // VERIFY THAT THE USER REALLY WANTS TO DELETE THE LIST
            let modal = document.getElementById("delete-modal");
            this.listToDeleteIndex = id;
            let listName = this.model.getList(id).getName();
            let deleteSpan = document.getElementById("delete-list-span");
            deleteSpan.innerHTML = "";
            deleteSpan.appendChild(document.createTextNode(listName));
            modal.classList.add("is-visible");
            document.getElementById("dialog-cancel-button").onmousedown=(event)=>{
                modal.classList.remove("is-visible");
            }
            document.getElementById("dialog-confirm-button").onmousedown=(event)=>{
                modal.classList.remove("is-visible");
            }
        }
    }

    ignoreParentClick(event) {
        event.cancelBubble = true;
        if (event.stopPropagation) event.stopPropagation();
    }
}