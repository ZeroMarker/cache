// /����: ҩƷ��Ϣ��ѯ
// /����: ҩƷ��Ϣ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.06.15
var drugRowid = "";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var LocId=session['LOGON.CTLOCID'];
var GroupId=session['LOGON.GROUPID'];
var gNewCatIdOther="";
var InciDescLookupGrid;
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		//============================DrugList.js====================================================================
		//==========����==========================
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
			drugRowid=inciDr;
			Search();
		}

		//==========����==========================
		
		//==========�ؼ�==========================
		// ҩƷ����
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : 'ҩƷ����',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			width : 150,
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						Search();
					}
				}
			}
		});
		var showshow=0
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : 'ҩƷ����',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						/*
						if (document.getElementById('bodyLookupComponetId').innerHTML!=""){
							if (document.getElementById('bodyLookupComponetId').style.display!="none"){
								e.stopEvent();
								e.preventDefault();
								e.stopPropagation();
								return false;
							}
						}*/
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						var allCatGrpFlag=(stktype=="")?"Y":"";
						GetPhaOrderLookUp(field.getValue(), stktype, App_StkTypeCode, "", "", "0", "",getDrugList,"",allCatGrpFlag);
					}
				}
			}
		})
		
		// ҩƷ����
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : 'ҩƷ����',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			width : 150,
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						Search();
					}
				}
			}
		});

		// ҩƷ����
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({
			fieldLabel : '�ࡡ����', 
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor:'90%',
			//LocId:LocId,
			UserId:UserId,
			listeners:{
				select:function(){
					M_StkCat.setValue('');
					M_StkCat.setRawValue('');
				}
			}
		}); 
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '������',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'M_StkGrpType'}
		});

		// ҩѧ����
		var M_PhcCat = new Ext.ux.ComboBox({
			fieldLabel : 'ҩѧ����',
			id : 'M_PhcCat',
			name : 'M_PhcCat',
			store : PhcCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			filterName:'PhccDesc'
		});

		M_PhcCat.on('change', function() {
			Ext.getCmp('M_PhcSubCat').setValue("");
			Ext.getCmp('M_PhcMinCat').setValue("");
		});
		
		// ҩѧ����
		var M_PhcSubCat = new Ext.ux.ComboBox({
			fieldLabel : 'ҩѧ����',
			id : 'M_PhcSubCat',
			name : 'M_PhcSubCat',
			store : PhcSubCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{PhcCatId:'M_PhcCat'}
		});

		M_PhcSubCat.on('change', function() {
			Ext.getCmp('M_PhcMinCat').setValue("");
		});
		
		// ҩѧС��
		var M_PhcMinCat = new Ext.ux.ComboBox({
			fieldLabel : 'ҩѧС��',
			id : 'M_PhcMinCat',
			name : 'M_PhcMinCat',
			store : PhcMinCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{PhcSubCatId:'M_PhcSubCat'}
		});
		
var PHCCATALLOTH = new Ext.form.TextField({
	fieldLabel : 'ҩѧ����',
	id : 'PHCCATALLOTH',
	name : 'PHCCATALLOTH',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : '',
	disabled:true
});
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALLOTH").setValue(catdescstr);
	gNewCatIdOther=newcatid;	
}

var PHCCATALLOTHButton = new Ext.Button({
	id:'PHCCATALLOTHButton',
	text : 'ҩѧ����',
	handler : function() {	
		PhcCatNewSelect(gNewCatIdOther,GetAllCatNew)

    }
});

var PHCCATClearButton = new Ext.Button({
	id:'PHCCATClearButton',
	text : '���',
	handler : function() {	
		Ext.getCmp("PHCCATALLOTH").setValue("");
		gNewCatIdOther=""
		

    }
});
		

		// ȫ��
		var M_AllFlag = new Ext.form.Checkbox({
			fieldLabel : 'ȫ��',
			id : 'M_AllFlag',
			name : 'M_AllFlag',
			anchor : '90%',
			width : 150,
			checked : false
		});
		var M_DateFrom = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			text:'��ʼ����',
			id : 'M_DateFrom',
			name : 'M_DateFrom',
			value:'',
			hidden:true
		});
		var M_DateFromText=new Ext.Toolbar.TextItem({
			id: 'M_DateFromText',
			text:'��ʼ����:',
			allowBlank:true,
			hidden:true
		});
		var M_DateTo = new Ext.ux.DateField({
			fieldLabel : '��������',
			text:'��������',
			id : 'M_DateTo',
			name : 'M_DateTo',
			value:'',
			hidden:true
		});
		var M_DateToText=new Ext.Toolbar.TextItem({
			id: 'M_DateToText',
			text:'��������:',
			allowBlank:true,
			hidden:true
		});

		//ҩƷ��������
		var InciUseConditionStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['OnlyUse', '����ҩƷ'], ['NewAdd','����ҩƷ'],['OnlyNotUse', 'ͣ��ҩƷ'], ['ArcStop', 'ҽ�����ֹ'],["All","ȫ������"]]
		});
		var InciUseCondition = new Ext.form.ComboBox({
				fieldLabel : 'ҩƷ״̬',
				id : 'InciUseCondition',
				name : 'InciUseCondition',
				store : InciUseConditionStore,
				valueField : 'RowId',
				displayField : 'Description',
				mode : 'local',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				forceSelection : true,
				anchor:'90%',  
				listeners : {
		            'select' : function(e) {
			            var tbarvisible=false;
			            if ((e.value=="NewAdd")||(e.value=="ArcStop")){tbarvisible=true}
				        Ext.getCmp('M_DateFrom').setVisible(tbarvisible);
			            Ext.getCmp('M_DateFromText').setVisible(tbarvisible);
			            Ext.getCmp('M_DateTo').setVisible(tbarvisible);
			            Ext.getCmp('M_DateToText').setVisible(tbarvisible);
		            }
    }
			});
		Ext.getCmp("InciUseCondition").setValue("OnlyUse");
		//==========�ؼ�==========================

		//��������Դ
		var DspPhaUrl = 'dhcst.druginfomaintainaction.csp';
		var proxy= new Ext.data.HttpProxy({url:DspPhaUrl+'?actiontype=GetItm',method:'POST'});

	
		// ָ���в���
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "Form", "GoodName","GenericName", "StkCat", "PhcCat", "PhcSubCat", "PhcMinCat","NotUseFlag","PhaCatAllDesc","ArcItemCat","OrderCat","Rp","InstrDesc","FreqDesc","PoisonDesc","ItmRemark","MaxSp","CountryBasicFlag","ProvinceBasicFlag","AntiFlag","InHosFlag","ImportFlag","CodexFlag","DrugUseInfo","OutUomDesc","InUomDesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			pageSize:30,
			//id : "InciRowid",
			fields : fields
		});
	
		// ���ݼ�
		var DrugInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			remoteSort: true
		});


		// �������ʽ
		//DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
	
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				Search();
			}
		});
		function Search(){
				var inciDesc = Ext.getCmp("M_InciDesc").getValue();
				var inciCode = Ext.getCmp("M_InciCode").getValue();
				var alias = Ext.getCmp("M_GeneName").getValue();
				var stkCatId = Ext.getCmp("M_StkCat").getValue();
				var PhcCatId = Ext.getCmp("M_PhcCat").getValue();
				var PhcSubCatId = Ext.getCmp("M_PhcSubCat").getValue();
				var PhcMinCatId = Ext.getCmp("M_PhcMinCat").getValue();
				var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
				var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
				var InciUseCondition=Ext.getCmp("InciUseCondition").getValue();
				var InciStartDate=Ext.getCmp("M_DateFrom").getValue();
				if (InciStartDate!=""){InciStartDate=InciStartDate.format('Y-m-d').toString();}
				var InciEndDate=Ext.getCmp("M_DateTo").getValue();
				if (InciEndDate!=""){InciEndDate=InciEndDate.format('Y-m-d').toString();}
				if (InciUseCondition=="All"){allFlag="Y"}
				//ҩѧ����id^ҩѧ����id^ҩѧ��С����id^����id^ҩѧ�༶����id^ҩƷ״̬
				var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^"+gNewCatIdOther+"^"+InciUseCondition+"^"+InciStartDate+"^"+InciEndDate
				if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")&&(others=="^^^^^^^")) {
					Msg.info("warning", "��ѡ���ѯ����!");
					return false;
				}

				var Params=inciDesc+RowDelim+inciCode+RowDelim+alias+RowDelim+stkCatId+RowDelim+allFlag+RowDelim+others ;
				DrugInfoStore.setBaseParam('Params',Params);
				DrugInfoStore.load({
					params:{start:0,limit:StatuTabPagingToolbar.pageSize},			
					callback : function(r,options, success) {					//Store�쳣��������
						if(success==false){
		 					Ext.MessageBox.alert("��ѯ����",DrugInfoStore.reader.jsonData.Error);  
		 				}         				
					}
				});	
		}
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				Ext.getCmp("M_DateFrom").setValue("");
				Ext.getCmp("M_DateTo").setValue("");
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkCat.setValue("");
				M_PhcCat.setValue("");
				M_PhcSubCat.setValue("");
				M_PhcMinCat.setValue("");
				M_StkGrpType.setRawValue("");
				M_StkCat.setRawValue("");
				M_PhcCat.setRawValue("");
				M_PhcSubCat.setRawValue("");
				M_PhcMinCat.setRawValue("");
				M_GeneName.setValue("");
				M_AllFlag.setValue(false);
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
			    Ext.getCmp("PHCCATALLOTH").setValue("");
				gNewCatIdOther=""
				Ext.getCmp("InciUseCondition").setValue("OnlyUse");
				Ext.getCmp('M_DateFrom').setVisible(false);
				Ext.getCmp('M_DateFromText').setVisible(false);
				Ext.getCmp('M_DateTo').setVisible(false);
				Ext.getCmp('M_DateToText').setVisible(false);
				drugRowid="";
				DrugInfoStore.setBaseParam('Params',"");
				DrugInfoStore.load({
					params:{start:0,limit:0},			
					callback : function(r,options, success) {					
						if(success==false){
		 					Ext.MessageBox.alert("��ѯ����",DrugInfoStore.reader.jsonData.Error);  
		 				}         				
					}
				});	
			}
		});
		// ��水ť
		var SaveAsBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���ΪExcel',
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(DrugInfoGrid);

					}
				});
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
				width : 250,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',				
				sortable : true
			}, {
				header : "����(��ⵥλ)",
				dataIndex : 'Rp',
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
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "���﷢ҩ��λ",
				dataIndex : 'OutUomDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "סԺ��ҩ��λ",
				dataIndex : 'InUomDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Form',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʒ��",
				dataIndex : 'GoodName',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����ͨ����",
				dataIndex : 'GenericName',
				width : 130,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "ҩѧ����",
				dataIndex : 'PhcCat',
				width : 150,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "ҩѧ����",
				dataIndex : 'PhcSubCat',
				width : 150,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "ҩѧС��",
				dataIndex : 'PhcMinCat',
				width : 150,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : "ҩѧ����",
				dataIndex : 'PhaCatAllDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "ҽ������",
				dataIndex : 'ArcItemCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "ҽ������",
				dataIndex : 'OrderCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "�÷�",
				dataIndex : 'InstrDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "Ƶ��",
				dataIndex : 'FreqDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���Ʒ���",
				dataIndex : 'PoisonDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��׼�ĺ�",
				dataIndex : 'ItmRemark',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : "����ۼ�",
				dataIndex : 'MaxSp',
				width : 70,
				align : 'right',
				sortable : false
			}, {
				header : "���ڱ�־",
				dataIndex : 'ImportFlag',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "��ҩ˵��",
				dataIndex : 'DrugUseInfo',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : "���һ���ҩ��",
				dataIndex : 'CountryBasicFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "ʡ����ҩ��",
				dataIndex : 'ProvinceBasicFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "����ҩ",
				dataIndex : 'AntiFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "��ԺҩƷĿ¼",
				dataIndex : 'InHosFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "�й�ҩ���־",
				dataIndex : 'CodexFlag',
				width : 80,
				sortable : true,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				}
			}, {
				header : "������",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				renderer: function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
				},
				sortable : true
			}
		]);
		DrugInfoCm.defaultSortable = true;
		
				var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : DrugInfoStore,
					pageSize : 30,
					displayInfo : true,
					displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
					emptyMsg : "No results to display",
					prevText : "��һҳ",
					nextText : "��һҳ",
					refreshText : "ˢ��",
					lastText : "���ҳ",
					firstText : "��һҳ",
					beforePageText : "��ǰҳ",
					afterPageText : "��{0}ҳ",
					emptyMsg : "û������"
				});
				
		var DrugInfoGrid = new Ext.grid.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			//height:420,
			//width : 495,
			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:false}),
			loadMask : true,
			bbar:StatuTabPagingToolbar		
		});
	
		var HospPanel = InitHospCombo('ARC_ItmMast',function(combo, record, index){
			HospId = this.value; 
			DrugInfoStore.reload();
		});

		var HisListTab = new Ext.form.FormPanel({
			height:DHCSTFormStyle.FrmHeight(3),
			labelWidth:60,
			labelAlign : 'right',
			title:'ҩƷ��Ϣ��ѯ',
			frame : true,
			autoScroll : false,
			region : 'north',	
			tbar : [SearchBT, '-', ClearBT,'-',SaveAsBT,'-',M_DateFromText,M_DateFrom,M_DateToText,M_DateTo],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:DHCSTFormStyle.FrmPaddingV,	
				items : [{ 				
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 200, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [M_InciCode,M_InciDesc,M_GeneName]
					
				}, {
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 180, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,				
					items : [M_StkGrpType,M_StkCat,InciUseCondition]
				}, {
					columnWidth: 0.4,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 295, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,				
					items : [{xtype:'compositefield',items:[PHCCATALLOTH,PHCCATALLOTHButton,PHCCATClearButton]}]
				}]			
			}]			
		});
		
		
		/***
		**����Ҽ��˵�,zdm,2012-01-04***
		**/
		/*
		DrugInfoGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuInciAlias', 
					handler: editIncAliasInfo, 
					text: '��������' 
				},{ 
					id: 'mnuArcAlias', 
					handler: editArcAliasInfo, 
					text: 'ҽ�������' 
				},{ 
					id: 'mnuDoseEquiv', 
					handler: editDoseEquivInfo, 
					text: '��Ч����' 
				}
			] 
		}); 
		*/
		//======Grid����¼�===================================
		
		//RefreshGridColSet(DrugInfoGrid,"DHCST.DrugQuery");   //�����Զ�������������������             
		
		var viewport = new Ext.Viewport({
            layout: 'border',           
            title: 'ҩƷ�б�',
			items:[
				{
					region:'north',
					height:'500px',
					items:[HospPanel,HisListTab]
				},DrugInfoGrid
			]
        });
       
    
})
