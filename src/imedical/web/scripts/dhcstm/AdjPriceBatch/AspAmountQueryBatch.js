// /����:�����������β�ѯ
// /����:�����������β�ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.08

Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	var InciDr = new Ext.ux.TextField({
				fieldLabel : 'InciDr',
				id : 'InciDr',
				name : 'InciDr'
			});

	var ItmDesc = new Ext.ux.TextField({
				fieldLabel : '��������',
				id : 'ItmDesc',
				name : 'ItmDesc',
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var item=field.getValue();
							if (item != null && item.length > 0) {
								GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",getDrugList);
							}
						}
					}
				}
			});

	// ���۵���
	var AspBatNo = new Ext.ux.TextField({
				fieldLabel : '���۵���',
				id : 'AspBatNo',
				name : 'AspBatNo'
			});

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			value : new Date().add(Date.DAY,-1)
		});

	// ��������
	var EndDate= new Ext.ux.DateField({
			fieldLabel : '��������',
			id : 'EndDate',
			name : 'EndDate',
			value : new Date()
		});
	var StartTime=new Ext.ux.TimeField({
		fieldLabel : '<font color=blue>��ʼʱ��</font>',
		id : 'StartTime',
		name : 'StartTime'
	});	

	var EndTime=new Ext.ux.TimeField({
		fieldLabel : '<font color=blue>��ֹʱ��</font>',
		id : 'EndTime',
		name : 'EndTime'
	});
	// ����
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'Loc',
		name : 'Loc',
		groupId:gGroupId
	});
	ReasonForAdjSpStore.load();
	var AspReason=new Ext.form.ComboBox({
		id:'AspReason',
		fieldLabel:'����ԭ��',
		name:'AspReason',
		width:100,
		anchor:'90%',
		emptyText:'����ԭ��',
		store:ReasonForAdjSpStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	
	var OptType=new Ext.form.RadioGroup({
		id:'OptType',
		columns:1,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'ȫ��',name:'type',inputValue:0,checked:true},
			{boxLabel:'���Ϊ��',name:'type',inputValue:1},
			{boxLabel:'���Ϊ��',name:'type',inputValue:-1}
		]
	});
	
	// ��ѯ
	var SearchBT = new Ext.ux.Button({
				id : "SearchBT",
				text : '��ѯ',
				iconCls : 'page_find',
				handler : function() {
					getAspBatAmount();
				}
			});

	// ��հ�ť
	var ClearBT = new Ext.ux.Button({
				id : "ClearBT",
				text : '���',
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("Loc").getStore(),'Loc');
		Ext.getCmp("InciDr").setValue("");
		Ext.getCmp("AspBatNo").setValue("");
		Ext.getCmp("ItmDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("OptType").setValue(0);
		Ext.getCmp("StartTime").setValue("");
		Ext.getCmp("EndTime").setValue("");
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

    function priceRender(value, metaData, record, rowIndex, colIndex, store){
	    if (value<0){
		    metaData.style="text-align:right;color:red;";
		}else if (value>0){
		    metaData.style="text-align:right;color:green;";
		}
	     return value;
	    };
	//���·�������ΪExcel����������ȡ��ʹ��    
	    /*
	function priceRender(val){
		var val = Ext.util.Format.number(val,'0.00');
		if(val<0){
			return '<span style="color:red;">'+val+'</span>';
		}else if(val>0){
			return '<span style="color:green;">'+val+'</span>';
		}
		return val;
	}*/
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+ 'inadjpricebatchaction.csp?actiontype=QueryAspBatchAmount';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["AspaId", "IncCode","IncDesc", "Spec", "AspUom","StkLbQty", 
			 "PriorSp","ResultSp", "DiffSp", "PriorRp",
			"ResultRp", "DiffRp", "SpLbAmt", "RpLbAmt","AspReason","ExecuteDate",
			"AspUser","LocDesc","BatExp","Incib"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "AspaId",
		fields : fields
	});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					StartDate:'',
					EndDate:'',
					Others:'',
					StartTime:'',
					EndTime:''
				},
				remoteSort:true
			});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "AspaId",
				dataIndex : 'AspaId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {   
			    header : "Incib",
				dataIndex : 'Incib',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���ʴ���",
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'IncDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
			    header : "����/Ч��",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : false
			},{
				header : "���",
				dataIndex : 'Spec',
				width : 80,
				align : 'left'
			}, {
				header : '���۵�λ',
				dataIndex : 'AspUom',
				width : 80,
				align : 'left',
				sortable : false
			}, {
				header : "�����",
				dataIndex : 'StkLbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "��ǰ�ۼ�",
				dataIndex : 'PriorSp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "�����ۼ�",
				dataIndex : 'ResultSp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "���(�ۼ�)",
				dataIndex : 'DiffSp',
				width : 80,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "��ǰ����",
				dataIndex : 'PriorRp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header:"�������",
				dataIndex:"ResultRp",
				width : 90,
				renderer:priceRender,
				align : 'right'
			},{
				header : "���(����)",
				dataIndex : 'DiffRp',
				width : 90,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "������(�ۼ�)",
				dataIndex : 'SpLbAmt',
				width : 80,
				align : 'right',
				renderer:priceRender,
				sortable : true				
			}, {
				header : "������(����)",
				dataIndex : 'RpLbAmt',
				width : 80,
				align : 'right',
				renderer:priceRender,
				sortable : true
			}, {
				header : "����",
				dataIndex : 'LocDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����ԭ��",
				dataIndex : 'AspReason',
				width : 80,
				align : 'left'
			}, {
				header : "��Ч����",
				dataIndex : 'ExecuteDate',
				width : 100,
				align : 'left'
			}, {
				header : "������",
				dataIndex : 'AspUser',
				width : 80,
				align : 'left'
			}]);

	var DetailPageToolBar=new Ext.ux.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize
	});

	var DetailGrid = new Ext.ux.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '������ϸ(����)',
				cm : DetailCm,
				store : DetailStore,
				sm :new Ext.grid.RowSelectionModel({singleSelect:true}),
				bbar:DetailPageToolBar
			});

			
	/**
	 * ���ط���
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		;
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		Ext.getCmp('InciDr').setValue(inciDr);			
		;			
	}
	
	// ��ʾ���۵�����
	function getAspBatAmount() {
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if(InciDesc==null || InciDesc==""){
			Ext.getCmp("InciDr").setValue("");
		}
		var InciRowid=Ext.getCmp("InciDr").getValue();
		if(InciRowid!=""&InciRowid!=null){
			InciDesc="";
		}		
		var AspBatNo=Ext.getCmp("AspBatNo").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
		
		var LocId=Ext.getCmp("Loc").getValue();
		var AspReasonId=Ext.getCmp("AspReason").getValue();
		var optType=Ext.getCmp("OptType").getValue().getGroupValue();
		var Others=LocId+"^"+AspBatNo+"^"+AspReasonId+"^"+optType+"^"+InciRowid+"^^^^"+InciDesc;
		if (StartDate == null || StartDate.length <= 0 ) {
			Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
			Ext.getCmp("StartDate").focus();
			return;
		}
		else{
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		if (EndDate == null || EndDate.length <= 0 ) {
			Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
			Ext.getCmp("EndDate").focus();
			return;
		}
		else{
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		DetailStore.setBaseParam("StartTime",startTime);
		DetailStore.setBaseParam("EndTime",endTime);
		var pagesize=DetailPageToolBar.pageSize;
		DetailStore.removeAll();
		DetailStore.load({params:{start:0,limit:pagesize}});
	}
	
	var MainForm = new Ext.ux.FormPanel({
		title:'���������ѯ(����)',
		tbar : [SearchBT, '-', ClearBT],
		items : [{					
				xtype : 'fieldset',
				title : '��ѯ����',
				defaults:{xtype : 'fieldset',border:false},
				layout : 'column',
				style : 'padding:5px 0px 0px 5px',
				items : [{
					columnWidth : .2,
					items : [StartDate,EndDate]
				},{
					columnWidth : .2,
					items : [StartTime,EndTime]
				},{
					columnWidth : .25,
					items : [Loc,AspBatNo]
				},{ 
					columnWidth : .22,
					items : [ItmDesc]
				},{
					columnWidth : .13,
					items : [OptType]					
				}]								
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [MainForm, DetailGrid]
	});
});

