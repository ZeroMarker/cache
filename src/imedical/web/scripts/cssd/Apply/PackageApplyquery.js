var init = function() {
	// �������
	var ReqLocParams;
	if (ApplyParamObj.IfAllLoc == 'Y') {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	} else {
		ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	}
	var ReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	var SupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function(data) { // Ĭ�ϵ�һ��ֵ
			if (data.length === 1) {
				$('#FSupLoc').combobox('setValue', data[0].RowId);
			}
		}
	});
	$HUI.combobox('#ReqType', {
		valueField: 'RowId',
		textField: 'Description',
		data: ReqTypeAllData
	});
	$HUI.combobox('#ReqStatus', {
		valueField: 'RowId',
		textField: 'Description',
		data: ReqStatusAllData
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			if (isEmpty($('#FReqLoc').combobox('getValue'))) {
				$UI.msg('alert', '������Ҳ���Ϊ�գ�');
				return;
			}
			QueryApply();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearDrugInfo();
		}
	});
	
	function QueryApply() {
		$UI.clear(ItemListGrid);
		$UI.clear(MainListGrid);
		$('#ApplyVStep')[0].innerHTML = '';
		var ParamsObj = $UI.loopBlock('#MainCondition');
		ParamsObj.DateType = '2';
		if (isEmpty(ParamsObj.FStartDate)) {
			$UI.msg('alert', '��ʼ����Ϊ��!');
			return;
		} else if (isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '��ֹ����Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	function ClearDrugInfo() {
		$UI.clearBlock('#MainCondition');
		SupLocBox.reload();
		ReqLocBox.reload();
		$UI.fillBlock('#MainCondition', Default);
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		$('#ApplyVStep')[0].innerHTML = '';
	}
	
	function GetDetail(ApplyMainId) {
		$('#ApplyVStep').vstep({
			items: []
		});
		$('#ApplyVStep')[0].innerHTML = '';
		
		if (isEmpty(ApplyMainId)) {
			return;
		}
		var StatusArray = $.cm({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			MethodName: 'GetApplyStatusById',
			ApplyMainId: ApplyMainId
		}, false);
		
		$('#ApplyVStep').hstep({
			stepWidth: 200,
			titlePostion: 'top',
			currentInd: StatusArray.length,
			items: StatusArray
		});
	}
	
	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'No',
			width: 120
		}, {
			title: '�������',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '�ܾ�ԭ��',
			field: 'RefuseReason',
			width: 150
		}, {
			title: '��������',
			field: 'ReqTypeDesc',
			width: 100
		}, {
			title: '����״̬',
			field: 'ReqFlag',
			formatter: ReqStatusRenderer,
			width: 100
		}, {
			title: '�����̶�',
			field: 'ReqLevelDesc',
			width: 100
		}, {
			title: '�ύ��',
			field: 'commitUser',
			width: 100
		}, {
			title: '�ύʱ��',
			field: 'commitDate',
			width: 150
		}, {
			title: '�Ƶ���',
			field: 'CreateUser',
			width: 100
		}
	]];
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll'
		},
		columns: MainCm,
		sortName: 'No',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#MainList').datagrid('selectRow', 0);
				var Row = MainListGrid.getRows()[0];
				var RowId = Row.RowId;
				GetDetail(RowId);
			}
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				ItemListGrid.load({
					ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
					QueryName: 'SelectByF',
					ApplyId: Id,
					rows: 9999
				});
			}
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
			var RowId = row.RowId;
			GetDetail(RowId);
		}
	});
	
	var ItemCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '����������',
			field: 'PackageName',
			width: 200
		}, {
			title: '����',
			field: 'Qty',
			align: 'right',
			width: 100
		}, {
			title: '��ע',
			field: 'Remark',
			width: 200
		}, {
			title: '������Ϣ',
			field: 'RemarkInfo',
			width: 110
		}
	]];
	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			MethodName: 'SelectByF'
		},
		columns: ItemCm,
		fitColumns: true,
		pagination: false,
		singleSelect: false
	});

	var Default = {
		FReqLoc: gLocObj,
		FStartDate: DefaultStDate(),
		FEndDate: DefaultEdDate()
	};
	$UI.fillBlock('#MainCondition', Default);
	
	QueryApply();
};
$(init);