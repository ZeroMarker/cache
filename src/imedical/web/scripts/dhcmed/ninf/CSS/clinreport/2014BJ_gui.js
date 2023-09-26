var objScreen = new Object();
function InitCSSReport(){
    var obj = objScreen;
	obj.InfFlag = 0;
	obj.LabFlag = 0;
	obj.AntiFlag = 0;
	obj.OperFlag = 0;
	
	var htmlMainPanel = ''
		+ '<table class="table_CSSreport" align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;">'
		+ '		<span style="font-size:28px;"><b>横断面调查表</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style="font-size:16px;"><b>一般情况</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;"><font color="red">*</font>科室</div></td><td><div id="TD-cboLoc" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><font color="red">*</font>床号</div></td><td><div id="TD-txtBed" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><font color="red">*</font>病例号</div></td><td><div id="TD-txtMRNo" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><font color="red">*</font>入院日期</div></td><td><div id="TD-txtAdmDate" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;"><font color="red">*</font>姓名</div></td><td><div id="TD-txtName" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><font color="red">*</font>性别</div></td><td><div id="TD-cbgSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><font color="red">*</font>年龄</div></td>'
		+ '				<td><div id="TD-txtAgeY" style="width:50px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">岁</div></td>'
		+ '				<td><div id="TD-txtAgeM" style="width:50px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">月</div></td>'
		+ '				<td><div id="TD-txtAgeD" style="width:50px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">天</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>基础疾病诊断 </div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">（1）</div></td><td><div id="TD-txtDiagnos1" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">（2）</div></td><td><div id="TD-txtDiagnos2" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">（3）</div></td><td><div id="TD-txtDiagnos3" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:235px;text-align:right;overflow:hidden;"><font color="red">*</font>过去24小时内是否有≥3次的腹泻：</div></td><td><div id="TD-cbgAddOns4" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style="font-size:16px;"><b>感染情况</b></span>'
		+ '		<span onclick="objScreen.LabInfoDiv_expand();" style="font-size:16px;color:red;">显示本次住院病原体检查菌情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-LabInfo" style="width=100%;heigth=200px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>医院感染</div></td><td><div id="TD-cbgIsInfection" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">医院感染部位</div></td>'
		+ '				<td><div style="width:160px;text-align:right;overflow:hidden;">感染日期(年月日)</div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">病原体：</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">1.</div></td><td><div id="TD-cboInfPos1" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:right;overflow:hidden;">1.</div></td><td><div id="TD-txtInfDate1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtPathogen1A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtPathogen1B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtPathogen1C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">2.</div></td><td><div id="TD-cboInfPos2" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:right;overflow:hidden;">2.</div></td><td><div id="TD-txtInfDate2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtPathogen2A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtPathogen2B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtPathogen2C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">3.</div></td><td><div id="TD-cboInfPos3" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:right;overflow:hidden;">3.</div></td><td><div id="TD-txtInfDate3" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtPathogen3A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtPathogen3B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtPathogen3C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style="font-size:16px;"><b>抗菌药物使用情况</b></span>'
		+ '		<span onclick="objScreen.AntiInfoDiv_expand();" style="font-size:16px;color:red;">显示本次住院抗菌药物使用情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-AntiInfo" style="width=100%;heigth=200px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;"><font color="red">*</font>抗菌药物使用</div></td><td><div id="TD-cbgAnti1" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">目的</div></td><td><div id="TD-cbgAnti2" style="width:300px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">联用</div></td><td><div id="TD-cbgAnti3" style="width:380px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">治疗用药前后送细菌培养</div></td><td><div id="TD-cbgAnti4" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style="font-size:16px;"><b>手术相关情况</b></span>'
		+ '		<span onclick="objScreen.OperInfoDiv_expand();" style="font-size:16px;color:red;">显示本次住院手术情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-OperInfo" style="width=100%;heigth=50px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;"><font color="red">*</font>手术</div></td><td><div id="TD-cbgOper1" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">术前应用抗菌药物</div></td><td><div id="TD-cbgOper2" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">手术切口等级</div></td><td><div id="TD-cbgOper3" style="width:430px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">Ⅰ、Ⅱ级切口围手术期用药</div></td><td><div id="TD-cbgOper4" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span style="font-size:16px;"><b>侵袭性操作相关情况</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">动静脉插管</div></td><td><div id="TD-cbgAddOns1" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">泌尿道插管</div></td><td><div id="TD-cbgAddOns2" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:190px;text-align:right;overflow:hidden;">使用呼吸机</div></td><td><div id="TD-cbgAddOns3" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><b>调查者</b></div></td><td><div id="TD-txtSurvUser" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><b>调查日期</b></div></td><td><div id="TD-txtSurvDate" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><b>调查科室</b></div></td><td><div id="TD-txtSurvLoc" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		+ '</tr></table>'
	
	obj.cboLoc         = Common_ComboToDic("cboLoc","科室","NINFCSSLoc")
	obj.txtBed         = Common_TextField("txtBed","床位")
	obj.txtMRNo        = Common_TextField("txtMRNo","病案号")
	obj.txtAdmDate     = Common_TextField("txtAdmDate","入院日期")
	obj.txtName        = Common_TextField("txtName","姓名")
	obj.cbgSex         = Common_RadioGroupToDic("cbgSex","性别","NINFCSSSex",2)
	obj.txtAgeY        = Common_TextFieldToFormat("txtAgeY","年龄-岁")
	obj.txtAgeM        = Common_TextFieldToFormat("txtAgeM","年龄-月")
	obj.txtAgeD        = Common_TextFieldToFormat("txtAgeD","年龄-天")
	//Common_SetDisabled("cboLoc",true);
	Common_SetDisabled("txtBed",true);
	Common_SetDisabled("txtMRNo",true);
	Common_SetDisabled("txtAdmDate",true);
	Common_SetDisabled("txtName",true);
	Common_SetDisabled("cbgSex",true);
	Common_SetDisabled("txtAgeY",true);
	Common_SetDisabled("txtAgeM",true);
	Common_SetDisabled("txtAgeD",true);
	obj.txtDiagnos1    = Common_TextField("txtDiagnos1","基础疾病诊断1")
	obj.txtDiagnos2    = Common_TextField("txtDiagnos2","基础疾病诊断2")
	obj.txtDiagnos3    = Common_TextField("txtDiagnos3","基础疾病诊断3")
	obj.cbgAddOns4     = Common_RadioGroupToDic("cbgAddOns4","过去24小时内是否有≥3次的腹泻","NINFCSSBoolean",2)
	obj.cbgIsInfection = Common_RadioGroupToDic("cbgIsInfection","是否感染","NINFCSSBoolean",2)
	obj.cboInfPos1     = Common_ComboToDic("cboInfPos1","感染部位","NINFCSSInfPos")
	obj.txtInfDate1    = Common_DateFieldToDate("txtInfDate1","感染日期")
	obj.txtPathogen1A  = Common_TextField("txtPathogen1A","病原体")
	obj.txtPathogen1B  = Common_TextField("txtPathogen1B","病原体")
	obj.txtPathogen1C  = Common_TextField("txtPathogen1C","病原体")
	obj.cboInfPos2     = Common_ComboToDic("cboInfPos2","感染部位","NINFCSSInfPos")
	obj.txtInfDate2    = Common_DateFieldToDate("txtInfDate2","感染日期")
	obj.txtPathogen2A  = Common_TextField("txtPathogen2A","病原体")
	obj.txtPathogen2B  = Common_TextField("txtPathogen2B","病原体")
	obj.txtPathogen2C  = Common_TextField("txtPathogen2C","病原体")
	obj.cboInfPos3     = Common_ComboToDic("cboInfPos3","感染部位","NINFCSSInfPos")
	obj.txtInfDate3    = Common_DateFieldToDate("txtInfDate3","感染日期")
	obj.txtPathogen3A  = Common_TextField("txtPathogen3A","病原体")
	obj.txtPathogen3B  = Common_TextField("txtPathogen3B","病原体")
	obj.txtPathogen3C  = Common_TextField("txtPathogen3C","病原体")
	obj.cbgAnti1       = Common_RadioGroupToDic("cbgAnti1","抗菌药物使用","NINFCSSBoolean",2)
	obj.cbgAnti2       = Common_RadioGroupToDic("cbgAnti2","目的","NINFCSSMedObj",3)
	obj.cbgAnti3       = Common_RadioGroupToDic("cbgAnti3","联用","NINFCSSDrugCom",4)
	obj.cbgAnti4       = Common_RadioGroupToDic("cbgAnti4","治疗用药前后送细菌培养","NINFCSSBoolean",2)
	obj.cbgOper1       = Common_RadioGroupToDic("cbgOper1","手术","NINFCSSBoolean",2)
	obj.cbgOper2       = Common_RadioGroupToDic("cbgOper2","术前应用抗菌药物","NINFCSSBoolean",2)
	obj.cbgOper3       = Common_RadioGroupToDic("cbgOper3","手术切口等级","NINFCSSOperCut",5)
	obj.cbgOper4       = Common_RadioGroupToDic("cbgOper4","Ⅰ、Ⅱ级切口围手术期用药","NINFCSSBoolean",2)
	obj.cbgAddOns1     = Common_RadioGroupToDic("cbgAddOns1","动静脉插管","NINFCSSBoolean",2)
	obj.cbgAddOns2     = Common_RadioGroupToDic("cbgAddOns2","泌尿道插管","NINFCSSBoolean",2)
	obj.cbgAddOns3     = Common_RadioGroupToDic("cbgAddOns3","使用呼吸机","NINFCSSBoolean",2)
	obj.txtSurvDate    = Common_TextField("txtSurvDate","调查日期")
	obj.txtSurvLoc     = Common_TextField("txtSurvLoc","调查科室")
	obj.txtSurvUser    = Common_TextField("txtSurvUser","调查人")
	Common_SetDisabled("txtSurvDate",true);
	Common_SetDisabled("txtSurvLoc",true);
	Common_SetDisabled("txtSurvUser",true);
	
	obj.LabTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="20%">医嘱名称</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="20%">检验项目</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">送检时间</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">标本</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="30%">检出菌</td>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{OEItemDesc}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{TestDesc}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{SubmissionDate}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{Specimen}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{Pathogeny}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	
	obj.AntiTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="35%">抗生素名称</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">开始日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">停止日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">频次</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">途径</td>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{ArcimDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{SttDate}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{XDate}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{PHCFreq}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{PHCInstr}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	
	obj.OperTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="35%">手术名称</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">类型</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">手术日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">术者</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">切口类型</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">麻醉方式</td>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{OperDesc}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{OperType}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{OperDate}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{DocName}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{CutGrade}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{Anesthesia}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	
	obj.btnReport=new Ext.Button({
		id:'btnReport'
		,text:'保存'
		,iconCls:'icon-save'
		,height:30
	});
    
	obj.btnPrint=new Ext.Button({
		id:'btnPrint'
		,text:'打印'
		,iconCls:'icon-print'
		,height:30
	});
    
	obj.btnClose=new Ext.Button({
		id:'btnClose'
		,text:'关闭'
		,iconCls:'icon-close'
		,height:30
	});
    
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,buttonAlign:'center'
		,buttons : [
			obj.btnReport
			,obj.btnPrint
			,obj.btnClose
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
	
    InitCSSReportEvent(obj);
    obj.LoadEvent();
}