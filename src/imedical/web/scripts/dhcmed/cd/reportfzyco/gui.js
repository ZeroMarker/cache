
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>��ְҵ��һ����̼�ж����濨</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr><td width="100%"><div id="DivBaseInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatName" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ա�</div></td><td><div id="TD-txtPatSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatAge" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ�绰</div></td><td><div id="TD-txtLXDH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ</div></td><td><div id="TD-cboCRZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">����ְҵ</div></td><td><div id="TD-txtCRQTZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����֤��</div></td><td><div id="TD-txtPatCardNo" style="width:286px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ַ ʡ</div></td><td><div id="TD-cboProvince1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:100px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:80px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϸ��ַ</div></td><td><div id="TD-txtAdress1" style="width:468px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		
		+ '		<tr><td width="100%"><div id="DivICDInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ж�����</div></td><td><div id="TD-txtCOZDRQ" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ж�ʱ��</div></td><td><div id="TD-txtCOZDSJ" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:300px;text-align:left;overflow:hidden;">(24Сʱ��,���������˵���ѡ��ʱ��)</div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ж�����ԭ��</div></td><td><div id="TD-cbgZDYY" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>�ж�����</div></td><td><div id="TD-cbgZDCS" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>�ж�����</div></td><td><div id="TD-cbgZDYS" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>��Ҫ֢״</div></td><td><div id="TD-cbgZYZZ" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"></div></td><td><div id="TD-txtCRQTZZ" style="width:180px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>�ж����</div></td><td><div id="TD-cbgZDZD" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>���δ�ʩ</div></td><td><div id="TD-cbgJZCS" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>ת��</div></td><td><div id="TD-cbgCOZG" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������</div></td><td><div id="TD-txtZDQR" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtSWRQ" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">���</div></td><td><div id="TD-txtReportUser" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">���λ</div></td><td><div id="TD-txtReportOrgan" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">�����</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
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
	obj.txtCRQTZY = Common_TextField("txtCRQTZY","","����ְҵ");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","����֤��");
	obj.txtLXDH = Common_TextField("txtLXDH","��ϵ�绰");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","ʡ","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","��","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","��","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","��/��","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","��");
	obj.txtAdress1 = Common_TextField("txtAdress1","��ס��ϸ��ַ");
	
	obj.txtCOZDRQ = Common_DateFieldToDate("txtCOZDRQ","�ж�����");
	obj.txtCOZDSJ = Common_TimeField("txtCOZDSJ","�ж�ʱ��");
	obj.cbgZDYY = Common_RadioGroupToDic("cbgZDYY","�ж�ԭ��","CRCOZDYY",3);
	obj.cbgZDYS = Common_RadioGroupToDic("cbgZDYS","�ж�����","CRZDYS",3);
	obj.cbgZYZZ = Common_CheckboxGroupToDic("cbgZYZZ","��Ҫ֢״","CRZYZZ",3);
	obj.txtCRQTZZ = Common_TextField("txtCRQTZZ","","����֢״");
	obj.cbgZDCS = Common_RadioGroupToDic("cbgZDCS","�ж�����","CRZDCS",3);
	obj.cbgZDZD = Common_RadioGroupToDic("cbgZDZD","�ж����","CRZDZD",3);
	obj.cbgJZCS = Common_CheckboxGroupToDic("cbgJZCS","���δ�ʩ","CRJZCS",3);
	obj.cbgCOZG = Common_RadioGroupToDic("cbgCOZG","ת��","CRCOZG",3);
	obj.txtZDQR = Common_DateFieldToDate("txtZDQR","�������")
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