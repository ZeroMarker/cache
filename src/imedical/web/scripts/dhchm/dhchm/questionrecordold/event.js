
function InitViewport1Event(obj){
    obj.LoadEvent = function(args){
        obj.GridPanel1Store.load({
            params: {
                start: 0,
                limit: obj.bbar.pageSize
            }
        });
        obj.StartDate.focus(true, 3);
    };
    obj.BFind_click = function(){
        obj.GridPanel1Store.load({
            params: {
                start: 0,
                limit: obj.bbar.pageSize
            }
        });
        //callback :function(){obj.GridPanel1.getSelectionModel().selectFirstRow();}
    };
    obj.TabChange = function(tabPanel, activePanel){
        if (!activePanel) 
            return;
        var ID = activePanel.getId();
        var Type = ID.substring(1, 2);
        if (Type == "Q") {
            obj.GetHisResult.setVisible(true);
        }
        else {
            obj.GetHisResult.setVisible(false);
        }
    };
    obj.GetHisResult_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        if (Type != "Q") {
            ExtTool.alert("提示", "不是问卷结果不能获取")
            return;
        }
        var ID = panelID.substring(1, panelID.length);
        var EID = ID.substring(1, ID.length);
        var rStr = obj.Method.GetQuestionStatus(EID, Type, "U");
        if (rStr != "") {
            ExtTool.alert("提示","操作失败！ "+ rStr);
            return;
        }
        var rStr = obj.Method.GetHisResult(EID);
        var Char1 = String.fromCharCode(1);
        var rArray = rStr.split(Char1);
        var flag = rArray[0];
        if (flag < 0) {
            ExtTool.alert("提示", rArray[1])
            return;
        }
        var resultStr = rArray[1];
        var resultJson = Ext.decode(resultStr);
        var rec = new Ext.data.Record(resultJson);
        baseForm.loadRecord(rec);
    };
    obj.GridPanel1_rowclick = function(objGrid, row, e){
        var record = objGrid.getStore().getAt(row);
        if (obj.RecordID == record.get("ID")) 
            return;
        if (obj.FormPanel3.getActiveTab()) {
            obj.FormPanel3.removeAll(true);
        }
        obj.RecordID = record.get("ID");
        obj.TreeLoader.baseParams.Arg1 = obj.RecordID;
        obj.TreePanel.loader = obj.TreeLoader;
        obj.TreeLoader.load(obj.TreePanel.getRootNode());
        obj.TreePanel.expandAll();
        //obj.TreePanel.getRootNode().expanded=true;
    };
    
    obj.Save_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        /*
         if (!baseForm.isValid()){
         ExtTool.alert("提示","请检查录入数据")
         return;
         }*/
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        var ID = panelID.substring(1, panelID.length);
        var EID = ID.substring(1, ID.length);
        var rStr = obj.Method.GetQuestionStatus(EID, Type, "U");
        if (rStr != "") {
            ExtTool.alert("提示","操作失败！ "+ rStr);
            return;
        }
        var Char1 = String.fromCharCode(1);
        var Char2 = String.fromCharCode(2);
        var resultStr = "";
        if (Type != "T") {
            //textfield,numberfield,datefield,combo
            var pp = formPanel.findByType('textfield');
            var j = pp.length;
            for (var i = 0; i < j; i++) {
            
                if (!pp[i].isValid()) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: pp[i].fieldLabel + '不能为空',
                        buttons: Ext.Msg.OK,
                        fn: function(){
                            pp[i].focus();
                        }
                    });
                    return false;
                }
                var id = pp[i].getId();
                id = id.split("^")[1];
                var value = pp[i].getValue();
                if ((pp[i].isXType('datefield')) && (value != "")) {
                    value = value.format(ExtToolSetting.DateFormatString);
                }
                if (resultStr == "") {
                    resultStr = id + Char2 + value;
                }
                else {
                    resultStr = resultStr + Char1 + id + Char2 + value;
                }
            };
            //checkbox radion;
            var pp = formPanel.findByType('checkbox');
            var j = pp.length;
            for (var i = 0; i < j; i++) {
            
                var id = pp[i].getId();
                id = id.split("^")[1];
                var value = pp[i].getValue();
                var string = "N";
                if (value) {
                    string = "Y";
                }
                if (resultStr == "") {
                    resultStr = id + Char2 + string;
                }
                else {
                    resultStr = resultStr + Char1 + id + Char2 + string;
                }
            };
            
                    /*
             //var objJson = baseForm.getValues();
             var objJson = baseForm.getFieldValues(true);
             for (var oneKey in objJson) {
             oneValue = objJson[oneKey];
             if (oneValue == obj.InputInfo)
             continue;
             if (resultStr == "") {
             resultStr = oneKey + Char2 + oneValue;
             }
             else {
             resultStr = resultStr + Char1 + oneKey + Char2 + oneValue;
             }
             }*/
        }
        else {
            var grid = Ext.getCmp(ID + "GridPanel1");
            var store = grid.getStore();
            var modifyArray = store.modified.slice(0);
            Ext.each(modifyArray, function(item, index, array){
				var DataID = item.get("ID");
                var MedicalTipsDR = item.get("QMTCMedicalTipsDR");
                if (MedicalTipsDR=="") return
                var desc = item.get("QMTDesc");
                var detail = item.get("QMTDetail");
                var type = item.get("QMTType");
                var remark = item.get("QMTRemark");
                if (resultStr == "") {
                    resultStr = DataID + Char2 + MedicalTipsDR + Char2 + desc + Char2 + detail + Char2 + type + Char2 + remark + Char2 + EID;
                }
                else {
                    resultStr = resultStr + Char1 + DataID + Char2 + MedicalTipsDR + Char2 + desc + Char2 + detail + Char2 + type + Char2 + remark + Char2 + EID;
                }
            });
        }
        if (resultStr == "") {
            ExtTool.alert("提示", "没有需要保存的数据");
            return;
        }
		var User = session['LOGON.USERID'];
        var retStr = obj.Method.UpdateResult(Type, resultStr, User);
        if (retStr == "") {
            if (Type == "T") {
                store.commitChanges();
                store.load({
                    params: {
                        start: 0,
                        limit: 25
                    }
                });
            }
            ExtTool.alert("恭喜", "您的操作成功");
        }
        else {
            ExtTool.alert("很遗憾", "您的操作没有成功，" + retStr);
        }
        
    }
    obj.Submit_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        var ID = panelID.substring(2, panelID.length);
        var rStr = obj.Method.GetQuestionStatus(ID, Type, "S");
        if (rStr != "") {
            ExtTool.alert("提示","操作失败！ "+ rStr);
            return;
        }
        var User = session['LOGON.USERID'];
        var retStr = obj.Method.SubmitQuestion(Type, ID, User);
        if (retStr == "") {
            ExtTool.alert("恭喜", "您的操作成功");
        }
        else {
            ExtTool.alert("很遗憾", "您的操作没有成功，" + retStr);
        }
    }
	obj.CancelSubmit_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var panelID = formPanel.id;
        var Type = panelID.substring(1, 2);
        var ID = panelID.substring(2, panelID.length);
        var retStr = obj.Method.CanelSubmit(Type, ID);
        if (retStr == "") {
            ExtTool.alert("恭喜", "您的操作成功");
        }
        else {
            ExtTool.alert("很遗憾", "您的操作没有成功，" + retStr);
        }
    }
    obj.Clear_click = function(){
        var formPanel = obj.FormPanel3.getActiveTab();
        if (!formPanel) 
            return;
        var baseForm = formPanel.getForm();
        var Value = baseForm.reset();
    }
    obj.TreePanel_click = function(node, e){
        var ID = node.id;
        if (ID == 0) 
            return;
        var Desc = node.text;
        var cmp = Ext.getCmp("P" + ID);
        
        if (cmp) {
            obj.FormPanel3.setActiveTab("P" + ID);
            return;
        }
        CreateActivePanel(obj, ID, Desc);
    };
    /*Viewport1新增代码占位符*/





























































































































































































































































}

