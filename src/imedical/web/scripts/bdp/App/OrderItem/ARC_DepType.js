 /**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于押金类型维护。
 * @Created on 2012-8-4
 * @LastUpdated on 2013-6-24 by sunfengchao
 */
  /// 调用 别名维护 的后台类方法
    document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
    Ext.onReady(function() {
    Ext.QuickTips.init();            
    Ext.form.Field.prototype.msgTarget = 'qtip';        
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
    /// 调用 押金类型维护后台类方法
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCDepType&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCDepType&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCDepType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCDepType";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCDepType&pClassMethod=DeleteData";
   
    //初始化“别名”维护面板
      var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
       TableN : "ARC_DepType"
     });
     Ext.BDP.FunLib.TableName="ARC_DepType";
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
	 
    /*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.ARCDepType";
    var btnSort = Ext.BDP.FunLib.SortBtn;
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
       RowID=rows[0].get('ARCDTRowId');
       Desc=rows[0].get('ARCDTDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	/**----自定义一个表单验证Vtype*/
	Ext.apply(Ext.form.VTypes, {
		codetype:function(val, field) {                                 
         	var index = grid.getStore().findBy(function(record,id){       
         	return record.get(field.name) ==val;						 
         	});
         	if(win.title=="修改") {										 
         		var gsm = grid.getSelectionModel();				          
				var rows = gsm.getSelections();					         
				rowid = rows[0].get('ARCDTRowId');                        
				var index1 = grid.getStore().findBy(function(record,id){  
         			return record.get('ARCDTRowId') ==rowid;              
         		});
         		if (index1==index){										 
         			return true;
         		}
         	}
         	
         	if(index !='-1'){											 
                 return false; 
         	}
         	if(index == '-1'){  										   	
         		return true;
         	}   
		}
	});
    
 /***********************************定义删除按钮***********************************************/
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
					 return
				 }
				 else{
					Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
					if (btn == 'yes') {
                        //删除所有别名
                        AliasGrid.DataRefer=records[0].get('ARCDTRowId');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('ARCDTRowId') 
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
    var jsonReaderE=new Ext.data.JsonReader({root:'list'},
   [{ 
          name : 'ARCDTRowId',
          mapping : 'ARCDTRowId' 
     }, {
          name : 'ARCDTCode',
          mapping :'ARCDTCode' 
      }, {
          name : 'ARCDTDesc',
          mapping :'ARCDTDesc' 
     } 
  ]);
  /// RowID   
    var RowIdText=new Ext.BDP.FunLib.Component.TextField({
         fieldLabel : 'ARCDTRowId',
         hideLabel : 'True',
         hidden : true,                               //--------RowId属性隐藏
         name : 'ARCDTRowId'
    });
   /// Code
    var CodeText=new Ext.BDP.FunLib.Component.TextField({
         fieldLabel : '<font color=red>*</font>代码',
         name : 'ARCDTCode',
         id:'ARCDTCodeF',
         readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCDTCodeF'),
         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCDTCodeF')),
         allowBlank: false,
         enableKeyEvents : true,
         validationEvent : 'blur',  
         validator : function(thisText){
           if(thisText==""){  //当文本框里的内容为空的时候不用此验证
             return true;
           }
           var className =  "web.DHCBL.CT.ARCDepType";   
           var classMethod = "FormValidate"; //数据重复验证后台函数名                             
           var id="";
           if(win.title=='修改'){  
              var _record = grid.getSelectionModel().getSelected();
              var id = _record.get('ARCDTRowId');  
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
      });
   /// Desc
    var DescText=new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : '<font color=red>*</font>描述',
          labelSeparator:"",
	      name : 'ARCDTDesc',
	      id:'ARCDTDescF',
	      readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCDTDescF'),
	      style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCDTDescF')),
	      allowBlank: false,
	      enableKeyEvents : true,
          validationEvent : 'blur',
          validator : function(thisText){
             if(thisText==""){  
                  return true;
             }
            var className =  "web.DHCBL.CT.ARCDepType"; //后台类名称
            var classMethod = "FormValidate"; //数据重复验证后台函数名
            var id="";
            if(win.title=='修改'){ 
            var _record = grid.getSelectionModel().getSelected();
            var id = _record.get('ARCDTRowId');  
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
    });
	/*************************************创建一个供增加和修改使用的form********************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',	                                     							
				title:'基本信息',
				labelAlign : 'right',                                      
				width : 200,	
				split : true,											 
				frame : true,											 
				defaults : {											 
					anchor: '85%',
					border : false
				},
				reader:jsonReaderE,
				items : [RowIdText,CodeText,DescText]
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
 /*******************************定义‘基本信息’框*******************************************/
  var tabs=new Ext.TabPanel({
	     id:'basic',
	     activeTab: 0,
	     frame:true,
	     items:[WinForm,AliasGrid]
 });
 Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
/*********************************增加、修改操作弹出的窗口***********************************/
	var win = new Ext.Window({
		width : 420,
		height : 290,
		buttonAlign : 'center',
		layout : 'fit',													 
		plain : true,                                                  
		modal : false,
		frame : true,	
		closeAction : 'hide',		
		items : tabs,											 
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {									  
			var tempCode = Ext.getCmp("form-save").getForm().findField("ARCDTCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("ARCDTDesc").getValue();
			if (tempCode=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>代码不能为空!</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("ARCDTCode").focus(true,true);
								}
							});
			      			return;
					}
			if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>描述不能为空!</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("ARCDTDesc").focus(true,true);
								}
							});
			      			return;
				}
		     if(WinForm.getForm().isValid()==false){
		           Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
		           return;
		        } 
				/**-------添加部分操作----------*/	 
				if (win.title == "添加") {                                         
					WinForm.form.submit({
						clientValidation : true,                       
						url : SAVE_ACTION_URL_New,						 
						method : 'POST',
						
						/**下面有两种不同类型的success对象其表示的意义有所不同
						 * ①是submit的一个配置选项 表示服务器成功响应。不管你响应给客户端的内容是什么，
						 * ---------------------------------------只要响应成功就会执行这个success，跟你返回的内容无关
						 * ②是根据返回json中success属性判断的，如果success为true，则success否则 failure
						 */
						success : function(form, action) {              
							if (action.result.success == 'true') {    //如果json中success属性返回的为true
								var myrowid = action.result.id;	
		                        win.hide();
				    	        Ext.Msg.show({						 
		  						           title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,	   
											buttons : Ext.Msg.OK,      
											fn : function(btn) {      
												var startIndex = grid.getBottomToolbar().cursor;//获取当前页开始的记录数
												grid.getStore().load({ //-----------重新载入数据         
													params : { //-----------参数
															    start : 0,
																limit : limit,
																rowid : myrowid   //新添加的数据rowid
											    			}
													});
											   }
						 			});
                                 //保存别名
						        AliasGrid.DataRefer = myrowid;
				   	            AliasGrid.saveAlias();
							} 
							else {									//--------------如果jason中success属性返回的不是true
								var errorMsg = '';
								if (action.result.errorinfo) {      //--------------保存返回的错误信息
									errorMsg = '<br />错误信息:'
											+ action.result.errorinfo
								}
								Ext.Msg.show({						//--------------显示错误信息文本框
											title : '提示',
											msg : '添加失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
											buttons : Ext.Msg.OK    //--------------只有一个确定按钮
										});
							}

						},
						//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {			//--------------服务器端响应失败
							Ext.Msg.alert('提示', '添加失败！');
						}
					})
				} 
				/**---------修改部分操作(操作过程与增加类似，重复代码不再注释)-------*/
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({                   //---------------确定修改后，将表单的数据提交
								clientValidation : true,            //---------------进行客户端验证
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
											errorMsg = '<br />错误信息:'
													+ action.result.errorinfo
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
									Ext.Msg.alert('提示', '修改失败');
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
				Ext.getCmp("form-save").getForm().findField("ARCDTCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	/**************************************增加按钮*********************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData,
				scope : this										 
			});
	 function AddData() {                           
			   win.setTitle('添加');
		       win.setIconClass('icon-add');
			   win.show('new1');
			   WinForm.getForm().reset();	
               tabs.setActiveTab(0);
              //清空别名面板grid
              AliasGrid.DataRefer = "";
              AliasGrid.clearGrid();
	  }
	/*********************************修改按钮**************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {						        //-----------显示修改的窗口和form	
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
			
  /********************************将数据读取出来并转换(成record实例)，为后面的读取和修改做准备*****************/
	var fields=[{												 
					name : 'ARCDTRowId',
					mapping : 'ARCDTRowId',
					type : 'int'
				}, {
					name : 'ARCDTCode', 
					mapping : 'ARCDTCode',
					type : 'string'
				}, {
					name : 'ARCDTDesc',
					mapping : 'ARCDTDesc',
					type : 'string'
				}];
	var ds = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            
							url : ACTION_URL								 
						}),
				reader : new Ext.data.JsonReader({						     
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields) 
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
/**********************************************加载数据**********************************************/
	ds.load({
				 params : {												  
					     start : 0,
					    limit : limit
			    },
				callback : function(records, options, success) {           
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					
					if(success){
							 Ext.getCmp('grid').getSelectionModel().selectRow(0);
					}
				 */
				}
			});
			
/*********************************************分页工具条**********************************************/	
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
          });
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	/*********************************增删改工具条************************************************/
	var tbbutton = new Ext.Toolbar({
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 			   
		})
		
		
	/**********************************搜索按钮****************************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                          
				grid.getStore().baseParams={							 	
						code : Ext.getCmp('TextCode').getValue(),
						desc : Ext.getCmp('TextDesc').getValue()
												
				};
				grid.getStore().load({									 
					params : {
								start : 0,
								limit : limit
							}
				 });
			}
		});
			
	/*****************************************刷新按钮****************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function Refresh() {
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
			
	/********************************将工具条放在一起**************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				enableKeyEvents :true,
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode') 
						},
						 '-',
						'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')  
						},'-',LookUpConfigureBtn, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {                                      
					render : function() {                            
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	var GridCM= [new Ext.grid.CheckboxSelectionModel(), {								 
				header : 'ARCDT_RowId',
				width : 160,
				sortable : true,
				dataIndex : 'ARCDTRowId',
				hidden : true                         
			}, {
				header : '代码',
				width : 160,
				sortable : true,
				dataIndex : 'ARCDTCode'
			}, {
				header : '描述',
				width : 160,
				sortable : true,
				dataIndex : 'ARCDTDesc'
			}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				columnLines : true, //在列分隔处显示分隔符
				closable : true,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				store : ds,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns :GridCM,
				stripeRows : true,                                //------------------显示斑马线
				title : '押金类型',
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
					forceFit : true								  //-----------------固定大小
				},
				bbar : paging,                                    //-----------------底部状态栏
				tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid'
			});
	   Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	   /**********************************右键菜单************************************/
      grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
      var rightClick = new Ext.menu.Menu({
      id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
      disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
      items: [
         {
             id: 'rMenu1',
             iconCls :'icon-delete',
             handler: DelData,//点击后触发的事件
             disabled : true, //Ext.BDP.FunLib.Component.DisableFlag('rMenu1'),
             text: '删除数据'
         }, {
             id: 'rMenu2',
             iconCls :'icon-add',
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu2'),
             handler: AddData,
             text: '添加数据'
         },{
             id: 'rMenu3',
             iconCls :'icon-update',
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu3'),
             handler:UpdateData ,
             text: '修改数据'
         },{
          id:'rMenu4',
          iconCls :'icon-refresh',
          disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu4'),
          handler:function(){
               Ext.getCmp("grid").store.reload();
             },
          text:'刷新'
         }
     ]
 }); 
 
  /****************************************右键菜单的关键代码，右键可以选中一行***************************************************/
  function rightClickFn(grid,rowindex,e){
      e.preventDefault();
      var currRecord = false; 
      var currRowindex = false; 
      var currGrid = false; 
         if (rowindex < 0) { 
         return; 
   } 
     grid.getSelectionModel().selectRow(rowindex); 
     currRowIndex = rowindex; 
     currRecord = grid.getStore().getAt(rowindex); 
     currGrid = grid; 
     rightClick.showAt(e.getXY()); 
  }
 
btnTrans.on("click",function(){
	if (grid.selModel.hasSelection())
	{
	  var _record=grid.getSelectionModel().getSelected();
      var selectrow=_record.get('ARCDTRowId');
	 }
	else
	{
	  var selectrow=""
	 }
	Ext.BDP.FunLib.SelectRowId=selectrow
  });
	/******************************************双击事件***********************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('ARCDTRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
                   },
	                failure : function(form,action) {
	                }
	            });
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('ARCDTRowId');
               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
				loadFormData(grid);
	    });	
	    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	    /******************************快捷键操作*****************************************************/
  		Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
   /****************************创建viewport*******************************************************/
		var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	});
 
 