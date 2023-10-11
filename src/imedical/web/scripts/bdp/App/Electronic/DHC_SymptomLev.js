/// 名称: 症状分级表
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-10-30
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombo.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');

Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=SaveData&pEntityName=web.Entity.CT.DHCSymptomLev";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=OpenData";
	
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=GetTreeJson";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=GetTreeComboJson";
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=DragNode";
	//var SAVE_DROP_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=SaveDropData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	var selectNode="";  //选中节点
	var nodeStr="";
	Ext.BDP.FunLib.SortTableName = "User.DHCSymptomLev^User.DHCSymptomCon";
    var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
    var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName) ;
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
   var _record = treePanel.getSelectionModel().getSelectedNode();
   if(_record){
						 
		console.log(_record)
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",_record.id,_record.text);        
    }
  });
	/************************症状分级与症状相关联*************************************/
	var btnFeild = new Ext.Toolbar.Button({
			text : '关联症状',
			tooltip : '关联症状',
			iconCls : 'icon-DP',
			id : 'btnFeild',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnFeild'),
	      	handler: ConLab=function () {	
				if(selectNode == ""){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 }
				 else{
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/Electronic/DHC_SymptomCon&selectNode="+selectNode; 
	                	/** 症状分级与症状关联窗口 */
						var windowLab = new Ext.Window({
										iconCls : 'icon-DP',
										width : 1000,
										height : 480,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
										autoScroll : false,
										collapsible : true,
										hideCollapseTool : true,
										titleCollapse : true,
										constrain : true,
										closeAction : 'close',
										html : '',
										listeners : {
											"show" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
											    	keymap_main.disable();
											    }
											},
											"hide" : function(){
												/*Ext.getCmp('FindTreeText').reset();
												hiddenPkgs = [];
												treePanel.on('beforeload', function(){   
											        treeLoader.dataUrl = TREE_ACTION_URL ;  
											        treeLoader.baseParams = {LastLevel:"TreeRoot"}
												});
												treePanel.root.reload();*/

											 	treePanel.getNodeById(selectNode).reload();

											},
											"close" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
													keymap_main.enable();
											    }
											}
										}
									});
						if ('undefined'!==typeof websys_getMWToken){
							link += "&MWToken="+websys_getMWToken()
						}
						windowLab.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						var title=treePanel.getSelectionModel().getSelectedNode().text
						windowLab.setTitle(title);
						windowLab.show();
				}
	      }	
    });
	
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
						var refreshid=""
						var ids=treePanel.getSelectionModel().getSelectedNode().id
						if(ids.indexOf("Con")>-1){
							ids=ids.replace("Con","");
							var DELETE_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomCon&pClassMethod=DeleteData";
						}
						else{
							var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomLev&pClassMethod=DeleteData";
						}
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : ids
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
												//Ext.getCmp('FindTreeText').reset();
												/*clearFind();
												hiddenPkgs = [];
												treePanel.on('beforeload', function(){   
											        treeLoader.dataUrl = TREE_ACTION_URL ;  
											        treeLoader.baseParams = {LastLevel:"TreeRoot"}
												});
												treePanel.root.reload();*/
											    //删除之后 刷新
												var _record = treePanel.getSelectionModel().getSelectedNode();
												if (_record == null) {
													treePanel.on('beforeload', function(){   
												        treeLoader.dataUrl = TREE_ACTION_URL ;  
												        treeLoader.baseParams = {LastLevel:"TreeRoot"};
												        treeLoader.baseParams = {nodeStr:nodeStr};
													});
												 	treePanel.root.reload();
												 } else {
												 	if (_record.parentNode.id=="TreeRoot"){
												 		treePanel.on('beforeload', function(){   
													        treeLoader.dataUrl = TREE_ACTION_URL ;  
													        treeLoader.baseParams = {LastLevel:"TreeRoot"};
													        treeLoader.baseParams = {nodeStr:nodeStr};
														});
												 		treePanel.root.reload();
												 	}else{
												 		treePanel.getNodeById(_record.parentNode.id).reload();
												 	}
												 }
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
						msg : '请选择需要删除的症状分级!',
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

	/*var comboTreePanel = new Ext.tree.TreePanel({
			id: 'treeComboPanel',
			root: new Ext.tree.AsyncTreeNode({
					id:"LevTreeRoot",
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
			name:'SYLLastRowid',
			id:'treeCombox',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
			fieldLabel:"上级分类",
			hiddenName : 'SYLLastRowid',
			anchor:"97%",
			editable : true,
			enableKeyEvents: true,
			tree:comboTreePanel
		});*/
		
	 var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'treeCombox',
		 name:'SYLLastRowid', 
         width : 180,  
         fieldLabel:"上级分类",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
         hiddenName : 'SYLLastRowid',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"LevTreeRoot",
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
				autoScroll : true,
				//bodyStyle : 'overflow-x:hidden; overflow-y:scroll',
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'SYLRowId',mapping:'SYLRowId',type:'string'},
                         {name: 'SYLCode',mapping:'SYLCode',type:'string'},
                         {name: 'SYLDesc',mapping:'SYLDesc',type:'string'},
                         {name: 'SYLLastRowid',mapping:'SYLLastRowid',type:'string'},
                         {name: 'SYLSequence',mapping:'SYLSequence',type:'string'},
                         {name: 'SYLLevel',mapping:'SYLLevel',type:'string'}
                   ]),  
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'SYLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'SYLRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'SYLCode',
							id:'SYLCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SYLCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SYLCodeF')),
							allowBlank : false,
							blankText : '代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.DHCSymptomLev";  //后台类名称
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
							name : 'SYLDesc',
							id:'SYLDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SYLDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SYLDescF')),
							allowBlank : false,
							blankText : '描述不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.DHCSymptomLev";  //后台类名称
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
							fieldLabel : '顺序',
							name : 'SYLSequence',
							id:'SYLSequenceF',
							xtype:'numberfield',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SYLSequenceF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SYLSequenceF'))
						}, {
							fieldLabel : '级别',
							name : 'SYLLevel',
							id:'SYLLevelF',
							xtype:'numberfield',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SYLLevelF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SYLLevelF'))
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
		//autoScroll : true,
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
				var tempCode = Ext.getCmp("SYLCodeF").getValue();
				var tempDesc = Ext.getCmp("SYLDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
    			if(WinForm.form.isValid()==false){
					Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					return;}
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
												/*Ext.getCmp('FindTreeText').reset();
												hiddenPkgs = [];
												treePanel.on('beforeload', function(){   
											        treeLoader.dataUrl = TREE_ACTION_URL ;  
											        treeLoader.baseParams = {LastLevel:"TreeRoot"}
												});
												treePanel.root.reload();*/
											   //添加之后 刷新
												if (Ext.getCmp("treeCombox").getValue() == "") {
													treePanel.on('beforeload', function(){   
												        treeLoader.dataUrl = TREE_ACTION_URL ;  
												        treeLoader.baseParams = {LastLevel:"TreeRoot"};
												        treeLoader.baseParams = {nodeStr:nodeStr};
													});
													treePanel.root.reload();
												 } else {
												 	var _record = treePanel.getSelectionModel().getSelectedNode();
												 	if (_record!=null){
												 		if (_record.parentNode.id=="TreeRoot"){
															treePanel.on('beforeload', function(){   
														        treeLoader.dataUrl = TREE_ACTION_URL ;  
														        treeLoader.baseParams = {LastLevel:"TreeRoot"};
														        treeLoader.baseParams = {nodeStr:nodeStr};
															});
															treePanel.root.reload();
													 	}else{
													 		treePanel.getNodeById(_record.parentNode.id).reload();
													 	}
												 	}
												 	treePanel.getNodeById(Ext.getCmp("treeCombox").getValue()).reload();
												 }
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
													/*Ext.getCmp('FindTreeText').reset();
													hiddenPkgs = [];
													treePanel.on('beforeload', function(){   
												        treeLoader.dataUrl = TREE_ACTION_URL ;  
												        treeLoader.baseParams = {LastLevel:"TreeRoot"}

													});
													treePanel.root.reload();*/
													//修改之后 刷新
													var _record = treePanel.getSelectionModel().getSelectedNode();
													treePanel.getNodeById(_record.parentNode.id).reload();
														clearFind();
													/*
													if (_record == null) {
														treePanel.on('beforeload', function(){   
													        treeLoader.dataUrl = TREE_ACTION_URL ;  
													        treeLoader.baseParams = {LastLevel:"TreeRoot"};
													        treeLoader.baseParams = {nodeStr:nodeStr};
														});
													 	treePanel.root.reload();
													 } else {
													 	if (_record.parentNode.id=="TreeRoot"){
													 		treePanel.on('beforeload', function(){   
														        treeLoader.dataUrl = TREE_ACTION_URL ;  
														        treeLoader.baseParams = {LastLevel:"TreeRoot"};
														        treeLoader.baseParams = {nodeStr:nodeStr};
															});
													 		treePanel.root.reload();
													 	}else{
													 		treePanel.getNodeById(_record.parentNode.id).reload();
													 	}
														
													 }
													 */
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
				var tempCode = Ext.getCmp("SYLCodeF").getValue();
				var tempDesc = Ext.getCmp("SYLDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){
					Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					return;}

					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
								//Ext.getCmp("form-save").getForm().reset();
								Ext.getCmp('FindTreeText').reset();
								hiddenPkgs = [];
								treePanel.on('beforeload', function(){   
							        treeLoader.dataUrl = TREE_ACTION_URL ;  
							        treeLoader.baseParams = {LastLevel:"TreeRoot"}
								});
								treePanel.root.reload();
							   //添加之后 刷新
								if (Ext.getCmp("treeCombox").getValue() == "") {
									treePanel.on('beforeload', function(){   
								        treeLoader.dataUrl = TREE_ACTION_URL ;  
								        treeLoader.baseParams = {LastLevel:"TreeRoot"};
								        treeLoader.baseParams = {nodeStr:nodeStr};
									});
									treePanel.root.reload();
								 } else {
								 	//treePanel.getNodeById(Ext.getCmp("treeCombox").getValue()).reload();
								 }
								Ext.getCmp("form-save").getForm().reset();
								if (treePanel.getSelectionModel().getSelectedNode()) {
									var _record = treePanel.getSelectionModel().getSelectedNode();
									treeCombox.setValue(_record.id)
									Ext.get("treeCombox").dom.value = _record.text;		
									var level =tkMakeServerCall("web.DHCBL.CT.DHCSymptomLev","GetLevel",_record.id);
									level=parseInt(level)+1
									Ext.getCmp("SYLLevelF").setValue(level);
								}
								else
								{
									Ext.getCmp("SYLLevelF").setValue(0);
								}
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
				Ext.getCmp("form-save").getForm().findField("SYLCode").focus(true,800);
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
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					var _record = treePanel.getSelectionModel().getSelectedNode();
					if(_record){
						var ids=_record.id
						if(ids.indexOf("Con")>-1){
							
						}else{
							win.setTitle('添加');
							win.setIconClass('icon-add');
							win.show('new1');
							WinForm.getForm().reset();									
							
							treeCombox.setValue(_record.id)
							Ext.get("treeCombox").dom.value = _record.text;		
							var level =tkMakeServerCall("web.DHCBL.CT.DHCSymptomLev","GetLevel",_record.id);
							level=parseInt(level)+1
							Ext.getCmp("SYLLevelF").setValue(level);
							var seq =tkMakeServerCall("web.DHCBL.CT.DHCSymptomLev","GetSequence",_record.id);
							seq=parseInt(seq)
							Ext.getCmp("SYLSequenceF").setValue(seq)

						}
					}else{
						win.setTitle('添加');
						win.setIconClass('icon-add');
						win.show('new1');
						WinForm.getForm().reset();
						Ext.getCmp("SYLLevelF").setValue(0);
					}
				},
				scope : this
			});
	
	function AddSame(){
			var _record = treePanel.getSelectionModel().getSelectedNode();
			if(_record){
				var ids=_record.id
				if(ids.indexOf("Con")>-1){
					
				}else{
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();																		
					
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
					var level =tkMakeServerCall("web.DHCBL.CT.DHCSymptomLev","GetLevel",_record.id);
					level=parseInt(level)
					Ext.getCmp("SYLLevelF").setValue(level);
					var seq =tkMakeServerCall("web.DHCBL.CT.DHCSymptomLev","GetSequence",_record.parentNode.id);
					seq=parseInt(seq)
					Ext.getCmp("SYLSequenceF").setValue(seq)

				}
			}else{
				win.setTitle('添加');
				win.setIconClass('icon-add');
				win.show('new1');
				WinForm.getForm().reset();
				Ext.getCmp("SYLLevelF").setValue(0);
			}
	}
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
							msg : '请选择需要修改的症状分级!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				  	}else {
				  		var ids=_record.id
				  		if(ids.indexOf("Con")>-1){
				  			
						}else{
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + treePanel.getSelectionModel().getSelectedNode().id,
			                success : function(form,action) {
			                	var SYLLastRowid=treePanel.getSelectionModel().getSelectedNode().parentNode.text;
			                	if(SYLLastRowid==undefined){
			                		Ext.get("treeCombox").dom.value = "";
			                	}else{
									Ext.get("treeCombox").dom.value = SYLLastRowid;                	
			                	}
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
						}
			        }
		        } 
			});
	
	var treeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "LastLevel",
			dataUrl: TREE_ACTION_URL
		});

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
		enableDD:true,
        listeners:{
        	"click":function(node,event) {	
        		selectNode=node.id;
			},
		   // "dragdrop":function(treePanel,node,dd,event){
			"movenode":function(panel, node , oldParent , newParent , index){
				//alert(node.id); //源节点id
				//alert(node.parentNode.id); //目标父节点id
				//alert(node.nextSibling ? node.nextSibling.text : ""); //下一个节点id，用于拖动插入某节点到另一节点之前/后
				//alert(node.previousSibling ? node.previousSibling.text : ""); //前一个节点id，用于拖动插入某节点到另一节点之前/后
		    	var orderstr=""
		    	var childnodes=newParent.childNodes;  
		    	for(var i=0;i<childnodes.length;i++)
		    	{
		    		var rootnode = childnodes[i];
		    		if (orderstr!="")
		    		{
		    			var orderstr=orderstr+"^"+rootnode.id;
		    		}
		    		else
		    		{
		    			var orderstr=rootnode.id;
		    		}
		    	}
		    	//alert(node.parentNode.text  + "&" +orderstr)
				Ext.Ajax.request({
						url : DRAG_ACTION_URL , 		
						method : 'POST',	
						params : {
								'id' : node.id,
								'parentid' : newParent.id,
								'orderstr':orderstr
						},
						callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								/*Ext.getCmp('FindTreeText').reset();
								hiddenPkgs = [];
								treePanel.on('beforeload', function(){   
							        treeLoader.dataUrl = TREE_ACTION_URL ;  
							        treeLoader.baseParams = {LastLevel:"TreeRoot"};
							        treeLoader.baseParams = {nodeStr:nodeStr};
								});
								treePanel.root.reload();*/

							}else{
								var errorMsg ='';
								if(jsonData.errorinfo){
									errorMsg='<br />'+jsonData.errorinfo
								}
								Ext.Msg.show({
									title:'提示',
									msg:errorMsg,
									minWidth:210,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}

						}
					}								
				})
			},
			'collapsenode':function(node){
				if (nodeStr!=""){
			 		nodeStr=nodeStr+"^<"+node.id+">";
			 	}else{
			 		nodeStr="<"+node.id+">";
			 	}
			},
			'expandnode':function(node){
				nodeStr=nodeStr.replace("<"+node.id+">","");
			}
        }
	});
	if(treePanel){
		treePanel.on("dblclick",function (node, e){
			var ids=node.id
	  		if(ids.indexOf("Con")>-1){//如果选中的是症状则没反应
	  		
	  		}else{
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + node.id,
                success : function(form,action) {
                	var SYLLastRowid=treePanel.getSelectionModel().getSelectedNode().parentNode.text
                	if(SYLLastRowid==undefined){
                		Ext.get("treeCombox").dom.value = "";
                	}else{
						Ext.get("treeCombox").dom.value = SYLLastRowid;                	
                	}
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
	  		}
		},this,{stopEvent:true});
		
		//单击事件，如果是症状，添加修改按钮灰化
		treePanel.on("click",function (node, e){
			var ids=node.id
	  		if(ids.indexOf("Con")>-1){
	  			Ext.getCmp("add_btn").setDisabled(true);
	  			Ext.getCmp("update_btn").setDisabled(true);
	  			Ext.getCmp("btnFeild").setDisabled(true);  			
			}else{
				Ext.getCmp("add_btn").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('add_btn'));
				Ext.getCmp("update_btn").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('update_btn'));
				Ext.getCmp("btnFeild").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('btnFeild'));
			}
		},this,{stopEvent:true});
		
		 /*treePanel.on('nodedrop', function(e){
			  var curTree = e.tree;//得到当前的tree    append表示添加above节点的上方below节点的下方。
			  var tmpDropNode = e.dropNode;  var tmpDropedNode = e.target;  var dropType = e.point;   
			  var begin=tmpDropNode.id
			  var end=tmpDropedNode.id
			 // alert(begin+"^"+end+"^"+dropType)
			  Ext.Ajax.request({ 
			   url: SAVE_DROP_ACTION_URL, 
			   method: 'post', 
			   params: {  
					begin: begin,  
					end: end, 
					type: dropType  
				}, 
			  callback : function(options, success, response) {
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if (jsonData.success == 'true') {
									Ext.getCmp('FindTreeText').reset();
									hiddenPkgs = [];
									treePanel.on('beforeload', function(){   
								        treeLoader.dataUrl = TREE_ACTION_URL ;  
								        treeLoader.baseParams = {LastLevel:"TreeRoot"};
								        treeLoader.baseParams = {nodeStr:nodeStr};
									});
									treePanel.root.reload();
								}
								else {
									var errorMsg = '';
									if(jsonData.errorinfo){
										errorMsg='<br/>错误信息:'+jsonData.errorinfo
									}
									Ext.Msg.show({
										title : '提示',
										msg : '修改失败!'+errorMsg,
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK														
										})		
								}
							}
							else {
									Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败,请检查网络连接!',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
										});
							}	
			   },    
			   failure: function(response, option){ //nodeEdited.setText(oldValue);//如果失败则将改过的节点恢复原状 
			    	alert("异步通讯失败请与管理员联系"); 
			   } 
			  }); 
		 });*/
		 
		 		
		treePanel.on("contextmenu",function (node, e){
			selectNode=node.id;
			//alert(node.text)
			if(this.nodemenu==null){
			this.nodemenu=new Ext.menu.Menu({  			
				items: [
				{
		            iconCls :'icon-add',
		            handler: AddSame,
		            id:'menuAddSame',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddSame'),
		            text: '添加本级'
		        },
	    		{
		            iconCls :'icon-add',
		            handler: AddData,
		            id:'menuAddData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
		            text: '添加下级'
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
		            handler: clearFind,
		            id:'menuRefresh',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuRefresh'),
		            text: '刷新'
		        },{
		            iconCls :'icon-DP',
		            handler: ConLab,
		            id:'menuCon',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuCon'),
		            text: '关联症状'
		        }]     	
			}); 
			}
		
			this.nodemenu.showAt(e.getXY());//menu的showAt，不要忘记
			this.getSelectionModel().select(node);
			
			var ids=node.id
	  		if(ids.indexOf("Con")>-1){
	  			Ext.getCmp("add_btn").setDisabled(true);
	  			Ext.getCmp("update_btn").setDisabled(true);
	  			Ext.getCmp("btnFeild").setDisabled(true);
	  			
	  			Ext.getCmp("menuAddSame").setDisabled(true);
	  		    Ext.getCmp("menuAddData").setDisabled(true);
	  			Ext.getCmp("menuUpdateData").setDisabled(true);
	  			Ext.getCmp("menuCon").setDisabled(true);
			}else{
				Ext.getCmp("add_btn").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('add_btn'));
				Ext.getCmp("update_btn").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('update_btn'));
				Ext.getCmp("btnFeild").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('btnFeild'));
				
				Ext.getCmp("menuAddSame").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('menuAddSame'));
				Ext.getCmp("menuAddData").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('menuAddData'));
	  			Ext.getCmp("menuUpdateData").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'));
	  			Ext.getCmp("menuCon").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('menuCon'));
			}
		});
	}

	var panel = new Ext.Panel({
		title: '症状分级表',
		layout:'border',
		region:'center',
		items:[treePanel],
		tools:Ext.BDP.FunLib.Component.HelpMsg,
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
						if(event.getKey()==27){
							clearFind();
						}
					},
					scope: this
				}
			}), '-', {
				text:'清空',
				iconCls:'icon-refresh',
				handler:function(){clearFind();} //清除树过滤
			}, '-',btnAddwin, '-', btnEditwin, '-', btnDel, '-',btnFeild,'->',btnlog,'-', btnhislog
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
					return !n.isLeaf() || re.test(n.text);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				treePanel.root.cascade(function(n) {
					if(n.id!='0'){
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
			
			Ext.getCmp("add_btn").setDisabled(false);
			Ext.getCmp("update_btn").setDisabled(false);
			Ext.getCmp("btnFeild").setDisabled(false);
			
			//Ext.getCmp("menuAddData").setDisabled(false);
  			//Ext.getCmp("menuUpdateData").setDisabled(false);
  			//Ext.getCmp("menuCon").setDisabled(false);
	}
	/*************************************************************/
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
