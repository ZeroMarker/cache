
/// descript: �������뵥��ӡ����js  consultprintcom.js
/// author��  bianshuai
/// date��    2018-04-12

var PrintFlag = "N";

/// ��ӡ�������뵥
function PrintCst_OE(Oeori){

	if (Oeori == ""){
		$.messager.alert("��ʾ:","ҽ��IDΪ��,���ʵ��,�ٴ�ӡ��");
		return;
	}
	/*
	runClassMethod("web.DHCEMConsultQuery","GetPisPrintByOeori",{"Oeori":Oeori},function(jsonString){

		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObj = jsonString;
			PrintCst_Xml(jsonObj);
		}
	},'json',false)
	*/
}

/// ��ӡ�������뵥
function PrintCst_REQ(mCstID){
	
	if (mCstID == ""){
		$.messager.alert("��ʾ:","��ǰ�޿ɴ�ӡ�Ļ������뵥��");
		return;
	}
	
	runClassMethod("web.DHCEMConsultQuery","GetPisPrintCon",{"mCstID":mCstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				PrintCst_Xml(jsonObjArr[i]);
			}
		}
	},'json',false)	
}

/// ��ӡ�����л�
function PrintCst_Xml(jsonObj){
	
	/// ��ͨ�������뵥
	if (jsonObj.CstOutFlag == "N"){
		Print_CstNT(jsonObj);
	}
	
	/// ��Ժ�������뵥
	if (jsonObj.CstOutFlag == "Y"){
		Print_CstOut(jsonObj);
	}
	/*
	/// MDT�������뵥
	if (jsonObj.CstOutFlag == "Y"){
		Print_CstMDT(jsonObj);
	}
	*/
	/// ��ʿ�������뵥
	if (jsonObj.CstType == "NUR"){
		Print_CstNur(jsonObj);
	}

}

/// ��ӡ�������뵥
function PrintCst_AUD(mCstID){
	
	if (mCstID == ""){
		$.messager.alert("��ʾ:","��ǰ�޿ɴ�ӡ�Ļ������뵥��");
		return;
	}
	
	runClassMethod("web.DHCEMConsultQuery","GetPisPrintCon",{"mCstID":mCstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				PrintCst_Xml_AUD(jsonObjArr[i]);
			}
		}
	},'json',false)	
}

/// ��ӡ�����л�
function PrintCst_Xml_AUD(jsonObj){
	

	/// Ժ�ڶ�ƶ�����
	if (jsonObj.CstMoreFlag > 1){
		Print_CstMulSuper(jsonObj);
	}
	
	/// ��ͨ�������뵥
	if (jsonObj.CstOutFlag == "N"){
		Print_CstNT(jsonObj);
	}
	
	/// ��Ժ�������뵥
	if (jsonObj.CstOutFlag == "Y"){
		Print_CstOut(jsonObj);
	}
}

/// ��ͨ�������뵥
function Print_CstNT(jsonObj){
	
	var itemObjArr = jsonObj.CsItemArr;  	 /// ������Ŀ
	for (var i=0; i<itemObjArr.length; i++){
		Print_Cst(jsonObj, itemObjArr[i]);
	}
}

/// ��ͨ�������뵥
function Print_Cst(jsonObj, itemObj){

	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// ���
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// ����
	MyPara = MyPara+"^CstUser"+String.fromCharCode(2)+jsonObj.CstUser;       /// ��ϵ��
	
	/// ���뵥��ϸ����
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"��";       /// �Ӽ�
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"��";       /// ��ͨ
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// ������
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// ��������
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// ����ʱ��
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// ��������
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// ����ʱ��

	MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+itemObj.CsLocDesc;     /// �������
	MyPara = MyPara+"^ConsCName"+String.fromCharCode(2)+itemObj.CsUser;       /// ����ҽ��
	MyPara = MyPara+"^ConsCPrvTp"+String.fromCharCode(2)+itemObj.CsPrvTp;   /// ҽ������
	var CsOpinion = itemObj.CsOpinion;										  /// �������
	
	/// ��ʷ
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// ����Ŀ��
	var TmpLabelArr = SplitString(jsonObj.CstTrePro +";"+ jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// �������
	var TmpLabelArr = SplitString(CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			if (n > 21) {
				PrintFlag = "Y";
				break;
			}
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}

	if (PrintFlag == "Y"){
		MyPara = MyPara+"^PageNo"+String.fromCharCode(2)+"��1ҳ(��2ҳ)";     /// ҳ��
	}else{
		MyPara = MyPara+"^ConsCText"+String.fromCharCode(2)+"����ҽʦ:";     /// ����ҽ��
		MyPara = MyPara+"^ConsCValue"+String.fromCharCode(2)+jsonObj.CsUser;     /// ����ҽ��
		MyPara = MyPara+"^PageNo"+String.fromCharCode(2)+"��1ҳ(��1ҳ)";     /// ҳ��
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_Consult");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// Ժ�ڻ������뵥
function Print_CstMul(jsonObj){

	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// ���
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// ����
	MyPara = MyPara+"^CstUnit"+String.fromCharCode(2)+jsonObj.CstUnit;       /// ��Ժ����
	MyPara = MyPara+"^CstDocName"+String.fromCharCode(2)+jsonObj.CstDocName; /// ��Ժ����
	
	/// ���뵥��ϸ����
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"��";       /// �Ӽ�
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"��";       /// ��ͨ
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// ������
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// ��������
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// ����ʱ��
	var TmpLocArr = jsonObj.CstLocList.split("��");
	for(var m=0; m<TmpLocArr.length; m++){
		if (TmpLocArr[m] != ""){
			MyPara = MyPara+"^ConsCLoc"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLocArr[m].replace(" ","   "));
		}
	}
    //MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+jsonObj.CstLocList;     /// �������
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// ��������
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// ����ʱ��
	
	/// ��ʷ
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// ����Ŀ��
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// �������
	/*
	var TmpLabelArr = SplitString(jsonObj.CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
	*/
	MyPara = MyPara+"^ConsOpinion1"+String.fromCharCode(2)+"���������¼";
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultMul");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// ��Ժ�������뵥
function Print_CstOut(jsonObj){

	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// ���
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// ����
	MyPara = MyPara+"^CstUnit"+String.fromCharCode(2)+jsonObj.CstUnit;       /// ��Ժ����
	MyPara = MyPara+"^CstDocName"+String.fromCharCode(2)+jsonObj.CstDocName; /// ��Ժ����
	
	/// ���뵥��ϸ����
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"��";       /// �Ӽ�
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"��";       /// ��ͨ
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// ������
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// ��������
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// ����ʱ��
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// ��������
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// ����ʱ��
	MyPara = MyPara+"^CstPhone"+String.fromCharCode(2)+jsonObj.CstPhone;      /// ��ϵ��ʽ
	
	/// ��ʷ
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// ����Ŀ��
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}

	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultOut");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// MDT�������뵥
function Print_CstMDT(jsonObj){
	
}

/// ��ʿ�������뵥
function Print_CstNur(jsonObj){

	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// ���
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// ����
	
	/// ���뵥��ϸ����
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"��";       /// �Ӽ�
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"��";       /// ��ͨ
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// ������
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// ��������
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// ����ʱ��
	MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+jsonObj.CsLocDesc;     /// �������
	MyPara = MyPara+"^ConsCName"+String.fromCharCode(2)+jsonObj.CsUser;       /// ����ҽ��
	MyPara = MyPara+"^ConsCPrvTp"+String.fromCharCode(2)+jsonObj.CsPrvTp;   /// ҽ������
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// ��������
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// ����ʱ��
	
	/// ��ʷ
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// ��ʷ������Ŀ��
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// �������
	var TmpLabelArr = SplitString(jsonObj.CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultNur");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");	
}

/// �������뵥��ҳ
function Print_CstXY(jsonObj){
	
	var MyPara = "";
	/// ���뵥������Ϣ
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// �ǼǺ�
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// ���
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// ����
	
	/// ���뵥��ϸ����
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"��";       /// �Ӽ�
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"��";       /// ��ͨ
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// ������
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// ��������
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// ����ʱ��
	MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+jsonObj.CsLocDesc;     /// �������
	MyPara = MyPara+"^ConsCName"+String.fromCharCode(2)+jsonObj.CsUser;       /// ����ҽ��
	MyPara = MyPara+"^ConsCPrvTp"+String.fromCharCode(2)+jsonObj.CsPrvTp;   /// ҽ������
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// ��������
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// ����ʱ��
	MyPara = MyPara+"^PageNo"+String.fromCharCode(2)+"��2ҳ(��2ҳ)";     /// ҳ��
	
	/// ��ʷ
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// ����Ŀ��
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// �������
	var TmpLabelArr = SplitString(jsonObj.CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultXY");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// Ժ�ڶ�ƶ�����
function Print_CstMulSuper(jsonObj){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCEM_ConsMulSuper.xlsx";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	var CsItemArr = jsonObj.CsItemArr;
	
	for (var i=0; i<CsItemArr.length; i++){
		var itmObject = CsItemArr[i];
		if (i == 0){
			objSheet.Cells(3+i, 1).value = jsonObj.CstRLoc;
			objSheet.Cells(3+i, 2).value = jsonObj.PatAddr;
			objSheet.Cells(3+i, 3).value = jsonObj.PatBed;
			objSheet.Cells(3+i, 4).value = jsonObj.PatName;
			objSheet.Cells(3+i, 5).value = jsonObj.PatNo;
			objSheet.Cells(3+i, 6).value = jsonObj.CstRUser;
			objSheet.Cells(3+i, 10).value = jsonObj.CstNDate;
		}
		objSheet.Cells(3+i, 7).value = itmObject.CsLocDesc;
		objSheet.Cells(3+i, 8).value = itmObject.CsUser;
		objSheet.Cells(3+i, 9).value = itmObject.ProvPhone;
		objSheet.Cells(3+i, 11).value = "";
		objSheet.Cells(3+i, 12).value = "";
		objSheet.Cells(3+i, 13).value = "";
		objSheet.Cells(3+i, 14).value = "";
		objSheet.Cells(3+i, 15).value = "";
	}
	
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

/// ����Ϊ undefined ��ʾ��
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}



function PrintCstNew(CstItmIDs,LgHospID){
	var LODOP = getLodop();
	var parLimit=String.fromCharCode(2);
	var tmpName="DHCEM_ConsPrint";
	var printData="";
	runClassMethod("web.DHCEMConsultQuery","GetCstPrintCons",{"CstItmIDs":CstItmIDs,"LgHospID":LgHospID},function(jsonString){
		printData=jsonString;
	},'json',false)
	
	if(printData.length==0) return ;
	
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt",tmpName);
	for (i in printData){
		var myPara="";
		var itmData=printData[i];
		myPara="MedicalNo"+parLimit+itmData.MedicareNo;
		myPara=myPara+"^"+"PatNo"+parLimit+itmData.PatNo;
		myPara=myPara+"^"+"ConsType"+parLimit+itmData.CstTypeDesc;
		myPara=myPara+"^"+"PatName"+parLimit+itmData.PatName+"("+itmData.PatSex+")";
		myPara=myPara+"^"+"PacWardDesc"+parLimit+itmData.PatLoc;
		myPara=myPara+"^"+"PatBedDesc"+parLimit+itmData.PatBed;
		myPara=myPara+"^"+"AppConsDate"+parLimit+itmData.CstRDate+"  "+itmData.CstRTime;
		myPara=myPara+"^"+"ConsTreProPurpose"+parLimit+"����ժҪ:"+itmData.CstTrePro+"\r\n"+"����Ŀ�ļ�Ҫ��"+itmData.CstPurpose;
		myPara=myPara+"^"+"ConsAppLoc"+parLimit+itmData.CstRLoc;
		myPara=myPara+"^"+"ConsAppUser"+parLimit+itmData.CstRUser;
		myPara=myPara+"^"+"ConsDate"+parLimit+itmData.CstNDate+"  "+itmData.CstNTime;
		myPara=myPara+"^"+"Opinion"+parLimit+itmData.CsOpinion;
		myPara=myPara+"^"+"ConsLoc"+parLimit+itmData.CsLocDesc;
		myPara=myPara+"^"+"ConsUser"+parLimit+itmData.CsUser;
		myPara=myPara+"^"+"HospTile"+parLimit+itmData.LgHospName;
		
		DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara Ϊxml��ӡҪ��ĸ�ʽ
		LODOP.NEWPAGE();
	}
	var printRet = LODOP.PRINT();
	return printRet;
}
