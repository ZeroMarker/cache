/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 医疗单元
 */

var MedUnitCareProvJS = '../scripts/bdp/App/Care/DHC_CTLoc_MedUnitCareProv.js';//指定科室部分
document.write('<scr' + 'ipt type="text/javascript" src="'+MedUnitCareProvJS+'"></scr' + 'ipt>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/framework/ext.icare.Lookup.js"></script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassQuery=QueryMedUnit1";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCCTLocMedUnit";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassMethod=OpenData";
 	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	/*************************************排序*********************************/
 	Ext.BDP.FunLib.TableName="DHC_CTLoc_MedUnit";
    /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名  
    Ext.BDP.FunLib.SortTableName = "User.DHCCTLocMedUnit";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//-----------------翻译开始--------//	
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
    //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
       TableN : "DHC_CTLoc_MedUnit"
   });
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
       RowID=rows[0].get('MURowId');
       Desc=rows[0].get('CTMUDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
   /*
    Ext.BDP.FunLib.TableName="DHC_CTLoc_MedUnit"
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
	  */
	  
	//多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数
	hospComp.on('select',function (){
		 grid.enable();
		 Ext.getCmp('TextCTLocDr').reset();
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : limit
					}
				});
		
	});
	  
 /*************************** 删除功能*************************************************/
	var btnDel = new Ext.Toolbar.Button({
		text : $g('删除'),
		tooltip : $g('删除'),
		iconCls : 'icon-delete',
		id:'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					 	Ext.Msg.show({
										title:$g('提示'),
										minWidth:280,
										msg:$g('请选择需要删除的行!'),
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 } 
				 else{
					Ext.MessageBox.confirm('<font color=blue>'+$g('提示')+'</font>','<font color=red>'+$g('确定要删除所选的数据吗?')+'</font>', function(btn) {
					if (btn == 'yes') {
                         //删除所有别名
                        AliasGrid.DataRefer=records[0].get('MURowId') ;
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('MURowId') 
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '<font color=blue>'+$g('提示')+'</font>',
											msg : '<font color=red>'+$g('删除成功!')+'</font>',
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
											errorMsg = '<br />'+$g('错误信息')+':' + jsonData.info
										}
										Ext.Msg.show({
														title : '<font color=blue>'+$g('提示')+'</font>',
														msg : '<font color=red>'+$g('数据删除失败!')+'</font>' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														animEl: 'form-save',
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>'+$g('提示')+'</font>',
													msg : '<font color=red>'+$g('异步通讯失败,请检查网络连接!')+'</font>',
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
                        [{name: 'MURowId',mapping:'MURowId',type:'string'},
                         {name: 'CTMUCode',mapping:'CTMUCode',type:'string'},
                         {name: 'CTMUDesc',mapping:'CTMUDesc',type:'string'},
                         {name:'CTCode',mapping:'CTCode',type:'string'},
                         {name:'CTLocDr',mapping:'CTLocDr',type:'string'},
                         {name: 'CTMUActiveFlag',mapping:'CTMUActiveFlag',type:'string'},
                         {name: 'CTMUDateFrom',mapping:'CTMUDateFrom',type:'string'},
                         {name: 'CTMUDateTo',mapping:'CTMUDateTo',type:'string'}                 
                ]);
    var RowidText=new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : 'MURowId',
          hideLabel : 'True',
          hidden : true,
          name:'MURowId'
    });
    var CodeText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : '<font color=red>*</font>'+$g('代码'),
	       allowBlank:false,
	       regexText:$g("代码不能为空"),
	       name :'CTMUCode',
	       id:'CTMUCodeF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTMUCodeF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTMUCodeF')),
	       enableKeyEvents : true,
	       validationEvent : 'blur',  
           validator : function(thisText){
              if(thisText==""){  
                 return true;
               }
              var className =  "web.DHCBL.CT.DHCCTLocMedUnit";   
              var classMethod = "FormValidate"; 
              if (win.title==$g('添加')){
              	var Paref=Ext.getCmp('CTLocDrF').getValue();
              	var id="";
              }
              if(win.title==$g('修改')){  
                 var _record = grid.getSelectionModel().getSelected();
                 var id = _record.get('MURowId');  
                 var Paref=""
               }
             var flag = "";
             var flag = tkMakeServerCall(className,classMethod,Paref,id,thisText,""); 
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
    var DescText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : '<font color=red>*</font>'+$g('描述'),
       allowBlank:false,
       regexText:$g("描述不能为空"),
       name : 'CTMUDesc',
       id:'CTMUDescF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTMUDescF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTMUDescF')),
       enableKeyEvents : true,
       validationEvent : 'blur',
       validator : function(thisText){
       if(thisText==""){  
            return true;
        }
       var className =  "web.DHCBL.CT.DHCCTLocMedUnit"; 
       var classMethod = "FormValidate"; 
       var Paref=Ext.getCmp('CTLocDrF').getValue();
       var id="";
       if(win.title==$g('修改')){ 
        var _record = grid.getSelectionModel().getSelected();
        var id = _record.get('MURowId');  
       }
        var flag = "";
        var flag = tkMakeServerCall(className,classMethod,Paref,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
        if(flag == "1"){   
          return false;
        }else{
          return true;
         }
       },
         invalidText : $g('该描述已经存在'),
         listeners : {
                'change' : Ext.BDP.FunLib.Component.ReturnValidResult
            }
      });
     
    /// DateFrom
    var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>'+$g('开始日期'),
       name :'CTMUDateFrom',
       id:'CTMUDateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTMUDateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTMUDateFromF')),
       format : BDPDateFormat,
       allowBlank:false,
       regexText:$g("开始日期不能为空"),
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
       fieldLabel : $g('结束日期'),
       name : 'CTMUDateTo',
       id:'CTMUDateToF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTMUDateToF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTMUDateToF')),
       format :BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
         Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        
        }}
    });
    
  
	/****************************增加修改的Form*********************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				split : true,
				frame : true,
                title:$g('基本信息'),
				defaults : {
				anchor: '85%',
				border : false  
				},
				reader:jsonReaderE,
				items : [RowidText,{
							xtype : 'bdpcombo',
							fieldLabel : '<font color=red>*</font>'+$g('科室'),
							loadByIdParam:'rowid',
							hiddenName:'CTLocDr',
							dataIndex:'CTLocDr',
							id:'CTLocDrF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLocDrF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLocDrF')),
							store : new Ext.data.Store({
								proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							listWidth:250,
							pageSize:Ext.BDP.FunLib.PageSize.Combo,  
							forceSelection : true,
							selectOnFocus : false, 
							allowBlank:false,
							minChars : 0,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
											desc:e.query,
											hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
								
									}
							}
						},CodeText,DescText,DateFromText,DateToText,{
							xtype:'checkbox',
							fieldLabel : $g('是否激活'),
							id : 'CTMUActiveFlagF',
							name : 'CTMUActiveFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTMUActiveFlagF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTMUActiveFlagF')),
							inputValue : true ? 'Y' : 'N',
							checked : true
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

	/************************** 增加修改时弹出窗口*********************************************/
	var win = new Ext.Window({
		width : 430,
		height : 360,
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
		labelWidth : 55,
		items : tabs,
		buttons : [{
			text : $g('保存'),
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempctloc=Ext.getCmp('CTLocDrF').getValue();
			var tempCode = Ext.getCmp("form-save").getForm().findField("CTMUCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("CTMUDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("CTMUDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("CTMUDateTo").getValue();
			if (tempctloc==""){
							Ext.Msg.show({
								title : '<font color=blue>'+$g('提示')+'</font>', 
								msg : '<font color=red>'+$g('科室不能为空!')+'</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTLocDrF").focus(true,true);
								}
							 });
      			return;
			}
			if (tempCode=="") {
				Ext.Msg.show({
								title : '<font color=blue>'+$g('提示')+'</font>', 
								msg : '<font color=red>'+$g('代码不能为空!')+'</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTMUCode").focus(true,true);
								}
							 });
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>'+$g('提示')+'</font>',
								msg : '<font color=red>'+$g('描述不能为空!')+'</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTMUDesc").focus(true,true);
								}
						   });
      			return;
			}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>'+$g('提示')+'</font>',
								msg : '<font color=red>'+$g('开始日期不能为空!')+'</font>',
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTMUDateFrom").focus(true,true);
								}
							});
      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
			    					title : '<font color=blue>'+$g('提示')+'</font>',
									msg : '<font color=red>'+$g('开始日期不能大于结束日期!')+'</font>',
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
	      			 		return;
	  				}
				 }
			if(WinForm.getForm().isValid()==false){
                 Ext.Msg.alert('提示','<font color = "red">'+$g('数据验证失败')+'，<br />'+$g('请检查您的数据格式是否有误')+'！');
                 return;
            } 
		   if (win.title == $g("添加")) {
					WinForm.form.submit({
						clientValidation : true,  
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
						 if (action.result.success == 'true') {
							   var myrowid = action.result.id;
                                win.hide();
								Ext.Msg.show({
												title : '<font color=blue>'+$g('提示')+'</font>',
												msg : '<font color=green>'+$g('添加成功!')+'</font>',
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
															errorMsg = '<br/>'+$g('错误信息')+':' + action.result.errorinfo
														}
														Ext.Msg.show({
																		title : '<font color=blue>'+$g('提示')+'</font>',
																		msg : '<font color=red>'+$g('添加失败!')+'</font>' ,
																		minWidth : 200,
																		animEl: 'form-save',
																		icon : Ext.Msg.ERROR,
																		buttons : Ext.Msg.OK
																	});
								             	}
						  	},
						  failure : function(form, action) {
							Ext.Msg.show({
											title : '<font color=blue>'+$g('提示')+'</font>',
											msg : '<font color=red>'+$g('添加失败!')+'</font>' ,
											minWidth : 200,
											animEl: 'form-save',
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
								}
					 	})
				   } else {
                        var gsm = grid.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            var rowid=rows[0].get('MURowId');
                            var activeflag=Ext.getCmp('CTMUActiveFlagF').getValue();
                            var ctlocid= rows[0].get('CTLocDr');
                            if (ctlocid!=tempctloc){
                                    Ext.Msg.show({
                                            title : '<font color=blue>'+$g('提示')+'</font>',
                                            msg : '<font color=red>'+$g('科室不能修改!')+'</font>' ,
                                            minWidth : 200,
                                            animEl: 'form-save',
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                                    return false;
                            }
					   Ext.MessageBox.confirm('<font color=blue>'+$g('提示')+'</font>', '<font color=red>'+$g('确定要修改该条数据吗?')+'</font>', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true,  
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								params:{
									'rowid':rowid,
									'activeflag':activeflag
								},
								success : function(form, action) {
                                    AliasGrid.saveAlias(); 
									if (action.result.success == 'true') {
									    var myrowid = 'rowid='+action.result.id;
						                win.hide();
					                    Ext.Msg.show({
					                                  title : '<font color=blue>'+$g('提示')+'</font>',
					                                  msg : '<font color=green> '+$g('修改成功!')+'</font>',
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
											errorMsg = '<br/>'+$g('错误信息')+':' + action.result.errorinfo
										}
										Ext.Msg.show({
														title : '<font color=blue>'+$g('提示')+'</font>',
														msg : '<font color=red>'+$g('修改失败!')+'</font>' ,
														minWidth : 200,
														animEl: 'form-save',
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
												}
										},
								failure : function(form, action) {
									Ext.Msg.show({
													title : '<font color=blue>'+$g('提示')+'</font>',
													msg : '<font color=red>'+$g('修改失败!')+'</font>' ,
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
			text : $g('关闭'),
            iconCls : 'icon-close',
			handler : function() {
			  win.hide();   
              ClearForm();
			}
		}],
		listeners : {
			"show" : function() {
			     Ext.getCmp("form-save").getForm().findField("CTMUCode").focus(true,300);
                 if (win.title == $g("添加")) {
                     Ext.getCmp('CTLocDrF').setReadOnly(false);
                 }else{
                  Ext.getCmp('CTLocDrF').setReadOnly(true);
                 
                 }
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	/********************************增加按钮**********************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : $g('添加'),
				tooltip : $g('添加'),
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle($g('添加'));
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
	/********************************修改按钮**********************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : $g('修改'),
				tooltip : $g('修改'),
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
						Ext.Msg.show({
										title:$g('提示'),
										minWidth:280,
										msg:$g('请选择需要修改的行!'),
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 } 
				 else{
				   		win.setTitle($g('修改'));
						win.setIconClass('icon-update');
						win.show('');
						loadFormData(grid);
					 }
      		 }
    });
	 
  	var winDesignatedDepartment = new Ext.Window(getResourcePanel()); 
/************************************医疗单元医护人员定义**************************/
	var CareProvBtn=new Ext.Toolbar.Button({
		text:$g('关联医护人员') ,
		tooltip : $g('关联医护人员'),
		iconCls : 'icon-DP',
		id:'medunitcareprov',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('medunitcareprov'),
		handler:seach=function(){
				var gsm = grid.getSelectionModel(); 
				var rows = gsm.getSelections(); 
				if(rows.length>0){
					var MUCPParRef=rows[0].get('MURowId');
					var LocDesc=rows[0].get('CTMUDesc');
					winDesignatedDepartment.setTitle($g('关联医护人员')+'->'+LocDesc);
				    winDesignatedDepartment.setIconClass('icon-DP');
				    winDesignatedDepartment.show('');
				   
				    CareProvDs.baseParams={MURowid:rows[0].get('MURowId')}
					CareProvDs.load({
							params : {
									start : 0,
									limit : limit
							} 
					}); 
	                wingrid.getStore().baseParams={ParRef:rows[0].get('MURowId')}
	                wingrid.getStore().load({params:{start:0, limit:limit}});
	                Ext.getCmp("child_TextCode").reset();
					Ext.getCmp("child_TextDesc").reset();
					Ext.getCmp('checkhistory').reset();
	                Ext.getCmp('HideRef').reset();
				 	Ext.getCmp('HideRef').setValue(rows[0].get('MURowId'));
					}
				else{
						Ext.Msg.alert($g("提示"),$g("未选中行"))
					}
				}
			});
	/***************************数据保存格式为json格式**********************************/
 	var fields= [{
					name : 'MURowId',
					mapping : 'MURowId',
					type : 'string'
				},{
					name : 'CTMUCode',  
					mapping : 'CTMUCode',
					type : 'string'
				}, {
					name : 'CTMUDesc',
					mapping :'CTMUDesc',
					type:'string'
				},{
					name:'CTLOCCode',
					mapping:'CTLOCCode',
					type:'string'
				},{
					name:'CTLOCDesc',
					mapping:'CTLOCDesc',
					type:'string'
				},{
					name:'CTLocDr',
					mapping:'CTLocDr',
					type:'string'
				},{
					name:'CTMUActiveFlag',
					mapping:'CTMUActiveFlag',
					type:'string'
				},{
					name:'CTMUDateFrom',
					mapping:'CTMUDateFrom',
					type : 'date',
					dateFormat : 'm/d/Y'
				}, {
					name :'CTMUDateTo',
					mapping :'CTMUDateTo',
					type : 'date',
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
 	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName)
    Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);

	/************************************数据分页************************************/
	var paging = new Ext.PagingToolbar({
            pageSize: limit,
            store: ds,
            displayInfo: true,
            displayMsg : $g('显示第')+' {0} '+$g('条到')+' {1} '+$g('条记录,一共')+' {2} '+$g('条'),
            emptyMsg : $g("没有记录"),
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
					          "change":function (t,p)
					        { 
					           limit=this.pageSize;
					        }
                        }
        });
	/***************************增删改工具条*********************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin,'-',CareProvBtn,'-',btnTrans,'->',btnlog,'-',btnhislog] 
        // '-', btnDel ,'-',btnSort ]  
		})
	/*************************** 搜索工具条**********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : $g('搜索'),
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue() ,
						desc : Ext.getCmp("TextDesc").getValue(),
						CTLocDr:Ext.getCmp('TextCTLocDr').getValue(),
						hospid:hospComp.getValue() 
				};
				grid.getStore().load({
					params : {
								start : 0,
								limit : limit
							}
						});
					}
			});
	/******************************* 刷新工作条************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : $g('重置'),
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
				 	Ext.getCmp('TextCTLocDr').reset();
					grid.getStore().baseParams={
						hospid:hospComp.getValue()
					};
					grid.getStore().load({
								params : {
											start : 0,
											limit : limit
										}
								});
						}
				});
	/**********************************将工具条放到一起*****************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [$g('科室'),{
							xtype : 'bdpcombo',
							fieldLabel : $g('科室'),
							loadByIdParam:'rowid',
							hiddenName:'CTLocDr',
							dataIndex:'CTLocDr',
							id:'TextCTLocDr',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextCTLocDr'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextCTLocDr')),
							store : new Ext.data.Store({
								proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							listWidth:250,
							pageSize:Ext.BDP.FunLib.PageSize.Combo,  
							forceSelection : true,
							selectOnFocus : false, 
							minChars : 0,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
								'beforequery': function(e){
									this.store.baseParams = {
										desc:e.query,
										hospid:hospComp.getValue()
									};
									this.store.load({params : {
												start : 0,
												limit : Ext.BDP.FunLib.PageSize.Combo
									}})
							
								},
								 'select':function(){
								 	 var TextLocDr=Ext.getCmp('TextCTLocDr').getValue();
								 	 grid.getStore().baseParams={			
											CTLocDr:TextLocDr 
									};
									grid.getStore().load({
										params : {
													start : 0,
													limit : limit
												}
											});
								 }
							}
					
				},$g('代码'), {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},$g('描述/别名'), {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						  },'-',LookUpConfigureBtn ,'-', btnSearch, '-', btnRefresh,'->'],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
/************************************create the Grid *************************************/
	var sm=	new Ext.grid.RowSelectionModel({singleSelect:true})
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'MURowId',
							width : 20,
							sortable : true,
							dataIndex : 'MURowId',
							hidden : true
						}, {
							header:$g('科室代码'),
							width:120,
							sortable:true,
							dataIndex:'CTLOCCode',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header:$g('科室描述'),
							width:120,
							sortable:true,
							dataIndex:'CTLOCDesc',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						},{
							header : $g('代码'),
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'CTMUCode'
						}, {
							header : $g('描述'),
							width : 130,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'CTMUDesc'
						
						},{
							header:$g('是否激活'),
							width:80,
							sortable:true,
							dataIndex:'CTMUActiveFlag',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header : $g('开始日期'),
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'CTMUDateFrom'
						}, {
							header : $g('结束日期'),
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTMUDateTo'
						},{
                            dataIndex:'CTLocDr',
                            header:'CTLocDr',
                            width:90,
                            hidden:true
                        } ];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				stripeRows:true,
				autoFill:true,
				trackMouseOver : true,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM,
				sm:sm, 
				stripeRows : true,
				columnLines : true,  
				title : $g('医疗单元'),
				stateful : true,
				viewConfig : {
					forceFit : true,
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>"+$g("对不起,没有检索到相关数据.")+"</span>'",
    				enableRowBody: true  
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
 
/************************************双击事件*****************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  
	        if (!_record) {
	            Ext.Msg.alert($g('修改操作'), $g('请选择要修改的一项!'));
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('MURowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
                     
	        	      },
	                 failure : function(form,action) {
	                 Ext.Msg.alet($g("提示"),$g("加载数据失败！"))
	                }
	            });
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('MURowId');
               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle($g('修改'));      ///双击后
				win.setIconClass('icon-update');
				win.show('');
				loadFormData(grid)
	    });	
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	
	//单击事件（翻译按钮要用到）
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
		        var _record = grid.getSelectionModel().getSelected();
		        var selectrow = _record.get('MURowId');	           
			 } else {
			 	var selectrow="";
			 }
			 Ext.BDP.FunLib.SelectRowId = selectrow
		});	
	
	/************************************键盘事件*********************************************/
   	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData);
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
					limit : limit
				},
				callback : function(records, options, success) {
				}
			});
	}	
	
  });
