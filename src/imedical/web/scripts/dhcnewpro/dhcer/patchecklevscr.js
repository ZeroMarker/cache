//===========================================================================================
// 作者：      sunhe
// 编写日期:   2022-08-15
// 描述:	   院前院内衔接平台
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgParams=LgUserID+"^"+LgLocID+"^"+LgHospID;
var EpisodeID="";
function initPageDefault(){
	
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageStyle();          /// 初始化页面样式
	initMap("")   //初始化地图
}

/// 初始化页面样式
function InitPageStyle(){
	
	$("#LisPanel").css({"height":$(document).height()-50});
	$("#dgEmPatList").datagrid("resize");

}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 开始日期
	$HUI.datebox("#CstStartDate").setValue(GetCurSystemDate(-1));
	
	/// 结束日期
	$HUI.datebox("#CstEndDate").setValue(GetCurSystemDate(0));
	
	///tabs 
	$HUI.tabs("#tabs",{
		onSelect:function(tabTitle){
			var rowData = $("#dgEmPatList").datagrid('getSelected'); //选中要删除的行
			if (rowData != null) {
				EpisodeID = rowData.EpisodeID;
			}
 			selectTab(tabTitle, EpisodeID);
		}
	});
}

function selectTab(tabTitle, EpisodeID){
	if(tabTitle=="基本信息"){
		initPatInf(EpisodeID)
	}
	else if(tabTitle=="心电图"){
		initXd(EpisodeID)
	}
	else if(tabTitle=="心电照片"){
		initXdPhoto(EpisodeID)
	}else if(tabTitle=="超声"){
    	initCs(EpisodeID)
    }else if(tabTitle=="地图"){
		initMap()
	}else if(tabTitle=="远程会诊"){
		initYchz(EpisodeID, "");
	}
}

/// 页面DataGrid初始定义11
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'患者列表',width:205,formatter:setCellLabel,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			var tab = $("#tabs").tabs("getSelected");    //获取选中的标签页面板
    		var tabObj = tab.panel('options').tab;          //相应的标签页对象
    		var tabTitle = tabObj[0].innerText;             //相应的标签页内容
    		selectTab(tabTitle, rowData.EpisodeID);
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            if (data.rows.length != 0) {
		       $('#dgEmPatList').datagrid("selectRow", 0); 
		       
		       var tab = $("#tabs").tabs("getSelected");    //获取选中的标签页面板
    		   var tabObj = tab.panel('options').tab;          //相应的标签页对象
    		   var tabTitle = tabObj[0].innerText;             //相应的标签页内容
		       selectTab(tabTitle, data.rows[0].EpisodeID);
		    } 
   
		},
		rowStyler:function(index,rowData){   
	
	    }
	};

	var params = LgParams+"^^^^"
	var uniturl = LINK_CSP+"?ClassName=web.DHCERPreinJoin&MethodName=GetErPatList&Params="+params;
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  隐藏分页图标
    var panel = $("#dgEmPatList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){	
	
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName +'</h3>';
	htmlstr = htmlstr +'<h3 style="position:absolute;right:0;background-color:transparent;"><span>'+ rowData.PatNo +'</span></h3><br>';
	htmlstr = htmlstr +'<h4 style="position:absolute;left:0;background-color:transparent;">'+ rowData.PatAge +'</h4>';
	htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;">'+ rowData.EMDispJud +'</h4><br>';
	htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.PAAdmDate+" "+rowData.PAAdmTime+'</h4>';
	htmlstr = htmlstr + '<br>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 查询申请单列表
function QryCons(){
	
	var CstStartDate = $HUI.datebox("#CstStartDate").getValue(); /// 开始日期
	var CstEndDate = $HUI.datebox("#CstEndDate").getValue();     /// 结束日期
	var PatNo = $("#PatNo").val();    /// 登记号
	var PatName = $("#PatName").val();    /// 病人姓名
   /// 重新加载会诊列表
	var params = LgParams+"^"+CstStartDate+"^"+CstEndDate+"^"+PatNo+"^"+PatName;
	$("#dgEmPatList").datagrid("load",{"Params":params});
}

/// 重新加载会诊列表
function reLoadEmPatList(){
	$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
}

/// 刷新主页面数据
function reLoadMainPanel(){
	reLoadEmPatList(); /// 重新加载会诊列表
}

function btn_More_Click(){
	
	if ($(".more-panel").is(":hidden")){
		$(".more-panel").css("display","block");
		$("#LisPanel").height($("#LisPanel").height()-180);
		$("#dgEmPatList").datagrid("resize");
	}else{
		$(".more-panel").css("display","none");
		$("#LisPanel").height($("#LisPanel").height()+180);
		$("#dgEmPatList").datagrid("resize");
	}
}
/// 患者信息
function initPatInf(EpisodeID){	
	var url="dhcer.patprehosinf.csp?EpisodeID="+EpisodeID
	$("#patInf").attr("src",url)
}
/// 初始化地图
function initMap(method, params){
	
//	var Link = "dhcer.defaulthome.csp?message=未检测到地图连接，请检查链接配置！";
//	$('#map').html('<iframe id="mapframe" src="'+ Link +'" width="100%" height="100%" style="border:0"/>');
	var Link = "dhcer.larscrmap.csp";
	$('#map').html('<iframe id="mapframe" src="'+ Link +'" width="100%" height="100%" style="border:0"/>');
}

//心电
function initXd(patno){
	
	//var Link = "dhcer.defaulthome.csp?message=未检测到设备连接，请检查链接配置！";
	var Link="../scripts/dhcnewpro/dhcer/pdf/xd.pdf";  
	$("#xd").attr("src",Link)
}

//心电照片
function initXdPhoto(EpisodeID){	

	var url = "dhcer.ecgshow.csp";
	$("#xdPhoto").attr("src",url)
}
//超声
function initCs(EpisodeID){	
	var url="dhcer.ultimgview.csp?EpisodeID="+EpisodeID 
	$("#cs").attr("src",url)
}
//远程会诊
function initYchz(admDr,SN){
		
	var url="dhcer.remoteconsultations.csp?admDr="+admDr+"&SN="+SN+"&flag=1";
	$("#consult").attr("src",url)
//	var url="dhcer.remoteconsultations.csp?admDr="+admDr+"&SN="+SN+"&flag=1"
//	window.open(url); 
}
/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 自动设置页面布局
function onresize_handler(){
	$.parser.parse($('#tabmain'));  /// 重新解析	
}

window.onresize = onresize_handler;
/// JQuery 初始化页面
$(function(){ initPageDefault(); })