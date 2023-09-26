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
			    fieldLabel : '月份',
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

             text: '统计',
			 tooltip:'统计各库房的月报汇总',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{   
                          "click":function(){   
                             
                              FindData();
                              
                              }   
                       } 
             
             })
             
 		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
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
		fieldLabel:'月份',
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
   ///Tabs定义
    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    margins:'3 3 3 0',
	    border :true,
	    bodyBorder: false, 
	    activeTab: 0,
	    items:[{
	        title: '汇总列表',
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
		title:'月报汇总统计',
		frame : true,
		height:10,
		tbar:new Ext.Toolbar({items:[FindButton,{xtype:'tbtext',text:'月报选择:'},StYear,{xtype:'tbtext',text:'年'},StMonth,{xtype:'tbtext',text:'月'},RefreshBT]})

	       })
	       
	       
 ///框架定义
    

      var port = new Ext.Viewport({

				layout : 'border',

				items : [QueryForm,QueryTabs]

			});
	
	
	
	//查询数据
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
 
///获取参数
function GetStrParam()
 {
	 
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	//var month=Ext.getCmp("StMonthField").getRawValue();       
        var month=stYear+'-'+stMonth+'-'+'01';
	 StrParam=month;
 }
	
})