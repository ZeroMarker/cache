
var base10Value = new Array({
			header : '',
			dataIndex : 'rowid'
		}, // 0
		{
			header : 'ָ�����',
			dataIndex : 'BonusTargetCode'
		},// 1
		{
			header : 'ָ������',
			dataIndex : 'BonusTargetName'
		},// 2
		{
			header : '',
			dataIndex : 'CalUnitID'
		}, // 3
		{
			header : 'ָ�굥λ',
			dataIndex : 'CalUnitName'
		}, // 4
		{
			header : '',
			dataIndex : 'TargetTypeID'
		}, // 5
		{
			header : 'ָ������',
			dataIndex : 'TargetTypeName'
		}, // 6
		{
			header : 'ƴ����',
			dataIndex : 'TargetSpell'
		}, // 7
		{
			header : '������Դ',
			dataIndex : 'DataSource'
		}, // 8
		{
			header : '',
			dataIndex : 'TargetDesc'
		}, // 9
		{
			header : '',
			dataIndex : 'CalculateFormula'
		}, // 10
		{
			header : 'ָ�깫ʽ',
			dataIndex : 'CalculateDesc'
		}, // 11
		{
			header : '�������ȼ�',
			dataIndex : 'CalculatePriority'
		}, // 12
		{
			header : 'ָ������',
			dataIndex : 'TargetProperty'
		}, // 13 
		{
			header : '',
			dataIndex : 'RateType'
		}, // 14
		{
			header : '',
			dataIndex : 'ParameterTarget' 
		}, // 15
		{
			header : '',
			dataIndex : 'IsValid'
		}, // 16
		{
			header : '',
			dataIndex : 'AuditingState'
		}, // 17
		{
			header : '',
			dataIndex : 'AuditingDate'
		}, // 18
		{
			header : '����ʱ��',
			dataIndex : 'UpdateDate'
		}, // 19
		{
			header : '����ָ��',
			dataIndex : 'ParameterTargetName'
		}, // 20
		{
			header : '���ݼ���Id',
			dataIndex : 'calFlagId'
		}, // 21
		{
			header : '���ݼ���',
			dataIndex : 'calFlagName'
		}, // 22
		{
			header : 'Ĭ��ֵ',
			dataIndex : 'InitValue'
		} , // 23
		{
			header : '���ֵ',
			dataIndex : 'MaxValue'
		}   // 24
);
var DataSourceValue = new Array('', // 0
		'�ֹ�¼��', // 1
		'��ʽ����', // 2
		'�������', // 3
		'����ϵ��', // 4
		'��������', // 5
		'����ۼ�', // 6
		'�����ۼ�', // 7
		'�ۼ����', // 8
		'�������', // 9
		'����ָ��', // 10
		'֧��ָ��', // 11
		'RBRVSָ��', // 12
		'Drgsָ��', // 13
		'��Чָ��' // 14
);

var TargetPropertyValue = new Array('', // 0
		'����ָ��', // 1
		'ϵͳָ��' // 2
);

var base10Url = 'dhc.bonus.base10exe.csp';
var base10Proxy = new Ext.data.HttpProxy({
			url : base10Url + '?action=base10list'
		});

var base10Ds = new Ext.data.Store({
			proxy : base10Proxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, [base10Value[0].dataIndex, base10Value[1].dataIndex,
							base10Value[2].dataIndex, base10Value[3].dataIndex,
							base10Value[4].dataIndex, base10Value[5].dataIndex,
							base10Value[6].dataIndex, base10Value[7].dataIndex,
							base10Value[8].dataIndex, base10Value[9].dataIndex,
							base10Value[10].dataIndex,
							base10Value[11].dataIndex,
							base10Value[12].dataIndex,
							base10Value[13].dataIndex,
							base10Value[14].dataIndex,
							base10Value[15].dataIndex,
							base10Value[16].dataIndex,
							base10Value[17].dataIndex,
							base10Value[18].dataIndex,
							base10Value[19].dataIndex,
							base10Value[20].dataIndex,
							base10Value[21].dataIndex,
							base10Value[22].dataIndex,
							base10Value[23].dataIndex,
							base10Value[24].dataIndex]),
			remoteSort : true
		});

base10Ds.setDefaultSort('BonusTargetCode', 'ASC');

var inDeptsCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : base10Value[1].header,
			dataIndex : base10Value[1].dataIndex,
			width : 60,
			sortable : true
		}, {
			header : base10Value[2].header,
			dataIndex : base10Value[2].dataIndex,
			width : 150,
			align : 'left',
			sortable : true
		}/*, {
			header : base10Value[7].header,
			dataIndex : base10Value[7].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}*/, {
			header : base10Value[6].header,
			dataIndex : base10Value[6].dataIndex,
			width : 100,
			sortable : true
		}, /*{
			header : base10Value[4].header,
			dataIndex : base10Value[4].dataIndex,
			width : 60,
			align : 'left',
			sortable : true
		}, */{
			header : base10Value[8].header,
			dataIndex : base10Value[8].dataIndex,
			width : 60,
			align : 'left',
			renderer : function(value, metadata, record, rowIndex, colIndex,
					store) {
				return DataSourceValue[value];
			},
			sortable : true
		}, {
			header : base10Value[11].header,
			dataIndex : base10Value[11].dataIndex,
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : base10Value[13].header,
			dataIndex : base10Value[13].dataIndex,
			width : 80,
			renderer : function(value, metadata, record, rowIndex, colIndex,
					store) {
				return TargetPropertyValue[value];
			},
			sortable : true
		},/* {
			header : base10Value[12].header,
			dataIndex : base10Value[12].dataIndex,
			width : 80,
			align : 'left',
			sortable : true
		}, */{
			header : base10Value[20].header,
			dataIndex : base10Value[20].dataIndex,
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : base10Value[19].header,
			dataIndex : base10Value[19].dataIndex,
			width : 75,
			align : 'left',
			sortable : true
		}, {
			header : 'Ĭ��ֵ',
			dataIndex : base10Value[23].dataIndex,
			width : 100,
			align : 'right',
			decimalPrecision :4,
			sortable : true
		}, {
			header : '���ֵ',
			dataIndex : base10Value[24].dataIndex,
			width : 100,
			align : 'right',
			decimalPrecision :4,
			sortable : true
		}]);

var base10PagingToolbar = new Ext.PagingToolbar({
			pageSize : 25,
			store : base10Ds,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û������"// ,
		});

// ///////////////////////////////////////////
var addButton = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '���',
			iconCls : 'add',
			handler : function() {
				base10AddFun();
			}
		});

var editButton = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�޸�',
			iconCls : 'option',
			handler : function() {
				base10EditFun();
			}
		});

var delButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		var rowObj = base10Main.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";

		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ���ļ�¼!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
				if (btn == 'yes') {
					Ext.Ajax.request({
						url : base10Url + '?action=base10del&rowid=' + tmpRowid,
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
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								base10Ds.load({
											params : {
												start : 0,
												limit : base10PagingToolbar.pageSize
											}
										});
							} else {
								Ext.Msg.show({
											title : '����',
											msg : jsonData.info,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				}
			})
		}
	}
});

var btcField = new Ext.form.TextField({
			name : 'BonusTargetCode',
			width : 100,
			emptyText : 'ָ�����'
		});

var btnField = new Ext.form.TextField({
			name : 'BonusTargetName',
			width : 100,
			emptyText : 'ָ������'
		});
//zlg 
var DataSourceSt = new Ext.data.ArrayStore({
			fields : ['rowid', 'name'],
			data : [['1', DataSourceValue[1]], ['2', DataSourceValue[2]],
					['3', DataSourceValue[3]], ['4', DataSourceValue[4]],
					['9', DataSourceValue[9]], ['10', DataSourceValue[10]]
					,['11', DataSourceValue[11]], ['12', DataSourceValue[12]]
					,['13', DataSourceValue[13]], ['14', DataSourceValue[14]]
					]
		});  


var dsCombo = new Ext.form.ComboBox({
			name : 'DataSource',
			store : DataSourceSt,
			displayField : 'name',
			valueField : 'rowid',
			width : 100,
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '������Դ',
			selectOnFocus : true
		});

var ttCombo = new Ext.form.ComboBox({
			name : 'TargetTypeName',
			store : targetTypeComboDs,
			valueField : 'rowid',
			width : 100,
			listWidth : 190,
			displayField : 'TargetTypeName',
			triggerAction : 'all',
			emptyText : 'ָ������',
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var checkButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'add',
			handler : function() {
				// alert(btnField.getValue().trim());
				base10Ds.proxy = new Ext.data.HttpProxy({
							url : base10Url + '?action=base10list&btc='
									+ btcField.getValue().trim() + '&btn='
									+ encodeURIComponent(btnField.getValue().trim()) + '&ds='
									+ dsCombo.getValue().trim() + '&tt='
									+ ttCombo.getValue().trim()
						});
				base10Ds.load({
							params : {
								start : 0,
								limit : base10PagingToolbar.pageSize,
								btc : btcField.getValue().trim(),
								ds : dsCombo.getValue(),
								tt : ttCombo.getValue()
							}
						});
			}
		});

var base10Main = new Ext.grid.GridPanel({
			region : 'center',
			store : base10Ds,
			cm : inDeptsCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			viewConfig : {
				forceFit : true
			},
			tbar : [addButton, '-', editButton, '-', delButton, '-', '��ѯ����:',
					btcField, '-', btnField, '-', dsCombo, '-', ttCombo,
					checkButton],
			bbar : base10PagingToolbar
		});

base10Ds.load({
			params : {
				start : 0,
				limit : base10PagingToolbar.pageSize
			}
		});

base10Main.on('rowclick', function(grid, rowIndex, e) {
			var selectedRow = base10Ds.data.items[rowIndex];
			// �޸��Ƿ���Ч
			if (selectedRow.data["base10State"] == 1) {
				editButton.setDisabled(true);
			} else {
				editButton.setDisabled(false);
			}

		});