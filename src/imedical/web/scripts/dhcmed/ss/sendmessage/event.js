
function InitwinViewportEvent(obj) {
	var CHR_1 = String.fromCharCode(1);
	var RowIndex="";
	var objMess = ExtTool.StaticServerObject("DHCMed.SSService.MessageSrv");
	var MessRowid="";
	
	obj.objSelContextMenu = new Ext.menu.Menu(
		{
			items:[
				{
					text:'<b>删除用户</b>',
					icon:'../scripts/dhcmed/img/delete.gif',
					handler:function()
					{
						if(RowIndex == null) return;
						obj.MessRecUserStore.removeAt(RowIndex);
						obj.MessRecUserStore.load();
					}
				}
			]
		}
	);
	obj.LoadEvent = function(args)
  {};
	obj.MessageGrid_rowdblclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.MessageGridStore.getAt(rowIndex);
		var MessageID=objRec.get("rowid");
		if(MessageID=="") return;
		var objWinEdit = new InitViewWin(MessageID);
		objWinEdit.ViewWin.show();
	};
	obj.MessageGrid_rowclick = function()
	{
		obj.BtnClear.disable(true);
		obj.MessRecUser.disable(true);
		obj.UserCBox.disable(true);
		obj.CtlocCBox.disable(true);
		obj.GroupCBox.disable(true);
		var rowIndex = arguments[1];
		var objRec = obj.MessageGridStore.getAt(rowIndex);
		if(objRec.get("rowid")=="")
		{
			ExtTool.alert("提示","请先选择一条消息!");
			return;
		}
		obj.MessRecUserStore.removeAll();
		if(objRec.get("rowid")!=MessRowid)
		{
			MessRowid=objRec.get("rowid");
			obj.MessageText.setValue(objRec.get("Message"));
			var ret=objMess.GetUserListByMessID(MessRowid);
			if(ret==-1) return;
		
			var len=ret.split(CHR_1).length;
			for (var i=0;i<len;i++)
			{
				var str=ret.split(CHR_1)[i];
				var userID=str.split("^")[0];
				var userName=str.split("^")[1];
				var str=Validate(obj,userID);		// ret=-1表示该用户已经在列表中
				if(str==1) AddUser(obj,userID,userName);
			}
		}
		else{
			obj.BtnClear.enable(true);
			obj.MessRecUser.enable(true);
			obj.UserCBox.enable(true);
			obj.CtlocCBox.enable(true);
			obj.GroupCBox.enable(true);
			MessRowid="";
			ClearPanelData(obj);
		}
	};
	obj.BtnSave_click = function()
	{
		var SSUserID="";
		var MessText=obj.MessageText.getValue();
		var LogonUserID=session['LOGON.USERID'];
		if(LogonUserID=="") return;
		if(MessText=="")
		{
			ExtTool.alert("提示","消息内容不能为空!");
			return;	
		}
		if(obj.MessRecUserStore.getCount()==0)
		{
			ExtTool.alert("提示","接收人不能为空!");
			return;	
		}
		for(var i = 0; i < obj.MessRecUserStore.getCount(); i ++)
    	{
    		var objUser = obj.MessRecUserStore.getAt(i);
    		var UserID=objUser.get("UserID");
    		if(SSUserID=="") SSUserID=UserID;
    		else SSUserID += "^"+UserID;
    	}
    	var str=LogonUserID+"^"+MessText+CHR_1+SSUserID;
    	//alert(str);
    	if(MessRowid=="")
    	{
    		var ret=objMess.SendMessageToUser(str);
    	}
    	else
    	{
    		str=MessRowid+"^"+LogonUserID+"^"+MessText;
    		var ret=objMess.UpdateMessageToUser(str);
    	}
    	MessRowid="";
    	obj.BtnClear.enable(true);
		obj.MessRecUser.enable(true);
		obj.UserCBox.enable(true);
		obj.CtlocCBox.enable(true);
		obj.GroupCBox.enable(true);
   		obj.MessageGridStore.load();
   		ClearPanelData(obj);
	};
	obj.BtnClear_click = function()
	{
		obj.MessRecUserStore.removeAll();
		obj.MessRecUserStore.load();
	}
	obj.UserCBox_select = function()
	{
		var userID=obj.UserCBox.getValue();
		var userName=obj.UserCBox.getRawValue();
		var ret=Validate(obj,userID);		// ret=-1表示该用户已经在列表中
		if (ret==1) AddUser(obj,userID,userName);
		ExtTool.AddComboItem(obj.UserCBox,"","");
	};
	obj.CtlocCBox_select = function()
	{
		var LocID=obj.CtlocCBox.getValue();
		if(LocID=="") return;
		var ret=objMess.GetUserByLocID(LocID);
		if(ret==-1) return;
		
		var len=ret.split(CHR_1).length;
		for (var i=0;i<len;i++)
		{
			var str=ret.split(CHR_1)[i];
			var userID=str.split("^")[0];
			var userName=str.split("^")[1];
			var str=Validate(obj,userID);		// ret=-1表示该用户已经在列表中
			if(str==1) AddUser(obj,userID,userName);
		}
		ExtTool.AddComboItem(obj.CtlocCBox,"","");
	};
	obj.GroupCBox_select = function()
	{
		var GroupID=obj.GroupCBox.getValue();
		if(GroupID=="") return;
		var ret=objMess.GetUserByGroupID(GroupID);
		if(ret==-1) return;
		
		var len=ret.split(CHR_1).length;
		for (var i=0;i<len;i++)
		{
			var str=ret.split(CHR_1)[i];
			var userID=str.split("^")[0];
			var userName=str.split("^")[1];
			var str=Validate(obj,userID);		// ret=-1表示该用户已经在列表中
			if (str==1) AddUser(obj,userID,userName);
		}
		ExtTool.AddComboItem(obj.GroupCBox,"","");
	};
	
	obj.MessRecUser_rowcontextmenu = function(objGrid, rowIndex, eventObj)
	{
		RowIndex=rowIndex;
		eventObj.preventDefault();//覆盖默认右键
		objGrid.getSelectionModel().selectRow(rowIndex);
		obj.objSelContextMenu.showAt(eventObj.getXY());
	}
}
function AddUser(obj,userID,userName)
{
		var rec=new Ext.data.Record({		
			checked:true,
			UserID:userID,
			UserName:userName
		});
		obj.MessRecUserStore.add([rec]);     //往GridPanel里面添加临时数据
		obj.MessRecUserStore.load();	
}
function Validate(obj,userID)
{
	var ret=1;
	for(var i = 0; i < obj.MessRecUserStore.getCount(); i ++)
    {
    	var objUser = obj.MessRecUserStore.getAt(i);
    	var UserID=objUser.get("UserID");
    	if(UserID==userID) ret=-1;
    }
    return ret;
}
function InitViewWinEvent(obj)
{	

}
function ClearPanelData(obj)
{
	obj.MessageText.setValue("");
	obj.MessRecUserStore.removeAll();
	obj.MessRecUserStore.load();
}