
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>ũҩ�ж����濨</span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
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
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ��ַ:ʡ</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:102px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:70px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϸ��ַ</div></td><td><div id="TD-txtAdress1" style="width:450px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ж�ũҩ����</div></td><td><div id="TD-txtZDNYMC" style="width:244px;overflow:hidden;"></div></td>'
		+ '				<td ><div id="TD-txtSHFSSJ" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:center;overflow:hidden;"><span style="color:red">*</span>ũҩ��������</div></td><td><div id="TD-cbgNYZLSL" style="width:200px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�ж�ԭ��</div></td><td><div id="TD-cbgZDYY" style="width:480px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:170px;text-align:center;overflow:hidden;"><span style="color:red">*</span>ְҵ��ȫ����֪ʶ��ѵ</div></td><td><div id="TD-cbgZSPX" style="width:300px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ʩҩ��ʽ</div></td><td><div id="TD-cbgSYFS" style="width:360px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>Σ����Ϊ</div></td><td><div id="TD-cbgWXXW" style="width:550px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ת��</div></td><td><div id="TD-cbgZDZG" style="width:480px;overflow:hidden;"></div></td><td><div id="TD-txtCRQTZG" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������</div></td><td><div id="TD-txtZDQR" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtSWRQ" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">���</div></td><td><div id="TD-txtReportUser" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">���λ</div></td><td><div id="TD-txtReportOrgan" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">�����</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '</table>'
	
	//���˻�����Ϣ
	obj.txtCRKPBH=Common_TextField("txtCRKPBH","��Ƭ���");
	obj.txtPatName = Common_TextField("txtPatName","����");
	obj.txtPatSex = Common_TextField("txtPatSex","�Ա�");
	obj.txtPatAge = Common_TextField("txtPatAge","����");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","���䵥λ","CRPatAge");
	obj.txtPatCardNo = Common_TextField("txtPatCardNo","���֤��");
	obj.txtLXDH = Common_TextField("txtLXDH","��ϵ�绰");
	obj.cboProvince1 = Common_ComboToArea("cboProvince1","ʡ","1");
	obj.cboCity1 = Common_ComboToArea("cboCity1","��","cboProvince1");
	obj.cboCounty1 = Common_ComboToArea("cboCounty1","��","cboCity1");
	obj.cboVillage1 = Common_ComboToArea("cboVillage1","��/��","cboCounty1");
	obj.txtCUN1 = Common_TextField("txtCUN1","��");
	obj.txtAdress1 = Common_TextField("txtAdress1","��ס��ϸ��ַ");
	
	obj.txtZDNYMC = Common_TextField("txtZDNYMC","�ж�ũҩ����");
	obj.cbgNYZLSL = Common_RadioGroupToDic("cbgNYZLSL","��������","CRNYZLSL",2);
	obj.cbgZDYY = Common_RadioGroupToDic("cbgZDYY","�ж�ԭ��","CRZDYY",4);
	obj.cbgZSPX = Common_RadioGroupToDic("cbgZSPX","֪ʶ��ѵ","CRZSPX",2);
	obj.cbgSYFS = Common_RadioGroupToDic("cbgSYFS","ʩҩ��ʽ","CRSYFS",3);
	obj.cbgWXXW = Common_CheckboxGroupToDic("cbgWXXW","Σ����Ϊ","CRWXXW",4);
	obj.cbgZDZG = Common_RadioGroupToDic("cbgZDZG","ת��","CRZDZG",4);
	obj.txtCRQTZG = Common_TextField("txtCRQTZG","����ת��","����ת��");
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