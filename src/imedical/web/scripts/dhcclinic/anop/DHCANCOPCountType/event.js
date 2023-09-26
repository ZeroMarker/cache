function InitViewScreenEvent(obj)
{
    var _DHCANCOPCount = ExtTool.StaticServerObject('web.DHCANCOPCount');
	
	obj.LoadEvent=function(args)
	{
	
	};
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	    if (rc)
	    {
		    SelectedRowID=rc.get("TypeId");
		    if(preRowID!=SelectedRowID)
		    {
			    obj.Code.setValue(rc.get("TypeCode"));
			    obj.Desc.setValue(rc.get("TypeDesc"));
			    obj.TypeId.setValue(rc.get("TypeId"));
			    obj.dataretGridPanelStore.reload({});
			    obj.selectTypeStore.reload({});
			    preRowID=SelectedRowID;
			}
			else
			{
				obj.Code.setValue("");
			    obj.Desc.setValue("");
			    obj.TypeId.setValue("");
			    obj.dataretGridPanelStore.reload({});
			    obj.selectTypeStore.reload({});
			    SelectedRowID = 0;
			    preRowID=0;
			    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
			}
	    }
    }
	obj.dataretGridPanel_rowclick=function()
	{
	   var rc = obj.dataretGridPanel.getSelectionModel().getSelected();
	   if (rc)
	   {
	      // obj.dataretGridPanelStore.load({}); 
	   }
	}
	
	obj.addbutton_click = function()
	{
	    var Code=obj.Code.getValue();
		var Desc=obj.Desc.getValue();
		if((Code=="")||(Desc==""))
	    {
		    Ext.Msg.alert("提示","代码，名称都不能为空!");
		    return ;
		}
		var ret=_DHCANCOPCount.AddType(Code,Desc);
		
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
				obj.Code.setValue("");
				obj.Desc.setValue("");
	  	  		obj.retGridPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示",ret);
		}
	}
	obj.updatebutton_click = function()
	{
	    var Code=obj.Code.getValue();
		var Desc=obj.Desc.getValue();
		var TypeId=""
		var rc=obj.retGridPanel.getSelectionModel().getSelected();
		if(rc) 
		{
			TypeId = rc.get("TypeId");
		}
		if(TypeId=="")
		{
			alert("请选择一条记录");
			return;
		}
		if((Code=="")||(Desc==""))
	    {
		    Ext.Msg.alert("提示","代码，名称都不能为空!");
		    return ;
		}
		var ret=_DHCANCOPCount.UpdateType(TypeId,Code,Desc);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","修改成功!",function(){
				obj.Code.setValue("");
				obj.Desc.setValue("");
	  	  		obj.retGridPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示",ret);
		}
	}
	obj.deletebutton_click=function()
	{
		var TypeId = "";
	    var rc=obj.retGridPanel.getSelectionModel().getSelected();
	    if(rc)
	    {
			 TypeId = rc.get("TypeId");
	    }
		if(TypeId=="")
		{
			Ext.Msg.alert("提示","请选择一条要删除的记录!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCANCOPCount.DeleteType(TypeId);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		else
	  	 	 Ext.Msg.alert("提示","删除成功！",function(){
				obj.Code.setValue("");
				obj.Desc.setValue("");
	  	  		obj.retGridPanelStore.load({});   
		  	});
	    });	
	}
	//-----------增加清点器材------------------------------
	obj.addTypeButton_click = function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc)
	    {
		    code=rc.get("TypeCode")
		    //alert(code)
		    if (code=="")
			{
				Ext.Msg.alert("提示","请选择清点类型");
				return;
			}
		}
	    var rcs = obj.allTypeGrid.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len>0)
		{
		    for(var i=0;i<len;i++)
			{   
			    var ANCOPC_RowId=rcs[i].get("ANCOPC_RowId");
			    var ANCOPC_Desc=rcs[i].get("ANCOPC_Desc");
				if(IsAncopc(ANCOPC_RowId))
				{
				    continue;
				}
			var rec = new (obj.selectTypeStore.recordType)();
			rec.set('DefItemCode',ANCOPC_RowId);
			rec.set('DefItemDesc',ANCOPC_Desc);
			obj.selectTypeStore.add(rec);
			}
		}
		else
		{
			Ext.Msg.alert("提示","请选中一条清点项目");
		}
	}
	
	function IsAncopc(ANCOPC_RowId)
	{
	    for(var i=0;i<obj.selectTypeStore.getCount();i++)
		{
			var rw=obj.selectTypeStore.getAt(i).get("DefItemCode");
			if(rw==ANCOPC_RowId)
			{
				return true;
			}
		}
		return false;
	}
	
	obj.delTypeButton_click = function()
	{
	    var rcs = obj.selectTypeGrid.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len>0)
		{
		    for(var i=0;i<len;i++)
			{   
			    obj.selectTypeStore.remove(rcs[i]);
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在所选清点项中选择一项");
		}
	}
	
	obj.SaveButton_click=function()
	{
		var TypeId=""
	   var rc = obj.retGridPanel.getSelectionModel().getSelected();
	   if(rc)
	   {
	   		TypeId=rc.get("TypeId")
	   }
	   if(TypeId=="")
	   {
		   alert("请选择一条清点类型");
		   return;
	   }
	   var str="";
	   var temList=new Array();
	   for(var i=0;i<obj.selectTypeStore.getCount();i++)
		{
		    var DefItemCode=obj.selectTypeStore.getAt(i).get("DefItemCode");
		    temList[i]=DefItemCode;
		}
		str=temList.join("^");
		//alert(TypeId+str);
		var ret=_DHCANCOPCount.SaveTypeSel(TypeId,str);
		alert(ret);
	    obj.dataretGridPanelStore.load({}); 
		return;
	}
	obj.upButton_click=function()
	{
	    var rcs = obj.selectTypeGrid.getSelectionModel().getSelections();
	    if(rcs=="")
	    {
		    alert("请选择一条记录");
		    return;
	    }
		var index=obj.selectTypeStore.indexOf(rcs[0]);
		//alert(index);
	    var DefItemCode=obj.selectTypeStore.getAt(index).get("DefItemCode");
		var DefItemDesc=obj.selectTypeStore.getAt(index).get("DefItemDesc");
		var DefItemCode1=obj.selectTypeStore.getAt(index-1).get("DefItemCode");
		var DefItemDesc1=obj.selectTypeStore.getAt(index-1).get("DefItemDesc");
		obj.selectTypeStore.getAt(index).set("DefItemCode",DefItemCode1);
		obj.selectTypeStore.getAt(index-1).set("DefItemCode",DefItemCode);
		obj.selectTypeStore.getAt(index).set("DefItemDesc",DefItemDesc1);
		obj.selectTypeStore.getAt(index-1).set("DefItemDesc",DefItemDesc);		
	}
	obj.downButton_click=function()
	{
	   var rcs = obj.selectTypeGrid.getSelectionModel().getSelections();
	
	   if(rcs=="")
	   {
		   alert("请选择一条记录");
		   return;
	   }
		//var DefItemCode=rcs[0].get("DefItemCode");
		//var a = obj.selectTypeGrid.;
		var index=obj.selectTypeStore.indexOf(rcs[0]);
		//alert(index);
	    var DefItemCode=obj.selectTypeStore.getAt(index).get("DefItemCode");
		var DefItemDesc=obj.selectTypeStore.getAt(index).get("DefItemDesc");
		var DefItemCode1=obj.selectTypeStore.getAt(index+1).get("DefItemCode");
		var DefItemDesc1=obj.selectTypeStore.getAt(index+1).get("DefItemDesc");
		obj.selectTypeStore.getAt(index).set("DefItemCode",DefItemCode1);
		obj.selectTypeStore.getAt(index+1).set("DefItemCode",DefItemCode);
		obj.selectTypeStore.getAt(index).set("DefItemDesc",DefItemDesc1);
		obj.selectTypeStore.getAt(index+1).set("DefItemDesc",DefItemDesc);	
		obj.selectTypeGrid.getSelectionModel().selectRow(Index + 1);
		obj.selectTypeStore.load({});
	}
	obj.dataretGridPanel_keydown=function(field,e)
	{	
	if(e.getKey()==e.ENTER)
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var rm = obj.dataretGridPanel.getSelectionModel().getSelected();
		var OPCountId=rm.get("OPCountId");
		var SeqNo=rm.get("SeqNo");
		var PreOperNum=rm.get("PreOperNum");
		var para=OPCountId+"!"+PreOperNum;
	    var TypeId=rc.get("TypeId");
	   var ret=_DHCANCOPCount.SaveTypeSelDefVal(TypeId,SeqNo,para);
	   alert(ret);
	   obj.dataretGridPanelStore.load({}); 
	}
		//判断是否可以编辑
	obj.dataretGridPanel_beforeedit = function (ev) 
	{
	    if((ev.field!='PreOperNum'))
		{
		 	return false;
		}
	}
	obj.dataretGridPanel_validateedit=function(ev)
	{
	}
 obj.dataretGridPanel_afteredit=function(ev) //修改科室和台次
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var rm = obj.dataretGridPanel.getSelectionModel().getSelected();
		var OPCountId=rm.get("OPCountId");
		var SeqNo=rm.get("SeqNo");
		var PreOperNum=rm.get("PreOperNum");
		var para=OPCountId+"!"+PreOperNum;
	    var TypeId=rc.get("TypeId");
		if(ev.field=='PreOperNum')
		{
			   var ret=_DHCANCOPCount.SaveTypeSelDefVal(TypeId,SeqNo,para);
			   //alert(ret);
			   obj.dataretGridPanelStore.load({}); 

		 }
	}

}