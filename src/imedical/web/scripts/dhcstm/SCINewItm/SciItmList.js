// /����: ������Ϣά��
// /����: ������Ϣά��
// /��д�ߣ�zhangdongmei
// /��д����: 2011.12.16
// /�޸ģ�2012-06-14����������
var drugRowid = "";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var SEL_REC;
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
		var DateFrom = new Ext.ux.DateField({
	           fieldLabel : '<font color=blue>��ʼ����</font>',
	           id : 'DateFrom',
	           anchor : '90%',
	           value : new Date().add(Date.DAY,-15)
         });

         var DateTo = new Ext.ux.DateField({
	           fieldLabel : '<font color=blue>��ֹ����</font>',
	           id : 'DateTo',
	           anchor : '90%',
	           value : new Date()
         });
		
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '<font color=blue>��������</font>',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						
					}
				}
			}
		});
	    // ȫ��
		var FindTypeData=[['ȫ��','1'],['�����ɿ����','2'],['δ���ɿ����','3']];
		
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});

		var FindTypeCombo = new Ext.form.ComboBox({
			store: FindTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'FindTypeCombo',
			fieldLabel : 'ͳ�Ʒ�ʽ',
			triggerAction:'all', //ȡ���Զ�����
			valueField : 'typeid'
		});
		Ext.getCmp("FindTypeCombo").setValue("3");
		
		
		var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor:'90%'
		});
		// ����·��
		var HospIncListUrl ='dhcstm.newitmaction.csp?actiontype=GetNewItm';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url:HospIncListUrl,
			method : "POST"
		});
		
		// ָ���в���
		var fields = ["Inci", "NIDesc", "NISpec", "NIManfDesc","NIPUomDesc", "NIRpPUom", "NISpPUom","SciId"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "InciRowid",
			fields : fields
		});
	
		// ���ݼ�
		var SciDrugInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			remoteSort: true
		});
	
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				search();
			}
		});

		function search(){
			//DrugInfoGrid.getStore().removeAll();
			//DrugInfoGrid.getView().refresh();
			//clearData();
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var Vendor= Ext.getCmp("Vendor").getValue();
			var allFlag=Ext.getCmp("FindTypeCombo").getValue();
			var others = inciDesc+"^"+Vendor+"^"+allFlag;
			var startDate = Ext.getCmp("DateFrom").getValue();
			var endDate = Ext.getCmp("DateTo").getValue();
			if(startDate==""||endDate==""){
				Msg.info("warning","��ѡ��ʼ���ڻ��ֹ���ڣ�");
				return;
			}
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var strParm=startDate+"^"+endDate+"^^"+allFlag;
			var strParm=startDate+"^"+endDate+"^^"+allFlag;
			
			SciDrugInfoStore.setBaseParam('Param',strParm);
			var pageSize=SciDrugInfoToolbar.pageSize;
			SciDrugInfoStore.load({params:{start:0, limit:pageSize},
				callback : function(r,options, success) {
					if(success==false){
						Msg.info("error", "��ѯ������鿴��־!");
					}else{
						if(r.length>=1){
							SciDrugInfoGrid.getSelectionModel().selectFirstRow();
							SciDrugInfoGrid.getView().focusRow(0);
						}
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
				M_InciDesc.setValue("");
				Ext.getCmp("FindTypeCombo").setValue("3");
				
				//clearData();
			}
		});
		
		var nm = new Ext.grid.RowNumberer();
		var SciDrugInfoCm = new Ext.grid.ColumnModel([nm, 
			{
				header : "�����id",
				dataIndex : 'Inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, { 
				header : 'ƽ̨��������',
				dataIndex : 'NIDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'NISpec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'NIManfDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'NIPUomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "����(��ⵥλ)",
				dataIndex : 'NIRpPUom',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'NISpPUom',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "SciId",
				dataIndex : 'SciId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}
		]);
		SciDrugInfoCm.defaultSortable = true;
		
		var SciDrugInfoToolbar = new Ext.PagingToolbar({
			store:SciDrugInfoStore,
			pageSize:PageSize,
			id:'SciDrugInfoToolbar',
			displayInfo:true
		});
		
		var SciDrugInfoGrid = new Ext.ux.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			autoScroll:true,
			cm:SciDrugInfoCm,
			store:SciDrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask : true,
			bbar:SciDrugInfoToolbar,
			viewConfig:{
				getRowClass : function(record,rowIndex,rowParams,store){ 
					//var ArcId=parseInt(record.get("ArcId"));
					//if(!isNaN(ArcId)&& ArcId>0){
					//	return 'classGreen';
					//}
								
				}
			},
			listeners:
			{
				rowcontextmenu : function(grid,rowindex,e){
					e.preventDefault();
					SEL_REC=grid.getStore().getAt(rowindex);
					rightClick.showAt(e.getXY());
				}
			}
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			labelWidth: 60,
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����',
				layout: 'column',
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items : [{
					columnWidth: 0.5,
					items: [DateFrom,DateTo]
				},{
					columnWidth: 0.5,
					items: [M_InciDesc,Vendor]
				}]
			}]
		});
		//==== ��ӱ��ѡȡ���¼�=============
		SciDrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			
			var selectedRow = SciDrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['Inci'];
			var SciRowid= selectedRow.data['SciId'];
			drugRowid = InciRowid;
			//��ѯ��������Ϣ
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}
			GetDetail(drugRowid,SciRowid);
			
		});
		var viewport = new Ext.ux.Viewport({
			layout: 'border',
			items: [{
				region: 'center',
				title: '�����б�',
				split: true,
				width: 500,
				minSize: 470,
				maxSize: 600,
				margins: '0 5 0 0',
				layout: 'border', 
				items : [HisListTab,SciDrugInfoGrid]
			},talPanel]
		});

		//InitDetailForm();
		
});