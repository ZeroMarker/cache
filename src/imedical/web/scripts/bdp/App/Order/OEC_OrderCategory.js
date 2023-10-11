/// 名称: 医嘱与结果 2.医嘱大类维护 
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2012-8-31
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	var OCGRP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategoryGroup&pClassQuery=GetDataForCmb1";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.OECOrderCategory";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassMethod=DeleteData";
	
	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var CTLOC_Group_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmbGroup";  //返回本组的科室
	var HOSP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var Priority_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
	var CHILD_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrdCatRecLoc&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.OECOrdCatRecLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.OECOrdCatRecLoc';
	var CHILD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.OECOrdCatRecLoc&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.OECOrdCatRecLoc&pClassMethod=DeleteData';

	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "OEC_OrderCategory"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.OECOrderCategory";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="OEC_OrderCategory"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	/////////////////////////////日志查看 ////////////////////////////////////////
	var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
    var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu) 
	//var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
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
	if (btnhislogflag ==1)
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
			RowID=rows[0].get('ORCATRowId');
			Desc=rows[0].get('ORCATDesc');
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
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
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
				var rowid=grid.getSelectionModel().getSelections()[0].get("ORCATRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
	
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('ORCATRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ORCATRowId')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败!' + errorMsg,
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
	
	/** 接收科室删除按钮 */
	var child_btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn'),
		handler :DelData2= function() {
			if (child_grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : CHILD_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('RLRowId')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.DelForTruePage(child_grid,pagesize_pop);
												
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败!' + errorMsg,
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
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 80,
				title : '基本信息',
				frame : true,
				autoScroll : true, //滚动条
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ORCATRowId',mapping:'ORCATRowId',type:'string'},
                                         {name: 'ORCATCode',mapping:'ORCATCode',type:'string'},
                                         {name: 'ORCATDesc',mapping:'ORCATDesc',type:'string'},
                                         {name: 'ORCATRepeatInOrder',mapping:'ORCATRepeatInOrder',type:'string'},
                                         {name: 'ORCATOCGroupDR',mapping:'ORCATOCGroupDR',type:'string'}
                                   ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ORCATRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ORCATRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'ORCATCode',
							id:'ORCATCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ORCATCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ORCATCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.OECOrderCategory";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ORCATRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互  //多院区医院
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
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
							fieldLabel : '<font color=red>*</font>描述',
							name : 'ORCATDesc',
							id:'ORCATDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ORCATDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ORCATDescF')),
							allowBlank : false,
							validationEvent : 'blur',
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.OECOrderCategory"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ORCATRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互  //多院区医院
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							
							fieldLabel : '医嘱类组',
							name : 'ORCATOCGroupDR',
							hiddenName : 'ORCATOCGroupDR',
							id:'ORCATOCGroupDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ORCATOCGroupDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ORCATOCGroupDRF')),
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : OCGRP_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'OCGRPRowId', 'OCGRPDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'OCGRPRowId',
							displayField : 'OCGRPDesc'
						}, {
							xtype : 'checkbox',
							fieldLabel : '重复医嘱',
							name : 'ORCATRepeatInOrder',
							id:'ORCATRepeatInOrderF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ORCATRepeatInOrderF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ORCATRepeatInOrderF')),
							inputValue : 'Y'
						}]
			});
	
	/** 接收科室增加\修改的Form */
	var child_WinForm = new Ext.form.FormPanel({
				id : 'child-form-save',
				labelAlign : 'right',
				autoScroll:true,////要加在FormPanel里，加在window里不出现滚动条
				labelWidth : 90,
				frame : true, ///baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'RLRowId',mapping:'RLRowId',type:'string'},
                                         {name: 'RLRecLocDR',mapping:'RLRecLocDR',type:'string'},
                                         {name: 'RLOrdLocDR',mapping:'RLOrdLocDR',type:'string'},
                                         {name: 'RLFunction',mapping:'RLFunction',type:'string'},
                                         {name: 'RLDefaultFlag',mapping:'RLDefaultFlag',type:'string'},
                                         {name: 'RLTimeFrom',mapping:'RLTimeFrom',type:'string'},
                                         {name: 'RLTimeTo',mapping:'RLTimeTo',type:'string'},
                                         {name: 'RLCTHospitalDR',mapping:'RLCTHospitalDR',type:'string'},
                                         {name: 'RLDateFrom',mapping:'RLDateFrom',type:'string'},
                                         {name: 'RLDateTo',mapping:'RLDateTo',type:'string'},
                                         {name: 'RLOrderPriorityDR',mapping:'RLOrderPriorityDR',type:'string'},
                                         {name: 'RLClinicType',mapping:'RLClinicType',type:'string'}
                                   ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'RLParRef',
							hideLabel : 'True',
							hidden : true,
							readOnly : true,
							name : 'RLParRef'
						},{
							fieldLabel : 'RLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'RLRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							
							fieldLabel : '病人科室',
							name : 'RLOrdLocDR',
							hiddenName : 'RLOrdLocDR',
							id:'RLOrdLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLOrdLocDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLOrdLocDRF')),
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
												desc:e.query,
												tablename:Ext.BDP.FunLib.TableName,
												hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
									
								 	}
							}
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>接收科室',
							name : 'RLRecLocDR',
							id:'RLRecLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLRecLocDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLRecLocDRF')),
							hiddenName : 'RLRecLocDR',
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							allowBlank : false
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>功能',
							hiddenName : 'RLFunction',
							id:'RLFunctionF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLFunctionF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLFunctionF')),
							allowBlank : false,
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [
													['Execute', 'Execute'],
													['Processing', 'Processing']
												]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, {
							xtype : 'checkbox',
							fieldLabel : '默认',
							name : 'RLDefaultFlag',
							id:'RLDefaultFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLDefaultFlagF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLDefaultFlagF')),
							inputValue : 'Y'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '医院',
							hiddenName : 'RLCTHospitalDR',
							id:'RLCTHospitalDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLCTHospitalDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLCTHospitalDRF')),						
							store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : HOSP_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'HOSPRowId', 'HOSPDesc' ])
										}),
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'HOSPRowId',
							displayField : 'HOSPDesc'
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'RLDateFrom',
							id:'RLDateFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLDateFromF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLDateFromF')),
							format : BDPDateFormat,
							allowBlank : false,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							id:'RLDateToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLDateToF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLDateToF')),
							name : 'RLDateTo',
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'timefield',
							fieldLabel : '开始时间',
							name : 'RLTimeFrom',
							id:'RLTimeFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLTimeFromF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLTimeFromF')),
							format : 'H:i:s',
							increment: 15
						
						}, {
							xtype : 'timefield',
							fieldLabel : '结束时间',
							id:'RLTimeToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLTimeToF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLTimeToF')),
							name : 'RLTimeTo',
							format : 'H:i:s',
							increment: 15
						}, {
							xtype : 'bdpcombo',
							pageSize :  Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							fieldLabel : '医嘱优先级',
							
							hiddenName : 'RLOrderPriorityDR',
							id:'RLOrderPriorityDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLOrderPriorityDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLOrderPriorityDRF')),
						
							store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : Priority_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'OECPRRowId', 'OECPRDesc' ])
										}),
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'OECPRRowId',
							displayField : 'OECPRDesc'
						}, 
						{
							xtype : 'combo',
							fieldLabel : '就诊类型',
							hiddenName : 'RLClinicType',
							id:'RLClinicTypeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLClinicType'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLClinicType')),
							allowBlank : true,
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [
													['O', '门诊'],
													['E', '急诊'],
													['I', '住院'],
													['H', '体检'],
													['N', '新生儿']
												]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}
						]
			});
	
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		title : '',
		width : 300,
		height: 300,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
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
				
   			 	if(WinForm.form.isValid()==false){
   			 		Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
   			 		return;
   			 	}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												grid.getStore().load({
															params : {
																start : 0,
																limit : 1,
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
											msg : '添加失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}

						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
						}
					})
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									//保存别名
									AliasGrid.saveAlias();
									
									// alert(action);
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : 1,
																rowid : myrowid
															}
														});*/
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
									Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
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
				Ext.getCmp("form-save").getForm().findField("ORCATCode").focus(true,800);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {}
		}
	});
	
	/** 接收科室增加\修改窗口 */
	var child_win = new Ext.Window({
		title : '',
		width : 400,
		height:470,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
			handler : function() {
				var RLDateFrom = Ext.getCmp("child-form-save").getForm().findField("RLDateFrom").getValue();				
    			var RLDateTo = Ext.getCmp("child-form-save").getForm().findField("RLDateTo").getValue();
				var RLTimeFrom = Ext.getCmp("child-form-save").getForm().findField("RLTimeFrom").getValue();				
    			var RLTimeTo = Ext.getCmp("child-form-save").getForm().findField("RLTimeTo").getValue();
    			if (RLDateFrom != "" && RLDateTo != "") {
    				RLDateFrom = RLDateFrom.format("Ymd");
    				RLDateTo = RLDateTo.format("Ymd");
        			if (RLDateFrom > RLDateTo) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始日期不能大于结束日期!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
      				
   			 	}
   			 	if (((RLTimeFrom=="")&&(RLTimeTo != ""))||((RLTimeFrom!="")&&(RLTimeTo== ""))) 
   			 	{
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始时间和结束时间需同时填写!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      			
   			 	}
   			 	if (RLTimeFrom != "" && RLTimeTo != "") {
        			if (RLTimeFrom >= RLTimeTo) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '结束时间必须大于开始时间!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
   			 	}
   			 	if(child_WinForm.form.isValid()==false){
   			 		Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
   			 		return;
   			 	}

				var ClinicType = Ext.getCmp("RLClinicTypeF").getValue();

   			 	var WarningMsg="";
   			 	var RLDefaultFlagF = Ext.getCmp("RLDefaultFlagF").getValue();  ///true false
   			 	if(RLDefaultFlagF==true)
   			 	{
   			 		var parref = grid.getSelectionModel().getSelected().get('ORCATRowId');	 
   			 		var rlrowid = Ext.getCmp("child-form-save").getForm().findField("RLRowId").getValue();
   			 		var ordlocdr = Ext.getCmp("child-form-save").getForm().findField("RLOrdLocDR").getValue();
   			 		var HospitalDR=Ext.getCmp("RLCTHospitalDRF").getValue()
   			 		var str=Ext.getCmp("RLOrderPriorityDRF").getValue()+"^"+Ext.getCmp("RLTimeFromF").getValue()+"^"+Ext.getCmp("RLTimeToF").getValue()+"^"+Ext.getCmp("RLDateFromF").getValue()+"^"+Ext.getCmp("RLDateToF").getValue()+"^"+HospitalDR+"^"+ClinicType
   			 		var flag=tkMakeServerCall("web.DHCBL.CT.OECOrdCatRecLoc","GetDefRecLoc",parref,rlrowid,ordlocdr,str);
   			 		if (flag==1)
   			 		{
   			 			WarningMsg='已经存在默认接收科室，此次保存会把其他的默认记录改成不默认,'
   			 		}
   			 	
   			 	}
   			 	
   			 	Ext.MessageBox.confirm('提示', WarningMsg+'确定要保存该条数据吗?', function(btn) {
					if (btn == 'yes') {
						if (child_win.title == '添加') {
							child_WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : CHILD_SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										child_win.hide();
										var myrowid = action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
													title : '提示',
													msg : '添加成功!',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														child_grid.getStore().load({
																	params : {
																		start : 0,
																		limit : 1,
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
													title : '提示',
													msg : '添加失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
		
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
								}
							})
						} else {
							
									child_WinForm.form.submit({
										clientValidation : true, // 进行客户端验证
										waitMsg : '正在提交数据请稍后...',
										waitTitle : '提示',
										url : CHILD_SAVE_ACTION_URL,
										method : 'POST',
										success : function(form, action) {
											// alert(action);
											if (action.result.success == 'true') {
												child_win.hide();
												var myrowid = "rowid=" + action.result.id;
												// var myrowid = jsonData.id;
												Ext.Msg.show({
													title : '提示',
													msg : '修改成功!',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														///Ext.BDP.FunLib.ReturnDataForUpdate("child_grid", CHILD_QUERY_ACTION_URL, myrowid)
														child_grid.getStore().load({
																	params : {
																		start : 0,
																		limit : pagesize_pop
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
															title : '提示',
															msg : '修改失败!' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										},
										failure : function(form, action) {
											Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
										}
									})
								
							// WinForm.getForm().reset();
						}
				
					}
					}, this);
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				child_win.hide();
			}
		}],
		listeners : {
			'show' : function() {
				//Ext.getCmp("child-form-save").getForm().findField("RLOrdLocDR").focus(true,800);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});
	
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
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
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					
					if (!grid.selModel.hasSelection()) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			        	var _record = grid.getSelectionModel().getSelected();
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ORCATRowId'),
			                waitMsg : '正在载入数据...',
			                success : function(form,action) {
			                    //Ext.Msg.alert(action);
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            
			            //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('ORCATRowId');
				        AliasGrid.loadGrid();
			        }
				}
			});
			
	/** 接收科室store */
	var child_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RLRowId',
									mapping : 'RLRowId',
									type : 'string'
								}, {
									name : 'RLRecLocDesc',
									mapping : 'RLRecLocDesc',
									type : 'string'
								}, {
									name : 'RLOrdLocDesc',
									mapping : 'RLOrdLocDesc',
									type : 'string'
								}, {
									name : 'RLFunction',
									mapping : 'RLFunction',
									type : 'string'
								}, {
									name : 'RLDefaultFlag',
									mapping : 'RLDefaultFlag',
									type : 'string'
								}, {
									name : 'RLTimeFrom',
									mapping : 'RLTimeFrom',
									type : 'string'
								}, {
									name : 'RLTimeTo',
									mapping : 'RLTimeTo',
									type : 'string'
								}, {
									name : 'RLCTHospitalDesc',
									mapping : 'RLCTHospitalDesc',
									type : 'string'
								}, {
									name : 'RLDateFrom',
									mapping : 'RLDateFrom',
									type : 'string'
								}, {
									name : 'RLDateTo',
									mapping : 'RLDateTo',
									type : 'string'
								}, {
									name : 'RLOrderPriorityDesc',
									mapping : 'RLOrderPriorityDesc',
									type : 'string'
								}, {
									name : 'RLClinicType',
									mapping : 'RLClinicType',
									type : 'string'
								}// 列的映射
						])
			});
	/** 加载前设置参数 */
	child_ds.on('beforeload',function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.apply(child_ds.lastOptions.params, {
				    	ParRef : rows[0].get('ORCATRowId')
				    });
			},this);
	/** 接收科室child_grid */
	var child_grid = new Ext.grid.GridPanel({
				id : 'child_grid',
				region : 'center',
				closable : true,
				store : child_ds,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'RLRowId',
							sortable : true,
							dataIndex : 'RLRowId',
							hidden : true
						}, {
							header : '病人科室',
							sortable : true,
							dataIndex : 'RLOrdLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						}, {
							header : '接收科室',
							sortable : true,
							dataIndex : 'RLRecLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						}, {
							header : '功能',
							sortable : true,
							dataIndex : 'RLFunction'
						}, {
							header : '默认',
							sortable : true,
							dataIndex : 'RLDefaultFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '医院',
							sortable : true,
							dataIndex : 'RLCTHospitalDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '开始日期',
							sortable : true,
							dataIndex : 'RLDateFrom'
						}, {
							header : '结束日期',
							sortable : true,
							dataIndex : 'RLDateTo'
						}, {
							header : '开始时间',
							sortable : true,
							dataIndex : 'RLTimeFrom'
						}, {
							header : '结束时间',
							sortable : true,
							dataIndex : 'RLTimeTo'
						}, {
							header : '医嘱优先级',
							sortable : true,
							dataIndex : 'RLOrderPriorityDesc'
						}, {
							header : '就诊类型',
							sortable : true,
							width : 120,
							dataIndex : 'RLClinicType'
						}],
				title : '医嘱大类 接收科室',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					}),
				tbar : new Ext.Toolbar({
						  items : [ '病人科室',{
						  				xtype : 'bdpcombo',
						  				pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										loadByIdParam : 'rowid',
						  				id : 'TextCode2',
   										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
						  				mode : 'remote',			
										store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'CTLOCRowID', 'CTLOCDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc',
										listeners:{
											   'beforequery': function(e){
													this.store.baseParams = {
															desc:e.query,
															tablename:Ext.BDP.FunLib.TableName,
															hospid:hospComp.getValue()
													};
													this.store.load({params : {
																start : 0,
																limit : Ext.BDP.FunLib.PageSize.Combo
													}})
												
											 	}
										}
						  			}, '-',
									'接收科室',{
										xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							
										id : 'TextDesc2',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2'),
										mode : 'remote',
										store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'CTLOCRowID', 'CTLOCDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc'
										}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch'),
													handler : function() {
																child_grid.getStore().baseParams={
																	RecLoc : Ext.getCmp('TextDesc2').getValue(),
																	OrdLoc : Ext.getCmp('TextCode2').getValue()
															 	};
																child_grid.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh'),
														handler : function() {
															Ext.getCmp('TextCode2').reset();
															Ext.getCmp('TextDesc2').reset();
															child_grid.getStore().baseParams={};
															child_grid.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton.render(child_grid.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});
	Ext.BDP.FunLib.ShowUserHabit(child_grid,"User.OECOrdCatRecLoc");		
	/** child_grid双击事件 */
	child_grid.on('rowdblclick', function(child_grid) {
				var _record = child_grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            child_win.setTitle('修改');
					child_win.setIconClass('icon-update');
					child_win.show('');
					 Ext.getCmp("child-form-save").getForm().load({
		                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('RLRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                	
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
			
	/** 接收科室窗口 */	
	var child_list_win = new Ext.Window({
		//title : '医嘱大类 接收科室',
		iconCls : 'icon-DP',
		width : Ext.getBody().getWidth()*0.96,
		height : Ext.getBody().getHeight()-180,//Ext.getBody().getHeight()*0.9,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		//frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		//bodyStyle : 'padding:3px',
		constrain : true,
		closeAction : 'hide',
		items : [child_grid],
		listeners : {
			"show" : function(){
				keymap_main.disable();
				keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData2,UpdateData2,DelData2);
				
			},
			"hide" : function(){
				keymap_pop.disable();
				keymap_main.enable();
				
			},
			"close" : function(){
			}
		}
	});
			
	/** 接收科室按钮 */
	var btnLoc = new Ext.Toolbar.Button({
				text : '接收科室',
				tooltip : '医嘱大类接收科室',
				id:'btnLoc',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLoc'),
				iconCls : 'icon-DP',
				handler : function() {
					if (grid.selModel.hasSelection()) {
						Ext.getCmp('TextCode2').reset();
						Ext.getCmp('TextDesc2').reset();
						child_ds.removeAll();
						child_ds.baseParams={};
						child_ds.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win.setTitle(rows[0].get('ORCATDesc'));
						child_list_win.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条医嘱大类!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
			
	/** 接收科室维护工具条 */
	var child_tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn'),
								handler : AddData2=function () {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var RLParRef = rows[0].get('ORCATRowId')
									child_win.setTitle('添加');
									child_win.setIconClass('icon-add');
									child_win.show('new1');
									child_WinForm.getForm().reset();
									child_WinForm.getForm().findField('RLParRef').setValue(RLParRef);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn'),
									handler : UpdateData2=function () {
										var _record = child_grid.getSelectionModel().getSelected();
										if (!_record) {
								            Ext.Msg.show({
												title : '提示',
												msg : '请选择需要修改的行!',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
								        } else {
								            child_win.setTitle('修改');
											child_win.setIconClass('icon-update');
											child_win.show('');
											 Ext.getCmp("child-form-save").getForm().load({
								                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('RLRowId'),
								                waitMsg : '正在载入数据...',
								                success : function(form,action) {
								                    //Ext.Msg.alert(action);
								                	//Ext.Msg.alert('编辑', '载入成功');
								                	
								                },
								                failure : function(form,action) {
								                	Ext.Msg.alert('编辑', '载入失败');
								                }
								            });
								        }
									},
									scope : this
								}), '-', child_btnDel]
		});
		
		
				var fields=[{
									name : 'ORCATRowId',
									mapping : 'ORCATRowId',
									type : 'int'
								}, {
									name : 'ORCATCode',
									mapping : 'ORCATCode',
									type : 'string'
								}, {
									name : 'ORCATDesc',
									mapping : 'ORCATDesc',
									type : 'string'
								}, {
									name : 'ORCATRepeatInOrder',
									mapping : 'ORCATRepeatInOrder',
									type : 'string'
								}, {
									name : 'ORCATOCGroupDesc',
									mapping : 'ORCATOCGroupDesc',
									type : 'string'
								}
						]
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields )
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
					});
	
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-', btnLoc,'-',HospWinButton  ///多院区医院
		,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue(),
							OCGRPRowId : Ext.getCmp("OCGRPRowId").getValue(),
							hospid:hospComp.getValue()    ///多院区医院
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : pagesize_main
						}
					});
				}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("OCGRPRowId").reset();
					grid.getStore().baseParams={
						hospid:hospComp.getValue()    ///多院区医院
					
					};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_main
								}
							});
				}
			});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'描述', {
							xtype : 'textfield',
							emptyText : '描述/别名',id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}, '-',
						'医嘱类组', {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							id : 'OCGRPRowId',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('OCGRPRowId'),
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : OCGRP_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'OCGRPRowId', 'OCGRPDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'OCGRPRowId',
							displayField : 'OCGRPDesc'
						}, Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName), '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
			
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ORCATRowId',
							sortable : true,
							dataIndex : 'ORCATRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'ORCATCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'ORCATDesc'
						}, {
							header : '医嘱类组',
							sortable : true,
							dataIndex : 'ORCATOCGroupDesc'
						}, {
							header : '重复医嘱',
							sortable : true,
							dataIndex : 'ORCATRepeatInOrder',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}]
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM,
				stripeRows : true,
				title : '医嘱大类',
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
			
		Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
    	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
		Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);	
	    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ORCATRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ORCATRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		            
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = _record.get('ORCATRowId');
			        AliasGrid.loadGrid();
		        }				
			});

	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [GenHospPanel(hospComp),grid]  //多院区医院
			});
	var keymap_pop=""
	var keymap_main=Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
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
