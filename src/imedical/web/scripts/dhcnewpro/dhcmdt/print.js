/// 打印知情同意书  北京肿瘤
function PrintConsent(cstID){
	
	var printData="";
	/// 获取打印分诊数据
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
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	LODOP.PRINT()
	InsCsMasPrintFlag(cstID,"Z");
	return;
}

/// 打印诊间预约单  北京肿瘤
function PrintMakeDoc(cstID){
	
	var printData="";
	/// 获取打印分诊数据
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":cstID},function(jsonString){
		if(jsonString==-1){
			$.messager.alert("提示:","会诊未发送，不允许打印知情同意书！","info");	
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
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	LODOP.PRINT()
	InsCsMasPrintFlag(cstID,"M");
	return;
}

 /// 修改会诊打印标志
function InsCsMasPrintFlag(mdtID,printFlag){
	
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示:","更新会诊打印状态失败，失败原因:"+jsonString);
		}
	},'',false)
}

/// 打印会诊申请单
function PrintCst_REQ(mCstID,mdtDisGrp){

	if (mCstID == ""){
		$.messager.alert("提示:","当前无可打印的会诊申请单！");
		return;
	}
	
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":mCstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			
			PrintCst_Xml(jsonObj);
		}
	},'json',false)	
	
}

/// 会诊通知单
function PrintCst_Xml(jsonObj){

	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
    MyPara = MyPara+"^DisGroup"+String.fromCharCode(2)+jsonObj.DisGroup;	 /// 病种
    MyPara = MyPara+"^CsDataRange"+String.fromCharCode(2)+jsonObj.CsDataRange;	 /// 会诊日期
    MyPara = MyPara+"^CsTimeRange"+String.fromCharCode(2)+jsonObj.Time;	 	 /// 会诊时间
    MyPara = MyPara+"^CstNPlace"+String.fromCharCode(2)+jsonObj.CstNPlace;	 /// 会诊时间
    MyPara = MyPara+"^HosDesc"+String.fromCharCode(2)+jsonObj.HospDesc+"疑难病会诊告知单";		 /// 医院
    if(jsonObj.DisGroup=="肿瘤2")
    MyPara = MyPara+"^s1"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="食管胃")
    MyPara = MyPara+"^s2"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="垂体")
    MyPara = MyPara+"^s3"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="结直肠")
    MyPara = MyPara+"^s4"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="骨代谢")
    MyPara = MyPara+"^s5"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="胰腺")
    MyPara = MyPara+"^s6"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="脑")
    MyPara = MyPara+"^s7"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="泌尿肿瘤")
    MyPara = MyPara+"^s8"+String.fromCharCode(2)+"√";
    if(jsonObj.DisGroup=="呼吸")
    MyPara = MyPara+"^s9"+String.fromCharCode(2)+"√";
	DHCP_GetXMLConfig("InvPrintEncrypt","DHC_MDTConsult");
	//调用具体打印方法
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_XMLPrint(myobj, MyPara, "");
	//DHCP_PrintFun(myobj, MyPara, "");
	LODOP=getLodop()
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHC_MDTConsult");
	DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	LODOP.PRINT()
	return;

}
//打印MDT申请记录单
//yangyongtao
//2020-04-15
function PrintCons(CstID){
    
    var printData="";
    if (CstID == ""){
		$.messager.alert("提示:","当前无可打印的会诊申请单！");
		return;
	}
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":CstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}
		  printData=jsonString;
	},'json',false)
	
	if (printData=="") return;
	
	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatCardNo"+String.fromCharCode(2)+printData.PatNo;					 		/// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+printData.PatName;		 		/// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+printData.PatSex;		 			/// 性别
    MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+printData.PatAge;		 			/// 年龄
    MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+printData.PatTelH;		 		/// 联系电话
    MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+printData.MedicareNo;			/// 病案号
    MyPara = MyPara+"^CstNDate"+String.fromCharCode(2)+printData.CstNDate;		 		/// 会诊时间
    MyPara = MyPara+"^CstNPlace"+String.fromCharCode(2)+printData.CstNPlace;		 	/// 会诊地点
    MyPara = MyPara+"^CstTrePro"+String.fromCharCode(2)+printData.CstTrePro;		 	/// 病情摘要
    MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+printData.PatDiag;		 		/// 初步诊断
    MyPara = MyPara+"^CstPurpose"+String.fromCharCode(2)+printData.CstPurpose;			/// 会诊目的
    MyPara = MyPara+"^CstOpinion"+String.fromCharCode(2)+printData.CstOpinion;			/// 会诊意见
    MyPara = MyPara+"^HospDesc"+String.fromCharCode(2)+printData.HospDesc;			    /// 医院描述

	var mdtCsLocs = printData.mdtCsLocs;  /// 会诊科室列表
	if (mdtCsLocs != ""){
		var mdtCsLocArr = mdtCsLocs.split("#");
		for (var i=1; i <= mdtCsLocArr.length; i++){
			var itemArr = mdtCsLocArr[i-1].split("@");
			MyPara = MyPara+("^CsLoc_")+i+String.fromCharCode(2)+itemArr[0];	    /// 科室
			MyPara = MyPara+("^CsDoc_"+i)+String.fromCharCode(2)+itemArr[1]		 	/// 医生
		}
	}
	LODOP=getLodop()
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_MDTCONS");
	DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	LODOP.PRINT()
	InsCsMasPrintFlag(CstID,"Y");  /// 修改会诊打印标志
	return;
	
}
 
 /// 修改会诊打印标志
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示:","更新会诊打印状态失败，失败原因:"+jsonString);
		}
	},'',false)
}

