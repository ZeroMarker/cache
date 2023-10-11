/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于挂号职称维护 
 * @Created on 2012-8-4
 * @Updated on 2013-5-11
 * @LastUpdated on 2013-6-24 by sunfengchao
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    var combopage=Ext.BDP.FunLib.PageSize.Combo 
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCSessionType&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBCSessionType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.RBCSessionType";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBCSessionType&pClassMethod=DeleteData";
	var QUERY_ACTION= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCSessionType&pClassQuery=GetDataForCmb1";
	var OPEN_ACTION_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBCSessionType&pClassMethod=OpenData";
 
   	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.RBCSessionType";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
  //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "RBC_SessionType"
  });
   Ext.BDP.FunLib.TableName="RBC_SessionType";
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
       RowID=rows[0].get('SESSRowId');
       Desc=rows[0].get('SESSDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

   //多院区医院下拉框
  var hospComp=GenHospComp(Ext.BDP.FunLib.TableName); 
  console.log(hospComp)
  //医院下拉框选择一条医院记录后执行此函数 
  hospComp.on('select',function (){
     grid.enable();
     grid.getStore().baseParams={     
        code : Ext.getCmp("TextCode").getValue() ,
        desc : Ext.getCmp("TextDesc").getValue() ,
        active : Ext.getCmp("TextCTCOUActive").getValue(),
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
        var rowid=grid.getSelectionModel().getSelections()[0].get("SESSRowId");
        GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
      }
      else
      {
        alert('请选择需要授权的记录!')
      }        
    });

 /************************************ 删除功能*********************************/
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
                        AliasGrid.DataRefer=records[0].get('SESSRowId');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('SESSRowId') 
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
                         [{name: 'SESSRowId',mapping:'SESSRowId',type:'int'},
                         {name: 'SESSCode',mapping:'SESSCode',type:'string'},
                         {name: 'SESSDesc',mapping:'SESSDesc',type:'string'},
                         {name: 'SESSSessionTypeDR',mapping:'SESSSessionTypeDR',type:'string'},
                         {name: 'SESSNumberOfDays',mapping:'SESSNumberOfDays',type:'string'},
                         {name: 'SESSEnableByDefault',mapping:'SESSEnableByDefault',type:'string'},
                         {name: 'SESSDateFrom',mapping:'SESSDateFrom',type:'string'},
						 {name: 'SESSCategory',mapping:'SESSCategory',type:'string'},
                         {name: 'SESSDateTo',mapping:'SESSDateTo',type:'string'}
                       ]);
     /// Rowid
     var RowIdText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : 'SESSRowId',
	       hideLabel : 'True',
	       hidden : true,
	       name : 'SESSRowId'
     });
     /// Code
     var codeText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : '<font color=red>*</font>代码',
	       allowBlank:false,
	       regexText:"代码不能为空",
	       name : 'SESSCode',
	       id:'SESSCodeF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSCodeF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSCodeF')),
	       enableKeyEvents : true,
	       validationEvent : 'blur',  
           validator : function(thisText){
              if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                return true;
              }
              var className =  "web.DHCBL.CT.RBCSessionType";   
              var classMethod = "FormValidate"; //数据重复验证后台函数名                             
              var id="";
              if(win.title=='修改'){  
              var _record = grid.getSelectionModel().getSelected();
              var id = _record.get('SESSRowId');  
            }
              var flag = "";
              var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
     var descText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : '<font color=red>*</font>描述',
	       allowBlank:false,
	       regexText:"描述不能为空",
	       name : 'SESSDesc',
	       id:'SESSDescF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSDescF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSDescF')),
	       enableKeyEvents : true,
	       validationEvent : 'blur',
           validator : function(thisText){
             if(thisText==""){  
                   return true;
              }
             var className =  "web.DHCBL.CT.RBCSessionType"; //后台类名称
             var classMethod = "FormValidate"; //数据重复验证后台函数名
             var id="";
             if(win.title=='修改'){ 
             var _record = grid.getSelectionModel().getSelected();
             var id = _record.get('SESSRowId');  
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
     /// DateFrom
     var DateFromText=new Ext.BDP.FunLib.Component.DateField({
        fieldLabel : '<font color=red>*</font>开始日期',
        name :'SESSDateFrom',
        id:'SESSDateFromF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSDateFromF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSDateFromF')),
        format : BDPDateFormat,
        allowBlank:false,
        regexText:"开始日期不能为空",
        invalidText :"输入的日期格式非法",
        editable:true,
        enableKeyEvents : true,
        listeners : {   
        'keyup' : function(field, e)
        { 
         Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        
        }}
     });
     /// DateTo DateFromText,DateToText
     var DateToText=new Ext.BDP.FunLib.Component.DateField({
        fieldLabel : '结束日期',
        name : 'SESSDateTo',
        id:'SESSDateToF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSDateToF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSDateToF')),
        format : BDPDateFormat,
        invalidText :"输入的日期格式非法",
        enableKeyEvents : true,
        listeners : {   
        'keyup' : function(field, e)
        { 
         Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
     });
    /// sessionTypeDR
    var SessionTypeDRText=new Ext.BDP.Component.form.ComboBox({
       		xtype:'bdpcombo',
       		loadByIdParam:'rowid',
        	fieldLabel : '转换',
      		id:'SessionTypeDRF',
       		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SessionTypeDRF'),
      		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SessionTypeDRF')),
       		hiddenname:'SESSSessionTypeDR',
       		dataindex:'SESSSessionTypeDR', 
        	store : new Ext.data.Store({
        	    //autoLoad: true,
        		 proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION }),
         		 reader : new Ext.data.JsonReader({
		         totalProperty : 'total',
		         root : 'data',
		         successProperty : 'success'
        	 }, [ 'SESSRowId', 'SESSDesc' ])
       }),
	     queryParam : 'query',
	     forceSelection : true,
	     selectOnFocus : false,
	   //  minChars : 0,
	     listWidth : 250,
	     valueField : 'SESSRowId',
	     displayField : 'SESSDesc',
	     hiddenName : 'SESSSessionTypeDR',
	     pageSize :combopage,
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
    });
    
    /// NumberOfDays
     var NumberOfDaysText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel:'天数',
        name:'SESSNumberOfDays',
        id:'SESSNumberOfDaysF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSNumberOfDaysF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSNumberOfDaysF')),
        xtype:'numberfield',
        regex : /^(([0-9]+)+)$/,
        regexText : "对不起,您只能输入0或者正整数!",
        blankText:'输入整数'
     });
     /// SESSEnableByDefault
     var SESSEnableByDefaultText=new Ext.BDP.FunLib.Component.Checkbox({
        fieldLabel:'默认允许',
        name:'SESSEnableByDefault',
        id:'SESSEnableByDefaultF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSEnableByDefaultF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSEnableByDefaultF')),
        xtype:'checkbox',
        autoHeight:'true',
        inputValue : true?'Y':'N'
     });
	 
	 /// 归类 （普通Normal、专家Specialist、主任Director、副主任DeputyDirector、急诊Emergency）
	 var SESSCategory=new  Ext.BDP.FunLib.Component.BaseComboBox({
			xtype:'combo',
			fieldLabel:'归类',
			id:'SESSCategoryF',
			name:'SESSCategory',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('SESSCategoryF'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SESSCategoryF')),
			store:new Ext.data.SimpleStore({
				fields:['SESSCategory','value'],
				data:[
						  ['N','普通'],
						  ['S','专家'],
						  ['D','主任'],
						  ['DP','副主任'], 
						  ['E','急诊']
					 ]
			}),
			displayField:'value',
			valueField:'SESSCategory',
			mode:'local',
			triggerAction:'all', 
			blankText:'请选择'  
		});
	/************************************ 增加修改的Form************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				width : 180,
				split : true,
				frame : true,
                title:'基本信息',
				reader:jsonReaderE ,
                    defaults : {
					anchor: '90%',         
					border : false   
				},
				items : [RowIdText, codeText, descText,SESSCategory,SessionTypeDRText,NumberOfDaysText,SESSEnableByDefaultText,DateFromText,DateToText ]
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
     height : 330,
     frame:true,
     items:[WinForm,AliasGrid]
 });
Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
/************************************增加修改时弹出窗口************************************/
	var win = new Ext.Window({
		width : 420,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
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
			var tempCode = Ext.getCmp("form-save").getForm().findField("SESSCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("SESSDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("SESSDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("SESSDateTo").getValue(); 
			if (tempCode=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>代码不能为空!</font>',
								minWidth : 200,
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								animEl: 'form-save',
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("SESSCode").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("SESSDesc").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("SESSDateFrom").focus(true,true);
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
												msg : '<font color=green>添加成功!</green>',
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
												msg : '<font color=red>添加失败!</font>',
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
													msg : '<font color=red>修改失败!</font>',
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
				Ext.getCmp("form-save").getForm().findField("SESSCode").focus(true,300);
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
	/************************************ 修改按钮************************************/
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
	 
	/*********************************数据存储方式***************************************************/
    var fields=[{
					name:'SESSRowId',
					mapping:'SESSRowId',
					type : 'int'
				}, {
					name : 'SESSCode',         
					mapping : 'SESSCode', 
					type : 'string'
				}, {
					name : 'SESSDesc',
					mapping :'SESSDesc',
					type:'string'
				},{
					name:'SESSCategory',
					mapping:'SESSCategory',
					type:'string'
				},{
					name:'SESSSessionTypeDR',
					mapping:'SESSSessionTypeDR',
					type:'string'
				},{
					name:'SESSNumberOfDays',
					mapping:'SESSNumberOfDays',
					type:'string'
				},{
					 name:'SESSEnableByDefault',
					 mapping:'SESSEnableByDefault',
					 type:'string',
					 inputValue : true?'Y':'N'
				},{
					name:'SESSDateFrom',
					mapping:'SESSDateFrom',
					type : 'date',
                    dateFormat : 'm/d/Y'
				}, {
					name :'SESSDateTo',
					mapping :'SESSDateTo',
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

	/************************************分页************************************/
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

/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',HospWinButton   //多院区医院
    ,'-',btnTrans ,'-',btnSort,'->',btnlog,'-',btnhislog]   
		})
/************************************搜索工具条************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue() ,
						desc : Ext.getCmp("TextDesc").getValue() ,
						active : Ext.getCmp("TextCTCOUActive").getValue(),
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
	var search=function()
	{
		grid.getStore().baseParams={			
				active : Ext.getCmp("TextCTCOUActive").getValue() ,
				hospid:hospComp.getValue() 
			 };
			grid.getStore().load({
				params : {
							start : 0,
							limit : pagesize_main
						}
				});
	}
/************************************ 刷新工作条***********************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
				    Ext.getCmp("TextCTCOUActive").reset();
					grid.getStore().baseParams={hospid:hospComp.getValue()};
					grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
							});
					}
			});
	 
	/************************************将工具条放到一起***********************************/
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
			},  '默认允许', {
							fieldLabel : '<font color=red></font>默认',
							xtype : 'combo',
							id : 'TextCTCOUActive',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTCOUActive'),
							width : 140,
							mode : 'local',
							triggerAction : 'all',
							minChars : 0,
							listWidth : 140,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [	{value : 'Y',name : 'Yes'}, 
													{value : 'N',name : 'No'}			
												]
										}),
							listeners:{
        					 'select': search
   							 }	
					},'-',LookUpConfigureBtn ,'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	/************************************创建表格*****************************************/
	var sm=	new Ext.grid.RowSelectionModel({singleSelect:true})
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
					header : 'SESSRowId',
					width : 20,
					sortable : true,
					dataIndex : 'SESSRowId',
					hidden : true
				}, {
					header : '代码',
					width : 60,
					sortable : true,
					renderer: Ext.BDP.FunLib.Component.GirdTipShow,
					dataIndex : 'SESSCode'
				}, {
					header : '描述',
					width : 50,
					sortable : true,
					renderer: Ext.BDP.FunLib.Component.GirdTipShow,
					dataIndex : 'SESSDesc'
				}, {
					header : '归类',
					width : 85,
					sortable : true,
					renderer: Ext.BDP.FunLib.Component.GirdTipShow,
					dataIndex : 'SESSCategory'
				}, {
					header : '转换',
					width : 85,
					sortable : true,
					renderer: Ext.BDP.FunLib.Component.GirdTipShow,
					dataIndex : 'SESSSessionTypeDR'
				},{
					header:'天数',
					width:85,
					sortable:true,
					dataIndex:'SESSNumberOfDays'
				},{
					header:'默认允许',
					width:60,
					sortable:true,
					dataIndex:'SESSEnableByDefault',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon 
				},{
					header : '开始日期',
					width : 100,
					sortable : true,
					renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
					dataIndex :'SESSDateFrom'
				}, {
					header : '结束日期',
					width : 100,
					sortable : true,
					renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
					dataIndex : 'SESSDateTo'
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
				columns:GridCM ,
				sm:sm,
				stripeRows : true,
				columnLines : true, //在列分隔处显示分隔符
				title : '挂号职称',
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
/*****************************************右键菜单操作**********************************************/
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
          var selectrow=_record.get('SESSRowId');
	
	 }
	else
	{
	  var selectrow=""
	 }
	Ext.BDP.FunLib.SelectRowId=selectrow
  });
/*********************************双击事件***********************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('SESSRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	                	Ext.getCmp("form-save").getForm().findField('SESSEnableByDefault').setValue((_record.get('SESSEnableByDefault'))=='Y'?true:false);
                      },
	                failure : function(form,action) {
	                 	Ext.Msg.alert('编辑', '载入失败!');
	                }
	            });
              //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('SESSRowId');
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
	/************************************键盘事件，按A键弹出添加窗口*************************/
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
      }
    });
  
  }
});
