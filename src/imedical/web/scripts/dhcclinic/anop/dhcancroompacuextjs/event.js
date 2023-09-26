function InitViewScreenEvent(obj)
{
	var _DHCANCRoom=ExtTool.StaticServerObject('web.DHCANCRoom');
	
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
		  SelectedRowID=rc.get("tOprId");
	    if(preRowID!=SelectedRowID)
	    {   
		    obj.Rowid.setValue(rc.get("tOprId"));
		    obj.oprCode.setValue(rc.get("tOprCode"));
		    obj.oprAvailable.setValue(rc.get("tOprAvailable"));
		    obj.oprDesc.setValue(rc.get("tOprDesc"));
		    obj.oprNotAvailReason.setValue(rc.get("tOprNotAvailReason"));
		    obj.OperLoc.setValue(rc.get("tOprCtLoc"));
		    obj.oprCtDefUse.setValue(rc.get("tOprCtDefUse"));
		    obj.oprCtFloor.setValue(rc.get("tOprCtFloor"));
	     
		     ExtTool.AddComboItem(obj.oprCtFloor,rc.get("tOprCtFloor"),rc.get("tOprCtFloorId"))
		     ExtTool.AddComboItem(obj.OperLoc,rc.get("tOprCtLoc"),rc.get("tOprCtLocId"))
		     ExtTool.AddComboItem(obj.oprCtDefUse,rc.get("tOprCtDefUse"),rc.get("tOprCtDefUseId"))
		     ExtTool.AddComboItem(obj.oprNotAvailReason,rc.get("tOprNotAvailReason"),rc.get("tOprNotAvailReasonId"))
	  		preRowID=SelectedRowID;
	  }
	  else
	  {
		  	obj.Rowid.setValue("");
		  	obj.oprCode.setValue("");
		    obj.oprAvailable.setValue("");
		    obj.oprDesc.setValue("");
		    obj.oprNotAvailReason.setValue("");
		    obj.OperLoc.setValue("");
		    obj.oprCtDefUse.setValue("");
		    obj.oprCtFloor.setValue("");
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    SelectedRowID = 0;
		    preRowID=0;

		   obj.retGridPanel.getSelectionModel().deselectRow(linenum);
	  }
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.OperLoc.getValue())
		if(obj.oprCode.getValue()=="")
		{
			ExtTool.alert("提示","手术间代码不能为空!");	
			return;
		}
		if(obj.oprDesc.getValue()=="")
		{
			ExtTool.alert("提示","手术间名称不能为空!");	
			return;
		}
		
		var oprLocId=obj.OperLoc.getValue();
		
		var oprCode=obj.oprCode.getValue(); 
		var oprDesc=obj.oprDesc.getValue();  
		var ret=_DHCANCRoom.RepOperRoom(oprCode,oprDesc);
		if(ret=="Y"){
		alert("手术间代码或名称有重复,无法添加!")
		 return;
		}
		
		if(obj.oprCtFloor.getValue()=="")
		{
			ExtTool.alert("提示","手术楼层不能为空!");	
			return;
		}
		
		//var oprNotAvailReason=obj.oprNotAvailReason.getRawValue();
		var oprAvailable=obj.oprAvailable.getValue();                 
		var oprNotAvailReason=obj.oprNotAvailReason.getValue();       
		 
		var oprCtDefUse=obj.oprCtDefUse.getValue();   
		var defDesc=obj.oprCtDefUse.getRawValue();
	  var checkFlag=_DHCANCRoom.CheckValidData(defDesc,oprCtDefUse);
	  if(checkFlag==0)
	  {
		alert("请从下拉菜单中选择科室")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }

		
		
		var oprCtFloor=obj.oprCtFloor.getValue();  
       //P是恢复室，T：手术间+20150313+dyl
		var ret=_DHCANCRoom.InsertOperRoom(oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"P");
	
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.oprCode.setValue("");
	  	  	obj.oprAvailable.setValue("");
	  	  	obj.oprDesc.setValue("");
	  	  	obj.oprNotAvailReason.setValue("");
	  	  	obj.OperLoc.setValue("");
	  	  	obj.oprCtDefUse.setValue("");
	  	  	obj.oprCtFloor.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","未选中!");	
			return;
		}		
		
		var Rowid=obj.Rowid.getValue();
		var oprLocId=obj.OperLoc.getValue();
		var oprCode=obj.oprCode.getValue();           
		var oprAvailable=obj.oprAvailable.getValue();           
		var oprDesc=obj.oprDesc.getValue();        
		var oprNotAvailReason=obj.oprNotAvailReason.getValue();       
		var oprCtDefUse=obj.oprCtDefUse.getValue(); 
		var oprCtFloor=obj.oprCtFloor.getValue();  
		var defDesc=obj.oprCtDefUse.getRawValue();
	  var checkFlag=_DHCANCRoom.CheckValidData(defDesc,oprCtDefUse);
	  if(checkFlag==0)
	  {
		alert("请从下拉菜单中选择科室")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }

		//alert(oprCtFloor)  
       //P是恢复室，T：手术间+20150313+dyl
		var ret=_DHCANCRoom.UpdateOperRoom(Rowid,oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"P");
	
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","更新失败！"+ret);	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.oprCode.setValue("");
	  	  	obj.oprAvailable.setValue("");
	  	  	obj.oprDesc.setValue("");
	  	  	obj.oprNotAvailReason.setValue("");
	  	  	obj.OperLoc.setValue("");
	  	  	obj.oprCtDefUse.setValue("");
	  	  	obj.oprCtFloor.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var RID=obj.Rowid.getValue();
	  
	  if(RID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCRoom.DeleteOperRoom(RID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.oprCode.setValue("");
	  	  	obj.oprAvailable.setValue("");
	  	  	obj.oprDesc.setValue("");
	  	  	obj.oprNotAvailReason.setValue("");
	  	  	obj.OperLoc.setValue("");
	  	  	obj.oprCtDefUse.setValue("");
	  	  	obj.oprCtFloor.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}