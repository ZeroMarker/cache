function PrintPayMon(growid,activeTabtmp){
	if (isEmpty(growid)) {
		return false;
	}
	if(activeTabtmp=="�����±���ϸ"){
		fileName="{DHCSTM_HUI_PayMonDetailRp_Common.raq(growid="+growid+")}";
	}else{
		fileName="";
		$UI.msg('alert',"��ʹ�ñ�������Ĵ�ӡ����!");
	}
	if(fileName!=""){
		var fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
}

function GetPayMonMain(growid){
	if (isEmpty(growid)) {
		return false;
	}
	var mainData=tkMakeServerCall("web.DHCSTMHUI.DHCPayMon","GetPayMonMain",growid);
	
	return mainData;
}