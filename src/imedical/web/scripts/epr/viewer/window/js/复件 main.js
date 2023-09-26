/*
 * Ext JS Library 2.0
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */
var LocationX = -15;
var LocationY = -15;
var addX = 25;
var addY = 25;
Ext.onReady(function(){
	//创建window窗体
	function createWindow(title, patientID, episodeID, printTemplateDocID, templateDocID)
	{
		var windowID = 'win' + episodeID + printTemplateDocID + templateDocID;
		var frameID = 'frame' + episodeID + printTemplateDocID + templateDocID;
		var frameSrc = 'epr.newfw.viewerSingle.csp?EpisodeID=' + episodeID + '&PatientID=' + patientID + '&PrintTemplateDocID=' + printTemplateDocID + '&TemplateDocID=' + templateDocID;
		var win = Ext.getCmp(windowID);
		if(!win){
			win = new Ext.Window({
				id: windowID,
				footer : false,
				title: title,
				width: 480,
				height: 360,
				iconCls: 'accordion',
				collapsed: true,
				collapsible: true,
				shim: false,
				animCollapse: false,
				constrainHeader: true,
				layout: 'fit',
				border: false,
				maximizable: true,
				//minimizable: true,
				renderTo: 'divCenter',
				layoutConfig: {
					animate: false
				},
				listeners: {'beforeclose': function(panel){ this.hide(); return false; } },
				html: '<iframe id="' + frameID + '" style="border-style: none; width:100%; height:100%" src = ' + frameSrc + '></iframe>'
			});
			LocationX += addX;
			LocationY += addY;
			win.setPosition(LocationX, LocationY);		
		}
		else
		{
			var frame = Ext.getDom(frameID);
			frame.src = frameSrc;
		}		
		win.show();
		
	}
	
	
	//创建树形菜单
	function getBorwserTree(episodeID)
	{
		//重写tree的鼠标双击事件
		Ext.override(Ext.tree.TreeNodeUI, 
		{
			onDblClick : function(e) 
			{
				e.preventDefault();
				if (this.disabled) 
				{
					return;
				}
				if (this.checkbox && !this.node.hasChildNodes()) 
				{
					this.toggleCheck();
				}
				if (!this.animating && this.node.hasChildNodes()) 
				{
					var isExpand = this.node.ownerTree.doubleClickExpand;
		        
					if (isExpand) 
					{
					};
					this.node.toggle();
				}
				this.fireEvent("dblclick", this.node, e);
			}
		});
		
		var treeTbar = [
		{
			id : 'btnSelect', 
			text : '确定',
			pressed: false,
			icon:'../scripts/epr/Pics/viewer/window/btnConfirm.gif',
			handler: function(){
				alert(tree.getChecked('id'));
			}
		}];
		
		var Tree = Ext.tree;
		
		/*	treeLoader begin  */			
		var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.viewerTree.cls?EpisodeID=" + episodeID});
		//抛出异常时的处理				
		treeLoader.on("loadexception", function(tree, node, response) {
			var obj = response.responseText;
			alert(obj);
		});
		
		//add by zhuj on 2009-12-28	begin
		treeLoader.on("load", function(tree, node, response) {
			if (node.getDepth() == 2)
			{
				var checked = node.attributes.checked;
				node.eachChild(function(child) {   
					child.ui.toggleCheck(checked);   
					child.attributes.checked = checked;   
					child.fireEvent('checkchange', child, checked);   
				});   
			}
		});
		//end
		/*	treeLoader end  */
		
		var tree = new Tree.TreePanel({
			rootVisible: false,
			autoScroll: true,
			animate: false,
			//enableDD:true,
			containerScroll: true,
			lines: true, 
			checkModel: 'cascade',
			autoHeight: true,
			border: false,
			loader: treeLoader,
			tbar: treeTbar,
			id: "browserTree"
		});
	      
		var root = new Tree.AsyncTreeNode( {
			text: '电子病历',
			nodeType: 'async',
			draggable: false,
			id: "RT0"
		});	
		
		//add by zhuj on 2009-12-28	begin
		tree.on('checkchange', function(node, checked) {   
			node.expand();
			node.attributes.checked = checked;   
			node.eachChild(function(child) {   
				child.ui.toggleCheck(checked);   
				child.attributes.checked = checked;   
				child.fireEvent('checkchange', child, checked);   
			});
		}, tree);		
		//end
		
		
		tree.on('click',function(node,event){
			selectNode = node;
			selectParentNode = node.parentNode;
			//判断是否是叶子节点
			if (node.isLeaf() == true)
			{
				var selectNodeID = selectNode.id.substring(2, selectNode.id.length);
				var selectParentNodeID = selectParentNode.id.substring(2, selectParentNode.id.length);
				var title = selectNode.text;
				templateDocID = selectNodeID;
				printTemplateDocID = selectParentNodeID;
				createWindow(title, patientID, episodeID, printTemplateDocID, templateDocID);
			}
		}); 

		tree.setRootNode(root);
		root.expand(); 
		return tree;
	}


	
	var frmMainContent = new Ext.Viewport(
        {
            id: 'mainViewPort',
            shim: false,
            animCollapse: false,
            constrainHeader: true, 
            margins:'0 0 0 0',           
            layout: 'border',        
			border: false,             
            items: [{ 
			
                        region: 'west', 
                        layout: 'accordion',
                        title: '病历列表',
                        width: 230, 
                        split: true, 
                        collapsible: true,
                        items: [
							{
								title: '病历结构',
								items: getBorwserTree(episodeID),
								autoScroll:true
							},{
								title: '医嘱',
								layout: 'fit',
								autoScroll:true,
								items: createOeord()
							},{
								title: '检查结果',
								html:'<p>Something useful would be in here.</p>',
								autoScroll:true
							}
						]
					},
                    { 
						region: 'center', 
						layout: "border", 
						id: "mainCenter",
                        items: [
									{ 
										 border: false, id: 'mainSouth', region: 'south', title: ' ', split: true, collapsible: true, collapsed: true, titleCollapse: false, layout: 'fit', height: 280,
										 html: '<iframe id ="southTab" style="width:100%; height:100%" src="epr.newfw.southTabNew.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocID + '&printTemplateDocId=' + printTemplateDocID + '" ></iframe>'
									},
									{
										 border: false, region: 'center',html: '<div id = "divCenter" style = "width: 100%; height: 100%"></div>'
									}
								]
                    }]
        });
        
        //增加southTitle		
		var mainsouthcollapsed = document.getElementById('mainSouth-xcollapsed');
		var titleInfo = document.createElement("div");
		titleInfo.id = 'southTitleInfo';
		titleInfo.style.fontSize = 12;
		//titleInfo.innerHTML = '&nbsp医嘱/化验/病历浏览';
		titleInfo.style.position = 'absolute';
		titleInfo.style.top = 4;
		titleInfo.style.color = '565f6d';
		titleInfo.style.fontWeight = 'bold';
		mainsouthcollapsed.appendChild(titleInfo); 

});

//创建医嘱		add by zhuj on 2009-12-28
function createOeord()
{
	var panel = new Ext.Panel(
	{
		    layout : "column",  
            labelAlign : 'right',
            textdAlign : 'right',     
            labelWidth : 30,  
            frame : true,
            items : [
                        {
                            columnWidth : 1,
                            layout : 'form',
							labelAlign : 'right',
							labelWidth : 60,
                            border : false,
                            items:[{ xtype : "textfield", fieldLabel : "登记号", id : "txtRegNo", anchor: '100%'}]
                        },                        
                        {
                            columnWidth : 1,
                            labelAlign : 'right',
                            labelWidth : 60,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "textfield", fieldLabel : "就诊号", id : "txtEpisodeID", anchor: '100%'}]
                        },
                        {
                            columnWidth : 1,
                            labelAlign : 'right',
                            labelWidth : 60,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "textfield", fieldLabel : "科室", id : "txtOrdDep", anchor: '100%'}]
                        },
						{
                            columnWidth : 1,
                            labelAlign : 'right',
                            labelWidth : 60,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "textfield", fieldLabel : "基本信息", id : "txtPatBasinfo", anchor: '100%'}]
                        },

                        {
                            columnWidth : 1,
                            labelAlign : 'right',
                            labelWidth : 60,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "datefield", fieldLabel : "开始日期", id : "txtStartDT",anchor: '100%', format : "Y-m-d" }]
                        },
						{
                            columnWidth : 1,
                            labelAlign : 'right',
                            labelWidth : 60,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "datefield", fieldLabel : "结束日期", id : "txtEndDT",anchor: '100%', format : "Y-m-d" }]
                        },
                        
                        {
                            columnWidth : 0.5,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "checkbox", boxLabel  : "按日期查询", id : "chkDT", hideLabel : true }]
                        },
                        
                         {
                            columnWidth : 0.5,
                            layout : 'form',
                            border : false,
                            items:[{ xtype : "checkbox", boxLabel  : "全部", id : "chkAll", hideLabel : true }]
                        },
                        {
                            columnWidth : 1,
                            layout : 'form',
                            buttonAlign: 'center',
                            border : false,
                            buttons: [
								{ id : "btnOrdLong", text: "长期医嘱"},
								{ id : "btnOrdTemp", text: "临时医嘱"}
							]
                        }
                    ]
	});
	return panel;
}

