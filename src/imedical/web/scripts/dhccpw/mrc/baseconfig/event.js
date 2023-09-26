
function InitMainViewportEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnUpdate.on('click', obj.btnUpdate_click, obj);
		obj.btnDelete.on('click', obj.btnDelete_click, obj);
		obj.MainGridPanel.on("rowclick", obj.MainGridPanel_rowclick, obj);
		obj.MainGridPanel.on("rowdblclick", obj.MainGridPanel_rowclick, obj);
	};
	obj.CurrResultRowid = "";
	obj.btnUpdate_click = function(){
		var InPutErr="",InPutStr=""
		var BCID="",BCCode="",BCDesc="",BCValue="",BCResume="";
		if (obj.CurrResultRowid) BCID=obj.CurrResultRowid;
		BCCode=obj.txtBCCode.getValue();
		//检查code是否重复
		var objBC = ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseConfig");
		var checkVal=objBC.CheckBCCode(BCCode,BCID)
		if(checkVal>=1){ //Modified By LiYang 2011-02-19 值1代表数据库已经有这个Code了
			alert("代码重复，请重新输入");
			return
		}
		BCDesc=obj.txtBCDesc.getValue();
		BCValue=obj.txtBCValue.getValue();
		BCResume=obj.txtBCResume.getValue();
		
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
        if (BCCode=="") InPutErr = InPutErr + "代码不能为空!" + CRChar;
        if (BCDesc=="") InPutErr = InPutErr + "描述不能为空!" + CRChar;
        //if (BCValue=="") InPutErr = InPutErr + "值不能为空!" + CRChar;
	    if(InPutErr!=="") {
			ExtTool.alert("提示",InPutErr);
			return;
		}
	    var separete = "^";
		var InPutStr = BCID + separete;
		InPutStr = InPutStr + BCCode + separete;
		InPutStr = InPutStr + BCDesc + separete;
	   	InPutStr = InPutStr + BCValue + separete;
		InPutStr = InPutStr + BCResume + separete;
		
		try{
			var ret = objBC.Update(InPutStr);
			if(ret<0) {
				ExtTool.alert("提示","更新失败!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				obj.MainGridPanelStore.load({
				    params : {
					    start : 0,
					    limit : 20
					}
				});
				obj.ClearFormData();
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	
	obj.btnDelete_click = function(){
		var BCID="",InPutErr="";
		var objBC = ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseConfig");
		if (obj.CurrResultRowid==""){
			InPutErr = "请选择删除记录,再删除!";
			ExtTool.alert("提示",InPutErr);
			return;
		}else{
			ExtTool.confirm('选择框','确定删除此记录?',function(btn){
				if (btn=='no') return;
				BCID=obj.CurrResultRowid;
				try{
					var ret = objBC.DeleteById(BCID);
					if(ret<0) {
						ExtTool.alert("提示","删除失败!");
						return;
					}else{
						obj.CurrResultRowid="";
						obj.ClearFormData();
						obj.MainGridPanelStore.load({
						    params : {
							    start : 0,
							    limit : 20
							}
						});
					}
				}catch(err){
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
			});
		}
	};
	obj.MainGridPanel_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.MainGridPanelStore.getAt(rowIndex);
		if ((obj.CurrResultRowid)&&(objRec.get("BCID")==obj.CurrResultRowid)){
			obj.ClearFormData();
		}else{
			obj.CurrResultRowid=objRec.get("BCID");
			obj.txtBCCode.setValue(objRec.get("BCCode"));
			obj.txtBCDesc.setValue(objRec.get("BCDesc"));
			obj.txtBCValue.setValue(objRec.get("BCValue"));
			obj.txtBCResume.setValue(objRec.get("BCResume"));
		}
	};
	obj.ClearFormData = function(){
		obj.CurrResultRowid="";
		obj.txtBCCode.setValue("");
		obj.txtBCDesc.setValue("");
		obj.txtBCValue.setValue("");
		obj.txtBCResume.setValue("");
	}
}
