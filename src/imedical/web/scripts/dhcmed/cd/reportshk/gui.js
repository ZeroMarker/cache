
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>伤害监测报告卡</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">监测医院编号</div></td><td><div id="TD-txtCRYYBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:200px;text-align:left;overflow:hidden;">&nbsp;</div></td>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>Ⅰ患者基本信息</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>姓名</div></td><td><div id="TD-txtPatName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>性别</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>年龄</div></td><td><div id="TD-txtPatAge" style="width:56px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:44px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系电话</div></td><td><div id="TD-txtLXDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>身份证号</div></td><td><div id="TD-txtPatCardNo" style="width:274px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>户籍</div></td><td><div id="TD-cboCRHJ" style="width:104px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">文化程度(八岁以上填写此栏)</div></td></div></td><td><div id="TD-cboCRWHCD" style="width:144px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>职业</div></td><td><div id="TD-cboCRZY" style="width:104px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTZY" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系地址:省</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty1" style="width:104px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage1" style="width:98px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>详细地址</div></td><td><div id="TD-txtAdress1" style="width:450px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>Ⅱ伤害事件基本情况</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害发生时间</div></td><td><div id="TD-txtSHFSRQ" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td ><div id="TD-txtSHFSSJ" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td ><div style="width:100px;text-align:left;overflow:hidden;">时(24小时制)</div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>患者就诊时间</div></td><td><div id="TD-txtHZJZRQ" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td ><div id="TD-txtHZJZSJ" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td ><div style="width:100px;text-align:left;overflow:hidden;">时(24小时制)</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害发生原因</div></td><td><div id="TD-cboSHFSYY" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTYY" style="width:180px;overflow:hidden;">'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害发生地点</div></td><td><div id="TD-cboSHFSDD" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTDD" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害发生活动</div></td><td><div id="TD-cboSHFSSHD" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTHD" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>是否故意</div></td><td><div id="TD-cbgSHSFGY" style="width:540px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>Ⅲ伤害临床信息</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:220px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害性质：(选择最严重的一种)</div></td><td><div id="TD-cboCRSHXZ" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTXZ" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:220px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害部位：(最严重伤害的部位)</div></td><td><div id="TD-cboCRSHBW" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTBW" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:115px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害严重程度：</div></td><td><div id="TD-cbgCRSHYZCD" style="width:370px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害临床诊断</div></td><td><div id="TD-cboCRSHLCZD" style="width:200px;overflow:hidden;"></div></td><td><div id="TD-txtCRSHLCZDICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:85px;text-align:right;overflow:hidden;"><span style="color:red">*</span>伤害结局：</div></td><td><div id="TD-cbgCRSHJJ" style="width:550px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>Ⅳ伤害涉及产品信息</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivCPInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">产品名称1</div></td><td><div id="TD-txtSHCPMC1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">品牌/型号1</div></td><td><div id="TD-txtSHPPXH1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">产品分类1</div></td><td><div id="TD-cboCRSHCPFL1" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">产品名称2</div></td><td><div id="TD-txtSHCPMC2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">品牌/型号2</div></td><td><div id="TD-txtSHPPXH2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">产品分类2</div></td><td><div id="TD-cboCRSHCPFL2" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">填卡人</div></td><td><div id="TD-txtReportUser" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">填卡日期</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:150px;text-align:right;overflow:hidden;"><span style="color:red">*</span>典型案例(可多选):</div></td><td><div id="TD-cbgCRSHDYAL" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">注：此卡不作为医学证明。</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '</table>'
	
	//病人基本信息
	obj.txtCRYYBH = Common_TextField("txtCRYYBH","医院编号");
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","卡片编号");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtPatSex = Common_TextField("txtPatSex","性别");
	obj.txtPatAge = Common_TextField("txtPatAge","年龄");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","年龄单位","CRPatAge");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","身份证号");
	obj.txtLXDH = Common_TextField("txtLXDH","联系电话");
	obj.cboCRHJ = Common_ComboToDic("cboCRHJ","户籍","CRHJ");
	obj.cboCRWHCD = Common_ComboToDic("cboCRWHCD","文化程度","CRDTHEducation");
	obj.cboCRZY = Common_ComboToDic("cboCRZY","职业","CRZY");
	obj.txtCRQTZY = Common_TextField("txtCRQTZY","其他职业","其他职业");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","省","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","市","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","县","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","乡/镇","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","村");
	obj.txtAdress1 = Common_TextField("txtAdress1","居住详细地址");
	
	obj.txtSHFSRQ = Common_DateFieldToDate("txtSHFSRQ","伤害发生日期");
	obj.txtSHFSSJ = Common_TextField("txtSHFSSJ","");
	obj.txtHZJZRQ = Common_DateFieldToDate("txtHZJZRQ","患者就诊日期");
	obj.txtHZJZSJ = Common_TextField("txtHZJZSJ","");
	obj.cboSHFSYY = Common_ComboToDic("cboSHFSYY","伤害发生原因","CRSHFSYY");
	obj.txtCRQTYY = Common_TextField("txtCRQTYY","其他原因","其他原因");
	obj.cboSHFSDD = Common_ComboToDic("cboSHFSDD","伤害发生地点","CRSHFSDD");
	obj.txtCRQTDD = Common_TextField("txtCRQTDD","其他地点","其他地点");
	obj.cboSHFSSHD = Common_ComboToDic("cboSHFSSHD","伤害发生时活动","CRSHFSSHD");
	obj.txtCRQTHD = Common_TextField("txtCRQTHD","其他活动","其他活动");
	obj.cbgSHSFGY = Common_RadioGroupToDic("cbgSHSFGY","是否故意","CRSHSFGY",4);
	
	obj.cboCRSHXZ = Common_ComboToDic("cboCRSHXZ","伤害性质","CRSHXZ");
	obj.txtCRQTXZ = Common_TextField("txtCRQTXZ","其他性质","其他性质");
	obj.cboCRSHBW = Common_ComboToDic("cboCRSHBW","伤害部位","CRSHBW");
	obj.txtCRQTBW = Common_TextField("txtCRQTBW","其他部位","其他部位");
	obj.cbgCRSHYZCD = Common_RadioGroupToDic("cbgCRSHYZCD","严重程度","CRSHYZCD",3);
	obj.cboCRSHLCZD = Common_ComboToICD("cboCRSHLCZD","临床诊断");
	obj.txtCRSHLCZDICD = Common_TextField("txtCRSHLCZDICD","诊断ICD","诊断ICD");
	obj.cbgCRSHJJ = Common_RadioGroupToDic("cbgCRSHJJ","伤害结局","CRSHJJ",4);
	obj.txtSHCPMC1 = Common_TextField("txtSHCPMC1","产品名称1");
	obj.txtSHPPXH1 = Common_TextField("txtSHPPXH1","品牌/型号1");
	obj.cboCRSHCPFL1 = Common_ComboToDic("cboCRSHCPFL1","伤害产品分类1","CRSHCPFL");
	obj.txtSHCPMC2 = Common_TextField("txtSHCPMC2","产品名称2");
	obj.txtSHPPXH2 = Common_TextField("txtSHPPXH2","品牌/型号2");
	obj.cboCRSHCPFL2 = Common_ComboToDic("cboCRSHCPFL2","伤害产品分类2","CRSHCPFL");
	
	obj.txtReportUser = Common_TextField("txtReportUser","填卡人");
	obj.txtReportDate = Common_DateFieldToDate("txtReportDate","填卡日期");
	obj.cbgCRSHDYAL = Common_CheckboxGroupToDic("cbgCRSHDYAL","典型案例","CRSHDYAL",2);
	
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