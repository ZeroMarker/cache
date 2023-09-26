// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//
function luItem() {
	var scn='';
	var itm='';
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		if (Scn) scn=Scn.value;
		if (Item) itm=Item.value;
		var url='websys.dssview.lookup.csp?classname=' + scn + '&sqlfieldname=' + itm;
		websys_lu(url,true,'');
		return websys_cancel();
	}

}
function StartingClassName_changehandler() {
	//If we have items selected and we are changing the class then delete the items
	if (Scn) {
		if (Items) {
			if (Items.length>0||(Scn.value='')) {
				if (confirm(t['DELITEMS'])) {
					Items.length=0;
					return true;
				} else
					return false;
			}
		}
	}
}
function AddItem(txt) {
	if (Items) {
		var opt = new Option(txt,Items.length);
		opt.value=Items.length;
		Items[Items.length] = opt;
	}
	websys_setfocus('Item');
}
function DeleteItemHandler() {
	var i=Items.selectedIndex;
	if (i>-1) {
		Items.options.remove(i);
		SQLAs.value='';
	}
	return false;
}
function ItemsClickHandler() {
	var i=Items.selectedIndex;
	if (i>-1) {
		var txt=Items.options[i].text;
		var aTxt=txt.split(' AS ');
		if (aTxt[0]) {
			Item.value=aTxt[0];
		} else
			Item.value='';
		if (aTxt[1]) {
			SQLAs.value=aTxt[1];
		} else
			SQLAs.value='';
	}
	return false;
}
function SQLAs_changehandler() {
	var i=Items.selectedIndex;
	if (i>-1) {
		var txt=Items.options[i].text;
		var aTxt=txt.split(' AS ');
		if (SQLAs.value=='') {
			Items.options[i].text=aTxt[0];
		} else {
			Items.options[i].text=aTxt[0] + ' AS ' + SQLAs.value;
		}
	}
}
function update_clickhandler() {
	// String 'em all together and stick them on HITEMS

	var tmp='';

	for (var j=0;j<Items.length;j++) {
		tmp=tmp+Items.options[j].text+'^';
	}
	var obj=document.getElementById("HITEMS");
	if (obj) obj.value=tmp;
	
	update1_click();
}

function ClassDisplayNameLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("StartingClassName")
	if (obj) obj.value = lu[1]
	obj=document.getElementById("StartingClassDisplayName")
	if (obj) obj.value = lu[0]
}

//INIT
//override the lookup magnifying glass and the key stroke
var classobj=document.getElementById("StartingClassName")
if (classobj) classobj.readOnly=true;

var obj=document.getElementById('ld1523iItem');
if (obj) obj.onclick=luItem;

var obj=document.getElementById('update1');
if (obj) obj.onclick=update_clickhandler;

//set up some standard names
var Item=document.getElementById('Item');
if (Item) Item.onkeydown=luItem;

var Items=document.getElementById('Items');
if (Items) {
	Items.multiple=false;
	Items.onclick=ItemsClickHandler;
}
var Scn=document.getElementById('StartingClassName');
if (Scn) Scn.onchange=StartingClassName_changehandler;
var DelItm=document.getElementById('DeleteItem');
if (DelItm) DelItm.onclick=DeleteItemHandler;

var SQLAs=document.getElementById('SQLAs');
if (SQLAs) SQLAs.onchange=SQLAs_changehandler;
//END INIT