var schemUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';
var schemProxy = new Ext.data.HttpProxy({
			url : schemUrl + '?action=schemlist'
		});
var userCode = session['LOGON.USERCODE'];
var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '�·�'], ['Q', '����'], ['H', '����'], ['Y', '���']]
		});

var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '�ڼ�����',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01��'], ['M02', '02��'], ['M03', '03��'], ['M04', '04��'],
				['M05', '05��'], ['M06', '06��'], ['M07', '07��'], ['M08', '08��'],
				['M09', '09��'], ['M10', '10��'], ['M11', '11��'], ['M12', '12��']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01����'], ['Q02', '02����'], ['Q03', '03����'],
				['Q04', '04����']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '�ϰ���'], ['H02', '�°���']];
	}
	if (cmb.getValue() == "Y") {
		data = [['Y00', '00']];
	}
	periodStore.loadData(data);

});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '�����ڼ�',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			allowBlank : false,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'BonusYear'])
		});

cycleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl
								+ '?action=yearlist&topCount=5&orderby=Desc',
						method : 'POST'
					})
		});

var periodYear = new Ext.form.ComboBox({
			id : 'periodYear',
			fieldLabel : '�������',
			width : 80,
			listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : cycleDs,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodYear.on("select", function(cmb, rec, id) {

			if (Ext.getCmp('periodField').getValue() != '')
				schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								userCode : session['LOGON.USERCODE'],
								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});
		});

// ���������������Դ
var schemDs = new Ext.data.Store({
			proxy : schemProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'BonusSchemeCode', 'BonusSchemeName',
							'BonusYear', 'BonusPeriod', 'CalcFlag', 'CalcDate',
							'AuditingFlag', 'AuditingDate', 'person', 'IsDate',
							'IsPay']),
			remoteSort : true
		});

schemDs.setDefaultSort('rowid', 'desc');

var schemeTypeSt = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'code', 'name'])
		});
schemeTypeSt.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.bonusschemtypeexe.csp?action=list&start=0&limit=10',
				//method : 'GET'
				 method:'POST'
			});
});

// ���𷽰����
var schemeTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '��������',
			//name : 'type',
			id: 'schemeTypeCombo',
			name : 'schemeTypeCombo',
			width : 150,
			listWidth : 200,
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			// mode : 'local',
			forceSelection : true,
			pageSize : 10,
			triggerAction : 'all',
			emptyText : '',
			selectOnFocus : true,
			anchor : '100%'
		});

schemeTypeCombo.on('select', function() {
	p_SchemeType = schemeTypeCombo.value
	if (Ext.getCmp('periodField').getValue() != '')
		tmpStore.removeAll();

	schemDs.load({
				params : {
					bonusYear : Ext.getCmp('periodYear').getValue(),
					bonusPeriod : Ext.getCmp('periodField').getValue(),
					userCode : session['LOGON.USERCODE'],
					schemeType : p_SchemeType,
					start : 0,
					limit : schemPagingToolbar.pageSize
				}
			});
		// alert(p_SchemeType)
	})

var schemCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '�������ID',
			dataIndex : 'rowid',
			width : 40,
			hidden : true,
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'BonusSchemeCode',
			width : 40,
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'BonusSchemeName',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "�������",
			dataIndex : 'BonusYear',
			width : 40,
			align : 'left',
			sortable : true
		}, {
			header : "�����ڼ�",
			dataIndex : 'BonusPeriod',
			width : 40,
			align : 'left',
			sortable : true
		}, {
			header : "�Ƿ����",
			dataIndex : 'CalcFlag',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "����ʱ��",
			dataIndex : 'CalcDate',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : "�Ƿ����",
			dataIndex : 'AuditingFlag',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "���ʱ��",
			dataIndex : 'AuditingDate',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "�·���־",
			dataIndex : 'IsPay',
			width : 50,
			align : 'center',
			sortable : true,
			renderer : function(v, p, record) {
				if (v == 1) {
					return "�·��ɹ�";
				} else {
					return "";
				}
			}
		}, {
			header : "�·���",
			dataIndex : 'person',
			width : 40,
			align : 'center',
			sortable : true
		}, {
			header : "�·�ʱ��",
			dataIndex : 'IsDate',
			width : 80,
			align : 'center',
			sortable : true
		}]);

// ���𷽰�����
var BonusCalcButton = new Ext.Toolbar.Button({
			text : '�������',
			tooltip : '�������',
			iconCls : 'add',
			handler : function() {
				schemeCalc(SchemGrid, schemDs);
			}
		});

// ���𷽰����
var BonusAuditingButton = new Ext.Toolbar.Button({
			text : '�������',
			tooltip : '�������',
			iconCls : 'add',
			handler : function() {
				schemeAuditing(SchemGrid, schemDs);
			}
		});
// ������Ա�·�����
var uploadButton = new Ext.Toolbar.Button({
			text : '������Ա����',
			tooltip : '��������(Excel��ʽ)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});

// ==============2012-3-30===limingzhong====�����·�===============================================
var DownButton = new Ext.Toolbar.Button({
	text : '�����·�',
	tooltip : '���͸����ҽ��н�����η��䣡',
	iconCls : 'add',
	handler : function() {
		var rowObj = SchemGrid.getSelections();
		var len = rowObj.length;
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ�񽱽𷽰�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return false;
		} else {

			function datadown(rowObj) {

				var schemCode = rowObj[0].get("BonusSchemeCode");
				var year = Ext.getCmp('periodYear').getValue();
				var period = Ext.getCmp('periodField').getValue();
				var isCalc = rowObj[0].get("rowid")
				if(year==""){
				         Ext.Msg.show({
							title : 'ע��',
							msg : '������Ȳ���Ϊ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				       return false;
			}
			if(isCalc==''){
				         Ext.Msg.show({
							title : 'ע��',
							msg : '���½���δ���㣬�����·�!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				       return false;
			}
				
				// alert('../csp/dhc.bonus.deptbonuscalcexe.csp?action=down&schemCode='+schemCode+'&year='+year+'&period='+period+'&userCode='+session['LOGON.USERCODE'])
				Ext.Ajax.request({
					url : '../csp/dhc.bonus.deptbonuscalcexe.csp?action=down&schemCode='
							+ schemCode
							+ '&year='
							+ year
							+ '&period='
							+ period
							+ '&userCode=' + session['LOGON.USERCODE'],
					waitMsg : '�����·���...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '��ʾ',
									msg : '������������...',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						// alert(jsonData)
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '��ʾ',
										msg : '�����·��ɹ�!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});
							schemDs.load({
										params : {
											bonusYear : year,
											bonusPeriod : period,
											schemeType : p_SchemeType,
											userCode : session['LOGON.USERCODE'],
											start : 0,
											limit : schemPagingToolbar.pageSize
										}
									});
						} else {
							Ext.Msg.show({
										title : '����',
										msg : '�����·�ʧ��',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this
				});
			}

			// 1.�жϸ÷����Ƿ��Ѿ������
			var auditFlag = rowObj[0].get("AuditingFlag");
			if (auditFlag == "�����") {

				// 2.�����������н����·�������
				if (rowObj[0].get("IsPay") == "1") {

					Ext.MessageBox.confirm('��ʾ', '�����Ѿ��·����Ƿ�Ҫ�����·�?', handler1);
					function handler1(id) {
						if (id == "yes") {
							datadown(rowObj)
						}
					}
	
				} else {
					datadown(rowObj)

				}
			} else if (auditFlag == "δ���"){
				Ext.Msg.show({
							title : 'ע��',
							msg : '�÷���δ��ˣ��������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
		}
	}
});
// ==============2012-3-30===limingzhong====�����·�===============================================

// ���𷽰�����
var BonusPayButton = new Ext.Toolbar.Button({
			text : '���𷢷�',
			tooltip : '���𷢷�',
			iconCls : 'add',
			handler : function() {
				// editJXUnitFun(SchemGrid, bonusItemDs,
				// bonusitemgrid,jxUnitPagingToolbar);
				schemePay(SchemGrid, schemDs);
			}
		});

var schemPagingToolbar = new Ext.PagingToolbar({// ��ҳ������
	pageSize : 25,
	store : schemDs,
	displayInfo : true,
	displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg : "û������",
	doLoad : function(C) {
		var B = {}, A = this.paramNames;
		B[A.start] = C;
		B[A.limit] = this.pageSize;
		B['period'] = Ext.getCmp('periodTypeField').getValue();
		B['dir'] = "asc";
		B['sort'] = "rowid";
		if (this.fireEvent("beforechange", this, B) !== false) {
			this.store.load({
						params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								userCode : session['LOGON.USERCODE'],
								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
					});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({// ���
	title : '��Ԫ���𷽰�����',
	region : 'north',
	height : 210,
	minSize : 350,
	maxSize : 450,
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	store : schemDs,
	cm : schemCm,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	viewConfig : {
		forceFit : true
	},
	tbar : ['��������:', schemeTypeCombo, '�������:', periodYear, '-', '�ڼ�����:',
			periodTypeField, '-', '�����ڼ�:', periodField, '-', BonusCalcButton,
			'-', BonusAuditingButton, '-', DownButton],
	bbar : schemPagingToolbar
});
// ,'-',uploadButton
// ------����¼�����-----begin-----------------

// �����ڼ� ѡ���ڼ�
periodField.on("select", function(cmb, rec, id) {
			if (Ext.getCmp('periodField').getValue() != '') {
				tmpStore.removeAll();

				schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								schemeType : p_SchemeType,
								userCode : session['LOGON.USERCODE'],
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});
			}
			// ��ʾ���������ϸ
			schemDs.on('load', function(ds, o) {
						showBonusDetail(SchemGrid, 0, '');
					});

		});

var schemRowId = "";
var schemName = "";

// ����������㷽����ˢ�� ���㵥Ԫ������
SchemGrid.on('rowclick', function(grid, rowIndex, e) {
			showBonusDetail(grid, rowIndex, e)
		});
// ���𷽰�����
schemDs.on("beforeload", function(ds) {
			bonusItemDs.removeAll();
			schemRowId = "";
			bonusitemgrid.setTitle("���𷽰���������ϸ");
		});

var tmpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ''
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}),
			remoteSort : true
		});

// ----------------��������------------------------------------
// ��ʾ���������ϸ
function showBonusDetail(grid, rowIndex, e) {

	var selectedRow = schemDs.data.items[rowIndex];

	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["BonusSchemeName"];
	schemCode = selectedRow.data["BonusSchemeCode"];
	// var str=schemRowId+":"+schemCode+":"+schemName

	sbonusYear = Ext.getCmp('periodYear').getValue(), sbonusPeriod = Ext
			.getCmp('periodField').getValue(),

	bonusitemgrid.setTitle(schemName + "-����Ӧ���������");
	Ext.Ajax.request({
		url : '../csp/dhc.bonus.deptbonuscalcexe.csp?action=getTitleInfo&sMainSchemeCode='
				+ schemCode,
		waitMsg : '���ں�����...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '����',
						msg : '������������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);

			var cmItems = [];
			var cmConfig = {};
			// cmItems.push(sm);
			cmItems.push(new Ext.grid.RowNumberer());

			var cmConfig = {};
			var jsonHeadNum = jsonData.results;
			
			var jsonHeadList = jsonData.rows;
			var tmpDataMapping = [];
			
			
			for (var i = 0; i < jsonHeadList.length; i++) {
				if (i<3) { 
				cmConfig = {
					header : jsonHeadList[i].title,
					dataIndex : jsonHeadList[i].IndexName,
					width : 95,
					sortable : true,
					align : 'left',
					editor : new Ext.form.TextField({
								allowBlank : true
							})
				};
				} else
				{
				cmConfig = {
					header : jsonHeadList[i].title,
					dataIndex : jsonHeadList[i].IndexName,
					width : 95,
					sortable : true,
					align : 'right',
					editor : new Ext.form.TextField({
								allowBlank : true
							})

					}}

				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// ��ȡ����������
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping

			tmpStore.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.deptbonuscalcexe.csp?action=getBonusDetail&sMainSchemeCode='
						+ schemCode
						+ '&bonusPeriod='
						+ sbonusPeriod
						+ '&bonusYear=' + sbonusYear,
				method : 'POST'
			})

			tmpStore.reader = new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, tmpDataMapping);

			bonusitemgrid.reconfigure(tmpStore, tmpColumnModel);
			tmpStore.load({
						params : {
							start : 0,
							limit : jxUnitPagingToolbar.pageSize
						}
					});
			jxUnitPagingToolbar.bind(tmpStore);
		},
		scope : this
	});

}

// ���𷽰�����
function schemeCalc(SchemGrid, schemDs) {
	var rowObj = SchemGrid.getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ����Ľ��𷽰�!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}


   var Year= periodYear.getValue();                  //�������
   var periodType = periodTypeField.getValue();     //�ڼ�����
   var period = periodField.getValue();            //�����ڼ�
	
	
	
	if (Year == "") {
		Ext.Msg.show({
					title : '����',
					msg : '������Ȳ���Ϊ��',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				return;
			};
	
	if (periodType == "") {
		Ext.Msg.show({
					title : '����',
					msg : '�ڼ����Ͳ���Ϊ��',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				return;
			};
			
			
	if (period == "") {
		Ext.Msg.show({
					title : '����',
					msg : '�����ڼ䲻��Ϊ��',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				return;
			};
			
			
	var isCalc = rowObj[0].get("rowid")
	var BonusSchemeCode = rowObj[0].get("BonusSchemeCode")
	var sBonusPeriod = rowObj[0].get("BonusYear") + "^"
			+ Ext.getCmp('periodField').getValue()

	if (isCalc != '') {
		Ext.MessageBox.confirm('��ʾ', '�ý��𷽰��Ѿ����㣬ȷʵҪ���º�����?', handler);
		return false;
	}

	Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ����ý��𷽰���?', handler);

	function handler(id) {

		if (id == 'yes') {

			// ��ӽ�����������
			var progressBar = Ext.Msg.show({
						title : "�������",
						msg : "'���ں�����...",
						width : 300,
						wait : true,
						closable : true
					});
	//------------------------------------------			
			var year = rowObj[0].get("BonusYear")	
			var month = Ext.getCmp('periodField').getValue()
					
			 var flag ="";
		     Ext.Ajax.request({
					url:  schemUrl + '?action=statejudgement&year=' + year + '&month='+ month ,
							waitMsg : '������...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									flag = jsonData.info;
									if (flag==0) {
										Ext.Msg.show({
											title : 'ע��',
											msg : '�������ݲɼ��У����ܽ��к���!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										}
										
										else if(flag ==-1) {
										Ext.Msg.show({
											title : 'ע��',
											msg : '�������û���ڼ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										return;
										}
										
									else if(flag==2) {
										Ext.Msg.show({
											title : 'ע��',
											msg : '���������Ѿ����ˣ����ܽ��к���!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										}
									else{
										var surl = schemUrl + '?action=bonuscalc&BonusSchemeCode='
						                           + BonusSchemeCode + '&sBonusPeriod=' + sBonusPeriod;
										Account(surl)
											}
									} else {
										Ext.Msg.show({
											title : '����',
											msg : '����',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
										}
								},
								scope : this
								});
//----------------------------------------------------------
//			Ext.Ajax.request({
//				url : schemUrl + '?action=bonuscalc&BonusSchemeCode='
//						+ BonusSchemeCode + '&sBonusPeriod=' + sBonusPeriod,
//				waitMsg : '���ں�����...',
//				timeout: 100000000,
//				failure : function(result, request) {
//					Ext.Msg.show({
//								title : '��ʾ��',
//								msg : '�������ں���,�����Ժ�......',
//								buttons : Ext.Msg.OK,
//								icon : Ext.MessageBox.ERROR
//							});
//				},
//				success : function(result, request) {
//					var rtn = result.responseText;
//					// prompt("result",rtn)
//
//					var jsonData = Ext.util.JSON.decode(result.responseText);
//
//					if (jsonData.success == 'true') {
//						Ext.Msg.show({
//									title : 'ע��',
//									msg : '���ݺ���ɹ�!',
//									buttons : Ext.Msg.OK,
//									icon : Ext.MessageBox.INFO
//								});
//
//						schemDs.load({
//							params : {
//								bonusYear : Ext.getCmp('periodYear').getValue(),
//								bonusPeriod : Ext.getCmp('periodField')
//										.getValue(),
//								userCode : session['LOGON.USERCODE'],
//								schemeType : p_SchemeType,
//								start : 0,
//								limit : schemPagingToolbar.pageSize
//							}
//						});
//
//						// showBonusDetail(SchemGrid, 1)
//
//						window.close();
//					} else {
//						var message = "";
//						message = "���𷽰�����ʧ�ܣ�";
//						Ext.Msg.show({
//									title : '����',
//									msg : jsonData.info,
//									buttons : Ext.Msg.OK,
//									icon : Ext.MessageBox.ERROR
//								});
//					}
//				},
//				scope : this
//			});

		}
	}

}
// ���𷽰����
function schemeAuditing(SchemGrid, schemDs) {

	var rowObj = SchemGrid.getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ��˵�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	var rowid = rowObj[0].get("rowid")
	var isCalc = rowObj[0].get("rowid")
	var IsAuditing = rowObj[0].get("AuditingFlag")

	if (isCalc == '') {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�÷���δ���н�����㣬���Ƚ��н������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}
	if (IsAuditing == '�����') {
		Ext.Msg.show({
					title : 'ע��',
					msg : '�ý��𷽰��Ѿ����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ��˸÷�����?', Auditing);

	function Auditing(id) {

		if (id == 'yes') {

			Ext.Ajax.request({
				url : schemUrl + '?action=auditing&rowid=' + rowid
						+ '&IsAuditing=1',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					if (rtn == 0) {
						Ext.Msg.show({
									title : 'ע��',
									msg : '������˳ɹ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								schemeType : p_SchemeType,
								userCode : session['LOGON.USERCODE'],
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});

						window.close();
					} else {
						var message = "";
						message = "���𷽰����ʧ�ܣ�";
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
	}

}

function Account(surl){
         Ext.Ajax.request({
				url : surl,
				waitMsg : '���ں�����...',
				timeout: 100000000,
				failure : function(result, request) {
					Ext.Msg.show({
								title : '��ʾ��',
								msg : '�������ں���,�����Ժ�......',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					// prompt("result",rtn)

					var jsonData = Ext.util.JSON.decode(result.responseText);

					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : 'ע��',
									msg : '���ݺ���ɹ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});

						schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								userCode : session['LOGON.USERCODE'],
								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});

						// showBonusDetail(SchemGrid, 1)

						window.close();
					} else {
						var message = "";
						message = "���𷽰�����ʧ�ܣ�";
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
