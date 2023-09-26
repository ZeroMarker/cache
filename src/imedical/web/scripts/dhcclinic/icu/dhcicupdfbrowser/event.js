function InitViewScreenEvent(obj)
{ 
	var _DHCICUPdfBrowser=ExtTool.StaticServerObject('web.DHCICUPdfBrowser');
	var intReg=/^[1-9]\d*$/;
	var SelectNum=0;
	var logLocType = "App"
	obj.LoadEvent = function(args)
	{
		/*
		var isSet=false
		var win=top.frames['eprmenu'];
		if (win)
		{
			var frm = win.document.forms['fEPRMENU'];
			if (frm)
			{
				var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
				var mradm=frm.mradm.value; 
 
				isSet=true
			}
		}
		if (isSet==false)
		{
			var frm =dhcsys_getmenuform();
			if (frm)
			{ 				
			    var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
				var mradm=frm.mradm.value; 
			}
		}
		*/
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCICUPdfBrowser';
			param.QueryName = 'GetPatInfo';
			param.Arg1 = EpisodeID;
			//param.Arg1 = 28258395;
			param.ArgCnt = 1;
		});
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
	};
	obj.btnView_click = function()
	{
		var selectObj = obj.csm.getSelected();
		if (selectObj)
		{
			var icuaId="";
			icuaId=selectObj.get('icuaId');
			var EpisodeID = selectObj.get('tEpisodeID');
			var date=obj.dateFrm.getRawValue();
			var existsFlag=_DHCICUPdfBrowser.CheckPDFIfExist(EpisodeID,icuaId,date);
			if(existsFlag==1)
			{
				var PDFUrl=_DHCICUPdfBrowser.GetPDFUrl(EpisodeID,icuaId,date);
			    if(PDFUrl=="")
			    {
				    alert("FTP服务器信息未维护！");
				    return;
			    }
			    else
			    {
				    window.open(PDFUrl);
			    }
			}
			else if(existsFlag==0)
			{
				alert("服务器不存在此文件,请重新选择查看日期");
				return;
			}
			else
			{
				alert(existsFlag);
				return;
			}
		}
		else
		{
			alert("请选择一条记录");
		}
	}
	
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick = function ()
	{
	    var count=obj.csm.getCount();
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
	    var linenum=obj.retGridPanel.getSelectionModel().lastActive;
		if ((count==1)&&(selectObj))
		{
			SelectedRowID=selectObj.get("icuaId");
		    if(preRowID!=SelectedRowID)
	        {
		        obj.txtPatname.setValue(selectObj.get('tPatName'));
		        obj.txtPatSex.setValue(selectObj.get('sex'));
		        obj.txtPatAge.setValue(selectObj.get('age'));
		        obj.txtPatRegNo.setValue(selectObj.get('tRegNo'));
		        
		        obj.txtMedCareNo.setValue(selectObj.get('tMedCareNo'));
		        obj.txtRegNo.setValue(selectObj.get('tRegNo'));
		        obj.icuaId.setValue(selectObj.get('icuaId'));
			    obj.EpisodeID.setValue(selectObj.get('tEpisodeID'));
			    preRowID=SelectedRowID;
	        }
		    else
		    {
			    obj.txtPatname.setValue('');
			    obj.txtPatSex.setValue('');
			    obj.txtPatAge.setValue('');
			    obj.txtPatRegNo.setValue('');
			    obj.txtMedCareNo.setValue('');
			    obj.EpisodeID.setValue('');
			    obj.txtRegNo.setValue('');
			    obj.icuaId.setValue('');
			    SelectedRowID = 0;
			    preRowID=0;
			    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
			}
		}
	}
}
