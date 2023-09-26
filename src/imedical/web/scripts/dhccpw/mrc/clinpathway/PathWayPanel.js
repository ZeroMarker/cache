/*!
 * 编写日期:2010-04-26
 * 作者：李宇峰
 * 说明：页面中左侧panel中的代码
 * 名称：PathWayPanel.js
 */
PathWayPanel = function() {
	
	//临床路径维护 基础代码维护 下拉菜单定义
	this.typeMenu = new Ext.menu.Menu({
        id: 'mainMenu'
        ,style: {
            overflow: 'visible'     // For the Combo popup
        }
        ,items: [
            {
                text: '路径类型维护',
                handler: this.pathWayTypeEdit
            },{
	            text:'临床路径维护',
	            handler: this.showWindow
	        },'-',{
        		text:'变异原因维护',
            	handler:function(){
	                this.objWinVarReason = new InitWinVarReason();
	                this.objWinVarReason.WinVarReason.show();
        		}
            },{
            	text:'变异类型维护',
                handler:function(){
                	this.objWinVarCateg = new InitWinVarCateg();
                	this.objWinVarCateg.WinVarCateg.show();
                }
            },{
            	text:'项目大类维护',
            	handler:this.StepItemCat	
            },{
            	text:'项目子类维护',
            	handler:this.StepItemSubCat
            },'-',{
            	text:'临床路径表单导入',
                handler:function(){
	                this.objWinImportClinPathWay = new InitWinImportClinPathWay();
	                this.objWinImportClinPathWay.WinImportClinPathWay.show();
            	}
			}
        ]
    });
    
    //临床路径维护 左侧面板定义
	PathWayPanel.superclass.constructor.call(this, {
        id:'way-tree',
        region:'west',
        title:'',
        split:true,
        width: 300,
        minSize: 175,
        maxSize: 400,
        buttonAlign:'center',
        collapsible: true,  		                                //此Panel是否可以收缩
        margins:'0 0 5 5',
        cmargins:'0 5 5 5',
        rootVisible:false,                                          //root节点是否可见
        lines:false,
        autoScroll:true,    		                                //是否自动产生滚动条
        root: new Ext.tree.TreeNode('临床路径')                     //root 为树添加一个根结点
        ,tbar: [
	        {            										    //panel 顶部工具条。
	        	iconCls:'add-way'
	    		,text: '科室常用路径'
	            ,handler: function(){
	            	this.PathWayDeptWin=new PathWayDept();
	            	this.PathWayDeptWin.PathDeptWin.show();
	            }
	            ,scope: this
	        }
	        ,{
	            text:'基础代码维护'
	            ,iconCls: 'bmenu'
	            ,menu: this.typeMenu
	        }
        ]
    });
    
    this.getSelectionModel().on({
        'beforeselect' : function(sm, node){
            return node.isLeaf();
        },
        'selectionchange' : function(sm, node){
            if(node){
                this.fireEvent('feedselect', node.attributes);    //***触发PathWayViewer.js中的feedselect方法
            }
        },
        scope:this
    });
    this.addEvents({feedselect:true});
    
    this.on('contextmenu', this.onContextMenu, this);     //定义左侧面板临床路径右键菜单事件
    this.loadTypes();                                     //加载左侧面板临床路径类型
    this.addListener("beforeexpandnode",function(node,e){ //定义临床路径类型节点展开事件
    	if(node.parentNode){
    		this.loadPathWays(node);
    	}
    },false,false);
};

Ext.extend(PathWayPanel, Ext.tree.TreePanel, {
    onContextMenu : function(node, e){                    //当在临床路径上右击时生成的菜单
		this.node=node;
        if(!this.menu){
            this.menu = new Ext.menu.Menu({
                id:'main-ctx',
                items: [
                	/*********************************************************************
	                // update by zf 2010-11-03
	                //删除右键菜单[加载]功能
	                //屏蔽右键菜单[删除]功能
	                {
	                    text:'删除临床路径',                         //删除一个结点
	                    iconCls:'delete-icon',
	                    scope: this,
	                    handler:function(){
	                    	var idStr=this.node.id.split("_");
							var pathRowid=idStr[0];
	                    	Ext.MessageBox.confirm('Confirm', '你确定要删除此临床路径吗?', function(btn,text){
	                			if(btn=="yes"){
							        var DeletePathMethod=document.getElementById('DeletePathMethod');
							        if(DeletePathMethod){
							        	var encmeth=DeletePathMethod.value;
							        }else{
							        	var encmeth="";
							        }
							        var deleteVal=cspRunServerMethod(encmeth,pathRowid);
							        if(deleteVal==0){
							        	Ext.getCmp('way-tree').getNodeById(pathRowid+"_path").remove();
							        		
							        }else{
							        	ExtTool.alert("提示","删除失败!");	
							        }
								}
							});
	                    }
	                },'-',
	                *********************************************************************/
	                {
	                    iconCls:'add-way',
	                    text:'临床路径维护',
	                    handler: function(){
	                    	var nodeRowid=this.node.id.split("_");
	                    	var pathRowid=nodeRowid[0];
							this.win = new EditPathWay(pathRowid);
							this.win.PathWayWin.show();	
	                    },
	                    scope: this
	                },{
	                    iconCls:'add-way',
	                    text:'指定常用科室',
	                    scope: this,
	                    handler: function(){
	                    		if(!this.DeptPathWay){
									this.DeptPathWay = new DeptPathWay(this.node);
								}else{
									this.DeptPathWay = new DeptPathWay(this.node);
								}
								this.DeptPathWay.DeptPathWin.show();
	                    }
	                },{
	                    iconCls:'add-way',
	                    text:'路径阶段维护',
	                    scope: this,
	                    handler: function(){
	                    	this.PathWayEp=new PathWayEp(this.node);
							this.PathWayEp.PathWayEpWin.show();
	                    }
	                },
	                {
	                    iconCls:'add-way',
	                    text:'监控规则维护',
	                    scope: this,
	                    handler: function(){
	                    	var cpwRowid=this.node.id.split("_");
	                    	cpwRowid=cpwRowid[0];
							if(!this.PathWayRule){
								this.PathWayRule=new InitWinRules(cpwRowid)	
							}else{
								this.PathWayRule=new InitWinRules(cpwRowid)
							}
							this.PathWayRule.WinRules.show();
	                    }
	                }
                ]
            });
            this.menu.on('hide', this.onContextHide, this);
        }
        if(this.ctxNode){
            this.ctxNode.ui.removeClass('x-node-ctx');
            this.ctxNode = null;
        }
        if(node.isLeaf()){
            this.ctxNode = node;
            this.ctxNode.ui.addClass('x-node-ctx');
            //高度检查
	          var arr=e.getXY()
		        var menuNum=Ext.getCmp('main-ctx').items.length        //菜单条的个数
		        var mainHeight=Ext.getCmp('way-tree').getSize().height  //此treepanel的高度
		        var mainTop=Ext.getCmp('way-tree').getPosition()[1]      //此treepanel的Top
		        if(arr[1]+menuNum*25>mainHeight+mainTop){       
		        	arr[1]=arr[1]-menuNum*25
		        }
	            this.menu.showAt(arr);
        }
    },
    onContextHide : function(){
        if(this.ctxNode){
            this.ctxNode.ui.removeClass('x-node-ctx');
            this.ctxNode = null;
        }
    },
    showWindow : function(btn){       //显示"临床路径编辑"窗口的方法
        	if(!this.win){
							this.win = new EditPathWay("");
					}else{	        	
						this.win = new EditPathWay("");
					}
					this.win.PathWayWin.show();
    },
    selectFeed: function(id){
        this.getNodeById(id).select();
    },
    removePath: function(node){    //删除一个临床路径结点
        var idStr=node.id.split("_");
        var pathRowid=idStr[0]
        var DeletePathMethod=document.getElementById('DeletePathMethod');
        if(DeletePathMethod){
        	var encmeth=DeletePathMethod.value;	
        }else{
        	var encmeth=""	
        }
        var deleteVal=cspRunServerMethod(encmeth,pathRowid);
        alert(deleteVal)
        if(deleteVal==0){
        		node.remove();
        }else{
        	ExtTool.alert("提示","删除失败!");	
        }
    },
		removeAllChildren:function(node){
    	if(!node) return;
    	while(node.hasChildNodes()){
    		this.removeAllChildren(node.firstChild);
    		node.removeChild(node.firstChild);
    	}
    },
    addFeed : function(attrs, inactive, preventAnim){
        var exists = this.getNodeById(attrs.Rowid);
        if(exists){
            if(!inactive){
                exists.select();
                exists.ui.highlight();
            }
            return;
        }
        Ext.apply(attrs, {
            iconCls: 'feed-icon',
            leaf:true,
            cls:'feed',
            id: attrs.Rowid
        });
        var node = new Ext.tree.TreeNode(attrs);
        this.root.appendChild(node);
        
        return node;
    },
    afterRender : function(){
        PathWayPanel.superclass.afterRender.call(this);
        this.el.on('contextmenu', function(e){
            e.preventDefault();
        });
    },
    loadTypes: function(){
    	this.removeAllChildren(this.root)
			var types=this.getAllType()
    	var types=types.split(",");
    	for(var i=0;i<types.length;i++){
    		var type=types[i].split("^");
    		this.root.appendChild(   //为根节点添加子节点
       		new Ext.tree.TreeNode({
            text:type[1],
            id:type[0]+"_type",
            cls:'ways-node',
            expanded:false,
            expandable:true
        	})
				)
		}
		this.root.appendChild(   //为根节点添加子节点
       		new Ext.tree.TreeNode({
            text:"其它",
            id:"Other_type",
            cls:'ways-node',
            expanded:false,
            expandable:true
        	})
     )
	},
	loadPathWays:function(typeNode){
			var typeRowid=typeNode.id.split("_");
			var pathWays=this.getPathByType(typeRowid[0]);
			if(pathWays=="") return;
			var pathWays=pathWays.split(",");
			for(var i=0;i<pathWays.length;i++){
				var pathWay=pathWays[i];
				pathWay=pathWay.split("^")
				var exists = this.getNodeById(pathWay[0]+"_path");
				//alert(exists)
				if(exists){
					continue;	
				}
				typeNode.appendChild({
						iconCls: 'feed-icon',
            leaf:true,
            //cls:'feed',
            text:pathWay[1],
            id:pathWay[0]+"_path"
				});
			}
	},
	pathWayTypeEdit:function(){   //显示"临床路径类型"窗口方法
		//var pathType=new PathWayType();
		if(!this.pathTypeWin){
							this.pathTypeWin = new PathWayType();
					}else{
								        	
						this.pathTypeWin = new PathWayType();
					}
					this.pathTypeWin.TypeWin.show();
					//this.win.store.load();
	},
	getAllType:function(){
		var GetAllTypeMethod=document.getElementById('GetAllTypeMethod');
		if(GetAllTypeMethod){
			var encmeth=GetAllTypeMethod.value;	
		}	else{
			var encmeth=""	
		}
		var types=cspRunServerMethod(encmeth)
		return types
	},
	getPathByType:function(type){
			var GetPathByTypeMethod=document.getElementById('GetPathByTypeMethod');
			if(GetPathByTypeMethod){
				var encmeth=GetPathByTypeMethod.value;
			}else{
				var encmeth="";
			}
			var pathWays=cspRunServerMethod(encmeth,type);
			return pathWays;
	},
	pathWaysArcim:function(){
		if(this.pathWaysArcimWin){
			this.pathWaysArcimWin=new PathWaysARCIM();
		}else{
			this.pathWaysArcimWin=new PathWaysARCIM();
		}
		this.pathWaysArcimWin.PathARCIMWindow.show();
	},
	StepItemCat:function(){
		if(this.StepItemCatWin){
			this.StepItemCatWin=new StepItemCat();
		}else{
			this.StepItemCatWin=new StepItemCat();
		}
		this.StepItemCatWin.StepItemCatWindow.show()
	},
	StepItemSubCat:function(){
		if(!this.StepItemSubCatWin){
			this.StepItemSubCatWin=new StepItemSubCat();
		}else{
			//this.StepItemSubCatWin=new StepItemSubCat();
		}
		this.StepItemSubCatWin.StepItemSubCatWindow.show()
	}
});

Ext.reg('pathWaypanel', PathWayPanel); 