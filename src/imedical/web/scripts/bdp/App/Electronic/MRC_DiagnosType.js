/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于诊断类型维护。
 * @Created on 2014-12-11
 */
/// 调用 别名维护 的后台类方法
 document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCDiagnosType&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCDiagnosType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCDiagnosType";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCDiagnosType&pClassMethod=DeleteData";
	var OPEN_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCDiagnosType&pClassMethod=OpenData";
   
     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "MRC_DiagnosType"
   });
     Ext.BDP.FunLib.TableName="MRC_DiagnosType";
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
    Ext.BDP.FunLib.SortTableName = "User.MRCDiagnosType";
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
	       RowID=rows[0].get('DTYPRowId');
	       Desc=rows[0].get('DTYPDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
	    }
  });
    
/*********************************删除功能**********************************/
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
					Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
                        AliasGrid.DataRefer=records[0].get('DTYPRowId');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('DTYPRowId') 
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '删除成功!',
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
														title : '提示',
														msg : '数据删除失败!' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														animEl: 'form-save',
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接!',
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
         name : 'DTYPRowId',
         mapping :'DTYPRowId',
         type : 'int'
        }, {
         name : 'DTYPCode',
         mapping : 'DTYPCode',
         type : 'string'
        }, {
         name : 'DTYPDesc',
         mapping :'DTYPDesc',
         type:'string'
        } ,{
         name:'DTYPNoSendToCoding',
         mapping:'DTYPNoSendToCoding',
         inputValue : true?'Y':'N',
         type:'string'
        }, {
         name : 'DTYPClinicType',
         mapping :'DTYPClinicType',
         type:'string'
        }, {
         name : 'DTYPDateFrom',
         mapping :'DTYPDateFrom',
         type:'string'
        }, {
         name : 'DTYPDateTo',
         mapping :'DTYPDateTo',
         type:'string'
        },{name: 'DTYPClinicTypeO',mapping:'DTYPClinicTypeO',type:'string'},
         {name: 'DTYPClinicTypeE',mapping:'DTYPClinicTypeE',type:'string'},
         {name: 'DTYPClinicTypeI',mapping:'DTYPClinicTypeI',type:'string'},
         {name: 'DTYPClinicTypeH',mapping:'DTYPClinicTypeH',type:'string'},
         {name: 'DTYPClinicTypeN',mapping:'DTYPClinicTypeN',type:'string'}   
     ]);
     
   /// Rowid
    var RowIdText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : 'DTYPRowId',
        hideLabel : 'True',
        hidden : true,
        name : 'DTYPRowId'
    });
   /// Code
   var CodeText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : '<font color=red>*</font>代码',
        allowBlank:false,
        regexText:"代码不能为空",
        name : 'DTYPCode',
        id:'DTYPCodeF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DTYPCodeF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DTYPCodeF')),
        enableKeyEvents : true ,
        validationEvent : 'blur',  
        validator : function(thisText){
          if(thisText==""){  //当文本框里的内容为空的时候不用此验证
               return true;
           }
          var className =  "web.DHCBL.CT.MRCDiagnosType";   
          var classMethod = "FormValidate"; //数据重复验证后台函数名                             
          var id="";
          if(win.title=='修改'){  
          var _record = grid.getSelectionModel().getSelected();
          var id = _record.get('DTYPRowId');  
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
       name : 'DTYPDesc',
       id:'DTYPDescF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DTYPDescF') ,
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DTYPDescF')),
       enableKeyEvents : true,
       validationEvent : 'blur',
                            validator : function(thisText){
                             if(thisText==""){  
                              return true;
                             }
                             var className =  "web.DHCBL.CT.MRCDiagnosType"; //后台类名称
                             var classMethod = "FormValidate"; //数据重复验证后台函数名
                             var id="";
                             if(win.title=='修改'){ 
                              var _record = grid.getSelectionModel().getSelected();
                              var id = _record.get('DTYPRowId');  
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
 
   /// DTYPNoSendToCoding
    var DTYPNoSendToCodingCheck=new Ext.BDP.FunLib.Component.Checkbox({
           fieldLabel:'DTYPNoSendToCoding',
	       name:'DTYPNoSendToCoding',
	       id:'DTYPNoSendToCodingF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DTYPNoSendToCodingF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DTYPNoSendToCodingF')),
	       autoHeight:'true',
	       hideLabels:true,
	       inputValue : true?'Y':'N'
    });

   	  /// DateFrom 
  	var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'DTYPDateFrom',
       anchor: '85%',
       id:'DTYPDateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DTYPDateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DTYPDateFromF')),
       format : BDPDateFormat,
       allowBlank:false,
       regexText:"开始日期不能为空",
       editable:true,
       value:new Date(),
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
	       name : 'DTYPDateTo',
	       anchor: '85%',
	       id:'DTYPDateToF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DTYPDateToF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DTYPDateToF')),
	       format : BDPDateFormat,
	       enableKeyEvents : true,
	       listeners : {   
	        'keyup' : function(field, e)
	        { 
	            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
	        }}
	 });

/************************************增加修改的Form************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
                title:'基本信息',
				labelAlign : 'right',
                labelWidth : 170,
				split : true,
				frame : true,
				defaults : {
					anchor: '80%',
					bosrder : false   
				},
				reader:jsonReaderE,
				defaultType : 'textfield',
				items : [RowIdText, CodeText, DescText,DTYPNoSendToCodingCheck,DateFromText,DateToText, {
							xtype:'fieldset',
				            title: '就诊类型' , 
				            style: 'margin-left:43px;',
		           			bodyStyle: 'margin-left:-54px;',
				            items: [{
				            		xtype : 'checkboxgroup',   ////// 控制哪些类型可开，值为空则都可以开   O,E,I,H,N  (门诊,急诊,住院,体检,新生儿)
								    id:'DTYPClinicTypeF',
								    readOnly : Ext.BDP.FunLib.Component.DisableFlag('DTYPClinicTypeF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DTYPClinicTypeF')),
								    columns: 1,
								    items: [
								        {boxLabel: '门诊', name: 'DTYPClinicTypeO',id: 'DTYPClinicTypeO', inputValue : 'O'},
								        {boxLabel: '急诊', name: 'DTYPClinicTypeE',id: 'DTYPClinicTypeE', inputValue : 'E'},
								        {boxLabel: '住院', name: 'DTYPClinicTypeI',id: 'DTYPClinicTypeI', inputValue : 'I'},
								        {boxLabel: '体检', name: 'DTYPClinicTypeH',id: 'DTYPClinicTypeH', inputValue : 'H'},
								        {boxLabel: '新生儿', name: 'DTYPClinicTypeN',id: 'DTYPClinicTypeN', inputValue : 'N'}
								    ]
				            }]
							
						
						}]
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
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		width : 430,
		height : 470,
		layout : 'fit',
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
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("DTYPCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("DTYPDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("DTYPDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("DTYPDateTo").getValue();
			                     //获取通过checkboxgroup定义的checkbox值
			var ClinicTypeCheck = Ext.getCmp('DTYPClinicTypeF').items;

			var ClinicType = "";
			
			for(var i = 0; i < ClinicTypeCheck.length; i++){

				if(ClinicTypeCheck.get(i).checked){
					if (ClinicType=="")
					{
						ClinicType=ClinicTypeCheck.get(i).boxLabel;
					}
					else
					{
						ClinicType+=","+ClinicTypeCheck.get(i).boxLabel;
					}

				}

			}
			if (ClinicType=="")
			{
				Ext.Msg.show({ 
							title : '提示',
							msg : '就诊类型不能为空!', 
							minWidth : 200,
							animEl: 'form-save',
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK 
						});
      			return;
			}
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
									Ext.getCmp("form-save").getForm().findField("DTYPCode").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("DTYPDesc").focus(true,true);
								}
							});
      			return;
			}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '提示',
								msg : '开始日期不能为空!',
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("DTYPDateFrom").focus(true,true);
								}
							});
			      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
			    					title : '提示',
									msg : '开始日期不能大于结束日期!',
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
      			 		return;
  					}
			 }

             if(WinForm.getForm().isValid()==false){
	           Ext.Msg.alert('提示','数据验证失败，<br />请检查您的数据格式是否有误！');
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
											title : '提示',
											msg : '添加成功!',
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
                                   //保存别名
                                    AliasGrid.DataRefer = myrowid;
                                    AliasGrid.saveAlias();
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
												title : '提示',
												msg : '添加失败!',
												minWidth : 200,
												animEl: 'form-save',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
									}
						},
						failure : function(form, action) {
							Ext.Msg.show({
											title : '提示',
											msg : '添加失败!' ,
											minWidth : 200,
											animEl: 'form-save',
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
					})
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
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
			                                  title : '提示',
			                                  msg : '<font color=green> 修改成功!',
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
														title : '提示',
														msg : '修改失败!',
														minWidth : 200,
														animEl: 'form-save',
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										}
								},
								failure : function(form, action) {
									Ext.Msg.show({
													title : '提示',
													msg : '修改失败!' ,
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
				Ext.getCmp("form-save").getForm().findField("DTYPCode").focus(true,250);
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
					 }
      		 }
    });
/************************************数据存储***********************************/
	var fields=[{     
		            name : 'DTYPRowId',
					mapping :'DTYPRowId',
					type : 'int'
				}, {
					name : 'DTYPCode', 
					mapping : 'DTYPCode',
					type : 'string'
				}, {
					name : 'DTYPDesc',
					mapping :'DTYPDesc',
					type:'string'
				},{
					name:'DTYPNoSendToCoding',
					inputValue : true?'Y':'N',
					mapping:'DTYPNoSendToCoding'
				}, {
					name : 'DTYPClinicType',
					mapping :'DTYPClinicType',
					type:'string'
				}, {
					name : 'DTYPDateFrom',
					mapping :'DTYPDateFrom',
					type : 'date'
				}, {
					name : 'DTYPDateTo',
					mapping :'DTYPDateTo',
					type : 'date'
				} ] 


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
	/************************************数据加载************************************/
	ds.load({
				params : {
					start : 0,
					limit : limit
				},
				callback : function(records, options, success) {
				}
			}); // 加载数据
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
        });
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});
 /************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
	});
/************************************搜索工具条************************************/
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
/************************************刷新工作条************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
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
	
/************************************将工具条放到一起************************************/
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
				},'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->']
			});
	 /************************************创建表格************************************/
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header :'DTYPRowId',
							width : 60,
							sortable : true,
						    hidden:true,
							dataIndex : 'DTYPRowId'
					  }, {
							header : '代码',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'DTYPCode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'DTYPDesc'
						},{
							header:'DTYPNoSendToCoding',
							width:80,
							sortable:true,
							dataIndex:'DTYPNoSendToCoding',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header:'就诊类型',
							width:120,
							sortable:true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'DTYPClinicType'
						},{
							header:'开始日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex:'DTYPDateFrom'
						},{
							header:'结束日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex:'DTYPDateTo'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				singleSelect: true ,
				monitorResize : true,
				trackMouseOver : true,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM ,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stripeRows : true,
				columnLines : true, //在列分隔处显示分隔符
				title : '诊断类型',
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
				forceFit : true,
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true 
				},
				bbar : paging,
				tbar :tb ,
				stateId : 'grid',
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
	});
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
 	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  var _record=grid.getSelectionModel().getSelected();
	          var selectrow=_record.get('DTYPRowId');
		 }
		else
		{
		  var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
  });
/************************************双击事件************************************/
	  	var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('DTYPRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	                	Ext.getCmp("form-save").getForm().findField('DTYPNoSendToCoding').setValue((_record.get('DTYPNoSendToCoding'))=='Y'?true:false);
	        	      	Ext.getCmp('DTYPClinicTypeO').setValue((action.result.data.DTYPClinicTypeO)=='O'?true:false);
		            	Ext.getCmp('DTYPClinicTypeE').setValue((action.result.data.DTYPClinicTypeE)=='E'?true:false);
		            	Ext.getCmp('DTYPClinicTypeI').setValue((action.result.data.DTYPClinicTypeI)=='I'?true:false);
		            	Ext.getCmp('DTYPClinicTypeH').setValue((action.result.data.DTYPClinicTypeH)=='H'?true:false);
		            	Ext.getCmp('DTYPClinicTypeN').setValue((action.result.data.DTYPClinicTypeN)=='N'?true:false);
	        	      },
	                failure : function(form,action) {
	                }
	            });
                //激活基本信息面板
                tabs.setActiveTab(0);
                //加载别名面板
                AliasGrid.DataRefer = _record.get('DTYPRowId');
                AliasGrid.loadGrid();

	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
	        	loadFormData(grid);
	    });	
	 
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/************************************键盘事件，按键弹出添加窗口***********************************/
   	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
			layout : 'border',
			items : [grid]
		});
	});
