/// UDHCOEOrder.Item.List.js

document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){
	document.onkeydown=Doc_OnKeyDown;
	var obj=document.getElementById("Copy");
	if (obj) obj.onclick=CopyClickHandler;
	var obj=document.getElementById("CopyShort");
	if (obj) obj.onclick=CopyShortClickHandler;
	var obj=document.getElementById("CopyLong");
	if (obj) obj.onclick=CopyLongClickHandler;
	var obj = document.getElementById("CopyONE");
    if (obj) obj.onclick = CopyONEClickHandler;
	var obj=document.getElementById("CopyOut");
	if (obj) obj.onclick=CopyOutClickHandler;
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClickHandler;
	var obj=document.getElementById("PriorID");
	//if (obj){obj.value=""};
	var obj=document.getElementById("Prior1");
	if (obj) obj.onchange=Prior1ChangeHandler;
    var obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAllClickHandler;}
	 
	var obj=document.getElementById("SelectGroupMaster");
	if (obj){obj.onclick=SelectGroupMasterClickHandler;}
	document.onclick=OrderDetails;
	SetTableRowStyle();
	
	var obj=document.getElementById("HistoryAdmList");
    if (obj){obj.onkeydown=HistoryAdmListKeyDown;}
    var obj=document.getElementById("DocUserDep");
    if (obj){obj.onkeydown=DocUserDepKeyDown;}
    var obj=document.getElementById("DocName");
    if (obj){obj.onkeydown=DocNameKeyDown;}	
    //lxz 加入医嘱名称事件
    var obj=document.getElementById("GOrderName");
    if (obj){obj.onkeydown=GOrderName_keyDown;}
	
	InitOrdCopy();
	
}
function Prior1ChangeHandler(e) {
	var Prior1=DHCC_GetElementData("Prior1");
	if (Prior1=="") {
		DHCC_SetElementData("PriorID","");
	}
}
function GOrderName_keyDown(e)
{	
	var key=websys_getKey(e);
	var obj=document.getElementById("GOrderName");
	if (obj.value==""){
		var Obj=document.getElementById("GOrderNameID");
		if (Obj){Obj.value=""}
		}
    if (key==13)
	{
		return GOrderName_lookuphandler();
	}
}
function GOrderName_lookuphandler()
{		
		var url='websys.lookup.csp';
		url += "?ID=GOrderName";
		url += "&CONTEXT=Kweb.UDHCStopOrder:orderlookup";
		url += "&TLUJSF=OrdDesc";
		var obj=document.getElementById('GOrderName');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
}

function DocNameKeyDown(e)
{
	var key=websys_getKey(e);
	var obj=document.getElementById("DocName");
	if (obj.value==""){
		var CTLOCRowId=document.getElementById("DocNameID");
		if (CTLOCRowId){CTLOCRowId.value=""}
		}
    if (key==13)
	{
		return DocName_lookuphandler();
	}
}
function DocName_lookuphandler(e)
{		
		var url='websys.lookup.csp';
		url += "?ID=DocName";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:FindLocDoc";
		url += "&TLUJSF=GetDocName";
		var obj=document.getElementById('CTLOCRowId');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('DocName');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	
}
function DocUserDepKeyDown(e)
{
	var key=websys_getKey(e);
	var obj=document.getElementById("DocUserDep");
	if (obj.value==""){
		var CTLOCRowId=document.getElementById("CTLOCRowId");
		if (CTLOCRowId){CTLOCRowId.value=""}
		var Name=document.getElementById("DocName")
		if (Name) Name.value="";
		var DocNameID=document.getElementById("DocNameID")
		if (DocNameID) DocNameID.value="";
		}
    if (key==13)
	{
		return DocUserDep_lookuphandler();
	}
	
}
function DocUserDep_lookuphandler(e)
{
	    var url='websys.lookup.csp';
		url += "?ID=DocUserDep";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:ctloclookup";
		url += "&TLUJSF=GetDocUserDep";
		var obj=document.getElementById('DocUserDep');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
}
function HistoryAdmListKeyDown(e)
{
	var key=websys_getKey(e);
	var obj=document.getElementById("HistoryAdmList");
	if (obj.value==""){
		var id=document.getElementById("Adm");
		if (id){id.value=""}
		}
	if (key==13)
	{
		return HistoryAdmList_lookuphandler();
	}
}



function HistoryAdmList_lookuphandler() {
		var url='websys.lookup.csp';
		url += "?ID=HistoryAdm";
		url += "&CONTEXT=Kweb.DHCOEOrdItem:HistoryAdm";
		url += "&TLUJSF=HistoryAdm";
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
}


//得到值的方法
function HistoryAdm(str)
{
 var HistoryAdmList=document.getElementById("HistoryAdmList");
 var AdmArry=str.split("^");
 if (str!=""){
 	var id=document.getElementById("Adm");
 	HistoryAdmList.value=AdmArry[1]
 	id.value=AdmArry[0];
 }
  Find_click(); 
}
 		

function Doc_OnKeyDown(e){
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if ((event.altKey)&&(event.keyCode==67))
	{
		SetCopyData(1);	
	}
}
function SetTableRowStyle(){
	try{
		var DCStatusRowId="";
		var obj=document.getElementById("DCStatusRowId");
		if (obj) DCStatusRowId=obj.value;

		var objtbl=document.getElementById("tUDHCOEOrder_Item_List");
		for (var i=1; i<objtbl.rows.length; i++) {
			var Status=GetColumnData("OrderStatusRowid",i)
			var objrow=objtbl.rows[i];
			if (Status==DCStatusRowId) {objrow.className="Discontinue"}
			
			var OrderItemInValid=GetColumnData("OrderItemInValid",i);
			var selobj=document.getElementById('AddItemz'+i);
			if ((selobj)&&(OrderItemInValid=="1")){selobj.disabled=true;}	
		}
	}catch(e){alert(e.message)}
}

function OrderDetails(e){
	var src=websys_getSrcElement(e);
	if (src.tagName == "A") return;

	if (src.id.substring(0,8)=="AddItemz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("AddItemz"+rowsel);
		if (obj) {
			if (obj.checked) {
				var SeqNo=GetColumnData("OrderSeqNo",rowsel)
				var arry1=SeqNo.split(".");
				var MasterSeqNo=arry1[0];
				ChangelLinkItemSelect(MasterSeqNo);
			}
		}
	}
}

function SelectAllClickHandler(e){
 // alert("ss");
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tUDHCOEOrder_Item_List');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('AddItemz'+i); 
	var OrderItemInValid=GetColumnData("OrderItemInValid",i);
	if ((!selobj.disabled)&&(OrderItemInValid!="1"))	selobj.checked=obj.checked;  
  }
}

function ChangelLinkItemSelect(MasterSeqNo){

    try{
		var eTABLE=document.getElementById("tUDHCOEOrder_Item_List");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var SeqNo=GetColumnData("OrderSeqNo",i)
			if (SeqNo=="") continue;
			var arry=SeqNo.split(".");
			var OrderItemInValid=GetColumnData("OrderItemInValid",i)
			if (!(AddItemObj.checked)&&(arry[0]==MasterSeqNo)&&(OrderItemInValid!="1")) {
				SetColumnData("AddItem",i,true)
			}
		}
    }catch(e){alert(e.message)}
}
function LookUpPrioritySelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PriorID");
	if (obj) {obj.value=lu[1];}
}
function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj.tagName=='LABEL'){
		return CellObj.innerText;
	}else{
		if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else{
			return CellObj.value;}
		}
	return "";
}

function SetCopyData(type){
	var Copyary=new Array();
	var IsSelectFlag=false;
	var objshort=document.getElementById("DefShortPriorRowid");
	if (objshort){var DefShortPriorRowid=objshort.value}
	
	var objlong=document.getElementById("DefLongPriorRowid");
	if (objlong){var DefLongPriorRowid=objlong.value}
	
  	var objONE = document.getElementById("DefONEPriorRowid");
  	if (objONE) {var DefONEPriorRowid = objONE.value}
  
  	var objOut = document.getElementById("DefOutPriorRowid");
 	if (objOut) {var DefOutPriorRowid = objOut.value}
 	var Outflag=false;
	var par_win = window.opener;
    try{
		var eTABLE=document.getElementById("tUDHCOEOrder_Item_List");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if (AddItemObj.checked) {
				var IsSelectFlag=true;
				var code=GetColumnData("OrderARCIMRowid",i);
				var OrderType=GetColumnData("OrderType",i);
				//非药品医嘱不允许复制为出院带药医嘱
				if((type==5)&&(OrderType!="R")){
					Outflag=true;
					alert("非药品医嘱不允许复制为出院带药医嘱");
					break;}  //continue;
				var OrderPrior=GetColumnData("OrderPrior",i);
				var OrderPriorRowid=GetColumnData("OrderPriorRowid",i);
				var OrderDoseQty=GetColumnData("OrderDoseQty",i);
				OrderDoseQty=OrderDoseQty.replace(/(^\s*)|(\s*$)/g, '')
				var OrderDoseUOM=GetColumnData("OrderDoseUOM",i);
				var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",i);
				var OrderFreq=GetColumnData("OrderFreq",i);
				var OrderFreqRowid=GetColumnData("OrderFreqRowid",i);
				var OrderFreqFactor=GetColumnData("OrderFreqFactor",i);
				var OrderFreqInterval=GetColumnData("OrderFreqInterval",i);
				var OrderInstr=GetColumnData("OrderInstr",i);
				var OrderInstrRowid=GetColumnData("OrderInstrRowid",i);
				var OrderDur=GetColumnData("OrderDur",i);
				var OrderDurRowid=GetColumnData("OrderDurRowid",i);
				var OrderDurFactor=GetColumnData("OrderDurFactor",i);
				var OrderPackQty=GetColumnData("OrderPackQty",i);
				OrderPackQty=OrderPackQty.replace(/(^\s*)|(\s*$)/g, '')
				//same function as below
				//OrderPackQty=OrderPackQty.replace(/\s/g,'');
				var OrderPackUOM=GetColumnData("OrderPackUOM",i);
				var OrderPackUOMRowid=GetColumnData("OrderPackUOMRowid",i);
				var OrderSeqNo=GetColumnData("OrderSeqNo",i);
 				var OrderBillTypeRowId=GetColumnData("OrderBillTypeRowId",i);
        		if ((type==2)&&(DefShortPriorRowid!="")){
         	 		OrderPrior="";
          			OrderPriorRowid=DefShortPriorRowid
        		}
        		if ((type==3)&&(DefLongPriorRowid!="")){
          			OrderPrior="";
          			OrderPriorRowid=DefLongPriorRowid;
        		}
        		if ((type == 4) && (DefONEPriorRowid != "")) {
          			OrderPrior = "";
          			OrderPriorRowid = DefONEPriorRowid;
        		}
        		if ((type == 5) && (DefOutPriorRowid != "")) {
          			OrderPrior="";
          			OrderPriorRowid = DefOutPriorRowid;
        		}
				
        		var CopyBillTypeFlag=false;
        		var obj=document.getElementById("CopyBillTypeFlag");
        		if (obj){CopyBillTypeFlag=obj.checked;}
        		if (!CopyBillTypeFlag){
        			OrderBillTypeRowId="";
        		}
        		var OrderDepProcNote=GetColumnData("OrderDepProcNote",i);
        		var OrderStage=GetColumnData("OrderStage",i);
        		var OrderStageDesc=GetColumnData("OrderStageDesc",i);
				//和医嘱套界面保持一致。
    			//.s ItemData=ItemDoseQty_$C(1)_ItemDoseUOM_$C(1)_ItemDoseUOMRowid
				//.s ItemData=ItemData_"^"_ItemFreq_$C(1)_ItemFreqRowid_$C(1)_ItemFreqFactor_$C(1)_ItemFreqInterval
				//.s ItemData=ItemData_"^"_ItemInstr_$C(1)_ItemInstrRowid
				//.s ItemData=ItemData_"^"_ItemDur_$C(1)_ItemDurRowid_$C(1)_ItemDurFactor
				//.s ItemData=ItemData_"^"_ItemQty_$C(1)_ItemBillUOM_$C(1)_ItemBillUOMRowid
				//.s ItemData=ItemData_"^"_DHCDocOrderType_$C(1)_DHCDocOrderTypeID_$C(1)_""
				//.s ItemData=ItemData_"^"_ARCOSRowid
				//.s ItemData=ItemData_"^^"_ARCOSSubCatRowid_"^"_ItemRemark_"^"OrderPriorRemarksDR_"^"_ItemSpecCode
			    var ARCOSRowid=""
				var ItemData=code+"!"+OrderSeqNo+"!"+OrderDoseQty+String.fromCharCode(1)+OrderDoseUOM+String.fromCharCode(1)+OrderDoseUOMRowid;
				ItemData=ItemData+"^"+OrderFreq+String.fromCharCode(1)+OrderFreqRowid+String.fromCharCode(1)+OrderFreqFactor+String.fromCharCode(1)+OrderFreqInterval;
				ItemData=ItemData+"^"+OrderInstr+String.fromCharCode(1)+OrderInstrRowid;
				ItemData=ItemData+"^"+OrderDur+String.fromCharCode(1)+OrderDurRowid+String.fromCharCode(1)+OrderDurFactor;
				ItemData=ItemData+"^"+OrderPackQty+String.fromCharCode(1)+OrderPackUOM+String.fromCharCode(1)+OrderPackUOMRowid;
				ItemData=ItemData+"^"+OrderPrior+String.fromCharCode(1)+OrderPriorRowid+String.fromCharCode(1)+"";
				ItemData=ItemData+"^"+"";
				ItemData=ItemData+"^^"+""+"^"+OrderDepProcNote+"^"+""+"^"+"";
				ItemData=ItemData+"^^^^"+OrderStage+String.fromCharCode(1)+OrderStageDesc
				var OrderSpeedFlowRate="";
				var OrderFlowRateUnit=""
				var OrderFlowRateUnitRowId=""
				ItemData=ItemData+"^"+OrderSpeedFlowRate+String.fromCharCode(1)+OrderFlowRateUnit+String.fromCharCode(1)+OrderFlowRateUnitRowId;
				ItemData=ItemData+"!"+OrderType+"!"+OrderBillTypeRowId+"!"+"Order";
				Copyary[Copyary.length]=ItemData;
			}
		}
    }catch(e){alert(e.message)}
	if (!IsSelectFlag) {alert("请选择要复制的医嘱");return;}
    if(Outflag)return;
	if ((par_win)&&(Copyary.length!=0)){
		//alert(ItemData);
		par_win.AddCopyItemToList(Copyary);
	}else{return;}
	window.setTimeout("Copy_click();",500);
}
function CopyClickHandler(){
	SetCopyData(1);
}
function CopyShortClickHandler(){
	SetCopyData(2);
}
function CopyLongClickHandler(){
	SetCopyData(3);
}
function CopyONEClickHandler() {
  SetCopyData(4);
}
function CopyOutClickHandler() {
	SetCopyData(5);
}

function FindClickHandler(){
	//查询时先查询病人就诊列表
	var obj=document.getElementById("Patientno");
	if(obj){
		var Patientno=obj.value;
		if(Patientno==""){alert("病人登记号不能为空");return;}
	}
	var PriorDesc="",PriorRowid="";
	var obj=document.getElementById("Prior1");;
	if(obj){
		PriorDesc=obj.value;
		if (PriorDesc=="") {
		    var obj=document.getElementById("PriorID");
	    	if(obj){obj.value="";}else{PriorRowid=obj.value;}
		}
	}
	var obj=document.getElementById("SttDate");
	if(obj){var SttDate=obj.value;}else{var SttDate="";}
	var obj=document.getElementById("EndDate");
	if(obj){var EndDate=obj.value;}else{var EndDate="";}
	var obj=document.getElementById("CTLOCRowId");
	if(obj){var CTLOCRowId=obj.value;}else{var CTLOCRowId="";}
	var obj1=document.getElementById("DocUserDep");
	if(obj1){
		if(obj1.value=="") {
			obj.value=""
			CTLOCRowId=""
		}
	}
	var obj=document.getElementById("DocNameID");
	if(obj){var DocNameID=obj.value;}else{var DocNameID="";}
	var obj1=document.getElementById("DocName");
	if(obj1){
		if(obj1.value=="") {
			obj.value=""
			DocNameID=""
		}
	}
	var obj=document.getElementById("GOrderNameID");
	if(obj){var GOrderNameID=obj.value;}else{var GOrderNameID="";}
	var Outpatient="N",Inpatient="N";
	var obj=document.getElementById("Outpatient");
	if(obj){if(obj.checked)Outpatient="Y";}
	var obj=document.getElementById("Inpatient");
	if(obj){if(obj.checked)Inpatient="Y";}
	var retAdmstr=tkMakeServerCall("web.DHCDocOrderItemList","GetPAADMIDStr",Patientno,SttDate,EndDate,Outpatient,Inpatient,"",session['LOGON.HOSPID']);
	//alert(retAdmstr);
	SetPAADmList(retAdmstr);
	var obj=document.getElementById("EpisodeID");
	//if(obj){obj.value="";}
	//Find_click();
}
function SetPAADmList(val){
	var selIndex="";
	var EpisodeID=document.getElementById("EpisodeID").value;
	var obj=document.getElementById("PAADmList");
	DHCC_ClearAllList(obj);
	var admArr=val.split("^");
	var FirstAdm="";
	for (var i=0;i<admArr.length;i++){
		var admId=admArr[i]; //.split(String.fromCharCode(2))[0];
		//var admInfo=admArr[i].split(String.fromCharCode(2))[1];
		if (i==0) FirstAdm=admId
		if(EpisodeID==admId){selIndex=obj.length;}
		var admInfo=tkMakeServerCall("web.DHCDocOrderItemList","GetPAADMInfo",admId);
		obj.options[obj.length] = new Option(admInfo,admId);
	}
	//var selIndex=document.getElementById("SelectedIndex").value;
	if(selIndex=="") {
		selIndex=0;
		var obj1=document.getElementById("EpisodeID");
	    if(obj1){obj1.value=FirstAdm;}
	}
	obj.selectedIndex=selIndex;
}
function PAADmListClickHandler(){
	var obj=document.getElementById("PAADmList");//alert(obj.length)
	if(obj.selectedIndex==-1){alert("请选择就诊记录");return;}
	var SelectedIndex=obj.selectedIndex;
	var obj=document.getElementById("SelectedIndex");
	if(obj)obj.value=SelectedIndex;
	//alert(document.getElementById("SelectedIndex").value);
	var PaadmId=document.getElementById("PAADmList").value;
	var obj=document.getElementById("EpisodeID");
	if(obj){obj.value=PaadmId;}	
	Find_click();
	//setTimeout('Find_click();',200);
	//location.reload();
	//FindClickHandler();
}
function InitOrdCopy(){
	var obj=document.getElementById("GroupRowId");
	if (obj) {obj.value=session['LOGON.GROUPID'];}
	var obj=document.getElementById("PAADmList");
	if (obj) {obj.onclick=PAADmListClickHandler;}
	var EpisodeID=document.getElementById("EpisodeID").value;
	if(EpisodeID!=""){
		var PAPMINo=tkMakeServerCall("web.DHCDocOrderItemList","GetPAPMINo",EpisodeID);
		document.getElementById("Patientno").value=PAPMINo;
	}
	FindClickHandler();
	
	var CTLOCID=session['LOGON.CTLOCID'];
	var Pattype=tkMakeServerCall("web.DHCDocOrderItemList","GetPATType",CTLOCID);
	var objshort=document.getElementById("CopyShort");
	var objlong=document.getElementById("CopyLong");
	var objone=document.getElementById("CopyONE");
	var objout=document.getElementById("CopyOut");
	var objprior=document.getElementById("Prior1");;
	var objpriorid=document.getElementById("PriorID");
	var retprior=tkMakeServerCall("web.DHCDocOrderItemList","GetOrderPrior",CTLOCID);
	if(Pattype=="I"){
		if(objshort)objshort.style.display="";
		if(objlong)objlong.style.display="";
		if(objone)objone.style.display="";
		if(objout)objout.style.display="";
		if(objpriorid.value==""){
			var retprior=tkMakeServerCall("web.DHCDocOrderItemList","GetOrderPrior","S");
			if(objprior)objprior.value=retprior.split("^")[1];
			if(objpriorid)objpriorid.value=retprior.split("^")[0];
		}
	}else{
		if(objshort)objshort.style.display="none";
		if(objlong)objlong.style.display="none";
		if(objone)objone.style.display="none";
		if(objout)objout.style.display="none";
		if(objpriorid.value==""){	
			var retprior=tkMakeServerCall("web.DHCDocOrderItemList","GetOrderPrior","NORM");
			if(objprior)objprior.value=retprior.split("^")[1];
			if(objpriorid)objpriorid.value=retprior.split("^")[0];
		}
	}
}
function SelectGroupMasterClickHandler(e){
	var selectrows=0;
	var par_win = window.opener;
  	try{
		var eTABLE=document.getElementById("tUDHCOEOrder_Item_List");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if (AddItemObj.checked) {
				var code=GetColumnData("OrderARCIMRowid",i);
				var OrderName=GetColumnData("OrderName",i);
				var OrderEpisodeID=GetColumnData("OrderEpisodeID",i);
				selectrows=selectrows+1;
		        var ItemData=code+"!"+OrderName;
			}
		}

		if ((selectrows>1)||(selectrows==0)){
			alert("只能选择一条医嘱")
			return;
		}
		var obj=document.getElementById("EpisodeID");
		if (obj){
			if (obj.value!=OrderEpisodeID){
				alert("请选择本次就诊记录下的医嘱");
				return;
			}
		}
  	}catch(e){alert(e.message)}

	if ((par_win)&&(ItemData!="")){
		//alert(ItemData);
		par_win.SetGroupMasterOrder(ItemData);
	}
	window.setTimeout("SelectGroupMaster_click();",500);
}

//科室选择
function GetDocUserDep(str)
{
		var Obj=str.split("^");
		var locdes=document.getElementById("DocUserDep")
		var LOCRowId=document.getElementById("CTLOCRowId")
		locdes.value=Obj[1];
		LOCRowId.value=Obj[0];
		
}

//医嘱选择
function OrdDesc(str)
{ 		var obj=str.split("^");
		var Name=document.getElementById("GOrderName")
		if (Name) Name.value=obj[0];
		var Obj=document.getElementById("GOrderNameID");
		if (Obj){Obj.value=obj[1]};
}

//医生选择
function GetDocName(str)
{ 
		var obj=str.split("^");
		var Name=document.getElementById("DocName")
		Name.value=obj[1];
		var DocNameID=document.getElementById("DocNameID")
		DocNameID.value=obj[0];
		//alert(loc[1]);
}