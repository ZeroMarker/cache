/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于服务组维护。
 * @Created on 2012-8-4
 * @Updated on 2013-5-11
 * @LastUpdated on 2013-6-24 by sunfengchao
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.RBCServiceGroup";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassMethod=OpenData";
    
 	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.RBCServiceGroup";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "RBC_ServiceGroup"
   });
     Ext.BDP.FunLib.TableName="RBC_ServiceGroup";
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
       RowID=rows[0].get('SGRowId');
       Desc=rows[0].get('SGDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

   //多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		 grid.enable();		 
		grid.getStore().baseParams={			
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			active1:Ext.getCmp("SGPreadmissionCheck").getValue(),
			active2:Ext.getCmp("SGBypassDateCheck").getValue(),
			active3:Ext.getCmp("SGAllowBookAfterDischarge").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize_main
					}
				});
		
	});
	//多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
				var rowid=grid.getSelectionModel().getSelections()[0].get("SGRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
 /*************************删除功能********************************************/
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
                        //删除所有别名
                        AliasGrid.DataRefer=records[0].get('SGRowId');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('SGRowId') 
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
													 Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
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
      name : 'SGRowId',
      mapping : 'SGRowId',
      type : 'int'
    }, {
      name : 'SGCode',
      mapping : 'SGCode',
      type : 'string'
    }, {
      name : 'SGDesc',
      mapping :'SGDesc',
      type:'string'
    },{
      name:'SGPreadmissionCheck',
      mapping:'SGPreadmissionCheck',
      inputValue : true?'Y':'N',
      type:'string'
    },{
      name:'SGBypassDateCheck',
      mapping:'SGBypassDateCheck',
      inputValue : true?'Y':'N',
      type:'string'
    },{
         name:'SGAllowBookAfterDischarge',
      mapping:'SGAllowBookAfterDischarge',
      inputValue : true?'Y':'N',
      type:'string'
    },{
      name:'SGDateFrom',
      mapping:'SGDateFrom',
      type : 'string'
    }, {
      name :'SGDateTo',
      mapping :'SGDateTo',
      type : 'string'
    }// 列的映射  
  ]);
  
   // RowId
     var RowIdText=new Ext.BDP.FunLib.Component.TextField({
	       fieldLabel : 'SGRowId',
	       hideLabel : 'True',
	       hidden : true,
	       name : 'SGRowId'
     });
    /// code
    var codeText=new Ext.BDP.FunLib.Component.TextField({
	       fieldLabel : '<font color=red>*</font>代码',
	       allowBlank:false,
	       regexText:"代码不能为空",
	       name : 'SGCode',
	       id:'SGCodeF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGCodeF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGCodeF')),
	       enableKeyEvents : true,
	       validationEvent : 'blur',  
           validator : function(thisText){
              if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                 return true;
               }
			   else if(thisText.length>5) {
				Ext.Msg.alert("提示","代码长度不能超过5位");
				 return  false;
			  }
              var className =  "web.DHCBL.CT.RBCServiceGroup";   
              var classMethod = "FormValidate"; //数据重复验证后台函数名                             
              var id="";
              if(win.title=='修改'){  
              var _record = grid.getSelectionModel().getSelected();
              var id = _record.get('SGRowId');  
            }
              var flag = "";
              var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
              if(flag == "1"){   
                 return false;
               }else{
                 return true;
                }
              },
         invalidText : '该代码已经存在或者超长',
         listeners : {
             'change' : Ext.BDP.FunLib.Component.ReturnValidResult
          }
    });
    /// desc
    var descText=new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : '<font color=red>*</font>描述',
	      allowBlank:false,
	      regexText:"描述不能为空",
	      name : 'SGDesc',
	      id:'SGDescF',
	      readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGDescF'),
	      style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGDescF')),
	      enableKeyEvents : true,
          validationEvent : 'blur',
          validator : function(thisText){
            if(thisText==""){  
                return true;
             }
            var className =  "web.DHCBL.CT.RBCServiceGroup"; //后台类名称
            var classMethod = "FormValidate"; //数据重复验证后台函数名
            var id="";
            if(win.title=='修改'){ 
            var _record = grid.getSelectionModel().getSelected();
            var id = _record.get('SGRowId');  
          }
           var flag = "";
           var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
   /// SGPreadmissionCheck
    var SGPreadmissionCheckText=new Ext.BDP.FunLib.Component.Checkbox({
           fieldLabel:'SGPreadmissionCheck',
	       name:'SGPreadmissionCheck',
	       id:'SGPreadmissionCheckF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGPreadmissionCheckF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGPreadmissionCheckF')),
	       autoHeight:'true',
	       hideLabels:true,
	       inputValue : true?'Y':'N'
    });
   /// SGBypassDateCheck
    var SGBypassDateCheckText=new Ext.BDP.FunLib.Component.Checkbox({
           fieldLabel:'SGBypassDateCheck',
	       name:'SGBypassDateCheck',
	       id:'SGBypassDateCheckF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGBypassDateCheckF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGBypassDateCheckF')),
	       autoHeight:'true',
	       hideLabels:true,
	       inputValue : true?'Y':'N'
    });
    ///SGAllowBookAfterDischarge
    var SGAllowBookAfterDischarge=new Ext.BDP.FunLib.Component.Checkbox({
	       fieldLabel:'SGAllowBookAfterDischarge',
	       name:'SGAllowBookAfterDischarge',
	       id:'SGAllowBookAfterDischargeF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGAllowBookAfterDischargeF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGAllowBookAfterDischargeF')),
	       hideLabels:true,
	       autoHeight:'true',
	       inputValue : true?'Y':'N'
    });
    /// DateFrom 
    var DateFromText=new Ext.BDP.FunLib.Component.DateField({
	       fieldLabel : '<font color=red>*</font>开始日期',
	       name :'SGDateFrom',
	       id:'SGDateFromF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGDateFromF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGDateFromF')),
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
	      name : 'SGDateTo',
	      id:'SGDateToF',
	      readOnly : Ext.BDP.FunLib.Component.DisableFlag('SGDateToF'),
	      style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SGDateToF')),
	      format : BDPDateFormat,
	      enableKeyEvents : true,
	      listeners : {   
	       'keyup' : function(field, e)
	       { 
	        Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
            }
        }
    });
    /****************************增加修改的Form**********************************************/
	var WinForm = new Ext.form.FormPanel({
	        id:'form-save',
		 	iconCls: 'icon-tabs',
			labelWidth: 200,
			labelAlign : 'right',
			split : true,
			frame : true,
	        title:'基本信息',
            defaults : {
                anchor: '85%',
                border : false  
             },
			reader: jsonReaderE ,
			items: [ RowIdText, codeText, descText, DateFromText, DateToText,SGPreadmissionCheckText,SGBypassDateCheckText,SGAllowBookAfterDischarge]
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
	/******************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		width : 480,
		height : 350,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 100,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),	
			handler : function() {
		 	var tempCode = Ext.getCmp("form-save").getForm().findField("SGCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("SGDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("SGDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("SGDateTo").getValue();
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
									Ext.getCmp("form-save").getForm().findField("SGCode").focus(true,true);
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
								buttons : Ext.Msg.OK,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("SGDesc").focus(true,true);
								}
							});
      			return;
			}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>',
								msg : '<font color=red>开始日期不能为空!</font>',
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("SGDateFrom").focus(true,true);
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
						clientValidation : true, // 进行客户端验证
						//waitMsg : '正在提交数据请稍后',
						waitTitle : '<font color=blue>提示</font>',
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						params : {									 
							'LinkHospId' :hospComp.getValue()         
						},
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
								                   limit : pagesize_main,
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
								//waitMsg : '正在提交数据请稍后...',
								waitTitle : '<font color=blue>提示</font>',
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
			Ext.getCmp("form-save").getForm().findField("SGCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	/************************************增加按钮****************************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function(){
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
	/**************************************修改按钮*************************************/
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
	 
     
	/*******************************数据保存格式为json格式**************************************/
    var fields= [{
					name : 'SGRowId',
					mapping : 'SGRowId',
					type : 'int'
				}, {
					name : 'SGCode',   
					mapping : 'SGCode',
					type : 'string'
				}, {
					name : 'SGDesc',
					mapping :'SGDesc',
					type:'string'
				},{
					name:'SGPreadmissionCheck',
					mapping:'SGPreadmissionCheck',
					inputValue : true?'Y':'N',
					type:'string'
				},{
					name:'SGBypassDateCheck',
					mapping:'SGBypassDateCheck',
					inputValue : true?'Y':'N',
					type:'string'
				},{
					name:'SGAllowBookAfterDischarge',
					mapping:'SGAllowBookAfterDischarge',
					inputValue : true?'Y':'N',
					type:'string'
				},{
					name:'SGDateFrom',
					mapping:'SGDateFrom',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
				}, {
					name :'SGDateTo',
					mapping :'SGDateTo',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
				} ]; 
	var ds = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ACTION_URL
					}),// 调用的动作
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					},fields) 
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/***************************加载数据****************************************************/	
	 
	var paging = new Ext.PagingToolbar({
            pageSize: pagesize_main,
            store: ds,
            displayInfo: true,
            displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
            emptyMsg : "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
             listeners : {
						        "change":function (t,p)
						       { 
						           pagesize_main=this.pageSize;
						       }
				          }
        });
	 
	/***************************** 增删改工具条*****************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel ,'-',HospWinButton   //多院区医院
		,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]   
		})
	/*********************** 搜索工具条***********************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue(),
						active1:Ext.getCmp("SGPreadmissionCheck").getValue(),
						active2:Ext.getCmp("SGBypassDateCheck").getValue(),
						active3:Ext.getCmp("SGAllowBookAfterDischarge").getValue(),
						hospid:hospComp.getValue()
				};
				grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								 }
							});
						}
					});
	/******************************刷新工作条****************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
				    Ext.getCmp("SGPreadmissionCheck").reset();
				    Ext.getCmp("SGBypassDateCheck").reset();
				    Ext.getCmp("SGAllowBookAfterDischarge").reset();
					grid.getStore().baseParams={hospid:hospComp.getValue()};
					grid.getStore().load({
					params : {
								start : 0,
								limit : pagesize_main
							}
						});
					}
			});
	/*************************将工具条放到一起****************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							width:100
				},	'描述/别名', {
				        	width:100,
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
			  },'PreadmissionCheck',{
			  	fieldLabel : '<font color=red></font>PreadmissionCheck',
							xtype : 'combo',
							id : 'SGPreadmissionCheck',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('SGPreadmissionCheck'),
							width : 75,
							mode : 'local',
							triggerAction : 'all',
							minChars : 1,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{value : 'Y',name : 'Yes'}, 
											{value : 'N',name : 'No'}			
										   ]
							}),
							listeners:{
        					 'select': function()
        					 {
        					 		grid.getStore().baseParams={			
										code : Ext.getCmp("TextCode").getValue(),
										desc : Ext.getCmp("TextDesc").getValue(),
										active1:Ext.getCmp("SGPreadmissionCheck").getValue(),
										active2:Ext.getCmp("SGBypassDateCheck").getValue(),
										active3:Ext.getCmp("SGAllowBookAfterDischarge").getValue(),
										hospid:hospComp.getValue()
									};
									grid.getStore().load({
															params : {
																		start : 0,
																		limit : pagesize_main
																	  }
															});
													}
						        			 }
   			 }	,'BypassDateCheck',{
   			 fieldLabel : '<font color=red></font>BypassDateCheck',
							xtype : 'combo',
							id : 'SGBypassDateCheck',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('SGBypassDateCheck'),
							width : 75,
							mode : 'local',
							triggerAction : 'all',
							minChars : 1,
							listWidth : 60,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{value : 'Y',name : 'Yes'}, 
												{value : 'N',name : 'No'}			
										    ]
							}),
							listeners:{
        					 'select': function()
        					 {
        					 		grid.getStore().baseParams={			
										code : Ext.getCmp("TextCode").getValue(),
										desc : Ext.getCmp("TextDesc").getValue(),
										active1:Ext.getCmp("SGPreadmissionCheck").getValue(),
										active2:Ext.getCmp("SGBypassDateCheck").getValue(),
										active3:Ext.getCmp("SGAllowBookAfterDischarge").getValue(),
										hospid:hospComp.getValue()
									};
									grid.getStore().load({
									params : {
												start : 0,
												limit : pagesize_main
							  				}
									});
							}
        			 }
   			 },'AllowBookAfterDischarge',{
   			 fieldLabel : '<font color=red></font>AllowBookAfterDischarge',
							xtype : 'combo',
							id : 'SGAllowBookAfterDischarge',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('SGAllowBookAfterDischarge'),
							width : 75,
							mode : 'local',
							triggerAction : 'all',
							minChars : 1,
							listWidth : 60,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{value : 'Y',name : 'Yes'}, 
												{value : 'N',name : 'No'}			
										    ]
							}),
							listeners:{
        					 'select': function()
        					 {
        					 		grid.getStore().baseParams={			
										code : Ext.getCmp("TextCode").getValue(),
										desc : Ext.getCmp("TextDesc").getValue(),
										active1:Ext.getCmp("SGPreadmissionCheck").getValue(),
										active2:Ext.getCmp("SGBypassDateCheck").getValue(),
										active3:Ext.getCmp("SGAllowBookAfterDischarge").getValue(),
										hospid:hospComp.getValue()
									};
									grid.getStore().load({
									params : {
												start : 0,
												limit : pagesize_main
							  				}
										});
        					 		}
							}
        		 },'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'],
					listeners : {
					render : function() {
						tbbutton.render(grid.tbar)  
					}
				}
			});
	/***************************** create the Grid *************************************/
	var sm=	new Ext.grid.RowSelectionModel({singleSelect:true})
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'SGRowId',
							width : 160,
							sortable : true,
							dataIndex : 'SGRowId',
							hidden : true
						}, {
							header : '代码',
							width : 160,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'SGCode'
						}, {
							header : '描述',
							width : 160,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'SGDesc'
						}, {
							header : 'PreadmissionCheck',
							width : 160,
							sortable : true,
							dataIndex : 'SGPreadmissionCheck', 
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						},{
							header : 'BypassDateCheck',
							width : 160,
							sortable : true,
							dataIndex : 'SGBypassDateCheck', 
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						},{
							header : 'AllowBookAfterDischarge',
							width : 160,
							sortable : true,
							dataIndex : 'SGAllowBookAfterDischarge', 
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						},{
							header : '开始日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'SGDateFrom'
						}, {
							header : '结束日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'SGDateTo'
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
				sm:sm ,
				columns:GridCM,
				stripeRows : true,
				columnLines : true, //在列分隔处显示分隔符
				title : '服务组',
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
/*****************************右键菜单**************************************************/
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
	            handler: AddData,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu2'),
	            text: '添加数据'
	        },{
	            id: 'rMenu3',
	            iconCls :'icon-update',
	            handler:UpdateData ,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu3'),
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
          var selectrow=_record.get('SGRowId');
	
	 }
	else
	{
	  var selectrow=""
	 }
	Ext.BDP.FunLib.SelectRowId=selectrow
  });
	/****************************************双击事件*********************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&sid='+ _record.get('SGRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	                		Ext.getCmp("form-save").getForm().findField('SGPreadmissionCheck').setValue((_record.get('SGPreadmissionCheck'))=='Y'?true:false);
	                		Ext.getCmp("form-save").getForm().findField('SGBypassDateCheck').setValue((_record.get('SGBypassDateCheck'))=='Y'?true:false);
	                		Ext.getCmp("form-save").getForm().findField('SGAllowBookAfterDischarge').setValue((_record.get('SGAllowBookAfterDischarge'))=='Y'?true:false);
                     },
	                failure : function(form,action) {
	                }
	            });
                //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('SGRowId');
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
	/**********************键盘事件，按键弹出添加窗口******************************************/
 	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
 
	var viewport = new Ext.Viewport({
			layout : 'border',
			items : [GenHospPanel(hospComp),grid]
	});
	///多院区医院
    var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		grid.disable();
	}
	else
	{
		/** grid加载数据 */
		ds.load({
					params : {
						start : 0,
						limit : pagesize_main
					},
					callback : function(records, options, success) {
						// alert(options);
						// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
					}
				});
	
	}
});
