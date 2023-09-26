function PrintPayMon(growid,activeTabtmp){
	if (isEmpty(growid)) {
		return false;
	}
	if(activeTabtmp=="付款月报明细"){
		fileName="{DHCSTM_HUI_PayMonDetailRp_Common.raq(growid="+growid+")}";
	}else{
		fileName="";
		$UI.msg('alert',"请使用报表上面的打印功能!");
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