function InitViewScreenEvent(obj)
{
    var _DHCANRCRiskAssess=ExtTool.StaticServerObject('web.DHCANRCRiskAssess');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick=function()
	{
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		  
	        obj.OperDiffculty.setValue(rc.get("OperDiffcultyDr"));
	        obj.ASA.setValue(rc.get("ASADr"));
	        obj.RowId.setValue(rc.get("RowId"));
			obj.Ctloc.setValue(rc.get("CtlocDr"));
			obj.Anrcrc.setValue(rc.get("AnrcrcDr"));
	  }
	}
	
	obj.addbutton_click=function()
	{
		ExtTool.alert("123","add");
	    if(obj.OperDiffculty.getValue()=="")
		{
			ExtTool.alert("��ʾ","�����Ѷȷ��಻��Ϊ��!");	
			return;
		}
		if(obj.ASA.getValue()=="")
		{
			ExtTool.alert("��ʾ","ASA�ּ�����Ϊ��!");	
			return;
		}
		if(obj.Anrcrc.getValue()=="")
		{
			ExtTool.alert("��ʾ","�������ռ�����Ϊ��!");	
			return;
		}
		if(obj.Ctloc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ҳ���Ϊ��!");	
			return;
		}
		
		var OperDiffculty=obj.OperDiffculty.getValue();
		var ASA=obj.ASA.getValue();
		var Anrcrc=obj.Anrcrc.getValue();
		var Ctloc=obj.Ctloc.getValue();
		//alert(OperDiffculty+"--"+ASA+"--"+Anrcrc+"--"+Ctloc)
		var ret=_DHCANRCRiskAssess.InsertANRCRiskAssess(OperDiffculty, ASA,Anrcrc,Ctloc);
		//alert(ret);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.OperDiffculty.setValue("");
	  	  	obj.ASA.setValue("");
	  	  	obj.Anrcrc.setValue("");
			obj.Ctloc.setValue("");
			obj.store.load(); 
	  	  	});
		}
	}
	
	obj.updatebutton_click = function()
	{
	    if(obj.RowId.getValue()=="")
		{
		    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	        return;
		}
		if(obj.OperDiffculty.getValue()=="")
		{
			ExtTool.alert("��ʾ","�����Ѷȷ��಻��Ϊ��!",function(){obj.Code.focus(true,true);});	
			return;
		}
		if(obj.ASA.getValue()=="")
		{
			ExtTool.alert("��ʾ","ASA�ּ�����Ϊ��!",function(){obj.Code.focus(true,true);});	
			return;
		}
		if(obj.Anrcrc.getValue()=="")
		{
			ExtTool.alert("��ʾ","�������ռ�����Ϊ��!",function(){obj.Code.focus(true,true);});	
			return;
		}
		if(obj.Ctloc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ҳ���Ϊ��!",function(){obj.Code.focus(true,true);});	
			return;
		}
	  	var RowId=obj.RowId.getValue();
        var OperDiffculty=obj.OperDiffculty.getValue();
		var ASA=obj.ASA.getValue();
		var Anrcrc=obj.Anrcrc.getValue();
		var Ctloc=obj.Ctloc.getValue();

		var ret=_DHCANRCRiskAssess.UpdateANRCRiskAssess(RowId,OperDiffculty, ASA,Anrcrc,Ctloc);
		if(ret!='0')
		{
		  Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","�޸ĳɹ���",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.OperDiffculty.setValue("");
	  	  	obj.ASA.setValue("");
	  	  	obj.Anrcrc.setValue("");
			obj.Ctloc.setValue("");
			obj.store.load(); 
			
		  	});
	     }
	 };
	 
	 obj.deletebutton_click = function()
	{
	  var RowId=obj.RowId.getValue();
	  if(RowId=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANRCRiskAssess.DeleteANRCRiskAssess(RowId);
	  	//alert(ret);
	  	if(ret!='0')
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.OperDiffculty.setValue("");
	  	  	obj.ASA.setValue("");
	  	  	obj.Anrcrc.setValue("");
			obj.Ctloc.setValue("");
			obj.store.load(); 
	  	  	});

	  	}
	  );
	};
}