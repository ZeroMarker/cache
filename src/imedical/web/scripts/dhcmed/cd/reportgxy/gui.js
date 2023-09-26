
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;">'
		+ '		<span style="font-size:28px;"><b>高血压报告卡</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">姓名</div></td><td><div id="TD-txtPatName" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">性别</div></td><td><div id="TD-txtPatSex" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">年龄</div></td><td><div id="TD-txtPatAge" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">出生日期</div></td><td><div id="TD-txtBirthDay" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">身份证号</div></td><td><div id="TD-txtPatCardNo" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系电话</div></td><td><div id="TD-txtLXDH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>家庭现住址:省</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty1" style="width:80px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:40px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN1" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">详细家庭现住址</div></td><td><div id="TD-txtAdress1" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">户籍地址:省</div></td><td><div id="TD-cboProvince2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty2" style="width:80px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:40px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN2" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">详细户籍地址</div></td><td><div id="TD-txtAdress2" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">高血压类型</div></td><td><div id="TD-cbgGXYLX" style="width:250px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:160px;text-align:right;overflow:hidden;">收缩压(mmHg)</div></td><td><div id="TD-txtSSY" style="width:70px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">高血压分级</div></td><td><div id="TD-cbgGXYFJ" style="width:300px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:110px;text-align:right;overflow:hidden;">舒张压(mmHg)</div></td><td><div id="TD-txtSZY" style="width:70px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:center;overflow:hidden;">确诊日期</div></td><td><div id="TD-txtZDQR" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:center;overflow:hidden;">确诊医院</div></td><td><div id="TD-txtReportOrgan" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">填卡人</div></td><td><div id="TD-txtReportUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">填卡科室</div></td><td><div id="TD-cboCRReportLoc" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">填卡日期</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '</table>'
	
	//病人基本信息
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","卡片编号");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtPatSex = Common_TextField("txtPatSex","性别");
	obj.txtPatAge = Common_TextField("txtPatAge","年龄");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","年龄单位","CRPatAge");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","身份证号");
	obj.txtLXDH = Common_TextField("txtLXDH","联系电话");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","省","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","市","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","县","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","乡/镇","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","村");
	obj.txtAdress1 = Common_TextField("txtAdress1","居住详细地址");
	obj.cboProvince2 = Common_ComboToArea("cboProvince2","省","1");
	obj.cboCity2 = Common_ComboToArea("cboCity2","市","cboProvince2");
	obj.cboCounty2 = Common_ComboToArea("cboCounty2","县","cboCity2");
	obj.cboVillage2 = Common_ComboToArea("cboVillage2","常住户口乡/镇","cboCounty2");
	obj.txtCUN2 = Common_TextField("txtCUN2","常住户口村");
	obj.txtAdress2 = Common_TextField("txtAdress2","居住详细地址");
	obj.txtBirthDay = Common_DateFieldToDate("txtBirthDay","出生日期");
	
	obj.txtSSY = Common_TextField("txtSSY","收缩压");
	obj.txtSZY = Common_TextField("txtSZY","舒张压");
	obj.cbgZDYY = Common_RadioGroupToDic("cbgGXYLX","高血压类型","CRGXYLX",3);
	obj.cbgZSPX = Common_RadioGroupToDic("cbgGXYFJ","高血压分级","CRGXYFJ",4);
	obj.txtZDQR = Common_DateFieldToDate("txtZDQR","确诊日期")
	obj.txtReportOrgan= Common_TextField("txtReportOrgan","确诊医院");
	
	obj.txtReportUser = Common_TextField("txtReportUser","填卡人");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","填卡科室","E","","I");
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
        ,iconCls:'icon-exit'
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