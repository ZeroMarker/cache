function InitLateDtlWinEvent(obj) {
	obj.LoadEvent = function(args){
		obj.LateDtlGridPanelStore.load({});
		obj.btnExport.on('click',obj.btnExport_click,obj);
	};
	
	obj.btnExport_click = function (){
		if (obj.LateDtlGridPanelStore.getCount()<1) {
			window.alert("无数据记录可导出!");
			return;
		}
		if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
			ExprotGrid(obj.LateDtlGridPanel,obj.winTitle);
		}else{
			ExprotGridStrNew(obj.LateDtlGridPanel,obj.winTitle);	
		}
	}
}
function LateDtlLookUpHeader(aParam,winTitle)
{
	var objLateDtlWin = new InitLateDtlWin(aParam,winTitle);
	objLateDtlWin.LateDtlWin.show();
}