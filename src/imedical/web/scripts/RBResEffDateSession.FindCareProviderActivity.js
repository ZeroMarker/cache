// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var debug="N"  //"Y" = alerts and stuff, "N" = alert free

function DocumentLoadHandler() {

	obj=document.getElementById('CTPCPDesc');
	if (obj) obj.onblur= CPTextBlurHandler;

	obj=document.getElementById('Location');
	if (obj) obj.onblur= LocTextBlurHandler;
	
	obj=document.getElementById('surgeon');
	if (obj) obj.onchange= CBChangeHandler;

	obj=document.getElementById('anaethetist');
	if (obj) obj.onchange= CBChangeHandler;

	obj=document.getElementById('radiologist');
	if (obj) obj.onchange= CBChangeHandler;

	obj=document.getElementById('BlankCP');
	if (obj) obj.onclick= CareProvClick;

	obj=document.getElementById('find');
	if (obj) obj.onclick= findClick;
	
	var objDeleteLL=document.getElementById('LocationDelete'); 
	if (objDeleteLL) objDeleteLL.onclick=LLDeleteClickHandler; 
	
	
	InitialDf();
	
	

}

function InitialDf() {
	
	//CareProvClick();
	var obj=document.getElementById('LocationDesc');
	var obj1=document.getElementById('Location');
	var obj2=document.getElementById('LocationList');
	var obj3=document.getElementById('BlankCP');
	if ((obj3)&&(obj3.checked==true))
	{
	CareProvClick();
	var j=0
	if ((obj)&&(obj1)&&(obj.value!="")&&(obj2))
	{
	RemoveAllFromList(obj2);
	while (obj.value.split("^")[j]) {
		//alert(obj.value.split("^")[j]);
		var part=obj.value.split("^")[j];
		if (part!="" )
		{
		var part1=part.split("|")[0];
		var part2=part.split("|")[1];
		AddItemToList(obj2,part2,part1);
		}
		j=j+1;
		}
	}
	}
	else 
	{
	if ((obj1)&&(obj)&&(obj.value.split("^")[0]))
	{
	var v1=obj.value.split("^")[0];
	if (v1!="") {
	obj1.value=v1.split("|")[0];
	  obj1.onchange; 
	  }
	}
	}
	//alert(document.getElementById('LocationID').value);
}

function findClick() {
	var blankcp=document.getElementById('BlankCP');
	if ((blankcp)&&(blankcp.checked==true)) {
		var Loc=document.getElementById('Location');
		var LocID=document.getElementById('LocationID');
		BLLOnFind();
		if ((Loc)&&(LocID)) {
			if ((Loc.className="clsRequired")&&(LocID.value=="")) {
			alert("\'"+t['Location']+"\' "+t["XMISSING"]);
				return false;
			}
		}
		
		var dtfrm=document.getElementById('datefrom');
		if ((dtfrm)) {
			if ((dtfrm.className="clsRequired")&&(dtfrm.value=="")) {
				alert("\'"+t['datefrom']+"\' "+t["XMISSING"]);
				return false;
			}
		}
		var dtto=document.getElementById('dateto');
		if ((dtto)) {
			if ((dtto.className="clsRequired")&&(dtto.value=="")) {
				alert("\'"+t['dateto']+"\' "+t["XMISSING"]);
				return false;
			}
		}
	}
	
	//alert(document.getElementById('LocationID').value);
	return find_click();
}
/* MDdR
function LocationLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Location');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocationID');
	if (obj) obj.value=lu[1];
}
*/
//
function LocationLookUp(txt) {
	/*
	if (evtTimer) {
		setTimeout('LocationLookUp(txt);',200);
		return;
	}
	*/
	//alert(txt);
	var objCP=document.getElementById("BlankCP");
	var objLL=document.getElementById("LocationList");
	if (((objCP)&&(!objCP.checked) )||(!objLL))
	{
	var lu = txt.split("^");
	var obj=document.getElementById('Location');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocationID');
	if (obj) obj.value=lu[1];
	}
	else
	{
	//Add an item to SepRefEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	//alert(txt);
	var adata=txt.split("^");
	//alert("adata[0]="+adata[0]);
	//alert("adata[1]="+adata[1]);
	var obj=document.getElementById("LocationList");
		//Need to check if Loc already exists in the List and alert the user
		if (obj) {
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert(t['SameLocation']);
				var obj=document.getElementById("Location");//Textbox with lookup for SepRef
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['SameLocation']);
				var obj=document.getElementById("Location");
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	
	AddItemToList(obj,adata[1],adata[0]);
	var obj=document.getElementById("Location")
	if (obj) obj.value="";
	}
	//alert("adata="+adata);
	}
	//alert("NUM1:"+document.getElementById('LocationID').value);
}

//md M 
function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=code
	list.options[list.options.length] = new Option(desc,code);
}

function LLDeleteClickHandler() {
	//Delete items from SepRefEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("LocationList")
	if (obj)
	RemoveFromList(obj);
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

function BLLOnFind() {
	var arrItems = new Array();
	var lst = document.getElementById("LocationList");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//FCH: 14-Oct-2002: 
			//Added text value of options to string.
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById("LocationID");
		if (el) el.value = arrItems.join("^");
		//alert(el.value );
	}
}
//MD D

function CareProvLookUp(str) {
	var lu = str.split("^");
	//alert(str);

	var objDesc=document.getElementById("CTPCPDesc");
	if (objDesc) objDesc.value=lu[0];

	var objCPID=document.getElementById("CareProvID");
	if (objCPID) objCPID.value=lu[1];
}

function CareProvClick(e) {
	var obj=document.getElementById("BlankCP");
	var CP=document.getElementById("CTPCPDesc");
	var CPlu=document.getElementById("ld1779iCTPCPDesc");
	var CPlbl=document.getElementById("cCTPCPDesc");
	var objblank=document.getElementById("blankcare");
	var Loc=document.getElementById("Location");
	var Loclbl=document.getElementById("cLocation");
	var dtfrm=document.getElementById("datefrom");
	var dtfrmlbl=document.getElementById("cdatefrom");
	var dtto=document.getElementById("dateto");
	var dttolbl=document.getElementById("cdateto");
	var LLoc=document.getElementById("LocationList");
	if ((obj)&&(CP)&&(CPlu)&&(CPlbl)&&(objblank)&&(Loc)&&(Loclbl)&&(dtfrm)&&(dtfrmlbl)&&(dtto)&&(dttolbl)) {
		if (obj.checked) {
			CP.value=""; CP.disabled=true; CP.className="disabledField"; CPlu.disabled=true; CPlbl.className="";
			Loc.className="clsRequired"; Loclbl.className="clsRequired";
			dtfrm.className="clsRequired"; dtfrmlbl.className="clsRequired"; dtto.className="clsRequired"; dttolbl.className="clsRequired";
			if (document.getElementById('LocationList')) document.getElementById('LocationList').disabled=false;
			if (document.getElementById("CareProvID")) document.getElementById("CareProvID").value="";
			objblank.value="B";Loc.onchange();
		} else {
			CP.disabled=false; CP.className="clsRequired"; CPlu.disabled=false; CPlbl.className="clsRequired";
			Loc.className=""; Loclbl.className="";
			dtfrm.className=""; dtfrmlbl.className=""; dtto.className=""; dttolbl.className="";
			objblank.value="";
			Loc.value="";
			if (document.getElementById('LocationID')) document.getElementById('LocationID').value=""
			if (document.getElementById('LocationList')) {
			RemoveAllFromList(LLoc);
			LLoc.disabled=true;
			}
		}
	}
}

function CPTextBlurHandler(e) {
	//alert(e)
	var obj=document.getElementById("CTPCPDesc");
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById("CareProvID");
		if (obj) obj.value=""
	}
}

function LocTextBlurHandler(e) {
	//alert(e)
	var obj=document.getElementById("Location");
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById("LocationID");
		if (obj) obj.value=""
	}
}

function CBChangeHandler(e) {
	var tvalues="";
	var obj=document.getElementById("surgeon");
	if ((obj)&&(obj.checked)) {
		tvalues=tvalues+"S";
	}
	var obj=document.getElementById("anaethetist");
	if ((obj)&&(obj.checked)) {
		tvalues=tvalues+"A";
	}
	var obj=document.getElementById("radiologist");
	if ((obj)&&(obj.checked)) {
		tvalues=tvalues+"R";
	}
	var obj=document.getElementById("types");
	if (obj) obj.value=tvalues;
}

document.body.onload = DocumentLoadHandler;

