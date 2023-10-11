///****************************************
//*	Author: 		qunianpeng
//*	Create: 		2020/03/18
//*	Description:	批量数据下载
///****************************************
/// 页面初始化函数
function initPageDefault(){
	
}


function DownData()
{
	var tmppid=0
	runClassMethod("web.DHCCKBPrescTest","GetOrderPid",{},function(val){
		 tmppid=val	
	},"",false)

	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"批量测试数据", //默认DHCCExcel
		ClassName:"web.DHCCKBPrescTest",
		QueryName:"ExportOrderMsg",
		pid:tmppid //505074
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;

}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
