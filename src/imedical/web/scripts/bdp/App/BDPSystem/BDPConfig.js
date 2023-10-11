/// 名称: 基础配置动态加载
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-9-22

var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDPConfig/BDPConfig.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');


document.write('<script type="text/javascript" src="../scripts/bdp/App/BDPSystem/ext-basex.js"> </script>');

/*	
 	var Translationurl="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPTrans_Aut"
		if ('undefined'!==typeof websys_getMWToken)
        {
			Translationurl += "&MWToken="+websys_getMWToken() //20230209 增加token
		}
 	var TranslationWin = new Ext.Window({
				width:900,
	            height:530,
			    layout:'fit',
			    frame :true,
				closeAction:'hide',
				html:'<iframe name="myFrame" src="'+Translationurl+'" width="100%" height="100%"></iframe>'
			});
	var Ashow=function(){
		TranslationWin.show();
	}
	
	*/
	var BDPHISASRLocDatashow=function(){
		var url="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_CommandLocSet"
		if ('undefined'!==typeof websys_getMWToken)
        {
			url += "&MWToken="+websys_getMWToken() //增加token
		}
		var BDPHISASRLocDataWin = new Ext.Window({
				width:600,
				title: '按科室开启语音功能',
	            height:530,
			    layout:'fit',
			    frame :true,
				closeAction:'hide',
				html:'<iframe src="'+url+'" width="100%" height="100%"></iframe>'
			});
		BDPHISASRLocDataWin.show();
		//Ext.getCmp("_multiselect3").toStore.load({params: {}});	
		//Ext.getCmp("_multiselect3").fromStore.load({params: {}});	
	}

///***************************国家标准编码要显示字段表单********************************/
	var NationalDataForm = new Ext.form.FormPanel({
					id:'NationalDataForm',
					labelAlign:'right',
					labelWidth:60,
					frame :true,
					defaultType:'checkbox',
					items:[{
		                boxLabel: '国家标准编码',
		                name: 'BDPInternalCode',
		                id:'BDPInternalCodeF',
		                width: 'auto',
		                checked:true,
						inputValue : true?'Y':'N'
		                
		            },{
		                boxLabel: '国家标准编码名称',
		                name: 'BDPInternalDesc',
		                id:'BDPInternalDescF',
		                width: 'auto',
		                checked:true,
						inputValue : true?'Y':'N'
		            },{
		                boxLabel: '医院标准编码',
		                name: 'BDPHospNationalCode',
		                id:'BDPHospNationalCodeF',
		                width: 'auto',
		                checked:true,
						inputValue : true?'Y':'N'
		            },{
		                boxLabel: '医院标准编码名称',
		                name: 'BDPPHospNationalDesc',
		                id:'BDPPHospNationalDescF',
		                width: 'auto',
		                checked:true,
						inputValue : true?'Y':'N'
		            }]
		});
	/****国家标准编码要显示字段***/
	var NationalDataWin=new Ext.Window({
			title:'国家标准编码列表显示字段',
			width:260,
            height:250,
			layout:'fit',
			plain : true,//true则主体背景透明
			modal : true,
			frame : true,
			autoScroll : true,
			collapsible : true,
			constrain : true,
			hideCollapseTool : true,
			titleCollapse : true,
			buttonAlign:'center',
			closable:false,
		 	closeAction:'hide',   
			items: [NationalDataForm],
			buttons:[{
					text:'保存',
					iconCls : 'icon-save',
					handler:function(){
						var str="BDPInternalCode:"+Ext.getCmp('BDPInternalCodeF').getValue()
						+"^BDPInternalDesc:"+Ext.getCmp('BDPInternalDescF').getValue()
						+"^BDPHospNationalCode:"+Ext.getCmp('BDPHospNationalCodeF').getValue()
						+"^BDPPHospNationalDesc:"+Ext.getCmp('BDPPHospNationalDescF').getValue()
						var saveflag =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","SaveNationalData",str);
						if(saveflag){
							alert("保存成功")
							NationalDataWin.hide();
						}else{
							alert("保存失败")
						}
				}
			},{
				text:'关闭',
				iconCls : 'icon-close',
				handler:function(){
			  		Ext.getCmp('NationalDataForm').getForm().reset();
					NationalDataWin.hide();
				}
			}] 
	});

	var showNationalData=function(){
		var nationShow =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPNationalDataShow");
		NationalDataWin.show();
		var nationStr = nationShow.split("^");
		for (var i = 0; i < nationStr.length; i++) { 
			var  str=nationStr[i].split(":"); 
			var nationCode=str[0]+"F";
			var nationValue=str[1];
			Ext.getCmp(nationCode).setValue(nationValue);
		}
	}
	
	/*************************科室用户配置**likefan**2021-07-14**********************/
	
	var winDeptUserAut;
	var showBDPCDSSDeptUserAut=function(){
		winDeptUserAut = new Ext.Window({
					id:'winDeptUserAut',
					iconCls : 'icon-DP',
					width : Ext.getBody().getViewSize().width-50,
					height : Ext.getBody().getViewSize().height-50,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : false,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					constrain : true,
					closeAction : 'close'
				});
				var url="dhc.bdp.bdp.bdpcdssdeptuseraut.csp?CDSSCodeStr=1^"
				if ('undefined'!==typeof websys_getMWToken)
		        {
					url += "&MWToken="+websys_getMWToken() //增加token
				}
				winDeptUserAut.html='<iframe id="windepuseraut" frameborder="0" src="'+url+'" width="99%" height="98%" scrolling="auto"></iframe>';
				winDeptUserAut.setTitle("科室用户配置");
				winDeptUserAut.show();
	}
	
	/*************************科室用户配置完*************************/
	
	
	///2018-11-14
	///chenying
	///开启安全组数据查询权限
	var SSGroup_TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=GetGroupTreeJson";
	var groupTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: SSGroup_TREE_QUERY_ACTION_URL
			});
	
	var groupPanel = new Ext.tree.TreePanel({
			region: 'center',
			//xtype:'treepanel',
			id: 'menuConfigTreePanel',
			expanded:true,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"menuTreeRoot",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
					
				}),
			loader: groupTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,///
			tbar:[{xtype : 'textfield',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
			listeners : {
		       change : function(field,newValue,oldValue){
		       		groupPanel.root.reload()
		             
		       }
}
			},new Ext.Button({
							id : 'btnSearch',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
							tooltip : '搜索',
							iconCls : 'icon-search',
							text : '搜索',
							handler : function() {
								groupPanel.root.reload()
						}
				}),'-',
				{
						xtype:'panel',
						baseCls:'x-plain',
						height:30,
						items:[{
							xtype : 'radiogroup',
							columns: [60, 60, 60],
				            items : [{
			            		id : 'radio1',
			            		boxLabel : "全部",
			            		name : 'FilterCK',
			            		inputValue : '0',
			            		checked : true,
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			groupTreeLoader.dataUrl = SSGroup_TREE_QUERY_ACTION_URL;
					            			
					            			groupPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}, {
			            		id : 'radio2',
			            		boxLabel : "已选",
			            		name : 'FilterCK',
			            		inputValue : '1',
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			groupTreeLoader.dataUrl = SSGrup_TREE_QUERY_ACTION_URL + '&FilterCK=checked';
					            			groupPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}, {
			            		id : 'radio3',
			            		boxLabel : "未选",
			            		name : 'FilterCK',
			            		inputValue : '2',
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			groupTreeLoader.dataUrl = SSGroup_TREE_QUERY_ACTION_URL + '&FilterCK=unchecked';
					            			groupPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}]
			            }]
					}]
	});
	groupTreeLoader.on("beforeload",function(groupTreeLoader,node){
		groupTreeLoader.baseParams.desc=Ext.getCmp("TextDesc").getValue();
	},this);
	
	var Tree1Window = new Ext.Window({
    title: '安全组授权',
    closable: true,      
    width: 500,
    height: 500,
    border: false,
    layout: 'border',
    modal : true,
	closeAction : 'hide',
    items: [groupPanel],
    buttons: [
    	
    		{
        text: '保存',
        iconCls : 'icon-save',
        handler: function () {
        		var selNodes = groupPanel.getChecked();
				var idstr="&";
				var count=0
				//遍历获取所有的节点数据
				Ext.each(selNodes, function (node) {
					
				       idstr=idstr+node.id+"&"
				    	count=count+1
				});
				var SaveResult = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","SaveData","BDPQueryAutGroupData^"+idstr);
 				Ext.Msg.show({
							title : '提示',
							msg : '保存成功！',
							icon : Ext.Msg.INFO,
							buttons : Ext.Msg.OK
						});
    		}
    	},{
        text: '关闭',
        iconCls : 'icon-close',
        handler: function () {
        	
 			Tree1Window.hide();
        }
    }],
    listeners : {
		"show" : function(){
						
		},
		"hide" : function(){
			Ext.getCmp("radio1").setValue(0);
		},
		"close" : function(){
		}
	}
  	});	
  	
  	
	var showSSGroupAutData=function(){
		var nationShow =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPQueryAutGroup");
		groupTreeLoader.dataUrl=SSGroup_TREE_QUERY_ACTION_URL;
		ssordroot.reload();  //重新加载dataURL和根节点
		Tree1Window.show();
	}
	
	
	
		/// 封装一个方法可以自动生成快捷键组合
	var ProduceKey=function(e,id){
				var returnVal=Ext.BDP.FunLib.GetKeyByKeyCode(e.keyCode)
				var ShowStr="";
				if (returnVal=="BackSpace"||returnVal=="Delete"||returnVal=="CapsLk"){
					returnVal="";
					return false ;
				}
				 
				if (((!e.ctrlKey)&&(!e.altKey)&&(!e.shiftKey))&&(returnVal=="A"||returnVal=="B"||returnVal=="C"||returnVal=="D"||returnVal=="E"||returnVal=="F"||returnVal=="G"||returnVal=="H"||returnVal=="I"||returnVal=="J"||returnVal=="K"||returnVal=="L"||returnVal=="M"||returnVal=="N"||returnVal=="O"||returnVal=="P"||returnVal=="Q"||returnVal=="R"||returnVal=="S"||returnVal=="T"||returnVal=="U"||returnVal=="V"||returnVal=="W"||returnVal=="X"||returnVal=="Y"||returnVal=="Z"))
				{
					/// shift ctrl alt 都没按下
				 	ShowStr="Ctrl+Alt"+"+"+returnVal; 
				 	if (returnVal!="Tab"){
						Ext.getCmp(id).reset();
						Ext.getCmp(id).setValue(ShowStr);	 
				 	}
				}
				else
				{
					if (e.ctrlKey && !e.altKey && !e.shiftKey && returnVal!="Ctrl"){
						/// ctrl 按下
						ShowStr="Ctrl+"+returnVal; 
					}
					if (!e.ctrlKey && !e.altKey && e.shiftKey && returnVal!="Shift"){
						/// shift 按下
						ShowStr="Shift+"+returnVal; 
					}
					if (!e.ctrlKey && e.altKey && !e.shiftKey && returnVal!="Alt"){
						/// alt 按下
						ShowStr="Alt+"+returnVal; 
					}
					if (!e.ctrlKey && e.altKey && e.shiftKey && returnVal!="Shift" && returnVal!="Alt"){
						/// alt shift 同时 按下
						ShowStr="Shift+Alt+"+returnVal; 
					}
					if (e.ctrlKey && e.altKey && !e.shiftKey && returnVal!="Ctrl"&&returnVal!="Alt"){
						/// ctrl shift 同时 按下
						 ShowStr="Ctrl+Alt+"+returnVal; 
					}
					if (e.ctrlKey&&!e.altKey&&e.shiftKey&&returnVal!="Shift"&&returnVal!="Ctrl"){
						/// shift  ctrl同时 按下
						ShowStr="Shift+Ctrl+"+returnVal; 
					}	
					if (e.ctrlKey&&e.altKey&&e.shiftKey&&returnVal!="Ctrl"&&returnVal!="Shift"&&returnVal!="Alt"){
						/// shift  ctrl alt同时 按下
						 ShowStr="Shift+Ctrl+Alt+"+returnVal; 
					}	
					if (returnVal!="Tab"){
						Ext.getCmp(id).reset();
						Ext.getCmp(id).setValue(ShowStr);	 
				 	}	  
				}
		}

	
//// 快捷键配置  add by sunfengchao 
	var KeyMapDataForm = new Ext.form.FormPanel({
					id:'KeyMapDataForm',
					labelAlign:'right',
					labelWidth:90,
					frame :true,
					defaultType:'textfield',
					items:[{
		                fieldLabel: '添加功能',
		                name: 'KeyMapAdd',
		                id:'KeyMapAddF',
		                width: 170 ,
		                enableKeyEvents:true,
		                readOnly:true,
		                stopEvent:true,
		                listeners : {
		                	'keydown':function()
		                	 { 
		                	 	var e=window.event||e;
								ProduceKey(e,"KeyMapAddF");
							 }
		                }
		                
		            },{
		                fieldLabel: '修改功能',
		                name: 'KeyMapUpdate',
		                id:'KeyMapUpdateF',
		                enableKeyEvents:true,
		                readOnly:true,
		                stopEvent:true,
		                width:170,
		                listeners : {
		                	'keydown':function()
		                	 { 
		                	 	var e=window.event||e;
								ProduceKey(e,"KeyMapUpdateF");
							}
		                }
		            },{
		                fieldLabel: '删除功能',
		                name: 'KeyMapDelete',
		                id:'KeyMapDeleteF',
		                width: 170 ,
		                enableKeyEvents:true,
		                readOnly:true,
		                stopEvent:true,
		                listeners : {
		                	 'keydown':function()
		                	 { 
		                	 	var e=window.event||e;
								ProduceKey(e,"KeyMapDeleteF");
							 }
		                }
		            },{
		                fieldLabel: '帮助功能',
		                name: 'KeyMapHelp',
		                id:'KeyMapHelpF',
		                width: 170 ,
		                readOnly:true,
		                enableKeyEvents:true,
		                stopEvent:true,
		                listeners : {
		                	 'keydown':function()
		                	 { 
		                	 	var e=window.event||e;
								ProduceKey(e,"KeyMapHelpF");
							 }
		                }
		            }]
		});
	 
	var KeyMapWin=new Ext.Window({
			title:'快捷键配置',
			width:350,
            height:240,
			layout:'fit',
			plain : true, 
			modal : true,
			frame : true,
			constrain : true,
			buttonAlign:'center',
		 	closeAction:'hide',
			items: [KeyMapDataForm],
			buttons:[{
					text:'保存',
					iconCls : 'icon-save',
					handler:function(){
						var str=Ext.getCmp('KeyMapAddF').getValue()+"^"+Ext.getCmp('KeyMapUpdateF').getValue()+"^"+Ext.getCmp('KeyMapDeleteF').getValue()+"^"+Ext.getCmp('KeyMapHelpF').getValue()
						var saveflag =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","SaveKeyMapData",str);
						if(saveflag){
							Ext.Msg.alert("提示","保存成功!")
							KeyMapWin.hide();
						}else{
							Ext.Msg.alert("提示","保存失败!")
						}   
				}
			},{
				text:'关闭',
				iconCls : 'icon-close',
				handler:function(){
					Ext.getCmp('KeyMapAddF').setValue('');
					Ext.getCmp('KeyMapUpdateF').setValue('');
					Ext.getCmp('KeyMapDeleteF').setValue('');
					Ext.getCmp('KeyMapHelpF').setValue('');
					KeyMapWin.hide();
				}
			}] ,
			listeners:{
				'show':function(){
					var KeyMapData=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","ShowKeyMapValue"); 
					var KeyMapArr=new Array();
					KeyMapArr=KeyMapData.split("^")
					Ext.getCmp('KeyMapAddF').setValue(KeyMapArr[0]);
					Ext.getCmp('KeyMapUpdateF').setValue(KeyMapArr[1]);
					Ext.getCmp('KeyMapDeleteF').setValue(KeyMapArr[2]);
					Ext.getCmp('KeyMapHelpF').setValue(KeyMapArr[3]);
				},
				"hide" : function(){
				 //	Ext.getCmp('KeyMapAddF').reset();
				},
				'close':function(){}
			}
	});
	
	var showKeyMapData=function(){  
	   	 var oneKeyShow =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPKeyMap");
	   	 if (oneKeyShow=="Y"){
		 	KeyMapWin.show();
	   	 }
	}
	
Ext.onReady(function(){
	var OPENDATA_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=SaveData";
	var RESTORE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=RestoreData";
	var PASSWORD_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=GetPassword";
	var IDSTR_ACTION_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfig&pClassMethod=FindIdStr";
	var BindingGroup = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";
	var value="",code="",desc="",type="",active="",explain="",edit=""

	var count //表单加载的组件个数，用于动态调整窗口大小
	Ext.QuickTips.init();   //--------启用悬浮提示
	  
	var keymap = new Ext.KeyMap(document, 
		[{
		    key: Ext.EventObject.B, /****快捷键用shift B组合键,用来唤醒管理员配置页面。***/
		    shift:true,   
		    ctrl:true,
		    fn:handerMethod
		}]
	)
	function handerMethod(obj){  
		pswWin.show();
		Ext.getCmp("pswForm").getForm().findField("psw").focus(true,300); //聚焦
	}  
	var height=Math.min(Ext.getBody().getViewSize().height-50,790)	
	 ///**调用BDPConfigAdmin.js的平台配置组内应用面板**/
	var ConfigAdminurl="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPConfigAdmin"
	if ('undefined'!==typeof websys_getMWToken)
    {
		ConfigAdminurl += "&MWToken="+websys_getMWToken() //增加token  
	}
	var SpecWin = new Ext.Window({
				width:1100,
	            height:height,
			    layout:'fit',
			    frame :true,
				closeAction:'hide',
				html:'<iframe src="'+ConfigAdminurl+'" width="100%" height="100%"></iframe>',
				listeners : {
						"hide" : function() {
							 loadFormData();
						}	
					}
			});

	///***************************平台配置组内应用输入密码表单********************************/
	var pswForm = new Ext.form.FormPanel({
					id:'pswForm',
					labelAlign:'right',
					labelWidth:60,
					frame :true,
					defaultType:'textfield',
					items:[{
						fieldLabel:'密码',
						name :'password',
						id:'psw',
						xtype:'textfield',
						inputType :'password',
						allowBlank:false,
						listeners: {
					       specialkey: function(field, e){									
						        if (e.getKey() == e.ENTER) {
							         savepsw()
						        }
					        }
				       }
					}]
		});
	/****平台配置组内人员密码输入窗口***/
	var pswWin=new Ext.Window({
			title:'组内人员密码输入窗口',
			width:300,
            height:150,
			layout:'fit',
			plain : true,//true则主体背景透明
			modal : true,
			frame : true,
			autoScroll : true,
			collapsible : true,
			constrain : true,
			hideCollapseTool : true,
			titleCollapse : true,
			buttonAlign:'center',
			closable:false,
		 	closeAction:'hide',   
			items: [pswForm],
			buttons:[{
					text:'确定',
					iconCls : 'icon-ok',
					id:'sava_btn1',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn1'),
					handler:savepsw=function(){
    				var v2 = Ext.getCmp ("psw").getValue();
					if(v2=="bdp"){
					   	SpecWin.setTitle('平台配置组内应用');
						SpecWin.show();
						Ext.getCmp('pswForm').getForm().reset();
						pswWin.hide();
						
					}else{
						Ext.Msg.show({
							title : '提示',
							msg : '密码错误，请重新输入' ,
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK,
							fn : function(btn) {
								
								Ext.getCmp("pswForm").getForm().findField("password").focus(true,300);
							}
						})
						
					}
				}
			},{
				text:'关闭',
				iconCls : 'icon-close',
				handler:function(){
			  		Ext.getCmp('pswForm').getForm().reset();
					pswWin.hide();
				}
			}] 
	});
    ///***************************修改基础配置********************************/
	/********修改基础配置的表单**********/
	var winFormUpdate=new Ext.form.FormPanel({
		id : 'form-save',
		labelAlign : 'right',
		labelWidth : 180,
		autoScroll : true,
		//height : 380,
		title : '',
		frame : true
		/*defaults : {
					anchor : '92%',
					border : false
				}*/

	})

	/********修改基础配置的窗口**********/
	var winUpdate=new Ext.Window({
		title : '',
		width : 450,
		//autoHeight:true,
		height:height,
		layout : 'fit',
		plain : true,//true则主体背景透明
		modal : true,
		frame : true,
		//autoScroll : true,
		//collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		//bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : winFormUpdate,
		buttons:[{
			text:"保存",
			iconCls : 'icon-save',
			id:'save_btn',
			handler:function(){
				var args=""
				var BDPGroupValue=""
				var BDPSSUSRGroupValue=""
				winFormUpdate.items.each(function(item,index,length){                             
			       var ConfigCode=item.getName();   
			       var ConfigValue=item.getValue();
			       var ConfigType=item.getXType();
			       if(ConfigType=="checkbox"&&ConfigValue==true){
			       		ConfigValue="Y"
			       }
			       if(ConfigType=="checkbox"&&ConfigValue==false){
			       		ConfigValue="N"
			       }
			       if(ConfigType=="radiogroup"){
			       		ConfigValue=Ext.getCmp(ConfigCode).getValue().inputValue;
			       }
			       if(ConfigType=="datefield"){
			       		ConfigValue=ConfigValue.format('Y-m-d')
			       }
			       if (ConfigCode=="BDPGroup")  //记录下新增用户是否默认安全组
			       {
			       		BDPGroupValue=ConfigValue
			       }
			       if (ConfigCode=="BDPSSUSRGroup")  //记录下新增用户默认的安全组
			       {
			       		BDPSSUSRGroupValue=ConfigValue
			       }
			       if(args==""){
			       		args=ConfigCode+"^"+ConfigValue+"^"+ConfigType
			       }else{
			      	 	args=args+";"+ConfigCode+"^"+ConfigValue+"^"+ConfigType
			       }
 				 }); 
 				 
 				 if ((BDPGroupValue=="Y")&(BDPSSUSRGroupValue==""))  //如果新增用户默认安全组，但是却没选中安全组则给出提示
 				 {
 				 	alert("请选择新增用户默认的安全组！")
 				 	return;
 				 }
 				 //alert(args)
 				 Ext.Ajax.request({
						url : SAVE_ACTION_URL , 				
						method : 'POST',	
						params : {
								'args' : args
							},
						callback : function(options, success, response) {	
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
										title : '提示',
										msg : '修改成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK														
										});
								}
								else {
									var errorMsg = '';
									if(jsonData.errorinfo){
										errorMsg='<br/>错误信息:'+jsonData.errorinfo
									}
									Ext.Msg.show({
										title : '提示',
										msg : '修改失败!'+errorMsg,
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
					},this);
			   winUpdate.hide();
			   loadFormData();
			},
			 listeners:{//添加监听事件 可以结合handler测试这两个事件哪个最先执行
		         "click":function(){

		         }
   			}
		},{
			text : '恢复默认',
			iconCls : 'icon-save',
			handler : function() {
				
				Ext.MessageBox.confirm('提示', '确定要恢复默认数据吗?', function(btn) {
					if (btn == 'yes') {
						 Ext.Ajax.request({
							url : RESTORE_ACTION_URL ,		
							method : 'POST',	
							params : {
									'args' :''
								},
							callback : function(options, success, response) {	
								if(success){
									var jsonData = Ext.util.JSON.decode(response.responseText);	
									if (jsonData.success == 'true') {
										winUpdate.hide();
										Ext.Msg.show({
											title : '提示',
											msg : '恢复成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												loadFormData();
											}
										})
									} 
									}else {
											Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接!',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
												});
										}	
							}
						},this);
					}
				}, this);
			   		
			}
		},{
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
			winUpdate.hide();
			}
		}]
	})
	
	///**********************载入修改基础配置表单******************************/
	
	/***********根据配置项类型加载相应的组件************/
	var CreatUI= function(objNameType){
			switch (objNameType) {
			    case 'S':
			    var NewCom =new Ext.BDP.FunLib.Component.TextField({
						fieldLabel: desc,
						name :code,
						id:code,
						xtype:'textfield',
						allowBlank : false,
						blankText: '不能为空'			
				});
			    break;
			    case 'N':
			    var NewCom =new Ext.BDP.FunLib.Component.NumberField({
					fieldLabel: desc,
					name :code,
					id:code,
					xtype:'numberfield',
					allowBlank : false,
					blankText: '不能为空'
				});
			    break;
			    case 'D':
		    	var NewCom=new Ext.BDP.FunLib.Component.DateField({
					fieldLabel: desc,
					name :code,
					id:code,
					xtype:'datefield',
					allowBlank : false,
					blankText: '不能为空',
					format : BDPDateFormat,
					regexText:"日期不能为空",
					editable:false,
					enableKeyEvents : true,
					listeners : {   
						'keyup' : function(field, e)
							{	
								Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
									
							}}			
					});
		        break;
		  		case 'H': 
				var NewCom=new Ext.form.HtmlEditor({
					fieldLabel: desc,
					name :code,
					id:code,
					xtype:'htmleditor',
					allowBlank : false,
					blankText: '不能为空'	
				});  
		        break;
		    	case 'R':
		    		var NewCom=new Ext.BDP.FunLib.Component.RadioGroup({
					fieldLabel: desc,
		    		xtype:'fieldset',
					//xtype:'radio',
		    		defaultType:'radio',
					name :code,
					id:code,
					title:' ',
					autoHeight:true,
					defaultType:'radio',
					layout:'column', //激活、未激活呈分列式排布
					items:[{boxLabel:'Yes',name:code,inputValue:'Y'},
						   {boxLabel:'No',name:code,inputValue:'N',checked:true}]
				});
		        break;
		        case 'C':
			      	var NewCom=new Ext.BDP.FunLib.Component.Checkbox ({
			        xtype : 'checkbox',
					fieldLabel: desc,
					name :code,
					id:code,
					inputValue : true?'Y':'N'
				});	 
		        break;
		        case 'CB':
		        var NewCom = new Ext.BDP.FunLib.Component.BaseComboBox({
					fieldLabel: desc,
				 	name:code,
				 	id:code,
				 	mode : 'remote',
				 	triggerAction : 'all',// query
					forceSelection : true,
					selectOnFocus : false,
					typeAhead : true,
					queryParam : "desc",
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					minChars : 0,
					listWidth : 250,
					valueField : 'SSGRPRowId',
					displayField : 'SSGRPDesc',
					store : new Ext.data.JsonStore({
						autoLoad : true,
						url : BindingGroup,
						root : 'data',
						totalProperty : 'total',
						idProperty : 'SSGRPRowId',
						fields : ['SSGRPRowId', 'SSGRPDesc'],
						remoteSort : true,
						sortInfo : {
							field : 'SSGRPRowId',
							direction : 'ASC'
						}
					})
				 	/*editable:false,
				    typeAhead: true,
				    triggerAction: 'all',
				    lazyRender:true,
				    mode: 'local',
				    store: new Ext.data.ArrayStore({
				        id: 0,
				        fields: [
				            'myId',
				            'displayText'
				        ],
				        data: [[1, 'item1'], [2, 'item2']]
				    }),
				    valueField: 'myId',
				    displayField: 'displayText'*/
				});
			    break;
			}	
			return NewCom;
	}
	/***********添加组件************/
	var val = "";
	var valPsw = "",valCDSS="";
	var valSignPsw = "";
	var addItems = function(rowId){
			Ext.Ajax.request({											
				url:OPENDATA_ACTION_URL + '&id='+rowId ,
				method:'GET',
				async: false,  //同步
				callback:function(options,success,response){
					if(success){
						var jsonData=Ext.util.JSON.decode(response.responseText);
						value=jsonData.list[0].ConfigValue;
						code=jsonData.list[0].ConfigCode;
						desc=jsonData.list[0].ConfigDesc;
						type=jsonData.list[0].ConfigType;
						active=jsonData.list[0].ConfigActive;
						edit=jsonData.list[0].ConfigEdit
						explain=jsonData.list[0].ConfigExplain
						var showtype = CreatUI(type);
						if(code=="BDPPassWord"){
							Ext.getCmp(code).inputType="password";
							Ext.getCmp(code).setValue(value);  //给组件赋值
							winFormUpdate.add(showtype); //加载组件
							if(edit=='N'){              //是否隐藏组件
								Ext.getCmp(code).setDisabled(true);
							}else{
								Ext.getCmp(code).setDisabled(false);
							}
							//2021-01-08
							showtype.addListener('focus',function(){  //密码框点击时清空
								Ext.getCmp("BDPPassWord").setValue("")
							});
							showtype.addListener('blur',function(){    //密码框失去焦点时如果是空显示成******
								if (Ext.getCmp("BDPPassWord").getValue()=="") 
								{
									Ext.getCmp("BDPPassWord").setValue("******")
								}
							});
						}
						if(active!='N'){	//激活状态
							Ext.getCmp(code).setValue(value);  //给组件赋值
							//alert(code+"^"+explain)
							var remind=Ext.getCmp(code)      
							remind.on('render', function(field){   //设置悬浮提示
									if(field.rendered){
										field.getEl().dom.setAttribute("ext:qtip",explain)
									}
							})
							winFormUpdate.add(showtype); //加载组件
							count=count+1;

							if(edit=='N'){              //是否隐藏组件
								Ext.getCmp(code).setDisabled(true);
							}else{
								Ext.getCmp(code).setDisabled(false);
							}
							//是否新增用户默认安全组判断
							if(code=="BDPGroup"){
								val=value;
								Ext.getCmp(code).on('check',function(checked){
									if(checked.checked){
										Ext.getCmp("BDPSSUSRGroup").setDisabled(false);

									}else{
										Ext.getCmp("BDPSSUSRGroup").setDisabled(true);

									}
									
								})
							}
							if (code=="BDPSSUSRGroup"){
								if(val=="N"){
									Ext.getCmp(code).setDisabled(true);
								}else{
									Ext.getCmp(code).setDisabled(false);
								}
							}

							//是否新增用户默认密码
							if(code=="BDPIfUserPsw"){
								valPsw=value;
								Ext.getCmp(code).on('check',function(checked){
									if(checked.checked){
										Ext.getCmp("BDPUserPsw").setDisabled(false);
									}else{
										Ext.getCmp("BDPUserPsw").setDisabled(true);
									}
									
								})
							}
							if (code=="BDPUserPsw"){
								Ext.getCmp(code).inputType="password";
								if(valPsw=="N"){
									Ext.getCmp(code).setDisabled(true);
								}else{
									Ext.getCmp(code).setDisabled(false);
								}
							}
							
							//是否新增用户默认医嘱签名密码
							if(code=="BDPUserSignPswOpen"){
								valSignPsw=value;
								Ext.getCmp(code).on('check',function(checked){
									if(checked.checked){
										Ext.getCmp("BDPUserSignPsw").setDisabled(false);
									}else{
										Ext.getCmp("BDPUserSignPsw").setDisabled(true);
									}
									
								})
							}
							if (code=="BDPUserSignPsw"){
								Ext.getCmp(code).inputType="password";
								if(valSignPsw=="N"){
									Ext.getCmp(code).setDisabled(true);
								}else{
									Ext.getCmp(code).setDisabled(false);
								}
							}
							
							//是否开启临床决策支持
							if(code=="CDSSAut"){
								valCDSS=value;
								Ext.getCmp(code).on('check',function(checked){
									if(checked.checked){
										Ext.getCmp("CDSSDataServerIP").setDisabled(false);  //CDSS数据服务器IP

									}else{
										Ext.getCmp("CDSSDataServerIP").setDisabled(true);

									}
									
								})
							}
							//CDSS数据服务器IP
							if (code=="CDSSDataServerIP"){
								if(valCDSS=="N"){
									Ext.getCmp(code).setDisabled(true);
								}else{
									Ext.getCmp(code).setDisabled(false);
								}
							}
								
						}
						winFormUpdate.doLayout();
					}
				}	
			})   
	}

	//加载修改基础配置表单各项
	var loadUpdateData = function(){
		winFormUpdate.removeAll();
		count=0;
		Ext.Ajax.request({											
				url:IDSTR_ACTION_URL,
				method:'GET', 
				callback:function(options,success,response){
						    if(success){	
						    var jsonData=Ext.util.JSON.decode(response.responseText);
    				 		var IdJson=jsonData.IdStr;
    				 		var idStr = IdJson.split("^");
							for (var i = 1; i < idStr.length; i++) { 
								var id = idStr[i]; 
								addItems(id);
							}
							
							//winUpdate.setHeight(350+14*count);	//改变窗口大小*/
  						 }
					}
				})

	}
	
    ///***************************输入密码*******************************/
	/**密码输入表单*/
	var winFormSubmit = new Ext.form.FormPanel({
		id : 'form-submit',
		labelAlign : 'right',
		labelWidth : 130,
		frame :true,
		defaultType : 'textfield',
		items:[{
			fieldLabel : '<font color=red>*</font>请输入管理员密码',
			name : 'password',
			id:'password',
			inputType : 'password',
			allowBlank : false,
			blankText: '不能为空',
			listeners: {
		       specialkey: function(field, e){									
			        if (e.getKey() == e.ENTER) {
				         savepassword()
			        }
		        }
	       }
		}]
	})
	/**密码输入窗口**/
	var winSubmit=new Ext.Window({
		title : '基础数据平台配置修改',
		width : 350,
		height:150,
		layout : 'fit',
		plain : true,//true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closable:false,
		closeAction : 'hide',
		items : winFormSubmit,
		buttons:[{
			text:"确定",
			iconCls : 'icon-ok',
			id:'submit_btn',
			handler: savepassword=function(){
				if (Ext.getCmp("password").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '密码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			    var matchresponse=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","MatchPassword",Ext.getCmp("password").getValue());
				if (matchresponse==0) 
				{
					loadUpdateData();
			    	Ext.getCmp("form-submit").getForm().findField("password").reset();
			    	winSubmit.hide();			    				   			    	
					winUpdate.setTitle('修改');
					winUpdate.setIconClass('icon-update');
					winUpdate.show();						
	
				}
				else
				{
					Ext.Msg.show({
						title : '提示',
						msg : '密码错误，请重新输入' ,
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK,
						fn : function(btn) {
							
							Ext.getCmp("form-submit").getForm().findField("password").focus(true,300);
						}
					})
					
					
				}
			}
			
		},{
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				Ext.getCmp("form-submit").getForm().findField("password").reset();
				winSubmit.hide();
			}
		}]
	})
	
	
   ///***************************首页面基础配置显示表单********************************/
	   var fieldSet1 = new Ext.form.FieldSet({                                
           title: '默认显示条数',  
           id : 'fieldSet1'                             
        });
       var fieldSet2 = new Ext.form.FieldSet({                                
           title: '权限配置',  
           id : 'fieldSet2'                             
        });
       /*var fieldSet3 = new Ext.form.FieldSet({                                
           title: '版本信息',  
           id : 'fieldSet3'                            
        }); */
       var fieldSet4 = new Ext.form.FieldSet({                                
           title: '其他信息',  
           id : 'fieldSet4'
          // hidden:true
        }); 
/*       var tb = new Ext.Toolbar({
        		enableOverflow : true,
				id : 'tb',
				height:25,
				buttonAlign:'right',
				items: ["->",helphtmlbtn]
			});*/
        
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
		labelWidth : 220,
		//tools:Ext.BDP.FunLib.Component.HelpMsg,
		tbar : ["<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"cog_edit.png' style='border: 0px'>","平台配置","->",helphtmlbtn],
		items:[{
			layout:'column',
			items:[{
				columnWidth:.4,
				baseCls : 'x-plain',//form透明,不显示框框
				layout:'form',
				autoHeight:true,
				items:[fieldSet1,fieldSet2]
			},{
				columnWidth:.4,
				baseCls : 'x-plain',//form透明,不显示框框
				layout:'form',
				autoHeight:true,
				style:'margin-left:10px',
				items:[fieldSet4]
			}]				
		}],
			buttons:[{
			text:"修改配置",
			iconCls : 'icon-update',
			width:100,
			id:"update",
			handler:function(){				
				winSubmit.show();
				Ext.getCmp("form-submit").getForm().findField("password").focus(true,300);
			}
		}]
	})
	
	
	
	/*****************载入首页面基础配置显示表单的数据*****************/
	//首页创建displayField类型组件
	var CreatDisplayField=function(){
			var NewCom =new Ext.form.DisplayField({
						fieldLabel: desc,
						name :code+"a",
						id:code+"a",
						allowBlank:true
				});
			return NewCom;
	}
	//加载组件
	var addDisplayItems = function(rowId){
			Ext.Ajax.request({											
				url:OPENDATA_ACTION_URL + '&id='+rowId ,
				method:'GET',
				async: false,  
				callback:function(options,success,response){
							if(success){
						    	var jsonData=Ext.util.JSON.decode(response.responseText);
						    	value=jsonData.list[0].ConfigValue;
						    	code=jsonData.list[0].ConfigCode;
						    	desc=jsonData.list[0].ConfigDesc;
						    	type=jsonData.list[0].ConfigType;
						    	active=jsonData.list[0].ConfigActive;
						    	explain=jsonData.list[0].ConfigExplain;
						    	var showtype=CreatDisplayField();
						    	if(code=="BDPPageSizeForMain"||code=="BDPPageSizeForPop"||code=="BDPPageSizeForAut"||code=="BDPPageSizeForCombo"){
									Ext.getCmp('fieldSet1').remove(showtype);
								}
								else if(code=="BDPDisableDel"||code=="BDPHospAut"||code=="BDPDataAudit"||code=="BDPTranslation"||code=="BDPDataImport"||code=="BDPNationalData"||code=="BDPKeyMap"||code=="BDPQueryAutGroup"){
									Ext.getCmp('fieldSet2').remove(showtype);
								}
								/*else if(code=="BDPVersion"||code=="BDPUpdateLog"){
									Ext.getCmp('fieldSet3').remove(showtype);
								}*/
								else {										
									Ext.getCmp('fieldSet4').remove(showtype);
								} 	
							    if(active!='N'){
									//添加组件
									if(code=="BDPGroup"){
										val=value;
									}
									if(code=="BDPIfUserPsw"){
										valPsw=value;
									}
									if(code=="BDPUserSignPswOpen"){
										valSignPsw=value;
									}
									if(code=="CDSSAut"){
										valCDSS=value;
									}
								    /*if((code=="BDPTranslation")&&(value=="true"||value=="Y")){   //开启翻译功能配置
								    	value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'> <a href='#' onclick='Ashow();'>翻译功能配置</a>"
								    }*/
								    if((code=="BDPNationalData")&&(value=="true"||value=="Y")){   //开启国家标准编码
								    	value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'> <a href='#' onclick='showNationalData();'>国家标准编码列表显示字段</a>"
								    }
								    if((code=="BDPKeyMap")&&(value=="true"||value=="Y")){   //开启快捷键
										 value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'> <a href='#' onclick='showKeyMapData();'>快捷键配置</a>"
								    }
								    if((code=="BDPQueryAutGroup")&&(value=="true"||value=="Y")){   //开启安全组数据查询权限
								    	value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'> <a href='#' onclick='showSSGroupAutData();'>授权安全组</a>"
								    }
								    if((code=="BDPHISASRLoc")&&(value=="true"||value=="Y")){   //开启按科室开启语音功能
								    	
								    	value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'> <a href='#' onclick='BDPHISASRLocDatashow();'>授权科室</a>"
								    }
									if((code=="CDSSAut")&&(value=="true"||value=="Y")){   //开启临床决策支持系统 2021-07-14 likefan
								    	value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'> <a href='#' onclick='showBDPCDSSDeptUserAut();'>科室用户配置</a>"
								    }
								    
								    if(type=="C"&&(value=="N"||value==""||value=="false")){
								    		value="<img src='../scripts/bdp/Framework/icons/no1.png' style='border: 0px'>"
								    }
								    if(type=="C"&&(value=="true"||value=="Y")){
								    	     value="<img src='../scripts/bdp/Framework/icons/yes1.png' style='border: 0px'>"
								    		//value="<a href='#' onclick='Ashow();'>翻译功能配置</a>"
								    }
								    
									Ext.getCmp(code+"a").setValue(value);
									var remind=Ext.getCmp(code+"a")
									remind.on('render', function(field){   //设置悬浮提示
										if(field.rendered){
											field.getEl().dom.setAttribute("ext:qtip",explain)
										}
									})

									
									if(code=="BDPPageSizeForMain"||code=="BDPPageSizeForPop"||code=="BDPPageSizeForAut"||code=="BDPPageSizeForCombo"){
										Ext.getCmp('fieldSet1').items.add(showtype);
									}
									else if(code=="BDPDisableDel"||code=="BDPHospAut"||code=="BDPDataAudit"||code=="BDPTranslation"||code=="BDPDataImport"||code=="BDPNationalData"||code=="BDPKeyMap"||code=="BDPQueryAutGroup"){
										Ext.getCmp('fieldSet2').items.add(showtype);
									}
									/*else if(code=="BDPVersion"||code=="BDPUpdateLog"){
										Ext.getCmp('fieldSet3').items.add(showtype);
									}*/
									else {	
										/*if (code=="BDPGroup"){
											Ext.getCmp('fieldSet4').items.add(showtype);
										}*/
										if (code=="BDPSSUSRGroup"){
											if(val=="true"||val=="Y"){
												Ext.getCmp('fieldSet4').items.add(showtype);
											}
										}
										/*if (code=="BDPIfUserPsw"){
											Ext.getCmp('fieldSet4').items.add(showtype);
										}*/
										else if (code=="BDPUserPsw"){
											if(valPsw=="true"||valPsw=="Y"){
												Ext.getCmp('fieldSet4').items.add(showtype);
											}
										}
										/*if (code=="BDPUserSignPswOpen"){
											Ext.getCmp('fieldSet4').items.add(showtype);
										}*/
										else if (code=="BDPUserSignPsw"){
											if(valSignPsw=="true"||valSignPsw=="Y"){
												Ext.getCmp('fieldSet4').items.add(showtype);
											}
										}
										else if (code=="CDSSDataServerIP"){
											if(valCDSS=="true"||valCDSS=="Y"){
												Ext.getCmp('fieldSet4').items.add(showtype);
											}
										}
										/*if (code=="BDPUserSyncPACS"||code=="BDPCheckDataLog"||code=="BDPCheckDataTime"||code=="BDPNewData"||code=="BDPUsePortal"||code=="BDPLogStartNum"){
											Ext.getCmp('fieldSet4').items.add(showtype);
										}*/
										else{
											Ext.getCmp('fieldSet4').items.add(showtype);
										}
										
									} 

						    	}
						    	formConfig.doLayout();
						    }
						}	
				})   
	}
	//加载首页面基础配置表单
    var loadFormData = function() {
 			Ext.Ajax.request({											
				url:IDSTR_ACTION_URL,
				method:'GET',
				callback:function(options,success,response){
						    if(success){	
							var jsonData=Ext.util.JSON.decode(response.responseText);
    				 		var IdJson=jsonData.IdStr;
    				 		var idStr = IdJson.split("^");
							for (var i = 1; i < idStr.length; i++) { 
								var id = idStr[i]; 
								addDisplayItems(id);
							}
  						 }
					}
				})

    };	
    var btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除',
					iconCls : 'icon-delete',
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					handler : function DelData() {
						
					}
				});
   loadFormData();
	/**用Viewport可自适应高度跟宽度*/
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [formConfig]
    });
});

