// ����:��Ӧ�̹�Ӧ��Ŀά��
// ��д����:2013-05-2
var currVendorRowId='';
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var APCVendorGridUrl="dhcstm.itmvenaction.csp"

// ����
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor:'90%'
});
//��Ӧ�� 
var conditionNameField = new Ext.ux.VendorComboBox({
	id:'conditionNameField',
	fieldLabel:'��Ӧ������',
	params : {ScgId : 'StkGrpType'},
	allowBlank:true,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText:'��Ӧ������...',
	anchor:'90%'
});

//����ҩƷ���岢���ؽ��
function GetPhaOrderInfo(item, group) {				
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}
	
// ���ط���
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var conditionNameField=Ext.getCmp("conditionNameField").getValue();
	var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
	// ѡ����
	var row = cell[0];
	var rowData = APCVendorGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("MCode",inciCode);
	rowData.set("MDesc",inciDesc);
	rowData.set("Vendor",conditionNameField);
	var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;	
	var url = DictUrl
				+ "ingdrecaction.csp?actiontype=GetItmInfo";
	Ext.Ajax.request({
				url : url,
				params : {IncId:inciDr,Params:Params},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var data=jsonData.info.split("^");
						addComboData(PhManufacturerStore, data[0], data[1]);
						rowData.set("PhManf", data[0]);
					}
				},
				scope : this
			});

	//�������������
	var colIndex=GetColIndex(APCVendorGrid,'Carrier');
	APCVendorGrid.startEditing(row, colIndex);			
}
//������
var Carrier = new Ext.ux.ComboBox({
	fieldLabel : '�б�������',
	id : 'INFOPbCarrier',
	name : 'INFOPbCarrier',
	store : CarrierStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CADesc'
});

// ��������
var Phmnf = new Ext.ux.ComboBox({
	fieldLabel : '��������',
	id : 'Phmnf',
	name : 'Phmnf',
	anchor : '90%',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	params : {ScgId : 'StkGrpType'}
});

//�������
INFOQualityLevelStore.load();
var QutyLevel = new Ext.ux.ComboBox({
	fieldLabel : '�������',
	id : 'INFOQualityLevel',
	name : 'INFOQualityLevel',
	anchor : '90%',
	store : INFOQualityLevelStore,
	valueField : 'RowId',
	displayField : 'Description'
});

var findAPCVendor = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query();
	}
});

var addAPCVendor = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		APCVendorGrid.store.removeAll();
		APCVendorPagingToolbar.getComponent(4).setValue(1);   //���õ�ǰҳ��
		APCVendorPagingToolbar.getComponent(5).setText("ҳ,�� 1 ҳ");//���ù���ҳ
		APCVendorPagingToolbar.getComponent(12).setText("û�м�¼"); //���ü�¼����
		addNewRow();
	}
});
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '����',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		// ����
		saveOrder();
	}
});

//ɾ����ť
var deleteMarkType = new Ext.Toolbar.Button({
    text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
	    deleteDetail();
	}
});
			
var Win = new Ext.grid.CheckColumn({
    header:'�Ƿ��б��־',
    dataIndex:'Win',
    width:80,
    sortable:true
});
var RecPurMark = new Ext.grid.CheckColumn({
    header:'�����ɹ���־',
    dataIndex:'RecPurMark',
    width:80,
    sortable:true
});
//ģ��
var nm = new Ext.grid.RowNumberer();
var APCVendorGridCm = new Ext.grid.ColumnModel([nm, {
			header : "RowId",
			dataIndex : 'RowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "IncRowid",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "���ʴ���",
			dataIndex : 'MCode',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'MDesc',
			width : 120,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var Vendor = Ext.getCmp("conditionNameField").getValue();
									if (Vendor == "") {
										Msg.info("warning", "��Ӧ�̲���Ϊ��!");
										return;
									}
									var group = Ext.getCmp("StkGrpType").getValue();
									GetPhaOrderInfo(field.getValue(), group);
								}
							}
						}
					}))
		}, {
			header : "��Ӧ��",
			dataIndex : 'Vendor',
			width : 250,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.comboRenderer2(conditionNameField, "Vendor", "VendorDesc")
		}, {
			header : "����",
			dataIndex : 'PhManf',
			width : 250,
			align : 'left',
			sortable : true,
			editable : false,
			renderer : Ext.util.Format.comboRenderer2(Phmnf, "PhManf", "PhManfDesc"),
			editor : new Ext.grid.GridEditor(Phmnf, new Ext.form.TextField({
								selectOnFocus : true,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
											var record = APCVendorGrid.getStore().getAt(cell[0]);
											var colIndex = GetColIndex(APCVendorGrid, 'StartDate');
											APCVendorGrid.startEditing(cell[0],colIndex);
										}
									}
								}
							}))
		}, {
			header : "������",
			dataIndex : 'Carrier',
			width : 250,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.comboRenderer2(Carrier, "Carrier",
					"CarrierDesc"),
			editor : new Ext.grid.GridEditor(Carrier, new Ext.form.TextField({
								selectOnFocus : true,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
											var record = APCVendorGrid.getStore().getAt(cell[0]);
											var colIndex = GetColIndex(APCVendorGrid, 'StartDate');
											APCVendorGrid.startEditing(cell[0],colIndex);
										}
									}
								}
							}))
		}, {
			header : "��ʼ����",
			dataIndex : 'StartDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : new Ext.ux.DateField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'EndDate');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : "��ֹ����",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : new Ext.ux.DateField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore()
											.getAt(cell[0]);
									var SDate = record.get("StartDate")// .format(ARG_DATEFORMAT)
									var EDate = field.getValue()// .format(ARG_DATEFORMAT);
									if ((SDate != "") & (EDate != "")) {
										if (EDate.format(ARG_DATEFORMAT) < SDate.format(ARG_DATEFORMAT)) {
											Msg.info("warning","��ֹ���ڲ���С�ڿ�ʼ����!");
											return;
										}
									}
									// alert(EDate)
									var colIndex = GetColIndex(APCVendorGrid,'BeforeRp');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : "�б�ǰ����",
			dataIndex : 'BeforeRp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'DealRp');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : "Э�����",
			dataIndex : 'DealRp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore().getAt(cell[0]);
									var colIndex = GetColIndex(APCVendorGrid,'BeforeSp');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : "�б�ǰ�ۼ�",
			dataIndex : 'BeforeSp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'DealSp');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : 'Э���ۼ�',
			dataIndex : 'DealSp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore().getAt(cell[0]);
									var colIndex = GetColIndex(APCVendorGrid,'QutyLevel');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : '�������',
			dataIndex : 'QutyLevel',
			width : 100,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.comboRenderer(QutyLevel),
			editor : new Ext.grid.GridEditor(QutyLevel, new Ext.form.TextField(
							{
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
											var record = APCVendorGrid.getStore().getAt(cell[0]);
											var colIndex = GetColIndex(APCVendorGrid, 'HighSp');
											APCVendorGrid.startEditing(cell[0],colIndex);
										}
									}
								}
							}))
		}, {
			header : '����ۼ�',
			dataIndex : 'HighSp',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
									var record = APCVendorGrid.getStore().getAt(cell[0]);
									var colIndex = GetColIndex(APCVendorGrid,'Num');
									APCVendorGrid.startEditing(cell[0],colIndex);
								}
							}
						}
					})
		}, {
			header : '�����б����',
			dataIndex : 'Num',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
							var record = APCVendorGrid.getStore().getAt(cell[0]);
							var colIndex = GetColIndex(APCVendorGrid, 'Remark');
							APCVendorGrid.startEditing(cell[0], colIndex);
						}
					}
				}
			})
		}, {
			header : '���',
			dataIndex : 'Sort',
			width : 150,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '��ע',
			dataIndex : 'Remark',
			width : 150,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addNewRow()
								}
							}
						}
					})
		}, Win, RecPurMark]);

//��ʼ��Ĭ��������
APCVendorGridCm.defaultSortable = true;

function addNewRow() {
	var NewRecord = CreateRecordInstance(APCVendorGridDs.fields,{})
    APCVendorGridDs.add(NewRecord);
    var col = GetColIndex(APCVendorGrid,'MDesc');
    APCVendorGrid.startEditing(APCVendorGridDs.getCount() - 1, col);
}

// ����·��
var DetailUrl =DictUrl+
	'itmvenaction.csp?actiontype=Query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
	});
		
// ָ���в���
var fields = ["RowId", "IncId", "MDesc","Vendor","VendorDesc","Carrier","CarrierDesc","PhManf","PhManfDesc",{name:'StartDate',type:'date',dateFormat:DateFormat},
	{name:'EndDate',type:'date',dateFormat:DateFormat},"BeforeRp","DealRp","BeforeSp","DealSp",
	"QutyLevel","HighSp","Num","Sort","Remark","Win","RecPurMark","MCode"];
	
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
});
// ���ݼ�
var APCVendorGridDs = new Ext.data.Store({
		proxy : proxy,
		reader : reader
});

//���湩Ӧ��Ŀ��ϸ
function saveOrder(){
	var Vendor=Ext.getCmp("conditionNameField").getValue();
	var ListDetail="";
	var rowCount = APCVendorGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = APCVendorGridDs.getAt(i);
		//���������ݷ����仯ʱִ����������
		if(rowData.data.newRecord || rowData.dirty){
			var RowId=rowData.get("RowId"); 
			var IncId=rowData.get("IncId");
			var MDesc=rowData.get("MDesc");	
			var Carrier=rowData.get("Carrier");	
			var PhManf=rowData.get("PhManf");
			var StartDate =Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
			var EndDate =Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
			var BeforeRp=rowData.get("BeforeRp");
			var DealRp=rowData.get("DealRp");
			var BeforeSp=rowData.get("BeforeSp");
			var DealSp=rowData.get("DealSp");
			var QutyLevel=rowData.get("QutyLevel");
			var HighSp=rowData.get("HighSp");
			var Num=rowData.get("Num");
			var Sort=rowData.get("Sort");  
			var Remark=rowData.get("Remark");    
			var Win=rowData.get("Win");  
			var RecPurMark=rowData.get("RecPurMark");
			//alert("StartDate="+Vendor)
			var str= Vendor + "^" + IncId+"^"+Carrier+"^"+PhManf+"^"+StartDate+"^"+EndDate+"^"+BeforeRp+"^"
				    +DealRp+"^"+BeforeSp+"^"+DealSp+"^"+ QutyLevel+"^"+ HighSp+"^"+Num +"^"+Sort+"^"+ Remark +"^"+ Win +"^"+RecPurMark+"^"+RowId
				
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
	}
	                   
	if(ListDetail==""){
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var url = DictUrl+"itmvenaction.csp?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
							.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					// ˢ�½���
					var IngrRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					Query();
					//APCVendorGridDs.load();
				}else{
					var ret=jsonData.info;
					if (ret=-100){
						Msg.info("warning","�ù�Ӧ�̵ĸ������Ѿ�ά��");
						return;
					}else{
						Msg.info("error", "������ϸ���治�ɹ���"+ret);
					}
				}
			},
			scope : this
		});
	}
}

//��ѯ����
function Query(){
	var Vendor=Ext.getCmp("conditionNameField").getValue();
	var Stkcat=Ext.getCmp("StkGrpType").getValue();
	APCVendorGridDs.setBaseParam('Vendor',Vendor);
	APCVendorGridDs.setBaseParam('Stkcat',Stkcat);
	APCVendorGridDs.removeAll();
	APCVendorGridDs.load({
		params:{start:0,limit:APCVendorPagingToolbar.pageSize},
		callback:function(r,options,success){
			if(success==false){
				Msg.info("error","��ѯ����, ��鿴��־!");
			}
		}
	});
}
function deleteDetail(){
	var cell = APCVendorGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}else{
		var record = APCVendorGrid.getStore().getAt(cell[0]);
		var RowId = record.get("RowId");
		if (RowId!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',function(btn){
				if(btn=="yes"){
					var url = DictUrl+"itmvenaction.csp?actiontype=Delete&rowid="+RowId;
					var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
					Ext.Ajax.request({
						url:url,
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Msg.info("error","������������!");
							mask.hide();
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							mask.hide();
							if (jsonData.success=='true') {
								Msg.info("success","ɾ���ɹ�!");
									var Vendor=Ext.getCmp("conditionNameField").getValue();
									Query(Vendor)
							}else{
								Msg.info("error","ɾ��ʧ��!");
							}
						},
						scope: this
					});
				}
			})
		}else{
			var rowInd=cell[0];      
			if (rowInd>=0){
				APCVendorGrid.getStore().removeAt(rowInd);
			}
		}
	}   
}

var editAPCVendor = new Ext.Toolbar.Button({
	text:'�༭',
    tooltip:'�༭',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowindex = APCVendorGrid.getSelectionModel().getSelectedCell()[0]; 
		var rowObj=APCVendorGrid.getStore().getAt(rowindex)
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var IncId = rowObj.get('IncId');
			var PhManf = rowObj.get('PhManf');
			var list=IncId+"^"+PhManf;
			if (PhManf==""){
				Msg.info("warning","����Ϊ��,������ʾ����������Ϣ!");
				return;
			}else if (IncId==""){
				Msg.info("warning","�������Ʋ���Ϊ��!");
				return;
			}
			//������ʾ
			CreateEditWin(list);
		}
	}
});
 
var formPanel = new Ext.ux.FormPanel({
	title:'��Ӧ�̹����б�ά��',
    tbar:[findAPCVendor,'-',addAPCVendor,'-',SaveBT,'-',deleteMarkType],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},		
		items : [{
				columnWidth : .33,
				items : [StkGrpType]
			}, {
				columnWidth : .33,
				items : [conditionNameField]
			}]
	}]

});

//��ҳ������
var APCVendorPagingToolbar = new Ext.PagingToolbar({
	store:APCVendorGridDs,
	pageSize:30,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��'
});

//���
APCVendorGrid = new Ext.grid.EditorGridPanel({
	store:APCVendorGridDs,
	cm:APCVendorGridCm,
	title:'��Ӧ��Ŀ��ϸ',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	height:690,
	stripeRows:true,
	plugins:[Win,RecPurMark],
    sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:APCVendorPagingToolbar,
   	listeners:{
		'rowdblclick':function(){
			editAPCVendor.handler();
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,APCVendorGrid],
		renderTo:'mainPanel'
	});
	Query()
});