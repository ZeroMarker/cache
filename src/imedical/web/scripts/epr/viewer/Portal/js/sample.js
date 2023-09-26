/*
 * Ext JS Library 2.0
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */
var pannel;
Ext.onReady(function(){

    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
// portlet 上的工具按钮(暂时至定义了关闭按钮)
    var tools = [/*{
        id:'gear',
        handler: function(){
            Ext.Msg.alert('Message', 'The Settings tool was clicked.');
        }
    },*/{
        id:'close',
        handler: function(e, target, panel){
            panel.ownerCt.remove(panel, true);
        }
    }];
    var tools1 = [/*{
        id:'gear',
        handler: function(){
            Ext.Msg.alert('Message', 'The Settings tool was clicked.');
        }
    },*/{
        id:'refresh',
        handler: function(){
            document.frames('workiframe').document.location.reload();
        }
    },{
        id:'close',
        handler: function(e, target, panel){
            panel.ownerCt.remove(panel, true);
        }
    }]; 
    var tools2 = [{
        id:'refresh',
        handler: function(){
            document.frames('questioniframe').document.location.reload();
        }
    },{
        id:'close',
        handler: function(e, target, panel){
            panel.ownerCt.remove(panel, true);
        }
    }];
    pannel = new Ext.TabPanel({
                    region:'center',
                    deferredRender: false,
                    activeTab:0,
                    minTabWidth: 100,
                    //plugins: new Ext.ux.TabCloseMenu(),//标签页多时，可以左右查看标签页
                    resizeTabs: true, 
			        enableTabScroll: false,
			        defaults: {autoScroll:false},
                    items:[
                	{
            xtype:'portal',
            title: '我的工作台',
            closable: false,
            autoScroll: true,
            //margins:'35 5 5 0',
            items:[{
                columnWidth:.33,
                style:'padding:10px 0 10px 10px',
                items:[
                {
	                    title: '通讯录',
						tools: tools,
						scrolling: true,
						//style:'padding:10px 0 10px 10px;height:260',
						height: 260,
	                    //html: '<HTML><HEAD><TITLE>待办事宜</TITLE></HEAD><BODY><table border=1 ><tr><td>aaa</td><td>aaa</td><td>aaa</td></tr><tr><td>aaa</td><td>aaa</td><td>aaa</td></tr><tr><td>aaa</td><td>aaa</td><td>aaa</td></tr></table></BODY></HTML>'
	                    html: '<HTML><HEAD><TITLE>通讯录</TITLE></HEAD><BODY><iframe scrolling=yes frameborder=0  height=100% width=100% src='+getServerUrl()+'/sysmanage/telbook_portlet1.jsp></iframe></BODY></HTML>'
	                },{
	                    title: '天气情况',
						tools: tools,
						height: 270,
	                    //html: '<br>显示当天及明天天气情况,开发中...<br><br><br><br><br>'
	                    html: '<HTML><HEAD><TITLE>天气情况</TITLE></HEAD><BODY><iframe scrolling=yes frameborder=0  height=100% width=100% src='+getServerUrl()+'/sysmanage/weather_portlet.jsp></iframe></BODY></HTML>'
	                }]
	            },{
	                columnWidth:.33,
	                style:'padding:10px 0 10px 10px',
	                items:[
	                {
	                    title: '通知公告',
						tools: tools,
						height: 260,
	                    //html: '<br><table width=100%><tr align="center"><td><a href=# onclick=window.open("../download/dhzc/content.htm","_blank");><img src=scheme/images/dhzc.gif border=0></a></td></tr></table><br>'
	                    html: '<HTML><HEAD><TITLE>通知公告</TITLE></HEAD><BODY><iframe scrolling=no frameborder=0 height=100%  width=100% src='+getServerUrl()+'/sysmanage/notice_portlet.jsp></iframe></BODY></HTML>'
	                }
	                ,{
	                    title: '待办事宜',
						tools: tools1,
						scrolling: true,
	                    //html: '<HTML><HEAD><TITLE>待办事宜</TITLE></HEAD><BODY><table border=1 ><tr><td>aaa</td><td>aaa</td><td>aaa</td></tr><tr><td>aaa</td><td>aaa</td><td>aaa</td></tr><tr><td>aaa</td><td>aaa</td><td>aaa</td></tr></table></BODY></HTML>'
	                    html: '<HTML><HEAD><TITLE>待办事宜</TITLE></HEAD><BODY><iframe id=workiframe scrolling=yes frameborder=0 width=100% src='+getServerUrl()+'/sysmanage/work_portlet.jsp></iframe></BODY></HTML>'
	                }/*{
	                    title: '我的邮箱',
						tools: tools,
	                    html: '<br>个人邮箱功能,开发中...<br><br><br><br><br>'
	                },{
                    title: '今天的考勤记录',
                    tools: tools,
                    html: '<br>显示当天的考勤情况,开发中...<br><br><br><br><br>'
                   // html: '<iframe src='+getServerUrl()+'/t002.do?fodwin=002_104013></iframe>'
                }*/]
	            },{
	                columnWidth:.33,
	                style:'padding:10px 0 10px 10px',
	                items:[
					/*{
	                    title: '投票',
						tools: tools,
						scrolling: true,
	                    html: '<HTML><HEAD><TITLE>投票</TITLE></HEAD><BODY><iframe id=bolletframe scrolling=yes frameborder=0 height=800 width=100% src='+getServerUrl()+'/sysmanage/ballot_portlet.jsp></iframe></BODY></HTML>'
	                },*/{
	                    title: '问题反馈',
						tools: tools2,
						height: 260,
						scrolling: true,
	                    html: '<HTML><HEAD><TITLE>问题反馈</TITLE></HEAD><BODY><iframe id=questioniframe width=100%  height=100% scrolling=yes frameborder=0 src='+getServerUrl()+'/sysmanage/question_portlet.jsp></iframe></BODY></HTML>'
	                },{
	                    title: '资源下载',
						tools: tools,
						height: 270,
	                    html: '<HTML><HEAD><TITLE>资源下载</TITLE></HEAD><BODY><iframe id=srcdown width=100%  height=100% scrolling=yes frameborder=0 src='+getServerUrl()+'/sysmanage/srcdown_portlet.jsp></iframe></BODY></HTML>'
	                }/*,{
	                    title: '我的日志',
						tools: tools,
	                    html: '<br><br>填写日志区域,开发中...<br><br><br><br>'
	                },{
	                    title: '项目仪表盘',
						tools: tools,
	                    html: '<br><table width=100%><tr align="center"><td><img src=scheme/images/portlet_prj_1.jpg border=0></td></tr></table><br>'
	                }*/]
	            }]
	        },
                	//标签页2，不可以被关闭
                	new Ext.BoxComponent({
	                    el: 'center',
	                    title: '列表区',
	                    //closable: true,
                        autoScroll: false,
                        html: '中间面板2<br/><br/>'
                	})]
                });
    
    pannel.items.items[0].addListener('activate',function(){document.frames('workiframe').document.location.reload();document.frames('questioniframe').document.location.reload()});
    viewport = new Ext.Viewport({
        layout:'border',
        items:[
        {
            region:'west',
            id:'west-panel',
            title:'功能菜单',
            split:true,
            width: 150,
            minSize: 120,
            maxSize: 400,
            collapsible: true,
            collapsed: true,
            //margins:'35 0 5 5',
            //cmargins:'35 5 5 5',
            layout:'accordion',
            layoutConfig:{
            animate:true
            },
            items: i
        }
        ,
        //北部区域，BoxComponent对象
                new Ext.BoxComponent({ 
                    region:'north',
                    el: 'north',
                    height:53
                })
        //:~
        ,
        pannel
        //中部区域，iframe标签页         

        ]
    });
    
    //北部区域的iframe标签页中的src
    Ext.getDom("north").src = "top3.jsp";
    //:~
    //中间区域的iframe标签页中的src,进入系统第一个页面,默认是任务列表
    Ext.getDom("center").src = getServerUrl()+"/t002.do?fodwin=002_104042";
    //:~
	//viewport.items.items[0].addListener('expand',function(){alert('aa');viewport.items.items[0].collapse(true);})
	viewport.items.items[0].expand(true);
});

