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
		+ '		<span style="font-size:20px;"><b>���˻�����Ϣ</b></span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">Ժ��</div></td><td><div id="TD-cboHospital" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>��������</div></td><td><div id="TD-cboMrType" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>�ǼǺ�</div></td><td><div id="TD-txtRegNo" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>������</div></td><td><div id="TD-txtMrNo" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">���ѷ�ʽ</div></td><td><div id="TD-cboSocSat" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">ҽ����</div></td><td><div id="TD-txtSocialNo" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����</div></td><td><div id="TD-txtName" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">����ƴ��</div></td><td><div id="TD-txtNameSpell" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>�Ա�</div></td><td><div id="TD-cboSex" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">ҽ����</div></td><td><div id="TD-txtMedicalNo" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>��������</div></td><td><div id="TD-txtBirthday" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����</div></td><td><div id="TD-txtAge" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">֤������</div></td><td><div id="TD-cboCardType" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>֤������</div></td><td><div id="TD-txtPersonalID" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">����״��</div></td><td><div id="TD-cboMarital" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">ְҵ</div></td><td><div id="TD-cboOccupation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����</div></td><td><div id="TD-cboNation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����</div></td><td><div id="TD-cboCountry" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����ʡ��</div></td><td><div id="TD-cboBirthProvince" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����������</div></td><td><div id="TD-cboBirthCity" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">�����ʱ�</div></td><td><div id="TD-txtRegZIP" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>���ڵ�ַ</div></td><td><div id="TD-txtRegAddr" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">������λ</div></td><td><div id="TD-txtCompany" style="width:340px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��λ�ʱ�</div></td><td><div id="TD-txtCompanyZIP" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��λ�绰</div></td><td><div id="TD-txtCompanyTel" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��ϵ��</div></td><td><div id="TD-txtForeignId" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��ϵ</div></td><td><div id="TD-cboRelation" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��ϵ�˵绰<font color="red">*</font></div></td><td><div id="TD-txtForeignTel" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��ϵ�˵�ַ</div></td><td><div id="TD-txtForeignAddr" style="width:240px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '		<tr><td width="100%"><div style="width=100%;background-color:#84C1FF;">'
		+ '		<span style="font-size:20px;"><b>����������Ϣ</b></span>'
		+ '		</div></td></tr>'

		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div id="TD-RadioGroupPatFrom" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:right;">��</div></td><td><div id="TD-RadioGroupEPPatFrom" style="width:170px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:10px;text-align:left;">��</div></td><td><div id="TD-RadioGroupPatAdmStatus" style="width:320px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">����״̬</div></td><td><div id="TD-txtMrStatus" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">������</div></td><td><div id="TD-txtBuildFees" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtBuildDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">������</div></td><td><div id="TD-txtBuildUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table border=0 cellpadding=0 cellspacing=0><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>�������</div></td><td><div id="TD-cboFirstLoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>����ҽʦ</div></td><td><div id="TD-cboFirstDoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><font color="red">*</font>��������</div></td><td><div id="TD-txtFirstDate" style="width:120px;overflow:hidden;"></div></td>'
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
	
	obj.txtRegNo = Common_TextField("txtRegNo","�ǼǺ�");
	obj.txtMrNo = Common_TextField("txtMrNo","������");
	obj.txtSocialNo = Common_TextField("txtSocialNo","ҽ����");
	obj.txtMedicalNo = Common_TextField("txtMedicalNo","ҽ����");
	obj.cboSocSat = Common_ComboToSocialStatus("cboSocSat","���ʽ");
	obj.txtName = Common_TextField("txtName","����");
	obj.txtNameSpell = Common_TextField("txtNameSpell","����ƴ��");
	obj.cboCardType = Common_ComboToCardType("cboCardType","֤������");
	obj.txtPersonalID = Common_TextField("txtPersonalID","֤������");
	obj.cboSex = Common_ComboToSex("cboSex","�Ա�");
	obj.cboMarital = Common_ComboToMarital("cboMarital","����");
	obj.txtBirthday = Common_DateFieldToDate("txtBirthday","��������");
	obj.txtAge = Common_TextField("txtAge","����");
	obj.cboOccupation = Common_ComboToOccupation("cboOccupation","ְҵ");
	obj.cboNation = Common_ComboToNation("cboNation","����");
	obj.cboCountry = Common_ComboToCountry("cboCountry","����");
	obj.cboBirthProvince = Common_ComboToProvince("cboBirthProvince","����ʡ��","cboBirthCity");
	obj.cboBirthCity = Common_ComboToCity("cboBirthCity","������","cboBirthProvince");
	obj.txtRegAddr = Common_TextField("txtRegAddr","���ڵ�ַ");
	obj.txtRegZIP = Common_TextField("txtRegZIP","�����ʱ�");
	obj.txtCompany = Common_TextField("txtCompany","������λ");
	obj.txtCompanyZIP = Common_TextField("txtCompanyZIP","��λ�ʱ�");
	obj.txtCompanyTel = Common_TextField("txtCompanyTel","��λ�绰");
	obj.txtForeignId = Common_TextField("txtForeignId","��ϵ��");
	obj.cboRelation = Common_ComboToRelation("cboRelation","��ϵ��ϵ");
	obj.txtForeignAddr = Common_TextField("txtForeignAddr","��ϵ�˵�ַ");
	obj.txtForeignTel = Common_TextField("txtForeignTel","��ϵ�˵绰");
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","Ժ��",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.txtMrStatus = Common_TextField("txtMrStatus","����״̬");
	obj.txtBuildFees = Common_TextField("txtBuildFees","����������");
	obj.txtBuildDate = Common_TextField("txtBuildDate","��������");
	obj.txtBuildUser = Common_TextField("txtBuildUser","������");
	obj.cboFirstLoc = Common_ComboToLendLoc("cboFirstLoc","�������","E","","cboHospital");
	obj.cboFirstDoc = Common_ComboToLendUser("cboFirstDoc","����ҽʦ","cboFirstLoc");
	obj.txtFirstDate = Common_DateFieldToDate("txtFirstDate","��������");
	
	obj.RadioGroupPatFrom=Common_RadioGroupToDicNew("RadioGroupPatFrom","������Դ","PatFrom","60%",true);
	obj.RadioGroupEPPatFrom=Common_RadioGroupToDicNew("RadioGroupEPPatFrom","������Դ","EPPatFrom","100%",false);
	obj.RadioGroupPatAdmStatus=Common_RadioGroupToDicNew("RadioGroupPatAdmStatus","����״̬","PatAdmStatus","60%",true);
	
	obj.btnReset = new Ext.Button({
		id : 'btnReset'
		,iconCls : 'icon-reset'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '����'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '����'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : 'ȡ��'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '��ӡ'
	});
	
	obj.btnPrintVicepage = new Ext.Button({
		id : 'btnPrintVicepage'
		,iconCls : 'icon-print'
		,width : 80
		,height : 30
		,anchor : '100%'
		,text : '��ӡ��ҳ'
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
		,loadMask : { msg : '���ڲ�ѯ,���Ժ�...'}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 40, dataIndex: 'AdmType', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '����', width: 120, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: 'ҽʦ', width: 70, dataIndex: 'AdmDocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����ʱ��', width: 60, dataIndex: 'AdmTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�ű�', width: 120, dataIndex: 'RegDoctor', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '����', width: 100, dataIndex: 'ConsultArea', sortable: false, menuDisabled:true, align: 'left'}
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