function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCBPCNurseGroup=ExtTool.StaticServerObject('web.DHCBPCNurseGroup');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("rowId"));
	    obj.bpcNGCode.setValue(rc.get("Code"));
	    obj.bpcNGDesc.setValue(rc.get("Desc"));
	    obj.bpcNGWardDr.setValue(rc.get("WardId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcNGCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcNGDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		if(obj.bpcNGWardDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}		
		//var RowId = obj.RowId.getValue();
		var bpcNGCode=obj.bpcNGCode.getValue();           
		var bpcNGDesc=obj.bpcNGDesc.getValue();           
		var bpcNGWardDr=obj.bpcNGWardDr.getValue();  
		var bpcNGString=bpcNGCode+"^"+bpcNGDesc+"^"+bpcNGWardDr       
        //alert(bpcNGString)
		var ret=_DHCBPCNurseGroup.AddNurseGroup(bpcNGString);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcNGCode.setValue("");
	  	  	obj.bpcNGDesc.setValue("");
	  	  	obj.bpcNGWardDr.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert(obj.RowId.getValue())
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼ID����Ϊ��!");	
			return;
		}
		if(obj.bpcNGCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcNGDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		if(obj.bpcNGWardDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}		
		var RowId = obj.RowId.getValue();
		var bpcNGCode=obj.bpcNGCode.getValue();           
		var bpcNGDesc=obj.bpcNGDesc.getValue();           
		var bpcNGWardDr=obj.bpcNGWardDr.getValue();  
		var bpcNGString=bpcNGCode+"^"+bpcNGDesc+"^"+bpcNGWardDr;       
        
	   
		var ret=_DHCBPCNurseGroup.UpdateNurseGroup(RowId,bpcNGString);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcNGCode.setValue("");
	  	  	obj.bpcNGDesc.setValue("");
	  	  	obj.bpcNGWardDr.setValue(""); 	  
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
	  	var ret=_DHCBPCNurseGroup.DeleteNurseGroup(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcNGCode.setValue("");
	  	  	obj.bpcNGDesc.setValue("");
	  	  	obj.bpcNGWardDr.setValue(""); 	  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
//	obj.findbutton_click = function(){
//		obj.retGridPanelStore.load({});
//			obj.RowId.setValue("");
//	  	  	obj.bpcEPCode.setValue("");
//	  	  	obj.bpcEPDesc.setValue("");
//	  	  	obj.bpcEPModelDr.setValue("");	 
//		obj.intCurrRowIndex = -1;
//	};
}