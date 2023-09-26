function InitMainWindowEvent(obj){
	var Table = ExtTool.StaticServerObject("web.DHCHM.QuestionDetailSet");
    obj.LoadEvent = function(args){
    }
    obj.QDSave_click = function(){
       
        if (!obj.FormPanelQD.getForm().isValid()) {
            ExtTool.alert("提示", "请检查必填项！");
            return;
        }
        
        var id = obj.QDID.getValue();
        
        var property = 'QDCode^QDDesc^QDType^QDUnit^QDSex^QDLinkCode^QDElementNum^QDActive^QDRequired^QDRemark';
        
        var tmp = ExtTool.GetValuesByIds(property);
        try {
            var ret = Table.QDSave(id, tmp, property);
            if (ret.split("^")[0] == -1) {
                ExtTool.alert("失败", ret.split("^")[1]);
                return;
            }
            else {
                obj.QDID.setValue(ret);
                ExtTool.FormToGrid(id, obj.GridPanelQD, obj.FormPanelQD);
				if(id==''){
					obj.QDClear_click();
				}
                else{
					obj.WindowQD.close();
				};
            }
        } 
        catch (err) {
            ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
        }
    };
    
    obj.QDClear_click = function(){
        obj.FormPanelQD.getForm().reset();
        obj.QDCode.focus(true, 3);
    };
    
}


function InitMainPanelEvent(obj){
    var Table = ExtTool.StaticServerObject("web.DHCHM.QuestionDetailSet");
    var QDType = '';
    obj.LoadEvent = function(args){
    };
    
    obj.GridPanelQD_rowclick = function(g, row, e){
        var record = obj.GridPanelQD.getStore().getAt(row);
        obj.QDOClear_click();
        obj.QDOParRef.setValue(record.data.QDID);
        obj.GridPanelQDOStore.load();
        QDType = record.data.QDType;
        if ((record.data.QDType != 'M') && (record.data.QDType != 'S')) {
            obj.FormPanelQDO.disable();
            obj.GridPanelQDO.disable();
        }
        else {
            obj.FormPanelQDO.enable();
            obj.GridPanelQDO.enable();
        }
        obj.QDODesc.focus(true, 3);
    };
    
    obj.GridPanelQD_rowdblclick = function(g, row, e){
    
        var winobj = new InitMainWindow();
        winobj.WindowQD.show();
        var record = obj.GridPanelQD.getStore().getAt(row);
        winobj.FormPanelQD.getForm().loadRecord(record);
		winobj.GridPanelQD = obj.GridPanelQD;
    };
    
	obj.QUAdd_click = function(){
    
        var winobj = new InitMainWindow();
        winobj.WindowQD.show();
		winobj.GridPanelQD = obj.GridPanelQD;
    };
    
    obj.QUClear_click = function(){
        obj.FormPanelQU.getForm().reset();
        obj.QUCode.focus(true, 3);
    };
    
    
    obj.QDOSave_click = function(){
    
        if (obj.QDOParRef.getValue() == "") {
            ExtTool.alert("提示", "先选择一条问卷内容！");
            return;
        }
        
        if (!obj.FormPanelQDO.getForm().isValid()) {
            ExtTool.alert("提示", "请检查必填项！");
            return;
        }
        
        var id = obj.QDOID.getValue();
        
        var property = 'QDOActive^QDOClass^QDODefault^QDODesc^QDOOrder^QDOParRef^QDOSex';
        
        var tmp = ExtTool.GetValuesByIds(property);
        try {
            var ret = Table.QDOSave(id, tmp, property, QDType, obj.QDODefault.getValue(), obj.QDOParRef.getValue());
            if (ret.split("^")[0] == -1) {
                ExtTool.alert("失败", ret.split("^")[1]);
                return;
            }
            else {
                obj.GridPanelQDOStore.load();
                obj.QDOClear_click();
            }
        } 
        catch (err) {
            ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
        }
    };
    obj.GridPanelQDO_rowclick = function(g, row, e){
        var record = obj.GridPanelQDO.getStore().getAt(row);
        obj.FormPanelQDO.getForm().loadRecord(record);
    };
    obj.QDOClear_click = function(){
        var QDOParRef = obj.QDOParRef.getValue();
        obj.FormPanelQDO.getForm().reset();
        obj.QDOParRef.setValue(QDOParRef);
        obj.QDODesc.focus(true, 3);
    };
	
	obj.QDFind_click = function(){
        obj.GridPanelQDStore.load({
            params: {
                start: 0,
                limit: 20
            }
        });
        
    };
    /*MainPanel新增代码占位符*/
}
