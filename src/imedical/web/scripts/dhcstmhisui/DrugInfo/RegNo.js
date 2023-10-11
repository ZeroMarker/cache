// ����:ע��֤��
// ��д����:2019-08-28
var RegId = '';
function RegNoInfo(regNo, ParamStr, DisableButtonFlag) {
	$HUI.dialog('#RegNo', { width: gWinWidth, height: gWinHeight }).open();
	
	$HUI.combobox('#MRCCategory', {
		data: [
			{
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
	$HUI.combobox('#MRCManf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ StkType: 'M', BDPHospital: GetHospId() })),
		valueField: 'RowId',
		textField: 'Description'
	});
	function Query() {
		$UI.clearBlock('#RegNo');
		$UI.clear(RegNoHistoryGrid);
		$('#MRCNo').attr('disabled', 'disabled');
		var Inci = ParamStr.split('^')[0];
		var ManfId = ParamStr.split('^')[1];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
			MethodName: 'getByRegNo',
			No: regNo
		}, function(jsonData) {
			$UI.fillBlock('#RegNo', jsonData);
			if (isEmpty(jsonData.MRCNo)) {
				$('#MRCNo').val(regNo);
			}
			RegId = jsonData.MRCRowID;
		});
		RegNoHistoryGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
			QueryName: 'QueryInciRegHistory',
			query2JsonStrict: 1,
			Inci: Inci
		});
	}
	
	function DeleteRelation() {
		var Row = RegNoHistoryGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '��ѡ��һ��ע��֤��Ϣ!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
			MethodName: 'jsDeleteRelation',
			RowId: Row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#SaveRegNoBT', {
		disabled: !!DisableButtonFlag,
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#RegNo');
			var StartDate = ParamsObj.MRCApprovalDate;
			var EndDate = ParamsObj.MRCValidUntil;
			if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			var MRCRowID = ParamsObj.MRCRowID;
			var RelaFlag = '';
			if ((!isEmpty(MRCRowID)) && (!isEmpty(RegId))) {
				$.messager.confirm3('��ʾ', '������Ѵ���ע��֤�������Ƿ����¹���?', function(r) {
					if (true === r) {
						RelaFlag = 'Y';
						SaveRegInfo(Params, ParamStr, RelaFlag);
					} else if (false === r) {
						RelaFlag = 'N';
						SaveRegInfo(Params, ParamStr, RelaFlag);
					} else {
						return false;
					}
				});
			} else {
				SaveRegInfo(Params, ParamStr, 'Y');
			}
		}
	});
	function SaveRegInfo(Params, ParamStr, RelaFlag) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
			MethodName: 'jsSave',
			Params: Params,
			ParamStr: ParamStr,
			RelaFlag: RelaFlag
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				if (RelaFlag == 'Y') {
					SetDrugRegInfo();
					$HUI.dialog('#RegNo').close();
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var RegNoHistoryCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'MRCRowID',
			field: 'MRCRowID',
			width: 100,
			hidden: true
		}, {
			title: 'ע��֤��',
			field: 'MRCNo',
			width: 180
		}, {
			title: '��������',
			field: 'MRCManfDesc',
			width: 150
		}, {
			title: '��Ч����',
			field: 'MRCValidUntil',
			width: 100
		}, {
			title: 'ע��֤�ӳ�Ч��',
			field: 'MRCValidExtend',
			width: 150
		}, {
			title: 'ע��֤����',
			field: 'MRCCategory',
			width: 100
		}, {
			title: 'ע��������',
			field: 'MRCRegName',
			width: 100
		}, {
			title: 'ע����ס��',
			field: 'MRCRegPerAddress',
			width: 100
		}, {
			title: '����������',
			field: 'MRCRegAgent',
			width: 100
		}, {
			title: '������ס��',
			field: 'MRCAgentAddress',
			width: 100
		}, {
			title: '��Ʒ����',
			field: 'MRCInciDesc',
			width: 100
		}, {
			title: '����ͺ�',
			field: 'MRCSpecForm',
			width: 100
		}, {
			title: '�ṹ�����',
			field: 'MRCStructure',
			width: 100
		}, {
			title: '���÷�Χ',
			field: 'MRCAppliedRange',
			width: 100
		}, {
			title: '��ע',
			field: 'MRCRemark',
			width: 100
		}, {
			title: '��׼����',
			field: 'MRCApprovalDate',
			width: 100
		}
	]];
	
	var RegNoHistoryGrid = $UI.datagrid('#RegNoHistoryGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
			QueryName: 'QueryInciRegHistory',
			query2JsonStrict: 1
		},
		/*
		toolbar:[
			{
				text: '�������',
				iconCls: 'icon-save',
				handler: function () {
					DeleteRelation();
				}
			}
		],
		*/
		columns: RegNoHistoryCm,
		onClickRow: function(index, row) {
			RegNoHistoryGrid.commonClickRow(index, row);
			var MRCNo = row['MRCNo'];
			setRegInfo(MRCNo);
		}
	});
	Query();
}

function SetDrugRegInfo() {
	$('#RegNoId').val($('#MRCRowID').val());
	$('#RegCertNo').val($('#MRCNo').val());
	$('#RegCertExpDate').dateboxq('setValue', $('#MRCValidUntil').dateboxq('getValue'));
	$('#RegCertDate').dateboxq('setValue', $('#MRCApprovalDate').dateboxq('getValue'));
	$('#RegItmDesc').val($('#MRCInciDesc').val());
	$('#RegSpecNum').val($('#MRCSpecForm').val());
	$HUI.checkbox('#RegCertExpDateExtended').setValue($HUI.checkbox('#MRCValidExtend').getValue());
	$('#ManfBox').combobox('setValue', $('#MRCManf').combobox('getValue'));
}
function setRegInfo(regNo) {
	$UI.clearBlock('#RegNo');
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCMatRegCert',
		MethodName: 'getByRegNo',
		No: regNo
	}, function(jsonData) {
		$UI.fillBlock('#RegNo', jsonData);
		$('#MRCNo').val(regNo);
	});
}