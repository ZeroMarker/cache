/// 名称: 菜单维护——树形展示（新版）
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍 陈莹
/// 编写日期: 2015-10-13
//***************************************************************************//
var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDP_Menu/BDP_Menu.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/compositefield.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;

	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPMenuDefine";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;

	var MENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=GetMenuForCmb";
	var LinkFuntion_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExecutables&pClassQuery=GetDataForCmb1";
	
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=GetMenuNew";
	var LINECMB_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=GetLineForCmb";
    var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=DragNode";
    var selectNode="";
 	
 	var CHILD_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.FunctionalElement&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.FunctionalElement&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.FunctionalElement';
	var CHILD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.FunctionalElement&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.FunctionalElement&pClassMethod=DeleteData';


	//**********父菜单选择框 初始化treecombo *************//
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "id",
				dataUrl: MENUTREE_ACTION_URL
			});
	/*var menuPanel = new Ext.tree.TreePanel({
				id: 'menuPanel',
				root: new Ext.tree.AsyncTreeNode({
						id:"CatTreeRoot",
						text:"菜单",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: menuTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false
			});
	var treeCombox = new Ext.tet.TreeComboField({
				name:'ParentMenuDr',
				id:'treeCombox',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
				fieldLabel:"父菜单",
				hiddenName : 'ParentMenuDr',
				anchor:"97%",
				editable : true,
				enableKeyEvents: true,
				tree:menuPanel
			});*/

    var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'treeCombox',
		 name: 'ParentMenuDr',
         width : 180,  
         fieldLabel:"父菜单",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
         hiddenName : 'ParentMenuDr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"菜单",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: menuTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });
	
			
	//********** 产品线选择框 初始化treecombo *************//
	var proTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "id",
				dataUrl: LINECMB_ACTION_URL
			});
	/*var proLinePanel = new Ext.tree.TreePanel({
				id: 'menuPanelPro',
				root: new Ext.tree.AsyncTreeNode({
						id:"CatTreeRoot",
						text:"产品线",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: proTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false
			});
	var treeComboxPro = new Ext.tet.TreeComboField({
				name:'ProductLineDr',
				id:'treeComboxPro',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeComboxPro'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeComboxPro')),
				fieldLabel:"关联产品线",
				hiddenName : 'ProductLineDr',
				anchor:"97%",
				editable : true,
				enableKeyEvents: true,
				tree:proLinePanel
			});*/
	    var treeComboxPro = new Ext.ux.TreeCombo({  
		 id : 'treeComboxPro',
         width : 180,  
         fieldLabel:"关联产品线",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeComboxPro'),
         hiddenName : 'ProductLineDr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRootPro",
					text:"产品线",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: proTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });
	/// 名称: 批量隐藏或激活菜单
		
			
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=GetTreeJson2";
	var TREE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=SaveTreeJson2";
    var sessionStr = Ext.BDP.FunLib.Session(); 
    
    
	//**************** 判断全部/已选/未选****************************************//
	var findByRadioCheck = function(flag){
		if(flag=='all'){
			menuPanelG.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
				}
			});
		}
		if(flag=='checked'){
			menuPanelG.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
					if(!n.attributes.checked){
						n.ui.hide();
					}
				}
			});
		}
		if(flag=='unchecked'){
			menuPanelG.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
					var falg = 1;
					if(n.attributes.checked&&n.isLeaf()){
						n.ui.hide();
					}
					else if(n.attributes.checked&&!n.isLeaf()){
						n.cascade(function(n) {
							//if(!n.attributes.checked&&n.isLeaf()){
							if(!n.attributes.checked){
								falg = 0;
								return;
							}
						});
						if (falg == 1)
						{
							n.ui.hide();
						}
						
					}
				}
			});
		}
	}
//**************************************************************//
	/** 菜单面板 */
	var menuTreeLoaderG = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: TREE_QUERY_ACTION_URL 
			});
	
	var menuPanelG = new Ext.tree.TreePanel({
			region: 'center',
			id: 'menuConfigTreePanel',
			expanded:false,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"menuTreeRoot",
					draggable:false,  //可拖拽的
					expanded:false  //根节点自动展开 
					
				}),
			loader: menuTreeLoaderG,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,///
			listeners: {  
					
                    "checkchange": function(node, state) {  
                    	var rs=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","SaveActiveTree",node.id,state) ///2018-03-28
                    }    
  
                },  
			tbar:[{
					xtype:'panel',
					baseCls:'x-plain',
					height:30,
					items:[{
						id : 'radioGroup1',
						xtype : 'radiogroup',
						columns: [60, 60, 60],
			            items : [{
		            		id : 'radio1',
		            		boxLabel : "全部",
		            		name : 'FilterCK',
		            		inputValue : '0',
		            		checked : true,
		            		listeners : {
				            	'check' : function(com, checked){
				            		if(checked){
				            			findByRadioCheck('all');
				            		}
				            	},
				            	scope : this
				            }
		            	}, {
		            		id : 'radio2',
		            		boxLabel : "已选",
		            		name : 'FilterCK',
		            		inputValue : '1',
		            		listeners : {
				            	'check' : function(com, checked){
				            		if(checked){
				            			findByRadioCheck('checked');
				            		}
				            	},
				            	scope : this
				            }
		            	}, {
		            		id : 'radio3',
		            		boxLabel : "未选",
		            		name : 'FilterCK',
		            		inputValue : '2',
		            		listeners : {
				            	'check' : function(com, checked){
				            		if(checked){
				            			findByRadioCheck('unchecked');
				            		}
				            	},
				            	scope : this
				            }
		            	}]
		              }]
					}]
	});

	
	var Tree1Window = new Ext.Window({
	    title: '批量隐藏/激活菜单',
	    closable: true,      
	    width: 350,
	    height: 500,
	    border: false,
	    layout: 'border',
	    modal : true,
		closeAction : 'hide',
	    items: [menuPanelG],
	    buttons: [{
	        text: '关闭',
	        handler: function () { 
	            Tree1Window.hide();
	        }
	    }]
  	});	
  				
		var btnGroup = new Ext.Button({
				id : 'group_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('group_btn'),
				iconCls : 'icon-AdmType',
				text : '批量隐藏/激活',
				handler :function(){
					menuTreeLoaderG.dataUrl=TREE_QUERY_ACTION_URL;
					ssordroot.reload();  //重新加载dataURL和根节点
					Tree1Window.show();
					Ext.getCmp("radioGroup1").setValue("0");
				}
			});	
			
			
//==============================================================菜单维护部分======================================
    /** 删除方法 */
    DelData=function () {
        if (treePanel.getSelectionModel().getSelectedNode()) {
            Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
                if (btn == 'yes') {
                    Ext.Ajax.request({
                        url : DELETE_ACTION_URL,
                        method : 'POST',
                        params : {
                            'id' : treePanel.getSelectionModel().getSelectedNode().id
                        },
                        callback : function(options, success, response) {
                            if (success) {
                                var jsonData = Ext.util.JSON.decode(response.responseText);
                                if (jsonData.success == 'true') {
                                    Ext.Msg.show({
                                        title : '提示',
                                        msg : '数据删除成功!',
                                        icon : Ext.Msg.INFO,
                                        buttons : Ext.Msg.OK,
                                        fn : function(btn) {
                                            Ext.getCmp('FindTreeText').reset();
                                            hiddenPkgs = [];
                                            /*treePanel.on('beforeload', function(){   
                                                treeLoader.dataUrl = LOADMENU_URL ;  
                                                treeLoader.baseParams = {id:"menuTreeRoot"}
                                            });
                                            treePanel.root.reload();
                                            treePanel.getSelectionModel().clearSelections();
                                            treePanel.getView().refresh();*/
                                            treePanel.loadTreeOther();
                                            //树加载完后收缩起来 2021-01-08
                                            /*setTimeout(function() {
                                                treePanel.collapseAll()
                                            }, 800);*/
                                        }
                                    });
                                } else {
                                    var errorMsg = '';
                                    if (jsonData.info) {
                                        errorMsg = '<br/>错误信息:' + jsonData.info
                                    }
                                    Ext.Msg.show({
                                                title : '提示',
                                                msg : '数据删除失败!' + errorMsg,
                                                minWidth : 200,
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                }
                            } else {
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '异步通讯失败,请检查网络连接!',
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                            }
                        }
                    }, this);
                }
            }, this);
        } else {
            Ext.Msg.show({
                        title : '提示',
                        msg : '请选择需要删除的行!',
                        icon : Ext.Msg.WARNING,
                        buttons : Ext.Msg.OK
                    });
        }
    }
    /** 删除按钮 */
    var btnDel = new Ext.Toolbar.Button({
                    text : '删除',
                    id:'del_btn',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
                    tooltip : '请选择一行后删除',
                    iconCls : 'icon-delete',
                    handler : DelData
                });
    
    /** 功能元素删除按钮 */
	var child_btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn'),
		handler :DelData2= function() {
			if (child_grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');

						var gsm = child_grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : CHILD_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ID')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.DelForTruePage(child_grid,pagesize_pop);
												
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接!',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							}
						}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});

    /** 功能定义checkbox数据存储 */
    var ds_LinkFuntion = new Ext.data.Store({
                autoLoad : true,
                proxy : new Ext.data.HttpProxy({ url : LinkFuntion_QUERY_ACTION_URL }),
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        },[{ name:'ID',mapping:'ID'},
                            {name:'Caption',mapping:'Caption'} ])
            });
 
    
    var ChangeIcon_Win = new Ext.Window({
	            id:'changeImage',
	            title:'选择图标',
	            width :640,
	            height :480,
	            layout : 'fit',
	            closeAction : 'hide',
	            buttonAlign : 'center',
                frame:true,
                plain : true,// true则主体背景透明
                modal : true,
	            buttons:[{
	                text : '确定',
	                handler : function() {
	                  //获取iframe的window对象
	                    var topWin =document.getElementById("ChangeIcon").contentWindow;
	                    var ImageValue=topWin.document.getElementById("pictureinput").value
	                    Ext.getCmp('imgbox').el.dom.src=ImageValue ;
	                    Ext.getCmp('Image').setValue(ImageValue);    
	                    ChangeIcon_Win.hide();
	                }
	            },{
	                text : '取消',
	                handler : function() {
	                    ChangeIcon_Win.hide();
	                }
	            }],
	          listeners : {
	                "show" : function() {
	                   
	                },
	                "hide" : function(){
	                     var topWin =document.getElementById("ChangeIcon").contentWindow;
                         topWin.document.getElementById("imagesee").src="../scripts/bdp/Framework/BdpIconsLib/null.png";
	                   },
	                "close" : function() {
	                }
	           }
	});

 	var ChangeIconBtn=new Ext.Button({
                id:'ChangeIconBtn',
                disabled:Ext.BDP.FunLib.Component.DisableFlag('DataLiftBtn'),
                text:'更改图标' ,
                iconCls : 'icon-DP',
                handler:function(){
                		var link="dhc.bdp.bdp.loadpicture.csp"; 
                		if ('undefined'!==typeof websys_getMWToken)
				        {
							link += "?MWToken="+websys_getMWToken() // 增加token
						}
                        ChangeIcon_Win.html='<iframe id="ChangeIcon" src=" '+link+' " width="100%" height="100%" scrolling="no"></iframe>';
                        ChangeIcon_Win.show();
                 } 
            });
    var cancelbtn=new Ext.Button({
                id:'cancelbtn',
                disabled:Ext.BDP.FunLib.Component.DisableFlag('cancelbtn'),
                text:'清除图标' ,
                iconCls : 'icon-AdmType',
                handler:function(){
                        Ext.getCmp('imgbox').el.dom.src="" ;
                        Ext.getCmp('Image').reset();
                 } 
            });
            
    
    
    var bbox=new Ext.BoxComponent({
        id: 'imgbox',//图片id
        hidden: false,//隐藏图片
        xtype: 'box',
        width: 20,
        height: 20,
        style: 'margin-left:5px',
        autoEl: {
            tag: 'img',
            src: '../scripts/bdp/Framework/BdpIconsLib/null.png'
        }
     });
      
  var composite=new Ext.BDP.FunLib.Component.CompositeField ({
                            xtype: 'compositefield',
                            //buildLabel: "",
                            labelWidth: 150,
                            items: [
                                {
                                    xtype     : 'displayfield',
                                    fieldLabel: '图标',
                                    width     : 30,
                                    hidden:true,
                                    name : 'Image',
                                    id: 'Image',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('Image'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Image'))
                               },  bbox, ChangeIconBtn,cancelbtn ]
                          });
	/** 增加修改的FormPanel */					
    var WinForm=new Ext.form.FormPanel({
    			id : 'form-save',
				labelAlign : 'right',
				labelWidth : 130,
				frame:true,
				autoScroll : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                    [
                      	{name: 'ID',mapping:'ID',type:'string'},
                        {name: 'Code',mapping:'Code',type:'string'},
                        {name: 'Caption',mapping:'Caption',type:'string'},
                        {name: 'LinkFuntionDR',mapping:'LinkFuntionDR',type:'string'},
                        {name: 'LinkUrl',mapping:'LinkUrl',type:'string'},
                        {name: 'Image',mapping:'Image',type:'string'},
                        {name: 'Method',mapping:'Method',type:'string'},
                        {name: 'Sequence',mapping:'Sequence',type:'string'},
                        {name: 'ShortcutKey',mapping:'ShortcutKey',type:'string'},
                        {name: 'ShowInNewWindow',mapping:'ShowInNewWindow',type:'string'},
                        {name: 'ParentMenuDr',mapping:'ParentMenuDr',type:'string'},
                        {name: 'ProductLineDr',mapping:'ProductLineDr',type:'string'},
                        {name: 'ValueExpression',mapping:'ValueExpression',type:'string'},
                        {name: 'actMenuBDP',mapping:'actMenuBDP',type:'string'},
                        {name: 'actMenuAutItem',mapping:'actMenuAutItem',type:'string'},
                        {name: 'actMenuAutData',mapping:'actMenuAutData',type:'string'},
                        {name: 'IsMKBMenu',mapping:'IsMKBMenu',type:'string'},
                        {name: 'CompName',mapping:'CompName',type:'string'}
                 ]),
				layout:'column',
				items : [{
					columnWidth:0.5,
					items:[{
						layout:'form',
						defaultType : 'textfield',
						defaults : {
							anchor : '88%',
							border : false
						},
						items:[
						  {
							fieldLabel : 'ID',
							hideLabel : 'True',
							hidden : true,
							name : 'ID'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'Code',
							id:'Code',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Code'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Code')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPMenuDefine";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var id = treePanel.getSelectionModel().getSelectedNode().id; //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							name : 'Caption',
							id :"Caption",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Caption'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Caption')),
							allowBlank : false
						}, {
							fieldLabel : 'URL解析地址',
							name : 'LinkUrl',
							id:'LinkUrl',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkUrl'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkUrl'))
						}, /*{
							xtype:'combo',
							fieldLabel : '功能',
							hiddenName : 'LinkFuntionDR',
							id: 'LinkFuntionDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkFuntionDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkFuntionDRF')),
							store : ds_LinkFuntion,
							listWidth:156,
							mode : 'local',
							queryParam : 'caption',
							forceSelection : true,
						 	triggerAction:'all',
							selectOnFocus : false,//true表示获取焦点时选中既有值
							valueField : 'ID',
							displayField : 'Caption',
							listeners:{
			　　　　　　　　　　　　		//监听每次查询前
			                    'expand':function(combo){
			                    	//alert(combo.getRawValue())
										ds_LinkFuntion.load({
											params : {caption : combo.getRawValue()}
										})
			                    },
			                    'keyup':function(combo){
			                    	//alert(combo.getRawValue())
										ds_LinkFuntion.load({
											params : {caption : combo.getRawValue()}
										})
			                    }
			                    }
						}*/{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'RowId',
							listWidth:250,
							fieldLabel : '功能',
							hiddenName : 'LinkFuntionDR',
							id: 'LinkFuntionDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkFuntionDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkFuntionDRF')),
							store : ds_LinkFuntion,
							mode  : 'local',
							shadow:false,
							queryParam : 'caption',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'ID',
							displayField : 'Caption'
						}, {
							fieldLabel : '组件名称',
							name : 'CompName',
							id: 'CompName',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CompName'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CompName'))
						},treeCombox, {
							xtype:'numberfield',
							fieldLabel : '显示顺序',
							name : 'Sequence',
							id: 'Sequence',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Sequence'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Sequence')),  
							minValue : 0,
							nanText : '只能是数字'
						}, composite ,treeComboxPro]
					}]
				},{
					columnWidth:.5,
					items:[{
							layout:'form',
							defaultType : 'textfield',
							defaults : {
								anchor : '88%',
								border : false
							},
							items:[ 
						{
							fieldLabel : '服务器端类方法',
							name : 'Method',
							id: 'Method',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Method'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Method'))
						},
					   {
							fieldLabel : '版本号',  //2021-08-31 将快捷键 改成 版本号。
							name : 'ShortcutKey',
							id: 'ShortcutKey',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ShortcutKey'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ShortcutKey'))
						}, {
							fieldLabel : '弹出窗口或增加Tab的方式',
							name : 'ShowInNewWindow',
							id: 'ShowInNewWindow',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ShowInNewWindow'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ShowInNewWindow'))
						}, {
							fieldLabel : '值表达式',
							name : 'ValueExpression',
							id: 'ValueExpression',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValueExpression'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValueExpression'))
							}]
						}, {
							xtype: 'fieldset',
				            title: '',
				            autoHeight: true,
				            defaultType: 'checkbox',
				            items: [{
				                checked: true,
				                fieldLabel: '',
				                boxLabel: '激活基础数据维护菜单',
				                name: 'actMenuBDP',
				                inputValue: '1',
				                id: 'actMenuBDP',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('actMenuBDP'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('actMenuBDP'))
				            }, {
				            	checked: true,
				                fieldLabel: '',
				                labelSeparator: '',
				                boxLabel: '激活功能元素授权菜单',
				                name: 'actMenuAutItem',
				                inputValue: '1',
				                id: 'actMenuAutItem',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('actMenuAutItem'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('actMenuAutItem'))
				            }, {
				            	checked: true,
				                fieldLabel: '',
				                labelSeparator: '',
				                boxLabel: '激活基础数据授权菜单',
				                name: 'actMenuAutData',
				                inputValue: '1',
				                id: 'actMenuAutData',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('actMenuAutData'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('actMenuAutData'))
				            }, {
				            	checked: false, 
				            	hideLabel : 'True',   //基础数据平台下菜单维护里 这个标识隐藏掉。以免项目上误选 2021-01-08
								hidden : true,
				                fieldLabel: '',
				                labelSeparator: '',
				                boxLabel: '是否属于医用知识库',
				                name: 'IsMKBMenu',
				                inputValue: 'Y',
				                id: 'IsMKBMenu',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('IsMKBMenu'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('IsMKBMenu'))
							}]
				          }]
					}]
   		 });
 	
 	/** 功能元素增加\修改的Form */
	var child_WinForm = new Ext.form.FormPanel({
				id : 'child-form-save',
				labelAlign : 'right',
				autoScroll:true,////要加在FormPanel里，加在window里不出现滚动条
				labelWidth : 90,
				frame : true, ///baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ID',mapping:'ID',type:'string'},
                                         {name: 'ParRef',mapping:'ParRef',type:'string'},
                                         {name: 'ItemCode',mapping:'ItemCode',type:'string'},
                                         {name: 'ItemName',mapping:'ItemName',type:'string'},
                                         {name: 'ItemType',mapping:'ItemType',type:'string'}
                                   ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ParRef',
							hideLabel : 'True',
							hidden : true,
							readOnly : true,
							name : 'ParRef'
						},{
							fieldLabel : 'ID',
							hideLabel : 'True',
							hidden : true,
							name : 'ID'
						}, {
							fieldLabel : '代码',
							name : 'ItemCode',
							id:'ItemCode',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ItemCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ItemCode'))
						}, {
							fieldLabel : '描述',
							name : 'ItemName',
							id:'ItemName',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ItemName'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ItemName'))
						}, {
							fieldLabel : '按钮类型',
							name : 'ItemType',
							id:'ItemType',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ItemType'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ItemType'))
						}
						]
			});

	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 950,
					height:420,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					constrain : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : WinForm,
					buttons : [{
						text : '保存',
						id:'save_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {
                            var tempImage=Ext.getCmp('Image').getValue(); 
							var tempCode = Ext.getCmp("form-save").getForm().findField("Code").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("Caption").getValue();
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinForm.form.isValid()==false){return;}
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
                                    params:{
                                        'tempImage':tempImage                                    
                                    },
									success : function(form, action) {
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.getCmp('FindTreeText').reset();
															hiddenPkgs = [];
                                                            treePanel.loadTreeAdd();  //loadTreeOther();
                                                            //树加载完后收缩起来 2021-01-08
                                                            /*setTimeout(function() {   
                                                                treePanel.collapseAll()
                                                            }, 800);*/
                                                        }
                                            });
                                        } else {
                                            var errorMsg = '';
                                            if (action.result.errorinfo) {
                                                errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                            }
                                            Ext.Msg.show({
                                                        title : '提示',
                                                        msg : '添加失败!' + errorMsg,
                                                        minWidth : 200,
                                                        icon : Ext.Msg.ERROR,
                                                        buttons : Ext.Msg.OK
                                                    });
                                        }           
                                    },
                                    failure : function(form, action) {
                                        Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
                                    }
                                })
                            } else {
                                Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
                                    if (btn == 'yes') {
                                        WinForm.form.submit({
                                            clientValidation : true, // 进行客户端验证
                                            waitTitle : '提示',
                                            url : SAVE_ACTION_URL,
                                            method : 'POST',
                                            params:{
                                               'tempImage':tempImage                                    
                                            },
                                            success : function(form, action) {
                                                if (action.result.success == 'true') {
                                                    win.hide();
                                                    var myrowid = "rowid=" + action.result.id;
                                                    // var myrowid = jsonData.id;
                                                    Ext.Msg.show({
                                                        title : '提示',
                                                        msg : '修改成功!',
                                                        icon : Ext.Msg.INFO,
                                                        buttons : Ext.Msg.OK,
                                                        fn : function(btn) {
                                                            Ext.getCmp('FindTreeText').reset();
                                                            hiddenPkgs = [];
                                                            treePanel.loadTreeOther();
                                                            //树加载完后收缩起来 2021-01-08
                                                            /*setTimeout(function() {
                                                                treePanel.collapseAll()
                                                            }, 800);*/
                                                        }
                                                    });
                                                } else {
                                                    var errorMsg = '';
                                                    if (action.result.errorinfo) {
                                                        errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                                    }
                                                    Ext.Msg.show({
                                                                title : '提示',
                                                                msg : '修改失败!' + errorMsg,
                                                                minWidth : 200,
                                                                icon : Ext.Msg.ERROR,
                                                                buttons : Ext.Msg.OK
                                                            });
                                                }           
                                            },
                                            failure : function(form, action) {
                                                Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
                                            }
                                        })
                                    }
                                }, this);
                                // WinForm.getForm().reset();
                            }           
                        }
                    }, {
                        text : '取消',
                        handler : function() {
                            win.hide();
                        }
                    }],
                    listeners : {
                        "show" : function() {
                            //Ext.getCmp("form-save").getForm().findField("Code").focus(true,1000);
                        },
                        "hide" : function() {
                            Ext.BDP.FunLib.Component.FromHideClearFlag();
                            //Ext.getCmp("treeCombox").hideTree();
                            //Ext.getCmp("treeComboxPro").hideTree();
                            Ext.getCmp('imgbox').el.dom.src='../scripts/bdp/Framework/BdpIconsLib/null.png';
						},
						"close" : function() {}
					}
				});
	
	/** 功能元素增加\修改窗口 */
	var child_win = new Ext.Window({
		title : '',
		width : 400,
		height:200,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
			handler : function() {

					Ext.MessageBox.confirm('提示', '确定要保存该条数据吗?', function(btn) {
					if (btn == 'yes') {
						if (child_win.title == '添加') {
							child_WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : CHILD_SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										child_win.hide();
										var myrowid = action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
													title : '提示',
													msg : '添加成功!',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														child_grid.getStore().load({
																	params : {
																		start : 0,
																		limit : 1,
																		rowid : myrowid
																	}
																});
													}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '添加失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
		
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
								}
							})
						} else {
							
									child_WinForm.form.submit({
										clientValidation : true, // 进行客户端验证
										waitMsg : '正在提交数据请稍后...',
										waitTitle : '提示',
										url : CHILD_SAVE_ACTION_URL,
										method : 'POST',
										success : function(form, action) {
											// alert(action);
											if (action.result.success == 'true') {
												child_win.hide();
												var myrowid = "rowid=" + action.result.id;
												// var myrowid = jsonData.id;
												Ext.Msg.show({
													title : '提示',
													msg : '修改成功!',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														///Ext.BDP.FunLib.ReturnDataForUpdate("child_grid", CHILD_QUERY_ACTION_URL, myrowid)
														child_grid.getStore().load({
																	params : {
																		start : 0,
																		limit : pagesize_pop
																	}
																});
													}
												});
											} else {
												var errorMsg = '';
												if (action.result.errorinfo) {
													errorMsg = '<br/>错误信息:' + action.result.errorinfo
												}
												Ext.Msg.show({
															title : '提示',
															msg : '修改失败!' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										},
										failure : function(form, action) {
											Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
										}
									})
								
							// WinForm.getForm().reset();
						}
				
					}
					}, this);
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				child_win.hide();
			}
		}],
		listeners : {
			'show' : function() {
				//Ext.getCmp("child-form-save").getForm().findField("RLOrdLocDR").focus(true,800);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});

	function AddSame(){
		win.setTitle('添加');
		win.setIconClass('icon-add');
		win.show('new1');
		WinForm.getForm().reset();
		if (treePanel.getSelectionModel().getSelectedNode()) {
			var _record = treePanel.getSelectionModel().getSelectedNode();
			if(_record){																				
				if(_record.parentNode.id=="TreeRoot")
				{
					treeCombox.setValue("")
					Ext.get("treeCombox").dom.value ="";	
				}
				else
				{
					treeCombox.setValue(_record.parentNode.id)
					Ext.get("treeCombox").dom.value = _record.parentNode.text;
				}
				var seq =tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetSequence",_record.parentNode.id);
				seq=parseInt(seq)
				Ext.getCmp("Sequence").setValue(seq)

			}else{
				Ext.getCmp("Sequence").setValue(0);
			}
		}
	}
	/** 添加方法 */
	AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					if (treePanel.getSelectionModel().getSelectedNode()) {
						var _record = treePanel.getSelectionModel().getSelectedNode();
						if(!_record.leaf){
							treeCombox.setValue(_record.id)
							Ext.get("treeCombox").dom.value = _record.text;	
							var seq =tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetSequence",_record.id);
							Ext.getCmp("Sequence").setValue(seq)
						}

					}
					                			             
				}
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData,
				scope : this
			});
	/** 修改方法 */
	UpdateData=function() {
					var _record = treePanel.getSelectionModel().getSelectedNode();
					if (!_record) {
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			        	//屏蔽当前选中菜单,避免死锁
			        	menuTreeLoader.baseParams = {'id': _record.id};
			        	win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.id,
			                success : function(form,action) {
		                		var ParentMenu=treePanel.getSelectionModel().getSelectedNode().parentNode.text;
			                	if(ParentMenu==undefined){
			                		Ext.get("treeCombox").dom.value = "";
			                	}else{
									Ext.get("treeCombox").dom.value = ParentMenu;                	
			                	}
			                	var proDesc = tkMakeServerCall("web.DHCBL.BDP.DHCProductLine","GetProDesc", _record.id);//用tkMakeServerCall函数实现与后台同步调用交互
			                	Ext.get("treeComboxPro").dom.value = proDesc;
			                	var ImageValue=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",_record.id);
                                Ext.getCmp('imgbox').el.dom.src=ImageValue ;
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData
			});
	/** 功能元素store */
	var child_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'ParRef',
									mapping : 'ParRef',
									type : 'string'
								}, {
									name : 'ItemCode',
									mapping : 'ItemCode',
									type : 'string'
								}, {
									name : 'ItemName',
									mapping : 'ItemName',
									type : 'string'
								}, {
									name : 'ItemType',
									mapping : 'ItemType',
									type : 'string'
								}// 列的映射
						])
			});
	/** 加载前设置参数 */
	child_ds.on('beforeload',function() {
			var parref=treePanel.getSelectionModel().getSelectedNode().id
					Ext.apply(child_ds.lastOptions.params, {
				    	ParRef : parref
				    });
			},this);
	/** 功能元素child_grid */
	var child_grid = new Ext.grid.GridPanel({
				id : 'child_grid',
				region : 'center',
				closable : true,
				store : child_ds,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						},{
							header : 'ParRef',
							sortable : true,
							dataIndex : 'ParRef',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'ItemCode',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'ItemName',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						}, {
							header : '按钮类型',
							sortable : true,
							dataIndex : 'ItemType'
						}],
				//title : '菜单 功能元素',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					}),
				tbar : new Ext.Toolbar({
						  items : ['代码',{
										xtype: 'textfield',
										id: 'TextItemCode',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextItemCode')
									},'-',
									'描述',{
										xtype: 'textfield',
										id: 'TextItemDesc',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextItemDesc')
									}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch'),
													handler : function() {
																child_grid.getStore().baseParams={
																	code : Ext.getCmp('TextItemCode').getValue(),
																	desc : Ext.getCmp('TextItemDesc').getValue()
															 	};
																child_grid.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh'),
														handler : function() {
															Ext.getCmp('TextItemCode').reset();
															Ext.getCmp('TextItemDesc').reset();
															child_grid.getStore().baseParams={};
															child_grid.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton.render(child_grid.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});

	child_grid.on('rowdblclick', function(child_grid) {
		var _record = child_grid.getSelectionModel().getSelected();
		if (!_record) {
            Ext.Msg.show({
					title : '提示',
					msg : '请选择需要修改的行!',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
				});
        } else {
            child_win.setTitle('修改');
			child_win.setIconClass('icon-update');
			child_win.show('');
			 Ext.getCmp("child-form-save").getForm().load({
                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('ID'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                	
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
        }
	});
			
	/** 功能元素窗口 */	
	var child_list_win = new Ext.Window({
		iconCls : 'icon-DP',
		width : Ext.getBody().getWidth()*0.96,
		height : Ext.getBody().getHeight()-180,//Ext.getBody().getHeight()*0.9,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		//frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		//bodyStyle : 'padding:3px',
		constrain : true,
		closeAction : 'hide',
		items : [child_grid],
		listeners : {
			"show" : function(){
				/*keymap_main.disable();
				keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData2,UpdateData2,DelData2);*/
				
			},
			"hide" : function(){
				/*keymap_pop.disable();
				keymap_main.enable();*/
				
			},
			"close" : function(){
			}
		}
	});			
	/** 功能元素按钮 */
	var btnItem = new Ext.Toolbar.Button({
		text : '功能元素',
		tooltip : '功能元素',
		id:'btnItem',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnItem'),
		iconCls : 'icon-DP',
		handler : function() {
			if (treePanel.getSelectionModel().getSelectedNode()) {
				Ext.getCmp('TextItemCode').reset();
				Ext.getCmp('TextItemDesc').reset();
				child_ds.removeAll();
				child_ds.baseParams={};
				child_ds.load({
						params : {
								start : 0,
								limit : pagesize_pop
							}
					});
				var desc=treePanel.getSelectionModel().getSelectedNode().text

				child_list_win.setTitle(desc);
				child_list_win.show();
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择菜单!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	/** 功能元素维护工具条 */
	var child_tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn'),
								handler : AddData2=function () {
									treePanel.getSelectionModel().getSelectedNode().id
									
									var ParRef = treePanel.getSelectionModel().getSelectedNode().id
									child_win.setTitle('添加');
									child_win.setIconClass('icon-add');
									child_win.show('new1');
									child_WinForm.getForm().reset();
									child_WinForm.getForm().findField('ParRef').setValue(ParRef);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn'),
									handler : UpdateData2=function () {
										var _record = child_grid.getSelectionModel().getSelected();
										if (!_record) {
								            Ext.Msg.show({
												title : '提示',
												msg : '请选择需要修改的行!',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
								        } else {
								            child_win.setTitle('修改');
											child_win.setIconClass('icon-update');
											child_win.show('');
											 Ext.getCmp("child-form-save").getForm().load({
								                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('ID'),
								                waitMsg : '正在载入数据...',
								                success : function(form,action) {
								                    //Ext.Msg.alert(action);
								                	//Ext.Msg.alert('编辑', '载入成功');
								                	
								                },
								                failure : function(form,action) {
								                	Ext.Msg.alert('编辑', '载入失败');
								                }
								            });
								        }
									},
									scope : this
								}), '-', child_btnDel]
		});


	var treePanel = new Ext.BDP.Component.tree.TreePanel({
		region:'center',
		dataUrl: TREE_ACTION_URL,
		dragUrl: DRAG_ACTION_URL, //拖拽方法
		AddMethod:AddSame, //右键菜单添加本级方法
		comboId:"treeCombox", //下拉树id
		rootId:"TreeRoot",
		nodeParameter: "LastLevel",
		expandFlag:0
	});
	treePanel.on("click",function(node,event){
        selectNode=node.id
	})
	
	/** 给菜单树加监听 */
	if(treePanel){
		treePanel.on("dblclick",function (node, e){
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + node.id,
                success : function(form,action) {
                	var PHICLastLevel=treePanel.getSelectionModel().getSelectedNode().parentNode.text
                	if(PHICLastLevel==undefined){
                		Ext.get("treeCombox").dom.value = "";
                	}else{
						Ext.get("treeCombox").dom.value = PHICLastLevel;                	
                	}
                	var proDesc = tkMakeServerCall("web.DHCBL.BDP.DHCProductLine","GetProDesc",node.id);//用tkMakeServerCall函数实现与后台同步调用交互
			        Ext.get("treeComboxPro").dom.value = proDesc;
                    var ImageValue=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",node.id);
                    Ext.getCmp('imgbox').el.dom.src=ImageValue ;
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
		},this,{stopEvent:true});
		
		/*treePanel.on("contextmenu",function (node, e){
			if(this.nodemenu==null){
			this.nodemenu=new Ext.menu.Menu({  			
				items: [
	    		{
		            iconCls :'icon-add',
		            handler: AddData,
		            id:'menuAddData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
		            text: '添加'
		        },{
		            iconCls :'icon-Update',
		            handler: UpdateData,
		             id:'menuUpdateData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'),
		            text: '修改'
		        },{
		            iconCls :'icon-delete',
		            handler: DelData,
		            id:'menuDelData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDelData'),
		            text: '删除'
		         },{
		            iconCls :'icon-refresh',
		            handler: Refresh,
		            id:'menuRefresh',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuRefresh'),
		            text: '刷新'
		        }]     	
			}); 
			}
		
			this.nodemenu.showAt(e.getXY());//menu的showAt，不要忘记
			this.getSelectionModel().select(node);
		});*/
		
	}
	/** 刷新方法 */
	Refresh=function (){
		treePanel.expandFlag=1;
		treePanel.nodeStr="";
		clearFind();
		treePanel.collapseAll()
	}
	
	/** 主面板 */
	var panel = new Ext.Panel({
		title: '菜单维护',
		layout:'border',
		region:'center',
		items:[treePanel],
		tools:Ext.BDP.FunLib.Component.HelpMsg,
		tbar:[
			'查询',
			new Ext.form.TextField({
				id:'FindTreeText',
				width:200,
				emptyText:'请输入查找内容，回车查询',
				enableKeyEvents: true,
				listeners:{
					keyup:function(node, event) {
						if (event.getKey() == 13) {  ///2020-03-21chenying 回车检索
							if(node.getValue()!=""){
								findByKeyWordFiler(node);
							}else{
								Refresh()
							}
						}
					},
					scope: this
				}
			}),'-', {
				text:'查询',
				iconCls:'icon-search',
				handler:function()
				{
					if (Ext.getCmp("FindTreeText").getValue()!=""){
						findByKeyWordFiler(Ext.getCmp("FindTreeText"))
					}else{
						Refresh()
					}
				}
			},  '-', {
				text:'清空',
				iconCls:'icon-refresh',
				handler:Refresh //清除树过滤
			}, '-',btnAddwin, '-', btnEditwin, '-', btnDel, '-', btnItem,'-', btnGroup
		]
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [panel],
		listeners:{
			'afterlayout':function(){
				
				//树加载完后收缩起来 2021-01-08
				setTimeout(function() {
					treePanel.collapseAll()
				}, 800);
			}
		}
	});
/*******************************检索功能********************************/	
	var timeOutId = null;
	var treeFilter = new Ext.tree.TreeFilter(treePanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node) {
		treePanel.expandFlag=0;
		treePanel.nodeStr="";
		treePanel.expandAll();// 展开树节点
			
		clearTimeout(timeOutId);// 清除timeOutId
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					return !n.isLeaf() || re.test(n.text);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				treePanel.root.cascade(function(n) {
					if((n.id!='0')&&(n.id!='TreeRoot')){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				clearFind();
				return;
			}
			
		}, 800);
	}
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			if(n1.isLeaf()){
				if(re.test(n1.text)){ str=true;return; }
			} else {
				if(re.test(n1.text)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		treePanel.root.cascade(function(n) {
				if(n.id!='TreeRoot'){
					n.ui.show();
				}
				if(n.id==selectNode){
					n.unselect();  //取消树节点选择状态
				}
				n.ui.show(); /// 清空后重新加载
		});
		selectNode=""
	}
	/** 调用keymap */
   // Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);

});
