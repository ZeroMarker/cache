// 获取最大码 inci_code
function GetMaxCode() {
	var Clear = function() {
		$UI.clearBlock('#MaxCodeConditions');
		var ScgId = $('#StkGrpBox').combo('getValue');
		var ScgDesc = $('#StkGrpBox').combo('getText');
		var IncscId = $('#StkCatBox').combo('getValue');
		var IncscDesc = $('#StkCatBox').combo('getText');
		
		var DefaData = {
			'StkGrp': { RowId: ScgId, Description: ScgDesc },
			'StkCat': { RowId: IncscId, Description: IncscDesc }
		};
		$UI.fillBlock('#MaxCodeConditions', DefaData);
	};
	$HUI.dialog('#FindMaxCode').open();
	$UI.linkbutton('#FindMaxCodeBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MaxCodeConditions');
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.INCITM',
				MethodName: 'GetMaxCode',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$('#MaxCode').val(jsonData.rowid);
				} else {
					$('#MaxFirCode').val('');
					$('#MaxCode').val('');
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ChoiMaxCodeBT', {
		onClick: function() {
			var MaxCode = $('#MaxCode').val();
			var NewMaxCode = '';	// 新的最大码
			if (MaxCode == '') {
				$UI.msg('alert', '未查询到最大码,请自行维护!');
				$HUI.dialog('#FindMaxCode').close();
				return;
			}
			var CodeLen = MaxCode.length;
			for (var index = 0; index < CodeLen; index++) {
				var subCodeStr = MaxCode.slice(index);
				var num = Number(subCodeStr);
				if (isFinite(num) && Number(num) > 0) {
					break;
				}
			}
			// 生成新的最大码
			if (index == CodeLen) {
				NewMaxCode = MaxCode + '1';
			} else if (index == 0) {
				NewMaxCode = leftPad((num + 1).toString(), '0', CodeLen);
			} else {
				var numLen = CodeLen - index;
				var rightStr = MaxCode.slice(0, index);
				var newLeftCode = leftPad((num + 1).toString(), '0', numLen);
				NewMaxCode = rightStr + newLeftCode;
			}
			$('#InciCode').val(NewMaxCode);
			$('#ArcCode').val(NewMaxCode);
			$('#TariCode').val(NewMaxCode);
			var StkGrp = $('#MaxStkGrp').combotree('getValue');
			var StkCat = $('#MaxStkCat').combobox('getValue');
			var StkCatDesc = $('#MaxStkCat').combobox('getText');
			var StkCatObj = { 'RowId': StkCat, 'Description': StkCatDesc };
			$('#StkGrpBox').combotree('setValue', StkGrp);
			AddComboData($('#StkCatBox'), StkCat, StkCatDesc);
			$('#StkCatBox').combobox('setValue', StkCat);
			$HUI.dialog('#FindMaxCode').close();
		}
	});
	$('#MaxStkGrp').stkscgcombotree({
		onSelect: function(node) {
			$('#MaxStkCat').combobox('setValue', '');
			$('#MaxStkCat').combobox('setText', '');
		}
	});
	/*
	$HUI.lookup('#MaxStkCat', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetStkCat',
			Params: JSON.stringify(addSessionParams())
		},
		onBeforeLoad: function(param) {
			var StkGrpId = $('#MaxStkGrp').combobox('getValue');
			param['StkGrpId'] = StkGrpId;
		}
	});
	*/
	$HUI.radio("[name='MaxCodeType']", {
		onChecked: function(e, value) {
			$('#MaxStkGrp').combotree('setValue', '');
			$('#MaxStkCat').combobox('setValue', '');
			$('#MaxStkCat').combobox('setText', '');
			$('#MaxFirCode').val('');
			$('#MaxCode').val('');
			var MaxCodeType = $("input[name='MaxCodeType']:checked").val();
			if (MaxCodeType == 'Cat') {
				$('#MaxStkGrp').combotree('enable');
				$('#MaxStkCat').combobox('enable');
				$('#MaxFirCode').attr('disabled', 'disabled');
			} else {
				$('#MaxStkGrp').combotree('disable');
				$('#MaxStkCat').combobox('disable');
				$('#MaxFirCode').removeAttr('disabled');
			}
		}
	});
	
	Clear();
}