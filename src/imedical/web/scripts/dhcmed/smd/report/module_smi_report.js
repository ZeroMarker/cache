﻿function InitSmiReport(obj)
{
	//页面布局
	obj.HtmlSubPanel = ''
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>基本信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;">卡片编号</div></td><td><div id="td_txtCardNo" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td width="100%"><div style="width=100%;text-align:left;">'
		+ '				<span id="Spanid" style="font-size:20px;color:red;"><b>' + obj.RepStatus + '</b></span>'  //fix bug报告状态不能及时更新
		+ '				</div></td>'
		+ '			</tr></table>'
		//+ '			<table><tr>'
		//+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次入院原因</span></div></td><td><div id="td_cbgAdmitReason" style="width:450px;overflow:hidden;"></div></td>'
		//+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>患者类型</span></div></td><td><div id="td_cbgPatType" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>报卡类型</span></div></td><td><div id="td_cbgAdmType" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>完整性</span></div></td><td><div id="td_cbgIsComplete" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:85px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次入院时间</span></div></td><td><div id="td_txtAdmitDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><font color="red">*</font>患者姓名</div></td><td><div id="td_txtPatName" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span><font color="red">*</font>性别</span></div></td><td><div id="td_txtSex" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:85px;text-align:right;overflow:hidden;"><span><font color="red">*</font>出生日期</span></div></td><td><div id="td_txtBirthday" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>身份证号</span></div></td><td><div id="td_txtPersonalID" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>联系人姓名</span></div></td><td><div id="td_txtContactor" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>联系人电话</span></div></td><td><div id="td_txtContactorTel" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;">工作单位</div></td><td><div id="td_txtCompany" style="width:300px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">单位电话</div></td><td><div id="td_txtCompanyTel" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>人员属地</span></div></td><td><div id="td_cbgLocal" style="width:500px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>户籍地 省</span></div></td><td><div id="td_cboRegProvince" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:18px;text-align:right;overflow:hidden;"><span><font color="red">*</font>市</span></div></td><td><div id="td_cboRegCity" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:18px;text-align:right;overflow:hidden;"><span><font color="red">*</font>区</span></div></td><td><div id="td_cboRegCounty" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;"><span><font color="red">*</font>乡镇(街道)</span></div></td><td><div id="td_cboRegVillage" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>村(居委会)</span></div></td><td><div id="td_txtRegRoad" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:left;overflow:hidden;">(详至门牌号)</div></td>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;"><span><font color="red">*</font>户籍地类型</span></div></td><td><div id="td_cboRegAddType" style="width:227px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>现住址 省</span></div></td><td><div id="td_cboCurrProvince" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:18px;text-align:right;overflow:hidden;"><span><font color="red">*</font>市</span></div></td><td><div id="td_cboCurrCity" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:18px;text-align:right;overflow:hidden;"><span><font color="red">*</font>区</span></div></td><td><div id="td_cboCurrCounty" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;"><span><font color="red">*</font>乡镇(街道)</span></div></td><td><div id="td_cboCurrVillage" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>村(居委会)</span></div></td><td><div id="td_txtCurrRoad" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:left;overflow:hidden;">(详至门牌号)</div></td>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;"><span><font color="red">*</font>现住址类型</span></div></td><td><div id="td_cboCurrAddType" style="width:227px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>职业类别</span></div></td><td><div id="td_cboOccupation" style="width:330px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>发病信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>初次发病时间</span></div></td><td><div id="td_txtSickDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:200px;text-align:left;overflow:hidden;">(患者首次出现精神症状的时间)</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>送诊主体(多选)</span></div></td><td><div id="td_cbgReferral" style="width:400px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">其他备注</div></td><td><div id="td_txtReferralTxt" style="width:120px;overflow:hidden;"></div></td>'  //送诊主体其他
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次确诊医院</span></div></td><td><div id="td_txtDiagHospital" style="width:230px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次确诊日期</span></div></td><td><div id="td_txtDiagDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>疾病名称</span></div></td><td><div id="td_cboDisease" style="width:230px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;">ICD10编码</div></td><td><div id="td_txtDiseaseICD" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;">备注</div></td><td><div id="td_txtResume" style="width:500px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>报告信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>报告科室</span></div></td><td><div id="td_txtRepLoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>科室电话</span></div></td><td><div id="td_txtRepLocTel" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>填卡医师</span></div></td><td><div id="td_txtRepUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;"><span><font color="red">*</font>填卡日期</span></div></td><td><div id="td_txtRepDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;">录入人</div></td><td><div id="td_txtCheckUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;text-align:right;overflow:hidden;">录入日期</div></td><td><div id="td_txtCheckDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
	
	obj.CheckReport = function(){
		
	}
	
	return obj;
}