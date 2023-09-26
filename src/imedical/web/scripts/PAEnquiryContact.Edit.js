// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 18.06.02

/*
function SurnameLookupSelect(str) {
  //alert(str);
  var lu = str.split("^");
  showClient(lu[0],lu[2],lu[3]+" "+lu[4],lu[9],lu[14],lu[10],lu[11],lu[7]);
}*/

function RequestStatusLookupSelect() {
  //dummy
}

function ResourceLookupSelect() {
  //dummy
}

function CareProvLookupSelect() {
  //dummy
}

/*
function SurnameChangeHandler() {
 var obj=document.getElementById('PAPERName');
 if ((obj)&&(obj.value==""))
 {
   showClient("","","","","","","","");
 }
}*/

function ContactChangeHandler() {
 var obj=document.getElementById('ENQContactName');
 var obj2=document.getElementById("ENQContactNumber");
 if ((obj)&&(obj2)) {
   if (obj.value=="") DisableField(obj2);
   if (obj.value!="")
   {
     EnableField(obj2);
     obj2.focus();
   }
 }
}

function DeleteClientLink() {
  showClient("","","","","","","","");
}

function showClient(id,surname,forname,add1,add2,city,zip,tel) {
 var oPAPER=document.getElementById("ENQPAPERDR");
 var oSurname=document.getElementById("PAPERName");
 var oForname=document.getElementById("PAPERName2");
 var oAdd1=document.getElementById("PAPERStName");
 var oAdd2=document.getElementById("PAPERForeignAddress");
 var oCity=document.getElementById("CTCITDesc");
 var oZip=document.getElementById("CTZIPDesc");
 var oTel=document.getElementById("PAPERTelH");

 if (oPAPER) oPAPER.value=id;
 if (oSurname) oSurname.innerText=surname;
 if (oForname) oForname.innerText=forname;
 if (oAdd1) oAdd1.innerText=add1;
 if (oAdd2) oAdd2.innerText=add2;
 if (oCity) oCity.innerText=city;
 if (oZip) oZip.innerText=zip;
 if (oTel) oTel.innerText=tel;
 return;
}

function UpdateClickHandler() {
	var msg="";
	
	// mandatory fields
	if (msg != "") {
		alert(msg);
		return false;
	}
	return update1_click();
}


function BodyLoadHandler() {
    var obj=document.getElementById('DeleteClientLink');
    if (obj) obj.onclick=DeleteClientLink;

    //var obj=document.getElementById('PAPERName');
    //if (obj) obj.onblur=SurnameChangeHandler;

    var obj=document.getElementById('ENQContactName');
    var obj2=document.getElementById('ENQContactNumber');
    if ((obj)&&(obj2)&&(obj.value=="")) DisableField(obj2);
    if (obj) obj.onblur=ContactChangeHandler;

	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
}

document.body.onload=BodyLoadHandler;

function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}
