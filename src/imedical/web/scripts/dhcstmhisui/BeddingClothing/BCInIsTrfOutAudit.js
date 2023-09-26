var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj['FrLoc'])){
			$UI.msg('alert', '科室不可为空!');
			return;
		}
		if(isEmpty(ParamsObj['StartDate'])){
			$UI.msg('alert', '起始日期不可为空!');
			return;
		}
		if(isEmpty(ParamsObj['EndDate'])){
			$UI.msg('alert', '截止日期不可为空!');
			return;
		}
		ParamsObj['DateType'] = '1';
		ParamsObj['Comp'] = 'Y';
		ParamsObj['Status'] = '11,30';
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			$UI.clearBlock('Conditions');
			$UI.clear(DetailGrid);
			$UI.clear(MasterGrid);
			SetDefaValues();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function(){
			var SelectedRow = MasterGrid.getSelected();
			if(isEmpty(SelectedRow)){
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var RowId = SelectedRow['RowId'];
			PrintInIsTrfBC(RowId);
		}
	});
	
	$UI.linkbutton('#AutitYesBT', {
		onClick: function(){
			var Sels = MasterGrid.getSelections();
			if(isEmpty(Sels)){
				$UI.msg('alert', '请选择需要审核的单据!');
				return;
			}
			$.messager.confirm('审核', '确定审核选取的单据?', function(r){
				if(r){
					TransOutAuditYes();
				}
			});
		}
	});
	function TransOutAuditYes(){
		var Sels = MasterGrid.getSelections();
		var InitStr = '';
		for(var i = 0, Len = Sels.length; i < Len; i++){
			var InitId = Sels[i]['RowId'];
			if(InitStr == ''){
				InitStr = InitId;
			}else{
				InitStr = InitStr + '^' + InitId;
			}
		}
		if(isEmpty(InitStr)){
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransOutAuditYesStr',
			InitStr: InitStr,
			UserId: gUserId,
			GroupId: gGroupId,
			AutoAuditInFlag:'Y'
		},function(jsonData){
			if(jsonData.success === 0){
				var Ret = jsonData.msg;
				var RetArr = Ret.split(",");
				var InitRetStr = RetArr[0];
				var TotalCnt = RetArr[1];
				var SucessCnt = RetArr[2];
				$UI.msg('success', '共'+TotalCnt+'张单据,成功审核'+SucessCnt+'张单据!');
				if(InitParamObj['AutoPrintAfterAckOut'] == 'Y'){
					var InitArr = InitRetStr.split("^");
					for(var i = 0; i < InitArr.length; i++){
						var Init = InitArr[i];
						var HVflag = GetCertDocHVFlag(Init,"T");
						PrintInIsTrfBC(Init, 'Y');
					}
				}
				Query();
			}else{
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	$UI.linkbutton('#AutitNoBT', {
		onClick: function(){
			var Sels = MasterGrid.getSelections();
			if(isEmpty(Sels)){
				$UI.msg('alert', '请选择需要拒绝的单据!');
				return;
			}
			$.messager.confirm('拒绝', '确定拒绝选取的单据?', function(r){
				if(r){
					TransOutAuditNo();
				}
			});
		}
	});
	
	function TransOutAuditNo(){
		var Sels = MasterGrid.getSelections();
		var InitStr = '';
		for(var i = 0, Len = Sels.length; i < Len; i++){
			var InitId = Sels[i]['RowId'];
			if(InitStr == ''){
				InitStr = InitId;
			}else{
				InitStr = InitStr + '^' + InitId;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransOutAuditNoStr',
			InitStr: InitStr,
			UserId: gUserId
		},function(jsonData){
			var Ret = jsonData.msg;
			var RetArr = Ret.split(",");
			var InitRetStr = RetArr[0];
			var TotalCnt = RetArr[1];
			var SucessCnt = RetArr[2];
			$UI.msg('success', '共'+TotalCnt+'张单据,成功拒绝'+SucessCnt+'张单据!');
			Query();
			hideMask();
		});
	}

	var FrLoc = $HUI.combobox('#FrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			var LocId = record['RowId'];
			$('#CreateUser').combobox('clear');  
			$('#CreateUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({LocDr:LocId})
			);
		}
	});
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var ToLoc = $HUI.combobox('#ToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});

	var MasterCm = [[{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '出库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '出库类型',
			field: 'OperateTypeDesc',
			width: 80
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '进销差',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];

	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM'
		},
		columns: MasterCm,
		showBar: true,
		onSelect: function(index, row){
			var Init = row['RowId'];
			var ParamsObj = {Init:Init, InitType:'T'};
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				Params: JSON.stringify(ParamsObj),
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				MasterGrid.selectRow(0);
			}
		}
	});

	var DetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '批次Id',
			field: 'Inclb',
			width: 120,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '厂商',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			rows: 99999
		},
		pagination:false,
		columns: DetailCm,
		showBar: true,
		remoteSort: false
	});
	
	//设置缺省值
	function SetDefaValues(){
		$('#FrLoc').combobox('setValue', gLocId);
		$('#StartDate').datebox('setValue', DefaultStDate());
		$('#EndDate').datebox('setValue',  DefaultEdDate());
	}
	
	SetDefaValues();
	Query();
}
$(init);