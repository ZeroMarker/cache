// /����: ������ѯ
// /����: ������ѯ
// /��д�ߣ�yangshijie
// /��д����: 2019-12-19
Ext.onReady(function() {

	var gGroupId = session['LOGON.GROUPID'];
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		groupId : gGroupId
	});
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		//width : 120,
		value : DefaultStDate()
	});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		//width : 120,
		value : DefaultEdDate()
	});

	var inpoNoField = new Ext.form.TextField({
		id:'inpoNoField2',
		fieldLabel:'������',
		allowBlank:true,
		emptyText:'������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	// ��������
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '����',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		width : 150,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = '';  //Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});
	var IncId = new Ext.form.TextField({
		fieldLabel : '����',
		id : 'IncId',
		name : 'IncId',
		hidden:true
	});
		/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, stktype) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
		}
	}
	
	/**
	 * ���ط���
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var InciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(InciDesc);
		Ext.getCmp("IncId").setValue(inciDr);
	}
	// ��Ӧ��
	var apcVendorField = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor : '90%',
		emptyText : '��Ӧ��...'
	});
	
	
	var finishflag = new Ext.form.Checkbox({
		id: 'finishflag',
		fieldLabel:'���',
		allowBlank:true,
		anchor:'90%'
	});
		
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '��ѯ',
		tooltip : '�����ѯ����',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});


	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	var cancelBt=new Ext.Toolbar.Button({
		id : "cancelBT",
		text : 'ȡ��',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			if (win) win.close();
		}
	})
	// ��ӡ��ť
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '�����ӡ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
							return;
						}
						var PoId = rowData.get("PoId");
						var PoNo = rowData.get("PoNo");
						var Vendor = rowData.get("Vendor");
						var PoDate = rowData.get("PoDate");
						
						var printtype=""
						if (printtype==1) {
							//ֱ�Ӵ�ӡ
							fileName="{DHCST_INPO_Detail.raq(Parref="+PoId+";vendor="+Vendor+";inpono="+PoNo+";inpodate="+PoDate+")}";
							DHCCPM_RQDirectPrint(fileName);
						}
						else {
							//Ԥ����ӡ	
							fileName="DHCST_INPO_Detail.raq&Parref="+PoId+"&vendor="+Vendor+"&inpono="+PoNo+"&inpodate="+PoDate;
							DHCCPM_RQPrint(fileName)	
						}
						
					}
	});
	
	
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("inpoNoField2").setValue("");
		Ext.getCmp("IncId").setValue("");
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp('finishflag').setValue(false);
		Ext.getCmp('StartDate').setValue(DefaultStDate());
		Ext.getCmp('EndDate').setValue(DefaultEdDate());
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		
	}

	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var venDesc=Ext.getCmp("apcVendorField").getValue();
		if (venDesc==""){
			Ext.getCmp("apcVendorField").setValue("");
		}
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var PoNo = Ext.getCmp('inpoNoField2').getValue();
		var Status='';
		var Complete="";
		var Complete1 = Ext.getCmp('finishflag').getValue();
		Complete = (Complete1==true?'Y':(Complete1==false?'N':''));
		var inciDesc=Ext.getCmp("InciDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var InciId=Ext.getCmp("IncId").getRawValue();
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)^����id
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+Vendor+'^'+phaLoc+'^'+Complete+'^N^'+Status+'^'+InciId;
		//alert(ListParam);
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
		  
		/*
		   MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
		
		*/
	}
	// ��ʾ������ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
		
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='δ���';			
		}else if(value==1){
			PoStatus='�������';
		}else if(value==2){
			PoStatus='ȫ�����';
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","CmpFlag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				listeners:{
					'load':function(ds){
						DetailGrid.store.removeAll();
						DetailGrid.getView().refresh();
						
						if (ds.getCount()>0)
						{
							MasterGrid.getSelectionModel().selectFirstRow();
							MasterGrid.getView().focusRow(0);
						}
					}
				
					
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
		header : "RowId",
		dataIndex : 'PoId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "������",
		dataIndex : 'PoNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'PoLoc',
		width : 120,
		align : 'left',
		sortable : true,
		hidden:true
	}, {
		header : "��Ӧ��",
		dataIndex : 'Vendor',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "����״̬",
		dataIndex : 'PoStatus',
		width : 90,
		align : 'left',
		sortable : true,
		renderer:renderPoStatus
	}, {
		header : "��������",
		dataIndex : 'PoDate',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header : "���",
		dataIndex : 'CmpFlag',
		width : 60,
		align : 'center',
		sortable : true,
		renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}	
	}
	
	]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var MasterGrid = new Ext.grid.GridPanel({
		title : '',
		height : 360,
		autoScroll:true,
		//region:'west',
		layout:'fit',
		cm : MasterCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar]
		
	});

	// ���ӱ��񵥻����¼�
	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
		//var PoId = MasterStore.getAt(rowIndex).get("PoId");
		//var Size=DetailPagingToolbar.pageSize;
		//DetailStore.setBaseParam('Parref',PoId);
		//DetailStore.load({params:{start:0,limit:Size}});
	});
	
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
		var PoId = rec.get("PoId");
		var Size=DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('Parref',PoId);
		DetailStore.load({params:{start:0,limit:Size}}); 
	});		
		
	MasterGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		if (PoId!='')	{
			fn(PoId);
			if (win) win.close();
		}
	});
	
		
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// ָ���в���
	//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "PoItmId",
		fields : fields
	});
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "������ϸid",
		dataIndex : 'PoItmId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "RowId",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '����',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '����',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'PurUom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'PurQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'ImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "δ��������",
		dataIndex : 'NotImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}]);

	var DetailGrid = new Ext.grid.GridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '',
		height : 360,
		region:'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:[DetailPagingToolbar]
	});
	
	var HisListTab = new Ext.form.FormPanel({
			region:'north',
			labelWidth : 60,
			height:DHCSTFormStyle.FrmHeight(1),
			labelAlign : 'right',
			frame : true,
			tbar : [SearchBT, '-',  ClearBT,'-',cancelBt,'-',PrintBT],
			layout:'fit',
			items : [{
				xtype : 'fieldset',
				title : '��ѯ��Ϣ',
				layout : 'column',
				style:DHCSTFormStyle.FrmPaddingV,				
				items : [{
					columnWidth : .3,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					defaults: {width: 140, border:false},   
					border: false,
					items : [PhaLoc,apcVendorField]
				}, {
					columnWidth : .25,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					autoHeight: true,
					border: false,
					items : [StartDate,EndDate]
				}, {
					columnWidth : .3,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					autoHeight: true,
					border: false,
					items : [inpoNoField,InciDesc]
				},{
					columnWidth : .15,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					autoHeight: true,
					border: false,
					items : [finishflag]
				}]
				
			}]		
						
		});
				
	
	/*
	var poPanel = new Ext.Panel({
		title:'����',
		activeTab:0,
		height:410,
		//autoScroll:true,
		collapsible:true,
        split:true,
		layout:'fit',
		width:550,
        minSize:0,
        maxSize:550,
		items:[MasterGrid]                                 
	});
				
	var poItemPanel = new Ext.Panel({
		title:'������ϸ',
		activeTab:0,
		height:410,
		deferredRender:true,
		region:'center',
		width:1125,
		items:[DetailGrid]                                 
	});
	*/
	// ҳ�沼��
	var mainPanel = new Ext.form.FormPanel({
		activeTab:0,
		height:410,
		width:1200,
		region:'center',
		layout:'border',
		items : [{
			region:'west',		
			title:'����',
			activeTab:0,
			height:410,
			autoScroll:true,
			collapsible:true,
	        split:true,
			layout:'fit',
			width:550,
	        minSize:0,
	        maxSize:550,
			items:[MasterGrid]     			
		},{
			region:'center',
			layout:'fit',
			title:'������ϸ',
			activeTab:0,
			height:410,
			deferredRender:true,
			region:'center',
			width:1125,
			items:[DetailGrid]    				
		}]
		//renderTo : 'mainPanel'
	});
	
		// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [HisListTab  ,mainPanel]          // create instance immediately
       			,
				renderTo : 'mainPanel'
			});
	
	
	
});