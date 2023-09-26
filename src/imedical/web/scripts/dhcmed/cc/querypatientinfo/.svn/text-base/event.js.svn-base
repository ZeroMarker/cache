
function InitwinViewportEvent(obj)
{	
	var paadm=0;
	obj.objSelContextMenu = new Ext.menu.Menu(
		{
			items:[
				{
					text:'<b>显示病人基本信息</b>',
					icon:'../scripts/dhcmed/img/menudic.gif',
					handler:function()
					{	
						var objDisplayWin = new DisplayPatientWin(paadm);
						objDisplayWin.objDisplayWin.show();							
					}
				},
				new Ext.menu.Separator({}),
				{
					text:'医嘱单',
					icon:'../scripts/dhcmed/img/menudic.gif',
					handler:function()
					{
						var objMarkWin = new InitOEWin(paadm); 
						objMarkWin.OEWin.show();
					}
				},
				new Ext.menu.Separator({}),
				{
					text:'发送消息',
					icon:'../scripts/dhcmed/img/menudic.gif',
					handler:function()
					{
						var objMarkWin = new InitwinsSendMessage(paadm); 
						objMarkWin.winsSendMessage.show();
					}
				}
			]
		}
	);
	obj.LoadEvent = function(args)
	{
	}
	obj.BtnFind_click = function()
	{
		obj.PatListGridStore.load({params : {start:0 ,limit:20}});
	};
	obj.Text_specialkey = function()
	{
		obj.PatListGridStore.load({params : {start:0 ,limit:20}});
	}
	obj.PatListGrid_rowcontextmenu = function(objGrid, rowIndex, eventObj)
	{
		eventObj.preventDefault();//覆盖默认右键
		var sel = obj.PatListGridStore.getAt(rowIndex);
		paadm = sel.get("Paadm");
		obj.objSelContextMenu.showAt(eventObj.getXY());
	}
}
