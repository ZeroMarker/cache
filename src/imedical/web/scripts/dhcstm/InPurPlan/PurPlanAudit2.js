// /����: �ɹ��ƻ�����
// /����: �ɹ��ƻ�����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.30
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// �ɹ�����
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '�ɹ�����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '�ɹ�����...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});

	var PurNo = new Ext.form.TextField({
				fieldLabel : '�ɹ�����',
				id : 'PurNo',
				name : 'PurNo',
				anchor : '90%',
				width : 120
			});
	// ��������
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 		
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'defLocPP',
			fieldLabel:'����֧�����',
			anchor:'90%',
			width:150,
			checked:true,
			allowBlank:true
	});
	
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
				anchor : '90%',
				
				width : 120,
				value : new Date().add(Date.DAY, - 30)
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				width : 120,
				value : new Date()
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
	function filterRepeatStr(str){ 
var ar2 = str.split("^"); 
var array = new Array(); 
var j=0 
for(var i=0;i<ar2.length;i++){ 
if((array == "" || array.toString().match(new RegExp(ar2[i],"g")) == null)&&ar2[i]!=""){ 
array[j] =ar2[i]; 
array.sort(); 
j++; 
} 
} 
return array.toString(); 
}
	/**
	 * ��ѯ����
	 */
	function Query() {
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
		var StkGrp=Ext.getCmp("StkGrpType").getValue();
		//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӧ��id^����id^��ɱ�־^��˱�־
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+purno+'^'+StkGrp+'^'+vendor+'^^'+CmpFlag+'^N'+"^"+includeDefLoc;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('strParam',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options,success){
				if(!success){
					Msg.info("error","��ѯ����,��鿴��־!");
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
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
	}

	// ������ť
	var CheckBT = new Ext.ux.Button({
				id : "CheckBT",
				text : '����',
				tooltip : '�������',
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
				text : '�ܾ�һ��',
				tooltip : '����ܾ�',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					DenyDetail();								
				}
			});
	/**
	 * �����ɹ��ƻ���
	 */
	function Audit() {
		
		var rowDataarr = MasterGrid.getSelectionModel().getSelections();
		if (Ext.isEmpty(rowDataarr)) {
			Msg.info("warning", "��ѡ��Ҫ�����Ĳɹ���!");
			return;
		}
		var count=rowDataarr.length;
		var inppstr=""
		for (i=0;i<count;i++)
		{
			var rowData=rowDataarr[i];
			var inppid=rowData.get('Parref');
			if (inppstr=="")
			 {inppstr=inppid}
			 else
			 {inppstr=inppstr+"^"+inppid}
				
		}
		
		inppstr=filterRepeatStr(inppstr)  ///ȥ���ظ�
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=AuditStr";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {rowid:inppstr,userId:userId,groupId:groupId},
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", "�����ɹ�!");
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
	function DenyDetail() {
		var rowDataarr = MasterGrid.getSelectionModel().getSelections();
		if (rowDataarr ==null) {
			Msg.info("warning", "��ѡ��Ҫ�ܾ�����ϸ!");
			return;
		}
		var count=rowDataarr.length;
		if (count!=1){
			Msg.info("warning", "��ѡ��һ��Ҫ�ܾ�����ϸ!");
			return;}
		var inppistr=""
		for (i=0;i<count;i++)
		{
			var rowData=rowDataarr[i];
			var inppi=rowData.get('RowId');
			if (inppistr=="")
			 {inppistr=inppi}
			 else
			 {inppistr=inppistr+","+inppi}
				
		}

		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=DenyDetail";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					params: {RowIdStr:inppistr,userId:userId},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "�ܾ��ɹ�!");
							Query();
						}else {
							var Ret=jsonData.info;
							if(Ret==-1){
								Msg.info("error","��������Ȩ��,���ܾܾ�!");
							}else if(Ret==-2){
								Msg.info("error", "������,���ܾܾ�!");
							}else {
								Msg.info("error", "�ܾ�ʧ��:"+Ret);
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
	var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=querydetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["Parref","RowId", "PurNo", "LocId", "Loc", "Date", "User","PoFlag", "CmpFlag",
				"StkGrpId", "StkGrp", "DHCPlanStatus", "DHCPlanStatusDesc",
				 "IncId","IncCode","IncDesc", "Spec","SpecDesc", "Manf", "Qty","UomId",
			 	"Uom", "Rp", "Sp","RpAmt","SpAmt","Vendor", "Carrier", "Gene", "GoodName",
				"Form", "ReqLoc", "StkQty", "MaxQty","MinQty","Mobile","reqremark"];
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
	var nm = new Ext.grid.RowNumberer();
	var sm=new Ext.grid.CheckboxSelectionModel()
	var MasterCm = new Ext.grid.ColumnModel([nm,sm,{
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "�绰",
				dataIndex : 'Mobile',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : "�ɹ��ƻ�����",
				dataIndex : 'PurNo',
				width : 140,
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
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'User',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƿ������ɶ���",
				dataIndex : 'PoFlag',
				width : 40,
				align : 'center',
				sortable : true,
				renderer:rendorPoFlag
			}, {
				header : "��ɱ�־",
				dataIndex : 'CmpFlag',
				width : 40,
				align : 'center',
				sortable : true,
				renderer:rendorCmpFlag
			}, {
				header : "����",
				dataIndex : 'StkGrp',
				width : 80,
				align : 'left',
				sortable : true
			},{
	            header:"���״̬",
                dataIndex:'DHCPlanStatusDesc',
                width:80,
                align:'left',
                sortable:true
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
			},{
				header : "�����б�",
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
				sortable : true
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
			},{
				header:"����ע",
				dataIndex:'reqremark',
				width:120,
				align:'left'
		}
	]);
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:1000,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var MasterGrid = new Ext.ux.GridPanel({
				title : '',
				cm : MasterCm,
				sm :sm,
				store : MasterStore,
				bbar:GridPagingToolbar
			});

	
	
	

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 100,	
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT, '-',DeniedBT],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {width: 220, border:false},    // Default config options for child items
			style : 'padding:5px 0px 0px 5px',
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',        	
	        	items: [PhaLoc,Vendor]				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',	      
	        	items: [PurNo,StkGrpType]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	      
	        	items: [includeDefLoc]
			}]
		}]
		
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'�ɹ��ƻ�����',
		                height: 160, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '�ɹ�����ϸ',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid
		            }
       			],
				renderTo : 'mainPanel'
			});
})