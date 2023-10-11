/// 名称: 药品成分字典
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2016-8-19
document.write('<script type="text/javascript" src="../scripts/bdp/App/KB/Dic/GenericDataPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtIngr";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=DeleteData";
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=GetTreeJson";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=GetTreeComboJson";
	var Tree_BATCH_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=GetTreeJson";
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=DragNode";
	var SAVE_DROP_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=SaveDropData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var DrugId = tkMakeServerCall("web.DHCBL.KB.DHCPHLibCat","GetDrugId","DRUG");  //默认药品的值
	var selectNode="";
	var ObjectReference="";
	
	/*************************代码自动生成配置开始************************************/
	var AutoCodeForm = new Ext.form.FormPanel({
		id:'AutoCodeForm',
		labelAlign:'right',
		labelWidth:100,
		frame :true,
		defaultType : 'textfield',
		items:[{
            fieldLabel :'手动输入代码',
            name: 'AutoCode',
            id:'AutoCodeF',
            xtype:'checkbox',
            width: 'auto',
            checked:true,
			inputValue : true?'Y':'N',
			listeners:{
				'check':function(checked){
					   if(checked.checked){
							Ext.getCmp("CodeLenF").setDisabled(true);
							Ext.getCmp("StartCodeF").setDisabled(true);

						}else{
							Ext.getCmp("CodeLenF").setDisabled(false);
							Ext.getCmp("StartCodeF").setDisabled(false);

						}
					
				}
			}
            
        },{
            fieldLabel : '<font color=red>*</font>代码长度',
            name: 'CodeLen',
            xtype:'numberfield',
            id:'CodeLenF',
            disabled:true
        },{
            fieldLabel : '<font color=red>*</font>代码起始字符',
            name: 'StartCode',
            id:'StartCodeF',
            disabled:true,
            regex:/^[a-zA-Z]+$/,
			regexText : '只能输入英文字符'
        }]
	});
	/****代码生成规则窗口***/
	var AutoCodeWin=new Ext.Window({
		title:'代码生成规则',
		width:340,
        height:240,
		layout:'fit',
		plain : true,//true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign:'center',
		closable:false,
	 	closeAction:'hide',   
		items: [AutoCodeForm],
		buttons:[{
				text:'保存',
				iconCls : 'icon-save',
				handler:function(){
					if(AutoCodeForm.form.isValid()==false){return;}
					var AutoCode=Ext.getCmp('AutoCodeF').getValue();
					var CodeLen=Ext.getCmp('CodeLenF').getValue();
					var StartCode=Ext.getCmp('StartCodeF').getValue();
					var saveflag =tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","SaveAutoCode",AutoCode,CodeLen,StartCode);
					if (AutoCode!=true)
					{
						if (CodeLen=="") {
		    				Ext.Msg.show({ title : '提示', msg : '代码长度不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			return;
		    			}
		    			if (StartCode=="") {
		    				Ext.Msg.show({ title : '提示', msg : '代码起始字符不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			return;
		    			}
		    			if (saveflag==2)
					    {
							Ext.Msg.show({ title : '提示', msg : '代码起始字符的长度要小于代码长度!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
							return;
						}
					}
					if (saveflag==""){
						Ext.Msg.show({ title : '提示', msg : '保存失败!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
					}else{
						Ext.Msg.show({ title : '提示', msg : '保存成功!', minWidth : 200, icon : Ext.Msg.INFO, buttons : Ext.Msg.OK });
						AutoCodeWin.hide();
					}
					
			}
		},{
			text : '关闭',
			iconCls : 'icon-close',
			handler:function(){
		  		Ext.getCmp('AutoCodeForm').getForm().reset();
				AutoCodeWin.hide();
			}
		}] 
	});

	/** 配置按钮 */
	var btnConfig = new Ext.Toolbar.Button({
		text : '配置',
		tooltip : '配置自动生成代码规则',
		iconCls : 'icon-config',
		id:'btnConfig',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnConfig'),
		handler : showNationalData=function () {
			AutoCodeWin.show();
			var AutoCode=tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","ShowAutoCode","AutoCode");
			var CodeLen=tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","ShowAutoCode","CodeLen");
			var StartCode=tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","ShowAutoCode","StartCode");
			if(AutoCode=="") {AutoCode=true}
			Ext.getCmp("AutoCodeF").setValue(AutoCode);
			Ext.getCmp("CodeLenF").setValue(CodeLen);
			Ext.getCmp("StartCodeF").setValue(StartCode);
		},
		scope : this
	});
	/*************************代码自动生成配置结束************************************/
	
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
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
						msg : '请选择需要删除的分类!',
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
    var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'treeCombox',
         width : 180,  
         fieldLabel:"上级分类",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
         name:'PHEINGLastLevel',
         hiddenName : 'PHEINGLastLevel',  
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
/*	var comboTreePanel = new Ext.tree.TreePanel({
			id: 'treeComboPanel',
			root: new Ext.tree.AsyncTreeNode({
					id:"CatTreeRoot",
					text:"分类",
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
			name:'PHEINGLastLevel',
			id:'treeCombox',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
			fieldLabel:"上级分类",
			hiddenName : 'PHEINGLastLevel',
			anchor:"97%",
			editable : true,
			enableKeyEvents: true,
			tree:comboTreePanel
		});*/
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				frame : true,
				//autoScroll : true,
				//bodyStyle : 'overflow-x:hidden; overflow-y:scroll',
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'PHEINGRowId',mapping:'PHEINGRowId',type:'string'},
                         {name: 'PHEINGCode',mapping:'PHEINGCode',type:'string'},
                         {name: 'PHEINGDesc',mapping:'PHEINGDesc',type:'string'},
                         {name: 'PHEINGLastLevel',mapping:'PHEINGLastLevel',type:'string'},
                         {name: 'PHEINGLevel',mapping:'PHEINGLevel',type:'string'},
                         {name: 'PHEINGRelation',mapping:'PHEINGRelation',type:'string'},
                         {name: 'PHEINGPivaTotalQty',mapping:'PHEINGPivaTotalQty',type:'string'},
                         {name: 'PHEINGActiveFlag',mapping:'PHEINGActiveFlag',type:'string'},
                         {name: 'PHEINGSysFlag',mapping:'PHEINGSysFlag',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHEINGRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHEINGRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PHEINGCode',
							id:'PHEINGCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGCodeF')),
							allowBlank : false,
							blankText : '代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHExtIngr";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var id = treePanel.getSelectionModel().getSelectedNode().id; //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
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
							name : 'PHEINGDesc',
							id:'PHEINGDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGDescF')),
							allowBlank : false,
							blankText : '描述不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHExtIngr";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var id = treePanel.getSelectionModel().getSelectedNode().id; //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, treeCombox, {
							fieldLabel : '级别',
							name : 'PHEINGLevel',
							id:'PHEINGLevelF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGLevelF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGLevelF'))
						},{
							xtype : 'combo',
							fieldLabel : '关系',
							name : 'PHEINGRelation',
							hiddenName : 'PHEINGRelation',
							id:'PHEINGRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGRelationF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGRelationF')),
							editable:false,
							width : 100,
							labelWidth:30,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['>','大于'],
									      ['<','小于'],
									      ['=','等于'],
									      ['!>','不大于'],
									      ['!<','不小于'],
									      ['<>','不等于']
								     ]
							})
						}, {
							fieldLabel : '配液整组含量',
							name : 'PHEINGPivaTotalQty',
							id:'PHEINGPivaTotalQtyF',
							regex: /^\d+(\.\d+)?$/, 
							regexText:"请输入浮点数！", 
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGPivaTotalQtyF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGPivaTotalQtyF'))
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否可用',
							name : 'PHEINGActiveFlag',
							id:'PHEINGActiveFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGActiveFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PHEINGSysFlag',
							id:'PHEINGSysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEINGSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEINGSysFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}]
			});
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 460,
		height : 380,
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
				var tempCode = Ext.getCmp("PHEINGCodeF").getValue();
				var tempDesc = Ext.getCmp("PHEINGDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (win.title == "修改"){
    				if (Ext.get("treeCombox").getValue()==""){
    					var combid=0
    				}else{
    					var combid=parseInt(Ext.getCmp("treeCombox").getValue())
    				}
    				var treeid=parseInt(treePanel.getSelectionModel().getSelectedNode().id)
    				if ((combid>=treeid)){
    					Ext.Msg.show({ title : '提示', msg : '父级分类不能移入子级!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          				return;
    				}
    			}
    			if(WinForm.form.isValid()==false){return;}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
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
		},{
			text : '继续添加',
			iconCls : 'icon-save',
			handler : function() {
				var tempCode = Ext.getCmp("PHEINGCodeF").getValue();
				var tempDesc = Ext.getCmp("PHEINGDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){return;}
    			var comboxValue=Ext.getCmp("treeCombox").getValue();
				var comboxText=Ext.get("treeCombox").dom.value
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp("form-save").getForm().reset();
								var code = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastCode");
								Ext.getCmp("PHEINGCodeF").setValue(code)
								//给上级赋值
								treeCombox.setValue(comboxValue)
								Ext.get("treeCombox").dom.value = comboxText;
								/*if (treePanel.getSelectionModel().getSelectedNode()) {
									var _record = treePanel.getSelectionModel().getSelectedNode();
									if(!_record.leaf){
										treeCombox.setValue(_record.id)
										Ext.get("treeCombox").dom.value = _record.text;					
									}
								}*/
								
								Ext.getCmp('FindTreeText').reset();
								hiddenPkgs = [];
								
								treePanel.loadTreeAdd();
								
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
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params:{
							'PHEINGRowId':""
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp('FindTreeText').reset();
								hiddenPkgs = [];
								
								treePanel.loadTreeAdd();
								 Ext.getCmp("form-save").getForm().reset();
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
				//Ext.getCmp("form-save").getForm().findField("PHEINGCode").focus(true,800);//影响快捷键添加
				if(win.title == "修改"){
					win.buttons[1].hide();
				}else{
					win.buttons[1].show();
				}
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	
	var WinBatch = new Ext.Window({
	    title: '批量设定药品',
	    iconCls : 'icon-AdmType',
	    id : "WinBatch",
	    width: 650,
	    height: 500,
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
		closeAction : 'hide',
		items:[]
  	});	

  	/** 批量设定药品按钮 */
	var btnBatchwin = new Ext.Toolbar.Button({
			text : '批量设定药品',
			tooltip : '批量设定药品',
			iconCls : 'icon-AdmType',
			id:'batch_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('batch_btn'),
			handler : BatchData=function () {
				var _record = treePanel.getSelectionModel().getSelectedNode();
				if (!_record) {
		            Ext.Msg.show({
						title : '提示',
						msg : '请选择需要批量设定药品的分类!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
			  	}else {
			  		WinBatch.removeAll();
			  		ObjectReference = treePanel.getSelectionModel().getSelectedNode().id;
		  			var myTree = new Ext.KB.Component.GenericDataPanel({
				        region:"center",
						dataUrl:Tree_BATCH_URL,
						ObjectType : DrugId,
						ObjectReference : ObjectReference,
				        pageSize:Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
				        disToolbar : true, //是否显示搜索工具条
				        isCascade : true,   //级联
				        AutClass : "web.DHCBL.KB.DHCPHExtGenIngr", //获取授权数据类名称
				        getAutMethod : "GetBatchJson",		 //获取授权数据方法
				        saveAutMethod : 'SaveBatchData' //保存授权数据方法
					});	
			  		WinBatch.add(myTree);
			  		WinBatch.show();	
		        }
			},
			scope : this
		});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					var code = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastCode");
					Ext.getCmp("PHEINGCodeF").setValue(code)
					if (treePanel.getSelectionModel().getSelectedNode()) {
						var _record = treePanel.getSelectionModel().getSelectedNode();
						if(!_record.leaf){
							treeCombox.setValue(_record.id)
							Ext.get("treeCombox").dom.value = _record.text;					
						}
					}
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					var _record = treePanel.getSelectionModel().getSelectedNode();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的分类!',
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
			                	var PHEINGLastLevel=treePanel.getSelectionModel().getSelectedNode().parentNode.text;
			                	if(PHEINGLastLevel==undefined){
			                		Ext.get("treeCombox").dom.value = "";
			                	}else{
									Ext.get("treeCombox").dom.value = PHEINGLastLevel;                	
			                	}
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
		        } 
			});
	function AddSame(){
		win.setTitle('添加');
		win.setIconClass('icon-add');
		win.show('new1');
		WinForm.getForm().reset();
		var code = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastCode");
		Ext.getCmp("PHEINGCodeF").setValue(code)
		if (treePanel.getSelectionModel().getSelectedNode()) {
			var _record = treePanel.getSelectionModel().getSelectedNode();
			if(!_record.leaf){
				var LastLevel = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastLevel",_record.id);
				var LastId = LastLevel.split("^")[0];
				var LastDesc = LastLevel.split("^")[1];
				treeCombox.setValue(LastId)
				Ext.get("treeCombox").dom.value = LastDesc;					
			}
		}
	}
	var treePanel = new Ext.BDP.Component.tree.TreePanel({
		region:'center',
		rootId : "TreeRoot",
		nodeParameter :"LastLevel",
		dataUrl: TREE_ACTION_URL,
		dragUrl: DRAG_ACTION_URL, //拖拽方法
		AddMethod:AddSame, //右键菜单添加本级方法
		comboId:"treeCombox" //下拉树id
	});
	treePanel.on("click",function(node,event){
        selectNode=node.id
	})
	
	if(treePanel){
		treePanel.on("dblclick",function (node, e){
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + node.id,
                success : function(form,action) {
                	var PHEINGLastLevel=treePanel.getSelectionModel().getSelectedNode().parentNode.text
                	if(PHEINGLastLevel==undefined){
                		Ext.get("treeCombox").dom.value = "";
                	}else{
						Ext.get("treeCombox").dom.value = PHEINGLastLevel;                	
                	}
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
		},this,{stopEvent:true});
	}	
	var panel = new Ext.Panel({
		title: '药品成分字典',
		layout:'border',
		region:'center',
		tools:Ext.BDP.FunLib.Component.HelpMsg,
		items:[treePanel],
		tbar:[
			'检索',
			new Ext.form.TextField({
				id:'FindTreeText',
				width:150,
				emptyText:'请输入查找内容',
				enableKeyEvents: true,
				listeners:{
					keyup:function(node, event) {
						findByKeyWordFiler(node, event);
					},
					scope: this
				}
			}), '-', {
				text:'清空',
				iconCls:'icon-refresh',
				handler:Refresh = function(){clearFind();} //清除树过滤
			}, '-',btnAddwin, '-', btnEditwin, '-', btnDel , '-' , btnBatchwin ,'->', btnConfig
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
	var findByKeyWordFiler = function(node, event) {
		
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
					var pinyin=Pinyin.getWordsCode(n.text)
					return !n.isLeaf() || re.test(n.text) || re.test(pinyin);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				treePanel.root.cascade(function(n) {
					if(n.id!='TreeRoot'){
						var pinyin=Pinyin.getWordsCode(n.text)
						if(!n.isLeaf() &&judge(n,re)==false&& (!re.test(n.text)||!re.test(pinyin))){
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
			var pinyin=Pinyin.getWordsCode(n1.text)
			if(n1.isLeaf()){
				if(re.test(n1.text)||re.test(pinyin)){ str=true;return; }
			} else {
				if(re.test(n1.text)||re.test(pinyin)){ str=true;return; }
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
	}
	/*************************************************************/
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
