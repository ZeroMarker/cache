
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	if (typeof tDHCMedMenuOper=="undefined") {
		ExtTool.alert("��ʾ","��û�в���Ȩ�ޣ����������Ա����Ȩ��!");
		return;
	}else{
		
	}
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>����ְҵ�����濨</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatName" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ա�</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatAge" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ�绰</div></td><td><div id="TD-txtLXDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���֤��</div></td><td><div id="TD-txtPatCardNo" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ</div></td><td><div id="TD-cboCRZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ַ ʡ</div></td><td><div id="TD-cboProvince1" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:100px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:80px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϸ��ַ</div></td><td><div id="TD-txtAdress1" style="width:468px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table>'
		+ ' 		<tr>'
		+ '				<td rowspan="4" style="border-right:1px solid #84C1FF;"><div style="width:80px;text-align:right;overflow:hidden;">���˵�λ<br>������Ϣ</div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��λ����</div></td><td><div id="TD-txtYRDWMC" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ҵ</div></td><td><div id="TD-txtDWHY" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ ' 		<tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ͨѶ��ַ</div></td><td><div id="TD-txtYRDWDZ" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">�ʱ�</div></td><td><div id="TD-txtYRDWYB" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ ' 		<tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ��</div></td><td><div id="TD-txtYRDWLXR" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�绰</div></td><td><div id="TD-txtYRDWLXRDH" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ ' 		<tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-txtJJLX" style="width:200px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ҵ��ģ</div></td><td><div id="TD-cbgQYGM" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr>'
		+ '			</table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������Դ</div></td><td><div id="TD-cbgBRLY" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ������</div></td><td><div id="TD-txtZYBZL" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���岡��</div></td><td><div id="TD-txtJTBM" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ж��¹ʱ���</div></td><td><div id="TD-txtZDSGBM" style="width:180px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ͬʱ�ж�����</div></td><td><div id="TD-txtTSZDRS" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ͳ�ƹ���</div></td><td><div id="TD-cbgTJGZ" style="width:250px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">רҵ����</div></td>'
		+ '				<td><div id="TD-txtZYGLN" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtZYGLY" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">�Ӵ�ʱ��</div></td>'
		+ '				<td><div id="TD-txtJCSJT" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td>'
		+ '				<td><div id="TD-txtJCSJS" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">ʱ</div></td>'
		+ '				<td><div id="TD-txtJCSJF" style="width:40px;overflow:hidden;"></div></td><td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td>'
		+ '				<td><div style="width:350px;text-align:left;overflow:hidden;">(������רҵ���䲻��1�����ߵļ���ְҵ������)</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-txtFSRQ" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������</div></td><td><div id="TD-txtZDRQ" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtSWRQ" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">���</div></td><td><div id="TD-txtReportUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">���λ</div></td><td><div id="TD-txtReportOrgan" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">�����</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '</table>'
	
	//���˻�����Ϣ
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","��Ƭ���");
	obj.txtPatName = Common_TextField("txtPatName","����");
	obj.txtPatSex = Common_TextField("txtPatSex","�Ա�");
	obj.txtPatAge = Common_TextField("txtPatAge","����");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","���䵥λ","CRPatAge");
	obj.cboCRZY=Common_ComboToDic("cboCRZY","ְҵ","CRZY");
	//obj.txtCRQTZY = Common_TextField("txtCRQTZY","","����ְҵ");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","���֤��");
	obj.txtLXDH = Common_TextField("txtLXDH","��ϵ�绰");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","ʡ","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","��","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","��","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","��/��","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","��");
	obj.txtAdress1 = Common_TextField("txtAdress1","��ס��ϸ��ַ");
	
	obj.txtYRDWMC = Common_TextField("txtYRDWMC","���˵�λ����");
	obj.txtYRDWDZ = Common_TextField("txtYRDWDZ","���˵�λ��ַ");
	obj.txtYRDWYB = Common_TextField("txtYRDWYB","���˵�λ�ʱ�");
	obj.txtYRDWLXR = Common_TextField("txtYRDWLXR","���˵�λ��ϵ��");
	obj.txtYRDWLXRDH = Common_TextField("txtYRDWLXRDH","��ϵ�˵绰");
	obj.txtJJLX = Common_TextField("txtJJLX","��������");
	obj.txtDWHY = Common_TextField("txtDWHY","��ҵ");
	obj.cbgQYGM = Common_RadioGroupToDic("cbgQYGM","��ҵ��ģ","CRQYGM",4);
	obj.cbgBRLY = Common_RadioGroupToDic("cbgBRLY","������Դ","CRBRLY",3);
	obj.txtZYBZL = Common_TextField("txtZYBZL","ְҵ������");
	obj.txtJTBM = Common_TextField("txtJTBM","���岡��");
	obj.txtZDSGBM = Common_TextField("txtZDSGBM","�ж��¹ʱ���");
	obj.txtTSZDRS = Common_TextField("txtTSZDRS","ͬʱ�ж�����");
	obj.cbgTJGZ = Common_RadioGroupToDic("cbgTJGZ","ͳ�ƹ���","CRTJGZ",3);
	obj.txtZYGLN = Common_TextField("txtZYGLN","רҵ������");
	obj.txtZYGLY = Common_TextField("txtZYGLY","רҵ������");
	obj.txtJCSJT = Common_TextField("txtJCSJT","�Ӵ�ʱ����");
	txtJCSJS = Common_TextField("txtJCSJS","�Ӵ�ʱ��ʱ");
	obj.txtJCSJF = Common_TextField("txtJCSJF","�Ӵ�ʱ���");
	obj.txtFSRQ = Common_DateFieldToDate("txtFSRQ","��������");
	obj.txtZDRQ = Common_DateFieldToDate("txtZDRQ","�������");
	obj.txtSWRQ = Common_DateFieldToDate1("txtSWRQ","��������");
	
	
	obj.txtReportUser = Common_TextField("txtReportUser","���");
	obj.txtReportOrgan= Common_TextField("txtReportOrgan","���λ");
	obj.txtReportDate = Common_DateFieldToDate("txtReportDate","�����");
	
	
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