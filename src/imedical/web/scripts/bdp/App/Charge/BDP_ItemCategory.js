
/// 名称: 收费项目分类
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-10-30
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.BDP.FunLib.SortTableName = "User.BDPItemCategory";
	Ext.BDP.FunLib.TableName="BDP_ItemCategory"
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPItemCategory";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=DeleteData";
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=GetTreeJson";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=GetTreeComboJson";
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=DragNode";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var selectNode="";
	var types="ItemCat";
	
	Ext.BDP.FunLib.SortTableName = "User.BDPItemCategory";
	//////////////////////////////日志查看 ////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
   ///日志查看按钮是否显示
   var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogflag==1)
   {
      btnlog.hidden=false;
    }
    else
    {
       btnlog.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogflag==1)
   {
      btnhislog.hidden=false;
    }
    else
    {
       btnhislog.hidden=true;
    }  
   btnhislog.on('click', function(btn,e){    
   var RowID="",Desc="";
   if (treePanel.getSelectionModel().getSelectedNode()) {
     
       RowID=treePanel.getSelectionModel().getSelectedNode().id;
       Desc=treePanel.getSelectionModel().getSelectedNode().text;
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
  
    //多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		
		 ///切换树的时候， 要清空隐藏额树的数组
		 Ext.getCmp('FindTreeText').reset();
		 hiddenPkgs = [],selectNode="",HiddenCat="",HiddenCaption="";
		 treePanel.store.load(); 
		 
		
	});
	//多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (panel.getSelectionModel().getSelectedNode()) { //选中一条数据数据时，弹出 数据与医院关联窗口
				var rowid=panel.getSelectionModel().getSelectedNode().id;
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
  
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
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
												//加下面两段代码，否则删除后，没选中数据点击修改按钮，会弹出修改窗口
												/*treePanel.getSelectionModel().clearSelections();
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
						msg : '请选择需要删除的收费项目分类!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
				}
			}
	});
	var comboTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "ParentID",
			dataUrl: TREE_COMBO_URL
		});
	comboTreeLoader.on("beforeload", function(treeLoader, node) { 
		treeLoader.baseParams.hospid=hospComp.getValue();
    }, this);
	/*var comboTreePanel = new Ext.tree.TreePanel({
			id: 'treeComboPanel',
			root: new Ext.tree.AsyncTreeNode({
					id:"CatTreeRoot",
					text:"父菜单",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
				}),
			loader: comboTreeLoader,
			//boxMaxHeight:30,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false
		});
	var treeCombox = new Ext.tet.TreeComboField({
			name:'ParentCatDr',
			id:'treeCombox',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
			fieldLabel:"父菜单",
			hiddenName : 'ParentCatDr',
			anchor:"97%",
			editable : true,
			enableKeyEvents: true,
			tree:comboTreePanel
		});*/
    
     var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'treeCombox',
		 name:'ParentCatDr', 
         width : 180,  
         fieldLabel:"上级分类",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
         hiddenName : 'ParentCatDr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"分类",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: comboTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });  
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				frame : true,
				//autoScroll : true,
				//bodyStyle : 'overflow-x:hidden; overflow-y:scroll',
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'ID',mapping:'ID',type:'string'},
                         {name: 'Code',mapping:'Code',type:'string'},
                         {name: 'Caption',mapping:'Caption',type:'string'},
                         {name: 'ParentCatDr',mapping:'ParentCatDr',type:'string'},
                         {name: 'Sequence',mapping:'Sequence',type:'string'},
                         {name: 'ActiveFlag',mapping:'ActiveFlag',type:'string'},
                         {name: 'Type',mapping:'Type',type:'string'}
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
							id:'CodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CodeF')),
							allowBlank : false,
							blankText : '代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.BDPItemCategory";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var id = treePanel.getSelectionModel().getSelectedNode().id; //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
							id:'CaptionF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CaptionF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CaptionF')),
							allowBlank : false,
							blankText : '描述不能为空',
							validationEvent : 'blur'
						}, treeCombox, {
							fieldLabel : '顺序',
							name : 'Sequence',
							id:'SequenceF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SequenceF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SequenceF'))
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否激活',
							name : 'ActiveFlag',
							id:'ActiveFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						
						}]
			});
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 460,
		height : 320,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : WinForm,
		buttons : [{
			text : '保存',
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {

				var tempCode = Ext.getCmp("CodeF").getValue();
				var tempDesc = Ext.getCmp("CaptionF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			//if(WinForm.form.isValid()==false){return;}
 
				if (win.title == "添加") {
					
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
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
								success : function(form, action) {
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid=" + treePanel.getSelectionModel().getSelectedNode().id; 
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
				Ext.getCmp("form-save").getForm().findField("Code").focus(true,800);
			},
			"hide" : function() {
							Ext.BDP.FunLib.Component.FromHideClearFlag();
							//Ext.getCmp("treeCombox").hideTree();
						},
			"close" : function() {}
		}
	});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					
					if (treePanel.getSelectionModel().getSelectedNode()) {
						var _record = treePanel.getSelectionModel().getSelectedNode();
						if(!_record.leaf){
							treeCombox.setValue(_record.id)
							Ext.get("treeCombox").dom.value = _record.text;
							var seq =tkMakeServerCall("web.DHCBL.CT.BDPItemCategory","GetSequence",_record.id);
							Ext.getCmp("SequenceF").setValue(seq);
						}

					}
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'update_btn',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					var _record = treePanel.getSelectionModel().getSelectedNode();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的收费项目分类!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				  	}else {			        	
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + treePanel.getSelectionModel().getSelectedNode().id,
			                success : function(form,action) {
			                	var ParentCatDr=treePanel.getSelectionModel().getSelectedNode().parentNode.text;
			                	if(ParentCatDr==undefined){
			                		Ext.get("treeCombox").dom.value = "";
			                	}else{
									Ext.get("treeCombox").dom.value = ParentCatDr;                	
			                	}
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
		        } 
			});
			
	/** 添加同级 */			
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
				var seq =tkMakeServerCall("web.DHCBL.CT.BDPItemCategory","GetSequence",_record.parentNode.id);
				seq=parseInt(seq)
				Ext.getCmp("SequenceF").setValue(seq)

			}else{
				Ext.getCmp("SequenceF").setValue(0);
			}
		}
	}
	
	/*var treeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "LastLevel",
			dataUrl: TREE_ACTION_URL
		});
	treeLoader.on("beforeload", function(treeLoader, node) {
		
    }, this);  
	var treePanel = new Ext.tree.TreePanel({
		region:'center',
		id: 'catConfigTreePanel',
		expanded:true,
		border:true,
		root: new Ext.tree.AsyncTreeNode({
				id:"TreeRoot",
				draggable:false, //可拖拽的
				expanded:true  //根节点自动展开
			}),
		loader: treeLoader,
		autoScroll: true,
		containerScroll: true,
		rootVisible:false,
        listeners:{
        	"click":function(node,event) {
        		selectNode=node.id
			}
        }
	});*/
    
    var treePanel = new Ext.BDP.Component.tree.TreePanel({
		region:'center',
		rootId : "TreeRoot",
		nodeParameter :"LastLevel",
		dataUrl: TREE_ACTION_URL,
		dragUrl: DRAG_ACTION_URL, //拖拽方法
		AddMethod:AddSame, //右键菜单添加本级方法
		comboId:"treeCombox" //下拉树id
	});
	
    treePanel.loader.on("beforeload", function(treeLoader, node) {
			treeLoader.baseParams.hospid=hospComp.getValue();
		}, this); 
	if(treePanel){
		treePanel.on("dblclick",function (node, e){
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + node.id,
                success : function(form,action) {
                	var ParentCatDr=treePanel.getSelectionModel().getSelectedNode().parentNode.text
                	if(ParentCatDr==undefined){
                		Ext.get("treeCombox").dom.value = "";
                	}else{
						Ext.get("treeCombox").dom.value = ParentCatDr;                	
                	}
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
		},this,{stopEvent:true});
		
	}

	var panel = new Ext.Panel({
		title: '收费项目分类',
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
				text:'重置',
				iconCls:'icon-refresh',
				handler:Refresh=function(){
						clearFind();
					} //清除树过滤
			}, '-',btnAddwin, '-', btnEditwin, '-', btnDel,'-',HospWinButton  ///多院区医院
			,'->',btnlog,'-',btnhislog
		]
	});
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [GenHospPanel(hospComp),panel]  //多院区医院
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
					if(n.id!='0'){
						n.ui.show();
					}
					if(n.id==selectNode){
						n.unselect();  //取消树节点选择状态
					}
			});
		selectNode=""

	}
	/*************************************************************/
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
