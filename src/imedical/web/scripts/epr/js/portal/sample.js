/*
 * Ext JS Library 2.0
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

Ext.onReady(function(){

    //protal上的按钮
    var tools = [
    //{
       // id:'gear',
        //handler: function(){
           // Ext.Msg.alert('Message', 'The Settings tool was clicked.');
       // }
   // },
    {
        id:'close',
        handler: function(e, target, panel){
            //panel.ownerCt.remove(panel, true);
            panel.setVisible(false);
            var id = panel.id;
            var menuID = 'menu_' + id.substring(id.length - 1);
            Ext.getCmp(menuID).setChecked(false);
            
        }
    }];
    
    //创建protal的方法
    function createPortal(id, title, html)
    {
		var panel = Ext.getCmp(id);
		if(!panel)
		{
			panel = new Ext.Panel({
				id: id,
				title : title,
				animCollapse: true,
				html : html,
				//autoLoad : {url: html, scripts: true},
				anchor : '100%',
				frame : true,
				height: 250,
				collapsible : true,
				collapsed : true,
				draggable : true,
				tools : tools,
				autoScroll: false,
				cls : 'x-portlet'
			});
		}
		panel.on('collapse', function(p){
			p.getEl().setHeight(0);
		});
		return panel;
    }

    var iframeCommonTemplate = '<iframe id="frameCommonTemplate" width=100% height=100% frameborder=0 framespacing=0 src="epr.newfw.commontemplate.csp?episodeID=' + episodeID + '&patientID=' + patientID + '"></iframe>';	//常用模板的iframe
    var iframeRecentTemplate = '<iframe id="frameRecentTemplate" width=100% height=100% frameborder=0 framespacing=0 src="epr.newfw.recenttemplate.csp?episodeID=' + episodeID + '&patientID=' + patientID + '"></iframe>';	//常用模板的iframe
    var panel_1 = createPortal('panel_1', '质控列表', '<iframe id="iframe_1" style="width:100%; height:100%" src="epr.newfw.qualityreport.csp?EpisodeID=' + episodeID + '&patientID=' + patientID + '"></iframe>');
    //var panel_2 = createPortal('panel_2', '常用模板', '<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0"><tr><td width="50%" height="100%">'+ iframeCommonTemplate +'</td><td id="tdRecentTemplate" width="50%">' + iframeRecentTemplate + '</td></tr></table>');
    //var panel_2 = createPortal('panel_2', '常用模板', '<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0"><tr><td width="99%" height="190px">'+ iframeCommonTemplate +'</td></tr><tr><td id="tdRecentTemplate" width="99%" height="100%">' + iframeRecentTemplate + '</td></tr></table>');
    
    //edit by loo on 2010-8-24
    //bug #1084,要求拆分常用模板，将常用病历和最近操作历史记录拆分成两个Portal
    var panel_2 = createPortal('panel_2', '常用病历', iframeCommonTemplate);
    var panel_3 = createPortal('panel_3', '最近操作历史记录', iframeRecentTemplate);
    
    var panel_4 = createPortal('panel_4', '使用说明', '<iframe width=100% frameborder=0 framespacing=0 height=100% src="epr.newfw.showhelp.csp"></iframe>');
    
    //add by loo on 2010-9-8
    //新增质控信息列表,新增了panel_5和menu_5
    var panel_5 = createPortal('panel_5', '质控消息列表', '<iframe width=100% frameborder=0 framespacing=0 height=100% src="epr.newfw.qualitymessagelist.csp?episodeID='+ episodeID + '"></iframe>');
    
    //add by loo on 2010-9-30
    //新增了终末质控评价列表,新增了panel_6和menu_6
    var panel_6 = createPortal('panel_6', '终末质控评价', '<iframe width=100% height=100% src="epr.newfw.qualityfinalreport.csp?episodeID='+episodeID+'"></iframe>');
    //var panel_7 = createPortal('google6', 'google6', '<iframe width=100% height=100% src="http://www.baidu.cn"></iframe>');
    
	
	//menu的checkItem的checkchange事件,用来设置panel是否可见
	function setPanelVisiable(panel, isShow)
	{
		panel.setVisible(isShow);
	}
	
	//保存状态
	function saveState()
	{
		var configCol = '';		//配置每列的包含的panel
    	var configPenalProperty = '';		//配置panel的属性

		var portal = Ext.getCmp('portal');
		var arrAllCol = portal.getAllCol();		//所有的列

		for(var i = 0; i < arrAllCol.length; i++)
		{
			//配置configCol
			configCol += arrAllCol[i].id;
			var arrColAllPanel = portal.getColAllPanel(arrAllCol[i]);
			for(var j = 0; j < arrColAllPanel.length; j++)
			{
				var panelTmp = arrColAllPanel[j];
				//配置configCol
				configCol += "^";
				configCol += panelTmp.id;
				
				//配置configPenalProperty
				configPenalProperty += panelTmp.id;
				configPenalProperty += '^';
				configPenalProperty += 'menu_';
				var lastIndex = panelTmp.id.lastIndexOf('_');
				configPenalProperty += panelTmp.id.substring(lastIndex + 1);
				configPenalProperty += '^';
				configPenalProperty += panelTmp.isVisible();
				configPenalProperty += '^';
				configPenalProperty += panelTmp.getSize().height;
				configPenalProperty += '#';
			}
			configCol += "#";			
		}
		configCol = configCol.substring(0, configCol.length - 1);		//去掉最后的#
		configPenalProperty = configPenalProperty.substring(0, configPenalProperty.length - 1);		//去掉最后的#

		setCookie(configColName, configCol);
		setCookie(configPenalPropertyName, configPenalProperty);
		
	}
    
    //界面最上的tbar
    function getTBar()
	{
		var  tbar = new Ext.Toolbar({ border: false, items:['->','-',
			{text:"菜单", triggerAction : 'all', id: 'menuPanels',
			menu:[
                { id: 'menu_1', text: panel_1.title, checked: false, hideOnClick: false, listeners : { 'checkchange' : function(checkItem, checked) { setPanelVisiable(panel_1, checked);}} }, 
                { id: 'menu_2', text: panel_2.title, checked: false, hideOnClick: false, listeners : { 'checkchange' : function(checkItem, checked) { setPanelVisiable(panel_2, checked);}} }, 
                
                //edit by loo on 2010-8-24
                //bug #1084,要求拆分常用模板，将常用病历和最近操作历史记录拆分成两个Portal
                //如果要显示最近操作记录,直接取消下一句的屏蔽
                //{ id: 'menu_3', text: panel_3.title, checked: false, hideOnClick: false, listeners : { 'checkchange' : function(checkItem, checked) { setPanelVisiable(panel_3, checked);}} },
                { id: 'menu_4', text: panel_4.title, checked: false, hideOnClick: false, listeners : { 'checkchange' : function(checkItem, checked) { setPanelVisiable(panel_4, checked);}} },
                
                { id: 'menu_5', text: panel_5.title, checked: true, hideOnClick: false, listeners : { 'checkchange' : function(checkItem, checked) { setPanelVisiable(panel_5, checked);}} },
                { id: 'menu_6', text: panel_6.title, checked: true, hideOnClick: false, listeners : { 'checkchange' : function(checkItem, checked) { setPanelVisiable(panel_6, checked);}} } 
			]},
			{id:'btnSave',text:'保存布局', cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/save.gif',pressed:false,listeners:{'click': function(){  saveState();  }}},
			'-']});
		return tbar;
	}
	
	//页面整体布局
    var viewport = new Ext.Viewport({
        layout:'border',
        items:[{
			region: 'north',
			height: 25,
            items: getTBar()
		},{
			id: 'portal',
            xtype:'portal',
            region:'center',
            //margins:'5 5 5 5',
            items:[{
            	id:'col_1',
                columnWidth:.49,
                style:'padding:10px 0 10px 10px'
                //items:[panel_1,panel_2]
            },{
            	id:'col_2',
                columnWidth:.50,
                style:'padding:10px 0 10px 10px'
                //items:[panel_3,panel_4]
            }//,{
				//id:'col_3',
                //columnWidth:.33,
                //style:'padding:10px',
                //items:[panel_5,panel_6]
            //}
            ]
        }]
    });
    
    //给panel增加resizaer方法
    function bindResizer(panel)
    {
		var resizer = new Ext.Resizable(panel.getEl(), {
				animate: false,
				duration: .6,
				easing: 'backIn',
				handles: 's',
				minHeight: 50,
				pinned: false
			});
		resizer.on('resize', function(Resizable, width, height) { panel.setHeight(height); panel.getEl().setHeight(height); });
		return resizer;
    }
    

	//读取配置属性,设置相关panel的位置和属性
	function setConfig()
	{
	    //debugger;
		//设置位置
		var arrCol = configCol.split('#');
		for (var i = 0; i < arrCol.length; i++)
		{
			var arrPanel = arrCol[i].split('^');
			var colID = arrPanel[0];
			for	(var j = 1; j < arrPanel.length; j++)
			{
				Ext.getCmp(colID).add(Ext.getCmp(arrPanel[j]));
			}
		}
	    
	    var portal = Ext.getCmp('portal');
		portal.doLayout();		//刷新页面布局
		
		
	    
	    //设置属性,目前为是否显示,将来可以根据需要来增加
		var arrPanelProperty = configPenalProperty.split('#');
		for (var i = 0; i < arrPanelProperty.length; i++)
		{
			var arrTmpPanelPropertys = arrPanelProperty[i].split('^');
			var panel = Ext.getCmp(arrTmpPanelPropertys[0]);		//panel
			var menu = Ext.getCmp(arrTmpPanelPropertys[1])			//menu
			
			panel.setVisible(eval(arrTmpPanelPropertys[2]));		//设置panel是否显示
			menu.setChecked(eval(arrTmpPanelPropertys[2]));			//设置menu是否选中
			panel.setHeight(eval(arrTmpPanelPropertys[3]));			//设置panel的高度
			
			
			//panel.getEl().setHeight(eval(arrTmpPanelPropertys[3]));
			bindResizer(panel);			//给panel绑定resizer方法
			
			panel.expand();
			
			//当panel绑定resizer后,页面结构会修改,即在panel所生成的div上方增加一个div,用来修改panel的大小,但这样会破坏页面结构,导致portal在计算div的位置时出错.因此将resizer增加的div移动到panel里边.
			var proxyID = panel.id + '-rzproxy';
			$('#' + panel.id).append($('#' + proxyID));
		}
	}
	
    setConfig();

});

