function InitviewScreenEvents(obj)
{
	var ClsPatient 	  = ExtTool.StaticServerObject("DHCWMR.Base.Patient");
	var ClsCtloc 	  = ExtTool.StaticServerObject("DHCWMR.Base.Ctloc");
	var ClsSSRsRquest = ExtTool.StaticServerObject("DHCWMR.SS.RsRquest");
	var ClsSSVolume   = ExtTool.StaticServerObject("DHCWMR.SS.Volume");
	var ClsSSVolPaadm = ExtTool.StaticServerObject("DHCWMR.SS.VolPaadm");
	var ClsSSMain 	  = ExtTool.StaticServerObject("DHCWMR.SS.Main");
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.btnConsult.on("click",obj.btnConsult_click,obj);
		obj.txtPapmiNo.on("specialkey",obj.txtPapmiNo_specialkey,obj);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
		obj.cboLoc.setValue(session['LOGON.CTLOCID']);
		obj.cboLoc.setRawValue(ClsCtloc.GetObjById(session['LOGON.CTLOCID']).Descs);
		obj.cboUser.setValue(session['LOGON.USERID']);
		obj.cboUser.setRawValue(session['LOGON.USERNAME']);	
		obj.RepListStore.load({});
	}
	
	obj.cboHospital_select = function(combo,record,index){
		//���ز�������
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
						obj.MrType = r[0].get("MrTypeID");
					}
				}
			}
		});
	}
		
	obj.txtPapmiNo_specialkey = function(feild , e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var RegNo = Common_GetValue("txtPapmiNo");
		if (RegNo=="") return;
		var PatientID=ExtTool.RunServerMethod("DHCWMR.SSService.CommonSrv","GetPatientID",RegNo);
		obj.Patient  = ClsPatient.GetObjById(PatientID);
		obj.Volume	 = ClsSSVolume.GetObjByPatID(PatientID,obj.MrType);
		if (!obj.Volume)
		{
			ExtTool.alert("��ʾ","����û�����ﲡ����");
			obj.CleanBaseInfo();
			return;
		}
		obj.GetBaseInfo(PatientID);
	}

	obj.btnConsult_click = function()
	{
		var VolumeID = obj.Volume.RowID;
		if (!VolumeID)
		{
			ExtTool.alert("��ʾ","����û�����ﲡ����");
			return;
		}
		if (obj.Volume.SVOrdStep!="S")
		{
			ExtTool.alert("��ʾ","�ò���δ��ⲻ�ܵ��ģ�");
			return;
		}
		var errinfo = ""
		var ReqTypeID = Common_GetValue("cboReqType");
		if (!ReqTypeID) {
			errinfo = errinfo + "��������Ϊ�գ�";
		}
		if (errinfo) {
			ExtTool.alert("������ʾ",errinfo);
			return;
		}
		
		var inputStr = "";
		inputStr = inputStr + CHR_1 + VolumeID;
		inputStr = inputStr + CHR_1 + "R";
		inputStr = inputStr + CHR_1 + ReqTypeID;
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		var flg = ClsSSRsRquest.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("������ʾ","�����ύʧ��!Error=" + flg);
			return;
		}else{
			ExtTool.alert("��ʾ","�ύ�ɹ���");
			Common_LoadCurrPage('RepList');
		}
	}
	
	obj.GetBaseInfo = function(PatientID)
	{
		var objMain = ClsSSMain.GetObjById(obj.Volume.SVMainDr);
		var ManName = ClsSSVolPaadm.GetManNameByPatID(PatientID,obj.MrType)
		Common_SetValue("txtMarker",objMain.SMMarker);
		Common_SetValue("txtFileNo",objMain.SMFileNo);
		Common_SetValue("txtMrNo",objMain.SMMrNo);
		Common_SetValue("txtHName",ManName);
		Common_SetValue("txtPapmiNo",obj.Patient.PapmiNo);
		Common_SetValue("txtPatName",obj.Patient.PatientName);
		Common_SetValue("txtSex",obj.Patient.Sex);
		Common_SetValue("txtAge",obj.Patient.Age);
		Common_SetValue("txtIdentityCode",obj.Patient.PersonalID);
		var CurrentStatusDr = obj.Volume.SVStatus;
		var ClsSSWorkItem = ExtTool.StaticServerObject("DHCWMR.SS.WorkItem");
		var objWorkItem = ClsSSWorkItem.GetObjById(CurrentStatusDr);
		var CurrentStatus = objWorkItem.WIDesc;
		document.getElementById("RsStatusDiv").innerHTML = "����״̬��" + CurrentStatus;
	}

	obj.CleanBaseInfo = function()
	{
		Common_SetValue("txtMarker","");
		Common_SetValue("txtFileNo","");
		Common_SetValue("txtHName","");
		Common_SetValue("txtMrNo","");
		Common_SetValue("txtPatName","");
		Common_SetValue("txtPapmiNo","");
		Common_SetValue("txtSex","");
		Common_SetValue("txtAge","");
		Common_SetValue("txtIdentityCode","");
		document.getElementById("RsStatusDiv").innerHTML = "";
	}
}