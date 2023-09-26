
function SelReq(Fn,SelFn,HvFlag){
	$HUI.dialog('#SelReqWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	$HUI.combobox('#SelReqHosp', {
		url: $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=Array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel:function(){
			$(this).combobox('clear');
			var HospAutFlag=tkMakeServerCall("web.DHCSTMHUI.MatForBDPData","GetHospAutFlag");
			var Params=JSON.stringify(addSessionParams({tablename:"CT_Loc"}));
			var url=$URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=Array';
			if (HospAutFlag=="Y"){
				var url=$URL+ '?ClassName=web.DHCSTMHUI.MatForBDPHosp&QueryName=GetHospDataForCloud&ResultSetType=Array&Params='+Params;
			}
			$(this).combobox('reload',url);
		}
	});
	function GetHospId() {
		var HospId=$HUI.combogrid('#SelReqHosp').getValue();
		if (isEmpty(HospId)){
			HospId=gHospId;
		}
		return HospId;
	}
	$HUI.combobox('#SelReqRecLoc',{
		//url: $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel:function(){
			$(this).combobox('clear');
			var url=$URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+ JSON.stringify(addSessionParams({Type:'All',BDPHospital:GetHospId()}));
			$(this).combobox('reload',url);
		}
	});
	
	var SelReqHandlerParams = function(){
		var FrLoc = $('#InitFrLoc').combobox('getValue');
		var ToLoc = $('#SelReqRecLoc').combobox('getValue');
		var Obj = {StkGrpType: 'M', Locdr: FrLoc, ToLoc: ToLoc,BDPHospital:GetHospId()};
		return Obj;
	}
	$('#SelReqInciDesc').lookup(InciLookUpOp(SelReqHandlerParams, '#SelReqInciDesc', '#SelReqInciId'));
	
	$UI.linkbutton('#SelReqQueryBT', {
		onClick: function(){
			SelReqQuery();
		}
	});
	function SelReqQuery(){
		var FrLoc = $('#InitFrLoc').combobox('getValue');
		var ParamsObj = $UI.loopBlock('#SelReqConditions');
		ParamsObj.FrLoc = FrLoc;
		ParamsObj.HVFlag=HvFlag;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(SelReqMasterGrid);
		SelReqMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'INReqForTransfer',
			Params: Params
		});
	}
	///选取申请单
	$UI.linkbutton('#SelReqInfoBT',{
		onClick: function(){
			var Row = SelReqMasterGrid.getSelected();
			var FrLoc = Row.FrLoc;
			var ToLoc= Row.ToLoc;
			var ReqId= Row.RowId;
			var ReqNo=Row.ReqNo;
			var MainObj = {InitFrLoc:FrLoc,InitToLoc:ToLoc,ReqNo:ReqNo,ReqId:ReqId};
			var Detail = SelReqMasterGrid.getSelectedData();
			if(isEmpty(Detail)){
				return;
			}
			$('#SelReqWin').window('close');
			SelFn(MainObj,ReqId);
		}
	});
	$UI.linkbutton('#SelReqCreateBT',{
		onClick: function(){
			var FrLocId = $('#InitFrLoc').combobox('getValue');
			var MainObj = {FrLocId : FrLocId};
			MainObj = addSessionParams(MainObj);
			var Main = JSON.stringify(MainObj);
			var Detail = SelReqMasterGrid.getSelectedData();
			if(isEmpty(Detail)){
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCreateTransferByReq',
				Main: Main,
				Detail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					$('#SelReqWin').window('close');
					var InitStr = jsonData.rowid;
					Fn(InitStr);
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#SelReqRefuseBT', {
		onClick: function(){
			var Detail = SelReqMasterGrid.getSelections();
			if(isEmpty(Detail)){
				$UI.msg('alert', '请选择需要拒绝的单据!');
				return;
			}
			$UI.confirm('您将要拒绝选中的'+Detail.length+'张单据,是否继续?', '', '', RefuseReq);
		}
	});
	function RefuseReq(){
		var SelReqs = SelReqMasterGrid.getSelectedData();
		var ReqStr = '';
		for(var i = 0, Count = SelReqs.length; i < Count; i++){
			var RowId = SelReqs[i]['RowId'];
			if(ReqStr == ''){
				ReqStr = RowId;
			}else{
				ReqStr = ReqStr + '^' + RowId;
			}
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'jsCancelCompStr',
			ReqStr: ReqStr,
			Flag: 'T'
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				SelReqQuery();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#SelReqRefuseDetailBT', {
		onClick: function(){
			var ReqDetailSel = SelReqDetailGrid.getSelected();
			if(isEmpty(ReqDetailSel)){
				$UI.msg('alert', '请选择需要拒绝的明细!');
				return;
			}
			$UI.confirm('您将要拒绝选中的单据,是否继续?', '', '', RefuseReqDetail);
		}
	});
	function RefuseReqDetail(){
		var ReqDetailSel = SelReqDetailGrid.getSelected();
		var RowId = ReqDetailSel['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.INReqItm',
			MethodName: 'SetItmStatus',
			Reqi: RowId
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				QueryReqDetail();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function SelReqDefa(){
		var Dafult = {
			StartDate: DateFormatter(DateAdd(new Date(),'d',-7)),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#SelReqConditions', Dafult);
	}
	
	$UI.linkbutton('#SelSplitDetailBT', {
		onClick: function(){
			SelSplitDetail();
		}
	});
	function SelSplitDetail(){
		var Detail = SelReqDetailGrid.getSelectedData();
		if(isEmpty(Detail)){
			$UI.msg('alert', '请选择需要操作的明细数据!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequestSplit',
			MethodName: 'jsSetSplit',
			Params: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				SelReqDetailGrid.reload();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox : true
		}, {
			title : "RowId",
			field : 'RowId',
			saveCol : true,
			width : 60,
			sortable : true,
			hidden : true
		}, {
			title : "请求单号",
			field : 'ReqNo',
			width : 120,
			sortable : true
		}, {
			title : "请求科室",
			field : 'ToLocDesc',
			width : 120,
			sortable : true
		}, {
			title : "转移状态",
			field : 'TransStatus',
			width : 80,
			sortable : true,
			formatter: function(value, row, index){
				var status="";
				if(value == 0){
					status="未转移";
				}else if(value==1){
					status="部分转移";
				}else if(value==2){
					status="全部转移";
				}
				return status;
			}
		}, {
			title : "供给科室",
			field : 'FrLocDesc',
			width : 120,
			sortable : true
		}, {
			title : "请求时间",
			field : 'ReqDateTime',
			width : 90,
			sortable : true
		}, {
			title : "请求单类型",
			field : 'Status',
			width : 100,
			align : 'left',
			formatter: function(value, row, index){
				if(value == 'O'){
					value = '临时请求';
				}else if(value == 'C'){
					value = '申领计划';
				}
				return value;
			},
			sortable : true
		}, {
			title : "制单人",
			field : 'UserName',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			title : "高值标志",
			field : 'HVFlag',
			formatter : BoolFormatter,
			width : 80,
			align : 'center'
		}, {
			title : "FrLoc",
			field : 'FrLoc',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "ToLoc",
			field : 'ToLoc',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "备注",
			field : 'Remarks',
			width : 90,
			align : 'left',
			sortable : true
		}
	]];


	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'INReqForTransfer'
		},
		columns: SelReqMasterCm,
		singleSelect: (HvFlag=="Y")?true:false,
		onSelect: function(index, row){
			QueryReqDetail();
		},
		onUnselect: function(index, row){
			QueryReqDetail();
		},
		onSelectAll: function(rows){
			QueryReqDetail();
		},
		onUnselectAll: function(rows){
			$UI.clear(SelReqDetailGrid);
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				//SelReqMasterGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row){
//			Fn(row['RowId']);
//			$HUI.dialog('#FindWin').close();
		}
	});
	
	function QueryReqDetail(){
		$UI.clear(SelReqDetailGrid);
		var ReqIdStr = '';
		var Sels = SelReqMasterGrid.getSelections();
		for(var i = 0, Len = Sels.length; i < Len; i++){
			var ReqId = Sels[i]['RowId'];
			if(ReqIdStr == ''){
				ReqIdStr = ReqId;
			}else{
				ReqIdStr = ReqIdStr + ',' + ReqId;
			}
		}
		if(ReqIdStr == ''){
			return;
		}
		var ParamsObj = {};
		SelReqDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'INReqD',
			Req: ReqIdStr,
			Params: JSON.stringify(ParamsObj),
			rows: 9999
		});
	}

	var SelReqDetailCm = [[
		{
			field: 'ck',
			checkbox : true
		}, {
			title : "请求明细RowId",
			field : 'RowId',
			saveCol : true,
			width : 100,
			sortable : true,
			hidden : true
		}, {
			title : "物资RowId",
			field : 'Inci',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			title : '请求单号',
			field : 'ReqNo',
			width : 120,
			hidden : true,
			sortable : true
		}, {
			title : '请求科室',
			field : 'ReqLocDesc',
			width : 80,
			sortable : true
		}, {
			title : '物资代码',
			field : 'InciCode',
			width : 80,
			sortable : true
		}, {
			title : '物资名称',
			field : 'InciDesc',
			width : 160,
			sortable : true
		}, {
			title : "规格",
			field : 'Spec',
			width : 80,
			sortable : true
		}, {
			title : "请求数量",
			field : 'Qty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "采购量",
			field : 'ProReqQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "供应方库存",
			field : 'StkQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "供应方可用库存",
			field : 'ProLocAllAvaQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "供应方批准数量",
			field : 'QtyApproved',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "已转移数量",
			field : 'TransQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "未转移数量",
			field : 'NotTransQty',
			saveCol : true,
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "单位",
			field : 'UomDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			title : "备注",
			field : 'Remark',
			width : 180,
			align : 'left',
			sortable : true
		}
	]];

	var SelReqDetailGrid = $UI.datagrid('#SelReqDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'INReqD'
		},
		columns: SelReqDetailCm,
		singleSelect: false,
		pagination: false,
		remoteSort: false,
		onLoadSuccess: function(data){
			$.each(data.rows, function(index, row){
				var ColorField = 'InciCode';
				var AvaQty = Number(row['ProLocAllAvaQty']);
				var NotTransQty = Number(row['NotTransQty']);
				if((AvaQty > 0) && (AvaQty < NotTransQty)){
					var Color = '#FD930C';
					SetGridBgColor(SelReqDetailGrid, index, 'RowId', Color, ColorField);
				}else if((NotTransQty > 0) && (AvaQty <= 0)){
					var Color = '#EE4F38';
					SetGridBgColor(SelReqDetailGrid, index, 'RowId', Color, ColorField);
				}
			});
		}
	});

	SelReqDefa();
	SelReqQuery();
}