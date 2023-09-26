function InitViewScreenEvent(obj)
{
	var _DHCANCInstrument=ExtTool.StaticServerObject('web.DHCANCInstrument');
	obj.LoadEvent = function(args)
	{
	};
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		  SelectedRowID=rc.get("RowId");
		  if(preRowID!=SelectedRowID)
		  {
			  obj.ancInstrCode.setValue(rc.get("ANCINSTR_Code"));
			  obj.ancInstrDesc.setValue(rc.get("ANCINSTR_Desc"));
			  obj.Rowid.setValue(rc.get("RowId"));
			  preRowID=SelectedRowID;
		  }
		  else
		  {
			  obj.ancInstrCode.setValue("");
			  obj.ancInstrDesc.setValue("");
			  SelectedRowID = 0;
			  preRowID=0;
			  obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		  }
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.ancInstrCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","��е���벻��Ϊ��!");	
			return;
		}
		if(obj.ancInstrDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��е���Ʋ���Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var ancInstrCode=obj.ancInstrCode.getValue();
		var ancInstrDesc=obj.ancInstrDesc.getValue();

		var ret=_DHCANCInstrument.InsertOperInstrument(ancInstrCode,ancInstrDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ancInstrCode.setValue("");
	  	  	obj.ancInstrDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.ancInstrCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","��е���벻��Ϊ��!",function(){obj.ancInstrCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.ancInstrDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","��е���Ʋ���Ϊ��!",function(){obj.ancInstrDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var ancInstrCode=obj.ancInstrCode.getValue();
        var ancInstrDesc=obj.ancInstrDesc.getValue();
		var ret =_DHCANCInstrument.UpdateOperInstrument(Rowid,ancInstrCode,ancInstrDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ancInstrCode.setValue("");
	  	  	obj.ancInstrDesc.setValue("");
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
	  	var ret=_DHCANCInstrument.DeleteOperInstrument(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ancInstrCode.setValue("");
	  	  	obj.ancInstrDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}