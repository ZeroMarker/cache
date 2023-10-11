/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于过敏原分类维护 
 * @Created on 2013-9-3
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
// document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPStandardCodeFormPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    /// 调用 过敏原分类维护 的后台类方法
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCAllType";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassMethod=OpenData";
 
      //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "MRC_AllType"
   });
 	 Ext.BDP.FunLib.TableName="MRC_AllType"
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
    /*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.MRCAllType";
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
       RowID=rows[0].get('MRCATRowId');
       Desc=rows[0].get('MRCATDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
 /***************************************** 删除功能***********************************************************/
	var btnDel = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'icon-delete',
			id:'del_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
			enableKeyEvents:true,
			enableToggle:true,
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
                        AliasGrid.DataRefer=records[0].get('MRCATRowId') ;
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
								  url : DELETE_ACTION_URL,
								  method : 'POST',
								  params : {
							        'id':rows[0].get('MRCATRowId') 
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
 
  /**********************winform 的json解析****************************/
    var JsonReaderE=new Ext.data.JsonReader({root:'list'},
    [{
         name : 'MRCATRowId',
         mapping : 'MRCATRowId',
         type : 'int'
      }, {
         name : 'MRCATCode',
         mapping : 'MRCATCode',
         type : 'string'
        }, {
         name : 'MRCATDesc',
         mapping :'MRCATDesc',
         type:'string'
        },{
         name:'MRCATTagDescription',
         mapping:'MRCATTagDescription',
         type:'string' 
        } ,{
         name:'MRCATDateFrom',
         mapping:'MRCATDateFrom',
         type : 'string'
        }, {
         name :'MRCATDateTo',
         mapping :'MRCATDateTo',
         type : 'string'
        }// 列的映射
     ]);
   /// RowID
    var RowIDText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : 'MRCATRowId',
        hideLabel : 'True',
        hidden : true,
        name : 'MRCATRowId'
    });
   /// Code
    var CodeText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : '<font color=red>*</font>代码',
        allowBlank:false,
        regexText:"代码不能为空",
        name : 'MRCATCode',
        anchor: '85%',
        id:'MRCATCodeF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCATCodeF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCATCodeF')),
        enableKeyEvents : true,
        validationEvent : 'blur',  
        validator : function(thisText){
            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
            return true;
          }
        var className =  "web.DHCBL.CT.MRCAllType";   
        var classMethod = "FormValidate"; //数据重复验证后台函数名                             
        var id="";
        if(win.title=='修改'){  
              var _record = grid.getSelectionModel().getSelected();
              var id = _record.get('MRCATRowId');  
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
       allowBlank:false,
       regexText:"描述不能为空",
       name : 'MRCATDesc',
       anchor: '85%',
       id:'MRCATDescF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCATDescF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCATDescF')),
       enableKeyEvents : true,
       validationEvent : 'blur',
       validator : function(thisText){
         if(thisText==""){  
             return true;
         }
        var className =  "web.DHCBL.CT.MRCAllType"; //后台类名称
        var classMethod = "FormValidate"; //数据重复验证后台函数名
        var id="";
        if(win.title=='修改'){ 
          var _record = grid.getSelectionModel().getSelected();
          var id = _record.get('MRCATRowId');  
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
   
   
   /// TagDescription
  var ALG_TAG_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassMethod=GetSelectItems";
  var TagDescriptionText= new Ext.BDP.Component.form.ComboBox({  
            fieldLabel:'过敏类型',
            id:'MRCATTagDescriptionF',
            name:'MRCATTagDescription',
            anchor: '85%',
            readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCATTagDescriptionF'),
            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCATTagDescriptionF')),
            loadByIdParam:'rowid',
            hiddenName : 'MRCATTagDescription',
            store : new Ext.data.Store({
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
                        proxy : new Ext.data.HttpProxy({ url : ALG_TAG_DR_QUERY_ACTION_URL }),
                        reader : new Ext.data.JsonReader({
                        totalProperty : 'total',
                        root : 'data',
                        successProperty : 'success'
                    }, [{ name:'StoredValue',mapping:'StoredValue'},
                        {name:'Description',mapping:'Description'} ])
                }),
            displayField:'Description',
            valueField:'StoredValue' 
  });
  /// DateFrom 
  var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'MRCATDateFrom',
       anchor: '85%',
       id:'MRCATDateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCATDateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCATDateFromF')),
       format : BDPDateFormat,
       allowBlank:false,
       regexText:"开始日期不能为空",
       editable:true,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
  });
  /// DateTo 
 var DateToText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '结束日期',
       name : 'MRCATDateTo',
       anchor: '85%',
       id:'MRCATDateToF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCATDateToF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCATDateToF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
 });
 
/****************************增加修改的Form*****************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				split : true,
				waitMsgTarget : true,
				frame : true,
                title:'基本信息',
				defaults : {
					border : false   
				},
				reader:JsonReaderE,
				items : [RowIDText,CodeText,DescText,TagDescriptionText,DateFromText,DateToText]
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

/****************************** 增加修改时弹出窗口***************************/
	var win = new Ext.Window({
		width : 460,
		height : 410,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : false,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:1px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("MRCATCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("MRCATDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("MRCATDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("MRCATDateTo").getValue();
		 
			if (tempCode=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>代码不能为空!</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("MRCATCode").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("MRCATDesc").focus(true,true);
								}
							});
      				return;
			}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>',
								msg : '<fontc color=red>开始日期不能为空!</font>',
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("MRCATDateFrom").focus(true,true);
								}
							});
			      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
			    					title : '<font color=blue>提示</font>',
									msg : '<font color=red>开始日期不能大于结束日期!</font>',
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
      			 		return;
  					}
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
			   		     AliasGrid.DataRefer = myrowid;
                         AliasGrid.saveAlias();  
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
											msg : '<font color=red>添加失败!</font>',
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
								clientValidation : true,  
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
							   	 if (action.result.success == 'true') {
                                    AliasGrid.saveAlias(); 
							    	var myrowid = 'rowid='+action.result.id;
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
		},{
			text : '关闭',
            iconCls : 'icon-close',
			handler : function() {
			 win.hide();  
             ClearForm(); 
			}
		}],
		listeners : {
			"show" : function() {
			Ext.getCmp("form-save").getForm().findField("MRCATCode").focus(true,300);
			},
			"hide" : function(){
                  Ext.BDP.FunLib.Component.FromHideClearFlag();
                  closepages();
                  AliasGrid.DataRefer = "";
		          AliasGrid.clearGrid();
               },
			"close" : function() {
			}
		}
	});
	/************************** 增加按钮***********************************/
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
	/***************************修改按钮**********************************/
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
    var fields=[{
					name : 'MRCATRowId',
					mapping : 'MRCATRowId',
					type : 'int'
				}, {
					name : 'MRCATCode',
					mapping : 'MRCATCode',
					type : 'string'
				}, {
					name : 'MRCATDesc',
					mapping :'MRCATDesc',
					type:'string'
				},{
					name:'MRCATTagDescription',
					mapping:'MRCATTagDescription',
					type:'string',
					renderer : function(v){
						if(v=='Generic'){ return 'G'; }
						if(v=='Pharmacy Item'){ return 'P'; }
						if(v=='Ingredient'){ return 'I';}
			       }
				}, {
					name:'MRCATDateFrom',
					mapping:'MRCATDateFrom',
					type : 'date',
                    dateFormat : 'm/d/Y'
				}, {
					name :'MRCATDateTo',
					mapping :'MRCATDateTo',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
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
	ds.load({
				params : {
							start : 0,
							limit : limit
				},
				callback : function(records, options, success) {
				}
			}); 
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
	/****************************增删改工具条*********************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel ,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
		})
	/*****************************搜索工具条*********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function search() {
			    canceldata=Ext.getCmp("TextMRCATTagDescription").getValue()
				if(canceldata=="G")
				{
					canceldata="Generic"
				}
				if(canceldata=="P")
				{
					canceldata="Pharmacy Item"
				}
				if(canceldata=="I")
				{
					canceldata="Ingredient"
				}
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue() ,
						desc : Ext.getCmp("TextDesc").getValue(),
						cancel :Ext.getCmp("TextMRCATTagDescription").getValue()
				};
				grid.getStore().load({
					params : {
								start : 0,
								limit : limit
							}
						});
					}
			});
	
	/****************************刷新工作条**************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
				    Ext.getCmp("TextMRCATTagDescription").reset()
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : limit
								}
							});
						}
			});
	/**************************** 将工具条放到一起********************************/
     var TextTagDescriptionText= new Ext.BDP.Component.form.ComboBox({  
            fieldLabel:'过敏类型',
            id:'TextMRCATTagDescription',
            name:'MRCATTagDescription',
            anchor: '85%',
            readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextMRCATTagDescription'),
            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextMRCATTagDescription')),
            loadByIdParam:'rowid',
            hiddenName : 'MRCATTagDescription',
            store : new Ext.data.Store({
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
                        proxy : new Ext.data.HttpProxy({ url : ALG_TAG_DR_QUERY_ACTION_URL }),
                        reader : new Ext.data.JsonReader({
                        totalProperty : 'total',
                        root : 'data',
                        successProperty : 'success'
                    }, [{ name:'StoredValue',mapping:'StoredValue'},
                        {name:'Description',mapping:'Description'} ])
                }),
            displayField:'Description',
            valueField:'StoredValue' 
  });
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
   					},'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
					} ,'过敏类型',TextTagDescriptionText 
                 ,'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) 
					}
				}
			}); 
			
	var sm=new Ext.grid.CheckboxSelectionModel({singleSelect:true})
	var GridCM=[new Ext.grid.CheckboxSelectionModel(),  {
							header : 'MRCATRowId',
							width : 40,
							sortable : true,
							dataIndex : 'MRCATRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'MRCATCode'  
						}, {
							header : '描述',
							width : 80,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'MRCATDesc'
						}, {
							header : '过敏类型',
							width : 80,
							sortable : true,
							dataIndex : 'MRCATTagDescription' 
						},  {
							header : '开始日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'MRCATDateFrom'
						}, {
							header : '结束日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'MRCATDateTo'
						}
					];
	// create the Grid 
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				sortable:true,
				store : ds,
				trackMouseOver : true,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				trackMouseOver : true,
				columns:GridCM,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stripeRows : true,
				columnLines : true, 
				title : '过敏原分类',
				stateful : true,
				viewConfig : {
					forceFit : true,
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true  
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
      Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	/*****************************************双击事件*********************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	           Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        	WinForm.form.load( {
	               url : OPEN_ACTION_URL + '&id='+ _record.get('MRCATRowId'),  //id 对应OPEN里的入参
	               success : function(form,action) {
                     
                    },
	                failure : function(form,action) {   
	                }
	            });
                
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('MRCATRowId');
               AliasGrid.loadGrid();
	        }
	    };
	btnTrans.on("click",function()
	{
		if (grid.selModel.hasSelection())
		{
		  	var _record=grid.getSelectionModel().getSelected();
	        var selectrow=_record.get('MRCATRowId');
		}
		else
		{
		  var selectrow=""
		}
		Ext.BDP.FunLib.SelectRowId=selectrow
  });
	  grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	var row = grid.getStore().getAt(rowIndex).data;	
		   	var _record=grid.getSelectionModel().getSelected();
	        var selectrow=_record.get('MRCATRowId');
			win.setTitle('修改');      
			win.setIconClass('icon-update');
			win.show('');
			loadFormData(grid)
     });	
	  
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName); 
	/***------------------键盘事件，使用快捷键实现增删改功能，------------------***/
   	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
  });