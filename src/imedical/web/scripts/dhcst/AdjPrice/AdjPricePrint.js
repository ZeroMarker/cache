// /����: ���۵���ӡ
// /����: ���۵���ӡ
// /��д�ߣ�yunhaibao
// /��д����: 2015.12.01

/*
 * creator:yunhaibao
 * createdate:2015-12-01
 * description:��ӡ�������۵�����Ǭ��
 * params: ingr:���۵���
 * return:
 * */
function PrintAdjPrice(adjpriceno){
	if(adjpriceno==null || adjpriceno==''){
		Msg.info("warning","��ѡ����۵����ӡ!");
		return;
	}
	var RQDTFormat=App_StkRQDateFormat; //+" "+App_StkRQTimeFormat;
	var printtype=1;
	/*if (printtype==1) {
		//ֱ�Ӵ�ӡ
		fileName="{DHCST_InAdjSalePrice_Common.raq(AspNo="+adjpriceno+";HospDesc="+App_LogonHospDesc+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	else {
		//Ԥ����ӡ	
		fileName="DHCST_InAdjSalePrice_Common.raq&AspNo="+adjpriceno+"&HospDesc="+App_LogonHospDesc;
		DHCCPM_RQPrint(fileName);
	}*/
	if (printtype==1) {
		//ֱ�Ӵ�ӡ
		fileName="{DHCST_InAdjSalePrice_Common.raq(AspNo="+adjpriceno+";HospDescIO="+session['LOGON.HOSPID']+";RQDTFormat="+RQDTFormat+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
	else {
		//Ԥ����ӡ	
		fileName="DHCST_InAdjSalePrice_Common.raq&AspNo="+adjpriceno+"&HospDescIO="+session['LOGON.HOSPID']+"&RQDTFormat="+RQDTFormat;
		DHCCPM_RQPrint(fileName);
	}



}

