function InitViewScreenEvent(obj)
{
	var _DHCICUCProperty=ExtTool.StaticServerObject('web.DHCICUCProperty');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		obj.tICUCPRowID.setValue(rc.get("tICUCPRowID"));
	    obj.viewsupcode.setValue(rc.get("tICUCPCode"));
	    obj.viewsupname.setValue(rc.get("tICUCPDesc"));
	    //20160928+dyl
	    obj.viewsupvalue.setValue(rc.get("tICUCPDefaultValue"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.viewsupcode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.viewsupname.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ʋ���Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var viewsupcode=obj.viewsupcode.getValue();
		var viewsupname=obj.viewsupname.getValue();
		var viewsupvalue=obj.viewsupvalue.getValue();


		var ret=_DHCICUCProperty.InsertProperty(viewsupcode,viewsupname,viewsupvalue);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!"+ret);
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.viewsupvalue.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.tICUCPRowID.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","��ѡ��һ����¼!",function(){obj.Rowid.focus(true,true);});
	  		return;
	  	} ;		
	  	if(obj.viewsupcode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���벻��Ϊ��!",function(){obj.viewsupcode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.viewsupname.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���Ʋ���Ϊ��!",function(){obj.viewsupname.focus(true,true);});
	  		return;
	  	};
	  	var tICUCPRowID=obj.tICUCPRowID.getValue();
        var viewsupcode=obj.viewsupcode.getValue();
        var viewsupname=obj.viewsupname.getValue();
        var viewsupvalue=obj.viewsupvalue.getValue();
		var ret = _DHCICUCProperty.UpdateProperty(tICUCPRowID,viewsupcode,viewsupname,viewsupvalue);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.tICUCPRowID.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.viewsupvalue.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	
	obj.deletebutton_click = function()
	{
	  var ID=obj.tICUCPRowID.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUCProperty.DeleteProperty(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.tICUCPRowID.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.viewsupvalue.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

