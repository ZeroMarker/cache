function InitViewScreenEvent(obj)
{
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	    if (rc)
	    {
			SelectedRowID=rc.get("tcode");
			if(preRowID!=SelectedRowID)
			{
				obj.code.setValue(rc.get("tcode"));
				obj.name.setValue(rc.get("tname"));
				obj.filename.setValue(rc.get("tfilename"));
				obj.operStat.setRawValue(rc.get("toperStat"));
				obj.operStat.setValue(rc.get("tstatCode"));
				obj.retGridPanelListStore.load({}); 
				preRowID=SelectedRowID;
		    }
		    else
		    {
			    obj.code.setValue("");
				obj.name.setValue("");
				obj.filename.setValue("");
				obj.operStat.setRawValue("");
				obj.operStat.setValue("");
				obj.retGridPanelListStore.load({});
				SelectedRowID = 0;
				preRowID=0;
				obj.retGridPanel.getSelectionModel().deselectRow(linenum);
			}     
	    }
    }
    
    obj.addbutton_click=function()
    {
	    var code=obj.code.getValue();
	    var name=obj.name.getValue();
	    var filename=obj.filename.getValue();
	    var operStat=obj.operStat.getRawValue();
	    var statCode=obj.operStat.getValue();
	    if((code=="")||(name=="")||(filename==""))
	    {
		    Ext.Msg.alert("��ʾ","���룬���ƺ��ļ���������Ϊ��!");
		    return ;
		}
		var typeStr=name+"^"+filename+"^"+operStat+"^"+statCode;
		var ret=_UDHCANOPSET.TypeAdd(code,typeStr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
				obj.code.setValue("");
				obj.name.setValue("");
				obj.filename.setValue("");
				obj.operStat.setValue("");
				obj.operStat.setRawValue("");
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridPanelListStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
		}
	}
	
	obj.updatebutton_click=function()
	{
		var code=obj.code.getValue();
	    var name=obj.name.getValue();
	    var filename=obj.filename.getValue();
	    var operStat=obj.operStat.getRawValue();
	    var statCode=obj.operStat.getValue();
	    if((code=="")||(name=="")||(filename==""))
	    {
		    Ext.Msg.alert("��ʾ","���룬���ƺ��ļ���������Ϊ��!");
		    return ;
		}
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var oldcode=rc.get("tcode");
		if(oldcode==code)
		{
			Ext.Msg.alert("��ʾ","����δ�޸�!");
		}
		var typeStr=name+"^"+filename+"^"+operStat+"^"+statCode;
		var ret=_UDHCANOPSET.TypeUpdate(oldcode,code,typeStr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
				obj.code.setValue("");
				obj.name.setValue("");
				obj.filename.setValue("");
				obj.operStat.setValue("");
				obj.operStat.setRawValue("");
	  	  		obj.retGridPanelStore.load({});  
	  	  		obj.retGridPanelListStore.load({});	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");
		}
	}
	
	obj.deletebutton_click=function()
	{
		var code=obj.code.getValue("");
		if(code=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_UDHCANOPSET.TypeDel(code);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
	  	 	 Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
				obj.code.setValue("");
				obj.name.setValue("");
				obj.filename.setValue("");
				obj.operStat.setValue("");
				obj.operStat.setRawValue("");
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridPanelListStore.load({}); 
		  	});
	    });	
	}
	
	obj.retGridPanelList_rowclick=function()
	{
		
		var rc = obj.retGridPanelList.getSelectionModel().getSelected();   
		if (rc)
		{
		    obj.seqno.setValue(rc.get("tseqno"));
		    obj.columnName.setValue(rc.get("tname"));
		    obj.columnLink.setRawValue(rc.get("tColLink"));
		    obj.columnLink.setValue(rc.get("tColLinkID"));
		    obj.rw.setValue(rc.get("trw"));  
		}
	}
	
	obj.addbuttonList_click=function()
	{
		var code=obj.code.getValue();
		var seqno=obj.seqno.getValue();
		var columnName=obj.columnName.getValue();
		var columnLink=obj.columnLink.getRawValue();
		var columnLinkId=obj.columnLink.getValue();
		var rw=obj.rw.getValue();
		
		if((code=="")||(columnName=="")||(columnLink=="")||(columnLinkId=="")||(seqno==""))
		{
			Ext.Msg.alert("��ʾ","���룬�������й���������Ϊ��!");
		    return ;
		}
		var typeStr=columnName+"|"+columnLink+"|"+columnLinkId+"|"+seqno;
		var ret=_UDHCANOPSET.AddTitle(code,typeStr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
				obj.seqno.setValue("");
				obj.columnName.setValue("");
				obj.columnLink.setValue("");
				obj.columnLink.setRawValue("");
	  	  		obj.retGridPanelListStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
		}
	}
	
	obj.updatebuttonList_click=function()
	{
		var code=obj.code.getValue();
		var seqno=obj.seqno.getValue();
		var columnName=obj.columnName.getValue();
		var columnLink=obj.columnLink.getRawValue();
		var columnLinkId=obj.columnLink.getValue();
		var rw=obj.rw.getValue();
		
	    if((code=="")||(seqno=="")||(columnName=="")||(columnLink=="")||(columnLinkId=="")||(rw==""))
	    {
		    Ext.Msg.alert("��ʾ","���룬��ţ��������й�����rw������Ϊ��!");
		    return ;
		}
		var typeStr=columnName+"|"+columnLink+"|"+columnLinkId+"|"+seqno;
		
		var ret=_UDHCANOPSET.UpdateTitle(rw,typeStr,code);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
				obj.seqno.setValue("");
				obj.columnName.setValue("");
				obj.columnLink.setValue("");
				obj.columnLink.setRawValue("");
	  	  		obj.retGridPanelListStore.load({}); 
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");
		}
	}
	
	obj.deletebuttonList_click=function()
	{
		var code=obj.code.getValue("");
		var rw=obj.rw.getValue();
		if((code=="")||(rw==""))
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_UDHCANOPSET.DelTitle(code,rw);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
	  	 	 Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
				obj.seqno.setValue("");
				obj.columnName.setValue("");
				obj.columnLink.setValue("");
				obj.columnLink.setRawValue("");
	  	  		obj.retGridPanelListStore.load({});
		  	});
	    });	
	}
	
	
}