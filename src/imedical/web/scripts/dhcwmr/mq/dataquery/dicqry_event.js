function InitDicQryEvent(obj) 
{
	obj.LoadEvent = function(args){
		obj.txtAlias.on('specialkey',obj.txtAlias_specialkey,obj);
		obj.gridItemDic.on('rowdblclick',obj.gridItemDic_rowdblclick,obj);
		if (obj.IsLoadAll==1) Common_LoadCurrPage('gridItemDic',1);
	}

	obj.txtAlias_specialkey = function(field,e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_LoadCurrPage('gridItemDic',1);
	}

	obj.gridItemDic_rowdblclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.gridItemDicStore.getAt(rowIndex);
		var CompValue = objRec.get(obj.ChooseValue);
		obj.WinDicQry.close();
		Common_SetValue('txtCompValue',CompValue);
	}
}