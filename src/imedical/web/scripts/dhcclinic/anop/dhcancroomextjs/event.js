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
			    obj.Rowid.setValue(rc.get("tOprId"));	//������id
			    obj.opRoomDesc.setRawValue(rc.get("tOprDesc"));	//����������
			    obj.opRoomCode.setValue(rc.get("tOprCode"));	//���������
			    obj.oprAvailable.setValue(rc.get("tOprAvailable"));	//�Ƿ����
			    obj.oprNotAvailReason.setValue(rc.get("tOprNotAvailReason"));	//������ԭ��
			    obj.operLoc.setValue(rc.get("tOprCtLocId"));
			    obj.operLoc.setRawValue(rc.get("tOprCtLoc"));	//������
			    obj.oprCtDefUse.setValue(rc.get("tOprCtDefUseId"));
			    obj.oprCtDefUse.setRawValue(rc.get("tOprCtDefUse"));	//Ĭ����ƿ���
			    obj.oprCtFloor.setRawValue(rc.get("tOprCtFloor"));	//����¥��
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
			ExtTool.alert("��ʾ","��������벻��Ϊ��!");	
			return;
		}
		if(obj.opRoomDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���������Ʋ���Ϊ��!");	
			return;
		}
		
		var oprLocId=obj.operLoc.getValue();
		var oprCode=obj.opRoomCode.getValue(); 
		var oprDesc=obj.opRoomDesc.getValue();  
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
		var oprAvailable=obj.oprAvailable.getValue();                 
		var oprNotAvailReason=obj.oprNotAvailReason.getValue();       
		var ctlocDesc=obj.operLoc.getValue();  
		
		var defDesc=obj.oprCtDefUse.getRawValue();
		var oprCtDefUse=obj.oprCtDefUse.getValue();   
	  var checkFlag=_DHCANCRoom.CheckValidData(defDesc,oprCtDefUse);
	  if(checkFlag==0)
	  {
		alert("��������˵���ѡ�����")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }  
		var oprCtFloor=obj.oprCtFloor.getValue();  
       
		var ret=_DHCANCRoom.InsertOperRoom(oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"T");
	
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
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
			ExtTool.alert("��ʾ","δѡ��!");	
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
		alert("��������˵���ѡ�����")
		obj.oprCtDefUse.setValue("");
	   return;  
	  }  
		var oprCtFloor=obj.oprCtFloor.getValue();  
		//alert(oprCtFloor)  
       
		var ret=_DHCANCRoom.UpdateOperRoom(Rowid,oprLocId,oprCode,oprDesc,oprCtFloor,"",oprCtDefUse,oprAvailable,oprNotAvailReason,"T");
	
		if(ret!='0')
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
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