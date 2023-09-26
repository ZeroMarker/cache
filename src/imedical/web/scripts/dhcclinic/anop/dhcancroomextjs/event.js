function InitViewScreenEvent(obj)
{
	var _DHCANCRoom=ExtTool.StaticServerObject('web.DHCANCRoom');
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
		  SelectedRowID=rc.get("tOprId");
		    if(preRowID!=SelectedRowID)
		    {   
			    obj.Rowid.setValue(rc.get("tOprId"));	//手术间id
			    obj.opRoomDesc.setRawValue(rc.get("tOprDesc"));	//手术间名称
			    obj.opRoomCode.setValue(rc.get("tOprCode"));	//手术间代码
			    obj.oprAvailable.setValue(rc.get("tOprAvailable"));	//是否可用
			    obj.oprNotAvailReason.setValue(rc.get("tOprNotAvailReason"));	//不可用原因
			    obj.operLoc.setValue(rc.get("tOprCtLocId"));
			    obj.operLoc.setRawValue(rc.get("tOprCtLoc"));	//手术室
			    obj.oprCtDefUse.setValue(rc.get("tOprCtDefUseId"));
			    obj.oprCtDefUse.setRawValue(rc.get("tOprCtDefUse"));	//默认外科科室
			    obj.oprCtFloor.setRawValue(rc.get("tOprCtFloor"));	//手术楼层
			    obj.oprCtFloor.setValue(rc.get("tOprCtFloorId"));
			    preRowID=SelectedRowID;
		    }
		  else
		  {
		  	  	obj.Rowid.setValue("");
		  	  	obj.opRoomCode.setValue("");
		  	  	obj.oprAvailable.setValue("");
		  	  	obj.opRoomDesc.setValue("");
		  	  	obj.oprNotAvailReason.setValue("");
		  	  	obj.operLoc.setValue("");
		  	  	obj.oprCtDefUse.setValue("");
		  	  	obj.oprCtFloor.setValue("");
		  	  	 obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		  	  	SelectedRowID = 0;
			    preRowID=0;	  	
		  }
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.ctlocDesc.getValue())
		if(obj.opRoomCode.getValue()=="")
		{
			ExtTool.alert("提示","手术间代码不能为空!");	
			return;
		}
		if(obj.opRoomDesc.getValue()=="")
		{
			ExtTool.alert("提示","手术间名称不能为空!");	
			return;
		}
		
		var oprLocId=obj.operLoc.getValue();
		var oprCode=obj.opRoomCode.getValue(); 
		var oprDesc=obj.opRoomDesc.getValue();  
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
		var oprAvailable=obj.oprAvailable.getValue();                 
		var oprNotAvailReason=obj.oprNotAvailReason.getValue();       
		var ctlocDesc=obj.operLoc.getValue();  
		
		var defDesc=obj.oprCtDefUse.getRawValue();
		var oprCtDefUse=obj.oprCtDefUse.getValue();   
	  var checkFlag=_DHCANCRoom.CheckValidData(defDesc,oprCtDefUse);
	  if(checkFlag==0)
	  {
		alert("请从下拉菜单中选择科室")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }  
		var oprCtFloor=obj.oprCtFloor.getValue();  
       
		var ret=_DHCANCRoom.InsertOperRoom(oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"T");
	
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.opRoomCode.setValue("");
	  	  	obj.oprAvailable.setValue("");
	  	  	obj.opRoomDesc.setValue("");
	  	  	obj.oprNotAvailReason.setValue("");
	  	  	obj.operLoc.setValue("");
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
		var oprLocId=obj.operLoc.getValue();
		var oprCode=obj.opRoomCode.getValue();           
		var oprAvailable=obj.oprAvailable.getValue();           
		var oprDesc=obj.opRoomDesc.getValue();        
		var oprNotAvailReason=obj.oprNotAvailReason.getValue();       
		var ctlocDesc=obj.operLoc.getValue();  
		var defDesc=obj.oprCtDefUse.getRawValue();
		var oprCtDefUse=obj.oprCtDefUse.getValue();   
	  var checkFlag=_DHCANCRoom.CheckValidData(defDesc,oprCtDefUse);
	  if(checkFlag==0)
	  {
		alert("请从下拉菜单中选择科室")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }  
		var oprCtFloor=obj.oprCtFloor.getValue();  
		//alert(oprCtFloor)  
       
		var ret=_DHCANCRoom.UpdateOperRoom(Rowid,oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"T");
	
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.opRoomCode.setValue("");
	  	  	obj.oprAvailable.setValue("");
	  	  	obj.opRoomDesc.setValue("");
	  	  	obj.oprNotAvailReason.setValue("");
	  	  	obj.operLoc.setValue("");
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
	  	  	obj.Rowid.setValue("");
	  	  	obj.opRoomCode.setValue("");
	  	  	obj.oprAvailable.setValue("");
	  	  	obj.opRoomDesc.setValue("");
	  	  	obj.oprNotAvailReason.setValue("");
	  	  	obj.operLoc.setValue("");
	  	  	obj.oprCtDefUse.setValue("");
	  	  	obj.oprCtFloor.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}