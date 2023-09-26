
/// descript: �������뵥��ӡ����js  pisprintcom.js
/// author��  bianshuai
/// date��    2018-03-07

/// ��ӡ�������뵥
function PrintPis_OE(Oeori){

	if (Oeori == ""){
		$.messager.alert("��ʾ:","ҽ��IDΪ��,���ʵ��,�ٴ�ӡ��");
		return;
	}
	runClassMethod("web.DHCAPPPrintCom","GetPisPrintByOeori",{"Oeori":Oeori},function(jsonString){

		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObj = jsonString;
			/// PrintPis_Xml(jsonObj);
			PrintPis_Xml_New(jsonObj);
		}
	},'json',false)
}

/// ��ӡ�������뵥
function PrintPis_REQ(PisID){
	
	if (PisID == ""){
		$.messager.alert("��ʾ:","��ǰ�޿ɴ�ӡ�Ĳ������뵥��");
		return;
	}
	var PisPrintInfo=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPisPrintInfo",
	    PisID:PisID,
	    dataType:"text"
    },false);
    var PisPrintAdm=PisPrintInfo.split("^")[0];
    var PisPrintMapCode=PisPrintInfo.split("^")[1];
    var PisPrintTemp=PisPrintInfo.split("^")[2];
    var PisPrintCall=PisPrintInfo.split("^")[3];
	var MyPara=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPisPrintCon",
	    dataType:"text",
	    PisID:PisID
    },false);
    var MyList=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "GetPrintList",
	    dataType:"text",
	    PisID:PisID
    },false);
    DHCP_GetXMLConfig("InvPrintEncrypt",PisPrintTemp);
    DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
    
    if (PisPrintCall!=""){
	    DHCP_GetXMLConfig("InvPrintEncrypt",PisPrintCall);
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	}
	var RecordPrintTime=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "RecordPrintTime",
	    dataType:"text",
	    PisID:PisID
    },false);
	/*runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("��ʾ:","��ӡ�쳣��");
		}else{
			var jsonObj = jsonString;
			/// PrintPis_Xml(jsonObj);
			PrintPis_Xml_New(jsonObj);
		}
	},'json',false)	*/
}

/// ��ӡ�����л�
function PrintPis_Xml(jsonObj){
	
	/// ����TCT���뵥
	if (jsonObj.PisType == "TCT"){
		Print_TCT(jsonObj);
	}
	
	/// HPV���뵥
	if (jsonObj.PisType == "HPV"){
		Print_HPV(jsonObj);
	}
	
	/// ϸ������
	if (jsonObj.PisType == "CYT"){
		Print_CYT(jsonObj);
	}
	
	/// ʬ������
	if (jsonObj.PisType == "APY"){
		Print_APY(jsonObj);
	}

	/// ��������
	if (jsonObj.PisType == "LIV"){	
		Print_LIV(jsonObj);
	}
	
	/// ��Ժ����
	if (jsonObj.PisType == "CON"){		
		Print_CON(jsonObj);
	}
	
	/// ���Ӳ�������
	if (jsonObj.PisType == "MOL"){		
		Print_MOL(jsonObj);
	}
}

/// ����TCT���뵥��ӡ
function Print_TCT(jsonObj){
	
	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������

	/// ���뵥��ϸ����
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// �Ӽ�
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// ����
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// �����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// ���뵥��
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// ����걾
	/// ����ַ���
	var PatMedRecord = jsonObj.PisPatRec +","+ jsonObj.MedRecord;
	var TmpLabelArr = SplitString(PatMedRecord, 88);
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(TmpLabelArr[0]);      /// �ٴ�����
	MyPara = MyPara+"^MedRecord1"+String.fromCharCode(2)+txtUtil(TmpLabelArr[1]);     /// �ٴ�����
	MyPara = MyPara+"^MedRecord2"+String.fromCharCode(2)+txtUtil(TmpLabelArr[2]);     /// �ٴ�����

	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// �ٴ����
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// ȡ����������
	MyPara = MyPara+"^FixDate"+String.fromCharCode(2)+txtUtil(jsonObj.FixDate);            /// ��ʼ�̶�����
	MyPara = MyPara+"^BLocDesc"+String.fromCharCode(2)+txtUtil(jsonObj.BLocDesc);          /// ȡ�Ŀ���
	MyPara = MyPara+"^DocName"+String.fromCharCode(2)+txtUtil(jsonObj.DocName);            /// ȡ��ҽ��
	MyPara = MyPara+"^LastMensDate"+String.fromCharCode(2)+txtUtil(jsonObj.LastMensDate);  /// �ϴ��¾�����
	MyPara = MyPara+"^MensDate"+String.fromCharCode(2)+txtUtil(jsonObj.MensDate);          /// ĩ���¾�����
	MyPara = MyPara+"^PauFlag"+String.fromCharCode(2)+txtUtil(jsonObj.PauFlag);            /// �Ƿ����
	MyPara = MyPara+"^PreTimes"+String.fromCharCode(2)+txtUtil(jsonObj.PreTimes);          /// ���д���
	MyPara = MyPara+"^LyTimes"+String.fromCharCode(2)+txtUtil(jsonObj.LyTimes);            /// ��������
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisTCT");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// HPV���뵥��ӡ
function Print_HPV(jsonObj){

	var MyPara = "";
	
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������
	
	/// ���뵥��ϸ����
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       	/// �Ӽ�
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);     /// ����
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);  			/// �����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);  		/// ���뵥��
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);  		/// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);   /// ����걾
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);     /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag);   /// �ٴ����
	MyPara = MyPara+"^FoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.FoundDate);  	/// �״η�������ͷ������ʱ��
	MyPara = MyPara+"^PisTesItmMet"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesItmMet);  /// ��ⷽ��
	MyPara = MyPara+"^PisTreMet"+String.fromCharCode(2)+txtUtil(jsonObj.PisTreMet);     /// ���Ʒ���
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisHPV");
	
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// ϸ�����뵥��ӡ
function Print_CYT(jsonObj){
	
	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori; 	     /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������
	
	/// ���뵥��ϸ����
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);        /// �Ӽ�
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);    /// ����
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);            /// �����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);      /// ���뵥��
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);      /// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);  /// ����걾
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);    /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag);  /// �ٴ����
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisCytExn");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");		
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// ʬ�����뵥��ӡ
function Print_APY(jsonObj){
	
	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;            /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;	        /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		    /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;            /// ����
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;        /// �ѱ�
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       	/// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;    	/// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	    /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;  	/// ��������
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+txtUtil(jsonObj.PatTelH); /// �����Ŀ
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+txtUtil(jsonObj.PatAddr); /// �����Ŀ
	
	/// ���뵥��ϸ����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);       	    /// ���뵥��
	MyPara = MyPara+"^SpecName"+String.fromCharCode(2)+txtUtil(jsonObj.SpecName);       		/// �걾��Ϣ
	MyPara = MyPara+"^lbapplycheckpro"+String.fromCharCode(2)+txtUtil(jsonObj.CellOrder);  		/// �����Ŀ
	MyPara = MyPara+"^MorToDeaPro"+String.fromCharCode(2)+txtUtil(jsonObj.MorToDeaPro);  		/// �Է�������������ʱ��
	MyPara = MyPara+"^DisAndTrePro"+String.fromCharCode(2)+txtUtil(jsonObj.DisAndTrePro);     	/// ��ʷ�����ƾ���
	MyPara = MyPara+"^PhyAndLabTest"+String.fromCharCode(2)+txtUtil(jsonObj.PhyAndLabTest); 	/// �ٴ�����鼰������
	MyPara = MyPara+"^PatDiagDesc"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag);  		/// ����ٴ����
	
	MyPara = MyPara+"^TakBack"+String.fromCharCode(2)+(txtUtil(jsonObj.FinTakRes) == "TakBack"?"��":"");  		/// ��ʬ�����
	MyPara = MyPara+"^TakHosp"+String.fromCharCode(2)+(txtUtil(jsonObj.FinTakRes) == "TakHosp"?"��":"");  		/// ��Ժ������ 
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisAutoPsy");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// �������뵥��ӡ
function Print_LIV(jsonObj){

	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������
	
	/// ���뵥��ϸ����
	if (txtUtil(jsonObj.EmgFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"��";       /// �Ӽ�
	}
	if (txtUtil(jsonObj.FrostFlag) == "Y"){
		MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+"��";   /// ����
	}
	
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// �����
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// ����걾
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// �ٴ����
	MyPara = MyPara+"^OperRes"+String.fromCharCode(2)+txtUtil(jsonObj.OperRes);       /// ��������
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// ���뵥��
	MyPara = MyPara+"^TFoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.TFoundDate); /// ������������
	MyPara = MyPara+"^TumPart"+String.fromCharCode(2)+txtUtil(jsonObj.TumPart);		  /// ������λ
	MyPara = MyPara+"^TumSize"+String.fromCharCode(2)+txtUtil(jsonObj.TumSize);       /// ������С
	MyPara = MyPara+"^TransFlag"+String.fromCharCode(2)+txtUtil(jsonObj.TransFlag);   /// �Ƿ�ת��
	MyPara = MyPara+"^TransPos"+String.fromCharCode(2)+txtUtil(jsonObj.TransPos);     /// ת�Ʋ�λ
	MyPara = MyPara+"^RadCureFlag"+String.fromCharCode(2)+txtUtil(jsonObj.RadCureFlag); /// �Ƿ����
	MyPara = MyPara+"^CheCureFlag"+String.fromCharCode(2)+txtUtil(jsonObj.CheCureFlag); /// �Ƿ���
	MyPara = MyPara+"^Remark"+String.fromCharCode(2)+txtUtil(jsonObj.Remark);           /// ������Ϣ
	
	MyPara = MyPara+"^LastMensDate"+String.fromCharCode(2)+txtUtil(jsonObj.LastMensDate);  /// �ϴ��¾�����
	MyPara = MyPara+"^MensDate"+String.fromCharCode(2)+txtUtil(jsonObj.MensDate);          /// ĩ���¾�����
	MyPara = MyPara+"^PauFlag"+String.fromCharCode(2)+txtUtil(jsonObj.PauFlag);            /// �Ƿ����
	MyPara = MyPara+"^PreTimes"+String.fromCharCode(2)+txtUtil(jsonObj.PreTimes);          /// ���д���
	MyPara = MyPara+"^LyTimes"+String.fromCharCode(2)+txtUtil(jsonObj.LyTimes);            /// ��������
	
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// ȡ����������
	MyPara = MyPara+"^FixDate"+String.fromCharCode(2)+txtUtil(jsonObj.FixDate);            /// ��ʼ�̶�����
	MyPara = MyPara+"^BLocDesc"+String.fromCharCode(2)+txtUtil(jsonObj.BLocDesc);          /// ȡ�Ŀ���
	MyPara = MyPara+"^DocName"+String.fromCharCode(2)+txtUtil(jsonObj.DocName);            /// ȡ��ҽ��
	MyPara = MyPara+"^PisPatInfDis"+String.fromCharCode(2)+txtUtil(jsonObj.PisPatInfDis);  /// ��Ⱦ��ʷ
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	if (txtUtil(jsonObj.PatSex) == "Ů"){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisLivCell");
	}else{
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisLivCell_M");
	}
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");

}

/// ��Ժ���뵥��ӡ
function Print_CON(jsonObj){
	
	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������
	
	/// ���뵥��ϸ����
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// �Ӽ�
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// ����
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// �����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// ���뵥��
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// ����걾
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// �ٴ����

	MyPara = MyPara+"^OperRes"+String.fromCharCode(2)+txtUtil(jsonObj.OperRes);        /// ��������
	MyPara = MyPara+"^FoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.FoundDate);    /// �״η�������ͷ������ʱ��
	MyPara = MyPara+"^InsDoc"+String.fromCharCode(2)+txtUtil(jsonObj.InsDoc);          /// �ͼ�ҽ��
	MyPara = MyPara+"^InsHosp"+String.fromCharCode(2)+txtUtil(jsonObj.InsHosp);        /// �ͼ�ҽԺ
	MyPara = MyPara+"^SpecExaRes"+String.fromCharCode(2)+txtUtil(jsonObj.SpecExaRes);  /// ����걾�������
	MyPara = MyPara+"^ConsNote"+String.fromCharCode(2)+txtUtil(jsonObj.ConsNote);      /// ����Ҫ��
	MyPara = MyPara+"^ConsStaff"+String.fromCharCode(2)+txtUtil(jsonObj.ConsStaff);    /// ����ר��
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisOutCou");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");

}

/// �������뵥��ӡ
function Print_MOL(jsonObj){
	var MyPara = "";
	/// ���뵥��������
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// �ǼǺ�
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// �ǼǺ�-����
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// �ǼǺ�-����
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// ����
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// �Ա�
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// ������
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// ��������
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// �ѱ�
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// ����
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// ��ͥסַ
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// �绰
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// ����
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// ����
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// ������
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// �������
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// ��������
	
	/// ���뵥��ϸ����
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// �Ӽ�
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// ����
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// �����
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// ���뵥��
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// �����Ŀ
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// ����걾
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// �ٴ�����
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// �ٴ����
	MyPara = MyPara+"^Position"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);   /// ȡ�Ĳ�λ
	MyPara = MyPara+"^PisCutBasType"+String.fromCharCode(2)+txtUtil(jsonObj.PisCutBasType); ///���Ӳ���ȡ������ qunianpeng 2018/2/7
	MyPara = MyPara+"^PisTesItmMol"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesItmMol);  ///���Ӳ�������Ŀ qunianpeng 2018/2/7
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// ��ɫͨ�� sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisMol");
	//���þ����ӡ����
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

///����
function PrintPis_Xml_New(jsonObj){		   		 
		   		      
	DHCP_GetXMLConfig("InvPrintEncrypt",jsonObj.PrintTemp);
	
	var MyPara = "" + String.fromCharCode(2);
	for (Element in jsonObj){
		MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + jsonObj[Element];
	}
	
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj,MyPara,"");
		   			
}

/// ����Ϊ undefined ��ʾ��
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}


/// ����ַ���
function SplitString(TmpString, LimitLen){
	
	var TmpLabelArr = ["","","","","","","","","",""];   /// ��ʼ��������
	var Len = 0; j = 0; k = 0;
	/// bianshuai  ��ȡҩ��
	for (var i=0; i<TmpString.length; i++) {
		var vChar = TmpString.charCodeAt(i);   
		//���ֽڼ�1    
		if ((vChar >= 0x0001 && vChar <= 0x007e)||(0xff60 <= vChar && vChar <= 0xff9f)){   
			Len++;   
		}else{   
			Len+=2;   
		}
		
		if(((Len%LimitLen == 0)||(Len%LimitLen == 1))&(Len != 1)){
			
			if ((i - k) < 2) continue;
			TmpLabelArr[j] = TmpString.substr(k, i-k);  /// ��ȡ�ַ���
			if (j == 4){
				TmpLabelArr[j] = TmpLabelArr[j] + "...";   /// ���һ���ַ��������...
				break;
			}
			j = j + 1;
			k = i;
		}
		if ((i == TmpString.length - 1)&(k != i)){
			TmpLabelArr[j] = TmpString.substr(k, (i-k)+1);
		}
	}
	return TmpLabelArr;
}

/**ȥ���ַ���ǰ�����пո�*/
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
} 