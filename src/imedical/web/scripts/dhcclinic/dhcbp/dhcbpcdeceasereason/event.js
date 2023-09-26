function InitViewScreenEvent(obj)
{
	var _DHCBPCDeceaseReason=ExtTool.StaticServerObject('web.DHCBPCDeceaseReason');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.BPCDRCode.setValue(rc.get("tBPCDRCode"));
	    obj.BPCDRDesc.setValue(rc.get("tBPCDRDesc"));
	    obj.Rowid.setValue(rc.get("tBPCDRRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.BPCDRCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ���벻��Ϊ��!");	
			return;
		}
		if(obj.BPCDRDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ��������Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var BPCDRCode=obj.BPCDRCode.getValue();
		var BPCDRDesc=obj.BPCDRDesc.getValue();

		var ret=_DHCBPCDeceaseReason.AddDHCBPCDeceaseReason(BPCDRCode,BPCDRDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCDRCode.setValue("");
	  	  	obj.BPCDRDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
		var Rowid=obj.Rowid.getValue();
		if(Rowid==""||Rowid==null)
		{
			Ext.Msg.alert("��ʾ","��ѡ��Ҫ���µļ�¼��");
	  		return;
		}
	  	if(obj.BPCDRCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ���벻��Ϊ��!",function(){obj.BPCDRCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.BPCDRDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ��������Ϊ��!",function(){obj.BPCDRDesc.focus(true,true);});
	  		return;
	  	};
	  	
        var BPCDRCode=obj.BPCDRCode.getValue();
        var BPCDRDesc=obj.BPCDRDesc.getValue();
		var ret =_DHCBPCDeceaseReason.UpdateDHCBPCDeceaseReason(Rowid,BPCDRCode,BPCDRDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCDRCode.setValue("");
	  	  	obj.BPCDRDesc.setValue("");
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
	  	var ret=_DHCBPCDeceaseReason.DeleteDHCBPCDeceaseReason(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCDRCode.setValue("");
	  	  	obj.BPCDRDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

