
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>糖尿病发病报告卡</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtCRKPBH" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">登记号</div></td><td><div id="TD-txtPatientNo" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>姓名</div></td><td><div id="TD-txtPatName" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>身份证号</div></td><td><div id="TD-txtPatCardNo" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;"><span style="color:red">*</span>性别</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">年龄</div></td><td><div id="TD-txtPatAge" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>职业</div></td><td><div id="TD-cboCRZY" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>具体工种</div></td><td><div id="TD-cboCRGZ" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;"><span style="color:red">*</span>文化</div></td><td><div id="TD-cboCRWH" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>出生日期</div></td><td><div id="TD-txtBirthDay" style="width:92px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>民族</div></td><td><div id="TD-cboCRMZ" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系电话</div></td><td><div id="TD-txtJTDH" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;">工作单位</div></td><td><div id="TD-txtGZDW" style="width:276px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>目前居住地址:省</div></td><td><div id="TD-cboProvince1" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity1" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty1" style="width:106px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:65px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage1" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN1" style="width:162px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>居住详细地址</div></td><td><div id="TD-txtAdress1" style="width:698px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>常住户口地址:省</div></td><td><div id="TD-cboProvince2" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity2" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty2" style="width:106px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:65px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage2" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN2" style="width:162px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>户口详细地址</div></td><td><div id="TD-txtAdress2" style="width:698px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>糖尿病类型</div></td><td><div id="TD-cboCRZDLX" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断</div></td><td><div id="TD-cboCRZD" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">ICD编码</div></td><td ><div id="TD-txtCRZDICD" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>并发症</div></td><td><div id="TD-cbgCRBFZ" style="width:630px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">危害因素</div></td><td><div id="TD-cbgCRWHYS" style="width:420px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">体重</div></td><td><div id="TD-txtCRTZ" style="width:40px;overflow:hidden;"></div></td><td><div style="width:30px;text-align:left;overflow:hidden;">公斤</div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">身高</div></td><td><div id="TD-txtCRSG" style="width:40px;overflow:hidden;"></div></td><td><div style="width:40px;text-align:left;overflow:hidden;">厘米</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">家族史：父母兄弟姐妹共</div></td><td><div id="TD-txtCRRS" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:160px;text-align:left;overflow:hidden;">人，其中有糖尿病史：</div></td><td><div id="TD-cbgCRJZS" style="width:250px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>临床表现</div></td><td><div id="TD-cbgCRLCBX" style="width:650px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">其他临床表现</div></td><td><div id="TD-txtCRQTLCBX" style="width:526px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">主要检查情况</div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E1 空腹血糖值(mol/L)</div></td><td><div id="TD-txtCRZYJCQK1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E2 随机血糖值(mol/L)</div></td><td><div id="TD-txtCRZYJCQK2" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E3 OGTT(mol/L)</div></td><td><div id="TD-txtCRZYJCQK3" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E4 总胆固醇(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK4" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E5 HDL-C(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK5" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E6 LDL-C(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK6" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E7 甘油三酯(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK7" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E8 尿微量蛋白(mg/24h)</div></td><td><div id="TD-txtCRZYJCQK8" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E9 糖化血红蛋白(%)</div></td><td><div id="TD-txtCRZYJCQK9" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="Div12" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断日期</div></td><td><div id="TD-txtCRZDDate" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>最高诊断单位</div></td><td><div id="TD-cboCRZGZDDW" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡单位</div></td><td><div id="TD-txtCRReportOrgan" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">报卡科室</div></td><td><div id="TD-cboCRReportLoc" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡医生</div></td><td><div id="TD-txtCRReportUser" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡日期</div></td><td><div id="TD-txtCRReportDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡日期</div></td><td><div id="TD-txtCRSWRQ" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡原因</div></td><td><div id="TD-cboCRSWYY" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡诊断</div></td><td><div id="TD-cboCRSWZD" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡ICD10</div></td><td><div id="TD-txtCRSYICD" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡具体原因</div></td><td><div id="TD-txtCRJTSWYY" style="width:460px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '</tr></table>'
	
	//病人基本信息
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","卡片编号");
    obj.txtPatientNo = Common_TextField("txtPatientNo","登记号");
    obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","身份证号");
	obj.txtPatSex = Common_TextField("txtPatSex","性别");
	obj.txtPatAge = Common_TextField("txtPatAge","年龄");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","年龄单位","CRPatAge");
	obj.txtBirthDay = Common_DateFieldToDate1("txtBirthDay","出生日期");
	obj.cboCRZY=Common_ComboToDic("cboCRZY","职业","CRZY");
	obj.cboCRMZ=Common_ComboToDic("cboCRMZ","民族","CRMZ");
	obj.cboCRGZ = Common_ComboToDicGZ("cboCRGZ","工种",DicTypeGZ);
	obj.cboCRWH = Common_ComboToDic("cboCRWH","文化","CRDTHEducation");
	
	obj.txtJTDH = Common_TextField("txtJTDH","家庭电话");
	obj.txtGZDW = Common_TextField("txtGZDW","工作单位");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","居住地址省","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","居住地址市","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","居住地址县","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","居住地址乡/镇","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","居住地址村");
	obj.txtAdress1 = Common_TextField("txtAdress1","居住详细地址");
	obj.cboProvince2 = Common_ComboToArea("cboProvince2","常住户口省","1");
	obj.cboCity2 = Common_ComboToArea("cboCity2","常住户口市","cboProvince2");
	obj.cboCounty2 = Common_ComboToArea("cboCounty2","常住户口县","cboCity2");
	obj.cboVillage2 = Common_ComboToArea("cboVillage2","常住户口乡/镇","cboCounty2");
	obj.txtCUN2 = Common_TextField("txtCUN2","常住户口村");
	obj.txtAdress2 = Common_TextField("txtAdress2","户口详细地址");
	
	//诊断信息
	obj.cboCRZDLX = Common_ComboToDic("cboCRZDLX","糖尿病类型","CRZDLX");
	obj.cboCRZD = Common_ComboToICD("cboCRZD","诊断","糖尿病");
	
	obj.txtCRZDICD = Common_TextField("txtCRZDICD","诊断ICD");
	obj.cbgCRBFZ = Common_CheckboxGroupToDic("cbgCRBFZ","并发症","CRBFZ",6);
	obj.cbgCRWHYS = Common_CheckboxGroupToDic("cbgCRWHYS","危害因素","CRWHYS",4);
	obj.txtCRTZ = Common_TextField("txtCRTZ","体重");
	obj.txtCRSG = Common_TextField("txtCRSG","身高");
	obj.cbgCRJZS = Common_CheckboxGroupToDic("cbgCRJZS","家族史","CRJZS",4);
	obj.txtCRRS = Common_TextField("txtCRRS","人数");
	
	obj.txtCRZDDate = Common_DateFieldToDate("txtCRZDDate","诊断日期");
	obj.cboCRZGZDDW=Common_ComboToDic("cboCRZGZDDW","最高诊断单位","CRZGZDDW");
	obj.txtCRReportOrgan = Common_TextField("txtCRReportOrgan","报卡单位");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","报卡科室","E","","I");
	obj.txtCRReportUser = Common_TextField("txtCRReportUser","报卡医生");
	obj.txtCRReportDate = Common_DateFieldToDate("txtCRReportDate","报卡日期");
	obj.txtCRSWRQ = Common_DateFieldToDate1("txtCRSWRQ","死亡日期");
	obj.txtCRSYICD = Common_TextField("txtCRSYICD","死亡ICD10");
	obj.cboCRSWYY = Common_ComboToDic("cboCRSWYY","死亡原因","CRSWYY");
	obj.cboCRSWZD = Common_ComboToICD("cboCRSWZD","死亡诊断");
	obj.txtCRJTSWYY = Common_TextField("txtCRJTSWYY","具体死亡原因");
	obj.cbgCRLCBX = Common_CheckboxGroupToDic("cbgCRLCBX","临床表现","CRLCBX",5);
	obj.txtCRQTLCBX = Common_TextField("txtCRQTLCBX","其他临床表现");
	
	obj.txtCRZYJCQK1 = Common_TextField("txtCRZYJCQK1","E1 空腹血糖值");
	obj.txtCRZYJCQK2 = Common_TextField("txtCRZYJCQK2","E2 随机血糖值");
	obj.txtCRZYJCQK3 = Common_TextField("txtCRZYJCQK3","E3 OGTT");
	obj.txtCRZYJCQK4 = Common_TextField("txtCRZYJCQK4","E4 总胆固醇");
	obj.txtCRZYJCQK5 = Common_TextField("txtCRZYJCQK5","E5 HDL-C");
	obj.txtCRZYJCQK6 = Common_TextField("txtCRZYJCQK6","E6 LDL-C");
	obj.txtCRZYJCQK7 = Common_TextField("txtCRZYJCQK7","E7 甘油三酯");
	obj.txtCRZYJCQK8 = Common_TextField("txtCRZYJCQK8","E8 尿微量蛋白");
	obj.txtCRZYJCQK9 = Common_TextField("txtCRZYJCQK9","E9 糖化血红蛋白");
	
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 75
		,text : '保存'
	});
	
	obj.btnCheck=new Ext.Button({
        id:'btnCheck'
        ,text:'审核'
        ,iconCls:'icon-check'
		,width : 75
    });
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 75
		,text : '删除'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 75
		,text : '导出'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 75
		,text : '打印'
	});
	
	obj.btnCancle=new Ext.Button({
        id:'btnCancle'
        ,text:'关闭'
        ,iconCls:'icon-close'
		,width : 75
    });
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,buttonAlign:'center'
		,buttons : [
			obj.btnSave,
			obj.btnDelete,
			obj.btnCheck,
			obj.btnExport,
			obj.btnPrint,
			obj.btnCancle
		]
	});
	
	
	//界面整体布局
	obj.ViewPort = new Ext.Viewport({
		id:'MainViewPortId'
        ,layout : 'fit'
		,items:[
			obj.MainPanel
		]
	});
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById('TD-' + cmp.id);
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render('TD-' + cmp.id);
		}
	});
	
	InitViewPortEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 