
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>�����������濨</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">�ǼǺ�</div></td><td><div id="TD-txtPatientNo" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�����Ѹ�֪����</div></td><td><div id="TD-cboCRBQYGZBR" style="width:70px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatName" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ա�</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">����</div></td><td><div id="TD-txtPatAge" style="width:56px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:44px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-txtBirthDay" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-cboCRMZ" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���֤��</div></td><td><div id="TD-txtPatCardNo" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ</div></td><td><div id="TD-cboCRZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���幤��</div></td><td><div id="TD-cboCRGZ" style="width:104px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ͥ�绰</div></td><td><div id="TD-txtJTDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">������λ</div></td><td><div id="TD-txtGZDW" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>Ŀǰ��ס��ַ:ʡ</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:104px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ס��ϸ��ַ</div></td><td><div id="TD-txtAdress1" style="width:760px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ס���ڵ�ַ:ʡ</div></td><td><div id="TD-cboProvince2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:50px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty2" style="width:104px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN2" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������ϸ��ַ</div></td><td><div id="TD-txtAdress2" style="width:760px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td ><div style="width:95px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϲ�λ</div></td><td><div id="TD-txtCRZDBW" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���</div></td><td><div id="TD-cboCRZD" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">ICD����</div></td><td ><div id="TD-txtCRZDICD" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:95px;text-align:right;overflow:hidden;">ԭ���</div></td><td><div id="TD-cboCRYZD" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">ԭ�������</div></td><td><div id="TD-txtCRYZDRQ" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:200px;text-align:left;overflow:hidden;">��ԭ�����������ʱ��д��</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:95px;text-align:right;overflow:hidden;">����ѧ����</div></td><td><div id="TD-txtCRBLXLX" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">�����</div></td><td><div id="TD-txtCRBLH" style="width:220px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '			    <td><div style="width:95px;text-align:right;overflow:hidden;">ȷ��ʱ�ڱ�:T</div></td><td><div id="TD-cboCRTNMFQT" style="width:88px;overflow:hidden;"></div></td>'
		+ '			    <td><div style="width:20px;text-align:right;overflow:hidden;">N</div></td><td><div id="TD-cboCRTNMFQN" style="width:90px;overflow:hidden;"></div></td>'
		+ '			    <td><div style="width:20px;text-align:right;overflow:hidden;">M</div></td><td><div id="TD-cboCRTNMFQM" style="width:90px;overflow:hidden;"></div></td>'
		+ '			    <td><div style="width:50px;text-align:right;overflow:hidden;">�ڱ�</div></td><td><div id="TD-cboCRFHCD" style="width:136px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:340px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������(���������������������ע��ԭ����λ)</div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cbgCRZDYJ" style="width:800px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������</div></td><td><div id="TD-txtCRZDRQ" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�����ϵ�λ</div></td><td><div id="TD-cboCRZGZDDW" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td ><div style="width:74px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������λ</div></td><td><div id="TD-txtCRReportOrgan" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td ><div style="width:74px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-cboCRReportLoc" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����ҽ��</div></td><td><div id="TD-txtCRReportUser" style="width:199px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-txtCRReportDate" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">�������</div></td><td><div id="TD-cboCRSWZD" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">����ԭ��</div></td><td><div id="TD-cboCRSWYY" style="width:199px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtCRSWRQ" style="width:182px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;">����ICD10</div></td><td><div id="TD-txtCRSYICD" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������ԭ��</div></td><td><div id="TD-txtCRJTSWYY" style="width:460px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td colspan="10"><div style="width:260px;text-align:left;overflow:hidden;">��ʷժҪ(���ߡ��ٴ����ֺͼ�����)</div></td>'
		+ '			</tr><tr>'
		+ '				<td><div style="width:74px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-txtCRBSZY" style="width:780px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '</tr></table>'
	
	//���˻�����Ϣ
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","��Ƭ���");
    obj.txtPatientNo = Common_TextField("txtPatientNo","�ǼǺ�");
	obj.cboCRBQYGZBR=Common_ComboToDic("cboCRBQYGZBR","�����Ѹ�֪����","CRBQYGZBR");
    obj.txtPatName = Common_TextField("txtPatName","����");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","���֤��");
	obj.txtPatSex = Common_TextField("txtPatSex","�Ա�");
	obj.txtPatAge = Common_TextField("txtPatAge","����");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","���䵥λ","CRPatAge");
	obj.txtBirthDay = Common_DateFieldToDate1("txtBirthDay","��������");
	obj.cboCRZY=Common_ComboToDic("cboCRZY","ְҵ","CRZY");
	obj.cboCRMZ=Common_ComboToDic("cboCRMZ","����","CRMZ");
	obj.cboCRGZ = Common_ComboToDicGZ("cboCRGZ","����",DicTypeGZ);
	obj.txtJTDH = Common_TextField("txtJTDH","��ͥ�绰");
	obj.txtGZDW = Common_TextField("txtGZDW","������λ");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","��סʡ","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","��ס��","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","��ס��","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","��ס��/��","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","��ס��");
	obj.txtAdress1 = Common_TextField("txtAdress1","��ס��ϸ��ַ");
	obj.cboProvince2 = Common_ComboToArea("cboProvince2","����ʡ","1");
	obj.cboCity2 = Common_ComboToArea("cboCity2","������","cboProvince2");
	obj.cboCounty2 = Common_ComboToArea("cboCounty2","������","cboCity2");
	obj.cboVillage2 = Common_ComboToArea("cboVillage2","������/��","cboCounty2");
	obj.txtCUN2 = Common_TextField("txtCUN2","���ڴ�");
	obj.txtAdress2 = Common_TextField("txtAdress2","������ϸ��ַ");
	
	//�����Ϣ
	obj.txtCRZDBW = Common_TextField("txtCRZDBW","��ϲ�λ");
	obj.cboCRZD = Common_ComboToICD("cboCRZD","���");
	obj.txtCRZDICD = Common_TextField("txtCRZDICD","���ICD");
	obj.txtCRBLXLX = Common_TextField("txtCRBLXLX","����ѧ����");
	obj.txtCRBLH = Common_TextField("txtCRBLH","�����");
	obj.txtCRZDRQ = Common_DateFieldToDate("txtCRZDRQ","�������");
	obj.cboCRYZD = Common_ComboToICD("cboCRYZD","ԭ���");
	obj.txtCRYZDRQ = Common_DateFieldToDate1("txtCRYZDRQ","ԭ�������");
	obj.cboCRZGZDDW=Common_ComboToDic("cboCRZGZDDW","�����ϵ�λ","CRZGZDDW");
	obj.txtCRReportOrgan = Common_TextField("txtCRReportOrgan","������λ");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","��������","E","","I");
	obj.txtCRReportUser = Common_TextField("txtCRReportUser","����ҽ��");
	obj.txtCRReportDate = Common_DateFieldToDate("txtCRReportDate","��������");
	obj.txtCRSWRQ = Common_DateFieldToDate1("txtCRSWRQ","��������");
	obj.cboCRSWZD = Common_ComboToICD("cboCRSWZD","�������");
	obj.txtCRSYICD = Common_TextField("txtCRSYICD","����ICD10");
	obj.cboCRSWYY = Common_ComboToDic("cboCRSWYY","����ԭ��","CRSWYYzlk");
	obj.txtCRBSZY = Common_TextArea("txtCRBSZY","��ʷժҪ",50);
	obj.cbgCRZDYJ = Common_CheckboxGroupToDic("cbgCRZDYJ","�������","CRZDYJ",5);
	obj.txtCRJTSWYY = Common_TextField("txtCRJTSWYY","��������ԭ��");
	obj.cboCRTNMFQT = Common_ComboToDic("cboCRTNMFQT","ȷ��ʱ��T","CRTNMFQT");
	obj.cboCRTNMFQN = Common_ComboToDic("cboCRTNMFQN","ȷ��ʱ��N","CRTNMFQN");
	obj.cboCRTNMFQM = Common_ComboToDic("cboCRTNMFQM","ȷ��ʱ��M","CRTNMFQM");
	obj.cboCRFHCD = Common_ComboToDic("cboCRFHCD","�ڱ�","CRFHCD");
	
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
}