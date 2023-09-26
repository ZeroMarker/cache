
function InitwinsSendMessageEvent(obj,paadm)
{	
	var objMess = ExtTool.StaticServerObject("DHCMed.SSService.MessageSrv");
	var CHR_1 = String.fromCharCode(1);
	var RowIndex="";
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
	{
	}
	obj.BtnSave_click = function()
	{
		var SSUserID="";
		var MessText=obj.Message.getValue();
		var LogonUserID=session['LOGON.USERID'];
		if(LogonUserID=="")
		{
			ExtTool.alert("提示","请先登录!");	
			return;
		}
		if(MessText=="")
		{
			ExtTool.alert("提示","消息内容不能为空!");
			return;	
		}
		if(paadm=="")
		{
			ExtTool.alert("提示","病人就诊号不能为空!");
			return;	
		}
		for(var i = 0; i < obj.MessRecUserStore.getCount(); i ++)
    	{
    		var objUser = obj.MessRecUserStore.getAt(i);
    		var UserID=objUser.get("UserID");
    		if(SSUserID=="") SSUserID=UserID;
    		else SSUserID += "^"+UserID;
    	}
    	var str=paadm+"^"+LogonUserID+"^"+MessText+CHR_1+SSUserID;
		var ret=objMess.SendMessageToPatient(str);
		if(ret>0)
		{
			ExtTool.alert("提示","发送成功!");
			obj.PatMessageListStore.load();
			obj.MessRecUserStore.removeAll();
			obj.MessRecUserStore.load();
			obj.Message.setValue("");
			return;	
		}else{
			ExtTool.alert("提示","发送失败!");
			return;
		}
	};
	obj.BtnExit_click = function()
	{
		obj.winsSendMessage.close();
	};
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
	obj.PatMessageList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.PatMessageListStore.getAt(rowIndex);
		obj.Message.setValue(objRec.get("Message"));
	};
	obj.MessRecUser_rowcontextmenu = function(objGrid, rowIndex, eventObj)
	{
		RowIndex=rowIndex;
		eventObj.preventDefault();//覆盖默认右键
		objGrid.getSelectionModel().selectRow(rowIndex);
		var position=eventObj.getXY()
		obj.objSelContextMenu.showAt(position);
	}
	obj.BtnClear_click = function()
	{
		obj.MessRecUserStore.removeAll();
		obj.MessRecUserStore.load();
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