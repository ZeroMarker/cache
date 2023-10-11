/// 名称: 用户目录树
/// 描述: 用户目录树
/// 编写者： 基础数据平台组 高姗姗
/// 编写日期: 2016-10-8
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/ColumnNodeUI.css"> </link>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/column-tree.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ColumnNodeUI.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCheckNodeUI.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ColumnTreeCheckNodeUI.js"> </script>');

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombo.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePagePanel.js"> </script>');

var ResourceJS = '../scripts/bdp/App/Care/CT_CareProv_Resource.js';//指定科室部分
document.write('<scr' + 'ipt type="text/javascript" src="'+ResourceJS+'"></scr' + 'ipt>');
var MedUnitJS = '../scripts/bdp/App/Care/CT_CareProv_MedUnit.js';//医疗单元部分
document.write('<scr' + 'ipt type="text/javascript" src="'+MedUnitJS+'"></scr' + 'ipt>');
var DirectoryTreeConfigJS = '../scripts/bdp/App/System/DirectoryTreeConfig.js';//目录树配置部分
document.write('<scr' + 'ipt type="text/javascript" src="'+DirectoryTreeConfigJS+'"></scr' + 'ipt>');
var htmlurl = "../scripts/bdp/AppHelp/System/SSUser.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
	function getCookie(cname) {
	 var name = cname + "=";
	 var ca = document.cookie.split(';');
	 for(var i=0; i<ca.length; i++) {
	  var c = ca[i];
	  while (c.charAt(0)==' ') c = c.substring(1);
	  if (c.indexOf(name) != -1) return c.substring(name.length, c.length);
	 }
	 return "";
	}
var flagType=getCookie('SSUserFlagType');
if( typeof(flagType) == "undefined") flagType=""
if (flagType=="") var flagType=tkMakeServerCall("web.DHCBL.CT.DirectoryTreeConfig","OpenData","User.SSUser");
Ext.onReady(function(){
	var selectNode="",HiddenCat="";
	var type="SSUSRDefaultDeptDR",sort="default";
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip';

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';			
	//**********左侧类别树 *************//
	var fstyle1="",fstyle2="",fstyle3="",fstyle4="",fstyle5="",fstyle6="";
	if(!Sys.ie)  //ie11 ,chorme
	{ 
		if ("ActiveXObject" in window)  ///ie11
		{
			fstyle1="margin-top: -12px;";
			fstyle2="margin-top: 0;";
			fstyle3="margin-top: -6px;";
			fstyle4="margin-top: -25px;";
			fstyle5="margin-top: -12px;";
			fstyle6="margin-top: -2px;";
			
		}
		else  //chrome  火狐
		{
			fstyle1="margin-top: -15px;margin-left: -5px;";
			fstyle2="margin-top: -5px;margin-left: -5px;";
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
		fstyle2="margin-top: 0;";
		fstyle3="margin-top: -2px;";
		fstyle4="margin-top: -2px;";
		fstyle5="margin-top: -2px;";
		fstyle6="margin-top: 0;";
		if(navigator.userAgent.indexOf("MSIE")>0){
      		if(navigator.userAgent.indexOf("MSIE 8.0")>0 && !window.innerWidth){
      			/*fstyle1="margin-top: -13px;";
				fstyle2="margin-top: -10px;";
				fstyle3="margin-top: -7px;";
				fstyle4="margin-top: -20px;";
				fstyle5="margin-top: -10px;";
				fstyle6="margin-top: 0;";*/
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
		Ext.fly('btnSSUSRHospitalDR').removeClass('x-btn-click');
	}
	function loadTree(){
		Ext.getCmp('TreeSearchText').setValue('');
		CatPanel.loadTree(type);
        hiddenPkgs = [],selectNode="",HiddenCat=""
	}
	var height1=document.documentElement.clientHeight
	var height2=document.body.clientHeight
	var windowheight=(height1>height2)? (height1-31):(height2-31)
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
	            height:windowheight*3/19,
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
	        	text:'<div style="'+fstyle2+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">科室</div>',
	            id:'btnRESCTLOCDR',
	            width:30,
	            height:windowheight*3/19,
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
	            height:windowheight*3/19,
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
	            height:windowheight*4/19,
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
	            height:windowheight*3/19,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTPCPSpecDR'),
	            listeners:{
	            	'click':function(){
	            		type="CTPCPSpecDR";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnCTPCPSpecDR').addClass('x-btn-click');
	            	}
	            }
	        },{
	        	text:'<div style="'+fstyle6+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">医院</div>',
	            id:'btnSSUSRHospitalDR',
	            width:30,
	            height:windowheight*2.8/19,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSSUSRHospitalDR'),
	            listeners:{
	            	'click':function(){
	            		type="SSUSRHospitalDR";
	            		 loadTree();
	            		removeClass();
	            		Ext.fly('btnSSUSRHospitalDR').addClass('x-btn-click');
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
		new Ext.form.TextField({
			id:'TreeSearchText',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TreeSearchText'),
		    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TreeSearchText')),
			width:125
		}), '-', new Ext.Button({
			iconCls : 'icon-search',
			tooltip : '检索',
			id : 'btnRetrieve',
			handler : function(){
				CatPanel.doQuery();
			},
			scope : this
		}),'-',  {
			iconCls:'icon-refresh',
			tooltip : '查询所有用户',
			id : 'btnReset',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnReset'),
			handler:function(){
				Ext.getCmp('TreeSearchText').setValue('');
				CatPanel.doQuery();
				/*grid.getStore().baseParams = {};*/
				HiddenCat="";
				refresh();
				tree.getSelectionModel().clearSelections();
			} 
		}
		],
	    listeners:{
           "click":function(node,event) {
       			var nid=node.id;
       			HiddenCat=nid;
       			selectNode=nid;
       			loader.on("beforeload", function(treeLoader, node) {
					loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
					loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
					loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
					loader.baseParams.treetype = type;
   					loader.baseParams.category = HiddenCat;
   					loader.baseParams.sort = sort;
			    }, this); 
				tree.root.reload();
				tree.getSelectionModel().clearSelections();
   				/*grid.getStore().baseParams = {
					Initials : Ext.getCmp("TextCode").getValue(),
					Name : Ext.getCmp("TextName").getValue(),
					Active : Ext.getCmp("TextActive").getValue(),
					treetype:type,
   					category:HiddenCat,
   					sort:sort
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize,
						communityid:communityid
					}
				});*/
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

	//var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassQuery=GetList";
	var ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=GetListJson2";
	var SAVEALL_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=SaveAll&pEntityName=web.Entity.CT.SSUser";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=Delete";
	var DELETEALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=DeleteAll";
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=DragNode2";
	var BindingCTCareProv = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetDataForCmb1";
	var BindingLanguage = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetDataForCmb1";
	var BindingLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var BindingGroup = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";

	var BindingSpec = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSpec&pClassQuery=GetDataForCmb1";
	var BindingCarPrvTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetDataForCmb1";
	var BindingLocC = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var BindingHospital = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var BindingTitle = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTTitle&pClassQuery=GetDataForCmb1";
	var OPENALL_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=OpenAll";
	var OPEN_CAREPROV_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassMethod=GetData";
	
	var VALIDATE_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassMethod=PasswordValidate";

	var ACTION_URL_SSUserOtherLogonLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassQuery=GetList";
	var SAVE_URL_OtherLogonLoc = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=SaveAll";
	var DELETE_OtherLogonLoc_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=DeleteData"
	
	var GroupId = session['LOGON.GROUPID']; // 获取GroupId

	/*
	 * if(session['LOGON.GROUPDESC']!="Demo Group") //判断用户是否是demo,不是demo就走授权 {
	 * BindingGroup
	 * ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassQuery=GetGroupList";
	 * BindingLoc="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassQuery=GetLocList"; }
	 */
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
	
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "SS_User"
	});
	
	var GroupId = session['LOGON.GROUPID'];
	//当天
	var TodayDate=(new Date()).format("Y/m/d");
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
			if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
				Ext.MessageBox.show({
					title:'提示',
					msg:'是否同时删除医护人员？',
					buttons:Ext.MessageBox.YESNOCANCEL,
					fn:function(btn){
						/**删除用户开始**/
						if (btn == 'no') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var SSUSRRowId=tree.getSelectionModel().getSelectedNode().id;
						AliasGrid.DataRefer = SSUSRRowId;
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : SSUSRRowId
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												/*Ext.BDP.FunLib.DelForTruePage(grid,pagesize);*/
											    //小气泡数量修改
											    var valLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName.split("#")[0];
												var countLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName.split("#")[1]-1;
												tree.getSelectionModel().getSelectedNode().parentNode.setText('<span ext:qtitle="" ext:qtip="' + valLoc + '">' + valLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+countLoc+'</h6></span>')
												tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName=valLoc+"#"+countLoc;
												if(tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName!=undefined){
													var valHosp=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName.split("#")[0];
													var countHosp=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName.split("#")[1]-1;
													tree.getSelectionModel().getSelectedNode().parentNode.parentNode.setText('<span ext:qtitle="" ext:qtip="' + valHosp + '">' + valHosp + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+countHosp+'</h6></span>')
													tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName=valHosp+"#"+countHosp;
												}
												loader.on("beforeload", function(treeLoader, node) {
													loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
													loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
													loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
													loader.baseParams.treetype =  type;
													loader.baseParams.category =  HiddenCat;
													loader.baseParams.sort =  sort;
											    }, this); 
											    //tree.root.reload();
											    tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload();
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
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var SSUSRRowId=tree.getSelectionModel().getSelectedNode().id;
						AliasGrid.DataRefer = SSUSRRowId;
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETEALL_ACTION_URL,
							method : 'POST',
							params : {
								'id' : SSUSRRowId
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												/*Ext.BDP.FunLib.DelForTruePage(grid,pagesize);*/
												 //小气泡数量修改
											    var valLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName.split("#")[0];
												var countLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName.split("#")[1]-1;
												tree.getSelectionModel().getSelectedNode().parentNode.setText('<span ext:qtitle="" ext:qtip="' + valLoc + '">' + valLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+countLoc+'</h6></span>')
												tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName=valLoc+"#"+countLoc;
												if(tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName!=undefined){
													var valHosp=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName.split("#")[0];
													var countHosp=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName.split("#")[1]-1;
													tree.getSelectionModel().getSelectedNode().parentNode.parentNode.setText('<span ext:qtitle="" ext:qtip="' + valHosp + '">' + valHosp + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+countHosp+'</h6></span>')
													tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName=valHosp+"#"+countHosp;
												}
												loader.on("beforeload", function(treeLoader, node) {
													loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
													loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
													loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
													loader.baseParams.treetype =  type;
													loader.baseParams.category =  HiddenCat;
													loader.baseParams.sort =  sort;
											    }, this); 
											    //tree.root.reload();
											    tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload(); 
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
	var SSUSRRowId = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : 'SSUSRRowId',
		hideLabel : 'True',
		hidden : true,
		id : 'SSUSRRowId',
		name : 'SSUSRRowId'

	});
	var SSUSRInitials = new Ext.BDP.FunLib.Component.TextField({
		//人事ID
		fieldLabel : '<font color=red>*</font>人事ID',
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
				var id = tree.getSelectionModel().getSelectedNode().id; // 此条数据的rowid
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
		invalidText : '该人事ID已经存在',
		listeners : {
			'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
			'blur' : function(){
				if(Ext.getCmp("CTPCPCode").getValue()==""){
					Ext.getCmp("CTPCPCode").setValue(Ext.getCmp("SSUSRInitials").getValue());
				}	
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
								Ext.getCmp("CareProvDR").setValue(jsonData.CTPCPRowId1);
								Ext.getCmp("CTPCPOtherName").setValue(jsonData.CTPCPOtherName);//拼音检索码
								Ext.getCmp("CTPCPUnit").setValue(jsonData.CTPCPUnit);//医生资格证书号
								Ext.getCmp("CarPrvTpDR").setValue(jsonData.CTPCPCarPrvTpDR);//医护人员类型
								Ext.getCmp("CTPCPDateActiveFrom").setValue(jsonData.CTPCPDateActiveFrom);//开始日期
								Ext.getCmp("CTPCPSurgeon").setValue(jsonData.CTPCPSurgeon);//是否外科医生
								Ext.getCmp("CTPCPHICApproved").setValue(jsonData.CTPCPHICApproved);//毒麻处方权
								Ext.getCmp("CTPCPActiveFlag").setValue(jsonData.CTPCPActiveFlag);//是否激活
								Ext.getCmp("CTPCPDesc").setValue(jsonData.CTPCPDesc);//姓名
								Ext.getCmp("CTPCPId").setValue(jsonData.CTPCPId);//标识码
								Ext.getCmp("CTPCPTextOne").setValue(jsonData.CTPCPTextOne);//Text1
								Ext.getCmp("CTPCPTextTwo").setValue(jsonData.CTPCPTextTwo);//Text2
								Ext.getCmp("SpecDR").setValue(jsonData.CTPCPSpecDR);//医生专长
								Ext.getCmp("CTPCPAnaesthetist").setValue(jsonData.CTPCPAnaesthetist);//是否麻醉师
								Ext.getCmp("CTPCPSpecialistYN").setValue(jsonData.CTPCPSpecialistYN);//是否可以出特需号
								Ext.getCmp("CTPCPDateActiveTo").setValue(jsonData.CTPCPDateActiveTo);//结束日期
								Ext.getCmp("CTPCPTelO").setValue(jsonData.CTPCPTelO);//办公电话
								Ext.getCmp("CTPCPTelH").setValue(jsonData.CTPCPTelH);//家庭电话
								Ext.getCmp("CTPCPTelOExt").setValue(jsonData.CTPCPTelOExt);//电话分机
								Ext.getCmp("CTPCPMobilePhone").setValue(jsonData.CTPCPMobilePhone);//移动电话
								Ext.getCmp("CTPCPEmail").setValue(jsonData.CTPCPEmail);//Email
								Ext.getCmp("CTPCPFax").setValue(jsonData.CTPCPFax);//传真
								Ext.getCmp("TitleDR").setValue(jsonData.CTPCPTitleDR);//医护人员职称
							}else{
								Ext.getCmp("CareProvDR").setValue("");
								Ext.getCmp("CTPCPOtherName").setValue("");//拼音检索码
								Ext.getCmp("CTPCPUnit").setValue("");//医生资格证书号
								Ext.getCmp("CarPrvTpDR").setValue("");//医护人员类型
								Ext.getCmp("CTPCPDateActiveFrom").setValue("");//开始日期
								Ext.getCmp("CTPCPSurgeon").setValue("");//是否外科医生
								Ext.getCmp("CTPCPHICApproved").setValue("");//毒麻处方权
								//Ext.getCmp("CTPCPActiveFlag").setValue("");//是否激活
								Ext.getCmp("CTPCPDesc").setValue("");//姓名
								Ext.getCmp("CTPCPId").setValue("");//标识码
								Ext.getCmp("CTPCPTextOne").setValue("");//Text1
								Ext.getCmp("CTPCPTextTwo").setValue("");//Text2
								Ext.getCmp("SpecDR").setValue("");//医生专长
								Ext.getCmp("CTPCPAnaesthetist").setValue("");//是否麻醉师
								Ext.getCmp("CTPCPSpecialistYN").setValue("");//是否可以出特需号
								Ext.getCmp("CTPCPDateActiveTo").setValue("");//结束日期
								Ext.getCmp("CTPCPTelO").setValue("");//办公电话
								Ext.getCmp("CTPCPTelH").setValue("");//家庭电话
								Ext.getCmp("CTPCPTelOExt").setValue("");//电话分机
								Ext.getCmp("CTPCPMobilePhone").setValue("");//移动电话
								Ext.getCmp("CTPCPEmail").setValue("");//Email
								Ext.getCmp("CTPCPFax").setValue("");//传真
								Ext.getCmp("CTPCPTitleDR").setValue("");//医护人员职称
							}
							
						}
					}
				});
			}
		}	
	});
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
		/*validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
			var className = "web.DHCBL.CT.SSUser"; // 后台类名称
			var classMethod = "FormValidate"; // 数据重复验证后台函数名
			var id = "";
			if (win.title == '修改') { // 如果窗口标题为'修改'则获取rowid
				var id = tree.getSelectionModel().getSelectedNode().id; // 此条数据的rowid
			}
			var flag = "";
			var flag = tkMakeServerCall(className, classMethod,id, thisText, ""); // 用tkMakeServerCall函数实现与后台同步调用交互
			if (flag == "1") { // 当后台返回数据位"1"时转换为相应的布尔值
				return false;
			} else {
				return true;
			}
		},
		invalidText : '该姓名已经存在',	*/		
		listeners:{
			'blur' : function(){
				if(Ext.getCmp("CTPCPDesc").getValue()==""){
					Ext.getCmp("CTPCPDesc").setValue(Ext.getCmp("SSUSRName").getValue());
					Ext.getCmp("CTPCPOtherName").setValue(Pinyin.GetJPU(Ext.getCmp("SSUSRName").getValue()))
				}					
			}
		}
	});
	var loginLoc = new Ext.Button({
		//其它登录科室维护
		fieldLabel:' ',
		//xtype:'button',
		id:'loginLoc',
		text : '其它登录科室维护',
		tooltip : '其它登录科室维护',
		labelSeparator : '',
		boxMaxWidth:50,	 
		//iconCls : 'icon-LoginLoc',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLoginLoc'),
		handler : function LoginLocUpdateData() {
			/*if (grid.selModel.hasSelection()) {
				WinForm.isAdd = false;
				winOtherLogonLocPanel.setTitle('其它登录科室');
				winOtherLogonLocPanel.setIconClass('icon-LoginLoc');
				winOtherLogonLocPanel.show('');
				Ext.getCmp("comboxOtherLogonLoc").reset();
				Ext.getCmp("comboGroup").reset();
				Ext.getCmp("comboHospital").reset();
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
			}*/
		}

	});
	var DefaultDeptDR = new Ext.BDP.Component.form.ComboBox({
		//默认登录科室
		fieldLabel : '默认登录科室',	
		//xtype : 'bdpcombo',
		name : 'SSUSRDefaultDeptDR',
		id : 'DefaultDeptDR',
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
			//baseParams:{communityid:communityid},
			autoLoad : true,
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
		//安全组
		fieldLabel : '<font color=red>*</font>安全组',
		//xtype : 'combo',
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
		blankText : '不能为空',
		allowBlank : false,
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
	});
	var SSUSRHospitalDR = new Ext.BDP.Component.form.ComboBox({
		//医院关联
		fieldLabel : '医院关联',
		//xtype : 'combo',
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
		//allowBlank : false,
		valueField : 'HOSPRowId',
		displayField : 'HOSPDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingHospital,
			//baseParams:{communityid:communityid},
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
		//默认语言
		fieldLabel: '默认语言',
		//xtype:'combo',
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
			autoLoad: true,
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
		//xtype : 'datefield',
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
		//xtype : 'datefield',
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
		//登录密码
		fieldLabel : '<font color=red>*</font>登录密码',
		id : 'SSUSRPassword',
		name : 'SSUSRPassword',
		inputType : 'password',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPassword'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPassword')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPassword'),
		blankText : '不能为空',
		allowBlank : false,
		dataIndex : 'SSUSRPassword'
		/*validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "" || thisText=="******") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
			
			//var passLen =  parseInt(tkMakeServerCall("web.DHCBL.CT.SSUser", "PasswordValidate"));
			//var passLen=6
			//var passValid = "Y"
			var passLen = tkMakeServerCall("web.CFSM", "GetPasswordMinLength");						
			var passValid = tkMakeServerCall("websys.Configuration","GetFieldValue","PwdContainWordAndNum");
			
			var passReg = /^(?=.*?[a-zA-Z])(?=.*?\d).*/
			/*
			if(thisText.length < passLen){								
				Ext.getCmp("SSUSRPassword").invalidText= "登陆密码长度不能小于" + passLen;
				return false;								
			}else if(passValid=="Y"){
				if(!passReg.test(thisText)){		
					Ext.getCmp("SSUSRPassword").invalidText="密码需要包含数字和字母";
					return false;
				}else{
					return true;
				}
			}else{
				return true;
			}
		},
		invalidText : '验证不通过！'*/
	});
	var SSUSRPin = new Ext.BDP.FunLib.Component.TextField({ 
		//医嘱签名密码
		fieldLabel : '医嘱签名密码',
		id : 'SSUSRPin',
		name : 'SSUSRPin',
		inputType : 'password',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPin')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPin'),
		dataIndex : 'SSUSRPin',
		validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "" || thisText=="******") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
									
			var passLen = tkMakeServerCall("web.CFSM", "GetPasswordMinLength");						
			var passValid = tkMakeServerCall("websys.Configuration","GetFieldValue","PwdContainWordAndNum");
			
			// var passLen =  parseInt(tkMakeServerCall("web.DHCBL.CT.SSUser", "PasswordValidate"));
			// var passValid = "Y"
			
			var passReg = /^(?=.*?[a-zA-Z])(?=.*?\d).*/; 
			if(thisText.length < passLen){								
				Ext.getCmp("SSUSRPin").invalidText= "医嘱签名密码长度不能小于" + passLen;
				return false;								
			}else if(passValid=="Y"){
				if(!passReg.test(thisText)){		
					Ext.getCmp("SSUSRPin").invalidText="密码需要包含数字和字母";
					return false;
				}else{
					return true;
				}
			}else{
				return true;
			}
		},
		invalidText : '验证不通过。'
	});
	var SSUSRChangeLocation = new Ext.form.Checkbox({
		//允许用户更改登录科室
		//xtype : 'checkbox',
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
		//是否激活
		//xtype : 'checkbox',
		boxLabel : '是否激活',
		id : 'SSUSRActive',
		name : 'SSUSRActive',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRActive'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRActive')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRActive'),
		inputValue : true ? 'Y' : 'N',
		checked : true,
		listeners:{
			'check':function(){
				Ext.getCmp("CTPCPActiveFlag").setValue(Ext.getCmp("SSUSRActive").getValue())
			}
		}
	});
	var SSUSRPasswordChanged = new Ext.form.Checkbox({
		//下次登录时强制用户改变密码
		//xtype : 'checkbox',
		boxLabel : '下次登录时强制用户改变密码',
		id : 'SSUSRPasswordChanged',
		name : 'SSUSRPasswordChanged',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPasswordChanged'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRPasswordChanged')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRPasswordChanged'),
		inputValue : true ? 'Y' : 'N'
	});
	var SSUSRAdmitted = new Ext.form.Checkbox({
		//管理员用户
		//xtype : 'checkbox',
		boxLabel : '管理员用户',
		id : 'SSUSRAdmitted',
		name : 'SSUSRAdmitted',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRAdmitted'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRAdmitted')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRAdmitted'),
		inputValue : true ? 'Y' : 'N'
	});
	var SSUSRIgnoreCALogon = new Ext.form.Checkbox({
		//是否忽略CA登录控制
		//xtype : 'checkbox',
		boxLabel : '是否忽略CA登录控制',
		id : 'SSUSRIgnoreCALogon',
		name : 'SSUSRIgnoreCALogon',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSUSRIgnoreCALogon'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSUSRIgnoreCALogon')),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('SSUSRIgnoreCALogon'),
		inputValue : true ? 'Y' : 'N'
	});
	var CareProvDR = new Ext.BDP.Component.form.ComboBox({
		//关联医护人员
		//xtype:'combo',
		hidden:true,
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
			autoLoad: true,
			url:BindingCTCareProv,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTPCPRowId1',
			fields:['CTPCPRowId1','CTPCPDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTPCPRowId1', direction: 'ASC'}
		})
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
		validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
			var className = "web.DHCBL.CT.CTCareProv"; // 后台类名称
			var classMethod = "FormValidate"; // 数据重复验证后台函数名
			var id = Ext.getCmp('CareProvDR').getValue(); // 此条数据的rowid
			if(id==""){
				return true;
			}
			var flag = "";
			var flag = tkMakeServerCall(className, classMethod, id, thisText,""); // 用tkMakeServerCall函数实现与后台同步调用交互
			if (flag == "1") { // 当后台返回数据位"1"时转换为相应的布尔值
				return false;
			} else {
				return true;
			}
		},
		invalidText : '该工号已经存在',
		listeners : {
			'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
			'blur':function(){
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
								Ext.getCmp("CareProvDR").setValue(jsonData.CTPCPRowId1);
								Ext.getCmp("CTPCPOtherName").setValue(jsonData.CTPCPOtherName);//拼音检索码
								Ext.getCmp("CTPCPUnit").setValue(jsonData.CTPCPUnit);//医生资格证书号
								Ext.getCmp("CarPrvTpDR").setValue(jsonData.CTPCPCarPrvTpDR);//医护人员类型
								Ext.getCmp("CTPCPDateActiveFrom").setValue(jsonData.CTPCPDateActiveFrom);//开始日期
								Ext.getCmp("CTPCPSurgeon").setValue(jsonData.CTPCPSurgeon);//是否外科医生
								Ext.getCmp("CTPCPHICApproved").setValue(jsonData.CTPCPHICApproved);//毒麻处方权
								Ext.getCmp("CTPCPActiveFlag").setValue(jsonData.CTPCPActiveFlag);//是否激活
								Ext.getCmp("CTPCPDesc").setValue(jsonData.CTPCPDesc);//姓名
								Ext.getCmp("CTPCPId").setValue(jsonData.CTPCPId);//标识码
								Ext.getCmp("CTPCPTextOne").setValue(jsonData.CTPCPTextOne);//Text1
								Ext.getCmp("CTPCPTextTwo").setValue(jsonData.CTPCPTextTwo);//Text2
								Ext.getCmp("SpecDR").setValue(jsonData.CTPCPSpecDR);//医生专长
								Ext.getCmp("CTPCPAnaesthetist").setValue(jsonData.CTPCPAnaesthetist);//是否麻醉师
								Ext.getCmp("CTPCPSpecialistYN").setValue(jsonData.CTPCPSpecialistYN);//是否可以出特需号
								Ext.getCmp("CTPCPDateActiveTo").setValue(jsonData.CTPCPDateActiveTo);//结束日期
								Ext.getCmp("CTPCPTelO").setValue(jsonData.CTPCPTelO);//办公电话
								Ext.getCmp("CTPCPTelH").setValue(jsonData.CTPCPTelH);//家庭电话
								Ext.getCmp("CTPCPTelOExt").setValue(jsonData.CTPCPTelOExt);//电话分机
								Ext.getCmp("CTPCPMobilePhone").setValue(jsonData.CTPCPMobilePhone);//移动电话
								Ext.getCmp("CTPCPEmail").setValue(jsonData.CTPCPEmail);//Email
								Ext.getCmp("CTPCPFax").setValue(jsonData.CTPCPFax);//传真
								Ext.getCmp("TitleDR").setValue(jsonData.CTPCPTitleDR);//医护人员职称
							}else{
								Ext.getCmp("CareProvDR").setValue("");
								Ext.getCmp("CTPCPOtherName").setValue("");//拼音检索码
								Ext.getCmp("CTPCPUnit").setValue("");//医生资格证书号
								Ext.getCmp("CarPrvTpDR").setValue("");//医护人员类型
								Ext.getCmp("CTPCPDateActiveFrom").setValue("");//开始日期
								Ext.getCmp("CTPCPSurgeon").setValue("");//是否外科医生
								Ext.getCmp("CTPCPHICApproved").setValue("");//毒麻处方权
								//Ext.getCmp("CTPCPActiveFlag").setValue("");//是否激活
								Ext.getCmp("CTPCPDesc").setValue("");//姓名
								Ext.getCmp("CTPCPId").setValue("");//标识码
								Ext.getCmp("CTPCPTextOne").setValue("");//Text1
								Ext.getCmp("CTPCPTextTwo").setValue("");//Text2
								Ext.getCmp("SpecDR").setValue("");//医生专长
								Ext.getCmp("CTPCPAnaesthetist").setValue("");//是否麻醉师
								Ext.getCmp("CTPCPSpecialistYN").setValue("");//是否可以出特需号
								Ext.getCmp("CTPCPDateActiveTo").setValue("");//结束日期
								Ext.getCmp("CTPCPTelO").setValue("");//办公电话
								Ext.getCmp("CTPCPTelH").setValue("");//家庭电话
								Ext.getCmp("CTPCPTelOExt").setValue("");//电话分机
								Ext.getCmp("CTPCPMobilePhone").setValue("");//移动电话
								Ext.getCmp("CTPCPEmail").setValue("");//Email
								Ext.getCmp("CTPCPFax").setValue("");//传真
								Ext.getCmp("TitleDR").setValue("");//医护人员职称
							}
						}
					}
				});
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
	var CTPCPUnit = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPUnit 医生资格证书号
		fieldLabel : '医生资格证书号',
		name : 'CTPCPUnit',
		id : 'CTPCPUnit',
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit'),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPUnit')),
		dataIndex : 'CTPCPUnit'
	});
	var CTCPTDescCombo = new Ext.BDP.Component.form.ComboBox({ // ----------CTCPTDesc
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
			autoLoad : true,
			idProperty : 'CTCPTRowId',
			fields : ['CTCPTRowId', 'CTCPTDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'CTCPTRowId',
				direction : 'ASC'
			}
		}),
		listeners : {
			'select' : function(combo, record, index) {
				Ext.getCmp('CTLOCDR1').enable();
				// var id=Ext.getCmp('CTLOCDR').getValue();
				CTLOCDR.clearValue();
				var className = "web.DHCBL.CT.CTCarPrvTp"; // 后台类名称
				var classMethod = "GetInternalType"; // 数据重复验证后台函数名
				var id = combo.value;
				var flag = "";
				var flag = tkMakeServerCall(className, classMethod, id); // 用tkMakeServerCall函数实现与后台同步调用交互
				CTLOCStore.baseParams = {
					type : flag
				}
				CTLOCStore.load({
							params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
							}
						});
				// var provincedr=Ext.getCmp('comboCTZIPProvinceDR').getValue();
				// //原来的省份值。不是新的
			}/*
				 * , 'change':function(combo,record,index){
				 * Ext.getCmp('CTLOCDR').clearValue();//改变级联1,级联2/3先清空
				 * Ext.getCmp('CTLOCDR').clearValue();
				 * 
				 * var regiondr=Ext.getCmp('CTLOCDR').getValue();
				 * CTLOCStore.load({params:{regiondr:regiondr}}); var child =
				 * CTLOCStore.getAt(0).get('PROVRowId');
				 * Ext.getCmp('CTLOCStore').setValue(child); var
				 * provincedr=Ext.getCmp('comboCTZIPProvinceDR').getValue();
				 * //现在是新的值 //var index =
				 * provinceStore.find('PROVRegionDR',regiondr); //var child =
				 * provinceStore.getAt(index).get('PROVRowId');
				 * cityStore.load({params:{provincedr:provincedr}});//2改变,重新加载'级联3',变为空值 }
				 */
		}

	});

	var CTLOCStore = new Ext.data.JsonStore({
				url : BindingLocC,
				autoLoad : true,
				root : 'data',
				totalProperty : 'total',
				idProperty : 'CTLOCRowID',
				fields : ['CTLOCRowID', 'CTLOCDesc'],
				remoteSort : true,
				sortInfo : {
					field : 'CTLOCRowID',
					direction : 'ASC'
				}
			});

	var CTLOCDR = new Ext.BDP.Component.form.ComboBox({ // ----------CTCPTDesc 科室 combo
		fieldLabel : '科室',
		name : 'CTLOCDR',
		id : 'CTLOCDR1',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDR1'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDR1')),
		hiddenName : 'CTLOCDR',
		//triggerAction : 'all',// query
		forceSelection : true,
		selectOcnFocus : false,
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTLOCRowID',
		displayField : 'CTLOCDesc',
		store : CTLOCStore

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
	var CTPCPSurgeon = new Ext.form.Checkbox({ // ----------CTPCPSurgeon 是否外科医生
		boxLabel : '是否外科医生',
		id : 'CTPCPSurgeon',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon'),
		// disabled : Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPSurgeon')),
		name : 'CTPCPSurgeon',
		dataIndex : 'CTPCPSurgeon',
		inputValue : true ? 'Y' : 'N'
	});

	/*
	 * var CTPCPHICApproved = new Ext.form.Checkbox({
	 * //----------CTPCPAnaesthetist 毒麻处方权 fieldLabel: '毒麻处方权', name:
	 * 'CTPCPHICApproved', id: 'CTPCPHICApproved', disabled :
	 * Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApproved'),
	 * dataIndex:'CTPCPHICApproved', inputValue : true?'Y':'N' });
	 */

	/*
	 * var CTPCPHICApproved = new Ext.form.Checkbox({
	 * //----------CTPCPAnaesthetist 毒麻处方权 fieldLabel: '毒麻处方权', name:
	 * 'CTPCPHICApproved', id: 'CTPCPHICApproved', disabled :
	 * Ext.BDP.FunLib.Component.DisableFlag('CTPCPHICApproved'),
	 * dataIndex:'CTPCPHICApproved', inputValue : true?'Y':'N' });
	 */

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

	var CTPCPActiveFlag = new Ext.form.Checkbox({ // ----------CTPCPActiveFlag
		// 是否激活
		boxLabel : '是否激活',
		id : 'CTPCPActiveFlag',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPActiveFlag'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPActiveFlag')),
		name : 'CTPCPActiveFlag',
		dataIndex : 'CTPCPActiveFlag',
		inputValue : true ? 'Y' : 'N',
		checked : true
	});
	var CTPCPDesc = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPDesc 姓名
		fieldLabel : "<span style='color:red;'>*</span>姓名",
		name : 'CTPCPDesc',
		id : 'CTPCPDesc',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDesc'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPDesc')),
		blankText : '不能为空',
		allowBlank : false,
		dataIndex : 'CTPCPDesc',
		validationEvent : 'blur',
		// enableKeyEvents:true,
		validator : function(thisText) {
			if (thisText == "") { // 当文本框里的内容为空的时候不用此验证
				return true;
			}
			var className = "web.DHCBL.CT.CTCareProv"; // 后台类名称
			var classMethod = "FormValidate"; // 数据重复验证后台函数名
			var id = "";
			if (win.title == '修改') { // 如果窗口标题为'修改'则获取rowid
				var id = tree.getSelectionModel().getSelectedNode().attributes.CTPCPRowId1; // 此条数据的rowid
			}
			var flag = "";
			var flag = tkMakeServerCall(className, classMethod, id, "",thisText); // 用tkMakeServerCall函数实现与后台同步调用交互
			if (flag == "1") { // 当后台返回数据位"1"时转换为相应的布尔值
				return false;
			} else {
				return true;
			}
		},
		invalidText : '该姓名已经存在',
		listeners : {
			'blur' : function(){
				Ext.getCmp("CTPCPOtherName").setValue(Pinyin.GetJPU(Ext.getCmp("CTPCPDesc").getValue()))
			},
			'change' : Ext.BDP.FunLib.Component.ReturnValidResult
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
	var CTPCPTextOne = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTextOne Text1
		fieldLabel : 'Text1',
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
	var CTSPCDescCombo = new Ext.BDP.Component.form.ComboBox({ // ----------CTSPCDescCombo
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
			autoLoad : true,
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
		// 是否麻醉师
		boxLabel : '是否麻醉师',
		name : 'CTPCPAnaesthetist',
		id : 'CTPCPAnaesthetist',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPAnaesthetist'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPAnaesthetist')),
		dataIndex : 'CTPCPAnaesthetist',
		inputValue : true ? 'Y' : 'N'
	});
	var CTPCPSpecialistYN = new Ext.form.Checkbox({ // ----------CTPCPAnaesthetist
		// 是否可以出特需号
		boxLabel : '是否可以出特需号',
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
	var CTPCPTelO = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTelO
		//办公电话
		fieldLabel : '办公电话',
		name : 'CTPCPTelO',
		id : 'CTPCPTelO',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelO'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelO')),
		dataIndex : 'CTPCPTelO'
	});
	var CTPCPTelH = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTelH
		//家庭电话
		fieldLabel : '家庭电话',
		name : 'CTPCPTelH',
		id : 'CTPCPTelH',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelH'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelH')),
		dataIndex : 'CTPCPTelH'
	});
	var CTPCPTelOExt = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPTelOExt
		//电话分机
		fieldLabel : '电话分机',
		name : 'CTPCPTelOExt',
		id : 'CTPCPTelOExt',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelOExt'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPTelOExt')),
		dataIndex : 'CTPCPTelOExt'
	});
	var CTPCPMobilePhone = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPMobilePhone
		//移动电话
		fieldLabel : '移动电话',
		name : 'CTPCPMobilePhone',
		id : 'CTPCPMobilePhone',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPMobilePhone'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPMobilePhone')),
		dataIndex : 'CTPCPMobilePhone'
	});
	var CTPCPEmail = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPEmail
		//Email
		fieldLabel : 'Email',
		name : 'CTPCPEmail',
		id : 'CTPCPEmail',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPEmail'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPEmail')),
		dataIndex : 'CTPCPEmail'
	});
	var CTPCPFax = new Ext.BDP.FunLib.Component.TextField({ // ----------CTPCPFax
		//传真
		fieldLabel : '传真',
		name : 'CTPCPFax',
		id : 'CTPCPFax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPFax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPFax')),
		dataIndex : 'CTPCPFax'
	});
	var CTPCPTitleDR = new Ext.BDP.Component.form.ComboBox({ // ----------CTPCPTitleDR
		//医护人员职称
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
			autoLoad : true,
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
	/** ---------其他登录科室维护表单内容部分------------* */
	var OTHLLStartDate = new Ext.BDP.FunLib.Component.DateField({
	          				fieldLabel: '开始日期',
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
		            	 });
	var k = 0;
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
      				 layout : "form",  
      				 items : [{
							fieldLabel: '登录科室',	
							xtype:'bdpcombo',
							id: 'comboxOtherLogonLoc',
							loadByIdParam : 'rowid',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('comboxOtherLogonLoc'),
							//hiddenName:'RESCTLOCDR',//不能与id相同
							//allQuery:'',
							queryParam : "desc",
							forceSelection: true,
							selectOcnFocus:false,
							mode:'remote',
							pageSize:10,
							//minChars: 0,
							listWidth:250,
							valueField:'CTLOCRowID',
							displayField:'CTLOCDesc',
							store:new Ext.data.JsonStore({
								autoLoad: true,
								url:BindingLoc,
								//baseParams:{communityid:communityid},
								root: 'data',
								totalProperty: 'total',
								idProperty: 'CTLOCRowID',
								fields:['CTLOCRowID','CTLOCDesc'],
								remoteSort: true,
								sortInfo: {field: 'CTLOCRowID', direction: 'ASC'}
							})
						},OTHLLStartDate]
			        }, {
			           columnWidth : .33,
			           layout : "form",
			           items : [{
							fieldLabel: '<font color=red>*</font>安全组',	
							xtype:'bdpcombo',
							id: 'comboGroup',
							loadByIdParam : 'rowid',
							width:120,
							blankText : '不能为空',
							allowBlank : false,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('comboGroup'),
							//hiddenName:'RESCTLOCDR',//不能与id相同
							//allQuery:'',
							forceSelection: true,
							selectOcnFocus:false,
							queryParam:"desc",
							mode:'remote',
							pageSize:10,
							//minChars: 0,
							listWidth:250,
							valueField:'SSGRPRowId',
							displayField:'SSGRPDesc',
							store:new Ext.data.JsonStore({
								autoLoad: true,
								url:BindingGroup,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'SSGRPRowId',
								fields:['SSGRPRowId','SSGRPDesc'],
								remoteSort: true,
								sortInfo: {field: 'SSGRPRowId', direction: 'ASC'}
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
	      				 		}]
	      				 },{
			          	 columnWidth : .33,
			           	 layout : "form",
			           	 items : [{
								//fieldLabel: '医院',	
								hidden:true,
								xtype:'bdpcombo',
								id: 'comboHospital',
								loadByIdParam : 'rowid',
								width:120,
								disabled : Ext.BDP.FunLib.Component.DisableFlag('comboHospital'),
								//hiddenName:'RESCTLOCDR',//不能与id相同
								//allQuery:'',
								forceSelection: true,
								selectOcnFocus:false,
								mode:'remote',
								pageSize:10,
								queryParam:"desc",
								//minChars: 0,
								listWidth:250,
								valueField:'HOSPRowId',
								displayField:'HOSPDesc',
								store:new Ext.data.JsonStore({
									autoLoad: true,
									url:BindingHospital,
									root: 'data',
									totalProperty: 'total',
									idProperty: 'HOSPRowId',
									fields:['HOSPRowId','HOSPDesc'],
									remoteSort: true,
									sortInfo: {field: 'HOSPRowId', direction: 'ASC'}
								})
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
	                	if(winOtherLogonLoc.form.isValid()==false){return;}
	                	var comboxOtherLogonLoc = Ext.getCmp("comboxOtherLogonLoc").getValue();
	                	var comboGroup = Ext.getCmp("comboGroup").getValue();
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
										msg:'该记录已存在!',
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
									return;
								}
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
								if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
				   			 		var flag = "";
					   			 	var SSUSRRowId=tree.getSelectionModel().getSelectedNode().id;
		        					var flag = tkMakeServerCall("web.DHCBL.CT.SSUserOtherLogonLoc","Validate",SSUSRRowId,comboxOtherLogonLoc,comboGroup);
		        					if (flag==1){
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
	        			k=k+1;
			    	 	var _record = new Ext.data.Record({
			    	 		'OTHLLRowId':'',
			    	 		//'SSUSRName':Ext.getCmp('SSUSRName').getValue(),
			    	 		'CTLOCDesc':Ext.getCmp('comboxOtherLogonLoc').getRawValue(),
			    	 		'SSGRPDesc':Ext.getCmp('comboGroup').getRawValue(),
			    	 		'HOSPDesc':Ext.getCmp('comboHospital').getRawValue(),
			    	 		'OTHLLCTLOCDR':Ext.getCmp('comboxOtherLogonLoc').getValue(),
			    	 		'OTHLLUserGroupDR':Ext.getCmp('comboGroup').getValue(),
			    	 		'OTHLLHospitalDR':Ext.getCmp('comboHospital').getValue(),
			    	 		'OTHLLStartDate':Ext.getCmp('OTHLLStartDate').getValue(),
			    	 		'OTHLLEndDate':Ext.getCmp('OTHLLEndDate').getValue(),
			    	 		'Id':k
			    	 	});
			    	 	gridOtherLogonLoc.stopEditing();
			    	 	dsOtherLogonLoc.insert(0,_record); 	   
			    	 	Ext.getCmp("comboxOtherLogonLoc").reset();
						Ext.getCmp("comboGroup").reset();
						Ext.getCmp("comboHospital").reset();
						Ext.getCmp("OTHLLStartDate").reset();
						Ext.getCmp("OTHLLEndDate").reset();
						
					}
	     	}, { 
	            	id:'update_btn2',
	            	text:'修改',
	            	width: 60,
	            	iconCls : 'icon-update',
	            	disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn2'),
	                handler: function (){ 
	                	if(gridOtherLogonLoc.selModel.hasSelection()){
	                		if(winOtherLogonLoc.form.isValid()==false){return;}
	                		var selectOTHLLRowId = gridOtherLogonLoc.getSelectionModel().getSelections()[0].get('OTHLLRowId');
	                		var comboxOtherLogonLoc = Ext.getCmp("comboxOtherLogonLoc").getValue();
	                		var comboGroup = Ext.getCmp("comboGroup").getValue();
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
										msg:'该记录已存在!',
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
									return;
								}
			   			 	var selectId = gridOtherLogonLoc.getSelectionModel().getSelections()[0].get('Id');
			   			 		for (var i = 0; i < dsOtherLogonLoc.getCount(); i++) {
									var record = dsOtherLogonLoc.getAt(i);
									var OTHLLCTLOCDR = record.get('OTHLLCTLOCDR');
									var OTHLLUserGroupDR = record.get('OTHLLUserGroupDR');
									var OTHLLRowId = record.get('OTHLLRowId');
									var Id = record.get('Id');
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
								if (selectOTHLLRowId==""){
		                			selectOTHLLRowId=tree.getSelectionModel().getSelectedNode().attributes.SSUSRRowId;
		                		}
			   			 		var flag = "";
	        					var flag = tkMakeServerCall("web.DHCBL.CT.SSUserOtherLogonLoc","Validate",selectOTHLLRowId,comboxOtherLogonLoc,comboGroup);
	        					if (flag==1){
	        						Ext.Msg.show({
										title:'提示',
										msg:'该记录已存在!',
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
									return;
	        					}
				    	 	var myrecord = gridOtherLogonLoc.getSelectionModel().getSelected();
				    	 	//myrecord.set('SSUSRName',Ext.getCmp('SSUSRName').getValue())
				    	 	myrecord.set('CTLOCDesc',Ext.getCmp('comboxOtherLogonLoc').getRawValue());
				    	 	myrecord.set('SSGRPDesc',Ext.getCmp('comboGroup').getRawValue());
				    	 	myrecord.set('HOSPDesc',Ext.getCmp('comboHospital').getRawValue());
				    	 	myrecord.set('OTHLLCTLOCDR',Ext.getCmp('comboxOtherLogonLoc').getValue());
				    	 	myrecord.set('OTHLLUserGroupDR',Ext.getCmp('comboGroup').getValue());
				    	 	myrecord.set('OTHLLHospitalDR',Ext.getCmp('comboHospital').getValue());
				    	 	myrecord.set('OTHLLStartDate',Ext.getCmp('OTHLLStartDate').getValue());
				    	 	myrecord.set('OTHLLEndDate',Ext.getCmp('OTHLLEndDate').getValue());
				    	 	
				    	 	Ext.getCmp("comboxOtherLogonLoc").reset();
							Ext.getCmp("comboGroup").reset();
							Ext.getCmp("comboHospital").reset();
							Ext.getCmp("OTHLLStartDate").reset();
							Ext.getCmp("OTHLLEndDate").reset();
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
				                	dsOtherLogonLoc.remove(gsm.getSelected());
				                	Ext.Msg.show({
										title:'提示',
										msg:'数据删除成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){
											Ext.getCmp("comboxOtherLogonLoc").reset();
											Ext.getCmp("comboGroup").reset();
											Ext.getCmp("comboHospital").reset();
											Ext.getCmp("OTHLLStartDate").reset();
											Ext.getCmp("OTHLLEndDate").reset();
										}
									});
				                }else{
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
															Ext.getCmp("comboxOtherLogonLoc").reset();
															Ext.getCmp("comboGroup").reset();
															Ext.getCmp("comboHospital").reset();
															Ext.getCmp("OTHLLStartDate").reset();
															Ext.getCmp("OTHLLEndDate").reset();
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
						Ext.getCmp("comboxOtherLogonLoc").reset();
						Ext.getCmp("comboGroup").reset();
						Ext.getCmp("comboHospital").reset();
						Ext.getCmp("OTHLLStartDate").reset();
						Ext.getCmp("OTHLLEndDate").reset();
						if(win.title=='注册新用户'){
							gridOtherLogonLoc.getStore().load({params:{OTHLLParRef:0,start:0, limit:pageSize_LogonLoc}});
						}else{
							gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
						}
				   }
			}],
			listeners:{
				'afterlayout':function(){
					var startDateExist = tkMakeServerCall("web.DHCBL.BDP.FindTableStructure","PropertyExistOrNot","User.SSUserOtherLogonLoc","OTHLLStartDate");
					var endDateExist = tkMakeServerCall("web.DHCBL.BDP.FindTableStructure","PropertyExistOrNot","User.SSUserOtherLogonLoc","OTHLLEndDate");
					if(startDateExist=="0"){
						Ext.getCmp('OTHLLStartDate').getEl().up('.x-form-item').setDisplayed(false);
						gridOtherLogonLoc.getColumnModel().setHidden(8,true); 
					}
					if(endDateExist=="0"){
						Ext.getCmp('OTHLLEndDate').getEl().up('.x-form-item').setDisplayed(false);
						gridOtherLogonLoc.getColumnModel().setHidden(9,true); 
					}
					//设置其他登录科室默认开始日期
					Ext.getCmp("OTHLLStartDate").setValue(TodayDate);
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
	    //{ name: 'SSUSRName', mapping:'SSUSRName',type: 'string'},
	    { name: 'OTHLLCTLOCDR', mapping:'OTHLLCTLOCDR',type: 'string'},
        { name: 'CTLOCDesc',mapping:'CTLOCDesc', type: 'string' },   
        { name: 'OTHLLUserGroupDR', mapping:'OTHLLUserGroupDR',type: 'string'},
        { name: 'SSGRPDesc', mapping:'SSGRPDesc',type: 'string'},
        { name: 'OTHLLHospitalDR', mapping:'OTHLLHospitalDR',type: 'string'},
        { name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'},
        { name: 'OTHLLStartDate', mapping:'OTHLLStartDate',type : 'date',dateFormat : 'm/d/Y'},
        { name: 'OTHLLEndDate', mapping:'OTHLLEndDate',type : 'date',dateFormat : 'm/d/Y'},
        { name: 'Id', mapping:'Id',type: 'string'}
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
	var smOtherLogonLoc = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridOtherLogonLoc = new Ext.grid.GridPanel({
		id:'gridOtherLogonLoc',
		region: 'center',
		title:'其他登录科室明细',
		width:780,
		height:210,
		closable:true,
	    store: dsOtherLogonLoc,
	    trackMouseOver: true,
	    columns: [
	            smOtherLogonLoc,
	            { header: 'OTHLLRowId', width: 160, sortable: true, dataIndex: 'OTHLLRowId', hidden : true},
	            //{ header: '科室', width: 160, sortable: true, dataIndex: 'OTHLLParRef' },
				//{ header: '用户名', width: 120, sortable: true, dataIndex: 'SSUSRName' },   
	            { header: '登录科室', width: 200, sortable: true, dataIndex: 'CTLOCDesc' },
				{ header: '安全组', width: 200, sortable: true, dataIndex: 'SSGRPDesc' },
	            { header: '医院', width: 200, sortable: true, dataIndex: 'HOSPDesc'},
	            { header: '登录科室ID', width: 120, sortable: true, dataIndex: 'OTHLLCTLOCDR', hidden : true },
				{ header: '安全组ID', width: 120, sortable: true, dataIndex: 'OTHLLUserGroupDR', hidden : true },
	            { header: '医院ID', width: 120, sortable: true, dataIndex: 'OTHLLHospitalDR', hidden : true },
	            { header: '开始日期', width: 120, sortable: true, dataIndex: 'OTHLLStartDate',renderer : Ext.util.Format.dateRenderer(BDPDateFormat) },
	            { header: '结束日期', width: 120, sortable: true, dataIndex: 'OTHLLEndDate',renderer : Ext.util.Format.dateRenderer(BDPDateFormat) },
	            { header: 'Id', width: 120, sortable: true, dataIndex: 'Id', hidden : true }
	        ],
	    stripeRows: true,
	    loadMask: { msg: '数据加载中,请稍候...' },
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
	    //Ext.getCmp("comboHospital").reset();
	    Ext.getCmp("comboHospital").setValue(_record.get('OTHLLHospitalDR'));
	    Ext.getCmp("comboHospital").setRawValue(_record.get('HOSPDesc'));
	    //Ext.getCmp("OTHLLStartDate").reset();
	    Ext.getCmp("OTHLLStartDate").setValue(_record.get('OTHLLStartDate'));
	    //Ext.getCmp("OTHLLEndDate").reset();
	    Ext.getCmp("OTHLLEndDate").setValue(_record.get('OTHLLEndDate'));
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
			var startDate="";
			if((record.get('OTHLLStartDate')!="")&&(record.get('OTHLLStartDate')!=null)){
				startDate = record.get('OTHLLStartDate').format(BDPDateFormat)
			}
			var endDate="";
			if((record.get('OTHLLEndDate')!="")&&(record.get('OTHLLEndDate')!=null)){
				endDate = record.get('OTHLLEndDate').format(BDPDateFormat)
			}
			locstr = locstr+record.get('OTHLLCTLOCDR')+'^'+record.get('OTHLLUserGroupDR')+'^'+record.get('OTHLLHospitalDR')+'^'+startDate+'^'+endDate+'^'+record.get('OTHLLRowId');
	    }, this);
		Ext.Ajax.request({
			url:SAVE_URL_OtherLogonLoc,
			method:'POST',
			params:{
				'rowid':rowid,
				'locstr':locstr
			}	
		});  
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
					{name : 'SSUSRInitials',mapping : 'SSUSRInitials',type : 'string'},//
					{name : 'SSUSRName',mapping : 'SSUSRName',type : 'string'},//
					{name : 'SSUSRPassword',mapping : 'SSUSRPassword',type : 'string'}, //  
					{name : 'SSUSRDefaultDeptDR',mapping : 'SSUSRDefaultDeptDR',type : 'string'}, //
					{name : 'SSUSRGroup',mapping : 'SSUSRGroup',type : 'string'}, //
					{name : 'SSUSRUseDeptAsDefault',mapping : 'SSUSRUseDeptAsDefault',type : 'string'}, //
					{name : 'SSUSRChangeLocation',mapping : 'SSUSRChangeLocation',type : 'string'}, //
					{name : 'SSUSRCTLANDR',mapping : 'SSUSRCTLANDR',type : 'string'}, //
					{name : 'SSUSRCareProvDR',mapping : 'SSUSRCareProvDR',type : 'string'}, //
					{name : 'SSUSRPin',mapping : 'SSUSRPin',type : 'string'}, 
					{name : 'SSUSRActive',mapping : 'SSUSRActive',type : 'string'}, //
					{name : 'SSUSRDateFrom',mapping : 'SSUSRDateFrom',type : 'string'}, //
					{name : 'SSUSRDateTo',mapping : 'SSUSRDateTo',type : 'string'}, //
					{name : 'SSUSRHospitalDR',mapping : 'SSUSRHospitalDR',type : 'string'}, //
					{name : 'SSUSRPasswordChanged',mapping : 'SSUSRPasswordChanged',type : 'string'}, //
					{name : 'SSUSRAdmitted',mapping : 'SSUSRAdmitted',type : 'string'}, //
					{name : 'SSUSRIgnoreCALogon',mapping : 'SSUSRIgnoreCALogon',type : 'string'}, //
					//医护人员
					{name:'CTPCPRowId1',mapping:'CTPCPRowId1',type:'string'},
					{name:'CTPCPCode',mapping:'CTPCPCode',type:'string'},
					{name:'CTPCPOtherName',mapping:'CTPCPOtherName',type:'string'},
					{name:'CTPCPUnit',mapping:'CTPCPUnit',type:'string'},
					{name:'CTPCPCarPrvTpDR',mapping:'CTPCPCarPrvTpDR',type:'string'},
					{name:'CTPCPHICApproved',mapping:'CTPCPHICApproved',type:'string'},
					{name:'CTPCPDateActiveFrom',mapping:'CTPCPDateActiveFrom',type : 'string'},
					{name:'CTPCPSurgeon',mapping:'CTPCPSurgeon',type:'string'},
					{name:'CTPCPActiveFlag',mapping:'CTPCPActiveFlag',type:'string'},
					{name:'CTPCPDesc',mapping:'CTPCPDesc',type:'string'},
					{name:'CTPCPId',mapping:'CTPCPId',type:'string'},
					{name:'CTPCPTextOne',mapping:'CTPCPTextOne',type:'string'},
					{name:'CTPCPTextTwo',mapping:'CTPCPTextTwo',type:'string'},
					{name:'CTPCPSpecDR',mapping:'CTPCPSpecDR',type:'string'},
					{name:'CTPCPDateActiveTo',mapping:'CTPCPDateActiveTo',type : 'string'},
					{name:'CTPCPAnaesthetist',mapping:'CTPCPAnaesthetist',type:'string'},
					{name:'CTPCPSpecialistYN',mapping:'CTPCPSpecialistYN',type:'string'},
					{name:'CTPCPTelO',mapping:'CTPCPTelO',type:'string'},
					{name:'CTPCPTelH',mapping:'CTPCPTelH',type:'string'},
					{name:'CTPCPTelOExt',mapping:'CTPCPTelOExt',type:'string'},
					{name:'CTPCPMobilePhone',mapping:'CTPCPMobilePhone',type:'string'},
					{name:'CTPCPEmail',mapping:'CTPCPEmail',type:'string'},
					{name:'CTPCPFax',mapping:'CTPCPFax',type:'string'},
					{name:'CTPCPTitleDR',mapping:'CTPCPTitleDR',type:'string'}
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
					items : [SSUSRInitials,SSUSRCTLANDR,SSUSRHospitalDR,SSUSRDateFrom,SSUSRPassword,SSUSRRowId]
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
					items : [SSUSRName,DefaultDeptDR,SSUSRGroup,SSUSRDateTo,SSUSRPin]
				},{
					columnWidth : '.33',
					layout : 'form',
					labelWidth : 30,
					labelPad : 1,
					border : false,
					defaults : {
						anchor : '92%',
						xtype : 'textfield'
					},
					items : [SSUSRChangeLocation,SSUSRActive,SSUSRPasswordChanged,SSUSRAdmitted,SSUSRIgnoreCALogon,CareProvDR]//loginLoc,
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
					items : [CTPCPCode, CTPCPUnit,CTCPTDescCombo,CTPCPDateActiveFrom,CTPCPTitleDR,CTPCPTextOne,CTPCPRowId1]
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
					items : [CTPCPDesc,CTPCPOtherName,CTPCPId,CTSPCDescCombo,CTPCPDateActiveTo,CTPCPTextTwo]
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
					items : [CTPCPActiveFlag,CTPCPSurgeon,CTPCPSpecialistYN,CTPCPHICApproved,CTPCPAnaesthetist]
				}]
			},{
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
				
			}],
			listeners : {
				'beforeexpand' : function() { 
					if(win.title=='修改'&&tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc==""){
						Ext.getCmp("CTPCPCode").setValue(Ext.getCmp("SSUSRInitials").getValue())
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
										Ext.getCmp("CareProvDR").setValue(jsonData.CTPCPRowId1);
										Ext.getCmp("CTPCPOtherName").setValue(jsonData.CTPCPOtherName);//拼音检索码
										Ext.getCmp("CTPCPUnit").setValue(jsonData.CTPCPUnit);//医生资格证书号
										Ext.getCmp("CarPrvTpDR").setValue(jsonData.CTPCPCarPrvTpDR);//医护人员类型
										Ext.getCmp("CTPCPDateActiveFrom").setValue(jsonData.CTPCPDateActiveFrom);//开始日期
										Ext.getCmp("CTPCPSurgeon").setValue(jsonData.CTPCPSurgeon);//是否外科医生
										Ext.getCmp("CTPCPHICApproved").setValue(jsonData.CTPCPHICApproved);//毒麻处方权
										Ext.getCmp("CTPCPActiveFlag").setValue(jsonData.CTPCPActiveFlag);//是否激活
										Ext.getCmp("CTPCPDesc").setValue(jsonData.CTPCPDesc);//姓名
										Ext.getCmp("CTPCPId").setValue(jsonData.CTPCPId);//标识码
										Ext.getCmp("CTPCPTextOne").setValue(jsonData.CTPCPTextOne);//Text1
										Ext.getCmp("CTPCPTextTwo").setValue(jsonData.CTPCPTextTwo);//Text2
										Ext.getCmp("SpecDR").setValue(jsonData.CTPCPSpecDR);//医生专长
										Ext.getCmp("CTPCPAnaesthetist").setValue(jsonData.CTPCPAnaesthetist);//是否麻醉师
										Ext.getCmp("CTPCPSpecialistYN").setValue(jsonData.CTPCPSpecialistYN);//是否可以出特需号
										Ext.getCmp("CTPCPDateActiveTo").setValue(jsonData.CTPCPDateActiveTo);//结束日期
										Ext.getCmp("CTPCPTelO").setValue(jsonData.CTPCPTelO);//办公电话
										Ext.getCmp("CTPCPTelH").setValue(jsonData.CTPCPTelH);//家庭电话
										Ext.getCmp("CTPCPTelOExt").setValue(jsonData.CTPCPTelOExt);//电话分机
										Ext.getCmp("CTPCPMobilePhone").setValue(jsonData.CTPCPMobilePhone);//移动电话
										Ext.getCmp("CTPCPEmail").setValue(jsonData.CTPCPEmail);//Email
										Ext.getCmp("CTPCPFax").setValue(jsonData.CTPCPFax);//传真
										Ext.getCmp("TitleDR").setValue(jsonData.CTPCPTitleDR);//医护人员职称
									}else{
										Ext.getCmp("CareProvDR").setValue("");
										Ext.getCmp("CTPCPOtherName").setValue(Pinyin.GetJPU(Ext.getCmp("CTPCPDesc").getValue()));//拼音检索码
										Ext.getCmp("CTPCPUnit").setValue("");//医生资格证书号
										Ext.getCmp("CarPrvTpDR").setValue("");//医护人员类型
										Ext.getCmp("CTPCPDateActiveFrom").setValue("");//开始日期
										Ext.getCmp("CTPCPSurgeon").setValue("");//是否外科医生
										Ext.getCmp("CTPCPHICApproved").setValue("");//毒麻处方权
										//Ext.getCmp("CTPCPActiveFlag").setValue("");//是否激活
										Ext.getCmp("CTPCPDesc").setValue(Ext.getCmp("SSUSRName").getValue());//姓名
										Ext.getCmp("CTPCPId").setValue("");//标识码
										Ext.getCmp("CTPCPTextOne").setValue("");//Text1
										Ext.getCmp("CTPCPTextTwo").setValue("");//Text2
										Ext.getCmp("SpecDR").setValue("");//医生专长
										Ext.getCmp("CTPCPAnaesthetist").setValue("");//是否麻醉师
										Ext.getCmp("CTPCPSpecialistYN").setValue("");//是否可以出特需号
										Ext.getCmp("CTPCPDateActiveTo").setValue("");//结束日期
										Ext.getCmp("CTPCPTelO").setValue("");//办公电话
										Ext.getCmp("CTPCPTelH").setValue("");//家庭电话
										Ext.getCmp("CTPCPTelOExt").setValue("");//电话分机
										Ext.getCmp("CTPCPMobilePhone").setValue("");//移动电话
										Ext.getCmp("CTPCPEmail").setValue("");//Email
										Ext.getCmp("CTPCPFax").setValue("");//传真
										Ext.getCmp("TitleDR").setValue("");//医护人员职称
									}
									
								}
							}
						});
						
					}
				}/*,
				'collapse':function(){
					win.setSize(900,540);
				}*/
			}
		}]
	});
	
	var tabs = new Ext.TabPanel({
			 activeTab : 0,
			 frame : true,
			 border : false,
			 animScroll:true,
			 enableTabScroll:true,
			 border:false,
			 defaults:{autoScroll:true},
			 items : [WinForm, OtherLogonLocPanel, AliasGrid],
			 listeners:{
			 	'tabchange':function(tp,p){
			 		if (p.title="其他登录科室"){
			 			//设置默认安全组、默认登录科室
			 			Ext.getCmp("OtherDefaultDept").reset();
			 			Ext.getCmp("OtherBDPGroup").reset();
			 			Ext.getCmp("OtherDefaultDept").setValue(Ext.getCmp("DefaultDeptDR").getRawValue());
			 			Ext.getCmp("OtherBDPGroup").setValue(Ext.getCmp("BDPGroup").getRawValue());
			 			Ext.getCmp("OtherDefaultDeptDr").reset();
			 			Ext.getCmp("OtherBDPGroupDr").reset();
			 			Ext.getCmp("OtherDefaultDeptDr").setValue(Ext.getCmp("DefaultDeptDR").getValue());
			 			Ext.getCmp("OtherBDPGroupDr").setValue(Ext.getCmp("BDPGroup").getValue());
			 			
			 			//设置其他登录科室默认开始日期
						var TodayDate=new Date();//(new Date()).format("Y/m/d");
						Ext.getCmp("OTHLLStartDate").setValue(TodayDate);
			 		}
			 	}
			 }
	});
			 
	var win = new Ext.Window({
		title:'',
		width:1000,
        height:540,
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
				
				if(win.title=='注册新用户'){
					Ext.getCmp("CTProvSet").expand();	
				}
				if(win.title=='修改'&&tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc!=""){					
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
				//关联医护人员信息的选中状态，选中为false，不选为true
				var collapse = Ext.getCmp("CTProvSet").collapsed	
				/*if(((win.title=="注册新用户" && collapse==false)||(win.title=='修改'&&tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc!="")||(win.title=='修改'&&tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc==""&&collapse==false)) && WinForm.getForm().isValid()==false){			
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}*/
				
				/**用户参数串*/
				var startDate = Ext.getCmp("SSUSRDateFrom").getValue();
				var endDate = Ext.getCmp("SSUSRDateTo").getValue();
				if (startDate=="") {
			    	Ext.Msg.show({ title : '提示', msg : '开始日期不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
				if((startDate!="")&&(startDate!=null)){
    				startDate = startDate.format('Y/m/d');
   				}
				if((endDate!="")&&(endDate!=null)){
    				endDate = endDate.format('Y/m/d');
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
			   	var SSUSRInitials=Ext.getCmp("SSUSRInitials").getValue();			   
			   	var DefaultDeptDR=Ext.getCmp("DefaultDeptDR").getValue();
			   	var SSUSRCTLANDR=Ext.getCmp("CTLANDR").getValue();
			   	var SSUSRPassword=Ext.getCmp("SSUSRPassword").getValue();			   	
			   	var SSUSRChangeLocation=Ext.getCmp("SSUSRChangeLocation").getValue();
			   	var SSUSRName=Ext.getCmp("SSUSRName").getValue();		   
			   	var BDPGroup=Ext.getCmp("BDPGroup").getValue();			   	
			   	var SSUSRCareProvDR=Ext.getCmp("CareProvDR").getValue();
			   	var SSUSRPin=Ext.getCmp("SSUSRPin").getValue();
			   	var SSUSRActive=Ext.getCmp("SSUSRActive").getValue();
			   	var SSUSRHospital=Ext.getCmp("SSUSRHospital").getValue();
			   	var SSUSRPasswordChanged=Ext.getCmp("SSUSRPasswordChanged").getValue();
			   	var SSUSRRowId=Ext.getCmp("SSUSRRowId").getValue();
			   	var SSUSRAdmitted=Ext.getCmp("SSUSRAdmitted").getValue();
				var SSUSRIgnoreCALogon=Ext.getCmp("SSUSRIgnoreCALogon").getValue();
			   	if (SSUSRInitials=="") {
			    	Ext.Msg.show({ title : '提示', msg : '人事ID不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    } 
			    if (SSUSRName=="") {
			    	Ext.Msg.show({ title : '提示', msg : '姓名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			    if (BDPGroup=="") {
			    	Ext.Msg.show({ title : '提示', msg : '安全组不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
			   	var passLen = tkMakeServerCall("web.CFSM", "GetPasswordMinLength");						
				var passValid = tkMakeServerCall("websys.Configuration","GetFieldValue","PwdContainWordAndNum");
				var passReg = /^(?=.*?[a-zA-Z])(?=.*?\d).*/; 
				if (SSUSRPassword=="") {
			    	Ext.Msg.show({ title : '提示', msg : '登陆密码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			    	return;
			    }
				/*if(SSUSRPassword!=""&&SSUSRPassword!="******"&&SSUSRPassword.length<passLen){									
					Ext.Msg.show({ title : '提示', msg : '登陆密码长度不能小于'+passLen, minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });						        
				}else if(SSUSRPassword!=""&&SSUSRPassword!="******"&&passValid=="Y"){
					if(!passReg.test(SSUSRPassword)){		
						Ext.Msg.show({ title : '提示', msg : '登陆密码须同时包含数字与字母', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });		        	
					}
				}*/
				if(SSUSRPin!=""&&SSUSRPin!="******"&&SSUSRPin.length<passLen){									
					Ext.Msg.show({ title : '提示', msg : '医嘱签名密码长度不能小于'+passLen, minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });	       
				}else if(SSUSRPin!=""&&SSUSRPin!="******"&&passValid=="Y"){
					if(!passReg.test(SSUSRPin)){		
						Ext.Msg.show({ title : '提示', msg : '医嘱签名密码须同时包含数字与字母', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });			        	
					}
				}
			   	
			   	var userStr=SSUSRInitials+"^"+DefaultDeptDR+"^"+SSUSRCTLANDR+"^"+startDate+"^"+SSUSRPassword+"^"+SSUSRChangeLocation+"^"+SSUSRName+"^"+BDPGroup+"^"+SSUSRCareProvDR+"^"+endDate+"^"+SSUSRPin+"^"+SSUSRActive+"^"+SSUSRHospital+"^"+SSUSRPasswordChanged+"^"+SSUSRRowId+"^"+collapse+"^"+SSUSRAdmitted+"^"+SSUSRIgnoreCALogon;;
			   	/**医护人员参数串*/
			   	var CTPCPCode=Ext.getCmp("CTPCPCode").getValue();
			   	var CTPCPOtherName=Ext.getCmp("CTPCPOtherName").getValue();
			   	var CTPCPUnit=Ext.getCmp("CTPCPUnit").getValue();
			   	var CTPCPCarPrvTpDR=Ext.getCmp("CarPrvTpDR").getValue();
			   	var CTPCPHICApproved=Ext.getCmp("CTPCPHICApproved").getValue();
			   	var sDate=Ext.getCmp("CTPCPDateActiveFrom").getValue();
			   	var CTPCPSurgeon=Ext.getCmp("CTPCPSurgeon").getValue();
			   	var CTPCPActiveFlag=Ext.getCmp("CTPCPActiveFlag").getValue();
			   	var CTPCPDesc=Ext.getCmp("CTPCPDesc").getValue();
			   	var CTPCPId=Ext.getCmp("CTPCPId").getValue();
			   	var CTPCPTextOne=Ext.getCmp("CTPCPTextOne").getValue();
			   	var CTPCPTextTwo=Ext.getCmp("CTPCPTextTwo").getValue();
			   	var CTPCPSpecDR=Ext.getCmp("SpecDR").getValue();
			   	var eDate=Ext.getCmp("CTPCPDateActiveTo").getValue();
			   	var CTPCPAnaesthetist=Ext.getCmp("CTPCPAnaesthetist").getValue();
			   	var CTPCPSpecialistYN=Ext.getCmp("CTPCPSpecialistYN").getValue();
			   	var CTPCPTelO=Ext.getCmp("CTPCPTelO").getValue();
			   	var CTPCPTelH=Ext.getCmp("CTPCPTelH").getValue();
			   	var CTPCPTelOExt=Ext.getCmp("CTPCPTelOExt").getValue();
			   	var CTPCPMobilePhone=Ext.getCmp("CTPCPMobilePhone").getValue();
			   	var CTPCPEmail=Ext.getCmp("CTPCPEmail").getValue();
			   	var CTPCPFax=Ext.getCmp("CTPCPFax").getValue();
			   	var CTPCPTitleDR=Ext.getCmp("TitleDR").getValue();
				
			   	/*if((sDate!="")&&(sDate!=null)){
    				sDate = sDate.format('Y/m/d');
   				}
   				if((eDate!="")&&(eDate!=null)){
    				eDate = eDate.format('Y/m/d');
   				}
			   	if (sDate != "" && eDate != "") {
        			if (sDate > eDate) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始日期不能大于结束日期！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
			   	}  */
			   	if(((win.title=="注册新用户" && collapse==false)||(win.title=='修改'&&tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc!="")||(win.title=='修改'&&tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc==""&&collapse==false)) ){			
					if (CTPCPCode=="") {
				    		Ext.Msg.show({ title : '提示', msg : '工号不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				     if (CTPCPDesc=="") {
				    		Ext.Msg.show({ title : '提示', msg : '姓名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				     if (CTPCPOtherName=="") {
				    		Ext.Msg.show({ title : '提示', msg : '拼音检索码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				     if (CTPCPCarPrvTpDR=="") {
				    		Ext.Msg.show({ title : '提示', msg : '医护人员类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        	return;
				     } 
				}
			   	var provStr=CTPCPCode+"^"+CTPCPOtherName+"^"+CTPCPUnit+"^"+CTPCPCarPrvTpDR+"^"+CTPCPHICApproved+"^"+sDate+"^"+CTPCPSurgeon+"^"+CTPCPActiveFlag+"^"+CTPCPDesc+"^"+CTPCPId+"^"+CTPCPTextOne+"^"+CTPCPTextTwo+"^"+CTPCPSpecDR+"^"+eDate+"^"+CTPCPAnaesthetist+"^"+CTPCPSpecialistYN+"^"+CTPCPTelO+"^"+CTPCPTelH+"^"+CTPCPTelOExt+"^"+CTPCPMobilePhone+"^"+CTPCPEmail+"^"+CTPCPFax+"^"+CTPCPTitleDR;
			   
			   	
			    if(win.title=="注册新用户")
				{
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
								//保存其它登录科室
								saveloc(myrowid);
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								Ext.Msg.show({
								title : '提示',
								msg : '添加成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									Ext.getCmp("comboxOtherLogonLoc").reset();
									Ext.getCmp("comboGroup").reset();
									Ext.getCmp("comboHospital").reset();
									/*var startIndex = grid.getBottomToolbar().cursor;
									grid.getStore().load({
										params : {
											start : 0,
											limit : pagesize,
											rowid : myrowid
										}
									});*/
									loader.on("beforeload", function(treeLoader, node) {
										//loader.baseParams.ParentID="L0";
										loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
										loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
										loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
										loader.baseParams.treetype =  type;
										loader.baseParams.category =  HiddenCat;
										loader.baseParams.sort =  sort;
								    }, this); 
								    tree.root.reload();
								    /*if (DefaultDeptDR==""){
								    	tree.getNodeById("L0").reload(); 
								    }else{
								    	tree.getNodeById("L"+DefaultDeptDR).reload(); 
								    }*/
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
										//修改其它登录科室
										saveloc(jsonData.id);
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.getCmp("comboxOtherLogonLoc").reset();
												Ext.getCmp("comboGroup").reset();
												Ext.getCmp("comboHospital").reset();
												/*Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid);*/
												tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload();
												//小气泡数量修改
												var rule="";
												var hosp="";
												if (flagType=="SSUSRDefaultDeptDR"){rule=DefaultDeptDR;}
												else if(flagType=="SSUSRGroup"){rule=BDPGroup;}
												else if(flagType=="CTPCPCarPrvTpDR"){rule=CTPCPCarPrvTpDR;}
												else if(flagType=="CTPCPSpecDR"){rule=CTPCPSpecDR;}
												else if(flagType=="SSUSRHospitalDR"){rule=SSUSRHospital;}
												else if(flagType=="HospitalSSUSRDefaultDeptDR"){
													rule=DefaultDeptDR;
													var CTLOCHospitalDR = tkMakeServerCall("web.DHCBL.CT.CTLoc","GetHospitalDR",rule);
													hosp=CTLOCHospitalDR;
												}
												if (rule!=tree.getSelectionModel().getSelectedNode().parentNode.attributes.id.split("L")[1]){
													var oldValLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName.split("#")[0];
													var oldCountLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName.split("#")[1]-1;
													tree.getSelectionModel().getSelectedNode().parentNode.setText('<span ext:qtitle="" ext:qtip="' + oldValLoc + '">' + oldValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+oldCountLoc+'</h6></span>')
													tree.getSelectionModel().getSelectedNode().parentNode.attributes.SSUSRName=oldValLoc+"#"+oldCountLoc;
													if (rule==""){
														var newValLoc=tree.getNodeById(hosp+"L0").attributes.SSUSRName.split("#")[0];
														var newCountLoc=parseInt(tree.getNodeById(hosp+"L0").attributes.SSUSRName.split("#")[1])+1;
														tree.getNodeById(hosp+"L0").setText('<span ext:qtitle="" ext:qtip="' + newValLoc + '">' + newValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountLoc+'</h6></span>')
														tree.getNodeById(hosp+"L0").attributes.SSUSRName=newValLoc+"#"+newCountLoc;
													}else{
														var newValLoc=tree.getNodeById(hosp+"L"+rule).attributes.SSUSRName.split("#")[0];
														var newCountLoc=parseInt(tree.getNodeById(hosp+"L"+rule).attributes.SSUSRName.split("#")[1])+1;
														tree.getNodeById(hosp+"L"+rule).setText('<span ext:qtitle="" ext:qtip="' + newValLoc + '">' + newValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountLoc+'</h6></span>')
														tree.getNodeById(hosp+"L"+rule).attributes.SSUSRName=newValLoc+"#"+newCountLoc;
													}
													if (flagType=="HospitalSSUSRDefaultDeptDR"){
														if(CTLOCHospitalDR==""){var CTLOCHospitalDR=0}
														if (CTLOCHospitalDR!=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.id.substring(1)){
															var oldValHosp=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName.split("#")[0];
															var oldCountHosp=tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName.split("#")[1]-1;
															tree.getSelectionModel().getSelectedNode().parentNode.parentNode.setText('<span ext:qtitle="" ext:qtip="' + oldValHosp + '">' + oldValHosp + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+oldCountHosp+'</h6></span>')
															tree.getSelectionModel().getSelectedNode().parentNode.parentNode.attributes.SSUSRName=oldValHosp+"#"+oldCountHosp;
															var newValHosp=tree.getNodeById("H"+CTLOCHospitalDR).attributes.SSUSRName.split("#")[0];
															var newCountHosp=parseInt(tree.getNodeById("H"+CTLOCHospitalDR).attributes.SSUSRName.split("#")[1])+1;
															tree.getNodeById("H"+CTLOCHospitalDR).setText('<span ext:qtitle="" ext:qtip="' + newValHosp + '">' + newValHosp + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountHosp+'</h6></span>')
															tree.getNodeById("H"+CTLOCHospitalDR).attributes.SSUSRName=newValHosp+"#"+newCountHosp
														}
													}
													
													loader.on("beforeload", function(treeLoader, node) {
														loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
														loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
														loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
														loader.baseParams.treetype =  type;
														loader.baseParams.category =  HiddenCat;
														loader.baseParams.sort =  sort;
														loader.baseParams.rebuild =  "Y";
												    }, this); 
												    if (rule==""){
												    	if (tree.getSelectionModel().getSelectedNode().parentNode.attributes.id!=hosp+"L0"){
												    		tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload(); 
												    	}
												    	tree.getNodeById(hosp+"L0").reload(); 
												    }else{
												    	if (tree.getSelectionModel().getSelectedNode().parentNode.attributes.id!=hosp+"L"+rule){
												    		tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload(); 
												    	}
												    	tree.getNodeById(hosp+"L"+rule).reload(); 
												    }
												}
												
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
				id : 'btnAddwin',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddwin'),
				iconCls : 'icon-useradd',
				handler : AddData=function () {
					WinForm.isAdd = true;
					win.setTitle('注册新用户');
					win.setIconClass('icon-useradd');					
					win.show('new1');
					
					gridOtherLogonLoc.getStore().load({
						params : {
							OTHLLParRef:0,
							start : 0,
							limit : pageSize_LogonLoc
						}
					});
					WinForm.getForm().reset();
					winOtherLogonLoc.getForm().reset();
					//右键注册新用户设置默认值
					if (tree.getSelectionModel().getSelectedNode()){
						if(tree.getSelectionModel().getSelectedNode().attributes.id.substring(0,1)=="L"){
							var flagValue=tree.getSelectionModel().getSelectedNode().attributes.id.substring(1);
							if (flagType.indexOf("SSUSRDefaultDeptDR")>=0){
								Ext.getCmp("DefaultDeptDR").setValue(flagValue)
							}else if(flagType.indexOf("SSUSRGroup")>=0){
								Ext.getCmp("BDPGroup").setValue(flagValue)
							}else if(flagType=="SSUSRHospitalDR"){
								Ext.getCmp("SSUSRHospital").setValue(flagValue)
							}else if(flagType=="CTPCPCarPrvTpDR"){
								Ext.getCmp("CarPrvTpDR").setValue(flagValue)
							}else if(flagType=="CTPCPSpecDR"){
								Ext.getCmp("SpecDR").setValue(flagValue)
							}
						}
					}
					
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
				id : 'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
						win.setTitle('修改');
						win.setIconClass('icon-Update');
						win.show('');

						var SSUSRRowId=tree.getSelectionModel().getSelectedNode().id;
						//载入其它登录科室
						gridOtherLogonLoc.getStore().baseParams = {
							OTHLLParRef : SSUSRRowId
						};
						Ext.getCmp("comboxOtherLogonLoc").reset();
						Ext.getCmp("comboGroup").reset();
						Ext.getCmp("comboHospital").reset();
						gridOtherLogonLoc.getStore().load({
							params : {
								start : 0,
								limit : pageSize_LogonLoc
							}
						});
						
						//载入用户医护人员信息
						Ext.getCmp("form-User-save").getForm().load({
							url : OPENALL_ACTION_URL + '&id='+ SSUSRRowId,
							waitMsg : '正在载入数据...',
							success : function(form, action) {
							},
							failure : function(form, action) {
								Ext.Msg.alert('编辑', '载入失败');
							}
						});
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = SSUSRRowId;
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

	var btnAccredit = new Ext.Toolbar.Button({ // 授权
		text : '授权',
		iconCls : 'icon-accredit',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAccredit'),
		tooltip : '授权',
		width : 30,
		handler : function() {
			if (tree.getSelectionModel().getSelectedNode()) {
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
        handler: DesignatedDepartment=function() {
        if((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)&&(tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc!="")){      
               	var id = tree.getSelectionModel().getSelectedNode().attributes.SSUSRCareProvDR;                        
			    var flag = "";
		        var flag = tkMakeServerCall("web.DHCBL.CT.CTCarPrvTp","GetInternalTypeForCareID",id);	//用tkMakeServerCall函数实现与后台同步调用交互
		        RBCTLOCStore.baseParams={type:flag}
	            RBCTLOCStore.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Combo}});
	               
				winDesignatedDepartment.setTitle('指定科室');
			    winDesignatedDepartment.setIconClass('icon-DP');
			    winDesignatedDepartment.show('');
			   
                var RESCode=tree.getSelectionModel().getSelectedNode().attributes.CTPCPCode;
                gridResource.getStore().baseParams={Code:RESCode};
                gridResource.getStore().load({params:{start:0, limit:pagesize_Resource}});
                var RESCTPCPDR=tree.getSelectionModel().getSelectedNode().attributes.SSUSRCareProvDR;
                var RESDesc=tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc;
                
                Ext.getCmp("hidden_RESCode").reset();
                Ext.getCmp("hidden_RESCode").setValue(RESCode);
                Ext.getCmp("hidden_RESCTPCPDR").reset();
                Ext.getCmp("hidden_RESCTPCPDR").setValue(RESCTPCPDR);
                Ext.getCmp("hidden_RESDesc").reset();
                Ext.getCmp("hidden_RESDesc").setValue(RESDesc);
                Ext.getCmp("comboxResource").reset();
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
        if((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)&&(tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc!="")){
			winMed.setTitle('所属医疗单元');
			winMed.setIconClass('icon-DP');
			winMed.show('');
            var CTPCPRowId=tree.getSelectionModel().getSelectedNode().attributes.SSUSRCareProvDR;
            var CTPCPCode=tree.getSelectionModel().getSelectedNode().attributes.CTPCPCode;
            var CTPCPDesc=tree.getSelectionModel().getSelectedNode().attributes.CTPCPDesc;
            Ext.getCmp("DoctorDRF").reset();
            Ext.getCmp("CTPCPCodeF").reset();
            Ext.getCmp("CTPCPDescF").reset();
            Ext.getCmp("DoctorDRF").setValue(CTPCPRowId);
           	Ext.getCmp("CTPCPCodeF").setValue(CTPCPCode);
           	Ext.getCmp("CTPCPDescF").setValue(CTPCPDesc);
            gridMedUnit.getStore().baseParams={DoctorDR:CTPCPRowId};
           	gridMedUnit.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择所属医疗单元的关联医护人员!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	var winDirectoryTreeConfig = new Ext.Window(getConfigPanel());  //调用DirectoryTreeConfig.js的目录树配置面板 
	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-', btnDesignatedDepartment, '-', btnMedUnit, '-' ,btnTrans,'-',btnSort,'->',
			new Ext.SplitButton({
			   	text: '更多功能',
			   	icon:Ext.BDP.FunLib.Path.URL_Icon +'list-items.gif',
			   	menu: new Ext.menu.Menu({
			        items: [
			        	{text: '切换为列表展示',id : 'btnSwitch',iconCls:'icon-refresh',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSwitch'),handler:function(){
				        	//var userId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.System.SSUser",""); //用户列表菜单id
							//window.location.href="dhc.bdp.ext.sys.csp?BDPMENU="+userId;  
			        		window.location.href="dhc.bdp.ext.default.csp?extfilename=App/System/SS_User.js"; 
				        }},
				        {text: '树形展示配置',id : 'btnConfigTree',iconCls:'icon-config',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnConfigTree'),handler:function(){
				        	winDirectoryTreeConfig .setTitle('规则配置');
							winDirectoryTreeConfig .setIconClass('icon-config');
							winDirectoryTreeConfig .show('');
							Ext.getCmp("hidden_table").reset();
			       			Ext.getCmp("hidden_table").setValue(Ext.BDP.FunLib.SortTableName);
							RuleStore.baseParams={table:Ext.BDP.FunLib.SortTableName}
		           			RuleStore.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
		           			Ext.getCmp("RuleF").reset();
			       			Ext.getCmp("RuleF").setValue(tkMakeServerCall("web.DHCBL.CT.DirectoryTreeConfig","OpenData",Ext.BDP.FunLib.SortTableName));
				        }},'-',
			         	{text: '查看数据日志',id:'btnlog',iconCls:'icon-DP',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnlog'),handler:function(){
			         		var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPDataChangeLogForPages&UserClass="+Ext.BDP.FunLib.SortTableName;
			         		var link=encodeURI(link)
							if ('undefined'!==typeof websys_getMWToken)
							{
								link += "&MWToken="+websys_getMWToken() //增加token  
							}
			         		var LogWin = new Ext.Window({
				                    width:1100,
				                    height:480,
				                    id:'LogWin',
				                    title:'查看数据日志',
				                    layout : 'fit',
				                    plain : true, 
				                    modal : true,
				                    frame : true,
				                    autoScroll : false,
				                    constrain : true,
				                    closeAction : 'close' 
				                });
				            LogWin.html='<iframe  src=" '+link+' " width="100%" height="100%"></iframe>';                        
				            LogWin.show();     
			         	}},
			         	{text: '查看数据生命周期',id:'btnhislog',icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnhislog'),handler:function(){
			         	    var RowID="",Desc="";
						    if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
						       RowID=tree.getSelectionModel().getSelectedNode().id;
						       Desc=tree.getSelectionModel().getSelectedNode().attributes.SSUSRName;
						       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
						    }
						    else
						    {
						       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
						    }
			         		var paramsArr= [];
				            var paramsstr=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetLogParams");
				            if ((paramsstr!="")&&(paramsstr!="undefined")){
						            paramsArr=paramsstr.split("^"); 
						            var objrowid=paramsArr[0];
						            var objdesc=paramsArr[1];
						            var SortWin = new Ext.Window({
						                    width:1120,
						                    height:460,
						                    id:'SortWin',
						                    title:'数据生命周期',
						                    layout : 'fit',
						                    plain : true,// true则主体背景透明
						                    modal : true,
						                    frame : true,
						                    autoScroll : false,
						                    collapsible : true,
						                    hideCollapseTool : true,
						                    titleCollapse : true,
						                    constrain : true,
				                            icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',
						                    closeAction : 'close' 
						                });
						            var link="dhc.bdp.bdp.timeline.csp?actiontype=timeline&ClassN="+Ext.BDP.FunLib.SortTableName +"&OBJDESC="+objrowid+"&ObjectDesc="+objdesc;
								    var link=encodeURI(link)
									if ('undefined'!==typeof websys_getMWToken)
									{
										link += "&MWToken="+websys_getMWToken() //增加token  
									}
						            SortWin.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';                        
						            SortWin.show();     
						          }
						          else
						          {
					               Ext.Msg.show({
					                        title:'提示',
					                        minWidth:280,
					                        msg:'请选择需要查看的行!',
					                        icon:Ext.Msg.WARNING,
					                        buttons:Ext.Msg.OK
					                    }); 
						          }
			         	}}
			       	]
			   	})
			})
		]//btnlog,'-',btnhislog,'-',btnSwitch, '-', btnLoginLoc
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		});
		///日志查看按钮是否显示
	   var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
	   if (btnlogflag==1)
	   {
	      Ext.getCmp("btnlog").show();
	    }
	    else
	    {
	       Ext.getCmp("btnlog").hide();
	    }
	    /// 数据生命周期按钮 是否显示
	   var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
	   if (btnhislogflag==1)
	   {
	      Ext.getCmp("btnhislog").show();
	    }
	    else
	    {
	       Ext.getCmp("btnhislog").hide();
	    } 
    // 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				text : '搜索',
				handler : 	search=	function (){
					loader.on("beforeload", function(treeLoader, node) {
						loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
						loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
						loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
						loader.baseParams.treetype =  type;
						loader.baseParams.category =  HiddenCat;
						loader.baseParams.sort =  sort;
				    }, this); 
				    tree.root.reload();
				    tree.getSelectionModel().clearSelections();
					/*grid.getStore().baseParams = {
							Initials : Ext.getCmp("TextCode").getValue(),
							Name : Ext.getCmp("TextName").getValue(),
							Active : Ext.getCmp("TextActive").getValue(),
							treetype:type,
							category:HiddenCat,
	   						sort:sort
						};
					grid.getStore().load({
							params : {
								start : 0,
								limit : pagesize,
								communityid:communityid
							}
						});*/
				}
			});
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				text : '重置',
				handler :  refresh=function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextName").reset();
					Ext.getCmp("TextActive").reset();
					Ext.getCmp("sort").setValue(sort);
					sort="default";
					loader.on("beforeload", function(treeLoader, node) {
						loader.baseParams.sort =  sort;
				    }, this); 
				    tree.root.reload();
				    tree.getSelectionModel().clearSelections();
					/*
					 * grid.getStore().baseParams = {
							treetype:type,
							category:HiddenCat,
							sort:sort
						};
					grid.getStore().load({
							params : {
								start : 0,
								limit : pagesize,
								communityid:communityid
							}
						});*/
				}
			});
	var tb = new Ext.Toolbar({
		id : 'tb',
		items : [
				'人事ID',
				{
					xtype : 'textfield',
					id : 'TextCode',
					width:100,
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
					width:100,
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
				'-',
				'用户激活',{
					xtype : 'combo',
					listWidth:60,
					width:60,
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
				},'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',btnSearch,'-',btnRefresh,
				'->', 
				'排序方式',
				{
				xtype:'panel',
				baseCls:'x-plain',
				width:180,
				height:30,
				items:[{
					id : 'sort',
					xtype : 'radiogroup',
					columns:3,
					//columns: [50, 50, 50],
		            items : [{
	            		id : 'radio1',
	            		boxLabel : "默认",
	            		name : 'FilterCK',
	            		inputValue : 'default',
	            		checked : true,
	            		listeners : {
			            	'check' : function(com, checked){
			            		if(checked){
			            			sort="default"
			            			search() 
			            		}
			            	},
			            	scope : this
			            }
	            	}, {
	            		id : 'radio2',
	            		boxLabel : "人事ID",
	            		name : 'FilterCK',
	            		inputValue : 'SSUSRInitials',
	            		listeners : {
			            	'check' : function(com, checked){
			            		if(checked){
			            			sort="SSUSRInitials"
			            			search() 
			            		}
			            	},
			            	scope : this
			            }
	            	}, {
	            		id : 'radio3',
	            		boxLabel : "姓名",
	            		name : 'FilterCK',
	            		inputValue : 'SSUSRName',
	            		listeners : {
			            	'check' : function(com, checked){
			            		if(checked){
			            			sort="SSUSRName"
			            			search() 
			            		}
			            	},
			            	scope : this
			            }
	            	}]
	            }]
				},helphtmlbtn
		],
		listeners : {
			render : function() {
				tbbutton.render(treePanel.tbar) // tbar.render(panel.bbar)这个效果在底部
			}
		}
	});
	
	/*********************目录树start*******************************************/
 	var loader = new Ext.tree.TreeLoader({
 		nodeParameter: "ParentID",
        dataUrl: ACTION_URL,
        requestMethod: 'GET',
        uiProviders: {
            'col':Ext.tree.ColumnTreeNodeUI  //Ext.ux.ColumnTreeCheckNodeUI如果不需要checkbox,则需要使用Ext.tree.ColumnTreeNodeUI      
        }/*,
        listeners: {
            "loadexception": function(loader, node, response) {
                //加载服务器数据,直到成功
                node.loaded = false;
                node.reload.defer(100, node);
            }
        }*/
    });
    loader.on('beforeload', function(treeLoader,node){
			loader.baseParams.ParentID=node.id;
			loader.baseParams.sort=sort;
			loader.baseParams.flagType=flagType;
	});
    var cm=[
    	{header : '姓名',width : 290,dataIndex : 'SSUSRName',renderer:Ext.BDP.FunLib.Component.TreeTipShow},
    	{header : '人事ID',width : 60,dataIndex : 'SSUSRInitials'},
    	{header : 'ID',width : 60,dataIndex : 'id', hidden:true},
    	{header : '安全组 ',width : 100,dataIndex : 'SSGRPDesc'},
    	{header : '医护人员Id',width : 60,dataIndex : 'SSUSRCareProvDR',hidden:true},
    	{header : '医护人员Code',width : 60,dataIndex : 'CTPCPCode',hidden:true},
    	{header : '关联医护人员',width : 80,dataIndex : 'CTPCPDesc'},
    	{header : '医护人员类型',width : 80,dataIndex : 'CTCPTDesc'},
    	{header : '拼音检索码',width : 60,dataIndex : 'CTPCPOtherName'},
    	{header : '用户激活',width : 50,dataIndex : 'SSUSRActive',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
    	{header : '开始日期',width : 75,dataIndex : 'SSUSRDateFrom',renderer : Ext.util.Format.dateRenderer(BDPDateFormat)},
    	{header : '结束日期',width : 75,dataIndex : 'SSUSRDateTo',renderer : Ext.util.Format.dateRenderer(BDPDateFormat)}
    	];
    var tree = new Ext.tree.ColumnTree({
        animate: true,
        rootVisible: false,
        autoScroll: true,
        containerScroll : true,
        enableDD:true,
        //checkModel: 'cascade', //级联多选，如果不需要checkbox,该属性去掉
        //onlyLeafCheckable: false, //所有结点可选，如果不需要checkbox,该属性去掉
        loader: loader,               
        columns: cm,               
        root: new Ext.tree.AsyncTreeNode({
        	id : 'root',
            text: '用户'
        })
    });
    /*********************目录树end*******************************************/
	var treePanel = new Ext.Panel({
		title:'用户',
      	layout:'fit',
      	collapsible: false,
      	plain:true,
      	frame:true,
		region:'center',
		tools : Ext.BDP.FunLib.Component.HelpMsg,
      	items:tree,
      	tbar : tb
	});
	/**拖拽功能*/
    tree.on('movenode',function(panel, node , oldParent , newParent , index){
    	Ext.Ajax.request({
					url : DRAG_ACTION_URL , 		
					method : 'POST',	
					params : {
							'id' : node.id,
							'parentid' : newParent.id.substring(1),
							'rule':flagType
					},
					callback : function(options, success, response) {	
					if(success){
						var jsonData = Ext.util.JSON.decode(response.responseText);
						if (jsonData.success == 'true') {
							//小气泡数量修改
							if (oldParent.id!=newParent.id){
								var oldValLoc=oldParent.attributes.SSUSRName.split("#")[0];
								var oldCountLoc=oldParent.attributes.SSUSRName.split("#")[1]-1;
								oldParent.setText('<span ext:qtitle="" ext:qtip="' + oldValLoc + '">' + oldValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+oldCountLoc+'</h6></span>')
								oldParent.attributes.SSUSRName=oldValLoc+"#"+oldCountLoc;
								var newValLoc=newParent.attributes.SSUSRName.split("#")[0];
								var newCountLoc=parseInt(newParent.attributes.SSUSRName.split("#")[1])+1;
								newParent.setText('<span ext:qtitle="" ext:qtip="' + newValLoc + '">' + newValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountLoc+'</h6></span>')
								newParent.attributes.SSUSRName=newValLoc+"#"+newCountLoc;
								if (oldParent.parentNode.id!=newParent.parentNode.id){
									var oldValHosp=oldParent.parentNode.attributes.SSUSRName.split("#")[0];
									var oldCountHosp=oldParent.parentNode.attributes.SSUSRName.split("#")[1]-1;
									oldParent.parentNode.setText('<span ext:qtitle="" ext:qtip="' + oldValHosp + '">' + oldValHosp + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+oldCountHosp+'</h6></span>')
									oldParent.parentNode.attributes.SSUSRName=oldValHosp+"#"+oldCountHosp;
									var newValHosp=newParent.parentNode.attributes.SSUSRName.split("#")[0];
									var newCountHosp=parseInt(newParent.parentNode.attributes.SSUSRName.split("#")[1])+1;
									newParent.parentNode.setText('<span ext:qtitle="" ext:qtip="' + newValHosp + '">' + newValHosp + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountHosp+'</h6></span>')
									newParent.parentNode.attributes.SSUSRName=newValHosp+"#"+newCountHosp
								}
							}
							
							loader.on("beforeload", function(treeLoader, node) {
									loader.baseParams.Initials =  Ext.getCmp("TextCode").getValue();
									loader.baseParams.Name =  Ext.getCmp("TextName").getValue();
									loader.baseParams.Active =  Ext.getCmp("TextActive").getValue();
									loader.baseParams.treetype =  type;
									loader.baseParams.category =  HiddenCat;
									loader.baseParams.sort =  sort;
							    }, this); 
							    //tree.root.reload();
							    /*if (DefaultDeptDR==""){
							    	if (tree.getSelectionModel().getSelectedNode().parentNode.attributes.id!="L0"){
							    		tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload(); 
							    	}
							    	tree.getNodeById("L0").reload(); 
							    }else{
							    	if (tree.getSelectionModel().getSelectedNode().parentNode.attributes.id!="L"+DefaultDeptDR){
							    		tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload(); 
							    	}
							    	tree.getNodeById("L"+DefaultDeptDR).reload(); 
							    }*/
						}else{
							var errorMsg ='';
							if(jsonData.errorinfo){
								errorMsg='<br />'+jsonData.errorinfo
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
    });
	tree.on("dblclick",function (node, e){
		if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
			win.setTitle('修改');
			win.setIconClass('icon-Update');
			win.show('');

			var SSUSRRowId=tree.getSelectionModel().getSelectedNode().id;
			//载入其它登录科室
			gridOtherLogonLoc.getStore().baseParams = {
				OTHLLParRef : SSUSRRowId
			};
			Ext.getCmp("comboxOtherLogonLoc").reset();
			Ext.getCmp("comboGroup").reset();
			Ext.getCmp("comboHospital").reset();
			gridOtherLogonLoc.getStore().load({
				params : {
					start : 0,
					limit : pageSize_LogonLoc
				}
			});
			
			//载入用户医护人员信息
			Ext.getCmp("form-User-save").getForm().load({
				url : OPENALL_ACTION_URL + '&id='+ SSUSRRowId,
				waitMsg : '正在载入数据...',
				success : function(form, action) {
				},
				failure : function(form, action) {
					Ext.Msg.alert('编辑', '载入失败');
				}
			});
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            AliasGrid.DataRefer = SSUSRRowId;
	        AliasGrid.loadGrid();
		
		} 
	},this,{stopEvent:true});
	tree.on("click",function(node,e){
		if (node.attributes.leaf) {
			Ext.getCmp('update_btn').enable();
			Ext.getCmp('del_btn').enable();
			if(node.attributes.CTPCPDesc==""){
		 		Ext.getCmp('btnDesignatedDepartment').disable();
		 		Ext.getCmp('btnMedUnit').disable();
		 	}else{
		 		Ext.getCmp('btnDesignatedDepartment').enable();
		 		Ext.getCmp('btnMedUnit').enable();
		 	}
		}else{
 			Ext.getCmp('update_btn').disable();
			Ext.getCmp('del_btn').disable();
			Ext.getCmp('btnDesignatedDepartment').disable();
			Ext.getCmp('btnMedUnit').disable();
		}
	})
	tree.addListener('contextmenu', rightClickFn);//右键菜单代码关键部分
	var nodemenu = new Ext.menu.Menu({
		id:'nodemenu', //在HTML文件中必须有个rightClickCont的DIV元素
		disabled : Ext.BDP.FunLib.Component.DisableFlag('nodemenu'),
		items: [
		{
            iconCls :'icon-useradd',
            handler: AddData,
            id:'menuAddData',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
            text: '注册新用户'
        },{
            iconCls :'icon-update',
            handler: UpdateData,
            id:'menuUpdateData',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'),
            text: '修改'
        },{
            iconCls :'icon-delete',
            handler: DelData,
            id:'menuDelData',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDelData'),
            text: '删除'
        },{
            icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'CT_Loc.png',
            handler: DesignatedDepartment,
            id:'menuDesignatedDepartment',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDesignatedDepartment'),
            text: '指定科室'
        },{
            icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'DHC_CTLoc_MedUnit.png',
            handler: Med,
            id:'menuMed',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuMed'),
            text: '所属医疗单元'
        }]     	
	}); 
 	function rightClickFn(node,e){
 		if (node.attributes.leaf) {
 			Ext.getCmp('update_btn').enable();
			Ext.getCmp('del_btn').enable();
 			Ext.getCmp('menuUpdateData').enable();
			Ext.getCmp('menuDelData').enable();
 			if(node.attributes.CTPCPDesc==""){
				Ext.getCmp('menuDesignatedDepartment').disable();
				Ext.getCmp('menuMed').disable();
				Ext.getCmp('btnDesignatedDepartment').disable();
				Ext.getCmp('btnMedUnit').disable();
			}else{
				Ext.getCmp('menuDesignatedDepartment').enable();
				Ext.getCmp('menuMed').enable();
				Ext.getCmp('btnDesignatedDepartment').enable();
				Ext.getCmp('btnMedUnit').enable();
			} 
 		}else{
 			Ext.getCmp('update_btn').disable();
			Ext.getCmp('del_btn').disable();
			Ext.getCmp('btnDesignatedDepartment').disable();
			Ext.getCmp('btnMedUnit').disable();
 			Ext.getCmp('menuUpdateData').disable();
			Ext.getCmp('menuDelData').disable();
			Ext.getCmp('menuDesignatedDepartment').disable();
			Ext.getCmp('menuMed').disable();
 		}
 		nodemenu.showAt(e.getXY());//menu的showAt，不要忘记
		tree.getSelectionModel().select(node);
    }
    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
	        var selectrow = tree.getSelectionModel().getSelectedNode().id;	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow;
	});	
	Ext.BDP.FunLib.Component.KeyMap(AddData, UpdateData, DelData);
	var viewport = new Ext.Viewport({
		layout : 'border',
		defaults:{split:true},
		items : [searchPanel,treePanel]
	});
	Ext.fly('btnSSUSRDefaultDeptDR').addClass('x-btn-click');
});