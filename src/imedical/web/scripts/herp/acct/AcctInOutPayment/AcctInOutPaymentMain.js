/// ����:��ĩ����-��֧��ת
/// ��д�ߣ�������
/// ��д���ڣ�2015-12-29

Ext.onReady(function(){
	
	Ext.QuickTips.init();

    
    var formPanel2 = new Ext.form.FormPanel({
   		id : 'formPanel2',
		frame : true,
		//autoScroll : true,
		
		items :[{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items:[{
            	xtype : 'displayfield',
            	style:'line-height: 20px;',
				value : ' &nbsp;&nbsp;����ڼ�:&nbsp;&nbsp; '
				//columnWidth : .15
            },periodDate,{
            	xtype:'displayfield',
            	value:'',
            	width:8
       		},{
            	xtype : 'displayfield',
            	style:'line-height: 20px;',
				value : ' &nbsp;&nbsp;��֧ƾ֤ģ��&nbsp;&nbsp; '
				//columnWidth : .15
            },acctTemplet,{
            	xtype : 'displayfield',
				value : ' &nbsp;&nbsp;&nbsp;&nbsp; '
				//columnWidth : .15
            },inOutPaymentEnd,{
            	xtype : 'displayfield',
				value : ' &nbsp;&nbsp;&nbsp;&nbsp; '
				//columnWidth : .15
            },acctBuild,{
            	xtype : 'displayfield',
				value : ' &nbsp;&nbsp;&nbsp;&nbsp; '
				//columnWidth : .15
            },buttQuery
	      	]
		}],
		itemCls:"float:center"
    });
	var reportPanel=new Ext.Panel({
		//autoScroll:true,
		layout:'fit',
		//autoScroll:false, 
		html:'<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'
		
	});
	
    //============================�鿴=========================================//
    var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			iconCls:'maintain',
			region:'north',
			title:'��֧��ת',						
			height:70,
			// split:true,
			// collapsible:true,
			layout:'fit',
			items:formPanel2
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
    
    });


});