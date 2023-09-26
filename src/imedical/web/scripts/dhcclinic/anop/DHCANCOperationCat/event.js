function InitViewScreenEvent(obj)
{
	var _DHCANCOperationCat=ExtTool.StaticServerObject('web.DHCANCOperationCat');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.OperationCatCode.setValue(rc.get("ANCOCCode"));
	    obj.OperationCatName.setValue(rc.get("ANCOCDesc"));
	    obj.Rowid.setValue(rc.get("RowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.OperationCatCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","����벻��Ϊ��!");	
			return;
		}
		if(obj.OperationCatName.getValue()=="")
		{
			ExtTool.alert("��ʾ","�����Ʋ���Ϊ��!");	
			return;
		}
		var OperationCatCode=obj.OperationCatCode.getValue();
		var OperationCatName=obj.OperationCatName.getValue();

		var ret=_DHCANCOperationCat.InsertOperCat(OperationCatCode,OperationCatName);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.OperationCatCode.setValue("");
	  	  	obj.OperationCatName.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.Rowid.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ϵͳ�Ų���Ϊ��!",function(){obj.Rowid.focus(true,true);});
	  		return;
	  	} ;		
	  	if(obj.OperationCatCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","����벻��Ϊ��!",function(){obj.OperationCatCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.OperationCatName.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","�����Ʋ���Ϊ��!",function(){obj.OperationCatName.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var OperationCatCode=obj.OperationCatCode.getValue();
		var OperationCatName=obj.OperationCatName.getValue();
		var ret = _DHCANCOperationCat.UpdateOperCat(Rowid,OperationCatCode,OperationCatName);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.OperationCatCode.setValue("");
	  	  	obj.OperationCatName.setValue("");
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
	  	var ret=_DHCANCOperationCat.DeleteOperCat(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.OperationCatCode.setValue("");
	  	  	obj.OperationCatName.setValue("");
	  	  	obj.retGridPanelStore.load({});   	  	
	  	  	});

	  	}
	  );
	};
	
}

