var objScreen = new Object();
function InitReportXNXG(){
    var obj = objScreen;
	obj.ReportID = ReportID;
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>冠心病急性事件、脑卒中发病报卡</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtKPBH" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">登记号</div></td><td><div id="TD-txtRegNo" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">报卡类型</div></td><td><div id="TD-cboBGKLX" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		//基本信息
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>姓名</div></td><td><div id="TD-txtPatName" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>性别</div></td><td><div id="TD-txtSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">年龄</div></td><td><div id="TD-txtAge" style="width:56px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:44px;overflow:hidden;"></div></td>'		
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>出生日期</div></td><td><div id="TD-dtBirthday" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>民族</div></td><td><div id="TD-cboNation" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>身份证号</div></td><td><div id="TD-txtIdentify" style="width:130px;overflow:hidden;"></div></td>'
		+ '			  	<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>职业</div></td><td><div id="TD-cboOccupation" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>具体工种</div></td><td><div id="TD-cboCRGZ" style="width:104px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>文化</div></td><td><div id="TD-cboEducation" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>婚姻情况</div></td><td><div id="TD-cboMarital" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>电话</div></td><td><div id="TD-txtTelphone" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">工作单位</div></td><td><div id="TD-txtCompany" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>目前居住地址:省</div></td><td><div id="TD-cboCurrProvince" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCurrCity" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">县(区)</div></td><td><div id="TD-cboCurrCounty" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">街道</div></td><td><div id="TD-cboCurrVillage" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCurrRoad" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>居住详细地址</div></td><td><div id="TD-txtCurrAddress" style="width:776px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>常住户口地址:省</div></td><td><div id="TD-cboRegProvince" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboRegCity" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">县(区)</div></td><td><div id="TD-cboRegCounty" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">街道</div></td><td><div id="TD-cboRegVillage" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtRegRoad" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>户口详细地址</div></td><td><div id="TD-txtRegAddress" style="width:776px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		//疾病信息
		+ '		<tr><td width="100%"><div class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断</div></td><td><div id="TD-cboCRZD" style="width:290px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">ICD编码</div></td><td><div id="TD-txtZDBM" style="width:104px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">冠心病</div></td><td><div id="TD-cboGXBZD" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">脑卒中</div></td><td><div id="TD-cboNCZZD" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">首要症状:</div></td><td><div id="TD-cbgSYZZ" style="width:600px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>病史:</div></td><td><div id="TD-chkBS" style="width:600px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>发病日期</div></td><td><div id="TD-dtFBRQ" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>确诊日期</div></td><td><div id="TD-dtQZRQ" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:105px;text-align:right;overflow:hidden;">是否首次发病</div></td><td><div id="TD-chgSFSCFB" style="width:65px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>确诊单位</div></td><td><div id="TD-cboQZDW" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡单位</div></td><td><div id="TD-txtRepDW" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">报卡科室</div></td><td><div id="TD-cboCRReportLoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡医生</div></td><td><div id="TD-txtDoctor" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>报卡日期</div></td><td><div id="TD-dtRepDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">死亡原因</div></td><td><div id="TD-cboDeathReason" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">死亡日期</div></td><td><div id="TD-dtDeathDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">死亡诊断</div></td><td><div id="TD-cboCRSWZD" style="width:294px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">死亡ICD</div></td><td><div id="TD-txtDeathICD" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡具体原因</div></td><td><div id="TD-txtSWJTReason" style="width:244px;overflow:hidden;"></div></td>'
		+ ' 		</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:320px;text-align:right;overflow:hidden;">本次卒中发病时间与CT/核磁共振检查时间间隔</div></td><td><div id="TD-cboSJJG" style="width:218px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:125px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断依据:磁共振</div></td><td><div id="TD-cboCGZ" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:55px;text-align:right;overflow:hidden;">血清酶</div></td><td><div id="TD-cboXQM" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">心电图</div></td><td><div id="TD-cboXDT" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">CT</div></td><td><div id="TD-cboCT" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">血管造影</div></td><td><div id="TD-cboXGZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:125px;text-align:right;overflow:hidden;">临床症状</div></td><td><div id="TD-cboLCZZ" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:55px;text-align:right;overflow:hidden;">脑脊液</div></td><td><div id="TD-cboNJY" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">尸检</div></td><td><div id="TD-cboSJ" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">脑电图</div></td><td><div id="TD-cboNDT" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">医生检查</div></td><td><div id="TD-cboYSJC" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:125px;text-align:right;overflow:hidden;">死后推断</div></td><td><div id="TD-cboSHTD" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:600px;text-align:left;overflow:hidden;">病史摘要(主述、临床表现和具体检查情况)</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"></div></td><td width="100%"><div id="TD-txtBSSummary" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '</tr></table>'
		
	//病人基本信息
    obj.txtKPBH  = Common_TextField("txtKPBH","卡片编号");
    obj.txtRegNo = Common_TextField("txtRegNo","登记号");
	obj.cboBGKLX = Common_ComboToDic("cboBGKLX","报卡类型","CRReportType");
    obj.txtPatName  = Common_TextField("txtPatName","病人姓名");
    obj.txtSex 		= Common_TextField("txtSex","性别");
	obj.cboCRGZ = Common_ComboToDicGZ("cboCRGZ","工种",DicTypeGZ);
	obj.cboNation	= Common_ComboToDic("cboNation","民族","CRMZ");
	obj.cboCardType = Common_ComboToDic("cboCardType","证件类型","DTHCardType");
	obj.txtIdentify = Common_TextField("txtIdentify","证件号码");
    obj.dtBirthday  = Common_DateFieldToDate("dtBirthday","出生日期");
    obj.txtAge 		= Common_TextField("txtAge","年龄");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","年龄单位","CRPatAge");
	obj.cboMarital 	= Common_ComboToDic("cboMarital","婚姻情况","CRDTHMarriage");
	obj.cboEducation  = Common_ComboToDic("cboEducation","文化","CRDTHEducation");
	obj.cboOccupation = Common_ComboToDic("cboOccupation","职业","CRZY");
    obj.txtCompany  = Common_TextField("txtCompany","工作单位");
	
    obj.txtRegAddress  = Common_TextField("txtRegAddress","户口详细地址");
	obj.cboRegProvince = Common_ComboToArea("cboRegProvince","常住户口省","1");
	obj.cboRegCity    = Common_ComboToArea("cboRegCity","常住户口市","cboRegProvince");
	obj.cboRegCounty  = Common_ComboToArea("cboRegCounty","常住户口县","cboRegCity");
	obj.cboRegVillage = Common_ComboToArea("cboRegVillage","常住户口街道","cboRegCounty");
    obj.txtRegRoad 	  = Common_TextField("txtRegRoad","常住户口村");
    obj.txtCurrAddress  = Common_TextField("txtCurrAddress","居住详细地址");
	obj.cboCurrProvince = Common_ComboToArea("cboCurrProvince","居住省","1");
	obj.cboCurrCity    = Common_ComboToArea("cboCurrCity","居住市","cboCurrProvince");
	obj.cboCurrCounty  = Common_ComboToArea("cboCurrCounty","居住县","cboCurrCity");
	obj.cboCurrVillage = Common_ComboToArea("cboCurrVillage","居住街道","cboCurrCounty");
    obj.txtCurrRoad = Common_TextField("txtCurrRoad","居住村");
	
    obj.txtTelphone = Common_TextField("txtTelphone","电话");
    obj.dtRepDate   = Common_DateFieldToDate("dtRepDate","填卡日期");
    obj.dtDeathDate = Common_DateFieldToDate("dtDeathDate","死亡日期");
    obj.cboDeathReason = Common_ComboToDic("cboDeathReason","死亡原因","CRSWYYxnxg");
    obj.txtSWJTReason  = Common_TextField("txtSWJTReason","死亡具体原因");
	obj.cboCRSWZD = Common_ComboToICD("cboCRSWZD","死亡诊断");
	obj.txtDeathICD	   = Common_TextField("txtDeathICD","死亡ICD10");
    obj.cboSHTD = Common_ComboToDic("cboSHTD","死后推断","CRSHTD");
    obj.cboSJJG = Common_ComboToDic("cboSJJG","时间间隔","CRSJJG");
    
	obj.cboCRZD = Common_ComboToICD("cboCRZD","诊断");
    obj.txtZDBM   = Common_TextField("txtZDBM","ICD编码");
	obj.cbgSYZZ   = Common_CheckboxGroupToDic("cbgSYZZ","首要症状(脑卒中)","CRSYZZ",4);
	obj.cboGXBZD  = Common_ComboToDic("cboGXBZD","冠心病诊断","CRGXBZD");
	obj.cboNCZZD  = Common_ComboToDic("cboNCZZD","脑卒中诊断","CRNZZZD");
	//obj.chgSFSCFB = Common_RadioGroupToDic("chgSFSCFB",'是否首次发病',"CEIsFristInfect",2)
	obj.chgSFSCFB = Common_Checkbox("chgSFSCFB",'是否首次发病');
	obj.chkBS  = Common_CheckboxGroupToDic("chkBS","病史","CRZDBS",4)
    obj.dtFBRQ = Common_DateFieldToDate("dtFBRQ","发病日期");
    obj.dtQZRQ = Common_DateFieldToDate("dtQZRQ","确诊日期");
	obj.cboQZDW = Common_ComboToDic("cboQZDW","确诊单位","CRZGZDDW");
	obj.cboLCZZ = Common_ComboToDic("cboLCZZ","临床症状","CRDiagnoseBase");
	obj.cboXGZY = Common_ComboToDic("cboXGZY","血管造影","CRDiagnoseBase");
	obj.cboXDT  = Common_ComboToDic("cboXDT","心电图","CRDiagnoseBase");
	obj.cboCT   = Common_ComboToDic("cboCT","CT","CRDiagnoseBase");
	obj.cboXQM  = Common_ComboToDic("cboXQM","血清酶","CRDiagnoseBase");
	obj.cboCGZ  = Common_ComboToDic("cboCGZ","磁共振","CRDiagnoseBase");
	obj.cboNJY  = Common_ComboToDic("cboNJY","脑脊液","CRDiagnoseBase");
	obj.cboSJ   = Common_ComboToDic("cboSJ","尸检","CRDiagnoseBase");
	obj.cboNDT  = Common_ComboToDic("cboNDT","脑电图","CRDiagnoseBase");
	obj.cboYSJC = Common_ComboToDic("cboYSJC","神经科医生检查","CRDiagnoseBase");
	
    obj.txtRepDW  = Common_TextField("txtRepDW","报卡单位");
    obj.txtDoctor = Common_TextField("txtDoctor","报卡医生");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","报卡科室","E","","I");
    obj.txtBSSummary = Common_TextArea("txtBSSummary","病史摘要",50,600);
	
	obj.btnSubmit = new Ext.Button({
		id : 'btnSubmit'
		,iconCls : 'icon-save'
		,width : 75
		,text : '提交'
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
			obj.btnSubmit,
			obj.btnDelete,
			obj.btnCheck,
			obj.btnExport,
			obj.btnPrint,
			obj.btnCancle
		]
	});
	
    obj.MainViewPort=new Ext.Viewport({
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
	
    InitReportXNXGEvent(obj);
    obj.LoadEvent();
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 