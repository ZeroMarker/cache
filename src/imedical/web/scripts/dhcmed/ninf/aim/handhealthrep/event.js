function InitViewport1Event(obj) {
	obj.LoadEvent = function()
  {
  };
  	
  obj.RadioGroup1_change = function()
  {
  	var MeasuresValue="";
		var objMeasures=document.getElementsByName("Measures");	
		for(var i=0;i<objMeasures.length;i++)
		{	
			if(objMeasures.item(i).checked==true) MeasuresValue=objMeasures.item(i).value;
			
		}
		if((MeasuresValue==1)||(MeasuresValue==2))
		{
			//obj.RadioGroupYN.reset();
			obj.RadioGroup2.reset();
			obj.RadioGroupYN.enable(); //是否正确
		}
  }
	
	obj.RadioGroup2_change = function()
  {
  	var MeasuresValue="";
		var objMeasures=document.getElementsByName("Measures");	
		for(var i=0;i<objMeasures.length;i++)
		{	
			if(objMeasures.item(i).checked==true) MeasuresValue=objMeasures.item(i).value;
			
		}
		if((MeasuresValue==3)||(MeasuresValue==4))
		{
			//obj.RadioGroupYN.reset();
			obj.RadioGroup1.reset();
			obj.RadioGroupYN.disable(); //是否正确
		}
  }
	obj.HandHealthRep_rowclick = function()
	{
		var rc=obj.HandHealthRep.getSelectionModel().getSelected();
	  if(rc==null) return;
	  var ReportID=rc.get("RepID");
	  if(ReportID==obj.RepID.getValue()) ClearData(obj);
	  
	  else{
	  	
	  	ClearAllData(obj);
	  
	  	obj.RepID.setValue(ReportID);
	  	ExtTool.AddComboItem(obj.cboInfCtLoc,rc.get("LocDesc"),rc.get("CTLOCID"));
			ExtTool.AddComboItem(obj.cboInfCtLoc,rc.get("Wardesc"),rc.get("WardID"));
			obj.dtSurveryDate.setRawValue(rc.get("ObserveDate") + " " + rc.get("ObserveTime") );
			ExtTool.AddComboItem(obj.RepUser,rc.get("ObserverName"),rc.get("ObserverDR"));
			ExtTool.AddComboItem(obj.DocType,rc.get("IdentityDesc"),rc.get("Identity"));
			
			if(rc.get("HandAction")<3) obj.RadioGroup1.setValue(rc.get("HandAction"));
			else obj.RadioGroup2.setValue(rc.get("HandAction"));
			
			obj.RadioGroupYN.setValue(rc.get("HandActionRit"));
	  
	    var str=rc.get("HandPoint").split("/")
	    var len=str.length
	    for(i=0;i<len;i++)
	    {
	    	var objStore=obj.HandHealthGuide.getStore();
	 			for(var j=0;j<objStore.getCount();j++)
	  		{
	  			var rc=objStore.getAt(j);
	  			if(rc.get("Code")==str[i]) rc.set("checked",true);
	  		}
	    }
	  }
	};
	obj.BtnFind_click = function()
	{
		obj.HandHealthRepStore.load({params : {start:0,limit:1000}});
	}
	obj.BtnSave_click = function()
	{
		if((obj.cboInfCtLoc.getValue()=="")||(obj.cboInfCtLoc.getValue()==obj.cboInfCtLoc.getRawValue()))
		{
			alert("必须选择一个科室!!");
			return;	
		}
		if((obj.Ward.getValue()=="")||(obj.Ward.getValue()==obj.Ward.getRawValue()))
		{
			alert("必须选择一个病区!!");
			return;	
		}
		if((obj.RepUser.getValue()=="")||(obj.RepUser.getValue()==obj.RepUser.getRawValue()))
		{
			alert("必须选择一个报告人!!");
			return;	
		}
		if((obj.DocType.getValue()=="")||(obj.DocType.getValue()==obj.DocType.getRawValue()))
		{
			alert("必须选择一个专业类!!");
			return;	
		}
		if(obj.dtSurveryDate.getRawValue()=="")
		{
			alert("日期不能为空!!");	
			return;
		}
		
		var GuideList="";
		var objStore=obj.HandHealthGuide.getStore();
	  for(var i=0;i<objStore.getCount();i++)
	  {
	  	var rc=objStore.getAt(i);
	  	if(rc.get("checked"))
	  	{
	  		if(GuideList!="") GuideList=GuideList + "/" + rc.get("Code");
	  		if(GuideList=="") GuideList=rc.get("Code");
	  	}
	  }
	  if(GuideList=="")
	  {
	  	alert("请至少选择一条手卫生指针!!");	
	  	return;
	  }
		var MeasuresValue="";
		var objMeasures=document.getElementsByName("Measures");	
		for(var i=0;i<objMeasures.length;i++)
		{	
			if(objMeasures.item(i).checked==true) MeasuresValue=objMeasures.item(i).value;
			
		}
		if(MeasuresValue=="")
		{
			alert("手卫生措施不能为空!!");	
			return;
		}
		
		var YesNoValue="";
		var objYesNo=document.getElementsByName("YesNo");	
		for(var i=0;i<objYesNo.length;i++)
		{	
			if(objYesNo.item(i).checked==true) YesNoValue=objYesNo.item(i).value;
		}
		
		var arg = obj.RepID.getValue();
				arg += "^" + obj.cboInfCtLoc.getValue();
				arg += "^" + obj.dtSurveryDate.getRawValue().split(" ")[0];
				arg += "^" + obj.dtSurveryDate.getRawValue().split(" ")[1];
				arg += "^" + obj.RepUser.getValue();
				arg += "^" + obj.DocType.getValue();
				arg += "^" + GuideList;
				arg += "^" + MeasuresValue;
				
				if(obj.RadioGroupYN.disabled) arg += "^";
				else arg += "^" + YesNoValue;
				
				arg += "^" + obj.Ward.getValue();
		
		var objHandHealth = ExtTool.StaticServerObject("DHCMed.NINF.Aim.HandHealth");
		var ret=objHandHealth.Update(arg);
		if(ret>0) 
		{
			obj.HandHealthRepStore.load({params : {start:0,limit:1000}});
			ClearData(obj);
			return;	
		}
		else 
		{
			ExtTool.alert("提示","保存失败!");
			return;
		}
	}
	obj.BtnDelete_click = function()
	{
		var RepID=obj.RepID.getValue()
		if(RepID=="")
		{
			alert("请选中一行数据!!");
			return;	
		}
		var objHandHealth = ExtTool.StaticServerObject("DHCMed.NINF.Aim.HandHealth");
		var ret=objHandHealth.DeleteById(RepID);
		if(ret>-1)
		{
			ClearData(obj);
			obj.HandHealthRepStore.load({params : {start:0,limit:1000}});
		}else{
			alert("删除失败，请检查原因!!");
			return;
		}
	}
}
function ClearData(obj)
{
	obj.RepID.setValue("");
	
	var objStore=obj.HandHealthGuide.getStore();
	  for(var i=0;i<objStore.getCount();i++)
	  {
	  	var rc=objStore.getAt(i);
	  	rc.set("checked",false)
	  }
	  
	obj.RadioGroupYN.reset();
	obj.RadioGroup1.reset();
	obj.RadioGroup2.reset();
	obj.RadioGroupYN.enable();
}

function ClearAllData(obj)
{
	ClearData(obj);
	ExtTool.AddComboItem(obj.cboInfCtLoc,"","");
	ExtTool.AddComboItem(obj.Ward,"","");
	obj.dtSurveryDate.setRawValue("");
	ExtTool.AddComboItem(obj.RepUser,"","");
	ExtTool.AddComboItem(obj.DocType,"","");
	obj.RepID.setValue("");
}