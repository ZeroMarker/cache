function InitReportXNXGEvent(obj){
	obj.PatientCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportPAT");
	obj.ReportXNXGCls=ExtTool.StaticServerObject("DHCMed.CD.CRReportXNXG");
	obj.ReportCls=ExtTool.StaticServerObject("DHCMed.CD.CRReport");
	obj.ReportSrv=ExtTool.StaticServerObject("DHCMed.CDService.Service");
	obj.RepUpdateCls=ExtTool.StaticServerObject("DHCMed.CDService.UpdateService");
	obj.CtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
	obj.PatientSrv = ExtTool.StaticServerObject("DHCMed.Base.Patient")
	obj.LoadEvent = function() {
		obj.btnSubmit.on('click',obj.btnSubmit_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCheck.on("click",obj.btnCheck_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnCancle.on("click",obj.btnCancle_click,obj);
		
		Common_SetValue("dtDeathDate","");
		obj.cboCRZD.on("select",obj.cboCRZD_select,obj);
		obj.cboCRSWZD.on("select",obj.cboCRSWZD_select,obj);
		obj.cboOccupation.on('expand',obj.cboOccupation_expand,obj);
		obj.cboOccupation.on("select",obj.cboOccupation_select,obj);
		//������ַ
		obj.cboRegProvince.on('expand',obj.cboRegProvince_expand,obj);
		obj.cboRegCity.on('expand',obj.cboRegCity_expand,obj);
		obj.cboRegCounty.on('expand',obj.cboRegCounty_expand,obj);
		obj.cboRegVillage.on('expand',obj.cboRegVillage_expand,obj);
		obj.cboRegProvince.on('select',obj.cboRegProvince_Select,obj);
		obj.cboRegCity.on('select',obj.cboRegCity_Select,obj);
		obj.cboRegCounty.on('select',obj.cboRegCounty_Select,obj);
		obj.cboRegVillage.on('select',obj.cboRegVillage_Select,obj);
		
		//��ססַ
		obj.cboCurrProvince.on('expand',obj.cboCurrProvince_expand,obj);
		obj.cboCurrCity.on('expand',obj.cboCurrCity_expand,obj);
		obj.cboCurrCounty.on('expand',obj.cboCurrCounty_expand,obj);
		obj.cboCurrVillage.on('expand',obj.cboCurrVillage_expand,obj);
		obj.cboCurrProvince.on('select',obj.cboCurrProvince_Select,obj);
		obj.cboCurrCity.on('select',obj.cboCurrCity_Select,obj);
		obj.cboCurrCounty.on('select',obj.cboCurrCounty_Select,obj);
		obj.cboCurrVillage.on('select',obj.cboCurrVillage_Select,obj);
		
		Common_SetDisabled("txtKPBH",true);
		Common_SetDisabled("dtRepDate",true);
		if (obj.ReportID!=""){
			//�������ҳ�����ݼ���
			obj.InitRepByReportID();
		}else{
			//�½�����ҳ�����ݼ���
			obj.InitRepByEpisodeID();
		}
		obj.InitRepPowerByStatus(ReportID);
		//Common_SetValue("cboRegProvince",44195,"�㽭ʡ");
		//Common_SetValue("cboCurrProvince",44195,"�㽭ʡ");
		
		Common_SetDisabled("dtRepDate",true);
		Common_SetDisabled("txtDoctor",true);
		Common_SetDisabled("cboCRReportLoc",true);
		
		Common_SetDisabled("txtRegNo",true);
		Common_SetDisabled("txtPatName",true);
		Common_SetDisabled("txtSex",true);
		Common_SetDisabled("dtBirthday",true);
		//Common_SetDisabled("txtIdentify",true);
		Common_SetDisabled("cboNation",true);
		Common_SetDisabled("txtAge",true);
		Common_SetDisabled("cboPatAgeDW",true);
		//Common_SetDisabled("txtZDBM",true);
		obj.cboGXBZD.on("select",obj.cboGXBZD_select,obj);
		obj.cboNCZZD.on("select",obj.cboNCZZD_select,obj);
	}
	
	obj.cboGXBZD_select = function(){
		var objRec = arguments[1];
		if (objRec){
			//Common_SetValue("txtZDBM",objRec.get("ICD10"))
			Common_SetValue("cboNCZZD","","");
			Common_SetValue("cbgSYZZ","","");
			Common_SetDisabled("cbgSYZZ",true);
		}
	}
	obj.cboNCZZD_select = function(){
		var objRec = arguments[1];
		if (objRec){
			//Common_SetValue("txtZDBM",objRec.get("ICD10"))
			Common_SetValue("cboGXBZD","","");
			Common_SetDisabled("cbgSYZZ",false);
		}
	}
	obj.cboCRZD_select = function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtZDBM",objRec.get("ICD10"))
		}
	}
	obj.cboCRSWZD_select = function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtDeathICD",objRec.get("ICD10"))
		}
	}
	
	obj.cboOccupation_expand = function(){
		obj.cboCRGZ.setValue('');
	}
	
	obj.cboOccupation_select = function(){
		var objRec = arguments[1];
		if (objRec){
			var DicCode=objRec.get("DicCode");
			var DicType="CDGZ"+DicCode;
			DicTypeGZ=DicType;
			obj.cboCRGZ.getStore().load({}); 
		}
	}
	
	//��ʾ��ť����Ȩ�� ���ݱ���״̬�����Ȩ�޿���
	obj.InitRepPowerByStatus = function(ReportID){
		Common_SetVisible("btnSubmit",false);
		Common_SetVisible("btnPrint",false);
		Common_SetVisible("btnExport",false);
		Common_SetVisible("btnDelete",false);
		Common_SetVisible("btnCheck",false);
		Common_SetVisible("btnCancle",false);
		obj.RepStatusCode=obj.ReportSrv.GetReportStatus(ReportID);
     	switch (obj.RepStatusCode) {
			case "" : // �ޱ��� ֻ���ϱ�
				Common_SetVisible("btnSubmit",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "1" : // ����
				obj.btnSubmit.setText("�޸ı���");
				Common_SetVisible("btnSubmit",true);
				Common_SetVisible("btnDelete",true);
				Common_SetVisible("btnCheck",true);
				Common_SetVisible("btnExport",true);
				Common_SetVisible("btnPrint",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "2" : // ���
				Common_SetVisible("btnPrint",true);
				Common_SetVisible("btnExport",true);
				Common_SetVisible("btnCancle",true);
				break;
			case "3" : // ɾ��
				Common_SetVisible("btnCancle",true);
				break;
		}
		
		if (tDHCMedMenuOper['Submit']!=1) {
			Common_SetVisible("btnSubmit",false);
		}
		if (tDHCMedMenuOper['Check']!=1) {
			Common_SetVisible("btnCheck",false);
		}
		if (tDHCMedMenuOper['Check']) {
			Common_SetVisible("btnDelete",false);
		}
	}
	//������ַ�����¼�
	obj.cboRegProvince_expand = function(){
		obj.cboRegProvince.setValue('');
		obj.cboRegCity.setValue('');
		obj.cboRegCounty.setValue('');
		obj.cboRegVillage.setValue('');
	}
	obj.cboRegCity_expand = function(){
		obj.cboRegCity.clearValue();
		obj.cboRegCounty.clearValue();
		obj.cboRegVillage.clearValue();
	}
	obj.cboRegCounty_expand = function(){
		obj.cboRegCounty.clearValue();
		obj.cboRegVillage.clearValue();
	}
	obj.cboRegVillage_expand = function(){
		obj.cboRegVillage.clearValue();
	}

	obj.cboRegProvince_Select = function(){
		obj.cboRegCity.getStore().load({}); 
		obj.cboRegCounty.getStore().load({}); 
		obj.cboRegVillage.getStore().load({}); 
	}
	obj.cboRegCity_Select = function(){
		obj.cboRegCounty.getStore().load({}); 
		obj.cboRegVillage.getStore().load({}); 
	}
	obj.cboRegCounty_Select = function(){
		obj.cboRegVillage.getStore().load({}); 
	}
	obj.cboRegVillage_Select = function(){
	}
	//��ס��ַ�����¼�
	obj.cboCurrProvince_expand = function(){
		obj.cboCurrProvince.setValue('');
		obj.cboCurrCity.setValue('');
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrCity_expand = function(){
		obj.cboCurrCity.setValue('');
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrCounty_expand = function(){
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrVillage_expand = function(){
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrProvince_Select = function(){
		obj.cboCurrCity.getStore().load({}); 
		obj.cboCurrCounty.getStore().load({}); 
		obj.cboCurrVillage.getStore().load({}); 
	}
	obj.cboCurrCity_Select = function(){
		obj.cboCurrCounty.getStore().load({}); 
		obj.cboCurrVillage.getStore().load({}); 
	}
	obj.cboCurrCounty_Select = function(){
		obj.cboCurrVillage.getStore().load({}); 
	}
	obj.cboCurrVillage_Select = function(){
	}
	//����ҳ���ʼ��
	obj.InitRepByReportID=function(){
		var objRep=obj.ReportCls.GetStringById(obj.ReportID);
		var objXNXG=obj.ReportXNXGCls.GetStringByParRef(obj.ReportID);
		var objPat=obj.PatientCls.GetStringByParRef(obj.ReportID);
		var arrRep=objRep.split("^");
		var arrXNXG=objXNXG.split("^");
		var arrPat=objPat.split("^");
		
		Common_SetValue("txtKPBH",arrXNXG[0]);
		Common_SetValue("txtRegNo",arrPat[3]);
		Common_SetValue("cboBGKLX",arrXNXG[18].split(CHR_1)[0],arrXNXG[18].split(CHR_1)[1]);
		
		Common_SetValue("txtPatName",arrPat[4]);
		Common_SetValue("txtSex",arrPat[6]);
		Common_SetValue("cboCRGZ",arrPat[17].split(CHR_1)[0],arrPat[17].split(CHR_1)[1]);
		Common_SetValue("cboNation",arrPat[13].split(CHR_1)[0],arrPat[13].split(CHR_1)[1]);
		Common_SetValue("txtIdentify",arrPat[11]);
		Common_SetValue("dtBirthday",arrPat[7]);
		var patAge="";
		var patAgeDW="";
		if(arrPat[8]!=""){
			patAge=arrPat[8];
			patAgeDW="��";
		}else if(arrPat[9]!=""){
			patAge=arrPat[9];
			patAgeDW="��";
		}else{
			patAge=arrPat[10];
			patAgeDW="��";
		}
		Common_SetValue("txtAge",patAge);
		Common_SetValue("cboPatAgeDW","",patAgeDW);
		Common_SetValue("cboMarital",arrPat[14].split(CHR_1)[0],arrPat[14].split(CHR_1)[1]);
		Common_SetValue("cboEducation",arrPat[15].split(CHR_1)[0],arrPat[15].split(CHR_1)[1]);
		Common_SetValue("cboOccupation",arrPat[16].split(CHR_1)[0],arrPat[16].split(CHR_1)[1]);
		Common_SetValue("txtCompany",arrPat[21]);
		
		Common_SetValue("cboCurrProvince",arrPat[29].split(CHR_1)[0],arrPat[29].split(CHR_1)[1]);
		Common_SetValue("cboCurrCity",arrPat[30].split(CHR_1)[0],arrPat[30].split(CHR_1)[1]);
		Common_SetValue("cboCurrCounty",arrPat[31].split(CHR_1)[0],arrPat[31].split(CHR_1)[1]);
		Common_SetValue("cboCurrVillage",arrPat[32].split(CHR_1)[0],arrPat[32].split(CHR_1)[1]);
		Common_SetValue("txtCurrRoad",arrPat[33]);
		Common_SetValue("txtCurrAddress",arrPat[34]);
		Common_SetValue("cboRegProvince",arrPat[23].split(CHR_1)[0],arrPat[23].split(CHR_1)[1]);
		Common_SetValue("cboRegCity",arrPat[24].split(CHR_1)[0],arrPat[24].split(CHR_1)[1]);
		Common_SetValue("cboRegCounty",arrPat[25].split(CHR_1)[0],arrPat[25].split(CHR_1)[1]);
		Common_SetValue("cboRegVillage",arrPat[26].split(CHR_1)[0],arrPat[26].split(CHR_1)[1]);
		Common_SetValue("txtRegRoad",arrPat[27]);
		Common_SetValue("txtRegAddress",arrPat[28]);
		Common_SetValue("txtTelphone",arrPat[20]);
		
		Common_SetValue("dtRepDate",arrRep[7]);
		Common_SetValue("dtDeathDate",arrXNXG[12]);
		Common_SetValue("cboDeathReason",arrXNXG[13].split(CHR_1)[0],arrXNXG[13].split(CHR_1)[1]);
		Common_SetValue("txtSWJTReason",arrXNXG[16]);
		Common_SetValue("txtDeathICD",arrXNXG[15]);
		
		Common_SetValue("txtZDBM",arrXNXG[2]);
		Common_SetValue("cboCRZD",arrXNXG[1].split(CHR_1)[0],arrXNXG[1].split(CHR_1)[1]); //fix bug 191750 �򿪱�����ϲ���ʾ���
		Common_SetValue("cbgSYZZ",arrXNXG[19]);
		Common_SetValue("cboSHTD",arrXNXG[20].split(CHR_1)[0],arrXNXG[20].split(CHR_1)[1]);
		Common_SetValue("cboSJJG",arrXNXG[21].split(CHR_1)[0],arrXNXG[21].split(CHR_1)[1]);
		Common_SetValue("cboCRSWZD",arrXNXG[22].split(CHR_1)[0],arrXNXG[22].split(CHR_1)[1]);//fix bug 191750 �򿪱�����ϲ���ʾ�������
		
		if(arrXNXG[3].split("-")[1]=="GXB"){
			Common_SetValue("cboGXBZD",arrXNXG[1],arrXNXG[3].split("-")[0]);
			Common_SetDisabled("cbgSYZZ",true); // fix bug 191750 �򿪱��� �����Ϸ����ǹ��Ĳ� ������������Ҫ֢״����ѡ
		}
		if(arrXNXG[3].split("-")[1]=="NCZ"){
			Common_SetValue("cboNCZZD",arrXNXG[1],arrXNXG[3].split("-")[0]);
		}
		/*if(arrXNXG[9]){
			Common_SetValue("chgSFSCFB","","��");
		}else{
			Common_SetValue("chgSFSCFB","","��");
		}*/
		Common_SetValue("chgSFSCFB",arrXNXG[9]);
		
		Common_SetValue("chkBS",arrXNXG[6]);
		Common_SetValue("dtFBRQ",arrXNXG[7]);
		Common_SetValue("dtQZRQ",arrXNXG[8]);
		Common_SetValue("cboQZDW",arrXNXG[10].split(CHR_1)[0],arrXNXG[10].split(CHR_1)[1]);
		var DiagBase=arrXNXG[5].split(",");
		
		Common_SetValue("cboLCZZ",DiagBase[0].split(CHR_1)[0],DiagBase[0].split(CHR_1)[1]);
		Common_SetValue("cboXGZY",DiagBase[1].split(CHR_1)[0],DiagBase[1].split(CHR_1)[1]);
		Common_SetValue("cboXDT",DiagBase[2].split(CHR_1)[0],DiagBase[2].split(CHR_1)[1]);
		Common_SetValue("cboCT",DiagBase[3].split(CHR_1)[0],DiagBase[3].split(CHR_1)[1]);
		Common_SetValue("cboXQM",DiagBase[4].split(CHR_1)[0],DiagBase[4].split(CHR_1)[1]);
		Common_SetValue("cboCGZ",DiagBase[5].split(CHR_1)[0],DiagBase[5].split(CHR_1)[1]);
		Common_SetValue("cboNJY",DiagBase[6].split(CHR_1)[0],DiagBase[6].split(CHR_1)[1]);
		Common_SetValue("cboSJ",DiagBase[7].split(CHR_1)[0],DiagBase[7].split(CHR_1)[1]);
		Common_SetValue("cboNDT",DiagBase[8].split(CHR_1)[0],DiagBase[8].split(CHR_1)[1]);
		Common_SetValue("cboYSJC",DiagBase[9].split(CHR_1)[0],DiagBase[9].split(CHR_1)[1]);
		
		Common_SetValue("txtRepDW",arrRep[6]);
		Common_SetValue("txtDoctor",arrRep[5]);
		Common_SetValue("cboCRReportLoc",arrRep[3],arrRep[4]);
		Common_SetValue("txtBSSummary",arrXNXG[17]);
	}
	//�½�����ҳ���ʼ��
	obj.InitRepByEpisodeID = function(){
		Common_SetValue("txtRepDW",HospDesc);
		Common_SetValue("txtDoctor",session['LOGON.USERNAME']);
		var LogLocID = session['LOGON.CTLOCID'];
		var objLoc = obj.CtlocSrv.GetObjById(LogLocID);
		Common_SetValue("cboCRReportLoc",objLoc.Rowid,objLoc.Descs);
		if(PatientID!=""){
			var objPat=obj.PatientSrv.GetObjById(PatientID);
			Common_SetValue("txtRegNo",objPat.PapmiNo);
			Common_SetValue("txtPatName",objPat.PatientName);
			Common_SetValue("txtSex",objPat.Sex);
			Common_SetValue("dtBirthday",objPat.Birthday);
			Common_SetValue("txtIdentify",objPat.PersonalID);
			Common_SetComboSSDicValue("cboNation","CRMZ","",objPat.Nation);
			if ((objPat.Marital=="����")||(objPat.Marital=="����")||(objPat.Marital=="�ٻ�"))
				objPat.Marital=="�ѻ�";
			Common_SetComboSSDicValue("cboMarital","CRDTHMarriage","",objPat.Marital);
			//Common_SetValue("txtAge",objPat.Age);
			//Common_SetValue("cboPatAgeDW","","��");
			Common_SetValue("txtCompany",objPat.WorkAddress);
			Common_SetValue("txtCurrAddress",objPat.Address);
			Common_SetValue("txtRegAddress",objPat.Address);
			Common_SetValue("txtTelphone",objPat.Telephone);
			var AgeY=objPat.Age;
			var AgeM=objPat.AgeMonth;
			var AgeD=objPat.AgeDay;
			if (AgeY>0){
				Common_SetValue("txtAge",objPat.Age);
				Common_SetValue("cboPatAgeDW","","��");
			}else if(AgeM>0){
				Common_SetValue("txtAge",objPat.AgeMonth);
				Common_SetValue("cboPatAgeDW","","��");
			}else {
				Common_SetValue("txtAge",objPat.AgeDay);
				Common_SetValue("cboPatAgeDW","","��");
			}
		}
	}
	//�ύ��ť�����¼�
	obj.btnSubmit_click = function(){
		if (obj.CheckReport() != true) return;
		obj.SaveReport("1");
	}
	
	obj.SaveReport=function(StatusCode){
		var Separate="^";                                 //�ָ���
		var CardNo		= obj.txtKPBH.getValue();         //��Ƭ���
		var PapmiNo		= obj.txtRegNo.getValue();        //�ǼǺ�
		var RepType		= obj.cboBGKLX.getValue();        //���濨����
		var Name		= obj.txtPatName.getValue();      //��������
		var Identify	= obj.txtIdentify.getValue();     //֤������
		var Sex			= obj.txtSex.getValue();          //�Ա�
		var Age			= obj.txtAge.getValue();          //����
		var AgeDW		= obj.cboPatAgeDW.getRawValue()	  //���䵥λ
		var NLS,NLY,NLT="";
		if(AgeDW=="��"){
			NLS=Age;
			NLY="";
			NLT="";
		}else if(AgeDW=="��"){
			NLY=Age;
			NLT="";
			NLS="";
		}else{
			NLT=Age;
			NLY="";
			NLS="";
		}
		
		var Birthday	= obj.dtBirthday.getRawValue();   //��������
		var Occupation	= obj.cboOccupation.getValue();   //ְҵ
		var Country		= obj.cboCRGZ.getValue();         //���幤��
		var Nation		= obj.cboNation.getValue();       //����
		var Education	= obj.cboEducation.getValue();    //�Ļ��̶�
		var Marital		= obj.cboMarital.getValue();      //����״��
		var Telphone	= obj.txtTelphone.getValue();     //��ϵ�绰
		var Company		= obj.txtCompany.getValue();      //������λ
		
		//��ס��ַ(ʡ������)
		var CurrProvince	= Common_GetValue('cboCurrProvince');
		var CurrCity		= Common_GetValue('cboCurrCity');
		var CurrCounty		= Common_GetValue('cboCurrCounty');
		var CurrVillage		= Common_GetValue('cboCurrVillage');
		var CurrProvinceDesc= Common_GetText('cboCurrProvince');
		var CurrCityDesc	= Common_GetText('cboCurrCity');
		var CurrCountyDesc	= Common_GetText('cboCurrCounty');
		var CurrVillageDesc	= Common_GetText('cboCurrVillage');
		var CurrRoad		= Common_GetValue('txtCurrRoad');
		//CurrProvinceDesc + CurrCityDesc + CurrCountyDesc + CurrVillageDesc + CurrRoad;
		var CurrAddress 	= Common_GetValue('txtCurrAddress')
		//������ַ(ʡ������)
		var RegProvince		= Common_GetValue('cboRegProvince');
		var RegCity			= Common_GetValue('cboRegCity');
		var RegCounty		= Common_GetValue('cboRegCounty');
		var RegVillage		= Common_GetValue('cboRegVillage');
		var RegProvinceDesc	= Common_GetText('cboRegProvince');
		var RegCityDesc		= Common_GetText('cboRegCity');
		var RegCountyDesc	= Common_GetText('cboRegCounty');
		var RegVillageDesc	= Common_GetText('cboRegVillage');
		var RegRoad			= Common_GetValue('txtRegRoad');
		 //RegProvinceDesc + RegCityDesc + RegCountyDesc + RegVillageDesc + RegRoad;
		var RegAddress 		= Common_GetValue('txtRegAddress')
		
		//�����Ϣ
		var ICD10	= Common_GetValue('txtZDBM')			//ICD����
		var ICDID = Common_GetValue('cboCRZD')            //�������
		var ICDDesc = Common_GetText('cboCRZD')            //�������
	  
		var GXBDiagID   = Common_GetValue('cboGXBZD')		//���Ĳ����
		var GXBDiagDesc = Common_GetText('cboGXBZD')
		var NCZDiagID   = Common_GetValue('cboNCZZD')		//���������
		var NCZDiagDesc = Common_GetText('cboNCZZD')
		var Symptom = Common_GetValue('cbgSYZZ')			//��Ҫ֢״
			
		var History  = Common_GetValue("chkBS") 			//��ʷ
		var InfDate  = Common_GetValue('dtFBRQ')			//��������
		var DiagDate = Common_GetValue('dtQZRQ')			//ȷ������
		var IsFirst  = (Common_GetValue("chgSFSCFB")?1:0) 		//�Ƿ��״η���
		var DiagUnit = Common_GetValue("cboQZDW") 			//ȷ�ﵥλ
		var RepOrgan = Common_GetValue("txtRepDW") 			//�ϱ���λ
		var RepDoc   = Common_GetValue("txtDoctor") 		//����ҽ��
		var RepDate  = Common_GetValue('dtRepDate')		//��������
		var DeathDate	= Common_GetValue('dtDeathDate')	//��������
		var DeathReason = Common_GetValue("cboDeathReason") //����ԭ��
		var DeathICDID 	= Common_GetValue("txtDeathICD") 	//����ICD
		var DeathICDDesc = Common_GetText("cboDeathReason") 	//����ԭ��
		var DeathCause 	= Common_GetValue("txtSWJTReason") 	//����ԭ������
		var Summary 	= Common_GetValue("txtBSSummary") 	//��ʷժҪ
		var SJJG = Common_GetValue("cboSJJG")
		
		//�������
		var DiagBase = obj.cboLCZZ.getValue()+"#"+obj.cboXGZY.getValue()+"#"+obj.cboXDT.getValue()+"#"+obj.cboCT.getValue()+"#"+obj.cboXQM.getValue()+"#"+obj.cboCGZ.getValue()+"#"+obj.cboNJY.getValue()+"#"+obj.cboSJ.getValue()+"#"+obj.cboNDT.getValue()+"#"+obj.cboYSJC.getValue();
		
		var MainInfo="",PatInfo="",DiagInfo="";		//������Ϣ�����˻�����Ϣ�������Ϣ
		
		//������Ϣ
		MainInfo = obj.ReportID;						 	//����ID	1
		MainInfo = MainInfo+Separate+EpisodeID;	 	//�����	2
		MainInfo = MainInfo+Separate+"XNXG";	 		//��������(XNXG-����Ѫ��)	3
		MainInfo = MainInfo+Separate+1;	 		//����״̬code	4
		MainInfo = MainInfo+Separate+Common_GetValue("cboCRReportLoc"); //session['LOGON.CTLOCID'];	 	//�����	5
		MainInfo = MainInfo+Separate+RepDoc;	 		//�ҽ��	6
		MainInfo = MainInfo+Separate+RepOrgan;	 		//�ϱ���λ	7
		MainInfo = MainInfo+Separate+RepDate;	 		//�����	8
		MainInfo = MainInfo+Separate+"";	 			//�ʱ��	9
		MainInfo = MainInfo+Separate+session['LOGON.USERID'];	 	//������	10
		MainInfo = MainInfo+Separate+"";	 			//��������	11
		MainInfo = MainInfo+Separate+"";	 			//����ʱ��	12
		MainInfo = MainInfo+Separate+"0";	 			//��˱��	13
		MainInfo = MainInfo+Separate+"";	 			//�����	14
		MainInfo = MainInfo+Separate+"";	 			//�������	15
		MainInfo = MainInfo+Separate+"";	 			//���ʱ��	16
		MainInfo = MainInfo+Separate+"0";	 			//�������	17
		MainInfo = MainInfo+Separate+"";	 			//������	18
		MainInfo = MainInfo+Separate+"";	 			//��������	19
		MainInfo = MainInfo+Separate+"";	 			//����ʱ��	20
		MainInfo = MainInfo+Separate+"";	 			//��ע		21
		MainInfo = MainInfo+Separate+session['LOGON.CTLOCID'];	//���¿���		22
		
		//���˻�����Ϣ
		PatInfo = obj.ReportID
		PatInfo = PatInfo+Separate+PatientID;	//CRPatientID
		PatInfo = PatInfo+Separate+"";	//CRMZH
		PatInfo = PatInfo+Separate+"";	//CRZYH
		PatInfo = PatInfo+Separate+PapmiNo;	//CRDJH
		PatInfo = PatInfo+Separate+Name;	//CRXM
		PatInfo = PatInfo+Separate+"";	//CRJZXM
		PatInfo = PatInfo+Separate+Sex;	//CRXB
		PatInfo = PatInfo+Separate+Birthday;	//CRCSRQ
		
		PatInfo = PatInfo+Separate+NLS;	//CRNLS
		PatInfo = PatInfo+Separate+NLY;	//CRNLY
		PatInfo = PatInfo+Separate+NLT;	//CRNLT
		PatInfo = PatInfo+Separate+Identify;	//CRSFZH
		PatInfo = PatInfo+Separate+"";	//CRJTDH
		PatInfo = PatInfo+Separate+Nation;	//CRMZ
		PatInfo = PatInfo+Separate+Marital;	//CRHYZK
		PatInfo = PatInfo+Separate+Education;	//CRWHCD
		PatInfo = PatInfo+Separate+Occupation;	//CRZY
		PatInfo = PatInfo+Separate+Country;	//CRGZ
		PatInfo = PatInfo+Separate+"";	//CRLXR
		PatInfo = PatInfo+Separate+"";	//CRYBRGX
		PatInfo = PatInfo+Separate+Telphone;	//CRLXDH
		PatInfo = PatInfo+Separate+Company;	//CRGZDW
		PatInfo = PatInfo+Separate+"";	//CRHJ
		PatInfo = PatInfo+Separate+RegProvince;	//CRHJDZS
		PatInfo = PatInfo+Separate+RegCity;	//CRHJDZS2
		PatInfo = PatInfo+Separate+RegCounty;	//CRHJDZX
		PatInfo = PatInfo+Separate+RegVillage;	//CRHJDZX2
		PatInfo = PatInfo+Separate+RegRoad;	//CRHJDZC
		PatInfo = PatInfo+Separate+RegAddress;	//CRHJDZXX
		PatInfo = PatInfo+Separate+CurrProvince;	//CRCZDZS
		PatInfo = PatInfo+Separate+CurrCity;	//CRCZDZS2
		PatInfo = PatInfo+Separate+CurrCounty;	//CRCZDZX
		PatInfo = PatInfo+Separate+CurrVillage;	//CRCZDZX2
		PatInfo = PatInfo+Separate+CurrRoad;	//CRCZDZC
		PatInfo = PatInfo+Separate+CurrAddress;	//CRCZDZXX
		//������Ϣ
		DiagInfo=obj.ReportID;								//ReportID	1
		DiagInfo = DiagInfo+Separate+CardNo;			//��Ƭ���	2
		DiagInfo = DiagInfo+Separate+RepType;			//���濨����	3
		DiagInfo = DiagInfo+Separate+ICDID+","+ICDDesc;		    //ICDID(�������)
		DiagInfo = DiagInfo+Separate+ICD10;			//ICD����	5
		if (GXBDiagID!=""){
			DiagInfo = DiagInfo+Separate+GXBDiagID+","+GXBDiagDesc+"-"+"GXB";	//��Ϸ���		6
		}else{
			DiagInfo = DiagInfo+Separate+NCZDiagID+","+NCZDiagDesc+"-"+"NCZ";	//��Ϸ���	    6
		}
		DiagInfo = DiagInfo+Separate+DiagBase;			//�������	7
		DiagInfo = DiagInfo+Separate+History;			//��ʷ	8
		DiagInfo = DiagInfo+Separate+InfDate;			//��������	9
		DiagInfo = DiagInfo+Separate+DiagDate;			//ȷ������	10
		DiagInfo = DiagInfo+Separate+IsFirst;			//�Ƿ��״η���	11
		DiagInfo = DiagInfo+Separate+DiagUnit;			//ȷ�ﵥλ	12
		DiagInfo = DiagInfo+Separate+"";				//ת��	13
		DiagInfo = DiagInfo+Separate+DeathDate;		//��������	14
		DiagInfo = DiagInfo+Separate+DeathReason+","+DeathICDDesc;		//����ԭ��	15
		DiagInfo = DiagInfo+Separate+DeathICDID;		//����ICD	16
		DiagInfo = DiagInfo+Separate+DeathCause;		//��������ԭ��	17
		DiagInfo = DiagInfo+Separate+Symptom;			//��Ҫ֢״	18
		DiagInfo = DiagInfo+Separate+Summary;			//��ʷժҪ	19
		DiagInfo = DiagInfo+Separate+Common_GetValue("cboSHTD");
		DiagInfo = DiagInfo+Separate+SJJG;
		DiagInfo = DiagInfo+Separate+Common_GetValue("cboCRSWZD");
		
		var ret=obj.RepUpdateCls.SaveRepData(MainInfo,DiagInfo,PatInfo);
		if(parseInt(ret)<=0){
			ExtTool.alert("����","���ݱ������!"+ret);
			return;
		}else{
			ExtTool.alert("��ʾ","���ݱ���ɹ�!");
			obj.ReportID=ret;
			obj.InitRepPowerByStatus(obj.ReportID); //���²�����ť
		}
	}
	
	
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","��δ�ϱ�!");
			return;
		}
		Ext.MessageBox.confirm("��ʾ","��ȷ���Ƿ�ɾ��?",function(btn){
			if(btn=="yes"){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				DeleteStr=DeleteStr+"^"+session['LOGON.USERID'];
				DeleteStr=DeleteStr+"^"+session['LOGON.CTLOCID'];
				DeleteStr=DeleteStr+"^"+"DELETE";
				var ret=obj.ReportCls.DeleteReport(DeleteStr,"^");
				if(parseInt(ret)<=0){
					ExtTool.alert("����","ɾ��ʧ��!"+ret);
					return;
				}else{
					ExtTool.alert("��ʾ","����ɾ���ɹ�!");
					obj.InitRepPowerByStatus(obj.ReportID); //���²�����ť
				}
			}
		});
	};
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","���������ϱ�������");
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];
		var ret=obj.ReportCls.CheckReport(CheckStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("����","�������ʧ��!"+ret);
			return;
		}else{
			ExtTool.alert("��ʾ","������˳ɹ�!");
			obj.InitRepPowerByStatus(obj.ReportID); //���²�����ť
		}
	};
	obj.btnExport_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","���������ϱ�������");
			return;
		}
		var ExportStr=obj.ReportID;
		ExportStr=ExportStr+"^"+session['LOGON.USERID'];
		ExportStr=ExportStr+"^"+session['LOGON.CTLOCID'];
		ExportStr=ExportStr+"^"+"EXPORT";
		var ret=obj.ReportCls.ExportReport(ExportStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("����","���浼��ʧ��!"+ret);
			return;
		}else{
			var cArguments=obj.ReportID;
			var flg=ExportDataToExcel("","","����Ѫ�ܱ��濨("+Common_GetValue("txtPatName")+")",cArguments);
		}
	};
	obj.btnPrint_click = function(){
		if(obj.ReportID==""){
			ExtTool.alert("����","���������ϱ�������");
			return;
		}
		var PrintStr=obj.ReportID;
		PrintStr=PrintStr+"^"+session['LOGON.USERID'];
		PrintStr=PrintStr+"^"+session['LOGON.CTLOCID'];
		PrintStr=PrintStr+"^"+"PRINT";
		var ret=obj.ReportCls.ExportReport(PrintStr,"^");
		if(parseInt(ret)<=0){
			ExtTool.alert("����","�����ӡʧ��!"+ret);
			return;
		}else{
			var cArguments=obj.ReportID;
			var flg=PrintDataToExcel("","","����Ѫ�ܱ��濨("+Common_GetValue("txtPatName")+")",cArguments);
		}
	};
	obj.btnCancle_click = function(){
		window.close();
	};
	
	//���淶
	obj.CheckReport = function(){
		var errStr = "";
		
		errStr += obj.ValidateControl(obj.txtRegNo);		//�ǼǺ�
		errStr += obj.ValidateControl(obj.txtPatName);		//��������
		errStr += obj.ValidateControl(obj.txtIdentify);		//֤������
		errStr += obj.ValidateControl(obj.txtSex);			//�Ա�
		errStr += obj.ValidateControl(obj.txtAge);			//����
		errStr += obj.ValidateControl(obj.dtBirthday);		//��������
		errStr += obj.ValidateControl(obj.cboOccupation);	//ְҵ
		errStr += obj.ValidateControl(obj.cboCRGZ);			//���幤��
		errStr += obj.ValidateControl(obj.cboEducation);	//�Ļ��̶�
		errStr += obj.ValidateControl(obj.cboMarital);		//����״��
		errStr += obj.ValidateControl(obj.txtTelphone);		//�绰
		errStr += obj.ValidateControl(obj.cboNation);		//
		//errStr += obj.ValidateControl(obj.txtCompany);		//������λ
		errStr += obj.ValidateControl(obj.cboCurrProvince);	//��ס��-ʡ
		errStr += obj.ValidateControl(obj.cboCurrCity);		//��
		errStr += obj.ValidateControl(obj.cboCurrCounty);	//��
		errStr += obj.ValidateControl(obj.cboCurrVillage);	//�ֵ�
		errStr += obj.ValidateControl(obj.txtCurrRoad);		//��
		errStr += obj.ValidateControl(obj.txtCurrAddress);	//��ϸ��ַ
		errStr += obj.ValidateControl(obj.cboRegProvince);	//���ڵ�-ʡ
		errStr += obj.ValidateControl(obj.cboRegCity);		//��
		errStr += obj.ValidateControl(obj.cboRegCounty);	//��
		errStr += obj.ValidateControl(obj.cboRegVillage);	//�ֵ�
		errStr += obj.ValidateControl(obj.txtRegRoad);		//��
		errStr += obj.ValidateControl(obj.txtRegAddress);	//��ϸ��ַ
		errStr += obj.ValidateControl(obj.txtZDBM);			//ICD����
		errStr += obj.ValidateControl(obj.dtFBRQ);			//��������
		errStr += obj.ValidateControl(obj.dtQZRQ);			//ȷ������
		errStr += obj.ValidateControl(obj.txtDoctor);		//�ҽ��
		errStr += obj.ValidateControl(obj.cboLCZZ);
		errStr += obj.ValidateControl(obj.cboXGZY);
		errStr += obj.ValidateControl(obj.cboXDT);
		errStr += obj.ValidateControl(obj.cboCT);
		errStr += obj.ValidateControl(obj.cboXQM);
		errStr += obj.ValidateControl(obj.cboCGZ);
		errStr += obj.ValidateControl(obj.cboNJY);
		errStr += obj.ValidateControl(obj.cboSJ);
		errStr += obj.ValidateControl(obj.cboNDT);
		errStr += obj.ValidateControl(obj.cboYSJC);
		errStr += obj.ValidateControl(obj.cboSHTD);
		errStr += obj.ValidateControl(obj.chkBS);
		errStr += obj.ValidateControl(obj.cboCRZD);
		errStr += obj.ValidateControl(obj.cboQZDW);
		if ((obj.cboNCZZD.getValue()!="")&&(obj.cbgSYZZ.getValue()=="")){
			errStr += "��Ҫ֢״����"
		}
		if ((obj.cboNCZZD.getValue()=="")&&(obj.cboGXBZD.getValue()=="")){
			errStr += "���û��ѡ��"
		}
		//����
		if (obj.dtDeathDate.getRawValue()!=""){
			//fix bug 194476 ����ԭ��������ϡ���������ԭ�� ��ʾ��ȷ��Ϣ
			//if((obj.cboDeathReason.getValue()=="")||(obj.txtSWJTReason.getValue()=="")||(obj.cboCRSWZD.getValue()==""))
			//	errStr += "����ԭ��������ϡ���������ԭ�����!"
			errStr += obj.ValidateControl(obj.cboDeathReason);
			errStr += obj.ValidateControl(obj.txtSWJTReason);	
			errStr += obj.ValidateControl(obj.cboCRSWZD);

			if (Common_ComputeDays("dtFBRQ","dtDeathDate")<0){
				errStr += "�������ڱ�����ڷ������ڣ�"
			}
			//add by mxp 20160405 fix bug 191734 �������ڲ��ܴ��ڵ�ǰ����
			//var NowDate = new Date().format("Y-m-d");
			if (Common_ComputeDays("dtDeathDate")<0) {
				errStr += '�������ڲ��������ڵ�ǰ����!';
			}
		}
		if (Common_ComputeDays("dtBirthday","dtFBRQ")<0){
				errStr += "�������ڱ�����ڳ������ڣ�"
			}
			if (Common_ComputeDays("dtFBRQ","dtQZRQ")<0){
				errStr += "ȷ�����ڱ��벻С�ڷ������ڣ�"
			}
		if(errStr != "")
		{
			ExtTool.alert("��ʾ", errStr, Ext.MessageBox.INFO);
			return false;
		}
		return true;
	}
	obj.ValidateControl = function(objCtl){
		var errStr = "";
		if((objCtl.getValue() == "") || (!objCtl.isValid(false)))
			errStr = "<P>��" + objCtl.initialConfig.fieldLabel + "������Ϊ�գ�</P>";
		return errStr;
	}
}