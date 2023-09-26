function InitDthChild(){
	var obj = new Object();
	
	//儿童死亡报卡权限
	if (typeof tDHCMedMenuOper=="undefined") {
		ExtTool.alert("提示","您没有操作权限，请找相关人员增加权限!");
		return;
	}
	var RowHeight = 28
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;">'
		+ '		<span style="font-size:28px;"><b>儿童死亡报卡</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">死亡证编号</div></td><td><div id="TD-txtDTHNo" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">是否补卡</div></td><td><div id="TD-chkIsReplenish" style="width:38px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-lblStatus" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">父亲姓名</div></td><td><div id="TD-txtFatherName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;color:red;">母亲姓名</div></td><td><div id="TD-txtMotherName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;color:red;">联系电话</div></td><td><div id="TD-txtFamTel" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">姓名</div></td><td><div id="TD-txtName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">性别</div></td><td><div id="TD-cboSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">出生日期</div></td><td><div id="TD-txtBirthday" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">出生体重</div></td><td><div id="TD-txtWeight" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;color:red;">体重类别</div></td><td><div id="TD-cboWeightType" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;color:red;">怀孕几周</div></td><td><div id="TD-txtPregnancyWeek" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">户籍类型</div></td><td><div id="TD-cboRegType" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;color:red;">出生地点</div></td><td><div id="TD-cboBirthdayPlace" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">死亡年龄</div></td>'
		+ '				<td><div id="TD-txtDeathAgeYear" style="width:30px;overflow:hidden;"></div></td><td><div style="width:15px;text-align:right;overflow:hidden;">岁</div></td>'
		+ '				<td><div id="TD-txtDeathAgeMonth" style="width:30px;overflow:hidden;"></div></td><td><div style="width:15px;text-align:right;overflow:hidden;">月</div></td>'
		+ '				<td><div id="TD-txtDeathAgeDay" style="width:30px;overflow:hidden;"></div></td><td><div style="width:15px;text-align:right;overflow:hidden;">天</div></td>'
		+ '				<td><div id="TD-txtDeathAgeHour" style="width:30px;overflow:hidden;"></div></td><td><div style="width:15px;text-align:right;overflow:hidden;">时</div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡日期</div></td><td><div id="TD-dtDeathDate" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">分类编号</div></td><td><div id="TD-cboCategory" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">死亡地点</div></td><td><div id="TD-cboDeathPosition" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;color:red;">死亡前治疗</div></td><td><div id="TD-cboCareBeforeDeath" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;color:red;">诊断级别</div></td><td><div id="TD-cboDiagnoseLv" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;color:red;">最高诊断依据</div></td><td><div id="TD-cboDiagnoseBasis" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" ><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">未治疗原因</div></td><td><div id="TD-cboNotCareReason" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">其他原因</div></td><td><div id="TD-txtNotCareReasonTxt" style="width:130px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		+ '</tr></table>'
	
	obj.txtDTHNo = Common_TextField("txtDTHNo","死亡证编号");
	obj.chkIsReplenish = Common_Checkbox("chkIsReplenish","是否补卡");
	obj.txtName = Common_TextField("txtName","姓名");
	obj.txtFatherName = Common_TextField("txtFatherName","父亲姓名");
	obj.txtMotherName = Common_TextField("txtMotherName","母亲姓名");
	obj.txtFamTel = Common_TextField("txtFamTel","联系电话");
	obj.cboSex = Common_ComboToDic("cboSex","性别","DTCSex");	// 性别 1--男 2--女 3--性别不明
	obj.txtBirthday = Common_DateFieldToDate("txtBirthday","出生日期");;
	obj.cboRegType = Common_ComboToDic("cboRegType","户籍类型","DTCRegType");	// 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
	obj.txtWeight = Common_NumberField("txtWeight","出生体重");
	obj.cboWeightType = Common_ComboToDic("cboWeightType","体重类别","DTCWeightType");	// 出生体重类别：1--测量 2--估计
	obj.txtPregnancyWeek = Common_NumberField("txtPregnancyWeek","怀孕几周");
	obj.cboBirthdayPlace = Common_ComboToDic("cboBirthdayPlace","出生地点","DTCBirthdayPlace");	// 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
	obj.dtDeathDate = Common_DateFieldToDate("dtDeathDate","死亡日期");;
	obj.txtDeathAgeYear = Common_NumberField("txtDeathAgeYear","死亡年龄-年");
	obj.txtDeathAgeMonth = Common_NumberField("txtDeathAgeMonth","死亡年龄-月");
	obj.txtDeathAgeDay = Common_NumberField("txtDeathAgeDay","死亡年龄-日");
	obj.txtDeathAgeHour = Common_NumberField("txtDeathAgeHour","死亡年龄-时");
	obj.cboDeathPosition = Common_ComboToDic("cboDeathPosition","死亡地点","DTCDeathPosition");	// 死亡地点 1--医院 2--途中 3--家中

	obj.cboCareBeforeDeath = Common_ComboToDic("cboCareBeforeDeath","死亡前治疗","DTCCareBeforeDeath");	// 死亡前治疗 1--住院 2--门诊 3--未治疗
	obj.cboDiagnoseLv = Common_ComboToDic("cboDiagnoseLv","诊断级别","DTCDiagnoseLv");	// 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
	obj.cboNotCareReason = Common_ComboToDic("cboNotCareReason","未治疗原因","DTCNotCareReason");	// 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
	obj.txtNotCareReasonTxt = Common_TextField("txtNotCareReasonTxt","其它原因");	// 未治疗或未就医主要原因（需要注明原因）
	obj.cboDiagnoseBasis = Common_ComboToDic("cboDiagnoseBasis","最高诊断依据","DTCDiagnoseBasis");	// 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
	obj.cboCategory = Common_ComboToDic("cboCategory","分类编号","DTCCategory");	// 分类编号 01-痢疾 02--败血症 03-麻疹 ...
	obj.txtICD10 = Common_TextField("txtICD10","ICD-10编码");	// ICD-10编码
	obj.lblStatus = new Ext.form.Label({id : 'lblStatus', text : "", style : 'color:red;font-weight:bolder;'});
	
	obj.btnTMP = new Ext.Button({text : '草稿', iconCls : 'icon-save'});
	obj.btnSave = new Ext.Button({text : '保存',iconCls : 'icon-save'});
	obj.btnDelete = new Ext.Button({text : '作废',iconCls:'icon-delete'});
	obj.btnCheck = new Ext.Button({text : '审核',iconCls:'icon-save'});
	obj.btnReturn = new Ext.Button({text : '退回',iconCls:'icon-exit'});
	obj.btnPrint = new Ext.Button({text : '打印',iconCls:'icon-print'});
    obj.btnCancel=new Ext.Button({id:'btnCancel',text:'退出',iconCls:'icon-exit'});	
	
	obj.ChildReportPanel = new Ext.Panel({
		id : 'ChildReportPanel'
		,autoScroll : true
		,frame : true
		,html : htmlMainPanel
		,buttonAlign:'center'
		,buttons : [
			obj.btnTMP
			,obj.btnSave
			,obj.btnDelete
			,obj.btnPrint
			,obj.btnCheck
			,obj.btnReturn
			,obj.btnCancel
		]
	});
	
    obj.ChildReportViewPort=new Ext.Viewport({
        id:'ChildReportViewPortId'
        ,layout : 'fit'
		,items:[
			obj.ChildReportPanel
		]
    });
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById('TD-' + cmp.id);
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render('TD-' + cmp.id);
		}
	});
	
	InitDthChildEvent(obj);
	obj.LoadEvent();
}