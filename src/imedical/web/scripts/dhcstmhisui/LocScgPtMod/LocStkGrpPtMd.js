var init = function() {
	var HospId = gHospId;
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('ScgPtModTB');
				Query();
			};
		}
		Query();
	}
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			PhaLocBox.clear();
			var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams;
			PhaLocBox.reload(url);
		}
	});
	
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = StkLocGrpGrid.getRows();
				var row = rows[StkLocGrpGrid.editIndex];
				row.LocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var PtModCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPrintRules&ResultSetType=array',
			mode: 'remote',
			valueField: 'Code',
			textField: 'Code'
		}
	};
	var ScgData = $.cm({
		ClassName: 'web.DHCSTMHUI.Util.StkGrp',
		MethodName: 'GetScgChildNode',
		NodeId: 'AllSCG',
		StrParam: gLocId + '^' + gUserId + '^^^' + gHospId + '^' + StkGrpHospid,
		Type: 'M'
	}, false);
	var StkGrpBox = {
		type: 'combotree',
		options: {
			data: ScgData,
			required: true,
			valueField: 'id',
			textField: 'text',
			onSelect: function(record) {
				var rows = StkLocGrpGrid.getRows();
				var row = rows[StkLocGrpGrid.editIndex];
				row.StkGrpDesc = record.text;
			},
			onShowPanel: function() {
				$(this).combotree('reload');
			}
		}
	};
	/*
	var StkGrpBox = {
		type: 'combotree',
		options: {
			//data:ScgData,
			required:true,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var rows =StkLocGrpGrid.getRows();
				var row = rows[StkLocGrpGrid.editIndex];
				row.StkGrpDesc=record.Description;
			},
			onShowPanel:function(){
				var Params=gLocId+"^"+gUserId+"^^^"+gHospId+"^"+HospId;
				$(this).combobox('clear');
				var url = $URL+ '?ClassName=web.DHCSTMHUI.Util.StkGrp&QueryName=GetScgChildNode&ResultSetType=Array&NodeId='+"AllSCG"+"&Type="+"M"+"&StrParam="+Params;
				$(this).combobox('reload',url);
			}
		}
	};*/
	function Query() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('ScgPtModTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		StkLocGrpGrid.load({
			ClassName: 'web.DHCSTMHUI.StkLocGrp',
			QueryName: 'QueryPtMod',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			StkLocGrpGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = StkLocGrpGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkLocGrp',
				MethodName: 'SavePtMod',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					StkLocGrpGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			Delete();
		}
	});
	function Delete() {
		var Rows = StkLocGrpGrid.getSelectedData();
		if (Rows == false) {
			StkLocGrpGrid.commonDeleteRow();
			return false;
		}
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要删除的信息!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.StkLocGrp',
			MethodName: 'DeletePtMod',
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				StkLocGrpGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var StkLocGrpCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '科室名称',
			field: 'LocId',
			width: 200,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox
		}, {
			title: '类组',
			field: 'StkGrpId',
			width: 200,
			formatter: CommonFormatter(StkGrpBox, 'StkGrpId', 'StkGrpDesc'),
			editor: StkGrpBox
		}, {
			title: '打印类型',
			field: 'PtModID',
			width: 200,
			formatter: CommonFormatter(PtModCombox, 'PtModID', 'PtModDesc'),
			editor: PtModCombox
		}
	]];
	var StkLocGrpGrid = $UI.datagrid('#StkLocGrpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkLocGrp',
			QueryName: 'QueryPtMod',
			query2JsonStrict: 1
		},
		columns: StkLocGrpCm,
		toolbar: '#ScgPtModTB',
		checkField: 'LocId',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			StkLocGrpGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);