function InitViewScreenEvent(obj)
{
	var _DHCCLCScore=ExtTool.StaticServerObject('web.DHCCLCScore');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.mainclcs.setValue(rc.get("TCLCSLMainCLCSDr"));
	    obj.linkclcs.setValue(rc.get("TCLCSLLinkCLCSDr"));
	    obj.Rowid.setValue(rc.get("TRowid"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.mainclcs.getValue()=="")
		{
			ExtTool.alert("提示","主评分不能为空!");	
			return;
		}
		if(obj.linkclcs.getValue()=="")
		{
			ExtTool.alert("提示","关联评分不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var mainclcs=obj.mainclcs.getValue();
		var linkclcs=obj.linkclcs.getValue();
		var sameFlag=_DHCCLCScore.CompareClCSLink(mainclcs,linkclcs,"")
		if(sameFlag==1)
		{
			alert("关联评分项重复");
			return;
		}
		var ret=_DHCCLCScore.InsertClCSLink(mainclcs,linkclcs);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.mainclcs.setValue("");
	  	  	obj.linkclcs.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.Rowid.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","ID号不能为空!",function(){obj.floorno.focus(true,true);});
	  		return;
	  	} ;

	  	if(obj.mainclcs.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","主评分不能为空!",function(){obj.floorno.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.linkclcs.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","关联评分不能为空!",function(){obj.floorname.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var mainclcs=obj.mainclcs.getValue();
        var linkclcs=obj.linkclcs.getValue();
        var sameFlag=_DHCCLCScore.CompareClCSLink(mainclcs,linkclcs,Rowid)
		if(sameFlag==1)
		{
			alert("关联评分项已存在");
			return;
		}
		var ret = _DHCCLCScore.UpdateClCSLink(Rowid,mainclcs,linkclcs);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.mainclcs.setValue("");
	  	  	obj.linkclcs.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCCLCScore.DeleteClCSLink(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.mainclcs.setValue("");
	  	  	obj.linkclcs.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

