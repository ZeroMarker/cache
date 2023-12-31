function InitViewScreenEvent(obj)
{
	var _DHCANOPReport=ExtTool.StaticServerObject('web.DHCANOPReport');
     obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {  
			var code=selectObj.get('tcode');
			obj.code.setValue(code);
			var name=selectObj.get('tname');
			obj.name.setValue(name);
			/*var operstat=selectObj.get('toperstat');
			obj.operstat.setRawValue(operstat);*/
			var orderType=selectObj.get('torderType');
			obj.orderType.setRawValue(orderType);
			var orderTypeID=selectObj.get('torderTypeID');
			obj.orderTypeID.setValue(orderTypeID);
			var tstatCode=selectObj.get('tstatCode');
			obj.operstat.setValue(tstatCode);
			
			
		}
		      
	        obj.retGridPanelStore.load({});
			obj.retGridPanelListStore.load({});      
	    }
     obj.retGridPanelList_rowclick=function() //点击后获取数据
	{
		{
		var selectObj = obj.retGridPanelList.getSelectionModel().getSelected();
		if (selectObj)
	    {  
			var seqno=selectObj.get('tseqno');
			obj.seqno.setValue(seqno);
			var name=selectObj.get('tname');
			obj.columnName.setValue(name);
			var ColLink=selectObj.get('tColLink');
			obj.columnLink.setRawValue(ColLink);
			var ColLinkId=selectObj.get('tColLinkID');
			obj.columnLink.setValue(ColLinkId);
			var schtype=selectObj.get('tschtype');
			obj.checkType.setRawValue(schtype);
			var schtypeId=selectObj.get('tschtypeId');
			obj.checkType.setValue(schtypeId);
			var returnType=selectObj.get('treturntype');
			obj.returnType.setRawValue(returnType);
			var returnTypeid=selectObj.get('treturntypeId');
			obj.returnType.setValue(returnTypeid);
			
		}
	}
	obj.retGridPanelListStore.load({});      
	    }
	 obj.addbutton_click=function()
	 {
		 var code=obj.code.getValue();
		 var name=obj.name.getValue();
		 //var orderTypeID=obj.orderTypeID.getValue();
		 var orderType=obj.orderType.getRawValue();
		 var orderTypeID=obj.orderType.getValue();
		 var operstat=obj.operstat.getRawValue();
		 var statCode=obj.operstat.getValue();
		 
		 if((code=="")||(name=="")||(orderType==""))
	    {
		    Ext.Msg.alert("提示","代码，名称和统计类型都不能为空!");
		    return ;
		}
		var typeStr=name+"^"+operstat+"^"+statCode+"^"+orderType;
		var ret=_DHCANOPReport.TypeAdd(code,orderTypeID,typeStr); 
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
				obj.code.setValue("");
				obj.name.setValue("");  
				obj.orderType.setRawValue("");
				obj.operstat.setRawValue("");
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridPanelListStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","增加失败！");
		}
	}
	
	
	obj.updatebutton_click=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var oldcode=rc.get("tcode");
		var code=obj.code.getValue();
	    var name=obj.name.getValue();
	    var orderType=obj.orderType.getRawValue();
	    var reorderTypeID=obj.orderType.getValue();
	    var statCode=obj.operstat.getValue();
	    var operStat=obj.operstat.getRawValue();
	    if((code=="")||(name=="")||(orderType==""))
	    {
		    Ext.Msg.alert("提示","代码，名称统计类型都不能为空!");
		    return ;
		}
		
		if(oldcode!=code)
		{
			Ext.Msg.alert("提示","代码未修改!");
		}
		var orderTypeID=rc.get('torderTypeID');
		var typeStr=name+"^"+operStat+"^"+statCode+"^"+orderType;
		var ret=_DHCANOPReport.TypeUpdate(oldcode,code,reorderTypeID,orderTypeID,typeStr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","修改成功!",function(){
				obj.code.setValue("");
				obj.name.setValue("");  
				obj.orderType.setRawValue("");
				obj.operstat.setRawValue("");
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});  
	  	  		obj.retGridPanelListStore.load({});	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","修改失败！");
		}
	}
	
	obj.deletebutton_click=function()
	{
		var code=obj.code.getValue("");
		var orderTypeID=obj.orderTypeID.getValue("");
		if(code=="")
		{
			Ext.Msg.alert("提示","请选择一条要删除的记录!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCANOPReport.TypeDel(orderTypeID,code);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		else
	  	 	 Ext.Msg.alert("提示","删除成功！",function(){
				obj.code.setValue("");
				obj.name.setValue("");  
				obj.orderType.setRawValue("");
				obj.operstat.setRawValue("");
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridPanelListStore.load({}); 
		  	});
	    });	 
	}
	
	
	obj.addbuttonList_click=function()
	{
		var code=obj.code.getValue();
		var seqno=obj.seqno.getValue();
		var columnName=obj.columnName.getValue();
		var columnLink=obj.columnLink.getRawValue();
		var columnLinkId=obj.columnLink.getValue();
		var orderTypeID=obj.orderTypeID.getValue();
		var checkType=obj.checkType.getRawValue();
		var checkTypeID=obj.checkType.getValue();
		var returnTypeID=obj.returnType.getValue();
		var returnType=obj.returnType.getRawValue();
		
		if((code=="")||(columnName=="")||(columnLink=="")||(columnLinkId=="")||(seqno==""))
		{
			Ext.Msg.alert("提示","代码，列名，列关联都不能为空!");
		    return ;
		}
		var typeStr=columnName+"^"+columnLink+"^"+seqno+"^"+returnTypeID+"^"+checkType+"^"+returnType;
		var ret=_DHCANOPReport.AddTitle(code,orderTypeID,columnLinkId,checkTypeID,typeStr);
		
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
				obj.seqno.setValue("");
				obj.columnName.setValue("");
				obj.columnLink.setValue("");
				obj.columnLink.setRawValue("");
				obj.returnType.setRawValue("");
				obj.checkType.setRawValue("");
				//obj.retGridPanelListStore.removeAll();
	  	  		obj.retGridPanelListStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","增加失败！");
		}
	}
	
	
	
	obj.updatebuttonList_click=function()
	{
		
		var code=obj.code.getValue();
		var seqno=obj.seqno.getValue();
		var columnName=obj.columnName.getValue();
		var columnLink=obj.columnLink.getRawValue();
		var repcolumnLinkId=obj.columnLink.getValue();
		var orderTypeID=obj.orderTypeID.getValue();
		var checkType=obj.checkType.getRawValue();
		var repcheckTypeID=obj.checkType.getValue();
		var returnTypeID=obj.returnType.getValue();
		var returnType=obj.returnType.getRawValue();
		//var rw=obj.rw.getValue();
		
	    if((code=="")||(seqno=="")||(columnName=="")||(columnLink==""))
	    {
		    Ext.Msg.alert("提示","代码，序号，列名和列关联都不能为空!");
		    return ;
		}
		var rc = obj.retGridPanelList.getSelectionModel().getSelected();
		var columnLinkId=rc.get("tcolumnLinkID");
		var checkTypeID=rc.get("tschtypeId");
		var typeStr=columnName+"^"+columnLink+"^"+seqno+"^"+returnTypeID+"^"+checkType+"^"+returnType;
		
		var ret=_DHCANOPReport.UpdateTitle(code,orderTypeID,repcolumnLinkId,repcheckTypeID,columnLinkId,checkTypeID,typeStr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","修改成功!",function(){
				obj.seqno.setValue("");
				obj.columnName.setValue("");
				obj.columnLink.setValue("");
				obj.columnLink.setRawValue("");
				obj.returnType.setRawValue("");
				obj.checkType.setRawValue("");
				//obj.retGridPanelListStore.removeAll();
	  	  		obj.retGridPanelListStore.load({}); 
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","修改失败！");
		}
	}
	
	
	
	
	obj.deletebuttonList_click=function()
	{
		var code=obj.code.getValue("");
		var seqno=obj.seqno.getValue("");
		var orderTypeID=obj.orderTypeID.getValue("");
		var checkType=obj.checkType.getRawValue("");
		var checkTypeID=obj.checkType.getValue("");
		var columnLink=obj.columnLink.getRawValue("");
		var columnLinkId=obj.columnLink.getValue("");
		
		if((code=="")||(seqno==""))
		{
			Ext.Msg.alert("提示","请选择一条要删除的记录!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCANOPReport.DelTitle(orderTypeID,code,checkTypeID,columnLinkId);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		else
	  	 	 Ext.Msg.alert("提示","删除成功！",function(){
				obj.seqno.setValue("");
				obj.columnName.setValue("");
				obj.orderType.setValue("");
				obj.checkType.setValue("");
				obj.columnLink.setValue("");
				obj.columnLink.setRawValue("");
				obj.returnType.setValue("");
				obj.returnType.setRawValue("");
	  	  		obj.retGridPanelListStore.load({});
		  	});
	    });	
	}
	
	
}