function InitViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.gridSubject.on("rowclick", obj.gridSubject_rowclick, obj);
		obj.btnUpdate.on("click", obj.btnUpdate_click, obj);
		obj.btnStartConfig.on("click", obj.btnStartConfig_click, obj);
		obj.btnAutoWorkFilter.on("click", obj.btnAutoWorkFilter_click, obj);
	};
	obj.gridSubject_rowclick = function(){
		var rowIndex = arguments[1];
		var rc = obj.gridSubjectStore.getAt(rowIndex);
		if(obj.CurrRowid!==rc.get("rowid")){
			obj.CurrRowid=rc.get("rowid");
			obj.txtCode.setValue(rc.get("Code"));
			obj.txtTitle.setValue(rc.get("Title"));
			obj.txtDesc.setValue(rc.get("Desc"));
			obj.chkIsActive.setValue(rc.get("IsActive"));
			obj.chkIsAutoWork.setValue(rc.get("IsAutoRun"));
			obj.chkIsTimeLine.setValue(rc.get("IsTimeLine"));
		}else{
			ClearData(obj);
		}
	};
	obj.btnUpdate_click = function(){
		var Code =obj.txtCode.getValue();
		var Title =obj.txtTitle.getValue();
	 	if(Code==""){
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(Title==""){
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.CurrRowid;
		tmp += "^"+obj.txtCode.getValue();
		tmp += "^"+obj.txtTitle.getValue();
		tmp += "^"+obj.txtDesc.getValue();
		tmp += "^"+ "";
		tmp += "^"+ "";
		tmp += "^"+(obj.chkIsActive.getValue()? "1":"0");
		tmp += "^"+ "";
		tmp += "^"+(obj.chkIsAutoWork.getValue()? "1":"0");
		tmp += "^"+(obj.chkIsTimeLine.getValue()? "1":"0");
		var objSub = ExtTool.StaticServerObject("DHCMed.CC.Subject");
		var ret=objSub.Update(tmp);
		if(ret>0){
			ClearData(obj);
			obj.gridSubjectStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("提示","保存失败!");
		}
	};
	
	obj.btnStartConfig_click = function(){
		var rc = obj.gridSubject.getSelectionModel().getSelected();
		if(!rc){
			ExtTool.alert("提示","请先选则一个监控主题!");
			return;	
		}
		obj.CurrRowid=rc.get("rowid");
		var objFrm = new InitStartConfig(obj.CurrRowid);
		objFrm.winStartConfig.show();
	}
	
	obj.btnAutoWorkFilter_click = function()
	{
		var rc = obj.gridSubject.getSelectionModel().getSelected();
		if(!rc){
			ExtTool.alert("提示","请先选则一个监控主题!");
			return;	
		}
		obj.CurrRowid=rc.get("rowid");
		var objFrm = new InitFilterRule(obj.CurrRowid);
		objFrm.pnCtlFilterRule.show();		
	}
	
}

function ClearData(obj)
{
	obj.CurrRowid="";
	obj.txtCode.setValue("");
	obj.txtTitle.setValue("");
	obj.txtDesc.setValue("");
	obj.chkIsActive.setValue(true);
	obj.chkIsAutoWork.setValue(false);
	obj.chkIsTimeLine.setValue(false);
}

function ClearColorData(obj)
{
	obj.CurrColorID="";
	obj.Score.setValue("");
	obj.txtVCColour.setValue("");
	Ext.getDom(obj.txtVCColour.id).style.background='#FFFFFF';
}

function InitColorEvent(obj)
{	
	obj.LoadEvent = function(args)
	{
		obj.cBtnUpdate.on("click", obj.cBtnUpdate_click, obj);
		obj.cBtnDelete.on("click", obj.cBtnDelete_click, obj);
		obj.cboMarkColor.on("beforeselect", obj.cboMarkColor_beforeselect, obj);
		obj.ColorList.on("rowclick",obj.ColorList_rowclick,obj);
		obj.ColorPicker.on('select', function(p,v){
			obj.txtVCColour.setValue('#'+v);
			Ext.getDom(obj.txtVCColour.id).style.background='#'+v;
		});
	}
	obj.cboMarkColor_beforeselect = function(objCbo, objRec)
	{
		var objDom = document.getElementById("txtMarkColor");
		obj.txtVCColour.setValue(objRec.get("ColorNumber"));
		Ext.getDom(obj.txtVCColour.id).style.background= objRec.get("ColorNumber");
		return true;
	};
	obj.ColorList_rowclick = function ()
	{
		var rc = obj.ColorList.getSelectionModel().getSelected();
		if(obj.CurrColorID==rc.get("rowid"))
		{
			obj.CurrColorID="";
			obj.Score.setValue(rc.get("Score"));
			obj.txtVCColour.setValue(rc.get("ColorRGB"));
			Ext.getDom(obj.txtVCColour.id).style.background=rc.get("ColorRGB");
		}else{
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
	 	var tmp = obj.CurrColorID;
	 	tmp += "^"+obj.txtVCColour.getValue();
		tmp += "^"+obj.SubjectID;
		tmp += "^"+obj.Score.getValue();
		var objSubColor = ExtTool.StaticServerObject("DHCMed.CC.SubjectColor");
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
			var objSubColor = ExtTool.StaticServerObject("DHCMed.CC.SubjectColor");
			var ret=objSubColor.DeleteById(selectObj.get("rowid"));
			if(ret==0)
			{
				ClearColorData(obj);
				obj.ColorListStore.load({params : {start:0,limit:20}});
				return;	
			}else{
				ExtTool.alert("提示","删除失败!!");
				return;
			}
		}else{
			ExtTool.alert("提示","请先选中一行!");
		}
	}
}