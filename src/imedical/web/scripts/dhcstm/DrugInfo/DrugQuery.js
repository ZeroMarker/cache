// /����: ������Ϣ��ѯ
// /����: ������Ϣ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.06.15

var drugRowid = "";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gParam="";
var defaRp="";
var SEL_REC;

Ext.onReady(function() {
		Ext.Ajax.timeout = 120000;	//��Ӧʱ���Ϊ2min
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		gParam=GetParams();
		var defaRp=GetParam(gParam,"ItmQueryDefaRp");
		
		//==========����==========================
		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
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
		}
		

		/*
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
		
		function editIncAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�༭�����ʣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				IncAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editArcAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�༭�����ʣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				OrdAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editDoseEquivInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�༭�����ʣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				DoseEquivEdit(DrugInfoStore, IncRowid);								
			}
		}
		*/

		//==========����==========================
		
		//==========�ؼ�==========================
		// ���ʱ���
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '���ʱ���',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});
		
		// ��������
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			width : 150,
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
			fieldLabel : '���ʱ���',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});
		// ���
		var Spec = new Ext.form.TextField({
			fieldLabel : '���',
			id : 'Spec',
			name : 'Spec',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});

		var Brand = new Ext.form.TextField({
			fieldLabel : 'Ʒ��',
			id : 'Brand',
			name : 'Brand',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});

		var Abbrev = new Ext.form.TextField({
			fieldLabel : '���',
			id : 'Abbrev',
			name : 'Abbrev',
			anchor : '90%',
			width : 150,
			valueNotFoundText : ''
		});

		var BRp = new Ext.ux.NumberField({
			formatType : 'FmtRP',
			fieldLabel : '����',
			id : 'BRp',
			anchor : '90%',
			allowNegative : false
		});
		
		var BSp = new Ext.ux.NumberField({
			formatType : 'FmtSP',
			fieldLabel : '�ۼ�',
			id : 'BSp',
			anchor : '90%',
			allowNegative : false
		});
		
		// ��������
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor:'90%',
			LocId:gLocId,
			UserId:userId,
			DrugInfo:"Y",
			listWidth : 200,
			listeners:{
				change:function(field,newValue,oldValue){
					M_StkCat.setValue("");
				}
			}
		}); 
			var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor:'90%'
		});
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '������',
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
			width : 150,
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
		
		// ��ֵ��־
		var M_HighPrice = new Ext.form.RadioGroup({
			id:'M_HighPrice',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'ȫ��',name:'M_HighPrice',id:'HighPrice_All',inputValue:'',checked:true},
				{boxLabel:'��ֵ',name:'M_HighPrice',id:'HighPrice_Yes',inputValue:'Y'},
				{boxLabel:'�Ǹ�ֵ',name:'M_HighPrice',id:'HighPrice_No',inputValue:'N'}
			]
		});
		// �շѱ�־
		var M_ChargeFlag = new Ext.form.RadioGroup({
			id:'M_ChargeFlag',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'ȫ��',name:'M_ChargeFlag',id:'ChargeFlag_All',inputValue:'',checked:true},
				{boxLabel:'�շ�',name:'M_ChargeFlag',id:'ChargeFlag_Yes',inputValue:'Y'},
				{boxLabel:'���շ�',name:'M_ChargeFlag',id:'ChargeFlag_No',inputValue:'N'}
			]
		});
		// ֲ���־
		var M_ImplantationMat = new Ext.form.RadioGroup({
			id:'M_ImplantationMat',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'ȫ��',name:'M_ImplantationMat',id:'ImplantationMat_All',inputValue:'',checked:true},
				{boxLabel:'ֲ��',name:'M_ImplantationMat',id:'ImplantationMat_Yes',inputValue:'Y'},
				{boxLabel:'��ֲ��',name:'M_ImplantationMat',id:'ImplantationMat_No',inputValue:'N'}
			]
		});
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '�����ʼ',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%'
	});
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '�����ֹ',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%'
		
	});
	var CreateUser = new Ext.ux.ComboBox({
			fieldLabel:'�½���',	
			id:'CreateUser',
			anchor : '90%',
			store:AllUserStore,
			valueField:'RowId',
			displayField:'Description',
			filterName:'Desc',
			params:{}
	});
	
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['����', '����'], ['����', '����'], ['����', '����']]
	});
	var ImportFlag = new Ext.form.ComboBox({
		fieldLabel : '���ڱ�־',
		id : 'ImportFlag',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor : '90%',
		mode : 'local',
		triggerAction : 'all'
	});
	
		//��������Դ
		var DspPhaUrl = 'dhcstm.druginfomaintainaction.csp';
		var proxy= new Ext.data.HttpProxy({url:DspPhaUrl+'?actiontype=GetItm',method:'POST'});

	
		// ָ���в���
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","brand","PurUom", "Sp", "Rp", "MaxSp", "BUom", "BillUom",
				"StkCat", "NotUseFlag","vendor","vendorName","registerNo","registerNoExpDate","productionlicense","businesscertificate","businesslicense","contactperson","authorizationdate","contacttel",
				"Marginnow","bRp","highpriceflag","chargeflag","implantationmat","model","PhcdCode","Supervision","Origin","regCertDateOfIssue","regItmDesc","regCertNoFull","CreateUser","print","INCIBarCode",
				"ImportFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id:'InciRowid',
			pageSize:30,
			fields : fields
		});
	
		// ���ݼ�
		var DrugInfoStore = new Ext.data.Store({
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
				var inciDesc = Ext.getCmp("M_InciDesc").getValue();
				var inciCode = Ext.getCmp("M_InciCode").getValue();
				var alias = Ext.getCmp("M_GeneName").getValue();
				var stkCatId = Ext.getCmp("M_StkCat").getValue();
				var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
				var Vendor= Ext.getCmp("Vendor").getValue();
				var spec=Ext.getCmp("Spec").getValue();
				var brand=Ext.getCmp("Brand").getValue();
				var abbrev=Ext.getCmp("Abbrev").getValue();
				var brp=Ext.getCmp("BRp").getValue();
				var bsp=Ext.getCmp("BSp").getValue();
				var allFlag=Ext.getCmp("FindTypeCombo").getValue();
				var highPrice = Ext.getCmp('M_HighPrice').getValue().getGroupValue();
				var charge = Ext.getCmp('M_ChargeFlag').getValue().getGroupValue();
				var implantation = Ext.getCmp('M_ImplantationMat').getValue().getGroupValue();
				var StartDate=Ext.getCmp("DateFrom").getValue()
				if(!Ext.isEmpty(StartDate)){StartDate=StartDate.format(ARG_DATEFORMAT).toString()}
				var EndDate=Ext.getCmp("DateTo").getValue()
				if(!Ext.isEmpty(EndDate)){EndDate=EndDate.format(ARG_DATEFORMAT).toString()}
				var CreatUserid=Ext.getCmp("CreateUser").getValue();
				var ImportFlag = Ext.getCmp('ImportFlag').getValue();
				//^^^����id
				var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^"+defaRp+"^"+spec+"^"+brand+"^"+abbrev+"^"+brp+"^"+bsp
					+"^^^"+StartDate+"^"+EndDate+"^"+CreatUserid+"^"+ImportFlag;
				if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")&&(Vendor=="")) {
					Msg.info("warning", "��ѡ���ѯ����!");
					return false;
				}
				DrugInfoStore.setBaseParam('InciDesc',inciDesc);
				DrugInfoStore.setBaseParam('InciCode',inciCode);
				DrugInfoStore.setBaseParam('Alias',alias);
				DrugInfoStore.setBaseParam('StkCatId',stkCatId);
				DrugInfoStore.setBaseParam('AllFlag',allFlag);
				DrugInfoStore.setBaseParam('Others',others);
				DrugInfoStore.setBaseParam('HighPrice',highPrice);
				DrugInfoStore.setBaseParam('Charge',charge);
				DrugInfoStore.setBaseParam('Implantation',implantation);
				DrugInfoStore.setBaseParam('Vendor',Vendor);
				DrugInfoStore.setBaseParam('sort', 'InciCode');
				DrugInfoStore.setBaseParam('dir', 'ASC');
				DrugInfoStore.removeAll();
				DrugInfoStore.load({
					params:{start:0,limit:StatuTabPagingToolbar.pageSize},			
					callback : function(r,options, success) {
						if(success==false){
							Msg.info("error", "��ѯ������鿴��־!");
							//DrugInfoGrid.loadMask.hide();
							//return "{results:0,rows:[]}";
						}
					}
				});
			}
		});

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
				M_StkGrpType.getStore().load();
				M_StkCat.setValue("");	
				M_GeneName.setValue("");
				Ext.getCmp("FindTypeCombo").setValue("1");
				M_HighPrice.setValue('');
				M_ChargeFlag.setValue('');
				M_ImplantationMat.setValue('');
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				Vendor.setValue("");
				StatuTabPagingToolbar.getComponent(4).setValue(1);   //���õ�ǰҳ��
				StatuTabPagingToolbar.getComponent(5).setText("ҳ,�� 1 ҳ");//���ù���ҳ
				StatuTabPagingToolbar.getComponent(12).setText("û�м�¼"); //���ü�¼����
			}
		});
		
		//		
		// ������ť
		var ExportAllToExcelBT = new Ext.Toolbar.Button({
			text : '�������',
			tooltip : '�������',
			width : 70,
			height : 30,
			iconCls : 'page_excel',
			handler : function() {
				ExportAllToExcel(DrugInfoGrid);
			}
		});
		
		var printInciBarCode = new Ext.Toolbar.Button({
			text : '��ӡ����',
			iconCls : 'page_print',
			width : 70,
			height : 30,
			handler : function(button, e) {
				DHCP_GetXMLConfig("DHCSTM_InciBarcode");
				var selectRows = DrugInfoGrid.getSelectionModel().getSelections();
				if (selectRows.length == 0) {
					Msg.info("warning", "��ѡ��Ҫ��ӡ��������ʣ�");
					return;
				}
				for(var rowIndex=0;rowIndex<selectRows.length;rowIndex++){
					var RowData = selectRows[rowIndex];
					var InciBarcode = RowData.get("INCIBarCode");
					if(InciBarcode==""){
						continue;
					}
					var IncDesc= RowData.get("InciDesc");
					var Spec=RowData.get("Spec");
					var Rp=RowData.get("Rp");
					var MyPara = 'InciBarcode' + String.fromCharCode(2) + "*" + InciBarcode + "*"
								+ '^IncDesc' + String.fromCharCode(2) + IncDesc
								+ '^Spec' + String.fromCharCode(2) + Spec
								+ '^Rp' + String.fromCharCode(2) + Rp;
					DHCP_PrintFun(MyPara, "");
				}
			}
		});
		var printInciBarCodeAll = new Ext.Toolbar.Button({
				text : '��ӡ��ҳ����',
				iconCls : 'page_print',
				width : 70,
				height : 30,
				handler : function(button, e) {
					DHCP_GetXMLConfig("DHCSTM_InciBarcode");
					var count = DrugInfoGrid.getStore().getCount();
					for (var i = 0; i < count; i++) {
						var RowData = DrugInfoGrid.getStore().getAt(i);
						var InciBarcode = RowData.get("INCIBarCode");
						if(InciBarcode==""){
							continue;
						}
						var IncDesc= RowData.get("InciDesc");
						var Spec=RowData.get("Spec");
						var Rp=RowData.get("Rp");
						var MyPara = 'InciBarcode' + String.fromCharCode(2) + "*" + InciBarcode + "*"
									+ '^IncDesc' + String.fromCharCode(2) + IncDesc
									+ '^Spec' + String.fromCharCode(2) + Spec
									+ '^Rp' + String.fromCharCode(2) + Rp;
						DHCP_PrintFun(MyPara, "");
					}
				}
			});
		var BatchSave = new Ext.Toolbar.Button({
			text : '�����޸�',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function(button, e) {
				var selectRows = DrugInfoGrid.getSelectionModel().getSelections();
				if (selectRows.length == 0) {
					Msg.info("warning", "��ѡ����Ҫ�����޸ĵ�����");
					return;
				}
				var InciIdStr=""
				for(var rowIndex=0;rowIndex<selectRows.length;rowIndex++){
					var RowData = selectRows[rowIndex];
					var InciId = RowData.get("InciRowid");
					if(InciIdStr==""){InciIdStr=InciId;}
					else{InciIdStr=InciIdStr+"^"+InciId;}
				}
				BatchSaveWin(InciIdStr,DrugInfoStore)
			}
		});
		var SendInciBT = new Ext.Toolbar.Button({
					id : "SendInciBT",
					text : '����������Ϣ��ƽ̨',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						var selectRows = DrugInfoGrid.getSelectionModel().getSelections();
						if (selectRows.length == 0) {
							Msg.info("warning", "��ѡ����Ҫͬ��������");
							return;
						}
						var InciIdStr=""
						for(var rowIndex=0;rowIndex<selectRows.length;rowIndex++){
							var RowData = selectRows[rowIndex];
							var InciId = RowData.get("InciRowid");
							if(InciIdStr==""){InciIdStr=InciId;}
							else{InciIdStr=InciIdStr+"^"+InciId;}
						}
						var Synresult=tkMakeServerCall("web.DHCSTM.ServiceForSCI","getHopInc",InciIdStr);
						if (Synresult==""){Msg.info("success","ͬ���ɹ�");}
						else{Msg.info("warning","ͬ������ʧ�ܣ�"+Synresult);}
					}
		});
		var nm = new Ext.grid.RowNumberer();
		var	sm=new Ext.grid.CheckboxSelectionModel({
			singleSelect : false,
			checkOnly:true
		});
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, sm,
			{
				header : "�����id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "���ʴ���",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : '��������',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				renderer : InciPicRenderer('InciRowid'),
				sortable : true
			},{
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : "�ͺ�",
				dataIndex : 'model',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "Ʒ��",
				dataIndex : 'brand',
				width : 60,
				align : 'left',
				sortable : true
			},{
				header : "��ܼ���",
				dataIndex : 'Supervision',
				width : 60,
				align : 'center',
				sortable : true
			},{
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : "����",
				dataIndex : 'Origin',
				width : 80
			},{
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			},{
				header : "����(��ⵥλ)",
				dataIndex : 'Rp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "�ӳ�",
				dataIndex : 'Marginnow',
				width : 60,
				align : 'right',
				sortable : true
			},{
				header : "����ۼ�(��ⵥλ)",
				dataIndex : 'MaxSp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "������λ",
				dataIndex : 'BUom',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "������",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			},{
				header : "������",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				xtype:'checkcolumn',
				sortable : true
			},{
				header:'��Ӧ��rowid',
				dataIndex:'vendor',
				align:'left',
				hidden:true
			},{
				header:'��Ӧ��',
				dataIndex:'vendorName',
				align:'left',
				width:150
			},{
				header:'ע��֤��',
				dataIndex:'registerNo',
				align:'left',
				width:150
			},{
				header:'ע��֤Ч��',
				dataIndex:'registerNoExpDate',
				align:'left',
				width:150
			},{
				header:'ע��֤��֤����',
				dataIndex:'regCertDateOfIssue',
				align:'left',
				width:150
			},
			/*{
				header:'ע��֤��ȫ��',
				dataIndex:'regCertNoFull',
				align:'left',
				width:150
			},*/
			{
				header:'ע��֤����',
				dataIndex:'regItmDesc',
				align:'left',
				width:150
			},{
				header:'������-�������֤��',
				dataIndex:'productionlicense',
				align:'left',
				xtype:'',
				width:150
			},{
				header:'��Ӧ��-��Ӫ���֤��',
				dataIndex:'businesscertificate',
				align:'left',
				width:150
			},{
				header:'��Ӧ��-Ӫҵִ�պ�',
				dataIndex:'businesslicense',
				align:'left',
				width:150
			},{
				header:'��Ӧ��-��ϵ��',
				dataIndex:'contactperson',
				align:'left',
				width:150
			},{
				header:'��Ӧ��-��Ȩ����',
				dataIndex:'authorizationdate',
				align:'left',
				width:150
			},{
				header:'��Ӧ��-��ϵ�绰',
				dataIndex:'contacttel',
				align:'left',
				width:150
			},{
				header : "����(������λ)",
				dataIndex : 'bRp',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header:'��ֵ��־',
				dataIndex:'highpriceflag',
				align:'left',
				xtype:'checkcolumn',
				width:80,
				sortable : true
			},{
				header : "ֲ���־",
				dataIndex :'implantationmat',
				xtype:'checkcolumn',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "ҩѧ�����",
				dataIndex :'PhcdCode',
				width : 80
				
			},{
				header:'�½���',
				dataIndex:'CreateUser',
				align:'left',
				width:150
			}, {
				header : "��������",
				dataIndex : 'INCIBarCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "���ڱ�־",
				dataIndex : 'ImportFlag',
				width : 80
			}
		]);
		
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : DrugInfoStore,
			pageSize : 30,
			displayInfo : true
		});
		
		var DrugInfoGrid = new Ext.ux.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
//			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : sm,
			loadMask : true,
			bbar:StatuTabPagingToolbar,
			listeners:
			{
				rowcontextmenu : function(grid,rowindex,e){
					
					e.preventDefault();
					grid.getSelectionModel().selectRow(rowindex);
					SEL_REC=grid.getStore().getAt(rowindex);
					
					rightClick.showAt(e.getXY());
				}
			}
		});

		var HisListTab = new Ext.ux.FormPanel({
			labelWidth: 60,
			title:'������Ϣ��ѯ',
			tbar : [SearchBT, '-', ClearBT,'-',ExportAllToExcelBT,'-',printInciBarCode,'-',printInciBarCodeAll,'-',BatchSave,'-',SendInciBT],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults : {xtype: 'fieldset', border : false},
				style:'padding:0px 0px 0px 5px',
				items : [{
					columnWidth: 0.2,
					items: [M_InciCode,M_InciDesc,M_GeneName,DateFrom]
				}, {
					columnWidth: 0.2,
					items : [M_StkGrpType,M_StkCat,Vendor,DateTo]
				}, {
					columnWidth: 0.2,
					items : [FindTypeCombo,Spec,Brand,CreateUser]
				}, {
					columnWidth: 0.15,
					labelWidth: 60,
					items : [Abbrev,BRp,BSp,ImportFlag]
				}, {
					columnWidth: 0.25,
					items : [M_HighPrice,M_ChargeFlag,M_ImplantationMat]
				}]
			}]
		});
		
		
		/***
		**����Ҽ��˵�,zdm,2012-01-04***
		**/
		function editPHCDF()
		{		
			gParam=GetParams();
			var EnablePhcdForMat=GetParam(gParam,"EnablePhcdForMat");
			if (EnablePhcdForMat!='Y')
			{
				Msg.info('error','��ǰ���ò�����ά�����ʲ��ϵ�ҩѧ��Ŀ����֪ͨϵͳ����Ա��');
				return ;
			}
			if (SEL_REC)
			{
				var inci=SEL_REC.get("InciRowid");
				ShowPhc(inci);
			}
			
		}
		
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{
					id: 'mnuPhcdf', 
					handler: editPHCDF, 
					text: ' ҩѧ��ά��...' 
				}
				
			] 
		}); 
		
		//======Grid����¼�===================================
		
		//RefreshGridColSet(DrugInfoGrid,"dhcstm.DrugQuery");   //�����Զ�������������������             
		
		var viewport = new Ext.ux.Viewport({
            layout: 'border',           
            title: '�����б�',
            items: [ HisListTab,DrugInfoGrid ]
        });
       
   function GetParams(){
		var userId = session['LOGON.USERID'];
		var groupId=session['LOGON.GROUPID'];
		var locId=session['LOGON.CTLOCID'];
		var hospId=session['LOGON.HOSPID'];
		var url='dhcstm.druginfomaintainaction.csp?actiontype=GetParamPropNew&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId+"&HospId="+hospId;
		var response=ExecuteDBSynAccess(url);
		var jsonData=Ext.util.JSON.decode(response);
		if(jsonData.success=='true'){
			var info=jsonData.info;
			return info;	
		}
	}

	function GetParam(G,P)
	{
		var len=G.length;
		for (var i=0;i<len;i++)
		{
			var obj=G[i];
			if  (obj.APCode==P)
			{
				return  obj.APValue;
			}
		}
	}

})