//CF.BSP.CA.SignCfg.js
var init = function(){
	$("#Save").click(function(){
		var sqn = $("#ScanQRCodeAPPName").val();
		var msc = getValueById("MustSignByUserNotCert");
		var lcs = $("#LogonCALinksNameAndSort").val();
		var isl = getValueById("IsShowCALogonLinks");
		var sqrm= getValueById("ScanQRRollMax");
		var sqri= getValueById("ScanQRRollInterval");
		$cm({
			ClassName:"CF.BSP.CA.DTO.SignModel",
			MethodName:"SaveCACfg",
			ScanQRCodeAPPName:sqn,
			MustSignByUserNotCert:msc?1:0,
			LogonCALinksNameAndSort:lcs,
			IsShowCALogonLinks:isl?1:0,
			ScanQRRollMax:sqrm,
			ScanQRRollInterval:sqri,
			dataType:'text'
		},function(rtn){
			if (rtn==0){
				$.messager.popover({msg: '±£´æ³É¹¦',type:'alert',timeout: 2000});
			}
		})
	});
};
$(init);
