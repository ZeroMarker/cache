//===========================================================================================
// Author：      qunianpeng
// Date:		 					2020-05-10
// Description:	 新版临床知识库-通用通用名自动生成分类
//===========================================================================================


/// 页面初始化函数
function initPageDefault(){

}

function SetDrugCat(){

	var Result = "";
	runClassMethod("web.DHCCKBUtil","SetDrugCatByGenerName",{},function(retString){
							if (retString == 1){
									Result = "操作成功！";
							}else
							{
								Result = "操作失败！";	
							}
		},'text',false);
		$.messager.popover({msg: Result,type:'success',timeout: 1000});
		OutPutRecord();	
	
}

function OutPutRecord(){
				var rtn = $cm({
					dataType:'text',
					ResultSetType:"Excel",
					ExcelName:"通用名生成分类数据", //默认DHCCExcel
					ClassName:"web.DHCCKBUtil",
					QueryName:"OutPutRecord"		
				},false);
				location.href = rtn;

}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
