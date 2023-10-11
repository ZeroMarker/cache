/**
 * @Title: 基础数据平台-基础数据
 * @Author: DHC-BDP sunfengchao
 * @Description: 患者级别维护
 * @Created on 2015-2-5
 */
Ext.data.Store.prototype.applySort=function(){  
	if (this.sortInfo&& !this.remoteSort){
		var s=this.sortInfo,f=s.field;
		var st=this.fields.get(f).sortType;
		var fn=function(r1,r2){
		  var v1=st(r1.data[f]), v2=st(r2.data[f]);
		  if(typeof(v1)=="string"){
		  	return v1.localeCompare(v2);
		  }
		  return v1>v2?1:(v1<v2? -1:0);
		};
		this.data.sort(s.direction,fn);
		if (this.snapshot && this.snapshot !=this.data){
			this.snapshot.sort(s.direction,fn);
		}
	}
};
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTEmpFunc&pClassQuery=GetList";
	var SAVE_ACTION_URL_New ="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTEmpFunc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTEmpFunc";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTEmpFunc&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTEmpFunc&pClassMethod=OpenData";

	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.CTEmpFunc";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "CT_EmpFunc"
   });
     Ext.BDP.FunLib.TableName="CT_EmpFunc";
     /// 获取查询配置按钮 
     var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
	 var btnTrans=Ext.BDP.FunLib.TranslationBtn;
	 var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	 if (TransFlag=="false")
	 {
		btnTrans.hidden=false;
	  }
	 else
	 {
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
	       RowID=rows[0].get('CTEMFRowID');
	       Desc=rows[0].get('CTEMFDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
	    }
  });
 /************************************ 删除功能************************************/
	var btnDel = new Ext.Toolbar.Button({
		id:'del_btn',
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		disabled:Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
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
					 return
				 } 
				 else{
					Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
					if (btn == 'yes') {
                         //删除所有别名
                        AliasGrid.DataRefer=records[0].get('CTEMFRowID') ;
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel(); 
						var rows = gsm.getSelections(); 
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('CTEMFRowID') 
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
											animEl: 'form-save',
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
														animEl: 'form-save',
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
													icon : Ext.Msg.ERROR,
													animEl: 'form-save',
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

  /// winform里的jsonreader
    var JsonReaderE=new Ext.data.JsonReader({root:'list'},
      [{
         name : 'CTEMFRowID',
         mapping : 'CTEMFRowID',
         type : 'int'
        }, {
         name : 'CTEMFCode',
         mapping : 'CTEMFCode',
         type : 'string'
        }, {
         name : 'CTEMFDesc',
         mapping :'CTEMFDesc',
         type:'string'
        }
     ]);
   /// RowID
     var RowIDText=new Ext.form.TextField({
           fieldLabel : 'CTEMFRowID',
	       hideLabel : 'True',
	       hidden : true,
	       name : 'CTEMFRowID'
      });
   /// Code    
    var CodeText=new Ext.form.TextField({
          fieldLabel : '<font color=red>*</font>代码',
          anchor: '85%',
          labelSeparator:"",
          allowBlank:false,
          regexText:"代码不能为空",
          name : 'CTEMFCode',
          id:'CTEMFCodeF',
          readOnly:Ext.BDP.FunLib.Component.DisableFlag('CTEMFCodeF'),
          style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTEMFCodeF')),
          enableKeyEvents : true,
          validationEvent : 'blur',  
          validator : function(thisText){
            if(thisText==""){   
                  return true;
               }
              var className =  "web.DHCBL.CT.CTEmpFunc";   
              var classMethod = "FormValidate";                      
              var id="";
              if(win.title=='修改'){  
                   var _record = grid.getSelectionModel().getSelected();
                   var id = _record.get('CTEMFRowID');  
                }
              var flag = "";
              var flag = tkMakeServerCall(className,classMethod,id,thisText,""); 
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
     });
  /// Desc
   var DescText=new Ext.form.TextField({
          fieldLabel : '<font color=red>*</font>描述',
          anchor: '85%',
	      allowBlank:false,
          labelSeparator:"",
	      regexText:"描述不能为空",
	      name : 'CTEMFDesc',
	      id:'CTEMFDescF',
	      readOnly:Ext.BDP.FunLib.Component.DisableFlag('CTEMFDescF'),
	      style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTEMFDescF')),
	      enableKeyEvents : true,
	      validationEvent : 'blur',
          validator : function(thisText){
             if(thisText==""){  
                   return true;
             }
             var className =  "web.DHCBL.CT.CTEmpFunc";  
             var classMethod = "FormValidate";  
             var id="";
             if(win.title=='修改'){ 
                var _record = grid.getSelectionModel().getSelected();
                var id = _record.get('CTEMFRowID');  
             }
             var flag = "";
             var flag = tkMakeServerCall(className,classMethod,id,"",thisText); 
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
   });
/************************************增加修改的Form************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				width : 300,
				split : true,
				frame : true,
                title:'基本信息',
				defaults : {
					border : false   
				},
				reader: JsonReaderE,
				items : [RowIDText,CodeText,DescText]
			});
  
 /*********************************重置form的数据清空**************************************/
        var ClearForm = function()
      {
          Ext.getCmp("form-save").getForm().reset()   
      }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
     var closepages= function (){
           win.hide();
           ClearForm();
      }  
   
 /*******************************定义‘基本信息’框*******************************************/
 var tabs=new Ext.TabPanel({
     id:'basic',
     activeTab: 0,
     frame:true,
     items:[WinForm,AliasGrid]
 });
Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		width : 420,
		height : 285,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : false,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 55,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled:Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("CTEMFCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("CTEMFDesc").getValue();
			if (tempCode=="") {
				Ext.Msg.show({ 
								title : '提示',
								msg : '代码不能为空!',
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTEMFCode").focus(true,true);
								}
							});
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '提示', 
								msg : '描述不能为空!', 
								minWidth : 200,
								animEl: 'form-save', 
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTEMFDesc").focus(true,true);
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
						clientValidation : true,  
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
			  		    	if (action.result.success == 'true') {
					     		var myrowid = action.result.id;
			                    win.hide();
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
                                  AliasGrid.DataRefer = myrowid;
                                  AliasGrid.saveAlias(); 
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=red>添加失败!</font>' ,
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
														msg : '<font color=red>修改失败!</font>' ,
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
				Ext.getCmp("form-save").getForm().findField("CTEMFCode").focus(true,300);
			},
			"hide" :  function(){
                  Ext.BDP.FunLib.Component.FromHideClearFlag();
                  closepages();
               },
			"close" : function() {
			}
		}
	});

/************************************增加按钮**********************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
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
/************************************修改按钮************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
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
	var fields= [{
					name : 'CTEMFRowID',
					mapping : 'CTEMFRowID',
					type : 'int'
				}, {
					name : 'CTEMFCode', 
					mapping : 'CTEMFCode',
					type : 'string'
				}, {
					name : 'CTEMFDesc',
					mapping :'CTEMFDesc',
					type:'string'
				}]
	/************************************数据存储************************************/
	var ds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : ACTION_URL
		}), 
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		},fields)
	});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);	
	/************************************数据加载************************************/	
	ds.load({
			params : {
						start : 0,
						limit : limit
					},
			callback : function(records, options, success) {
			}
		});  
	/************************************数据分页************************************/
	var paging = new Ext.PagingToolbar({
            pageSize: limit,
            store: ds,
            displayInfo: true,
            displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
            emptyMsg : "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
             listeners : {
					          "change":function (t,p)
					        { 
					           limit=this.pageSize;
					        }
			            }
        })
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel ,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]  
		})
	/************************************搜索工具条************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue(),
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
/************************************ 刷新工作条***********************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
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
/************************************ 将工具条放到一起**********************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled:Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled:Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
				},'-',LookUpConfigureBtn ,'-', btnSearch, '-', btnRefresh, '->'],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
/************************************create the Grid************************************/
	
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'CTEMFRowID',
							width : 160,
							sortable : true,
							dataIndex : 'CTEMFRowID',
							hidden : true
						}, {
							header : '代码',
							width : 160,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'CTEMFCode'
						}, {
							header : '描述',
							width : 160,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							sortable : true,
							dataIndex : 'CTEMFDesc'
					 
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stripeRows : true,
				columnLines : true,  
				title : '患者级别',
				stateful : true,
				viewConfig : {
					forceFit : true,
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true // 
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
  	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	// 单击事件：翻译要用到
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  var _record=grid.getSelectionModel().getSelected();
          var selectrow=_record.get('CTEMFRowID');
		 }
		else
		{
		  var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
  });

/************************************双击事件************************************/
 		   var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('CTEMFRowID'),  
	                success : function(form,action) {
                       
	        	    },
	                failure : function(form,action) {
	                }
	            });
                     //激活基本信息面板
	               tabs.setActiveTab(0);
	               //加载别名面板
	               AliasGrid.DataRefer = _record.get('CTEMFRowID');
	               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
			   	var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
				loadFormData(grid)
	    });	 
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/************************************键盘事件************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
});
 