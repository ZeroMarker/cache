function InitViewScreenEvent(obj)
{
	var _DHCBPCNurse=ExtTool.StaticServerObject('web.DHCBPCNurse');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		///alert(1);
	    obj.BPCNBPCNurseGroupDr.setValue(rc.get("tBPCNBPCNurseGroupDr"));
	    obj.BPCNNurseCTCPDr.setValue(rc.get("tBPCNNurseCTCPDr"));
	    obj.Rowid.setValue(rc.get("tBPCNRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		///alert(obj.BPCBPMCode.getValue());
		if(obj.BPCNBPCNurseGroupDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʿ�鲻��Ϊ��!");	
			return;
		}
		if(obj.BPCNNurseCTCPDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҽ����Ա����Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var BPCNBPCNurseGroupDr=obj.BPCNBPCNurseGroupDr.getValue();
		var BPCNNurseCTCPDr=obj.BPCNNurseCTCPDr.getValue();

		var ret=_DHCBPCNurse.AddDHCBPCNurse(BPCNBPCNurseGroupDr,BPCNNurseCTCPDr);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCNBPCNurseGroupDr.setValue("");
	  	  	obj.BPCNNurseCTCPDr.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.BPCNBPCNurseGroupDr.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","��ʿ�鲻��Ϊ��!",function(){obj.BPCNBPCNurseGroupDr.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.BPCNNurseCTCPDr.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ҽ����Ա����Ϊ��!",function(){obj.BPCNNurseCTCPDr.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var BPCNBPCNurseGroupDr=obj.BPCNBPCNurseGroupDr.getValue();
        var BPCNNurseCTCPDr=obj.BPCNNurseCTCPDr.getValue();
		var ret =_DHCBPCNurse.UpdateDHCBPCNurse(Rowid,BPCNBPCNurseGroupDr,BPCNNurseCTCPDr);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCNBPCNurseGroupDr.setValue("");
	  	  	obj.BPCNNurseCTCPDr.setValue("");
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
	  	var ret=_DHCBPCNurse.DeleteDHCBPCNurse(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCNBPCNurseGroupDr.setValue("");
	  	  	obj.BPCNNurseCTCPDr.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

