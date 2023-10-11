/**
	kemaolin
	2020-03-31
	流量中心 flowcenter.js
*/
$(function(){
	initDateBox();
	initDatagrid();
	initBtn();
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
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBMonMaster&MethodName=QueryMesterList',
		queryParams:{
			'stdate':stdate,
			'eddate':eddate,
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
		'hosp':LgHospDesc
	});
}

///设置操作明细连接
function queryDetail(value, rowData, rowIndex){
	var btn = "<a title='详情' class='icon icon-compare' style='cursor:pointer;color:#000;display:inline-block;width:16px;height:16px' onclick=\"addProgressNote('"+rowData.RowID+"')\"></a>" 
    return btn;  	
}
///设置操作明细连接
function queryResult(value, rowData, rowIndex){
	var btn = "<a title='结果' class='icon icon-compare' style='cursor:pointer;color:#000;display:inline-block;width:16px;height:16px' onclick=\"initView('"+rowData.RowID+"')\"></a>" 
    return btn;  	
}

function initView(RowID){
	//alert(RowID);
	var pdss = new PDSS({});
	var PdssObj = {};
	PdssObj.MsgID=RowID;
	PdssObj.CheckFlag = "N";
	PdssObj.AuditState = "0";
	//alert(PdssObj.lmID);
	pdss.refresh(PdssObj, null, 1);  /// 调用审查接口
	if(pdss.passFlag == 0) {  
          
	    /// do something  
	    return;  
    }  

}

//病程记录弹框
function addProgressNote(RowID){
	commonShowWin({
		url:'dhcckb.problemscenter.csp', //'dhcckb.checkdetail.csp?RowID='+RowID,
		title:'审查记录',
		height:600,
		width:1100
	})
}

/**
* 公共弹出界面
* @author zhouxin
*/
function commonShowWin(option){
		
		var content = '<iframe src="'+option.url+'" scrolling="auto" width="100%" height="98%" frameborder="0" scrolling="no"></iframe>';
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