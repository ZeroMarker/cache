///****************************************
//*	Author: 		qunianpeng
//*	Create: 		2020/03/18
//*	Description:	������������
///****************************************
/// ҳ���ʼ������
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
		ExcelName:"������������", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBPrescTest",
		QueryName:"ExportOrderMsg",
		pid:tmppid //505074
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;

}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
