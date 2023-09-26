function InitViewScreenEvent(obj)
{
    var _DHCANRCRiskAssess=ExtTool.StaticServerObject('web.DHCANRCRiskAssess');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick=function()
	{
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		  
	        obj.OperDiffculty.setValue(rc.get("OperDiffcultyDr"));
	        obj.ASA.setValue(rc.get("ASADr"));
	        obj.RowId.setValue(rc.get("RowId"));
			obj.Ctloc.setValue(rc.get("CtlocDr"));
			obj.Anrcrc.setValue(rc.get("AnrcrcDr"));
	  }
	}
	
	obj.addbutton_click=function()
	{
		ExtTool.alert("123","add");
	    if(obj.OperDiffculty.getValue()=="")
		{
			ExtTool.alert("提示","手术难度分类不能为空!");	
			return;
		}
		if(obj.ASA.getValue()=="")
		{
			ExtTool.alert("提示","ASA分级不能为空!");	
			return;
		}
		if(obj.Anrcrc.getValue()=="")
		{
			ExtTool.alert("提示","手术风险级别不能为空!");	
			return;
		}
		if(obj.Ctloc.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!");	
			return;
		}
		
		var OperDiffculty=obj.OperDiffculty.getValue();
		var ASA=obj.ASA.getValue();
		var Anrcrc=obj.Anrcrc.getValue();
		var Ctloc=obj.Ctloc.getValue();
		//alert(OperDiffculty+"--"+ASA+"--"+Anrcrc+"--"+Ctloc)
		var ret=_DHCANRCRiskAssess.InsertANRCRiskAssess(OperDiffculty, ASA,Anrcrc,Ctloc);
		//alert(ret);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.OperDiffculty.setValue("");
	  	  	obj.ASA.setValue("");
	  	  	obj.Anrcrc.setValue("");
			obj.Ctloc.setValue("");
			obj.store.load(); 
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
		if(obj.OperDiffculty.getValue()=="")
		{
			ExtTool.alert("提示","手术难度分类不能为空!",function(){obj.Code.focus(true,true);});	
			return;
		}
		if(obj.ASA.getValue()=="")
		{
			ExtTool.alert("提示","ASA分级不能为空!",function(){obj.Code.focus(true,true);});	
			return;
		}
		if(obj.Anrcrc.getValue()=="")
		{
			ExtTool.alert("提示","手术风险级别不能为空!",function(){obj.Code.focus(true,true);});	
			return;
		}
		if(obj.Ctloc.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!",function(){obj.Code.focus(true,true);});	
			return;
		}
	  	var RowId=obj.RowId.getValue();
        var OperDiffculty=obj.OperDiffculty.getValue();
		var ASA=obj.ASA.getValue();
		var Anrcrc=obj.Anrcrc.getValue();
		var Ctloc=obj.Ctloc.getValue();

		var ret=_DHCANRCRiskAssess.UpdateANRCRiskAssess(RowId,OperDiffculty, ASA,Anrcrc,Ctloc);
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","修改失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","修改成功！",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.OperDiffculty.setValue("");
	  	  	obj.ASA.setValue("");
	  	  	obj.Anrcrc.setValue("");
			obj.Ctloc.setValue("");
			obj.store.load(); 
			
		  	});
	     }
	 };
	 
	 obj.deletebutton_click = function()
	{
	  var RowId=obj.RowId.getValue();
	  if(RowId=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANRCRiskAssess.DeleteANRCRiskAssess(RowId);
	  	//alert(ret);
	  	if(ret!='0')
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.OperDiffculty.setValue("");
	  	  	obj.ASA.setValue("");
	  	  	obj.Anrcrc.setValue("");
			obj.Ctloc.setValue("");
			obj.store.load(); 
	  	  	});

	  	}
	  );
	};
}