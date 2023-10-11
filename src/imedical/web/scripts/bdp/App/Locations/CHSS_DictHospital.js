/**@author基础数据平台公共产品组 高姗姗**/
/**@argument：医院-组织机构维护**/
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var communityid=Ext.getUrlParam('communityid');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassMethod=SaveData&pEntityName=web.Entity.CT.CHSSDictHospital";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassMethod=OpenData";
	var BindingType = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassQuery=GetDataForCmb1";
	var BindingUp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassQuery=GetDataForCmb2";
	var BindingProvince="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassQuery=GetProvinceForCmb";
	var BindingRecord="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassQuery=GetRecordForCmb";
	var BindingHospital = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var Community_Url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CHSSDictHospital&pClassMethod=GetCurrentCommunity";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	/************************************键盘事件，按键弹出添加窗口***********************************/
	  if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  {
   	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
  } 
  
  		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="CT_Hospital"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
		/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTHospital";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
    
  //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_Hospital"
	});
	var btnImport = new Ext.Toolbar.Button({
		text : '导入数据',
		tooltip : '导入数据',
		iconCls : 'icon-import',
		id : 'btnImport',
		hidden:true,
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('btnImport'),
      	handler: importData=function () {			        
            	var link="dhc.bdp.ext.default.csp?extfilename=App/Locations/CHSS_DictHospitalImport.js"; 
            	if ("undefined"!==typeof websys_getMWToken){
					url += "&MWToken="+websys_getMWToken()
				}
            	/** 导入数据窗口 */
				var windowImport = new Ext.Window({
						iconCls : 'icon-DP',
						width : 800,
						height : 480,
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
								if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
							    {
							    	keymap_main.disable();
							    }
							},
							"hide" : function(){
								Ext.getCmp('ExcelImportPath').reset();
							},
							"close" : function(){
								if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
							    {
									keymap_main.enable();
							    }
							}
						}
					});
				windowImport.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
				windowImport.setTitle("导入数据");
				windowImport.show();
			}
    });
	
	/**-----------------------实现医院维护中的删除功能-------------------------**/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : function DelData() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						AliasGrid.DataRefer = rows[0].get('HOSPRowId');
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('HOSPRowId')
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
												window.parent.location.reload();
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
	/******************************行政地区form**************************/
	//市store
	var dsCity=new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingRecord,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'RowId',
			fields : ['RowId', 'Description'],
			remoteSort : true,
			sortInfo : {
				field : 'RowId',
				direction : 'ASC'
			}
		})
	//县store
	var dsSection=new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingRecord,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'RowId',
			fields : ['RowId', 'Description'],
			remoteSort : true,
			sortInfo : {
				field : 'RowId',
				direction : 'ASC'
			}
		})
	//乡store
	var dsStreet=new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingRecord,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'RowId',
			fields : ['RowId', 'Description'],
			remoteSort : true,
			sortInfo : {
				field : 'RowId',
				direction : 'ASC'
			}
		})
	//村store
	var dsVillage=new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingRecord,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'RowId',
			fields : ['RowId', 'Description'],
			remoteSort : true,
			sortInfo : {
				field : 'RowId',
				direction : 'ASC'
			}
		})
	/** 创建行政地区Form表单 */
	var formRecord = new Ext.form.FormPanel({
				id : 'form-record',
				labelAlign : 'right',
				labelWidth : 110,
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [
                         {name: 'ProvinceDR',mapping:'ProvinceDR',type:'string'},
                         {name: 'CityDR',mapping:'CityDR',type:'string'},
                         {name: 'SectionDR',mapping:'SectionDR',type:'string'},
                         {name: 'StreetDR',mapping:'StreetDR',type:'string'},
                         {name: 'VillageDR',mapping:'VillageDR',type:'string'}
                ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [ {
							xtype : 'combo',
							fieldLabel : '省',
							name : 'ProvinceDR',
							id:'ProvinceDRF',
							hiddenName:'ProvinceDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ProvinceDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ProvinceDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							valueField : 'RowId',
							displayField : 'Description',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingProvince,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'RowId',
								fields : ['RowId', 'Description'],
								remoteSort : true,
								sortInfo : {
									field : 'RowId',
									direction : 'ASC'
								}
							}),
							listeners:{
								'select':function(combo){
									dsCity.baseParams = {
										TableName : "DictCity",
										RowIdParref:combo.getValue()
									}
									dsCity.load({
										params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
										}
									});
								}
							}
						},{
							xtype : 'combo',
							fieldLabel : '市(地区)',
							name : 'CityDR',
							id:'CityDRF',
							hiddenName:'CityDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CityDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CityDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							valueField : 'RowId',
							displayField : 'Description',
							store : dsCity,
							listeners:{
								'select':function(combo){
									dsSection.baseParams = {
										TableName : "DictSection",
										RowIdParref:combo.getValue(),
										communityid:communityid
									}
									dsSection.load({
										params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
										}
									});
								}
							}
						},{
							xtype : 'combo',
							fieldLabel : '县(区)',
							name : 'SectionDR',
							id:'SectionDRF',
							hiddenName:'SectionDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SectionDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SectionDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							valueField : 'RowId',
							displayField : 'Description',
							store : dsSection,
							listeners:{
								'select':function(combo){
									dsStreet.baseParams = {
										TableName : "DictStreet",
										RowIdParref:combo.getValue(),
										communityid:communityid
									}
									dsStreet.load({
										params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
										}
									});
								}
							}
						},{
							xtype : 'combo',
							fieldLabel : '乡(镇/街道办事处)',
							name : 'StreetDR',
							id:'StreetDRF',
							hiddenName:'StreetDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('StreetDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('StreetDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							valueField : 'RowId',
							displayField : 'Description',
							store : dsStreet,
							listeners:{
								'select':function(combo){
									dsVillage.baseParams = {
										TableName : "DictVillage",
										RowIdParref:combo.getValue(),
										communityid:communityid
									}
									dsVillage.load({
										params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
										}
									});
								}
							}
						},{
							xtype : 'combo',
							fieldLabel : '村(街/路/弄)',
							name : 'VillageDR',
							id:'VillageDRF',
							hiddenName:'VillageDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('VillageDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('VillageDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							valueField : 'RowId',
							displayField : 'Description',
							store : dsVillage
						}]
			});
	function loadCity(){
            dsCity.baseParams = {
				TableName : "DictCity",
				RowIdParref:Ext.getCmp("ProvinceDRF").getValue()
			}
			dsCity.load({
				params : {
					start : 0,
					limit : Ext.BDP.FunLib.PageSize.Combo
				}
			});
	}
	function loadSection(){
			dsSection.baseParams = {
				TableName : "DictSection",
				RowIdParref:Ext.getCmp("CityDRF").getValue(),
				communityid:communityid
			}
			dsSection.load({
				params : {
					start : 0,
					limit : Ext.BDP.FunLib.PageSize.Combo
				}
			});
	}
	function loadStreet(){
			dsStreet.baseParams = {
				TableName : "DictStreet",
				RowIdParref:Ext.getCmp("SectionDRF").getValue(),
				communityid:communityid
			}
			dsStreet.load({
				params : {
					start : 0,
					limit : Ext.BDP.FunLib.PageSize.Combo
				}
			});
	}
	function loadVillage(){ 
			dsVillage.baseParams = {
				TableName : "DictVillage",
				RowIdParref:Ext.getCmp("StreetDRF").getValue(),
				communityid:communityid
			}
			dsVillage.load({
				params : {
					start : 0,
					limit : Ext.BDP.FunLib.PageSize.Combo
				}
			});
	}
	function disabled(){
		if((Ext.getCmp('CommunityTypeF').getRawValue())=='市卫生局')
		{
		    Ext.getCmp("SectionDRF").setDisabled(true);
			Ext.getCmp("StreetDRF").setDisabled(true);
			Ext.getCmp("VillageDRF").setDisabled(true);
		}
		else  if(((Ext.getCmp('CommunityTypeF').getRawValue())=='县（区）卫生局'))
		{
			Ext.getCmp("StreetDRF").setDisabled(true);
			Ext.getCmp("VillageDRF").setDisabled(true);
		}
		else if(((Ext.getCmp('CommunityTypeF').getRawValue())=='乡镇卫生院') || ((Ext.getCmp('CommunityTypeF').getRawValue())=='社区卫生服务中心'))
		{	
			Ext.getCmp("VillageDRF").setDisabled(true);		
		}
		else if((Ext.getCmp('CommunityTypeF').getRawValue())=='省卫生厅')
		{
			Ext.getCmp("CityDRF").setDisabled(true);
		    Ext.getCmp("SectionDRF").setDisabled(true);
			Ext.getCmp("StreetDRF").setDisabled(true);
			Ext.getCmp("VillageDRF").setDisabled(true);
		}
		else {	
			Ext.getCmp("VillageDRF").setDisabled(false);	
		}
	};
	//加载数据
	formRecord.on('afterlayout', function(panel, layout) {
		disabled();
	});
	var winRecord = new Ext.Window({
		title : '',
		width : 350,
		height : 250,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : false,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		items : formRecord,
		buttons : [{
			text : '确定',
			id:'confm_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('confm_btn'),
			handler : function ConfmData() {
				var Type=Ext.getCmp('CommunityTypeF').getRawValue();
				if (Type == '省卫生厅')
				{
					var privince = Ext.getCmp('ProvinceDRF').getRawValue();
					var privinceId = Ext.getCmp('ProvinceDRF').getValue();
					Ext.getCmp('Record').setValue(privince);
					Ext.getCmp('RecordDR').setValue(privinceId);
					winRecord.hide();
				}
				else if (Type == '市卫生局')
				{
					var city = Ext.getCmp('CityDRF').getRawValue();
					var cityId = Ext.getCmp('CityDRF').getValue();
					Ext.getCmp('Record').setValue(city);
					Ext.getCmp('RecordDR').setValue(cityId);
					winRecord.hide();
				}
				else if(Type == '县（区）卫生局')
				{
					var section = Ext.getCmp('SectionDRF').getRawValue();
					var sectionId = Ext.getCmp('SectionDRF').getValue();
					Ext.getCmp('Record').setValue(section);
					Ext.getCmp('RecordDR').setValue(sectionId);
					winRecord.hide();
				}
				else if(Type == '社区卫生服务中心'||Type == '乡镇卫生院'){
					var street = Ext.getCmp('StreetDRF').getRawValue();
					var streetId = Ext.getCmp('StreetDRF').getValue();
					Ext.getCmp('Record').setValue(street);
					Ext.getCmp('RecordDR').setValue(streetId);
					winRecord.hide();
				}
				else      												
				{
					var village = Ext.getCmp('VillageDRF').getRawValue();
					var villageId = Ext.getCmp('VillageDRF').getValue();
					Ext.getCmp('Record').setValue(village);
					Ext.getCmp('RecordDR').setValue(villageId);
					winRecord.hide();
				}
			}
		}, {
			text : '取消',
			handler : function() {
				winRecord.hide();
			}
		}]
	});
	//读取当前所选社区编码
/*	var CommunityFields = ["VillageDR","StreetDR","SectionDR","CityDR","ProvinceDR","VillageName","StreetName","SectionName","CityName","ProvinceName"];		
	var CommunityInfoDs = new Ext.data.Store({
			baseParams:{CommunityCode:communityid},
			proxy : new Ext.data.HttpProxy({
						url : Community_Url,
						method : "POST"
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success',
						fields : CommunityFields
					})
		});
	CommunityInfoDs.load({
			params : {
				start : 0,
				limit : Ext.BDP.FunLib.PageSize.Combo
			},
			callback: function(r, options, success) {
				if(CommunityInfoDs.getCount()==1){
						var CommunityRecord = CommunityInfoDs.getAt(0);
						Ext.getCmp('ProvinceDRF').setRawValue(CommunityRecord.get("ProvinceName"));
						Ext.getCmp('CityDRF').setRawValue(CommunityRecord.get("CityName"));
						Ext.getCmp('SectionDRF').setRawValue(CommunityRecord.get("SectionName"));
						Ext.getCmp('StreetDRF').setRawValue(CommunityRecord.get("StreetName")); 
						Ext.getCmp('ProvinceDRF').setValue(CommunityRecord.get("ProvinceDR"));	
						Ext.getCmp('CityDRF').setValue(CommunityRecord.get("CityDR"));
						Ext.getCmp('SectionDRF').setValue(CommunityRecord.get("SectionDR"));
						Ext.getCmp('StreetDRF').setValue(CommunityRecord.get("StreetDR"));
						loadCity();
						loadSection();
						loadStreet();
						loadVillage(); 
				}
			}
	});*/
/************************************增加修改的Form************************************/
	var HOSPCode=new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '<font color=red>*</font>代码',
			allowBlank:false,
		 	blankText: '代码不能为空',
			name : 'HOSPCode',
			id:'HOSPCode',	
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPCode')),
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPCode'),
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPCode'),
			enableKeyEvents : true,
			validationEvent : 'blur',  
            validator : function(thisText){
              if(thisText==""){  //当文本框里的内容为空的时候不用此验证
              return true;
              }
                var className =  "web.DHCBL.CT.CHSSDictHospital";   
                var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
                var id="";
                if(win.title=='修改'){  
                	var _record = grid.getSelectionModel().getSelected();
                	var id = _record.get('HOSPRowId');  
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
		        'change' : function(obj){
					var _codedom=document.getElementById('code-icon');
					if(_codedom!=null) _codedom.parentNode.removeChild(_codedom);
		        	if(obj.isValid()){  
		        		var _parentNode = obj.el.dom.parentNode;
						var valid =  Ext.get(_parentNode).createChild({
							         	    	 tag : 'span',
							         	    	 id : 'code-icon',
							        		     html : "<img  src ='"+Ext.BDP.FunLib.Path.URL_Icon+"/accept.png' style='border: 0px' />"
							     			});
		        	}
		    	},
		    	'blur':function(){
		    		Ext.getCmp("CommunityCode").setValue(Ext.getCmp("HOSPCode").getValue());
		    	}
		    }
	
	});
	var HOSPDesc=new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '<font color=red>*</font>描述',
			allowBlank:false,
			blankText: '描述不能为空',
			name : 'HOSPDesc',
			id:'HOSPDesc',
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDesc')),
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDesc'),
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDesc'),
			enableKeyEvents : true,
			validationEvent : 'blur',
            validator : function(thisText){
                if(thisText==""){  
                	return true;
                }
                var className =  "web.DHCBL.CT.CHSSDictHospital"; //后台类名称
                var classMethod = "FormValidate"; //数据重复验证后台函数名
                var id="";
                if(win.title=='修改'){ 
                	var _record = grid.getSelectionModel().getSelected();
                	var id = _record.get('HOSPRowId');  
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
		        'change' : function(obj){
					var _descdom=document.getElementById('desc-icon');
					if(_descdom!=null) _descdom.parentNode.removeChild(_descdom);
		        	if(obj.isValid()){   //当数据验证通过时要显示对号
		        		var _parentNode = obj.el.dom.parentNode;
						var valid =  Ext.get(_parentNode).createChild({
							         	    	 tag : 'span',
							         	    	 id : 'desc-icon',
							        		     html : "<img  src ='"+Ext.BDP.FunLib.Path.URL_Icon+"/accept.png' style='border: 0px' />"
							     			});
		        	}
		    	},
		    	'blur':function(){
		    		Ext.getCmp("CommunityName").setValue(Ext.getCmp("HOSPDesc").getValue());
		    	}
		    }
	});
	var HOSPDateFrom=new Ext.BDP.FunLib.Component.DateField({
			fieldLabel : '<font color=red>*</font>开始日期',
			name :'HOSPDateFrom',
			id:'HOSPDateFromF',
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDateFromF')),
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateFromF'),
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateFromF'),
			//format : 'Y/m/d',
			format : BDPDateFormat,
			allowBlank:false,
			enableKeyEvents : true,
			listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
			blankText: '开始日期不能为空'
	});
	var HOSPDateTo=new Ext.BDP.FunLib.Component.DateField({
			xtype : 'datefield',
			fieldLabel : '&nbsp;结束日期',
			name : 'HOSPDateTo',
			id:'HOSPDateToF',
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDateToF')),
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateToF'),
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateToF'),
			//format : 'Y/m/d',
			format : BDPDateFormat,
			enableKeyEvents : true,
			listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
	});
	var HOSPMandatoryRefHospital=new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '&nbsp;是否转诊医院',
			name :'HOSPMandatoryRefHospital',
			id:'HOSPMandatoryRefHospitalF',
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPMandatoryRefHospitalF')),
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPMandatoryRefHospitalF'),
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPMandatoryRefHospitalF'),
			autoHeight:'true',
			inputValue : true?'Y':'N'
	});
	//社区ID
	var RowId=new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : 'RowId',
			hideLabel : 'True',
			hidden : true,
			name : 'RowId'
	});
	//社区编码
	var CommunityCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel:'<font color=red>*</font>机构编码',
		id:'CommunityCode',
		name:'CommunityCode',
		allowBlank:false,
		blankText:'机构编码不能为空',
		regex:/^[a-zA-Z0-9]*$/,
		regexText:'只能输入数字和字母'
	});
	//社区名称
	var CommunityName = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel:'<font color=red>*</font>机构名称',
		id:'CommunityName',
		name:'CommunityName',
		allowBlank:false,
		blankText:'机构名称不能为空'
	});
	//社区类别
	var CommunityType = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '<font color=red>*</font>机构类别',	
		name : 'CommunityType',
		id : 'CommunityTypeF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CommunityTypeF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CommunityTypeF')),
		hiddenName : 'CommunityType',
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		minChars : 0,
		listWidth : 250,
		valueField : 'Description',
		displayField : 'Description',
		allowBlank:false,
		blankText:'机构类别不能为空',
		store : new Ext.data.JsonStore({
			url : BindingType,
			baseParams:{communityid:communityid},
			autoLoad : true,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'Description',
			fields : ['Description', 'Description'],
			remoteSort : true,
			sortInfo : {
				field : 'Description',
				direction : 'ASC'
			}
		})
	});
	//对应的社区机构
	var Record = new Ext.BDP.FunLib.Component.TextField({
		id:'Record',
		name:'Record',
		allowBlank:false,
		blankText:'对应行政地区不能为空',
		readOnly:true,
		flex:1
	});
	//对应社区机构选择按钮
	var btn = new Ext.Button({
		text:'选择',
		width:35,
		tooltip:'选择行政地区',
		handler:function(){
			var vtype =Ext.getCmp('CommunityTypeF').getRawValue();
			if (vtype =='')
			{
				Ext.Msg.show({
		                title : '提示',
						msg : '请选择机构类别!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
		           });
			}
			else {
				winRecord.setTitle('选择机构');
				winRecord.show('');
				Ext.Ajax.request({
	                url:  Community_Url,
	                params: {'CommunityCode': communityid},
	                callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							Ext.getCmp("ProvinceDRF").setValue(jsonData.ProvinceDR);
							Ext.getCmp("CityDRF").setValue(jsonData.CityDR);
							Ext.getCmp("SectionDRF").setValue(jsonData.SectionDR);
							Ext.getCmp("StreetDRF").setValue(jsonData.StreetDR);
							Ext.getCmp("VillageDRF").setValue(jsonData.VillageDR);
							Ext.getCmp("ProvinceDRF").setRawValue(jsonData.ProvinceName);
							Ext.getCmp("CityDRF").setRawValue(jsonData.CityName);
							Ext.getCmp("SectionDRF").setRawValue(jsonData.SectionName);
							Ext.getCmp("StreetDRF").setRawValue(jsonData.StreetName);
							Ext.getCmp("VillageDRF").setRawValue(jsonData.VillageName);
							loadCity();
							loadSection();
							loadStreet();
							loadVillage(); 
						}
	                }
	            });
					
			}
		}
	});
	//上级编码
	var dsUpCommunity = new Ext.data.JsonStore({
			url : BindingUp,
			autoLoad : true,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CommunityCode',
			fields : ['CommunityCode', 'CommunityName'],
			remoteSort : true,
			sortInfo : {
				field : 'CommunityCode',
				direction : 'ASC'
			}
		})
	var UpCommunityCode = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '<font color=red>*</font>上级医疗机构',	
		name : 'UpCommunityCode',
		id : 'UpCommunityCodeF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('UpCommunityCodeF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('UpCommunityCodeF')),
		hiddenName : 'UpCommunityCode',
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		minChars : 0,
		listWidth : 250,
		valueField : 'CommunityCode',
		displayField : 'CommunityName',
		allowBlank:false,
		blankText:'上级医疗机构不能为空',
		store : dsUpCommunity
	});
		
	//对应社区机构ID
	var RecordDR = new Ext.BDP.FunLib.Component.TextField({
		id:'RecordDR',
		name:'RecordDR',
		hidden:true,
		labelSeparator:''
	});
	//HospitalDR
	var HospitalDR = new Ext.BDP.FunLib.Component.BaseComboBox({
		//fieldLabel : 'HospitalDR',	
		name : 'HospitalDR',
		id : 'HospitalDRF',
		hidden:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('HospitalDRF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HospitalDRF')),
		hiddenName : 'HospitalDR',
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		minChars : 0,
		listWidth : 250,
		valueField : 'HOSPRowId',
		displayField : 'HOSPDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingHospital,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'HOSPRowId',
			fields : ['HOSPRowId', 'HOSPDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'HOSPRowId',
				direction : 'ASC'
			}
		})
	});
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				title : '基本信息',		
				labelAlign : 'right',
				split : true,
				frame : true,
				reader : new Ext.data.JsonReader({root:'data'},
					[{name : 'RowId',mapping : 'RowId',type : 'string'},
					{name : 'HOSPCode',mapping : 'HOSPCode',type : 'string'},
					{name : 'HOSPDesc',mapping : 'HOSPDesc',type : 'string'},
					{name : 'HOSPDateFrom',mapping : 'HOSPDateFrom',type : 'string'},
					{name : 'HOSPDateTo',mapping : 'HOSPDateTo',type : 'string'},
					{name : 'HOSPMandatoryRefHospital',mapping : 'HOSPMandatoryRefHospital',type : 'string'},
					{name : 'CommunityCode',mapping : 'CommunityCode',type : 'string'},
					{name : 'CommunityName',mapping : 'CommunityName',type : 'string'},
					{name : 'UpCommunityCode',mapping : 'UpCommunityCode',type : 'string'},
					{name : 'CommunityType',mapping : 'CommunityType',type : 'string'},
					{name : 'HospitalDR',mapping : 'HospitalDR',type : 'string'},
					{name : 'RecordDR',mapping : 'RecordDR',type : 'string'},
					{name : 'Record',mapping : 'Record',type : 'string'}
				]),
				items : [{
					xtype : 'fieldset',
					title : '医院维护',
					autoHeight : true,
					items : [{
						layout : 'column',
						border : false,
						items : [{
							columnWidth : '.5',
							layout : 'form',
							labelWidth :85,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '98%',
								xtype : 'textfield'
							},
							items : [HOSPCode,HOSPDateFrom,HOSPMandatoryRefHospital]
						},{
							columnWidth : '.5',
							layout : 'form',
							labelWidth :85,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '98%',
								xtype : 'textfield'
							},
							items : [HOSPDesc,HOSPDateTo]
						}]
					}]
				},{
					xtype : 'fieldset',
					title : '医疗机构维护',
					autoHeight : true,
					items : [{
						layout : 'column',
						border : false,
						items : [{
							columnWidth : '.5',
							layout : 'form',
							labelWidth : 85,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '98%',
								xtype : 'textfield'
							},
							items : [CommunityCode,CommunityType,UpCommunityCode,HospitalDR]
						},{
							columnWidth : '.5',
							layout : 'form',
							labelWidth : 85,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '98%',
								xtype : 'textfield'
							},
							items : [CommunityName,{
											xtype: 'compositefield',  
						    				fieldLabel : '<font color=red>*</font>行政地区',
						    				labelSeparator:"",
											items:[Record,btn]
											},RecordDR,RowId
									]
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
	 
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		title : '',
		width : 680,
		height : 430,
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
		labelWidth : 65,
		items : tabs,
		buttons : [{
			text : '保存',
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("HOSPCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("HOSPDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("HOSPDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("HOSPDateTo").getValue();
			var CommunityCode = Ext.getCmp("form-save").getForm().findField("CommunityCode").getValue();
			var CommunityName = Ext.getCmp("form-save").getForm().findField("CommunityName").getValue();
			if(WinForm.getForm().isValid()==false){ return;}
			if (tempCode=="") {
				Ext.Msg.show({ title : '提示', msg : '代码不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({ title : '提示', msg : '描述不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (startDate=="") {
				Ext.Msg.show({ title : '提示', msg : '开始日期不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (CommunityCode=="") {
				Ext.Msg.show({ title : '提示', msg : '机构编码不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (CommunityName=="") {
				Ext.Msg.show({ title : '提示', msg : '机构名称不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
			 	
			    	if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,
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
												//Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												var startIndex = grid.getBottomToolbar().cursor;
													grid.getStore().load({
														params : {
															start : 0,
															limit : 1,
															rowid : myrowid
														}
													});
												AliasGrid.DataRefer = myrowid;
												AliasGrid.saveAlias();
												window.parent.location.reload();
												/*var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize,
																rowid : myrowid
															}
														});*/
											}
								});
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
								url : SAVE_ACTION_URL_New,
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
												window.parent.location.reload();
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
				Ext.getCmp("form-save").getForm().findField("HOSPCode").focus(true,50);
			},
			"hide" : function() {
				var _codedom=document.getElementById('code-icon');
				var _descdom=document.getElementById('desc-icon');
				if(_codedom!=null) _codedom.parentNode.removeChild(_codedom);
				if(_descdom!=null) _descdom.parentNode.removeChild(_descdom);
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
				handler : function AddData() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					dsUpCommunity.baseParams = {
						communityid : communityid
					}
					dsUpCommunity.load();
					dsUpCommunity.on("load",function(){
						Ext.getCmp("UpCommunityCodeF").setValue("");
					})
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
				handler : function UpdateData() {
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						var record = grid.getSelectionModel().getSelected();// records[0]
						/*Ext.getCmp("form-save").getForm().loadRecord(record);
						Ext.getCmp("form-save").getForm().findField('HOSPMandatoryRefHospital').setValue((record.get('HOSPMandatoryRefHospital'))=='Y'?true:false);*/
						
						Ext.getCmp("form-save").getForm().load({
							url : OPEN_ACTION_URL + '&id='+ record.get('HOSPRowId'),
							//waitMsg : '正在载入数据...',
							success : function(form, action) {
								dsUpCommunity.baseParams = {
									communityid : action.result.data.UpCommunityCode
								}
								dsUpCommunity.load();
								dsUpCommunity.on("load",function(){
									Ext.getCmp("UpCommunityCodeF").setValue(action.result.data.UpCommunityCode);
								})
							},
							failure : function(form, action) {
								Ext.Msg.alert('编辑', '载入失败');
							}
						});
						//激活基本信息面板
			            tabs.setActiveTab(0);
						//加载别名面板
	            		AliasGrid.DataRefer = record.get('HOSPRowId');
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
/************************************数据存储***********************************/
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
									
						}, [{     
						            name : 'HOSPRowId',
									mapping :'HOSPRowId',
									type : 'string'
								}, {
									name : 'HOSPCode',
									mapping : 'HOSPCode',
									type : 'string'
								}, {
									name : 'HOSPDesc',
									mapping :'HOSPDesc',
									type:'string'
								},{
									name:'HOSPDateFrom',
									mapping:'HOSPDateFrom',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name :'HOSPDateTo',
									mapping :'HOSPDateTo',
									type : 'date',
									dateFormat : 'm/d/Y'
								},{
									name:'HOSPMandatoryRefHospital',
									mapping:'HOSPMandatoryRefHospital',
									inputValue : true?'Y':'N'
								} 
						]),
				remoteSort : true
			});	
	/************************************数据加载************************************/
	ds.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		     communityid:communityid
		  }   
		)
	});
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
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-' ,btnTrans,'-',btnSort,'-',btnImport]
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
						limit : pagesize,
						communityid:communityid
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
									limit : pagesize,
									communityid:communityid
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
				columns : [sm, {
							header :'HOSPRowId',
							width : 60,
							sortable : true,
						    hidden:true,
							dataIndex : 'HOSPRowId'
					  }, {
							header : '代码',
							width : 120,
							sortable : true,
							dataIndex : 'HOSPCode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							dataIndex : 'HOSPDesc'
						},{
							header : '开始日期',
							width : 120,
							sortable : true,
							//renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'HOSPDateFrom'
						}, {
							header : '结束日期',
							width : 120,
							sortable : true,
							//renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'HOSPDateTo'
						},{
							header : '是否转诊医院',
							width : 160,
							sortable : true,
							dataIndex : 'HOSPMandatoryRefHospital',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				title : '医院维护',
				stateful : true,
				viewConfig : {
				forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
/************************************双击事件************************************/
	  		var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('HOSPRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	        	},
	                failure : function(form,action) {
	                }
	            });
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
	        	var record = grid.getSelectionModel().getSelected();// records[0]
				/*Ext.getCmp('form-save').getForm().loadRecord(record);
				Ext.getCmp("form-save").getForm().findField('HOSPMandatoryRefHospital').setValue((record.get('HOSPMandatoryRefHospital'))=='Y'?true:false);*/
				WinForm.form.load({
					url : OPEN_ACTION_URL + '&id='+ record.get('HOSPRowId'),
					//waitMsg : '正在载入数据...',
					success : function(form, action) {
						dsUpCommunity.baseParams = {
							communityid : action.result.data.UpCommunityCode
						}
						dsUpCommunity.load();
						dsUpCommunity.on("load",function(){
							Ext.getCmp("UpCommunityCodeF").setValue(action.result.data.UpCommunityCode);
						})
					},
					failure : function(form, action) {
						Ext.Msg.alert('编辑', '载入失败');
					}
				});						//激活基本信息面板
	        	//加载别名面板
	            AliasGrid.DataRefer = record.get('HOSPRowId');
		        AliasGrid.loadGrid();
	    });	
	    
	    	//单击事件（翻译按钮要用到）
	grid.on("rowclick", function(grid, rowIndex, e) {
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('HOSPRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
});
