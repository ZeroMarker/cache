function InitViewScreenEvent(obj)
{
	var DHCANCOPLevel=ExtTool.StaticServerObject('web.DHCANCOPLevel');
	obj.LoadEvent = function(args) 
	{
		obj.Rowid.setValue("");
	};
    var SelectedRowID = 0;
	var preRowID=0;
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		SelectedRowID=rc.get("RowId");
	    if(preRowID!=SelectedRowID)
	    {  
		    obj.anCOPLCode.setValue(rc.get("ANCOPL_Code"));
		    obj.anCOPLDesc.setValue(rc.get("ANCOPL_Desc"));
		    obj.Rowid.setValue(rc.get("RowId"));
		    preRowID=SelectedRowID;
	    }
	    else
	    {
		    obj.anCOPLCode.setValue("");
		    obj.anCOPLDesc.setValue("");
		    obj.Rowid.setValue("");
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    SelectedRowID = 0;
		    preRowID=0;
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		}
	  }
	};
	
	obj.addbutton_click = function()
	{
		
		//alert(obj.floorno.getValue());
		if(obj.anCOPLCode.getValue()=="")
		{
			ExtTool.alert("提示","手术规模代码不能为空!");	
			return;
		}
		if(obj.anCOPLDesc.getValue()=="")
		{
			ExtTool.alert("提示","手术规模描述不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var anCOPLCode=obj.anCOPLCode.getValue();
		var anCOPLDesc=obj.anCOPLDesc.getValue();

		var ret=DHCANCOPLevel.InsertANCOPLevel(anCOPLCode,anCOPLDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.anCOPLCode.setValue("");
	  	  	obj.anCOPLDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","请先选中一行记录!");	
			return;
		}
	  	if(obj.anCOPLCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式代码不能为空!",function(){obj.anCOPLCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.anCOPLDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式描述不能为空!",function(){obj.anCOPLDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var anCOPLCode=obj.anCOPLCode.getValue();
        var anCOPLDesc=obj.anCOPLDesc.getValue();
		var ret =DHCANCOPLevel.UpdateANCOPLevel(Rowid,anCOPLCode,anCOPLDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.anCOPLCode.setValue("");
	  	  	obj.anCOPLDesc.setValue("");
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
	  	var ret=DHCANCOPLevel.DeleteANCOPLevel(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.anCOPLCode.setValue("");
	  	  	obj.anCOPLDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

