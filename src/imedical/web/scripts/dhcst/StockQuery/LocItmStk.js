// /����: ����ѯ
// /����: ����ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.06
var gNewCatId="";
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var gIncId='';
	var gStrParam='';
	var gStrParamBatch='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
		//wyx add�������� 2013-11-13
	if(gParam.length<1){
		GetParam();  //��ʼ����������
		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
	ChartInfoAddFun();

   
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : 'ҩ��',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
	         listeners : {
	            'select' : function(e) {
	                     var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
	                     StkGrpType.getStore().removeAll();
	                     StkGrpType.getStore().setBaseParam("locId",SelLocId)
	                     StkGrpType.getStore().setBaseParam("userId",UserId)
	                     StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
	                     StkGrpType.getStore().load();
				}
			}
		});

		var DateTime = new Ext.ux.DateField({
					fieldLabel : '����',
					id : 'DateTime',
					name : 'DateTime',
					anchor : '90%',
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			fieldLabel : '����',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId
		});
		StkGrpType.on('change',function(){
			Ext.getCmp("DHCStkCatGroup").setValue('');
		});
		
		var TypeStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', '���Ϊ��'], ['2', '���Ϊ��'],
							['3', '���Ϊ��']]
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : '����',
					id : 'Type',
					name : 'Type',
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
		Ext.getCmp("Type").setValue("0");
		
		//�����Ƿ��п��
		var incilIfNotZeroStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', '�п��'], ['2', '�޿��']]
				});
		var incilIfNotZero = new Ext.form.ComboBox({
					fieldLabel : '�Ƿ��п��',
					id : 'incilIfNotZero',
					name : 'incilIfNotZero',
					anchor:'70%',
					store : incilIfNotZeroStore,
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
					valueNotFoundText : '',
					listeners : {
			                 'select' : function(e) {
                               	BatchReload();        
			               }
	                        }
				});
		Ext.getCmp("incilIfNotZero").setValue("1");
		
		
		//���ο���Ƿ����
		var incilStkActiveStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', '����'], ['2', '������']]
				});
		var incilStkActive = new Ext.form.ComboBox({
					fieldLabel : '��治����',
					id : 'incilStkActive',
					name : 'incilStkActive',
					anchor:'70%',
					store : incilStkActiveStore,
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
					valueNotFoundText : '',
					listeners : {
			                 'select' : function(e) {
                               	BatchReload();         
			               }
	                        }
				});
		//Ext.getCmp("incilStkActive").setValue("1");
		
		//����ҽ���Ƿ����
		var incilArcActiveStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', '����'], ['2', '������']]
				});
		var incilArcActive = new Ext.form.ComboBox({
					fieldLabel : 'ҽ��������',
					id : 'incilArcActive',
					name : 'incilArcActive',
					anchor:'70%',
					store : incilArcActiveStore,
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
					valueNotFoundText : '',
					listeners : {
			                 'select' : function(e) {
                               	BatchReload();      
			               }
	                        }
				});
		//Ext.getCmp("incilArcActive").setValue("1");
function BatchReload()
{
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				return;
				//Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),App_StkDateFormat);			
				//var StoNoZeroFlag = (Ext.getCmp("StoNoZeroFlag").getValue()==true?'Y':'N');	
				var IncilIfNotZero=Ext.getCmp("incilIfNotZero").getValue();
				var IncilStkActive=Ext.getCmp("incilStkActive").getValue();
				var IncilArcActive=Ext.getCmp("incilArcActive").getValue();
						
				gStrParamBatch=Incil+"^"+Date+"^"+IncilIfNotZero+"^"+IncilStkActive+"^"+IncilArcActive;
				
				BatchStore.setBaseParam("Params",gStrParamBatch);
				BatchStore.load({params:{start:0,limit:PageSize,Params:gStrParamBatch}});
			}
			
		
}

		var InciDesc = new Ext.form.TextField({
					fieldLabel : 'ҩƷ����',
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 140,
					selectOnFocus : true,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								var stkgrp=Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(),stkgrp);
							}
						}
					}
				});

				/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				var PhaLoc = Ext.getCmp("PhaLoc").getValue();
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, PhaLoc, "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);
			searchData();
			Ext.getCmp("InciDesc").focus(true,1000);						
		}

		var ImportStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['����', '����'], ['����', '����'], ['����', '����']]
				});
		var INFOImportFlag = new Ext.form.ComboBox({
					fieldLabel : '���ڱ�־',
					id : 'INFOImportFlag',
					name : 'INFOImportFlag',
					anchor : '90%',					
					store : ImportStore,
					valueField : 'RowId',
					displayField : 'Description',
					mode : 'local',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					listWidth : 150,
					forceSelection : true
				});
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : '������',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});
				
		// ҩѧ����
		var PhcCat = new Ext.ux.ComboBox({
					fieldLabel : 'ҩѧ����',
					id : 'PhcCat',
					name : 'PhcCat',				
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PhccDesc'
				});
		PhcCat.on('change', function() {
			Ext.getCmp('PhcSubCat').setValue("");
			Ext.getCmp('PhcMinCat').setValue("");
		});

		// ҩѧ����
		var PhcSubCat = new Ext.ux.ComboBox({
					fieldLabel : 'ҩѧ����',
					id : 'PhcSubCat',
					name : 'PhcSubCat',			
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcCatId:'PhcCat'}
				});

		// ҩѧС��
		var PhcMinCat = new Ext.ux.ComboBox({
					fieldLabel : 'ҩѧС��',
					id : 'PhcMinCat',
					name : 'PhcMinCat',		
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcSubCatId:'PhcSubCat'}
				});
var PHCCATALL = new Ext.form.TextField({
	fieldLabel : 'ҩѧ����',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	anchor : '90%',
	readOnly : true,
	width:115,
	valueNotFoundText : ''
});
//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : 'ҩѧ����',
	handler : function() {	
		PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});

		var ARCItemCat = new Ext.ux.ComboBox({
					fieldLabel : 'ҽ������',
					id : 'ARCItemCat',
					name : 'ARCItemCat',
					store : ArcItemCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'Desc'
				});

		var PHCDFPhcDoDR = new Ext.ux.ComboBox({
					fieldLabel : '���Ʒ���',
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var PhManufacturer = new Ext.ux.ComboBox({
					fieldLabel : '����',
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHMNFName'
				});

		var PHCDOfficialType = new Ext.ux.ComboBox({
					fieldLabel : 'ҽ�����',
					id : 'PHCDOfficialType',
					name : 'PHCDOfficialType',
					store : OfficeCodeStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var PHCForm = new Ext.ux.ComboBox({
					fieldLabel : '����',
					id : 'PHCForm',
					name : 'PHCForm',			
					store : PhcFormStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHCFDesc'
				});		

		var ManageDrug = new Ext.form.Checkbox({
					boxLabel : '����ҩ',
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',				
					height : 20,
					checked : false
				});


		var UseFlag = new Ext.form.Checkbox({
					boxLabel : '������Ʒ��',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',					
					height : 20,
					checked : true
				});

		var NotUseFlag = new Ext.form.Checkbox({
					boxLabel : '��������Ʒ��',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',					
					height : 20,
					checked : false
				});
				
		var StoNoZeroFlag = new Ext.form.Checkbox({
					boxLabel : '���п��ҽ�����β�����',
					id : 'StoNoZeroFlag',
					name : 'StoNoZeroFlag',
					anchor : '90%',					
					height : 20,
					checked : false
				});
				
		var ArcStatStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', 'ҽ�����ֹ'], ['2', 'ҽ��������']]
				});
		var ArcStat = new Ext.form.ComboBox({
					fieldLabel : 'ҽ����״̬',
					id : 'ArcStat',
					name : 'ArcStat',
					anchor:'90%',
					store : ArcStatStore,
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
		Ext.getCmp("ArcStat").setValue("0");


		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : '��ѯ',
					tooltip : '�����ѯ',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
		//wyx add 2014-01-15
		setNormalValue("HisListTab")
		var PhaLocDesc = Ext.getCmp("PhaLoc").getRawValue();
		if (PhaLocDesc ==""||PhaLocDesc == null || PhaLocDesc.length <= 0) {
				Msg.info("warning", "ҩ������Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}	
			
			
			
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "ҩ������Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
		//wyx add 2014-01-15
		var DateTimetmp = Ext.getCmp("DateTime").getValue()
		if (DateTimetmp=="") {
		    Msg.info("warning", "���ڲ���Ϊ�գ�");
		    Ext.getCmp("DateTime").focus();
		    return;
				}
			
			var date = Ext.getCmp("DateTime").getValue().format(App_StkDateFormat)
					.toString();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StockType = Ext.getCmp("Type").getValue();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "���ڲ���Ϊ�գ�");
				Ext.getCmp("DateTime").focus();
				return;
			}
			if ((StkGrpRowId == null || StkGrpRowId.length <= 0)&(gParamCommon[9]=="N")) {
				Msg.info("warning", "���鲻��Ϊ�գ�");
				Ext.getCmp("StkGrpType").focus();
				return;
			}
			if (StockType == null || StockType.length <= 0) {
				Msg.info("warning", "���Ͳ���Ϊ�գ�");
				Ext.getCmp("Type").focus();
				return;
			}
			
			// ��ѡ����
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var PhcCatList = "";
			var PhcCat = Ext.getCmp("PhcCat").getValue();
			var PhcSubCat = Ext.getCmp("PhcSubCat").getValue();
			var PhcMinCat = Ext.getCmp("PhcMinCat").getValue();
			var ARCItemCat = Ext.getCmp("ARCItemCat").getValue();
			var PHCDFPhcDoDR = Ext.getCmp("PHCDFPhcDoDR").getValue();
			var PhManufacturer = Ext.getCmp("PhManufacturer").getValue();
			var PHCDOfficialType = Ext.getCmp("PHCDOfficialType").getValue();
			var PHCForm = Ext.getCmp("PHCForm").getValue();
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();
			var StoNoZeroFlag = (Ext.getCmp("StoNoZeroFlag").getValue()==true?'Y':'N');
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			var ArcStatValue=Ext.getCmp("ArcStat").getValue();
			var strParam=phaLoc+"^"+date+"^"+StkGrpRowId+"^"+StockType+"^"+gIncId
			+"^"+ImpFlag+"^"+DHCStkCatGroup+"^"+PhcCat+"^"+PhcSubCat+"^"+PhcMinCat
			+"^"+ARCItemCat+"^"+PHCDFPhcDoDR+"^"+PhManufacturer+"^"+PHCDOfficialType
			+"^"+PHCForm+"^"+ManageDrug+"^"+UseFlag+"^"+NotUseFlag+"^"+gNewCatId
			+"^"+ArcStatValue+"^"+StoNoZeroFlag;
			BatchGrid.store.removeAll();
			StockQtyStore.setBaseParam("Params",strParam);
			StockQtyStore.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize}});
			StockQtyStore.on('load',function(){
				if (StockQtyStore.getCount()>0){
					StockQtyGrid.getSelectionModel().selectRow(1);
					StockQtyGrid.getView().focusRow(1);
				}
			});
		}
        	
			
		

		function manFlagRender(value){
			if(value==1){
				return '����ҩ'	;		
			}else if (value==0) {
				return '�ǹ���ҩ';
			
			}
		}
				
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '����',
					tooltip : '�������',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),"PhaLoc");
	        Ext.getCmp("StkGrpType").getStore().setBaseParam("locId",gLocId)
            Ext.getCmp("StkGrpType").getStore().setBaseParam("userId",UserId)
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("Type").setValue('0');
			Ext.getCmp("DateTime").setValue(new Date());
			Ext.getCmp("InciDesc").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("PhcSubCat").setValue('');
			Ext.getCmp("PhcMinCat").setValue('');
			Ext.getCmp("ARCItemCat").setValue('');
			Ext.getCmp("PHCDFPhcDoDR").setValue('');
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("PHCDOfficialType").setValue('');
			Ext.getCmp("PHCForm").setValue('');
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(true);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("INFOImportFlag").setValue('');
			gIncId="";
			StockQtyGrid.store.removeAll();
			StockQtyStore.setBaseParam("Params","");
			StockQtyStore.load({params:{start:0,limit:0}});
			StatuTabPagingToolbar.updateInfo();
			StockQtyGrid.getView().refresh();
			Ext.getCmp("PHCCATALL").setValue("");
			gNewCatId=""
			BatchGrid.store.removeAll();
			BatchStore.setBaseParam("Params","");
			Ext.getCmp("incilIfNotZero").setValue("1");
			Ext.getCmp("incilStkActive").setValue("");
			Ext.getCmp("incilArcActive").setValue("");
			BatchStore.load({params:{start:0,limit:0}});
			BatchGrid.getView().refresh();
			
		}

		// ��水ť
		var SaveAsBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���ΪExcel',
					iconCls : 'page_excel',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);
						//gridSaveAsExcel(StockQtyGrid);
					}
				});
				
		// ��С��1����ֵ��0�����������ֵ��ֵ����
	function SetNumber(val,meta){
		    if (val=="") return ""
			var newnum=parseFloat(val)
			if(!newnum) newnum=val
			else newnum=Number(val) 
			
			return newnum
		
		}		
		
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.RowSelectionModel({singleSelect:true});
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "INCILRowID",
					dataIndex : 'Incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '���(��װ��λ)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true,
					renderer:SetNumber
				}, {
					header : "��װ��λ",
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "���(������λ)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : "������λ",
					dataIndex : 'BUomDesc',
					width : 60,
					align : 'left',
					sortable : false
				}, {
					header : "���(��λ)",
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "ռ�ÿ��",
					dataIndex : 'DirtyQty',
					width : 100,
					align : 'right',
					sortable : true,
				}, {
					header : "���ÿ��",
					dataIndex : 'AvaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "��;��",
					dataIndex : 'ReservedQty',
					width : 100,
					align : 'right',
					sortable : true,
					//renderer:SetNumber
				}, {
					header : "���ۼ�",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false,
					renderer:SetNumber
				}, {
					header : "���½���",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false,
					renderer:SetNumber
				}, {
					header : '�ۼ۽��',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false,
					renderer:FormatGridSpAmount
				}, {
					header : '���۽��',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false,
					renderer:FormatGridRpAmount
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '����',
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "����ͨ����",
					dataIndex : 'Gene',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "ҽ�����",
					dataIndex : 'OfficalCode',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "����",
					dataIndex : 'FormDesc',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "�Ƿ����ҩ",
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : false,
					renderer:manFlagRender
				}]);
		var GridColSetBT = new Ext.Toolbar.Button({
	      text:'������',
          tooltip:'������',
          iconCls:'page_gear',
          //	width : 70,
         //	height : 30,
	      handler:function(){
		    GridColSet(StockQtyGrid,"DHCSTLOCITMSTK");
	      }
        });
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStk&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["Incil", "Inci", "InciCode", "InciDesc",
				"StkBin", "PurUomDesc", "BUomDesc", "PurStockQty",
				"StockQty", "StkQtyUom", {name:"Sp",type:"float"},{name:"SpAmt",type:"float"} ,
				{name:"Rp",type:"float"}, {name:"RpAmt",type:"float"}, "Spec", "ManfDesc",
				"OfficalCode", "ManFlag","DirtyQty","AvaQty","ReservedQty","Gene", "FormDesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Incil",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
					prevText : "��һҳ",
					nextText : "��һҳ",
					refreshText : "ˢ��",
					lastText : "���ҳ",
					firstText : "��һҳ",
					beforePageText : "��ǰҳ",
					afterPageText : "��{0}ҳ",
					emptyMsg : "û������"
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true,
					border:false,
					bbar : [StatuTabPagingToolbar],
					tbar:[GridColSetBT]
				});
		// ��ӱ�񵥻����¼�
		StockQtyGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var Incil = StockQtyStore.getAt(rowIndex).get("Incil");
			var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),App_StkDateFormat);			
			//var StoNoZeroFlag = (Ext.getCmp("StoNoZeroFlag").getValue()==true?'Y':'N');	
			var IncilIfNotZero=Ext.getCmp("incilIfNotZero").getValue();
			var IncilStkActive=Ext.getCmp("incilStkActive").getValue();
			var IncilArcActive=Ext.getCmp("incilArcActive").getValue();
					
			gStrParamBatch=Incil+"^"+Date+"^"+IncilIfNotZero+"^"+IncilStkActive+"^"+IncilArcActive;
			
			BatchStore.setBaseParam("Params",gStrParamBatch);
			BatchStore.load({params:{start:0,limit:PageSize,Params:gStrParamBatch}});
			
		});
		
		
			
		var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: 'ҽ��������',
   		dataIndex: 'NotUseFlag',
   		width: 80,
   		sortable:true,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
		    return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	    });	
		var ColumnStkNotUseFlag = new Ext.grid.CheckColumn({
   		header: '��治����',
   		dataIndex: 'StkNotUseFlag',
   		width: 80,
   		sortable:true,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
		    return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	    });		
		var nm = new Ext.grid.RowNumberer();
		var BatchCm = new Ext.grid.ColumnModel([{
					header : "Inclb",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, ColumnNotUseFlag,
				   ColumnStkNotUseFlag,{
					header : '����',
					dataIndex : 'BatNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "Ч��",
					dataIndex : 'ExpDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'QtyUom',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "ռ��",
					dataIndex : 'DirtyQty',
					width : 90,
					align : 'left',
					sortable : true,
				}, {
					header : "����",
					dataIndex : 'AvaQty',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "��;",
					dataIndex : 'InclbResQty',
					width : 90,
					align : 'left',
					sortable : true,
					//renderer:SetNumber
				}, {
					header : '����(����)',
					dataIndex : 'BRp',
					width : 90,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "����(��װ)",
					dataIndex : 'PRp',
					width : 90,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : '�ۼ�(����)',
					dataIndex : 'BSp',
					width : 90,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "�ۼ�(��װ)",
					dataIndex : 'PSp',
					width : 90,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "��Ӧ��",
					dataIndex : 'PVenDesc',
					width : 150,
					align : 'left',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "����",
					dataIndex : 'PManf',
					width : 150,
					align : 'left',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "������",
					dataIndex : 'LockUser',
					width : 80,
					align : 'center',
					sortable : true
				}, {
					header : "����ʱ��",
					dataIndex : 'LockDate',
					width : 130,
					align : 'left',
					sortable : true
				}]);
		BatchCm.defaultSortable = false;
		
		// ����·��
		var BatchUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=Batch&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxyBatch = new Ext.data.HttpProxy({
					url : BatchUrl,
					method : "POST"
				});
		// ָ���в���
		var fieldsBatch = ["BatNo", "ExpDate", "QtyUom", {name:"BRp",type:"float"},{name:"PRp",type:"float"}, "Inclb","DirtyQty",
		"AvaQty","PVenDesc","PManf","NotUseFlag",{name:"BSp",type:"float"},{name:"PSp",type:"float"},"InclbResQty","LockUser","LockDate","StkNotUseFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var readerBatch = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsBatch
				});
		// ���ݼ�
		var BatchStore = new Ext.data.Store({
					proxy : proxyBatch,
					reader : readerBatch,
					remoteSort:true,
					pruneModifiedRecords:true
				});

		var StatuTabPagingToolbarBatch = new Ext.PagingToolbar({
					store : BatchStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
					prevText : "��һҳ",
					nextText : "��һҳ",
					refreshText : "ˢ��",
					lastText : "���ҳ",
					firstText : "��һҳ",
					beforePageText : "��ǰҳ",
					afterPageText : "��{0}ҳ",
					emptyMsg : "û������"
				});
        //yunhaibao20151118,���ο�������
        var NoUseBT = new Ext.Toolbar.Button({
          	text:'�޸Ĳ�����״̬',
          	iconCls:'page_edit',
         	handler:function(){
				var mr=BatchStore.getModifiedRecords();
				var BatListDetail="";
				for(var i=0;i<mr.length;i++){
					var inclb = mr[i].data["Inclb"];
					var notuseflag = mr[i].data["NotUseFlag"];
					var stknotuseflag = mr[i].data["StkNotUseFlag"];
					var iList=inclb+"^"+notuseflag+"^"+gUserId+"^"+stknotuseflag
					if (BatListDetail==""){
						BatListDetail=iList;	
					}
					else{
						BatListDetail=BatListDetail+xRowDelim()+iList;	
					}
				}
				if (BatListDetail==""){
					Msg.info("warning", "�޿��ñ�����Ϣ!");
					return
				}
				var url = DictUrl+ 'locitmstkaction.csp?actiontype=ChangeBatchUseFlag';
				var loadMask=ShowLoadMask(Ext.getBody(),"������...");
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							params:{BatListDetail:BatListDetail},
							waitMsg : '������...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "�޸ĳɹ�!");
									
									BatchReload(); 
									/*
									var rows=StockQtyGrid.getSelectionModel().getSelected() ; 
						            var Incil = rows.get("Incil");
						            var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),App_StkDateFormat);           
						            gStrParamBatch=Incil+"^"+Date;
						            var pageSize=StatuTabPagingToolbarBatch.pageSize;
						            BatchStore.setBaseParam("Params",gStrParamBatch);
						            BatchStore.load({params:{start:0,limit:pageSize}});
						            */

								} else {
										Msg.info("error", "�޸�ʧ��!\n"+jsonData.info);
								}
							},
							scope : this
						});
				loadMask.hide();
			}
        });
			var BatchGrid = new Ext.grid.GridPanel({
					id:'BatchGrid',
					cm : BatchCm,
					store : BatchStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					plugins:[ColumnNotUseFlag,ColumnStkNotUseFlag], 
					tbar:[NoUseBT],
					border:false,
					bbar : [StatuTabPagingToolbarBatch]					
			});
		
		function TransShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),App_StkDateFormat);
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+'         ��װ��λ��'+PurUom+'     ������λ��'+BUom;
				TransQuery(Incil, Date,IncInfo);								
			}
		}	
		function ClrResQtyAllShow(){		

         // �û��Ի�����һ���ص�����������:
                   Ext.Msg.show({
	                 title:'ȫԺ��;�����',
	                 msg:'ȷ�����ȫԺ��;����',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    ClrResQtyAll(); 
		                     }
                        
	                     }

	                 });

		}
		function ClrResQtyLocShow(){		
                  var phaLoc = Ext.getCmp("PhaLoc").getValue();
         // �û��Ի�����һ���ص�����������:
                   Ext.Msg.show({
	                 title:'������;�����',
	                 msg:'ȷ�����������;����',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    ClrResQtyLoc(phaLoc); 
		                     }
	                     }
	                 });

		}
	function ClrResQtyLocInciShow(){		
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var incil = selectedRow.get("Incil");  
         // �û��Ի�����һ���ص�����������:
                   Ext.Msg.show({
	                 title:'���ҵ�Ʒ��;�����',
	                 msg:'ȷ��������ҵ�Ʒ��;����',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    ClrResQtyLocInci(incil); 
		                     }
	                     }
	                 });
			}

		}
		function SynInciLocShow(){		
                  var phaLoc = Ext.getCmp("PhaLoc").getValue();
         // �û��Ի�����һ���ص�����������:
                   Ext.Msg.show({
	                 title:'���ҿ��ͬ��',
	                 msg:'ȷ��ͬ�����ҿ�棿',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    SynInciLoc(phaLoc); 
		                     }
	                     }
	                 });

		}
	function SynInciLocInciShow(){		
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var incil = selectedRow.get("Incil");  
         // �û��Ի�����һ���ص�����������:
                   Ext.Msg.show({
	                 title:'���ҵ�Ʒ���ͬ��',
	                 msg:'ȷ��ͬ�����ҵ�Ʒ��棿',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    SynInciLocInci(incil); 
		                     }
	                     }
	                 });
			}

		}		
		//���ȫԺ��;������ wyx 2013-11-12
		function ClrResQtyAll(){
		
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=ClrResQtyAll';
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						//params:{IngrNo:IngrNo,MainInfo:MainInfo,ListDetail:ListDetail},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
						
								Msg.info("success", "����ɹ�!");
								// ���¼�������
								searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "���ʧ��!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
		//���������;������ wyx 2013-11-12
		function ClrResQtyLoc(phaLoc){
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=ClrResQtyLoc';
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{PhaLoc:phaLoc},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "����ɹ�!");
								// ���¼�������
								searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "���ʧ��!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}	
		//������ҵ�Ʒ��;������ wyx 2013-11-12
		function ClrResQtyLocInci(incil){
		
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=ClrResQtyLocInci';
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Incil:incil},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "����ɹ�!");
								// ���¼�������
								searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "���ʧ��!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
		//ͬ�����ҿ�� wyx 2013-11-12
		function SynInciLoc(phaLoc){

		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=SynInciLoc';
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{PhaLoc:phaLoc},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "ͬ���ɹ�!");
								// ���¼�������
								//searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "ͬ��ʧ��!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}	
		//ͬ�����ҵ�Ʒ��� wyx 2013-11-12
		function SynInciLocInci(incil){
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=SynInciLocInci';
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Incil:incil},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "ͬ���ɹ�!");
								// ���¼�������
								//searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "ͬ��ʧ��!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
		//ȫԺ���ҿ��  hulihua
		function DayTotalShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+' ��װ��λ��'+PurUom+' ������λ��'+BUom;
				DayTotalQuery(Incil,IncInfo); 
			} 
		}
		
		//��;���ݲ�ѯ
		function ReserveQtyShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				ReserveQtyQuery(Incil,"","",""); 
			} 
		}
		/**
		 * ����Ҽ��˵�,zdm,2012-01-04***
		 */
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){
			grid.getSelectionModel().selectRow(rowindex);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); //��ȡ����
           
		}
		StockQtyGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuTrans', 
					handler: TransShow, 
					text: '̨����Ϣ',
					click:true,
					hidden:(gParam[0]=='Y'?false:true)
					 
				},{ 
					id: 'mnuClrResQtyAll', 
					handler: ClrResQtyAllShow, 
					text: 'ȫԺ��;�����',
					click:true,
					hidden:(gParam[1]=='Y'?false:true)
				},{ 
					id: 'mnuClrResQtyLoc', 
					handler: ClrResQtyLocShow, 
					text: '������;�����',
					click:true,
					hidden:(gParam[2]=='Y'?false:true)
				},{ 
					id: 'mnuClrResQtyLocInci', 
					handler: ClrResQtyLocInciShow, 
					text: '���ҵ�Ʒ��;�����',
					click:true,
					hidden:(gParam[3]=='Y'?false:true) 
				},{ 
					id: 'mnuSynInciLoc', 
					handler: SynInciLocShow, 
					text: '���ҿ��ͬ��',
					click:true,
					hidden:(gParam[4]=='Y'?false:true)
				},{ 
					id: 'mnumnuSynInciLocInci', 
					handler: SynInciLocInciShow, 
					text: '���ҵ�Ʒ���ͬ��',
					click:true,
					hidden:(gParam[5]=='Y'?false:true) 
				},{ 
					id: 'mnudayTotal', 
					handler: DayTotalShow, 
					text: 'ȫԺ���ҿ��',
					click:true,
					hidden:(gParam[6]=='Y'?false:true)
				},{ 
					id: 'mnuReserveQty', 
					handler: ReserveQtyShow, 
					text: '��;����ѯ',
					click:true,
					hidden:false
				}
			
			] 
		}); 

		//�Ҽ��˵�����ؼ����� 
		function DirtyQtyShow() {
			var gridSelected =Ext.getCmp("BatchGrid"); 
			var rows=BatchGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ���Σ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Inclb = selectedRow.get("Inclb");
				var rowsInc=StockQtyGrid.getSelectionModel().getSelections() ; 
				var selectedInc = rowsInc[0];
				var IncDesc=selectedInc.get("InciDesc");
				var PurUom=selectedInc.get("PurUomDesc");
				var BUom=selectedInc.get("BUomDesc");
				var IncInfo=IncDesc+'         ��װ��λ��'+PurUom+'     ������λ��'+BUom;
				DirtyQtyQuery(Inclb,IncInfo,ReloadBatchGrid);							
			}
		}
			//����׷����Ϣ  hulihua 2016-01-10
		function BatTransShow() {
			var gridSelected =Ext.getCmp("BatchGrid"); 
			var rows=BatchGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ׷�ٵ�ҩƷ���Σ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),App_StkDateFormat);
				var Inclb = selectedRow.get("Inclb");
				var BatNo=selectedRow.get("BatNo");
				var ExpDate=selectedRow.get("ExpDate");
				var PVenDesc=selectedRow.get("PVenDesc");
				var PManf=selectedRow.get("PManf");
				var rowsInc=StockQtyGrid.getSelectionModel().getSelections() ; 
				var selectedInc = rowsInc[0];
				var IncDesc=selectedInc.get("InciDesc");
				var PurUom=selectedInc.get("PurUomDesc");
				var BUom=selectedInc.get("BUomDesc");
				var InclbInfo='<p>'+IncDesc+'�����ţ�'+BatNo+' Ч�ڣ�'+ExpDate+'����װ��λ��'+PurUom+'��������λ��'+BUom+'</p>'+'���ι�Ӧ�̣�'+PVenDesc+'�����γ��̣�'+PManf;
				BatTransQuery(Inclb,Date,InclbInfo);							
			}
		}
		function ReloadBatchGrid()
		{
			BatchStore.reload()
		
		}
		function rightClickDirtyQtyFn(grid,rowindex,e){
			grid.getSelectionModel().selectRow(rowindex);
			e.preventDefault(); 
			rightClickDirtyQty.showAt(e.getXY()); 
		}
		BatchGrid.addListener('rowcontextmenu', rightClickDirtyQtyFn);//�Ҽ��˵�����ؼ����� 
		var rightClickDirtyQty = new Ext.menu.Menu({ 
			id:'rightClickDirtyQty', 
			items: [ 
				{ 
					id: 'mnuDirtyQty', 
					handler: DirtyQtyShow, 
					text: '�鿴ռ�õ���' 
				},{ 
					id: 'mnuBatTrans', 
					handler: BatTransShow, 
					text: '����̨����Ϣ'
				}
			] 
		}); 
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 80,
			id:'HisListTab',
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', RefreshBT, '-', SaveAsBT],			   						
			items : [{
						title:'��ѡ����',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[PhaLoc,DateTime,StkGrpType,Type]
					},InciDesc,INFOImportFlag,DHCStkCatGroup,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},ARCItemCat,PHCDFPhcDoDR,PhManufacturer,PHCForm,ArcStat,
				ManageDrug,UseFlag,NotUseFlag,//StoNoZeroFlag,
					{
						title:'��������',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[incilIfNotZero,incilStkActive,incilArcActive]
					}
					
			]		   	
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
                			border:true,
			                title: '����ѯ',
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab
			               
			            }, {             
			                region: 'center',
			                boder:false,	
			                layout:'border',
			                items:[{
			                	region:'center',
			                	title: '�����Ϣ',
			                	layout: 'fit', // specify layout manager for items
			                	items: StockQtyGrid    
			                },{
			                	region:'south',
			                	title:'������Ϣ',
			                	split:true,
			                	height:300,
			                	minSize:100,
			                	maxSize:400,
			                	collapsible:true,
			                	layout:'fit',
			                	items:BatchGrid			                
			                }]             	
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				RefreshGridColSet(StockQtyGrid,"DHCSTLOCITMSTK");
				//ReserveQtyQuery("308||1","","","");  
				
	}
/*��ѯʱ�������RawValueΪ������valueΪ��*/
function setNormalValue(formId)
{
	if (formId=="") return;
	Ext.getCmp(formId).getForm().items.each(function(f){ 
		if ((f.getRawValue()=="")||(f.getRawValue()==null)||(f.getRawValue()=="undefined")){
			f.setValue("");	
			f.setRawValue("");		
		}		
	});
}	
})