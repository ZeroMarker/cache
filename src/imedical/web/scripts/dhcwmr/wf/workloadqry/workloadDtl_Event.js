function InitWorkDtlWinEvent(obj) {
	obj.LoadEvent = function(args){
		obj.WorkDtlGridPanelStore.load({});
		obj.btnExport.on('click',obj.btnExport_click,obj);
	};
	
	obj.btnExport_click = function (){
		if (obj.WorkDtlGridPanelStore.getCount()<1) {
			window.alert("请先查询再导出Excel!");
			return;
		}
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
			ExprotGrid(obj.WorkDtlGridPanel,'工作量统计明细');
		}else{
			ExprotGridStrNew(obj.WorkDtlGridPanel,'工作量统计明细');
		}
	}
}
function WorkDtlLookUpHeader(aParam,aUserID,aWFItemID,winTitle)
{
	var objWorkDtlWin = new InitWorkDtlWin(aParam,aUserID,aWFItemID,winTitle);
	objWorkDtlWin.WorkDtlWin.show();
}