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
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.Desc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ʋ���Ϊ��!");	
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
		var DisplayType=obj.DisplayType.getValue();  //��ȡ��ʾ��ʽ
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
   		var DisIf=obj.DisIf.getValue();  //�Ƿ���ʾ
   		var RowNumber=obj.RowNumber.getValue();  //'�к�|�и�|�к�|�и�'��"|"�ָ�
		//alert("Code="+Code+"--Desc="+Desc+"--DefAnrcmcDr="+DefAnrcmcDr+"--ClcmsDr="+ClcmsDr)
		//alert("Type="+Type+"--TestCode="+TestCode+"--ExamCode="+ExamCode+"--ConsultationCode="+ConsultationCode)
		var ret=_DHCANRCCheckItem.InsertANRCCheckItem(Code, Desc, DefAnrcmcDr, ClcmsDr, Type, TestCode, ExamCode, ConsultationCode,DisplayTypeStr,DisIf,RowNumber);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
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
		    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	        return;
		}
	  	if(obj.Code.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���벻��Ϊ��!",function(){obj.Code.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.Desc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���Ʋ���Ϊ��!",function(){obj.Desc.focus(true,true);});
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
		var DisplayType=obj.DisplayType.getValue();  //��ȡ��ʾ��ʽ
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
   		var DisIf=obj.DisIf.getValue();  //�Ƿ���ʾ
   		var RowNumber=obj.RowNumber.getValue();  //'�к�|�и�|�к�|�и�'��"|"�ָ�
		var ret=_DHCANRCCheckItem.UpdateANRCCheckItem(RowId,Code, Desc, DefAnrcmcDr, ClcmsDr, Type, TestCode, ExamCode, ConsultationCode,DisplayTypeStr,DisIf,RowNumber);
		if(ret!='0')
		{
		  Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","�޸ĳɹ���",function(){
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
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANRCCheckItem.DeleteANRCCheckItem(RowId);
	  	//alert(ret);
	  	if(ret!='0')
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
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