function InitSmdDischage(obj)
{
	//社会危害
	obj.txtCause 	    = Common_TextField("txtCause","轻度滋事次数");
	obj.txtCause1 	    = Common_TextField("txtCause1","肇事次数");
	obj.txtCause2 	    = Common_TextField("txtCause2","肇祸次数");
	obj.txtCause3 	    = Common_TextField("txtCause3","其它危害行为次数");
	obj.txtCause4 	    = Common_TextField("txtCause4","自伤次数");
	obj.txtCause5	    = Common_TextField("txtCause5","自杀未遂次数");
	obj.txtCauseNote    = Common_TextField("txtCauseNote","其他需要说明的特殊情况");

	//既往治疗
	obj.cbgOPTreatment 	= Common_RadioGroupToDic("cbgOPTreatment","门诊治疗情况","SMDOPTreatment",3);
	obj.txtTreatTimes   = Common_TextField("txtTreatTimes","既往住院次数");
	obj.txtFDTreatDate  = Common_DateFieldToDate("txtFDTreatDate","首次抗精神病药物治疗时间");
	
	//住院治疗
	obj.cboPrognosis 	= Common_ComboToDic("cboPrognosis","住院疗效","SMDPrognosis");
	obj.cbgTreatMeasure = Common_CheckboxGroupToDic("cbgTreatMeasure","本次住院康复措施","SMDRehabMeasure",5);
	obj.txtTreatMeasureTxt = Common_TextField("txtTreatMeasureTxt","本次住院康复措施其他");
	obj.cbgIsFunding    = Common_RadioGroupToDic("cbgIsFunding","本次住院是否获得经费补助","SMDIsFunding",2);
	obj.cbgFundsType    = Common_RadioGroupToDic("cbgFundsType","经费补助类型","SMDFundsType",2);
	obj.cbgFundsSource  = Common_RadioGroupToDic("cbgFundsSource","经费来源","SMDFundsSource",4);
	obj.txtFundsSource 	= Common_TextField("txtFundsSource","经济来源其他");
	obj.cboTreatDrug1 = Common_ComboToPsychDrug("cboTreatDrug1","住院用药1");
	obj.cboTreatDrug2 = Common_ComboToPsychDrug("cboTreatDrug2","住院用药2");
	obj.cboTreatDrug3 = Common_ComboToPsychDrug("cboTreatDrug3","住院用药3");
	obj.cboTreatInst1 = Common_ComboToDic("cboTreatInst1","用法1","SMDPsychDrugFreq");
	obj.cboTreatInst2 = Common_ComboToDic("cboTreatInst2","用法2","SMDPsychDrugFreq");
	obj.cboTreatInst3 = Common_ComboToDic("cboTreatInst3","用法3","SMDPsychDrugFreq");
	obj.txtTreatDoseQty1 = Common_TextField("txtTreatDoseQty1","剂量1");
	obj.txtTreatDoseQty2 = Common_TextField("txtTreatDoseQty2","剂量2");
	obj.txtTreatDoseQty3 = Common_TextField("txtTreatDoseQty3","剂量3");
	obj.cboTreatDoseUnit1 = Common_ComboToDic("cboTreatDoseUnit1","剂量单位1","SMDPsychDrugUnit");
	obj.cboTreatDoseUnit2 = Common_ComboToDic("cboTreatDoseUnit2","剂量单位2","SMDPsychDrugUnit");
	obj.cboTreatDoseUnit3 = Common_ComboToDic("cboTreatDoseUnit3","剂量单位3","SMDPsychDrugUnit");
	
	//康复治疗
	obj.cbgRehabMeasure = Common_CheckboxGroupToDic("cbgRehabMeasure","康复措施","SMDRehabMeasure",5);
	obj.txtRehabMeasureTxt = Common_TextField("txtRehabMeasureTxt","康复措施备注");
	obj.txtRehabResume  = Common_TextField("txtRehabResume","其他注意事项");
	obj.cboRehabDrug1 = Common_ComboToPsychDrug("cboRehabDrug1","康复用药1");
	obj.cboRehabDrug2 = Common_ComboToPsychDrug("cboRehabDrug2","康复用药2");
	obj.cboRehabDrug3 = Common_ComboToPsychDrug("cboRehabDrug3","康复用药3");
	obj.cboRehabInst1 = Common_ComboToDic("cboRehabInst1","用法1","SMDPsychDrugFreq");
	obj.cboRehabInst2 = Common_ComboToDic("cboRehabInst2","用法2","SMDPsychDrugFreq");
	obj.cboRehabInst3 = Common_ComboToDic("cboRehabInst3","用法3","SMDPsychDrugFreq");
	obj.txtRehabDoseQty1 = Common_TextField("txtRehabDoseQty1","剂量1");
	obj.txtRehabDoseQty2 = Common_TextField("txtRehabDoseQty2","剂量2");
	obj.txtRehabDoseQty3 = Common_TextField("txtRehabDoseQty3","剂量3");
	obj.cboRehabDoseUnit1 = Common_ComboToDic("cboRehabDoseUnit1","剂量单位1","SMDPsychDrugUnit");
	obj.cboRehabDoseUnit2 = Common_ComboToDic("cboRehabDoseUnit2","剂量单位2","SMDPsychDrugUnit");
	obj.cboRehabDoseUnit3 = Common_ComboToDic("cboRehabDoseUnit3","剂量单位3","SMDPsychDrugUnit");
	
	//精神症状
	var htmlSymptom = '<table style="font-size:14px;"><tr>'
	var strDicList = ExtTool.RunServerMethod("DHCMed.SSService.DictionarySrv","GetDicsByType",'SMDSymptom');
	var dicList = strDicList.split(String.fromCharCode(1));
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		if (dicList[dicIndex] == '') continue;
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		
		var strSymptom = ExtTool.RunServerMethod("DHCMed.SMD.Symptom","GetStringByCat",dicSubList[0]);
		if (strSymptom == '') continue;
		var rowIndex = obj.cbgSymptoms.length;
		obj.cbgSymptoms[rowIndex] = Common_CheckboxGroupToStr("cbgSymptoms" + rowIndex,dicSubList[1],strSymptom,5);
		
		if (rowIndex>0) htmlSymptom += '</tr><tr>'
		if (dicIndex<6){
			htmlSymptom += '<td style="border-bottom:1px #84C1FF solid;"><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>' + dicSubList[1] + '</div></td><td style="border-bottom:1px #84C1FF solid;"><div id="td_cbgSymptoms' + rowIndex + '" style="width:1060px;overflow:hidden;"></div></td>'
		}else{
		htmlSymptom += '<td style="border-bottom:1px #84C1FF solid;"><div style="width:100px;text-align:right;overflow:hidden;">' + dicSubList[1] + '</div></td><td style="border-bottom:1px #84C1FF solid;"><div id="td_cbgSymptoms' + rowIndex + '" style="width:1060px;overflow:hidden;"></div></td>'
		}
	}
	htmlSymptom += '</tr></table>'
	
	//页面布局
	obj.HtmlSubPanel = ''
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>基本信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">卡片编号</div></td><td><div id="td_txtCardNo" style="width:204px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:left;">'
		+ '				<span id="Spanid" style="font-size:20px;color:red;"><b>' + obj.RepStatus + '</b></span>'    //fix bug报告状态不能及时更新
		+ '				</div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>常住类型</span></div></td><td><div id="td_cbgLocal" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>患者姓名</span></div></td><td><div id="td_txtPatName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>性别</span></div></td><td><div id="td_txtSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>出生日期</span></div></td><td><div id="td_txtBirthday" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>民族</span></div></td><td><div id="td_txtNation" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>身份证号</span></div></td><td><div id="td_txtPersonalID" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>联系人姓名</span></div></td><td><div id="td_txtContactor" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>联系人电话</span></div></td><td><div id="td_txtContactorTel" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>家庭电话</span></div></td><td><div id="td_txtHomeTel" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>户籍地类型</span></div></td><td><div id="td_cboRegAddType" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span><font color="red">*</font>现住址类型</span></div></td><td><div id="td_cboCurrAddType" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>户籍地 省</span></div></td><td><div id="td_cboRegProvince" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>市</span></div></td><td><div id="td_cboRegCity" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>区</span></div></td><td><div id="td_cboRegCounty" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>乡镇(街道)</span></div></td><td><div id="td_cboRegVillage" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>村(居委会)</span></div></td><td><div id="td_txtRegRoad" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:left;overflow:hidden;">(详至门牌号)</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>现住址 省</span></div></td><td><div id="td_cboCurrProvince" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>市</span></div></td><td><div id="td_cboCurrCity" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>区</span></div></td><td><div id="td_cboCurrCounty" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>乡镇(街道)</span></div></td><td><div id="td_cboCurrVillage" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>村(居委会)</span></div></td><td><div id="td_txtCurrRoad" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:left;overflow:hidden;">(详至门牌号)</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>患者发病情况</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>初次发病时间</span></div></td><td><div id="td_txtSickDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:210px;height:25px;text-align:left;overflow:hidden;">(患者首次出现精神症状的时间)</div></td>'
		+ '				<td><div style="width:90px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>入院日期</span></div></td><td><div id="td_txtAdmitDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>出院日期</span></div></td><td><div id="td_txtDischDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次住院原因</span></div></td><td><div id="td_cbgAdmitReason" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>精神症状</b>（选以下项目，可多选）</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ htmlSymptom  //精神症状页面元素
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>患者对家庭社会的影响</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">轻度滋事</div></td><td><div id="td_txtCause" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;height:25px;text-align:left;overflow:hidden;">次</div></td>'
		+ '				<td><div style="width:80px;height:25px;text-align:right;overflow:hidden;">肇事</div></td><td><div id="td_txtCause1" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;height:25px;text-align:left;overflow:hidden;">次</div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">肇祸</div></td><td><div id="td_txtCause2" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;height:25px;text-align:left;overflow:hidden;">次</div></td>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">其它危害行为</div></td><td><div id="td_txtCause3" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;height:25px;text-align:left;overflow:hidden;">次</div></td>'
		+ '				<td><div style="width:80px;height:25px;text-align:right;overflow:hidden;">自伤</div></td><td><div id="td_txtCause4" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;height:25px;text-align:left;overflow:hidden;">次</div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">自杀未遂</div></td><td><div id="td_txtCause5" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;height:25px;text-align:left;overflow:hidden;">次</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:198px;height:25px;text-align:right;overflow:hidden;">其他需要说明的特殊情况</div></td><td><div id="td_txtCauseNote" style="width:300px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>既往治疗情况</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>门诊(单选)</span></div></td><td><div id="td_cbgOPTreatment" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:180px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>首次抗精神病药治疗时间</span></div></td><td><div id="td_txtFDTreatDate" style="width:100px;overflow:hidden;"></div></td>'
	
		+ '				<td><div style="width:300px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>住院曾住精神专科医院/综合医院精神科</span></div></td><td><div id="td_txtTreatTimes" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;height:25px;text-align:left;overflow:hidden;">次（含此次住院）</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>住院治疗情况</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">门诊病案号</div></td><td><div id="td_txtOPMrNo" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">住院病案号</div></td><td><div id="td_txtIPMrNo" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>医疗付费方式</span></div></td><td><div id="td_cboPayment" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">医保号/新农合号</div></td><td><div id="td_txtInsurNo" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>疾病名称</span></div></td><td><div id="td_cboDisease" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">ICD10编码</div></td><td><div id="td_txtDiseaseICD" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>确诊日期</span></div></td><td><div id="td_txtDiagDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;"><font color="red">*</font>住院用药药物1</div></td>'
		+ '				<td><div id="td_cboTreatDrug1" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">频次</div></td>'
		+ '				<td><div id="td_cboTreatInst1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">剂量</div></td>'
		+ '				<td><div id="td_txtTreatDoseQty1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">单位</div></td>'
		+ '				<td><div id="td_cboTreatDoseUnit1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:left;overflow:hidden;"></div></td>'
		+ '			</tr><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">药物2</div></td>'
		+ '				<td><div id="td_cboTreatDrug2" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">频次</div></td>'
		+ '				<td><div id="td_cboTreatInst2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">剂量</div></td>'
		+ '				<td><div id="td_txtTreatDoseQty2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">单位</div></td>'
		+ '				<td><div id="td_cboTreatDoseUnit2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:left;overflow:hidden;"></div></td>'
		+ '			</tr><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">药物3</div></td>'
		+ '				<td><div id="td_cboTreatDrug3" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">频次</div></td>'
		+ '				<td><div id="td_cboTreatInst3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">剂量</div></td>'
		+ '				<td><div id="td_txtTreatDoseQty3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">单位</div></td>'
		+ '				<td><div id="td_cboTreatDoseUnit3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:left;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font><b>住院疗效(单选)</div></td><td><div id="td_cboPrognosis" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:200px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次住院康复措施(多选)</span></div></td><td><div id="td_cbgTreatMeasure" style="width:500px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;height:25px;text-align:right;overflow:hidden;">其他</div></td><td><div id="td_txtTreatMeasureTxt" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:200px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>本次住院是否获得经费补助</span></div></td><td><div id="td_cbgIsFunding" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;"> (单选)</div></td><td><div id="td_cbgFundsType" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:300px;height:25px;text-align:right;overflow:hidden;">（若选“有”，此项必填*）经费来源（单选）</div></td><td><div id="td_cbgFundsSource" style="width:400px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;height:25px;text-align:right;overflow:hidden;">其他</div></td><td><div id="td_txtFundsSource" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>下一步治疗方案及康复建议</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;"><font color="red">*</font>住院用药药物1</div></td>'
		+ '				<td><div id="td_cboRehabDrug1" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">频次</div></td>'
		+ '				<td><div id="td_cboRehabInst1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">剂量</div></td>'
		+ '				<td><div id="td_txtRehabDoseQty1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">单位</div></td>'
		+ '				<td><div id="td_cboRehabDoseUnit1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:left;overflow:hidden;"></div></td>'
		+ '			</tr><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">药物2</div></td>'
		+ '				<td><div id="td_cboRehabDrug2" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">频次</div></td>'
		+ '				<td><div id="td_cboRehabInst2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">剂量</div></td>'
		+ '				<td><div id="td_txtRehabDoseQty2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">单位</div></td>'
		+ '				<td><div id="td_cboRehabDoseUnit2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:left;overflow:hidden;"></div></td>'
		+ '			</tr><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">药物3</div></td>'
		+ '				<td><div id="td_cboRehabDrug3" style="width:240px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">频次</div></td>'
		+ '				<td><div id="td_cboRehabInst3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;height:25px;text-align:right;overflow:hidden;">剂量</div></td>'
		+ '				<td><div id="td_txtRehabDoseQty3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">单位</div></td>'
		+ '				<td><div id="td_cboRehabDoseUnit3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:left;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:150px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>康复措施（多选）</span></div></td><td><div id="td_cbgRehabMeasure" style="width:450px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;height:25px;text-align:right;overflow:hidden;">其他</div></td><td><div id="td_txtRehabMeasureTxt" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;height:25px;text-align:right;overflow:hidden;">其他注意事项</div></td><td><div id="td_txtRehabResume" style="width:445px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style=""><b>报告信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:75px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>填卡医师</span></div></td><td><div id="td_txtRepUser" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>填卡日期</span></div></td><td><div id="td_txtRepDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>报告科室</span></div></td><td><div id="td_txtRepLoc" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;height:25px;text-align:right;overflow:hidden;"><span><font color="red">*</font>科室电话</span></div></td><td><div id="td_txtRepLocTel" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;height:25px;text-align:right;overflow:hidden;">录入人</div></td><td><div id="td_txtCheckUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:75px;height:25px;text-align:right;overflow:hidden;">录入日期</div></td><td><div id="td_txtCheckDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '     </table>';  //Add By LiYang 2015-01-13 不全TABLE标记，解决屏幕在相应用户事件时闪烁或者内容消失的问题。
	
	return obj;
}