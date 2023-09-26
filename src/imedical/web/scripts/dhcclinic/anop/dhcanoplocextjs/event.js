function InitViewScreenEvent(obj)
{
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	
	
	//麻醉科室中添加科室
	obj.addAnlocButton_click=function()
	{
		var rcs = obj.CTLocGrid.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				var ctlocid=rcs[i].get("ctlocid");
				var ctloc=rcs[i].get("ctloc");
				if(IsCTLocInAnLoc(ctlocid))
				{
					continue;
				}
				var rec = new (obj.AnLocListViewStore.recordType)();
				rec.set('rw',ctlocid);
				rec.set('desc',ctloc);
				obj.AnLocListViewStore.add(rec);
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在科室中选择一行");
		}
	}
	
	//麻醉科室中删除科室
	obj.delAnlocButton_click=function()
	{
		var rcs = obj.AnLocGrid.getSelectionModel().getSelections();
		var len=rcs.length;
		
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				obj.AnLocListViewStore.remove(rcs[i]);
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在麻醉科室中选择一行");
		}
	}
	
	//判断在科室中选择的行是否在麻醉科室中已存在
	function IsCTLocInAnLoc(ctlocid)
	{
		for(var i=0;i<obj.AnLocListViewStore.getCount();i++)
		{
			var rw=obj.AnLocListViewStore.getAt(i).get("rw");
			if(rw==ctlocid)
			{
				return true;
			}
		}
		return false;
	}
	
	
	//手术科室中添加科室
	obj.addOplocButton_click=function()
	{
		var rcs = obj.CTLocGrid.getSelectionModel().getSelections();
		var len = rcs.length;
		
		if( len > 0)
		{
			for(var i=0;i<len;i++)
			{
				var ctlocid=rcs[i].get("ctlocid");
				var ctloc=rcs[i].get("ctloc");
				if(IsCTLocInOpLoc(ctlocid))
				{
					continue;
				}	
				var rec = new (obj.OpLocListViewStore.recordType)();
				rec.set('rw',ctlocid);
				rec.set('desc',ctloc);
				obj.OpLocListViewStore.add(rec);
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在科室中选择一行");
		}
	}
	//判断在科室中选择的行是否在手术科室中已存在
	function IsCTLocInOpLoc(ctlocid)
	{
		for(var i=0;i<obj.OpLocListViewStore.getCount();i++)
		{
			var rw=obj.OpLocListViewStore.getAt(i).get("rw");
			if(ctlocid==rw)
			{
				return true;
			}
		}
		return false;
	}
	
	//手术科室中删除科室
	obj.delOplocButton_click=function()
	{
		var rcs = obj.OpLocGrid.getSelectionModel().getSelections();
		var len=rcs.length;
		
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				obj.OpLocListViewStore.remove(rcs[i]);
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在手术科室中选择一行");
		}
	}
	
	//单击保存按钮时
	obj.SaveSetButton_click=function()
	{
		var AnLocStr="";
		var OpLocStr="";
		
		AnLocStr=getLocStr(obj.AnLocListViewStore);
		OpLocStr=getLocStr(obj.OpLocListViewStore);
		
		var AnOpLoc=AnLocStr+"!"+OpLocStr;
		var ret=_UDHCANOPSET.SaveAnOpSet(AnOpLoc);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存成功！");
			obj.CTLocListViewStore.load({});
			obj.AnLocListViewStore.load({});
			obj.OpLocListViewStore.load({});
		}
		else
		{
			Ext.Msg.alert("提示","保存失败！");
		}
	}
	
	function getLocStr(store)
	{
		var LocStr="";
		var temList=new Array();
		for(var i=0;i<store.getCount();i++)
		{
			var rw=store.getAt(i).get("rw");
			var desc=store.getAt(i).get("desc");
			temList[i]=rw+"|"+desc;
		}
		LocStr=temList.join("^");
		return LocStr;
	}
	
	/*obj.CTLocGrid_keydown=function(e)
	{
		//获取按键的ASCII码
		var charCode=e.getCharCode();
		
		var c=String.fromCharCode(charCode).toUpperCase();
		var rcs=obj.CTLocGrid.find("ctloc","SMK-手麻科");
		alert(rcs.length);
	}*/
}