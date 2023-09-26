function InitViewScreenEvent(obj)
{
	var _DHCICUCViewSuperCat=ExtTool.StaticServerObject('web.DHCICUCViewSuperCat');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.icuCVSCCode.setValue(rc.get("tICUCVSCCode"));
	    obj.icuCVSCDesc.setValue(rc.get("tICUCVSCDesc"));
	    obj.Rowid.setValue(rc.get("tICUCVSCRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.icuCVSCCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","����벻��Ϊ��!");	
			return;
		}
		if(obj.icuCVSCDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","�����Ʋ���Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var icuCVSCCode=obj.icuCVSCCode.getValue();
		var icuCVSCDesc=obj.icuCVSCDesc.getValue();
		
        var repflag=_DHCICUCViewSuperCat.RepOperSuperCat(icuCVSCCode);
        if(repflag=="Y")
        {
		ExtTool.alert("��ʾ","��������ظ����޷����!");
		 return;
		}
        
		var ret=_DHCICUCViewSuperCat.InsertOperSuperCat(icuCVSCCode,icuCVSCDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.icuCVSCCode.setValue("");
	  	  	obj.icuCVSCDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("��ʾ","����ѡ��һ�м�¼!");	
			return;
		}
	  	if(obj.icuCVSCCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","����벻��Ϊ��!",function(){obj.icuCVSCCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.icuCVSCDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","�����Ʋ���Ϊ��!",function(){obj.icuCVSCDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var icuCVSCCode=obj.icuCVSCCode.getValue();
        var icuCVSCDesc=obj.icuCVSCDesc.getValue();
		var ret =_DHCICUCViewSuperCat.UpdateOperSuperCat(Rowid,icuCVSCCode,icuCVSCDesc);
		if(ret!='0')
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.icuCVSCCode.setValue("");
	  	  	obj.icuCVSCDesc.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  if(ID=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUCViewSuperCat.DeleteOperSuperCat(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.icuCVSCCode.setValue("");
	  	  	obj.icuCVSCDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}