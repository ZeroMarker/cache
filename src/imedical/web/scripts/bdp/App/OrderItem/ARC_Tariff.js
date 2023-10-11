
 /// @Author: 孙凤超 DHC-BDP
 /// @Description: 用于征收代码维护
 /// @Created on 2015-10-29
  /// 调用 别名维护 的后台类方法
 document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
 Ext.onReady(function() {
    Ext.QuickTips.init();            
    Ext.form.Field.prototype.msgTarget = 'qtip';        
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
    /// 调用 押金类型维护后台类方法
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCTariff&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCTariff&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCTariff&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCTariff ";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCTariff&pClassMethod=DeleteData";
   
    //初始化“别名”维护面板
    var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "ARC_Tariff"
  	});
   	Ext.BDP.FunLib.TableName="ARC_Tariff";
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
    Ext.BDP.FunLib.SortTableName = "User.ARCTariff";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
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
	   var RowID="",Desc="";
	   if (grid.selModel.hasSelection()) {
	       var rows = grid.getSelectionModel().getSelections(); 
	       RowID=rows[0].get('TARRowId');
	       Desc=rows[0].get('TARDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
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
                        AliasGrid.DataRefer=records[0].get('TARRowId');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('TARRowId') 
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
          name : 'TARRowId',
          mapping : 'TARRowId' 
     }, {
          name : 'TARCode',
          mapping :'TARCode' 
      }, {
          name : 'TARDesc',
          mapping :'TARDesc' 
     } 
  ]);
  /// RowID   
    var RowIdText=new Ext.BDP.FunLib.Component.TextField({
         fieldLabel : 'TARRowId',
         hideLabel : 'True',
         hidden : true,                             
         name : 'TARRowId'
    });
   /// Code
    var CodeText=new Ext.BDP.FunLib.Component.TextField({
         fieldLabel : '<font color=red>*</font>代码',
         labelSeparator:"",
         name : 'TARCode',
         id:'TARCodeF',
         readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARCodeF'),
         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARCodeF')),
         allowBlank: false,
         maxLength:15,
         enableKeyEvents : true,
         validationEvent : 'blur',  
         validator : function(thisText){
           if(thisText==""){  //当文本框里的内容为空的时候不用此验证
             return true;
           }
           var className =  "web.DHCBL.CT.ARCTariff";   
           var classMethod = "FormValidate";                      
           var id="";
           if(win.title=='修改'){  
              var _record = grid.getSelectionModel().getSelected();
              var id = _record.get('TARRowId');  
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
	      name : 'TARDesc',
	      maxLength:220,
	      id:'TARDescF',
	      readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARDescF'),
	      style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARDescF')),
	      allowBlank: false,
	      enableKeyEvents : true,
          validationEvent : 'blur',
          validator : function(thisText){
             if(thisText==""){  
                  return true;
             }
            var className =  "web.DHCBL.CT.ARCTariff";  
            var classMethod = "FormValidate";  
            var id="";
            if(win.title=='修改'){ 
            var _record = grid.getSelectionModel().getSelected();
            var id = _record.get('TARRowId');  
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
 Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName)
/*********************************增加、修改操作弹出的窗口***********************************/
	var win = new Ext.Window({
		width : 420,
		height : 290,
		buttonAlign : 'center',
		layout : 'fit',	
		closeAction : 'hide',
		plain : true,                                                  
		modal : false,
		frame : true,													 
		items : tabs,											 
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {									  
			var tempCode = Ext.getCmp("form-save").getForm().findField("TARCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("TARDesc").getValue();
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
									Ext.getCmp("form-save").getForm().findField("TARCode").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("TARDesc").focus(true,true);
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
							if (action.result.success == 'true') {  
								var myrowid = action.result.id;	
		                        win.hide();
				    	        Ext.Msg.show({						 
		  						           title : '提示',
											msg : '添加成功!',
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
                                 //保存别名
						        AliasGrid.DataRefer = myrowid;
				   	            AliasGrid.saveAlias();
							} 
							else {									
								var errorMsg = '';
								if (action.result.errorinfo) {     
									errorMsg = '<br />错误信息:'
											+ action.result.errorinfo
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
						//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {			
							Ext.Msg.alert('提示', '添加失败！');
						}
					})
				} 
				/**---------修改部分操作(操作过程与增加类似，重复代码不再注释)-------*/
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({                  
								clientValidation : true,           
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
				Ext.getCmp("form-save").getForm().findField("TARCode").focus(true,300);
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
			
  /********************************将数据读取出来并转换(成record实例)，为后面的读取和修改做准备*****************/
	var fields=[{												 
					name : 'TARRowId',
					mapping : 'TARRowId',
					type : 'int'
				}, {
					name : 'TARCode', 
					mapping : 'TARCode',
					type : 'string'
				}, {
					name : 'TARDesc',
					mapping : 'TARDesc',
					type : 'string'
				}]
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
	});
		
	/**********************************搜索按钮****************************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
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
						tbbutton.render(grid.tbar)                  
					}
				}
			});
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {					 
							header : 'ARCDT_RowId',
							width : 160,
							sortable : true,
							dataIndex : 'TARRowId',
							hidden : true                       
						}, {
							header : '代码',
							width : 160,
							sortable : true,
							dataIndex : 'TARCode'
						}, {
							header : '描述',
							width : 160,
							sortable : true,
							dataIndex : 'TARDesc'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				columnLines : true, 
				closable : true,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				store : ds,										 
				trackMouseOver : true,                              
				columns : GridCM,
				stripeRows : true,                                
				title : '征收代码',
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stateful : true,                                  
				viewConfig : {									 
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
					forceFit : true								  
				},
				bbar : paging,                                   
				tbar : tb,                                        
				stateId : 'grid'
			});
		Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
/**********************************右键菜单************************************/
    grid.addListener('rowcontextmenu', rightClickFn); 
    var rightClick = new Ext.menu.Menu({
      	id:'rightClickCont',  
      	disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
      	items: [
         {
             id: 'rMenu1',
             iconCls :'icon-delete',
             handler: DelData, 
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu1'),
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
      var selectrow=_record.get('TARRowId');
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
	                url : OPEN_ACTION_URL + '&id='+ _record.get('TARRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
                   },
	                failure : function(form,action) {
	                }
	            });
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('TARRowId');
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
 
 