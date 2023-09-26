// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

function GetDesc(type) {
	var desc = "User (" + session['LOGON.USERCODE'] + ")";
	if (type=='L') desc = "Location (" + document.getElementById("LocDesc").value + ")";
	//alert("type L"+desc);
	if (type=='G') desc = "Group (" + session['LOGON.GROUPDESC'] + ")";
	if (type=='T') desc = "Site (" + session['LOGON.SITECODE'] + ")";
	return desc;
}
function SetOrgFavSaveAs(type) {
	document.fOEOrder_OrgFav.type.value=type;
	document.getElementById('SaveAs').innerText=GetDesc(type);
}

function DeleteItems() {
	for (var i=1; i<6; i++) {
		var lst = document.getElementById("lstOrders" + i);
		if (lst) {
		  for (var j=lst.options.length-1; j>=0; j--) {
			if (lst.options[j].selected)
				lst.options.remove(j);
		  }
		}
	}
	return false;
}
var obj=document.getElementById("Delete");
if (obj) obj.onclick=DeleteItems;

function UpdateItems() {
	for (var i=1; i<6; i++) {
		var arrItems = new Array();
		var lst = document.getElementById("lstOrders" + i);
		if (lst) {
		  for (var j=0; j<lst.options.length; j++) {
			//alert(lst.options[j].itype);
			var valueArr=lst.options[j].value.split(String.fromCharCode(4));
			if (valueArr.length>1) {
				//alert("OSItemIDArr="+valueArr[4]);
				if (valueArr[0]=="ARCOS") {
					var OSItemIDArr=valueArr[4].split(String.fromCharCode(14));
					var OSItemIDs="";
					for (var k=0;k<OSItemIDArr.length;k++) {
						if (OSItemIDArr[k].split(String.fromCharCode(12))[0].length==0) break;
						if (OSItemIDArr[k].split(String.fromCharCode(12)).length > 1 && OSItemIDArr[k].split(String.fromCharCode(12))[0]!="") OSItemIDs=OSItemIDs+OSItemIDArr[k].split(String.fromCharCode(12))[0]+String.fromCharCode(12);
					}
					//alert("after OSItemIDs :"+OSItemIDs);
					valueArr=valueArr[0]+String.fromCharCode(4)+valueArr[1]+String.fromCharCode(4)+valueArr[2]+String.fromCharCode(4)+valueArr[3]+String.fromCharCode(4)+OSItemIDs+String.fromCharCode(4)+valueArr[5]+String.fromCharCode(4);
					lst.options[j].itype=valueArr;
				}
				else {
					lst.options[j].itype=valueArr[0]+String.fromCharCode(4)+valueArr[1]+String.fromCharCode(4)+valueArr[2]+String.fromCharCode(4)+valueArr[3]+String.fromCharCode(4)+String.fromCharCode(4)+valueArr[5]+String.fromCharCode(4);
				}
				lst.options[j].value=lst.options[j].value.split(String.fromCharCode(28))[1];
			}
			//alert("itype="+lst.options[j].itype+" value="+lst.options[j].value);
			arrItems[j] = lst.options[j].itype + String.fromCharCode(28) + lst.options[j].value;
			//alert("brenda's debugging org: "+arrItems[j]);
		  }
		}
		var el = document.getElementById("LstGroup" + i);
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert(el.id + " : " + el.value);
	}
	return Update_click();
}

function BodyLoadHandler() {
	var frame0=window.opener.parent.frames[0]; //.document.forms[0];
	//alert("frame0 "+frame0.name);
	var locObj=document.getElementById("Location");
	var clocObj=document.getElementById("cLocation");
	var imglocObj=document.getElementById("ld266iLocation");
	// ANA LOG 23069 04-APR-02.These fields are hidden from the user if he accesses this page from anywhere other than directly from the menu.( normally on the side menu)
	if (frame0.name=="TRAK_menu") {
		if (locObj) locObj.style.visibility="visible" //type="hidden";
		if (clocObj) clocObj.style.visibility="visible" //type="hidden";
		if (imglocObj) imglocObj.style.visibility="visible" //type="hidden";
	}else {
		//Log 27536 20-08-02 Disbale the "Location" instead of making it invisible. 
		if (locObj) locObj.style.visibility="visible" //type="hidden";
		if (clocObj) clocObj.style.visibility="visible" //type="hidden";
		DisableField("Location","ld266iLocation");
		
	}

}


var obj=document.getElementById("Update");
if (obj) obj.onclick=UpdateItems;
var addObj=document.getElementById("Add");
if (addObj) addObj.onclick=AddItem;

function OrderItemLookupSelect(txt) {
	//Add an item to lstOrders when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];	
	var ifreq=adata[2];
	var iordertype=adata[3];
	var ialias=adata[4];
	var isubcatcode=adata[5];
	//alert("isubcatcode "+isubcatcode)
	var iorderCatID=adata[6];
	var iSetID=adata[7];
	var mes=adata[8];
	var irangefrom=adata[9];
	var irangeto=adata[10]
	var iuom=adata[11];
	var idur=adata[12];
	var igeneric=adata[13];
	var match="notfound";
	var SetRef=1;
	var OSItemIDs=adata[15];
	var iorderSubCatID=adata[16];
	if(OSItemIDs=="") Itemids=icode;
	else Itemids=icode+String.fromCharCode(12)+OSItemIDs;

	icode=iordertype+String.fromCharCode(4)+ialias+String.fromCharCode(4)+iSetID+String.fromCharCode(4)+iorderCatID+String.fromCharCode(4)+String.fromCharCode(28)+icode;
	//this only adds the item to group 1
	var obj=document.getElementById("lstOrders1")
	//if (obj) AddItem(obj,icode,idesc);
	if (obj) AddItem(obj,icode,idesc,"","","","","","","","",OSItemIDs,iorderSubCatID);
	document.fOEOrder_OrgFav.Item.value="";

}

function AddItem(list,code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,setref,OSItemIDs,ordsubcatID) {
	//Add an item to a group1
	//alert(code+"*"+desc+"*"+OSItemIDs);
	list.options[list.length] = new Option(desc,code);	
	list.options[list.length-1].id=subcatcode+String.fromCharCode(4)+dur+String.fromCharCode(4)+setref+String.fromCharCode(4);
	
	list.options[list.length-1].value=code.split(String.fromCharCode(28))[1];
		
	if (OSItemIDs=="") {
		list.options[list.length-1].itype=code.split(String.fromCharCode(4))[0]+String.fromCharCode(4)+code.split(String.fromCharCode(4))[1]+String.fromCharCode(4)+code.split(String.fromCharCode(4))[2]+String.fromCharCode(4)+code.split(String.fromCharCode(4))[3]+String.fromCharCode(4)+String.fromCharCode(4)+ordsubcatID+String.fromCharCode(4);
	}
	else {
		var OSItemIDArr=OSItemIDs.split(String.fromCharCode(12))
		for (var i=0;i<OSItemIDArr.length;i++) {
			if (OSItemIDArr[i].split(String.fromCharCode(14)).length > 1) OSItemIDArr[i]=OSItemIDArr[i].split(String.fromCharCode(14))[1];
		}
		OSItemIDs=OSItemIDArr.join(String.fromCharCode(12));
		list.options[list.length-1].itype=code.split(String.fromCharCode(4))[0]+String.fromCharCode(4)+code.split(String.fromCharCode(4))[1]+String.fromCharCode(4)+code.split(String.fromCharCode(4))[2]+String.fromCharCode(4)+code.split(String.fromCharCode(4))[3]+String.fromCharCode(4)+OSItemIDs+String.fromCharCode(4)+ordsubcatID+String.fromCharCode(4);
	}
	list.options[list.length-1].idata=data;
	//alert("itype="+list.options[list.length-1].itype+" value="+list.options[list.length-1].value);
	//alert(list.options[list.length-1].value.length);

}

function moveItems(lstFrom,lstTo) {
	for (var i=0; i<lstFrom.options.length; i++) {
		var opt = lstFrom.options[i];
		if (opt.selected) {
			var cnt = lstTo.options.length;
			lstTo.options[cnt] = new Option(opt.text,opt.value);
			lstTo.options[cnt].itype = opt.itype;
			//alert("val "+lstTo.options[cnt].value);
			//alert("desc "+lstTo.options[cnt].text);
			lstTo.options[cnt].selected = true;
		}
	}
	return false;
}
function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}
function getLst(e) {
	var id="";
	if (window.event)
		var id = window.event.srcElement.id;
	else
		var id = e.target.id;
	var lstfrom = document.getElementById("lstOrders" + id.charAt(id.length-4));
	var lstto = document.getElementById("lstOrders" + id.charAt(id.length-1));
	moveItems(lstfrom,lstto);
	RemoveFromList(lstfrom);
}
function UpClickFav(obj) {
	var i=obj.selectedIndex;
	var len=obj.length;
	if ((len>1)&&(i>0)) SwapFav(obj,i,i-1)
	return false;
}
function DownClickFav(obj) {
	var i=obj.selectedIndex;
	var len=obj.length;
	if ((len>1)&&(i>=0)&&(i<(len-1))) SwapFav(obj,i,i+1)
	return false;
}
function SwapFav(lst,a,b) { //Swap position and style of two options
	var opta=lst.options[a];
	var optb=lst.options[b];
	lst.options[a] = new Option(optb.text,optb.value);
	lst.options[a].itype = optb.itype
	lst.options[b] = new Option(opta.text,opta.value);
	lst.options[b].itype = opta.itype
	lst.options[a].selected = optb.selected;
	lst.options[b].selected = opta.selected;
}
function UpClickHandler1() {UpClickFav(document.getElementById("lstOrders1")); return false;}
function DownClickHandler1() {DownClickFav(document.getElementById("lstOrders1")); return false;}
function UpClickHandler2() {UpClickFav(document.getElementById("lstOrders2")); return false;}
function DownClickHandler2() {DownClickFav(document.getElementById("lstOrders2")); return false;}
function UpClickHandler3() {UpClickFav(document.getElementById("lstOrders3")); return false;}
function DownClickHandler3() {DownClickFav(document.getElementById("lstOrders3")); return false;}
function UpClickHandler4() {UpClickFav(document.getElementById("lstOrders4")); return false;}
function DownClickHandler4() {DownClickFav(document.getElementById("lstOrders4")); return false;}
function UpClickHandler5() {UpClickFav(document.getElementById("lstOrders5")); return false;}
function DownClickHandler5() {DownClickFav(document.getElementById("lstOrders5")); return false;}

var obj=document.getElementById("b1to2"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b2to1"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b2to3"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b3to2"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b3to4"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b4to3"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b4to5"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b5to4"); if (obj) obj.onclick=getLst;
var obj=document.getElementById("b1Up"); if (obj) obj.onclick=UpClickHandler1;
var obj=document.getElementById("b1Down"); if (obj) obj.onclick=DownClickHandler1;
var obj=document.getElementById("b2Up"); if (obj) obj.onclick=UpClickHandler2;
var obj=document.getElementById("b2Down"); if (obj) obj.onclick=DownClickHandler2;
var obj=document.getElementById("b3Up"); if (obj) obj.onclick=UpClickHandler3;
var obj=document.getElementById("b3Down"); if (obj) obj.onclick=DownClickHandler3;
var obj=document.getElementById("b4Up"); if (obj) obj.onclick=UpClickHandler4;
var obj=document.getElementById("b4Down"); if (obj) obj.onclick=DownClickHandler4;
var obj=document.getElementById("b5Down"); if (obj) obj.onclick=DownClickHandler5;
var obj=document.getElementById("b5Up"); if (obj) obj.onclick=UpClickHandler5;
var obj=document.getElementById("b5Down"); if (obj) obj.onclick=DownClickHandler5;

function LookUpCatSelect(txt) {
	
	//ANA 06.03.2002 Function to Return the Category ID 

	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];	
	var catCode=adata[2];
	var catobj=document.getElementById("Categ");
	catobj.value=escape(catDesc);
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	var scobj=document.getElementById("SubCategory");
	scobj.value="";
	var iobj=document.getElementById("Item");
	iobj.value="";
}

function LookUpSubCatSelect(txt) {
	
	//ANA 06.03.2002 Function to Return the SubCategory ID 

	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];	
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;
}

function LookUpLocSelect(txt) {
	
	//ANA 03.04.2002 Function to Return the Location Description

	var adata=txt.split("^");
	var locDesc=adata[0];
	var locID=adata[1];	
	var locCode=adata[2];
	var locobj=document.getElementById("LocDesc");
	if (locobj) locobj.value=locDesc;
}

var cobj=document.getElementById("Category");
if (cobj) cobj.onchange=checkBlank;


var scobj=document.getElementById("SubCategory");
if (scobj) scobj.onchange=checkBlank;

document.body.onload = BodyLoadHandler;
function checkBlank(){	
	if (cobj.value=="") {
		var catobj=document.getElementById("catID");
		catobj.value=""
		
	}
	if(scobj.value=="") {
		var subcatobj=document.getElementById("subCatID");
		subcatobj.value=""
	}
}