// /����: ̨�ʲ�ѯ
// /����: ̨�ʲ�ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.09
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth��Ҫ��һ��
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	ChartInfoAddFun();

	function ChartInfoAddFun() {

		//ͳ�ƿ���
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
			
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});

		// ��������
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '��������',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});	
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			childCombo : 'DHCStkCatGroup'
		});
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '������',
			id : 'DHCStkCatGroup',
			name : 'DHCStkCatGroup',
			anchor : '90%',
			width : 120,
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});

		var InciDr = new Ext.form.TextField({
			fieldLabel : '����RowId',
			id : 'InciDr',
			name : 'InciDr',
			anchor : '90%',
			width : 140,
			valueNotFoundText : ''
		});

		var ItmDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'ItmDesc',
			name : 'ItmDesc',
			anchor : '90%',
			width : 160,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var StkGrp= Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),StkGrp);
					}
				}
			}
		});
					
		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, group) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "", "", "",
						getDrugList);
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
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("ItmDesc").setValue(inciDesc);
			Ext.getCmp('InciDr').setValue(inciDr);
		}
		
		var INFOSpec = new Ext.form.TextField({
			fieldLabel :'���',
			id : 'INFOSpec',
			name : 'INFOSpec',
			anchor : '90%',
			width : 100,
			valueNotFoundText : ''
		});
		
		var GType = new Ext.form.Checkbox({
			boxLabel : '����',
			id:'GType',
			name : 'GType',
			anchor : '90%',
			checked : false,
			listeners:{
				'check':function(chk){
					if (chk.getValue()) {
						Ext.getCmp("LType").setValue(!chk.getValue()); 
					}
				}
			}
		})
		
		var LType = new Ext.form.Checkbox({
			boxLabel : 'С��',
			id:'LType',
			name : 'LType',
			anchor : '90%',
			checked : false,
			listeners:{
				'check':function(chk){
					if (chk.getValue()) {
						Ext.getCmp("GType").setValue(!chk.getValue()); 
					}
				}
			}
		})
		
		var INCIBRpPuruom = new Ext.ux.NumberField({
			formatType : 'FmtRP',
			fieldLabel:'����',
			id : 'INCIBRpPuruom',
			name : 'INCIBRpPuruom',
			allowNegative : false,
			selectOnFocus : true
		});
		
		//�ص��ע��־
		var ManageDrug = new Ext.form.Checkbox({
			boxLabel : '�ص��ע��־',
			id : 'ManageDrug',
			name : 'ManageDrug',
			anchor : '90%',
			checked : false
		});
					
		var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', 'ȫ��'], ['1', '������'], ['2', '��������']]
		});
		//ͳ�Ʊ�־
		var QueryFlag = new Ext.form.ComboBox({
			fieldLabel : 'ͳ�Ʊ�־',
			id : 'QueryFlag',
			name : 'QueryFlag',
			anchor : '90%',
			width : 100,
			store : TypeStore,
			valueField : 'RowId',
			displayField : 'Description',
			mode : 'local',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			listWidth : 150,
			forceSelection : true
		});
		Ext.getCmp("QueryFlag").setValue(0);

		var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', 'ȫ��'], ['1', '���Ϊ��'], ['2', '���Ϊ��'],
					['3', '���Ϊ��'], ['4', '������']]
		});
		var StockType = new Ext.form.ComboBox({
			fieldLabel : '�������',
			id : 'StockType',
			anchor:'90%',
			store : TypeStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : false,
			valueNotFoundText : ''
		});
		Ext.getCmp("StockType").setValue("0");
		
		
		// ��ѯ��ť
		var searchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ����̨��',
			iconCls : 'page_find',
			height:30,
			width:70,
			handler : function() {
				searchMainData();
			}
		});
		function priceRender(val){
			var val = Ext.util.Format.number(val,'0.00');
			if(val<0){
				return '<span style="color:red;">'+val+'</span>';
			}else if(val>0){
				return '<span style="color:green;">'+val+'</span>';
			}
			return val;
		}
		function searchMainData() {
			var StartDate=Ext.getCmp("StartDate").getValue();
		    var EndDate=Ext.getCmp("EndDate").getValue();
		    if(StartDate==""||EndDate==""){
			    Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			    return;
			    
		    }
			var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT)
					.toString();
			if(StartDate==null||StartDate.length <= 0) {
				Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
				return;
			}
			var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT)
					.toString();
			if(EndDate==null||EndDate.length <= 0) {
				Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
				return;
			}
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			if(PhaLoc==null||PhaLoc.length <= 0) {
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				return;
			}
			var StkGrp= Ext.getCmp("StkGrpType").getValue();
			var StkCat= Ext.getCmp("DHCStkCatGroup").getValue();
			var ItmDesc=Ext.getCmp("ItmDesc").getValue();
			if(ItmDesc == "" || ItmDesc == null){
				Ext.getCmp("InciDr").setValue("");
			}
			var ItmRowid=Ext.getCmp("InciDr").getValue();
			if(ItmRowid!=""&ItmRowid!=null){
				ItmDesc="";
			}
			var ManageFlag= Ext.getCmp("ManageDrug").getValue();
			if(ManageFlag==true){
				ManageFlag=1;
			}
			else{
				ManageFlag="";
			}
			var StateFlag= Ext.getCmp("QueryFlag").getValue();
			var INFOSpec= Ext.getCmp("INFOSpec").getValue();
			var StockType=Ext.getCmp("StockType").getValue();
			var Others=StkGrp+"^"+StkCat+"^"+ItmRowid+"^"+StockType+"^"+""
				+"^"+ManageFlag+"^"+StateFlag+"^"+INFOSpec+"^"+ItmDesc;
			MasterInfoStore.setBaseParam('startdate',StartDate);
			MasterInfoStore.setBaseParam('enddate',EndDate);
			MasterInfoStore.setBaseParam('phaloc',PhaLoc);
			MasterInfoStore.setBaseParam('others',Others);
			var size=StatuTabPagingToolbar.pageSize;
			MasterInfoStore.removeAll();
			DetailInfoGrid.store.removeAll();
			MasterInfoStore.load({
				params:{start:0,limit:size},
				callback : function(r,options, success){
					if(success==false){
						Msg.info("error", "��ѯ������鿴��־!");
					}else{
						if(r.length>0){
							MasterInfoGrid.getSelectionModel().selectFirstRow();
						}
					}
				}
			});
		}

		// ��հ�ť
		var clearBT = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			iconCls : 'page_clearscreen',
			height:30,
			width:70,
			handler : function() {
				clearData();
			}
		});

		function clearData() {
			
			Ext.getCmp("StartDate").setValue(new Date());
			Ext.getCmp("EndDate").setValue(new Date());
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("INFOSpec").setValue('');
			Ext.getCmp("INCIBRpPuruom").setValue('');
			Ext.getCmp("StockType").setValue('0');
			Ext.getCmp("GType").setValue('');
			Ext.getCmp("LType").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("QueryFlag").setValue('0');
			Ext.getCmp("ItmDesc").setValue('');
			Ext.getCmp("ManageDrug").setValue(false);
			MasterInfoGrid.store.removeAll();
			DetailInfoGrid.store.removeAll();
		}
					
		// ����·��
		var MasterInfoUrl = DictUrl
						+ 'locitmstkaction.csp?actiontype=LocItmStkMoveSum&start=0&limit=20';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url : MasterInfoUrl,
			method : "POST"
		});
		// ָ���в���
		// INCIL^��������^���������^������^��ⵥλ^������λ^�ڳ�����(������λ)
		// ^�ڳ�����(����λ)^�ڳ����(����)^�ڳ����(�ۼ�)^��ĩ����(������λ)^��ĩ����(����λ)
		// ^��ĩ���(����)^��ĩ���(�ۼ�)
		var fields = ["INCIL", "InciCode", "InciDesc","StkCat","PurUom","BUom","BegQty","BegQtyUom",
			"BegRpAmt","BegSpAmt","EndQty","EndQtyUom","EndRpAmt","EndSpAmt"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "INCIL",
			fields : fields
		});
		// ���ݼ�
		var MasterInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
		var nm = new Ext.grid.RowNumberer();
		var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCIL",
				dataIndex : 'INCIL',
				width : 20,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���ʴ���",
				dataIndex : 'InciCode',
				width : 160,
				align : 'left',
				renderer :Ext.util.Format.InciPicRenderer('INCIL'),
				useRenderExport : false,
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'InciDesc',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'StkCat',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '������λ',
				dataIndex : 'BUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�ڳ����',
				dataIndex : 'BegQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�ڳ����(����)',
				dataIndex : 'BegRpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
			}, {
				header : '�ڳ����(�ۼ�)',
				dataIndex : 'BegSpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
			}, {
				header : '��ĩ���',
				dataIndex : 'EndQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��ĩ���(����)',
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
			}, {
				header : '��ĩ���(�ۼ�)',
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
		}]);
		MasterInfoCm.defaultSortable = true;
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : MasterInfoStore,
			pageSize : PageSize,
			displayInfo : true
		});
		
		var sm = new Ext.grid.RowSelectionModel({
			singleSelect : true,
			listeners:{
				'rowselect': function(sm,rowIndex,r){
					var Incil = MasterInfoStore.getAt(rowIndex).get("INCIL");
					var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
					var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
					var INCIBRpPuruom=Ext.getCmp("INCIBRpPuruom").getValue();
					var GType=(Ext.getCmp("GType").getValue()==true?'G':'');	//����
					var LType=(Ext.getCmp("LType").getValue()==true?'L':'');	//С��
					var RpType=INCIBRpPuruom+"^"+GType+"^"+LType;
					var size=StatuTabPagingToolbar2.pageSize;
					DetailInfoStore.setBaseParam('incil',Incil);
					DetailInfoStore.setBaseParam('startdate',StartDate);
					DetailInfoStore.setBaseParam('enddate',EndDate);
					DetailInfoStore.setBaseParam('RpType',RpType);
					DetailInfoStore.removeAll();
					DetailInfoStore.load({
						params:{start:0,limit:size},
						callback:function(r,options,success){
							if(success==false){
								Msg.info("error","��ѯ����, ��鿴��־!");
							}
						}
					});
				}
			}
		});
		
		var MasterInfoGrid = new Ext.ux.GridPanel({
			region: 'west',
			collapsible: true,
			split: true,
			width: 300,
			margins: '0 5 0 0',
			id : 'MasterInfoGrid',
			title : '̨��',
			cm : MasterInfoCm,
			sm : sm,
			store : MasterInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar : StatuTabPagingToolbar
		});

		// ����·��
		var DetailInfoUrl = DictUrl
						+ 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url : DetailInfoUrl,
			method : "POST"
		});
		
		// ָ���в���
		//ҵ������^����^��λ^�ۼ�^����^��������(������λ)^��������(����λ)^��������(������λ)
		//^��������(����λ)^�������(����)^�������(�ۼ�)^�����^������^ժҪ
		//^��ĩ���(����)^��ĩ���(�ۼ�)^��Ӧ��^����^������	
		var fields = ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser","HVBarCode"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "TrId",
			fields : fields
		});
		// ���ݼ�
		var DetailInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
		var nm = new Ext.grid.RowNumberer();
		var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����",
				dataIndex : 'TrDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '����Ч��',
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'PurUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��ֵ����",
				dataIndex : 'HVBarCode',
				width : 140
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 80,
				align : 'right'
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'EndQtyUom',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'TrQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'TrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'TrAdm',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "ժҪ",
				dataIndex : 'TrMsg',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "������(����)",
				dataIndex : 'EndRpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "������(�ۼ�)",
				dataIndex : 'EndSpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',				
				sortable : true
			}, {
				header : "������",
				dataIndex : 'OperateUser',
				width : 100,
				align : 'left',				
				sortable : true
		}]);
		DetailInfoCm.defaultSortable = true;
		var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
			store : DetailInfoStore,
			pageSize : 20,
			displayInfo : true
		});
		var DetailInfoGrid = new Ext.ux.GridPanel({
			region: 'center',
			id : 'DetailInfoGrid',
			title : '̨����ϸ',
			cm : DetailInfoCm,
			sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
			store : DetailInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar : StatuTabPagingToolbar2
		});

		var HisListTab = new Ext.ux.FormPanel({
			title:'̨�ʲ�ѯ',
			tbar : [searchBT, '-', clearBT],
			layout : 'column',
			items:[{
					columnWidth:0.25,
					xtype: 'fieldset',
					title:'��ѡ����',
					style : 'padding:5px 0px 0px 5px',
					items : [PhaLoc,StartDate,EndDate]
				},{
					columnWidth:0.74,
					xtype: 'fieldset',
					title:'��ѡ����',
					style : 'padding:5px 0px 0px 5px',
					defaults : {border:false,xtype:'fieldset'},
					style:'margin-left:2px',
					layout : 'column',
					items : [{
						columnWidth:0.3,
						items : [StkGrpType,DHCStkCatGroup,QueryFlag]
					},{
						columnWidth:0.28,
						items : [ItmDesc,INFOSpec,ManageDrug]
					},{
						columnWidth:0.2,
						items : [INCIBRpPuruom,GType,LType]
					},{
						columnWidth:0.22,
						items : [StockType]
					}]
				}
			]
		});

		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterInfoGrid, DetailInfoGrid]
		});
	}
});