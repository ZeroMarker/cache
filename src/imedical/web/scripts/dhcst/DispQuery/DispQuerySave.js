// /����: �ۺϲ�ѯͳ��
// /����: �ۺϲ�ѯͳ��
// /DispQuerySave.js
// /��д�ߣ�wyx
// /��д����: 2014.05.26
var gNewCatId=""
Ext.onReady(function() {

	Ext.QuickTips.init();//���ڸ�����ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL; //ͼƬ����·��
	var gIncId='';
	var StrParam="";
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
           var DispLoc = new Ext.ux.DispLocComboBox({
					fieldLabel : '��ҩ����',
					id : 'DispLoc',
					name : 'DispLoc',
					anchor : '90%'
				});
	//����
	var LocWard=new Ext.ux.LocWardComboBox({
		id : 'LocWard',
		name : 'LocWard',
		anchor:'90%'
	});

	var DateFrom = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		format : 'Y-m-d',
		value :DefaultStDate()
	});
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>��ʼʱ��</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120
	});	
	var DateTo = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		format : 'Y-m-d',
		value : DefaultEdDate()
	});
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>��ֹʱ��</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120
	});
	//��ҩ���
	var DispType=new Ext.ux.DispTypeComboBox({
		id : 'DispType',
		name : 'DispType',
		anchor:'90%'
	});
	var InciDesc = new Ext.form.TextField({
					fieldLabel : 'ҩƷ����',
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								//var stkgrp=Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(),'');
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
           //ִ�п���
           var ExeLoc = new Ext.ux.ExeLocComboBox({
					fieldLabel : '�������',
					id : 'ExeLoc',
					name : 'ExeLoc',
					anchor : '90%'
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
var PHCCATALL = new Ext.form.TextField({
	fieldLabel : 'ҩѧ����',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	anchor : '90%',
	readOnly : true,
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
	text : 'ҩѧ����ά��',
	handler : function() {	
       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    
     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
     
	var phacstr=retstr.split("^")
	GetAllCatNew(phacstr[0],phacstr[1])

    }
});	
				
						
		//ҽ������
		var DocLoc = new Ext.ux.ComboBox({
					fieldLabel : 'ҽ������',
					id : 'DocLoc',
					name : 'DocLoc',			
					store : DocLocStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{FroLoc:'DispLoc'}
				});		
		//��ҩ��
		var LocDispUser = new Ext.ux.ComboBox({
					fieldLabel : '��ҩ��',
					id : 'LocDispUser',
					name : 'LocDispUser',			
					store : LocDispUserStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{FroLoc:'DispLoc'}
				});		
				
		var RetFlag = new Ext.form.Checkbox({
					fieldLabel : '������ҩ',
					id : 'RetFlag',
					name : 'RetFlag',
					anchor : '90%',				
					height : 10,
					checked : false
				});


		var DocFlag = new Ext.form.Checkbox({
					fieldLabel : '��ҽ������',
					id : 'DocFlag',
					name : 'DocFlag',
					anchor : '90%',					
					height : 10,
					checked : false
				});				
				
				
				
				
				
				
				
				
				
				
				
				
							
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : 'ͳ��',
					tooltip : '���ͳ��',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});
						// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_refresh',
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
			StrParam='';
			gStrParam='';
			Ext.getCmp("DispLoc").setValue('');
			Ext.getCmp("LocWard").setValue('');  
			Ext.getCmp("DateFrom").setValue(new Date());
			Ext.getCmp("DateTo").setValue(new Date());
			Ext.getCmp("StartTime").setValue(''); 
			Ext.getCmp("EndTime").setValue(''); 
			Ext.getCmp("DispType").setValue('');
			Ext.getCmp("InciDesc").setValue('');
			Ext.getCmp("ExeLoc").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("DocLoc").setValue('');
			Ext.getCmp("LocDispUser").setValue('');
			Ext.getCmp("PHCCATALL").setValue("");
			gNewCatId=""
			
		}
				
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT,'-','-','-','-','-','-',RefreshBT],			   						
			items : [{
						title:'ѡ������',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[DispLoc,LocWard,DateFrom,StartTime,DateTo,EndTime,DispType,InciDesc,ExeLoc,PhcCat,DocLoc,LocDispUser]
						
					}, RetFlag,DocFlag
			]		  	
		});
//��ѯ����
function searchData()
 {

	 var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 var iframe = p.el.dom.getElementsByTagName("iframe")[0];
        var dispLoc = Ext.getCmp("DispLoc").getValue();
	 if (dispLoc ==""||dispLoc == null || dispLoc.length <= 0){
				Msg.info("warning", "��ҩ���Ҳ���Ϊ�գ�");
				Ext.getCmp("DispLoc").focus();
				return;
			}
        GetStrParam();
         iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispQuerySave_INCI_Common.raq&StrParam='+StrParam;	

 }		
					
///Tabs����
    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    margins:'3 3 3 0', 
	    activeTab: 0,
	    items:[{
	        title: '����',
	        id:'list',    
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
	           }
                ],
	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                     } 
                                
               } 
	    
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
			                title: '��ҩͳ��',
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab       
			               
			            }, {             
			                region: 'center',	
			                layout:'border',
			                items:[{
			                	region:'center',
			                	layout: 'fit', // specify layout manager for items
			                	items: QueryTabs    
			                }]             	
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				///��ȡ����
function GetStrParam()
 {
	 var sDate=Ext.getCmp("DateFrom").getRawValue();       
        var eDate=Ext.getCmp("DateTo").getRawValue();
        
        var sTime=Ext.getCmp("StartTime").getRawValue();
        var eTime=Ext.getCmp("EndTime").getRawValue();
        var dispLoc = Ext.getCmp("DispLoc").getValue();
	 var locWard = Ext.getCmp("LocWard").getValue();
	 var locDispUser = Ext.getCmp("LocDispUser").getValue();
	 var dispType = Ext.getCmp("DispType").getValue();
	 var phcCat = Ext.getCmp("PhcCat").getValue();
	 var phcCatDesc = Ext.getCmp("PhcCat").getRawValue();
	 var inci = Ext.getCmp("InciDesc").getValue();
	 var inciDesc=Ext.getCmp("InciDesc").getRawValue();
	 var exeLoc = Ext.getCmp("ExeLoc").getValue();
	 var outflag="N"
	 if (dispType=="OUT") {outflag="Y";}
	 var docFlag = Ext.getCmp("DocFlag").getValue();
	 var docLoc = Ext.getCmp("DocLoc").getValue();
	 var retFlag = Ext.getCmp("RetFlag").getValue();

	 if(InciDesc==null || InciDesc==""){
		gIncId="";
	 }
///	  StrParam=��ʼ����^��������^��ҩ����^����^��ҩ��^��ҩ���^ҩѧ����^ҩƷ����^�������^
///       ��Ժ��ҩ���^��ҽ�����ұ��^��ʼʱ��^����ʱ��^ҽ������^������ҩ���
	 StrParam= sDate+"^"+eDate+"^"+dispLoc+"^"+locWard+"^"+locDispUser+"^"+dispType+"^"+phcCat+"^"+inci+"^"+exeLoc+"^"+outflag+"^"+docFlag+"^"+sTime+"^"+eTime+"^"+docLoc+"^"+retFlag+"^"+gNewCatId ;
 }		
	
})