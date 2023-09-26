// /名称: 付款单打印
// /描述: 付款单打印
// /编写者：zhangxiao
// /编写日期: 2013.6.15

/*
 * creator:zhangxiao,2013-06-15
 * description:打印单个付款单（润乾）
 * params: ingr:付款单主表id
 * return:*/
var PayParamObj = GetAppPropValue('DHCSTPAYM');

function PrintPay(pay){
	if(pay==null||pay==''){
		return;
	}
	var mainData=GetMainData(pay);	
	if(mainData==null || mainData==""){
		return;
	}	
	var mainArr=mainData.split("^");
	var Vendor=mainArr[23]
    var payNo=mainArr[1]
    var payDate=mainArr[4]
    var payTime=mainArr[5]
    var payLoc=mainArr[24]
    var userName=mainArr[20]
    var ack1UserName=mainArr[21]  //采购确认
    var ack2UserName=mainArr[22]   //会计确认
    
	fileName="{DHCSTM_Pay_Common.raq(pay="+pay+";Vendor="+Vendor+";payNo="+payNo+";payDate="+payDate+";payTime="+payTime+";payLoc="+payLoc+";userName="+userName+";ack1UserName="+ack1UserName+";ack2UserName="+ack2UserName+";HospDesc="+App_LogonHospDesc+")}";
	if(PayParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}
	
/*
 * creator:zhangxiao,2013-06-15
 * description:取付款主表信息
 * params: ingr:付款主表id
 * return:
 * */
function GetMainData(pay){
	var mainData="";
	if(pay==null || pay==''){
		return;
	}
	var url='dhcstm.payaction.csp?actiontype=Select&pay='+pay;	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	return mainData;
}
/*
 * creator: tsr,2015-04-02
 * description: 打印发票组合主表信息
 * params: inv:发票组合主表id
 * */
function Printinv(inv){
	if(inv==null||inv==''){
		return;
	}
	var mainData=GetMainInvData(inv);	
	if(mainData==null || mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var Vendor=mainArr[3]
    var AssemNo=mainArr[1]
    var invDate=mainArr[6]
    var invTime=mainArr[7]
    var invLoc=mainArr[9]
    var userName=mainArr[5]
	var InvNo=mainArr[12]
	
    fileName="{DHCSTM_Inv_Common.raq(inv="+inv+";Vendor="+Vendor+";AssemNo="+AssemNo+";invDate="+invDate+";invTime="+invTime+";invLoc="+invLoc+";userName="+userName+";InvNo="+InvNo+";HospDesc="+App_LogonHospDesc+")}";
	if(PayParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
	}
/*
 * creator: tsr,2015-04-02
 * description: 取发票组合主表信息
 * params: inv:发票组合主表id
 * */
function GetMainInvData(inv){
	var mainData="";
	if(inv==null || inv==''){
		return;
	}
	var url='dhcstm.vendorinvaction.csp?actiontype=Select&inv='+inv;	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	return mainData;
}