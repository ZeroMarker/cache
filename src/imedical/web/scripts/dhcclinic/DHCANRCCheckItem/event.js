function InitViewScreenEvent(obj)
{
    var _DHCANRCCheckItem=ExtTool.StaticServerObject('web.DHCANRCCheckItem');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick=function()
	{
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		  
	        obj.Code.setValue(rc.get("Code"));
	        obj.Desc.setValue(rc.get("Desc"));
	        obj.RowId.setValue(rc.get("RowId"));
			obj.TestCode.setValue(rc.get("TestCode"));
			obj.ExamCode.setValue(rc.get("ExamCode"));
            obj.ConsultationCode.setValue(rc.get("ConsultationCode"));	  
			obj.Type.setValue(rc.get("Type"));
			obj.DefAnrcmcDr.setValue(rc.get("DefAnrcmcDr"));
			obj.AnrcmcDr=rc.get("DefAnrcmcDr");
			obj.ClcmsDr.setValue(rc.get("ClcmsDr"));
			obj.Type.setValue(rc.get("Type"));
			obj.DefAnrcmcDr.setValue(rc.get("DefAnrcmcDr"));
			obj.ClcmsDr.setValue(rc.get("ClcmsDr"));
			
			obj.DisIf.setValue(rc.get("DisDecide"));			
			obj.RowNumber.setValue(rc.get("DisRowColNum"));
			var DisplayTypeStr="",tempstr1="",tempstr2="",tempstr3="",tempstr4="N"
			var DisplayTypeList=rc.get("DisProject").split("|");
			for(var i=0;i<DisplayTypeList.length;i++)
   			{
	   			if (DisplayTypeList[i]=="Checked"){tempstr1="Checked" }
	   			if (DisplayTypeList[i]=="Result"){tempstr2="Result" }
	   			if (DisplayTypeList[i]=="Note"){tempstr3="Note" }
	   			if (DisplayTypeList[i]=="Y"){tempstr4="Sample"}	   		
   			}
   			DisplayTypeStr=tempstr1+","+tempstr2+","+tempstr3+","+tempstr4;
   			obj.DisplayType.setValue(DisplayTypeStr); //
	  }
	}
	
	obj.addbutton_click=function()
	{
	    if(obj.Code.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.Desc.getValue()=="")
		{
			ExtTool.alert("提示","名称不能为空!");	
			return;
		}
		var Code=obj.Code.getValue();
		var Desc=obj.Desc.getValue();
		var DefAnrcmcDr=obj.AnrcmcDr;//obj.DefAnrcmcDr.getValue();
		var ClcmsDr=obj.ClcmsDr.getValue();
		var Type=obj.Type.getValue();
		var TestCode=obj.TestCode.getValue();
		var ExamCode=obj.ExamCode.getValue();
		var ConsultationCode=obj.ConsultationCode.getValue();
		var DisplayType=obj.DisplayType.getValue();  //获取显示方式
		var DisplayTypeStr="",tempstr1="|",tempstr2="|",tempstr3="|",tempstr4="N"
		var DisplayTypeList=DisplayType.split(",");
		for(var i=0;i<DisplayTypeList.length;i++)
   		{
	   		if (DisplayTypeList[i]=="Checked"){tempstr1="checkbox|Checked" }
	   		if (DisplayTypeList[i]=="Result"){tempstr2="checkbox|Result" }
	   		if (DisplayTypeList[i]=="Note"){tempstr3="textbox|Note" }
	   		if (DisplayTypeList[i]=="Sample"){tempstr4="Y"}	   		
   		}
   		DisplayTypeStr=tempstr1+"|"+tempstr2+"|"+tempstr3+"|"+tempstr4; //
   		var DisIf=obj.DisIf.getValue();  //是否显示
   		var RowNumber=obj.RowNumber.getValue();  //'行号|行高|列号|列高'，"|"分割
		//alert("Code="+Code+"--Desc="+Desc+"--DefAnrcmcDr="+DefAnrcmcDr+"--ClcmsDr="+ClcmsDr)
		//alert("Type="+Type+"--TestCode="+TestCode+"--ExamCode="+ExamCode+"--ConsultationCode="+ConsultationCode)
		var ret=_DHCANRCCheckItem.InsertANRCCheckItem(Code, Desc, DefAnrcmcDr, ClcmsDr, Type, TestCode, ExamCode, ConsultationCode,DisplayTypeStr,DisIf,RowNumber);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.Code.setValue("");
	  	  	obj.Desc.setValue("");
	  	  	obj.DefAnrcmcDr.setValue("");
			obj.ClcmsDr.setValue("");
			obj.Type.setValue("");
			obj.TestCode.setValue("");
			obj.ExamCode.setValue("");
			obj.ConsultationCode.setValue("");	  	  	
	  	  	obj.DisplayType.setValue("");
			obj.DisIf.setValue("");
	  	  	obj.RowNumber.setValue("");
	  	  	//obj.retGridPanelStore.load({});
	  	  	self.location.reload();  	  	
	  	  	});
		}
	}
	
	obj.updatebutton_click = function()
	{
	    if(obj.RowId.getValue()=="")
		{
		    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	        return;
		}
	  	if(obj.Code.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","代码不能为空!",function(){obj.Code.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.Desc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","名称不能为空!",function(){obj.Desc.focus(true,true);});
	  		return;
	  	};
	  	var RowId=obj.RowId.getValue();
        var Code=obj.Code.getValue();
		var Desc=obj.Desc.getValue();
		var DefAnrcmcDr=obj.AnrcmcDr;//obj.DefAnrcmcDr.getValue();
		var ClcmsDr=obj.ClcmsDr.getValue();
		var Type=obj.Type.getValue();
		var TestCode=obj.TestCode.getValue();
		var ExamCode=obj.ExamCode.getValue();
		var ConsultationCode=obj.ConsultationCode.getValue();
		var DisplayType=obj.DisplayType.getValue();  //获取显示方式
		var DisplayTypeStr="",tempstr1="|",tempstr2="|",tempstr3="|",tempstr4="N"
		var DisplayTypeList=DisplayType.split(",");
		for(var i=0;i<DisplayTypeList.length;i++)
   		{
	   		if (DisplayTypeList[i]=="Checked"){tempstr1="checkbox|Checked" }
	   		if (DisplayTypeList[i]=="Result"){tempstr2="checkbox|Result" }
	   		if (DisplayTypeList[i]=="Note"){tempstr3="textbox|Note" }
	   		if (DisplayTypeList[i]=="Sample"){tempstr4="Y"}	   		
   		}
   		DisplayTypeStr=tempstr1+"|"+tempstr2+"|"+tempstr3+"|"+tempstr4; //
   		var DisIf=obj.DisIf.getValue();  //是否显示
   		var RowNumber=obj.RowNumber.getValue();  //'行号|行高|列号|列高'，"|"分割
		var ret=_DHCANRCCheckItem.UpdateANRCCheckItem(RowId,Code, Desc, DefAnrcmcDr, ClcmsDr, Type, TestCode, ExamCode, ConsultationCode,DisplayTypeStr,DisIf,RowNumber);
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","修改失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","修改成功！",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.Code.setValue("");
	  	  	obj.Desc.setValue("");
	  	  	obj.DefAnrcmcDr.setValue("");
			obj.ClcmsDr.setValue("");
			obj.Type.setValue("");
			obj.TestCode.setValue("");
			obj.ExamCode.setValue("");
			obj.ConsultationCode.setValue("");	  	  	
	  	  	obj.DisplayType.setValue("");
			obj.DisIf.setValue("");
	  	  	obj.RowNumber.setValue("");
	  	  	//obj.retGridPanelStore.load({});
	  	  	self.location.reload();
		  	});
	     }
	 };
	 
	 obj.deletebutton_click = function()
	{
	  var RowId=obj.RowId.getValue();
	  //alert(ID);
	  if(RowId=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANRCCheckItem.DeleteANRCCheckItem(RowId);
	  	//alert(ret);
	  	if(ret!='0')
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.Code.setValue("");
	  	  	obj.Desc.setValue("");
	  	  	obj.DefAnrcmcDr.setValue("");
			obj.ClcmsDr.setValue("");
			obj.Type.setValue("");
			obj.TestCode.setValue("");
			obj.ExamCode.setValue("");
			obj.ConsultationCode.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}