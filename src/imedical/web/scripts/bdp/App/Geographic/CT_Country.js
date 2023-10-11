	
	/// 名称:地理信息 - 1 国籍/地区维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2012-9-10
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	var CouLinkLanJS = '../scripts/bdp/App/Geographic/HOS_CountryLinkLan.js';//关联语言部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+CouLinkLanJS+'"></scr' + 'ipt>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_Country"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.CTCountry";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    
    //翻译
	Ext.BDP.FunLib.TableName="CT_Country";
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
       RowID=rows[0].get('CTCOURowId');
       Desc=rows[0].get('CTCOUDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCountry";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassMethod=DeleteData";
	
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
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('CTCOURowId');
						AliasGrid.delallAlias();
									
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTCOURowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
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
	

			    
	//---英文简称
	var CTCOUENGShortDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '英文简称',
		name : 'CTCOUENGShortDesc',
		id:'CTCOUENGShortDescF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUENGShortDescF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUENGShortDescF')
	});

	//---中文全称
	var CTCOUCHNFullDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '中文全称',
		name : 'CTCOUCHNFullDesc',
		id:'CTCOUCHNFullDescF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUCHNFullDescF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUCHNFullDescF')
	});

	//---英文全称
	var CTCOUENGFullDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '英文全称',
		name : 'CTCOUENGFullDesc',
		id:'CTCOUENGFullDescF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUENGFullDescF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUENGFullDescF')
	});

	//---罗马2字符代码
	var CTCOURomanCode2 = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '罗马2字符代码',
		name : 'CTCOURomanCode2',
		id:'CTCOURomanCode2F',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOURomanCode2F')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOURomanCode2F')
	});

	//---罗马3字符代码
	var CTCOURomanCode3 = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '罗马3字符代码',
		name : 'CTCOURomanCode3',
		id:'CTCOURomanCode3F',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOURomanCode3F')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOURomanCode3F')
	});

	var CTCOUSeqNo= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '排序号',
		name : 'CTCOUSeqNo',
		id : 'CTCOUSeqNoF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUSeqNoF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUSeqNoF')),
		dataIndex : 'CTCOUSeqNo',
		allowDecimals: false, // 不允许小数点 
		allowNegative: false, // 不允许负数
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是非负整数'	
	});
/*
	//---排序号
	var CTCOUSeqNo = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '排序号',
		name : 'CTCOUSeqNo',
		id:'CTCOUSeqNoF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUSeqNoF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUSeqNoF')
	});	*/

	//---拼音码
	var CTCOUPYCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '拼音码',
		name : 'CTCOUPYCode',
		id:'CTCOUPYCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUPYCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUPYCodeF')
	});

	//---五笔码
	var CTCOUWBCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '五笔码',
		name : 'CTCOUWBCode',
		id:'CTCOUWBCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUWBCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUWBCodeF')
	});

	//---备注
	var CTCOUMark = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '备注',
		name : 'CTCOUMark',
		id:'CTCOUMarkF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUMarkF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUMarkF')
	});

	var BindingLanguage = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetDataForCmb1";
	var CTCOULanguageDR = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '语言',
		loadByIdParam : 'rowid',
		id:'CTCOULanguageDRF',
		name: 'CTCOULanguageDR',
		hiddenName:'CTCOULanguageDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOULanguageDRF'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOULanguageDRF')),
		queryParam:"desc",
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTLANRowId',
		displayField:'CTLANDesc',
		store:new Ext.data.JsonStore({
			url:BindingLanguage,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTLANRowId',
			fields:['CTLANRowId','CTLANDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTLANRowId', direction: 'ASC'}
		})
	});

	// 增加修改的form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				title : '基本信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				URL : SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 120,
				autoScroll : true, //滚动条
				frame : true,//baseCls : 'x-plain',
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTCOUCode',mapping:'CTCOUCode'},
                                         {name: 'CTCOUDesc',mapping:'CTCOUDesc'},
                                         {name: 'CTCOUActive',mapping:'CTCOUActive'},
                                         {name: 'CTCOUDateActiveFrom',mapping:'CTCOUDateActiveFrom'},
                                         {name: 'CTCOUDateActiveTo',mapping:'CTCOUDateActiveTo'},
                                         {name: 'CTCOURowId',mapping:'CTCOURowId'},
                                         {name: 'CTCOUENGShortDesc',mapping:'CTCOUENGShortDesc'},
                                         {name: 'CTCOUCHNFullDesc',mapping:'CTCOUCHNFullDesc'},
                                         {name: 'CTCOUENGFullDesc',mapping:'CTCOUENGFullDesc'},
                                         {name: 'CTCOURomanCode2',mapping:'CTCOURomanCode2'},
                                         {name: 'CTCOURomanCode3',mapping:'CTCOURomanCode3'},
                                         {name: 'CTCOUSeqNo',mapping:'CTCOUSeqNo'},
                                         {name: 'CTCOUPYCode',mapping:'CTCOUPYCode'},
                                         {name: 'CTCOUWBCode',mapping:'CTCOUWBCode'},
                                         {name: 'CTCOUMark',mapping:'CTCOUMark'},
                                         {name: 'CTCOULanguageDR',mapping:'CTCOULanguageDR'}


                                        ]),
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
							columnWidth:'.55',
							layout: 'form',
							labelPad:1,//默认5
							border:false,
							defaults: {anchor:'90%'},
							items: [{
									id:'CTCOURowId',
									xtype:'textfield',
									fieldLabel : 'CTCOURowId',
									name : 'CTCOURowId',
									hideLabel : 'True',
									hidden : true
								}, {
									fieldLabel : '<font color=red>*</font>代码',
									xtype:'textfield',
									id:'CTCOUCode',
									maxLength:15,
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCOUCode'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUCode'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUCode')),
									name : 'CTCOUCode',
									allowBlank:false,
									enableKeyEvents:true, 
									validationEvent : 'blur',  
		                            validator : function(thisText){
		                            	//Ext.Msg.alert(thisText);
			                            if(thisText==""){
			                            	return true;
			                            }
			                            var className =  "web.DHCBL.CT.CTCountry";
			                            var classMethod = "FormValidate";                         
			                            var id="";
			                            if(win.title=='修改'){
			                            	var _record = grid.getSelectionModel().getSelected();
			                            	var id = _record.get('CTCOURowId');
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
								},CTCOUENGShortDesc,CTCOUENGFullDesc,CTCOURomanCode2,
								{
									xtype : 'datefield',
									fieldLabel : '<font color=red>*</font>开始日期',
									name : 'CTCOUDateActiveFrom',
									format : BDPDateFormat,
									id:'date1',
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
									vtype:'cKDate',
									enableKeyEvents : true,
									listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
									allowBlank:false
								},CTCOULanguageDR,CTCOUMark,{
									fieldLabel: '<font color=red></font>是否有效',
									xtype : 'checkbox',
									name : 'CTCOUActive',
									id:'CTCOUActive',
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCOUActive'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUActive'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUActive')),
									inputValue : true?'Y':'N',//这句话对Checkbox不起作用，可以直接写成 inputValue : 'Y'
									checked:true
									
								}
							]					
						},{
							baseCls : 'x-plain',
						    columnWidth:'.45',
							layout: 'form',
							labelPad:1,
							border:false,
							defaults: {anchor:'90%'},
							items: [{
									fieldLabel : '<font color=red>*</font>描述',
									xtype:'textfield',
									id:'CTCOUDesc',
									maxLength:220,
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCOUDesc'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCOUDesc'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCOUDesc')),
									name : 'CTCOUDesc',
									allowBlank:false,
									enableKeyEvents:true, 
									validationEvent : 'blur',
		                            validator : function(thisText){
		                            	//Ext.Msg.alert(thisText);
			                            if(thisText==""){
			                            	return true;
			                            }
			                            var className =  "web.DHCBL.CT.CTCountry";
			                            var classMethod = "FormValidate";
			                            var id="";
			                            if(win.title=='修改'){
			                            	var _record = grid.getSelectionModel().getSelected();
			                            	var id = _record.get('CTCOURowId');
			                            }
			                            var flag = "";
			                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);
			                            //Ext.Msg.alert(flag);
			                            if(flag == "1"){
			                             	return false;
			                             }else{
			                             	return true;
			                             }
		                            },
		                            invalidText : '该描述已经存在',
								    listeners : {
								    	'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
								    	'blur' : function(){
								    		//失焦自动填写拼音码和五笔码
							        		var Desc=Ext.getCmp("CTCOUDesc").getValue()
							        		if (Desc!="")
							        		{
							        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
										        var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
										        Ext.getCmp("CTCOUPYCodeF").setValue(PYCode)  
										        Ext.getCmp("CTCOUWBCodeF").setValue(WBCode)
							        		}
								    	}
									}

								
								},CTCOUCHNFullDesc,CTCOUSeqNo,CTCOURomanCode3,
								{
									xtype : 'datefield',
									fieldLabel : '结束日期',
									name : 'CTCOUDateActiveTo',
									id:'date2',
									//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
									enableKeyEvents : true,
									listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
									vtype:'cKDate',
									format : BDPDateFormat
								}, CTCOUPYCode,CTCOUWBCode

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
	//var height=Math.min(Ext.getBody().getViewSize().height-30,600)	
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 800,
		height:400,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		//autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
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
				Ext.getCmp("form-save").getForm().findField("CTCOUCode").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
			/**********************************定义国家关联语言按钮********************************/	
	var winCouLinkLan = new Ext.Window(getCouLinkLanPanel());  //调用关联语言面板
	var btnCouLinkLan = new Ext.Toolbar.Button({				
	    text: '关联语言',
	    id:'btnCouLinkLan',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCouLinkLan'),
        iconCls: 'icon-LinkLoc',
		tooltip: '关联语言',
		handler: CouLinkLanWinEdit = function() {   
    			var _record = grid.getSelectionModel().getSelected();
	        	if(_record)
	        	{
		        var gsm = grid.getSelectionModel();//获取选择列
	            var rows = gsm.getSelections();//根据选择列获取到所有的行 
				winCouLinkLan.setTitle(rows[0].get('CTCOUDesc')+'-关联语言');
				winCouLinkLan.setIconClass('icon-LinkLoc');
				winCouLinkLan.show('');
	            var CTCOURowId=rows[0].get('CTCOURowId');
	            Ext.getCmp("Hidden_CTCountryId").reset();
	           	Ext.getCmp("Hidden_CTCountryId").setValue(CTCOURowId);  //对调用的js中id为 Hidden_CTCountryId 的变量赋值
	            gridCouLinkLan.getStore().baseParams={cllcoudr:CTCOURowId};
	           	gridCouLinkLan.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});	           	
	        	}
		        else
				{
					Ext.Msg.show({
							title:'提示',
							msg:'请选择一个国家!',
							icon:Ext.Msg.WARNING,
							buttons:Ext.Msg.OK
						});
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
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show();
						loadFormData(grid);
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('CTCOURowId');
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
								name : 'CTCOURowId',
								mapping : 'CTCOURowId',
								type : 'number'
							}, {
								name : 'CTCOUCode',
								mapping : 'CTCOUCode',
								type : 'string'
							}, {
								name : 'CTCOUDesc',
								mapping : 'CTCOUDesc',
								type : 'string'
							}, {
								name : 'CTCOUActive',
								mapping : 'CTCOUActive',
								//type : 'string' // radio
								inputValue : true?'Y':'N' //checkbox
							},{
								name : 'CTCOUDateActiveFrom',
								mapping : 'CTCOUDateActiveFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CTCOUDateActiveTo',
								mapping : 'CTCOUDateActiveTo',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CTCOUENGShortDesc',
								mapping : 'CTCOUENGShortDesc',
								type : 'string'
							}, {
								name : 'CTCOUCHNFullDesc',
								mapping : 'CTCOUCHNFullDesc',
								type : 'string'
							}, {
								name : 'CTCOUENGFullDesc',
								mapping : 'CTCOUENGFullDesc',
								type : 'string'
							}, {
								name : 'CTCOURomanCode2',
								mapping : 'CTCOURomanCode2',
								type : 'string'
							}, {
								name : 'CTCOURomanCode3',
								mapping : 'CTCOURomanCode3',
								type : 'string'
							}, {
								name : 'CTCOUSeqNo',
								mapping : 'CTCOUSeqNo',
								type : 'string'
							}, {
								name : 'CTCOUPYCode',
								mapping : 'CTCOUPYCode',
								type : 'string'
							}, {
								name : 'CTCOUWBCode',
								mapping : 'CTCOUWBCode',
								type : 'string'
							}, {
								name : 'CTCOUMark',
								mapping : 'CTCOUMark',
								type : 'string'
							}, {
								name : 'CTCOULanguageDR',
								mapping : 'CTCOULanguageDR',
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
				//sortInfo: {field : "OPERRowId",direction : "ASC"}
	});
	//ds.sort("CTCOUCode","DESC");
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);		
 	// 加载数据
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
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
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
		,'-',btnSort,'-',btnTrans,'-',btnCouLinkLan,'->',btnlog,'-',btnhislog
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
					
						active : Ext.getCmp("TextCTCOUActive").getValue()
						
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
					Ext.getCmp("TextCTCOUActive").reset();  
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
						'是否有效',
						 {
							fieldLabel : '<font color=red></font>是否有效',
							xtype : 'combo',
							//name : 'CTCOUActive',
							id : 'TextCTCOUActive',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTCOUActive'),
							width : 140,
							mode : 'local',
							//hiddenName:'CTCOUActive',
							triggerAction : 'all',
							//forceSelection : true,
							//selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							listWidth : 140,
							shadow:false,
							valueField : 'value',
							displayField : 'name',
							//editable:false,
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{value : 'Y',name : 'Yes'}, 
												{value : 'N',name : 'No'}			
										]
							})	
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
							header : 'CTCOURowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTCOURowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CTCOUCode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							dataIndex : 'CTCOUDesc'
						
						}, {
							header : '开始日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTCOUDateActiveFrom'
						}, {
							header : '结束日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTCOUDateActiveTo'
						}, {
							header : '英文简称',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUENGShortDesc'
						
						}, {
							header : '中文全称',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUCHNFullDesc'
						
						}, {
							header : '英文全称',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUENGFullDesc'
						
						}, {
							header : '罗马2字符代码',
							width : 120,
							sortable : true,
							hidden : true,
							dataIndex : 'CTCOURomanCode2'
						
						}, {
							header : '罗马3字符代码',
							width : 120,
							sortable : true,
							hidden : true,
							dataIndex : 'CTCOURomanCode3'
						
						}, {
							header : '是否有效',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTCOUActive'
						}, {
							header : '语言',
							width : 80,
							sortable : true,
							dataIndex : 'CTCOULanguageDR'
						
						}, {
							header : '排序号',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUSeqNo'
						
						}, {
							header : '拼音码',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUPYCode'
						
						}, {
							header : '五笔码',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUWBCode'
						
						}, {
							header : '备注',
							width : 100,
							sortable : true,
							dataIndex : 'CTCOUMark'
						
						}]

	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '国籍/地区',
				id : 'grid',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
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
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTCOURowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
           
            Ext.getCmp("form-save").getForm().findField('CTCOUActive').setValue((_record.get('CTCOUActive'))=='Y'?true:false);
        }
    };

    //双击事件
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
		   	//var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('CTCOURowId');
	        AliasGrid.loadGrid();
		}	
    });	
	
//翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('CTCOURowId');	           
		 	} else {
		 		var selectrow="";
			 }
				Ext.BDP.FunLib.SelectRowId = selectrow;	

			})

    
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
   
    
	//创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});