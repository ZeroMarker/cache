function InitViewportEvent(obj)
{	
	var objSub = ExtTool.StaticServerObject("DHCMed.CC.Subject");
	obj.LoadEvent = function(args)
	{
	}
	obj.Subject_rowclick = function()
	{
		var rc = obj.Subject.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.rowid.getValue()!=MessagePID)
		{
			obj.rowid.setValue(rc.get("rowid"));
			obj.Code.setValue(rc.get("Code"));
			obj.Title.setValue(rc.get("Title"));
			obj.IsActive.setValue(rc.get("IsActive"));
			obj.ResumeText.setValue(rc.get("ResumeText"));
			obj.Categroy.setValue(rc.get("Categroy"));
			obj.Desc.setValue(rc.get("Desc"));
			obj.Expression.setValue(rc.get("Expression"));
		}
		else
		{
			ClearData(obj);	
		}
	};
	obj.btnFind_click = function()
	{
		obj.SubjectStore.load({params : {start:0,limit:20}});
	};
	obj.btnItem_click = function()
	{
		var rc = obj.Subject.getSelectionModel().getSelected();
		if(!rc)
		{
			ExtTool.alert("提示","请先选则一个监控主题!");
			return;	
		}
		obj.rowid.setValue(rc.get("rowid"));
		if(obj.rowid.getValue()!=null)
		{
			var objSubItm = new InitSubjectItm();
			objSubItm.SubjectItmID.setValue(rc.get("rowid"));
			objSubItm.SubjectItmListStore.removeAll();
			objSubItm.SubjectItmListStore.load({params : {start:0,limit:20}});
			objSubItm.SubjectItm.show();
		}
	};
	obj.btnConfig_click = function()
	{
		var rc = obj.Subject.getSelectionModel().getSelected();
		if(!rc)
		{
			ExtTool.alert("提示","请先选则一个监控主题!");
			return;	
		}
		obj.rowid.setValue(rc.get("rowid"));
		if(obj.rowid.getValue()!=null)
		{
			var objConfig = new InitSubjectVMStartConfig();
			objConfig.ConSubID.setValue(rc.get("rowid"));
			objConfig.SubjectVMSConfigStore.load({params : {start:0,limit:20}});
			objConfig.SubjectVMStartConfig.show();
		}
	};
	obj.btnUpdate_click = function()
	{
		var Code =obj.Code.getValue();
		var Title =obj.Title.getValue();
	 	if(Code=="")
	 	{
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(Title=="")
	 	{
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.rowid.getValue();
		tmp += "^"+obj.Code.getValue();
		tmp += "^"+obj.Title.getValue();
		tmp += "^"+obj.Desc.getValue();
		tmp += "^"+obj.Categroy.getValue();
		tmp += "^"+obj.Expression.getValue();
		tmp += "^"+(obj.IsActive.getValue()? "1":"0");
		tmp += "^"+obj.ResumeText.getValue();
		var ret=objSub.Update(tmp);
		if(ret>0) 
		{
			ClearData(obj);
			obj.SubjectStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.btnColor_click = function()
	{
		var rc = obj.Subject.getSelectionModel().getSelected();
		if(!rc)
		{
			ExtTool.alert("提示","请先选则一个监控主题!");
			return;	
		}
		obj.rowid.setValue(rc.get("rowid"));
		if(obj.rowid.getValue()!=null)
		{
			var objColor = new InitColor();
			objColor.SubjectID.setValue(rc.get("rowid"));
			objColor.ColorListStore.load({params : {start:0,limit:20}});
			objColor.Color.show();
		}
	}
}
function ClearData(obj)
{
	obj.Code.setValue("");
	obj.Title.setValue("");
	obj.rowid.setValue("");
	obj.ResumeText.setValue("");
	obj.Expression.setValue("");
	obj.Categroy.setValue("");
	obj.Desc.setValue("");
}

function ClearSubItmData(obj)
{
	obj.ItmCode.setValue("");
	obj.ItmRowid.setValue("");
	obj.ItemDic.setValue("");
	obj.ItemDicID.setValue("");
	obj.ItmScore.setValue("");
	obj.ItmResumeText.setValue("");
}

function ClearColorData(obj)
{
	obj.ColorID.setValue("");
	obj.Score.setValue("");
	obj.txtVCColour.setValue("");
	Ext.getDom(obj.txtVCColour.id).style.background='#FFFFFF';
}
function ClearVMStartConfigData(obj)
{
	obj.ConCode.setValue("");
	obj.ConDesc.setValue("");
	obj.ConStartIndex.setValue("");
	obj.ConExpression.setValue("");
	obj.ConVarName.setValue("");
	obj.ConResumeText.setValue("");
	obj.ConID.setValue("");
	obj.ConRunType.setValue("");
}
function InitSubjectItmEvent(obj)
{	
	var objSubItm = ExtTool.StaticServerObject("DHCMed.CC.SubjectItm");
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(args)
	{
		var rc = parent.Subject.getSelectionModel().getSelected();
		obj.treePMsTreeLoader.baseParams.subjectID=rc.get("rowid");
		obj.treePMs.loader=obj.treePMsTreeLoader;
		//obj.treePMsTreeLoader.load(obj.treePMs.getRootNode());
		//obj.treePMs.getRootNode().expanded=true;
	}
	obj.SubjectItmCatList_rowclick = function ()
	{
		var rc = obj.SubjectItmCatList.getSelectionModel().getSelected();
		obj.ItemDic.setValue(rc.get("Desc"));
		obj.ItemDicID.setValue(rc.get("rowid"));
	}
	obj.SubjectItmCatListStore.load({});
	obj.ItmBtnFind_click = function()
	{
		obj.SubjectItmListStore.load({params : {start:0,limit:20}});
	};
	obj.ItmBtnUpdate_click = function()
	{
		var ItmCode =obj.ItmCode.getValue();
		var ItemDicID =obj.ItemDicID.getValue();
	 	if(ItmCode=="")
	 	{
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(ItemDicID=="")
	 	{
	 		ExtTool.alert("提示","字典项不能为空!");
	 		return;
	 	}
	 	var tmp = obj.ItmRowid.getValue();
		tmp += "^"+obj.SubjectItmID.getValue();
		tmp += "^"+obj.ItmCode.getValue();
		tmp += "^"+obj.ItemDicID.getValue();
		tmp += "^"+obj.ItmScore.getValue();
		tmp += "^"+(obj.ItmIsActive.getValue()? "Y":"N");
		tmp += "^"+obj.ItmResumeText.getValue();
		tmp += "^"+(obj.MultiTimes.getValue()?"Y":"N");
		var ret=objSubItm.Update(tmp,"^");
		if(ret>0) 
		{
			ClearSubItmData(obj);
			obj.SubjectItmListStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.treePMs_click = function()
	{
		var objNode = arguments[0];
		if(objNode.id.search("L")==1)		//叶子节点
		{
			if(obj.ItemDicID.getValue()==parseInt(objNode.id))
			{
				obj.ItemDic.setValue("");
				obj.ItemDicID.setValue("");
			}
			else{
			obj.ItemDic.setValue(objNode.text);
			obj.ItemDicID.setValue(parseInt(objNode.id));		//把字符串转换为数字
		}
		}
	}
	obj.ItmBtnExit_click = function()
	{
		ClearData(parent);
		obj.SubjectItm.close();
	};
	obj.SubjectItmList_rowclick = function()
	{
		var rc = obj.SubjectItmList.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.ItmRowid.getValue()!=MessagePID)
		{
			obj.ItmRowid.setValue(rc.get("rowid"));
			obj.ItmCode.setValue(rc.get("Code"));
			obj.ItmIsActive.setValue(rc.get("IsActive"));
			obj.ItmResumeText.setValue(rc.get("ResumeText"));
			obj.ItmScore.setValue(rc.get("Score"));
			obj.ItemDicID.setValue(rc.get("ItemDic"));
			obj.ItemDic.setValue(rc.get("IDDesc"));
			obj.MultiTimes.setValue(rc.get("MultiTimes"));
		}
		else
		{
			ClearSubItmData(obj);	
		}
	};
}

function InitSubjectVMStartConfigEvent(obj)
{	
	var objVMCon = ExtTool.StaticServerObject("DHCMed.CC.SubjectVMStartConfig");
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(args)
	{
	}
	obj.ConBtnFind_click = function()
	{
		obj.SubjectVMSConfigStore.load({params : {start:0,limit:20}});
	};
	obj.ConBtnUpdate_click = function()
	{
		var Code =obj.ConCode.getValue();
		var ConStartIndex =obj.ConStartIndex.getValue();
		var ConExpression =obj.ConExpression.getValue();
		var ConVarName =obj.ConVarName.getValue();
	 	if(Code=="")
	 	{
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(ConStartIndex=="")
	 	{
	 		ExtTool.alert("提示","加载顺序不能为空!");
	 		return;
	 	}
	 	if(ConExpression=="")
	 	{
	 		ExtTool.alert("提示","表达式不能为空!");
	 		return;
	 	}
	 	if(ConVarName=="")
	 	{
	 		ExtTool.alert("提示","VM变量名不能为空!");
	 		return;
	 	}
	 	var tmp = obj.ConID.getValue();
		tmp += "^"+obj.ConSubID.getValue();
		tmp += "^"+obj.ConCode.getValue();
		tmp += "^"+obj.ConDesc.getValue();
		tmp += "^"+(obj.ConIsActive.getValue()? "Y":"N");
		tmp += "^"+obj.ConStartIndex.getValue();
		tmp += "^"+obj.ConExpression.getValue();
		tmp += "^"+obj.ConResumeText.getValue();
		tmp += "^"+obj.ConRunType.getValue();
		tmp += "^"+obj.ConVarName.getValue();
		var ret=objVMCon.Update(tmp);
		if(ret>0) 
		{
			ClearVMStartConfigData(obj);
			obj.SubjectVMSConfigStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.ConBtnExit_click = function()
	{
		ClearData(parent);
		obj.SubjectVMStartConfig.close();
	};
	obj.SubjectVMSConfig_rowclick = function()
	{
		var rc = obj.SubjectVMSConfig.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.ConID.getValue()!=MessagePID)
		{
			obj.ConID.setValue(rc.get("rowid"));
			obj.ConCode.setValue(rc.get("Code"));
			obj.ConIsActive.setValue(rc.get("IsActive"));
			obj.ConResumeText.setValue(rc.get("ResumeText"));
			obj.ConStartIndex.setValue(rc.get("StartIndex"));
			obj.ConVarName.setValue(rc.get("VarName"));
			obj.ConExpression.setValue(rc.get("Expression"));
			obj.ConDesc.setValue(rc.get("Desc"));
			obj.ConRunType.setValue(rc.get("RunType"));
		}
		else
		{
			ClearVMStartConfigData(obj);	
		}
	};
}

function InitColorEvent(obj)
{	
	var objSubColor = ExtTool.StaticServerObject("DHCMed.CC.SubjectColor");
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(args)
	{
		obj.ColorPicker.on('select', function(p,v){
		obj.txtVCColour.setValue('#'+v);
		Ext.getDom(obj.txtVCColour.id).style.background='#'+v;
		});
	}
	obj.cboMarkColor_beforeselect = function(objCbo, objRec)
	{
		var objDom = document.getElementById("txtMarkColor");
		//window.alert(objRec.get("ColorNumber"));
		obj.txtVCColour.setValue(objRec.get("ColorNumber"));
		Ext.getDom(obj.txtVCColour.id).style.background= objRec.get("ColorNumber");
		return true;
	};
	obj.ColorList_rowclick = function ()
	{
		var rc = obj.ColorList.getSelectionModel().getSelected();
		var tColorID=rc.get("rowid");
		if(obj.ColorID.getValue()!=tColorID)
		{
			obj.ColorID.setValue(rc.get("rowid"));
			obj.Score.setValue(rc.get("Score"));
			obj.txtVCColour.setValue(rc.get("ColorRGB"));
			Ext.getDom(obj.txtVCColour.id).style.background=rc.get("ColorRGB");
		}
		else
		{
			ClearColorData(obj);	
		}
	}
	obj.cBtnUpdate_click = function ()
	{
		var Score =obj.Score.getValue();
		var txtVCColour =obj.txtVCColour.getValue();
	 	if(Score=="")
	 	{
	 		ExtTool.alert("提示","分数不能为空!");
	 		return;
	 	}
	 	if(txtVCColour=="")
	 	{
	 		ExtTool.alert("提示","颜色不能为空!");
	 		return;
	 	}
	 	var tmp = obj.ColorID.getValue();
	 	tmp += "^"+obj.txtVCColour.getValue();
		tmp += "^"+parent.rowid.getValue();
		tmp += "^"+obj.Score.getValue();
		var ret=objSubColor.Update(tmp);
		if(ret>0) 
		{
			ClearColorData(obj);
			obj.ColorListStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
		
	}
	obj.cBtnDelete_click = function ()
	{
		var selectObj = obj.ColorList.getSelectionModel().getSelected();
		if (selectObj){
			var ret=objSubColor.DeleteById(selectObj.get("rowid"));
			if(ret==0)
				{
					ClearColorData(obj);
					obj.ColorListStore.load({params : {start:0,limit:20}});
					return;	
				}
			else {
					 ExtTool.alert("提示","删除失败!!");
					 return;
				 }
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}	
	}
	
}
