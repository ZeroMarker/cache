function InitViewScreenEvent(obj)
{ 
     var _DHCANCSiteProphyAntibiotics=ExtTool.StaticServerObject('web.DHCANCSiteProphyAntibiotics');
     var SelectedRowID = 0;
     var preRowID=0;

	obj.LoadEvent = function(args)
	{
	};
   obj.needArcimDesc_select=function()
	{
	  obj.needArcimDescStore.reload({});
	} 

	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	  	   SelectedRowID=rc.get("tRowID");
	       if(preRowID!=SelectedRowID)
	       { 	    
	        obj.RowId.setValue(rc.get("tRowID"));
	        obj.OecBodySiteDesc.setValue(rc.get("tSPABodySite"));
	        obj.OecBodySiteDesc.setRawValue(rc.get("tSPABodySite"));
		    obj.ISDisplay.setValue(rc.get("tSPAActive"));
		    obj.needArcimDesc.setValue(rc.get("tSPAArcimID"));
		    obj.needArcimDesc.setRawValue(rc.get("tSPAArcim"));
		    preRowID=SelectedRowID;
	      }
	       else
	      {
		    obj.OecBodySiteDesc.setValue("");
		    obj.ISDisplay.setValue("");
		    obj.needArcimDesc.setValue("");
		    SelectedRowID = 0;
		    preRowID=0;
		    
		 }
	  }
	  
	};	
	
	obj.selectbutton_click = function()
	{
		obj.retGridPanelStore.load({});
		obj.RowId.setValue("");
		obj.OecBodySiteDesc.setValue("");
		obj.ISDisplay.setValue("");
	    obj.needArcimDesc.setValue("");
	}
	
	obj.addbutton_click = function()
	{
	   var RowId=obj.RowId.getValue();
   	   if(obj.RowId.getValue()!="")
		{
			ExtTool.alert("��ʾ","������¼�¼��");	
			return;
		}
		if(obj.OecBodySiteDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���岿λ����Ϊ��!");	
			return;
		}
		if(obj.ISDisplay.getValue()=="")
		{
			ExtTool.alert("��ʾ","�Ƿ񼤻��Ϊ��!");	
			return;
		}
		if(obj.ISDisplay.getValue()!="Y"&&obj.ISDisplay.getValue()!="N")
		{
			ExtTool.alert("��ʾ","�Ƿ񼤻�������Y/N!");	
			return;
		}	
		if(obj.needArcimDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҽ������Ϊ��!");	
			return;
		}
		var OecBodySite=obj.OecBodySiteDesc.getValue();
		var ISDisplay=obj.ISDisplay.getValue();
		var needArcim=obj.needArcimDesc.getValue();
		var OecBodySiteDr=_DHCANCSiteProphyAntibiotics.GetOecBSD("","",OecBodySite);
	    var ret=_DHCANCSiteProphyAntibiotics.InsertCommonOrd(OecBodySiteDr,needArcim,ISDisplay);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.OecBodySiteDesc.setValue("");
	  	  	obj.ISDisplay.setValue("");
	  	  	obj.needArcimDesc.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	}
    obj.deletebutton_click = function()
	{
	   var RowId=obj.RowId.getValue();
   	   if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");	
			return;
		}
		 Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  var ret=_DHCANCSiteProphyAntibiotics.DeleteOrd(RowId);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.OecBodySiteDesc.setValue("");
	  	  	obj.ISDisplay.setValue("");
	  	  	obj.needArcimDesc.setValue("");		  
	  	  	obj.retGridPanelStore.load({});  
		  	});
	  	}
	  );			
	}
		
	obj.updatebutton_click = function()
	{
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼ID����Ϊ��!");	
			return;
		}		
		if(obj.OecBodySiteDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���岿λ����Ϊ��!");	
			return;
		}
		if(obj.ISDisplay.getValue()=="")
		{
			ExtTool.alert("��ʾ","�Ƿ񼤻��Ϊ��!");	
			return;
		}
		if(obj.ISDisplay.getValue()!="Y"&&obj.ISDisplay.getValue()!="N")
		{
			ExtTool.alert("��ʾ","�Ƿ񼤻�������Y/N!");	
			return;
		}	
		if(obj.needArcimDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҽ������Ϊ��!");	
			return;
		}
		var RowId=obj.RowId.getValue();
        var OecBodySite=obj.OecBodySiteDesc.getValue();
		var ISDisplay=obj.ISDisplay.getValue();
		var needArcim=obj.needArcimDesc.getValue();
		var OecBodySiteDr=_DHCANCSiteProphyAntibiotics.GetOecBSD("","",OecBodySite);
		var ret=_DHCANCSiteProphyAntibiotics.Update(RowId,OecBodySiteDr,needArcim,ISDisplay);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
			obj.RowId.setValue("");
			obj.OecBodySiteDesc.setValue("");
	  	  	obj.ISDisplay.setValue("");
	  	  	obj.needArcimDesc.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}					
	}
	
}