function InitViewScreenEvent(obj)
{
	var DHCANCOPLevel=ExtTool.StaticServerObject('web.DHCANCOPLevel');
	obj.LoadEvent = function(args) 
	{
		obj.Rowid.setValue("");
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
		    obj.anCOPLCode.setValue(rc.get("ANCOPL_Code"));
		    obj.anCOPLDesc.setValue(rc.get("ANCOPL_Desc"));
		    obj.Rowid.setValue(rc.get("RowId"));
		    preRowID=SelectedRowID;
	    }
	    else
	    {
		    obj.anCOPLCode.setValue("");
		    obj.anCOPLDesc.setValue("");
		    obj.Rowid.setValue("");
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    SelectedRowID = 0;
		    preRowID=0;
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		}
	  }
	};
	
	obj.addbutton_click = function()
	{
		
		//alert(obj.floorno.getValue());
		if(obj.anCOPLCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","������ģ���벻��Ϊ��!");	
			return;
		}
		if(obj.anCOPLDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","������ģ��������Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var anCOPLCode=obj.anCOPLCode.getValue();
		var anCOPLDesc=obj.anCOPLDesc.getValue();

		var ret=DHCANCOPLevel.InsertANCOPLevel(anCOPLCode,anCOPLDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","����ɹ�!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.anCOPLCode.setValue("");
	  	  	obj.anCOPLDesc.setValue("");
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
	  	if(obj.anCOPLCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ���벻��Ϊ��!",function(){obj.anCOPLCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.anCOPLDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","ģʽ��������Ϊ��!",function(){obj.anCOPLDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var anCOPLCode=obj.anCOPLCode.getValue();
        var anCOPLDesc=obj.anCOPLDesc.getValue();
		var ret =DHCANCOPLevel.UpdateANCOPLevel(Rowid,anCOPLCode,anCOPLDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.anCOPLCode.setValue("");
	  	  	obj.anCOPLDesc.setValue("");
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
	  	var ret=DHCANCOPLevel.DeleteANCOPLevel(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.anCOPLCode.setValue("");
	  	  	obj.anCOPLDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

