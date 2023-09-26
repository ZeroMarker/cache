
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
  {};
	obj.BtnDelete_click = function()
	{
		var cSDRowid=obj.SDRowid.getValue();
	 	if(cSDRowid=="")
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
                	
            var objSD = ExtTool.StaticServerObject("DHCMed.CC.ShowDic");
			var ret = objSD.DeleteById(cSDRowid);
			if(ret==0)
				{	
					obj.SDRowid.setValue("");
					obj.SDCode.setValue("");
					obj.SDDesc.setValue("");
					obj.SDInPut.setValue("");
					obj.SDQueryName.setValue("");
					obj.SDResume.setValue("");
					obj.sDicGridPanelStore.load();
				
					return;
				}
	 		if(ret<0)
	 			{
	 				ExtTool.alert("提示","删除失败!");
	 				return;	
	 			}
           	});
	};
	obj.BtnUpdate_click = function()
	{
		if(ValidateData(obj.SDCode,"代码不能为空!")==-1) return;
		if(ValidateData(obj.SDDesc,"描述不能为空!")==-1) return;
		
		var objID = ExtTool.StaticServerObject("DHCMed.CC.ShowDic");
		var tmp = obj.SDRowid.getValue();
		tmp += "^"+obj.SDCode.getValue();
		tmp += "^"+obj.SDDesc.getValue();
		tmp += "^"+obj.SDInPut.getValue();
		tmp += "^"+obj.SDQueryName.getValue();
		tmp += "^"+obj.SDResume.getValue();
		
		var ret=objID.Update(tmp);
		if(ret>0) 
		{
			obj.SDRowid.setValue();
			obj.SDCode.setValue();
			obj.SDDesc.setValue();
			obj.SDInPut.setValue();
			obj.SDQueryName.setValue();
			obj.SDResume.setValue();
			obj.sDicGridPanelStore.load();
		}
		else ExtTool.alert("提示",ret);
	};
	obj.sDicGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.sDicGridPanelStore.getAt(rowIndex);
		if(objRec.get("ID")==obj.SDRowid.getValue())
		{
			obj.SDRowid.setValue("");
			obj.SDCode.setValue("");
			obj.SDDesc.setValue("");
			obj.SDInPut.setValue("");
			obj.SDQueryName.setValue("");
			obj.SDResume.setValue("");
			
			return;
		}
			obj.SDRowid.setValue(objRec.get("ID"));
			obj.SDCode.setValue(objRec.get("SDCode"));
			obj.SDDesc.setValue(objRec.get("SDDesc"));
			obj.SDInPut.setValue(objRec.get("SDInPut"));
			obj.SDQueryName.setValue(objRec.get("SDQueryName"));
			obj.SDResume.setValue(objRec.get("SDResume"));
	};
/*Viewport1新增代码占位符*/
}
function ValidateData(tObj,str)
{
	if(tObj.getValue()=="")
	{
		ExtTool.alert("提示",str);
		return -1;
	}
	else return 1;
}

