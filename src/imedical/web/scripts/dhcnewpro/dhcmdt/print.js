/// ��ӡ֪��ͬ����  ��������
function PrintConsent(cstID){
	
	var printData="";
	/// ��ȡ��ӡ��������
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":cstID},function(jsonString){
		printData=jsonString;
	},'json',false)
	
	if (printData=="") return;
	var myPara="";
	myPara="PatName"+String.fromCharCode(2)+printData.PatName
	myPara = myPara+"^"+"PatSex"+String.fromCharCode(2)+printData.PatSex;
	myPara = myPara+"^"+"PatAge"+String.fromCharCode(2)+printData.PatAge;
	myPara = myPara+"^"+"PatWard"+String.fromCharCode(2)+printData.PatWard;
	myPara = myPara+"^"+"PatSeatNo"+String.fromCharCode(2)+printData.PatBed;
	myPara = myPara+"^"+"CstNDate"+String.fromCharCode(2)+printData.PreDate;
	myPara = myPara+"^"+"CstNPlace"+String.fromCharCode(2)+printData.CstNPlace;
	myPara = myPara+"^"+"PatDiagDesc"+String.fromCharCode(2)+printData.PatDiag;
	myPara = myPara+"^"+"DirectLoc"+String.fromCharCode(2)+printData.CstRLoc;
	myPara = myPara+"^"+"CstRLocID"+String.fromCharCode(2)+printData.CstRLoc;   
	myPara = myPara+"^"+"HospDesc"+String.fromCharCode(2)+printData.HospDesc; //hxy 2023-02-10
	LODOP=getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHC_MDTZQTYSMDT");
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara Ϊxml��ӡҪ��ĸ�ʽ
	LODOP.PRINT()
	InsCsMasPrintFlag(cstID,"Z");
	return;
}

/// ��ӡ���ԤԼ��  ��������
function PrintMakeDoc(cstID){
	
	var printData="";
	/// ��ȡ��ӡ��������
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":cstID},function(jsonString){
		if(jsonString==-1){
			$.messager.alert("��ʾ:","����δ���ͣ��������ӡ֪��ͬ���飡","info");	
			return;
		}
		printData=jsonString;
	},'json',false)
	
	if (printData=="") return;
	var myPara="";
	myPara = "PatNo"+String.fromCharCode(2)+printData.PatNo;
	myPara = myPara+"^"+"PatNoExt"+String.fromCharCode(2)+printData.PatNo;
	myPara = myPara+"^"+"CardNo"+String.fromCharCode(2)+printData.CardNo;
	myPara = myPara+"^"+"MredNO"+String.fromCharCode(2)+printData.MedicareNo;
	myPara = myPara+"^"+"PatName"+String.fromCharCode(2)+printData.PatName;
	myPara = myPara+"^"+"GroupDesc"+String.fromCharCode(2)+printData.DisGroup;
	myPara = myPara+"^"+"PreDate"+String.fromCharCode(2)+printData.PreDate;
	myPara = myPara+"^"+"Adddesc"+String.fromCharCode(2)+printData.CstNPlace;
	myPara = myPara+"^"+"APPDate"+String.fromCharCode(2)+printData.CstRDate+" "+printData.CstRTime;
	myPara = myPara+"^"+"AppDoc"+String.fromCharCode(2)+printData.CstRUser;  
	myPara = myPara+"^"+"ConsPrice"+String.fromCharCode(2)+printData.ConsPrice;  
	myPara = myPara+"^"+"OpenSeeDate"+String.fromCharCode(2)+printData.DisGroupNotes; 
	myPara = myPara+"^"+"HospName"+String.fromCharCode(2)+printData.HospDesc;	
	LODOP=getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHC_MDTQRDMDT");
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara Ϊxml��ӡҪ��ĸ�ʽ
	LODOP.PRINT()
	InsCsMasPrintFlag(cstID,"M");
	return;
}

 /// �޸Ļ����ӡ��־
function InsCsMasPrintFlag(mdtID,printFlag){
	
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ:","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}
	},'',false)
}

/// ��ӡ�������뵥
function PrintCst_REQ(mCstID,mdtDisGrp){

	if (mCstID == ""){
		$.messager.alert("��ʾ:","��ǰ�޿ɴ�ӡ�Ļ������뵥��");
		return;
	}
	
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":mCstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObj = jsonString;
			
			PrintCst_Xml(jsonObj);
		}
	},'json',false)	
	
}

/// ����֪ͨ��
function PrintCst_Xml(jsonObj){

	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
    MyPara = MyPara+"^DisGroup"+String.fromCharCode(2)+jsonObj.DisGroup;	 /// ����
    MyPara = MyPara+"^CsDataRange"+String.fromCharCode(2)+jsonObj.CsDataRange;	 /// ��������
    MyPara = MyPara+"^CsTimeRange"+String.fromCharCode(2)+jsonObj.Time;	 	 /// ����ʱ��
    MyPara = MyPara+"^CstNPlace"+String.fromCharCode(2)+jsonObj.CstNPlace;	 /// ����ʱ��
    MyPara = MyPara+"^HosDesc"+String.fromCharCode(2)+jsonObj.HospDesc+"���Ѳ������֪��";		 /// ҽԺ
    if(jsonObj.DisGroup=="����2")
    MyPara = MyPara+"^s1"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="ʳ��θ")
    MyPara = MyPara+"^s2"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="����")
    MyPara = MyPara+"^s3"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="��ֱ��")
    MyPara = MyPara+"^s4"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="�Ǵ�л")
    MyPara = MyPara+"^s5"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="����")
    MyPara = MyPara+"^s6"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="��")
    MyPara = MyPara+"^s7"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="��������")
    MyPara = MyPara+"^s8"+String.fromCharCode(2)+"��";
    if(jsonObj.DisGroup=="����")
    MyPara = MyPara+"^s9"+String.fromCharCode(2)+"��";
	DHCP_GetXMLConfig("InvPrintEncrypt","DHC_MDTConsult");
	//���þ����ӡ����
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_XMLPrint(myobj, MyPara, "");
	//DHCP_PrintFun(myobj, MyPara, "");
	LODOP=getLodop()
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHC_MDTConsult");
	DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara Ϊxml��ӡҪ��ĸ�ʽ
	LODOP.PRINT()
	return;

}
//��ӡMDT�����¼��
//yangyongtao
//2020-04-15
function PrintCons(CstID){
    
    var printData="";
    if (CstID == ""){
		$.messager.alert("��ʾ:","��ǰ�޿ɴ�ӡ�Ļ������뵥��");
		return;
	}
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":CstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}
		  printData=jsonString;
	},'json',false)
	
	if (printData=="") return;
	
	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatCardNo"+String.fromCharCode(2)+printData.PatNo;					 		/// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+printData.PatName;		 		/// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+printData.PatSex;		 			/// �Ա�
    MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+printData.PatAge;		 			/// ����
    MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+printData.PatTelH;		 		/// ��ϵ�绰
    MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+printData.MedicareNo;			/// ������
    MyPara = MyPara+"^CstNDate"+String.fromCharCode(2)+printData.CstNDate;		 		/// ����ʱ��
    MyPara = MyPara+"^CstNPlace"+String.fromCharCode(2)+printData.CstNPlace;		 	/// ����ص�
    MyPara = MyPara+"^CstTrePro"+String.fromCharCode(2)+printData.CstTrePro;		 	/// ����ժҪ
    MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+printData.PatDiag;		 		/// �������
    MyPara = MyPara+"^CstPurpose"+String.fromCharCode(2)+printData.CstPurpose;			/// ����Ŀ��
    MyPara = MyPara+"^CstOpinion"+String.fromCharCode(2)+printData.CstOpinion;			/// �������
    MyPara = MyPara+"^HospDesc"+String.fromCharCode(2)+printData.HospDesc;			    /// ҽԺ����

	var mdtCsLocs = printData.mdtCsLocs;  /// ��������б�
	if (mdtCsLocs != ""){
		var mdtCsLocArr = mdtCsLocs.split("#");
		for (var i=1; i <= mdtCsLocArr.length; i++){
			var itemArr = mdtCsLocArr[i-1].split("@");
			MyPara = MyPara+("^CsLoc_")+i+String.fromCharCode(2)+itemArr[0];	    /// ����
			MyPara = MyPara+("^CsDoc_"+i)+String.fromCharCode(2)+itemArr[1]		 	/// ҽ��
		}
	}
	LODOP=getLodop()
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_MDTCONS");
	DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara Ϊxml��ӡҪ��ĸ�ʽ
	LODOP.PRINT()
	InsCsMasPrintFlag(CstID,"Y");  /// �޸Ļ����ӡ��־
	return;
	
}
 
 /// �޸Ļ����ӡ��־
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ:","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}
	},'',false)
}

