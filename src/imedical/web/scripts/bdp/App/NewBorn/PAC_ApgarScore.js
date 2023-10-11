/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于新生儿评分（阿氏评分)的维护。
 * @Created on 2012-8-6
 * @Updated on 2013-5-11
 * @LastUpdated on 2013-6-21 by sunfengchao
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
    var limit = Ext.BDP.FunLib.PageSize.Main;
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACApgarScore&pClassMethod=OpenData";
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACApgarScore&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACApgarScore&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACApgarScore";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACApgarScore&pClassMethod=DeleteData";

     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "PAC_ApgarScore"
 	 });
  	 Ext.BDP.FunLib.TableName="PAC_ApgarScore"
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

	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.PACApgarScore";
    var btnSort = Ext.BDP.FunLib.SortBtn;
	 
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
       RowID=rows[0].get('APGSRowId');
       Desc=rows[0].get('APGSDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
      /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名 
    /************************************ 删除功能********************************************************/
	var btnDel = new Ext.Toolbar.Button({
			id:'del_btn',
			text :'删除',
			tooltip : '删除',
			iconCls :'icon-delete',
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
                        //删除所有别名
                        AliasGrid.DataRefer=records[0].get('APGSRowId') ;
                        AliasGrid.delallAlias();
						Ext.MessageBox.wait('数据删除中,请稍候...', '<font color=blue>提示</font>');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('APGSRowId') 
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
			                                                    var startIndex = grid.getBottomToolbar().cursor;
			                                                    var totalnum=grid.getStore().getTotalCount();
			                                                    if(totalnum==1){   //修改添加后只有一条，返回第一页
												                var startIndex=0
												               }
												               else if((totalnum-1)%limit==0)//最后一页只有一条
												               {
												                 var pagenum=grid.getStore().getCount();
												                 if (pagenum==1){ startIndex=startIndex-limit;}  //最后一页的时候,不是最后一页则还停留在这一页
												               }
												             grid.getStore().load({
			                                                 params : {
														                   start : startIndex,
														                   limit : limit
														               }
														           });
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
 /*************** 双击时的json 解析**********************************************/
  var jsonReader=new Ext.data.JsonReader({root:'list'},[{
              name : 'APGSRowId',
              mapping :'APGSRowId' 
             }, {
              name : 'APGSCode',
              mapping : 'APGSCode' 
             }, {
              name : 'APGSDesc',
              mapping :'APGSDesc' 
             },{
              name:'APGSNationalCode',
              mapping:'APGSNationalCode' 
             },{
              name:'APGSCount',
              mapping:'APGSCount'
             }  
          ]);
          
  /// rowid
   var rowidText=new Ext.form.TextField({
         fieldLabel : 'APGSRowId',
         hideLabel : 'True',
         hidden : true,
         name : 'APGSRowId'
   }); 
  /// code
   var codeText=new Ext.BDP.FunLib.Component.TextField({
            fieldLabel : '<font color=red>*</font>代码',
            name : 'APGSCode',
            id:'APGSCodeF',
            stripCharsRe :  ' ',
            allowBlank : false,
            anchor: '85%',
            readOnly : Ext.BDP.FunLib.Component.DisableFlag('APGSCodeF'),
            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('APGSCodeF')),
            enableKeyEvents : true,
            validationEvent : 'blur',  
            validator : function(thisText){
            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                   return true;
              }
             var className =  "web.DHCBL.CT.PACApgarScore";   
             var classMethod = "FormValidate"; //数据重复验证后台函数名                             
             var id="";
             if(win.title=='修改'){  
                  var _record = grid.getSelectionModel().getSelected();
                  var id = _record.get('APGSRowId');  
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
   ///  desc
   var descText=new Ext.BDP.FunLib.Component.TextField({
           	 fieldLabel : '<font color=red>*</font>描述',
             allowBlank:false,
             anchor: '85%',
             regexText : "对不起,此项为必填项!",
             name : 'APGSDesc',
             id:'APGSDescF',
             enableKeyEvents : true,
             validationEvent : 'blur',
             readOnly : Ext.BDP.FunLib.Component.DisableFlag('APGSDescF'),
             style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('APGSDescF')),
             validator : function(thisText){
             if(thisText==""){  
               	return true;
              }
             var className =  "web.DHCBL.CT.PACApgarScore"; //后台类名称
             var classMethod = "FormValidate"; //数据重复验证后台函数名
             var id="";
             if(win.title=='修改'){ 
             	 var _record = grid.getSelectionModel().getSelected();
                 var id = _record.get('APGSRowId');  
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
   /// nationalcode
    var nationalcodeText=new Ext.BDP.FunLib.Component.TextField({
              fieldLabel:'NationalCode',
              anchor: '85%',
              id:'NationalCodeF',
              name:'APGSNationalCode',
              readOnly : Ext.BDP.FunLib.Component.DisableFlag('NationalCodeF'),
              style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('NationalCodeF'))
    });
    // ApgsCount
    var apgscountText=new Ext.BDP.FunLib.Component.TextField({
              fieldLabel : '<font color=red>*</font>分数',
              allowblank:false,
              anchor: '85%',
              regex : /^(([0-9]+)+)$/,
              regexText : "对不起,您只能输入0或者正整数!",
              minValue:0,
              maxValue:100,
              name:'APGSCount',
              id:'APGSCountF',
              readOnly : Ext.BDP.FunLib.Component.DisableFlag('APGSCountF'),
              style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('APGSCountF'))
    });
  /************************************增加修改的Form************************************/
       var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				split : true,
				frame : true,
				title:'基本信息',
				reader: jsonReader,
				items : [rowidText,codeText,descText,nationalcodeText,apgscountText]
		 });
				 
  /*********************************关闭弹出窗口时的函数方法*********************************/
          var closepages= function (){
               win.hide();  
               Ext.getCmp("form-save").getForm().reset();   
		 }
    
 /*******************************定义‘基本信息’框*******************************************/
 var tabs=new Ext.TabPanel({
     id:'basic',
     activeTab: 0,
     frame:true,
     items:[WinForm,AliasGrid]
 });
 Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	/************************************增加修改时弹出窗口************************************/
	var win = new Ext.Window({
		id:'window',
		width : 430 ,
        height :320,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : false,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 65,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled:Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("APGSCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("APGSDesc").getValue();
			var tempNationalCode = Ext.getCmp("form-save").getForm().findField("APGSNationalCode").getValue();
			var tempCount = Ext.getCmp("form-save").getForm().findField("APGSCount").getValue();
			if (tempCode=="") {
				Ext.Msg.show({
								title : '<font color=blue>提示</font>',
								msg : '<font color=red>代码不能为空!</font>', 
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								fn:function ss(){
								    Ext.getCmp("form-save").getForm().findField("APGSCode").focus(true,true);
							  },
								buttons : Ext.Msg.OK 
							});
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>描述不能为空!</font>', 
								minWidth : 200, 
								icon : Ext.Msg.ERROR,
								animEl: 'form-save',
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("APGSDesc").focus(true,true);
								},
								buttons : Ext.Msg.OK 
			  				});
      		 		 return;
			}
				if (tempCount==""){
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>分数不能为空!</font>', 
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("APGSCount").focus(true,true);
								},
								buttons : Ext.Msg.OK
							 });
      				return;
				}
			if (tempCount>100||tempCount<0) {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>分数超出限定范围!</font>', 
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								animEl: 'form-save',
								buttons : Ext.Msg.OK
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
							    Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=green>添加成功!</font>',
												icon : Ext.Msg.INFO,
												animEl: 'form-save',
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
												msg : '<font color=red> 添加失败!</font>' ,
												minWidth : 200,
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
									}
							},
						  failure : function(form, action) {
						   	Ext.Msg.alert('<font color=blue>提示</font>', '<font color=red>添加失败!</font>');
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
										var myrowid ='rowid='+ action.result.id;
                                        win.hide();
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=green> 修改成功!</font>',
														animEl: 'form-save',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														 fn : function(btn) {
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
														animEl: 'form-save',
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
											}
									},
								failure : function(form, action) {
									Ext.Msg.alert('<font color=blue>提示</font>', '<font color=red>修改失败!</font>');
								}
							})
						}
					}, this);
				}
			}
		},{
			text : '关闭',
            iconCls : 'icon-close',
			id:'cancel_btn',
			handler : function() {
			    win.hide();
                Ext.getCmp("form-save").getForm().reset();  
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("APGSCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag(); 
			     closepages();
               },
			"close" : function() {
			}
		}
	});
	/************************************ 增加按钮************************************/
	var btnAddwin = new Ext.Toolbar.Button({
				id:'add_btn',
				text : '添加',
				tooltip : '添加',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				iconCls : 'icon-add',
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
/************************************ 修改按钮************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				id:'update_btn',
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
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
				 };
				if(recordsLen > 1){
						Ext.Msg.show({
							title:'提示',
							minWidth:280,
							msg:'修改时每次只能选择一条数据,请重新选择!',
							icon:Ext.Msg.WARNING,
							buttons:Ext.Msg.OK,
							fn:function(btn){
							var view = grid.getView();
							var sm = grid.getSelectionModel();
							if(sm){
									sm.clearSelections();
									var hd = Ext.fly(view.innerHd);
									var c = hd.query('.x-grid3-hd-checker-on');
									if(c && c.length>0){
															Ext.fly(c[0]).removeClass('x-grid3-hd-checker-on')
														}
								 }
							}
						});
				  }
				 else{
				   		win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						loadFormData(grid);
					 }
      		 }
    });
 
/************************************数据保存*************************************/
    var fields=[{     
		            name : 'APGSRowId',
					mapping :'APGSRowId',
					type : 'int'
				}, { 
					name : 'APGSCode',
					mapping : 'APGSCode',
					type : 'string'
				}, {
					name : 'APGSDesc',
					mapping :'APGSDesc',
					type:'string'
				},{
					name:'APGSNationalCode',
					mapping:'APGSNationalCode',
					type:'string'
				},{
					name:'APGSCount',
					mapping:'APGSCount',
					type:'int'
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
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
/*********************************数据加载问题***********************************/
	ds.load({
				params : {
					start : 0,
					limit : limit
				},
				callback : function(records, options, success) {
				}
			}); // 加载数据
/*********************************数据分页***************************************/
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
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]   
		})
	var search=function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue(),
						nationalcode :Ext.getCmp("nationalcode").getValue() ,
						score:Ext.getCmp("TextScore").getValue()
				};
				grid.getStore().load({
						params : {
									start : 0,
									limit : limit
								}
							});
						}
/************************************搜索工具条************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : search 
			});
  	 var refresh=function () {
  	 			Ext.BDP.FunLib.SelectRowId="";
				Ext.getCmp("TextCode").reset();
				Ext.getCmp("TextDesc").reset();
				Ext.getCmp("nationalcode").reset();
				Ext.getCmp("TextScore").reset();
				grid.getStore().baseParams={};
				grid.getStore().load({
							params : {
											start : 0,
											limit : limit
									}
							});
						}
/************************************刷新工作条***********************************/
		var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				disabled:Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				text : '重置',
				handler : refresh
			});
	/************************************将工具条放到一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode') 
					},	'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
                            labelSeparator:"" 
					},'NationalCode',{
							xtype : 'textfield',
							id : 'nationalcode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('nationalcode'),
                            labelSeparator:"" 
					},'分数',{
							xtype:'textfield',
							id:'TextScore',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextScore') 
					},'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'],
				listeners : {
								render : function() {
								tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
							}
				}	
	});
/********************************************* create the Grid ************************************/
		var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header :'APGSRowId',
						    width:30,
							sortable : true,
						    hidden:true,
							dataIndex : 'APGSRowId'
					  }, {
							header : '代码',
							id:'APPSCode',
							width:100,
							sortable : true,
							trackMouseOver:true, //鼠标特效
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'APGSCode'
						}, {
							header : '描述',
							width:100,
							sortable : true,
							trackMouseOver:true, //鼠标特效
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'APGSDesc'
						}, {
							header : 'NationalCode',
							width:100,
							sortable : true,
							dataIndex : 'APGSNationalCode'
						},{
							header : '分数',
							width:100,
							sortable : true,
							dataIndex : 'APGSCount'
						}];

	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				trackMouseOver : true,
			//	singleSelect: true ,
				monitorResize : true,
				store : ds,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				trackMouseOver : true,
				columnLines : true, //在列分隔处显示分隔符
				columns :GridCM ,
				sm:new Ext.grid.CheckboxSelectionModel(),
				stripeRows : true,
				title : '新生儿评分(阿氏评分)',
				stateful : true,
				viewConfig : {
					forceFit: true, // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化(比如你resize了它)时不会自动调整column的宽度
					scrollOffset: 0 ,//不加这个的话,会在grid的最右边有个空白,留作滚动条的位置
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				autoFill:true,
    				enableRowBody: true // 
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
 		Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	 /********************************右键菜单维护**************************************/		
            grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
        	{
	            id: 'rMenu1',
	            iconCls :'icon-delete',
	            handler: DelData,//点击后触发的事件
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
/***************************************双击事件*************************************/
	   var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('APGSRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
		              },
	                failure : function(form,action) {
	                }
	            });
                 //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('APGSRowId');
               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      
				win.setIconClass('icon-update');
				win.show('');
				loadFormData(grid)
	    });	
	    
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection())
			{
			  var _record=grid.getSelectionModel().getSelected();
		      var selectrow=_record.get('APGSRowId');
			}
			else
			{
			  var selectrow=""
			}
			Ext.BDP.FunLib.SelectRowId=selectrow
  	});
  	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
  	 /************************************键盘事件，按快捷键实现相应的功能***********************************/
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	});