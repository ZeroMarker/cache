function InitViewScreenEvent(obj)
{
	var _DHCBPCVisitStatus=ExtTool.StaticServerObject('web.DHCBPCVisitStatus');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.bpcVSCode.setValue(rc.get("tBPCVSCode"));
	    obj.bpcVSDesc.setValue(rc.get("tBPCVSDesc"));
	    obj.Rowid.setValue(rc.get("tBPCVSRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.bpcVSCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcVSDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ��������Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcVSCode=obj.bpcVSCode.getValue();
		var bpcVSDesc=obj.bpcVSDesc.getValue();

		var ret=_DHCBPCVisitStatus.InsertVStatus(bpcVSCode,bpcVSDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVSCode.setValue("");
	  	  	obj.bpcVSDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.bpcVSCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ���벻��Ϊ��!",function(){obj.bpcVSCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.bpcVSDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ��������Ϊ��!",function(){obj.bpcVSDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var bpcVSCode=obj.bpcVSCode.getValue();
        var bpcVSDesc=obj.bpcVSDesc.getValue();
		var ret =_DHCBPCVisitStatus.UpdateVStatus(Rowid,bpcVSCode,bpcVSDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVSCode.setValue("");
	  	  	obj.bpcVSDesc.setValue("");
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
	  	var ret=_DHCBPCVisitStatus.DeleteVStatus(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVSCode.setValue("");
	  	  	obj.bpcVSDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

