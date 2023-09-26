
var init = function(){

	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(IngrDetailGrid);
		$UI.clear(IngrMasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		var Params = JSON.stringify(ParamsObj);
		IngrMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
			QueryName: 'QueryImportForTrans',
			sort: '',
			order: '',
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			$UI.clear(IngrDetailGrid);
			$UI.clear(IngrMasterGrid);
			$UI.clearBlock('#Conditions');
			SetDefaValues();
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var RecLoc = $('#RecLoc').combobox('getValue');
			if(isEmpty(RecLoc)){
				$UI.msg('alert', '入库科室不可为空!')
				return;
			}
			var InitToLoc = $('#RequestedLoc').combobox('getValue');
			if(isEmpty(InitToLoc)){
				$UI.msg('alert', '接收科室不可为空!')
				return;
			}
			if(RecLoc==InitToLoc){
				$UI.msg('alert', '出库科室不允许与接收科室相同!')
				return;
			}
			var RecRowData = IngrMasterGrid.getSelected();
			if(isEmpty(RecRowData)){
				$UI.mag('alert', '请选择需要处理的入库单!');
				return;
			}
			var InitScg = RecRowData['StkGrpId'];
			var MainObj = {InitFrLoc : RecLoc, InitToLoc : InitToLoc, InitComp : 'N', InitState : '10', InitUser : gUserId,
				InitScg: InitScg};
			var Main = JSON.stringify(addSessionParams(MainObj));
			var Detail = IngrDetailGrid.getRowsData();
			if(Detail.length<=0){
				$UI.mag('alert', '没有对应的明细数据!');
				return;
			}
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
					$UI.clear(IngrDetailGrid);
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					var UrlStr = "dhcstmhui.dhcinistrf.csp?RowId="+InitId;
					Common_AddTab('出库', UrlStr);
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	
	var RecLoc = $HUI.combobox('#RecLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			Query();
		}
	});
	$('#RecLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var Vendor = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='
			+ JSON.stringify(addSessionParams({RcFlag: 'Y'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var VirtualFlag = $HUI.checkbox('#VirtualFlag',{
		onCheckChange: function(e, value){
			if(value){
				var RecLoc = $('#RecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',RecLoc);
				var InfoArr = Info.split("^");
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#RecLoc'), VituralLoc, VituralLocDesc);
				$('#RecLoc').combobox('setValue', VituralLoc);
			}else{
				$('#RecLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	
	
	var RequestedLoc = $HUI.combobox('#RequestedLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var IngrMasterCm = [[
		{
			title : "IngrId",
			field : 'RowId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "入库单号",
			field : 'IngrNo',
			width : 140,
			align : 'left',
			sortable : false
		}, {
			title : "请求部门",
			field : 'ReqLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			title : "供给部门",
			field : 'RecLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			title : "入库日期",
			field : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			title : "入库人",
			field : 'CreateUser',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			title : "转移状态",
			field : 'Status',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			title : "类组",
			field : 'StkGrpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}
	]];
	
	var IngrMasterGrid = $UI.datagrid('#IngrMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
			QueryName: 'QueryImportForTrans'
		},
		columns: IngrMasterCm,
		showBar: true,
		remoteSort: false,
		onSelect: function(index, row){
			var RowId = row['RowId'];
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
				MethodName: 'QueryImportDetailForTrans',
				Parref: RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var IngrDetailCm = [[{
			title : "入库明细id",
			field : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "物资RowId",
			field : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			title : "批次RowId",
			field : 'Inclb',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "批号~效期",
			field : 'BatExp',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			title : "高值标志",
			field : 'HVFlag',
			width : 80,
			align : 'center',
			sortable : true,
			hidden : true
		},{
			title : "高值条码",
			field : 'HVBarCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			title : "批次库存",
			field : 'StkQty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			title : "转移数量",
			field : 'Qty',
			width : 80,
			align : 'right',
			sortable : true,
			editor : 'numberbox'
//			editor : new Ext.form.NumberField({
//				selectOnFocus : true,
//				allowBlank : false,
//				listeners : {
//					specialkey : function(field, e) {
//						if (e.getKey() == Ext.EventObject.ENTER) {
//							
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
//							var salePriceAMT = record
//									.get("Sp")
//									* qty;
//							record.set("SpAmt",
//									salePriceAMT);
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
			title : "转移单位",
			field : 'UomDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			title : "进价",
			field : 'Rp',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "售价",
			field : 'Sp',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
			align : 'right',
			summaryType : 'sum',
			sortable : true
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
			align : 'right',
			summaryType : 'sum',
			sortable : true
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			title : "占用数量",
			field : 'DirtyQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "可用数量",
			field : 'AvaQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "转换率",
			field : 'ConFacPur',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "基本单位",
			field : 'BUomId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}
	]];
	
	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
			MethodName: 'QueryImportDetailForTrans',
			rows: 99999
		},
		pagination:false,
		columns: IngrDetailCm,
		showBar: true,
		remoteSort: false
	});
	
	function SetDefaValues(){
		$('#StartDate').datebox('setValue', DefaultStDate());
		$('#EndDate').datebox('setValue',  DefaultEdDate());
		$('#RecLoc').combobox('setValue', session['LOGON.CTLOCID']);
	}
	SetDefaValues();
	Query();
}
$(init);