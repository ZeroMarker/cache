function InitGridRowMoveMenu(obj)
{
	obj.menuItemRowMoveUp = new Ext.menu.Item({
		id : 'btnRowMoveUp'
		,iconCls : 'icon-arrow_up'
		,text : '上移'
	});
	obj.menuItemRowMoveDown = new Ext.menu.Item({
		id : 'btnRowMoveDown'
		,iconCls : 'icon-arrow_down'
		,text : '下移'
	})
	obj.menuItemRowMoveTo = new Ext.menu.Item({
		id : 'btnRowMoveTo'
		,iconCls : 'icon-arrow_switch'
		,text : '移动至<input type=\"text\" id=\"rowno_moveto\" style=\"font-size:13px;width:30px;height:20px;color:red;\"/>'
	})
	
	obj.resultContextMenu = new Ext.menu.Menu({
        id:'resultContextMenu',
        items:[
			obj.menuItemRowMoveUp
			,obj.menuItemRowMoveDown
			,obj.menuItemRowMoveTo
		]
	});

	obj.menuItemRowMoveUp_click = function()
	{
		var direction=-1;
		var rowSelectObjs=obj.retGridPanel.getSelectionModel().getSelections();
		if(rowSelectObjs)
		{
			moveToRowNum=Number(rowSelectObjs[0].data.rowId)-1;
			MoveGridRecords(rowSelectObjs,direction,"");
			return true;
		}
	}

	obj.menuItemRowMoveDown_click = function()
	{
		var direction=1;
		var rowSelectObjs=obj.retGridPanel.getSelectionModel().getSelections();
		if(rowSelectObjs)
		{
			moveToRowNum=Number(rowSelectObjs[0].data.rowId)+1;
			MoveGridRecords(rowSelectObjs,direction,"");
			return true;
		}
	}

	obj.menuItemRowMoveTo_click = function()
	{
		document.getElementById("rowno_moveto").focus();
		var moveToRowNum = document.getElementById("rowno_moveto").value;
		if(!moveToRowNum)
		{
			if(event && event.preventDefault) event.preventDefault();
			else window.event.returnValue = false;
			return false;
		}
		else
		{
			var rowSelectObjs=obj.retGridPanel.getSelectionModel().getSelections();
			if(rowSelectObjs)
			{
				MoveGridRecords(rowSelectObjs,"",moveToRowNum);
				return true;
			}
		}
	}

	function MoveGridRecords(records,direction,moveToRowNum)
	{
		var rowIdStr="";
		for(var i in records)
		{
			if(typeof records[i] == 'object')
			{
				if(rowIdStr.length>0)rowIdStr = rowIdStr+"^";
				rowIdStr = rowIdStr+records[i].data.rowId;
			}
		}
		var ret = obj._DHCANOPStat.MoveResultRows(obj.anciId,obj.historySeq,rowIdStr,direction,moveToRowNum);
		if(ret == "0")
		{
			obj.ifInquiry = 'N';
			obj.RefreshInquiryResult();
		}
		else
		{
			alert("移动行错误!");
		}
	}

	obj.menuItemRowMoveTo.on("click",obj.menuItemRowMoveTo_click,obj);
	obj.menuItemRowMoveUp.on("click",obj.menuItemRowMoveUp_click,obj);
	obj.menuItemRowMoveDown.on("click",obj.menuItemRowMoveDown_click,obj);
}