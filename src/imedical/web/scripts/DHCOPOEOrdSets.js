// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
///DHCOPOEOrdSets.js
///zhaocz   2005-09-26
///Define Interface Parameter;
///OPOrdInsType
///OPOrdInsRowId
///
var strDefaultData="";
var bContainOrderSet=false;
var Qparam1="";
var Qparam2="";
var Qcheckval="";
var AutoAdd=0;

///
session['OPComList']=""
session['OPComList']+="OPOrdItemDesc" + "^";
session['OPComList']+="OPOrdItemRowID" + "^";
session['OPComList']+="OPOrdUnit" + "^";
session['OPComList']+="OPOrdPrice" + "^";
session['OPComList']+="OPOrdQty" + "^";
session['OPComList']+="OPOrdBillSum" + "^";
session['OPComList']+="OPOrdConFac" + "^";
session['OPComList']+="OPOrdDiscPrice" + "^";
session['OPComList']+="OPOrdInsPrice" + "^";
session['OPComList']+="OPOrdPatPrice" +"^";
session['OPComList']+="OPOrdItemRecLoc" +"^";
session['OPComList']+="OPOrdItemRecLocRID" +"^";
session['OPComList']+="OPOrdBillFlag" + "^"
session['OPComList']+="OPOrdARCType" + "^"
session['OPComList']+="OPOrdType" + "^"
session['OPComList']+="OrdRowId" + "^"
session['OPComList']+="OPOrdInsType" + "^"
session['OPComList']+="OPOrdInsRowId" + "^"
session['OPComList']+="OPOrdEnt" + "^"
session['OPComList']+="OPOrdPrescNo" + "^";

//
var aryEName=new Array();
aryEName[0]="OPOrdItemDesc" ;
aryEName[1]="OPOrdItemRowID" ;
aryEName[2]="OPOrdUnit" ;
aryEName[3]="OPOrdPrice" ;
aryEName[4]="OPOrdQty" ;
aryEName[5]="OPOrdBillSum" ;
aryEName[6]="OPOrdConFac" ;
aryEName[7]="OPOrdDiscPrice" ;
aryEName[8]="OPOrdInsPrice" ;
aryEName[9]="OPOrdPatPrice";
aryEName[10]="OPOrdItemRecLoc";
aryEName[11]="OPOrdItemRecLocRID";
aryEName[12]="OPOrdBillFlag";
aryEName[13]="OPOrdARCType";
aryEName[14]="OPOrdType";
aryEName[15]="OrdRowId"
aryEName[16]="OPOrdInsType"
aryEName[17]="OPOrdInsRowId";
aryEName[18]="OPOrdEnt";
aryEName[19]="OPOrdPrescNo";


//Load Handler
function BodyLoadHandler() {
	//if (self==top) websys_reSizeT();
	//if (self==top) reSizeT();
	//alert("doc");
	//document.getElementById("AddItemz").onclick = displayDetails();
	//websys_firstfocus();
	
	document.onkeydown = DHCWeb_EStopSpaceKey;
	var DisabledItemsCount=0;
	var Deselect="";
	var ConfigUnselObj=document.getElementById("OECFDefaultCheckBsUnselect")
	if (ConfigUnselObj) Deselect=ConfigUnselObj.value;
	var OSOrdObj=document.getElementById("OSOrderRowIDs");
	var OSOrderRowIDs=OSOrdObj.value;
	var OSAry="";
	if ((OSOrdObj)&&(OSOrdObj.value!="")) OSAry=OSOrderRowIDs.split("^");
	
	self.focus();
	///document.onclick=OrderDetails;
	document.getElementById("Add").onclick = AddClickHandler;
	///
	var OSItmtbl=document.getElementById("tDHCOPOEOrdSets");
	if (OSItmtbl){
		LabOrderWithoutExternalCode;
		for (var c=1; c<=OSItmtbl.rows.length-1; c++) {
			var DFobj=document.getElementById("DISABLEDz"+c);
			var SCobj=document.getElementById("AddItemz"+c);
			var ItmRowobj=document.getElementById("ItemRowidz"+c);
			var DescObj=document.getElementById("descz"+c);
			if (ItmRowobj&&SCobj) {
				if (LabOrderWithoutExternalCode.split(ItmRowobj.value).length>1) SCobj.disabled=true;
			}
			if (DFobj&&SCobj) {
				if (DFobj.value=="T") {
					////SCobj.disabled=true;
					DisabledItemsCount=DisabledItemsCount+1;
				}
			}
			var RecLocObj=document.getElementById("OPOrdItemRecLocz"+c);
			if (RecLocObj){
				RecLocObj.size=1;
				RecLocObj.multiple=false;
				RecLocObj.style.width=130;
				RecLocObj.style.height=60;
				
				RecLocObj.onchange=OPOrdItemRecLoc_Change;   ////CheckStock;
			}
		}
	}
	////find table
	
	if (Deselect!="Y") SelectAllClickHandler();
	var idsobj=document.getElementById("OSOrderRowIDs");
	if ((idsobj)&&(idsobj.value=="")) {
	}
	var quantitysobj=document.getElementById("OSOrderQuantitys");
	
	var bInsType=DHCWebD_GetObjValue("InsType");
	
	if ((idsobj)&&(quantitysobj)){
		var eTABLE=document.getElementById("tDHCOPOEOrdSets");
		var OrdRowIdString=idsobj.value;
		var OrdQuantityString=quantitysobj.value;
		var OrdRowIdArr=OrdRowIdString.split("^");
		var OrdQuantityArr=OrdQuantityString.split("^");
		var eTABLE=document.getElementById("tDHCOPOEOrdSets");
		var eobj=document.getElementById("EpisodeID");
		if (eobj) EpisodeID=eobj.value;
		for (var i=1; i<eTABLE.rows.length; i++) {
			///zhao  Addtional Data;
			//var arydata=itminfo.split(String.fromCharCode(2));
			var itmrid="";
			var itmobj=document.getElementById("OPOrdItemRowIDz"+i);
			if (itmobj){
				itmrid=itmobj.value;
			}
			var unitobj=document.getElementById("OPOrdUnitz"+i);
			if (unitobj){
				 unitobj.readOnly=true;
			}
			var bOEPrice="";
			var ordtypeobj=document.getElementById("OPOrdTypez"+i);
			var priceobj=document.getElementById("OPOrdPricez"+i);
			if ((priceobj)&&(ordtypeobj)){
				////
				var myordtype=DHCWebD_GetCellValue(ordtypeobj);
				if ((myordtype=="P")){
					AutoAdd=0;
					priceobj.readOnly=false;
					//bOEPrice
				}
				else{
					priceobj.readOnly=true;
				}
			}
			
			///ARCOS ARCIM
			var typobj=document.getElementById("OPOrdARCTypez"+i);
			if (typobj){
				//typobj.value=arydata[7];
			}
			
			var CodeObj=document.getElementById("ItemRowidz"+i);
			var QuantityObj=document.getElementById("OPOrdQtyz"+i);
			var AddItemObj=document.getElementById("AddItemz"+i);
			var RecLocObj=document.getElementById("OPOrdItemRecLocz"+i);
			var encobj=document.getElementById("OPOSOEInfoEncrypt");
			
			var bPackQty=0;
			if (QuantityObj){
				/////alert("QuantityObj:::"+QuantityObj.value);
				bPackQty=DHCWebD_GetCellValue(QuantityObj);
			}
			var myobj=document.getElementById("OPOrdInsRowIdz"+i);
			var myInsRowID="";
			if(myobj){
				myInsRowID = DHCWebD_GetCellValue(myobj);
			}
			
			var bARCType="ARCIM";
			if (encobj) {
				var encmeth=encobj.value;
				var LocRowID=session['LOGON.CTLOCID']   //yyx 按登陆科室取接收科室
				///alert(EpisodeID+bInsType+bOEPrice+bARCType+bPackQty);
				//alert(LocRowID)
				var HospID=session['LOGON.HOSPID']
				//alert(HospID)
				SetARCITMInfo(encmeth,aryEName[10]+"z"+i,EpisodeID,itmrid,"",myInsRowID, bOEPrice, bARCType, bPackQty,i,LocRowID,HospID)
			}
			//
			if ((AddItemObj)&&(AddItemObj.disabled)&&(QuantityObj)) {
				QuantityObj.value="";
				QuantityObj.disabled=true;
			}
			else if ((CodeObj)&&(QuantityObj)) {
				var CodeId=CodeObj.value;
				for (var j=0; j<OrdRowIdArr.length; j++) {
					if (mPiece(OrdRowIdArr[j],"*",0)==CodeId) {
						if (OrdQuantityArr[j]!="") QuantityObj.value=OrdQuantityArr[j];
					}
				}
			}
		}
	}
	var obj=document.getElementById("Add");
	if (obj){
		websys_setfocus(obj);
	}
	///
	if (AutoAdd=="1"){
		AddClickHandler();
	}
	websys_setfocus("Add")
}


function HiddenQuantityChange_changehandler(encmeth) {
	Qcheckval=cspRunServerMethod(encmeth,Qparam1,Qparam2);
}

function getDelim(RepeatTimes) {
	var getDelim="";
	if (!RepeatTimes) RepeatTimes=30;
	for (var k=1; k<RepeatTimes; k++) {
		getDelim=getDelim+String.fromCharCode(1);
	}
	return getDelim;
}
function SelectAllClickHandler(){
	var eTABLE=document.getElementById("tDHCOPOEOrdSets");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var descObj=document.getElementById("desc"+i);
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) AddItemObj.checked=true;
		}
	}
}

function UnSelectAllClickHandler(){
	var eTABLE=document.getElementById("tDHCOPOEOrdSets");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var descObj=document.getElementById("desc"+i);
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) AddItemObj.checked=false;
		}
	}
	
}

function AddClickHandler() {
	bContainOrderSet=false;
	var NeedToCallUpdateOnAddClick=false;
	var NewQuantitys="";
	var OrderSetGroupNumber="";
	
	var par_win = window.opener;
	var DelItems="";
	if(par_win.name!="DHCOPOEOrdInput") {
		par_win=window.open("","DHCOPOEList");
	}
	
	var eTABLE=document.getElementById("tDHCOPOEOrdSets");
	var SInfoFramObj=window;
	var DListFramObj=par_win.parent.frames["DHCOPOEList"];
	if (SInfoFramObj&&DListFramObj){
		///DHCWebD_WrtOSItmList(document,DListFramObj)
		var myOEListStr=BuildOEItemStr();
		
		DHCWebD_WrtOSItmListByStr(myOEListStr,DListFramObj);
	}
	par_win.intdocument();
	window.close();
	
	return;
	
	//window.close();
	//JPD Log 50899 / 52338 
	//var path="oeorder.deleteOSitems.csp?DelItems="+DelItems;
	//websys_createWindow(path,"TRAK_hidden");
	//Add_click();
}

function BuildOEItemStr(){
	
	var myOEListAry=new Array();
	var SInfoTabObj=document.getElementById("tDHCOPOEOrdSets");
	
	var mylen=aryEName.length;
	
	for (var idx=1;idx<SInfoTabObj.rows.length;idx++){
		
		var AddFlagObj=document.getElementById("AddItemz"+idx);
		var AddFlag=DHCWebD_GetCellValue(AddFlagObj);
		
		if (AddFlag){
			var myOEItemAry=new Array();
			for (var i=0;i<mylen;i++){
				var SObj=document.getElementById(aryEN[i]+"z"+idx);
				var SValue=DHCWebD_GetCellValue(SObj);
				var myIndx=myOEItemAry.length;
				myOEItemAry[myIndx]=SValue;
			}
			myOEListAry[myOEListAry.length]=myOEItemAry.join("^");
		}
	}
	
	var mystr=myOEListAry.join(String.fromCharCode(2));
	return mystr;
}

function TransARCOS(){
	
}

function OPOrdItemRecLoc_Change(){
	var rowidx=DHCWeb_GetRowIdx(window);
	
	var RecoptObj=document.getElementById(aryEName[10]+"z"+rowidx);
	var RecRIDObj=document.getElementById(aryEName[11]+"z"+rowidx);
	if (RecoptObj){
		var RecIdx=RecoptObj.selectedIndex;
		RecRIDObj.value=RecoptObj.options[RecIdx].value;
	}
	var rtn=CheckStock(rowidx);
	
	var SelObj=document.getElementById("AddItemz"+rowidx);
	SelObj.checked=rtn;
	if (rtn){
		SelObj.disabled=false;
	}else{
		SelObj.disabled=true;
	}
	
}
function CheckStock(rowidx)
{
	var listobj=document.getElementById(aryEName[14]+"z"+rowidx);
	
	if (listobj){
		var myordtype=DHCWebD_GetCellValue(listobj);
		if (myordtype!="R"){
			return true;
		}
	}else{
		return false;
	}
	
	var listobj=document.getElementById(aryEName[1]+"z"+rowidx);
	if (listobj){
		var arcimrid=DHCWebD_GetCellValue(listobj);
	}
	//alert(listobj.tagName);
	var listobj=document.getElementById(aryEName[4]+"z"+rowidx);
	if (listobj){
		var PackQty=DHCWebD_GetCellValue(listobj);
	}
	var listobj=document.getElementById(aryEName[11]+"z"+rowidx);
	if (listobj){
		var RecLocrid=DHCWebD_GetCellValue(listobj);
	}
	var encmeth=DHCWebD_GetObjValue("OPOrdCheckStockEncrypt");
	try{
		//alert(arcimrid+":"+PackQty+":"+RecLocrid);
		var rtn=cspRunServerMethod(encmeth,arcimrid,PackQty,RecLocrid)
		if (rtn==1){
			//
			return true;
		}else{
			//
			return false;
		}
	}catch(e){
		alert(e.message);
		return false;
	}
}

function SetARCITMInfo(encmeth,ListName,paAdmRowid,acrIMRowid,bPatType,bInsType, bOEPrice, bARCType ,bPackQty,TabIdx,LocRowID,HospID){
	try{
		
		var ItmInfo=cspRunServerMethod(encmeth,paAdmRowid,acrIMRowid,bPatType,bInsType, bOEPrice, bARCType , bPackQty,LocRowID,HospID)
		////alert(ItmInfo+"******"+bPackQty);
		var ListObj=document.getElementById(ListName);
		
		var aryITMInfo=ItmInfo.split("^");
		
		var RecLocStr=aryITMInfo[16];
		var aryRecLoc=RecLocStr.split(String.fromCharCode(1));
		
		if (aryRecLoc!=""){
			var ListIdx=0;
			for (var i=0;i<aryRecLoc.length;i++){
				var arylocstr=aryRecLoc[i].split(String.fromCharCode(2));
				var txtdesc=arylocstr[0];
				var valdesc=arylocstr[1]+String.fromCharCode(2)+arylocstr[2]
				AddToList(ListName,txtdesc,valdesc,ListIdx);
				ListIdx=ListIdx+1;
			}
			StrSetRecLocList(ListName);
		}
		
		var listobj=document.getElementById("AddItemz"+TabIdx);
		if (listobj){
			if ((aryITMInfo[17]==1)){
				listobj.disabled=true;
				////
				if (AutoAdd==1){
					AutoAdd=0;
				}
			}else{
				listobj.checked=true;
			}
		}
		var listobj=document.getElementById(aryEName[2]+"z"+TabIdx);
		if (listobj){
			SetListValue(listobj,aryITMInfo[4]);
		}
		
		var listobj=document.getElementById("OPOrdPricez"+TabIdx);
		if (listobj){
			SetListValue(listobj,aryITMInfo[12]);
		}
		var listobj=document.getElementById("OPOrdDiscPricez"+TabIdx);
		if (listobj){
			SetListValue(listobj,aryITMInfo[13]);
		}
		////alert(listobj);
		var listobj=document.getElementById("OPOrdInsPricez"+TabIdx);
		if (listobj){
			SetListValue(listobj,aryITMInfo[14]);
		}
		var listobj=document.getElementById("OPOrdPatPricez"+TabIdx);
		if (listobj){
			SetListValue(listobj,aryITMInfo[15]);
		}
		
		var listobj=document.getElementById("OPOrdBillSumz"+TabIdx);
		if (listobj){
			SetListValue(listobj,aryITMInfo[18]);
		}

		var RecoptObj=document.getElementById(aryEName[10]+"z"+TabIdx);
		var RecRIDObj=document.getElementById(aryEName[11]+"z"+TabIdx);
		if ((RecoptObj)&&(RecoptObj.length>0)){
			var RecIdx=RecoptObj.selectedIndex;
			RecRIDObj.value=RecoptObj.options[RecIdx].value;
		}
		
	}catch(e){
		alert(e.message);
	}	
}

function StrSetRecLocList(ListName)
{
	var ListObj=document.getElementById(ListName);
	//
	//var txtobj=documnet.getElementById();
	if (ListObj.options.length>0){
		//
		var fnflag=0;
		for (var i=0;i<ListObj.options.length;i++){
			var listvalue=ListObj.options[i].value;
			var aryopt=listvalue.split(String.fromCharCode(2));
			if (aryopt[1]=="1"){
				fnflag=1;
				ListObj.selectedIndex=i;
			}
			///
			ListObj.options[i].value=aryopt[0];
		}
		if (fnflag==0){
			ListObj.selectedIndex=0;
		}
	}
}

function SetRecLocList(encmeth,ListName,paAdmRowid,acrIMRowid,LocRowID)
{
	var ListObj=document.getElementById(ListName);
	alert(LocRowID)
	if (cspRunServerMethod(encmeth,'AddToList',ListName,paAdmRowid,acrIMRowid,LocRowID)=='0') {
	}
	//
	//var txtobj=documnet.getElementById();
	if (ListObj.options.length>0){
		//
		var fnflag=0;
		for (var i=0;i<ListObj.options.length;i++){
			var listvalue=ListObj.options[i].value;
			var aryopt=listvalue.split(String.fromCharCode(2));
			if (aryopt[1]=="1"){
				fnflag=1;
				ListObj.selectedIndex=i;
			}
			///
			ListObj.options[i].value=aryopt[0];
		}
		if (fnflag==0){
			ListObj.selectedIndex=0;
		}
	}
}

function AddToList(ListName,txtdesc,valdesc,ListIdx)	{
	var ListObj=document.getElementById(ListName);
	var aryitmdes=txtdesc		//.split("^");
	var aryitminfo=valdesc		//.split("^");
	if (aryitmdes.length>0)	{
		ListObj.options[ListIdx] = new Option(aryitmdes,aryitminfo);	//,aryval[i]	
	}
}


function KeepPriority() {
	var obj=document.getElementById("OECFKeepPriorDateSession");
	if (obj) {
		if (obj.value=="Y") {
			return true;
		} else {
			return false;
		}
	}
	return false
}

function CollectedFields(DataFields){
	var obj=document.getElementById("ItemDataz"+rowsel)
	if (obj) {
		obj.value=DataFields;
		//alert("objvalue="+obj.value);
	}

}

/*function reSizeT(e) {
	var w=0;var f=this.document.body.all;
	for (var i=0;i<f.length;i++) {
		if (f[i].tagName=="TABLE") if (f[i].offsetWidth>w) w=f[i].offsetWidth;
	}
	if (w>eval(window.screen.Width-window.screenLeft)) w=eval(window.screen.Width-window.screenLeft)-40;
	if (w<282) w=282;
	this.resizeTo(w+30,450);
	}
*/


function BodyUnLoadHandler() {
	//If there is any mandatory field left unfilled, alert the user and delete the order item from the list.
	var par_win = window.opener;
	if (par_win.name=="TRAK_hidden") par_win=window.open('',OrderWindow); //par_win=par_win.top.frames[1];
	//Go to the details page of the next order item
	if ((par_win)&&(par_win.document.fOEOrder_Custom)&&(bContainOrderSet)) par_win.OrderDetailsShowing(par_win.document.fOEOrder_Custom);

}
function OrderDetailsOpen(sItemDesc,sitemdata,sitemvalue,sOSRowid,sOrderTypeCode) {
		//var url = "oeorder.mainloop.csp?ARCIMDesc="+sItemDesc+"&EpisodeID="+document.forms['fOEOrder_Custom'].EpisodeID.value+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&OrderTypeCode"+sOrderTypeCode;
		//Loads default values - if default carry to every item - log 22982
		var PatientID="";
		var pobj=document.getElementById("PatientID");
		if(pobj)
			PatientID=pobj.value;

		if (sitemdata=="") sitemdata=strDefaultData;
		var EpisodeID="";
		var eobj=document.getElementById("EpisodeID");
		if (eobj) EpisodeID=eobj.value;

		//sitemdata=escape(sitemdata);
		var url = "oeorder.mainloop.csp?ARCIMDesc="+sItemDesc+"&EpisodeID="+EpisodeID+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&OrderTypeCode="+sOrderTypeCode+"&PatientID="+PatientID;
		//alert("url="+url);
		//websys_lu(url,false,"width=600,height=500,top=10");
		//window.open(url,"details");
		websys_lu(url,false);
}
function DisplayMessages(desc) {
	//display Order Entry Message against ItemMast
	//desc=desc.substring(5,desc.length);
	var mesObj=document.getElementById("OEMessagez"+rowsel);
	if (mesObj) {
		mes=mesObj.value;

		var smes=mes.split("|");
		mes=smes.join("\n");

		//Please DO NOT comment this alert line out, it's not part of debugging.
		if (mes!="") alert("ORDER ENTRY MESSAGE:"+desc+String.fromCharCode(10)+mes);
	}

	//display quantity ranges against ItemMast
	var rFromObj=document.getElementById("RangeFromz"+rowsel);
	if (rFromObj) RangeFrom=rFromObj.value;
	var rToObj=document.getElementById("RangeToz"+rowsel);
	if (rToObj) RangeTo=rToObj.value;
	var uObj=document.getElementById("UOMz"+rowsel);
	if (uObj) UOM=uObj.value;
	if ((RangeFrom!=null) || (RangeTo!=null)) {
		if ((RangeFrom!="") || (RangeTo!="")) {
			alert("WARNING:  The quantity for this order item is out of range."+String.fromCharCode(10)+"The set quantity range is between "+RangeFrom+" to "+RangeTo+" "+UOM);
		}
	}
}
function getCheckedValue(val) {
//	alert(val);
}
function OpenCheckedItem(src) {
	
	var par_win = window.opener;
	//Log 49059 PeterC 17/02/05: Below code fails becasue par_win is hidden frame, need to set it to the OE screen
	if(par_win.name!="oeorder_entry") {
		par_win=window.open("","oeorder_entry");
	}
	//document.tDHCOPOEOrdSets.target
	if (src.id.substring(0,8)=="AddItemz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("AddItemz"+rowsel);

		if (obj) {
			if (obj.checked) {
				var eTABLE=document.getElementById("tDHCOPOEOrdSets");
				var desc=eTABLE.rows[rowsel].cells[0].innerText;
				desc.substring(5,desc.length);
				var itemRowidObj=document.getElementById("ItemRowidz"+rowsel);
				if (itemRowidObj) itemid=itemRowidObj.value;

				var durObj=document.getElementById("defdurz"+rowsel);
				if (durObj) dur=durObj.value;

				var allergy="";
				var allergyObj=document.getElementById("allergyz"+rowsel);
				if (allergyObj) allergy=allergyObj.value;
				if (allergy=="1")
				{
					var desc="";
					var descObj=document.getElementById("ARCIMDescz"+rowsel);
					if (descObj) desc=descObj.value;
					var choice=confirm("Allergy: "+desc);
					if(choice==false)
					{
						obj.checked=false;
						return;
					}
				}

				if (itemRowidObj) itemid=itemRowidObj.value;
				//Log 49059 PeterC 22/03/05 Commented out the below line to avoid dubling up of OE message 
				//DisplayMessages(desc);
				if (par_win) par_win.DrugInteractionCheck(itemid,desc,dur,"OS");
				var itmCatObj=document.getElementById("itmCatidz"+rowsel);
 				var itmSubCatObj=document.getElementById("itmSubCatidz"+rowsel);
				var itmCatid,itmSubCatid="";
 				//alert("clicking away outside itmcat obj = " + itmCatObj);
 				//var match="notfound";
				if ((itmCatObj)||(itmSubCatObj)) {
					if (itmCatObj)itmCatid=itmCatObj.value;
					if (itmSubCatObj)itmSubCatid=itmSubCatObj.value;
					//alert("itmCatid"+itmCatid);
					//Log 49059 PeterC 22/03/05 Added "itemid" to the below line
					if (par_win.matchCategory(ItemCat,itmCatid,itmSubCatid,itemid)) {
						match="found";
						var par_win = window.opener;
						//Log 49059 PeterC 17/02/05: Below code fails becasue par_win is hidden frame, need to set it to the OE screen
						if(par_win.name!="oeorder_entry") {
							par_win=window.open("","oeorder_entry");
						}

						var setidObj=document.getElementById("SETIDz"+rowsel);
						if (setidObj) setid=setidObj.value;
						var idataObj=document.getElementById("ItemDataz"+rowsel);
						if (idataObj) idata=idataObj.value;
						var iOTCodeObj=document.getElementById("OrderTypeCodez"+rowsel);
						if (iOTCodeObj) iOrderTypeCode=iOTCodeObj.value;
						OrderDetailsOpen(desc,idata,itemid,setid,iOrderTypeCode);
					}
				}
				//if (par_win) par_win.AgeSexRestrictionCheck(itemid,desc,iOrderTypeCode,dur,match,obj);
				//alert(obj.checked);
				//alert("clicking");

			}
		}
	}

}

function SetDefaultData(sDefaultData) {
	strDefaultData=sDefaultData;
	//alert(strDefaultData);
}

function OrderDetails(e){
	//var obj=document.getElementById("AddItemz1");
	//alert(obj.checked);

	var src=websys_getSrcElement(e);
	//alert("details");
	OpenCheckedItem(src);
	//alert(src.tagName);
	if (src.tagName != "A") return;
	//Gets the selected row
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];
	var DataField=document.getElementById("ItemDataz"+rowsel);
	var LinkField=document.getElementById("descz"+rowsel);
	if (src.id.substring(0,5)!="descz") return;
	//Adds ItemData to link expression
	if (DataField) {
		//Replaces ItemData with DefaultData - log 22982
		if (DataField.value=="") {
			LinkField.href = LinkField.href.substring(0,LinkField.href.lastIndexOf("&")) + "&itemdata=" + strDefaultData;
			websys_lu(LinkField.href,false,"width=600,height=500,top=10");
			return false;
		} else {
			LinkField.href = LinkField.href.substring(0,LinkField.href.lastIndexOf("&")) + "&itemdata=" + DataField.value;
			websys_lu(LinkField.href,false,"width=600,height=500,top=10");
			return false;
		}
	}
}

function SetOrdItem(itminfo)
{
	//
	//itminfo:
	//ARCIMastDesc:%String,ARCIMastRowID:%String,ARCSubCat:%String,
	//subcatordtype:%String,phuomdesc:%String,ItemPrice:%Float
	//phFreqCode:%String,ARCType:%String
	var arydata=itminfo.split(String.fromCharCode(2));

	var obj=document.getElementById("OPOrdAdd");
	obj.disabled=false;
	var OrdObj=document.getElementById('OPOrdItemDesc');
	if (OrdObj){
		OrdObj.value=arydata[0];
	}
	var obj=document.getElementById("OPOrdItemRowID");
	if (obj) obj.value=arydata[1];
	var ordobj=document.getElementById("OPOrdType");
	if (ordobj){
		ordobj.value=arydata[3];
	}	
	var unitobj=document.getElementById("OPOrdUnit");
	if (unitobj){
		 unitobj.readOnly=true;
		 unitobj.value=arydata[4];
	}
	//alert(ordobj.value + arydata[4]);
	var priceobj=document.getElementById("OPOrdPrice");
	if (priceobj){
		////&&((arydata[5]!="")&&(parseFloat(arydata[5])!=0))
		if ((arydata[3]=="P")){
			priceobj.readOnly=false;}
		else{
			priceobj.readOnly=true;
		}
		priceobj.value=arydata[5];
	}
	
	var qtyobj=document.getElementById("OPOrdQty");
	if (qtyobj){
		qtyobj.value=1;
	}
	///ARCOS或ARCIM
	var typobj=document.getElementById("OPOrdARCType");
	if (typobj){
		typobj.value=arydata[7];
	}
	//var Resobj=document.getElementById("OPOrdBillSum");
	
	switch (arydata[7]){
		case "ARCIM":
			///
			//
			SetOEInfo();
			//
			//OPRecLocEncrypt
			
			var encobj=document.getElementById("OPRecLocEncrypt");
			if (encobj) {
				var encmeth=encobj.value;
			
				SetRecLocList(encmeth,aryEName[10],"",arydata[1]);
				//
				//OPOrdItemRecLoc_Change();
			}
			break;
		case "ARCOS":
			///
		
			OSItemListOpen(OSRowid,ItemDesc,"YES","",OrdRowIdString);
			
			break;
		default:
		
	}
}

function SetListValue(Tobj,transval){
	switch (Tobj.type)
	{
		case "select-one":
			var myrows=Tobj.options.length;
			Tobj.options[myrows] = new Option(transval,"");	//,aryval[i]	
			break;
		case "checkbox":
			Tobj.checked=Sobj.checked;	//txtobj.checked;
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}

var rowsel=0;
var iOrderTypeCode;
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
var SelAllObj=document.getElementById("SelectAll");
if (SelAllObj) SelAllObj.onclick=SelectAllClickHandler;

var UnSelAllObj=document.getElementById("UnSelectAll");
if (UnSelAllObj) UnSelAllObj.onclick=UnSelectAllClickHandler;

var ItemCat=""; var obj=document.getElementById("GroupItmCat"); if (obj) ItemCat=obj.value;
var SetCat=""; var obj=document.getElementById("GroupSetCat"); if (obj) SetCat=obj.value;bj=document.getElementById("GroupSetCat"); if (obj) SetCat=obj.value;