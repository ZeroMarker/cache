
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
				$UI.msg('alert', '�����Ҳ���Ϊ��!')
				return;
			}
			var InitToLoc = $('#RequestedLoc').combobox('getValue');
			if(isEmpty(InitToLoc)){
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!')
				return;
			}
			if(RecLoc==InitToLoc){
				$UI.msg('alert', '������Ҳ���������տ�����ͬ!')
				return;
			}
			var RecRowData = IngrMasterGrid.getSelected();
			if(isEmpty(RecRowData)){
				$UI.mag('alert', '��ѡ����Ҫ�������ⵥ!');
				return;
			}
			var InitScg = RecRowData['StkGrpId'];
			var MainObj = {InitFrLoc : RecLoc, InitToLoc : InitToLoc, InitComp : 'N', InitState : '10', InitUser : gUserId,
				InitScg: InitScg};
			var Main = JSON.stringify(addSessionParams(MainObj));
			var Detail = IngrDetailGrid.getRowsData();
			if(Detail.length<=0){
				$UI.mag('alert', 'û�ж�Ӧ����ϸ����!');
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
					Common_AddTab('����', UrlStr);
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
			title : "��ⵥ��",
			field : 'IngrNo',
			width : 140,
			align : 'left',
			sortable : false
		}, {
			title : "������",
			field : 'ReqLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			title : "��������",
			field : 'RecLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			title : "�������",
			field : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			title : "��Ӧ��",
			field : 'Vendor',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			title : "�����",
			field : 'CreateUser',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			title : "ת��״̬",
			field : 'Status',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			title : "����",
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
			title : "�����ϸid",
			field : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "����RowId",
			field : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			title : '��������',
			field : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			title : "����RowId",
			field : 'Inclb',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "����~Ч��",
			field : 'BatExp',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			title : "��ֵ��־",
			field : 'HVFlag',
			width : 80,
			align : 'center',
			sortable : true,
			hidden : true
		},{
			title : "��ֵ����",
			field : 'HVBarCode',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			title : "���ο��",
			field : 'StkQty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			title : "ת������",
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
//								Msg.info("warning", "ת����������Ϊ��!");
//								return;
//							}
//							if (qty <= 0) {
//								Msg.info("warning", "ת����������С�ڻ����0!");
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
//								Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
//								return;
//							}
//						}
//					}
//				}
//			})
		}, {
			title : "ת�Ƶ�λ",
			field : 'UomDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			title : "����",
			field : 'Rp',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "�ۼ�",
			field : 'Sp',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "���۽��",
			field : 'RpAmt',
			width : 100,
			align : 'right',
			summaryType : 'sum',
			sortable : true
		}, {
			title : "�ۼ۽��",
			field : 'SpAmt',
			width : 100,
			align : 'right',
			summaryType : 'sum',
			sortable : true
		}, {
			title : "����",
			field : 'Manf',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			title : "ռ������",
			field : 'DirtyQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "��������",
			field : 'AvaQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			title : "ת����",
			field : 'ConFacPur',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			title : "������λ",
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