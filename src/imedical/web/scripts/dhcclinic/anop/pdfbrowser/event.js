function InitViewScreenEvent(obj)
{ 
	var _DHCANOPPdfBrowser=ExtTool.StaticServerObject('web.DHCANOPPdfBrowser');
	var intReg=/^[1-9]\d*$/;
	var SelectNum=0;
	var logLocType = "App"
	obj.LoadEvent = function(args)
	{
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
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPPdfBrowser';
			param.QueryName = 'GetPatInfo';
			param.Arg1 = EpisodeID;
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
			var FTPType=obj.FTPType.getValue();
			if(FTPType=="")
			{
				alert("请选择查看文件类型");
				return;
			}
			var opaId="";
			opaId=selectObj.get('opaId');
			var EpisodeID = selectObj.get('adm');
			var existsFlag=_DHCANOPPdfBrowser.CheckPDFIfExist(FTPType,EpisodeID,opaId);
			if(existsFlag==1)
			{
			    var PDFUrl=_DHCANOPPdfBrowser.GetPDFUrl(FTPType,EpisodeID,opaId);
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
				alert("服务器不存在此文件,请重新选择");
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
			alert("请选择一条手术记录");
		}
	}
	
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick = function ()
	{
		var count=obj.csm.getCount();
		var selectObj = obj.csm.getSelected();
	    var linenum=obj.retGridPanel.getSelectionModel().lastActive;
		if ((count==1)&&(selectObj))
		{
			SelectedRowID=selectObj.get("opaId");
			if(preRowID!=SelectedRowID)
	        {
		        obj.txtPatname.setValue(selectObj.get('patname'));
		        obj.txtPatSex.setValue(selectObj.get('sex'));
		        obj.txtPatAge.setValue(selectObj.get('age'));
		        obj.txtPatRegNo.setValue(selectObj.get('regno'));
		        
		        obj.txtMedCareNo.setValue(selectObj.get('medCareNo'));
		        obj.txtRegNo.setValue(selectObj.get('regno'));
		        obj.opaId.setValue(selectObj.get('opaId'));
		        
		        var adm = selectObj.get('adm');
		        obj.EpisodeID.setValue(adm);
		        var EpisodeID = adm;
		        var AnaesthesiaID = "";
		        var PatientID=selectObj.get('PatientID');
		        var mradm=selectObj.get('PAADMMainMRADMDR');
		        AnaesthesiaID = selectObj.get('AnaesthesiaID');
		        var win = top.frames['eprmenu'];
		        var isSet = false;
		        if (win)
		        {
			        var frm = win.document.forms['fEPRMENU'];
			        if (frm)
			        {
				        frm.PatientID.value = PatientID;
				        frm.EpisodeID.value =adm;
				        frm.mradm.value=mradm;
				        if (frm.AnaesthesiaID)
				            frm.AnaesthesiaID.value = AnaesthesiaID;
					        isSet = true;
					}
				}
				if (isSet == false)
				{
					var frm = dhcsys_getmenuform();
					if (frm)
					{
						frm.PatientID.value = PatientID;
						frm.EpisodeID.value =adm;
						frm.mradm.value=mradm;
						if (frm.AnaesthesiaID)
						    frm.AnaesthesiaID.value = AnaesthesiaID;
				    }
				}
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
		        obj.opaId.setValue('');
			    SelectedRowID = 0;
			    preRowID=0;
			    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    }
		}
	}
}
