// /����: �ɹ��ƻ�����
// /����: �ɹ��ƻ�����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.30

//�������ֵ��object
var InPurPlanParamObj = GetAppPropValue('DHCSTPURPLANAUDITM');
var timer=null;
Ext.Ajax.timeout=12000;
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// �ɹ�����
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '�ɹ�����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor :'90%',
				emptyText : '�ɹ�����...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});

	var PurNo = new Ext.form.TextField({
				fieldLabel : '�ɹ�����',
				id : 'PurNo',
				name : 'PurNo'
			});
			
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'defLocPP',
			fieldLabel:'����֧�����',
			allowBlank:true
	});
	var Auditted=new Ext.form.Checkbox({
			id: 'Auditted',
			fieldLabel:'�����������',
			allowBlank:true,
			handler: function() {
				changeButEnable();
			}
	});
	function changeButEnable() {
		var AuditFlag = Ext.getCmp("Auditted").getValue(); 
		if (AuditFlag == true) {
			CheckBT.setDisabled(true);
			DeniedBT.setDisabled(true);
		} else {
			CheckBT.setDisabled(false);
			DeniedBT.setDisabled(false);
		}
	}
	// ��Ӧ��
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '��Ӧ��',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			emptyText : '��Ӧ��...',
			params : {LocId : 'PhaLoc'}
	});
		
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				
				width : 120,
				value : DefaultEdDate()
			});

	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		changeButEnable();
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var purno = Ext.getCmp("PurNo").getValue();
		var CmpFlag = "Y";
		
		var includeDefLoc=(Ext.getCmp('defLocPP').getValue()==true?1:0);  //�Ƿ����֧�����
		var Auditted=Ext.getCmp('Auditted').getValue();  //�����������(�Լ��������)
		///��˼������(0:���������[��һ����],����ѯδ���, 1:ȱʡ(�������δ������), 2:����ѯ��ȫ���), 3:������,4������ȫ�鼶������� 5���ñ��������
		var AuditLevel='';
		if(Auditted){
			AuditLevel=4
		}else{
			AuditLevel=5		
		}
		
		//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӧ��id^����id^��ɱ�־^��˱�־
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+purno+'^^'+vendor+'^^'+CmpFlag+'^'+''+"^"+includeDefLoc+"^"+AuditLevel+'^^^^^'+groupId;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('strParam',ListParam);
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options,success){
				if(!success){
					Msg.info("error","��ѯ����,��鿴��־!");
				}else if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		});
	}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("PurNo").setValue("");
		Ext.getCmp("defLocPP").setValue(false);
		Ext.getCmp("Auditted").setValue(false);
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '�����ӡ�ɹ���',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ����Ҫ��ӡ�Ĳɹ��ƻ���!");
				return;
			}
			var purId = rowData.get("RowId");
			PrintInPur(purId);
		}
	});
	// ������ť
	var CheckBT = new Ext.Toolbar.Button({
				id : "CheckBT",
				text : '���ͨ��',
				tooltip : '������ͨ��',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Audit();
				}
			});
	// �ܾ���ť
	var DeniedBT = new Ext.Toolbar.Button({
				id : "DeniedBT",
				text : '������ͨ��',
				tooltip : '���������ͨ��',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					Deny();								
				}
			});
	/**
	 * �����ɹ��ƻ���
	 */
	function Audit() {
		var PuridStr="";
		var rowData = MasterGrid.getSelectionModel().getSelections();
		if (Ext.isEmpty(rowData)) {
			Msg.info("warning", "��ѡ��Ҫ�����Ĳɹ���!");
			return false;
		}
		for (var i=0;i<rowData.length;i++)
		{
			var record=rowData[i];
			var PurId = record.get("RowId");
			if (PuridStr=="")
			{
				PuridStr= PurId;
			}else{
				PuridStr= PuridStr+"^"+PurId;
			} 
		}
		if (Ext.isEmpty(PuridStr)) {
			Msg.info("warning", "��ѡ��Ҫ�����Ĳɹ���!");
			return false;
		}
		//��ȡ�޸���ϸ20191022
		var rowCount = DetailGrid.getStore().getCount();
		var ListDetail="";
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);	
			if(rowData.dirty){
				var RowId = rowData.get("RowId");
				var Qty = rowData.get("Qty");
				var str =RowId+"^"+Qty
				if(ListDetail==""){
					ListDetail=str
					}
				else {
					ListDetail=ListDetail+xRowDelim()+str;
					}	
			}	
		}
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=AuditStr&rowid="
				+ PuridStr + "&userId=" + userId +"&groupId=" + groupId
				+"&ListDetail=" +ListDetail;
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						loadMask.hide();
						if (jsonData.success == 'true') {
							// ��˵���
							
							var infoarr=jsonData.info.split("^");
							var allcount=infoarr[0];
							var succount=infoarr[1];
							Msg.info("success", "��"+allcount+"����¼,�ɹ����"+succount+"����¼��");
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-10){
								Msg.info("warning","�ɹ������д��ڹ�Ӧ��Ϊ�յļ�¼���������ɶ���!");
							}
							else if(Ret==-2){
								Msg.info("error", "���¼ƻ���������־ʧ��!");
							}else if(Ret==-3){
								Msg.info("error", "���涩��������Ϣʧ��!");
							}else if(Ret==-4){
								Msg.info("error", "���涩����ϸʧ��!");
							}else if(Ret==-5){
								Msg.info("error", "�ƻ����Ѿ�����!");
							}else if(Ret==-101){
								Msg.info("error", "��û������Ȩ��!");
							}else if(Ret==-103){
								Msg.info("error", "���İ�ȫ���Ѿ��������!");
							}else if(Ret==-104){
								Msg.info("error", "��һ������δ���!");
							}else if(Ret==-102){
								Msg.info("error", "����������¼ʧ��!");
							}else{
								Msg.info("error", "����ʧ��:"+Ret);
							}
						}
					},
					scope : this
				});
	}
	/**
	 * �ܾ��ɹ��ƻ���
	 */
	function Deny() {
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ��������ͨ���Ĳɹ���!");
			return;
		}
		var PurId = rowData.get("RowId");
		var RefuseCase=rowData.get("RefuseCase");
		if(Ext.isEmpty(RefuseCase)){
			Msg.info('error', '����д�ܾ�ԭ��!');
			return false;
		}
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=Deny&rowid="
				+ PurId + "&userId=" + userId +"&groupId=" + groupId;
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
					url : url,
					params : {RefuseCase:RefuseCase},
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						loadMask.hide();
						if (jsonData.success == 'true') {
							Msg.info("success", "������ͨ���ɹ�!");
							Query();
						}else {
							var Ret=jsonData.info;
							if(Ret==-1){
								Msg.info("error","��������Ȩ��,���ܾܾ�!");
							}else if(Ret==-2){
								Msg.info("error", "������,���ܾܾ�!");
							}else if(Ret==-10){
								Msg.info("error", "��һ��δ����")
							}else {
								Msg.info("error", "���ʧ��:"+Ret);
							}
						}
					},
					scope : this
				});
	}
	function rendorPoFlag(value){
        return value=='Y'? '��': '��';
    }
    function rendorCmpFlag(value){
        return value=='Y'? '���': 'δ���';
    }
	

	// ����·��
	var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["RowId", "PurNo", "LocId", "Loc", "Date", "User","PoFlag", "CmpFlag","StkGrpId", "StkGrp", "DHCPlanStatus", "DHCPlanStatusDesc","RefuseCase"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "RowId",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	function querysum(){
		tabpanel.fireEvent('tabchange',tabpanel,tabpanel.getActiveTab());
	
	}
	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		listeners:{
			selectionchange:function (dsm){
				clearTimeout(timer)
				timer=querysum.defer(100,this)
			}
		}
	});
	var MasterCm = new Ext.grid.ColumnModel([nm,sm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "�ɹ��ƻ�����",
				dataIndex : 'PurNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�ɹ�����",
				dataIndex : 'Loc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ�����",
				dataIndex : 'Date',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'User',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƿ������ɶ���",
				dataIndex : 'PoFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorPoFlag
			}, {
				header : "��ɱ�־",
				dataIndex : 'CmpFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorCmpFlag
			}, {
				header : "����",
				dataIndex : 'StkGrp',
				width : 100,
				align : 'left',
				sortable : true
			},{
	            header:"���״̬",
                dataIndex:'DHCPlanStatusDesc',
                width:250,
                align:'left',
                sortable:true
			},{
	            header:"�ܾ�ԭ��",
                dataIndex:'RefuseCase',
                width:250,
                align:'left',
                sortable:true,
                editor:new Ext.form.TextField()
			}
	]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.grid.EditorGridPanel({
				region : 'center',
				title: '�ɹ���',
				cm : MasterCm,
				sm : sm,
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// ��ӱ�񵥻����¼�
	/*MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PurId = MasterStore.getAt(rowIndex).get("RowId");
		DetailStore.removeAll();
		DetailStore.setBaseParam('sort','Rowid');
		DetailStore.setBaseParam('dir','Desc');
		DetailStore.setBaseParam('parref',PurId);
		DetailStore.load({params:{start:0,limit:20,sort:'Rowid',dir:'Desc',parref:PurId}});
	});*/

	// ת����ϸ
	// ����·��
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=queryItem';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["RowId", "IncId","IncCode","IncDesc", "Spec","SpecDesc", "Manf", "Qty","UomId",
			 "Uom", "Rp", "Sp","RpAmt","SpAmt","Vendor", "Carrier", "Gene", "GoodName",
			"Form", "ReqLoc", "StkQty", "MaxQty","MinQty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "RowId",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����Id",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'IncDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 180,
				align : 'left',
				sortable : true
			} ,{
				header : "������",
				dataIndex : 'SpecDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "�ɹ�����",
				dataIndex : 'Qty',
				width : 80,
				align : 'right',
				sortable : true,
				editor:new Ext.form.NumberField({selectOnFocus:true})
			}, {
				header : "��λ",
				dataIndex : 'Uom',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'Carrier',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'ReqLoc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'StkQty',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MaxQty',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MinQty',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	var DetailGridPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:20,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var DetailGrid = new Ext.grid.EditorGridPanel({
				minSize: 200,
				maxSize: 350,
				collapsible: true,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				//bbar:DetailGridPagingToolbar,
				sm : new Ext.grid.CellSelectionModel({}),
	            clicksToEdit:1
			});
	DetailGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
		e.preventDefault();
		menu.showAt(e.getXY());		
	});
	var menu=new Ext.menu.Menu({
		id:'rightMenu',
		height:30,
		items:[{
			id:'ChangeDetail',
			text:'�޸ļ�¼',
			handler:GetChangeDetail
		}]
	});
   function GetChangeDetail(){
	   var cell = DetailGrid.getSelectionModel().getSelectedCell();
	   if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var RowId = record.get("RowId");
	   ChangeDetailQuery(RowId)
	   }
	var HisListTab = new Ext.form.FormPanel({
		region : 'north',
		autoHeight : true,
		title:'�ɹ��ƻ�����',
		labelWidth: 100,	
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT, '-',DeniedBT, '-',PrintBT],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {border:false},    // Default config options for child items
			style : 'padding:5px 0px 0px 5px',
			items:[{ 				
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [PhaLoc,Vendor]
			},{
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [StartDate,EndDate]
			},{
				columnWidth: 0.33,
	        	xtype: 'fieldset',
	        	items: [PurNo,includeDefLoc]
			},{
				columnWidth: 0.13,
	        	xtype: 'fieldset',
	        	items: [Auditted]
			}]
		}]
		
	});
	var PurPlanitmPanel=new Ext.Panel({
			title:"�ɹ��ƻ���ϸ",
			id:"PurPlanitmPanel",
			layout:"fit",
			items:DetailGrid
	});
	var PurPlanitmStatPanel=new Ext.Panel({
			title:"�ɹ��ƻ�����",
			id:"PurPlanitmStatPanel",
			layout:"fit",
			html:'<iframe id="framePurPlanitmStat" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var tabpanel=new Ext.TabPanel({
			region:"south",
			activeTab:0,
			height: gGridHeight,
			items:[PurPlanitmPanel,PurPlanitmStatPanel],
			listeners:{
					tabchange:function(tabpanel,panel){
							var PuridStr="";
							var rowData = MasterGrid.getSelectionModel().getSelections();
							for (var i=0;i<rowData.length;i++)
							{
								var record=rowData[i];
								var PurId = record.get("RowId");
								if (PuridStr=="")
								{
									PuridStr= PurId;
								}else{
									PuridStr= PuridStr+","+PurId;
								} 
							}
							if (panel.id=="PurPlanitmPanel"){
								DetailStore.removeAll();
								DetailStore.setBaseParam('sort','Rowid');
								DetailStore.setBaseParam('dir','Desc');
								//DetailStore.setBaseParam('parref',PuridStr);
								DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PuridStr}});
	
							}else if (panel.id=="PurPlanitmStatPanel"){
								var p_Url=PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_Stat.raq'+
								'&Parref='+PuridStr;
								var ReportFrame=document.getElementById("framePurPlanitmStat");
								ReportFrame.src=p_Url;
							}
						}	
				}
			
	});
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, tabpanel]
			});
			
	Query();
})