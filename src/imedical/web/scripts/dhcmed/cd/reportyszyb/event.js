function InitViewPortEvent(obj) {
	obj.PatientCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportPAT");
	obj.ReportYSZYBCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportYSZYB");
	obj.ReportCls=ExtTool.StaticServerObject("DHCMed.CD.CRReport");
	obj.ReportSrv=ExtTool.StaticServerObject("DHCMed.CDService.Service");
	obj.RepUpdateCls=ExtTool.StaticServerObject("DHCMed.CDService.UpdateService");
	obj.CtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
	obj.PatientSrv = ExtTool.StaticServerObject("DHCMed.Base.Patient")
	obj.ReportBZQTCls = ExtTool.StaticServerObject("DHCMed.CD.CRReportBZQT")
	obj.LoadEvent = function(args)
    {
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCheck.on("click",obj.btnCheck_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnCancle.on("click",obj.btnCancle_click,obj);
		
		obj.cboProvince1.on('expand',obj.cboProvince1_expand,obj);
		obj.cboCity1.on('expand',obj.cboCity1_expand,obj);
		obj.cboCounty1.on('expand',obj.cboCounty1_expand,obj);
		obj.cboVillage1.on('expand',obj.cboVillage1_expand,obj);
		obj.cboProvince1.on('select',obj.cboProvince1_Select,obj);
		obj.cboCity1.on('select',obj.cboCity1_Select,obj);
		obj.cboCounty1.on('select',obj.cboCounty1_Select,obj);
		obj.cboVillage1.on('select',obj.cboVillage1_Select,obj);
		
		Common_SetDisabled("txtCRKPBH",true);
		Common_SetDisabled("txtReportDate",true);
		Common_SetDisabled("txtReportUser",true);
		
		Common_SetDisabled("txtPatName",true);
		Common_SetDisabled("txtPatSex",true);
		//Common_SetDisabled("txtPatCardNo",true);
		Common_SetDisabled("txtPatAge",true);
		Common_SetDisabled("cboPatAgeDW",true);
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);
  	};
	
	
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
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			Common_SetValue("txtReportUser",session['LOGON.USERNAME']);
			Common_SetValue("txtReportOrgan",HospDesc);
			if(PatientID!=""){
				var objPat=obj.PatientSrv.GetObjById(PatientID);
				Common_SetValue("txtPatName",objPat.PatientName);
				Common_SetValue("txtPatSex",objPat.Sex);
				Common_SetValue("txtPatCardNo",objPat.PersonalID);
				Common_SetValue("txtLXDH",objPat.Telephone);
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
			var objYSZYB=obj.ReportYSZYBCls.GetStringByParRef(obj.ReportID);
			var objPat=obj.PatientCls.GetStringByParRef(obj.ReportID);
			var arrRep=objRep.split("^");
			var arrYSZYB=objYSZYB.split("^");
			var arrPat=objPat.split("^");
			Common_SetValue("txtCRKPBH",arrYSZYB[0]);
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
			}else{
				patAge=arrPat[10];
				patAgeDW="天";
			}
			Common_SetValue("txtPatAge",patAge);
			Common_SetValue("cboPatAgeDW","",patAgeDW);
			Common_SetValue("txtLXDH",arrPat[20]);
			Common_SetValue("cboCRZY",arrPat[16].split(CHR_1)[0],arrPat[16].split(CHR_1)[1]);
			Common_SetValue("cboProvince1",arrPat[29].split(CHR_1)[0],arrPat[29].split(CHR_1)[1]);
			Common_SetValue("cboCity1",arrPat[30].split(CHR_1)[0],arrPat[30].split(CHR_1)[1]);
			Common_SetValue("cboCounty1",arrPat[31].split(CHR_1)[0],arrPat[31].split(CHR_1)[1]);
			Common_SetValue("cboVillage1",arrPat[32].split(CHR_1)[0],arrPat[32].split(CHR_1)[1]);
			Common_SetValue("txtCUN1",arrPat[33]);
			Common_SetValue("txtAdress1",arrPat[34]);
			
			Common_SetValue("txtYRDWMC",arrYSZYB[1]);
			Common_SetValue("txtYRDWDZ",arrYSZYB[2]);
			Common_SetValue("txtYRDWYB",arrYSZYB[3]);
			Common_SetValue("txtYRDWLXR",arrYSZYB[4]);
			Common_SetValue("txtYRDWLXRDH",arrYSZYB[5]);
			Common_SetValue("txtJJLX",arrYSZYB[6]);
			Common_SetValue("txtDWHY",arrYSZYB[7]);
			Common_SetValue("cbgQYGM",arrYSZYB[8].split(CHR_1)[0],arrYSZYB[8].split(CHR_1)[1]);
			Common_SetValue("cbgBRLY",arrYSZYB[9].split(CHR_1)[0],arrYSZYB[9].split(CHR_1)[1]);
			Common_SetValue("txtZYBZL",arrYSZYB[10]);
			Common_SetValue("txtJTBM",arrYSZYB[11]);
			Common_SetValue("txtZDSGBM",arrYSZYB[12]);
			Common_SetValue("txtTSZDRS",arrYSZYB[13]);
			Common_SetValue("cbgTJGZ",arrYSZYB[14].split(CHR_1)[0],arrYSZYB[14].split(CHR_1)[1]);
			Common_SetValue("txtZYGLN",arrYSZYB[15]);
			Common_SetValue("txtZYGLY",arrYSZYB[16]);
			Common_SetValue("txtJCSJT",arrYSZYB[17]);
			Common_SetValue("txtJCSJS",arrYSZYB[18]);
			Common_SetValue("txtJCSJF",arrYSZYB[19]);
			Common_SetValue("txtFSRQ",arrYSZYB[20]);
			Common_SetValue("txtZDRQ",arrYSZYB[21]);
			Common_SetValue("txtSWRQ",arrYSZYB[22]);
			
			Common_SetValue("txtReportUser",arrRep[5]);
			Common_SetValue("txtReportOrgan",arrRep[6]);
			Common_SetValue("txtReportDate",arrRep[7]);
		}
	};
	
	obj.GetRepData = function (step) {
		var RepLoc = "";
		if (obj.ReportID!="") {
			var objRep=obj.ReportCls.GetObjById(obj.ReportID);
			RepLoc = objRep.CRReportLoc;
		}
		else{
			RepLoc = session['LOGON.CTLOCID'];
		}
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"YSZYB";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3删除
		InputStr=InputStr+"^"+RepLoc; //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+Common_GetValue("txtReportUser");
		InputStr=InputStr+"^"+Common_GetValue("txtReportOrgan");
		InputStr=InputStr+"^"+Common_GetValue("txtReportDate");
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		return InputStr;
	}
	
	obj.GetYSZYBData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+Common_GetValue("txtCRKPBH");
		InputStr=InputStr+"^"+Common_GetValue("txtYRDWMC");
		InputStr=InputStr+"^"+Common_GetValue("txtYRDWDZ");
		InputStr=InputStr+"^"+Common_GetValue("txtYRDWYB");
		InputStr=InputStr+"^"+Common_GetValue("txtYRDWLXR");
		InputStr=InputStr+"^"+Common_GetValue("txtYRDWLXRDH");
		InputStr=InputStr+"^"+Common_GetValue("txtJJLX");
		InputStr=InputStr+"^"+Common_GetValue("txtDWHY");
		InputStr=InputStr+"^"+Common_GetValue("cbgQYGM");
		InputStr=InputStr+"^"+Common_GetValue("cbgBRLY");
		InputStr=InputStr+"^"+Common_GetValue("txtZYBZL");
		InputStr=InputStr+"^"+Common_GetValue("txtJTBM");
		InputStr=InputStr+"^"+Common_GetValue("txtZDSGBM");
		InputStr=InputStr+"^"+Common_GetValue("txtTSZDRS");
		InputStr=InputStr+"^"+Common_GetValue("cbgTJGZ");
		InputStr=InputStr+"^"+Common_GetValue("txtZYGLN");
		InputStr=InputStr+"^"+Common_GetValue("txtZYGLY");
		InputStr=InputStr+"^"+Common_GetValue("txtJCSJT");
		InputStr=InputStr+"^"+Common_GetValue("txtJCSJS");
		InputStr=InputStr+"^"+Common_GetValue("txtJCSJF");
		InputStr=InputStr+"^"+Common_GetValue("txtFSRQ");
		InputStr=InputStr+"^"+Common_GetValue("txtZDRQ");
		InputStr=InputStr+"^"+Common_GetValue("txtSWRQ");
		
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+Common_GetValue("txtPatName");
		InputStr=InputStr+"^"+Common_GetValue("txtPatCardNo");
		InputStr=InputStr+"^"+Common_GetValue("txtPatSex");
		InputStr=InputStr+"^"+Common_GetValue("txtPatAge");
		InputStr=InputStr+"^"+Common_GetText("cboPatAgeDW");  //7
		InputStr=InputStr+"^"+Common_GetValue("txtLXDH");
		InputStr=InputStr+"^"+"";
		InputStr=InputStr+"^"+"";  //10
		InputStr=InputStr+"^"+Common_GetValue("cboCRZY");
		InputStr=InputStr+"^"+Common_GetValue("cboProvince1");
		InputStr=InputStr+"^"+Common_GetValue("cboCity1");   //13
		InputStr=InputStr+"^"+Common_GetValue("cboCounty1");
		InputStr=InputStr+"^"+Common_GetValue("cboVillage1");
		InputStr=InputStr+"^"+Common_GetValue("txtCUN1");    //16
		InputStr=InputStr+"^"+Common_GetValue("txtAdress1");
		
		return InputStr;
	}
	
	
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var YSZYBData=obj.GetYSZYBData();
		var PatData=obj.GetPatData();
		var ret=obj.RepUpdateCls.SaveRepData(RepData,YSZYBData,PatData);
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
			var flg=ExportDataToExcel("","","疑似职业病报告卡("+Common_GetValue("txtPatName")+")",cArguments);
		}
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
		if (tDHCMedMenuOper['Print']!=1) {
			Common_SetVisible("btnPrint",false);
			Common_SetVisible("btnExport",false);
		}
	}
	
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
			var flg=PrintDataToExcel("","","疑似职业病报告卡("+Common_GetValue("txtPatName")+")",cArguments);
		}
	};
	obj.btnCancle_click = function(){
		window.close();
	};
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		
		errStr += obj.ValidateControl(obj.txtPatName);		//病人姓名
		errStr += obj.ValidateControl(obj.txtPatSex);			//性别
		errStr += obj.ValidateControl(obj.txtPatAge);			//年龄
		errStr += obj.ValidateControl(obj.txtLXDH);		//电话
		errStr += obj.ValidateControl(obj.txtPatCardNo);		//身份证号
		errStr += obj.ValidateControl(obj.cboCRZY);	//职业
		errStr += obj.ValidateControl(obj.cboProvince1);	//居住地-省
		errStr += obj.ValidateControl(obj.cboCity1);		//市
		errStr += obj.ValidateControl(obj.cboCounty1);	//县
		errStr += obj.ValidateControl(obj.cboVillage1);	//街道
		errStr += obj.ValidateControl(obj.txtCUN1);		//村
		errStr += obj.ValidateControl(obj.txtAdress1);	//详细地址
		
		errStr += obj.ValidateControl(obj.txtYRDWMC);	//用人单位名称
		errStr += obj.ValidateControl(obj.txtYRDWDZ);	//用人单位地址
		//errStr += obj.ValidateControl(obj.txtYRDWYB);	//用人单位邮编
		errStr += obj.ValidateControl(obj.txtYRDWLXR);	//用人单位联系人
		errStr += obj.ValidateControl(obj.txtYRDWLXRDH);	//联系人电话
		errStr += obj.ValidateControl(obj.txtJJLX);		//经济类型
		errStr += obj.ValidateControl(obj.txtDWHY);		//行业
		errStr += obj.ValidateControl(obj.cbgQYGM);		//企业规模
		errStr += obj.ValidateControl(obj.cbgBRLY);		//病人来源
		errStr += obj.ValidateControl(obj.txtZYBZL);	//职业病种类
		errStr += obj.ValidateControl(obj.txtJTBM);		//具体病名
		errStr += obj.ValidateControl(obj.txtZDSGBM);	//中毒事故编码
		errStr += obj.ValidateControl(obj.txtTSZDRS);	//同时中毒人数
		errStr += obj.ValidateControl(obj.cbgTJGZ);		//统计工种
		//errStr += obj.ValidateControl(obj.txtZYGLN);	//专业工龄年
		//errStr += obj.ValidateControl(obj.txtZYGLY);	//专业工龄月
		//errStr += obj.ValidateControl(obj.txtJCSJT);	//接触时间天
		//errStr += obj.ValidateControl(obj.txtJCSJS);	//接触时间时
		//errStr += obj.ValidateControl(obj.txtJCSJF);	//接触时间分
	 	errStr += obj.ValidateControl(obj.txtFSRQ);		//发生日期
		errStr += obj.ValidateControl(obj.txtZDRQ);		//诊断日期
		
		//var NowDate = new Date().format("Y-m-d");
		var txtFSRQ=obj.txtFSRQ.getRawValue();
		if ((txtFSRQ!="")&&(Common_ComputeDays("txtFSRQ")<0)) {
			errStr += '发生日期不能大于当前日期!<br>';
		}					
		if ((obj.txtZDRQ.getRawValue()!="")&&(Common_ComputeDays("txtZDRQ")<0)) {
			errStr += '诊断日期不能大于当前日期!<br>';
		}
		
		if ((obj.txtSWRQ.getRawValue()!="")&&(Common_ComputeDays("txtSWRQ")<0)) {
			errStr += '死亡日期不能大于当前日期!<br>';
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