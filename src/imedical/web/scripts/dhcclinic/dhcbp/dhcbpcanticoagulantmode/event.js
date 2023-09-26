function InitViewScreenEvent(obj)
{
	var _DHCBPCAnticoagulantMode=ExtTool.StaticServerObject('web.DHCBPCAnticoagulantMode');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    //alert(rc.get("tClcmId"))
	    obj.Rowid.setValue(rc.get("tBPCAMRowId"));
	    obj.bpcAMCode.setValue(rc.get("tBPCAMCode"));
	    obj.bpcAMDesc.setValue(rc.get("tBPCAMDesc"));
	    obj.IfSelectDrug.setValue(rc.get("ifSelectDrug"));
	    obj.Active.setValue(rc.get("ifActive"));
	    obj.SubType.setValue(rc.get("tBPCAMSubType"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcAMCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcAMDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		
		var bpcAMCode=obj.bpcAMCode.getValue();           
		var bpcAMDesc=obj.bpcAMDesc.getValue();           
		var ifSelectDrug=obj.IfSelectDrug.getValue();        
		var ifActive=obj.Active.getValue();  
		var bpcAMSubType=obj.SubType.getValue();      
		var ret=_DHCBPCAnticoagulantMode.InsertAntMode(bpcAMCode,bpcAMDesc,ifSelectDrug,ifActive,bpcAMSubType);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.bpcAMCode.setValue("");
	  	  	obj.bpcAMDesc.setValue("");
			obj.IfSelectDrug.setValue("");    
			obj.Active.setValue("");
			obj.SubType.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert("gg")
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼IdΪ��!");	
			return;
		}
		if(obj.bpcAMCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcAMDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		var Rowid=obj.Rowid.getValue(); 
		var bpcAMCode=obj.bpcAMCode.getValue();           
		var bpcAMDesc=obj.bpcAMDesc.getValue();           
		var ifSelectDrug=obj.IfSelectDrug.getValue();        
		var ifActive=obj.Active.getValue(); 
		var bpcAMSubType=obj.SubType.getValue();
		var ret=_DHCBPCAnticoagulantMode.UpdateAntMode(Rowid,bpcAMCode,bpcAMDesc,ifSelectDrug,ifActive,bpcAMSubType);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	//obj.Rowid.setValue("");
		  	obj.bpcAMCode.setValue("");
	  	  	obj.bpcAMDesc.setValue("");
	  	  	obj.IfSelectDrug.setValue("");    
			obj.Active.setValue("");
			obj.SubType.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCAnticoagulantMode.DeleteAntMode(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
		  	obj.bpcAMCode.setValue("");
	  	  	obj.bpcAMDesc.setValue("");
	  	  	obj.IfSelectDrug.setValue("");    
			obj.Active.setValue("");
			obj.SubType.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}