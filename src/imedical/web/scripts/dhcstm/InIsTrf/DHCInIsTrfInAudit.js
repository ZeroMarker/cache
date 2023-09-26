// /����: ת��������
// /����: ת��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
		// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '������',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',					
				anchor: '90%',
				emptyText:'������',
				groupId:gGroupId
				//defaultLoc:''
			});

	// ��������
	/*var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '��������',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',	
				emptyText:'��������',
				anchor : '90%',
				//groupId:gGroupId
				defaultLoc:''
			});*/
	var SupplyPhaLoc = new Ext.ux.ComboBox({
		id:'SupplyPhaLoc',
		fieldLabel:'��������',
		anchor:'90%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'��������...',
		params:{LocId:'RequestPhaLoc'},
		filterName : 'FilterDesc'
	});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				
				width : 120,
				value : AuditStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				
				width : 120,
				value : new Date()
			});
    var HVBarCodeField = new Ext.form.TextField({
	              fieldLabel : '��ֵ����',
	              id : 'HVBarCodeField',
	              name : 'HVBarCodeField',
	              anchor : '90%',
	              listeners : {
	              specialkey : function(field, e) {
			             if (e.getKey() == Ext.EventObject.ENTER) {
				             CheckHVBarCodeBT.handler()
			             }
		             }
             	}
      });
     // ��ֵ��������
	var CheckHVBarCodeBT = new Ext.Toolbar.Button({
				id : "CheckHVBarCodeBT",
				text : '��ֵ��������',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					CheckHVBarCode();
				}
			}); 
	function CheckHVBarCode() {
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "��ѡ��Ҫ���յ�ת�Ƶ�!");
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning", "ת�Ƶ����Ǵ�����״̬�����ʵ!");
			return;
		}
		var Init = rowData.get("init");
		var HvBarcode=Ext.getCmp("HVBarCodeField").getValue()
		if (HvBarcode=="") {
			Msg.info("warning", "��ֵ���벻��Ϊ��!");
			return;
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CheckHVBarCode&Rowid="
				+ Init + "&User=" + userId+ "&HvBarcode=" + HvBarcode;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							//Msg.info("success", "��ֵ�������ճɹ�!");
							var Data = tkMakeServerCall("web.DHCSTM.DHCINIsTrf","GetDataByBarcode",HvBarcode);
							Msg.info("success", "��ֵ�������ճɹ�!������ϢΪ: "+Data);
							DetailStore.setBaseParam('Parref',Init)
		                    DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		                    
						} else {
							var Ret=jsonData.info;
							if(Ret==-1){
								Msg.info("error", "û�г��ⵥ!");
							}else if(Ret==-2){
								Msg.info("error", "û��������!");
							}else if(Ret==-5 || Ret==-6){
								Msg.info("error", "��ֵ����δ�ڴ˳��ⵥ��!");
							}else if(Ret==-4){
								Msg.info("error", "��ֵ����δ�Ǽ�!");
							}else if(Ret==-7){
								Msg.info("error", "��ֵ��������ʧ��!");
							}else{
								Msg.info("error", "��ֵ��������ʧ��:"+Ret);
							}
						}
					},
					scope : this
				});
	}		
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
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if (requestphaLoc == null || requestphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��������!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var statue = "21";
		var UserScgPar = requestphaLoc + '%' + userId;
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^Y'
			+'^'+statue+'^^^^'
			+'^^^^'+UserScgPar;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		DetailGrid.store.removeAll();
		MasterStore.removeAll();
		MasterStore.load({params:{start:0, limit:Page}});
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
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setValue("");
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ������ť
	var CheckBT = new Ext.Toolbar.Button({
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

	/**
	 * ����ת�Ƶ����
	 */
	function Audit() {
		// �ж�ת�Ƶ��Ƿ������
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "��ѡ��Ҫ���յ�ת�Ƶ�!");
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning", "ת�Ƶ����Ǵ�����״̬�����ʵ!");
			return;
		}
		var Init = rowData.get("init");
		
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ Init + "&User=" + userId;
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", "���ճɹ�!");
							Query();
							//���ݲ��������Զ���ӡ
							if(gParam[5]=='Y'){
								PrintInIsTrf(Init);
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", "���ⵥ���Ǵ�����״̬!");
							}else if(Ret==-99){
								Msg.info("error", "����ʧ��!");
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", "���³��ⵥ״̬ʧ��!");
							}else if(Ret==-3){
								Msg.info("error", "�������ʧ��!");
							}else if(Ret==-4){
								Msg.info("error", "����̨��ʧ��!");
							}else{
								Msg.info("error", "����ʧ��:"+Ret);
							}
						}
						loadMask.hide();
					},
					scope : this
				});
	}

	// �����˾ܾ���ť
	var AuditNoBT = new Ext.Toolbar.Button({
				id : "AuditNoBT",
				text : '�ܾ�����',
				tooltip : '����ܾ�����',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					AuditNo();
				}
			});
	/**
	 * ��ⵥ��˲�ͨ��
	*/
	function AuditNo() {
		// �ж�ת�Ƶ��Ƿ������
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "��ѡ����Ҫ�ܾ���ת�Ƶ�!");
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning", "ת�Ƶ����Ǵ�����״̬�����ʵ!");
			return;
		}
		var Init = rowData.get("init");
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditInNo&Rowid="
				+ Init + "&User=" + userId;
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", "�ɹ�!");
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", "���ⵥ���Ǵ�����״̬!");
							}else if(Ret==-101){
								Msg.info("error", "���ⵥ�Ѿ�����һ���µ����޲��ܾܾ�����!");
							}else if(Ret==-102){
								Msg.info("error", "��������Ѿ������±�,���ɾܾ�����!");
							}else if(Ret==-99){
								Msg.info("error", "����ʧ��!");
							}else if(Ret==-1){
								Msg.info("error", "���³��ⵥ״̬ʧ��!");
							}else if(Ret==-3){
								Msg.info("error", "�ָ���棬����̨��ʧ��!");
							}else if(Ret==-4){
								Msg.info("error", "�ָ�ռ������ʧ��!");
							}else if(Ret==-5){
								Msg.info("error", "���³�����ϸ״̬ʧ��!");
							}else{
								Msg.info("error", "ʧ��:"+Ret);
							}
						}
						loadMask.hide();
					},
					scope : this
				});
	}
	
	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
	"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "init",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				listeners : {
					load : function(store,records,options){
						if (records.length > 0){
							MasterGrid.getSelectionModel().selectFirstRow();
						}
					}
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ת�Ƶ���",
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '���󵥺�',
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'dd',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'StatusCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MarginAmt',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "��ע",
				dataIndex : 'Remark',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '���ⵥ',
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// ���ӱ��񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var InIt = MasterStore.getAt(rowIndex).get("init");
		DetailStore.setBaseParam('Parref',InIt)
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
	});

	// ת����ϸ
	// ����·��
	var DetailUrl =  DictUrl
				+ 'dhcinistrfaction.csp?actiontype=QueryDetail';;;
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["initi", "inrqi", "inci","inciCode",
			"inciDesc", "inclb", "batexp", "manf","manfName",
			 "qty", "uom", "sp","status","remark",
			"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
			"pp", "spec", "gene", "form","newSp","HVBarCode","checkflag",
			"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "initi",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "ת��ϸ��RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����Id",
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'inciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'inciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ֵ����',
				dataIndex : 'HVBarCode',
				width : 120,
				align : 'left'
			}, {
				header : "����״̬",
				dataIndex : 'checkflag',
				width : 60,
				align : 'center',
				sortable : true
			}, {
				header : "����Id",
				dataIndex : 'inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����/Ч��",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "���ο��",
				dataIndex : 'inclbQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ת�Ƶ�λ",
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'reqQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��λ��",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���󷽿��",
				dataIndex : 'reqLocStkQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "ռ������",
				dataIndex : 'inclbDirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'inclbAvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�����ۼ�",
				dataIndex : 'newSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, /*{
				header : "ͨ����",
				dataIndex : 'gene',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'form',
				width : 100,
				align : 'left',
				sortable : true
			},*/ {
				header : "�ۼ۽��",
				dataIndex : 'spAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'rpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}]);
   var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var DetailGrid = new Ext.grid.GridPanel({
				region: 'south',
				split: true,
				height: gGridHeight,
				collapsible: true,
				title: '���ⵥ��ϸ',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				bbar:GridDetailPagingToolbar,
				loadMask : true,
					viewConfig:{
					getRowClass : function(record,rowIndex,rowParams,store){ 
						var checkflag=record.get("checkflag");
						
							if(checkflag=="Y"){   //��������ܳ��� �ú�ɫ��ʾ
								return 'classGreen';
							}
							
					}
				}
			});
	
	var HisListTab = new Ext.ux.FormPanel({
		title : 'ת��������',
		labelWidth: 60,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT,'-',AuditNoBT,'-',CheckHVBarCodeBT],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			style:'padding:5px 0px 0px 5px',
			defaults: {xtype: 'fieldset', border:false},    // Default config options for child items
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.25,
            	items: [SupplyPhaLoc,HVBarCodeField]
			},{
				columnWidth: 0.25,
            	items: [RequestPhaLoc]
			},{ 				
				columnWidth: 0.25,
            	items: [StartDate]
			},{
				columnWidth: 0.25,
            	items: [EndDate]
			}]
		}]			
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, DetailGrid],
				renderTo : 'mainPanel'
			});
	
	Query();
})