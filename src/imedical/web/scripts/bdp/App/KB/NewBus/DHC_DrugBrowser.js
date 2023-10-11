/*
Creator:GuXueping
CreatDate:2017-12-01
Description:知识库浏览器
*/
///通用名列表
var lib="DRUG"
var countInfo=""  //小气泡显示的条数
var GEN_FORM_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetGenFormCombo";
var CAT_TREE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetTreeProComboJson&lib=DRUG";

//医生站传过来通用名代码+剂型代码，则只展示该通用名+剂型的数据
var showData = function(){
	
	//如果是医生站调用该界面，则左侧面板隐藏
	var Pdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",GenCode);  //通用名描述
	var PFdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getFormDesc",PointerCode);  //剂型描述
	
	var GlPGenDr = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",GenCode);     //通用名id
	var GlPPointer = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getFormRowId",PointerCode);  //剂型id
	var GlPPointerType="Form"
	
	//alert(GlPPointer+"^"+GlPGenDr+"^"+Pdesc+"^"+PFdesc);
	
	if ((Pdesc=="") || (PFdesc=="") || (GlPGenDr=="-1") ||(GlPPointer=="-1"))
	{
		GenDesc = "未查询到该药品说明书"
	}
	else
	{
		document.getElementById('mainGrid').style.display='';  //显示mygrid
		$("#div-img").hide();		 //初始图片消失
		GenDesc=Pdesc+"/"+PFdesc
		QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
	}
				
	$("#drugDesc").html(GenDesc);
			
		
}

//医生站传过来商品名代码，则只展示该商品名的数据
var showProData = function(){
	
	var GlPPointer = "0"
	var GlPPointerType="ProName"		
	var proInfo= tkMakeServerCall("web.DHCBL.KB.DHCPHProContrast","getProInfo",ProCode);
	var prostr = proInfo.split("[N]");	
	var GlPGenDr=prostr[0];  //商品名id
	var GenDesc=prostr[1];  //商品名描述
	var factory=prostr[2];  //商品名厂家
	var formInfo=eval('('+formInfo+')'); 
	
	if ((GlPGenDr=="") || (GenDesc==""))
	{
	   if ((GenCode!= "")&(PointerCode!=""))  //如果没有商品名则展示通用名
	   {
		  showData();
	   }
		
	}
	else
	{
		if(factory.indexOf("-") > 0 )
		{
		   factory = factory.split("-")[1];
		}		
		if (factory=="")
		{
			GenDesc ="<h2 style='color:black;'>"+GenDesc+"</h2>"
		}
		else
		{
			GenDesc ="<h2 style='color:black; margin-bottom: 1px; margin-top: 2px;'>"+GenDesc+"</h2><h3 style='color:black;margin-top: 2px;background-color: #fff;text-align:center;'>"+factory+"</h3>"
		}

		document.getElementById('mainGrid').style.display='';  //显示mygrid
		$("#div-img").hide();		 //初始图片消失
		QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
	}

	$("#drugDesc").html(GenDesc);
		
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
	var Pdesc=rowData.PHEGDesc;
	var PFdesc=rowData.PHEFDesc;
	var GenDesc=Pdesc+"/"+PFdesc;
	$("#drugDesc").html("<h2 style='color:black;'>"+GenDesc+"</h2>");
	//$("#drugDesc").html(GenDesc);
	var GlPGenDr = rowData.GlPGenDr;
	var GlPPointer =rowData.GlPPointer;
	var GlPPointerType="Form" ;
	//var input=GlPGenDr+"^"+GlPPointer+"^"+GlPPointerType;
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
	var GenDesc=rowData.PHNDesc;

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
	var GlPGenDr = rowData.PHNRowId;
	var GlPPointer ="0";
	var GlPPointerType="ProName";
	//var input=GlPGenDr+"^"+GlPPointer+"^"+GlPPointerType;
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
				  {field:'PHINSTDesc',title:'',
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
			//去掉treegrid结点前面的文件及文件夹小图标
			$("#mainGridDiv .tree-icon,#mainGridDiv .tree-file").removeClass("tree-icon tree-file");
			$("#mainGridDiv .tree-icon,#mainGridDiv .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
		}
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
	 
	//如果医生站传过来商品名代码、或者通用名+剂型的代码
	if ((ProCode!="")||((GenCode!= "")&(PointerCode!="")))
	{
		$('#mainlayout .layout-panel-west').css('display','none'); 
		$("#mainlayout").layout("resize");
	}
    //主面板treegrid  
	InitMainList();
	$('#mainGrid').treegrid('loadData', {total:0,rows:[]}); 
	
	//如果医生站传过来商品名代码则展示商品名数据
	if(ProCode!="")
	{
		showProData();
	}
	else  //如果医生站没有传过来商品名代码
	{
		//通用名和剂型数据不为空则显示通用名+剂型数据
		if ((GenCode!= "")&(PointerCode!=""))
		{
			showData();
		}
		
	}
	


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
	return returnValue;
}	
	


