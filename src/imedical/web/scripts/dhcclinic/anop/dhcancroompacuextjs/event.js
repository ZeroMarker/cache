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
			ExtTool.alert("��ʾ","��������벻��Ϊ��!");	
			return;
		}
		if(obj.oprDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���������Ʋ���Ϊ��!");	
			return;
		}
		
		var oprLocId=obj.OperLoc.getValue();
		
		var oprCode=obj.oprCode.getValue(); 
		var oprDesc=obj.oprDesc.getValue();  
		var ret=_DHCANCRoom.RepOperRoom(oprCode,oprDesc);
		if(ret=="Y"){
		alert("�����������������ظ�,�޷����!")
		 return;
		}
		
		if(obj.oprCtFloor.getValue()=="")
		{
			ExtTool.alert("��ʾ","����¥�㲻��Ϊ��!");	
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
		alert("��������˵���ѡ�����")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }

		
		
		var oprCtFloor=obj.oprCtFloor.getValue();  
       //P�ǻָ��ң�T��������+20150313+dyl
		var ret=_DHCANCRoom.InsertOperRoom(oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"P");
	
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
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
			ExtTool.alert("��ʾ","δѡ��!");	
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
		alert("��������˵���ѡ�����")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }

		//alert(oprCtFloor)  
       //P�ǻָ��ң�T��������+20150313+dyl
		var ret=_DHCANCRoom.UpdateOperRoom(Rowid,oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"P");
	
		if(ret!='0')
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�"+ret);	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
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
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCRoom.DeleteOperRoom(RID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
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