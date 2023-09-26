function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	obj.icucvcCodeold=0;
	var _DHCICUCViewCat=ExtTool.StaticServerObject('web.DHCICUCViewCat');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("tRowId"));
	    //alert(rc.get("tIcucioiId"))
	    obj.icucvcCode.setValue(rc.get("tIcucvcCode"));
	    obj.icucvcEvent.setValue(rc.get("tIcucvcEvent"));
	    obj.icucvcDisplayByCat.setValue(rc.get("tIcucvcDisplayByCat"));
	    obj.icucvcDesc.setValue(rc.get("tIcucvcDesc"));
	    obj.icucvcOrder.setValue(rc.get("tIcucvcOrder"));
	    obj.icucvscDesc.setValue(rc.get("tIcucvscDesc"));
	    obj.icucvcVPSite.setValue(rc.get("tIcucvcVPSite"));
	    obj.icucvcTherapy.setValue(rc.get("tIcucvcTherapy"));
	    obj.icucvcSummaryType.setValue(rc.get("tIcucvcSummaryType"));
	    obj.icucvcVS.setValue(rc.get("tIcucvcVS"));
	    obj.icucvcLab.setValue(rc.get("tIcucvcLab"));
	    obj.icucvcOptions.setValue(rc.get("tIcucvcOptions"));
	    obj.icucvcCodeold=obj.icucvcCode.getValue();
	     ExtTool.AddComboItem(obj.icucvscDesc,rc.get("tIcucvscDesc"),rc.get("tIcucvscId"))
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.icucvcCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���ʹ��벻��Ϊ��!");	
			return;
		}
		if(obj.icucvcDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ�������Ʋ���Ϊ��!");	
			return;
		}
		if(obj.icucvscDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���಻��Ϊ��!");	
			return;
		}		
		//var RowId = obj.RowId.getValue();
		var icucvcCode=obj.icucvcCode.getValue();
		var repflag=_DHCICUCViewCat.RepICUCViewCat(icucvcCode);
        if(repflag=="Y")
        {
		ExtTool.alert("��ʾ","��������ظ����޷����!");
		 return;
		}
		   
		var icucvcDesc=obj.icucvcDesc.getValue();          
		var icucvcOrder=obj.icucvcOrder.getValue();        
		var icucvcVS=obj.icucvcVS.getValue();     
		var icucvcSummaryType=obj.icucvcSummaryType.getRawValue();       
		var icucvcEvent=obj.icucvcEvent.getValue();   
		var icucvcVPSite=obj.icucvcVPSite.getValue();      
		var icucvcTherapy=obj.icucvcTherapy.getValue();  
		var icucvcLab=obj.icucvcLab.getValue();
		var icucvscDesc=obj.icucvscDesc.getValue();
		var icucvcOptions=obj.icucvcOptions.getRawValue();
		var icucvcDisplayByCat=obj.icucvcDisplayByCat.getValue();
		      

		var ret=_DHCICUCViewCat.InsertICUCViewCat(icucvcCode,icucvcDesc,icucvcVS,icucvcOrder,icucvcEvent,icucvcVPSite,icucvscDesc,icucvcDisplayByCat,icucvcTherapy,icucvcLab,icucvcSummaryType,icucvcOptions);
		//alert(ret)
		if(ret!="0") 
		{ 
		     Ext.Msg.alert("��ʾ",ret);
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.icucvcCode.setValue("");
	  	  	obj.icucvcDesc.setValue("");
	  	  	obj.icucvcOrder.setValue("");
	  	  	obj.icucvcVS.setValue("");
	  	  	obj.icucvcSummaryType.setValue(""); 
	  	  	obj.icucvcEvent.setValue(""); 
	  	  	obj.icucvcVPSite.setValue("");
	  	  	obj.icucvcTherapy.setValue("");	
	  	  	obj.icucvcLab.setValue("");
	  	  	obj.icucvscDesc.setValue("");
	  	  	obj.icucvcOptions.setValue("");
	  	  	obj.icucvcOptions.setValue(""); 
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
		if(obj.icucvcCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���ʹ��벻��Ϊ��!");	
			return;
		}
		if(obj.icucvcDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ�������Ʋ���Ϊ��!");	
			return;
		}
		if(obj.icucvscDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���಻��Ϊ��!");	
			return;
		}
		
		var icucvcCode=obj.icucvcCode.getValue();	
		//alert(obj.icucvcCodeold+"/"+icucvcCode);
	if(obj.icucvcCodeold!=icucvcCode){
	
    var repflag=_DHCICUCViewCat.RepICUCViewCat(icucvcCode);
    if(repflag=="Y")
        {
		ExtTool.alert("��ʾ","��������ظ����޷����!");
		 return;
		}
	 }
	 
        var RowId = obj.RowId.getValue();
		var icucvcDesc=obj.icucvcDesc.getValue();          
		var icucvcOrder=obj.icucvcOrder.getValue();        
		var icucvcVS=obj.icucvcVS.getValue();     
		var icucvcSummaryType=obj.icucvcSummaryType.getRawValue();       
		var icucvcEvent=obj.icucvcEvent.getValue();   
		var icucvcVPSite=obj.icucvcVPSite.getValue();      
		var icucvcTherapy=obj.icucvcTherapy.getValue();  
		var icucvcLab=obj.icucvcLab.getValue();
		var icucvscDesc=obj.icucvscDesc.getValue();
		var icucvcOptions=obj.icucvcOptions.getRawValue();
		var icucvcDisplayByCat=obj.icucvcDisplayByCat.getValue();
		
		var ret=_DHCICUCViewCat.UpdateICUCViewCat(RowId,icucvcCode,icucvcDesc,icucvcVS,icucvcOrder,icucvcEvent,icucvcVPSite,icucvscDesc,icucvcDisplayByCat,icucvcTherapy,icucvcLab,icucvcSummaryType,icucvcOptions);
		//alert(ret)
		if(ret!="0")
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.icucvcCode.setValue("");
	  	  	obj.icucvcDesc.setValue("");
	  	  	obj.icucvcOrder.setValue("");
	  	  	obj.icucvcVS.setValue("");
	  	  	obj.icucvcSummaryType.setValue(""); 
	  	  	obj.icucvcEvent.setValue(""); 
	  	  	obj.icucvcVPSite.setValue("");
	  	  	obj.icucvcTherapy.setValue("");	
	  	  	obj.icucvcLab.setValue("");
	  	  	obj.icucvscDesc.setValue("");
	  	  	obj.icucvcOptions.setValue("");
	  	  	obj.icucvcOptions.setValue(""); 
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
	  	var ret=_DHCICUCViewCat.DeleteICUCViewCat(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.icucvcCode.setValue("");
	  	  	obj.icucvcDesc.setValue("");
	  	  	obj.icucvcOrder.setValue("");
	  	  	obj.icucvcVS.setValue("");
	  	  	obj.icucvcSummaryType.setValue(""); 
	  	  	obj.icucvcEvent.setValue(""); 
	  	  	obj.icucvcVPSite.setValue("");
	  	  	obj.icucvcTherapy.setValue("");	
	  	  	obj.icucvcLab.setValue("");
	  	  	obj.icucvscDesc.setValue("");
	  	  	obj.icucvcOptions.setValue("");
	  	  	obj.icucvcOptions.setValue("");  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStore.load({});
			obj.RowId.setValue("");
	  	  	obj.icucvcCode.setValue("");
	  	  	obj.icucvcDesc.setValue("");
	  	  	obj.icucvcOrder.setValue("");
	  	  	obj.icucvcVS.setValue("");
	  	  	obj.icucvcSummaryType.setValue(""); 
	  	  	obj.icucvcEvent.setValue(""); 
	  	  	obj.icucvcVPSite.setValue("");
	  	  	obj.icucvcTherapy.setValue("");	
	  	  	obj.icucvcLab.setValue("");
	  	  	obj.icucvscDesc.setValue("");
	  	  	obj.icucvcOptions.setValue("");
	  	  	obj.icucvcOptions.setValue("");  
		obj.intCurrRowIndex = -1;
	};
}