
function InitViewportCateItemEvent(obj)
{
	//加载类方法
	obj.ClsCateItem = ExtTool.StaticServerObject("DHCMed.NINF.Dic.CateItem");
	
	obj.LoadEvent = function(args)
    {
		obj.btnFind.on("click",obj.btnFind_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridItemDic.on("cellclick",obj.gridItemDic_cellclick,obj);
		obj.gridCateItem.on("cellclick",obj.gridCateItem_cellclick,obj);
		
    	obj.gridCateItemStore.load({params : {start : 0,limit : 50}});
		obj.gridItemDicStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.gridCateItem_cellclick = function(grid, rowIndex, columnIndex, e)
	{
		var objRec = grid.getStore().getAt(rowIndex);
		var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		if ((fieldName != 'ItemActive')&&(fieldName != 'IsChecked')) return;
		
		var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		
		if (fieldName == 'ItemActive') {
			var InputStr = objRec.get('ItemID');
			var InputStr = InputStr + '^'  + objRec.get('ItemCode');
			var InputStr = InputStr + '^'  + objRec.get('ItemDesc');
			var InputStr = InputStr + '^'  + objRec.get('ItemCateCode');
			var InputStr = InputStr + '^'  + newValue;
			var InputStr = InputStr + '^'  + objRec.get('ItemResume');
			var flg = obj.ClsCateItem.Update(InputStr,'^');
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","添加分类项目错误!");
				return;
			}
		}
		
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.gridItemDic_cellclick = function(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex !=0) return;
		var objRec = grid.getStore().getAt(rowIndex);
		
		var InputStr = '';
		var InputStr = InputStr + '^'  + objRec.get('DicID');
		var InputStr = InputStr + '^'  + objRec.get('DicDesc');
		var InputStr = InputStr + '^'  + obj.CateCode;
		var InputStr = InputStr + '^'  + '1';
		var InputStr = InputStr + '^'  + '';
		var flg = obj.ClsCateItem.Update(InputStr,'^');
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","分类项目添加错误!");
			return;
		} else {
			var RecordType = obj.gridCateItemStore.recordType;
			var RecordData = new RecordType({
				ItemID : flg
				,ItemCode : objRec.get('DicID')
				,ItemDesc : objRec.get('DicDesc')
				,ItemCateCode : obj.CateCode
				,ItemActive : '1'
				,ItemResume : ''
			});
			obj.gridCateItemStore.insert(obj.gridCateItemStore.getCount(), RecordData);
			obj.gridCateItem.getView().focusRow(obj.gridCateItemStore.getCount()-1);
			//删除行
			grid.getStore().remove(objRec);
		}
	}
	
	obj.btnFind_click = function()
	{
		obj.gridItemDicStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.btnDelete_click = function()
	{
		Ext.MessageBox.confirm('删除', '是否删除分类项目?', function(btn,text){
			if(btn=="yes"){
				var objStore = obj.gridCateItemStore;
				for (var indRec = 0; indRec < objStore.getCount(); indRec++)
				{
					var objRec = objStore.getAt(indRec);
					if (objRec.get('IsChecked') == '1')
					{
						var itemID = objRec.get('ItemID');
						var flg = obj.ClsCateItem.DeleteById(itemID);
						if (parseInt(flg) < 0) {
							ExtTool.alert("错误提示","删除分类项目错误!");
							return;
						}
					}
				}
				//加载当前页
				Common_LoadCurrPage('gridCateItem');
			}
		});
	}
}