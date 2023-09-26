// rowid^BonusSchemeID^BonusItemTypeID^SchemeItemCode^SchemeItemName^DataSource^BonusFormula^BonusFormulaDesc^BonusType^CalculatePriority^IsValid^UpdateDate
var schemeValue = new Array({
			header : '',
			dataIndex : 'rowid'
		}, // 0
		{
			header : '����ID',
			dataIndex : 'BonusSchemeID'
		}, // 1
		{
			header : '��Ŀ���',
			dataIndex : 'BonusItemTypeName'
		}, // 2
		{
			header : '��Ŀ����',
			dataIndex : 'SchemeItemCode'
		}, // 3
		{
			header : '��Ŀ����',
			dataIndex : 'SchemeItemName'
		}, // 4
		{
			header : '������Դ',
			dataIndex : 'DataSource'
		}, // 5
		{
			header : '��ʽ',
			dataIndex : 'BonusFormula'
		}, // 6
		{
			header : '��ʽ����',
			dataIndex : 'BonusFormulaDesc'
		}, // 7
		{
			header : '��Ŀ����',
			dataIndex : 'BonusType'
		}, // 8
		{
			header : '�������ȼ�',
			dataIndex : 'CalculatePriority'
		}, // 9
		{
			header : '�Ƿ���Ч',
			dataIndex : 'IsValid'
		}, // 10
		{
			header : '����ʱ��',
			dataIndex : 'UpdateDate'
		}, // 11
		{
			header : '���������',
			dataIndex : 'BonusItemTypeID'
		} // 12
);
//
var itemCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : schemeValue[3].header,
			dataIndex : schemeValue[3].dataIndex,
			width : 55,
			sortable : true
		}, {
			header : schemeValue[4].header,
			dataIndex : schemeValue[4].dataIndex,
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[2].header,
			dataIndex : schemeValue[2].dataIndex,
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[8].header,
			dataIndex : schemeValue[8].dataIndex,
			width : 70,
			renderer : function(value, metadata, record, rowIndex, colIndex,
					store) {
				return bonusTypeValue[value];
			},
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[5].header,
			dataIndex : schemeValue[5].dataIndex,
			width : 60,
			renderer : function(value, metadata, record, rowIndex, colIndex,
					store) {
				return dataSourceValue[value];
			},
			align : 'left',
			sortable : true
		}, {
			header : schemeValue[7].header,
			dataIndex : schemeValue[7].dataIndex,
			width : 400,
			align : 'left',
			renderer : change,
			// css : 'background: #FFFFFF;color:#FF0000',
			sortable : true
		}, {
			header : schemeValue[12].header,
			dataIndex : schemeValue[12].dataIndex,
			width : 40,
			align : 'left',
			hidden : true,
			sortable : true
		}]);

var itemAddButton = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '���',
			iconCls : 'add',
			handler : function() {
				var rowObj = schemeMain.getSelectionModel().getSelections();
				if (rowObj.length == 0) {
					schemeSM.selectFirstRow();
					rowObj = schemeMain.getSelectionModel().getSelections();
				}
				if (rowObj[0].get("schemeState") == 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '�����,�������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}

				itemAddFun();
			}
		});

var itemEditButton = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�޸�',
			iconCls : 'option',
			handler : function() {
				var rowObj = schemeMain.getSelectionModel().getSelections();
				if (rowObj.length == 0) {
					schemeSM.selectFirstRow();
					rowObj = schemeMain.getSelectionModel().getSelections();
				}
				if (rowObj[0].get("schemeState") == 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '���������,�����޸�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}

				itemEditFun();
			}
		});

var itemDelButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		var rowObj = schemeMain.getSelectionModel().getSelections();
		if (rowObj.length == 0) {
			schemeSM.selectFirstRow();
			rowObj = schemeMain.getSelectionModel().getSelections();
		}
		if (rowObj[0].get("schemeState") == 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '�����,����ɾ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}

		var rowObj = itemMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var myId = "";

		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ��������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
				if (btn == 'yes') {
					myId = rowObj[0].get("rowid");
					Ext.Ajax.request({
						url : itemUrl + '?action=itemdel&rowid=' + myId,
						waitMsg : 'ɾ����...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : 'ɾ���ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								itemDs.load({
											params : {
												start : 0,
												limit : itemPagingToolbar.pageSize
											}
										});
							} else {
								var message = "";
								Ext.Msg.show({
											title : '����',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				}
			});
		}
	}
});

var itemUrl = 'dhc.bonus.scheme01exe.csp';
var itemProxy = '';// new Ext.data.HttpProxy({url: itemUrl +
// '?action=itemlist'});

var itemDs = new Ext.data.Store({
			proxy : itemProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, [schemeValue[0].dataIndex, schemeValue[1].dataIndex,
							schemeValue[2].dataIndex, schemeValue[3].dataIndex,
							schemeValue[4].dataIndex, schemeValue[5].dataIndex,
							schemeValue[6].dataIndex, schemeValue[7].dataIndex,
							schemeValue[8].dataIndex, schemeValue[9].dataIndex,
							schemeValue[10].dataIndex,
							schemeValue[11].dataIndex,
							schemeValue[12].dataIndex]),
			remoteSort : true
		});

itemDs.setDefaultSort('SchemeItemCode', 'ASC');

var itemPagingToolbar = new Ext.PagingToolbar({
			pageSize : 25,
			store : itemDs,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û������"// ,

		});

itemSM = new Ext.grid.RowSelectionModel({
			singleSelect : true
		});

var itemMain = new Ext.grid.GridPanel({
			title : '���𷽰���ά��',
			region : 'center',
			store : itemDs,
			// render:change,
			cm : itemCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : itemSM,
			loadMask : true,
			viewConfig : {
				forceFit : true
			},
			tbar : [itemAddButton, '-', itemEditButton, '-', itemDelButton],
			bbar : itemPagingToolbar
		});

itemMain.on('cellclick', function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex); // Get the Record
			var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
			var data = record.get(fieldName);

			var ItemNameIndex = grid.getColumnModel().getDataIndex(2);
			var ItemName = record.get(ItemNameIndex);

			if (columnIndex == 6) {
				if (data != null)
					Ext.Msg.alert(ItemName + '=', data);

			}

		});
		
//itemDs.on('load', function(grid, d, r) {
//
//			itemMain.getSelectionModel().selectFirstRow();
//		});
// Ext.get('XX').on('mouseover',function(){
// Ext.fly('XX').dom.style.cursor="hand";});
function change(val) {
	return '<span style="cursor:hand">' + val + '</span>';
	//return '<span style="color:blue;cursor:hand">' + val + '</span>';
}
//style.cursor="hand"
// itemDs.load({params:{start:0, limit:itemPagingToolbar.pageSize}});
