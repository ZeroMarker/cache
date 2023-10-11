	
	/// 名称:地理信息 - 5 邮编维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2012-9-12
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_Zip"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.CTZip";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//翻译
	Ext.BDP.FunLib.TableName="CT_Zip";
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
       RowID=rows[0].get('CTZIPRowId');
       Desc=rows[0].get('CTZIPDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTZip&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTZip&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTZip&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTZip";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTZip&pClassMethod=DeleteData";
	
	var CT_Region_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTRegion&pClassQuery=GetDataForCmb1";
	//级联，用的GetDataForCmb2
	var CT_Province_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTProvince&pClassQuery=GetDataForCmb2";
	var CT_City_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetDataForCmb2";
	var CT_CityArea_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassQuery=GetDataForCmb2"; 
	var CT_HealthCareArea_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareArea&pClassQuery=GetDataForCmb1";   ///2015-3-13
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();

	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());//初始化Ext状态管理器,在Cookie中记录用户的操作状态
	
	Ext.form.Field.prototype.msgTarget = 'qtip';//设置消息提示方式悬浮提示，under为在下方直接显示,右边为side
	
	// 自定义一个cKData的vtype的表单验证, 用来验证结束日期是否大约开始日期
	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();
    		var v2 = Ext.getCmp ("date2").getValue();
    		if(v1=="" || v2=="") return true;//有日期为空的情况要排除在外
    		return v2 > v1;//通过判断返回一个boolean值类型
		},
		cKDateText:'结束日期应该大于开始日期'//当判断错误时显示的错误提示信息
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
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('CTZIPRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTZIPRowId')
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
								else {//对应 if (success) {}   
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
	var regionStore =new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : CT_Region_DR_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
				totalProperty : 'total',
				root : 'data',
				successProperty : 'success'
			}, [{ name:'CTRGRowId',mapping:'CTRGRowId'},
				{name:'CTRGDesc',mapping:'CTRGDesc'} ])
	});
	
	var comboRegion= {
		xtype : 'bdpcombo',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		loadByIdParam : 'rowid',
		listWidth:250,
		//emptyText:'请选择',
		fieldLabel : '<font color=red></font>区域',
		hiddenName : 'CTZIPRegionDR',
		id :'comboCTZIPRegionDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPRegionDR'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPRegionDR')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPRegionDR'),
		store : regionStore,
		mode : 'local',
		shadow:false,
		queryParam : 'desc',
		forceSelection : true,
		selectOnFocus : false,
		//triggerAction : 'all',
		//hideTrigger: false,
		//typeAhead : true,
		//minChars : 1,
		//editable: false,
		//allowBlank : false,
		displayField : 'CTRGDesc',
		valueField : 'CTRGRowId',
		listeners : {
				'select' : function(combo, record, index) {
					Ext.getCmp('comboCTZIPProvinceDR').reset();
					Ext.getCmp('comboCTZIPCITYDR').reset();
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
					
					provinceStore.baseParams = {
						regiondr : combo.getValue()
					};
					cityStore.baseParams = {
						provincedr : ""
					};
					CityAreaStore.baseParams = {
						citydr : ""
					};
					
				},
				
				/*'collapse':function(combo) { //当下拉列表收起的时候触发
					Ext.getCmp('comboCTZIPProvinceDR').reset();
					Ext.getCmp('comboCTZIPCITYDR').reset();
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
					provinceStore.baseParams = {
						regiondr : combo.getValue()
					};
					cityStore.baseParams = {
						provincedr : ""
					};
					CityAreaStore.baseParams = {
						citydr : ""
					};
					
				},*/
				'keyup':function(field,e) {
					Ext.getCmp('comboCTZIPProvinceDR').reset();
					Ext.getCmp('comboCTZIPCITYDR').reset();
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
					provinceStore.baseParams = {
						regiondr : field.getValue()
					};
					cityStore.baseParams = {
						provincedr : ""
					};
					CityAreaStore.baseParams = {
						citydr : ""
					};
				
				}
			}
	};

	var provinceStore=new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : CT_Province_DR_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
				totalProperty : 'total',
				root : 'data',
				successProperty : 'success'
			}, [{ name:'PROVRowId',mapping:'PROVRowId'},
			{name:'PROVDesc',mapping:'PROVDesc'},
			{name:'PROVRegionDR',mapping:'PROVRegionDR'}])
	});
	
	var comboProvince={
		xtype : 'bdpcombo',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		loadByIdParam : 'rowid',
		listWidth:250,
		fieldLabel : '<font color=red></font>省',
		hiddenName : 'CTZIPProvinceDR',
		id :'comboCTZIPProvinceDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPProvinceDR'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPProvinceDR')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPProvinceDR'),
		store : provinceStore,
		//disabled:true,//省份菜单必须依赖于区域的值,所以开始的时候设置为不可选
		mode : 'local',//必须设置为local
		queryParam : 'desc',
		forceSelection : true,
		selectOnFocus : false,
		//triggerAction : 'all',
		shadow:false,
		//hideTrigger: false,
		//typeAhead : true,
		//minChars : 1,
		//listWidth : 150,
		//editable: true,
		//allowBlank : false,
		displayField : 'PROVDesc',
		valueField : 'PROVRowId',
		listeners:{
			'keyup':function(field,e) {
					
					Ext.getCmp('comboCTZIPCITYDR').reset();
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
       	 			
       	 			cityStore.baseParams = {
						provincedr : combo.getValue()
					};
					CityAreaStore.baseParams = {
						citydr : ""
					};
					
				},
			
			'select':function(combo,record,index){
				
					Ext.getCmp('comboCTZIPCITYDR').reset();
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
       	 			
       	 			cityStore.baseParams = {
						provincedr : combo.getValue()
					};
					CityAreaStore.baseParams = {
						citydr : ""
					};
			}
			
		}	
	};
	var cityStore=new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : CT_City_DR_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
				totalProperty : 'total',
				root : 'data',
				successProperty : 'success'
			}, [{ name:'CTCITRowId',mapping:'CTCITRowId'},
				{name:'CTCITDesc',mapping:'CTCITDesc'},
				{name:'CTCITProvinceDR',mapping:'CTCITProvinceDR'}])
	});
	
	var comboCity={
		xtype : 'bdpcombo',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		loadByIdParam : 'rowid',
		listWidth:250,
		fieldLabel : '<font color=red></font>城市',
		hiddenName : 'CTZIPCITYDR',
		id :'comboCTZIPCITYDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPCITYDR'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPCITYDR')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('comboCTZIPCITYDR'),
		store : cityStore,
		mode : 'local',
		queryParam : 'desc',
		forceSelection : true,
		selectOnFocus : false,
		//triggerAction : 'all',
		shadow:false,
		//hideTrigger: false,
		//typeAhead : true,
		//minChars : 1,
		//listWidth : 150
		//editable: true,
		//allowBlank : false,
		//disabled:true,
		displayField : 'CTCITDesc',
		valueField : 'CTCITRowId',
		listeners:{
			'keyup':function(field,e) {
				
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
					CityAreaStore.baseParams = {
						citydr : combo.getValue()
					};
					
				},
			'select':function(combo,record,index){
					Ext.getCmp('comboCTZIPCITYAREADR').reset();
					CityAreaStore.baseParams = {
						citydr : combo.getValue()
					};
			}
			
		}	
	};
	var CityAreaStore=new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : CT_CityArea_DR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'CITAREARowId',mapping:'CITAREARowId'},
						{name:'CITAREADesc',mapping:'CITAREADesc'} ])
				})
	
	var comboCityArea={
			xtype : 'bdpcombo',
			pageSize : Ext.BDP.FunLib.PageSize.Combo,
			loadByIdParam : 'rowid',
			listWidth:250,
			fieldLabel : '<font color=red></font>城市区域',
			hiddenName : 'CTZIPCITYAREADR',
			id :'comboCTZIPCITYAREADR',
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTZIPCITYAREADR'),
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTZIPCITYAREADR'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTZIPCITYAREADR')),
			store : CityAreaStore,
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			//triggerAction : 'all',
			//hideTrigger: false,
			displayField : 'CITAREADesc',
			valueField : 'CITAREARowId'	
			
	}
	// 增加修改的Form
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				// collapsible : true,
				title:'基本信息',
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				URL : SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 95,
				split : true,
				frame : true,//Panel具有全部阴影,若为false则只有边框有阴影	
				defaults : {
					anchor : '100%',
					bosrder : false
				},
				waitMsgTarget : true,//这个属性决定了load和submit中对数据的处理,list必须是一个集合类型,json格式应该是[ ]包含的一个数组
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTZIPCode',mapping:'CTZIPCode'},
                                         {name: 'CTZIPDesc',mapping:'CTZIPDesc'},
                                         {name: 'CTZIPRegionDR',mapping:'CTZIPRegionDR'},
                                         {name: 'CTZIPProvinceDR',mapping:'CTZIPProvinceDR'},
                                         {name: 'CTZIPHCADR',mapping:'CTZIPHCADR'},
                                         {name: 'CTZIPCITYDR',mapping:'CTZIPCITYDR'},
                                         
                                         {name: 'CTZIPCITYAREADR',mapping:'CTZIPCITYAREADR'},
                                         {name: 'CTZIPDateFrom',mapping:'CTZIPDateFrom'},
                                         {name: 'CTZIPDateTo',mapping:'CTZIPDateTo'},
                                         {name: 'CTZIPRowId',mapping:'CTZIPRowId'}
                                        ]),
				//defaultType : 'textfield',
				items : [{
							layout:'column',
							baseCls : 'x-plain',//form透明,不显示框框
							items:[{
										columnWidth:.5,
										baseCls : 'x-plain',//form透明,不显示框框
										layout:'form',
										items:[{
													id:'CTZIPRowId',
													xtype:'textfield',
													fieldLabel : 'CTZIPRowId',
													name : 'CTZIPRowId',
													hideLabel : 'True',
													hidden : true
												},{
													fieldLabel : '<font color=red>*</font>代码',
													xtype:'textfield',
													id:'CTZIPCode',
													maxLength:15,
													width:150,
													//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTZIPCode'),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTZIPCode'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTZIPCode')),
													name : 'CTZIPCode',
													allowBlank:false
													/*validationEvent : 'blur',  
													enableKeyEvents:true, 
                            						validator : function(thisText){
                            							//Ext.Msg.alert(thisText);
	                            						if(thisText==""){	//当文本框里的内容为空的时候不用此验证
	                            							return true;
	                         						   }
	                         						   var className =  "web.DHCBL.CT.CTZip";	//后台类名称
	                         						   var classMethod = "FormValidate";	//数据重复验证后台函数名	                            
	                          						   var id="";
	                          						   if(win.title=='修改'){	//如果窗口标题为'修改'则获取rowid
	                           						 	var _record = grid.getSelectionModel().getSelected();
	                           						 	var id = _record.get('CTZIPRowId');	//此条数据的rowid
	                           						   }
	                          						   var flag = "";
	                           						   var flag = tkMakeServerCall(className,classMethod,id,thisText,"");	//用tkMakeServerCall函数实现与后台同步调用交互
	                            						//Ext.Msg.alert(flag);
	                           						   if(flag == "1"){	//当后台返回数据位"1"时转换为相应的布尔值
	                           						  	return false;
	                           						   }else{
	                           						  	return true;
	                           						   }
                           						 },
                           						 invalidText : '该代码已经存在',
						   						 listeners : {
						   						 	'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						   						 }*/
												}, {
													fieldLabel : '<font color=red>*</font>描述',
													xtype:'textfield',
													id:'CTZIPDesc',
													maxLength:220,
													width:150,
													//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTZIPDesc'),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTZIPDesc'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTZIPDesc')),
													name : 'CTZIPDesc',
													allowBlank:false
													/*validationEvent : 'blur',
													enableKeyEvents:true, 
                           						 	validator : function(thisText){
                           						 		//Ext.Msg.alert(thisText);
	                            						if(thisText==""){	//当文本框里的内容为空的时候不用此验证
	                          						  	return true;
	                         						   }
	                         						   var className =  "web.DHCBL.CT.CTZip";	//后台类名称
	                          						  var classMethod = "FormValidate";	//数据重复验证后台函数名
	                          						  var id="";
	                          						  if(win.title=='修改'){		//如果窗口标题为'修改'则获取rowid
	                          						  	var _record = grid.getSelectionModel().getSelected();
	                          						  	var id = _record.get('CTZIPRowId');	//此条数据的rowid
	                        						    }
	                         						   var flag = "";
	                          						  var flag = tkMakeServerCall(className,classMethod,id,"",thisText);	//用tkMakeServerCall函数实现与后台同步调用交互
	                         						   //Ext.Msg.alert(flag);
	                          						  if(flag == "1"){	//当后台返回数据位"1"时转换为相应的布尔值
	                          						   	return false;
	                          						   }else{
	                          						   	return true;
	                         						    }
                           						 },
                           						 invalidText : '该描述已经存在',
						   						 listeners : {
						   						 	'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						   						 }*/
												},{
													xtype : 'datefield',
													fieldLabel : '<font color=red>*</font>开始日期',
													name : 'CTZIPDateFrom',
													format : BDPDateFormat,
													id:'date1',
													//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
													vtype:'cKDate',
													width:150,
													enableKeyEvents : true,
													listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
													allowBlank:false
												},{
													xtype : 'datefield',
													fieldLabel : '结束日期',
													name : 'CTZIPDateTo',
													format : BDPDateFormat,
													id:'date2',
													//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
													width:150,
													enableKeyEvents : true,
													listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
													vtype:'cKDate'
												}]
								},{
										columnWidth:.48,
										layout:'form',
										baseCls : 'x-plain',//form透明,不显示框框
										///style:'margin-left:20px',
										items:[comboRegion, comboProvince, comboCity, 
											comboCityArea,{
													xtype : 'bdpcombo',
													pageSize : Ext.BDP.FunLib.PageSize.Combo,
													loadByIdParam : 'rowid',
													listWidth:250,
													fieldLabel : '<font color=red></font>健康监护区域',
													hiddenName : 'CTZIPHCADR',
													//id :'CTZIPHCADR',
													//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTZIPHCADR'),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTZIPHCADR'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTZIPHCADR')),
													store : new Ext.data.Store({
																autoLoad: true,
																proxy : new Ext.data.HttpProxy({ url : CT_HealthCareArea_DR_QUERY_ACTION_URL }),
																reader : new Ext.data.JsonReader({
																totalProperty : 'total',
																root : 'data',
																successProperty : 'success'
															}, [{ name:'HCARowId',mapping:'HCARowId'},
																{name:'HCADesc',mapping:'HCADesc'} ])
														}),
													mode : 'local',
													shadow:false,
													forceSelection : true,
													//triggerAction : 'all',
													//hideTrigger: false,
													displayField : 'HCADesc',
													valueField : 'HCARowId'
											}]
							}]	
				}]	
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
		width : 680,
		height: 330,
		minWidth:650,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
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
				var flag = tkMakeServerCall("web.DHCBL.CT.CTZip","FormValidate",Ext.getCmp("CTZIPRowId").getValue(),Ext.getCmp("CTZIPCode").getValue(),Ext.getCmp("CTZIPDesc").getValue())
    			if(flag == "1"){
                 	Ext.Msg.show({ title : '提示', msg : '该代码和描述已经存在!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                 	return;
                } 
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				//-------添加----------	
				if (win.title == "添加") {//WinForm.form.isValid()
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
				Ext.getCmp("form-save").getForm().findField("CTZIPCode").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾
				WinForm.getForm().reset();
				/*regionStore.load();
				provinceStore.proxy= new Ext.data.HttpProxy({url: CT_Province_DR_QUERY_ACTION_URL+'&regiondr=""' });  
				provinceStore.load(); 
				cityStore.proxy= new Ext.data.HttpProxy({url: CT_City_DR_QUERY_ACTION_URL+'&provincedr=""' });  
				cityStore.load();  
        		CityAreaStore.proxy= new Ext.data.HttpProxy({url: CT_CityArea_DR_QUERY_ACTION_URL+'&citydr=""'});  
				CityAreaStore.load(); */
				
				
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
					
					regionStore.baseParams = {}; 
					provinceStore.baseParams = {}; 
					cityStore.baseParams = {}; 
					CityAreaStore.baseParams = {}; 
					 
			
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
			            AliasGrid.DataRefer = _record.get('CTZIPRowId');
				        AliasGrid.loadGrid();
				        
						//var record = grid.getSelectionModel().getSelected();//获取当前行的记录
						//Ext.getCmp("form-save").getForm().loadRecord(record);//通过form的id调用form,并加载当前行的数据到form
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
								name : 'CTZIPRowId',
								mapping : 'CTZIPRowId',
								type : 'number'
							}, {
								name : 'CTZIPCode',
								mapping : 'CTZIPCode',
								type : 'string'
							}, {
								name : 'CTZIPDesc',
								mapping : 'CTZIPDesc',
								type : 'string'
							}, {
								name : 'CTZIPRegionDR',
								mapping : 'CTZIPRegionDR',
								type : 'string'
							}, {
								name : 'CTZIPProvinceDR',
								mapping : 'CTZIPProvinceDR',
								type : 'string'
							}, {
								name : 'CTZIPHCADR',
								mapping : 'CTZIPHCADR',
								type : 'string'
							}, {
								name : 'CTZIPCITYDR',
								mapping : 'CTZIPCITYDR',
								type : 'string'
							}, {
								name : 'CTZIPRegionDR1',
								mapping : 'CTZIPRegionDR1',
								type : 'string'
							}, {
								name : 'CTZIPProvinceDR1',
								mapping : 'CTZIPProvinceDR1',
								type : 'string'
							
							}, {
								name : 'CTZIPCITYDR1',
								mapping : 'CTZIPCITYDR1',
								type : 'string'
							}, {
								name : 'CTZIPCITYAREADR',
								mapping : 'CTZIPCITYAREADR',
								type : 'string'
							},{
								name : 'CTZIPDateFrom',
								mapping : 'CTZIPDateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'CTZIPDateTo',
								mapping : 'CTZIPDateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
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
				//sortInfo: {field : "CTZIPRowId",direction : "ASC"}
	});
	//ds.sort("CTZIPCode","DESC");
	 Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);		
 	// 加载数据
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
					//加载完成后执行的回调函数
					//参数records表示获得的数据, options表示执行load时传递的参数,success表示是否加载成功
					//alert(options);
					//Ext.Msg.alert('info', '加载完毕, success = '+ records.length);
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
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条', //{0}表示数字占位符，会按照设置的值而变化
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
				handler : function() {	//执行回调函数
				//翻译
				Ext.BDP.FunLib.SelectRowId="";
				
				grid.getStore().baseParams={	//模糊查询		
						code : Ext.getCmp("TextCode").getValue(),
						
						desc : Ext.getCmp("TextDesc").getValue()
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
				//autoWidth:true,
				items : ['代码', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},'-',
						'描述', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-',
						LookUpConfigureBtn,'-',
						btnSearch,'-', 
						btnRefresh ,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar);
					}
				}
	});
	var GridCM=[sm, {
							header : 'CTZIPRowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTZIPRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CTZIPCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPDesc'
						}, {
							header : '区域',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPRegionDR'
							
						}, {
							header : '省',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPProvinceDR'						
						}, {
							header : '城市',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPCITYDR'
						}, {
							header : '区域ID',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPRegionDR1',
							hidden : true
							
						}, {
							header : '省ID',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPProvinceDR1',
							hidden : true						
						}, {
							header : '城市ID',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPCITYDR1'	,
							hidden : true		
						}, {
							header : '城市区域',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPCITYAREADR'
						}, {
							header : '健康监护区域',
							width : 100,
							sortable : true,
							dataIndex : 'CTZIPHCADR'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTZIPDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTZIPDateTo'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '邮编',
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
        var _record = grid.getSelectionModel().getSelected();//获取当前行的记录
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
        
			provinceStore.baseParams = {
						regiondr : _record.get('CTZIPRegionDR1')
					};
            cityStore.baseParams = {
						provincedr : _record.get('CTZIPProvinceDR1')
					};
            
            CityAreaStore.baseParams = {
						citydr : _record.get('CTZIPCITYDR1')
					};
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTZIPRowId'),//id对应OPEN里的入参
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
					
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
           
            
        }
    };
   
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('CTZIPRowId');
	        AliasGrid.loadGrid();
			
    });
    //翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('CTZIPRowId');	           
		 	} else {
		 		var selectrow="";
			 }
				Ext.BDP.FunLib.SelectRowId = selectrow;	

			})

 	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
    
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : grid
	});

});