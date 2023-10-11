/// 名称: 专项护理字典
/// 描述: 专项护理维护页面
/// 项目：重庆人民医院，添加专项护理字典维护界面
/// 编写者： 基础数据平台组 李可凡
/// 编写日期: 2019年8月23日

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

 Ext.onReady(function(){ 
	Ext.QuickTips.init();
	var limit = Ext.BDP.FunLib.PageSize.Main;//定义分页
	
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTSpecialNursing&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTSpecialNursing";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTSpecialNursing&pClassMethod=DeleteData";
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSpecialNursing&pClassQuery=GetList";       
	var OPEN_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTSpecialNursing&pClassMethod=OpenData";
	
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_SpecialNursing"
	});
	
	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTSpecialNursing";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
	
		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="CT_SpecialNursing"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
//////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName);
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
   if (grid.selModel.hasSelection()) {
       var rows = grid.getSelectionModel().getSelections(); 
       RowID=rows[0].get('SpecialNursingRowId');
       Desc=rows[0].get('SpecialNursingDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

	
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
						AliasGrid.DataRefer = rows[0].get('SpecialNursingRowId');
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('SpecialNursingRowId') 
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
         name : 'SpecialNursingRowId',
         mapping :'SpecialNursingRowId',
         type : 'int'
        }, {
         name : 'SpecialNursingCode',
         mapping : 'SpecialNursingCode',
         type : 'string'
        }, {
         name : 'SpecialNursingDesc',
         mapping :'SpecialNursingDesc',
         type:'string'
        },{
         name:'SpecialNursingRemark',
         mapping:'SpecialNursingRemark',
         type : 'string' 
        }
     ]);	


	
/************************************添加修改弹窗Form************************************/
	var WinForm = new Ext.form.FormPanel({
		id : 'form-save',
		title:'基本信息',
		labelAlign : 'right',
		labelWidth:130,
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
					fieldLabel : 'SpecialNursingRowId',
					hideLabel : 'True',
					hidden : true,
					name : 'SpecialNursingRowId'
				},{ // 代码
					xtype : 'textfield',
					fieldLabel:'<font color=red>*</font>代码',
					id:'SpecialNursingCodeF',
					name:'SpecialNursingCode',
					allowBlank:false,
					blankText:'代码为必填项',
					validationEvent : 'blur',  
					validator : function(thisText){
						if(thisText==""){  //当文本框里的内容为空的时候不用此验证
							return true;
						}
						var className =  "web.DHCBL.CT.CTSpecialNursing";   
						var classMethod = "FormValidate"; //数据重复验证后台函数名                             
						var id="";
						if(win.title=='修改'){  
							var _record = grid.getSelectionModel().getSelected();
							var id = _record.get('SpecialNursingRowId');  
						}
						var flag = "";
						var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
						if(flag == "1"){
							return false;
						}else{
							return true;
						}
					},
					invalidText : '该代码已经存在',
					listeners : {
						 'change' : Ext.BDP.FunLib.Component.ReturnValidResult
					}
				},{ // 描述
					xtype : 'textfield',
					fieldLabel:'<font color=red>*</font>描述',
					id:'SpecialNursingDescF',
					name:'SpecialNursingDesc',
					allowBlank:false,
					blankText:'描述为必填项',
					validationEvent : 'blur',  
					validator : function(thisText){
						if(thisText==""){  //当文本框里的内容为空的时候不用此验证
							return true;
						}
						var className =  "web.DHCBL.CT.CTSpecialNursing";   
						var classMethod = "FormValidate"; //数据重复验证后台函数名                             
						var id="";
						if(win.title=='修改'){
							var _record = grid.getSelectionModel().getSelected();
							var id = _record.get('SpecialNursingRowId');  
						}
						var flag = "";
						var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
						if(flag == "1"){
						return false;
						}else{
							return true;
						}
					},
					invalidText : '该描述已经存在',
					listeners : {
						 'change' : Ext.BDP.FunLib.Component.ReturnValidResult
					}
				},{	// 备注
					xtype : 'textfield',
					fieldLabel:'备注',
					id:'SpecialNursingRemarkF',
					name:'SpecialNursingRemark',
				}]
	});	

 /*******************************定义‘基本信息’框*******************************************/
   	var tabs=new Ext.TabPanel({
	    id:'basic',
	    activeTab: 0,
	    frame:true,
	    items:[WinForm,AliasGrid]
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
		height : 300,
		layout : 'fit',
		modal : true,
		frame : true,
		autoScroll : false,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 65,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("SpecialNursingCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("SpecialNursingDesc").getValue();

			if (tempCode=="") {
				Ext.Msg.show({ 
					title : '<font color=blue>提示</font>',
					msg : '代码不能为空!', 
					minWidth : 200,
					animEl: 'form-save',
					icon : Ext.Msg.ERROR,
					buttons : Ext.Msg.OK ,
					fn:function()
						{
							Ext.getCmp("form-save").getForm().findField("SpecialNursingCode").focus(true,true);
						}
				});
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({
					title : '<font color=blue>提示</font>',
					msg : '描述不能为空!', 
					minWidth : 200,
					animEl: 'form-save',
					icon : Ext.Msg.ERROR, 
					buttons : Ext.Msg.OK ,
					fn:function()
					{
						Ext.getCmp("form-save").getForm().findField("SpecialNursingDesc").focus(true,true);
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
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
                        		win.hide();
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=green>添加成功!</font>',
											animEl: 'form-save',
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
												animEl: 'form-save',
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
											animEl: 'form-save',
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
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
									AliasGrid.saveAlias();
									if (action.result.success == 'true') {
										 var myrowid = 'rowid='+action.result.id;
										  win.hide();
			                             Ext.Msg.show({
			                                  title : '<font color=blue>提示</font>',
			                                  msg : '<font color=green> 修改成功!</font>',
			                                  animEl: 'form-save',
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
														animEl: 'form-save',
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
													animEl: 'form-save',
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
				Ext.getCmp("form-save").getForm().findField("SpecialNursingCode").focus(true,250);
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
					//清空别名面板grid
					AliasGrid.DataRefer = "";
					AliasGrid.clearGrid();
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
							var _record = grid.getSelectionModel().getSelected();
							//加载别名面板
							AliasGrid.DataRefer = _record.get('SpecialNursingRowId');
							AliasGrid.loadGrid(); 
						 }
				 }
    });


/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin,'-',btnEditwin,'-',btnDel,'-' ,btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
	});
	
/************************************搜索按钮************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue() ,
						desc : Ext.getCmp("TextDesc").getValue()
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
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
											start : 0,
											limit : limit
										}
							});
					}
			});
	
/************************************将工具条放到一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'描述', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
				},'-', btnSearch,'-',
				Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName), 
				'-', btnRefresh
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});



/************************************数据存储***********************************/
    var fields=[{
                    name : 'SpecialNursingRowId',
                    mapping : 'SpecialNursingRowId',
                    type : 'int'
                }, {
                    name : 'SpecialNursingCode',  
                    mapping : 'SpecialNursingCode',
                    type : 'string'
                }, {
                    name : 'SpecialNursingDesc',
                    mapping :'SpecialNursingDesc',
                    type:'string'
                },{
                    name:'SpecialNursingRemark',
                    mapping:'SpecialNursingRemark',
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
		{header:"Rowid",dataIndex:"SpecialNursingRowId",width: 85, sortable: true,hidden:true},
		{header:"代码",dataIndex:"SpecialNursingCode",width: 85, sortable: true},
		{header:"描述",dataIndex:"SpecialNursingDesc",width: 85, sortable: true} ,
		{header:'备注',dataIndex:'SpecialNursingRemark',width: 85, sortable: true}
	];
      

   
/************************************定义表格面板************************************/		
	var grid = new Ext.grid.GridPanel({ 
		title:"专项护理",  
		columns:GridCM,
		id:'grid',
		region: 'center',
		width:900,
		height:500,
		tools:Ext.BDP.FunLib.Component.HelpMsg, //右上角的小问号图标
		columnLines : true, //在列分隔处显示分隔符
		store:ds ,  
		viewConfig: {
			forceFit: true
		},
		tbar : tb,
		bbar:paging,  
		stateId : 'grid'
	});       
	
/************************************标准编码等功能************************************/	
	
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
  	
  	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
  	    
		
    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName); //用户习惯
	
	/************************************ 调用keymap*********************************************/
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);	
	
/************************************双击事件************************************/
	var loadFormData = function(grid){
		var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
		if (!_record) {
			Ext.Msg.alert('修改操作', '请选择要修改的一项!');
		} else {
			WinForm.form.load({
			url : OPEN_ACTION_URL + '&id='+ _record.get('SpecialNursingRowId'),  //id 对应OPEN里的入参
			success : function(form,action) {
			},
			failure : function(form,action) {
			}
			});
			//激活基本信息面板
			tabs.setActiveTab(0);
			//加载别名面板
			AliasGrid.DataRefer = _record.get('SpecialNursingRowId');
			AliasGrid.loadGrid();
		}
	};
	
	grid.on("rowdblclick", function(grid, rowIndex, e) {
			win.setTitle('修改');      ///双击后
			win.setIconClass('icon-update');
			win.show('');
			loadFormData(grid);
	});		
	
	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('SpecialNursingRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	var view =new Ext.Viewport({
		layout:'border',
		items:[grid]
	});
	
	
 });