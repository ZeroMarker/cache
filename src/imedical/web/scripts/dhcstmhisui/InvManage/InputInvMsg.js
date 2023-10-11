var ToolBar, InvMainCm, InvDetailCm, InvMainGrid, InvDetailGrid;
var init = function() {
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var MainToolBar = [{
		text: '�ϴ�',
		iconCls: 'icon-upload-cloud',
		handler: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ�ϴ�ͼƬ�ķ�Ʊ��Ϣ!');
				return;
			}
			var RowId = Row.RowId;
			var VendorId = Row.VendorId;
			if (RowId == '') {
				$UI.msg('alert', '��ѡ��Ҫ�ϴ�ͼƬ�ķ�Ʊ��Ϣ!');
				return;
			}
			UpLoadFileWin('Vendor', VendorId, 'Inv', 'Inv', RowId, '');
		}
	},
	{
		text: '����',
		iconCls: 'icon-camera',
		handler: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ�ϴ�ͼƬ�ķ�Ʊ��Ϣ!');
				return;
			}
			var RowId = Row.RowId;
			var VendorId = Row.VendorId;
			if (RowId == '') {
				$UI.msg('alert', '��ѡ��Ҫ�ϴ�ͼƬ�ķ�Ʊ��Ϣ!');
				return;
			}
			TakePhotoWin('Vendor', VendorId, 'Inv', 'Inv', RowId, '');
		}
	}];
	InvMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'Ԥ��',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="�鿴ͼƬ" href="#" onclick="ViewFile(' + index + ')"></div>';
				return str;
			}
		}, {
			title: 'VendorId',
			field: 'VendorId',
			width: 50,
			hidden: true,
			saveCol: true
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 180
		}, {
			title: 'LocId',
			field: 'LocId',
			width: 180,
			saveCol: true,
			hidden: true
		}, {
			title: '����',
			field: 'LocDesc',
			width: 180
		}, {
			title: '��Ͻ���',
			field: 'RpAmt',
			width: 100,
			align: 'right',
			saveCol: true
		}, {
			title: '��Ʊ����',
			field: 'InvCode',
			width: 180,
			editor: {
				type: 'text'
			},
			saveCol: true
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 180,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '¼����',
			field: 'CreateUserName',
			width: 120
		}, {
			title: '¼������',
			field: 'CreateDate',
			width: 120
		}, {
			title: '¼��ʱ��',
			field: 'CreateTime',
			width: 80
		}, {
			title: '��ɱ�־',
			field: 'CompFlag',
			align: 'center',
			width: 100
		}, {
			title: '��˱�־',
			field: 'FilledFlag',
			align: 'center',
			width: 100
		}
	]];

	InvMainGrid = $UI.datagrid('#InvMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetInvInfo',
			query2JsonStrict: 1
		},
		columns: InvMainCm,
		showBar: true,
		toolbar: MainToolBar,
		onSelect: function(index, row) {
			QueryDetail(row.RowId);
		},
		onClickRow: function(index, row) {
			InvMainGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InvMainGrid.selectRow(0);
			}
		},
		onBeginEdit: function(index, row) {
			$(this).datagrid('beginEdit', index);
			var ed = $(this).datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InvCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var RowIndex = InvMainGrid.editIndex;
							var InvInfo = $(this).val();
							if (!isEmpty(InvInfo)) {
								var InvObj = GetInvInfo(InvInfo);
								if (InvObj === false) {
									$UI.msg('alert', '��¼����ȷ�ķ�Ʊ��Ϣ!');
									$(this).val('');
									$(this).focus();
									InvMainGrid.stopJump();
									return false;
								}
								if (!isEmpty(InvObj)) {
									var InvCode = InvObj.InvCode;
									var InvNo = InvObj.InvNo;
									var InvAmt = InvObj.InvAmt;
									var InvDate = InvObj.InvDate;
									InvMainGrid.updateRow({
										index: RowIndex,
										row: {
											InvCode: InvCode,
											InvNo: InvNo,
											InvAmt: InvAmt,
											InvDate: InvDate
										}
									});
								}
							}
						}
					});
				}
			}
		}
	});

	InvDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true,
			saveCol: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 50,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 150
		}, {
			title: '��������',
			field: 'Description',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 40
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '��������',
			field: 'Manf',
			width: 120
		}, {
			title: '����',
			field: 'Type',
			width: 50,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '���';
				} else {
					return '�˻�';
				}
			}
		}, {
			title: '����',
			field: 'IngrNo',
			width: 120
		}
	]];

	InvDetailGrid = $UI.datagrid('#InvDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'DHCVendorInvItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: InvDetailCm,
		showBar: true,
		fitColumns: true
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (!isEmpty(StartDate) && !isEmpty(EndDate) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '�������ڲ���С�ڿ�ʼ����!');
			return;
		}
		ParamsObj.CompFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(InvDetailGrid);
		InvMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetInvInfo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function QueryDetail(InvRowId) {
		InvDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'DHCVendorInvItm',
			query2JsonStrict: 1,
			Inv: InvRowId,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(InvMainGrid);
			$UI.clear(InvDetailGrid);
			SetDefaValues();
		}
	});
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ��ӡ�ķ�Ʊ��Ϣ!');
				return;
			}
			PrintInv(Row.RowId);
		}
	});
	
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ��˵ķ�Ʊ��Ϣ!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			var FilledFlag = Row.FilledFlag;
			var InvNo = Row.InvNo;
			var InvAmt = Row.InvAmt;
			var RpAmt = Row.RpAmt;
			if (CompFlag != 'Y') {
				$UI.msg('alert', '��Ʊδ��ɣ��������!');
				return;
			}
			if (FilledFlag == 'Y') {
				$UI.msg('alert', '��Ʊ����ˣ������ظ����!');
				return;
			}
			if (isEmpty(InvNo)) {
				$UI.msg('alert', '��Ʊ��Ϊ��,�������!');
				return;
			}
			if (!isEmpty(InvAmt) && RpAmt != InvAmt) {
				$UI.msg('alert', '��Ʊ�������Ͻ��۲�һ��,�������!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsAuditInvInfo',
				Inv: InvRowId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var DetailObj = InvMainGrid.getChangesData('RowId');
			if (DetailObj === false) {
				return false;
			}
			if (isEmpty(DetailObj) || DetailObj.length == 0) {
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return false;
			}
			for (var i = 0; i < DetailObj.length; i++) {
				var RpAmt = DetailObj[i].RpAmt;
				var InvAmt = DetailObj[i].InvAmt;
				var LeftAmt = accSub(Number(InvAmt), Number(RpAmt));
				if (!isEmpty(InvAmt) && Number(InvAmt) == 0) {
					// δά����Ʊ����,�ݲ�������
					$UI.msg('alert', '��' + (i + 1) + '�е�ǰ��Ʊ������0,��ע���ʵ!');
					return;
				}
				if (!isEmpty(InvAmt) && Number(RpAmt) > Number(InvAmt)) {
					// δά����Ʊ����,�ݲ�������
					$UI.msg('alert', '��' + (i + 1) + '�е�ǰ��Ʊ���С�ڵ�����Ͻ���,��ע���ʵ!');
					return;
				}
			}
			var Detail = JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsSave',
				ListData: Detail
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
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫȡ����˵ķ�Ʊ��¼!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			var FilledFlag = Row.FilledFlag;
			if (CompFlag != 'Y') {
				$UI.msg('alert', '��Ʊδ��ɣ�����ȡ�����!');
				return;
			}
			if (FilledFlag != 'Y') {
				$UI.msg('alert', '��Ʊδ��ˣ�����ȡ�����!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsCancelAudit',
				InvId: InvRowId
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
	});
	$UI.linkbutton('#SendBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���͵ķ�Ʊ��Ϣ!');
				return;
			}
			if (Row.FilledFlag != 'Y') {
				$UI.msg('alert', '��ѡ������˵ķ�Ʊ��Ϣ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForECS',
				MethodName: 'updateInvState',
				InvId: Row.RowId
			}, function(jsonData) {
				$UI.msg('success', '���ͳɹ�');
			});
		}
	});
	function SetDefaValues() {
		var DefaultValue = {
			FilledFlag: 'N',
			IngrLoc: gLocObj,
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		if (SerUseObj.ECS == 'Y') {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}

	SetDefaValues();
	Query();
};
$(init);
function ViewFile(index) {
	var RowData = InvMainGrid.getRows()[index];
	var OrgType = 'Vendor';
	var OrgId = RowData.VendorId;
	var RowId = RowData.RowId;
	ViewFileWin(OrgType, OrgId, 'Inv', 'Inv', RowId, '', '');
}