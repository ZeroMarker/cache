
function InitViewport1Event(obj) {
	var CHR_1 = String.fromCharCode(1);
	var objSApp = ExtTool.StaticServerObject("DHCMed.CCService.SubjectAppSrv");
	var objSub = ExtTool.StaticServerObject("DHCMed.CC.SubjectApp");
	obj.LoadEvent = function()
  {};
	obj.BtnNew_click = function()
	{
		var objSA = new InitSAWindow();
		objSA.SAWindow.show();
	};
	obj.BtnEdit_click = function()
	{
		var objSA = new InitSAWindow();
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
			if(selectObj.get("ID")<1) return;
			objSA.SARowid.setValue(selectObj.get("ID"));
			var ret=objSApp.GetSubAppInfoByID(objSA.SARowid.getValue());
			if(ret!="")
			{
				str=ret.split("^");
				objSA.SACode.setValue(str[1]);
				objSA.SADesc.setValue(str[2]);
				ExtTool.AddComboItem (objSA.SASubjectDr, str[3].split(CHR_1)[1], str[3].split(CHR_1)[0]);
				objSA.SAShowScore.setValue(str[4]);
				ExtTool.AddComboItem(objSA.SAShowDr, str[5].split(CHR_1)[1], str[5].split(CHR_1)[0]);
				objSA.SAResume.setValue(str[6]);
				objSA.SAWindow.show();
			}
		}
		else
		{
			ExtTool.alert("提示","请先选择一条监控主题!");		
			return;
		}
	};
	obj.BtnDelete_click = function()
	{
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
	 	if(!selectObj)
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
                	
			var ret = objSub.DeleteById(selectObj.get("ID"));
			if(ret==0)
			{
				obj.SAGridPanelStore.removeAll();
				obj.SAGridPanelStore.load();
				return;
			}
	 		if(ret<0)
	 		{
	 			ExtTool.alert("提示","删除失败!");
	 			return;	
	 		}
		});
	};
	obj.ColsBtnUpdate_click = function()
	{
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
			var objWinEdit = new InitSubAppCWindow();
			objWinEdit.sSARowid.setValue(selectObj.get("ID"));
			if(selectObj.get("ID")<1) return;
			objWinEdit.SACEditGridPanelStore.load();
			objWinEdit.SubAppCWindow.show();
		}
		else
		{
			ExtTool.alert("提示","请先选择一条监控主题!");		
			return;
		}
	};
	obj.SubBtnUpdate_click = function()
	{
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
			var objSAS = new InitSASWindow();
			objSAS.SAID.setValue(selectObj.get("ID"));
			objSAS.SASGridPanelStore.load();
			objSAS.SASWindow.show();
		}
		else
		{
			ExtTool.alert("提示","请先选择一条监控主题!");		
			return;
		}
	};
}

//***********************监控主题应用维护*****************************

function InitSAWindowEvent(obj) {
	var parent=objControlArry['Viewport1'];
	obj.LoadEvent = function()
  {};
	obj.SABtnSave_click = function()
	{
		var LabStr="";
		if(ValidateData(obj.SACode,"代码不能为空!")==-1) return;
		if(ValidateData(obj.SADesc,"描述不能为空!")==-1) return;
		if(ValidateData(obj.SASubjectDr,"监控主题不能为空!")==-1) return;
		if(ValidateData(obj.SAShowDr,"展现模式不能为空!")==-1) return;
		
		if(obj.SASubjectDr.getValue()==obj.SASubjectDr.getRawValue())
		{
			ExtTool.alert("提示","请选择一个监控主题!");	
			return;
		}
		if(obj.SAShowDr.getValue()==obj.SAShowDr.getRawValue())
		{
			ExtTool.alert("提示","请选择一个展现模式!");	
			return;
		}
		var objLab = ExtTool.StaticServerObject("DHCMed.CC.SubjectApp");
		var tmp = obj.SARowid.getValue();
		tmp += "^" + obj.SACode.getValue();
		tmp += "^" + obj.SADesc.getValue();
		tmp += "^" + obj.SASubjectDr.getValue();
		tmp += "^" + obj.SAShowScore.getValue();
		tmp += "^" + obj.SAShowDr.getValue();
		tmp += "^" + obj.SAResume.getValue();
		var ret=objLab.Update(tmp);
		if(ret>0) 
		{
			obj.SARowid.setValue("");
			obj.SACode.setValue("");
			obj.SADesc.setValue("");
			obj.SASubjectDr.setValue("");
			
			obj.SAShowScore.setValue("");
			obj.SAShowDr.setValue("");
			obj.SAResume.setValue("");
			
			ExtTool.alert("提示","保存成功!");
			obj.SAWindow.close();
			parent.SAGridPanelStore.load();
		}
		else ExtTool.alert("提示","保存失败!"); 
	};
	obj.SABtnExit_click = function()
	{
		obj.SAWindow.close();
	};
}

//*****************监控项目应用列表属性维护***************************

function InitSubAppCWindowEvent(obj) {
	var CHR_1 = String.fromCharCode(1);
	var objSApp = ExtTool.StaticServerObject("DHCMed.CCService.SubjectAppSrv");
	obj.LoadEvent = function()
  {};
  	obj.SACBtnSave_click = function()
	{
		var TotalStr="";
		if(obj.SACEditGridPanelStore.getCount()==0) return;
		for(var i = 0; i < obj.SACEditGridPanelStore.getCount(); i ++)  //遍历监控主题应用列表
    	{
    		var str="",SACIsHide="",SACIsSort="";
    		var objData = obj.SACEditGridPanelStore.getAt(i);
    		str = objData.get('SACParref');	
    		str += "^"+ objData.get('SACName');
    		str += "^"+ objData.get('SACDesc');
    		if(objData.get('SACIsHide')=="Y") SACIsHide=1;
    		else SACIsHide=0;
    		str += "^"+ SACIsHide;
    		str += "^"+ objData.get('SACWidth');
    		if(objData.get('SACIsSort')=="Y") SACIsSort=1;
    		else SACIsSort=0;
    		str += "^"+ SACIsSort;
    		str += "^"+ objData.get('SACIndex');
    		
    		if(TotalStr=="") TotalStr=str;
    		else TotalStr += CHR_1 + str;
    	}
    	var ret=objSApp.InsertDataToSubAppCols(TotalStr);
    	if(ret==1)
    	{
    		ExtTool.alert("提示","保存成功!");
    		obj.SubAppCWindow.close();
    		return;
    	}
    	else 
    	{
    		ExtTool.alert("提示","保存失败!");
    		return;	
    	}
	};
	obj.SACBtnExit_click = function()
	{
		obj.SubAppCWindow.close();
	};
}

//*********************监控主题应用监控项目维护***********************

function InitSASWindowEvent(obj)
{	
	var objSApp = ExtTool.StaticServerObject("DHCMed.CC.SubjectAppSub");
	obj.LoadEvent = function(args)
	{
	}
	obj.SASBtnSave_click = function()
	{
		if(ValidateData(obj.SASItemDr,"监控项目不能为空!")==-1) return;
		if(ValidateData(obj.SASItemType,"项目类型不能为空!")==-1) return;
		
		if(obj.SASItemDr.getValue()==obj.SASItemDr.getRawValue())
		{
			ExtTool.alert("提示","请选择一个监控项目!");	
			return;
		}
		if(obj.SASItemType.getValue()==obj.SASItemType.getRawValue())
		{
			ExtTool.alert("提示","请选择一个项目类型!");	
			return;
		}
		
		var tmp = obj.SASRowid.getValue();
		if(tmp=="") tmp=obj.SAID.getValue()+"||";
		tmp += "^" + obj.SASItemDr.getValue();
		tmp += "^" + obj.SASItemType.getValue();
		tmp += "^" + obj.SASItemScore.getValue();
		
		if(obj.SASLocDr.getRawValue()=="") tmp += "^";
		else if(obj.SASLocDr.getValue()==obj.SASLocDr.getRawValue()) tmp += "^";
		else tmp += "^"+ obj.SASLocDr.getValue();
		
		if(obj.SASGroupDr.getRawValue()=="") tmp += "^";
		else if(obj.SASGroupDr.getValue()==obj.SASGroupDr.getRawValue()) tmp += "^";
		else tmp += "^" + obj.SASGroupDr.getValue();
		
		tmp += "^" + obj.SASResume.getValue();

		var ret=objSApp.Update(tmp);
		if(ret<0) ExtTool.alert("提示","保存失败!"); 
		else{
			RemoveSASData(obj);
			//ExtTool.alert("提示","保存成功!");
			obj.SASGridPanelStore.load();
			return;
		}
	};
	obj.SASBtnDelete_click = function()
	{
		var selectObj = obj.SASGridPanel.getSelectionModel().getSelected();
	 	if(!selectObj)
	 	{
	 		ExtTool.alert("提示","请先选中一行！");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
            var ID=selectObj.get("SASRowid");
			var ret = objSApp.DeleteById(ID);
			if(ret==0)
			{
				RemoveSASData(obj);
				obj.SASGridPanelStore.removeAll();
				obj.SASGridPanelStore.load();
				return;
			}
	 		if(ret<0)
	 		{
	 			ExtTool.alert("提示","删除失败!");
	 			return;	
	 		}
		});
	};
	obj.SASBtnExit_click = function()
	{
		obj.SASWindow.close();
	};
	obj.SASGridPanel_rowclick = function()
	{
		var selectObj = obj.SASGridPanel.getSelectionModel().getSelected();
		if(selectObj.get("SASRowid")!=obj.SASRowid.getValue())
		{
			obj.SASRowid.setValue(selectObj.get("SASRowid"));
			ExtTool.AddComboItem(obj.SASItemDr,selectObj.get("SASItemDrDesc"),selectObj.get("SASItemDr"));
			ExtTool.AddComboItem(obj.SASItemType,selectObj.get("SASItemTypeDesc"),selectObj.get("SASItemType"));
			obj.SASItemScore.setValue(selectObj.get("SASItemScore"));
			ExtTool.AddComboItem(obj.SASLocDr,selectObj.get("SASLocDrDesc"),selectObj.get("SASLocDr"));
			ExtTool.AddComboItem(obj.SASGroupDr,selectObj.get("SASGroupDrDesc"),selectObj.get("SASGroupDr"));
			obj.SASResume.setValue(selectObj.get("SASResume"));
		}
		else{
			RemoveSASData(obj);
			return;
		}
	};
}

// 
function RemoveSASData(obj)
{
	obj.SASRowid.setValue("");
	obj.SASLocDr.setRawValue("");
	obj.SASItemDr.setValue("");
	obj.SASItemType.setValue("");
	obj.SASItemScore.setValue("");
	obj.SASGroupDr.setValue("");
	obj.SASResume.setValue("");
	obj.SASItemDrStore.removeAll();
	obj.SASItemTypeStore.removeAll();
	obj.SASLocDrStore.removeAll();
	obj.SASGroupDrStore.removeAll();
	obj.SASItemDrStore.load();
	obj.SASItemTypeStore.load();
	obj.SASLocDrStore.load();
	obj.SASGroupDrStore.load();
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
