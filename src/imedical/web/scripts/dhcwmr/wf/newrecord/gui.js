function InitViewPort()
{
	var obj = new Object();
	obj.PatientID = '';
	obj.MrNo = '';
	obj.FirstAdm = '';
	obj.UpdateFlag = -1;
	
	var htmlMainPanel = ''
		+ '<div style="overflow-y:auto;width:100%;height:100%">'
		+ '<table id="NewRecord_table" align="center" border=0 cellpadding=0 cellspacing=0 style="border:0px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>病人基本信息</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">院区</div></td><td><div id="TD-cboHospital" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>病案类型</div></td><td><div id="TD-cboMrType" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>登记号</div></td><td><div id="TD-txtRegNo" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>病案号</div></td><td><div id="TD-txtMrNo" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">付费方式</div></td><td><div id="TD-cboSocSat" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">医保号</div></td><td><div id="TD-txtSocialNo" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>姓名</div></td><td><div id="TD-txtName" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">姓名拼音</div></td><td><div id="TD-txtNameSpell" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>性别</div></td><td><div id="TD-cboSex" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">医联码</div></td><td><div id="TD-txtMedicalNo" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>出生日期</div></td><td><div id="TD-txtBirthday" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>年龄</div></td><td><div id="TD-txtAge" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">证件类型</div></td><td><div id="TD-cboCardType" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>证件号码</div></td><td><div id="TD-txtPersonalID" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">婚姻状况</div></td><td><div id="TD-cboMarital" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">职业</div></td><td><div id="TD-cboOccupation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>民族</div></td><td><div id="TD-cboNation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>国籍</div></td><td><div id="TD-cboCountry" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>出生省市</div></td><td><div id="TD-cboBirthProvince" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>出生市县区</div></td><td><div id="TD-cboBirthCity" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">户口邮编</div></td><td><div id="TD-txtRegZIP" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>户口地址</div></td><td><div id="TD-txtRegAddr" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">工作单位</div></td><td><div id="TD-txtCompany" style="width:340px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">单位邮编</div></td><td><div id="TD-txtCompanyZIP" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">单位电话</div></td><td><div id="TD-txtCompanyTel" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">联系人</div></td><td><div id="TD-txtForeignId" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">关系</div></td><td><div id="TD-cboRelation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">联系人电话<font color="red">*</font></div></td><td><div id="TD-txtForeignTel" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">联系人地址</div></td><td><div id="TD-txtForeignAddr" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>病案建档信息</b></span>'
		+ '		</div></td></tr>'

		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div id="TD-RadioGroupPatFrom" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:right;">（</div></td><td><div id="TD-RadioGroupEPPatFrom" style="width:170px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:left;">）</div></td><td><div id="TD-RadioGroupPatAdmStatus" style="width:320px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">病案状态</div></td><td><div id="TD-txtMrStatus" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">建档费</div></td><td><div id="TD-txtBuildFees" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">建档日期</div></td><td><div id="TD-txtBuildDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">建档人</div></td><td><div id="TD-txtBuildUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>初诊科室</div></td><td><div id="TD-cboFirstLoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>初诊医师</div></td><td><div id="TD-cboFirstDoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>初诊日期</div></td><td><div id="TD-txtFirstDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '             <td width="50%"> </td>'
		+ '				<td><div id="TD-btnReset" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-btnSave" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-btnCancel" style="width:100px;overflow:hidden;"></div></td>'
		+ '             <td width="50%"> </td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		//+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		+ '</tr></table>'
		+ '</div>'
	
	obj.txtRegNo = Common_TextField("txtRegNo","登记号");
	obj.txtMrNo = Common_TextField("txtMrNo","病案号");
	obj.txtSocialNo = Common_TextField("txtSocialNo","医保号");
	obj.txtMedicalNo = Common_TextField("txtMedicalNo","医联码");
	obj.cboSocSat = Common_ComboToSocialStatus("cboSocSat","付款方式");
	obj.txtName = Common_TextField("txtName","姓名");
	obj.txtNameSpell = Common_TextField("txtNameSpell","姓名拼音");
	obj.cboCardType = Common_ComboToCardType("cboCardType","证件类型");
	obj.txtPersonalID = Common_TextField("txtPersonalID","证件号码");
	obj.cboSex = Common_ComboToSex("cboSex","性别");
	obj.cboMarital = Common_ComboToMarital("cboMarital","婚姻");
	obj.txtBirthday = Common_DateFieldToDate("txtBirthday","出生日期");
	obj.txtAge = Common_TextField("txtAge","年龄");
	obj.cboOccupation = Common_ComboToOccupation("cboOccupation","职业");
	obj.cboNation = Common_ComboToNation("cboNation","民族");
	obj.cboCountry = Common_ComboToCountry("cboCountry","国籍");
	obj.cboBirthProvince = Common_ComboToProvince("cboBirthProvince","出生省市","cboBirthCity");
	obj.cboBirthCity = Common_ComboToCity("cboBirthCity","出生县","cboBirthProvince");
	obj.txtRegAddr = Common_TextField("txtRegAddr","户口地址");
	obj.txtRegZIP = Common_TextField("txtRegZIP","户口邮编");
	obj.txtCompany = Common_TextField("txtCompany","工作单位");
	obj.txtCompanyZIP = Common_TextField("txtCompanyZIP","单位邮编");
	obj.txtCompanyTel = Common_TextField("txtCompanyTel","单位电话");
	obj.txtForeignId = Common_TextField("txtForeignId","联系人");
	obj.cboRelation = Common_ComboToRelation("cboRelation","联系关系");
	obj.txtForeignAddr = Common_TextField("txtForeignAddr","联系人地址");
	obj.txtForeignTel = Common_TextField("txtForeignTel","联系人电话");
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","院区",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.txtMrStatus = Common_TextField("txtMrStatus","病案状态");
	obj.txtBuildFees = Common_TextField("txtBuildFees","初建病历费");
	obj.txtBuildDate = Common_TextField("txtBuildDate","建档日期");
	obj.txtBuildUser = Common_TextField("txtBuildUser","建档人");
	obj.cboFirstLoc = Common_ComboToLendLoc("cboFirstLoc","初诊科室","E","","cboHospital");
	obj.cboFirstDoc = Common_ComboToLendUser("cboFirstDoc","初诊医师","cboFirstLoc");
	obj.txtFirstDate = Common_DateFieldToDate("txtFirstDate","初诊日期");
	
	obj.RadioGroupPatFrom=Common_RadioGroupToDicNew("RadioGroupPatFrom","病人来源","PatFrom","60%",true);
	obj.RadioGroupEPPatFrom=Common_RadioGroupToDicNew("RadioGroupEPPatFrom","急诊来源","EPPatFrom","100%",false);
	obj.RadioGroupPatAdmStatus=Common_RadioGroupToDicNew("RadioGroupPatAdmStatus","就诊状态","PatAdmStatus","60%",true);
	
	obj.btnReset = new Ext.Button({
		id : 'btnReset'
		,iconCls : 'icon-reset'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '重置'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '保存'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '取消'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '打印'
	});
	
	obj.btnPrintVicepage = new Ext.Button({
		id : 'btnPrintVicepage'
		,iconCls : 'icon-print'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '打印副页'
	});
	
	obj.gridAdmListByPatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAdmListByPatStore = new Ext.data.Store({
		proxy: obj.gridAdmListByPatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EpisodeID'
		},[
			{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'AdmType', mapping : 'AdmType'}
			,{name: 'AdmDate', mapping : 'AdmDate'}
			,{name: 'AdmTime', mapping : 'AdmTime'}
			,{name: 'AdmLocID', mapping : 'AdmLocID'}
			,{name: 'AdmLocDesc', mapping : 'AdmLocDesc'}
			,{name: 'AdmDocID', mapping: 'AdmDocID'}
			,{name: 'AdmDocDesc', mapping: 'AdmDocDesc'}
			,{name: 'RegDoctor', mapping: 'RegDoctor'}
			,{name: 'ConsultRoom', mapping: 'ConsultRoom'}
			,{name: 'ConsultArea', mapping: 'ConsultArea'}
		])
		,sortInfo: {
			field: 'AdmDate',
			direction: 'DESC'
		}
	});
	obj.gridAdmListByPat = new Ext.grid.GridPanel({
		id : 'gridAdmListByPat'
		,store : obj.gridAdmListByPatStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,loadMask : { msg : '正在查询,请稍后...'}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '类型', width: 40, dataIndex: 'AdmType', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '科室', width: 120, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '医师', width: 70, dataIndex: 'AdmDocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊日期', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊时间', width: 60, dataIndex: 'AdmTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '号别', width: 120, dataIndex: 'RegDoctor', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '诊区', width: 100, dataIndex: 'ConsultArea', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,frame : true
		,items:[
			{
				region: 'north',
				height: 440,
				frame : true,
				layout:'form',
				html : htmlMainPanel
			},obj.gridAdmListByPat
		]
	});
	
	obj.gridAdmListByPatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.NewRecordSrv';
		param.QueryName = 'QryAdmByPat';
		param.Arg1 = obj.PatientID;
		param.Arg2 = Common_GetValue('cboMrType');
		param.Arg3 = Common_GetValue('cboHospital');
		param.ArgCnt = 3;
	});
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById('TD-' + cmp.id);
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render('TD-' + cmp.id);
		}
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}