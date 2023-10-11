/*
Creator:GuXueping
CreatDate:2018-01-09
Description:心电项目编辑器
*/
///通用名列表
var lib="ELECT"
var GlPGenDr=""
var GlPPointer=""
var GlPPointerType="Form"
var GenDesc=""
var countInfo=""  //小气泡显示的条数

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
				  {field:'PHEGDesc',title:'心电项目',width:180},
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
	//编辑按钮可用
	document.getElementById('mainGrid').style.display='';  //显示mygrid
	$("#div-img").hide();		 //初始图片消失
	$('#btnDrugEdit').linkbutton('enable');
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
		'countInfo':countInfo
	});

}

///创建左侧菜单树
function InitLeftTree(desc)
{
	AddFunWindow();  //弹出弹框
	getNumbers();    //获取气泡数量
	var LEFT_MENU_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetMenuNew"+"&code="+lib;
	var leftclumns=[[ 
				  {field:'text',title:'',width:'140',
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
							return 'padding-left:10px;';  //#40a2de
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
		width:'100%',
		height:'100%', 
		pagination: false, 
		pageSize:1000,
		pageList:[1000],
		headerCls:'panel-header-gray',
		scrollbarSize :0,
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
					addTab(row.text,row.myhref)	//重新加载右侧面板
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
			var url = "../csp/dhc.bdp.kb.dhcecgdiseaseind.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="禁忌证")
		{
			var url = "../csp/dhc.bdp.kb.dhcecgdiseasecon.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}	
		else if(title=="不良反应")
		{
			var url = "../csp/dhc.bdp.kb.dhcecgar.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="注意事项")
		{
			var url = "../csp/dhc.bdp.kb.dhcecgmha.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
		}
		else if(title=="相互作用")
		{
			var url = "../csp/dhc.bdp.kb.dhcecginteract.csp"+"?GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType;
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
		/*var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>'; 
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
	 
	
    //主面板treegrid  
	InitMainList();
	$('#mainGrid').datagrid('loadData', {total:0,rows:[]}); 
	
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
	/*//初始化编辑页签左侧导航栏
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
	  case "相互作用":  //"相互作用"
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/xhzy.png' style='border: 0px'><span style='font-size:16px'>"+"【相互作用】"+"</span>";
	  break;
	  case "临床意义":  //"临床意义"  20200728-深圳肿瘤加临床意义、相互作用页签
	  returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lcyy.png' style='border: 0px'><span style='font-size:16px'>"+"【临床意义】"+"</span>";
	  break;
	  default:  //"其他"
	  returnValue = "<span style='font-size:16px'>"+"【其他】"+"</span>";
	} 
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
		 	QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType)
		 }
	});
}