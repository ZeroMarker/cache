//���ⵥ����ȷ��
function VerifyPassWord(VerifyObj, Fn){
	var VerifyLocId = VerifyObj['LocId'];
	var VerifyUserId = VerifyObj['UserId'];
	var VerifyUserCode = VerifyObj['UserCode'];
	var gVerifyUserId = '';		//ȷ����id

	$.extend($.fn.validatebox.defaults.rules, {
		ValidUser: {
			validator: function(value, param){
				var VerifyLocId = param[0];
				gVerifyUserId = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetDeptUserId', VerifyLocId, value);
				return isEmpty(gVerifyUserId)? false : true;
			},
			message: '�Ǳ�������Ա!'
		}
	});
	
	var VerifyUser = $HUI.validatebox('#VerifyUser', {
		validType: 'ValidUser[' + VerifyLocId + ']'
	});
	$('#VerifyUser').bind('blur',function(){
		$('#VerifyUser').validatebox('isValid');
	}).bind('keydown', function(event){
		if(event.keyCode == 13){
			$('#VerifyPassWord').focus();
		}
	});
	
	$('#VerifyPassWord').bind('keyup', function(){
		if(gVerifyUserId == ''){
			$UI.msg('alert', '�û���������!')
			return false;
		}
		var PassWord = $(this).val();
		var IsOK = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','CheckPassword',gVerifyUserId,PassWord);
		if(IsOK == '1'){
			$('#VerifyYes').linkbutton('enable');
			$('#VerifyUser').attr('readonly', true);
		}else{
			$('#VerifyYes').linkbutton('disable');
			$('#VerifyUser').attr('readonly', false);
		}
	}).bind('keydown', function(event){
		if(event.keyCode == 13){
			if(!$('#VerifyYes').linkbutton('options').disabled){
				VerifyYes.handler();
			}
		}
	});

	var VerifyYes = {
		id: 'VerifyYes',
		iconCls: 'icon-w-stamp',
		text: 'ȷ��',
		disabled: true,
		handler: function(){
			if(gVerifyUserId == ''){
				$UI.msg('error', 'ǩ����Ϣ����!');
				return false;
			}
			Fn(gVerifyUserId);
			$HUI.dialog('#VerifyPassWordWin').close();
		}
	};
	
	var VerifyClear = {
		iconCls: 'icon-w-clean',
		text : '���',
		handler : function() {
			gVerifyUserId = '';
			$('#VerifyUser').val('');
			$('#VerifyPassWord').val('');
			$('#VerifyUser').attr('readonly', false);
		}
	};
	
	
	$HUI.dialog('#VerifyPassWordWin', {
		width: 300,
		height: 200,
		buttons: [VerifyYes, VerifyClear],
		onOpen: function(){
			VerifyClear.handler();
			if(!isEmpty(VerifyUserId) && !isEmpty(VerifyUserCode)){
				$('#VerifyUser').val(VerifyUserCode);
				gVerifyUserId = VerifyUserId;
			}
		}
	}).open();
}