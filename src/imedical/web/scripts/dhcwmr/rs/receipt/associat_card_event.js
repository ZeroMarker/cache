function VS_InitAssociatCardEvent(obj)
{
	var ClsPatient = ExtTool.StaticServerObject("DHCWMR.Base.Patient");
	var ClsSSVolume = ExtTool.StaticServerObject("DHCWMR.SS.Volume")
	var ClsSSMain = ExtTool.StaticServerObject("DHCWMR.SS.Main")
	var ClsSSVolPaadm = ExtTool.StaticServerObject("DHCWMR.SS.VolPaadm")

	obj.VS_LoadEvent = function()
	{
		obj.btnAssociat.on("click",obj.btnAssociat_cilck,obj);
		obj.AdmListStore.load({
			callback : function(r,option,success){
				if (success) {
					obj.LoadPanelData();
				}
			}
		});
	}

	obj.btnAssociat_cilck = function()
	{
		var VolumeID = "",MrNo = "";
		obj.AdmListStore.each(function(r)
			{
				if (r.get("VolumeID")){
					VolumeID = r.get("VolumeID");
					MrNo = r.get("MrNo");
				}
			}
		);
		if (!VolumeID){
			Ext.MessageBox.alert("错误提示","卷信息错误！");
			return;
		}
		Ext.MessageBox.confirm('提示', '是否进行关联，请确认！', function(btn,text){
			if (btn=="yes"){
				//关联
				var ret = tkMakeServerCall("DHCWMR.SS.VolPaadm","RsAssociatCard",VolumeID,obj.VS_Argument.EpisodeID);
				if (!ret)
				{
					Ext.MessageBox.alert("错误提示","关联失败！");
					return;
				}else{
					var manName = Common_GetValue("txtHName");
					var ret = ClsSSVolPaadm.UpdateManNameByVol(VolumeID,manName);
					if (ret<0) { 
						Ext.MessageBox.alert("错误提示","更新男方姓名失败！");
					}

					Ext.MessageBox.alert("提示","关联成功！");
					obj.VS_WinAssociatCard.close();
					var MainID = ClsSSVolume.GetObjById(VolumeID).SVMainDr;
					var VolPaadm = ClsSSVolPaadm.GetPatObjByAdm(obj.VS_Argument.EpisodeID,"","");
					var Main = ClsSSMain.GetObjById(MainID);

					Common_SetValue("txtMrNo",MrNo);
					Common_SetValue("txtHName",VolPaadm.VPManName);
					Common_SetValue("txtMarker",Main.SMMarker);
					Common_SetValue("txtFileNo",Main.SMFileNo);
					Common_LoadCurrPage("AdmList");
				}
			}
		});
	}
	obj.LoadPanelData = function()
	{
		var VolumeID = "",PatientID = "",EpisodeID="";
		obj.AdmListStore.each(function(r)
			{
				if (r.get("VolumeID")){
					VolumeID = r.get("VolumeID");
					EpisodeID = r.get("EpisodeID");
				}
				PatientID = r.get("PatientID");
			}
		);

		if (VolumeID)
		{
			var MainID = ClsSSVolume.GetObjById(VolumeID).SVMainDr;
			var VolPaadm = ClsSSVolPaadm.GetPatObjByAdm(EpisodeID,"","");
			var Main = ClsSSMain.GetObjById(MainID);
			Common_SetValue("txtMarkerTo",Main.SMMarker);
			Common_SetValue("txtFileNoTo",Main.SMFileNo);
			Common_SetValue("txtHNameTo",VolPaadm.VPManName);
		}
		
		var Patient = ClsPatient.GetObjById(PatientID);
		Common_SetValue("txtMrNoTo",Patient.OutPatientMrNo);
		Common_SetValue("txtPapmiNoTo",Patient.PapmiNo);
		Common_SetValue("txtPatNameTo",Patient.PatientName);
		Common_SetValue("txtSexTo",Patient.Sex);
		Common_SetValue("txtAgeTo",Patient.Age);
		Common_SetValue("txtIdentityCodeTo",Patient.PersonalID);
		
	}
}