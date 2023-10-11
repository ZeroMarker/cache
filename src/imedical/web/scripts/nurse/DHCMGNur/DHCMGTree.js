/**
 * @author Qse
 */
 Ext.onReady(function(){   
            //北边，标题栏   
            var north_item = new Ext.Panel({   
                title: '你的公司公司组织架构',   
                region: 'north',   
                contentEl: 'north-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                height: 50,   
                minSize: 50,   
                maxSize: 120   
            });   
               
            //南边，状态栏   
            var south_item = new Ext.Panel({   
                title: '版权所有',   
                region: 'south',   
                contentEl: 'south-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                height: 50,   
                minSize: 50,   
                maxSize: 120   
            });   
               
            //树   
            //设置树形面板   
               
               
            //中间的中间，功能菜单   
            var grid_item = new Ext.Panel({               
                region: 'west',                   
                el: 'center-center',                   
                title: '功能菜单',       
                split: true,   
                collapsible: true,   
                titlebar: true,   
                collapsedTitle: '内容',   
                height: 200,   
                width: 200,   
                minSize: 100,   
                maxSize: 400   
            });   
               
               
            //中间的南边,信息列表   
            var center_south_item = new Ext.Panel({   
                region: 'center',   
                contentEl: 'center-south',   
                title: '信息列表',   
                split: true,   
                collapsible: true,   
                titlebar: true,   
                collapsedTitle: '内容'   
            });   
               
            //中间   
            var center_item = new Ext.Panel({   
                region: 'center',   
                layout: 'border',   
                items: [grid_item, center_south_item]   
            });   
               
               
            //西边，后台管理   
            var managerUrl = "http://www.google.com";   
            var managerUrlName = "搜索";   
            var west_item = new Ext.Panel({   
                title: '后台管理',   
                region: 'west',   
                contentEl: 'west-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                width: 120,   
                minSize: 120,   
                maxSize: 200,   
                layout: "accordion",   
                layoutConfig: {   
                    animate: true   
                },   
                items: [{   
                    title: "系统管理",   
                    html: '<div id="tree"></div>'   
                }, {   
                    title: "我的任务",   
                    html: '任务'                   
                }, {   
                    title: "流程管理",   
                    html: "流程管理"   
                }]   
            });   
               
            new Ext.Viewport({   
                layout: "border",   
                items: [north_item, south_item, west_item, center_item]   
            });   
               
            //设置树形面板   
            //定义树的跟节点   
            var root = new Ext.tree.TreeNode({   
                id: "root",//根节点id   
                text: "公司"   
            });   
               
            //定义树节点   
            var c1 = new Ext.tree.TreeNode({   
                id: 'c1',//子结点id   
                text: '研发中心'   
            });   
               
            root.appendChild(c1);//为根节点增加子结点c1   
            //生成树形面板   
            var tree = new Ext.tree.TreePanel({   
                renderTo: "tree",   
                root: root,//定位到根节点   
                animate: true,//开启动画效果   
                enableDD: false,//不允许子节点拖动   
                border: false,//没有边框   
                rootVisible: true//设为false将隐藏根节点，很多情况下，我们选择隐藏根节点增加美观性   
            });   
        });   
  
