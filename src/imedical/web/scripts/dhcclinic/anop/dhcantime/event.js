function InitViewScreenEvent(obj)
{ 

    var _DHCANRecord=ExtTool.StaticServerObject('web.DHCANRecord');
	var selectObj=window.dialogArguments;
    obj.LoadEvent = function(args)
	{
	    var opaId=selectObj.get('opaId');
	    var retstr=_DHCANRecord.getTime(opaId);
		var appList=retstr.split("^")
		var proAnTime=appList[0]
		var leaveTime=appList[1]
		var toICUTime=appList[2]
		var toWarTime=appList[3]
		obj.proAnTime.setRawValue(proAnTime);
	    obj.leaveTime.setRawValue(leaveTime);
	    obj.toICUTime.setRawValue(toICUTime);
	    obj.toWarTime.setRawValue(toWarTime);
	}
	obj.toICUTime_blur=function()
	{
	    if(obj.toICUTime.getValue!="")
	{
	   obj.toWarTime.setValue("");
	   obj.toWarTime.disable();
	}
	}
	obj.toWarTime_blur=function()
	{
	    if(obj.toWarTime.getValue!="")
	{
	   obj.toICUTime.setValue("");
	   obj.toICUTime.disable();
	}
	}
	obj.updatebutton_click=function()
	{
	    var opaId=selectObj.get('opaId');
		var proAnTime=obj.proAnTime.getRawValue();
		var leaveTime=obj.leaveTime.getRawValue();
		var toICUTime=obj.toICUTime.getRawValue();
		var toWarTime=obj.toWarTime.getRawValue();
		if(proAnTime=="")
		{
		    alert("Ԥ������ʱ��Ϊ��");
			return;
		}
		if(leaveTime=="")
		{
		    alert("�뿪����ʱ��Ϊ��")
			return;
		}
		var ret=_DHCANRecord.UpdateTime(opaId,proAnTime,leaveTime,toICUTime,toWarTime);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){ 
	  	  	});
			window.close();	
		}
	}
	obj.closebutton_click=function()
	 {
	   window.close();
	 }
}