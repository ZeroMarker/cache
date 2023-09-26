// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//Log 56894 BoC 12/12/2006

function LookUpCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];
	var catCode=adata[2];
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value="";

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

// JPD Log 52240
// changed onchange to onblur as they over-ride calls to brokers. 
var cobj=document.getElementById("Category");
if (cobj) cobj.onblur=checkBlank;

//LOG 30799 02/12/02 PeterC: Commented out to prevent the Subcategory field from reseting
var scobj=document.getElementById("SubCategory");
if (scobj) scobj.onblur=SubCatChangeHandler;

function SubCatChangeHandler() {
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("subCatID");
		if (subcatobj) subcatobj.value="";
	}
}
function checkBlank(){
	var catobj=document.getElementById("catID");
	var subcatobj=document.getElementById("subCatID");
	if (cobj.value=="") {
		catobj.value="";
		cobj.value="";
		scobj.value="";
		subcatobj.value="";
	}
	if(scobj.value=="") {
		scobj.value="";
		subcatobj.value=""
	}
}

function OrderItemLookupSelect(txt) {
	//alert(txt);
	var adata=txt.split("^");
	var idesc=adata[0];
	var iid=adata[1];
	var iordertype=adata[3];

	window.focus();

	AddItemToList(iid,idesc,iordertype);
	var itemobj=document.getElementById("Item");
	if (itemobj) {
		itemobj.value="";
		websys_setfocus('Item');
	}
}

function AddItemToList(id,desc,ordertype) {
	var lstOrders=document.getElementById("Orders");
	lstOrders.options[lstOrders.length] = new Option(unescape(desc),id);
	lstOrders.options[lstOrders.length-1].id=id;
	lstOrders.options[lstOrders.length-1].itype=ordertype;
	lstOrders.options[lstOrders.length-1].selected=true;
}

function DeleteClickHandler() {
	var lstOrders=document.getElementById("Orders");
	for (var i=(lstOrders.length-1); i>=0; i--){
		if (lstOrders.options[i].selected) lstOrders.options[i]=null;
	}
}

/*
function BodyloadHandler() {
	alert ("body");
	SetFields();
	SetItemList();
}*/

function UpdateClickHandler() {
	/*
	var EPTotalDaysObj=document.getElementById("EPTotalDays");
	var Obj=document.getElementById("CTLOCDesc");
	var LabelObj=document.getElementById("cCTLOCDesc");
	if ((LabelObj)&&(LabelObj.style.visibility!="hidden")&&(Obj)&&(Obj.style.visibility!="hidden")&&(Obj.value=="")&&(EPTotalDaysObj)&&(EPTotalDaysObj.value!="")){
		alert (t['CTLOCDesc']+t['XMISSING']);
		return false;
	}*/
	self.location.reload();
	return update1_click();
}

function AddServiceOrdersClickHandler() {
	var Obj=document.getElementById("CTLOCDesc");
	var LabelObj=document.getElementById("cCTLOCDesc");
	if ((LabelObj)&&(LabelObj.style.visibility!="hidden")&&(LabelObj.className=="clsRequired")&&(Obj)&&(Obj.style.visibility!="hidden")&&(Obj.value=="")){
		alert (t['CTLOCDesc']+t['XMISSING']);
		return false;
	}
	var EPTotalDays="";
	var DAYS="";
	var EPTotalDaysObj=document.getElementById("HiddenEPTotalDays");
	if (EPTotalDaysObj) EPTotalDays=EPTotalDaysObj.value;
	if (EPTotalDays!="") {
		for (i=1;i<=EPTotalDays ; i++) {
			var DaySelected=document.getElementById(i);
			if ((DaySelected)&&(DaySelected.checked)) {
				DAYS=DAYS+"^"+i;
			}
		}
		var CTLOCDR="";
		var RBResourceDR="";
		var ServiceDR="";
		var EPRowId="";
		var DAYSRowId="";
		var EPEpisode="";
		var link="";
		var ItemIDs="";
		var OSRowIds="";
		var EPIPEpisodeRequired="";
		var obj=document.getElementById("CTLOCDR");
		if (obj) CTLOCDR=obj.value;
		var obj=document.getElementById("RBResourceDR");
		if (obj) RBResourceDR=obj.value;
		var obj=document.getElementById("ServiceDR");
		if (obj) ServiceDR=obj.value;
		var obj=document.getElementById("EPRowId");
		if (obj) EPRowId=obj.value;
		var obj=document.getElementById("DAYSRowId");
		if (obj) DAYSRowId=obj.value;
		var obj=document.getElementById("EPEpisode");
		if (obj) EPEpisode=obj.value;
		var obj=document.getElementById("EPEpisode");
		if (obj) EPEpisode=obj.value;
		var obj=document.getElementById("OSRowIds");
		if (obj) OSRowIds=obj.value;
		var obj=document.getElementById("EPIPEpisodeRequired");
		if (obj) EPIPEpisodeRequired=obj.checked;
		var lstOrders=document.getElementById("Orders");
		for (i=0;i<lstOrders.length ;i++ ) {
			ItemIDs=ItemIDs+"^"+lstOrders.options[i].id
		}
		// log 62820
		if (lstOrders.length==0) {
			var obj=document.getElementById("DefaultItmID");
			if (obj) ItemIDs="^"+obj.value;
			var DefaultItm=tkMakeServerCall("web.MRCClinPathwEpDays","GetItemDesc",obj.value);
			alert (t['NOITM_ADDED']+DefaultItm+t['ADD_DEFAULTITM']);
		}
		//alert (DAYS+"*"+EPRowId+"*"+CTLOCDR+"*"+RBResourceDR+"*"+ServiceDR+"*"+DAYSRowId+"*"+ItemIDs+"*"+OSRowIds+"*"+EPIPEpisodeRequired);
		tkMakeServerCall("web.MRCClinPathwEpDays","SavePathwEpDays",DAYS,EPRowId,CTLOCDR,RBResourceDR,ServiceDR,DAYSRowId,ItemIDs,OSRowIds,EPIPEpisodeRequired);
	}
	link="mrclinicalpathways.cycleedit.csp?&EPRowId="+EPRowId+"&EPEpisode="+EPEpisode
	window.open(link,window.name,"toolbar=no,location=no,menubar=no,width=800,height=600,resizable=yes");
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function LocationLookupHandler(txt) {
	var obj=document.getElementById("CTLOCDR");
	if (obj) obj.value=mPiece(txt,"^",1);
}

function ResourceLookupHandler(txt) {
	var obj=document.getElementById("RBResourceDR");
	if (obj) obj.value=mPiece(txt,"^",2);
	var obj=document.getElementById("RESCode");
	if (obj) obj.value=mPiece(txt,"^",1);
}

function ServiceLookupHandler(txt) {
	//alert (txt);
	var lu = txt.split("^");
	var char4=String.fromCharCode(4)
	var SScheck=""
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[1];
	//log 62820
	var obj=document.getElementById('DefaultItmID');
	if (obj) obj.value=lu[11];
	//var obj=document.getElementById('OrderItemMess');
	//if (obj) obj.value=lu[2];
	SScheck=mPiece(lu[3],char4,1)

	if (SScheck=="SS") {
		var obj=document.getElementById('ServiceDR');
		if (obj) obj.value=mPiece(lu[3],char4,0)
	} else {
		var obj=document.getElementById('ServiceDR');
		if (obj) obj.value=lu[3];
	}
	//var obj=document.getElementById('ServiceGrpParams');
	//if (obj) obj.value=lu[10];
}

function LocationChangeHandler() {
	var DescObj=document.getElementById("CTLOCDesc");
	var DRObj=document.getElementById("CTLOCDR");
	if ((DescObj)&&(DescObj.value=="")&&(DRObj)) DRObj.value="";
}

function ResourceChangeHandler() {
	var DescObj=document.getElementById("RESDesc");
	var DRObj=document.getElementById("RBResourceDR");
	var CodeObj=document.getElementById("RESCode");
	if ((DescObj)&&(DescObj.value=="")) {
		if (DRObj) DRObj.value="";
		if (CodeObj) CodeObj.value="";
	}
}

function ServiceChangeHandler() {
	var DescObj=document.getElementById("SERDesc");
	var DRObj=document.getElementById("ServiceDR");
	//log 62820
	var DefaultItmObj=document.getElementById('DefaultItmID');
	if ((DescObj)&&(DescObj.value=="")&&(DRObj)) DRObj.value="";
	if ((DescObj)&&(DescObj.value=="")&&(DefaultItmObj)) DefaultItmObj.value="";
}

function SetFields() {
	var IPFlag="";
	var EPEpisodeObj=document.getElementById("EPEpisode");
	var EPCycleOffsetDaysObj=document.getElementById("EPCycleOffsetDays");
	if (EPEpisodeObj && EPEpisodeObj.value==1 && EPCycleOffsetDaysObj) EPCycleOffsetDaysObj.disabled=true;
	var EPTotalDaysObj=document.getElementById("EPTotalDays");
	var Obj=document.getElementById("IPFlag");
	if (Obj) IPFlag=Obj.value;
	var Obj=document.getElementById("EPIPEpisodeRequired");
	if (Obj && IPFlag=="Y") Obj.checked=true;
	if ((EPTotalDaysObj)&&(EPTotalDaysObj.value=="")) {
		var Obj=document.getElementById("EPIPEpisodeRequired");
		if (Obj) Obj.disabled=true;
		var Obj=document.getElementById("CTLOCDesc");
		if (Obj) {Obj.className=""; Obj.style.visibility="hidden";}
		var LabelObj=document.getElementById("cCTLOCDesc");
		if (LabelObj) {LabelObj.className=""; LabelObj.style.visibility="hidden";}
		var ImgObj=document.getElementById("ld2307iCTLOCDesc");
		if (ImgObj) ImgObj.style.visibility="hidden";
		var Obj=document.getElementById("RESDesc");
		if (Obj) Obj.style.visibility="hidden";
		var LabelObj=document.getElementById("cRESDesc");
		if (LabelObj) LabelObj.style.visibility="hidden";
		var ImgObj=document.getElementById("ld2307iRESDesc");
		if (ImgObj) ImgObj.style.visibility="hidden";
		var Obj=document.getElementById("SERDesc");
		if (Obj) Obj.style.visibility="hidden";
		var LabelObj=document.getElementById("cSERDesc");
		if (LabelObj) LabelObj.style.visibility="hidden";
		var ImgObj=document.getElementById("ld2307iSERDesc");
		if (ImgObj) ImgObj.style.visibility="hidden";
		var Obj=document.getElementById("Category");
		if (Obj) Obj.style.visibility="hidden";
		var LabelObj=document.getElementById("cCategory");
		if (LabelObj) LabelObj.style.visibility="hidden";
		var ImgObj=document.getElementById("ld2307iCategory");
		if (ImgObj) ImgObj.style.visibility="hidden";
		var Obj=document.getElementById("SubCategory");
		if (Obj) Obj.style.visibility="hidden";
		var LabelObj=document.getElementById("cSubCategory");
		if (LabelObj) LabelObj.style.visibility="hidden";
		var ImgObj=document.getElementById("ld2307iSubCategory");
		if (ImgObj) ImgObj.style.visibility="hidden";
		var Obj=document.getElementById("Item");
		if (Obj) Obj.style.visibility="hidden";
		var LabelObj=document.getElementById("cItem");
		if (LabelObj) LabelObj.style.visibility="hidden";
		var ImgObj=document.getElementById("ld2307iItem");
		if (ImgObj) ImgObj.style.visibility="hidden";
		var Obj=document.getElementById("Orders");
		if (Obj) Obj.style.visibility="hidden";
		var Obj=document.getElementById("delete1");
		if (Obj) Obj.style.visibility="hidden";
		var Obj=document.getElementById("AddServiceOrders");
		if (Obj) Obj.style.visibility="hidden";
		var tblobj=document.getElementById("CycleCalendar");
		if (tblobj) tblobj.style.display="none";

	}/*
	if ((EPTotalDaysObj)&&(EPTotalDaysObj.value!="")) {
		var LabelObj=document.getElementById("cCTLOCDesc");
		if (LabelObj) LabelObj.className="clsRequired";
	}*/
}

function InitDaySelectHandler(){
	var TotalDays="";
	var DaysObj=document.getElementById("HiddenEPTotalDays");
	if (DaysObj) TotalDays=DaysObj.value;
	if (TotalDays!="") {
		for (i=1;i<=TotalDays ; i++) {
			var DaySelect=document.getElementById(i);
			if (DaySelect) DaySelect.onclick=DaySelectHandler;
		}
	}
}

function DaySelectHandler(){
	var obj=document.getElementById("DAYSRowId");
	if (obj) obj.value="";
}

function ServiceTextChangeHandler() {
}

var DeleteObj=document.getElementById("delete1");
if (DeleteObj) DeleteObj.onclick=DeleteClickHandler;

//var UpdateObj=document.getElementById("update1");
//if (UpdateObj) UpdateObj.onclick=UpdateClickHandler;

var AddServiceOrdersObj=document.getElementById("AddServiceOrders");
if (AddServiceOrdersObj) AddServiceOrdersObj.onclick=AddServiceOrdersClickHandler;

var obj=document.getElementById("CTLOCDesc");
if (obj) obj.onblur=LocationChangeHandler;

var obj=document.getElementById("RESDesc");
if (obj) obj.onblur=ResourceChangeHandler;

var obj=document.getElementById("SERDesc");
if (obj) obj.onblur=ServiceChangeHandler;

var win=window.opener;
