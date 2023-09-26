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
		    //obj.FTPSrvUserCode.setValue(rc.get("FTPSrvUserCode"));
		    obj.FTPFolderName.setValue(rc.get("FTPFolderName"));
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
		var FTPFolderName=obj.FTPFolderName.getRawValue();
		var FTPType=obj.FTPFolderName.getValue();
		//ȷ��ѡ���޸�ʱ������
		if(FTPType=="DHCANOP") FTPType="A"
		if(FTPType=="DHCANPACU") FTPType="PA"
		if(FTPType=="DHCANPRE") FTPType="PR"
		if(FTPType=="DHCANPOST") FTPType="PO"
		if(FTPType=="DHCICU") FTPType="I"
		//----------
		if(FTPSrvIP==""||FTPSrvPortNo==""||FTPSrvUserName==""||FTPSrvUserCode==""||FTPFolderName=="")
		{
			Ext.Msg.alert("��ʾ","������IP,�˿ں�,�û���,����,�ļ��������������Ϊ��");
			return;
		}
		var ret=_DHCANCPDFConfig.SaveFTPConfig(FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","����ɹ�");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
			obj.retGridPanelStore.reload();
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
			obj.retGridPanelStore.reload();
		}
		
	};
	obj.DeleteButton_click=function()
	{
		var FTPRowId=obj.FTPRowId.getValue();
		if(FTPRowId=="")
		{
			Ext.Msg.alert("��ʾ","����ѡ��һ��");
			return;
		}
		var ret=_DHCANCPDFConfig.DeleteFTPConfig(FTPRowId);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","ɾ���ɹ�");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
			obj.retGridPanelStore.reload();
		}
		else
		{
			Ext.Msg.alert("��ʾ","ɾ��ʧ��");
			obj.FTPSrvIP.setValue("");
		    obj.FTPSrvPortNo.setValue("");
		    obj.FTPSrvUserName.setValue("");
		    obj.FTPSrvUserCode.setValue("");
		    obj.FTPFolderName.setValue("");
			obj.retGridPanelStore.reload();
		}
	}
}