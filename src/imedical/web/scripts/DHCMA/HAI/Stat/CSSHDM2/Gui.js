function InitCSSHDM2Win(){
	var obj = new Object();
	$.parser.parse();
	
	//ҽԺ
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	
		//���ص��鷽ʽ������
	$HUI.combobox("#cboSurvNumber",{
		url:$URL+'?ClassName=DHCHAI.IRS.INFCSSSrv&QueryName=QueryByCode&ResultSetType=Array&aHospIDs='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'SESurvNumber',
		onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboSurvNumber').combobox('select',data[0].ID);
		}
	});
	///���ظ�Ⱦ����
	$HUI.combobox("#cboInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode='+"IRCSSINFTYPE",
		valueField:'ID',
		textField:'DicDesc',
		
	});
	
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit",
		aHospDr: $.LOGON.HOSPID
	},false);
	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
		}
	}
	InitCSSHDM2WinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}