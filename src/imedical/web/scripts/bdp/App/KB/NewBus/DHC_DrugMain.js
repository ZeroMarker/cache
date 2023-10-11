/*
Creator:GuXueping
CreatDate:2017-12-01
Description:知识库浏览器
*/
///通用名列表
var lib="DRUG"
var GlPGenDr=""
var GlPPointer=""
var GlPPointerType=""
var GenDesc=""
var countInfo=""  //小气泡显示的条数

var SAVE_GEN_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCGenLinkPointer";

var GEN_FORM_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetGenFormCombo";
var CAT_TREE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=DRUG";
var showData = function(){
   
	//如果是医生站调用该界面，则左侧面板隐藏
	if ((GenCode!= "")&(PointerCode!="")&(GenCode!=null)&(PointerCode!=null)&(GenCode!=undefined)&(PointerCode!=undefined))
	{
		$('#mainlayout .layout-panel-west').css('display','none'); 
		$("#mainlayout").layout("resize");
		var Pdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",GenCode);
		var PFdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",PointerCode);
		
		//alert(Pdesc);
		//alert(PFdesc);
		
		var GlPGenDr = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",GenCode);
		var GlPPointer = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",PointerCode);
		
		//alert(GlPGenDr);
		//alert(GlPPointer);
		
		if ((Pdesc=="") || (PFdesc=="") || (GlPGenDr=="-1") ||(GlPPointer=="-1"))
		{
			GenDesc = "未查询到该检验项目"
		}
		else
		{
			document.getElementById('mainGrid').style.display='';  //显示mygrid
			$("#div-img").hide();		 //初始图片消失
			GenDesc=Pdesc+"/"+PFdesc
			//alert(GlPGenDr+"^"+GlPPointer+"^"+GlPPointerType)
			QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
		}
					
		$("#drugDesc").html(GenDesc);
	}		
		
}


function InitGenList()
{

	var GEN_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetGenListNew"+"&lib="+lib;
	var gencolumns =[[  
				  {field:'PHEGDesc',title:'通用名',width:180},
				  {field:'PHEFDesc',title:'剂型',width:80}, 
				  {field:'GlPGenDr',title:'通用名Dr',width:30,hidden:true},
				  {field:'GlPPointer',title:'剂型Dr',width:30,hidden:true},
				  {field:'GlPRowId',title:'GlPRowId',width:30,hidden:true}
				  ]];

	$('#genGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		toolbar:'#genbar', //上工具栏,空为null
		pagination: true, 
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		displayMsg:'',
		showRefresh:false,
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:GEN_QUERY_ACTION_URL,
		singleSelect:true,
		idField:'GlPRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:gencolumns,
		onClickRow:ClickGenGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
		},
		onLoadError:function(){
		}
	});
}

///通用名单击事件
function  ClickGenGrid(rowIndex, rowData)
{	
	//编辑按钮可用
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").hide();		 //初始图片消失
	$('#btnDrugEdit').linkbutton('enable');
	var Pdesc=rowData.PHEGDesc;
	var PFdesc=rowData.PHEFDesc;
	GenDesc=Pdesc+"/"+PFdesc;
	$("#drugDesc").html("<h2 style='color:black;'>"+GenDesc+"</h2>");
	//$("#drugDesc").html(GenDesc);
	GlPGenDr = rowData.GlPGenDr;
	GlPPointer =rowData.GlPPointer;
	GlPPointerType="Form" ;
	var input=GlPGenDr+"^"+GlPPointer+"^"+GlPPointerType;
	QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
	/*if ($('#maintabs').tabs('exists', 1)){
		$("#maintabs").tabs("select", 0);  //切换到浏览页签
		$('#maintabs').tabs('enableTab', 1);  //编辑页签设置为可用
	}*/
	//判断当前选中的tab。如果是浏览则重新加载grid，如果是编辑就重新加载编辑的左侧列表，因为小气泡数量不一样
	/*var tab = $('#maintabs').tabs('getSelected');
	var index = $('#maintabs').tabs('getTabIndex',tab);
	if (index==1){  //编辑页签
		getNumbers();
		QueryLeftTree();	
		closeTabs();			
	}*/
}
	
///通用名剂型检索框
function InitGenFormList()
{

	$('#GlPPointer').combobox({ 
		url:GEN_FORM_COMBO_URL,
		valueField:'id',
		textField:'text',
		panelWidth:100,
		onSelect:function(record){
			GenSearch();	
		}
	});
}

///商品名剂型检索框
function InitProFormList()
{
	$('#proForm').combobox({ 
		url:GEN_FORM_COMBO_URL,
		valueField:'id',
		textField:'text',
		panelWidth:100,
		onSelect:function(record){
			ProSearch();	
		}
	});
}

///药品分类检索框
function InitLibList()
{
	var catTree = $HUI.combotree('#LibType',{
		url:CAT_TREE_URL,
		panelWidth:450,
		panelHeight:400,
		cascadeCheck: false, 
        //onlyLeafCheck: true,
		multiple: true
	});
}

///商品名列表
function InitProList()
{
	var PRO_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetProListNew";
	
	var procolumns=[[  
				  {field:'PHNDesc',title:'商品名',width:180}, 
				  {field:'PHNFormDr',title:'剂型',width:80}, 
				  {field:'PHNFactory',title:'厂商',hidden:true},
				  {field:'PHNManfDR',title:'厂商新',hidden:true},
				  {field:'PHNToxicity',title:'有毒',hidden:true},
				  {field:'PHNRowId',title:'PHNRowId',hidden:true}
				  ]];


	$('#proGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		pagination: true, 
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:'',
		showRefresh:false,
		toolbar:'#probar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:PRO_QUERY_ACTION_URL,
		singleSelect:true,
		idField:'PHNRowId', 
		rownumbers:true,
		fixRowNumber:true,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:procolumns,
		onClickRow: ClickProGrid,
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
		},
		onLoadError:function(){
		}
	});
}

///商品名单击事件
function  ClickProGrid(rowIndex, rowData)
{
	//编辑按钮可用
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").hide();		 //初始图片消失
	$('#btnDrugEdit').linkbutton('enable');
	GenDesc=rowData.PHNDesc;

	var factory=rowData.PHNManfDR //厂商
	var toxicity= rowData.PHNToxicity //毒性
	if (toxicity!=""){
		GenDesc=GenDesc+"（"+toxicity+"）"
	}
	if(factory.indexOf("-") > 0 )
	{
	   factory = factory.split("-")[1];
	}		
	if (factory=="")
	{
		$("#drugDesc").html("<h2 style='color:black;'>"+GenDesc+"</h2>");
	}
	else
	{
		$("#drugDesc").html("<h2 style='color:black; margin-bottom: 1px; margin-top: 2px;'>"+GenDesc+"</h2><h3 style='color:black;margin-top: 2px;background-color: #fff;text-align:center;'>"+factory+"</h3>");
	}
	GlPGenDr = rowData.PHNRowId;
	GlPPointer ="0";
	GlPPointerType="ProName";
	var input=GlPGenDr+"^"+GlPPointer+"^"+GlPPointerType;
	//alert(input)
	QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
	/*if ($('#maintabs').tabs('exists', 1)){
		$("#maintabs").tabs("select", 0);  //切换到浏览页签
		$('#maintabs').tabs('enableTab', 1);  //编辑页签设置为可用
	}*/
}
	

///知识库浏览器主界面
function InitMainList()
{
	var MAIN_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetDrugBookListNew";
	var mainclumns=[[ 
				  {field:'PHINSTDesc',title:'',width:800,
					formatter: function(value,row,index){
						if (row._parentId=="")
						{
							return ReturnFlagIcon(row.PHINSTGroupDesc)
						}else{
							//return '<div style="word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">'+value+'</div>';
							return value
						}
					},
					styler: function(value,row,index){
						/*if (row._parentId==""){
							return 'background-color:#bebec5;';  //#40a2de
						}*/
					}
				  }, 
				  //{field:'libdr',title:'libdr',hidden:true}, 
				  {field:'PHINSTGroupDesc',title:'知识库标识',hidden:true}, 
				  {field:'PHINSTSoft',title:'排序',hidden:true},   
				  {field:'PHINSTCount',title:'数量',hidden:true},
				  {field:'id',title:'id',hidden:true},
				  {field:'_parentId',title:'parentId',hidden:true}
				  ]];
	$('#mainGrid').treegrid({ 
		url:MAIN_QUERY_ACTION_URL,
		columns:mainclumns,
		width:'100%',
		height:'100%',
		showHeader:false,
		pagination: false, 
		pageSize:1000,
		pageList:[1000],
		toolbar:'#mainbar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		singleSelect:true,
		idField:'id', 
		treeField:'PHINSTDesc',
		rownumbers:false,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		onLoadSuccess:function(node, data){
			$('.editbutton').linkbutton({
				plain:true,
				iconCls:"icon-editrow"
			});
			//去掉treegrid结点前面的文件及文件夹小图标
			$("#mainGridDiv .tree-icon,#mainGridDiv .tree-file").removeClass("tree-icon tree-file");
			$("#mainGridDiv .tree-icon,#mainGridDiv .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
		},
		onDblClickRow:function(index,row){
			InitLeftTree(row.PHINSTGroupDesc)
		}
	});
	
	
}

///获取小气泡的显示数字
function getNumbers()
{
	countInfo=""
	var rows = $('#mainGrid').treegrid('getData');
	for(var i=0; i<rows.length; i++)
	{
		var parentid= rows[i].id;
		var children= $('#mainGrid').treegrid('getChildren',parentid);
		var childlen=children.length;
		countInfo= countInfo+rows[i].PHINSTGroupDesc + '#' + childlen + '^';
	}
	//alert(countInfo)
}

///重新加载编辑页签左侧面板数据
function QueryLeftTree()
{
	$('#LeftTree').datagrid('load',  {  
		'countInfo':countInfo,
		'pointType':GlPPointerType
	});

}

///创建左侧菜单树
function InitLeftTree(desc)
{
	AddFunWindow();  //弹出弹框
	getNumbers();    //获取气泡数量
	var LEFT_MENU_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetMenuNew"+"&code="+lib+"&pointType="+GlPPointerType;
	var leftclumns=[[ 
				  {field:'text',title:'',width:'154',
					formatter: function(value,row,index){
						if (row.icon!=""){
							if (row.count!="0"){
								return "<img src='"+row.icon+"' style='border: 0px'><span>"+" "+value+"</span><span class='badgeDiv'>"+row.count+"</span>";
							}else{
								return "<img src='"+row.icon+"' style='border: 0px'><span>"+" "+value;
							}
						}else{
							return value
						}
					},
					styler: function(value,row,index){
						if (row._parentId==""){
							//return 'padding-left:2px;';  //#40a2de
						}
					}
				  }, 
				  //{field:'libdr',title:'libdr',hidden:true}, 
				  {field:'count',title:'条数',hidden:true}, 
				  {field:'myhref',title:'路径',hidden:true},   
				  {field:'icon',title:'图标',hidden:true},
				  {field:'id',title:'id',hidden:true},
				  {field:'_parentId',title:'parentId',hidden:true}
				  ]];

	$('#LeftTree').datagrid({ 
		/*pagination: false, 
		pageSize:1000,
		pageList:[1000],*/
		headerCls:'panel-header-gray',
		scrollbarSize :10,
		showHeader:false,
		fitColumns: false,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:LEFT_MENU_URL,
		queryParams:{
			countInfo:countInfo
		},
		singleSelect:true,
		idField:'id', 
		//treeField:'text',
		rownumbers:false,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:leftclumns,
		onClickRow: function(rowIndex, rowData) {		
			addTab(rowData.text,rowData.myhref)
		},
		onLoadSuccess:function(data){
			//隐藏行选择数，只按默认显示15个
			var row = $("#LeftTree").datagrid("getSelected");   //加载中间面板
			if (desc!="")  //如果确定现在要编辑哪个项目
			{
				if ((row)&&(row.text==desc)){  //如果之前编辑的项目和现在要编辑的项目一致
					addTab(row.text,row.myhref)	//重新加载右侧面板
				}
				else  //如果之前编辑的项目和现在要编辑的项目不一致
				{
					var rows = $("#LeftTree").datagrid("getRows");
					for(var i=0;i<rows.length;i++){
			            if (rows[i].text==desc){
			            	$('#LeftTree').datagrid("selectRow", i);   //选中要编辑的项目
			            	addTab(rows[i].text,rows[i].myhref)	   //重新加载右侧面板
			            	break
			            }
			        }
				}
			} 
			else   //如果是点击的最上方的编辑按钮
			{			
				if (row){  //如果之前有编辑的项目
					var flag=false
					for(var i=0;i<data.total;i++){
						if (data.rows[i].text==row.text)
						{ 
							flag=true
						}
					}
					if (flag)
					{
						addTab(row.text,row.myhref)	//重新加载右侧面板
					}
					else
					{
						$('#LeftTree').datagrid("selectRow", 0);  
						var rows = $("#LeftTree").datagrid("getRows");
						addTab(rows[0].text,rows[0].myhref)	
					}
				}
				else{  //如果之前没有编辑的项目，则选中第一行，并加载右侧面板
					$('#LeftTree').datagrid("selectRow", 0);  
					var rows = $("#LeftTree").datagrid("getRows");
					addTab(rows[0].text,rows[0].myhref)	
				}
			}
			
		}
	});
	
}

//动态添加标签页 ——后来去掉了编辑最上面的tab页签。
function addTab(title, myhref){
	/*if ($('#righttabs').tabs('exists', title)){
		$('#righttabs').tabs('select', title);
	} else {*/
		var parm = "?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType
		var url=myhref+parm
		/*if (title=="适应证")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdrugdiseaseind.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="用药频率")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdiseasefreq.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="给药途径")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdiseaseuse.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="不良反应")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdar.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="注意事项")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdmha.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="成分含量(g)")
		{
			var url = "../csp/dhc.bdp.kb.dhcphelecon.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="溶媒量")
		{
			var url = "../csp/dhc.bdp.kb.dhcphmenstruumqty.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="浓度")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdrgsolvent.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="配伍禁忌")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdrugcontrain.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="相互作用")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdiseaseinteract.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="重复用药")
		{
			var url = "../csp/dhc.bdp.kb.dhcphrepeatitm.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="可配伍药品")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdrgalone.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="禁忌证")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdrugdiseasecon.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}	
		else if(title=="用法用量")
		{
			var url = "../csp/dhc.bdp.kb.dhcphusagedosage.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}		
		else if(title=="辅助用药个数")
		{
			var url = "../csp/dhc.bdp.kb.dhcphassdrugnum.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="炮制作用")
		{
			var url = "../csp/dhc.bdp.kb.dhcphprocessingact.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="滴速")
		{
			var url = "../csp/dhc.bdp.kb.dhcphdrippingspeed.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="联合用药")
		{
			var url = "../csp/dhc.bdp.kb.dhcphmustdrug.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else
		{
			var url = myhref + parm;
		}*/
		
		//console.log(url);
		if('undefined'!==typeof websys_getMWToken)
		{
			url+="&MWToken="+websys_getMWToken()
		}
		$('#myiframe').attr("src",url); 
		//alert(url)
		/*var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></
		>'; 
		$('#righttabs').tabs('add',{
			title:title,
			content:content,
			closable:true
		});*/
	//}
}

//关闭全部标签
function closeTabs() {  

	$(".tabs li").each(function(index, obj) {  
		  //获取所有可关闭的选项卡  
		  var tabTitle = $(".tabs-closable", this).text();  
		  $("#righttabs").tabs("close", tabTitle);  
	 });  		  
  
}  

///界面加载代码
function BodyLoadHandler()
{

	//通用名列表
    InitGenList();
	//通用名剂型
	InitGenFormList();
    //商品名列表
	InitProList	();
	//商品名剂型
	InitProFormList();
	
	///药品分类检索框
	InitLibList() ;
	
    //通用名检索
	$('#textDesc').searchbox({
		searcher:function(value,name){
			//alert(value + "," + name)
			GenSearch();
		}
	});
	//通用名新增
	$("#btnGenAdd").click(AddGenWindow)  
	/*$("#btnGenSearch").click(function (e) { 
		GenSearch();
	 }) */   
	//商品名检索
	/*$("#btnProSearch").click(function (e) { 
		ProSearch();
	 }) */  
	$('#textPro').searchbox({
		searcher:function(value,name){
			ProSearch();
		}
	});
	//通用名重置
	$("#btnGenReset").click(function (e) { 
		GenReset();
	 })  
	//商品名重置
	$("#btnProReset").click(function (e) { 
		ProReset();
	 })  	 
	/* //通用名单击事件
	var opt=$("#genGrid").datagrid('options');
	opt.onClickRow=ClickGenGrid
	
    //商品名单击事件
	var opt=$("#proGrid").datagrid('options');
	opt.onClickRow=ClickProGrid*/
	
    //主面板treegrid  
	InitMainList();
	$('#mainGrid').treegrid('loadData', {total:0,rows:[]}); 
	//初始化编辑按钮不可用
	$('#btnDrugEdit').linkbutton('disable');
	//药品编辑按钮
	$("#btnDrugEdit").click(function (e) { 
		/*AddFunWindow();
		getNumbers();
		InitLeftTree();
		setTimeout(function(){
		var row = $("#LeftTree").datagrid("getSelected");   //加载中间面板
		if (row)
		{
			addTab(row.text,row.myhref)	
		}
		},"800");*/
		InitLeftTree("");
		
	}) 
	//医生站端调浏览器
	showData();
	/*
	//初始化编辑页签左侧导航栏
	InitLeftTree();	
	
	$('#maintabs').tabs({  
		  border:false,  
		  fit:true,  
		  onSelect:function(title,index){ 
			if (index=="1"){
				//编辑页签
				getNumbers();   //获取小气泡的显示数字
				QueryLeftTree();  //重新加载编辑页签左侧面板数据
				var row = $("#LeftTree").datagrid("getSelected");   //加载中间面板
				if (row)
				{
					addTab(row.text,row.myhref)	
				}	
				//closeTabs();		
			}else{
				//浏览页签
				QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
				
			}

		  }


	});
	
	if ($('#maintabs').tabs('exists', 1)){
		$('#maintabs').tabs('disableTab', 1);   //一开始编辑按钮不可用
	}*/
	

}
//通用名检索方法
function GenSearch()
{
	//var desc=$.trim($("#textDesc").val());
	var desc=$.trim($('#textDesc').searchbox('getValue'));
	var point=$.trim($('#GlPPointer').combobox('getValue'));
	var cats=$.trim($('#LibType').combotree('getValues'));
	//alert(cats)
	//var point=$.trim($("#GlPPointer").val());
	$('#genGrid').datagrid('load',  { 
		'lib':lib,	
		'desc': desc,
		'point': point,
		'cats':cats
	});
}

//通用名重置方法
function GenReset()
{
	//$("#textDesc").val("")
	$("#textDesc").searchbox('setValue', '');
	$('#GlPPointer').combobox('clear');//清空
	$('#LibType').combotree('clear')
	$('#genGrid').datagrid('load',  { 
		'lib':lib,	
		'desc': "",
		'point': ""
	});
	$('#genGrid').datagrid('unselectAll');
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").show();		 //初始图片展示
}
//商品名检索方法
function ProSearch()
{
	//var desc=$.trim($("#textPro").val());
	var desc=$.trim($("#textPro").searchbox('getValue'));
	var form=$.trim($('#proForm').combobox('getValue'));
	$('#proGrid').datagrid('load',  { 
		'desc': desc,
		'form': form
	});
}
//商品名重置方法
function ProReset()
{
	//$("#textPro").val("")
	$("#textPro").searchbox('setValue', '');
	$('#proForm').combobox('clear');//清空
	$('#proGrid').datagrid('load',  { 
		'desc': "",
		'form': ""
	});
	$('#proGrid').datagrid('unselectAll');
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").show();		 //初始图片消失
}
//加载浏览器数据
function QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType)
{
	$('#mainGrid').treegrid('load',  {  
		'GenDr':GlPGenDr,
		'PointerType':GlPPointerType,
		'PointerDr':GlPPointer
	});
	
	/*$('#mainGrid').treegrid('loadData',{"total":2,"rows":[
		{"id":13,"PHINSTDesc":"相互作用"},
		{"id":11,"PHINSTDesc":"测试相互作用","_parentId":13}
		]
	});*/

}


/**用于Grid中返回组图片**/
//蔡昊哲   谷雪萍修改-显示顺序2017-08-29
ReturnFlagIcon = function(value)
{
	var returnValue = "";
	//var value=parseInt(value);
	switch(value)
	{
	  case "成分含量(g)":  //"成分含量(g)"  <span style='font-size:24px'>
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/zzndhl.png' style='border: 0px'><span style='font-size:16px'>"+"【成分含量(g)】"+"</span>";
	  break;
	  case "适应证": //"适应证"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/syz.png' style='border: 0px'><span style='font-size:16px'>"+"【适应证】"+"</span>";
	  break;
	  case "用法用量":  //"用法用量"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/yfyl.png' style='border: 0px'><span style='font-size:16px'>"+"【用法用量】"+"</span>";
	  break;
	  case "溶媒量":  //"溶媒量"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/rml.png' style='border: 0px'><span style='font-size:16px'>"+"【溶媒量】"+"</span>";
	  break;
	  case "浓度": //"浓度"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lcyy.png' style='border: 0px'><span style='font-size:16px'>"+"【浓度】"+"</span>";
	  break;
	  case "给药途径":  //"给药途径"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/yyff.png' style='border: 0px'><span style='font-size:16px'>"+"【给药途径】"+"</span>";
	  break;		  
	  case "用药频率":  //"用药频率"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/yypl.png' style='border: 0px'><span style='font-size:16px'>"+"【用药频率】"+"</span>";
	  break;
	  case "滴速":  //"滴速"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/ds.png' style='border: 0px'><span style='font-size:16px'>"+"【滴速】"+"</span>";
	  break;
	  case "不良反应":  //"不良反应"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/blfy.png' style='border: 0px'><span style='font-size:16px'>"+"【不良反应】"+"</span>";
	  break;
	  case "禁忌证":  //"禁忌证"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/jjz.png' style='border: 0px'><span style='font-size:16px'>"+"【禁忌证】"+"</span>";
	  break;
	  case "配伍禁忌":  //"配伍禁忌"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/jj.png' style='border: 0px'><span style='font-size:16px'>"+"【配伍禁忌】"+"</span>";
	  break;
	  case "注意事项":  //"注意事项"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/zysx.png' style='border: 0px'><span style='font-size:16px'>"+"【注意事项】"+"</span>";
	  break;		  
	  case "相互作用":  //"相互作用"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/xhzy.png' style='border: 0px'><span style='font-size:16px'>"+"【相互作用】"+"</span>";
	  break;
	  case "可配伍药品":  //"可配伍药品"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/ddyy.png' style='border: 0px'><span style='font-size:16px'>"+"【可配伍药品】"+"</span>";
	  break;
	  case "联合用药":  //"联合用药"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lhyy.png' style='border: 0px'><span style='font-size:16px'>"+"【联合用药】"+"</span>";
	  break;
	  case "辅助用药个数":  //"辅助用药个数"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/fzyygs.png' style='border: 0px'><span style='font-size:16px'>"+"【辅助用药个数】"+"</span>";
	  break;
	  case "重复用药":  //"重复用药"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/cfyy.png' style='border: 0px'><span style='font-size:16px'>"+"【重复用药】"+"</span>";
	  break;
	  case "炮制作用":  //"炮制作用"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/pzzy.png' style='border: 0px'><span style='font-size:16px'>"+"【炮制作用】"+"</span>";
	  break;
	  /*case "别称":
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/Alias32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
	  break;*/
	  default:  //"其他"
	  returnValue = "<span style='font-size:16px'>"+"【其他】"+"</span>";
	} 
	//return returnValue;
	return returnValue+"<a class='editbutton' onclick='InitLeftTree(\""+value+"\")'></a>";
}	

var winwidth=window.screen.width-280 //定义展开属性内容的宽带
var winheight=window.screen.height-240 //定义展开属性内容的高度	
//编辑弹框	
AddFunWindow= function(Fn)
{	
	$("#myWin").show();
	$('#myWin').window({ 
		 width:winwidth,
         height: winheight,
		 title:GenDesc,
		 minimizable:false,
		 maximizable:false,
		 collapsible:false,  
		 modal:true,
		 onClose:function(){
		 	QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
		 }
	});

	
}

AddGenWindow= function(Fn)
{	
	$('#addGenWin').dialog({ 
		 title:'添加药品到列表',
		 minimizable:false,
		 maximizable:false,
		 collapsible:false,
		 width:400,   
		 height:300,   
		 modal:true,
		 buttons:[{
			text:'保存',
			handler:function(){
				var genid=$.trim($('#GlPGenDrF').combobox('getValue'));
				var pointid=$.trim($('#GlPPointerF').combobox('getValues'));
				if (genid=="")
				{
					$.messager.alert('错误提示','通用名不能为空!',"error");
					return;
				}
				if (pointid=="")
				{
					$.messager.alert('错误提示','剂型不能为空!',"error");
					return;
				}
				$('#Genform').form('submit', { 
					url: SAVE_GEN_ACTION_URL, 
					onSubmit: function(param){
						param.GlPPointer=pointid
						param.GlPActiveFlag = "Y",
						param.GlPSysFlag = "Y"
					},
					success: function (data) { 
						var data=eval('('+data+')'); 
						if (data.success == 'true') {
							$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
							GenSearch();  // 重新载入当前页面数据  
							$HUI.dialog('#addGenWin').close();
						} 
						else { 
							var errorMsg ="更新失败！"
							if (data.errorinfo) {
								errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
							}
							$.messager.alert('操作提示',errorMsg,"error");

						}

					} 
				  }); 	
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#addGenWin').close();
			}
		}]
	});
	
	$('#GlPGenDrF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCBusMainNew&QueryName=GetGenForCmb1&ResultSetType=array&code=DRUG",
		valueField:'PHEGRowId',
		textField:'PHEGDesc',
		required:'true'
	});
	$('#GlPPointerF').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.KB.DHCPHExtForm&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHEFRowId',
		textField:'PHEFDesc',
		multiple:true,   //多选
		required:'true'
	});


}