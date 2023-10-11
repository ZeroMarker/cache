/**@author基础数据平台公共产品组 谷雪萍**/
/**@argument：医疗机构**/
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTRefClin&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTRefClin&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTRefClin";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTRefClin&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTRefClin&pClassMethod=OpenData";
	/// 市
	var CITY_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetDataForCmb1";
	/// 区
    var CITYAREA_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassQuery=GetDataForCmb1"; 
    /// 组织机构
    var HOSOrganization_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSOrganization&pClassQuery=GetDataForCmb1";
	/// 所有制形式
    var HOSHORGOwnerShip_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSHORGOwnerShip&pClassQuery=GetDataForCmb1";
	/// 医院等级代码
    var HOSHORGGrade_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSHORGGrade&pClassQuery=GetDataForCmb1";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var combopage=Ext.BDP.FunLib.PageSize.Combo;
	/************************************键盘事件，按键弹出添加窗口***********************************/

  		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="CT_RefClin"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTRefClin";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
    
  //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_RefClin"
	});
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
       RowID=rows[0].get('CTRFCRowId');
       Desc=rows[0].get('CTRFCDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	/**-----------------------删除功能-------------------------**/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						AliasGrid.DataRefer = rows[0].get('CTRFCRowId');
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('CTRFCRowId')
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
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br />错误信息:' + jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '删除失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接!',
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
							msg : '请选择需要删除的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});

/************************************增加修改的Form************************************/
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
				labelWidth : 150,
				split : true,
				frame : true,//Panel具有全部阴影,若为false则只有边框有阴影	
				defaults : {
					anchor : '100%',
					bosrder : false
				},
				waitMsgTarget : true,//这个属性决定了load和submit中对数据的处理,list必须是一个集合类型,json格式应该是[ ]包含的一个数组
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTRFCCode',mapping:'CTRFCCode'},
                                         {name: 'CTRFCDesc',mapping:'CTRFCDesc'},
                                         {name: 'CTRFCActiveFlag',mapping:'CTRFCActiveFlag'},
                                         //{name: 'CTRFCVEMD',mapping:'CTRFCVEMD'},
                                         {name: 'CTRFCDateFrom',mapping:'CTRFCDateFrom'},
                                         {name: 'CTRFCDateTo',mapping:'CTRFCDateTo'},
										 {name: 'CTRFCCategoryCode',mapping:'CTRFCCategoryCode',type:'string'},
										 {name:'CTRFCLevel',mapping:'CTRFCLevel',type:'string'},
										 {name: 'CTRFCCityDR',mapping:'CTRFCCityDR',type:'string'}, 
										 {name:'CTRFCCityAreaDR',mapping:'CTRFCCityAreaDR',type:'string'},
										 {name:'CTRFCAddress',mapping:'CTRFCAddress',type:'string'},
										 {name:'CTRFCPersonName',mapping:'CTRFCPersonName',type:'string'},
										 {name:'CTRFCSociaCreditCode',mapping:'CTRFCSociaCreditCode',type:'string'},
                                         {name:'CTRFCORGCode',mapping:'CTRFCORGCode',type:'string'},
                                         {name:'CTRFCBusinessClicenseCode',mapping:'CTRFCBusinessClicenseCode',type:'string'},
                                         {name:'CTRFCBusinessClicenseFrom',mapping:'CTRFCBusinessClicenseFrom',type:'string'},
                                         {name:'CTRFCBusinessClicenseTo',mapping:'CTRFCBusinessClicenseTo',type:'string'},
                                         //{name:'CTRFCOSCode',mapping:'CTRFCOSCode',type:'string'},
                                         {name:'CTRFCBedsNum',mapping:'CTRFCBedsNum',type:'string'},
                                         {name:'CTRFCGradeCode',mapping:'CTRFCGradeCode',type:'string'},
                                         {name:'CTRFCChargeStandard',mapping:'CTRFCChargeStandard',type:'string'},
                                         {name:'CTRFCInsuCode',mapping:'CTRFCInsuCode',type:'string'},
                                         {name:'CTRFCSeqNo',mapping:'CTRFCSeqNo',type:'string'},
                                         {name:'CTRFCPYCode',mapping:'CTRFCPYCode',type:'string'},
                                         {name:'CTRFCWBCode',mapping:'CTRFCWBCode',type:'string'},
                                         {name:'CTRFCMark',mapping:'CTRFCMark',type:'string'},
                                         {name: 'CTRFCRowId',mapping:'CTRFCRowId'}
                                        ]),
				//defaultType : 'textfield',
				items : [{
							layout:'column',
							baseCls : 'x-plain',//form透明,不显示框框
							defaults : {
								width : 190,
								bosrder : false   
							},
							items:[{
										columnWidth:.5,
										baseCls : 'x-plain',//form透明,不显示框框
										layout:'form',
										items:[{
											xtype : 'textfield',
											fieldLabel : 'CTRFCRowId',
											hideLabel : 'True',
											hidden : true,
											name : 'CTRFCRowId'
										}, {
											xtype : 'textfield',
											fieldLabel : '<font color=red>*</font>代码',
											allowBlank:false,
										 	blankText: '代码不能为空',
											name : 'CTRFCCode',
											id:'CTRFCCodeF',	
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCodeF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCodeF'),
											enableKeyEvents : true,
											validationEvent : 'blur',  
				                            validator : function(thisText){
					                          if(thisText==""){  //当文本框里的内容为空的时候不用此验证
					                          return true;
					                          }
					                            var className =  "web.DHCBL.CT.CTRefClin";   
					                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
					                            var id="";
					                            if(win.title=='修改'){  
					                            	var _record = grid.getSelectionModel().getSelected();
					                            	var id = _record.get('CTRFCRowId');  
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
											
											 
										}, {
											xtype : 'textfield',
											fieldLabel : '<font color=red>*</font>描述',
											allowBlank:false,
											blankText: '描述不能为空',
											name : 'CTRFCDesc',
											id:'CTRFCDescF',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCDescF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCDescF'),
											enableKeyEvents : true,
											validationEvent : 'blur',
				                            validator : function(thisText){
					                            if(thisText==""){  
					                            	return true;
					                            }
					                            var className =  "web.DHCBL.CT.CTRefClin"; //后台类名称
					                            var classMethod = "FormValidate"; //数据重复验证后台函数名
					                            var id="";
					                            if(win.title=='修改'){ 
					                            	var _record = grid.getSelectionModel().getSelected();
					                            	var id = _record.get('CTRFCRowId');  
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
				            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
				            			        'blur' : function(){
										    		//失焦自动填写拼音码和五笔码
									        		var Desc=Ext.getCmp("CTRFCDescF").getValue()
									        		if (Desc!="")
									        		{
									        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
												        var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
												        Ext.getCmp("CTRFCPYCode").setValue(PYCode)  
												        Ext.getCmp("CTRFCWBCode").setValue(WBCode)
									        		}
										    	}
										    }
										},{ 		
											xtype : 'textfield',
											fieldLabel : '<font color=red>*</font>法定代表人',
											name :'CTRFCPersonName',
											id:'CTRFCPersonNameF',
											allowBlank:false,
											blankText: '法定代表人不能为空',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonNameF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonNameF') 
									    },{ 	
									    	xtype : 'textfield',
											fieldLabel : '<font color=red>*</font>统一社会信用代码',
											name :'CTRFCSociaCreditCode',
											id:'CTRFCSociaCreditCodeF',
											allowBlank:false,
											blankText: '统一社会信用代码不能为空',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCSociaCreditCodeF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCSociaCreditCodeF') 
									    },{ 	
									    	xtype : 'textfield',
											fieldLabel : '类别编码',
											name :'CTRFCCategoryCode',
											id:'CTRFCCategoryCodeF',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCategoryCodeF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCategoryCodeF') 
									    },{ 	
									    	xtype : 'textfield',
											fieldLabel : '级别',
											name :'CTRFCLevel',
											id:'CTRFCLevelF',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCLevelF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCLevelF') 
										} ,{
											xtype:'bdpcombo',
											fieldLabel : '市',
											id:'CTRFCCityDRF',
											width:160,
											hiddenName : 'CTRFCCityDR',
				  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCityDRF'),
											style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCityDRF')) ,
									        loadByIdParam:'rowid',
									        store : new Ext.data.Store({
									         	proxy : new Ext.data.HttpProxy({ url : CITY_QUERY_ACTION }),
									         	reader : new Ext.data.JsonReader({
									          	totalProperty : 'total',
									          	root : 'data',
									          	successProperty : 'success'
									         }, [ 'CTCITRowId', 'CTCITDesc' ])
									       }),
										     queryParam : 'desc',
										     triggerAction : 'all',
										     forceSelection : true,
										     selectOnFocus : false,
										     minChars : 0,
										     listWidth : 250,
										     valueField : 'CTCITRowId',
										     displayField : 'CTCITDesc',
										     pageSize :combopage 
										},{
											xtype:'bdpcombo',
				                            fieldLabel : '县/区',
				                            id:'CTRFCCityAreaDRF',
				                            width:160,
				                            hiddenName : 'CTRFCCityAreaDR',
				                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCityAreaDRF'),
				                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCityAreaDRF')) ,
				                            loadByIdParam:'rowid',
				                            store : new Ext.data.Store({
					                                proxy : new Ext.data.HttpProxy({ url : CITYAREA_QUERY_ACTION }),
					                                reader : new Ext.data.JsonReader({
					                                totalProperty : 'total',
					                                root : 'data',
					                                successProperty : 'success'
					                             }, [ 'CITAREARowId', 'CITAREADesc'])
				                           	 }),
				                             queryParam : 'desc',
				                             triggerAction : 'all',
				                             forceSelection : true,
				                             selectOnFocus : false,
				                             minChars : 0,
				                             listWidth : 250,
				                             valueField : 'CITAREARowId',
				                             displayField : 'CITAREADesc',
				                             pageSize :combopage,
									         listeners:{
									             'beforequery':function(obj){
									                if (Ext.getCmp("CTRFCCityDRF").getValue()=="")
									                {
									                    return false;
									                }
									                else{
									                     obj.combo.store.baseParams = {
									                            start:0,
									                            limit:combopage,
									                            desc:obj.combo.getRawValue(),
									                            citydr:Ext.getCmp("CTRFCCityDRF").getValue()
									                        };
									                    obj.combo.store.load();
									                }
									            }
									        }
										},{
											xtype : 'textfield',
											fieldLabel : '医疗机构地址',
											name :'CTRFCAddress',
											id:'CTRFCAddressF',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCAddressF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCAddressF') 
									    } ,{
											xtype : 'datefield',
											fieldLabel : '<font color=red>*</font>开始日期',
											name :'CTRFCDateFrom',
											id:'CTRFCDateFromF',
											width:160,
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCDateFromF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCDateFromF'),
											allowBlank:false,
											blankText: '开始日期不能为空',
											format : BDPDateFormat,
											enableKeyEvents : true,
											listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
										}, {
											xtype : 'datefield',
											fieldLabel : '结束日期',
											name : 'CTRFCDateTo',
											id:'CTRFCDateToF',
											width:160,
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCDateToF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCDateToF'),
											format : BDPDateFormat,
											enableKeyEvents : true,
											listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
										},{ 							 
											fieldLabel : '是否可用',
											name :'CTRFCActiveFlag',
											id:'CTRFCActiveFlagF',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCActiveFlagF')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCActiveFlagF'),
											xtype:'checkbox',
											checked:true,
											inputValue : true?'Y':'N'
										}]
								},{
										columnWidth:.45,
										layout:'form',
										baseCls : 'x-plain',//form透明,不显示框框
										///style:'margin-left:20px',
										items:[{
													xtype:'bdpcombo',
													allowBlank:false,
													blankText: '组织机构不能为空',
													hiddenName:'CTRFCORGCode',
													fieldLabel : '<font color=red>*</font>组织机构',
													id:'CTRFCORGCodeF',
													width:160,
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCORGCodeF'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCORGCodeF')) ,
											        loadByIdParam:'rowid',
											        store : new Ext.data.Store({
											         	proxy : new Ext.data.HttpProxy({ url : HOSOrganization_QUERY_ACTION }),
											         	reader : new Ext.data.JsonReader({
											          	totalProperty : 'total',
											          	root : 'data',
											          	successProperty : 'success'
											         }, [ 'ID', 'ORGDesc' ])
											       }),
												     queryParam : 'desc',
												     //triggerAction : 'all',
												     forceSelection : true,
												     selectOnFocus : false,
												     //minChars : 0,
												     listWidth : 250,
												     valueField : 'ID',
												     displayField : 'ORGDesc',
												     pageSize :combopage 
												}/*, {	
													xtype:'bdpcombo',
													fieldLabel : '所有制形式',
													id:'CTRFCOSCodeF',
													hiddenName : 'CTRFCOSCode',
													width:160,
						  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCOSCodeF'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCOSCodeF')) ,
											        loadByIdParam:'rowid',
											        store : new Ext.data.Store({
											         	proxy : new Ext.data.HttpProxy({ url : HOSHORGOwnerShip_QUERY_ACTION }),
											         	reader : new Ext.data.JsonReader({
											          	totalProperty : 'total',
											          	root : 'data',
											          	successProperty : 'success'
											         }, [ 'ID', 'HORGOSDesc' ])
											         }),
												     queryParam : 'desc',
												     //triggerAction : 'all',
												     forceSelection : true,
												     selectOnFocus : false,
												     //minChars : 0,
												     listWidth : 250,
												     valueField : 'ID',
												     displayField : 'HORGOSDesc',
												     pageSize :combopage 
												 }*/, {	
													xtype:'bdpcombo',
													fieldLabel : '医院等级代码',
													id:'CTRFCGradeCodeF',
													width:160,
													hiddenName : 'CTRFCGradeCode',
						  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCGradeCodeF'),
													style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCGradeCodeF')) ,
											        loadByIdParam:'rowid',
											        store : new Ext.data.Store({
											         	proxy : new Ext.data.HttpProxy({ url : HOSHORGGrade_QUERY_ACTION }),
											         	reader : new Ext.data.JsonReader({
											          	totalProperty : 'total',
											          	root : 'data',
											          	successProperty : 'success'
											         }, [ 'ID', 'HORGGCDesc' ])
											         }),
												     queryParam : 'desc',
												     //triggerAction : 'all',
												     forceSelection : true,
												     selectOnFocus : false,
												     //minChars : 0,
												     listWidth : 250,
												     valueField : 'ID',
												     displayField : 'HORGGCDesc',
												     pageSize :combopage 
												
												}, {
													xtype: 'textfield',
													fieldLabel : '医疗机构执业许可证号',
													name : 'CTRFCBusinessClicenseCode',
													id:'CTRFCBusinessClicenseCode',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessClicenseCode'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessClicenseCode'))
												} ,{
													xtype : 'datefield',
													fieldLabel : '许可证效期开始日期',
													name :'CTRFCBusinessClicenseFrom',
													id:'CTRFCBusinessClicenseFrom',
													width:160,
													style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessClicenseFrom')),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessClicenseFrom'),
													format : BDPDateFormat,
													enableKeyEvents : true,
													listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
												}, {
													xtype : 'datefield',
													fieldLabel : '许可证效期结束日期',
													name : 'CTRFCBusinessClicenseTo',
													id:'CTRFCBusinessClicenseTo',
													width:160,
													style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessClicenseTo')),
													readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessClicenseTo'),
													format : BDPDateFormat,
													enableKeyEvents : true,
													listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
												
												}, {
													xtype: 'numberfield',
													fieldLabel : '编制床位数',
													name : 'CTRFCBedsNum',
													id:'CTRFCBedsNum',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBedsNum'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBedsNum'))
						   						}, {
													xtype: 'textfield',
													fieldLabel : '医院物价标准',
													name : 'CTRFCChargeStandard',
													id:'CTRFCChargeStandard',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCChargeStandard'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCChargeStandard'))
												
												}, {
													xtype: 'textfield',
													fieldLabel : '医院医保代码',
													name : 'CTRFCInsuCode',
													id:'CTRFCInsuCode',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCInsuCode'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCInsuCode'))
												
												}, {
													xtype: 'numberfield',
													fieldLabel : '排序号',
													name : 'CTRFCSeqNo',
													id:'CTRFCSeqNo',
													minValue : 0,
													allowNegative : false,//不允许输入负数
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCSeqNo'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCSeqNo'))
												
												}, {
													xtype: 'textfield',
													fieldLabel : '拼音码',
													name : 'CTRFCPYCode',
													id:'CTRFCPYCode',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCPYCode'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCPYCode'))
						   						}, {
													xtype: 'textfield',
													fieldLabel : '五笔码',
													name : 'CTRFCWBCode',
													id:'CTRFCWBCode',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCWBCode'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCWBCode'))
												},{
													xtype: 'textfield',
													fieldLabel : '备注',
													name : 'CTRFCMark',
													id:'CTRFCMark',
						   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCMark'),
						   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCMark'))
											}]
							}]	
				}]	
	});
	
	var tabs = new Ext.TabPanel({
		 activeTab : 0,
		 frame : true,
		 border : false,
		 height : 350,
		 items : [WinForm, AliasGrid]
	 });
	 
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		title : '',
		width : 850,
		height : 560,
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
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("CTRFCCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("CTRFCDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("CTRFCDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("CTRFCDateTo").getValue();
			if (tempCode=="") {
				Ext.Msg.show({ title : '提示', msg : '代码不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({ title : '提示', msg : '描述不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
    					title : '提示',
						msg : '开始日期不能大于结束日期！',
						minWidth : 200,
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
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
													grid.getStore().load({
														params : {
															start : 0,
															limit : 1,
															rowid : myrowid
														}
													});
											}
								});
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								//保存别名
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败!' + errorMsg,
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
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后',
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									//保存别名
									AliasGrid.saveAlias();
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+ action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid);
												
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}

								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败');
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
			
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
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
					//激活基本信息面板
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
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						loadFormData(grid);
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
						var record = grid.getSelectionModel().getSelected();// records[0]
	            		AliasGrid.DataRefer = record.get('CTRFCRowId');
		        		AliasGrid.loadGrid();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				}
			});
			
   var winExtend; 
   var btnRefClinExtend = new Ext.Toolbar.Button({
        text: '医疗机构扩展信息',
        tooltip: '医疗机构扩展信息',
        iconCls: 'icon-DP',
        id:'btnRefClinExtend',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefClinExtend'),
        handler: function() {                   
            if(!grid.selModel.hasSelection()){
                Ext.Msg.show({
                    title:'提示',
                    minWidth:200,
                    msg:'请选择一条数据!',
                    icon:Ext.Msg.WARNING,
                    buttons:Ext.Msg.OK
                }); 
                return false;
            }else{
                winExtend= new Ext.Window({
                    iconCls : 'icon-DP',
                    width : 1000,
                    height : Math.min(Ext.getBody().getViewSize().height-30,500),
                    layout : 'fit',
                    plain : true,// true则主体背景透明
                    modal : true,
                    frame : true,
                    autoScroll : false, 
                    hideCollapseTool : true, 
                    constrain : true,
                    closeAction : 'hide',
                    listeners : {
                        "show" : function() {
                             
                        },
                        "hide" : function() { 
                         
                        },
                        "close" : function() {
                        }
                    }
                });
                var gsm = grid.getSelectionModel();// 获取选择列
                var rows = gsm.getSelections();// 根据选择列获取到所有的行
                var itemRowId=rows[0].get('CTRFCRowId')
                var itemdesc=rows[0].get('CTRFCDesc')
                var link="dhc.bdp.ext.default.csp?extfilename=App/Locations/CT_RefClinExtend&selectrow="+itemRowId; 
                if ("undefined"!==typeof websys_getMWToken){
					link += "&MWToken="+websys_getMWToken()
				}
                winExtend.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';
                winExtend.setTitle(itemdesc+"-医疗机构扩展信息"); 
                winExtend.show(); 
            }
        }
    });  
    HideParentWin=function(){
        winExtend.hide();
    } 
/************************************数据存储***********************************/
	var fields=[{     
						            name : 'CTRFCRowId',
									mapping :'CTRFCRowId',
									type : 'string'
								}, {
									name : 'CTRFCCode',
									mapping : 'CTRFCCode',
									type : 'string'
								}, {
									name : 'CTRFCDesc',
									mapping :'CTRFCDesc',
									type:'string'
								},{
									name:'CTRFCActiveFlag',
									mapping:'CTRFCActiveFlag',
									inputValue : true?'Y':'N'
								},/* {
									name : 'CTRFCVEMD',
									mapping :'CTRFCVEMD',
									type:'string'  
								},*/{
									name:'CTRFCDateFrom',
									mapping:'CTRFCDateFrom',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name :'CTRFCDateTo',
									mapping :'CTRFCDateTo',
									type : 'date',
									dateFormat : 'm/d/Y'
								} , {
									name : 'CTRFCCategoryCode',
									mapping : 'CTRFCCategoryCode',
									type : 'string'
								}, {
									name : 'CTRFCLevel',
									mapping :'CTRFCLevel',
									type:'string'
								},{
									name:'CTRFCCityDR',
									mapping:'CTRFCCityDR',
									type:'string'
								},{
									name:'CTRFCCityAreaDR',
									mapping:'CTRFCCityAreaDR',
									type:'string'
								},{
									name:'CTRFCAddress',
									mapping:'CTRFCAddress',
									type:'string'
								},{
									name:'CTRFCPersonName',
									mapping:'CTRFCPersonName',
									type:'string'
								},{
									name:'CTRFCSociaCreditCode',
									mapping:'CTRFCSociaCreditCode',
									type:'string'
								},{
									name:'CTRFCSeqNo',
									mapping:'CTRFCSeqNo',
									type:'string'
								}
						]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
									
						}, fields),
				remoteSort : true
			});	
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/************************************数据加载************************************/

	ds.load({
				params : {
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {
				}
			}); // 加载数据
/************************************数据分页************************************/
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize=this.pageSize;
				         }
		        }
			})

/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-' ,btnRefClinExtend , '-' ,btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		})
 
/************************************搜索工具条************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {
				grid.getStore().baseParams={			
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
/************************************刷新工作条************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function refresh() { 
					Ext.BDP.FunLib.SelectRowId =""; //翻译 
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
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},
						// '-',
						'描述', {
							xtype : 'textfield',
							id : 'TextDesc',
							emptyText : '描述/别名',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}
						,'-',LookUpConfigureBtn
					  ,'-', btnSearch, '-', btnRefresh, '->'
				// btnHelp
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	 /************************************创建表格************************************/
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header :'CTRFCRowId',
							width : 60,
							sortable : true,
						    hidden:true,
							dataIndex : 'CTRFCRowId'
					  }, {
							header : '代码',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCCode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCDesc'
						}, {
							header : '法定代表人',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCPersonName'
						}, {
							header : '统一社会信用代码',
							width : 150,
							sortable : true,
							dataIndex : 'CTRFCSociaCreditCode'
						},{
							header : '是否可用',
							width : 80,
							sortable : true,
							dataIndex : 'CTRFCActiveFlag',
							 renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						}, /*{
							header : 'VEMD',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCVEMD' 
						},*/
						 {
							header : '类别编码',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCCategoryCode'
						}, {
							header : '级别',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCLevel'
						}, {
							header : '行政区划(市)',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCCityDR'
						}, {
							header : '行政区划(县)',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCCityAreaDR'
						}, {
							header : '医疗机构地址',
							width : 120,
							sortable : true,
							dataIndex : 'CTRFCAddress'
						},{
							header : '开始日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'CTRFCDateFrom'
						}, {
							header : '结束日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTRFCDateTo'
						}, {
							header : '排序号',
							width : 80,
							sortable : true,
							dataIndex : 'CTRFCSeqNo'
						}]		
			
	
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				disabled:Ext.BDP.FunLib.Component.DisableFlag('grid'),
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns : GridCM,
				stripeRows : true, 
				title : '医疗机构维护',
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
			//保留用户习惯
	//	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
/************************************双击事件************************************/
	  	var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            //Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        	WinForm.form.load({
	                url : OPEN_ACTION_URL + '&id='+ _record.get('CTRFCRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	                	//Ext.Msg.alert('编辑','载入成功！');
	                },
	                failure : function(form,action) {
	                	Ext.Msg.alert('编辑','载入失败！');
	                }
	            });
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {	    	
			   //	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show();
	        	loadFormData(grid);
	        	
	        	//激活基本信息面板
            	tabs.setActiveTab(0);
             	//加载别名面板
	        	var record = grid.getSelectionModel().getSelected();// records[0]
				//加载别名面板
	            AliasGrid.DataRefer = record.get('CTRFCRowId');
		        AliasGrid.loadGrid();
	    });	
	    
	    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('CTRFCRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
});
