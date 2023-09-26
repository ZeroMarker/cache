function InitViewScreenEvent(obj)
{
	var _DHCBPCEquipRunMode=ExtTool.StaticServerObject('web.DHCBPCEquipRunMode');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.bpcERMCode.setValue(rc.get("tBPCERMCode"));
	    obj.bpcERMDesc.setValue(rc.get("tBPCERMDesc"));
	    obj.Rowid.setValue(rc.get("tBPCERMRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.bpcERMCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcERMDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ��������Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcERMCode=obj.bpcERMCode.getValue();
		var bpcERMDesc=obj.bpcERMDesc.getValue();

		var ret=_DHCBPCEquipRunMode.InsertERunMode(bpcERMCode,bpcERMDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcERMCode.setValue("");
	  	  	obj.bpcERMDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.bpcERMCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ���벻��Ϊ��!",function(){obj.bpcERMCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.bpcERMDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ��������Ϊ��!",function(){obj.bpcERMDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var bpcERMCode=obj.bpcERMCode.getValue();
        var bpcERMDesc=obj.bpcERMDesc.getValue();
		var ret =_DHCBPCEquipRunMode.UpdateERunMode(Rowid,bpcERMCode,bpcERMDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcERMCode.setValue("");
	  	  	obj.bpcERMDesc.setValue("");
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
	  	var ret=_DHCBPCEquipRunMode.DeleteERunMode(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcERMCode.setValue("");
	  	  	obj.bpcERMDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

