/*!
 * ��д����:2010-04-26
 * ���ߣ������
 * ˵������װ��ҳ��ʱ����ִ�����js��Ĵ���
 * ���ƣ�PathWayViewer.js
 */
PathWayViewer = {};

Ext.onReady(function(){     //����ִ���������
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
    
    var ways = new PathWayPanel();    //�õ�ҳ����������Ķ���
    var mainPanel = new MainPanel();  //�õ������Ķ���
    
    var mainPanels1 = new Ext.Panel({
		id : 'mainPanels1',
		buttonAlign : 'center',
		height:300,
		layout:'fit',
		region:'center'
	});
	var mainPanels = new Ext.Panel({
		id : 'mainPanels',
		title:"�ٴ�·��"
		,buttonAlign : 'center',
		layout:'border',
		region:'center',
		items:[
			mainPanels1
		]
	});
    ways.on('feedselect', function(way){   //Ϊfeedselect����¼�
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