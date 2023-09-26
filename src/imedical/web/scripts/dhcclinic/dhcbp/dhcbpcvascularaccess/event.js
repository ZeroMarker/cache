function InitViewScreenEvent(obj)
{
	var _DHCBPCVascularAccess=ExtTool.StaticServerObject('web.DHCBPCVascularAccess');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.bpcVACode.setValue(rc.get("tBPCVACode"));
	    obj.bpcVADesc.setValue(rc.get("tBPCVADesc"));
	    obj.Rowid.setValue(rc.get("tBPCVARowId"));
	    obj.ctlocdesc.setRawValue(rc.get("tBPCVADept"))
	    obj.ctlocdesc.setValue(rc.get("tBPCVADeptDr"))
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.bpcVACode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcVADesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		if(obj.ctlocdesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ҳ���Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcVACode=obj.bpcVACode.getValue();
		var bpcVADesc=obj.bpcVADesc.getValue();
		var ctloc=obj.ctlocdesc.getValue();
		
		var ret=_DHCBPCVascularAccess.InsertVasAccess(bpcVACode,bpcVADesc,ctloc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVACode.setValue("");
	  	  	obj.bpcVADesc.setValue("");
	  	  	obj.ctlocdesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.bpcVACode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���벻��Ϊ��!",function(){obj.bpcVACode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.bpcVADesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","��������Ϊ��!",function(){obj.bpcVADesc.focus(true,true);});
	  		return;
	  	};
	  	if(obj.ctlocdesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ҳ���Ϊ��!",function(){obj.ctlocdesc.focus(true,true);});	
			return;
		}
	  	var Rowid=obj.Rowid.getValue();
        var bpcVACode=obj.bpcVACode.getValue();
        var bpcVADesc=obj.bpcVADesc.getValue();
        var ctloc=obj.ctlocdesc.getValue();
		var ret =_DHCBPCVascularAccess.UpdateVasAccess(Rowid,bpcVACode,bpcVADesc,ctloc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVACode.setValue("");
	  	  	obj.bpcVADesc.setValue("");
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
	  	var ret=_DHCBPCVascularAccess.DeleteVasAccess(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVACode.setValue("");
	  	  	obj.bpcVADesc.setValue("");
	  	  	obj.ctlocdesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}


