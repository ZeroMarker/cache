var objScreen = new Object();
function InitDMReport(){
    var obj = objScreen;
	obj.RepStatusCode = '';
	obj.TemplateVersion = '';
	
	//死亡证明报告权限
	if (typeof tDHCMedMenuOper=="undefined") {
		ExtTool.alert("提示","您没有操作权限，请找相关人员增加权限!");
		return;
	}
	var RowHeight = 28
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #65B2FF;border-collapse:collapse;width:1000px;">'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>死亡医学证明书</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>病人基本信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;padding:0px 10px;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red"><b>无名氏</b></span></div></td><td><div id="TD-chkJohnDoe" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red"><b>新生儿</b></span></div></td><td><div id="TD-chkNewBorn" style="width:38px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td width="7%" style="text-align:right;">登记号</td><td width="13%"><div id="TD-txtRegNo"></div></td>'
		+ '				<td width="7%" style="text-align:right;">姓名</td><td width="13%"><div id="TD-txtPatName" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">性别</td><td width="13%"><div id="TD-txtSex" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">年龄</td><td width="13%"><div id="TD-txtAge" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">出生日期</td><td width="13%"><div id="TD-txtBirthday" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td width="7%" style="text-align:right;">病案号</td><td width="13%"><div id="TD-txtMrNo" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">国家/地区</td><td width="13%"><div id="TD-txtCountry" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">民族</td><td width="13%"><div id="TD-txtNation" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>证件类型</span></td><td width="13%"><div id="TD-cboCardType" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>证件号码</span></td><td width="13%"><div id="TD-txtIdentify" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>婚姻状况</span></td><td width="13%"><div id="TD-cboMarital" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>文化程度</span></td><td width="13%"><div id="TD-cboEducation" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>职业</span></td><td width="13%"><div id="TD-cboOccupation" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>工作单位</span></td><td width="33%"><div id="TD-txtCompany" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;">户籍地址</td><td width="93%"><div id="TD-txtRegAddress" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>省</span></td><td width="13%"><div id="TD-cboRegProvince" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>市</span></td><td width="13%"><div id="TD-cboRegCity" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>县</span></td><td width="13%"><div id="TD-cboRegCounty" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>乡(街道)</span></td><td width="13%"><div id="TD-cboRegVillage" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>村(小区)</span></td><td width="13%"><div id="TD-txtRegRoad" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;">常住地址</td><td width="93%"><div id="TD-txtCurrAddress" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>省</span></td><td width="13%"><div id="TD-cboCurrProvince" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>市</span></td><td width="13%"><div id="TD-cboCurrCity" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>县</span></td><td width="13%"><div id="TD-cboCurrCounty" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>乡(街道)</span></td><td width="13%"><div id="TD-cboCurrVillage" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>村(小区)</span></td><td width="13%"><div id="TD-txtCurrRoad" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table  width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>证明编号</span></td><td width="13%"><div id="TD-txtDeathNo" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>死亡日期</span></td><td width="13%"><div id="TD-txtDeathDate" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>死亡时间</span></td><td width="13%"><div id="TD-txtDeathTime" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>死亡地点</span></td><td width="13%"><div id="TD-cboDeathPlace" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">病人密级</td><td width="13%"><div id="TD-txtEncryptLevel" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>家属姓名</span></td><td width="13%"><div id="TD-txtFamName" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>联系电话</span></td><td width="13%"><div id="TD-txtFamTel" style="overflow:hidden;"></div></td>'
		+ '				<td width="27%" style="text-align:right;"><div id="TD-cboPregnanciesL" style="overflow:hidden;"><span><font color="red">*</font>妊娠期或终止妊娠42天内</span></div></td><td width="13%"><div id="TD-cboPregnancies" style="overflow:hidden;"></div></td>'
		+ '				<td width="7%" style="text-align:right;">病人级别</td><td width="13%"><div id="TD-txtPatLevel" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table  width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td width="7%" style="text-align:right;"><span><font color="red">*</font>死者关系</span></td><td width="13%"><div id="TD-cboFamRelation" style="overflow:hidden;"></div></td>'
		+ '				<td width="15%" style="text-align:right;"><span><font color="red">*</font>家属住址或工作单位</span></td><td width="65%"><div id="TD-txtFamAddress" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>死亡证明明细信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;padding:0px 10px;">'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">(a)直接导致死亡的疾病或情况</div></td><td><div id="TD-cboAReason" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtAReasonICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">编码</div></td><td><div id="TD-txtAFPReason" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">时间间隔</div></td><td><div id="TD-txtAInterval" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">单位</div></td><td><div id="TD-cboATime" style="width:60px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">(b)引起(a)的疾病或情况</div></td><td><div id="TD-cboBReason" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtBReasonICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">编码</div></td><td><div id="TD-txtBFPReason" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">时间间隔</div></td><td><div id="TD-txtBInterval" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">单位</div></td><td><div id="TD-cboBTime" style="width:60px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">(c)引起(b)的疾病或情况</div></td><td><div id="TD-cboCReason" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtCReasonICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">编码</div></td><td><div id="TD-txtCFPReason" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">时间间隔</div></td><td><div id="TD-txtCInterval" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">单位</div></td><td><div id="TD-cboCTime" style="width:60px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">(d)引起(c)的疾病或情况</div></td><td><div id="TD-cboDReason" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtDReasonICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">编码</div></td><td><div id="TD-txtDFPReason" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">时间间隔</div></td><td><div id="TD-txtDInterval" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">单位</div></td><td><div id="TD-cboDTime" style="width:60px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">损伤中毒诊断</div></td><td><div id="TD-cboDamageDiagnose" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-cboDamageDiagnoseICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><b><span><font color="red">*</font>诊断单位</span></b></div></td><td><div id="TD-cboDiagnoseUnit" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><b><span><font color="red">*</font>诊断依据</span></b></div></td><td><div id="TD-cboDiagnoseBasis" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">其他诊断</div></td><td><div id="TD-cboOtherDiagnose" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtOtherDiagnoseICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">编码</div></td><td><div id="TD-txtOtherDiagnoseFP" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">时间间隔</div></td><td><div id="TD-txtOtherDiagnoseInterval" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">单位</div></td><td><div id="TD-cboOtherDiagnoseTime" style="width:60px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px"><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">备注</div></td><td><div id="TD-txtResume" style="width:810px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>调查记录</b>(死亡地点不是医疗卫生机构的患者必须填调查记录)</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;padding:0px 10px;">'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">死者生前病史及症状体征</div></td><td><div id="TD-txtExamMedical" style="width:946px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">被调查者</div></td><td><div id="TD-txtExamName" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">与死者关系</div></td><td><div id="TD-cboExamRelation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">联系电话</div></td><td><div id="TD-txtExamTel" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">死因推断</div></td><td><div id="TD-txtExamDeathReason" style="width:300px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">联系地址</div></td><td><div id="TD-txtExamAddress" style="width:480px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">调查者</div></td><td><div id="TD-txtExamUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">调查日期</div></td><td><div id="TD-txtExamDate" style="width:220px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivBaseReasonL" class="subtitle">'
		+ '		<span style=""><b>根本死因</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="DivBaseReason" style="width=100%;padding:0px 10px;">'
		+ '			<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0"><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">根本死因</div></td><td><div id="TD-cboBaseReason" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtBaseReasonICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">损伤中毒</div></td><td><div id="TD-cboDamage" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">ICD10</div></td><td><div id="TD-txtDamageICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '</tr></table>'
	
	//病人基本信息
    obj.chkJohnDoe = Common_Checkbox("chkJohnDoe","无名氏");
    obj.chkNewBorn = Common_Checkbox("chkNewBorn","新生儿");
    obj.txtRegNo = Common_TextField("txtRegNo","登记号");
    obj.txtMrNo = Common_TextField("txtMrNo","病案号");
    obj.txtPatName = Common_TextField("txtPatName","病人姓名");
    obj.txtSex = Common_TextField("txtSex","性别");
    obj.txtCountry = Common_TextField("txtCountry","国家或地区");
	obj.txtNation = Common_TextField("txtNation","民族");
	obj.cboCardType = Common_ComboToDic("cboCardType","证件类型","DTHCardType");
	obj.txtIdentify = Common_TextField("txtIdentify","证件号码");
    obj.txtBirthday = Common_DateFieldToDate("txtBirthday","出生日期");
    obj.txtAge = Common_TextField("txtAge","年龄");
	obj.cboMarital = Common_ComboToDic("cboMarital","婚姻状况","DTHMarriage");
	obj.cboEducation = Common_ComboToDic("cboEducation","文化程度","DTHEducation");
	obj.cboOccupation = Common_ComboToDic("cboOccupation","职业","DTHCareer");
	obj.cboWorkType = Common_ComboToDic("cboWorkType","工作类型","DMJOBTYPE");
    obj.txtCompany = Common_TextField("txtCompany","工作单位");
    obj.txtRegAddress = Common_TextField("txtRegAddress","户籍地址");
	obj.cboRegProvince = Common_ComboToArea("cboRegProvince","省","1");
	obj.cboRegCity = Common_ComboToArea("cboRegCity","市","cboRegProvince");
	obj.cboRegCounty = Common_ComboToArea("cboRegCounty","县","cboRegCity");
	obj.cboRegVillage = Common_ComboToArea("cboRegVillage","乡","cboRegCounty");
    obj.txtRegRoad = Common_TextField("txtRegRoad","地址");
    obj.txtCurrAddress = Common_TextField("txtCurrAddress","生前住址");
	obj.cboCurrProvince = Common_ComboToArea("cboCurrProvince","省","1");
	obj.cboCurrCity = Common_ComboToArea("cboCurrCity","市","cboCurrProvince");
	obj.cboCurrCounty = Common_ComboToArea("cboCurrCounty","县","cboCurrCity");
	obj.cboCurrVillage = Common_ComboToArea("cboCurrVillage","乡","cboCurrCounty");
    obj.txtCurrRoad = Common_TextField("txtCurrRoad","地址");
    obj.txtFamName = Common_TextField("txtFamName","家属姓名");
	obj.cboFamCardType = Common_ComboToDic("cboFamCardType","家属证件类型","DTHCardType");
    obj.txtFamIdentify = Common_TextField("txtFamIdentify","证件号码");
	obj.cboFamRelation = Common_ComboToDic("cboFamRelation","家属与死者关系","DTHFamilyRelation");
    obj.txtFamTel = Common_TextField("txtFamTel","联系电话");
	obj.txtEncryptLevel = Common_TextField("txtEncryptLevel","病人密级");
	obj.txtPatLevel = Common_TextField("txtPatLevel","病人级别");
	
    obj.txtFamAddress = Common_TextField("txtFamAddress","家属住址或工作单位");
    obj.txtDeathNo = Common_TextField("txtDeathNo","证明编号");
    obj.txtDeathDate = Common_DateFieldToDate("txtDeathDate","死亡日期");
	obj.txtDeathTime = Common_TimeField("txtDeathTime","死亡时间");
	obj.cboDeathPlace = Common_ComboToDic("cboDeathPlace","死亡地点","DTHDeathAddress");
	obj.cboPregnancies = Common_ComboToDic("cboPregnancies","妊娠期或终止妊娠42天内","DTHPregnancies");
	//死亡证明明细信息
    obj.cboAReason=new Common_ComboToICD("cboAReason","(a)直接导致死亡的疾病或情况");
    obj.txtAReasonICD = Common_TextField("txtAReasonICD","ICD10");
    obj.txtAFPReason = Common_TextField("txtAFPReason","编码");
    obj.txtAInterval = Common_TextField("txtAInterval","时间间隔");
	obj.cboATime = Common_ComboToDic("cboATime","时间单位","DTHDeathTimes");
	obj.cboBReason=new Common_ComboToICD("cboBReason","(b)引起(a)的疾病或情况");
    obj.txtBReasonICD = Common_TextField("txtBReasonICD","ICD10");
    obj.txtBFPReason = Common_TextField("txtBFPReason","编码");
    obj.txtBInterval = Common_TextField("txtBInterval","时间间隔");
	obj.cboBTime = Common_ComboToDic("cboBTime","时间单位","DTHDeathTimes");
	obj.cboCReason=new Common_ComboToICD("cboCReason","(c)引起(b)的疾病或情况");
    obj.txtCReasonICD = Common_TextField("txtCReasonICD","ICD10");
    obj.txtCFPReason = Common_TextField("txtCFPReason","编码");
    obj.txtCInterval = Common_TextField("txtCInterval","时间间隔");
	obj.cboCTime = Common_ComboToDic("cboCTime","时间单位","DTHDeathTimes");
	obj.cboDReason=new Common_ComboToICD("cboDReason","(d)引起(c)的疾病或情况");
    obj.txtDReasonICD = Common_TextField("txtDReasonICD","ICD10");
    obj.txtDFPReason = Common_TextField("txtDFPReason","编码");
    obj.txtDInterval = Common_TextField("txtDInterval","时间间隔");
	obj.cboDTime = Common_ComboToDic("cboDTime","时间单位","DTHDeathTimes");
	obj.cboDamageDiagnose=new Common_ComboToICD("cboDamageDiagnose","损伤中毒诊断");
	obj.cboDamageDiagnoseICD = Common_TextField("cboDamageDiagnoseICD","ICD10");
	obj.cboOtherDiagnose = Common_ComboToICD("cboOtherDiagnose","其他诊断");
	obj.txtOtherDiagnoseICD = Common_TextField("txtOtherDiagnoseICD","ICD10");
	obj.txtOtherDiagnoseFP = Common_TextField("txtOtherDiagnoseFP","编码");
	obj.txtOtherDiagnoseInterval = Common_TextField("txtOtherDiagnoseInterval","时间间隔");
	obj.cboOtherDiagnoseTime = Common_ComboToDic("cboOtherDiagnoseTime","时间单位","DTHDeathTimes");
	obj.cboDiagnoseUnit = Common_ComboToDic("cboDiagnoseUnit","诊断单位","DTHDiagnoseUnit");
	obj.cboDiagnoseBasis = Common_ComboToDic("cboDiagnoseBasis","诊断依据","DTHDiagnoseBasis");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	//调查记录
    obj.txtExamMedical = Common_TextArea("txtExamMedical","死者生前病史及症状体征",35);
	obj.txtExamName = Common_TextField("txtExamName","被调查者");
	obj.cboExamRelation = Common_ComboToDic("cboExamRelation","与死者关系","DTHFamilyRelation");
	obj.txtExamTel = Common_TextField("txtExamTel","联系电话");
	obj.txtExamDeathReason = Common_TextField("txtExamDeathReason","死因推断");
	var DiagnoseBasisTip = new Ext.ToolTip({        
		target: obj.txtExamDeathReason,
		title:"死因推断一定是具体疾病，不可仅填写症状体征；可以填写表示推测的诊断用语。",
		trackMouse: true   
	});
	obj.txtExamUser = Common_TextField("txtExamUser","调查者");
	obj.txtExamDate = Common_DateFieldToDate("txtExamDate","调查日期");
	obj.txtExamAddress = Common_TextField("txtExamAddress","联系地址");
	
    //根本死因
	obj.cboBaseReason=new Common_ComboToICD("cboBaseReason","根本死因");
    obj.txtBaseReasonICD = Common_TextField("txtBaseReasonICD","ICD10");
	obj.cboDamage=new Common_ComboToICD("cboDamage","损伤中毒");
    obj.txtDamageICD = Common_TextField("txtDamageICD","ICD10");
	

	//上报儿童死亡报卡
	//Add By LiYang 2015-03-12
	obj.btnChildReport = new Ext.Button
	({
		id : 'btnChildReport'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,height:30
		,text : '儿童死亡报卡'
	});
	
    obj.btnReport=new Ext.Button({
        id:'btnReport'
        ,text:'上报'
        ,iconCls:'icon-save'
		,height:30
		,tooltip : DiagnoseBasisTip
    });
    
    obj.btnHelpWord=new Ext.Button({
        id:'btnHelpWord'
        ,text:'帮助文档'
        ,iconCls:'icon-help'
		,height:30
    });
    
    obj.btnPrintPatInfo=new Ext.Button({
        id:'btnPrintPatInfo'
        ,text:'打印核对信息'
        ,iconCls:'icon-print'
		,height:30
    });
    
    obj.btnSaveTmp = new Ext.Button({
		id : 'btnSaveTmp'
		,width : 75
		,text : '暂存'
        ,iconCls:'icon-temp'
		,height:30
	});
	
    obj.btnPrintOne=new Ext.Button({
        id:'btnPrintOne'
        ,text:'首联打印'
        ,iconCls:'icon-print'
		,height:30
    });
	
    obj.btnCheckOne=new Ext.Button({
        id:'btnCheckOne'
        ,text:'编码'
        ,iconCls:'icon-save'
		,height:30
    });
	
	obj.btnCheckTwo=new Ext.Button({
        id:'btnCheckTwo'
        ,text:'审核'
        ,iconCls:'icon-check'
		,height:30
    });
	
    obj.btnCancle=new Ext.Button({
        id:'btnCancle'
        ,text:'关闭'
        ,iconCls:'icon-close'
		,height:30
    });
	obj.btnDel=new Ext.Button({
        id:'btnDel'
        ,text:'作废'
        ,iconCls:'icon-delete'
		,height:30
    });
    obj.btnPrintThree=new Ext.Button({
        id:'btnPrintThree'
        ,text:'三联打印'
        ,iconCls:'icon-print'
		,height:30
    });
	
    obj.btnGrantThree=new Ext.Button({
        id:'btnGrantThree'
        ,text:'三联打印授权'
        ,iconCls:'icon-update'
		,height:30
    });
    
	obj.btnGrantOne=new Ext.Button({
        id:'btnGrantOne'
        ,text:'首联打印授权'
        ,iconCls:'icon-update'
		,height:30
    });
	
	obj.btnReturn=new Ext.Button({
        id:'btnReturn'
        ,text:'退回'
        ,iconCls:'icon-exit'
		,height:30
    });
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,buttonAlign:'center'
		,buttons : [
			obj.btnSaveTmp
			,obj.btnReport
			,obj.btnPrintPatInfo
			,obj.btnChildReport //Add By LiYang 2015-03-12 儿童死亡报卡
			,obj.btnPrintThree
			,obj.btnGrantThree
			,obj.btnCheckOne
			,obj.btnCheckTwo
			,obj.btnPrintOne
			,obj.btnGrantOne
			,obj.btnReturn
			,obj.btnDel
			,obj.btnHelpWord
			,obj.btnCancle
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
	
    InitDMReportEvent(obj);
    obj.LoadEvent();
}
//退回原因
function InitBackReason(obj)
{
	var objBackReason = new Object();
	objBackReason.ParentForm=obj;
	
	objBackReason.resumeText = new Ext.form.TextArea
	({
		id : 'resumeText'
		,height : 60
		,width:500
		,anchor : '95%'
	});
	objBackReason.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	objBackReason.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-close'
		,anchor : '95%'
		,text : '关闭'
	});
	objBackReason.mainWindow = new Ext.Window
	({
		id : 'mainWindow'
		,height : 150
		,buttonAlign : 'center'
		,width : 400
		,title : '请录入退回原因'
		,layout : 'fit'
		,modal:true
		,items : [
			objBackReason.resumeText
		]
		,buttons : [
			objBackReason.saveBtn
			,objBackReason.exitBtn
		]
	});
	
	InitBackReasonEvent(objBackReason);
	
	objBackReason.saveBtn.on("click", objBackReason.saveBtn_click, objBackReason);
	objBackReason.exitBtn.on("click", objBackReason.exitBtn_click, objBackReason);
	objBackReason.LoadEvent(arguments);
	return objBackReason;
}
//三联授权
function InitPopStorage(obj)
{
	var obj = new Object();
	obj.ParentForm=obj;
	
	obj.resumeText = new Ext.form.TextArea
	({
		id:'resumeTextId'
		,height:115
		,width:275
	});
	obj.TxtUser=new Ext.form.TextField({
	     id:'TxtReportUser'
	    ,fieldLabel:'用户名'
	    ,anchor : '80%'
	    ,width:90
	    ,allowBlank:false
	    ,allowDecimals:false
	});
	obj.TxtPassWord=new Ext.form.TextField({
	     id:'TxtPassWordId'
	    ,fieldLabel:'用户密码'
	    ,anchor : '80%'
	    ,width:90
	    ,allowBlank:false
	    ,allowDecimals:false
	    ,blankText:'请输入用户密码'
	    ,inputType: 'password'
	});
	
	obj.btnSure = new Ext.Button
	({
		id : 'btnSure'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	obj.btnExit = new Ext.Button
	({
		id : 'btnExit'
		,iconCls : 'icon-close'
		,anchor : '95%'
		,text : '关闭'
	});
	obj.mainWindow = new Ext.Window
	({
		id : 'mainWindow'
		,height : 160
		,buttonAlign :'center'
		,labelAlign:'right'
		,width : 300
		,title : '补打用户签名'
		,padding:5
		,layout:'form'
		,modal:true
		,items : [
			 obj.TxtUser
			,obj.TxtPassWord
		]
		,buttons : [
			obj.btnSure
		   ,obj.btnExit
		]
	});
	
   InitPopStorageEvent(obj);
   obj.LoadEvent();
	return obj;
}
//首联授权
function InitPopStorageTwo(obj)
{
	var obj = new Object();
	obj.ParentForm=obj;
	
	obj.resumeText = new Ext.form.TextArea
	({
		id:'resumeTextId'
		,height:115
		,width:275
	});
	obj.TxtUser=new Ext.form.TextField({
	     id:'TxtReportUser'
	    ,fieldLabel:'用户名'
	    ,anchor : '80%'
	    ,width:90
	    ,allowBlank:false
	    ,allowDecimals:false
	});
	obj.TxtPassWord=new Ext.form.TextField({
	     id:'TxtPassWordId'
	    ,fieldLabel:'用户密码'
	    ,anchor : '80%'
	    ,width:90
	    ,allowBlank:false
	    ,allowDecimals:false
	    ,blankText:'请输入用户密码'
	    ,inputType: 'password'
	});
	
	obj.btnSure = new Ext.Button
	({
		id : 'btnSureId'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	obj.btnExit = new Ext.Button
	({
		id : 'btnExitId'
		,iconCls : 'icon-close'
		,anchor : '95%'
		,text : '关闭'
	});
	obj.mainWindow = new Ext.Window
	({
		id : 'mainWindow'
		,height : 160
		,buttonAlign :'center'
		,labelAlign:'right'
		,width : 300
		,title : '补打授权用户签名'
		,padding:5
		,layout:'form'
		,modal:true
		,items : [
			 obj.TxtUser
			,obj.TxtPassWord
		]
		,buttons : [
			obj.btnSure
		   ,obj.btnExit
		]
	});
	
   InitPopStorageTwoEvent(obj);
   obj.LoadEvent();
	return obj;
}
//三联打印原因
function InitPrintReason(obj)
{
	var objPrintReason = new Object();
	objPrintReason.ParentForm=obj;
	
	objPrintReason.resumeText = new Ext.form.TextArea
	({
		id : 'resumeText'
		,height : 60
		,width:500
		,anchor : '95%'
		,html:"补打原因：家属姓名：家属身份证号：补打三联中的哪联："
	});
	objPrintReason.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
	});
	objPrintReason.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-close'
		,anchor : '95%'
		,text : '关闭'
	});
	objPrintReason.mainWindow = new Ext.Window
	({
		id : 'mainWindow'
		,height : 150
		,buttonAlign : 'center'
		,width : 400
		,title : '请输入重复打印原因'
		,layout : 'fit'
		,modal:true
		,items : [
			objPrintReason.resumeText
		]
		,buttons : [
			 objPrintReason.saveBtn
			,objPrintReason.exitBtn
		]
	});
	
	InitPrintReasonEvent(objPrintReason);
	
	objPrintReason.saveBtn.on("click", objPrintReason.saveBtn_click, objPrintReason);
	objPrintReason.exitBtn.on("click", objPrintReason.exitBtn_click, objPrintReason);
	objPrintReason.LoadEvent(arguments);
	return objPrintReason;
}
//首联打印原因
function InitTPrintReason(obj)
{
	var objTPrintReason = new Object();
	objTPrintReason.ParentForm=obj;
	
	objTPrintReason.resumeText = new Ext.form.TextArea
	({
		id : 'resumeText'
		,height : 60
		,width:500
		,anchor : '95%'
	});
	objTPrintReason.saveBtn = new Ext.Button
	({
		id : 'saveBtn'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
	});
	objTPrintReason.exitBtn = new Ext.Button
	({
		id : 'exitBtn'
		,iconCls : 'icon-close'
		,anchor : '95%'
		,text : '关闭'
	});
	objTPrintReason.mainWindow = new Ext.Window
	({
		id : 'mainWindow'
		,height : 150
		,buttonAlign : 'center'
		,width : 400
		,title : '请输入重复打印原因'
		,layout : 'fit'
		,modal:true
		,items : [
			objTPrintReason.resumeText
		]
		,buttons : [
			 objTPrintReason.saveBtn
			,objTPrintReason.exitBtn
		]
	});
	
	InitTPrintReasonEvent(objTPrintReason);
	
	objTPrintReason.saveBtn.on("click", objTPrintReason.saveBtn_click, objTPrintReason);
	objTPrintReason.exitBtn.on("click", objTPrintReason.exitBtn_click, objTPrintReason);
	objTPrintReason.LoadEvent(arguments);
	return objTPrintReason;
}
