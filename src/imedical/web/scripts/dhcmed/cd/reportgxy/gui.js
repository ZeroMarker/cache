
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	var htmlMainPanel = ''
		+ '<table align="center" border=0 cellpadding=0 cellspacing=0 style="border:1px solid #84C1FF;border-collapse:collapse;">'
		
		+ '		<tr><td width="100%"><div style="width=100%;text-align:center;">'
		+ '		<span style="font-size:28px;"><b>��Ѫѹ���濨</b></span>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtCRKPBH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">����</div></td><td><div id="TD-txtPatName" style="width:60px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">�Ա�</div></td><td><div id="TD-txtPatSex" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:40px;text-align:right;overflow:hidden;">����</div></td><td><div id="TD-txtPatAge" style="width:30px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:40px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-txtBirthDay" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">���֤��</div></td><td><div id="TD-txtPatCardNo" style="width:220px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:80px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ϵ�绰</div></td><td><div id="TD-txtLXDH" style="width:120px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ͥ��סַ:ʡ</div></td><td><div id="TD-cboProvince1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty1" style="width:80px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:40px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage1" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN1" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;">��ϸ��ͥ��סַ</div></td><td><div id="TD-txtAdress1" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">������ַ:ʡ</div></td><td><div id="TD-cboProvince2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCity2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCounty2" style="width:80px;overflow:hidden;"></div></td>'
		+ ' 			<td><div style="width:40px;text-align:right;overflow:hidden;">��/��</div></td><td><div id="TD-cboVillage2" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:20px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCUN2" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��ϸ������ַ</div></td><td><div id="TD-txtAdress2" style="width:400px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivICDInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">��Ѫѹ����</div></td><td><div id="TD-cbgGXYLX" style="width:250px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:160px;text-align:right;overflow:hidden;">����ѹ(mmHg)</div></td><td><div id="TD-txtSSY" style="width:70px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:90px;text-align:right;overflow:hidden;">��Ѫѹ�ּ�</div></td><td><div id="TD-cbgGXYFJ" style="width:300px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:110px;text-align:right;overflow:hidden;">����ѹ(mmHg)</div></td><td><div id="TD-txtSZY" style="width:70px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivLCInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:80px;text-align:center;overflow:hidden;">ȷ������</div></td><td><div id="TD-txtZDQR" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:center;overflow:hidden;">ȷ��ҽԺ</div></td><td><div id="TD-txtReportOrgan" style="width:150px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		
		+ '		<tr><td style="width=100%;height:3px;background-color:#84C1FF;"></td></tr>'
		
		+ '		<tr><td width="100%"><div id="DivTitle" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">���</div></td><td><div id="TD-txtReportUser" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:right;overflow:hidden;">�����</div></td><td><div id="TD-cboCRReportLoc" style="width:150px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:60px;text-align:left;overflow:hidden;">�����</div></td><td><div id="TD-txtReportDate" style="width:100px;overflow:hidden;"></div></td>'
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
	obj.cboProvince2 = Common_ComboToArea("cboProvince2","ʡ","1");
	obj.cboCity2 = Common_ComboToArea("cboCity2","��","cboProvince2");
	obj.cboCounty2 = Common_ComboToArea("cboCounty2","��","cboCity2");
	obj.cboVillage2 = Common_ComboToArea("cboVillage2","��ס������/��","cboCounty2");
	obj.txtCUN2 = Common_TextField("txtCUN2","��ס���ڴ�");
	obj.txtAdress2 = Common_TextField("txtAdress2","��ס��ϸ��ַ");
	obj.txtBirthDay = Common_DateFieldToDate("txtBirthDay","��������");
	
	obj.txtSSY = Common_TextField("txtSSY","����ѹ");
	obj.txtSZY = Common_TextField("txtSZY","����ѹ");
	obj.cbgZDYY = Common_RadioGroupToDic("cbgGXYLX","��Ѫѹ����","CRGXYLX",3);
	obj.cbgZSPX = Common_RadioGroupToDic("cbgGXYFJ","��Ѫѹ�ּ�","CRGXYFJ",4);
	obj.txtZDQR = Common_DateFieldToDate("txtZDQR","ȷ������")
	obj.txtReportOrgan= Common_TextField("txtReportOrgan","ȷ��ҽԺ");
	
	obj.txtReportUser = Common_TextField("txtReportUser","���");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","�����","E","","I");
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