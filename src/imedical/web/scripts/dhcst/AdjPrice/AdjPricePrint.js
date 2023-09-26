// /名称: 调价单打印
// /描述: 调价单打印
// /编写者：yunhaibao
// /编写日期: 2015.12.01

/*
 * creator:yunhaibao
 * createdate:2015-12-01
 * description:打印单个调价单（润乾）
 * params: ingr:调价单号
 * return:
 * */
function PrintAdjPrice(adjpriceno){
	if(adjpriceno==null || adjpriceno==''){
		Msg.info("warning","请选择调价单后打印!");
		return;
	}
	var RQDTFormat=App_StkRQDateFormat; //+" "+App_StkRQTimeFormat;
	var printtype=1;
	/*if (printtype==1) {
		//直接打印
		fileName="{DHCST_InAdjSalePrice_Common.raq(AspNo="+adjpriceno+";HospDesc="+App_LogonHospDesc+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	else {
		//预览打印	
		fileName="DHCST_InAdjSalePrice_Common.raq&AspNo="+adjpriceno+"&HospDesc="+App_LogonHospDesc;
		DHCCPM_RQPrint(fileName);
	}*/
	if (printtype==1) {
		//直接打印
		fileName="{DHCST_InAdjSalePrice_Common.raq(AspNo="+adjpriceno+";HospDescIO="+session['LOGON.HOSPID']+";RQDTFormat="+RQDTFormat+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	else {
		//预览打印	
		fileName="DHCST_InAdjSalePrice_Common.raq&AspNo="+adjpriceno+"&HospDescIO="+session['LOGON.HOSPID']+"&RQDTFormat="+RQDTFormat;
		DHCCPM_RQPrint(fileName);
	}



}

