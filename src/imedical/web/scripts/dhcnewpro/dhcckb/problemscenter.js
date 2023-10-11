//problemscenter.js
//问题中心

var library = "";

$(function(){	
	initDateBox();
	initDatagrid();
	initBtn();
	initParams();
})

///初始化事件控件
function initDateBox(){
	$HUI.datebox("#stdate").setValue(formatDate(0));
	$HUI.datebox("#eddate").setValue(formatDate(0));
}

//初始化表格
function initDatagrid(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$("#datagrid").datagrid({
		nowrap:false,
		border:false,
		rownumbers:true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBMonMaster&MethodName=QueryMonQueList'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
		queryParams:{
			'stdate':stdate,
			'eddate':eddate,
			'library':library,
			'hosp':LgHospDesc
			},
		//fitColumns:true,
		singleSelect:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,100]	
	})
}

//初始化按钮
function initBtn(){
	$("#searchBTN").click(function(){
		search();	
	});
}

//表格查询
function search(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$('#datagrid').datagrid('load',{
		'stdate':stdate,
		'eddate':eddate,
		'library':library,
		'hosp':LgHospDesc
	});
}

///设置操作明细连接
function queryDetail(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='详情' onclick=\"addProgressNote('"+rowData.RowID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  	
}
///设置操作明细连接
function queryResult(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='结果' onclick=\"initView('"+rowData.RowID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  	
}

function initView(RowID){
	runClassMethod("web.DHCCKBMonMaster","QueryCheckResult",{"id":388},function(data){
		if(data!=""){
			var InreViewObj = new InreView({});
			InreViewObj.refreshNew(data.items, SetItemWarnFlag, 1); /// 审查
		}	
	},"json");
}
/// 知识库回调函数
function SetItemWarnFlag(itemWarnObj){
	

}
//病程记录弹框
function addProgressNote(RowID){

	commonShowWin({
		url:'dhcckb.checkdetail.csp?RowID='+RowID+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
		title:'病程记录',
		height:600,
		width:1100
	})
}

/**
* 公共弹出界面
* @author zhouxin
*/
function commonShowWin(option){
		
		var linkurl = option.url;
		linkurl += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
		var content = '<iframe src="'+linkurl+'" scrolling="auto" width="100%" height="98%" frameborder="0" scrolling="no"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1110,
			height: 600,
			closed: false,
			content: content,
			modal: true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}
function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}

/// 接收链接参数
function initParams(){
		var checkFlag =  getParam("checkFlag");  
		if (checkFlag == "monitor"){	// 监测中心调用 
					setParams();
					library  = getParam("library");  
					search(); 
			}else{
					library = "";
			}
}

/// 监测中心界面调用明细，设置参数
function setParams(){
	
		$HUI.datebox("#stdate").setValue(formatDate(-7));
		$HUI.datebox("#eddate").setValue(formatDate(0));		
		$("#toolbar").hide();
}