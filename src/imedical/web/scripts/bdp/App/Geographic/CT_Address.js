/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于地址维护 
 * @LastUpdated on 2015-11-13 
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
   	Ext.form.Field.prototype.msgTarget = 'qtip'; 
    var limit = Ext.BDP.FunLib.PageSize.Main;
    var combopage=Ext.BDP.FunLib.PageSize.Combo  
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
 
	var ACTION_URL ="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.CTAddress&pClassMethod=GetList"; 
    // "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTAddress&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTAddress&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTAddress";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTAddress&pClassMethod=DeleteData";
	/// 省份
	var PROVINCE_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTProvince&pClassQuery=GetDataForCmb1";
	/// 市
	var CITY_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCity&pClassQuery=GetDataForCmb1";
	/// 城市区域
	var CITYAREA_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCityArea&pClassQuery=GetDataForCmb2";
	/// 街道/乡镇
	var STREET_QUERY_ACTION="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.CTLocalityType&pClassMethod=GetDataForCmb1&type="+escape('Street'); 
	/// 社区
	var COMMUNITY_QUERY_ACTION="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.CTCommunity&pClassMethod=GetDataForCmb1"; 
	
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTAddress&pClassMethod=OpenData";
	var GETCODE_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTAddress&pClassMethod=GetCode";
    /*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.CTAddress";
    var btnSort = Ext.BDP.FunLib.SortBtn;
 
    //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "CT_Address"
    });
     Ext.BDP.FunLib.TableName="CT_Address";
     /// 获取查询配置按钮 
     var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
	 var btnTrans=Ext.BDP.FunLib.TranslationBtn;
	 var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	 if (TransFlag=="false")
	 {
		btnTrans.hidden=false;
	  }
	 else
	 {
		btnTrans.hidden=true;
	  }
	 //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName) ;
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
	       RowID=rows[0].get('CTADDRowId');
	       Desc=rows[0].get('CTADDDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
	    }
  }); 	  
	  
	/************************导入地址数据*************************************/
	var btnImport = new Ext.Toolbar.Button({
			text : '导入地址数据',
			tooltip : '导入地址数据',
			iconCls : 'icon-import',
			id : 'btnImport',
			hidden:true,
			//disabled : Ext.BDP.FunLib.Component.DisableFlag('btnImport'),
	      	handler: importData=function () {			        ;
				 	//alert(selectNode)
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/ctaddimport";
	                	if ('undefined'!==typeof websys_getMWToken){
							link += "&MWToken="+websys_getMWToken()
						} 
	                	/** 导入地址数据窗口 */
						var windowImport = new Ext.Window({
										iconCls : 'icon-DP',
										width : 800,
										height : 480,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
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
												//Ext.getCmp('ExcelImportPath').reset();
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
						windowImport.setTitle("导入地址数据");
						windowImport.show();
				}
	      
    });
	/***********************规定资源维护中的删除功能*************************************/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		id:'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		iconCls : 'icon-delete',
		handler : DelData=function() {
			    var records =  grid.selModel.getSelections();
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
                         //删除所有别名
                        AliasGrid.DataRefer=records[0].get('CTADDRowId') ;
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('CTADDRowId') 
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
											animEl: 'form-save',
											fn : function(btn) {
													 Ext.BDP.FunLib.DelForTruePage(grid,limit);
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
														animEl: 'form-save',
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
													icon : Ext.Msg.ERROR,
													animEl: 'form-save',
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
                [        {name: 'CTADDRowId',mapping:'CTADDRowId',type:'int'},
                         {name: 'CTADDCode',mapping:'CTADDCode',type:'string'},
                         {name: 'CTADDDesc',mapping:'CTADDDesc',type:'string'},
                         {name: 'CTADDProvinceDR',mapping:'CTADDProvinceDR',type:'string'},
                         {name: 'CTADDCityDR',mapping:'CTADDCityDR',type:'string'},
                         {name: 'CTADDCityAreaDR',mapping:'CTADDCityAreaDR',type:'string'},
                         {name: 'CTADDStreetDR',mapping:'CTADDStreetDR',type:'string'},
                         {name: 'CTADDCommunityDR',mapping:'CTADDCommunityDR',type:'string'},
                         {name: 'CTADDSearchCode',mapping:'CTADDSearchCode',type:'string'},
                         {name: 'CTADDDateFrom',mapping:'CTADDDateFrom',type:'string'},
                         {name: 'CTADDDateTo',mapping:'CTADDDateTo',type:'string'}                 
               ]);
     /// Rowid  
    var RowIdText=new Ext.BDP.FunLib.Component.TextField({
	        fieldLabel : 'CTADDRowId',
	        hideLabel : 'True',
	        hidden : true,
	        name : 'CTADDRowId'
    });
    /// Code
    var codeText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : '<font color=red>*</font>代码',
	       allowBlank:false,
	       regexText:"代码不能为空",
	       name : 'CTADDCode',
	       id:'CTADDCodeF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDCodeF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDCodeF')),
	       enableKeyEvents : true,
	       validationEvent : 'blur',  
           validator : function(thisText){
              if(thisText==""){   
                 return true;
               }
              var className =  "web.DHCBL.CT.CTAddress";   
              var classMethod = "FormValidate";                           
              var id="";
              if(win.title=='修改'){  
                 var _record = grid.getSelectionModel().getSelected();
                 var id = _record.get('CTADDRowId');  
               }
               var flag = "";
               var flag = tkMakeServerCall(className,classMethod,id,thisText); 
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
     });
    /// DESC
    var descText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : '<font color=red>*</font>描述',
	       allowBlank:false,
	       regexText:"描述不能为空",
	       name : 'CTADDDesc',
	       id:'CTADDDescF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDDescF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDDescF')) 
    });
    var ProvinceStore=new Ext.data.Store({
         	proxy : new Ext.data.HttpProxy({ url : PROVINCE_QUERY_ACTION }),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'PROVRowId', 'PROVDesc' ])
       });
       
    var CityStore=new Ext.data.Store({
         	proxy : new Ext.data.HttpProxy({ url : CITY_QUERY_ACTION }),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'CTCITRowId', 'CTCITDesc' ])
       });
   var CityAreaStore=new Ext.data.Store({
         	proxy : new Ext.data.HttpProxy({ url : CITYAREA_QUERY_ACTION }),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'CITAREARowId', 'CITAREADesc' ])
     });
     
   var StreetStore=new Ext.data.Store({
         	proxy : new Ext.data.HttpProxy({ url : STREET_QUERY_ACTION }),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'LOCTYPERowId', 'LOCTYPEDesc' ])
       });
    var CommunityStore=new Ext.data.Store({
         	proxy : new Ext.data.HttpProxy({ url : COMMUNITY_QUERY_ACTION }),
         	reader : new Ext.data.JsonReader({
          	totalProperty : 'total',
          	root : 'data',
          	successProperty : 'success'
         }, [ 'CTCMUNTRowId', 'CTCMUNTDesc' ])
       });
    /// 省份
    var ProvinceDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel : '<font color=red>*</font>省',
        name : 'CTADDProvinceDR',
        id:'CTADDProvinceDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDProvinceDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDProvinceDRF')),
        allowBlank:false,
        store :ProvinceStore ,
	    queryParam : 'desc',
	    triggerAction : 'all',
	    forceSelection : true,
	    selectOnFocus : false,
	    minChars : 0,
	    listWidth : 250,
	    valueField : 'PROVRowId',
	    displayField : 'PROVDesc',
	    hiddenName : 'CTADDProvinceDR',
	    pageSize :combopage,
	    listeners:{
		    'select': function(field,e){
				Ext.getCmp("CTADDCityDRF").reset();
				Ext.getCmp("CTADDCityAreaDRF").reset();
				Ext.getCmp("CTADDStreetDRF").reset();
				Ext.getCmp("CTADDCommunityDRF").reset();
				Ext.getCmp("CTADDCodeF").reset(); 	 
				Ext.getCmp("CTADDDescF").reset();
				Ext.getCmp("CTADDSearchCodeF").reset();
            }
         }		
    });
     /// 市
    var CityDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel : '<font color=red>*</font>市',
        name : 'CTADDCityDR',
        id:'CTADDCityDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDCityDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDCityDRF')),
        allowBlank:false,
        store :CityStore,
	    queryParam : 'desc',
	    triggerAction : 'all',
	    forceSelection : true,
	    selectOnFocus : false,
	    minChars : 0,
	    listWidth : 250,
	    valueField : 'CTCITRowId',
	    displayField : 'CTCITDesc',
	    hiddenName : 'CTADDCityDR',
	    pageSize :combopage,
	    listeners:{
		     'beforequery':function(obj){
		     	if (Ext.getCmp("CTADDProvinceDRF").getValue()=="")
		     	{
       	  			return false;   
		     	}
		     	else{
		         obj.combo.store.baseParams = {
							start:0,
		           			limit:combopage,
		          			desc:obj.combo.getRawValue(),
		          			provincedr:Ext.getCmp("CTADDProvinceDRF").getValue()
						};
         		obj.combo.store.load();
		     }
            },
	     	'change':function(){
	     		CityChange()
	     	},
	     	'select':function(){
	     		CityChange()
	     	}
    	}					
    });
    var CityChange=function(){
    	Ext.getCmp("CTADDCityAreaDRF").reset();
		Ext.getCmp("CTADDStreetDRF").reset();
		Ext.getCmp("CTADDCommunityDRF").reset();
		Ext.getCmp("CTADDCodeF").reset(); 	 
		Ext.getCmp("CTADDDescF").reset();
		Ext.getCmp("CTADDSearchCodeF").reset();
		if (Ext.getCmp('CTADDProvinceDRF').getRawValue()!=""){
			if(Ext.getCmp('CTADDProvinceDRF').getRawValue().indexOf('-')>0){
 				ProvinceArr=(Ext.getCmp('CTADDProvinceDRF').getRawValue()).split('-');
 				ProvinceValue=ProvinceArr[1];
			}
			else{
				ProvinceValue=Ext.getCmp('CTADDProvinceDRF').getRawValue() ;
			}
 		}
        /// 获取城市数据
 		if (Ext.getCmp('CTADDCityDRF').getRawValue()!=""){
			if(Ext.getCmp('CTADDCityDRF').getRawValue().indexOf('-')>0){
				CityArr=(Ext.getCmp('CTADDCityDRF').getRawValue()).split('-');
				CityValue=CityArr[0];
			}
			else{
				CityValue=Ext.getCmp('CTADDCityDRF').getRawValue();
			}
	}
	AddressValue=ProvinceValue+CityValue;
	Ext.getCmp('CTADDDescF').setValue(AddressValue);
	var CTADDSearchCodeValue=Pinyin.GetJP(AddressValue);
	Ext.getCmp('CTADDSearchCodeF').setValue(CTADDSearchCodeValue);
	Ext.Ajax.request({
		url:GETCODE_URL ,
		method:'POST',
		params:{
			'Province': Ext.getCmp('CTADDProvinceDRF').getValue(),  
			'City':Ext.getCmp('CTADDCityDRF').getValue()
		},
		callback:function(options, success, response){
			if(success){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				if(jsonData.success == 'true'){
				 		 Ext.getCmp('CTADDCodeF').setValue(jsonData.id);
					} 
			}
			else{
				Ext.Msg.show({
					 	title : '提示',
			            msg : '获取地址代码失败,请手动输入代码!',
			            icon : Ext.Msg.ERROR,
			            buttons : Ext.Msg.OK,
			            fn:function(){
			            	Ext.getCmp('CTADDCodeF').focus();
			            }
				});
			}
		}
	});	
    }
    //// 城市区域
       var CityAreaDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel:'城市区域',
        name:'CTADDCityAreaDR',
        id:'CTADDCityAreaDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDCityAreaDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDCityAreaDRF')),
        allowBlank:true,
        store : CityAreaStore,
	    queryParam : 'desc',
	    triggerAction : 'all',
	    forceSelection : true,
	    selectOnFocus : false,
	    minChars : 0,
	    listWidth : 250,
	    valueField : 'CITAREARowId',
	    displayField : 'CITAREADesc',
	    hiddenName : 'CTADDCityAreaDR',
	    pageSize :combopage,
	    listeners:{
		     'beforequery':function(obj){
		     	if (Ext.getCmp("CTADDCityDRF").getValue()=="")
		     	{
		     		return false;
		     	}
		     	else{
		     		 obj.combo.store.baseParams = {
							start:0,
		           			limit:combopage,
		          			desc:obj.combo.getRawValue(),
		          			citydr:Ext.getCmp("CTADDCityDRF").getValue()
						};
         			obj.combo.store.load();
		     	}
            },
	     	'change':function(){
	     		CityAreaChange()
	     	},
	     	'select':function(){
	     		CityAreaChange()
	     	}
            
    	}					
    });
    var CityAreaChange=function(){
    	var ProvinceArr=new Array();
 		var CityArr=new Array();
 		var CityAreaArr=new Array();
 		var AddressValue="";
 		Ext.getCmp("CTADDStreetDRF").reset();
		Ext.getCmp("CTADDCommunityDRF").reset();
		Ext.getCmp('CTADDSearchCodeF').reset();
 		Ext.getCmp('CTADDCodeF').reset();
 		Ext.getCmp('CTADDDescF').reset();
 		if (Ext.getCmp('CTADDProvinceDRF').getRawValue()!=""){
    			if(Ext.getCmp('CTADDProvinceDRF').getRawValue().indexOf('-')>0){
     				ProvinceArr=(Ext.getCmp('CTADDProvinceDRF').getRawValue()).split('-');
     				ProvinceValue=ProvinceArr[1];
    			}
    			else{
    				ProvinceValue=Ext.getCmp('CTADDProvinceDRF').getRawValue() ;
    			}
     		}
     		if (Ext.getCmp('CTADDCityDRF').getRawValue()!=""){
    			if(Ext.getCmp('CTADDCityDRF').getRawValue().indexOf('-')>0){
    				CityArr=(Ext.getCmp('CTADDCityDRF').getRawValue()).split('-');
    				CityValue=CityArr[0];
    			}
    			else{
    				CityValue=Ext.getCmp('CTADDCityDRF').getRawValue();
    			}
		}
			/// 城市区域可以为空,比如直辖市 
		if (Ext.getCmp('CTADDCityAreaDRF').getRawValue()!=""){
			if (Ext.getCmp('CTADDCityAreaDRF').getRawValue().indexOf('-')>0){
				CityAreaArr=(Ext.getCmp('CTADDCityAreaDRF').getRawValue()).split('-');
				CityAreaValue=CityAreaArr[1];
			}
			else
			{
				CityAreaValue=Ext.getCmp('CTADDCityAreaDRF').getRawValue()
			}
			 AddressValue=ProvinceValue+CityValue+CityAreaValue;
		}
		else{
			 AddressValue=ProvinceValue+CityValue;
		}
		Ext.getCmp('CTADDDescF').setValue(AddressValue);
		var CTADDSearchCodeValue=Pinyin.GetJP(AddressValue);
		Ext.getCmp('CTADDSearchCodeF').setValue(CTADDSearchCodeValue);
		Ext.Ajax.request({
			url:GETCODE_URL ,
			method:'POST',
			params:{
				'Province': Ext.getCmp('CTADDProvinceDRF').getValue(),  
				'City':Ext.getCmp('CTADDCityDRF').getValue(),
				'CityArea':Ext.getCmp('CTADDCityAreaDRF').getValue() 
			},
			callback:function(options, success, response){
				if(success){
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if(jsonData.success == 'true'){
					 		 Ext.getCmp('CTADDCodeF').setValue(jsonData.id);
						} 
				}
				else{
					Ext.Msg.show({
						 	title : '提示',
				            msg : '获取地址代码失败,请手动输入代码!',
				            icon : Ext.Msg.ERROR,
				            buttons : Ext.Msg.OK,
				            fn:function(){
				            	Ext.getCmp('CTADDCodeF').focus();
				            }
					});
				}
			}
		});	
    }
        //// 街道/乡镇
       var StreetDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel : '街道/乡镇',
        name : 'CTADDStreetDR',
        id:'CTADDStreetDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDStreetDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDStreetDRF')),
        store : StreetStore,
	     queryParam : 'desc',
	     triggerAction : 'all',
	     forceSelection : true,
	     selectOnFocus : false,
	     minChars : 0,
	     listWidth : 250,
	     valueField : 'LOCTYPERowId',
	     displayField : 'LOCTYPEDesc',
	     hiddenName : 'CTADDStreetDR',
	     pageSize :combopage,
	     listeners:{
		     'beforequery':function(obj){
		     	if (Ext.getCmp("CTADDCityAreaDRF").getValue()==""){
		     		  obj.combo.store.baseParams = {
							start:0,
		           			limit:combopage
						};
         			   obj.combo.store.load();
		     	}
		     	else{
		     		  obj.combo.store.baseParams = {
							start:0,
		           			limit:combopage,
		          			desc:obj.combo.getRawValue(),
		          			nationalcode:Ext.getCmp("CTADDCityAreaDRF").getValue()
						};
         			   obj.combo.store.load();
		     	}
            },
	     	'change':function(){
	     		StreetChange()
	     	},
	     	'select':function(){
	     		StreetChange()
	     	}	     	
	     }
    });
    var StreetChange=function(){
    	var ProvinceArr=new Array();
 		var CityArr=new Array();
 		var CityAreaArr=new Array();
 		var AddressValue="";
 		var Street="";
 		Ext.getCmp("CTADDCommunityDRF").reset();
 		Ext.getCmp('CTADDSearchCodeF').reset();
 		Ext.getCmp('CTADDCodeF').reset();
 		Ext.getCmp('CTADDDescF').reset();
 		
			if (Ext.getCmp('CTADDProvinceDRF').getRawValue()!=""){
    			if(Ext.getCmp('CTADDProvinceDRF').getRawValue().indexOf('-')>0){
     				ProvinceArr=(Ext.getCmp('CTADDProvinceDRF').getRawValue()).split('-');
     				ProvinceValue=ProvinceArr[1];
    			}
    			else{
    				ProvinceValue=Ext.getCmp('CTADDProvinceDRF').getRawValue() ;
    			}
     		}
     		if (Ext.getCmp('CTADDCityDRF').getRawValue()!=""){
    			if(Ext.getCmp('CTADDCityDRF').getRawValue().indexOf('-')>0){
    				CityArr=(Ext.getCmp('CTADDCityDRF').getRawValue()).split('-');
    				CityValue=CityArr[0];
    			}
    			else{
    				CityValue=Ext.getCmp('CTADDCityDRF').getRawValue();
    			}
		}
		/// 城市区域可以为空,比如直辖市 
		if (Ext.getCmp('CTADDCityAreaDRF').getRawValue()!=""){
			if (Ext.getCmp('CTADDCityAreaDRF').getRawValue().indexOf('-')>0){
				CityAreaArr=(Ext.getCmp('CTADDCityAreaDRF').getRawValue()).split('-');
				CityAreaValue=CityAreaArr[1];
			}
			else
			{
				CityAreaValue=Ext.getCmp('CTADDCityAreaDRF').getRawValue()
			}
		}
		else
		{
			CityAreaValue="";
		}
		Street=Ext.getCmp('CTADDStreetDRF').getRawValue();
		AddressValue=ProvinceValue+CityValue+CityAreaValue+Street
		Ext.getCmp('CTADDDescF').setValue(AddressValue);
		var CTADDSearchCodeValue=Pinyin.GetJP(AddressValue);
		Ext.getCmp('CTADDSearchCodeF').setValue(CTADDSearchCodeValue);
		Ext.Ajax.request({
			url:GETCODE_URL ,
			method:'POST',
			params:{
				'Province': Ext.getCmp('CTADDProvinceDRF').getValue(),  
				'City':Ext.getCmp('CTADDCityDRF').getValue(),
				'CityArea':Ext.getCmp('CTADDCityAreaDRF').getValue(),
				'Street':Ext.getCmp('CTADDStreetDRF').getValue() 
			},
			callback:function(options, success, response){
				if(success){
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if(jsonData.success == 'true'){
					 		 Ext.getCmp('CTADDCodeF').setValue(jsonData.id);
								
						}else{
							 
						}
				}
				else{
					Ext.Msg.show({
						 	title : '提示',
				            msg : '获取地址代码失败,请手动输入代码!',
				            icon : Ext.Msg.ERROR,
				            buttons : Ext.Msg.OK,
				            fn:function(){
				            	Ext.getCmp('CTADDCodeF').focus();
				            }
					});
				}
			}
		});
    }
        //// 社区/村
       var CommunityDr=new Ext.BDP.Component.form.ComboBox({
        xtype:'bdpcombo',
        loadByIdParam:'rowid',
        fieldLabel : '社区/村',
        name : 'CTADDCommunityDR',
        id:'CTADDCommunityDRF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDCommunityDRF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDCommunityDRF')),
        store : CommunityStore,
	     queryParam : 'desc',
	     triggerAction : 'all',
	     forceSelection : true,
	     selectOnFocus : false,
	     minChars : 0,
	     listWidth : 250,
	     valueField : 'CTCMUNTRowId',
	     displayField : 'CTCMUNTDesc',
	     hiddenName : 'CTADDCommunityDR',
	     pageSize :combopage,
	     listeners:{
		    'beforequery':function(obj){
		    	if (Ext.getCmp("CTADDStreetDRF").getValue()=="")
		    	{
		    		return false;
		    	}
		    	else
		    	{
		         obj.combo.store.baseParams = {
							start:0,
		           			limit:combopage,
		          			desc:obj.combo.getRawValue(),
		          			CommunityDr:Ext.getCmp("CTADDStreetDRF").getValue()
						};
         			obj.combo.store.load();
       	  			// return false;  
		    	}
            } ,
            beforeselect : function(){
            	 if (Ext.getCmp('CTADDStreetDRF').getValue()=="")
            	 {
            	 	Ext.Msg.show({
								 	title : '提示',
						            msg : '街道/乡镇不能为空,请选择街道/乡镇!',
						            icon : Ext.Msg.ERROR,
						            buttons : Ext.Msg.OK,
						            fn:function(){
						            	Ext.getCmp("CTADDCommunityDRF").reset();
							     		Ext.getCmp('CTADDSearchCodeF').reset();
							     		Ext.getCmp('CTADDCodeF').reset();
							     		Ext.getCmp('CTADDDescF').reset();
						            	Ext.getCmp('CTADDStreetDRF').focus();
						            }
							});
            		 }
            },
	     	'change':function(){
	     		CommunityChange()
	     	},
	     	'select':function(){
	     		CommunityChange()
	     	}
	     }
    });
    var CommunityChange=function(){
    	var ProvinceArr=new Array();
 		var CityArr=new Array();
 		var CityAreaArr=new Array();

		if (Ext.getCmp('CTADDProvinceDRF').getRawValue()!=""){
			if(Ext.getCmp('CTADDProvinceDRF').getRawValue().indexOf('-')>0){
 				ProvinceArr=(Ext.getCmp('CTADDProvinceDRF').getRawValue()).split('-');
 				ProvinceValue=ProvinceArr[1];
			}
			else{
				ProvinceValue=Ext.getCmp('CTADDProvinceDRF').getRawValue() ;
			}
 		}
 		if (Ext.getCmp('CTADDCityDRF').getRawValue()!=""){
			if(Ext.getCmp('CTADDCityDRF').getRawValue().indexOf('-')>0){
				CityArr=(Ext.getCmp('CTADDCityDRF').getRawValue()).split('-');
				CityValue=CityArr[0];
			}
			else{
				CityValue=Ext.getCmp('CTADDCityDRF').getRawValue();
			}
		} 
		var Street=Ext.getCmp('CTADDStreetDRF').getRawValue();
		var Comunity=Ext.getCmp('CTADDCommunityDRF').getRawValue();
		
		if (Ext.getCmp('CTADDCityAreaDRF').getValue()!=""){
		   if(Ext.getCmp('CTADDCityAreaDRF').getValue().indexOf('-')>0){
		   	    CityAreaArr=(Ext.getCmp('CTADDCityAreaDRF').getRawValue()).split('-');
		   	    CityAreaValue=CityAreaArr[1];
		   }
		   else{
		   	 	CityAreaValue=Ext.getCmp('CTADDCityAreaDRF').getRawValue() ;
		   }
		   AddressValue=ProvinceValue+CityValue+CityAreaValue+Street+Comunity;
		}
		else{
			CityValue="";
		    AddressValue=ProvinceValue+CityValue+CityAreaValue+Street+Comunity;
		}
		if (Ext.getCmp('CTADDCommunityDRF').getValue()!=""){
		   if(Ext.getCmp('CTADDCommunityDRF').getValue().indexOf('-')>0){
		   	    CommunityArr=(Ext.getCmp('CTADDCommunityDRF').getRawValue()).split('-');
		   	    CityAreaValue=CityAreaArr[1];
		   }
		   else{
		   	 	CityAreaValue=Ext.getCmp('CTADDCityAreaDRF').getRawValue() ;
		   }
		   AddressValue=ProvinceValue+CityValue+CityAreaValue+Street+Comunity;
		}
		else{
			CityValue="";
		    AddressValue=ProvinceValue+CityValue+CityAreaValue+Street+Comunity;
		}

		Ext.getCmp('CTADDDescF').setValue(AddressValue);
		var CTADDSearchCodeValue=Pinyin.GetJP(AddressValue);
		Ext.getCmp('CTADDSearchCodeF').setValue(CTADDSearchCodeValue);
		Ext.Ajax.request({
			url:GETCODE_URL ,
			method:'POST',
			params:{
				'Province': Ext.getCmp('CTADDProvinceDRF').getValue(),  
				'City':Ext.getCmp('CTADDCityDRF').getValue(),
				'CityArea':Ext.getCmp('CTADDCityAreaDRF').getValue(),
				'Street':Ext.getCmp('CTADDStreetDRF').getValue(),
		 		'Comunity':Ext.getCmp('CTADDCommunityDRF').getValue()
			},
			callback:function(options, success, response){
				if(success){
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if(jsonData.success == 'true'){
					 		 Ext.getCmp('CTADDCodeF').setValue(jsonData.id);
						}else{
					}
				}
				else{
					Ext.Msg.show({
						 	title : '提示',
				            msg : '获取地址代码失败,请手动输入代码!',
				            icon : Ext.Msg.ERROR,
				            buttons : Ext.Msg.OK,
				            fn:function(){
				            	Ext.getCmp('CTADDCodeF').focus();
				            }
					});
				}
			}
		});
    }
    /// 拼音码
    var  SearchCodeText=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel : '<font color=red>*</font>拼音码',
	       name : 'CTADDSearchCode',
	       id:'CTADDSearchCodeF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDSearchCodeF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDSearchCodeF')), 
	       allowBlank:false
    });
    /// DateFrom
    var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'CTADDDateFrom',
       id:'CTADDDateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDDateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDDateFromF')),
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
    /// DateTO
    var DateToText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '结束日期',
       name : 'CTADDDateTo',
       id:'CTADDDateToF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTADDDateToF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTADDDateToF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
         	Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });
	/************************** 增加修改的Form***************************/			
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				width : 230,
				split : true,
				frame : true,
                title:'基本信息',
				reader:jsonReaderE,
				defaults : {
					anchor: '85%',
					border : false   
				},
				items:[RowIdText,ProvinceDr,CityDr,CityAreaDr,StreetDr,CommunityDr,codeText,descText,SearchCodeText,DateFromText,DateToText]
			});
   
   /*********************************重置form的数据清空**************************************/
      var ClearForm = function()
      {
           Ext.getCmp("form-save").getForm().reset();   
      }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
     var closepages= function (){
        win.hide();
        ClearForm();
     }  
 /*******************************定义‘基本信息’框*******************************************/
	 var tabs=new Ext.TabPanel({
	     id:'basic',
	     activeTab: 0,
	     frame:true,
	     items:[WinForm,AliasGrid]
	 });
	 Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);	 
	/**************************增加修改时弹出窗口*****************************/
	var win = new Ext.Window({
		width : 440,
		height : 450,
		layout : 'fit',
		plain : true, 
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
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("CTADDCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("CTADDDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("CTADDDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("CTADDDateTo").getValue();
			if (tempCode=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>代码不能为空!</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTADDCode").focus(true,true);
								}
							});
			      			return;
					}
			if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '<font color=red>描述不能为空!</font>', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTADDDesc").focus(true,true);
								}
							});
			      			return;
				}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>',
								msg : '<font color=red>开始日期不能为空!</font>',
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("CTADDDateFrom").focus(true,true);
								}
							});
      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
			    					title : '<font color=blue>提示</font>',
									msg : '<font color=red>开始日期不能大于结束日期!</font>',
									minWidth : 200,
									animEl: 'form-save',
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
						waitTitle : '<font color=blue>提示</font>',
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
                                win.hide();
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=green>添加成功!</font>',
												animEl: 'form-save',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													var startIndex = grid.getBottomToolbar().cursor;
													grid.getStore().load({
																params : {
																			start : 0,
																			limit : limit,
																			rowid : myrowid
																		}
																});
														}
												});
                                    AliasGrid.DataRefer = myrowid;
                                    AliasGrid.saveAlias(); 
							  } else {
							    	var errorMsg = '';
							    	if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=red>添加失败!</green>',
												minWidth : 200,
												animEl: 'form-save',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
										}
								},
						failure : function(form, action) {
							Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=red>添加失败!</green>',
											minWidth : 200,
											animEl: 'form-save',
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
									}
							})
				} else {
					Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
                                    AliasGrid.saveAlias();
									if (action.result.success == 'true') {
										var myrowid = 'rowid='+action.result.id;
							            win.hide();
						                Ext.Msg.show({
						                                  title : '<font color=blue>提示</font>',
						                                  msg : '<font color=green> 修改成功!</font>',
						                                  animEl: 'form-save',
						                                  icon : Ext.Msg.INFO,
						                                  buttons : Ext.Msg.OK,
						                                  fn : function(btn) {
						                                  var startIndex = grid.getBottomToolbar().cursor;
						                                  Ext.BDP.FunLib.ReturnDataForUpdate('grid',ACTION_URL,myrowid);
						                              }
						                         });
											} else {
														var errorMsg = '';
														if (action.result.errorinfo) {
														errorMsg = '<br/>错误信息:' + action.result.errorinfo
													}
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>修改失败!</font>' ,
														minWidth : 200,
														animEl: 'form-save',
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
													animEl: 'form-save',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
											}
										})
									}
							}, this);
						}
				}
		} ,{
			  text : '关闭',
              iconCls : 'icon-close',
		      handler : function() {
				 win.hide();   
                 ClearForm();
           	 }
		}],
		listeners : {
			"show" : function() {
			Ext.getCmp("form-save").getForm().findField("CTADDCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	/***************************增加按钮******************************************/
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
                tabs.setActiveTab(0);
                //清空别名面板grid
                AliasGrid.DataRefer = "";
                AliasGrid.clearGrid();   
			},
			 scope : this
			});
	/************************** 修改按钮****************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
				var records =  grid.selModel.getSelections();
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
				   		win.setTitle('修改');
						win.setIconClass('icon-update');
						tabs.setActiveTab(0);
						win.show();
						loadFormData(grid);
					 }
      		 }
    });
 
	/***********************************数据存储***********************************/
   	var fields= [{     
		            name : 'CTADDRowId',
					mapping :'CTADDRowId',
					type : 'int'
				}, {
					name : 'CTADDCode',  
					mapping : 'CTADDCode',
					type : 'string'
				}, {
					name : 'CTADDDesc',
					mapping :'CTADDDesc',
					type:'string'
				},{
					name:'CTADDProvinceDR',
					mapping:'CTADDProvinceDR',
					type:'string'
				},{
					name:'CTADDCityDR',
					mapping:'CTADDCityDR',
					type:'string'
				} ,{
					name:'CTADDCityAreaDR',
					mapping:'CTADDCityAreaDR',
					type:'string'
				} ,{
					name:'CTADDStreetDR',
					mapping:'CTADDStreetDR',
					type:'string'
				} ,{
					name:'CTADDCommunityDR',
					mapping:'CTADDCommunityDR',
					type:'string'
				} ,{
					name:'CTADDSearchCode',
					mapping:'CTADDSearchCode',
					type:'string'
				} ,
				{
					name :'CTADDDateFrom',
					mapping :'CTADDDateFrom',
					type : 'date',
                    dateFormat : 'm/d/Y'
				},{
					name :'CTADDDateTo',
					mapping :'CTADDDateTo',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
				  } ]
						
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
									
						},fields) 
		});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/************************加载数据	***********************************/
	 ds.load({
				params : {
					start : 0,
					limit : limit
				},
				callback : function(records, options, success) {
				}
			}); 
	/************************分页操作*****************************************/
	var paging = new Ext.PagingToolbar({
            pageSize: limit,
            store: ds,
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
	/*******************************增删改工具条*************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel ,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog,'->',btnImport]  
	})
	/*******************************搜索工具条***************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function () {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue() ,
						desc : Ext.getCmp("TextDesc").getValue() ,
						Chinese:Ext.getCmp('TextChinese').getValue(),
						Province:Ext.getCmp('TextCTCITProvinceDR').getValue(),
						City:Ext.getCmp('TextCITAREACityDR').getValue(),
						CityArea:Ext.getCmp('TextCTADDCityAreaDR').getValue()
				};
				grid.getStore().load({
					params : {
								start : 0,
								limit : limit
							}
						});
					}
				});
			 
	/*************************** 刷新工作条*****************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function refresh() {
				Ext.BDP.FunLib.SelectRowId="";
				Ext.getCmp("TextCode").reset();
				Ext.getCmp("TextDesc").reset();
				Ext.getCmp('TextChinese').reset();
				Ext.getCmp('TextCTCITProvinceDR').reset();
				Ext.getCmp('TextCITAREACityDR').reset();
				Ext.getCmp('TextCTADDCityAreaDR').reset();
				grid.getStore().baseParams={};
				grid.getStore().load({
					params :{
								start : 0,
								limit : limit
							}
						});
					}
			});
	var search=function()
	{
		grid.getStore().load({
			params : {
						start : 0,
						limit : limit
					}
			});
	  }
	/************************** 将工具条放到一起********************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							width:100,
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},
					'描述/别名', {
							xtype : 'textfield',
							width:100,
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},'拼音码', {
							xtype : 'textfield',
							width:100,
							id : 'TextChinese',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextChinese')
						},	'省份',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							shadow:false,
							fieldLabel : '<font color=red></font>省',
							width:100,
							id :'TextCTCITProvinceDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTCITProvinceDR'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : PROVINCE_QUERY_ACTION }),
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
							displayField : 'PROVDesc',
							valueField : 'PROVRowId',
							listeners:{
					              'select': function(field,e){
					              	　Ext.getCmp('TextCITAREACityDR').reset();
									  Ext.getCmp("CTADDCityAreaDRF").reset();
					             }
					    	}					
						},	'市',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							shadow:false,
							fieldLabel : '<font color=red></font>市',
							width:100,
							id :'TextCITAREACityDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCITAREACityDR'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CITY_QUERY_ACTION }),
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
							valueField : 'CTCITRowId',
							listeners:{
							     'beforequery':function(obj){
							     	if (Ext.getCmp("TextCTCITProvinceDR").getValue()==""){
							     		return false;
							     	}
							     	else{
							         obj.combo.store.baseParams = {
												start:0,
							           			limit:combopage,
							          			desc:obj.combo.getRawValue(),
							          			provincedr:Ext.getCmp("TextCTCITProvinceDR").getValue()
											};
					         		obj.combo.store.load();
							     }       		
					            },
					              'select': function(field,e){
									  Ext.getCmp("CTADDCityAreaDRF").reset();
					             }
					    	}					
						},	'城市区域',{
									xtype : 'bdpcombo',
							        loadByIdParam:'rowid',
							        fieldLabel:'城市区域',
							        name:'CTADDCityAreaDR',
							        id:'TextCTADDCityAreaDR',
							        width:100,
							        readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextCTADDCityAreaDR'),
							        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextCTADDCityAreaDR')),
							        store : CityAreaStore,
								    queryParam : 'desc',
								    triggerAction : 'all',
								    forceSelection : true,
								    selectOnFocus : false,
								    minChars : 0,
								    listWidth : 250,
								    valueField : 'CITAREARowId',
								    displayField : 'CITAREADesc',
								    //hiddenName : 'CTADDCityAreaDR',
								    pageSize :combopage,
								    listeners:{
									     'beforequery':function(obj){
									     	if (Ext.getCmp("TextCITAREACityDR").getValue()==""){
												return false;									     	
									     	}
									     	else
									     	{
									         obj.combo.store.baseParams = {
														start:0,
									           			limit:combopage,
									          			desc:obj.combo.getRawValue(),
									          			citydr:Ext.getCmp("TextCITAREACityDR").getValue()
													};
							         		obj.combo.store.load();
									     }
									   }
								    }
							    },
						'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)  
					}
				}
			});
	/*******************************create the Grid ***********************************/
	var sm=	new Ext.grid.RowSelectionModel({singleSelect:true})
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header :'CTADDRowId',
							width : 20,
							sortable : true,
						    hidden:true,
							dataIndex : 'CTADDRowId'
					  }, {
							header : '代码',
							width : 160,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'CTADDCode'
						}, {
							header : '描述',
							width : 165,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'CTADDDesc'
						},{
							header : '拼音码',
							width : 100,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'CTADDSearchCode'
						},{
							header : '省',
							width : 70,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'CTADDProvinceDR'
						},{
							header : '市',
							width : 85,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'CTADDCityDR'
						},{
							header : '城市区域',
							width : 85,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'CTADDCityAreaDR'
						},{
							header : '街道/乡镇',
							width : 85,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'CTADDStreetDR'
						},{
							header : '社区/村',
							width : 115,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex:'CTADDCommunityDR'
						},{
							header : '开始日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'CTADDDateFrom'
						},{
							header : '结束日期',
							width :85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTADDDateTo'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				trackMouseOver : true,
				columns:GridCM ,
				sm :sm, 
				stripeRows : true,
				columnLines : true,
				title : '地址',
				stateful : true,
				viewConfig : {
								forceFit : true,
								emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
			    				enableRowBody: true 
							},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
  Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);	 
  btnTrans.on("click",function(){
	if (grid.selModel.hasSelection())
	{
	  var _record=grid.getSelectionModel().getSelected();
      var selectrow=_record.get('CTADDRowId');
	}
	else
	{
	  var selectrow=""
	}
	Ext.BDP.FunLib.SelectRowId=selectrow
  });
	/*********************************双击事件***********************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();   
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('CTADDRowId'), 
	                success : function(form,action) {
	        	   },
	                failure : function(form,action) {
	               	  Ext.Msg.alert('编辑', '载入失败!');
	                }
	            });
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('CTADDRowId');
               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      
				win.setIconClass('icon-update');
				tabs.setActiveTab(0);
				win.show();
			 	loadFormData(grid);
	    });	
	    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/*************************键盘事件，按快捷键弹出添加窗口。***********************/
   		Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
});
