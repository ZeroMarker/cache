/*!
 * 编写日期:2010-04-27
 * 作者：李宇峰
 * 说明：临床路径展示界面
 * 名称：MailPanel.js
 */
MainPanel = function(){
	var treeloader=new Ext.tree.TreeLoader({dataUrl:ExtToolSetting.TreeQueryPageURL}); 
    MainPanel.superclass.constructor.call(this, {
		id:'main-tree',
        split:true,
        width: 400,
        ddGroup: 'ddGroup',
        enableDrag : true,
        root : new Ext.tree.AsyncTreeNode({text:"",id:"path",expanded:true}),
        rootVisible:false,
        lines:true,
        enableDD:true,
        clearOnLoad:false,
        autoScroll:true,
        loader : treeloader,
        collapseFirst:false
    });
    this.menu1 = new Ext.menu.Menu({
		id:'epi-ctx',
        items: [{
            id:'addEpisode',
            iconCls:'load-icon',
            text:'路径阶段维护',
            scope: this,
            handler:function(){
                var pathTree=Ext.getCmp("way-tree");
                var pathNode=pathTree.getSelectionModel().getSelectedNode();
                if(!this.PathWayEp){
					this.PathWayEp=new PathWayEp(pathNode)	
				}else{
					this.PathWayEp=new PathWayEp(pathNode)
				}
				this.PathWayEp.PathWayEpWin.show();
            }
        },{
            id:'addEpStep',
            text:'路径步骤维护',
            iconCls:'delete-icon',
            scope: this,
            handler:function(){
            		var node=this.menuNode;
            		if(!this.PathWEpStepWin){
            				this.PathWEpStepWin=new PathWEpStep(node,"")
            		}else{
            				this.PathWEpStepWin=new PathWEpStep(node,"")
            		}
            		this.PathWEpStepWin.PathWEpStepWindow.show();
            }
        }
        /* update by zf 20101105 屏蔽树表单树中删除功能
        ,{
    		id:'deleteEpi',
    		text:'删除路径阶段',
    		iconCls:'delete-icon',
    		scope:this,
    		handler:function(){
    			var node=this.menuNode;
    			Ext.MessageBox.confirm('Confirm', '确定要删除这个阶段?', function(btn,text){
    					if(btn=="yes"){
											var DeletePathWayEpMethod=document.getElementById('DeletePathWayEpMethod')
											if(DeletePathWayEpMethod){
												var encmeth=DeletePathWayEpMethod.value;	
											}else{
												var encmeth=""	
											}
											var delVal=cspRunServerMethod(encmeth,node.id)
    							if(delVal==0){
    								node.remove();
    							}else{
    								Ext.MessageBox.show({
		           								title: 'Failed',
		          								 msg: '删除失败!',
		           									buttons: Ext.MessageBox.OK,
		           									icon:Ext.MessageBox.ERROR
		   									});	
    							}
    					}
    				});
    		}
		}*/
		]
	});
    this.menu2 = new Ext.menu.Menu({       //右击树的第二级结点弹出的菜单
        id:'setp-ctx',
        items: [
            /* update by zf 20101105 屏蔽树表单树中删除功能
            {
                id:'deleteStep',
                iconCls:'delete-icon',
                text:'删除路径步骤',
                scope: this,
                handler:function(){
                	var node=this.menuNode;
            		Ext.MessageBox.confirm('Confirm', 'Are you sure you want to delete this Step?', function(btn,text){
        				if(btn=="yes"){
        					var DeleteStepMethod=document.getElementById('DeleteStepMethod')
        					if(DeleteStepMethod){
        						var encmeth=DeleteStepMethod.value;	
        					}else{
        						var encmeth=""	
        					}
        					var delVal=cspRunServerMethod(encmeth,node.id)
							if(delVal==0){
								node.remove();
							}else{
								Ext.MessageBox.show({
       								title: 'Failed',
      								msg: '删除失败!',
       								buttons: Ext.MessageBox.OK,
       								icon:Ext.MessageBox.ERROR
	   							});	
							}
        				}
            		});
               	}
			},*/
			{
        		id:'stepDetails',
        		text:'路径步骤维护',
        		scope:this,
        		handler:function(){
        			var node=this.menuNode;
        			var parentNode=node.parentNode
        			
        			if(!this.PathWEpStepWin){
        				this.PathWEpStepWin=new PathWEpStep(parentNode,node.id);
        			}else{
        				this.PathWEpStepWin=new PathWEpStep(parentNode,node.id);
        			}
        			this.PathWEpStepWin.PathWEpStepWindow.show();
        		}
            },{
                id:'editStep',
                text:'路径项目维护',
                iconCls:'delete-icon',
                scope: this,
                handler:function(btn){
                		var node=this.menuNode;
                			this.PathItemWin=new PathWEpStepItem(node,"")
                		this.PathItemWin.PathItemWindow.show()
                }
            }
            /*,{
            	id:"copyOrd",
            	text:"路径项目复制",
            	scope:this,
            	handler:function(){
            		//var node=this.menuNode;
            		var cpwNode=Ext.getCmp('way-tree').getSelectionModel().getSelectedNode()
            		var cpwRowid=cpwNode.id.split('_');
            		cpwRowid=cpwRowid[0];
            		this.copyOrdWin=new CopyItem();
            		this.copyOrdWin.show();
            	}	
            }*/
        ]
    });
    this.menu3 = new Ext.menu.Menu({
        id:'ord-ctx',
        items: [
            /* update by zf 20101105 屏蔽树表单树中删除功能
            {
                id:'deleteOrd',
                iconCls:'load-icon',
                text:'删除路径项目',
                scope: this,
                handler:function(){
                	var node=this.menuNode;
            		Ext.MessageBox.confirm(node.text, 'Are you sure you want to delete this Step?', function(btn,text){
            				if(btn=="yes"){
            					var DeleteStepItemMethod=document.getElementById('DeleteStepItemMethod')
            					if(DeleteStepItemMethod){
            						var encmeth=DeleteStepItemMethod.value;	
            					}else{
            						var encmeth=""	
            					}
            					var delVal=cspRunServerMethod(encmeth,node.id)
    							if(delVal==1){
    								node.remove();
    							}else{
    								Ext.MessageBox.show({
		           								title: 'Failed',
		          								msg: '删除失败!',
		           								buttons: Ext.MessageBox.OK,
		           								icon:Ext.MessageBox.ERROR
		   							});	
    							}
            				}
            		});
                }
			},*/
            {
                id:'ItemDetails',
                text:'路径项目维护',
                iconCls:'delete-icon',
                scope: this,
                handler:function(){
            		var node=this.menuNode;
            		if(!this.PathItemWin){
            			this.PathItemWin=new PathWEpStepItem(node.parentNode,node.id)	
            		}else{
            			this.PathItemWin=new PathWEpStepItem(node.parentNode,node.id);	
            		}
            		this.PathItemWin.PathItemWindow.show()
                }
            }
        ]
    });
    this.on('contextmenu', this.onContextMenu, this);
    treeloader.on('beforeload',function(treeloader,node){
       treeloader.baseParams.ClassName="web.DHCCPW.MRC.ClinPathWaysSrv";
       treeloader.baseParams.QueryName="QueryCPWTree";
       treeloader.baseParams.Arg1=node.id;
       treeloader.baseParams.ArgCnt=1;
    });
};

Ext.extend(MainPanel, Ext.tree.TreePanel, {
	onContextMenu : function(node, e){
		node.select()
		this.menuNode=node;
    	var depth=node.getDepth();
    	if(depth==1){
	        if(!this.menu1){ // create context menu on first right click
	            this.menu1.on('hide', this.onContextHide, this);
	        }
	        if(this.ctxNode){
	        }
	        if(node.isLeaf()){
	            this.ctxNode = node;
	            this.ctxNode.ui.addClass('x-node-ctx');
	            this.menu.items.get('load').setDisabled(node.isSelected());
	            this.menu.showAt(e.getXY());
	        }
	        var arr=e.getXY()
	        var menuNum=Ext.getCmp('ord-ctx').items.length        //菜单条的个数
	        var mainHeight=Ext.getCmp('main-tree').getSize().height  //此treepanel的高度
	        var mainTop=Ext.getCmp('main-tree').getPosition()[1]      //此treepanel的Top
	        if(arr[1]+menuNum*25>mainHeight+mainTop){       
	        	arr[1]=arr[1]-menuNum*25
	        }
	        this.menu1.showAt(arr);
        }
        if(depth==2){
        	if(!this.menu2){ // create context menu on first right click
	        }
	        if(this.ctxNode){
	        }
	        var arr=e.getXY()
	        var menuNum=Ext.getCmp('setp-ctx').items.length        //菜单条的个数
	        var mainHeight=Ext.getCmp('main-tree').getSize().height  //此treepanel的高度
	        var mainTop=Ext.getCmp('main-tree').getPosition()[1]     //此treepanel的Top
	        if(arr[1]+menuNum*25>mainHeight+mainTop){       
	        	arr[1]=arr[1]-menuNum*25
	        }
	        this.menu2.showAt(arr);
        }
        if(depth==3){
        	if(!this.menu3){ // create context menu on first right click
	            this.menu3.on('hide', this.onContextHide, this);
	        }
	        if(this.ctxNode){
	        }
	        if(node.isLeaf()){
	        }
	        var arr=e.getXY()
	        var menuNum=Ext.getCmp('ord-ctx').items.length        //菜单条的个数
	        var mainHeight=Ext.getCmp('main-tree').getSize().height  //此treepanel的高度
	        var mainTop=Ext.getCmp('main-tree').getPosition()[1]      //此treepanel的Top
	        if(arr[1]+menuNum*25>mainHeight+mainTop){       
	        	arr[1]=arr[1]-menuNum*25
	        }
	        this.menu3.showAt(arr);
        }
    },
    onContextHide : function(){
        if(this.ctxNode){
            this.ctxNode.ui.removeClass('x-node-ctx');
            this.ctxNode = null;
        }
    },
    loadEpisode : function(episode){
    	var episodeStr=episode.id.split("_");
    	var pathWayId=episodeStr[0];
    	var rootNode=new Ext.tree.AsyncTreeNode({text:"",id:pathWayId});
    	this.setRootNode(rootNode);
    	return;
    },
    removeAllChildren:function(node){
    	if(!node) return;
    	while(node.hasChildNodes()){
    		this.removeAllChildren(node.firstChild);
    		node.removeChild(node.firstChild);
    	}
    },
    afterRender : function(){
        PathWayPanel.superclass.afterRender.call(this);
        this.el.on('contextmenu', function(e){
            e.preventDefault();
        });
    }
});

Ext.reg('appmainpanel', MainPanel);