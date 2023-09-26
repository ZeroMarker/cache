var objScreen = new Object();
function InitCSSReport(){
    var obj = objScreen;
	obj.InfFlag = 0;
	obj.LabFlag = 0;
	obj.AntiFlag = 0;
	obj.OperFlag = 0;
	obj.BugsFlag = 0;
	
	var clientHeight = document.body.clientHeight - 15;
	var clientWidth = document.body.clientWidth - 15;
	var htmlMainPanel = ''
		+ '<div style="overflow-y:auto;width:' + clientWidth + 'px;height:' + clientHeight + 'px">'
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;">'
		+ '		<span style="font-size:28px;"><b>横断面调查表</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>一般情况</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">病人编号：</div></td><td><div id="TD-txtPatNo" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">科室：</div></td><td><div id="TD-cboLoc" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">床号：</div></td><td><div id="TD-txtBed" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">病历号：</div></td><td><div id="TD-txtMRNo" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">姓名：</div></td><td><div id="TD-txtName" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">性别：</div></td><td><div id="TD-cbgSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">年龄：</div></td>'
		+ '				<td><div id="TD-txtAgeY" style="width:50px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">岁</div></td>'
		+ '				<td><div id="TD-txtAgeM" style="width:50px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">月</div></td>'
		+ '				<td><div id="TD-txtAgeD" style="width:50px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">天</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">基础疾病诊断：</div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">（1）</div></td><td><div id="TD-txtDiagnos1" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">（2）</div></td><td><div id="TD-txtDiagnos2" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">（3）</div></td><td><div id="TD-txtDiagnos3" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>手术情况</b></span>'
		+ '		<span onclick="objScreen.OperInfoDiv_expand();" style="font-size:16px;color=red;">显示本次住院手术情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-OperInfo" style="width=100%;heigth=50px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">手术：</div></td><td><div id="TD-cbgOper1" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">切口类型：</div></td><td><div id="TD-cbgOper3" style="width:430px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>感染情况（包括医院感染与社区感染）</b></span>'
		+ '		<span onclick="objScreen.LabInfoDiv_expand();" style="font-size:16px;color=red;">显示本次住院病原体检查菌情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-LabInfo" style="width=100%;heigth=200px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">感染：</div></td><td><div id="TD-cbgIsInfection" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">感染分类：</div></td><td><div id="TD-cbgInfCategory" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:140px;text-align:right;overflow:hidden;">医院感染部位：</div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">病原体：</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">1.</div></td><td><div id="TD-cboInfPos1" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtPathogen1A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtPathogen1B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtPathogen1C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">2.</div></td><td><div id="TD-cboInfPos2" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtPathogen2A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtPathogen2B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtPathogen2C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">3.</div></td><td><div id="TD-cboInfPos3" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtPathogen3A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtPathogen3B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtPathogen3C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">手术后肺炎：</div></td><td><div id="TD-cbgAddOns5" style="width:170px;overflow:hidden;"></div></td><td><div style="width:150px;text-align:right;overflow:hidden;">（仅指调查时段内）</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:140px;text-align:right;overflow:hidden;">社区感染部位：</div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">病原体：</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">1.</div></td><td><div id="TD-cboComInfPos1" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtComPathogen1A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtComPathogen1B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtComPathogen1C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">2.</div></td><td><div id="TD-cboComInfPos2" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtComPathogen2A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtComPathogen2B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtComPathogen2C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">3.</div></td><td><div id="TD-cboComInfPos3" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">①</div></td><td><div id="TD-txtComPathogen3A" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">②</div></td><td><div id="TD-txtComPathogen3B" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:15px;text-align:right;overflow:hidden;">③</div></td><td><div id="TD-txtComPathogen3C" style="width:160px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>细菌耐药情况</b></span>'
		+ '		<span onclick="objScreen.BugsInfoDiv_expand();" style="font-size:16px;color=red;">显示本次住院细菌耐药情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-BugsInfo" style="width=100%;heigth=200px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">金黄色葡萄球菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">苯唑西林</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen11" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢西丁</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen12" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">凝固酶阴性葡萄球菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">苯唑西林</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen21" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢西丁</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen22" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">粪肠球菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">氨苄西林</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen31" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">万古霉素</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen32" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">粪肠球菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">氨苄西林</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen41" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">万古霉素</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen42" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">屎肠球菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">青霉素</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen51" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">大肠埃希菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢他啶</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen61" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">亚胺/美罗培南</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen62" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">左氧氟沙星</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen63" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">肺炎克雷伯菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢他啶</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen71" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">亚胺/美罗培南</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen72" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">左氧氟沙星</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen73" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">铜绿假单胞菌：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">环丙沙星</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen81" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">哌拉西林/他唑巴坦</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen82" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">亚胺培南/美罗培南</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen83" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢他啶</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen84" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢吡肟</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen85" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">阿米卡星</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen86" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '				<tr>'
		+ '					<td><div style="width:120px;text-align:right;overflow:hidden;">鲍曼不动杆：</div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">亚胺培南/美罗培南</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen91" style="width:200px;overflow:hidden;"></div></td>'
		+ '             	<td><div style="width:120px;text-align:right;overflow:hidden;">头孢哌酮/舒巴坦</div></td>'
		+ '             	<td><div id="TD-cbgAntiSen92" style="width:200px;overflow:hidden;"></div></td>'
		+ '				</tr>'
		+ '			</table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>抗菌药物使用情况</b></span>'
		+ '		<span onclick="objScreen.AntiInfoDiv_expand();" style="font-size:16px;color=red;">显示本次住院抗菌药物使用情况</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div id="div-AntiInfo" style="width=100%;heigth=200px;"></div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">抗菌药物使用：</div></td><td><div id="TD-cbgAnti1" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">目的：</div></td><td><div id="TD-cbgAnti2" style="width:260px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">联用：</div></td><td><div id="TD-cbgAnti3" style="width:350px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">治疗用药已送细菌培养：</div></td><td><div id="TD-cbgAnti4" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><b>调查者</b></div></td><td><div id="TD-txtSurvUser" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><b>调查日期</b></div></td><td><div id="TD-txtSurvDate" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><b>调查科室</b></div></td><td><div id="TD-txtSurvLoc" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '             <td width="50%"> </td>'
		+ '				<td><div id="TD-btnReport" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-btnPrint" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-btnClose" style="width:80px;overflow:hidden;"></div></td>'
		+ '             <td width="50%"> </td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		+ '</tr></table>'
		+ '</div>'
	
	obj.txtPatNo        = Common_TextField("txtPatNo","病人编号")
	obj.cboLoc         = Common_ComboToDic("cboLoc","科室","NINFCSSLoc")
	obj.txtBed         = Common_TextField("txtBed","床位")
	obj.txtMRNo        = Common_TextField("txtMRNo","病案号")
	obj.txtName        = Common_TextField("txtName","姓名")
	obj.cbgSex         = Common_RadioGroupToDic("cbgSex","性别","NINFCSSSex",2)
	obj.txtAgeY        = Common_TextFieldToFormat("txtAgeY","年龄-岁")
	obj.txtAgeM        = Common_TextFieldToFormat("txtAgeM","年龄-月")
	obj.txtAgeD        = Common_TextFieldToFormat("txtAgeD","年龄-天")
	Common_SetDisabled("txtPatNo",true);
	//Common_SetDisabled("cboLoc",true);
	//Common_SetDisabled("txtBed",true);
	Common_SetDisabled("txtMRNo",true);
	Common_SetDisabled("txtName",true);
	Common_SetDisabled("cbgSex",true);
	Common_SetDisabled("txtAgeY",true);
	Common_SetDisabled("txtAgeM",true);
	Common_SetDisabled("txtAgeD",true);
	obj.txtDiagnos1    = Common_TextField("txtDiagnos1","基础疾病诊断1")
	obj.txtDiagnos2    = Common_TextField("txtDiagnos2","基础疾病诊断2")
	obj.txtDiagnos3    = Common_TextField("txtDiagnos3","基础疾病诊断3")
	
	obj.cbgOper1       = Common_RadioGroupToDic("cbgOper1","手术","NINFCSSBoolean",2)
	obj.cbgOper3       = Common_RadioGroupToDic("cbgOper3","手术切口等级","NINFCSSOperCut",5)
	
	obj.cbgIsInfection = Common_RadioGroupToDic("cbgIsInfection","是否感染","NINFCSSBoolean1",2)
	obj.cbgInfCategory = Common_RadioGroupToDic("cbgInfCategory","感染分类","NINFCSSInfCategory",2)
	obj.cboInfPos1     = Common_ComboToDic("cboInfPos1","感染部位","NINFCSSInfPos")
	obj.txtPathogen1A  = Common_TextField("txtPathogen1A","病原体")
	obj.txtPathogen1B  = Common_TextField("txtPathogen1B","病原体")
	obj.txtPathogen1C  = Common_TextField("txtPathogen1C","病原体")
	obj.cboInfPos2     = Common_ComboToDic("cboInfPos2","感染部位","NINFCSSInfPos")
	obj.txtPathogen2A  = Common_TextField("txtPathogen2A","病原体")
	obj.txtPathogen2B  = Common_TextField("txtPathogen2B","病原体")
	obj.txtPathogen2C  = Common_TextField("txtPathogen2C","病原体")
	obj.cboInfPos3     = Common_ComboToDic("cboInfPos3","感染部位","NINFCSSInfPos")
	obj.txtPathogen3A  = Common_TextField("txtPathogen3A","病原体")
	obj.txtPathogen3B  = Common_TextField("txtPathogen3B","病原体")
	obj.txtPathogen3C  = Common_TextField("txtPathogen3C","病原体")
	obj.cbgAddOns5     = Common_RadioGroupToDic("cbgAddOns5","手术后肺炎","NINFCSSBoolean1",2)
	obj.cboComInfPos1     = Common_ComboToDic("cboComInfPos1","感染部位","NINFCSSInfPos")
	obj.txtComPathogen1A  = Common_TextField("txtComPathogen1A","病原体")
	obj.txtComPathogen1B  = Common_TextField("txtComPathogen1B","病原体")
	obj.txtComPathogen1C  = Common_TextField("txtComPathogen1C","病原体")
	obj.cboComInfPos2     = Common_ComboToDic("cboComInfPos2","感染部位","NINFCSSInfPos")
	obj.txtComPathogen2A  = Common_TextField("txtComPathogen2A","病原体")
	obj.txtComPathogen2B  = Common_TextField("txtComPathogen2B","病原体")
	obj.txtComPathogen2C  = Common_TextField("txtComPathogen2C","病原体")
	obj.cboComInfPos3     = Common_ComboToDic("cboComInfPos3","感染部位","NINFCSSInfPos")
	obj.txtComPathogen3A  = Common_TextField("txtComPathogen3A","病原体")
	obj.txtComPathogen3B  = Common_TextField("txtComPathogen3B","病原体")
	obj.txtComPathogen3C  = Common_TextField("txtComPathogen3C","病原体")
	
	obj.cbgAntiSen11        = Common_RadioGroupToDic("cbgAntiSen11","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen12        = Common_RadioGroupToDic("cbgAntiSen12","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen21        = Common_RadioGroupToDic("cbgAntiSen21","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen22        = Common_RadioGroupToDic("cbgAntiSen22","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen31        = Common_RadioGroupToDic("cbgAntiSen31","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen32        = Common_RadioGroupToDic("cbgAntiSen32","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen41        = Common_RadioGroupToDic("cbgAntiSen41","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen42        = Common_RadioGroupToDic("cbgAntiSen42","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen51        = Common_RadioGroupToDic("cbgAntiSen51","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen61        = Common_RadioGroupToDic("cbgAntiSen61","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen62        = Common_RadioGroupToDic("cbgAntiSen62","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen63        = Common_RadioGroupToDic("cbgAntiSen63","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen71        = Common_RadioGroupToDic("cbgAntiSen71","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen72        = Common_RadioGroupToDic("cbgAntiSen72","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen73        = Common_RadioGroupToDic("cbgAntiSen73","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen81        = Common_RadioGroupToDic("cbgAntiSen81","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen82        = Common_RadioGroupToDic("cbgAntiSen82","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen83        = Common_RadioGroupToDic("cbgAntiSen83","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen84        = Common_RadioGroupToDic("cbgAntiSen84","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen85        = Common_RadioGroupToDic("cbgAntiSen85","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen86        = Common_RadioGroupToDic("cbgAntiSen86","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen91        = Common_RadioGroupToDic("cbgAntiSen91","药敏结果","NINFCSSAntiSen")
	obj.cbgAntiSen92        = Common_RadioGroupToDic("cbgAntiSen92","药敏结果","NINFCSSAntiSen")
	
	obj.cbgAnti1       = Common_RadioGroupToDic("cbgAnti1","抗菌药物使用","NINFCSSBoolean",2)
	obj.cbgAnti2       = Common_RadioGroupToDic("cbgAnti2","目的","NINFCSSMedObj",3)
	obj.cbgAnti3       = Common_RadioGroupToDic("cbgAnti3","联用","NINFCSSDrugCom",4)
	obj.cbgAnti4       = Common_RadioGroupToDic("cbgAnti4","治疗用药已送细菌培养","NINFCSSBoolean",2)
	obj.txtSurvDate    = Common_TextField("txtSurvDate","调查日期")
	obj.txtSurvLoc     = Common_TextField("txtSurvLoc","调查科室")
	obj.txtSurvUser    = Common_TextField("txtSurvUser","调查人")
	Common_SetDisabled("txtSurvDate",true);
	Common_SetDisabled("txtSurvLoc",true);
	Common_SetDisabled("txtSurvUser",true);
	
	obj.BugsTemplate = new Ext.XTemplate(
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
						'{[ this.TestSetDataView(values) ]}',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>',
		{
			TestSetDataView : function(values){
				var strTestSet = values.Antibiotics;
				var arrTestSet = strTestSet.split(CHR_1);
				if (arrTestSet.length>0){
					var tabEv = '<tr><td colspan="6" align="left"><div>'
					tabEv = tabEv + '<table border=1 cellpadding=0 cellspacing=0 width="100%">';
					var col = 5;
					for (var indTS = 0; indTS < arrTestSet.length; indTS++){
						var strTestSetSen = arrTestSet[indTS];
						if (!strTestSetSen) continue;
						var arrTestSetSen = strTestSetSen.split('<$C2>');
						if (arrTestSetSen.length<4) continue;
						
						var TSS1 = arrTestSetSen[1];
						var TSS3 = arrTestSetSen[3];
						if (arrTestSetSen[1] == '') TSS1 = '&nbsp;';
						if (arrTestSetSen[3] == '') TSS3 = '&nbsp;';
						
						if ((indTS + 1)%col == 1) tabEv = tabEv + '<tr>';
						tabEv = tabEv + '<td width="15%">' + TSS1 + '</td>';
						tabEv = tabEv + '<td width="5%">' + TSS3 + '</td>';
						if ((indTS + 1)%col == 0) tabEv = tabEv + '</tr>';
					}
					if (indTS%col != 0){
						var tmpNum = indTS%col;
						for (var indNum = 0; indNum < (col-tmpNum); indNum++){
							tabEv = tabEv + '<td width="15%">' + '&nbsp;' + '</td>';
							tabEv = tabEv + '<td width="5%">' + '&nbsp;' + '</td>';
						}
						tabEv = tabEv + '</tr>';
					}
					tabEv = tabEv + '</table>';
					tabEv = tabEv + '</div></td></tr>';
				} else {
					var tabEv = '';
				}
				return tabEv;
			}
		}
	);
	
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
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">类型</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">开始日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">停止日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">频次</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">途径</td>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{ArcimDesc}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{PriorityDesc}</td>',
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
        ,iconCls:'icon-exit'
		,height:30
    });
    
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		//,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,buttonAlign:'center'
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