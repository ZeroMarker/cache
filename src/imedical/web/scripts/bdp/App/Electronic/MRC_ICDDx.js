/// 名称: ICD诊断代码
/// 描述: ICD诊断代码，包含增删改查合并功能
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2012-12-18

///ofy1 兰大一院   自动生成最大代码  ,且ICD10 和ICD9 Map 互换fieldlabel  2016-12-23
///ofy2 南通中医院 添加导入按钮
///ofy3 兰大一院  如果勾选了肿瘤形态学编码或损伤中毒外部原因，则不校验描述
document.write('<script type="text/javascript" src="../scripts/bdp/App/Electronic/MRC_ICDAlias.js"> </script>');
	
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
///页面帮助 2014-10-23 by chenying
var htmlurl = "../scripts/bdp/AppHelp/Electronic/MRCICDDx.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
//var pinyins=Pinyin.GetJPU("液状石蜡外用液体剂[500ml][吉林]")  大写
Ext.onReady(function() {
	
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "MRC_ICDDx"
	});
	
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.MRCICDDx";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//翻译
	Ext.BDP.FunLib.TableName="MRC_ICDDx";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	/////////////////////////////日志查看 ////////////////////////////////////////
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
			RowID=rows[0].get('MRCIDRowId');
			Desc=rows[0].get('MRCIDDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});

  
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	var SEX_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	var MRCIDTypeDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDxType&pClassQuery=GetDataForCmb1";
	//版本下拉框取值
	var VersionDictDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDVersionDict&pClassQuery=GetDataForCmb1&type=User.MRCICDDx";
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=GetList";
	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCICDDx";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=OpenData";
	var COPY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=CopyData";
	
	//var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=DeleteData";
	
	var ICDALIAS_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassQuery=GetList";
	var ICDALIAS_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCICDAlias";
	var ICDALIAS_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=DeleteData";
	
	

	////增加配置维护页面  2017-07-04
	/*1,是否校验代码
	 *2,是否校验描述
	 *3,是否自动生成代码
	 *4,代码开头字母
	 *5,代码总共位数
	*/		
	  
	var config_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=GetConfigValue";
   	var config_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=SaveConfigValue";
	
    //多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		 grid.enable();
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			icd10:Ext.getCmp("Texticd10").getValue(),
			activeflag:Ext.getCmp("TextActive").getValue(),
			type:Ext.getCmp("TextType").getValue(),
			insucode:Ext.getCmp("insucode").getValue(),
			insucodeflag:Ext.getCmp("insucodeflag").getValue(),
			versiondr:Ext.getCmp("TextMRCIDVersionDictDR").getValue(),
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
				var rowid=grid.getSelectionModel().getSelections()[0].get("MRCIDRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });   
		
	var configWinForm = new Ext.FormPanel({
				id : 'config-form-save',
				URL : config_SAVE_ACTION_URL,
				labelAlign : 'right',
				labelWidth : 140,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ValidCode',mapping:'ValidCode'},
                                         {name: 'ValidDesc',mapping:'ValidDesc'},
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
						boxLabel:'校验代码和描述是否重复',
						id:'ValidCode',
						//inputValue : true?'Y':'N',
			    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValidCode'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValidCode'))
					/*}, {
						xtype:'checkbox',
						//inputValue : true?'Y':'N',
						boxLabel:'校验描述是否重复',
						id:'ValidDesc',
			    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'))
					*/
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
					//var ConfigStr=Ext.getCmp('ValidCode').getValue()+'^'+Ext.getCmp('ValidDesc').getValue()+"^"+Ext.getCmp('AutoCode').getValue()+'^'+Ext.getCmp('OriginCode').getValue()+'^'+Ext.getCmp('TotalLength').getValue()
					
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

	/** 删除按钮 */
	/*var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : function DelData() {
			var gsm = grid.getSelectionModel();// 获取选择列
			var rows = gsm.getSelections();// 根据选择列获取到所有的行
			if (rows.length==1) {
				Ext.MessageBox.confirm('提示', '确定要删除该条数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中，请稍候...', '提示');
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('MRCIDRowId')
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
							msg : '请选择一条需要删除的数据!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	*/
	var AgeFrom=new Ext.BDP.FunLib.Component.CompositeField ({
	    xtype: 'compositefield',
	    //buildLabel: "",
	    labelWidth: 250,
	    items: [
	        {
				xtype : 'numberfield',
				fieldLabel : '从年龄',
				name : 'MRCIDAgeFrom',
				id:'MRCIDAgeFromF',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeFromF'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeFromF')),
				decimalPrecision:6,
				allowNegative : false,//不允许输入负数
				allowDecimals : true,//允许输入小数
				minValue : 0,
				maxValue : 180,
				minText : '年龄不能小于0',
				maxText : '年龄不能大于180',
				nanText : '年龄只能是数字',
				width:60
			},{
				xtype : 'combo',
				fieldLabel : '',
				name : 'MRCIDAgeFromType',
				id:'MRCIDAgeFromTypeF',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeFromTypeF'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeFromTypeF')),
				hiddenName : 'MRCIDAgeFromType',
				mode : 'local',
				store : new Ext.data.SimpleStore({
							fields : ['value', 'text'],
							data : [
										['Y', '岁'],
										['M', '月'],
										['D', '日']
									]
						}),
				emptyText:'请选择从年龄类型！',
				triggerAction : 'all',
				forceSelection : true,
				selectOnFocus : false,
				//typeAhead : true,
				//minChars : 1,
				valueField : 'value',
				displayField : 'text',
				width:140
			} ]
	  });
	var AgeTo=new Ext.BDP.FunLib.Component.CompositeField ({
	    xtype: 'compositefield',
	    //buildLabel: "",
	    labelWidth: 150,
	    items: [
	        {
				xtype : 'numberfield',
				fieldLabel : '到年龄',
				name : 'MRCIDAgeTo',
				id:'MRCIDAgeToF',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeToF'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeToF')),
				decimalPrecision:6,				
				allowNegative : false,//不允许输入负数
				allowDecimals : true,//允许输入小数
				minValue : 0,
				maxValue : 180,
				minText : '年龄不能小于0',
				maxText : '年龄不能大于180',
				nanText : '年龄只能是数字',
				width:60
			}, {
				xtype : 'combo',
				fieldLabel : '',
				name : 'MRCIDAgeToType',
				id:'MRCIDAgeToTypeF',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeToTypeF'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDAgeToTypeF')),
				hiddenName : 'MRCIDAgeToType',
				mode : 'local',
				store : new Ext.data.SimpleStore({
							fields : ['value', 'text'],
							data : [
										['Y', '岁'],
										['M', '月'],
										['D', '日']
									]
						}),
				emptyText:'请选择到年龄类型！',
				triggerAction : 'all',
				forceSelection : true,
				selectOnFocus : false,
				//typeAhead : true,
				//minChars : 1,
				valueField : 'value',
				displayField : 'text',
				width:140
			} ]
	  });
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				title:'基本信息',
				labelAlign : 'right',
				labelWidth : 120,
				autoScroll : true, //滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'MRCIDRowId',mapping:'MRCIDRowId',type:'string'},
                                         {name: 'MRCIDCode',mapping:'MRCIDCode',type:'string'},
                                         {name: 'MRCIDDesc',mapping:'MRCIDDesc',type:'string'},
                                         {name: 'MRCIDICD9CMCode',mapping:'MRCIDICD9CMCode',type:'string'},
                                         {name: 'MRCIDDateActiveFrom',mapping:'MRCIDDateActiveFrom',type:'string'},
                                         {name: 'MRCIDDateActiveTo',mapping:'MRCIDDateActiveTo',type:'string'},
                                         {name: 'MRCIDAgeFrom',mapping:'MRCIDAgeFrom',type:'string'},
                                         {name: 'MRCIDAgeTo',mapping:'MRCIDAgeTo',type:'string'},
                                         {name: 'MRCIDTypeDR',mapping:'MRCIDTypeDR',type:'string'},  //2019-04-20
                                         {name: 'MRCIDSexDR',mapping:'MRCIDSexDR',type:'string'},
                                         {name: 'MRCIDVersionDictDR',mapping:'MRCIDVersionDictDR',type:'string'},
                                         {name: 'MRCIDValid',mapping:'MRCIDValid',type:'string'},
                                         {name: 'MRCID2ndCodeInPair',mapping:'MRCID2ndCodeInPair',type:'string'},
                                         {name: 'MRCIDICD9Map',mapping:'MRCIDICD9Map',type:'string'},
                                         {name: 'MRCIDInsuCode',mapping:'MRCIDInsuCode',type:'string'},
                                         {name: 'MRCIDInsuDesc',mapping:'MRCIDInsuDesc',type:'string'},
                                         {name: 'MRCIDNationalDesc',mapping:'MRCIDNationalDesc',type:'string'},
                                         {name: 'MRCIDLongDescription',mapping:'MRCIDLongDescription',type:'string'},
                                         {name: 'MRCIDMetastaticSite',mapping:'MRCIDMetastaticSite',type:'string'},
                                         {name: 'MRCIDInjuryPoisoningCode',mapping:'MRCIDInjuryPoisoningCode',type:'string'},
                                         {name: 'MRCIDBillFlag1',mapping:'MRCIDBillFlag1',type:'string'},
                                         {name: 'MRCIDBillFlag3',mapping:'MRCIDBillFlag3',type:'string'},
                                         {name: 'MRCIDClinicTypeO',mapping:'MRCIDClinicTypeO',type:'string'},
                                         {name: 'MRCIDClinicTypeE',mapping:'MRCIDClinicTypeE',type:'string'},
                                         {name: 'MRCIDClinicTypeI',mapping:'MRCIDClinicTypeI',type:'string'},
                                         {name: 'MRCIDClinicTypeH',mapping:'MRCIDClinicTypeH',type:'string'},
                                         {name: 'MRCIDClinicTypeN',mapping:'MRCIDClinicTypeN',type:'string'},
                                         {name: 'MRCIDAgeFromType',mapping:'MRCIDAgeFromType',type:'string'},
                                         {name: 'MRCIDAgeToType',mapping:'MRCIDAgeToType',type:'string'},
                                         {name: 'MRCIDGrayCodeFlag',mapping:'MRCIDGrayCodeFlag',type:'string'},
                                         //{name: 'MRCIDDiagnosticType',mapping:'MRCIDDiagnosticType',type:'string'},
                                         {name: 'MRCIDRareDiseaseFlag',mapping:'MRCIDRareDiseaseFlag',type:'string'}

                                         
                                         /*, {name: 'ALIASText',mapping:'ALIASText',type:'string'}*/
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
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
					columnWidth:'.55',
					layout: 'form',
					labelPad:1,//默认5
					border:false,
					defaults: {anchor:'90%'},
					items: [{
							xtype: 'textfield',
							fieldLabel : 'MRCIDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'MRCIDRowId'
						}, {
							xtype: 'textfield',
							fieldLabel : '<font color=red>*</font>代码',
							name : 'MRCIDCode',
							id:'MRCIDCodeF',
							maxLength:100,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDCodeF')),
							allowBlank : false,
							blankText: '代码不能为空'
							
						}, {
							xtype: 'textfield',
							fieldLabel : '<font color=red>*</font>描述',
							name : 'MRCIDDesc',
							id:'MRCIDDescF',
							maxLength:220,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDDescF')),
							allowBlank : false,
							blankText: '描述不能为空'
						},{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
              allowBlank : false,
							loadByIdParam : 'rowid',
							fieldLabel : '<font color=red>*</font>版本',
							name:'MRCIDVersionDictDR',
							hiddenName : 'MRCIDVersionDictDR',
							id:'MRCIDVersionDictDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDVersionDictDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDVersionDictDRF')),
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
							xtype: 'textfield',
							fieldLabel : '<font color=red>*</font>ICD10代码',
							name : 'MRCIDICD9CMCode',
							id:'MRCIDICD9CMCodeF',
							maxLength:100,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDICD9CMCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDICD9CMCodeF')),
							allowBlank : false,
							blankText: 'ICD10代码不能为空'
						}, {
							xtype: 'textfield',
							fieldLabel : '国家标准名称',
							name : 'MRCIDNationalDesc',
							id:'MRCIDNationalDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDNationalDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDNationalDescF'))
   						}, {
							xtype: 'textfield',
							fieldLabel : '副编码',
							name : 'MRCID2ndCodeInPair',
							id:'MRCID2ndCodeInPairF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCID2ndCodeInPairF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCID2ndCodeInPairF'))
						}, {
							xtype: 'textfield',
							fieldLabel : 'ICD9代码',
							name : 'MRCIDICD9Map',
							id:'MRCIDICD9MapF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDICD9MapF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDICD9MapF'))
   						}, {
							
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'MRCIDDateActiveFrom',
							format : BDPDateFormat,
							id:'MRCIDDateActiveFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDDateActiveFromF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDDateActiveFromF')),
							allowBlank : false,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'MRCIDDateActiveTo',
							id:'MRCIDDateActiveToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDDateActiveToF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDDateActiveToF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						
						
						}, AgeFrom,AgeTo, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							fieldLabel : 'ICD诊断分类',
							name:'MRCIDTypeDR',
							hiddenName : 'MRCIDTypeDR',
							id:'MRCIDTypeDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDTypeDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDTypeDRF')),
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : MRCIDTypeDR_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ICDTYPERowId', 'ICDTYPEDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'ICDTYPERowId',
							displayField : 'ICDTYPEDesc'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							fieldLabel : '限制性别',
							name:'MRCIDSexDR',
							hiddenName : 'MRCIDSexDR',
							id:'MRCIDSexDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDSexDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDSexDRF')),
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : SEX_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTSEXRowId', 'CTSEXDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTSEXRowId',
							displayField : 'CTSEXDesc'
						
							
						},{
							
							xtype: 'textfield',
							fieldLabel : '注释',
							name : 'MRCIDLongDescription',
							id:'MRCIDLongDescriptionF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDLongDescriptionF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDLongDescriptionF'))
						
						}/*, {
							xtype : 'combo',
							fieldLabel : '诊断类型',
							name : 'MRCIDDiagnosticType',
							id:'MRCIDDiagnosticTypeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDDiagnosticTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDDiagnosticTypeF')),
							hiddenName : 'MRCIDDiagnosticType',
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [
													['TCM', '中医'],
													['WM', '西医'],
													['ST', '证型']
												]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}*/]					
				},{
					baseCls : 'x-plain',
				    columnWidth:'.45',
					layout: 'form',
					labelPad:1,
					border:false,
					defaults: {anchor:'90%'},
					items: [{
							xtype: 'textfield',
							fieldLabel : '国家医保编码',
							name : 'MRCIDInsuCode',
							id:'MRCIDInsuCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuCodeF'))
						}, {
							xtype: 'textfield',
							fieldLabel : '国家医保名称',
							name : 'MRCIDInsuDesc',
							id:'MRCIDInsuDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuDescF'))
						}, {	
							xtype : 'checkbox',
							fieldLabel : '肿瘤形态学编码',
							name : 'MRCIDMetastaticSite',
							id:'MRCIDMetastaticSiteF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDMetastaticSiteF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDMetastaticSiteF')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
							fieldLabel : '损伤中毒外部原因',
							name : 'MRCIDInjuryPoisoningCode',
							id:'MRCIDInjuryPoisoningCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDInjuryPoisoningCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInjuryPoisoningCodeF')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
							fieldLabel : '中医证型',
							name : 'MRCIDBillFlag1',
							id:'MRCIDBillFlag1F',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag1F'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag1F')),
							inputValue : 'Y',
							listeners : {
								'check' :function() {
										if (Ext.getCmp("MRCIDBillFlag1F").getValue())
										{
											Ext.getCmp("MRCIDBillFlag3F").setValue(true)
											Ext.getCmp("MRCIDBillFlag3F").readOnly=true
										}
										else
										{
											var flag=Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag3F');
											Ext.getCmp("MRCIDBillFlag3F").readOnly=flag;
										}
								}
							}
						}, {
							xtype : 'checkbox',
							fieldLabel : '中医诊断',
							name : 'MRCIDBillFlag3',
							id:'MRCIDBillFlag3F',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag3F'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag3F')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
							fieldLabel : '医保灰码',
							name : 'MRCIDGrayCodeFlag',
							id:'MRCIDGrayCodeFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDGrayCodeFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDGrayCodeFlagF')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
							fieldLabel : '罕见病标志',
							name : 'MRCIDRareDiseaseFlag',
							id:'MRCIDRareDiseaseFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDRareDiseaseFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDRareDiseaseFlagF')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
							fieldLabel : '有效',
							id:'MRCIDValidF',
							name : 'MRCIDValid',
							inputValue : 'Y',
							checked:true
						}, {
							xtype:'fieldset',
				            title: '就诊类型' , 
				            style: 'margin-left:43px;',
		           			bodyStyle: 'margin-left:-54px;',
				            items: [{
				            		xtype : 'checkboxgroup',   ////// 控制哪些类型可开，值为空则都可以开   O,E,I,H,N  (门诊,急诊,住院,体检,新生儿)
								    id:'MRCIDClinicTypeF',
								    readOnly : Ext.BDP.FunLib.Component.DisableFlag('MRCIDClinicTypeF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MRCIDClinicTypeF')),
								    columns: 1,
								    items: [
								        {boxLabel: '门诊', name: 'MRCIDClinicTypeO',id: 'MRCIDClinicTypeO', inputValue : 'O',checked:true},
								        {boxLabel: '急诊', name: 'MRCIDClinicTypeE',id: 'MRCIDClinicTypeE', inputValue : 'E',checked:true},
								        {boxLabel: '住院', name: 'MRCIDClinicTypeI',id: 'MRCIDClinicTypeI', inputValue : 'I',checked:true},
								        {boxLabel: '体检', name: 'MRCIDClinicTypeH',id: 'MRCIDClinicTypeH', inputValue : 'H',checked:true},
								        {boxLabel: '新生儿', name: 'MRCIDClinicTypeN',id: 'MRCIDClinicTypeN', inputValue : 'N',checked:true}
								    ]
				            }]
							
						
						}]						
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
	//获取年龄	
	var GetTrueAge=function(age,type)
	{
		var trueage=""
		if (type=="Y")
		{
			trueage=age*365
		}
		else if (type=="M")
		{
			trueage=age*30
		}
		else if (type=="D")
		{
			trueage=age
		}
		return trueage
	}

	var height=Math.min(Ext.getBody().getViewSize().height-30,610)
	//var height=Math.min(Ext.getBody().getViewSize().height-30,680)
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		title : '',
		width : 800,
		height:height,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
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
			handler : SaveEntity=function () {
				var pinyins=Pinyin.GetJPU(Ext.getCmp("MRCIDDescF").getValue())
				var tempCode = Ext.getCmp("form-save").getForm().findField("MRCIDCode").getValue();
				var tempDesc = Ext.getCmp("form-save").getForm().findField("MRCIDDesc").getValue();
				var tempICD = Ext.getCmp("form-save").getForm().findField("MRCIDICD9CMCode").getValue();
				//var ALIASText = Ext.getCmp("form-save").getForm().findField("ALIASText").getValue();
				var startDate = Ext.getCmp("form-save").getForm().findField("MRCIDDateActiveFrom").getValue();
    			var endDate = Ext.getCmp("form-save").getForm().findField("MRCIDDateActiveTo").getValue();
				var ageFrom = Ext.getCmp("form-save").getForm().findField("MRCIDAgeFrom").getRawValue();
				var ageTo = Ext.getCmp("form-save").getForm().findField("MRCIDAgeTo").getRawValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempICD=="") {
    				Ext.Msg.show({ title : '提示', msg : 'ICD10代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
    			if (startDate=="") {
    				Ext.Msg.show({ title : '提示', msg : '开始日期不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
                var flag="", id="";
                if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
                	var _record = grid.getSelectionModel().getSelected();
                	id = _record.get('MRCIDRowId'); //此条数据的rowid
                }
                
                // var billflag3=(Ext.getCmp("MRCIDBillFlag3F").getValue()==true?"Y":"N")  //中医诊断标识
                ///重复校验   rowid,代码，描述，医院，结束日期
                var flag = tkMakeServerCall("web.DHCBL.CT.MRCICDDx","FormValidate",id,Ext.getCmp("MRCIDCodeF").getValue(),Ext.getCmp("MRCIDDescF").getValue(),hospComp.getValue(),Ext.getCmp("MRCIDDateActiveToF").getRawValue())
    			if(flag == "1"){
                 	Ext.Msg.show({ title : '提示', msg : '该代码和描述已经存在!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                 	return;
                }
                
    			if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
    			if (startDate != "" && endDate != "") {
    				startDate = startDate.format("Ymd");
    				endDate = endDate.format("Ymd");
        			if (startDate > endDate) {
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
   			 	var ageFromType=Ext.getCmp("form-save").getForm().findField("MRCIDAgeFromType").getValue();
				var ageToType=Ext.getCmp("form-save").getForm().findField("MRCIDAgeToType").getValue();
   			 	if (((ageFrom!="")&&(ageFromType==""))||((ageTo!="")&&(ageToType=="")))
   			 	{
	   			 	
   			 		Ext.Msg.show({
        					title : '提示',
							msg : '年龄类型不能为空!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
   			 	}
   			 	if (((ageFrom=="")&&(ageFromType!=""))||((ageTo=="")&&(ageToType!="")))
   			 	{
   			 		Ext.Msg.show({
        					title : '提示',
							msg : '年龄不能为空!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
   			 	}
   			 	
    			if (ageFrom!=="" && ageTo!=="")
			 	{
			 		ageFrom=GetTrueAge(ageFrom,ageFromType)
					ageTo=GetTrueAge(ageTo,ageToType)
	    			if (ageFrom > ageTo) {
	    				Ext.Msg.show({
	    					title : '提示',
							msg : '从年龄不能大于到年龄!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
	      			 	return;
	  				}
			 	}
   			 	
				if ((win.title == "添加")||(win.title == "快速复制")) 
				{
					
					
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
								//添加时 同时保存别名
								AliasGrid.ALIASParRef = myrowid;
								AliasGrid.saveAlias();
								
								///2016-3-1 chenying
								var aliastext=""+"^"+pinyins+"^"+myrowid
								var aliaspinyin= tkMakeServerCall("web.DHCBL.CT.MRCICDAlias","SaveAll",aliastext)
								//alert(aliaspinyin)
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
								params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
								success : function(form, action) {
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										
									
										win.hide();
										var myrowid = "rowid=" + action.result.id;
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
				//Ext.getCmp("form-save").getForm().findField("MRCIDCode").focus(true,800);
				
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
					
					//ofy1 兰大一院   自动生成最大代码 总共5位 加配置
					
					var MaxCode = tkMakeServerCall("web.DHCBL.CT.MRCICDDx","AutoCreateCode");
					Ext.getCmp("MRCIDCodeF").setValue(MaxCode)
					
					var flag=Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag3F');
					Ext.getCmp("MRCIDBillFlag3F").readOnly=flag;

					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.ALIASParRef = "";
		            AliasGrid.clearGrid();
		            //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
			        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"MRC_ICDDx");
			        if (InsuConfig=="INSU")
			        {
			        	Ext.getCmp("MRCIDInsuCodeF").setDisabled(true);
			        	Ext.getCmp("MRCIDInsuDescF").setDisabled(true);
			        }
			        else
			        {
				        Ext.getCmp("MRCIDInsuCodeF").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuCodeF'));
			        	Ext.getCmp("MRCIDInsuDescF").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuDescF'));
			        }
				},
				scope : this
			});
	/** 复制按钮 */
	var btncopywin = new Ext.Toolbar.Button({
				text : '快速复制',
				iconCls : 'icon-add',
				id:'copy_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('copy_btn'),
				handler :CopyData= function () {
					
					if (!grid.selModel.hasSelection()) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要复制的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
					
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						if (rows.length!=1) {
				            Ext.Msg.show({
								title : '提示',
								msg : '请选择一条需要复制的数据!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
				        } else {
				            win.setTitle('快速复制');
							win.setIconClass('icon-add');
							win.show();
							Ext.getCmp("form-save").getForm().reset();
							
					        
				            Ext.getCmp("form-save").getForm().load({
				                url : COPY_ACTION_URL + '&id=' + rows[0].get('MRCIDRowId'),
				                //waitMsg : '正在载入数据...',
				                success : function(form,action) {
				                	
									if (Ext.getCmp("MRCIDBillFlag1F").getValue())
									{
										Ext.getCmp("MRCIDBillFlag3F").setValue(true)
										Ext.getCmp("MRCIDBillFlag3F").readOnly=true
									}
									else
									{
										var flag=Ext.BDP.FunLib.Component.DisableFlag('MRCIDBillFlag3F');
										Ext.getCmp("MRCIDBillFlag3F").readOnly=flag;
										
									}
									Ext.getCmp('MRCIDClinicTypeO').setValue((action.result.data.MRCIDClinicTypeO)=='O'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeE').setValue((action.result.data.MRCIDClinicTypeE)=='E'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeI').setValue((action.result.data.MRCIDClinicTypeI)=='I'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeH').setValue((action.result.data.MRCIDClinicTypeH)=='H'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeN').setValue((action.result.data.MRCIDClinicTypeN)=='N'?true:false);
									
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
				            AliasGrid.ALIASParRef = "";
			            	AliasGrid.clearGrid();
			            	//添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
					        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"MRC_ICDDx");
					        if (InsuConfig=="INSU")
					        {
					        	Ext.getCmp("MRCIDInsuCodeF").setDisabled(true);
					        	Ext.getCmp("MRCIDInsuDescF").setDisabled(true);
					        }
					        else
					        {
						        Ext.getCmp("MRCIDInsuCodeF").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuCodeF'));
					        	Ext.getCmp("MRCIDInsuDescF").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuDescF'));
					        }
				        }
			        
			        }
			        
				}
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler :UpdateData= function () {
					
					if (!grid.selModel.hasSelection()) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的数据!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
					
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						if (rows.length!=1) {
				            Ext.Msg.show({
								title : '提示',
								msg : '请选择一条需要修改的数据!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
				        } else {
				            win.setTitle('修改');
							win.setIconClass('icon-update');
							win.show('');
							Ext.getCmp("form-save").getForm().reset();
							
					        
				            Ext.getCmp("form-save").getForm().load({
				                url : OPEN_ACTION_URL + '&id=' + rows[0].get('MRCIDRowId'),
				                //waitMsg : '正在载入数据...',
				                success : function(form,action) {
				                    //Ext.Msg.alert(action);
				                	//Ext.Msg.alert('编辑', '载入成功');
				                	Ext.getCmp('MRCIDClinicTypeO').setValue((action.result.data.MRCIDClinicTypeO)=='O'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeE').setValue((action.result.data.MRCIDClinicTypeE)=='E'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeI').setValue((action.result.data.MRCIDClinicTypeI)=='I'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeH').setValue((action.result.data.MRCIDClinicTypeH)=='H'?true:false);
				                	Ext.getCmp('MRCIDClinicTypeN').setValue((action.result.data.MRCIDClinicTypeN)=='N'?true:false);
				                },
				                failure : function(form,action) {
				                	Ext.Msg.alert('编辑', '载入失败');
				                }
				            });
				            
				            //激活基本信息面板
				            tabs.setActiveTab(0);
					        //加载别名面板
				            var _record = grid.getSelectionModel().getSelected();
				            AliasGrid.ALIASParRef = _record.get('MRCIDRowId');
					        AliasGrid.loadGrid();
					        
					        //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
					        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"MRC_ICDDx");
					        if (InsuConfig=="INSU")
					        {
					        	Ext.getCmp("MRCIDInsuCodeF").setDisabled(true);
					        	Ext.getCmp("MRCIDInsuDescF").setDisabled(true);
					        }
					        else
					        {
						        Ext.getCmp("MRCIDInsuCodeF").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuCodeF'));
					        	Ext.getCmp("MRCIDInsuDescF").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('MRCIDInsuDescF'));
					        }
				        }
				        
			        }
			        
				}
			});
	
	var fields=[{
									name : 'MRCIDRowId',
									mapping : 'MRCIDRowId',
									type : 'int'
								}, {
									name : 'MRCIDCode',
									mapping : 'MRCIDCode',
									type : 'string'
								}, {
									name : 'MRCIDDesc',
									mapping : 'MRCIDDesc',
									type : 'string'
								}, {
									name : 'MRCIDICD9CMCode',
									mapping : 'MRCIDICD9CMCode',
									type : 'string'
								}, {
									name : 'MRCIDICD9Map',
									mapping : 'MRCIDICD9Map',
									type : 'string'
								}, {
									name : 'MRCIDNationalDesc',
									mapping : 'MRCIDNationalDesc',
									type : 'string'
								}, {
									name : 'MRCID2ndCodeInPair',
									mapping : 'MRCID2ndCodeInPair',
									type : 'string'
								}, {
									name : 'MRCIDDateActiveFrom',
									mapping : 'MRCIDDateActiveFrom',
									type : 'string'
								}, {
									name : 'MRCIDDateActiveTo',
									mapping : 'MRCIDDateActiveTo',
									type : 'string'
								}, {
									name : 'MRCIDAgeFrom',
									mapping : 'MRCIDAgeFrom',
									type : 'string'
								}, {
									name : 'MRCIDAgeTo',
									mapping : 'MRCIDAgeTo',
									type : 'string'
								}, {
									name : 'MRCIDTypeDR',
									mapping : 'MRCIDTypeDR',
									type : 'string'
								}, {
									name : 'MRCIDSexDR',
									mapping : 'MRCIDSexDR',
									type : 'string'
								}, {
									name : 'MRCIDVersionDictDR',
									mapping : 'MRCIDVersionDictDR',
									type : 'string'
								}, {
									name : 'MRCIDValid',
									mapping : 'MRCIDValid',
									type : 'string'
								},{
									
									name : 'MRCIDLongDescription',
									mapping : 'MRCIDLongDescription',
									type : 'string'
								}, {
									name : 'MRCIDMetastaticSite',
									mapping : 'MRCIDMetastaticSite',
									type : 'string'
								}, {
									name : 'MRCIDInjuryPoisoningCode',
									mapping : 'MRCIDInjuryPoisoningCode',
									type : 'string'
								}, {
									name : 'MRCIDBillFlag1',
									mapping : 'MRCIDBillFlag1',
									type : 'string'
								}, {
									name : 'MRCIDBillFlag3',
									mapping : 'MRCIDBillFlag3',
									type : 'string'
								}, {
									name : 'MRCIDClinicType',
									mapping : 'MRCIDClinicType',
									type : 'string'
								}, {
									name : 'MRCIDInsuCode',
									mapping : 'MRCIDInsuCode',
									type : 'string'
								}, {
									name : 'MRCIDInsuDesc',
									mapping : 'MRCIDInsuDesc',
									type : 'string'
								}, {
									name : 'MRCIDAgeFromType',
									mapping : 'MRCIDAgeFromType',
									type : 'string'
								}, {
									name : 'MRCIDAgeToType',
									mapping : 'MRCIDAgeToType',
									type : 'string'
								}, {
									name : 'MRCIDGrayCodeFlag',
									mapping : 'MRCIDGrayCodeFlag',
									type : 'string'
								}/*, {
									name : 'MRCIDDiagnosticType',
									mapping : 'MRCIDDiagnosticType',
									type : 'string'
								}*/, {
									name : 'MRCIDRareDiseaseFlag',
									mapping : 'MRCIDRareDiseaseFlag',
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
			
	/** 监听数据是否有变化,自动判断是否全选并选中或不选中表头的checkbox 20130711lisen */
	ds.on('datachanged', function autoCheckGridHead(store){
		var hd_checker = grid.getEl().select('div.x-grid3-hd-checker'); 	//CompositeElementLite/CompositeElement
    	var hd = hd_checker.first();		//呵呵，终于搞定了，这句测了好久，才找对对象;
    	if(hd != null){
    		//清空表格头的checkBox
                if(hd.hasClass('x-grid3-hd-checker-on')){
	                hd.removeClass('x-grid3-hd-checker-on');     //x-grid3-hd-checker-on
                	//grid.getSelectionModel().clearSelections();
	            }
    	}
	});
	
	
	
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
	

/************************导入数据*************************************/
	///ofy2
	/*var btnImport = new Ext.Toolbar.Button({
			text : '导入数据',
			tooltip : '导入数据',
			iconCls : 'icon-import',
			id : 'btnImport',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnImport'),
	      	handler: importData=function () {
				 	var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_DataIMPanel.js"+"&AutCode=MRC_ICDDx"; 
	                	///导入数据窗口 
						var windowImport = new Ext.Window({
										iconCls : 'icon-DP',
										width : 1000,
										height : 560,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
										autoScroll : false,
										collapsible : true,
										hideCollapseTool : true,
										titleCollapse : true,
										constrain : true,
										closeAction : 'close',
										html : '',
										listeners : {
											"show" : function(){
												
											},
											"hide" : function(){
												
											},
											"close" : function(){
											}
										}
									});
						windowImport.html='<iframe id="iframeImport" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowImport.setTitle("导入数据");
						windowImport.show();
				}
	      
    });
*/
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btncopywin,'-',btnEditwin,'-',btnConfig   
				////,'-',btnImport    ///ofy2导入按钮
				,'-',HospWinButton  ///多院区医院
				,'-',btnTrans
				,'-',btnSort,'->',btnlog,'-',btnhislog
				
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
						code:Ext.getCmp("TextCode").getValue(),
						desc:Ext.getCmp("TextDesc").getValue(),
						icd10:Ext.getCmp("Texticd10").getValue(),
						activeflag:Ext.getCmp("TextActive").getValue(),
						type:Ext.getCmp("TextType").getValue(),
						insucode:Ext.getCmp("insucode").getValue(),
						insucodeflag:Ext.getCmp("insucodeflag").getValue(),
						versiondr:Ext.getCmp("TextMRCIDVersionDictDR").getValue(),
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
					Ext.getCmp("Texticd10").reset();
					Ext.getCmp("insucode").reset();
					Ext.getCmp("insucodeflag").reset();
					Ext.getCmp("TextActive").setValue("Y");
					Ext.getCmp("TextType").setValue("");
					Ext.getCmp("TextMRCIDVersionDictDR").setValue("");
					
					grid.getStore().baseParams={
						activeflag:Ext.getCmp("TextActive").getValue(),
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
	// 增删改工具条2
	var tbbutton2 = new Ext.Toolbar({
		enableOverflow : true,
		items : [	 
						'国家医保编码', {
							xtype : 'textfield',
							width:150,
							id : 'insucode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('insucode')
						}, '-', '国家医保编码对照状态',{
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
						},'-','过滤数据',{
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
						}, '-','版本',{
							xtype : 'combo',
							listWidth : 250,
							width:150,
							loadByIdParam : 'rowid',
							fieldLabel : '版本',
							id:'TextMRCIDVersionDictDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextMRCIDVersionDictDR'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextMRCIDVersionDictDR')),
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
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							width:150,
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'描述', {
							xtype : 'textfield',
							width:150,
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
							emptyText : '描述/别名'
						}, '-',
						'ICD10代码', {
							xtype : 'textfield',
							width:150,
							id : 'Texticd10',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('Texticd10')
						}, '-', '数据分类',{
							xtype : 'combo',
							listWidth:150,
							width:150,
							shadow:false,
							id :'TextType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextType'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '西医诊断',
									value : 'XYZD'
								}, {
									name : '中医诊断',
									value : 'ZYZD'
								}, {
									name : '中医证型',
									value : 'ZYZX'
								}, {
									name : '肿瘤形态学编码',
									value : 'ZLBM'
								}, {
									name : '损伤中毒外部原因',
									value : 'SSZD'
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name'
						},'-',
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', 
						btnSearch, '-', btnRefresh
						//, '->',helphtmlbtn
				],
				listeners : {
					render : function() {
						tbbutton2.render(grid.tbar)
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	Ext.getCmp("TextActive").setValue("Y");
	/** grid浮动显示 */
	var girdShow = function (value, meta, rec, rowIdx, colIdx, ds){
		return '<div ext:qtitle="" ext:qtip="' + value + '">'+ value +'</div>';
	}
	var GridCM=[
	new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
	new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ID',
							sortable : true,
							dataIndex : 'MRCIDRowId',
							hidden : true,
							width :80
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'MRCIDCode',
							width : 140
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'MRCIDDesc',
							renderer : girdShow,
							width : 200
						}, {
							header : 'ICD10代码',
							sortable : true,
							renderer : girdShow,
							dataIndex : 'MRCIDICD9CMCode',
							width : 140
						}, {
							header : '国家标准名称',
							sortable : true,
							renderer : girdShow,
							dataIndex : 'MRCIDNationalDesc',
							width : 140
						}, {
							header : '副编码',
							sortable : true,
							dataIndex : 'MRCID2ndCodeInPair',
							width : 140
						}, {
							header : 'ICD9代码',
							sortable : true,
							dataIndex : 'MRCIDICD9Map',
							width : 120
						},  {
							header : '国家医保编码',
							width : 120,
							sortable : true,
							dataIndex : 'MRCIDInsuCode'
						},  {
							header : '国家医保名称',
							width : 120,
							sortable : true,
							dataIndex : 'MRCIDInsuDesc',
							renderer : girdShow
						}, {
							header : '开始日期',
							sortable : true,
							dataIndex : 'MRCIDDateActiveFrom',
							width : 100
						}, {
							header : '结束日期',
							sortable : true,
							dataIndex : 'MRCIDDateActiveTo',
							width : 100
						}/*, {
							header : '诊断类型',
							sortable : true,
							dataIndex : 'MRCIDDiagnosticType',
							width : 100
						}*/, {
							header : '肿瘤形态学编码',
							sortable : true,
							dataIndex : 'MRCIDMetastaticSite',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 120
						}, {
							header : '损伤中毒外部原因',
							sortable : true,
							dataIndex : 'MRCIDInjuryPoisoningCode',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 140
						}, {
							header : '中医证型',
							sortable : true,
							dataIndex : 'MRCIDBillFlag1',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 80
						}, {
							header : '中医诊断',
							sortable : true,
							dataIndex : 'MRCIDBillFlag3',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width :80
						}, {
							header : '就诊类型',
							width : 200,
							sortable : true,
							dataIndex : 'MRCIDClinicType',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '有效',
							sortable : true,
							dataIndex : 'MRCIDValid',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 120
						}, {
							header : '从年龄',
							sortable : true,
							dataIndex : 'MRCIDAgeFrom',
							width : 120
						}, {
							header : '从年龄类型',
							sortable : true,
							dataIndex : 'MRCIDAgeFromType',
							width : 120
						}, {
							header : '到年龄',
							sortable : true,
							dataIndex : 'MRCIDAgeTo',
							width : 120
						}, {
							header : '到年龄类型',
							sortable : true,
							dataIndex : 'MRCIDAgeToType',
							width : 120
						}, {
							header : 'ICD诊断分类',
							sortable : true,
							dataIndex : 'MRCIDTypeDR',
							width : 120
						}, {
							header : '限制性别',
							sortable : true,
							dataIndex : 'MRCIDSexDR',
							width : 120
						}, {
							
							header : '注释',
							sortable : true,
							dataIndex : 'MRCIDLongDescription',
							renderer : girdShow,
							width : 160 
						}, {
							header : '医保灰码',
							sortable : true,
							dataIndex : 'MRCIDGrayCodeFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 120
						}, {
							header : '版本',
							sortable : true,
							dataIndex : 'MRCIDVersionDictDR',
							width : 140
						
						}, {
							header : '罕见病标志',
							sortable : true,
							dataIndex : 'MRCIDRareDiseaseFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 120
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
				title : 'ICD诊断代码',
				//stateful : true,
				//viewConfig : { forceFit : true },
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), //改成单选2020-06-15
				//sm : new Ext.grid.CheckboxSelectionModel(), //多选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	
	
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	
	
	//翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('MRCIDRowId');	           
		 	} else {
		 		var selectrow="";
			 }
				Ext.BDP.FunLib.SelectRowId = selectrow;	

			})
	
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				UpdateData()
			});
	
	/** 快捷键 */
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData);
	
	
	   
	var loadflag=0;   
    /** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [GenHospPanel(hospComp),grid],  //多院区医院
				 listeners:{
			
					'afterlayout':function(){
						//打开页面默认加载数据(以下)
						if (loadflag==0)
						{
							loadflag=1
						   /** grid加载数据 */
							grid.getStore().baseParams={
								code:Ext.getCmp("TextCode").getValue(),
								desc:Ext.getCmp("TextDesc").getValue(),
								icd10:Ext.getCmp("Texticd10").getValue(),
								activeflag:Ext.getCmp("TextActive").getValue(),
								type:Ext.getCmp("TextType").getValue(),
								insucode:Ext.getCmp("insucode").getValue(),
								insucodeflag:Ext.getCmp("insucodeflag").getValue(),
								versiondr:Ext.getCmp("TextMRCIDVersionDictDR").getValue()
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
									limit : pagesize_main
								},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
								}
							});
						}
							
						}
					}
				
				}
			});
		
	
});
