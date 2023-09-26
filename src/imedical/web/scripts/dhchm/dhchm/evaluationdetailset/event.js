function InitMainWindowEvent(obj){

    var TableED = ExtTool.StaticServerObject("web.DHCHM.EvaluationDetailSet");
    obj.LoadEvent = function(args){
    };
    obj.EDSave_click = function(){
        if (!obj.FormPanelED.getForm().isValid()) {
            ExtTool.alert("提示", "请检查必填项！");
            return;
        }
        var id = obj.EDID.getValue();
        
        var property = 'EDActive^EDCode^EDDataSource^EDDesc^EDSex^EDType^EDUnit';
        
        var tmp = ExtTool.GetValuesByIds(property);
        try {
            var ret = TableED.EDSave(id, tmp, property);
            if (ret.split("^")[0] == -1) {
                ExtTool.alert("失败", ret.split("^")[1]);
                return;
            }
            else {
                obj.EDID.setValue(ret);
                ExtTool.FormToGrid(id, obj.GridPanelED, obj.FormPanelED);
				if(id==''){
					obj.EDClear_click();
				}
                else{
					obj.WindowED.close();
				};
            }
        } 
        catch (err) {
            ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
        }
    };
	obj.EDClear_click = function(){
        obj.FormPanelED.getForm().reset();
        obj.EDCode.focus(true, 3);
    };
}

function InitMainPanelEvent(obj){
	var EType = '20011005';
    obj.LoadEvent = function(args){
    }
    
    obj.GridPanelED_rowdblclick = function(g, row, e){

        var winobj = new InitMainWindow();
        winobj.WindowED.show();
        var record = obj.GridPanelED.getStore().getAt(row);
        winobj.FormPanelED.getForm().loadRecord(record);
		winobj.GridPanelED = obj.GridPanelED;
    };
	
	obj.QUAdd_click = function(){

        var winobj = new InitMainWindow();
        winobj.WindowED.show();
		winobj.GridPanelED = obj.GridPanelED;
    };
	
	obj.QUClear_click = function(){
        obj.FormPanelQU.getForm().reset();
        obj.QUCode.focus(true, 3);
    };
    
    obj.EDFind_click = function(){
        obj.GridPanelEDStore.load({
            params: {
                start: 0,
                limit: 20
            }
        });
    };
    obj.GridPanelED_cellclick = function(g, row, col, e){
		var record = obj.GridPanelED.getStore().getAt(row);
        var fieldName = g.getColumnModel().getDataIndex(col);
        if (fieldName != 'EditExpression') 
            return;
        var objWindowEx = new InitWindowEx();
        objWindowEx.WindowEx.show();
        objWindowEx.ESourceID.setValue(record.data.EDID);
        objWindowEx.EType.setValue(EType);
        objWindowEx.GridPanelExStore.load();
        objWindowEx.ECQuestionnaireDR.focus(true, 3);
    };
    
    /*MainPanel新增代码占位符*/

}
