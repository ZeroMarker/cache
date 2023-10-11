/*
Creator:GuXueping
CreatDate:2018-01-09
Description:内镜项目编辑器
*/
///通用名列表
var lib="ENDO"
var GlPGenDr=""
var GlPPointer=""
var GlPPointerType="Form"
var GenDesc=""
var countInfo=""  //小气泡显示的条数
var showData = function(){
   
	//如果是医生站调用该界面，则左侧面板隐藏
	if (GenCode!= "")
	{
		var Pdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",GenCode);
		var PFdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getPartDesc",PointerCode);

		var GlPGenDr = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",GenCode);
		var GlPPointer = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getPartRowId",PointerCode);
		
		//alert(GlPPointer+"^"+GlPGenDr+"^"+Pdesc+"^"+PFdesc);
		if ((Pdesc=="") || (PFdesc=="") || (GlPGenDr=="-1") ||(GlPPointer=="-1"))
		{
			GenDesc = "未查询到该内镜项目说明书"
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
				  {field:'PHEGDesc',title:'内镜项目',width:180},
				  {field:'PHEFDesc',title:'部位',width:80}, 
				  {field:'GlPGenDr',title:'通用名Dr',width:30,hidden:true},
				  {field:'GlPPointer',title:'部位Dr',width:30,hidden:true},
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
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").hide();		 //初始图片消失
	var Pdesc=rowData.PHEGDesc;
	var PFdesc=rowData.PHEFDesc;
	GenDesc=Pdesc+"/"+PFdesc;
	$("#drugDesc").html(GenDesc);
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
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:1000,
		pageList:[1000],
		showHeader:false,
		toolbar:'#mainbar',
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:MAIN_QUERY_ACTION_URL,
		singleSelect:true,
		idField:'id', 
		treeField:'PHINSTDesc',
		rownumbers:false,
		fit:true,
		remoteSort:false,
		//sortName:"EpisodeID",
		columns:mainclumns,
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

	
    //通用名检索
	$('#textDesc').searchbox({
		searcher:function(value,name){
			//alert(value + "," + name)
			GenSearch();
		}
	});

	//通用名重置
	$("#btnGenReset").click(function (e) { 
		GenReset();
	 })  
	 
	//如果别的组调说明书，则隐藏左侧面板，只显示一条数据的说明书
	if (GenCode!= "")
	{
		$('#mainlayout .layout-panel-west').css('display','none'); 
		$("#mainlayout").layout("resize");
	} 	 
	
    //主面板treegrid  
	InitMainList();
	$('#mainGrid').datagrid('loadData', {total:0,rows:[]}); 
	

	//医生站端调浏览器
	showData();
}
//通用名检索方法
function GenSearch()
{
	//var desc=$.trim($("#textDesc").val());
	var desc=$.trim($('#textDesc').searchbox('getValue'));
	$('#genGrid').datagrid('load',  { 
		'lib':lib,	
		'desc': desc
	});
}

//通用名重置方法
function GenReset()
{
	//$("#textDesc").val("")
	$("#textDesc").searchbox('setValue', '');
	$('#genGrid').datagrid('load',  { 
		'lib':lib,	
		'desc': ""
	});
	$('#genGrid').datagrid('unselectAll');
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").show();		 //初始图片展示
}

//加载浏览器数据
function QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType)
{
	$('#mainGrid').treegrid('load',  {  
		'GenDr':GlPGenDr,
		'PointerType':GlPPointerType,
		'PointerDr':GlPPointer
	});

}


/**用于Grid中返回组图片**/
//蔡昊哲   谷雪萍修改-显示顺序2017-08-29
ReturnFlagIcon = function(value)
{
	var returnValue = "";
	switch(value)
	{

	  case "适应证": //"适应证"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/syz.png' style='border: 0px'><span style='font-size:16px'>"+"【适应证】"+"</span>";
	  break;
	  case "禁忌证":  //"禁忌证"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/jjz.png' style='border: 0px'><span style='font-size:16px'>"+"【禁忌证】"+"</span>";
	  break;
	  case "注意事项":  //"注意事项"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/zysx.png' style='border: 0px'><span style='font-size:16px'>"+"【注意事项】"+"</span>";
	  break;		  
	  case "不良反应":  //"不良反应"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/blfy.png' style='border: 0px'><span style='font-size:16px'>"+"【不良反应】"+"</span>";
	  break;
	  case "临床意义":  //"临床意义"  20200728-深圳肿瘤加临床意义、相互作用页签
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lcyy.png' style='border: 0px'><span style='font-size:16px'>"+"【临床意义】"+"</span>";
	  break;
	  case "相互作用":  //"相互作用"  20200728-深圳肿瘤加临床意义、相互作用页签
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/xhzy.png' style='border: 0px'><span style='font-size:16px'>"+"【相互作用】"+"</span>";
	  break;
	  default:  //"其他"
	  returnValue = "<span style='font-size:16px'>"+"【其他】"+"</span>";
	} 
	return returnValue;
}	

