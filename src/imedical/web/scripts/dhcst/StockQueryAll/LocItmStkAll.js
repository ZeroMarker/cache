// /����: ȫԺ����ѯ����¼��
// /����:  ȫԺ����ѯ����¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.01.17
var gNewCatId="";
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME']

     
	ChartInfoAddFun();
    function ChartInfoAddFun() {
    /*		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : 'ҩ��',
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor : '90%',
					groupId:gGroupId
				});*/

		var DateTime = new Ext.ux.DateField({
					fieldLabel : $g('����'),
					id : 'DateTime',
					name : 'DateTime',
					anchor : '90%',
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
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
					data : [['0', $g('ȫ��')], ['1', $g('���Ϊ��')], ['2', $g('���Ϊ��')],
							['3', $g('���Ϊ��')]]
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : $g('����'),
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

		var InciDesc = new Ext.form.TextField({
					fieldLabel : $g('ҩƷ����'),
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 140,
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
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
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
			;
			Ext.getCmp("InciDesc").setValue(inciDesc);
			//Ext.getCmp('InciDr').setValue(inciDr);			
			;			
		}

		var ImportStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [[$g('����'), $g('����')], [$g('����'), $g('����')], [$g('����'), $g('����')]]
				});
		var INFOImportFlag = new Ext.form.ComboBox({
					fieldLabel : $g('���ڱ�־'),
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
					fieldLabel : $g('������'),
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});
				
		// ҩѧ����
		var PhcCat = new Ext.ux.ComboBox({
					fieldLabel : $g('ҩѧ����'),
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
					fieldLabel : $g('ҩѧ����'),
					id : 'PhcSubCat',
					name : 'PhcSubCat',			
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcCatId:'PhcCat'}
				});

		// ҩѧС��
		var PhcMinCat = new Ext.ux.ComboBox({
					fieldLabel : $g('ҩѧС��'),
					id : 'PhcMinCat',
					name : 'PhcMinCat',		
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcSubCatId:'PhcSubCat'}
				});
var PHCCATALL = new Ext.form.TextField({
	fieldLabel : $g('ҩѧ����'),
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : '',
	width:115
});

function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}
var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : $g('ҩѧ����'),
	handler : function() {	
		PhcCatNewSelect(gNewCatId,GetAllCatNew)
    }
});

		var ARCItemCat = new Ext.ux.ComboBox({
					fieldLabel : $g('ҽ������'),
					id : 'ARCItemCat',
					name : 'ARCItemCat',
					store : ArcItemCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'Desc'
				});

		var PHCDFPhcDoDR = new Ext.ux.ComboBox({
					fieldLabel : $g('���Ʒ���'),
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var PhManufacturer = new Ext.ux.ComboBox({
					fieldLabel : $g('������ҵ'),
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHMNFName'
				});

		var PHCDOfficialType = new Ext.ux.ComboBox({
					fieldLabel : $g('ҽ�����'),
					id : 'PHCDOfficialType',
					name : 'PHCDOfficialType',
					store : OfficeCodeStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var PHCForm = new Ext.ux.ComboBox({
					fieldLabel : $g('����'),
					id : 'PHCForm',
					name : 'PHCForm',			
					store : PhcFormStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHCFDesc'
				});		

		var ManageDrug = new Ext.form.Checkbox({
					fieldLabel : $g('����ҩ'),
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',				
					height : 10,
					checked : false
				});


		var UseFlag = new Ext.form.Checkbox({
					fieldLabel :$g( '������Ʒ��'),
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					fieldLabel :$g( '��������Ʒ��'),
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
				});
		var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%'
			
		});

		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('��ѯ'),
					tooltip : $g('�����ѯ'),
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						ShowReport();
					}
				});

       function ShowReport(){
			var date = Ext.getCmp("DateTime").getValue().format(App_StkDateFormat)
					.toString();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StockType = Ext.getCmp("Type").getValue();
			if (date == null || date.length <= 0) {
				Msg.info("warning", $g("���ڲ���Ϊ�գ�"));
				Ext.getCmp("DateTime").focus();
				return;
			}
			if (StockType == null || StockType.length <= 0) {
				Msg.info("warning", $g("���Ͳ���Ϊ�գ�"));
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
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			//var vendor=Ext.getCmp("Vendor").getValue();
			var strParam=date+"^"+StkGrpRowId+"^"+StockType+"^"+gIncId
			+"^"+ImpFlag+"^"+DHCStkCatGroup+"^"+PhcCat+"^"+PhcSubCat+"^"+PhcMinCat
			+"^"+ARCItemCat+"^"+PHCDFPhcDoDR+"^"+PhManufacturer+"^"+PHCDOfficialType
			+"^"+PHCForm+"^"+ManageDrug+"^"+UseFlag+"^"+NotUseFlag+"^"+gNewCatId; 
			
			var inciRadioFlag=Ext.getCmp("InciRadio").getValue();
			var batRadioFlag=Ext.getCmp("BatRadio").getValue();
			var p_URL="";
			if(inciRadioFlag == true) {
				var reportframe=document.getElementById("reportFrame")      
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_LocItmStkAll_Common.raq&StrParam='+strParam+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc;
				reportframe.src=p_URL;
			}else if(batRadioFlag == true){
				var reportframe=document.getElementById("reportFrame")      
				p_URL = 'dhccpmrunqianreport.csp?reportName=PHAIN_AllBatStock.rpx&inputStr='+strParam+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc;
				//console.log("p_URL:"+p_URL)
				reportframe.src=p_URL;
			}
	    }
	       
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('����'),
					tooltip : $g('�������'),
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
			//SetLogInDept(PhaLoc.getStore(),"PhaLoc");
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
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("INFOImportFlag").setValue('');
			gIncId="";
			Ext.getCmp("PHCCATALL").setValue("");
			gNewCatId=""
			Ext.getCmp("Vendor").setValue("");
			document.getElementById("reportFrame").src=BlankBackGroundImg;
			//StockQtyGrid.store.removeAll();
			//StockQtyGrid.getView().refresh();
			//BatchGrid.store.removeAll();
		}	
		var InciRadio = new Ext.form.Radio({
					boxLabel : '��ҩƷ',
					id : 'InciRadio',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});
		var BatRadio = new Ext.form.Radio({
				boxLabel : '������',
				id : 'BatRadio',
				name : 'ReportType',
				anchor : '80%'
			});
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', RefreshBT],			   						
			items : [{
						title:$g('��ѡ����'),
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[DateTime,StkGrpType,Type]
					},InciDesc,INFOImportFlag,DHCStkCatGroup,
				 {xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},ARCItemCat,PHCDFPhcDoDR,PhManufacturer,PHCForm,
				ManageDrug,UseFlag,NotUseFlag,InciRadio,BatRadio
			]		   	
		});
	var reportPanel=new Ext.Panel({
		//autoScroll:true,
		layout:'fit',
		html:'<iframe id="reportFrame" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'
	})
		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 300,
                			minSize: 250,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('ȫԺ����ѯ'),
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab       
			               
			            },{
						region:'center',
						layout:'fit',
						items:reportPanel
					}
	       			],
					renderTo : 'mainPanel'
				});
	}
})