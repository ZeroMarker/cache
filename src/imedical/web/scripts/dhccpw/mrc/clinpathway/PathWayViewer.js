/*!
 * 编写日期:2010-04-26
 * 作者：李宇峰
 * 说明：当装载页面时最先执行这个js里的代码
 * 名称：PathWayViewer.js
 */
PathWayViewer = {};

Ext.onReady(function(){     //最先执行这个方法
    Ext.QuickTips.init();
	
    //Ext.state.Manager.setProvider(new Ext.state.SessionProvider({state: Ext.appState}));
	
    var tpl = Ext.Template.from('preview-tpl', {
        compiled:true,
        getBody : function(v, all){
            return Ext.util.Format.stripScripts(v || all.description);
        }
    });
    PathWayViewer.getTemplate = function(){
        return tpl;
    }
    
    var ways = new PathWayPanel();    //得到页面中左侧面板的对象
    var mainPanel = new MainPanel();  //得到主面板的对象
    
    var mainPanels1 = new Ext.Panel({
		id : 'mainPanels1',
		buttonAlign : 'center',
		height:300,
		layout:'fit',
		region:'center'
	});
	var mainPanels = new Ext.Panel({
		id : 'mainPanels',
		title:"临床路径"
		,buttonAlign : 'center',
		layout:'border',
		region:'center',
		items:[
			mainPanels1
		]
	});
    ways.on('feedselect', function(way){   //为feedselect添加事件
		mainPanel.loadEpisode(way);
		mainPanels1.add(mainPanel);
		mainPanels1.doLayout();
		mainPanels.setTitle(way.text);
		mainPanels.doLayout();
    });
    
    var viewport = new Ext.Viewport({
        layout:'border',
        items:[
            ways,
           	mainPanels
         ]
    });
    Ext.get('header').on('click', function() {
        viewport.focus();
    });
    ways.focus();
});

PathWayViewer.LinkInterceptor = {
    render: function(p){
        p.body.on({
            'mousedown': function(e, t){ // try to intercept the easy way
                t.target = '_blank';
            },
            'click': function(e, t){ // if they tab + enter a link, need to do it old fashioned way
                if(String(t.target).toLowerCase() != '_blank'){
                    e.stopEvent();
                    window.open(t.href);
                }
            },
            delegate:'a'
        });
    }
};