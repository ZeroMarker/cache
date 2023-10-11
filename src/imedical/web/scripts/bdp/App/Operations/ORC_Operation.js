  	
	/// 名称:手术和过程 - 18 手术/过程维护	
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2012-9-19
	////ofy1 兰大一院   自动生成最大代码 S开头 总共六位  2016-12-23
	////ofy2江西南大二附院   使用技术添加 P  操作性手术   2017-03-17
	////ofy3树形手术分类 北京安贞医院需求 2017-12-01  BDPOpetationCategory
	document.write('<script type="text/javascript" src="../scripts/bdp/App/Operations/ORC_OperationAlias.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
	/* 引用导入导出js2022-07-04 */
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.extendscript.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx-style/xlsx.full.min.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/export.js"> </script>');
	//var pinyins=Pinyin.GetJPU("液状石蜡外用液体剂[500ml][吉林]")  大写
Ext.onReady(function() {
	///var IfExtendLoad=0;
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "ORC_Operation"
	});
	var LocStr="",HospStr="";   ///解决未选列表里 双击或者删除后数据不对的问题 2016-8-11
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	// ORC_OperationAlias 18.1手术别名
	var ALIAS_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassQuery=GetList";
	var Alias_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassMethod=OpenData";
	var Alias_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCOperationAlias";
	var Alias_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationAlias&pClassMethod=DeleteData";
	var Alias_ParRef_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassQuery=GetDataForCmb1";
	
	// ORC_OperationItemLink 18.2手术关联医嘱项
	var LINK_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationItemLink&pClassQuery=GetList";
	var Link_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationItemLink&pClassMethod=OpenData";
	var Link_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationItemLink&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCOperationItemLink";
	var Link_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationItemLink&pClassMethod=DeleteData";
	var Link_ParRef_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassQuery=GetDataForCmb1";
	var SAVE_LINK_ALL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationItemLink&pClassMethod=SaveAll";
	
	
	// ORC_Operation 18手术/过程
	///var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassQuery=GetList";
	var ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=OpenData2";
	//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=OpenData";
	var COPY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=CopyData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=SaveEntity2&pEntityName=web.Entity.CT.ORCOperation2";
	//var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCOperation";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=DeleteData";
	var ARC_ItmMast_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetDataForCmb2";
	//var ARC_ItmMast_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	
	var DefaultCategory_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationCategory&pClassQuery=GetDataForCmb1";
	var Sex_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	//版本下拉框取值
	var VersionDictDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDVersionDict&pClassQuery=GetDataForCmb1&type=User.ORCOperation";
	
	
	///手术过程扩展表
	var Extend_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCOperationExtend";
	var Extend_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassMethod=OpenData";
	var DELETE_CTLoc_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassMethod=DeleteLocData";	
	var DELETE_Hosp_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassMethod=DeleteHospData";	

	
	var ORCBladeType_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCBladeType&pClassQuery=GetDataForCmb1";
	var OECBodySite_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECBodySite&pClassQuery=GetDataForCmb1";
	var ORCOperPosition_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperPosition&pClassQuery=GetDataForCmb1";
	var CTLoc_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var ANCOperCat_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassQuery=GetDataForANCOperCat";
	
	
	var QUERY_UnSelCTLoc_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassQuery=GetUnSelCTLocList";
	var ACTION_URL_CTLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassQuery=GetSelCTLocList";
	
	var QUERY_UnSelHOSP_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassQuery=GetUnSelHOSPList";
	var ACTION_URL_HOSP = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationExtend&pClassQuery=GetSelHOSPList";
	
	
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.ORCOperation";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="ORC_Operation"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	//-----------------（别忘了后面的grid单击事件）翻译结束--------//
	/////////////////////////////日志查看 ////////////////////////////////////////
	var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
	//var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
	var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu);
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
			RowID=rows[0].get('OPERRowId');
			Desc=rows[0].get('OPERDesc');
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
			icd10:	Ext.getCmp("TextICD10").getValue(),
			icd9:	Ext.getCmp("TextICD9").getValue(),
			category:Ext.getCmp("TextCategory").getValue(),
			activeflag:Ext.getCmp("TextActive").getValue(),
			insucode:Ext.getCmp("insucode").getValue(),
			insucodeflag:Ext.getCmp("insucodeflag").getValue(),
			versiondr:Ext.getCmp("TextOPERVersionDictDR").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
		
	});
	//多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
				var rowid=grid.getSelectionModel().getSelections()[0].get("OPERRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
	
	Ext.QuickTips.init();//悬浮提示,tooltip:'***'
	
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
	Ext.apply(Ext.form.VTypes, {										   
		cKAge1:function(val, field){
			var v1 = Ext.getCmp("OPERAgeFrom").getValue();
    		var v2 = Ext.getCmp ("OPERAgeTo").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKAge1Text:'"从年龄"应该小于"到年龄"'
	});
	
	Ext.apply(Ext.form.VTypes, {										   
		cKAge2:function(val, field){
			var v1 = Ext.getCmp("OPERAgeFrom1").getValue();
    		var v2 = Ext.getCmp ("OPERAgeTo1").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKAge2Text:'"从限制年龄"应该小于"到限制年龄"'
	});
	
	
	////增加配置维护页面  2017-07-26
	/*
	 *3,是否自动生成代码
	 *4,代码开头字母
	 *5,代码总共位数
	*/		
	  
	var config_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=GetConfigValue";
   	var config_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCOperation&pClassMethod=SaveConfigValue";
       
		
	var configWinForm = new Ext.FormPanel({
				id : 'config-form-save',
				URL : config_SAVE_ACTION_URL,
				labelAlign : 'right',
				labelWidth : 140,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'ValidCode',mapping:'ValidCode'},
                                         //{name: 'ValidDesc',mapping:'ValidDesc'},
                                         {name: 'AutoCode',mapping:'AutoCode'},
                                         {name: 'OriginCode',mapping:'OriginCode'},
                                         {name: 'TotalLength',mapping:'TotalLength'}
                                        ]),
				defaults : {
					anchor : '90%',
					bosrder : false
				},
				items : [{
						xtype:'checkbox',
						boxLabel:'校验代码+描述重复',
						id:'ValidCode',
						//inputValue : true?'Y':'N',
			    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValidCode'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValidCode'))
					/*}, {
						xtype:'checkbox',  //20220805改成代码+描述一起校验
						//inputValue : true?'Y':'N',
						boxLabel:'校验描述重复',
						id:'ValidDesc',
			    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'))*/
					},{
						boxLabel :'自动生成代码(字母+数字或者纯数字编码)',   //默认不自动生成
		                name: 'AutoCode',
		                id:'AutoCode',
		                xtype:'checkbox',
		                width: 'auto',
		                //checked:false,
						listeners:{
							'check':function(checked){
								   if(checked.checked){
										Ext.getCmp("TotalLength").setDisabled(false);
										Ext.getCmp("OriginCode").setDisabled(false);

									}else{
										Ext.getCmp("TotalLength").setDisabled(true);
										Ext.getCmp("OriginCode").setDisabled(true);
										
									}
							}
						}
		            },{
		                fieldLabel : '代码起始字符',
		                name: 'OriginCode',
		                xtype:'textfield',
		                id:'OriginCode',
		                disabled:true 
					 },{
		                fieldLabel : '<font color=red>*</font>代码总长度',
		                name: 'TotalLength',
		                xtype:'numberfield',
		                minValue : 1,
						allowNegative : false,//不允许输入负数
						allowDecimals : false,//不允许输入小数
		                id:'TotalLength',
		                disabled:true
					}]
	});
	
	var configwin = new Ext.Window({
		title : '',
		width : 515,
		minWidth:515,
		height: 250,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		hideCollapseTool : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : configWinForm, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'configsave_btn',
			handler : function() { 
					var AutoCode=Ext.getCmp('AutoCode').getValue();
					var OriginCode=Ext.getCmp('OriginCode').getValue();
					var TotalLength=Ext.getCmp('TotalLength').getValue();
					if (AutoCode==true)
					{
						if (TotalLength=="") {
		    				Ext.Msg.show({ title : '提示', msg : '代码总长度不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			return;
		    			}
		    			
		    			if ((OriginCode!="")&&(TotalLength!=""))
		    			{
							if (TotalLength<=(OriginCode.length))
							{
								Ext.Msg.show({ title : '提示', msg : '代码起始字符的长度必须小于代码总长度!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          				return;
							}
		    			}
					}
					//-------保存----------
					var ConfigStr=Ext.getCmp('ValidCode').getValue()+'^'+""+"^"+Ext.getCmp('AutoCode').getValue()+'^'+Ext.getCmp('OriginCode').getValue()+'^'+Ext.getCmp('TotalLength').getValue()
					Ext.Ajax.request({
							url : config_SAVE_ACTION_URL, 
							method : 'POST',
							params : {
								'ConfigStr' :ConfigStr
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{
										configwin.hide();          
										Ext.Msg.show({
											title : '提示',
											msg : '配置保存成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '配置保存失败！' + errorMsg,
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
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				configwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
			
			},
			"close" : function() {
			}
		}
	});
	
	 var btnConfig = new Ext.Button({
		text : '配置',
		id:'btnConfig',
		iconCls : 'icon-config',
		handler : function() {
			
			Ext.getCmp("config-form-save").getForm().load( {
	                	url : config_OPEN_ACTION_URL,
	                	//waitMsg : '正在载入数据...',
	               	 success : function(form,action) {
	                	//Ext.Msg.alert('编辑','载入成功！');
	                	},
	                	failure : function(form,action) {
	                		Ext.Msg.alert('编辑','载入失败！');
	               	 }
	           	 	});
	           	 	
			configwin.setTitle('配置');
			configwin.setIconClass('icon-config');
			configwin.show();
			
		}
	});

 	//---------------------子表2:手术关联医嘱项-------------------------
	// 删除功能
	var linkbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'Link_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('Link_del_btn'),
		handler : function() {
			if (linkgrid.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				var gsm = linkgrid.getSelectionModel();
				var rows = gsm.getSelections();
				if(rows[0].get('LINKRowId'))   //判断选中的数据是否已经保存
				{
					Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
						if (btn == 'yes') {
							// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
							
							// Ext.Ajax.request({},this);
							Ext.Ajax.request({
								url : Link_DELETE_ACTION_URL,
								method : 'POST',
								params : {
									'id' : rows[0].get('LINKRowId')
								},
								callback : function(options, success, response) {
									Ext.MessageBox.hide();
									if (success) {
										var jsonData = Ext.util.JSON.decode(response.responseText);
										if (jsonData.success == 'true') {
											// var myrowid = action.result.id;
											Ext.Msg.show({
												title : '提示',
												msg : '数据删除成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn){
													
													var targetRecord = linkgrid.getSelectionModel().getSelected();
													linkds.remove(targetRecord);
													/*var startIndex = linkgrid.getBottomToolbar().cursor;
													var totalnum=linkgrid.getStore().getTotalCount();
													if(totalnum==1){   //修改添加后只有一条，返回第一页
														var startIndex=0
													}
													else if((totalnum-1)%pagesize1==0)//最后一页只有一条
													{
															
															var pagenum=linkgrid.getStore().getCount();
															if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
															//不是最后一页则还停留在这一页
													}
													linkgrid.getStore().load({
																params : {
																	start : startIndex,
																	limit : pagesize1,
																	linkparref : grid.getSelectionModel().getSelected().get('OPERRowId')  
																	}	
															});		*/
		
												}
											});
										} else {
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
									} else {
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
					
					
					}
				else
				{
					var targetRecord = linkgrid.getSelectionModel().getSelected();
					linkds.remove(targetRecord);
				}
					
				
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
	var arcimds=new Ext.data.Store({
				//autoLoad : true,
				proxy : new Ext.data.HttpProxy({
							url : ARC_ItmMast_DR_QUERY_ACTION_URL
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ARCIMRowId',
									mapping : 'ARCIMRowId'
								}, {
									name : 'ARCIMDesc',
									mapping : 'ARCIMDesc'
								}])
			})
	// 增加修改的Form
	var linkWinForm = new Ext.FormPanel({
		id : 'link-form-save',
		URL : Link_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'LINKParRef',
							mapping : 'LINKParRef'
						}, {
							name : 'LINKARCIMDR',
							mapping : 'LINKARCIMDR'
						}, {
							name : 'LINKRowId',
							mapping : 'LINKRowId'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'LINKRowId',
					xtype : 'textfield',
					fieldLabel : 'LINKRowId',
					name : 'LINKRowId',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'LINKParRef',
					xtype : 'textfield',
					fieldLabel : 'LINKParRef',
					name : 'LINKParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					xtype : 'bdpcombo',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					loadByIdParam : 'rowid',
					listWidth:250,
					fieldLabel : '<font color=red>*</font>医嘱项',
					allowBlank:false,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('LINKARCIMDR'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('LINKARCIMDR'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LINKARCIMDR')),
					hiddenName : 'LINKARCIMDR',
					// id :'LINKARCIMDR',
					store : arcimds,
					mode : 'local',
					queryParam : 'desc',
					shadow : false,
					forceSelection : true,
					selectOnFocus : false,
					//triggerAction : 'all',
					// hideTrigger: false,
					displayField : 'ARCIMDesc',
					valueField : 'ARCIMRowId'
				}]
	});

	// 增加修改时弹出窗口
	var linkwin = new Ext.Window({
		title : '',
		width : 280,
		height : 130,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : linkWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id : 'Link_savebtn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('Link_savebtn'),
			handler : function() {
				// -------添加----------
				if (linkwin.title == "添加") {
					
					linkWinForm.form.submit({
						url : Link_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'LINKParRef' : grid.getSelectionModel().getSelected().get('OPERRowId') //在打开的时候,已赋值
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								linkwin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = linkgrid.getBottomToolbar().cursor;
												linkgrid.getStore().baseParams = { // 解决linkgrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													linkparref : grid.getSelectionModel().getSelected().get('OPERRowId')
												};
												linkgrid.getStore().load({
															params : {
																/*start : 0,
																limit : pagesize1*/
															}
														});
											}
										});
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
				// ---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							linkWinForm.form.submit({
								url : Link_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										linkwin.hide();
										var myrowid = action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = linkgrid.getBottomToolbar().cursor;
												//Ext.BDP.FunLib.ReturnDataForUpdate("linkgrid",LINK_ACTION_URL,myrowid)
												linkgrid.getStore().baseParams = { // 解决linkgrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													linkparref : grid.getSelectionModel().getSelected().get('OPERRowId')
												};
												linkgrid.getStore().load({
															params : {
																/*start : 0,
																limit : pagesize1*/
															}
														});
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'
													+ action.result.errorinfo
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
				linkwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("link-form-save").getForm().findField("LINKARCIMDR").focus(true, 300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				linkWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var linkbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id : 'LinkbtnAdd',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnAdd'),
				handler : function() {
					var code=Ext.getCmp("OPERCode").getValue();
					
					if(code=="")
					{	Ext.Msg.show({
									title : '提示',
									msg : '手术代码不可为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						return;
					}
					var desc=Ext.getCmp("OPERDesc").getValue();
					if(desc=="")
					{	Ext.Msg.show({
									title : '提示',
									msg : '手术描述不可为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						return;
					}	
					var acrimdr=Ext.getCmp("tbLINKARCIMDR").getValue();
					if (acrimdr=="")
					{
						Ext.Msg.show({
									title : '提示',
									msg : '请选择医嘱项！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						return;
					}
					
					///重复校验 ，2015-10-13 chenying
						for (var i = 0; i < linkds.getCount(); i++) {
								var record1 = linkds.getAt(i);
								var LINKARCIMDR = record1.get('LINKARCIMDR');
								if(acrimdr==LINKARCIMDR)
								{
									Ext.Msg.show({
										title:'提示',
										msg:'该记录已存在!',
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
									return;
								}
							}
							
					var record = new Ext.data.Record({
    	 					'LINKRowId':'',
    	 					'LINKParRef':'',
    	 					'LINKARCIMDR':Ext.getCmp('tbLINKARCIMDR').getValue(),
    	 					'ARCIMDesc':Ext.getCmp('tbLINKARCIMDR').getRawValue()
    	 					
    	 					
    	 			});
    	 			linkgrid.stopEditing();
    	 			linkds.insert(0,record); 	   
    	 			Ext.getCmp("tbLINKARCIMDR").reset();

				},
				scope : this
			});

	// 修改按钮
	var linkbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'LinkbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnUpdate'),
				handler : function() {
					if (linkgrid.selModel.hasSelection()) {
						var acrimdr=Ext.getCmp("tbLINKARCIMDR").getValue()
						if (acrimdr=="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : '请选择要关联的医嘱项！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
							return;
						}
						///重复校验 ，2015-10-13 chenying
						for (var i = 0; i < linkds.getCount(); i++) {
								var record1 = linkds.getAt(i);
								var LINKARCIMDR = record1.get('LINKARCIMDR');
								if(acrimdr==LINKARCIMDR)
								{
									Ext.Msg.show({
										title:'提示',
										msg:'该记录已存在!',
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
									return;
								}
							}
							
						var myrecord = linkgrid.getSelectionModel().getSelected();
    	 				myrecord.set('ARCIMDesc',Ext.getCmp('tbLINKARCIMDR').getRawValue());
    	 				myrecord.set('LINKARCIMDR',Ext.getCmp('tbLINKARCIMDR').getValue());
						Ext.getCmp("tbLINKARCIMDR").reset();
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
		// 刷新工作条
	var linkbtnRefresh = new Ext.Button({
				id : 'LinkbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					
					Ext.getCmp("tbLINKARCIMDR").reset();
					if(win.title=="修改")
					{
						linkgrid.getStore().baseParams={
									linkparref : grid.getSelectionModel().getSelected().get('OPERRowId')	
						};
						linkgrid.getStore().load({
							params : {
									/*start : 0,
									limit : pagesize1*/
							}
						});
					}
					else
					{
						linkgrid.getStore().baseParams={
								linkparref : ""
						};
						linkgrid.getStore().load({
							params : {
								/*	start : 0,
									limit : pagesize1*/
							}
						});
					}
					
					
				}
	});
	var linkds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : LINK_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'LINKRowId',
								mapping : 'LINKRowId',
								type : 'string'
							}, {
								name : 'LINKARCIMDR',
								mapping : 'LINKARCIMDR',
								type : 'string'
							}, {
								name : 'ARCIMDesc',
								mapping : 'ARCIMDesc',
								type : 'string'
							}, {
								name : 'LINKParRef',
								mapping : 'LINKParRef',
								type : 'string'
							}])
			// remoteSort : true
			// sortInfo: {field : "CMCBMRowId",direction : "ASC"}
		});
	// ds.sort("CMCBMCode","DESC");

	// 加载数据
	/*linkds.load({
				params : {
					
				},
				callback : function(records, options, success) {
				}
			});*/

	// 分页工具条
	var linkpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : linkds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize1=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
			});

	var linksm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var linktbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [linkbtnAddwin, '-', linkbtnEditwin, '-',
						linkbtnDel, '-',linkbtnRefresh,'-']
			});
	var linktb = new Ext.Toolbar({
				id : 'linktb',
				items : [
						'医嘱项', {xtype : 'bdpcombo',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					loadByIdParam : 'rowid',
					listWidth:250,
					fieldLabel : '<font color=red>*</font>医嘱项',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('tbLINKARCIMDR'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tbLINKARCIMDR')),
					///hiddenName : 'LINKARCIMDR',
					id :'tbLINKARCIMDR',
					store :arcimds,
					mode : 'local',
					queryParam : 'desc',
					shadow : false,
					forceSelection : true,
					selectOnFocus : false,
					//triggerAction : 'all',
					// hideTrigger: false,
					displayField : 'ARCIMDesc',
					valueField : 'ARCIMRowId'} ],
				listeners : {
					render : function() {//当组件被渲染后将触发此函数
						linktbbutton.render(linkgrid.tbar) //渲染tbbutton按钮,tbar.render(panel.bbar)这个效果在底部
					}
				}
	});
	// 创建Grid
	var linkgrid = new Ext.grid.GridPanel({
				title : '手术关联医嘱项',
				id : 'linkgrid',
				region : 'center',
				width : 560,
				height : 370,
				//closable : true,
				store : linkds,
				trackMouseOver : true,
				columns : [linksm, {
							header : 'LINKRowId',
							width : 70,
							sortable : true,
							dataIndex : 'LINKRowId',
							hidden : true
						}, {
							header : '手术/过程', //LINKParRef
							width : 80,
							hidden : true,
							sortable : true,
							dataIndex : 'LINKParRef'
						}, {
							header : '关联的医嘱项', //LINKParRef
							width : 80,
							sortable : true,
							dataIndex : 'ARCIMDesc'
						}, {
							header : '关联的医嘱项',
							width : 80,
							hidden : true,
							sortable : true,
							dataIndex : 'LINKARCIMDR'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				//bbar : linkpaging,  //分页的话数据只能去到第一页的数据，复制时和修改时有bug 2016-3-3
				tbar : linktb,
				stateId : 'linkgrid'
			});
	Ext.BDP.FunLib.ShowUserHabit(linkgrid,"User.ORCOperationItemLink");
	
	linkgrid.on("rowclick",function(grid,rowIndex,e){
		var _record1 = linkgrid.getSelectionModel().getSelected();//records[0]
		
	    Ext.getCmp("tbLINKARCIMDR").reset();
	    Ext.getCmp("tbLINKARCIMDR").setValue(_record1.get('LINKARCIMDR'));
	    Ext.getCmp("tbLINKARCIMDR").setRawValue(_record1.get('ARCIMDesc'));
	    
	});	

	var linkwindow = new Ext.Window({
				title : '',
				width : 590,
				height : 420,
				plain : true,// true则主体背景透明
				modal : true,
				frame : true,// win具有全部阴影,若为false则只有边框有阴影
				autoScroll : true,
				collapsible : true,
				hideCollapseTool : true,
				titleCollapse : true,
				bodyStyle : 'padding:3px',
				buttonAlign : 'center',
				closeAction : 'hide',// 关闭窗口后执行隐藏命令
				items : linkgrid
			});
	var linkbtn = new Ext.Toolbar.Button({
				text : '手术关联医嘱项',
				tooltip : '手术关联医嘱项',
				//iconCls : 'icon-add',
				id : 'btnLink',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLink'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					linkwindow.setTitle(rows[0].get('OPERDesc'));
					var linkparref1=grid.getSelectionModel().getSelected().get('OPERRowId');
					linkds.removeAll();
					//Ext.getCmp("LINKParRef").setValue(linkparref1);
					linkgrid.getStore().baseParams={  //解决linkgrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								linkparref : linkparref1
					};
					linkds.load({
								params : {
									/*start : 0,
									limit : pagesize1*/
									
								}
							});
					linkwindow.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择手术/过程！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				},
				scope : this
			});
	//----------------------子表完----------------------
	function savelink(rowid){
 		var linkstr="";
	    linkds.each(function(record){
			if(linkstr!="") linkstr = linkstr+"*";
			linkstr = linkstr+record.get('LINKRowId')+'^'+record.get('LINKARCIMDR');
	    }, this);
		Ext.Ajax.request({
			url:SAVE_LINK_ALL,
			method:'POST',
			params:{
				'rowid':rowid,
				'linkstr':linkstr
			}	
		});  
	}	
	
	
	function copysavelink(rowid){
 		var linkstr="";
 		//var mm=0
	    linkds.each(function(record){
	    	//mm=mm+1
	    	//alert()
			if(linkstr!="") linkstr = linkstr+"*";
			linkstr = linkstr+""+'^'+record.get('LINKARCIMDR');
	    }, this);
		Ext.Ajax.request({
			url:SAVE_LINK_ALL,
			method:'POST',
			params:{
				'rowid':rowid,
				'linkstr':linkstr
			}	
		});  
	}	
	
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({ 
		text : '删除',
		tooltip : '删除',
		hidden:true,//2019-10-16
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			if (grid.selModel.hasSelection()) {//如果选中某一行则继续执行删除操作
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope]) 
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();//获取选择列
						var rows = gsm.getSelections();//根据选择列获取到所有的行
						
						/// 删除国家标准编码数据20160520
						Ext.BDP.DeleteFormFun(Ext.BDP.FunLib.TableName,rows[0].get('OPERRowId'));
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : DELETE_ACTION_URL,//发出请求的路径
							method : 'POST',//需要传递参数 用POST
							params : {	//请求带的参数
								'id' : rows[0].get('OPERRowId')
							},
							//callback : Function （可选项）(Optional) 
                            //该方法被调用时附上返回的http response对象
                            //options : Object  //请求所调用的参数
                            //success : Boolean //请求成功则为true
                            //response : Object //包含了返回数据的xhr(XML Http Request)对象       
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功									
									var jsonData = Ext.util.JSON.decode(response.responseText);//获取返回的信息
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												
												
												 Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
												 
												/*var startIndex = grid.getBottomToolbar().cursor;
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
														});		*/
	
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {//获取传递来的错误信息
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
								} else {
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

	
	
/**************************************科室多选开始*****************************************/	

	
	var text="";
	/*var text = new Array();
	
	function getStr(text){
		alert(text)
		alert(text.length)
		if(text.length<0) return "";
		var str="";
		for (var i = 0 ; i < text.length; i++){
			if(text[i]==undefined){
				text[i]="";
			}
			str=str+text[i];
		}
		return str;
	}
	*/
	///科室未选列表内容部分
	var dsUnSelCTLoc = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelCTLoc_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'CTLOCRowID', mapping:'CTLOCRowID',type: 'string'},
	  	{ name: 'SaveFlag', mapping:'SaveFlag',type: 'string'},
	  	{ name: 'CTLOCDesc', mapping:'CTLOCDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelCTLoc
	});
	dsUnSelCTLoc.on('beforeload',function(thiz,options){ 
		var	operrowid = ""
		if(typeof(grid)!="undefined"){
			
			if (win.title=="修改")
			{
		    	operrowid = grid.getSelectionModel().getSelections()[0].get('OPERRowId');	
			}
			else
			{
				operrowid = ""		
			}
			//alert(operrowid+"ctloc")
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     operrowid:operrowid,
		     LocStr:LocStr //2016-8-11
		  }   
		)
	});
	/*dsUnSelCTLoc.load({
		params : {
			start : 0,
			LocStr:LocStr,
			limit : pagesize1
		},
		callback : function(records, options, success) {
		}
	});*/
	var UnSelCTLocSearch = new Ext.Button({
		id : 'UnSelCTLocSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelCTLoc.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelCTLocText").getValue(),
		     	LocStr:LocStr //2016-8-11
       		};
			gridUnSelCTLoc.getStore().load({									
				params : {
					start : 0,
					limit : pagesize1
					}
			});
		}
	});	
	var UnSelCTLocRefresh = new Ext.Button({
		id : 'UnSelCTLocRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelCTLocText").reset();                    
			gridUnSelCTLoc.getStore().baseParams={LocStr:LocStr};
			gridUnSelCTLoc.getStore().load({                           
				params : {
					start : 0,
					limit : pagesize1
				}
			});
		}
	});	
	var UnSelCTLocText = new Ext.BDP.FunLib.Component.TextField({
		id : 'UnSelCTLocText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelCTLoc.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelCTLocText").getValue()
       			,LocStr:LocStr
       		};
			gridUnSelCTLoc.getStore().load({									
				params : {
					start : 0,
					limit : pagesize1
					}
				});
	        }
		}						
	})
	var unSelCTLoctb = new Ext.Toolbar({
		id : 'unSelCTLoctb',
		items : [UnSelCTLocSearch, UnSelCTLocText, '->' ,UnSelCTLocRefresh]
	});
	var pagingUnSelCTLoc= new Ext.PagingToolbar({
            pageSize: pagesize1,
            store: dsUnSelCTLoc,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize1=this.pageSize;
				         }
		        }
        })	
	var smUnSelCTLoc = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelCTLoc = new Ext.grid.GridPanel({
		id:'gridUnSelCTLoc',
		closable:true,
	    store: dsUnSelCTLoc,
	    trackMouseOver: true,
	    columns: [
	            smUnSelCTLoc,
	            { header: 'CTLOCRowID', width: 200, sortable: true, dataIndex: 'CTLOCRowID',hidden:true }, 
	            { header: 'SaveFlag', width: 200, sortable: true, dataIndex: 'SaveFlag',hidden:true}, 
	           { header: '科室', width: 200, sortable: true, dataIndex: 'CTLOCDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelCTLoctb, 
		bbar:pagingUnSelCTLoc,
	    stateId: 'gridUnSelCTLoc'
	});
	var WinCTLoc=new Ext.Window({  
        id:'WinCTLoc',  
        width:260,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'科室',  
        items:gridUnSelCTLoc  
    }); 
	//---科室
	var OPERSurgeonDeptDrDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '科室',
		name : 'OPERSurgeonDeptDrDesc',
		id : 'OPERSurgeonDeptDrDesc',
		editable:false,   ////描述框不可编辑
		readOnly : true,
		style : Ext.BDP.FunLib.ReadonlyStyle(true),
		dataIndex:'OPERSurgeonDeptDrDesc'
	});
	var BtnCTLoc = new Ext.Button({
		id : 'btnCTLoc',  
        text : '...',  
        tooltip : '科室未选列表',
        listeners : {  
	        'click' : function() {  
	        	//科室未选列表加载
	        	var operrowid="";
	        	if(typeof(grid)!="undefined"){
					var	operrowid = ""
					if (win.title=="修改")
					{
				    	operrowid = grid.getSelectionModel().getSelections()[0].get('OPERRowId');	
					}
					else
					{
						operrowid = ""
						
					}
					//alert(operrowid+"ctloc")
		    	}
		    	
			    dsUnSelCTLoc.load({
					params : {
						operrowid:operrowid,
						start : 0,
						limit : pagesize1
						,LocStr:LocStr
					}
			    });
	        	WinCTLoc.setPosition(410,40);
	        	WinCTLoc.show();
	        }  
        }  
	});
	//科室维护表单内容部分---
	var dsCTLoc = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_CTLoc}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'CTLOCDesc', mapping:'CTLOCDesc',type: 'string'},
	  	{ name: 'SaveFlag', mapping:'SaveFlag',type: 'string'},
	  	 { name: 'CTLOCRowID', mapping:'CTLOCRowID',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsCTLoc
	});
	/*dsCTLoc.on('beforeload',function(thiz,options){ 
		var	operrowid = ""
		if(typeof(grid)!="undefined"){
			
			if (win.title=="修改")
			{
		    	operrowid = grid.getSelectionModel().getSelections()[0].get('OPERRowId');
			}
			else
			{
				operrowid = ""
			}
			//alert(operrowid+"ctloc")
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     operrowid:operrowid
		  }   
		)
	});*/
	
/*	var pagingCTLoc= new Ext.PagingToolbar({
        pageSize: pagesize1,
        store: dsCTLoc,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pagesize1=this.pageSize;
			         }
	        }
    });	*/
	var smCTLoc = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridCTLoc = new Ext.grid.GridPanel({
		id:'gridCTLoc',
		region: 'center',
		width:250,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsCTLoc,
	    trackMouseOver: true,
	    columns: [
	            smCTLoc,
	            { header: 'ID', width: 100, sortable: true, dataIndex: 'CTLOCRowID',hidden:true },
	             { header: 'SaveFlag', width: 100, sortable: true, dataIndex: 'SaveFlag',hidden:true },
	            { header: '科室', width: 120, sortable: true, dataIndex: 'CTLOCDesc' }, 
	            {
				header : '操作',
				width:70,
				dataIndex: 'CTLOCRowID',
				//align:'center',
				renderer:function (){    
			    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
     				var resultStr = String.format(formatStr);  
     				return '<div class="delBtnCTLOC">' + resultStr + '</div>';  
			    }.createDelegate(this)
				}],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		//bbar:pagingCTLoc ,
	    stateId: 'gridCTLoc'
	});
	gridUnSelCTLoc.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'CTLOCRowID':gridUnSelCTLoc.getSelectionModel().getSelections()[0].get('CTLOCRowID'),
			'SaveFlag':'N',
			'CTLOCDesc':gridUnSelCTLoc.getSelectionModel().getSelections()[0].get('CTLOCDesc')
	 	});
	 	gridCTLoc.stopEditing();
	 	dsCTLoc.insert(0,_record); 
	 	
	 	if (LocStr!=""){
	 		LocStr=LocStr+"^<"+gridUnSelCTLoc.getSelectionModel().getSelections()[0].get('CTLOCDesc')+">";
	 	}else{
	 		LocStr="<"+gridUnSelCTLoc.getSelectionModel().getSelections()[0].get('CTLOCDesc')+">";
	 	}  //2016-8-11
	 	
	 	
	 	//未选列表删除
	 	var myrecord=gridUnSelCTLoc.getSelectionModel().getSelected();
	 	dsUnSelCTLoc.remove(myrecord);
	 	//页面科室显示值
	 	
	 	var CTLocDescs="";
		var CTLocRowIDs="";
	    dsCTLoc.each(function(record){
	    	if(CTLocDescs==""){
	    		CTLocDescs = record.get('CTLOCDesc');
	    	}else{
	    		CTLocDescs = CTLocDescs+","+record.get('CTLOCDesc');
	    	}
	    	
	    	if(CTLocRowIDs==""){
	    		CTLocRowIDs = record.get('CTLOCRowID');
	    	}else{
	    		CTLocRowIDs = CTLocRowIDs+"|"+record.get('CTLOCRowID');
	    	}
	    }, this);
	    Ext.getCmp("OPERSurgeonDeptDrDesc").setValue(CTLocDescs);

	 /*   if(CTLocRowIDs!=""){
	   		 text[0]=CTLocRowIDs;
	    }else{
	    	text[0]="";
	    }
	    Ext.getCmp("OPERSurgeonDeptDr").setValue(getStr(text));
	    */
	     if(CTLocRowIDs!=""){
	   		 text=CTLocRowIDs;
	    }else{
	    	text="";
	    }
		Ext.getCmp("OPERSurgeonDeptDr").setValue(text);
	});
	
	
	
	
	gridCTLoc.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtnCTLOC');
	 	if(btn){
	 	  if (gridCTLoc.selModel.hasSelection()) {
	 	  	
	 		var SaveFlag = gridCTLoc.getSelectionModel().getSelections()[0].get('SaveFlag');
	 		if (SaveFlag!="Y")
	 		{
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'CTLOCRowID':gridCTLoc.getSelectionModel().getSelections()[0].get('CTLOCRowID'),
					'SaveFlag':'N',
					'CTLOCDesc':gridCTLoc.getSelectionModel().getSelections()[0].get('CTLOCDesc')
			 	});
			 	gridUnSelCTLoc.stopEditing();
			 	dsUnSelCTLoc.insert(0,_record);
			 	
			 	
			 	//已选列表删除
			 	LocStr=LocStr.replace("<"+gridCTLoc.getSelectionModel().getSelections()[0].get('CTLOCDesc')+">","");//2016-8-11
	 			
			 	
	 			var myrecord=gridCTLoc.getSelectionModel().getSelected();
			 	dsCTLoc.remove(myrecord);
	 			//页面病症框显示值
	 			var CTLocDescs="";
	 			var CTLocRowIDs="";
			    dsCTLoc.each(function(record){
			    	if(CTLocDescs==""){
			    		CTLocDescs = record.get('CTLOCDesc');
			    	}else{
			    		CTLocDescs = CTLocDescs+","+record.get('CTLOCDesc');
			    	}
			    	
			    	if(CTLocRowIDs==""){
			    		CTLocRowIDs = record.get('CTLOCRowID');
			    	}else{
			    		CTLocRowIDs = CTLocRowIDs+"|"+record.get('CTLOCRowID');
			    	}
			    }, this);
			    Ext.getCmp("OPERSurgeonDeptDrDesc").setValue(CTLocDescs);

			  /*  if(CTLocRowIDs!=""){
			   		 text[0]=CTLocRowIDs;
			    }else{
			    	text[0]="";
			    }
				Ext.getCmp("OPERSurgeonDeptDr").setValue(getStr(text));
				*/
				  if(CTLocRowIDs!=""){
			   		 text=CTLocRowIDs;
			    }else{
			    	text="";
			    }
				Ext.getCmp("OPERSurgeonDeptDr").setValue(text);
	 		}else{
	 			var operrowid = Ext.getCmp('grid').getSelectionModel().getSelections()[0].get('OPERRowId');
	 			var CTLOCRowID = grid.getSelectionModel().getSelections()[0].get('CTLOCRowID');
	 			Ext.Ajax.request({
					url : DELETE_CTLoc_URL,
					method : 'POST',
					params : {
						ctlocrowid: CTLOCRowID,
						operrowid:operrowid
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								
								var _record = new Ext.data.Record({
									'CTLOCRowID':gridCTLoc.getSelectionModel().getSelections()[0].get('CTLOCRowID'),
									'SaveFlag':'N',
							 		'CTLOCDesc':gridCTLoc.getSelectionModel().getSelections()[0].get('CTLOCDesc')
							 	});
							 	gridUnSelCTLoc.stopEditing();
							 	dsUnSelCTLoc.insert(0,_record);

						       var myrecord=gridCTLoc.getSelectionModel().getSelected();
	 						   dsCTLoc.remove(myrecord);
	 						   //页面病症框显示值
								var CTLocDescs="";
					 			var CTLocRowIDs="";
							    dsCTLoc.each(function(record){
							    	if(CTLocDescs==""){
							    		CTLocDescs = record.get('CTLOCDesc');
							    	}else{
							    		CTLocDescs = CTLocDescs+","+record.get('CTLOCDesc');
							    	}
							    	
							    	if(CTLocRowIDs==""){
							    		CTLocRowIDs = record.get('CTLOCRowID');
							    	}else{
							    		CTLocRowIDs = CTLocRowIDs+"|"+record.get('CTLOCRowID');
							    	}
							    }, this);
							    Ext.getCmp("OPERSurgeonDeptDrDesc").setValue(CTLocDescs);
				
							    if(CTLocRowIDs!=""){
							   		 text=CTLocRowIDs;
							    }else{
							    	text="";
							    }
								Ext.getCmp("OPERSurgeonDeptDr").setValue(text);
								
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
	 	  }
	 	}
	});
	////科室多选结束
	
	
	
	/**************************************医院多选开始*****************************************/	

	
	var textHOSP=""
	/*var text = new Array();
	
	function getStr(text){
		alert(text)
		alert(text.length)
		if(text.length<0) return "";
		var str="";
		for (var i = 0 ; i < text.length; i++){
			if(text[i]==undefined){
				text[i]="";
			}
			str=str+text[i];
		}
		return str;
	}
	*/
	///医院未选列表内容部分
	var dsUnSelHOSP = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelHOSP_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'HOSPRowId', mapping:'HOSPRowId',type: 'string'},
	  	{ name: 'SaveFlag', mapping:'SaveFlag',type: 'string'},
	  	{ name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelHOSP
	});
	dsUnSelHOSP.on('beforeload',function(thiz,options){ 
		var	operrowid = ""
		if(typeof(grid)!="undefined"){
			
			if (win.title=="修改")
			{
		    	operrowid = grid.getSelectionModel().getSelections()[0].get('OPERRowId');
		    	
			}
			else
			{
				operrowid = ""
				
			}
			//alert(operrowid+"ctloc")
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     operrowid:operrowid,
		     HospStr:HospStr //2016-8-11
		  }   
		)
	});
	/*dsUnSelHOSP.load({
		params : {
			start : 0,
			limit : pagesize1,
		    HospStr:HospStr //2016-8-11
		},
		callback : function(records, options, success) {
		}
	});*/
	var UnSelHOSPSearch = new Ext.Button({
		id : 'UnSelHOSPSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelHOSP.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelHOSPText").getValue(),
		   		HospStr:HospStr //2016-8-11
       		};
			gridUnSelHOSP.getStore().load({									
				params : {
					start : 0,
					limit : pagesize1
					}
			});
		}
	});	
	var UnSelHOSPRefresh = new Ext.Button({
		id : 'UnSelHOSPRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelHOSPText").reset();                    
			gridUnSelHOSP.getStore().baseParams={
		   		HospStr:HospStr //2016-8-11
		    
		    };
			gridUnSelHOSP.getStore().load({                           
				params : {
					start : 0,
					limit : pagesize1
				}
			});
		}
	});	
	var UnSelHOSPText = new Ext.BDP.FunLib.Component.TextField({
		id : 'UnSelHOSPText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelHOSP.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelHOSPText").getValue(),
		    	HospStr:HospStr //2016-8-11
       		};
			gridUnSelHOSP.getStore().load({									
				params : {
					start : 0,
					limit : pagesize1
					}
				});
	        }
		}						
	})
	var unSelHOSPtb = new Ext.Toolbar({
		id : 'unSelHOSPtb',
		items : [UnSelHOSPSearch, UnSelHOSPText, '->' ,UnSelHOSPRefresh]
	});
	var pagingUnSelHOSP= new Ext.PagingToolbar({
            pageSize: pagesize1,
            store: dsUnSelHOSP,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize1=this.pageSize;
				         }
		        }
        })	
	var smUnSelHOSP = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelHOSP = new Ext.grid.GridPanel({
		id:'gridUnSelHOSP',
		closable:true,
	    store: dsUnSelHOSP,
	    trackMouseOver: true,
	    columns: [
	            smUnSelHOSP,
	            { header: 'HOSPRowId', width: 200, sortable: true, dataIndex: 'HOSPRowId',hidden:true }, 
	            { header: 'SaveFlag', width: 200, sortable: true, dataIndex: 'SaveFlag',hidden:true }, 
	           { header: '医院', width: 200, sortable: true, dataIndex: 'HOSPDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelHOSPtb, 
		bbar:pagingUnSelHOSP,
	    stateId: 'gridUnSelHOSP'
	});
	var WinHOSP=new Ext.Window({  
        id:'WinHOSP',  
        width:260,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'医院',  
        items:gridUnSelHOSP  
    }); 
	//---医院
	var OPERHospitalDrDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '医院',
		name : 'OPERHospitalDrDesc',
		id : 'OPERHospitalDrDesc',
		editable:false,   ////描述框不可编辑
		readOnly : true,
		style : Ext.BDP.FunLib.ReadonlyStyle(true),
		dataIndex:'OPERHospitalDrDesc',
		listeners : {
			'blur' : function(){
				/*if(Ext.getCmp("OPERHospitalDrDesc").getValue()!=""){
					text[0]=Ext.getCmp("OPERHospitalDrDesc").getValue();
				}else{
					text[0]="";
				}
				Ext.getCmp("OPERHospitalDr").setValue(getStr(text));	*/
			}		
		}
	});
	var BtnHOSP = new Ext.Button({
		id : 'btnHOSP',  
        text : '...',  
        tooltip : '医院未选列表',
        listeners : {  
	        'click' : function() {  
	        	//医院未选列表加载
	        	var	operrowid = ""
				if(typeof(grid)!="undefined"){
					
					if (win.title=="修改")
					{
				    	operrowid = grid.getSelectionModel().getSelections()[0].get('OPERRowId');
				    	
					}
					else
					{
						operrowid = ""
						
					}
		    	}
			    dsUnSelHOSP.load({
					params : {
						operrowid:operrowid,
						start : 0,
						limit : pagesize1,
		    			HospStr:HospStr //2016-8-11
					}
			    });
	        	WinHOSP.setPosition(710,40);
	        	WinHOSP.show();
	        }  
        }  
	});
	//医院维护表单内容部分---
	var dsHOSP = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_HOSP}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'},
	  	{ name: 'SaveFlag', mapping:'SaveFlag',type: 'string'},
	  	 { name: 'HOSPRowId', mapping:'HOSPRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsHOSP
	});
	/*dsHOSP.on('beforeload',function(thiz,options){ 
		var	operrowid = ""
		if(typeof(grid)!="undefined"){
			
			if (win.title=="修改")
			{
		    	operrowid = grid.getSelectionModel().getSelections()[0].get('OPERRowId');
		    	
			}
			else
			{
				operrowid = ""
			}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     operrowid:operrowid
		  }   
		)
	});*/
	
/*	var pagingHOSP= new Ext.PagingToolbar({
        pageSize: pagesize1,
        store: dsHOSP,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pagesize1=this.pageSize;
			         }
	        }
    });	*/
	var smHOSP = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridHOSP = new Ext.grid.GridPanel({
		id:'gridHOSP',
		region: 'center',
		width:250,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsHOSP,
	    trackMouseOver: true,
	    columns: [
	            smHOSP,
	            { header: 'ID', width: 100, sortable: true, dataIndex: 'HOSPRowId',hidden:true },
	             { header: 'SaveFlag', width: 100, sortable: true, dataIndex: 'SaveFlag',hidden:true },
	            { header: '医院',width: 120, sortable: true, dataIndex: 'HOSPDesc' }, 
	            {
				header : '操作',
				width:70,
				dataIndex: 'HOSPRowId',
				//align:'center',
				renderer:function (){    
			    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
     				var resultStr = String.format(formatStr);  
     				return '<div class="delBtnHOSP">' + resultStr + '</div>';  
			    }.createDelegate(this)
				}],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		//bbar:pagingHOSP ,
	    stateId: 'gridHOSP'
	});
	gridUnSelHOSP.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'HOSPRowId':gridUnSelHOSP.getSelectionModel().getSelections()[0].get('HOSPRowId'),
			'SaveFlag':'N',
			'HOSPDesc':gridUnSelHOSP.getSelectionModel().getSelections()[0].get('HOSPDesc')
	 	});
	 	gridHOSP.stopEditing();
	 	dsHOSP.insert(0,_record); 
	 	
	 	
	 	if (HospStr!=""){
	 		HospStr=HospStr+"^<"+gridUnSelHOSP.getSelectionModel().getSelections()[0].get('HOSPDesc')+">";
	 	}else{
	 		HospStr="<"+gridUnSelHOSP.getSelectionModel().getSelections()[0].get('HOSPDesc')+">";
	 	}  //2016-8-11
	 	
	 	
			 	
	 	//未选列表删除
	 	var myrecord=gridUnSelHOSP.getSelectionModel().getSelected();
	 	dsUnSelHOSP.remove(myrecord);
	 	//页面科室显示值
	 	
	 	var HOSPDescs="";
		var HOSPRowIds="";
	    dsHOSP.each(function(record){
	    	if(HOSPDescs==""){
	    		HOSPDescs = record.get('HOSPDesc');
	    	}else{
	    		HOSPDescs = HOSPDescs+","+record.get('HOSPDesc');
	    	}
	    	
	    	if(HOSPRowIds==""){
	    		HOSPRowIds = record.get('HOSPRowId');
	    	}else{
	    		HOSPRowIds = HOSPRowIds+"|"+record.get('HOSPRowId');
	    	}
	    }, this);
	    Ext.getCmp("OPERHospitalDrDesc").setValue(HOSPDescs);

	 /*   if(HOSPRowIds!=""){
	   		 text[0]=HOSPRowIds;
	    }else{
	    	text[0]="";
	    }
	    Ext.getCmp("OPERSurgeonDeptDr").setValue(getStr(text));
	    */
	     if(HOSPRowIds!=""){
	   		 textHOSP=HOSPRowIds;
	    }else{
	    	textHOSP="";
	    }
		Ext.getCmp("OPERHospitalDr").setValue(textHOSP);
	});
	gridHOSP.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtnHOSP');
	 	if(btn){
	 	  if (gridHOSP.selModel.hasSelection()) {
	 		
	 		var SaveFlag = gridHOSP.getSelectionModel().getSelections()[0].get('SaveFlag');
	 		if (SaveFlag!="Y")
	 		{
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'HOSPRowId':gridHOSP.getSelectionModel().getSelections()[0].get('HOSPRowId'),
					'SaveFlag':'N',
					'HOSPDesc':gridHOSP.getSelectionModel().getSelections()[0].get('HOSPDesc')
			 	});
			 	gridUnSelHOSP.stopEditing();
			 	dsUnSelHOSP.insert(0,_record);
			 	
			 	
			 	//已选列表删除
			 	HospStr=HospStr.replace("<"+gridHOSP.getSelectionModel().getSelections()[0].get('HOSPDesc')+">","");//2016-8-11
	 			
			 	
	 			var myrecord=gridHOSP.getSelectionModel().getSelected();
			 	dsHOSP.remove(myrecord);
	 			//页面病症框显示值
	 			var HOSPDescs="";
	 			var HOSPRowIds="";
			    dsHOSP.each(function(record){
			    	if(HOSPDescs==""){
			    		HOSPDescs = record.get('HOSPDesc');
			    	}else{
			    		HOSPDescs = HOSPDescs+","+record.get('HOSPDesc');
			    	}
			    	
			    	if(HOSPRowIds==""){
			    		HOSPRowIds = record.get('HOSPRowId');
			    	}else{
			    		HOSPRowIds = HOSPRowIds+"|"+record.get('HOSPRowId');
			    	}
			    }, this);
			    Ext.getCmp("OPERHospitalDrDesc").setValue(HOSPDescs);

			 
				if(HOSPRowIds!=""){
			   		 text=HOSPRowIds;
			    }else{
			    	text="";
			    }
				Ext.getCmp("OPERHospitalDr").setValue(text);
	 		}else{
	 			var operrowid = Ext.getCmp('grid').getSelectionModel().getSelections()[0].get('OPERRowId');
	 			var HOSPRowId = grid.getSelectionModel().getSelections()[0].get('HOSPRowId');
				Ext.Ajax.request({
					url : DELETE_Hosp_URL,
					method : 'POST',
					params : {
						hosprowid: HOSPRowId,
						operrowid:operrowid
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								
								var _record = new Ext.data.Record({
									'HOSPRowId':gridHOSP.getSelectionModel().getSelections()[0].get('HOSPRowId'),
									'SaveFlag':'N',
							 		'HOSPDesc':gridHOSP.getSelectionModel().getSelections()[0].get('HOSPDesc')
							 	});
							 	gridUnSelHOSP.stopEditing();
							 	dsUnSelHOSP.insert(0,_record);

						       var myrecord=gridHOSP.getSelectionModel().getSelected();
	 						   dsHOSP.remove(myrecord);
	 						   //页面病症框显示值
								var HOSPDescs="";
					 			var HOSPRowIds="";
							    dsHOSP.each(function(record){
							    	if(HOSPDescs==""){
							    		HOSPDescs = record.get('HOSPDesc');
							    	}else{
							    		HOSPDescs = HOSPDescs+","+record.get('HOSPDesc');
							    	}
							    	
							    	if(HOSPRowIds==""){
							    		HOSPRowIds = record.get('HOSPRowId');
							    	}else{
							    		HOSPRowIds = HOSPRowIds+"|"+record.get('HOSPRowId');
							    	}
							    }, this);
							    Ext.getCmp("OPERHospitalDrDesc").setValue(HOSPDescs);
				
							    if(HOSPRowIds!=""){
							   		 text=HOSPRowIds;
							    }else{
							    	text="";
							    }
								Ext.getCmp("OPERHospitalDr").setValue(text);
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
	 	  }
	 	}
	});
	
	////医院多选结束↑↑↑↑↑↑↑↑↑↑↑↑↑↑
	
	
	
	////ofy3树形手术分类  2017-12-01 
	/*
	 var comboTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPOperationCategory&pClassMethod=GetTreeComboJson"; 
	
	var comboTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: comboTREE_ACTION_URL
			});
	var OPERBDPOperationCategoryDR = new Ext.ux.TreeCombo({
				name:'OPERBDPOperationCategoryDR',
				id:'OPERBDPOperationCategoryDR1',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERBDPOperationCategoryDR1'),
				fieldLabel:"树形手术分类",
				width:160,
				hiddenName : 'OPERBDPOperationCategoryDR',
				root: comboroot=new Ext.tree.AsyncTreeNode({
						id:"CatTreeRoot",
						text:"菜单",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: comboTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false
			});	
			
	
			
	var comboTreeLoader1 = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: comboTREE_ACTION_URL
			});
	var OPERBDPOperationCategoryDR2 = new Ext.ux.TreeCombo({
				id:'OPERBDPOperationCategoryDR2',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERBDPOperationCategoryDR2'),
				fieldLabel:"树形手术分类",
				width:160,
				root: comboroot=new Ext.tree.AsyncTreeNode({
						id:"CatTreeRoot",
						text:"菜单",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: comboTreeLoader1,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false
			});	
	*/
	///ofy3  ↑↑↑↑↑
			
			
			
			
	// 增加和修改使用的form
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',								
				title : '基本信息',
				//URL:SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				// region: 'west',
				labelAlign : 'right', //标签对齐方式
				labelWidth :125,
				autoScroll : true,
				//monitorValid:true,
				split : true,
				frame : true,//Panel具有全部阴影,若为false则只有边框有阴影
				defaults : {
					anchor : '97%',
					bosrder : false
				},
				reader: new Ext.data.JsonReader({root:'list'},
		           [{name: 'OPERCode',mapping:'OPERCode'},
		       		{name: 'OPERDesc',mapping:'OPERDesc'},
		       		{name: 'OPERARCIMDR',mapping:'OPERARCIMDR'},
		       		{name: 'OPERDateActiveFrom',mapping:'OPERDateActiveFrom'},
		       		{name: 'OPERActiveDateTo',mapping:'OPERActiveDateTo'},
		       		{name: 'OPERDefaultCategoryDR',mapping:'OPERDefaultCategoryDR'},
		       		{name: 'OPERAgeFrom',mapping:'OPERAgeFrom'},
		       		{name: 'OPERAgeTo',mapping:'OPERAgeTo'},
		       		{name: 'OPERSexDR',mapping:'OPERSexDR'},
		       		{name: 'OPERVersionDictDR',mapping:'OPERVersionDictDR'},
		       		{name: 'OPERICD10',mapping:'OPERICD10'},
		       		{name: 'OPERICD9Map',mapping:'OPERICD9Map'},
		       		{name: 'OPERValid',mapping:'OPERValid'},
		       		{name: 'OPERDaySurgery',mapping:'OPERDaySurgery'},
		       		
		       		{name: 'OPERAgeFrom1',mapping:'OPERAgeFrom1'},
		       		{name: 'OPERAgeTo1',mapping:'OPERAgeTo1'},
		       		{name: 'OPERLongDescription',mapping:'OPERLongDescription'},
		       		{name: 'OPERInsuCode',mapping:'OPERInsuCode'},
		       		{name: 'OPERInsuDesc',mapping:'OPERInsuDesc'},
		       		{name: 'OPERRowId',mapping:'OPERRowId'}
		       		
		       		,{name: 'OPERClassDr',mapping:'OPERClassDr'},
		       		{name: 'OPERStandardClassDR',mapping:'OPERStandardClassDR'},
		       		{name: 'OPERBladeDr',mapping:'OPERBladeDr'},
		       		{name: 'OPERBodySiteDr',mapping:'OPERBodySiteDr'},
		       		{name: 'OPEROperPositionDr',mapping:'OPEROperPositionDr'},
		       		{name: 'OPERSurgeonDeptDr',mapping:'OPERSurgeonDeptDr'},
		       		{name: 'OPERSurgeonDeptDrDesc',mapping:'OPERSurgeonDeptDrDesc'},
		       		{name: 'OPERIsKeyOperation',mapping:'OPERIsKeyOperation'},
		       		{name: 'OPERScrubNurseClass',mapping:'OPERScrubNurseClass'},
		       		{name: 'OPERCirculNurseClass',mapping:'OPERCirculNurseClass'},
		       		{name: 'OPERDefaultOperLocDr',mapping:'OPERDefaultOperLocDr'},
		       		{name: 'OPERType',mapping:'OPERType'},
		       		{name: 'OPERApplyFeature',mapping:'OPERApplyFeature'},
		       		{name: 'OPERRegType',mapping:'OPERRegType'},
		       		{name: 'OPERCategoryDr',mapping:'OPERCategoryDr'},
		       		{name: 'OPERIsUploadCode',mapping:'OPERIsUploadCode'},
		       		{name: 'OPERTechnique',mapping:'OPERTechnique'},
		       		{name: 'OPERMedicalTechniqueLevel',mapping:'OPERMedicalTechniqueLevel'},
		       		{name: 'OPERIsSpecial',mapping:'OPERIsSpecial'},
		       		{name: 'OPERIsHighRisk',mapping:'OPERIsHighRisk'},
		       		{name: 'OPERIsAudit',mapping:'OPERIsAudit'},
		       		{name: 'OPERIsPacs',mapping:'OPERIsPacs'},
		       		{name: 'OPERIsSupplierPreparation',mapping:'OPERIsSupplierPreparation'},
		       		{name: 'OPERIsProtectiveAntibacterial',mapping:'OPERIsProtectiveAntibacterial'},
		       		{name: 'OPERHospitalDr',mapping:'OPERHospitalDr'},
		       		{name: 'OPERIsMinInvasive',mapping:'OPERIsMinInvasive'},
		       		{name: 'OPERIsSubOperation',mapping:'OPERIsSubOperation'},
		       		{name: 'OPERIsRestrictedTechnology',mapping:'OPERIsRestrictedTechnology'},
		       		{name: 'OPERIsNewItem',mapping:'OPERIsNewItem'},
		       		{name: 'OPERHospitalDrDesc',mapping:'OPERHospitalDrDesc'},
		       		///ofy3
		       		///{name: 'OPERBDPOperationCategoryDR',mapping:'OPERBDPOperationCategoryDR'},
		       		{name: 'OPERAbbreviation',mapping:'OPERAbbreviation'},
		       		{name: 'OPERGrayCodeFlag',mapping:'OPERGrayCodeFlag'}
		          ]),
			items : [{
							xtype:'fieldset',
							title:'手术信息',
							items:[
			{
				layout:'column',
				baseCls : 'x-plain',//form透明,不显示框框
				items:[
					{
						columnWidth:.34,
						baseCls : 'x-plain',//form透明,不显示框框
						//frame:true,
						layout:'form',
						items:[
							{
								fieldLabel : '<font color=red>*</font>代码',
								xtype:'textfield',
								id:'OPERCode',
								maxLength:15,
								width:160,
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERCode'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERCode'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERCode')),
								name : 'OPERCode',
								allowBlank:false
							}, {
								fieldLabel : '<font color=red>*</font>描述',
								xtype:'textfield',
								id:'OPERDesc',
								maxLength:220,
								width:160,
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERDesc'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERDesc'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERDesc')),
								name : 'OPERDesc',
								allowBlank:false
							},{
								xtype : 'bdpcombo',
                allowBlank:false,
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								listWidth : 250,
								width:160,
								loadByIdParam : 'rowid',
								fieldLabel : '<font color=red>*</font>版本',
								name:'OPERVersionDictDR',
								hiddenName : 'OPERVersionDictDR',
								id:'OPERVersionDictDRF',
	   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERVersionDictDRF'),
	   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERVersionDictDRF')),
								store : new Ext.data.Store({
									//autoLoad : true,
									proxy : new Ext.data.HttpProxy({ url : VersionDictDR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
												totalProperty : 'total',
												root : 'data',
												successProperty : 'success'
											}, [ 'ID', 'VersionName' ])
								}),
								mode : 'remote',
								queryParam : 'desc',
								//triggerAction : 'all',
								forceSelection : true,
								selectOnFocus : false,
								//typeAhead : true,
								//minChars : 1,
								valueField : 'ID',
								displayField : 'VersionName'
              }, {
								xtype : 'datefield',
								fieldLabel : '<font color=red>*</font>开始日期',
								name : 'OPERDateActiveFrom',
								format : BDPDateFormat,
								width:160,
								id:'date1',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
								vtype:'cKDate',
								allowBlank:false
							}, {
								xtype : 'datefield',
								fieldLabel : '结束日期',
								name : 'OPERActiveDateTo',
								format : BDPDateFormat,
								width:160,
								id:'date2',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
								vtype:'cKDate'
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '手术分级',
								id : 'OPERDefaultCategoryDR1',
								hiddenName : 'OPERDefaultCategoryDR',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERDefaultCategoryDR1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERDefaultCategoryDR1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : DefaultCategory_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'CATEGRowId',mapping:'CATEGRowId'},
											{name:'CATEGDesc',mapping:'CATEGDesc'} ]
									)
								}),
								mode : 'local',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'CATEGDesc',
								valueField : 'CATEGRowId',
								listeners:  ///同步两个手术分级
								{
									'select' : function(combo, record, index) {
										
										var value = Ext.getCmp('OPERDefaultCategoryDR1').getValue();
										if (value!="")
										{
											var display = Ext.getCmp('OPERDefaultCategoryDR1').getRawValue();
											Ext.getCmp("OPERClassDr1").setValue(value);
											Ext.getCmp("OPERClassDr1").setRawValue(display);
										}
										
									},
									'keyup':function(){
										
									var value = Ext.getCmp('OPERDefaultCategoryDR1').getValue();
										if (value!="")
										{
											var display = Ext.getCmp('OPERDefaultCategoryDR1').getRawValue();
											Ext.getCmp("OPERClassDr1").setValue(value);
											Ext.getCmp("OPERClassDr1").setRawValue(display);
										}
									}
								}
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								//emptyText:'请选择',
								fieldLabel : '默认医嘱项',
								hiddenName : 'OPERARCIMDR',
								id :'OPERARCIMDR1',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERARCIMDR1'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERARCIMDR1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERARCIMDR1')),
								width:160,
								store :arcimds,
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'ARCIMDesc',
								valueField : 'ARCIMRowId'
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '国家标准分级',
								id : 'OPERStandardClassDR1',
								hiddenName : 'OPERStandardClassDR',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERStandardClassDR1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERStandardClassDR1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : DefaultCategory_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'CATEGRowId',mapping:'CATEGRowId'},
											{name:'CATEGDesc',mapping:'CATEGDesc'} ]
									)
								}),
								mode : 'local',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'CATEGDesc',
								valueField : 'CATEGRowId'
							}
						]
					},{
						columnWidth:.33,
						baseCls : 'x-plain',//form透明,不显示框框
						//frame:true,
						//style:'padding:10px 0 10px 10px',
						layout:'form',
						items:[{
								fieldLabel : 'ICD10代码',
								xtype:'textfield',
								id:'OPERICD10',
								maxLength:30,
								width:160,
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERICD10'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERICD10'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERICD10')),
								name : 'OPERICD10'
							}, {
								fieldLabel : 'ICD9 Map',
								xtype:'textfield',
								id:'OPERICD9Map',
								maxLength:30,
								width:160,
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERICD9Map'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERICD9Map'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERICD9Map')),
								name : 'OPERICD9Map'
							},{
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								//emptyText:'请选择',
								fieldLabel : '限制性别',
								hiddenName : 'OPERSexDR',
								id :'OPERSexDR1',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERSexDR1'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERSexDR1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERSexDR1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : Sex_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'CTSEXRowId',mapping:'CTSEXRowId'},
											{name:'CTSEXDesc',mapping:'CTSEXDesc'} ]
									)
								}),
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'CTSEXDesc',
								valueField : 'CTSEXRowId'
							},{
								fieldLabel: '有效性',
								xtype : 'checkbox',
								name : 'OPERValid',
								id:'OPERValid',
								checked:true,   ///默认有效
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERValid'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERValid'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERValid')),
								inputValue : true?'Y':'N'
							
							},{
								fieldLabel : '详细描述',
								xtype:'textarea',
								width:160,
								maxLength:255,
								id:'OPERLongDescription',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERLongDescription'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERLongDescription'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERLongDescription')),
								name : 'OPERLongDescription'
								//allowBlank:false
							
							},{
								fieldLabel: '医保灰码',
								xtype : 'checkbox',
								name : 'OPERGrayCodeFlag',
								id:'OPERGrayCodeFlag',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERGrayCodeFlag'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERGrayCodeFlag')),
								inputValue : true?'Y':'N'
							
							}
						]			
					},
					
					{
						columnWidth:.33,
						baseCls : 'x-plain',//form透明,不显示框框
						//frame:true,
						layout:'form',
						items:[
							{
								fieldLabel : '从年龄',
								xtype:'numberfield',
								id:'OPERAgeFrom',
								maxLength:30,
								vtype:'cKAge1',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeFrom'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeFrom'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERAgeFrom')),
								minValue : 0,
								maxValue : 200,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								//nanText:'年龄只能是正整数'
								name : 'OPERAgeFrom'
								//allowBlank:false
							}, {
								fieldLabel : '到年龄',
								xtype:'numberfield',
								id:'OPERAgeTo',
								maxLength:30,
								vtype:'cKAge1',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeTo'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeTo'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERAgeTo')),
								minValue : 0,
								maxValue : 200,
								allowNegative : false, //不允许输入负数
								allowDecimals : false, //不允许输入小数
								//nanText : '年龄只能是正整数'
								name : 'OPERAgeTo'
								//allowBlank:false
							},{
								fieldLabel : '从限制年龄',
								xtype:'numberfield',
								id:'OPERAgeFrom1',
								maxLength:30,
								vtype:'cKAge2',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeFrom1'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeFrom1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERAgeFrom1')),
								stripCharsRe :  ' ',
								minValue : 0,
								maxValue : 200,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								//nanText:'年龄只能是正整数'
								name : 'OPERAgeFrom1'
								//allowBlank:false
							},{
								fieldLabel : '到限制年龄',
								xtype:'numberfield',
								id:'OPERAgeTo1',
								vtype:'cKAge2',
								maxLength:30,
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeTo1'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERAgeTo1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERAgeTo1')),
								minValue : 0,
								maxValue : 200,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								//nanText:'年龄只能是正整数'
								name : 'OPERAgeTo1'
								//allowBlank:false
							},{
								fieldLabel: '日间手术',
								xtype : 'checkbox',
								name : 'OPERDaySurgery',
								id:'OPERDaySurgery',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERDaySurgery'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERDaySurgery')),
								inputValue : true?'Y':'N',
								hideLabel : 'True',
								hidden : true
							},{
								fieldLabel : '国家医保编码',
								xtype:'textfield',
								id:'OPERInsuCode',
								maxLength:200,
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERInsuCode'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuCode')),
								name : 'OPERInsuCode'
							},{
								fieldLabel : '国家医保名称',
								xtype:'textfield',
								id:'OPERInsuDesc',
								maxLength:200,
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERInsuDesc'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuDesc')),
								name : 'OPERInsuDesc'
							},{
								id:'OPERRowId',
								xtype:'textfield',
								fieldLabel : 'OPERRowId',
								name : 'OPERRowId',
								hideLabel : 'True',
								hidden : true
							}
						]
					}
					
				]
		}]
		
			},{
							xtype:'fieldset',
							title:'扩展信息',
							items:[
			{
				layout:'column',
				baseCls : 'x-plain',//form透明,不显示框框
				items:[
					{
						columnWidth:.34,
						baseCls : 'x-plain',//form透明,不显示框框
						//frame:true,
						layout:'form',
						items:[
							{
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '手术分级',
								id : 'OPERClassDr1',
								hideLabel : 'True',  //2019-01-20隐藏
								hidden : true,
								hiddenName : 'OPERClassDr',
								readOnly : true,
								style:Ext.BDP.FunLib.ReadonlyStyle(true),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : DefaultCategory_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'CATEGRowId',mapping:'CATEGRowId'},
											{name:'CATEGDesc',mapping:'CATEGDesc'} ]
									)
								}),
								mode : 'local',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								
								//hideTrigger: false,
								displayField : 'CATEGDesc',
								valueField : 'CATEGRowId'
							
							
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '手术切口类型',
								hiddenName : 'OPERBladeDr',
								id :'OPERBladeDr1',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERBladeDr1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERBladeDr1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : ORCBladeType_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'BLDTPRowId',mapping:'BLDTPRowId'},
											{name:'BLDTPDesc',mapping:'BLDTPDesc'} ]
									)
								}),
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								displayField : 'BLDTPDesc',
								valueField : 'BLDTPRowId'
							
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '手术部位',
								hiddenName : 'OPERBodySiteDr',
								id :'OPERBodySiteDr1',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERBodySiteDr1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERBodySiteDr1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : OECBodySite_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'BODSRowId',mapping:'BODSRowId'},
											{name:'BODSDesc',mapping:'BODSDesc'} ]
									)
								}),
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'BODSDesc',
								valueField : 'BODSRowId'
							
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '手术体位',
								hiddenName : 'OPEROperPositionDr',
								id :'OPEROperPositionDr1',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPEROperPositionDr1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPEROperPositionDr1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : ORCOperPosition_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'OPPOSRowId',mapping:'OPPOSRowId'},
											{name:'OPPOSDesc',mapping:'OPPOSDesc'} ]
									)
								}),
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								//triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'OPPOSDesc',
								valueField : 'OPPOSRowId'
							
							}, {
								xtype : 'bdpcombo',
								pageSize : Ext.BDP.FunLib.PageSize.Combo,
								loadByIdParam : 'rowid',
								listWidth:250,
								fieldLabel : '默认手术室',
								hiddenName : 'OPERDefaultOperLocDr',
								id :'OPERDefaultOperLocDr1',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERDefaultOperLocDr1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERDefaultOperLocDr1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : CTLoc_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'CTLOCRowID',mapping:'CTLOCRowID'},
											{name:'CTLOCDesc',mapping:'CTLOCDesc'} ]
									)
								}),
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								displayField : 'CTLOCDesc',
								valueField : 'CTLOCRowID',
								 listeners:{
									   'beforequery': function(e){
											this.store.baseParams = {
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
								fieldLabel : '手术分类',
								hiddenName : 'OPERCategoryDr',    ///User.DHCANCOperationCat
								id :'OPERCategoryDr1',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERCategoryDr1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERCategoryDr1')),
								width:160,
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : ANCOperCat_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'ANCOCRowId',mapping:'ANCOCRowId'},
											{name:'ANCOCDesc',mapping:'ANCOCDesc'} ]
									)
								}),
								mode : 'local',
								shadow:false,
								queryParam : 'desc',
								forceSelection : true,
								selectOnFocus : false,
								displayField : 'ANCOCDesc',
								valueField : 'ANCOCRowId'	
						}, {
								fieldLabel : '手术缩写',
								xtype:'textfield',
								id:'OPERAbbreviation',
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERAbbreviation'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERAbbreviation')),
								name : 'OPERAbbreviation'
								
						},
						///ofy3
						//OPERBDPOperationCategoryDR,
								{
							xtype : 'fieldset',
							title : '手术医生科室',
							width:275,
							autoHeight : true,
							style:'margin-left:0px', 
							items:[{layout : 'column',
							border : false,
							items : [{
									width:220,
									layout : 'form',
									labelWidth : 50,
									labelPad : 1,// 默认5
									border : false,
									style:'margin-left:1px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [OPERSurgeonDeptDrDesc]
								},{
									width:20,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%',
										msgTarget : 'under'
									},
									items : [BtnCTLoc]
								}]},  gridCTLoc
								]
							}, {
								hideLabel : 'True',
								hidden : true,
								fieldLabel : '手术医生科室Id("|")',
								xtype:'textfield',
								id:'OPERSurgeonDeptDr',
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERSurgeonDeptDr'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERSurgeonDeptDr')),
								name : 'OPERSurgeonDeptDr'
							
							}
						]
					},{
						columnWidth:.33,
						baseCls : 'x-plain',//form透明,不显示框框
						//frame:true,
						style:'padding:0 0 10px 10px',  ///不加这句这三列会都跑到第一列去  20160824
						layout:'form',
						items:[
							{
								fieldLabel : '手术操作类别',
								xtype : 'combo',
								hiddenName: 'OPERType',
								id : 'OPERType1',
			   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERType1')),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERType1'),
								width : 160,
								mode : 'local',
								triggerAction : 'all',// query
								forceSelection : true,
								selectOnFocus : false,
								listWidth : 160,
								valueField : 'value',
								displayField : 'name',
								store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : '手术',
												value : 'N'
											}, {
												name : '诊断性操作',
												value : 'D'
											}, {
												name : '治疗性操作',
												value : 'T'
											}, {
												name : '介入治疗',
												value : 'I'
											}]
								})
							
							},{
								fieldLabel : '登记类型',
								xtype : 'combo',
								hiddenName: 'OPERRegType',
								id : 'OPERRegType1',
			   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERRegType1')),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERRegType1'),
								width : 160,
								mode : 'local',
								triggerAction : 'all',// query
								forceSelection : true,
								selectOnFocus : false,
								listWidth : 160,
								valueField : 'value',
								displayField : 'name',
								store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : '标本登记本',
												value : '标本登记本'
											}, {
												name : '特殊病人登记本',
												value : '特殊病人登记本'
											}, {
												name : '手术登记本',
												value : '手术登记本'
											}, {
												name : '结扎手术登记本',
												value : '结扎手术登记本'
											}]
								})
								},{
								
								fieldLabel : '使用技术',
								xtype : 'combo',
								hiddenName: 'OPERTechnique',
								id : 'OPERTechniqueF',
			   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERTechniqueF')),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERTechniqueF'),
								width : 160,
								mode : 'local',
								triggerAction : 'all',// query
								forceSelection : true,
								selectOnFocus : false,
								listWidth : 160,
								valueField : 'value',
								displayField : 'name',
								store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{ 
												name : '内镜',  
												value : 'E'  //Endoscope
											}, {
												name : '腔镜',
												value : 'L'   //Laparoscope
											}, {
												name : '普通',
												value : 'N'  //Normal  //开放手术  ofy2
											}, {
												name : '介入',
												value : 'I'  //Intervention
											}, {
												name : '操作',
												value : 'I'  //Procedure
											}]
								})
								
							},{
								
								fieldLabel : '器械护士分级',
								xtype:'textfield',
								id:'OPERScrubNurseClass',
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERScrubNurseClass'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERScrubNurseClass')),
								name : 'OPERScrubNurseClass'
							}, {
								fieldLabel : '巡回护士分级',
								xtype:'textfield',
								id:'OPERCirculNurseClass',
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERCirculNurseClass'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERCirculNurseClass')),
								name : 'OPERCirculNurseClass'
							},{
								
								fieldLabel : '医疗技术级别要求',
								xtype:'textfield',
								id:'OPERMedicalTechniqueLevel',
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERMedicalTechniqueLevel'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERMedicalTechniqueLevel')),
								name : 'OPERMedicalTechniqueLevel'
							},{
								fieldLabel : '手术应用特性',
								xtype : 'combo',
								hiddenName: 'OPERApplyFeature', 
								id : 'OPERApplyFeature1',
			   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERApplyFeature1')),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERApplyFeature1'),
								width : 160,
								mode : 'local',
								triggerAction : 'all',// query
								forceSelection : true,
								selectOnFocus : false,
								listWidth : 160,
								valueField : 'value',
								displayField : 'name',
								store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : '必选',
												value : 'R'
											}, {
												name : '中医必选',
												value : 'C'
											}, {
												name : '选择性',
												value : 'O'
											
											}]
								})
								},{
							xtype : 'fieldset',
							title : '医院',
							width:275,
							autoHeight : true,
							style:'margin-left:0px', 
							items:[{layout : 'column',
							border : false,
							items : [{
									width:220,
									layout : 'form',
									labelWidth : 50,
									labelPad : 1,// 默认5
									border : false,
									style:'margin-left:1px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [OPERHospitalDrDesc]
								},{
									width:20,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%',
										msgTarget : 'under'
									},
									items : [BtnHOSP]
								}]},gridHOSP]
							
							}, {
								hideLabel : 'True',
								hidden : true,
								fieldLabel : '医院Id("|")',
								xtype:'textfield',
								id:'OPERHospitalDr',
								width:160,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERHospitalDr'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERHospitalDr')),
								name : 'OPERHospitalDr'
						
							}
						]
					},{
						columnWidth:.33,
						baseCls : 'x-plain',//form透明,不显示框框
						//frame:true,
						//style:'padding:10px 0 10px 10px',
						layout:'form',
						items:[{
								boxLabel: '重点手术',
								xtype : 'checkbox',
								name : 'OPERIsKeyOperation',
								id:'OPERIsKeyOperation',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsKeyOperation'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsKeyOperation')),
								inputValue : 'Y'
							}, {
								boxLabel: '有上传编码',
								xtype : 'checkbox',
								name : 'OPERIsUploadCode',
								id:'OPERIsUploadCode',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsUploadCode'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsUploadCode')),
								inputValue : 'Y'
								
							},{
								boxLabel: '特殊手术',
								xtype : 'checkbox',
								name : 'OPERIsSpecial',
								id:'OPERIsSpecial',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsSpecial'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsSpecial')),
								inputValue : 'Y'
							
							},{
								boxLabel: '高风险技术',
								xtype : 'checkbox',
								name : 'OPERIsHighRisk',
								id:'OPERIsHighRisk',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsHighRisk'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsHighRisk')),
								inputValue : 'Y'
							},{
								boxLabel: '审批技术',
								xtype : 'checkbox',
								name : 'OPERIsAudit',
								id:'OPERIsAudit',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsAudit'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsAudit')),
								inputValue : 'Y'
							},{
								boxLabel: '有PACS影像',
								xtype : 'checkbox',
								name : 'OPERIsPacs',
								id:'OPERIsPacs',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsPacs'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsPacs')),
								inputValue : 'Y'
							},{
								boxLabel: '供应商备货',
								xtype : 'checkbox',
								name : 'OPERIsSupplierPreparation',
								id:'OPERIsSupplierPreparation',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsSupplierPreparation'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsSupplierPreparation')),
								inputValue : '1'	
							},{
								boxLabel: '使用预防性抗菌药物',
								xtype : 'checkbox',
								name : 'OPERIsProtectiveAntibacterial',
								id:'OPERIsProtectiveAntibacterial',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsProtectiveAntibacterial'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsProtectiveAntibacterial')),
								inputValue : '1'	
							},{
								boxLabel: '微创手术',
								xtype : 'checkbox',
								name : 'OPERIsMinInvasive',
								id:'OPERIsMinInvasive',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsMinInvasive'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsMinInvasive')),
								inputValue : 'Y'	
							},{
								boxLabel: '子手术',
								xtype : 'checkbox',
								name : 'OPERIsSubOperation',
								id:'OPERIsSubOperation',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsSubOperation'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsSubOperation')),
								inputValue : 'Y'	
							},{
								boxLabel: '限制类技术',
								xtype : 'checkbox',
								name : 'OPERIsRestrictedTechnology',
								id:'OPERIsRestrictedTechnology',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsRestrictedTechnology'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsRestrictedTechnology')),
								inputValue : 'Y'	
							},{
								boxLabel: '新项目新技术',
								xtype : 'checkbox',
								name : 'OPERIsNewItem',
								id:'OPERIsNewItem',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPERIsNewItem'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPERIsNewItem')),
								inputValue : 'Y'	
							}
						]			
					}
					
					
					
				]
			}]
		
			}
		]
	});
	
	
	
	
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 deferredRender :false,		//是否延迟渲染，缺省时为true，
				 height : 200,
				 items : [WinForm,linkgrid,AliasGrid]
				
			 });				
	var height=Math.min(Ext.getBody().getViewSize().height-30,830)		
	// 增加修改弹出的窗口
	var win = new Ext.Window({
		title : '',
		width : 1060,
		minWidth:1060,
		height: height,
		layout : 'fit',
		plain : true,
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
				
				
				///重复校验   rowid,代码，描述，医院，结束日期
                var flag = tkMakeServerCall("web.DHCBL.CT.ORCOperation","FormValidate",Ext.getCmp("OPERRowId").getValue(),Ext.getCmp("OPERCode").getValue(),Ext.getCmp("OPERDesc").getValue(),hospComp.getValue(),Ext.getCmp("date2").getRawValue())
    			if(flag == "1"){
                 	Ext.Msg.show({ title : '提示', msg : '该代码和描述已经存在!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                 	return;
                }
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				var ageFrom = Ext.getCmp("form-save").getForm().findField("OPERAgeFrom").getValue();
				var ageTo = Ext.getCmp("form-save").getForm().findField("OPERAgeTo").getValue();
				var ageFrom1 = Ext.getCmp("form-save").getForm().findField("OPERAgeFrom1").getValue();
				var ageTo1 = Ext.getCmp("form-save").getForm().findField("OPERAgeTo1").getValue();
				if (ageFrom!="" && ageTo!="")
			 	{
	    			if (ageFrom > ageTo) {
	    				Ext.Msg.show({
	    					title : '提示',
							msg : '"从年龄"不能大于"到年龄"！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
	      			 	return;
	  				}
			 	}
			 	if (ageFrom1!="" && ageTo1!="")
			 	{
	    			if (ageFrom1 > ageTo1) {
	    				Ext.Msg.show({
	    					title : '提示',
							msg : '"限制年龄从"不能大于"限制年龄到"！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
	      			 	return;
	  				}
			 	}
				//-------添加----------
				if ((win.title == "添加")||(win.title == "快速复制")) {
					WinForm.form.submit({
						clientValidation : true,//进行客户端验证
						waitMsg : '正在提交数据请稍候...',
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
						//下面有两种不同类型的success对象其表示的意义有所不同
						// ①是submit的一个配置选项 表示服务器成功响应。不管你响应给客户端的内容是什么
						// 只要响应成功就会执行这个success,跟你返回的内容无关
						// ②是根据返回json中success属性判断的,如果success为true,则success否则 failure
						success : function(form, action) {              
							if (action.result.success == 'true') {//如果json中success属性返回的为true
								
								win.hide();
								var myrowid = action.result.id;	
								
								//保存关联医嘱项
								if (win.title == "添加")
								{
									savelink(action.result.id)
								}
								if (win.title == "快速复制")
								{
									copysavelink(action.result.id)
								}
								//alert(myrowid)
								//添加时 同时保存别名
								AliasGrid.ALIASParRef = myrowid;
								AliasGrid.saveAlias();
								
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												
												var startIndex = grid.getBottomToolbar().cursor;//获取当前页开始的记录数
												grid.getStore().load({       
															params : {//参数
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
								
								///2016-3-1 chenying
								var pinyins=Pinyin.GetJPU(Ext.getCmp("OPERDesc").getValue());
								var aliastext=""+"^"+pinyins+"^"+myrowid
								var aliaspinyin= tkMakeServerCall("web.DHCBL.CT.ORCOperationAlias","SaveAll",aliastext)

								
							} 
							else {//如果jason中success属性返回的不是true
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
						/*failure : function(form, action) {//服务器端响应失败
							 if(action.failureType == 'client'){
                                  //客户端数据验证失败的情况下
                                  Ext.Msg.alert('提示','数据验证失败,<br/>请检查您的数据格式是否有误！');
								}
								else Ext.Msg.alert('提示', '添加失败！');
						}*/
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！！');
						}
					})
				} 
				//---------修改)-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({ 
								clientValidation : true,
								//waitMsg : '正在提交数据请稍候...',
								//waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
								success : function(form, action) {
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									// alert(action);
									if (action.result.success == 'true') {
										
										win.hide();
										var myrowid = "rowid="+action.result.id;
										
										
										savelink(action.result.id)
										Ext.Msg.show({
														title : '提示',
														msg : '修改成功！',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															
															var startIndex = grid.getBottomToolbar().cursor;
															Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
															
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
								}  ,
							/*
								failure : function(form, action) {
								switch (action.failureType) {
								    case Ext.form.Action.CLIENT_INVALID:
									       Ext.Msg.alert('Failure', '客户端的表单验证出现错误！');
									break;
									case Ext.form.Action.CONNECT_FAILURE:
									       Ext.Msg.alert('Failure', '远程服务器发送请求遇到通信错误！');
									break;
									case Ext.form.Action.SERVER_INVALID:
										Ext.Msg.alert('Failure', '服务器端数据验证失败！');
								 }
								}
								*/
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！！');
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
				Ext.getCmp("form-save").getForm().findField("OPERCode").focus(true,600);
				
				
				//grid.setDisabled(true); //Form打开后grid灰化
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
				Ext.getCmp("tbLINKARCIMDR").reset();
				LocStr="",HospStr="";
				////保存数据的时候 把科室未选框、医院未选框也隐藏掉
				WinCTLoc.hide();
				WinHOSP.hide();
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
					linkgrid.getStore().baseParams={
						linkparref : ""	
					};
					linkgrid.getStore().load({
						params : {
							/*start : 0,
							limit : pagesize1*/
						}
					});	
					dsCTLoc.baseParams={
						operrowid:''	
					};
					dsCTLoc.load();
									
					dsHOSP.baseParams={
						operrowid:''
					};
					dsHOSP.load();
					
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
					////ofy1 兰大一院   自动生成最大代码  S开头 六位
					var MaxCode = tkMakeServerCall("web.DHCBL.CT.ORCOperation","AutoCreateCode");
					Ext.getCmp("OPERCode").setValue(MaxCode) 
					
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.ALIASParRef = "";
		            AliasGrid.clearGrid();
		            
		            //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
		            var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"ORC_Operation");
		            if (InsuConfig=="INSU")
		            {
		            	Ext.getCmp("OPERInsuCode").setDisabled(true);
		            	Ext.getCmp("OPERInsuDesc").setDisabled(true);
		            }
		            else
			        {
				        Ext.getCmp("OPERInsuCode").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuCode'));
			        	Ext.getCmp("OPERInsuDesc").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuDesc'));
			        }
				},
				scope : this
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
				            AliasGrid.ALIASParRef = _record.get('OPERRowId');
					        AliasGrid.loadGrid();
					        
					        
					        //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
					        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"ORC_Operation");
				            if (InsuConfig=="INSU")
				            {
				            	Ext.getCmp("OPERInsuCode").setDisabled(true);
				            	Ext.getCmp("OPERInsuDesc").setDisabled(true);
				            }
				            else
					        {
						        Ext.getCmp("OPERInsuCode").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuCode'));
					        	Ext.getCmp("OPERInsuDesc").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuDesc'));
					        }
					        
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
	 // 载入被选择的数据行的表单数据
    var copyloadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('提示','请先选择一项手术/过程！');
        } 
        else {
        	linkgrid.getStore().baseParams={
						linkparref : grid.getSelectionModel().getSelected().get('OPERRowId')	
			};
			linkgrid.getStore().load({
				params : {
						cflag:1/*,
						start : 0,
						limit : pagesize1*/
				}
			});	
			dsCTLoc.baseParams={
				operrowid:''		
			};
			dsCTLoc.load();
							
			dsHOSP.baseParams={
				operrowid:''
			};
			dsHOSP.load();
			
            WinForm.form.load( {
                url : COPY_ACTION_URL + '&id='+ _record.get('OPERRowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                    //Ext.Msg.alert(action);
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
            
        }
    };		
	// 复制按钮
	var btncopywin = new Ext.Toolbar.Button({
				text : '快速复制',
				iconCls : 'icon-add',
				id:'copy_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('copy_btn'),
				handler : CopyData=function() {	
						if (grid.selModel.hasSelection()) {
						win.setTitle('快速复制');
						win.setIconClass('icon-add');
						win.show();
						copyloadFormData(grid);
						//WinFormExtend.getForm().reset();
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //清空别名面板grid
			            AliasGrid.ALIASParRef = "";
			            AliasGrid.clearGrid();
				        
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要复制的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	var fields=[{
					name : 'OPERRowId',
					mapping : 'OPERRowId',
					type : 'number'
				}, {
					name : 'OPERCode',
					mapping : 'OPERCode',
					type : 'string'
				}, {
					name : 'OPERDesc',
					mapping : 'OPERDesc',
					type : 'string'
				}, {
					name : 'OPERARCIMDR',
					mapping : 'OPERARCIMDR',
					type : 'string'							
				},{
					name : 'OPERDateActiveFrom',
					mapping : 'OPERDateActiveFrom',
					type : 'date',
					dateFormat : 'm/d/Y'
				}, {
					name : 'OPERActiveDateTo',
					mapping : 'OPERActiveDateTo',
					type : 'date',
					dateFormat : 'm/d/Y'
				}, {
					name : 'OPERValid',
					mapping : 'OPERValid',
					inputValue : true?'Y':'N'
				}, {
					name : 'OPERDaySurgery',
					mapping : 'OPERDaySurgery',
					inputValue : true?'Y':'N'
				}, {
					name : 'OPERDefaultCategoryDR',
					mapping : 'OPERDefaultCategoryDR',
					type : 'string'
				}, {
					name : 'OPERAgeFrom',
					mapping : 'OPERAgeFrom',
					type : 'string'
				}, {
					name : 'OPERAgeTo',
					mapping : 'OPERAgeTo',
					type : 'string'
				}, {
					name : 'OPERAgeFrom1',
					mapping : 'OPERAgeFrom1',
					type : 'string'
				}, {
					name : 'OPERAgeTo1',
					mapping : 'OPERAgeTo1',
					type : 'string'	
				}, {
					name : 'OPERSexDR',
					mapping : 'OPERSexDR',
					type : 'string'
				}, {
					name : 'OPERVersionDictDR',
					mapping : 'OPERVersionDictDR',
					type : 'string'
				}, {
					name : 'OPERICD10',
					mapping : 'OPERICD10',
					type : 'string'
				}, {
					name : 'OPERICD9Map',
					mapping : 'OPERICD9Map',
					type : 'string'
				}, {
					name : 'OPERLongDescription',
					mapping : 'OPERLongDescription',
					type : 'string'
	
				}, {
					name : 'OPERIsKeyOperation',
					mapping : 'OPERIsKeyOperation',
					type : 'string'
				}, {
					name : 'OPERTechnique',
					mapping : 'OPERTechnique',
					type : 'string'
				}, {
					name : 'OPERIsUploadCode',
					mapping : 'OPERIsUploadCode',
					type : 'string'
				}, {
					name : 'OPERIsSpecial',
					mapping : 'OPERIsSpecial',
					type : 'string'
				}, {
					name : 'OPERIsHighRisk',
					mapping : 'OPERIsHighRisk',
					type : 'string'
				}, {
					name : 'OPERIsAudit',
					mapping : 'OPERIsAudit',
					type : 'string'
				}, {
					name : 'OPERIsPacs',
					mapping : 'OPERIsPacs',
					type : 'string'
				}, {
					name : 'OPERIsSupplierPreparation',
					mapping : 'OPERIsSupplierPreparation',
					type : 'string'
				}, {
					name : 'OPERIsProtectiveAntibacterial',
					mapping : 'OPERIsProtectiveAntibacterial',
					type : 'string'
				}, {
					name : 'OPERType',
					mapping : 'OPERType',
					type : 'string'
				}, {
					name : 'OPERApplyFeature',
					mapping : 'OPERApplyFeature',
					type : 'string'
				}, {
					name : 'OPERCategoryDr',
					mapping : 'OPERCategoryDr',
					type : 'string'
				}, {
					name : 'OPERDefaultOperLocDr',
					mapping : 'OPERDefaultOperLocDr',
					type : 'string'
				}, {
					name : 'OPEROperPositionDr',
					mapping : 'OPEROperPositionDr',
					type : 'string'
				}, {
					name : 'OPERBodySiteDr',
					mapping : 'OPERBodySiteDr',
					type : 'string'
				}, {
					name : 'OPERBladeDr',
					mapping : 'OPERBladeDr',
					type : 'string'
				}, {
					name : 'OPERIsMinInvasive',
					mapping : 'OPERIsMinInvasive',
					type : 'string'
				}, {
					name : 'OPERIsSubOperation',
					mapping : 'OPERIsSubOperation',
					type : 'string'
				}, {
					name : 'OPERIsRestrictedTechnology',
					mapping : 'OPERIsRestrictedTechnology',
					type : 'string'
		    }, {
					name : 'OPERIsNewItem',
					mapping : 'OPERIsNewItem',
	        type : 'string'
				}, {
        
					name : 'OPERInsuCode',
					mapping : 'OPERInsuCode',
					type : 'string'
				}, {
					name : 'OPERInsuDesc',
					mapping : 'OPERInsuDesc',
					type : 'string'
				//ofy3
				/*}, {
					name : 'OPERBDPOperationCategoryDR',
					mapping : 'OPERBDPOperationCategoryDR',
					type : 'string'
				*/			
				}, {
					name : 'OPERGrayCodeFlag',
					mapping : 'OPERGrayCodeFlag',
					type : 'string'
				}, {
					name : 'OPERStandardClassDR',
					mapping : 'OPERStandardClassDR',
					type : 'string'
				}
				]
	
	var ds = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields)
				//remoteSort : true	
	});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	
			
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
				displayInfo : true,//是否显示右下方的提示信息false为不显示
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',   //提示信息,这里规定了一种显示格式,默认也可以
				emptyMsg : "没有记录！"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});
	
	/*
	///导出查询的数据 2017-1-16
	
	///2019-02-13
	function isIE()
	{
		////navigator.userAgent.indexOf("compatible") > -1 && navigator.userAgent.indexOf("MSIE") > -1  //ie6,7,8,9,10
		//// navigator.userAgent.indexOf('Trident') > -1 &&  navigator.userAgent.indexOf("rv:11.0") > -1;  //ie11  //"ActiveXObject" in window
		if((!!window.ActiveXObject)||(navigator.userAgent.indexOf('Trident')>-1&&navigator.userAgent.indexOf("rv:11.0")>-1))
		{	return true;}
		else
		{  
			return false;
		}
	}
	
	ExportExcelData=function() {
				var count=tkMakeServerCall("web.DHCBL.CT.ORCOperation","GetDataCount");
				if (count==0){
					Ext.Msg.show({
						title : '提示',
						msg : '没有查询到数据，请重新设置查询条件！' ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
				    return;
				}
				var ErrorMsgInfo="请先确认本机有安装office软件。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "

				try{
			   	 	var xlApp = new ActiveXObject("Excel.Application");
					var xlBook = xlApp.Workbooks.Add();///默认三个sheet
				}catch(e){
					var emsg="不能生成表格文件。"+ErrorMsgInfo;
					Ext.Msg.show({
						title : '提示',
						msg : emsg ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
				    return;
				}     
					     
			 	xlBook.worksheets(1).select(); 
				var xlsheet = xlBook.ActiveSheet; 
				var titlenameStr="代码&%描述&%医嘱项&%开始日期&%结束日期&%有效性&%手术分级&%ICD10&%ICD9&%从年龄&%到年龄&%从限制年龄&%到限制年龄&%限制性别&%备注&%手术操作类别&%使用技术&%手术应用特性&%微创手术(Y/N)&%子手术(Y/N)&%限制类技术(Y/N)&%新项目新技术(Y/N)&%国家医保编码&%国家医保名称";  //&%日间手术
				var titlenamearr=titlenameStr.split("&%");
				for (var m = 0; m < titlenamearr.length; m++) {    				
					//第一行	
		    		xlsheet.cells(1,m+1)=titlenamearr[m];
		    		xlsheet.cells(1,m+1).Font.Bold = true;  //设置为粗体 
		    		xlsheet.cells(1,m+1).WrapText=true;  //设置为自动换行*
				}
					
					
			       
	         	var row=0,taskcount=count;
				var ProgressText='';
				var winproBar = new Ext.Window({
						closable:false,
						modal:true,
						width:314,
						items:[
							new Ext.ProgressBar({id:'proBar',text:'',width:300})
						] 
				});
				var proBar=new Ext.getCmp('proBar');
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>taskcount) //当到达最后一行退出
				  	{
				  		Ext.MessageBox.hide();
						//alert(errorMsg)
						//idTmr = window.setInterval("Cleanup();",1);
						Ext.TaskMgr.stop(this);
						winproBar.close();
						
						xlApp.Visible=true;	
						xlBook.Close(savechanges=true);
						CollectGarbage();
						xlApp=null;
						xlsheet=null;		
		
						
				  	}
				  	else
				  	{
				  		var DataDetailStr2=tkMakeServerCall("web.DHCBL.CT.ORCOperation","GetDataValue",row);
						var Detail2=DataDetailStr2.split("&%");		
						for (var j=1;j<=Detail2.length;j++){
							xlsheet.cells(1+row,j)="'"+Detail2[j-1];
						}
						progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";  
					    proBar.updateProgress(row/taskcount,progressText);
					  }
						 
				  },  
				  interval:100  
				});
				winproBar.show();
			         
				
	}
	*/
	//调用js-xlsx 导出数据  2022-08-03
	function ExportExcelData() {
		
		var xlsName="手术字典" 
		if (xlsName!="") 
		{  
			var taskcount=tkMakeServerCall("web.DHCBL.CT.ORCOperation","GetDataCount"); //获取要导出的总条数  
			if (taskcount==0)
			{
				Ext.Msg.show({
					title : '提示',
					msg : '没有查询到数据，请重新确认！' ,
					minWidth : 200,
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
				})
				return;
			}
			if (taskcount>0)
			{
				//ext进度条，导出
				var winproBar = new Ext.Window({
						closable:false,
						modal:true,
						width:314,
						items:[
							new Ext.ProgressBar({id:'proBar',text:'',width:300})
						] 
				});
				var proBar=Ext.getCmp('proBar');
				var TotalArray=[] //定义数组，用于给table赋值
				var titlenameStr=tkMakeServerCall("web.DHCBL.CT.ORCOperation","GetExceltitlename")
				var titlenamearr=titlenameStr.split("&%");
				TotalArray.push(titlenamearr);    
				
				var row=0,taskcount=taskcount;
				var ProgressText='';
				Ext.TaskMgr.start({  
				  run:function(){
				  	row++;
				  	if(row>taskcount) //当到达最后一行退出
				  	{
				  		Ext.MessageBox.hide(); 
						Ext.TaskMgr.stop(this);  
						winproBar.close();
						
						var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
						
						//第一行增加样式
				        for (var key in sheet) {
				        	if ((key=='A2')||(key=='!ref')){break;}
				        	//非必填项模板颜色黑色
							sheet[key]["s"] = {
					            font: {
					                name: '宋体',
					                sz: 14,
					                bold: true,
					                underline: false,
					                color: {
					                    rgb: "000000"  //黑色
					                }
					            },
					            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
					                horizontal: "center",
					                vertical: "center",
					                wrap_text: true
					            }
					        };
						};
						openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
				  	}
				  	else
				  	{
						progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";   
						proBar.updateProgress(row/taskcount,progressText);
						//将每条数据加到数组里
						var DataDetailStr2=tkMakeServerCall("web.DHCBL.CT.ORCOperation","GetDataValue",row)
						var DetailArray=DataDetailStr2.split("&%");
					    TotalArray.push(DetailArray)
					  }
				  },  
				  interval:10
				}); 
				winproBar.show();
			}
			
		}  
	}
	///导出查询数据
	var btnExport = new Ext.Button({
				id : 'btnExport',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnExport'),
				iconCls : 'icon-export',
				text : '导出查询数据',
				handler :function() {
						/*if (!isIE())  //2019-02-13
						{	
							alert("请在IE下执行！"); return;	
						}	*/	
						ExportExcelData()
						
				}
			});		
			
	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		//enableOverflow : true,										
		items : [btnAddwin, '-', btncopywin,'-',btnEditwin, '-', btnDel,'-',HospWinButton  ///多院区医院
		,'-',btnConfig,'-',btnExport
		,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		]
	});
	
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip:'搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={//模糊查询		
							code :  Ext.getCmp("TextCode").getValue(),
							
							desc :  Ext.getCmp("TextDesc").getValue(),
							
							icd10:	Ext.getCmp("TextICD10").getValue(),
							
							icd9:	Ext.getCmp("TextICD9").getValue(),
							
							category:Ext.getCmp("TextCategory").getValue(),
							
							activeflag:Ext.getCmp("TextActive").getValue(),
							
							insucode:Ext.getCmp("insucode").getValue(),
							
							insucodeflag:Ext.getCmp("insucodeflag").getValue(),
							
							versiondr:Ext.getCmp("TextOPERVersionDictDR").getValue(),
							
							hospid:hospComp.getValue()    ///多院区医院
							
							//,bdpcategory:Ext.getCmp("OPERBDPOperationCategoryDR2").getValue
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : pagesize
						}
					});
				}

	});
			
	// 刷新按钮
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextICD10").reset();
					Ext.getCmp("TextICD9").reset();
					Ext.getCmp("insucode").reset();
					Ext.getCmp("insucodeflag").reset();
					Ext.getCmp("TextCategory").setValue("");
					Ext.getCmp("TextActive").setValue("Y");
					Ext.getCmp("TextOPERVersionDictDR").setValue("")
					grid.getStore().baseParams={
						activeflag:Ext.getCmp("TextActive").getValue(),
						hospid:hospComp.getValue()    ///多院区医院
					};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}

	});
	// 增删改工具条2
	var tbbutton2 = new Ext.Toolbar({
		enableOverflow : true,
		items : [	 
						'国家医保编码', {xtype : 'textfield',id : 'insucode',width:75,disabled : Ext.BDP.FunLib.Component.DisableFlag('insucode')},'-',
						'国家医保编码对照状态',{
							xtype : 'combo',
							listWidth:150,
							width:150,
							shadow:false,
							id :'insucodeflag',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('insucodeflag'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '已对照',
									value : 'Y'
								}, {
									name : '未对照',
									value : 'N'
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name'
						}, '-', '过滤数据',{
							xtype : 'combo',
							listWidth:150,
							width:150,
							shadow:false,
							id :'TextActive',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextActive'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '有效数据',
									value : 'Y'
								}, {
									name : '无效数据',
									value : 'N'
								}, {
									name : '所有数据',
									value : ''
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name'
						},'-','版本',{
							xtype : 'combo',
							listWidth : 250,
							width:150,
							loadByIdParam : 'rowid',
							fieldLabel : '版本',
							id:'TextOPERVersionDictDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextOPERVersionDictDR'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextOPERVersionDictDR')),
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : VersionDictDR_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ID', 'VersionName' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'ID',
							displayField : 'VersionName'
						},'-'	
		]
	});			
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [
						'代码', {xtype : 'textfield',id : 'TextCode',width:150,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')}, '-',
						'描述', {xtype : 'textfield',emptyText : '描述/别名',width:150,id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-',
						'ICD10', {xtype : 'textfield',id : 'TextICD10',width:150,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextICD10')},'-',
						'ICD9', {xtype : 'textfield',id : 'TextICD9',width:150,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextICD9')},'-',
						'手术分级',
						{
								xtype : 'combo',
								width:150,
								listWidth:150,
								fieldLabel : '手术分级',
								id : 'TextCategory',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextCategory'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextCategory')),
								store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : DefaultCategory_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
										}, [{ name:'CATEGRowId',mapping:'CATEGRowId'},
											{name:'CATEGDesc',mapping:'CATEGDesc'} ]
									)
								}),
								mode : 'remote',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : false,
								triggerAction : 'all',
								//hideTrigger: false,
								displayField : 'CATEGDesc',
								valueField : 'CATEGRowId'
							},
						 '-', 
						///ofy3 
						///'树形手术分类',OPERBDPOperationCategoryDR2,
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', 
						btnSearch, '-', btnRefresh,'-', '->'],
				listeners : {
					render : function() {//当组件被渲染后将触发此函数
						tbbutton2.render(grid.tbar)
						tbbutton.render(grid.tbar) //渲染tbbutton按钮,tbar.render(panel.bbar)这个效果在底部
					}
				}
	});
	Ext.getCmp("TextActive").setValue("Y");
	var GridCM=[
		new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
		sm, {
							header : 'OPERRowId',
							width : 70,
							sortable : true,
							dataIndex : 'OPERRowId',
							hidden : true
						}, {
							header : '代码',
							width : 140,
							sortable : true,
							dataIndex : 'OPERCode'
						}, {
							header : '描述',
							width : 200,
							sortable : true,
							dataIndex : 'OPERDesc'
						},  {
							header : 'ICD10代码',
							width : 120,
							sortable : true,
							dataIndex : 'OPERICD10'
						},  {
							header : '手术分级',
							width : 120,
							sortable : true,
							dataIndex : 'OPERDefaultCategoryDR'
						},  {
							header : '国家标准分级',
							width : 120,
							sortable : true,
							dataIndex : 'OPERStandardClassDR'
						}, {
							header : '开始日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'OPERDateActiveFrom'
						}, {
							header : '结束日期',
							width : 100,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'OPERActiveDateTo'
						},{
							header : '有效性',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERValid'
						}, {
							header : '医保灰码',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERGrayCodeFlag'
						},  {
							header : '国家医保编码',
							width : 120,
							sortable : true,
							dataIndex : 'OPERInsuCode'
						},  {
							header : '国家医保名称',
							width : 120,
							sortable : true,
							dataIndex : 'OPERInsuDesc'
					
						//ofy3
						/*}, {
							header : '新手术分类',
							width : 160,
							sortable : true,
							dataIndex : 'OPERBDPOperationCategoryDR'
						*/
						
						}, {
							header : 'ICD9 Map',
							width : 120,
							sortable : true,
							hidden : true,
							dataIndex : 'OPERICD9Map'
						},{
							header : '日间手术',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERDaySurgery',
							hidden : true
						}, {
							header : '手术操作类别',
							width : 160,
							sortable : true,
							dataIndex : 'OPERType',
							renderer : function(v){
								if(v=='N'){return '手术';} 
								if(v=='D'){return '诊断性操作';}
								if(v=='T'){return '治疗性操作';}
								if(v=='I'){return '介入治疗';}
							}
						
						
						}, {
							header : '使用技术',
							width : 160,
							sortable : true,
							dataIndex : 'OPERTechnique',
							renderer : function(v){
								
								if(v=='N'){return '普通';} ///ofy2 开放
								if(v=='I'){return '介入';}   
								if(v=='E'){return '内镜';}
								if(v=='L'){return '腔镜';}
								if(v=='P'){return '操作';}
							}
						},{
							header : '版本',
							width : 140,
							sortable : true,
							dataIndex : 'OPERVersionDictDR'
						
						}, {
							header : '从年龄',
							width : 80,
							sortable : true,
							dataIndex : 'OPERAgeFrom'
						}, {
							header : '到年龄',
							width : 80,
							sortable : true,
							dataIndex : 'OPERAgeTo'
						}, {
							header : '从限制年龄',
							width : 80,
							sortable : true,
							dataIndex : 'OPERAgeFrom1'
						}, {
							header : '到限制年龄',
							width : 80,
							sortable : true,
							dataIndex : 'OPERAgeTo1'
						},{
							header : '限制性别',
							width : 120,
							sortable : true,
							dataIndex : 'OPERSexDR'
						}, {
							header : '默认医嘱项',
							width : 160,
							sortable : true,
							dataIndex : 'OPERARCIMDR'
						}, {
							header : 'LongDescription',
							width : 160,
							sortable : true,
							hidden : true,
							dataIndex : 'OPERLongDescription'
						
						}, {
							header : '手术切口类型',
							width : 160,
							sortable : true,
							dataIndex : 'OPERBladeDr'
						}, {
							header : '手术部位',
							width : 160,
							sortable : true,
							dataIndex : 'OPERBodySiteDr'
						}, {
							header : '手术体位',
							width : 160,
							sortable : true,
							dataIndex : 'OPEROperPositionDr'
						}, {
							header : '默认手术室',
							width : 160,
							sortable : true,
							hidden : true,
							dataIndex : 'OPERDefaultOperLocDr'
						}, {
							header : '手术分类',
							width : 160,
							sortable : true,
							dataIndex : 'OPERCategoryDr'
						}, {
							header : '重点手术',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsKeyOperation'
						}, {
							header : '有上传编码',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsUploadCode'
						}, {
							header : '特殊手术',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsSpecial'
						}, {
							header : '高风险技术',
							width : 160,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsHighRisk'
						}, {
							header : '审批技术',
							width : 160,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsAudit'
						}, {
							header : '有PACS影像',
							width : 160,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsPacs'
						}, {
							header : '供应商备货',
							width : 160,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsSupplierPreparation'
						}, {
							header : '使用预防性抗菌药物',
							width : 160,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsProtectiveAntibacterial'
						}, {
							header : '手术应用特性',
							width : 120,
							sortable : true,
							dataIndex : 'OPERApplyFeature',
							renderer : function(v){
								if(v=='R'){return '必选';} 
								if(v=='C'){return '中医必选';}
								if(v=='O'){return '选择性';}
							}		
						}, {
							header : '微创手术',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsMinInvasive'
						}, {
							header : '子手术',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsSubOperation'
						}, {
							header : '限制类技术',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsRestrictedTechnology'
						}, {
							header : '新项目新技术',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'OPERIsNewItem'
						}]
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				title : '手术/过程',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,//鼠标移动到某一行将显示高亮
				columns : GridCM,
				stripeRows : true,//显示斑马线
				/*loadMask : {//用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				*/
				// config options for stateful behavior
				stateful : true,
				/*viewConfig : {//视图配置
					forceFit : true//固定大小
				},*/
				//autoExpandColum:'PHCFRForeignDesc',
				bbar : paging,//底部状态栏
				tbar : tb,//顶部状态栏
				stateId : 'grid'
	});
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	

	// 双击事件
	grid.on("rowdblclick", function(grid,rowIndex, e) {
		var row = grid.getStore().getAt(rowIndex).data;
		win.setTitle('修改');
		win.setIconClass('icon-update');
		win.show();
        loadFormData(grid);
        
        //激活基本信息面板
        tabs.setActiveTab(0);
        //加载别名面板
        var _record = grid.getSelectionModel().getSelected();
        AliasGrid.ALIASParRef = _record.get('OPERRowId');
        AliasGrid.loadGrid();
        
        //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"ORC_Operation");
        if (InsuConfig=="INSU")
        {
        	Ext.getCmp("OPERInsuCode").setDisabled(true);
        	Ext.getCmp("OPERInsuDesc").setDisabled(true);
        }
        else
        {
	        Ext.getCmp("OPERInsuCode").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuCode'));
        	Ext.getCmp("OPERInsuDesc").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('OPERInsuDesc'));
        }
    });
    
	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('OPERRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});
	
    // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('提示','请先选择一项手术/过程！');
        } 
        else {
        	linkgrid.getStore().baseParams={
						linkparref : grid.getSelectionModel().getSelected().get('OPERRowId')	
			};
			linkgrid.getStore().load({
				params : {
						/*start : 0,
						limit : pagesize1*/
				}
			});	
			
			
			dsCTLoc.baseParams={
				operrowid:grid.getSelectionModel().getSelections()[0].get('OPERRowId')		
			};
			dsCTLoc.load();
							
			dsHOSP.baseParams={
				operrowid:grid.getSelectionModel().getSelections()[0].get('OPERRowId')
			};
			dsHOSP.load();
			
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('OPERRowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                    //Ext.Msg.alert(action);
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
           
           }
    };
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
    
    var loadflag=0;
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [GenHospPanel(hospComp),grid],  //多院区医院
				 listeners:{
			
					'afterlayout':function(){
						//打开页面默认加载数据(以下)
						if (loadflag==0)
						{
							loadflag=1
							grid.getStore().baseParams={//模糊查询		
									code :  Ext.getCmp("TextCode").getValue(),
									
									desc :  Ext.getCmp("TextDesc").getValue(),
									
									icd10:	Ext.getCmp("TextICD10").getValue(),
									
									icd9:	Ext.getCmp("TextICD9").getValue(),
									
									category:Ext.getCmp("TextCategory").getValue(),
									
									activeflag:Ext.getCmp("TextActive").getValue(),
									
									insucode:Ext.getCmp("insucode").getValue(),
							
									insucodeflag:Ext.getCmp("insucodeflag").getValue(),
							
									versiondr:Ext.getCmp("TextOPERVersionDictDR").getValue()
									
									//,bdpcategory:Ext.getCmp("OPERBDPOperationCategoryDR2").getValue
							};
							///多院区医院
						var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
						if (flag=="Y"){
							grid.disable();
						}
						else
						{
							grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize
								},
								callback : function(records, options, success) {
										
								}
							});
						}
						    
						}
					}
				
				}
	});

});
