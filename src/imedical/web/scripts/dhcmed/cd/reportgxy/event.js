﻿function InitViewPortEvent(obj) {
	obj.PatientCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportPAT");
	obj.ReportGXYCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportGXY");
	obj.ReportCls=ExtTool.StaticServerObject("DHCMed.CD.CRReport");
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
		obj.DisplayRepInfo();
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
			Common_SetValue("txtReportUser",session['LOGON.USERNAME']);
			Common_SetValue("txtReportOrgan",HospDesc);
			if(PatientID!=""){
				var objPat=obj.PatientSrv.GetObjById(PatientID);
				Common_SetValue("txtPatName",objPat.PatientName);
				Common_SetValue("txtPatSex",objPat.Sex);
				Common_SetValue("txtPatCardNo",objPat.PersonalID);
				Common_SetValue("txtLXDH",objPat.Telephone);
				//Common_SetValue("txtPatAge",objPat.Age);
				//Common_SetValue("cboPatAgeDW","","岁");
				Common_SetValue("txtAdress1",objPat.Address);
				Common_SetValue("txtAdress2",objPat.Address);
				Common_SetValue("txtBirthDay",objPat.Birthday);
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
			var objGXY=obj.ReportGXYCls.GetStringByParRef(obj.ReportID);
			var objPat=obj.PatientCls.GetStringByParRef(obj.ReportID);
			var arrRep=objRep.split("^");
			var arrGXY=objGXY.split("^");
			var arrPat=objPat.split("^");
			Common_SetValue("txtCRKPBH",arrNYZD[0]);
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
			Common_SetValue("txtBirthDay",arrPat[7]);
			Common_SetValue("txtLXDH",arrPat[20]);
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

			Common_SetValue("cbgGXYLX",arrGXY[1].split(CHR_1)[0],arrGXY[1].split(CHR_1)[1]);
			Common_SetValue("cbgGXYFJ",arrGXY[2].split(CHR_1)[0],arrGXY[2].split(CHR_1)[1]);
			Common_SetValue("txtSSY",arrGXY[3]);
			Common_SetValue("txtSZY",arrGXY[4]);
			Common_SetValue("txtZDQR",arrGXY[7]);
			
			Common_SetValue("txtReportUser",arrRep[5]);
			Common_SetValue("txtReportOrgan",arrRep[6]);
			Common_SetValue("txtReportDate",arrRep[7]);
			Common_SetValue("cboCRReportLoc",arrRep[3],arrRep[4]);
		}
	};
	
	obj.GetRepData = function (step) {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"GXY";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1上报，2审核，3删除
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+Common_GetValue("txtReportUser");
		InputStr=InputStr+"^"+Common_GetValue("txtReportOrgan");
		InputStr=InputStr+"^"+Common_GetValue("txtReportDate");
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];
		return InputStr;
	}
	
	obj.GetGXYData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+Common_GetValue("txtCRKPBH");
		InputStr=InputStr+"^"+Common_GetValue("cbgGXYLX");
		InputStr=InputStr+"^"+Common_GetValue("cbgGXYFJ");
		InputStr=InputStr+"^"+Common_GetValue("txtSSY");
		InputStr=InputStr+"^"+Common_GetValue("txtSZY");
		InputStr=InputStr+"^"+Common_GetValue("txtZDQR");
		
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;
		InputStr=InputStr+"^"+Common_GetValue("txtPatName");
		InputStr=InputStr+"^"+Common_GetValue("txtPatCardNo");
		InputStr=InputStr+"^"+Common_GetValue("txtPatSex");
		InputStr=InputStr+"^"+Common_GetValue("txtPatAge");
		InputStr=InputStr+"^"+Common_GetText("cboPatAgeDW");  
		InputStr=InputStr+"^"+Common_GetValue("txtLXDH");
		InputStr=InputStr+"^"+Common_GetValue("txtBirthDay");
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
		var RepData=obj.GetRepData(1);
		var GXYData=obj.GetGXYData();
		var PatData=obj.GetPatData();
		var ExtraData=obj.GetExtraData();
		var ret=obj.RepUpdateCls.SaveRepData(RepData,GXYData,PatData);
		if(parseInt(ret)<=0){
			ExtTool.alert("错误","数据保存错误!"+ret);
			return;
		}else{
			ExtTool.alert("提示","数据保存成功!");
			obj.ReportID=ret;
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
			//var flg=ExportDataToExcel("","","伤害报告卡("+Common_GetValue("txtPatName")+")",cArguments);
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
			//var flg=PrintDataToExcel("","","伤害报告卡("+Common_GetValue("txtPatName")+")",cArguments);
		}
	};
	obj.btnCancle_click = function(){
		window.close();
	};
}	