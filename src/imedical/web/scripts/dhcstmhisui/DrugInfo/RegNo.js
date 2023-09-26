// 名称:注册证号
// 编写日期:2019-08-28
function RegNoInfo(regNo,ParamStr){
	var Clear=function(){
		$UI.clearBlock('#RegNoConditions');
	}
	Clear();
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
		MethodName: 'getByRegNo',
		No: regNo
	}, function (jsonData) {
		$UI.clearBlock('#RegNo');
		$UI.fillBlock('#RegNo', jsonData);
		$("#MRCNo").val(regNo);
	});
	var MRCCategory = $HUI.combobox('#MRCCategory', {
		data: [{
			'RowId': 'I',
			'Description': 'I'
		}, {
			'RowId': 'II',
			'Description': 'II'
		}, {
			'RowId': 'III',
			'Description': 'III'
		}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.dialog('#RegNo').open();
	$UI.linkbutton('#saveRegNoBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#RegNoConditions')
			var Params=JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
				MethodName: 'jsSave',
				Params: Params,
				ParamStr:ParamStr
			},function(jsonData){
				if(jsonData.success==0){
					setRegInfo(regNo);
					$HUI.dialog('#RegNo').close();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});	
		}	
	});	
	$UI.linkbutton('#cancalRegNoBT',{
		onClick:function(){
			$HUI.dialog('#RegNo').close();
		}
	});

}
function setRegInfo (regNo){
	if(isEmpty(regNo)){return;}
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
		MethodName: 'getByRegNo',
		No: regNo
	}, function (jsonData) {
		$UI.clearBlock('#RegNo');
		$UI.fillBlock('#RegNo', jsonData);
		$("#RegNoId").val($("#MRCRowID").val());
		$("#RegCertNo").val(regNo);
		$("#RegCertExpDate").datebox('setValue',$("#MRCValidUntil").datebox('getValue'));
		$("#RegCertDate").datebox('setValue',$("#MRCApprovalDate").datebox('getValue'));
		$("#RegItmDesc").val($("#MRCInciDesc").val());
		if(isEmpty($("#MRCRowID").val())){
			RegNoInfo(regNo,ParamStr)
		}
	});

}