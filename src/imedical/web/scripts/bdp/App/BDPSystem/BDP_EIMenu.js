/// 名称: 导入导出菜单维护——树形展示（新版）
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-11-3
//***************************************************************************//
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
Ext.onReady(function() {
	 /// 去除compositeField的逗号间隔标志
	Ext.BDP.FunLib.Component.CompositeField  = Ext.extend(Ext.form.CompositeField ,{
		  buildLabel: function(segments) {
	        return segments.join("");
	     },
	     labelSeparator:""
	});
	Ext.reg("compositefield",Ext.BDP.FunLib.Component.CompositeField);


	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPEIMenu";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=DeleteData";

	var MENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=GetMenuForCmb";	
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=GetMenuNew";
    var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=DragNode";
    
    var TableList_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableList&pClassQuery=GetList";
    
    var selectNode="";
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    
	//**********父菜单选择框 初始化treecombo *************//
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "id",
				dataUrl: MENUTREE_ACTION_URL
			});
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
                  iconCls : 'icon-save',
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
                   iconCls : 'icon-close',
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
   var bbox2=new Ext.BoxComponent({
        id: 'imgbox2',//图片id
        hidden: false,//隐藏图片
        xtype: 'box',
        width: 35,
        height: 20,
        style: 'margin-left:35px' 
     });  
   var composite=new Ext.BDP.FunLib.Component.CompositeField ({
						    xtype: 'compositefield',
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
						       },  bbox, ChangeIconBtn,cancelbtn
						    ]
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
                        {name: 'ParentMenuDr',mapping:'ParentMenuDr',type:'string'},
                        {name: 'Image',mapping:'Image',type:'string'},
                        {name: 'Sequence',mapping:'Sequence',type:'int'},
                        {name: 'TableName',mapping:'TableName',type:'string'},
                        {name: 'ClassName',mapping:'ClassName',type:'string'},
                        {name: 'Kglobal',mapping:'Kglobal',type:'string'},
                        {name: 'ImportFlag',mapping:'ImportFlag',type:'string'},
                        {name: 'ExportFlag',mapping:'ExportFlag',type:'string'},
                        {name: 'LockFlag',mapping:'LockFlag',type:'string'},
                         {name: 'LinkTableDr',mapping:'LinkTableDr',type:'string'}
                 ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
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
	                            var className =  "web.DHCBL.BDP.BDPEIMenu";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
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
						},treeCombox, {
							xtype:'numberfield',
							fieldLabel : '显示顺序',
							name : 'Sequence',
							id: 'Sequence',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Sequence'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Sequence')),
							allowDecimals : false, //不允许输入小数
							minValue : 0,
							nanText : '只能是数字'
						}, composite,
					   {
							fieldLabel : '表名',  ///删除私有数据与医院关联用这个
							name : 'TableName',
							id: 'TableName',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TableName'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TableName'))
						}, {
							fieldLabel : '类名（显示日志）',  //导入完成后显示导入日志，根据类名来匹配
							name : 'ClassName',
							id: 'ClassName',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClassName'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClassName'))
						}, {
							fieldLabel : 'Kglobal',
							name : 'Kglobal',
							id: 'Kglobal',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Kglobal'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Kglobal'))
						}, {
							fieldLabel : '在导入菜单显示',
							xtype : 'checkbox',
							inputValue : true ? 'Y' : 'N',
							checked:true,
							name : 'ImportFlag',
							id: 'ImportFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ImportFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ImportFlag'))
						}, {
							fieldLabel : '在导出菜单显示',
							xtype : 'checkbox',
							inputValue : true ? 'Y' : 'N',
							checked:true,
							name : 'ExportFlag',
							id: 'ExportFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ExportFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ExportFlag'))
						}, {
							xtype : 'bdpcombo',
							fieldLabel : '表结构登记',
							name : 'LinkTableDr',
							id:'LinkTableDrF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkTableDr'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkTableDr')),
							hiddenName : 'LinkTableDr',
							store : new Ext.data.Store({   
								proxy : new Ext.data.HttpProxy({ url : TableList_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ID', 'TableDesc' ])
							}),
							loadByIdParam : "RowId",
							queryParam : 'desc',
							mode : 'remote',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'ID',
							displayField : 'TableDesc'
						}, {
							fieldLabel : '是否加锁',  //2022-09-13隐藏
							xtype : 'checkbox',
							hidden:true,
							hideLabel : 'True',
							inputValue : true ? 'Y' : 'N',
							name : 'LockFlag',
							id: 'LockFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LockFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LockFlag'))
						}]
   		 });
 
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 480,
					height:450,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : WinForm,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
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
															treePanel.loadTreeAdd();
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
						text : '关闭',
						iconCls : 'icon-close',
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
                            Ext.getCmp('imgbox').el.dom.src="";
						},
						"close" : function() {}
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
				var seq =tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetSequence",_record.parentNode.id);
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
						//if(!_record.leaf){
							treeCombox.setValue(_record.id)
							Ext.get("treeCombox").dom.value = _record.text;	
							var seq =tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetSequence",_record.id);
							Ext.getCmp("Sequence").setValue(seq)
						//}

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
			                	var ImageValue=tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetIconByID",_record.id);
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

	var treePanel = new Ext.BDP.Component.tree.TreePanel({
		region:'center',
		dataUrl: TREE_ACTION_URL,
		dragUrl: DRAG_ACTION_URL, //拖拽方法
		AddMethod:AddSame, //右键菜单添加本级方法
		comboId:"treeCombox", //下拉树id
		rootId:"TreeRoot",
		nodeParameter: "LastLevel"
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
                    var ImageValue=tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetIconByID",node.id);
                    Ext.getCmp('imgbox').el.dom.src=ImageValue ;
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
		},this,{stopEvent:true});		
	}
	/** 刷新方法 */
	Refresh=function (){
		clearFind();
	}
	
	/** 主面板 */
	var panel = new Ext.Panel({
		title: '导入导出菜单维护',
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
							findByKeyWordFiler(node);
						}
					},
					scope: this
				}
			}), '-', {
				text:'查询',
				iconCls:'icon-search',
				handler:function()
				{
					findByKeyWordFiler(Ext.getCmp("FindTreeText"))
				
				}
			}, '-', {
				text:'清空',
				iconCls:'icon-refresh',
				handler:Refresh //清除树过滤
			}, '-',btnAddwin, '-', btnEditwin, '-', btnDel
		]
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [panel]
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
		
		clearTimeout(timeOutId);// 清除timeOutId
		treePanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			})
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
				return;
			}
		}, 500);
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
			});
		selectNode=""
	}
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);

});
