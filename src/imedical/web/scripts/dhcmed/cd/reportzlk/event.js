﻿function InitViewPortEvent(obj) {
	obj.PatientCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportPAT");
	obj.ReportZLKCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportZLK");
	obj.ReportCls=ExtTool.StaticServerObject("DHCMed.CD.CRReport");
	obj.ReportSrv=ExtTool.StaticServerObject("DHCMed.CDService.Service");
	obj.RepUpdateCls=ExtTool.StaticServerObject("DHCMed.CDService.UpdateService");
	obj.CtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
	obj.PatientSrv = ExtTool.StaticServerObject("DHCMed.Base.Patient")
	obj.LoadEvent = function(args)
    {
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCheck.on("click",obj.btnCheck_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnCancle.on("click",obj.btnCancle_click,obj);
		
		obj.cboCRZD.on("select",obj.cboCRZD_select,obj);
		obj.cboCRSWZD.on("select",obj.cboCRSWZD_select,obj);
		obj.cboCRZY.on('expand',obj.cboCRZY_expand,obj);
		obj.cboCRZY.on("select",obj.cboCRZY_select,obj);
			
		obj.cboProvince1.on('expand',obj.cboProvince1_expand,obj);
		obj.cboCity1.on('expand',obj.cboCity1_expand,obj);
		obj.cboCounty1.on('expand',obj.cboCounty1_expand,obj);
		obj.cboVillage1.on('expand',obj.cboVillage1_expand,obj);
		obj.cboProvince1.on('select',obj.cboProvince1_Select,obj);
		obj.cboCity1.on('select',obj.cboCity1_Select,obj);
		obj.cboCounty1.on('select',obj.cboCounty1_Select,obj);
		obj.cboVillage1.on('select',obj.cboVillage1_Select,obj);
		
		obj.cboProvince2.on('expand',obj.cboProvince2_expand,obj);
		obj.cboCity2.on('expand',obj.cboCity2_expand,obj);
		obj.cboCounty2.on('expand',obj.cboCounty2_expand,obj);
		obj.cboVillage2.on('expand',obj.cboVillage2_expand,obj);
		obj.cboProvince2.on('select',obj.cboProvince2_Select,obj);
		obj.cboCity2.on('select',obj.cboCity2_Select,obj);
		obj.cboCounty2.on('select',obj.cboCounty2_Select,obj);
		obj.cboVillage2.on('select',obj.cboVillage2_Select,obj);
		
		Common_SetDisabled("txtCRKPBH",true);
		Common_SetDisabled("txtCRReportDate",true);
		Common_SetDisabled("txtCRReportUser",true);
		
		Common_SetDisabled("txtPatName",true);
		Common_SetDisabled("txtPatSex",true);
		//Common_SetDisabled("txtPatCardNo",true);
		Common_SetDisabled("txtPatAge",true);
		Common_SetDisabled("cboPatAgeDW",true);
		Common_SetDisabled("txtBirthDay",true);
		Common_SetDisabled("cboCRMZ",true);
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);
  	};
  	
  	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(ReportID){		
		Common_SetVisible("btnSave",false);
		Common_SetVisible("btnPrint",false);
		Common_SetVisible("btnExport",false);
		Common_SetVisible("btnDelete",false);
		Common_SetVisible("btnCheck",false);
		Common_SetVisible("btnCancle",false);
		obj.RepStatusCode=obj.ReportSrv.GetReportStatus(ReportID);
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能上报
				Common_SetVisible("btnSave",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "1" : // 待审
				obj.btnSave.setText("修改报卡");
				Common_SetVisible("btnSave",true);
				Common_SetVisible("btnDelete",true);
				Common_SetVisible("btnCheck",true);
				Common_SetVisible("btnExport",true);
				Common_SetVisible("btnPrint",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "2" : // 审核
				Common_SetVisible("btnPrint",true);
				Common_SetVisible("btnExport",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "3" : // 删除
				Common_SetVisible("btnCancle",true);
				break;
		}
		
		if (tDHCMedMenuOper['Submit']!=1) {
			Common_SetVisible("btnSave",false);
		}
		if (tDHCMedMenuOper['Check']!=1) {
			Common_SetVisible("btnCheck",false);
		}
		if (tDHCMedMenuOper['Check']) {
			Common_SetVisible("btnDelete",false);
		}
	}
	
	obj.cboCRZD_select = function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtCRZDICD",objRec.get("ICD10"))
		}
	}
	
	obj.cboCRSWZD_select = function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtCRSYICD",objRec.get("ICD10"))
		}
	}
	
	obj.cboCRZY_expand = function(){
		obj.cboCRGZ.setValue('');
	}
	
	obj.cboCRZY_select = function(){
		var objRec = arguments[1];
		if (objRec){
			var DicCode=objRec.get("DicCode");
			var DicType="CDGZ"+DicCode;
			DicTypeGZ=DicType;
			obj.cboCRGZ.getStore().load({}); 
		}
	}
	
	//户籍地址触发事件
	obj.cboProvince1_expand = function(){
		obj.cboProvince1.setValue('');
		obj.cboCity1.setValue('');
		obj.cboCounty1.setValue('');
		obj.cboVillage1.setValue('');
	}
	obj.cboCity1_expand = function(){
		obj.cboCity1.clearValue();
		obj.cboCounty1.clearValue();
		obj.cboVillage1.clearValue();
	}
	obj.cboCounty1_expand = function(){
		obj.cboCounty1.clearValue();
		obj.cboVillage1.clearValue();
	}
	obj.cboVillage1_expand = function(){
		obj.cboVillage1.clearValue();
	}

	obj.cboProvince1_Select = function(){
		obj.cboCity1.getStore().load({}); 
		obj.cboCounty1.getStore().load({}); 
		obj.cboVillage1.getStore().load({}); 
	}
	obj.cboCity1_Select = function(){
		obj.cboCounty1.getStore().load({}); 
		obj.cboVillage1.getStore().load({}); 
	}
	obj.cboCounty1_Select = function(){
		obj.cboVillage1.getStore().load({}); 
	}
	obj.cboVillage1_Select = function(){
	}
	//居住地址触发事件
	obj.cboProvince2_expand = function(){
		obj.cboProvince2.setValue('');
		obj.cboCity2.setValue('');
		obj.cboCounty2.setValue('');
		obj.cboVillage2.setValue('');
	}
	obj.cboCity2_expand = function(){
		obj.cboCity2.setValue('');
		obj.cboCounty2.setValue('');
		obj.cboVillage2.setValue('');
	}
	obj.cboCounty2_expand = function(){
		obj.cboCounty2.setValue('');
		obj.cboVillage2.setValue('');
	}
	obj.cboVillage2_expand = function(){
		obj.cboVillage2.setValue('');
	}
	obj.cboProvince2_Select = function(){
		obj.cboCity2.getStore().load({}); 
		obj.cboCounty2.getStore().load({}); 
		obj.cboVillage2.getStore().load({}); 
	}
	obj.cboCity2_Select = function(){
		obj.cboCounty2.getStore().load({}); 
		obj.cboVillage2.getStore().load({}); 
	}
	obj.cboCounty2_Select = function(){
		obj.cboVillage2.getStore().load({}); 
	}
	obj.cboVillage2_Select = function(){
	}
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			var LogLocID = session['LOGON.CTLOCID'];
			var objLoc = obj.CtlocSrv.GetObjById(LogLocID);
			Common_SetValue("cboCRReportLoc",objLoc.Rowid,objLoc.Descs);
			Common_SetValue("txtCRReportUser",session['LOGON.USERNAME']);
			Common_SetValue("txtCRReportOrgan",HospDesc);
			if(PatientID!=""){
				var objPat=obj.PatientSrv.GetObjById(PatientID);
				Common_SetValue("txtPatientNo",objPat.PapmiNo);
				Common_SetValue("txtPatName",objPat.PatientName);
				Common_SetValue("txtPatSex",objPat.Sex);
				Common_SetValue("txtBirthDay",objPat.Birthday);
				Common_SetValue("txtPatCardNo",objPat.PersonalID);
				Common_SetComboSSDicValue("cboCRMZ","CRMZ","",objPat.Nation);
				//Common_SetValue("txtPatAge",objPat.Age);
				//Common_SetValue("cboPatAgeDW","","岁");
				Common_SetValue("txtJTDH",objPat.Telephone);
				Common_SetValue("txtGZDW",objPat.WorkAddress);
				Common_SetValue("txtAdress1",objPat.Address);
				Common_SetValue("txtAdress2",objPat.Address);
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					Common_SetValue("txtPatAge",objPat.Age);
					Common_SetValue("cboPatAgeDW","","岁");
				}else if(AgeM>0){
					Common_SetValue("txtPatAge",objPat.AgeMonth);
					Common_SetValue("cboPatAgeDW","","月");
				}else {
					Common_SetValue("txtPatAge",objPat.AgeDay);
					Common_SetValue("cboPatAgeDW","","天");
				}
			}
		}else{
			var objRep=obj.ReportCls.GetStringById(obj.ReportID);
			var objZLK=obj.ReportZLKCls.GetStringByParRef(obj.ReportID);
			var objPat=obj.PatientCls.GetStringByParRef(obj.ReportID);
			var arrRep=objRep.split("^");
			var arrZLK=objZLK.split("^");
			var arrPat=objPat.split("^");
			
			Common_SetValue("txtCRKPBH",arrZLK[0]);
			Common_SetValue("txtPatientNo",arrPat[3]);
			Common_SetValue("cboCRBQYGZBR",arrZLK[1].split(CHR_1)[0],arrZLK[1].split(CHR_1)[1]);
			Common_SetValue("txtPatName",arrPat[4]);
			Common_SetValue("txtPatCardNo",arrPat[11]);
			Common_SetValue("txtPatSex",arrPat[6]);
			var patAge="";
			var patAgeDW="";
			if(arrPat[8]!=""){
				patAge=arrPat[8];
				patAgeDW="岁";
			}else if(arrPat[9]!=""){
				patAge=arrPat[9];
				patAgeDW="月";
			}else if(arrPat[10]!=""){
				patAge=arrPat[10];
				patAgeDW="天";
			}
			Common_SetValue("txtPatAge",patAge);
			Common_SetValue("cboPatAgeDW","",patAgeDW);
			Common_SetValue("txtBirthDay",arrPat[7]);
			Common_SetValue("cboCRZY",arrPat[16].split(CHR_1)[0],arrPat[16].split(CHR_1)[1]);
			Common_SetValue("cboCRMZ",arrPat[13].split(CHR_1)[0],arrPat[13].split(CHR_1)[1]);
			Common_SetValue("cboCRGZ",arrPat[17].split(CHR_1)[0],arrPat[17].split(CHR_1)[1]);
			Common_SetValue("txtJTDH",arrPat[12]);
			Common_SetValue("txtGZDW",arrPat[21]);
			Common_SetValue("cboProvince1",arrPat[29].split(CHR_1)[0],arrPat[29].split(CHR_1)[1]);
			Common_SetValue("cboCity1",arrPat[30].split(CHR_1)[0],arrPat[30].split(CHR_1)[1]);
			Common_SetValue("cboCounty1",arrPat[31].split(CHR_1)[0],arrPat[31].split(CHR_1)[1]);
			Common_SetValue("cboVillage1",arrPat[32].split(CHR_1)[0],arrPat[32].split(CHR_1)[1]);
			Common_SetValue("txtCUN1",arrPat[33]);
			Common_SetValue("txtAdress1",arrPat[34]);
			Common_SetValue("cboProvince2",arrPat[23].split(CHR_1)[0],arrPat[23].split(CHR_1)[1]);
			Common_SetValue("cboCity2",arrPat[24].split(CHR_1)[0],arrPat[24].split(CHR_1)[1]);
			Common_SetValue("cboCounty2",arrPat[25].split(CHR_1)[0],arrPat[25].split(CHR_1)[1]);
			Common_SetValue("cboVillage2",arrPat[26].split(CHR_1)[0],arrPat[26].split(CHR_1)[1]);
			Common_SetValue("txtCUN2",arrPat[27]);
			Common_SetValue("txtAdress2",arrPat[28]);

			Common_SetValue("txtCRZDBW",arrZLK[4]);
			Common_SetValue("cboCRZD",arrZLK[2].split(CHR_1)[0],arrZLK[2].split(CHR_1)[1]);
			Common_SetValue("txtCRZDICD",arrZLK[3]);
			Common_SetValue("txtCRBLXLX",arrZLK[6]);
			Common_SetValue("txtCRBLH",arrZLK[7]);
			Common_SetValue("txtCRZDRQ",arrZLK[13]);
			Common_SetValue("cboCRYZD",arrZLK[22].split(CHR_1)[0],arrZLK[22].split(CHR_1)[1]);
			Common_SetValue("txtCRYZDRQ",arrZLK[24]);
			Common_SetValue("cboCRZGZDDW",arrZLK[17].split(CHR_1)[0],arrZLK[17].split(CHR_1)[1]);
			Common_SetValue("txtCRReportOrgan",arrRep[6]);
			Common_SetValue("cboCRReportLoc",arrRep[3],arrRep[4]);
			Common_SetValue("txtCRReportUser",arrRep[5]);
			Common_SetValue("txtCRReportDate",arrRep[7]);
			Common_SetValue("txtCRSWRQ",arrZLK[25]);
			Common_SetValue("txtCRSYICD",arrZLK[28]);
			Common_SetValue("cboCRSWYY",arrZLK[26].split(CHR_1)[0],arrZLK[26].split(CHR_1)[1]);
			Common_SetValue("txtCRBSZY",arrZLK[29]);
			Common_SetValue("cboCRSWZD",arrZLK[30].split(CHR_1)[0],arrZLK[30].split(CHR_1)[1]);
			Common_SetValue("cbgCRZDYJ",arrZLK[15]);
			Common_SetValue("txtCRJTSWYY",arrZLK[27]);
			Common_SetValue("cboCRFHCD",arrZLK[9].split(CHR_1)[0],arrZLK[9].split(CHR_1)[1]);
			Common_SetValue("cboCRTNMFQT",arrZLK[10].split(CHR_1)[0],arrZLK[10].split(CHR_1)[1]);
			Common_SetValue("cboCRTNMFQN",arrZLK[11].split(CHR_1)[0],arrZLK[11].split(CHR_1)[1]);
			Common_SetValue("cboCRTNMFQM",arrZLK[12].split(CHR_1)[0],arrZLK[12].split(CHR_1)[1]);
			
		}
	};
	
	obj.GetRepData = function (step) {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"ZLK";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3删除
		InputStr=InputStr+"^"+Common_GetValue("cboCRReportLoc");
		InputStr=InputStr+"^"+Common_GetValue("txtCRReportUser");
		InputStr=InputStr+"^"+Common_GetValue("txtCRReportOrgan");
		InputStr=InputStr+"^"+Common_GetValue("txtCRReportDate");
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		return InputStr;
	}
	
	obj.GetZLKData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+Common_GetValue("txtCRKPBH");
		InputStr=InputStr+"^"+Common_GetValue("cboCRBQYGZBR");
		InputStr=InputStr+"^"+Common_GetValue("cboCRZD");
		InputStr=InputStr+"^"+Common_GetValue("txtCRZDICD");
		InputStr=InputStr+"^"+Common_GetValue("txtCRZDBW");
		InputStr=InputStr+"^"+Common_GetValue("txtCRBLXLX");
		InputStr=InputStr+"^"+Common_GetValue("txtCRBLH");
		InputStr=InputStr+"^"+Common_GetValue("txtCRZDRQ");
		InputStr=InputStr+"^"+Common_GetValue("cboCRYZD");
		InputStr=InputStr+"^"+Common_GetValue("txtCRYZDRQ");
		InputStr=InputStr+"^"+Common_GetValue("cboCRZGZDDW");
		InputStr=InputStr+"^"+Common_GetValue("txtCRSWRQ");
		InputStr=InputStr+"^"+Common_GetValue("txtCRSYICD");
		InputStr=InputStr+"^"+Common_GetValue("cboCRSWYY");
		InputStr=InputStr+"^"+Common_GetValue("txtCRBSZY");
		InputStr=InputStr+"^"+Common_GetValue("cbgCRZDYJ");
		InputStr=InputStr+"^"+Common_GetValue("txtCRJTSWYY");
		InputStr=InputStr+"^"+Common_GetValue("cboCRTNMFQT");
		InputStr=InputStr+"^"+Common_GetValue("cboCRTNMFQN");
		InputStr=InputStr+"^"+Common_GetValue("cboCRTNMFQM");
		InputStr=InputStr+"^"+Common_GetValue("cboCRFHCD");
		InputStr=InputStr+"^"+Common_GetValue("cboCRSWZD");
		
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+Common_GetValue("txtPatientNo");
		InputStr=InputStr+"^"+Common_GetValue("txtPatName");
		InputStr=InputStr+"^"+Common_GetValue("txtPatCardNo");
		InputStr=InputStr+"^"+Common_GetValue("txtPatSex");
		InputStr=InputStr+"^"+Common_GetValue("txtPatAge");
		InputStr=InputStr+"^"+Common_GetText("cboPatAgeDW");
		InputStr=InputStr+"^"+Common_GetValue("txtBirthDay");
		InputStr=InputStr+"^"+Common_GetValue("cboCRZY");
		InputStr=InputStr+"^"+Common_GetValue("cboCRMZ");
		InputStr=InputStr+"^"+Common_GetValue("cboCRGZ");
		InputStr=InputStr+"^"+Common_GetValue("txtJTDH");
		InputStr=InputStr+"^"+Common_GetValue("txtGZDW");
		InputStr=InputStr+"^"+Common_GetValue("cboProvince1");
		InputStr=InputStr+"^"+Common_GetValue("cboCity1");
		InputStr=InputStr+"^"+Common_GetValue("cboCounty1");
		InputStr=InputStr+"^"+Common_GetValue("cboVillage1");
		InputStr=InputStr+"^"+Common_GetValue("txtCUN1");
		InputStr=InputStr+"^"+Common_GetValue("txtAdress1");
		InputStr=InputStr+"^"+Common_GetValue("cboProvince2");
		InputStr=InputStr+"^"+Common_GetValue("cboCity2");
		InputStr=InputStr+"^"+Common_GetValue("cboCounty2");
		InputStr=InputStr+"^"+Common_GetValue("cboVillage2");
		InputStr=InputStr+"^"+Common_GetValue("txtCUN2");
		InputStr=InputStr+"^"+Common_GetValue("txtAdress2");
		
		return InputStr;
	}
	
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var ZLKData=obj.GetZLKData();
		var PatData=obj.GetPatData();
		
		var ret=obj.RepUpdateCls.SaveRepData(RepData,ZLKData,PatData);
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","数据保存错误!"+ret);
			return;
		}else{
			ExtTool.alert("提示","数据保存成功!");
			obj.ReportID=ret;
			obj.InitRepPowerByStatus(obj.ReportID); //更新操作按钮
		}
	};
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("错误","还未上报!");
			return;
		}
		Ext.MessageBox.confirm("提示","请确认是否删除?",function(btn){
			if(btn=="yes"){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				DeleteStr=DeleteStr+"^"+session['LOGON.USERID'];
				DeleteStr=DeleteStr+"^"+session['LOGON.CTLOCID'];
				DeleteStr=DeleteStr+"^"+"DELETE";
				var ret=obj.ReportCls.DeleteReport(DeleteStr,"^");
				if(parseInt(ret)<=0){
					ExtTool.alert("错误","删除失败!"+ret);
					return;
				}else{
					ExtTool.alert("提示","报告删除成功!");
					obj.InitRepPowerByStatus(obj.ReportID); //更新操作按钮
				}
			}
		});
	};
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("错误","请先做【上报】操作");
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];
		var ret=obj.ReportCls.CheckReport(CheckStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","报告审核失败!"+ret);
			return;
		}else{
			ExtTool.alert("提示","报告审核成功!");
			obj.InitRepPowerByStatus(obj.ReportID); //更新操作按钮
		}
	};
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("错误","请先做【上报】操作");
			return;
		}
		var ExportStr=obj.ReportID;
		ExportStr=ExportStr+"^"+session['LOGON.USERID'];
		ExportStr=ExportStr+"^"+session['LOGON.CTLOCID'];
		ExportStr=ExportStr+"^"+"EXPORT";
		var ret=obj.ReportCls.ExportReport(ExportStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","报告导出失败!"+ret);
			return;
		}else{
			var cArguments=obj.ReportID;
			var flg=ExportDataToExcel("","","肿瘤报告卡("+Common_GetValue("txtPatName")+")",cArguments);
		}
	};
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("错误","请先做【上报】操作");
			return;
		}
		var PrintStr=obj.ReportID;
		PrintStr=PrintStr+"^"+session['LOGON.USERID'];
		PrintStr=PrintStr+"^"+session['LOGON.CTLOCID'];
		PrintStr=PrintStr+"^"+"PRINT";
		var ret=obj.ReportCls.ExportReport(PrintStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","报告打印失败!"+ret);
			return;
		}else{
			var cArguments=obj.ReportID;
			var flg=PrintDataToExcel("","","肿瘤报告卡("+Common_GetValue("txtPatName")+")",cArguments);
		}
	};
	obj.btnCancle_click = function(){
		window.close();
	};
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		
		errStr += obj.ValidateControl(obj.txtPatientNo);		//登记号
		errStr += obj.ValidateControl(obj.cboCRBQYGZBR);		//
		errStr += obj.ValidateControl(obj.txtPatName);		//病人姓名
		errStr += obj.ValidateControl(obj.txtPatSex);			//性别
		errStr += obj.ValidateControl(obj.txtPatAge);			//年龄
		errStr += obj.ValidateControl(obj.txtBirthDay);		//出生日期
		errStr += obj.ValidateControl(obj.cboCRMZ);
		errStr += obj.ValidateControl(obj.cboCRZY);	//职业
		errStr += obj.ValidateControl(obj.cboCRGZ);			//具体工种
		errStr += obj.ValidateControl(obj.txtJTDH);		//电话
		errStr += obj.ValidateControl(obj.txtPatCardNo);		//电话
		errStr += obj.ValidateControl(obj.cboProvince1);	//居住地-省
		errStr += obj.ValidateControl(obj.cboCity1);		//市
		errStr += obj.ValidateControl(obj.cboCounty1);	//县
		errStr += obj.ValidateControl(obj.cboVillage1);	//街道
		errStr += obj.ValidateControl(obj.txtCUN1);		//村
		errStr += obj.ValidateControl(obj.txtAdress1);	//详细地址
		errStr += obj.ValidateControl(obj.cboProvince2);	//户口地-省
		errStr += obj.ValidateControl(obj.cboCity2);		//市
		errStr += obj.ValidateControl(obj.cboCounty2);	//县
		errStr += obj.ValidateControl(obj.cboVillage2);	//街道
		errStr += obj.ValidateControl(obj.txtCUN2);		//村
		errStr += obj.ValidateControl(obj.txtAdress2);	//详细地址
		errStr += obj.ValidateControl(obj.txtCRZDICD);			//ICD编码
		errStr += obj.ValidateControl(obj.cboCRZGZDDW);			
		errStr += obj.ValidateControl(obj.cboCRZD);			
		errStr += obj.ValidateControl(obj.cbgCRZDYJ);		
		errStr += obj.ValidateControl(obj.txtCRZDBW);			
		errStr += obj.ValidateControl(obj.txtCRReportOrgan);		
		errStr += obj.ValidateControl(obj.txtCRZDRQ);
		
		//add by mxp 20160405 fix bug 192194 诊断日期不能大于当前日期,原诊断日期不为空时不能大于诊断诊断日期
		//var NowDate = new Date().format("Y-m-d");
		if (obj.txtCRZDRQ.getRawValue()!=""){
			if (Common_ComputeDays("txtCRZDRQ")<0) {
				errStr += '诊断日期不能大于当前日期!';
			}
			if (obj.txtCRYZDRQ.getRawValue()!="") {
				if (Common_ComputeDays("txtCRYZDRQ","txtCRZDRQ")<0) {
					errStr += '原诊断日期不能大于诊断日期!';
				}
			}
		}
		
		if (obj.txtCRSWRQ.getRawValue()!=""){
			//fix bug 194476 死亡原因、死亡诊断、死亡具体原因 提示明确信息
			//if((obj.cboCRSWZD.getValue()=="")||(obj.cboCRSWYY.getValue()=="")||(obj.txtCRJTSWYY.getValue()==""))
			//	errStr += "死亡原因、死亡诊断、死亡具体原因必填!"
			errStr += obj.ValidateControl(obj.cboCRSWZD);		
			errStr += obj.ValidateControl(obj.cboCRSWYY);	
			errStr += obj.ValidateControl(obj.txtCRJTSWYY);
			if (Common_ComputeDays("txtCRZDRQ","txtCRSWRQ")<0){
				errStr += "死亡日期必须大于诊断日期！"
			}
			//add by mxp 20160405 fix bug 191734 死亡日期不能大于当前日期
			if (Common_ComputeDays("txtCRSWRQ")<0) {
				errStr += '死亡日期不允许大于当前日期!';
			}
		}
	var ZDYJs=Common_GetValue("cbgCRZDYJ");
	if((ZDYJs.indexOf("1148")>=0)||(ZDYJs.indexOf("1149")>=0)||(ZDYJs.indexOf("1150")>=0)){
		if((Common_GetValue("txtCRBLXLX")=="")||(Common_GetValue("txtCRBLH")=="")){
			errStr += "病理学类型和病理号不能为空！"
		}
	}
		if(errStr != "")
		{
			ExtTool.alert("提示", errStr, Ext.MessageBox.INFO);
			return false;
		}
		return true;
	}
	obj.ValidateControl = function(objCtl){
		var errStr = "";
		if((objCtl.getValue() == "") || (!objCtl.isValid(false)))
			errStr = "<P>“" + objCtl.initialConfig.fieldLabel + "”不能为空！</P>";
		return errStr;
	}
}	