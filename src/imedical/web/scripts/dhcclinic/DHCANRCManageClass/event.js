function InitViewScreenEvent(obj)
{
    var _DHCANRCManageClass=ExtTool.StaticServerObject('web.DHCANRCManageClass');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick=function()
	{
		var invNum=new Array();
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		  
	        obj.Code.setValue(rc.get("Code"));
	        obj.Desc.setValue(rc.get("Desc"));
	        obj.RowId.setValue(rc.get("RowId"));
			obj.CtlocDr.setValue(rc.get("CtlocDr"));
			var retstr=rc.get("AuditCarPrvTpDrStr");
			var strList=retstr.split("^")
			var strLen=strList.length;
			for (var i=0;i<strLen;i++)
			{				
				invNum[invNum.length]=strList[i]
			}
			obj.AuditCarPrvTp.setValue(invNum);
	  }
	}
	
	obj.addbutton_click=function()
	{		
	    if(obj.Code.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.Desc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ʋ���Ϊ��!");	
			return;
		}
		var Code=obj.Code.getValue();
		var Desc=obj.Desc.getValue();
		var CtlocDr=obj.CtlocDr.getValue();
		var AuditCarPrvTp=obj.AuditCarPrvTp.getValue();
		//alert(CtlocDr)
		var ret=_DHCANRCManageClass.InsertANRCManageClass(Code, Desc, CtlocDr,AuditCarPrvTp);
		//alert(ret);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.Code.setValue("");
	  	  	obj.Desc.setValue("");
	  	  	obj.CtlocDr.setValue("");
	  	  	obj.AuditCarPrvTp.setValue("");
	  	  	});
		}
		obj.store.reload({}); 
	}
	
	obj.updatebutton_click = function()
	{
	    if(obj.RowId.getValue()=="")
		{
		    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫ�޸ĵļ�¼��");
	        return;
		}
	  	if(obj.Code.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���벻��Ϊ��!",function(){obj.Code.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.Desc.getValue()=="")
	  	{
	  		Ext.Msg.alert("��ʾ","���Ʋ���Ϊ��!",function(){obj.Desc.focus(true,true);});
	  		return;
	  	};
	  	var RowId=obj.RowId.getValue();
        var Code=obj.Code.getValue();
		var Desc=obj.Desc.getValue();
		var CtlocDr=obj.CtlocDr.getValue();
		var AuditCarPrvTp=obj.AuditCarPrvTp.getValue();

		var ret=_DHCANRCManageClass.UpdateANRCManageClass(RowId,Code, Desc, CtlocDr,AuditCarPrvTp);
		if(ret!='0')
		{
		  Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","�޸ĳɹ���",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.Code.setValue("");
	  	  	obj.Desc.setValue("");
	  	  	obj.CtlocDr.setValue("");
	  	  	obj.AuditCarPrvTp.setValue("");
		  	});
	     }
	     obj.store.reload({}); 
	 };
	 
	 obj.deletebutton_click = function()
	{
	  var RowId=obj.RowId.getValue();
	  //alert(ID);
	  if(RowId=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANRCManageClass.DeleteANRCManageClass(RowId);
	  	//alert(ret);
	  	if(ret!='0')
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.Code.setValue("");
	  	  	obj.Desc.setValue("");
	  	  	obj.CtlocDr.setValue("");  	
	  	  	obj.AuditCarPrvTp.setValue("");
	  	  	});
			obj.store.reload({}); 
	  	}
	  );
	};



}