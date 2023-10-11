/// 名称: 科室/病区维护
/// 描述: 科室/病区维护，包含增删改查功能，整合附属功能
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2012-10-26
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/ColumnNodeUI.css"> </link>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/column-tree.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ColumnNodeUI.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCheckNodeUI.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ColumnTreeCheckNodeUI.js"> </script>');

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePagePanel.js"> </script>');
	var htmlurl = "../scripts/bdp/AppHelp/Locations/CTLoc.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');


/**----------------------------------掉用外部JS--------------------------------------**/
	var RBResource = '../scripts/bdp/App/Locations/CT_Loc_RBResource.js';//关联医护人员部分
	var CTLocLinkLocationJS = '../scripts/bdp/App/Locations/CT_LocLinkLocation.js';//关联科室部分
	var PACBedJS = '../scripts/bdp/App/Locations/PAC_Bed.js';    //病区床位部分
	//var PACWardRoomJS = '../scripts/bdp/App/Locations/PAC_WardRoom.js';    //房间分配部分---等候区
	var CTLocSimilarDepartmentJS = '../scripts/bdp/App/Locations/CT_Loc_SimilarDepartment.js';    //相似部门部分
	var CT_Loc_ClassifyJS = '../scripts/bdp/App/Locations/CT_Loc_Classify.js';    //科室分类 （病人管理-访问类型位置）
	var CTLocGroupStockJS = '../scripts/bdp/App/Locations/CT_LocGroupStock.js';//库存授权部分
	var DirectoryTreeConfigJS = '../scripts/bdp/App/System/DirectoryTreeConfig.js';//目录树配置部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+RBResource+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocLinkLocationJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+PACBedJS+'"></scr' + 'ipt>');
	//document.write('<scr' + 'ipt type="text/javascript" src="'+PACWardRoomJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocSimilarDepartmentJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CT_Loc_ClassifyJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocGroupStockJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+DirectoryTreeConfigJS+'"></scr' + 'ipt>');
/**----------------------------------掉用外部JS--------------------------------------**/
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
var flagType=getCookie('CTLocFlagType');
if( typeof(flagType) == "undefined") flagType=""
if (flagType=="") var flagType=tkMakeServerCall("web.DHCBL.CT.DirectoryTreeConfig","OpenData","User.CTLoc");
Ext.getUrlParam = function(param) {
    var params = Ext.urlDecode(unescape(location.search.substring(1)));
    return param ? params[param] : params;
};
var communityid=Ext.getUrlParam('communityid');
Ext.onReady(function() {
    var selectNode="",HiddenCat="";
    var type="CTLOCType";
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var pagesize = Ext.BDP.FunLib.PageSize.Main;
    var pagesizelow=Ext.BDP.FunLib.PageSize.Pop;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';

	//**********左侧类别树 *************//
	var fstyle1="",fstyle2="",fstyle3="";
	if(!Sys.ie)  //ie11 ,chorme
	{
		if ("ActiveXObject" in window)  ///ie11
		{
			fstyle1="margin-top: -10px;";
			fstyle2="margin-top: 0;";
			fstyle3="margin-top: -4px;";
		}
		else  //chrome  火狐
		{
			fstyle1="margin-top: -18px;margin-left:-7px;";
			fstyle2="margin-top:-10px;margin-left:-7px;";
			fstyle3="margin-top: -5px;margin-left:-7px;";
		}
	}
	else ///ie10,9,8,7,6
	{
		fstyle1="margin-top: 0;";
		fstyle2="margin-top: 0;";
		fstyle3="margin-top: 0;";
		if(navigator.userAgent.indexOf("MSIE")>0){
      		if(navigator.userAgent.indexOf("MSIE 8.0")>0 && !window.innerWidth){
      			/*fstyle1="margin-top: -13px;";
				fstyle2="margin-top: -10px;";
				fstyle3="margin-top: -7px;";*/
      			fstyle1="margin-top: 0px;";
				fstyle2="margin-top: 0px;";
				fstyle3="margin-top: 0px;";
      		}
    	}
	}
	function removeClass(){
		Ext.fly('btnCTLOCType').removeClass('x-btn-click');
		Ext.fly('btnCTLOCDepDR').removeClass('x-btn-click');
		Ext.fly('btnCTLOCHospitalDR').removeClass('x-btn-click');
	}
	function loadTree(){
		/*CatTreeLoader.dataUrl = CatTree_QUERY_ACTION_URL ;
        CatTreeLoader.baseParams = {LastLevel:"TreeRoot"};
        CatTreeLoader.baseParams.Type = type;
        CatPanel.root.reload();*/
		Ext.getCmp('TreeSearchText').setValue('');
		CatPanel.loadTree(type);
        hiddenPkgs = [],selectNode="",HiddenCat=""
	}
	var height1=document.documentElement.clientHeight
	var height2=document.body.clientHeight
	var windowheight=(height1>height2)? (height1-30):(height2-30)
	var TypePanel = new Ext.Panel({
		items : [{
			xtype: 'buttongroup',
	        columns: 1,
	        items: [{
	        	text:'<div style="'+fstyle1+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">科室类型</div>',
	            id:'btnCTLOCType',
	            width:30,
	            height:windowheight/3,//100,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLOCType'),
	            listeners:{
	            	'click':function(){
	            		removeClass();
	            		Ext.fly('btnCTLOCType').addClass('x-btn-click');
	            		type="CTLOCType";
	            		 loadTree();
	            	}
	            }
	        },{
	        	text:'<div style="'+fstyle2+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">部门组</div>',
	            id:'btnCTLOCDepDR',
	            width:30,
	            height:windowheight/3,//100,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLOCDepDR'),
	            listeners:{
	            	'click':function(){
	            		removeClass();
	            		Ext.fly('btnCTLOCDepDR').addClass('x-btn-click');
	            		type="CTLOCDepDR";
	            		 loadTree();
	            	}
	            }
	        },{
	        	text:'<div style="'+fstyle3+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">医院</div>',
	            id:'btnCTLOCHospitalDR',
	            width:30,
	            height:windowheight/3,//100,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLOCHospitalDR'),
	            listeners:{
	            	'click':function(){
	            		removeClass();
	            		Ext.fly('btnCTLOCHospitalDR').addClass('x-btn-click');
	            		type="CTLOCHospitalDR";
	            		 loadTree();
	            	}
	            }
	        }]

		}]
	});
	var CatTree_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=GetTreeJson";
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
			width:125/*,
			enableKeyEvents: true,
			listeners:{
				keyup:function(node, event) {
					CatPanel.doQuery();
				},
				scope: this
			}*/
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
			tooltip : '查询所有科室',
			id : 'btnReset',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnReset'),
			handler:function(){
				Ext.getCmp('TreeSearchText').setValue('');
				CatPanel.doQuery();
				HiddenCat="";
				Refresh();
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
					loader.baseParams.code =  Ext.getCmp("TextCode").getValue();
					loader.baseParams.desc =  Ext.getCmp("TextDesc").getValue();
					loader.baseParams.treetype = type;
   					loader.baseParams.category = HiddenCat;
			    }, this);
				tree.root.reload();
				tree.getSelectionModel().clearSelections();
   				/*grid.getStore().baseParams={
					code : Ext.getCmp("TextCode").getValue(),
					desc : Ext.getCmp("TextDesc").getValue(),
					treetype:type,
   					category:HiddenCat
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize,
						communityid : communityid
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
/*	var CatTree_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=GetTreeJson";
	var CatTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: "LastLevel",
		dataUrl: CatTree_QUERY_ACTION_URL+'&Type='+type
	});
	var CatPanel = new Ext.tree.TreePanel({
		height:windowheight,
		collapsed:false,
		titleCollapse : false,
		//collapsible:true,
		//xtype:'treepanel',
		id: 'CatTreePanel',
		expanded:true,
		root: root1=new Ext.tree.AsyncTreeNode({
				id:"TreeRoot",
				draggable:false,  //可拖拽的
				expanded:true  //根节点自动展开

			}),
		loader: CatTreeLoader,
		autoScroll: true,
		containerScroll: true,
		rootVisible:false,
	    listeners:{
	           "click":function(node,event) {
           			var nid=node.id;
           			HiddenCat=nid;
           			selectNode=nid;

	   				grid.getStore().baseParams={
						code : Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue(),
						//type : Ext.getCmp("comboCTLOCType").getValue(),
						//dep : Ext.getCmp("comboCTLOCDepDR").getValue(),
						treetype:type,
	   					category:HiddenCat
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : pagesize,
							communityid : communityid
						}
					});

			}
        }
	});*/

	//**********左侧类别树  end*************//
	var ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=GetListJson2";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLoc";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=DeleteData";
	var DEPDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCDepartmentGroup&pClassQuery=GetDataForCmb1";
	var HOSP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=DragNode2";
	//取科主任 用户表
	var BindingSSUser= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassQuery=GetDataForCmb1";
	var BindingBroadPatient= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBroadPatientGroup&pClassQuery=GetDataForCmb1";
	var SEX_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";

	var pagesize=Ext.BDP.FunLib.PageSize.Main;

    	//-----------------翻译开始--------//
	Ext.BDP.FunLib.TableName="CT_Loc"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}

	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTLoc";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/

    //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_Loc"
	});

    //删除功能
    var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗？', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中，请稍候．．．', '提示');
						var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
						AliasGrid.DataRefer = CTLOCRowID;
						AliasGrid.delallAlias();

						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : CTLOCRowID
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												//Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
												 //小气泡数量修改
											    var valLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.CTLOCDesc.split("#")[0];
												var countLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.CTLOCDesc.split("#")[1]-1;
												tree.getSelectionModel().getSelectedNode().parentNode.setText('<span ext:qtitle="" ext:qtip="' + valLoc + '">' + valLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+countLoc+'</h6></span>')
												tree.getSelectionModel().getSelectedNode().parentNode.attributes.CTLOCDesc=valLoc+"#"+countLoc;
												loader.on("beforeload", function(treeLoader, node) {
													loader.baseParams.code =  Ext.getCmp("TextCode").getValue();
													loader.baseParams.desc =  Ext.getCmp("TextDesc").getValue();
													loader.baseParams.treetype =  type;
													loader.baseParams.category =  HiddenCat;
											    }, this);
												tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload();
											}
										});
									}
									else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
										}
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
									}
								}
								else {
									Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败，请检查网络连接！',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
							}
						}, this);
					}
				}, this);
			}
			else {
				Ext.Msg.show({
					title : '提示',
					msg : '请选择需要删除的行！',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
				});
			}
		}
	});



	var CTLOCRowID = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : 'CTLOCRowID',
		hideLabel : 'True',
		hidden : true,
		name : 'CTLOCRowID'
	});

	var CTLOCCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '<font color=red>*</font>代码',
		name : 'CTLOCCode',
		id:'CTLOCCode',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCCode')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCCode'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCCode'),
		allowBlank : false,
		validationEvent : 'blur',
		validator : function(thisText){
    	//Ext.Msg.alert(thisText);
        if(thisText==""){ //当文本框里的内容为空的时候不用此验证
        	return true;
        }
        var className =  "web.DHCBL.CT.CTLoc"; //后台类名称
        var classMethod = "Validate"; //数据重复验证后台函数名
        var id="";
        if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
        	var id = tree.getSelectionModel().getSelectedNode().id; //此条数据的rowid
        }
        var flag = "";
        var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
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
	});

	var CTLOCDesc = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '<font color=red>*</font>描述',
		name : 'CTLOCDesc',
		id:'CTLOCDescF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDescF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDescF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDescF'),
		allowBlank : false,
		validationEvent : 'blur',
    	validator : function(thisText){
    	//Ext.Msg.alert(thisText);
        if(thisText==""){ //当文本框里的内容为空的时候不用此验证
        	return true;
        }
        var className =  "web.DHCBL.CT.CTLoc"; //后台类名称
        var classMethod = "Validate"; //数据重复验证后台函数名
        var id="";
        if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
        	var id = tree.getSelectionModel().getSelectedNode().id;//此条数据的rowid
        }
        var flag = "";
        var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
        //Ext.Msg.alert(flag);
        if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
         	return false;
         }else{
         	return true;
         }
    	},
    	invalidText : '该描述已经存在',
    	listeners : {
        	'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
        	'blur' : function(){
        		if (Ext.getCmp("CTLOCDescF").getValue().indexOf("-")>0){
        			Ext.getCmp("CTLOCContactNameF").setValue(Ext.getCmp("CTLOCDescF").getValue().split("-")[0]);
        		}
        		else{
        			Ext.getCmp("CTLOCContactNameF").setValue(Pinyin.GetJPU(Ext.getCmp("CTLOCDescF").getValue()));
        		}
        	}
    	}
	});

	var CTLOCAddress = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '地址',
		name : 'CTLOCAddress',
		id:'CTLOCAddressF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCAddressF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCAddressF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCAddressF'),
		stripCharsRe :  ' '
	});

	var CTLOCFloor = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '楼层',
		name : 'CTLOCFloor',
		id:'CTLOCFloorF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCFloorF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCFloorF'),
		//disabled : Ext.BDP.Funmib.Component.DisableFlag('CTLOCFloorF'),
		stripCharsRe :  ' '
	});

	var CTLOCWardSingleSex = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '性别',
		name : 'CTLOCWardSingleSex',
		//id:'CTLOCWardSingleSex',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCWardSingleSexF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCWardSingleSexF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		store : new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : SEX_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'CTSEXRowId', 'CTSEXDesc' ])
		}),
		queryParam : 'desc',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTSEXRowId',
		displayField : 'CTSEXDesc',
		hiddenName : 'CTLOCWardSingleSex',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});

	var CTLOCType = new Ext.BDP.FunLib.Component.BaseComboBox({
		//xtype : 'combo',
		fieldLabel : '<font color=red>*</font>科室类型',
		name : 'CTLOCType',
		id:'CTLOCTypeF',
		allowBlank : false,
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCTypeF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCTypeF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCTypeF'),
		store : new Ext.data.SimpleStore({
		fields : ['value', 'text'],
		data : [
			 ['W', 'Ward'],
			 ['E', 'Execute'],
			 ['DI', 'Drug Injection'],
			 ['D', 'Dispensing'],
			 ['C', 'Cashier'],
			 ['O', 'Other'],
			 ['OP', 'Operating Theatre'],
			 ['EM', 'Emergency'],
			 ['DS', 'Day Surgery'],
			 ['MR', 'Medical Records'],
			 ['OR', 'OutPatient Consulting Room'],
			 ['CL', 'Clinic'],
			 ['ADM', 'Admission Point']
			]
		}),
		mode : 'local',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 200,
		valueField : 'value',
		displayField : 'text',
		hiddenName : 'CTLOCType'
	});

	var CTLOCDepDR = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '部门组',
		name : 'CTLOCDepDR',
		id:'CTLOCDepDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		store : new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : DEPDR_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'DEPRowId', 'DEPDesc' ])
		}),
		queryParam : 'desc',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'DEPRowId',
		displayField : 'DEPDesc',
		hiddenName : 'CTLOCDepDR',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});

	var CTLOCDepartmentHeadUserDR = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '科主任',
		name : 'CTLOCDepartmentHeadUserDR',
		id:'CTLOCDepartmentHeadUserDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepartmentHeadUserDRF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepartmentHeadUserDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		store : new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : BindingSSUser }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'SSUSRRowId', 'SSUSRName' ])
		}),
		queryParam : 'desc',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'SSUSRRowId',
		displayField : 'SSUSRName',
		hiddenName : 'CTLOCDepartmentHeadUserDR',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});

	var CTLOCHospitalDR = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '医院',
		name : 'CTLOCHospitalDR',
		id:'CTLOCHospitalDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCHospitalDRF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCHospitalDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCHospitalDRF'),
		store : new Ext.data.Store({
			//autoLoad: true,
			baseParams:{communityid:communityid},
			proxy : new Ext.data.HttpProxy({ url : HOSP_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'HOSPRowId', 'HOSPDesc' ])
		}),
		queryParam : 'desc',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'HOSPRowId',
		displayField : 'HOSPDesc',
		hiddenName : 'CTLOCHospitalDR',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});

	var CTLOCIndex = new Ext.form.Checkbox({
		//xtype : 'checkbox',
		boxLabel : '医嘱索引',
		name : 'CTLOCIndex',
		id:'CTLOCIndexF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCIndexF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCIndexF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCIndexF'),
		inputValue : true?'Y':'N'
	});

	var CTLOCMedicalRecordActive = new Ext.form.Checkbox({
		//xtype : 'checkbox',
		boxLabel : '在此科室病历可用',
		name : 'CTLOCMedicalRecordActive',
		id:'CTLOCMedicalRecordActiveF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCMedicalRecordActiveF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCMedicalRecordActiveF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCMedicalRecordActiveF'),
		inputValue : true?'Y':'N'
	});

	var CTLOCExecuteConfirmation = new Ext.form.Checkbox({
		//xtype : 'checkbox',
		boxLabel : '医嘱执行确认',
		name : 'CTLOCExecuteConfirmation',
		id:'CTLOCExecuteConfirmationF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCExecuteConfirmationF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCExecuteConfirmationF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCExecuteConfirmationF'),
		inputValue : true?'Y':'N'
	});

	var CTLOCContactName = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '<font color=red>*</font>科室检索码',
		name : 'CTLOCContactName',
		id:'CTLOCContactNameF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCContactNameF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCContactNameF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCContactNameF'),
		stripCharsRe :  ' ',
		blankText: '不能为空',
		allowBlank : false
	});

	var CTLOCDateActiveFrom = new Ext.BDP.FunLib.Component.DateField({
		//xtype : 'datefield',
		fieldLabel : '<font color=red>*</font>开始日期',
		name : 'CTLOCDateActiveFrom',
		id:'CTLOCDateActiveFromF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDateActiveFromF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDateActiveFromF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDateActiveFromF'),
		format : BDPDateFormat,
		allowBlank : false,
		enableKeyEvents : true,
		listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
	});

	var CTLOCDateActiveTo = new Ext.BDP.FunLib.Component.DateField({
		//xtype : 'datefield',
		fieldLabel : '结束日期',
		name : 'CTLOCDateActiveTo',
		id:'CTLOCDateActiveToF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDateActiveToF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDateActiveToF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDateActiveToF'),
		format : BDPDateFormat,
		enableKeyEvents : true,
		listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
		//editable : false
	});

		//---年龄最小值
	var CTLOCAgeFrom= new Ext.BDP.FunLib.Component.NumberField({
		fieldLabel : '开始年龄',
		name : 'CTLOCAgeFrom',
		id : 'CTLOCAgeFromF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCAgeFromF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCAgeFromF')),
		dataIndex : 'CTLOCAgeFrom',
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是数字'
	});

	//---年龄最大值
	var CTLOCAgeTo= new Ext.BDP.FunLib.Component.NumberField({
		name : 'CTLOCAgeTo',
		fieldLabel : '截止年龄',
		id : 'CTLOCAgeToF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCAgeToF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCAgeToF')),
		dataIndex : 'CTLOCAgeTo',
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是数字'
	});
	//---作为接收科室时能接收的就诊类型
	var CTLOCClinicType = new Ext.form.CheckboxGroup({
	    id:'CTLOCClinicTypeF',
	    fieldLabel: '作为接收科室时能接收的就诊类型',
	    readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCClinicTypeF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCClinicTypeF')),
	    columns: 1,
	    items: [
	        {boxLabel: '门诊', name: 'CTLOCClinicType', inputValue : 'O'},
	        {boxLabel: '急诊', name: 'CTLOCClinicType', inputValue : 'E'},
	        {boxLabel: '住院', name: 'CTLOCClinicType', inputValue : 'I'},
	        {boxLabel: '体检', name: 'CTLOCClinicType', inputValue : 'H'}
	    ]
	});
	//---病人位置分组
	var CTLOCBroadPatientGroupDR = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '病人位置分组',
		name : 'CTLOCBroadPatientGroupDR',
		id:'CTLOCBroadPatientGroupDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCBroadPatientGroupDRF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCBroadPatientGroupDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCBroadPatientGroupDRF'),
		store : new Ext.data.Store({
			//autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : BindingBroadPatient }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'BPGRowId', 'BPGDesc' ])
		}),
		queryParam : 'desc',
		triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'BPGRowId',
		displayField : 'BPGDesc',
		hiddenName : 'CTLOCBroadPatientGroupDR',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});
	//---联系电话
	var CTLOCTelephone = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '联系电话',
		name : 'CTLOCTelephone',
		id:'CTLOCTelephoneF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCTelephoneF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCTelephoneF'),
		//disabled : Ext.BDP.Funmib.Component.DisableFlag('CTLOCTelephoneF'),
		stripCharsRe :  ' '
	});
	//---检验条码科室简称
	var CTLOCNationCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '检验条码科室简称',
		name : 'CTLOCNationCode',
		id:'CTLOCNationCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCNationCodeF')),
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCNationCodeF'),
		//disabled : Ext.BDP.Funmib.Component.DisableFlag('CTLOCNationCodeF'),
		stripCharsRe :  ' '
	});
    var WinForm = new Ext.form.FormPanel({
	    id:'form-save',
		iconCls: 'icon-tabs',
		labelWidth: 75,
		width: '400',
		labelAlign : 'right',
		title : '基本信息',
		split : true,
		frame : true,
		//bodyStyle:'overflow-y:auto;overflow-x:hidden;',
		//这个属性决定了load和submit中对数据的处理ㄛlist必须是一个集合类型ㄛjson格式应该是[]包含的一个数组
		reader: new Ext.data.JsonReader({root:'list'},
          [{ name: 'CTLOCRowID', mapping:'CTLOCRowID',type: 'string'},
           { name: 'CTLOCCode', mapping:'CTLOCCode',type: 'string'},
           { name: 'CTLOCDesc',mapping:'CTLOCDesc', type: 'string' },
           { name: 'CTLOCAddress', mapping:'CTLOCAddress',type: 'string'},
           { name: 'CTLOCFloor', mapping:'CTLOCFloor',type: 'string'},
           { name: 'CTLOCWardSingleSex',mapping:'CTLOCWardSingleSex', type: 'string' },
           { name: 'CTLOCAgeFrom', mapping:'CTLOCAgeFrom',type: 'string'},
           { name: 'CTLOCAgeTo', mapping:'CTLOCAgeTo',type: 'string'},
           { name: 'CTLOCType',mapping:'CTLOCType', type: 'string' },
           { name: 'CTLOCDepDR', mapping:'CTLOCDepDR',type: 'string'},
           { name: 'CTLOCIndex',mapping:'CTLOCIndex', type: 'string' },
           { name: 'CTLOCHospitalDR', mapping:'CTLOCHospitalDR',type: 'string'},
           { name: 'CTLOCDepartmentHeadUserDR', mapping:'CTLOCDepartmentHeadUserDR',type: 'string'},
           { name: 'CTLOCMedicalRecordActive',mapping:'CTLOCMedicalRecordActive', type: 'string' },
           { name: 'CTLOCExecuteConfirmation',mapping:'CTLOCExecuteConfirmation', type: 'string' },
           { name: 'CTLOCDateActiveFrom', mapping:'CTLOCDateActiveFrom',type: 'string' },
           { name: 'CTLOCDateActiveTo',mapping:'CTLOCDateActiveTo',type: 'string' },
           { name: 'CTLOCContactName', mapping:'CTLOCContactName', type: 'string'},
           { name: 'CTLOCClinicType', mapping:'CTLOCClinicType', type: 'string'},
           { name: 'CTLOCBroadPatientGroupDR', mapping:'CTLOCBroadPatientGroupDR', type: 'string'},
           { name: 'CTLOCTelephone', mapping:'CTLOCTelephone', type: 'string'},
           { name: 'CTLOCNationCode', mapping:'CTLOCNationCode', type: 'string'},
           { name: 'WARDActive', mapping:'WARDActive',type: 'string'},
           { name: 'WARDSingleRoom', mapping:'WARDSingleRoom',type: 'string'},
           { name: 'WARDViewLinkedRooms', mapping:'WARDViewLinkedRooms',type: 'string'},
           { name: 'WARDViewNextMostUrgent', mapping:'WARDViewNextMostUrgent',type: 'string'},
           { name: 'OutPatient', mapping:'OutPatient',type: 'string'},
           { name: 'InPatient', mapping:'InPatient',type: 'string'},
           { name: 'Emergency', mapping:'Emergency',type: 'string'},
           { name: 'HealthPromotion', mapping:'HealthPromotion',type: 'string'}
		]),
		layout : 'column',
		border : false,
		items: [{
			xtype : 'fieldset',
			title : '科室',
			autoHeight : true,
			layout: 'column',
			columnWidth:.7,
			items: [{
		        columnWidth:.5,
		         layout : 'form',
				labelWidth : 110,
				labelPad : 1,
				border : false,
				defaults : {
					anchor : '93%',
					xtype : 'textfield'
				},
		        items : [
		        CTLOCCode,CTLOCAddress,CTLOCType,CTLOCHospitalDR,CTLOCWardSingleSex,CTLOCAgeFrom,CTLOCDateActiveFrom,CTLOCBroadPatientGroupDR,CTLOCTelephone,CTLOCNationCode,CTLOCIndex,CTLOCExecuteConfirmation,CTLOCMedicalRecordActive,CTLOCRowID
		        ]
			    },{
		        columnWidth:.5,
		        layout : 'form',
				labelWidth : 90,
				labelPad : 1,
				border : false,
				defaults : {
					anchor : '93%',
					xtype : 'textfield'
				},
		        items : [
		        CTLOCDesc,CTLOCFloor,CTLOCDepDR,CTLOCDepartmentHeadUserDR,CTLOCContactName,CTLOCAgeTo,CTLOCDateActiveTo,
		        	{
		        	labelWidth : 9,
		            xtype:'fieldset',
		            title: '作为接收科室时能接收的就诊类型' ,
		            autoHeight:true,
		            hideLabels: true,
		            style: 'margin-left:40px;',
		            bodyStyle: 'margin-left:50px;',
		            items: [CTLOCClinicType]
		        	}
		        ]
			    }]
		},
			    	{
		        columnWidth:.3,
		        layout:'form',
		        items:[{
		            xtype:'fieldset',
		            title: '病区' ,
		            autoHeight:true,
		            defaultType: 'checkbox',
		            hideLabels: true,
		            style: 'margin-left:10px;',
		            bodyStyle: 'margin-left:20px;',
		            boxLabelHeight:25,
		            items: [{
		            	disabled : true,
		                boxLabel: '单一房间',
		                name: 'WARDSingleRoom',
		                id:'WARDSingleRoomF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WARDSingleRoomF')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('WARDSingleRoomF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('WARDSingleRoomF'),
		                width: 'auto',
						inputValue : true?'Y':'N'

		            },{
		            	disabled : true,
		                boxLabel: '激活',
		                name: 'WARDActive',
		                id:'WARDActiveF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WARDActiveF')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('WARDActiveF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('WARDActiveF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            },{
		            	disabled : true,
		                boxLabel: 'ViewLinkedRooms',
		                name: 'WARDViewLinkedRooms',
		                id:'WARDViewLinkedRoomsF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WARDViewLinkedRoomsF')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('WARDViewLinkedRoomsF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('WARDViewLinkedRoomsF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            },{
		            	disabled : true,
		                boxLabel: 'ViewNextMostUrgent',
		                name: 'WARDViewNextMostUrgent',
		                id:'WARDViewNextMostUrgentF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WARDViewNextMostUrgentF')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('WARDViewNextMostUrgentF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('WARDViewNextMostUrgentF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            }]
		        },{
		            xtype :'fieldset',
		            title : '说明',
		            autoHeight : true,
		            style : 'margin-left:10px;',
		            bodyStyle : 'margin-left:10px;',
		            html : '"病区"仅对科室类型为"Ward、Emergency"时有效!'
		        },{
		            xtype:'fieldset',
		            title: '科室分类' ,
		            autoHeight:true,
		            defaultType: 'checkbox',
		            hideLabels: true,
		            style: 'margin-left:10px;',
		            bodyStyle: 'margin-left:20px;',
		            boxLabelHeight:25,
		            items: [{
		            	disabled : true,
		                boxLabel: '门诊',
		                name: 'OutPatient',
		                id:'OutPatientF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OutPatientF')),
						//readOnly : Ext.BDP.FunLib.Component.DisableFlag('OutPatientF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('OutPatientF'),
		                width: 'auto',
						inputValue : true?'Y':'N'

		            },{
		            	disabled : true,
		                boxLabel: '急诊',
		                name: 'Emergency',
		                id:'EmergencyF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EmergencyF')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('EmergencyF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('EmergencyF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            },{
		            	disabled : true,
		                boxLabel: '住院',
		                name: 'InPatient',
		                id:'InPatientF',
		                //style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InPatientF')),
						//readOnly : Ext.BDP.FunLib.Component.DisableFlag('InPatientF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('InPatientF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            },{
		            	disabled : true,
		                boxLabel: '体检',
		                name: 'HealthPromotion',
		                id:'HealthPromotionF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HealthPromotionF')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('HealthPromotionF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('HealthPromotionF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            }]
		        }]
		    }]

	});

	//如果科室类型为"Ward"时的监听事件
	Ext.getCmp("form-save").getForm().findField('CTLOCType').on('select', function () {
		if (Ext.getCmp("form-save").getForm().findField('CTLOCType').getValue()=='W' || Ext.getCmp("form-save").getForm().findField('CTLOCType').getValue()=='EM' || Ext.getCmp("form-save").getForm().findField('CTLOCType').getValue()=='OP')
		{
			Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(false);
			Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(false);
			Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(false);
			Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(false);
		}else{
			Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
		}
	});

	var tabs = new Ext.TabPanel({
			 activeTab : 0,
			 frame : true,
			 border : false,
			 //height : 200,
			 width : 560,
			 defaults:{autoScroll:true},
			 items : [WinForm, AliasGrid]
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
			items : tabs,
			buttons:[{
				text:'保存',
				id:'save_btn',
				iconCls : 'icon-save',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
				handler:function(){
					   if(WinForm.getForm().isValid()==false){
							 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
							 return;
						}
						var tempCode = Ext.getCmp("form-save").getForm().findField("CTLOCCode").getValue();
						var tempDesc = Ext.getCmp("form-save").getForm().findField("CTLOCDesc").getValue();
						var startDate = Ext.getCmp("form-save").getForm().findField("CTLOCDateActiveFrom").getValue();
		    			var endDate = Ext.getCmp("form-save").getForm().findField("CTLOCDateActiveTo").getValue();
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
		    			if (startDate != "" && endDate != "") {
		        			if (startDate > endDate) {
		        				Ext.Msg.show({ title : '提示', msg : '开始日期不能大于结束日期！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			 	return;
		      				}
		   			 	}

		   			 	var CTLOCType = Ext.getCmp("form-save").getForm().findField("CTLOCType").getValue();
		   			 	var CTLOCDepDR = Ext.getCmp("form-save").getForm().findField("CTLOCDepDR").getValue();
		   			 	var CTLOCHospitalDR = Ext.getCmp("form-save").getForm().findField("CTLOCHospitalDR").getValue();

		   			 	//就诊类型赋值
		    			var ClinicValues="";
					    var ClinicTypes = CTLOCClinicType.items;
					    for (var i = 0; i < ClinicTypes.length; i++) {
					        if (ClinicTypes.itemAt(i).checked) {
					            if(ClinicValues =="") {
					            	ClinicValues=ClinicTypes.itemAt(i).inputValue
					            } else {
					            	ClinicValues=ClinicValues+"&"+ClinicTypes.itemAt(i).inputValue
					            }
					        }
					    }

						if (win.title == "添加") {
						WinForm.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后',
							waitTitle : '提示',
							url : SAVE_ACTION_URL,
							params:{'ClinicValues':ClinicValues},
							method : 'POST',
							success : function(form, action) {
								if (action.result.success == 'true') {
									win.hide();
									var myrowid = action.result.id;
									Ext.Msg.show({
												title : '提示',
												msg : '添加成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													/*grid.getStore().load({
														params : {
															start : 0,
															limit : 1,
															rowid : myrowid
														}
													});*/
													loader.on("beforeload", function(treeLoader, node) {
														loader.baseParams.code =  Ext.getCmp("TextCode").getValue();
														loader.baseParams.desc =  Ext.getCmp("TextDesc").getValue();
														loader.baseParams.treetype =  type;
														loader.baseParams.category =  HiddenCat;
												    }, this);
												    tree.root.reload();
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
												msg : '添加失败！' + errorMsg,
												minWidth : 200,
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}

							},
							failure : function(form, action) {
								Ext.Msg.alert('提示', '异步通讯失败，请检查网络连接！');
							}
						})
					} else {
						Ext.MessageBox.confirm('提示', '确定要修改该条数据吗？', function(btn) {
							if (btn == 'yes') {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									params:{'ClinicValues':ClinicValues},
									method : 'POST',
									success : function(form, action) {
										//保存别名
												AliasGrid.saveAlias();
										// alert(action);
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = "rowid="+ action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
												title : '提示',
												msg : '修改成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													//Ext.BDP.FunLib.ReturnDataForUpdate("grid",QUERY_ACTION_URL,myrowid);
													tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload();
													//小气泡数量修改
													var rule="";
													if (flagType=="CTLOCType"){rule=CTLOCType;}
													else if(flagType=="CTLOCDepDR"){rule=CTLOCDepDR;}
													else if(flagType=="CTLOCHospitalDR"){rule=CTLOCHospitalDR;}

													if (rule!=tree.getSelectionModel().getSelectedNode().parentNode.attributes.id.substring(1)){
														var oldValLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.CTLOCDesc.split("#")[0];
														var oldCountLoc=tree.getSelectionModel().getSelectedNode().parentNode.attributes.CTLOCDesc.split("#")[1]-1;
														tree.getSelectionModel().getSelectedNode().parentNode.setText('<span ext:qtitle="" ext:qtip="' + oldValLoc + '">' + oldValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+oldCountLoc+'</h6></span>')
														tree.getSelectionModel().getSelectedNode().parentNode.attributes.CTLOCDesc=oldValLoc+"#"+oldCountLoc;
														if (rule==""){
															var newValLoc=tree.getNodeById("H0").attributes.CTLOCDesc.split("#")[0];
															var newCountLoc=parseInt(tree.getNodeById("H0").attributes.CTLOCDesc.split("#")[1])+1;
															tree.getNodeById("H0").setText('<span ext:qtitle="" ext:qtip="' + newValLoc + '">' + newValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountLoc+'</h6></span>')
															tree.getNodeById("H0").attributes.CTLOCDesc=newValLoc+"#"+newCountLoc;
														}else{
															var newValLoc=tree.getNodeById("H"+rule).attributes.CTLOCDesc.split("#")[0];
															var newCountLoc=parseInt(tree.getNodeById("H"+rule).attributes.CTLOCDesc.split("#")[1])+1;
															tree.getNodeById("H"+rule).setText('<span ext:qtitle="" ext:qtip="' + newValLoc + '">' + newValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountLoc+'</h6></span>')
															tree.getNodeById("H"+rule).attributes.CTLOCDesc=newValLoc+"#"+newCountLoc;
														}


														loader.on("beforeload", function(treeLoader, node) {
															loader.baseParams.code =  Ext.getCmp("TextCode").getValue();
															loader.baseParams.desc =  Ext.getCmp("TextDesc").getValue();
															loader.baseParams.treetype =  type;
															loader.baseParams.category =  HiddenCat;
															loader.baseParams.rebuild =  "Y";
													    }, this);

													    if (rule==""){
													    	if (tree.getSelectionModel().getSelectedNode().parentNode.attributes.id!="H0"){
													    		tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload();
													    	}
													    	tree.getNodeById("H0").reload();
													    }else{
													    	if (tree.getSelectionModel().getSelectedNode().parentNode.attributes.id!="H"+rule){
													    		tree.getNodeById(tree.getSelectionModel().getSelectedNode().parentNode.attributes.id).reload();
													    	}
													    	tree.getNodeById("H"+rule).reload();
													    }
													}

												}
											});
										} else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:' + action.result.errorinfo
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
					win.hide();
				}
			}],
			listeners:{
				"show":function(){
					Ext.getCmp("CTLOCCode").focus(true,500);
				},
				"hide":function(){
					Ext.BDP.FunLib.Component.FromHideClearFlag();
				},
				"close":function(){
				}
			}
		});
    var btnAddwin = new Ext.Toolbar.Button({
        text: '添加',
        tooltip: '添加',
        iconCls: 'icon-add',
        id:'add_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
        handler: AddData =function () {
				win.setTitle('添加');
				win.setIconClass('icon-add');
				win.show('new1');
				WinForm.getForm().reset();
				//右键添加科室设置默认值
				if (tree.getSelectionModel().getSelectedNode()){
					if(tree.getSelectionModel().getSelectedNode().attributes.id.substring(0,1)=="H"){
						var flagValue=tree.getSelectionModel().getSelectedNode().attributes.id.substring(1);
						if (flagType=="CTLOCHospitalDR"){
							Ext.getCmp("CTLOCHospitalDRF").setValue(flagValue)
						}else if(flagType=="CTLOCType"){
							Ext.getCmp("CTLOCTypeF").setValue(flagValue)
						}else if(flagType=="CTLOCDepDR"){
							Ext.getCmp("CTLOCDepDRF").setValue(flagValue)
						}
					}
				}

				Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);

				//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
        },
        scope: this
    });
    var btnEditwin = new Ext.Toolbar.Button({
        text: '修改',
        tooltip: '修改',
        iconCls: 'icon-update',
        id:'update_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
        handler: UpdateData=function() {
        	if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
					win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
					if(tree.getSelectionModel().getSelectedNode().attributes.CTLOCType=="W" || tree.getSelectionModel().getSelectedNode().attributes.CTLOCType=='EM' || tree.getSelectionModel().getSelectedNode().attributes.CTLOCType=='OP'){
						Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(false);
					}else{
						Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
					}
					var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + CTLOCRowID,
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                	var ClinicValues=action.result.data.CTLOCClinicType;//获取就诊类型值串
							var checkboxGroup=Ext.getCmp('CTLOCClinicTypeF');
							if(ClinicValues!=""){
							  	var val=ClinicValues.split("&");
								var items=checkboxGroup.items;
								checkboxGroup.reset();
								for(var i=0;i<val.length;i++){
							      items.each(function(items){
							          if(items.inputValue==val[i]){
							          	items.setValue(true);           //前台动态选中就诊类型多选框
							          }
							      })
							    }
							}
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		             //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = CTLOCRowID;
				        AliasGrid.loadGrid();
			}
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择需要修改的行!!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}
        }
    });
    var deptgroupurl="dhc.bdp.ext.default.csp?extfilename=App/Locations/RBC_DepartmentGroup"
    if ('undefined'!==typeof websys_getMWToken){
		deptgroupurl += "&MWToken="+websys_getMWToken()
	}

	///*科室部门组维护*//
	var RBCDepartmentGroupWin = new Ext.Window({
		title:'',
		width:850,
        height:550,
		layout:'fit',
		closeAction:'hide',
		html:'<iframe src="'+deptgroupurl+'" width="100%" height="100%"></iframe>'
	});



/*	var btnRBCDepartmentGroup = new Ext.Toolbar.Button({				//科室部门组维护
	    text: '科室部门组维护',
	    id:'btnRBCDepartmentGroup',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRBCDepartmentGroup'),
        iconCls: 'icon-DP',
		tooltip: '科室部门组维护',
        handler: function RBCDepartmentGroupWinEdit() {
				RBCDepartmentGroupWin.setTitle('科室部门组维护');
				RBCDepartmentGroupWin.setIconClass('icon-DP');
				RBCDepartmentGroupWin.show('');
        }
	});*/


	/** 关联医护人员部分  **/
	var winRelevanceCareProv = new Ext.Window(getResourcePanel());  //调用CT_CareProv_Resource.js的指定科室面板

	var btnRelevanceCareProv = new Ext.Toolbar.Button({    //关联医护人员
	    text: '关联医护人员',
        tooltip: '关联医护人员',
        iconCls: 'icon-careprov',
        id:'btnRelevanceCareProv',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRelevanceCareProv'),
        handler: RelevanceCareProv = function() {
        if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {

            var id = tree.getSelectionModel().getSelectedNode().id;
            var flag = tree.getSelectionModel().getSelectedNode().attributes.CTLOCType;

	        RBCareProvStore.baseParams={type:flag}
            RBCareProvStore.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Combo}});

			winRelevanceCareProv.setTitle('关联医护人员');
		    winRelevanceCareProv.setIconClass('icon-careprov');
		    winRelevanceCareProv.show('');
		    var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;

            //var RESCode=rows[0].get('CTPCPCode');
            gridResource.getStore().baseParams={LOCDR:CTLOCRowID};
            gridResource.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});

            //var RESCTPCPDR=rows[0].get('CTPCPRowId1');
            //var RESDesc=rows[0].get('CTPCPDesc');
            Ext.getCmp("hidden_CTLOCRowID").reset();
            Ext.getCmp("hidden_CTLOCRowID").setValue(CTLOCRowID);

            Ext.getCmp("comboxResource").reset();
			//getForm().getValues() getForm().getFieldValues()
		}
        else
		{
		Ext.Msg.show({
					title:'提示',
					msg:'请选择需要关联的科室!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}

        }
	});


	 var winCTLocLinkLocation = new Ext.Window(getCTLocLinkLocationPanel());  //调用CT_CareProv_Resource.js的指定科室面板

	var btnCTLocLinkLocation = new Ext.Toolbar.Button({				//关联科室
	    text: '关联科室',
	    id:'btnCTLocLinkLocation',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocLinkLocation'),
        iconCls: 'icon-LinkLoc',
		tooltip: '关联科室',
        handler: CTLocLinkLocationWinEdit = function() {
    	if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
			winCTLocLinkLocation.setTitle('关联科室');
			winCTLocLinkLocation.setIconClass('icon-LinkLoc');
			winCTLocLinkLocation.show('');
            var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
            Ext.getCmp("Hidden_LocLink_CTLocID").reset();
           	Ext.getCmp("Hidden_LocLink_CTLocID").setValue(CTLOCRowID);
            gridCTLocLinkLocation.getStore().baseParams={rowid:CTLOCRowID};
           	gridCTLocLinkLocation.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
           	Ext.getCmp("LINKCTLOCDR1").getStore().load();
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择需要关联的科室!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}
        }
	});

	var winPacBed = new Ext.Window(getPacBedPanel());  //调用病区床位弹出框

	var btnPacBed = new Ext.Toolbar.Button({				//病区床位
	    text: '病区床位',
	    id:'btnPacBed',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'),
        iconCls: 'icon-bed',
		tooltip: '病区床位--科室类型为Ward或Emergency时激活',
        handler: PacBedWinEdit = function () {
        if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
			winPacBed.setIconClass('icon-bed');
			winPacBed.show();
       		var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
       		var CTLOCDesc=tree.getSelectionModel().getSelectedNode().attributes.CTLOCDesc;
       		winPacBed.setTitle('病区床位--'+CTLOCDesc);
       		Ext.getCmp("CTLOCDesc_HIDDEN").reset();
			Ext.getCmp("CTLOCDesc_HIDDEN").setValue(CTLOCDesc);
       		Ext.getCmp("CTLOCRowID_HIDDEN").reset();
           	Ext.getCmp("CTLOCRowID_HIDDEN").setValue(CTLOCRowID);
       		var WARDParRef = tkMakeServerCall("web.DHCBL.CT.PACBed","GetWARDParRef",CTLOCRowID);
       		Ext.getCmp("hidden_ref").reset();
           	Ext.getCmp("hidden_ref").setValue(WARDParRef);
           	PACBedds.baseParams={ParRef:WARDParRef}
       		PACBedds.load({params:{start:0, limit:pagesizelow}});
        }
        else
		{
			Ext.Msg.show({
					title:'提示',
					msg:'请选择科室!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}
        }
	});
	/*
	var winPACWardRoom = new Ext.Window(getPACWardRoomPanel());  //调用CT_CareProv_Resource.js的指定科室面板

	var btnPACWardRoom = new Ext.Toolbar.Button({				//房间分配
	    text: '房间分配',
	    id:'btnPACWardRoom',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPACWardRoom'),
        iconCls: 'icon-wardroom',
		tooltip: '房间分配',
        handler: function PACWardRoomWinEdit() {
	        var _record = grid.getSelectionModel().getSelected();
	        if(_record){
				winPACWardRoom.setIconClass('icon-wardroom');
				winPACWardRoom.show('');
				var gsm = grid.getSelectionModel();//获取选择列
	        	var rows = gsm.getSelections();//根据选择列获取到所有的行
	           	var CTLOCRowID=rows[0].get('CTLOCRowID');
	           	var CTLOCDesc=rows[0].get('CTLOCDesc');
	           	winPACWardRoom.setTitle('房间分配--'+CTLOCDesc);
	           	Ext.getCmp("CTLOCRowID_HIDDEN").reset();
           		Ext.getCmp("CTLOCRowID_HIDDEN").setValue(CTLOCRowID);
       			var WardRoomParRef = tkMakeServerCall("web.DHCBL.CT.PACWardRoom","GetWardRoomParRef",CTLOCRowID);
	           	Ext.getCmp("hidden_ref").reset();
           		Ext.getCmp("hidden_ref").setValue(WardRoomParRef);
           		//alert(WardRoomParRef); //5
	            PACWardRoom_ds.baseParams={ROOMParRef:WardRoomParRef}
	           	PACWardRoom_ds.load({params:{start:0, limit:pagesizelow}});
	         }
	        else
			{
				Ext.Msg.show({
					title:'提示',
					msg:'请选择需要修改的行!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
			}
        }
	});*/

	var winCTLocSimilarDepartment = new Ext.Window(getCTLocSimilarDepartmentPanel());  //调用CT_CareProv_Resource.js的指定科室面板

	var btnCTLocSimilarDepartment = new Ext.Toolbar.Button({				//相似部门
	    text: '相似部门',
	    id:'btnCTLocSimilarDepartment',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'),
        iconCls: 'icon-similar',
		tooltip: '相似部门',
        handler: CTLocSimilarDepartmentWinEdit =function() {
	        if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
				winCTLocSimilarDepartment.setIconClass('icon-similar');
				winCTLocSimilarDepartment.show('');
	           	var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
	           	var CTLOCDesc=tree.getSelectionModel().getSelectedNode().attributes.CTLOCDesc;
		   		winCTLocSimilarDepartment.setTitle('相似部门--'+CTLOCDesc);
		   		Ext.getCmp("TextCode2").reset();
		   		Ext.getCmp("CTLocSimilarDepartment_CTLocID").reset();
		       	Ext.getCmp("CTLocSimilarDepartment_CTLocID").setValue(CTLOCRowID);
		       	CTLocSimilarDepartment_ds.baseParams={DEPParRef:CTLOCRowID}
	           	CTLocSimilarDepartment_ds.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
	        }
	        else
			{
				Ext.Msg.show({
					title:'提示',
					msg:'请选择科室!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
			}
        }
	});

	var winLocClassify = new Ext.Window(getLocClassifyPanel());  //调用病人类型

	var btnLocClassify = new Ext.Toolbar.Button({				//病人类型
	    text: '科室分类',
	    id:'btnLocClassify',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLocClassify'),
        iconCls: 'icon-AdmType',
		tooltip: '科室分类',
        handler: LocClassifyWinEdit =function() {
        if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
			winLocClassify.setIconClass('icon-AdmType');
			winLocClassify.show('');
        	var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
           	var CTLOCDesc=tree.getSelectionModel().getSelectedNode().attributes.CTLOCDesc;
           	winLocClassify.setTitle('科室分类-'+CTLOCDesc);



	   		Ext.getCmp("hidden_LocRef").reset();
	       	Ext.getCmp("hidden_LocRef").setValue(CTLOCRowID);
	       	LocClassifyds.baseParams={CTLOCRowID:CTLOCRowID}
           	LocClassifyds.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
        }
        else
		{
			Ext.Msg.show({
					title:'提示',
					msg:'请选择科室!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
		}
        }
	});
	var winCTLocGroupStock = new Ext.Window(getCTLocGroupStockPanel());  //调用CT_LocGroupStock.js的库存授权面板

	var btnCTLocGroupStock = new Ext.Toolbar.Button({				//库存授权
	    text: '库存授权',
	    id:'btnCTLocGroupStock',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocGroupStock'),
        iconCls: 'icon-DP',
		tooltip: '库存授权',
        handler: CTLocGroupStockWinEdit =function() {
    	if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
            var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
            Ext.getCmp("Hidden_GroupStock_CTLocID").reset();
           	Ext.getCmp("Hidden_GroupStock_CTLocID").setValue(CTLOCRowID);
           	menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL+ '&LocId='+Ext.getCmp("Hidden_GroupStock_CTLocID").getValue();
			menuPanel.root.reload();
			winCTLocGroupStock.setTitle('库存授权');
			winCTLocGroupStock.setIconClass('icon-DP');
			winCTLocGroupStock.show('');
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择科室!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}
        }
	});
	//科室配置
    //var url="dhc.bdp.ext.default.csp?extfilename=/App/Locations/CT_Loc_Authorize";
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCMessageLocConfig";
	if ('undefined'!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken()
	}
    var ObjectType="G";
    var ObjectReference="1";
	var LocAutWin = new Ext.Window({
		width:600,
		title: '科室接收消息权限配置',
		iconCls: 'icon-NewsA',
	    height:530,
	    layout:'fit',
	    frame :true,
		closeAction:'hide',
		//html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"&ObjectType="+ObjectType+"&ObjectReference="+ObjectReference+"'></iframe>",
		html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
		listeners : {
			"hide" : function() {
	 		/*grid.getStore().load({
				params : {
				start : 0,
				limit : pagesize
				}
			});*/
		}
		}
	});
	var btnLocAut = new Ext.Toolbar.Button({	 //相似部门
	    text: '科室接收消息权限配置',
	    id:'btnLocAut',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLocAut'),
	    iconCls: 'icon-NewsA',
		tooltip: '科室接收消息权限配置',
	        handler: function CTLocAut() {
	        	LocAutWin.show();
	        }
	});
	var fields= [{ name: 'CTLOCRowID', mapping:'CTLOCRowID',type: 'string'},
           { name: 'CTLOCCode', mapping:'CTLOCCode',type: 'string'},
           { name: 'CTLOCDesc',mapping:'CTLOCDesc', type: 'string' },
           //{ name: 'CTLOCAddress', mapping:'CTLOCAddress',type: 'string'},
           { name: 'CTLOCType',mapping:'CTLOCType', type: 'string' },
           { name: 'DEPDesc', mapping:'DEPDesc',type: 'string'},
           { name: 'CTLOCIndex',mapping:'CTLOCIndex', type: 'string' },
           { name: 'CTLOCMedicalRecordActive',mapping:'CTLOCMedicalRecordActive', type: 'string' },
           { name: 'CTLOCExecuteConfirmation',mapping:'CTLOCExecuteConfirmation', type: 'string' },
           { name: 'CTLOCDateActiveFrom', mapping:'CTLOCDateActiveFrom',type: 'date'},
           { name: 'CTLOCDateActiveTo',mapping:'CTLOCDateActiveTo',type: 'date'}
           //{ name: 'CTLOCContactName', mapping:'CTLOCContactName', type: 'string'}//列的映射
		];
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},fields )
    });

    ds.on('beforeload',function(thiz,options){
		Ext.apply(
		  this.baseParams,
		  {
		     communityid:communityid
		  }
		)
	});
	ds.load({
    	params:{start:0, limit:pagesize},
    	callback: function(records, options, success){
    		//alert(options);
			//Ext.Msg.alert('info', '加载完毕, success  = '+ records.length);
		}
	}); //加载数据

	var winDirectoryTreeConfig = new Ext.Window(getConfigPanel());  //调用DirectoryTreeConfig.js的目录树配置面板
    // 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin,
		'-', btnDel,
		//'-',btnRBCDepartmentGroup,
		'-',btnRelevanceCareProv,
		'-',btnCTLocLinkLocation,'-',btnPacBed,'-', // btnPACWardRoom,'-',
		btnCTLocSimilarDepartment,'-',btnLocClassify, '-' ,btnCTLocGroupStock,'-',btnSort,'-',btnTrans,'->',
			{
			   	text: '更多功能',
			   	icon:Ext.BDP.FunLib.Path.URL_Icon +'list-items.gif',
			   	menu: new Ext.menu.Menu({
			        items: [
			        	{text: '切换为列表展示',id : 'btnSwitch',iconCls:'icon-refresh',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSwitch'),handler:function(){
				        	//var userId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.Locations.CTLoc",""); //用户列表菜单id
							//window.location.href="dhc.bdp.ext.sys.csp?BDPMENU="+userId;
			        		window.location.href="dhc.bdp.ext.default.csp?extfilename=App/Locations/CT_Loc.js";
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
			         		if ('undefined'!==typeof websys_getMWToken){
								link += "&MWToken="+websys_getMWToken()
							}
			         		var link=encodeURI(link)
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
				            LogWin.html='<iframe id="iframlog" src=" '+link+' " width="100%" height="100%"></iframe>';
				            LogWin.show();
			         	}},
			         	{text: '查看数据生命周期',id:'btnhislog',icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnhislog'),handler:function(){
			         	    var RowID="",Desc="";
						    if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
						       RowID=tree.getSelectionModel().getSelectedNode().id;
						       Desc=tree.getSelectionModel().getSelectedNode().attributes.CTLOCDesc;
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
								    if ('undefined'!==typeof websys_getMWToken){
										link += "&MWToken="+websys_getMWToken()
									}	
								    var link=encodeURI(link)
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
			         	}},'-',
				        {text: '科室接收消息权限配置',id:'btnLocAut',iconCls:'icon-NewsA',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLocAut'), handler:function(){
				        	LocAutWin.show();
				        }}
			        ]
			   	})
			}]//,btnlog,'-',btnhislog,'-',btnLocAut
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
		text : '搜索',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
		handler : search=function() {
			loader.on("beforeload", function(treeLoader, node) {
				loader.baseParams.code =  Ext.getCmp("TextCode").getValue();
				loader.baseParams.desc =  Ext.getCmp("TextDesc").getValue();
				loader.baseParams.treetype =  type;
				loader.baseParams.category =  HiddenCat;
		    }, this);
		    tree.root.reload();
		    tree.getSelectionModel().clearSelections();
			/*grid.getStore().baseParams={
					code : Ext.getCmp("TextCode").getValue(),
					desc : Ext.getCmp("TextDesc").getValue(),
					treetype:type,
					category:HiddenCat
			};
			grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize,
					communityid : communityid
				}
			});*/
		}
	});

	// 刷新工作条
	var btnRefresh = new Ext.Button({
		id : 'btnRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
		handler : Refresh = function() {
			Ext.getCmp("TextCode").reset();
			Ext.getCmp("TextDesc").reset();
		    tree.root.reload();
		    tree.getSelectionModel().clearSelections();
			/*grid.getStore().baseParams = {
					treetype:type,
					category:HiddenCat
				};
			grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize,
						communityid:communityid
					}
				});*/

			/*Ext.getCmp("comboCTLOCType").reset();
			Ext.getCmp("comboCTLOCDepDR").reset();*/
		}
	});

	// 将工具条放到一起
	var tb = new Ext.Toolbar({
		id : 'tb',
		items : [{xtype: 'textfield',id: 'CTLOCDesc_HIDDEN',hidden : true},
					'代码', {
					xtype : 'textfield',
					id : 'TextCode',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							search()
						},
						scope: this
					}
				}, '-',
				'描述', {
					xtype : 'textfield',
					id : 'TextDesc',
					width:120,
					emptyText : '描述/别名',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							search()
						},
						scope: this
					}
				}/*, '-','科室类型:',{
					xtype : 'combo',
					fieldLabel : '科室类型',
					id:'comboCTLOCType',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('comboCTLOCType'),
					store : new Ext.data.SimpleStore({
					fields : ['value', 'text'],
					data : [
							 ['W', 'Ward'],
							 ['E', 'Execute'],
							 ['DI', 'Drug Injection'],
							 ['D', 'Dispensing'],
							 ['C', 'Cashier'],
							 ['O', 'Other'],
							 ['OP', 'Operating Theatre'],
							 ['EM', 'Emergency'],
							 ['DS', 'Day Surgery'],
							 ['MR', 'Medical Records'],
							 ['OR', 'OutPatient Consulting Room'],
							 ['CL', 'Clinic'],
							 ['ADM', 'Admission Point']
							]
					}),
					mode : 'local',
					triggerAction : 'all',
					forceSelection : true,
					selectOnFocus : false,
					//typeAhead : true,
					//minChars : 1,
					listWidth : 200,
					valueField : 'value',
					displayField : 'text',
					hiddenName : 'CTLOCType',
					listeners:{
						   'select': function(field,e){
						         search();
		                 	}
					}
				}
				,'-','部门组:',{
					xtype:'bdpcombo',
					loadByIdParam : 'rowid',
					fieldLabel : '部门组',
					id:'comboCTLOCDepDR',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('comboCTLOCDepDR'),
					store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : DEPDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'DEPRowId', 'DEPDesc' ])
					}),
					queryParam : 'desc',
					triggerAction : 'all',
					forceSelection : true,
					selectOnFocus : false,
					//typeAhead : true,
					//minChars : 1,
					listWidth : 250,
					valueField : 'DEPRowId',
					displayField : 'DEPDesc',
					hiddenName : 'CTLOCDepDR',
					pageSize : Ext.BDP.FunLib.PageSize.Combo
				},'-'*/,{
			xtype: 'textfield',
			id: 'hidden_ref',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('hidden_ref'),
			hidden : true
			},
				{
			xtype: 'textfield',
			id: 'CTLOCRowID_HIDDEN',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCRowID_HIDDEN'), //为了床位图查询用 //房间分配也用到了，可以放在ctloc.js里？？
			hidden : true
			},'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName), '-', btnSearch, '-', btnRefresh, '->',helphtmlbtn
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
			loader.baseParams.flagType=flagType;
	});
	var cm=[
			{header: '描述',width: 260,dataIndex: 'CTLOCDesc',renderer: Ext.BDP.FunLib.Component.TreeTipShow},
			{header: '代码',width: 120,dataIndex: 'CTLOCCode'},
			{header: 'ID',width: 20,dataIndex: 'id',hidden : true},
			//{header: '地址',width: 120,dataIndex: 'CTLOCAddress',renderer: Ext.BDP.FunLib.Component.GirdTipShow},
			{header: '科室类型',width: 80,dataIndex: 'CTLOCType',
    			renderer : function(v){
					if(v=='W'){ return 'Ward'; }
					if(v=='E'){ return 'Execute'; }
					if(v=='DI'){ return 'Drug Injection'; }
					if(v=='D'){ return 'Dispensing'; }
					if(v=='C'){ return 'Cashier'; }
					if(v=='O'){ return 'Other'; }
					if(v=='OP'){ return 'Operating Theatre'; }
					if(v=='EM'){ return 'Emergency'; }
					if(v=='DS'){ return 'Day Surgery'; }
					if(v=='MR'){ return 'Medical Records'; }
					if(v=='OR'){ return 'OutPatient Consulting Room'; }
					if(v=='CL'){ return 'Clinic'; }
					if(v=='ADM'){ return 'Admission Point'; }
				}},
			{header: '部门组',width: 70,dataIndex: 'DEPDesc'},
			{header: '医嘱索引',width: 60,dataIndex: 'CTLOCIndex',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
			{header: '在此科室病历可用',width: 60,dataIndex: 'CTLOCMedicalRecordActive',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
			{header: '医嘱执行确认',width: 60,dataIndex: 'CTLOCExecuteConfirmation',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
			{header: '开始日期',width: 80,renderer: Ext.util.Format.dateRenderer(BDPDateFormat),dataIndex: 'CTLOCDateActiveFrom'},
			{header: '结束日期',width: 80,renderer: Ext.util.Format.dateRenderer(BDPDateFormat),dataIndex: 'CTLOCDateActiveTo'}
			//{header: '科室检索码',width: 85,dataIndex: 'CTLOCContactName'}
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
            text: '科室/病区'
        })
    });
    /*********************目录树end*******************************************/
	var treePanel = new Ext.Panel({
		title:'科室/病区维护',
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
								var oldValLoc=oldParent.attributes.CTLOCDesc.split("#")[0];
								var oldCountLoc=oldParent.attributes.CTLOCDesc.split("#")[1]-1;
								oldParent.setText('<span ext:qtitle="" ext:qtip="' + oldValLoc + '">' + oldValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+oldCountLoc+'</h6></span>')
								oldParent.attributes.CTLOCDesc=oldValLoc+"#"+oldCountLoc;
								var newValLoc=newParent.attributes.CTLOCDesc.split("#")[0];
								var newCountLoc=parseInt(newParent.attributes.CTLOCDesc.split("#")[1])+1;
								newParent.setText('<span ext:qtitle="" ext:qtip="' + newValLoc + '">' + newValLoc + '<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>'+newCountLoc+'</h6></span>')
								newParent.attributes.CTLOCDesc=newValLoc+"#"+newCountLoc;
							}
							loader.on("beforeload", function(treeLoader, node) {
								loader.baseParams.code =  Ext.getCmp("TextCode").getValue();
								loader.baseParams.desc =  Ext.getCmp("TextDesc").getValue();
								loader.baseParams.treetype =  type;
								loader.baseParams.category =  HiddenCat;
						    }, this);

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
	//双击事件
	tree.on("dblclick",function (node, e){
		if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
			if(tree.getSelectionModel().getSelectedNode().attributes.CTLOCType=="W" || tree.getSelectionModel().getSelectedNode().attributes.CTLOCType=="EM" || tree.getSelectionModel().getSelectedNode().attributes.CTLOCType=="OP" ){
				Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(false);
			}else{
				Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
			}
			var CTLOCRowID=tree.getSelectionModel().getSelectedNode().id;
            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + CTLOCRowID,
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                	var ClinicValues=action.result.data.CTLOCClinicType;//获取就诊类型值串
					var checkboxGroup=Ext.getCmp('CTLOCClinicTypeF');
					if(ClinicValues!=""){
					  	var val=ClinicValues.split("&");
						var items=checkboxGroup.items;
						checkboxGroup.reset();
						for(var i=0;i<val.length;i++){
					      items.each(function(items){
					          if(items.inputValue==val[i]){
					          	items.setValue(true);           //前台动态选中就诊类型多选框
					          }
					      })
					    }
					}
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = CTLOCRowID;
			        AliasGrid.loadGrid();
		}else{
			Ext.example.msg('修改操作', '请选择要修改的一项');
		}
	});

		//单击事件（翻译按钮要用到）
		btnTrans.on("click",function(){
			if ((tree.getSelectionModel().getSelectedNode())&&(tree.getSelectionModel().getSelectedNode().attributes.leaf==true)) {
		        var selectrow = tree.getSelectionModel().getSelectedNode().id;
			 } else {
			 	var selectrow="";
			 }
			 Ext.BDP.FunLib.SelectRowId = selectrow;
		});

		tree.on("click",function(node,e){
			if (node.attributes.leaf) {
				btnEditwin.setDisabled(false);
				btnDel.setDisabled(false);
				btnRelevanceCareProv.setDisabled(false);
				btnCTLocLinkLocation.setDisabled(false);
				btnLocClassify.setDisabled(false);
				btnCTLocGroupStock.setDisabled(false);
				if(node.attributes.CTLOCType!="W")
				{
					if((node.attributes.CTLOCType!="EM")&(node.attributes.CTLOCType!="OP"))
					{
						if(!Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'))
						{
							btnPacBed.setDisabled(true);
						}
						if(!Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'))
						{
							btnCTLocSimilarDepartment.setDisabled(false);
						}
					}
					else
					{
						if(!Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'))
						{
							btnPacBed.setDisabled(false);
						}
						if(!Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'))
						{
							btnCTLocSimilarDepartment.setDisabled(false);
						}
					}
				}
				else
				{
				 	if(!Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'))
					{
						btnPacBed.setDisabled(false);
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'))
					{
						btnCTLocSimilarDepartment.setDisabled(true);
					}
				}
			}else{
				btnEditwin.setDisabled(true);
				btnDel.setDisabled(true);
				btnRelevanceCareProv.setDisabled(true);
				btnCTLocLinkLocation.setDisabled(true);
				btnPacBed.setDisabled(true);
				btnCTLocSimilarDepartment.setDisabled(true);
				btnLocClassify.setDisabled(true);
				btnCTLocGroupStock.setDisabled(true);
			}
		});

	 /**---------------------右键菜单-------------------**/

			tree.addListener('contextmenu', rightClickFn);//右键菜单代码关键部分
			var nodemenu = new Ext.menu.Menu({
    		id:'nodemenu', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('nodemenu'),
    		items: [
    		{
	            iconCls :'icon-add',
	            handler: AddData,
	            id:'menuAddData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
	            text: '添加'
	        },{
	            iconCls :'icon-Update',
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
	            iconCls :'icon-refresh',
	            handler: Refresh,
	             id:'menu',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuRefresh'),
	            text: '刷新'
	        },{
	            iconCls :'icon-careprov',
	            handler: RelevanceCareProv,
	             id:'menucareprov',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menucareprov'),
	            text: '关联医护人员'
	        },
	        	{
	            iconCls :'icon-LinkLoc',
	            handler: CTLocLinkLocationWinEdit,
	             id:'menuCTLocLinkLocation',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuCTLocLinkLocation'),
	            text: '关联科室'
	        },{
	            iconCls :'icon-bed',
	            handler: PacBedWinEdit,
	             id:'menuPacBed',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuPacBed'),
	            text: '病区床位'
	        /*},{
	            iconCls :'icon-wardroom',
	            handler: PACWardRoomWinEdit,
	             id:'menuPACWardRoom',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuPACWardRoom'),
	            text: '房间分配'*/
	        },{
	            iconCls :'icon-similar',
	            handler: CTLocSimilarDepartmentWinEdit,
	            id:'menuCTLocSimilarDepartment',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuCTLocSimilarDepartment'),
	            text: '相似部门'
	        },{
	            iconCls :'icon-AdmType',
	            handler: LocClassifyWinEdit,
	             id:'menuLocClassify',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuLocClassify'),
	            text: '科室分类'

	        },{
	            iconCls :'icon-DP',
	            handler: CTLocGroupStockWinEdit,
	             id:'menuCTLocGroupStock',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuCTLocGroupStock'),
	            text: '库存授权'
	        }]
		});

 	function rightClickFn(node,e){
 		if (node.attributes.leaf) {
 			btnEditwin.setDisabled(false);
			btnDel.setDisabled(false);
			btnRelevanceCareProv.setDisabled(false);
			btnCTLocLinkLocation.setDisabled(false);
			btnLocClassify.setDisabled(false);
			btnCTLocGroupStock.setDisabled(false);
			Ext.getCmp("menuUpdateData").setDisabled(false);
			Ext.getCmp("menuDelData").setDisabled(false);
			Ext.getCmp("menucareprov").setDisabled(false);
			Ext.getCmp("menuCTLocLinkLocation").setDisabled(false);
			Ext.getCmp("menuLocClassify").setDisabled(false);
			Ext.getCmp("menuCTLocGroupStock").setDisabled(false);
	     if(node.attributes.CTLOCType!="W")//右键菜单灰化
		 {
		 		if((node.attributes.CTLOCType!="EM")&(node.attributes.CTLOCType!="OP"))
				{
					if(!Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'))
					{
						btnPacBed.setDisabled(true);
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('menuPacBed'))
					{
						Ext.getCmp('menuPacBed').disable();
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'))
					{
						btnCTLocSimilarDepartment.setDisabled(false);
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('menuCTLocSimilarDepartment'))
					{
						Ext.getCmp('menuCTLocSimilarDepartment').enable();
					}
				}
				else
				{
					if(!Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'))
					{
						btnPacBed.setDisabled(false);
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('menuPacBed'))
					{
						Ext.getCmp('menuPacBed').enable();
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'))
					{
						btnCTLocSimilarDepartment.setDisabled(false);
					}
					if(!Ext.BDP.FunLib.Component.DisableFlag('menuCTLocSimilarDepartment'))
					{
						Ext.getCmp('menuCTLocSimilarDepartment').enable();
					}
				}
		 }
		 else{
			 	if(!Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'))
				{
					btnPacBed.setDisabled(false);
				}
				if(!Ext.BDP.FunLib.Component.DisableFlag('btnCTLocSimilarDepartment'))
				{
					btnCTLocSimilarDepartment.setDisabled(true);
				}
				if(!Ext.BDP.FunLib.Component.DisableFlag('menuPacBed'))
				{
					Ext.getCmp('menuPacBed').enable();
				}
				if(!Ext.BDP.FunLib.Component.DisableFlag('menuCTLocSimilarDepartment'))
				{
					Ext.getCmp('menuCTLocSimilarDepartment').disable();
				}
	     	}
        }else{
			btnEditwin.setDisabled(true);
			btnDel.setDisabled(true);
			btnRelevanceCareProv.setDisabled(true);
			btnCTLocLinkLocation.setDisabled(true);
			btnPacBed.setDisabled(true);
			btnCTLocSimilarDepartment.setDisabled(true);
			btnLocClassify.setDisabled(true);
			btnCTLocGroupStock.setDisabled(true);
			Ext.getCmp("menuUpdateData").setDisabled(true);
			Ext.getCmp("menuDelData").setDisabled(true);
			Ext.getCmp("menucareprov").setDisabled(true);
			Ext.getCmp("menuCTLocLinkLocation").setDisabled(true);
			Ext.getCmp("menuPacBed").setDisabled(true);
			Ext.getCmp("menuCTLocSimilarDepartment").setDisabled(true);
			Ext.getCmp("menuLocClassify").setDisabled(true);
			Ext.getCmp("menuCTLocGroupStock").setDisabled(true);
		}
        nodemenu.showAt(e.getXY());//menu的showAt，不要忘记
		tree.getSelectionModel().select(node);
    }

    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);

	/**---------------------右键菜单-------------------**/

    var viewport = new Ext.Viewport({
        layout: 'border',
        defaults:{split:true},
        items: [searchPanel,treePanel]
    });
	Ext.fly('btnCTLOCType').addClass('x-btn-click');
});
