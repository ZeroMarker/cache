/// 描述: 版本号关联数据页面
/// 编写者： 基础数据平台组 李可凡
/// 编写日期: 2019年12月12日
 Ext.onReady(function(){ 
	Ext.QuickTips.init();
	var limit = Ext.BDP.FunLib.PageSize.Main;//定义分页
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersionLinkData&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPTableVersionLinkData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersionLinkData&pClassMethod=DeleteData";
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersionLinkData&pClassQuery=GetList";
	var OPEN_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersionLinkData&pClassMethod=OpenData";
	var TV_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersion&pClassQuery=GetDataForCmb1";
	var TableList_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersion&pClassQuery=GetTable";
	var Version_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTableVersion&pClassQuery=GetVersionByTable";
	
/*********************************删除按钮**********************************/
	var btnDel = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'icon-delete',
			id:'del_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
			handler : DelData=function() {
			var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
						Ext.Msg.show({
							title:'提示',
							minWidth:280,
							msg:'请选择需要删除的行!',
							icon:Ext.Msg.WARNING,
							buttons:Ext.Msg.OK
						});	
					 return false;
				 } 
				 else{
					Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
					if (btn == 'yes') {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('RowID') 
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=red>删除成功!</font>',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.DelForTruePage(grid,limit);	
                                            }
                                        });
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br />错误信息:' + jsonData.info
										}
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>数据删除失败!</font>' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
										}
								}
							}, this);
						}
				}, this);
			} 
		}
	});	
	
	///读表单数据
    var jsonReaderE=new Ext.data.JsonReader({root:'list'},//list对应类方法中s str = "{list:["_str_"]}"
     [{    
         name : 'RowID',
         mapping :'RowID',
         type : 'int'
        },{
         name : 'TableName',
         mapping :'TableName',
         type:'string'
        },{
         name : 'Version',
         mapping :'Version',
         type:'string'
        },{
         name:'DataId',
         mapping:'DataId',
         type : 'string' 
        }
     ]);	

	var Version = new Ext.BDP.Component.form.ComboBox({//版本号
					fieldLabel: '<font color=red>*</font>版本号',	
					//xtype:'bdpcombo',
					id: 'VersionF',
					name:'Version',
					hiddenName:'Version',
					loadByIdParam : 'rowid',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('VersionF'),
					queryParam : "version",
					forceSelection: true,
					selectOcnFocus:false,
					mode:'remote',
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					listWidth:250,
					valueField:'RowID',
					displayField:'Version',
					allowBlank:false,
					blankText:'版本号为必选项',
					store:new Ext.data.JsonStore({
						//autoLoad: true,
						url:Version_QUERY_ACTION_URL,
						root: 'data',
						totalProperty: 'total',
						idProperty: 'RowID',
						fields:['RowID','Version']
					}),
					validator : function(thisText){
						if (Ext.getCmp("TableNameF").getValue()=="")
						{
							return false;
						}
					},
					invalidText : '请选择表名',
					listeners:{
						 'expand': function(){
		                 }
					}
				})
	
/************************************添加修改弹窗Form************************************/
	var WinForm = new Ext.form.FormPanel({
		id : 'form-save',
		title:'基本信息',
		labelAlign : 'right',
		labelWidth:100,
		width : 380,
		split : true,
		frame : true,
		defaults : {
			anchor: '85%',
			bosrder : false   
		},
		reader:jsonReaderE,
		defaultType : 'textfield',
		items : [{	//rowid
					xtype : 'textfield',
					fieldLabel : 'RowID',
					hideLabel : 'True',
					hidden : true,
					name : 'RowID'
				},{//表名
					fieldLabel: '<font color=red>*</font>表名',	
					xtype:'bdpcombo',
					id: 'TableNameF',
					name:'TableName',
					hiddenName:'TableName',
					loadByIdParam : 'rowid',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TableNameF'),
					queryParam : "table",
					forceSelection: true,
					selectOcnFocus:false,
					mode:'remote',
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					listWidth:220,
					valueField:'RowID',
					displayField:'Table',
					allowBlank:false,
					blankText:'表名为必选项',
					store:new Ext.data.JsonStore({
						//autoLoad: true,
						url:TableList_QUERY_ACTION_URL,
						root: 'data',
						totalProperty: 'total',
						idProperty: 'RowID',
						fields:['RowID','Table']
					}),
					listeners:{
						   'select': function(){
								Version.getStore().baseParams={			
									tabledr : Ext.getCmp("TableNameF").getValue()
								};
		                 	}
					}
				},Version,{	//关联数据id
					xtype : 'textfield',
					fieldLabel:'<font color=red>*</font>关联数据id',
					id:'DataIdF',
					name:'DataId',
					allowBlank:false,
					blankText:'关联数据id为必填项',
					validationEvent : 'blur',  
					validator : function(thisText){
						if(thisText==""){  //当文本框里的内容为空的时候不用此验证
							return true;
						}
						var className =  "web.DHCBL.BDP.BDPTableVersionLinkData";   
						var classMethod = "FormValidate"; //数据重复验证后台函数名                             
						var id="";
						if(win.title=='修改'){  
							var _record = grid.getSelectionModel().getSelected();
							var id = _record.get('RowID');  
						}
						var tableversiondr=Ext.getCmp("VersionF").getValue();
						var flag = "";
						var flag = tkMakeServerCall(className,classMethod,id,tableversiondr,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
						if(flag == "1"){
							return false;
						}else{
							return true;
						}
					},
					invalidText : '该版本号已关联该条数据',
					listeners : {
						 'change' : Ext.BDP.FunLib.Component.ReturnValidResult
					}
				}]
	});	

 /*******************************定义‘基本信息’框*******************************************/
   	var tabs=new Ext.TabPanel({
	    id:'basic',
	    activeTab: 0,
	    frame:true,
	    items:[WinForm]
	});


/*********************************重置form的数据清空**************************************/
        var ClearForm = function()
      	{
           Ext.getCmp("form-save").getForm().reset();   
     	}
/*********************************关闭弹出窗口时的函数方法*********************************/
         var closepages= function (){
             win.hide();
             ClearForm();
         }  

/************************************添加修改弹窗***********************************/
	var win = new Ext.Window({
		width : 400,
		height : 250,
		layout : 'fit',
		modal : true,
		frame : true,
		autoScroll : false,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 65,
		items : WinForm,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempTableVersion = Ext.getCmp("form-save").getForm().findField("VersionF").getValue();
			var tempDataId = Ext.getCmp("form-save").getForm().findField("DataId").getValue();
			if (tempTableVersion=="") {
				Ext.Msg.show({
					title : '<font color=blue>提示</font>',
					msg : '版本号不能为空!', 
					minWidth : 200,
					icon : Ext.Msg.ERROR, 
					buttons : Ext.Msg.OK ,
					fn:function()
					{
						Ext.getCmp("form-save").getForm().findField("VersionF").focus(true,true);
					}
				});
      			return;
			}
			if (tempDataId=="") {
				Ext.Msg.show({
					title : '<font color=blue>提示</font>',
					msg : '关联数据id不能为空!', 
					minWidth : 200,
					icon : Ext.Msg.ERROR, 
					buttons : Ext.Msg.OK ,
					fn:function()
					{
						Ext.getCmp("form-save").getForm().findField("DataId").focus(true,true);
					}
				});
      			return;
			}
            if(WinForm.getForm().isValid()==false){
	           Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
	           return;
	        } 
			if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
                        		win.hide();
								Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=green>添加成功!</font>',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																		start : 0,
																		limit : limit,
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
												title : '<font color=blue>提示</font>',
												msg : '<font color=red>添加失败!</font>' + errorMsg,
												minWidth : 200,
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
									}
						},
						failure : function(form, action) {
							Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=red>添加失败!</font>' ,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
					})
			} else {
					Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										 var myrowid = 'rowid='+action.result.id;
										  win.hide();
			                             Ext.Msg.show({
			                                  title : '<font color=blue>提示</font>',
			                                  msg : '<font color=green> 修改成功!</font>',
			                                  icon : Ext.Msg.INFO,
			                                  buttons : Ext.Msg.OK,
			                                           fn : function(btn) {
			                                            var startIndex = grid.getBottomToolbar().cursor;
			                                            Ext.BDP.FunLib.ReturnDataForUpdate('grid',ACTION_URL,myrowid);
			                                        }
			                                   }); 
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo
										}
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>修改失败!</font>',
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										}
								},
								failure : function(form, action) {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>修改失败!</font>' ,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
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
               ClearForm(); 
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});

/************************************增加按钮************************************/
	 var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
                    tabs.setActiveTab(0);
				},
				scope : this
			});
/************************************修改按钮**********************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					var records =  grid.selModel.getSelections();
					var recordsLen= records.length;
					if(recordsLen == 0){
							Ext.Msg.show({
								title:'提示',
								minWidth:280,
								msg:'请选择需要修改的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});	
						 return
					 } 
					 else{
							win.setTitle('修改');
							win.setIconClass('icon-update');
							win.show('');
							loadFormData(grid);
						 }
				 }
    });


/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin,'-',btnEditwin,'-',btnDel] 
	});
	
/************************************搜索按钮************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {
				grid.getStore().baseParams={			
						tabledr : Ext.getCmp("TextTableName").getValue() ,
						versiondr : Ext.getCmp("TextVersionF").getValue()
				};
				
				grid.getStore().load({
						params : {
									start : 0,
									limit : limit
								}
							});
						 }
					});
/************************************刷新按钮************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function refresh() {
					Ext.getCmp("TextTableName").reset();
					Ext.getCmp("TextVersionF").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
											start : 0,
											limit : limit
										}
							});
					}
			});
	
	
	var TextVersion = new Ext.BDP.Component.form.ComboBox({//版本号
					fieldLabel: '<font color=red>*</font>版本号',	
					//xtype:'bdpcombo',
					id: 'TextVersionF',
					name:'TextVersion',
					hiddenName:'TextVersion',
					loadByIdParam : 'rowid',
					width:220,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextVersionF'),
					queryParam : "version",
					forceSelection: true,
					selectOcnFocus:false,
					mode:'remote',
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					listWidth:220,
					valueField:'RowID',
					displayField:'Version',
					store:new Ext.data.JsonStore({
						//autoLoad: true,
						url:Version_QUERY_ACTION_URL,
						root: 'data',
						totalProperty: 'total',
						idProperty: 'RowID',
						fields:['RowID','Version']
					}),
					listeners:{
						   'expand': function(){
		                 	}
					}
				})
	
/************************************将工具条放到一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['表名', {
					xtype:'bdpcombo',
					id: 'TextTableName',
					loadByIdParam : 'rowid',
					width:220,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextTableName'),
					queryParam : "table",
					forceSelection: true,
					selectOcnFocus:false,
					mode:'remote',
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					listWidth:220,
					valueField:'RowID',
					displayField:'Table',
					store:new Ext.data.JsonStore({
						//autoLoad: true,
						url:TableList_QUERY_ACTION_URL,
						root: 'data',
						totalProperty: 'total',
						idProperty: 'RowID',
						fields:['RowID','Table']
					}),
					listeners:{
						   'select': function(){
								TextVersion.getStore().baseParams={			
									tabledr : Ext.getCmp("TextTableName").getValue()
								};
		                 	}
					}
				},'版本号', TextVersion/*{
					xtype:'bdpcombo',
					id: 'TextVersion',
					loadByIdParam : 'rowid',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextVersion'),
					queryParam : "table",
					forceSelection: true,
					selectOcnFocus:false,
					mode:'remote',
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					listWidth:250,
					valueField:'RowID',
					displayField:'Version',
					store:new Ext.data.JsonStore({
						//autoLoad: true,
						url:Version_QUERY_ACTION_URL,
						root: 'data',
						totalProperty: 'total',
						idProperty: 'RowID',
						fields:['RowID','Version']
					})
				}*/,'-', btnSearch, '-', btnRefresh
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});



/************************************数据存储***********************************/
    var fields=[{
                    name : 'RowID',
                    mapping : 'RowID',
                    type : 'int'
                }, {
                    name : 'TableName',  
                    mapping : 'TableName',
                    type : 'string'
                }, {
                    name : 'Version',
                    mapping :'Version',
                    type:'string'
                },{
                    name:'DataId',
                    mapping:'DataId',
                    type:'string'
    }]
				
         
	var ds = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ACTION_URL
					}),// 调用的动作
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, fields)
	});  
	
/************************************数据加载************************************/
	ds.load({
				params : {
					start : 0,
					limit : limit
				},
				callback : function(records, options, success) {
				}
			})
	
/************************************数据分页************************************/	
	var paging= new Ext.PagingToolbar({
		pageSize: limit,
		store: ds,
		displayInfo: true,
		displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg: "没有记录" ,
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
					        "change":function (t,p)
					       { 
					           limit=this.pageSize;
					       }
			           }
	});   	
	
/************************************创建表格************************************/	
	var GridCM=[new Ext.grid.CheckboxSelectionModel(),//可选择的
		{header:"RowId",dataIndex:"RowID",width: 85, sortable: true,hidden:true},
		{header:"表名",dataIndex:"TableName",width: 85, sortable: true},
		{header:"版本号",dataIndex:"Version",width: 85, sortable: true},
		{header:'关联数据RowId',dataIndex:'DataId',width: 85, sortable: true}
	];
      

   
/************************************定义表格面板************************************/		
	var grid = new Ext.grid.GridPanel({ 
		title:"版本号关联数据",  
		columns:GridCM,
		id:'grid',
		region: 'center',
		width:900,
		height:500,
		columnLines : true, //在列分隔处显示分隔符
		store:ds ,  
		viewConfig: {
			forceFit: true
		},
		tbar : tb,
		bbar:paging,  
		stateId : 'grid'
	});       
	
/************************************双击事件************************************/
	var loadFormData = function(grid){
		var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
		if (!_record) {
			Ext.Msg.alert('修改操作', '请选择要修改的一项!');
		} else {
				WinForm.form.load({
				url : OPEN_ACTION_URL + '&id='+ _record.get('RowID'),  //id 对应OPEN里的入参
				success : function(form,action) {
				},
				failure : function(form,action) {
				}
			});
			//激活基本信息面板
			//tabs.setActiveTab(0);
		}
	};
	
	grid.on("rowdblclick", function(grid, rowIndex, e) {
			win.setTitle('修改');      ///双击后
			win.setIconClass('icon-update');
			win.show('');
			loadFormData(grid);
	});		
	
	var view =new Ext.Viewport({
		layout:'border',
		items:[grid]
	});
	
	
 });