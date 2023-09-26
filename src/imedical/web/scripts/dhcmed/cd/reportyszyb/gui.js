
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	if (typeof tDHCMedMenuOper=="undefined") {
		ExtTool.alert("提示","您没有操作权限，请找相关人员增加权限!");
		return;
	}else{
		
	}
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>疑似职业病报告卡</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>姓名</div></td><td><div id="TD-txtPatName" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>性别</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>年龄</div></td><td><div id="TD-txtPatAge" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系电话</div></td><td><div id="TD-txtLXDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>身份证号</div></td><td><div id="TD-txtPatCardNo" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>职业</div></td><td><div id="TD-cboCRZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>地址 省</div></td><td><div id="TD-cboProvince1" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty1" style="width:100px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:80px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN1" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>详细地址</div></td><td><div id="TD-txtAdress1" style="width:468px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table>'
		+ ' 		<tr>'
		+ '				<td rowspan="4" style="border-right:1px solid #84C1FF;"><div style="width:80px;text-align:right;overflow:hidden;">用人单位<br>基本信息</div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>单位名称</div></td><td><div id="TD-txtYRDWMC" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>行业</div></td><td><div id="TD-txtDWHY" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ ' 		<tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>通讯地址</div></td><td><div id="TD-txtYRDWDZ" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">邮编</div></td><td><div id="TD-txtYRDWYB" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ ' 		<tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系人</div></td><td><div id="TD-txtYRDWLXR" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>电话</div></td><td><div id="TD-txtYRDWLXRDH" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ ' 		<tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>经济类型</div></td><td><div id="TD-txtJJLX" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>企业规模</div></td><td><div id="TD-cbgQYGM" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ '			</table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>病人来源</div></td><td><div id="TD-cbgBRLY" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>职业病种类</div></td><td><div id="TD-txtZYBZL" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>具体病名</div></td><td><div id="TD-txtJTBM" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>中毒事故编码</div></td><td><div id="TD-txtZDSGBM" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>同时中毒人数</div></td><td><div id="TD-txtTSZDRS" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>统计工种</div></td><td><div id="TD-cbgTJGZ" style="width:250px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">专业工龄</div></td>'
		+ '				<td><div id="TD-txtZYGLN" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">年</div></td><td><div id="TD-txtZYGLY" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">月</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">接触时间</div></td>'
		+ '				<td><div id="TD-txtJCSJT" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">天</div></td>'
		+ '				<td><div id="TD-txtJCSJS" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">时</div></td>'
		+ '				<td><div id="TD-txtJCSJF" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">分</div></td>'
		+ '				<td><div style="width:350px;text-align:left;overflow:hidden;">(适用于专业工龄不足1个月者的急性职业病患者)</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>发生日期</div></td><td><div id="TD-txtFSRQ" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断日期</div></td><td><div id="TD-txtZDRQ" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">死亡日期</div></td><td><div id="TD-txtSWRQ" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">填卡人</div></td><td><div id="TD-txtReportUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">填卡单位</div></td><td><div id="TD-txtReportOrgan" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">填卡日期</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '</table>'
	
	//病人基本信息
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","卡片编号");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtPatSex = Common_TextField("txtPatSex","性别");
	obj.txtPatAge = Common_TextField("txtPatAge","年龄");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","年龄单位","CRPatAge");
	obj.cboCRZY=Common_ComboToDic("cboCRZY","职业","CRZY");
	//obj.txtCRQTZY = Common_TextField("txtCRQTZY","","其他职业");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","身份证号");
	obj.txtLXDH = Common_TextField("txtLXDH","联系电话");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","省","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","市","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","县","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","乡/镇","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","村");
	obj.txtAdress1 = Common_TextField("txtAdress1","居住详细地址");
	
	obj.txtYRDWMC = Common_TextField("txtYRDWMC","用人单位名称");
	obj.txtYRDWDZ = Common_TextField("txtYRDWDZ","用人单位地址");
	obj.txtYRDWYB = Common_TextField("txtYRDWYB","用人单位邮编");
	obj.txtYRDWLXR = Common_TextField("txtYRDWLXR","用人单位联系人");
	obj.txtYRDWLXRDH = Common_TextField("txtYRDWLXRDH","联系人电话");
	obj.txtJJLX = Common_TextField("txtJJLX","经济类型");
	obj.txtDWHY = Common_TextField("txtDWHY","行业");
	obj.cbgQYGM = Common_RadioGroupToDic("cbgQYGM","企业规模","CRQYGM",4);
	obj.cbgBRLY = Common_RadioGroupToDic("cbgBRLY","病人来源","CRBRLY",3);
	obj.txtZYBZL = Common_TextField("txtZYBZL","职业病种类");
	obj.txtJTBM = Common_TextField("txtJTBM","具体病名");
	obj.txtZDSGBM = Common_TextField("txtZDSGBM","中毒事故编码");
	obj.txtTSZDRS = Common_TextField("txtTSZDRS","同时中毒人数");
	obj.cbgTJGZ = Common_RadioGroupToDic("cbgTJGZ","统计工种","CRTJGZ",3);
	obj.txtZYGLN = Common_TextField("txtZYGLN","专业工龄年");
	obj.txtZYGLY = Common_TextField("txtZYGLY","专业工龄月");
	obj.txtJCSJT = Common_TextField("txtJCSJT","接触时间天");
	txtJCSJS = Common_TextField("txtJCSJS","接触时间时");
	obj.txtJCSJF = Common_TextField("txtJCSJF","接触时间分");
	obj.txtFSRQ = Common_DateFieldToDate("txtFSRQ","发生日期");
	obj.txtZDRQ = Common_DateFieldToDate("txtZDRQ","诊断日期");
	obj.txtSWRQ = Common_DateFieldToDate1("txtSWRQ","死亡日期");
	
	
	obj.txtReportUser = Common_TextField("txtReportUser","填卡人");
	obj.txtReportOrgan= Common_TextField("txtReportOrgan","填卡单位");
	obj.txtReportDate = Common_DateFieldToDate("txtReportDate","填卡日期");
	
	
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