/// 名称: 数据翻译
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2015-5-5

var selectrow=Ext.BDP.FunLib.getParam('selectrow');
var tableName=Ext.BDP.FunLib.getParam('tableName');

document.write('<script type="text/javascript" src="../scripts/bdp/App/BDPSystem/ext-basex.js"> </script>');

Ext.onReady(function(){
	var OPENDATA_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=SaveData";
	var LANGUAGE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassQuery=GetDataForCmb1";
	
	var descBefore="",descAfter="",FieldName="",TitleDesc="";
	Ext.form.Field.prototype.msgTarget = 'under';
	Ext.QuickTips.init();   //--------启用悬浮提示

    //翻译语言选择框
	var LanguageCombo=new Ext.BDP.FunLib.Component.BaseComboBox({
							//pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							shadow:false,
							fieldLabel : '<font color=red></font>翻译语言',
							id :'LanguageF',
							hiddenName:'Language',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('LanguageF'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : LANGUAGE_QUERY_ACTION_URL }),
										baseParams :{
											'table':tableName
										},
										reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [{ name:'CTLANRowId',mapping:'CTLANRowId'},
											{ name:'CTLANCode',mapping:'CTLANCode'},
											{name:'CTLANDesc',mapping:'CTLANDesc'} ]),
										listeners:{
											'load':function(){  
												  Ext.getCmp('LanguageF').setValue(this.getAt(0).get('CTLANCode'));
												  loadFormData();
											}
										}
								}),
							mode : 'local',
							triggerAction : 'all',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'CTLANDesc',
							valueField : 'CTLANCode',
							listeners:{
								'select':function(){
									loadFormData();
								}
							}
			
		});
		
	//数据翻译边框
	var fieldSetTrans = new Ext.form.FieldSet({                                
           title: '',  
           id : 'fieldSetTrans',
           columnWidth: 0.5,
			//collapsible: true,
	        autoHeight:true,
	        defaultType: 'textfield'
        });
   ///***************************首页面基础配置显示表单********************************/
	var formConfig=new Ext.form.FormPanel({	
		id:'form-config',
		frame:true,
		autoScroll:true,///滚动条
		border:false,
		region: 'center',
		//width:500,
		iconCls:'icon-find',
		buttonAlign:'center',
		labelAlign : 'right',
		labelWidth : 180,
		//tools:Ext.BDP.FunLib.Component.HelpMsg,
		tbar : ['翻译语言',LanguageCombo],
		items:[fieldSetTrans],
		buttons:[{
			text:"保存",
			iconCls : 'icon-save',
			width:100,
			id:"update",
			handler:function(){
				var emptyFlag=""
				var args=""
				Ext.getCmp('fieldSetTrans').items.each(function(item,index,length){                             
			       var BTFieldName=item.getName();
			      // var BTFieldDesc=item.fieldLabel;
			       var BTTransDesc=item.getValue();
			       //var Type=item.getXType();  
				   if(args==""){
				       	args=BTFieldName+"^"+BTTransDesc
				    }else{
				      	args=args+"&#"+BTFieldName+"^"+BTTransDesc
				    }
				    /*if (BTTransDesc==""){
				    	emptyFlag="Y"
				    }*/
 				 }); 
 				 /*if (emptyFlag=="Y")	
 				 {
 				 	 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />翻译后内容不能为空！');
					 return;
 				 }*/
 				 //alert(args)
 				 Ext.Ajax.request({
						url : SAVE_ACTION_URL , 				
						method : 'POST',	
						params : {
								'TableName' : tableName,
								'Languages' :Ext.getCmp("LanguageF").getValue(),
								'rowid':selectrow,
								'args' : args
							},
						callback : function(options, success, response) {	
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											var TransWin = parent.Ext.getCmp('TransWin');
   											if (TransWin) {TransWin.close();}
										}
										});
										//self.close();
								}
								else {
									var errorMsg = '';
									if(jsonData.errorinfo){
										errorMsg='<br/>错误信息:'+jsonData.errorinfo
									}
									Ext.Msg.show({
										title : '提示',
										msg : '保存失败!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK														
										})		
								}
							}
							else {
									Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败,请检查网络连接!',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
										});
							}
							loadFormData();
						}
					},this);
			}
		}]
	})

	/*****************载入首页面基础配置显示表单的数据*****************/

	//首页创建displayField类型组件
	var CreatDisplayField=function(){
			var NewCom =new Ext.BDP.FunLib.Component.TextField({
						width:200,
						fieldLabel:TitleDesc,
						name :FieldName,
						id:FieldName,
						allowBlank: true,
						blankText: '翻译后的内容不能为空',
						validationEvent : 'blur',
						listeners:{
							render:function(obj){
								var _parentNode = obj.el.dom.parentNode;
								var valid =  Ext.get(_parentNode).createChild({
							    	 tag : 'span',
							    	 id : obj.id+'-icon',
								     html :"&nbsp&nbsp&nbsp&nbsp;"+"<font color='blue'>"+descBefore+"</font>"
								});
							}
						}
				});
			return NewCom;
	}
	//加载组件
    var loadFormData = function() { 		
	    	var p = Ext.getCmp("form-config").find('textfield'); 
			for(var i = 0; i<p.length;i++){
			       Ext.getCmp("fieldSetTrans").remove(p[i],true); //清除所有textfield文本框
			}
 			Ext.Ajax.request({											
				url:OPENDATA_ACTION_URL,
				method:'GET',
				params : {
					'TableName' : tableName,
					'Languages' :Ext.getCmp("LanguageF").getValue(),
					'rowid':selectrow
				},
				async: false,  
				callback:function(options,success,response){
						    if(success){	    	
						    var jsonData=Ext.util.JSON.decode(response.responseText);
						    if(jsonData.success!="false"){
	    				 		var length=jsonData.totalCount;
	    				 		for(var i=0;i<length;i++){
	    				 		 	descBefore=jsonData.data[i].BTFieldDesc;
	    				 		 	descAfter=jsonData.data[i].BTTransDesc;
	    				 		 	FieldName=jsonData.data[i].BTFieldName;
	    				 		 	TitleDesc=jsonData.data[i].TitleDesc;
	    				 		 	classAllName=jsonData.data[i].classAllName;
	    				 		 	if(descBefore!=""){
				    					var showtype=CreatDisplayField();
				    					Ext.getCmp(FieldName).setValue(descAfter);
				    					var remind=Ext.getCmp(FieldName);
										Ext.getCmp('fieldSetTrans').items.add(showtype);
	    				 		 	}
			    					formConfig.doLayout();
								} 	
						    }else{
						    	var errorMsg = '';
									if(jsonData.info){
										errorMsg='<br/>错误信息:'+jsonData.info
									}
									Ext.Msg.show({
										title : '提示',
										msg : '加载失败!'+errorMsg,
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK														
										})		
						    }
  						 }
  						 else {
									Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败,请检查网络连接!',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
										});
							}	
  						 
					}
				})
    };	
  
	/**用Viewport可自适应高度跟宽度*/
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [formConfig]
    });
});
