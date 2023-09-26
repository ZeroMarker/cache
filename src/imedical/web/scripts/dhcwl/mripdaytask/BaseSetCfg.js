(function(){
	Ext.ns("dhcwl.mripdaytask.BaseSetCfg");
})();
///描述: 		基本配置界面
///编写者：		陈乙
///编写日期: 	2015-02-13
dhcwl.mripdaytask.BaseSetCfg=function(){
    var baseSetCfgPanel =new Ext.FormPanel({
    	labelWidth: 15, // label settings here cascade unless overridden
        frame:true,
        title: '基本设置',
        items: [{
	        xtype:'fieldset',
            width:410,
            //collapsible: true,   //收缩展开设置
            autoHeight:true,
            //设置无边框
            style:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: #000000 0px solid;',
	        items:[{
            	xtype:'fieldset',
            	title: '停任务条件',
            	width:380,
            	//collapsible: true,
            	autoHeight:true,
            	defaults: {width: 150},
            	defaultType: 'checkbox',
            	items :[{
                    boxLabel: '科室停任务',
                    //checked:true,  //默认值:在InitBaseSet取到的后台数据过程中设置
                    name: 'locFlag'
                	},{
                    boxLabel: '病区停任务',
                    //checked:true,  //默认值:在InitBaseSet取到的后台数据过程中设置
                    name: 'wardFlag'
                	}
            		]
            	},
        		{
            	xtype:'fieldset',
            	title: '出院时间选择',
            	width:380, 
            	//collapsible: true,
            	autoHeight:true,
            	defaults: {width: 150},
            	defaultType: 'radio',
            	items :[/*docDate,nurseDate*/
            		{
                    boxLabel: '医生医疗结算',
                    inputValue:1,
                    id:'docDate',
                    name:'disDateChoose'
                	},{
                    boxLabel: '护士最终结算',
                    //checked:true,  //默认值:在InitBaseSet取到的后台数据过程中设置
                    inputValue:2,
                    id:'nurseDate',
                    name:'disDateChoose'
                	}
            	]
        	},
        	{ 
        		buttonAlign: 'center',//居中
        		buttons: [{
            		text: '<span style="line-Height:1">保存</span>',		
            		icon: '../images/uiimages/filesave.png',
            		handler: function(){
            			var locFlag=baseSetCfgPanel.getForm().findField('locFlag').getValue();
            			var wardFlag=baseSetCfgPanel.getForm().findField('wardFlag').getValue();
            			var disDateChoose=baseSetCfgPanel.getForm().findField('disDateChoose').getValue();  //第一个为true，第二个为false
            			var paraValues=locFlag+'-'+wardFlag+'-'+disDateChoose
            			dhcwl.mkpi.Util.ajaxExc('dhcwl/mripdaytask/mripdaytaskbaseset.csp?action=baseSetSave',{paraValues:paraValues});
            		}
        		}]
        	}]
        }],
        listeners:{
        	'afterrender':function(th){
				InitBaseSet('dhcwl/mripdaytask/mripdaytaskbaseset.csp?action=baseSetInit');
        	}
        }
        	
    
    });
    
    	// 初始化
	//this.InitBaseSet = function(url) {
    function InitBaseSet(url) {
		Ext.Ajax.request({
					url : encodeURI(url),
					waitMsg : '正在处理...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '网络连接失败！',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData, tip;
						jsonData = Ext.util.JSON.decode(result.responseText);
						//alert(result.responseText);
						var depStopFlag=jsonData.depStopFlag;
						var wardStopFlag=jsonData.wardStopFlag;
						var disDateType=jsonData.disDateType;
						if (depStopFlag=='Y'){
							baseSetCfgPanel.getForm().findField('locFlag').setValue(true);
						}
						else{
						 	baseSetCfgPanel.getForm().findField('locFlag').setValue(false);
						}
						if (wardStopFlag=='Y'){
							baseSetCfgPanel.getForm().findField('wardFlag').setValue(true);
						}
						else{
						 	baseSetCfgPanel.getForm().findField('wardFlag').setValue(false);
						}
						//baseSetCfgPanel.getForm().findField('docDate').setValue(true);
						if (disDateType=='DOC'){
							baseSetCfgPanel.getForm().findField('docDate').setValue(true);
						}
						else{
						 	baseSetCfgPanel.getForm().findField('nurseDate').setValue(true);
						}
						//return;
					}
		})
	}
    this.getBaseSetCfgPanel=function(){
    	return baseSetCfgPanel;
    }   

}

