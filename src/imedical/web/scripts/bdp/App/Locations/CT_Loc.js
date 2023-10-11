/// 名称: 科室/病区维护	
/// 描述: 科室/病区维护，包含增删改查功能，整合附属功能
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2012-10-26

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePagePanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
	
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
	var CTLocLinkSpNurJS = '../scripts/bdp/App/Locations/CT_LocLinkSpNur.js';//专项护理部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+RBResource+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocLinkLocationJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+PACBedJS+'"></scr' + 'ipt>');
	//document.write('<scr' + 'ipt type="text/javascript" src="'+PACWardRoomJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocSimilarDepartmentJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CT_Loc_ClassifyJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocGroupStockJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocLinkSpNurJS+'"></scr' + 'ipt>');
	
	var CTLocDepHeadUserJS = '../scripts/bdp/App/Locations/CT_LocDepHeadUser.js';//其他科主任部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+CTLocDepHeadUserJS+'"></scr' + 'ipt>');
	

	//预住院病区 引用框架文件。
	var BDPItemJS1 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.ux.Multiselect.js';		
	var BDPItemJS2 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/DDView.js';  		
	var BDPItemJS3 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.form.MultiSelect.js';  		
	var BDPItemCSS = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Multiselect.css';
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS1+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS2+'"></scr' + 'ipt>');
    document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS3+'"></scr' + 'ipt>');
    document.write('<link rel="stylesheet"' + 'ipt type="text/css" href="'+BDPItemCSS+'"></scr' + 'ipt>');
/**----------------------------------掉用外部JS--------------------------------------**/		
	
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
	/*
	var fstyle1="",fstyle2="",fstyle3="",fstyle4="";
	if(!Sys.ie)  //ie11 ,chorme
	{ 
		//if ("ActiveXObject" in window)  ///ie11
		if((navigator.userAgent.indexOf('Trident')>-1)&&(navigator.userAgent.indexOf("rv:11.0")>-1))
		{
			fstyle1="margin-top: -10px;";
			fstyle2="margin-top: 0;";
			fstyle3="margin-top: -4px;";
			fstyle4="margin-top: -16px;";
		}
		else  //chrome  火狐
		{
			fstyle1="margin-top: -18px;margin-left:-7px;";
			fstyle2="margin-top:-10px;margin-left:-7px;";
			fstyle3="margin-top: -5px;margin-left:-7px;";
			fstyle4="margin-top: -26px;margin-left:-7px;";
		}
	}
	else ///ie10,9,8,7,6
	{
		fstyle1="margin-top: 0;";
		fstyle2="margin-top: 0;";
		fstyle3="margin-top: 0;";
		fstyle4="margin-top: 0;";
		if(navigator.userAgent.indexOf("MSIE")>0){
      		if(navigator.userAgent.indexOf("MSIE 8.0")>0 && !window.innerWidth){
      			//fstyle1="margin-top: -13px;";
				//fstyle2="margin-top: -10px;";
				//fstyle3="margin-top: -7px;";
      			fstyle1="margin-top: 0px;";
				fstyle2="margin-top: 0px;";
				fstyle3="margin-top: 0px;";
				fstyle4="margin-top: 0px;";
      		}    
    	}	
	}
	function removeClass(){
		Ext.fly('btnCTLOCType').removeClass('x-btn-click');
		Ext.fly('btnCTLOCDepDR').removeClass('x-btn-click');
		//Ext.fly('btnCTLOCHospitalDR').removeClass('x-btn-click');
		//Ext.fly('btnCTLOCCategoryDR').removeClass('x-btn-click');	//update2020-1-2 增加科室多层分类 钟荣枫
	}
	function loadTree(){
		//CatTreeLoader.dataUrl = CatTree_QUERY_ACTION_URL ;  
        //CatTreeLoader.baseParams = {LastLevel:"TreeRoot"};
        //CatTreeLoader.baseParams.Type = type;
        //CatPanel.root.reload();
		Ext.getCmp('TreeSearchText').setValue('');
		CatPanel.loadTree(type,hospComp.getValue());
        hiddenPkgs = [],selectNode="",HiddenCat=""
	}
	var height1=document.documentElement.clientHeight
	var height2=document.body.clientHeight
	var windowheight=(height1>height2)? (height1-67):(height2-67)
	var TypePanel = new Ext.Panel({
		items : [{ 
			xtype: 'buttongroup',
	        columns: 1,
	        items: [{
	        	text:'<div style="'+fstyle1+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">科室类型</div>',
	            id:'btnCTLOCType',
	            width:30,
	            height:windowheight/2,//100,
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
	            height:windowheight/2,//100,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLOCDepDR'),
	            listeners:{
	            	'click':function(){
	            		removeClass();
	            		Ext.fly('btnCTLOCDepDR').addClass('x-btn-click');
	            		type="CTLOCDepDR";
	            		 loadTree();
	            	}
	            }
	        }*//*,{					
	        	text:'<div style="'+fstyle3+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">医院</div>',
	            id:'btnCTLOCHospitalDR',
	            width:30,
	            height:windowheight/4,//100,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLOCHospitalDR'),
	            listeners:{
	            	'click':function(){
	            		removeClass();
	            		Ext.fly('btnCTLOCHospitalDR').addClass('x-btn-click');
	            		type="CTLOCHospitalDR";
	            		 loadTree();
	            		
	            	
	            	}
	            }
	        },{							//update2020-1-2 增加科室多层分类 钟荣枫
	        	text:'<div style="'+fstyle4+'writing-mode : tb-rl;  -ms-writing-mode: tb-rl  ;-webkit-writing-mode: vertical-lr;">科室多层分类</div>',
	            id:'btnCTLOCCategoryDR',
	            width:30,
	            height:windowheight/3,//100,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLOCCategoryDR'),
	            listeners:{
	            	'click':function(){
	            		removeClass();
	            		Ext.fly('btnCTLOCCategoryDR').addClass('x-btn-click');
	            		type="CTLOCCategoryDR";
	            		 loadTree();
	            	}
	            }
	        }*/
			/*]

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
			width:125,
			enableKeyEvents: true,
			listeners:{
				keyup:function(node, event) {

					if(event.getKey()==13){
						if(type=="CTLOCCategoryDR"){
							findByKeyWordFiler(node, event);
						}else{
							CatPanel.doQuery();
						}
					}
					if(event.getKey()==27){
						Ext.getCmp('TreeSearchText').setValue('');
						CatPanel.doQuery();
						HiddenCat="";
						Refresh();
					}
				},
				scope: this
			}
		}), '-', new Ext.Button({
			iconCls : 'icon-search',
			tooltip : '检索',
			id : 'btnRetrieve',
			handler : function(){
				if(type=="CTLOCCategoryDR"){
					findByKeyWordFiler("","");
				}else{
					CatPanel.doQuery();
				}

				//CatPanel.doQuery();
				HiddenCat="";
				Refresh();
			},
			scope : this
		}),'-',  {
			iconCls:'icon-refresh',
			tooltip : '查询所有科室',
			id : 'btnReset',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnReset'),
			handler:function(){
				Ext.getCmp('TreeSearchText').setValue('');
				if(type=="CTLOCCategoryDR"){
					loadTree();
					findByKeyWordFiler("","");
				}else{
					CatPanel.doQuery();
				}

				//CatPanel.doQuery();
				HiddenCat="";
				Refresh();
			} 
		}
		],
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
   					category:HiddenCat,
					hospid:hospComp.getValue()
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
	});	
	//var pinyins=Pinyin.GetJPU(n.text).toUpperCase()
	//var repinyins=Pinyin.GetJPU(re).toUpperCase()

	Ext.Ajax.timeout = 36000000;
	var timeOutId = null;
	var treeFilter = new Ext.tree.TreeFilter(CatPanel, {
		clearBlank : true,
		autoClear : true
	});
	// 保存上次隐藏的空节点
	var hiddenPkgs = [];

	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		CatPanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值			

			var text=Ext.getCmp('TreeSearchText').getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
				//n.select()
			});

			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					return !n.isLeaf() || re.test(n.text);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				CatPanel.root.cascade(function(n) {
					if(n.id!='0'){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				return;
			}
		}, 500);
	}
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			if(n1.isLeaf()){
				if (re.test(n1.text)){ str=true;return; }
			} else {
				if(re.test(n1.text)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		CatPanel.root.cascade(function(n) {
			if(n.id!='0'){
				n.ui.show();
			}
						
			if (n.id== selectNode) { 
				n.unselect();  ///取消树节点选中状态
			}
		});
	}

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
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLoc";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassMethod=DeleteData";
	var DEPDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCDepartmentGroup&pClassQuery=GetDataForCmb1";
	var HOSP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	//取科主任 用户表
	var BindingSSUser= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassQuery=GetDataForCmb1";
	var BindingBroadPatient= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBroadPatientGroup&pClassQuery=GetDataForCmb1";
	var SEX_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	
	var CTLOCCATECMB_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPCTLOCCategory&pClassMethod=GetJsonDataForCmb";
	//组织部门
	var BindingDepatment= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSDepartment&pClassQuery=GetDataForCmb1";
	//业务域
	var BindingHOSBusiDomain= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSBusiDomain&pClassQuery=GetDataForCmb1";

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
	//多院区医院下拉框
	//var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数
	hospComp.on('select',function (){
		 grid.enable();
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			type : Ext.getCmp("comboCTLOCType").getValue(),
			dep : Ext.getCmp("comboCTLOCDepDR").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					},
					callback : function(records, options, success) {
						//loadTree();	 ///grid加载完 加载左侧分类树 2020-05-15
					}
				});
		
	});
	
    //删除功能
    var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗？', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中，请稍候．．．', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						AliasGrid.DataRefer = rows[0].get('CTLOCRowID');
						AliasGrid.delallAlias();
				
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTLOCRowID')
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
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
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
        var classMethod = "FormValidate"; //数据重复验证后台函数名
        var id="";
        if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
        	var _record = grid.getSelectionModel().getSelected();
        	var id = _record.get('CTLOCRowID'); //此条数据的rowid
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
        var classMethod = "FormValidate"; //数据重复验证后台函数名
        var id="";
        if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
        	var _record = grid.getSelectionModel().getSelected();
        	var id = _record.get('CTLOCRowID'); //此条数据的rowid
        }
        var flag = "";
        var hosp=hospComp.getValue();	//Ext.getCmp("CTLOCHospitalDRF").getValue();
        var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hosp);//用tkMakeServerCall函数实现与后台同步调用交互
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
        		//失焦自动填写拼音码和五笔码
        		var Desc=Ext.getCmp("CTLOCDescF").getValue()
        		if (Desc!="")
        		{
        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
					var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1)
			        Ext.getCmp("CTLOCPYCodeF").setValue(PYCode)
			        Ext.getCmp("CTLOCWBCodeF").setValue(WBCode)
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
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCAddressF')
	});
	
	/*
	var CTLOCFloor = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '楼层',
		name : 'CTLOCFloor',
		id:'CTLOCFloorF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCFloorF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCFloorF'),
		//disabled : Ext.BDP.Funmib.Component.DisableFlag('CTLOCFloorF')
	});
	*/
	
	var Floor_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocBuildingFloor&pClassQuery=GetDataForCmb1";
	var CTLOCFloor = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '楼层',
		name : 'CTLOCFloor',
		id:'CTLOCFloorF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCFloorF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCFloorF'),
		store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : Floor_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'CTLBFRowId', 'CTLBFFloor' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'CTLBFRowId',
		displayField : 'CTLBFFloor',
		hiddenName : 'CTLOCFloor',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		listeners:{
		   'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:hospComp.getValue()
				};
				this.store.load({params : {
							start : 0,
							limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			}
		}
	});
	
	var CTLOCWardSingleSex = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '性别',
		name : 'CTLOCWardSingleSex',
		//id:'CTLOCWardSingleSex',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCWardSingleSexF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCWardSingleSexF'),
		store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : SEX_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'CTSEXRowId', 'CTSEXDesc' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
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
		fieldLabel : '<font color=red>*</font>部门组',
		allowBlank : false,
		name : 'CTLOCDepDR',
		id:'CTLOCDepDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : DEPDR_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'DEPRowId', 'DEPDesc' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'DEPRowId',
		displayField : 'DEPDesc',
		hiddenName : 'CTLOCDepDR',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		listeners:{
		   'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:hospComp.getValue()
				};
				this.store.load({params : {
							start : 0,
							limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			}
		}
	});
					
	var CTLOCDepartmentHeadUserDR = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '默认科主任',
		name : 'CTLOCDepartmentHeadUserDR',
		id:'CTLOCDepartmentHeadUserDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepartmentHeadUserDRF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepartmentHeadUserDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDepDRF'),
		store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : BindingSSUser }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'SSUSRRowId', 'SSUSRName' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'SSUSRRowId',
		displayField : 'SSUSRName',
		hiddenName : 'CTLOCDepartmentHeadUserDR',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		listeners:{
		   'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:hospComp.getValue()
				};
				this.store.load({params : {
							start : 0,
							limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			}
		}
	});
	//2020-1-2 钟荣枫 增加科室多层分类
	
	//********** 科室多层分类选择框 初始化treecombo *************//
	var CTLOCCategoryDRLoader = new Ext.tree.TreeLoader({
				nodeParameter: "id",
				dataUrl: CTLOCCATECMB_ACTION_URL
			});
	var CTLOCCategoryDR = new Ext.ux.TreeCombo({  
		 id : 'CTLOCCategoryDRF',
         width : 180,  
         fieldLabel:"科室多层分类",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCCategoryDRF'),
         hiddenName : 'CTLOCCategoryDR',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"菜单",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: CTLOCCategoryDRLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });
	
	var CTLOCHospitalDR = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '<font color=red>*</font>医院',
		name : 'CTLOCHospitalDR',
		allowBlank : false,
		id:'CTLOCHospitalDRF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCHospitalDRF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCHospitalDRF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCHospitalDRF'),
		store : new Ext.data.Store({
			autoLoad: true,
			baseParams:{communityid:communityid},
			proxy : new Ext.data.HttpProxy({ url : HOSP_QUERY_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'HOSPRowId', 'HOSPDesc' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
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

	var CTLOCAllowNoCureLimit = new Ext.form.Checkbox({
		//xtype : 'checkbox',
		boxLabel : '允许无收治限制',
		name : 'CTLOCAllowNoCureLimit',
		id:'CTLOCAllowNoCureLimitF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCAllowNoCureLimitF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCAllowNoCureLimitF'),
		inputValue : true?'Y':'N'
	});

	var CTLOCBeInHospital = new Ext.form.Checkbox({
		//xtype : 'checkbox',
		boxLabel : '是否住院总签床',
		name : 'CTLOCBeInHospital',
		id:'CTLOCBeInHospitalF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCBeInHospitalF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCBeInHospitalF'),
		inputValue : true?'Y':'N'
	});

	var CTLOCContactName = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '<font color=red>*</font>科室检索码',
		name : 'CTLOCContactName',
		id:'CTLOCContactNameF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCContactNameF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCContactNameF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCContactNameF')
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
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : BindingBroadPatient }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'BPGRowId', 'BPGDesc' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
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

	//---组织部门
	var CTLOCDeptCode = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '组织部门',
		name : 'CTLOCDeptCode',
		id:'CTLOCDeptCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDeptCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDeptCodeF'),
		store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : BindingDepatment }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'ID', 'DEPTDesc' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'ID',
		displayField : 'DEPTDesc',
		hiddenName : 'CTLOCDeptCode',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});

	//---业务域
	var CTLOCDomainCode = new Ext.BDP.Component.form.ComboBox({
		//xtype:'bdpcombo',
		loadByIdParam : 'rowid',
		fieldLabel : '业务域',
		name : 'CTLOCDomainCode',
		id:'CTLOCDomainCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDomainCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDomainCodeF'),
		store : new Ext.data.Store({
			autoLoad: true,
			proxy : new Ext.data.HttpProxy({ url : BindingHOSBusiDomain }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'ID', 'DomainDesc' ])
		}),
		queryParam : 'desc',
		//triggerAction : 'all',
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
		//minChars : 1,
		listWidth : 250,
		valueField : 'ID',
		displayField : 'DomainDesc',
		hiddenName : 'CTLOCDomainCode',
		pageSize : Ext.BDP.FunLib.PageSize.Combo
	});

	//---物理位置
	var CTLOCLocation = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '物理位置',
		name : 'CTLOCLocation',
		id:'CTLOCLocationF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCLocationF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCLocationF')
	});	

	//---排序号
	var CTLOCSeqNo= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '排序号',
		name : 'CTLOCSeqNo',
		id : 'CTLOCSeqNoF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCSeqNoF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCSeqNoF')),
		dataIndex : 'CTLOCSeqNo',
		allowDecimals: false, // 不允许小数点 
		allowNegative: false, // 不允许负数
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是非负整数'	
	});

	//---拼音码
	var CTLOCPYCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '拼音码',
		name : 'CTLOCPYCode',
		id:'CTLOCPYCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCPYCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCPYCodeF')
	});

	//---五笔码
	var CTLOCWBCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '五笔码',
		name : 'CTLOCWBCode',
		id:'CTLOCWBCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCWBCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCWBCodeF')
	});

	//---备注
	var CTLOCMark = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '备注',
		name : 'CTLOCMark',
		id:'CTLOCMarkF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCMarkF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCMarkF')
	});

	// 是否有效
	var CTLOCActiveFlag = new Ext.form.Checkbox({
		boxLabel : '是否有效',
		name : 'CTLOCActiveFlag',
		id:'CTLOCActiveFlagF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCActiveFlagF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCActiveFlagF'),
		inputValue : true?'Y':'N',
		checked : true
	});


	//---联系电话
	var CTLOCTelephone = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '联系电话',
		name : 'CTLOCTelephone',
		id:'CTLOCTelephoneF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCTelephoneF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCTelephoneF'),
		//disabled : Ext.BDP.Funmib.Component.DisableFlag('CTLOCTelephoneF')
	});		
	//---检验条码科室简称
	var CTLOCNationCode = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '科室简称',
		name : 'CTLOCNationCode',
		id:'CTLOCNationCodeF',
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCNationCodeF')),	
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCNationCodeF'),
		//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCNationCodeF')
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
           { name: 'CTLOCAllowNoCureLimit',mapping:'CTLOCAllowNoCureLimit', type: 'string' },
           { name: 'CTLOCBeInHospital',mapping:'CTLOCBeInHospital', type: 'string' },
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
           { name: 'WARDBeforehand', mapping:'WARDBeforehand',type: 'string'},
           { name: 'OutPatient', mapping:'OutPatient',type: 'string'},
           { name: 'InPatient', mapping:'InPatient',type: 'string'},
           { name: 'Emergency', mapping:'Emergency',type: 'string'},
           { name: 'HealthPromotion', mapping:'HealthPromotion',type: 'string'},
           { name: 'CTLOCDeptCode', mapping:'CTLOCDeptCode',type: 'string'},
           { name: 'CTLOCDomainCode', mapping:'CTLOCDomainCode',type: 'string'},
           { name: 'CTLOCLocation', mapping:'CTLOCLocation',type: 'string'},
           { name: 'CTLOCSeqNo', mapping:'CTLOCSeqNo',type: 'string'},
           { name: 'CTLOCPYCode', mapping:'CTLOCPYCode',type: 'string'},
           { name: 'CTLOCWBCode', mapping:'CTLOCWBCode',type: 'string'},
           { name: 'CTLOCMark', mapping:'CTLOCMark',type: 'string'},
           { name: 'CTLOCActiveFlag', mapping:'CTLOCActiveFlag',type: 'string'}
           
           //{ name: 'CTLOCCategoryDR', mapping:'CTLOCCategoryDR',type: 'string'}
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
				labelWidth : 115,
				labelPad : 1,
				border : false,
				defaults : {
					anchor : '93%',
					xtype : 'textfield'
				},
		        items : [
		        CTLOCCode,CTLOCAddress,CTLOCType,CTLOCHospitalDR,CTLOCWardSingleSex,CTLOCAgeFrom,CTLOCDateActiveFrom,CTLOCBroadPatientGroupDR,CTLOCTelephone,CTLOCNationCode,CTLOCSeqNo,CTLOCMark,CTLOCIndex,CTLOCExecuteConfirmation,CTLOCMedicalRecordActive,CTLOCAllowNoCureLimit,CTLOCBeInHospital,CTLOCActiveFlag,CTLOCRowID
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
		        CTLOCDesc,CTLOCFloor,CTLOCDepDR,CTLOCDepartmentHeadUserDR,CTLOCContactName,CTLOCAgeTo,CTLOCDateActiveTo,CTLOCDeptCode,CTLOCDomainCode,CTLOCLocation,CTLOCPYCode,CTLOCWBCode,
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
		            },{
		            	disabled : true,
						hidden : true,
		                boxLabel: '预住院病区',
		                name: 'WARDBeforehand',
		                id:'WARDBeforehandF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('WARDBeforehandF')),	
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('WARDBeforehandF'),
		                width: 'auto',
						inputValue : true?'Y':'N'
		            }]
		        },{
		            xtype :'fieldset',
		            title : '说明',
		            autoHeight : true,
		            style : 'margin-left:10px;',
		            bodyStyle : 'margin-left:10px;',
		            html : '"病区"仅对科室类型为"Ward、Emergency、Operating Theatre"时有效!'
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
		            	//disabled : true,
		            	boxLabel: '门诊',
		                name: 'OutPatient',
		                id:'OutPatientF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OutPatientF')),	
						//readOnly : Ext.BDP.FunLib.Component.DisableFlag('OutPatientF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('OutPatientF'),
		                width: 'auto',
						inputValue : 'Y',
						listeners:{
							'check':function(){
								/*if(Ext.getCmp("OutPatientF").getValue()){
										Ext.getCmp("EmergencyF").setValue(false);
										Ext.getCmp("InPatientF").setValue(false);
										Ext.getCmp("HealthPromotionF").setValue(false);
									}*/
							}
						}
		                
		            },{
		            	//disabled : true,
		            	boxLabel: '急诊',
		                name: 'Emergency',
		                id:'EmergencyF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EmergencyF')),	
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('EmergencyF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('EmergencyF'),
		                width: 'auto',
						inputValue : true?'Y':'N',
						listeners:{
							'check':function(){
								/*if(Ext.getCmp("EmergencyF").getValue()){
										Ext.getCmp("OutPatientF").setValue(false);
										Ext.getCmp("InPatientF").setValue(false);
										Ext.getCmp("HealthPromotionF").setValue(false);
									}*/
							}
						}
		            },{
		            	//disabled : true,
		                boxLabel: '住院',
		                name: 'InPatient',
		                id:'InPatientF',
		                //style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InPatientF')),	
						//readOnly : Ext.BDP.FunLib.Component.DisableFlag('InPatientF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('InPatientF'),
		                width: 'auto',
						inputValue : true?'Y':'N',
						listeners:{
							'check':function(){
								/*if(Ext.getCmp("InPatientF").getValue()){
										Ext.getCmp("OutPatientF").setValue(false);
										Ext.getCmp("EmergencyF").setValue(false);
										Ext.getCmp("HealthPromotionF").setValue(false);
									}*/
							}
						}
		            },{
		            	//disabled : true,
		                boxLabel: '体检',
		                name: 'HealthPromotion',
		                id:'HealthPromotionF',
		                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HealthPromotionF')),	
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('HealthPromotionF'),
   						//disabled : Ext.BDP.FunLib.Component.DisableFlag('HealthPromotionF'),
		                width: 'auto',
						inputValue : true?'Y':'N',
						listeners:{
							'check':function(){
								/*if(Ext.getCmp("HealthPromotionF").getValue()){
										Ext.getCmp("OutPatientF").setValue(false);
										Ext.getCmp("EmergencyF").setValue(false);
										Ext.getCmp("InPatientF").setValue(false);
									}*/
							}
						}
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
			Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(false);
		}else{
			Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
			Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(true);
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
	var height=Math.min(Ext.getBody().getViewSize().height-30,660)
	var win = new Ext.Window({
			title:'',
			width:1000,
        	height:height,
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
													grid.getStore().load({
														params : {
															start : 0,
															limit : 1,
															rowid : myrowid
														}
													});
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
													Ext.BDP.FunLib.ReturnDataForUpdate("grid",QUERY_ACTION_URL,myrowid);
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
					Ext.getCmp("CTLOCTypeF").reset();	//20200423 lkf
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
				Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(true);

				//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
				//20200520	likefan
				Ext.getCmp("CTLOCHospitalDRF").setValue(hospComp.getValue());
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
        	var _record = grid.getSelectionModel().getSelected();
	        if(_record){
					win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					//Ext.getCmp("form-save").getForm().reset();
					if(_record.get('CTLOCType')=="W" || _record.get('CTLOCType')=='EM' || _record.get('CTLOCType')=='OP'){
						Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(false);
						Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(false);
					}else{
						Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
						Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(true);
					}
					
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + grid.getSelectionModel().getSelected().get('CTLOCRowID'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                	Ext.getCmp("CTLOCClinicTypeF").reset();
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

							//Ext.getCmp("CTLOCCategoryDRF").reset();
							//var CategoryDRF=action.result.data.CTLOCCategoryDR;//获取科室多层分类
							//Ext.getCmp("CTLOCCategoryDRF").setValue(CategoryDRF);
							//Ext.getCmp("CTLOCCategoryDRF").setRawValue(_record.get('CTLOCCategoryDR'));;
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });

		             //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('CTLOCRowID');
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
    
    var depgroupurl="dhc.bdp.ext.default.csp?extfilename=App/Locations/RBC_DepartmentGroup"
    if ('undefined'!==typeof websys_getMWToken){
		depgroupurl += "&MWToken="+websys_getMWToken()
	} 
	///*科室部门组维护*//
	var RBCDepartmentGroupWin = new Ext.Window({
		title:'',
		width:850,
        height:550,
		layout:'fit',
		closeAction:'hide',
		html:'<iframe src="'+depgroupurl+'" width="100%" height="100%"></iframe>'
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
        if(grid.selModel.hasSelection()){       
        	
        	var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            
            var id = rows[0].get('CTLOCRowID');
            var flag = rows[0].get('CTLOCType');

	        RBCareProvStore.baseParams={type:flag}
            RBCareProvStore.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Combo}});
            
			winRelevanceCareProv.setTitle('关联医护人员');
		    winRelevanceCareProv.setIconClass('icon-careprov');
		    winRelevanceCareProv.show('');
		    var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            var CTLOCRowID=rows[0].get('CTLOCRowID');
            
            //var RESCode=rows[0].get('CTPCPCode');
            gridResource.getStore().baseParams={LOCDR:CTLOCRowID};
            gridResource.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
            
            var RESCTPCPDR=rows[0].get('CTPCPRowId1');
            var RESDesc=rows[0].get('CTPCPDesc');
            Ext.getCmp("hidden_CTLOCRowID").reset();
            Ext.getCmp("hidden_CTLOCRowID").setValue(CTLOCRowID);
        	Ext.getCmp("hidden_RESHOSPDR").reset();
            Ext.getCmp("hidden_RESHOSPDR").setValue(hospComp.getValue());
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
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winCTLocLinkLocation.setTitle('关联科室');
			winCTLocLinkLocation.setIconClass('icon-LinkLoc');
			winCTLocLinkLocation.show('');
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 Hidden_LocLink_CTLocID
            var CTLOCRowID=rows[0].get('CTLOCRowID');
            Ext.getCmp("Hidden_LocLink_CTLocID").reset();
           	Ext.getCmp("Hidden_LocLink_CTLocID").setValue(CTLOCRowID);
			Ext.getCmp("hidden_LocLink_HOSPDR").reset();
            Ext.getCmp("hidden_LocLink_HOSPDR").setValue(hospComp.getValue());
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
	
	/*************************科室扩展信息维护*************************/
	var winExtend; 	//必须先定义弹窗，否则无法在弹窗界面实现隐藏方法HideParentWin
	var btnCTLocExtend = new Ext.Toolbar.Button({
        text: '科室扩展信息',
        tooltip: '科室扩展信息',
        iconCls: 'icon-DP',
        id:'btnCTLocExtend',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocExtend'),
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
			    var itemRowId=rows[0].get('CTLOCRowID')
			    var itemdesc=rows[0].get('CTLOCDesc')
            	var link="dhc.bdp.ext.default.csp?extfilename=App/Locations/CT_LocExtend&selectrow="+itemRowId; 
            	if ('undefined'!==typeof websys_getMWToken){
					link += "&MWToken="+websys_getMWToken()
				}
				winExtend = new Ext.Window({
					id:'winExtend',
					iconCls : 'icon-DP',
					width : 700,
					height : 400,
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
				winExtend.setTitle(itemdesc+"-科室扩展信息");
				winExtend.show();
			}
      	}
    });	
	//实现新窗口关闭
	HideParentWin=function(){
        winExtend.close();
    }
	
	var winPacBed = new Ext.Window(getPacBedPanel());  //调用病区床位弹出框
	
	var btnPacBed = new Ext.Toolbar.Button({				//病区床位
	    text: '病区床位',
	    id:'btnPacBed',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPacBed'),
        iconCls: 'icon-bed',
		tooltip: '病区床位--科室类型为Ward或Emergency时激活',
        handler: PacBedWinEdit = function () {
        var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winPacBed.setIconClass('icon-bed');
			winPacBed.show();	
			var gsm = grid.getSelectionModel();//获取选择列
      		var rows = gsm.getSelections();//根据选择列获取到所有的行
       		var CTLOCRowID=rows[0].get('CTLOCRowID');
       		var CTLOCDesc=rows[0].get('CTLOCDesc');
       		winPacBed.setTitle('病区床位--'+CTLOCDesc);
       		Ext.getCmp("CTLOCDesc_HIDDEN").reset();
			Ext.getCmp("CTLOCDesc_HIDDEN").setValue(CTLOCDesc);
       		Ext.getCmp("CTLOCRowID_HIDDEN").reset();
           	Ext.getCmp("CTLOCRowID_HIDDEN").setValue(CTLOCRowID);
       		var WARDParRef = tkMakeServerCall("web.DHCBL.CT.PACBed","GetWARDParRef",CTLOCRowID);
       		Ext.getCmp("hidden_ref").reset();
           	Ext.getCmp("hidden_ref").setValue(WARDParRef);
			Ext.getCmp("hidden_PACBedHOSPDR").reset();
            Ext.getCmp("hidden_PACBedHOSPDR").setValue(hospComp.getValue());
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
	        var _record = grid.getSelectionModel().getSelected();
	        if(_record){
				winCTLocSimilarDepartment.setIconClass('icon-similar');
				winCTLocSimilarDepartment.show('');	
				var gsm = grid.getSelectionModel();//获取选择列
	        	var rows = gsm.getSelections();//根据选择列获取到所有的行
	           	var CTLOCRowID=rows[0].get('CTLOCRowID');
	           	var CTLOCDesc=rows[0].get('CTLOCDesc');        		
		   		winCTLocSimilarDepartment.setTitle('相似部门--'+CTLOCDesc);
		   		Ext.getCmp("TextCode2").reset();
		   		Ext.getCmp("CTLocSimilarDepartment_CTLocID").reset();
		       	Ext.getCmp("CTLocSimilarDepartment_CTLocID").setValue(CTLOCRowID);
				Ext.getCmp("hidden_SimilarDepHOSPDR").reset();
				Ext.getCmp("hidden_SimilarDepHOSPDR").setValue(hospComp.getValue());
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
        var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winLocClassify.setIconClass('icon-AdmType');
			winLocClassify.show('');			
			var gsm = grid.getSelectionModel();//获取选择列
        	var rows = gsm.getSelections();//根据选择列获取到所有的行
        	var CTLOCRowID=rows[0].get('CTLOCRowID');
           	var CTLOCDesc=rows[0].get('CTLOCDesc');  
           	winLocClassify.setTitle('科室分类-'+CTLOCDesc);
			
	   		Ext.getCmp("hidden_LocRef").reset();
	       	Ext.getCmp("hidden_LocRef").setValue(CTLOCRowID);
	       	LocClassifyds.baseParams={CTLOCRowID:CTLOCRowID,hospid:hospComp.getValue()}
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
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 Hidden_GroupStock_CTLocID
            var CTLOCRowID=rows[0].get('CTLOCRowID');
            Ext.getCmp("Hidden_GroupStock_CTLocID").reset();
           	Ext.getCmp("Hidden_GroupStock_CTLocID").setValue(CTLOCRowID);
           	menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL+ '&LocId='+Ext.getCmp("Hidden_GroupStock_CTLocID").getValue()+ '&hospid='+hospComp.getValue();
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
	///预住院病区 允许收治病区
	var ABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkWard&pClassMethod=GetData";
	var DISABLE_ITEM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkWard&pClassMethod=GetAllData";
	var ITEM_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkWard&pClassMethod=SaveAll";

	var ds1 = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : ABLE_ITEM_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name :'Name',
									mapping :'Name',
									type : 'string'
								}
						])
			});
	var ds2 = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : DISABLE_ITEM_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'ID',
							mapping : 'ID',
							type : 'string'
						}, {
							name :'Name',
							mapping :'Name',
							type : 'string'
						}
				])
	});
	var clickevent= function(id){
			Ext.getCmp("_multiselect3").toStore.load({params: {ParRef:id}});	
			Ext.getCmp("_multiselect3").fromStore.load({params: {ParRef:id,hospid:hospComp.getValue()}});	
	}
	var CurePanel = new Ext.Panel({
		//title : '允许收治病区',
		//width : 500,
		//height: 600,
		region:'center',
		frame:true,
		//bodyStyle : 'padding: 1px;',
		items : [{
			xtype : "itemselector",
			id    : "_multiselect3",
			fieldLabel : "ItemSelector",
			dataFields : ["ID", "Name"],
			fromStore   : ds2,
			toStore     : ds1,
			toSortField : true,
			msWidth    : 250,
			msHeight   : 480,
			valueField   : "ID",
			displayField : "Name",
			toLegend     : "允许收治病区",
			fromLegend   : "不允许收治病区"
		}],
		tbar : [{ 	text:'保存',
					icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
					handler:function() {
						str="";
						var rows = grid.getSelectionModel().getSelections();//获取选择列
						var CTLOCRowID=rows[0].get('CTLOCRowID');
						function f(record){
							var WARDRowID = record.get("ID");
							if(WARDRowID) {
								str=str+CTLOCRowID+"^"+WARDRowID+"#"
							}

						}
						ds1.each(f);
						if(str==""){
							str=CTLOCRowID+"^#"
						}
						Ext.Ajax.request({
							url:ITEM_SAVE_ACTION_URL,
							params: {str:str},
							success: function(resp,option){
								var rtn = resp.responseText.replace(/\r\n/g,"");
								try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
								if (obj.success == "true") {
									Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										minWidth : 150,
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK
									});
									CureWin.hide();
								}else {
									Ext.Msg.show({
										title : '提示',
										msg : obj.erroinfo,
										minWidth : 150,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
							},
							failure: function(response, opts) {
										console.log('server-side failure with status code ' + response.status);
									},
							scope : this
						});
					}
				},'-',{
					text:"清空允许收治病区",
					icon:Ext.BDP.FunLib.Path.URL_Icon+'bckdelete.gif',
					handler:function(){
						var i = Ext.getCmp("_multiselect3");
						i.reset.call(i);
					}
				}]
	});
	var CureWin = new Ext.Window({
		width:600,
		title: '允许收治病区',
		iconCls: 'icon-LinkLoc',
	    height:560,
	    layout:'fit',
	    frame :true,
		closeAction:'hide',
		items:[CurePanel],
		listeners : {
			"hide" : function() {
			}	
		}
	});
	var btnCure = new Ext.Toolbar.Button({	 //允许收治病区
	    text: '允许收治病区',
	    id:'btnCure',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCure'),
	    iconCls: 'icon-LinkLoc',
		tooltip: '允许收治病区',
	    handler: function () {
	    	var _record = grid.getSelectionModel().getSelected();
	        if(_record){
				var gsm = grid.getSelectionModel();//获取选择列
	            var rows = gsm.getSelections();//根据选择列获取到所有的行 Hidden_GroupStock_CTLocID
	            var CTLOCRowID=rows[0].get('CTLOCRowID');
	            CureWin.show();
				clickevent(CTLOCRowID)
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
    var ObjectType="G";
    var ObjectReference="1";
	if ('undefined'!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken()
	}
	var btnLocAut = new Ext.Toolbar.Button({	 //相似部门
	    text: '科室接收消息权限配置',
	    id:'btnLocAut',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLocAut'),
	    iconCls: 'icon-NewsA',
		tooltip: '科室接收消息权限配置',
	        handler: CTLocAut = function () {
				var LocAutWin = new Ext.Window({
					width:600,
					title: '科室接收消息权限配置',
					iconCls: 'icon-NewsA',
					height:530,
					layout:'fit',
					frame :true,
					closeAction:'close',
					html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"&SingleHospId="+hospComp.getValue()+"'></iframe>", 
					listeners : {
						"hide" : function() {
							grid.getStore().load({
								params : {
								start : 0,
								limit : pagesize
								}
							});
						}	
					}
				});
	        	LocAutWin.show();
	
	        }
	});
	var fields= [{ name: 'CTLOCRowID', mapping:'CTLOCRowID',type: 'string'},
           { name: 'CTLOCCode', mapping:'CTLOCCode',type: 'string'},
           { name: 'CTLOCDesc',mapping:'CTLOCDesc', type: 'string' },
           { name: 'CTLOCAddress', mapping:'CTLOCAddress',type: 'string'},
           { name: 'CTLOCType',mapping:'CTLOCType', type: 'string' },
           //{ name: 'CTLOCCategoryDR',mapping:'CTLOCCategoryDR', type: 'string' },
           { name: 'DEPDesc', mapping:'DEPDesc',type: 'string'},
           { name: 'CTLOCIndex',mapping:'CTLOCIndex', type: 'string' },
           { name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'},
           { name: 'CTLOCMedicalRecordActive',mapping:'CTLOCMedicalRecordActive', type: 'string' },
           { name: 'CTLOCExecuteConfirmation',mapping:'CTLOCExecuteConfirmation', type: 'string' },
           { name: 'CTLOCDateActiveFrom', mapping:'CTLOCDateActiveFrom',type: 'date'},
           { name: 'CTLOCDateActiveTo',mapping:'CTLOCDateActiveTo',type: 'date'},
	   { name: 'CTLOCContactName', mapping:'CTLOCContactName', type: 'string'},	   
           { name: 'CTLOCDeptCode', mapping:'CTLOCDeptCode', type: 'string'},	   
           { name: 'CTLOCDomainCode', mapping:'CTLOCDomainCode', type: 'string'},	   
           { name: 'CTLOCLocation', mapping:'CTLOCLocation', type: 'string'},	   
           { name: 'CTLOCActiveFlag', mapping:'CTLOCActiveFlag', type: 'string'},	   
           { name: 'CTLOCSeqNo', mapping:'CTLOCSeqNo', type: 'string'},	   
           { name: 'CTLOCPYCode', mapping:'CTLOCPYCode', type: 'string'},	   
           { name: 'CTLOCWBCode', mapping:'CTLOCWBCode', type: 'string'},	   
           { name: 'CTLOCMark', mapping:'CTLOCMark', type: 'string'}	//列的映射
		];
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},fields )
    });	
    
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
    ds.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		     communityid:communityid
		  }   
		)
	});
	
	var paging= new Ext.PagingToolbar({
            pageSize: pagesize,
            store: ds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pagesize=this.pageSize;
			         }
	        }
        });		
    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
	
	
    var btnOrderLimit = new Ext.Toolbar.Button({               // 医嘱限制
        text: '医嘱限制',
        id:'btnOrderLimit',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnOrderLimit'),
        icon: Ext.BDP.FunLib.Path.URL_BdpIcon+'DHC_CTLoc_MedUnit.png',
        tooltip: '医嘱限制',
        handler: Med = function() {   
        var _record = grid.getSelectionModel().getSelected();
        if(_record){
			var winOrderLimit = new Ext.Window({
				width:700,
				height:500,
				title: '医嘱限制',
				iconCls: 'icon-NewsA', 
				layout:'fit',
				frame :true,
				closeAction:'hide', 
				//html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+ORDERLimitURL+"'></iframe>", 
				listeners : {
					"hide" : function() {
						grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize
								}
						});
					}	
				}
			}); 
            var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 
            var OrderLimtParRef= rows[0].get('CTLOCRowID');
			var ORDERLimitURL="dhc.bdp.ext.default.csp?extfilename=/App/Locations/CT_Loc_OrderLimit&OrderLimtParRef="+OrderLimtParRef;
			if ('undefined'!==typeof websys_getMWToken){
				ORDERLimitURL += "&MWToken="+websys_getMWToken()
			}
			var link=encodeURI(ORDERLimitURL) 
			winOrderLimit.html="<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+ORDERLimitURL+"'></iframe>";
			winOrderLimit.show(); 
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

/**********************************定义专项护理按钮********************************/	

	var winCTLocLinkSpNur = new Ext.Window(getCTLocLinkSpNurPanel());  //调用专项护理面板
	
	var btnCTLocLinkSpNur = new Ext.Toolbar.Button({				
	    text: '专项护理',
	    id:'btnCTLocLinkSpNur',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocLinkSpNur'),
        iconCls: 'icon-LinkLoc',
		tooltip: '专项护理',
		handler: CTLocLinkSpNurWinEdit = function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			//alert(_record.get('CTLOCRowID'));
			winCTLocLinkSpNur.setTitle('专项护理');
			winCTLocLinkSpNur.setIconClass('icon-LinkLoc');
			winCTLocLinkSpNur.show('');
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 
            var CTLOCRowID=rows[0].get('CTLOCRowID');
            Ext.getCmp("Hidden_SpNur_CTLocID").reset();
           	Ext.getCmp("Hidden_SpNur_CTLocID").setValue(CTLOCRowID);  //对调用的js中id为 Hidden_SpNur_CTLocID 的变量赋值
            gridCTLocLinkSpNur.getStore().baseParams={parref:CTLOCRowID};
           	gridCTLocLinkSpNur.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
           	Ext.getCmp("SpNurDR1").getStore().load();
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一个科室!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	
	/**********************************定义其他科主任按钮********************************/	
	var winCTLocDepHeadUser = new Ext.Window(getCTLocDepHeadUserPanel());
	var btnCTLocDepHeadUser = new Ext.Toolbar.Button({				
	    text: '其他科主任',
	    id:'btnCTLocDepHeadUser',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocDepHeadUser'),
        iconCls: 'icon-careprov',
		tooltip: '其他科主任',
		handler: CTLocDepHeadUserWinEdit = function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			winCTLocDepHeadUser.setTitle('其他科主任');
			winCTLocDepHeadUser.setIconClass('icon-careprov');
			winCTLocDepHeadUser.show('');
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 
            var CTLOCRowID=rows[0].get('CTLOCRowID');
            Ext.getCmp("Hidden_CTLocID").reset();
           	Ext.getCmp("Hidden_CTLocID").setValue(CTLOCRowID);  //对调用的js中id为 Hidden_CTLocID 的变量赋值
            gridCTLocDepHeadUser.getStore().baseParams={parref:CTLOCRowID};
           	gridCTLocDepHeadUser.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
           	Ext.getCmp("CTDHUDepHeadUserDRF").getStore().load();
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择一个科室!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});

    // 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, 
		'-', btnDel,
		//'-',btnRBCDepartmentGroup,
		'-',btnRelevanceCareProv,
		'-',btnCTLocLinkLocation,'-',btnCTLocExtend,'-',btnPacBed,'-', btnCTLocDepHeadUser, '-', // btnPACWardRoom,'-', '-',btnOrderLimit,
		btnCTLocSimilarDepartment,'-',btnLocClassify, '-' ,btnCTLocGroupStock,'-',btnCure,'->',
		{	text: '更多功能',
			   	icon:Ext.BDP.FunLib.Path.URL_Icon +'list-items.gif',
			   	menu: new Ext.menu.Menu({
			        items: [
			        	/*{text: '切换为树形展示',id : 'btnSwitch',iconCls:'icon-refresh',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSwitch'),handler:function(){
				        	//var userId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.Locations.CTLocTree",""); //科室目录树菜单id
							//window.location.href="dhc.bdp.ext.sys.csp?BDPMENU="+userId;  
			        		window.location.href="dhc.bdp.ext.default.csp?extfilename=App/Locations/CT_LocTree.js"; 
				        }},'-',*/
				        {text: '查看数据日志',id:'btnlog',iconCls:'icon-DP',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnlog'),handler:function(){
							var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
			         		var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPDataChangeLogForPages&UserClass="+logmenu;
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
			         	}},'-',
			         	{text: '查看数据生命周期',id:'btnhislog',icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',disabled : Ext.BDP.FunLib.Component.DisableFlag('btnhislog'),handler:function(){
			         	   var RowID="",Desc="";
						   if (grid.selModel.hasSelection()) {
						       var rows = grid.getSelectionModel().getSelections(); 
						       RowID=rows[0].get('CTLOCRowID');
						       Desc=rows[0].get('CTLOCDesc');
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
						            SortWin.html='<iframe id="iframsort" src=" '+link+' " width="100%" height="100%"></iframe>';                        
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
				        	CTLocAut();
				        }}
				     ]
				 })
			}
		]
		//btnlog,'-',btnhislog,'-',btnLocAut
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
			grid.getStore().baseParams={
					code : Ext.getCmp("TextCode").getValue(),
					desc : Ext.getCmp("TextDesc").getValue(),
					type : Ext.getCmp("comboCTLOCType").getValue(),
					dep : Ext.getCmp("comboCTLOCDepDR").getValue(),
					//treetype:type,
					//category:HiddenCat,
					hospid:hospComp.getValue()
			};
			grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize,
					communityid : communityid
				}
			});
		}
	});
	
	// 刷新工作条
	var btnRefresh = new Ext.Button({
		id : 'btnRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
		handler : Refresh = function() {
			grid.getStore().baseParams = {
					treetype:type,
					category:HiddenCat,
					hospid:hospComp.getValue()
				};
			grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize,
						communityid:communityid
					}
				});
			
			Ext.getCmp("TextCode").reset();
			Ext.getCmp("TextDesc").reset();
			Ext.getCmp("comboCTLOCType").reset();
			Ext.getCmp("comboCTLOCDepDR").reset();
			
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
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				}, '-', 
				'描述', {
					xtype : 'textfield',
					id : 'TextDesc',
					width:120,
					emptyText : '描述/别名',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
				}, '-','科室类型',{
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
				,'-','部门组',{
					xtype:'bdpcombo',
					loadByIdParam : 'rowid',
					fieldLabel : '部门组',
					id:'comboCTLOCDepDR',
					width:120,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('comboCTLOCDepDR'),
					store : new Ext.data.Store({
						autoLoad: true,
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
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					listeners:{
					   'beforequery': function(e){
							this.store.baseParams = {
								desc:e.query,
								hospid:hospComp.getValue()
							};
							this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
							}})

						},
						'select': function(field,e){
						         search();
		                 	}
					}
				},'-',{
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
			},Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName), '-', btnSearch, '-', btnRefresh,'-',btnSort,'-',btnTrans,'-',btnCTLocLinkSpNur, '->',helphtmlbtn
			],  
			listeners : {
			render : function() {
				tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
			}
		}
	});
	var GridCM = [sm, {
    			header: 'RowID',
    			width: 60,
    			sortable: true,
    			dataIndex: 'CTLOCRowID',
    			hidden : true
    		}, {
    			header: '代码',
    			width: 85,
    			sortable: true,
    			dataIndex: 'CTLOCCode'
    		}, {
    			header: '描述',
    			width: 120,
    			sortable: true,
    			dataIndex: 'CTLOCDesc',
    			renderer: Ext.BDP.FunLib.Component.GirdTipShow
    		}, {
    			header: '地址',
    			width: 120,
    			sortable: true,
    			dataIndex: 'CTLOCAddress',
    			renderer: Ext.BDP.FunLib.Component.GirdTipShow
    		}, {
    			header: '科室类型',
    			width: 85,
    			sortable: true,
    			dataIndex: 'CTLOCType',
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
				}
			}, {
				header: '部门组',
				width: 80,
				sortable: true,
				dataIndex: 'DEPDesc'
			}, {
				header: '医嘱索引',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCIndex',
				renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
			}, {
				header: '医院',
				width: 160,
				sortable: true,
				dataIndex: 'HOSPDesc' 
			}, /*{
				header: '科室多层分类',
				width: 100,
				sortable: true,
				dataIndex: 'CTLOCCategoryDR'
			},*/
			{
				header: '物理位置',
				width: 100,
				sortable: true,
				dataIndex: 'CTLOCLocation'   
			},{
				header: '是否有效',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCActiveFlag',
				renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon  
			},{
				header: '排序号',
				width: 80,
				sortable: true,
				dataIndex: 'CTLOCSeqNo'  
			}, {
				header: '在此科室病历可用',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCMedicalRecordActive',
				renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
			},{
				header: '医嘱执行确认',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCExecuteConfirmation',
				renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
			}, {
				header: '开始日期',
				width: 160,
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(BDPDateFormat),
				dataIndex: 'CTLOCDateActiveFrom' 
			}, {
				header: '结束日期',
				width: 85,
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(BDPDateFormat),
				dataIndex: 'CTLOCDateActiveTo'
			}, {
				header: '科室检索码',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCContactName'
			}/*, {
				header: '拼音码',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCPYCode'
			}, {
				header: '五笔码',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCWBCode'
			}, {
				header: '备注',
				width: 85,
				sortable: true,
				dataIndex: 'CTLOCMark'
			}*/];	    
   // create the Grid
	var grid = new Ext.grid.GridPanel({
			id : 'grid',
			region : 'center',
			closable : true,
			store : ds,
			tools:Ext.BDP.FunLib.Component.HelpMsg,
			trackMouseOver : true,
		    columns : GridCM,
		    stripeRows : true,
		    loadMask: { msg: '数据加载中,请稍候...' },
		    title: '科室/病区维护',

		    // config options for stateful behavior
		   // stateful: true,
		   // viewConfig: { forceFit: true },
			bbar : paging ,
			tbar : tb,	
		    stateId: 'grid'		    
		});
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
  	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	//双击事件
	grid.on("rowdblclick", function(grid, rowIndex, e) {
		var _record = grid.getSelectionModel().getSelected();
		if (!_record) {
            Ext.example.msg('修改操作', '请选择要修改的一项');
        } else {
            win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			//Ext.getCmp("form-save").getForm().reset();
			if(_record.get('CTLOCType')=="W" || _record.get('CTLOCType')=="EM" || _record.get('CTLOCType')=="OP" ){
				Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(false);
				Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(false);
			}else{
				Ext.getCmp("form-save").getForm().findField('WARDSingleRoom').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDActive').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewLinkedRooms').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDViewNextMostUrgent').setDisabled(true);
				Ext.getCmp("form-save").getForm().findField('WARDBeforehand').setDisabled(true);
			}

            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + _record.get('CTLOCRowID'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                	Ext.getCmp("CTLOCClinicTypeF").reset();
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
					//Ext.getCmp("CTLOCCategoryDRF").reset();
					//var CategoryDRF=action.result.data.CTLOCCategoryDR;//获取科室多层分类
					//Ext.getCmp("CTLOCCategoryDRF").setValue(CategoryDRF);
					//Ext.getCmp("CTLOCCategoryDRF").setRawValue(_record.get('CTLOCCategoryDR'));
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = _record.get('CTLOCRowID');
			        AliasGrid.loadGrid();
        }				
	});
	
			//单击事件（翻译按钮要用到）
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
		        var _record = grid.getSelectionModel().getSelected();
		        var selectrow = _record.get('CTLOCRowID');	           
			 } else {
			 	var selectrow="";
			 }
			 Ext.BDP.FunLib.SelectRowId = selectrow
		});	
		
		grid.on("rowclick",function(grid,rowIndex,e){
				var _record = grid.getSelectionModel().getSelected();
				if(_record.get('CTLOCType')!="W")
				{
					if((_record.get('CTLOCType')!="EM")&(_record.get('CTLOCType')!="OP"))
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
				
			}); 
	
	//var gridname=Ext.getCmp(Request);
	 /**---------------------右键菜单-------------------**/
  
   
    
	   /*if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  		{*/
            grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
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
		
 	function rightClickFn(grid,rowindex,e){
    	 e.preventDefault();
    	 var currRecord = false; 
   		 var currRowindex = false; 
   		 var currGrid = false; 
         if (rowindex < 0) { 
         	return; 
  		 } 
	     grid.getSelectionModel().selectRow(rowindex); 
	     currRowIndex = rowindex; 
	     currRecord = grid.getStore().getAt(rowindex);
		 
	     var _record = grid.getSelectionModel().getSelected();
		 
	     if(currRecord.json.CTLOCType!="W")//右键菜单灰化
		 {
		 	if((currRecord.json.CTLOCType!="EM")&(_record.get('CTLOCType')!="OP"))
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
	     currGrid = grid; 
	     rightClick.showAt(e.getXY()); 
        }
    //}	
    
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
	/**---------------------右键菜单-------------------**/	

    var viewport = new Ext.Viewport({
        layout: 'border',
        defaults:{split:true},
        items: [GenHospPanel(hospComp),grid]
    });
	//Ext.fly('btnCTLOCType').addClass('x-btn-click');
	
	///多院区医院
	var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		grid.disable();
	}
	else
	{
		/** grid加载数据 */
		/*
		ds.load({
				params : {
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {
				}
			});
			*/
	}		
	
});
