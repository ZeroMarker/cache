	
	/// 名称:地理信息 - 4 城市维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2012-9-11
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_City"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.CTCity";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//翻译
	Ext.BDP.FunLib.TableName="CT_City";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	 /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
		 //////////////////////////////日志查看 ////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
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
       RowID=rows[0].get('CTCITRowId');
       Desc=rows[0].get('CTCITDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCity";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassMethod=DeleteData";
	
	var CT_Province_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTProvince&pClassQuery=GetDataForCmb1";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();// 初始化显示提示信息。没有它提示信息出不来。
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	Ext.form.Field.prototype.msgTarget = 'qtip';

	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();
    		var v2 = Ext.getCmp ("date2").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKDateText:'结束日期应该大于开始日期'
	});
	
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('CTCITRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTCITRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{
										//var myrowid = action.result.id;                
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												var startIndex = grid.getBottomToolbar().cursor;
												var totalnum=grid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize==0)//最后一页只有一条
												{
														
														var pagenum=grid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												grid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize  
																}	
														});		
	
											}
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							}
						}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});

	//---罗马代码
	var CTCITRomanCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '罗马代码',
		name : 'CTCITRomanCode',
		id:'CTCITRomanCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITRomanCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITRomanCodeF')
	});	

	//---市级行政区罗马名称
	var CTCITRomanDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '罗马名称',
		name : 'CTCITRomanDesc',
		id:'CTCITRomanDescF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITRomanDescF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITRomanDescF')
	});	

	//---排序号
	var CTCITSeqNo= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '排序号',
		name : 'CTCITSeqNo',
		id : 'CTCITSeqNoF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITSeqNoF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITSeqNoF')),
		dataIndex : 'CTCITSeqNo',
		allowDecimals: false, // 不允许小数点 
		allowNegative: false, // 不允许负数
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是非负整数'	
	});

	//---拼音码
	var CTCITPYCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '拼音码',
		name : 'CTCITPYCode',
		id:'CTCITPYCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITPYCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITPYCodeF')
	});

	//---五笔码
	var CTCITWBCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '五笔码',
		name : 'CTCITWBCode',
		id:'CTCITWBCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITWBCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITWBCodeF')
	});

	//---备注
	var CTCITMark = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '备注',
		name : 'CTCITMark',
		id:'CTCITMarkF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITMarkF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PROVMarkF')
	});

	// 增加修改的Form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				//collapsible : true,
				title:'基本信息',
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				URL : SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTCITCode',mapping:'CTCITCode'},
                                         {name: 'CTCITDesc',mapping:'CTCITDesc'},
                                         {name: 'CTCITProvinceDR',mapping:'CTCITProvinceDR'},
                                         {name: 'CTCITDateFrom',mapping:'CTCITDateFrom'},
                                         {name: 'CTCITDateTo',mapping:'CTCITDateTo'},
                                         {name: 'CTCITRowId',mapping:'CTCITRowId'},
                                         {name: 'CTCITRomanCode',mapping:'CTCITRomanCode'},
                                         {name: 'CTCITRomanDesc',mapping:'CTCITRomanDesc'},
                                         {name: 'CTCITCountryCode',mapping:'CTCITCountryCode'},
                                         {name: 'CTCITActivity',mapping:'CTCITActivity'},
                                         {name: 'CTCITSeqNo',mapping:'CTCITSeqNo'},
                                         {name: 'CTCITPYCode',mapping:'CTCITPYCode'},
                                         {name: 'CTCITWBCode',mapping:'CTCITWBCode'},
                                         {name: 'CTCITMark',mapping:'CTCITMark'}     
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				items : {
					xtype:'fieldset',
					border:false,
					autoHeight:true,
					items :[{
						baseCls : 'x-plain',
						layout:'column',
						border:false,
						items:[{
							baseCls : 'x-plain',
							columnWidth:'.5',
							layout: 'form',
							labelPad:1,//默认5
							border:false,
							defaults: {anchor:'90%'},
							items: [{
									id:'CTCITRowId',
									xtype:'textfield',
									fieldLabel : 'CTCITRowId',
									name : 'CTCITRowId',
									hideLabel : 'True',
									hidden : true
								}, {
									maxLength:220, //这个例外不是15
									fieldLabel : '<font color=red>*</font>代码',
									xtype:'textfield',
									id:'CTCITCode',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITCode'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITCode')),
									name : 'CTCITCode',
									allowBlank:false,
									enableKeyEvents:true, 
									validationEvent : 'blur',  
		                            validator : function(thisText){
		                            	//Ext.Msg.alert(thisText);
			                            if(thisText==""){
			                            	return true;
			                            }
			                            var className =  "web.DHCBL.CT.CTCity";
			                            var classMethod = "FormValidate";                           
			                            var id="";
			                            if(win.title=='修改'){
			                            	var _record = grid.getSelectionModel().getSelected();
			                            	var id = _record.get('CTCITRowId');
			                            }
			                            var flag = "";
			                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");
			                            //Ext.Msg.alert(flag);
			                            if(flag == "1"){
			                            	return false;
			                             }else{
			                             	return true;
			                             }
		                            },
		                            invalidText : '该代码已经存在',
								    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
								},{
									xtype : 'bdpcombo',
									pageSize : Ext.BDP.FunLib.PageSize.Combo,
									loadByIdParam : 'rowid',
									listWidth:250,
									///emptyText:'请选择',
									fieldLabel : '<font color=red>*</font>省份',
									hiddenName : 'CTCITProvinceDR',
									allowBlank : false,
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCITProvinceDR'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITProvinceDR'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITProvinceDR')),
									//id :'CTCITProvinceDR',
									store : new Ext.data.Store({
												autoLoad: true,
												proxy : new Ext.data.HttpProxy({ url : CT_Province_DR_QUERY_ACTION_URL }),
												reader : new Ext.data.JsonReader({
												totalProperty : 'total',
												root : 'data',
												successProperty : 'success'
											}, [{ name:'PROVRowId',mapping:'PROVRowId'},
												{name:'PROVDesc',mapping:'PROVDesc'} ])
										}),
									mode  : 'local',
									shadow:false,
									queryParam : 'desc',
									forceSelection : true,
									selectOnFocus : false,
									//triggerAction : 'all',//用bdpcombo时要注释掉
									//hideTrigger: false,
									displayField : 'PROVDesc',
									valueField : 'PROVRowId'
									//typeAhead : true,
									//minChars : 1,
									//editable: false
								},{
									xtype : 'datefield',
									fieldLabel : '<font color=red>*</font>开始日期',
									name : 'CTCITDateFrom',
									format : BDPDateFormat,
									id:'date1',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
									enableKeyEvents : true,
									listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
		  					 		//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
									vtype:'cKDate',
									allowBlank:false
								},CTCITRomanCode,{
									fieldLabel: '<font color=red></font>是否有效',
									xtype : 'checkbox',
									name : 'CTCITActivity',
									id:'CTCITActivityF',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITActivityF'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITActivityF')),
									inputValue : true?'Y':'N',//这句话对Checkbox不起作用，可以直接写成 inputValue : 'Y'
									checked:true
									
								},CTCITWBCode

							]					
						},{
							baseCls : 'x-plain',
						    columnWidth:'.5',
							layout: 'form',
							labelPad:1,
							border:false,
							defaults: {anchor:'90%'},
							items: [{
									fieldLabel : '<font color=red>*</font>描述',
									xtype:'textfield',
									id:'CTCITDesc',
									maxLength:220,
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCITDesc'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCITDesc'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCITDesc')),
									name : 'CTCITDesc',
									allowBlank:false,
								    listeners : {
								    	'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
								    	'blur' : function(){
								    		//失焦自动填写拼音码和五笔码
							        		var Desc=Ext.getCmp("CTCITDesc").getValue()
							        		if (Desc!="")
							        		{
							        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
										        var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
										        Ext.getCmp("CTCITPYCodeF").setValue(PYCode)  
										        Ext.getCmp("CTCITWBCodeF").setValue(WBCode)
							        		}
								    	}
									}
								},CTCITSeqNo, {
									xtype : 'datefield',
									fieldLabel : '结束日期',
									name : 'CTCITDateTo',
									format : BDPDateFormat,
									id:'date2',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
									enableKeyEvents : true,
									listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
									vtype:'cKDate'
								},CTCITRomanDesc,CTCITPYCode,CTCITMark

							]						
						}]
					}]
				}
			});
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });		
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 500,
		height: 340,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,
		frame : true,
		//autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() { 
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				//-------添加----------	
				if (win.title == "添加") {
					//WinForm.form.isValid()
					WinForm.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								 //var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
									
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});*/
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
						}
					}, this);
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("CTCITCode").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
					
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
		            
				},
				scope: this
	});
	
	// 修改按钮
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					if (grid.selModel.hasSelection()) {
						loadFormData(grid);
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('CTCITRowId');
				        AliasGrid.loadGrid();
				        
						//var record = grid.getSelectionModel().getSelected();
						//Ext.getCmp("form-save").getForm().loadRecord(record);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	var fields=[{
								name : 'CTCITRowId',
								mapping : 'CTCITRowId',
								type : 'number'
							}, {
								name : 'CTCITCode',
								mapping : 'CTCITCode',
								type : 'string'
							}, {
								name : 'CTCITDesc',
								mapping : 'CTCITDesc',
								type : 'string'
							}, {
								name : 'CTCITProvinceDR',
								mapping : 'CTCITProvinceDR',
								type : 'string'
							},{
								name : 'CTCITDateFrom',
								mapping : 'CTCITDateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CTCITDateTo',
								mapping : 'CTCITDateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CTCITRomanCode',
								mapping : 'CTCITRomanCode',
								type : 'string'
							}, {
								name : 'CTCITRomanDesc',
								mapping : 'CTCITRomanDesc',
								type : 'string'
							}, {
								name : 'CTCITActivity',
								mapping : 'CTCITActivity',
								type : 'string'
							}, {
								name : 'CTCITSeqNo',
								mapping : 'CTCITSeqNo',
								type : 'string'
							}, {
								name : 'CTCITPYCode',
								mapping : 'CTCITPYCode',
								type : 'string'
							}, {
								name : 'CTCITWBCode',
								mapping : 'CTCITWBCode',
								type : 'string'
							}, {
								name : 'CTCITMark',
								mapping : 'CTCITMark',
								type : 'string'
							}
						]
						
						
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
				//remoteSort : true
				//sortInfo: {field : "CTCITRowId",direction : "ASC"}
	});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	//ds.sort("CTCITCode","DESC");
			
 	// 加载数据
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) { 
				}
	});
	
	// 分页工具条
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel
		,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		
]
	});
	
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={
						code :  Ext.getCmp("TextCode").getValue(),
						
						desc :  Ext.getCmp("TextDesc").getValue(),
						
						provincedr :  Ext.getCmp("TextCTCITProvinceDR").getValue()
						
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}
	});
	
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextCTCITProvinceDR").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}
	});
	
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {xtype : 'textfield',id : 'TextCode',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'-',
						'描述', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-', 
						'省份',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							//emptyText:'请选择',
							shadow:false,
							fieldLabel : '<font color=red></font>省',
							//hiddenName : 'TextCTCITProvinceDR',
							id :'TextCTCITProvinceDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTCITProvinceDR'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CT_Province_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PROVRowId',mapping:'PROVRowId'},
										{name:'PROVDesc',mapping:'PROVDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'PROVDesc',
							valueField : 'PROVRowId'
							//typeAhead : true,
							//minChars : 1,
							//listWidth : 150,
							//editable: false,
							//allowBlank : false
						},'-',
						LookUpConfigureBtn,'-',
						btnSearch,'-', 
						btnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});
	var GridCM=[sm, {
							header : 'CTCITRowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTCITRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CTCITCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'CTCITDesc'
						}, {
							header : '罗马代码',
							width : 120,
							sortable : true,
							dataIndex : 'CTCITRomanCode'
						},{
							header : '罗马名称',
							width : 100,
							sortable : true,
							dataIndex : 'CTCITRomanDesc'
						}, {
							header : '省份',
							width : 100,
							sortable : true,
							dataIndex : 'CTCITProvinceDR'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTCITDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTCITDateTo'
						}, {
							header : '是否有效',
							width : 80,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTCITActivity'
						}, {
							header : '排序号',
							width : 80,
							sortable : true,
							dataIndex : 'CTCITSeqNo'
						}, {
							header : '拼音码',
							width : 100,
							sortable : true,
							dataIndex : 'CTCITPYCode'
						},{
							header : '五笔码',
							width : 100,
							sortable : true,
							dataIndex : 'CTCITWBCode'
						}, {
							header : '备注',
							width : 100,
							sortable : true,
							dataIndex : 'CTCITMark'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '城市',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'	
	});
	
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
   // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
        	win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTCITRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('提示','载入成功！');
                },
                failure : function(form,action) {
                	//Ext.Msg.alert('提示','载入失败！');
                }
            });
        }
    };
    
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
		   //var row = grid.getStore().getAt(rowIndex).data;
        	loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('CTCITRowId');
	        AliasGrid.loadGrid();
		}	        
    });	
    //翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('CTCITRowId');	           
		 	} else {
		 		var selectrow="";
			 }
				Ext.BDP.FunLib.SelectRowId = selectrow;	

			})

	
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
    
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});