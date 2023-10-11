/// 名称:东华产品线维护——树形展示（新版）
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2015-10-13
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=SaveData&pEntityName=web.Entity.BDP.DHCProductLine";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;

	var LINECMB_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=GetLineForCmb";
	
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=GetProLineTree";
	
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=DragNode";
	var selectNode="";  //选中节点
	var nodeStr="";
	
	//********** 初始化treecombo *************//
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "id",
				dataUrl: LINECMB_ACTION_URL
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
				name:'ParentDr',
				id:'treeCombox',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
				fieldLabel:"父菜单",
				hiddenName : 'ParentDr',
				anchor:"97%",
				editable : true,
				enableKeyEvents: true,
				tree:menuPanel
			});*/
			
    var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'treeCombox',
		 name: 'ParentDr',
         width : 180,  
         fieldLabel:"父菜单",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
         hiddenName : 'ParentDr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"产品线",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: menuTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });  
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
														    //删除之后 刷新
															Ext.getCmp('FindTreeText').reset();
															hiddenPkgs = [];
															
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
					//tooltip : '请选择一行后删除(Shift+D)',
					iconCls : 'icon-delete',
					handler : DelData
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
                        {name: 'Shorthand',mapping:'Shorthand',type:'string'},
                        {name: 'Type',mapping:'Type',type:'string'},
                        {name: 'Offer',mapping:'Offer',type:'string'},
                        {name: 'ProManMonth',mapping:'ProManMonth',type:'string'},
                        {name: 'Sequence',mapping:'Sequence',type:'int'},
                        {name: 'ImpManMonth',mapping:'ImpManMonth',type:'string'},
                        {name: 'ManMonth',mapping:'ManMonth',type:'string'},
                        {name: 'ParentDr',mapping:'ParentDr',type:'string'},
                        {name: 'InQuotation',mapping:'InQuotation',type:'string'},
                        {name: 'OutQuotation',mapping:'OutQuotation',type:'string'},
                        {name: 'StandaloneFlag',mapping:'StandaloneFlag',type:'string'},
                        {name: 'SalesFlag',mapping:'SalesFlag',type:'string'},
                        {name: 'ActiveFlag',mapping:'ActiveFlag',type:'string'},
                        {name: 'ProDesc',mapping:'ProDesc',type:'string'}
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
							fieldLabel : '<font color=red>*</font>产品线编码',
							name : 'Code',
							id:'CodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.DHCProductLine";  //后台类名称
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
							fieldLabel : '<font color=red>*</font>产品线名称',
							name : 'Caption',
							id :"CaptionF",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CaptionF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CaptionF')),
							allowBlank : false
						}, {
							fieldLabel : '实施分类',
							name : 'Type',							
							id:'TypeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TypeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TypeF')),
							xtype : 'combo',
							hiddenName:'Type',
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['区域医疗','区域医疗'],
									      ['传统HIS','传统HIS'],
									      ['专业系统','专业系统'],
									      ['健康乐','健康乐']
								     ]
							})
						}, {
							fieldLabel : '简写名称',
							name : 'Shorthand',
							id: 'ShorthandF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ShorthandF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ShorthandF'))
						},treeCombox, {
							xtype:'numberfield',
							fieldLabel : '显示顺序',
							name : 'Sequence',
							id: 'SequenceF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SequenceF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SequenceF')),
							allowDecimals : false, //不允许输入小数
							minValue : 0,
							nanText : '只能是数字'
						}, {
							fieldLabel : '产品线描述',
							xtype:'textarea',
							//width:150,
							height:110,
							maxLength:255,
							name : 'ProDesc',
							id: 'ProDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ProDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ProDescF'))
						}
						]
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
							fieldLabel : '产品额定人月',
							xtype:'numberfield',
							name : 'ProManMonth',
							id: 'ProManMonthF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ProManMonthF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ProManMonthF'))
						},
					   {
							fieldLabel : '实施额定人月',
							xtype:'numberfield',
							name : 'ImpManMonth',
							id: 'ImpManMonthF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ImpManMonthF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ImpManMonthF'))
						}, {
							fieldLabel : '人月数',
							xtype:'numberfield',
							name : 'ManMonth',
							id: 'ManMonthF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ManMonthF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ManMonthF')),
							listeners:{
								'blur':function(){
									var manmonth=Ext.getCmp('ProManMonthF').getValue()+Ext.getCmp('ImpManMonthF').getValue();
									Ext.getCmp('ManMonthF').setValue(manmonth)
								}		
							}
						}, {
							fieldLabel : '产品线报价',
							name : 'Offer',
							id: 'OfferF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OfferF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OfferF'))
						 }, {
							fieldLabel : '对内报价',
							name : 'InQuotation',
							id: 'InQuotationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InQuotationF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InQuotationF'))
						}, {
							fieldLabel : '对外报价',
							name : 'OutQuotation',
							id: 'OutQuotationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OutQuotationF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OutQuotationF'))
							}]
						}, {
							xtype: 'fieldset',
				            title: '',
				            autoHeight: true,
				            defaultType: 'checkbox',
				            items: [{
				                checked: true,
				                fieldLabel: '是否独立运行',
				               // boxLabel: '是否独立运行',
				                name: 'StandaloneFlag',
				                inputValue: 'Y',
				                id: 'StandaloneFlagF',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('StandaloneFlagF'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('StandaloneFlagF'))
				            }, {
				            	checked: true,
				                fieldLabel: '是否销售',
				                labelSeparator: '',
				                //boxLabel: '是否销售',
				                name: 'SalesFlag',
				                inputValue: 'Y',
				                id: 'SalesFlagF',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SalesFlagF'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SalesFlagF'))
				            }, {
				            	checked: true,
				                fieldLabel: '是否有效',
				                labelSeparator: '',
				                //boxLabel: '是否有效',
				                name: 'ActiveFlag',
				                inputValue: 'Y',
				                id: 'ActiveFlagF',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ActiveFlagF'))
				            }]
				          }]
					}]
   		 });
 
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 680,
					height:430,
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
							var tempCode = Ext.getCmp("form-save").getForm().findField("Code").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("Caption").getValue();
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '产品线编码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '产品线名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
		    			
			   			 	//alert(WinForm.form.isValid());
			   			 	if(WinForm.form.isValid()==false){return;}
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
								//	waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
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
															//修改之后 刷新
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
							Ext.getCmp("form-save").getForm().findField("Code").focus(true,1000);
						},
						"hide" : function() {
							Ext.BDP.FunLib.Component.FromHideClearFlag();
							//Ext.getCmp("treeCombox").hideTree();
						},
						"close" : function() {}
					}
				});
				
	/** 添加方法 */
	AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					if (treePanel.getSelectionModel().getSelectedNode()) {
						var _record = treePanel.getSelectionModel().getSelectedNode();
						//if(!_record.leaf){
							treeCombox.setValue(_record.id);
							Ext.get("treeCombox").dom.value = _record.text;	
							var seq =tkMakeServerCall("web.DHCBL.BDP.DHCProductLine","GetSequence",_record.id);
							Ext.getCmp("SequenceF").setValue(seq)
							
						//}

					}
					                			             
				}
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				//tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData,
				scope : this
			});
	/** 修改方法 */
	UpdateData=function () {
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
			                	//Ext.Msg.alert('编辑', '载入成功');
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
				//tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData
			});

	/** 添加同级 */			
	function AddSame(){
			win.setTitle('添加');
			win.setIconClass('icon-add');
			win.show('new1');
			WinForm.getForm().reset();
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
				var seq =tkMakeServerCall("web.DHCBL.BDP.DHCProductLine","GetSequence",_record.parentNode.id);
				seq=parseInt(seq)
				Ext.getCmp("SequenceF").setValue(seq)

			}else{
				Ext.getCmp("SequenceF").setValue(0);
			}
	}
	
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
                	var Parent=treePanel.getSelectionModel().getSelectedNode().parentNode.text
                	if(Parent==undefined){
                		Ext.get("treeCombox").dom.value = "";
                	}else{
						Ext.get("treeCombox").dom.value = Parent;                	
                	}
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
		title: '东华产品线维护',
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
			},  '-', {
				text:'重置',
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
					if(n.id!='TreeRoot'){
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
