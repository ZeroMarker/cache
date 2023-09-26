
/// descript: 会诊申请单打印公共js  consultprintcom.js
/// author：  bianshuai
/// date：    2018-04-12

var PrintFlag = "N";

/// 打印会诊申请单
function PrintCst_OE(Oeori){

	if (Oeori == ""){
		$.messager.alert("提示:","医嘱ID为空,请核实后,再打印！");
		return;
	}
	/*
	runClassMethod("web.DHCEMConsultQuery","GetPisPrintByOeori",{"Oeori":Oeori},function(jsonString){

		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			PrintCst_Xml(jsonObj);
		}
	},'json',false)
	*/
}

/// 打印会诊申请单
function PrintCst_REQ(mCstID){
	
	if (mCstID == ""){
		$.messager.alert("提示:","当前无可打印的会诊申请单！");
		return;
	}
	
	runClassMethod("web.DHCEMConsultQuery","GetPisPrintCon",{"mCstID":mCstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				PrintCst_Xml(jsonObjArr[i]);
			}
		}
	},'json',false)	
}

/// 打印类型切换
function PrintCst_Xml(jsonObj){
	
	/// 普通会诊申请单
	if (jsonObj.CstOutFlag == "N"){
		Print_CstNT(jsonObj);
	}
	
	/// 外院会诊申请单
	if (jsonObj.CstOutFlag == "Y"){
		Print_CstOut(jsonObj);
	}
	/*
	/// MDT会诊申请单
	if (jsonObj.CstOutFlag == "Y"){
		Print_CstMDT(jsonObj);
	}
	*/
	/// 护士会诊申请单
	if (jsonObj.CstType == "NUR"){
		Print_CstNur(jsonObj);
	}

}

/// 打印会诊申请单
function PrintCst_AUD(mCstID){
	
	if (mCstID == ""){
		$.messager.alert("提示:","当前无可打印的会诊申请单！");
		return;
	}
	
	runClassMethod("web.DHCEMConsultQuery","GetPisPrintCon",{"mCstID":mCstID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				PrintCst_Xml_AUD(jsonObjArr[i]);
			}
		}
	},'json',false)	
}

/// 打印类型切换
function PrintCst_Xml_AUD(jsonObj){
	

	/// 院内多科督导单
	if (jsonObj.CstMoreFlag > 1){
		Print_CstMulSuper(jsonObj);
	}
	
	/// 普通会诊申请单
	if (jsonObj.CstOutFlag == "N"){
		Print_CstNT(jsonObj);
	}
	
	/// 外院会诊申请单
	if (jsonObj.CstOutFlag == "Y"){
		Print_CstOut(jsonObj);
	}
}

/// 普通会诊申请单
function Print_CstNT(jsonObj){
	
	var itemObjArr = jsonObj.CsItemArr;  	 /// 科室项目
	for (var i=0; i<itemObjArr.length; i++){
		Print_Cst(jsonObj, itemObjArr[i]);
	}
}

/// 普通会诊申请单
function Print_Cst(jsonObj, itemObj){

	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// 诊断
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// 科室
	MyPara = MyPara+"^CstUser"+String.fromCharCode(2)+jsonObj.CstUser;       /// 联系人
	
	/// 申请单明细内容
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"√";       /// 普通
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// 申请人
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// 申请日期
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// 申请时间
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// 会诊日期
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// 会诊时间

	MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+itemObj.CsLocDesc;     /// 会诊科室
	MyPara = MyPara+"^ConsCName"+String.fromCharCode(2)+itemObj.CsUser;       /// 会诊医生
	MyPara = MyPara+"^ConsCPrvTp"+String.fromCharCode(2)+itemObj.CsPrvTp;   /// 医生级别
	var CsOpinion = itemObj.CsOpinion;										  /// 会诊意见
	
	/// 病史
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊目的
	var TmpLabelArr = SplitString(jsonObj.CstTrePro +";"+ jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊意见
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
		MyPara = MyPara+"^PageNo"+String.fromCharCode(2)+"第1页(共2页)";     /// 页码
	}else{
		MyPara = MyPara+"^ConsCText"+String.fromCharCode(2)+"会诊医师:";     /// 会诊医生
		MyPara = MyPara+"^ConsCValue"+String.fromCharCode(2)+jsonObj.CsUser;     /// 会诊医生
		MyPara = MyPara+"^PageNo"+String.fromCharCode(2)+"第1页(共1页)";     /// 页码
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_Consult");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 院内会诊申请单
function Print_CstMul(jsonObj){

	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// 诊断
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// 科室
	MyPara = MyPara+"^CstUnit"+String.fromCharCode(2)+jsonObj.CstUnit;       /// 外院名称
	MyPara = MyPara+"^CstDocName"+String.fromCharCode(2)+jsonObj.CstDocName; /// 外院科室
	
	/// 申请单明细内容
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"√";       /// 普通
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// 申请人
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// 申请日期
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// 申请时间
	var TmpLocArr = jsonObj.CstLocList.split("、");
	for(var m=0; m<TmpLocArr.length; m++){
		if (TmpLocArr[m] != ""){
			MyPara = MyPara+"^ConsCLoc"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLocArr[m].replace(" ","   "));
		}
	}
    //MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+jsonObj.CstLocList;     /// 会诊科室
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// 会诊日期
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// 会诊时间
	
	/// 病史
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊目的
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊意见
	/*
	var TmpLabelArr = SplitString(jsonObj.CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
	*/
	MyPara = MyPara+"^ConsOpinion1"+String.fromCharCode(2)+"详见病历记录";
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultMul");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 外院会诊申请单
function Print_CstOut(jsonObj){

	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// 诊断
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// 科室
	MyPara = MyPara+"^CstUnit"+String.fromCharCode(2)+jsonObj.CstUnit;       /// 外院名称
	MyPara = MyPara+"^CstDocName"+String.fromCharCode(2)+jsonObj.CstDocName; /// 外院科室
	
	/// 申请单明细内容
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"√";       /// 普通
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// 申请人
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// 申请日期
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// 申请时间
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// 会诊日期
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// 会诊时间
	MyPara = MyPara+"^CstPhone"+String.fromCharCode(2)+jsonObj.CstPhone;      /// 联系方式
	
	/// 病史
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊目的
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}

	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultOut");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// MDT会诊申请单
function Print_CstMDT(jsonObj){
	
}

/// 护士会诊申请单
function Print_CstNur(jsonObj){

	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// 诊断
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// 科室
	
	/// 申请单明细内容
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"√";       /// 普通
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// 申请人
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// 申请日期
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// 申请时间
	MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+jsonObj.CsLocDesc;     /// 会诊科室
	MyPara = MyPara+"^ConsCName"+String.fromCharCode(2)+jsonObj.CsUser;       /// 会诊医生
	MyPara = MyPara+"^ConsCPrvTp"+String.fromCharCode(2)+jsonObj.CsPrvTp;   /// 医生级别
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// 会诊日期
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// 会诊时间
	
	/// 病史
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 病史及会诊目的
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊意见
	var TmpLabelArr = SplitString(jsonObj.CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultNur");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");	
}

/// 会诊申请单续页
function Print_CstXY(jsonObj){
	
	var MyPara = "";
	/// 申请单病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 /// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedNo"+String.fromCharCode(2)+jsonObj.MedicareNo;      /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^PatDiag"+String.fromCharCode(2)+jsonObj.PatDiag;       /// 诊断
	MyPara = MyPara+"^PatLoc"+String.fromCharCode(2)+jsonObj.PatLoc;         /// 科室
	
	/// 申请单明细内容
	if (txtUtil(jsonObj.CstEmFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}else{
		MyPara = MyPara+"^NorFlag"+String.fromCharCode(2)+"√";       /// 普通
	}
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.CstRUser;      /// 申请人
	MyPara = MyPara+"^CreateDate"+String.fromCharCode(2)+jsonObj.CstRDate;    /// 申请日期
	MyPara = MyPara+"^CreateTime"+String.fromCharCode(2)+jsonObj.CstRTime;    /// 申请时间
	MyPara = MyPara+"^ConsCLoc"+String.fromCharCode(2)+jsonObj.CsLocDesc;     /// 会诊科室
	MyPara = MyPara+"^ConsCName"+String.fromCharCode(2)+jsonObj.CsUser;       /// 会诊医生
	MyPara = MyPara+"^ConsCPrvTp"+String.fromCharCode(2)+jsonObj.CsPrvTp;   /// 医生级别
	MyPara = MyPara+"^ConsCDate"+String.fromCharCode(2)+jsonObj.CstNDate;     /// 会诊日期
	MyPara = MyPara+"^ConsCTime"+String.fromCharCode(2)+jsonObj.CstNTime;     /// 会诊时间
	MyPara = MyPara+"^PageNo"+String.fromCharCode(2)+"第2页(共2页)";     /// 页码
	
	/// 病史
	var TmpLabelArr = SplitString(jsonObj.CstTrePro, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CstTrePro"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊目的
	var TmpLabelArr = SplitString(jsonObj.CstPurpose, 84);
	for(var m=0; m<TmpLabelArr.length; m++){
		if (TmpLabelArr[m] != ""){
			MyPara = MyPara+"^CsPurpose"+ (m+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[m]);
		}
	}
	
	/// 会诊意见
	var TmpLabelArr = SplitString(jsonObj.CsOpinion, 84);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^ConsOpinion"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_ConsultXY");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 院内多科督导单
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

/// 内容为 undefined 显示空
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
		myPara=myPara+"^"+"ConsTreProPurpose"+parLimit+"病情摘要:"+itmData.CstTrePro+"\r\n"+"会诊目的及要求："+itmData.CstPurpose;
		myPara=myPara+"^"+"ConsAppLoc"+parLimit+itmData.CstRLoc;
		myPara=myPara+"^"+"ConsAppUser"+parLimit+itmData.CstRUser;
		myPara=myPara+"^"+"ConsDate"+parLimit+itmData.CstNDate+"  "+itmData.CstNTime;
		myPara=myPara+"^"+"Opinion"+parLimit+itmData.CsOpinion;
		myPara=myPara+"^"+"ConsLoc"+parLimit+itmData.CsLocDesc;
		myPara=myPara+"^"+"ConsUser"+parLimit+itmData.CsUser;
		myPara=myPara+"^"+"HospTile"+parLimit+itmData.LgHospName;
		
		DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
		LODOP.NEWPAGE();
	}
	var printRet = LODOP.PRINT();
	return printRet;
}
