//DHCOPRegConfig.Js
var OldManFreeObj=document.getElementById("OldManFree");

function BodyLoadHandler(){
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=Save_Click;}
	
	var obj=document.getElementById("ADD");
	if (obj){obj.onclick=add_Click;}
	//InitDoc();
	
	var BillSubStr=DHCC_GetElementData('BillSubStr');
	
	var RegFeeBillSubRowId=DHCC_GetElementData('RegFeeBillSubRowId');

	combo_RegFeeBillSub=dhtmlXComboFromStr("RegFeeBillSub",BillSubStr);
	if (combo_RegFeeBillSub){
		combo_RegFeeBillSub.enableFilteringMode(true);
		combo_RegFeeBillSub.setComboValue(RegFeeBillSubRowId);
		//ind=combo_RegFeeBillSub.getIndexByValue(RegFeeBillSubRowId);
		//combo_RegFeeBillSub.selectOption(ind,true)
	}
	
	var CheckFeeBillSubRowId=DHCC_GetElementData('CheckFeeBillSubRowId');
	combo_CheckFeeBillSub=dhtmlXComboFromStr("CheckFeeBillSub",BillSubStr);
	if (combo_CheckFeeBillSub){
		combo_CheckFeeBillSub.enableFilteringMode(true);
		combo_CheckFeeBillSub.setComboValue(CheckFeeBillSubRowId);
		//ind=combo_CheckFeeBillSub.getIndexByValue(CheckFeeBillSubRowId);
		//combo_CheckFeeBillSub.selectOption(ind,true)
	}
	
	var ReCheckFeeBillSubRowId=DHCC_GetElementData('ReCheckFeeBillSubRowId');
	combo_ReCheckFeeBillSub=dhtmlXComboFromStr("ReCheckFeeBillSub",BillSubStr);
	if (combo_ReCheckFeeBillSub){
		combo_ReCheckFeeBillSub.enableFilteringMode(true);
		combo_ReCheckFeeBillSub.setComboValue(ReCheckFeeBillSubRowId);
	}
	
	var HoliFeeBillSubRowId=DHCC_GetElementData('HoliFeeBillSubRowId');
	combo_HoliFeeBillSub=dhtmlXComboFromStr("HoliFeeBillSub",BillSubStr);
	if (combo_HoliFeeBillSub){
		combo_HoliFeeBillSub.enableFilteringMode(true);
		combo_HoliFeeBillSub.setComboValue(HoliFeeBillSubRowId);
		//ind=combo_HoliFeeBillSub.getIndexByValue(HoliFeeBillSubRowId);
		//combo_HoliFeeBillSub.selectOption(ind,true)
	}

	var AppFeeBillSubRowId=DHCC_GetElementData('AppFeeBillSubRowId');
	combo_AppFeeBillSub=dhtmlXComboFromStr("AppFeeBillSub",BillSubStr);
	if (combo_AppFeeBillSub){
		combo_AppFeeBillSub.enableFilteringMode(true);
		combo_AppFeeBillSub.setComboValue(AppFeeBillSubRowId);
		//ind=combo_AppFeeBillSub.getIndexByValue(AppFeeBillSubRowId);
		//combo_AppFeeBillSub.selectOption(ind,true);
	}
	//挂号服务组
	var GetRBCServiceGroupStr=DHCC_GetElementData('GetRBCServiceGroupStr');
	var RegServiceGroupRowId=DHCC_GetElementData('RegServiceGroupRowId');
	combo_RBCServiceGroup=dhtmlXComboFromStr("RBCServiceGroup",GetRBCServiceGroupStr);
	if (combo_RBCServiceGroup){
		combo_RBCServiceGroup.enableFilteringMode(true);
		combo_RBCServiceGroup.setComboValue(RegServiceGroupRowId);
	}
	
	
	
	///启用医保实时结算
	var EnableInsuBillStr=DHCC_GetElementData('EnableInsuBillStr');

	var EnableInsuBillRowId=DHCC_GetElementData('EnableInsuBillRowId');
	var EnableInsuBill=DHCC_GetElementData('EnableInsuBill');
	combo_EnableInsuBill=dhtmlXComboFromStr("EnableInsuBill",EnableInsuBillStr);
	if (combo_EnableInsuBill){
		combo_EnableInsuBill.enableFilteringMode(true);
		combo_EnableInsuBill.setComboValue(EnableInsuBillRowId);
	}

	///老年人免费
	if (OldManFreeObj){
		var OldManFreeStr=DHCC_GetElementData('OldManFreeStr');
		var OldManFreeRowId=DHCC_GetElementData('OldManFreeRowId');
		combo_OldManFree=dhtmlXComboFromStr("OldManFree",OldManFreeStr);
		if (combo_OldManFree){
			combo_OldManFree.enableFilteringMode(true);
			combo_OldManFree.setComboValue(OldManFreeRowId);
			//ind=combo_AppFeeBillSub.getIndexByValue(AppFeeBillSubRowId);
			//combo_AppFeeBillSub.selectOption(ind,true);
		}
	}
	
	var orderobj=document.getElementById('order');
	if (orderobj) {
		orderobj.onkeydown=orderlook;
		orderobj.onkeyup=clearorderid;
	}
	var obj=document.getElementById('NeedBillCardFeeOrder');
	if (obj) {
		obj.onblur=ClearNeedBillCardFeeOrderID;
	}
	var DepExpand=document.getElementById("DepExpand");
	if(DepExpand){
		DepExpand.onclick=function(){
			window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegDepExpand", '', "top=80,left=50,width=900,height=490,status=yes,scrollbars=yes");
				
		}
	}
	var obj=document.getElementById("BtnForceCancelReg");
	if(obj){
		obj.onclick=function(){
			window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCOPForceCancelReg", '', "top=80,left=50,width=900,height=490,status=yes,scrollbars=yes");
				
		}
	}

}
 /*病历本费医嘱设置*/
function getorderid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getorderid');
	obj.value=val[1];

}
function orderlook(){
	if (window.event.keyCode==13){  
		window.event.keyCode=117;
	  order_lookuphandler();
	}
}
function clearorderid(){
	var obj=document.getElementById('getorderid');
	obj.value="";
}
/*病历本费医嘱设置*/
/*需要账单卡费医嘱*/
function NeedBillCardFeeOrderLookUp(value){
	var val=value.split("^");
	var obj=document.getElementById('NeedBillCardFeeOrderID');
	obj.value=val[1];
}
function ClearNeedBillCardFeeOrderID(){
	var TextObj=document.getElementById('NeedBillCardFeeOrder');
	if (TextObj&&(TextObj.value=="")){
		var obj=document.getElementById('NeedBillCardFeeOrderID');
		if (obj)obj.value="";
	}
}
/*需要账单卡费医嘱*/

/*免费医嘱设置,增加两元素FreeOrder,FreeOrderID*/
function FreeOrderLookUp(value){
	var val=value.split("^");
	var obj=document.getElementById('FreeOrderID');
	obj.value=val[1];
}
function ClearFreeOrderID(){
	var TextObj=document.getElementById('FreeOrder');
	if (TextObj&&(TextObj.value=="")){
		var obj=document.getElementById('FreeOrderID');
		if (obj)obj.value="";
	}
}
function InitDoc(){
	var encmeth=DHCWebD_GetObjValue("ReadOPRegFS");
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth));
		var myary=rtnvalue.split("^");
		var mylen=myary.length;
		for(var i=0;i<mylen;i++){
			var evinfo=myary[i].split("!");
			DHCWebD_SetObjValueA(evinfo[0],evinfo[1]);
		}
	}
}

function add_Click(){
	
}

function Save_Click(){
	var mystr=BuildStr();
	var myoutsr=""
	var encmeth=document.getElementById("SaveParaEncrypt").value;
	if ((encmeth!="")&&(mystr!="")){
		var rtnvalue=cspRunServerMethod(encmeth,mystr);
		alert(t["SaveOK"]);
	}
}

function BuildStr(){
	var myary=new Array();
	
	myary[0]=DHCWebD_GetObjValue("Hospital");
	if (myary[0]!=""){myary[0]="Hospital"+"!"+myary[0];}
	myary[1]=DHCWebD_GetObjValue("AutoBregno");
	if (myary[1]==true){
		myary[1]=1;
	}else{
		myary[1]=0;
	}
	
	var RegFeeBillSub="",CheckFeeBillSub="",AppFeeBillSub="",HoliFeeBillSub="",ReCheckFeeBillSub="",RegServiceGroupRowId="";
	var OldManFree="";
	if (combo_RegFeeBillSub) var RegFeeBillSub=combo_RegFeeBillSub.getSelectedValue();
	if (combo_CheckFeeBillSub) var CheckFeeBillSub=combo_CheckFeeBillSub.getSelectedValue();
	if (combo_AppFeeBillSub) var AppFeeBillSub=combo_AppFeeBillSub.getSelectedValue();
	if(combo_HoliFeeBillSub) var HoliFeeBillSub=combo_HoliFeeBillSub.getSelectedValue();
	if (OldManFreeObj){
		if(combo_OldManFree) var OldManFree=combo_OldManFree.getSelectedValue();
	}
	if(combo_ReCheckFeeBillSub) var ReCheckFeeBillSub=combo_ReCheckFeeBillSub.getSelectedValue();
	
	myary[1]="AutoBregno"+"!"+myary[1];
	myary[2]="AppReturnTime"+"!"+DHCWebD_GetObjValue("AppReturnTime");
	myary[3]="AppDaysLimit"+"!"+DHCWebD_GetObjValue("AppDaysLimit");
	myary[4]="DayAppCountLimit"+"!"+DHCWebD_GetObjValue("DayAppCountLimit");
	myary[5]="AppQtyDefault"+"!"+DHCWebD_GetObjValue("AppQtyDefault");
	myary[6]="AppStartNoDefault"+"!"+DHCWebD_GetObjValue("AppStartNoDefault");
	myary[7]="AdmTimeRangeCount"+"!"+DHCWebD_GetObjValue("AdmTimeRangeCount");
	myary[8]="SchedulePeriod"+"!"+DHCWebD_GetObjValue("SchedulePeriod");
	myary[9]="AppBreakLimit"+"!"+DHCWebD_GetObjValue("AppBreakLimit");
	myary[10]="RegFeeBillSub"+"!"+RegFeeBillSub;
	myary[11]="CheckFeeBillSub"+"!"+CheckFeeBillSub;
	myary[12]="AppFeeBillSub"+"!"+AppFeeBillSub;
	myary[13]="HoliFeeBillSub"+"!"+HoliFeeBillSub;
	myary[14]="AppStartTime"+"!"+DHCWebD_GetObjValue("AppStartTime");
	myary[15]="RegStartTime"+"!"+DHCWebD_GetObjValue("RegStartTime");
	myary[16]="AddStartTime"+"!"+DHCWebD_GetObjValue("AddStartTime");
	myary[17]="DayRegCountLimit"+"!"+DHCWebD_GetObjValue("DayRegCountLimit");
	myary[18]="DaySameDocRegCountLimit"+"!"+DHCWebD_GetObjValue("DaySameDocRegCountLimit");
	myary[19]="CommonCardNo"+"!"+DHCWebD_GetObjValue("CommonCardNo");
	
	var IFScreenStartV=DHCWebD_GetObjValue("IFScreenStart");
	if (IFScreenStartV==true){myary[20]=1;}else{myary[20]=0;}	
	myary[20]="IFScreenStart"+"!"+myary[20];

	var IFScreenStartV=DHCWebD_GetObjValue("IFTeleAppStart");
	if (IFScreenStartV==true){myary[21]=1;}else{myary[21]=0;}	
	myary[21]="IFTeleAppStart"+"!"+myary[21];
	myary[22]="MRArcimId"+"!"+DHCWebD_GetObjValue("getorderid")+'@'+DHCWebD_GetObjValue("order");
	myary[23]="OldManFree"+"!"+OldManFree;
	myary[24]="ReCheckFeeBillSub"+"!"+ReCheckFeeBillSub;
	myary[25]="NeedBillCardFeeOrder"+"!"+DHCWebD_GetObjValue("NeedBillCardFeeOrderID")+'@'+DHCWebD_GetObjValue("NeedBillCardFeeOrder");
	myary[26]="FreeOrder"+"!"+DHCWebD_GetObjValue("FreeOrderID")+'@'+DHCWebD_GetObjValue("FreeOrder");
	myary[27]="ReturnNotAllowReg"+"!"+(eval(DHCWebD_GetObjValue("ReturnNotAllowReg"))==true?1:0);
	myary[28]="ReturnNotAllowAdd"+"!"+(eval(DHCWebD_GetObjValue("ReturnNotAllowAdd"))==true?1:0);
	myary[29]="NotNullRealAmount"+"!"+(eval(DHCWebD_GetObjValue("NotNullRealAmount"))==true?1:0);
	myary[30]="NotNeedNotFeeBill"+"!"+(eval(DHCWebD_GetObjValue("NotNeedNotFeeBill"))==true?1:0);
	myary[31]="HolidayNotCreateSche"+"!"+(eval(DHCWebD_GetObjValue("HolidayNotCreateSche"))==true?1:0);
	myary[32]="MedifyPatTypeSynAdmRea"+"!"+(eval(DHCWebD_GetObjValue("MedifyPatTypeSynAdmRea"))==true?1:0);
	//增加门诊挂号树状查询 20130425
	myary[33]="RegTreeQuery"+"!"+(eval(DHCWebD_GetObjValue("RegTreeQuery"))==true?1:0);
	//提前取预约号
	myary[34]="AdvanceAppAdm"+"!"+(eval(DHCWebD_GetObjValue("AdvanceAppAdm"))==true?1:0);
	
	//每人每天挂相同科室限额
	myary[35]="DaySameLocRegCountLimit"+"!"+DHCWebD_GetObjValue("DaySameLocRegCountLimit");
	//是否启用挂号医保实时结算
	var EnableInsuBill=0;
	if (combo_EnableInsuBill) EnableInsuBill=combo_EnableInsuBill.getSelectedValue();
	myary[36]="EnableInsuBill"+"!"+EnableInsuBill;
	myary[37]="AppReturnNotAllowRegAdd"+"!"+(eval(DHCWebD_GetObjValue("AppReturnNotAllowRegAdd"))==true?1:0);
	
	if (combo_RBCServiceGroup) RegServiceGroupRowId=combo_RBCServiceGroup.getSelectedValue();
	myary[38]="RegServiceGroup"+"!"+RegServiceGroupRowId;
	//排班模板与医生坐诊信息调整医生科室检索按科室分类(默认按诊区)
	myary[39]="IsHideExaBor"+"!"+(eval(DHCWebD_GetObjValue("IsHideExaBor"))==true?1:0);
	 
	
	var myInfo=myary.join("^");
	return myInfo;
}

function GetLoginLoc (value){
  var Str=value.split("^");
  
  var obj=document.getElementById("LocID");
  obj.value=Str[1]
  //alert(obj.value)
}

document.body.onload = BodyLoadHandler;