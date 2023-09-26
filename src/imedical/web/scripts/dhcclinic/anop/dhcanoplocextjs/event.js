function InitViewScreenEvent(obj)
{
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	
	
	//�����������ӿ���
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
			Ext.Msg.alert("��ʾ","�������ڿ�����ѡ��һ��");
		}
	}
	
	//���������ɾ������
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
			Ext.Msg.alert("��ʾ","�����������������ѡ��һ��");
		}
	}
	
	//�ж��ڿ�����ѡ������Ƿ�������������Ѵ���
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
	
	
	//������������ӿ���
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
			Ext.Msg.alert("��ʾ","�������ڿ�����ѡ��һ��");
		}
	}
	//�ж��ڿ�����ѡ������Ƿ��������������Ѵ���
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
	
	//����������ɾ������
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
			Ext.Msg.alert("��ʾ","������������������ѡ��һ��");
		}
	}
	
	//�������水ťʱ
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
			Ext.Msg.alert("��ʾ","����ɹ���");
			obj.CTLocListViewStore.load({});
			obj.AnLocListViewStore.load({});
			obj.OpLocListViewStore.load({});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
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
		//��ȡ������ASCII��
		var charCode=e.getCharCode();
		
		var c=String.fromCharCode(charCode).toUpperCase();
		var rcs=obj.CTLocGrid.find("ctloc","SMK-�����");
		alert(rcs.length);
	}*/
}