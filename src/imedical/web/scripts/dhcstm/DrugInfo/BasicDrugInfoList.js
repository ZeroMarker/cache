// /����: ����������Ϣά��
// /����: ����������Ϣά��
// /��д�ߣ�wangguohua
// /��д����: 2013.05.07
var drugRowid = "";
var storeConRowId="";
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var SEL_REC;
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
		//==========================����====================//
		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
			 //	GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
			 GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
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
			var InciCode=record.get("InciCode");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("M_InciDesc").setValue(InciDesc);
			Ext.getCmp("M_InciCode").setValue(InciCode);
			
			search();
		}
		
		/***
		**����Ҽ��˵�����,20170222
		**/
		//����Ϊ����
		function setUse()
		{		
			if (SEL_REC)
			{
		        var NotUseFlag=SEL_REC.get("NotUseFlag");   //N����  Y������
				if(NotUseFlag=="N")
				{
					Msg.info('error','��ǰ������Ϊ"����"���ظ����ã�');
					return;
				}
				var inci=SEL_REC.get("InciRowid");
				SetNotUseFlag(inci,"N");
			}
			
		}
		//����Ϊ������
		function setNotUse()
		{	
			if (SEL_REC)
			{
		        var NotUseFlag=SEL_REC.get("NotUseFlag");   //N����  Y������
				if(NotUseFlag=="Y")
				{
					Msg.info('error','��ǰ������Ϊ"������"���ظ����ã�');
					return;
				}
				var inci=SEL_REC.get("InciRowid");
				SetNotUseFlag(inci,"Y");
			}
		}
		//���¡������á�״̬
		function SetNotUseFlag(inci,NotUseFlag)
		{
			var clsName="web.DHCSTM.INCITM";
		    var methodName="UpdNotUseFlag";
		    var ret=tkMakeServerCall(clsName,methodName,inci,NotUseFlag) ;
			if(ret<0){
				Msg.info('error','����ʧ�ܣ�');
				return ret;
			}
			else{
				Msg.info("success", "���óɹ�!");
				DrugInfoStore.reload();
			}
		}

		//==========����==========================
		
		//==========�ؼ�==========================
		// ���ʱ���
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '<font color=blue>���ʱ���</font>',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});
		
		// ��������
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '<font color=blue>��������</font>',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
		
		// ���ʱ���
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : '<font color=blue>���ʱ���</font>',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});

		// ��������
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			fieldLabel:'<font color=blue>����</font>',
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			UserId:gUserId,
			LocId:gLocId,
			DrugInfo:"Y",
			anchor : '90%',
			//scgset:"'MO'",
			listWidth : 200,
			listeners:{
				'select':function(){
					Ext.getCmp("M_StkCat").setValue('');
				}
			}
		});
		
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '<font color=blue>������</font>',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			filterName:'StkCatName',
			params:{StkGrpId:'M_StkGrpType'}
		});
		// ȫ��
		/*
		var M_AllFlag = new Ext.form.Checkbox({
			fieldLabel : 'ȫ��',
			id : 'M_AllFlag',
			name : 'M_AllFlag',
			anchor : '90%',
			checked : false
		});
		*/
		var FindTypeData=[['ȫ��','1'],['����','2'],['������','3']];
	
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
		Ext.getCmp("FindTypeCombo").setValue("1");
		
		// ����ʱ��
		var CreateDayData=[['','ȫ��'],['1','���1��'],['2','���2��'],['3','���3��'],['4','���4��'],['5','���5��'],['10','���10��'],['20','���20��'],['30','���30��']];
		var CreateDayStore = new Ext.data.SimpleStore({
			fields: ['dayid','daydesc'],
			data : CreateDayData
		});
		var CreateDay = new Ext.form.ComboBox({
			store: CreateDayStore,
			displayField:'daydesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'CreateDay',
			fieldLabel : '��������',
			triggerAction:'all', 
			valueField : 'dayid'
		});
		Ext.getCmp("CreateDay").setValue("");
		
		//����ʱ��
		var UpdateDayData=[['','ȫ��'],['1','���1��'],['2','���2��'],['3','���3��'],['4','���4��'],['5','���5��'],['10','���10��'],['20','���20��'],['30','���30��']];
		var UpdateDayStore = new Ext.data.SimpleStore({
			fields: ['dayid','daydesc'],
			data : UpdateDayData
		});
		var UpdateDay = new Ext.form.ComboBox({
			store: UpdateDayStore,
			displayField:'daydesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'UpdateDay',
			fieldLabel : '��������',
			triggerAction:'all', 
			valueField : 'dayid'
		});
		Ext.getCmp("UpdateDay").setValue("");
		
		//==========�ؼ�==========================
	
		// ����·��
		var DspPhaUrl ='dhcstm.druginfomaintainaction.csp?actiontype=GetItm';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url:DspPhaUrl,
			method : "POST"
		});
		// ָ���в���
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "Form", "GoodName","GenericName", "StkCat", "PhcCat", "PhcSubCat", "PhcMinCat","NotUseFlag","model","brand","incicreateDate","inciupdateDate"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "InciRowid",
			fields : fields
		});
	
		// ���ݼ�
		var DrugInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			remoteSort: false
		});

		// �������ʽ
		DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
	
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
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
			clearData();
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var inciCode = Ext.getCmp("M_InciCode").getValue();
			var alias = Ext.getCmp("M_GeneName").getValue();
			var stkCatId = Ext.getCmp("M_StkCat").getValue();
			var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
			if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
				Msg.info("error", "��ѡ���ѯ����!");
				return false;
			}
			//var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
			var allFlag=Ext.getCmp("FindTypeCombo").getValue();
			var Createday= Ext.getCmp("CreateDay").getValue();
			var Updateday= Ext.getCmp("UpdateDay").getValue();
			//ҩѧ����id^ҩѧ����id^ҩѧ��С����id^����id^^^^^^^����ʱ��^����ʱ��
			var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^^^^^^^"+Createday+"^"+Updateday;
			// ��ҳ��������
			DrugInfoStore.setBaseParam('InciDesc',inciDesc);
			DrugInfoStore.setBaseParam('InciCode',inciCode);
			DrugInfoStore.setBaseParam('Alias',alias);
			DrugInfoStore.setBaseParam('StkCatId',stkCatId);
			DrugInfoStore.setBaseParam('AllFlag',allFlag);
			DrugInfoStore.setBaseParam('Others',others);
			var pageSize=DrugInfoToolbar.pageSize;
			DrugInfoStore.load({params:{start:0, limit:pageSize},
				callback : function(r,options, success) {					//Store�쳣��������
					if(success==false){
						Msg.info("error", "��ѯ������鿴��־!");
					}else{
						//ֻ��һ����¼�Ļ�ѡ�д˼�¼
						if(r.length>0){
							DrugInfoGrid.getSelectionModel().selectFirstRow();
							DrugInfoGrid.getView().focusRow(0);
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
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkCat.setValue("");
		
				M_StkGrpType.getStore().load();
				M_StkCat.setRawValue("");
			
				M_GeneName.setValue("");
				//M_AllFlag.setValue(false);
				Ext.getCmp("FindTypeCombo").setValue("1");
				
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				drugRowid="";
				CreateDay.setValue("");
				UpdateDay.setValue("");
				clearData();
			}
		});
		///����������Ϣ��ƽ̨
		var SendToSCMFlagData=[['ȫ��','1'],['����','2'],['δ����','3']];
		var SendToSCMFlagStore = new Ext.data.SimpleStore({
			fields: ['STSCMdesc', 'STSCMid'],
			data : SendToSCMFlagData
		});
		var SendToSCMFlagCombo = new Ext.form.ComboBox({
			store: SendToSCMFlagStore,
			displayField:'STSCMdesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'SendToSCMFlagCombo',
			fieldLabel : '�Ƿ���',
			triggerAction:'all', //ȡ���Զ�����
			valueField : 'STSCMid'
		});
		Ext.getCmp("SendToSCMFlagCombo").setValue("1");
		var SendInciBT = new Ext.Toolbar.Button({
					id : "SendInciBT",
					text : '����������Ϣ��ƽ̨',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						    var rowData=DrugInfoGrid.getSelectionModel().getSelected();
							if (rowData ==null) {
								Msg.info("warning", "��ѡ����Ҫ���͵�������Ϣ!");
								return;
							}
							var InciRowid = rowData.get("InciRowid");
							SendInci(InciRowid);
					}
		});
		function SendInci(InciRowid){
			 var url = "dhcstm.druginfomaintainaction.csp?actiontype=SendInci";
		        var loadMask=ShowLoadMask(Ext.getBody(),"������Ϣ��...");
		        Ext.Ajax.request({
		                    url : url,
		                    method : 'POST',
		                    params:{InciRowid:InciRowid},
		                    waitMsg : '������...',
		                    success : function(result, request) {
		                        var jsonData = Ext.util.JSON.decode(result.responseText);
		                        if (jsonData.success == 'true') {
		                            var IngrRowid = jsonData.info;
		                            Msg.info("success", "���ͳɹ�!");
		                            search();
		                        } else {
		                            var ret=jsonData.info;
		                            Msg.info("error", jsonData.info);
		                            search();
		                        }
		                    },
		                    scope : this
		                });
		        loadMask.hide();
		}
		
		var nm = new Ext.grid.RowNumberer();
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
			{
				header : "�����id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "�ͺ�",
				dataIndex : 'model',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "Ʒ��",
				dataIndex : 'brand',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʒ��",
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "ͨ����",
				dataIndex : 'GenericName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'incicreateDate',
				width : 80,
				align : 'left'
			},  {
				header : '��������',
				dataIndex : 'inciupdateDate',
				width : 80,
				align : 'left'
			},  {
				header : "������",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				renderer : function(v) {
					if (v == "Y")
						return "<div class='ux-lovcombo-icon-checked ux-lovcombo-icon' style='background-position:0 -13px;'>&nbsp;</div>";
					else
						return "<div class='ux-lovcombo-icon-unchecked ux-lovcombo-icon'>&nbsp;</div>"
				},
				sortable : true
			}
		]);
		DrugInfoCm.defaultSortable = true;
		
		var DrugInfoToolbar = new Ext.PagingToolbar({
			store:DrugInfoStore,
			pageSize:PageSize,
			id:'DrugInfoToolbar',
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		
		var DrugInfoGrid = new Ext.grid.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask : true,
			tbar:{items:[{text:'������',iconCls:'page_gear',handler:function(){	GridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAINM");}}]},
			bbar:DrugInfoToolbar,
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
			tbar : [SearchBT, '-', ClearBT, '-', SendInciBT],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����--<font color=red>���顢�����ࡢ���ʱ��롢�������ơ����ʱ�������ȫ��Ϊ��</font>',
				layout: 'column',				
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items : [{
					columnWidth: 0.5,
					items: [M_InciCode,M_InciDesc,M_GeneName,CreateDay]
				}, {
					columnWidth: 0.5,
					items : [M_StkGrpType,M_StkCat,FindTypeCombo,UpdateDay]
				}]
			}]
		});
		
		//==== ��ӱ��ѡȡ���¼�=============
		DrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			drugRowid = InciRowid;
			//��ѯ��������Ϣ
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}
			
			GetDetail(drugRowid);
		});
		
		//�Ҽ��˵�
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [			
				{
					id: 'Rbtn_UseFlag', 
					handler: setUse, 
					text: '����' 
				},
				{
					id: 'Rbtn_NotUseFlag', 
					handler: setNotUse, 
					text: '������' 
				}
			] 
		});

		RefreshGridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAINM");   //�����Զ�������������������
		
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [{
				region: 'center',
				title: '�����б�',
				split: true,
				width: 500, // give east and west regions a width
				minSize: 470,
				maxSize: 600,
				margins: '0 5 0 0',
				layout: 'border', 
				items : [HisListTab,DrugInfoGrid]
			},
			talPanel]
		});
		
		InitDetailForm();
		
		var btnids="Rbtn_UseFlag^Rbtn_NotUseFlag";
		Authorization(btnids);
})