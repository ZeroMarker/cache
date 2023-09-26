
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>肿瘤发病报告卡</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtCRKPBH" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">登记号</div></td><td><div id="TD-txtPatientNo" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>病情已告知病人</div></td><td><div id="TD-cboCRBQYGZBR" style="width:70px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>姓名</div></td><td><div id="TD-txtPatName" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>性别</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">年龄</div></td><td><div id="TD-txtPatAge" style="width:56px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:44px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>出生日期</div></td><td><div id="TD-txtBirthDay" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>民族</div></td><td><div id="TD-cboCRMZ" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>身份证号</div></td><td><div id="TD-txtPatCardNo" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>职业</div></td><td><div id="TD-cboCRZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>具体工种</div></td><td><div id="TD-cboCRGZ" style="width:104px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>家庭电话</div></td><td><div id="TD-txtJTDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">工作单位</div></td><td><div id="TD-txtGZDW" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>目前居住地址:省</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty1" style="width:104px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>居住详细地址</div></td><td><div id="TD-txtAdress1" style="width:760px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>常住户口地址:省</div></td><td><div id="TD-cboProvince2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty2" style="width:104px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN2" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>户口详细地址</div></td><td><div id="TD-txtAdress2" style="width:760px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td ><div style="width:95px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断部位</div></td><td><div id="TD-txtCRZDBW" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断</div></td><td><div id="TD-cboCRZD" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">ICD编码</div></td><td ><div id="TD-txtCRZDICD" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:95px;text-align:right;overflow:hidden;">原诊断</div></td><td><div id="TD-cboCRYZD" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">原诊断日期</div></td><td><div id="TD-txtCRYZDRQ" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:200px;text-align:left;overflow:hidden;">（原报告诊断有误时填写）</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:95px;text-align:right;overflow:hidden;">病理学类型</div></td><td><div id="TD-txtCRBLXLX" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">病理号</div></td><td><div id="TD-txtCRBLH" style="width:220px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '			    <td><div style="width:95px;text-align:right;overflow:hidden;">确认时期别:T</div></td><td><div id="TD-cboCRTNMFQT" style="width:88px;overflow:hidden;"></div></td>'
		+ '			    <td><div style="width:20px;text-align:right;overflow:hidden;">N</div></td><td><div id="TD-cboCRTNMFQN" style="width:90px;overflow:hidden;"></div></td>'
		+ '			    <td><div style="width:20px;text-align:right;overflow:hidden;">M</div></td><td><div id="TD-cboCRTNMFQM" style="width:90px;overflow:hidden;"></div></td>'
		+ '			    <td><div style="width:50px;text-align:right;overflow:hidden;">期别</div></td><td><div id="TD-cboCRFHCD" style="width:136px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:340px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断依据(如果是续发性肿瘤尽可能注明原发部位)</div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cbgCRZDYJ" style="width:800px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断日期</div></td><td><div id="TD-txtCRZDRQ" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>最高诊断单位</div></td><td><div id="TD-cboCRZGZDDW" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td ><div style="width:74px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡单位</div></td><td><div id="TD-txtCRReportOrgan" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td ><div style="width:74px;text-align:right;overflow:hidden;">报卡科室</div></td><td><div id="TD-cboCRReportLoc" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡医生</div></td><td><div id="TD-txtCRReportUser" style="width:199px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡日期</div></td><td><div id="TD-txtCRReportDate" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">死亡诊断</div></td><td><div id="TD-cboCRSWZD" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡原因</div></td><td><div id="TD-cboCRSWYY" style="width:199px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">死亡日期</div></td><td><div id="TD-txtCRSWRQ" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">死亡ICD10</div></td><td><div id="TD-txtCRSYICD" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">具体死亡原因</div></td><td><div id="TD-txtCRJTSWYY" style="width:460px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td colspan="10"><div style="width:260px;text-align:left;overflow:hidden;">病史摘要(主诉、临床表现和检查情况)</div></td>'
		+ '			</tr><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-txtCRBSZY" style="width:780px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '</tr></table>'
	
	//病人基本信息
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","卡片编号");
    obj.txtPatientNo = Common_TextField("txtPatientNo","登记号");
	obj.cboCRBQYGZBR=Common_ComboToDic("cboCRBQYGZBR","病情已告知病人","CRBQYGZBR");
    obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","身份证号");
	obj.txtPatSex = Common_TextField("txtPatSex","性别");
	obj.txtPatAge = Common_TextField("txtPatAge","年龄");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","年龄单位","CRPatAge");
	obj.txtBirthDay = Common_DateFieldToDate1("txtBirthDay","出生日期");
	obj.cboCRZY=Common_ComboToDic("cboCRZY","职业","CRZY");
	obj.cboCRMZ=Common_ComboToDic("cboCRMZ","民族","CRMZ");
	obj.cboCRGZ = Common_ComboToDicGZ("cboCRGZ","工种",DicTypeGZ);
	obj.txtJTDH = Common_TextField("txtJTDH","家庭电话");
	obj.txtGZDW = Common_TextField("txtGZDW","工作单位");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","居住省","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","居住市","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","居住县","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","居住乡/镇","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","居住村");
	obj.txtAdress1 = Common_TextField("txtAdress1","居住详细地址");
	obj.cboProvince2 = Common_ComboToArea("cboProvince2","户口省","1");
	obj.cboCity2 = Common_ComboToArea("cboCity2","户口市","cboProvince2");
	obj.cboCounty2 = Common_ComboToArea("cboCounty2","户口县","cboCity2");
	obj.cboVillage2 = Common_ComboToArea("cboVillage2","户口乡/镇","cboCounty2");
	obj.txtCUN2 = Common_TextField("txtCUN2","户口村");
	obj.txtAdress2 = Common_TextField("txtAdress2","户口详细地址");
	
	//诊断信息
	obj.txtCRZDBW = Common_TextField("txtCRZDBW","诊断部位");
	obj.cboCRZD = Common_ComboToICD("cboCRZD","诊断");
	obj.txtCRZDICD = Common_TextField("txtCRZDICD","诊断ICD");
	obj.txtCRBLXLX = Common_TextField("txtCRBLXLX","病理学类型");
	obj.txtCRBLH = Common_TextField("txtCRBLH","病理号");
	obj.txtCRZDRQ = Common_DateFieldToDate("txtCRZDRQ","诊断日期");
	obj.cboCRYZD = Common_ComboToICD("cboCRYZD","原诊断");
	obj.txtCRYZDRQ = Common_DateFieldToDate1("txtCRYZDRQ","原诊断日期");
	obj.cboCRZGZDDW=Common_ComboToDic("cboCRZGZDDW","最高诊断单位","CRZGZDDW");
	obj.txtCRReportOrgan = Common_TextField("txtCRReportOrgan","报卡单位");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","报卡科室","E","","I");
	obj.txtCRReportUser = Common_TextField("txtCRReportUser","报卡医生");
	obj.txtCRReportDate = Common_DateFieldToDate("txtCRReportDate","报卡日期");
	obj.txtCRSWRQ = Common_DateFieldToDate1("txtCRSWRQ","死亡日期");
	obj.cboCRSWZD = Common_ComboToICD("cboCRSWZD","死亡诊断");
	obj.txtCRSYICD = Common_TextField("txtCRSYICD","死亡ICD10");
	obj.cboCRSWYY = Common_ComboToDic("cboCRSWYY","死亡原因","CRSWYYzlk");
	obj.txtCRBSZY = Common_TextArea("txtCRBSZY","病史摘要",50);
	obj.cbgCRZDYJ = Common_CheckboxGroupToDic("cbgCRZDYJ","诊断依据","CRZDYJ",5);
	obj.txtCRJTSWYY = Common_TextField("txtCRJTSWYY","具体死亡原因");
	obj.cboCRTNMFQT = Common_ComboToDic("cboCRTNMFQT","确认时期T","CRTNMFQT");
	obj.cboCRTNMFQN = Common_ComboToDic("cboCRTNMFQN","确认时期N","CRTNMFQN");
	obj.cboCRTNMFQM = Common_ComboToDic("cboCRTNMFQM","确认时期M","CRTNMFQM");
	obj.cboCRFHCD = Common_ComboToDic("cboCRFHCD","期别","CRFHCD");
	
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
}