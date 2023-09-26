function InitViewScreenEvent(obj)
{
	var _DHCBPCBloodPurificationMode=ExtTool.StaticServerObject('web.DHCBPCBloodPurificationMode');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.BPCBPMCode.setValue(rc.get("tBPCBPMCode"));
	    obj.BPCBPMDesc.setValue(rc.get("tBPCBPMDesc"));
	    obj.BPCBPMIsSpecial.setValue(rc.get("tBPCBPMIsSpecial"));
	    obj.Rowid.setValue(rc.get("tBPCBPMRowId"));
	    obj.ctlocdesc.setRawValue(rc.get("tBPCBPMDept"))
	    obj.ctlocdesc.setValue(rc.get("tBPCBPMDeptDr"))
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.BPCBPMCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ���벻��Ϊ��!");	
			return;
		}
		if(obj.BPCBPMDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","ģʽ��������Ϊ��!");	
			return;
		}
		if(obj.BPCBPMIsSpecial.getValue()=="")
		{
			ExtTool.alert("��ʾ","�Ƿ����ⲻ��Ϊ��!");	
			return;
		}
		
		//var RowId = obj.RowId.getValue();
		var BPCBPMCode=obj.BPCBPMCode.getValue();
		var BPCBPMDesc=obj.BPCBPMDesc.getValue();
		var BPCBPMIsSpecial=obj.BPCBPMIsSpecial.getValue();
		var ctloc=obj.ctlocdesc.getValue();
		var ret=_DHCBPCBloodPurificationMode.Add(BPCBPMCode,BPCBPMDesc,BPCBPMIsSpecial,ctloc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCBPMCode.setValue("");
	  	  	obj.BPCBPMDesc.setValue("");
	  	  	obj.BPCBPMIsSpecial.setValue("");
	  	  	obj.ctlocdesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.BPCBPMCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ���벻��Ϊ��!",function(){obj.BPCBPMCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.BPCBPMDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ��������Ϊ��!",function(){obj.BPCBPMDesc.focus(true,true);});
	  		return;
	  	};
	  	if(obj.BPCBPMIsSpecial.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ��������Ϊ��!",function(){obj.BPCBPMIsSpecial.focus(true,true);});
	  		return;
	  	};
	  	
	  	var Rowid=obj.Rowid.getValue();
        var BPCBPMCode=obj.BPCBPMCode.getValue();
        var BPCBPMDesc=obj.BPCBPMDesc.getValue();
        var BPCBPMIsSpecial=obj.BPCBPMIsSpecial.getValue();
        var ctloc=obj.ctlocdesc.getValue();
		var ret =_DHCBPCBloodPurificationMode.Update(Rowid,BPCBPMCode,BPCBPMDesc,BPCBPMIsSpecial,ctloc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCBPMCode.setValue("");
	  	  	obj.BPCBPMDesc.setValue("");
	  	  	obj.BPCBPMIsSpecial.setValue("");
	  	  	obj.ctlocdesc.setValue("");
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
	  	var ret=_DHCBPCBloodPurificationMode.Delete(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCBPMCode.setValue("");
	  	  	obj.BPCBPMDesc.setValue("");
	  	  	obj.BPCBPMIsSpecial.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

