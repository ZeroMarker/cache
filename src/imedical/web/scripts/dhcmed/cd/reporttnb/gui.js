
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>���򲡷������濨</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">�ǼǺ�</div></td><td><div id="TD-txtPatientNo" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatName" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���֤��</div></td><td><div id="TD-txtPatCardNo" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ա�</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">����</div></td><td><div id="TD-txtPatAge" style="width:50px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ</div></td><td><div id="TD-cboCRZY" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���幤��</div></td><td><div id="TD-cboCRGZ" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ļ�</div></td><td><div id="TD-cboCRWH" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-txtBirthDay" style="width:92px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-cboCRMZ" style="width:160px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ�绰</div></td><td><div id="TD-txtJTDH" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:65px;text-align:right;overflow:hidden;">������λ</div></td><td><div id="TD-txtGZDW" style="width:276px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>Ŀǰ��ס��ַ:ʡ</div></td><td><div id="TD-cboProvince1" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:106px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:65px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:162px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ס��ϸ��ַ</div></td><td><div id="TD-txtAdress1" style="width:698px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ס���ڵ�ַ:ʡ</div></td><td><div id="TD-cboProvince2" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity2" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty2" style="width:106px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:65px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage2" style="width:90px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN2" style="width:162px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������ϸ��ַ</div></td><td><div id="TD-txtAdress2" style="width:698px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-cboCRZDLX" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���</div></td><td><div id="TD-cboCRZD" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">ICD����</div></td><td ><div id="TD-txtCRZDICD" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����֢</div></td><td><div id="TD-cbgCRBFZ" style="width:630px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">Σ������</div></td><td><div id="TD-cbgCRWHYS" style="width:420px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">����</div></td><td><div id="TD-txtCRTZ" style="width:40px;overflow:hidden;"></div></td><td><div style="width:30px;text-align:left;overflow:hidden;">����</div></td>'
		+ '				<td><div style="width:30px;text-align:right;overflow:hidden;">���</div></td><td><div id="TD-txtCRSG" style="width:40px;overflow:hidden;"></div></td><td><div style="width:40px;text-align:left;overflow:hidden;">����</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">����ʷ����ĸ�ֵܽ��ù�</div></td><td><div id="TD-txtCRRS" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:160px;text-align:left;overflow:hidden;">�ˣ�����������ʷ��</div></td><td><div id="TD-cbgCRJZS" style="width:250px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ٴ�����</div></td><td><div id="TD-cbgCRLCBX" style="width:650px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">�����ٴ�����</div></td><td><div id="TD-txtCRQTLCBX" style="width:526px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��Ҫ������</div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E1 �ո�Ѫ��ֵ(mol/L)</div></td><td><div id="TD-txtCRZYJCQK1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E2 ���Ѫ��ֵ(mol/L)</div></td><td><div id="TD-txtCRZYJCQK2" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E3 OGTT(mol/L)</div></td><td><div id="TD-txtCRZYJCQK3" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E4 �ܵ��̴�(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK4" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E5 HDL-C(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK5" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E6 LDL-C(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK6" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E7 ��������(mg/dl)</div></td><td><div id="TD-txtCRZYJCQK7" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E8 ��΢������(mg/24h)</div></td><td><div id="TD-txtCRZYJCQK8" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">E9 �ǻ�Ѫ�쵰��(%)</div></td><td><div id="TD-txtCRZYJCQK9" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="Div12" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������</div></td><td><div id="TD-txtCRZDDate" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�����ϵ�λ</div></td><td><div id="TD-cboCRZGZDDW" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������λ</div></td><td><div id="TD-txtCRReportOrgan" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-cboCRReportLoc" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����ҽ��</div></td><td><div id="TD-txtCRReportUser" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-txtCRReportDate" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtCRSWRQ" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">����ԭ��</div></td><td><div id="TD-cboCRSWYY" style="width:235px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">�������</div></td><td><div id="TD-cboCRSWZD" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">����ICD10</div></td><td><div id="TD-txtCRSYICD" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������ԭ��</div></td><td><div id="TD-txtCRJTSWYY" style="width:460px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '</tr></table>'
	
	//���˻�����Ϣ
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","��Ƭ���");
    obj.txtPatientNo = Common_TextField("txtPatientNo","�ǼǺ�");
    obj.txtPatName = Common_TextField("txtPatName","����");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","���֤��");
	obj.txtPatSex = Common_TextField("txtPatSex","�Ա�");
	obj.txtPatAge = Common_TextField("txtPatAge","����");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","���䵥λ","CRPatAge");
	obj.txtBirthDay = Common_DateFieldToDate1("txtBirthDay","��������");
	obj.cboCRZY=Common_ComboToDic("cboCRZY","ְҵ","CRZY");
	obj.cboCRMZ=Common_ComboToDic("cboCRMZ","����","CRMZ");
	obj.cboCRGZ = Common_ComboToDicGZ("cboCRGZ","����",DicTypeGZ);
	obj.cboCRWH = Common_ComboToDic("cboCRWH","�Ļ�","CRDTHEducation");
	
	obj.txtJTDH = Common_TextField("txtJTDH","��ͥ�绰");
	obj.txtGZDW = Common_TextField("txtGZDW","������λ");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","��ס��ַʡ","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","��ס��ַ��","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","��ס��ַ��","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","��ס��ַ��/��","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","��ס��ַ��");
	obj.txtAdress1 = Common_TextField("txtAdress1","��ס��ϸ��ַ");
	obj.cboProvince2 = Common_ComboToArea("cboProvince2","��ס����ʡ","1");
	obj.cboCity2 = Common_ComboToArea("cboCity2","��ס������","cboProvince2");
	obj.cboCounty2 = Common_ComboToArea("cboCounty2","��ס������","cboCity2");
	obj.cboVillage2 = Common_ComboToArea("cboVillage2","��ס������/��","cboCounty2");
	obj.txtCUN2 = Common_TextField("txtCUN2","��ס���ڴ�");
	obj.txtAdress2 = Common_TextField("txtAdress2","������ϸ��ַ");
	
	//�����Ϣ
	obj.cboCRZDLX = Common_ComboToDic("cboCRZDLX","��������","CRZDLX");
	obj.cboCRZD = Common_ComboToICD("cboCRZD","���","����");
	
	obj.txtCRZDICD = Common_TextField("txtCRZDICD","���ICD");
	obj.cbgCRBFZ = Common_CheckboxGroupToDic("cbgCRBFZ","����֢","CRBFZ",6);
	obj.cbgCRWHYS = Common_CheckboxGroupToDic("cbgCRWHYS","Σ������","CRWHYS",4);
	obj.txtCRTZ = Common_TextField("txtCRTZ","����");
	obj.txtCRSG = Common_TextField("txtCRSG","���");
	obj.cbgCRJZS = Common_CheckboxGroupToDic("cbgCRJZS","����ʷ","CRJZS",4);
	obj.txtCRRS = Common_TextField("txtCRRS","����");
	
	obj.txtCRZDDate = Common_DateFieldToDate("txtCRZDDate","�������");
	obj.cboCRZGZDDW=Common_ComboToDic("cboCRZGZDDW","�����ϵ�λ","CRZGZDDW");
	obj.txtCRReportOrgan = Common_TextField("txtCRReportOrgan","������λ");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","��������","E","","I");
	obj.txtCRReportUser = Common_TextField("txtCRReportUser","����ҽ��");
	obj.txtCRReportDate = Common_DateFieldToDate("txtCRReportDate","��������");
	obj.txtCRSWRQ = Common_DateFieldToDate1("txtCRSWRQ","��������");
	obj.txtCRSYICD = Common_TextField("txtCRSYICD","����ICD10");
	obj.cboCRSWYY = Common_ComboToDic("cboCRSWYY","����ԭ��","CRSWYY");
	obj.cboCRSWZD = Common_ComboToICD("cboCRSWZD","�������");
	obj.txtCRJTSWYY = Common_TextField("txtCRJTSWYY","��������ԭ��");
	obj.cbgCRLCBX = Common_CheckboxGroupToDic("cbgCRLCBX","�ٴ�����","CRLCBX",5);
	obj.txtCRQTLCBX = Common_TextField("txtCRQTLCBX","�����ٴ�����");
	
	obj.txtCRZYJCQK1 = Common_TextField("txtCRZYJCQK1","E1 �ո�Ѫ��ֵ");
	obj.txtCRZYJCQK2 = Common_TextField("txtCRZYJCQK2","E2 ���Ѫ��ֵ");
	obj.txtCRZYJCQK3 = Common_TextField("txtCRZYJCQK3","E3 OGTT");
	obj.txtCRZYJCQK4 = Common_TextField("txtCRZYJCQK4","E4 �ܵ��̴�");
	obj.txtCRZYJCQK5 = Common_TextField("txtCRZYJCQK5","E5 HDL-C");
	obj.txtCRZYJCQK6 = Common_TextField("txtCRZYJCQK6","E6 LDL-C");
	obj.txtCRZYJCQK7 = Common_TextField("txtCRZYJCQK7","E7 ��������");
	obj.txtCRZYJCQK8 = Common_TextField("txtCRZYJCQK8","E8 ��΢������");
	obj.txtCRZYJCQK9 = Common_TextField("txtCRZYJCQK9","E9 �ǻ�Ѫ�쵰��");
	
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 75
		,text : '����'
	});
	
	obj.btnCheck=new Ext.Button({
        id:'btnCheck'
        ,text:'���'
        ,iconCls:'icon-check'
		,width : 75
    });
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 75
		,text : 'ɾ��'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 75
		,text : '����'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 75
		,text : '��ӡ'
	});
	
	obj.btnCancle=new Ext.Button({
        id:'btnCancle'
        ,text:'�ر�'
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
	
	
	//�������岼��
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
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 