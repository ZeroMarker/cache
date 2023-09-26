///名称:     医嘱录入组件UDHCOEOrder.List.Custom
///描述:     用于控制医嘱录入的增加删除控制
///编写者  周志强
///编写日期: 2009.02.20
///已用医院: 沈阳医科大;宁医附院;深圳中医院;地坛医院;潍坊人民医院;衢州人民医院,珠海人民医院

var newwidth=270;
var xiniwidth;
var nparams="";
var vparams="";
var tparams="";
var totCount=0;
var k=0;
var hidItemCnt=0;
var Update=true;
var path="";
var lstGroup1;
var lstGroup2;
var lstGroup3;
var lstGroup4;
var lstGroup5;
var lstOrders;
var OSRowidFromitype="";
var itmidsForQuest="";
var alertreason="";
var strDefaultData="";

var Gparam1="";
var Gparam2="";
var Gparam3="";
var Gparam4="";
var Gcheckval=1;
var Gparam5="";
var Gsdcheckval="Y";
var Aparam1="";
var Acheckval="";
var Dparam1="";
var Dcheckval="";
var Nparam1="";
var Nparam2="";
var Nparam3=""; //This param is not for csp method, it is used in showing the order group number 
var Ncheckval="";
var Uparam1="";
var Uparam2="";

//jpd 48368
var IspayorObj=document.getElementById("IsPayorOnPage");
var IsplanObj=document.getElementById("IsPlanOnPage");

var OrderDetailsOpenCount=0;

var cNewOrders="";
var cCat="";
var cDeletedOrderItemIDs="";
var LabOrderWithoutExternalCode="";
var StockInOtherLoc="";

//used for favourites
var currTab="";

var itemdataDelim = String.fromCharCode(4);
var groupitemDelim = String.fromCharCode(28);
var tabgroupDelim = String.fromCharCode(1);

//if in order entry frame (with eprchart) then allow next item in workflow to jump out of orderframes and back to main frame
if (window.name=="oeorder_entry") document.forms['fUDHCOEOrder_List_Custom'].elements['TFRAME'].value=window.parent.name;

var evtTimer;
var evtName;
var doneInit=0;
//var brokerflag=1;  //L48722 - remove brokerflag

var SelectedRow=0;
var FocusRowIndex=0;
var KeyEnterChangeFocus=0;
var OrderPackQtyColumnIndex=2;
var OrderDoseQtyColumnIndex=1;
var OrderPriorColumnIndex=1;
var OrderNameColumnIndex=2;
//保存成功标志
var UpdateFlag=false;
//主医嘱序号串,在增减医嘱时处理
var CheckMasterNoStr="";

//关联医嘱信息,把当前所录入医嘱作为已保存医嘱的子医嘱时使用
var VerifiedOrderMasterRowid="";
var VerifiedOrderMasterSeqNo="";
var VerifiedOrderPriorRowid="";
var VerifiedOrderFreFactor="";
var VerifiedOrderFreDesc1="";
var VerifiedOrderFreRowId="";

var OrderRowAry=new Array();
var ShowInstrLookup=0;
var PHCINDesczLookupGrid;
var ShowFreqLookup=0;
var PHCFRDesczLookupGrid;
var ShowDurLookup=0;
var PHCDUDesczLookupGrid;
//互斥医嘱信息
var ConflictItemsInfo="";
var AuditFlag=""          //12-11-12

var CopyItemProgress=0;
//审查保存医嘱此串可沿用不用每次都循环,节约时间,为页面未保存的医嘱项目Rowid串
var UnSaveARCIMRowidStr="";
var objnewrow="";
function RedrawPrescriptType(tabidx,PrescTypePara,PrescTypeDetailDelim) {
	//if (CurrentPrescTypeTab==tabidx) return;
	var Check=CheckBoreChangePrescriptType(tabidx);
	if (Check==false) return;
	var split_Value=PrescTypePara.split(PrescTypeDetailDelim);
	var PrescItemCats=split_Value[2];
	var PrescBillType=split_Value[3];
	var PrescLimitSum=split_Value[4];
	var PrescLimitCount=split_Value[5];
	//dhcsys_alert(PrescTypePara);
	SetPrescItemCats(PrescItemCats);
	SetPrescBillTypeID(PrescBillType);
	SetPrescLimitSum(PrescLimitSum);
	SetPrescLimitCount(PrescLimitCount);
	var obj=document.getElementById("PrescTypeTAB"+CurrPrescTypeTab);
	if (obj) obj.className="PrescTypeTab";
	var obj=document.getElementById("PrescTypeTAB"+tabidx);
	if (obj) obj.className="selectedPrescTypeTab";
	CurrPrescTypeTab=tabidx;
}

function CheckBoreChangePrescriptType(tabidx) {
	return true;
	var NewRows=HaveNewOrder()
	if ((NewRows>0)&&(CurrPrescTypeTab!=tabidx)) {
		var DelCheck=dhcsys_confirm((t['NO_SAVE']),false);
    if (DelCheck==false) {return false;}
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');

		for (var i=0; i<NewRows; i++){
			var rows=objtbl.rows.length;
			for (var j=1; j<rows; j++){
				var Row=GetRow(j);
				var OrderName=GetColumnData("OrderName",Row);
				var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
				var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){DeleteTabRow(objtbl,j);}
			}
		}
	  SetScreenSum()
	}
	return true;
}

function HaveNewOrder(){
	var NewRows=0;
  try{
  	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderName=GetColumnData("OrderName",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){NewRows=NewRows+1;}
		}
		if (NewRows>0) return NewRows;
	}catch(e){
		dhcsys_alert(e.message);
	}
	return 0;
}


function CheckPrescItemAndCount(ItemDesc,ArcimRowid,ARCIMDetail){
	var  BillGrpDesc=mPiece(ARCIMDetail,"^",0);
	var  FormDesc=mPiece(ARCIMDetail,"^",1);
	var PHPoisonCode=mPiece(ARCIMDetail,"^",2);
	var OrderGenericName=mPiece(ARCIMDetail,"^",3);
	var LimitDetail=mPiece(ARCIMDetail,"^",4);

	var  PrescCheck=CheckItemBillClass(ArcimRowid);
	if (PrescCheck==false){
		var PrescCheck=dhcsys_confirm((ItemDesc+t['SELFPAY_ALERT']),true);
		if (PrescCheck==false){
       		return false;
		}
	}

	var  PrescCheck=CheckItemPoison(ItemDesc,PHPoisonCode);
	if (PrescCheck==false){
		return false;
	}
	var PrescCheck=CheckPrescriptType(BillGrpDesc);
	if (PrescCheck==false){
		dhcsys_alert(ItemDesc+t['Diff_PrescType']);
		return false;
	}
	
	var PrescCheck=CheckPrescriptForm(FormDesc);
	if (PrescCheck==false){
		dhcsys_alert(ItemDesc+t['Diff_Form']);
		return false;
	}
	var PrescCheck=CheckPrescriptCount(BillGrpDesc);
	if (PrescCheck==false){
		dhcsys_alert(ItemDesc+t['EXCEED_PRESCCOUNT']);
		return false;
	}

	var PrescCheck=CheckPrescriptPoisonCount(PHPoisonCode);
	if (PrescCheck==false){
		dhcsys_alert(ItemDesc+t['EXCEED_PRESCPoisonCOUNT']);
		return false;
	}
		
	var PrescCheck=CheckPrescriptItem(ArcimRowid);
	if (PrescCheck==false){
		dhcsys_alert(ItemDesc+t['LIMIT_PRESCITEM']);
        return false;
	}
	/*
	var  PrescCheck=CheckPrescDupOrderItem(ArcimRowid);
	if (PrescCheck==true){
		dhcsys_alert(ItemDesc+t['SAME_PrescORDERITEM']);
    return false;
	}
	*/
	var PrescCheck=CheckPrescSameGenericNameItem(OrderGenericName);
	if (PrescCheck==true){
		dhcsys_alert(ItemDesc+t['SAME_PrescGenericNameORDERITEM']);
    return false;
	}
		
	var  PrescCheck=CheckDupOrderItem(ArcimRowid);
	if (PrescCheck==true){
		//如果是有一天最大量设置的医嘱不允许在同一处方中出现两条
		var OrderMaxDoseQtyPerDay=mPiece(LimitDetail,String.fromCharCode(1),5);
		if ((OrderMaxDoseQtyPerDay!="")&&(OrderMaxDoseQtyPerDay!=0)){
			dhcsys_alert(ItemDesc+t['NOT_ALLOW_SAME_ORDERITEM']);
			return false;
		}else{
			var PrescCheck=dhcsys_confirm((ItemDesc+t['SAME_ORDERITEM']),true);
			if (PrescCheck==false)return PrescCheck;
		}
		/*
		var PrescCheck=dhcsys_confirm((ItemDesc+t['SAME_ORDERITEM']),true);
    return PrescCheck;
    */
	}
	var  ItemDiagnosCheck=CheckItemDiagnos(ArcimRowid);
	if (ItemDiagnosCheck==false){
		dhcsys_alert(ItemDesc+t['LIMIT_DIAGNOSE']);
		return false;
	}
	
	return true;
}

function CheckPrescriptType(PHPrescType){
	return true;
	if (PAAdmType=="I") {return true}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		if ((i!=FocusRowIndex)&&(OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
			//dhcsys_alert(OrderItemRowid+"^"+OrderARCIMRowid+"^"+OrderType+"^"+PHPrescType+"^"+OrderPHPrescType);
		  if (OrderPHPrescType!=PHPrescType) {
					return false;
			}
		}
	}
	return true;	
}

function CheckPrescriptForm(FormDesc){
	if (PAAdmType=="I") {return true}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")&&(OrderPHPrescType=="3")){
			var OrderPHForm=GetColumnData("OrderPHForm",Row);
			//dhcsys_alert(OrderItemRowid+"^"+OrderARCIMRowid+"^"+OrderType+"^"+FormDesc+"^"+OrderPHForm);
			if ((i!=FocusRowIndex)&&(FormDesc!=OrderPHForm)&&((OrderPHForm==t['CNMedForm'])||(FormDesc==t['CNMedForm']))) {
					return false;
			}
		}
	}	
	return true;
}

function CheckPrescriptCount(PHPrescType){
	if (PAAdmType=="I") {return true}
	//如果按用法分方就只能在保存时判断因为在录入过程中有可能改变用法
	if (PrescByInstr==1){return true}
	if (PrescByAuto==1){return true}
	var PrescBillTypeRowid=GetPrescBillTypeID();
	var PrescCount=0;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		if (HospitalCode!="SZZYY"){
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")&&(OrderPHPrescType==PHPrescType)&&(OrderBillTypeRowid==PrescBillTypeRowid)){
				if (HospitalCode!="JST"){
					if (OrderMasterSeqNo==""){PrescCount=PrescCount+1;}
				}else{
					PrescCount=PrescCount+1;
				}
			}
		}else{
		  if ((OrderItemRowid=="")&&(Trim(OrderMasterSeqNo)=="")&&(OrderARCIMRowid!="")&&(OrderType=="R")){
				PrescCount=PrescCount+1;
		  }
		}
	}	

	//var PrescLimitCount=GetPrescLimitCount();
	PrescLimitCount=0;
	if (PHPrescType=="1") PrescLimitCount=5;
	if (PHPrescType=="2") {
		if (HospitalCode!="JST"){
			PrescLimitCount=5;
		}else{
			if (BillTypeDesc.substring(0,2)!=t['BillType_GF']){PrescLimitCount=5;}else{PrescLimitCount=3;}
		}
	}
	//dhcsys_alert("PHPrescType:"+PHPrescType+"  PrescLimitCount:"+PrescLimitCount+"   PrescCount:"+PrescCount);
	if ((PrescLimitCount!=0)&&(PrescLimitCount!="")&&(PrescLimitCount!=null)){
		if (PrescLimitCount<=PrescCount){return false;}
	}	
	return true;
}

///一张处方抗生素的数目判断
function CheckPrescriptPoisonCount(PHPoisonCode){
	if (PAAdmType=="I") {return true}
  if (PHPoisonCode!="KSS") {return true}
	var PrescBillTypeRowid=GetPrescBillTypeID();
	var PrescCount=0;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderPoisonCode=GetColumnData("OrderPoisonCode",Row);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")&&(OrderPoisonCode==PHPoisonCode)&&(OrderBillTypeRowid==PrescBillTypeRowid)){
			PrescCount=PrescCount+1;
		}
	}	
	//dhcsys_alert(PrescCount);
	PrescLimitCount=3;
	if (PrescLimitCount<=PrescCount){return false;}
	return true;
}

function CheckPrescriptItem(ArcimRowid){
	if (PAAdmType=="I") {return true}
	var PrescItemCats="";
  var objPrescItemCats=document.getElementById("PrescItemCats");
	if ((objPrescItemCats)&&(objPrescItemCats.value!="")) PrescItemCats=objPrescItemCats.value;
        //dhcsys_alert("PrescItemCats:"+PrescItemCats+"ArcimRowid:"+ArcimRowid);
	if (PrescItemCats!="") {
		var GetARCItemSubCatID=document.getElementById('GetARCItemSubCatID');
		if (GetARCItemSubCatID) {
			var encmeth=GetARCItemSubCatID.value;
			//dhcsys_alert("encmeth:"+encmeth);
			var SubCatID=cspRunServerMethod(encmeth,'','',ArcimRowid)
			//dhcsys_alert("SubCatID="+SubCatID);
			if (SubCatID!=""){
				SubCatID="^"+SubCatID+"^";
				PrescItemCats="^"+PrescItemCats+"^";
				if (PrescItemCats.indexOf(SubCatID)==-1) {return false;}
			}
		}
	}
	return true;
}
function CheckPrescDupOrderItem(ARCIMRowid){
	if (PAAdmType=="I") {return false}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			if ((ARCIMRowid==OrderARCIMRowid)&&(i!=FocusRowIndex)) return true;
		}
	}	
	return false;
}
function CheckPrescSameGenericNameItem(GenericName){
	if (GenericName=="") return false;
	if (CFOPNotRepeatGenericName!=1) return false;
	if (PAAdmType=="I") return false;
	var limitNum=2,count=0;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderGenericName=GetColumnData("OrderGenericName",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			if ((GenericName==OrderGenericName)&&(i!=FocusRowIndex)) count=count+1;
		}
		if (count>=2) return true;
	}	
	return false;
}
function CheckDupOrderItemCat(ItemCatRowId){
	//查找是否有不允许重复录入的相同子类医嘱
	if ((PAAdmType=="O")&&(OPUnRepeatItemCat!=="")) {
		var SubCatID="^"+ItemCatRowId+"^";
		var OPUnRepeatItemCats="^"+OPUnRepeatItemCat+"^";
		if (OPUnRepeatItemCats.indexOf(SubCatID)>-1) {
	
			var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
			var rows=objtbl.rows.length;
			var FocusRow=GetRow(FocusRowIndex);
			for (var i=1; i<rows; i++){
				var Row=GetRow(i);
				var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
				var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
				var OrderType=GetColumnData("OrderType",Row);
				var OrderName=GetColumnData("OrderName",Row);
				var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
				var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType!="R")){
					if ((OrderItemCatRowid==ItemCatRowId)&&(i!=FocusRowIndex)) {
						//dhcsys_alert(t['ItemCatRepeat']+OrderName);
						return true;
					}
				}
			}
			if (FindSameOrderItemCatMethod!="") {
				var obj=document.getElementById('EpisodeID');
		    var PAADMRowid=obj.value;
		    //dhcsys_alert("PAADMRowid"+PAADMRowid+"ARCIMRowid:"+ARCIMRowid);
				var retDetail=cspRunServerMethod(FindSameOrderItemCatMethod,PAADMRowid, ItemCatRowId);
			  if (retDetail==1) return true;
			}
			return false;			
		}
	}	
}
function CheckDupOrderItem(ARCIMRowid){
	//if ((PAAdmType=="I")||(PAAdmType=="E")) {return false}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	var FocusRow=GetRow(FocusRowIndex);
	var StartDate=GetColumnData("OrderStartDate",FocusRow);
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderStartDate=GetColumnData("OrderStartDate",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			if ((ARCIMRowid==OrderARCIMRowid)&&(i!=FocusRowIndex)&&(OrderStartDate==StartDate)) return true;
		}
	}	

	var CheckSameOrderItem=document.getElementById('FindSameOrderItem');
	if (CheckSameOrderItem) {
		var encmeth=CheckSameOrderItem.value;
		var obj=document.getElementById('EpisodeID');
    var PAADMRowid=obj.value;
    //dhcsys_alert("PAADMRowid"+PAADMRowid+"ARCIMRowid:"+ARCIMRowid);
		var retDetail=cspRunServerMethod(encmeth,PAADMRowid, ARCIMRowid);
	  if (retDetail==1) return true;
	}
	return false;
}

function CheckDateDupOrderItem(CurrentRow,ARCIMRowid,StartDate){
	if ((PAAdmType=="I")||(PAAdmType=="E")) {return false}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderStartDate=GetColumnData("OrderStartDate",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			if ((ARCIMRowid==OrderARCIMRowid)&&(i!=CurrentRow)&&(OrderStartDate==StartDate)) return true;
		}
	}	
	return false;
}

function GetDefaultLabSpec(LabSpecStr){
	 var DefaultSpecRowid="";
 	 var DefaultSpecDesc="";
   var ArrData=LabSpecStr.split(String.fromCharCode(2));
   for (var i=0;i<ArrData.length;i++) {
   	 var ArrData1=ArrData[i].split(String.fromCharCode(3));
   	 if (ArrData1[4]=="Y") {
   	 	 var DefaultSpecRowid=ArrData1[0];
   	 	 var DefaultSpecDesc=ArrData1[1];
   	 }
   }
   return DefaultSpecRowid
}

function CheckDupLabSpecItem(LabExCode,LabSpecStr){
	var OrderLabExCodeStr="";
	var OrderRowStr="";
	
	var LabSpecRowid=GetDefaultLabSpec(LabSpecStr);
	var FocusRow=GetRow(FocusRowIndex);
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderLabExCode=GetColumnData("OrderLabExCode",Row);
		var OrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row);
		var OrderName=GetColumnData("OrderName",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(i!=FocusRow)&&(OrderLabExCode!="")&&(OrderLabSpecRowid==LabSpecRowid)){
			if (OrderLabExCodeStr==""){
				OrderLabExCodeStr=OrderLabExCode;
				OrderRowStr=Row;
			}else{
				OrderLabExCodeStr=OrderLabExCodeStr+"^"+OrderLabExCode;
				OrderRowStr=OrderRowStr+"^"+Row;
			}
		}
	}	

	if ((CheckRepeatLabSpecMethod!="")&&(OrderLabExCodeStr!="")&&(CFNotCheckSameSpecItem!=1)){
		var ret=cspRunServerMethod(CheckRepeatLabSpecMethod,OrderLabExCodeStr,LabExCode);
		var retArr=ret.split("^");
		if (retArr[0]==1){
			/*
			var i=eval(retArr[1])-1;
			var RowArr=OrderRowStr.split("^");
			var Row=RowArr[i];
			var OrderName=GetColumnData("OrderName",Row);
			dhcsys_alert(t['SameLabSpecItem']+":"+OrderName);
			*/
			//dhcsys_alert(t['SameLabSpecItem']);
			//return true;
			if (HospitalCode=="HF"){
				dhcsys_alert(t['SameLabSpecItem']);
				return true;
			}

			var PrescCheck=dhcsys_confirm(t['SameLabSpecItem'],true);
			if (PrescCheck==false){return true;}else{return false}

		}
	}
	return false;
}

function CheckItemInsurLimit(iinsurinfo){
	var TempPlist=iinsurinfo.split(String.fromCharCode(1));
	var InsurAdmFlag=TempPlist[0];
	var DiagnosCatArcimPass=TempPlist[1];
	var PreOrderDate=TempPlist[2];
	var IsADMInsTypeDCArcim=TempPlist[3];
	if ((InsurAdmFlag=="1")&&(PAAdmType=="I")){
		dhcsys_alert(t['InsurLimitOP']);
		return true;
	}
	if ((InsurAdmFlag=="2")&&(PAAdmType=="I")){
		dhcsys_alert(t['InsurLimit']);
		return true;
	}
	if ((DiagnosCatArcimPass=="0")&&(PAAdmType!="I")){
		dhcsys_alert(t['DiagnosCatArcimAllow']);
		return false;
	}	

	if ((PreOrderDate!="")&&(PAAdmType=="O")){
		dhcsys_alert(PreOrderDate+t['InPreOrderDuration']);
		if (HospitalCode=="HF") return false;
	}
	
	if (IsADMInsTypeDCArcim=="1"){
		dhcsys_alert(t['IsADMInsTypeDCArcim']);
		return false;
	}
	return true;
}

function CheckItemAllergy(iallergy){
	//有过敏记录阳性的药物强制不能开也不合适有时阳性了还需再做皮试希望提示但不强制限制
	var TempPlist=iallergy.split(String.fromCharCode(1));
	var allergycode=TempPlist[0];
	var allergymsg=TempPlist[1];
	if (allergycode=="01"){
  	var ret=dhcsys_confirm(t['Have_Allergy'],true);
    if (ret==false){return false;}
		//dhcsys_alert(t['Have_Allergy']);
		//return false;
	}
	return true;
}

function CheckItemPoison(ItemDesc,PHPoisonCode){
		var IDCardNo="";
		var encmeth="";
		var obj=document.getElementById('PatientID');
		if (obj) PatientID=obj.value;
		var obj=document.getElementById("GetIDCardNo");
	    if (obj) encmeth=obj.value;
	    if (encmeth!=""){
			var IDCardNo=cspRunServerMethod(encmeth,PatientID);
	    }
		//开毒麻药品判断身份证号是否存在，若不存在，输入保存
	  if ((PHPoisonCode=='J2')||(PHPoisonCode=='J1')||(PHPoisonCode=='DX')||(PHPoisonCode=='MZ')){
			if(IDCardNo==''){
				var myRet=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCDoc.Patient&PatientID="+PatientID,"","dialogwidth:40;dialogheight:30;status:no;center:1;resizable:yes");
			    if ((myRet=="")||(myRet=="undefined")||(myRet==null)) return false;}
			    dhcsys_alert(ItemDesc+t['POISON_ALERT'])
			    return true;
		}
	  if ((PHPoisonCode=='DBTHZJ')||(PHPoisonCode=='TLJS')){
			   dhcsys_alert(ItemDesc+t['POISON_SPORT_ALERT'])
			   return true;
		}
	return true;
}

function CheckItemBillClass(ARCIMRowid){
	  if (PAAdmType=="I") {return true}
    if (BillTypeDesc!=t['BillType_ZF']){
		var obj=document.getElementById("PrescTypeTAB"+CurrPrescTypeTab);
		if (obj) {
				PrescDesc=obj.innerHTML;
	    	if ((PrescDesc==t['BillType_ZF'])&&(GetARCIMBillClassMethod!="")){
					var BillClass=cspRunServerMethod(GetARCIMBillClassMethod,ARCIMRowid);
					if ((BillClass=='1')||(BillClass=='2')){
						return false;
					}
				}
			}
    }
    return true;
}


function CheckItemInDuration(ARCIMRowid){
	if (PAAdmType=="I") {return true}
	var obj=document.getElementById('EpisodeID');
    var PAADMRowid=obj.value;
    if (CheckItemInDurationMethod!=""){
		var BillTypeID=GetPrescBillTypeID();
		var retDetail=cspRunServerMethod(CheckItemInDurationMethod,PAADMRowid, BillTypeID,ARCIMRowid);
        return retDetail;
    }
}
function CheckDiagnosLimitDur(CurDurFactor){
	if (PAAdmType=="I") {return true}
	if (GetDiagnosLimitDurMethod!=''){
		var objmradm=document.getElementById("mradm");
		if ((objmradm)&&(objmradm.value!="")) mradmid=objmradm.value;
		var PatType=GetPatType();
		var MaxDurFactor=cspRunServerMethod(GetDiagnosLimitDurMethod,PatType,mradmid);
		if (MaxDurFactor!=0) {
			if (parseFloat(CurDurFactor) > parseFloat(MaxDurFactor)) return false;
		}
		return true;
	}
	 
	 return true;
}

function CheckItemDiagnos(ARCIMRowid){
	if (PAAdmType=="I") {return true}
	var CheckItemDiagnos=document.getElementById('CheckItemDiagnos');
	if (CheckItemDiagnos) {
		var encmeth=CheckItemDiagnos.value;
		//dhcsys_alert("encmeth:"+encmeth);
                if (encmeth!=''){
			var objmradm=document.getElementById("mradm");
			if ((objmradm)&&(objmradm.value!="")) mradmid=objmradm.value;
			var PatType=GetPatType();
	                //dhcsys_alert("PatType:"+PatType+"   ARCIMRowid:"+ARCIMRowid+"  mradmid"+mradmid);
			var retDetail=cspRunServerMethod(encmeth,PatType, ARCIMRowid,mradmid);
		        if (retDetail==1) return false;
		        return true;
	        }
	 }
	 return true;
}

function CheckMRDiagnose(){
	if (PAAdmType=="I") {return true}
  var obj_mradm=document.getElementById("mradm");
	if ((obj_mradm)&&(obj_mradm.value!="")) mradmid=obj_mradm.value;
	if (mradmid=="") return false;
	var GetMRDiagnoseCount=document.getElementById('GetMRDiagnoseCount');
	if (GetMRDiagnoseCount) {
		var encmeth=GetMRDiagnoseCount.value;
		var MRDiagnoseCount=cspRunServerMethod(encmeth,mradmid)
		if (MRDiagnoseCount>0) return true;
	}
	return false;
}

function CheckDurationPackQty(Row) {
	//判断医嘱整数量的限定值
  var OrderName=GetColumnData("OrderName",Row);
  var OrderMaxQty=GetColumnData("OrderMaxQty",Row);
	var OrderPackQty=GetColumnData("OrderPackQty",Row);

  if ((OrderMaxQty>0)&&(parseFloat(OrderPackQty)>parseFloat(OrderMaxQty))) {
    dhcsys_alert(OrderName+t['MedMaxQty']+OrderMaxQty);
    return false;
  }
  
	var OrderType=GetColumnData("OrderType",Row);
  
  if (OrderType!="R") return true;
	if (PAAdmType!="O") return true;

	var OrderMaxDurFactor=GetColumnData("OrderMaxDurFactor",Row);
  if (OrderMaxDurFactor==0) {return true;}
	
	var Interval=GetColumnData("OrderFreqInterval",Row);
	if ((Interval!="") && (Interval!=null)) {
		var convert=Number(OrderMaxDurFactor)/Number(Interval)
		var fact=(Number(OrderMaxDurFactor))%(Number(Interval));
		if (fact>0) {fact=1;} else {fact=0;}
		OrderMaxDurFactor=Math.floor(convert)+fact;
	}

  var freq=GetColumnData("OrderFreqFactor",Row);
	var OrderConFac=GetColumnData("OrderConFac",Row);
  var OrderBaseQty=GetColumnData("OrderBaseQty",Row); 
	if (OrderBaseQty=="") OrderBaseQty=1;

	var CheckdurDoseQtySum = parseFloat(OrderBaseQty) * parseFloat(freq) * parseFloat(OrderMaxDurFactor);
	var CheckPackQty=CheckdurDoseQtySum/parseFloat(OrderConFac);
	CheckPackQty=CheckPackQty.toFixed(4);
	CheckPackQty=Math.ceil(CheckPackQty);
  if (OrderPackQty>CheckPackQty){
    dhcsys_alert(OrderName+t['ExceedDurationQty']);
    return false;
  }
	return true;
}

function GetPrice(OrderType,ItemRowid){
	var GetOrderPrice=document.getElementById('GetOrderPrice');
	if (GetOrderPrice) {
		var encmeth=GetOrderPrice.value;
		//dhcsys_alert("encmeth:"+encmeth);
		var PatType="";
		var InsType=GetPrescBillTypeID();
		var SttDate="";
		var PriorRowid="";
		var InstrRowid="";
		var LinkTo="";
		var OEPrice="";

		var retPrice=cspRunServerMethod(encmeth,'','',PatType, InsType, OrderType,ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice);
	        //dhcsys_alert(retPrice);
	        var Price=mPiece(retPrice,"^",0);
	        var DiscPrice=mPiece(retPrice,"^",1);
	        var InsPrice=mPiece(retPrice,"^",2);
	        var PatPrice=mPiece(retPrice,"^",3);
	        //dhcsys_alert("Price:"+retPrice);
	        return retPrice;

	 }
	 return "0^0^0^0"
}
function GetOrderItemDetail(OEORIRowid){
	var GetOrderPrice=document.getElementById('GetOrderItemDetail');
	if (GetOrderPrice) {
		var encmeth=GetOrderPrice.value;
		//dhcsys_alert("encmeth:"+encmeth);
		var PatType="";
		var InsType=GetPrescBillTypeID();

		var retDetail=cspRunServerMethod(encmeth,PatType, InsType, OEORIRowid);
	        //dhcsys_alert(retDetail);
	        return retDetail;
	 }
	 return "0^0^0^0^0^0^0^0^1^1";
}

function CheckPrescriptSum(AddSum,Arcim){
	
	var ScreenBillSum=GetScreenBillSum();
	if ((PAAdmType=="I")||(GetStayStatusFlag==1)){
		var amount=parseFloat(ScreenBillSum)+parseFloat(AddSum);
		var ret=CheckDeposit(amount,Arcim);
		return ret;

	}else{
		//PrescLimitSum已经做为本日费用总和的控制而非单处方的?
		/*
		var PrescLimitSum=GetPrescLimitSum();
	  if (PrescLimitSum==0) return true;
	 	if ((eval(ScreenBillSum)+eval(AddSum))>eval(PrescLimitSum)){
			dhcsys_alert(t['EXCEED_PRESCAMOUNT']+PrescLimitSum);
			return false;
		}
		*/
	}
	return true;
}

//for card bill
//卡消费
function CardBillClick(){
	var groupDR=session['LOGON.GROUPID'];
	var mode=tkMakeServerCall("web.udhcOPBillIF","GetCheckOutMode",groupDR);
    if(mode==1){
    	//checkOut(cardNO,episodeID,insType,oeoriIDStr,guser,groupDR,locDR,hospDR)
    	var cardNO="";
    	var insType=GetPrescBillTypeID();;
    	var oeoriIDStr="";
    	var guser=session['LOGON.USERID'];
    	var groupDR=session['LOGON.GROUPID'];
    	var locDR=session['LOGON.CTLOCID'];
    	var hospDR=session['LOGON.HOSPID'];
    	var obj=document.getElementById("PatientID");
		var PatientID=obj.value
		var obj=document.getElementById("EpisodeID");
		var EpisodeID=obj.value;
		
    	var rtn=checkOut(cardNO,PatientID,EpisodeID,insType,oeoriIDStr,guser,groupDR,locDR,hospDR)
    	return;	
    }
	
	var obj=document.getElementById("CardBillCardTypeValue");
	if (obj){
		var CardTypeValue=obj.value;
		var temparr=CardTypeValue.split("^");
		var CardTypeRowId=temparr[0];
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardTypeValue);
	}else{
		var myrtn=DHCACC_GetAccInfo();
	}
	myrtn=myrtn.toString()
	var myary=myrtn.split("^");
	var rtn=myary[0];
	var rtnPatientID=myary[4];
	var obj=document.getElementById("EpisodeID");
	var EpisodeID=obj.value;
	var obj=document.getElementById("PatientID");
	var PatientID=obj.value

	if (EpisodeID=="") return;
	switch (rtn){
		case "0":
				if (PatientID!=rtnPatientID){
					dhcsys_alert(t['Diff_Patient']);
					return;
				}		  
			//var lnk="udhcopbillif.csp?PatientIDNo="+myary[5]+"&CardNo="+myary[1];
		    //dhcsys_alert(EpisodeID+"^"+PatientID+"^"+myary[1]);
        	var lnk="udhcopbillforadmif.csp?CardNo="+myary[1]+"&SelectAdmRowId="+EpisodeID+"&SelectPatRowId="+PatientID;
        	var NewWin=open(lnk,"udhcopbillif","scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");
		break;
		case "-200":
			dhcsys_alert(t["InvaildCard"]);
			return;
			break;
		case "-201":
			dhcsys_alert(t["AccountNotExist"]);
			return;
			///var obj=document.getElementById("PatientID");
			///obj.value=myary[5];
			///ReadPatInfo();
			break;
		default:
	}
}

function transINVStr(myINVStr)
{
}

function SetScreenSum(){
	var amount=0;

	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		//自备药不进行金额计算
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
		if ((OrderPriorRowid==OMOrderPriorRowid)||(OrderPriorRemarks=="OM")) continue;
		var OrderItemSum=GetColumnData("OrderSum",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderPackQty=GetColumnData("OrderPackQty",Row);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			amount=amount+parseFloat(OrderItemSum);
		}
	}	
  /*
	if (amount==0){
			var OrderItemSum=document.getElementById("OrderItemSum");
			if (OrderItemSum)	{OrderItemSum.value=0;}
	}
  */
	amount=amount.toFixed(2);
	var ToBillSum=GetToBillSum();
	var TotalToBillSum=parseFloat(ToBillSum)+parseFloat(amount);
	TotalToBillSum=TotalToBillSum.toFixed(2);
	SetTotalToBillSum(TotalToBillSum);
	//dhcsys_alert("ToBillSum:"+ToBillSum+"amount:"+amount+"TotalToBillSum:"+TotalToBillSum);
	var obj_ScreenBillSum=document.getElementById('ScreenBillSum');
	if (obj_ScreenBillSum) {obj_ScreenBillSum.value=amount;}
	CheckAccInfo(TotalToBillSum);
}
function CheckDeposit(amount,arcim){
	if (PAAdmType!="I") {return true}
	if (CheckIPDepositMethod!=""){
		var retDetail=cspRunServerMethod(CheckIPDepositMethod,EpisodeID,amount,"OE");
		if (retDetail!=0) {
			var retArray=retDetail.split("^");
			if (retArray[4]=='C'){
				if (retArray[5]=='N'){
					dhcsys_alert(t['ExceedDeposit']+retArray[0]);
					return false;
				}else{
					if (arcim!=""){
						var retDetail=cspRunServerMethod(CheckDepositOrderMethod,retArray[2],arcim);
						if (retDetail==0){
							dhcsys_alert(t['ExceedDeposit']+retArray[0]);
							return false;
						}
					}
				}
			}
		}		
	}
	return true;
}

function CheckBillTypeSum(Amount){
	if ((PAAdmType!="O")||(Amount==0)) {return true}	
	//只有在门诊时才存在PrescBillType TAB页
	var OrderBillTypeRowid=GetPrescBillTypeID();
	var PrescLimitSum=GetPrescLimitSum();
	if (CheckBillTypeSumMethod!=""){
		var retDetail=cspRunServerMethod(CheckBillTypeSumMethod,EpisodeID,OrderBillTypeRowid,PrescLimitSum,Amount);
		if (retDetail==1) {return false}
	}
	return true
}
///出院带药根据费别的病人费用限制
function CheckOutOrderSum(Amount){
	if ((PAAdmType!="I")||(Amount==0)) {return true}	
	//只有在门诊时才存在PrescBillType TAB页
	var OrderBillTypeRowid=GetPrescBillTypeID();
	var PrescLimitSum=GetPrescLimitSum();
	if (CheckOutOrderSumMethod!=""){
		var retDetail=cspRunServerMethod(CheckOutOrderSumMethod,EpisodeID,OrderBillTypeRowid,Amount);
		if (retDetail==1) {return false}
	}
	return true
}
///出院带药根据病人的费别其他限制
function CheckOutOrderOtherContral(OrderName,OrderBillTypeRowid,DurRowid,ItemCatRowid,ARCIMRowidStr,ArcimId,FreqRowid,qtyPackUom,DoseQty,unitUomId){
	if (PAAdmType!="I") {return true}	
	if (CheckOutOrderOtherMethod!=""){
		var retDetail=cspRunServerMethod(CheckOutOrderOtherMethod,EpisodeID,OrderBillTypeRowid,DurRowid,ItemCatRowid,ARCIMRowidStr,ArcimId,FreqRowid,qtyPackUom,DoseQty,unitUomId);
		var TempArr=retDetail.split("^");
		if (TempArr[0]==1) {
			dhcsys_alert(TempArr[1]);
			return false;
		}
	}
	//判断是否有相同出院带药,仅提示
	if (FindSameOutOrderItemMethod!="") {
		var ret=cspRunServerMethod(FindSameOutOrderItemMethod,EpisodeID,ArcimId,ARCIMRowidStr);
		if (ret==1) {
			if (!dhcsys_confirm(OrderName+",存在相同的出院带药医嘱,是否继续?")) return false;
		}
	}
	return true
}
/////Add by zhaocz
function CheckAccInfo(TotalToBillSum){
	if ((HospitalCode!="HF")&&(HospitalCode!="FJXMXL")) return;
	if (PAAdmType=="I"){
		var obj=document.getElementById("Deposit");
		if (obj){
			var Deposit=parseFloat(obj.value);
			var LeftDeposit=parseFloat(obj.value)-parseFloat(TotalToBillSum);
			var obj=document.getElementById("AccLeftTip");
			if (obj){
				if (LeftDeposit>0){
					obj.className='clsvalid';
				}else{
					obj.className='clsInvalid';
				}
				obj.value=LeftDeposit;
			}
		}
	}else{
		var obj=document.getElementById("PatientID");
		if (obj){
			var myPAPMI=obj.value;
			var myrtn=GetAccLeftByPAPMI(myPAPMI,TotalToBillSum);
			var myary=myrtn.split("^");
		
			var obj=document.getElementById("AccLeftTip");
			if (obj){
				if (myary[0]=="0"){
					obj.className='clsvalid';
				}else{
					obj.className='clsInvalid';
				}
				obj.value=myary[1];
			}
		}
	}
}
function GetScreenBillSum() {
	var obj_ScreenBillSum=document.getElementById('ScreenBillSum');
	if (obj_ScreenBillSum) {
		var ScreenBillSum=obj_ScreenBillSum.value;
		if (ScreenBillSum=="") {return 0;} else {return ScreenBillSum;}
	} else {return 0;}
}

function SetPrescBillTypeID(BillTypeRowid) {
	//dhcsys_alert("BillTypeID:"+BillTypeRowid);
	var obj_PrescBillTypeID=document.getElementById('PrescBillTypeID');
	obj_PrescBillTypeID.value=BillTypeRowid;
	if (obj_PrescBillTypeID) {obj_PrescBillTypeID.value=BillTypeRowid;}
}
function GetPrescBillTypeID() {
	var obj_PrescBillTypeID=document.getElementById('PrescBillTypeID');
	if (obj_PrescBillTypeID) {return obj_PrescBillTypeID.value;}else {return "";}
}
function SetPrescItemCats(ItemCat) {
        //dhcsys_alert("ItemCat:"+ItemCat)
	var obj_PrescItemCat=document.getElementById('PrescItemCats');
	if (obj_PrescItemCat) {obj_PrescItemCat.value=ItemCat;}
}
function GetPrescItemCats() {
	var obj_PrescItemCat=document.getElementById('PrescItemCats');
	if (obj_PrescItemCat) {
		return obj_PrescItemCat.value;}
	else {return "";}
}
function SetPrescLimitSum(LimitSum) {
	//dhcsys_alert("ItemCat:"+LimitSum)
        if (LimitSum=='') LimitSum=0;
	var obj_PrescLimitSum=document.getElementById('PrescLimitSum');
	if (obj_PrescLimitSum) {obj_PrescLimitSum.value=LimitSum;}
}
function GetPrescLimitSum() {
	var obj_PrescLimitSum=document.getElementById('PrescLimitSum');
	if (obj_PrescLimitSum) {return obj_PrescLimitSum.value;}else {return "";}
}

function SetPrescLimitCount(LimitCount) {
        //dhcsys_alert("ItemCat:"+LimitCount)
	var obj_PrescLimitCount=document.getElementById('PrescLimitCount');
	if (obj_PrescLimitCount) {obj_PrescLimitCount.value=LimitCount;}
}
function GetPrescLimitCount() {
	var obj_PrescLimitCount=document.getElementById('PrescLimitCount');
	if (obj_PrescLimitCount) {return obj_PrescLimitCount.value;}else {return "";}
}
function SetToBillSum(ToBillSum) {
        //dhcsys_alert("ToBillSum:"+ToBillSum);
	var obj_ToBillSum=document.getElementById('ToBillSum');
	if (obj_ToBillSum) {obj_ToBillSum.value=ToBillSum;}
}
function GetToBillSum() {
	var obj_ToBillSum=document.getElementById('ToBillSum');
	if (obj_ToBillSum) {return obj_ToBillSum.value;}else {return "0";}
}
function SetTotalToBillSum(TotalToBillSum) {
        //dhcsys_alert("ToBillSum:"+TotalToBillSum);
	var obj_TotalToBillSum=document.getElementById('TotalToBillSum');
	if (obj_TotalToBillSum) {obj_TotalToBillSum.value=TotalToBillSum;}
}
function GetTotalToBillSum() {
	var obj_TotalToBillSum=document.getElementById('TotalToBillSum');
	if (obj_TotalToBillSum) {return obj_TotalToBillSum.value;}else {return "0";}
}

function SetMRDiagnoseCount() {
	var MRDiagnoseCount=0;
	var obj_mradm=document.getElementById("mradm");
	if ((obj_mradm)&&(obj_mradm.value!="")) var mradmid=obj_mradm.value;
	var GetMRDiagnoseCount=document.getElementById('GetMRDiagnoseCount');
	if ((GetMRDiagnoseCount)&&(mradmid!='')) {
		var encmeth=GetMRDiagnoseCount.value;
		//dhcsys_alert("encmeth:"+encmeth);
		MRDiagnoseCount=cspRunServerMethod(encmeth,mradmid);
	}
	var obj_MRDiagnoseCount=document.getElementById('MRDiagnoseCount');
	if (obj_MRDiagnoseCount) {
		obj_MRDiagnoseCount.value=MRDiagnoseCount;
	}
	//dhcsys_alert(MRDiagnoseCount);
}

function GetMRDiagnoseCount() {
	var obj_MRDiagnoseCount=document.getElementById('MRDiagnoseCount');
	if (obj_MRDiagnoseCount) {return obj_MRDiagnoseCount.value;}else {return 0;}
}

function SetPatType(PatTypeID) {
        //dhcsys_alert("PatTypeID:"+PatTypeID);
	var obj_PatType=document.getElementById('PatTypeID');
	if (obj_PatType) {obj_PatType.value=PatTypeID;}
}

function GetPatType() {
	var obj_PatType=document.getElementById('PatTypeID');
	if (obj_PatType) {return obj_PatType.value;}else {return '';}
}
function SetPCSPatType(PCSPatTypeID) {
        //dhcsys_alert("PCSPatTypeID:"+PCSPatTypeID);
	var obj_PatType=document.getElementById('PCSPatTypeID');
	if (obj_PatType) {obj_PatType.value=PCSPatTypeID;}
}

function GetPCSPatType() {
	var obj_PatType=document.getElementById('PCSPatTypeID');
	if (obj_PatType) {return obj_PatType.value;}else {return '';}
}
function SetPCSLoc(PCSLocIDs) {
        //dhcsys_alert("PCSLoc:"+PCSLoc);
	var obj_PCSLoc=document.getElementById('PCSLocIDs');
	if (obj_PCSLoc) {obj_PCSLoc.value=PCSLocIDs;}
}

function GetPCSLoc() {
	var obj_PCSLoc=document.getElementById('PCSLocIDs');
	if (obj_PCSLoc) {return obj_PCSLoc.value;}else {return '';}
}

function CheckPCSEpisode(){

	var PatTypeID=GetPatType();
	var PCSPatTypeID=GetPCSPatType();
	var PCSLocIDs=GetPCSLoc();
	if ((PCSPatTypeID=="")&&(PCSLocIDs="")) return false;
	if (PatTypeID==PCSPatTypeID) {
		var CurrenLoc=session['LOGON.CTLOCID'];
		var Pos=PCSLocIDs.indexOf(CurrenLoc);
		if (Pos>0) return true;
	}
	return false;
}


function CheckDiagnose(ordertype){
	//dhcsys_alert(PAAdmType)
	if ((PAAdmType=="I")&&(IPOrderPhamacyWithDiagnos!="1")) {return true;}
	if (OrderPhamacyWithDiagnos!="1"){return true;}
	var MRDiagnoseCount=GetMRDiagnoseCount();
	var NeedDiagnosFlag=1;
	var obj=document.getElementById('NeedDiagnosFlag');
	if (obj){NeedDiagnosFlag=obj.value}
	if ((MRDiagnoseCount==0)&&(ordertype=="R")&&( NeedDiagnosFlag==1)) {
		if ((t['NO_DIAGNOSE'])&&(t['NO_DIAGNOSE']!="")) {
		dhcsys_alert(t['NO_DIAGNOSE']);}
		return false;
	}
	return true;
}

var obj=document.getElementById('FavOrderSets');
if (obj) obj.onclick=FavOrderSetsclickhandler;

function FavOrderSetsclickhandler(){
	var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCFavOrderSets.List&UserID="+session['LOGON.USERID'];
	websys_lu(url,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
}
function FavOrderSetsConfigclickhandler(){
	var url="UDHCFavItem.Edit.csp";
	window.open(url);
}

var obj=document.getElementById('FavOrderSetsConfig');
if (obj) obj.onclick=FavOrderSetsConfigclickhandler;

function CheckConflict(ARCIMRowid){
	  var ConflictItems=cspRunServerMethod(GetConflictMethod,ARCIMRowid);
    if (ConflictItems!="") {
			var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
			var rows=objtbl.rows.length;
			for (var i=1; i<rows; i++){
				var Row=GetRow(i)
				var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
				var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
				var OrderName=GetColumnData("OrderName",Row);
				//不需要对当前行再做判断
				var TempConflictItems="^"+ConflictItems+"^";
				var TempOrderARCIMRowid="^"+OrderARCIMRowid+"^";
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(FocusRowIndex!=i)){
					if (TempConflictItems.indexOf(TempOrderARCIMRowid)!=-1) {
						dhcsys_alert(t['ItemConflict']+OrderName);
						return false;
					}
				}
			}	
    }
    var obj=document.getElementById('EpisodeID');
		if (obj) var EpisodeID =obj.value;

    if (CheckConflictMethod){
	    var ret=cspRunServerMethod(CheckConflictMethod,EpisodeID,ARCIMRowid);
	    var CheckConflict=mPiece(ret,"^",0)
	    var ConflictItemDesc=mPiece(ret,"^",1)
	    if (CheckConflict=="Y")  {
	    	dhcsys_alert(t['ItemConflict']+ConflictItemDesc+t['ItemConflictAutoStop']+ConflictItemDesc);
	    }
  	}
  	
		return true;	
}

function GetConflictItemsInfo(ARCIMRowid){
    var obj=document.getElementById('EpisodeID');
		if (obj) var EpisodeID =obj.value;

    if (CheckConflictMethod){
	    var ret=cspRunServerMethod(CheckConflictMethod,EpisodeID,ARCIMRowid);
	    var CheckConflict=mPiece(ret,"^",0)
	    var ConflictItemDesc=mPiece(ret,"^",1)
	    if (CheckConflict=="Y")  {
	    	//dhcsys_alert(t['ItemConflict']+ConflictItemDesc+t['ItemConflictAutoStop']+ConflictItemDesc);
	    	//return false;
	    	if (ConflictItemsInfo==""){
	    		ConflictItemsInfo=ConflictItemDesc;
	    	}else{
	    		ConflictItemsInfo=ConflictItemsInfo+"  "+ConflictItemDesc;
	    	}
	    }
  	}
		return true;	
}

function CheckConflictItemCat(ItemCatRowId){


}

function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

//////////////////////////////////////////////////////////////////////////////////////////
function InitDHCC(){
	var obj_ScreenBillSum=document.getElementById('ScreenBillSum');
	if (obj_ScreenBillSum) {obj_ScreenBillSum.value="0.00";}
	
	//yjy
	if (HospitalCode=="BJZYY"){
		var docbtnobj=document.getElementById('Docbtn');
		var MRDiagnos=document.getElementById('AddMRDiagnos');
		if (session['LOGON.GROUPID']!='249'){
			if (MRDiagnos) MRDiagnos.style.visibility="hidden";
			if (docbtnobj) docbtnobj.style.visibility="hidden";
		}else{
			if (docbtnobj){docbtnobj.onclick=changedoc;}
			if (MRDiagnos){MRDiagnos.onclick=InsertMRDiagnos;}
		}
	}
	
	var obj=document.getElementById('Find');
	if (obj) {obj.onclick=FindClickHandler;}
	var obj=document.getElementById('Query');
	if (obj) {obj.onclick=QueryClickHandler;}
	try {
		websys_sckeys['D']=DeleteClickHandler;
		//websys_sckeys['D']=""
	} catch(e) {};

	try {
		websys_sckeys['A']=AddClickHandler;
	} catch(e) {};

	try {
		websys_sckeys['U']=UpdateClickHandler;
	} catch(e) {};	
	try {
		//websys_sckeys['D']=DeleteClickHandler;
		websys_sckeys['F']=FindClickHandler;
	} catch(e) {};
	
	//医嘱相关说明
	var PatientOrderFile1=document.getElementById("PatientOrderFile1");
	var PatientOrderFile2=document.getElementById("PatientOrderFile2");
	var PatientOrderFile3=document.getElementById("PatientOrderFile3");
	if (PatientOrderFile1){PatientOrderFile1.onclick=OpenWindow1;}
	if (PatientOrderFile2){PatientOrderFile2.onclick=OpenWindow2;}
	if (PatientOrderFile3){PatientOrderFile3.onclick=OpenWindow3;}
	////////////////////////
	AddListToDT();
	var obj=document.getElementById("XHZY");
	if (obj) obj.onclick=XHZY_Click;
	var obj=document.getElementById("YDTS");
	if (obj) obj.onclick=YDTS_Click;
 	var obj=document.getElementById("ExitDT");
	if (obj) obj.onclick=ExitDT_Click;
	var obj=document.getElementById("DTBtn");
	if (obj) obj.onclick=DTBtn_Click;  
	var obj=document.getElementById("HKXD");
	if (obj) obj.onclick=HKXD_Click;  
	var obj=document.getElementById("DTBegin");
	if (obj) obj.onclick=DTBegin_Click;
	//打印导诊单 
	var obj=document.getElementById("BtnPrtGuidPat");
	//if (obj) obj.onclick=BtnPrtGuidPat_Click;
	//补打
	var obj=document.getElementById("BtnRePrtGuidPat");
	if (obj) obj.onclick=BtnRePrtGuidPat_Click;

	if (EnableButton==0) {
		DisableUpdateButton(1);
		DisableAddButton(1);
		DisableDeleteButton(1);
	}

	var obj=document.getElementById("Deposit");
	if (obj){obj.value=CurrentDeposit}
	if ((PAAdmType!="I")&&(obj)){
		obj.style.visibility="hidden";
		var obj=document.getElementById("cDeposit");
		if (obj){obj.style.visibility="hidden";}
	}
	
	if ((DHCDTInterface==1)) CreateBEGIN();
	/////////////////////////////
	var objtbl=document.getElementById("tUDHCOEOrder_List_Custom");
	if (objtbl){
		var rows=objtbl.rows.length;
		var Row=rows-1;
		var objlastrow=objtbl.rows[Row];
    	GetTableSequence(objlastrow);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		//dhcsys_alert(OrderItemRowid+"^"+OrderARCIMRowid);
		if ((OrderItemRowid=="")&&(OrderARCIMRowid=="")){
			ChangeRowStyle(objlastrow,1,true);
			SetColumnData("OrderPrior",Row,DefaultOrderPriorRowid);
			SetColumnData("OrderPriorRowid",Row,DefaultOrderPriorRowid);
			SetColumnData("OrderSeqNo",Row,Row);
			var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
			var CurrDateTimeArr=CurrDateTime.split("^");
			SetColumnData("OrderStartDate",Row,CurrDateTimeArr[0]);
			SetColumnData("OrderStartTime",Row,CurrDateTimeArr[1]);
			SetColumnData("OrderDate",Row,CurrDateTimeArr[0]);
			SetColumnData("OrderTime",Row,CurrDateTimeArr[1]);
			if (PAAdmType=="I") {
				if (HospitalCode!="ZGYKDFSYY") SetColumnData("OrderCoverMainIns",Row,true);
			}
			SetFocusColumn("OrderName",Row);
			FocusRowIndex=1;
		}
	}
	
	if (FocusRowIndex!=1){websys_setfocus('Add')};
	
	var obj=document.getElementById("FindByLogDep");
	if ((obj)&&(FindRecLocByLogonLoc=="1")){obj.checked=true;}
	
	if (StoreUnSaveData=="1"){
		AddUnsaveDataToList();
		//var FieldName="UserUnSaveData"+EpisodeID;
		//var UserUnSaveData=cspRunServerMethod(GetSessionDataMethod,FieldName)
		//dhcsys_alert(PAAdmType+","+EpisodeID+","+session['LOGON.USERID'])
		//var UserUnSaveData=tkMakeServerCall("web.DHCDocUserUnSaveOrder","GetUserUnSaveData",PAAdmType,EpisodeID,session['LOGON.USERID']);
		//dhcsys_alert(UserUnSaveData)
		//if (UserUnSaveData!=""){AddUnsaveDataToList(UserUnSaveData);}
	}
	
	var obj=document.getElementById("PinNumber");
	if (obj){obj.onkeydown=PinNumberKeyDownHandler}
		
	obj=document.getElementById('EQASInfo');
	if (obj){obj.onclick=EQASInfoClickHandler;}
	
	var obj=document.getElementById("BeforceBalance");
	if (obj){obj.onclick=BeforceBalanceHandler}

	obj=document.getElementById('BtnViewArcInfo');
	if (obj){obj.onclick=BtnViewArcInfoHandler;}
	
	obj=document.getElementById('BtnViewArcPriceInfo');
	if (obj){obj.onclick=BtnViewArcPriceInfoHandler;}
	
	var obj=document.getElementById("BtnPrtGuidPat");
	if (obj){obj.onclick=BtnPrtGuidPatHandler;}
	
	var obj=document.getElementById("RowUp");
	if (obj) obj.onclick=RowUp_Click; 
	var obj=document.getElementById("RowDown");
	if (obj) obj.onclick=RowDown_Click;

	/* update by zf 2012-05-14
	var obj=document.getElementById('ShowPathWayItem');
	if (obj) {
		obj.onclick=ShowPathWayItem;
		if (InUseCPWRowId=='') {
			obj.disabled=true;
			obj.onclick='';
		}
	}
	*/
	
	var obj=document.getElementById("LnkLabPage");
	if (obj) obj.onclick=LnkLabPage_Click;
	
	var obj=document.getElementById("SetSaveForUser");
	if (obj) obj.onclick=SetSaveForUserClickHandler;

	var obj=document.getElementById("OEPrefLoc");
	if (obj)obj.onclick=OEPrefClickHandler;
	var obj=document.getElementById("OEPrefUser");
	if (obj) obj.onclick=OEPrefClickHandler;
	var obj=document.getElementById("OEPrefHosp");
	if (obj) obj.onclick=OEPrefClickHandler;
	
	if(IsExistUserPrefFlag=="0"){ 
			var obj=document.getElementById("OEPrefUser");
		  if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;COLOR: yellow;BACKGROUND-COLOR: #336699;BORDER: 2px outset #336699;FONT-WEIGHT: bold;cursor: hand;";
	  	
	}else {
		 var obj=document.getElementById("OEPrefLoc");
		  if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;COLOR: yellow;BACKGROUND-COLOR: #336699;BORDER: 2px outset #336699;FONT-WEIGHT: bold;cursor: hand;";
	}
	
	obj=document.getElementById('BtnViewArcItemInfo');
	if (obj){obj.onclick=BtnViewArcItemInfoHandler;}
	obj=document.getElementById('BtnViewAuditAntibio')
	if(obj){obj.onclick=BtnShowViewAnditAnti;}
	var obj=document.getElementById('DeleteMulti');
 	if(obj)  {obj.onclick=DeleteMultiClickHandler;}
	var obj=document.getElementById('SynBtn'); 
  	if(obj) {obj.onclick=SynBtnClickHandler;}
	//lxz 保存为医嘱套
	var obj=document.getElementById("SaveToArcos");
	if (obj) obj.onclick=SaveToArcos_Click;
	//一键打印按钮
	var obj=document.getElementById("BtnPrtClick");
	if (obj){obj.onclick=BtnPrtClickHandler;}
	//处方预览
	var obj=document.getElementById("PresView");
	if (obj){obj.onclick=PresView_Click;}
	
	
    
}

//一键打印按钮功能添加；2014-11-17
function BtnPrtClickHandler(){
	var obj=document.getElementById('PatientID');
	if (obj) var PatientID=obj.value;
	var obj=document.getElementById('mradm');
	if (obj) var MRADMID=obj.value;
	var EpisodeID=document.getElementById("EpisodeID").value;
	var userid=session['LOGON.USERID'];
	var ctlocid=session['LOGON.CTLOCID'];
	var PrtClick=new PrtClickInfo(EpisodeID,PatientID,MRADMID,ctlocid,userid)
}
function BtnShowViewAnditAnti(){
	//dhcsys_alert(12)
	var EpisodeID=document.getElementById("EpisodeID").value;
	var userid=session['LOGON.USERID'];
	//dhcsys_alert(23)
	var AuditAnti=new AuditInfo(EpisodeID,userid)
	}
/* update by zf 2012-05-14
function ShowPathWayItem(){
	var EpisodeID=document.getElementById('EpisodeID').value;
	var PatientID=document.getElementById('PatientID').value;
	var MRAdm=document.getElementById('mradm').value;
	var StepItemIDS=window.showModalDialog("dhccpw.mr.formshow.csp?EpisodeID=" + EpisodeID +"&OEOrderFlag=1&NEOrderFlag=1&NewPage=1"
		,""
		,"dialogHeight: "+top.screen.height+"px; dialogWidth: "+top.screen.width+"px");
	if ((AddMRCPWItemToListMethod!='')&&(StepItemIDS!='')) {
		var ret=cspRunServerMethod(AddMRCPWItemToListMethod,'AddCopyItemToList','',StepItemIDS);
	}
}
*/

//update by zf 2012-05-14
function addOEORIByCPW(StepItemIDS){
	//dhcsys_alert(StepItemIDS);
	if ((AddMRCPWItemToListMethod!='')&&(StepItemIDS!='')) {
		var ret=cspRunServerMethod(AddMRCPWItemToListMethod,'AddCopyItemToList','',StepItemIDS);
	}
}


function EQASInfoClickHandler(){
	var Row=GetRow(FocusRowIndex);
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
	//dhcsys_alert(OrderARCIMRowid+"^"+OrderRecDepRowid);
	var ARCIMEQResRowId=cspRunServerMethod(GetARCIMEQResMethod,OrderARCIMRowid,OrderRecDepRowid);
	if (ARCIMEQResRowId!=""){
		var posn="height="+(screen.availHeight-40)+",width="+(screen.availWidth-10)+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes"
		var path="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBApptSchedule.SingleEQ.List&ResRowId="+ARCIMEQResRowId+"&ResType=Equipment";
		//dhcsys_alert("path="+path);
		websys_createWindow(path,false,posn);
	}
}
function PinNumberKeyDownHandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		if ((keycode==13)||(keycode==9)){
			var obj1=document.getElementById("PinNumber");
			
			var obj=document.getElementById("Update");	
		  if ((obj)&&(obj1.value!="")){
				websys_setfocus("Update");
				return websys_cancel();
			}
		}
	}catch(e) {}
}

function testclick(e){
	try{
		var obj=new ActiveXObject("CardReader.CLSIDCard");
		var PatInfo=obj.ReadInfo();
		if (PatInfo!=-1){
		}
	}catch(e){
		dhcsys_alert(e.message);
	}
}

function GetTableSequence(rowobj){

		var rowitems=rowobj.all;
		if (!rowitems) rowitems=rowobj.getElementsByTagName("LABEL");
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				var Columnid=arrId[0];
				if (Columnid=="OrderPackQty"){
					OrderPackQtyColumnIndex=j;
				}
				if (Columnid=="OrderDoseQty"){
					OrderDoseQtyColumnIndex=j;
				}
				if (Columnid=="OrderPrior"){
					OrderPriorColumnIndex=j;
				}				
				if (Columnid=="OrderName"){
					OrderNameColumnIndex=j;
				}				}
		}
		//dhcsys_alert(OrderPackQtyColumnIndex+"^"+OrderDoseQtyColumnIndex+"^"+OrderPriorColumnIndex+"^"+OrderNameColumnIndex);
}

//医嘱相关说明1
function OpenWindow1() {
	if (FocusRowIndex==0) return;
	var Row=GetRow(FocusRowIndex);
	var url=GetColumnData("OrderFile1",Row);
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;
	
	if (url!="") {
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile1', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}else{
		dhcsys_alert(t['NoPatientOrderFile']);
	}
	return false;
}

//医嘱相关说明2
function OpenWindow2() {
	if (FocusRowIndex==0) return;
	var Row=GetRow(FocusRowIndex);
	var url=GetColumnData("OrderFile2",Row);
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;
	
	if (url!="") {
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile2', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}else{
		dhcsys_alert(t['NoPatientOrderFile']);
	}
	return false;
}

//医嘱相关说明3
function OpenWindow3() {
	if (FocusRowIndex==0) return;
	var Row=GetRow(FocusRowIndex);
	var url=GetColumnData("OrderFile3",Row);
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;
	
	if (url!="") {
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile3', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}else{
		dhcsys_alert(t['NoPatientOrderFile']);
	}
	return false;
}

function FindClickHandler(e){
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID")
	if (objEpisodeID) {
		EpisodeID=objEpisodeID.value;
		var sttdate="";
		var enddate="";
		var prior="";
		if (PAAdmType=="I"){
			var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
		  var CurrDateTimeArr=CurrDateTime.split("^");
		  sttdate=CurrDateTimeArr[0];
		  enddate=CurrDateTimeArr[0];
		}
		if (HospitalCode!='ZJQZRMYY'){
			var posn="height="+(screen.availHeight-40)+",width="+(screen.availWidth-10)+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
		}else{
			var posn="height="+(screen.availHeight-340)+",width="+(screen.availWidth-180)+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
		}
		//var posn='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=0,left=0,top=30,left=20,width=1000,height=500';

		var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.Item.List&EpisodeID="+EpisodeID+"&SttDate="+sttdate+"&EndDate="+enddate+"&PriorID="+prior;
		//dhcsys_alert("path="+path);
		websys_createWindow(path,false,posn);
		//return websys_cancel();
	}

}
function QueryClickHandler(e){
	  var Days=15;
		if (HospitalCode=="HF"){Days=5}
		var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.Query.Item&EpisodeID="+EpisodeID+"&Days="+Days;
		//dhcsys_alert("path="+path);
		//var posn='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=0,left=0,top=30,left=20,width=600,height=500';
		var posn="height="+(screen.availHeight-40)+",width="+(screen.availWidth-10)+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes"
		websys_createWindow(path,false,posn);
		//return websys_cancel();

}

function UpdateClickHandler() {
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	UpdateFlag=false;
	var obj=document.getElementById("update");
	if (obj){
		obj.onclick="";
		obj.disabled=true;
	}
	var ret=CheckBeforeUpdate();
	if (ret==false) {
		obj.disabled=false;
		obj.onclick=UpdateClickHandler;
		return false;
	}
	var StopConflictFlag="0";
	if (ConflictItemsInfo!=""){
		var StopConflictItems=dhcsys_confirm("存在以下互斥医嘱："+ConflictItemsInfo+" "+"请确认是否自动停止互斥医嘱");
		if (StopConflictItems) StopConflictFlag="1";
	}
	//电子签名
	var caIsPass=0;
	var ContainerName="";
	if (CAInit==1) 
	{  
			  if (IsCAWin=="") 
				{
					dhcsys_alert("请先插入KEY");
					var obj=document.getElementById("update");
					obj.disabled=false;
	  				obj.onclick=UpdateClickHandler;
					return;
				}
			  var result = window.showModalDialog("../csp/oeorder.oplistcustom.caaudit.csp", window, "dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
				if ((result=="")||(result=="undefined")||(result==null)) 
	      {
	      	var obj=document.getElementById("update");
	      	obj.disabled=false;
					obj.onclick=UpdateClickHandler;
	      	return false;
	      }
	      ContainerName=result;
	      caIsPass=1;
	}
	//将合理用药检查结果保存到处方中
	var XHZYRetCode=0;
	if (DHCDTInterface==1){
		var XHZYRetCode=DaTongXHZYHander();
		if (XHZYRetCode!=0){
    	var PrescCheck=dhcsys_confirm(t['DTQuestion'],true);
      if (PrescCheck==false){
				obj.disabled=false;
				obj.onclick=UpdateClickHandler;
      	return false;
      }
		}
	}
	
	var OrderItemStr=GetOrderDataOnAdd();
	if (OrderItemStr=="") return false;
	//dhcsys_alert(OrderItemStr);
	if (DirectSave!="1"){
		if (OrderItemStr!=""){
			var OEOrdItemIDs=InsertOrderItem(OrderItemStr,StopConflictFlag);
			//dhcsys_alert(OEOrdItemIDs);
			if (OEOrdItemIDs=="0") {
				dhcsys_alert(t['Fail_SaveOrder']);
				return websys_cancel();
			}
		}
  }else{
		var PinNumberobj=document.getElementById("PinNumber");
		if (PinNumberobj){
			var PinNumber=PinNumberobj.value;
			
			if (PinNumber==""){
				dhcsys_alert(t['Input_PinNumber']);
				websys_setfocus('PinNumber');
				return websys_cancel();
			}else{
				var ret=cspRunServerMethod(PinNumberMethod,session['LOGON.USERID'],PinNumber)
				if (ret=="-4"){
					dhcsys_alert(t['Wrong_PinNumber']);
					websys_setfocus('PinNumber');
					return websys_cancel();
				}
			}
		}
	
		var OEOrdItemIDs=SaveOrderItems(OrderItemStr,XHZYRetCode,StopConflictFlag);
		//dhcsys_alert(OEOrdItemIDs);
		if (OEOrdItemIDs=="100") {
			dhcsys_alert(t['Fail_SaveOrder']);
			return websys_cancel();
		}
	}
	var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
	OEOrdItemIDsobj.value=OEOrdItemIDs;
	var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
	OEOrdItemIDsobj.value=OEOrdItemIDs;
	if (caIsPass==1)
	{
		try{
			   //1.批量认证
			   var CASignOrdStr="",CASignOrdValStr="";
			    var TempIDs=OEOrdItemIDs.split("^");
					var IDsLen=TempIDs.length;
					for (var k=0;k<IDsLen;k++) {
						var TempNewOrdDR=TempIDs[k].split("*");
						if (TempNewOrdDR.length < 2) continue;
						var newOrdIdDR=TempNewOrdDR[1];
						if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
						else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;			
				  }
				var CASignOrdArr=CASignOrdStr.split("^");
				var SignOrdHashStr="",SignedOrdStr="";
				for (var count=0;count<CASignOrdArr.length;count++) {
					var CASignOrdId=CASignOrdArr[count];
					var OEORIItemXMLStr=cspRunServerMethod(GetOEORIItemXMLMethod,CASignOrdId,"A");
					//dhcsys_alert(OEORIItemXMLStr);
					var OEORIItemXMLArr=OEORIItemXMLStr.split(String.fromCharCode(2));
					for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
						if (OEORIItemXMLArr[ordcount]=="")continue;
	    			var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
	     			var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
					  //dhcsys_alert("OEORIItemXML:"+OEORIItemXML);
						var OEORIItemXMLHash=HashData(OEORIItemXML);
						//dhcsys_alert("HashOEORIItemXML:"+OEORIItemXMLHash);
						if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
						else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
						//dhcsys_alert(ContainerName);
						var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
						if(SignedOrdStr=="") SignedOrdStr=SignedData;
						else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
						if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
						else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
						 //AddData(HashOEORIItemXML);
				  }
			  }
				if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
				if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
				//dhcsys_alert("SignedOrdStr"+SignedOrdStr);
				//dhcsys_alert(ContainerName);
				//获取客户端证书
				 var varCert = GetSignCert(ContainerName);
				 var varCertCode=GetUniqueID(varCert);
				//3.保存签名信息记录
				/*
				dhcsys_alert("ContainerName:"+ContainerName)
				dhcsys_alert("CASignOrdValStr:"+CASignOrdValStr);
				dhcsys_alert("SignOrdHashStr:"+SignOrdHashStr);
				dhcsys_alert("varCertCode:"+varCertCode);
				dhcsys_alert("SignedData:"+SignedOrdStr);
				*/
				if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!=""))
				{
						var ret=cspRunServerMethod(InsertCASignInfoMethod,CASignOrdValStr,session['LOGON.USERID'],"A",SignOrdHashStr,varCertCode,SignedOrdStr,"");
				    if (ret!="0") dhcsys_alert("数字签名没成功");	
			  }else{
			  	dhcsys_alert("数字签名错误");
			  }
		}catch(e){dhcsys_alert(e.message);}
	}
	var summflag=document.getElementById("SUMMFlag");
	UpdateFlag=true;
	//自动弹出检查申请单
	var ItemServiceFlag=cspRunServerMethod(GetItemServiceFlagMethod,UnSaveARCIMRowidStr);
	if (ItemServiceFlag=="1"){
		if(dhcsys_confirm("是否立即填写申请单",true)){
			var Eposide=document.getElementById("EpisodeID").value;
			var mradm=document.getElementById("mradm").value;
			var PatientID=document.getElementById("PatientID").value;
			var lnk="dhcrisappbill.csp?a=a&EpisodeID="+Eposide+"&mradm="+mradm+"&PatientID="+PatientID;
  			
  			var obj=document.getElementById('EpisodeID');
			var EpisodeID=obj.value;
			var SessionFieldName="RisAppBillURL"+EpisodeID;
			var Ret=cspRunServerMethod(SetSessionDataMethod,SessionFieldName,lnk);
			//parent.location.href=lnk;
  			//websys_lu(lnk,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=630");
		}
	}
	
	
	//录入医嘱的时候判断到达状态;若未到达则置为到达
	//var obj=document.getElementById('DocID');
	var obj=document.getElementById('DoctorID');	
	if ((obj)&&(SetArriveByOrder==1)&&(SetArrivedStatusMethod!="")) {
		var	DocID=obj.value;
		if (cspRunServerMethod(SetArrivedStatusMethod,EpisodeID,DocID,session['LOGON.CTLOCID'],session['LOGON.USERID'])!='1') {
				//dhcsys_alert('fail');
		}
	}

	if ((PAAdmType=="I")&&(HospitalCode=="ZGYKDFSYY")){DHCDOCCallCs();}   //发送到住院超声室供叫号使用叫号,yanjiyan,2008.12.07
		 	
	if ((DHCDTInterface==1)&&(DHCDTUploadFlag==1)){
		//CreateXHZYSave(OEOrdItemIDs);
		var myrtn=DaTongXHZYSave();
		//if (myrtn==2)dhcsys_alert(t['DTQuestion']);
	}

	//dhcsys_alert("OEOrdItemIDsobj:"+OEOrdItemIDsobj.value+"  summflag:"+summflag.value);
	/*
	document.forms['fUDHCOEOrder_List_Custom'].id="fOEOrder_Custom"
	document.forms['fUDHCOEOrder_List_Custom'].name="fOEOrder_Custom"	
	var obj=document.getElementById("TFORM");
	obj.value="OEOrder.Custom";
	*/
	
	//update by zf 2012-05-14
	if (typeof window.parent.objControlArry != "undefined"){
		window.parent.objControlArry['FormNewWin'].objFormShow.formShowData("",0);
	}
	else if (typeof window.parent.parent.objControlArry != "undefined"){
		window.parent.parent.objControlArry['FormNewWin'].objFormShow.formShowData("",0);
	}
	
	//审核医嘱是否自动弹出一键打印窗口,医生站安全组配置中配置
	var ClickPrnFlag=tkMakeServerCall("web.DHCDocConfig","GetConfigNode1","ClickPrnConfig",session['LOGON.GROUPID'])
	if(ClickPrnFlag=="1"){
		var obj=document.getElementById('PatientID');
		if (obj) var PatientID=obj.value;
		var obj=document.getElementById('mradm');
		if (obj) var MRADMID=obj.value;
		var EpisodeID=document.getElementById("EpisodeID").value;
		var userid=session['LOGON.USERID'];
		var ctlocid=session['LOGON.CTLOCID'];
		var PrtClick=new PrtClickInfo(EpisodeID,PatientID,MRADMID,ctlocid,userid);
	}else{
		window.setTimeout("UpdateClickHandlerFinish()",1000);
	}
}

function CheckOrderStartDate(OrderStartDate,CurrDate){
	if (CurrDate=="") return true;
	if (OrderStartDate=="") return true;
	
	var dt=OrderStartDate;
	if ((dt.indexOf('/')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
	var dtArr=dt.split('/');
	var len=dtArr.length;
	if (len>3) return false;
	for (i=0; i<len; i++) {
	if (dtArr[i]=='') return false;
	}
 
 	var OrderStartDateArr=OrderStartDate.split("/");
	var OrderStartDateYear=OrderStartDateArr[2];
	var OrderStartDateMonth=parseFloat(OrderStartDateArr[1])-1;
	var OrderStartDateDay=OrderStartDateArr[0];
	
	var CurrDateArr=CurrDate.split("/");
	var CurrDateYear=CurrDateArr[2];
	var CurrDateMonth=parseFloat(CurrDateArr[1])-1;
	var CurrDateDay=CurrDateArr[0];
	
	var objDate = new Date(OrderStartDateYear,OrderStartDateMonth,OrderStartDateDay,0,0,0);
	var minDate = new Date(CurrDateYear,CurrDateMonth,CurrDateDay,0,0,0);
	//dhcsys_alert(minDate.getTime()+"^"+objDate.getTime());
	if (minDate.getTime() > objDate.getTime()) return false;
	return true;
}

function CompareDate(DateTime1,DateTime2){

	return true;
}

function CheckBeforeUpdate(){
	//update by zf 2012-05-14
	if (CPWCheck()!==true) return false;
	
	var XYPrescCount=0;
	var ZCYPrescCount=0;
	var CYPrescCount=0;
	var NewRows=0;
	var CNOrderDur="";
	var FindCNMedCl=false;
	var NeedCheckDeposit=false;
	var Amount=0;
	var OrderInstrGroupArr=new Array();
	var ARCIMRowidStr="";
	UnSaveARCIMRowidStr="";
  try{
		var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
		var CurrDateTimeArr=CurrDateTime.split("^");
		var CurrDate=CurrDateTimeArr[0];
  		var OrderMaterialBarCodeStr=""
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderName=GetColumnData("OrderName",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
			var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
			var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
			var OrderFreq=GetColumnData("OrderFreq",Row);
			var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
			var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
			var OrderDur=GetColumnData("OrderDur",Row);
			var OrderDurFactor=GetColumnData("OrderDurFactor",Row);
			var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);	
			var OrderInstr=GetColumnData("OrderInstr",Row);	
			var OrderDoseQty=GetColumnData("OrderDoseQty",Row);	
			var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
			var OrderDoseUOM=GetColumnData("OrderDoseUOM",Row);
			var OrderPackQty=GetColumnData("OrderPackQty",Row);
			var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var PHPrescType=GetColumnData("OrderPHPrescType",Row);
			var OrderConFac=GetColumnData("OrderConFac",Row);
			var OrderBaseQty=GetColumnData("OrderBaseQty",Row);
			var OrderPrice=GetColumnData("OrderPrice",Row);
			var OrderStartDate=GetColumnData("OrderStartDate",Row);
			var OrderPHForm=GetColumnData("OrderPHForm",Row);
			var OrderItemSum=GetColumnData("OrderSum",Row);	    
			var OrderEndDate=GetColumnData("OrderEndDate",Row);	  
			var OrderAlertStockQty=GetColumnData("OrderAlertStockQty",Row); 
			var OrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
			var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
			var OrderPackUOM=GetColumnData("OrderPackUOM",Row);
			var OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
			var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
			var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
			var OrderSpeedFlowRate=GetColumnData("OrderSpeedFlowRate",Row);
			var OrderFlowRateUnit=GetColumnData("OrderFlowRateUnit",Row);
			//if (OrderFirstDayTimes=="0") {dhcsys_alert(OrderName+t['FirstTimesNotZero']); return false}
			if ((OrderFreqFactor!="")&&(OrderFirstDayTimes!="")&&(Number(OrderFirstDayTimes)>Number(OrderFreqFactor))) {dhcsys_alert(OrderName+t['FirstMaxNum']); return false}
			var AntUseReason=GetColumnData("AntUseReason",Row);
			var OrderPoisonCode=GetColumnData("OrderPoisonCode",Row);
			var OrderUsableDays=GetColumnData("OrderUsableDays",Row);
			
			
			/*//检查是否输写使用目的和申请单 
			var OrderAntibApplyRowid=GetColumnData("OrderAntibApplyRowid",Row);
			var UserReasonId=GetColumnData("UserReasonId",Row);
			var ShowTabStr=GetColumnData("ShowTabStr",Row);
			if((ShowTabStr=="UserReason")&&(UserReasonId=="")){
					dhcsys_alert(OrderName+"  请填写使用目的!")
					SetFocusColumn("UserReason",Row);
					FocusRowIndex=i;
					return false;
			}
			if(ShowTabStr=="Apply,UserReason"){
					if(UserReasonId==""){
							dhcsys_alert(OrderName+"  请填写使用目的!")
							SetFocusColumn("UserReason",Row);
							FocusRowIndex=i;
							return false;
					}	
					if(OrderAntibApplyRowid==""){
							dhcsys_alert(OrderName+"  请填写登记表!")
							SetFocusColumn("UserReason",Row);
							FocusRowIndex=i;
							return false;	
					}
			}
			*/
			
			
			
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				
				if (OrderRecDepRowid==""){
					 dhcsys_alert(OrderName+t['NO_RECLOC']);
					 return false;
				}
				
				var DateStr=GetColumnData("OrderStartDate",Row)+"^"+GetColumnData("OrderEndDate",Row)+"^"+GetColumnData("OrderDate",Row)
				var TimeStr=GetColumnData("OrderStartTime",Row)+"^"+GetColumnData("OrderEndTime",Row)+"^"+GetColumnData("OrderTime",Row)
				var CheckDateTimeFlag=cspRunServerMethod(CheckDateTime,DateStr,TimeStr);
				if (CheckDateTimeFlag!="Y"){dhcsys_alert(OrderName+"请录入有效的相关日期时间格式");return false}
				
				if (OrderPriorRowid==""){dhcsys_alert("请选择相应的医嘱类型!");return false;}
				 //判断医嘱项中的门急诊限制
				var CheckArcimTypeStr=cspRunServerMethod(CheckArcimType,OrderARCIMRowid,EpisodeID); 
				if (CheckArcimTypeStr!=""){dhcsys_alert(OrderName+CheckArcimTypeStr);return false;}
				
				
				//超量疗程原因
				var ExceedReasonID=GetColumnData("ExceedReasonID",Row);	
				var ExceedDate=cspRunServerMethod(GetExceedDate,PAAdmType)
				if((ExceedReasonID=="")&&(OrderType=='R')&&(ExceedDate!=0)&&(parseInt(OrderDurFactor)>ExceedDate)){
					if (PAAdmType=="E"){dhcsys_alert(OrderName+"  急诊诊病人处方超过"+ExceedDate+"天必须选择疗程超天数原因!")}
					else{dhcsys_alert(OrderName+"  门诊病人处方超过"+ExceedDate+"天必须选择疗程超天数原因!")}
					SetFocusColumn("ExceedReason",Row);
					FocusRowIndex=i;
					return false;
				}
				//静脉配液接收科室判断判断
				var OrderNeedPIVAFlag=GetColumnData("OrderNeedPIVAFlag",Row);
				if (OrderNeedPIVAFlag=="Y"){
					if (IPDosingRecLocStr!=""){
							if (("^"+IPDosingRecLocStr+"^").indexOf("^"+OrderRecDepRowid+"^")<0){
									dhcsys_alert("静脉配液医嘱请选择相应的静配接收科室");
									return false;
								}
						}
				}
				//判断是否此药房只发散包装
				if ((CFIPDispensingRecLoc!='')&&(PAAdmType=="I")&&(OrderType=='R')){
					var DispensingRecLocStr='^'+CFIPDispensingRecLoc+'^';
					var OrderRecDepStr='^'+OrderRecDepRowid+'^';
					if ((DispensingRecLocStr.indexOf(OrderRecDepStr)!=-1)&&(OrderPackQty!="")){
						dhcsys_alert(OrderName+t['PackQtyNotAccept']);
						return false;
					}
				}
				
				//---------------高值耗材
				if (HighValueControl==1){
				var IncItmHighValueFlag=cspRunServerMethod(GetIncItmHighValueFlag,OrderARCIMRowid)
				var OrderMaterialBarCode=GetColumnData("OrderMaterialBarcodeHiden",Row);
				if((IncItmHighValueFlag=="Y")&&(OrderMaterialBarCode=="")){
					dhcsys_alert(OrderName+" 属于高值耗材,只能通过扫条码下医嘱!")
					SetFocusColumn("OrderMaterialBarCode",Row);
					FocusRowIndex=i;
					return false;
				}
				if (OrderMaterialBarCode!=""){
					var RtnMaterialBarcode=CheckMaterialBarcode(OrderMaterialBarCode,Row)
					if (RtnMaterialBarcode==false) {return false;}
					if (OrderMaterialBarCodeStr!="")
					{
					if ((("^"+OrderMaterialBarCodeStr+"^").indexOf(("^"+OrderMaterialBarCode+"^")))>=0){dhcsys_alert("一次录入不能存在两条相同条码的医嘱！");return false}
					}
					if (OrderMaterialBarCodeStr==""){OrderMaterialBarCodeStr=OrderMaterialBarCode}
					else{OrderMaterialBarCodeStr=OrderMaterialBarCodeStr+"^"+OrderMaterialBarCode}
				}
				}
				
				//--------------
				
				if (UnSaveARCIMRowidStr=="") UnSaveARCIMRowidStr=OrderARCIMRowid;
				else UnSaveARCIMRowidStr=UnSaveARCIMRowidStr+"^"+OrderARCIMRowid;
				if (ARCIMRowidStr=="")ARCIMRowidStr=OrderPriorRowid+"^"+OrderARCIMRowid;
				else ARCIMRowidStr=ARCIMRowidStr+"!"+OrderPriorRowid+"^"+OrderARCIMRowid;
				Amount=Amount+parseFloat(OrderItemSum);
				if (!(CheckOrderStartDate(OrderStartDate,CurrDate))) {
					dhcsys_alert(OrderName+t['STARTDATE_EXCEEDTODAY']);
					SetFocusColumn("OrderStartDate",Row);
					FocusRowIndex=i;
					return false;
				}
				var IPNeedBillQtyFlag="0";
				if (OrderType=="R"){
					if (OrderMasterSeqNo!=""){
						if (OrderMasterSeqNo==OrderSeqNo) {
							SetColumnData("OrderMasterSeqNo",Row,"");
						}else{
							var ret=CheckMasterSeqNo(OrderMasterSeqNo);
							if (!ret){
								dhcsys_alert(OrderName+t['Err_SeqNo']);
								SetFocusColumn("OrderMasterSeqNo",Row);
								FocusRowIndex=i;
								return false;
							}
						}
					}
					var CheckWYInstr=IsWYInstr(OrderInstrRowid);
					if (((OrderDoseQty=='')||(parseFloat(OrderDoseQty)==0)||(isNumber(OrderDoseQty)==false))&&(!CheckWYInstr)) {
						dhcsys_alert(OrderName+t['NO_DoseQty']);
						SetFocusColumn("OrderDoseQty",Row);
						FocusRowIndex=i;
						return false;
					}
					
					if ((OrderFreqRowid=='')||(OrderFreq=="")) {
						dhcsys_alert(OrderName+t['NO_Frequence']);
						SetFocusColumn("OrderFreq",Row);
						FocusRowIndex=i;
						return false;
					}
					
					if (((OrderDoseUOMRowid=='')||(OrderDoseUOM==""))&&(!CheckWYInstr)) {
						dhcsys_alert(OrderName+t['NO_DoseUOM']);
						SetFocusColumn("OrderDoseUOM",Row);
						FocusRowIndex=i;
						return false;
					}
					if (((OrderDurRowid=='')||(OrderDur==''))&&(!CheckWYInstr)&&(OrderPriorRowid!=LongOrderPriorRowid)) {
						dhcsys_alert(OrderName+t['NO_Duration']);
						SetFocusColumn("OrderDur",Row);
						FocusRowIndex=i;
						return false;
					}
					if ((OrderInstrRowid=='')||(OrderInstrRowid=='')) {
						dhcsys_alert(OrderName+t['NO_Instr']);
						SetFocusColumn("OrderInstr",Row);
						FocusRowIndex=i;
						return false;
					}
					
					//判断药品剂量
					if (CheckOrderDoseLimit(Row)==false){

						return false;
					}					

					if ((PHPrescType=="3")&&(HospitalCode=="HF")&&(OrderARCIMRowid=="5612||1")){
						FindCNMedCl=true;
						if ((OrderPackQty!="")&&(OrderPackQty>2)){
							dhcsys_alert(OrderName+t['Exceed_CNDurCL']);
					    SetFocusColumn("OrderDur",Row);
					    FocusRowIndex=i;
					    return false;
						}
					}
					//CJB2006-10-26+ 合肥修改草药颗粒剂14付控制;		
					if ((OrderPHForm==t['CNMedForm'])&&(PHPrescType=="3")&&(((HospitalCode=="HF")&&(OrderARCIMRowid!="5612||1"))||(HospitalCode!="HF"))){
						if ((OrderDurFactor!="")&&(OrderDurFactor>14)){
							dhcsys_alert(OrderName+t['Exceed_KLCNDur']);
							SetFocusColumn("OrderDur",Row);
							FocusRowIndex=i;
							return false;
						}
					}
	        if ((OrderPHForm==t['CNMedForm'])&&(PHPrescType=="3")&&(((HospitalCode=="HF")&&(OrderARCIMRowid!="5612||1"))||(HospitalCode!="HF"))){
	        	if ((OrderDurFactor!="")&&(OrderDurFactor>7)){
	        		  dhcsys_alert(OrderName+t['Exceed_CNDur']);
						    SetFocusColumn("OrderDur",Row);
						    FocusRowIndex=i;
						    return false;
	        	}
	        	if (CNOrderDur==""){CNOrderDur=OrderDurRowid}else{
	        		if (CNOrderDur!=OrderDurRowid){
	        			dhcsys_alert(t['Diff_CNDur']);
						    SetFocusColumn("OrderDur",Row);
						    FocusRowIndex=i;
						    return false;
	        		}
	        	}
	        }

	        if (PAAdmType!="I") {
						//dhcsys_alert(XYPrescCount+"^"+ZCYPrescCount);
						if (HospitalCode=="NB"){
						  if ((PHPrescType=="1")&&(OrderMasterSeqNo==""))  {XYPrescCount=XYPrescCount+1;}
						  if ((PHPrescType=="2")&&(OrderMasterSeqNo==""))  {ZCYPrescCount=ZCYPrescCount+1;}
			        if ((PHPrescType=="3")&&(OrderMasterSeqNo==""))  {CYPrescCount=CYPrescCount+1;}
						  if (XYPrescCount>5) {
						  	SetFocusColumn("OrderName",Row);
						  	FocusRowIndex=i;
						  	dhcsys_alert(t['EXCEED_PRESCCOUNT']);
						  	return false;
						  }
						  if (ZCYPrescCount>5) {
						  	SetFocusColumn("OrderName",Row);
						  	FocusRowIndex=i;
						  	dhcsys_alert(t['EXCEED_PRESCCOUNT']);
						  	return false;
						  }
						}else{
							//按用法分处方
							if (PrescByInstr==1){
								var InstrGroupCode=cspRunServerMethod(GetInstrGroupCodeMethod,OrderInstrRowid);
								if (InstrGroupCode!=""){
									var PrescName=PHPrescType+'^'+OrderBillTypeRowid+'^'+InstrGroupCode+"^"+OrderInstr;
									var FindPresc=false;
									for (var j=0;j<=OrderInstrGroupArr.length-1;j++) {
										var TempName=mPiece(OrderInstrGroupArr[j],"!",0)
										if (TempName==PrescName){
											PrescCount=eval(mPiece(OrderInstrGroupArr[j],"!",1))+1
											OrderInstrGroupArr[j]=PrescName+"!"+PrescCount;
											FindPresc=true;
										}
									}
									if (!FindPresc){
										OrderInstrGroupArr[OrderInstrGroupArr.length]=PrescName+"!"+1;
									}
								}
							}
							if (HospitalCode=="ZGYKDFSYY"){
								//溶液剂量>=100ml静脉点滴的关联长期医嘱才能开到静脉配液中心
								if ((IPDosingRecLoc!="")&&(OrderType=="R")&&(OrderPriorRowid==LongOrderPriorRowid)&&(OrderDoseQty>=100)&&(OrderDoseUOMRowid==MLUOMRowId)&&(OrderInstrRowid==IVInstrRowId)){
									var ret=CheckDosingRecLoc(OrderRecDepRowid);
									if (!ret){
										var ret=IsMasterOrderItem(OrderSeqNo);
										if (ret){
											dhcsys_alert(OrderName+t['NotDosingRecLoc']);
											return false;
										}
									}
								}
							}
							if (OrderType=="R") {
								var InsurFlag=cspRunServerMethod(GetInsurFlagMethod,OrderBillTypeRowid,PAAdmType);
								if (OrderUsableDays=="") OrderUsableDays=0;
								if ((InsurFlag==1)&&(parseFloat(OrderUsableDays)>200)){
									dhcsys_alert(OrderName+t['InsurOPUsableDaysLimit']);
									return false;
								}
								//根据诊断对药品最大疗程的限制,使用设置:medtrak-医生站配置-诊断设置-诊断疗程限制
								var Rtn=CheckDiagnosLimitDur(OrderDurFactor);
								if (Rtn==false) {
									dhcsys_alert(OrderName+t['DiagnosLimitDurMsg']);
									return false;
								}
							}
						}
					}
				}else{
					if ((OrderPriorRowid==OMOrderPriorRowid)||(OrderPriorRowid==OMSOrderPriorRowid)){
						dhcsys_alert(OrderName+t['OMOrderPriorNotAllow']);
						return false;
					}
					//自定价医嘱
					if (OrderType=="P"){
						OrderPrice=Trim(OrderPrice);
						if (OrderPrice=='') {
							dhcsys_alert(OrderName+t['NO_OrderPrice']);
							SetFocusColumn("OrderPrice",Row);
							FocusRowIndex=i;
							return false;
						}else{
							if ((!isNumber(OrderPrice))||(parseFloat(OrderPrice)==0)){
								dhcsys_alert(OrderName+t['Not_Number']);
								FocusRowIndex=i;
								SetFocusColumn("OrderPrice",Row);
								return false;
							}
						}
					}
					//检验医嘱
					if (OrderType=="L"){
						if (OrderPackQty==""){OrderPackQty="1"}
						if (HospitalCode!="ZGYKDFSYY"){
							var PrescCheck=CheckDateDupOrderItem(i,OrderARCIMRowid,OrderStartDate);
							if (PrescCheck==true){
								dhcsys_alert(OrderName+t['SAME_LABORDERITEM']);
							  return false;
						  }
						}
						var OrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row);
						if (OrderLabSpecRowid==''){
							dhcsys_alert(OrderName+t['NeedLabSpec']);
							return false;
						}
					}
				}
				
				var Qty=1;
				if (OrderBaseQty=="") {OrderBaseQty=1;}
				if (OrderFreqFactor==""){OrderFreqFactor=1;}
				if ((OrderPackQty!="")&&(parseFloat(OrderPackQty)!=0)){
					Qty=parseFloat(OrderConFac)*parseFloat(OrderPackQty);
				}else{
					Qty=parseFloat(OrderBaseQty) * parseFloat(OrderFreqFactor);
					if (Qty<1) {Qty=1}
				}
				
				//库存判断-------自备药医嘱不用判断库存
				var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
				if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(OrderPriorRemarks!="OM")){
					//var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,Qty,OrderRecDepRowid);
					//CheckBeforeUpdateMethodhod包含了库存判断
					var ret=cspRunServerMethod(CheckBeforeUpdateMethod,OrderARCIMRowid,Qty,OrderRecDepRowid,PAAdmType);
					var Check=mPiece(ret,"^",0);
					IPNeedBillQtyFlag=mPiece(ret,"^",1);
					if (Check=='0') {
						//根据设定的最小量来判断是否需要提示库存量
						if ((OrderAlertStockQty!="")&&(OrderAlertStockQty!=0)&&(PAAdmType=="O")){
							var StockQtyStr=cspRunServerMethod(GetStockQtyMethod,OrderRecDepRowid,OrderARCIMRowid);
							var StockQty=mPiece(StockQtyStr,"^",0);
							var PackedQty=mPiece(StockQtyStr,"^",1);
							var LogicQty=parseFloat(StockQty)-parseFloat(PackedQty);
							if (parseFloat(OrderAlertStockQty)>LogicQty){
								dhcsys_alert(OrderName+t['QTY_NOTENOUGH']+","+t['STOCKQTY']+LogicQty);
								SetFocusColumn("OrderPackQty",Row);
								FocusRowIndex=i;
								return false;
							}
						}
						dhcsys_alert(OrderName+t['QTY_NOTENOUGH']);
						SetFocusColumn("OrderPackQty",Row);
						FocusRowIndex=i;
						return false;
					}else if (Check=="-1"){
						var CellObj=document.getElementById("OrderRecDepz"+Row); 
						var OrderRecDepDesc=CellObj.options[CellObj.selectedIndex].text;
						dhcsys_alert(OrderName+OrderRecDepDesc+t['QTY_INCItemLocked']);
						return false;
					}
					//需要配液 判断默认首日的接收科室库存是否充足
					var OrderNeedPIVAFlag=GetColumnData("OrderNeedPIVAFlag",Row);
					if (OrderNeedPIVAFlag==true){OrderNeedPIVAFlag="Y"}else{OrderNeedPIVAFlag="N"}
					if ((OrderNeedPIVAFlag=="Y")&&(OrderPriorRowid==LongOrderPriorRowid)){
						var OrderStartTime=GetColumnData("OrderStartTime",Row);
						var GetFirstDayRecLoc=tkMakeServerCall("appcom.OEDispensing","GetFirstDaySetting",EpisodeID,OrderARCIMRowid,OrderRecDepRowid,OrderStartDate,OrderStartTime);
						if (GetFirstDayRecLoc!=""){
							var ret1=cspRunServerMethod(CheckBeforeUpdateMethod,OrderARCIMRowid,Qty,GetFirstDayRecLoc,PAAdmType);
							if (mPiece(ret1,"^",0)=='0'){
								var CTLOCStr=tkMakeServerCall("web.DHCDocCommon","GetCTLOCDesc",GetFirstDayRecLoc);
								var CTLOCDesc=CTLOCStr.split("^")[0]
								dhcsys_alert(OrderName+"，配液首日默认接收科室"+CTLOCDesc+t['QTY_NOTENOUGH']);
								SetFocusColumn("OrderPackQty",Row);
								FocusRowIndex=i;
								return false;
								}
						}
					}
				}
				//判断整数量输入值是否为有效数值
				OrderPackQty=Trim(OrderPackQty);
				var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
				var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
				var AllowEntryDecimalItemCatStr="^"+AllowEntryDecimalItemCat+"^"
				if((AllowEntryDecimalItemCatStr.indexOf("^"+OrderItemCatRowid+"^"))==-1){
					if (OrderType=="R"){
						if ((OrderPackQty!="")&&((!isInteger(OrderPackQty))||(parseFloat(OrderPackQty)==0))){
							dhcsys_alert(OrderName+t['Not_Number']);
							FocusRowIndex=i;
							SetFocusColumn("OrderPackQty",Row);
							return false;
						}
					}else{
						if ((OrderPackQty!="")&&((!isNumber(OrderPackQty))||(parseFloat(OrderPackQty)==0))){
							dhcsys_alert(OrderName+t['Not_Number']);
							FocusRowIndex=i;
							SetFocusColumn("OrderPackQty",Row);
							return false;
							
						}else{
							if ((OrderType=="L")&&(eval(OrderPackQty)!=1)){
								//深圳中医院对检验的特殊要求
							
								if (((HospitalCode=="SZZYY")&&(OrderPackUOM=="次"))||(HospitalCode!="SZZYY")){
								  dhcsys_alert(t['LAB_QtyLimit']);
									FocusRowIndex=i;
								  SetFocusColumn("OrderPackQty",Row);
								  return false;
								}
							}
							
							var JCOrderFlag=cspRunServerMethod(GetItemServiceFlagMethod,OrderARCIMRowid); 
							if((JCOrderFlag=="1")&&(eval(OrderPackQty)!=1)){
						 		  dhcsys_alert(t['JC_QtyLimit']);
								  FocusRowIndex=i;
								  SetFocusColumn("OrderPackQty",Row);
								  return false;
							}
						}

					}
				}else{
					//允许录入小数
					//dhcsys_alert(isNaN(OrderPackQty)+"##"+parseFloat(OrderPackQty))
					if((isNaN(OrderPackQty))||(parseFloat(OrderPackQty)<=0)||(OrderPackQty=="")){
						//dhcsys_alert(OrderName+t['Not_Number']);
						FocusRowIndex=i;
						SetFocusColumn("OrderPackQty",Row);
						return false;
					}
				}
				if (OrderPackQty=="") {OrderPackQty=0}				
				//对于整包装数量的判断
				if (PAAdmType!="I"){
					if (parseFloat(OrderPackQty)==0){
						dhcsys_alert(OrderName+t['NO_PackQty']);
						FocusRowIndex=i;
						SetFocusColumn("OrderPackQty",Row);
						return false;
					}
				}else{
					
					//判断出院带药是否必须要录整包装
					if ((parseInt(OrderPackQty)==0)&&(OrderPriorRowid==OutOrderPriorRowid)&&(OutOrderNeedPackQty=="1")){
						dhcsys_alert(OrderName+t['NO_PackQty']);
						FocusRowIndex=i;
						SetFocusColumn("OrderPackQty",Row);
						return false;						
					}
					//住院判断是否必须要录整包装
					var IPNeedBillQty=mPiece(OrderHiddenPara,String.fromCharCode(1),1);
					if ((parseFloat(OrderPackQty)==0)&&((IPNeedBillQty=="Y")||(IPNeedBillQtyFlag=="1"))&&(OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)){
						dhcsys_alert(OrderName+t['NO_PackQty']);
						FocusRowIndex=i;
						SetFocusColumn("OrderPackQty",Row);
						return false;
					}
					//判断出院带其他控制
					if (OrderPriorRowid==OutOrderPriorRowid) {
						/* //医保提示,根据项目修改
			    	var InsurFlag=cspRunServerMethod(GetInsurFlagMethod,OrderBillTypeRowid,PAAdmType);
			    	if ((InsurFlag==1)&&(OrderName.indexOf("(丙)")!=-1)) {
			    		 dhcsys_alert(OrderName+t['InsurIPSelfAlert']);
			    	}
			    	*/
						if (!CheckOutOrderOtherContral(OrderName,OrderBillTypeRowid,OrderDurRowid,OrderItemCatRowid,ARCIMRowidStr,OrderARCIMRowid,OrderFreqRowid,OrderPackQty,OrderDoseQty,OrderDoseUOMRowid)){
					   	return false;
				    }
			    }
			    
				}
				
				//判断整数量是否符合限量控制和疗程控制
				if (CheckDurationPackQty(Row)==false){
					SetFocusColumn("OrderPackQty",Row);
					return false;
				}
				//检查医嘱优先级相关的控制
			  var PriorCheck=CheckPriorAllowRange(OrderPriorRowid,OrderARCIMRowid);
			  if (PriorCheck==false) {
			  	dhcsys_alert(OrderName+",禁止开此医嘱类型.");
			  	return false;
			  }
			  //出院带药
				if ((OrderPriorRowid==OutOrderPriorRowid)&&(OrderType!='R')){
					dhcsys_alert(OrderName+t['NoAllowOutPrior']);
					SetFocusColumn("OrderName",Row);
					return false;
				}
				//选择输液流速单位
				if ((OrderSpeedFlowRate!="")&&(OrderFlowRateUnit=='')){
					dhcsys_alert(OrderName+" 请选择输液流速单位");
					SetFocusColumn("OrderFlowRateUnit",Row);
					return false;
				}
				//请填写输液流速
				if ((OrderFlowRateUnit!='')&&(OrderSpeedFlowRate=='')){
					dhcsys_alert(OrderName+" 请填写输液流速");
					SetFocusColumn("OrderSpeedFlowRate",Row);
					return false;
				}
				//抗生素使用原因
				if ((OrderPoisonCode.indexOf("KSS")>-1)&&(AntUseReason=='')){
					//dhcsys_alert(OrderName+" 请选择抗生素使用原因");
					//SetFocusColumn("AntUseReason",Row);
					//return false;
				}
				
				NewRows=NewRows+1;
				//如果只开了自备药医嘱或零价格医嘱则不用判断欠费
				if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(parseFloat(OrderPrice)!=0)) {NeedCheckDeposit=true}
				// 取互斥医嘱信息
		    if ((PAAdmType=="I")&&((OrderPriorRowid==LongOrderPriorRowid)||(OrderPriorRowid==OMOrderPriorRowid))){
		    	GetConflictItemsInfo(OrderARCIMRowid);
		    }
			}
			
			if ((OrderPriorRowid==ShortOrderPriorRowid)&&(OrderPoisonCode.indexOf("KSS")>-1)){
				//加一个条件（申请单为未审核给与提示）
				var OrderAntibApplyRowid=GetColumnData("OrderAntibApplyRowid",Row);
				if((OrderAntibApplyRowid!="")&&(OrderAntibApplyRowid!="undefined")){
					var AppStatusFlag=tkMakeServerCall("web.DHCDocAntiCommon","GetAntibioSta",OrderAntibApplyRowid)
					if(AppStatusFlag==0){
						dhcsys_alert("请上级医师24小时内审核");
					}
				}
			}
		}
		//判断医嘱需开特定医嘱设置
		var ret=cspRunServerMethod(CheckSpecOrdLinkedMethod,EpisodeID,ARCIMRowidStr);
		if (ret.split("^")[0]!="0") {
			dhcsys_alert(ret.split("^")[1]+t['NeedSpecOrdLinked']);
			return false;
		}
		//判断一张处方的数量限量
		for (var i=0;i<=OrderInstrGroupArr.length-1;i++) {
			if (mPiece(OrderInstrGroupArr[i],"!",1)>5){
				var msg=mPiece(mPiece(OrderInstrGroupArr[i],"!",0),"^",3)
				dhcsys_alert(msg+t['EXCEED_PRESCCOUNT']);
				return false
			}
		}

		if (NeedCheckDeposit){
			var amount=0;
			var obj_ScreenBillSum=document.getElementById('ScreenBillSum');
			if (obj_ScreenBillSum) {amount=obj_ScreenBillSum.value;}
	    if (!CheckDeposit(amount,"")){
	    	return false;
	    }
	  }
	  
		Amount=Amount.toFixed(2);
    if (!CheckBillTypeSum(Amount)){
    	var PrescCheck=dhcsys_confirm(t['EXCEED_ADMAMOUNT'],true);
      if (PrescCheck==false){return false;}
    }
			
    if (!CheckOutOrderSum(Amount)){
    	var OutOrderCheck=dhcsys_alert(t['EXCEED_OutOrderAMOUNT']);
      return false;
    }
    var LinkedMasterOrderRowid=GetColumnData("LinkedMasterOrderRowid",Row);
	if (LinkedMasterOrderRowid!="") {
		 var OrderStatus=tkMakeServerCall('web.DHCDocOrderCommon','GetOrderStatus',LinkedMasterOrderRowid);
		 if (OrderStatus=="U"||OrderStatus=="D"||OrderStatus=="C"){
			    dhcsys_alert("关联主医嘱已停止或作废，不给予审核！");
				return false;
		}
	}
			
		if ((CYPrescCount>0)&&(!FindCNMedCl)&&(HospitalCode=="HF")){
      var PrescCheck=dhcsys_confirm(t['No_AddCNMedCL'],true);
      if (PrescCheck==false){return false;}
      //dhcsys_alert(t['No_AddCNMedCL']);
			//return false;
		}
		if (NewRows==0){
			dhcsys_alert(t['NO_NewOrders']);
			return false;
		}
		///成组医嘱的医嘱类型不同，不给于审核   关联：OrderMasterSeqNo，  医嘱类型：OrderPriorRowid  序号：OrderSeqNo
		///增加护士补录医嘱类型是否一致的控制
		var MastOrderPriorRowid="";
		var LinkedMasterOrderRowid=GetColumnData("LinkedMasterOrderRowid",Row);
		var LinkOrderStrObj=document.getElementById("LinkOrderStr");
		if (LinkOrderStrObj){
		if ((LinkedMasterOrderRowid=="")&&(LinkOrderStrObj!="")){
				SetNurLinkOrd()
				LinkedMasterOrderRowid=GetColumnData("LinkedMasterOrderRowid",Row);
			}
		}
		if (LinkedMasterOrderRowid!="") {
			MastOrderPriorRowid=tkMakeServerCall('web.DHCDocOrderCommon','GetNurMastOrderPriorRowid',LinkedMasterOrderRowid);
		}else if(OrderMasterSeqNo!=""){
			MastOrderPriorRowid=GetColumnData("OrderPriorRowid",OrderMasterSeqNo);
		}
		if (MastOrderPriorRowid!="") {
			var MastOrderPriorFlag=IsLongPrior(MastOrderPriorRowid);
			var OrderPriorFlag=IsLongPrior(OrderPriorRowid);
			if(MastOrderPriorFlag!=OrderPriorFlag){
				dhcsys_alert("关联医嘱类型不同，不给予审核！");
				return false;
			}
		}
		return true;
	}catch(e){dhcsys_alert(e.message);}
}

function IsMasterOrderItem(SeqNo){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		if (OrderMasterSeqNo==SeqNo) return true;
	}
	return false;
}
function IsLongPrior(OrderPriorRowId) {
	var OrderPriorFlag=cspRunServerMethod(ISLongOrderPriorMethod,OrderPriorRowId);
	return OrderPriorFlag;
}

function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}

function isInteger(objStr){
	var reg=/^\+?[0-9]*[0-9][0-9]*$/;
	var ret=objStr.match(reg);
  if(ret==null){return false}else{return true}
}

function isNumber(objStr){
 strRef = "-1234567890.";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}
function CheckMasterSeqNo(MasterSeqNo){
  try{
    /*//09-04-17 郭荣勇 改成添加和删除拼串CheckMasterNoStr来加快审查速度
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderName=GetColumnData("OrderName",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	    var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				if (OrderSeqNo==MasterSeqNo){return true}
			}
		}
	  */

		var MasterSeqNo="!"+MasterSeqNo+"!";
		if (CheckMasterNoStr.indexOf(MasterSeqNo)!=-1) return true;

	}catch(e){dhcsys_alert(e.message);}
	return false;
}
function GetOrderDataOnAdd() {
  var OrderItemStr=""; 
  var OrderItem=""; 
  var OneOrderItem="";
	try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		//得到界面上OrderSeqNo最大值?为后面追加的医嘱所用
		var MaxRow=GetRow(rows-1);
		var MaxSeqNo=GetColumnData("OrderSeqNo",MaxRow);
		
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
			var OrderName=GetColumnData("OrderName",Row);
			var OrderType=GetColumnData("OrderType",Row);
			var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
			var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
			var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
			var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
		    var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);	
		    var OrderDoseQty=GetColumnData("OrderDoseQty",Row);	
		    var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
		    var OrderPackQty=GetColumnData("OrderPackQty",Row);
		    var OrderPrice=GetColumnData("OrderPrice",Row);
		    var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		    var PHPrescType=GetColumnData("OrderPHPrescType",Row);
		    var BillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
		    var OrderSkinTest=GetColumnData("OrderSkinTest",Row);
		    var OrderARCOSRowid=GetColumnData("OrderARCOSRowid",Row);
		    var OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
		    var OrderStartDate=GetColumnData("OrderStartDate",Row);
		    var OrderStartTime=GetColumnData("OrderStartTime",Row);
		    var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		    var OrderDepProcNotes=GetColumnData("OrderDepProcNote",Row);
			var OrderPhSpecInstr=GetColumnData("OrderPhSpecInstr",Row);
			var OrderCoverMainIns=GetColumnData("OrderCoverMainIns",Row);
			var OrderActionRowid=GetColumnData("OrderActionRowid",Row);
			var OrderEndDate=GetColumnData("OrderEndDate",Row);
			var OrderEndTime=GetColumnData("OrderEndTime",Row);
			if (OrderSkinTest==true){OrderSkinTest="Y"}else{OrderSkinTest="N"}
			if (OrderCoverMainIns==true){OrderCoverMainIns="Y"}else{OrderCoverMainIns="N"}
			var OrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row);
			var OrderMultiDate=GetColumnData("OrderMultiDate",Row);
			var OrderNotifyClinician=GetColumnData("OrderNotifyClinician",Row);
			if (OrderNotifyClinician==true){OrderNotifyClinician="Y"}else{OrderNotifyClinician="N"}
			var OrderDIACatRowId=GetColumnData("OrderDIACatRowId",Row);
			//医保类别
			var OrderInsurCatRowId=GetColumnData("OrderInsurCatRowId",Row);
			//医嘱首日次数
			var OrderFirstDayTimes="";
			//如果是生成取药医嘱,自备药长嘱只生成执行记录,如果是自备药即刻
			if (((OrderPriorRowid==LongOrderPriorRowid)||(OrderPriorRowid==OMSOrderPriorRowid))&&(PAAdmType=="I")) {
				OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
			}
			//医保适应症
			var OrderInsurSignSymptomCode=GetColumnData("OrderInsurSignSymptomCode",Row);
				
				//身体部位
		    var OrderBodyPart=GetColumnData("OrderBodyPart",Row);
		    if (OrderBodyPart!="") {
		    	if (OrderDepProcNotes!="") {
		    		OrderDepProcNotes=OrderDepProcNotes+","+OrderBodyPart;
		    	}else{
		    		OrderDepProcNotes=OrderBodyPart;
		    	}
		    }
		    
			//医嘱阶段
		    var OrderStageCode=GetColumnData("OrderStage",Row);
		    //输液滴速
		    var OrderSpeedFlowRate=GetColumnData("OrderSpeedFlowRate",Row);
		    
		    var OrderLabEpisodeNo=GetColumnData("OrderLabEpisodeNo",Row);
				
			//营养药标志
			var OrderNutritionDrugFlag=GetColumnData("OrderNutritionDrugFlag",Row);
			if (OrderNutritionDrugFlag==true){OrderNutritionDrugFlag="Y"}else{OrderNutritionDrugFlag="N"}
				
			var LinkedMasterOrderRowid=GetColumnData("LinkedMasterOrderRowid",Row);
			if ((VerifiedOrderMasterSeqNo!="")&&(OrderMasterSeqNo=="")) OrderMasterSeqNo=VerifiedOrderMasterSeqNo;
			if ((VerifiedOrderMasterRowid!="")&&(LinkedMasterOrderRowid=="")) LinkedMasterOrderRowid=VerifiedOrderMasterRowid;
			
		    //审批类型
		    var OrderInsurApproveType=GetColumnData("OrderInsurApproveType",Row);
		    //临床路径步骤
		    var OrderCPWStepItemRowId=GetColumnData("OrderCPWStepItemRowId",Row);
			//高值材料条码—使用隐藏的,防止页面上OrderMaterialBarcode的扫描之后被篡改
			var OrderMaterialBarCode=GetColumnData("OrderMaterialBarcodeHiden",Row);
			//输液滴速单位
		    var OrderFlowRateUnit=GetColumnData("OrderFlowRateUnit",Row);
		    
		    //输液次数  2013-04-24
			var OrderLocalInfusionQty=GetColumnData("OrderLocalInfusionQty",Row);
			//开医嘱日期
			var OrderDate=GetColumnData("OrderDate",Row);
			//开医嘱时间
			var OrderTime=GetColumnData("OrderTime",Row);
			//需要配液
			var OrderNeedPIVAFlag=GetColumnData("OrderNeedPIVAFlag",Row);
			if (OrderNeedPIVAFlag==true){OrderNeedPIVAFlag="Y"}else{OrderNeedPIVAFlag="N"}
			// 管制药品申请
			var OrderAntibApplyRowid=GetColumnData("OrderAntibApplyRowid",Row);
			
			//使用目的
			var UserReasonId=GetColumnData("UserReasonId",Row);
			
			var ShowTabStr=GetColumnData("ShowTabStr",Row);
			//抗生素使用原因
		    var AntUseReason=GetColumnData("AntUseReason",Row);
			// 协议包装,2014-05-30,by xp
			var OrderPackUOMRowid=GetColumnData("OrderPackUOMRowid",Row);


		    var OrderQtySum="";
		    if (OrderType=="R"){
				  var freq=GetColumnData("OrderFreqFactor",Row);   
					var dur=GetColumnData("OrderDurFactor",Row);
				  var Interval=GetColumnData("OrderFreqInterval",Row);
					if ((Interval!="") && (Interval!=null)) {
						var convert=Number(dur)/Number(Interval)
						var fact=(Number(dur))%(Number(Interval));
						if (fact>0) {
							fact=1;
						} else {
							fact=0;
						}
						dur=Math.floor(convert)+fact;
					}	
					if (freq=="") freq=1;
				  OrderQtySum=parseFloat(OrderDoseQty)*parseFloat(dur)*parseFloat(freq);
				  OrderQtySum=OrderQtySum.toFixed(4);
				  //dhcsys_alert(OrderQtySum);
		    }else{
		    	if ((OrderType=="L")&&(OrderPackQty=="")){OrderPackQty=1}
		    	OrderQtySum=OrderPackQty;
		    	OrderPackQty="";
		    }
		    var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
		    OrderPriorRowid=ReSetOrderPriorRowid(OrderPriorRowid,OrderPriorRemarks);
			if (OrderDoseQty==""){OrderDoseUOMRowid=""}
			var OrderBySelfOMFlag=GetColumnData("OrderBySelfOMFlag",Row);	
			if (OrderBySelfOMFlag){OrderBySelfOMFlag="Y"}else{OrderBySelfOMFlag="N"}
			//超限疗程原因
			var ExceedReasonID=GetColumnData("ExceedReasonID",Row);
			//科研项目
			var OrderPilotProRowid=GetColumnData("OrderPilotProRowid",Row);
			
			if (PAAdmType=="I") {
				if (CFIPPilotPatAdmReason!="") BillTypeRowid=CFIPPilotPatAdmReason;
			}else{
				if (CFPilotPatAdmReason!="") BillTypeRowid=CFPilotPatAdmReason;
			}
		    OrderItem=OrderARCIMRowid+"^"+OrderType+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderStartTime+"^"+OrderPackQty+"^"+OrderPrice;
		    OrderItem=OrderItem+"^"+OrderRecDepRowid+"^"+BillTypeRowid+"^"+OrderDrugFormRowid+"^"+OrderDepProcNotes;
		    OrderItem=OrderItem+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderQtySum+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderInstrRowid;
		    OrderItem=OrderItem+"^"+PHPrescType+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+OrderSkinTest+"^"+OrderPhSpecInstr+"^"+OrderCoverMainIns;
		    OrderItem=OrderItem+"^"+OrderActionRowid+"^"+OrderARCOSRowid+"^"+OrderEndDate+"^"+OrderEndTime+"^"+OrderLabSpecRowid+"^"+OrderMultiDate;
		    OrderItem=OrderItem+"^"+OrderNotifyClinician+"^"+OrderDIACatRowId+"^"+OrderInsurCatRowId+"^"+OrderFirstDayTimes+"^"+OrderInsurSignSymptomCode;
		    OrderItem=OrderItem+"^"+OrderStageCode+"^"+OrderSpeedFlowRate+"^"+AnaesthesiaID+"^"+OrderLabEpisodeNo;
		   	OrderItem=OrderItem+"^"+LinkedMasterOrderRowid+"^"+OrderNutritionDrugFlag;
		   	OrderItem=OrderItem+"^"+OrderMaterialBarCode+"^^"+OrderCPWStepItemRowId+"^"+OrderInsurApproveType;
		   	OrderItem=OrderItem+"^"+OrderFlowRateUnit+"^"+OrderDate+"^"+OrderTime+"^"+OrderNeedPIVAFlag+"^"+OrderAntibApplyRowid+"^"+AntUseReason+"^"+UserReasonId;
			OrderItem=OrderItem+"^"+OrderLocalInfusionQty+"^"+OrderBySelfOMFlag+"^"+ExceedReasonID+"^"+OrderPackUOMRowid+"^"+OrderPilotProRowid;
			
		    if (OrderItemStr==""){OrderItemStr=OrderItem}else{OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem}
				//dhcsys_alert(OrderName+"^"+OrderItem);
				/*转成DHCDocOrderCommon.mac后台生成只有安徽省立医院还用以下的处理
				if (PAAdmType=="I"){
					var FormatOrderInstrRowid="^"+OrderInstrRowid+"^";
					//dhcsys_alert(FormatOrderInstrRowid+"&"+OneOrderPriorInstrs);
			    if ((CreateOneOrder=="1")&&(GetOneOrderPriorQtyMethod!="")&&(OrderPriorRowid==LongOrderPriorRowid)&&(OrderType=="R")&&(PHPrescType!="3")&&(OneOrderPriorInstrs.indexOf(FormatOrderInstrRowid)!=-1)){
						//自动生成取药医嘱
						var OneOrderPriorQty=cspRunServerMethod(GetOneOrderPriorQtyMethod,OrderFreqRowid,OrderStartTime);

						//dhcsys_alert(OneOrderPriorQty);
						//如果过了最后的分发时间点?则不用生成取药医嘱
						//if (OneOrderPriorQty<0) {OneOrderPriorQty=Math.abs(OneOrderPriorQty)}
						//if (OneOrderPriorQty!=0){
						if (OneOrderPriorQty>0){
							for (var j=0;j<OneOrderPriorQty;j++) {
								MaxSeqNo=parseInt(MaxSeqNo)+1;
								OrderSeqNo=MaxSeqNo;
								OrderMasterSeqNo="";
							  OrderQtySum=parseFloat(OrderDoseQty)*parseFloat(dur);
							  OrderQtySum=OrderQtySum.toFixed(4);
								OrderFreqRowid=STFreqRowid;
						    OneOrderItem=OrderARCIMRowid+"^"+OrderType+"^"+OneOrderPriorRowid+"^"+OrderStartDate+"^"+OrderStartTime+"^"+OrderPackQty+"^"+OrderPrice;
						    OneOrderItem=OneOrderItem+"^"+OrderRecDepRowid+"^"+BillTypeRowid+"^"+OrderDrugFormRowid+"^"+OrderDepProcNotes;
						    OneOrderItem=OneOrderItem+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderQtySum+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderInstrRowid;
						    OneOrderItem=OneOrderItem+"^"+PHPrescType+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+OrderSkinTest+"^"+OrderPhSpecInstr+"^"+OrderCoverMainIns;
						    OneOrderItem=OneOrderItem+"^"+OrderActionRowid+"^"+OrderARCOSRowid+"^"+"^"+"^"+"^"+"^"+"^"+"^"+OrderInsurCatRowId+"^";
						    OrderItemStr=OrderItemStr+String.fromCharCode(1)+OneOrderItem;
						    //dhcsys_alert(OrderItemStr);
							}
						}	    	
			    }
			  }
			  */
			  
			}
		}
	}catch(e){dhcsys_alert(e.message)}
	return OrderItemStr;
}
function InsertOrderItem(OrderItemStr,StopConflictFlag){
	var UserAddRowid="";
	var UserAddDepRowid="";
	var DoctorRowid="";
  UserAddRowid=session['LOGON.USERID'];
  UserAddDepRowid=session['LOGON.CTLOCID']; 
  //如果登陆人为医生?就加入医生?如果登陆人为护士?并替医生录入?还是加入医生
  //如果登陆人为护士?而且没有选择医生?就加入护士
  if (LogonDoctorType=="DOCTOR"){
  	DoctorRowid=LogonDoctorID;
  }else{
    var obj=document.getElementById('DoctorID');
  	if (obj) DoctorRowid=obj.value;
  	if (DoctorRowid=="") {DoctorRowid=LogonDoctorID;}
  }
  //dhcsys_alert(OrderItemStr+"----"+UserAddRowid+"^"+UserAddDepRowid+"^"+DoctorRowid);
	var ret=cspRunServerMethod(InsertOrderItemMethod,EpisodeID,OrderItemStr,UserAddRowid,UserAddDepRowid,DoctorRowid,StopConflictFlag)
	return ret;
	
}
function SaveOrderItems(OrderItemStr,XHZYRetCode,StopConflictFlag){
	var UserAddRowid="";
	var UserAddDepRowid="";
	var DoctorRowid="";
  UserAddRowid=session['LOGON.USERID'];
  UserAddDepRowid=session['LOGON.CTLOCID']; 
  //如果登陆人为医生?就加入医生?如果登陆人为护士?并替医生录入?还是加入医生
  //如果登陆人为护士?而且没有选择医生?就加入护士
  if (LogonDoctorType=="DOCTOR"){
  	DoctorRowid=LogonDoctorID;
  }else{
    var obj=document.getElementById('DoctorID');
  	if (obj) DoctorRowid=obj.value;
  	if (DoctorRowid=="") {DoctorRowid=LogonDoctorID;}
  }

  //dhcsys_alert(OrderItemStr+"----"+UserAddRowid+"^"+UserAddDepRowid+"^"+DoctorRowid);
	var ret=cspRunServerMethod(SaveOrderItemsMethod,EpisodeID,OrderItemStr,UserAddRowid,UserAddDepRowid,DoctorRowid,XHZYRetCode,StopConflictFlag)
	return ret;
	
}
function AddClickHandler() {
	try {
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var ret=CanAddRow(objtbl);
		if (ret){
	    AddRowToList(objtbl);
	  }
    //可以控制屏幕不跳动
    return false;
	} catch(e) {};
}
function CanAddRow(objtbl){
	var rows=objtbl.rows.length;
  if (rows==1) return false;
	var Row=GetRow(rows-1);
	var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	if (OrderARCIMRowid==""){	
		SetFocusColumn("OrderName",Row);
		FocusRowIndex=rows-1;
		return false;
	}
	return true;
}
function DeleteClickHandler() {
	try {
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var ret=CanDeleteRow(objtbl,FocusRowIndex);
		if (ret){
	    DeleteTabRow(objtbl,FocusRowIndex);
	  }
	  //add by zhouzq 2005.07.07 for recalculate sum
	  SetScreenSum()
	  if (objtbl.rows.length==2) {FocusRowIndex=1}else{FocusRowIndex=0}
	  XHZY_Click();	
    //control the screen not move
    return false;
	} catch(e) {};
}
function CanDeleteRow(objtbl,SelRowIndex){
	if (SelRowIndex==0) return false;
	var rows=objtbl.rows.length;
  if (rows==1) return false;
	var Row=GetRow(SelRowIndex);
	var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	if (OrderItemRowid!=""){	return false;}
	return true;
}
function DeleteTabRow(objtbl,SelRowIndex){
	if (SelRowIndex==0) return false;
	var rows=objtbl.rows.length;
	DeleteMasterSub(SelRowIndex);
	//DeleteAntibApply(SelRowIndex);
	DeleteAntReason(SelRowIndex)
	
	if (rows>2){
		var Row=GetRow(SelRowIndex);
		ChangeChildRowStyle(SelRowIndex);
		objtbl.deleteRow(SelRowIndex);
	}else{
		var objlastrow=objtbl.rows[rows-1];
		var rowitems=objlastrow.all; //IE only

		var Row=GetRow(1);
		var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
		var CurrDateTimeArr=CurrDateTime.split("^");
		var StartDate=CurrDateTimeArr[0];
		var StartTime=CurrDateTimeArr[1];
		ClearRow(1);
		ChangeRowStyle(objlastrow,1,true);
		SetColumnData("OrderStartDate",Row,StartDate);
		SetColumnData("OrderStartTime",Row,StartTime);
		SetColumnData("OrderPrior",Row,DefaultOrderPriorRowid);
		SetColumnData("OrderPriorRowid",Row,DefaultOrderPriorRowid);
		
		SetFocusColumn("OrderName",Row);
		ChangeCellsDisabledStyle(Row,false);
	}
}
function DeleteMasterSub(CurrentRow)
{
	var CurrentSeqNo=GetColumnData("OrderSeqNo",CurrentRow);
	var OldStr='!'+CurrentSeqNo+'!';
	var ExpPara=new RegExp("("+OldStr+")","g");
	CheckMasterNoStr=CheckMasterNoStr.replace(ExpPara,"!");
}

function AddRowToList(objtbl) {
	var rows=objtbl.rows.length;
	var objlastrow=objtbl.rows[rows-1];
	//make sure objtbl is the tbody element,
	//之所以要走tk_getTBody?是因为TBody不包括THead,而且TBody只有appendChild,但只用通过rowobj才能取得TBody
	//tUDHCOEOrder_List_Custom是包括THeader和Tbody
	//tUDHCOEOrder_List_Custom.rows和TBody.rows是不同的?后者一般比前者少1
	objtbody=tk_getTBody(objlastrow);
	//dhcsys_alert(objtbl.innerHTML);
	//objtbl=websys_getParentElement(objlastrow);
	objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
	    //rowitems其实是element的集合,每个element的ParentElement就是Tabelobj.RowObj.Cell对象
	    //将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
			/*
			if (arrId[0]=="OrderPrior"){
				var obj=websys_getParentElement(rowitems[j]); 
				var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"width:" + obj.style.width +"\" value=\"\">";
        obj.innerHTML=str;
			} 
			*/
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}

	objnewrow=objtbody.appendChild(objnewrow);
	ChangeRowStyle(objnewrow,1,true);

	//默认置上前一条的医嘱类型	
	if (objtbl.rows.length>2) {
		var PreRow=GetRow(objtbl.rows.length-2);
		var PreOrderPriorRowid=GetColumnData("OrderPriorRowid",PreRow);
		var PreOrderPHPrescType=GetColumnData("OrderPHPrescType",PreRow);
		var PreOrderDurRowid=GetColumnData("OrderDurRowid",PreRow);
		
		var PreOrderSeqNo=GetColumnData("OrderSeqNo",PreRow);
		//如果是门诊开医嘱?不要把上一条记录医嘱类型带下来
		if (PAAdmType!="I"){
		   PreOrderPriorRowid=DefaultOrderPriorRowid;
		}
	}

	
	var Row=GetRow(objnewrow.rowIndex);
	if (PreOrderPriorRowid!=""){
		SetColumnData("OrderPrior",Row,PreOrderPriorRowid);
		SetColumnData("OrderPriorRowid",Row,PreOrderPriorRowid);
	}
	SetColumnData("OrderSeqNo",Row,parseInt(PreOrderSeqNo)+1);
	var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
	var CurrDateTimeArr=CurrDateTime.split("^");
	SetColumnData("OrderStartDate",Row,CurrDateTimeArr[0]);
	SetColumnData("OrderStartTime",Row,CurrDateTimeArr[1]);	
	SetColumnData("OrderSkinTest",Row,false);	
	SetColumnData("OrderNotifyClinician",Row,false);	
	if ((PAAdmType=="I")&&(HospitalCode!="ZGYKDFSYY")&&(HospitalCode!="SZZYY")) SetColumnData("OrderCoverMainIns",Row,true);	
	//将焦点放在名称上
	if (OrderNameColumnIndex<OrderPriorColumnIndex){
		websys_setfocus("OrderNamez"+Row);
	}else{
		websys_setfocus("OrderPriorz"+Row);
		websys_setfocus("OrderNamez"+Row);
	}
	FocusRowIndex=objnewrow.rowIndex;

	//dhcsys_alert("add:"+FocusRowIndex);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
	ChangeCellsDisabledStyle(Row,false);
}

function ChangeRowStyle(RowObj,EnablePackQty,EnableDuration){
	for (var j=0;j<RowObj.cells.length;j++) {
      if (!RowObj.cells[j].firstChild) {continue} 
		  var Id=RowObj.cells[j].firstChild.id;
			var arrId=Id.split("z");
		  var objindex=arrId[1];
		  var objwidth=RowObj.cells[j].style.width;
		  var objheight=RowObj.cells[j].style.height;
		  var IMGId="ldi"+Id;
      //dhcsys_alert("type:"+RowObj.cells[j].firstChild.type)
      //var objtype=RowObj.cells[j].firstChild.type;
      //if (objtype) {continue}
		
			//dhcsys_alert(RowObj.cells[j].style.height);
			/*
			1.RowObj.cells[i]本身是个对象,本身有Style属性,里面可以包含多个element(HIDDEN TableItem就全放在了一个Cell中)
			2.cells[j].firstChild是Cell里的第一个element,如果为label的话就没有type属性
			3.将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
      4.只有列不为Display only?不一定会有Style属性(可以参见网页源码),所以最好只将Display Only的列变为可编辑时候
        对innerHTML属性进行重新定义,否则容易造成列自动变为一个默认长度
      */
      
			if (arrId[0]=="OrderPrior"){
          if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  //cells[j].className="DentalSel";
				 //dhcsys_alert(owObj.cells[j].className);
				  //dhcsys_alert(RowObj.cells[j].innerHTML);
				  //dhcsys_alert(RowObj.cells[j].style.height);
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"OrderPriorchangehandler()\" onkeydown=\"OrderPriorkeydownhandler()\">";
          //dhcsys_alert(str);
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorArray=OrderPriorStr.split("^");
		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[2],OrderPrior[0]);
		         }
		         //obj.onchange=PrescList_Change;
		      }
          //dhcsys_alert(RowObj.cells[j].innerHTML);
			}
			
			if (arrId[0]=="OrderPriorRemarks"){
          if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"OrderPriorRemarkschangehandler()\">";
          
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorRemarksArray=OrderPriorRemarksStr.split("^");
		         obj.options[obj.length] = new Option("","");
		         for (var i=0;i<OrderPriorRemarksArray.length;i++) {
		         	 var OrderPriorRemarks=OrderPriorRemarksArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPriorRemarks[2],OrderPriorRemarks[1]);
		         }
		      }
			}
			
			
			if (arrId[0]=="OrderName"){
				  objwidth=AdjustWidth(objwidth);
				  //\""+objindex+"\"
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"xItem_lookuphandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"xItem_lookuphandler()\">";
          //dhcsys_alert(str);
          RowObj.cells[j].innerHTML=str;
          /*也可以采用下面的方式定义事件
					var obj=document.getElementById(Id);
					if (obj) obj.onkeydown=Item_lookuphandler;
					var obj=document.getElementById(IMGId);
					if (obj) obj.onclick=Item_lookuphandler;
					*/
			}
			if (arrId[0]=="OrderDoseQty"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\"\" onchange=\"OrderDoseQtychangehandler()\" onkeypress=\"OrderDoseQtykeypresshandler()\" onkeydown=\"OrderDoseQtykeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
			}

			if (arrId[0]=="OrderDoseUOM"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderDoseUOMchangehandler()\">";
          RowObj.cells[j].innerHTML=str;
          ClearAllList(RowObj.cells[j].firstChild);
			}
			if (arrId[0]=="OrderFreq"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCFRDesc_lookuphandler()\" onchange=\"FrequencyChangeHandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCFRDesc_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderInstr"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCINDesc_lookuphandler()\" onchange=\"InstrChangeHandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCINDesc_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderDur"){
					objwidth=AdjustWidth(objwidth);
					//住院的草药还需要录入疗程?开即刻医嘱
					//if ((PAAdmType!="I")||((OrderPHPrescType=="3")&&(PAAdmType=="I"))){
					if (EnableDuration){
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCDUDesc_lookuphandler()\" onchange=\"DurationChangeHandler()\">";
						str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCDUDesc_lookuphandler()\">";
          }else{
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          }
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderPackQty"){
				  if (EnablePackQty==1) {
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\"\" onkeydown=\"OrderPackQtykeydownhandler()\" onkeypress=\"OrderPackQtykeypresshandler()\" onchange=\"OrderPackQtychangehandler()\">";
          }else{
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          }
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderRecDep"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderRecDepchangehandler()\" onkeydown=\"OrderRecDepkeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
          ClearAllList(RowObj.cells[j].firstChild);
			}
			if (arrId[0]=="OrderMasterSeqNo"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderSeqNochangehandler()\" onkeydown=\"OrderSeqNokeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
			}

			if (arrId[0]=="OrderDepProcNote"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\"  onkeydown=\"OrderDepProcNotekeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
			}

			if (arrId[0]=="OrderBodyPart"){
         if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\">";
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorArray=MRCBodyPartStr.split("^");
		         obj.options[obj.length] = new Option("","");

		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[2],OrderPrior[2]);
		         }
		      }
			}

			if (arrId[0]=="OrderStage"){
         if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\">";
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorArray=OrderStageStr.split("^");
		         obj.options[obj.length] = new Option("","");
		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[1],OrderPrior[0]);
		         }
		      }
			}			
			if (arrId[0]=="OrderStartDate"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onkeydown=\"OEORISttDat_lookuphandler()\" onchange=\"OEORISttDat_changehandler()\" value=\"\" >";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OEORISttDat_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderStartTime"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OEORISttTim_changehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderEndDate"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onkeydown=\"OEORIEndDat_lookuphandler()\" onchange=\"OEORIEndDat_changehandler()\" value=\"\" >";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OEORIEndDat_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderEndTime"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OEORIEndTim_changehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
		
			if (arrId[0]=="OrderDate"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onkeydown=\"OEORIDat_lookuphandler()\" onchange=\"OEORIDat_changehandler()\" value=\"\" >";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OEORIDat_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderTime"){
				  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OEORITim_changehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderPrice"){
				  //if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderAutoCalculate"){
				  //if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" checked=true>";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderPhSpecInstr"){
				  if (EnablePackQty==1) {
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
            RowObj.cells[j].innerHTML=str;
          }else{
					  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
						var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\">";
	          RowObj.cells[j].innerHTML=str;
	          obj=RowObj.cells[j].firstChild;
	          if (obj){
							 var PhSpecInstrArray=new Array();
							 var PhSpecInstrArray=PhSpecInstrList.split("^");
							 obj.options[obj.length] = new Option("","");
							 for (var i=0;i<PhSpecInstrArray.length;i++) {
									var TempArray=new Array();
									var TempArray=PhSpecInstrArray[i].split(String.fromCharCode(1));
									obj.options[obj.length] = new Option(TempArray[1],TempArray[1]);
							 }
			      }
          }
			}			
			if (arrId[0]=="OrderAction"){
          if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"OrderActionchangehandler()\">";
          //dhcsys_alert(str);
          RowObj.cells[j].innerHTML=str;
          obj=RowObj.cells[j].firstChild;
          if (obj){
		         var OrderPriorArray=OrderActionStr.split("^");
		         obj.options[obj.length] = new Option("","");
		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[2],OrderPrior[0]);
		         }
		      }
			}
			if (arrId[0]=="OrderLabSpec"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}							
			if (arrId[0]=="OrderLabEpisodeNo"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderSkinTest"){
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onpropertychange=\"OrderSkinTestChangehandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderMultiDate"){
					objwidth=AdjustWidth(objwidth);
					var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onclick=\"OrderMultiDateClickhandler()\"></A>";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"  onclick=\"OrderMultiDateClickhandler()\">";
					//RowObj.cells[j].firstChild.href+"\"
          //<A id="OrderMultiDatez1" HREF="websys.csp?TEVENT=t50151iOrderSelectMultiDate&TPAGID=715717&TWKFL=50002&TWKFLI=1&TRELOADID=130361" style="WIDTH: 51px; HEIGHT: 22px" tabIndex="999"><img SRC="../images/websys/lookupdate.gif" BORDER="0"></A>
          RowObj.cells[j].innerHTML=str;
			}							
			if (arrId[0]=="OrderNotifyClinician"){
				  //if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\">";
          RowObj.cells[j].innerHTML=str;

			}
			if (arrId[0]=="AddRemark"){
				  objwidth=AdjustWidth(objwidth);
					var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"AddRemarkClickhandler("+objindex+")\"></A>";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/update.gif\"  onclick=\"AddRemarkClickhandler("+objindex+")\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderDIACat"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderDIACatchangehandler()\">";
          RowObj.cells[j].innerHTML=str;
          ClearAllList(RowObj.cells[j].firstChild);
			}
			if (arrId[0]=="OrderFirstDayTimes"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeypress=\"keypressisnumhandler()\" onchange=\"OrderFirstDayTimeschangehandler()\" onkeydown=\"OrderFirstDayTimeskeydownhandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderInsurCat"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderInsurCat_lookuphandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"OrderInsurCat_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderInsurSignSymptom"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderInsurSignSymptom_lookuphandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"OrderInsurSignSymptom_lookuphandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderSpeedFlowRate"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\"\" onchange=\"OrderSpeedFlowRate_changehandler()\" onkeypress=\"OrderSpeedFlowRatekeypresshandler()\">";
					RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderLocalInfusionQty"){
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\"\" onkeypress=\"keypressisnumhandler()\" onchange=\"OrderLocalInfusionQty_changehandler()\">";
					RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderFlowRateUnit"){
					if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
					var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"OrderFlowRateUnitchangehandler()\">";
					//dhcsys_alert(str);
					RowObj.cells[j].innerHTML=str;
					obj=RowObj.cells[j].firstChild;
					if (obj){
						 var OrderFlowRateUnitArray=OrderFlowRateUnitStr.split("^");
						 obj.options[obj.length] = new Option("","");
						 for (var i=0;i<OrderFlowRateUnitArray.length;i++) {
							 var OrderFlowRateUnit=OrderFlowRateUnitArray[i].split(String.fromCharCode(1));
							obj.options[obj.length] = new Option(OrderFlowRateUnit[2],OrderFlowRateUnit[0]);
						 }
					}
			}
			if (arrId[0]=="OrderNeedPIVAFlag"){
				var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onclick=\"OrderNeedPIVAFlagChangehandler()\">";
				RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderBySelfOMFlag"){
				var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onclick=\"OrderBySelfOMFlagChangehandler()\">";
				RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="AntUseReason"){
				if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
				var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" >";
				//dhcsys_alert(str);
				RowObj.cells[j].innerHTML=str;
				obj=RowObj.cells[j].firstChild;
				if (obj){
					 var AntUseReasonArray=AntUseReasonStr.split("^");
					 obj.options[obj.length] = new Option("","");
					 
					 for (var i=0;i<AntUseReasonArray.length;i++) {
						 var AntUseReason=AntUseReasonArray[i].split(String.fromCharCode(1));
					   obj.options[obj.length] = new Option(AntUseReason[2],AntUseReason[0]);
							}
				  } 
			}
			if (arrId[0]=="UserReason"){
				  objwidth=AdjustWidth(objwidth);
				  var str=""     //"<input type=button id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderInsurSignSymptom_lookuphandler()\">";
				  str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"UserReasonClick()\">";
          		  RowObj.cells[j].innerHTML=str;
			}
			//超量疗程原因
			if (arrId[0]=="ExceedReason"){
			  if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
			  var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
			  var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"ExceedReasonchangehandler()\">";
        	  RowObj.cells[j].innerHTML=str;
        	  obj=RowObj.cells[j].firstChild;
        	  if (obj){
					var GetExceedReasonArray=GetExceedStr.split("^");
					obj.options[obj.length] = new Option("","");
					for (var i=0;i<GetExceedReasonArray.length;i++) {
						 var ExceedReason=GetExceedReasonArray[i].split(String.fromCharCode(1));
						 obj.options[obj.length] = new Option(ExceedReason[1],ExceedReason[0]);
						}
				}
			}
			//高值耗材
			if (arrId[0]=="OrderMaterialBarcode"){
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"; ime-mode:disabled\" value=\"\" onchange=\"OrderMaterialBarcode_changehandler()\"  onkeydown=\"OrderMaterialBarcode_changehandler()\">";
						RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderPackUOM"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderPackUOMchangehandler()\">";
					RowObj.cells[j].innerHTML=str;
					ClearAllList(RowObj.cells[j].firstChild);
			}
			//药理项目
			if (arrId[0]=="OrderPilotPro"){
				var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderPilotProchangehandler()\" onkeydown=\"OrderPilotProkeydownhandler()\">";
				RowObj.cells[j].innerHTML=str;
				obj=RowObj.cells[j].firstChild;
				if (obj) obj.disabled=true;
				ClearAllList(obj);
			}
		
		}
}

function OrderMultiDateClickhandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var datestr=GetColumnData("OrderMultiDate",Row);
		var url='dhcoeorder.selectmultidate.csp?ID=OrderMultiDate&DATEVAL=' + escape(datestr);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=300');
		return websys_cancel();
	}
}

function OrderMultiDate_lookupSelect(dateval) {
	var datestr=dateval;
	var Row=GetRow(FocusRowIndex);
	var olddatestr=GetColumnData("OrderMultiDate",Row);
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	if (olddatestr!=dateval){
		SetColumnData("OrderMultiDate",Row,datestr);
		SetPackQty(Row);
		try {
			ChangeLinkOrderMultiDate(OrderSeqNo,datestr);
			if (ShowFreqLookup==1) {websys_setfocus("OrderInstrz"+Row);}
		} catch(e) {dhcsys_alert(e.message)};
	}
	//dhcsys_alert(GetColumnData("OrderMultiDate",Row));
	//SetFocusColumn("OrderStartTime",Row);
	//websys_nexttab('4',obj.form);
}

function ChangeLinkOrderMultiDate(OrderSeqNo,OrderMultiDate){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderMultiDate",Row,OrderMultiDate);
				SetPackQty(Row);
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}


//如果有图标和元素在同一列里?要调整元素的宽度
function AdjustWidth(objwidth){
  if (objwidth!=""){
  	 var objwidtharr=objwidth.split("px")
  	 var objwidthnum=objwidtharr[0]-25;
  	 objwidth=objwidthnum+"px"
  }
	return objwidth
}

function ChangeCellStyle(ColumnName,Row,disabled){
	var CellObj=document.getElementById(ColumnName+"z"+Row);
	//dhcsys_alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){
		CellObj.disabled=disabled;
	}
}

function ChangeRowStyleToNormal(RowObj,OrderType,EnableDuration,EnableFrequence){
	for (var j=0;j<RowObj.cells.length;j++) {
			var Id=RowObj.cells[j].firstChild.id;
			var arrId=Id.split("z");
		  var objindex=arrId[1];
		  var objwidth=RowObj.cells[j].style.width;
		  var objheight=RowObj.cells[j].style.height;
		  var IMGId="ldi"+Id;

      //dhcsys_alert("id:"+Id);
      //dhcsys_alert("type:"+RowObj.cells[j].firstChild.type)
      var objtype=RowObj.cells[j].firstChild.type;
      //if (objtype) {continue}
		  
			if (arrId[0]=="OrderDoseQty"){
				  if (!EnableFrequence){
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
	        }else{
					  var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderDoseQtychangehandler()\" onkeydown=\"OrderDoseQtykeydownhandler()\">";
	        }
		      RowObj.cells[j].innerHTML=str;
			}
      
			if (arrId[0]=="OrderDoseUOM"){
					var str="<label id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderFreq"){
				  //if (OrderPHPrescType!="4"){
				  if (!EnableFrequence){
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          }else{
				  	objwidth=AdjustWidth(objwidth);
					  var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCFRDesc_lookuphandler()\" onchange=\"FrequencyChangeHandler()\">";
					  str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCFRDesc_lookuphandler()\">";
          }
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderInstr"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderDur"){
				  //if (OrderPHPrescType!="4"){
				  if (!EnableDuration){
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
	          RowObj.cells[j].innerHTML=str;
          }else{
				  	objwidth=AdjustWidth(objwidth);
					  var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"DurationChangeHandler()\" onchange=\"DurationChangeHandler()\">";
					  str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCDUDesc_lookuphandler()\">";
          }
	          
			}
			if (arrId[0]=="OrderMasterSeqNo"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderPrice"){
				  if (OrderType=="P"){
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderPricekeydownhandler()\" onchange=\"OrderPricechangehandler()\">";
          }else{
          	var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" >";
          }
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderAction"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderLabSpec"){
					var str="<select id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"OrderLabSpecchangehandler()\">";
          RowObj.cells[j].innerHTML=str;
          ClearAllList(RowObj.cells[j].firstChild);
			}
			if (arrId[0]=="OrderNotifyClinician"){
				  //if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" >";
          RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderInsurCat"){
				  objwidth=AdjustWidth(objwidth);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderInsurCat_lookuphandler()\" >";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"OrderInsurCat_lookuphandler()\">";
          	RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderSpeedFlowRate"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderFlowRateUnit"){
					var str="<label id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderNeedPIVAFlag"){
					var str="<input type=checkbox id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" >";
          RowObj.cells[j].innerHTML=str;
			}
			
			
			if (arrId[0]=="AntUseReason"){
					var str="<label id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			
			if (arrId[0]=="OrderLabEpisodeNo"){
				  if (OrderType!="L"){
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          }else{
				  	objwidth=AdjustWidth(objwidth);
					  var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderLabEpisodeNo_lookuphandler()\">";
					  str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"OrderLabEpisodeNo_lookuphandler()\">";
          }
          RowObj.cells[j].innerHTML=str;
			}			
			//超量疗程原因
		if (arrId[0]=="ExceedReason"){
					var str="<label id=\""+Id+"\" name=\""+Id+ " size=4 \" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
		}			

}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//dhcsys_alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}

function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //dhcsys_alert(CellObj.id+"^"+CellObj.tagName);
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
function SetFocusColumn(ColName,Row){
	var obj=document.getElementById(ColName+"z"+Row);
	if (obj){websys_setfocus(ColName+"z"+Row)};

}

function SetCellStyle(ColName,Row,val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
		CellObj.style.visibility=val;
	}	
}

function ClearRow(Rowindex){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var RowObj=objtbl.rows[Rowindex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
			if (rowitems[j].tagName=='LABEL'){
				if (arrId[0]!="OrderSeqNo") {
				  rowitems[j].innerText="";
				}else{
				}
			}else{
				if ((arrId[0]!="OrderPrior")&&(arrId[0]!="OrderPriorRowid")&&(arrId[0]!="OrderStartDate")&&(arrId[0]!="OrderStartTime")) {
					rowitems[j].value="";
				}else{
				}
			}
		}
	}
	SetFocusColumn("OrderName",Row);
	return Row;
}	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//dhcsys_alert("selectrow:"+selectrow);
	if (!selectrow) return;

	//FocusRowIndex是Tbody的?所以GetRow也要去Tbody的;
	FocusRowIndex=selectrow;
	//dhcsys_alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	var PatientID=document.getElementById('PatientID').value;

	var mradm=document.getElementById('mradm').value;
	//var win=top.frames['eprmenu'];
	//if (win) {
		//var frm = win.document.forms['fEPRMENU'];
		//modify by wuqk 2010-07-02 for exr framework
		//var frm=top.document.forms['fEPRMENU'];
		//modify by zzq 2010-08-31
		var frm =dhcsys_getmenuform();

        if ((frm)&&(frm != "null"))  {
					frm.EpisodeID.value = EpisodeID;
					frm.PatientID.value=PatientID;
					frm.mradm.value=mradm;
					frm.AnaesthesiaID.value=AnaesthesiaID;
        }
	//}
	if (eSrc.type=="text") eSrc.select();
	if (selectrow!=SelectedRow){
		SelectedRow=0;
	}
}

function GetRow(Rowindex){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}

var showPriorList=0;
function OrderPriorkeydownhandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	if (key==13) {
		var OrderDurObj=document.getElementById("OrderDurz"+Row);
	  var OrderPackQtyObj=document.getElementById("OrderPackQtyz"+Row);
	  var OrderStartDateObj=document.getElementById("OrderStartDatez"+Row);	
	  if (OrderStartDateObj&&(OrderStartDateObj.type=="text")){
	  	websys_setfocus("OrderStartDatez"+Row);
	  	return websys_cancel();
	  }
  	if (OrderDurObj&&(OrderDurObj.type=="text")){
  		websys_setfocus("OrderDurz"+Row);
  	}else if (OrderPackQtyObj&&(OrderPackQtyObj.type=="text")){
  		websys_setfocus("OrderPackQtyz"+Row);
  	}
	}else{
		if ((key==38)||(key==40)) {
			showPriorList=0
			//return websys_cancel();
		}
	}
}
function OrderPriorchangehandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	var selIndex=obj.selectedIndex;
	var PriorRowid="";
	
	var OldPriorRowid=GetColumnData("OrderPriorRowid",Row);
	if (selIndex!=-1) {PriorRowid=obj.options[selIndex].value;}
	 //判断已经下了出院医嘱或者已经医疗结算的不能开出出院带药以外的医嘱
  	if ((PAADMMedDischarged=="1")&&(PriorRowid!=OutOrderPriorRowid)){
  		dhcsys_alert(t['IsEstimDischarge']);
  		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
			DeleteTabRow(objtbl,FocusRowIndex);
  		return false;
  	}
	OrderPriorchangeCommon(OldPriorRowid,PriorRowid,Row);
}

function OrderPriorchangeCommon(OldPriorRowid,PriorRowid,Row){
	SetColumnData("OrderPriorRowid",Row,PriorRowid);
	var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row)
	if ((PriorRowid==LongOrderPriorRowid)&&((OrderFreqRowid==STFreqRowid)||(OrderFreqRowid==ONCEFreqRowid))){
		SetColumnData("OrderFreqRowid",Row,"");
		SetColumnData("OrderFreq",Row,"");
	}
	if (PAAdmType=="I"){
		if ((PriorRowid!=LongOrderPriorRowid)&&((OrderFreqRowid!=STFreqRowid)||(OrderFreqRowid!=ONCEFreqRowid))){
			SetColumnData("OrderFreqRowid",Row,ONCEFreqRowid);
			SetColumnData("OrderFreq",Row,ONCEFreq);		
		}		
	}
	OrderFreqRowid=GetColumnData("OrderFreqRowid",Row)
	//if (((HospitalCode=="HF")||(HospitalCode=="NB")||(HospitalCode=="SHHSPD"))&&((PriorRowid==ShortOrderPriorRowid)||(PriorRowid==OMOrderPriorRowid))&&(OrderFreqRowid!=STFreqRowid)&&(PAAdmType=="I")){
	//把从医院代码设定改为从设置去判断
	if ((IPShortOrderPriorST=="1")&&((PriorRowid==ShortOrderPriorRowid)||(PriorRowid==OMOrderPriorRowid))&&(STFreqRowid!="")&&(OrderFreqRowid!=STFreqRowid)&&(PAAdmType=="I")){
		SetColumnData("OrderFreqRowid",Row,STFreqRowid);
		SetColumnData("OrderFreq",Row,STFreq);
	}
	OrderFreqRowid=GetColumnData("OrderFreqRowid",Row)
	if ((PriorRowid==STATOrderPriorRowid)&&(OrderFreqRowid!=STFreqRowid)&&(PAAdmType=="I")){
		SetColumnData("OrderFreqRowid",Row,STFreqRowid);
		SetColumnData("OrderFreq",Row,STFreq);
	}

	if (PAAdmType=="I"){
		//选择出院带药时,设上出院带院接收科室值
		if (PriorRowid==OutOrderPriorRowid){
			var OrderOutPriorRecLocStr=GetColumnData("OrderOutPriorRecLocStr",Row);
			if (OrderOutPriorRecLocStr!=""){
				SetColumnList("OrderRecDep",Row,OrderOutPriorRecLocStr);
			}
		}
		//选择取药医嘱时,设上取药医嘱接收科室值
		if (PriorRowid==OneOrderPriorRowid){
			var OrderOnePriorRecLocStr=GetColumnData("OrderOnePriorRecLocStr",Row);
			if (OrderOnePriorRecLocStr!=""){
				SetColumnList("OrderRecDep",Row,OrderOnePriorRecLocStr);
			}
		}

		
		//由取药医嘱,出院带药切换到非出院带药时,设上普通接收科室值
		if ((PriorRowid!=OneOrderPriorRowid)&&(PriorRowid!=OutOrderPriorRowid)){
			//原来的医院没有按医嘱类型设置接受科室为了保持稳定在此分别处理
			if (HospitalCode=="ZGYKDFSYY"){
				var OrderRecLocStr=GetColumnData("OrderRecLocStr",Row);
				OrderRecLocStr=GetRecLocStrByPrior(OrderRecLocStr,PriorRowid);
				
				SetColumnList("OrderRecDep",Row,OrderRecLocStr)
			}else{
			  //if ((OldPriorRowid==OutOrderPriorRowid)||(OldPriorRowid==OneOrderPriorRowid)){
					var OrderRecLocStr=GetColumnData("OrderRecLocStr",Row);
					OrderRecLocStr=GetRecLocStrByPrior(OrderRecLocStr,PriorRowid);
				
					SetColumnList("OrderRecDep",Row,OrderRecLocStr)
				//}
				//用法定义接收科室,未定义用法接收科室,则还取原接收科室串
		    var InstrReclocStr=GetReclocByInstr(Row);
		    var OrderRecLocStr=GetRecLocStrByPrior(InstrReclocStr,PriorRowid);
				SetColumnList("OrderRecDep",Row,OrderRecLocStr);
			}
		}
	}
	if ((PriorRowid==OutOrderPriorRowid)||(PriorRowid==OneOrderPriorRowid)){
		SetPackQty(Row);
	}


	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row)
	SetRowStyleClass(FocusRowIndex,PriorRowid,OrderMasterSeqNo);
	
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	///ChangeLinkOrderPrior(OrderSeqNo,OrderPriorRowid);
	
	///疗程列如果为长期医嘱不允许修改疗程,其他可以
	var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
		//if (HospitalCode=="BJDTYY"){
		if (CFLongOrderNotAllowPackQty==1){
			var Id="OrderPackQtyz"+Row;
			var obj=document.getElementById(Id);
			var cellobj=websys_getParentElement(obj);
			if (cellobj){
				var objwidth=cellobj.style.width;
				var objheight=cellobj.style.height;
				var IMGId="ldi"+Id;
				var OrderType=GetColumnData("OrderType",Row);
				if (((PriorRowid==LongOrderPriorRowid)||(PriorRowid==OMSOrderPriorRowid))&&(OrderType=="R")){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
					cellobj.innerHTML=str;
				}else{
		    	var OrderPackQty=GetColumnData("OrderPackQty",Row);
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderPackQtykeydownhandler()\" onkeypress=\"OrderPackQtykeypresshandler()\" onchange=\"OrderPackQtychangehandler()\">";
					cellobj.innerHTML=str;
					SetColumnData("OrderPackQty",Row,OrderPackQty);
				}
			}
		}
		var OrderType=GetColumnData("OrderType",Row);
		if (OrderType=="R"){
			var Id="OrderFirstDayTimesz"+Row;
			var obj=document.getElementById(Id);
			if (obj){
				var cellobj=websys_getParentElement(obj);
				if (cellobj){
					var objwidth=cellobj.style.width;
					var objheight=cellobj.style.height;
					var IMGId="ldi"+Id;
					if ((PriorRowid==LongOrderPriorRowid)||(PriorRowid==OMSOrderPriorRowid)){
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeypress=\"keypressisnumhandler()\" onkeydown=\"OrderFirstDayTimeskeydownhandler()\" onchange=\"OrderFirstDayTimeschangehandler()\">";
						cellobj.innerHTML=str;
					}else{
						var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
						cellobj.innerHTML=str;
					}
				}
			}
		}	

		var OrderStartDate="",OrderStartTime="";

		var Id="OrderDurz"+Row;
		var obj=document.getElementById(Id);
		var cellobj=websys_getParentElement(obj);
		if (cellobj){
			var objwidth=cellobj.style.width;
			var objheight=cellobj.style.height;
			var IMGId="ldi"+Id;
			var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
			if ((((PriorRowid==LongOrderPriorRowid)||(PriorRowid==OMSOrderPriorRowid))||((PriorRowid==ShortOrderPriorRowid)&&(PAAdmType=="I")))&&(OrderPriorRemarks!="OUT")){
				var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
				cellobj.innerHTML=str;
				var OrderDur=IPDefaultDur;
				var OrderDurRowid=IPDefaultDurRowId;
				var OrderDurFactor=IPDefaultDurFactor;
				SetColumnData("OrderDur",Row,OrderDur);
				SetColumnData("OrderDurRowid",Row,OrderDurRowid);
			  SetColumnData("OrderDurFactor",Row,OrderDurFactor); 
			  var OrderType=GetColumnData("OrderType",Row);

			  ///如果药物切换为长期医嘱,则把整包装设为空
			  if (OrderType=="R")	SetColumnData("OrderPackQty",Row,'');
			  
				var OrderStartDate="",OrderStartTime="";
				if ((PriorRowid==LongOrderPriorRowid)&&(OrderType=="R")){
					RecDepRowid=GetColumnData("OrderRecDepRowid",Row);
					var ret=CheckDosingRecLoc(RecDepRowid);
					if (ret){
						var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
						var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
						var StartDateTime=cspRunServerMethod(GetDosingDateTimeMethod,"4","2",OrderItemCatRowid);
						var StartDateTimeArr=StartDateTime.split("^");
						var OrderStartDate=StartDateTimeArr[0];
						var OrderStartTime=StartDateTimeArr[1];
						//SetColumnData("OrderStartDate",Row,OrderStartDate);
						//SetColumnData("OrderStartTime",Row,OrderStartTime);	
					}
				}
	    }else{
	    	var OrderDur=GetColumnData("OrderDur",Row);
				objwidth=AdjustWidth(objwidth);
				var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\""+OrderDur+"\" onkeydown=\"PHCDUDesc_lookuphandler()\" onchange=\"DurationChangeHandler()\">";
				str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCDUDesc_lookuphandler()\">";
				cellobj.innerHTML=str;
				
				var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
				var CurrDateTimeArr=CurrDateTime.split("^");
				var OrderStartDate=CurrDateTimeArr[0];
				var OrderStartTime=CurrDateTimeArr[1];
				SetColumnData("OrderStartDate",Row,OrderStartDate);
				SetColumnData("OrderStartTime",Row,OrderStartTime);
			}
		}
	}

	if ((HospitalCode=="SDWFYY")&(PAAdmType=="I")&(OrderPriorRowid==LongOrderPriorRowid)&(OrderType=="R")){
		OrderStartTime="08:00"	
		SetColumnData("OrderStartTime",Row,OrderStartTime);
	}
	
	if (PriorRowid!=ShortOrderPriorRowid){
		SetColumnData("OrderSkinTest",Row,false);
		var ActionRowid=GetColumnData("ActionRowid",Row);
		var ActionCode=GetOrderActionCode(ActionRowid);
		if (ActionCode=="YY"){
			SetColumnData("OrderActionRowid",Row,"");
	 		SetColumnData("OrderAction",Row,"");
		}
	 	var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
		if (OrderPriorRemarks=="ONE"){
			var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		 	SetColumnData("OrderPriorRemarks",Row,"");
		}	
	}
	OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
 	if (OrderMasterSeqNo!="") {
 		ChangeCellsDisabledStyle(Row,true);
 	}
		
	ChangeLinkOrderPrior(OrderSeqNo,OrderPriorRowid,OrderStartDate,OrderStartTime);
	
	var MasterOrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
	var OrderFreq=GetColumnData("OrderFreq",Row);
	var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
	var OrderFreqDispTimeStr=GetColumnData("OrderFreqDispTimeStr",Row);
	var OrderFreqInterval=GetColumnData("OrderFreqInterval",Row);
	
	PHCFRDesc_changehandlerX(LookUpFrequencyMethod);
	ChangeLinkOrderFreq(OrderSeqNo,MasterOrderPriorRowid,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,OrderStartTime);

	SetFocusColumn("OrderName",Row);
	CheckFreqAndPackQty(Row);
}

function ChangeLinkOrderPrior(OrderSeqNo,OrderPriorRowid,OrderStartDate,OrderStartTime){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				var OldOrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
				SetColumnData("OrderPrior",Row,OrderPriorRowid);
				SetColumnData("OrderPriorRowid",Row,OrderPriorRowid);
				OrderPriorchangeCommon(OldOrderPriorRowid,OrderPriorRowid,Row);
				if (OrderStartDate!=""){
					SetColumnData("OrderStartDate",Row,OrderStartDate);
				}
				if (OrderStartTime!=""){
					SetColumnData("OrderStartTime",Row,OrderStartTime);
				}
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}

function SetRowStyleClass(RowIndex,PriorRowid,OrderMasterSeqNo){
	if ((OrderMasterSeqNo=="")&&(PAAdmType=="I")&&((HospitalCode=="JST")||(HospitalCode=="SG"))){
	//if (OrderMasterSeqNo==""){
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rowObj=objtbl.rows[FocusRowIndex];
		if (LongOrderPriorRowid==PriorRowid){
			rowObj.className='LongOrder';
			rowObj.PrevClassName="LongOrder";
		}else{
			if (rowObj.className=='clsRowSelected'){
				if (rowObj.rowIndex>0) {if (rowObj.rowIndex%2==0) {rowObj.PrevClassName="RowEven";} else {rowObj.PrevClassName="RowOdd";}}
			}else{
				if (rowObj.rowIndex>0) {if (rowObj.rowIndex%2==0) {rowObj.className="RowEven";} else {rowObj.className="RowOdd";}}
			}		
		}
	}	
}

function OrderActionchangehandler(e){
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	var selIndex=obj.selectedIndex;
	var ActionRowid=""
	if (selIndex!=-1) {ActionRowid=obj.options[selIndex].value;}
	//dhcsys_alert(Row+"^"+PriorRowid);
	SetColumnData("OrderActionRowid",Row,ActionRowid);
	var ActionCode=GetOrderActionCode(ActionRowid);
	if (ActionCode=="YY"){
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	 	if ((OrderMasterSeqNo=="")||(OrderPriorRowid==ShortOrderPriorRowid)) {
	 		SetColumnData("OrderSkinTest",Row,true);
	 	}else{
	 		SetColumnData("OrderActionRowid",Row,"");
	 		SetColumnData("OrderAction",Row,"");
	 	}
	}
	if (ActionCode=="MS") {SetColumnData("OrderSkinTest",Row,false)}
	//if (ActionCode=="YY") {SetColumnData("OrderSkinTest",Row,true)}
	//续注
	if (ActionCode=="XZ") {SetColumnData("OrderSkinTest",Row,false)}
}
function GetOrderActionCode(OrderActionRowid){
	if (OrderActionStr=="") {return ""}
	var OrderPriorArray=OrderActionStr.split("^");
	for (var i=0;i<OrderPriorArray.length;i++) {
		var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		if (OrderPrior[0]==OrderActionRowid){
			return OrderPrior[1];
		}
	}
	return "";
}
function OrderDoseUOMchangehandler(e){
	var Row=GetEventRow(e);
	var UOMListObj=websys_getSrcElement(e);
	var selIndex=UOMListObj.selectedIndex;
	var UOMRowid=""
	if (selIndex!=-1) {UOMRowid=UOMListObj.options[selIndex].value;}
	//dhcsys_alert(Row+"^"+UOMRowid);
	SetColumnData("OrderDoseUOMRowid",Row,UOMRowid);
}

function OrderDIACatchangehandler(e){
	var Row=GetEventRow(e);
	var RecDepObj=websys_getSrcElement(e);
	var selIndex=RecDepObj.selectedIndex;
	var RecDepRowid=""
	if (selIndex!=-1) {OrderDIACatRowId=RecDepObj.options[selIndex].value;}
	//dhcsys_alert(Row+"^"+RecDepRowid);
	SetColumnData("OrderDIACatRowId",Row,OrderDIACatRowId);
}

function OrderRecDepchangehandler(e){
	var Row=GetEventRow(e);
	var RecDepObj=websys_getSrcElement(e);
	var selIndex=RecDepObj.selectedIndex;
	var RecDepRowid=""
	if (selIndex!=-1) {RecDepRowid=RecDepObj.options[selIndex].value;}
	//dhcsys_alert(Row+"^"+RecDepRowid);
	SetColumnData("OrderRecDepRowid",Row,RecDepRowid);
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	
	var OrderStartDate="",OrderStartTime="";
	var OrderType=GetColumnData("OrderType",Row);
	if (((OrderPriorRowid==LongOrderPriorRowid)||(OrderPriorRowid==OMSOrderPriorRowid))&&(OrderType=="R")){
		var ret=CheckDosingRecLoc(RecDepRowid);
		if (ret){
			var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
			var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
			var StartDateTime=cspRunServerMethod(GetDosingDateTimeMethod,"4","2",OrderItemCatRowid);
			var StartDateTimeArr=StartDateTime.split("^");
			var OrderStartDate=StartDateTimeArr[0];
			var OrderStartTime=StartDateTimeArr[1];
			//SetColumnData("OrderStartDate",Row,OrderStartDate);
			//SetColumnData("OrderStartTime",Row,OrderStartTime);	
		}else{
			//在更换接收科室的时候需要重新赋值
			var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
			var CurrDateTimeArr=CurrDateTime.split("^");
			SetColumnData("OrderStartDate",Row,CurrDateTimeArr[0]);
			SetColumnData("OrderStartTime",Row,CurrDateTimeArr[1]);	
		}
	}
	GetBillUOMStr(Row);
	ChangeLinkOrderRecDep(OrderSeqNo,RecDepRowid,OrderStartDate,OrderStartTime)
}

function OrderRecDepkeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		if ((keycode==13)||(keycode==9)){
			window.event.keyCode=0;
			var Row=GetEventRow(e);
		  var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
		  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		  if ((OrderARCIMRowid!="")&&(OrderRecDepRowid!="")){
		  	window.setTimeout("AddClickHandler()",200);
			}
			return websys_cancel();
		}
	}catch(e) {}
}
function OrderDepProcNotekeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		if ((keycode==13)||(keycode==9)){
			window.event.keyCode=0;
		  window.setTimeout("AddClickHandler()",200);

			return websys_cancel();
		}
	}catch(e) {}
}
function ChangeLinkOrderRecDep(OrderSeqNo,OrderRecDepRowid,OrderStartDate,OrderStartTime){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderRecDep",Row,OrderRecDepRowid);
				SetColumnData("OrderRecDepRowid",Row,OrderRecDepRowid);
				if (OrderStartDate!=""){
					SetColumnData("OrderStartDate",Row,OrderStartDate);
					SetColumnData("OrderStartTime",Row,OrderStartTime);	
				}
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}


function OrderLabSpecchangehandler(e){
	var Row=GetEventRow(e);
	var ListObj=websys_getSrcElement(e);
	var selIndex=ListObj.selectedIndex;
	var LabSpecRowid=""
	if (selIndex!=-1) {LabSpecRowid=ListObj.options[selIndex].value;}
	//dhcsys_alert(Row+"^"+UOMRowid);
	SetColumnData("OrderLabSpecRowid",Row,LabSpecRowid);
}

function OrderSeqNokeydownhandler(e){
	var Row=GetEventRow(e);
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {

			if ((keycode==13)||(keycode==9)){
				var obj=websys_getSrcElement(e);
				if (obj.value==""){

					SetFocusColumn("OrderFreq",Row);
				}else{
					var IdOrderPackQty="OrderPackQtyz"+Row;
					var Obj=document.getElementById(IdOrderPackQty);
					if (Obj&&(Obj.type=="text")){
			  	  	 	SetFocusColumn("OrderPackQty",Row);
					}
					else{
						var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
						var NextFocusRowIndex=FocusRowIndex+1; 
						var RowObj=objtbl.rows[NextFocusRowIndex];
						if (RowObj!=undefined){
							var RowNext=GetRow(NextFocusRowIndex);
							SetFocusColumn("OrderName",RowNext)
						}else{AddRowToList(objtbl)}
						
					}
			  }
			}
	}catch(e){}
}

function OrderSeqNochangehandler(e){
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	var SeqNo=Trim(obj.value);
	OrderSeqNochangeX(obj,SeqNo,Row);
}
function OrderSeqNochangeX(obj,SeqNo,Row){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	//var rowObj=objtbl.rows[Row];
	var rowObj=objtbl.rows[FocusRowIndex];
	
	//自备药长期医嘱,长期医嘱可以在同一组里?临时医嘱,自备药临时医嘱可以在同一组里
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	if (SeqNo=="") {
		SetOrderFirstDayTimes(Row);
		ChangeCellsDisabledStyle(Row,false);
		SetRowStyleClass(FocusRowIndex,OrderPriorRowid,"");
		XHZY_Click();
		return;
	}

	var MasterOrderFreqRowid="";
	var MasterOrderDurRowid="";
	var MasterOrderInstrRowid="";
	var MasterOrderFreq="";
	var MasterOrderDur="";
	var MasterOrderInstr="";
	var MasterOrderFreqFactor=1
	var MasterOrderFreqInterval=0;
	var MasterOrderDurFactor=1;
	var MasterSeqNo="";
	var MasterOrderEndDate="";
	var MasterOrderEndTime="";
	var MasterOrderType="";
	var MasterOrderMultiDate="";
	var MasterRecDepRowId="";
	var MasterOrderStartDate="";
	var MasterOrderStartTime="";
	var MasterOrderSpeedFlowRate="";
	var MasterOrderFlowRateUnit="";
	var MasterOrderFirstDayTimes="";
	var MasterOrderDate="";
	var MasterOrderTime="";
	var MasterOrderNeedPIVAFlag=false;
	
	var MasterPrescCount=0;

  for (var i=1;i<rows;i++) {
  	var ListRow=GetRow(i);
  	var ListSeqNo=GetColumnData("OrderSeqNo",ListRow);
  	var ListOrderType=GetColumnData("OrderType",ListRow);
  	var ListOrderItemRowid=GetColumnData("OrderItemRowid",ListRow);
  	//深圳中医院开成组医嘱不能超过三组
		if ((HospitalCode=="SZZYY")&&(PAAdmType!="I")){
  		if (IsMasterOrderItem(ListSeqNo)){
				MasterPrescCount=MasterPrescCount+1;
			}
			//MasterPrescCount=parseInt(MasterPrescCount)+parseInt(GroupOrdItemSum);
			if (MasterPrescCount>3){
				dhcsys_alert("成组药品医嘱超过3组??不允许再开成组药品??");
				SetColumnData("OrderMasterSeqNo",FocusRowIndex,"")
				return;
			}
  	}
  	//已经保存过的医嘱不能被关联
  	if ((ListSeqNo==SeqNo)&&(ListOrderType=="R")&&(ListOrderItemRowid=="")){
  		MasterOrderFreqRowid=GetColumnData("OrderFreqRowid",ListRow);
  		MasterOrderFreq=GetColumnData("OrderFreq",ListRow);
   		MasterOrderFreqFactor=GetColumnData("OrderFreqFactor",ListRow);
  		MasterOrderFreqInterval=GetColumnData("OrderFreqInterval",ListRow);
  		MasterOrderPriorRowid=GetColumnData("OrderPriorRowid",ListRow);
 		
  		MasterOrderInstrRowid=GetColumnData("OrderInstrRowid",ListRow);
  		MasterOrderInstr=GetColumnData("OrderInstr",ListRow);
  		MasterOrderDurRowid=GetColumnData("OrderDurRowid",ListRow);
  		MasterOrderDur=GetColumnData("OrderDur",ListRow);
  		MasterOrderDurFactor=GetColumnData("OrderDurFactor",ListRow);
  		MasterOrderEndDate=GetColumnData("OrderEndDate",ListRow);
  		MasterOrderEndTime=GetColumnData("OrderEndTime",ListRow);
  		MasterOrderType=GetColumnData("OrderType",ListRow);
  		MasterOrderMultiDate=GetColumnData("OrderMultiDate",ListRow);
			MasterOrderFreqDispTimeStr=GetColumnData("OrderFreqDispTimeStr",ListRow);
			MasterOrderRecDepRowid=GetColumnData("OrderRecDepRowid",ListRow);
			MasterOrderStartDate=GetColumnData("OrderStartDate",ListRow);
			MasterOrderStartTime=GetColumnData("OrderStartTime",ListRow);
			MasterOrderSpeedFlowRate=GetColumnData("OrderSpeedFlowRate",ListRow);
			MasterOrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",ListRow);
  		SetColumnData("OrderMasterSeqNo",ListRow,"")
  		MasterOrderFlowRateUnit=GetColumnData("OrderFlowRateUnit",ListRow);
  		MasterOrderDate=GetColumnData("OrderDate",ListRow);
  		MasterOrderTime=GetColumnData("OrderTime",ListRow);
  		MasterOrderNeedPIVAFlag=GetColumnData("OrderNeedPIVAFlag",ListRow);
		  MasterSeqNo=SeqNo;
		  var MasterrowObj=objtbl.rows[i];
		  if (MasterrowObj) {
		  	MasterrowObj.className="MasterOrder";
		  	MasterrowObj.PrevClassName="MasterOrder";
		  	if (selectedRowObj.rowIndex==MasterrowObj.rowIndex){
			  	selectedRowObj.className="MasterOrder";
			  	selectedRowObj.PrevClassName="MasterOrder";
		  	}
		  }
		  break;
  	}
  	
  }
  
  if (MasterSeqNo!=""){
  	if ((MasterOrderType!="R")&&(HospitalCode=="SG")){
			SetRowStyleClass(FocusRowIndex,OrderPriorRowid,"")
			obj.value="";
			obj.focus();
 			return; 		
  	}
  	rowObj.className="SubOrder";
  	rowObj.PrevClassName="SubOrder";
  	
		//自备药长期医嘱,长期医嘱可以在同一组里?临时医嘱,自备药临时医嘱可以在同一组里
  	if (!(((OrderPriorRowid==LongOrderPriorRowid)||(OrderPriorRowid==OMSOrderPriorRowid))&&((MasterOrderPriorRowid==LongOrderPriorRowid)||(MasterOrderPriorRowid==OMSOrderPriorRowid)))){
  		if (!(((OrderPriorRowid==ShortOrderPriorRowid)||(OrderPriorRowid==OMOrderPriorRowid))&&((MasterOrderPriorRowid==ShortOrderPriorRowid)||(MasterOrderPriorRowid==OMOrderPriorRowid)))){
				SetColumnData("OrderPrior",Row,MasterOrderPriorRowid);
				SetColumnData("OrderPriorRowid",Row,MasterOrderPriorRowid);
				OrderPriorchangeCommon(OrderPriorRowid,MasterOrderPriorRowid,Row);
			}
  	}
  	
  	//SetColumnData("OrderPriorRowid",Row,MasterOrderPriorRowid);
  	SetColumnData("OrderFreq",Row,MasterOrderFreq);
  	SetColumnData("OrderFreqRowid",Row,MasterOrderFreqRowid);
  	SetColumnData("OrderFreqFactor",Row,MasterOrderFreqFactor);
  	SetColumnData("OrderFreqInterval",Row,MasterOrderFreqInterval);
  	SetColumnData("OrderDur",Row,MasterOrderDur);
  	SetColumnData("OrderDurRowid",Row,MasterOrderDurRowid);
  	SetColumnData("OrderDurFactor",Row,MasterOrderDurFactor);
  	
  	var InstrRowId=GetColumnData("OrderInstrRowid",Row)
  	if (!IsNotFollowInstr(InstrRowId)){
  		SetColumnData("OrderInstr",Row,MasterOrderInstr);
  		SetColumnData("OrderInstrRowid",Row,MasterOrderInstrRowid);
  	}

  	SetColumnData("OrderEndDate",Row,MasterOrderEndDate);
  	SetColumnData("OrderEndTime",Row,MasterOrderEndTime);
  	SetColumnData("OrderMultiDate",Row,MasterOrderMultiDate);
  	SetColumnData("OrderFreqDispTimeStr",Row,MasterOrderFreqDispTimeStr);
  	if (MasterOrderStartDate!="") SetColumnData("OrderStartDate",Row,MasterOrderStartDate);
  	if (MasterOrderStartTime!="") SetColumnData("OrderStartTime",Row,MasterOrderStartTime);
  	SetColumnData("OrderSpeedFlowRate",Row,MasterOrderSpeedFlowRate);
  	SetColumnData("OrderFirstDayTimes",Row,MasterOrderFirstDayTimes);
  	SetColumnData("OrderFlowRateUnit",Row,MasterOrderFlowRateUnit);
  	SetColumnData("OrderDate",Row,MasterOrderDate);
  	SetColumnData("OrderTime",Row,MasterOrderTime);
  	SetColumnData("OrderNeedPIVAFlag",Row,MasterOrderNeedPIVAFlag);
  	
  	//lxz 用法定义接收科室放在最上边。已成组的为主
  	//用法定义接收科室,未定义用法接收科室,则还取原接收科室串
		var InstrReclocStr=GetReclocByInstr(Row);
        var OrderRecLocStr=GetRecLocStrByPrior(InstrReclocStr,OrderPriorRowid);
		SetColumnList("OrderRecDep",Row,OrderRecLocStr);
  	
  	
  	//改成设置主子医嘱药品使用相同的接受科室
  	//if ((PAAdmType=="I")&&((HospitalCode=="BJDTYY")||(HospitalCode=="ZGYKDFSYY"))) {
  	var OrderType=GetColumnData("OrderType",Row);
  	var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
		
  	if ((PAAdmType=="I")&&(CFSameRecDepForGroup==1)&&(OrderType=='R')) {
   		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
 			if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(OrderPriorRemarks!="OM")){
	  		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	  		var OrderName=GetColumnData("OrderName",Row);
				var CellObj=document.getElementById("OrderRecDepz"+ListRow);
				var OrderRecDepDesc=CellObj.options[CellObj.selectedIndex].text;
				var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,1,MasterOrderRecDepRowid,PAAdmType);
				if (Check=='0'){
					dhcsys_alert(OrderName+OrderRecDepDesc+t['QTY_NOTENOUGH']);
					SetColumnData("OrderMasterSeqNo",Row,"")
					if (HospitalCode=='BJDTYY'){
				    DeleteTabRow(objtbl,FocusRowIndex);
				    return;
				  }
				}else if (Check=='-1'){
					dhcsys_alert(OrderName+OrderRecDepDesc+t['QTY_INCItemLocked']);
					return;
				}else{
					var OrderType=GetColumnData("OrderType",ListRow);
					if (OrderType!="R") return;

					var FindSubRecDep=false;
					var CellObj=document.getElementById("OrderRecDepz"+Row);
					if (CellObj){
						for (var i=0;i<CellObj.length;i++) {
						 	if (CellObj.options[i].value==MasterOrderRecDepRowid){FindSubRecDep=true}
						}
					}

					if (FindSubRecDep==false){
						dhcsys_alert(t['SubOrderRecDepNotDefine']);
						return;
					}
		  		SetColumnData("OrderRecDepRowid",Row,MasterOrderRecDepRowid);
		  		SetColumnData("OrderRecDep",Row,MasterOrderRecDepRowid);
		  	}
		  }
		}
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
    SetPackQty(Row);
  	if (PAAdmType!="I") {SetFocusColumn("OrderPackQty",Row);}
  }else{
		SetRowStyleClass(FocusRowIndex,OrderPriorRowid,"")
		obj.value="";
  	obj.focus();
  }
  OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
 	if (OrderMasterSeqNo!="") {
 		ChangeCellsDisabledStyle(Row,true);
 	}
  //同步输液次数
  ChangeLinkOrderLocalInfusionQty(Row)
  //可能会影响速度
  XHZY_Click();
}
function IsNotFollowInstr(InstrRowId){
	if (InstrRowId=="") return false;
	if (NotFollowInstr=="") return false;
	var Instr="^"+InstrRowId+"^";
	if (NotFollowInstr.indexOf(Instr)<0) return false;
	return true;
}

function OrderDoseQtychangehandler(e){
	try {
		var Row=GetEventRow(e);
	  var OrderType=GetColumnData("OrderType",Row);
	  var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
	  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	  
	  //if ((OrderType=="R")&&(OrderDoseQty!="")&&(OrderARCIMRowid!="")){
	  //存在非药品的治疗项目
	  if ((OrderDoseQty!="")&&(OrderARCIMRowid!="")){
	  	SetPackQty(Row);
	  	//websys_setfocus("OrderMasterSeqNoz"+Row);
	  }else{
	  	//websys_setfocus("OrderPackQtyz"+Row);
	  }
	}catch(e) {}
}

function OrderDoseQtykeypresshandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}

	if (((keycode>47)&&(keycode<58))||(keycode==46)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}

}

function OrderDoseQtykeydownhandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	//dhcsys_alert(keycode);
	try {
		//if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		if ((keycode==13)||(keycode==9)){
			var Row=GetEventRow(e);
		  var OrderType=GetColumnData("OrderType",Row);
		  var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		  //dhcsys_alert(OrderARCIMRowid);
		  if (OrderARCIMRowid!=""){
		  	//dhcsys_alert(OrderType+"^"+OrderDoseQty);
			  if (OrderType=="R"){
			  	//(OrderDoseQty!="")
			  	//dhcsys_alert("OrderMasterSeqNoz"+Row);
			  	XHZY_Click();
			  	websys_setfocus("OrderMasterSeqNoz"+Row);
			  }else{
			  	if (OrderPHPrescType!="4"){
			  		websys_setfocus("OrderPackQtyz"+Row);
			  	}else{
			  		websys_setfocus("OrderFreqz"+Row);
			  	}
			  }
			}
			return websys_cancel();
		}
	}catch(e) {}
}

function OrderPackQtykeypresshandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}

	if (((keycode>47)&&(keycode<58))||(keycode==46)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}
}
function OrderPackQtykeydownhandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}

	if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		try {
			if ((keycode==13)||(keycode==9)){
				var Row=GetEventRow(e);
				var OrderARCOSRowId=GetColumnData("OrderARCOSRowId",Row);
				var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
				var rows=objtbl.rows.length;
				if ((FindARCOSInputByLogonLoc==1)&&(OrderARCOSRowId!='')&&(rows>FocusRowIndex+1)){
					var NextFocusRowIndex=FocusRowIndex+1; 
					var RowNext=GetRow(NextFocusRowIndex);
					SetFocusColumn("OrderPackQty",RowNext);
					return websys_cancel();	
				}else{
					window.event.keyCode=0;
				  var OrderPackQty=GetColumnData("OrderPackQty",Row);
				  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
				  if (OrderARCIMRowid!=""){
				    var OrderType=GetColumnData("OrderType",Row);
				    if ((OrderType=="R")&&(OrderPackQtyColumnIndex<OrderDoseQtyColumnIndex)) {
				    		SetFocusColumn("OrderDoseQty",Row);
				    		return websys_cancel();
				    }			  	
	    			if ((PAAdmType=="I")||((PAAdmType!="I")&&(OrderPackQty!=""))){
				  			window.setTimeout("AddClickHandler()",200);
				  	}
					}
				}
				return websys_cancel();
			}
		}catch(e) {}
	}else{
		return websys_cancel();
	}
}
function OrderPackQtychangehandler(e){ 
	var eSrc=websys_getSrcElement(e);
	try {
		  var Row=GetEventRow(e);
		  var OrderPackQty=GetColumnData("OrderPackQty",Row);
		  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		  var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		  var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		  var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
		  if (OrderPackQty==""){OrderPackQty=0}
		  if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				var OrderPrice=GetColumnData("OrderPrice",Row);
				var OrderSum=parseFloat(OrderPrice)*parseFloat(OrderPackQty);
				OrderSum=OrderSum.toFixed(4);
				//宁波需要整包装变化过后就不要再自动计算了
				if (HospitalCode=="NB") SetColumnData("OrderAutoCalculate",Row,false);
				//如果是自备药医嘱则不用再计算金额
				if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(OrderPriorRemarks!="OM")){
					SetColumnData("OrderSum",Row,OrderSum);
					SetScreenSum();
				}
				//住院进行欠费控制
				if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(OrderPriorRemarks!="OM"))
				{
					var ScreenBillSum=GetScreenBillSum();
					if (PAAdmType=="I"){
						if(!CheckDeposit(ScreenBillSum,OrderItemRowid)){
							SetColumnData("OrderSum",Row,"0");
							SetColumnData("OrderPackQty",Row,"0")
						  	SetScreenSum()
						}	
					}
				}
		 }
			return websys_cancel();
	}catch(e) {}
}

function OrderPricekeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}

	if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		try {
			if ((keycode==13)||(keycode==9)){
				var Row=GetEventRow(e);
			  var OrderPackQty=GetColumnData("OrderPackQty",Row);
			  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			  if (OrderARCIMRowid!=""){
			  	websys_setfocus("OrderPackQtyz"+Row);
				}
				return websys_cancel();
			}
		}catch(e) {}
	}else{
		return websys_cancel();
	}
}
function OrderPricechangehandler(e){ 
	var eSrc=websys_getSrcElement(e);
	try {
			var Row=GetEventRow(e);
		  var OrderPackQty=GetColumnData("OrderPackQty",Row);
		  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		  var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		  if (OrderPackQty==""){OrderPackQty=0}
		  if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				var OrderPrice=GetColumnData("OrderPrice",Row);
				var OrderSum=parseFloat(OrderPrice)*parseFloat(OrderPackQty);
				OrderSum=OrderSum.toFixed(4);
				//dhcsys_alert(OrderSum);
				SetColumnData("OrderSum",Row,OrderSum);
				SetScreenSum();
			}
			return websys_cancel();
	}catch(e) {}
}
function OEORIDoseQty_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidCurrency(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('OEORIDoseQty');
		return websys_cancel();
	} else {
		eSrc.className='';
	}
}

function OrderSkinTestChangehandler(e){
	var ActionRowid="";
	var Row=GetEventRow(e);
  var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
	var eSrc=websys_getSrcElement(e);
	var SkinTestYY=mPiece(OrderHiddenPara,String.fromCharCode(1),0);
	if (eSrc.checked){
		if (SkinTestYY==1){
			var OrderPriorArray=OrderActionStr.split("^");
			for (var i=0;i<OrderPriorArray.length;i++) {
			 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
			 if (OrderPrior[1]=="YY"){ActionRowid=OrderPrior[0];}
			}
			SetColumnData("OrderAction",Row,ActionRowid);
			SetColumnData("OrderActionRowid",Row,ActionRowid);
		}
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		if (OrderPriorRowid!=ShortOrderPriorRowid){
			SetColumnData("OrderPrior",Row,ShortOrderPriorRowid);
			SetColumnData("OrderPriorRowid",Row,ShortOrderPriorRowid);
			OrderPriorchangeCommon(OrderPriorRowid,ShortOrderPriorRowid,Row);
		}
	}else{
		SetColumnData("OrderAction",Row,"");
		SetColumnData("OrderActionRowid",Row,"");
	}
}
function OrderFirstDayTimeschangehandler(e)
{
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);

	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
	var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
	if (OrderFreqFactor=="") OrderFreqFactor=0;
	if (parseFloat(OrderFreqFactor) < parseFloat(OrderFirstDayTimes)) {
		dhcsys_alert("首日次数不能超过频次总次数.");
		SetOrderFirstDayTimes(Row);
		OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
	}
	
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);

		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
			SetColumnData("OrderFirstDayTimes",Row,OrderFirstDayTimes);
		}
	}
}

function keypressisnumhandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}

	if ((keycode>47)&&(keycode<58)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}
}

function OrderFirstDayTimeskeydownhandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	//dhcsys_alert(keycode);
	if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))){
		try {
			return websys_cancel();
		}catch(e) {}
	}else{
		return websys_cancel();
	}
}

function OrderSpeedFlowRatekeypresshandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	if (((keycode>47)&&(keycode<58))||(keycode==46)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}
}

function ChangeLinkOrderSpeedFlowRate(OrderSeqNo,OrderSpeedFlowRate){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);

			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderSpeedFlowRate",Row,OrderSpeedFlowRate);
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function OrderSpeedFlowRate_changehandler(e) {
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);

	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	if (OrderMasterSeqNo!="") OrderSeqNo=OrderMasterSeqNo;
	var OrderSpeedFlowRate=GetColumnData("OrderSpeedFlowRate",Row);
	
	ChangeLinkOrderSpeedFlowRate(OrderSeqNo,OrderSpeedFlowRate);
}

function OrderLocalInfusionQty_changehandler(e){
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);

	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderLocalInfusionQty=GetColumnData("OrderLocalInfusionQty",Row);
	ChangeLinkOrderLocalInfusionQty(Row);
}
function ChangeLinkOrderLocalInfusionQty(Row){
	try{
		var OrderSeqNoMain=GetColumnData("OrderSeqNo",Row).replace(/(^\s*)|(\s*$)/g,'');
		var OrderMasterSeqNoMain=GetColumnData("OrderMasterSeqNo",Row).replace(/(^\s*)|(\s*$)/g,'');
		var OrderLocalInfusionQtyMain=GetColumnData("OrderLocalInfusionQty",Row).replace(/(^\s*)|(\s*$)/g,'');
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row).replace(/(^\s*)|(\s*$)/g,'');
			var OrderSeqNo=GetColumnData("OrderSeqNo",Row).replace(/(^\s*)|(\s*$)/g,'');
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
				if (OrderMasterSeqNoMain==""){
					if (OrderSeqNoMain==OrderMasterSeqNo){
						 SetColumnData("OrderLocalInfusionQty",Row,OrderLocalInfusionQtyMain);
					}
				}
				else{
					if ((OrderSeqNo==OrderMasterSeqNoMain)||(OrderMasterSeqNo==OrderMasterSeqNoMain)){
						 SetColumnData("OrderLocalInfusionQty",Row,OrderLocalInfusionQtyMain);
						}
					}
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function ChangeLinkOrderFlowRateUnit(OrderSeqNo,OrderFlowRateUnit){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);

			var OrderSeqNoMasterLink=GetColumnData("OrderSeqNo",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&((OrderMasterSeqNo==OrderSeqNo)||(OrderSeqNoMasterLink==OrderSeqNo))){	
				SetColumnData("OrderFlowRateUnit",Row,OrderFlowRateUnit);
				SetColumnData("OrderSpeedFlowRate",Row,"");
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function OrderFlowRateUnitchangehandler(e) {
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);

	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	if (OrderMasterSeqNo!="") OrderSeqNo=OrderMasterSeqNo;
	var OrderFlowRateUnit=GetColumnData("OrderFlowRateUnit",Row);
	SetColumnData("OrderSpeedFlowRate",Row,"");
	
	ChangeLinkOrderFlowRateUnit(OrderSeqNo,OrderFlowRateUnit);
}

//////////////////////////////////////////////////////////////////
function OEORISttDat_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var CellObj=document.getElementById("OrderStartDatez"+Row);
  if (CellObj.disabled) return websys_cancel();
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var objid='OrderStartDatez'+Row;
		var obj=document.getElementById(objid);
		if (!IsValidDate(obj)) return;
		//因为弹出的时间选择窗口会调用与传入的ID_lookupSelect的方法?所以如果这时不能传入当前对象的的ID?否则会找不到相应的方法
		var url='websys.lookupdate.csp?ID=OEORISttDat&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function OEORISttDat_lookupSelect(dateval) {
	var Row=GetRow(FocusRowIndex);
	var obj=document.getElementById('OrderStartDatez'+Row);
	obj.value=dateval;
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	ChangeLinkOrderStartDate(OrderSeqNo,dateval)
	SetFocusColumn("OrderStartTime",Row);
	//websys_nexttab('4',obj.form);
}

function ChangeLinkOrderStartDate(OrderSeqNo,OrderStartDate){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderStartDate",Row,OrderStartDate);
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function OEORISttDat_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return  websys_cancel();
	} else {
		var Row=GetEventRow(e);
		var OrderStartDate=GetColumnData("OrderStartDate",Row);
		OEORISttDat_lookupSelect(OrderStartDate);
		eSrc.className='';
		SetFocusColumn("OrderStartTime",Row);
	}
}

function OEORISttTim_changehandler(e) {
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		SetOrderFirstDayTimes(Row);
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		var OrderStartTime=GetColumnData("OrderStartTime",Row);
		ChangeLinkOrderStartTime(OrderSeqNo,OrderStartTime)

		SetFocusColumn("OrderName",Row);
		eSrc.className='';
	}
}

function ChangeLinkOrderStartTime(OrderSeqNo,OrderStartTime){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderStartTime",Row,OrderStartTime);
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function OEORIEndDat_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var CellObj=document.getElementById("OrderEndDatez"+Row);
  if (CellObj.disabled) return websys_cancel();
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var objid='OrderStartDatez'+Row;
		var obj=document.getElementById(objid);
		if (!IsValidDate(obj)) return;
		//因为弹出的时间选择窗口会调用与传入的ID_lookupSelect的方法?所以如果这时不能传入当前对象的的ID?否则会找不到相应的方法
		var url='websys.lookupdate.csp?ID=OEORIEndDat&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function OEORIEndDat_lookupSelect(dateval) {
	var Row=GetRow(FocusRowIndex);
	var obj=document.getElementById('OrderEndDatez'+Row);
	obj.value=dateval;
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row); 
  ChangeLinkOrderEndDate(OrderSeqNo,obj.value);
	SetFocusColumn("OrderEndTime",Row);
	//websys_nexttab('4',obj.form);
}

function OEORIEndDat_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return  websys_cancel();
	} else {
		eSrc.className='';
		SetFocusColumn("OrderEndTime",Row);
	}
}

function ChangeLinkOrderEndDate(OrderSeqNo,OrderEndDate){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderEndDate",Row,OrderEndDate);
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}

function OEORIEndTim_changehandler(e) {
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		SetFocusColumn("OrderName",Row);
		eSrc.className='';
	}
}
var dtseparator='/';
var dtformat='DMY';
function DateMsg(itemname) {
  var msg='';
  try {
	if (!IsValidDate(document.getElementById(itemname))) {
		msg+="\'" + t[itemname] + "\' " + t['XDATE'] + "\n";
		if (focusat==null) focusat=document.getElementById(itemname);
	}
	return msg;
  } catch(e) {return msg;};
}
function isLeapYear(y) {
 return ((y%4)==0)&&(!(((y%100)==0)&&((y%400)!=0)));
}function ReWriteDate(d,m,y) {
 y=parseInt(y,10);
 if (y<15) y+=2000; else if (y<100) y+=1900;
 if ((y>99)&&(y<1000)) y+=1900;
 if ((d<10)&&(String(d).length<2)) d='0'+d;
 if ((m<10)&&(String(m).length<2)) m='0'+m;
 var newdate='';
 newdate=d+'/'+m+'/'+y;
 return newdate;
}
function IsValidDate(fld) {
 var dt=fld.value;
 var re = /^(\s)+/ ; dt=dt.replace(re,'');
 var re = /(\s)+$/ ; dt=dt.replace(re,'');
 var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
 if (dt=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 dt=dt.replace(re,'/');

 for (var i=0;i<dt.length;i++) {
    var type=dt.substring(i,i+1).toUpperCase();
    if (type=='T'||type=='W'||type=='M'||type=='Y') {
       if (type=='T') {return ConvertTDate(fld);} else {return ConvertWMYDate(fld,i,type);}
       break;
    }
 }
 if ((dt.indexOf('/')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
 var dtArr=dt.split('/');
 var len=dtArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (dtArr[i]=='') return 0;
 }
 var dy,mo,yr;
 for (i=len; i<3; i++) dtArr[i]='';
 dy=dtArr[0];mo=dtArr[1];yr=dtArr[2];
 if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
 if ((String(yr).length==4)&&(yr<1840)) return 0;
 var today=new Date();
 if (yr=='') {
  yr=today.getYear();
  if (mo=='') mo=today.getMonth()+1;
 }
 if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
 if ((dy<1)||(dy>31)||(mo<1)||(mo>12)||(yr<0)) return 0;
 if (mo==2) {
  if (dy>29) return 0;
  if ((!isLeapYear(yr))&&(dy>28)) return 0;
 }
 if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
 if (isMaxedDate(dy,mo,yr)) return 0;
 fld.value=ReWriteDate(dy,mo,yr);
 websys_returnEvent();
 return 1;
}
function isMaxedDate(dy,mo,yr) {
 var maxDate = new Date();
 maxDate.setTime(maxDate.getTime() + (1000*24*60*60*1000));
 yr = parseInt(yr,10); if (yr<15) yr+=2000; else if (yr<100) yr+=1900;
 if ((yr>99)&&(yr<1000)) yr+=1900;
 var objDate = new Date(yr,mo-1,dy,0,0,0);
 if (maxDate.getTime() < objDate.getTime()) return 1;
 return 0;
}
function ConvertTDate(fld) {
 var today=new Date();
 var dt=fld.value;
 var re = /(\s)+/g ;
 dt=dt.replace(re,'');
 if (dt.charAt(0).toUpperCase()=='T') {
  xdays = dt.slice(2);
  if (xdays=='') xdays=0;
  if (isNaN(xdays)) return 0;
  if ((dt.charAt(1)=='+')&&(xdays>1000)) return 0;
  xdays_ms = xdays * 24 * 60 * 60 * 1000;
  if (dt.charAt(1) == '+') today.setTime(today.getTime() + xdays_ms);
  else if (dt.charAt(1) == '-') today.setTime(today.getTime() - xdays_ms);
  else if (dt.length>1) return 0;
  fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertWMYDate(fld,pos,type) {
 var today=new Date();
 var dt=fld.value;
 var re = /(\s)+/g ;
 dt=dt.replace(re,'');
 var x = dt.substring(0,pos);xmn=0;xyr=0;
 if (x=='') x=1;
 if (isNaN(x)) return 0;
 if (dt.substring(pos+1,dt.length)!='') return 0;
 if (type=='M') {
 while (x>11) {xyr++;x=x-12}
 xmn=today.getMonth()+eval(x);
 if (xmn>=11) {xyr++;today.setMonth(eval(xmn-12));} else {today.setMonth(xmn);}
 } else if (type=='Y') {xyr=x;
 } else {today.setTime(today.getTime() + (x * 7 * 24 * 60 * 60 * 1000));}
 if (isMaxedDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr))) return 0;
 fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr));
 websys_returnEvent();
 return 1;
 }
function ConvertNoDelimDate(dt)  {
 var len = dt.length;
 if (len%2) return dt;
 if (len>8) return dt;
 var dy=dt.slice(0,2); var mn=dt.slice(2,4); var yr=dt.slice(4);
 if (yr=='') {
  var today = new Date();
  yr=today.getYear();
 }
 var dtconv=dy+'/'+mn+'/'+yr;
 return dtconv
}
function TimeMsg(itemname) {
  var msg='';
  try {
	if (!IsValidTime(document.getElementById(itemname))) {
		msg+="\'" + t[itemname] + "\' " + t['XTIME'] + "\n";
		if (focusat==null) focusat=document.getElementById(itemname);
	}
	return msg;
  } catch(e) {return msg;};
}
var tmseparator=':';
function ReWriteTime(h,m,s) {
 var newtime='';
 if (h<10) h='0'+h;
 if (m<10) m='0'+m;
 if (s<10) s='0'+s;
 newtime=h+':'+m ;
 return newtime;
}
function IsValidTime(fld) {
 var TIMER=0;
 var tm=fld.value;
 var re = /^(\s)+/ ; tm=tm.replace(re,'');
 var re = /(\s)+$/ ; tm=tm.replace(re,'');
 var re = /(\s){2,}/g ; tm=tm.replace(re,' ');
 tm=tm.toUpperCase();
 var x=tm.indexOf(' AM');
 if (x==-1) x=tm.indexOf(' PM');
 if (x!=-1) tm=tm.substring(0,x)+tm.substr(x+1);
 if (tm=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 tm=tm.replace(re,':');
 if (isNaN(tm.charAt(0))) return ConvNTime(fld);
 if ((tm.indexOf(':')==-1)&&(tm.length>2)) tm=ConvertNoDelimTime(tm);
 symIdx=tm.indexOf('PM');
 if (symIdx==-1) {
  symIdx=tm.indexOf('AM');
  if (symIdx!=-1) {
   if (tm.slice(symIdx)!='AM') return 0;
   else {
    tm=tm.slice(0,symIdx);
    TIMER=1;
  }}
 } else {
  if (tm.slice(symIdx)!='PM') return 0;
  else {
   tm=tm.slice(0,symIdx);
   TIMER=2;
  }
 }
 if (tm=='') return 0;
 var tmArr=tm.split(':');
 var len=tmArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (tmArr[i]=='') return 0;
 }
 var hr=tmArr[0];
 var mn=tmArr[1];
 var sc=tmArr[2];
 if (len==1) {
  mn=0;
  sc=0;
 } else if (len==2) {
  if (mn.length!=2) return 0;
  sc=0;
 } else if (len==3) {
  if (mn.length!=2) return 0;
  if (sc.length!=2) return 0;
 }
 if ((hr>12)&&(TIMER==1)) return 0;
 if ((hr==12)&&(TIMER==1)) hr=00;
 if ( isNaN(hr)||isNaN(mn)||isNaN(sc) ) return 0;
 hr=parseInt(hr,10);
 mn=parseInt(mn,10);
 sc=parseInt(sc,10);
 if ((hr>23)||(hr<0)||(mn>59)||(mn<0)||(sc>59)||(sc<0)) return 0;
 if ((hr<12)&&(TIMER==2)) hr+=12;
 fld.value=ReWriteTime(hr,mn,sc);
 websys_returnEvent();
 return 1;
}
function ConvNTime(fld) {
 var now=new Date();
 var tm=fld.value;
 var re = /(\s)+/g ;
 tm=tm.replace(re,'');
 if (tm.charAt(0).toUpperCase()=='N') {
  xmin = tm.slice(2);
  if (xmin=='') xmin=0;
  if (isNaN(xmin)) return 0;
  xmin_ms = xmin * 60 * 1000;
  if (tm.charAt(1) == '+') now.setTime(now.getTime() + xmin_ms);
  else if (tm.charAt(1) == '-') now.setTime(now.getTime() - xmin_ms);
  else if (tm.length>1) return 0;
  fld.value=ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertNoDelimTime(tm)  {
 if (isNaN(tm)) return tm;
 var hr=tm.slice(0,2);
 var mn=tm.slice(2);
 var tmconv=hr+':'+mn;
 return tmconv
}
var curydecimalsym='.';
var curygroupsym=',';
function IsValidCurrency(p)  {
	var CurrencyEntered=p.value;
	// js doesn't recognise grouping symbols when doing isNaN, remove grouping symbols
	// for check. These will be reset in CurrencyRound
	var strCheckNum=CurrencyEntered.replace(/\,/g, '');
	var CurrNoGrpSym=CurrencyEntered.replace(/\,/g, '');
	if (('.'==',')&&(strCheckNum.indexOf('.')!=-1)) {
		//js doesn't recognise dec. comma, only dec. point.
		strCheckNum=strCheckNum.replace(/\,/g, '.');
	}
	if (isNaN(strCheckNum)) return false;
	var IntegerPart='';
	// Ignore any spaces passed
	CurrencyEntered=CurrencyEntered.replace(/\ /g, '');
	if ((CurrencyEntered.indexOf('.'))!=-1) {
		var AryCurrencyEntered=CurrencyEntered.split('.');
		if (AryCurrencyEntered.length>2) {
			return false;
		} else if (AryCurrencyEntered.length==2) {
			//If decimal symbol is entered and decimal part is blank, number is invalid
			if (AryCurrencyEntered[1] == '') return false;
			//If a grouping symbol appears in the decimal part, number is invalid
			if (AryCurrencyEntered[1].indexOf(',')!=-1) return false;
			IntegerPart=AryCurrencyEntered[0];
		} else {
			if (AryCurrencyEntered[0]) IntegerPart=AryCurrencyEntered[0];
		}
	} else {
		IntegerPart=CurrencyEntered;
	}
	if ((IntegerPart!='')&&((IntegerPart.indexOf(','))!=-1)) {
		var ArrIntegerPart=IntegerPart.split(',');
		//If first element of array is blank then a leading grouping symbol has been passed
		if (ArrIntegerPart[0] == '') return false;
		// j set to 1 since 1st element [0] can be shorter than 3, all other groups must be 3.
		for (var j=1; j<ArrIntegerPart.length; j++) {
			if (ArrIntegerPart[j].length != 3) return false
		}
	}
	p.value=CurrencyRound(MedtrakCurrToJSMath(CurrNoGrpSym));
	websys_returnEvent();
	return true;
}

///////////////////////////////////////////////////////////////////////////
function GetEventRow(e)
{
	var obj=websys_getSrcElement(e);
	var Id=obj.id;

	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	return Row
}

var ShowFreqLookup=0;
function PHCFRDesc_lookuphandler(e) {
	if (evtName=='OrderFreq') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	ShowFreqLookup=0;
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var CellObj=document.getElementById("OrderFreqz"+Row);
  if (CellObj.disabled) return websys_cancel();
	var obj=websys_getSrcElement(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))){
		
		//*********************************BJXHYY 2011.12.21********************************************
		var Id='OrderFreqz'+Row;	
		if ((type=='keydown')&&(key==13)&&(obj.value!="")&&(OrderRowAry[Row]!=undefined)){
    	var oldOrderFreq=OrderRowAry[Row]["OrderFreq"];
    	if (oldOrderFreq==obj.value) {
    		FreqNextFocus(Row);
				return websys_cancel();	
			}
		}

		ShowFreqLookup=1;
		var FreqName=GetColumnData('OrderFreq',Row);
		if (PHCFRDesczLookupGrid&&PHCFRDesczLookupGrid.store) {
			PHCFRDesczLookupGrid.searchAndShow([FreqName,PAAdmType]);
		}else {
			//鼠标操作为全查询
			if (type=='click') FreqName="";
			
			PHCFRDesczLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "频次选择",
				lookupName: Id,
				listClassName: 'web.DHCDocOrderCommon',	
				listQueryName: 'LookUpFrequency',
				listProperties: [FreqName,PAAdmType],
				listeners:{'selectRow': FrequencyLookUpSelect},
				pageSize: 10
			});	
		}
		return websys_cancel();		
		//*********************************************************************************************
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0)&&(Hospital=="ZNDXXYEY")){
			ShowFreqLookup=1
			SetColumnData("OrderFreqRowid",Row,"");
			var Id='OrderFreqz'+Row;
			var obj=document.getElementById(Id);
			if (obj.value!='') {
				var tmp=document.getElementById(Id);
				if (tmp) {var p1=tmp.value } else {var p1=''};
				var ret=cspRunServerMethod(LookUpSingleFrequencyMethod,'FrequencyLookUpSelect','',p1)
				if (ret==1) {
					return websys_cancel();
				}
				if (ret=='0') {
					obj.className='clsInvalid';
					websys_setfocus(Id);
					return websys_cancel();	
				}
			}
			obj.className='';

			//ShowFreqLookup=1;
			//PHCFRDesc_changehandlerX(LookUpFrequencyMethod);
			//return;
		}

		var url='websys.lookup.csp';
		url += "?ID=d157iPHCFRDesc1";
		//url += "&CONTEXT=Kweb.PHCFreq:LookUpFrequency";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookUpFrequency";
		url += "&TLUJSF=FrequencyLookUpSelect";
		if (type=='click') {
			if (obj) url += "&P1=" ;
		}else{
			var obj=document.getElementById('OrderFreqz'+Row);
			if (obj) url += "&P1=" + websys_escape(obj.value);
		}
		ShowFreqLookup=1;
		websys_lu(url,1,'');
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==1)){
				websys_setfocus("OrderInstrz"+Row);
		}
	}		
}
function FrequencyLookUpSelect(value) {
	//dhcsys_alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusRowIndex);
	try {
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		var OldPriorRowid=OrderPriorRowid
    var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
    var OrderFreq=Split_Value[0];
    var OrderFreqFactor=Split_Value[2];
    var OrderFreqInterval=Split_Value[3];
    var OrderFreqRowid=Split_Value[4];
    var OrderFreqDispTimeStr=Split_Value[5];
		SetColumnData("OrderFreq",Row,OrderFreq);
		SetColumnData("OrderFreqFactor",Row,OrderFreqFactor);
		SetColumnData("OrderFreqInterval",Row,OrderFreqInterval);
		SetColumnData("OrderFreqRowid",Row,OrderFreqRowid);
		SetColumnData("OrderFreqDispTimeStr",Row,OrderFreqDispTimeStr);
	
		var obj=document.getElementById('OrderFreqz'+Row);
		if (obj) {
		  	obj.className='';
		}
		var MasterOrderPriorRowid="";
		if ((PAAdmType=="I")&&(OrderPriorRowid!=OutOrderPriorRowid)){
			if((OrderFreqRowid==STFreqRowid)||(OrderFreqRowid==ONCEFreqRowid)){
				SetColumnData("OrderPrior",Row,ShortOrderPriorRowid);
				SetColumnData("OrderPriorRowid",Row,ShortOrderPriorRowid);
				MasterOrderPriorRowid=ShortOrderPriorRowid;
			}else{
				SetColumnData("OrderPrior",Row,LongOrderPriorRowid);
				SetColumnData("OrderPriorRowid",Row,LongOrderPriorRowid);
				MasterOrderPriorRowid=LongOrderPriorRowid;
			}
		}
		
		if ((OrderPriorRowid==OMSOrderPriorRowid)&&(OrderFreqRowid==STFreqRowid)){
			SetColumnData("OrderPrior",Row,OMOrderPriorRowid);
			SetColumnData("OrderPriorRowid",Row,OMOrderPriorRowid);
			MasterOrderPriorRowid=OMOrderPriorRowid;
		}
		
		if ((PAAdmType=="I")&&(OrderFreqRowid!=STFreqRowid)){
			//HF认为临时医嘱只有ST的用法,非ST者是长期医嘱
			if (HospitalCode=="HF"){
				if (OrderPriorRowid==OMSOrderPriorRowid){
					SetColumnData("OrderPrior",Row,OMOrderPriorRowid);
					SetColumnData("OrderPriorRowid",Row,OMOrderPriorRowid);
					MasterOrderPriorRowid=OMOrderPriorRowid;
				}
				if (OrderPriorRowid==ShortOrderPriorRowid){
					SetColumnData("OrderPrior",Row,LongOrderPriorRowid);
					SetColumnData("OrderPriorRowid",Row,LongOrderPriorRowid);
					MasterOrderPriorRowid=LongOrderPriorRowid;
				}
			}
			//即刻医嘱只有ST的用法非ST就改成临时医嘱因为在计费时即刻医嘱只算一次
			if (OrderPriorRowid==STATOrderPriorRowid){
				SetColumnData("OrderPrior",Row,ShortOrderPriorRowid);
				SetColumnData("OrderPriorRowid",Row,ShortOrderPriorRowid);
				MasterOrderPriorRowid=ShortOrderPriorRowid;
			}
		}
		var PriorRowid=GetColumnData("OrderPriorRowid",Row);
		if (OldPriorRowid!=PriorRowid) OrderPriorchangeCommon(OldPriorRowid,PriorRowid,Row);
		var MasterOrderStartTime="",MasterOrderStartDate="";
		if(OrderFreqRowid==STFreqRowid){
			var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
			var CurrDateTimeArr=CurrDateTime.split("^");
			var MasterOrderStartTime=CurrDateTimeArr[1];
			SetColumnData("OrderStartTime",Row,MasterOrderStartTime);
		}
		
		//websys_nextfocusElement(obj);
		SetPackQty(Row);
		ChangeLinkOrderFreq(OrderSeqNo,MasterOrderPriorRowid,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,MasterOrderStartTime);
		var type="";
		//if (window.event) type=websys_getType(e);
		if ((ShowFreqLookup==1)&&(type!='change')) {websys_setfocus("OrderInstrz"+Row);}
	} catch(e) {dhcsys_alert(e.message)};
}

function ChangeLinkOrderFreq(OrderSeqNo,OrderPriorRowid,OrderFreqRowid,OrderFreq,OrderFreqFactor,OrderFreqInterval,OrderFreqDispTimeStr,OrderStartTime){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderFreq",Row,OrderFreq);
				SetColumnData("OrderFreqRowid",Row,OrderFreqRowid);
		    SetColumnData("OrderFreqFactor",Row,OrderFreqFactor);
		    SetColumnData("OrderFreqInterval",Row,OrderFreqInterval);
		    SetColumnData("OrderFreqDispTimeStr",Row,OrderFreqDispTimeStr);
		    var OldOrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
				if (OrderPriorRowid!=""){
					SetColumnData("OrderPrior",Row,OrderPriorRowid);
					SetColumnData("OrderPriorRowid",Row,OrderPriorRowid);
				}
				var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
				if (OldOrderPriorRowid!=OrderPriorRowid) OrderPriorchangeCommon(OldOrderPriorRowid,OrderPriorRowid,Row);
				if (OrderStartTime!=""){
		    	SetColumnData("OrderStartTime",Row,OrderStartTime);
		    }
				SetPackQty(Row);
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}

function FrequencyChangeHandler(){
	evtName='OrderFreq';
	var evtSrcElm=websys_getSrcElement(e);
	var TDSrc=websys_getParentElement(evtSrcElm);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	PHCFRDesc_changehandlerX(LookUpFrequencyMethod); evtTimer="";
	return;
	if (doneInit) { evtTimer=window.setTimeout("PHCFRDesc_changehandlerX('"+LookUpFrequencyMethod+"');",200); }
	else { PHCFRDesc_changehandlerX(encmeth); evtTimer=""; }
}

function PHCFRDesc_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	
	var Row=GetRow(FocusRowIndex);
	SetColumnData("OrderFreqRowid",Row,"");
	var Id='OrderFreqz'+Row;
	var obj=document.getElementById(Id);
	if (obj.value!='') {
		var tmp=document.getElementById(Id);
		if (tmp) {var p1=tmp.value } else {var p1=''};
		//if (cspRunServerMethod(encmeth,'PHCFRDesc1_lookupsel','FrequencyLookUpSelect',p1)=='0') {
		if (cspRunServerMethod(encmeth,'FrequencyLookUpSelect','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus(Id);
			return websys_cancel();
		}
	}else{
		//对于部分可录入频次的治疗材料在没有录入频次的情况下可以审核,所以需要计算一遍
		SetOrderFirstDayTimes(Row);
	}
	obj.className='';
}

var ShowDurLookup=0;
function PHCDUDesc_lookuphandler(e) {
	if (evtName=='OrderDur') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	ShowDurLookup=0;
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var obj=websys_getSrcElement(e);
	var Row=GetEventRow(e);
	var CellObj=document.getElementById("OrderDurz"+Row);
  if (CellObj.disabled) return websys_cancel();
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))){
		//*********************************BJXHYY 2011.12.21********************************************
		var Id='OrderDurz'+Row;
		if ((type=='keydown')&&(key==13)&&(obj.value!="")&&(OrderRowAry[Row]!=undefined)){
    	var oldOrderDur=OrderRowAry[Row]["OrderDur"];
    	if (oldOrderDur==obj.value) {
    			DurNextFocus(Row);
					return websys_cancel();	
				}
			}		
		
		ShowDurLookup=1;
		var DurName=GetColumnData('OrderDur',Row);
		if (PHCDUDesczLookupGrid&&PHCDUDesczLookupGrid.store) {
			PHCDUDesczLookupGrid.searchAndShow([DurName]);
		}else {
			//鼠标操作为全查询
			if (type=='click') DurName="";

			PHCDUDesczLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "疗程选择",
				lookupName: Id,
				listClassName: 'web.DHCDocOrderCommon',	
				listQueryName: 'LookUpDuration',
				listProperties: [DurName], 
				listeners:{'selectRow': DurationLookUpSelect},
				pageSize: 10
			});	
		}
		return websys_cancel();					
		//***************************************************************************************
		
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0)&&(HospitalCode="ZNDXXYEY")){
			ShowDurLookup=1
		  SetColumnData("OrderDurRowid",Row,"");
			var Id='OrderDurz'+Row;
			var obj=document.getElementById(Id);
			if (obj.value!='') {
				var tmp=document.getElementById(Id);
				if (tmp) {var p1=tmp.value } else {var p1=''};
				var ret=cspRunServerMethod(LookUpSingleDurationMethod,'DurationLookUpSelect','',p1)
				if (ret=='1') {
					return websys_cancel();
				}
				if (ret=='0') {
					obj.className='clsInvalid';
					websys_setfocus(Id);
					return websys_cancel();	
				}
			}		
		}
			
	
		var url='websys.lookup.csp';
		url += "?ID=d157iPHCDUDesc1";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookUpDuration";
		url += "&TLUJSF=DurationLookUpSelect";
		ShowDurLookup=1;
		if (type=='click'){
			url += "&P1=";
		}else{
			var obj=document.getElementById('OrderDurz'+Row);
			if (obj) url += "&P1=" + websys_escape(obj.value);
		}
		websys_lu(url,1,'');
		return websys_cancel();
	}else{
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
		if ((type=='keydown')&&(key==9)&&(OrderARCIMRowid!="")){
			if ((((HospitalCode=="HF")&&(OrderARCIMRowid!="5612||1"))||(HospitalCode!="HF"))&&(OrderPHPrescType=="3")){
 				window.setTimeout("AddClickHandler()",200);
 			}else{
		    var OrderType=GetColumnData("OrderType",Row);
		    if ((OrderType=="R")&&(OrderPackQtyColumnIndex<OrderDoseQtyColumnIndex)) {
		        window.setTimeout("AddClickHandler()",200);
		    }
    	}
		}else{
			if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==1)){
					websys_setfocus("OrderPackQtyz"+Row);
			}			
			return websys_cancel();
		}
	}
}

function DurNextFocus(Row) {
	var OrderPackQtyObj=document.getElementById("OrderPackQtyz"+Row);
	if (OrderPackQtyObj&&(OrderPackQtyObj.type=="text")){
		websys_setfocus("OrderPackQtyz"+Row);
	}else{
		window.setTimeout("AddClickHandler()",200);
	}
}
function DurationLookUpSelect(value) {
	//dhcsys_alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusRowIndex);
	try {
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		var OrderDur=unescape(Split_Value[1]);
		var OrderDurRowid=Split_Value[0];
		var OrderDurFactor=Split_Value[3];
		var obj=document.getElementById('OrderDurz'+Row);
		if (obj) {
  			obj.value=OrderDur;
		  	obj.className='';
		}
		SetColumnData("OrderDurRowid",Row,OrderDurRowid);
		SetColumnData("OrderDurFactor",Row,OrderDurFactor);
		//websys_nextfocusElement(obj);
		SetPackQty(Row);
		ChangeLinkOrderDur(OrderSeqNo,OrderDurRowid,OrderDur,OrderDurFactor);
		var OrderPackQty=GetColumnData("OrderPackQty",Row);
    var OrderType=GetColumnData("OrderType",Row);
    if ((OrderType=="R")&&(OrderPackQtyColumnIndex>OrderDoseQtyColumnIndex)) {
    		var type="";
				if (window.event) type=websys_getType(e);
        if ((ShowDurLookup==1)&&(type!='change')){websys_setfocus("OrderPackQtyz"+Row);}
    }else{			  	
			if ((PAAdmType=="I")||((PAAdmType!="I")&&(OrderPackQty!=""))){
	  			window.setTimeout("AddClickHandler()",200);
	  	}
	  }
		
	} catch(e) {};
}

function ChangeLinkOrderDur(OrderSeqNo,OrderDurRowid,OrderDur,OrderDurFactor){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderDur",Row,OrderDur);
				SetColumnData("OrderDurRowid",Row,OrderDurRowid);
				SetColumnData("OrderDurFactor",Row,OrderDurFactor);
				SetPackQty(Row);
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}
function DurationChangeHandler(e){
	evtName='OrderDur';
	var evtSrcElm=websys_getSrcElement(e);
	var TDSrc=websys_getParentElement(evtSrcElm);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	PHCDUDesc_changehandlerX(LookUpDurationMethod)
	return;
}

function PHCDUDesc_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}

	var Row=GetRow(FocusRowIndex);
  SetColumnData("OrderDurRowid",Row,"");
	var Id='OrderDurz'+Row;
	var obj=document.getElementById(Id);
	if (obj.value!='') {
		var tmp=document.getElementById(Id);
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'DurationLookUpSelect','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus(Id);
			return websys_cancel();
		}
	}
	obj.className='';
}

var ShowInstrLookup=0;
function PHCINDesc_lookuphandler(e) {
	if (evtName=='OrderInstr') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
  var Row=GetEventRow(e);
  var CellObj=document.getElementById("OrderInstrz"+Row);
  if (CellObj.disabled) return websys_cancel();
  var obj=websys_getSrcElement(e);
  //因为有可能点上一行的放大镜?这是FoucsRowIndex仍是当前行的值所以需要重新取一下
  var Rowobj=getRow(obj);
  if (Rowobj) {FocusRowIndex=Rowobj.rowIndex}
  ShowInstrLookup=0;
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))) {
		//*********************************BJXHYY 2011.12.21********************************************
		var Id='OrderInstrz'+Row;
		if ((type=='keydown')&&(key==13)&&(obj.value!="")&&(OrderRowAry[Row]!=undefined)){
    	var oldOrderInstr=OrderRowAry[Row]["OrderInstr"];
    	if (oldOrderInstr==obj.value) {
    		InstrNextFocus(Row);
					return websys_cancel();	
				}
			}	
		///将ShowInstrLookup=1以确保在弹出窗口切换焦点后InstrChangeHandler中不执行处理,其他Lookup同理
		ShowInstrLookup=1;
		var InstrName=GetColumnData('OrderInstr',Row);
		if (PHCINDesczLookupGrid&&PHCINDesczLookupGrid.store) {
			PHCINDesczLookupGrid.searchAndShow([InstrName,PAAdmType]);
		}else {
			//鼠标操作为全查询
			if (type=='click') InstrName="";

			PHCINDesczLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "用法选择",
				lookupName: Id,
				listClassName: 'web.DHCDocOrderCommon',	
				listQueryName: 'LookUpInstr',
				listProperties: [InstrName,PAAdmType], // EmployeeNo USERNAME
				listeners:{'selectRow': InstrLookUpSelect},
				pageSize: 10
			});	
		}

		return websys_cancel();		
		//*******************************************************************************************************
		
		
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0)&&(HospitalCode=="ZNDXXYEY")){
			ShowInstrLookup=1
			SetColumnData("OrderInstrRowid",Row,"");
			var Id='OrderInstrz'+Row;
			var obj=document.getElementById(Id);
			if (obj.value!='') {
				var tmp=document.getElementById(Id);
				if (tmp) {var p1=tmp.value } else {var p1=''};
				var ret=cspRunServerMethod(LookUpSingleInstrMethod,'InstrLookUpSelect','',p1)
				if (ret=='1') {
					return websys_cancel();
				}
				if (ret=='0') {
					obj.className='clsInvalid';
					websys_setfocus(Id);
					return websys_cancel();	
				}
			}	
		}

		var url='websys.lookup.csp';
		url += "?ID=d157iPHCINDesc1";
//		url += "&CONTEXT=Kweb.PHCInstruc:LookUpInstr";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookUpInstr";
		url += "&TLUJSF=InstrLookUpSelect";
		if (type=='click'){
			url += "&P1=";
		}else{
			var obj=document.getElementById('OrderInstrz'+Row);
			if (obj) url += "&P1=" + websys_escape(obj.value);
		}
		ShowInstrLookup=1;
		websys_lu(url,1,'');
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==1)){
			websys_setfocus("OrderDurz"+Row);
		  
		}
	}
}

function InstrLookUpSelect(value) {
	//dhcsys_alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusRowIndex);
	try {
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		var OrderInstr=unescape(Split_Value[1]);
		var OrderInstrRowid=Split_Value[0];
		var OrderInstrCode=Split_Value[2];
		var obj=document.getElementById('OrderInstrz'+Row);
		if (obj) {
  			obj.value=OrderInstr;
		  	obj.className='';
		}
		
		//如果有皮试用法自动选上皮试标志
		if (SkinTestInstr!=""){
			var Instr="^"+OrderInstrRowid+"^"
			if (SkinTestInstr.indexOf(Instr)!="-1"){
				SetColumnData("OrderSkinTest",Row,true);
				ChangeCellStyle("OrderSkinTest",Row,true);
			}else{
				SetColumnData("OrderSkinTest",Row,false);
				ChangeCellStyle("OrderSkinTest",Row,false);
			}
		}
    SetColumnData("OrderInstrRowid",Row,OrderInstrRowid);
 		if ((IsWYInstr(OrderInstrRowid))&&(PAAdmType!="I")){
			SetColumnData("OrderDur",Row,"");
			SetColumnData("OrderDurRowid",Row,"");
		  SetColumnData("OrderDoseQty",Row,"");
		}
    
    var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
    //用法定义接收科室,未定义用法接收科室,则还取原接收科室串
		var InstrReclocStr=GetReclocByInstr(Row);
    var OrderRecLocStr=GetRecLocStrByPrior(InstrReclocStr,OrderPriorRowid);
		SetColumnList("OrderRecDep",Row,OrderRecLocStr);
   
    ChangeLinkOrderInstr(OrderSeqNo,OrderInstrRowid,OrderInstr);
    
    SetOrderLocalInfusionQty(Row);
		//websys_nextfocusElement(obj);
		var type="";
		if (window.event) type=websys_getType(e);
		if ((ShowInstrLookup==1)&&(type!='change')) {
			var OrderDurObj=document.getElementById("OrderDurz"+Row);
		  var OrderPackQtyObj=document.getElementById("OrderPackQtyz"+Row);
		  if (OrderDurObj&&(OrderDurObj.type=="text")){
				websys_setfocus("OrderDurz"+Row);
			}else if (OrderPackQtyObj&&(OrderPackQtyObj.type=="text")){
				websys_setfocus("OrderPackQtyz"+Row);
			}else{
				window.setTimeout("AddClickHandler()",200);
			}
		}
	} catch(e) {};
}

function ChangeLinkOrderInstr(OrderSeqNo,OrderInstrRowid,OrderInstr){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
		  	var InstrRowId=GetColumnData("OrderInstrRowid",Row)
		  	if (!IsNotFollowInstr(InstrRowId)){
					SetColumnData("OrderInstr",Row,OrderInstr);
					SetColumnData("OrderInstrRowid",Row,OrderInstrRowid);
					var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
			    //用法定义接收科室,未定义用法接收科室,则还取原接收科室串
					var InstrReclocStr=GetReclocByInstr(Row);
			    var OrderRecLocStr=GetRecLocStrByPrior(InstrReclocStr,OrderPriorRowid);
					SetColumnList("OrderRecDep",Row,OrderRecLocStr);
					SetPackQty(Row);
		  	}
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}

function InstrChangeHandler(e){
	evtName='OrderInstr';
	var evtSrcElm=websys_getSrcElement(e);
	var TDSrc=websys_getParentElement(evtSrcElm);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	PHCINDesc_lookuphandlerX(LookUpInstrMethod); evtTimer="";
}

function PHCINDesc_lookuphandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var Row=GetRow(FocusRowIndex);
	SetColumnData("OrderInstrRowid",Row,"");
	var Id='OrderInstrz'+Row;
	var obj=document.getElementById(Id);
	if (obj.value!='') {
		var tmp=document.getElementById(Id);
		if (tmp) {var p1=tmp.value } else {var p1=''};
		if (cspRunServerMethod(encmeth,'InstrLookUpSelect','',p1)=='0') {
			obj.className='clsInvalid';
			SetColumnData("OrderInstrRowid",Row,"");
			websys_setfocus(Id);
			return websys_cancel();
		}

	}
	obj.className='';
}

var ItemzLookupGrid;
function xItem_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);

	if (evtName=='OrderName') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	if((key==40)&&(ItemzLookupGrid)){
			ItemzLookupGrid.getSelectionModel().selectFirstRow();;
			ItemzLookupGrid.getView().focusRow(1)
			return ;
	
	}
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		//if (!CheckDiagnose()) return;
		var obj=document.getElementById('OrderNamez'+Row);
		var OrderName=obj.value;
		var Id='OrderNamez'+Row;
		if (OrderName==""){return false}
		var OrderOldName=GetColumnData('OrderOldName',Row);
		var OrderARCIMRowid=GetColumnData('OrderARCIMRowid',Row);
		if ((type=='keydown')&&(key==13)&&(OrderName==OrderOldName)&&(OrderARCIMRowid!="")){
			websys_setfocus('OrderDoseQtyz'+Row);
			return
		}
		
		var GroupID=DHCC_GetElementData('GroupID');
		var catID=DHCC_GetElementData('catID');
		var subCatID=DHCC_GetElementData('subCatID');
		var P5="";
		var LogonDep=GetLogonLocByFlag();
		var OrderPriorRowid=DHCC_GetElementData('OrderPriorRowid');
		var P9="",P10="";
		var OrdCatGrp=DHCC_GetElementData('OrdCatGrp');
		var CurLogonDep=DHCC_GetElementData('CurLogonDep');
		if (CurLogonDep=="") CurLogonDep=session['LOGON.CTLOCID']; 
		
		if (ItemzLookupGrid&&ItemzLookupGrid.store) {
			ItemzLookupGrid.searchAndShow([OrderName,GroupID,catID,subCatID,P5,LogonDep,OrderPriorRowid,EpisodeID,P9,P10,session["LOGON.USERID"],OrdCatGrp,"",CurLogonDep]);
		}else {
			ItemzLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "医嘱项选择",
				lookupName: Id,
				listClassName: 'web.DHCDocOrderEntry',	
				listQueryName: 'LookUpItem',
				resizeColumn:true,
				listProperties: [OrderName,GroupID,catID,subCatID,P5,LogonDep,OrderPriorRowid,EpisodeID,P9,P10,session["LOGON.USERID"],OrdCatGrp,"",CurLogonDep], 
				listeners:{'selectRow': OrderItemLookupSelect},
				pageSize: 10
			});
			/*
			ItemzLookupGrid.store.on('load',function(s,r){
				var gridcount = 0;
				this.each(function (r){
					var StockQty = r.get("StockQty");
					if (StockQty=="N"){
						ItemzLookupGrid.getView().getRow(gridcount).style.backgroundColor = 'Moccasin';
						ItemzLookupGrid.getView().getRow(gridcount).style.fontStyle = 'italic';
					}
					gridcount = gridcount + 1;
				});
			});
			*/
		}
		
		return websys_cancel();

		var url='websys.lookup.csp';
		url += "?ID=d50013iOrderNamez"+Row;
		//url += "?ID=d50013iItem";
		//url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm";
		url += "&CONTEXT=Kweb.DHCDocOrderEntry:LookUpItem";
		url += "&TLUJSF=OrderItemLookupSelect";
		//var obj=document.getElementById('OrderNamez'+Row);
		//var OrderName=obj.value;
		//if (OrderName==""){return false}
		if (OrderName=="*"){OrderName=""}
		if (obj) url += "&P1=" + websys_escape(OrderName);
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById("catID");
		if (obj) url += "&P3=" + websys_escape(obj.value);
		//if (obj) url += "&P3=" ;
		var obj=document.getElementById('subCatID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		//if (obj) url += "&P4=";
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		//var obj=document.getElementById('""');
		//if (obj) url += "&P6=" + websys_escape(obj.value);
		var LogonDep=GetLogonLocByFlag();
  	//if (FindRecLocByLogonLoc=="1"){LogonDep=session['LOGON.CTLOCID']}
  	url += "&P6=" + websys_escape(LogonDep);

		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		if (obj) url += "&P7=" + websys_escape(OrderPriorRowid);
		
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		
		
	  //For ItemAuthority
		url += "&P11=" + websys_escape(session["LOGON.USERID"]);

		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P12=" + websys_escape(obj.value);

		websys_lu(url,1,'');
		//dhcsys_alert(url);
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==9)){
			var obj=websys_getSrcElement(e);
			var OrderName=obj.value;
			if (OrderName==""){
				websys_setfocus(obj.id);
			  return websys_cancel();
			}
		}
	}

}

function OrderItemLookupSelect(txt) { 
	//dhcsys_alert(txt);
	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];
	var ifreq=adata[2];
	var iordertype=adata[3];
	var ialias=adata[4];
	//OrderType for example:"R"
	var isubcatcode=adata[5];
	//dhcsys_alert("isubcatcode "+isubcatcode)
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
	//dhcsys_alert(mPiece(OSItemIDs,String.fromCharCode(12),1));
	window.focus();

  var Row=GetRow(FocusRowIndex);
  //dhcsys_alert(isubcatcode)
	if (!CheckDiagnose(isubcatcode)){
		var itemobj=document.getElementById("OrderNamez"+Row);
		if (itemobj) {
			itemobj.value="";
			websys_setfocus(itemobj.id);
		  return false;
		}
	} 
   
	if (iordertype=="ARCIM") iSetID="";
	
	var Itemids="";
  
	if(OSItemIDs=="") Itemids=icode;
	else Itemids=icode+String.fromCharCode(12)+OSItemIDs;

	//OSItemIDs is Combinded as Aricmrowid+String.fromCharCode(14)+arcimdesc, code below remove arcimdesc,left arcimrowid
	var OSItemIDArr=OSItemIDs.split(String.fromCharCode(12))
	for (var i=0;i<OSItemIDArr.length;i++) {
		if (OSItemIDArr[i].split(String.fromCharCode(14)).length > 1) OSItemIDArr[i]=OSItemIDArr[i].split(String.fromCharCode(14))[1];
	}

	OSItemIDs=OSItemIDArr.join(String.fromCharCode(12));
	//dhcsys_alert(lstOrders.length+","+icode+","+idesc+","+isubcatcode+","+iordertype+","+ialias+","+""+","+iSetID+","+iorderCatID+","+idur+","+SetRef+","+OSItemIDs+","+iorderSubCatID);
	//AgeSexRestrictionCheck(icode,idesc,isubcatcode,idur,match,"",iordertype);

	if (iordertype=="ARCIM"){
    var Para="";
    var ItemDefaultRowId=GetItemDefaultRowId(icode);
	  var ret=AddItemToList(FocusRowIndex,icode,Para,"",ItemDefaultRowId);
		if (ret==false) {
			ClearRow(FocusRowIndex);
			return websys_cancel();
		}

    var OrderType=GetColumnData("OrderType",Row);
    if (OrderType=="R") {
    	if (OrderPackQtyColumnIndex>OrderDoseQtyColumnIndex){
    		SetFocusColumn("OrderDoseQty",Row);
    	}else{
    		SetFocusColumn("OrderPackQty",Row);
    	}
    }else{
    	if (OrderType=="P") {
    		SetFocusColumn("OrderPrice",Row);
    	}else{
    		SetFocusColumn("OrderPackQty",Row);
    	}
    }
		return websys_cancel();
	}else{
		ClearRow(FocusRowIndex);
		OSItemListOpen(icode,"","YES","","");
	}

}
function OSItemListOpen(ARCOSRowid,OSdesc,del,itemtext,OrdRowIdString) {
	var Patient = "";
	var EpisodeID="";

	var patobj=document.getElementById("PatientID");
	if (patobj) Patient=patobj.value;
	var objEpisodeID=document.getElementById("EpisodeID")
	if (objEpisodeID)	EpisodeID=objEpisodeID.value;
	if (ARCOSRowid!="") {
		var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.OSItem&EpisodeID="+EpisodeID+"&ARCOSRowid="+ARCOSRowid;
		//dhcsys_alert("path="+path);
		websys_createWindow(path,"frmOSList","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=100,width=800,height=600")
	}

}
function AddCopyItemToList(ParaArr){
	var seqnoarr=new Array();
	var Count=0;
	var ArrLength=ParaArr.length;
	AuditFlag=0;
	var FirstOSRow=-1;
	AddCopyAryStr=ParaArr.join("@");
	progressBar=Ext.Msg.show({
	 title:"多条医嘱",
	 msg:"加载中...",
	 progress:true,
	 width:300,
	 wait:true,
	 modal:true
	});
 //dhcsys_alert(progressBar.getPosition());
 //progressBar.setPagePosition(200,200)
 var Task={
	 run:function () {
	 		if (Count==ArrLength) {
	 			progressBar.hide();
	 			Ext.TaskMgr.stop(Task);
	 			if ((FirstOSRow>-1)&&(FindARCOSInputByLogonLoc==1)){
					SetFocusColumn("OrderPackQty",FirstOSRow);
					return websys_cancel();
				}
				SetScreenSum();
	 		}else{
	 			//window.console.log("1:"+Count+","+(new Date()));
	 			if (ArrLength==1) {
	 				var progressRate=1;
	 			}else{
	 				var progressRate=Count/(ArrLength-1);
	 			}
	 			progressBar.updateProgress(progressRate,Math.ceil((progressRate*100))+'%');
	 			var para1Str=AddCopyAryStr.split('@')[Count];
	 			AddCopyOneItemToList(para1Str,seqnoarr);
	 			if (FirstOSRow==-1) FirstOSRow=GetRow(FocusRowIndex);
	 			var proWindow=progressBar.getDialog();
	 			proWindow.center();
	 		}
	 		Count++;
	 },
	 interval:10
 }
 Ext.TaskMgr.start(Task);
}
function AddCopyOneItemToList(para1Str,seqnoarr){
	  AddClickHandler();
	  //progressBar.updateProgress(CopyItemProgress,(CopyItemProgress)*100+'%');
    //默认置上前一条的医嘱跨院
    var Row=GetRow(FocusRowIndex);
		if (FocusRowIndex>1) {
			var PreRow=GetRow(FocusRowIndex-1);
			var PreOrderOpenForAllHosp=GetColumnData("OrderOpenForAllHosp",PreRow);
      if (PreOrderOpenForAllHosp==true){
				SetColumnData("OrderOpenForAllHosp",Row,"true");
			}
	  }
	  var para1=para1Str.split("!")
	  var icode=para1[0];
	  var seqno=para1[1];
	  var Para=para1[2];
	  var ItemOrderType=para1[3];
	  var CopyBillTypeRowId=para1[4];
	  //****************************************************
	  //update by zf 2012-05-14
	  var CopyType=para1[5];
	  var CPWStepItemRowId=para1[6];
	  var tmpList=Para.split("^");
	  var tmpOrderDepProcNote=tmpList[9];
	  /*
	  if (tmpList.length>6){
			var tmpString=tmpList[6];
			var tmpSubList=tmpString.split(String.fromCharCode(1));
			if (tmpSubList.length>2){
				tmpOrderDepProcNote=tmpSubList[2];
			}
	  }
	  */
    //****************************************************
		//update by shp
		var KSSCopyFlag=para1[7]
		if((KSSCopyFlag!="undefined")&&(KSSCopyFlag=="KSS")){
			AuditFlag=1
		}
		//var Row=GetRow(FocusRowIndex);
		if (CheckDiagnose(ItemOrderType)){
		  var ret=AddItemToList(FocusRowIndex,icode,Para,CopyBillTypeRowId,"");
	    if (ret==true){
		  	var tempseqnoarr=seqno.split(".");
		  	if (tempseqnoarr.length>1){
		  		var masterseqno=tempseqnoarr[0];
		  		if (seqnoarr[masterseqno]){
		  			//dhcsys_alert(seqnoarr[masterseqno]);
		  			var MasterArr=seqnoarr[masterseqno].split("^");
		  			newmasterseqno=MasterArr[0];
		  			var MasterOrderRecDepRowid=MasterArr[1];
		  			var MasterOrderStartTime=MasterArr[2];
		  			SetColumnData("OrderMasterSeqNo",Row,newmasterseqno);
		  			SetColumnData("OrderStartTime",Row,MasterOrderStartTime);
		  			//子医嘱接收科室是否跟随主医嘱
						var OrderType=GetColumnData("OrderType",Row);
						var iCFSameRecDepForGroup=CFSameRecDepForGroup;
						//沈阳医大只要求医嘱套接受科室一致,后改为设置
						//if ((CopyType=="OSItem")&&(HospitalCode=="ZGYKDFSYY")) iCFSameRecDepForGroup=1;
						if ((CopyType=="OSItem")&&(CFSameRecDepForARCOSGroup=="1")) iCFSameRecDepForGroup=1;
						if ((OrderType=="R")&&(MasterOrderRecDepRowid!='undefine')&&(iCFSameRecDepForGroup=="1")){
							var FindSubRecDep=false;

							var CellObj=document.getElementById("OrderRecDepz"+Row);
							if (CellObj){
								for (var j=0;j<CellObj.length;j++) {
								 	if (CellObj.options[j].value==MasterOrderRecDepRowid){FindSubRecDep=true}
								}
							}
							if (FindSubRecDep==false){
								dhcsys_alert(t['SubOrderRecDepNotDefine']);
							}else{
					  		SetColumnData("OrderRecDepRowid",Row,MasterOrderRecDepRowid);
					  		SetColumnData("OrderRecDep",Row,MasterOrderRecDepRowid);
					  	}
			  		}
			  	}
		  	}else{
		  		//因为主医嘱的时间可能会有变化,所以子医嘱的时间也要同步
			  	newseqno=GetColumnData("OrderSeqNo",Row);
			  	var MasterOrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
			  	var MasterOrderStartTime=GetColumnData("OrderStartTime",Row);
			  	seqnoarr[seqno]=newseqno+"^"+MasterOrderRecDepRowid+"^"+MasterOrderStartTime;
			  }
			//****************************************************
			//update by zf 2012-05-14
			if (CPWStepItemRowId!="undefined"){
				SetColumnData("OrderCPWStepItemRowId",Row,CPWStepItemRowId);
			}
			if (tmpOrderDepProcNote!="undefined"){
				SetColumnData("OrderDepProcNote",Row,tmpOrderDepProcNote);
			}
			//****************************************************
		    var OrderType=GetColumnData("OrderType",Row);
		    if (OrderType=="R") {
		    	if (OrderPackQtyColumnIndex>OrderDoseQtyColumnIndex){
		    		SetFocusColumn("OrderDoseQty",Row);
		    	}else{
		    		SetFocusColumn("OrderPackQty",Row);
		    	}
		    }else{
		    	if (OrderType=="P") {
		    		SetFocusColumn("OrderPrice",Row);
		    	}else{
		    		SetFocusColumn("OrderPackQty",Row);
		    	}
		    }
		    //if (FirstOSRow==-1) FirstOSRow=Row;
		    //医嘱套或者复制过来的医嘱验证关联关系
		    var Obj=document.getElementById("OrderMasterSeqNoz"+Row);
		    if (Obj&&(Obj.type=="text")){
				 var SeqNo=GetColumnData("OrderMasterSeqNo",Row);
				 SeqNo=Trim(SeqNo);
				 if (SeqNo!=""){
				 	OrderSeqNochangeX(Obj,SeqNo,Row);
				 }
			}
		  }
		}
}
function AddCopyItemToListOld(ParaArr){
	AuditFlag=0;
	var FirstOSRow=-1;
	var seqnoarr=new Array();
	var length=ParaArr.length;
  for (var i=0; i<length; i++) {
	  AddClickHandler();

    //默认置上前一条的医嘱跨院
    var Row=GetRow(FocusRowIndex);
		if (FocusRowIndex>1) {
			var PreRow=GetRow(FocusRowIndex-1);
			var PreOrderOpenForAllHosp=GetColumnData("OrderOpenForAllHosp",PreRow);
      if (PreOrderOpenForAllHosp==true){
				SetColumnData("OrderOpenForAllHosp",Row,"true");
			}
	  }

	  var para1=ParaArr[i].split("!")
	  var icode=para1[0];
	  var seqno=para1[1];
	  var Para=para1[2];
	  var ItemOrderType=para1[3];
	  var CopyBillTypeRowId=para1[4];
	  //****************************************************
	  //update by zf 2012-05-14
	  var CopyType=para1[5];
	  var CPWStepItemRowId=para1[6];
	  var tmpList=Para.split("^");
	  var tmpOrderDepProcNote="";
	  if (tmpList.length>6){
			var tmpString=tmpList[6];
			var tmpSubList=tmpString.split(String.fromCharCode(1));
			if (tmpSubList.length>2){
				tmpOrderDepProcNote=tmpSubList[2];
			}
	  }
    //****************************************************
		//update by shp
		var KSSCopyFlag=para1[7]
		if((KSSCopyFlag!="undefined")&&(KSSCopyFlag=="KSS")){
			AuditFlag=1
			}
		//var Row=GetRow(FocusRowIndex);
		if (CheckDiagnose(ItemOrderType)){
		  var ret=AddItemToList(FocusRowIndex,icode,Para,CopyBillTypeRowId,"");
	    if (ret==true){
		  	var tempseqnoarr=seqno.split(".");
		  	if (tempseqnoarr.length>1){
		  		var masterseqno=tempseqnoarr[0];
		  		if (seqnoarr[masterseqno]){
		  			//dhcsys_alert(seqnoarr[masterseqno]);
		  			var MasterArr=seqnoarr[masterseqno].split("^");
		  			newmasterseqno=MasterArr[0];
		  			var MasterOrderRecDepRowid=MasterArr[1];
		  			var MasterOrderStartTime=MasterArr[2];
		  			SetColumnData("OrderMasterSeqNo",Row,newmasterseqno);
		  			SetColumnData("OrderStartTime",Row,MasterOrderStartTime);
		  			//子医嘱接收科室是否跟随主医嘱
						var OrderType=GetColumnData("OrderType",Row);
						var iCFSameRecDepForGroup=CFSameRecDepForGroup;
						//沈阳医大只要求医嘱套接受科室一致,后改为设置
						//if ((CopyType=="OSItem")&&(HospitalCode=="ZGYKDFSYY")) iCFSameRecDepForGroup=1;
						if ((CopyType=="OSItem")&&(CFSameRecDepForARCOSGroup=="1")) iCFSameRecDepForGroup=1;
						if ((OrderType=="R")&&(MasterOrderRecDepRowid!='undefine')&&(iCFSameRecDepForGroup=="1")){
							var FindSubRecDep=false;
							
							var CellObj=document.getElementById("OrderRecDepz"+Row);
							if (CellObj){
								for (var j=0;j<CellObj.length;j++) {
								 	if (CellObj.options[j].value==MasterOrderRecDepRowid){FindSubRecDep=true}
								}
							}
							if (FindSubRecDep==false){
								dhcsys_alert(t['SubOrderRecDepNotDefine']);
							}else{
					  		SetColumnData("OrderRecDepRowid",Row,MasterOrderRecDepRowid);
					  		SetColumnData("OrderRecDep",Row,MasterOrderRecDepRowid);
					  		
					  	}
			  		}
			  	}
		  	}else{
		  		//因为主医嘱的时间可能会有变化,所以子医嘱的时间也要同步
			  	newseqno=GetColumnData("OrderSeqNo",Row);
			  	var MasterOrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
			  	var MasterOrderStartTime=GetColumnData("OrderStartTime",Row);
			  	seqnoarr[seqno]=newseqno+"^"+MasterOrderRecDepRowid+"^"+MasterOrderStartTime;
			  }
			  
			//****************************************************
			//update by zf 2012-05-14
			if (CPWStepItemRowId!="undefined"){
				SetColumnData("OrderCPWStepItemRowId",Row,CPWStepItemRowId);
			}
			if (tmpOrderDepProcNote!="undefined"){
				SetColumnData("OrderDepProcNote",Row,tmpOrderDepProcNote);
			}
			//****************************************************
		    var OrderType=GetColumnData("OrderType",Row);
		    if (OrderType=="R") {
		    	if (OrderPackQtyColumnIndex>OrderDoseQtyColumnIndex){
		    		SetFocusColumn("OrderDoseQty",Row);
		    	}else{
		    		SetFocusColumn("OrderPackQty",Row);
		    	}
		    }else{
		    	if (OrderType=="P") {
		    		SetFocusColumn("OrderPrice",Row);
		    	}else{
		    		SetFocusColumn("OrderPackQty",Row);
		    	}
		    }
		    if (FirstOSRow==-1) FirstOSRow=Row;
		  }
		}
	}
	if ((FirstOSRow>-1)&&(FindARCOSInputByLogonLoc==1)){
		SetFocusColumn("OrderPackQty",FirstOSRow);
	}
	SetScreenSum();
}

function AddLinkItemToList(ParaArr,MasterOrderItemRowId,MasterOrderSeqNo,MasterOrderPriorRowid,MasterOrderFreqStr,MasterOrderStartDate,MasterOrderStartTime)
{
	VerifiedOrderMasterRowid=MasterOrderItemRowId;
	VerifiedOrderMasterSeqNo=MasterOrderSeqNo;
	var MasterOrderStartDate=cspRunServerMethod(ConverDateMethod,MasterOrderStartDate,3,4);
	var TempOrderFreqStr=MasterOrderFreqStr.split("^");
	var MasterOrderFreqRowid=TempOrderFreqStr[0];
	var MasterOrderFreq=TempOrderFreqStr[1];
	var length=ParaArr.length;
	for (var i=0; i<length; i++) {
	  AddClickHandler();
	  var para1=ParaArr[i].split("!")
	  var icode=para1[0];
	  var seqno=para1[1];
	  var ItemOrderType=para1[2];
	  var linkqty=para1[4];
	  var LinkNotes=para1[5];
	  var Para="";
	  var CopyBillTypeRowId="";
	  var Row=GetRow(FocusRowIndex);
	  if (CheckDiagnose(ItemOrderType)){
		  var ret=AddItemToList(FocusRowIndex,icode,Para,CopyBillTypeRowId,"")
		}
	}
}

function CheckStockEnough(OrderName,OrderARCIMRowid,OrderPackQty,str){
	if (OrderPackQty==""){return "-1"}
  var ArrData=str.split(String.fromCharCode(2));
	if (ArrData.length==1){
		var ArrData1=ArrData[0].split(String.fromCharCode(1));
		var OrderRecDepRowid=ArrData1[0];
		var OrderRecDepDesc=ArrData1[1];

		var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,OrderPackQty,OrderRecDepRowid,PAAdmType);
		if (Check=='0') {
			dhcsys_alert(OrderName+OrderRecDepDesc+t['QTY_NOTENOUGH']);
			return "";
		}else if (Check=='-1'){
			dhcsys_alert(OrderName+OrderRecDepDesc+t['QTY_INCItemLocked']);
			return "";
		}else{
			return ArrData[0];
		}
	}else{
 	  var DefaultRecLocRowid="";
 	  var DefaultRecLocDesc="";
		for (var i=0;i<ArrData.length;i++) {
			var ArrData1=ArrData[i].split(String.fromCharCode(1));
			if ((ArrData1[2]=="Y")&&(DefaultRecLocRowid=="")) {
				DefaultRecLocRowid=ArrData1[0];
				DefaultRecLocDesc=ArrData1[1];
			}
		}

		if (DefaultRecLocRowid!=""){
			var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,OrderPackQty,DefaultRecLocRowid,PAAdmType);
			if ((Check!='0')&&(Check!='-1')){
				return DefaultRecLocRowid+String.fromCharCode(1)+DefaultRecLocDesc;
			}
		}

		for (var i=0;i<ArrData.length;i++) {
			var ArrData1=ArrData[i].split(String.fromCharCode(1));
			if (ArrData1[2]!="Y") {
				var OrderRecDepRowid=ArrData1[0];
				var OrderRecLocDesc=ArrData1[1];
				var Check=cspRunServerMethod(CheckStockEnoughMethod,OrderARCIMRowid,OrderPackQty,OrderRecDepRowid,PAAdmType);
				if ((Check!='0')&&(Check!='-1')) {
					//肿瘤医院潍坊住院需要由医生来确定是否改变接收科室,
					if ((HospitalCode=='YKYZLYY')||((HospitalCode=='SDWFYY')&(PAAdmType=="I"))){
						var PrescCheck=dhcsys_confirm((OrderName+t['Change_Stock_Recloc']),true);
						if (PrescCheck==false){return '';}
					}else{
						//由设置决定是否切换药房
						if (CFNotAutoChangeRecloc=='1'){
							if (Check=='0')	dhcsys_alert(OrderName+OrderRecLocDesc+t['QTY_NOTENOUGH']);
							if (Check=='-1') dhcsys_alert(OrderName+OrderRecDepDesc+t['QTY_INCItemLocked']);
							return '';
						}
						dhcsys_alert(OrderName+t['Change_Stock_Recloc']);
					}
					return ArrData[i];
				}
			}
		}
		dhcsys_alert(OrderName+t['QTY_NOTENOUGH']);
		return ""		
	}
}
function IsWYInstr(InstrRowid){
	if (InstrRowid=="") return false;
	if (WYInstr=="") return false;
	var Instr="^"+InstrRowid+"^"
	if (WYInstr.indexOf(Instr)<0) return false;
	return true;
}

function AddItemToList(RowIndex,icode,Para,CopyBillTypeRowId,ItemDefaultRowId) {	  //Add an item to a listbox
	var BillGrpDesc="";
	var ARCIMDetail="";
	var PackQty="1";
	var OrderBillTypeRowid=""
	var OrderRecDepRowid=""
	var PrescCheckinfo=""
	if (!CopyBillTypeRowId){CopyBillTypeRowId=""}

	//挪到此处与相互作用拉开一定操作时间,而且不处理医嘱套返回里的提示
	if ((DHCDTInterface==1)&&(Para=="")&&(icode!="")){  
		//CreateYDTS(icode);  
	}
	var OrdRootCheckFlag=cspRunServerMethod(OrdRootCheck,icode,session['LOGON.GROUPID']); 
	if (OrdRootCheckFlag!="Y"){dhcsys_alert("您没有权限开此类医嘱!");return false;}
	//判断医嘱项中的门急诊限制
	var CheckArcimTypeStr=cspRunServerMethod(CheckArcimType,icode,EpisodeID); 
	if (CheckArcimTypeStr!=""){dhcsys_alert(CheckArcimTypeStr);return false;}
	//如果按登录科室取接收科室?就把登录科室传进去
	var LogonDep=GetLogonLocByFlag();
	//科室用药限制监测
	var ArcimAuthorizeFlag=cspRunServerMethod(CheckArcimAuthorize,icode,session['LOGON.CTLOCID'],session['LOGON.USERID']); 
	if (ArcimAuthorizeFlag==0){dhcsys_alert("该药品在科室被限制使用");return false;}
	//临床药理用药子类检测
	var PilotCatFlag=cspRunServerMethod(CheckPilotCat,EpisodeID,icode); 
	if (PilotCatFlag!="Y"){dhcsys_alert("该药品及同属子类药品,不能被临床药理患者使用");return false;}
	
	var Row=GetRow(RowIndex);
	SetColumnData("OrderMaterialBarcodeHiden",Row,"");     //高值材料 每次都有把隐藏条码清空，到加载完成后在外部赋值
	//dhcsys_alert(EpisodeID+"^"+OrderBillTypeRowid+"^"+LogonDep+"^"+icode);
	if (PAAdmType!="I"){
	if (CopyBillTypeRowId!=""){
		OrderBillTypeRowid=CopyBillTypeRowId;
	}else{
		OrderBillTypeRowid=GetPrescBillTypeID();
	}
	}else{
		OrderBillTypeRowid=BillTypeID;
	}
	
  var OrderOpenForAllHosp=GetColumnData("OrderOpenForAllHosp",Row);
  var SessionStr=GetSessionStr();
  var EPARCIMDetail=cspRunServerMethod(GetEPARCIMDetailMehtod,EpisodeID,OrderBillTypeRowid,LogonDep,icode,OrderOpenForAllHosp,SessionStr,ItemDefaultRowId);
  //dhcsys_alert(EPARCIMDetail);
  var idesc=mPiece(EPARCIMDetail,"^",0);
  var OrderType=mPiece(EPARCIMDetail,"^",1);
  var OrderItemCatRowid=mPiece(EPARCIMDetail,"^",2);
  var InciRowid=mPiece(EPARCIMDetail,"^",4);
  var OrderPHPrescType=mPiece(EPARCIMDetail,"^",5);
  var OrderBillType=mPiece(EPARCIMDetail,"^",6);
  var iretPrice=mPiece(EPARCIMDetail,"^",7)
  var ipackqtystr=mPiece(EPARCIMDetail,"^",8);
  var ireclocstr=mPiece(EPARCIMDetail,"^",9);
  var iformstr=mPiece(EPARCIMDetail,"^",10);
  var idoseqtystr=mPiece(EPARCIMDetail,"^",11);
  var ifrequencestr=mPiece(EPARCIMDetail,"^",12);
  var iinstructionstr=mPiece(EPARCIMDetail,"^",13);
  var idurationstr=mPiece(EPARCIMDetail,"^",14);
  var idefpriorstr=mPiece(EPARCIMDetail,"^",15);
  var iordermsg=mPiece(EPARCIMDetail,"^",16);
  var realstockqty=mPiece(EPARCIMDetail,"^",17);
  var ilab=mPiece(EPARCIMDetail,"^",18);
  var iskintest=mPiece(EPARCIMDetail,"^",19);
  var iinsurinfo=mPiece(EPARCIMDetail,"^",20);
  var ilimitstr=mPiece(EPARCIMDetail,"^",21);
  var ioutpriorreclocstr=mPiece(EPARCIMDetail,"^",22);
  var iallergy=mPiece(EPARCIMDetail,"^",23);
  var ionepriorreclocstr=mPiece(EPARCIMDetail,"^",24);
  var idiagnoscatstr=mPiece(EPARCIMDetail,"^",25);
  var iother=mPiece(EPARCIMDetail,"^",26);
  var OrderItemInValid=mPiece(iother,String.fromCharCode(1),0);
  var OrderGenericName=mPiece(iother,String.fromCharCode(1),1);
  var iSpecCheckCode=mPiece(iother,String.fromCharCode(1),2);
  var AlertAuditSpecialItem=mPiece(iother,String.fromCharCode(1),3);
  var ArcimCode=mPiece(iother,String.fromCharCode(1),4);
  var OrderAuthInValid=mPiece(iother,String.fromCharCode(1),5);
  var ASCheckStr=mPiece(iother,String.fromCharCode(1),6);
  var ASCheckFlag=mPiece(ASCheckStr,String.fromCharCode(2),0);
  var ASCheckSex=mPiece(ASCheckStr,String.fromCharCode(2),1);
  var ASCheckAgeRange=mPiece(ASCheckStr,String.fromCharCode(2),2);
  self.focus();
	if (OrderItemInValid==1){
		dhcsys_alert(idesc+",医嘱项目无效！");
		return false;
	}
	if (OrderAuthInValid==0){
		dhcsys_alert(idesc+t['NOT_ORDERED']);
		return false;
	}
	if (ireclocstr=="") {
    dhcsys_alert(idesc+t['NO_RECLOC']);
		return false;
	}
  if (ASCheckFlag==1) {
	  dhcsys_alert("项目["+idesc+"]被限制使用:性别限制为:"+ASCheckSex+",年龄限制为:"+ASCheckAgeRange);
	  return false;
  }
  
  if (AlertAuditSpecialItem!=0){
  	var NeedInsuAudit=dhcsys_confirm(idesc+t['NeedInsuAudit']);
  	if (NeedInsuAudit==false)return false;
  }
  if (OrderPHPrescType==3) {
  	dhcsys_alert(t['NotEntryCNMed']);
  	return false;
  }

  var ConflictCheck=CheckConflict(icode);
	if (ConflictCheck==false) {
		return false;
	}

  var ConflictCheck=CheckDupOrderItemCat(OrderItemCatRowid);
	if (ConflictCheck==true) {
		if ((HospitalCode=='SHSDFYY')&&(OrderBillTypeRowid=='1')){
  	}else{	
			dhcsys_alert(idesc+t['ItemCatRepeat']);
			return false;
		}
	}

	//过敏检查
	var AllergyCheck=CheckItemAllergy(iallergy);
	if (AllergyCheck==false) {return false;}
	var OrderPHForm=mPiece(iformstr,String.fromCharCode(1),0);
	var OrderConFac=mPiece(iformstr,String.fromCharCode(1),2);
	var OrderDrugFormRowid=mPiece(iformstr,String.fromCharCode(1),1);
	//rowid改成PoisonCode待确定需要修改类方法
	var OrderPoisonRowid=mPiece(iformstr,String.fromCharCode(1),3);
	var OrderPoisonCode=mPiece(iformstr,String.fromCharCode(1),4);
	var OrderLabSpec=mPiece(ilab,String.fromCharCode(1),0);
	var OrderLabExCode=mPiece(ilab,String.fromCharCode(1),1);
	var OrderLabItemActive=mPiece(ilab,String.fromCharCode(1),2);
	//判断检验项目不可用
	if (OrderLabItemActive!="Y"){
		dhcsys_alert(idesc+t['LabItemUnavailable']);
		return false;
	}
	
	if (OrderType=="R"){
    	var ARCIMDetail=OrderPHPrescType+"^"+OrderPHForm+'^'+OrderPoisonCode+'^'+OrderGenericName+"^"+ilimitstr;
  		var PrescCheck=CheckPrescItemAndCount(idesc,icode,ARCIMDetail);
		if (PrescCheck==false){return false;}
	}else{  //非药物医嘱也要判断重复
		var TempNotAlertRepeatItemCat="^"+NotAlertRepeatItemCat+"^";
		var TempOrderItemCatRowid="^"+OrderItemCatRowid+"^";
		if (TempNotAlertRepeatItemCat.indexOf(TempOrderItemCatRowid)==-1) {
			var PrescCheck=CheckDupOrderItem(icode);
			if (PrescCheck==true){
				var PrescCheck=dhcsys_confirm((idesc+t['SAME_ORDERITEM']),true);
				if (PrescCheck==false){return false;}
			}
		}
		if (OrderType=="L"){
			if (OrderLabSpec==""){dhcsys_alert(t['Err_LabSpec']); return false;}
			//判断是否有样本指标重复
			if (OrderLabExCode!=""){
				var ret=CheckDupLabSpecItem(OrderLabExCode,OrderLabSpec);
				if (ret==true){return false;}
			}
		}
  }
	//微生物检验医嘱需要确定采样部位
	if ((OrderLabExCode!="")&&(HospitalCode=="ZGYKDFSYY")){
	  var encmeth=document.getElementById('GetMicrobe').value;
	  var ret=cspRunServerMethod(encmeth,OrderLabExCode)
	  if (ret=="1"){
			var encmeth=document.getElementById('ExchangeLab').value;
			cspRunServerMethod(encmeth,ilab);
			var path="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocMicrobe&Rows="+Row;
			websys_createWindow(path,false,"");
		}
	}
	if (OrderLabExCode!=""){
		if (CheckLabItemActiveMethod!=""){
			var ret=cspRunServerMethod(CheckLabItemActiveMethod,OrderLabExCode);
			if (ret!="Y"){
				dhcsys_alert(idesc+t['LabItemUnavailable']);
			}
		}
	}
  var OrderPackQty=mPiece(ipackqtystr,String.fromCharCode(1),0);
  var OrderPackUOM=mPiece(ipackqtystr,String.fromCharCode(1),1);
  var OrderPackUOMRowid=mPiece(ipackqtystr,String.fromCharCode(1),2);
  var OrderFreq=mPiece(ifrequencestr,String.fromCharCode(1),0);
  var OrderFreqRowid=mPiece(ifrequencestr,String.fromCharCode(1),1);
  var OrderFreqFactor=mPiece(ifrequencestr,String.fromCharCode(1),2);
  var OrderFreqInterval=mPiece(ifrequencestr,String.fromCharCode(1),3);
  if ((PrescCheckinfo!="")&&(PrescCheckinfo!="undefined")&&(PrescCheckinfo!=null)){
		var OrderInstr=PrescCheckinfo.split("^")[3]
		var OrderInstrRowid=PrescCheckinfo.split("^")[3]
  }else{
		var OrderInstr=mPiece(iinstructionstr,String.fromCharCode(1),0);
		var OrderInstrRowid=mPiece(iinstructionstr,String.fromCharCode(1),1);
	}
  var OrderDur=mPiece(idurationstr,String.fromCharCode(1),0);
  var OrderDurRowid=mPiece(idurationstr,String.fromCharCode(1),1);
  var OrderDurFactor=mPiece(idurationstr,String.fromCharCode(1),2);
  var OrderDefPriorRowid= mPiece(idefpriorstr,String.fromCharCode(1),1); 
  var OrderDefPrior=mPiece(idefpriorstr,String.fromCharCode(1),0); 
  var Price=mPiece(iretPrice,String.fromCharCode(1),0)
  var DiscPrice=mPiece(iretPrice,String.fromCharCode(1),1)
  var InsPrice=mPiece(iretPrice,String.fromCharCode(1),2)
  var PatPrice=mPiece(iretPrice,String.fromCharCode(1),3)
  var OrderMaxDurFactor=mPiece(ilimitstr,String.fromCharCode(1),0);
  var OrderMaxQty=mPiece(ilimitstr,String.fromCharCode(1),1);
  var OrderAlertStockQty=mPiece(ilimitstr,String.fromCharCode(1),2);
  var OrderMaxDoseQty=mPiece(ilimitstr,String.fromCharCode(1),4);
  var OrderMaxDoseQtyPerDay=mPiece(ilimitstr,String.fromCharCode(1),5);
  var OrderLimitDays=mPiece(ilimitstr,String.fromCharCode(1),6);
  var OrderMaxDoseQtyPerOrder=mPiece(ilimitstr,String.fromCharCode(1),7);
  var OrderMsg=mPiece(iordermsg,String.fromCharCode(1),0);
  var OrderFile1=mPiece(iordermsg,String.fromCharCode(1),1);
  var OrderFile2=mPiece(iordermsg,String.fromCharCode(1),2);
  var OrderFile3=mPiece(iordermsg,String.fromCharCode(1),3);
  var OrderARCOSRowid="",ARCOSSubCatRowid="";
	if (Price==0){
		//0价格提示改成设置,中医院同步后可以把下面的注释删掉  ---2009.04.02 周志强
		if (CFNotAlertZeroPrice!=1){
			var AlertZero=true;
			if (NotAlertZeroItemCatStr!=""){
				if (("^"+OrderItemCatRowid+"^").indexOf(("^"+OrderItemCatRowid+"^"))>=0){AlertZero=false}
			}
			if(AlertZero){
			  var ret=dhcsys_confirm(idesc+t['NO_PRICE']);
			  if (ret==false) return false;
			}
		}
	}

  var needskintest=mPiece(iskintest,String.fromCharCode(1),0);
  var skintestyy=mPiece(iskintest,String.fromCharCode(1),1);
  var IPNeedBillQty=mPiece(iskintest,String.fromCharCode(1),2);
  if ((HospitalCode=='SHHSPD')&&(PAAdmType=="I")&&(needskintest=="Y")){
  	////t['IPNeedSkinTest']="病人三天内无青霉素类医嘱需要做皮试请录入皮试医嘱"
	  var DelCheck=dhcsys_confirm((t['IPNeedSkinTest']),false);
	  if (DelCheck==false) {return false;}
	}
	
   //从医嘱套里传入的参数
  if (Para!=""){
  	//dhcsys_alert(Para);
    var ispecdoseqtystr=mPiece(Para,"^",0);
    var ispecfrequencestr=mPiece(Para,"^",1);
    var ispecinstructionstr=mPiece(Para,"^",2);
    var ispecdurationstr=mPiece(Para,"^",3);
    var ispecpackqtystr=mPiece(Para,"^",4);
    var ispecpriorstr=mPiece(Para,"^",5);
    var ispecordersetstr=mPiece(Para,"^",6);
    var ispecordersetsubcatstr=mPiece(Para,"^",8);
    var OrderPriorRemarksDR=mPiece(Para,"^",10);
    //****************抗生素11********************************/
    //抗菌药物  13-03-20
    var antiapplyinfostr=mPiece(Para,"^",11);               
    if(typeof(antiapplyinfostr)!="undefined"){
	    var OrderAntibApplyRowid=mPiece(antiapplyinfostr,String.fromCharCode(1),0);
	    var UserReasonID=mPiece(antiapplyinfostr,String.fromCharCode(1),1);  
  	}
    //*******************/
  	var SpecOrderDoseQty=mPiece(ispecdoseqtystr,String.fromCharCode(1),0);
  	var SpecOrderDoseUOM=mPiece(ispecdoseqtystr,String.fromCharCode(1),1);
  	var SpecOrderDoseUOMRowid=mPiece(ispecdoseqtystr,String.fromCharCode(1),2);
    var SpecOrderFreq=mPiece(ispecfrequencestr,String.fromCharCode(1),0);
    var SpecOrderFreqRowid=mPiece(ispecfrequencestr,String.fromCharCode(1),1);
    var SpecOrderFreqFactor=mPiece(ispecfrequencestr,String.fromCharCode(1),2);
    var SpecOrderFreqInterval=mPiece(ispecfrequencestr,String.fromCharCode(1),3);
  	var SpecOrderInstr=mPiece(ispecinstructionstr,String.fromCharCode(1),0);
  	var SpecOrderInstrRowid=mPiece(ispecinstructionstr,String.fromCharCode(1),1);
  	var SpecOrderDur=mPiece(ispecdurationstr,String.fromCharCode(1),0);
  	var SpecOrderDurRowid=mPiece(ispecdurationstr,String.fromCharCode(1),1);
  	var SpecOrderDurFactor=mPiece(ispecdurationstr,String.fromCharCode(1),2);
	  var SpecOrderPackQty=mPiece(ispecpackqtystr,String.fromCharCode(1),0);
	  var SpecOrderPackUOM=mPiece(ispecpackqtystr,String.fromCharCode(1),1);
	  var SpecOrderPackUOMRowid=mPiece(ispecpackqtystr,String.fromCharCode(1),2);
	  var SpecOrderPrior=mPiece(ispecpriorstr,String.fromCharCode(1),0);
	  var SpecOrderPriorRowid=mPiece(ispecpriorstr,String.fromCharCode(1),1);
	  OrderFreq=SpecOrderFreq;
    OrderFreqRowid=SpecOrderFreqRowid;
    OrderFreqFactor=SpecOrderFreqFactor;
    OrderFreqInterval=SpecOrderFreqInterval;
  	OrderInstr=SpecOrderInstr;
  	OrderInstrRowid=SpecOrderInstrRowid;
  	OrderDur=SpecOrderDur;
  	OrderDurRowid=SpecOrderDurRowid;
  	OrderDurFactor=SpecOrderDurFactor;
  	OrderPackQty=SpecOrderPackQty;
  	OrderARCOSRowid=ispecordersetstr;
  	ARCOSSubCatRowid=ispecordersetsubcatstr;
  	
  	//非药品医嘱套也可能维护了数量
  	if ((OrderType!='R')&&((OrderPackQty==0)||(OrderPackQty==''))){
  		if ((OrderFreqFactor=='')||(OrderFreqFactor==0)) OrderFreqFactor=1;
  		if ((OrderDurFactor=='')||(OrderDurFactor==0)) OrderDurFactor=1;
	  	if (PAAdmType!="I") OrderDurFactor=1;
	  	OrderPackQty=OrderDurFactor*OrderFreqFactor;
	  }
  }
  
	OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var OrderBaseQty=1;
	var Qty=1;	

	//非药品没有长期医嘱?如果是非药品就用这个医嘱项默认类型
	//if ((OrderType!="R")&&(OrderDefPriorRowid!="")&&(PAAdmType!="I")){OrderPriorRowid=OrderDefPriorRowid}
	if ((OrderType!="R")&&(OrderDefPriorRowid!="")){OrderPriorRowid=OrderDefPriorRowid}
	//如果是复制医嘱或开医嘱套的就优先取传入的医嘱类型,按门诊,住院区分
	if ((Para!="")&&(SpecOrderPriorRowid!="")){
		var CheckOrderPriorStr="^"+OrderPriorStr+String.fromCharCode(1);
		var CheckSpecOrderPriorRowid="^"+SpecOrderPriorRowid+String.fromCharCode(1);
		if (CheckOrderPriorStr.indexOf(CheckSpecOrderPriorRowid)!=-1) {OrderPriorRowid=SpecOrderPriorRowid;}
	}
	//如果是st医嘱就改为临时医嘱
	if ((OrderPriorRowid==LongOrderPriorRowid)&&((OrderFreqRowid==STFreqRowid)||(OrderFreqRowid==ONCEFreqRowid))){OrderPriorRowid=ShortOrderPriorRowid}

	///此处处理有问题需改正
	var obj=document.getElementById("GetNowTime");
	if (obj){
		var LongOrderStopFlag=obj.value;
		if ((OrderPriorRowid==LongOrderPriorRowid)&&(PAAdmType=="I")&&(LongOrderStopFlag==0)){OrderPriorRowid=ShortOrderPriorRowid;}
	}
	
	if ((PAAdmType=="I")&&(OrderPriorRowid==ShortOrderPriorRowid)){
		OrderFreq=ONCEFreq;
		OrderFreqRowid=ONCEFreqRowid;
    OrderFreqFactor=1;
    OrderFreqInterval=1;
	}
	
	if (((OrderPriorRowid==ShortOrderPriorRowid)||(OrderPriorRowid==OMOrderPriorRowid))&&(OrderFreqRowid!=STFreqRowid)&&(OrderType=="R")&&(PAAdmType=="I")&&(IPShortOrderPriorST=="1")){
		OrderFreq=STFreq;
		OrderFreqRowid=STFreqRowid;
    OrderFreqFactor=1;
    OrderFreqInterval=1;
	}

	if ((OrderPriorRowid==STATOrderPriorRowid)&&(OrderFreqRowid!=STFreqRowid)&&(PAAdmType=="I")){
		OrderFreq=STFreq;
		OrderFreqRowid=STFreqRowid;
    OrderFreqFactor=1;
    OrderFreqInterval=1;
	}
	
  //因为出院带药有可能指定接收科室?所以会存在两个接收科室串
  //当就诊类型为住院.出院带药接收科室有定义值.医嘱为药品时将CurrentRecLocStr置上供后面程序使用
  //当就诊类型为住院.取药医嘱接收科室有定义值.医嘱为药品时将CurrentRecLocStr置上供后面程序使用
	if ((PAAdmType=="I")&&(OrderType=="R")){
		if ((OrderPriorRowid==OutOrderPriorRowid)&&(ioutpriorreclocstr!="")){
			var CurrentRecLocStr=ioutpriorreclocstr;
		}else if ((OrderPriorRowid==OneOrderPriorRowid)&&(ionepriorreclocstr!="")) {
			var CurrentRecLocStr=ionepriorreclocstr;
		}else{
			//var CurrentRecLocStr=ireclocstr;
			var CurrentRecLocStr=GetRecLocStrByPrior(ireclocstr,OrderPriorRowid);
		}
	}else{
		//var CurrentRecLocStr=ireclocstr;
		var CurrentRecLocStr=GetRecLocStrByPrior(ireclocstr,OrderPriorRowid)
	}
	//用法定义接收科室,未定义用法接收科室,则还取原接收科室串
	if ((OrderType=="R")&&(ReclocByInstr=="1")&&(GetInstrReclocMethod!="")){
		var OrdDept=GetLogonLocByFlag();
		//dhcsys_alert("OrderInstrRowid"+":"+OrderInstrRowid+"^"+"OrdDept"+":"+OrdDept+"^"+"PreInstrRecLocStr"+":"+PreInstrRecLocStr)
		var InstrReclocStr=cspRunServerMethod(GetInstrReclocMethod,EpisodeID,OrderInstrRowid,OrdDept,OrderItemCatRowid,OrderPriorRowid,CurrentRecLocStr)
		//dhcsys_alert("InstrReclocStr"+":"+InstrReclocStr)
		CurrentRecLocStr=GetRecLocStrByPrior(InstrReclocStr,OrderPriorRowid);
	}
	//判断已经下了出院医嘱或者已经医疗结算的不能开出出院带药以外的医嘱
	if ((PAADMMedDischarged=="1")&&(OrderPriorRowid!=OutOrderPriorRowid)){
		dhcsys_alert(t['IsEstimDischarge']);
		return false;
	}	

	//如果为非库存项,将不会进入这个判断
	if (InciRowid!=""){
		//根据设置取药和出院带药默认按整包装开
		if (((OrderPriorRowid==OutOrderPriorRowid)||(OrderPriorRowid==OneOrderPriorRowid))&&(CFOutAndOneDefaultPackQty==1)) OrderPackQty=1;
		//if (((OrderPriorRowid==OutOrderPriorRowid)||(OrderPriorRowid==OneOrderPriorRowid))&&(HospitalCode=="BJZYY")) OrderPackQty=1;
		var BaseDoseQty=1;		
		if (OrderPackQty!="") {
			Qty=parseFloat(OrderConFac)*parseFloat(OrderPackQty);
		}else{
			var DefaultDoseQty="";
			var DefaultDoseUOMRowid="";
			if (Para!=""){
				DefaultDoseQty=SpecOrderDoseQty;
				DefaultDoseUOMRowid=SpecOrderDoseUOMRowid;
			}else{
		 	  if (idoseqtystr!=""){
					var ArrData=idoseqtystr.split(String.fromCharCode(2));
					if (ArrData.length>0){
						var ArrData1=ArrData[0].split(String.fromCharCode(1));
						var DefaultDoseQty=ArrData1[0];
						var DefaultDoseUOMRowid=ArrData1[2];
					}
				}
			}
			if (DefaultDoseUOMRowid!=""){
				//dhcsys_alert("DrugFormRowid:"+OrderDrugFormRowid+"  DefaultDoseUOMRowid: "+DefaultDoseUOMRowid+"   DefaultDoseQty "+DefaultDoseQty);
				OrderBaseQty=cspRunServerMethod(CalDoseMethod,DefaultDoseUOMRowid,OrderDrugFormRowid,DefaultDoseQty);
				if (OrderBaseQty=="") OrderBaseQty=1;
				//dhcsys_alert("OrderBaseQty:"+OrderBaseQty);
			}
			Qty=parseFloat(OrderFreqFactor)*parseFloat(OrderDurFactor)*parseFloat(OrderBaseQty);
		}
		//dhcsys_alert("Qty:"+Qty);
		var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
		if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(OrderPriorRemarks!="OM")){
			if (PAAdmType!="I") {CheckQty=OrderConFac}
			var CheckQty=1;
			var ret=CheckStockEnough(idesc,icode,CheckQty,CurrentRecLocStr);
			//返回库存医嘱的可用库存的科室,
			if (ret=="") {return false}else{OrderRecDepRowid=mPiece(ret,String.fromCharCode(1),0);}
			//自动同步静脉配液时间(去掉)
			if ((OrderPriorRowid==LongOrderPriorRowid)&&(OrderType=="R")){
				var ret=CheckDosingRecLoc(OrderRecDepRowid);
				if (ret){
					var StartDateTime=cspRunServerMethod(GetDosingDateTimeMethod,"4","2",OrderItemCatRowid);
						var StartDateTimeArr=StartDateTime.split("^");
						//SetColumnData("OrderStartDate",Row,StartDateTimeArr[0]);
						//SetColumnData("OrderStartTime",Row,StartDateTimeArr[1]);	
				}
			}
		}else{
			OrderRecDepRowid="";
		}
	}
	Price=parseFloat(Price).toFixed(4);
	if (PAAdmType!="I"){
	  var Sum=parseFloat(OrderPackQty)*parseFloat(Price);
	  Sum=Sum.toFixed(2);
	}else{
		//自备药医嘱不计入总金额
		var Sum=0;
		if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)){
			if (InciRowid!=""){
				Sum=(parseFloat(Price)/parseFloat(OrderConFac))*parseFloat(Qty);
			}else{
				if (OrderPackQty!="") {Qty=OrderPackQty}
				Sum=parseFloat(Qty)*parseFloat(Price);
			}
		}
		Sum=Sum.toFixed(4);		
	}
	//在这个位置验证处方金额控制不准确-可能在后续进行频次和数量的修改。改为在末尾验证
	//自备药医嘱和无费用医嘱不参与费用控制
	/*
	if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)&&(Price!=0)){
		var PrescCheck=CheckPrescriptSum(Sum,icode);
		if (PrescCheck==false) return false;
	}
	*/

  //医生自行设置是否弹出提示
	var objmsgflag=document.getElementById("MsgFlag");  
	if (objmsgflag){
		//dhcsys_alert(objmsgflag.checked+","+iordermsg);
		if (!objmsgflag.checked){OrderMsg=""}
	}
	if ((OrderMsg!="")&&(((Para=="")&&(HospitalCode=="HF"))||(HospitalCode!="HF"))){dhcsys_alert(idesc+OrderMsg);}
	//医保及特病提示
	if (HospitalCode=="SDWFYY"){
	//潍坊医院不判断
	}else {
	var InsurCheck=CheckItemInsurLimit(iinsurinfo);
	if (InsurCheck==false) {return false;}
	}
	
	//因为医保串里新增了$C(2)的分割符,所以取值要先处理一下
	var iinsurinfo1=mPiece(iinsurinfo,String.fromCharCode(2),0);
	var limitFlag=mPiece(iinsurinfo1,String.fromCharCode(1),4);
	var InsurAdmAllowFlag=mPiece(iinsurinfo1,String.fromCharCode(1),5);
	var InsurFlag=mPiece(iinsurinfo1,String.fromCharCode(1),6);

	InsurCheck=false;
	///因为可能存在着自费病人住院或出院更改为医保病人的情况因此默认为医保
	if (HospitalCode=="ZJQZRMYY") InsurCheck=true;

	////医科大附属医院提示限制用药,统一后可以在所有项目通用
	////CFAllConfirmInsurSYMM决定是否所有类型的病人都判断
	
	if ((InsurFlag!='0')||(CFAllConfirmInsurSYMM==1)){
		InsurCheck=true;
		//提示限制用药,适应症判断改成设置,沈阳程序同步后可以把下面的注释删掉  ---2009.04.02 周志强
		if ((limitFlag)&&(CFConfirmInsurSYMM==1)){
		//if ((limitFlag)&&(InsurFlag!="0")&&(HospitalCode=="ZGYKDFSYY")){
			var InsurCheck=window.dhcsys_confirm(t['InsurSYMMMessage1']+InsurAdmAllowFlag+t['InsurSYMMMessage2']);
		}
	}

	//潍坊的检验项目要求自费病人下医保的检验项目的时候给医生提示
	if ((HospitalCode=="SDWFYY")&(PAAdmType=="I")){
		var LabDescFlag=(idesc.indexOf("医保"));
		if ((LabDescFlag!="-1")&(OrderBillTypeRowid=="1")&(OrderType=="L")){
			var LabDescCheck=dhcsys_confirm(t['OrderOnlyForInsurAdm'],false);
			if (LabDescCheck==false) {return false;}
		}
		///潍坊要求下长期医嘱的时候默认的开始时间是8:00
		if ((OrderPriorRowid==LongOrderPriorRowid)&(OrderType=="R")){
			SetColumnData("OrderStartTime",Row,"8:00");
		}

		///潍坊要求住院默认的频次和用法都是空
		OrderFreq="";
		OrderFreqRowid="";
		OrderInstr="";
		OrderInstrRowid="";
	}
 	
	///深圳取当选取的医嘱是否含有自费项目
	if ((HospitalCode=="SZZYY")||(HospitalCode=="ZJQZRMYY")){
    ArcimLinkInsuSelfMethod=document.getElementById('ArcimLinkInsuSelfMethod').value;
  	YbTarFlag=cspRunServerMethod(ArcimLinkInsuSelfMethod,icode,OrderBillTypeRowid);
		//深圳中医院的处理为什么要这样写死billtypeid,先注释
  	//if ((YbTarFlag!="")&&(YbTarFlag!="-1")&&(YbTarFlag!="-2")&&(BillTypeID=="1")&&(Price!=0)){
  	if ((YbTarFlag!="")&&(YbTarFlag!="-1")&&(YbTarFlag!="-2")&&(Price!=0)){
	  	str1=YbTarFlag.split("^");
	  	str2=t['OrderIncludeSelfpay']+'\n';
	  	for(i=0;i<str1.length;i++){
		  	strcode=str1[i].split(String.fromCharCode(1))[0];
		  	strdesc=str1[i].split(String.fromCharCode(1))[1];
		  	str2=str2+strcode+". "+strdesc+'\n'
		  }
	  	var ret=dhcsys_confirm(str2);
	  	//if (ret==false) return false;
	  	InsurCheck=(!ret);
	  }
	}
	////深圳中医院医保下级分类
  var OrderInsurCatRowId="";
  var OrderInsurCat="";OrderInsurCatRowId="",OrderInsurNote=""
	if ((HospitalCode=="SZZYY")||((HospitalCode=="SDWFYY")&&(PAAdmType=="I"))){
	  GetArcimLinkTarStrMethod=document.getElementById('GetArcimLinkTarStr').value;
	  if (GetArcimLinkTarStrMethod!=""){
		  OrderInsurCatStr=cspRunServerMethod(GetArcimLinkTarStrMethod,icode,OrderBillTypeRowid);
		  if ((OrderInsurCatStr!="")&&(OrderInsurCatStr!="-3")&&(OrderInsurCatStr!="-2")){
		  	var ret=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCArcimLinkTarStr&ArcimRowid="+icode+"&AdmReason="+OrderBillTypeRowid+"&Row="+Row,"","dialogwidth:50;dialogheight:30;status:no;center:1;resizable:yes");
		  	//var ret=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCArcimLinkTarStr&ArcimRowid="+icode+"&AdmReason="+"2"+"&Row="+Row,"","dialogwidth:50em;dialogheight:30em;status:no;center:1;resizable:yes");
		  	if (ret==null) {
		  		OrderInsurCatRowId="";
		  		OrderInsurCat="";
		  	}else{
		  		OrderInsurCatRowId=mPiece(ret,"^",0);
		  		OrderInsurCat=mPiece(ret,"^",1);
					OrderInsurNote=mPiece(ret,"^",2);
				  if (OrderInsurNote!=''){
				  	var JY='';
					  var NewOrderName=mPiece(idesc,"%",1);
						var JYStr=mPiece(idesc,"%",0);
						var reg=/^\+?[0-9]*[0-9][0-9]*$/;
						var sum="0"
						for (i=0;i<JYStr.length;i++){
							var tempChar= JYStr.substring(i,i+1);
							if (tempChar.match(reg)&&(sum!=1)){
								var  JY=JYStr.substring(0,i);
								sum=1;
							}
						}
					  var idesc=JY+OrderInsurNote+NewOrderName
				  }
		  	}
			}
	  }
	}	
	////
	////宁医附院医保适应症
  var OrderInsurSignSymptomCode="";
  var OrderInsurSignSymptom="";
  ///药品,医保费别标志,住院,非自备药
	if ((HospitalCode=="NXYXYFSYY")&&(OrderType=="R")&&(InsurFlag!=0)&&(PAAdmType=="I")&&(OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)){
	  var Method=document.getElementById('GetArcimInsurDSYMMethod').value;
	  if (Method!=""){
	  	var InsurSignSymptom="";
		  var OrderInsurDiagnosStr=cspRunServerMethod(Method,icode,OrderBillTypeRowid);
		  if ((OrderInsurDiagnosStr!="")&&(OrderInsurDiagnosStr!=-1)){
		  	
		  	var OrderInsurSignSymptomCode=FindInsurSignSymptom(OrderInsurDiagnosStr,Row);

		  	if (OrderInsurSignSymptomCode==""){
		  		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocArcimLinkInsurSignSymptom&ARCIMID="+icode+"&BillType="+OrderBillTypeRowid;
			  	var ret=window.showModalDialog(url,"适应症选择","dialogwidth:30em;dialogheight:30em;status:no;center:1;resizable:yes");
			  	if (ret==null) {
			  		OrderInsurSignSymptomCode="";
			  		OrderInsurSignSymptom="";
			  	}else{
			  		OrderInsurSignSymptom=mPiece(ret,String.fromCharCode(1),1);
			  		OrderInsurSignSymptomCode=mPiece(ret,String.fromCharCode(1),0);
			  	}
			  }else{
			  	var Method=document.getElementById('GetSignSymptomMethod').value;
	  			if (Method!=""){
	  				var OrderInsurSignSymptom=cspRunServerMethod(Method,OrderInsurSignSymptomCode);
	  			}
			  }
			}
	  }
	}
	
	// 北京地区医保适应症提示
	if ((HospitalCode=='YY')||(HospitalCode=='BJZYY')||(HospitalCode=='BJDTYY')||(HospitalCode=='BJFCYY')||(HospitalCode=='YKYZLYY')){
		var InsurAlertStr=mPiece(iinsurinfo,String.fromCharCode(2),1);
		if (InsurAlertStr==""){
		}else if (InsurAlertStr=="-1"){
		}else if (InsurAlertStr=="-2"){
		}else if (InsurAlertStr=="-3"){
		}else {
			var InsurCheck=true;
			var Itemtemp=InsurAlertStr.split("!");
			if (Itemtemp.length==1){
				var Item=Itemtemp[0].split(String.fromCharCode(1));
				var TarConCode=Item[0];
				var TarConDesc=Item[1];
				var Contype=Item[2];
				var bz=Item[3];
				//因为中医院有医保防火墙,中医院要求不要此提示,由大夫自己判断是否开到医保处方中,将提示信息取值修改
				//if (HospitalCode!='BJZYY') InsurCheck=window.dhcsys_confirm(t['Insu_Ind1']+bz+t['Insu_Ind2']);
				if (HospitalCode!='BJZYY') InsurCheck=window.dhcsys_confirm(t['InsurSYMMMessage1']+bz+t['InsurSYMMMessage2']);
			}
			if (Itemtemp.length>1){
				var obj = new Object();
        obj.name="Para";
        obj.value=InsurAlertStr+"&"+Row;
				var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocIndicationsChoose";
				//原来是将InsuConType放到OrderHiddenPara中第4位其实应该赋值到OrderInsurCatRowId隐藏列中
				//var InsuConType=window.showModalDialog(url,obj,"dialogwidth:50em;dialogheight:30em;status:yes;center:1;resizable:yes")
				var OrderInsurCatRowId=window.showModalDialog(url,obj,"dialogwidth:50em;dialogheight:30em;status:yes;center:1;resizable:yes")
			}
		}
	}	

		
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var RowObj=objtbl.rows[RowIndex];

	var EnableDuration=false;
	var EnableFrequence=false;
	if (OrderType!="R"){
		if (OrderPHPrescType=="4"){
			if ((OrderPriorRowid!=LongOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)) {			
				EnableDuration=true;
			}
			EnableFrequence=true;
		}
		ChangeRowStyleToNormal(RowObj,OrderType,EnableDuration,EnableFrequence);
	}else{
		//住院的草药还需要录入疗程,开即刻医嘱
		if (PAAdmType!="I"){
			EnableDuration=true;
		}else{
			if (OrderPHPrescType=="3"){EnableDuration=true}
			else{
				if ((OrderPriorRowid!=LongOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)) EnableDuration=true;
			}
		}
		//如果是韶关临时医嘱可以录入疗程(以后改成设置)
		//if ((Hospital=="SG")&&(OrderPriorRowid==ShortOrderPriorRowid)){EnableDuration=true}
		if ((OrderPHPrescType=="3")&&(((HospitalCode=="HF")&&(icode!="5612||1"))||(HospitalCode!="HF"))){
			ChangeRowStyle(RowObj,0,EnableDuration);
		}else{
			var EnablePackQty=1;
			//if ((HospitalCode=="BJDTYY")&&(OrderPriorRowid==LongOrderPriorRowid)) EnablePackQty=0;
			if ((CFLongOrderNotAllowPackQty==1)&&(OrderPriorRowid==LongOrderPriorRowid)) EnablePackQty=0;
			ChangeRowStyle(RowObj,EnablePackQty,EnableDuration);
		}
	}

	if (OrderType=="R") {
		//检查医生对管制分类药品的控制级别 V-6.9
		/*
  	var PrescCheck=CheckDoctorTypePoison(OrderPoisonRowid,icode,Row,OrderPoisonCode);
  	var len=PrescCheck.length
		if (len>1){
			var PrescCheckArr=PrescCheck.split("||")
  			var PrescCheck=PrescCheckArr[0]
  			var PrescCheckinfo=PrescCheckArr[1]
			if (PrescCheck==false){return false;}
		}else{
			if (PrescCheck==false){return false;}
		}
  	*/
		//测试医生站抗菌药物分级管理时放开此方法,V_7.X
		var PrescCheck=CheckDoctorTypePoison_7(OrderPoisonRowid,icode,Row,OrderPoisonCode);
		if (PrescCheck==false){return false;}
	}
	
	//设置科研项目
	SetColumnList("OrderPilotPro",Row,PilotProStr);
	
	//医保适应症
	SetColumnData("OrderInsurSignSymptom",Row,OrderInsurSignSymptom);
	SetColumnData("OrderInsurSignSymptomCode",Row,OrderInsurSignSymptomCode);
	
	//医保子分类	
	SetColumnData("OrderInsurCat",Row,OrderInsurCat);
	SetColumnData("OrderInsurCatRowId",Row,OrderInsurCatRowId);

	//SetColumnData("OrderPrior",Row,OrderPriorRowid);
	//SetColumnData("OrderPriorRowid",Row,OrderPriorRowid);
	
	SetColumnList("OrderDoseUOM",Row,idoseqtystr);
	SetColumnList("OrderDIACat",Row,idiagnoscatstr);

	//默认置上前一条的诊断类别	
	if (FocusRowIndex>1) {
		var PreRow=GetRow(FocusRowIndex-1);
		var PreDIACatRowId=GetColumnData("OrderDIACat",PreRow);
		SetColumnData("OrderDIACat",Row,PreDIACatRowId);
		SetColumnData("OrderDIACatRowId",Row,PreDIACatRowId);
	}
	
	//把前面的得到可用接收科室串用来置接收科室List
  SetColumnList("OrderRecDep",Row,CurrentRecLocStr);
	//记录下非出院带药的接收科室和出院带药的接收科室?当切换医嘱类型时需要这两个串
  SetColumnData("OrderRecLocStr",Row,ireclocstr);
  SetColumnData("OrderOutPriorRecLocStr",Row,ioutpriorreclocstr);
  SetColumnData("OrderOnePriorRecLocStr",Row,ionepriorreclocstr);
  
  if (Para!=""){
		 SetColumnData("OrderDoseQty",Row,SpecOrderDoseQty);
		 SetColumnData("OrderDoseUOM",Row,SpecOrderDoseUOMRowid);	       
		 SetColumnData("OrderDoseUOMRowid",Row,SpecOrderDoseUOMRowid);
  }
	
	//设定前面给定的有库存接受科室
	if (OrderRecDepRowid!="") {
		SetColumnData("OrderRecDep",Row,OrderRecDepRowid);
		SetColumnData("OrderRecDepRowid",Row,OrderRecDepRowid);
	}
	//设标本选择下拉框
	SetColumnList("OrderLabSpec",Row,OrderLabSpec);

	//dhcsys_alert(OrderFreqFactor+"^"+OrderFreqInterval+"^"+OrderDurFactor+"^"+OrderConFac+"^"+OrderDrugFormRowid);
	//SetColumnData("OrderFreq",Row,OrderFreq);
	//SetColumnData("OrderFreqRowid",Row,OrderFreqRowid);
	//SetColumnData("OrderInstr",Row,OrderInstr);
	//SetColumnData("OrderInstrRowid",Row,OrderInstrRowid);
	//避免抗菌使用目的赋值被覆盖
	var SpeAction=GetColumnData("SpecialAction",Row)
	if(SpeAction!="isEmergency"){
		SetColumnData("OrderPrior",Row,OrderPriorRowid);
		SetColumnData("OrderPriorRowid",Row,OrderPriorRowid);
		SetColumnData("OrderFreq",Row,OrderFreq);
		SetColumnData("OrderFreqRowid",Row,OrderFreqRowid);
		SetColumnData("OrderInstr",Row,OrderInstr);
		SetColumnData("OrderInstrRowid",Row,OrderInstrRowid);
	}
	SetColumnData("OrderDur",Row,OrderDur);
	SetColumnData("OrderDurRowid",Row,OrderDurRowid);
	SetColumnData("OrderFreqFactor",Row,OrderFreqFactor);
	SetColumnData("OrderFreqInterval",Row,OrderFreqInterval);  
	SetColumnData("OrderDurFactor",Row,OrderDurFactor);  
	SetColumnData("OrderConFac",Row,OrderConFac);  
	SetColumnData("OrderPHForm",Row,OrderPHForm);
	SetColumnData("OrderPHPrescType",Row,OrderPHPrescType);	
	SetColumnData("OrderARCIMRowid",Row,icode);
	SetColumnData("OrderDrugFormRowid",Row,OrderDrugFormRowid);	
	SetColumnData("OrderName",Row,idesc);
	SetColumnData("OrderOldName",Row,idesc);
	SetColumnData("OrderPackQty",Row,OrderPackQty);
	SetColumnData("OrderPackUOM",Row,OrderPackUOM);
	SetColumnData("OrderPackUOMRowid",Row,OrderPackUOMRowid);
	SetColumnData("OrderPrice",Row,Price);
	SetColumnData("OrderSum",Row,Sum);
	SetColumnData("OrderType",Row,OrderType);
	SetColumnData("OrderBillTypeRowid",Row,OrderBillTypeRowid);	
	SetColumnData("OrderBillType",Row,OrderBillType);
	SetColumnData("OrderBaseQty",Row,OrderBaseQty);  
	//SetColumnData("OrderLabSpec",Row,OrderLabSpec);
	SetColumnData("OrderARCOSRowid",Row,OrderARCOSRowid ); 
	SetColumnData("OrderMaxDurFactor",Row,OrderMaxDurFactor); 
	SetColumnData("OrderMaxQty",Row,OrderMaxQty); 
	SetColumnData("OrderBaseQtySum",Row,Qty);
	SetColumnData("OrderFile1",Row,OrderFile1);
	SetColumnData("OrderFile2",Row,OrderFile2);
	SetColumnData("OrderFile3",Row,OrderFile3);
	SetColumnData("OrderLabExCode",Row,OrderLabExCode);
	SetColumnData("OrderAlertStockQty",Row,OrderAlertStockQty);  
	SetColumnData("OrderPoisonCode",Row,OrderPoisonCode); 
	var AntibApplyRowid=GetColumnData("OrderAntibApplyRowid",Row)
	if ((AntibApplyRowid=="")&&(OrderAntibApplyRowid!="undefined")){
	 SetColumnData("OrderAntibApplyRowid",Row,OrderAntibApplyRowid);
	}
	var ReasonID=GetColumnData("UserReasonID",Row)
	if ((ReasonID=="")&&(typeof(UserReasonID)!="undefined")){
	 SetColumnData("UserReasonID",Row,UserReasonID);
	}
	SetColumnData("OrderPriorRemarks",Row,OrderPriorRemarksDR);
  
	var needskintest=mPiece(iskintest,String.fromCharCode(1),0);
	var skintestyy=mPiece(iskintest,String.fromCharCode(1),1);
	//住院开整包装标志
	var IPNeedBillQty=mPiece(iskintest,String.fromCharCode(1),2);
	//是否紧急标志可用
	var EmergencyFlag=mPiece(iskintest,String.fromCharCode(1),3);

  if (needskintest=="Y"){
	//东方医院需要医生确认是否置皮试
	if ((HospitalCode=='SHSDFYY')||(HospitalCode=='JSXZZXYY')){
		var DelCheck=dhcsys_confirm("该药品需要皮试,是否做皮试?",false);
	}else{
		var DelCheck=true;
	}
	var OrderPriorArray=OrderActionStr.split("^");
	for (var i=0;i<OrderPriorArray.length;i++) {
	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
	 if (OrderPrior[1]=="YY"){var YYActionRowid=OrderPrior[0];}
	 if (OrderPrior[1]=="MS"){var MSActionRowid=OrderPrior[0];}
	 if (OrderPrior[1]=="XZ"){var XZActionRowid=OrderPrior[0];}
	}
	//还需要增加不是青霉素类药品的判断
  	if (DelCheck==true) {              
		//皮试备注标记原液;点击取消后,皮试不打勾,皮试备注标记为免试液
  		SetColumnData("OrderSkinTest",Row,true);
  		if (skintestyy=='1'){
  			SetColumnData("OrderActionRowid",Row,YYActionRowid);  
	  		SetColumnData("OrderAction",Row,YYActionRowid); 
	  	}else{
	  		SetColumnData("OrderActionRowid",Row,"");  
	  		SetColumnData("OrderAction",Row,""); 
	  	}
  	}else{
	  		SetColumnData("OrderActionRowid",Row,MSActionRowid);  
	  		SetColumnData("OrderAction",Row,MSActionRowid); 
  	}
  }
  
  if (InsurCheck==false) SetColumnData("OrderCoverMainIns",Row,false);
  SetColumnData("OrderCoverMainIns",Row,InsurCheck);

  if (EmergencyFlag=="Y") {ChangeCellStyle("OrderNotifyClinician",Row,false)}else{ChangeCellStyle("OrderNotifyClinician",Row,true)}
  //以String.fromCharCode(1)为分隔符
  var OrderHiddenPara=skintestyy+String.fromCharCode(1)+IPNeedBillQty+String.fromCharCode(1)+OrderItemCatRowid+String.fromCharCode(1)+OrderMaxDoseQty+String.fromCharCode(1)+OrderMaxDoseQtyPerDay+String.fromCharCode(1)+OrderLimitDays+String.fromCharCode(1)+OrderMaxDoseQtyPerOrder;
  SetColumnData("OrderHiddenPara",Row,OrderHiddenPara);

	/*
	//如果是住院且为临时医嘱,频次变为st(宁波,合肥,上海要求),原来由医院代码来判断,现改为设置
  //if ((OrderPriorRowid==ShortOrderPriorRowid)&&(OrderFreqRowid!=STFreqRowid)&&(OrderType=="R")&&(PAAdmType=="I")&&((HospitalCode=="NB")||(HospitalCode=="HF")||(HospitalCode=="SHHSPD"))){
	if ((OrderPriorRowid==ShortOrderPriorRowid)&&(OrderFreqRowid!=STFreqRowid)&&(OrderType=="R")&&(PAAdmType=="I")&&(IPShortOrderPriorST=="1")){
		SetColumnData("OrderFreq",Row,STFreq);
		SetColumnData("OrderFreqRowid",Row,STFreqRowid);
	}
	*/
	if ((OrderPriorRowid==STATOrderPriorRowid)&&(OrderFreqRowid!=STFreqRowid)&&(PAAdmType=="I")){
		SetColumnData("OrderFreqRowid",Row,STFreqRowid);
		SetColumnData("OrderFreq",Row,STFreq);
	}
	
	if ((IsWYInstr(OrderInstrRowid))&&(PAAdmType!="I")&&(HospitalCode!="BJZYY")){
		SetColumnData("OrderDur",Row,"");
		SetColumnData("OrderDurRowid",Row,"");
		SetColumnData("OrderDoseQty",Row,"");
	}
  
	if ((OrderPHPrescType=="3")&&(objtbl.rows.length>2)&&(((icode!="5612||1")&&(HospitalCode=="HF"))||(HospitalCode!="HF"))){
		//草药默认置上前一条的医嘱疗程
		var PreRow=GetRow(objtbl.rows.length-2);
		var PreOrderPHPrescType=GetColumnData("OrderPHPrescType",PreRow);
		if ((Para=="")&&(OrderDurRowid!="")&&(PreOrderPHPrescType=="3")) {
			OrderDurRowid=GetColumnData("OrderDurRowid",PreRow);
			OrderDur=GetColumnData("OrderDur",PreRow);
			OrderDurFactor=GetColumnData("OrderDurFactor",PreRow); 
			SetColumnData("OrderDur",Row,OrderDur);
			SetColumnData("OrderDurRowid",Row,OrderDurRowid);
			SetColumnData("OrderDurFactor",Row,OrderDurFactor);  
			if (Para=="") SetPackQty(Row);
		}
	}
	if (OrderType=="R"){
		SetColumnData("OrderGenericName",Row,OrderGenericName);
	}
	
	//补录医嘱
	SetNurLinkOrd(Row)
	
	if (Para!="") {
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		if (OrderPriorRowid==LongOrderPriorRowid) {
			if (OrderType=="R") {
				SetColumnData("OrderPackQty",Row,"");
			}
			SetColumnData("OrderDur",Row,IPDefaultDur);
			SetColumnData("OrderDurRowid",Row,IPDefaultDurRowId);
			SetColumnData("OrderDurFactor",Row,IPDefaultDurFactor);
		}
	}
	
	//对有频次的非药品医嘱根据开始时间计算首日次数
	SetOrderFirstDayTimes(Row);
	//门诊输液次数
	SetOrderLocalInfusionQty(Row);
	
	SetOrderRowAry(Row,"OrderInstr",OrderInstr);
	SetOrderRowAry(Row,"OrderFreq",OrderFreq);
	SetOrderRowAry(Row,"OrderDur",OrderDur);
	SetOrderRowAry(Row,"OrderName",idesc);
	
	//得到序号的串
	if (CheckMasterNoStr=="")CheckMasterNoStr="!";
	CheckMasterNoStr=CheckMasterNoStr+GetColumnData("OrderSeqNo",Row)+"!";
  
	SetPoisonOrderStyle(OrderPoisonCode,OrderPoisonRowid,RowObj,Row);
	
	SetRowStyleClass(FocusRowIndex,OrderPriorRowid,"");
	
	//dhcsys_alert(RowObj.className);
	//医嘱套等多条医嘱添加在此调用会影响速度
	// 协议包装,2014-05-30,by xp,Start
	GetBillUOMStr(Row);
	if (Para!=""){
		SetColumnData("OrderPackUOM",Row,SpecOrderPackUOMRowid);
		SetColumnData("OrderPackUOMRowid",Row,SpecOrderPackUOMRowid);
		OrderPackUOMchangeCommon(Row);
		OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
		if ((OrderPackQty!="")&&(((OrderPriorRowid!=LongOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid))||(OrderPHPrescType!='4'))){
			SetColumnData("OrderPackQty",Row,OrderPackQty);
			if (Para=="") SetPackQty(Row);
		}
	}
	// 协议包装,2014-05-30,by xp,End
	if (Para=="") SetScreenSum();
	
	if ((HospitalCode=="BJZYY")&&(OrderType=="R")){SetFocusColumn("OrderDoseQty",Row)}else{SetFocusColumn("OrderPackQty",Row)}
 
	if (DHCDTInterface==1){
		//if (icode!="") CreateYDTS(icode);
		//判断草药是否激活相互作用
		if (OrderType!="R") {return true;}  
		if ((OrderPHPrescType=="3")&&(DTCheckCNMed!="1")){return true;} 
		XHZY_Click();
	}
	//放在最后保证医嘱套中关联关系加载完后再检验
    CheckOrderPriorRemarks(Row)
	//住院进行欠费控制
	if ((OrderPriorRowid!=OMOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid))
	{
		var ScreenBillSum=GetScreenBillSum();
		if (PAAdmType=="I"){
			if(!CheckDeposit(ScreenBillSum,icode)){
				var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
				var ret=CanDeleteRow(objtbl,Row);
				if (ret){
					DeleteTabRow(objtbl,Row);
			  	}
			  	SetScreenSum()
			}	
		}
	}
	return true;
}

function CheckDosingRecLoc(RecDepRowId){
	if ((IPDosingRecLoc!="")&&(RecDepRowId!="")){
		var ArrData=IPDosingRecLoc.split("^");
		for (var i=0;i<ArrData.length;i++) {
			if (ArrData[i]==RecDepRowId) return true;
		}
	}
	return false
}
function SetColumnList(ColumnName,Row,str) {
	  var Id=ColumnName+"z"+Row;
    var obj=document.getElementById(Id);
    if ((obj)&&(obj.type=="select-one")){
    	 ClearAllList(obj);
    	 if (ColumnName=="OrderRecDep"){
    	 	 var DefaultRecLocRowid="";
    	 	 var DefaultRecLocDesc="";
	       var ArrData=str.split(String.fromCharCode(2));
	       for (var i=0;i<ArrData.length;i++) {
	       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
	       	 if ((ArrData1[2]=="Y")&&(DefaultRecLocRowid=="")) {
	       	 	 var DefaultRecLocRowid=ArrData1[0];
	       	 	 var DefaultRecLocDesc=ArrData1[1];
	       	 }
	         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	       }
	       SetColumnData("OrderRecDepRowid",Row,DefaultRecLocRowid);
	       SetColumnData("OrderRecDep",Row,DefaultRecLocRowid);
	     }
    	 if (ColumnName=="OrderDoseUOM"){
    	 	 var DefaultDoseQty="";
    	 	 var DefaultDoseQtyUOM=""
    	 	 var DefaultDoseUOMRowid="";
    	 	 if (str!=""){
		       var ArrData=str.split(String.fromCharCode(2));
		       for (var i=0;i<ArrData.length;i++) {
		       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
		         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[2]);
		         if (i==0) {
		         	var DefaultDoseQty=ArrData1[0];
		         	var DefaultDoseQtyUOM=RowidData=ArrData1[1];
		         	var DefaultDoseUOMRowid=RowidData=ArrData1[2];
		        }
		       }
		      }
	       SetColumnData("OrderDoseQty",Row,DefaultDoseQty);
	       SetColumnData("OrderDoseUOM",Row,DefaultDoseUOMRowid);	       
	       SetColumnData("OrderDoseUOMRowid",Row,DefaultDoseUOMRowid);

	     }
		  // 协议包装,2014-05-30,by xp,Start
	     if (ColumnName=="OrderPackUOM"){
    	 	 var DefaultDoseQty="";
    	 	 var DefaultDoseQtyUOM=""
    	 	 var DefaultDoseUOMRowid="";
    	 	 if (str!=""){
		       var ArrData=str.split(String.fromCharCode(2));
		       for (var i=0;i<ArrData.length;i++) {
		       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
		         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
		         if (i==0) {
		         	var DefaultDoseUOMRowid=RowidData=ArrData1[0];
		         	var DefaultDoseQtyUOM=RowidData=ArrData1[1];
		        }
		       }
		      }
	       SetColumnData("OrderPackUOM",Row,DefaultDoseUOMRowid);	       
	       SetColumnData("OrderPackUOMRowid",Row,DefaultDoseUOMRowid);
	     }
	     // 协议包装,2014-05-30,by xp,End
    	 if (ColumnName=="OrderLabSpec"){
    	 	 var DefaultSpecRowid="";
    	 	 var DefaultSpecDesc="";
	       var ArrData=str.split(String.fromCharCode(2));
	       for (var i=0;i<ArrData.length;i++) {
	       	 var ArrData1=ArrData[i].split(String.fromCharCode(3));
	       	 if (ArrData1[4]=="Y") {
	       	 	 var DefaultSpecRowid=ArrData1[0];
	       	 	 var DefaultSpecDesc=ArrData1[1];
	       	 }
	         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	       }
	       SetColumnData("OrderLabSpecRowid",Row,DefaultSpecRowid);
	       SetColumnData("OrderLabSpec",Row,DefaultSpecRowid);
	     }
    	 if (ColumnName=="OrderDIACat"){
    	 	 var DefaultDIACatRowId="";
    	 	 var DefaultDIACatDesc="";
	       var ArrData=str.split(String.fromCharCode(2));
	       obj.options[obj.length] = new Option("","");
	       for (var i=0;i<ArrData.length;i++) {
	       	 var ArrData1=ArrData[i].split(String.fromCharCode(1));
	       	 /*
	       	 if (i==0) {
	       	 	 var DefaultRecLocRowid=ArrData1[0];
	       	 	 var DefaultRecLocDesc=ArrData1[1];
	       	 }
	       	 */
	         obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	       }
	       SetColumnData("OrderDIACatRowId",Row,DefaultDIACatRowId);
	       SetColumnData("OrderDIACat",Row,DefaultDIACatRowId);
	     }
	     //身体部位
    	 if (ColumnName=="OrderBodyPart"){
	       var ArrData=str.split(String.fromCharCode(2));
	       obj.options[obj.length] = new Option("","");
	       for (var i=0;i<ArrData.length;i++) {
					var ArrData1=ArrData[i].split(String.fromCharCode(1));
         	obj.options[obj.length] = new Option(ArrData1[2],ArrData1[2]);
	       }
	     }
	     //开医嘱阶段
    	 if (ColumnName=="OrderStage"){
	       var ArrData=str.split(String.fromCharCode(2));
	       obj.options[obj.length] = new Option("","");
	       for (var i=0;i<ArrData.length;i++) {
					var ArrData1=ArrData[i].split(String.fromCharCode(1));
         	obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	       }
	     }
		if (ColumnName=="OrderPilotPro"){
    	 	var DefaultPilotProRowid="";
    	 	var DefaultPilotProDesc="";
	     	var ArrData=str.split(String.fromCharCode(2));
	       	for (var i=0;i<ArrData.length;i++) {
	       		var ArrData1=ArrData[i].split(String.fromCharCode(1));
	       		if (ArrData1[2]=="Y") {
	       	 		var DefaultPilotProRowid=ArrData1[0];
	       	 		var DefaultPilotProDesc=ArrData1[1];
	       		}
	        	obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
	        }
	       	SetColumnData("OrderPilotProRowid",Row,DefaultPilotProRowid);
	       	SetColumnData("OrderPilotPro",Row,DefaultPilotProRowid);
	 	 }
	   }
}

function ListDoubleClickHandler() {
	var eSrc=websys_getSrcElement();
	//Adds selected item from the group listboxes when an "Add" button is clicked.
	if (eSrc.id=="group1") AddItemsFromFav(document.fUDHCOEOrder_List_Custom,lstGroup1.name);
	if (eSrc.id=="group2") AddItemsFromFav(document.fUDHCOEOrder_List_Custom,lstGroup2.name);
	if (eSrc.id=="group3") AddItemsFromFav(document.fUDHCOEOrder_List_Custom,lstGroup3.name);
	if (eSrc.id=="group4") AddItemsFromFav(document.fUDHCOEOrder_List_Custom,lstGroup4.name);
	if (eSrc.id=="group5") AddItemsFromFav(document.fUDHCOEOrder_List_Custom,lstGroup5.name);
	return false;
}

function AddItemsFromFav(f,selfrom) {
	var selary=getSelected(f.elements[selfrom],0,1);
	addSelectedFav(selary);
}

function addSelectedFav(selary) {
	var desc="";
	var selItmid="";
	var selItmDesc="";
	var selItmDur="";
	var isubcatcode="";
	var obj1="";
	var objLinkedOrder="";
	var orderValue="";
	var orderType="";
	var bCanCopy="";
	var CatID="";
	var SubCatID="";
	var OrderType="";
	var setid="";
	var OrderGroupNumber="";
	var objOrderGroupNumber=document.getElementById("OEORIItemGroup");
	if ((objOrderGroupNumber)&&(objOrderGroupNumber.value!="")) OrderGroupNumber=objOrderGroupNumber.value;
	//Log 48858 PeterC 31/03/05
	var Freq="";
	var Dur="";
	var Priority="";
	var DosageQty="";
	var Status="";
	var ProcNote="";
	var PrescItemCats="";
	
	for (var i=0;i<selary.length;i++) {
		//dhcsys_alert(selary[i]["val"]);
		Freq=selary[i]["val"].split(String.fromCharCode(4))[10];
		Dur=selary[i]["val"].split(String.fromCharCode(4))[11];
		Priority=selary[i]["val"].split(String.fromCharCode(4))[12];
		DosageQty=selary[i]["val"].split(String.fromCharCode(4))[13];
		Status=selary[i]["val"].split(String.fromCharCode(4))[14];
		ProcNote=selary[i]["val"].split(String.fromCharCode(4))[15];
		if(ProcNote!="") ProcNote=unescape(ProcNote);
		OrderType=mPiece(selary[i]["val"],String.fromCharCode(4),0);
		isubcatcode=mPiece(selary[i]["val"],String.fromCharCode(4),8)
		var itemid=selary[i]["val"].split(String.fromCharCode(4))[2];

    AddClickHandler();

		if (OrderType=="ARCIM"){
      var Para="";
			if (!CheckDiagnose(isubcatcode)){
				return false;
				var itemobj=document.getElementById("OrderNamez"+Row);
				if (itemobj) {
					itemobj.value="";
					websys_setfocus(itemobj.id);
				  return false;
				}
			} 

			var ItemDefaultRowId=GetItemDefaultRowId(itemid);
	    var ret=AddItemToList(FocusRowIndex,itemid,Para,"",ItemDefaultRowId);

			if (ret==false) {
			  ClearRow(FocusRowIndex);
				continue;
  		}else{
  		}

 		
		}else{
			var osid=selary[i]["val"].split(String.fromCharCode(4))[2];
			AddClickHandler();
			ClearRow(FocusRowIndex);
			OSItemListOpen(osid,"","YES","","");
		}
	}
	SetScreenSum();
}
function ConervToDate(OrderStartDate){
 	var OrderStartDateArr=OrderStartDate.split("/");
	var OrderStartDateYear=OrderStartDateArr[2];
	var OrderStartDateMonth=parseInt(OrderStartDateArr[1],10)-1;
	var OrderStartDateDay=OrderStartDateArr[0];	
	var objDate = new Date(OrderStartDateYear,OrderStartDateMonth,OrderStartDateDay,0,0,0);
	return objDate;	
}


function dateadd(date1,day)
{
    var T=new Date();
    if(day<0)day=0;
    var t=Date.parse(date1)+day*1000*3600*24;
    T.setTime(t);
    return T;
}

function GetCountByFreqDispTime(FreqDispTimeStr,StartDateStr,DurFactor)
{
	var count=0
	var StartTime=new Date(); 
	var objStartDate=ConervToDate(StartDateStr);
	var ArrData=FreqDispTimeStr.split(String.fromCharCode(1));
	for (var j=0;j<DurFactor;j++){
		//var TempDate=new Date();
		var TempDate=dateadd(objStartDate,j);
		var TempDateWeek=TempDate.getDay();
		//dhcsys_alert(TempDateWeek);
		for (var i=0;i<ArrData.length;i++) {
		 var ArrData1=ArrData[i].split(String.fromCharCode(2));
	 	 var DispTime=ArrData1[0];
	 	 var DispWeek=ArrData1[1];
	 	 if (DispWeek==TempDateWeek){count=count+1}
	 	 if ((DispWeek==7)&&(TempDateWeek==0)){count=count+1}
		}
	}
	
	return count;
}
function CheckOrderDoseLimit(Row) {
	var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
	var OrderMaxDoseQty=mPiece(OrderHiddenPara,String.fromCharCode(1),3);
	var OrderMaxDoseQtyPerDay=mPiece(OrderHiddenPara,String.fromCharCode(1),4);
	var OrderLimitDays=mPiece(OrderHiddenPara,String.fromCharCode(1),5);
	var OrderMaxDoseQtyPerOrder=mPiece(OrderHiddenPara,String.fromCharCode(1),6);
	//dhcsys_alert(OrderHiddenPara);
	//判断没有设置参数就不用走后面的处理
	if ((OrderMaxDoseQty=='')&&(OrderMaxDoseQtyPerDay=='')&&(OrderLimitDays=='')&&(OrderMaxDoseQtyPerOrder=='')) return true;
	
	var DrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
	var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
	var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
	var freq=GetColumnData("OrderFreqFactor",Row);   
	var dur=GetColumnData("OrderDurFactor",Row);
	var Interval=GetColumnData("OrderFreqInterval",Row);
	
	//取得以等效单位第一条为标准的剂量单位数量
	if (CalEqDoseMethod!=''){
		var BaseDoseQty=cspRunServerMethod(CalEqDoseMethod,OrderDoseUOMRowid,DrugFormRowid,OrderDoseQty);
		//dhcsys_alert("OrderDoseUOMRowid:"+OrderDoseUOMRowid+" DrugFormRowid:"+DrugFormRowid+" OrderDoseQty:"+OrderDoseQty);
		//dhcsys_alert("BaseDoseQty:"+BaseDoseQty+" OrderMaxDoseQty:"+OrderMaxDoseQty+" OrderMaxDoseQtyPerDay:"+OrderMaxDoseQtyPerDay+" OrderMaxDoseQtyPerOrder:"+OrderMaxDoseQtyPerOrder);
		if ((BaseDoseQty!='')&&(BaseDoseQty!=0)){
			if ((OrderMaxDoseQty!='')&&(OrderMaxDoseQty!=0)){
				if (parseFloat(BaseDoseQty)>parseFloat(OrderMaxDoseQty)){
					dhcsys_alert(t['ExceedPHDoseQtyLimit']);
					SetFocusColumn("OrderDoseQty",Row);
					return false;
				}
			}
			if ((OrderMaxDoseQtyPerDay!='')&&(OrderMaxDoseQtyPerDay!=0)){
				var BaseDoseQtyPerDay=parseFloat(BaseDoseQty)*parseFloat(freq) ;
				if ((parseFloat(BaseDoseQtyPerDay)>parseFloat(OrderMaxDoseQtyPerDay))){
					dhcsys_alert(t['ExceedPHDoseQtyPerDayLimit']);
					SetFocusColumn("OrderFreq",Row);
					return false;
				}
			}
			if ((OrderMaxDoseQtyPerOrder!='')&&(OrderMaxDoseQtyPerOrder!=0)){
				var BaseDoseQtyPerOrder=parseFloat(BaseDoseQty)*parseFloat(freq)* parseFloat(dur);
				if ((parseFloat(BaseDoseQtyPerOrder)>parseFloat(OrderMaxDoseQtyPerOrder))){
					dhcsys_alert(t['ExceedPHDoseQtyPerOrderLimit']);
					SetFocusColumn("OrderDur",Row);
					return false;
				}
			}
		}
		if ((OrderLimitDays!='')&&(OrderLimitDays!=0)){
			var OrderDepProcNote=GetColumnData("OrderDepProcNote",Row);
			if ((parseFloat(dur)>parseFloat(OrderLimitDays))&&(OrderDepProcNote=='')){
				AddRemarkClickhandler(Row);
				dhcsys_alert(t['ExceedPHDurationLimit']);
				SetFocusColumn("OrderDepProcNote",Row);
				return false;
			}
		}
	}
	return true;
	if ((Interval!="") && (Interval!=null)) {
		var convert=Number(dur)/Number(Interval)
		var fact=(Number(dur))%(Number(Interval));
		if (fact>0) {fact=1;} else {fact=0;}
		dur=Math.floor(convert)+fact;
	}
	var NumTimes=parseFloat(freq) * parseFloat(dur);
 
}
function SetPackQty(Row) {
	CheckFreqAndPackQty(Row)
	var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
    var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
    if ((OrderItemRowid!="")||(OrderARCIMRowid=="")) return;
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	//if ((PAAdmType=="I")&&(OrderPriorRowid!=OutOrderPriorRowid)&&(OrderPriorRowid!=OneOrderPriorRowid)) return true;
	var OrderType=GetColumnData("OrderType",Row);
	var OldOrderPackQty=GetColumnData("OrderPackQty",Row);
	var OrderConFac=GetColumnData("OrderConFac",Row);
	var OrderPrice=GetColumnData("OrderPrice",Row);
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var OrderStartDate=GetColumnData("OrderStartDate",Row);
	var OrderMultiDate=GetColumnData("OrderMultiDate",Row);
	var FreqDispTimeStr=GetColumnData("OrderFreqDispTimeStr",Row); 
	var freq=GetColumnData("OrderFreqFactor",Row);   
	var dur=GetColumnData("OrderDurFactor",Row);
	var Interval=GetColumnData("OrderFreqInterval",Row);
	var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);
	if (OrderType=="R"){
  	var OrderAutoCalculate=GetColumnData("OrderAutoCalculate",Row);
  	if ((OrderAutoCalculate==false)&&(HospitalCode=="NB")){return true}
	//如果是通过选择日期则需要计算天数
	if(OrderMultiDate) { //2014 -12-26 OrderMultiDate无效
		OrderMultiDate=OrderMultiDate.toString();
		if (OrderMultiDate!=""){
			var DateArr=OrderMultiDate.split(String.fromCharCode(2));
			dur=DateArr.length;
		}
	}
	var DrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
	var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
	var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
	var PackQty=1;
	var BaseDoseQty=1;
	var BaseDoseQtySum=1;
	if ((Interval!="") && (Interval!=null)) {
		var convert=Number(dur)/Number(Interval)
		var fact=(Number(dur))%(Number(Interval));
		if (fact>0) {fact=1;} else {fact=0;}
		dur=Math.floor(convert)+fact;
	}
	//dhcsys_alert(OrderDoseQty);
	if (OrderDoseQty!=""){
	//if ((OrderDoseQty!="")&&(parseInt(OrderDoseQty)!=0)){
	  	var valDoseQty=parseFloat(OrderDoseQty);
			//dhcsys_alert(valDoseQty+"^"+freq+"^"+dur+"^"+Interval+"^"+DrugFormRowid+"^"+OrderDoseUOMRowid+"^"+OrderConFac);
		  if (freq=="") freq=1;
			if (CalDoseMethod!=''){
				//dhcsys_alert(CalDoseMethod);
				BaseDoseQty=cspRunServerMethod(CalDoseMethod,OrderDoseUOMRowid,DrugFormRowid,valDoseQty);
				//dhcsys_alert("DrugFormRowid:"+DrugFormRowid+"  BaseDoseQty: "+BaseDoseQty+"   ItemConFac "+OrderConFac+"    valDoseQty:"+valDoseQty);
				if (BaseDoseQty=="") BaseDoseQty=1
				try{
					var NumTimes=1;
					if ((PAAdmType!="I")||((PAAdmType=="I")&&((OrderPriorRowid==OutOrderPriorRowid)||(OrderPriorRowid==OneOrderPriorRowid)||(OrderPriorRemarks=="ONE")))) {
						if (FreqDispTimeStr!=""){
							if (OrderStartDate==''){
								var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"4","2");
								var CurrDateTimeArr=CurrDateTime.split("^");
								OrderStartDate=CurrDateTimeArr[0];
							}
							NumTimes=GetCountByFreqDispTime(FreqDispTimeStr,OrderStartDate,dur);
						}else{
							NumTimes=parseFloat(freq) * parseFloat(dur);
						}
					}
					//dhcsys_alert("NumTimes :"+NumTimes)
					var BaseDoseQtySum = parseFloat(BaseDoseQty) * parseFloat(NumTimes);
			    //dhcsys_alert("BaseDoseQtySum :"+BaseDoseQtySum);
			    PackQty=parseFloat(parseFloat(BaseDoseQtySum)/parseFloat(OrderConFac));
					PackQty=PackQty.toFixed(4);
					PackQty=Math.ceil(PackQty);
			    //dhcsys_alert("BaseDoseQtySum: "+BaseDoseQtySum+"   PackQty: "+PackQty)
			    //RoundUpNum=Math.ceil(valDoseQty);
			  }catch(e){dhcsys_alert(e.message)}
			}
		}
	}else{
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		if (OrderDoseQty=="") OrderDoseQty=1;
		if ((dur==0)||(dur=="")){dur=1}
		if (PAAdmType=="I") {
			//如果是住院有隔几日的频次,就要把数量置为1
			if (FreqDispTimeStr!="") freq=1;
		} 
		PackQty=GetColumnData("OrderPackQty",Row);
		BaseDoseQtySum=PackQty
		if (isNumber(freq)&&isNumber(dur)&&isNumber(OrderDoseQty)){
			PackQty=parseInt(freq)*parseInt(dur)*parseInt(OrderDoseQty);
			BaseDoseQtySum=PackQty;
			BaseDoseQty="";
		}

	}
	SetOrderFirstDayTimes(Row);
	//门诊输液次数
	SetOrderLocalInfusionQty(Row);
	
	//if ((PAAdmType=="I")&&(OrderPriorRowid!=OutOrderPriorRowid)&&(OrderPriorRowid!=OneOrderPriorRowid)) {
	//dhcsys_alert(OMOrderPriorRowid+"^"+OMSOrderPriorRowid+"^"+OrderPriorRowid);
	if (PAAdmType=="I") {
		//中医院取药医嘱和出院带药医嘱需要整包装
		if (((OrderPriorRowid==OutOrderPriorRowid)||(OrderPriorRowid==OneOrderPriorRowid)||(OrderPriorRemarks=="ONE"))&&(CFOutAndOneDefaultPackQty==1)) {
			SetColumnData("OrderPackQty",Row,PackQty);
		  var OrderSum=parseFloat(OrderPrice)*PackQty;
			SetColumnData("OrderSum",Row,OrderSum);
		}else if (((OldOrderPackQty!="")&&(OrderType=="R"))||(OrderPriorRowid==OMOrderPriorRowid)||(OrderPriorRowid==OMSOrderPriorRowid)) {
			//如果已经有整包装或者是自备药医嘱则不用去计算金额
			return true;
		}else{
		  var OrderSum=(parseFloat(OrderPrice)/parseFloat(OrderConFac))*parseFloat(BaseDoseQtySum);
		  OrderSum=OrderSum.toFixed(4);
			SetColumnData("OrderBaseQty",Row,BaseDoseQty);	
			SetColumnData("OrderBaseQtySum",Row,BaseDoseQtySum);
			if (OrderType!="R") SetColumnData("OrderPackQty",Row,PackQty);
			SetColumnData("OrderSum",Row,OrderSum);
		}	
	}else{
		var DrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		//if ((IsSpecForm(DrugFormRowid))&&(PAAdmType!="I")&&(HospitalCode=="BJXHYY")&&(OrderDoseQty==t['ByDoctor'])){
		//	SetOrderUsableDays(Row);
		//}else{
			if (PackQty <= 0) {PackQty=1}
			var OrderSum=parseFloat(OrderPrice)*PackQty;
			OrderSum=OrderSum.toFixed(4);
			SetColumnData("OrderPackQty",Row,PackQty);
			SetColumnData("OrderBaseQty",Row,BaseDoseQty);
			SetColumnData("OrderBaseQtySum",Row,BaseDoseQtySum);
			SetColumnData("OrderSum",Row,OrderSum);
			SetOrderUsableDays(Row);
		//}
	}
	SetScreenSum();
	return true;	
}
function SetOrderUsableDays(Row) {
	if (CalcDurByArcimMethod=="") return;
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
	var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
	var OrderPackQty=GetColumnData("OrderPackQty",Row);
	var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
	var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
	
	var UsableDays=cspRunServerMethod(CalcDurByArcimMethod,OrderARCIMRowid,OrderFreqRowid,OrderDurRowid,OrderPackQty,OrderDoseQty,OrderDoseUOMRowid);
	SetColumnData("OrderUsableDays",Row,UsableDays);
}
function SetOrderFirstDayTimes(Row){
	if (HospitalCode=="ZJQZRMYY") return;
	var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var OrderType=GetColumnData("OrderType",Row);
	if ((OrderPriorRowid!=LongOrderPriorRowid)&&(OrderPriorRowid!=OMSOrderPriorRowid)) return;
	
	var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
	if (((OrderType=='R')||(OrderPHPrescType=='4'))&&(OrderFreqRowid!="")){
		if (GetTodayDispTimesMethod!=''){
			var OrderStartDate=GetColumnData("OrderStartDate",Row);
			var OrderStartTime=GetColumnData("OrderStartTime",Row);
			var OrderFirstDayTimes=cspRunServerMethod(GetTodayDispTimesMethod,OrderFreqRowid,OrderStartTime,OrderStartDate);
			SetColumnData("OrderFirstDayTimes",Row,OrderFirstDayTimes);
			OrderFirstDayTimesChangeCommon(Row);	
		}	
	}else{
		SetColumnData("OrderFirstDayTimes",Row,1);
	}
}

function SetOrderLocalInfusionQty(Row){
	var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
	var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
	var OrderFreqInterval=GetColumnData("OrderFreqInterval",Row);
	var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
	var OrderDurFactor=GetColumnData("OrderDurFactor",Row);
	var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
	var OrderType=GetColumnData("OrderType",Row);
	if ((OrderType=='R')&&(GetLocalInfusionInstrMethod!='')){
		var CFLocalInfusionInstrStr=cspRunServerMethod(GetLocalInfusionInstrMethod);
		CFLocalInfusionInstrStr="^"+CFLocalInfusionInstrStr+"^";
		if (CFLocalInfusionInstrStr.indexOf("^"+OrderInstrRowid+"^")!=-1){
			if (OrderFreqFactor=="") OrderFreqFactor=1;
			if (OrderDurFactor=="") OrderFreqFactor=1;
			if ((OrderFreqInterval!="") && (OrderFreqInterval!=null)) {
				var convert=Number(OrderDurFactor)/Number(OrderFreqInterval)
				var fact=(Number(OrderDurFactor))%(Number(OrderFreqInterval));
				if (fact>0) {
					fact=1;
				} else {
					fact=0;
				}
				OrderDurFactor=Math.floor(convert)+fact;
			}
			var OrderLocalInfusionQty=parseInt(OrderFreqFactor)*parseInt(OrderDurFactor);
			SetColumnData("OrderLocalInfusionQty",Row,OrderLocalInfusionQty);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////

function OrderFirstDayTimesChangeCommon(Row)
{
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	if (OrderMasterSeqNo!="") {
		OrderSeqNo=OrderMasterSeqNo;
		var MasterOrderFirstDayTimes="";
		for (var i=1; i<rows; i++){
			var tmpRow=GetRow(i);
			var tmpOrderSeqNo=GetColumnData("OrderSeqNo",tmpRow);
			if (tmpOrderSeqNo==OrderSeqNo) {
				MasterOrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",tmpRow);
				break;
			}
		}
		var OrderFirstDayTimes=MasterOrderFirstDayTimes;
	}else{
		var OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
	}
	var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
	var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
	var OrderType=GetColumnData("OrderType",Row);
	if (OrderType!="R") {
		if (OrderFirstDayTimes!="") {
			if (OrderDoseQty!="") {
				var OrderPackQty=Math.ceil(OrderFirstDayTimes*OrderDoseQty);
			}else{
				var OrderPackQty=OrderFirstDayTimes;
			}
		}else{
			if (OrderDoseQty!="") {
				var OrderPackQty=Math.ceil(OrderFreqFactor*OrderDoseQty);
			}else{
				var OrderPackQty=OrderFreqFactor;
			}
		}
		SetColumnData("OrderPackQty",Row,OrderPackQty);	
	}
	
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		var OrderSeqNoMasterLink=GetColumnData("OrderSeqNo",Row);		
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&((OrderMasterSeqNo==OrderSeqNo)||(OrderSeqNoMasterLink==OrderSeqNo))){	
			SetColumnData("OrderFirstDayTimes",Row,OrderFirstDayTimes);
			var OrderType=GetColumnData("OrderType",Row);
			if (OrderType!="R") {
				if (OrderFirstDayTimes!="") {
					if (OrderDoseQty!="") {
						var OrderPackQty=Math.ceil(OrderFirstDayTimes*OrderDoseQty);
					}else{
						var OrderPackQty=OrderFirstDayTimes;
					}
				}else{
					if (OrderDoseQty!="") {
						var OrderPackQty=Math.ceil(OrderFreqFactor*OrderDoseQty);
					}else{
						var OrderPackQty=OrderFreqFactor;
					}
				}
				SetColumnData("OrderPackQty",Row,OrderPackQty);	
			}
		}
	}
}

function Category_lookuphandler(e) {
	if (evtName=='Category') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += "?ID=d50013iCategory";
		url += "&CONTEXT=Kweb.OECOrderCategory:LookUpCat";
		url += "&TLUJSF=LookUpCatSelect";
		var obj=document.getElementById('Category');
		if (obj) url += "&P1=" + "";
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('Category');
	if (obj) obj.onkeydown=Category_lookuphandler;


function SubCategory_lookuphandler(e) {
	if (evtName=='SubCategory') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += "?ID=d50013iSubCategory";
		url += "&CONTEXT=Kweb.ARCItemCat:LookUpSubCat";
		url += "&TLUJSF=LookUpSubCatSelect";
		var obj=document.getElementById('Category');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('SubCategory');
		if (obj) url += "&P2=" + "";
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('SubCategory');
	if (obj) obj.onkeydown=SubCategory_lookuphandler;
	var obj=document.getElementById('ld50013iSubCategory');
	if (obj) obj.onclick=SubCategory_lookuphandler;
	
//Log 47556	
var evtTimerPharmacy;
var evtNamePharmacy;
var doneInitPharmacy=0;
var brokerflagPharmacy=1;
function PharmacyItem_lookuphandler(e) {
	if (evtNamePharmacy=='PharmacyItem') {
		window.clearTimeout(evtTimerPharmacy);
		evtTimerPharmacy='';
		evtNamePharmacy='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		brokerflagPharmacy=0;
		var url='websys.lookup.csp';
		url += "?ID=d128iPharmacyItem";
		url += "&CONTEXT=Kweb.OEOrdItem:LookUpItm";
		url += "&TLUJSF=OrderItemLookupSelect";
		//var obj=document.getElementById('Item');
		//if (obj) url += "&P1=" + websys_escape(obj.value);
		url += "&P1=XXX";
		var obj=document.getElementById('GroupID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('Category');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('subCatID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P12=" + websys_escape(obj.value);
		var obj=document.getElementById('PharmacyItem');
		if (obj) url += "&P13=" + websys_escape(obj.value);
		var obj=document.getElementById('Form');
		if (obj) url += "&P14=" + websys_escape(obj.value);
		var obj=document.getElementById('Strength');
		if (obj) url += "&P15=" + websys_escape(obj.value);
		var obj=document.getElementById('Route');
		if (obj) url += "&P16=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('PharmacyItem');
	if (obj) obj.onkeydown=PharmacyItem_lookuphandler;
	var obj=document.getElementById('ld50045iPharmacyItem');
	if (obj) obj.onclick=PharmacyItem_lookuphandler;

	
function Item_changehandler(encmeth) {
	evtName='Item';
	if (doneInit) { evtTimer=window.setTimeout("Item_changehandlerX('"+encmeth+"');",200); }
	else { Item_changehandlerX(encmeth); evtTimer=""; }
}
function Item_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('Item');

	if (obj.value!='') {  //&&(brokerflag)) { //L48722 - remove brokerflag, no use
		var tmp=document.getElementById('Item');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var tmp=document.getElementById('GroupID');
		if (tmp) {var p2=tmp.value } else {var p2=''};
		var tmp=document.getElementById('Category');
		if (tmp) {var p3=tmp.value } else {var p3=''};
		var tmp=document.getElementById('subCatID');
		if (tmp) {var p4=tmp.value } else {var p4=''};
		var tmp=document.getElementById('""');
		if (tmp) {var p5=tmp.value } else {var p5=''};
		var tmp=document.getElementById('""');
		if (tmp) {var p6=tmp.value } else {var p6=''};
		var tmp=document.getElementById('""');
		if (tmp) {var p7=tmp.value } else {var p7=''};
		var tmp=document.getElementById('EpisodeID');
		if (tmp) {var p8=tmp.value } else {var p8=''};
		if (cspRunServerMethod(encmeth,'Item_lookupsel','OrderItemLookupSelect',p1,p2,p3,p4,p5,p6,p7,p8)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Item');
			return websys_cancel();
		}
	}
	obj.className='';
	//brokerflag=1;
}

function HiddenDeleteOrder_changehandler(encmeth) {
	//dhcsys_alert(" "+encmeth+" "+Gparam1+" "+Gparam2+" "+Gparam3+" "+Gparam4);
	//Dcheckval=cspRunServerMethod(encmeth,Dparam1);
	cspRunServerMethod(encmeth,Dparam1);
}

function HiddenUpdateGroupNumber_changehandler(encmeth) {
	//dhcsys_alert(Uparam1+","+Uparam2);
	var ret="";
	var selList = lstOrders;
	var length = selList.length;
	ret=cspRunServerMethod(encmeth,Uparam1,Uparam2);
	if (ret=="Y") {
		for (var i=0; i<length; i++) {
			if (selList.options[i].selected) selList.options[i].text=mPiece(selList.options[i].text,"((",0)+"(("+Uparam1+"))";
		}
	}
}

function HiddenNewDentalOrder_changehandler(encmeth) {
	//dhcsys_alert(" "+encmeth+" "+Gparam1+" "+Gparam2);
	//Dcheckval=cspRunServerMethod(encmeth,Dparam1);
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID");
	if (objEpisodeID) EpisodeID=objEpisodeID.value;
	Ncheckval=cspRunServerMethod(encmeth,Nparam1,Nparam2,EpisodeID);
	//dhcsys_alert("Ncheckval="+Ncheckval);
	if (Ncheckval!="") {
		var k=lstOrders.length;
		var NewOrderString="";
		var NewOrder="";
		var OrderDesc="";
		var OrderRowID="";
		var OrderItmMastID="";
		var idata="";
		var itype="";
		for (var bm3=0; bm3<k; bm3++) {
			if (lstOrders.options[bm3].ORIRowId.indexOf(Nparam1)>-1) {
				idata=lstOrders.options[bm3].idata;
				itype=lstOrders.options[bm3].itype;
				break;
			}
		}
		for (var bm3=0; bm3<Ncheckval.split("^").length-1; bm3++) {
			NewOrder=mPiece(Ncheckval,"^",bm3);
			OrderRowID=mPiece(NewOrder,String.fromCharCode(1),0);
			OrderItmMastID=mPiece(NewOrder,String.fromCharCode(1),1);
			OrderDesc=mPiece(NewOrder,String.fromCharCode(1),2);
			if (Nparam3!="") lstOrders.options[k+bm3]=new Option(OrderDesc+"(("+Nparam3+"))",OrderItmMastID);
			else lstOrders.options[k+bm3]=new Option(OrderDesc,OrderItmMastID);
			lstOrders.options[k+bm3].ORIRowId=OrderItmMastID+"*"+OrderRowID+"*V^";
			lstOrders.options[k+bm3].idata=idata;
			if (itype.split(Nparam1).length=1)lstOrders.options[k+bm3].itype=itype;
			if (itype.split(Nparam1).length>1) lstOrders.options[k+bm3].itype=mPiece(itype,Nparam1,0)+OrderRowID+mPiece(itype,Nparam1,1);
			NewOrderString=NewOrderString+lstOrders.options[k+bm3].ORIRowId;
		}
		if (NewOrderString!="") {
			var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
			if (OEOrdItemIDsobj) OEOrdItemIDsobj.value=OEOrdItemIDsobj.value+NewOrderString;
		}
	}
}

function HiddenCheck_changehandler(encmeth) {
	//dhcsys_alert(" "+encmeth+" "+Gparam1+" "+Gparam2+" "+Gparam3+" "+Gparam4);
	Gcheckval=cspRunServerMethod(encmeth,Gparam1,Gparam2,Gparam3,Gparam4);
}

function HiddenAuthCheck_changehandler(encmeth) {
	//dhcsys_alert(" "+encmeth+" "+Gparam1+" "+Gparam2+" "+Gparam3+" "+Gparam4);
	Acheckval=cspRunServerMethod(encmeth,Aparam1);
}

function PricesClickHandler() {
}

function AgeSexRestrictionCheck(selItmid,seldesc,selsubcatcode,seldur,selmatch,obj,seltype) {
	var DrugString="";
	var EpisObj=document.getElementById("EpisodeID");
	if (EpisObj) EpisID=EpisObj.value;

	var DDObj=document.getElementById("DischDate");
	if(DDObj && (DDObj.value!="")) {
		//dhcsys_alert("DDDATE"+DDObj.value);
		selmatch="found"
	}

	if (selsubcatcode=="R") {
		DrugString=DrugInteractionCheck(selItmid,seldesc,seldur,"");
		//dhcsys_alert("DrugString "+DrugString)
		var DIobj=document.getElementById("DrugString");
		if ((DIobj)&&(DrugString!="")) DIobj.value=DrugString;
	}
	var PatObj=document.getElementById("PatientID");
	if (PatObj) PatID=PatObj.value;

	var DateObj=document.getElementById("Date");
	if (DateObj) DateVal=DateObj.value;

	var OrderSetRowid=lstOrders.options[lstOrders.selectedIndex].value;

	//var f1=top.frames['TRAK_hidden'];
	//modify by wuqk 2010-07-02 for exr framework
	var f1=top.document.getElementsByName("TRAK_hidden");
	//AmiN  log25880 adding message for items not covered by insurance    IT is an F ONE not F L
	if (f1) {
		//dhcsys_alert("hello allergy ");
		//dhcsys_alert("in oeorder.custom.csp"+"PatID="+PatID+" OEORIItmMastDR="+selItmid+"  ARCIMDesc="+seldesc+"  durid="+seldur)
		//ANA LOG 25687 Checks system flag to decide wether to show message as a pop up or on the summary screen. 30-SEP-02
		var alertOBJ=document.getElementById("SUMMFlag")
		if ((alertOBJ)&&(alertOBJ.value!="Y")) {
			DrugString=escape(DrugString);
			OrderSetRowid=escape(OrderSetRowid);
			f1.location="oeorder.agesexrestriction.csp?PatID="+PatID+"&OEORIItmMastDR="+selItmid+"&ARCIMDesc="+seldesc+"&durid="+seldur+"&CatMatch="+selmatch+"&OrderSetRowid="+OrderSetRowid+"&DateVal="+DateVal+"&EpisID="+EpisID+"&type="+seltype+"&drugs="+DrugString;
			//f1.location="oeorder.agesexrestriction1.csp?PatID="+PatID+"&OEORIItmMastDR="+selItmid+"&ARCIMDesc="+seldesc+"&durid="+seldur+"&CatMatch="+selmatch+"&OrderSetRowid="+OrderSetRowid+"&DateVal="+DateVal+"&EpisID="+EpisID+"&type="+seltype+"&drugs="+DrugString;
		} else {
			if (selmatch=="found") {
				//OrderDetailsOpen(seldesc,"",selItmid,OrderSetRowid,EpisID);
			}
		}
	}
	else if (selmatch=="found") {
		//OrderDetailsOpen(seldesc,"",selItmid,OrderSetRowid,EpisID);
	}
}
function AlertCheck(selItmid,seldesc,selsubcatcode,seldur,selmatch,obj,seltype) {
	var DrugString="";
	var EpisObj=document.getElementById("EpisodeID");
	if (EpisObj) EpisID=EpisObj.value;

	var DDObj=document.getElementById("DischDate");
	if(DDObj && (DDObj.value!="")) {
		selmatch="found"
	}

	if (selsubcatcode=="R") {
		DrugString=DrugInteractionCheck(selItmid,seldesc,seldur,"");
		//dhcsys_alert("DrugString "+DrugString)
		var DIobj=document.getElementById("DrugString");
		if ((DIobj)&&(DrugString!="")) DIobj.value=DrugString;
	}
	var PatObj=document.getElementById("PatientID");
	if (PatObj) PatID=PatObj.value;

	var DateObj=document.getElementById("Date");
	if (DateObj) DateVal=DateObj.value;

	var OrderSetRowid=lstOrders.options[lstOrders.selectedIndex].value;

	//var f1=top.frames['TRAK_hidden'];	
	//modify by wuqk 2010-07-02 for exr framework
	var f1=top.document.getElementsByName("TRAK_hidden");
	//AmiN  log25880 adding message for items not covered by insurance    IT is an F ONE not F L
	if (f1) {
		//dhcsys_alert("in oeorder.custom.csp"+"PatID="+PatID+" OEORIItmMastDR="+selItmid+"  ARCIMDesc="+seldesc+"  durid="+seldur)
		//ANA LOG 25687 Checks system flag to decide wether to show message as a pop up or on the summary screen. 30-SEP-02
		DrugString=escape(DrugString);
		OrderSetRowid=escape(OrderSetRowid);
		f1.location="oeorder.agesexrestriction.csp?PatID="+PatID+"&OEORIItmMastDR="+selItmid+"&ARCIMDesc="+seldesc+"&durid="+seldur+"&CatMatch="+selmatch+"&OrderSetRowid="+OrderSetRowid+"&DateVal="+DateVal+"&EpisID="+EpisID+"&type="+seltype+"&drugs="+DrugString;
	}
}

function DrugInteractionCheck(selItmid,selItmDesc,selItmDur,os) {
	var EpisObj=document.getElementById("EpisodeID");
	if (EpisObj) EpisID=EpisObj.value;

	var selList = lstOrders;
	var length = selList.length;
	var drugs="";
	var subcatcode="";
	var listItem="";
	var listValue="";
	var dur="";
	var drugParams="";
	for (var i=0; i<length; i++) {
		subcatcode=mPiece(selList.options[i].id,String.fromCharCode(4),0);
		if (subcatcode=="R") {
			listItem = selList.options[i].text;
			listValue = selList.options[i].value;
			dur = mPiece(selList.options[i].id,String.fromCharCode(4),1);
			//dhcsys_alert(dur+" duration ");
			drugParams=listValue+String.fromCharCode(2)+String.fromCharCode(2)+dur+String.fromCharCode(2);
			drugs=drugs+drugParams+String.fromCharCode(5);
		}
	}
	//dhcsys_alert("drugs= "+drugs);
	//var f2=top.frames['TRAK_hidden'];
	//if ((os!="") && (f2)) top.frames['TRAK_hidden'].location="oeorder.druginteractions.csp?itmMast="+selItmid+"&durid="+selItmDur+"&drugs="+drugs+"&EpisodeID="+EpisID+"&ordDesc="+selItmDesc+"&forderset="+os;
	return drugs;
}
function getAlertDesc(desc) {
	var listid = lstOrders.options[lstOrders.length-1].id;
	lstOrders.options[lstOrders.length-1].id = listid + String.fromCharCode(4)+desc;
}

function SelectAllItemList() {
	for (pi=0;pi<lstOrders.length;pi++) {
		lstOrders.options[pi].selected=true;
	}
}

//Log 49182 PeterC 20/04/05 Use the below function to tell which order has yet to be updated.
function SelectAllPreUpdateItem() {
	for (pi=0;pi<lstOrders.length;pi++) {
		var HasUpdate=lstOrders.options[pi].itype;
		if(HasUpdate.indexOf("||")==-1) lstOrders.options[pi].selected=true;
	}
}

function OrderDetailsPage(f) {
		var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
		var txtobj=document.getElementById("itemtext"); //Enter item with free text area
		if (txtobj) {
			itemtext=txtobj.value;
			var str=StripAllSpaces(itemtext);
		}
		//dhcsys_alert(str);
		if (lstOrders.selectedIndex == -1) {
			//dhcsys_alert("Please select an item");
			return;
		}
		var ItemDesc = mPiece(lstOrders.options[lstOrders.selectedIndex].text,"((",0);
		var itemdata=lstOrders.options[lstOrders.selectedIndex].idata;
		var itemvalue=lstOrders.options[lstOrders.selectedIndex].value;  // OrderSetRowid
		var itype=lstOrders.options[lstOrders.selectedIndex].itype;
		//dhcsys_alert("itype="+itype);
		var CatID=mPiece(lstOrders.options[lstOrders.selectedIndex].itype,String.fromCharCode(4),3);
		var SubCatID=mPiece(lstOrders.options[lstOrders.selectedIndex].itype,String.fromCharCode(4),5);
		//dhcsys_alert(itemvalue+"           "+itype);
		var ORIRowID="";
		var OrdRowIdString="";
		ORIRowID=lstOrders.options[lstOrders.selectedIndex].ORIRowId;
		//dhcsys_alert(ItemDesc+'\n data:'+itemdata+'\n value:'+itemvalue+'\n type:'+itype+'\n ORIRowid:'+ORIRowID);
		OrdRowIdString=ORIRowID;
		if (ORIRowID!="") {
			var NewOrderArr=ORIRowID.split("^")
			var ORIRowID="";
			var currOrder="";
			var ORIRowIDArr="";
			for (var jl=0;jl<NewOrderArr.length;jl++) {
				currOrder=NewOrderArr[jl]
				if(currOrder=="") continue;
				ORIRowIDArr=currOrder.split("*")
				if (ORIRowIDArr.length>1) ORIRowID=ORIRowID+ORIRowIDArr[1]+"^";
			}
			ORIRowID=ORIRowID.substring(0,(ORIRowID.length-1))
			//dhcsys_alert(ORIRowID);
			//var ORIRowIDArr=ORIRowID.split("*")
			//ORIRowID=ORIRowIDArr[1];
			}
		var ItemId=lstOrders.options[lstOrders.selectedIndex].id;

		var OSRowid=itemvalue;
		//dhcsys_alert("OSRowid"+OSRowid);
		var OSRowidFromitype = mPiece(itype,String.fromCharCode(4),2);
		if (!OSRowidFromitype) {
			OSRowidFromitype="";
		}
		OrderDetailsOpenCount++;
		if (mPiece(itype,String.fromCharCode(4),0)=="ARCOS") {
			OSItemListOpen(OSRowid,ItemDesc,"YES","",OrdRowIdString);
		} else if (OSRowid.indexOf("||")<0) {
			OSItemListOpen(OSRowid,ItemDesc,"YES","",OrdRowIdString);
		} else {
			if (!itemdata) itemdata="";
			if (OSRowidFromitype!="") OSRowid=OSRowidFromitype;
			if (mPiece(itemdata,String.fromCharCode(1),4)=="NODETAILS") itemdata="";
			var EpisObj=document.getElementById("EpisodeID");
			if (EpisObj) EpisID=EpisObj.value;
			//dhcsys_alert("ItemDesc/itemdata/itemvalue/OSRowid/EpisID="+ItemDesc+"/"+itemdata+"/"+itemvalue+"/"+OSRowid+"/"+EpisID);
			if (ORIRowID=="") {
				var itypeLen=itype.split(String.fromCharCode(4)).length;
				if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
				if (ORIRowID.split("*").length>1) ORIRowID=mPiece(ORIRowID,"*",1);
			}
			OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID); // itemvalue from item selected in Selected Orders
		}
}
function OrderDetailsShowing(f,ShowAutoOnly) {
	        //dhcsys_alert("OrderDetailsShowing");
		var txtobj=document.getElementById("itemtext"); //Enter item with free text area
		if (txtobj) {
			itemtext=txtobj.value;
			var str=StripAllSpaces(itemtext);
		}
		//if ((lstOrders.selectedIndex == -1) && ((str==""))) {
		//Log 41115 PeterC: Modified the above for freetext to work
		//dhcsys_alert("selectedIndex="+lstOrders.selectedIndex+" OrderDetailsOpenCount="+OrderDetailsOpenCount);
		if (lstOrders.selectedIndex == -1) {
			//dhcsys_alert("Please select an item");
			return;
		}
		//dhcsys_alert(lstOrders.selectedIndex+"***"+OrderDetailsOpenCount);
		if (lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount] && lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].selected) {
			var ItemDesc = lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].text;
			var itemdata=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].idata;
			var itemvalue=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].value;  // OrderSetRowid
			var itype=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype;
			//dhcsys_alert("itype="+itype);
			var CatID=mPiece(lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype,String.fromCharCode(4),3);
			var SubCatID=mPiece(lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype,String.fromCharCode(4),5);
			var HasAutoPopUp=mPiece(lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].itype,String.fromCharCode(4),6);
			//dhcsys_alert("CS"+CatID+","+SubCatID)
			var ORIRowID=""
			ORIRowID=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].ORIRowId;
			if (ORIRowID!="") {
				var ORIRowIDArr=ORIRowID.split("*")
				if (ORIRowIDArr.length>1) ORIRowID=ORIRowIDArr[1];
			}
			var OSOrdRowIdString="";
			//dhcsys_alert(itype +"###"+ORIRowID);
			var itypeLen=itype.split(String.fromCharCode(4)).length;
			if (itypeLen>1) OSOrdRowIdString=mPiece(itype,String.fromCharCode(4),itypeLen-2);
			//dhcsys_alert(OSOrdRowIdString);

			var OSRowid=itemvalue;
			var OSRowidFromitype = mPiece(itype,String.fromCharCode(4),2);
			if (!OSRowidFromitype) {
				OSRowidFromitype="";
			}

			var LinkedItmID1="";
			var newOrderValue=lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].text;
			if (newOrderValue.substring(0,5)=="     ") {
				var bCanCopy=false;
				var orderValue="";
				var orderType="";
				for (var bm8=0;bm8<lstOrders.selectedIndex+OrderDetailsOpenCount;bm8++) {
					orderValue=lstOrders.options[bm8].text;
					orderType=mPiece(lstOrders.options[bm8].id,String.fromCharCode(4),0);
					if (orderValue.substring(0,1)!=" ") {
						if (orderType=="R") {
							bCanCopy=true;
							LinkedItmID1=lstOrders.options[bm8].ORIRowId;
							if (LinkedItmID1.split("*").length>1) LinkedItmID1=mPiece(LinkedItmID1,"*",1);
						}
			 			else {
							bCanCopy=false;
							LinkedItmID1="";
						}
					}
				}
				lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount].text="   "+newOrderValue.substring(5,newOrderValue.length)
				//dhcsys_alert("LinkedItmID1="+LinkedItmID1);
			}

			OrderDetailsOpenCount++;
			if (mPiece(itype,String.fromCharCode(4),0)=="ARCOS") {
				//Log 44538 28/07/04 PeterC: Take out the first item in OS for testing
				var OSFirstItem=newItmMastDR=mPiece(mPiece(OSOrdRowIdString,"^",0),"*",0);
				//Log 49059 PeterC 22/03/05: Now pass "OSRowid" into matchCategory
				if (matchCategory("OS",CatID,SubCatID,(OSFirstItem+"^"+OSRowid))) {
				//if (matchCategory("OS",CatID,SubCatID,itemvalue)) {
					OSItemListOpen(OSRowid,ItemDesc,"YES","",OSOrdRowIdString);
				}
				else OrderDetailsShowing(f);
			} else if (OSRowid.indexOf("||")<0) {
				if (matchCategory("OS",CatID,SubCatID,itemvalue)) OSItemListOpen(OSRowid,ItemDesc,"YES","",OSOrdRowIdString);
				else OrderDetailsShowing(f);
			} else {
				if (!itemdata) itemdata="";
				if (OSRowidFromitype!="") OSRowid=OSRowidFromitype;

				if (mPiece(itemdata,String.fromCharCode(1),4)=="NODETAILS") itemdata="";
				var EpisObj=document.getElementById("EpisodeID");
				if (EpisObj) EpisID=EpisObj.value;
				//dhcsys_alert("ItemDesc/itemdata/itemvalue/OSRowid/EpisID="+ItemDesc+"/"+itemdata+"/"+itemvalue+"/"+OSRowid+"/"+EpisID);
				//dhcsys_alert("matchcategory "+CatID+"##"+SubCatID+"##"+itemvalue);
				//Log 49059 PeterC 15/02/05: Do not pop up the detail page again if it already has pop up
				if((matchCategory("IM",CatID,SubCatID,itemvalue) && (HasAutoPopUp!="1")) || (LinkedItmID1!="")) {
					OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID,LinkedItmID1); // itemvalue from item selected in Selected Orders
					//Log 52136 16/05/05 PeterC
					var DataStr = lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount-1].itype
					var lu=DataStr.split(String.fromCharCode(4));
					if(lu) {
						lu[6]="1";
						DataStr=lu.join(String.fromCharCode(4));
						DataStr=DataStr.replace("undefined","");
						lstOrders.options[lstOrders.selectedIndex+OrderDetailsOpenCount-1].itype=DataStr;
					}
				}
				else if (mPiece(StockInOtherLoc,itemvalue+"*",0)!=StockInOtherLoc) { // If the stock exists in other Receiving Location, user choose to continue order this item, pop up the detail screen to ask user to choose a rec loc.
					OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID,ORIRowID,LinkedItmID1); 
				}
				else OrderDetailsShowing(f);
			}
		}
}
function OrderDetailsOpen(sItemDesc,sitemdata,sitemvalue,sOSRowid,sEpisodeID,ORIRowID,LinkedItmID1) {
		var win=window.open('',"AlertScreen");
		var uobj="";
		if (win) uobj=win.document.getElementById("Update");
		if ((win)&&(uobj)) {
			setTimeout("OrderDetailsOpen('"+sItemDesc+"','"+sitemdata+"','"+sitemvalue+"','"+sOSRowid+"','"+sEpisodeID+"','"+ORIRowID+"','"+LinkedItmID1+"')",500);
		}
		else {
		if (win) win.window.close();
		//dhcsys_alert(sItemDesc+"*"+sitemdata+"*"+sitemvalue+"*"+sOSRowid+"*"+ORIRowID);
		var OkToOpen=1;
		var OSdefSobj=document.getElementById("OECFDefaultCheckBsUnselect");
		var OSIndex=sOSRowid.indexOf("||");
		//if ((OSdefSobj)&&(OSdefSobj.value=="Y")&&(OSIndex==-1)) OkToOpen=0;
		var PatObj=document.getElementById("PatientID");
		if (PatObj) PatientID=PatObj.value;
		var EpisLoc=document.getElementById("EpisLoc");
		if (EpisLoc) {var PatientLocation=EpisLoc.value;} else {
			var PatLoc=document.getElementById("PatLoc");
			if (PatLoc) var PatientLocation=PatLoc.value;
		}
		if (PatientLocation!="") PatientLocation=escape(PatientLocation);
		if (sItemDesc!="") sItemDesc=escape(sItemDesc);
		if (!LinkedItmID1) LinkedItmID1="";
		//Loads default values - if default carry to every item - log 22982
		if (sitemdata=="") sitemdata=strDefaultData;
		var context="";
		var contextobj=document.getElementById("CONTEXT");
		if (contextobj) context=contextobj.value;
		var OrderedRowIDs="";
		for (var bm6=0;bm6<lstOrders.length;bm6++) {
			if (bm6!=lstOrders.selectedIndex) {
				OrderedRowIDs=OrderedRowIDs+lstOrders.options[bm6].ORIRowId+"^";
			}
		}
		var CantModifyToothFlag="";
		var TeethIDsobj=document.getElementById("TeethIDs");
		if ((TeethIDsobj)&&(TeethIDsobj.value!="")) CantModifyToothFlag="Y";
		//Log 50088 PeterC 21/03/05 Need to escape the itemdata
		if(sitemdata!="") sitemdata=escape(sitemdata);
		//dhcsys_alert(OrderedRowIDs);
		var url = "oeorder.mainloop.csp?ID="+ORIRowID+"&ARCIMDesc="+sItemDesc+"&EpisodeID="+sEpisodeID+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&PatientID="+PatientID+"&PatientLoc="+PatientLocation+"&LinkedOrder="+LinkedItmID1+"&OrderWindow="+window.name+"&CONTEXT="+context+"&OrderedRowIDs="+OrderedRowIDs+"&CantModifyToothFlag="+CantModifyToothFlag;
		//dhcsys_alert("url="+url);
    if (HospitalCode=="HF"){
		   if(OkToOpen==1) websys_createWindow(url, "frmOrderDetails","height="+(screen.availHeight-40)+",width="+(screen.availWidth-10)+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes")
	     return;
	  }
		var posn='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=0,left=0,width='+screen.availWidth+',height='+screen.availHeight;
		//var posn="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes"		
		if(OkToOpen==1) websys_createWindow(url, "frmOrderDetails",posn)
		}
}

function CollectedFields(DataFields){
	var selItem=lstOrders.options[lstOrders.selectedIndex];
	selItem.idata=DataFields;
}

function SetDefaultData(sDefaultData) {
	var obj=document.getElementById("DefaultData");
	strDefaultData=sDefaultData;
	if (obj) obj.value=sDefaultData
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

function CheckFreqBeforeUpdate() {
	var length = lstOrders.length;
	for (var i=0; i<length; i++) {
		if (lstOrders.options[i].id="NO DEFAULT") {
			//dhcsys_alert('item='+lstOrders.options[i].value+'-'+lstOrders.options[i].text);
			Update=false;
			break;
		}
	}
}
function getDelim(val) {
	var delim="";
	if (val>0) {
		for (i=1;i<val;i++) {
			delim=delim+String.fromCharCode(1);
		}
		return delim;
	}
}
// removes all spaces from a string
function StripAllSpaces(str)  {
	var re = /(\s)/g ;
	return str.replace(re,"");
}

function RedrawFavourites(tabidx,FocusWindowName) {
	//if (currTab==tabidx) return;
	//Log 54451 PeterC 19/08/05
	var formulary="";
	var obj=document.getElementById("NonFormulary");
	if (obj) {
	 	if (obj.checked) formulary="Y";
		else {formulary="N";}
	}

	if (!obj) formulary="";
	if ((FocusWindowName)&&(FocusWindowName!="")) {
		websys_createWindow(lnkFav+'&TABIDX='+tabidx+'&FocusWindowName='+FocusWindowName+'&formulary='+formulary,'TRAK_hidden');
	}else{
		//如果模板内容出不来?有可能窗口出错?可以把第二个参数'TRAK_hidden'设为空?就可以显示弹出窗口
		websys_createWindow(lnkFav+'&TABIDX='+tabidx,'TRAK_hidden');
		//将默认的list index置为空
		lstidx=""; 
		//如果TAB页切换不过来?可以用下面的语句还察看
		//websys_createWindow(lnkFav+'&TABIDX='+tabidx,'TRAK1');
	}
	var obj=document.getElementById("TAB"+currTab);
	if (obj) obj.className="PrefTab";
	var obj=document.getElementById("TAB"+tabidx);
	if (obj) obj.className="selectedPrefTab";
	currTab=tabidx;
	//因为切换Tab时会根据模板的设定置上Categor和SubCategory?为了不影响开医嘱?默认要置为空
	window.setTimeout("ClearCategory()",1000);
}

function ClearCategory(){

	obj=document.getElementById('catID');
	if (obj) obj.value='';
	obj=document.getElementById('Category');
	if ((obj)&&(obj.tagName=='INPUT')) {obj.value='';};
	obj=document.getElementById('subcatID');
	if (obj) obj.value='';
	obj=document.getElementById('SubCategory');
	if ((obj)&&(obj.tagName=='INPUT')) obj.value="";
}

function AddToPrefTabClickHandlerNew(evt) {
	// lgl+ 原函数无论新医嘱录入还是老的,即使修改过bug,也都只能做到添加到个人模版
	// 所以新做函数取代 并且可以具体到指定的listbox
	//var	newlnk = lnkFav + "&TABIDX="+currTab + "&CTLOCID="+PatLocID;
	if (AddToFavMethod=="") return false;
	var arr = new Array();
	try {
		//dhcsys_alert("FocusRowIndex"+","+FocusRowIndex);
		if (FocusRowIndex==0){
			dhcsys_alert(t['SelectIsNull']);
			return false;
		}
		var RowSel=GetRow(FocusRowIndex);  //lgl+防止删除后用FocusRowIndex不正确
		//dhcsys_alert("RowSel"+RowSel);
		var id=GetColumnData("OrderARCIMRowid",RowSel);
    //dhcsys_alert(RowSel+","+id);
    if (id=="") {
	    dhcsys_alert(t['SelectIsNull']);
	    return false;  //lgl + false 防止报错
    }
    arr[0] = "ARCIM" + itemdataDelim + id;
 	} catch(e) {
		dhcsys_alert(e.message);
		return false;
	}

	var userid=session["LOGON.USERID"];  //如果为空?
	var ctlocid=session["LOGON.CTLOCID"];
	var groupid=session["LOGON.GROUPID"];
	var siteid=session["LOGON.SITECODE"];  //医嘱模板,站点一级无实际意义.上下文我在合肥禁用掉,也可以不考虑
	if (lstidx==""){
		dhcsys_alert(t['NoListSelected']);
		return false;
	}
	var CONTEXT=session['CONTEXT'];
	var other=userid+"^"+ctlocid+"^"+groupid+"^"+currTab+"^"+lstidx+"^"+id+"^"+CONTEXT; 
	var ret=cspRunServerMethod(AddToFavMethod,other);
	if (ret=="0") {dhcsys_alert(t['Success_AddToFavPref']);}else{dhcsys_alert(t['Fail_AddToFavPref']);}
	websys_createWindow(lnkFav+'&TABIDX='+currTab,'TRAK_hidden');
	return false;
}

function AddToPrefTabClickHandler(evt) {
	/*
	if (lstOrders.selectedIndex == -1) return false;
	//var lnk=websys_getSrcElement(evt);
	var lnk = document.getElementById('addtotabs');
	newlnk = lnkFav + "&TABIDX="+currTab + "&CTLOCID="+PatLocID;
	var arr = new Array();
	var type="";
	var id="";
	var oerowid="";
	for (var j=0,i=0; j<lstOrders.length; j++) {
		if (lstOrders.options[j].selected==true) {
			type = lstOrders.options[j].itype.split(String.fromCharCode(4))[0];
			id = lstOrders.options[j].value.split(String.fromCharCode(4))[1];
			if (!id) id = lstOrders.options[j].value;
			arr[i] = type + itemdataDelim + id;
			i++;
		}
	}
	*/
	
	var lnk = document.getElementById('addtotabs');
	newlnk = lnkFav + "&TABIDX="+currTab + "&CTLOCID="+PatLocID;
	var arr = new Array();
	try {
		var id=GetColumnData("OrderARCIMRowid",FocusRowIndex);
    if (id=="") {
	    dhcsys_alert(t['SelectIsNull']);
	    return false;  
    }
    arr[0] = "ARCIM" + itemdataDelim + id;
 	} catch(e) {};
	newlnk += "&EXTRAPREFITEMS="+escape(arr.join(groupitemDelim));
	websys_createWindow(newlnk,'TRAK_hidden');
	return false;
}


function EnabledUpdateBtnHandler() {
	var obj=document.getElementById("Update");
	if (obj) obj.disabled=false;
}
function SelectOrdersChangeHandler(){
	
}
function SelectOrdersClickHandler(){

}
function groupListClickHandler(){  //lgl+ 
	var eSrc=websys_getSrcElement();
	var obj=document.getElementById(eSrc.id);
	for (var j=1; j<6; j++) {
		var listg="group"+j;
		if (listg!=eSrc.id){
			var obj=document.getElementById("group"+j);
		  if (obj) {
				obj.selectedIndex=-1;
				if (HospitalCode=="HF") {obj.style.width=230;}else{obj.style.width=xiniwidth;}
		  }
		}else{
		 var obj=document.getElementById("group"+j);
		 if(obj) {
		 		if (HospitalCode=="HF") {obj.style.width=300;}else{obj.style.width=270;}
			}
		 lstidx=j;  
		}
	}
}

function Init() {
	var j;
	var obj;
	//ANA Simon Player testing
	//flagOBJ=document.getElementById("DisplayQuestionFlag");
	//if (flagOBJ) dhcsys_alert("DisplayQuestionFlag "+flagOBJ.value);

	//flagOBJ=document.getElementById("NewOrders");
	//if (flagOBJ) dhcsys_alert("NewOrders "+flagOBJ.value);
	for (var j=1; j<6; j++) {   //lgl+0611 避免选中多个List框
		obj=document.getElementById("group"+j);
		if (obj) {
			obj.onclick=groupListClickHandler;
			if (j==1){xiniwidth=obj.style.width}
		}
	}

  obj=document.getElementById("oehelp");
	if (obj) obj.onclick=oehelpClickHandler;

  obj=document.getElementById("Add");
	if (obj) obj.onclick=AddClickHandler;

	obj=document.getElementById("AddToFav");
	//if (obj) obj.onclick=AddToFavClickHandler;
	//if (obj) obj.onclick=AddToPrefTabClickHandler;
	//if (tsc['AddToFav']) websys_sckeys[tsc['AddToFav']]=AddToPrefTabClickHandler;
	//解决追加时会替换掉科室模板的问题??需研究合并到AddToPrefTabClickHandler
	if (obj) obj.onclick=AddToPrefTabClickHandlerNew;
	if (tsc['AddToFav']) websys_sckeys[tsc['AddToFav']]=AddToPrefTabClickHandlerNew;


	obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;

	obj=document.getElementById("OrderDetails")
	if (obj) {
		obj.disabled=false;
		obj.onclick=OrderDetailsClickHandler;
	}

	obj=document.getElementById("Update")
	if (obj) {
		obj.disabled=false;
		obj.onclick=UpdateClickHandler;
	}

	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=UpdateClickHandler;
	}

	obj=document.getElementById("UpdateGroupNumber");
	if (obj) obj.onclick=UpdateGroupNumberClickHandler;
	
	obj=document.getElementById("CheckPrices");
	if (obj) obj.onclick=PricesClickHandler;
	//if (obj) obj.disabled=true;
	
	obj=document.getElementById("CheckCosts");
	if (obj) obj.onclick=CostsClickHandler;

	for (var j=1; j<6; j++) {
		obj=document.getElementById("group"+j);
		if (obj) obj.ondblclick=ListDoubleClickHandler;
		if (obj) obj.onchange=ListClickHandler;
	}
	var SpecColObj=document.getElementById("SpecCollected");
	if (SpecColObj) SpecColObj.onclick=SpecColCheck;
	var ColDateobj=document.getElementById("ColDate");
	var ColTimeobj=document.getElementById("ColTime");

	if (ColDateobj && ColDateobj.value!="") {
		if (SpecColObj)	SpecColObj.checked=true;
	}

	var RecDateObj=document.getElementById("ReceivedDate");
	if (RecDateObj) RecDateObj.onblur=ActivateSpecCol;

	var PINObj=document.getElementById("PIN");
	if((PINObj)&&(PINObj.className!="clsInvalid")) {
		if((ColDateobj)&&(ColDateobj.value==""))
		DisableFields();
	}
	//Log 49262 PeterC 24/01/05
	var obj=document.getElementById("CareProv");
	var LCobj=document.getElementById("LogonCareProvID");
	var DIobj=document.getElementById("DoctorID");

	if((obj)&&(obj.value!="")&&(LCobj)&&(LCobj.value!="")&&(DIobj)&&(DIobj.value=="")) DIobj.value=LCobj.value;

	MultiEpisodeID();

	//jpd 48368
	IspayorObj.value="N";
	IsplanObj.value="N";

	var payorObj=document.getElementById("InsurPayor");
	if (payorObj){
		IspayorObj=document.getElementById("IsPayorOnPage");
		if(IspayorObj) IspayorObj.value="Y";
	}

	var planObj=document.getElementById("InsurPlan");
	if (planObj){
		IsplanObj=document.getElementById("IsPlanOnPage");
		if(IsplanObj) IsplanObj.value="Y";
	}

	var decobj=document.getElementById("IsDeceased");
	if((decobj)&&(decobj.value=="Y")) dhcsys_alert(t['PAT_DECEASED']);

	var obj=document.getElementById("Orders");
    if (obj) obj.onchange=SelectOrdersClickHandler;
	//dhcsys_alert(IspayorObj.value);
	//dhcsys_alert(IsplanObj.value);
	var obj=document.getElementById("PrintPrescript");
  if (obj) obj.onclick=PrintPrescript_Click;
  var obj=document.getElementById("DoctorAppoint");
  if (obj) obj.onclick=DoctorAppoint_Click;
	var obj=document.getElementById("CardBill");
  if (obj) {obj.onclick=CardBillClick;}
}

function oehelpClickHandler(){
	//lgl+ help
	window.open("oehelp.htm",target="_blank")
}

function ListClickHandler(){
	if (HospitalCode!="NB") return;
	var eSrc=websys_getSrcElement();	
	if (eSrc.id=="group1") var lst=lstGroup1;
	if (eSrc.id=="group2") var lst=lstGroup2;
	if (eSrc.id=="group3") var lst=lstGroup3;
	if (eSrc.id=="group4") var lst=lstGroup4;
	if (eSrc.id=="group5") var lst=lstGroup5;
	var i=lst.selectedIndex;
	if (lst) {
  	if (lst.options[i].style.color=="red"){
  		lst.options[i].selected=false;
  	}
  }
}
function PrefAddItemCustom(lstcnt,val,desc,hasdefault,stockqty) {
	var lst=eval('lstGroup'+lstcnt);
	var descarr=desc.split(" - ")
	if (descarr.length>1){desc=descarr[1]}
	lst.options[lst.options.length] = new Option(desc,val);
	if(hasdefault=="Y") lst.options[lst.options.length-1].style.color="Blue";
	if(stockqty==0) lst.options[lst.options.length-1].style.color="Red";
}

function DoctorAppoint_Click(){
	var Obj=document.getElementById("PatientID");
	if (Obj) {var PatientID=Obj.value;}
	else {var PatientID="";}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.Appoint&PatientID="+PatientID;
	websys_lu(url,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=900");
}

function PrintPrescript_Click()
{
	var Obj=document.getElementById("PatientID");
	if (Obj) {var PatientID=Obj.value;}
	else {var PatientID="";}
	var Obj=document.getElementById("EpisodeID");
	if (Obj) {var EpisodeID=Obj.value;}
	else {var EpisodeID="";}
	var Obj=document.getElementById("mradm");
	if (Obj) {var MRADMID=Obj.value;}
	else {var MRADMID="";}
	
	var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCPrescript.Print&EpisodeID="+EpisodeID+"&mradm="+MRADMID+"&PatientID="+PatientID;
	websys_lu(url,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
    //win=open(url,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
}



function MultiEpisodeID() {
	var TObj=document.getElementById("MultiEpisodeID");
	var EObj=document.getElementById("EpisodeID");
	if((TObj)&&(TObj.value!="")&&(EObj)) {
		EObj.value=TObj.value;
		var temp=TObj.value;
		var delimArray = temp.split("^");
		if (delimArray.length>1) {
			window.parent.NoEPRChart();
			window.parent.NoPABanner();

		}
	}
}

function SetPayorPlan() {
	var PlanObj=document.getElementById("InsurPlan");
	if (PlanObj) PlanObj.value="";
}

function ResetPayor(str) {
	if (str) {
		var lu=str.split("^");
		var PayorObj=document.getElementById("InsurPayor");
		if (PayorObj) PayorObj.value=lu[1];
	}
}
/*
//ANA 21-Nov-2002: Code over-writes one from SCRIPTS_GEN so that it can pass in the WEBSYS.TCOMPONENT value: REF: PAAdm.Edit.Js.
function REFDDesc_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=";
		var obj=document.getElementById("OEORIRefDocDR");
		if (obj) {namevaluepairs="&P1="+obj.value+"&P2=&P3=";}
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
	}
}

function REFDDesc_lookuphandlerCustom2(namevaluepairs) {

	var url='websys.lookup.csp';
	url += "?ID=d251iREFDDesc&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs+"&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=ViewDoctorLookUp";
	var tmp=url.split('%');
	url=tmp.join('%25');
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}
*/
function REFDDesc_lookupsel(value) {
	try {
		var obj=document.getElementById("OEORIRefDocDR");
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
		websys_nextfocus(obj.sourceIndex);
		}
	} catch(e) {};
}


function ActivateSpecCol() {
	var RecDate="";
	var RecTime="";
	var SpecColObj=document.getElementById("SpecCollected");
	var RecDateObj=document.getElementById("ReceivedDate");
	if (RecDateObj) RecDate=RecDateObj.value;

	var RecTimeObj=document.getElementById("ReceivedTime");

	if(RecDate!=""){
		var hidRecTime="";
		var RecTimeobj=document.getElementById("ReceivedTime");
		var hidRecTimeobj=document.getElementById("HidRecTime");
		RecTimeobj.value=hidRecTimeobj.value;

		var SpecColObj=document.getElementById("SpecCollected");
		if (SpecColObj&&SpecColObj.checked==false) {
			if (SpecColObj) SpecColObj.checked=true;
			SpecColCheck();
		}

	}

	else {
		if (RecTimeObj) RecTimeObj.value="";
	}
}

function SpecColCheck() {
	var SpecColObj=document.getElementById("SpecCollected");
	if (SpecColObj&&SpecColObj.checked) {
		EnableFields();
		var hidColDate="";
		var hidColTime="";

		var ColDateobj=document.getElementById("ColDate");
		var ColTimeobj=document.getElementById("ColTime");
		var hidColDateobj=document.getElementById("HidColDate");
		var hidColTimeobj=document.getElementById("HidColTime");
		if ((hidColDateobj) && (ColDateobj)) ColDateobj.value=hidColDateobj.value;
		if ((hidColTimeobj) && (ColTimeobj)) ColTimeobj.value=hidColTimeobj.value;
	} else {
		DisableFields();
	}

}

function EnableFields() {
	var ColDateObj = document.getElementById("ColDate");
	var ColTimeObj = document.getElementById("ColTime");
	var ColDatelbl = document.getElementById("cColDate");
	var ColTimelbl = document.getElementById("cColTime");

	if (ColDateObj&&ColTimeObj) {
		ColDateObj.disabled = false;
		ColTimeObj.disabled = false;
		ColDateObj.className = "";
		ColTimeObj.className = "";
		if (ColTimelbl) ColTimelbl = ColTimelbl.className = ""; //"clsRequired";
		if (ColDatelbl) ColDatelbl = ColDatelbl.className = ""; //"clsRequired";
	}
}

function DisableFields() {
	var ColDateObj = document.getElementById("ColDate");
	var ColDatelbl = document.getElementById("cColDate");
	var ColTimeObj = document.getElementById("ColTime");
	var ColTimelbl = document.getElementById("cColTime");

	if ((ColDateObj)&&(ColDateObj.tagName=="INPUT")&&(ColTimeObj)&&(ColTimeObj.tagName=="INPUT")) {
		ColDateObj.value = "";
		ColTimeObj.value = "";
		ColDateObj.disabled = true;
		ColTimeObj.disabled = true;
		ColDateObj.className = "disabledField";
		ColTimeObj.className = "disabledField";
		if (ColDatelbl) ColDatelbl = ColDatelbl.className = "";
		if (ColTimelbl) ColDatelbl = ColTimelbl.className = "";
	}
}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}


function PopUpExec(ordItmMastId,ordExecId,ordId) {
	//dhcsys_alert("Come in to PopUpExec "+ordItmMastId+"*"+ordExecId);
	var valPatient;
	var patobj=document.getElementById("PatientID");
	if (patobj) valPatient=patobj.value;
	var URL="oeordexec.edit.csp?PatientBanner=1&PatientID="+valPatient+"&PARREF="+ordId+"&ID="+ordExecId+"&refresh=0"+"&OrderWindow="+window.name;
	//dhcsys_alert("URL"+URL);
	var features='scrollbars=auto,toolbar=no,resizable=yes'
	websys_createWindow(URL,'',features)
}
function PopUpExecWithoutExecTime(ordId) {
	//dhcsys_alert("Come in to PopUpExecWithoutExecTime "+ordId);
	var valPatient;
	var patobj=document.getElementById("PatientID");
	if (patobj) valPatient=patobj.value;
	var URL="oeordexec.edit.csp?PatientBanner=1&PatientID="+valPatient+"&PARREF="+ordId+"&ID=&refresh=0"+"&OrderWindow="+window.name;
	//dhcsys_alert("URL"+URL);
	var features='scrollbars=auto,toolbar=no,resizable=yes'
	websys_createWindow(URL,'',features)
}

var DupitmOK = new Array();
// this is an array of flags which catch a response to 'duplicate order' alert.
// it must be global so that repeat item alert does not appear with every item added.
// jpd log 49644 - April 2005



function DisableOrderDetailsButton(Disable){
	//dhcsys_alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
        
	var odObj=document.getElementById("OrderDetails");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=OrderDetailsClickHandler;
	}
}

function DisableAddButton(Disable){
	// disable add button till csp finishes inserting items to database.
	// ANA LOG XXX
	var addObj=document.getElementById("Add");
	if ((addObj)&&(Disable=="1")) {
		addObj.disabled=true;
		addObj.onclick="";
		if (tsc['Add']) {websys_sckeys[tsc['Add']]="";}
		
	}
	if ((addObj)&&(Disable=="0")) {
		addObj.disabled=false;
		addObj.onclick=AddClickHandler;
		if (tsc['Add']) {websys_sckeys[tsc['Add']]=AddClickHandler;}
	}
}
function DisableDeleteButton(Disable){
	// disable add button till csp finishes inserting items to database.
	// ANA LOG XXX
	var delObj=document.getElementById("Delete");
	if ((delObj)&&(Disable=="1")) {
		delObj.disabled=true;
		delObj.onclick="";
		if (tsc['Delete']) {websys_sckeys[tsc['Delete']]="";}
		
	}
	if ((delObj)&&(Disable=="0")) {
		delObj.disabled=false;
		delObj.onclick=DeleteClickHandler;
		if (tsc['Delete']) {websys_sckeys[tsc['Delete']]=DeleteClickHandler;}
	}
}
function DisableUpdateButton(Disable){
	// disable Update button till csp finishes inserting items to database.
	//dhcsys_alert("in DisableUpdateButton "+Disable);
	var updObj=document.getElementById("Update");

	if ((updObj)&&(Disable=="1")) {
		updObj.disabled=true;
		updObj.onclick="";
		if (tsc['Update']) {websys_sckeys[tsc['Update']]="";}
	}
	if ((updObj)&&(Disable=="0")) {
		updObj.disabled=false;
		updObj.onclick=UpdateClickHandler;
		if (tsc['Update']) {websys_sckeys[tsc['Update']]=UpdateClickHandler;}
	}
}
function OEORIDepProcNotes_keydownhandler(encmeth) {
	var obj=document.getElementById("OEORIDepProcNotes");
	LocateCode(obj,encmeth);
}



function DeSelectAll() {
	//Deselects all listboxes
	if (lstGroup1) lstGroup1.selectedIndex=-1;
	if (lstGroup2) lstGroup2.selectedIndex=-1;
	if (lstGroup3) lstGroup3.selectedIndex=-1;
	if (lstGroup4) lstGroup4.selectedIndex=-1;
	if (lstGroup5) lstGroup5.selectedIndex=-1;
}

function AddToFavClickHandler() {
	//Add selected items from lstOrders to lstGroup1,
	//at the same time, add Favourite categories
	//AddItems(document.fUDHCOEOrder_List_Custom,lstOrders.name,lstGroup1.name);
	AddToFavUpdate(document.fUDHCOEOrder_List_Custom,0);
	return false;
}
function AddItems(f,selfrom,selto,docheck) {
	var selary=getSelected(f.elements[selfrom],0,docheck);
	addSelected(f.elements[selto],selary,0);
}
function AddToFavUpdate(f,cls) {

	var path = "oeorder.orgfavupdate.csp?LstGroup1="+escape(vArray.join(String.fromCharCode(1)))+"&OrderWindow="+window.name;
	websys_createWindow(path,"TRAK_hidden","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");

/*
	var path = "oeorder.orgfavupdate.csp?LstGroup1="+vArray.join(String.fromCharCode(1));
	if (window.opener){
		window.opener.top.frames["TRAK_hidden"].location.href=path;
	}else{
		top.frames["TRAK_hidden"].location.href=path;
	}
*/
}

//Log 49182 PeterC 02/05/05
function ShowDrgSubs(ItemList,NonSubItems)
{
	//dhcsys_alert(ItemList+","+NonSubItems);
	var PatientID="";
	var EpisodeID="";
	var windesc="";
	var PObj=document.getElementById("PatientID");
	if (PObj) PatientID=PObj.value;
	var EObj=document.getElementById("EpisodeID");
	if (EObj) EpisodeID=EObj.value;

	var ItemArray=ItemList.split(String.fromCharCode(4));
	for(i=0;i<ItemArray.length;i++)
	{
		var CurrItemList=ItemArray[i];
		if(CurrItemList=="") break;
		var URL="oeorder.showdrgsubs.csp?ItemList="+CurrItemList+"&NonSubItems="+NonSubItems+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PatientBanner=1"+"&SubsItemCount="+(ItemArray.length-1);
		var features="top=30,left=20,width=410,height=310,scrollbars=yes,toolbar=no,resizable=yes";
		windesc="ShowDrgSubs"+i;
		websys_createWindow(URL,windesc,features);
	}
	return false;
}

function DeleteOrderClickHandler(ARCIM) {
	for (var i=(lstOrders.length-1); i>=0; i--) {
		if (lstOrders.options[i].selected){
			var selItmid=lstOrders.options[i].value;
			if(ARCIM==selItmid) {
				lstOrders.options[i]=null;
			}
		}
	}
}

function getDelim(RepeatTimes) {
	var getDelim="";
	if (!RepeatTimes) RepeatTimes=30;
	for (var k=1; k<RepeatTimes; k++) {
		getDelim=getDelim+String.fromCharCode(1);
	}
	return getDelim;
}

function OrderDetailsClickHandler() {		//displays new page where the user can edit some of the fields.
	OrderDetailsOpenCount=0;
	OrderDetailsPage(document.fUDHCOEOrder_List_Custom);
	return false;
}

function DeleteAllHiddenItems() {
	var id="";
	var objhid="";
	
	for (i=1; i<=hidItemCnt; i++) {
		id="hiddenitem"+hidItemCnt;
		objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';
	}
	//dhcsys_alert("lstOrders.length="+lstOrders.length)
	hidItemCnt=0;
}

function InvalidFields() {
	var invalid=false;
	if(!isInvalid("OEORIRefDocDR")&&(!invalid)) {
		dhcsys_alert(t['OEORIRefDocDR']+":  "+t['XINVALID']);
		invalid=true;
	}


	if(!isInvalid("Doctor")&&(!invalid)) {
		dhcsys_alert(t['Doctor']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("EpisLoc")&&(!invalid)) {
		dhcsys_alert(t['EpisLoc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("InsurPayor")&&(!invalid)) {
		dhcsys_alert(t['InsurPayor']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("InsurPlan")&&(!invalid)) {
		dhcsys_alert(t['InsurPlan']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OECPRDesc")&&(!invalid)) {
		dhcsys_alert(t['OECPRDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("ReasonAlert")&&(!invalid)) {
		dhcsys_alert(t['ReasonAlert']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("TempLoc")&&(!invalid)) {
		dhcsys_alert(t['TempLoc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORISpecialtyDR")&&(!invalid)) {
		dhcsys_alert(t['OEORISpecialtyDR']+":  "+t['XINVALID']);
		invalid=true;
	}



	return invalid;
}

function UpdateClickHandlerFinish() {
	var flagobj=document.getElementById("dateflag");
	if (flagobj&&(flagobj.value=="N")) {
		flagobj.value="Y";
		return false;
	}
	Update_click();
}

function StartDateInRange(DoNotClickDeleteWhenNotContinue) {   // *****  Log# 30710; AmiN ; 17/Dec/2002 Start Date must be within Episode Admin Date and Discharge date *****
	if (!DoNotClickDeleteWhenNotContinue) DoNotClickDeleteWhenNotContinue=false;
	var aobj=document.getElementById("AdmDate");
	var dobj=document.getElementById("DischDate");
	var sobj=document.getElementById("OEORISttDat");
	var AOOERobj=document.getElementById("AllowOrderOutEpisRange");
	var atime,dtime,stime=""
	var atobj=document.getElementById("AdmTime");
	if ((atobj)&&(atobj.value!="")) atime=atobj.value;
	var dtobj=document.getElementById("DischTime");
	if ((dtobj)&&(dtobj.value!="")) dtime=dtobj.value;
	var stobj=document.getElementById("OEORISttTim");
	if ((stobj)&&(stobj.value!="")) stime=stobj.value;
	if ((!stobj)||((stobj)&&(stobj.value==""))) {
		var htobj=document.getElementById("hidCurrTime");
		if ((htobj)&&(htobj.value!="")) stime=htobj.value;
	}
	var enteredDate  = new Date();
	var enteredDate1 = new Date();
	var enteredDate2 = new Date();
	//dhcsys_alert(dobj+" # "+dtime);
	if (dobj&&dtime) { var enteredDate  = VerifyDateformat(dobj,dtime); } //DischDate
	if (sobj&&stime) { var enteredDate1 = VerifyDateformat(sobj,stime); } //AdmDate
	if (aobj&&atime) { var enteredDate2 = VerifyDateformat(aobj,atime); } //OEORISttDat
	//dhcsys_alert("73 xx OEORISttDat ^ DischDate ^ AdmDate = "+sobj.value+"^"+dobj.value+"^"+aobj.value);

	if (sobj && (sobj.value!="")) {
		if (dobj && (dobj.value!="") && aobj && (aobj.value!="")) {
			if ((enteredDate1>enteredDate) && (AOOERobj) && (AOOERobj.value!="Y")) { //OEORISttDat(entered Date)>DischDate
				dhcsys_alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
				sobj.value=""
				if(stobj) stobj.value="";
				if (!DoNotClickDeleteWhenNotContinue) DeleteClickHandler();
				return false;
			}else if ((enteredDate1<enteredDate2) && (AOOERobj) && (AOOERobj.value!="Y")) {   //OEORISttDat(entered Date)<AdmDate
				dhcsys_alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
				sobj.value=""
				if(stobj) stobj.value="";
				if (!DoNotClickDeleteWhenNotContinue) DeleteClickHandler();
				return false;
			}
		}else{   //  Catches when  DischDate empty
			if ((enteredDate1<enteredDate2) && (AOOERobj) && (AOOERobj.value!="Y")) {   //  OEORISttDat(entered Date)< AdmDate
				var bContinue=1;
				bContinue=dhcsys_confirm(t['STARTDATE_EXCEED']+" "+aobj.value + "\n" + t['CONTINUE']);
				if (!bContinue) {
					sobj.value=""
					if(stobj) stobj.value="";
					if (!DoNotClickDeleteWhenNotContinue) DeleteClickHandler();
					return false;
				}
			}
		}
	}
	return true;
	// end Log# 30710;
}
function zVerifyDateformat(obj) {  //log 30710 AmiN Start Date must be within Episode Admin Date and Discharge date.

	var date="";
	date=obj.value;

	var dateArr = date.split(dtseparator);

	if(dtformat=="YMD")
	{
		date = new Date(dateArr[0],dateArr[1],dateArr[2]);
	}

	else if(dtformat=="MDY")
	{
		date = new Date(dateArr[2],dateArr[0],dateArr[1]);
	}

	else
	{
		date = new Date(dateArr[2],dateArr[1],dateArr[0]);
	}

	return date;
}
/*
function ClearField() {
	var obj=document.getElementById("CareProvider")
	if (obj) obj.value="";
}
*/


function matchCategory(Type,orderCat,orderSubCat,orderCode) {
	//Log 49059 PeterC 23/03/05
	var OSID=""
	if(mPiece(orderCode,"^",1)) OSID=mPiece(orderCode,"^",1);
	orderCode=mPiece(orderCode,"^",0);

	//dhcsys_alert(Type+"*"+orderCat+"*"+orderSubCat+"*"+orderCode);
	if (orderCat=="" || orderSubCat=="") {
		var NewOrders=cNewOrders.split("^");
		for (var b1=0;b1<NewOrders.length-1;b1++) {
			//dhcsys_alert("order is "+mPiece(mPiece(cNewOrders,"^",b1),"*",0));
			//dhcsys_alert("order is:"+cNewOrders);
			if (mPiece(mPiece(cNewOrders,"^",b1),"*",0)==orderCode) {
				var piece=mPiece(cCat,"^",b1);				
				if(piece) {
					orderCat=mPiece(piece,"*",0);
					orderSubCat=mPiece(piece,"*",1);
				}
				//orderCat=mPiece(mPiece(cCat,"^",b1),"*",0);
				//orderSubCat=mPiece(mPiece(cCat,"^",b1),"*",1);
			}
		}
	}
	if  (Type=="OS") {
		var objOSCat=document.getElementById("groupSetCat");
		var objOSSubCat=document.getElementById("groupSetSubCat");
		//dhcsys_alert(objOSCat.value+"*"+objOSSubCat.value);
		if (objOSCat && objOSSubCat) {
			var grpOSCatArray=objOSCat.value.split(",")
			var grpOSSubCatArray=objOSSubCat.value.split(",")
			for (i=0;i<grpOSCatArray.length;i++) {
				//dhcsys_alert("Cat:"+orderCat+","+grpOSCatArray[i]);
				if ((orderCat==grpOSCatArray[i])&&(orderCat!="")) {
					return true;
				}
			}
			for (i=0;i<grpOSSubCatArray.length;i++) {
				//dhcsys_alert("Sub-Cat:"+orderSubCat+","+grpOSSubCatArray[i]);
				if ((orderSubCat==grpOSSubCatArray[i])&&(orderSubCat!="")) {
					return true;
				}
			}
		}
	}
	else {
		var objIMCat=document.getElementById("groupItemCat");
		var objIMSubCat=document.getElementById("groupItemSubCat");
		//dhcsys_alert(objIMCat.value+"*"+objIMSubCat.value);
		if (objIMCat && objIMSubCat) {
			var grpIMCatArray=objIMCat.value.split(",")
			var grpIMSubCatArray=objIMSubCat.value.split(",")
			for (i=0;i<grpIMCatArray.length;i++) {
				if ((orderCat==grpIMCatArray[i])&&(orderCat!="")) {
					return true;
				}
			}
			for (i=0;i<grpIMSubCatArray.length;i++) {
				if ((orderSubCat==grpIMSubCatArray[i])&&(orderSubCat!="")) {
					return true;
				}
			}
		}
	}
	var objIMItem=document.getElementById("groupItemItem");
	//Log 49059 PeterC 23/03/05
	if ((OSID!="")&&(orderCode!="")) OSID=orderCode;
	//dhcsys_alert(objIMItem.value);
	if (objIMItem) {
		var grpIMItemArray=objIMItem.value.split(",")
		for (i=0;i<grpIMItemArray.length;i++) {
			if (orderCode==grpIMItemArray[i]) {
				return true;
			}
		}
	}
	return false;
}
function matchExecCategory(orderSubCat,orderCode) {
	//dhcsys_alert("in matchExecCategory "+orderSubCat+"*"+orderCode);
	var objIMSubCat=document.getElementById("groupExecSubCat");
	//dhcsys_alert(objIMSubCat.value);
	if (objIMSubCat) {
		var grpIMSubCatArray=objIMSubCat.value.split(",")
		for (i=0;i<grpIMSubCatArray.length;i++) {
			if (orderSubCat==grpIMSubCatArray[i]) {
				return true;
			}
		}
	}
	var objIMItem=document.getElementById("groupExecItem");
	//dhcsys_alert(objIMItem.value);
	if (objIMItem) {
		var grpIMItemArray=objIMItem.value.split(",")
		for (i=0;i<grpIMItemArray.length;i++) {
			if (orderCode==grpIMItemArray[i]) {
				return true;
			}
		}
	}
	return false;
}


function AddInput(selList,value){
	// ANA LOG XXX
	// this is called on Update. Will add hidden fields in OEOrder.Custom which are OEOriRowIds.
	hidItemCnt++;
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	//dhcsys_alert("newelement value on update="+NewElement.value);
	document.fUDHCOEOrder_List_Custom.dummy.insertAdjacentElement("afterEnd",NewElement);
}

function deSelect(f,name) {   //Makes sure that only options in the select box, which presently has the focus, are highlighted.
	for (var i=0;i<f.elements.length;i++) {
		if (f.elements[i].type=="select-multiple" && f.elements[i].name!=name) {
			for (var j=0;j<f.elements[i].length;j++) {
				f.elements[i].options[j].selected=false;
			}
		}
	}
	var ary=getSelected(f.elements[name],0);
	tArray=new Array();
	n=0;
	for (var i=ary.length-1;i>=0;i--) {tArray[n]=ary[i]["txt"];n++}
	document.all.tags("label")["item"].innerHTML=tArray.join("<BR>");
}

function RemoveOneItemFromList(indx) {
	if (lstOrders) {
		lstOrders.options[indx]=null;
	}
}
function RemoveFromList(f,obj) {
	var deleteString="";
	var itypeLen="";
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected) {
			deleteString=obj.options[i].itype;
			itypeLen=deleteString.split(String.fromCharCode(4)).length;
			deleteString=mPiece(deleteString,String.fromCharCode(4),itypeLen-2);
			cDeletedOrderItemIDs=cDeletedOrderItemIDs+deleteString;
			obj.options[i]=null;
		}
	}
}

//returns 2dimArray of all highlighted options from multi-select boxes
//also deletes those options if the del variable passed in is 1.
//checkmulti sets if option should be checked against already ordered items
function getSelected(obj,del,checkmulti) {
	var ary=new Array();
	var n=0;
	var doAdd="";
	var val="";
	var icode="";
	var favItemIDs="";
	var OSItemsWithoutDesc="";
	var OSItemIDInOSArr="";
  if (obj) {
	for (var i=0;i<=obj.length-1;i++) {
		if (obj.options[i].selected==true) {
			doAdd=1;
			if (checkmulti==1) {
				val=mPiece(obj.options[i].value,String.fromCharCode(28),1);
				if (val==null) val=obj.options[i].value;
				icode=val;
				//BM
				//dhcsys_alert("obj.options[i].value="+obj.options[i].value);
				//------------------------------------------
				if(mPiece(obj.options[i].value,String.fromCharCode(4),0)=="ARCOS"){
					favItemIDs=val+String.fromCharCode(12)+mPiece(obj.options[i].value,String.fromCharCode(4),4);
					val=favItemIDs;
					//dhcsys_alert("place 2:"+val);
				}
				doAdd=true; //Move the duplicate order check to summaryscreen
			}
			if (doAdd) {
				ary[n]=new Array();
				ary[n]["txt"]=obj.options[i].text;
				if(mPiece(obj.options[i].value,String.fromCharCode(4),0)=="ARCOS") {
					// BM  for orderset
					OSItemsWithoutDesc="";
					//dhcsys_alert("Place 0:"+obj.options[i].value);
					OSItemIDInOSArr=mPiece(obj.options[i].value,String.fromCharCode(4),4);
					OSItemIDInOSArr=OSItemIDInOSArr.split(String.fromCharCode(12));
					for (var j=0;j<OSItemIDInOSArr.length;j++) {
						//dhcsys_alert(j+":"+OSItemIDInOSArr[j]);
						if (OSItemIDInOSArr[j].split(String.fromCharCode(14)).length > 1) {
							if (OSItemIDInOSArr[j].split(String.fromCharCode(14))[1]!="") OSItemsWithoutDesc=OSItemsWithoutDesc+OSItemIDInOSArr[j].split(String.fromCharCode(14))[1]+String.fromCharCode(12);
						}
						else {
							if (j==0) OSItemsWithoutDesc=OSItemsWithoutDesc+OSItemIDInOSArr[j]+String.fromCharCode(12);
						}
					}
					OSItemIDInOSArr=obj.options[i].value.split(String.fromCharCode(4));
					OSItemIDInOSArr[4]=OSItemsWithoutDesc;
					ary[n]["val"]=OSItemIDInOSArr.join(String.fromCharCode(4));
					//ary[n]["val"]=obj.options[i].value;
					//dhcsys_alert("ary[n][val]="+ary[n]["val"]);
				}
				else {
					ary[n]["val"]=obj.options[i].value;
				}
				n++;
			}
			if (del==1) obj.options.remove(i);
		}
	}
  }
	return ary;
}

//adds options to a select box from 2dimArray passed to function.
//also makes these added options selected if variable s is 1.
function addSelected(obj,selary,s) {
	var k=obj.length;
	var tmpval="";
	var tmpitype="";
	for (var i=0;i<selary.length;i++) {
		obj.options[k]=new Option(selary[i]["txt"],selary[i]["val"]);
		obj.options[k].itype=obj.options[i].value;
		tmpval=mPiece(obj.options[k].value,String.fromCharCode(28),1);
		tmpitype=obj.options[k].value;
		if ((tmpval)&&(tmpval!="")) obj.options[k].value=tmpval;
		if (s==1) obj.options[k].selected=true;
		k++;
	}
}

//collects data from all relevant form elements and submits form.
function submitForm(f,cls) {
	//dhcsys_alert("submit");
	//not in use, need to double check
	var valArray=new Array();
	var namArray=new Array();
	var vArray="";
	var ntemp="";
	var vtemp="";
	for (var i=0;i<5;i++) {
		vArray=new Array();
		ntemp="group"+eval(i+1)+"name"
		if (f.elements[ntemp]) {namArray[i]=f.elements[ntemp].value;}
		vtemp="group"+eval(i+1)
		for (var j=0;j<f.elements[vtemp].length;j++) vArray[j]=f.elements[vtemp].options[j].value
		valArray[i]=vArray.join(",");
	}
	path=path+"&names="+namArray.join(",")+"&vals="+valArray.join(":");
	//var hf=window.opener.top.frames["TRAK_hidden"];
	//modify by wuqk 2010-07-02 for exr framework
	var hf=top.document.getElementsByName("TRAK_hidden");
	if (hf) hf.location.href=path;
	if (cls==1) window.close();
}


//fills non-hidden form elements with correct values from pre-defined arrays.
function docLoaded(f) {
	var namArray=nparams.split(",");
	var valArray=vparams.split(":");
	var txtArray=tparams.split(":");
	var selary="";
	var ntemp="";
	var goAhead="";
	var vtemp="";
	var vArray="";
	var tArray="";
	var idataArray="";
	var itypeArray="";
	if (tparams.split(":")!="") {
		for (var i=0;i<namArray.length;i++) {
			selary=new Array()
			ntemp="group"+eval(i+1)+"name"
			goAhead=0;
			if (f.elements[ntemp]) {f.elements[ntemp].value=namArray[i]}
			vtemp="group"+eval(i+1)
			vArray=new Array();
			tArray=new Array();
			idataArray=new Array();
			itypeArray=new Array();
			if (valArray[i]) var vArray=valArray[i].split(",");
			if (txtArray[i]) var tArray=txtArray[i].split("^");
			for (var j=0;j<vArray.length;j++) {
				if (vArray[j]!="") {
					selary[j]=new Array();
					selary[j]["val"]=vArray[j];
					selary[j]["txt"]=tArray[j];
					selary[j]["idata"]=idataArray[j];
					selary[j]["itype"]=itypeArray[j];
					goAhead=1;
				}
			}
			if (goAhead==1) addSelected(f.elements[vtemp],selary,0)
		}
	}
}



function PricesClickHandler(evt) { 	//form string of items to check prices first
	//dhcsys_alert("in PricesClickHandler");
	var itms = "";
	var qty = "";
	var uom = "";
	var drugformid="";
	var price= "";
	var sets = "";
	var count=0;
	var itmcount=0;
	var ordidstr="";

	var ItemNoOS="";
	var itype="";
	var itypeLen="";
	var itemdata="";
	var itemtype="";
	for (var i=0; i<lstOrders.options.length; i++) {
		//store desc if order set, else itemid
		//dhcsys_alert("lstOrders.options[i].id="+mPiece(lstOrders.options[i].id,String.fromCharCode(4),2));
		ItemNoOS=mPiece(lstOrders.options[i].id,String.fromCharCode(4),2)
		if (ItemNoOS==1) totCount=getOSItemCount(i);
		if ((!ItemNoOS)||(ItemNoOS=="")) totCount=0;
		//dhcsys_alert("totCount="+totCount);
		//dhcsys_alert("lstOrders.options[i].value="+lstOrders.options[i].value);
		//dhcsys_alert("lstOrders.options[i].itype="+lstOrders.options[i].itype);
		if (lstOrders.options[i].value == "") {
			itms += mPiece(lstOrders.options[i].itype,String.fromCharCode(1),2) + "^";
			//if(mPiece(lstOrders.options[i].ORIRowId,"*",1)){
			//	ordidstr += mPiece(lstOrders.options[i].ORIRowId,"*",1) + "^";
			//}
			//else{
				itype=lstOrders.options[i].itype;
				itypeLen=itype.split(String.fromCharCode(4)).length;
				if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
				if (ORIRowID.split("*").length>1) ORIRowID=mPiece(ORIRowID,"*",1);
				ordidstr += ORIRowID + "^";
			//}
		} else {
			itms += lstOrders.options[i].value + "^";
			//if(mPiece(lstOrders.options[i].ORIRowId,"*",1)){
			//	dhcsys_alert("Have");
			//	ordidstr += mPiece(lstOrders.options[i].ORIRowId,"*",1) + "^";
			//}
			//else{
				//dhcsys_alert("Blank");
				itype=lstOrders.options[i].itype;
				itypeLen=itype.split(String.fromCharCode(4)).length;
				if (itypeLen>1) ORIRowID=mPiece(itype,String.fromCharCode(4),itypeLen-2);
				if (ORIRowID.split("*").length>1) ORIRowID=mPiece(ORIRowID,"*",1);
				ordidstr += ORIRowID + "^";
			//}
		}
		itemdata = lstOrders.options[i].idata;
		//dhcsys_alert(itemdata);
		if (itemdata!="") itemdata=unescape(itemdata);
		//BM
		/*
		var BMTemp="";
		for (var j=1;j<120;j++) {
			BMTemp=BMTemp+"^"+j+"-"+mPiece(itemdata,String.fromCharCode(1), j);
		}
		dhcsys_alert(BMTemp);
		*/

		if (itemdata) {
			qty += mPiece(itemdata, String.fromCharCode(1), 10) + "^";
			uom += mPiece(itemdata,String.fromCharCode(1), 14) + "^";
			drugformid += mPiece(itemdata,String.fromCharCode(1), 93) + "^";
			price += mPiece(itemdata,String.fromCharCode(1), 32) + "^";
		} else {
			qty += "" + "^";
			uom += "" + "^";
			drugformid += "" + "^";
			price += "" + "^";
		}
		itemtype = lstOrders.options[i].itype;
		if (itemtype) {
			//SA 7.11.01: typical record here will have either
			//ARCIM or ARCOS and the order set id (if any).
			//egs. "ARCIM|13" is an order item which is part of order set which has DR of 13
			//     "ARCOS|50" is the complete order set with DR of 50
			//     "ARCIM|"   is an order item which is NOT part of an order set
			//	 "ARCOS|"   should NEVER occur - this implies it is an order set with no DR.
			//A new piece will need to be created in the future to cope with the case where
			//the same order set is ordered more tha once.
			sets += mPiece(itemtype, String.fromCharCode(4), 0) + String.fromCharCode(1) + mPiece(itemtype, String.fromCharCode(4), 2) + String.fromCharCode(1) + totCount + "^";
			//dhcsys_alert("sets "+sets);
		} else {
			sets += "" + "^";
			//dhcsys_alert("sets "+sets);
		}
	}
	sets=escape(sets);
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID")
	if (objEpisodeID) {
		//dhcsys_alert(price);
		EpisodeID=objEpisodeID.value;

		//var evtSrc=websys_getSrcElement(evt);

		var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.CheckPrices&EpisodeID="+EpisodeID+"&itemstr="+itms+"&qtystr="+qty+"&ordsetidstr="+sets+"&billpricestr="+price+"&uomstr="+uom+"&drugformstr="+drugformid+"&ordidstr="+ordidstr;
		//dhcsys_alert("path="+path);
		websys_lu(path,false,"");
	}
	return false;
}


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
		subcatobj.value="";
		if (cobj) cobj.value="";
		if (scobj) scobj.value="";
	}
	if (scobj){
		if(scobj.value=="") {
			scobj.value="";
			subcatobj.value=""
		}
	}
}
//TN:21-Jun-2002: create new hidden fields to store extra details already stored against the selected order item.
//only used for when order entry screen is being refreshed from some server side error message (such as invalid pin)
//should never call this unless you have already called AddInput();
function AddInputExtra(value) {
	//hidItemCnt has been incremented via AddInput();
	var obj=document.forms['fUDHCOEOrder_List_Custom'].elements['hiddenitem'+hidItemCnt];
	if (obj && (obj.value!=null)) {
		var NewElement=document.createElement("INPUT");
		NewElement.id = 'hiddenextra' + hidItemCnt;
		NewElement.name = 'hiddenextra' + hidItemCnt;
		NewElement.value = value;
		NewElement.type = "HIDDEN";
		obj.insertAdjacentElement("afterEnd",NewElement);

		var arrReloadVals=value.split(String.fromCharCode(1));
	}
}

function ReloadOrderSelectionListBox() {
	var lst=document.forms['fUDHCOEOrder_List_Custom'].elements['Orders'];
	var lstlength=0;
	var hidItem="";
	var hidItemExtra="";
	var desc=""; var value=""; var idval=""; var idata=""; var itype="";
	var arrReloadVals="";
	var arrReloadExtraVals="";
	for (var i=1; i<=reloadingcnt; i++) {
		hidItem=unescape(arrReload[i]);
		hidItemExtra=unescape(arrReloadExtra[i]);
		if (hidItem) {
			arrReloadVals=hidItem.split(String.fromCharCode(1));
			arrReloadExtraVals=hidItemExtra.split(String.fromCharCode(1));
			desc=arrReloadVals[0]; if (!desc) desc="";
			if ((arrReloadVals.length>2)&&(arrReloadExtraVals[0]=="DATA")) {
				idata=hidItem.substring(hidItem.indexOf(String.fromCharCode(1))+1);
			}
			idval=arrReloadExtraVals[1]; if (!idval) idval="";
			value=arrReloadExtraVals[2]; if (!value) value="";
			itype=arrReloadExtraVals[3]; if (!itype) itype="";
			lstlength=lstlength=lst.options.length;
			lst.options[lstlength]=new Option(desc,value);
			lst.options[lstlength].id=idval;
			lst.options[lstlength].itype=itype;
			lst.options[lstlength].idata=idata;
		}
	}
}

function VerifyColRecDateTime() {

	var cd="";
	var ct="";
	var rd="";
	var rt="";


	var cdobj=document.getElementById("ColDate");
	if(cdobj) cd=cdobj.value;

	var ctobj=document.getElementById("ColTime");
	if(ctobj) ct=ctobj.value;

	var rdobj=document.getElementById("ReceivedDate");
	if(rdobj) rd=rdobj.value;

	var rtobj=document.getElementById("ReceivedTime");
	if(rtobj) rt=rtobj.value;

	var CDate ="";
	var RDate ="";

	if(rd=="" && rt!=""){
		dhcsys_alert(t['RECEIVE_DATETIME']);
		return false;
	}

	if(rd!=""){

		if(cd=="" || ct=="" || rt=="")
		{
			dhcsys_alert(t['RECEIVE_DATETIME']);
			return false;
		}

		else{
			var CdateArr = cd.split(dtseparator);
			var RdateArr = rd.split(dtseparator);
			var CtimeArr = ct.split(":");
			var RtimeArr = rt.split(":");

			if(dtformat=="YMD")
			{
				CdateArr[1]=CdateArr[1]-1;
				RdateArr[1]=RdateArr[1]-1;
				CDate = new Date(CdateArr[0],CdateArr[1],CdateArr[2],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[0],RdateArr[1],RdateArr[2],RtimeArr[0],RtimeArr[1]);
			}

			else if(dtformat=="MDY")
			{
				CdateArr[0]=CdateArr[0]-1;
				RdateArr[0]=RdateArr[0]-1;
				CDate = new Date(CdateArr[2],CdateArr[0],CdateArr[1],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[2],RdateArr[0],RdateArr[1],RtimeArr[0],RtimeArr[1]);
			}

			else
			{
				CdateArr[1]=CdateArr[1]-1;
				RdateArr[1]=RdateArr[1]-1;
				CDate = new Date(CdateArr[2],CdateArr[1],CdateArr[0],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[2],RdateArr[1],RdateArr[0],RtimeArr[0],RtimeArr[1]);
			}


		}

		if (CDate>RDate){
			dhcsys_alert(t['INVALID_COLDATE']);
			return false;
		}

	}
}
function PrefAddItem(lstcnt,val,desc,hasdefault) {
	var lst=eval('lstGroup'+lstcnt);
	lst.options[lst.options.length] = new Option(desc,val);
	if(hasdefault=="Y") lst.options[lst.options.length-1].style.color="Blue";

}
function OEORISttDat_onBlur(e) {
	var obj=document.getElementById("OEORISttDat");
	Gparam5=obj.value;
	var objDate = DateStringToDateObj(Gparam5);
	var objToday = new Date();
	if (objDate < objToday) {
		var hsdcobj=document.getElementById("HiddenStartDateCheck");
		if (hsdcobj) hsdcobj.onchange();
		//dhcsys_alert("Gsdcheckval="+Gsdcheckval);
		if (Gsdcheckval=="Y") {
			dhcsys_alert(t['InClosedAccPeriod']);
		}
	}
}


function EnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13){
		try {
			var eSrc=websys_getSrcElement();
			if ((eSrc.id=="group1")||(eSrc.id=="group2")||(eSrc.id=="group3")||(eSrc.id=="group4")||(eSrc.id=="group5")) ListDoubleClickHandler();
		}
		catch(e) {}
	}

}

document.body.onkeydown=EnterKey;
/*
var obj=document.getElementById("OEORIRefDocDR");
//if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
var obj=document.getElementById("ld50045iOEORIRefDocDR");
//if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
var obj=document.getElementById("OEORISttDat");
if ((obj)&&(obj.value!="")) obj.onblur=OEORISttDat_onBlur;
//Log 54451 PeterC 19/08/05
var obj=document.getElementById("NonFormulary");
if (obj) obj.onclick=NonFormularyClickHandler;
*/
function NonFormularyClickHandler() {
	//dhcsys_alert("NonFormulary:"+window.currTab);
	var CurrTab="";
	CurrTab=window.currTab;
	RedrawFavourites(CurrTab,"");
}

//------xin--------start--
function Xaddwidth1(){
	var obj=document.getElementById("group1");
	if(obj) obj.style.width=newwidth;
	var obj=document.getElementById("group4");
	if(obj) obj.style.width=newwidth;
	}
function Xwidth1(){
	var obj=document.getElementById("group1");
	if(obj) obj.style.width=xiniwidth;
	var obj=document.getElementById("group4");
	if(obj) obj.style.width=xiniwidth;
	}
function Xaddwidth2(){
	var obj=document.getElementById("group2");
	if(obj) obj.style.width=newwidth;
	var obj=document.getElementById("group5");
	if(obj) obj.style.width=newwidth;
	}
function Xwidth2(){
	var obj=document.getElementById("group2");
	if(obj) obj.style.width=xiniwidth;
	var obj=document.getElementById("group5");
	if(obj) obj.style.width=xiniwidth;
	}	
function Xaddwidth3(){
	var obj=document.getElementById("group3");
	if(obj) obj.style.width=newwidth;
		var obj=document.getElementById("orders");
	if(obj) obj.style.width=newwidth;

	}
function Xwidth3(){
	var obj=document.getElementById("group3");
	if(obj) obj.style.width=xiniwidth;
	var obj=document.getElementById("orders");
	if(obj) obj.style.width=xiniwidth;
	}
//------xin--------end--
//------interface--------
function CreateBEGIN(){
	//return;
	//websys_createWindow(url,"TRAK_hidden","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
	//var newwin = window.open("", "TRAK_hidden");
	
	//var newwin = window.open("../csp/Begin.html","","top=10000,left=10000");
	dtywzxUI(0,0,"");
	dtywzxUI(768,0,session['LOGON.USERCODE']);
}

function CreateINIT(){
	var newwin = window.open("../csp/guideinit.html","","top=10000,left=10000");  //,"","top=10000,left=10000"
}

function CreateEND(){
	//return;
	//var newwin = window.open("../csp/End.html","TRAK_hidden");  //,"TRAK_hidden"
	//return;
	//退出
	//if (DHCDTInterface==1) dtywzxUI(1,0,"");
	//刷新
	if (DHCDTInterface==1) dtywzxUI(3,0,"");

}

function DTBegin_Click(){
	CreateBEGIN();
}

function XHZY_Click(){
	if ((DHCDTInterface==1)){
  	//CreateXHZY();
  	DaTongXHZYHander();
  }
}
function YDTS_Click(){
	if ((DHCDTInterface==1)) {
		if (FocusRowIndex==0) return;
		var Row=GetRow(FocusRowIndex);
		var itemid=GetColumnData("OrderARCIMRowid",Row);
		if (itemid=="") return;
		
		CreateYDTS(itemid,1);
	}
}
function HKXD_Click(){
	if ((DHCDTInterface==1)) {
		if (FocusRowIndex==0) return;
		var Row=GetRow(FocusRowIndex);
		var itemid=GetColumnData("OrderARCIMRowid",Row);
		if (itemid=="") return;
		CreateYDTS(itemid,2);
	}
}
function DTBtn_Click(){
	var ListObj=document.getElementById("DTList");
	if (ListObj){
	  var Para=ListObj.value;
		var url="UDHCDT.GUIDE.Csp?GuiID="+Para;
		//dhcsys_alert(url);
		var newwin = window.open(url,"","top=10000,left=10000");   //
		return;
	}
}

function ExitDT_Click(){
 var newwin = window.open("../csp/end.html","TRAK_hidden");
	//return;
}

function BtnClearAlert_Click(){
 var newwin = window.open("../csp/new.html","TRAK_hidden");
}

//upload server for prescription analyse
function CreateXHZYSaveOld(OEOrdItemIDs){   
	var OEORIIDs="";
	var siobj=new Array();
	siobj=OEOrdItemIDs.split("^");
	if ((siobj)&&(siobj.length-1>0)) {
		for (var i=0;i<(siobj.length-1);i++) {
			var NewOrderArr=siobj[i].split("*");
			var OrderItemRowid=NewOrderArr[1];
			if(OrderItemRowid=="") continue;
			if (OEORIIDs==""){
					OEORIIDs=OrderItemRowid;
			}else{
					OEORIIDs=OEORIIDs+"^"+OrderItemRowid;
			}
		}
	}
	//dhcsys_alert(OEORIIDs);
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	if (EpisodeID!=""){
		var UploadFlag="1";		
		var url="UDHCDT.XHZY.Csp?EpisodeID="+EpisodeID+"&DocCode="+session['LOGON.USERCODE']+"&OEORIIDs="+OEORIIDs+"&UploadFlag="+UploadFlag;//"&DocName="+session['LOGON.USERNAME']+
		var newwin = window.open(url,"","top=10000,left=10000");
	}	
	return;
}

function CreateXHZYSave(){   //上传保存
	var Orders="";
	var Para1=""
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
		var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
		var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
    var OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
    var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row)
    var GroupNumber=GetColumnData("OrderMasterSeqNo",Row)
    var OrderSeqNo=GetColumnData("OrderSeqNo",Row)
    if (GroupNumber==""){
    	if (OrderSeqNo.indexOf(".")>-1){
	    	var GroupNumber=OrderSeqNo.substring(0,OrderSeqNo.indexOf("."));
	    }else{
	    	var GroupNumber=OrderSeqNo;
    	}	
    }
    //判断是否处理草药
    if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 
    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid
    Para1=Para1+"!"+GroupNumber
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	if ((EpisodeID!="")){
		var UploadFlag="1";	
		//var escapeDHCDTPrescXML=websys_escape(DHCDTPrescXML);
		//dhcsys_alert(EpisodeID+"&"+session['LOGON.USERCODE']+"&"+Orders+"&"+escapeDHCDTPrescXML+"&"+UploadFlag);
		//lgl xiugai xml数据太大会导致超出ie地址兰限制而报指针错误,相关数据取得放到dt.csp内
		var escapeDHCDTPrescXML="";   
		//必须传递医生name,否则大通库不认
		//var url="udhcdt.xhzyentry.csp?EpisodeID="+EpisodeID+"&DocCode="+session['LOGON.USERCODE']+"&Orders="+Orders+"&OtherPresc="+escapeDHCDTPrescXML+"&DocName="+session['LOGON.USERNAME']+"&UploadFlag="+UploadFlag;//"&DocName="+session['LOGON.USERNAME']+
		var url="udhcdt.xhzyentry.new.csp?EpisodeID="+EpisodeID+"&DocCode="+session['LOGON.USERCODE']+"&Orders="+Orders+"&OtherPresc="+escapeDHCDTPrescXML+"&DocName="+session['LOGON.USERNAME']+"&UploadFlag="+UploadFlag;//"&DocName="+session['LOGON.USERNAME']+
		var newwin = window.open(url,"","top=10000,left=10000"); 
	}
	return;
}

function AddListToDT()	{
	var aryitmd=new Array();
	var aryitmi=new Array();
	var ListObj=document.getElementById("DTList");
	if ((!ListObj)||(DHCDTParameter=="")) return;
	ListObj.size=1;
	ListObj.multiple=false;	

	aryitmd=DHCDTParameter.split("^");
	for (var i=0;i<aryitmd.length-1;i++){
		aryitmi=aryitmd[i].split("!");
		ListObj.options[i] = new Option(aryitmi[0],aryitmi[1]);	
		//ListObj.options[i].selected=true;
	}
}

function CreateYDTS(Para,ShowType){
	var itemid=Para;
	var Encrypt="";
	var obj=document.getElementById("GetDTYDTS");
	if(obj){
		Encrypt=obj.value;
		var myDTYDTSXML=cspRunServerMethod(Encrypt,itemid);
  	dtywzxUI(12,0,myDTYDTSXML);
  }	
	return;
	
	var url="udhcdt.ydts.csp?ItmID="+Para+"&Type="+ShowType;
	var newwin = window.open(url,"","top=10000,left=10000");
	return;
}

function CreateXHZY(){   //仅参考不保存
	var Orders="";
	var Para1=""
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
		var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
		var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
    var OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row)    
    //判断是否处理草药
    if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 
		//传组号
  	var MasterSeqNo="";
  	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
  	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
  	if (OrderMasterSeqNo!=""){
  		MasterSeqNo=OrderMasterSeqNo;
  	}else{
  		MasterSeqNo=OrderSeqNo;
  	}

    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid
		Para1=Para1+"!"+MasterSeqNo
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
  //dhcsys_alert(Orders);
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	if ((EpisodeID!="")){
		var UploadFlag="0";	
		//var escapeDHCDTPrescXML=websys_escape(DHCDTPrescXML);
		//dhcsys_alert(EpisodeID+"&"+session['LOGON.USERCODE']+"&"+Orders+"&"+escapeDHCDTPrescXML+"&"+UploadFlag);
		//lgl xiugai xml数据太大会导致超出ie地址兰限制而报指针错误,相关数据取得放到dt.csp内
		var escapeDHCDTPrescXML="";   
		var url="udhcdt.xhzyentry.csp?EpisodeID="+EpisodeID+"&DocCode="+session['LOGON.USERCODE']+"&Orders="+Orders+"&OtherPresc="+escapeDHCDTPrescXML+"&UploadFlag="+UploadFlag;//"&DocName="+session['LOGON.USERNAME']+
		//var url="UDHCDT.XHZYEntry.Csp?EpisodeID="+EpisodeID+"&DocCode="+session['LOGON.USERCODE']+"&Orders="+Orders+"&OtherPresc="+escapeDHCDTPrescXML+"&UploadFlag="+UploadFlag;//"&DocName="+session['LOGON.USERNAME']+
		//var url="UDHCDT.XHZYEntry.Csp?EpisodeID="+EpisodeID+"&DocCode="+session['LOGON.USERCODE']+"&Orders="+Orders+"&UploadFlag="+UploadFlag;//"&DocName="+session['LOGON.USERNAME']+
		var newwin = window.open(url,"","top=10000,left=10000");   //,"TRAK_hidden"
	}
	return;
}

//  datong V3
function dtywzxUI(nCode,lParam,sXML){
	var result;
	result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
	return result;
}
function DaTongXHZYHander(){
	if (DTDepNotDoXHZY==1) return 0;
	var Orders="";
	var Para1="";
	var myrtn=0;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
		var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
		var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
    var OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row)
		var OrderStartDate=GetColumnData("OrderStartDate",Row)
		var OrderStartTime=GetColumnData("OrderStartTime",Row)
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		//传组号
    	var MasterSeqNo="";
    	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
    	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
    	if(OrderMasterSeqNo!="") {MasterSeqNo=OrderMasterSeqNo;}else{MasterSeqNo=OrderSeqNo;}
    	/*
    	for (var j=1; j<rows; j++){
				var GroupRow=GetRow(j);
				OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",GroupRow);
				if(OrderMasterSeqNo==OrderSeqNo)MasterSeqNo=OrderSeqNo;
			}*/
    //判断是否处理草药
    //if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime;
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
	var obj=document.getElementById("EpisodeID");
	if(obj)EpisodeID=obj.value;
	var DocCode=session['LOGON.USERCODE'];
	var UserID=session['LOGON.USERID'];
	
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	if (EpisodeID!=""){
		//var UploadFlag="0";	
		var DocCode=session['LOGON.USERCODE'];
		var UserID=session['LOGON.USERID'];
		
		var Encrypt="";
		var obj=document.getElementById("GetPrescXML");
		if(obj) {
			Encrypt=obj.value;
			var myPrescXML=cspRunServerMethod(Encrypt,Orders,EpisodeID,DocCode,UserID);
		
			if (PAAdmType=="I"){
				myrtn=dtywzxUI(28676,1,myPrescXML);
			}else{
				myrtn=dtywzxUI(4,0,myPrescXML);
			}
			
		}
	}
	return myrtn;
}
//datong yaodiantishi
function DaTongYDTSV3Hander()
{
	if (DTDepNotDoYDTS==1) return 0;
	var Row=GetRow(FocusRowIndex);
	var itemid=GetColumnData("OrderARCIMRowid",Row);
	var Encrypt="";
	var obj=document.getElementById("GetDTYDTS");
	if(obj){
		Encrypt=obj.value;
		var myDTYDTSXML=cspRunServerMethod(Encrypt,itemid);
  	dtywzxUI(12,0,myDTYDTSXML);
  }
}
///
function DaTongXHZYSave(){
	if (DTDepNotDoUpLoad==1) return 0; 
	var Orders="";
	var Para1="";
	var myrtn="";
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
		var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
		var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
		var OrderDoseQty=GetColumnData("OrderDoseQty",Row);
		var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
		var OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
		//传组号
  	var MasterSeqNo="";
  	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
  	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
  	if(OrderMasterSeqNo!="") {MasterSeqNo=OrderMasterSeqNo;}else{MasterSeqNo=OrderSeqNo;}
  	/*
  	for (var j=1; j<rows; j++){
			var GroupRow=GetRow(j);
			OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",GroupRow);
			if(OrderMasterSeqNo==OrderSeqNo)MasterSeqNo=OrderSeqNo;
		}*/
    //判断是否处理草药
    //if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo;
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	if ((EpisodeID!="")){
		//var UploadFlag="0";	
		var DocCode=session['LOGON.USERCODE'];
		var UserID=session['LOGON.USERID'];
		
		var obj=document.getElementById("GetPrescXML");
		if(obj){
			var Encrypt=obj.value;
			var myPrescXML=cspRunServerMethod(Encrypt,Orders,EpisodeID,DocCode,UserID);
			if (PAAdmType=="I"){
				myrtn=dtywzxUI(28685,1,myPrescXML);
			}else{
				myrtn=dtywzxUI(13,0,myPrescXML);
			}
  	}
	}
	return myrtn;
}

//document.body.onunload = DocumentUnloadHandler;
document.body.onbeforeunload=DocumentUnloadHandler; 

function DocumentUnloadHandler(e){
	CreateEND();
	//如果医嘱保存成功就不用保留在session中了
	if (StoreUnSaveData!="1"){return}
  
  try{
  	var Str="";
		var UnsaveData="";
		if (!UpdateFlag) {
		///护士补录医嘱 刷新界面清除关联
		var LinkedMasterOrderRowid=GetColumnData("LinkedMasterOrderRowid",Row);
		try{
		var par_win =window.parent.parent.parent.left.RPbottom
		if(par_win){
			par_win.ClearCheck();
			var LinkOrderStrobj=document.getElementById("LinkOrderStr");
			if (LinkOrderStrobj){
				LinkOrderStrobj.value=""
				SetNurLinkOrd()
				}
			}
		}catch(e){}
			var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
			var rows=objtbl.rows.length;
			for (var i=1; i<rows; i++){
				var Row=GetRow(i);
				var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
				var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);

				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")){
					var OrderName=GetColumnData("OrderName",Row);
					var OrderType=GetColumnData("OrderType",Row);
					var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
					var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
					var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
					var OrderFreq=GetColumnData("OrderFreq",Row);
					var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
					var OrderFreqInterval=GetColumnData("OrderFreqInterval",Row);
					var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
					var OrderDur=GetColumnData("OrderDur",Row);
					var OrderDurFactor=GetColumnData("OrderDurFactor",Row);
					var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);	
					var OrderInstr=GetColumnData("OrderInstr",Row);	
					var OrderDoseQty=GetColumnData("OrderDoseQty",Row);	
					var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
					var OrderDoseUOM=GetColumnData("OrderDoseUOM",Row);
					var OrderPackQty=GetColumnData("OrderPackQty",Row);
					var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
					var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
					var PHPrescType=GetColumnData("OrderPHPrescType",Row);
					var OrderConFac=GetColumnData("OrderConFac",Row);
					var OrderBaseQty=GetColumnData("OrderBaseQty",Row);
					var OrderPrice=GetColumnData("OrderPrice",Row);
					var OrderStartDate=GetColumnData("OrderStartDate",Row);
					var OrderPHForm=GetColumnData("OrderPHForm",Row);
					var OrderItemSum=GetColumnData("OrderSum",Row);	    
					var OrderEndDate=GetColumnData("OrderEndDate",Row);	  
					var OrderAlertStockQty=GetColumnData("OrderAlertStockQty",Row);
					var OrderDocRowid=GetColumnData("OrderDocRowid",Row);
					var OrderUserDep=GetColumnData("OrderUserDep",Row);
					var OrderUserAddRowid=GetColumnData("OrderUserAddRowid",Row);
					var OrderPackUOMRowid=GetColumnData("OrderPackUOMRowid",Row);
					var OrderBaseUOMRowid=GetColumnData("OrderBaseUOMRowid",Row);
					var OrderBillTypeRowId=GetColumnData("OrderBillTypeRowid",Row);
					var OrderARCOSRowid=GetColumnData("OrderARCOSRowid",Row);
					var OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
					var OrderStartDate=GetColumnData("OrderStartDate",Row);
					var OrderStartTime=GetColumnData("OrderStartTime",Row);
					var OrderDepProcNote=GetColumnData("OrderDepProcNote",Row);
					var OrderPhSpecInstr=GetColumnData("OrderPhSpecInstr",Row);
					var OrderSkinTest=GetColumnData("OrderSkinTest",Row);
					var OrderCoverMainIns=GetColumnData("OrderCoverMainIns",Row);
					var OrderActionRowid=GetColumnData("OrderActionRowid",Row);
					var OrderEndDate=GetColumnData("OrderEndDate",Row);
					var OrderEndTime=GetColumnData("OrderEndTime",Row);
					if (OrderSkinTest==true){OrderSkinTest="Y"}else{OrderSkinTest="N"}
					if (OrderCoverMainIns==true){OrderCoverMainIns="Y"}else{OrderCoverMainIns="N"}
					var OrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row);
					var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
					var OrderMultiDate=GetColumnData("OrderMultiDate",Row);
					if ((OrderMultiDate!="")&&(OrderMultiDate!=undefined)){
						var Arr=OrderMultiDate.split(String.fromCharCode(2));
						OrderMultiDate=Arr.join(String.fromCharCode(1));
					}

					var OrderNotifyClinician=GetColumnData("OrderNotifyClinician",Row);
					var OrderDIACatRowId=GetColumnData("OrderDIACatRowId",Row);

					var OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
					var OrderInsurCat=GetColumnData("OrderInsurCat",Row);
					var OrderInsurCatRowId=GetColumnData("OrderInsurCatRowId",Row);
					var OrderInsurSignSymptom=GetColumnData("OrderInsurSignSymptom",Row);
					var OrderInsurSignSymptomCode=GetColumnData("OrderInsurSignSymptomCode",Row);
					//因为在关闭界面的医嘱拼串分隔符和适应症串分隔符有冲突所以换成分隔符$C(3)
					if (OrderInsurSignSymptomCode!=""){
						var Arr=OrderInsurSignSymptomCode.split(String.fromCharCode(2));
						OrderInsurSignSymptomCode=Arr.join(String.fromCharCode(3));
					}
					//身体部位
					var OrderBodyPart=GetColumnData("OrderBodyPart",Row);
					//医嘱阶段
					var OrderStageCode=GetColumnData("OrderStage",Row);
					//输液滴速
					var OrderSpeedFlowRate=GetColumnData("OrderSpeedFlowRate",Row);
					//跨院标志
					var OrderOpenForAllHosp=GetColumnData("OrderOpenForAllHosp",Row);
					if (OrderOpenForAllHosp){OrderOpenForAllHosp=1}else{OrderOpenForAllHosp=0}
					//标本号
					var OrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row);
					var OrderLabEpisodeNo=GetColumnData("OrderLabEpisodeNo",Row);
					//通用名
					var OrderGenericName=GetColumnData("OrderGenericName",Row);
					//审批类型
					var OrderInsurApproveType=GetColumnData("OrderInsurApproveType",Row);
					//临床路径步骤
					var OrderCPWStepItemRowId=GetColumnData("OrderCPWStepItemRowId",Row);
					//高值材料条码——只保留隐藏条码值这个和医嘱项是一致的，页面的容易被篡改
					var OrderMaterialBarCode=GetColumnData("OrderMaterialBarcode",Row);
					var OrderMaterialBarcodeHiden=GetColumnData("OrderMaterialBarcodeHiden",Row); 
					var OrderMaterialBarCode=OrderMaterialBarcodeHiden //保存的时候只使用隐藏的高值条码
					//输液次数
					var OrderLocalInfusionQty=GetColumnData("OrderLocalInfusionQty",Row);
					//可用天数
					var OrderUsableDays=GetColumnData("OrderUsableDays",Row);
					//目前可用的接收科室串(包含各种医嘱类型),因为和刷新界面分隔符$C(2)有冲突所以换成分隔符$C(3)
					var OrderRecLocStr=GetColumnData("OrderRecLocStr",Row);
					if (OrderRecLocStr!=''){
						var OrderRecLocArr=OrderRecLocStr.split(String.fromCharCode(2));
						OrderRecLocStr=OrderRecLocArr.join(String.fromCharCode(3));
					}
					 //输液滴速单位
					var OrderFlowRateUnit=GetColumnData("OrderFlowRateUnit",Row);
					var OrderDate=GetColumnData("OrderDate",Row);
					var OrderTime=GetColumnData("OrderTime",Row);
					//是否配液
					var OrderNeedPIVAFlag=GetColumnData("OrderNeedPIVAFlag",Row);
					var OrderAntibApplyRowid=GetColumnData("OrderAntibApplyRowid",Row);
					if(OrderAntibApplyRowid=="undefined")OrderAntibApplyRowid="";
					//抗生素使用原因
					var AntUseReason=GetColumnData("AntUseReason",Row);
					//附件说明
					var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row);					
					var ShowTabStr=GetColumnData("ShowTabStr",Row);
					//使用目的 
					var UserReasonId=GetColumnData("UserReasonId",Row);
					//个人自备
					var OrderBySelfOMFlag=GetColumnData("OrderBySelfOMFlag",Row);
					//超量疗程原因
					var ExceedReasonID=GetColumnData("ExceedReasonID",Row);
					//药理项目
					var OrderPilotPro=GetColumnData("OrderPilotPro",Row);
					var OrderPilotProRowid=GetColumnData("OrderPilotProRowid",Row);
	
					var delim=String.fromCharCode(1);
					var icode=OrderARCIMRowid;
					var ipackqtystr=OrderPackQty;
					var idoseqtystr=OrderDoseQty+String.fromCharCode(1)+OrderDoseUOM+String.fromCharCode(1)+OrderDoseUOMRowid;
					var ireclocstr=OrderRecDepRowid+String.fromCharCode(1)+OrderOpenForAllHosp;
					var ifrequencestr=OrderFreq+String.fromCharCode(1)+OrderFreqRowid+String.fromCharCode(1)+OrderFreqFactor+String.fromCharCode(1)+OrderFreqInterval;
					var iinstructionstr=OrderInstr+String.fromCharCode(1)+OrderInstrRowid;
					var idurationstr=OrderDur+String.fromCharCode(1)+OrderDurRowid+String.fromCharCode(1)+OrderDurFactor;
					var idefpriorstr=OrderPriorRowid;
					var ilab=OrderLabSpecRowid+String.fromCharCode(1)+OrderLabEpisodeNo
				    var iother=OrderARCOSRowid+delim+OrderSkinTest+delim+OrderCoverMainIns+delim+OrderActionRowid+delim+OrderNotifyClinician+delim+OrderDepProcNote+delim+OrderInsurCatRowId+delim+OrderInsurCat+delim+OrderInsurSignSymptomCode+delim+OrderInsurSignSymptom+delim+OrderBodyPart+delim+OrderStageCode+delim+OrderGenericName+delim+OrderInsurApproveType+delim+OrderCPWStepItemRowId+delim+OrderMaterialBarCode+delim+OrderLocalInfusionQty+delim+OrderUsableDays;

					Str=icode+"^"+ipackqtystr+"^"+idoseqtystr+"^"+ireclocstr+"^"+ifrequencestr+"^"+iinstructionstr+"^"+idurationstr+"^"+idefpriorstr+"^"+ilab+"^"+iother+"^"+OrderHiddenPara+"^"+OrderMultiDate+"^"+OrderSeqNo+"^"+OrderMasterSeqNo+"^"+OrderBillTypeRowId+"^"+OrderDIACatRowId+"^"+OrderFirstDayTimes+"^"+OrderSpeedFlowRate+"^"+OrderStartDate+"^"+OrderStartTime+"^"+OrderRecLocStr;
					Str=Str+"^"+OrderFlowRateUnit+"^"+OrderDate+"^"+OrderTime+"^"+OrderNeedPIVAFlag+"^"+OrderAntibApplyRowid+"^"+AntUseReason+"^"+OrderPriorRemarks+"^"+UserReasonId+"^"+ShowTabStr+"^"+OrderBySelfOMFlag+"^"+ExceedReasonID;
					var OtherOrdData=OrderDocRowid+delim+OrderUserDep+delim+OrderUserAddRowid+delim+OrderPackUOMRowid+delim+OrderBaseUOMRowid+delim+OrderType+delim+PHPrescType;
						OtherOrdData=OtherOrdData+delim+OrderPrice+delim+OrderItemSum+delim+OrderDrugFormRowid+delim+OrderConFac+delim+OrderPHForm;
					var OtherExpStr=OrderPilotProRowid+delim+OrderPilotPro;
					
					Str=Str+"^"+OtherOrdData+"^"+OtherExpStr;
																																																																																																																																		 										
					if (UnsaveData==""){UnsaveData=Str}else{UnsaveData=UnsaveData+String.fromCharCode(2)+Str;}
				}
				if ((UnsaveData!="")&&(HospitalCode=="ZHSRMYY")) dhcsys_alert(t['OrderIsNotSave']);
			}
		}
		/*
		if (UserUnSaveData!=''){
			var RetCheck=dhcsys_confirm((t['NO_SAVE']),false);
	    if (RetCheck==false) {return}
		}
		
		var UserID=session['LOGON.USERID'];
		var obj=document.getElementById('EpisodeID');
		var EpisodeID=obj.value;
		var SessionFieldName="UserUnSaveData"+EpisodeID;
		var retDetail=cspRunServerMethod(SetSessionDataMethod,SessionFieldName,UnsaveData);
		*/
		var UserID=session['LOGON.USERID'];
		var CTLocId=session['LOGON.CTLOCID'];
		var obj=document.getElementById('EpisodeID');
		var EpisodeID=obj.value;
		var SessionFieldName="UserUnSaveData"+EpisodeID;
		//var retDetail=cspRunServerMethod(SetSessionDataMethod,SessionFieldName,UnsaveData);
		var AdmData=EpisodeID+"^"+UserID+"^"+PAAdmType+"^"+CTLocId;
		var retDetail=cspRunServerMethod(SetUserUnSaveDataMethod,AdmData,UnsaveData);

		//dhcsys_alert("Unload"+SessionFieldName+":"+UnsaveData);
	} catch(e) {dhcsys_alert(e.message);}

}
function GetColumnListStr(ColumnName,Row){
	var str="";
	var Id=ColumnName+"z"+Row;
	var obj=document.getElementById(Id);
	for (var i=0;i<obj.length;i++) {
		var scode=obj.options[i].value;
		var sdesc=obj.options[i].text;
		if (str==""){
			str=sdesc+String.fromCharCode(1)+scode;
		}else{
			str=str+String.fromCharCode(2)+sdesc+String.fromCharCode(1)+scode;
		}
 	}
 	return str;	
}
function GetLogonLocByFlag(){
	var FindRecLocByLogonLoc;
	//如果按登录科室取接收科室?就把登录科室传进去
	var obj=document.getElementById("FindByLogDep");
	if (obj){
		if (obj.checked){FindRecLocByLogonLoc=1}else{FindRecLocByLogonLoc=0}
	}
	var LogonDep=""
  if (FindRecLocByLogonLoc=="1"){LogonDep=session['LOGON.CTLOCID']}
  return LogonDep;
}

////////////////保存医嘱增加暂存功能20141118
function AddUnsaveDataToList(){
	var UserID=session['LOGON.USERID'];
	//dhcsys_alert(PAAdmType+","+EpisodeID+","+UserID)
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var UnsaveData=tkMakeServerCall("web.DHCDocUserUnSaveOrder","GetUserUnSaveData",PAAdmType,EpisodeID,UserID);
	//dhcsys_alert(UnsaveData)
	if(UnsaveData=="")return;
	var seqnoarray=new Array();
	var UnsaveArr1=UnsaveData.split(String.fromCharCode(2));
	for (var j=0;j<UnsaveArr1.length;j++) {
  		var ret=CanAddRow(objtbl);
		if (ret){AddRowToList(objtbl);}
	  	var RowIndex=FocusRowIndex;
	  	//var UnsaveInfo=tkMakeServerCall("web.DHCDocUserUnSaveOrder","GetUserUnSaveInfo",UnsaveArr1[j]);
	  	var UnsaveInfo=UnsaveArr1[j];
		var UnsaveArr=UnsaveInfo.split("^");
		var icode=mPiece(UnsaveArr[0],String.fromCharCode(1),0);
		var idesc=mPiece(UnsaveArr[0],String.fromCharCode(1),1);
		var GenericName=mPiece(UnsaveArr[0],String.fromCharCode(1),2);
		var OrderPackQty=mPiece(UnsaveArr[1],String.fromCharCode(1),0);
		var OrderPackUOM=mPiece(UnsaveArr[1],String.fromCharCode(1),1);
		var OrderPackUOMRowid=mPiece(UnsaveArr[1],String.fromCharCode(1),2);
		var OrderDoseQty=mPiece(UnsaveArr[2],String.fromCharCode(1),0);
		var OrderDoseUOM=mPiece(UnsaveArr[2],String.fromCharCode(1),1);
		var OrderDoseUOMRowid=mPiece(UnsaveArr[2],String.fromCharCode(1),2);

		var idoseqtystr=mPiece(UnsaveArr[2],String.fromCharCode(1),3);
		var OrderRecDepRowid=mPiece(UnsaveArr[3],String.fromCharCode(1),0);
		//var reclocdesc=mPiece(UnsaveArr[3],String.fromCharCode(1),1);
		var OrderOpenForAllHosp=mPiece(UnsaveArr[3],String.fromCharCode(1),2);
		var OrderFreqRowid=mPiece(UnsaveArr[4],String.fromCharCode(1),0);
		var OrderFreq=mPiece(UnsaveArr[4],String.fromCharCode(1),1);
		var OrderFreqFactor=mPiece(UnsaveArr[4],String.fromCharCode(1),2);
		var OrderFreqInterval=mPiece(UnsaveArr[4],String.fromCharCode(1),3);
		var OrderInstrRowid=mPiece(UnsaveArr[5],String.fromCharCode(1),0);
		var OrderInstr=mPiece(UnsaveArr[5],String.fromCharCode(1),1);
		var OrderDurRowid=mPiece(UnsaveArr[6],String.fromCharCode(1),0);
		var OrderDur=mPiece(UnsaveArr[6],String.fromCharCode(1),1);
		var OrderDurFactor=mPiece(UnsaveArr[6],String.fromCharCode(1),2);
		var OrderPriorRowid=mPiece(UnsaveArr[7],String.fromCharCode(1),0);
		//var priorcode=mPiece(UnsaveArr[7],String.fromCharCode(1),1);
		var OrderPriorRemarks=mPiece(UnsaveArr[7],String.fromCharCode(1),2);
		var OrderBillTypeRowid=mPiece(UnsaveArr[8],String.fromCharCode(1),0);
		var OrderBillType=mPiece(UnsaveArr[8],String.fromCharCode(1),1);
		
		var OrderPHPrescType=UnsaveArr[9],OrderType=UnsaveArr[10];
		var OrderSeqNo=UnsaveArr[11],OrderMasterSeqNo=UnsaveArr[12];
		var OrderPrice=UnsaveArr[13],OrderSum=UnsaveArr[14];
		var OrderLabSpecRowid=UnsaveArr[15],OrderLabEpisodeNo=UnsaveArr[16];
		var OrderCoverMainIns=UnsaveArr[17],OrderDepProcNote=UnsaveArr[18];
		var OrderARCOSRowid=UnsaveArr[19],OrderNotifyClinician=UnsaveArr[20];
		
		var OrderSkinTest=mPiece(UnsaveArr[21],String.fromCharCode(1),0);
		var OrderActionRowid=mPiece(UnsaveArr[21],String.fromCharCode(1),1);
		var docrowid=mPiece(UnsaveArr[22],String.fromCharCode(1),0);
		var docdesc=mPiece(UnsaveArr[22],String.fromCharCode(1),1);
		var userdeprowid=mPiece(UnsaveArr[23],String.fromCharCode(1),0);
		var userdep=mPiece(UnsaveArr[23],String.fromCharCode(1),1);
		
		var OrderStartDate=UnsaveArr[24],OrderStartTime=UnsaveArr[25];
		var useradd=UnsaveArr[26],OrderFirstDayTimes=UnsaveArr[27];
		
		var OrderDIACatRowId=mPiece(UnsaveArr[28],String.fromCharCode(1),0);
		//var priorcode=mPiece(UnsaveArr[28],String.fromCharCode(1),1);

		//var priorremark=mPiece(UnsaveArr[28],String.fromCharCode(1),2);
		
		var OrderInsurSignSymptom=mPiece(UnsaveArr[29],String.fromCharCode(1),0);
		var OrderInsurSignSymptomCode=mPiece(UnsaveArr[29],String.fromCharCode(1),1);
		
		var OrderInsurCatRowId=UnsaveArr[30],OrderInsurCat="";
		var OrderStageCode=UnsaveArr[32],OrderInsurApproveType=UnsaveArr[33];
		var OrderNeedPIVAFlag=UnsaveArr[34],OrderBySelfOMFlag=UnsaveArr[35];
		var OrderMaterialBarCode=UnsaveArr[36],OrderBodyPart=UnsaveArr[31];
		var ExceedReasonID=mPiece(UnsaveArr[37],String.fromCharCode(1),0);
		//var insusignsymcode=mPiece(UnsaveArr[37],String.fromCharCode(1),1);
		var UserReasonId=mPiece(UnsaveArr[38],String.fromCharCode(1),0);
		//var insusignsymcode=mPiece(UnsaveArr[38],String.fromCharCode(1),1);
		
		var AntUseReason=UnsaveArr[39],OrderUsableDays=UnsaveArr[40];
		var OrderCPWStepItemRowId=UnsaveArr[41],orderconfac=UnsaveArr[42];
		var OrderSpeedFlowRate=mPiece(UnsaveArr[43],String.fromCharCode(1),0);
		//var flowrateunitdesc=mPiece(UnsaveArr[43],String.fromCharCode(1),1);

		var OrderFlowRateUnit=mPiece(UnsaveArr[43],String.fromCharCode(1),2);
		
		var OrderLocalInfusionQty=UnsaveArr[44],OrderAntibApplyRowid=UnsaveArr[46];
		var ShowTabStr=UnsaveArr[45],OrderHiddenPara=UnsaveArr[47],OrderMultiDate=UnsaveArr[48];
		var OrderFile2=UnsaveArr[49];
		var OtherExpStr=UnsaveArr[50];
		var OrderPilotProRowid=mPiece(OtherExpStr,String.fromCharCode(1),0);
		var OrderPilotPro=mPiece(OtherExpStr,String.fromCharCode(1),1);
		
		var LogonDep=GetLogonLocByFlag();
  		var Row=GetRow(RowIndex);
  		var SessionStr=GetSessionStr();
		var EPARCIMDetail=cspRunServerMethod(GetEPARCIMDetailMehtod,EpisodeID,OrderBillTypeRowid,LogonDep,icode,OrderOpenForAllHosp,SessionStr,"");
		//dhcsys_alert(EPARCIMDetail);		
		var OrderItemCatRowid=mPiece(EPARCIMDetail,"^",2);
		var InciRowid=mPiece(EPARCIMDetail,"^",4);	
		var ireclocstr=mPiece(EPARCIMDetail,"^",9);
		//ireclocstr=OrderRecLocStr;
		var iformstr=mPiece(EPARCIMDetail,"^",10);
		var idoseqtystr=mPiece(EPARCIMDetail,"^",11);
		var ifrequencestr=mPiece(EPARCIMDetail,"^",12);
		var iinstructionstr=mPiece(EPARCIMDetail,"^",13);
		var idurationstr=mPiece(EPARCIMDetail,"^",14);
		var idefpriorstr=mPiece(EPARCIMDetail,"^",15);
		var iordermsg=mPiece(EPARCIMDetail,"^",16);
		var realstockqty=mPiece(EPARCIMDetail,"^",17);
		var ilab=mPiece(EPARCIMDetail,"^",18);
		var iskintest=mPiece(EPARCIMDetail,"^",19);
		var iinsurinfo=mPiece(EPARCIMDetail,"^",20);
		var iskintestyy=mPiece(EPARCIMDetail,"^",21);
		var ilimitstr=mPiece(EPARCIMDetail,"^",21);
		var ioutpriorreclocstr=mPiece(EPARCIMDetail,"^",22);
		var iallergy=mPiece(EPARCIMDetail,"^",23);
		var ionepriorreclocstr=mPiece(EPARCIMDetail,"^",24);
		var idiagnoscatstr=mPiece(EPARCIMDetail,"^",25);
		var OrderFormRowid=mPiece(iformstr,String.fromCharCode(1),5);
		self.focus();
		var OrderPHForm=mPiece(iformstr,String.fromCharCode(1),0);
		var OrderConFac=mPiece(iformstr,String.fromCharCode(1),2);
		var OrderDrugFormRowid=mPiece(iformstr,String.fromCharCode(1),1);
		var OrderPoisonRowid=mPiece(iformstr,String.fromCharCode(1),3);
		var OrderPoisonCode=mPiece(iformstr,String.fromCharCode(1),4);
		var OrderLabSpec=mPiece(ilab,String.fromCharCode(1),0);
		var OrderLabExCode=mPiece(ilab,String.fromCharCode(1),1);
		//var OrderLabEpisodeNo=mPiece(lab,String.fromCharCode(1),1);
		var OrderMaxDurFactor=mPiece(ilimitstr,String.fromCharCode(1),0);
  		var OrderMaxQty=mPiece(ilimitstr,String.fromCharCode(1),1);
		var OrderAlertStockQty=mPiece(ilimitstr,String.fromCharCode(1),2);
		var OrderMaxDoseQty=mPiece(ilimitstr,String.fromCharCode(1),4);
		var OrderMaxDoseQtyPerDay=mPiece(ilimitstr,String.fromCharCode(1),5);
		var OrderLimitDays=mPiece(ilimitstr,String.fromCharCode(1),6);
		var OrderMaxDoseQtyPerDay=mPiece(ilimitstr,String.fromCharCode(1),7);
  		var OrderMsg=mPiece(iordermsg,String.fromCharCode(1),0);
  		var OrderFile1=mPiece(iordermsg,String.fromCharCode(1),1);
  		//var OrderFile2=mPiece(iordermsg,String.fromCharCode(1),2);
  		//var OrderFile3=mPiece(iordermsg,String.fromCharCode(1),3);
  		var EmergencyFlag=mPiece(iskintest,String.fromCharCode(1),3); 
  		var OrderBaseQty=1;
		var Qty=1;	
	  	if ((PAAdmType=="I")&&(OrderType=="R")){
			if ((OrderPriorRowid==OutOrderPriorRowid)&&(ioutpriorreclocstr!="")){
				var CurrentRecLocStr=ioutpriorreclocstr;
			}else if ((OrderPriorRowid==OneOrderPriorRowid)&&(ionepriorreclocstr!="")) {
				var CurrentRecLocStr=ionepriorreclocstr;
			}else{
				//var CurrentRecLocStr=ireclocstr;
				var CurrentRecLocStr=GetRecLocStrByPrior(ireclocstr,OrderPriorRowid)
			}
		}else{
			//var CurrentRecLocStr=ireclocstr;
			var CurrentRecLocStr=GetRecLocStrByPrior(ireclocstr,OrderPriorRowid)
		}	
		
		if (InciRowid!=""){
			var BaseDoseQty=1;		
			if (OrderPackQty!="") {
				Qty=parseFloat(OrderConFac)*parseFloat(OrderPackQty);
			}else{
				if (OrderDoseUOMRowid!=""){
					//dhcsys_alert("DrugFormRowid:"+OrderDrugFormRowid+"  DefaultDoseUOMRowid: "+DefaultDoseUOMRowid+"   DefaultDoseQty "+DefaultDoseQty);
					OrderBaseQty=cspRunServerMethod(CalDoseMethod,OrderDoseUOMRowid,OrderDrugFormRowid,OrderDoseQty);
					if (OrderBaseQty=="") OrderBaseQty=1;
				  //dhcsys_alert("OrderBaseQty:"+OrderBaseQty);
				}
				if (isNumber(OrderFreqFactor)&&isNumber(OrderDurFactor)&&isNumber(OrderBaseQty)){
					Qty=parseFloat(OrderFreqFactor)*parseFloat(OrderDurFactor)*parseFloat(OrderBaseQty);
				}
			}

		}
		SetColumnData("OrderPrice",Row,OrderPrice);
		var RowObj=objtbl.rows[RowIndex];

		var EnableDuration=false;
		var EnableFrequence=false;
		var EnablePackQty=1;   //这个变量控制着数量能否录入   1，能录入，0，不能录入
		if (OrderType!="R"){
			if (OrderPHPrescType=="4"){
				EnableDuration=true;
				EnableFrequence=true;
			}				
			ChangeRowStyleToNormal(RowObj,OrderType,EnableDuration,EnableFrequence);
		}else{
			//住院的草药还需要录入疗程?开即刻医嘱
			if ((PAAdmType!="I")||((OrderPHPrescType=="3")&&(PAAdmType=="I"))){EnableDuration=true}
			//如果是韶关临时医嘱可以录入疗程(以后改成设置)
			if ((Hospital=="SG")||(OrderPriorRowid==ShortOrderPriorRowid)){EnableDuration=true}

				if(OrderPriorRowid==LongOrderPriorRowid){EnablePackQty=0}    //长期医嘱不能录入数量  把EnablePackQty置为0
			if ((OrderPHPrescType=="3")&&(((HospitalCode=="HF")&&(icode!="5612||1"))||(HospitalCode!="HF"))){
				ChangeRowStyle(RowObj,0,EnableDuration);
			}else{
				///zzy 20140731
				if (PAAdmType!="I"){
					//临时医嘱可以录入
					EnablePackQty=1;
					//add by guorongyong xhyy 2012.7.27 门诊自费可以录入整包装,特殊剂型可以录入整包装
					//if (OrderBillTypeRowid==ZFBillTypeRowid) EnablePackQty=1;
					if (PHCFormStr.indexOf("^"+OrderFormRowid+"^")!=-1) {
						//EnablePackQty=1;
					}
				}
				ChangeRowStyle(RowObj,EnablePackQty,EnableDuration);
			}			
		}
		
		//设置科研项目
		SetColumnList("OrderPilotPro",Row,PilotProStr);
		SetColumnData("OrderPilotPro",Row,OrderPilotProRowid);
		SetColumnData("OrderPilotProRowid",Row,OrderPilotProRowid);
			
		SetColumnData("OrderARCIMRowid",Row,icode);
		SetColumnData("OrderName",Row,idesc);
		SetColumnData("OrderGenericName",Row,GenericName);
		//里面设置默认剂量OrderDoseQty
		SetColumnList("OrderDoseUOM",Row,idoseqtystr);
		if (OrderDoseQty!=""){
			SetColumnData("OrderDoseQty",Row,OrderDoseQty);
			SetColumnData("OrderDoseUOM",Row,OrderDoseUOMRowid);	       
			SetColumnData("OrderDoseUOMRowid",Row,OrderDoseUOMRowid);
		}

		//把前面的得到可用接收科室串用来置接收科室List
		SetColumnList("OrderRecDep",Row,CurrentRecLocStr);
		//记录下非出院带药的接收科室和出院带药的接收科室?当切换医嘱类型时需要这两个串
		SetColumnData("OrderRecLocStr",Row,ireclocstr);
		SetColumnData("OrderOutPriorRecLocStr",Row,ioutpriorreclocstr);
		SetColumnData("OrderOnePriorRecLocStr",Row,ionepriorreclocstr);
		//设定前面给定的有库存接受科室
		if (OrderRecDepRowid!="") {
			SetColumnData("OrderRecDep",Row,OrderRecDepRowid);
			SetColumnData("OrderRecDepRowid",Row,OrderRecDepRowid);
		}
		if (OrderOpenForAllHosp==1){OrderOpenForAllHosp=true}else{OrderOpenForAllHosp=false}
		//跨院标志
		SetColumnData("OrderOpenForAllHosp",Row,OrderOpenForAllHosp);
		SetColumnData("OrderFreq",Row,OrderFreq);
		SetColumnData("OrderFreqRowid",Row,OrderFreqRowid);
		SetColumnData("OrderFreqFactor",Row,OrderFreqFactor);
		SetColumnData("OrderFreqInterval",Row,OrderFreqInterval);
		SetColumnData("OrderInstr",Row,OrderInstr);
		SetColumnData("OrderInstrRowid",Row,OrderInstrRowid);
		SetColumnData("OrderDur",Row,OrderDur);
		SetColumnData("OrderDurRowid",Row,OrderDurRowid);  
		SetColumnData("OrderDurFactor",Row,OrderDurFactor);
		SetColumnData("OrderPrior",Row,OrderPriorRowid);
		SetColumnData("OrderPriorRowid",Row,OrderPriorRowid);  
		SetColumnData("OrderBillType",Row,OrderBillType);
		SetColumnData("OrderBillTypeRowid",Row,OrderBillTypeRowid);
		SetColumnData("OrderPHForm",Row,OrderPHForm);
		SetColumnData("OrderPHPrescType",Row,OrderPHPrescType);
		SetColumnData("OrderSeqNo",Row,OrderSeqNo); 
		SetColumnData("OrderMasterSeqNo",Row,OrderMasterSeqNo); 
		SetColumnData("OrderPrice",Row,OrderPrice);
		SetColumnData("OrderSum",Row,OrderSum);
		SetColumnData("OrderType",Row,OrderType);	
		SetColumnData("OrderBaseQty",Row,OrderBaseQty);
		SetColumnData("OrderARCOSRowid",Row,OrderARCOSRowid );
		SetColumnData("OrderStartDate",Row,OrderStartDate);
		SetColumnData("OrderStartTime",Row,OrderStartTime);
		SetColumnData("OrderSpeedFlowRate",Row,OrderSpeedFlowRate);
		SetColumnData("OrderFlowRateUnit",Row,OrderFlowRateUnit);
		SetColumnData("OrderDate",Row,OrderStartDate);
		SetColumnData("OrderTime",Row,OrderStartTime);
		SetColumnData("OrderActionRowid",Row,OrderActionRowid);  
		SetColumnData("OrderAction",Row,OrderActionRowid);
		SetColumnData("OrderPriorRemarks",Row,OrderPriorRemarks);
		SetColumnData("OrderBySelfOMFlag",Row,OrderBySelfOMFlag);
		SetColumnData("OrderNeedPIVAFlag",Row,OrderNeedPIVAFlag);
		if (OrderBySelfOMFlag=="false") SetColumnData("OrderBySelfOMFlag",Row,false);
		if (OrderSkinTest=="Y")  SetColumnData("OrderSkinTest",Row,true);
		if (OrderCoverMainIns=="Y") {SetColumnData("OrderCoverMainIns",Row,true);}
		else SetColumnData("OrderCoverMainIns",Row,false);
		
		if (OrderNeedPIVAFlag=="false") SetColumnData("OrderNeedPIVAFlag",Row,false);
		
		//设特殊病种选择下拉框
		SetColumnList("OrderDIACat",Row,idiagnoscatstr)
		SetColumnData("OrderDIACat",Row,OrderDIACatRowId);
		SetColumnData("OrderDIACatRowId",Row,OrderDIACatRowId);
		//设标本选择下拉框
		SetColumnList("OrderLabSpec",Row,OrderLabSpec);
		SetColumnData("OrderLabSpec",Row,OrderLabSpecRowid);
		SetColumnData("OrderLabEpisodeNo",Row,OrderLabEpisodeNo);
		//设身体部位下拉框
		SetColumnData("OrderBodyPart",Row,OrderBodyPart);
		//设身体医嘱阶段下拉框
		SetColumnData("OrderStage",Row,OrderStageCode);			
		SetColumnData("OrderInsurCatRowId",Row,OrderInsurCatRowId); 
		SetColumnData("OrderInsurCat",Row,OrderInsurCat);
		SetColumnData("OrderInsurSignSymptom",Row,OrderInsurSignSymptom);
		SetColumnData("OrderInsurSignSymptomCode",Row,OrderInsurSignSymptomCode);
		SetColumnData("OrderInsurApproveType",Row,OrderInsurApproveType);
		SetColumnData("OrderCPWStepItemRowId",Row,OrderCPWStepItemRowId);
		//高值只保存隐藏条码 OrderMaterialBarCode
		SetColumnData("OrderMaterialBarCode",Row,OrderMaterialBarCode);
		SetColumnData("OrderMaterialBarcodeHiden",Row,OrderMaterialBarCode);
		SetColumnData("OrderLocalInfusionQty",Row,OrderLocalInfusionQty);
		SetColumnData("OrderUsableDays",Row,OrderUsableDays);
		SetColumnData("OrderAntibApplyRowid",Row,OrderAntibApplyRowid);
		SetColumnData("AntUseReason",Row,AntUseReason);
		SetColumnData("UserReasonId",Row,UserReasonId);
		SetColumnData("ShowTabStr",Row,ShowTabStr);
		SetColumnData("OrderPoisonCode",Row,OrderPoisonCode);
		SetColumnData("OrderDepProcNote",Row,OrderDepProcNote);
		SetColumnData("OrderFirstDayTimes",Row,OrderFirstDayTimes);
		SetColumnData("ExceedReasonID",Row,ExceedReasonID);
		SetColumnData("ExceedReason",Row,ExceedReasonID);
		if (EmergencyFlag=="Y"){
			if (OrderNotifyClinician=="true") {OrderNotifyClinician=true}else{OrderNotifyClinician=false}
			SetColumnData("OrderNotifyClinician",Row,OrderNotifyClinician);
		}else{
		 	ChangeCellStyle("OrderNotifyClinician",Row,true);
		}
		
		SetColumnData("OrderMaxDurFactor",Row,OrderMaxDurFactor); 
		SetColumnData("OrderMaxQty",Row,OrderMaxQty); 
		SetColumnData("OrderBaseQtySum",Row,Qty);
		SetColumnData("OrderFile1",Row,OrderFile1);
		SetColumnData("OrderFile2",Row,OrderFile2);
		//SetColumnData("OrderFile3",Row,OrderFile3);
		SetColumnData("OrderLabExCode",Row,OrderLabExCode);
		SetColumnData("OrderAlertStockQty",Row,OrderAlertStockQty);  
		SetColumnData("OrderHiddenPara",Row,OrderHiddenPara);
		SetColumnData("OrderMultiDate",Row,OrderMultiDate);  
		SetColumnData("OrderConFac",Row,OrderConFac);  	
		SetColumnData("OrderDrugFormRowid",Row,OrderDrugFormRowid);	
		//协议包装,2014-05-30,by xp,End 
		SetColumnData("OrderPackQty",Row,OrderPackQty);
		GetBillUOMStr(Row);
		SetColumnData("OrderPackUOM",Row,OrderPackUOMRowid);
		SetColumnData("OrderPackUOMRowid",Row,OrderPackUOMRowid);
		OrderPackUOMchangeCommon(Row);
		// 协议包装,2014-05-30,by xp,End
		
		//对有频次的非药品医嘱根据开始时间计算首日次数
		SetOrderFirstDayTimes(Row);
		//门诊输液次数
		SetOrderLocalInfusionQty(Row);
		//得到序号的串
		if (CheckMasterNoStr=="")CheckMasterNoStr="!";
		CheckMasterNoStr=CheckMasterNoStr+GetColumnData("OrderSeqNo",Row)+"!";
		seqnoarray[OrderSeqNo]=Row;

		SetPoisonOrderStyle(OrderPoisonCode,OrderPoisonRowid,RowObj,Row);
		if (OrderMasterSeqNo!="") {
			var Masterrow=seqnoarray[OrderMasterSeqNo];
			var MasterrowObj=objtbl.rows[Masterrow];
		  	if (MasterrowObj) {
		  		MasterrowObj.className="MasterOrder";
		  		MasterrowObj.PrevClassName="MasterOrder";
		  	}
	 		var rowObj=objtbl.rows[Row];
	 		rowObj.className="SubOrder";
  			rowObj.PrevClassName="SubOrder";
	 		ChangeCellsDisabledStyle(Row,true);
	 	}	
	}
	CheckFreqAndPackQty(Row);  //检测可用性
	SetScreenSum();
	
}
function SetPoisonOrderStyle(OrderPoisonCode,OrderPoisonRowid,RowObj,Row){
	if ((HospitalCode=='JZSYY')||(HospitalCode=='JSXZZXYY')){
		if ((OrderPoisonCode=='J1')||(OrderPoisonCode=='J2')||(OrderPoisonCode=='DX')||(OrderPoisonCode=='MZ')){
			RowObj.className='SkinTest';
			RowObj.PrevClassName="SkinTest";
		}
		if ((OrderPoisonCode=='TLJS')||(OrderPoisonCode=='DBTHZJ')){
	 		document.getElementById('OrderNamez'+Row).style.color='green';
	 	}
	}else{
		if (OrderPoisonRowid!=""){
			RowObj.className='SkinTest';
			RowObj.PrevClassName="SkinTest";
		}
	}
}

function GetRecLocStrByPrior(str,PriorRowId){
	//只查出定义了医嘱类型的接受科室否则查出全部
	var Find=0;
	var arr = new Array();
	var ArrData=str.split(String.fromCharCode(2));
	for (var i=0;i<ArrData.length;i++) {
		var ArrData1=ArrData[i].split(String.fromCharCode(1));
		if (ArrData1[3]==PriorRowId){
			Find=1
		}
	}
	for (var i=0;i<ArrData.length;i++) {
		var ArrData1=ArrData[i].split(String.fromCharCode(1));
		if (ArrData1[3]==""){
			if (Find==0) arr[arr.length] = ArrData[i];
		}else{
			if (ArrData1[3]==PriorRowId){
				arr[arr.length] = ArrData[i];
			}
		}
	}	
	return arr.join(String.fromCharCode(2));
}
function GetReclocByInstr(Row) {
	//用法定义接收科室
	var InstrReclocStr="";
	var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
	var InstrOrderType=GetColumnData("OrderType",Row);
	var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
	var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
	var InstrPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var PreInstrRecLocStr=GetColumnData("OrderRecLocStr",Row);
	//dhcsys_alert("PreInstrRecLocStr"+PreInstrRecLocStr)
	if ((InstrOrderType=="R")&&(ReclocByInstr=="1")&&(GetInstrReclocMethod!="")){
	var OrdDept=GetLogonLocByFlag();
  	//dhcsys_alert("OrderInstrRowid"+":"+OrderInstrRowid+"^"+"OrdDept"+":"+OrdDept+"^"+"PreInstrRecLocStr"+":"+PreInstrRecLocStr)
  	var InstrReclocStr=cspRunServerMethod(GetInstrReclocMethod,EpisodeID,OrderInstrRowid,OrdDept,OrderItemCatRowid,InstrPriorRowid,PreInstrRecLocStr)
  	//dhcsys_alert("InstrReclocStr"+":"+InstrReclocStr)
  }
  if (InstrReclocStr!="") {return InstrReclocStr;}else{return PreInstrRecLocStr;}
}
function SetGroupMasterOrder(ItemData){
	var TempArr=ItemData.split("!");
	var obj=document.getElementById("GroupMasterOrderItemRowid")
	if (obj){obj.value=TempArr[0]}
	var obj=document.getElementById("GroupMasterOrderItem")
	if (obj){obj.value=TempArr[1]}
}
//only for zyy
function InsertMRDiagnos(){
	if (document.getElementById("MRDiagnoseCount").value!=0){dhcsys_alert("诊断已存在!");return;};
	var yLogDepRowid="",yMRAdmRowid="",yICDCodeRowid="",yUserRowid="",yMRDIADesc="",yLogonCareProvID=""
	var yLogDepRowid=session['LOGON.CTLOCID'];
	var yMRAdmRowid=document.getElementById("EpisodeID").value;
	var yLogonCareProvID=document.getElementById("LogonCareProvID").value;
	//  sxw 39983
	var yICDCodeRowid="39983";       
	var yUserRowid=session['LOGON.USERID'];
	var yMRDIADesc="";
	//dhcsys_alert(yLogDepRowid+"^"+yMRAdmRowid+"^"+yICDCodeRowid+"^"+yUserRowid+"^"+yMRDIADesc);
	var GetDetail=document.getElementById('InsertDiagnos');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	//dhcsys_alert(LogDepRowid+"^"+MRADMID+"^"+MRCICDRowid+"^"+LogUserRowid);
	MRDiagnosRowid=cspRunServerMethod(encmeth,yLogDepRowid,yMRAdmRowid,yICDCodeRowid,yUserRowid,yMRDIADesc,"",yLogonCareProvID);
	//dhcsys_alert(MRDiagnosRowid);

	var EpisodeID=""
   var obj=document.getElementById('EpisodeID');
	if (obj){EpisodeID=obj.value}
	var obj=MRDiagnosRowid.split("^")[0]
		if (obj) {
			var	Doc=MRDiagnosRowid.split("^")[0];uuser=MRDiagnosRowid.split("^")[1];PAADMDepCodeDR=MRDiagnosRowid.split("^")[2];
			var SetArrivedStatus=document.getElementById('SetArrivedStatus');
			//dhcsys_alert(EpisodeID+"^"+AdmReadm+"^"+PAPMIAddress);
			if (SetArrivedStatus) {var encmeth=SetArrivedStatus.value} else {var encmeth=''};
			if (encmeth!="") {
				var LogonUserID=session['LOGON.USERID'];
				//dhcsys_alert(encmeth);
				//dhcsys_alert(EpisodeID+"^"+Doc+"^"+session['LOGON.CTLOCID']+"^"+uuser);
			
			if (cspRunServerMethod(encmeth,EpisodeID,Doc,PAADMDepCodeDR,uuser)!='1') {
					//dhcsys_alert('fail');
				}
			}
  }
	window.setTimeout("UpdateClickHandlerFinish()",1000);
}

function BeforceBalanceHandler(){
	var obj_PrescBillTypeID=document.getElementById('PrescBillTypeID');
	var EpisodeID=document.getElementById('EpisodeID');
	var PatTypeID=document.getElementById('PatTypeID');
	var AdmType=document.getElementById('GetPaAdmType');
	InsuDividePreForDoc("10",EpisodeID.value,session['LOGON.USERID'],obj_PrescBillTypeID.value,AdmType.value,"")
}
 
function changedoc(){
	var yMRAdmRowid="",yLogonCareProvID="";
	var yMRAdmRowid=document.getElementById("EpisodeID").value;
	var yLogonCareProvID=document.getElementById("LogonCareProvID").value;
	var GetDetail=document.getElementById('ChangeDoc');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	Doc=cspRunServerMethod(encmeth,yMRAdmRowid,yLogonCareProvID);
	window.setTimeout("UpdateClickHandlerFinish()",1000);
}	

//查看药品医嘱描述
function BtnViewArcInfoHandler(){
	if (FocusRowIndex<1) return;
	var Row=GetRow(FocusRowIndex);	
	var OrderType=GetColumnData("OrderType",Row)	
	if (OrderType=="R"){
		var f_OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row)
		if (f_OrderARCIMRowid!=""){
			//window.parent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc_Phamacy_Detail&PHCId="+f_OrderARCIMRowid;
			window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc_Phamacy_Detail&ARCIMRowid="+f_OrderARCIMRowid,"","dialogwidth:50em;dialogheight:30em;status:no;center:1;resizable:yes")
		}
	}
}

//弹出窗口增加备注
function AddRemarkClickhandler(rowindex){
	var OEOrderNotes="";
	if (rowindex<1) return;
	var focusrowid=GetRow(rowindex);
	OEOrderNotes=GetColumnData("OrderDepProcNote",focusrowid)
	var rtnvalue=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.DepProcNote&FocusRowIndex="+focusrowid+"&OEOrderNotes="+unescape(OEOrderNotes),true,"dialogwidth:40em;dialogheight:40em;status:no;center:1;resizable:yes")
	if(rtnvalue)
	{
		SetColumnData("OrderDepProcNote",focusrowid,unescape(rtnvalue));
	}
}

//查看医嘱对应的收费项
function BtnViewArcPriceInfoHandler(){
	if (FocusRowIndex<1) return;
	var Row=GetRow(FocusRowIndex);	
	var f_OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row)

	if (f_OrderARCIMRowid!=""){
		//window.parent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc_Phamacy_Detail&PHCId="+f_OrderARCIMRowid;
		window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFArcimPrice1&ArcimRowid="+f_OrderARCIMRowid,"","dialogwidth:800px;dialogheight:500px;status:no;center:1;resizable:yes");
	}
}

//打印门诊导诊单
function BtnPrtGuidPatHandler(){
	var Obj=document.getElementById("PatientID");	
	if (Obj) {var PatientID=Obj.value;}	else {var PatientID="";}	
	var Obj=document.getElementById("EpisodeID");	
	if (Obj) {var EpisodeID=Obj.value;}	else {var EpisodeID="";}	
	var Obj=document.getElementById("mradm");	
  if (Obj) {var MRADMID=Obj.value;}	else {var MRADMID="";}
   var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocPatGuideDocumentsPrt&EpisodeID="+EpisodeID+"&mradm="+MRADMID+"&PatientID="+PatientID;
  var ConfirmPrintAll=dhcsys_confirm("是否打印全部导诊单项目?");
if (ConfirmPrintAll){		
 window.open(url,"DHCDocPatGuideDocumentsPrtPrintAll","top=0,left=0,width=1,height=1,alwaysLowered=yes"); }
else{
 websys_createWindow(url,"DHCDocPatGuideDocumentsPrt","top=100,left=200,width=1000,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes"); 
	}
}

var ShowInsurCat=0;
function OrderInsurCat_lookuphandler(e) {
	if (evtName=='OrderInsurCat') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	ShowInsurCat=0;
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))){

		var url='websys.lookup.csp';
		url += "?ID=d157iOrderInsurCat1";
		/*不同的项目调用不同的Query
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookUpInsurCat";
		url += "&TLUJSF=InsurCatLookUpSelect";
		if (type=='click') {
			if (obj) url += "&P1=" ;
		}else{
			var obj=document.getElementById('OrderInsurCatz'+Row);
			if (obj) url += "&P1=" + websys_escape(obj.value);
		}		
		*/
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:LookupArcimInsurCat";
		url += "&TLUJSF=InsurCatLookUpSelect";
		
		var obj1=document.getElementById('OrderARCIMRowidz'+Row);
		if (obj) url += "&P1=" + websys_escape(obj1.value);  
		ShowInsurCat=1;
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function InsurCatLookUpSelect(value) {
	//dhcsys_alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusRowIndex);
	try {
    var OrderInsurCat=Split_Value[4];
    //取0还是4取决于所调用的query,参见OrderInsurCat_lookuphandler
    //var OrderInsurCat=Split_Value[0];
    var OrderInsurCatRowId=Split_Value[2];

		SetColumnData("OrderInsurCat",Row,OrderInsurCat);
		SetColumnData("OrderInsurCatRowId",Row,OrderInsurCatRowId);
	
		var obj=document.getElementById('OrderInsurCatz'+Row);
		if (obj) obj.className='';
	} catch(e) {dhcsys_alert(e.message)};
}


function DHCDOCCallCs() {
  
  Paadm = document.getElementById("EpisodeID").value;
  CsCallMethod = document.getElementById("GetCSData").value;
  var rtn = cspRunServerMethod(CsCallMethod, Paadm)
  
  if (rtn.split("^")[0] != "N") {
    PaperInfo = rtn.split("^");
    PatientType = "";
    PatientID = "";
    BookID = "";
    PName = "";
    Sex = "";
    PatientBirthday = "";
    OEORISttDat = "";
    ItemStr = "";
    ItemStr1 = "";
    PatientType = PaperInfo[0];
    PatientID = PaperInfo[1];
    BookID = PaperInfo[2];
    PName = PaperInfo[3];
    Sex = PaperInfo[4];
    PatientBirthday = PaperInfo[5];
    OEORISttDat = PaperInfo[6];
    ItemStr = PaperInfo[7];
    if (ItemStr != "") {
      for (i = 0; i < ItemStr.split(String.fromCharCode(1)).length; i++) {
        ItemData = ItemStr.split(String.fromCharCode(1))[i];
        var CheckItem = "";
        var StrDate = "";
        var Strtime = "";
        var OrderType = "";
        CheckItem = ItemData.split(String.fromCharCode(2))[0];
        StrDate = ItemData.split(String.fromCharCode(2))[1];
        Strtime = ItemData.split(String.fromCharCode(2))[2];
        OrderType = ItemData.split(String.fromCharCode(2))[3];
        //ItemStr1 = ItemStr1 + "<CheckItem>" + "<ItemDesc>" + CheckItem + "</ItemDesc>" + "<StrDate>" + StrDate + "</StrDate>"+"<Strtime>" + Strtime + "</Strtime>"+"</CheckItem>";
        ItemStr1 = ItemStr1 + '<CheckItem  Name = "' + CheckItem + '"  StrDate = "' + StrDate + '" StrTime = "' + Strtime + '"  OrderType = "' + OrderType + '" />'
      }
      databody = "";
      databody = databody + '<PatientType>' + PatientType + '</PatientType>';
      databody = databody + '<PatientID>' + PatientID + '</PatientID>';
      databody = databody + '<BookID>' + BookID + '</BookID>';
      databody = databody + '<Name>' + PName + '</Name>';
      databody = databody + '<Sex>' + Sex + '</Sex>';
      databody = databody + '<Birthday>' + PatientBirthday + '</Birthday>';
      databody = databody + '<BespeakDate>' + OEORISttDat + '</BespeakDate>';
      databody = databody + '<CheckItems>' + ItemStr1 + '</CheckItems>';
      var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
      var soap = "<?xml   version=\"1.0\"   encoding=\"utf-8\"?>"
      soap = soap + "<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"   xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"   xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
      soap = soap + "<soap:Body>"
      soap = soap + '<AddPatientInfo   xmlns="urn:VDSystemIntf-IVDSystem">'
      soap = soap + '<PatientInfo>';
      soap = soap + '<PatientInfo>';
      soap = soap + databody
      soap = soap + '</PatientInfo>';
      soap = soap + '</PatientInfo>';
      soap = soap + "</" + 'AddPatientInfo' + ">"
      soap = soap + "</soap:Body>"
      soap = soap + "</soap:Envelope>"
      //dhcsys_alert(PatientID+"^"+BookID) 
      var url = "http://172.26.202.11:1024/MEDIASERVER.DLL/soap/IVDSystem";
      //url="http://127.0.0.1/jh/MediaServer.dll/soap/IVDSystem";
      xmlHttp.open("POST", url, false);
      xmlHttp.setRequestHeader("Content-Type", "text/xml;charset=utf-8");
      xmlHttp.setRequestHeader("Content-Length", soap.length);
      xmlHttp.setRequestHeader("HOST", "172.26.202.11:1024")
      xmlHttp.setRequestHeader("SOAPAction", "urn:VDSystemIntf-IVDSystem#AddPatientInfo")
      //dhcsys_alert(soap)
      xmlHttp.send(soap);
      //dhcsys_alert(xmlHttp.responseText)
      //如果有错误的话   返回用户填写的信息   
      if (xmlHttp.status == 200) {
       // return 
      }
      else {
        return xmlHttp.responseXML.text;
      }

    }
  }
}

function RowDown_Click()
{
	var Row=GetRow(FocusRowIndex);
	Row=parseInt(Row);
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rowsAll=objtbl.rows.length;
	if(Row>(rowsAll-2)){
		dhcsys_alert("已经到达最后一行!");
		return;
		}
	var PreOrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
	var OrderType=GetColumnData("OrderType",Row);
	var PreOrderPHPrescType1=GetColumnData("OrderPHPrescType",(Row+1));
	var OrderType1=GetColumnData("OrderType",(Row+1));
	var OrderItemRowId=GetColumnData("OrderItemRowid",Row);
	if (OrderItemRowId!="") return;
	
	var TMPOrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var TMPOrderPrior=GetColumnData("OrderPrior",Row);
	var TMPOrderName=GetColumnData("OrderName",Row);
	var TMPOrderDoseQty=GetColumnData("OrderDoseQty",Row);
	var TMPOrderDoseUOM=GetColumnData("OrderDoseUOM",Row);
	var TMPOrderFreq=GetColumnData("OrderFreq",Row);
	var TMPOrderInstr=GetColumnData("OrderInstr",Row);
	var TMPOrderDur=GetColumnData("OrderDur",Row);
	var TMPOrderPrice=GetColumnData("OrderPrice",Row);
	var TMPOrderPackQty=GetColumnData("OrderPackQty",Row);
	var TMPOrderPackUOM=GetColumnData("OrderPackUOM",Row);
	var TMPOrderSkinTest=GetColumnData("OrderSkinTest",Row);
	var TMPOrderRecDep=GetColumnData("OrderRecDep",Row);
	var TMPOrderSum=GetColumnData("OrderSum",Row);
	var TMPOrderPrescNo=GetColumnData("OrderPrescNo",Row);
	var TMPOrderDepProcNote=GetColumnData("OrderDepProcNote",Row);
	var TMPOrderDoc=GetColumnData("OrderDoc",Row);
	var TMPOrderUserAdd=GetColumnData("OrderUserAdd",Row);
	var TMPOrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	var TMPOrderUserDep=GetColumnData("OrderUserDep",Row);
	var TMPOrderBillType=GetColumnData("OrderBillType",Row);
	var TMPOrderStartDate=GetColumnData("OrderStartDate",Row);
	var TMPOrderStartTime=GetColumnData("OrderStartTime",Row);
	var TMPOrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var TMPOrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
	var TMPOrderDurRowid=GetColumnData("OrderDurRowid",Row);
	var TMPOrderPackUOMRowid=GetColumnData("OrderPackUOMRowid",Row);
	var TMPOrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
	var TMPOrderStatusRowid=GetColumnData("OrderStatusRowid",Row);
	var TMPOrderBaseUOMRowid=GetColumnData("OrderBaseUOMRowid",Row);
	var TMPOrderDocRowid=GetColumnData("OrderDocRowid",Row);
	var TMPOrderUserAddRowid=GetColumnData("OrderUserAddRowid",Row);
	var TMPOrderLinkTo=GetColumnData("OrderLinkTo",Row);
	var TMPOrderARCOSRowid=GetColumnData("OrderARCOSRowid",Row);
	var TMPOrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row);
	var TMPOrderMaxDurRowid=GetColumnData("OrderMaxDurRowid",Row);
	var TMPOrderType=GetColumnData("OrderType",Row);
	var TMPOrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
	var TMPOrderSttDate=GetColumnData("OrderSttDate",Row);
	var TMPOrderPHForm=GetColumnData("OrderPHForm",Row);
	var TMPOrderConFac=GetColumnData("OrderConFac",Row);
	var TMPOrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	var TMPOrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
	var TMPOrderItemRowid=GetColumnData("OrderItemRowid",Row);
	var TMPOrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
	var TMPOrderFreqInterval=GetColumnData("OrderFreqInterval",Row);
	var TMPOrderDurFactor=GetColumnData("OrderDurFactor",Row);
	var TMPOrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
	var TMPOrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
	var TMPOrderBaseQty=GetColumnData("OrderBaseQty",Row);
	var TMPOrderPhSpecInstr=GetColumnData("OrderPhSpecInstr",Row);
	var TMPOrderLabSpec=GetColumnData("OrderLabSpec",Row);
	var TMPOrderAutoCalculate=GetColumnData("OrderAutoCalculate",Row);
	var TMPOrderCoverMainIns=GetColumnData("OrderCoverMainIns",Row);
	var TMPOrderAction=GetColumnData("OrderAction",Row);
	var TMPOrderActionRowid=GetColumnData("OrderActionRowid",Row);
	var TMPOrderMaxDurFactor=GetColumnData("OrderMaxDurFactor",Row);
	var TMPOrderMaxQty=GetColumnData("OrderMaxQty",Row);
	var TMPOrderFile1=GetColumnData("OrderFile1",Row);
	var TMPOrderFile2=GetColumnData("OrderFile2",Row);
	var TMPOrderFile3=GetColumnData("OrderFile3",Row);
	var TMPOrderLabExCode=GetColumnData("OrderLabExCode",Row);
	var TMPOrderEndDate=GetColumnData("OrderEndDate",Row);
	var TMPOrderEndTime=GetColumnData("OrderEndTime",Row);
	var TMPOrderOutPriorRecLocStr=GetColumnData("OrderOutPriorRecLocStr",Row);
	var TMPOrderRecLocStr=GetColumnData("OrderRecLocStr",Row);
	var TMPOrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row);
	var TMPOrderAlertStockQty=GetColumnData("OrderAlertStockQty",Row);
	var TMPOrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
	var TMPOrderMultiDate=GetColumnData("OrderMultiDate",Row);
	var TMPOrderFreqDispTimeStr=GetColumnData("OrderFreqDispTimeStr",Row);
	var TMPOrderGenericName=GetColumnData("OrderGenericName",Row);
	var TMPOrderInsurApproveType=GetColumnData("OrderInsurApproveType",Row);
	var TMPOrderCPWStepItemRowId=GetColumnData("OrderCPWStepItemRowId",Row);
	var TMPOrderMaterialBarCode=GetColumnData("OrderMaterialBarCode",Row);
	var TMPOrderMaterialBarcodeHiden=GetColumnData("OrderMaterialBarcodeHiden",Row);
	var TMPOrderLocalInfusionQty=GetColumnData("OrderLocalInfusionQty",Row);
	/*
	//如果有录入人了则说明是审核过的医嘱?则不允许上移和下移
	if(OrderItemRowId!=""){
		dhcsys_alert("已经审核过的医嘱不能移动!");
		return;
	}
	*/
	//单位
	var TMPOrderDoseUOMList=new Array();
	var obj=document.getElementById("OrderDoseUOMz"+Row);
	if(obj.tagName=="SELECT"){
	for(var i=0;i<obj.length;i++){
		TMPOrderDoseUOMList[i]=obj.options[i].value+"^"+obj.options[i].text;
		//dhcsys_alert(obj.options[i].value);	
	}
	if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}
//接收科室
	var TMPOrderDoseUOMListLoc=new Array();
 	var obj=document.getElementById("OrderRecDepz"+Row);
	if(obj.tagName=="SELECT"){
	for(var i=0;i<obj.length;i++){
		TMPOrderDoseUOMListLoc[i]=obj.options[i].value+"^"+obj.options[i].text;
		//dhcsys_alert(obj.options[i].value);	
	}
	if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}
	
	var TMP1OrderSeqNo=GetColumnData("OrderSeqNo",Row+1);
	var TMP1OrderPrior=GetColumnData("OrderPrior",Row+1);
	var TMP1OrderName=GetColumnData("OrderName",Row+1);
	var TMP1OrderDoseQty=GetColumnData("OrderDoseQty",Row+1);
	var TMP1OrderDoseUOM=GetColumnData("OrderDoseUOM",Row+1);
	var TMP1OrderFreq=GetColumnData("OrderFreq",Row+1);
	var TMP1OrderInstr=GetColumnData("OrderInstr",Row+1);
	var TMP1OrderDur=GetColumnData("OrderDur",Row+1);
	var TMP1OrderPrice=GetColumnData("OrderPrice",Row+1);
	var TMP1OrderPackQty=GetColumnData("OrderPackQty",Row+1);
	var TMP1OrderPackUOM=GetColumnData("OrderPackUOM",Row+1);
	var TMP1OrderSkinTest=GetColumnData("OrderSkinTest",Row+1);
	var TMP1OrderRecDep=GetColumnData("OrderRecDep",Row+1);
	var TMP1OrderSum=GetColumnData("OrderSum",Row+1);
	var TMP1OrderPrescNo=GetColumnData("OrderPrescNo",Row+1);
	var TMP1OrderDepProcNote=GetColumnData("OrderDepProcNote",Row+1);
	var TMP1OrderDoc=GetColumnData("OrderDoc",Row+1);
	var TMP1OrderUserAdd=GetColumnData("OrderUserAdd",Row+1);
	var TMP1OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row+1);
	var TMP1OrderUserDep=GetColumnData("OrderUserDep",Row+1);
	var TMP1OrderBillType=GetColumnData("OrderBillType",Row+1);
	var TMP1OrderStartDate=GetColumnData("OrderStartDate",Row+1);
	var TMP1OrderStartTime=GetColumnData("OrderStartTime",Row+1);
	var TMP1OrderPriorRowid=GetColumnData("OrderPriorRowid",Row+1);
	var TMP1OrderInstrRowid=GetColumnData("OrderInstrRowid",Row+1);
	var TMP1OrderDurRowid=GetColumnData("OrderDurRowid",Row+1);
	var TMP1OrderPackUOMRowid=GetColumnData("OrderPackUOMRowid",Row+1);
	var TMP1OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row+1);
	var TMP1OrderStatusRowid=GetColumnData("OrderStatusRowid",Row+1);
	var TMP1OrderBaseUOMRowid=GetColumnData("OrderBaseUOMRowid",Row+1);
	var TMP1OrderDocRowid=GetColumnData("OrderDocRowid",Row+1);
	var TMP1OrderUserAddRowid=GetColumnData("OrderUserAddRowid",Row+1);
	var TMP1OrderLinkTo=GetColumnData("OrderLinkTo",Row+1);
	var TMP1OrderARCOSRowid=GetColumnData("OrderARCOSRowid",Row+1);
	var TMP1OrderDrugFormRowid=GetColumnData("OrderDrugFormRowid",Row+1);
	var TMP1OrderMaxDurRowid=GetColumnData("OrderMaxDurRowid",Row+1);
	var TMP1OrderType=GetColumnData("OrderType",Row+1);
	var TMP1OrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row+1);
	var TMP1OrderSttDate=GetColumnData("OrderSttDate",Row+1);
	var TMP1OrderPHForm=GetColumnData("OrderPHForm",Row+1);
	var TMP1OrderConFac=GetColumnData("OrderConFac",Row+1);
	var TMP1OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row+1);
	var TMP1OrderPHPrescType=GetColumnData("OrderPHPrescType",Row+1);
	var TMP1OrderItemRowid=GetColumnData("OrderItemRowid",Row+1);
	var TMP1OrderFreqFactor=GetColumnData("OrderFreqFactor",Row+1);
	var TMP1OrderFreqInterval=GetColumnData("OrderFreqInterval",Row+1);
	var TMP1OrderDurFactor=GetColumnData("OrderDurFactor",Row+1);
	var TMP1OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row+1);
	var TMP1OrderFreqRowid=GetColumnData("OrderFreqRowid",Row+1);
	var TMP1OrderBaseQty=GetColumnData("OrderBaseQty",Row+1);
	var TMP1OrderPhSpecInstr=GetColumnData("OrderPhSpecInstr",Row+1);
	var TMP1OrderLabSpec=GetColumnData("OrderLabSpec",Row+1);
	var TMP1OrderAutoCalculate=GetColumnData("OrderAutoCalculate",Row+1);
	var TMP1OrderCoverMainIns=GetColumnData("OrderCoverMainIns",Row+1);
	var TMP1OrderAction=GetColumnData("OrderAction",Row+1);
	var TMP1OrderActionRowid=GetColumnData("OrderActionRowid",Row+1);
	var TMP1OrderMaxDurFactor=GetColumnData("OrderMaxDurFactor",Row+1);
	var TMP1OrderMaxQty=GetColumnData("OrderMaxQty",Row+1);
	var TMP1OrderFile1=GetColumnData("OrderFile1",Row+1);
	var TMP1OrderFile2=GetColumnData("OrderFile2",Row+1);
	var TMP1OrderFile3=GetColumnData("OrderFile3",Row+1);
	var TMP1OrderLabExCode=GetColumnData("OrderLabExCode",Row+1);
	var TMP1OrderEndDate=GetColumnData("OrderEndDate",Row+1);
	var TMP1OrderEndTime=GetColumnData("OrderEndTime",Row+1);
	var TMP1OrderOutPriorRecLocStr=GetColumnData("OrderOutPriorRecLocStr",Row+1);
	var TMP1OrderRecLocStr=GetColumnData("OrderRecLocStr",Row+1);
	var TMP1OrderLabSpecRowid=GetColumnData("OrderLabSpecRowid",Row+1);
	var TMP1OrderAlertStockQty=GetColumnData("OrderAlertStockQty",Row+1);
	var TMP1OrderHiddenPara=GetColumnData("OrderHiddenPara",Row+1);
	var TMP1OrderMultiDate=GetColumnData("OrderMultiDate",Row+1);
	var TMP1OrderFreqDispTimeStr=GetColumnData("OrderFreqDispTimeStr",Row+1);
	var TMP1OrderGenericName=GetColumnData("OrderGenericName",Row+1)
	var TMP1OrderInsurApproveType=GetColumnData("OrderInsurApproveType",Row+1);
	var TMP1OrderCPWStepItemRowId=GetColumnData("OrderCPWStepItemRowId",Row+1);
	var TMP1OrderMaterialBarCode=GetColumnData("OrderMaterialBarCode",Row+1);
	var TMP1OrderMaterialBarcodeHiden=GetColumnData("OrderMaterialBarcodeHiden",Row+1);
	var TMP1OrderLocalInfusionQty=GetColumnData("OrderLocalInfusionQty",Row+1);
	
	//单位
	var TMP1OrderDoseUOMList=new Array();
	var obj=document.getElementById("OrderDoseUOMz"+(Row+1));
	if(obj.tagName=="SELECT"){
	for(var i=0;i<obj.length;i++){
		TMP1OrderDoseUOMList[i]=obj.options[i].value+"^"+obj.options[i].text;
	
	}
	if (obj.options.length>0) {
	  for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}
//接收科室
	var TMP1OrderDoseUOMListLoc=new Array();
 	var obj=document.getElementById("OrderRecDepz"+(Row+1));
	if(obj.tagName=="SELECT"){
	for(var i=0;i<obj.length;i++){
		TMP1OrderDoseUOMListLoc[i]=obj.options[i].value+"^"+obj.options[i].text;
		//dhcsys_alert(obj.options[i].value);	
	}
	if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}
	//根据医嘱类型确定行的风格
 var EnableDuration=true;
 var EnableFrequence=false;
 var RowObj=objtbl.rows[Row];
 	var RowObj1=objtbl.rows[Row+1];
 if((OrderType=="R")&&(OrderType1!="R")){
 	
 	ChangeRowStyle(RowObj1,1,EnableDuration);
  ChangeRowStyleToNormal(RowObj,OrderType1,EnableDuration,EnableFrequence);
		
}
if((OrderType!="R")&&(OrderType1=="R")){
 	ChangeRowStyle(RowObj,1,EnableDuration);
  ChangeRowStyleToNormal(RowObj1,OrderType,EnableDuration,EnableFrequence);
}
   //单位
  var obj=document.getElementById("OrderDoseUOMz"+(Row+1));
  for(var i=0;i<TMPOrderDoseUOMList.length;i++){
  	var tempvalue=TMPOrderDoseUOMList[i].split("^")[0];
  	var temptext=TMPOrderDoseUOMList[i].split("^")[1];
  	obj.options[i]=new Option(temptext,tempvalue);
  	}
  
  var objTMP=document.getElementById("OrderDoseUOMz"+Row);
	for(var i=0;i<TMP1OrderDoseUOMList.length;i++){
  	var tempvalue=TMP1OrderDoseUOMList[i].split("^")[0];
  	var temptext=TMP1OrderDoseUOMList[i].split("^")[1];
  	objTMP.options[i]=new Option(temptext,tempvalue);
  	}
  	//接收科室
  	var obj=document.getElementById("OrderRecDepz"+(Row+1));
  for(var i=0;i<TMPOrderDoseUOMListLoc.length;i++){
  	var tempvalue=TMPOrderDoseUOMListLoc[i].split("^")[0];
  	var temptext=TMPOrderDoseUOMListLoc[i].split("^")[1];
  	obj.options[i]=new Option(temptext,tempvalue);
  	}
  
  var objTMP=document.getElementById("OrderRecDepz"+Row);
	for(var i=0;i<TMP1OrderDoseUOMListLoc.length;i++){
  	var tempvalue=TMP1OrderDoseUOMListLoc[i].split("^")[0];
  	var temptext=TMP1OrderDoseUOMListLoc[i].split("^")[1];
  	objTMP.options[i]=new Option(temptext,tempvalue);
  	}
  	/*
  	//交换颜色
  var TMPRowObj=objtbl.rows[Row];
	var TMPColor=TMPRowObj.className;
	var TMP1RowObj=objtbl.rows[Row+1];
	var TMP1Color=TMP1RowObj.className;
	if(TMPColor=="SkinTest"||(TMP1Color=="SkinTest")){
	TMP1RowObj.className=TMPColor;
	TMPRowObj.className=TMP1Color;
}
*/
	 
	 SetColumnData("OrderPrior",Row+1,TMPOrderPrior);
	 SetColumnData("OrderName",Row+1,TMPOrderName);
	 SetColumnData("OrderDoseQty",Row+1,TMPOrderDoseQty);
	 SetColumnData("OrderDoseUOM",Row+1,TMPOrderDoseUOM);
	 SetColumnData("OrderFreq",Row+1,TMPOrderFreq);
	 SetColumnData("OrderInstr",Row+1,TMPOrderInstr);
	 SetColumnData("OrderDur",Row+1,TMPOrderDur);
	 SetColumnData("OrderPrice",Row+1,TMPOrderPrice);
	 SetColumnData("OrderPackQty",Row+1,TMPOrderPackQty);
	 SetColumnData("OrderPackUOM",Row+1,TMPOrderPackUOM);
	 SetColumnData("OrderSkinTest",Row+1,TMPOrderSkinTest);
	 SetColumnData("OrderRecDep",Row+1,TMPOrderRecDep);
	 SetColumnData("OrderSum",Row+1,TMPOrderSum);
	 SetColumnData("OrderPrescNo",Row+1,TMPOrderPrescNo);
	 SetColumnData("OrderDepProcNote",Row+1,TMPOrderDepProcNote);
	 SetColumnData("OrderDoc",Row+1,TMPOrderDoc);
	 SetColumnData("OrderUserAdd",Row+1,TMPOrderUserAdd);
	 SetColumnData("OrderMasterSeqNo",Row+1,TMPOrderMasterSeqNo);
	 SetColumnData("OrderUserDep",Row+1,TMPOrderUserDep);
	 SetColumnData("OrderBillType",Row+1,TMPOrderBillType);
	 SetColumnData("OrderStartDate",Row+1,TMPOrderStartDate);
	 SetColumnData("OrderStartTime",Row+1,TMPOrderStartTime);
	 SetColumnData("OrderPriorRowid",Row+1,TMPOrderPriorRowid);
	 SetColumnData("OrderInstrRowid",Row+1,TMPOrderInstrRowid);
	 SetColumnData("OrderDurRowid",Row+1,TMPOrderDurRowid);
	 SetColumnData("OrderPackUOMRowid",Row+1,TMPOrderPackUOMRowid);
	 SetColumnData("OrderRecDepRowid",Row+1,TMPOrderRecDepRowid);
	 SetColumnData("OrderStatusRowid",Row+1,TMPOrderStatusRowid);
	 SetColumnData("OrderBaseUOMRowid",Row+1,TMPOrderBaseUOMRowid);
	 SetColumnData("OrderDocRowid",Row+1,TMPOrderDocRowid);
	 SetColumnData("OrderUserAddRowid",Row+1,TMPOrderUserAddRowid);
	 SetColumnData("OrderLinkTo",Row+1,TMPOrderLinkTo);
	 SetColumnData("OrderARCOSRowid",Row+1,TMPOrderARCOSRowid);
	 SetColumnData("OrderDrugFormRowid",Row+1,TMPOrderDrugFormRowid);
	 SetColumnData("OrderMaxDurRowid",Row+1,TMPOrderMaxDurRowid);
	 SetColumnData("OrderType",Row+1,TMPOrderType);
	 SetColumnData("OrderBillTypeRowid",Row+1,TMPOrderBillTypeRowid);
	 SetColumnData("OrderSttDate",Row+1,TMPOrderSttDate);
	 SetColumnData("OrderPHForm",Row+1,TMPOrderPHForm);
	 SetColumnData("OrderConFac",Row+1,TMPOrderConFac);
	 SetColumnData("OrderARCIMRowid",Row+1,TMPOrderARCIMRowid);
	 SetColumnData("OrderPHPrescType",Row+1,TMPOrderPHPrescType);
	 SetColumnData("OrderItemRowid",Row+1,TMPOrderItemRowid);
	 SetColumnData("OrderFreqFactor",Row+1,TMPOrderFreqFactor);
	 SetColumnData("OrderFreqInterval",Row+1,TMPOrderFreqInterval);
	 SetColumnData("OrderDurFactor",Row+1,TMPOrderDurFactor);
	 SetColumnData("OrderDoseUOMRowid",Row+1,TMPOrderDoseUOMRowid);
	 SetColumnData("OrderFreqRowid",Row+1,TMPOrderFreqRowid);
	 SetColumnData("OrderBaseQty",Row+1,TMPOrderBaseQty);
	 SetColumnData("OrderPhSpecInstr",Row+1,TMPOrderPhSpecInstr);
	 SetColumnData("OrderLabSpec",Row+1,TMPOrderLabSpec);
	 SetColumnData("OrderAutoCalculate",Row+1,TMPOrderAutoCalculate);
	 SetColumnData("OrderCoverMainIns",Row+1,TMPOrderCoverMainIns);
	 SetColumnData("OrderAction",Row+1,TMPOrderAction);
	 SetColumnData("OrderActionRowid",Row+1,TMPOrderActionRowid);
	 SetColumnData("OrderMaxDurFactor",Row+1,TMPOrderMaxDurFactor);
	 SetColumnData("OrderMaxQty",Row+1,TMPOrderMaxQty);
	 SetColumnData("OrderFile1",Row+1,TMPOrderFile1);
	 SetColumnData("OrderFile2",Row+1,TMPOrderFile2);
	 SetColumnData("OrderFile3",Row+1,TMPOrderFile3);
	 SetColumnData("OrderLabExCode",Row+1,TMPOrderLabExCode);
	 SetColumnData("OrderEndDate",Row+1,TMPOrderEndDate);
	 SetColumnData("OrderEndTime",Row+1,TMPOrderEndTime);
	 SetColumnData("OrderOutPriorRecLocStr",Row+1,TMPOrderOutPriorRecLocStr);
	 SetColumnData("OrderRecLocStr",Row+1,TMPOrderRecLocStr);
	 SetColumnData("OrderLabSpecRowid",Row+1,TMPOrderLabSpecRowid);
	 SetColumnData("OrderAlertStockQty",Row+1,TMPOrderAlertStockQty);
	 SetColumnData("OrderHiddenPara",Row+1,TMPOrderHiddenPara);
	 SetColumnData("OrderMultiDate",Row+1,TMPOrderMultiDate);
	 SetColumnData("OrderFreqDispTimeStr",Row+1,TMPOrderFreqDispTimeStr);
	 SetColumnData("OrderGenericName",Row+1,TMPOrderGenericName);
	 SetColumnData("OrderInsurApproveType",Row+1,TMPOrderInsurApproveType);
	 SetColumnData("OrderCPWStepItemRowId",Row+1,TMPOrderCPWStepItemRowId);
	 SetColumnData("OrderMaterialBarCode",Row+1,TMPOrderMaterialBarCode);
	 SetColumnData("OrderMaterialBarcodeHiden",Row+1,TMPOrderMaterialBarcodeHiden);

	 
	 SetColumnData("OrderLocalInfusionQty",Row+1,TMPOrderLocalInfusionQty);
	 
	 //SetColumnData("OrderSeqNo",Row+1,TMPOrderSeqNo);
	 
	 SetColumnData("OrderPrior",Row,TMP1OrderPrior);
	 SetColumnData("OrderName",Row,TMP1OrderName);
	 SetColumnData("OrderDoseQty",Row,TMP1OrderDoseQty);
	 SetColumnData("OrderDoseUOM",Row,TMP1OrderDoseUOM);
	 SetColumnData("OrderFreq",Row,TMP1OrderFreq);
	 SetColumnData("OrderInstr",Row,TMP1OrderInstr);
	 SetColumnData("OrderDur",Row,TMP1OrderDur);
	 SetColumnData("OrderPrice",Row,TMP1OrderPrice);
	 SetColumnData("OrderPackQty",Row,TMP1OrderPackQty);
	 SetColumnData("OrderPackUOM",Row,TMP1OrderPackUOM);
	 SetColumnData("OrderSkinTest",Row,TMP1OrderSkinTest);
	 SetColumnData("OrderRecDep",Row,TMP1OrderRecDep);
	 SetColumnData("OrderSum",Row,TMP1OrderSum);
	 SetColumnData("OrderPrescNo",Row,TMP1OrderPrescNo);
	 SetColumnData("OrderDepProcNote",Row,TMP1OrderDepProcNote);
	 SetColumnData("OrderDoc",Row,TMP1OrderDoc);
	 SetColumnData("OrderUserAdd",Row,TMP1OrderUserAdd);
	 SetColumnData("OrderMasterSeqNo",Row,TMP1OrderMasterSeqNo);
	 SetColumnData("OrderUserDep",Row,TMP1OrderUserDep);
	 SetColumnData("OrderBillType",Row,TMP1OrderBillType);
	 SetColumnData("OrderStartDate",Row,TMP1OrderStartDate);
	 SetColumnData("OrderStartTime",Row,TMP1OrderStartTime);
	 SetColumnData("OrderPriorRowid",Row,TMP1OrderPriorRowid);
	 SetColumnData("OrderInstrRowid",Row,TMP1OrderInstrRowid);
	 SetColumnData("OrderDurRowid",Row,TMP1OrderDurRowid);
	 SetColumnData("OrderPackUOMRowid",Row,TMP1OrderPackUOMRowid);
	 SetColumnData("OrderRecDepRowid",Row,TMP1OrderRecDepRowid);
	 SetColumnData("OrderStatusRowid",Row,TMP1OrderStatusRowid);
	 SetColumnData("OrderBaseUOMRowid",Row,TMP1OrderBaseUOMRowid);
	 SetColumnData("OrderDocRowid",Row,TMP1OrderDocRowid);
	 SetColumnData("OrderUserAddRowid",Row,TMP1OrderUserAddRowid);
	 SetColumnData("OrderLinkTo",Row,TMP1OrderLinkTo);
	 SetColumnData("OrderARCOSRowid",Row,TMP1OrderARCOSRowid);
	 SetColumnData("OrderDrugFormRowid",Row,TMP1OrderDrugFormRowid);
	 SetColumnData("OrderMaxDurRowid",Row,TMP1OrderMaxDurRowid);
	 SetColumnData("OrderType",Row,TMP1OrderType);
	 SetColumnData("OrderBillTypeRowid",Row,TMP1OrderBillTypeRowid);
	 SetColumnData("OrderSttDate",Row,TMP1OrderSttDate);
	 SetColumnData("OrderPHForm",Row,TMP1OrderPHForm);
	 SetColumnData("OrderConFac",Row,TMP1OrderConFac);
	 SetColumnData("OrderARCIMRowid",Row,TMP1OrderARCIMRowid);
	 SetColumnData("OrderPHPrescType",Row,TMP1OrderPHPrescType);
	 SetColumnData("OrderItemRowid",Row,TMP1OrderItemRowid);
	 SetColumnData("OrderFreqFactor",Row,TMP1OrderFreqFactor);
	 SetColumnData("OrderFreqInterval",Row,TMP1OrderFreqInterval);
	 SetColumnData("OrderDurFactor",Row,TMP1OrderDurFactor);
	 SetColumnData("OrderDoseUOMRowid",Row,TMP1OrderDoseUOMRowid);
	 SetColumnData("OrderFreqRowid",Row,TMP1OrderFreqRowid);
	 SetColumnData("OrderBaseQty",Row,TMP1OrderBaseQty);
	 SetColumnData("OrderPhSpecInstr",Row,TMP1OrderPhSpecInstr);
	 SetColumnData("OrderLabSpec",Row,TMP1OrderLabSpec);
	 SetColumnData("OrderAutoCalculate",Row,TMP1OrderAutoCalculate);
	 SetColumnData("OrderCoverMainIns",Row,TMP1OrderCoverMainIns);
	 SetColumnData("OrderAction",Row,TMP1OrderAction);
	 SetColumnData("OrderActionRowid",Row,TMP1OrderActionRowid);
	 SetColumnData("OrderMaxDurFactor",Row,TMP1OrderMaxDurFactor);
	 SetColumnData("OrderMaxQty",Row,TMP1OrderMaxQty);
	 SetColumnData("OrderFile1",Row,TMP1OrderFile1);
	 SetColumnData("OrderFile2",Row,TMP1OrderFile2);
	 SetColumnData("OrderFile3",Row,TMP1OrderFile3);
	 SetColumnData("OrderLabExCode",Row,TMP1OrderLabExCode);
	 SetColumnData("OrderEndDate",Row,TMP1OrderEndDate);
	 SetColumnData("OrderEndTime",Row,TMP1OrderEndTime);
	 SetColumnData("OrderOutPriorRecLocStr",Row,TMP1OrderOutPriorRecLocStr);
	 SetColumnData("OrderRecLocStr",Row,TMP1OrderRecLocStr);
	 SetColumnData("OrderLabSpecRowid",Row,TMP1OrderLabSpecRowid);
	 SetColumnData("OrderAlertStockQty",Row,TMP1OrderAlertStockQty);
	 SetColumnData("OrderHiddenPara",Row,TMP1OrderHiddenPara);
	 SetColumnData("OrderMultiDate",Row,TMP1OrderMultiDate);
	 SetColumnData("OrderFreqDispTimeStr",Row,TMP1OrderFreqDispTimeStr);
	 SetColumnData("OrderGenericName",Row,TMP1OrderGenericName);
	 SetColumnData("OrderInsurApproveType",Row,TMP1OrderInsurApproveType);
	 SetColumnData("OrderCPWStepItemRowId",Row,TMP1OrderCPWStepItemRowId);
	 SetColumnData("OrderMaterialBarCode",Row,TMP1OrderMaterialBarCode);
	 SetColumnData("OrderMaterialBarcodeHiden",Row,TMP1OrderMaterialBarcodeHiden);
	 SetColumnData("OrderLocalInfusionQty",Row,TMP1OrderLocalInfusionQty);

	 //SetColumnData("OrderSeqNo",Row,TMP1OrderSeqNo);
	 //移动关联医嘱的母液时?修改所有的子关联序号
  	var rows=objtbl.rows.length;
  	for(var i=0;i<rows;i++){
  		var OrderItemRowIdTMP=GetColumnData("OrderItemRowid",i);
  		var OrderSeqNoTMP=GetColumnData("OrderMasterSeqNo",i);
  		if(OrderItemRowIdTMP!="")continue;
  		if(OrderSeqNoTMP==TMP1OrderSeqNo){
  			SetColumnData("OrderMasterSeqNo",i,TMPOrderSeqNo);
  		}
  		if(OrderSeqNoTMP==TMPOrderSeqNo){
  		SetColumnData("OrderMasterSeqNo",i,TMP1OrderSeqNo);
  	  }
  	}
  	//end
	 objtbl.rows(Row+1).click();	
}
function DHCC_ClearAllList(obj) {
	if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}
function DHCC_ClearList(ListName){
	var obj=document.getElementById(ListName);
	if (obj){DHCC_ClearAllList(obj);}
}

function InsurSignSymptomLookUpSelect(value) {
	//dhcsys_alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusRowIndex);
	try {
		var SignSymptom=Split_Value[0];
		var SignSymptomCode=Split_Value[1];
		SetColumnData("OrderInsurSignSymptom",Row,SignSymptom);
		SetColumnData("OrderInsurSignSymptomCode",Row,SignSymptomCode);
	} catch(e) {};
}

function OrderInsurSignSymptom_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
  var Row=GetEventRow(e);
  var obj=websys_getSrcElement(e);
  //因为有可能点上一行的放大镜?这是FoucsRowIndex仍是当前行的值所以需要重新取一下
  var Rowobj=getRow(obj);
  if (Rowobj) {FocusRowIndex=Rowobj.rowIndex}
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var OrderARCIMRowid=websys_escape(GetColumnData("OrderARCIMRowid",Row));
		var OrderBillTypeRowid=websys_escape(GetColumnData("OrderBillTypeRowid",Row));
		var OrderInsurSignSymptomCode=websys_escape(GetColumnData("OrderInsurSignSymptomCode",Row));
		//var OrderInsurSignSymptomCode=GetColumnData("OrderInsurSignSymptomCode",Row);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocArcimLinkInsurSignSymptom&ARCIMID="+OrderARCIMRowid+"&BillType="+OrderBillTypeRowid+"&SelectedCode="+OrderInsurSignSymptomCode;
  	var ret=window.showModalDialog(url,"适应症选择","dialogwidth:30em;dialogheight:30em;status:no;center:1;resizable:yes");
  	if (ret) {
  		OrderInsurSignSymptom=mPiece(ret,String.fromCharCode(1),1);
  		OrderInsurSignSymptomCode=mPiece(ret,String.fromCharCode(1),0);
			SetColumnData("OrderInsurSignSymptom",Row,OrderInsurSignSymptom);
			SetColumnData("OrderInsurSignSymptomCode",Row,OrderInsurSignSymptomCode);
  	}
		return websys_cancel();
	}
}

function FindInsurSignSymptom(InsurSignSymptomStr,CurrRow){
	var SelectedInsurSignSymptomStr="";
	if (EPDSYMCodeStr!=""){SelectedInsurSignSymptomStr=String.fromCharCode(2)+EPDSYMCodeStr+String.fromCharCode(2)}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');

	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderInsurSignSymptomCode=GetColumnData("OrderInsurSignSymptomCode",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderInsurSignSymptomCode!="")&&(Row!=CurrRow)){
			if (SelectedInsurSignSymptomStr!=""){
				var CodeArr=OrderInsurSignSymptomCode.split(String.fromCharCode(2));
				for (var j=0;j<CodeArr.length;j++) {
					var Code="^"+CodeArr[j]+"^";
					if (SelectedInsurSignSymptomStr.indexOf(Code)==-1){
						SelectedInsurSignSymptomStr=SelectedInsurSignSymptomStr+CodeArr[j]+"^";
					}
				}
			}else{
				SelectedInsurSignSymptomStr="^"+OrderInsurSignSymptomCode+"^";
			}
		}
	}

	if (SelectedInsurSignSymptomStr!=""){
		var ary=InsurSignSymptomStr.split("^");
		for (i=0;i<ary.length;i++) {
			var Code="^"+ary[i]+"^";
			if (SelectedInsurSignSymptomStr.indexOf(Code)!=-1){
				return ary[i];
			}
		}
	}
	return "";
}

function GetInsurSignSymptom(){
	var SelectedInsurSignSymptomStr="";
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderInsurSignSymptomCode=GetColumnData("OrderInsurSignSymptomCode",Row);
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderInsurSignSymptomCode!="")){
			if (SelectedInsurSignSymptomStr!=""){
				var CodeArr=OrderInsurSignSymptomCode.split(String.fromCharCode(2));
				for (j=0;j<CodeArr.length;j++) {
					var Code=String.fromCharCode(2)+CodeArr[j]+String.fromCharCode(2);
					var CodeStr=String.fromCharCode(2)+SelectedInsurSignSymptomStr+String.fromCharCode(2);
					if (CodeStr.indexOf(Code)==-1){
						SelectedInsurSignSymptomStr=SelectedInsurSignSymptomStr+String.fromCharCode(2)+CodeArr[i];
					}
				}
			}else{
				SelectedInsurSignSymptomStr=OrderInsurSignSymptomCode;
			}
		}
	}

	return SelectedInsurSignSymptomStr;
}

function CheckPriorAllowRange(OrderPriorRowid,OrderARCIMRowid){
	if (CheckPriorAllowRangeMethod!=""){
		//dhcsys_alert(OrderPriorRowid+","+OrderARCIMRowid)
		var ret=cspRunServerMethod(CheckPriorAllowRangeMethod,OrderPriorRowid,OrderARCIMRowid);
		if (parseFloat(ret)>=1) return false;
	}	
	return true;
}
function CheckPriorAllowSum(EpisodeID,OrderPriorRowid,OrderARCIMRowid){
	if (PAAdmType=="I") {return true}
	//如果按用法分方，就只能在保存时判断，因为在录入过程中有可能改变用法
	if (PrescByInstr==1){return true}
	if (PrescByAuto==1){return true}
	var PrescBillTypeRowid=GetPrescBillTypeID();
	var PrescCount=0;
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
		var OrderType=GetColumnData("OrderType",Row);
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		if (HospitalCode!="SZZYY"){
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")&&(OrderPHPrescType==PHPrescType)&&(OrderBillTypeRowid==PrescBillTypeRowid)){
				if (HospitalCode!="JST"){
					if (OrderMasterSeqNo==""){PrescCount=PrescCount+1;}
				}else{
					PrescCount=PrescCount+1;
				}
			}
		}else{
		  if ((OrderItemRowid=="")&&(Trim(OrderMasterSeqNo)=="")&&(OrderARCIMRowid!="")&&(OrderType=="R")){
				PrescCount=PrescCount+1;
		  }
		}
	}
	
}

///找手术ID  add by guorongyong
function GetAnaesthesiaID(){
	var AnaesthesiaID="";
	//var win=top.frames['eprmenu'];
  //if (win) {
	    //var frm = win.document.forms['fEPRMENU'];
		//modify by wuqk 2010-07-02 for ext framework
		//var frm=top.document.forms['fEPRMENU'];
		//modify by zzq 2010.08.31
			var frm=dhcsys_getmenuform();
      if (frm) {
      	AnaesthesiaID=frm.AnaesthesiaID.value;
      }
  //}
  return AnaesthesiaID;
}

///用于追加到已经保存过样本上    add by zhouzq
function OrderLabEpisodeNo_lookuphandler(e) {
	if (evtName=='OrderLabEpisodeNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
  var Row=GetEventRow(e);
  var obj=websys_getSrcElement(e);
  //因为有可能点上一行的放大镜?这是FoucsRowIndex仍是当前行的值所以需要重新取一下
  var Rowobj=getRow(obj);
  if (Rowobj) {FocusRowIndex=Rowobj.rowIndex}
  ShowOrderLabEpisodeNo=0;
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==0))) {

		var url='websys.lookup.csp';
		url += "?ID=d157iOrderLabEpisodeNo";
		url += "&CONTEXT=Kweb.DHCOEOrdItem:FindOrderLabEpisode";
		url += "&TLUJSF=OrderLabEpisodeNoLookUpSelect";
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P1=" + websys_escape(obj.value);

		ShowOrderLabEpisodeNo=1;
		websys_lu(url,1,'');
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==13)&&(KeyEnterChangeFocus==1)){
				websys_setfocus("OrderDurz"+Row);
		}
	}
}

function OrderLabEpisodeNoLookUpSelect(value) {
	//dhcsys_alert(value);
	var Split_Value=value.split("^");
	var Row=GetRow(FocusRowIndex);
	try {
		var OrderLabEpisodeNo=unescape(Split_Value[0]);
		var obj=document.getElementById('OrderLabEpisodeNoz'+Row);
		if (obj) {
  			obj.value=OrderLabEpisodeNo;
		  	obj.className='';
		}
	} catch(e) {};
}

var obj=document.getElementById('AddPathWayItem');
if (obj) obj.onclick=AddPathWayItem_click;

function AddPathWayItem_click() {
	//dhcsys_alert(EpisodeID);
	if (AddMRCPWItemToListMethod!=''){
		var SubCatID=cspRunServerMethod(AddMRCPWItemToListMethod,'AddCopyItemToList','',EpisodeID);
		return websys_cancel();;
	}
}

function DHCC_ChangeRowEnable(ColumnName,Row,enable){
	var obj=document.getElementById(ColumnName+'z'+Row);
	if (obj) obj.disabled=enable;
	var obj=document.getElementById('ldi'+ColumnName+'z'+Row);
	if (obj) obj.disabled=enable;
}

///通过设置保存时判断主子医嘱某些属性是否一致,虽然关联时会有校验但还会存在修改子医嘱的问题
function CheckGroupItem(CurrentRow){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	var CurrentOrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",CurrentRow);
	if (CurrentOrderMasterSeqNo=='') return true;
	
	var CurrentOrderRecDepRowid=GetColumnData("OrderRecDepRowid",CurrentRow);
	var CurrentOrderFreqRowid=GetColumnData("OrderFreqRowid",CurrentRow);
	var CurrentOrderDurRowid=GetColumnData("OrderDurRowid",CurrentRow);
	var CurrentOrderInstrRowid=GetColumnData("OrderInstrRowid",CurrentRow);
	var CurrentOrderStartTime=GetColumnData("OrderStartTime",CurrentRow);	
	
	for (var i=1; i<rows; i++){
		var Row=GetRow(i);
		var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
		/*
		var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
		var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);
		*/
		var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
		var OrderStartTime=GetColumnData("OrderStartTime",Row);
		
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderSeqNo==CurrentOrderMasterSeqNo)){
			var OrderName=GetColumnData("OrderName",Row);
			if ((OrderRecDepRowid!=CurrentOrderRecDepRowid)&&(CFSameRecDepForGroup==1)){
				dhcsys_alert(OrderName+t['SubOrderRecDepNotMatch']);
				return false;
			}
			
			if (OrderFreqRowid!=CurrentOrderFreqRowid){
				dhcsys_alert(OrderName+t['SubOrderFreqNotMatch']);
				return false;
			}
			if (OrderStartTime!=CurrentOrderStartTime){
				dhcsys_alert(OrderName+t['SubOrderStartTimeNotMatch']);
				return false;
			}
			/*
			if (OrderDurRowid!=OrderDurRowid){
			}
			if (OrderInstrRowid!=CurrentOrderInstrRowid){
			}
			*/
		}
	}
	return true;
}

function VerifiedOrderItemLookupSelect(txt){
	var adata=txt.split("^");
	VerifiedOrderMasterRowid=adata[1];
	VerifiedOrderMasterSeqNo=adata[2];
	if (VerifiedOrderMasterSeqNo.lastIndexOf(".")!=-1){
		dhcsys_alert(t['VerifiedMasterError']);
		VerifiedOrderMasterRowid="";
		VerifiedOrderMasterSeqNo="";
		document.getElementById("VerifiedOrderItems").value="";
		return;
	}
	VerifiedOrderPriorRowid=adata[3];
	VerifiedOrderFreFactor=adata[8];
	VerifiedOrderFreDesc1=adata[9];
	VerifiedOrderFreRowId=adata[10];
	LinkToVerifiedOrder(VerifiedOrderFreFactor,VerifiedOrderFreDesc1,VerifiedOrderFreRowId);
}

function LinkToVerifiedOrder(OrderFreFactor,OrderFreDesc1,OrderFreRowId){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var RowObj=objtbl.rows[i];
		Row=GetRow(i);
		for (var j=0;j<RowObj.cells.length;j++) {
      if (!RowObj.cells[j].firstChild) {continue} 
		  var Id=RowObj.cells[j].firstChild.id;
			var arrId=Id.split("z");
		  var objwidth=RowObj.cells[j].style.width;
		  var objheight=RowObj.cells[j].style.height;
   
			if (arrId[0]=="OrderMasterSeqNo"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderFreq"){
					var str="<label id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
          RowObj.cells[j].innerHTML=str;
			}
			if (arrId[0]=="OrderPrior"){
				obj=RowObj.cells[j].firstChild;
        obj.disabled=true;
			}
		}
		var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row)
		var OrderType=GetColumnData("OrderType",Row)
		SetColumnData("OrderPrior",Row,VerifiedOrderPriorRowid);
		SetColumnData("OrderPriorRowid",Row,VerifiedOrderPriorRowid);
		if ((OrderType=="R")||((OrderPHPrescType=="4")&&(OrderType!="R"))){
			SetColumnData("OrderFreq",Row,OrderFreDesc1);
			SetColumnData("OrderFreqFactor",Row,OrderFreFactor);
			SetColumnData("OrderFreqRowid",Row,OrderFreRowId);
			SetPackQty(Row);
		}
	}
}

function VerifiedOrderItemOnKeydown(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==8){
		VerifiedOrderMasterRowid="";
		VerifiedOrderMasterSeqNo="";
		var obj=document.getElementById("VerifiedOrderItems");
		obj.value="";
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var RowObj=objtbl.rows[i];
			Row=GetRow(i);
			var OrderPHPrescType=GetColumnData("OrderPHPrescType",Row)
			var OrderType=GetColumnData("OrderType",Row)
			for (var j=0;j<RowObj.cells.length;j++) {
	      if (!RowObj.cells[j].firstChild) {continue} 
			  var Id=RowObj.cells[j].firstChild.id;
				var arrId=Id.split("z");
			  var objwidth=RowObj.cells[j].style.width;
			  var objheight=RowObj.cells[j].style.height;
		  	var IMGId="ldi"+Id;
	   
				if (arrId[0]=="OrderMasterSeqNo"){
						var str="<input id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
	          RowObj.cells[j].innerHTML=str;
				}
				if (arrId[0]=="OrderPrior"){
					obj=RowObj.cells[j].firstChild;
          obj.disabled=false;
				}
				if (arrId[0]=="OrderFreq"){
					if ((OrderType=="R")||((OrderPHPrescType=="4")&&(OrderType!="R"))){
						objwidth=AdjustWidth(objwidth);
						var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"PHCFRDesc_lookuphandler()\" onchange=\"FrequencyChangeHandler()\">";
						str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"PHCFRDesc_lookuphandler()\">";
	          RowObj.cells[j].innerHTML=str;
	        }
				}
			}
			SetColumnData("OrderPackQty",Row,1);
		}
	}
}

//设置临时数组用以比较是否输入有改变,决定是否弹出下拉窗口
function SetOrderRowAry(Row,ColumnName,ColumnValue){    
	if (OrderRowAry[Row]==undefined) OrderRowAry[Row]=new Array();
	OrderRowAry[Row][ColumnName]=ColumnValue;
}

function FreqNextFocus(Row) {
	var OrderInstrObj=document.getElementById("OrderInstrz"+Row);
	var OrderDurObj=document.getElementById("OrderDurz"+Row);
  var OrderPackQtyObj=document.getElementById("OrderPackQtyz"+Row);
  var OrderStartDateObj=document.getElementById("OrderStartDatez"+Row);
 
  /* //频次未改变的情况,默认跳转到医嘱类型
  if (OrderStartDateObj&&(OrderStartDateObj.type=="text")){
  	websys_setfocus("OrderPriorz"+Row);
  	return websys_cancel();
  }
  */
  if (OrderInstrObj&&(OrderInstrObj.type=="text")){
  	websys_setfocus("OrderInstrz"+Row);
	}else if (OrderDurObj&&(OrderDurObj.type=="text")){
		websys_setfocus("OrderDurz"+Row);
	}else if (OrderPackQtyObj&&(OrderPackQtyObj.type=="text")){
		websys_setfocus("OrderPackQtyz"+Row);
	}	
}

function DHCC_GetElementData(ElementName){
	var obj=document.getElementById(ElementName);
	if (obj){
		if (obj.tagName=='LABEL'){
			return obj.innerText
		}else{
			if (obj.type=='checkbox') return obj.checked;
			return obj.value
		}
	}
	return "";
}

//检验录入页
function LnkLabPage_Click(){
	var lnk = "dhcdocoeorder.csp";
	//var ret=window.open(lnk,"dhcdocoeorder","dialogwidth:70;dialogheight:60;status:no;center:1;resizable:yes");
	var ret=window.showModalDialog(lnk,"dhcdocoeorder","dialogwidth:70;dialogheight:60;status:no;center:1;resizable:yes");
	//dhcsys_alert(ret);
	PACSArcimFun(ret);
}

//提供给检查选择窗口回调函数
function PACSArcimFun(str){
	if(str=='')return;
 	var strArray=str.split('^');
 	for(var i=0;i<strArray.length;i++){
		var Para="";
		var OrderLabSpecRowid="";
		var Arr=strArray[i].split(String.fromCharCode(1))
		var icode=Arr[0];
		if (Arr.length==2) OrderLabSpecRowid=Arr[1];

		AddClickHandler();
		//var ret=AddBCToList(FocusRowIndex,icode,Para,""); //??是否要修改
		var ret=AddItemToList(FocusRowIndex,icode,Para,"","");
		var Row=GetRow(FocusRowIndex);
		//如果非检查的医嘱要进行诊断验证
		var objtab=document.getElementById("tUDHCOEOrder_List_Custom");
		var OrderType=GetColumnData("OrderType",Row);
		if (!CheckDiagnose(OrderType)){DeleteTabRow(objtab,Row); return false;}
		
		if (OrderLabSpecRowid!="") {
			SetColumnData("OrderLabSpecRowid",Row,OrderLabSpecRowid);
		  SetColumnData("OrderLabSpec",Row,OrderLabSpecRowid);
		}
 	}
 	SetScreenSum();
}

function SetSaveForUserClickHandler(){
	var eSrc = window.event.srcElement;
	if (eSrc) {
		if (FocusRowIndex < 1) {dhcsys_alert("请选择行!");return websys_cancel();}
		//添加到常用医嘱
		var Row=GetRow(FocusRowIndex);
		var OrderType=GetColumnData("OrderType",Row);
	  if (OrderType!="R") {dhcsys_alert("只允许添加药品!");return websys_cancel();}
	  	
		var Ret=OtherMenuUpdate("User",session["LOGON.USERID"],Row);
	}
	
	return websys_cancel();
}
function SetSaveForLocationClickHandler(){
	var eSrc = window.event.srcElement;
	if (eSrc) {
		if (FocusRowIndex < 1) {dhcsys_alert("请选择行!");return websys_cancel();}
		//添加到常用医嘱
		var Row=GetRow(FocusRowIndex);
		var Ret=OtherMenuUpdate("Location",session["LOGON.CTLOCID"],Row);
	}
	
	return websys_cancel();
}
function OtherMenuUpdate(ContralType,ContralKey,Row){
	try {
		var ContralStr="";
		ContralStr=GetContralStr(ContralType,ContralKey,Row);
		if (ContralStr=="") return "";
		/*
		var GroupContralStr="";
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var LoopRow=GetRow(i);
			var LoopMasterSeqNo=GetColumnData("OrderMasterSeqNo",LoopRow);
			var LoopItemRowid=GetColumnData("OrderItemRowid",LoopRow);
			var LoopARCIMRowid=GetColumnData("OrderARCIMRowid",LoopRow);
			if (LoopRow==Row) continue;
			//找主医嘱和其他子医嘱
			if (((OrderMasterSeqNo!="")&&(LoopMasterSeqNo=OrderMasterSeqNo))||(LoopMasterSeqNo==OrderSeqNo)){
				if (GroupContralStr=="") {
					GroupContralStr=GetContralStr(ContralType,ContralKey,LoopRow);
				}else{
					GroupContralStr=GroupContralStr+String.fromCharCode(1)+GetContralStr(ContralType,ContralKey,LoopRow);
				}
			}
		}
		if (GroupContralStr!="") {
			var conFlag=dhcsys_confirm("是否增加整组医嘱?");
			if (conFlag==true) ContralStr=ContralStr+String.fromCharCode(1)+GroupContralStr;
		}
		*/
		var UserID=session["LOGON.USERID"];
		var ret=cspRunServerMethod(SaveItemDefaultMethod,ContralStr,UserID);
		var TempArr=ret.split("^");
		if (TempArr[0]=='0') {dhcsys_alert("保存成功!")}
		else if (TempArr[0]=='-100') {}
		else if (TempArr[0]=='-101') {}
		else {}
		
	}catch(e){dhcsys_alert(e.message)}

	return ret
}

function GetContralStr(ContralType,ContralKey,Row){
	var OrderName=GetColumnData("OrderName",Row);
	var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	var OrderType=GetColumnData("OrderType",Row);
	var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	var OrderFreqRowid=GetColumnData("OrderFreqRowid",Row);
	var OrderFreq=GetColumnData("OrderFreq",Row);
	var OrderFreqFactor=GetColumnData("OrderFreqFactor",Row);
	var OrderDurRowid=GetColumnData("OrderDurRowid",Row);
	var OrderDur=GetColumnData("OrderDur",Row);
	var OrderDurFactor=GetColumnData("OrderDurFactor",Row);
	var OrderInstrRowid=GetColumnData("OrderInstrRowid",Row);	
	var OrderInstr=GetColumnData("OrderInstr",Row);	
	var OrderDoseQty=GetColumnData("OrderDoseQty",Row);	
	var OrderDoseUOMRowid=GetColumnData("OrderDoseUOMRowid",Row);
	var OrderDoseUOM=GetColumnData("OrderDoseUOM",Row);

	var OrderPackQty=GetColumnData("OrderPackQty",Row);
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
	var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	var PHPrescType=GetColumnData("OrderPHPrescType",Row);
	var OrderConFac=GetColumnData("OrderConFac",Row);
	var OrderBaseQty=GetColumnData("OrderBaseQty",Row);
	var OrderPrice=GetColumnData("OrderPrice",Row);
	var OrderStartDate=GetColumnData("OrderStartDate",Row);
	var OrderPHForm=GetColumnData("OrderPHForm",Row);
	var OrderItemSum=GetColumnData("OrderSum",Row);	    
	var OrderEndDate=GetColumnData("OrderEndDate",Row);	  
	var OrderAlertStockQty=GetColumnData("OrderAlertStockQty",Row); 
	var OrderBillTypeRowid=GetColumnData("OrderBillTypeRowid",Row);
	var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
	var OrderPackUOM=GetColumnData("OrderPackUOM",Row);
	var OrderFirstDayTimes=GetColumnData("OrderFirstDayTimes",Row);
	var OrderSkinTest=GetColumnData("OrderSkinTest",Row);
	if (OrderSkinTest==false){OrderSkinTest="N"}else{OrderSkinTest="Y"}
	var OrderActionRowid=GetColumnData("OrderActionRowid",Row);
	var OrderAction=GetColumnData("OrderAction",Row);
	var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
	var OrderItemCatRowid=mPiece(OrderHiddenPara,String.fromCharCode(1),2);
	var Notes="";
	
	//审查判断
	if (OrderARCIMRowid==""){
		dhcsys_alert(t["NoItem"])
		return "";
	}
	if (ContralKey==""){
		dhcsys_alert(t["NoContralType"])
		return "";
	}
	OrderMasterSeqNo=OrderMasterSeqNo.replace(/(^\s*)|(\s*$)/g,'');
	var ContralStr=OrderARCIMRowid+"^"+ContralType+"^"+ContralKey+"^"+OrderPriorRowid+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid;
	ContralStr=ContralStr+"^"+OrderInstrRowid+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderPackQty+"^"+OrderSkinTest;
	ContralStr=ContralStr+"^"+OrderActionRowid+"^"+OrderMasterSeqNo+"^"+OrderSeqNo+"^"+Notes+"^"+PAAdmType;
	return ContralStr;
}

function GetItemDefaultRowId(icode) {
	//选择医嘱自定义常用用法
	var userid=session["LOGON.USERID"];
	var ItemDefaultRowId="";
	if (GetUserItemDefaultSingleMethod!="") {
		var ItemDefaultRowIds=cspRunServerMethod(GetUserItemDefaultSingleMethod,icode,userid,PAAdmType);
		if (ItemDefaultRowIds!="") {
			var arr=ItemDefaultRowIds.split("^");
			if (arr.length>1) {
				var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocItemDefaultOrder&OrderRowid="+icode+"&UserID="+userid;
				var ItemDefaultRowId=window.showModalDialog(lnk,"","dialogwidth:50em;dialogheight:20em;center:1");
				if (ItemDefaultRowId==undefined) ItemDefaultRowId="";
				// 返回值是(^DHCDID(Rowid))的Rowid 
				//win=open(lnk,"","status=1,scrollbars=1,resizable=1,top=100,left=100,width=1000,height=520");		
			}else{
				ItemDefaultRowId=arr[0];
			}
		}
	}
	return ItemDefaultRowId;
}

function GetSessionStr(){
	var Str="";
	Str=session['LOGON.USERID'];
	Str+="^"+session['LOGON.GROUPID'];
	Str+="^"+session['LOGON.CTLOCID'];
	Str+="^"+session['LOGON.HOSPID'];
	Str+="^"+session['LOGON.WARDID'];
	Str+="^"+session['LOGON.LANGID'];
	return Str;
}

//个人模板或者科室模板r
function OEPrefClickHandler(e){
	currTab=1;
	
	ClearAllGroup();
	var obj=websys_getSrcElement(e);
	if (obj.id=='OEPrefUser') {
		obj.style.cssText="PADDING: 3px;MARGIN: 3px;COLOR: yellow;BACKGROUND-COLOR: #336699;BORDER: 2px outset #336699;FONT-WEIGHT: bold;cursor: hand;";
	  	var obj=document.getElementById("OEPrefLoc");
		if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;BACKGROUND-COLOR: #cfcfff;BORDER: 1px outset #cfcfff;cursor: hand;";
		var obj=document.getElementById("OEPrefHosp");
		if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;BACKGROUND-COLOR: #cfcfff;BORDER: 1px outset #cfcfff;cursor: hand;";
		var OrderType="User.SSUser";
	}else if (obj.id=='OEPrefLoc') {
		obj.style.cssText="PADDING: 3px;MARGIN: 3px;COLOR: yellow;BACKGROUND-COLOR: #336699;BORDER: 2px outset #336699;FONT-WEIGHT: bold;cursor: hand;";
	  	var obj=document.getElementById("OEPrefUser");
		if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;BACKGROUND-COLOR: #cfcfff;BORDER: 1px outset #cfcfff;cursor: hand;";
		var obj=document.getElementById("OEPrefHosp");
		if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;BACKGROUND-COLOR: #cfcfff;BORDER: 1px outset #cfcfff;cursor: hand;";
		var OrderType="User.CTLoc";
  	}else if (obj.id=='OEPrefHosp') {
		obj.style.cssText="PADDING: 3px;MARGIN: 3px;COLOR: yellow;BACKGROUND-COLOR: #336699;BORDER: 2px outset #336699;FONT-WEIGHT: bold;cursor: hand;";
	  	var obj=document.getElementById("OEPrefLoc");
		if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;BACKGROUND-COLOR: #cfcfff;BORDER: 1px outset #cfcfff;cursor: hand;";
	  	var obj=document.getElementById("OEPrefUser");
		if (obj)obj.style.cssText="PADDING: 3px;MARGIN: 3px;BACKGROUND-COLOR: #cfcfff;BORDER: 1px outset #cfcfff;cursor: hand;";
		var OrderType="User.CTHospital";
  	}

	if (FocusWindowName=="") lnkFav="oeorder.entry.redrawprefs.csp?EpisodeID="+EpisodeID+"&CTLOC="+escapedCTLOC+"&XCONTEXT="+session["CONTEXT"]+"&OEWIN="+window.name+"&ObjectType="+OrderType;
	else lnkFav="oeorder.entry.redrawprefs.csp?EpisodeID="+EpisodeID+"&CTLOC="+escapedCTLOC+"&FocusWindowName="+FocusWindowName+"&XCONTEXT="+session["CONTEXT"]+"&OEWIN="+window.name;
	
	if (RepeatOrdersFromEPR=="") websys_createWindow(lnkFav+'&PREFTAB=1','TRAK_hidden');
	
	return ;
}

function ClearAllGroup() {
	//Deselects all listboxes
	var obj=document.getElementById("ngroup1");
  if (obj) obj.innerHTML="";
	var obj=document.getElementById("ngroup2");
  if (obj) obj.innerHTML="";
	var obj=document.getElementById("ngroup3");
  if (obj) obj.innerHTML="";
	var obj=document.getElementById("ngroup4");
  if (obj) obj.innerHTML="";
	var obj=document.getElementById("ngroup5");
  if (obj) obj.innerHTML="";
  
	if (lstGroup1) ClearAllList(lstGroup1);
	if (lstGroup2) ClearAllList(lstGroup2);
	if (lstGroup3) ClearAllList(lstGroup3);
	if (lstGroup4) ClearAllList(lstGroup4);
	if (lstGroup5) ClearAllList(lstGroup5);
}

function ReSetOrderPriorRowid(OrderPriorRowid,OrderPriorRemarks) {
	switch (OrderPriorRemarks){
		case "PRN":
			OrderPriorRowid=PRNOrderPriorRowid;
			break;
		case "ONE":
			OrderPriorRowid=OneOrderPriorRowid;
			break;
		case "OM":
			if (OrderPriorRowid==ShortOrderPriorRowid) {
				OrderPriorRowid=OMOrderPriorRowid;
			}else{
				OrderPriorRowid=OMSOrderPriorRowid;
			}
			break;
		case "OUT":
			OrderPriorRowid=OutOrderPriorRowid;
			break;
		default:
	}
	return OrderPriorRowid;
}

function BtnPrtGuidPat_Click(){
	//打印导诊单 只打印单次审核
	  var obj=document.getElementById('EpisodeID');
		  if(obj)
		  {	var PAADMRowid=obj.value;
		    //通过adm获取就诊信息(未收费)
				var ordInfo=tkMakeServerCall("web.DHCDocService","GetDirectInfo",PAADMRowid,"N","1",session['LOGON.USERID'],"");
				dhcsys_alert(ordInfo);
				var obj=document.getElementById('PrintOrdDirect');
				if(obj){obj.PrintOrdDir(ordInfo,"协和门诊就诊明细单","daozhendan")}
			}	
}
function BtnRePrtGuidPat_Click(){
	//补打导诊单 全部打印
	  var obj=document.getElementById('EpisodeID');
		  if(obj)
		  {	var PAADMRowid=obj.value;
		    //通过adm获取就诊信息(未收费)
				var ordInfo=tkMakeServerCall("web.DHCDocService","GetDirectInfo",PAADMRowid,"N","",session['LOGON.USERID'],"");
				//dhcsys_alert(ordInfo);
				var obj=document.getElementById('PrintOrdDirect');
				if(obj){obj.PrintOrdDir(ordInfo,"协和门诊就诊明细单","daozhendan")}
			}	
}

//查看，模糊查询医嘱项目
function BtnViewArcItemInfoHandler(){
	//if (FocusRowIndex<1) return;
	//var Row=GetRow(FocusRowIndex);	

	//window.parent.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc_Phamacy_Detail&PHCId="+f_OrderARCIMRowid;
	//window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFArcimPrice","","dialogwidth:800px;dialogheight:500px;status:no;center:1;resizable:yes");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFArcimPrice1";
	var NewWin=open(lnk,"UDHCJFArcimPrice1","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
}

///lxz 对于附加说明检查独立成一个方法
function CheckOrderPriorRemarks(Row)
{
	var PriorRowid="";
	//----------------------6-9---------------------------
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	
	var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",Row); 
	if (OrderPriorRemarks!="OM"){SetColumnData("OrderBySelfOMFlag",Row,false);}
	if (OrderPriorRemarks=="ONE"){
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
	 	if ((OrderMasterSeqNo!="")&&(OrderPriorRowid!=ShortOrderPriorRowid)) {
	 		dhcsys_alert("关联医嘱,不允许选择取药医嘱");
	 		SetColumnData("OrderPriorRemarks",Row,"");
	 		return websys_cancel();
	 	
		 	//取药医嘱暂时不给予关联。
		 	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		 	for (i=1;i<=rows;i++){
		 		var RowGet=GetRow(i);
		 		var MasterOrderSeqNo=GetColumnData("OrderMasterSeqNo",RowGet);
		 		if ((MasterOrderSeqNo!="")&&(OrderSeqNo==MasterOrderSeqNo)) {
		 			dhcsys_alert("关联医嘱,不允许选择取药医嘱");
		 			SetColumnData("OrderPriorRemarks",RowGet,"");
		 			return websys_cancel();
				}
			}
		}
		//非药品医嘱不能选择取药医嘱
		var OrderType=GetColumnData("OrderType",Row); 
		if (OrderType!="R") {
			dhcsys_alert("非药品医嘱,不允许选择取药医嘱");
			SetColumnData("OrderPriorRemarks",Row,"");
			return websys_cancel();
		}
	}
	
	switch (OrderPriorRemarks){
		case "ONE":
			PriorRowid=ShortOrderPriorRowid;
			break;
		default:
	}
	var OldPriorRowid=GetColumnData("OrderPriorRowid",Row);
	if (PriorRowid=="") PriorRowid=OldPriorRowid;
	SetColumnData("OrderPrior",Row,PriorRowid);
	OrderPriorchangeCommon(OldPriorRowid,PriorRowid,Row);
}

function OrderPriorRemarkschangehandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	var selIndex=obj.selectedIndex;
	var PriorRowid="";
	//----------------------6-9---------------------------
	CheckOrderPriorRemarks(Row)
}
function OEORIDat_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	var CellObj=document.getElementById("OrderDatez"+Row);
  if (CellObj.disabled) return websys_cancel();
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var objid='OrderDatez'+Row;
		var obj=document.getElementById(objid);
		if (!IsValidDate(obj)) return;
		//因为弹出的时间选择窗口会调用与传入的ID_lookupSelect的方法?所以如果这时不能传入当前对象的的ID?否则会找不到相应的方法
		var url='websys.lookupdate.csp?ID=OEORIDat&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

function OEORIDat_lookupSelect(dateval) {
	var Row=GetRow(FocusRowIndex);
	var obj=document.getElementById('OrderDatez'+Row);
	obj.value=dateval;
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row); 
  ChangeLinkOrderDate(OrderSeqNo,obj.value);
	SetFocusColumn("OrderTime",Row);
	//websys_nexttab('4',obj.form);
}

function ChangeLinkOrderDate(OrderSeqNo,OrderDate){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderDate",Row,OrderDate);
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function OEORIDat_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return  websys_cancel();
	} else {
		eSrc.className='';
		SetFocusColumn("OrderTime",Row);
	}
}

function OEORITim_changehandler(e) {
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		var OrderTime=GetColumnData("OrderTime",Row);
		ChangeLinkOrderTime(OrderSeqNo,OrderTime)

		SetFocusColumn("OrderName",Row);
		eSrc.className='';
	}
}

function ChangeLinkOrderTime(OrderSeqNo,OrderTime){
  try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderTime",Row,OrderTime);
			}
		}
	}catch(e){dhcsys_alert(e.message)}	
}

function OrderNeedPIVAFlagChangehandler(E){
	try{
	  var CurrentRow=GetEventRow(e);
	  var OrderSeqNo=GetColumnData("OrderSeqNo",CurrentRow);
	  var OrderNeedPIVAFlag=GetColumnData("OrderNeedPIVAFlag",CurrentRow);
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=GetRow(i);
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",Row);
			var OrderItemRowid=GetColumnData("OrderItemRowid",Row);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
			var OrderType=GetColumnData("OrderType",Row);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderMasterSeqNo==OrderSeqNo)){
				SetColumnData("OrderNeedPIVAFlag",Row,OrderNeedPIVAFlag);
			}
		}
	}catch(e){dhcsys_alert(e.message)}
}


// 6.9  版本调用方法
function CheckDoctorTypePoison(PoisonRowId,ArcimRowid,Row,OrderPoisonCode){
	if (PoisonRowId=='') return true;
	var obj=document.getElementById('EpisodeID');
	var PAADMRowid=obj.value;
	var Arr=DoctorTypePoisonStr.split("^");
	for (j=0;j<Arr.length;j++) {
		var TypePoisonRowId=mPiece(Arr[j],String.fromCharCode(1),0);
		var TypeControl=mPiece(Arr[j],String.fromCharCode(1),1);
		if (PoisonRowId==TypePoisonRowId){
			if (TypeControl=='F'){
				if (HospitalCode=="ZGYKDFSYY"){
					var EmergencyPoisonFlag=ConfirmEmergencyPoison();
		  			if (EmergencyPoisonFlag){
		  				SetAntibioticRowid(9999999999);
		  				return true;	
		  			}else{
		  				dhcsys_alert(t['PoisonClassIsFobidden']);
						return false;
		  			}	
				}else{
					dhcsys_alert(t['PoisonClassIsFobidden']);
					return false;
				}
			}
			if (TypeControl=='A'){
			var ret=dhcsys_confirm((t['PoisonClassNeedConfirm']),false);
			return ret;
			}
	  		if (TypeControl=='P'){
	  			if (HospitalCode=="ZGYKDFSYY"){
		  			var EmergencyPoisonFlag=ConfirmEmergencyPoison();
		  			if (EmergencyPoisonFlag){
		  				SetAntibioticRowid(9999999999);
		  				return true;	
		  			}else{
		  				var ret=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocAntibioticApply&ArcimRowid="+ArcimRowid+"&EpisodeID="+PAADMRowid+"&TypeControl="+TypeControl,"","dialogwidth:60;dialogheight:40;status:yes;center:1;resizable:yes");
			  			//var ret=window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocAntibioticApply&ArcimRowid="+ArcimRowid+"&EpisodeID="+PAADMRowid,"","top:50;left:200;status:yes;center:1;width:900;height:600;resizable:yes");
							if ((ret=="")||(ret=="undefined")||(ret==null)) {
								return false;
							}else {
								SetAntibioticRowid(ret);
								return true;
							}
		  			}		
	  			}else{
	  				var ret=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocAntibioticApply&ArcimRowid="+ArcimRowid+"&EpisodeID="+PAADMRowid+"&TypeControl="+TypeControl,"","dialogwidth:60;dialogheight:40;status:yes;center:1;resizable:yes");
		  			//var ret=window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocAntibioticApply&ArcimRowid="+ArcimRowid+"&EpisodeID="+PAADMRowid,"","top:50;left:200;status:yes;center:1;width:900;height:600;resizable:yes");
						if ((ret=="")||(ret=="undefined")||(ret==null)) {
							return false;
						}else {
							SetAntibioticRowid(ret);
							return true;
						}
	  			}	
	  		}
	  		if (TypeControl=='S'){
				//SystemAddAntApply(OrderARCIMRowid);
				return true;
	  		}
	  		if (TypeControl==''){
				return true;
	  		}				
		}
	}
	/*
	dhcsys_alert(t['PoisonClassIsFobidden']);
	return false;
	*/
	return true;
}

// 7.0 抗菌药物调用方法
function CheckDoctorTypePoison_7(PoisonRowId,ArcimRowid,Row,OrderPoisonCode){
	if (PoisonRowId=='') return true;
	if (OrderPoisonCode.indexOf("KSS")<0)  return true;
	var obj=document.getElementById('EpisodeID');
	var PAADMRowid=obj.value;
	if (CheckAuditItem()) {return true;}
	var Checkret=0  //CheckSuscept(PAADMRowid,ArcimRowid)
	if (Checkret==1){
		var ret=dhcsys_confirm(("病人对于该药品有耐药反应，是否对患者继续开该药品"),false);
		if(!ret){return ret;}
		}
	//检查疗程之内的相同医嘱不在弹出登记表。
	var rtn=CheckInDurSameIM(ArcimRowid,Row);
	if (rtn==true){   return rtn ;}
	var Arr=DoctorTypePoisonStr.split("^");
	var ShowTabStr=""
	var OrderPoisonDesc=""
	if(OrderPoisonCode!=""){
		OrderPoisonDesc=cspRunServerMethod(GetPHCPoisonByCode,OrderPoisonCode)
	}
	var ReasonFlag=0
	for (j=0;j<Arr.length;j++) {
		var TypePoisonRowId=mPiece(Arr[j],String.fromCharCode(1),0);
		var TypeControl=mPiece(Arr[j],String.fromCharCode(1),1);
		if (PoisonRowId==TypePoisonRowId){
			ReasonFlag=1
			if (TypeControl=='F'){
				dhcsys_alert("该药品属于"+OrderPoisonDesc+"(管制分类)"+t['PoisonClassIsFobidden']);
				return false;
			}
			if (TypeControl=='A'){
				var ret=dhcsys_confirm(("该药品属于"+OrderPoisonDesc+"(管制分类)"+t['PoisonClassNeedConfirm']),false);
				if(!ret){return ret;}
  			
  			}
 
  		if (TypeControl=='P'){
  				dhcsys_alert("治疗类药品请送检")
  			  //var ret=window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocAntibioticApply&ArcimRowid="+ArcimRowid+"&EpisodeID="+PAADMRowid+"&TypeControl="+TypeControl,"","dialogwidth:60;dialogheight:40;status:yes;center:1;resizable:yes");
  				//var ret=window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCDocAntibioticApply&ArcimRowid="+ArcimRowid+"&EpisodeID="+PAADMRowid,"","top:50;left:200;status:yes;center:1;width:900;height:600;resizable:yes");
					if(OrderPoisonCode.indexOf("KSS3")>=0){   //(OrderPoisonCode=="KSS1")
						var obj=document.getElementById('EpisodeID');
						var PAADMRowid=obj.value;
						ShowTabStr="Apply,Consult"
						SetColumnData("ShowTabStr",Row,ShowTabStr);
						//var MainAnt=new AntMain(ShowTabStr,PAADMRowid,ArcimRowid,"","",OrderPoisonCode)
						//MainAnt.show()
				   }else{
					   	var obj=document.getElementById('EpisodeID');
						var PAADMRowid=obj.value;
						ShowTabStr="Apply";
						SetColumnData("ShowTabStr",Row,ShowTabStr);
				   }
				   var antMainUrl="dhcdocantimain.csp?ShowTabStr="+ShowTabStr+"&EpisodeID="+PAADMRowid+"&ArcimRowid="+ArcimRowid+"&OrderPoisonCode="+OrderPoisonCode
						var ret=window.showModalDialog(antMainUrl,"","dialogwidth:800px;dialogheight:600px;status:no;center:1;resizable:yes");
						//dhcsys_alert(ret);
						if(ret!=""){
							SetAntInfo(ret)
				}else {
								var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
								//DeleteTabRow(objtbl,Row);
								return false;
						}
  		}
  		if (TypeControl=='S'){
	  			//ReasonFlag=1
				//SystemAddAntApply(OrderARCIMRowid);
				//return true;
  		}
  		
  		if (TypeControl==''){
				//return true;
  		}				
		}
	}
	if(DoctorTypePoisonStr==""){
		dhcsys_alert("该药品属于"+OrderPoisonDesc+"(管制分类),"+t['PoisonClassIsFobidden']);
		return false	
	}
	if((ShowTabStr=="")&&(OrderPoisonCode.indexOf("KSS")>=0)&&(ReasonFlag==1)){   //((OrderPoisonCode=="KSS2")||(OrderPoisonCode=="KSS3"))
								var obj=document.getElementById('EpisodeID');
								var PAADMRowid=obj.value;
								ShowTabStr="UserReason"
								SetColumnData("ShowTabStr",Row,ShowTabStr);
								dhcsys_alert("治疗类药品请送检")
								//add by shp 2013-01-22
								var antMainUrl="dhcdocantimain.csp?ShowTabStr="+ShowTabStr+"&EpisodeID="+PAADMRowid+"&ArcimRowid="+ArcimRowid+"&OrderPoisonCode="+OrderPoisonCode
								var ret=window.showModalDialog(antMainUrl,"","dialogwidth:800px;dialogheight:600px;status:no;center:1;resizable:yes");
								//dhcsys_alert(ret);
								if(ret!=""){
									SetAntInfo(ret);
								}else{
									var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
									//DeleteTabRow(objtbl,Row);
									return false;
								}	
	}
	if(ReasonFlag==0){
		dhcsys_alert("该药品属于"+OrderPoisonDesc+"(管制分类),"+t['PoisonClassIsFobidden']);  //dhcsys_alert(t['PoisonClassIsFobidden']);
		return false;	
	}						

	//dhcsys_alert(t['PoisonClassIsFobidden']);
	//return false;
	return true;
}


//update by zf 2012-05-14
//临床路径检查，路径外医嘱填写变异
function CPWCheck(){
	var EpisodeID="";
	var obj=document.getElementById('EpisodeID');
	if (obj){
		var EpisodeID=obj.value
	}
	
	var ArcimIDs="";
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i < rows; i++){
		var Row=GetRow(i);
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		ArcimIDs=ArcimIDs + OrderARCIMRowid + ",";
	}
	if (!ArcimIDs) return true;
	
	var ret=tkMakeServerCall("web.DHCCPW.MR.ClinPathWaysVariance","CheckOutARCIM",EpisodeID,ArcimIDs,session['LOGON.USERID']);
	if (!ret) return true;
	var tmpRet=ret.split("^");
	if (tmpRet[0]>0){
		var path="dhccpw.mr.checkoeitem.csp?1=1"
			+ "&EpisodeID=" + EpisodeID
			+ "&PathWayID=" + tmpRet[1]
			+ "&EpStepID=" + tmpRet[2]
			+ "&ArcimIDs=" + tmpRet[3]
			+ "&UserID=" + session['LOGON.USERID'];
		var numHeigth=300;
		var numWidth=400;
		var numTop=(screen.availHeight-numHeigth)/2;
		var numLeft=(screen.availWidth-numWidth)/2;
		var posn="dialogHeight:"+ numHeigth +"px; dialogWidth:"+ numWidth +"px; top:" + numTop + "px; left:" + numLeft + "px";
		//window.open(path);
		var ret=window.showModalDialog(path,"",posn);
		if (ret){
			return true;
		}else{
			return false;
		}
	}
	return true;
}
// 修改一行的元素属性是否可编辑
function ChangeCellsDisabledStyle(Row,Disabled){
	ChangeCellStyle("OrderPrior",Row,Disabled);
	ChangeCellStyle("OrderFreq",Row,Disabled);
	ChangeCellStyle("OrderDur",Row,Disabled);
	ChangeCellStyle("OrderInstr",Row,Disabled);
	ChangeCellStyle("OrderStartDate",Row,Disabled);
	ChangeCellStyle("OrderStartTime",Row,Disabled);
	ChangeCellStyle("OrderEndDate",Row,Disabled);
	ChangeCellStyle("OrderEndTime",Row,Disabled);
	ChangeCellStyle("OrderMultiDate",Row,Disabled);
	ChangeCellStyle("OrderFirstDayTimes",Row,Disabled);
	ChangeCellStyle("OrderBodyPart",Row,Disabled);
	ChangeCellStyle("OrderStage",Row,Disabled);
	ChangeCellStyle("OrderSpeedFlowRate",Row,Disabled);
	ChangeCellStyle("OrderFlowRateUnit",Row,Disabled);
	ChangeCellStyle("OrderDate",Row,Disabled);
	ChangeCellStyle("OrderTime",Row,Disabled);
	ChangeCellStyle("OrderNeedPIVAFlag",Row,Disabled);
	
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	if (OrderPriorRowid!=ShortOrderPriorRowid){
		ChangeCellStyle("OrderSkinTest",Row,Disabled);
	}else{
		ChangeCellStyle("OrderSkinTest",Row,false);
	}	
}

// 修改一行的元素属性是否可编辑
function ChangeChildRowStyle(Row){
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
 	for (i=1;i<=rows;i++){
 		var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",i);
 		if ((OrderMasterSeqNo!="")&&(OrderSeqNo==OrderMasterSeqNo)) {
 			var Row=GetRow(i);
 			SetColumnData("OrderMasterSeqNo",Row,"");
 			ChangeCellsDisabledStyle(Row,false);
		}
	}
}

function SetLinkItemValue(LinkOrderStr){
	var patobj=document.getElementById("LinkOrderStr");
	if (patobj) patobj.value=LinkOrderStr;
	var Obj=document.getElementById("OrderNurLink");
	if (Obj){
		if (LinkOrderStr!=""){
			var OrderName="主医嘱："+LinkOrderStr.split("^")[9]
			}
		else{var OrderName=""}
		Obj.innerText=OrderName
	}
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=GetRow(i)
		SetNurLinkOrd(Row)
	}
}

function InstrNextFocus(Row) {
	var obj=document.getElementById('OrderDurz'+Row);
	if (obj&&(obj.type=="text")){
		websys_setfocus("OrderDurz"+Row);
	}else{
		var OrderPackQtyObj=document.getElementById("OrderPackQtyz"+Row);
		if (OrderPackQtyObj&&(OrderPackQtyObj.type=="text")){
			websys_setfocus("OrderPackQtyz"+Row);
		}else{
			window.setTimeout("AddClickHandler()",200);
		}
	}
	return;	
}
//对象转化为指定分隔符的字符串
function ObjectTransStr(obj,space){
  var k=0,str;
  for(var a in obj){
  	 if ((typeof obj[a] === 'function')||(typeof obj[a] === 'object')) continue;
     if(k==0){
     		str=a+"="+obj[a];
     }else{
     		str+=space+a+"="+obj[a];   
     }   
     k++;
  }  
  return str;  
}
function UserReasonClick(e){
	//弹出抗生素使用目的界面
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	if (evtName=='OrderName') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var PoisonCode=GetColumnData("OrderPoisonCode",Row);
	var ShowTabStr=""
	//PoisonCode="XZ"
	/*if(PoisonCode=="TS"){
			ShowTabStr="Apply^UserReason"	
	}
	if((PoisonCode=="XZ")||(PoisonCode=="FXZ")){
			ShowTabStr="UserReason"
	}*/
	ShowTabStr=GetColumnData("ShowTabStr",Row);
	if(ShowTabStr!=""){
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var obj=document.getElementById('EpisodeID');
		var OrderAntibApplyRowid=GetColumnData("OrderAntibApplyRowid",Row);
		var UserReasonId=GetColumnData("UserReasonId",Row);
		var OrderPoisonCode=GetColumnData("OrderPoisonCode",Row);
		var PAADMRowid=obj.value;
		//var MainAnt=new AntMain(ShowTabStr,PAADMRowid,OrderARCIMRowid,OrderAntibApplyRowid,UserReasonId,OrderPoisonCode)
		//MainAnt.GetPatDetail()
		//MainAnt.show();
		var antMainUrl="dhcdocantimain.csp?ShowTabStr="+ShowTabStr+"&EpisodeID="+PAADMRowid+"&ArcimRowid="+ArcimRowid+"&OrderPoisonCode="+OrderPoisonCode
		var ret=window.showModalDialog(antMainUrl,"","dialogwidth:800px;dialogheight:600px;status:no;center:1;resizable:yes");
		//dhcsys_alert(ret);
		if(ret!=""){
			SetAntInfo(ret);
		}else{
			var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
			//DeleteTabRow(objtbl,Row);
			return false;
		}	
	}
}
function SetAntInfo(AntInfoStr){
		if(AntInfoStr==""){
				var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
				DeleteTabRow(objtbl,FocusRowIndex);
		}else{
				var AntInfoArr=AntInfoStr.split("!")
				var UserReasonID=AntInfoArr[0]
				var AntibApplyRowid=AntInfoArr[1]
				var OrderInsId=AntInfoArr[2]
				var OrderInsDesc=AntInfoArr[3]
				var specailAction=AntInfoArr[4]
				var Row=GetRow(FocusRowIndex);
				SetColumnData("OrderAntibApplyRowid",Row,AntibApplyRowid);
				SetColumnData("UserReasonId",Row,UserReasonID);    //使用目的 
				if((OrderInsId!="")&&(OrderInsDesc!="")){
					SetColumnData("OrderInstrRowid",Row,OrderInsId);
					SetColumnData("OrderInstr",Row,OrderInsDesc);
				}
				if(specailAction=="isEmergency"){
					SetColumnData("OrderPrior",Row,ShortOrderPriorRowid);
					SetColumnData("OrderPriorRowid",Row,ShortOrderPriorRowid);
					SetColumnData("OrderFreqRowid",Row,ONCEFreqRowid);
					SetColumnData("OrderFreq",Row,ONCEFreq);
					document.getElementById("OrderPriorz"+Row).disabled=true;
					document.getElementById("OrderFreqz"+Row).disabled=true;
					SetColumnData("SpecialAction",Row,specailAction)
					}
	}	
}
function SetAntibioticRowid(OrderAntibApplyRowid){
	if (OrderAntibApplyRowid==""){
		var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
		DeleteTabRow(objtbl,FocusRowIndex);
  }else{
		var Row=GetRow(FocusRowIndex);
		SetColumnData("OrderAntibApplyRowid",Row,OrderAntibApplyRowid);
  }   
}  
function DeleteAntibApply(CurrentRow)
{
	var OrderAntibApplyRowid=GetColumnData("OrderAntibApplyRowid",CurrentRow);
	if ((OrderAntibApplyRowid!="")&&(DeleteAntibApplyMethod!="")) {
		var ret=cspRunServerMethod(DeleteAntibApplyMethod,OrderAntibApplyRowid);
	}
}

function DeleteAntReason(CurrentRow)
{
	var UserReasonId=GetColumnData("UserReasonId",CurrentRow);
	if((UserReasonId!="")&&(ReasonCanBeDeletedMethod!="")){
		var rtn=cspRunServerMethod(ReasonCanBeDeletedMethod,UserReasonId);
		if((rtn==1)&&(DeleteAntReasonMethod!="")){
			var ret=cspRunServerMethod(DeleteAntReasonMethod,UserReasonId);
			}
		}
}
/**/
document.body.onload = DocumentLoadHandler;
//document.body.onbeforeunload=DocumentUnloadHandler;
var AnditArcArr
function DocumentLoadHandler(){
	var EpisodeID=document.getElementById("EpisodeID").value;
	var userid=session['LOGON.USERID'];
	//check is doctor or nurse
	var IsDoc=tkMakeServerCall("web.DHCDocAntiCommon","GetCareType",userid)
	if(IsDoc==1){
		var ordInfo=tkMakeServerCall("web.DHCDocAntibioticReason","GetAuditApplyInfo",EpisodeID,userid)
		if (ordInfo!=""){
			var winAuditInfo=new AuditInfo(EpisodeID,userid)
			//AuditInfo.show();
		}
	}
}
//添加 抗菌药物检查方法。
function CheckAuditItem(){
	if (AuditFlag==1) {AuditFlag=0;return true;}
	else{ return false;}
}
function CheckSuscept(episodeid,arcim){
	var ret=0;
	if(CheckSusceptMethod!=""){
		var ret=cspRunServerMethod(CheckSusceptMethod,EpisodeID,arcim);
		return ret;
	}
	return ret
}
function CheckInDurSameIM(ImRowid,Row){
	var EpisodeID=document.getElementById("EpisodeID").value;
	var flag=false;
	if(CheckInDurSameIMMethod!=""){
		var ret=cspRunServerMethod(CheckInDurSameIMMethod,EpisodeID,ImRowid);
		var retArr=ret.split("^")
		var ret1=retArr[0];
		if (ret1==2){
			var UserReasonID=retArr[1];
			SetColumnData("UserReasonID",Row,UserReasonID)
			flag=true
			}
	}
	return flag;
}
function DeleteMultiClickHandler()
{
	try{
		var focusrow=GetRow(FocusRowIndex);
		var objtab=document.getElementById("tUDHCOEOrder_List_Custom");
		var rows1=objtab.rows.length;
		if(focusrow){
			for(var i=rows1-1;i>=focusrow;i--){				
			if(CanDeleteRow(objtab,i))
		     DeleteTabRow(objtab,i); 
			}
		}
	}catch(e){};	
}
function SynBtnClickHandler()
{
	//同步选中医嘱下边时间日期
    try {
          var Row=GetRow(FocusRowIndex);
          var OrderDate=GetColumnData("OrderDate",Row);
          var OrderTime=GetColumnData("OrderTime",Row);
          var StarDate=GetColumnData("OrderStartDate",Row);
          var StarTime=GetColumnData("OrderStartTime",Row);
          var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
          if (objtbl){
              var rows=objtbl.rows.length;
              for (var i=Row; i<=rows; i++){
	          var OrderItemRowid=GetColumnData("OrderItemRowid",i);
	          if (OrderItemRowid==""){
	              SetColumnData("OrderDate",i,OrderDate);
	              SetColumnData("OrderTime",i,OrderTime);
	              SetColumnData("OrderStartDate",i,StarDate);
	              SetColumnData("OrderStartTime",i,StarTime);
	          }
             }
          }
		return false;
     } catch(e) {};	
}
function IsSpecForm(DrgformRowid){
	if (DrgformRowid=="") return false;
	var FormRowid=cspRunServerMethod(GetArcimFormRowidMethod,DrgformRowid);
	var FormStr="^"+FormRowid+"^";
	if (PHCFormStr.indexOf(FormStr)<0){
		return false;
	}else{
		return true;
	}
}

function OrderBySelfOMFlagChangehandler(e)
{
	 var Row=GetEventRow(e);
	 var OrderBySelfOMFlag=GetColumnData("OrderBySelfOMFlag",Row);
	 if (OrderBySelfOMFlag){
	 	SetColumnData("OrderPriorRemarks",Row,"OM");
		}else{
		SetColumnData("OrderPriorRemarks",Row,"");
		}
}
//超量疗程原因
function ExceedReasonchangehandler()
{
	var Row=GetEventRow(e);
	var obj=websys_getSrcElement(e);
	var selIndex=obj.selectedIndex;
	var OralOrderDocRowId=""
	if (selIndex!=-1) {ExceedReasonRowId=obj.options[selIndex].value;}
	SetColumnData("ExceedReasonID",Row,ExceedReasonRowId);
}

//保存为医嘱套
function SaveToArcos_Click()
{
     var tb=document.getElementById("tUDHCOEOrder_List_Custom"); 
     var rows=tb.rows.length;
     var HasNosave=0
     for(var i=1;i<rows;i++)
     {
	     var RowGet=GetRow(i);  
	     //门诊的已经审核但未收费不会在录入的医嘱套中
	     var OrderNameObj=document.getElementById("OrderNamez"+RowGet); 
	     if ((OrderNameObj)&&(OrderNameObj.type!="text")) continue ;
	     var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",RowGet);
	     if(OrderARCIMRowid!="")
		  {	
	     	var HasNosave=1
		  }
	     
     }
     if (HasNosave==0){
	     dhcsys_alert("界面不存在未审核的医嘱！")
	     return false;
     }
     var RtnStr=UDHCOEOrderDescSetLink();
	 if (RtnStr==""){ return websys_cancel();}
	 var ArcosRowid=RtnStr.split("^")[0];
	 if (ArcosRowid!=""){AddTOArcosARCIM(ArcosRowid);}
	 else{dhcsys_alert("保存失败!");return websys_cancel();}
}
//插入医嘱套名称
function UDHCOEOrderDescSetLink(){	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCFavOrderSets.Edit";
	var RtnStr=window.showModalDialog(lnk,'UDHCFavOrderSets.Edit',"dialogwidth:60;dialogheight:27;help:no;status:no;center:1;resizable:no");	
    return  RtnStr
}
//对应的医嘱套医嘱保存
function AddTOArcosARCIM(Arcosrowid){
     if(Arcosrowid==""){return websys_cancel();}
     var tb=document.getElementById("tUDHCOEOrder_List_Custom"); 
     var rows=tb.rows.length;
     for(var i=1;i<rows;i++)
     {
	     var RowGet=GetRow(i);  
	     //门诊的已经审核但未收费不会在录入的医嘱套中
	     var OrderNameObj=document.getElementById("OrderNamez"+RowGet); 
	     if ((OrderNameObj)&&(OrderNameObj.type!="text")) continue ; 
	     var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",RowGet);
	     if(OrderARCIMRowid!="")
		  {	
			var OrderMasterSeqNo=GetColumnData("OrderMasterSeqNo",RowGet);
			var OrderSeqNo=GetColumnData("OrderSeqNo",RowGet);
			var OrderPriorRowid=GetColumnData("OrderPriorRowid",RowGet);
			//存在关联号为空,也赋值了关联号到医嘱套维护界面,在AddCopyItemToList有判断不影响使用
			if(OrderMasterSeqNo==""){
				OrderMasterSeqNo=OrderSeqNo;
				}
			else{
				OrderMasterSeqNo=OrderMasterSeqNo+"."+(OrderSeqNo-OrderMasterSeqNo)
				}
			var OrderDoseQty=GetColumnData("OrderDoseQty",RowGet);    //剂量
			var OrderDoseUOM=GetColumnData("OrderDoseUOM",RowGet);    //剂量单位
			var OrderFreqRowID=GetColumnData("OrderFreqRowid",RowGet); //频次
			var OrderInstrRowID=GetColumnData("OrderInstrRowid",RowGet); //用法
			var OrderDurRowid=GetColumnData("OrderDurRowid",RowGet);     //疗程
			var OrderPackQty=GetColumnData("OrderPackQty",RowGet);      //整包装
			var OrderPackUOM=GetColumnData("OrderPackUOM",RowGet);      //整包装单位
			var OrderDepProcNote=GetColumnData("OrderDepProcNote",RowGet); //医嘱备注
			var OrderPriorRemarks=GetColumnData("OrderPriorRemarks",RowGet); //附加说明
			///SampleId 标本ID,ARCOSItemNO  插入指定位置(医嘱录入不用), OrderPriorRemarksDR As %String
			var ret=tkMakeServerCall('web.DHCARCOrdSets','InsertItem',Arcosrowid,OrderARCIMRowid,OrderPackQty,OrderDoseQty,OrderDoseUOM,OrderFreqRowID,OrderDurRowid,OrderInstrRowID,OrderMasterSeqNo,OrderDepProcNote,OrderPriorRowid,"","",OrderPriorRemarks);
		  }
     }
     dhcsys_alert("保存成功")
	 return websys_cancel();	
}
//检查频次和整包装数量是否应该是可用的
function CheckFreqAndPackQty(Row){
	var OrderType=GetColumnData("OrderType",Row);
	//整包装
	var IdPackQty="OrderPackQtyz"+Row;
	var objPackQty=document.getElementById(IdPackQty);
	var PackQtyobj=websys_getParentElement(objPackQty);
	//频次
	var IdOrderFreq="OrderFreqz"+Row;
	var objFreq=document.getElementById(IdOrderFreq);
	var Freqobj=websys_getParentElement(objFreq);
	//疗程
	var IdOrderDur="OrderDurz"+Row;
	var objDur=document.getElementById(IdOrderDur);
	var Durobj=websys_getParentElement(objDur);
	//单次剂量
	var IdDoseQty="OrderDoseQtyz"+Row;
	var objDoseQty=document.getElementById(IdDoseQty);
	var DoseQtyobj=websys_getParentElement(objDoseQty);
	
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
	if (OrderPriorRowid==LongOrderPriorRowid){
			if (objFreq&&(objFreq.type=="text")){
					//长期医嘱频次可用则不许填写数量
					var objwidth=PackQtyobj.style.width;
					var objheight=PackQtyobj.style.height;
					var str="<label id=\""+IdPackQty+"\" name=\""+IdPackQty+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
					PackQtyobj.innerHTML=str;
					//var str="<input type=text id=\""+IdPackQty+"\" name=\""+IdPackQty+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"OrderPackQtykeydownhandler()\" onkeypress=\"OrderPackQtykeypresshandler()\" onchange=\"OrderPackQtychangehandler()\">";
					//PackQtyobj.innerHTML=str;
				}	
			}
 
  //小时医嘱
  var HourFlag=cspRunServerMethod(IsHourItem,OrderARCIMRowid);
  if (HourFlag=="1")
  {	  //小时医嘱不能录入频次
  	  var objwidth=Freqobj.style.width;
	  var objheight=Freqobj.style.height;
	  var str="<label id=\""+IdOrderFreq+"\" name=\""+IdOrderFreq+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
      Freqobj.innerHTML=str; 
      SetColumnData("OrderFreqRowid",Row,"");
	  SetColumnData("OrderFreqFactor",Row,"1");
		//疗程 
		var objwidth=Durobj.style.width;
		var objheight=Durobj.style.height;
		var str="<label id=\""+IdOrderDur+"\" name=\""+IdOrderDur+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
		Durobj.innerHTML=str; 
		SetColumnData("OrderDurRowid",Row,"");
		SetColumnData("OrderDurFactor",Row,"1");
	  
      if (OrderPriorRowid==LongOrderPriorRowid){
	  				//小时医嘱，长期的也不能录入数量
	  				var objwidth=PackQtyobj.style.width;
					var objheight=PackQtyobj.style.height;
					var str="<label id=\""+IdPackQty+"\" name=\""+IdPackQty+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
					PackQtyobj.innerHTML=str;
  	  }
  }
  //高值材料
  if (HighValueControl==1){
  var IncItmHighValueFlag=cspRunServerMethod(GetIncItmHighValueFlag,OrderARCIMRowid)
  var OrderMaterialBarCode=GetColumnData("OrderMaterialBarcodeHiden",Row);
  if(IncItmHighValueFlag=="Y"){
		//高值数量为1不可改
		var objwidth=PackQtyobj.style.width;
		var objheight=PackQtyobj.style.height;
		var str="<label id=\""+IdPackQty+"\" name=\""+IdPackQty+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
		PackQtyobj.innerHTML=str;
		SetColumnData("OrderPackQty",Row,1);
		//高值医嘱不能录入频次
		var objwidth=Freqobj.style.width;
		var objheight=Freqobj.style.height;
		var str="<label id=\""+IdOrderFreq+"\" name=\""+IdOrderFreq+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
		Freqobj.innerHTML=str; 
		SetColumnData("OrderFreqRowid",Row,"");
		SetColumnData("OrderFreqFactor",Row,"1");
		//单次剂量 
		var objwidth=DoseQtyobj.style.width;
		var objheight=DoseQtyobj.style.height;
		var str="<label id=\""+IdDoseQty+"\" name=\""+IdDoseQty+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
		DoseQtyobj.innerHTML=str; 
		SetColumnData("OrderDoseQty",Row,"");
		//疗程 
		var objwidth=Durobj.style.width;
		var objheight=Durobj.style.height;
		var str="<label id=\""+IdOrderDur+"\" name=\""+IdOrderDur+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\">";
		Durobj.innerHTML=str; 
		SetColumnData("OrderDurRowid",Row,"");
		SetColumnData("OrderDurFactor",Row,"1");
	  }
   }
 }
 //-------------高值更新
 //高值条码
 function OrderMaterialBarcode_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	if (evtName=='OrderMaterialBarcode') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}

	if (((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13)))&&(HighValueControl==1)) {
		var label=GetColumnData("OrderMaterialBarcode",Row);
		var AricmStr=cspRunServerMethod(GetArcimByLabel,label)
		var ArcimArr=AricmStr.split("^")
		if(ArcimArr[1]=="Enable"){
			//返回的是实库存数量。其实可以走统一的库存判断不用在这做判断
			var arcimRowid=ArcimArr[0]
			var avaQty=ArcimArr[4]
			if(avaQty<=0){
				dhcsys_alert("该条码对应的医嘱库存不足.")
				return false;
			}
			var ReLocId=ArcimArr[5]  //材料可用接收科室
			if(arcimRowid!=""){
				var ReLocIdFlag="N"
				AddItemToList(Row,arcimRowid,"","");
				var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
				if (OrderARCIMRowid!=""){
					var OrderRecLocStr=GetColumnData("OrderRecLocStr",Row);
					var ArrData=OrderRecLocStr.split(String.fromCharCode(2));
					for (var i=0;i<ArrData.length;i++) {
						var ArrData1=ArrData[i].split(String.fromCharCode(1));
						if ((ArrData1[0]==ReLocId)&&(ReLocIdFlag!="Y")){ReLocIdFlag="Y"};
					}
					if (ReLocIdFlag=="N")
					{	
						dhcsys_alert("该条码不能在该科室使用!")
						var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
						DeleteTabRow(objtbl,Row);
						return false;
					}
					SetColumnData("OrderMaterialBarcodeHiden",Row,label);  //把条码放到一个隐藏的列里面
					SetColumnData("OrderMaterialBarcode",Row,label)
				}
			}
		}
		else{
			dhcsys_alert("该条码不存在或者已被使用!");
			SetColumnData("OrderMaterialBarcodeHiden",Row,"")
			SetColumnData("OrderMaterialBarcode",Row,"")
		}
		
	}
}
//审核医嘱时候再次对高值条码可用性检测
function CheckMaterialBarcode(LabelCode,Row)
{
	if (HighValueControl==1){
		var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		var AricmStr=cspRunServerMethod(GetArcimByLabel,LabelCode)
		var ArcimArr=AricmStr.split("^")
		if(ArcimArr[1]=="Enable"){
			var arcimRowid=ArcimArr[0]
			var avaQty=ArcimArr[4]
			if(avaQty<=0){
				dhcsys_alert("该条码对应的医嘱库存不足.")
				return false;
			}
			var ReLocId=ArcimArr[5];  //材料可用接收科室
			var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
			if(ReLocId!=OrderRecDepRowid){
				dhcsys_alert("该条码接收科室错误!")
				return false;
			}
			if ((OrderARCIMRowid!="")&&(OrderARCIMRowid!=arcimRowid))
			{
				dhcsys_alert("条码和所对应的医嘱项目不符.")
				return false;
			}
		}
		else{
				dhcsys_alert("条码:"+LabelCode+"不可用,请输入其它条码!")
				SetFocusColumn("OrderMaterialBarcode",Row);
				return false;
			}
	 if (OrderPriorRowid!=ShortOrderPriorRowid){dhcsys_alert("高值材料请开临时医嘱使用!");return false;}
  }
	 return true
}
//-------------高值更新		

//处方预览
function PresView_Click()
{
	
	var ObjPrescNoStr=""
	var objtbl=document.getElementById('tUDHCOEOrder_List_Custom');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
				var Row=GetRow(i);
				var OrderPrescNo=GetColumnData("OrderPrescNo",Row);
				OrderPrescNo=OrderPrescNo.replace(/(^\s*)|(\s*$)/g,'');
		    if (OrderPrescNo=="") continue ;
		    if (("^"+ObjPrescNoStr+"^").indexOf(("^"+OrderPrescNo+"^"))>=0) continue;
				if (ObjPrescNoStr=="") ObjPrescNoStr=OrderPrescNo;
				else {ObjPrescNoStr=ObjPrescNoStr+"^"+OrderPrescNo
			
					}
				}

	if (ObjPrescNoStr==""){dhcsys_alert("不存在需要预览的处方");return}
	var obj=document.getElementById('EpisodeID');
	var EpisodeID=obj.value;
	var Url="dhcdoc.viewpresclist.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+"";
	window.open(Url,"","height=800,scrollbars=1");
}


// 协议包装,2014-05-30,by xp,Start
function OrderPackUOMchangehandler(e){
	var Row=GetEventRow(e);
	OrderPackUOMchangeCommon(Row)
}

function OrderPackUOMchangeCommon(Row){
	var PackUOMObj=document.getElementById("OrderPackUOMz"+Row);
	var selIndex=PackUOMObj.selectedIndex;
	var PackUOMRowid=""
	if (selIndex!=-1) {PackUOMRowid=PackUOMObj.options[selIndex].value;}
	SetColumnData("OrderPackUOMRowid",Row,PackUOMRowid);
	GetOrderPriceConUom(Row);
}

// 根据单位变化,取医嘱整包装价格
function GetOrderPriceConUom(Row){
	var LogonDep=""
  if (FindRecLocByLogonLoc=="1"){LogonDep=session['LOGON.CTLOCID']}
  if (PAAdmType!="I"){
  	OrderBillTypeRowid=GetPrescBillTypeID();
  }else{
  	OrderBillTypeRowid=BillTypeID;
  }
  
  var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
  var OrderOpenForAllHosp=GetColumnData("OrderOpenForAllHosp",Row);
  var OrderPackUOMRowid=GetColumnData("OrderPackUOMRowid",Row);
  if (OrderPackUOMRowid=="") return;
  var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row); //用来确定批次价格
  var retPrice=cspRunServerMethod(GetOrderPriceConUomMethod,EpisodeID,OrderBillTypeRowid,LogonDep,OrderARCIMRowid,OrderOpenForAllHosp,OrderPackUOMRowid,OrderRecDepRowid);
  var ArrPrice=retPrice.split("^");
  var Price=ArrPrice[0];
  var OrderConFac=ArrPrice[4];
  //var FreeMedFee=ArrPrice[5];
  //SetColumnData("FreeMedFee",Row,FreeMedFee);
  SetColumnData("OrderPrice",Row,Price);
  SetColumnData("OrderConFac",Row,OrderConFac);
  //OrderPricechangeCommon(Row);
  //------------修改协议单位改变每行价格和总价
  var OrderPackQty=GetColumnData("OrderPackQty",Row); 
  var IdOrderPack="OrderPackQtyz"+Row;
  var objPack=document.getElementById(IdOrderPack);
  if (objPack&&(objPack.type=="text")){
	  if (!isNumber(OrderPackQty)){
		  SetColumnData("OrderPackQty",Row,1);
		  OrderPackQty=1
	  }
	  var OrderSum=parseFloat(Price)*OrderPackQty;
 	  SetColumnData("OrderSum",Row,OrderSum);
  }
  SetScreenSum();
  //转换单位和整包装数量无关
  //SetPackQty(Row);
}

///初始化需要接收科室还有医嘱项ID,注意初始化位置在前边两项之后进行附值
function GetBillUOMStr(Row){
	DHCC_ClearList("OrderPackUOMz"+Row);
	var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",Row);
	var OrderRecDepRowid=GetColumnData("OrderRecDepRowid",Row);
	//取协议包装单位
	if (OrderRecDepRowid!="") {
		BillUOMStr=cspRunServerMethod(GetBillUOMStrMethod,OrderARCIMRowid,OrderRecDepRowid);
		SetColumnList("OrderPackUOM",Row,BillUOMStr);
		OrderPackUOMchangeCommon(Row);
	}
}
// 协议包装,2014-05-30,by xp,End
///得到菜单参数
function GetMenuPara(ParaName){
	var myrtn="";
    var frm=dhcsys_getmenuform();
    if (frm) {
  	  myrtn=eval("frm."+ParaName+".value");
    }
    return myrtn;
}
///补录医嘱
function SetNurLinkOrd(Row)
{
	
	var patobj=document.getElementById("LinkOrderStr");
	if(patobj){
		if(patobj.value!="") {    
		var ArrData=patobj.value.split("^");
		var MasterOrderItemRowId=ArrData[0];
		var MasterOrderPriorRowid=ArrData[1];
		var MasterOrderFreqRowid=ArrData[3];
		var MasterOrderStartDate=ArrData[2];
		var MasterOrderFreq=ArrData[4];
		var MasterOrderSeqNo="";
		var MasterOrderStartTime=ArrData[6];
		var MasterOrderInstrRowid=ArrData[7];
		var MasterOrderInstr=ArrData[8];
		if (MasterOrderPriorRowid==OMOrderPriorRowid){
			MasterOrderPriorRowid=ShortOrderPriorRowid;
		}else if(MasterOrderPriorRowid==OMSOrderPriorRowid){
			MasterOrderPriorRowid=LongOrderPriorRowid;
		}
		var MasterOrderStartDate=cspRunServerMethod(ConverDateMethod,MasterOrderStartDate,3,4);
		SetColumnData("OrderMasterSeqNo",Row,MasterOrderSeqNo);
		SetColumnData("LinkedMasterOrderRowid",Row,MasterOrderItemRowId);
		SetColumnData("OrderPrior",Row,MasterOrderPriorRowid);
		SetColumnData("OrderPriorRowid",Row,MasterOrderPriorRowid);
		SetColumnData("OrderFreqRowid",Row,MasterOrderFreqRowid);
		SetColumnData("OrderFreq",Row,MasterOrderFreq);
		SetColumnData("OrderInstrRowid",Row,MasterOrderInstrRowid);
		SetColumnData("OrderInstr",Row,MasterOrderInstr);
		SetColumnData("OrderStartDate",Row,MasterOrderStartDate);
		SetColumnData("OrderStartTime",Row,MasterOrderStartTime);
		if(MasterOrderFreqRowid!=""){
			PHCFRDesc_changehandlerX(LookUpFrequencyMethod);
		}
	}
	else{
		SetColumnData("OrderMasterSeqNo",Row,"");
		SetColumnData("LinkedMasterOrderRowid",Row,"");
		SetFocusColumn("OrderName",Row);
		}
	}
	return true;
}
