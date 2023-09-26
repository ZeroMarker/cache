var incomecollectUrl = 'dhc.bonus.incomedataassignmentexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : incomecollectUrl + '?action=list'
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

cycleDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
				method : 'POST'
			})
});

var cycleField = new Ext.form.ComboBox({
			id : 'cycleField',
			fieldLabel : '��������',
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : cycleDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText:'���',
			name : 'cycleField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '��'], ['Q', '��'], ['H', '����'], ['Y', '��']]
		});
var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '�ڼ�����',
			selectOnFocus : true,
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '�ڼ�����',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['01', '01��'], ['02', '02��'], ['03', '03��'], ['04', '04��'],
				['05', '05��'], ['06', '06��'], ['07', '07��'], ['08', '08��'],
				['09', '09��'], ['10', '10��'], ['11', '11��'], ['12', '12��']];
	}
	if (cmb.getValue() == "Q") {
		data = [['01', '01����'], ['02', '02����'], ['03', '03����'], ['04', '04����']];
	}
	if (cmb.getValue() == "H") {
		data = [['01', '1~6�ϰ���'], ['02', '7~12�°���']];
	}
	if (cmb.getValue() == "Y") {
		data = [['00', 'ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '',
			selectOnFocus : true,
			allowBlank : false,
			width : 70,
			listWidth : 150,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '�ڼ�',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var locSetDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name', 'shortcut'])
		});

locSetDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'dhc.bonus.incomedataassignmentexe.csp?action=locsetSublist',
		method : 'POST'
	})
});

var locSetField = new Ext.form.ComboBox({
			id : 'locSetField',
			fieldLabel : '�ӿ���:',
			width : 100,
			listWidth : 150,
			allowBlank : false,
			store : locSetDs,
			valueField : 'rowid',
			displayField : 'shortcut',
			triggerAction : 'all',
			emptyText : '',
			name : 'locSetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var interMedthodDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

interMedthodDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.intermethodexe.csp?action=InterMethod2&interLocSetDr='
						+ locSetField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
});
locSetField.on("select", function(cmb, rec, id) {

			interMedthodDs.load({
						params : {
							interLocSetDr : Ext.getCmp('locSetField')
									.getValue(),
							start : 0,
							limit : 10
						}
					});
		});
var interMethodField = new Ext.form.ComboBox({
			id : 'interMethodField',
			fieldLabel : '�ӿڷ���',
			width : 100,
			height : 200,
			listWidth : 200,
			allowBlank : false,
			store : interMedthodDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'interMethodField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var IncomeCollect = new Ext.data.Store({
			proxy : OutKPIDataProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid',
					'unitDr',
					'unitName',
					'itemDr', 
					'itemName',
					'year', 
					'period',
					'unitType',
					'unitTypeName', 
					'expensesType',
					'expensesTypeName', 
					'sickType',
					'sickTypeName', 
					'chiefDoctorDr',
					'chiefDoctorName', 
					'makeBillDoctorDr',
					'makeBillDoctorName',
					'executeDoctorDr',
					'executeDoctorName', 
					'incomeMoney',
					'incomeRate',
					'resultMoney',
					'state',
					'stateName',
					'updateDate',
					'kdDeptDr',
					'kdDeptName',
					'zxDeptDr',
					'zxDeptName',
					'brDeptDr',
					'brDeptName'
				]), 
			remoteSort : true
		});

IncomeCollect.setDefaultSort('rowid', 'DESC');

var OutKPIDataCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer()
, {
			header : '�������',
			dataIndex : 'year',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : '�����ڼ�',
			dataIndex : 'period',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header:'���㵥Ԫ����',
			dataIndex:'unitName',
			width:80,
			align:'center',
			sortable:true
		}, {
			header : '���㵥Ԫ���',
			dataIndex : 'unitTypeName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : '�շ���Ŀ����',
			dataIndex : 'itemName',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : " �������",
			dataIndex : 'expensesTypeName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " ��������",
			dataIndex : 'kdDeptName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " ִ�п���",
			dataIndex : 'zxDeptName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " ���˿���",
			dataIndex : 'brDeptName',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'incomeMoney',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '����ϵ��',
			dataIndex : 'incomeRate',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'resultMoney',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '����״̬',
			dataIndex : 'stateName',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'updateDate',
			width : 100,
			align : 'right',
			sortable : true
		}
]);
var incomeDataAssignmentButton = new Ext.Toolbar.Button({
	text:'�������ݷֽ�',
	tooltip:'�������ݷֽ�',
	iconCls:'add',
	handler:function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ�����!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var fre = Ext.getCmp('periodTypeField').getValue();
		if (fre == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ���������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var quote = Ext.getCmp('periodField').getValue();
		if (quote == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interSetDr = Ext.getCmp('locSetField').getValue();
		if (interSetDr == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ��ӿ���!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interMethod = Ext.getCmp('interMethodField').getValue();
		if (interMethod == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ��ӿڷ���!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		//alert(cycleDr+"^"+fre+"^"+quote+"^"+interSetDr+"^"+interMethod);
		
		Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ֽ���?', function(btn) {
			if (btn=='yes') {
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.incomedataassignmentexe.csp?action=assignment&cycleDr='+cycleDr+'&fre='+fre+'&quote='+quote+'&interSetDr='+interSetDr+'&interMethod='+interMethod,
					waitMsg:'�ֽ���...',
					failure:function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success:function(result, request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						if(jsonData.success=='0'){
							Ext.Msg.show({title:'��ʾ',msg:'�ֽ�ɹ���',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							IncomeCollect.load({params:{start:0,limit:PagingToolbar.pageSize,cycleDr:cycleDr,fre:fre,quote:quote,interSetDr:interSetDr,interMethod:interMethod}});
						}else{
							Ext.Msg.show({title:'��ʾ',msg:'�ֽ�ʧ�ܣ�',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope : this
				});
			}
		});
	}
});

var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'add',
	handler:function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ�����!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var fre = Ext.getCmp('periodTypeField').getValue();
		if (fre == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ���������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var quote = Ext.getCmp('periodField').getValue();
		if (quote == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interSetDr = Ext.getCmp('locSetField').getValue();
		if (interSetDr == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ��ӿ���!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interMethod = Ext.getCmp('interMethodField').getValue();
		if (interMethod == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ��ӿڷ���!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		
		Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ����', function(btn) {
			if (btn=='yes') {
				Ext.Ajax.request({
					url:'../csp/dhc.bonus.incomedataassignmentexe.csp?action=del&cycleDr='+cycleDr+'&fre='+fre+'&quote='+quote+'&interSetDr='+interSetDr+'&interMethod='+interMethod,
					waitMsg:'ɾ����...',
					failure:function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success:function(result, request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						if(jsonData.success=='0'){
							Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ���',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							IncomeCollect.load({params:{start:0,limit:PagingToolbar.pageSize,cycleDr:cycleDr,fre:fre,quote:quote,interSetDr:interSetDr,interMethod:interMethod}});
						}else{
							Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ�ܣ�',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope : this
				});
			}
		});
	}
});


var findDataButton = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'add',
	handler:function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ�����!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var fre = Ext.getCmp('periodTypeField').getValue();
		if (fre == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ���������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var quote = Ext.getCmp('periodField').getValue();
		if (quote == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interSetDr = Ext.getCmp('locSetField').getValue();
		if (interSetDr == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ��ӿ���!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		var interMethod = Ext.getCmp('interMethodField').getValue();
		if (interMethod == "") {
			Ext.Msg.show({title : '��ʾ',msg : '��ѡ��ӿڷ���!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
			return false;
		}
		
		IncomeCollect.load({params:{start:0,limit:PagingToolbar.pageSize,cycleDr:cycleDr,fre:fre,quote:quote,interSetDr:interSetDr,interMethod:interMethod}});
	}
});


var OutKPIDataSearchField = 'sickTypeName';
var OutKPIDataFilterItem = new Ext.SplitButton({
			text:'������',
			tooltip:'�ؼ����������',
			menu:{
				items:[new Ext.menu.CheckItem({
									text : '�������',
									value : 'sickTypeName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '���㵥Ԫ',
									value : 'unitName',
									checked : true,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�������',
									value : 'expensesTypeName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '�շ���Ŀ',
									value : 'itemName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '��������',
									value : 'updateDate',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								})]
			}
		});

function onOutKPIDataItemCheck(item, checked) {
	if (checked) {
		OutKPIDataSearchField = item.value;
		OutKPIDataFilterItem.setText(item.text + ':');
	}
};

var OutKPIDataSearchBox = new Ext.form.TwinTriggerField({// ���Ұ�ť
	width : 180,
	trigger1Class : 'x-form-clear-trigger',
	trigger2Class : 'x-form-search-trigger',
	emptyText : '����...',
	listeners : {
		specialkey : {
			fn : function(field, e) {
				var key = e.getKey();
				if (e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid : this,
	onTrigger1Click : function() {
		if (this.getValue()) {
			this.setValue('');
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : incomecollectUrl + '?action=list&cycleDr='
								+ cycleField.getValue() + '&fre='
								+ periodTypeField.getValue() + '&quote='
								+ periodField.getValue() + '&interSetDr='
								+ locSetField.getValue() + '&interMethod='
								+ interMethodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : PagingToolbar.pageSize
						}
					});
		}
	},
	onTrigger2Click : function() {
		if (this.getValue()) {
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : incomecollectUrl + '?action=list&searchField='
								+ OutKPIDataSearchField + '&searchValue='
								+ this.getValue() + '&cycleDr='
								+ cycleField.getValue() + '&fre='
								+ periodTypeField.getValue() + '&quote='
								+ periodField.getValue() + '&interSetDr='
								+ locSetField.getValue() + '&interMethod='
								+ interMethodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : PagingToolbar.pageSize
						}
					});
		}
	}
});

var PagingToolbar = new Ext.PagingToolbar({// ��ҳ������
	pageSize : 25,
	store : IncomeCollect,
	displayInfo : true,
	displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg : "û������",
	buttons : ['-',OutKPIDataFilterItem,'-',OutKPIDataSearchBox]
});

var IncomeDataAssignmentMain = new Ext.grid.GridPanel({// ���
	title : '�������ݷֽ�',
	store : IncomeCollect,
	cm : OutKPIDataCm,
	trackMouseOver : true,
	region : 'center',
	stripeRows : true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask : true,
	frame : true,
	clicksToEdit : 2,
	stripeRows : true,
	tbar : ['�������:',cycleField,'-',periodTypeField,'-',periodField,'-','�ӿ���:',locSetField,'-','�ӿڷ���:',interMethodField,'-',findDataButton,'-',incomeDataAssignmentButton,'-',delButton],
	bbar : PagingToolbar
});
