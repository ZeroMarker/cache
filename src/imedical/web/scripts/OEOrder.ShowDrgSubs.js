// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var HasClicked=0;

function BodyUnLoadHandler() {
	if(HasClicked==0) ProcNonSubItem();

}

function BlankClickHandler() {
	return false;
}

function BodyLoadHandler() {
	var OITMObj=document.getElementById("OrderOrig");
	if (OITMObj) OITMObj.onclick=OrigItemClickHandler;

	var SITMObj=document.getElementById("OrderSubs");
	if (SITMObj) SITMObj.onclick=SubsItemClickHandler;

	var DObj=document.getElementById("disableSubs");
	if((DObj)&&(DObj.value=="Y")) {
		var SITMObj=document.getElementById("SubsOrdItem");
		if (SITMObj) {
			SITMObj.onclick=BlankClickHandler;
			SITMObj.disabled=true;
		}
	}
}

function OrigItemClickHandler() {
	var ItemCount="";
	var AOIObj=document.getElementById("AddOrigItem");
	var SIStrObj=window.opener.document.getElementById("SubsItemStr");
	var SIStrCObj=window.opener.document.getElementById("SubsItemStrCount");
	var ICObj=document.getElementById("SubsItemCount");
	if((ICObj)&&(ICObj.value!="")) ItemCount=ICObj.value;
	if((SIStrObj)&&(AOIObj)&&(AOIObj.value!="")) {
		SIStrObj.value=SIStrObj.value+AOIObj.value;
		SIStrCObj.value=(SIStrCObj.value*1)+1;
		HasClicked=1;
	}
	if(ItemCount==SIStrCObj.value) ProcItem();
	window.close();
}

function SubsItemClickHandler() {
	var ItemCount=0;
	
	var ASObj=document.getElementById("AddSubsItem");
	var SIStrObj=window.opener.document.getElementById("SubsItemStr");
	var SIStrCObj=window.opener.document.getElementById("SubsItemStrCount");
	var ICObj=document.getElementById("SubsItemCount");
	if((ICObj)&&(ICObj.value!="")) ItemCount=ICObj.value;
	if((SIStrObj)&&(ASObj)&&(ASObj.value!="")) {
		SIStrObj.value=SIStrObj.value+ASObj.value;
		SIStrCObj.value=(SIStrCObj.value*1)+1;
		HasClicked=1;
	}
	if(ItemCount==SIStrCObj.value) ProcItem();
	window.close();
}

function ProcItem() {
	if(window.opener) {
		window.opener.DeleteClickHandler();
		var SIStrObj=window.opener.document.getElementById("SubsItemStr");
		var SIStrCObj=window.opener.document.getElementById("SubsItemStrCount");
		if((SIStrObj)&&(SIStrObj.value!="")) {
			var AddStr=SIStrObj.value;
			var adata=AddStr.split("*");
			for (var j=0;j<adata.length;j++) {
				var CurrStr=adata[j];
				if(CurrStr!="") {
					var ARCIMID=mPiece(CurrStr,"^",0);
					var ARCIMDesc=mPiece(CurrStr,"^",1);
					if((ARCIMID!="")&&(ARCIMDesc!="")) window.opener.AddItemToList("",ARCIMID,ARCIMDesc);
				}
			}
			var NSObj=document.getElementById("NonSubItems");
			if ((NSObj)&&(NSObj.value!="")) {
				var Str=NSObj.value;
				var adata=Str.split("*");
				for (var j=0;j<adata.length;j++) {
					var CurrStr=adata[j];
					if(CurrStr!="") {
						var ARCIMID=mPiece(CurrStr,"^",0);
						var ARCIMDesc=mPiece(CurrStr,"^",1);
						if((ARCIMID!="")&&(ARCIMDesc!="")) window.opener.AddItemToList("",ARCIMID,ARCIMDesc);
					}
				}
			}
			SIStrObj.value="";
			if(SIStrCObj) SIStrCObj.value="0";
		}
	}
	
	window.opener.SelectAllPreUpdateItem();
	window.opener.UpdateOnAddClick(0,1,1);
	window.close();
}

function ProcNonSubItem() {
	if(window.opener) {
		window.opener.DeleteClickHandler();
		var NSObj=document.getElementById("NonSubItems");
		if ((NSObj)&&(NSObj.value!="")) {
			var Str=NSObj.value;
			var adata=Str.split("*");
			for (var j=0;j<adata.length;j++) {
				var CurrStr=adata[j];
				if(CurrStr!="") {
					var ARCIMID=mPiece(CurrStr,"^",0);
					var ARCIMDesc=mPiece(CurrStr,"^",1);
					if((ARCIMID!="")&&(ARCIMDesc!="")) window.opener.AddItemToList("",ARCIMID,ARCIMDesc);
				}
			}
		}
		window.opener.SelectAllPreUpdateItem();
		window.opener.UpdateOnAddClick(0,1,1);
		window.close();
	}
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);	
	if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

document.body.onunload = BodyUnLoadHandler;
document.body.onload = BodyLoadHandler;
