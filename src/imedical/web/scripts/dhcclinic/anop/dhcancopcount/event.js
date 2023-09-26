
function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var DHCANCOPCount=ExtTool.StaticServerObject('web.DHCANCOPCount');
	var SelectedRowID = 0;
	var preRowID=0;
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
		
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc){ 
	    SelectedRowID=rc.get("tOPCountId");
	    if(preRowID!=SelectedRowID)
	    {
		    obj.RowId.setValue(rc.get("tOPCountId"));
		    obj.ancOPCCode.setValue(rc.get("OPCountCode"));
		    obj.ancOPCDesc.setValue(rc.get("OPCountDesc"));
			//obj.ancOPCModelDr.setValue(rc.get("tOPCountTypeId"))
		    //obj.ancOPCModelDr.setValue(rc.get("tOPCountTypeId")+" || "+rc.get("tOPCountType"));
		    preRowID=SelectedRowID;
	    }
	    else
	    {
			obj.RowId.setValue("");
		    obj.ancOPCCode.setValue("");
		    obj.ancOPCDesc.setValue("");
		    //obj.ancOPCModelDr.setValue("");
		    SelectedRowID = 0;
		    preRowID=0;
			obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    
		}
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.ancOPCCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.ancOPCDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		//alert(obj.tOPCountTypeId.getValue());
		//if(obj.ancOPCModelDr.getValue()=="")
		//{
			//ExtTool.alert("��ʾ","����ͺŲ���Ϊ��!");	
			//return;
		//}		
		//var RowId = obj.RowId.getValue();
		var ancOPCCode=obj.ancOPCCode.getValue();           
		var ancOPCDesc=obj.ancOPCDesc.getValue();           
		//var ancOPCModelDr=obj.ancOPCModelDr.getValue();         

		var ret=DHCANCOPCount.AddMethod(ancOPCCode,ancOPCDesc);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue(""); 
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
		if(obj.ancOPCCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.ancOPCDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
			return;
		}
		//if(obj.ancOPCModelDr.getValue()=="")
		//{
			//ExtTool.alert("��ʾ","�豸�ͺŲ���Ϊ��!");	
			//return;
		//}
		var RowId = obj.RowId.getValue();
		var ancOPCCode=obj.ancOPCCode.getValue();           
		var ancOPCDesc=obj.ancOPCDesc.getValue();           
		//var ancOPCModelDr=obj.ancOPCModelDr.getValue();
		var ret=DHCANCOPCount.UpdateMethod(RowId,ancOPCCode,ancOPCDesc);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue("");	  
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
	  	var ret=DHCANCOPCount.DeleteMethod(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue("");		  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANCOPCount';
			param.QueryName = 'FindOPCount';
			param.Arg1=obj.ancOPCCode.getValue();
			param.Arg2=obj.ancOPCDesc.getValue();
			param.Arg3="" //obj.ancOPCModelDr.getValue();
			param.ArgCnt = 3;
		});
		obj.retGridPanelStore.load({});
			obj.RowId.setValue("");
	  	  	obj.ancOPCCode.setValue("");
	  	  	obj.ancOPCDesc.setValue("");
	  	  	//obj.ancOPCModelDr.setValue("");	 
		obj.intCurrRowIndex = -1;
	};
}