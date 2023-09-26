
//ps: 使用高值的时候, 需要过滤掉HVFlag="Y"的
//切换科室时要处理datagrid数据?清空?
var init = function() {
	
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		$UI.setUrl(DetailGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj['ToLoc'])){
			$UI.msg('alert', '接收科室不可为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByLim',
			QueryName: 'RecLocItmForTransfer',
			Params: Params,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			$UI.clearBlock('Conditions');
			$UI.clear(DetailGrid);
			SetDefaValues();
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			Save();
		}
	});
	function Save(){
		var Detail = DetailGrid.getRowsData();
		if(isEmpty(Detail)){
			$UI.msg('alert', '没有需要保存的数据!');
			return;
		}
		var InitFrLoc = $('#FrLoc').combobox('getValue');
		if(isEmpty(InitFrLoc)){
			$UI.msg('alert', '科室不可为空!')
			return;
		}
		var InitToLoc = $('#ToLoc').combobox('getValue');
		if(isEmpty(InitToLoc)){
			$UI.msg('alert', '接收科室不可为空!')
			return;
		}
		if(InitFrLoc==InitToLoc){
			$UI.msg('alert', '出库科室不允许与接收科室相同!')
			return;
		}
		var InitScg = $('#ScgId').combobox('getValue');
		
		var MainObj = {InitFrLoc : InitFrLoc, InitToLoc : InitToLoc, InitComp : 'N', InitState : '10', InitUser : gUserId,
			InitScg: InitScg};
		var Main = JSON.stringify(addSessionParams(MainObj));
		
		if(Detail===false){
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsSave',
			Main: Main,
			Detail: JSON.stringify(Detail)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.clear(DetailGrid);
				$UI.msg('success', jsonData.msg);
				var InitId = jsonData.rowid;
				var UrlStr = 'dhcstmhui.dhcinistrf.csp?RowId='+InitId;
				Common_AddTab('出库', UrlStr);
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	var FrLoc = $HUI.combobox('#FrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var ToLoc = $HUI.combobox('#ToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var AuxToLoc = $HUI.combobox('#AuxToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});

	
	var DetailCm = [[
		{
			title : '物资Id',
			field : 'InciId',
			width : 80,
			align : 'left',
			hidden : true
		}, {
			title : '物资代码',
			field : 'InciCode',
			width : 80,
			sortable : true
		}, {
			title : '物资名称',
			field : 'InciDesc',
			width : 180,
			sortable : true
		}, {
			title : '批次Id',
			field : 'Inclb',
			saveCol : true,
			width : 80,
			hidden : true
		}, {
			title : '批号',
			field : 'BatchNo',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			title : '效期',
			field : 'ExpDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			title : '厂商',
			field : 'ManfDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			title : '转移数量',
			field : 'Qty',
			saveCol : true,
			width : 80,
			align : 'right',
			sortable : true
//			,
//			editor : new Ext.form.NumberField({
//				selectOnFocus : true,
//				allowBlank : false,
//				listeners : {
//					specialkey : function(field, e) {
//						if (e.getKey() == Ext.EventObject.ENTER) {
//							var qty = field.getValue();
//							if (qty == null || qty.length <= 0) {
//								Msg.info("warning", "转移数量不能为空!");
//								return;
//							}
//							if (qty <= 0) {
//								Msg.info("warning", "转移数量不能小于或等于0!");
//								return;
//							}
//							var cell = DetailGrid.getSelectionModel()
//									.getSelectedCell();
//							var record = DetailGrid.getStore()
//									.getAt(cell[0]);									
//							var AvaQty = record.get("AvaQty");
//							if (qty > AvaQty) {
//								Msg.info("warning", "转移数量不能大于可用库存数量!");
//								return;
//							}
//						}
//					}
//				}
//			})
		}, {
			title : '单位Id',
			field : 'UomId',
			saveCol : true,
			width : 80,
			align : 'left',
			hidden : true
		},{
			title : '单位',
			field : 'UomDesc',
			width : 80,
			align : 'left'
		}, {
			title : '售价',
			field : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			title : '货位码',
			field : 'StkbinDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			title : '批次库存',
			field : 'StkQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '占用数量',
			field : 'DirtyQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '可用数量',
			field : 'AvaQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '请求方总库存',
			field : 'CurQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '请求方标准库存',
			field : 'RepQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '参考库存',
			field : 'LevelQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '库存上限',
			field : 'MaxQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : '库存下限',
			field : 'MinQty',
			width : 80,
			align : 'right',
			sortable : true
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByLim',
			QueryName: 'RecLocItmForTransfer',
			rows: 99999
		},
		columns: DetailCm,
		showBar: true,
		pagination: false,
		remoteSort: false
//		,
//		singleSelect: false
//		,
//		onBeforeSelect: function(index, row){
//			var Qty = Number(row['Qty']);
//			var AvaQty = Number(row['InclbAvaQty']);
//			var OperQty = Math.min(Qty, AvaQty);
//			if(OperQty <= 0){
//				$UI.msg('alert', '可用数量不足!');
//				return;
//			}
//		}
//		,
//		onSelect: function(index, row){
//			var Qty = Number(row['Qty']);
//			var AvaQty = Number(row['InclbAvaQty']);
//			var OperQty = Math.min(Qty, AvaQty);
//			row['OperQty'] = OperQty;
//			$(this).datagrid('refreshRow', index);
//		},
//		onUnselect: function(index, row){
//			row['OperQty'] = '';
//			$(this).datagrid('refreshRow', index);
//		},
//		onSelectAll: function(rows){
//			alert('all')
//		}
	});
	
	//设置缺省值
	function SetDefaValues(){
		$('#FrLoc').combobox('setValue', gLocId);
	}
	
	SetDefaValues();
}
$(init);