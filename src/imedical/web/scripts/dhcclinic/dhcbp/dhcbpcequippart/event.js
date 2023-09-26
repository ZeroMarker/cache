function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCBPCEquipPart=ExtTool.StaticServerObject('web.DHCBPCEquipPart');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("tBPCEPRowId"));
	    obj.bpcEPCode.setValue(rc.get("tBPCEPCode"));
	    obj.bpcEPDesc.setValue(rc.get("tBPCEPDesc"));
	    obj.bpcEPModelDr.setValue(rc.get("tBPCEPBPCEquipModelDr"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcEPCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcEPDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		if(obj.bpcEPModelDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","�豸�ͺŲ���Ϊ��!");	
			return;
		}		
		//var RowId = obj.RowId.getValue();
		var bpcEPCode=obj.bpcEPCode.getValue();           
		var bpcEPDesc=obj.bpcEPDesc.getValue();           
		var bpcEPModelDr=obj.bpcEPModelDr.getValue();         

		var ret=_DHCBPCEquipPart.InsertEPart(bpcEPModelDr,bpcEPCode,bpcEPDesc);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼ID����Ϊ��!");	
			return;
		}
		if(obj.bpcEPCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcEPDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		if(obj.bpcEPModelDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","�豸�ͺŲ���Ϊ��!");	
			return;
		}
		var RowId = obj.RowId.getValue();
		var bpcEPCode=obj.bpcEPCode.getValue();           
		var bpcEPDesc=obj.bpcEPDesc.getValue();           
		var bpcEPModelDr=obj.bpcEPModelDr.getValue();
	
		var ret=_DHCBPCEquipPart.UpdateEPart(RowId,bpcEPModelDr,bpcEPCode,bpcEPDesc);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue("");	  
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
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCEquipPart.DeleteEPart(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue("");		  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStore.load({});
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue("");	 
		obj.intCurrRowIndex = -1;
	};
}