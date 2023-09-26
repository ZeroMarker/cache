function InitDthChildEvent(obj)
{
	obj.LoadEvent = function(){
	
		obj.btnSave.on("click", obj.btnSave_onclick, obj);
		obj.btnTMP.on("click", obj.btnTMP_onclick, obj);
		obj.btnDelete.on("click", obj.btnDelete_onclick, obj);
		obj.btnCheck.on("click", obj.btnCheck_onclick, obj);
		obj.btnReturn.on("click", obj.btnReturn_onclick, obj);
		obj.btnPrint.on("click", obj.btnPrint_onclick, obj);
		obj.btnCancel.on("click", obj.btnCancel_onclick, obj);
	
		if((reportId == "") && (dthReportID == ""))
		{
			ExtTool.alert("提示", "无法读取医学死亡证明书信息，请检查参数！", Ext.MessageBox.ERROR);
			return;
		}
		obj.DisplayReport(reportId, dthReportID);
	}
	
	obj.DisplayReport = function(ReportID,DthReportID)
	{
	
		var delimiter = "^";
		var ret = ExtTool.RunServerMethod("DHCMed.DTHService.ReportChildSrv", "GetReportString", ReportID, DthReportID);
		var strSections = ret.split(CHR_1);
		var strFields = strSections[0].split(delimiter);
		Common_SetValue("txtDTHNo", strFields[33]);
		// 是否补卡
		Common_SetValue("chkIsReplenish", (strFields[34] == "1"));
		// 姓名
		Common_SetValue("txtName",strFields[4]);
		// 父亲姓名
		Common_SetValue("txtFatherName",strFields[5]);
		// 母亲姓名
		Common_SetValue("txtMotherName",strFields[6]);
		//  联系电话
		Common_SetValue("txtFamTel",strFields[7]);
		// 性别 1--男 2--女 3--性别不明
		var objDic = strFields[8].split(CHR_2);
		Common_SetValue("cboSex", objDic[0], objDic[2]);
		// 出生日期
		Common_SetValue("txtBirthday",strFields[9]);;
		// 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
		var objDic = strFields[10].split(CHR_2);
		Common_SetValue("cboRegType", objDic[0], objDic[2]);
		// 出生体重
		Common_SetValue("txtWeight",strFields[11]);
		// 出生体重类别：1--测量 2--估计
		var objDic = strFields[12].split(CHR_2);
		Common_SetValue("cboWeightType", objDic[0], objDic[2]);
		// 怀孕___周
		Common_SetValue("txtPregnancyWeek",strFields[13]);
		// 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
		var objDic = strFields[14].split(CHR_2);
		Common_SetValue("cboBirthdayPlace", objDic[0], objDic[2]);
		// 死亡日期
		Common_SetValue("dtDeathDate",strFields[15]);;
		// 死亡年龄 年
		Common_SetValue("txtDeathAgeYear",strFields[16]);
		// 死亡年龄 月
		Common_SetValue("txtDeathAgeMonth",strFields[17]);
		// 死亡年龄 日
		Common_SetValue("txtDeathAgeDay",strFields[18]);
		Common_SetValue("txtDeathAgeHour",strFields[35]);
		// 死亡地点 1--医院 2--途中 3--家中
		var objDic = strFields[19].split(CHR_2);
		Common_SetValue("cboDeathPosition",objDic[0], objDic[2]);
		// 死亡前治疗 1--住院 2--门诊 3--未治疗
		var objDic = strFields[20].split(CHR_2);
		Common_SetValue("cboCareBeforeDeath",objDic[0], objDic[2]);
		// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
		var objDic = strFields[21].split(CHR_2);
		Common_SetValue("cboDiagnoseLv",objDic[0], objDic[2]);
		// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
		var objDic = strFields[22].split(CHR_2);
		Common_SetValue("cboNotCareReason",objDic[0], objDic[2]);
		// 未治疗或未就医主要原因（需要注明原因）
		Common_SetValue("txtNotCareReasonTxt",strFields[23]);
		// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
		var objDic = strFields[24].split(CHR_2);
		Common_SetValue("cboDiagnoseBasis",objDic[0], objDic[2]);
		// 分类编号 01-痢疾 02--败血症 03-麻疹 ...
		var objDic = strFields[25].split(CHR_2);
		Common_SetValue("cboCategory",objDic[0], objDic[2]);
		// ICD-10编码
		Common_SetValue("txtICD10",strFields[26]);	
		
		// 显示状态
		var objDic = strFields[32].split(CHR_2);
		Common_SetValue("lblStatus",objDic[2]);	
		if((objDic[1] == "5")||(objDic[1] == "4"))
		{
			Common_SetValue("lblStatus",objDic[2] + "，原因：" + strFields[36]);
		}
		obj.SetPower(objDic[1]); //设置按钮状态
	}

	//设置按钮状态
	obj.SetPower = function(StatusCode)
	{
		obj.txtDTHNo.disable();
		obj.dtDeathDate.disable();
		obj.txtBirthday.disable();
		obj.btnTMP.setVisible(false);
		obj.btnSave.setVisible(false);
		obj.btnDelete.setVisible(false);
		obj.btnCheck.setVisible(false);
		obj.btnReturn.setVisible(false);
		obj.btnPrint.setVisible(false);
		
		switch(StatusCode)
		{
			case "":
				obj.btnTMP.setVisible(true);
				obj.btnSave.setVisible(true);
				if(tDHCMedMenuOper['Report'] != 1){
					obj.btnTMP.setVisible(false);
					obj.btnSave.setVisible(false);
				}
				break;
			case "1": //保存
				obj.btnSave.setVisible(true);
				obj.btnDelete.setVisible(true);
				obj.btnCheck.setVisible(true);
				obj.btnReturn.setVisible(true);
				obj.btnPrint.setVisible(true);
				if(tDHCMedMenuOper['Report'] != 1){
					obj.btnTMP.setVisible(false);
					obj.btnSave.setVisible(false);
				}
				if(tDHCMedMenuOper['Check'] != 1){
					obj.btnCheck.setVisible(false);
				}
				if(tDHCMedMenuOper['Back'] != 1){
					obj.btnReturn.setVisible(false);
				}
				if(tDHCMedMenuOper['Print'] != 1)	{
					obj.btnPrint.setVisible(false);
				}
				break;
			case "4": //退回
				obj.btnSave.setVisible(true);
				obj.btnDelete.setVisible(true);
				if(tDHCMedMenuOper['Report'] != 1){
					obj.btnSave.setVisible(false);
					obj.btnDelete.setVisible(false);
				}
				break;
			case "2": //审核
				obj.btnPrint.setVisible(true);
				if(tDHCMedMenuOper['Print'] != 1)	{
					obj.btnPrint.setVisible(false);
				}
				break;
			case "3": //草稿
				obj.btnTMP.setVisible(true);
				obj.btnSave.setVisible(true);
				obj.btnDelete.setVisible(true);
				if(tDHCMedMenuOper['Report'] != 1){
					obj.btnSave.setVisible(false);
					obj.btnDelete.setVisible(false);
				}			
				break;
			case "5": //删除
				break;		
			default:
				break;
		}
	}
	
	obj.SaveReport = function(StatusCode){
		var objRepStatus = ExtTool.RunServerMethod("DHCMed.SS.Dictionary", "GetByTypeCode", "DTCReportType", StatusCode, "1");
		var delimiter = "^";
		var strArg = reportId + delimiter;
		strArg += patientId +delimiter;
		strArg += EpisodeID +delimiter;
		strArg += dthReportID +delimiter;
		// 姓名
		strArg += Common_GetValue("txtName") + delimiter;
		// 父亲姓名
		strArg += Common_GetValue("txtFatherName") + delimiter;
		// 母亲姓名
		strArg += Common_GetValue("txtMotherName") + delimiter;
		//  联系电话
		strArg += Common_GetValue("txtFamTel") + delimiter;
		// 性别 1--男 2--女 3--性别不明
		strArg += Common_GetValue("cboSex") + delimiter;
		// 出生日期
		strArg += Common_GetValue("txtBirthday") + delimiter;
		// 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
		strArg += Common_GetValue("cboRegType") + delimiter;
		// 出生体重
		strArg += Common_GetValue("txtWeight") + delimiter;
		// 出生体重类别：1--测量 2--估计
		strArg += Common_GetValue("cboWeightType") + delimiter;
		// 怀孕___周
		strArg += Common_GetValue("txtPregnancyWeek") + delimiter;
		// 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
		strArg += Common_GetValue("cboBirthdayPlace") + delimiter;
		// 死亡日期
		strArg += Common_GetValue("dtDeathDate") + delimiter;
		// 死亡年龄 年
		strArg += Common_GetValue("txtDeathAgeYear") + delimiter;
		// 死亡年龄 月
		strArg += Common_GetValue("txtDeathAgeMonth") + delimiter;
		// 死亡年龄 日
		strArg += Common_GetValue("txtDeathAgeDay") + delimiter;
		// 死亡地点 1--医院 2--途中 3--家中
		strArg += Common_GetValue("cboDeathPosition") + delimiter;
		// 死亡前治疗 1--住院 2--门诊 3--未治疗
		strArg += Common_GetValue("cboCareBeforeDeath") + delimiter;
		// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
		strArg += Common_GetValue("cboDiagnoseLv") + delimiter;
		// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
		strArg += Common_GetValue("cboNotCareReason") + delimiter;
		// 未治疗或未就医主要原因（需要注明原因）
		strArg += Common_GetValue("txtNotCareReasonTxt") + delimiter;
		// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
		strArg += Common_GetValue("cboDiagnoseBasis") + delimiter;
		// 分类编号 01-痢疾 02--败血症 03-麻疹 ...
		strArg += Common_GetValue("cboCategory") + delimiter;
		// ICD-10编码
		strArg += Common_GetValue("txtICD10") + delimiter;
		strArg += UserId + delimiter;
		strArg += RepLocDR + delimiter;
		strArg += UserId + delimiter;
		strArg += "RepDate" + delimiter;
		strArg += "RepTime" + delimiter;
		strArg += objRepStatus.RowID + delimiter;
		// 编号
		strArg += Common_GetValue("txtDTHNo") + delimiter;
		// 是否补卡
		strArg += (Common_GetValue("chkIsReplenish") ? 1 : 0) + delimiter;
		// 死亡年龄  时
		strArg += Common_GetValue("txtDeathAgeHour") + delimiter;
		var ret = ExtTool.RunServerMethod("DHCMed.DTH.ChildReport", "Update", strArg, delimiter);
		if(ret > 0)
		{
			reportId = ret;
			ExtTool.alert("提示", "保存成功！", Ext.MessageBox.INFO);
		}else
		{
			ExtTool.alert("提示", "保存失败，返回值为：" + ret + "！", Ext.MessageBox.ERROR);
		}
		
	}
	
	obj.btnSave_onclick = function(){
		if(!obj.ValidateContent())
			return;
		obj.SaveReport("1");
		obj.DisplayReport(reportId, dthReportID);
	}
	
	obj.ValidateControl = function(objCtl){
		var errStr = "";
		if(
			(objCtl.getValue() == "")|| 
			(!objCtl.isValid(false))||
			(objCtl.getValue() == null)||
			(objCtl.getRawValue() == ""))
			errStr = "<P>“" + objCtl.initialConfig.fieldLabel + "”不能为空！</P>";
		return errStr;
	}	
	
	obj.ValidateContent = function(){
		var errStr = "";
		errStr += obj.ValidateControl(obj.txtDTHNo);
		errStr += obj.ValidateControl(obj.txtName);
		errStr += obj.ValidateControl(obj.txtFatherName);
		errStr += obj.ValidateControl(obj.txtMotherName);
		errStr += obj.ValidateControl(obj.txtFamTel);
		errStr += obj.ValidateControl(obj.cboSex);
		errStr += obj.ValidateControl(obj.txtBirthday);
		errStr += obj.ValidateControl(obj.cboRegType);
		errStr += obj.ValidateControl(obj.txtWeight);
		errStr += obj.ValidateControl(obj.cboWeightType);
		errStr += obj.ValidateControl(obj.txtPregnancyWeek); //fix bug 197101 by pylian 20160419儿童死亡报告怀孕几周不允许为空 
		errStr += obj.ValidateControl(obj.cboBirthdayPlace);
		errStr += obj.ValidateControl(obj.dtDeathDate);
		
		errStr += obj.ValidateControl(obj.cboDeathPosition);
		errStr += obj.ValidateControl(obj.cboCareBeforeDeath);
		errStr += obj.ValidateControl(obj.cboDiagnoseLv);
		
		if (obj.cboCareBeforeDeath.getRawValue().indexOf("未治疗") > -1){  //fix bug 171037,死亡前治疗为“未治疗”时，未治疗原因必填
			errStr += obj.ValidateControl(obj.cboNotCareReason);
		}
		if(obj.txtDeathAgeMonth.getValue() > 12){
			errStr += '死亡时年龄的月数不能大于"12"，请准确填写年数和月数！\r\n';
		}
		if(obj.txtDeathAgeDay.getValue() > 31){
			errStr += '死亡时年龄的天数不能大于"31"，请准确填写月数和天数！\r\n';
		}
		if(obj.txtDeathAgeHour.getValue() > 24){
			errStr += '死亡时年龄的小时数不能大于"23"，请准确填写天数数和小时数！\r\n';	
		}
		if (((obj.txtDeathAgeYear.getValue() == "") || (obj.txtDeathAgeYear.getValue() == 0)) &&
			((obj.txtDeathAgeMonth.getValue() == "") || (obj.txtDeathAgeMonth.getValue() == 0)) &&
			((obj.txtDeathAgeDay.getValue() == "") || (obj.txtDeathAgeDay.getValue() == 0)) &&
			((obj.txtDeathAgeHour.getValue() == "") || (obj.txtDeathAgeHour.getValue() == 0))){
			errStr += "请填写患儿的死亡年龄，如果不足一周岁的，请填写具体年龄！\r\n";
		}
		if (obj.cboNotCareReason.getRawValue().indexOf("其他") > -1){
			errStr += obj.ValidateControl(obj.txtNotCareReasonTxt);
		}
		errStr += obj.ValidateControl(obj.cboDiagnoseBasis);
		errStr += obj.ValidateControl(obj.cboCategory);
		//errStr += obj.ValidateControl(obj.txtICD10);
		if (errStr != "") {
			ExtTool.alert("提示", errStr, Ext.MessageBox.INFO);
			return false;
		} else {
			return true;
		}
	}
	
	obj.ModiStatus = function(StatusCode)
	{
		var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary", "GetByTypeCode", "DTCReportType", StatusCode, "");
		switch(objDic.Code)
		{
			case '4': //退回
			case '5': //删除
				ExtTool.prompt("原因", "请输入" + objDic.Description + "的原因", 
					function(btn, txt){
						if(btn != 'ok')
							return;
						if(btn == "")
						{
							ExtTool.alert("提示","原因不能为空!");
							return;
						}
						var ret = ExtTool.RunServerMethod('DHCMed.DTH.ChildReport', 'ModifyStatus', reportId, objDic.RowID, txt, session['LOGON.USERID']);
						if(ret == "1")
							ExtTool.alert("提示", "操作成功！", Ext.MessageBox.INFO);
						else
							ExtTool.alert("提示", "操作失败，返回值为：" + ret + "！", Ext.MessageBox.ERROR);
						obj.DisplayReport(reportId, dthReportID);
					}
				);
				break;
			case '2': //审核
				ExtTool.confirm("审核", "您确定要审核这份儿童死亡报卡吗？",
					function(btn)
					{
						if(btn == 'no')
							return;
						var ret = ExtTool.RunServerMethod('DHCMed.DTH.ChildReport', 'ModifyStatus', reportId, objDic.RowID, "", session['LOGON.USERID']);
						if(ret == "1")
							ExtTool.alert("提示", "操作成功！", Ext.MessageBox.INFO);
						else
							ExtTool.alert("提示", "操作失败，返回值为：" + ret + "！", Ext.MessageBox.ERROR);
						obj.DisplayReport(reportId, dthReportID);			
					}
				);
				break;	
			default: //上报，草稿
				if(ret == "1")
					ExtTool.alert("提示", "操作成功！", Ext.MessageBox.INFO);
				else
					ExtTool.alert("提示", "操作失败，返回值为：" + ret + "！", Ext.MessageBox.ERROR);
				obj.DisplayReport(reportId, dthReportID);
				break;
		}
		obj.DisplayReport(reportId, dthReportID);
	}
	
	obj.btnTMP_onclick = function(){
		obj.SaveReport("3");
		obj.DisplayReport(reportId, dthReportID);		
	}
	
	obj.btnCheck_onclick = function(){
		obj.ModiStatus("2");
	}
	
	obj.btnDelete_onclick = function(){
		obj.ModiStatus("5");
	}
	
	obj.btnReturn_onclick = function(){
		obj.ModiStatus("4");
	}	
	
	obj.btnPrint_onclick = function(){
		if(reportId == "")
		{
			ExtTool.alert("提示", "请先保存儿童死亡报卡信息再打印！", Ext.MessageBox.ERROR);
			return;
		}
		PrintDataByExcel(reportId);
	}
	
	obj.btnCancel_onclick = function(){
		if(window.opener){
			if (window.opener.RefreshRowByReportID){
					window.opener.RefreshRowByReportID(reportId);
				}
		}
		window.close();
	}
}
