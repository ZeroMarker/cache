function InitViewPortEvent(obj) {
	obj.PatientCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportPAT");
	obj.ReportFZYCOCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportFZYCO");
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
				//fix bug 191989 by maxp新建报告时显示年龄
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
			var objFZYCO=obj.ReportFZYCOCls.GetStringByParRef(obj.ReportID);
			var objPat=obj.PatientCls.GetStringByParRef(obj.ReportID);
			var arrRep=objRep.split("^");
			var arrFZYCO=objFZYCO.split("^");
			var arrPat=objPat.split("^");
			Common_SetValue("txtCRKPBH",arrFZYCO[0]);
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
			
			Common_SetValue("txtCOZDRQ",arrFZYCO[1]);
			Common_SetValue("txtCOZDSJ",arrFZYCO[2]);
			Common_SetValue("cbgZDYY",arrFZYCO[3].split(CHR_1)[0],arrFZYCO[3].split(CHR_1)[1]);
			Common_SetValue("cbgZDCS",arrFZYCO[4].split(CHR_1)[0],arrFZYCO[4].split(CHR_1)[1]);
			Common_SetValue("cbgZDYS",arrFZYCO[5].split(CHR_1)[0],arrFZYCO[5].split(CHR_1)[1]);
			Common_SetValue("cbgZYZZ",arrFZYCO[6]);
			Common_SetValue("cbgZDZD",arrFZYCO[7].split(CHR_1)[0],arrFZYCO[7].split(CHR_1)[1]);
			Common_SetValue("cbgJZCS",arrFZYCO[8].split(CHR_1)[0],arrFZYCO[8].split(CHR_1)[1]);
			Common_SetValue("cbgCOZG",arrFZYCO[9].split(CHR_1)[0],arrFZYCO[9].split(CHR_1)[1]);
			Common_SetValue("txtZDQR",arrFZYCO[10]);
			Common_SetValue("txtSWRQ",arrFZYCO[11]);
			
			Common_SetValue("txtCRQTZY",obj.ReportBZQTCls.GetByPaCode(obj.ReportID,"CRQTZY"));
			Common_SetValue("txtCRQTZZ",obj.ReportBZQTCls.GetByPaCode(obj.ReportID,"CRQTZZ"));
			
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
		InputStr=InputStr+"^"+"FZYCO";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3删除
		InputStr=InputStr+"^"+RepLoc; //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+Common_GetValue("txtReportUser");
		InputStr=InputStr+"^"+Common_GetValue("txtReportOrgan");
		InputStr=InputStr+"^"+Common_GetValue("txtReportDate");
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		return InputStr;
	}
	
	obj.GetFZYCOData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+Common_GetValue("txtCRKPBH");
		InputStr=InputStr+"^"+Common_GetValue("txtCOZDRQ");
		InputStr=InputStr+"^"+Common_GetValue("txtCOZDSJ");
		InputStr=InputStr+"^"+Common_GetValue("cbgZDYY");
		InputStr=InputStr+"^"+Common_GetValue("cbgZDCS");
		InputStr=InputStr+"^"+Common_GetValue("cbgZDYS");
		InputStr=InputStr+"^"+Common_GetValue("cbgZYZZ");
		InputStr=InputStr+"^"+Common_GetValue("cbgZDZD");
		InputStr=InputStr+"^"+Common_GetValue("cbgJZCS");
		InputStr=InputStr+"^"+Common_GetValue("cbgCOZG");
		InputStr=InputStr+"^"+Common_GetValue("txtZDQR");
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
	
	
	obj.GetExtraData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+"CRQTZY"+CHR_1+"其他职业"+CHR_1+Common_GetValue("txtCRQTZY");
		InputStr=InputStr+"^"+"CRQTZZ"+CHR_1+"其他症状"+CHR_1+Common_GetValue("txtCRQTZZ");
		
		return InputStr;
	}
	
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var FZYCOData=obj.GetFZYCOData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
		var ret=obj.RepUpdateCls.SaveRepData(RepData,FZYCOData,PatData,ExtraData);
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","数据保存错误!"+ret);
			return;
		}else{
			ExtTool.alert("提示","数据保存成功!");
			obj.ReportID=ret;
			obj.InitRepPowerByStatus(obj.ReportID);
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
					obj.InitRepPowerByStatus(obj.ReportID);
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
			obj.InitRepPowerByStatus(obj.ReportID);
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
			var flg=ExportDataToExcel("","","CO中毒报告卡("+Common_GetValue("txtPatName")+")",cArguments);
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
			var flg=PrintDataToExcel("","","CO中毒报告卡("+Common_GetValue("txtPatName")+")",cArguments);
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
		//errStr += obj.ValidateControl(obj.cboCRZY);	//职业
		if ((Common_GetValue("cboCRZY")=="")&&(Common_GetValue("txtCRQTZY")==""))
			errStr += "'职业'不能为空'<br>";	//职业
		errStr += obj.ValidateControl(obj.cboProvince1);	//居住地-省
		errStr += obj.ValidateControl(obj.cboCity1);		//市
		errStr += obj.ValidateControl(obj.cboCounty1);	//县
		errStr += obj.ValidateControl(obj.cboVillage1);	//街道
		errStr += obj.ValidateControl(obj.txtCUN1);		//村
		errStr += obj.ValidateControl(obj.txtAdress1);	//详细地址
		
		errStr += obj.ValidateControl(obj.txtCOZDRQ);	//中毒日期
		//errStr += obj.ValidateControl(obj.txtCOZDSJ);	//中毒时间
		if (Common_GetValue("txtCOZDSJ")=="")
			errStr = "<P>“中毒时间”不能为空！</P>";
		errStr += obj.ValidateControl(obj.cbgZDYY);		//中毒原因		
		errStr += obj.ValidateControl(obj.cbgZDYS);		//中毒因素	
		errStr += obj.ValidateControl(obj.cbgZYZZ);		//主要症状
		errStr += obj.ValidateControl(obj.cbgZDCS);		//中毒场所
		errStr += obj.ValidateControl(obj.cbgZDZD);		//中毒诊断
		errStr += obj.ValidateControl(obj.cbgJZCS);		//救治措施
		errStr += obj.ValidateControl(obj.cbgCOZG);		//转归	
		errStr += obj.ValidateControl(obj.txtZDQR);		//诊断日期	
		
		//var NowDate = new Date().format("Y-m-d");
		var txtCOZDRQ=obj.txtCOZDRQ.getRawValue();
		if ((txtCOZDRQ!="")&&(Common_ComputeDays("txtCOZDRQ")<0)) {
			errStr += '中毒日期不能大于当前日期!<br>';
		}					
		if ((obj.txtZDQR.getRawValue()!="")&&(Common_ComputeDays("txtZDQR")<0)) {
			errStr += '诊断日期不能大于当前日期!<br>';
		}
		if ((Common_GetText("cbgCOZG")!='死亡')&&(obj.txtSWRQ.getRawValue()!="")){
			errStr += '填写了死亡日期，请确认病人转归!<br>';
		}
		if (Common_GetText("cbgCOZG")=='死亡') {
			errStr += obj.ValidateControl(obj.txtSWRQ);	//死亡日期
			if ((obj.txtSWRQ.getRawValue()!="")&&(Common_ComputeDays("txtSWRQ")<0)) {
				errStr += '死亡日期不能大于当前日期!<br>';
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
