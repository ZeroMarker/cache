var objScreen = new Object();
function InitReportXNXG(){
    var obj = objScreen;
	obj.ReportID = ReportID;
	var htmlMainPanel = ''
		+ '<table class="table_report" align="center" border=0 cellpadding=0 cellspacing=0>'
		
		+ '		<tr><td width="100%"><div class="ReportTitle" style="width=100%;text-align:center;">'
		+ '		<span>���Ĳ������¼��������з�������</span>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��Ƭ���</div></td><td><div id="TD-txtKPBH" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">�ǼǺ�</div></td><td><div id="TD-txtRegNo" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-cboBGKLX" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		//������Ϣ
		+ '		<tr><td width="100%"><div class="ReportPannel" id="DivBaseInfo" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-txtPatName" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ա�</div></td><td><div id="TD-txtSex" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">����</div></td><td><div id="TD-txtAge" style="width:56px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:0px;text-align:right;overflow:hidden;"></div></td><td><div id="TD-cboPatAgeDW" style="width:44px;overflow:hidden;"></div></td>'		
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-dtBirthday" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����</div></td><td><div id="TD-cboNation" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���֤��</div></td><td><div id="TD-txtIdentify" style="width:130px;overflow:hidden;"></div></td>'
		+ '			  	<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ְҵ</div></td><td><div id="TD-cboOccupation" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���幤��</div></td><td><div id="TD-cboCRGZ" style="width:104px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�Ļ�</div></td><td><div id="TD-cboEducation" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������</div></td><td><div id="TD-cboMarital" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�绰</div></td><td><div id="TD-txtTelphone" style="width:130px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">������λ</div></td><td><div id="TD-txtCompany" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>Ŀǰ��ס��ַ:ʡ</div></td><td><div id="TD-cboCurrProvince" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboCurrCity" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��(��)</div></td><td><div id="TD-cboCurrCounty" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">�ֵ�</div></td><td><div id="TD-cboCurrVillage" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtCurrRoad" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ס��ϸ��ַ</div></td><td><div id="TD-txtCurrAddress" style="width:776px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ס���ڵ�ַ:ʡ</div></td><td><div id="TD-cboRegProvince" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-cboRegCity" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��(��)</div></td><td><div id="TD-cboRegCounty" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">�ֵ�</div></td><td><div id="TD-cboRegVillage" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��</div></td><td><div id="TD-txtRegRoad" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:120px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������ϸ��ַ</div></td><td><div id="TD-txtRegAddress" style="width:776px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		//������Ϣ
		+ '		<tr><td width="100%"><div class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>���</div></td><td><div id="TD-cboCRZD" style="width:290px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">ICD����</div></td><td><div id="TD-txtZDBM" style="width:104px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">���Ĳ�</div></td><td><div id="TD-cboGXBZD" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">������</div></td><td><div id="TD-cboNCZZD" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��Ҫ֢״:</div></td><td><div id="TD-cbgSYZZ" style="width:600px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��ʷ:</div></td><td><div id="TD-chkBS" style="width:600px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '		<tr><td width="100%"><div class="ReportPannel" style="width=100%;">'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-dtFBRQ" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ȷ������</div></td><td><div id="TD-dtQZRQ" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:105px;text-align:right;overflow:hidden;">�Ƿ��״η���</div></td><td><div id="TD-chgSFSCFB" style="width:65px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>ȷ�ﵥλ</div></td><td><div id="TD-cboQZDW" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>������λ</div></td><td><div id="TD-txtRepDW" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-cboCRReportLoc" style="width:120px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>����ҽ��</div></td><td><div id="TD-txtDoctor" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"><span style="color:red">*</span>��������</div></td><td><div id="TD-dtRepDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">����ԭ��</div></td><td><div id="TD-cboDeathReason" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">��������</div></td><td><div id="TD-dtDeathDate" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">�������</div></td><td><div id="TD-cboCRSWZD" style="width:294px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">����ICD</div></td><td><div id="TD-txtDeathICD" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:100px;text-align:right;overflow:hidden;">��������ԭ��</div></td><td><div id="TD-txtSWJTReason" style="width:244px;overflow:hidden;"></div></td>'
		+ ' 		</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:320px;text-align:right;overflow:hidden;">�������з���ʱ����CT/�˴Ź�����ʱ����</div></td><td><div id="TD-cboSJJG" style="width:218px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:125px;text-align:right;overflow:hidden;"><span style="color:red">*</span>�������:�Ź���</div></td><td><div id="TD-cboCGZ" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:55px;text-align:right;overflow:hidden;">Ѫ��ø</div></td><td><div id="TD-cboXQM" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">�ĵ�ͼ</div></td><td><div id="TD-cboXDT" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">CT</div></td><td><div id="TD-cboCT" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">Ѫ����Ӱ</div></td><td><div id="TD-cboXGZY" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:125px;text-align:right;overflow:hidden;">�ٴ�֢״</div></td><td><div id="TD-cboLCZZ" style="width:80px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:55px;text-align:right;overflow:hidden;">�Լ�Һ</div></td><td><div id="TD-cboNJY" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">ʬ��</div></td><td><div id="TD-cboSJ" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">�Ե�ͼ</div></td><td><div id="TD-cboNDT" style="width:100px;overflow:hidden;"></div></td>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;">ҽ�����</div></td><td><div id="TD-cboYSJC" style="width:100px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:125px;text-align:right;overflow:hidden;">�����ƶ�</div></td><td><div id="TD-cboSHTD" style="width:80px;overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:600px;text-align:left;overflow:hidden;">��ʷժҪ(�������ٴ����ֺ;��������)</div></td>'
		+ '			</tr></table>'
		+ '			<table><tr>'
		+ '				<td><div style="width:70px;text-align:right;overflow:hidden;"></div></td><td width="100%"><div id="TD-txtBSSummary" style="overflow:hidden;"></div></td>'
		+ '			</tr></table>'
		+ '		</div></td></tr>'
		+ '</tr></table>'
		
	//���˻�����Ϣ
    obj.txtKPBH  = Common_TextField("txtKPBH","��Ƭ���");
    obj.txtRegNo = Common_TextField("txtRegNo","�ǼǺ�");
	obj.cboBGKLX = Common_ComboToDic("cboBGKLX","��������","CRReportType");
    obj.txtPatName  = Common_TextField("txtPatName","��������");
    obj.txtSex 		= Common_TextField("txtSex","�Ա�");
	obj.cboCRGZ = Common_ComboToDicGZ("cboCRGZ","����",DicTypeGZ);
	obj.cboNation	= Common_ComboToDic("cboNation","����","CRMZ");
	obj.cboCardType = Common_ComboToDic("cboCardType","֤������","DTHCardType");
	obj.txtIdentify = Common_TextField("txtIdentify","֤������");
    obj.dtBirthday  = Common_DateFieldToDate("dtBirthday","��������");
    obj.txtAge 		= Common_TextField("txtAge","����");
	obj.cboPatAgeDW = Common_ComboToDic("cboPatAgeDW","���䵥λ","CRPatAge");
	obj.cboMarital 	= Common_ComboToDic("cboMarital","�������","CRDTHMarriage");
	obj.cboEducation  = Common_ComboToDic("cboEducation","�Ļ�","CRDTHEducation");
	obj.cboOccupation = Common_ComboToDic("cboOccupation","ְҵ","CRZY");
    obj.txtCompany  = Common_TextField("txtCompany","������λ");
	
    obj.txtRegAddress  = Common_TextField("txtRegAddress","������ϸ��ַ");
	obj.cboRegProvince = Common_ComboToArea("cboRegProvince","��ס����ʡ","1");
	obj.cboRegCity    = Common_ComboToArea("cboRegCity","��ס������","cboRegProvince");
	obj.cboRegCounty  = Common_ComboToArea("cboRegCounty","��ס������","cboRegCity");
	obj.cboRegVillage = Common_ComboToArea("cboRegVillage","��ס���ڽֵ�","cboRegCounty");
    obj.txtRegRoad 	  = Common_TextField("txtRegRoad","��ס���ڴ�");
    obj.txtCurrAddress  = Common_TextField("txtCurrAddress","��ס��ϸ��ַ");
	obj.cboCurrProvince = Common_ComboToArea("cboCurrProvince","��סʡ","1");
	obj.cboCurrCity    = Common_ComboToArea("cboCurrCity","��ס��","cboCurrProvince");
	obj.cboCurrCounty  = Common_ComboToArea("cboCurrCounty","��ס��","cboCurrCity");
	obj.cboCurrVillage = Common_ComboToArea("cboCurrVillage","��ס�ֵ�","cboCurrCounty");
    obj.txtCurrRoad = Common_TextField("txtCurrRoad","��ס��");
	
    obj.txtTelphone = Common_TextField("txtTelphone","�绰");
    obj.dtRepDate   = Common_DateFieldToDate("dtRepDate","�����");
    obj.dtDeathDate = Common_DateFieldToDate("dtDeathDate","��������");
    obj.cboDeathReason = Common_ComboToDic("cboDeathReason","����ԭ��","CRSWYYxnxg");
    obj.txtSWJTReason  = Common_TextField("txtSWJTReason","��������ԭ��");
	obj.cboCRSWZD = Common_ComboToICD("cboCRSWZD","�������");
	obj.txtDeathICD	   = Common_TextField("txtDeathICD","����ICD10");
    obj.cboSHTD = Common_ComboToDic("cboSHTD","�����ƶ�","CRSHTD");
    obj.cboSJJG = Common_ComboToDic("cboSJJG","ʱ����","CRSJJG");
    
	obj.cboCRZD = Common_ComboToICD("cboCRZD","���");
    obj.txtZDBM   = Common_TextField("txtZDBM","ICD����");
	obj.cbgSYZZ   = Common_CheckboxGroupToDic("cbgSYZZ","��Ҫ֢״(������)","CRSYZZ",4);
	obj.cboGXBZD  = Common_ComboToDic("cboGXBZD","���Ĳ����","CRGXBZD");
	obj.cboNCZZD  = Common_ComboToDic("cboNCZZD","���������","CRNZZZD");
	//obj.chgSFSCFB = Common_RadioGroupToDic("chgSFSCFB",'�Ƿ��״η���',"CEIsFristInfect",2)
	obj.chgSFSCFB = Common_Checkbox("chgSFSCFB",'�Ƿ��״η���');
	obj.chkBS  = Common_CheckboxGroupToDic("chkBS","��ʷ","CRZDBS",4)
    obj.dtFBRQ = Common_DateFieldToDate("dtFBRQ","��������");
    obj.dtQZRQ = Common_DateFieldToDate("dtQZRQ","ȷ������");
	obj.cboQZDW = Common_ComboToDic("cboQZDW","ȷ�ﵥλ","CRZGZDDW");
	obj.cboLCZZ = Common_ComboToDic("cboLCZZ","�ٴ�֢״","CRDiagnoseBase");
	obj.cboXGZY = Common_ComboToDic("cboXGZY","Ѫ����Ӱ","CRDiagnoseBase");
	obj.cboXDT  = Common_ComboToDic("cboXDT","�ĵ�ͼ","CRDiagnoseBase");
	obj.cboCT   = Common_ComboToDic("cboCT","CT","CRDiagnoseBase");
	obj.cboXQM  = Common_ComboToDic("cboXQM","Ѫ��ø","CRDiagnoseBase");
	obj.cboCGZ  = Common_ComboToDic("cboCGZ","�Ź���","CRDiagnoseBase");
	obj.cboNJY  = Common_ComboToDic("cboNJY","�Լ�Һ","CRDiagnoseBase");
	obj.cboSJ   = Common_ComboToDic("cboSJ","ʬ��","CRDiagnoseBase");
	obj.cboNDT  = Common_ComboToDic("cboNDT","�Ե�ͼ","CRDiagnoseBase");
	obj.cboYSJC = Common_ComboToDic("cboYSJC","�񾭿�ҽ�����","CRDiagnoseBase");
	
    obj.txtRepDW  = Common_TextField("txtRepDW","������λ");
    obj.txtDoctor = Common_TextField("txtDoctor","����ҽ��");
	obj.cboCRReportLoc = Common_ComboToLoc("cboCRReportLoc","��������","E","","I");
    obj.txtBSSummary = Common_TextArea("txtBSSummary","��ʷժҪ",50,600);
	
	obj.btnSubmit = new Ext.Button({
		id : 'btnSubmit'
		,iconCls : 'icon-save'
		,width : 75
		,text : '�ύ'
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
			obj.btnSubmit,
			obj.btnDelete,
			obj.btnCheck,
			obj.btnExport,
			obj.btnPrint,
			obj.btnCancle
		]
	});
	
    obj.MainViewPort=new Ext.Viewport({
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
	
    InitReportXNXGEvent(obj);
    obj.LoadEvent();
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 