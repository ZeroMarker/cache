Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIncid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var today=new Date();
	var growid=""
	var activeTabtmp=""
       Ext.Ajax.timeout = 900000;
     var StMonthField = new Ext.ux.DateField({
			    fieldLabel : '�·�',
			    id : 'StMonthField',
			    name : 'StMonthField',
			    anchor : '90%',
			    format : 'Y-m-d',
			    value : new Date()
				});

   var FindButton = new Ext.Button({
             width : 30,
             height : 5,
             id:"FindButton",
             labelStyle: 'font-weight:bold;',

             text: 'ͳ��',
			 tooltip:'ͳ�Ƹ��ⷿ���±�����',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{   
                          "click":function(){   
                             
                              FindData();
                              
                              }   
                       } 
             
             })
             
 		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_refresh',
					width : 70,
					height : 30,
					handler : function() {
					 var p = Ext.getCmp("TblTabPanel").getActiveTab();
	                             var iframe = p.el.dom.getElementsByTagName("iframe")[0];
					iframe.src="../scripts/dhcmed/img/logon_bg2.jpg"	
					}
				});
var StYear=new Ext.form.TextField({
		fieldLabel:'�·�',
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:120,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:120,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
   ///Tabs����
    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    margins:'3 3 3 0',
	    border :true,
	    bodyBorder: false, 
	    activeTab: 0,
	    items:[{
	        title: '�����б�',
	        id:'list',    
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% src="../scripts/dhcmed/img/logon_bg2.jpg" ></iframe>'
	
	    }
	    
	    ],
	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                                          
                                    } 
                                
                      } 
	    
	    
	});


       var QueryForm=new Ext.FormPanel({
		labelWidth : 80,
		region : 'north',
		title:'�±�����ͳ��',
		frame : true,
		height:10,
		tbar:new Ext.Toolbar({items:[FindButton,{xtype:'tbtext',text:'�±�ѡ��:'},StYear,{xtype:'tbtext',text:'��'},StMonth,{xtype:'tbtext',text:'��'},RefreshBT]})

	       })
	       
	       
 ///��ܶ���
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,QueryTabs]

			});
	
	
	
	//��ѯ����
function FindData()
 {    
        GetStrParam();
        var stYear=Ext.getCmp('StYear').getValue();
	 var stMonth=Ext.getCmp('StMonth').getValue();
	 
	 var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 var iframe = p.el.dom.getElementsByTagName("iframe")[0];
        iframe.src="../scripts/dhcmed/img/logon_bg2.jpg"
        iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_ReportAllLocSum_Common.raq&month='+StrParam+'&stYear='+stYear+'&stMonth='+stMonth ;	
            
	

 }
 
///��ȡ����
function GetStrParam()
 {
	 
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	//var month=Ext.getCmp("StMonthField").getRawValue();       
        var month=stYear+'-'+stMonth+'-'+'01';
	 StrParam=month;
 }
	
})