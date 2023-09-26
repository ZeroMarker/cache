//Create by dongzt
// 2015016
//�?求统计分�?
function InitviewScreenEvent(obj) {
	
	obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		
		
		
		//obj.StatDataGridPanel.on("rowclick", obj.StatDataGridPanel_rowclick, obj);
	};
	
	obj.btnQuery_OnClick = function(){
		obj.StatDataGridPanelStore.removeAll();
		obj.StatDataGridPanelStore.load({});
		
		/* obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({}); */
	}
	obj.StatDataGridPanel_rowclick=function(){
		
		
		var record = obj.StatDataGridPanel.getSelectionModel().getSelections();
		
		var clickone =obj.StatDataGridPanel.getSelectionModel().getSelected();//获取�?�?
		clickone.get("TDesc");取出数据
		
		
		
		
	}
	
	
	
}