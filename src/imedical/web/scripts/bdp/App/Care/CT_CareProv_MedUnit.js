/// 名称: 医护人员维护-所属医疗单元
/// 描述: 医护人员维护的子JS，医疗单元部分
/// 编写者： 基础数据平台组 、高姗姗
/// 编写日期: 2016-8-29
	var QUERY_MEDUNIT_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassQuery=GetListByDoctorDR";
	var SAVE_MEDUNIT_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCCTLocMedUnitCareProv";
	var DELETE_MEDUNIT_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=DeleteData";
	var OPEN_MEDUNIT_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=OpenData";
 	var BindingMedUnit = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnit&pClassQuery=GetDataForCmb1";
	var limit = Ext.BDP.FunLib.PageSize.Main;
 /*************************** 删除功能*************************************************/
	var btnDelMedUnit = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btnMedUnit',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btnMedUnit'),
		handler : DelData=function() {
			var records =  gridMedUnit.selModel.getSelections();
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
						var gsm = gridMedUnit.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_MEDUNIT_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('MUCPRowId') 
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
											fn : function(btn) {
													 Ext.BDP.FunLib.DelForTruePage(gridMedUnit,limit);
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
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
													icon : Ext.Msg.ERROR,
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
                        [{name: 'MUCPRowId',mapping:'MUCPRowId',type:'string'},
                         {name: 'MUCPParRef',mapping:'MUCPParRef',type:'string'},
                         {name: 'MUCPDoctorDR',mapping:'MUCPDoctorDR',type:'string'},
                        // {name: 'CTPCPCode',mapping:'CTPCPCode',type:'string'},
                        // {name: 'CTPCPDesc',mapping:'CTPCPDesc',type:'string'},
                         {name: 'MUCPLeaderFlag',mapping:'MUCPLeaderFlag',type:'string'},
                         {name:'MUCPOPFlag',mapping:'MUCPOPFlag',type:'string'},
                         {name:'MUCPIPFlag',mapping:'MUCPIPFlag',type:'string'},
                         {name: 'MUCPDateFrom',mapping:'MUCPDateFrom',type:'string'},
                         {name: 'MUCPDateTo',mapping:'MUCPDateTo',type:'string'},
						 {name: 'MUCPTimeFrom',mapping:'MUCPTimeFrom',type:'string'},
						 {name: 'MUCPTimeTo',mapping:'MUCPTimeTo',type:'string'}						 
                ]);
    var RowidText=new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : 'MUCPRowId',
          hideLabel : 'True',
          hidden : true,
          name:'MUCPRowId'
    });
	
    var MUCPDoctorDR=new Ext.BDP.FunLib.Component.TextField({
    	  id : 'MUCPDoctorDRF',
          fieldLabel : 'MUCPDoctorDR',
          hideLabel : 'True',
          hidden : true,
          name:'MUCPDoctorDR'
    });
	/*
    var CTPCPCode=new Ext.BDP.FunLib.Component.TextField({
    	  id : 'CTPCPCodeF',
          fieldLabel : 'CTPCPCode',
          hideLabel : 'True',
          //hidden : true,
          name:'CTPCPCode'
    });
    var CTPCPDesc=new Ext.BDP.FunLib.Component.TextField({
    	  id : 'CTPCPDescF',
          fieldLabel : 'CTPCPDesc',
          hideLabel : 'True',
          //hidden : true,
          name:'CTPCPDesc'
    });
	*/

    /// DateFrom
    var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'MUCPDateFrom',
       id:'MUCPDateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPDateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPDateFromF')),
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
       fieldLabel : '&nbsp;结束日期',
       name : 'MUCPDateTo',
       id:'MUCPDateToF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPDateToF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPDateToF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
         Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });
    
  
	/****************************增加修改的Form*********************************************/
	var WinMedUnitForm = new Ext.form.FormPanel({
				id : 'medunitform-save',
				labelAlign : 'right',
				split : true,
				frame : true,
                title:'基本信息',
				defaults : {
				anchor: '85%',
				border : false  
				},
				reader:jsonReaderE,
				items : [{
							xtype : 'bdpcombo',
							fieldLabel : '<font color=red>*</font>医疗单元',
							loadByIdParam:'rowid',
							hiddenName:'MUCPParRef',
							dataIndex:'MUCPParRef',
							id:'MUCPParRefF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPParRefF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPParRefF')),
							store : new Ext.data.Store({
								proxy : new Ext.data.HttpProxy({ url : BindingMedUnit }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'MURowId', 'CTMUDesc' ])
							}),
							queryParam : 'desc',
							listWidth:250,
							pageSize:Ext.BDP.FunLib.PageSize.Combo,  
							forceSelection : true,
							selectOnFocus : false, 
							allowBlank:false,
							minChars : 0,
							valueField : 'MURowId',
							displayField : 'CTMUDesc',
							listeners:{
								'select':function(){
									var leaderdata=Ext.getCmp('MUCPLeaderFlagF').getValue()
									 if (leaderdata=="1"){
										 var flag = "";
							             var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('MUCPParRefF').getValue(),"");
							             if(flag == "1"){   
							             	  Ext.Msg.alert("提示","此科室已分配组长!")
							              } 
									 }
								},
								'beforequery': function(e){
										this.store.baseParams = {
											desc:e.query,
			  								hospid:Ext.getCmp("HospDR").getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
			      				
								 }
							}
						},DateFromText,DateToText,{
							fieldLabel: "开始时间",
							hiddenName:'MUCPTimeFrom',
							dataIndex:'MUCPTimeFrom',
							id:'MUCPTimeFromF',
							labelWidth: 80,
							width: 150,
							xtype: "timefield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							maxValue: "23:00",
							minValue: "00:00",
							pickerMaxHeight: 100,
							increment: 30,
							format: "G:i:s"
						},{
							fieldLabel: "结束时间",
							hiddenName:'MUCPTimeTo',
							dataIndex:'MUCPTimeTo',
							id:'MUCPTimeToF',
							labelWidth: 80,
							width: 150,
							xtype: "timefield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							maxValue: "23:00",
							minValue: "00:00",
							pickerMaxHeight: 100,
							increment: 30,
							format: "G:i:s"
						},{
							xtype:'checkbox',
							fieldLabel : '组长标志',
							id : 'MUCPLeaderFlagF',
							name : 'MUCPLeaderFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPLeaderFlagF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPLeaderFlagF')),
							inputValue : 1 ,
							listeners:{
								'change':function(){
									 var leaderdata=Ext.getCmp('MUCPLeaderFlagF').getValue()
									 if (leaderdata=="1"){
									 	if (Ext.getCmp('MUCPParRefF').getValue()==""){
									 		Ext.Msg.alert("提示","请先选择医疗单元!")
									 		return;
									 	}
										 var flag = "";
							             var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('MUCPParRefF').getValue(),"");
							             if(flag == "1"){   
							             	  Ext.Msg.alert("提示","此科室已分配组长!")
							              } 
									 }
								}
							}
						},{
							xtype:'checkbox',
							fieldLabel : '门诊出诊标志',
							id : 'MUCPOPFlagF',
							name : 'MUCPOPFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPOPFlagF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPOPFlagF')),
							inputValue : 2  
						},{
							xtype:'checkbox',
							fieldLabel : '住院出诊标志',
							id : 'MUCPIPFlagF',
							name : 'MUCPIPFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPIPFlagF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPIPFlagF')),
							inputValue : 3  
						},RowidText,MUCPDoctorDR]//,CTPCPCode,CTPCPDesc]
			});
   
   /*********************************重置form的数据清空**************************************/
      var ClearForm = function()
      {
           Ext.getCmp("medunitform-save").getForm().reset();   
      }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
        var closepages= function (){
           winMedUnit.hide();
           ClearForm();
      }  

	/************************** 增加修改时弹出窗口*********************************************/
	var winMedUnit = new Ext.Window({
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
		items : WinMedUnitForm,
		buttons : [{
			text : '保存',
			id:'save_btnMedUnit',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btnMedUnit'),
			handler : function() {
			var tempParRef = Ext.getCmp("MUCPParRefF").getValue();
			var DoctorDr = Ext.getCmp("MUCPDoctorDRF").getValue(); //数据校验入参医护人员dr
			var startDate = Ext.getCmp("MUCPDateFromF").getValue();
			var endDate = Ext.getCmp("MUCPDateToF").getValue();
			var popflag= Ext.getCmp("MUCPOPFlagF").getValue();
			var pipflag =Ext.getCmp("MUCPIPFlagF").getValue();
			var leaderdata=Ext.getCmp('MUCPLeaderFlagF').getValue();
			if(WinMedUnitForm.getForm().isValid()==false){
	           Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
	           return;
	        } 
			if (tempParRef=="") {
				Ext.Msg.show({
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>医疗单元不能为空!</font>', 
								minWidth : 200, 
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK 
							 });
      			return;
			}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>',
								msg : '<font color=red>开始日期不能为空!</font>',
								minWidth : 200,
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK 
							});
      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
			    					title : '<font color=blue>提示</font>',
									msg : '<font color=red>开始日期不能大于结束日期!</font>',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
	      			 		return;
	  				}
				 }
		   if (winMedUnit.title == "添加") { 
		   	if ((popflag=="")&&(pipflag=="")){
		    	 Ext.Msg.confirm('系统提示','医生出诊标志为空,确定要添加数据吗?',
					 function(btn){
						 if(btn=='yes'){
						   	if (leaderdata=="1"){
								var flag = "";
							    var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('MUCPParRefF').getValue(),"");
							    if(flag == "1"){   
							         Ext.Msg.alert("提示","此单元组已经有组领导,不能再分配组领导!")
							         return;
							     } 
							 }
							 var flag=tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","FormValidate",Ext.getCmp('MUCPParRefF').getValue(),"",DoctorDr,Ext.getCmp("MUCPDateFromF").getRawValue(),Ext.getCmp("MUCPDateToF").getRawValue());
							if (flag>0){
				   					Ext.Msg.show({
							    					title : '<font color=blue>提示</font>',
													msg : '<font color=red>本医疗单元已存在此医护人员!</font>',
													minWidth : 300,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
					      			 		return;
				   			}
				   			else
				   			{
									WinMedUnitForm.form.submit({
										clientValidation : true,  
										url : SAVE_MEDUNIT_URL,
										method : 'POST',
										success : function(form, action) {
										 if (action.result.success == 'true') {
											   var myrowid = action.result.id;
				                                winMedUnit.hide();
												Ext.Msg.show({
																title : '<font color=blue>提示</font>',
																msg : '<font color=green>添加成功!</font>',
																icon : Ext.Msg.INFO,
																buttons : Ext.Msg.OK,
																fn : function(btn) {
																		var startIndex = gridMedUnit.getBottomToolbar().cursor;
																		gridMedUnit.getStore().load({
																					params : {
																								start : 0,
																								limit : limit,
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
																						title : '<font color=blue>提示</font>',
																						msg : '<font color=red>添加失败!</font>' ,
																						minWidth : 200,
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
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
												}
									 	})
				   					}
				   					 }else{
										 	Ext.getCmp('MUCPOPFlagF').focus();
										 }
									 
									 },this);
						    }  
						else{
						    if (leaderdata=="1"){
								var flag = "";
							    var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('MUCPParRefF').getValue(),"");
							    if(flag == "1"){   
							         Ext.Msg.alert("提示","此单元组已经有组领导,不能再分配组领导!")
							         return;
							     } 
							 }
				   			var flag=tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","FormValidate",Ext.getCmp('MUCPParRefF').getValue(),"",DoctorDr,Ext.getCmp("MUCPDateFromF").getRawValue(),Ext.getCmp("MUCPDateToF").getRawValue());
							if (flag>0){
				   					Ext.Msg.show({
							    					title : '<font color=blue>提示</font>',
													msg : '<font color=red>本医疗单元已存在此医护人员!</font>',
													minWidth : 300,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
					      			 		return;
				   			}
				   			else
				   			{
										WinMedUnitForm.form.submit({
											clientValidation : true,  
											url : SAVE_MEDUNIT_URL,
											method : 'POST',
											success : function(form, action) {
											 if (action.result.success == 'true') {
												   var myrowid = action.result.id;
					                                winMedUnit.hide();
													Ext.Msg.show({
																	title : '<font color=blue>提示</font>',
																	msg : '<font color=green>添加成功!</font>',
																	icon : Ext.Msg.INFO,
																	buttons : Ext.Msg.OK,
																	fn : function(btn) {
																			var startIndex = gridMedUnit.getBottomToolbar().cursor;
																			gridMedUnit.getStore().load({
																						params : {
																									start : 0,
																									limit : limit,
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
																							title : '<font color=blue>提示</font>',
																							msg : '<font color=red>添加失败!</font>' ,
																							minWidth : 200,
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
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
													}
										 	})
				   					}
							}
						} 
						else {
							   	var _record = gridMedUnit.getSelectionModel().getSelected();  
			               		var rowid=_record.get('MUCPRowId');
								Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
									if (btn == 'yes') {
										var flag = "";
										if (leaderdata=="1"){
										    flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('MUCPParRefF').getValue(),rowid);
										    if(flag == "1"){   
										         Ext.Msg.alert("提示","此单元组已经有组领导,不能再分配组领导!")
										         return;
										     } 
										 }
										flag=tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","FormValidate",Ext.getCmp('MUCPParRefF').getValue(),rowid,DoctorDr,Ext.getCmp("MUCPDateFromF").getRawValue(),Ext.getCmp("MUCPDateToF").getRawValue());
										if (flag>0){
											 Ext.Msg.alert("提示","此单元组已经有该医护人员!")
										}
										else{
											WinMedUnitForm.form.submit({
												clientValidation : true,  
												url : SAVE_MEDUNIT_URL,
												method : 'POST',
												success : function(form, action) {
													if (action.result.success == 'true') {
													    var myrowid = 'rowid='+action.result.id;
										                winMedUnit.hide();
									                    Ext.Msg.show({
									                                  title : '<font color=blue>提示</font>',
									                                  msg : '<font color=green> 修改成功!</font>',
									                                  icon : Ext.Msg.INFO,
									                                  buttons : Ext.Msg.OK,
									                                  fn : function(btn) {
									                                    var startIndex = gridMedUnit.getBottomToolbar().cursor;
								                                        Ext.BDP.FunLib.ReturnDataForUpdate('gridMedUnit',QUERY_MEDUNIT_URL,myrowid);
								                                     }
								                              }); 
													}else {
														var errorMsg = '';
														if (action.result.errorinfo) {
															errorMsg = '<br/>错误信息:结束日期不为空，已结束的记录不能修改！'
														}
														Ext.Msg.show({
																		title : '<font color=blue>提示</font>',
																		msg : '<font color=red>修改失败!</font>' + errorMsg ,
																		minWidth : 200,
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
																	icon : Ext.Msg.ERROR,
																	buttons : Ext.Msg.OK
																});
															}
													})
												}
											}
										}, this);
									}
							}
						},{
							text : '关闭',
							iconCls : 'icon-close',
							handler : function() {
							  winMedUnit.hide();   
              					ClearForm();
							}
						}],
						listeners : {
							"show" : function() {
							},
							"hide" : function(){
				           
				               },
							"close" : function() {
							}
						}
					});
	/********************************增加按钮**********************************/
	var btnAddMedUnit = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btnMedUnit',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btnMedUnit'),
				handler : AddDataMedUnit=function() {
					Ext.getCmp('MUCPParRefF').enable();
					winMedUnit.setTitle('添加');
					winMedUnit.setIconClass('icon-add');
					winMedUnit.show('');
					WinMedUnitForm.getForm().reset();
					Ext.getCmp("MUCPDoctorDRF").setValue(Ext.getCmp("DoctorDRF").getValue()); //新增时给form表单的医护人员DR赋值
				},
				scope : this
			});
	/********************************修改按钮**********************************/
	var btnEditMedUnit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btnMedUnit',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btnMedUnit'),
				handler : UpdateDataMedUnit=function() {
					Ext.getCmp('MUCPParRefF').disable();
					var records =  gridMedUnit.selModel.getSelections();
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
				   		winMedUnit.setTitle('修改');
						winMedUnit.setIconClass('icon-update');
						winMedUnit.show('');
						loadFormData(gridMedUnit);
					 }
      		 }
    });
	 

	/***************************数据保存格式为json格式**********************************/
 	var fieldsMedUnit= [{
					name : 'MUCPParRef',
					mapping : 'MUCPParRef',
					type : 'string'
				}, {
					name : 'MUCPChildsub',  
					mapping : 'MUCPChildsub',
					type : 'string'
				}, {
					name : 'MUCPRowId',
					mapping :'MUCPRowId',
					type:'string'
				},{
					name:'CTMUDesc',
					mapping:'CTMUDesc',
					type:'string'
				},{
					name:'MUCPLeaderFlag',
					mapping:'MUCPLeaderFlag',
					type:'string'
				},{
					name:'MUCPOPFlag',
					mapping:'MUCPOPFlag',
					type:'string'
				},{
					name:'MUCPIPFlag',
					mapping:'MUCPIPFlag',
					type:'string'
				}, {
					name :'MUCPDateFrom',
					mapping :'MUCPDateFrom',
					type : 'date',
					dateFormat : 'm/d/Y'
				}, {  //新增开始时间
					name:'MUCPTimeFrom',
					mapping:'MUCPTimeFrom',
					type:'string' 
                }, {
					name :'MUCPDateTo',
					mapping :'MUCPDateTo',
					type : 'date',
					dateFormat : 'm/d/Y'
				}, {  //新增结束时间
					name:'MUCPTimeTo',
					mapping:'MUCPTimeTo',
					type:'string' 
                }]
	var dsMedUnit = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : QUERY_MEDUNIT_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fieldsMedUnit)
		});
/************************************加载数据***************************************/
	dsMedUnit.load({
			params : {
				start : 0,
				limit : limit
			} 
		}); 
	/************************************数据分页************************************/
	var pagingMedUnit = new Ext.PagingToolbar({
            pageSize: limit,
            store: dsMedUnit,
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
	/***************************增删改工具条*********************************/
	var tbbuttonMedUnit = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddMedUnit, '-', btnEditMedUnit]  //, '-', btnDelMedUnit 
		})
	/*************************** 搜索工具条**********************************/
	var btnSearchMedUnit = new Ext.Button({
				id : 'btnSearchMedUnit',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearchMedUnit'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				gridMedUnit.getStore().baseParams={	
						DoctorDR : Ext.getCmp("DoctorDRF").getValue(),
						ParRef : Ext.getCmp("TextParRef").getValue() 
				};
				gridMedUnit.getStore().load({
					params : {
								start : 0,
								limit : limit
							}
						});
					}
			});
	/******************************* 刷新工作条************************************/
	var btnRefreshMedUnit = new Ext.Button({
				id : 'btnRefreshMedUnit',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshMedUnit'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextParRef").reset();
					gridMedUnit.getStore().baseParams={DoctorDR:Ext.getCmp("DoctorDRF").getValue()};
					gridMedUnit.getStore().load({
								params : {
											start : 0,
											limit : limit
										}
								});
						}
				});
	/**********************************将工具条放到一起*****************************/
	var tbMedUnit = new Ext.Toolbar({
				id : 'tbMedUnit',
				items : ['医疗单元', {
							xtype : 'bdpcombo',
							loadByIdParam:'rowid',
							hiddenName:'MUCPParRef',
							dataIndex:'MUCPParRef',
							id:'TextParRef',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextParRef'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextParRef')),
							store : new Ext.data.Store({
								proxy : new Ext.data.HttpProxy({ url : BindingMedUnit }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'MURowId', 'CTMUDesc' ])
							}),
							queryParam : 'desc',
							listWidth:250,
							pageSize:Ext.BDP.FunLib.PageSize.Combo,  
							forceSelection : true,
							selectOnFocus : false, 
							minChars : 0,
							valueField : 'MURowId',
							displayField : 'CTMUDesc',
							listeners:{
								'beforequery': function(e){
										this.store.baseParams = {
											desc:e.query,
			  								hospid:Ext.getCmp("HospDR").getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
			      				
								 }
							}
						},'-', btnSearchMedUnit, '-', btnRefreshMedUnit,
						//将form表单的隐藏字段改加在工具条上
						{
							xtype: 'textfield',
							id: 'DoctorDRF',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('DoctorDRF'),
							hidden : true
						},
						{
							xtype: 'textfield',
							id: 'CTPCPCodeF',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCodeF'),
							hidden : true
						},
						{
							xtype: 'textfield',
							id: 'CTPCPDescF',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDescF'),
							hidden : true
						},
						{	//便于医疗单元下拉框传参 likefan
							xtype: 'textfield',
							id: 'HospDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('HospDR'),
							hidden : true
						},'->'],
				listeners : {
					render : function() {
						tbbuttonMedUnit.render(gridMedUnit.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
/************************************create the Grid *************************************/
	var smMedUnit=	new Ext.grid.RowSelectionModel({singleSelect:true})
	var GridCMGridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'MUCPParRef',
							width : 80,
							sortable : true,
							dataIndex : 'MUCPParRef',
							hidden : true
						}, {
							header : 'MUCPChildsub',
							width : 80,
							sortable : true,
							dataIndex : 'MUCPChildsub',
							hidden : true
						}, {
							header : 'MUCPRowId',
							width : 80,
							sortable : true,
							dataIndex : 'MUCPRowId',
							hidden : true
						},{
							header : '医疗单元',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'CTMUDesc'
						},{
							header : '组长标志',
							width : 80,
							sortable : true,
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'MUCPLeaderFlag'
						},{
							header:'门诊出诊标志',
							width:120,
							sortable:true,
							dataIndex:'MUCPOPFlag',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header:'住院出诊标志',
							width:120,
							sortable:true,
							dataIndex:'MUCPIPFlag',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header : '开始日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'MUCPDateFrom'
						}, {
							header : '结束日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'MUCPDateTo'
						},{
                            header:'开始时间',
                            width:100,
                            sortable:true,
                            dataIndex :'MUCPTimeFrom'
                        }, {
                            header:'结束时间',
                            width:100,
                            sortable:true,
                            dataIndex :'MUCPTimeTo'
                        }];
	var gridMedUnit = new Ext.grid.GridPanel({
				id : 'gridMedUnit',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : dsMedUnit,
				stripeRows:true,
				autoFill:true,
				trackMouseOver : true,
				singleSelect: true ,
				columns:GridCMGridCM,
				sm:smMedUnit, 
				stripeRows : true,
				columnLines : true,  
				stateful : true,
				viewConfig : {
					forceFit : true,
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true // 
				},
				bbar : pagingMedUnit,
				tbar : tbMedUnit,
				stateId : 'gridMedUnit'
			});
 
/************************************双击事件*****************************************/
	  var loadFormData = function(gridMedUnit){
	        var _record = gridMedUnit.getSelectionModel().getSelected();  
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinMedUnitForm.form.load( {
	                url : OPEN_MEDUNIT_URL + '&id='+ _record.get('MUCPRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
                     
	        	      },
	                 failure : function(form,action) {
	                 Ext.Msg.alet("提示","加载数据失败！")
	                }
	            });
	        }
	    };
	    gridMedUnit.on("rowdblclick", function(gridMedUnit, rowIndex, e) {
				Ext.getCmp('MUCPParRefF').disable();
			   	var row = gridMedUnit.getStore().getAt(rowIndex).data;
				winMedUnit.setTitle('修改');      ///双击后
				winMedUnit.setIconClass('icon-update');
				winMedUnit.show('');
				loadFormData(gridMedUnit)
	    });	
	Ext.BDP.FunLib.ShowUserHabit(gridMedUnit,"User.DHCCTLocMedUnit");

function getMedUnitPanel(){
	var winMed = new Ext.Window({
			title:'',
			width:1000,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: gridMedUnit,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
  	return winMed;
}
