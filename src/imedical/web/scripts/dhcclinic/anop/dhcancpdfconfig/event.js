function InitViewScreenEvent(obj)
{
	var _DHCANCPDFConfig = ExtTool.StaticServerObject('web.DHCANCPDFConfig');
	obj.LoadEvent=function(args)
	{
		
	};
	var SelectedRowID =0;
    var preRowID=0;
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		SelectedRowID=rc.get("Id");
		if(preRowID!=SelectedRowID)
	    {
		    obj.FTPRowId.setValue(rc.get("Id"));
		    obj.FTPSrvIP.setValue(rc.get("FTPSrvIP"));
		    obj.FTPSrvPortNo.setValue(rc.get("FTPSrvPortNo"));
		    obj.FTPSrvUserName.setValue(rc.get("FTPSrvUserName"));
		    ///obj.FTPSrvUserCode.setValue(rc.get("FTPSrvUserCode"));
		    obj.FTPFolderName.setValue(rc.get("FTPFolderName"));
		    obj.FTPType.setValue(rc.get("FTPType"));
		    obj.FTPHttpsPortNo.setValue(rc.get("FTPHttpsPortNo"));
		    preRowID=SelectedRowID;
		}
		else
		{
		    obj.FTPRowId.setValue("");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
		    obj.FTPType.setValue("");
		    obj.FTPHttpsPortNo.setValue("");
		    SelectedRowID = 0;
		    preRowID=0;
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		}
	  }
	};
	obj.SaveButton_click=function()
	{
		var FTPSrvIP=obj.FTPSrvIP.getValue();
		var FTPSrvPortNo=obj.FTPSrvPortNo.getValue();
		var FTPSrvUserName=obj.FTPSrvUserName.getValue();
		var FTPSrvUserCode=obj.FTPSrvUserCode.getValue();
		var FTPFolderName=obj.FTPFolderName.getValue();
		var FTPType=obj.FTPType.getValue();
		var FTPHttpsPortNo=obj.FTPHttpsPortNo.getValue();
		//确保选中修改时不出错
		if(FTPType=="DHCANOP") FTPType="A"
		if(FTPType=="DHCANPACU") FTPType="PA"
		if(FTPType=="DHCANPRE") FTPType="PR"
		if(FTPType=="DHCANPOST") FTPType="PO"
		if(FTPType=="DHCICU") FTPType="I"
		//----------
		if(FTPSrvIP==""||FTPSrvPortNo==""||FTPSrvUserName==""||FTPSrvUserCode==""||FTPFolderName==""||FTPType==""||FTPHttpsPortNo=="")
		{
			Ext.Msg.alert("提示","服务器IP,端口号,用户名,密码,文件夹名,文件类型,预览路径各项均不能为空");
			return;
		}
		var ret=_DHCANCPDFConfig.SaveFTPConfig(FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPHttpsPortNo);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存成功");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
		    obj.FTPType.setValue("");
		    obj.FTPHttpsPortNo.setValue("");
			obj.retGridPanelStore.reload();
		}
		else
		{
			Ext.Msg.alert("提示","保存失败");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
		    obj.FTPType.setValue("");
		    obj.FTPHttpsPortNo.setValue("");
			obj.retGridPanelStore.reload();
		}
		
	};
	obj.DeleteButton_click=function()
	{
		var FTPRowId=obj.FTPRowId.getValue();
		if(FTPRowId=="")
		{
			Ext.Msg.alert("提示","请先选中一行");
			return;
		}
		var ret=_DHCANCPDFConfig.DeleteFTPConfig(FTPRowId);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","删除成功");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
		    obj.FTPType.setValue("");
		    obj.FTPHttpsPortNo.setValue("");
			obj.retGridPanelStore.reload();
		}
		else
		{
			Ext.Msg.alert("提示","删除失败");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
		    obj.FTPType.setValue("");
		    obj.FTPHttpsPortNo.setValue("");
			obj.retGridPanelStore.reload();
		}
	}
}