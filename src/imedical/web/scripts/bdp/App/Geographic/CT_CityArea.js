	
	/// 名称:地理信息 - 6 城市区域维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2013-12-24
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_CityArea"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.CTCityArea";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    
	//翻译
	Ext.BDP.FunLib.TableName="CT_CityArea";
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
       RowID=rows[0].get('CITAREARowId');
       Desc=rows[0].get('CITAREADesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCityArea";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassMethod=DeleteData";
	
	var CITAREA_City_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetDataForCmb1";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();
	
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
						//删除所有别名
									
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('CITAREARowId');
						AliasGrid.delallAlias();
						
						

						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CITAREARowId')
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
	var CITAREARomanCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '罗马代码',
		name : 'CITAREARomanCode',
		id:'CITAREARomanCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREARomanCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREARomanCodeF')
	});	
	

	//---县级行政区罗马名称
	var CITAREARomanDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '罗马名称',
		name : 'CITAREARomanDesc',
		id:'CITAREARomanDescF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREARomanDescF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREARomanDescF')
	});


	//---排序号
	var CITAREASeqNo= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '排序号',
		name : 'CITAREASeqNo',
		id : 'CITAREASeqNoF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREASeqNoF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREASeqNoF')),
		dataIndex : 'CITAREASeqNo',
		allowDecimals: false, // 不允许小数点 
		allowNegative: false, // 不允许负数
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是非负整数'	
	});

	//---拼音码
	var CITAREAPYCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '拼音码',
		name : 'CITAREAPYCode',
		id:'CITAREAPYCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREAPYCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREAPYCodeF')
	});

	//---五笔码
	var CITAREAWBCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '五笔码',
		name : 'CITAREAWBCode',
		id:'CITAREAWBCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREAWBCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREAWBCodeF')
	});

	//---备注
	var CITAREAMark = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '备注',
		name : 'CITAREAMark',
		id:'CITAREAMarkF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREAMarkF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PROVMarkF')
	});

	// 增加修改的Form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				URL : SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				title:'基本信息',
				labelWidth : 75,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CITAREACode',mapping:'CITAREACode'},
                                         {name: 'CITAREADesc',mapping:'CITAREADesc'},
                                         {name: 'CITAREACityDR',mapping:'CITAREACityDR'},
                                         {name: 'CITAREADateFrom',mapping:'CITAREADateFrom'},
                                         {name: 'CITAREADateTo',mapping:'CITAREADateTo'},
                                         {name: 'CITAREARowId',mapping:'CITAREARowId'},
                                         {name: 'CITAREARomanCode',mapping:'CITAREARomanCode'},
                                         {name: 'CITAREARomanDesc',mapping:'CITAREARomanDesc'},
                                         {name: 'CITAREAActivity',mapping:'CITAREAActivity'},
                                         {name: 'CITAREASeqNo',mapping:'CITAREASeqNo'},
                                         {name: 'CITAREAPYCode',mapping:'CITAREAPYCode'},
                                         {name: 'CITAREAWBCode',mapping:'CITAREAWBCode'},
                                         {name: 'CITAREAMark',mapping:'CITAREAMark'}
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
									id:'CITAREARowId',
									xtype:'textfield',
									fieldLabel : 'CITAREARowId',
									name : 'CITAREARowId',
									hideLabel : 'True',
									hidden : true
								}, {
									maxLength:220, //这个例外不是15
									fieldLabel : '<font color=red>*</font>代码',
									xtype:'textfield',
									id:'CITAREACode',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREACode'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREACode')),
									name : 'CITAREACode',
									allowBlank:false,
									enableKeyEvents:true, 
									validationEvent : 'blur',  
		                            validator : function(thisText){
		                            	//Ext.Msg.alert(thisText);
			                            if(thisText==""){
			                            	return true;
			                            }
			                            var className =  "web.DHCBL.CT.CTCityArea";
			                            var classMethod = "FormValidate";                           
			                            var id="";
			                            if(win.title=='修改'){
			                            	var _record = grid.getSelectionModel().getSelected();
			                            	var id = _record.get('CITAREARowId');
			                            }
			                            var flag = "";
			                            var flag = tkMakeServerCall(className,classMethod,id,thisText);
			                            //Ext.Msg.alert(flag);
			                            if(flag == "1"){
			                            	return false;
			                             }else{
			                             	return true;
			                             }
		                            },
		                            invalidText : '该代码已经存在',
								    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
								}, CITAREARomanCode,{
									xtype : 'bdpcombo',
									pageSize : Ext.BDP.FunLib.PageSize.Combo,
									loadByIdParam : 'rowid',
									listWidth:250,
									
									fieldLabel : '<font color=red>*</font>市',
									hiddenName : 'CITAREACityDR',
									allowBlank : false,
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CITAREACityDR'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREACityDR'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREACityDR')),
									id :'CITAREACityDR1',
									store : new Ext.data.Store({
												autoLoad: true,
												proxy : new Ext.data.HttpProxy({ url : CITAREA_City_DR_QUERY_ACTION_URL }),
												reader : new Ext.data.JsonReader({
												totalProperty : 'total',
												root : 'data',
												successProperty : 'success'
											}, [{ name:'CTCITRowId',mapping:'CTCITRowId'},
												{name:'CTCITDesc',mapping:'CTCITDesc'} ])
										}),
									mode : 'local',
									shadow:false,
									queryParam : 'desc',
									//typeAhead : true,
									forceSelection : true,
									selectOnFocus : false,
									//triggerAction : 'all',
									//hideTrigger: false,
									displayField : 'CTCITDesc',
									valueField : 'CTCITRowId'
									//minChars : 1,
									//editable: false
								}, {
									xtype : 'datefield',
									fieldLabel : '<font color=red>*</font>开始日期',
									name : 'CITAREADateFrom',
									format : BDPDateFormat,
									id:'date1',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
									enableKeyEvents : true,
									listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
		  					 		//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
									vtype:'cKDate',
									allowBlank:false
								},{
									fieldLabel: '<font color=red></font>是否有效',
									xtype : 'checkbox',
									name : 'CITAREAActivity',
									id:'CITAREAActivityF',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREAActivityF'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREAActivityF')),
									inputValue : true?'Y':'N',//这句话对Checkbox不起作用，可以直接写成 inputValue : 'Y'
									checked:true
									
								},CITAREAPYCode

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
									id:'CITAREADesc',
									maxLength:220,
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CITAREADesc'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CITAREADesc'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CITAREADesc')),
									name : 'CITAREADesc',
									allowBlank:false,
								    listeners : {
								    	'blur' : function(){
								    		//失焦自动填写拼音码和五笔码
							        		var Desc=Ext.getCmp("CITAREADesc").getValue()
							        		if (Desc!="")
							        		{
							        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
										        var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
										        Ext.getCmp("CITAREAPYCodeF").setValue(PYCode)  
										        Ext.getCmp("CITAREAWBCodeF").setValue(WBCode)
							        		}
								    	}
									}
									
								},CITAREARomanDesc,CITAREASeqNo, {
									xtype : 'datefield',
									fieldLabel : '结束日期',
									name : 'CITAREADateTo',
									format : BDPDateFormat,
									id:'date2',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
									enableKeyEvents : true,
									listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
									vtype:'cKDate'
								},CITAREAWBCode,CITAREAMark

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
				Ext.getCmp("form-save").getForm().findField("CITAREACode").focus(true,300);
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
			            AliasGrid.DataRefer = _record.get('CITAREARowId');
				        AliasGrid.loadGrid();
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
								name : 'CITAREARowId',
								mapping : 'CITAREARowId',
								type : 'number'
							}, {
								name : 'CITAREACode',
								mapping : 'CITAREACode',
								type : 'string'
							}, {
								name : 'CITAREADesc',
								mapping : 'CITAREADesc',
								type : 'string'
							}, {
								name : 'CITAREACityDR',
								mapping : 'CITAREACityDR',
								type : 'string'
							},{
								name : 'CITAREADateFrom',
								mapping : 'CITAREADateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CITAREADateTo',
								mapping : 'CITAREADateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CITAREARomanCode',
								mapping : 'CITAREARomanCode',
								type : 'string'
							}, {
								name : 'CITAREARomanDesc',
								mapping : 'CITAREARomanDesc',
								type : 'string'
							}, {
								name : 'CITAREAPROVCode',
								mapping : 'CITAREAPROVCode',
								type : 'string'
							}, {
								name : 'CITAREAActivity',
								mapping : 'CITAREAActivity',
								type : 'string'
							}, {
								name : 'CITAREASeqNo',
								mapping : 'CITAREASeqNo',
								type : 'string'
							}, {
								name : 'CITAREAPYCode',
								mapping : 'CITAREAPYCode',
								type : 'string'
							}, {
								name : 'CITAREAWBCode',
								mapping : 'CITAREAWBCode',
								type : 'string'
							}, {
								name : 'CITAREAMark',
								mapping : 'CITAREAMark',
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
	});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) { 
				}
	});
	
	// 分页工具条
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
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
						
						citydr :  Ext.getCmp("TextCITAREACityDR").getValue()
						
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
					Ext.getCmp("TextCITAREACityDR").reset();
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
						'市',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							shadow:false,
							fieldLabel : '<font color=red></font>市',
							id :'TextCITAREACityDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCITAREACityDR'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CITAREA_City_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTCITRowId',mapping:'CTCITRowId'},
										{name:'CTCITDesc',mapping:'CTCITDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'CTCITDesc',
							valueField : 'CTCITRowId'
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
							header : 'CITAREARowId',
							width : 70,
							sortable : true,
							dataIndex : 'CITAREARowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CITAREACode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'CITAREADesc'
						}, {
							header : '罗马代码',
							width : 120,
							sortable : true,
							dataIndex : 'CITAREARomanCode'
						},{
							header : '罗马名称',
							width : 100,
							sortable : true,
							dataIndex : 'CITAREARomanDesc'
						}, {
							header : '市',
							width : 100,
							sortable : true,
							dataIndex : 'CITAREACityDR'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CITAREADateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CITAREADateTo'
						}, {
							header : '是否有效',
							width : 80,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CITAREAActivity'
						}, {
							header : '排序号',
							width : 80,
							sortable : true,
							dataIndex : 'CITAREASeqNo'
						}, {
							header : '拼音码',
							width : 100,
							sortable : true,
							dataIndex : 'CITAREAPYCode'
						},{
							header : '五笔码',
							width : 100,
							sortable : true,
							dataIndex : 'CITAREAWBCode'
						}, {
							header : '备注',
							width : 100,
							sortable : true,
							dataIndex : 'CITAREAMark'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '城市区域',
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
	

    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
        } else {
        	win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CITAREARowId'),
                success : function(form,action) {
                },
                failure : function(form,action) {
                }
            });
        }
    };
    //翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('CITAREARowId');	           
		 	} else {
		 		var selectrow="";
			 }
				Ext.BDP.FunLib.SelectRowId = selectrow;	

			})

			
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
        	loadFormData(grid);
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('CITAREARowId');
	        AliasGrid.loadGrid();
		}
    });	
    
	
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});
});