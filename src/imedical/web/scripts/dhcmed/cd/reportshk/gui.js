
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>�˺���ⱨ�濨</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">���ҽԺ���</div></td><td><div id="TD-txtCRYYBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:200px;text-align:left;overflow:hidden;">&nbsp;</div></td>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>���߻�����Ϣ</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ա�</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatAge" style="width:56px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:44px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ�绰</div></td><td><div id="TD-txtLXDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���֤��</div></td><td><div id="TD-txtPatCardNo" style="width:274px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-cboCRHJ" style="width:104px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:200px;text-align:right;overflow:hidden;">�Ļ��̶�(����������д����)</div></td></div></td><td><div id="TD-cboCRWHCD" style="width:144px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ</div></td><td><div id="TD-cboCRZY" style="width:104px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTZY" style="width:170px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ��ַ:ʡ</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:104px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:98px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϸ��ַ</div></td><td><div id="TD-txtAdress1" style="width:450px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>���˺��¼��������</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺�����ʱ��</div></td><td><div id="TD-txtSHFSRQ" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td ><div id="TD-txtSHFSSJ" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td ><div style="width:100px;text-align:left;overflow:hidden;">ʱ(24Сʱ��)</div></td>'
		+ '			</tr></table>'	
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���߾���ʱ��</div></td><td><div id="TD-txtHZJZRQ" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td ><div id="TD-txtHZJZSJ" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td ><div style="width:100px;text-align:left;overflow:hidden;">ʱ(24Сʱ��)</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺�����ԭ��</div></td><td><div id="TD-cboSHFSYY" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTYY" style="width:180px;overflow:hidden;">'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺������ص�</div></td><td><div id="TD-cboSHFSDD" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTDD" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺������</div></td><td><div id="TD-cboSHFSSHD" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTHD" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ƿ����</div></td><td><div id="TD-cbgSHSFGY" style="width:540px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>���˺��ٴ���Ϣ</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:220px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺����ʣ�(ѡ�������ص�һ��)</div></td><td><div id="TD-cboCRSHXZ" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTXZ" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:220px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺���λ��(�������˺��Ĳ�λ)</div></td><td><div id="TD-cboCRSHBW" style="width:180px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTBW" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:115px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺����س̶ȣ�</div></td><td><div id="TD-cbgCRSHYZCD" style="width:370px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺��ٴ����</div></td><td><div id="TD-cboCRSHLCZD" style="width:200px;overflow:hidden;"></div></td><td><div id="TD-txtCRSHLCZDICD" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:85px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�˺���֣�</div></td><td><div id="TD-cbgCRSHJJ" style="width:550px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'

		+ '		<tr class="defaulttitle"><td width="100%"><div>'
		+ '		<span>���˺��漰��Ʒ��Ϣ</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivCPInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��Ʒ����1</div></td><td><div id="TD-txtSHCPMC1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">Ʒ��/�ͺ�1</div></td><td><div id="TD-txtSHPPXH1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��Ʒ����1</div></td><td><div id="TD-cboCRSHCPFL1" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��Ʒ����2</div></td><td><div id="TD-txtSHCPMC2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">Ʒ��/�ͺ�2</div></td><td><div id="TD-txtSHPPXH2" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��Ʒ����2</div></td><td><div id="TD-cboCRSHCPFL2" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">���</div></td><td><div id="TD-txtReportUser" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">�����</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:150px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���Ͱ���(�ɶ�ѡ):</div></td><td><div id="TD-cbgCRSHDYAL" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:180px;text-align:right;overflow:hidden;">ע���˿�����Ϊҽѧ֤����</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '</table>'
	
	//���˻�����Ϣ
	obj.txtCRYYBH = Common_TextField("txtCRYYBH","ҽԺ���");
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","��Ƭ���");
	obj.txtPatName = Common_TextField("txtPatName","����");
	obj.txtPatSex = Common_TextField("txtPatSex","�Ա�");
	obj.txtPatAge = Common_TextField("txtPatAge","����");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","���䵥λ","CRPatAge");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","���֤��");
	obj.txtLXDH = Common_TextField("txtLXDH","��ϵ�绰");
	obj.cboCRHJ = Common_ComboToDic("cboCRHJ","����","CRHJ");
	obj.cboCRWHCD = Common_ComboToDic("cboCRWHCD","�Ļ��̶�","CRDTHEducation");
	obj.cboCRZY = Common_ComboToDic("cboCRZY","ְҵ","CRZY");
	obj.txtCRQTZY = Common_TextField("txtCRQTZY","����ְҵ","����ְҵ");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","ʡ","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","��","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","��","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","��/��","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","��");
	obj.txtAdress1 = Common_TextField("txtAdress1","��ס��ϸ��ַ");
	
	obj.txtSHFSRQ = Common_DateFieldToDate("txtSHFSRQ","�˺���������");
	obj.txtSHFSSJ = Common_TextField("txtSHFSSJ","");
	obj.txtHZJZRQ = Common_DateFieldToDate("txtHZJZRQ","���߾�������");
	obj.txtHZJZSJ = Common_TextField("txtHZJZSJ","");
	obj.cboSHFSYY = Common_ComboToDic("cboSHFSYY","�˺�����ԭ��","CRSHFSYY");
	obj.txtCRQTYY = Common_TextField("txtCRQTYY","����ԭ��","����ԭ��");
	obj.cboSHFSDD = Common_ComboToDic("cboSHFSDD","�˺������ص�","CRSHFSDD");
	obj.txtCRQTDD = Common_TextField("txtCRQTDD","�����ص�","�����ص�");
	obj.cboSHFSSHD = Common_ComboToDic("cboSHFSSHD","�˺�����ʱ�","CRSHFSSHD");
	obj.txtCRQTHD = Common_TextField("txtCRQTHD","�����","�����");
	obj.cbgSHSFGY = Common_RadioGroupToDic("cbgSHSFGY","�Ƿ����","CRSHSFGY",4);
	
	obj.cboCRSHXZ = Common_ComboToDic("cboCRSHXZ","�˺�����","CRSHXZ");
	obj.txtCRQTXZ = Common_TextField("txtCRQTXZ","��������","��������");
	obj.cboCRSHBW = Common_ComboToDic("cboCRSHBW","�˺���λ","CRSHBW");
	obj.txtCRQTBW = Common_TextField("txtCRQTBW","������λ","������λ");
	obj.cbgCRSHYZCD = Common_RadioGroupToDic("cbgCRSHYZCD","���س̶�","CRSHYZCD",3);
	obj.cboCRSHLCZD = Common_ComboToICD("cboCRSHLCZD","�ٴ����");
	obj.txtCRSHLCZDICD = Common_TextField("txtCRSHLCZDICD","���ICD","���ICD");
	obj.cbgCRSHJJ = Common_RadioGroupToDic("cbgCRSHJJ","�˺����","CRSHJJ",4);
	obj.txtSHCPMC1 = Common_TextField("txtSHCPMC1","��Ʒ����1");
	obj.txtSHPPXH1 = Common_TextField("txtSHPPXH1","Ʒ��/�ͺ�1");
	obj.cboCRSHCPFL1 = Common_ComboToDic("cboCRSHCPFL1","�˺���Ʒ����1","CRSHCPFL");
	obj.txtSHCPMC2 = Common_TextField("txtSHCPMC2","��Ʒ����2");
	obj.txtSHPPXH2 = Common_TextField("txtSHPPXH2","Ʒ��/�ͺ�2");
	obj.cboCRSHCPFL2 = Common_ComboToDic("cboCRSHCPFL2","�˺���Ʒ����2","CRSHCPFL");
	
	obj.txtReportUser = Common_TextField("txtReportUser","���");
	obj.txtReportDate = Common_DateFieldToDate("txtReportDate","�����");
	obj.cbgCRSHDYAL = Common_CheckboxGroupToDic("cbgCRSHDYAL","���Ͱ���","CRSHDYAL",2);
	
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