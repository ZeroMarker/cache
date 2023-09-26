function InitViewScreenEvent(obj)
{
	var _DHCCLCScore=ExtTool.StaticServerObject('web.DHCCLCScore');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.mainclcs.setValue(rc.get("TCLCSLMainCLCSDr"));
	    obj.linkclcs.setValue(rc.get("TCLCSLLinkCLCSDr"));
	    obj.Rowid.setValue(rc.get("TRowid"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.mainclcs.getValue()=="")
		{
			ExtTool.alert("��ʾ","�����ֲ���Ϊ��!");	
			return;
		}
		if(obj.linkclcs.getValue()=="")
		{
			ExtTool.alert("��ʾ","�������ֲ���Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var mainclcs=obj.mainclcs.getValue();
		var linkclcs=obj.linkclcs.getValue();
		var sameFlag=_DHCCLCScore.CompareClCSLink(mainclcs,linkclcs,"")
		if(sameFlag==1)
		{
			alert("�����������ظ�");
			return;
		}
		var ret=_DHCCLCScore.InsertClCSLink(mainclcs,linkclcs);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.mainclcs.setValue("");
	  	  	obj.linkclcs.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.Rowid.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ID�Ų���Ϊ��!",function(){obj.floorno.focus(true,true);});
	  		return;
	  	} ;

	  	if(obj.mainclcs.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","�����ֲ���Ϊ��!",function(){obj.floorno.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.linkclcs.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","�������ֲ���Ϊ��!",function(){obj.floorname.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var mainclcs=obj.mainclcs.getValue();
        var linkclcs=obj.linkclcs.getValue();
        var sameFlag=_DHCCLCScore.CompareClCSLink(mainclcs,linkclcs,Rowid)
		if(sameFlag==1)
		{
			alert("�����������Ѵ���");
			return;
		}
		var ret = _DHCCLCScore.UpdateClCSLink(Rowid,mainclcs,linkclcs);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.mainclcs.setValue("");
	  	  	obj.linkclcs.setValue("");
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
	  	var ret=_DHCCLCScore.DeleteClCSLink(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.mainclcs.setValue("");
	  	  	obj.linkclcs.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

