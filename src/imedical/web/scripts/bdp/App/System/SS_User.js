// / 名称: 用户维护
// / 描述: 用户维护
// / 编写者： 基础数据平台组 、蔡昊哲 陈莹
// / 编写日期: 2013-4-24
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombo.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePagePanel.js"> </script>');
/** ----------------------------------掉用外部JS--------------------------------------* */
var ResourceJS = '../scripts/bdp/App/Care/CT_CareProv_Resource.js';//指定科室部分
document.write('<script type="text/javascript" src="'+ResourceJS+'"></script>');
var MedUnitJS = '../scripts/bdp/App/Care/CT_CareProv_MedUnit.js';//医疗单元部分
document.write('<script type="text/javascript" src="'+MedUnitJS+'"></script>');

var htmlurl = "../scripts/bdp/AppHelp/System/SSUser.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/assets/uimain.js"> </script>');
/** ----------------------------------掉用外部JS--------------------------------------* */
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var communityid=Ext.getUrlParam('communityid');	

Ext.onReady(function() {
	var TodayDate=(new Date()).format(BDPDateFormat);
	var selectNode="",HiddenCat="";
	var type="SSUSRDefaultDeptDR",sort="default";
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip';

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';				
		
	//**********左侧类别树 *************//
	/*
	var fstyle1="",fstyle2="",fstyle3="",fstyle4="",fstyle5="",fstyle6="";
	if(!Sys.ie)  //ie11 ,chorme
	{ 
		//if ("ActiveXObject" in window)  ///ie11
		if((navigator.userAgent.indexOf('Trident')>-1)&&(navigator.userAgent.indexOf("rv:11.0")>-1))
		{
			fstyle1="margin-top: -12px;";
			fstyle2="margin-top: -12;";
			fstyle3="margin-top: -6px;";
			fstyle4="margin-top: -25px;";
			fstyle5="margin-top: -12px;";
			fstyle6="margin-top: -2px;";
		}
		else  //chrome  火狐
		{
			fstyle1="margin-top: -15px;margin-left: -5px;";
			fstyle2="margin-top: -15px;margin-left: -5px;";
			fstyle3="margin-top: -10px;margin-left:-5px;";
			fstyle4="margin-top: -30px;margin-left:-5px;";
			fstyle5="margin-top: -15px;margin-left:-5px;";
			fstyle6="margin-top: -10px;margin-left:-5px;";
		}
	}
	else ///ie10,9,8,7,6
	{
		//真实ie8
		fstyle1="margin-top: -2px;";
		fstyle2="margin-top: -2;";
		fstyle3="margin-top: -2px;";
		fstyle4="margin-top: -2px;";
		fstyle5="margin-top: -2px;";
		fstyle6="margin-top: 0;";
		if(navigator.userAgent.indexOf("MSIE")>0){
      		if(navigator.userAgent.indexOf("MSIE 8.0")>0 && !window.innerWidth){
      			fstyle1="margin-top: 0px;";
				fstyle2="margin-top: 0px;";
				fstyle3="margin-top: 0px;";
				fstyle4="margin-top: -2px;";
				fstyle5="margin-top: 0px;";
				fstyle6="margin-top: 0px;";
      		}    
    	}	
	}

	function removeClass(){
		Ext.fly('btnSSUSRDefaultDeptDR').removeClass('x-btn-click');
		Ext.fly('btnRESCTLOCDR').removeClass('x-btn-click');
		Ext.fly('btnSSUSRGroup').removeClass('x-btn-click');
		Ext.fly('btnCTPCPCarPrvTpDR').removeClass('x-btn-click');
		Ext.fly('btnCTPCPSpecDR').removeClass('x-btn-click');
		//Ext.fly('btnSSUSRHospitalDR').removeClass('x-btn-click');
	}
	function loadTree(){
		Ext.getCmp('TreeSearchText').setValue('');
		CatPanel.loadTree(type,hospComp.getValue());
        hiddenPkgs = [],selectNode="",HiddenCat=""
	}
	var height1=document.documentElement.clientHeight
	var height2=document.body.clientHeight
	var windowheight=(height1>height2)? (height1-67):(height2-67)
	var TypePanel = new Ext.form.FormPanel({
		id : 'TypePanel',
		items : [{ 
			xtype: 'buttongroup',
			id :'btnGroup',
	        columns: 1,
	        items: [{
	        	text:'<div style="'+fstyle1+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">登录科室</div>',
	            id:'btnSSUSRDefaultDeptDR',
	            width:30,
	            height:windowheight*1/5,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSSUSRDefaultDeptDR'),
	            listeners:{
	            	'click':function(){
	            		type="SSUSRDefaultDeptDR";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnSSUSRDefaultDeptDR').addClass('x-btn-click');
	            	}
	            }
	        },{
	        	text:'<div style="'+fstyle2+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">指定科室</div>',
	            id:'btnRESCTLOCDR',
	            width:30,
	            height:windowheight*1/5,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRESCTLOCDR'),
	            listeners:{
	            	'click':function(){
	            		type="RESCTLOCDR";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnRESCTLOCDR').addClass('x-btn-click');
	            	}
	            }
	        },{
	           	text:'<div style="'+fstyle3+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">安全组</div>',
	           	id:'btnSSUSRGroup',
	           	width:30,
	            height:windowheight*1/5,
	           	disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSSUSRGroup'),
	        	listeners:{
	            	'click':function(){
	            		type="SSUSRGroup";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnSSUSRGroup').addClass('x-btn-click');
	            	}
	            }
	        },{
	            text:'<div style="'+fstyle4+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">医护人员类型</div>',
	            id:'btnCTPCPCarPrvTpDR',
	            width:30,
	            height:windowheight*1/5,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTPCPCarPrvTpDR'),
	            listeners:{
	            	'click':function(){
	            		type="CTPCPCarPrvTpDR";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnCTPCPCarPrvTpDR').addClass('x-btn-click');
	            	}
	            }
	        },{
	            text:'<div style="'+fstyle5+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">医生专长</div>',
	            id:'btnCTPCPSpecDR',
	            width:30,
	            height:windowheight*1/5,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTPCPSpecDR'),
	            listeners:{
	            	'click':function(){
	            		type="CTPCPSpecDR";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnCTPCPSpecDR').addClass('x-btn-click');
	            	}
	            }
	        }]
		}]
	});
	
	
	
	
	
	var CatTree_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=GetTreeJson";
	var CatPanel = new Ext.BDP.Component.tree.TreePanel({
		height:windowheight,
		dataUrl:CatTree_QUERY_ACTION_URL,
		ObjectType : type,
        pageSize:Ext.BDP.FunLib.PageSize.Aut, 
        disToolbar : false,
		tbar:['检索',
		new Ext.BDP.FunLib.Component.TextField({
			id:'TreeSearchText',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TreeSearchText'),
		    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TreeSearchText')),
			width:125,
			enableKeyEvents: true,
			listeners:{
				keyup:function(node, event) {
					if(event.getKey()==13){
						CatPanel.doQuery();
					}
					if(event.getKey()==27){
						Ext.getCmp('TreeSearchText').setValue('');
						CatPanel.doQuery();
						HiddenCat="";
						refresh();
					}
				},
				scope: this
			}
		}), '-', new Ext.Button({
			iconCls : 'icon-search',
			tooltip : '检索',
			id : 'btnRetrieve',
			handler : function(){
				CatPanel.doQuery();
				grid.getStore().baseParams = {
					Initials : Ext.getCmp("TextCode").getValue(),
					Name : Ext.getCmp("TextName").getValue(),
					Active : Ext.getCmp("TextActive").getValue()
				};
				HiddenCat="";
				refresh();
				
			},
			scope : this
		}),'-',  {
			iconCls:'icon-refresh',
			tooltip : '重置',
			id : 'btnReset',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnReset'),
			handler:function(){
				Ext.getCmp('TreeSearchText').setValue('');
				CatPanel.doQuery();
				HiddenCat="";
				refresh();
			} 
		}
		],
	    listeners:{
           "click":function(node,event) {
       			var nid=node.id;
       			HiddenCat=nid;
   				grid.getStore().baseParams = {
					Initials : Ext.getCmp("TextCode").getValue(),
					Name : Ext.getCmp("TextName").getValue(),
					Active : Ext.getCmp("TextActive").getValue(),
					//SSUSRGroup : Ext.getCmp("SSGRP").getValue(),
					//DefaultDeptDR:Ext.getCmp("DefDeptDR").getValue(),
					//CarPrvTpDR:Ext.getCmp("careprovtype").getValue(),
					//SpecDR:Ext.getCmp("CTPCPSpecDR").getValue(),
					treetype:type,
   					category:HiddenCat,
   					sort:sort,
					hosp:hospComp.getValue()
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize,
						communityid:communityid
					}
				});
			}
        }
	});	
	var searchPanel = new Ext.Panel({
		width: 265,
		title:'&nbsp',
		region:'west',
		collapsible:true,
		layout: 'column',
        items: [{
        	width: 42,
            items:[TypePanel]
        }, {
            columnWidth: 1,
            items:[CatPanel]
        }]
	});
	*/
	//**********左侧类别树  end*************//
	
	
	

	//var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassQuery=GetList";
	var ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=GetListPage";
	//var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=SaveData&pEntityName=web.Entity.CT.SSUser";
	var SAVEALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=SaveAll";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=Delete";
	var DELETEALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=DeleteAll";
	
	var BindingCTCareProv = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetDataForCmb1";
	var BindingLanguage = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetDataForCmb1";
	var BindingLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var BindingGroup = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";
	var BindingPerson = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSPerson&pClassQuery=GetDataForCmb1";
	
	var BindingSpec = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSpec&pClassQuery=GetDataForCmb1";
	var BindingCarPrvTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetDataForCmb1";
	var BindingHospital = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var BindingTitle = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTitle&pClassQuery=GetDataForCmb1";
	//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=OpenData";
	var OPENALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=OpenAll";
	var OPEN_CAREPROV_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=GetData";
	
	
	var ACTION_URL_SSUserOtherLogonLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassQuery=GetList";
	//var SAVE_URL_OtherLogonLoc = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=SaveData&pEntityName=web.Entity.CT.SSUserOtherLogonLoc"
	var SAVE_URL_OtherLogonLoc = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=SaveAll";
	var DELETE_OtherLogonLoc_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=DeleteData"
	
	var ACTION_URL_UserAccountPost = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSUserAccountPost&pClassQuery=GetList";
	var SAVE_URL_UserAccountPost = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSUserAccountPost&pClassMethod=SaveAll";
	var DELETE_UserAccountPost_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSUserAccountPost&pClassMethod=DeleteData"
	var BindingPost = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSEmpPost&pClassQuery=GetDataForCmb1";

	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pageSize_LogonLoc = Ext.BDP.FunLib.PageSize.Pop;
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

	//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="SS_User"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	//-----------------（别忘了后面的grid单击事件）翻译结束--------//
	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.SSUser";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	/////////////////////////////日志查看 ////////////////////////////////////////
	//var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
	var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
	var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu) 
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
			RowID=rows[0].get('SSUSRRowId');
			Desc=rows[0].get('SSUSRName');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "SS_User"
	});
	
	//多院区医院下拉框	20200520 likefan
	var hospstore=new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb2"}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'HOSPRowId', 'HOSPDesc' ])
		})
		var hospComp = new Ext.form.ComboBox({
			id:'_hospComp',
			labelSeparator:"",
			width:250,
			fieldLabel : '医院',
			store : hospstore,
			editable:false,
			queryParam : 'desc',
			triggerAction : 'all',
			forceSelection : true,
			selectOnFocus : false,
			listWidth :250,
			valueField : 'HOSPRowId',
			displayField : 'HOSPDesc'
		});
		hospstore.load({
		       callback: function () {
			       hospComp.setValue(session['LOGON.HOSPID']);   //初始赋值为当前登录科室的院区
			       Ext.getCmp('_hospComp').fireEvent('select',Ext.getCmp('_hospComp'),Ext.getCmp('_hospComp').getStore().getById(session['LOGON.HOSPID']))  //触发select事件
		        },
		        scope: hospstore,
		        add: false
		});
	//医院下拉框选择一条医院记录后执行此函数
	hospComp.on('select',function (){
		
		grid.getStore().baseParams = {
				Initials : Ext.getCmp("TextCode").getValue(),
				Name : Ext.getCmp("TextName").getValue(),
				Active : Ext.getCmp("TextActive").getValue(),
				hosp:hospComp.getValue(),
				//treetype:type,
				//category:"",
				sort:sort
			};
		grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize,
					communityid:communityid
				},
				callback : function(records, options, success) {
					//loadTree();	 ///grid加载完 加载左侧分类树 2020-05-15
				}
			});
	});
	
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
			if (grid.selModel.hasSelection()) {
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行
				
				var rowid=rows[0].get('SSUSRRowId')
				var RESDesc=rows[0].get('CTPCPDesc');
				if (RESDesc!="")
				{
					Ext.MessageBox.show({
						title:'提示',
						msg:'是否同时删除医护人员？',
						buttons:Ext.MessageBox.YESNOCANCEL,
						fn:function(btn){
							/**删除用户开始**/
							if (btn == 'no') {
								AliasGrid.DataRefer =rowid;
								AliasGrid.delallAlias();
								Ext.Ajax.request({
									url : DELETE_ACTION_URL,
									method : 'POST',
									params : {
										'id' : rowid
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
														Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
													}
												});
											} else {
												var errorMsg = '';
												if (jsonData.info) {
													errorMsg = '<br />错误信息:'+ jsonData.info
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
						/**删除用户结束**/
						/**删除用户同时删除医护人员开始**/
							if (btn == 'yes') {
								AliasGrid.DataRefer = rowid;
								AliasGrid.delallAlias();
								Ext.Ajax.request({
									url : DELETEALL_ACTION_URL,
									method : 'POST',
									params : {
										'id' : rowid
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
														Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
													}
												});
											} else {
												var errorMsg = '';
												if (jsonData.info) {
													errorMsg = '<br />错误信息:'+ jsonData.info
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
						/**删除用户同时删除医护人员结束**/
						}
					},this)
				}
				else
				{
					Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
						if (btn == 'yes') {
							AliasGrid.DataRefer = rowid;
							AliasGrid.delallAlias();
							Ext.Ajax.request({
								url : DELETE_ACTION_URL,
								method : 'POST',
								params : {
									'id' : rowid
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
													Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
												}
											});
										} else {
											var errorMsg = '';
											if (jsonData.info) {
												errorMsg = '<br />错误信息:'+ jsonData.info
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
					
				}
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
	/** ---------用户维护表单内容部分------------* */
	var SSUSRInitials = new Ext.BDP.FunLib.Component.TextField({
		//代码
		fieldLabel : '<font color=red>*</font>代码',
		id : 'SSUSRInitials',
		name : 'SSUSRInitials',
		blankText : '不能为空',
		allowBlank : false,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRInitials'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRInitials')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRInitials'),
		dataIndex : 'SSUSRInitials',
		validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
			var className = "web.DHCBL.CT.SSUser"; // 后台类名称
			var classMethod = "FormValidate"; // 数据重复验证后台函数名
			var id = "";
			if (win.title == '修改') { // 如果窗口标题为'修改'则获取rowid
				var _record = grid.getSelectionModel().getSelected();
				var id = _record.get('SSUSRRowId'); // 此条数据的rowid
			}
			var flag = "";
			var flag = tkMakeServerCall(className, classMethod,id, thisText); // 用tkMakeServerCall函数实现与后台同步调用交互
			// Ext.Msg.alert(flag);
			if (flag == "1") { // 当后台返回数据位"1"时转换为相应的布尔值
				return false;
			} else {
				return true;
			}
		},
		invalidText : '该代码已经存在',
		listeners : {
			'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
			'blur' : function(){
				if((Ext.getCmp("CTPCPCode").getValue()=="")&&(Ext.getCmp("CTProvSet").collapsed==false))
				{
					Ext.getCmp("CTPCPCode").setValue(Ext.getCmp("SSUSRInitials").getValue());
					syncCTPCPCode()
				}	
				
			}
		}	
	});
	var syncCTPCPCode = function() {
		var code=Ext.getCmp("CTPCPCode").getValue()
		Ext.Ajax.request({
				url : OPEN_CAREPROV_URL , 		
				method : 'GET',	
				params : {
					'code' : Ext.getCmp("CTPCPCode").getValue()
				},
				callback : function(options, success, response) {	
					if(success){
						var jsonData = Ext.util.JSON.decode(response.responseText);
						if(jsonData.CTPCPDesc!=""){
							
								//Ext.MessageBox.confirm('提示', '此医护人员工号已存在，是否要跟此医护人员关联?', function(btn) {
								//	if (btn == 'yes') {
										Ext.getCmp("CareProvDR").setValue(jsonData.CTPCPRowId1);
										Ext.getCmp("CTPCPOtherName").setValue(jsonData.CTPCPOtherName);//拼音检索码
										Ext.getCmp("CTPCPUnit").setValue(jsonData.CTPCPUnit);//专业资格证书号
										Ext.getCmp("CarPrvTpDR").setValue(jsonData.CTPCPCarPrvTpDR);//医护人员类型
										Ext.getCmp("CTPCPDateActiveFrom").setValue(jsonData.CTPCPDateActiveFrom);//开始日期
										Ext.getCmp("CTPCPSurgeon").setValue(jsonData.CTPCPSurgeon);//外科医生
										Ext.getCmp("CTPCPHICApproved").setValue(jsonData.CTPCPHICApproved);//毒麻处方权
										//Ext.getCmp("CTPCPActiveFlag").setValue(jsonData.CTPCPActiveFlag);//激活
										Ext.getCmp("CTPCPDesc").setValue(jsonData.CTPCPDesc);//姓名
										Ext.getCmp("CTPCPId").setValue(jsonData.CTPCPId);//标识码
										Ext.getCmp("CTPCPTextOne").setValue(jsonData.CTPCPTextOne);//执业证书编码
										Ext.getCmp("CTPCPTextTwo").setValue(jsonData.CTPCPTextTwo);//Text2
										Ext.getCmp("SpecDR").setValue(jsonData.CTPCPSpecDR);//医生专长
										Ext.getCmp("CTPCPAnaesthetist").setValue(jsonData.CTPCPAnaesthetist);//麻醉师
										Ext.getCmp("CTPCPSpecialistYN").setValue(jsonData.CTPCPSpecialistYN);//可以出特需号
										Ext.getCmp("CTPCPDateActiveTo").setValue(jsonData.CTPCPDateActiveTo);//结束日期
										/*Ext.getCmp("CTPCPTelO").setValue(jsonData.CTPCPTelO);//办公电话
										Ext.getCmp("CTPCPTelH").setValue(jsonData.CTPCPTelH);//家庭电话
										Ext.getCmp("CTPCPTelOExt").setValue(jsonData.CTPCPTelOExt);//电话分机
										Ext.getCmp("CTPCPMobilePhone").setValue(jsonData.CTPCPMobilePhone);//手机
										Ext.getCmp("CTPCPEmail").setValue(jsonData.CTPCPEmail);//邮箱
										Ext.getCmp("CTPCPFax").setValue(jsonData.CTPCPFax);//传真 */
										Ext.getCmp("TitleDR").setValue(jsonData.CTPCPTitleDR);//医护人员职称
										Ext.getCmp("CTPCPMentalFlag").setValue(jsonData.CTPCPMentalFlag)
								//	}
								//}, this);
								
								//管制药品分类面板 2020年4月9日
								_Poisongridds.load({
									params:{parref:jsonData.CTPCPRowId1},
									callback: function(records, options, success){
										var records=[];//存放选中记录  
										for(var i=0;i<_Poisongridds.getCount();i++){  
											var record = _Poisongridds.getAt(i);  
											if(record.data.LinkFlag=='Y'){ records.push(record);   }  
										}  
										gridsm.selectRecords(records);//执行选中已对照的记录  
										hdcheckedfun(_PoisongridObj)	//全选框是否勾选 2020-11-25
									}
								});
								//关联处方权面板 2020年10月19日
								_PrescriptSetgridds.load({
									params:{
										parref:jsonData.CTPCPRowId1,
										hospid:hospComp.getValue()
									},
									callback: function(records, options, success){
										var records=[];//存放选中记录  
										for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
											var record = _PrescriptSetgridds.getAt(i);  
											if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
										}  
										PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
										hdcheckedfun(_PrescriptSetgridObj)	//全选框是否勾选 2020-11-25
									}
								});
								
						}else{
							Ext.getCmp("CareProvDR").setValue("");
							Ext.getCmp("CTPCPOtherName").setValue("");//拼音检索码
							Ext.getCmp("CTPCPUnit").setValue("");//专业资格证书号
							Ext.getCmp("CarPrvTpDR").setValue("");//医护人员类型
							Ext.getCmp("CTPCPDateActiveFrom").setValue("");//开始日期
							Ext.getCmp("CTPCPSurgeon").setValue("");//外科医生
							Ext.getCmp("CTPCPHICApproved").setValue(false);//毒麻处方权
							//Ext.getCmp("CTPCPActiveFlag").setValue(true);//激活
							Ext.getCmp("CTPCPDesc").setValue("");//姓名
							Ext.getCmp("CTPCPId").setValue("");//标识码
							Ext.getCmp("CTPCPTextOne").setValue("");//执业证书编码
							Ext.getCmp("CTPCPTextTwo").setValue("");//Text2
							Ext.getCmp("SpecDR").setValue("");//医生专长
							Ext.getCmp("CTPCPAnaesthetist").setValue(false);//麻醉师
							Ext.getCmp("CTPCPSpecialistYN").setValue(false);//可以出特需号
							Ext.getCmp("CTPCPDateActiveTo").setValue("");//结束日期
							/*Ext.getCmp("CTPCPTelO").setValue("");//办公电话
							Ext.getCmp("CTPCPTelH").setValue("");//家庭电话
							Ext.getCmp("CTPCPTelOExt").setValue("");//电话分机
							Ext.getCmp("CTPCPMobilePhone").setValue("");//手机
							Ext.getCmp("CTPCPEmail").setValue("");//邮箱
							Ext.getCmp("CTPCPFax").setValue("");//传真*/
							Ext.getCmp("TitleDR").setValue("");//医护人员职称
							Ext.getCmp("CTPCPMentalFlag").setValue("");
							
							//管制药品分类面板 2020年4月9日
							_Poisongridds.load({
								callback: function(records, options, success){
									var records=[];//存放选中记录  
									for(var i=0;i<_Poisongridds.getCount();i++){  
										var record = _Poisongridds.getAt(i);  
										if(record.data.LinkFlag=='Y'){ records.push(record);   }  
									}  
									gridsm.selectRecords(records);//执行选中已对照的记录  
									hdcheckedfun(_PoisongridObj)	//全选框是否勾选 2020-11-25
								}
							});
							//关联处方权面板 2020年10月19日
							_PrescriptSetgridds.load({
								params:{
									parref:0,
									hospid:hospComp.getValue()
								},
								callback: function(records, options, success){
									var records=[];//存放选中记录  
									for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
										var record = _PrescriptSetgridds.getAt(i);  
										if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
									}  
									PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
									hdcheckedfun(_PrescriptSetgridObj)	//全选框是否勾选 2020-11-25
								}
							});	
							
						}
						
					}
				}
			});
	
	
	}
	
	var SSUSRName = new Ext.BDP.FunLib.Component.TextField({ 
		//姓名
		fieldLabel : '<font color=red>*</font>姓名',
		id : 'SSUSRName',
		name : 'SSUSRName',
		blankText : '不能为空',
		allowBlank : false,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRName'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRName')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRName'),
		dataIndex : 'SSUSRName',		
		listeners:{
			'blur' : function(){
				if(Ext.getCmp("CTPCPDesc").getValue()==""){
					Ext.getCmp("CTPCPDesc").setValue(Ext.getCmp("SSUSRName").getValue());
					Ext.getCmp("CTPCPOtherName").setValue(Pinyin.GetJPU(Ext.getCmp("SSUSRName").getValue()))
				}	
				var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetDBCCNCODE",Ext.getCmp("SSUSRName").getValue(),4) 
				Ext.getCmp("SSUSRPYCode").setValue(PYCode);
				var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Ext.getCmp("SSUSRName").getValue(),1) 
				Ext.getCmp("SSUSRWBCode").setValue(WBCode);
			}
		}
	});
	/*var loginLoc = new Ext.Button({
		//其他登录科室维护
		fieldLabel:' ',
		//xtype:'button',
		id:'loginLoc',
		text : '其他登录科室维护',
		tooltip : '其他登录科室维护',
		labelSeparator : '',
		boxMaxWidth:50,	 
		//iconCls : 'icon-LoginLoc',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('loginLoc'),
		handler : function LoginLocUpdateData() {
			if (grid.selModel.hasSelection()) {
				WinForm.isAdd = false;
				winOtherLogonLocPanel.setTitle('其他登录科室');
				winOtherLogonLocPanel.setIconClass('icon-LoginLoc');
				winOtherLogonLocPanel.show('');
				Ext.getCmp("comboxOtherLogonLoc").reset();
				Ext.getCmp("comboGroup").reset();
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行
				var SSUSRRowId = rows[0].get('SSUSRRowId');
				gridOtherLogonLoc.getStore().baseParams = {
					OTHLLParRef : SSUSRRowId
				};
				gridOtherLogonLoc.getStore().load({
					params : {
						start : 0,
						limit : pageSize_LogonLoc
					}
				});
				Ext.getCmp("hidden_SSUSRRowId").reset();
				Ext.getCmp("hidden_SSUSRRowId").setValue(SSUSRRowId);
			} else {
				Ext.Msg.show({
					title : '提示',
					msg : '请选择用户!',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
				});
			}
		}

	});*/
	
	
	var SSUSRDefaultDeptDR = new Ext.BDP.Component.form.ComboBox({
		//默认登录科室
		fieldLabel : '<font color=red>*</font>默认登录科室',	
		//xtype : 'bdpcombo',
		name : 'SSUSRDefaultDeptDR',
		id : 'DefaultDeptDR',
		allowBlank : false,
		blankText : '不能为空',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRDefaultDeptDR'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRDefaultDeptDR')),
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('SSUSRDefaultDeptDR'),
		hiddenName : 'SSUSRDefaultDeptDR',
		//triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOcnFocus : false,
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTLOCRowID',
		displayField : 'CTLOCDesc',
		store : new Ext.data.JsonStore({
			url : BindingLoc,
			baseParams:{communityid:communityid},
			//autoLoad : true,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CTLOCRowID',
			fields : ['CTLOCRowID', 'CTLOCDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTLOCRowID',
				direction : 'ASC'
			}
		})
	});
	
	var SSUSRDefRBDepartmentDR = new Ext.BDP.Component.form.ComboBox({
		fieldLabel : '行政科室',	
		name : 'SSUSRDefRBDepartmentDR',
		id : 'SSUSRDefRBDepartmentDR1',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRDefRBDepartmentDR1'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRDefRBDepartmentDR1')),
		hiddenName : 'SSUSRDefRBDepartmentDR',
		//triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOcnFocus : false,
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTLOCRowID',
		displayField : 'CTLOCDesc',
		store : new Ext.data.JsonStore({
			url : BindingLoc,
			baseParams:{communityid:communityid},
			//autoLoad : true,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CTLOCRowID',
			fields : ['CTLOCRowID', 'CTLOCDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTLOCRowID',
				direction : 'ASC'
			}
		})
	});
	
	var SSUSRGroup = new Ext.BDP.Component.form.ComboBox({
		fieldLabel : '<font color=red>*</font>安全组',
		name : 'SSUSRGroup',
		id : 'BDPGroup',
		hiddenName : 'SSUSRGroup',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPGroup'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPGroup')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('BDPGroup'),
		//triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 0,
		listWidth : 250,
		allowBlank : false,
		valueField : 'SSGRPRowId',
		displayField : 'SSGRPDesc',
		store : new Ext.data.JsonStore({
			//autoLoad : true,
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
	});
	var SSUSRHospitalDR = new Ext.BDP.Component.form.ComboBox({
		fieldLabel : '<font color=red>*</font>医院关联',
		name : 'SSUSRHospitalDR',
		id : 'SSUSRHospital',
		hiddenName : 'SSUSRHospitalDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRHospital'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRHospital')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRHospital'),
		//triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 0,
		listWidth : 250,
		//blankText : '不能为空',
		allowBlank : false,
		valueField : 'HOSPRowId',
		displayField : 'HOSPDesc',
		store : new Ext.data.JsonStore({
			//autoLoad : true,
			url : BindingHospital,
			baseParams:{communityid:communityid},
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
	var defaultLan = tkMakeServerCall("web.DHCBL.CT.SSLanguage","GetDefault");
	var SSUSRCTLANDR = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '默认语言',
		loadByIdParam : 'rowid',
		id:'CTLANDR',
		name: 'SSUSRCTLANDR',
		hiddenName:'SSUSRCTLANDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRCTLANDR'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRCTLANDR')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRCTLANDR'),
		//triggerAction:'all',//query  all
		queryParam:"desc",
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		value:defaultLan,
		//minChars: 1,
		listWidth:250,
		valueField:'CTLANRowId',
		displayField:'CTLANDesc',
		store:new Ext.data.JsonStore({
			//autoLoad: true,
			url:BindingLanguage,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTLANRowId',
			fields:['CTLANRowId','CTLANDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTLANRowId', direction: 'ASC'}
		})
	});
	var SSUSRDateFrom = new Ext.BDP.FunLib.Component.DateField({
		fieldLabel : '<font color=red>*</font>开始日期',
		name : 'SSUSRDateFrom',
		id : 'SSUSRDateFrom',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRDateFrom'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRDateFrom')),
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('SSUSRDateFrom'),
		dataIndex : 'SSUSRDateFrom',	
		blankText : '不能为空',
		allowBlank : false,
		enableKeyEvents : true,
		format : BDPDateFormat,
		listeners : {
			'keyup' : function(field, e) {
				Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
			}
		}
	});
	var SSUSRDateTo = new Ext.BDP.FunLib.Component.DateField({
		fieldLabel : '结束日期',
		name : 'SSUSRDateTo',
		id : 'SSUSRDateTo',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRDateTo'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRDateTo')),
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('SSUSRDateTo'),
		dataIndex : 'SSUSRDateTo',
		format : BDPDateFormat,
		enableKeyEvents : true,
		listeners : {
			'keyup' : function(field, e) {
				Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
			}
		}
	});
	var SSUSRPassword = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '<font color=red>*</font>登录密码',
		id : 'SSUSRPassword',
		name : 'SSUSRPassword',
		inputType : 'password',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPassword'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPassword')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPassword'),
		blankText : '不能为空',
		allowBlank : false,
		dataIndex : 'SSUSRPassword',
		listeners:{
			'blur' : function(){
				if((Ext.getCmp("SSUSRPassword").getValue()=="")&&(Ext.getCmp("SSUSRRowId").getValue()!=""))
				{
					Ext.getCmp("SSUSRPassword").setValue("******");
				}
			},
			'focus' : function(){
				Ext.getCmp("SSUSRPassword").setValue("")
			}
		}
	});
	var SSUSRPin = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '<font color=red>*</font>医嘱签名密码',
		id : 'SSUSRPin',
		name : 'SSUSRPin',
		inputType : 'password',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPin')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPin'),
		dataIndex : 'SSUSRPin',
		blankText : '不能为空',
		allowBlank : false,
		listeners:{
			'blur' : function(){
				if((Ext.getCmp("SSUSRPin").getValue()=="")&&(Ext.getCmp("SSUSRRowId").getValue()!=""))
				{
					Ext.getCmp("SSUSRPin").setValue("******");
				}
			},
			'focus' : function(){
				Ext.getCmp("SSUSRPin").setValue("")
			}
		}
	});
	var SSUSRChangeLocation = new Ext.form.Checkbox({
		boxLabel : '允许用户更改登录科室',
		id : 'SSUSRChangeLocation',
		name : 'SSUSRChangeLocation',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRChangeLocation'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRChangeLocation')),
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('SSUSRChangeLocation'),
		inputValue : true ? 'Y' : 'N',
		checked : true
	});
	var SSUSRActive = new Ext.form.Checkbox({
		boxLabel : '激活',
		id : 'SSUSRActive',
		name : 'SSUSRActive',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRActive'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRActive')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRActive'),
		inputValue : true ? 'Y' : 'N',
		checked : true,
		listeners:{
			'check':function(){
				//Ext.getCmp("CTPCPActiveFlag").setValue(Ext.getCmp("SSUSRActive").getValue())
			}
		}
	});
	var SSUSRPasswordChanged = new Ext.form.Checkbox({
		boxLabel : '下次登录时强制用户改变密码',
		id : 'SSUSRPasswordChanged',
		name : 'SSUSRPasswordChanged',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPasswordChanged'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPasswordChanged')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPasswordChanged'),
		inputValue : true ? 'Y' : 'N'
	});
	var SSUSRAdmitted = new Ext.form.Checkbox({
		boxLabel : '管理员用户',
		id : 'SSUSRAdmitted',
		name : 'SSUSRAdmitted',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRAdmitted'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRAdmitted')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRAdmitted'),
		inputValue : true ? 'Y' : 'N'
	});
	var SSUSRIgnoreCALogon = new Ext.form.Checkbox({
		boxLabel : '忽略CA登录控制',
		id : 'SSUSRIgnoreCALogon',
		name : 'SSUSRIgnoreCALogon',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRIgnoreCALogon'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRIgnoreCALogon')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRIgnoreCALogon'),
		inputValue : true ? 'Y' : 'N'
	});
	var EnablePostLogon = new Ext.form.Checkbox({
		boxLabel : '启用岗位登录',
		id : 'EnablePostLogon',
		name : 'EnablePostLogon',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('EnablePostLogon'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EnablePostLogon')),
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('EnablePostLogon'),
		inputValue : true ? 'Y' : 'N',
		checked : true
	});
	var SSUSRCareProvDR = new Ext.BDP.Component.form.ComboBox({
		//关联医护人员
		hidden:true,    //隐藏
		loadByIdParam : 'rowid',
		id:'CareProvDR',
		name: 'SSUSRCareProvDR',
		hiddenName:'SSUSRCareProvDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRCareProvDR'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRCareProvDR')),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRCareProvDR'),
		//triggerAction:'all',//query
		queryParam:"Desc",
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		//minChars: 0,
		listWidth:250,
		valueField:'CTPCPRowId1',
		displayField:'CTPCPDesc',
		store:new Ext.data.JsonStore({
			//autoLoad: true,
			url:BindingCTCareProv,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTPCPRowId1',
			fields:['CTPCPRowId1','CTPCPDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTPCPRowId1', direction: 'ASC'}
		})
	});
	//2019-06-25
	var SSUSRFreeText1 = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '身份证号',
		id : 'SSUSRFreeText1',
		name : 'SSUSRFreeText1',
		maxLength:18,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRFreeText1'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRFreeText1')),
		dataIndex : 'SSUSRFreeText1',
		validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
			var flag = tkMakeServerCall("web.DHCBL.BDP.FunLib", "IsValidIdNum", thisText); 
			if (flag == "1") { // 当后台返回数据位"1"时转换为相应的布尔值
				return true;
			} else {
				return false;
			}
		},
		invalidText : '身份证号校验失败，请重新确认'
	});
	var CTSEX_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	
	var SSUSRFreeText2 = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '性别',
		loadByIdParam : 'rowid',
		id:'SSUSRFreeText2F',
		name: 'SSUSRFreeText2',
		hiddenName:'SSUSRFreeText2',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRFreeText2'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRFreeText2')),
		queryParam:"desc",
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTSEXRowId',
		displayField:'CTSEXDesc',
		store:new Ext.data.JsonStore({
			url:CTSEX_QUERY_ACTION_URL,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTSEXRowId',
			fields:['CTSEXRowId','CTSEXDesc']
		})
	});
	var SSUSRFreeText3 = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '国家医保代码',
		id : 'SSUSRFreeText3',
		name : 'SSUSRFreeText3',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRFreeText3'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRFreeText3')),
		dataIndex : 'SSUSRFreeText3',
		listeners : {
			render : function(field) {  
				Ext.QuickTips.init();  
				Ext.QuickTips.register({  
					target : field.el,  
					text : '医保15项贯标工作，医保系统工作人员代码/医保医师代码/医保护士代码/医保药师代码'
				})  
			}  
		}
	});
	
	var SSUSRMobile = new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '手机号',
		id : 'SSUSRMobile',
		name : 'SSUSRMobile',
		maxLength:11,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRMobile'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRMobile')),
		dataIndex : 'SSUSRMobile'
	});
	
	var SSUSRPager = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '办公电话',
		id : 'SSUSRPager',
		name : 'SSUSRPager',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPager'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPager')),
		dataIndex : 'SSUSRPager'
	});
	
	var SSUSREmail = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '邮箱',
		id : 'SSUSREmail',
		name : 'SSUSREmail',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREmail'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREmail')),
		dataIndex : 'SSUSREmail'
	});
	
	var SSUSRHOSPersonDR = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '人员',
		loadByIdParam : 'rowid',
		id:'HOSPersonDR',
		name: 'SSUSRHOSPersonDR',
		hiddenName:'SSUSRHOSPersonDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRHOSPersonDR'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRHOSPersonDR')),
		queryParam:"desc",
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'ID',
		displayField:'PAName',
		store:new Ext.data.JsonStore({
			url:BindingPerson,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'ID',
			fields:['ID','PAName']
		})
	});
	var SSUSRSeqNo = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '排序号',
		id : 'SSUSRSeqNo',
		name : 'SSUSRSeqNo',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRSeqNo'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRSeqNo')),
		dataIndex : 'SSUSRSeqNo',
		regex: /^[0-9]+?$/,
		regexText : '请输入非负整数（正整数 + 0）'
	});
	var SSUSRPYCode = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '拼音码',
		id : 'SSUSRPYCode',
		name : 'SSUSRPYCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPYCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPYCode')),
		dataIndex : 'SSUSRPYCode'
	});
	var SSUSRWBCode = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '五笔码',
		id : 'SSUSRWBCode',
		name : 'SSUSRWBCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRWBCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRWBCode')),
		dataIndex : 'SSUSRWBCode'
	});
	var SSUSRMark = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '备注',
		id : 'SSUSRMark',
		name : 'SSUSRMark',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRMark'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRMark')),
		dataIndex : 'SSUSRMark'
	});

	
	/** ---------医护人员维护表单内容部分------------* */
	var CTPCPRowId1 = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPRowId1
		// 表单主Rowid
		fieldLabel : 'CTPCPRowId1',
		hideLabel : 'True',
		hidden : true,
		id : 'CTPCPRowId1',
		name : 'CTPCPRowId1'
	});

	var CTPCPCode = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPCode 工号
		fieldLabel : "<span style='color:red;'>*</span>工号",
		name : 'CTPCPCode',
		id : 'CTPCPCode',
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPCode')),
		//readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPCode'),
		blankText : '不能为空',
		allowBlank : false,
		dataIndex : 'CTPCPCode',
		listeners:{
			'blur' : function(){
				//syncCTPCPCode()
				
			}
		}
	});
	var CTPCPOtherName = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPOtherName
		// 拼音检索码
		fieldLabel : "<span style='color:red;'>*</span>拼音检索码",
		name : 'CTPCPOtherName',
		id : 'CTPCPOtherName',
		blankText : '不能为空',
		allowBlank : false,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPOtherName'),
		dataIndex : 'CTPCPOtherName'
	});
	var CTPCPUnit = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPUnit 专业资格证书号
		fieldLabel : '专业资格证书号',
		name : 'CTPCPUnit',
		id : 'CTPCPUnit',
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit'),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit')),
		dataIndex : 'CTPCPUnit'
	});
	var CTPCPCarPrvTpDR = new Ext.BDP.Component.form.ComboBox({
		// 医护人员类型 combo
		fieldLabel : "<span style='color:red;'>*</span>医护人员类型",
		id:'CarPrvTpDR',
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CarPrvTpDR'),
		blankText : '不能为空',
		allowBlank : false,
		name : 'CTPCPCarPrvTpDR',
		hiddenName : 'CTPCPCarPrvTpDR',// 不能与id相同
		// onTriggerClick : Ext.emptyFn,
		forceSelection : true,
		//triggerAction : 'all',
		selectOnFocus : false,
		// hidden : true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CarPrvTpDR'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CarPrvTpDR')),
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 0,
		listWidth : 250,
		valueField : 'CTCPTRowId',
		displayField : 'CTCPTDesc',
		store : new Ext.data.JsonStore({
			url : BindingCarPrvTp,
			root : 'data',
			totalProperty : 'total',
			//autoLoad : true,
			idProperty : 'CTCPTRowId',
			fields : ['CTCPTRowId', 'CTCPTDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTCPTRowId',
				direction : 'ASC'
			}
		})

	});

	

	var CTPCPDateActiveFrom = new Ext.BDP.FunLib.Component.DateField({ // ----------CTPCPDateActiveFrom
		// 开始日期
		fieldLabel : "<span style='color:red;'>*</span>开始日期",
		id : 'CTPCPDateActiveFrom',
		hideLabel : true,
		hidden : true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveFrom'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveFrom')),
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveFrom'),
		//allowBlank : false,
		name : 'CTPCPDateActiveFrom',
		format : BDPDateFormat,
		enableKeyEvents : true,
		listeners : {
			'keyup' : function(field, e) {
				Ext.BDP.FunLib.Component.GetCurrentDate(field, e);
			}
		}
			// editable:false
	});
	var CTPCPSurgeon = new Ext.form.Checkbox({ // ----------CTPCPSurgeon 外科医生
		boxLabel : '外科医生',
		id : 'CTPCPSurgeon',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon'),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon')),
		name : 'CTPCPSurgeon',
		dataIndex : 'CTPCPSurgeon',
		inputValue : true ? 'Y' : 'N'
	});
	var CTPCPHICApproved = new Ext.form.Checkbox({ // ----------CTPCPAnaesthetist
		// 毒麻处方权
		boxLabel : '毒麻处方权',
		name : 'CTPCPHICApproved',
		id : 'CTPCPHICApproved',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApproved'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApproved')),
		dataIndex : 'CTPCPHICApproved',
		inputValue : true ? 'Y' : 'N',
		listeners : {
			'check' : function() {
				if (!Ext.getCmp("CTPCPHICApproved").getValue()) {
					Ext.getCmp("CTPCPHICApprovedButton").setDisabled(true);
				} else {
					Ext.getCmp("CTPCPHICApprovedButton").setDisabled(false);
				}
			}
		}
	});

	/*
	 * var myImage = new Ext.BoxComponent({ autoEl: { tag: 'img', src:
	 * Ext.BDP.FunLib.Path.URL_Img+'test.jpg' } });
	 */

	var CTPCPHICApprovedButton = new Ext.Button({ // ----------CTPCPAnaesthetist
		// 毒麻处方权
		text : '查看证书',
		// fieldLabel: '查看证书',
		iconCls : 'icon-search',
		name : 'CTPCPHICApprovedButton',
		id : 'CTPCPHICApprovedButton',
		hidden : true,
		// disabled :Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApprovedButton'),
		handler : function ShowPic() {
			win_uploadImage.setTitle("毒麻处方权资格证书-"
					+ Ext.getCmp("CTPCPDesc").getValue() + "-"
					+ Ext.getCmp("CTPCPCode").getValue());
			win_uploadImage.imageIndexName = 'Pic1';
			win_uploadImage.show();
			var CareID = Ext.getCmp("CTPCPCode").getValue() + "mf";
			// var image = Ext.get('imageBrowse').dom
			ShowPicByPatientID(CareID, 'imageBrowse');

			/*
			 * var image = Ext.get('imageBrowse').dom; var SignSrc =
			 * Ext.BLANK_IMAGE_URL; if
			 * (IsExistsFile("ftp://10.160.16.112:21/CarePhoto/"+CareID+".jpg")){
			 * SignSrc = "ftp://10.160.16.112:21/CarePhoto/"+CareID +".jpg"; }
			 * else { SignSrc = "ftp://10.160.16.112:21/CarePhoto/blank.gif1"; }
			 * image.src = SignSrc;
			 */

			Ext.getCmp("HidenPicRowId1").reset();
			Ext.getCmp("HidenPicRowId1").setValue(CareID);
		}
	});

	// 上传图片类型
	var img_reg = /\.([jJ][pP][gG]){1}$|\.([jJ][pP][eE][gG]){1}$|\.([gG][iI][fF]){1}$|\.([pP][nN][gG]){1}$|\.([bB][mM][pP]){1}$/;

	var HidenPicRowId1 = new Ext.BDP.FunLib.Component.TextField({
				fieldLabel : 'HidenPicRowId1',
				hideLabel : 'True',
				hidden : true,
				id : 'HidenPicRowId1',
				name : 'HidenPicRowId1'
			});

	var win_uploadImage = new Ext.Window({
		layout : 'fit',
		width : 620,
		closeAction : 'hide',
		height : 370,
		resizable : false,
		shadow : false,
		modal : true,
		closable : true,
		bodyStyle : 'padding: 5 5 5 5',
		animCollapse : true,
		imageIndexName : '',
		items : [{
			xtype : 'form',
			id : 'image-upload-form',
			frame : true,
			border : false,
			isAdd : false,
			enctype : 'multipart/form-data',
			fileUpload : true,
			layout : 'form',
			items : [HidenPicRowId1, {
						id : 'file-idx',
						name : 'file',
						inputType : "file",
						fieldLabel : '上传新图片',
						xtype : 'textfield',
						blankText : '上传图片不能为空',
						anchor : '100%'
					}, {
						xtype : 'panel',
						id : 'imageBrowse',
						html : "<p style='text-align:center'><img src='ftp://10.160.16.112:21/CarePhoto/blank.gif' width=420 height=210></p>"
					}/*
						 * ,{ xtype : 'box', id : 'browseImage', fieldLabel :
						 * "签名图片", autoEl : { width : 420, height : 210, tag :
						 * 'img', // type : 'image', src : "", style :
						 * 'filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale);',
						 * complete : 'off', id : 'imageBrowse' } }
						 */
			],
			listeners : {
				'render' : function(f) {
					//
					this.form.findField('file-idx').on('render', function() {
						// 通過change事件,图片也动态跟踪选择的图片变化
						Ext.get('file-idx').on('change',
								function(field, newValue, oldValue) {
									// 得到选择的图片路径
									var url = 'file://'+ Ext.get('file-idx').dom.value;
									// alert("url = " + url);
									// 是否是规定的图片类型
									if (img_reg.test(url)) {
										if (Ext.isIE) {
											var obj = document.getElementById('imageBrowse');
											obj.innerHTML = "<p style='text-align:center'><img SRC='"
													+ url
													+ "' width=420 height=210 ></p>"
											// var image =Ext.get('imageBrowse').dom;
											// image.src =Ext.BLANK_IMAGE_URL;// 覆盖原来的图片

											// image.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src= url;
										}
										else {
											Ext.get('imageBrowse').dom.src = Ext.get('file-idx').dom.files.item(0).getAsDataURL();
										}
									}
								}, this);
					}, this);
				}
			},
			buttons : [{
						text : '关闭',
						handler : function() {
							win_uploadImage.hide();
						}
					}, {
						text : '上传',
						handler : function() {
							var furl = "";
							furl = Ext.getCmp('image-upload-form').form.findField('file').getValue();
							var type = furl.substring(furl.length - 3).toLowerCase();
							if (furl == "" || furl == null) {
								aler('路径不能为空！');
								return;
							}
							if (type != 'jpg' && type != 'bmp' && type != 'gif'&& type != 'png') {
								alert('仅支持jpg、bmp、gif、png格式的图片');
								return;
							}

							var falg = ChangeStrToPhoto(Ext.getCmp("HidenPicRowId1").getValue(), furl);

							if (falg == "1") {
								Ext.Msg.show({
									title : '提示',
									msg : '上传成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK
								});
							} else {
								Ext.Msg.show({
									title : '提示',
									msg : '上传失败!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
							}

							/*
							 * Ext.getCmp('image-upload-form').form.submit({
							 * clienValidation:true, waitMsg:'正在上传请稍候',
							 * waitTitle:'提示', url:'UploadPic', method:'POST',
							 * success:function(form,action){ var picName =
							 * action.result.data;
							 * if(win_uploadImage.imageIndexName!=''){
							 * Ext.getCmp(win_uploadImage.imageIndexName).setValue(picName); }
							 * //reset form
							 * Ext.getCmp('image-upload-form').form.el.dom.reset();
							 * if (Ext.isIE) { var i_image =
							 * Ext.get('imageBrowse').dom; i_image.src =
							 * Ext.BLANK_IMAGE_URL;
							 * i_image.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src =
							 * Ext.BLANK_IMAGE_URL; }else{
							 * Ext.get('imageBrowse').dom.src =
							 * Ext.BLANK_IMAGE_URL; }
							 * 
							 * win_uploadImage.hide(); },
							 * failure:function(form,action){
							 * Ext.MessageBox.show({title: '失败',msg:
							 * '上传失败!',buttons: Ext.MessageBox.OK,icon:
							 * Ext.MessageBox.ERROR}); } })
							 */
						}
					}]
		}]
	});

	var CTPCPHICApprovedForm = {
		baseCls : 'x-plain',
		layout : "column",
		items : [{
					baseCls : 'x-plain',
					columnWidth : .6,
					layout : "form",
					items : [CTPCPHICApproved]
				}, {
					baseCls : 'x-plain',
					columnWidth : .4,
					layout : "form",
					items : [CTPCPHICApprovedButton]
				}]
	};

	/*var CTPCPActiveFlag = new Ext.form.Checkbox({
		// 激活
		boxLabel : '激活',
		id : 'CTPCPActiveFlag',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPActiveFlag'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPActiveFlag')),
		name : 'CTPCPActiveFlag',
		dataIndex : 'CTPCPActiveFlag',
		inputValue : true ? 'Y' : 'N',
		checked : true
	});*/
	var CTPCPDesc = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPDesc 姓名
		fieldLabel : "<span style='color:red;'>*</span>姓名",
		name : 'CTPCPDesc',
		id : 'CTPCPDesc',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDesc'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDesc')),
		blankText : '不能为空',
		allowBlank : false,
		dataIndex : 'CTPCPDesc',
		listeners : {
			'blur' : function(){
				Ext.getCmp("CTPCPOtherName").setValue(Pinyin.GetJPU(Ext.getCmp("CTPCPDesc").getValue()))
			}
		}
	});
	var CTPCPId = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPId 标识码
		fieldLabel : '标识码',
		name : 'CTPCPId',
		id : 'CTPCPId',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPId'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPId')),
		dataIndex : 'CTPCPId'
	});
	var CTPCPTextOne = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTextOne 执业证书编码
		fieldLabel : '执业证书编码',
		name : 'CTPCPTextOne',
		id : 'CTPCPTextOne',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextOne'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextOne')),
		dataIndex : 'CTPCPTextOne'
	});
	var CTPCPTextTwo = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTextTwo Text2
		fieldLabel : 'Text2',
		name : 'CTPCPTextTwo',
		id : 'CTPCPTextTwo',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextTwo'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTextTwo')),
		dataIndex : 'CTPCPTextTwo'
	});
	var CTPCPSpecDR = new Ext.BDP.Component.form.ComboBox({
		// 医生专长
		fieldLabel : '医生专长',
		xtype : 'combo',
		name : 'CTPCPSpecDR',
		id:'SpecDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SpecDR'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SpecDR')),
		hiddenName : 'CTPCPSpecDR',// 不能与id相同
		//triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTSPCRowId',
		displayField : 'CTSPCDesc',
		store : new Ext.data.JsonStore({
			//autoLoad : true,
			url : BindingSpec,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CTSPCRowId',
			fields : ['CTSPCRowId', 'CTSPCDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTSPCRowId',
				direction : 'ASC'
			}
		})
	});
	var CTPCPAnaesthetist = new Ext.form.Checkbox({ // ----------CTPCPAnaesthetist
		// 麻醉师
		boxLabel : '麻醉师',
		name : 'CTPCPAnaesthetist',
		id : 'CTPCPAnaesthetist',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPAnaesthetist'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPAnaesthetist')),
		dataIndex : 'CTPCPAnaesthetist',
		inputValue : true ? 'Y' : 'N'
	});
	var CTPCPSpecialistYN = new Ext.form.Checkbox({ // ----------CTPCPAnaesthetist
		// 可以出特需号
		boxLabel : '可以出特需号',
		name : 'CTPCPSpecialistYN',
		id : 'CTPCPSpecialistYN',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecialistYN'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecialistYN')),
		dataIndex : 'CTPCPSpecialistYN',
		inputValue : true ? 'Y' : 'N'
	});
	var CTPCPDateActiveTo = new Ext.BDP.FunLib.Component.DateField({ // ----------CTPCPDateActiveTo
		// 结束日期
		fieldLabel : '结束日期',
		name : 'CTPCPDateActiveTo',
		id : 'CTPCPDateActiveTo',
		hideLabel : true,
		hidden : true,
		enableKeyEvents : true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveTo'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDateActiveTo')),
		// editable:false,
		format : BDPDateFormat,
		listeners : {
			'keyup' : function(field, e) {
				Ext.BDP.FunLib.Component.GetCurrentDate(field, e);
			}
		}
	});
	/*var CTPCPTelO = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '办公电话',
		name : 'CTPCPTelO',
		id : 'CTPCPTelO',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelO'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelO')),
		dataIndex : 'CTPCPTelO'
	});
	var CTPCPTelH = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '家庭电话',
		name : 'CTPCPTelH',
		id : 'CTPCPTelH',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelH'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelH')),
		dataIndex : 'CTPCPTelH'
	});
	var CTPCPTelOExt = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '电话分机',
		name : 'CTPCPTelOExt',
		id : 'CTPCPTelOExt',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelOExt'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelOExt')),
		dataIndex : 'CTPCPTelOExt'
	});
	var CTPCPMobilePhone = new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '手机号',
		name : 'CTPCPMobilePhone',
		id : 'CTPCPMobilePhone',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPMobilePhone'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPMobilePhone')),
		dataIndex : 'CTPCPMobilePhone'
	});
	var CTPCPEmail = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '邮箱',
		name : 'CTPCPEmail',
		id : 'CTPCPEmail',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPEmail'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPEmail')),
		dataIndex : 'CTPCPEmail'
	});
	var CTPCPFax = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '传真',
		name : 'CTPCPFax',
		id : 'CTPCPFax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPFax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPFax')),
		dataIndex : 'CTPCPFax'
	});*/
	var CTPCPTitleDR = new Ext.BDP.Component.form.ComboBox({
		fieldLabel : '医护人员职称',
		//xtype : 'combo',
		name : 'CTPCPTitleDR',
		id : 'TitleDR',
		hiddenName : 'CTPCPTitleDR',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('TitleDR'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TitleDR')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('TitleDR'),
		//triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 0,
		listWidth : 250,
		valueField : 'TTLRowId',
		displayField : 'TTLDesc',
		store : new Ext.data.JsonStore({
			//autoLoad : true,
			url : BindingTitle,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'TTLRowId',
			fields : ['TTLRowId', 'TTLDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'TTLRowId',
				direction : 'ASC'
			}
		})
	});
	
	 var CTPCPMentalFlag = new Ext.BDP.FunLib.Component.Checkbox({
        boxLabel: '精神类药物处方权',
        name: 'CTPCPMentalFlag',
        id: 'CTPCPMentalFlag',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPMentalFlag'),
        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPMentalFlag')),
        dataIndex:'CTPCPMentalFlag',
        inputValue : true?'Y':'N'
    });
	/** ---------其他登录科室维护表单内容部分------------* */
	 var resetOtherLogonLoc=function()
	 {
				Ext.getCmp("comboxOtherLogonLoc").reset();
				Ext.getCmp("comboGroup").reset();
				Ext.getCmp("OTHLLStartDate").setValue(TodayDate);
				Ext.getCmp("OTHLLEndDate").reset();
				Ext.getCmp("SyncRBFlag").setValue(true)
				
	}
	var winOtherLogonLoc=new Ext.form.FormPanel({
		id:'winOtherLogonLoc',
		region:'north',
		height:150,
		labelAlign : 'right',
		items:[{
        	border:false,
      	 	items:[{ 
    		layout : "column",  
    		xtype:'fieldset',
			title:'其他登录科室',
    		items : [{
      				 columnWidth : .33,  
					 defaults: {anchor:'96%',msgTarget:'under'},
      				 layout : "form",  
      				 items : [{
							fieldLabel: '<font color=red>*</font>登录科室',	
							xtype:'bdpcombo',
							id: 'comboxOtherLogonLoc',
							loadByIdParam : 'rowid',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('comboxOtherLogonLoc'),
							queryParam : "desc",
							forceSelection: true,
							selectOcnFocus:false,
							mode:'remote',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							listWidth:250,
							valueField:'CTLOCRowID',
							displayField:'CTLOCDesc',
							store:new Ext.data.JsonStore({
								//autoLoad: true,
								url:BindingLoc,
								baseParams:{communityid:communityid},
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTLOCRowID',
								fields:['CTLOCRowID','CTLOCDesc']
							})
						},{
	          				fieldLabel: '<font color=red>*</font>开始日期',
							xtype:'datefield',
							width:120,
							id:'OTHLLStartDate',
				    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OTHLLStartDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OTHLLStartDate')),
			    			name: 'OTHLLStartDate',
			    			format: BDPDateFormat,
			    			enableKeyEvents : true,
							listeners : { 
								'keyup' : function(field, e){ 
									Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
								}
							}
						},{
							xtype : 'checkbox',
							boxLabel : '同步到资源表',
							id : 'SyncRBFlag',
							name : 'SyncRBFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SyncRBFlag'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SyncRBFlag')),
							inputValue : true?'Y':'N',
							checked : true,
							listeners:{
         						render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '用户关联了医护人员时，新增/修改/停止其他登录科室数据时才能同时新增到资源表'  
				                    })  
				                }  
				            
                    		}	
							
	
		            	 }]
			        }, {
			           columnWidth : .33,
					   defaults: {anchor:'96%',msgTarget:'under'},
			           layout : "form",
			           items : [{
							fieldLabel: '<font color=red>*</font>安全组',	
							xtype:'bdpcombo',
							id: 'comboGroup',
							loadByIdParam : 'rowid',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('comboGroup'),
							forceSelection: true,
							selectOcnFocus:false,
							queryParam:"desc",
							mode:'remote',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							listWidth:250,
							valueField:'SSGRPRowId',
							displayField:'SSGRPDesc',
							store:new Ext.data.JsonStore({
								//autoLoad: true,
								url:BindingGroup,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'SSGRPRowId',
								fields:['SSGRPRowId','SSGRPDesc']
							})
						},{
	             			fieldLabel: '结束日期',
	             			width:120,
							xtype:'datefield',
				    		id:'OTHLLEndDate',
				    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('OTHLLEndDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OTHLLEndDate')),
			    			name: 'OTHLLEndDate',
			    			format: BDPDateFormat,
			    			enableKeyEvents : true,
							listeners : { 
								'keyup' : function(field, e){ 
									Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
								}
							}
		            	 }]
			          },{
	      				 columnWidth : .33,  
						 defaults: {anchor:'96%',msgTarget:'under'},
	      				 layout : "form",  
	      				 items : [{
		      				 		xtype:'displayfield',
		      				 		fieldLabel:'默认登录科室',
									id: 'OtherDefaultDept'
	      				 		},{
		      				 		xtype:'displayfield',
		      				 		fieldLabel:'默认安全组',
									id: 'OtherBDPGroup'
	      				 		},{
		      				 		xtype:'textfield',
		      				 		fieldLabel:'默认登录科室Id',
									id: 'OtherDefaultDeptDr',
									hideLabel:true,
									hidden:true
	      				 		},{
		      				 		xtype:'textfield',
		      				 		fieldLabel:'默认安全组Id',
									id: 'OtherBDPGroupDr',
									hideLabel:true,
									hidden:true
								},{
									xtype: 'textfield',
									id: 'hidden_SSUSRRowId',
									hidden : true
								},{
									xtype: 'textfield',
									id: 'hidden_OTHLLRowId',
									hidden : true
	      				 		}]
	      				
				          }]
      				 	}]
       				}],
			buttonAlign:'center', 
	        buttons:[{  
	        		id:'btnOtherLogonLoc',
	        		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnOtherLogonLoc'),
	                text:'添加',
	                iconCls : 'icon-add',
	                width: 60,
	                handler: function (){
	                	
	                	var comboxOtherLogonLoc = Ext.getCmp("comboxOtherLogonLoc").getValue();
						
						if (comboxOtherLogonLoc== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '登录科室不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			      			
			   			 	}
						
	                	var comboGroup = Ext.getCmp("comboGroup").getValue();
	                	if (comboGroup== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '安全组不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			      			
			   			 	}
						//判断科室和安全组是否是同一个医院	20200618	likefan
						var HospDifferentFlag=tkMakeServerCall("web.DHCBL.CT.SSUser","IfHospDifferent",comboxOtherLogonLoc,comboGroup);
						if (HospDifferentFlag==1) {
							Ext.Msg.show({ title : '提示', msg : '登录科室和安全组必须在同一医院组!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
							return;
						}
							
	                	var startDate = Ext.getCmp("OTHLLStartDate").getValue();
	                	var endDate = Ext.getCmp("OTHLLEndDate").getValue();
	                	if (startDate== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '开始日期不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			      			
			   			 	}
				    	 if (startDate!= "" && endDate!= "") {
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
		   			 	
		   			 	if(comboxOtherLogonLoc==Ext.getCmp("OtherDefaultDeptDr").getValue() && comboGroup==Ext.getCmp("OtherBDPGroupDr").getValue() ){
							Ext.Msg.show({
								title:'提示',
								msg:'数据与默认登录科室和安全组重复!',
								minWidth:200,
								icon:Ext.Msg.ERROR,
								buttons:Ext.Msg.OK
							});
							return;
						}
							
		   			 	if (Ext.getCmp("SSUSRRowId").getValue()!="")
		   			 	{
		   			 		var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue()
		   			 		var locstr=""+"^"+comboxOtherLogonLoc+"^"+comboGroup+"^"+Ext.getCmp("OTHLLStartDate").getRawValue()+"^"+Ext.getCmp("OTHLLEndDate").getRawValue()+"^"+(Ext.getCmp('SyncRBFlag').getValue()==true?"Y":"N")
        					var savestr = tkMakeServerCall("web.DHCBL.CT.SSUserOtherLogonLoc","SaveAll",SSUSRRowId,locstr);
        					var jsonData = Ext.util.JSON.decode(savestr);
        					if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '保存成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
									}
								});
							} else {
								var errorMsg = '';
								if (jsonData.errorinfo) {
									errorMsg = '<br />错误信息:'+ jsonData.errorinfo
								}
								Ext.Msg.show({
									title : '提示',
									msg : '保存失败!' + errorMsg,
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
							}
						}
						else
						{
							
		   			 	 	for (var i = 0; i < dsOtherLogonLoc.getCount(); i++) {
								var record = dsOtherLogonLoc.getAt(i);
								var OTHLLCTLOCDR = record.get('OTHLLCTLOCDR');
								var OTHLLUserGroupDR = record.get('OTHLLUserGroupDR');
								if(comboxOtherLogonLoc==OTHLLCTLOCDR && comboGroup==OTHLLUserGroupDR){
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
							var _record = new Ext.data.Record({
				    	 		'OTHLLRowId':'',
				    	 		'CTLOCDesc':Ext.getCmp('comboxOtherLogonLoc').getRawValue(),
				    	 		'SSGRPDesc':Ext.getCmp('comboGroup').getRawValue(),
				    	 		'OTHLLCTLOCDR':Ext.getCmp('comboxOtherLogonLoc').getValue(),
				    	 		'OTHLLUserGroupDR':Ext.getCmp('comboGroup').getValue(),
				    	 		'OTHLLStartDate':Ext.getCmp('OTHLLStartDate').getRawValue(),
				    	 		'OTHLLEndDate':Ext.getCmp('OTHLLEndDate').getRawValue(),
				    	 		'SyncRBFlag':(Ext.getCmp('SyncRBFlag').getValue()==true?"Y":"N")
				    	 	});
				    	 	gridOtherLogonLoc.stopEditing();
				    	 	dsOtherLogonLoc.insert(0,_record); 	   
				    	 	
						}
						resetOtherLogonLoc()
						
					}
	     	}, { 
	            	id:'update_btn2',
	            	text:'修改',
	            	width: 60,
	            	iconCls : 'icon-update',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn2'),
	                handler: function (){ 
	                	if(gridOtherLogonLoc.selModel.hasSelection()){
							
							//多选修改返回提示框	2021-04-12	likefan
							var gsm = gridOtherLogonLoc.getSelectionModel();//获取选择列
							var rows = gsm.getSelections();//根据选择列获取到所有的行
							if(rows.length!=1){
								Ext.Msg.show({
			        					title : '提示',
										msg : '请选择一条数据修改!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
								});
								return;
							}
	                		
	                		var comboxOtherLogonLoc = Ext.getCmp("comboxOtherLogonLoc").getValue();
							
							if (comboxOtherLogonLoc== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '登录科室不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			      			
			   			 	}
							
	                		var comboGroup = Ext.getCmp("comboGroup").getValue();
	                		if (comboGroup== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '安全组不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			      			
			   			 	}
							//判断科室和安全组是否是同一个医院	20200618	likefan
							var HospDifferentFlag=tkMakeServerCall("web.DHCBL.CT.SSUser","IfHospDifferent",comboxOtherLogonLoc,comboGroup);
							if (HospDifferentFlag==1) {
								Ext.Msg.show({ title : '提示', msg : '登录科室和安全组必须在同一医院组!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
								return;
							}
							
	                		var startDate = Ext.getCmp("OTHLLStartDate").getValue();
	                		var endDate = Ext.getCmp("OTHLLEndDate").getValue();
				        	 if (startDate!= "" && endDate!= "") {
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
			   			 	if(comboxOtherLogonLoc==Ext.getCmp("OtherDefaultDeptDr").getValue() && comboGroup==Ext.getCmp("OtherBDPGroupDr").getValue() ){
								Ext.Msg.show({
									title:'提示',
									msg:'数据与默认登录科室和安全组重复!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
								return;
							}
							
			   			 	if (Ext.getCmp("SSUSRRowId").getValue()!="")
			   			 	{
			   			 		var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue()
			   			 		var OTHLLRowId = gridOtherLogonLoc.getSelectionModel().getSelections()[0].get('OTHLLRowId');
	        					var locstr=OTHLLRowId+"^"+comboxOtherLogonLoc+"^"+comboGroup+"^"+Ext.getCmp("OTHLLStartDate").getRawValue()+"^"+Ext.getCmp("OTHLLEndDate").getRawValue()+"^"+(Ext.getCmp('SyncRBFlag').getValue()==true?"Y":"N")
	        					var savestr = tkMakeServerCall("web.DHCBL.CT.SSUserOtherLogonLoc","SaveAll",SSUSRRowId,locstr);
	        					var jsonData = Ext.util.JSON.decode(savestr);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
										}
									});
								} else {
									var errorMsg = '';
									if (jsonData.errorinfo) {
										errorMsg = '<br />错误信息:'+ jsonData.errorinfo
									}
									Ext.Msg.show({
										title : '提示',
										msg : '保存失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
			   			 		
			   			 	}
			   			 	else
			   			 	{
			   			 		
			   			 		/*var selectId = gridOtherLogonLoc.getSelectionModel().getSelections()[0].get('Id');
			   			 		for (var i = 0; i < dsOtherLogonLoc.getCount(); i++) {
									var record = dsOtherLogonLoc.getAt(i);
									var OTHLLCTLOCDR = record.get('OTHLLCTLOCDR');
									var OTHLLUserGroupDR = record.get('OTHLLUserGroupDR');
									var OTHLLRowId = record.get('OTHLLRowId');
									if(selectId!=""){if(selectId==Id) continue;}
									if(selectOTHLLRowId!=""){if(selectOTHLLRowId==OTHLLRowId) continue;}
									if(comboxOtherLogonLoc==OTHLLCTLOCDR && comboGroup==OTHLLUserGroupDR){
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
								*/
					    	 	var myrecord = gridOtherLogonLoc.getSelectionModel().getSelected();
					    	 	myrecord.set('CTLOCDesc',Ext.getCmp('comboxOtherLogonLoc').getRawValue());
					    	 	myrecord.set('SSGRPDesc',Ext.getCmp('comboGroup').getRawValue());
					    	 	myrecord.set('OTHLLCTLOCDR',Ext.getCmp('comboxOtherLogonLoc').getValue());
					    	 	myrecord.set('OTHLLUserGroupDR',Ext.getCmp('comboGroup').getValue());
					    	 	myrecord.set('OTHLLStartDate',Ext.getCmp('OTHLLStartDate').getRawValue());
					    	 	myrecord.set('OTHLLEndDate',Ext.getCmp('OTHLLEndDate').getRawValue());
					    	 	myrecord.set('SyncRBFlag',(Ext.getCmp('SyncRBFlag').getValue()==true?"Y":"N"));
			   			 		
			   			 	}
				    	 	
				    	 	resetOtherLogonLoc()
						}else{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择需要修改的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
						}
	              }
	            }, {  
	            	id:'del_btn2',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn2'),
	                text:'删除',
	                iconCls : 'icon-delete',
	                width: 60,
	                handler: function (){ 
	                	if(gridOtherLogonLoc.selModel.hasSelection()){
							Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
								if(btn=='yes'){
									Ext.MessageBox.wait('数据删除中,请稍候...','提示');
									var gsm = gridOtherLogonLoc.getSelectionModel();//获取选择列
									var rows = gsm.getSelections();//根据选择列获取到所有的行
									if(rows[0].get('OTHLLRowId')==""){
										dsOtherLogonLoc.remove(gsm.getSelections());
										Ext.Msg.show({
											title:'提示',
											msg:'数据删除成功!',
											icon:Ext.Msg.INFO,
											buttons:Ext.Msg.OK,
											fn:function(btn){
												resetOtherLogonLoc()
												
											}
										});
									}else{
										if(rows.length==1){
											//选择单条删除
											Ext.Ajax.request({
												url:DELETE_OtherLogonLoc_URL,
												method:'POST',
												params:{
														'id':rows[0].get('OTHLLRowId')
												},
												callback:function(options, success, response){
													Ext.MessageBox.hide();
													if(success){
														var jsonData = Ext.util.JSON.decode(response.responseText);
														if(jsonData.success == 'true'){
															Ext.Msg.show({
																title:'提示',
																msg:'数据删除成功!',
																icon:Ext.Msg.INFO,
																buttons:Ext.Msg.OK,
																fn:function(btn){
																	resetOtherLogonLoc()
																	/*var startIndex = gridOtherLogonLoc.getBottomToolbar().cursor;
																	gridOtherLogonLoc.getStore().load({params:{start:startIndex, limit:pagesize}});*/
																	Ext.BDP.FunLib.DelForTruePage(gridOtherLogonLoc,pageSize_LogonLoc);
																}
															});
														}
														else{
															var errorMsg ='';
															if(jsonData.info){
																errorMsg='<br />错误信息:'+jsonData.info
															}
															Ext.Msg.show({
																title:'提示',
																msg:'数据删除失败!'+errorMsg,
																minWidth:200,
																icon:Ext.Msg.ERROR,
																buttons:Ext.Msg.OK
															});
														}
													}
													else{
														Ext.Msg.show({
															title:'提示',
															msg:'异步通讯失败,请检查网络连接!',
															icon:Ext.Msg.ERROR,
															buttons:Ext.Msg.OK
														});
													}
												}
											},this);
											
										}else{
											var str1="";
											for(var i=0;i<rows.length;i++){
												if (str1!=""){
													str1=str1+"^"
												}
												str1+=rows[i].get('OTHLLRowId');
											}
											//alert(str1);
											var delre=tkMakeServerCall("web.DHCBL.CT.SSUserOtherLogonLoc","DeleteSelections",str1);
											if (delre==1){
												Ext.MessageBox.hide();
												Ext.Msg.show({
													title:'提示',
													msg:'数据删除成功!',
													icon:Ext.Msg.INFO,
													buttons:Ext.Msg.OK,
													fn:function(btn){
														resetOtherLogonLoc();
														Ext.BDP.FunLib.DelForTruePage(gridOtherLogonLoc,pageSize_LogonLoc);
													}
												});
												gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
											}else{
												Ext.Msg.show({
														title:'提示',
														msg:'数据删除失败!',
														minWidth:200,
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											}
										}
									}
								}
							},this);
						}
						else{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择需要删除的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
						}
	              	}
	            },{				
	            	id:'btnRefresh2',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh2'),
					text:'重置',
					iconCls : 'icon-refresh',
					width:60,
					handler:function()
					{
						resetOtherLogonLoc()
						if(win.title=='注册新用户'){
							gridOtherLogonLoc.getStore().load({params:{OTHLLParRef:0,start:0, limit:pageSize_LogonLoc}});
						}else{
							gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
						}
				   }
				}],
			listeners:{
				'afterlayout':function(){
					
		      	}
			}
	});
	var dsOtherLogonLoc = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_SSUserOtherLogonLoc}),//调用的动作  pClassName=web.DHCBL.CT.RBOtherLogonLoc&pClassQuery=GetList
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'OTHLLRowId', mapping:'OTHLLRowId',type: 'string'},
        { name: 'OTHLLParRef', mapping:'OTHLLParRef',type: 'string'},
	    { name: 'OTHLLCTLOCDR', mapping:'OTHLLCTLOCDR',type: 'string'},
        { name: 'CTLOCDesc',mapping:'CTLOCDesc', type: 'string' },   
        { name: 'OTHLLUserGroupDR', mapping:'OTHLLUserGroupDR',type: 'string'},
        { name: 'SSGRPDesc', mapping:'SSGRPDesc',type: 'string'},
        { name: 'OTHLLHospitalDR', mapping:'OTHLLHospitalDR',type: 'string'},
        { name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'},
        { name: 'OTHLLStartDate', mapping:'OTHLLStartDate',type : 'string'},
        { name: 'OTHLLEndDate', mapping:'OTHLLEndDate',type : 'string'},
        { name: 'SyncRBFlag', mapping:'SyncRBFlag',type: 'string'}
		]),
		remoteSort: true
    });	
	var pagingOtherLogonLoc= new Ext.PagingToolbar({
            pageSize: pageSize_LogonLoc,
            store: dsOtherLogonLoc,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_LogonLoc=this.pageSize;
				         }
		        }
        })		
	var smOtherLogonLoc = new Ext.grid.CheckboxSelectionModel({singleSelect : false, checkOnly: false, width: 20});
    var gridOtherLogonLoc = new Ext.grid.GridPanel({
		id:'gridOtherLogonLoc',
		region: 'center',
		title:'其他登录科室明细',
		width:780,
		height:210,
		closable:true,
	    store: dsOtherLogonLoc,
	    trackMouseOver: true,
		sm:smOtherLogonLoc,
	    columns: [
	            smOtherLogonLoc,
	            { header: 'OTHLLRowId', width: 160, sortable: true, dataIndex: 'OTHLLRowId', hidden : true},
	            { header: '登录科室', width: 200, sortable: true, dataIndex: 'CTLOCDesc' },
				{ header: '安全组', width: 200, sortable: true, dataIndex: 'SSGRPDesc' },
	            { header: '医院', width: 200, sortable: true, dataIndex: 'HOSPDesc'},
	            { header: '登录科室ID', width: 120, sortable: true, dataIndex: 'OTHLLCTLOCDR', hidden : true },
				{ header: '安全组ID', width: 120, sortable: true, dataIndex: 'OTHLLUserGroupDR', hidden : true },
	            { header: '医院ID', width: 120, sortable: true, dataIndex: 'OTHLLHospitalDR', hidden : true },
	            { header: '开始日期', width: 120, sortable: true, dataIndex: 'OTHLLStartDate'},
	            { header: '结束日期', width: 120, sortable: true, dataIndex: 'OTHLLEndDate'},
	            { header: 'SyncRBFlag', width: 120, sortable: true, dataIndex: 'SyncRBFlag' ,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon, hidden : true}
	        ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		bbar:pagingOtherLogonLoc ,
	    stateId: 'gridOtherLogonLoc'
    
	});
	gridOtherLogonLoc.on("rowclick",function(grid,rowIndex,e){
		var _record = gridOtherLogonLoc.getSelectionModel().getSelected();//records[0]
		Ext.getCmp("hidden_OTHLLRowId").reset();
	    Ext.getCmp("hidden_OTHLLRowId").setValue(_record.get('OTHLLRowId'));
		//Ext.getCmp("comboxOtherLogonLoc").reset();
	    Ext.getCmp("comboxOtherLogonLoc").setValue(_record.get('OTHLLCTLOCDR'));
	    Ext.getCmp("comboxOtherLogonLoc").setRawValue(_record.get('CTLOCDesc'));
	    //Ext.getCmp("comboGroup").reset();
	    Ext.getCmp("comboGroup").setValue(_record.get('OTHLLUserGroupDR'));
	    Ext.getCmp("comboGroup").setRawValue(_record.get('SSGRPDesc'));
	   Ext.getCmp("OTHLLStartDate").setValue(_record.get('OTHLLStartDate'));
	   Ext.getCmp("OTHLLEndDate").setValue(_record.get('OTHLLEndDate'));
	   Ext.getCmp("SyncRBFlag").setValue(true);
	});	
	
	var OtherLogonLocPanel=new Ext.Panel({
		title:'其他登录科室',
		layout:'border',
		region:'center',
		frame:true,
		items:[winOtherLogonLoc,gridOtherLogonLoc]
	});
	
	function saveloc(rowid){
 		var locstr="";
 		
	    dsOtherLogonLoc.each(function(record){
			if(locstr!="") locstr = locstr+"*";
			locstr = locstr+record.get('OTHLLRowId')+'^'+record.get('OTHLLCTLOCDR')+'^'+record.get('OTHLLUserGroupDR')+'^'+record.get('OTHLLStartDate')+'^'+record.get('OTHLLEndDate')+'^'+record.get('SyncRBFlag');
	    }, this);
		Ext.Ajax.request({
			url:SAVE_URL_OtherLogonLoc,
			method:'POST',
			params:{
				'ssusrrowid':rowid,
				'locstr':locstr
			}
		});  
	}
	/***********************************用户关联岗位**gss**2022年11月30日************************************/
	var resetUserAccountPost=function()
	 {
		Ext.getCmp("USERPOSTPostCode").reset();
		Ext.getCmp("USERPOSTActivity").setValue(true)
		Ext.getCmp("USERPOSTStartDate").setValue(TodayDate);
		Ext.getCmp("USERPOSTEndDate").reset();
		Ext.getCmp("USERPOSTSeqNo").reset();
		Ext.getCmp("USERPOSTMark").reset();
		Ext.getCmp("USERPOSTDefault").setValue(false)
	}
	var PostStore=new Ext.data.JsonStore({
		//autoLoad: true,
		url:BindingPost,
		root: 'data',
		totalProperty: 'total',
		idProperty: 'ID',
		fields:['ID','POSTDesc']
	})
	var winUserAccountPost=new Ext.form.FormPanel({
		id:'winUserAccountPost',
		region:'north',
		height:110,
		labelAlign : 'right',
		items:[{
        	border:false,
      	 	items:[{ 
    		layout : "column",  
    		xtype:'fieldset',
			title:'系统账户岗位',
    		items : [{
      				 columnWidth : .33,  
					 defaults: {anchor:'96%',msgTarget:'under'},
      				 layout : "form",  
      				 items : [{
							fieldLabel: '<font color=red>*</font>岗位',	
							xtype:'bdpcombo',
							id: 'USERPOSTPostCode',
							loadByIdParam : 'rowid',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTPostCode'),
							queryParam : "desc",
							forceSelection: true,
							selectOcnFocus:false,
							mode:'remote',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							listWidth:250,
							valueField:'ID',
							displayField:'POSTDesc',
							store:PostStore,
							listeners : { 
							 	'beforequery': function(e){
									this.store.baseParams = {
										desc:e.query,
										personid:Ext.getCmp("HOSPersonDR").getValue()
									};
									this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
									}})
					
								}
							}
							
						},{
							xtype: 'textfield',
							fieldLabel: "排序号",
							name: 'USERPOSTSeqNo',
							id:'USERPOSTSeqNo',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('USERPOSTSeqNo')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTSeqNo'),
							dataIndex:'USERPOSTSeqNo',
							regex: /^[0-9]+?$/,
							regexText : '请输入非负整数（正整数 + 0）'
						}]
			        }, {
			           columnWidth : .33,
					   defaults: {anchor:'96%',msgTarget:'under'},
			           layout : "form",
			           items : [
			           	{
	          				fieldLabel: '<font color=red>*</font>开始日期',
							xtype:'datefield',
							width:120,
							id:'USERPOSTStartDate',
				    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTStartDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('USERPOSTStartDate')),
			    			name: 'USERPOSTStartDate',
			    			format: BDPDateFormat,
			    			enableKeyEvents : true,
							listeners : { 
								'keyup' : function(field, e){ 
									Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
								}
							}
						},{
							xtype: 'textfield',
							fieldLabel: "备注",
							name: 'USERPOSTMark',
							id:'USERPOSTMark',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('USERPOSTMark')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTMark'),
							dataIndex:'USERPOSTMark'
						}]
			          },{
	      				 columnWidth : .33,  
						 defaults: {anchor:'96%',msgTarget:'under'},
	      				 layout : "form",  
	      				 items : [{
		             			fieldLabel: '结束日期',
		             			width:120,
								xtype:'datefield',
					    		id:'USERPOSTEndDate',
					    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTEndDate'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('USERPOSTEndDate')),
				    			name: 'USERPOSTEndDate',
				    			format: BDPDateFormat,
				    			enableKeyEvents : true,
								listeners : { 
									'keyup' : function(field, e){ 
										Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
									}
								}
		            	 	},{
								xtype : 'checkbox',
								boxLabel : '是否有效',
								id : 'USERPOSTActivity',
								name : 'USERPOSTActivity',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTActivity'),
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('USERPOSTActivity')),
								inputValue : true?'Y':'N',
								checked : true
			            	 },{
								xtype : 'checkbox',
								boxLabel : '默认',
								id : 'USERPOSTDefault',
								name : 'USERPOSTDefault',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('USERPOSTDefault'),
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('USERPOSTDefault')),
								inputValue : true?'Y':'N'
			            	 },{
								xtype: 'textfield',
								id: 'USERPOSTRowId',
								hidden : true
							}]
	      				
				          }]
      				 	}]
       				}],
			buttonAlign:'center', 
	        buttons:[{  
	        		id:'btnAddUserAccountPost',
	        		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddUserAccountPost'),
	                text:'添加',
	                iconCls : 'icon-add',
	                width: 60,
	                handler: function (){
	                	var USERPOSTPostCode = Ext.getCmp("USERPOSTPostCode").getValue();
						if (USERPOSTPostCode== "" ) {
		    				Ext.Msg.show({
		        					title : '提示',
									msg : '岗位不能为空!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
								return;
		   			 	}
							
	                	var startDate = Ext.getCmp("USERPOSTStartDate").getValue();
	                	var endDate = Ext.getCmp("USERPOSTEndDate").getValue();
	                	if (startDate== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '开始日期不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			      			
			   			 	}
				    	 if (startDate!= "" && endDate!= "") {
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
		   			 	var defaultCount=0
		   			 	var USERPOSTDefault = Ext.getCmp('USERPOSTDefault').getValue()==true?"Y":"N"
		   			 	for (var i = 0; i < dsUserAccountPost.getCount(); i++) {
							var record = dsUserAccountPost.getAt(i);
							var POSTDefault = record.get('USERPOSTDefault');
							if (POSTDefault=="Y") defaultCount=defaultCount+1
							if ((USERPOSTDefault=="Y")&(POSTDefault=="Y")){
								Ext.Msg.show({
									title:'提示',
									msg:'仅能有一个默认岗位!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
								return;
							}
							
						}
							
		   			 	if (Ext.getCmp("SSUSRRowId").getValue()!="")
		   			 	{
		   			 		if ((defaultCount==0)&(USERPOSTDefault!="Y")){
								Ext.Msg.show({
									title:'提示',
									msg:'必须设置默认岗位!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
								return;
							}
							
		   			 		var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue()
		   			 		var poststr=""+"^"+USERPOSTPostCode+"^"+(Ext.getCmp('USERPOSTActivity').getValue()==true?"Y":"N")+"^"+Ext.getCmp("USERPOSTStartDate").getRawValue()+"^"+Ext.getCmp("USERPOSTEndDate").getRawValue()+"^"+Ext.getCmp("USERPOSTSeqNo").getValue()+"^"+Ext.getCmp("USERPOSTMark").getValue()+"^"+(Ext.getCmp('USERPOSTDefault').getValue()==true?"Y":"N")
        					var savestr = tkMakeServerCall("web.DHCBL.CT.HOSUserAccountPost","SaveAll",SSUSRRowId,poststr);
        					var jsonData = Ext.util.JSON.decode(savestr);
        					if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '保存成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										gridUserAccountPost.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
									}
								});
							} else {
								var errorMsg = '';
								if (jsonData.errorinfo) {
									errorMsg = '<br />错误信息:'+ jsonData.errorinfo
								}
								Ext.Msg.show({
									title : '提示',
									msg : '保存失败!' + errorMsg,
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
							}
						}
						else
						{
							
		   			 	 	for (var i = 0; i < dsUserAccountPost.getCount(); i++) {
								var record = dsUserAccountPost.getAt(i);
								var PostCode = record.get('USERPOSTPostCode');
								if(USERPOSTPostCode==PostCode){
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
							var _record = new Ext.data.Record({
				    	 		'USERPOSTRowId':'',
				    	 		'USERPOSTPostDesc':Ext.getCmp('USERPOSTPostCode').getRawValue(),
				    	 		'USERPOSTPostCode':Ext.getCmp('USERPOSTPostCode').getValue(),
				    	 		'USERPOSTActivity':(Ext.getCmp('USERPOSTActivity').getValue()==true?"Y":"N"),
				    	 		'USERPOSTStartDate':Ext.getCmp('USERPOSTStartDate').getRawValue(),
				    	 		'USERPOSTEndDate':Ext.getCmp('USERPOSTEndDate').getRawValue(),
				    	 		'USERPOSTSeqNo':Ext.getCmp('USERPOSTSeqNo').getValue(),
				    	 		'USERPOSTMark':Ext.getCmp('USERPOSTMark').getValue(),
				    	 		'USERPOSTDefault':(Ext.getCmp('USERPOSTDefault').getValue()==true?"Y":"N")
				    	 	});
				    	 	gridUserAccountPost.stopEditing();
				    	 	dsUserAccountPost.insert(0,_record); 	   
				    	 	
						}
						resetUserAccountPost()
						
					}
	     	}, { 
	            	id:'btnUpdateUserAccountPost',
	            	text:'修改',
	            	width: 60,
	            	iconCls : 'icon-update',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('btnUpdateUserAccountPost'),
	                handler: function (){ 
	                	if(gridUserAccountPost.selModel.hasSelection()){
							//多选修改返回提示框	
							var gsm = gridUserAccountPost.getSelectionModel();//获取选择列
							var rows = gsm.getSelections();//根据选择列获取到所有的行
							if(rows.length!=1){
								Ext.Msg.show({
			        					title : '提示',
										msg : '请选择一条数据修改!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
								});
								return;
							}
	                		
	                		var USERPOSTPostCode = Ext.getCmp("USERPOSTPostCode").getValue();
							if (USERPOSTPostCode== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '岗位不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			   			 	}
							
	                		var startDate = Ext.getCmp("USERPOSTStartDate").getValue();
	                		var endDate = Ext.getCmp("USERPOSTEndDate").getValue();
				        	 if (startDate!= "" && endDate!= "") {
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
			   			 	
			   			 	if (Ext.getCmp("SSUSRRowId").getValue()!="")
			   			 	{
			   			 		var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue()
			   			 		
			   			 		//取消原默认岗位
			   			 		var USERPOSTDefault = Ext.getCmp('USERPOSTDefault').getValue()==true?"Y":"N"
				   			 	for (var i = 0; i < dsUserAccountPost.getCount(); i++) {
									var record = dsUserAccountPost.getAt(i);
									var POSTDefault = record.get('USERPOSTDefault');
									var SelectionDefault = gridUserAccountPost.getSelectionModel().getSelections()[0].get('USERPOSTDefault');
									if ((USERPOSTDefault=="Y")&(POSTDefault=="Y")&(POSTDefault!=SelectionDefault)){
										var poststr=record.get('USERPOSTRowId')+'^'+record.get('USERPOSTPostCode')+'^'+record.get('USERPOSTActivity')+'^'+record.get('USERPOSTStartDate')+'^'+record.get('USERPOSTEndDate')+'^'+record.get('USERPOSTSeqNo')+'^'+record.get('USERPOSTMark')+'^N';
	        							var savestr = tkMakeServerCall("web.DHCBL.CT.HOSUserAccountPost","SaveAll",SSUSRRowId,poststr);
									}
									if ((USERPOSTDefault=="N")&(SelectionDefault=="Y")){
										Ext.Msg.show({
											title:'提示',
											msg:'必须有一个默认岗位!',
											minWidth:200,
											icon:Ext.Msg.ERROR,
											buttons:Ext.Msg.OK
										});
										return;
									}
								}
							
			   			 		var OTHLLRowId = gridUserAccountPost.getSelectionModel().getSelections()[0].get('USERPOSTRowId');
	        					var poststr=OTHLLRowId+"^"+USERPOSTPostCode+"^"+(Ext.getCmp('USERPOSTActivity').getValue()==true?"Y":"N")+"^"+Ext.getCmp("USERPOSTStartDate").getRawValue()+"^"+Ext.getCmp("USERPOSTEndDate").getRawValue()+"^"+Ext.getCmp("USERPOSTSeqNo").getValue()+"^"+Ext.getCmp("USERPOSTMark").getValue()+"^"+(Ext.getCmp('USERPOSTDefault').getValue()==true?"Y":"N")
	        					var savestr = tkMakeServerCall("web.DHCBL.CT.HOSUserAccountPost","SaveAll",SSUSRRowId,poststr);
	        					var jsonData = Ext.util.JSON.decode(savestr);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											gridUserAccountPost.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
										}
									});
								} else {
									var errorMsg = '';
									if (jsonData.errorinfo) {
										errorMsg = '<br />错误信息:'+ jsonData.errorinfo
									}
									Ext.Msg.show({
										title : '提示',
										msg : '保存失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
			   			 		
			   			 	}
			   			 	else
			   			 	{
			   			 		
					    	 	var myrecord = gridUserAccountPost.getSelectionModel().getSelected();
					    	 	myrecord.set('USERPOSTPostDesc',Ext.getCmp('USERPOSTPostCode').getRawValue());
					    	 	myrecord.set('USERPOSTPostCode',Ext.getCmp('USERPOSTPostCode').getValue());
					    	 	myrecord.set('USERPOSTActivity',(Ext.getCmp('USERPOSTActivity').getValue()==true?"Y":"N"));
					    	 	myrecord.set('USERPOSTStartDate',Ext.getCmp('USERPOSTStartDate').getRawValue());
					    	 	myrecord.set('USERPOSTEndDate',Ext.getCmp('USERPOSTEndDate').getRawValue());
					    	 	myrecord.set('USERPOSTSeqNo',Ext.getCmp('USERPOSTSeqNo').getValue());
					    	 	myrecord.set('USERPOSTMark',Ext.getCmp('USERPOSTMark').getValue());
					    	 	myrecord.set('USERPOSTDefault',(Ext.getCmp('USERPOSTDefault').getValue()==true?"Y":"N"));
			   			 	}
				    	 	resetUserAccountPost()
						}else{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择需要修改的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
						}
	              }
	            }, {  
	            	id:'btnDelUserAccountPost',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDelUserAccountPost'),
	                text:'删除',
	                iconCls : 'icon-delete',
	                width: 60,
	                handler: function (){ 
	                	if(gridUserAccountPost.selModel.hasSelection()){
							Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
								if(btn=='yes'){
									Ext.MessageBox.wait('数据删除中,请稍候...','提示');
									var gsm = gridUserAccountPost.getSelectionModel();//获取选择列
									var rows = gsm.getSelections();//根据选择列获取到所有的行
									for(var i=0;i<rows.length;i++){
										if ((rows[i].get('USERPOSTDefault')=="Y")&(dsUserAccountPost.getCount()>1)){
											Ext.Msg.show({
												title:'提示',
												msg:'必须保留一个默认岗位!',
												minWidth:200,
												icon:Ext.Msg.ERROR,
												buttons:Ext.Msg.OK
											});
											return;
											
										}
									}
									
									if(rows[0].get('USERPOSTRowId')==""){
										dsUserAccountPost.remove(gsm.getSelections());
										Ext.Msg.show({
											title:'提示',
											msg:'数据删除成功!',
											icon:Ext.Msg.INFO,
											buttons:Ext.Msg.OK,
											fn:function(btn){
												resetUserAccountPost()
												
											}
										});
									}else{
										if(rows.length==1){
											//选择单条删除
											Ext.Ajax.request({
												url:DELETE_UserAccountPost_URL,
												method:'POST',
												params:{
														'id':rows[0].get('USERPOSTRowId')
												},
												callback:function(options, success, response){
													Ext.MessageBox.hide();
													if(success){
														var jsonData = Ext.util.JSON.decode(response.responseText);
														if(jsonData.success == 'true'){
															Ext.Msg.show({
																title:'提示',
																msg:'数据删除成功!',
																icon:Ext.Msg.INFO,
																buttons:Ext.Msg.OK,
																fn:function(btn){
																	resetUserAccountPost()
																	Ext.BDP.FunLib.DelForTruePage(gridUserAccountPost,pageSize_LogonLoc);
																}
															});
														}
														else{
															var errorMsg ='';
															if(jsonData.info){
																errorMsg='<br />错误信息:'+jsonData.info
															}
															Ext.Msg.show({
																title:'提示',
																msg:'数据删除失败!'+errorMsg,
																minWidth:200,
																icon:Ext.Msg.ERROR,
																buttons:Ext.Msg.OK
															});
														}
													}
													else{
														Ext.Msg.show({
															title:'提示',
															msg:'异步通讯失败,请检查网络连接!',
															icon:Ext.Msg.ERROR,
															buttons:Ext.Msg.OK
														});
													}
												}
											},this);
											
										}else{
											var str1="";
											for(var i=0;i<rows.length;i++){
												if (str1!=""){
													str1=str1+"^"
												}
												str1+=rows[i].get('USERPOSTRowId');
											}
											var delre=tkMakeServerCall("web.DHCBL.CT.HOSUserAccountPost","DeleteSelections",str1);
											if (delre==1){
												Ext.MessageBox.hide();
												Ext.Msg.show({
													title:'提示',
													msg:'数据删除成功!',
													icon:Ext.Msg.INFO,
													buttons:Ext.Msg.OK,
													fn:function(btn){
														resetUserAccountPost();
														Ext.BDP.FunLib.DelForTruePage(gridUserAccountPost,pageSize_LogonLoc);
													}
												});
												gridUserAccountPost.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
											}else{
												Ext.Msg.show({
														title:'提示',
														msg:'数据删除失败!',
														minWidth:200,
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											}
										}
									}
								}
							},this);
						}
						else{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择需要删除的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
						}
	              	}
	            },{				
	            	id:'btnRefreshUserAccountPost',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshUserAccountPost'),
					text:'重置',
					iconCls : 'icon-refresh',
					width:60,
					handler:function()
					{
						resetUserAccountPost()
						if(win.title=='注册新用户'){
							gridUserAccountPost.getStore().load({params:{parref:0,start:0, limit:pageSize_LogonLoc}});
						}else{
							gridUserAccountPost.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
						}
				   }
				}],
			listeners:{
				'afterlayout':function(){
					
		      	}
			}
	});
	var dsUserAccountPost = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_UserAccountPost}),//调用的动作  pClassName=web.DHCBL.CT.HOSUserAccountPost&pClassQuery=GetList
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'USERPOSTRowId', mapping:'USERPOSTRowId',type: 'string'},
        { name: 'USERPOSTParRef', mapping:'USERPOSTParRef',type: 'string'},
	    { name: 'USERPOSTPostDesc', mapping:'USERPOSTPostDesc',type: 'string'},
        { name: 'USERPOSTPostCode',mapping:'USERPOSTPostCode', type: 'string' },   
        { name: 'USERPOSTActivity', mapping:'USERPOSTActivity',type: 'string'},
   		{ name: 'USERPOSTStartDate', mapping:'USERPOSTStartDate',type : 'string'},
        { name: 'USERPOSTEndDate', mapping:'USERPOSTEndDate',type : 'string'},
        { name: 'USERPOSTSeqNo', mapping:'USERPOSTSeqNo',type: 'string'},
        { name: 'USERPOSTMark', mapping:'USERPOSTMark',type: 'string'},
        { name: 'USERPOSTDefault', mapping:'USERPOSTDefault',type: 'string'}
		]),
		remoteSort: true
    });	
	var pagingUserAccountPost= new Ext.PagingToolbar({
            pageSize: pageSize_LogonLoc,
            store: dsUserAccountPost,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_LogonLoc=this.pageSize;
				         }
		        }
        })		
	var smUserAccountPost = new Ext.grid.CheckboxSelectionModel({singleSelect : false, checkOnly: false, width: 20});
    var gridUserAccountPost = new Ext.grid.GridPanel({
		id:'gridUserAccountPost',
		region: 'center',
		title:'系统账户岗位明细',
		width:780,
		height:210,
		closable:true,
	    store: dsUserAccountPost,
	    trackMouseOver: true,
		sm:smUserAccountPost,
	    columns: [
	            smUserAccountPost,
	            { header: 'USERPOSTRowId', width: 160, sortable: true, dataIndex: 'USERPOSTRowId', hidden : true},
	            { header: '岗位', width: 200, sortable: true, dataIndex: 'USERPOSTPostDesc' },
	            { header: '岗位ID', width: 120, sortable: true, dataIndex: 'USERPOSTPostCode', hidden : true },
	            { header: '是否有效', width: 120, sortable: true, dataIndex: 'USERPOSTActivity' ,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
	            { header: '开始日期', width: 120, sortable: true, dataIndex: 'USERPOSTStartDate'},
	            { header: '结束日期', width: 120, sortable: true, dataIndex: 'USERPOSTEndDate'},
	            { header: '排序号', width: 120, sortable: true, dataIndex: 'USERPOSTSeqNo'},
	            { header: '备注', width: 120, sortable: true, dataIndex: 'USERPOSTMark'},
	            { header: '默认', width: 120, sortable: true, dataIndex: 'USERPOSTDefault' ,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon}
	        ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		bbar:pagingUserAccountPost ,
	    stateId: 'gridUserAccountPost'
    
	});
	gridUserAccountPost.on("rowclick",function(grid,rowIndex,e){
		var _record = gridUserAccountPost.getSelectionModel().getSelected();//records[0]
		Ext.getCmp("USERPOSTRowId").reset();
	    Ext.getCmp("USERPOSTRowId").setValue(_record.get('USERPOSTRowId'));
	    Ext.getCmp("USERPOSTPostCode").setValue(_record.get('USERPOSTPostCode'));
	    Ext.getCmp("USERPOSTPostCode").setRawValue(_record.get('USERPOSTPostDesc'));
	    Ext.getCmp("USERPOSTActivity").setValue(_record.get('USERPOSTActivity')=="Y"?true:false);
	    Ext.getCmp("USERPOSTStartDate").setValue(_record.get('USERPOSTStartDate'));
	    Ext.getCmp("USERPOSTEndDate").setValue(_record.get('USERPOSTEndDate'));
	    Ext.getCmp("USERPOSTSeqNo").setValue(_record.get('USERPOSTSeqNo'));
	    Ext.getCmp("USERPOSTMark").setValue(_record.get('USERPOSTMark'));
	    Ext.getCmp("USERPOSTDefault").setValue(_record.get('USERPOSTDefault')=="Y"?true:false);
	});	
	
	var UserAccountPostPanel=new Ext.Panel({
		title:'系统账户岗位',
		layout:'border',
		region:'center',
		frame:true,
		items:[winUserAccountPost,gridUserAccountPost]
	});
	
	function savepost(rowid){
 		var poststr="";
	    dsUserAccountPost.each(function(record){
			if(poststr!="") poststr = poststr+"*";
			poststr = poststr+record.get('USERPOSTRowId')+'^'+record.get('USERPOSTPostCode')+'^'+record.get('USERPOSTActivity')+'^'+record.get('USERPOSTStartDate')+'^'+record.get('USERPOSTEndDate')+'^'+record.get('USERPOSTSeqNo')+'^'+record.get('USERPOSTMark')+'^'+record.get('USERPOSTDefault');
	    }, this);
	    
		Ext.Ajax.request({
			url:SAVE_URL_UserAccountPost,
			method:'POST',
			params:{
				'ssusrrowid':rowid,
				'poststr':poststr
			}
		});  
	}
	/*****************************************************************************************************/
	
	/***********************************第三方系统账号**likefan**2023-03-24************************************/

	var TPS_ComboData = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ThirdPartySystemUser&pClassQuery=GetTPSDataForCmb1";
	var SAVE_URL_ThirdPartySystemUser = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ThirdPartySystemUser&pClassMethod=SaveAll";
	var DELETE_ThirdPartySystemUser_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ThirdPartySystemUser&pClassMethod=DeleteData"
	var ACTION_URL_ThirdPartySystemUser = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ThirdPartySystemUser&pClassQuery=GetList";
	
	var pageSize_ThirdPartySystemUser = Ext.BDP.FunLib.PageSize.Pop;
	
	var resetThirdPartySystemUser=function()
	 {
		Ext.getCmp("TPSUTPSParref").reset();
		Ext.getCmp("TPSUUserCode").reset();
		Ext.getCmp("TPSUUserName").reset();
	}
	var TPSStore=new Ext.data.JsonStore({
		//autoLoad: true,
		url:TPS_ComboData,
		root: 'data',
		totalProperty: 'total',
		idProperty: 'SysRowId',
		fields:['SysRowId','SysDesc']
	})
	var winThirdPartySystemUser=new Ext.form.FormPanel({
		id:'winThirdPartySystemUser',
		region:'north',
		height:80,
		labelWidth: 120,
		labelAlign : 'right',
		items:[{
        	border:false,
      	 	items:[{ 
    		layout : "column",  
    		xtype:'fieldset',
			title:'第三方系统账号',
    		items : [{
      				 columnWidth : .33,  
					 defaults: {anchor:'96%',msgTarget:'under'},
      				 layout : "form",  
      				 items : [{
							fieldLabel: '<font color=red>*</font>三方系统',	
							xtype:'bdpcombo',
							id: 'TPSUTPSParref',
							loadByIdParam : 'rowid',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TPSUTPSParref'),
							queryParam : "desc",
							forceSelection: true,
							selectOcnFocus:false,
							mode:'remote',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							listWidth:250,
							valueField:'SysRowId',
							displayField:'SysDesc',
							store:TPSStore,
							listeners : { 
							 	'beforequery': function(e){
									this.store.baseParams = {
										desc:e.query
									};
									this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
									}})
								}
							}
							
						}]
			        }, {
			           columnWidth : .33,
					   defaults: {anchor:'96%',msgTarget:'under'},
			           layout : "form",
			           items : [
			           	{
							xtype: 'textfield',
							fieldLabel: "<font color=red>*</font>三方系统用户代码",
							name: 'TPSUUserCode',
							id:'TPSUUserCode',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPSUUserCode')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPSUUserCode'),
							dataIndex:'TPSUUserCode'
						}]
			          },{
	      				 columnWidth : .33,  
						 defaults: {anchor:'96%',msgTarget:'under'},
	      				 layout : "form",  
	      				 items : [{
							xtype: 'textfield',
							fieldLabel: "<font color=red>*</font>三方系统用户姓名",
							name: 'TPSUUserName',
							id:'TPSUUserName',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPSUUserName')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPSUUserName'),
							dataIndex:'TPSUUserName'
						},{
								xtype: 'textfield',
								id: 'TPSURowId',
								hidden : true
							}]
	      				
				          }]
      				 	}]
       				}],
			buttonAlign:'center', 
	        buttons:[{  
	        		id:'btnAddThirdPartySystemUser',
	        		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddThirdPartySystemUser'),
	                text:'添加',
	                iconCls : 'icon-add',
	                width: 60,
	                handler: function (){
	                	var TPSUTPSParref = Ext.getCmp("TPSUTPSParref").getValue();
						if (TPSUTPSParref== "" ) {
		    				Ext.Msg.show({
		        					title : '提示',
									msg : '三方系统不能为空!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
								return;
		   			 	}
						if (Ext.getCmp("TPSUUserCode").getValue()== "" ) {
		    				Ext.Msg.show({
		        					title : '提示',
									msg : '三方系统用户代码不能为空!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
								return;
		   			 	}
						if (Ext.getCmp("TPSUUserName").getValue()== "" ) {
		    				Ext.Msg.show({
		        					title : '提示',
									msg : '三方系统用户姓名不能为空!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
								return;
		   			 	}
						
		   			 	if (Ext.getCmp("SSUSRRowId").getValue()!="")
		   			 	{
		   			 		var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue();
		   			 		var poststr=""+"^"+TPSUTPSParref+"^"+Ext.getCmp("TPSUUserCode").getValue()+"^"+Ext.getCmp("TPSUUserName").getValue();
        					var savestr = tkMakeServerCall("web.DHCBL.CT.ThirdPartySystemUser","SaveAll",SSUSRRowId,poststr);
        					var jsonData = Ext.util.JSON.decode(savestr);
        					if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '保存成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										gridThirdPartySystemUser.getStore().load({params:{start:0, limit:pageSize_ThirdPartySystemUser}});
									}
								});
							} else {
								var errorMsg = '';
								if (jsonData.errorinfo) {
									errorMsg = '<br />错误信息:'+ jsonData.errorinfo
								}
								Ext.Msg.show({
									title : '提示',
									msg : '保存失败!' + errorMsg,
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
							}
						}
						else
						{
							
		   			 	 	for (var i = 0; i < dsThirdPartySystemUser.getCount(); i++) {
								var record = dsThirdPartySystemUser.getAt(i);
								var PostCode = record.get('TPSUTPSParref');
								if(TPSUTPSParref==PostCode){
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
							var _record = new Ext.data.Record({
				    	 		'TPSURowId':'',
				    	 		'TPSUTPSParref':Ext.getCmp('TPSUTPSParref').getValue(),
				    	 		'TPSUUserCode':Ext.getCmp('TPSUUserCode').getValue(),
				    	 		'TPSUUserName':Ext.getCmp('TPSUUserName').getValue()
				    	 	});
				    	 	gridThirdPartySystemUser.stopEditing();
				    	 	dsThirdPartySystemUser.insert(0,_record); 	   
				    	 	
						}
						resetThirdPartySystemUser()
						
					}
	     	}, {
	            	id:'btnUpdateThirdPartySystemUser',
	            	text:'修改',
	            	width: 60,
	            	iconCls : 'icon-update',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('btnUpdateThirdPartySystemUser'),
	                handler: function (){ 
	                	if(gridThirdPartySystemUser.selModel.hasSelection()){
							//多选修改返回提示框	
							var gsm = gridThirdPartySystemUser.getSelectionModel();//获取选择列
							var rows = gsm.getSelections();//根据选择列获取到所有的行
							if(rows.length!=1){
								Ext.Msg.show({
			        					title : '提示',
										msg : '请选择一条数据修改!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
								});
								return;
							}
	                		
	                		var TPSUTPSParref = Ext.getCmp("TPSUTPSParref").getValue();
							if (TPSUTPSParref== "" ) {
			    				Ext.Msg.show({
			        					title : '提示',
										msg : '三方系统不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
			   			 	}
							if (Ext.getCmp("TPSUUserCode").getValue()== "" ) {
								Ext.Msg.show({
										title : '提示',
										msg : '三方系统用户代码不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
							}
							if (Ext.getCmp("TPSUUserName").getValue()== "" ) {
								Ext.Msg.show({
										title : '提示',
										msg : '三方系统用户姓名不能为空!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
									return;
							}
							
			   			 	if (Ext.getCmp("SSUSRRowId").getValue()!="")
			   			 	{
			   			 		var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue()
			   			 		
			   			 		var OTHLLRowId = gridThirdPartySystemUser.getSelectionModel().getSelections()[0].get('TPSURowId');
	        					var poststr=OTHLLRowId+"^"+TPSUTPSParref+"^"+Ext.getCmp("TPSUUserCode").getValue()+"^"+Ext.getCmp("TPSUUserName").getValue()
	        					var savestr = tkMakeServerCall("web.DHCBL.CT.ThirdPartySystemUser","SaveAll",SSUSRRowId,poststr);
	        					var jsonData = Ext.util.JSON.decode(savestr);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											gridThirdPartySystemUser.getStore().load({params:{start:0, limit:pageSize_ThirdPartySystemUser}});
										}
									});
								} else {
									var errorMsg = '';
									if (jsonData.errorinfo) {
										errorMsg = '<br />错误信息:'+ jsonData.errorinfo
									}
									Ext.Msg.show({
										title : '提示',
										msg : '保存失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
			   			 		
			   			 	}
			   			 	else
			   			 	{
			   			 		
					    	 	var myrecord = gridThirdPartySystemUser.getSelectionModel().getSelected();
					    	 	myrecord.set('TPSUTPSDesc',Ext.getCmp('TPSUTPSParref').getRawValue());
					    	 	myrecord.set('TPSUTPSParref',Ext.getCmp('TPSUTPSParref').getValue());
					    	 	myrecord.set('TPSUUserCode',Ext.getCmp('TPSUUserCode').getValue());
					    	 	myrecord.set('TPSUUserName',Ext.getCmp('TPSUUserName').getValue());
			   			 	}
				    	 	resetThirdPartySystemUser()
						}else{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择需要修改的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
						}
	              }
	            }, {  
	            	id:'btnDelThirdPartySystemUser',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDelThirdPartySystemUser'),
	                text:'删除',
	                iconCls : 'icon-delete',
	                width: 60,
	                handler: function (){ 
	                	if(gridThirdPartySystemUser.selModel.hasSelection()){
							Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
								if(btn=='yes'){
									Ext.MessageBox.wait('数据删除中,请稍候...','提示');
									var gsm = gridThirdPartySystemUser.getSelectionModel();//获取选择列
									var rows = gsm.getSelections();//根据选择列获取到所有的行
									
									if(rows[0].get('TPSURowId')==""){
										dsThirdPartySystemUser.remove(gsm.getSelections());
										Ext.Msg.show({
											title:'提示',
											msg:'数据删除成功!',
											icon:Ext.Msg.INFO,
											buttons:Ext.Msg.OK,
											fn:function(btn){
												resetThirdPartySystemUser()
												
											}
										});
									}else{
										if(rows.length==1){
											//选择单条删除
											Ext.Ajax.request({
												url:DELETE_ThirdPartySystemUser_URL,
												method:'POST',
												params:{
														'id':rows[0].get('TPSURowId')
												},
												callback:function(options, success, response){
													Ext.MessageBox.hide();
													if(success){
														var jsonData = Ext.util.JSON.decode(response.responseText);
														if(jsonData.success == 'true'){
															Ext.Msg.show({
																title:'提示',
																msg:'数据删除成功!',
																icon:Ext.Msg.INFO,
																buttons:Ext.Msg.OK,
																fn:function(btn){
																	resetThirdPartySystemUser()
																	Ext.BDP.FunLib.DelForTruePage(gridThirdPartySystemUser,pageSize_ThirdPartySystemUser);
																}
															});
														}
														else{
															var errorMsg ='';
															if(jsonData.info){
																errorMsg='<br />错误信息:'+jsonData.info
															}
															Ext.Msg.show({
																title:'提示',
																msg:'数据删除失败!'+errorMsg,
																minWidth:200,
																icon:Ext.Msg.ERROR,
																buttons:Ext.Msg.OK
															});
														}
													}
													else{
														Ext.Msg.show({
															title:'提示',
															msg:'异步通讯失败,请检查网络连接!',
															icon:Ext.Msg.ERROR,
															buttons:Ext.Msg.OK
														});
													}
												}
											},this);
											
										}else{
											var str1="";
											for(var i=0;i<rows.length;i++){
												if (str1!=""){
													str1=str1+"^"
												}
												str1+=rows[i].get('TPSURowId');
											}
											var delre=tkMakeServerCall("web.DHCBL.CT.ThirdPartySystemUser","DeleteSelections",str1);
											if (delre==1){
												Ext.MessageBox.hide();
												Ext.Msg.show({
													title:'提示',
													msg:'数据删除成功!',
													icon:Ext.Msg.INFO,
													buttons:Ext.Msg.OK,
													fn:function(btn){
														resetThirdPartySystemUser();
														Ext.BDP.FunLib.DelForTruePage(gridThirdPartySystemUser,pageSize_ThirdPartySystemUser);
													}
												});
												gridThirdPartySystemUser.getStore().load({params:{start:0, limit:pageSize_ThirdPartySystemUser}});
											}else{
												Ext.Msg.show({
														title:'提示',
														msg:'数据删除失败!',
														minWidth:200,
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											}
										}
									}
								}
							},this);
						}
						else{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择需要删除的行!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
						}
	              	}
	            },{				
	            	id:'btnRefreshThirdPartySystemUser',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshThirdPartySystemUser'),
					text:'重置',
					iconCls : 'icon-refresh',
					width:60,
					handler:function()
					{
						resetThirdPartySystemUser()
						if(win.title=='注册新用户'){
							gridThirdPartySystemUser.getStore().load({params:{parref:0,start:0, limit:pageSize_ThirdPartySystemUser}});
						}else{
							gridThirdPartySystemUser.getStore().load({params:{start:0, limit:pageSize_ThirdPartySystemUser}});
						}
				   }
				}],
			listeners:{
				'afterlayout':function(){
					
		      	}
			}
	});
	var dsThirdPartySystemUser = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_ThirdPartySystemUser}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'TPSURowId', mapping:'TPSURowId',type: 'string'},
	    { name: 'TPSUTPSDesc', mapping:'TPSUTPSDesc',type: 'string'},
        { name: 'TPSUTPSParref',mapping:'TPSUTPSParref', type: 'string' },
        { name: 'TPSUUserCode', mapping:'TPSUUserCode',type: 'string'},
        { name: 'TPSUUserName', mapping:'TPSUUserName',type: 'string'}
		]),
		remoteSort: true
    });	
	var pagingThirdPartySystemUser= new Ext.PagingToolbar({
            pageSize: pageSize_ThirdPartySystemUser,
            store: dsThirdPartySystemUser,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_ThirdPartySystemUser=this.pageSize;
				         }
		        }
        })		
	var smThirdPartySystemUser = new Ext.grid.CheckboxSelectionModel({singleSelect : false, checkOnly: false, width: 20});
    var gridThirdPartySystemUser = new Ext.grid.GridPanel({
		id:'gridThirdPartySystemUser',
		region: 'center',
		title:'第三方系统账号',
		width:780,
		height:210,
		closable:true,
	    store: dsThirdPartySystemUser,
	    trackMouseOver: true,
		sm:smThirdPartySystemUser,
	    columns: [
	            smThirdPartySystemUser,
	            { header: 'TPSURowId', width: 160, sortable: true, dataIndex: 'TPSURowId', hidden : true},
	            { header: '三方系统', width: 200, sortable: true, dataIndex: 'TPSUTPSDesc' },
	            { header: '三方系统ID', width: 120, sortable: true, dataIndex: 'TPSUTPSParref', hidden : true },
	            { header: '三方系统用户代码 ', width: 120, sortable: true, dataIndex: 'TPSUUserCode'},
	            { header: '三方系统用户姓名', width: 120, sortable: true, dataIndex: 'TPSUUserName'}
	        ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		bbar:pagingThirdPartySystemUser ,
	    stateId: 'gridThirdPartySystemUser'
    
	});
	gridThirdPartySystemUser.on("rowclick",function(grid,rowIndex,e){
		var _record = gridThirdPartySystemUser.getSelectionModel().getSelected();//records[0]
		Ext.getCmp("TPSURowId").reset();
	    Ext.getCmp("TPSURowId").setValue(_record.get('TPSURowId'));
	    Ext.getCmp("TPSUTPSParref").setValue(_record.get('TPSUTPSParref'));
	    Ext.getCmp("TPSUTPSParref").setRawValue(_record.get('TPSUTPSDesc'));
	    Ext.getCmp("TPSUUserCode").setValue(_record.get('TPSUUserCode'));
	    Ext.getCmp("TPSUUserName").setValue(_record.get('TPSUUserName'));
	});	
	
	var ThirdPartySystemUserPanel=new Ext.Panel({
		title:'第三方系统账号',
		layout:'border',
		region:'center',
		frame:true,
		items:[winThirdPartySystemUser,gridThirdPartySystemUser]
	});
	
	function saveThirdPartySystemUser(rowid){
 		var poststr="";
	    dsThirdPartySystemUser.each(function(record){
			if(poststr!="") poststr = poststr+"*";
			poststr = poststr+record.get('TPSURowId')+'^'+record.get('TPSUTPSParref')+'^'+record.get('TPSUUserCode')+'^'+record.get('TPSUUserName');
	    }, this);
	    
		Ext.Ajax.request({
			url:SAVE_URL_ThirdPartySystemUser,
			method:'POST',
			params:{
				'ssusrrowid':rowid,
				'poststr':poststr
			}
		});  
	}
	/**********************************************第三方系统账号**end*****************************************************/
	
	/***********************************用户扩展信息**lkf**2020年4月9日************************************/

	var SSUSRE_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserExtend&pClassMethod=OpenData";
	var SSUSRE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSUserExtend&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSUserExtend"; 
	var CTNation_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTNation&pClassQuery=GetDataForCmb1";
	var CTCountry_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassQuery=GetDataForCmb1";
	var CTMarital_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTMarital&pClassQuery=GetDataForCmb1";
	var CTEducation_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTEducation&pClassQuery=GetDataForCmb1";

	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var btnUpload = new Ext.Toolbar.Button({
        text: '头像上传',
        tooltip: '头像上传',
        iconCls: 'icon-DP',
        id:'btnUpaload',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnUpaload'),
      	handler: function() {	
			if(win.title=='注册新用户'){
				var SSUSRRowId=""
			}
			else{
				var _record = grid.getSelectionModel().getSelected();// records[0]
				var SSUSRRowId=_record.get('SSUSRRowId');
			}
			var link="dhc.bdp.bdp.uploadavator.csp?selectrow="+SSUSRRowId; 
			if ('undefined'!==typeof websys_getMWToken)
			{
				link += "&MWToken="+websys_getMWToken() //增加token  
			}
			var winUpload = new Ext.Window({
				iconCls : 'icon-DP',
				width : 650,
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
				onHide:function(){
					var imgdata=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","getImg",SSUSRRowId)
					if(imgdata!=""){
						Ext.getCmp('browseImage').getEl().dom.src=imgdata
					}else{
						Ext.getCmp('browseImage').getEl().dom.src='../scripts/bdp/Framework/imgs/null.jpg';
					}
				}
			});
			winUpload.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';
			winUpload.setTitle("头像上传");
			winUpload.show();
			
		}
    });
	
	var WinFormExtend = new Ext.FormPanel({
		id : 'form-saveExtend',
		title : '用户扩展信息',
		region : 'center',
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		buttonAlign : 'center',
		reader: new Ext.data.JsonReader({root:'list'},
				[
				 {name: 'SSUSRERowId',mapping:'SSUSRERowId',type : 'string'},
				 {name: 'SSUSREBirthday',mapping:'SSUSREBirthday',type : 'string'},
				 {name: 'SSUSRECountryDR',mapping:'SSUSRECountryDR',type : 'string'},
				 {name: 'SSUSRENationDR',mapping:'SSUSRENationDR',type : 'string'},
				 {name: 'SSUSREMaritalDR',mapping:'SSUSREMaritalDR',type : 'string'},
				 {name: 'SSUSREEducationDR',mapping:'SSUSREEducationDR',type : 'string'},
				 {name: 'SSUSREAddress',mapping:'SSUSREAddress',type : 'string'},
				 {name: 'SSUSRESerialNo',mapping:'SSUSRESerialNo',type : 'string'},
				 {name: 'SSUSRECertificateNo',mapping:'SSUSRECertificateNo',type : 'string'},
				 {name: 'SSUSREPoliticalStatus',mapping:'SSUSREPoliticalStatus',type : 'string'},
				 {name: 'SSUSREIntroduction',mapping:'SSUSREIntroduction',type : 'string'},
				 {name: 'SSUSRESpeciality',mapping:'SSUSRESpeciality',type : 'string'},
				 {name: 'SSUSREText1',mapping:'SSUSREText1',type : 'string'},
				 {name: 'SSUSREText2',mapping:'SSUSREText2',type : 'string'},
				 {name: 'SSUSREImgOrientation',mapping:'SSUSREImgOrientation',type : 'string'},
				 {name: 'SSUSREMulpracFlag',mapping:'SSUSREMulpracFlag',type : 'string'},
				 {name: 'SSUSREMainpracinsFlag',mapping:'SSUSREMainpracinsFlag',type : 'string'},
				 {name: 'SSUSREHiServType',mapping:'SSUSREHiServType',type : 'string'},
				 {name: 'SSUSREBeginDate',mapping:'SSUSREBeginDate',type : 'string'},
				 {name: 'SSUSREDrPracType',mapping:'SSUSREDrPracType',type : 'string'},
				 {name: 'SSUSREDrProTechDuty',mapping:'SSUSREDrProTechDuty',type : 'string'},
				 {name: 'SSUSREDrPracScpCode',mapping:'SSUSREDrPracScpCode',type : 'string'},
				 {name: 'SSUSREProCode',mapping:'SSUSREProCode',type : 'string'},
				 {name: 'SSUSREDclProfFlag',mapping:'SSUSREDclProfFlag',type : 'string'},
				 {name: 'SSUSREPracticeCode',mapping:'SSUSREPracticeCode',type : 'string'},
				 {name: 'SSUSREDrProfttlCode',mapping:'SSUSREDrProfttlCode',type : 'string'},
				 {name: 'SSUSREBindFlag',mapping:'SSUSREBindFlag',type : 'string'},
				 {name: 'SSUSRESiprofFlag',mapping:'SSUSRESiprofFlag',type : 'string'},
				 {name: 'SSUSRELoclprofFlag',mapping:'SSUSRELoclprofFlag',type : 'string'},
				 {name: 'SSUSREHiDrFlag',mapping:'SSUSREHiDrFlag',type : 'string'},
				 {name: 'SSUSRECertType',mapping:'SSUSRECertType',type : 'string'},
				 {name: 'SSUSRECertno',mapping:'SSUSRECertno',type : 'string'},
				 {name: 'SSUSREBirthplace',mapping:'SSUSREBirthplace',type : 'string'}
				 
				]),
		items : [{
				xtype:'fieldset',
				title:'',
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.23',
						layout: 'form',
						labelWidth: 60,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{  
							xtype : 'box',  
							id : 'browseImage',  
							autoEl : {  
								width : 200,  
								height : 200,  
								tag : 'img',  
								src : Ext.BLANK_IMAGE_URL,  
								style : 'border : 1px solid #999;',  
								id : 'imageBrowse' 
							}  
						},btnUpload]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.77',
						layout: 'form',
						labelWidth: 80,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{
							xtype:'textarea',
							fieldLabel: "职工简介",
							//width:280,
							name: 'SSUSREIntroduction',
							id:'SSUSREIntroduction',
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREIntroduction')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREIntroduction'),
							dataIndex:'SSUSREIntroduction',
							height : 110
						},{
							xtype:'textarea',
							fieldLabel: "职工特长",
							//width:280,
							name: 'SSUSRESpeciality',
							id:'SSUSRESpeciality',
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRESpeciality')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRESpeciality'),
							dataIndex:'SSUSRESpeciality',
							height : 95
						}]					
					}]
				}]
			},{
				xtype:'fieldset',
				title:'用户扩展信息维护',
				labelWidth: 90,
				autoHeight:true,
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.33',
						layout: 'form',
						labelWidth: 120,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [{
							xtype:'datefield',
					        fieldLabel: '出生日期',
					        name: 'SSUSREBirthday',
					        id:'SSUSREBirthdayF',
					        enableKeyEvents : true, 
					        readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREBirthdayF'),
					        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREBirthdayF')),
							format : BDPDateFormat,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
					    },{
						 	xtype:'bdpcombo',
							fieldLabel: "国籍",
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							id:'SSUSRECountryDRF',
							name: 'SSUSRECountryDR',
							hiddenName:'SSUSRECountryDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRECountryDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRECountryDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTCOURowId',
							displayField:'CTCOUDesc',
							store:new Ext.data.JsonStore({
								url:CTCountry_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTCOURowId',
								fields:['CTCOURowId','CTCOUDesc']
							})
					    },{
							xtype:'bdpcombo',
							fieldLabel: "民族",
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							id:'SSUSRENationDRF',
							name: 'SSUSRENationDR',
							hiddenName:'SSUSRENationDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRENationDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRENationDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTNATRowId',
							displayField:'CTNATDesc',
							store:new Ext.data.JsonStore({
								url:CTNation_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTNATRowId',
								fields:['CTNATRowId','CTNATDesc']
							})
					    },{	
					    	xtype:'bdpcombo',
							fieldLabel: "婚姻状况",
							id:'SSUSREMaritalDRF',
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							name: 'SSUSREMaritalDR',
							hiddenName:'SSUSREMaritalDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREMaritalDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREMaritalDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'CTMARRowId',
							displayField:'CTMARDesc',
							store:new Ext.data.JsonStore({
								url:CTMarital_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTMARRowId',
								fields:['CTMARRowId','CTMARDesc']
							})
					    },{	
					    	xtype:'bdpcombo',
							fieldLabel: "教育水平",
							id:'SSUSREEducationDRF',
							loadByIdParam : 'rowid',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							name: 'SSUSREEducationDR',
							hiddenName:'SSUSREEducationDR',//不能与id相同
							queryParam : 'desc',
							forceSelection: true,
							selectOnFocus:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREEducationDRF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREEducationDRF')),
							mode:'remote',
							listWidth:250,
							valueField:'EDURowId',
							displayField:'EDUDesc',
							store:new Ext.data.JsonStore({
								url:CTEducation_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'EDURowId',
								fields:['EDURowId','EDUDesc']
							})
						},{	
						xtype:'combo',
						fieldLabel: "政治面貌",
						id:'SSUSREPoliticalStatusF',
						name: 'SSUSREPoliticalStatus',
						hiddenName:'SSUSREPoliticalStatus',
						forceSelection: true,
						selectOnFocus:false,
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREPoliticalStatusF'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREPoliticalStatusF')),
						mode:'local',
						triggerAction : 'all',
						listWidth:250,
						valueField : 'value',
						displayField : 'name',
						store : new Ext.data.JsonStore({
							fields : ['name', 'value'],
							data : [{
										name : '中共党员',value : '中共党员'
									}, {
										name : '中共预备党员',value : '中共预备党员'
									}, {
										name : '共青团员',value : '共青团员'
									}, {
										name : '民革党员',value : '民革党员'
									}, {
										name : '民盟盟员',value : '民盟盟员'
									}, {
										name : '民建会员',value : '民建会员'
									}, {
										name : '民进会员',value : '民进会员'
									}, {
										name : '农工党党员',value : '农工党党员'
									}, {
										name : '致公党党员',value : '致公党党员'
									}, {
										name : '九三学社社员',value : '九三学社社员'
									}, {
										name : '台盟盟员',value : '台盟盟员'
									}, {
										name : '无党派人士',value : '无党派人士'
									}, {
										name : '群众',value : '群众'
									}]
							})
					    },{
								xtype:'datefield',
								fieldLabel: '医疗服务开始时间',
								name: 'SSUSREBeginDate',
								id:'SSUSREBeginDateF',
								enableKeyEvents : true, 
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREBeginDateF'),
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREBeginDateF')),
								format : BDPDateFormat,
								listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
						},{
								xtype: 'textfield',
								fieldLabel: "医疗服务类型",
								name: 'SSUSREHiServType',
								id:'SSUSREHiServType',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREHiServType')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREHiServType'),
								dataIndex:'SSUSREHiServType'
						},{
								xtype: 'textfield',
								fieldLabel: "证书编号",
								name: 'SSUSRECertificateNo',
								id:'SSUSRECertificateNo',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertificateNo')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertificateNo'),
								dataIndex:'SSUSRECertificateNo'
						},{
							xtype: 'textfield',
							fieldLabel: "医师执业类别",
							name: 'SSUSREDrPracType',
							id:'SSUSREDrPracType',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrPracType')),	
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrPracType'),
							dataIndex:'SSUSREDrPracType'
						},{
							
							xtype:'textfield',
							fieldLabel: "SSUSRERowId",
							name: 'SSUSRERowId',
							id:'SSUSRERowId',
							hideLabel : 'True',
							hidden : true
						}]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.33',
						layout: 'form',
						labelWidth: 130,
						labelPad:1,
						border:false,
						defaults: {anchor:'96%',xtype: 'textfield',msgTarget:'under'},
						items: [{
								xtype: 'textfield',
								fieldLabel: "出生地",
								name: 'SSUSREBirthplace',
								id:'SSUSREBirthplace',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREBirthplace')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREBirthplace'),
								dataIndex:'SSUSREBirthplace'
							},{
								xtype: 'textfield',
								fieldLabel: "职工号",
								name: 'SSUSRESerialNo',
								id:'SSUSRESerialNo',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRESerialNo')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRESerialNo'),
								dataIndex:'SSUSRESerialNo'
							},{
								xtype: 'textfield',
								fieldLabel: "家庭住址",
								name: 'SSUSREAddress',
								id:'SSUSREAddress',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREAddress')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREAddress'),
								dataIndex:'SSUSREAddress'
							},{
								xtype: 'textfield',
								fieldLabel: "专业编号",
								name: 'SSUSREProCode',
								id:'SSUSREProCode',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREProCode')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREProCode'),
								dataIndex:'SSUSREProCode'
							},{
								xtype: 'textfield',
								fieldLabel: "医师职称编号",
								name: 'SSUSREDrProfttlCode',
								id:'SSUSREDrProfttlCode',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrProfttlCode')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrProfttlCode'),
								dataIndex:'SSUSREDrProfttlCode'
							},{
								xtype: 'textfield',
								fieldLabel: "证件类型",
								name: 'SSUSRECertType',
								id:'SSUSRECertType',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertType')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertType'),
								dataIndex:'SSUSRECertType'
							},{
								xtype: 'textfield',
								fieldLabel: "证件号码",
								name: 'SSUSRECertno',
								id:'SSUSRECertno',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertno')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRECertno'),
								dataIndex:'SSUSRECertno'
							},{
								xtype: 'textfield',
								fieldLabel: "是否本地申报专家",
								name: 'SSUSRELoclprofFlag',
								id:'SSUSRELoclprofFlag',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRELoclprofFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRELoclprofFlag'),
								dataIndex:'SSUSRELoclprofFlag'
							},{
								xtype: 'textfield',
								fieldLabel: "是否医保医师",
								name: 'SSUSREHiDrFlag',
								id:'SSUSREHiDrFlag',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREHiDrFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREHiDrFlag'),
								dataIndex:'SSUSREHiDrFlag'
							},{
								xtype: 'textfield',
								fieldLabel: "是否医保专家库成员",
								name: 'SSUSRESiprofFlag',
								id:'SSUSRESiprofFlag',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRESiprofFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRESiprofFlag'),
								dataIndex:'SSUSRESiprofFlag'
							},{           	
								xtype: 'textfield',
								fieldLabel : 'SSUSREImgOrientation',
								hideLabel : 'True',
								hidden : true,
								id:'SSUSREImgOrientationF',
								name : 'SSUSREImgOrientation'
							}]						
					},{
						baseCls : 'x-plain',
						columnWidth:'.34',
						layout: 'form',
						labelWidth: 120,
						labelPad:1,
						border:false,
						defaults: {anchor:'96%',xtype: 'textfield',msgTarget:'under'},
						items: [{
								xtype: 'textfield',
								fieldLabel: "多点执业标志",
								name: 'SSUSREMulpracFlag',
								id:'SSUSREMulpracFlag',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREMulpracFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREMulpracFlag'),
								dataIndex:'SSUSREMulpracFlag'
							},{
								xtype: 'textfield',
								fieldLabel: "主执业机构标志",
								name: 'SSUSREMainpracinsFlag',
								id:'SSUSREMainpracinsFlag',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREMainpracinsFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREMainpracinsFlag'),
								dataIndex:'SSUSREMainpracinsFlag'
							},{
								xtype: 'textfield',
								fieldLabel: "定岗标志",
								name: 'SSUSREBindFlag',
								id:'SSUSREBindFlag',
								style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREBindFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREBindFlag'),
								dataIndex:'SSUSREBindFlag'
							},{
								xtype: 'textfield',
								fieldLabel: "医师执业情况",
								name: 'SSUSREPracticeCode',
								id:'SSUSREPracticeCode',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREPracticeCode')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREPracticeCode'),
								dataIndex:'SSUSREPracticeCode'
							},{
								xtype: 'textfield',
								fieldLabel: "医师专业技术职务",
								name: 'SSUSREDrProTechDuty',
								id:'SSUSREDrProTechDuty',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrProTechDuty')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrProTechDuty'),
								dataIndex:'SSUSREDrProTechDuty'
							},{
								xtype: 'textfield',
								fieldLabel: "医师执业范围代码",
								name: 'SSUSREDrPracScpCode',
								id:'SSUSREDrPracScpCode',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrPracScpCode')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREDrPracScpCode'),
								dataIndex:'SSUSREDrPracScpCode'
							},{
								xtype: 'textfield',
								fieldLabel: "扩展信息1",
								name: 'SSUSREText1',
								id:'SSUSREText1',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREText1')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREText1'),
								dataIndex:'SSUSREText1'
							},{
								xtype: 'textfield',
								fieldLabel: "扩展信息2",
								name: 'SSUSREText2',
								id:'SSUSREText2',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREText2')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREText2'),
								dataIndex:'SSUSREText2'
							},{
								xtype: 'textfield',
								fieldLabel: "是否申报为本市专家库成员",
								name: 'SSUSREDclProfFlag',
								id:'SSUSREDclProfFlag',
						        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSREDclProfFlag')),	
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSREDclProfFlag'),
								dataIndex:'SSUSREDclProfFlag'
							}]						
					}]
				}]
			}]
	})
	
	//用户扩展信息页签保存方法 2020年4月9日
	function SaveExtend() {
		WinFormExtend.form.submit({
			clientValidation : true, // 进行客户端验证
			//waitMsg : '正在提交数据请稍后...',
			//waitTitle : '提示',
			url : SSUSRE_SAVE_ACTION_URL,
			method : 'POST',
			success : function(form, action) {
				
			},
			failure : function(form, action) {
				Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
			}
		})
	}

	/************************************用户扩展信息**end*************************************/
	
	/**********************************管制药品分类**lkf**2020年4月9日*********************************/
	var _Poisongridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvPHCPoison&pClassQuery=GetPHCPoison" }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'PHCPORowId', mapping : 'PHCPORowId', type : 'string' }, 
	                            {name : 'PHCPODesc',mapping : 'PHCPODesc',type : 'string'},
	                            {name : 'LinkFlag',mapping : 'LinkFlag',type : 'string' }
	                        ]) 
	     });
	     
	   var gridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _PoisongridObj.getStore().getAt(rowIndex).set("LinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _PoisongridObj.getStore().getAt(rowIndex).set("LinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _PoisongridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 210,
	                height : 230,
	                closable : true,
	                store : _Poisongridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:gridsm,
	                columns : [gridsm,
	                       	{header : '是否关联', width : 80,sortable : true, dataIndex : 'LinkFlag',hidden:true}, 
	                        {header : 'PHCPORowId',width : 80, sortable : true, dataIndex : 'PHCPORowId',hidden:true},
	                        {header : '管制药品分类', width : 160, sortable : true, dataIndex : 'PHCPODesc'}],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });
	/**********************************管制药品分类**end***********************************/
	
	/**********************************关联处方权**lkf**2020年10月19日*********************************/
	var _PrescriptSetgridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProvPrescriptSet&pClassQuery=GetPrescriptSet" }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'PSRowId', mapping : 'PSRowId', type : 'string' }, 
	                            {name : 'PSDesc',mapping : 'PSDesc',type : 'string'},
	                            {name : 'PSLinkFlag',mapping : 'PSLinkFlag',type : 'string' }
	                        ]) 
	     });
	     
	   var PrescriptSetgridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _PrescriptSetgridObj.getStore().getAt(rowIndex).set("PSLinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _PrescriptSetgridObj.getStore().getAt(rowIndex).set("PSLinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _PrescriptSetgridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 210,
	                height : 200,
	                closable : true,
	                store : _PrescriptSetgridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:PrescriptSetgridsm,
	                columns : [PrescriptSetgridsm,
	                       	{header : '是否关联', width : 80,sortable : true, dataIndex : 'PSLinkFlag',hidden:true}, 
	                        {header : 'PSRowId',width : 80, sortable : true, dataIndex : 'PSRowId',hidden:true},
	                        {header : '处方权', width : 160, sortable : true, dataIndex : 'PSDesc'}],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });	
	/**********************************关联处方权**end**********************************/		
	
	//全选框是否勾选 likefan 2020-11-25
	function hdcheckedfun(gridobj){
		//alert(gridobj.getSelectionModel().getSelections().length);	//所选中行的数量
		//alert(gridobj.getStore().getCount());	//所有行的数量
		var hd_checker = gridobj.getEl().select('div.x-grid3-hd-checker');
		var hd = hd_checker.first();
		if(hd != null){
			if (gridobj.getSelectionModel().getSelections().length!=gridobj.getStore().getCount())
			{
				hd.removeClass('x-grid3-hd-checker-on');	//清空表格头的checkBox
			}
			else
			{
				hd.addClass('x-grid3-hd-checker-on');	//选中表格头的checkBox
			}
		}
	}
	
	var WinForm = new Ext.form.FormPanel({
		id : 'form-User-save',
		title:'基本信息',
		iconCls : 'icon-tabs',
		labelWidth : 85,
		labelAlign : 'right',
		frame : true,
		reader : new Ext.data.JsonReader({
					root : 'data'
				}, [
					//用户
					{name : 'SSUSRRowId',mapping : 'SSUSRRowId',type : 'string'},
					{name : 'SSUSRInitials',mapping : 'SSUSRInitials',type : 'string'},
					{name : 'SSUSRName',mapping : 'SSUSRName',type : 'string'},
					{name : 'SSUSRPassword',mapping : 'SSUSRPassword',type : 'string'}, 
					{name : 'SSUSRDefaultDeptDR',mapping : 'SSUSRDefaultDeptDR',type : 'string'}, 
					{name : 'SSUSRGroup',mapping : 'SSUSRGroup',type : 'string'}, 
					{name : 'SSUSRChangeLocation',mapping : 'SSUSRChangeLocation',type : 'string'}, 
					{name : 'SSUSRCTLANDR',mapping : 'SSUSRCTLANDR',type : 'string'}, 
					{name : 'SSUSRCareProvDR',mapping : 'SSUSRCareProvDR',type : 'string'}, 
					{name : 'SSUSRPin',mapping : 'SSUSRPin',type : 'string'}, 
					{name : 'SSUSRActive',mapping : 'SSUSRActive',type : 'string'}, 
					{name : 'SSUSRDateFrom',mapping : 'SSUSRDateFrom',type : 'string'}, 
					{name : 'SSUSRDateTo',mapping : 'SSUSRDateTo',type : 'string'}, 
					{name : 'SSUSRHospitalDR',mapping : 'SSUSRHospitalDR',type : 'string'}, 
					{name : 'SSUSRPasswordChanged',mapping : 'SSUSRPasswordChanged',type : 'string'}, 
					{name : 'SSUSRAdmitted',mapping : 'SSUSRAdmitted',type : 'string'}, 
					{name : 'SSUSRIgnoreCALogon',mapping : 'SSUSRIgnoreCALogon',type : 'string'}, 
					{name : 'EnablePostLogon',mapping : 'EnablePostLogon',type : 'string'}, 
					{name : 'SSUSRFreeText1',mapping : 'SSUSRFreeText1',type : 'string'}, 
					{name : 'SSUSRFreeText2',mapping : 'SSUSRFreeText2',type : 'string'}, 
					{name : 'SSUSRFreeText3',mapping : 'SSUSRFreeText3',type : 'string'}, 
					{name : 'SSUSRMobile',mapping : 'SSUSRMobile',type : 'string'}, 
					{name : 'SSUSRPager',mapping : 'SSUSRPager',type : 'string'}, 
					{name : 'SSUSREmail',mapping : 'SSUSREmail',type : 'string'}, 
					{name : 'SSUSRDefRBDepartmentDR',mapping : 'SSUSRDefRBDepartmentDR',type : 'string'}, 
					{name : 'SSUSRHOSPersonDR',mapping : 'SSUSRHOSPersonDR',type : 'string'}, 
					{name : 'SSUSRSeqNo',mapping : 'SSUSRSeqNo',type : 'string'}, 
					{name : 'SSUSRPYCode',mapping : 'SSUSRPYCode',type : 'string'}, 
					{name : 'SSUSRWBCode',mapping : 'SSUSRWBCode',type : 'string'}, 
					{name : 'SSUSRMark',mapping : 'SSUSRMark',type : 'string'}, 
					
					//医护人员
					{name:'CTPCPRowId1',mapping:'CTPCPRowId1',type:'string'},
					{name:'CTPCPCode',mapping:'CTPCPCode',type:'string'},
					{name:'CTPCPOtherName',mapping:'CTPCPOtherName',type:'string'},
					{name:'CTPCPUnit',mapping:'CTPCPUnit',type:'string'},
					{name:'CTPCPCarPrvTpDR',mapping:'CTPCPCarPrvTpDR',type:'string'},
					{name:'CTPCPHICApproved',mapping:'CTPCPHICApproved',type:'string'},
					{name:'CTPCPDateActiveFrom',mapping:'CTPCPDateActiveFrom',type : 'string'},
					{name:'CTPCPSurgeon',mapping:'CTPCPSurgeon',type:'string'},
					//{name:'CTPCPActiveFlag',mapping:'CTPCPActiveFlag',type:'string'},
					{name:'CTPCPDesc',mapping:'CTPCPDesc',type:'string'},
					{name:'CTPCPId',mapping:'CTPCPId',type:'string'},
					{name:'CTPCPTextOne',mapping:'CTPCPTextOne',type:'string'},
					{name:'CTPCPTextTwo',mapping:'CTPCPTextTwo',type:'string'},
					{name:'CTPCPSpecDR',mapping:'CTPCPSpecDR',type:'string'},
					{name:'CTPCPDateActiveTo',mapping:'CTPCPDateActiveTo',type : 'string'},
					{name:'CTPCPAnaesthetist',mapping:'CTPCPAnaesthetist',type:'string'},
					{name:'CTPCPSpecialistYN',mapping:'CTPCPSpecialistYN',type:'string'},
					/*{name:'CTPCPTelO',mapping:'CTPCPTelO',type:'string'},
					{name:'CTPCPTelH',mapping:'CTPCPTelH',type:'string'},
					{name:'CTPCPTelOExt',mapping:'CTPCPTelOExt',type:'string'},
					{name:'CTPCPMobilePhone',mapping:'CTPCPMobilePhone',type:'string'},
					{name:'CTPCPEmail',mapping:'CTPCPEmail',type:'string'},
					{name:'CTPCPFax',mapping:'CTPCPFax',type:'string'},*/
					{name:'CTPCPTitleDR',mapping:'CTPCPTitleDR',type:'string'},
					{name:'CTPCPMentalFlag',mapping:'CTPCPMentalFlag',type:'string'}  //20190614
				]),
				defaults : {
						anchor : '97%'
					},
		items : [{
			xtype : 'fieldset',
			title : '用户维护',
			autoHeight : true,
			items : [{
				layout : 'column',
				border : false,
				items : [{
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 105,
					labelPad : 1,// 默认5
					border : false,
					defaults : {
						anchor : '92%',
						xtype : 'textfield'
					},
					items : [SSUSRInitials,SSUSRCTLANDR,SSUSRHospitalDR,SSUSRDateFrom,SSUSRPassword,SSUSRPin,SSUSRPager,SSUSRDefRBDepartmentDR,SSUSRHOSPersonDR,
							{
								xtype : 'textfield',
								fieldLabel : 'SSUSRRowId',
								hideLabel : 'True',
								hidden : true,
								id : 'SSUSRRowId',
								name : 'SSUSRRowId'
							}]
				}, {
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 95,
					labelPad : 1,
					border : false,
					defaults : {
						anchor : '92%',
						xtype : 'textfield'
					},
					items : [SSUSRName,SSUSRDefaultDeptDR,SSUSRGroup,SSUSRDateTo,SSUSRFreeText1,SSUSRFreeText2,SSUSRMobile,SSUSRFreeText3,SSUSRSeqNo]
				},{
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 45,
					labelPad : 1,
					border : false,
					defaults : {
						anchor : '92%',
						xtype : 'textfield'
					},
					items : [SSUSRChangeLocation,SSUSRActive,SSUSRPasswordChanged,SSUSRAdmitted,SSUSRIgnoreCALogon,EnablePostLogon,SSUSREmail,SSUSRPYCode,SSUSRWBCode,SSUSRMark,SSUSRCareProvDR]
				}]
			}]
		},{
			xtype : 'fieldset',
			checkboxToggle : true,
			title : '关联医护人员',
			autoHeight : true,
			id : 'CTProvSet',
			collapsed : true,
			
			items : [{
				baseCls : 'x-plain',
				layout : 'column',
				border : false,
				items : [{
					baseCls : 'x-plain',
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 105,
					labelPad : 1,// 默认5
					border : false,
					defaults : {
						anchor : '92%'
					},
					items : [CTPCPCode,CTPCPDesc,CTPCPOtherName,CTPCPCarPrvTpDR,CTPCPTitleDR,CTPCPSpecDR,CTPCPUnit,CTPCPTextOne,CTPCPTextTwo,CTPCPId,CTPCPRowId1]  //CTPCPDateActiveFrom,
				}, {
					baseCls : 'x-plain',
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 95,
					labelPad : 1,
					border : false,
					defaults : {
						anchor : '92%',
						xtype : 'textfield'
					},
					items : [CTPCPSurgeon,CTPCPAnaesthetist,{
							xtype : 'fieldset',
							title : '关联处方权（可多选）',
							//width:200,
							autoHeight : true,
							style:'margin-left:50px', 
							items:[_PrescriptSetgridObj]
						}]  //CTPCPDateActiveTo,
				},{
					baseCls : 'x-plain',
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 30,
					labelPad : 1,
					border : false,
					defaults : {
						anchor : '92%'
					},
					items : [CTPCPSpecialistYN,{
							xtype : 'fieldset',
							title : '管制药品分类权限（可多选）',
							//width:200,
							autoHeight : true,
							style:'margin-left:30px', 
							items:[_PoisongridObj]
						}]  //CTPCPActiveFlag,
				}]
			}
			/*,{
				xtype:'fieldset',
				title:'联系方式',
				items:[{
					baseCls : 'x-plain',
					layout : 'column',
					border : false,
					items:[{
						baseCls : 'x-plain',
						columnWidth : '.33',
						layout : 'form',
						labelWidth : 95,
						labelPad : 1,
						border : false,
						defaults : {
							anchor : '92%',
							xtype : 'textfield'
						},
						items:[CTPCPTelO,CTPCPTelOExt]
					},{
						baseCls : 'x-plain',
						columnWidth : '.33',
						layout : 'form',
						labelWidth : 90,
						labelPad : 1,
						border : false,
						defaults : {
							anchor : '92%',
							xtype : 'textfield'
						},
						items:[CTPCPTelH,CTPCPEmail]
					},{
						baseCls : 'x-plain',
						columnWidth : '.33',
						layout : 'form',
						labelWidth : 85,
						labelPad : 1,
						border : false,
						defaults : {
							anchor : '92%',
							xtype : 'textfield'
						},
						items:[CTPCPMobilePhone,CTPCPFax]
					}]
				}]
				
			}*/
			],
			listeners : {
				'beforeexpand' : function() { 
					if(win.title=='注册新用户'){
						syncCTPCPCode()
						
					}
				},
				'collapse':function(){
					Ext.getCmp("CareProvDR").setValue("");	//折叠时清空隐藏字段
				}
			}
		}]
	});
	
	var tabs = new Ext.TabPanel({
			 activeTab : 0,
			 frame : true,
			 deferredRender :false,		//缺省时为true，为true时，'用户扩展信息'等其他FormPanel页签加载不出来 2020年4月9日
			 border : false,
			 animScroll:true,
			 enableTabScroll:true,
			 border:false,
			 defaults:{autoScroll:true},	//2020年4月9日
			 items : [WinForm, OtherLogonLocPanel,WinFormExtend, AliasGrid,UserAccountPostPanel,ThirdPartySystemUserPanel],
			 listeners:{
			 	'tabchange':function(tp,p){
			 		if (p.title=="其他登录科室"){
			 			if (Ext.getCmp("EnablePostLogon").getValue()){ //启用岗位登录
			 				setTimeout(function(){
				 				Ext.Msg.show({
									title : '提示',
									msg : '此用户已启用岗位登录，请确认配置!',
									icon : Ext.Msg.INFO,
									buttons:Ext.Msg.OK
								});
							},50)
			 			}
			 			//设置默认安全组、默认登录科室
			 			Ext.getCmp("SyncRBFlag").setValue(true);
			 			Ext.getCmp("OTHLLStartDate").setValue(TodayDate);
						Ext.getCmp("OtherDefaultDept").setValue(Ext.getCmp("DefaultDeptDR").getRawValue());
			 			Ext.getCmp("OtherBDPGroup").setValue(Ext.getCmp("BDPGroup").getRawValue());
			 			Ext.getCmp("OtherDefaultDeptDr").setValue(Ext.getCmp("DefaultDeptDR").getValue());
			 			Ext.getCmp("OtherBDPGroupDr").setValue(Ext.getCmp("BDPGroup").getValue());
			 			
			 		}
					else if (p.title=="系统账户岗位"){
						if (!Ext.getCmp("EnablePostLogon").getValue()){ //未开启岗位登录
							setTimeout(function(){
								Ext.Msg.show({
									title : '提示',
									msg : '此用户未开启岗位登录，请确认配置!',
									icon : Ext.Msg.INFO,
									buttons:Ext.Msg.OK
								});
							},50)
						}
					}
			 	}
			 }
	});
	
	var win = new Ext.Window({
		title:'',
		width:1000,
		height:Math.min(Ext.getBody().getViewSize().height-10,760),
		layout:'fit',
		plain:true,//true则主体背景透明
		modal:true,
		split : true,
		frame:true,
		buttonAlign:'center',
		closeAction:'hide',
        //labelWidth:55,  
        //pageX:130, 
		//pageY:2, 
		items: tabs,
		listeners:{
			"show":function(){	
				Ext.getCmp("CTProvSet").checkbox.dom.disabled = false;
				Ext.getCmp("CTProvSet").collapsible = true;
				if(win.title=='注册新用户'){
					Ext.getCmp("CTProvSet").expand();	
				}
				if(win.title=='修改'&&grid.getSelectionModel().getSelections()[0].get('CTPCPDesc')!=""){					
					Ext.getCmp("CTProvSet").checkbox.dom.disabled = true;
					Ext.getCmp("CTProvSet").expand();
					
				}
			},
			"hide":function(){
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				Ext.getCmp("CTProvSet").collapse();
			},
			"close":function(){
			}
		},
		buttons:[{
			text:'保存',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler: function() {
				//关联医护人员信息的 面板是否收缩，选中为false不收缩，不选为true收缩
				var collapse = Ext.getCmp("CTProvSet").collapsed	
				
				/**用户参数串*/
				//var startDate = Ext.getCmp("form-User-save").getForm().findField("SSUSRDateFrom").getValue();
				var startDate = Ext.getCmp("SSUSRDateFrom").getValue();
				var endDate = Ext.getCmp("SSUSRDateTo").getValue();
				
				if (startDate=="") {
			    	Ext.Msg.show({ title : '提示', msg : '开始日期不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
				if((startDate!="")&&(startDate!=null)){
    				startDate = startDate.format('Ymd');
   				}
				if((endDate!="")&&(endDate!=null)){
    				endDate = endDate.format('Ymd');
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
			   	
			   	if (Ext.getCmp("SSUSRInitials").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    } 
			    if (Ext.getCmp("SSUSRName").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '姓名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			    if (Ext.getCmp("DefaultDeptDR").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '默认登录科室不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			    if (Ext.getCmp("BDPGroup").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '安全组不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
				//判断科室和安全组是否是同一个医院	20200618	likefan
				var HospDifferentFlag=tkMakeServerCall("web.DHCBL.CT.SSUser","IfHospDifferent",Ext.getCmp("DefaultDeptDR").getValue(),Ext.getCmp("BDPGroup").getValue());
				if (HospDifferentFlag==1) {
			    	Ext.Msg.show({ title : '提示', msg : '登录科室和安全组必须在同一医院组!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
				
			if (Ext.getCmp("SSUSRHospital").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '医院不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			   	//var passLen = tkMakeServerCall("web.CFSM", "GetPasswordMinLength");						
				//var passValid = tkMakeServerCall("websys.Configuration","GetFieldValue","PwdContainWordAndNum");
				//var passReg = /^(?=.*?[a-zA-Z])(?=.*?\d).*/; 
				if (Ext.getCmp("SSUSRPassword").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '登录密码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			    	return;
			    }
			    var SSUSRPin1=Ext.getCmp("SSUSRPin").getValue();
			    if (Ext.getCmp("SSUSRPin").getValue()=="") {
			    	Ext.Msg.show({ title : '提示', msg : '医嘱签名密码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			    	return;
			    }
				/*
				if(SSUSRPin1!=""&&SSUSRPin1!="******"&&SSUSRPin1.length<passLen){									
					Ext.Msg.show({ title : '提示', msg : '医嘱签名密码长度不能小于'+passLen, minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });	
					return;
				}else if(SSUSRPin1!=""&&SSUSRPin1!="******"&&passValid=="Y"){
					if(!passReg.test(SSUSRPin1)){		
						Ext.Msg.show({ title : '提示', msg : '医嘱签名密码须同时包含数字与字母', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });	
						return;
					}
				}
				*/
				if (Ext.getCmp("SSUSRFreeText1").getValue()!="")
				{
					var flag = tkMakeServerCall("web.DHCBL.BDP.FunLib", "IsValidIdNum", Ext.getCmp("SSUSRFreeText1").getValue());
					if (flag!=1)
					{
						Ext.Msg.show({ title : '提示', msg : '身份证号校验失败，请重新确认', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });	
						return;
					}
					
					//根据身份证号获取生日信息
					var birthdaytext=tkMakeServerCall("web.DHCBL.CT.SSUser","GetBirthdayByIdNo",Ext.getCmp("SSUSRFreeText1").getValue());
					//alert(birthdaytext)
					Ext.getCmp("SSUSREBirthdayF").setValue(birthdaytext);
				}
				
			   	var userStr=Ext.getCmp("SSUSRRowId").getValue()+"^"+Ext.getCmp("SSUSRInitials").getValue()+"^"+Ext.getCmp("SSUSRName").getValue()+"^"+collapse+"^"+Ext.getCmp("SSUSRDateFrom").getRawValue()
			    userStr=userStr+"^"+Ext.getCmp("SSUSRDateTo").getRawValue()+"^"+Ext.getCmp("DefaultDeptDR").getValue()+"^"+Ext.getCmp("BDPGroup").getValue()+"^"+Ext.getCmp("CareProvDR").getValue()+"^"+Ext.getCmp("SSUSRChangeLocation").getValue()
			    userStr=userStr+"^"+Ext.getCmp("SSUSRPassword").getValue()+"^"+Ext.getCmp("SSUSRPin").getValue()+"^"+Ext.getCmp("SSUSRHospital").getValue()+"^"+Ext.getCmp("SSUSRPasswordChanged").getValue()+"^"+Ext.getCmp("CTLANDR").getValue()
			   	userStr=userStr+"^"+Ext.getCmp("SSUSRActive").getValue()+"^"+Ext.getCmp("SSUSRAdmitted").getValue()+"^"+Ext.getCmp("SSUSRIgnoreCALogon").getValue()+"^"+Ext.getCmp("SSUSRFreeText1").getValue()+"^"+Ext.getCmp("SSUSRFreeText2F").getValue()
			   	userStr=userStr+"^"+Ext.getCmp("SSUSRFreeText3").getValue()+"^"+Ext.getCmp("SSUSRMobile").getValue()+"^"+Ext.getCmp("SSUSRPager").getValue()+"^"+Ext.getCmp("SSUSREmail").getValue()+"^"+Ext.getCmp("SSUSRDefRBDepartmentDR1").getValue()  //21-25
			    userStr=userStr+"^"+Ext.getCmp("HOSPersonDR").getValue()+"^"+Ext.getCmp("SSUSRSeqNo").getValue()+"^"+Ext.getCmp("SSUSRPYCode").getValue()+"^"+Ext.getCmp("SSUSRWBCode").getValue()+"^"+Ext.getCmp("SSUSRMark").getValue()+"^"+Ext.getCmp("EnablePostLogon").getValue()  //26-30
			   	/**医护人员参数串*/
			   	var flag = tkMakeServerCall("web.DHCBL.CT.CTCareProv","FormValidate",Ext.getCmp("CareProvDR").getValue(),Ext.getCmp("CTPCPCode").getValue());
			   	if (flag==1) {
			    	Ext.Msg.show({ title : '提示', msg : '医护人员工号已存在!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			    	return;
			    }
			   	
			   	 /*var CTPCPTelO=Ext.getCmp("CTPCPTelO").getValue();
			   	var CTPCPTelH=Ext.getCmp("CTPCPTelH").getValue();
			   	var CTPCPTelOExt=Ext.getCmp("CTPCPTelOExt").getValue();
			   	var CTPCPMobilePhone=Ext.getCmp("CTPCPMobilePhone").getValue();
			   	var CTPCPEmail=Ext.getCmp("CTPCPEmail").getValue();
			   	var CTPCPFax=Ext.getCmp("CTPCPFax").getValue();
			   	*/
			   	if (win.title=='修改')
			   	{
			   		var Desc=grid.getSelectionModel().getSelections()[0].get('CTPCPDesc')
			   	}
			   	if(((win.title=="注册新用户" && collapse==false)||(win.title=='修改'&&Desc!="")||(win.title=='修改'&&Desc==""&&collapse==false)) ){			
					 if (CTPCPCode=="") {
				    		Ext.Msg.show({ title : '提示', msg : '工号不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				     if (Ext.getCmp("CTPCPDesc").getValue()=="") {
				    		Ext.Msg.show({ title : '提示', msg : '姓名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				     if (Ext.getCmp("CTPCPOtherName").getValue()=="") {
				    		Ext.Msg.show({ title : '提示', msg : '拼音检索码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				     if (Ext.getCmp("CarPrvTpDR").getValue()=="") {
				    		Ext.Msg.show({ title : '提示', msg : '医护人员类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				}
			   	var provStr=Ext.getCmp("CTPCPCode").getValue()+"^"+Ext.getCmp("CTPCPDesc").getValue()+"^"+Ext.getCmp("CTPCPUnit").getValue()+"^"+Ext.getCmp("CarPrvTpDR").getValue()+"^"+Ext.getCmp("CTPCPHICApproved").getValue()   //1-5
			   	+"^"+""+"^"+Ext.getCmp("CTPCPSurgeon").getValue()+"^"+""+"^"+Ext.getCmp("CTPCPOtherName").getValue()+"^"+Ext.getCmp("CTPCPId").getValue()                                //6-10
			   	+"^"+Ext.getCmp("CTPCPTextOne").getValue()+"^"+Ext.getCmp("CTPCPTextTwo").getValue()+"^"+Ext.getCmp("SpecDR").getValue()+"^"+""+"^"+Ext.getCmp("CTPCPAnaesthetist").getValue()               //11-15
			   	+"^"+Ext.getCmp("CTPCPSpecialistYN").getValue()+"^"+Ext.getCmp("TitleDR").getValue()+"^"+Ext.getCmp("CTPCPMentalFlag").getValue();   //16-18
			   /*	+"^"+CTPCPTelO+"^"+CTPCPMobilePhone+"^"+CTPCPEmail+"^"+CTPCPTelH+"^"+CTPCPTelOExt+"^"+CTPCPFax  */
	
			    if(win.title=="注册新用户")
				{
					var defaultCount=0
					dsUserAccountPost.each(function(record){
				    	if (record.get('USERPOSTDefault')=="Y") defaultCount=defaultCount+1
				    }, this);
				    if ((dsUserAccountPost.getCount()>0)&&(defaultCount!=1)){
				    	Ext.Msg.show({
							title:'提示',
							msg:'有且仅能设置一条默认岗位!',
							minWidth:200,
							icon:Ext.Msg.ERROR,
							buttons:Ext.Msg.OK
						});
						return;
				    }
					
					Ext.Ajax.request({
						url : SAVEALL_ACTION_URL , 		
						method : 'POST',	
						params : {
								'userStr' : userStr,
								'provStr' : provStr
						},
					callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								win.hide();
								var myrowid = jsonData.id;
								//保存其他登录科室
								saveloc(myrowid);
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
								savepost(myrowid) //保存用户岗位 2022-11-30
								saveThirdPartySystemUser(myrowid);	//保存三方系统账号
								//保存用户扩展信息 2020年4月9日
								Ext.getCmp("SSUSRERowId").setValue(myrowid);
								SaveExtend();
								
								//管制药品分类保存 2020年4月9日
								if (collapse==false){
									var linkstr="";
									_PoisongridObj.getStore().each(function(record){
										if(linkstr!="") linkstr = linkstr+"^";
										linkstr = linkstr+record.get('PHCPORowId')+'$'+record.get('LinkFlag');
									}, this);
									var InputCTPCPDR = tkMakeServerCall("web.DHCBL.CT.CTCareProvPHCPoison","GetCTPCPDR",myrowid);	//根据用户id取医护人员id
									//alert(InputCTPCPDR);
									var resultPoison = tkMakeServerCall("web.DHCBL.CT.CTCareProvPHCPoison","UpdatePoison",InputCTPCPDR,linkstr);
								}
								//关联处方权保存 2020年10月19日
								if (collapse==false){
									var linkstr2="";
									_PrescriptSetgridObj.getStore().each(function(record){
										if(linkstr2!="") linkstr2 = linkstr2+"^";
										linkstr2 = linkstr2+record.get('PSRowId')+'$'+record.get('PSLinkFlag');
									}, this);
									var InputCTPCPDR = tkMakeServerCall("web.DHCBL.CT.CTCareProvPrescriptSet","GetCTPCPDR",myrowid);	//根据用户id取医护人员id
									var resultPrescriptSet = tkMakeServerCall("web.DHCBL.CT.CTCareProvPrescriptSet","UpdatePrescriptSet",InputCTPCPDR,linkstr2);
								}
							
								Ext.Msg.show({
								title : '提示',
								msg : '添加成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									resetOtherLogonLoc()
									resetUserAccountPost()
									resetThirdPartySystemUser();
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
							
							}else{
								var errorMsg ='';
								if(jsonData.info){
									errorMsg='<br />'+jsonData.info
								}
								Ext.Msg.show({
									title:'提示',
									msg:errorMsg,
									minWidth:210,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					}	
					
					})
				}
				else
				{
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : SAVEALL_ACTION_URL , 		
								method : 'POST',	
								params : {
										'userStr' : userStr,
										'provStr' : provStr
								},
								callback : function(options, success, response) {	
								if(success){
									AliasGrid.saveAlias();
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										win.hide();
										//var myrowid = "rowid="+ action.result.id;
										var myrowid = "rowid="+jsonData.id;
										//修改其他登录科室
										//saveloc(jsonData.id);  
										
										savepost(myrowid) //保存用户岗位 2022-11-30
										saveThirdPartySystemUser(myrowid);	//保存三方系统账号
										//保存用户扩展信息 2020年4月9日
										SaveExtend();
										
										//管制药品分类保存 2020年4月9日
										if (collapse==false){
											var linkstr="";
											_PoisongridObj.getStore().each(function(record){
												if(linkstr!="") linkstr = linkstr+"^";
												linkstr = linkstr+record.get('PHCPORowId')+'$'+record.get('LinkFlag');
											}, this);
											var InputCTPCPDR = tkMakeServerCall("web.DHCBL.CT.CTCareProvPHCPoison","GetCTPCPDR",jsonData.id);	//根据用户id取医护人员id
											var resultPoison = tkMakeServerCall("web.DHCBL.CT.CTCareProvPHCPoison","UpdatePoison",InputCTPCPDR,linkstr);
										}
										//关联处方权保存 2020年10月19日
										if (collapse==false){
											var linkstr2="";
											_PrescriptSetgridObj.getStore().each(function(record){
												if(linkstr2!="") linkstr2 = linkstr2+"^";
												linkstr2 = linkstr2+record.get('PSRowId')+'$'+record.get('PSLinkFlag');
											}, this);
											var InputCTPCPDR = tkMakeServerCall("web.DHCBL.CT.CTCareProvPrescriptSet","GetCTPCPDR",jsonData.id);	//根据用户id取医护人员id
											var resultPrescriptSet = tkMakeServerCall("web.DHCBL.CT.CTCareProvPrescriptSet","UpdatePrescriptSet",InputCTPCPDR,linkstr2);
										}
										
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												resetOtherLogonLoc()
												resetUserAccountPost()
												resetThirdPartySystemUser();
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid);
												
											}
									});
									}else{
										var errorMsg ='';
										if(jsonData.info){
											errorMsg='<br />'+jsonData.info
										}
										Ext.Msg.show({
											title:'提示',
											msg:errorMsg,
											minWidth:210,
											icon:Ext.Msg.ERROR,
											buttons:Ext.Msg.OK
										});
									}
								}
							}								
						})
						}
					}, this);				
				}			
		}
		},{
			text:'关闭',
			iconCls : 'icon-close',
			handler:function(){
				win.hide();
			}
		}]	
	});
	var btnAddwin = new Ext.Toolbar.Button({
				text : '注册新用户',
				tooltip : '注册新用户',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddwin'),
				iconCls : 'icon-useradd',
				handler : AddData=function () {
					WinForm.isAdd = true;
					
					//Ext.getCmp('loginLoc').getEl().up('.x-form-item').setDisplayed(false);
					//dsOtherLogonLoc.removeAll();
					gridOtherLogonLoc.getStore().load({
						params : {
							OTHLLParRef:0,
							start : 0,
							limit : pageSize_LogonLoc
						}
					});
					WinForm.getForm().reset();
					winOtherLogonLoc.getForm().reset();
					
					gridUserAccountPost.getStore().load({
						params : {
							parref:0,
							start : 0,
							limit : pageSize_LogonLoc
						}
					});
					winUserAccountPost.getForm().reset();
					Ext.getCmp("USERPOSTActivity").setValue(true)
					Ext.getCmp("USERPOSTStartDate").setValue(TodayDate);
					
					gridThirdPartySystemUser.getStore().load({
						params : {
							userdr:"",
							start : 0,
							limit : pageSize_LogonLoc
						}
					});
					winThirdPartySystemUser.getForm().reset();
					
					win.setTitle('注册新用户');
					win.setIconClass('icon-useradd');					
					win.show('new1');
					
					//管制药品分类面板 2020年4月9日
					_Poisongridds.load({
						callback: function(records, options, success){
							var records=[];//存放选中记录  
							for(var i=0;i<_Poisongridds.getCount();i++){  
								var record = _Poisongridds.getAt(i);  
								if(record.data.LinkFlag=='Y'){ records.push(record);   }  
							}  
							gridsm.selectRecords(records);//执行选中已对照的记录  
							hdcheckedfun(_PoisongridObj)	//全选框是否勾选 2020-11-25
						}
					});
					//关联处方权面板 2020年10月19日
					_PrescriptSetgridds.load({
						params:{
							parref:0,
							hospid:hospComp.getValue()
						},
						callback: function(records, options, success){
							var records=[];//存放选中记录  
							for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
								var record = _PrescriptSetgridds.getAt(i);  
								if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
							}  
							PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
							hdcheckedfun(_PrescriptSetgridObj)	//全选框是否勾选 2020-11-25
						}
					});
					
					//用户扩展信息 2020年4月9日
					WinFormExtend.getForm().reset();
					Ext.getCmp('browseImage').getEl().dom.src='../scripts/bdp/Framework/imgs/null.jpg';
					
					//设置默认安全组
					var BDPGroupFlag = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPGroup");
					var BDPGroupValue = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPSSUSRGroup");
					if(BDPGroupFlag=="Y"){
						Ext.getCmp("BDPGroup").setValue(BDPGroupValue);	
					}
					//设置默认登录密码	
    				var BDPUserPswFlag = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPIfUserPsw");
					var BDPUserPswValue = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPUserPsw");
					if(BDPUserPswFlag=="Y"){
						Ext.getCmp("SSUSRPassword").setValue(BDPUserPswValue);	
					}
    				//设置默认医嘱签名密码
					var BDPSignPswFlag = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPUserSignPswOpen");
					var BDPSignPswValue = tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPUserSignPsw");
					if(BDPSignPswFlag=="Y"){
						Ext.getCmp("SSUSRPin").setValue("BDPSignPswValue");	
					}
					//默认勾选 允许用户更改登录科室、激活、下次登录时强制用户改变密码
					Ext.getCmp("SSUSRChangeLocation").setValue(true)
					Ext.getCmp("SSUSRActive").setValue(true)
					Ext.getCmp("SSUSRPasswordChanged").setValue(true)
					
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();

				},
				scope : this
			});

	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					
					loadFormData(grid)
				}
			});

	/*
	var btnSSUserExtend = new Ext.Toolbar.Button({
        text: '用户扩展信息',
        tooltip: '用户扩展信息',
        iconCls: 'icon-DP',
        id:'btnSSUserExtend',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSSUserExtend'),
      	handler: function() {			        
			if(!grid.selModel.hasSelection()){
				Ext.Msg.show({
					title:'提示',
					minWidth:200,
					msg:'请选择一条数据!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});	
				return
			}else{
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行
			    var itemRowId=rows[0].get('SSUSRRowId')
			    var itemdesc=rows[0].get('SSUSRName')
            	var link="dhc.bdp.ext.default.csp?extfilename=App/System/SS_UserExtend&selectrow="+itemRowId; 
            	
				var winExtend = new Ext.Window({
					id:'winExtend',
					iconCls : 'icon-DP',
					width : 700,
					height : 590,
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
				winExtend.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';
				winExtend.setTitle(itemdesc+"-用户扩展信息");
				winExtend.show();
			}
      	}
    });	
	*/
	
	var btnAccredit = new Ext.Toolbar.Button({ // 授权
		text : '授权',
		iconCls : 'icon-accredit',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAccredit'),
		tooltip : '授权',
		width : 30,
		// iconCls: 'icon-accredit',
		handler : function() {
			if (grid.selModel.hasSelection()) {
				Ext.Msg.show({
							title : '提示',
							msg : '对不起，您没有权限进行授权!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要授权的医护人员!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	var btnDesignatedDepartment = new Ext.Toolbar.Button({    //指定科室
	    text: '指定科室',
        tooltip: '指定科室',
        icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'CT_Loc.png',
        id:'btnDesignatedDepartment',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDesignatedDepartment'),
        handler: function DesignatedDepartment() {
        if(grid.selModel.hasSelection()){      
        	 	var gsm = grid.getSelectionModel();//获取选择列
                var rows = gsm.getSelections();//根据选择列获取到所有的行
                
                var id = rows[0].get('SSUSRCareProvDR');                         
			    var flag = "";
		        var flag = tkMakeServerCall("web.DHCBL.CT.CTCarPrvTp","GetInternalTypeForCareID",id);	//用tkMakeServerCall函数实现与后台同步调用交互
		        RBCTLOCStore.baseParams={type:flag}
	            RBCTLOCStore.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Combo}});
	               
				winDesignatedDepartment.setTitle('指定科室');
			    winDesignatedDepartment.setIconClass('icon-DP');
			    winDesignatedDepartment.show('');
			   
                var RESCode=rows[0].get('CTPCPCode');
                gridResource.getStore().baseParams={Code:RESCode};
                gridResource.getStore().load({params:{start:0, limit:pagesize_Resource}});
                var RESCTPCPDR=rows[0].get('SSUSRCareProvDR');
                var RESDesc=rows[0].get('CTPCPDesc');
                
                Ext.getCmp("hidden_RESCode").reset();
                Ext.getCmp("hidden_RESCode").setValue(RESCode);
                Ext.getCmp("hidden_RESCTPCPDR").reset();
                Ext.getCmp("hidden_RESCTPCPDR").setValue(RESCTPCPDR);
                Ext.getCmp("hidden_RESDesc").reset();
                Ext.getCmp("hidden_RESDesc").setValue(RESDesc);
                Ext.getCmp("comboxResource").reset();
				Ext.getCmp("hidden_RESHOSPDR").reset();
                Ext.getCmp("hidden_RESHOSPDR").setValue(hospComp.getValue());
		}
        else
		{
		Ext.Msg.show({
					title:'提示',
					msg:'请选择需要指定科室的关联医护人员!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}

        }
	});
    var winDesignatedDepartment = new Ext.Window(getResourcePanel());  //调用CT_CareProv_Resource.js的指定科室面板
    
   	var winMed = new Ext.Window(getMedUnitPanel());  //调用CT_CareProv_MedUnit.js的医疗单元面板
	
	var btnMedUnit = new Ext.Toolbar.Button({				//关联医院
	    text: '所属医疗单元',
	    id:'btnMedUnit',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnMedUnit'),
        icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'DHC_CTLoc_MedUnit.png',
		tooltip: '所属医疗单元',
        handler: Med = function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winMed.setTitle('所属医疗单元');
			winMed.setIconClass('icon-DP');
			winMed.show('');
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 
            var CTPCPRowId=rows[0].get('SSUSRCareProvDR');
            var CTPCPCode=rows[0].get('CTPCPCode');
            var CTPCPDesc=rows[0].get('CTPCPDesc');
            Ext.getCmp("DoctorDRF").reset();
            Ext.getCmp("CTPCPCodeF").reset();
            Ext.getCmp("CTPCPDescF").reset();
            Ext.getCmp("DoctorDRF").setValue(CTPCPRowId);
           	Ext.getCmp("CTPCPCodeF").setValue(CTPCPCode);
           	Ext.getCmp("CTPCPDescF").setValue(CTPCPDesc);
			Ext.getCmp("HospDR").setValue(hospComp.getValue());
            gridMedUnit.getStore().baseParams={DoctorDR:CTPCPRowId};
           	gridMedUnit.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
           	//Ext.getCmp("txtHospital").getStore().load();
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一行进行维护!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
    
    var fields= [{
									name : 'SSUSRRowId',
									mapping : 'SSUSRRowId',
									type : 'string'
								}, {
									name : 'SSUSRInitials',
									mapping : 'SSUSRInitials',
									type : 'string'
								}, {
									name : 'SSUSRName',
									mapping : 'SSUSRName',
									type : 'string'
								}, {
									name : 'SSUSRPassword',
									mapping : 'SSUSRPassword',
									type : 'string'
								}, {
									name : 'CTLOCDesc',
									mapping : 'CTLOCDesc',
									type : 'string'
								}, {
									name : 'SSGRPDesc',
									mapping : 'SSGRPDesc',
									type : 'string'
								}, {
									name : 'SSUSRChangeLocation',
									mapping : 'SSUSRChangeLocation',
									type : 'string'
								}, {
									name : 'SSUSRCTLANDR',
									mapping : 'SSUSRCTLANDR',
									type : 'string'
								}, {
									name : 'CTPCPDesc',
									mapping : 'CTPCPDesc',
									type : 'string'
								}, {
									name : 'CTPCPCode',
									mapping : 'CTPCPCode',
									type : 'string'
								}, {
									name : 'SSUSRCareProvDR',
									mapping : 'SSUSRCareProvDR',
									type : 'string'
								}, {
									name : 'CTCPTDesc',
									mapping : 'CTCPTDesc',
									type : 'string'
								}, {
									name : 'CTPCPCarPrvTpDR',
									mapping : 'CTPCPCarPrvTpDR',
									type : 'string'
								}, {
									name : 'CTPCPOtherName',
									mapping : 'CTPCPOtherName',
									type : 'string'
								}, {
									name : 'CTPCPHICApproved',
									mapping : 'CTPCPHICApproved',
									type : 'string'
								}, {
									name : 'HOSPDesc',
									mapping : 'HOSPDesc',
									type : 'string'
								}, {
									name : 'SSUSRHospitalDR',
									mapping : 'SSUSRHospitalDR',
									type : 'string'
								}, {
									name : 'SSUSRPin',
									mapping : 'SSUSRPin',
									type : 'string'
								}, {
									name : 'SSUSRActive',
									mapping : 'SSUSRActive',
									type : 'string'
								}, {
									name : 'SSUSRAdmitted',
									mapping : 'SSUSRAdmitted',
									type : 'string'
								}, {
									name : 'SSUSRLastUpdateUserDR',
									mapping : 'SSUSRLastUpdateUserDR',
									type : 'string'
								}, {
									name : 'SSUSRLastUpdateDate',
									mapping : 'SSUSRLastUpdateDate',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'SSUSRLastUpdateTime',
									mapping : 'SSUSRLastUpdateTime',
									type : 'date',
									dateFormat : 'hh:mm:ss'
								}, {
									name : 'SSUSRDateFrom',
									mapping : 'SSUSRDateFrom',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'SSUSRDateTo',
									mapping : 'SSUSRDateTo',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'SSUSRFreeText3',
									mapping : 'SSUSRFreeText3',
									type : 'string'
								}, {
									name : 'SSUSRHOSPerson',
									mapping : 'SSUSRHOSPerson',
									type : 'string'
								}// 列的映射
						];
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
	
	ds.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		     communityid:communityid,
			 sort : sort
		  }   
		)
	});
	/*
	ds.load({
				params : {
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {
					// alert(options);
					// Ext.Msg.alert('info', '加载完毕, success = '+
					// records.length);
				}
			}); // 加载数据
			*/
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
	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-', btnDesignatedDepartment, '-', btnMedUnit, '-' ,btnTrans,'-',btnSort,'->',
			/*{	text: '更多功能',
			   	icon:Ext.BDP.FunLib.Path.URL_Icon +'list-items.gif',
			   	menu: new Ext.menu.Menu({
			        items: [
			        	{text: '切换为树形展示',id : 'btnSwitch',iconCls:'icon-refresh',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSwitch'),handler:function(){
				        	//var userId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.System.SSUserTree",""); //用户目录树菜单id
							//window.location.href="dhc.bdp.ext.sys.csp?BDPMENU="+userId;  
			        		window.location.href="dhc.bdp.ext.default.csp?extfilename=App/System/SS_UserTree.js";
				        }},
			        '-',
				       
			        ]
			   	})
			}
			*/
			btnlog,'-',btnhislog,'-',helphtmlbtn
			]//,'-',btnSwitch, '-', btnLoginLoc
		});
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				text : '搜索',
				handler : 	search=	function (){
					grid.getStore().baseParams = {
							Initials : Ext.getCmp("TextCode").getValue(),
							Name : Ext.getCmp("TextName").getValue(),
							Active : Ext.getCmp("TextActive").getValue(),
							SSUSRGroup : Ext.getCmp("SSGRP").getValue(),
							DefaultDeptDR:Ext.getCmp("DefDeptDRF").getValue(),
							CarPrvTpDR:Ext.getCmp("CarePrvTp").getValue(),
							//SpecDR:Ext.getCmp("CTPCPSpecDR").getValue(),
							SCTLOCDR:Ext.getCmp("RESCTLOCDRF").getValue(),
							//treetype:type,
							//category:HiddenCat,
							CareProvType:Ext.getCmp("CareProvType").getValue(),
							countryCodeYN:Ext.getCmp("countryCodeYN").getValue(),
	   						sort:sort,
							hosp:hospComp.getValue(),
							insurcode : Ext.getCmp("insurcode").getValue()
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
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				text : '重置',
				handler :  refresh=function() {
					sort="default";
					grid.getStore().baseParams = {
							//treetype:type,
							//category:HiddenCat,
							sort:sort,
							hosp:hospComp.getValue()
						};
					grid.getStore().load({
							params : {
								start : 0,
								limit : pagesize,
								communityid:communityid
							}
						});
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextName").reset();
					Ext.getCmp("TextActive").reset();
					//Ext.getCmp("sort").setValue(sort);
					Ext.getCmp("SSGRP").reset();
					Ext.getCmp("DefDeptDRF").reset();
					Ext.getCmp("CarePrvTp").reset();
					Ext.getCmp("RESCTLOCDRF").reset();
					//Ext.getCmp("CTPCPSpecDR").reset();
					Ext.getCmp("CareProvType").reset();
					Ext.getCmp("countryCodeYN").reset();
					Ext.getCmp("insurcode").reset();
				}

			});
			
	//var careprovtype = new Ext.BDP.Component.form.ComboBox({
	var careprovtype = new Ext.BDP.FunLib.Component.BaseComboBox({
    	width:90,
		//xtype:'combo',
		mode:'local',
		queryParam : "desc",
		minChars : 0,	//
    	//loadByIdParam : 'rowid',
		fieldLabel: '医护人员类型',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CarePrvTp'),
		id:'CarePrvTp',
		triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		//pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:250,
		valueField:'CTCPTRowId',
		displayField:'CTCPTDesc',
		store:new Ext.data.JsonStore({
			url:BindingCarPrvTp,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTCPTRowId',
			fields:['CTCPTRowId','CTCPTDesc']
		}),
		listeners:{
		   'select': function(field,e){
				search() 
			},
			scope: this
		}
	});		
			
/*	
	var SpecDR = ({ 
		//fieldLabel : '医生专长',
		xtype : 'bdpcombo',
		id:'CTPCPSpecDR',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSpecDR'),
		width:105,
		// hiddenName:'sss',//不能与id相同
		//triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTSPCRowId',
		displayField : 'CTSPCDesc',
		store : new Ext.data.JsonStore({
			//autoLoad : true,
			url : BindingSpec,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CTSPCRowId',
			fields : ['CTSPCRowId', 'CTSPCDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTSPCRowId',
				direction : 'ASC'
			}
		})
	});
	*/
	
	var CobGroup = new Ext.BDP.FunLib.Component.BaseComboBox({
		id : 'SSGRP',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('SSGRP'),
		//xtype : 'bdpcombo',
		width:90,
		// hiddenName:'sss',//不能与id相同
		triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		//pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//allQuery : '',
		//minChars : 1,
		listWidth : 250,
		valueField : 'SSGRPRowId',
		displayField : 'SSGRPDesc',
		store : new Ext.data.JsonStore({
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
				}),
		listeners:{
		   'select': function(field,e){
				search() 
			},
			'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:hospComp.getValue()
				};
				this.store.load({params : {
							//start : 0,
							//limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			}
			//scope: this
		}
	});
	
	
	var DefDeptDR =  new Ext.BDP.FunLib.Component.BaseComboBox({
		id : 'DefDeptDRF',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('DefDeptDRF'),
		//xtype : 'bdpcombo',
		width:90,
		// hiddenName:'sss',//不能与id相同
		triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		//pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//allQuery : '',
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTLOCRowID',
		displayField : 'CTLOCDesc',
		store : new Ext.data.JsonStore({
			url : BindingLoc,
			baseParams:{communityid:communityid},
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CTLOCRowID',
			fields : ['CTLOCRowID', 'CTLOCDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTLOCRowID',
				direction : 'ASC'
			}
		}),
		listeners:{
		   'select': function(field,e){
				search() 
			},
			'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:hospComp.getValue()
				};
				this.store.load({params : {
							//start : 0,
							//limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			}
			//scope: this
		}
	});
	
	var RESCTLOCDR =  new Ext.BDP.FunLib.Component.BaseComboBox({
		id : 'RESCTLOCDRF',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('RESCTLOCDRF'),
		//xtype : 'bdpcombo',
		width:90,
		// hiddenName:'sss',//不能与id相同
		triggerAction : 'all',// query
		queryParam : "desc",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'remote',
		//pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//allQuery : '',
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTLOCRowID',
		displayField : 'CTLOCDesc',
		store : new Ext.data.JsonStore({
			url : BindingLoc,
			baseParams:{communityid:communityid},
			root : 'data',
			totalProperty : 'total',
			idProperty : 'CTLOCRowID',
			fields : ['CTLOCRowID', 'CTLOCDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTLOCRowID',
				direction : 'ASC'
			}
		}),
		listeners:{
		   'select': function(field,e){
				search() 
			},
			'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:hospComp.getValue()
				};
				this.store.load({params : {
							//start : 0,
							//limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			}
			//scope: this
		}
	});
	
	// 第二排搜索工具条
	var searchbar = new Ext.Toolbar({
		enableOverflow : true,
		items : ['医护人员类型','-',careprovtype,'-','用户激活',{
							xtype : 'combo',
							listWidth:90,
							width:90,
							shadow:false,
							id :'TextActive',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextActive'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '是',
									value : 'Y'
								}, {
									name : '否',
									value : 'N'
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name',
							listeners:{
							   'select': function(field,e){
							        search() 
			                 	},
								scope: this
							}
						},'-',
						'人员类别',{
							xtype : 'combo',
							listWidth:90,
							width:90,
							shadow:false,
							id :'CareProvType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('CareProvType'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '医生',
									value : 'DOCTOR'
								}, {
									name : '护士',
									value : 'NURSE'
								}, {
									name : '技师',
									value : 'Technician'
								}, {
									name : '药师',
									value : 'Pharmacist'
								}, {
									name : '其他',
									value : 'Other'
								}, {
									name : '非医护人员',
									value : 'User'
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name',
							listeners:{
							   'select': function(field,e){
							        search() 
			                 	},
								scope: this
							}
						},
						'-',
						'是否对照国家医保代码',{
							xtype : 'combo',
							listWidth:90,
							width:90,
							shadow:false,
							id :'countryCodeYN',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('countryCodeYN'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '是',
									value : 'Y'
								}, {
									name : '否',
									value : 'N'
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name',
							listeners:{
							   'select': function(field,e){
							        search() 
			                 	},
								render : function(field) {  
									Ext.QuickTips.init();  
									Ext.QuickTips.register({  
										target : field.el,  
										text : '是否已对照国家医保代码'
									})  
								},
								scope: this
							}
						}
			]
		});
	
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [
						'代码',
						{
							xtype : 'textfield',
							id : 'TextCode',
							width:90,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							enableKeyEvents: true,
							listeners:{
								keyup:function(node, event) {
									if(event.getKey() == 13){
										search()
									}
								},
								scope: this
							}
						},
						'-',
						'姓名',
						{
							xtype : 'textfield',
							id : 'TextName',
							width:90,
							emptyText : '描述/别名',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextName'),
							enableKeyEvents: true,
							listeners:{
								keyup:function(node, event) {
									if(event.getKey() == 13){
										search()
									}
								},
								scope: this
							}
						} ,
						'-','国家医保代码',
						{
							xtype : 'textfield',
							id : 'insurcode',
							width:90,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('insurcode'),
							enableKeyEvents: true,
							listeners:{
								keyup:function(node, event) {
									if(event.getKey() == 13){
										search()
									}
								},
								scope: this
							}
						},
						'-',
						'登录科室',DefDeptDR,'-','指定科室',RESCTLOCDR,'-','安全组',CobGroup,'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',btnSearch,'-',btnRefresh//'-', '登录科室:', DefDeptDR ,"-", '所在安全组:', CobGroup, '-', '医护人员类型:', careprovtype,'-','医生专长:',SpecDR,'-', btnSearch, '-',btnRefresh, '->',helphtmlbtn
					// btnHelp
				],
				listeners : {
					render : function() {
						searchbar.render(grid.tbar)
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
			
	var GridCM = [new Ext.grid.CheckboxSelectionModel(), {
							header : 'RowId',
							width : 80,
							sortable : true,
							dataIndex : 'SSUSRRowId',
							hidden : true
						}, {
							header : '代码',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRInitials'
						}, {
							header : '姓名',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRName'
						},{
							header : '默认登录科室',
							width : 160,
							sortable : true,
							dataIndex : 'CTLOCDesc'
						}, {
							header : '安全组',
							width : 160,
							sortable : true,
							dataIndex : 'SSGRPDesc'
						}, {
							header : '默认语言',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRCTLANDR',
							hidden:true
						}, {
							header : '人员',
							width : 130,
							sortable : true,
							dataIndex : 'SSUSRHOSPerson'
						}, {
							header : '关联医护人员',
							width : 130,
							sortable : true,
							dataIndex : 'CTPCPDesc'
						}, {
							header : '医护人员code',
							width : 150,
							sortable : true,
							dataIndex : 'CTPCPCode',
							hidden:true
						}, {
							header : '医护人员id',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRCareProvDR',
							hidden:true
						}, {
							header : '医护人员类型',
							width : 140,
							sortable : true,
							dataIndex : 'CTCPTDesc'
						}, {
							header : '医护人员类型id',
							width : 150,
							sortable : true,
							dataIndex : 'CTPCPCarPrvTpDR',
							hidden:true
						}, {
							header : '拼音检索码',
							width : 120,
							sortable : true,
							dataIndex : 'CTPCPOtherName',
							hidden:true
						}, {
							header : '关联医院',
							width : 130,
							sortable : true,
							dataIndex : 'HOSPDesc'
						}, {
							header : '医院id',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRHospitalDR',
							hidden:true
						}, {
							header : '允许用户更改登录科室',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRChangeLocation',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							hidden:true
						},
						{
							header : '激活',
							width : 60,
							sortable : true,
							dataIndex : 'SSUSRActive',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '管理员用户',
							width : 100,
							sortable : true,
							dataIndex : 'SSUSRAdmitted',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							hidden:true
						}, {
							header : '最后更新人',
							width : 90,
							sortable : true,
							dataIndex : 'SSUSRLastUpdateUserDR',
							hidden:true
						}, {
							header : '最后更新日期',
							width : 90,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'SSUSRLastUpdateDate',
							hidden:true
						},{
							header : '开始日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'SSUSRDateFrom'
						}, {
							header : '结束日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'SSUSRDateTo'
						}, {
							header : '国家医保代码',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRFreeText3'
						}];
						
	var grid = new Ext.grid.GridPanel({
		id : 'grid',
		region : 'center',
		closable : true,
		store : ds,
		trackMouseOver : true,
		columns : GridCM,
		stripeRows : true,
		tools : Ext.BDP.FunLib.Component.HelpMsg,
		loadMask : {
			//msg : '数据加载中,请稍候...'
		},
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true,
					listeners : {
						rowselect : function(sm, row, rec) {
							// Ext.getCmp("form-DepartmentGroup").getForm().loadRecord(rec);
						}
					}
				}),
		title : '用户注册',
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
	if(Ext.getCmp("btnDesignatedDepartment").disabled==false){
		grid.on("rowclick", function(grid, rowIndex, e){
		 	var CTPCPDesc = grid.getSelectionModel().getSelections()[0].get('CTPCPDesc');
		 	if(CTPCPDesc==""){
		 		Ext.getCmp('btnDesignatedDepartment').disable();
		 	}else{
		 		Ext.getCmp('btnDesignatedDepartment').enable();
		 	}
		})
	}
	if(Ext.getCmp("btnMedUnit").disabled==false){
		grid.on("rowclick", function(grid, rowIndex, e){
		 	var CTPCPDesc = grid.getSelectionModel().getSelections()[0].get('CTPCPDesc');
		 	if(CTPCPDesc==""){
		 		Ext.getCmp('btnMedUnit').disable();
		 	}else{
		 		Ext.getCmp('btnMedUnit').enable();
		 	}
		})
	}
	var loadFormData = function(grid) {
		if (grid.selModel.hasSelection()) {
			// var row=grid.getStore().getAt(rowIndex).data;
			
			//Ext.getCmp('loginLoc').getEl().up('.x-form-item').setDisplayed(true);

			var _record = grid.getSelectionModel().getSelected();// records[0]
			var SSUSRRowId=_record.get('SSUSRRowId')
			//载入其他登录科室
			Ext.getCmp("comboxOtherLogonLoc").reset();
			Ext.getCmp("comboGroup").reset();
			Ext.getCmp("OTHLLStartDate").setValue(TodayDate);
			Ext.getCmp("OTHLLEndDate").reset();
			
			
			gridOtherLogonLoc.getStore().baseParams = {
				OTHLLParRef : SSUSRRowId
			};
			gridOtherLogonLoc.getStore().load({
				params : {
					start : 0,
					limit : pageSize_LogonLoc
				}
			});
			//载入系统账户岗位
			winUserAccountPost.getForm().reset();
			Ext.getCmp("USERPOSTActivity").setValue(true)
			Ext.getCmp("USERPOSTStartDate").setValue(TodayDate);
			gridUserAccountPost.getStore().baseParams = {
				parref : SSUSRRowId
			};
			gridUserAccountPost.getStore().load({
				params : {
					start : 0,
					limit : pageSize_LogonLoc
				}
			});
			
			//载入第三方系统账号
			winThirdPartySystemUser.getForm().reset();
			gridThirdPartySystemUser.getStore().baseParams = {
				userdr : SSUSRRowId
			};
			gridThirdPartySystemUser.getStore().load({
				params : {
					start : 0,
					limit : pageSize_LogonLoc
				}
			});
			
			//载入用户医护人员信息
			Ext.getCmp("form-User-save").getForm().load({
				url : OPENALL_ACTION_URL + '&id='+ SSUSRRowId,
				success : function(form, action) {
				},
				failure : function(form, action) {
					Ext.Msg.alert('编辑', '载入失败');
				}
			});
			
			//激活基本信息面板
			tabs.setActiveTab(0);
			
	        //加载别名面板
            AliasGrid.DataRefer = _record.get('SSUSRRowId');
	        AliasGrid.loadGrid();
	        
	        win.setTitle('修改');
			win.setIconClass('icon-Update');
			win.show('');
	        
			//加载用户扩展信息面板 2020年4月9日
			Ext.getCmp("form-saveExtend").getForm().load({
				url : SSUSRE_OPEN_ACTION_URL + '&id='+ SSUSRRowId,
				success : function(form,action) {
					var imgdata=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","getImg",SSUSRRowId)
					if(imgdata!=""){
						Ext.getCmp('browseImage').getEl().dom.src=imgdata
						var Orientation=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","getImgOrientation",SSUSRRowId)
						Ext.getCmp('browseImage').getEl().dom.style.transform = 'rotate('+Orientation+')';
					}else{
						Ext.getCmp('browseImage').getEl().dom.src='../scripts/bdp/Framework/imgs/null.jpg';
					}
					
					//单独加载简介特长，解决换行符被处理的问题
					var datastr1=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","GetDataIncluTR",SSUSRRowId,1)
					var datastr2=tkMakeServerCall("web.DHCBL.CT.SSUserExtend","GetDataIncluTR",SSUSRRowId,2)
					Ext.getCmp("SSUSREIntroduction").setValue(datastr1);
					Ext.getCmp("SSUSRESpeciality").setValue(datastr2);
					
				},
				failure : function(form,action) {
					Ext.Msg.alert('编辑','载入失败！');
				}
			});
			
			//管制药品分类面板 2020年4月9日
			_Poisongridds.load({
				params:{parref:_record.get('SSUSRCareProvDR')},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_Poisongridds.getCount();i++){  
						var record = _Poisongridds.getAt(i);  
						if(record.data.LinkFlag=='Y'){ records.push(record);   }  
					}  
					gridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PoisongridObj)	//全选框是否勾选 2020-11-25
				}
			});
			//关联处方权面板 2020年10月19日
			_PrescriptSetgridds.load({
				params:{
					parref:_record.get('SSUSRCareProvDR'),
					hospid:hospComp.getValue()
				},
				callback: function(records, options, success){
					var records=[];//存放选中记录  
					for(var i=0;i<_PrescriptSetgridds.getCount();i++){  
						var record = _PrescriptSetgridds.getAt(i);  
						if(record.data.PSLinkFlag=='Y'){ records.push(record);   }  
					}  
					PrescriptSetgridsm.selectRecords(records);//执行选中已对照的记录  
					hdcheckedfun(_PrescriptSetgridObj)	//全选框是否勾选 2020-11-25
				}
			});
			
		} else {
			Ext.Msg.show({
				title : '提示',
				msg : '请选择需要修改的行!',
				icon : Ext.Msg.WARNING,
				buttons : Ext.Msg.OK
			});
		}
	}
	// 双击事件
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				
				loadFormData(grid)
				
			});
	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('SSUSRRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	Ext.BDP.FunLib.Component.KeyMap(AddData, UpdateData, DelData);
	// var gridname=Ext.getCmp(Request);
	var viewport = new Ext.Viewport({
				layout : 'border',
				defaults:{split:true},
				items : [{
					frame:true,
					xtype: 'panel',
			        region: 'north',
			        layout:'form',
			        labelAlign : 'right',
					labelWidth : 30,
					items:[hospComp],
			        height: 35,
			        border: false
			    },grid] //,searchPanel
			});
	//Ext.fly('btnSSUSRDefaultDeptDR').addClass('x-btn-click');

	
});