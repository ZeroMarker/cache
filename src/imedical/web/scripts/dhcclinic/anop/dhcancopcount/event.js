
function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var DHCANCOPCount=ExtTool.StaticServerObject('web.DHCANCOPCount');
	var SelectedRowID = 0;
	var preRowID=0;
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
		
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc){ 
	    SelectedRowID=rc.get("tOPCountId");
	    if(preRowID!=SelectedRowID)
	    {
		    obj.RowId.setValue(rc.get("tOPCountId"));
		    obj.ancOPCCode.setValue(rc.get("OPCountCode"));
		    obj.ancOPCDesc.setValue(rc.get("OPCountDesc"));
			//obj.ancOPCModelDr.setValue(rc.get("tOPCountTypeId"))
		    //obj.ancOPCModelDr.setValue(rc.get("tOPCountTypeId")+" || "+rc.get("tOPCountType"));
		    preRowID=SelectedRowID;
	    }
	    else
	    {
			obj.RowId.setValue("");
		    obj.ancOPCCode.setValue("");
		    obj.ancOPCDesc.setValue("");
		    //obj.ancOPCModelDr.setValue("");
		    SelectedRowID = 0;
		    preRowID=0;
			obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    
		}
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.ancOPCCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.ancOPCDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		//alert(obj.tOPCountTypeId.getValue());
		//if(obj.ancOPCModelDr.getValue()=="")
		//{
			//ExtTool.alert("提示","清点型号不能为空!");	
			//return;
		//}		
		//var RowId = obj.RowId.getValue();
		var ancOPCCode=obj.ancOPCCode.getValue();           
		var ancOPCDesc=obj.ancOPCDesc.getValue();           
		//var ancOPCModelDr=obj.ancOPCModelDr.getValue();         

		var ret=DHCANCOPCount.AddMethod(ancOPCCode,ancOPCDesc);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("提示","记录ID不能为空!");	
			return;
		}
		if(obj.ancOPCCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.ancOPCDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		//if(obj.ancOPCModelDr.getValue()=="")
		//{
			//ExtTool.alert("提示","设备型号不能为空!");	
			//return;
		//}
		var RowId = obj.RowId.getValue();
		var ancOPCCode=obj.ancOPCCode.getValue();           
		var ancOPCDesc=obj.ancOPCDesc.getValue();           
		//var ancOPCModelDr=obj.ancOPCModelDr.getValue();
		var ret=DHCANCOPCount.UpdateMethod(RowId,ancOPCCode,ancOPCDesc);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue("");	  
	  	  	obj.retGridPanelStore.load({});  
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.RowId.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=DHCANCOPCount.DeleteMethod(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue("");		  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANCOPCount';
			param.QueryName = 'FindOPCount';
			param.Arg1=obj.ancOPCCode.getValue();
			param.Arg2=obj.ancOPCDesc.getValue();
			param.Arg3="" //obj.ancOPCModelDr.getValue();
			param.ArgCnt = 3;
		});
		obj.retGridPanelStore.load({});
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue("");	 
		obj.intCurrRowIndex = -1;
	};
}