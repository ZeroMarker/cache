
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>农药中毒报告卡</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">卡片编号</div></td><td><div id="TD-txtCRKPBH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
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
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>联系地址:省</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">市</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">县</div></td><td><div id="TD-cboCounty1" style="width:102px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">乡/镇</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">村</div></td><td><div id="TD-txtCUN1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>详细地址</div></td><td><div id="TD-txtAdress1" style="width:450px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>中毒农药名称</div></td><td><div id="TD-txtZDNYMC" style="width:244px;overflow:hidden;"></div></td>'
		+ '				<td ><div id="TD-txtSHFSSJ" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>农药种类数量</div></td><td><div id="TD-cbgNYZLSL" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>中毒原因</div></td><td><div id="TD-cbgZDYY" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:170px;text-align:center;overflow:hidden;"><span style="color:red">*</span>职业安全卫生知识培训</div></td><td><div id="TD-cbgZSPX" style="width:300px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>施药方式</div></td><td><div id="TD-cbgSYFS" style="width:360px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>危险行为</div></td><td><div id="TD-cbgWXXW" style="width:550px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>转归</div></td><td><div id="TD-cbgZDZG" style="width:480px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTZG" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>诊断日期</div></td><td><div id="TD-txtZDQR" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">死亡日期</div></td><td><div id="TD-txtSWRQ" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">填卡人</div></td><td><div id="TD-txtReportUser" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">填卡单位</div></td><td><div id="TD-txtReportOrgan" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">填卡日期</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
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
	
	obj.txtZDNYMC = Common_TextField("txtZDNYMC","中毒农药名称");
	obj.cbgNYZLSL = Common_RadioGroupToDic("cbgNYZLSL","种类数量","CRNYZLSL",2);
	obj.cbgZDYY = Common_RadioGroupToDic("cbgZDYY","中毒原因","CRZDYY",4);
	obj.cbgZSPX = Common_RadioGroupToDic("cbgZSPX","知识培训","CRZSPX",2);
	obj.cbgSYFS = Common_RadioGroupToDic("cbgSYFS","施药方式","CRSYFS",3);
	obj.cbgWXXW = Common_CheckboxGroupToDic("cbgWXXW","危险行为","CRWXXW",4);
	obj.cbgZDZG = Common_RadioGroupToDic("cbgZDZG","转归","CRZDZG",4);
	obj.txtCRQTZG = Common_TextField("txtCRQTZG","其他转归","其他转归");
	obj.txtZDQR = Common_DateFieldToDate("txtZDQR","诊断日期")
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