/*
Creator:GuXueping
CreatDate:2018-01-09
Description:检验项目编辑器
*/
///通用名列表
var lib="LAB"
var GlPGenDr=""
var GlPPointer=""
var GlPPointerType="Form"
var GenDesc=""
var countInfo=""  //小气泡显示的条数
 

var showData = function(){
   
	//如果是医生站调用该界面，则左侧面板隐藏
	if ((GenCode!= "")&(PointerCode!=""))
	{

		var Pdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",GenCode);
		var PFdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",PointerCode);
		
		var GlPGenDr = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",GenCode);
		var GlPPointer = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",PointerCode);
		
		//alert(GlPPointer+"^"+GlPGenDr+"^"+Pdesc+"^"+PFdesc);
		
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
				  {field:'PHEGDesc',title:'检验项目',width:180},
				  {field:'PHEFDesc',title:'标本',width:80}, 
				  {field:'GlPGenDr',title:'通用名Dr',width:30,hidden:true},
				  {field:'GlPPointer',title:'标本Dr',width:30,hidden:true},
				  {field:'GlPRowId',title:'GlPRowId',width:30,hidden:true}
				  ]];

	$('#genGrid').datagrid({ 
		width:'100%',
		height:'100%', 
		toolbar:'#genbar', //上工具栏,空为null
		pagination: true, 
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		fitColumns: true,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:GEN_QUERY_ACTION_URL,
		singleSelect:true,
		idField:'GlPRowId', 
		rownumbers:true,
		fixRowNumber:true,
		displayMsg:"",
		showRefresh:false,
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
	GenDesc=Pdesc+"/"+PFdesc;
	$("#drugDesc").html(GenDesc);
	GlPGenDr = rowData.GlPGenDr;
	GlPPointer =rowData.GlPPointer;
	GlPPointerType="Form" ;
	var input=GlPGenDr+"^"+GlPPointer+"^"+GlPPointerType;
	QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
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
		showHeader:false,
		pagination: false, 
		pageSize:1000,
		pageList:[1000],
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
	if ((GenCode!= "")&(PointerCode!=""))
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
	  case "相互作用":  //"相互作用"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/xhzy.png' style='border: 0px'><span style='font-size:16px'>"+"【相互作用】"+"</span>";
	  break;
	  case "临床意义":  //"临床意义"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lcyy.png' style='border: 0px'><span style='font-size:16px'>"+"【临床意义】"+"</span>";
	  break;
	  case "检验结果辅助诊断":  //"检验结果辅助诊断"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/fzzd.png' style='border: 0px'><span style='font-size:16px'>"+"【检验结果辅助诊断】"+"</span>";
	  break;
	
	  default:  //"其他"
	  returnValue = "<span style='font-size:16px'>"+"【其他】"+"</span>";
	} 
	return returnValue;
}	
	
