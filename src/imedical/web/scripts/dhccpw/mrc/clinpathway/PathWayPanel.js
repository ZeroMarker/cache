/*!
 * ��д����:2010-04-26
 * ���ߣ������
 * ˵����ҳ�������panel�еĴ���
 * ���ƣ�PathWayPanel.js
 */
PathWayPanel = function() {
	
	//�ٴ�·��ά�� ��������ά�� �����˵�����
	this.typeMenu = new Ext.menu.Menu({
        id: 'mainMenu'
        ,style: {
            overflow: 'visible'     // For the Combo popup
        }
        ,items: [
            {
                text: '·������ά��',
                handler: this.pathWayTypeEdit
            },{
	            text:'�ٴ�·��ά��',
	            handler: this.showWindow
	        },'-',{
        		text:'����ԭ��ά��',
            	handler:function(){
	                this.objWinVarReason = new InitWinVarReason();
	                this.objWinVarReason.WinVarReason.show();
        		}
            },{
            	text:'��������ά��',
                handler:function(){
                	this.objWinVarCateg = new InitWinVarCateg();
                	this.objWinVarCateg.WinVarCateg.show();
                }
            },{
            	text:'��Ŀ����ά��',
            	handler:this.StepItemCat	
            },{
            	text:'��Ŀ����ά��',
            	handler:this.StepItemSubCat
            },'-',{
            	text:'�ٴ�·��������',
                handler:function(){
	                this.objWinImportClinPathWay = new InitWinImportClinPathWay();
	                this.objWinImportClinPathWay.WinImportClinPathWay.show();
            	}
			}
        ]
    });
    
    //�ٴ�·��ά�� �����嶨��
	PathWayPanel.superclass.constructor.call(this, {
        id:'way-tree',
        region:'west',
        title:'',
        split:true,
        width: 300,
        minSize: 175,
        maxSize: 400,
        buttonAlign:'center',
        collapsible: true,  		                                //��Panel�Ƿ��������
        margins:'0 0 5 5',
        cmargins:'0 5 5 5',
        rootVisible:false,                                          //root�ڵ��Ƿ�ɼ�
        lines:false,
        autoScroll:true,    		                                //�Ƿ��Զ�����������
        root: new Ext.tree.TreeNode('�ٴ�·��')                     //root Ϊ�����һ�������
        ,tbar: [
	        {            										    //panel ������������
	        	iconCls:'add-way'
	    		,text: '���ҳ���·��'
	            ,handler: function(){
	            	this.PathWayDeptWin=new PathWayDept();
	            	this.PathWayDeptWin.PathDeptWin.show();
	            }
	            ,scope: this
	        }
	        ,{
	            text:'��������ά��'
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
                this.fireEvent('feedselect', node.attributes);    //***����PathWayViewer.js�е�feedselect����
            }
        },
        scope:this
    });
    this.addEvents({feedselect:true});
    
    this.on('contextmenu', this.onContextMenu, this);     //�����������ٴ�·���Ҽ��˵��¼�
    this.loadTypes();                                     //�����������ٴ�·������
    this.addListener("beforeexpandnode",function(node,e){ //�����ٴ�·�����ͽڵ�չ���¼�
    	if(node.parentNode){
    		this.loadPathWays(node);
    	}
    },false,false);
};

Ext.extend(PathWayPanel, Ext.tree.TreePanel, {
    onContextMenu : function(node, e){                    //�����ٴ�·�����һ�ʱ���ɵĲ˵�
		this.node=node;
        if(!this.menu){
            this.menu = new Ext.menu.Menu({
                id:'main-ctx',
                items: [
                	/*********************************************************************
	                // update by zf 2010-11-03
	                //ɾ���Ҽ��˵�[����]����
	                //�����Ҽ��˵�[ɾ��]����
	                {
	                    text:'ɾ���ٴ�·��',                         //ɾ��һ�����
	                    iconCls:'delete-icon',
	                    scope: this,
	                    handler:function(){
	                    	var idStr=this.node.id.split("_");
							var pathRowid=idStr[0];
	                    	Ext.MessageBox.confirm('Confirm', '��ȷ��Ҫɾ�����ٴ�·����?', function(btn,text){
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
							        	ExtTool.alert("��ʾ","ɾ��ʧ��!");	
							        }
								}
							});
	                    }
	                },'-',
	                *********************************************************************/
	                {
	                    iconCls:'add-way',
	                    text:'�ٴ�·��ά��',
	                    handler: function(){
	                    	var nodeRowid=this.node.id.split("_");
	                    	var pathRowid=nodeRowid[0];
							this.win = new EditPathWay(pathRowid);
							this.win.PathWayWin.show();	
	                    },
	                    scope: this
	                },{
	                    iconCls:'add-way',
	                    text:'ָ�����ÿ���',
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
	                    text:'·���׶�ά��',
	                    scope: this,
	                    handler: function(){
	                    	this.PathWayEp=new PathWayEp(this.node);
							this.PathWayEp.PathWayEpWin.show();
	                    }
	                },
	                {
	                    iconCls:'add-way',
	                    text:'��ع���ά��',
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
            //�߶ȼ��
	          var arr=e.getXY()
		        var menuNum=Ext.getCmp('main-ctx').items.length        //�˵����ĸ���
		        var mainHeight=Ext.getCmp('way-tree').getSize().height  //��treepanel�ĸ߶�
		        var mainTop=Ext.getCmp('way-tree').getPosition()[1]      //��treepanel��Top
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
    showWindow : function(btn){       //��ʾ"�ٴ�·���༭"���ڵķ���
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
    removePath: function(node){    //ɾ��һ���ٴ�·�����
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
        	ExtTool.alert("��ʾ","ɾ��ʧ��!");	
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
    		this.root.appendChild(   //Ϊ���ڵ�����ӽڵ�
       		new Ext.tree.TreeNode({
            text:type[1],
            id:type[0]+"_type",
            cls:'ways-node',
            expanded:false,
            expandable:true
        	})
				)
		}
		this.root.appendChild(   //Ϊ���ڵ�����ӽڵ�
       		new Ext.tree.TreeNode({
            text:"����",
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
	pathWayTypeEdit:function(){   //��ʾ"�ٴ�·������"���ڷ���
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