// /名称: 付款单打印
// /描述: 付款单打印
// /编写者：zhangxiao
// /编写日期: 2013.6.15

/*
 * creator:zhangxiao,2013-06-15
 * description:打印单个付款单（润乾）
 * params: ingr:付款单主表id
 * return:*/

 
function PrintPay(pay){
	if(pay==null||pay==''){
		return;
		}
	var mainData=GetMainData(pay);	
	if(mainData==null || mainData==""){
		return;
	}	
	var mainArr=mainData.split("^");
	var Vendor=mainArr[1]
    var payNo=mainArr[0]
    var payDate=mainArr[4]
    var payTime=mainArr[5]
    var payLoc=mainArr[2]
    var userName=mainArr[3]
    var ack1UserName=mainArr[14]  //采购确认
    var ack2UserName=mainArr[15]   //会计确认
    //直接打印
    var RQDTFormat=App_StkRQDateFormat;  //+" "+App_StkRQTimeFormat;
    //fileName="{DHCST_Pay_Common.raq(pay="+pay+";Vendor="+Vendor+";payNo="+payNo+";payDate="+payDate+";payTime="+payTime+";payLoc="+payLoc+";userName="+userName+";ack1UserName="+ack1UserName+";ack2UserName="+ack2UserName+";HospDesc="+App_LogonHospDesc+";RQDTFormat="+RQDTFormat+")}";
	fileName="{DHCST_Pay_Common.raq(pay="+pay+";RQDTFormat="+RQDTFormat+")}";  //";Vendor="+Vendor+";payNo="+payNo+";payDate="+payDate+";payTime="+payTime+";payLoc="+payLoc+";userName="+userName+";ack1UserName="+ack1UserName+";ack2UserName="+ack2UserName+";HospDesc="+App_LogonHospDesc+";RQDTFormat="+RQDTFormat+")}";

	
	DHCCPM_RQDirectPrint(fileName);
	//预览打印
	//fileName="DHCST_Pay_Common.raq&pay="+pay+"&Vendor="+Vendor+"&payNo="+payNo+"&payDate="+payDate+"&payTime="+payTime+"&payLoc="+payLoc+"&userName="+userName+"&ack1UserName="+ack1UserName+"&ack2UserName="+ack2UserName+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
	//DHCCPM_RQPrint(fileName)
	
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

	var url='dhcst.payaction.csp?actiontype=Select&pay='+pay;
	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	//alert(mainData)
	return mainData;
}
