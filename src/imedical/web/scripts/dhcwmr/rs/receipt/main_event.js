function InitviewScreenEvents(obj)
{
	var ClsPatient = ExtTool.StaticServerObject("DHCWMR.Base.Patient");
	var ClsSSVolume = ExtTool.StaticServerObject("DHCWMR.SS.Volume")
	var ClsSSMain = ExtTool.StaticServerObject("DHCWMR.SS.Main")
	var ClsSSVolPaadm = ExtTool.StaticServerObject("DHCWMR.SS.VolPaadm")
	var ClsSSMrType = ExtTool.StaticServerObject("DHCWMR.SS.MrType");
	obj.LoadEvents = function(){
		obj.cboHospital.on("select",obj.cboHospital_select,obj);
		obj.txtPapmiNo.on("specialkey",obj.txtPapmiNo_specialkey,obj);
		obj.btnModify.on("click",obj.btnModify_click,obj);
		obj.btnBatchPrintBar.on("click",obj.btnBatchPrintBar_click,obj);
		Common_SetValue('chkMBarCode',true);
		Common_SetValue('chkVBarCode',true);
		obj.cboHospital.setValue(CTHospID);
		obj.cboHospital.setRawValue(CTHospDesc);
		obj.cboHospital_select();
	}

	obj.cboHospital_select = function(combo,record,index){
		//加载病案类型
		obj.cboMrType.getStore().removeAll();
		obj.cboMrType.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboMrType.setValue(r[0].get("MrTypeID"));
						obj.cboMrType.setRawValue(r[0].get("MrTypeDesc"));
					}
				}
			}
		});
	}
				
	obj.txtPapmiNo_specialkey = function(feild , e)
	{
		if (e.getKey() != Ext.EventObject.ENTER) return;		
		var PatientID="",VolumeID="",EpisodeID="";
		obj.AdmListStore.load({
			callback:function(){
				obj.AdmListStore.each(function(r){
					if (r.get("VolumeID"))
					{
						VolumeID = r.get("VolumeID");
						EpisodeID = r.get("EpisodeID");
					}
					PatientID = r.get("PatientID");	
				});
				obj.CleanBaseInfo();
				obj.GetBaseInfo(PatientID,VolumeID,EpisodeID);
			}
		});
	}
	
	obj.GetBaseInfo = function(PatientID,VolumeID,EpisodeID)
	{
		if (PatientID!=""){
			var objPatient = ClsPatient.GetObjById(PatientID);
			Common_SetValue("txtPapmiNo",objPatient.PapmiNo);
			Common_SetValue("txtPatName",objPatient.PatientName);
			Common_SetValue("txtSex",objPatient.Sex);
			Common_SetValue("txtAge",objPatient.Age);
			Common_SetValue("txtIdentityCode",objPatient.PersonalID);
		}
		if (VolumeID!=""){
			var objVolume = ClsSSVolume.GetObjById(VolumeID);
			var objMain   = ClsSSMain.GetObjById(objVolume.SVMainDr);
			Common_SetValue("txtMrNo",objMain.SMMrNo);
			Common_SetValue("txtMarker",objMain.SMMarker);
			Common_SetValue("txtFileNo",objMain.SMFileNo);
		}
		if (EpisodeID!=""){
			var objVolPaadm  = ClsSSVolPaadm.GetPatObjByAdm(EpisodeID,"","");
			Common_SetValue("txtHName" ,objVolPaadm.VPManName);
			
		}
	}
    
    obj.CleanBaseInfo = function()
    {
	    Common_SetValue("txtMrNo","");
		Common_SetValue("txtPapmiNo","");
		Common_SetValue("txtPatName","");
		Common_SetValue("txtSex","");
		Common_SetValue("txtAge","");
		Common_SetValue("txtIdentityCode","");
		Common_SetValue("txtMarker","");
		Common_SetValue("txtFileNo","");
		Common_SetValue("txtHName","");
	}
    
	obj.ReceiptClick = function(PatientID,EpisodeID,MrNo,PapmiNo,MrTypeID){
		var ManName 	 = Common_GetValue("txtHName");
		var IdentityCode = Common_GetValue("txtIdentityCode");
		var Error		 = "";
		if (!ManName)		Error = Error+"男方姓名为空！";
		if (Error!="")
		{
			Ext.MessageBox.alert("提示",Error);
			return;
		}
		
		var ret = tkMakeServerCall("DHCWMR.SSService.VolumeSrv","GetPatByIdentityCode",IdentityCode,MrTypeID);
		if (ret)
		{
			Ext.MessageBox.confirm('提示', '该病人身份证存在建档记录，请确认！', function(btn,text){
				if (btn=="yes"){
					var ToPapmi_Dr = ret.split("^")[1];
					var ToPapmiNo =ClsPatient.GetObjById(ToPapmi_Dr).PapmiNo;
					if (IdentityCode){
						var HospID = Common_GetValue("cboHospital");
						var win = new VS_InitAssociatCard(HospID,MrTypeID,ToPapmiNo,EpisodeID);
						win.VS_WinAssociatCard.show();
					}
				}else{
					obj.GroupReceipt(PatientID,EpisodeID,MrNo,PapmiNo,MrTypeID);
				}
			});
		}else{
			obj.GroupReceipt(PatientID,EpisodeID,MrNo,PapmiNo,MrTypeID);
		}
	}
	
	obj.GroupReceipt = function(PatientID,EpisodeID,MrNo,PapmiNo,MrTypeID){
		if (!EpisodeID) return;
		var manName = Common_GetValue("txtHName");
		var LogonLocID=session['LOGON.CTLOCID'];
		var LogonUserID=session['LOGON.USERID'];
		var result = IGroupReceipt(EpisodeID,MrNo,LogonLocID,LogonUserID)
		var errArray = result.split('^');
		if ((errArray[0]*1)<1){
			Ext.MessageBox.alert("错误提示",errArray[1]);
			return;
		} else {
			var VolumeID = errArray[2];
			var MrNo 	 = errArray[3];
			var ret	 = obj.SaveVolPaadmExtra(VolumeID);
			var retArray = ret.split('^');
			if (retArray[0]<0){
				Ext.MessageBox.alert("错误提示",retArray[1]);
			}else{
				Ext.MessageBox.alert("提示","建档成功！");
			}
			Common_LoadCurrPage('AdmList');
			obj.GetBaseInfo(PatientID,VolumeID,EpisodeID);
			obj.PrintMrBarcode(VolumeID);
		}
	}

	obj.GroupUnReceipt = function(aEpisodeID)
	{
		if (!aEpisodeID) return;
		var result = IGroupUnReceipt(aEpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID']);
		var err = result.split('^')[0];
		if ((err*1)<0){
			ExtTool.alert('提示',err);
			return;
		}else{
			Common_LoadCurrPage('AdmList');
			obj.CleanBaseInfo();
		}
	}

	obj.SaveVolPaadmExtra = function(VolumeID)
	{
		var result = "",reterr = "";
		var ManName= Common_GetValue("txtHName");
		var Marker = Common_GetValue("txtMarker");
		var	FileNo = Common_GetValue("txtFileNo");
		var objMain= ClsSSVolume.GetObjById(VolumeID);
		var MainID = objMain.SVMainDr;

		var ret = ClsSSMain.UpdateMarker(MainID,Marker);
		if (ret<0) reterr = reterr + "更新标记失败！";

		var ret = ClsSSMain.UpdateFileNo(MainID,FileNo);
		if (ret<0) reterr = reterr + "更新上架号失败！";

		var ret = ClsSSVolPaadm.UpdateManNameByVol(VolumeID,ManName);
		if (ret<0) reterr = reterr + "更新男方姓名失败！";
		
		if (reterr==""){
			result = "1"		
		}else{
			result = "-1"+"^"+reterr;
		}
		return result;
	}

	obj.btnModify_click = function()
	{
		var ManName = Common_GetValue("txtHName");
		if (!ManName)
		{
			Ext.MessageBox.alert("提示","请输入男方姓名！");
			return;
		}
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
		var ret	 = obj.SaveVolPaadmExtra(VolumeID);
		var retArray = ret.split('^');
		if (retArray[0]<0){
			Ext.MessageBox.alert("错误提示",retArray[1]);
			return;
		}else{
			Ext.MessageBox.alert("提示","修改成功！");
			obj.GetBaseInfo(PatientID,VolumeID,EpisodeID);
		}
	}
	
	obj.btnBatchPrintBar_click = function(){
		var isPrintMBarcode = Common_GetValue("chkMBarCode");
		var isPrintVBarcode = Common_GetValue("chkVBarCode");
		if ((!isPrintMBarcode)&&(!isPrintVBarcode)) return;
		
		var VolumeID = '';
		var objStore = obj.AdmList.getStore();
		for (var row = 0; row < objStore.getCount(); row++){
			var record = objStore.getAt(row);
				VolumeID = record.get('VolumeID');
		}
		obj.PrintMrBarcode(VolumeID);
	}
	
	obj.PrintMrBarcode = function(VolumeIDs){
		var isPrintMBarcode = Common_GetValue("chkMBarCode");
		var isPrintVBarcode = Common_GetValue("chkVBarCode");
		if ((!isPrintMBarcode)&&(!isPrintVBarcode)) return;
		
		try {
			var strBarInfo = ExtTool.RunServerMethod("DHCWMR.SSService.VolumeSrv","GetBarInfo",VolumeIDs);
			if (strBarInfo == '') return;
			var arrBarInfo = strBarInfo.split(CHR_1);
			if (arrBarInfo.length<1) return;
			
			var strPrinterName = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //取条码打印机名称
			if (strPrinterName=='') strPrinterName='Zebra';
			var strBarFormat = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodeTypeO');  //取条码打印格式（条码样式）

			var Bar = new ActiveXObject("DHCMedBarCode.PrintBarMR");
			Bar.PrinterName = strPrinterName;  //打印机名称
			Bar.PrinterPort = "";              //打印机端口号
			Bar.BarFormat   = strBarFormat;    //设置条码样式编号
			//Bar.SetPrinter();                //设置打印机
			
			for (var indMR = 0; indMR < arrBarInfo.length; indMR++) {
				var strPatBarInfo = arrBarInfo[indMR];
				if (strPatBarInfo == '') return;
				var arrPatBarInfo = strPatBarInfo.split(CHR_2);
				var strMBarInfo = arrPatBarInfo[0];
				if (strMBarInfo == '') return;
				var arrMBarInfo = strMBarInfo.split("^");
				
				if ((isPrintMBarcode)&&(arrMBarInfo.length>=6)) {
					Bar.vMrType      = arrMBarInfo[1];
					Bar.vMrNo        = arrMBarInfo[2];
					Bar.vPatientName = arrMBarInfo[3];
					Bar.vSex         = arrMBarInfo[4];
					Bar.vBirthday    = arrMBarInfo[5];
					Bar.vAge         = arrMBarInfo[6];
					Bar.vManName     = arrMBarInfo[7];
					Bar.vLocDesc     = '';
					Bar.vDischDate   = '';
					Bar.vBarCode     = arrMBarInfo[0];
					Bar.PrintOut();
				}
				
				if ((isPrintVBarcode)&&(arrMBarInfo.length>6)&&(arrPatBarInfo.length>1)) {
					Bar.vMrType      = arrMBarInfo[1] + " 卷";
					Bar.vMrNo        = arrMBarInfo[2];
					Bar.vPatientName = arrMBarInfo[3];
					Bar.vSex         = arrMBarInfo[4];
					Bar.vBirthday    = arrMBarInfo[5];
					Bar.vAge         = arrMBarInfo[6];
					Bar.vManName     = arrMBarInfo[7];

					for (indVol = 1; indVol < arrPatBarInfo.length; indVol++){
						var strVBarInfo = arrPatBarInfo[indVol];
						if (strVBarInfo == '') continue;
						var arrVBarInfo = strVBarInfo.split("^");
						if (arrVBarInfo.length>3) {
							Bar.vLocDesc     = arrVBarInfo[1];
							Bar.vDischDate   = arrVBarInfo[3];
							Bar.vBarCode     = arrVBarInfo[0];
							Bar.PrintOut();
						}
					}
				}
			}
		} catch(e) {
			alert('打印病案条码错误，' + e.message);
		}
	}
}