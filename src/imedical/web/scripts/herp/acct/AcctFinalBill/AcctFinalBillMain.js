/// 描述:期末处理-期末结账
/// 编写者：初雅莉
/// 编写日期：2016-01-04

Ext.onReady(function(){
	
	Ext.QuickTips.init();

    
    var formPanel1 = new Ext.form.FormPanel({
   		id : 'formPanel1',
		frame : true,
		//autoScroll : true,
		
		items :[{
			//columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items:[{
            	xtype : 'displayfield',
				value : ' &nbsp;&nbsp;会计期间:&nbsp;&nbsp; ',
				style : 'padding-top:3px;'
            },periodDate,{
            	xtype : 'displayfield',
				value : ' &nbsp;&nbsp;&nbsp;&nbsp; '
				//columnWidth : .15
            },settleAccountsBtn,{
            	xtype : 'displayfield',
				value : ' &nbsp;&nbsp;&nbsp;&nbsp; '
				//columnWidth : .15
            },counterSettlingAccountsBtn
            /*,{
	            
	            xtype: 'radiogroup',
            fieldLabel: 'Auto Layout',
             itemCls: 'x-check-group-alt',
            items: [
                {boxLabel: '&nbsp;Item 1', name: 'rb-auto', inputValue: 1},
                {boxLabel: 'Item 2', name: 'rb-auto', inputValue: 2, checked: true},
                {boxLabel: 'Item 3', name: 'rb-auto', inputValue: 3},
                
            ]
	        	            }*/
	      	]
		}]
		//itemCls:"float:center"
    });
    //
  // var lala=$(".x-form-cb-label");
   // console.log(lala);
	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		//autoScroll:false, 
		html:'<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'
		
	});
	
    //============================查看=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			region:'north',
			layout:'fit',
			title:'期末结账',	
			iconCls:'finalbill',			
			height:70,
			//split:true,
			//collapsible:true,
			//layout:'fit',
			items:formPanel1
		},
		{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
    
    });


});