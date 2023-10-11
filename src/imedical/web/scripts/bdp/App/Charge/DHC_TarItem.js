///名称: 收费项目查询
///编写者：基础数据平台-陈莹
///编写日期: 2016-04-01
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/App/Charge/DHC_TarItemAlias.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');

document.write('<script type="text/javascript" src="../scripts/framework/ext.icare.Lookup.js"></script>');
/* 引用导入导出js 2022-07-04 */
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/shim.min.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.full.min.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/Blob.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/FileSaver.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.extendscript.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx-style/xlsx.full.min.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/export.js"> </script>');
//var pinyins=Pinyin.GetJP("液状石蜡外用液体剂[500ml][吉林]")  小写
//alert(pinyins.toUpperCase());
//var pinyins=Pinyin.GetJPU("液状石蜡外用液体剂[500ml][吉林]")  大写
/*
  	///ofy1河南省人民医院 新增收费项目和医嘱项时，将收费项目代码同步到收费项别名和医嘱项别名里
	///ofy3 河南省人民医院 医嘱项代码根据规则生成   医嘱项代码是 医嘱大类的代码 + 获取同一医嘱大类的下的最大生成码+1
	///ofy2 龙岩二院需求  收费项变成无效时，自动把一对一关联的医嘱项停用。
	///ofy4 南方医院 要求放出收费项结束日期给修改
	///ofy5 安徽省立  调用老的医保目录页面(组件)
	///ofy6 河北唐山人民  同步添加医嘱项时，医嘱项代码自动获取数据库中某规则下的医嘱项代码最大值+1
	///ofy7南方医院  添加、修改完收费项数据后不关闭窗口
	///ofy9 北京安贞医院 添加耗材新病案首页子类TARISuppliesMCNew  数据取新病案首页的数据，下拉框显示代码
	///ofy10 医保上传维护  南京高淳人民  根据开单科室和费别判断是否上传到医保  
 */
Ext.onReady(function() {
	
	
	///新增时开始日期默认当天
	//var TodayDate=new Date();
	//var TodayDate=(new Date()).format("Y/m/d");  //2016/04/27
	//var TodayDate=(new Date()).format("y/m/d");  //16/04/27
	Ext.Ajax.timeout = 36000000;
	///获取grid数据
	var GetList_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCTarItem";
	var ADD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=AddOpenData";

	// 单位TARIUOM
	var TARI_UOM_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTUOM&pClassQuery=GetDataForCmb1";
	
	//手术分级，2020-04-13add
	var TARI_OPERCategory_DR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCOperationCategory&pClassQuery=GetDataForCmb1";
	
	
	
	// 收费项目子类TARISubCate
    var SubCate_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarSubCate&pClassQuery=GetDataForCmb1";
	// 收费会计子类TARIAcctCate
	var AcctCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassQuery=GetDataForCmb1";
    // 住院费用子类TARIInpatCate
	var InpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarInpatCate&pClassQuery=GetDataForCmb1";
	// 门诊费用子类查询数据TARIOutpatCate
	var OutpatCate_ACTION_URL =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarOutpatCate&pClassQuery=GetDataForCmb1";
	// 经济核算子类TARIEMCCate
	var EMCCate_ACTION_URL ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarEMCCate&pClassQuery=GetDataForCmb1";
	// 旧病案首页子类查询数据TARIMRCate
	var MRCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarMRCate&pClassQuery=GetDataForCmb1";
	// 新病案首页子类查询数据TARIMCNew
	var MCNew_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCNewTarMRCate&pClassQuery=GetDataForCmb1";
	
	/*
	//收费项目子类TARISubCate
	    var SubCate_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=chargesubcat";
		//收费会计子类TARIAcctCate
		var AcctCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=acctsubcat";
	    //// 住院费用子类TARIInpatCate
 		var InpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=inpatsubcat";
		/// 门诊费用子类查询数据TARIOutpatCate
		var OutpatCate_ACTION_URL =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=outpatsubcat";
		/// 经济核算子类TARIEMCCate
		var EMCCate_ACTION_URL ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=emcsubcat";
		/// 旧病案首页子类查询数据TARIMRCate
		var MRCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=mrsubcat";
		/// 新病案首页子类查询数据TARIMCNew
		var MCNew_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=GetMCNew";
	
	 */
		
	
	
	
	
	// 优先级PriorityDR
  	var OLTPriorityDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
	// 用法OLTInstDR
    var OLTInstDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassQuery=GetDataForCmb1";
	///医嘱子分类
	var ItemCat_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
	
	var Price_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarItemPrice&pClassQuery=GetList";
 	var Price_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItemPrice&pClassMethod=SaveAll";
	
 	//患者费别TPPatInsType
	var PACAdmReason_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmReason&pClassQuery=GetDataForCmb1";
	//医院（改成获取医院组下的医院)
	var CT_Hospital_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForGroup";
	///var CT_Hospital_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	
	//// 账单组查询数据
 	var BillGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassQuery=GetDataForCmb1";
	/// 账单子组查询数据
	var BillSubGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassQuery=GetDataForCmb1";
	

	///根据收费项 查询关联了此收费项的医嘱项
	var LinkedArcim_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassQuery=FindArcByTar";
				
	
	
	var selectNode="",HiddenCat="",HiddenCaption="",selectTARIRowId="";

	
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var pagesize = Ext.BDP.FunLib.PageSize.Main;	
	
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "DHC_TarItem"
	});
	
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.DHCTarItem";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    
	//翻译
	Ext.BDP.FunLib.TableName="DHC_TarItem";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
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
			
			RowID=rows[0].get('TARIRowId');
			Desc=rows[0].get('TARIDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
		else
		{
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	
	function getExpParams() 
	{
		var datefrom1=Ext.getCmp("TbStartDate1").getValue()
		if (datefrom1!="") datefrom1=datefrom1.format(BDPDateFormat)
		var datefrom2=Ext.getCmp("TbStartDate2").getValue()
		if (datefrom2!="") datefrom2=datefrom2.format(BDPDateFormat)
		var ExpParams=Ext.getCmp("tbUOM").getValue()+"^"+Ext.getCmp("tbActiveFlag").getValue()+"^"+""+"^"+Ext.getCmp("TextExternalCode").getValue()+"^"+Ext.getCmp("TextChargeBasis").getValue()  //1-5 1单位^2激活标志(Y/N)^3医保名称(传的空)^4外部代码^5收费依据    
		ExpParams=ExpParams+"^"+""+"^"+Ext.getCmp("TypeF").getValue()+"^"+HiddenCat+"^"+Ext.getCmp("TextPrice1").getValue()+"^"+Ext.getCmp("TextPrice2").getValue()  //6-10  ^6收费说明(传的空)^7分类^8子分类^9价格从^10到价格
		ExpParams=ExpParams+"^"+datefrom1+"^"+datefrom2+"^"+Ext.getCmp("tbItemType").getValue()+"^"+Ext.getCmp("TextInsuCode").getValue()+"^"+Ext.getCmp("tbInsuCodeMapedFlag").getValue()  //11-15  ^11开始日期从^12开始日期到^13项目分类(药品/材料/诊疗项目)^14国家医保编码^15国家医保编码对照状态(Y/N)
		return ExpParams;	
	}
	var DataType=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",Ext.BDP.FunLib.TableName)
	var HospComboHiddenFlag=((tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")=="Y")&&(DataType!="G"))?false:true
	
    //多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数
	hospComp.on('select',function (){
		if (loadflag==1)
		{
			grid.enable();
	        ///切换树的时候， 要清空隐藏额树的数组
	        Ext.getCmp('FindTreeText').reset();
	        hiddenPkgs = [],selectNode="",HiddenCat="",HiddenCaption="";
			var ExpParams=getExpParams()
			grid.getStore().baseParams={
					code:Ext.getCmp("TextCode").getValue(),
					desc:Ext.getCmp("TextDesc").getValue(),
					alias:Ext.getCmp("TextAlias").getValue(),
					ExpParams:ExpParams,
					hospid:hospComp.getValue()  //多院区医院
			};
			grid.getStore().load({
	        	params:{
	        		start:0, 
	        		limit:pagesize
	        	},
				callback : function(records, options, success) {
					if (HospComboHiddenFlag==false)   //医院下拉框没隐藏时 加载 ；如果医院下拉框隐藏，不需要加载，
					{
						CatPanel.root.reload();  ///grid加载完 加载左侧分类树 2020-05-15
					}
				}
	        });
		}
		
	});
	//当天
	var TodayDate=(new Date()).format(BDPDateFormat);
	///第二天
	var TomorrowDate = (new Date((new Date()).getTime() + 24*60*60*1000)).format(BDPDateFormat);
	
	var tbarcat=new Ext.BDP.FunLib.Component.BaseComboBox ({
				name : 'Type',
				id:'TypeF',
				//hiddenName:'Type',
				triggerAction : 'all',// query
				editable:false,
				allowBlank : false,
				mode : 'local',
				width : 120,
				listWidth:170,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('TypeF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TypeF')),
				valueField : 'value',
				displayField : 'name',
				store:new Ext.data.SimpleStore({
					fields:['value','name'],
					data:[
						      
						      ['DHCTarCate','收费项目分类'],
						      ['DHCTarAC','会计费用分类'],
						      ['DHCTarOC','门诊费用分类'],
						      ['DHCTarIC','住院费用分类'],
						      ['DHCTarEC','核算费用分类'],
						      ['DHCTarMC','病案首页分类'],
						      ['DHCTarMCNew','新病案首页分类'],
						      ['ItemCat','树形分类'],
						      ['OPERCategory','手术分级']
					     ]
				}),
				listeners:{
					'select': function(field,e){
						 CatTreeLoader.dataUrl = CatTree_QUERY_ACTION_URL ;  
				         CatTreeLoader.baseParams = {LastLevel:"TreeRoot",Type:Ext.getCmp("TypeF").getValue(),hospid:hospComp.getValue()}     //多院区医院
				         // CatTreeLoader.baseParams.Type=Ext.getCmp("TypeF").getValue(;
				         CatPanel.root.reload();
				         
				         ///切换树的时候， 要清空隐藏额树的数组
				         Ext.getCmp('FindTreeText').reset();
				         hiddenPkgs = [],selectNode="",HiddenCat="",HiddenCaption="";
                     }
                    			
				}
	})
	Ext.getCmp('TypeF').setValue('DHCTarCate')
  Ext.getCmp('TypeF').setRawValue('收费项目分类')
						
	//**********父菜单选择框 初始化treecombo *************//
	var comboTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPItemCategory&pClassMethod=GetTreeComboJson"; 
	
	var comboTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: comboTREE_ACTION_URL
			});
			
			
	/*var comboPanel = new Ext.tree.TreePanel({
				id: 'comboPanel',
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
	var treeCombox = new Ext.tet.TreeComboField({
				name:'TARIItemCatDR',
				id:'treeCombox',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
				fieldLabel:"树形分类",
				hiddenName : 'TARIItemCatDR',
				editable : true,
				enableKeyEvents: true,
				tree:comboPanel
			});*/
	
			
			
	////2016-11-1
	var treeCombox = new Ext.ux.TreeCombo({
				name:'TARIItemCatDR',
				id:'treeCombox',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
				fieldLabel:"树形分类",
				hiddenName : 'TARIItemCatDR',
				root: comboroot=new Ext.tree.AsyncTreeNode({
						id:"CatTreeRoot",
						text:"菜单",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: comboTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false,
				listeners:{
					'select': function(field,e){
						///20170811  自动生成代码
            			//if ((win.title == "添加")||(win.title == "收费项复制")) {
						if (((win.title).indexOf("添加")>-1)||((win.title).indexOf("收费项复制")>-1)) {
							var flag= tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetAutoCreateFlag",hospComp.getValue())
							if (flag==1)
							{
	          					var MaxCode = tkMakeServerCall("web.DHCBL.CT.DHCTarItem","AutoCreateCode",Ext.getCmp("treeCombox").getValue()+"^1",hospComp.getValue());
								if(MaxCode!="") Ext.getCmp("TARICode").setValue(MaxCode)
							}
						}
                     }
                    			
				}
			});
	//2020-06-09 树形分类
	 comboTreeLoader.on("beforeload", function(comboTreeLoader, node) {
   		comboTreeLoader.dataUrl = comboTREE_ACTION_URL;  
		comboTreeLoader.baseParams = {LastLevel:"TreeRoot",hospid:hospComp.getValue()}
    }, this);
	
	//**********父菜单选择框 初始化treecombo  end*************//	
			
			
	//**********左侧类别树 *************//			
	var CatTree_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=GetCategoryTreeJson";
	var CatTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "LastLevel",
				dataUrl: CatTree_QUERY_ACTION_URL   //+'&Type='+Ext.getCmp("TypeF").getValue()
			});
	
	var CatPanel = new Ext.tree.TreePanel({
		region: 'west',
		minSize:100,
		maxSize:270,
		width:260,
		collapsed:false,
		titleCollapse : false,
		collapsible:true,
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
		tbar:[tbarcat,'检索',
				new Ext.BDP.FunLib.Component.TextField({
					id:'FindTreeText',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('FindTreeText'),
				    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FindTreeText')),
					width:70,
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							//alert(node.getValue())
							findByKeyWordFiler(node);
						},
						scope: this
					}
				}),'-',  {
					iconCls:'icon-refresh',
					tooltip : '重置',
					handler:function(){
					
						HiddenCat="",HiddenCaption="";
						clearFind();
						CatPanel.root.reload()
						ClearAll();
					} //清除树过滤
				}
		],
	    listeners:{
	           "click":function(node,event) {
           			var nid=node.id;
           			HiddenCat=nid;
           			HiddenCaption=node.text;
           			
           			selectNode=nid;
	   				
					var ExpParams=getExpParams();
	   				TarItemInfoStore.baseParams={
						code:Ext.getCmp("TextCode").getValue(),
						desc:Ext.getCmp("TextDesc").getValue(),
						alias:Ext.getCmp("TextAlias").getValue(),
						ExpParams:ExpParams,
						hospid:hospComp.getValue()   //多院区医院
	       			};
	       			TarItemInfoStore.load({
				        	params:{
				        		start:0, 
				        		limit:pagesize
				        	}
				      });
					
					
					
           			
           		
				
			}
        }
	});
	
	var timeOutId = null;
	var treeFilter = new Ext.tree.TreeFilter(CatPanel, {
		clearBlank : true,
		autoClear : true
	});
	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node) {
		clearTimeout(timeOutId);// 清除timeOutId
		CatPanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			//var text=Pinyin.GetJPU(text)
			//alert(text)
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
	
	//**********左侧类别树  end*************//
	
	var LinkedArcimds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : LinkedArcim_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'TArcRowid',
									mapping : 'TArcRowid',
									type : 'string'
								}, {
									name : 'TArcCode',
									mapping : 'TArcCode',
									type : 'string'
								}, {
									name : 'TArcDesc',
									mapping : 'TArcDesc',
									type : 'string'
								}, {
									name : 'TOrderCatDesc',
									mapping : 'TOrderCatDesc',
									type : 'string'
								}, {
									name : 'TArcItmCatDesc',
									mapping : 'TArcItmCatDesc',
									type : 'string'
								}, {
									name : 'TBillSubCatDesc',
									mapping : 'TBillSubCatDesc',
									type : 'string'
								}, {
									name : 'StDate',
									mapping : 'StDate',
									type : 'string'
								}, {
									name : 'EndDate',
									mapping : 'EndDate',
									type : 'string'
								}, {
									name : 'LinkQty',
									mapping : 'LinkQty',
									type : 'string'
										
									
								}, {
									name : 'LinkStDate',
									mapping : 'LinkStDate',
									type : 'string'
								}, {
									name : 'LinkEndDate',
									mapping : 'LinkEndDate',
									type : 'string'
								}, {
									name : 'OLTRowid',
									mapping : 'OLTRowid',
									type : 'string'
								
								}, {
									name : 'Relation',
									mapping : 'Relation',
									type : 'string'
								}, {
									name : 'LinkHospial',  //医嘱项所属医院
									mapping : 'LinkHospial',
									type : 'string'
								
								}// 列的映射
						])
			});

			
		var LinkedArcimpaging= new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : LinkedArcimds,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					})	
	 var btnEndLink = new Ext.Toolbar.Button({
				text : '添加结束日期',
				tooltip : '对只关联了一个收费项的医嘱项，会停用对照关系并停用医嘱项；对关联了多个收费项的医嘱项，会只停用对照关系',
				iconCls : 'icon-update',
				id:'btnEndLink',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnEndLink'),
				handler : function() {
					if (LinkedArcimgrid.selModel.hasSelection()) {

						var tarirowid=grid.getSelectionModel().getSelections()[0].get('TARIRowId')	
						var tbenddate=Ext.getCmp("TbLinkEndDate").getRawValue()
						if (tbenddate=="")
						{
							
							Ext.Msg.show({
									title : '提示',
									msg : '结束日期不能为空!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
							return;
						}
						
						var tbenddateymd=Ext.getCmp("TbLinkEndDate").getValue().format("Ymd");
				 	   	var TodayDateymd=(new Date()).format("Ymd");
				 	   	if (tbenddateymd < TodayDateymd) {
				 			Ext.Msg.show({
									title : '提示',
									msg : '结束日期不能早于今天！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
							return;
				 	   	}
						
						var gsm = LinkedArcimgrid.getSelectionModel();
						var rows = gsm.getSelections();
						
						for(var i=0;i<rows.length;i++){
							var linkenddate=LinkedArcimgrid.getSelectionModel().getSelections()[i].get('LinkEndDate')
							if (linkenddate!="")
							{
								Ext.Msg.show({
									title : '提示',
									msg : '第'+(i+1)+'行医嘱项与收费项关联关系已有结束日期，请核对信息！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
								
							}
							var EndDate=LinkedArcimgrid.getSelectionModel().getSelections()[i].get('EndDate')
							if (EndDate!="")
							{
								Ext.Msg.show({
									title : '提示',
									msg : '第'+(i+1)+'行医嘱项已有结束日期，请确认数据！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
							}
							
							
						}
						
						
						Ext.MessageBox.confirm('提示', '确定要添加结束日期吗?如果医嘱项只关联了一个收费项,将同时将此医嘱项停用', function(btn) {
						if (btn == 'yes') {
							
								var LinkStr="";
								var ErrorInfo=""
								for(var i=0;i<rows.length;i++){
									var OLTRowid=LinkedArcimgrid.getSelectionModel().getSelections()[i].get('OLTRowid');
									var Relation=LinkedArcimgrid.getSelectionModel().getSelections()[i].get('Relation');  //医嘱项关联收费项的数量   1  , >1
									var TArcRowid=LinkedArcimgrid.getSelectionModel().getSelections()[i].get('TArcRowid'); 
									///1.先停用医嘱项与收费项关联，关联的结束日期为选中的结束日期；
									///2.1如果这条医嘱项只关联了这一条收费项，则把这条医嘱项也停用，医嘱项结束日期也为选中的日期；
									///2.2如果这条医嘱项关联了多条收费项，则不停用医嘱项。
									if (LinkStr=="")
									{
										LinkStr=OLTRowid+"^"+Relation+"^"+TArcRowid;			
									}
									else
									{
										LinkStr=LinkStr+"&"+OLTRowid+"^"+Relation+"^"+TArcRowid;
									}
								}
								
								var BatcHUpdateOrderLinkTar_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=BatchEndOrderLinkTar";
								Ext.Ajax.request({
									url : BatcHUpdateOrderLinkTar_URL,
									method : 'POST',
									params : {
										'LinkStr' : LinkStr,
										'enddate' : tbenddate
									},
									callback : function(options, success, response) {
										if (success) {
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												Ext.Msg.show({
													title : '提示',
													msg : jsonData.info,
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														LinkedArcimds.baseParams={
															TarRowid:grid.getSelectionModel().getSelections()[0].get('TARIRowId')
														};
														LinkedArcimds.load({
																params : {
																		start : 0,
																		limit : pagesize_pop
																	}
															});
														
													}
												});
											} else {
												var errorMsg = '';
												if (jsonData.info) {
													errorMsg = '<br/>错误信息:' + jsonData.info
												}
												Ext.Msg.show({
															title : '提示',
															msg : errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK,
															fn : function(btn) {
																
																LinkedArcimds.baseParams={
																	TarRowid:grid.getSelectionModel().getSelections()[0].get('TARIRowId')
																};
																LinkedArcimds.load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
																			}
																	});
																
															}
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
									msg : '请选择一条医嘱项!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});	
			
	
	var lookup;
	var genLookup = function(){
		if(lookup&&lookup.store){
			lookup.doSearch(['',document.getElementById('TARIDescLink').value,hospComp.getValue()]);
		}else{
			lookup  = new dhcc.icare.Lookup({
				width:800,
				resizeColumn:false,
				lookupPage: 'dhc.taritemlist',
				lookupName: 'TARIDescLink',  //放大镜关联的输入框id   收费项目名称的id
				listClassName: 'web.DHCBL.CT.DHCOrderLinkTar',
				listQueryName: 'TaritemList',
				displayField: 'taridesc',
				listProperties: ['',document.getElementById('TARIDescLink').value,hospComp.getValue()],
				listeners:{
					selectRow: function(str){
						var strArray=str.split("^");
						Ext.getCmp('TARIRowIdLink').setValue(strArray[0]); //设置收费关联收费项目rowid
						Ext.getCmp('TARIDescLink').setValue(strArray[2]); //设置收费关联收费项目代码
						
					}
				}
			});
		}
	};
	var AddLink_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCOrderLinkTar&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCOrderLinkTar";
	var AddLinkWinForm = new Ext.FormPanel({
				id : 'AddLink-form-save',
				//title:'基本信息',
				//URL : AddLink_SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 110,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TARIRowId',mapping:'TARIRowId'},
                                        {name: 'TARIDesc',mapping:'TARIDesc'},
                                        {name: 'OLTStartDate',mapping:'OLTStartDate'},
                                        {name: 'OLTEndDate',mapping:'OLTEndDate'},
                                        {name: 'OLTQty',mapping:'OLTQty'},
                                        {name: 'OLTBascPriceFlag',mapping:'OLTBascPriceFlag'},
                                        {name: 'OLTBillOnceFlag',mapping:'OLTBillOnceFlag'}
                                        ]),
				defaults : {
					anchor : '90%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
								xtype:'textfield',
								fieldLabel : 'TARIRowIdLink',
								hideLabel : 'True',
								hidden : true,
								id: 'TARIRowIdLink',
								name : 'TARIRowId'
								
							},{
						       xtype:'trigger',
						       id: 'TARIDescLink',
						       readOnly:Ext.BDP.FunLib.Component.DisableFlag('TARIDescLink'),
							   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIDescLink')),
							   name:'TARIDesc',
						       fieldLabel:'<font color=red>*</font>收费项目名称',
						       enableKeyEvents: true,
						       onTriggerClick:genLookup,
						       triggerClass:'x-form-search-trigger',
						       listeners: {
							       specialkey: function(field, e){									
								        if (e.getKey() == e.ENTER) {
									           genLookup();
								        }
							        }
						       }
						      },{
								fieldLabel: '<font color=red>*</font>开始日期',
								xtype:'datefield',
					    		id:'OLTStartDateLink',
					    		readOnly:Ext.BDP.FunLib.Component.DisableFlag('OLTStartDateLink'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTStartDateLink')),
		            			name: 'OLTStartDate',
		            			format: BDPDateFormat,
								enableKeyEvents : true,
								listeners : { 
									'keyup' : function(field, e){ 
										Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
									}
								}	
							},{ 
								fieldLabel: '结束日期',
								xtype:'datefield',
					    		id:'OLTEndDateLink',
					    		readOnly:Ext.BDP.FunLib.Component.DisableFlag('OLTEndDateLink'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTEndDateLink')),
		            			name: 'OLTEndDate',
		            			format: BDPDateFormat,
								enableKeyEvents : true,
								listeners : { 
									'keyup' : function(field, e){ 
										Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
									}
								}
										
							},{
								fieldLabel: '<font color=red>*</font>数量',
								id:'OLTQtyLink',
								readOnly:Ext.BDP.FunLib.Component.DisableFlag('OLTQtyLink'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTQtyLink')),
								name:'OLTQty',
								xtype:'numberfield',
								decimalPrecision:6,
								allowNegative : false,//不允许输入负数
								allowDecimals : true,//允许输入小数
								enableKeyEvents:true,
								style:"ime-mode:disabled",   //不允许中文输入
								 listeners: {
			              			keydown:function(field, e){
			            				if (((e.keyCode>=48)&&(e.keyCode<=57))||((e.keyCode>=96)&&(e.keyCode<=105))||(e.keyCode==110)||(e.keyCode==190)||(e.keyCode==8)||(e.keyCode==46)) {}
			              				else {e.stopEvent()}
			              			}	 //数量文本框,只允许输入数字0-9或小数点、delete、backspace键（110位小键盘小数点  2017-04-20）  
								  }
								  
							}, {
								fieldLabel: '基价模式',
								xtype : 'checkbox',
								id:'OLTBascPriceFlagLink',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlagLink'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlagLink'))
							}, {
								fieldLabel: '多部位计价一次',
								xtype : 'checkbox',
								id:'OLTBillOnceFlagLink',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlagLink'))
							}]	
	});	
	// 增加修改时弹出窗口
	var AddLinkwin = new Ext.Window({
		title : '', 
		width : 400,
		height: 350,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : AddLinkWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'AddLinksave_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('AddLinksave_btn'),
			handler : function() { 
				if(AddLinkWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				
				
				var gsm = LinkedArcimgrid.getSelectionModel();
				var rows = gsm.getSelections();
				
				
				var ArcimDRStr='';
				for(var i=0;i<rows.length;i++){
					var arcimdr=LinkedArcimgrid.getSelectionModel().getSelections()[i].get('TArcRowid')
					if (ArcimDRStr=="")
					{
						ArcimDRStr=arcimdr
					}
					else
					{
						ArcimDRStr=ArcimDRStr+"^"+arcimdr
					}
				}
				var LinkStr=Ext.getCmp('TARIRowIdLink').getValue()+"^"+Ext.getCmp('OLTQtyLink').getValue()+"^"+Ext.getCmp('OLTStartDateLink').getRawValue()+"^"+Ext.getCmp('OLTEndDateLink').getRawValue()+"^"+Ext.getCmp('OLTBascPriceFlagLink').getValue()+"^"+Ext.getCmp('OLTBillOnceFlagLink').getValue()
				            
				var BatchAddOrderLinkTar_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=BatchAddOrderLinkTar";
				Ext.Ajax.request({
					url : BatchAddOrderLinkTar_URL,
					method : 'POST',
					params : {
						'ArcimDRStr' : ArcimDRStr,
						'LinkStr' : LinkStr
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : jsonData.info,
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										AddLinkwin.hide();
										LinkedArcimds.baseParams={
											TarRowid:grid.getSelectionModel().getSelections()[0].get('TARIRowId')
										};
										LinkedArcimds.load({
												params : {
														start : 0,
														limit : pagesize_pop
													}
											});
										
									}
								});
							} else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = '错误信息:<br/>' + jsonData.info
								}
								Ext.Msg.show({
											title : '提示',
											msg : errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												
												
											}
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
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				AddLinkwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				AddLinkWinForm.getForm().reset();
				LinkedArcimds.load({
						params : {
								start : 0,
								limit : pagesize_pop
							}
					});
			},
			"close" : function() {
			}
		}
	});
		
			
			
	/// 批量关联收费项。	
	 var btnAddLink = new Ext.Toolbar.Button({
				text : '批量关联收费项',
				tooltip : '可用于收费项目停止后,快速添加医嘱项与新的收费项的关联关系',
				iconCls : 'icon-add',
				id:'btnAddLink',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddLink'),
				handler : function() {
					if (LinkedArcimgrid.selModel.hasSelection()) {
						AddLinkwin.setTitle('批量关联收费项');
						AddLinkwin.setIconClass('icon-add');
						AddLinkwin.show();
						AddLinkWinForm.getForm().reset();
						
						
					} else {
							Ext.Msg.show({
									title : '提示',
									msg : '请选择一条医嘱项!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});	
	var LinkedArcimsm = new Ext.grid.CheckboxSelectionModel({  
		    singleSelect : false,
			//checkOnly : false,
			width : 20,  
		    listeners:{  
		        selectionchange:function(s){ 
		        	 var selectedCount = s.getCount();
		        	 if (selectedCount==0) { 
		        	 	///重新加载后 不会去掉全选的勾  2017-05-08
		             	LinkedArcimgrid.getEl().select('div.x-grid3-hd-checker').removeClass('x-grid3-hd-checker-on');
		             	
		             }
		        }  
		    }     
		});  
	////sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
	var LinkedArcimgrid = new Ext.grid.GridPanel({
				id : 'LinkedArcimgrid',
				region : 'center',
				closable : true,
				store : LinkedArcimds,
				trackMouseOver : true,
				sm:LinkedArcimsm,
				columns : [LinkedArcimsm, 
						{
							header : '医嘱项ID',
							sortable : true,
							width : 90,
							hidden:true,
							dataIndex : 'TArcRowid'
						}, {
							header : '对照关系',
							sortable : true,
							width:180,
							dataIndex : 'Relation',
							renderer : function(v){
								if(v==1){return '<font color=green>关联一个收费项</font>';}
								if(v>1){return '<font color=red>关联多个收费项</font>';}
							}	
						}, {
							header : '医嘱项代码',
							sortable : true,
							dataIndex : 'TArcCode',
							width : 160,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '医嘱项名称',
							sortable : true,
							dataIndex : 'TArcDesc',
							width : 200,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '医嘱大类',
							sortable : true,
							width:120,
							dataIndex : 'TOrderCatDesc'
						}, {
							header : '医嘱子分类',
							sortable : true,
							width:160,
							dataIndex : 'TArcItmCatDesc'
						}, {
							header : '账单子组',
							sortable : true,
							width:120,
							dataIndex : 'TBillSubCatDesc'
						}, {
							header : '医嘱项开始日期',
							sortable : true,
							width:160,
							dataIndex : 'StDate'
						}, {
							header : '医嘱项结束日期',
							sortable : true,
							width:160,
							dataIndex : 'EndDate',
							renderer : function(v){
								if(v!=""){return '<font color=red>'+v+'</font>';}
							}
						}, {
							header : '关联数量',
							sortable : true,
							width:160,
							dataIndex : 'LinkQty'
						}, {
							header : '关联开始日期',
							sortable : true,
							width:160,
							dataIndex : 'LinkStDate'
						}, {
							header : '关联结束日期',
							sortable : true,
							width:160,
							dataIndex : 'LinkEndDate',
							renderer : function(v){
								if(v!=""){return '<font color=red>'+v+'</font>';}
							}	
						}, {
							header : '关联ID',
							sortable : true,
							width:100,
							hidden:true,
							dataIndex : 'OLTRowid'	
						}, {
							header : '医嘱项所属医院',
							sortable : false,
							width:300,
							dataIndex : 'LinkHospial',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						
						}],
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				tbar:['结束日期',
					{
							xtype:'datefield',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TbLinkEndDate'),
							width:140,
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TbLinkEndDate')),
							format : BDPDateFormat,
							id:'TbLinkEndDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }
							
							}
							
							
						},'-',btnEndLink,'-',btnAddLink],
				columnLines : true, //在列分隔处显示分隔符
				
				bbar :LinkedArcimpaging
			});	
	
	///与收费项关联的医嘱项
	var LinkedArcimlist_win = new Ext.Window({
					iconCls : 'icon-AdmType',
					width : Ext.getBody().getWidth()*0.9,
					height : Ext.getBody().getHeight()*0.9,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [LinkedArcimgrid],
					listeners : {
						"show" : function(){
												
						},
						"hide" : function(){
							Ext.getCmp("TbLinkEndDate").setValue("")
						},
						"close" : function(){
						}
					}
				});
	
	 var btnEff = new Ext.Toolbar.Button({
				text : '根据收费项查询医嘱项',
				tooltip : '根据收费项查询医嘱项',
				iconCls : 'icon-AdmType',
				id:'btnEff',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnEff'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						//LinkedArcimds.removeAll();
						LinkedArcimds.baseParams={
							TarRowid:rows[0].get('TARIRowId')
						};
						LinkedArcimds.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						
						LinkedArcimlist_win.setTitle(rows[0].get('TARIDesc')+'-----关联医嘱项');
						LinkedArcimlist_win.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条收费项!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	
	///根据收费项 查询关联了此收费项的医嘱项   end
	 
		var TARIRowId = new Ext.BDP.FunLib.Component.TextField({
			//fieldLabel : '收费项rowid',
			id : 'TARIRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'TARIRowId'
		});
		

		
		// 收费项代码
		var TARICode = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '<font color=red>*</font>收费项代码',
			id : 'TARICode',
			allowBlank:false,
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARICode'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARICode')),
			name : 'TARICode',
			//regex: /^[A-Za-z0-9]+$/,
			//regexText : '只允许数字和英文字母,请输入正确的代码',
			listeners : {
				'blur' : function(){
					////自动生成代码 20170727 医嘱项页面配置
          				//if ((win.title == "添加")||(win.title == "收费项复制")) {
					if (((win.title).indexOf("添加")>-1)||((win.title).indexOf("收费项复制")>-1)) {
						var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
						if (flag==1)
						{
							var Type = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateType",hospComp.getValue());
							if (Type=="")
							{
								Ext.getCmp("ARCIMCode").setValue(Ext.getCmp("TARICode").getValue());
							}
							if (Type=="F")
							{
								var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode","^^0",hospComp.getValue());
								if (MaxCode!="") Ext.getCmp("ARCIMCode").setValue(MaxCode) 
							}
							if ((Type=="O")||(Type=="OA")||(Type=="A"))   ///类型为OA A O时， 不先把收费项代码带过来，当选了医嘱子分类才带过来
							{
								var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode","^"+Ext.getCmp("ARCIMItemCatDR1").getValue()+"^1",hospComp.getValue());
								if(MaxCode!="") Ext.getCmp("ARCIMCode").setValue(MaxCode)
								
							}
						}
						else{
							Ext.getCmp("ARCIMCode").setValue(Ext.getCmp("TARICode").getValue())
						}
					}
					
				},
				specialkey: function(field, e){	
					///2019-08-02 输入一个字符串，回车查询以这个字符串开头的最大码并自动+1(要求：字符串区分大小写，且字符串后面只有数字
			        if (e.getKey() == e.ENTER) {
                		//if ((win.title == "添加")||(win.title == "收费项复制")) {
			        	if (((win.title).indexOf("添加")>-1)||((win.title).indexOf("收费项复制")>-1)) {
				        	var maxcode=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetMaxCode",Ext.getCmp('TARICode').getValue(),hospComp.getValue());
					        Ext.getCmp('TARICode').setValue(maxcode)
			        	}
			        }
		        },
		        render : function(field) {  
	                    Ext.QuickTips.init();  
	                    Ext.QuickTips.register({  
	                        target : field.el,  
	                        text : '新增收费项时可以回车查询最大码并自动加1'  
	                    })  
	                }  
						
			}
		});

		// 收费项名称
		var TARIDesc = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '<font color=red>*</font>收费项名称',
			id : 'TARIDesc',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIDesc'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIDesc')),
			allowBlank:false,
			name : 'TARIDesc',
			listeners : {
				'blur' : function(){
					Ext.getCmp("ARCIMDesc").setValue(Ext.getCmp("TARIDesc").getValue());
					///根据医嘱名称自动获取拼音首字母大写别名
					var pinyins=Pinyin.GetJPU(Ext.getCmp("ARCIMDesc").getValue());
					Ext.getCmp("ARCIMAlias").setValue(pinyins);
					
				}
			}
		});
	
		// 国家医保名称
		var TARIInsuName = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '国家医保名称',
			id : 'TARIInsuName',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIInsuName'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuName')),
			name : 'TARIInsuName'
		});
		
		//手术分级 下拉框 
		 var TARIOPERCategoryDR = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIOPERCategoryDR1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIOPERCategoryDR1')),
			fieldLabel : '手术分级',
			id:'TARIOPERCategoryDR1',
			listWidth : 250,
			hiddenName : 'TARIOPERCategoryDR',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : TARI_OPERCategory_DR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'CATEGDesc',mapping:'CATEGDesc'},
						{name:'CATEGRowId',mapping:'CATEGRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'CATEGDesc',
			valueField : 'CATEGRowId'
	   });
		
		// 外部编码  
		var TARIExternalCode = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '外部编码',
			id : 'TARIExternalCode',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIExternalCode'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIExternalCode')),
			name : 'TARIExternalCode'/*,
			listeners:{
				render : function(field) {  
                    Ext.QuickTips.init();  
                    Ext.QuickTips.register({  
                        target : field.el,  
                        text : '外部编码里可以设置同类收费项的代码，比如A,A1为同类收费项目，A已经做了医保对照，A1的外部编码里维护A的收费项代码时就可以取到A的医保对照关系'  
                    })  
                }  
			}*/
		});
		//单位
		 var TARIUOM = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIUOM1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIUOM1')),
			allowBlank:false,
			fieldLabel : '<font color=red>*</font>单位',
			id:'TARIUOM1',
			listWidth : 250,
			hiddenName : 'TARIUOM',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : TARI_UOM_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'CTUOMDesc',mapping:'CTUOMDesc'},
						{name:'CTUOMRowId',mapping:'CTUOMRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'CTUOMDesc',
			valueField : 'CTUOMRowId'
	   });
	   
	   
	   
	   
	   
	    // 有效标志
		var TARIActiveFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '有效标志',
			id : 'TARIActiveFlag',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIActiveFlag'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIActiveFlag')),
			inputValue : 'Y', //不加会返回"on"
			name : 'TARIActiveFlag',
			listeners :{
				'check':function(e,checked)
				{
          				//if (win.title=="添加")
					if ((win.title).indexOf("添加")>-1)
					{
						//alert(Ext.getCmp("TARIActiveFlag").getValue())
						try{
							if (Ext.getCmp("TARIActiveFlag").getValue()==false)
							{
								Ext.getCmp("SyncAddARCItmMast").checkbox.dom.disabled = true;
								Ext.getCmp("SyncAddARCItmMast").collapse();
								
							}
							if (Ext.getCmp("TARIActiveFlag").getValue()==true)
							{
								Ext.getCmp("SyncAddARCItmMast").checkbox.dom.disabled = false;
								Ext.getCmp("SyncAddARCItmMast").expand()
								
							}
						}
						catch(e)
						{
							///刚打开formpanel时dom会找不到
						}
					}
				}
			}
		});
		 //收费项目子类
		 var TARISubCate = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			allowBlank:false,
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARISubCate1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARISubCate1')),
			fieldLabel : '<font color=red>*</font>收费项目子类',
			id:'TARISubCate1',
			listWidth : 250,
			hiddenName : 'TARISubCate',  ///不加hiddenName传入后台的就是描述而不是id
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : SubCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARSCDesc',mapping:'TARSCDesc'},
						{name:'TARSCRowId',mapping:'TARSCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARSCDesc',
			valueField : 'TARSCRowId',
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
	    
	 	//收费会计子类
		var TARIAcctCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>收费会计子类',
			id:'TARIAcctCate1',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIAcctCate1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIAcctCate1')),
			 
			listWidth : 250,
			hiddenName : 'TARIAcctCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : AcctCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARACDesc',mapping:'TARACDesc'},
						{name:'TARACRowId',mapping:'TARACRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARACDesc',
			valueField : 'TARACRowId',
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
	   
	
	   
	    
		var TARIInpatCate= new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>住院费用子类',
			id:'TARIInpatCate1',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIInpatCate1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIInpatCate1')),
			 
			listWidth : 250,
			hiddenName : 'TARIInpatCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : InpatCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARICDesc',mapping:'TARICDesc'},
						{name:'TARICRowId',mapping:'TARICRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARICDesc',
			valueField : 'TARICRowId',
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
		
		
		
		
		
	 
		// 门诊费用子类
		var TARIOutpatCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIOutpatCate1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIOutpatCate1')),
			 
			fieldLabel : '<font color=red>*</font>门诊费用子类',
			id:'TARIOutpatCate1',
			listWidth : 250,
			hiddenName : 'TARIOutpatCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OutpatCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TAROCDesc',mapping:'TAROCDesc'},
						{name:'TAROCRowId',mapping:'TAROCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TAROCDesc',
			valueField : 'TAROCRowId',
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
	 
	   
	   
	   
	   
	   
	   	
	  
		// 经济核算子类
		var TARIEMCCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>经济核算子类',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIEMCCate1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIEMCCate1')),
			
			id:'TARIEMCCate1',
			listWidth : 250,
			hiddenName : 'TARIEMCCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : EMCCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARECDesc',mapping:'TARECDesc'},
						{name:'TARECRowId',mapping:'TARECRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARECDesc',
			valueField : 'TARECRowId',
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
	   

	   	
	 
		// 旧病案首页子类
		var TARIMRCate = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>旧病案首页子类',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIMRCate1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIMRCate1')),
			
			id:'TARIMRCate1',
			listWidth : 250,
			hiddenName : 'TARIMRCate',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MRCate_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'TARMCDesc',mapping:'TARMCDesc'},
						{name:'TARMCRowId',mapping:'TARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'TARMCDesc',
			valueField : 'TARMCRowId',
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
	   
	   
	   
	   	
	  
		// 新病案首页子类
		var TARIMCNew = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allowBlank:false,
			emptyText:'',
			fieldLabel : '<font color=red>*</font>新病案首页子类',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIMCNew1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIMCNew1')),
			 
			id:'TARIMCNew1',
			listWidth : 250,
			hiddenName : 'TARIMCNew',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MCNew_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'NTARMCDesc',mapping:'NTARMCDesc'},
						{name:'NTARMCRowId',mapping:'NTARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'NTARMCDesc',
			valueField : 'NTARMCRowId',
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
	   
	   /*
	   // 耗材新病案首页子类 ofy9  再加到panel和grid显示里，后台Entity，AddOpenData，Getlist，opendata,save都需要加。
		var TARISuppliesMCNew = new Ext.BDP.Component.form.ComboBox({
			loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			//allowBlank:false,
			fieldLabel : '耗材新病案首页子类',  //<font color=red>*</font>
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARISuppliesMCNew1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARISuppliesMCNew1')), 
			id:'TARISuppliesMCNew1',
			listWidth : 250,
			hiddenName : 'TARISuppliesMCNew',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : MCNew_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'NTARMCCode',mapping:'NTARMCCode'},
						{name:'NTARMCRowId',mapping:'NTARMCRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'NTARMCCode',
			valueField : 'NTARMCRowId'
	   });
	   */
	     // 特殊项目标识
		var TARISpecialFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '特殊项目标识',
			id : 'TARISpecialFlag',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARISpecialFlag'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARISpecialFlag')),
			inputValue : 'Y',
			name : 'TARISpecialFlag',
			checked : false 
		});
		//特需项目标识  2020-12-09
		var TARISpecialProcurementFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '特需项目标识',
			id : 'TARISpecialProcurementFlag',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARISpecialProcurementFlag'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARISpecialProcurementFlag')),
			inputValue : 'Y',
			name : 'TARISpecialProcurementFlag',
			checked : false 
		});
		
		//不允许重复收费 2021-07-29
		var TARIRepeatedChargeFlag = new Ext.BDP.FunLib.Component.Checkbox({
			fieldLabel : '不允许重复收费',
			id : 'TARIRepeatedChargeFlag',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIRepeatedChargeFlag'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIRepeatedChargeFlag')),
			inputValue : 'Y',
			name : 'TARIRepeatedChargeFlag',
			checked : false 
		});
	   // 收费依据
		var TARIChargeBasis = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '收费依据',
			id : 'TARIChargeBasis',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIChargeBasis'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIChargeBasis')), 
			name : 'TARIChargeBasis'
		});
		
		// 收费说明
		var TARIEngName = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '收费说明',
			id : 'TARIEngName',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIEngName'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIEngName')),
			name : 'TARIEngName'
		});
		
		// 物价编码
		var TARIPriceCode = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '物价编码',
			id : 'TARIPriceCode',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIPriceCode'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIPriceCode')),
			name : 'TARIPriceCode'
		});
		// 物价名称
		var TARIPriceDesc = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '物价名称',
			id : 'TARIPriceDesc',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIPriceDesc'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIPriceDesc')),
			name : 'TARIPriceDesc'
		});
		
		
		var TARIStartDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '<font color=red>*</font>开始日期',
							allowBlank:false,
							name : 'TARIStartDate',
							format : BDPDateFormat,
							id:'TARIStartDate',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIStartDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIStartDate')), 
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
						})
						
		
		var TARIEndDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '结束日期',
							name : 'TARIEndDate',
							format : BDPDateFormat,
							id:'TARIEndDate',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIEndDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIEndDate')), 
							enableKeyEvents : true,
							listeners : {  
								'keyup' : function(field, e){	 
							
										Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
									}
							}
						
						})
		
		// 项目内涵  2017-11-29
		var TARIConnote = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '项目内涵',
			id : 'TARIConnote',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIConnote'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIConnote')),
			name : 'TARIConnote'
		});

		// 备注
		var TARIRemark = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '备注',
			id : 'TARIRemark',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIRemark'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIRemark')),
			name : 'TARIRemark'
		});

		// 除外内容
		var TARIExclude = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '除外内容',
			id : 'TARIExclude',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIExclude'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIExclude')),
			name : 'TARIExclude'
		});
		// 物价备注
		var TARIPriceRemark = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '物价备注',
			id : 'TARIPriceRemark',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIPriceRemark'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIPriceRemark')),
			name : 'TARIPriceRemark'
		});
		
		// 国家医保编码
		var TARIInsuCode = new Ext.BDP.FunLib.Component.TextField({
			fieldLabel : '国家医保编码',
			id : 'TARIInsuCode',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIInsuCode'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuCode')),
			name : 'TARIInsuCode'
		});
		
		// 进口标志
		var TARIManufactorType = new Ext.BDP.FunLib.Component.BaseComboBox({
			hideLabel : 'True',  //标准版先隐藏掉
			hidden : true,
			
			fieldLabel : '进口标志',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARIManufactorType1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARIManufactorType1')),
			id:'TARIManufactorType1',
			listWidth : 250,
			hiddenName : 'TARIManufactorType',
			valueField : 'value',
			displayField : 'name',
			store : new Ext.data.JsonStore({
				fields : ['name', 'value'],
				data : [{
							name : '进口',value : 'IM'
						}, {
							name : '国产',value : 'HM'
						}, {
							name : '合资',value : 'JM'
						}, {
							name : '未分类',value : 'UM'
						}]
			 }),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			triggerAction : 'all'
	   });
		
		
		///关联收费项表
		// 数量
		var OLTQty = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '<font color=red>*</font>数量',
			id : 'OLTQty',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTQty'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTQty')),
			decimalPrecision:6,
			minValue : 0,
			allowNegative : false,//不允许输入负数
			allowDecimals : false,//不允许输入小数
			//allowBlank:false,
			name : 'OLTQty'
		});
		var OLTStartDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'OLTStartDate',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTStartDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTStartDate')),
			
							format : BDPDateFormat,
							//allowBlank:false,
							id:'OLTStartDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
						});
						
		var OLTEndDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '结束日期',
							name : 'OLTEndDate',
							format : BDPDateFormat,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTEndDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTEndDate')),
							id:'OLTEndDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
							
						});
		//优先级
		 var OLTPriorityDR = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTPriorityDR1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTPriorityDR1')),
			fieldLabel : '优先级',
			id:'OLTPriorityDR1',
			listWidth : 250,
			hiddenName : 'OLTPriorityDR',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OLTPriorityDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'OECPRDesc',mapping:'OECPRDesc'},
						{name:'OECPRRowId',mapping:'OECPRRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'OECPRDesc',
			valueField : 'OECPRRowId'
	   });
	  
	var OLTInstDR = new Ext.BDP.Component.form.ComboBox({
		 	loadByIdParam : 'rowid',
		 	pageSize : Ext.BDP.FunLib.PageSize.Combo,
			emptyText:'',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTInstDR1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTInstDR1')),
			fieldLabel : '用法',
			id:'OLTInstDR1',
			listWidth : 250,
			hiddenName : 'OLTInstDR',
			store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : OLTInstDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'PHCINDesc1',mapping:'PHCINDesc1'},
						{name:'PHCINRowId',mapping:'PHCINRowId'} ])
				}),
			mode : 'local',
			shadow:false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'PHCINDesc1',
			valueField : 'PHCINRowId'
	   });
	   
	 
		var TPRowId = new Ext.BDP.FunLib.Component.TextField({
			//fieldLabel : '收费项价格rowid',
			id : 'TPRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'TPRowId'
		});	
		
		
		
		var TPPatInsType = new Ext.BDP.Component.form.ComboBox({
							fieldLabel : '<font color=red>*</font>患者费别',  //患者费别
		 					pageSize : Ext.BDP.FunLib.PageSize.Combo,
							emptyText:'',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPPatInsType1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPPatInsType1')),
							id:'TPPatInsType1',
							listWidth : 250,
							allowBlank:false,
							hiddenName : 'TPPatInsType',
							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : PACAdmReason_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'READesc',mapping:'READesc'},
										{name:'REARowId',mapping:'REARowId'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'READesc',
							valueField : 'REARowId',
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
	   	var TPHospitalDR = new Ext.BDP.Component.form.ComboBox({
							fieldLabel : '<font color=red>*</font>医院',
		 					pageSize : Ext.BDP.FunLib.PageSize.Combo,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPHospitalDR1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPHospitalDR1')),
							id:'TPHospitalDR1',
							listWidth :250,
							allowBlank:false,
							hiddenName : 'TPHospitalDR',
							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : CT_Hospital_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'HOSPDesc',mapping:'HOSPDesc'},
										{name:'HOSPRowId',mapping:'HOSPRowId'} ])
								}),
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'HOSPDesc',
							valueField : 'HOSPRowId',
							 listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
											desc:e.query,
											tablename:'DHC_TarItemPrice',
											Grouptablename:'DHC_TarItem',
											HospGroup:hospComp.getValue() 
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
								
								 	}
							 }
    
	   					});		
		var TPPrice = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '<font color=red>*</font>标准价格',
			id : 'TPPrice',
			minValue : 0,
			decimalPrecision:6,
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPPrice'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPPrice')),			
			allowBlank:false,
			allowNegative : false,//不允许输入负数
			name : 'TPPrice'
		});				
	   	var TPStartDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'TPStartDate',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPStartDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPStartDate')),
							format : BDPDateFormat,
							allowBlank:false,
							id:'TPStartDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
						});
		var TPEndDate=new Ext.BDP.FunLib.Component.DateField({
							fieldLabel : '结束日期',
							name : 'TPEndDate',
							format : BDPDateFormat,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPEndDate'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPEndDate')),
							//hideLabel : 'True',
							//hidden : true,
							id:'TPEndDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							
						});
		var TPAlterPrice1 = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '辅助价格1',
			id : 'TPAlterPrice1',
			decimalPrecision:6,
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPAlterPrice1'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPAlterPrice1')),
			minValue : 0,
			allowNegative : false,//不允许输入负数
			name : 'TPAlterPrice1'
		});	
		var TPAlterPrice2 = new Ext.BDP.FunLib.Component.NumberField({
			fieldLabel : '辅助价格2',
			id : 'TPAlterPrice2',
			decimalPrecision:6,
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPAlterPrice2'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPAlterPrice2')),
			minValue : 0,
			allowNegative : false,//不允许输入负数
			name : 'TPAlterPrice2'
		});	
	 
	  
		
	
	var PriceStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : Price_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'TPRowId',
								mapping : 'TPRowId',
								type : 'string'   
						}, {
								name : 'TPPatInsType',
								mapping : 'TPPatInsType',
								type : 'string'
						}, {
								name : 'TPPatInsTypeDesc',
								mapping : 'TPPatInsTypeDesc',
								type : 'string'
							}, {
								name : 'TPPrice',
								mapping : 'TPPrice',
								type : 'string'
							}, {
								name : 'TPStartDate',
								mapping : 'TPStartDate',
								type : 'string'
							}, {
								name : 'TPEndDate',
								mapping : 'TPEndDate',
								type : 'string'
							
							}, {
								name : 'TPAlterPrice1',
								mapping : 'TPAlterPrice1',
								type : 'string'
								
							}, {
								name : 'TPAlterPrice2',
								mapping : 'TPAlterPrice2',
								type : 'string'
							}, {
								name : 'TPUpdateUser',
								mapping : 'TPUpdateUser',
								type : 'string'
							}, {
								name : 'TPUpdateDate',
								mapping : 'TPUpdateDate',
								type : 'string'
							}, {
								name : 'TPUpdateTime',
								mapping : 'TPUpdateTime',
								type : 'string'
							}, {
								name : 'TPHospitalDR',
								mapping : 'TPHospitalDR',
								type : 'string'
							}, {
								name : 'TPHospitalDRDesc',
								mapping : 'TPHospitalDRDesc',
								type : 'string'
							}
						])
				
	});		
	
	var sm2 = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	var PriceGrid = new Ext.grid.GridPanel({
			id:'PriceGrid',
			region:'center',
			title:'收费项价格',
			height:150,
			//tbar:[addTarItemPrice],
			autoScroll:true,
			store:PriceStore,
			trackMouseOver : true,  //True表示为鼠标移动时高亮显示（默认为true)
			stripeRows : true,  //True表示为显示行的分隔符（默认为true）。
			//loadMask : true, 
			columns :[sm2, {
							header : '收费项价格ID',
							width : 30,
							sortable : true,
							dataIndex : 'TPRowId',
							hidden : true
						}, {
							header : '收费类型ID',
							width : 80,
							sortable : true,
							hidden : true,
							dataIndex : 'TPPatInsType'
						}, {
							header : '收费类型',
							width : 80,
							sortable : true,
							dataIndex : 'TPPatInsTypeDesc'
						}, {
							header : '标准价格',
							width : 80,
							sortable : true,
							dataIndex : 'TPPrice'
						}, {
							header : '开始日期',
							width : 90,
							//renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							sortable : true,
							dataIndex : 'TPStartDate'
							
						}, {
							header : '结束日期',
							width : 90,
							//renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							sortable : true,
							dataIndex : 'TPEndDate'
						}, {
							header : '辅助价格1',
							width : 80,
							sortable : true,
							dataIndex : 'TPAlterPrice1'
						}, {
							header : '辅助价格2',
							width : 80,
							sortable : true,
							dataIndex : 'TPAlterPrice2'
						}, {
							header : '更新人',
							width : 80,
							sortable : true,
							dataIndex : 'TPUpdateUser'
						}, {
							header : '更新日期',
							width : 80,
							sortable : true,
							dataIndex : 'TPUpdateDate'
						}, {
							header : '更新时间',
							width : 80,
							sortable : true,
							dataIndex : 'TPUpdateTime'
						}, {
							header : '医院ID',
							width : 90,
							hidden : true,
							sortable : true,
							dataIndex : 'TPHospitalDR'
						}, {
							header : '医院',
							width : 120,
							sortable : true,
							dataIndex : 'TPHospitalDRDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						/*}, {
							header : '备注信息',
							width : 100,
							sortable : true,
							dataIndex : 'TPNoteText'*/
						
						}],
				loadMask : {
					//msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true  ///注释后按照width显示宽度
				},
				stateId : 'PriceGrid'
		});

	/*PriceGrid.on("rowclick", function(PriceGrid, rowIndex, e) {
		   	var gsm = PriceGrid.getSelectionModel();//获取选择列
			var rows = gsm.getSelections();//根据选择列获取到所有的行
			
			
			var lastvalidflag=0;  //0为 其他数据的结束日期都不为空
			if ((rows[0].get('TPEndDate')=="")&&(rows[0].get('TPRowId')!=""))
			{
				for (var i = 0; i < PriceStore.getCount(); i++) {
					var record1 = PriceStore.getAt(i);
					if  ((record1.get('TPRowId')!="")&&(record1.get('TPRowId')!=rows[0].get('TPRowId')))
					{
						if (record1.get('TPEndDate')=="")
						{
							var lastvalidflag=1;
						}
					}
				}
			}		
			if ((rows[0].get('TPEndDate')=="")&&(rows[0].get('TPRowId')!="")&&(lastvalidflag==1))
			{
				Ext.getCmp('btn_UpdatePriceEndDate').enable();
	    	 	Ext.getCmp('TPPatInsType1').setValue(rows[0].get('TPPatInsType'))
	    	 	Ext.getCmp('TPHospitalDR1').setValue(rows[0].get('TPHospitalDR'))
				Ext.getCmp("TPStartDate").setValue(rows[0].get('TPStartDate'));
				Ext.getCmp("TPEndDate").setValue(rows[0].get('TPEndDate'));
				Ext.getCmp("TPPrice").setValue(rows[0].get('TPPrice'));
				Ext.getCmp("TPAlterPrice1").setValue(rows[0].get('TPAlterPrice1'));
				Ext.getCmp("TPAlterPrice2").setValue(rows[0].get('TPAlterPrice2'));
			}
			else
			{
				Ext.getCmp('btn_UpdatePriceEndDate').disable();
				var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
				Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
				var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
				Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
				Ext.getCmp('TPPrice').setValue("")
	     		//if (win.title=='修改')
	     		if (((win.title).indexOf("修改")>-1))
				{
					Ext.getCmp("TPStartDate").setValue(TomorrowDate);	
				}
				else
				{
					Ext.getCmp("TPStartDate").setValue(TodayDate);
				}
	     		Ext.getCmp('TPEndDate').setValue("")
	     		Ext.getCmp('TPAlterPrice1').setValue("")
	     		Ext.getCmp('TPAlterPrice2').setValue("")
			}
				        
    });	
	*/
    
/*alert(document.body.clientWidth) //获取页面总宽度
		alert("sw"+talPanel.x)
		alert("sh"+HisListTab.getWidth())

		return;*/
	
	
		// 收费项目Panel
var DHCTarItemPanel = new Ext.form.FormPanel({
	title:'收费项目',
	id:'DHCTarItemPanel',
	labelWidth : 110,
	labelAlign : 'right',
	frame : true,
	reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TARIRowId',mapping:'TARIRowId'},
                                         {name: 'TARICode',mapping:'TARICode'},
                                         {name: 'TARIDesc',mapping:'TARIDesc'},
                                         {name: 'TARIInsuName',mapping:'TARIInsuName'},
                                         {name: 'TARIOPERCategoryDR',mapping:'TARIOPERCategoryDR'},
                                         //{name: 'TariExpPrintName',mapping:'TariExpPrintName'},
                                         {name: 'TARIExternalCode',mapping:'TARIExternalCode'},
                                         {name: 'TARIItemSubCat',mapping:'TARIItemSubCat'},
                                         {name: 'TARIItemCatDR',mapping:'TARIItemCatDR'},
                                         {name: 'TARIUOM',mapping:'TARIUOM'},
                                         {name: 'TARISubCate',mapping:'TARISubCate'},
                                         {name: 'TARIInpatCate',mapping:'TARIInpatCate'},
                                         {name: 'TARIEMCCate',mapping:'TARIEMCCate'},
                                         {name: 'TARIMCNew',mapping:'TARIMCNew'},
                                         {name: 'TARIChargeBasis',mapping:'TARIChargeBasis'},
                                         {name: 'TARIStartDate',mapping:'TARIStartDate'},
                                         {name: 'TARIActiveFlag',mapping:'TARIActiveFlag'},
                                         {name: 'TARIAcctCate',mapping:'TARIAcctCate'},
                                         {name: 'TARIOutpatCate',mapping:'TARIOutpatCate'},
                                         {name: 'TARIMRCate',mapping:'TARIMRCate'},
                                        
                                         {name: 'TARIConnote',mapping:'TARIConnote'},
                                         {name: 'TARIRemark',mapping:'TARIRemark'},
                                         {name: 'TARIExclude',mapping:'TARIExclude'},
                                         {name: 'TARIPriceRemark',mapping:'TARIPriceRemark'},
                                         {name: 'TARIInsuCode',mapping:'TARIInsuCode'},   //2021-04-06
                                         {name: 'TARIManufactorType',mapping:'TARIManufactorType'},   //2021-8-19
                                         {name: 'TARIPriceCode',mapping:'TARIPriceCode'},
                                         {name: 'TARIPriceDesc',mapping:'TARIPriceDesc'},
                                         {name: 'TARIEndDate',mapping:'TARIEndDate'},
                                         {name: 'TARISpecialFlag',mapping:'TARISpecialFlag'},
                                         {name: 'TARISpecialProcurementFlag',mapping:'TARISpecialProcurementFlag'},
                                         {name: 'TARIRepeatedChargeFlag',mapping:'TARIRepeatedChargeFlag'},
                                         {name: 'TARIEngName',mapping:'TARIEngName'}
                                        ]),
				
	
	items : [
					{
						xtype: 'fieldset',
						anchor : '96%',
						style:'padding:12px 0px 0px 10px',
						defaults:{border:false},
						items:[		
							
						{
							layout: 'column', defaults: {defaults: {anchor:'95%'}}, items:
							
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARICode] }	
				 			 	,{columnWidth:.67,layout:'form',items:[TARIDesc] }
			     			]
						},{
				 			layout: 'column', defaults: {defaults: {anchor:'95%'}},items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIActiveFlag] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARIStartDate] }	 
			     			 	,{columnWidth:.33,layout:'form',items:[TARIEndDate]}
			     			]
			     		},{
				 			layout: 'column', defaults: {defaults: {anchor:'95%'}},  items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIUOM]  }
			     			 	,{columnWidth:.33,layout:'form',items:[TARISubCate] }
			     			 	 ,{columnWidth:.33,layout:'form',items:[treeCombox]}
			     			]
			     		},{
				 			layout: 'column', defaults: {defaults: {anchor:'95%'}}, items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIAcctCate] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARIOutpatCate] }	 
			     			 	,{columnWidth:.33,layout:'form',items:[TARIOPERCategoryDR]}
			     			 	
			     			]
			     		},{
				 			layout: 'column',defaults: {defaults: {anchor:'95%'}}, items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIInpatCate] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARIMRCate] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARISpecialFlag] }
			     			]
			     		
			     		},{
				 			layout: 'column', defaults: {defaults: {anchor:'95%'}}, items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIEMCCate] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARIMCNew] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARISpecialProcurementFlag]}
			     				  
			     			]
			     			
			     		},{
				 			layout: 'column', defaults: {defaults: {anchor:'95%'}}, items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIInsuCode] }  //国家医保编码
			     			 	,{columnWidth:.33,layout:'form',items:[TARIInsuName]}
			     			 	,{columnWidth:.33,layout:'form',items:[TARIRepeatedChargeFlag]}  //不允许重复计费
			     			]
			     		
			     		},{
				 			layout: 'column', defaults: {defaults: {anchor:'95%'}}, items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIPriceCode] }
			     			 	,{columnWidth:.33,layout:'form',items:[TARIPriceDesc]}
			     			 	,{columnWidth:.33,layout:'form',items:[TARIExternalCode]}
			     			]
			     		},{
              				layout: 'column', defaults: {defaults: {anchor:'95%'}}, items:
							[
				 			 	{columnWidth:.33,layout:'form',items:[TARIManufactorType] }  //进口标志
			     			 	,{columnWidth:.33,layout:'form',items:[TARIRowId]}
			     			]	 	
			     		},{
				 			layout: 'column', defaults: {defaults: {anchor:'97.3%'}}, items:
							[
				 			 	{columnWidth:1,layout:'form',items:[TARIChargeBasis]}
			     			]
			     		},{
							layout: 'column',  defaults: {defaults: {anchor:'97.3%'}},items:
							[
								{columnWidth:1,layout:'form',items:[TARIEngName] }
			     			]
						
						},{
							layout: 'column',  defaults: {defaults: {anchor:'97.3%'}},items:
							[
								{columnWidth:1,layout:'form',items:[TARIConnote] }
			     			]
						
						},{
							layout: 'column',  defaults: {defaults: {anchor:'97.3%'}},items:
							[
								{columnWidth:1,layout:'form',items:[TARIRemark] }
			     			]
						
						},{
							layout: 'column',  defaults: {defaults: {anchor:'97.3%'}},items:
							[
								{columnWidth:1,layout:'form',items:[TARIExclude] }
			     			]
						},{
							layout: 'column',  defaults: {defaults: {anchor:'97.3%'}},items:
							[
								{columnWidth:1,layout:'form',items:[TARIPriceRemark] }
			     			]
						}
						]
					},
		
			{
			xtype : 'fieldset',
			checkboxToggle : true,
			title : '同步生成医嘱项',
			autoHeight : true,
			id : 'SyncAddARCItmMast',
			collapsed : true,
			layout : 'form',
			//style:'padding:5px 0px 0px 0px',
			anchor : '96%',
			defaults:{border:false},
			items : [
			
				{
				layout: 'column',
				
				defaults:{border:false,defaults: {anchor:'95%'}},
				items : [
				{
					columnWidth : .335,
					xtype:'fieldset',
					//style:'margin-left:-20px',
					items : [{
						fieldLabel: '<font color=red>*</font>医嘱代码',
						dataIndex:'ARCIMCode',
						xtype:'textfield',
						
						///allowBlank:false,
						id:'ARCIMCode',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMCode'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMCode')),
						listeners :{
							specialkey: function(field, e){									
						        if (e.getKey() == e.ENTER) {
						        	var searchstr=Ext.getCmp('ARCIMCode').getValue()
							        var maxcode=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetMaxCode",searchstr,hospComp.getValue());
							        Ext.getCmp('ARCIMCode').setValue(maxcode)
						        }
					        },
					        render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '回车查询最大码并自动加1'  
				                    })  
				                } 
						}
					},{
						fieldLabel: '<font color=red>*</font>医嘱名称',
						id:'ARCIMDesc',
						xtype:'textfield',
						//allowBlank:false,
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDesc'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDesc')),
						listeners :{
							'blur':function(f){
								///根据医嘱名称自动获取拼音首字母大写别名
	 	 						var pinyins=Pinyin.GetJPU(Ext.getCmp("ARCIMDesc").getValue());
								Ext.getCmp("ARCIMAlias").setValue(pinyins);
							}
						}
					},{
						xtype: 'datefield',
						fieldLabel: '<font color=red>*</font>开始日期',
						id:'ARCIMEffDate',
						//allowBlank:false,
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMEffDate'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMEffDate')),
						name: 'ARCIMEffDate',
						format: BDPDateFormat,
						enableKeyEvents : true,
						listeners : { 
							'keyup' : function(field, e){ 
								Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
							}
						}
					},{
						xtype: 'datefield',
						fieldLabel: '结束日期',
						id:'ARCIMEffDateTo',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMEffDateTo'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMEffDateTo')),
						name: 'ARCIMEffDateTo',
						format: BDPDateFormat,
						enableKeyEvents : true,
						listeners : { 
							'keyup' : function(field, e){ 
								Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
							}
						}
					},{
						fieldLabel: '医嘱缩写',
						id:'ARCIMAbbrev',
						xtype: 'textfield',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMAbbrev'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMAbbrev'))	
					},{
						fieldLabel: '医嘱备注',
						id:'ARCIMOEMessage',
						xtype: 'textfield',
						readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMOEMessage'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMOEMessage'))
					
					}]
				}, {
					columnWidth : .33,
					xtype:'fieldset',
					items : [{
						fieldLabel: '<font color=red>*</font>医嘱子分类',
						xtype:'bdpcombo',
				       	id:'ARCIMItemCatDR1',
				       	hiddenName:'ARCIMItemCatDR',
				       	//allowBlank:false,
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMItemCatDR1'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMItemCatDR1')),
				      	forceSelection: true,
				       	selectOnFocus:false,
				       	mode:'remote',
				       	queryParam : 'desc',
				       	allQuery:'',  
				       	pageSize:Ext.BDP.FunLib.PageSize.Combo,
				       	minChars: 0,  
				       	listWidth:250,
						valueField:'ARCICRowId',
						displayField:'ARCICDesc',
						store:new Ext.data.JsonStore({
								url:ItemCat_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'rowid',
								fields:['ARCICRowId','ARCICCode','ARCICDesc'],
								remoteSort: true,
								sortInfo: {field: 'rowid', direction: 'ASC'}
							}),
				 		listeners:{
         					'select': function(field,e){
                    					//if ((win.title == "添加")||(win.title == "收费项复制")) {
         						if (((win.title).indexOf("添加")>-1)||((win.title).indexOf("收费项复制")>-1)) {
         							////自动生成代码 20170727  医嘱项页面配置
	         						var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
									if (flag==1)
									{
										var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode","^"+Ext.getCmp("ARCIMItemCatDR1").getValue()+"^1",hospComp.getValue());
										if(MaxCode!="") Ext.getCmp("ARCIMCode").setValue(MaxCode) 
									}
         						}
         							///ofy3 河南省人民医院 医嘱项代码根据规则生成
         							/*var itemcatid=Ext.getCmp('ARCIMItemCatDR1').getValue()
         							var RuleCode=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetMaxCodeByItemCat",itemcatid);						
          							Ext.getCmp("ARCIMCode").setValue(RuleCode);  //清空账单亚组的值
          							//alert(RuleCode)
          							 */
                     			},
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
							
							
					},{
						fieldLabel: '医嘱优先级',
						xtype:'bdpcombo',
						id:'ARCIMDefPriorityDR1',
				       	hiddenName:'ARCIMDefPriorityDR',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefPriorityDR1'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefPriorityDR1')),
				       	forceSelection: true,
				       	selectOnFocus:false,
				       	mode:'remote',
				       	queryParam:'desc',
				       	allQuery:'',   
				       	pageSize:Ext.BDP.FunLib.PageSize.Combo,
				       	minChars: 0,   
				       	listWidth:250,
				       	valueField:'OECPRRowId',
				       	displayField:'OECPRDesc',
				       	store:new Ext.data.JsonStore({
								url:OLTPriorityDR_QUERY_ACTION_URL,
								root: 'data',
								totalProperty: 'total',
								idProperty: 'rowid',
								fields:['OECPRRowId','OECPRCode','OECPRDesc'],
								remoteSort: true,
								sortInfo: {field: 'rowid', direction: 'ASC'}
						 }) 
					},{
						fieldLabel: '<font color=red>*</font>账单组',
						xtype:'bdpcombo',
						//allowBlank:false,
				    	id:'ARCIMBill1',
				    	hiddenName:'ARCIMBill',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMBill1'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMBill1')),
					    allQuery:'',   
				    	forceSelection: true,
					    selectOnFocus:true,
				     	mode:'remote',
				     	queryParam:'desc',
				    	pageSize:Ext.BDP.FunLib.PageSize.Combo,
				    	minChars: 0,
			    		listWidth:250,
				    	valueField:'ARCBGRowId',
				    	displayField:'ARCBGDesc',
				    	store:new Ext.data.JsonStore({
						    url:BillGroup_ACTION_URL,
						    root: 'data',
						    totalProperty: 'total',
						    idProperty: 'rowid',
						    fields:['ARCBGRowId','ARCBGDesc'],
						    remoteSort: true,
						    sortInfo: {field: 'rowid', direction: 'ASC'}
						}),
				 		listeners:{
         					'select': function(field,e){
          							Ext.getCmp("ARCIMBillSubDR1").setValue("");  //清空账单亚组的值
                     		},
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
					},{
						fieldLabel: '<font color=red>*</font>账单子组',
						xtype:'bdpcombo',
						//allowBlank:false,
				    	id:'ARCIMBillSubDR1',
				    	hiddenName:'ARCIMBillSubDR',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMBillSubDR1'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMBillSubDR1')),
				    	forceSelection: true,
				    	selectOnFocus:true,
				    	mode:'remote',
				    	queryParam:'desc',
				    	pageSize:Ext.BDP.FunLib.PageSize.Combo,
				    	minChars: 0,
				    	listWidth:250,
					    valueField:'ARCSGRowId',
				    	displayField:'ARCSGDesc',
				    	store:new Ext.data.JsonStore({
					    	url:BillSubGroup_ACTION_URL,
						  	root: 'data',
						  	totalProperty: 'total',
						  	idProperty: 'rowid',
						  	fields:['ARCSGRowId','ARCSGDesc'],
						  	remoteSort: true,
						  	sortInfo: {field: 'rowid', direction: 'ASC'}
						}),
				 		listeners:{
			 				'beforequery': function(e){
									this.store.baseParams = {
										desc:e.query,
		  								ParRef:Ext.getCmp("ARCIMBill1").getValue(),
		         		  				hospid:hospComp.getValue()
									};
									this.store.load({params : {
												start : 0,
												limit : Ext.BDP.FunLib.PageSize.Combo
									}})
		      				
							 	}
                    	}
                    },{
							fieldLabel: '<font color=red>*</font>账单单位',
							xtype:'bdpcombo',
							id:'ARCIMBillingUOMDR',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMBillingUOMDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMBillingUOMDR')),
					    	forceSelection: true,
						    selectOnFocus:false,
					     	mode:'remote',
					     	queryParam:'desc',
					    	pageSize:Ext.BDP.FunLib.PageSize.Combo,
					    	minChars: 0,  
				    		listWidth:250,
					    	valueField:'CTUOMRowId',
					    	displayField:'CTUOMDesc',
					    	store:new Ext.data.JsonStore({
								 url:TARI_UOM_QUERY_ACTION_URL,
								 root:'data',
								 totalProperty:'total',
								 idProperty:'rowid',
								 fields:['CTUOMRowId','CTUOMDesc'] 
							}) 
					},{
						fieldLabel: '服务/材料',
						xtype:'combo',
						id:'ARCIMServMaterial',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMServMaterial'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMServMaterial')),
						valueField:'rowid',
			    		displayField:'code',
						mode:'local',
						store: new Ext.data.ArrayStore({
			      			fields: ['rowid','code'],
			      			data: [['S','服务'],['M','材料']]
		     			})
					}] //OLTInstDR,OLTPriorityDR,OLTTariffDR
				}, {
					columnWidth : .33,
					xtype:'fieldset',
					items : [{
							fieldLabel: '<font color=red>*</font>别名(/分隔)',
							id:'ARCIMAlias',
							xtype:'textfield',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMAlias'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMAlias'))
						},{
							boxLabel:'独立医嘱',
							xtype: 'checkbox',
							name:'ARCIMOrderOnItsOwn',
							id:'ARCIMOrderOnItsOwn',
							readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMOrderOnItsOwn'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMOrderOnItsOwn')),
							inputValue:'Y'
						},{
							boxLabel:'无库存医嘱',
							id:'ARCIMAllowOrderWOStockCheck',
							xtype: 'checkbox',
							name:'ARCIMAllowOrderWOStockCheck',
							readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMAllowOrderWOStockCheck'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMAllowOrderWOStockCheck')),
							inputValue:'Y'
						},{
							boxLabel:'加急医嘱',
							xtype: 'checkbox', 
							id:'ARCIMSensitive',
							name:'ARCIMSensitive',
							readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive')),
							inputValue:'Y',
							listeners:{
         						'check':function(e,checked)
								{
									if(checked==true)
									{
										Ext.getCmp("ARCIMDefSensitive").readOnly = false;
									}
									else
									{
										Ext.getCmp("ARCIMDefSensitive").setValue(false)
										Ext.getCmp("ARCIMDefSensitive").readOnly = true;
									}
								}
                    		}
						},{
							boxLabel:'默认加急',
							id:'ARCIMDefSensitive',
							xtype : 'checkbox',
							readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive')),
							inputValue:'Y',
							listeners:{
								render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '加急医嘱才能选择默认加急'  
				                    })  
				                }  
				            
                    		}	
						}]
				}
				
				]},
				{
			layout: 'column',
			title : '关联医嘱项',
			id : 'Link',
			defaults:{border:false,defaults: {anchor:'95%'}},
			items : [
					{
						columnWidth : .335,
						xtype:'fieldset',
						items : [OLTQty]
					},{
						columnWidth : .33,
						xtype:'fieldset',
						items : [OLTStartDate]
					},{
						columnWidth : .33,
						xtype:'fieldset',
						items : [OLTEndDate]
					}
					
					
					
					
					
					]}
				
				
				
				
				]
		}
		
		
		
		]
});


	
	var winPricePanel = new Ext.form.FormPanel({
  		id:'winPricePanel',
		xtype:'form',
		region:'north', 
		frame:true,
		height:130,
		labelAlign : 'right',
		items:[{
			xtype:'fieldset',
			title:'价格维护',
			items:[{
				layout:'column',
				border:false,
				items:[{
					layout: 'form',
					labelWidth:80,
					columnWidth: '.34',
					border:false,
					defaults: {anchor:'95%'},
					items: [TPPatInsType,TPAlterPrice1,TPHospitalDR
					
					/*,{
						name : 'TPNoteText',
						fieldLabel: '备注',    //备注
						xtype:'textfield',
						id:'TPNoteText',
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('TPNoteText'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TPNoteText'))
					} */
					
					
					] 
				},{
					layout: 'form',
					labelWidth:80,
					columnWidth: '.33',
					border:false,
					defaults: {anchor:'95%'},
					items: [TPPrice,TPAlterPrice2]
				},{
					layout: 'form',
					columnWidth: '.33',
					border:false,
					defaults: {anchor:'100%'},
					items: [TPStartDate,TPEndDate]
				}]
			}]}],
				
					buttonAlign:'center',
					buttons:[{
		  						id:'btn_AddPrice',
		  						disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddPrice'),
								text:'添加',
								iconCls : 'icon-add',
								handler:function(){
									
									
									if(winPricePanel.getForm().isValid()==false){
										 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
										 return;
									}
									if (Ext.getCmp("TPPatInsType1").getValue()==""){
										 	Ext.Msg.show({
															title:'提示',
															msg:"患者费别不能为空,请重新选择!",
															icon:Ext.Msg.ERROR,
															buttons:Ext.Msg.OK
														});
												return ;
									 }
									 if (Ext.getCmp("TPHospitalDR1").getValue()==""){
										 	Ext.Msg.show({
															title:'提示',
															msg:"医院不能为空,请重新选择!",
															icon:Ext.Msg.ERROR,
															buttons:Ext.Msg.OK
														});
												return ;
									 }
									 if (Ext.getCmp("TPPrice").getRawValue()==""){
									 		Ext.Msg.show({
														title:'提示',
														msg:"价格不能为空!",
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											Ext.getCmp("TPPrice").focus()
											return ;
									 }
									if (Ext.getCmp("TPStartDate").getValue()==""){
									 	Ext.Msg.show({
														title:'提示',
														msg:"价格开始日期不能为空,请重新选择!",
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											return ;
									 }
									 else{
									 	
										var tbstdateymd=Ext.getCmp("TPStartDate").getValue().format("Ymd");
								 	   	var TodayDateymd=(new Date()).format("Ymd");
								 	   	if (tbstdateymd < TodayDateymd) {
								 			Ext.Msg.show({
													title : '提示',
													msg : '价格开始日期不允许早于今天！',
													icon : Ext.Msg.WARNING,
													buttons : Ext.Msg.OK
												});
											return;
								 	   	}
								 	   	if (Ext.getCmp("TPEndDate").getValue()!=""){
								 	   		
								 	   		/*var lastvalidflag=0;  //0为 其他数据的结束日期都不为空
											for (var i = 0; i < PriceStore.getCount(); i++) {
												var record1 = PriceStore.getAt(i);
												if (record1.get('TPEndDate')=="")
												{
													var lastvalidflag=1;
												}
											}
											if (lastvalidflag==0)
											{
												Ext.Msg.show({
														title : '提示',
														msg : '没有有效价格时新增不允许维护价格结束日期！',
														icon : Ext.Msg.WARNING,
														buttons : Ext.Msg.OK
													});
												return;
											}*/
									 	   	var tbendtdateymd=Ext.getCmp("TPEndDate").getValue().format("Ymd");
									 	   	var TodayDateymd=(new Date()).format("Ymd");
									 	   	if (tbendtdateymd < TodayDateymd) {
									 			Ext.Msg.show({
														title : '提示',
														msg : '价格结束日期不允许早于今天！',
														icon : Ext.Msg.WARNING,
														buttons : Ext.Msg.OK
													});
												return;
									 	   	}
									 	   	
									 	   	if (tbendtdateymd < tbstdateymd) {
									 			Ext.Msg.show({
														title : '提示',
														msg : '价格结束日期不允许早于结束日期！',
														icon : Ext.Msg.WARNING,
														buttons : Ext.Msg.OK
													});
												return;
									 	   	}
								 	   	}
								 	   	
							 	   	}
							 	   	
									 if (Ext.getCmp("TPPrice").getRawValue()=="")  //使用getValue价格为0时也会报错
									 {
									 	Ext.Msg.show({
														title:'提示',
														msg:"标准价格不能为空,请重新选择!",
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											return ;
									 }
									
									 //if (win.title=='修改')
									 if (((win.title).indexOf("修改")>-1))
									 {
									 	
												var datefrom=Ext.getCmp('TPStartDate').getRawValue(); 
												var dateto=Ext.getCmp('TPEndDate').getRawValue();
												var AddPriceStr = Ext.getCmp('TPPatInsType1').getValue()+'^'+Ext.getCmp('TPPrice').getValue()+'^'+datefrom+'^'+dateto+'^'+Ext.getCmp('TPAlterPrice1').getValue()+'^'+Ext.getCmp('TPAlterPrice2').getValue()+'^'+Ext.getCmp('TPHospitalDR1').getValue()   ///+'^'+Ext.getCmp('TPNoteText').getValue();
												
												var gsm =PriceGrid.getSelectionModel();
												var rows = gsm.getSelections()
												
												Ext.Ajax.request({
													url:Price_SAVE_ACTION_URL,
													method:'POST',
													params:{
														'rowid':selectTARIRowId ,
														'AddPriceStr':AddPriceStr
													},
													callback:function(options, success, response){
														if(success){
															/*alert(response.responseText)*/
															var jsonData = Ext.util.JSON.decode(response.responseText);
															if(jsonData.success == 'true'){
																Ext.Msg.show({
																			title:'提示',
																			msg:jsonData.info,
																			icon:Ext.Msg.INFO,
																			buttons:Ext.Msg.OK,
																			fn:function(btn){
																				PriceGrid.getStore().baseParams={
																					TARIRowId :  selectTARIRowId
																				};
																				PriceGrid.getStore().load();
																				var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
																				Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
																				var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
																				Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
																	     		Ext.getCmp('TPPrice').setValue("")
																	     		
																	     		Ext.getCmp('TPStartDate').setValue(TomorrowDate)
																	     		Ext.getCmp('TPEndDate').setValue("")
																	     		Ext.getCmp('TPAlterPrice1').setValue("")
																	     		Ext.getCmp('TPAlterPrice2').setValue("")
																	     		//Ext.getCmp('TPNoteText').setValue("")
																	     		
																		}
																	});							
																}else{
																	Ext.Msg.show({
																				title:'提示',
																				msg:jsonData.errorinfo,
																				icon:Ext.Msg.ERROR,
																				buttons:Ext.Msg.OK
																			});
																	}
													  	  }else{
															  Ext.Msg.show({
																			title:'提示',
																			msg:"收费项价格添加失败!",
																			icon:Ext.Msg.ERROR,
																			buttons:Ext.Msg.OK
																		});
															}
													 }
												});  
																		 	
																		 		
																		 	
																		 	
										}else{
											
											
											
												 var _record = new Ext.data.Record({
												 	'TPRowId':'',
												 	'TPPatInsType':Ext.getCmp("TPPatInsType1").getValue(),
												 	'TPPatInsTypeDesc':Ext.getCmp('TPPatInsType1').getRawValue(),
												 	'TPHospitalDR':Ext.getCmp("TPHospitalDR1").getValue(),
												 	'TPHospitalDRDesc':Ext.getCmp('TPHospitalDR1').getRawValue(),
												 	'TPAlterPrice1':Ext.getCmp("TPAlterPrice1").getValue(),
												 	'TPAlterPrice2':Ext.getCmp("TPAlterPrice2").getValue(),
												 	'TPPrice':Ext.getCmp("TPPrice").getValue(),
												 	'TPStartDate':Ext.getCmp("TPStartDate").getRawValue(),
												 	'TPEndDate':Ext.getCmp("TPEndDate").getRawValue()/*,
												 	'TPNoteText':Ext.getCmp("TPNoteText").getValue()*/
												 	
												 	
									    	 	});
									    	  
									    	 	//PriceGrid.stopEditing();
									    	 	PriceStore.insert(0,_record); 	
									    	 	var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
									    	 	Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
									    	 	var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
									    	 	Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
									    	 	//Ext.getCmp("TPPatInsType1").reset();
												Ext.getCmp("TPStartDate").setValue(TodayDate);
												
												Ext.getCmp("TPEndDate").reset();
												Ext.getCmp("TPPrice").setValue('');
												Ext.getCmp("TPAlterPrice1").reset();
												Ext.getCmp("TPAlterPrice2").reset();
												Ext.getCmp("TPEndDate").reset();
												//Ext.getCmp("TPNoteText").reset();
											 
										}
									 
									 
									}
							},/*
							{
		  						id:'btn_UpdatePriceEndDate',
		  						disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePriceEndDate'),
								text:'添加结束日期',
								iconCls : 'icon-update',
								handler:function(){
									
									if (!PriceGrid.selModel.hasSelection()) {
										
										Ext.Msg.show({
											title : '提示',
											msg : '请先选择一条价格！',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
									}
									if (Ext.getCmp("TPEndDate").getValue()==""){
									 	Ext.Msg.show({
														title:'提示',
														msg:"价格结束日期不能为空,请重新选择!",
														icon:Ext.Msg.ERROR,
														buttons:Ext.Msg.OK
													});
											return ;
									 }
									var tbenddateymd=Ext.getCmp("TPEndDate").getValue().format("Ymd");
							 	   	var TodayDateymd=(new Date()).format("Ymd");
							 	   	if (tbenddateymd <= TodayDateymd) {
							 			Ext.Msg.show({
												title : '提示',
												msg : '价格结束日期不允许早于等于今天！',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
										return;
							 	   	}
							 	   	
							 	   	//if (win.title=='修改')
							 	   	if (((win.title).indexOf("修改")>-1))
									{
									 			var gsm =PriceGrid.getSelectionModel();
												var rows = gsm.getSelections()
												
									 			var TPRowId=rows[0].get('TPRowId')
												var AddPriceStr = Ext.getCmp('TPPatInsType1').getValue()+'^'+Ext.getCmp('TPPrice').getValue()+'^'+Ext.getCmp('TPStartDate').getRawValue()+'^'+Ext.getCmp('TPEndDate').getRawValue()+'^'+Ext.getCmp('TPAlterPrice1').getValue()+'^'+Ext.getCmp('TPAlterPrice2').getValue()+'^'+Ext.getCmp('TPHospitalDR1').getValue()+'^'+TPRowId;   ///+'^'+Ext.getCmp('TPNoteText').getValue();
												
												
												Ext.Ajax.request({
													url:Price_SAVE_ACTION_URL,
													method:'POST',
													params:{
														'rowid':selectTARIRowId ,
														'AddPriceStr':AddPriceStr
													},
													callback:function(options, success, response){
														if(success){
															var jsonData = Ext.util.JSON.decode(response.responseText);
															if(jsonData.success == 'true'){
																Ext.Msg.show({
																			title:'提示',
																			msg:jsonData.info,
																			icon:Ext.Msg.INFO,
																			buttons:Ext.Msg.OK,
																			fn:function(btn){
																				PriceRefresh()
																	     		
																		}
																	});							
																}else{
																	Ext.Msg.show({
																				title:'提示',
																				msg:jsonData.errorinfo,
																				icon:Ext.Msg.ERROR,
																				buttons:Ext.Msg.OK
																			});
																	}
													  	  }else{
															  Ext.Msg.show({
																			title:'提示',
																			msg:"收费项价格结束日期添加失败!",
																			icon:Ext.Msg.ERROR,
																			buttons:Ext.Msg.OK
																		});
															}
													 }
												}); 						 	
										}
									 
									 
									}
							},*/
              {
								id:'btn_PriceRefresh',
								disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_PriceRefresh'),
								text:'重置',
								iconCls : 'icon-refresh',
								handler:PriceRefresh=function(){
											PriceGrid.getStore().baseParams={
												TARIRowId :  selectTARIRowId
											};
											PriceGrid.getStore().load();
											var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
											Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
											var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
											Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
											//Ext.getCmp('TPPatInsType1').setValue("")
								     		Ext.getCmp('TPPrice').setValue("")
								     		//if (win.title=='修改')
								     		if (((win.title).indexOf("修改")>-1))
											{
												Ext.getCmp("TPStartDate").setValue(TomorrowDate);	
											}
											else
											{
												Ext.getCmp("TPStartDate").setValue(TodayDate);
											}
								     		Ext.getCmp('TPEndDate').setValue("")
								     		Ext.getCmp('TPAlterPrice1').setValue("")
								     		Ext.getCmp('TPAlterPrice2').setValue("")
								     		//Ext.getCmp('TPNoteText').setValue("")
								     		
									}                 
							}]
					
		}); 
	
    var PricePanel=new Ext.Panel({
    	layout:'border',
     	region:'center',
     	width:600,
		height:500,
    	title:'收费项价格',
    	frame : true,  //解决新增重置按钮第二次点击弹窗会不显示的问题
    	items:[winPricePanel,PriceGrid]
    });
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 440,
				 region : 'center',
				 autoScroll:true,
			 	//resizeTabs:true,  
				tabWidth:65,
				animScroll:true,
				enableTabScroll:true,
				deferredRender :false,		//是否延迟渲染，缺省时为true， //解决新增重置按钮第二次点击弹窗会不显示的问题
				defaults:{autoScroll:true},
				items : [DHCTarItemPanel,PricePanel,AliasGrid]  //PriceStore
				,listeners : {
					tabchange : function(tp, p) {
						if (p.title!="收费项目")
						{
							if ((win.title).indexOf("添加")>-1) {
								win.setTitle('添加'+' '+Ext.getCmp("TARICode").getValue()+' '+Ext.getCmp("TARIDesc").getValue());
							}
							else if ((win.title).indexOf("收费项复制")>-1)
							{
								win.setTitle('收费项复制'+' '+Ext.getCmp("TARICode").getValue()+' '+Ext.getCmp("TARIDesc").getValue());
							}	
							else if ((win.title).indexOf("修改")>-1)
							{
								win.setTitle('修改'+' '+Ext.getCmp("TARICode").getValue()+' '+Ext.getCmp("TARIDesc").getValue());
							}
						}
					}
				}
	});
	
	
	var MultiAddPrice=function(rowid){
	 		 var AddPriceCount=PriceStore.getCount();
	 		 //alert(AddPriceCount)
	 		 if (AddPriceCount!=0){
	 		 		AddPriceStr="";
				    PriceStore.each(function(record){
						if(AddPriceStr!="") 
						{
							AddPriceStr = AddPriceStr+"&#";
						}
						var datefrom=record.get('TPStartDate'); 
						
						var dateto=record.get('TPEndDate');
						
						AddPriceStr = AddPriceStr+record.get('TPPatInsType')+'^'+record.get('TPPrice')+'^'+datefrom+'^'+dateto+'^'+record.get('TPAlterPrice1')+'^'+record.get('TPAlterPrice2')+'^'+record.get('TPHospitalDR')/*+'^'+record.get('TPNoteText');*/
				 
				  }, this);
 		 	} 
 		 	else{
 		 			AddPriceStr="";
 		 	}
		Ext.Ajax.request({
			url:Price_SAVE_ACTION_URL,
			method:'POST',
			params:{
				'rowid':rowid,
				'AddPriceStr':AddPriceStr
			}	
		});  
	}	
	///2018-11-27 根据屏幕大小，变化弹出窗口高度。
	try
	{
		if(parent.parent.$("#centerPanel")!=null&&parent.parent.$("#centerPanel")!=undefined)
	    {	
	    	var winheight=Math.min(parent.parent.$("#centerPanel").height()-20,820)
	    }
	    else
	    {
			var winheight=Math.min($(window).height()-20,820);
	    }
	}
	catch(e)  //2019-07-15 cache5.2.4识别不了
	{
		var winheight=Math.min($(window).height()-20,820);
	}
    // 添加修改时弹出窗口
	
	var win = new Ext.Window({
		title : '',
		width : 1070,  //弹窗第一次显示会有行距不一样的情况。
		minWidth:950,
		height: winheight,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() { 
				var activeflag=Ext.getCmp("TARIActiveFlag").getValue();
				
			   
			 	if ((Ext.getCmp("TARIStartDate").getValue() != "")&&(Ext.getCmp("TARIEndDate").getValue() != "")&&(Ext.getCmp("TARIStartDate").getValue() != null)&&(Ext.getCmp("TARIEndDate").getValue() != null)) {
			 		if (Ext.getCmp("TARIStartDate").getValue().format("Ymd") > Ext.getCmp("TARIEndDate").getValue().format("Ymd")) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '收费项开始日期不能大于结束日期！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
			   	}
				if (Ext.getCmp("SyncAddARCItmMast").collapsed==false)    ///不收缩 ，即同步添加医嘱项时 需要校验医嘱项数据  
				{
					
					if (Ext.getCmp("ARCIMCode").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱代码不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	var flag=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","FormValidate","",Ext.getCmp("ARCIMCode").getValue(),"",hospComp.getValue())
				 	if (flag==1)
				 	{
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱代码已存在,请重新输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 		
				 	}
				 	
				 	if (Ext.getCmp("ARCIMDesc").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱名称不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	var flag=  tkMakeServerCall("web.DHCBL.CT.ARCItmMast","FormValidate","","",Ext.getCmp("ARCIMDesc").getValue(),hospComp.getValue())
				 	if (flag==1)
				 	{
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱名称已存在,请重新输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 		
				 	}
				 	if (Ext.getCmp("TARIUOM1").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"收费项目单位不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	if (Ext.getCmp("ARCIMItemCatDR1").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱子分类不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
					if (Ext.getCmp("ARCIMBill1").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱项账单组不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	if (Ext.getCmp("ARCIMBillSubDR1").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱项账单子组不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	/*if (Ext.getCmp("ARCIMDefPriorityDR1").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱优先级不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}*/
				 	
				 	if (Ext.getCmp("ARCIMEffDate").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"医嘱项开始日期不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	
				 	
				 	
				 	if ((Ext.getCmp("ARCIMEffDate").getValue() != "")&&(Ext.getCmp("ARCIMEffDateTo").getValue() != "")&&(Ext.getCmp("ARCIMEffDate").getValue() != null)&&(Ext.getCmp("ARCIMEffDateTo").getValue() != null)) {
				 		if (Ext.getCmp("ARCIMEffDate").getValue().format("Ymd") > Ext.getCmp("ARCIMEffDateTo").getValue().format("Ymd")) {
	        				Ext.Msg.show({
	        					title : '提示',
								msg : '医嘱项开始日期不能大于医嘱项结束日期！',
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
	          			 	return;
	      				}
				   	}
				   	
				   	
				 	if (Ext.getCmp("OLTQty").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"收费项关联医嘱项,数量不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	
				 
				 	if (Ext.getCmp("OLTStartDate").getValue()=="") {
				 		 Ext.Msg.show({
										title:'提示',
										msg:"收费项关联医嘱项,关联开始日期不能为空,请输入!",
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
				 		 return;
				 	}
				 	
				 	
				 	if ((Ext.getCmp("OLTStartDate").getValue() != "")&&(Ext.getCmp("OLTEndDate").getValue() != "")&&(Ext.getCmp("OLTStartDate").getValue() != null)&&(Ext.getCmp("OLTEndDate").getValue() != null)) {
				 		if (Ext.getCmp("OLTStartDate").getValue().format("Ymd") > Ext.getCmp("OLTEndDate").getValue().format("Ymd")) {
	        				Ext.Msg.show({
	        					title : '提示',
								msg : '关联医嘱项开始日期不能大于结束日期！',
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
	          			 	return;
	      				}
				   	}
				   	
				   	
				}
				
				
				
				if (Ext.getCmp("TARICode").getValue()=="") {
			 		 Ext.Msg.show({
									title:'提示',
									msg:"收费项代码不能为空,请输入!",
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
			 		 return;
			 	}
			 	var flag=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","FormValidate",Ext.getCmp("TARIRowId").getValue(),Ext.getCmp("TARICode").getValue(),"",hospComp.getValue())
			 	if (flag==1)
			 	{
			 		 Ext.Msg.show({
									title:'提示',
									msg:"收费项代码已存在,请重新输入!",
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
			 		 return;
			 		
			 	}
			 	
			 	if (Ext.getCmp("TARIDesc").getValue()=="") {
			 		 Ext.Msg.show({
									title:'提示',
									msg:"收费项名称不能为空,请输入!",
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
			 		 return;
			 	}
			 	var flag=  tkMakeServerCall("web.DHCBL.CT.DHCTarItem","FormValidate",Ext.getCmp("TARIRowId").getValue(),"",Ext.getCmp("TARIDesc").getValue(),hospComp.getValue())
			 	if (flag==1)
			 	{
			 		 Ext.Msg.show({
									title:'提示',
									msg:"收费项名称已存在,请重新输入!",
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
			 		 return;
			 		
			 	}
			 	
			 	
				if (DHCTarItemPanel.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据是否有误！');
					 return;
				}
				//-------添加----------	
        			//if ((win.title == "添加")||(win.title == "收费项复制")) {
				if (((win.title).indexOf("添加")>-1)||((win.title).indexOf("收费项复制")>-1)) {
					
					
					///2020-01-03 没有维护价格的数据进行提醒，以防漏维护价格。
					var count=PriceStore.getCount()  //getTotalCount();
					if (count==0)
					{
						Ext.MessageBox.confirm('提示', '新增收费项目还没有维护价格，确定要保存数据吗?', function(btn) {
							if (btn == 'yes') {
								//WinForm.form.isValid()
								DHCTarItemPanel.form.submit({
									url : SAVE_ACTION_URL,
									clientValidation : true,
									waitTitle : '提示',
									method : 'POST',
									params : {									   ///多院区医院
										'LinkHospId' :hospComp.getValue()           
									},
									success : function(form, action) {
										if (action.result.success == 'true') {
											
											var myrowid = action.result.id;
											//var myrowid = jsonData.id;
											///批量保存价格
											MultiAddPrice(myrowid);
											//添加时 同时保存别名
											AliasGrid.TIATARIDR = myrowid;
											AliasGrid.saveAlias();
											
											if (Ext.getCmp("SyncAddARCItmMast").collapsed==false)    ///不收缩 ，即同步添加医嘱项时 需要校验医嘱项数据  
											{
												
												var ArcItmMastStr=Ext.getCmp("ARCIMCode").getValue()+"^"+Ext.getCmp("ARCIMDesc").getValue()+"^"+Ext.getCmp("ARCIMBillingUOMDR").getValue()+"^"+Ext.getCmp("ARCIMItemCatDR1").getValue()+"^"+Ext.getCmp("ARCIMBillSubDR1").getValue();
												ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMDefPriorityDR1").getValue()+"^"+Ext.getCmp("ARCIMOrderOnItsOwn").getValue()+"^"+Ext.getCmp("ARCIMAllowOrderWOStockCheck").getValue()+"^"+Ext.getCmp("ARCIMSensitive").getValue()+"^"+Ext.getCmp("ARCIMEffDate").getRawValue()
												ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMEffDateTo").getRawValue()+"^"+Ext.getCmp("ARCIMAlias").getValue()+"^"+hospComp.getValue()+"^"+Ext.getCmp("ARCIMAbbrev").getValue()+"^"+Ext.getCmp("ARCIMOEMessage").getValue();
												ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMServMaterial").getValue()+"^"+Ext.getCmp("ARCIMDefSensitive").getValue();
												var AddOrdLinkTar=Ext.getCmp("OLTQty").getValue()+"^"+Ext.getCmp("OLTStartDate").getRawValue()+"^"+Ext.getCmp("OLTEndDate").getRawValue();
												var saveMast=  tkMakeServerCall("web.DHCBL.CT.DHCTarItem","SyncAddARCItmMast",ArcItmMastStr,myrowid,AddOrdLinkTar);
												
											}
											
											/*
											 //ofy1河南省人民医院 新增收费项目和医嘱项时，将收费项目代码同步到收费项别名和医嘱项别名里 
											 var TARICode=Ext.getCmp("TARICode").getValue();
											var saveCodeToAlias=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","SyncAlias",TARICode,myrowid);
											*/
											win.hide();
											Ext.Msg.show({
													title : '提示',
													msg : '添加成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														
														
														
														grid.getStore().load({
																	params : {
																		start : 0,
																		limit : pagesize,
																		rowid : myrowid
																	}/*,
																	callback : function(records, options, success) {  ///ofy7南方医院  添加完收费项数据后不关闭窗口
																		if (success) {
																			grid.getSelectionModel().selectFirstRow();  
																			win.hide()
																			UpdateData()
																			
																		}
																		
																	}*/
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
							else
							{
								tabs.setActiveTab(1);
							}
						})
					}
					else
					{
						//WinForm.form.isValid()
								DHCTarItemPanel.form.submit({
									url : SAVE_ACTION_URL,
									clientValidation : true,
									waitTitle : '提示',
									method : 'POST',
									params : {									   ///多院区医院
										'LinkHospId' :hospComp.getValue()           
									},
									success : function(form, action) {
										if (action.result.success == 'true') {
											
											var myrowid = action.result.id;
											//var myrowid = jsonData.id;
											///批量保存价格
											MultiAddPrice(myrowid);
											//添加时 同时保存别名
											AliasGrid.TIATARIDR = myrowid;
											AliasGrid.saveAlias();
											
											if (Ext.getCmp("SyncAddARCItmMast").collapsed==false)    ///不收缩 ，即同步添加医嘱项时 需要校验医嘱项数据  
											{
												
												var ArcItmMastStr=Ext.getCmp("ARCIMCode").getValue()+"^"+Ext.getCmp("ARCIMDesc").getValue()+"^"+Ext.getCmp("ARCIMBillingUOMDR").getValue()+"^"+Ext.getCmp("ARCIMItemCatDR1").getValue()+"^"+Ext.getCmp("ARCIMBillSubDR1").getValue();
												ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMDefPriorityDR1").getValue()+"^"+Ext.getCmp("ARCIMOrderOnItsOwn").getValue()+"^"+Ext.getCmp("ARCIMAllowOrderWOStockCheck").getValue()+"^"+Ext.getCmp("ARCIMSensitive").getValue()+"^"+Ext.getCmp("ARCIMEffDate").getRawValue()
												ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMEffDateTo").getRawValue()+"^"+Ext.getCmp("ARCIMAlias").getValue()+"^"+hospComp.getValue()+"^"+Ext.getCmp("ARCIMAbbrev").getValue()+"^"+Ext.getCmp("ARCIMOEMessage").getValue();
												ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMServMaterial").getValue()+"^"+Ext.getCmp("ARCIMDefSensitive").getValue();
												var AddOrdLinkTar=Ext.getCmp("OLTQty").getValue()+"^"+Ext.getCmp("OLTStartDate").getRawValue()+"^"+Ext.getCmp("OLTEndDate").getRawValue();
												var saveMast=  tkMakeServerCall("web.DHCBL.CT.DHCTarItem","SyncAddARCItmMast",ArcItmMastStr,myrowid,AddOrdLinkTar);
												
											}
											
											/*
											 //ofy1河南省人民医院 新增收费项目和医嘱项时，将收费项目代码同步到收费项别名和医嘱项别名里 
											 var TARICode=Ext.getCmp("TARICode").getValue();
											var saveCodeToAlias=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","SyncAlias",TARICode,myrowid);
											*/
											win.hide();
											Ext.Msg.show({
													title : '提示',
													msg : '添加成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														
														
														
														grid.getStore().load({
																	params : {
																		start : 0,
																		limit : pagesize,
																		rowid : myrowid
																	}/*,
																	callback : function(records, options, success) {  ///ofy7南方医院  添加完收费项数据后不关闭窗口
																		if (success) {
																			grid.getSelectionModel().selectFirstRow();  
																			win.hide()
																			UpdateData()
																			
																		}
																		
																	}*/
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
				} 
				//---------修改-------
				else {
					
				
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							DHCTarItemPanel.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										//修改时 先保存别名
										AliasGrid.saveAlias();
										
										
										win.hide();     ///ofy7南方医院  修改完收费项数据后不关闭窗口
										Ext.Msg.show({
												title : '提示',
												msg : '修改成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													if (grid.selModel.hasSelection()) {
														var gsm = grid.getSelectionModel();// 获取选择列
														var rows = gsm.getSelections();// 根据选择列获取到所有的行
														var gridactiveflag=rows[0].get('TARIActiveFlag')
														////把收费项的有效修改为无效时触发
														//if ((activeflag==false)&&(gridactiveflag=="Y"))
														if (((activeflag==false)||(Ext.getCmp("TARIEndDate").getRawValue()!=""))&&(gridactiveflag=="Y"))
														{
															var gsm = grid.getSelectionModel();// 获取选择列
															var rows = gsm.getSelections();// 根据选择列获取到所有的行
															LinkedArcimds.baseParams={
																TarRowid:rows[0].get('TARIRowId')
															};
															LinkedArcimds.load({
																	params : {
																			start : 0,
																			limit : pagesize_pop
																		}
																});
															LinkedArcimlist_win.setTitle(rows[0].get('TARIDesc')+'-----关联医嘱项');
															LinkedArcimlist_win.show();
														}
													}
													var myrowid = "rowid="+action.result.id+"&hospid="+hospComp.getValue();
													Ext.BDP.FunLib.ReturnDataForUpdate("grid",GetList_ACTION_URL,myrowid)
												}
										});
										
										
										
										///原龙岩二院需求	ofy2
										/*if (activeflag==false)
										{
											var tarirowid=action.result.id;
											var LARCIMRowId=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetARCIMRowIdByTarid",tarirowid)
											if (LARCIMRowId!="")  //只有一条医嘱项与这条收费项关联的时候 ，才停止该医嘱项  日期为当天
											{
												var EndARCIMRst=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","EndPatInsType",LARCIMRowId)
												if (EndARCIMRst.indexOf("false")>=0)
												{
													Ext.Msg.show({
															title : '提示',
															msg : '停用医嘱项失败，请在医嘱项维护页面维护医嘱项的结束日期！',
															icon : Ext.Msg.INFO,
															buttons : Ext.Msg.OK
														});
												}
												else
												{
														
													Ext.Msg.show({
														title : '提示',
														msg : '已将与这条收费项关联的医嘱项停用，请在医嘱项维护页面核实！',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK
													});
												}
											}
										}
										else
										{
											Ext.Msg.show({
												title : '提示',
												msg : '修改成功！',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK
										});
										
										}
										*/
										
										
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
		listeners : {
			"show" : function() {
				Ext.getCmp("DHCTarItemPanel").getForm().findField("TARICode").focus(true,300);
				Ext.getCmp("SyncAddARCItmMast").checkbox.dom.disabled = false;
				
				//Ext.getCmp("SSUSRInitials").focus(true,500);
				Ext.getCmp("SyncAddARCItmMast").collapse();
				//if(win.title=='修改'){	
				if (((win.title).indexOf("修改")>-1))	
				{			
					Ext.getCmp("SyncAddARCItmMast").checkbox.dom.disabled = true;
					//Ext.getCmp("SyncAddARCItmMast").collapse();
					
					
					///Ext.getCmp("SyncAddARCItmMast").collapse();
					//Ext.getCmp("SyncAddARCItmMast").expand();
				}
				else{
					//Ext.getCmp("SyncAddARCItmMast").expand();	  默认勾选 同步生成医嘱项
				
				}
			},
			"hide" : function() {
				
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				/*treeCombox.hideTree();*/
				//WinForm.getForm().reset();
				//Ext.getCmp("CTProvSet").collapse();
			},
			"close" : function() {
			}
		}
	}); 
	
	
	
  

	
//————————————————————————————————————————————————查询条件————————————————————————————————————————		
	var fields=[{
								name : 'TARIRowId',
								mapping : 'TARIRowId',
								type : 'number'
							}, {
								name : 'TARICode',
								mapping : 'TARICode',
								type : 'string'
							}, {
								name : 'TARIDesc',
								mapping : 'TARIDesc',
								type : 'string'
							}, {
								name : 'TARIUOM',
								mapping : 'TARIUOM',
								type : 'string'
							}, {
								name : 'TARIUOMID',
								mapping : 'TARIUOMID',
								type : 'string'
							}, {
								name : 'TARISubCate',
								mapping : 'TARISubCate',
								type : 'string'
							}, {
								name : 'TARISubCateID',
								mapping : 'TARISubCateID',
								type : 'string'
							}, {
								name : 'TARIAcctCate',
								mapping : 'TARIAcctCate',
								type : 'string'
							}, {
								name : 'TARIAcctCateID',
								mapping : 'TARIAcctCateID',
								type : 'string'
							}, {
								name : 'TARIOutpatCate',
								mapping : 'TARIOutpatCate',
								type : 'string'
							
							}, {
								name : 'TARIOutpatCateID',
								mapping : 'TARIOutpatCateID',
								type : 'string'
							}, {
								name : 'TARIInpatCate',
								mapping : 'TARIInpatCate',
								type : 'string'
							}, {
								name : 'TARIInpatCateID',
								mapping : 'TARIInpatCateID',
								type : 'string'
							}, {
								name : 'TARIEMCCate',
								mapping : 'TARIEMCCate',
								type : 'string'
							}, {
								name : 'TARIEMCCateID',
								mapping : 'TARIEMCCateID',
								type : 'string'
							}, {
								name : 'TARIMRCate',
								mapping : 'TARIMRCate',
								type : 'string'
							}, {
								name : 'TARIMRCateID',
								mapping : 'TARIMRCateID',
								type : 'string'
								
							}, {
								name : 'TARIMCNew',
								mapping : 'TARIMCNew',
								type : 'string'
							}, {
								name : 'TARIMCNewID',
								mapping : 'TARIMCNewID',
								type : 'string'
							}, {
								name : 'TARIInsuName',
								mapping : 'TARIInsuName',
								type : 'string'
							}, {
								name : 'TARIInsuCode',
								mapping : 'TARIInsuCode',
								type : 'string'
							}, {
								name : 'TARIOPERCategoryDR',
								mapping : 'TARIOPERCategoryDR',
								type : 'string'	
							}, {
								name : 'TARIConnote',
								mapping : 'TARIConnote',
								type : 'string'
							}, {
								name : 'TARIRemark',
								mapping : 'TARIRemark',
								type : 'string'
							}, {
								name : 'TARIExclude',
								mapping : 'TARIExclude',
								type : 'string'
							}, {
								name : 'TARIPriceRemark',
								mapping : 'TARIPriceRemark',
								type : 'string'
							}, {
								name : 'TARIExternalCode',
								mapping : 'TARIExternalCode',
								type : 'string'
							}, {
								name : 'TARIChargeBasis',
								mapping : 'TARIChargeBasis',
								type : 'string'
							}, {
								name : 'TARIEngName',
								mapping : 'TARIEngName',
								type : 'string'
							}, {
								name : 'TARISpecialFlag',
								mapping : 'TARISpecialFlag',
								type : 'string'
							}, {
								name : 'TARIActiveFlag',
								mapping : 'TARIActiveFlag',
								type : 'string'
							}, {
								name : 'TARIStartDate',
								mapping : 'TARIStartDate',
								type : 'string'
							}, {
								name : 'TARIEndDate',
								mapping : 'TARIEndDate',
								type : 'string'
							}, {
								name : 'TARIItemCatDR',
								mapping : 'TARIItemCatDR',
								type : 'string'
								
							}, {
								name : 'TariPrice',
								mapping : 'TariPrice',
								type : 'string'
								
								  
							}, {
								name : 'TARIItemCatDRID',
								mapping : 'TARIItemCatDRID',
								type : 'string'
							}, {
								name : 'TARIPriceCode',
								mapping : 'TARIPriceCode',
								type : 'string'
							}, {
								name : 'TARIPriceDesc',
								mapping : 'TARIPriceDesc',
								type : 'string'
							}, {
								name : 'TARISpecialProcurementFlag',
								mapping : 'TARISpecialProcurementFlag',
								type : 'string'
							}, {
								name : 'TARIRepeatedChargeFlag',
								mapping : 'TARIRepeatedChargeFlag',
								type : 'string'
							}, {
								name : 'TARIManufactorType',  //进口标志
								mapping : 'TARIManufactorType',
								type : 'string'
							
							}
						]
	var TarItemInfoStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : GetList_ACTION_URL}),
				remoteSort : true,
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
				
	});
	Ext.BDP.AddReaderFieldFun(TarItemInfoStore,fields,Ext.BDP.FunLib.TableName);	
	
	
	
	
	// 分页工具条
	var TarItemInfoToolbar = new Ext.PagingToolbar({
				pageSize : pagesize,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				store : TarItemInfoStore,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录"
	});
		
	
	
	 var btnAdd = new Ext.Toolbar.Button({
    		text : '添加',
			id:'add_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
			tooltip : '添加',
			iconCls : 'icon-add',
			handler : AddData=function () {
				Ext.getCmp("DHCTarItemPanel").getForm().reset();
				var treetype=Ext.getCmp("TypeF").getValue();
				
				DHCTarItemPanel.form.load( {
	                url : ADD_OPEN_ACTION_URL + '&HiddenCat='+ HiddenCat+'&type='+ treetype+'&rowid=',
	                success : function(form,action) {
	                	//Ext.Msg.alert('提示','载入成功！');
	                	treeCombox.root.reload();
						if (treetype=="ItemCat")
						{
							//treeCombox.treePanel.load()
							
							Ext.getCmp("treeCombox").setValue(HiddenCat);
							Ext.getCmp("treeCombox").setRawValue(HiddenCaption);
						}
						else
						{
							Ext.getCmp("treeCombox").setValue("");
							Ext.getCmp("treeCombox").setRawValue("");
						}
						Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIStartDate').setValue(TodayDate);
						//20170811 自动生成代码
						var flag= tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetAutoCreateFlag",hospComp.getValue())
						if (flag==1)
						{
							var MaxCode = tkMakeServerCall("web.DHCBL.CT.DHCTarItem","AutoCreateCode",Ext.getCmp("treeCombox").getValue()+"^0",hospComp.getValue());
							Ext.getCmp("TARICode").setValue(MaxCode)
						}
	                },
	                failure : function(form,action) {
	                	//Ext.Msg.alert('提示','载入失败！');
	                }
	       		});
				
				Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIActiveFlag').setValue(true);
				Ext.getCmp('ARCIMOrderOnItsOwn').setValue(true);
				
				Ext.getCmp("ARCIMCode").setValue("");
				var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
				if (flag==1)
				{
					var Type = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateType",hospComp.getValue());
					if (Type=="")
					{
						Ext.getCmp("ARCIMCode").setValue(Ext.getCmp("TARICode").getValue());
					}
					if (Type=="F")
					{
						var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode","^^0",hospComp.getValue());
						if (MaxCode!="") Ext.getCmp("ARCIMCode").setValue(MaxCode) 
					}
					if ((Type=="O")||(Type=="OA")||(Type=="A"))   ///类型为OA A O时， 不先把收费项代码带过来，当选了医嘱子分类才带过来
					{
						var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode","^"+Ext.getCmp("ARCIMItemCatDR1").getValue()+"^1",hospComp.getValue());
						if(MaxCode!="") Ext.getCmp("ARCIMCode").setValue(MaxCode)
						
					}
				}
				
				
				Ext.getCmp("ARCIMDesc").setValue("");
				Ext.getCmp('ARCIMItemCatDR1').setValue("");
				Ext.getCmp("ARCIMDefPriorityDR1").setValue("");
				Ext.getCmp("ARCIMDefPriorityDR1").setRawValue("");
				Ext.getCmp("ARCIMEffDateTo").setValue("");
				Ext.getCmp("ARCIMAllowOrderWOStockCheck").setValue(true);
				Ext.getCmp("ARCIMSensitive").setValue(false);
				Ext.getCmp("ARCIMOrderOnItsOwn").setValue(true);
				Ext.getCmp('ARCIMEffDate').setValue(TodayDate);
				Ext.getCmp("ARCIMBill1").setValue("");
				Ext.getCmp("ARCIMBillSubDR1").setValue("");
				Ext.getCmp("ARCIMAlias").setValue("");
				Ext.getCmp("OLTQty").setValue("1");
				Ext.getCmp("OLTStartDate").setValue(TodayDate);
				Ext.getCmp("OLTEndDate").setValue("");
				var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
				Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
				var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
				Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
				//Ext.getCmp('TPPatInsType1').setValue("")
     			Ext.getCmp('TPPrice').setValue("")
     			Ext.getCmp('TPStartDate').setValue(TodayDate)
     			Ext.getCmp('TPEndDate').setValue("")
     			Ext.getCmp('TPAlterPrice1').setValue("")
     			Ext.getCmp('TPAlterPrice2').setValue("")
     			//Ext.getCmp('TPNoteText').setValue("")
     			Ext.getCmp('ARCIMBillingUOMDR').setValue("");
     			Ext.getCmp('ARCIMAbbrev').setValue("");
     			Ext.getCmp('ARCIMOEMessage').setValue("");
     			Ext.getCmp('ARCIMServMaterial').setValue("");
     			Ext.getCmp('ARCIMDefSensitive').setValue("");
     			
												
				win.setTitle('添加');
				win.setIconClass('icon-add');
				win.show();
				
				//清空别名面板grid
	            AliasGrid.TIATARIDR = "";
	            AliasGrid.clearGrid();
				PriceGrid.getStore().baseParams={
					TARIRowId :  ""
				};
				PriceGrid.getStore().load();
	           	selectTARIRowId=""
				//激活基本信息面板
	            tabs.setActiveTab(0);
	            
	            //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
		        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"DHC_TarItem");
		        if (InsuConfig=="INSU")
		        {
		        	Ext.getCmp("TARIInsuCode").setDisabled(true);
		        	Ext.getCmp("TARIInsuName").setDisabled(true);
		        }
		        else
		        {
			        Ext.getCmp("TARIInsuCode").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuCode'));
		        	Ext.getCmp("TARIInsuName").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuName'));
		        }
	            //Ext.getCmp('btn_UpdatePriceEndDate').disable();
   		}
	 });
	  var btnEditwin = new Ext.Toolbar.Button({
    	text : '修改',
		tooltip : '修改',
		iconCls : 'icon-update',
    	id:'update_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
   		handler: UpdateData=function () {
				
   			
   				if(grid.selModel.hasSelection()){
	                	
						
						loadFormData(grid);
						
				        
				       
	                }else{
	                	Ext.Msg.show({
										title:'提示',
										msg:'请选择需要修改的行!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
	               		 }
   			
   			
				
   		}
	 });
	 
	 
	 
	   
	 var btnCopy = new Ext.Toolbar.Button({
    		text : '收费项复制',
			id:'copy_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('copy_btn'),
			tooltip : '收费项复制',
			iconCls : 'icon-add',
			handler : CopyData=function () {
				
				
   				if(grid.selModel.hasSelection()){
   					
   					    var rows =grid.getSelectionModel().getSelections();
     					var rowid=rows[0].get('TARIRowId')
						var treetype=Ext.getCmp("TypeF").getValue();
						
						DHCTarItemPanel.form.load( {
			                url : ADD_OPEN_ACTION_URL + '&HiddenCat='+ HiddenCat+'&type='+ treetype+'&rowid='+ rowid,
			                success : function(form,action) {
			                	//Ext.Msg.alert('提示','载入成功！');
			                	treeCombox.root.reload();
			                	
								Ext.getCmp("treeCombox").setValue(rows[0].get('TARIItemCatDRID'));
								Ext.getCmp("treeCombox").setRawValue(rows[0].get('TARIItemCatDR'));
								var flag= tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetAutoCreateFlag",hospComp.getValue())
								if (flag==1)
								{
									var MaxCode = tkMakeServerCall("web.DHCBL.CT.DHCTarItem","AutoCreateCode",Ext.getCmp("treeCombox").getValue()+"^0",hospComp.getValue());
									Ext.getCmp("TARICode").setValue(MaxCode)
								}
			                },
			                failure : function(form,action) {
			                	//Ext.Msg.alert('提示','载入失败！');
			                }
			       		});
			       		
						Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIActiveFlag').setValue(true);
						Ext.getCmp('ARCIMOrderOnItsOwn').setValue(true);
						//Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIItemCatDR').setValue(itemcatdrid);
						//Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIItemCatDR').setRawValue(itemcatdrdesc);
						
						
						
						//Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIStartDate').setValue(TodayDate);
						
						Ext.getCmp("TARIDesc").setValue("")
						Ext.getCmp("ARCIMCode").setValue("");
						Ext.getCmp("ARCIMDesc").setValue("");
						Ext.getCmp('ARCIMItemCatDR1').setValue("");
						Ext.getCmp("ARCIMDefPriorityDR1").setValue("");
						Ext.getCmp("ARCIMDefPriorityDR1").setRawValue("");
						Ext.getCmp("ARCIMEffDateTo").setValue("");
						Ext.getCmp("ARCIMAllowOrderWOStockCheck").setValue(true);
						Ext.getCmp("ARCIMSensitive").setValue(false);
						Ext.getCmp("ARCIMOrderOnItsOwn").setValue(true);
						Ext.getCmp('ARCIMEffDate').setValue(TodayDate);
						Ext.getCmp("ARCIMBill1").setValue("");
						Ext.getCmp("ARCIMBillSubDR1").setValue("");
						Ext.getCmp("ARCIMAlias").setValue("");
						Ext.getCmp("OLTQty").setValue("1");
						Ext.getCmp("OLTStartDate").setValue(TodayDate);
						Ext.getCmp("OLTEndDate").setValue("");
						var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
						Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
						var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
						Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
						//Ext.getCmp('TPPatInsType1').setValue("")
		     			Ext.getCmp('TPPrice').setValue("")
		     			Ext.getCmp('TPStartDate').setValue(TodayDate)
		     			Ext.getCmp('TPEndDate').setValue("")
		     			Ext.getCmp('TPAlterPrice1').setValue("")
		     			Ext.getCmp('TPAlterPrice2').setValue("")
		     			//Ext.getCmp('TPNoteText').setValue("")
		     			Ext.getCmp('ARCIMBillingUOMDR').setValue("");
		     			Ext.getCmp('ARCIMAbbrev').setValue("");
		     			Ext.getCmp('ARCIMOEMessage').setValue("");
		     			Ext.getCmp('ARCIMServMaterial').setValue("");
		     			Ext.getCmp('ARCIMDefSensitive').setValue("");
		     			
		     			win.setTitle('收费项复制');
						win.setIconClass('icon-add');
						win.show();
						
						//清空别名面板grid
			            AliasGrid.TIATARIDR = "";
			            AliasGrid.clearGrid();
						PriceGrid.getStore().baseParams={
							TARIRowId :  ""
						};
						PriceGrid.getStore().load();
			           	selectTARIRowId=""
						//激活基本信息面板
			            tabs.setActiveTab(0);
			            //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
				        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"DHC_TarItem");
				        if (InsuConfig=="INSU")
				        {
				        	Ext.getCmp("TARIInsuCode").setDisabled(true);
				        	Ext.getCmp("TARIInsuName").setDisabled(true);
				        }
				        else
				        {
					        Ext.getCmp("TARIInsuCode").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuCode'));
				        	Ext.getCmp("TARIInsuName").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuName'));
				        }
			           // Ext.getCmp('btn_UpdatePriceEndDate').disable();
	            
	              }else{
	                	Ext.Msg.show({
										title:'提示',
										msg:'请选择需要复制的行!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
	               		 }
   		}
	 });
		 
	
	 
	 
	 // grid工具栏重置按钮
	var btnRefresh = new Ext.Toolbar.Button({
		text : '重置',
		id : 'btnRefresh',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
		tooltip : '重置查询某个类别下的收费项',
		iconCls : 'icon-refresh',
		handler : ClearAll=function() {
			
			Ext.getCmp("TextCode").setValue("");
			Ext.getCmp("TextDesc").setValue("");
			Ext.getCmp("TextAlias").setValue("");
			
			Ext.getCmp("tbUOM").setValue("");
			Ext.getCmp("TextExternalCode").setValue("");
			Ext.getCmp("TextChargeBasis").setValue("");
			Ext.getCmp("TextPrice1").setValue("");
			Ext.getCmp("TextPrice2").setValue("");
			Ext.getCmp("TbStartDate1").setValue("");
			Ext.getCmp("TbStartDate2").setValue("");
			Ext.getCmp("tbActiveFlag").setValue("");
			
			Ext.getCmp("tbItemType").setValue("");
			Ext.getCmp("TextInsuCode").setValue("");
			Ext.getCmp("tbInsuCodeMapedFlag").setValue("");
			var ExpParams=getExpParams();
			
			TarItemInfoStore.baseParams={
				ExpParams:ExpParams,
	   			hospid:hospComp.getValue()   //多院区医院
					
			}
			TarItemInfoStore.sort('TARIRowId', 'ASC');  //重置时，默认还是按照rowid排序 2019-09-20
			TarItemInfoStore.load({params:{start:0, limit:pagesize}});
			
			
		}
	});
	
	
	
	 var btnInsu = new Ext.Toolbar.Button({
    	text : '医保目录对照',
		tooltip : '医保目录对照',
		iconCls : 'icon-similar',
    	id:'Insu_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('Insu_btn'),
   		handler: function () {
				if(grid.selModel.hasSelection()){
				      	var rows = grid.getSelectionModel().getSelections();   
     					var taricode1=rows[0].get('TARICode');
     					var Insupanel =  new Ext.Window({
			                region:'center',
			                closeAction : 'hide',
			               	width:Ext.getBody().getViewSize().width-20,
							height:Ext.getBody().getViewSize().height-20,
							layout : 'fit',
							title:'医保目录对照',
							plain : true,
							modal : true,
							frame : true,
							collapsible : true,
							hideCollapseTool : true,
							titleCollapse : true,
							html :'',
			                //margins:'0 5 5 0',
			                //tabWidth:150
			                /* items:[{
			                	html : "<iframe frameborder='0' scrolling='auto' height='100%'  width='100%' src='insutarcontrast.csp?TarCode="+taricode1+"'></iframe>"
			                	///ofy5 安徽省立  调用老的医保目录页面(组件)
			                	///html : "<iframe frameborder='0' scrolling='auto' height='510px' width='100%' src='websys.default.csp?WEBSYS.TCOMPONENT=INSUTarContrastCom&InsuTypeFlag=HF&nhflag=0'></iframe>
			                }],*/
							listeners : {
								"show" : function() {
									
								},
								"hide" : function() {
									
								},
								"close" : function() {
								}
							}
						});
						var url="insutarcontrast.csp?TarCode="+taricode1+"&HospId="+hospComp.getValue()
						if ('undefined'!==typeof websys_getMWToken){
							url += "&MWToken="+websys_getMWToken()
						}
						Insupanel.html="<iframe frameborder='0' scrolling='auto' height='100%'  width='100%' src='"+url+"'></iframe>";
						Insupanel.show()
	                }else{
	                	Ext.Msg.show({
										title:'提示',
										msg:'请先选择收费项!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
	               		 }
				
   		}
	 });
	/*
	//调用外部网址
	 var btnWZ = new Ext.Toolbar.Button({
    	text : '第三方物资系统',
		iconCls : 'icon-similar',
    	id:'WZ_btn2',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('WZ_btn2'),
   		handler: function () {
				
		      	var WZpanel =  new Ext.Window({
	                region:'center',
	                closeAction : 'hide',
	               	width:Ext.getBody().getViewSize().width-80,
					height:Ext.getBody().getViewSize().height-80,
					layout : 'fit',
					title:'第三方物资系统',
					plain : true,
					modal : true,
					frame : true,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					items:[{
                                xtype:"panel",
                                id:"index",
                                iconCls:"homemanage",
                                title:"",
                                html:"<iframe src='http://www.baidu.com' scrolling='yes' frameborder=0 width=100% height=100%></iframe>"
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
				WZpanel.show()
	                
   		}
	 });
	*/
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});
	
	
	
	// 搜索按钮
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : search=function() {
					
					var ExpParams=getExpParams();
					TarItemInfoStore.baseParams={
							code:Ext.getCmp("TextCode").getValue(),
							desc:Ext.getCmp("TextDesc").getValue(),
							alias:Ext.getCmp("TextAlias").getValue(),
							ExpParams:ExpParams,
							hospid:hospComp.getValue()  //多院区医院
					};
			        TarItemInfoStore.load({
			        	params:{
			        		start:0, 
			        		limit:pagesize
			        	}});
				}
			})
	
	
	///ofy10
	/*
	var InsType_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarItemLocInstype&pClassQuery=GetList";
	var CT_LOC_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1"; //RowID
	var InsType_SAVE_ACTION_URL = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarItemLocInstype&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCTarItemLocInstype';
	var InsType_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItemLocInstype&pClassMethod=OpenData";
	var InsType_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItemLocInstype&pClassMethod=DeleteData";
	
	
	var PatInsTypeds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : InsType_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'LOCITRowId',
									mapping : 'LOCITRowId',
									type : 'string'
								
								}, {
									name : 'LOCITParRef',
									mapping : 'LOCITParRef',
									type : 'string'
								}, {
									name : 'LOCITPatInsType',
									mapping : 'LOCITPatInsType',
									type : 'string'
								}, {
									name : 'LOCITLocDR',
									mapping : 'LOCITLocDR',
									type : 'string'
								}, {
									name : 'LOCITStartDate',
									mapping : 'LOCITStartDate',
									type : 'string'
								}, {
									name : 'LOCITEndDate',
									mapping : 'LOCITEndDate',
									type : 'string'
								}, {
									
									name : 'LOCITUploadFlag',
									mapping : 'LOCITUploadFlag',
									type : 'string'
								
								}// 列的映射
						])
			});

			
	var PatInsTypepaging= new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : PatInsTypeds,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					})	
	 
	var PatInsTypesm = new Ext.grid.CheckboxSelectionModel({  
		    singleSelect : false,
			//checkOnly : false,
			width : 20,  
		    listeners:{  
		        selectionchange:function(s){ 
		        	 var selectedCount = s.getCount();
		        	 if (selectedCount==0) { 
		        	 	///重新加载后 不会去掉全选的勾  2017-05-08
		             	InsTypegrid.getEl().select('div.x-grid3-hd-checker').removeClass('x-grid3-hd-checker-on');
		             	
		             }
		        }  
		    }     
		});
		
	  var InsTypebtnDel = new Ext.Toolbar.Button({
    	text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
    	id:'InsType_btnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('InsType_btnDel'),
   		handler: function () {
   				if(InsTypegrid.selModel.hasSelection()){
						Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
							if (btn == 'yes') {
								Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
								var gsm = InsTypegrid.getSelectionModel();// 获取选择列
								var rows = gsm.getSelections();// 根据选择列获取到所有的行
								Ext.Ajax.request({
									url : InsType_DELETE_ACTION_URL,
									method : 'POST',
									params : {
										'id' : rows[0].get('LOCITRowId')
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
														Ext.BDP.FunLib.DelForTruePage(InsTypegrid,pagesize_pop);
														
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
						
				        
				       
	                }else{
	                	Ext.Msg.show({
										title:'提示',
										msg:'请选择需要删除的行!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
	               		 }
   			
   			
				
   		}
	 });
	var InsTypeWinForm = new Ext.form.FormPanel({
				id : 'InsType-form-save',
				labelAlign : 'right',
				labelWidth : 70,
				//title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'LOCITParRef',mapping:'LOCITParRef',type:'string'},
                                         {name: 'LOCITRowId',mapping:'LOCITRowId',type:'string'},
                                         {name: 'LOCITPatInsType',mapping:'LOCITPatInsType',type:'string'},
                                         {name: 'LOCITLocDR',mapping:'LOCITLocDR',type:'string'},
                                         {name: 'LOCITStartDate',mapping:'LOCITStartDate',type:'string'},
                                         {name: 'LOCITEndDate',mapping:'LOCITEndDate',type:'string'},
                                         {name: 'LOCITUploadFlag',mapping:'LOCITUploadFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'LOCITRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'LOCITRowId'
						}, {
							fieldLabel : 'LOCITParRef',
							hideLabel : 'True',
							hidden : true,
							name : 'LOCITParRef'
						}, {
							xtype:'bdpcombo',
							fieldLabel : '<font color=red>*</font>患者费别',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITPatInsTypeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITPatInsTypeF')),
							id:'LOCITPatInsTypeF',
							hiddenName:'LOCITPatInsType',
							listWidth : 250,
							allowBlank:false,
							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : PACAdmReason_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'READesc',mapping:'READesc'},
										{name:'REARowId',mapping:'REARowId'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'READesc',
							valueField : 'REARowId'
	   					},{
							
							xtype : 'bdpcombo',
							fieldLabel : '<font color=red>*</font>开单科室',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank:false,
							hiddenName:'LOCITLocDR',
							id : 'LOCITLocDRF', //要用id而不是hiddenname
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITLocDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITLocDRF')),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CT_LOC_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTLOCRowID',mapping:'CTLOCRowID'},
										{name:'CTLOCDesc',mapping:'CTLOCDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'CTLOCDesc',
							valueField : 'CTLOCRowID'
						}, {
							xtype:'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITStartDate'),
							width:140,
							allowBlank:false,
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITStartDate')),
							format : BDPDateFormat,
							id:'LOCITStartDate',
							enableKeyEvents : true,
							listeners : {   
								'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }
							
							}
						}, {
							xtype:'datefield',
							fieldLabel : '结束日期',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITEndDate'),
							width:140,
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITEndDate')),
							format : BDPDateFormat,
							id:'LOCITEndDate',
							enableKeyEvents : true,
							listeners : {   
								'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }
							
							}
						}, {
							xtype : 'checkbox',
							fieldLabel : '上传',
							name : 'LOCITUploadFlag',
							id:'LOCITUploadFlag',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITUploadFlag'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITUploadFlag')),
							inputValue : 'Y'
						}]
			});
	
	
	var InsTypewin = new Ext.Window({
		title : '',
		width : 300,
		height:300,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : InsTypeWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'InsType_save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('InsType_save_btn'),
			handler : function() {
				if(InsTypeWinForm.form.isValid()==false){
					Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
   			 		return;
   			 	}
   			 	
   			 	var date1 = Ext.getCmp("LOCITStartDate").getValue();				
    			var date2 = Ext.getCmp("LOCITEndDate").getValue();
				if (date1 != "" && date2 != "") {
    				date1 = date1.format("Ymd");
					date2 = date2.format("Ymd");
        			if (date1 > date2) {
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
   			 	
				if (InsTypewin.title == "添加") {
					InsTypeWinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : InsType_SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								InsTypewin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												InsTypegrid.getStore().load({
															params : {
																start : 0,
																limit : 1,
																rowid : myrowid
															}
														});
											}
								});
								
								
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
							InsTypeWinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : InsType_SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										InsTypewin.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("InsTypegrid", InsType_QUERY_ACTION_URL, myrowid)
												
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
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				InsTypewin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				InsTypeWinForm.getForm().reset();
			},
			"close" : function() {}
		}
	});
	var InsTypebtnAdd = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'InsType_add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('InsType_add_btn'),
				handler :function () {
					InsTypewin.setTitle('添加');
					InsTypewin.setIconClass('icon-add');
					InsTypewin.show();
					InsTypeWinForm.getForm().reset();
					
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					var ParRef = rows[0].get('TARIRowId')
					InsTypeWinForm.getForm().findField('LOCITParRef').setValue(ParRef);
					Ext.getCmp("LOCITPatInsType").focus(true,800);
				},
				scope : this
			});
	var InsTypebtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'InsType_update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('InsType_update_btn'),
				handler : InsTypeUpdateData=function () {
					if (!InsTypegrid.selModel.hasSelection()) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			        	var _record = InsTypegrid.getSelectionModel().getSelected();
			            InsTypewin.setTitle('修改');
						InsTypewin.setIconClass('icon-update');
						InsTypewin.show('');
						Ext.getCmp("InsType-form-save").getForm().reset();
			            Ext.getCmp("InsType-form-save").getForm().load({
			                url : InsType_OPEN_ACTION_URL + '&id=' + _record.get('LOCITRowId'),
			                success : function(form,action) {
			                    //Ext.Msg.alert(action);
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
			}); 
	var InsTypetbbutton= new Ext.Toolbar({
		enableOverflow : true,
		items : [	
					InsTypebtnAdd, '-',InsTypebtnEdit, '-', InsTypebtnDel
		]
	});	
	var InsTypebtnSearch = new Ext.Button({
				id : 'InsTypebtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('InsTypebtnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					InsTypegrid.getStore().baseParams={			
							instypedr : Ext.getCmp("tbLOCITPatInsType").getValue(),
							ctlocdr : Ext.getCmp("tbLOCITLocDR").getValue(),
							parref:rows[0].get('TARIRowId')
					};
					InsTypegrid.getStore().load({
						params : {
							start : 0,
							limit : pagesize_pop
						}
					});
				}
			});
	var InsTypebtnRefresh = new Ext.Button({
				id : 'InsTypebtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('InsTypebtnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("tbLOCITPatInsType").setValue("");
					Ext.getCmp("tbLOCITLocDR").setValue("");
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					InsTypegrid.getStore().baseParams={			
							parref:rows[0].get('TARIRowId')
					};
					InsTypegrid.getStore().load({
						params : {
							start : 0,
							limit : pagesize_pop
						}
					});
				}
			});
	// 将工具条放到一起
	var InsTypetb = new Ext.Toolbar({
				id : 'InsTypetb',
				items : [
	   					'患者费别',{
							xtype:'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							emptyText:'',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITPatInsType'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITPatInsType')),
							id:'tbLOCITPatInsType',
							listWidth : 250,
							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : PACAdmReason_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'READesc',mapping:'READesc'},
										{name:'REARowId',mapping:'REARowId'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'READesc',
							valueField : 'REARowId'
	   					},'-','开单科室',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							id : 'tbLOCITLocDR', //要用id而不是hiddenname
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCITLocDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCITLocDR')),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CT_LOC_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTLOCRowID',mapping:'CTLOCRowID'},
										{name:'CTLOCDesc',mapping:'CTLOCDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'CTLOCDesc',
							valueField : 'CTLOCRowID'
						}
							,'-',InsTypebtnSearch,'-',InsTypebtnRefresh
						
					],
				listeners : {
					render : function() {
						InsTypetbbutton.render(InsTypegrid.tbar)
					}
				}
	});
	var InsTypegrid = new Ext.grid.GridPanel({
				id : 'InsTypegrid',
				region : 'center',
				closable : true,
				store : PatInsTypeds,
				trackMouseOver : true,
				sm:PatInsTypesm,
				columns : [PatInsTypesm, 
						{
							header : 'ID',
							sortable : true,
							width : 90,
							hidden:true,
							dataIndex : 'LOCITRowId'
						
						}, {
							header : 'LOCITParRef',
							sortable : true,
							width : 90,
							hidden:true,
							dataIndex : 'LOCITParRef'
						
						}, {
							header : '病人费别',
							sortable : true,
							width:180,
							dataIndex : 'LOCITPatInsType'
						}, {
							header : '开单科室',
							sortable : true,
							dataIndex : 'LOCITLocDR',
							width : 160
						}, {
							header : '开始日期',
							sortable : true,
							width:120,
							dataIndex : 'LOCITStartDate'
						}, {
							header : '结束日期',
							sortable : true,
							width:160,
							dataIndex : 'LOCITEndDate'
						}, {
							header : '上传标识',
							sortable : true,
							width:160,
							dataIndex : 'LOCITUploadFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						
						}],
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				tbar:InsTypetb,
				columnLines : true, //在列分隔处显示分隔符
				bbar :PatInsTypepaging
			});	
	InsTypegrid.on('rowdblclick', function(InsTypegrid) {
				InsTypeUpdateData()
			});
	///与收费项关联的医嘱项
	var PatInsTypewin = new Ext.Window({
					iconCls : 'icon-AdmType',
					width : 1000,
					height : 460,//Ext.getBody().getHeight()*.9,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					constrain : true,
					closeAction : 'hide',
					items : [InsTypegrid],
					listeners : {
						"show" : function(){
												
						},
						"hide" : function(){
							Ext.getCmp("TbLinkEndDate").setValue("")
						},
						"close" : function(){
						}
					}
				});
	var btnPatInsType = new Ext.Button({
				id : 'btnPatInsType',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPatInsType'),
				iconCls : 'icon-AdmType',
				text : '医保上传维护',
				handler : function() {
					if (grid.selModel.hasSelection()) {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						InsTypegrid.getStore().baseParams={
							parref:rows[0].get('TARIRowId')
						};
						InsTypegrid.getStore().load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						
						PatInsTypewin.setTitle(rows[0].get('TARIDesc')+'----医保上传维护');
						PatInsTypewin.setIconClass('icon-AdmType');
						PatInsTypewin.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条收费项!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
	           	 	
					
					
				}
			});	
			
	
			
	*/
			
			
	
	
	////配置框  20170706 add
	var config_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=GetConfigValue";
   	var config_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=SaveConfigValue";
    	
	var configWinForm = new Ext.FormPanel({
				id : 'config-form-save',
				URL : config_SAVE_ACTION_URL,
				labelAlign : 'right',
				labelWidth : 140,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'AutoCode',mapping:'AutoCode'},
                                         {name: 'FCode',mapping:'FCode'},
                                          {name: 'ICode',mapping:'ICode'},
                                         {name: 'OriginCode',mapping:'OriginCode'},
                                         {name: 'TotalLength',mapping:'TotalLength'},
                                          {name: 'ValidDesc',mapping:'ValidDesc'}
                                        ]),
				defaults : {
					anchor : '90%',
					bosrder : false
				},
				items : [{
						boxLabel :'自动生成代码(字母+数字或者纯数字编码)',   //默认不自动生成
		                name: 'AutoCode',
		                id:'AutoCode',
		                xtype:'checkbox',
		                listeners:{
							'check':function(checked){
								   if(checked.checked){
										
										Ext.getCmp("FCode").setDisabled(false);
										Ext.getCmp("ICode").setDisabled(false);
										Ext.getCmp("TotalLength").setDisabled(false);
										
										if(Ext.getCmp("FCode").checked){
											Ext.getCmp("OriginCode").setDisabled(false);
	
										}else{
											Ext.getCmp("OriginCode").setDisabled(true);	
										}
										
									}else{
										
										Ext.getCmp("FCode").setDisabled(true);
										Ext.getCmp("ICode").setDisabled(true);
										Ext.getCmp("TotalLength").setDisabled(true);
										Ext.getCmp("OriginCode").setDisabled(true);
										
									}
							}
						}
		           },{
	                    xtype: 'radio', 
	                    id:'FCode',
	                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('FCode'),
	                    boxLabel: '自定义',
	                    name: 'CodeType',
	                    inputValue: 'F',
	                    listeners:{
							'check':function(checked){
								
								 if(Ext.getCmp("AutoCode").checked){
								
								   if(checked.checked){
										Ext.getCmp("OriginCode").setDisabled(false);

									}else{
										Ext.getCmp("OriginCode").setDisabled(true);	
									}
								 }
							}
						}
	                },{
		                fieldLabel : '代码起始字符',
		                name: 'OriginCode',
		                xtype:'textfield',
		                id:'OriginCode',
		                disabled:true 
					}, {
	                    xtype: 'radio', 
	                    id:'ICode',
	                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICode'),
	                    name: 'CodeType',
	                    labelSeparator: '',
	                    boxLabel: '树形分类代码',
	                    inputValue: 'I' 	   
		            },{
		                fieldLabel : '<font color=red>*</font>代码总长度',
		                name: 'TotalLength',
		                xtype:'numberfield',
		                minValue : 1,
						allowNegative : false,//不允许输入负数
						allowDecimals : false,//不允许输入小数
		                id:'TotalLength',
		                disabled:true
		             }, {
						xtype:'checkbox',
						inputValue :'Y',
						boxLabel:'校验名称是否重复',
						id:'ValidDesc',
			    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'),
						style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'))
					}]
	});
	
	var configwin = new Ext.Window({
		title : '',
		width : 515,
		minWidth:515,
		height: 300,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		hideCollapseTool : true,
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
					var CodeType="";
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
		    			if (Ext.getCmp("FCode").getValue()==true)
						{
							CodeType="F"
						}
						else if (Ext.getCmp("ICode").getValue()==true)
						{
							CodeType="I"
						}
						else
						{
							
							Ext.Msg.show({ title : '提示', msg : '请选择一个代码生成规则!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			return;
						}
					}
					//-------保存----------
					var ConfigStr=Ext.getCmp('AutoCode').getValue()+'^'+CodeType+'^'+Ext.getCmp('TotalLength').getValue()+'^'+Ext.getCmp('OriginCode').getValue()+'^'+Ext.getCmp('ValidDesc').getValue()   //1~5
					Ext.Ajax.request({
							url : config_SAVE_ACTION_URL, 
							method : 'POST',
							params : {
								'ConfigStr' :ConfigStr,
								'hospid':hospComp.getValue()
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
	                	url : config_OPEN_ACTION_URL+ '&hospid='+ hospComp.getValue(),
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
	
	
 	
	//ie下导出
	/*ExportExcelData=function() {
				var count=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDataCount");
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
				// f1的任务代码
				var ErrorMsgInfo="请先确认本机有安装office软件。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "
 
			 	try{
			   	 	xlApp = new ActiveXObject("Excel.Application");
					xlBook = xlApp.Workbooks.Add();///默认三个sheet
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
				var titlenameStr=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetExceltitlename");
				var titlenamearr=titlenameStr.split("^");
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
				  		var DataDetailStr2=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetFieldValue",row,hospComp.getValue());
						var Detail2=DataDetailStr2.split("^");		
						for (var j=1;j<=Detail2.length;j++){
							xlsheet.cells(1+row,j)="'"+Detail2[j-1];
						}
						progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";  
					    proBar.updateProgress(row/taskcount,progressText);
					  }
						 
				  },  
				  interval:5 
				});
				winproBar.show();
				
		}
		
	*/
	//调用js-xlsx 导出数据  2022-06-27
	function ExportExcelData() {
		
		var xlsName="收费项目" 
		if (xlsName!="") 
		{  
			var taskcount= tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDataCount");  //获取要导出的总条数  
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
				var titledescarr=[]; 
				var titleStr=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetExceltitlename");  
				titledescarr=titleStr.split("^");
				TotalArray.push(titledescarr);    
				
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
						var DataDetailStr=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetFieldValue",row,hospComp.getValue());  //获取每行的数据值
						var DetailArray=DataDetailStr.split("^");
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
	var btnExportLink = new Ext.Button({
				id : 'btnExportLink',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnExportLink'),
				iconCls : 'icon-export',
				text : '导出查询数据',
				handler :function() {
						ExportExcelData()
				}
			});		
	///调价
   /*
   var btnExportPrice = new Ext.Button({
				id : 'btnExportPrice',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnExportPrice'),
				iconCls : 'icon-import',
				tooltip:'请在IE下执行',
				text : '收费项目导出价格',
				handler :function() {
						var ExportPricepanel =  new Ext.Window({
			                region:'center',
			                closeAction : 'hide',
			               	width:Ext.getBody().getViewSize().width-20,
							height:Ext.getBody().getViewSize().height-20,
							layout : 'fit',
							title:'收费项目导出价格',
							plain : true,
							modal : true,
							frame : true,
							collapsible : true,
							hideCollapseTool : true,
							titleCollapse : true,
							html :"<iframe frameborder='0' scrolling='auto' height='100%'  width='100%' src='dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_DataEXPanel&AutCode=DHC_TarItemPrice'></iframe>",
			                listeners : {
								"show" : function() {
									
								},
								"hide" : function() {
									
								},
								"close" : function() {
								}
							}
						});
						ExportPricepanel.show()
				}
			});	
	var btnAdjustPrice = new Ext.Button({
				id : 'btnAdjustPrice',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAdjustPrice'),
				iconCls : 'icon-import',
				tooltip:'请在IE下执行',
				text : '收费项目调价',
				handler :function() {
						var AdjustPricepanel =  new Ext.Window({
			                region:'center',
			                closeAction : 'hide',
			               	width:Ext.getBody().getViewSize().width-20,
							height:Ext.getBody().getViewSize().height-20,
							layout : 'fit',
							title:'收费项目调价导入',
							plain : true,
							modal : true,
							frame : true,
							collapsible : true,
							hideCollapseTool : true,
							titleCollapse : true,
							html :"<iframe frameborder='0' scrolling='auto' height='100%'  width='100%' src='dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_DataIMPanel&AutCode=DHC_TarItemPrice'></iframe>",
			                listeners : {
								"show" : function() {
									
								},
								"hide" : function() {
									
								},
								"close" : function() {
								}
							}
						});
						AdjustPricepanel.show()
				}
			});	
	
	*/
	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [	
					'开始日期从',
				{
							xtype:'datefield',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TbStartDate1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TbStartDate1')),
							format : BDPDateFormat,
							id:'TbStartDate1',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  },
											 'select': function(field,e){
												         search();
								                 	}
							
							}
							
							
						},'到',
						{
							xtype:'datefield',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TbStartDate2'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TbStartDate2')),
							format : BDPDateFormat,
							id:'TbStartDate2',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  },
											'select': function(field,e){
												         search();
								                 	}
								                 	
								  }
						},	
							'价格从', {xtype : 'textfield',id : 'TextPrice1',minValue : 0,				
			allowNegative : false,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextPrice1'),width:50,enableKeyEvents: true,
									listeners:{
										keyup:function(node, event) {
											///var val = node.getValue().toString().replace(/["^d]/g,''); ///只有数字
											var val = node.getValue().toString().replace(/[^\d\.]/g,'');  ///数字和小数点
											node.setValue(val)
										
										},
										scope: this
									}},
											
								'到', {xtype : 'textfield',id : 'TextPrice2',minValue : 0,				
			allowNegative : false,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextPrice2'),width:50,enableKeyEvents: true,
									listeners:{
										keyup:function(node, event) {
											var val = node.getValue().toString().replace(/[^\d\.]/g,'');		
											node.setValue(val)
											
										},
										
										scope: this
									}},
									'国家医保编码', {xtype : 'textfield',id : 'TextInsuCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextInsuCode'),width:80},
									'对照状态',{
										xtype : 'combo',
										listWidth:70,
										width:70,
										shadow:false,
										//fieldLabel : '对照国家医保编码',
										id :'tbInsuCodeMapedFlag',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('tbInsuCodeMapedFlag'),
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
										//editable:false,
										valueField : 'value',
										displayField : 'name'
										,listeners:{
											   'select': function(field,e){
											         search();
							                 	}
										}
									},
									Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),
									btnSearch,btnRefresh
							 // ,'-',btnPatInsType  ofy10
				
						
		]
	});	
	var tbbutton2 = new Ext.Toolbar({
		enableOverflow : true,
		items : [	
					btnAdd, '-', btnEditwin,'-',btnCopy ,  
						'-',btnConfig,
						'-',btnInsu,  '-',btnEff, '-', btnExportLink,'-',  //btnAdjustPrice,
			'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		]
	});	
	
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),width:80},
						'名称', {xtype : 'textfield',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),width:80},
						'别名', {xtype : 'textfield',id : 'TextAlias',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextAlias'),width:80},
						'有效',{
							xtype : 'combo',
							listWidth:60,
							width:60,
							shadow:false,
							//fieldLabel : '有效',
							id :'tbActiveFlag',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbActiveFlag'),
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
							//editable:false,
							valueField : 'value',
							displayField : 'name'
							,listeners:{
								   'select': function(field,e){
								         search();
				                 	}
							}
						},
						'项目类型',{
							xtype : 'combo',
							listWidth:70,
							width:70,
							shadow:false,
							fieldLabel : '项目类型',
							id :'tbItemType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbItemType'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '药品',
									value : 'R'
								}, {
									name : '材料',
									value : 'M'
								}, {
									name : '诊疗项目',
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
							,listeners:{
								   'select': function(field,e){
								         search();
				                 	}
							}
						},
						
						
						'单位',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:260,
							width:70,
							shadow:false,
							fieldLabel : '单位',
							id :'tbUOM',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbUOM'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : TARI_UOM_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTUOMRowId',mapping:'CTUOMRowId'},
										{name:'CTUOMDesc',mapping:'CTUOMDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							displayField : 'CTUOMDesc',
							valueField : 'CTUOMRowId',
							listeners:{
								   'select': function(field,e){
								         search();
				                 	}
							}
						},
						'收费依据', {xtype : 'textfield',id : 'TextChargeBasis',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextChargeBasis'),width:80},
						'外部编码', {xtype : 'textfield',id : 'TextExternalCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextExternalCode'),width:70}
						
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
						tbbutton2.render(grid.tbar)
					}
				}
	});
	
	var GridCM=[
		new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
	 sm,{
							header : 'ID',
							width : 60,
							hidden : true,
							sortable : true,
							dataIndex : 'TARIRowId'
						}, {
							header : '是否有效',
							width : 70,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							sortable : false,
							dataIndex : 'TARIActiveFlag'
						}, {
							header : '收费项代码',
							width : 120,
							sortable : true,
							dataIndex : 'TARICode'
						}, {
							header : '收费项名称',
							width : 200,
							sortable : true,
							dataIndex : 'TARIDesc'
						}, {
							header : '价格',
							width : 100,
							sortable : true,
							dataIndex : 'TariPrice'	
						
						}, {
							header : '单位',
							width : 70,
							sortable : false,
							dataIndex : 'TARIUOM'
						
						}, {
							header : '开始日期',
							width : 100,
							sortable : true,
							dataIndex : 'TARIStartDate'
						}, {
							header : '结束日期',
							width : 100,
							sortable : false,
							//hidden : true,
							dataIndex : 'TARIEndDate'
						}, {
							header : '国家医保编码',
							width : 160,
							sortable : false,
							dataIndex : 'TARIInsuCode'
						}, {
							header : '国家医保名称',
							width : 160,
							sortable : false,
							dataIndex : 'TARIInsuName'
						}, {
							header : '收费项目子类',
							width : 100,
							sortable : false,
							dataIndex : 'TARISubCate'
						}, {
							header : '收费会计子类',
							width : 100,
							sortable : false,
							dataIndex : 'TARIAcctCate'
						}, {
							header : '门诊费用子类',
							width : 100,
							sortable : false,
							dataIndex : 'TARIOutpatCate'
						}, {
							header : '住院费用子类',
							width : 100,
							sortable : false,
							dataIndex : 'TARIInpatCate'
						}, {
							header : '经济核算子类',
							width : 100,
							sortable : false,
							dataIndex : 'TARIEMCCate'
						
						}, {
							header : '旧病案首页子类',
							width : 150,
							sortable : false,
							dataIndex : 'TARIMRCate'
						}, {
							header : '新病案首页子类',
							width : 150,
							sortable : false,
							dataIndex : 'TARIMCNew'
						}, {
							header : '特殊项目标识',
							width : 110,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							sortable : false,
							dataIndex : 'TARISpecialFlag'
						}, {
							header : '树形分类',
							width : 100,
							sortable : false,
							dataIndex : 'TARIItemCatDR'	
						}, {
							header : '手术分级',
							width :140,
							sortable : false,
							dataIndex : 'TARIOPERCategoryDR'
						}, {
							header : '收费依据',
							width : 180,
							sortable : true,
							dataIndex : 'TARIChargeBasis'
						}, {
							header : '外部编码',
							width : 120,
							sortable : true,
							dataIndex : 'TARIExternalCode'
						}, {
							header : '收费说明',
							width : 200,
							sortable : false,
							dataIndex : 'TARIEngName'	
						}, {
							header : '项目内涵',
							width : 200,
							sortable : false,
							dataIndex : 'TARIConnote'	
						}, {
							header : '备注',
							width : 200,
							sortable : false,
							dataIndex : 'TARIRemark'	
						}, {
							header : '除外内容',
							width : 200,
							sortable : false,
							dataIndex : 'TARIExclude'
						}, {
							header : '物价备注',
							width : 200,
							sortable : false,
							dataIndex : 'TARIPriceRemark'
						}, {
							header : '物价编码',
							width : 140,
							sortable : false,
							dataIndex : 'TARIPriceCode'
						}, {
							header : '物价名称',
							width : 140,
							sortable : false,
							dataIndex : 'TARIPriceDesc'
						}, {
							header : '特需项目标识',
							width : 120,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							sortable : false,
							dataIndex : 'TARISpecialProcurementFlag'
						
						}, {
							header : '不允许重复收费',
							width : 120,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							sortable : false,
							dataIndex : 'TARIRepeatedChargeFlag'
            }, {
							header : '进口标志',
							width : 90,
							sortable : false,
							hidden:true,                      //标准版先隐藏掉
							dataIndex : 'TARIManufactorType',
							renderer : function(v){
								if(v=='IM'){return '进口';} 
								if(v=='HM'){return '国产';}
								if(v=='JM'){return '合资';}
								if(v=='UM'){return '未分类';}
							}	
						
						}, {
							header : '树形分类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIItemCatDRID'	
						
						}, {
							header : '单位ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIUOMID'
						
						}, {
							header : '收费项目子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARISubCateID'
						}, {
							header : '收费会计子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIAcctCateID'
						}, {
							header : '门诊费用子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIOutpatCateID'
						}, {
							header : '住院费用子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIInpatCateID'
						}, {
							header : '经济核算子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIEMCCateID'
						
						}, {
							header : '旧病案首页子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIMRCateID'
						}, {
							header : '新病案首页子类ID',
							width : 100,
							hidden : true,
							sortable : false,
							dataIndex : 'TARIMCNewID'
						
						
						}]
	
	
		var grid = new Ext.grid.GridPanel({
			id:'grid',
			region:'center',
			title:'收费项目列表',
			//height:420,
			//width : 495,
			autoScroll:true,
			store:TarItemInfoStore,
			columnLines : true, //在列分隔处显示分隔符
			trackMouseOver : true,  //True表示为鼠标移动时高亮显示（默认为true)
			stripeRows : true,  //True表示为显示行的分隔符（默认为true）。
			//loadMask : true, 
			bbar:TarItemInfoToolbar,
			tbar:tb,
			columns :GridCM,
			sm:sm,
			/*loadMask : {
				//msg : '数据加载中,请稍候...'
			},*/
			// config options for stateful behavior
			stateful : true,
			viewConfig : {
				//forceFit : true  ///注释后按照width显示宽度
			},
			stateId : 'grid'
		});
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	
	var loadFormData = function(grid) {
       if (grid.selModel.hasSelection()) {
       		var rows = grid.getSelectionModel().getSelections();
       		win.setTitle('修改');
       		win.setIconClass('icon-update');
			win.show();
        	
            DHCTarItemPanel.form.load( {
                url : OPEN_ACTION_URL + '&id='+ rows[0].get('TARIRowId'),
                success : function(form,action) {
                	//Ext.Msg.alert('提示','载入成功！');
                	/*var obj = Ext.util.JSON.decode(action.response.responseText);
					if (obj) {

						var list=obj.list;
						//alert(list[0].TARIRowId)
					}*/
                	
                	////2019-11-19chenying 要等到加载完以后再去赋值描述，否则会显示成id
		          //  Ext.get("treeCombox").dom.value=_record.get('TARIItemCatDR');  ///描述
		           // Ext.getCmp("treeCombox").setValue(_record.get('TARIItemCatDRID'));
                	treeCombox.root.reload();
                  	Ext.getCmp("treeCombox").setValue(rows[0].get('TARIItemCatDRID'));
		            Ext.getCmp("treeCombox").setRawValue(rows[0].get('TARIItemCatDR'));  //描述
		            //Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIItemCatDR').setValue(_record.get('TARIItemCatDRID'));
					//Ext.getCmp("DHCTarItemPanel").getForm().findField('TARIItemCatDR').setRawValue(_record.get('TARIItemCatDR'));
                },
                failure : function(form,action) {
                	//Ext.Msg.alert('提示','载入失败！');
                }
            });
            
            Ext.getCmp("ARCIMCode").setValue("");
			Ext.getCmp("ARCIMDesc").setValue("");
			Ext.getCmp('ARCIMItemCatDR1').setValue("");
			Ext.getCmp("ARCIMItemCatDR1").setRawValue("");
			Ext.getCmp("ARCIMDefPriorityDR1").setValue("");
			Ext.getCmp("ARCIMDefPriorityDR1").setRawValue("");
			Ext.getCmp("ARCIMEffDate").setValue("");
			Ext.getCmp("ARCIMEffDateTo").setValue("");
			Ext.getCmp("ARCIMAllowOrderWOStockCheck").setValue(false);
			Ext.getCmp("ARCIMSensitive").setValue(false);
			Ext.getCmp("ARCIMOrderOnItsOwn").setValue(false);
			Ext.getCmp("ARCIMBill1").setValue("");
			Ext.getCmp("ARCIMBillSubDR1").setValue("");
			Ext.getCmp("ARCIMAlias").setValue("");
			
			Ext.getCmp("OLTQty").setValue("");
			Ext.getCmp("OLTStartDate").setValue("");
			Ext.getCmp("OLTEndDate").setValue("");
			
			PriceGrid.getStore().baseParams={
				TARIRowId :  rows[0].get('TARIRowId')
			};
			PriceGrid.getStore().load();
     		selectTARIRowId=rows[0].get('TARIRowId');
     		var DefPatInsTypeValue=tkMakeServerCall("web.DHCBL.CT.DHCTarItem","GetDefPatInsType",hospComp.getValue());
     		Ext.getCmp('TPPatInsType1').setValue(DefPatInsTypeValue)
     		var DefHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","DHC_TarItemPrice",hospComp.getValue())
     		Ext.getCmp('TPHospitalDR1').setValue(DefHospId)
     		//Ext.getCmp('TPPatInsType1').setValue("")
     		Ext.getCmp('TPPrice').setValue("")
     		Ext.getCmp('TPStartDate').setValue(TomorrowDate)
     		Ext.getCmp('TPEndDate').setValue("")
     		Ext.getCmp('TPAlterPrice1').setValue("")
     		Ext.getCmp('TPAlterPrice2').setValue("")
     		//Ext.getCmp('TPNoteText').setValue("")
     		Ext.getCmp('ARCIMBillingUOMDR').setValue("");
 			Ext.getCmp('ARCIMAbbrev').setValue("");
 			Ext.getCmp('ARCIMOEMessage').setValue("");
 			Ext.getCmp('ARCIMServMaterial').setValue("");
 			Ext.getCmp('ARCIMDefSensitive').setValue("");
     		//激活基本信息面板
            tabs.setActiveTab(0);
	       	AliasGrid.TIATARIDR = rows[0].get('TARIRowId');
	        AliasGrid.loadGrid();
	        
	        //添加维护限制，如果是配置取值来源为医保，则不允许维护国家医保编码和国家医保名称数据。
	        var InsuConfig = tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"DHC_TarItem");
	        if (InsuConfig=="INSU")
	        {
	        	Ext.getCmp("TARIInsuCode").setDisabled(true);
	        	Ext.getCmp("TARIInsuName").setDisabled(true);
	        }
	        else
	        {
		        Ext.getCmp("TARIInsuCode").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuCode'));
	        	Ext.getCmp("TARIInsuName").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TARIInsuName'));
	        }
	        //Ext.getCmp('btn_UpdatePriceEndDate').disable();
        }
    };
    
    
    //翻译
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
      			var rows = grid.getSelectionModel().getSelections();
       			 var selectrow = rows[0].get('TARIRowId');	           
	 	} else {
	 		var selectrow="";
		 }
		Ext.BDP.FunLib.SelectRowId = selectrow;	

	})

			
			
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   //var row = grid.getStore().getAt(rowIndex).data;
        	loadFormData(grid);		
				        
    });	
	
	var gridCenter = new Ext.Panel({
		id:'searchgrid',
        region: 'center',
        //title: '收费项目信息维护',
        collapsible: false,
        width: 423, // give east and west regions a width
        minSize: 350,
        maxSize: 500,
        margins: '0 0 0 0',
        layout: 'border', 
        defaults:{split:true},
        items : [grid]  
	});
	///左侧分类查询树
   CatTreeLoader.on("beforeload", function(CatTreeLoader, node) {
   		CatTreeLoader.dataUrl = CatTree_QUERY_ACTION_URL ;  
		CatTreeLoader.baseParams = {LastLevel:"TreeRoot",Type:Ext.getCmp("TypeF").getValue(),hospid:hospComp.getValue()}
    }, this);
	
	var loadflag=0;
	var viewport = new Ext.Viewport({
        layout: 'border',
        defaults:{split:true},
        items: [
		//WestForm, 
        GenHospPanel(hospComp),CatPanel, gridCenter  //多院区医院
      //  ExecutabletreePanel,
   		///talPanel
   		],
			 listeners:{
		
				'afterlayout':function(){
					//打开页面默认加载数据(以下)
					if (loadflag==0)
					{
						loadflag=1
						
						
						///多院区医院
						var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
						if (flag=="Y"){
							grid.disable();
							
						}
						else
						{
							
							TarItemInfoStore.baseParams={
			  			 	 	
			  			 	 };
							TarItemInfoStore.load({
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

