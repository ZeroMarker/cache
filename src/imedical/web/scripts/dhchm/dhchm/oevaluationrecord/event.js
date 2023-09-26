
function InitViewport1Event(obj){
    obj.LoadEvent = function(args){
		obj.GridPanel1Store.load({
            params: {
                start: 0,
                limit: obj.bbar.pageSize
            }
        });
		obj.BICode.focus(true,3);
    };
    obj.GridPanel1_rowdblclick = function(objGrid, row, e){
        var record = objGrid.getStore().getAt(row);
        var ID = record.get("ID");
        var baseInfo = obj.Method.GetEvaluationInfoByID(ID);
        if (baseInfo == "") {
            ExtTool.alert("很遗憾", "代码不存在，请确认");
            return;
        }
        var baseJson = Ext.decode(baseInfo);
        var rec = new Ext.data.Record(baseJson);
        obj.FormPanel2.getForm().loadRecord(rec);
        obj.TreeLoader.baseParams.Arg1 = ID;
        obj.TreeLoader.baseParams.Arg2 = "";
        obj.TreePanel.loader = obj.TreeLoader;
        obj.TreeLoader.load(obj.TreePanel.getRootNode());
        obj.TreePanel.expandAll();
    };
    obj.BICode_keydown = function(textField, e){
        if (e.getKey() == e.ENTER) {
            var code = textField.getValue();
			var baseInfo = obj.Method.GetBaseInfo(code,textField.id);
            if (baseInfo == "") {
                ExtTool.alert("很遗憾", "代码不存在，请确认");
				obj.BClear_click();
				textField.setValue(code);
                return;
            }
            var baseJson = Ext.decode(baseInfo);
            var rec = new Ext.data.Record(baseJson);
            obj.FormPanel2.getForm().loadRecord(rec);
            var ServiceClass = rec.get("QCServiceClassDR");
            obj.TreeLoader.baseParams.Arg1 = "";
            obj.TreeLoader.baseParams.Arg2 = ServiceClass;
            obj.TreePanel.loader = obj.TreeLoader;
            obj.TreeLoader.load(obj.TreePanel.getRootNode());
            obj.TreePanel.expandAll();
        }
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
    obj.BSave_click = function(){
    	Ext.MessageBox.wait('Loadng...........', '保存中，请等待');
      Ext.MessageBox.updateProgress(1);
      var delay=new Ext.util.DelayedTask(dosave);
      delay.delay(500);

    }
    dosave= function(){
    	  var ID = obj.ID.getValue();
        var baseID = obj.QOBaseInfoDR.getValue();
        if (baseID == "") {
            ExtTool.alert("提示", "请正确选择登记人员");
            return;
        }
        var propertyStr = "QOBaseInfoDR^QPostCode^QRemark^QCMaritalDR^QCServiceClassDR^QHMDR^QCEducationDR^QDocDR^QCOccupationDR"
        var valueStr = ExtTool.GetValuesByIds(propertyStr);
        var questionStr = GetQuestionStr();
        if (questionStr == "") {
            ExtTool.alert("提示", "人员没有选择问卷信息");
            return;
        }
        var user = session["LOGON.USERID"];
        var rStr = obj.Method.SaveEvaluationRecord(ID, valueStr, propertyStr, questionStr, user);
        var rArray = rStr.split("^");
        var flag = rArray[0];
        if (flag>0) {
			ExtTool.alert("提示", "人员登记成功");
			obj.ID.setValue(flag);


obj.GridPanel1Store.load({
            params: {
                start: 0,
                limit: obj.bbar.pageSize
            }
        });

            return;
        }
        else {
        	ExtTool.alert("提示", "人员登记失败，具体信息为"+rArray[1]);
            return;
        }
       
    }
    obj.BClear_click = function(){
    obj.FormPanel2.getForm().reset();
		obj.BICode.focus(true,3);
    }
    /*Viewport1新增代码占位符*/
    
    function GetQuestionStr(){
    		var Flag=0;
        var node = obj.TreePanel.getRootNode();
        var rStr = "";
        node.eachChild(function(child){
            var ID = child.id;
            var value = "NU";
            var checked = child.attributes.checked;
            if (checked){
            		Flag=1;
                value = "N";
              }
            if (rStr == "") {
                rStr = ID + "^" + value;
            }
            else {
                rStr = rStr + "$" + ID + "^" + value;
            }
        })
        if (Flag==0) return "";
        return rStr;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

