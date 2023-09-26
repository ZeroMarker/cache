function InitViewportEvent(obj)
{	
	var CHR_1 = String.fromCharCode(1);
	var CHR_2 = String.fromCharCode(2);
	var objType = ExtTool.StaticServerObject("DHCMed.NINF.Aim.HandLiquidType");
	obj.LoadEvent = function(args)
	{
	}
	obj.BtnSave_click = function()
	{
		var TotalStr="";
		for(var i = 0; i < obj.LocConListStore.getCount(); i ++)  //遍历对照列表
    	{
    		var objData = obj.LocConListStore.getAt(i);
    		var NorLocID=objData.get('NormalLoc').trim();
    		var intReg=/^[1-9]\d*$/;
   			
   			if((!intReg.exec(NorLocID))&&(NorLocID!=""))
   			{
    			var index = obj.NormalLocStore.find('Code',NorLocID);	
					if(index!=-1) NorLocID=obj.NormalLocStore.getAt(index).data.Code;		// 处理已保存对照科室
				}
    		if(intReg.exec(NorLocID))
    			{
    				var rowid=objData.get('rowid');					// 对照表rowid
    				if(rowid!="")
    				{
    					var str=rowid
    					str=str+"^"+objData.get('HandLiquidCode');
    					str=str+"^"+objData.get('HLName');
    					str=str+"^"+objData.get('HlVolume');
    					str=str+"^"+objData.get('HlUnit');
    					str=str+"^"+NorLocID;
    					var ret=objType.Update(str);
    				}
    			}
    	}
			obj.LocConListStore.load({});
	}
}
