
/// descript: 病理申请单打印公共js  pisprintcom.js
/// author：  bianshuai
/// date：    2018-03-07

/// 打印病理申请单
function PrintPis_OE(Oeori){

	if (Oeori == ""){
		$.messager.alert("提示:","医嘱ID为空,请核实后,再打印！");
		return;
	}
	runClassMethod("web.DHCAPPPrintCom","GetPisPrintByOeori",{"Oeori":Oeori},function(jsonString){

		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			/// PrintPis_Xml(jsonObj);
			PrintPis_Xml_New(jsonObj);
		}
	},'json',false)
}

/// 打印病理申请单
function PrintPis_REQ(PisID){
	
	if (PisID == ""){
		$.messager.alert("提示:","当前无可打印的病理申请单！");
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
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			/// PrintPis_Xml(jsonObj);
			PrintPis_Xml_New(jsonObj);
		}
	},'json',false)	*/
}

/// 打印类型切换
function PrintPis_Xml(jsonObj){
	
	/// 妇科TCT申请单
	if (jsonObj.PisType == "TCT"){
		Print_TCT(jsonObj);
	}
	
	/// HPV申请单
	if (jsonObj.PisType == "HPV"){
		Print_HPV(jsonObj);
	}
	
	/// 细胞申请
	if (jsonObj.PisType == "CYT"){
		Print_CYT(jsonObj);
	}
	
	/// 尸检申请
	if (jsonObj.PisType == "APY"){
		Print_APY(jsonObj);
	}

	/// 活体申请
	if (jsonObj.PisType == "LIV"){	
		Print_LIV(jsonObj);
	}
	
	/// 外院申请
	if (jsonObj.PisType == "CON"){		
		Print_CON(jsonObj);
	}
	
	/// 分子病理申请
	if (jsonObj.PisType == "MOL"){		
		Print_MOL(jsonObj);
	}
}

/// 妇科TCT申请单打印
function Print_TCT(jsonObj){
	
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期

	/// 申请单明细内容
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// 病理标本
	/// 拆分字符串
	var PatMedRecord = jsonObj.PisPatRec +","+ jsonObj.MedRecord;
	var TmpLabelArr = SplitString(PatMedRecord, 88);
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(TmpLabelArr[0]);      /// 临床病历
	MyPara = MyPara+"^MedRecord1"+String.fromCharCode(2)+txtUtil(TmpLabelArr[1]);     /// 临床病历
	MyPara = MyPara+"^MedRecord2"+String.fromCharCode(2)+txtUtil(TmpLabelArr[2]);     /// 临床病历

	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// 临床诊断
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// 取材离体日期
	MyPara = MyPara+"^FixDate"+String.fromCharCode(2)+txtUtil(jsonObj.FixDate);            /// 开始固定日期
	MyPara = MyPara+"^BLocDesc"+String.fromCharCode(2)+txtUtil(jsonObj.BLocDesc);          /// 取材科室
	MyPara = MyPara+"^DocName"+String.fromCharCode(2)+txtUtil(jsonObj.DocName);            /// 取材医生
	MyPara = MyPara+"^LastMensDate"+String.fromCharCode(2)+txtUtil(jsonObj.LastMensDate);  /// 上次月经日期
	MyPara = MyPara+"^MensDate"+String.fromCharCode(2)+txtUtil(jsonObj.MensDate);          /// 末次月经日期
	MyPara = MyPara+"^PauFlag"+String.fromCharCode(2)+txtUtil(jsonObj.PauFlag);            /// 是否绝经
	MyPara = MyPara+"^PreTimes"+String.fromCharCode(2)+txtUtil(jsonObj.PreTimes);          /// 怀孕次数
	MyPara = MyPara+"^LyTimes"+String.fromCharCode(2)+txtUtil(jsonObj.LyTimes);            /// 生产次数
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisTCT");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// HPV申请单打印
function Print_HPV(jsonObj){

	var MyPara = "";
	
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期
	
	/// 申请单明细内容
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       	/// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);     /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);  			/// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);  		/// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);  		/// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);   /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);     /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag);   /// 临床诊断
	MyPara = MyPara+"^FoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.FoundDate);  	/// 首次发现人乳头瘤病毒时间
	MyPara = MyPara+"^PisTesItmMet"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesItmMet);  /// 检测方法
	MyPara = MyPara+"^PisTreMet"+String.fromCharCode(2)+txtUtil(jsonObj.PisTreMet);     /// 治疗方法
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisHPV");
	
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 细胞申请单打印
function Print_CYT(jsonObj){
	
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori; 	     /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期
	
	/// 申请单明细内容
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);        /// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);    /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);            /// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);      /// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);      /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);  /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);    /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag);  /// 临床诊断
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisCytExn");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");		
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 尸检申请单打印
function Print_APY(jsonObj){
	
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;            /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;	        /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		    /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;            /// 年龄
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;        /// 费别
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       	/// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;    	/// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	    /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;  	/// 创建日期
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+txtUtil(jsonObj.PatTelH); /// 检查项目
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+txtUtil(jsonObj.PatAddr); /// 检查项目
	
	/// 申请单明细内容
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);       	    /// 申请单号
	MyPara = MyPara+"^SpecName"+String.fromCharCode(2)+txtUtil(jsonObj.SpecName);       		/// 标本信息
	MyPara = MyPara+"^lbapplycheckpro"+String.fromCharCode(2)+txtUtil(jsonObj.CellOrder);  		/// 检查项目
	MyPara = MyPara+"^MorToDeaPro"+String.fromCharCode(2)+txtUtil(jsonObj.MorToDeaPro);  		/// 自发病至死亡病程时日
	MyPara = MyPara+"^DisAndTrePro"+String.fromCharCode(2)+txtUtil(jsonObj.DisAndTrePro);     	/// 病史及治疗经过
	MyPara = MyPara+"^PhyAndLabTest"+String.fromCharCode(2)+txtUtil(jsonObj.PhyAndLabTest); 	/// 临床体格检查及化验检查
	MyPara = MyPara+"^PatDiagDesc"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag);  		/// 最后临床诊断
	
	MyPara = MyPara+"^TakBack"+String.fromCharCode(2)+(txtUtil(jsonObj.FinTakRes) == "TakBack"?"√":"");  		/// 由尸亲领回
	MyPara = MyPara+"^TakHosp"+String.fromCharCode(2)+(txtUtil(jsonObj.FinTakRes) == "TakHosp"?"√":"");  		/// 由院方处置 
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisAutoPsy");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 活体申请单打印
function Print_LIV(jsonObj){

	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期
	
	/// 申请单明细内容
	if (txtUtil(jsonObj.EmgFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}
	if (txtUtil(jsonObj.FrostFlag) == "Y"){
		MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+"√";   /// 冰冻
	}
	
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// 病理号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// 临床诊断
	MyPara = MyPara+"^OperRes"+String.fromCharCode(2)+txtUtil(jsonObj.OperRes);       /// 手术所见
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// 申请单号
	MyPara = MyPara+"^TFoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.TFoundDate); /// 肿瘤发现日期
	MyPara = MyPara+"^TumPart"+String.fromCharCode(2)+txtUtil(jsonObj.TumPart);		  /// 肿瘤部位
	MyPara = MyPara+"^TumSize"+String.fromCharCode(2)+txtUtil(jsonObj.TumSize);       /// 肿瘤大小
	MyPara = MyPara+"^TransFlag"+String.fromCharCode(2)+txtUtil(jsonObj.TransFlag);   /// 是否转移
	MyPara = MyPara+"^TransPos"+String.fromCharCode(2)+txtUtil(jsonObj.TransPos);     /// 转移部位
	MyPara = MyPara+"^RadCureFlag"+String.fromCharCode(2)+txtUtil(jsonObj.RadCureFlag); /// 是否放疗
	MyPara = MyPara+"^CheCureFlag"+String.fromCharCode(2)+txtUtil(jsonObj.CheCureFlag); /// 是否化疗
	MyPara = MyPara+"^Remark"+String.fromCharCode(2)+txtUtil(jsonObj.Remark);           /// 其他信息
	
	MyPara = MyPara+"^LastMensDate"+String.fromCharCode(2)+txtUtil(jsonObj.LastMensDate);  /// 上次月经日期
	MyPara = MyPara+"^MensDate"+String.fromCharCode(2)+txtUtil(jsonObj.MensDate);          /// 末次月经日期
	MyPara = MyPara+"^PauFlag"+String.fromCharCode(2)+txtUtil(jsonObj.PauFlag);            /// 是否绝经
	MyPara = MyPara+"^PreTimes"+String.fromCharCode(2)+txtUtil(jsonObj.PreTimes);          /// 怀孕次数
	MyPara = MyPara+"^LyTimes"+String.fromCharCode(2)+txtUtil(jsonObj.LyTimes);            /// 生产次数
	
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// 取材离体日期
	MyPara = MyPara+"^FixDate"+String.fromCharCode(2)+txtUtil(jsonObj.FixDate);            /// 开始固定日期
	MyPara = MyPara+"^BLocDesc"+String.fromCharCode(2)+txtUtil(jsonObj.BLocDesc);          /// 取材科室
	MyPara = MyPara+"^DocName"+String.fromCharCode(2)+txtUtil(jsonObj.DocName);            /// 取材医生
	MyPara = MyPara+"^PisPatInfDis"+String.fromCharCode(2)+txtUtil(jsonObj.PisPatInfDis);  /// 传染病史
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	if (txtUtil(jsonObj.PatSex) == "女"){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisLivCell");
	}else{
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisLivCell_M");
	}
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");

}

/// 外院申请单打印
function Print_CON(jsonObj){
	
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期
	
	/// 申请单明细内容
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// 临床诊断

	MyPara = MyPara+"^OperRes"+String.fromCharCode(2)+txtUtil(jsonObj.OperRes);        /// 手术所见
	MyPara = MyPara+"^FoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.FoundDate);    /// 首次发现人乳头瘤病毒时间
	MyPara = MyPara+"^InsDoc"+String.fromCharCode(2)+txtUtil(jsonObj.InsDoc);          /// 送检医生
	MyPara = MyPara+"^InsHosp"+String.fromCharCode(2)+txtUtil(jsonObj.InsHosp);        /// 送检医院
	MyPara = MyPara+"^SpecExaRes"+String.fromCharCode(2)+txtUtil(jsonObj.SpecExaRes);  /// 大体标本检查所见
	MyPara = MyPara+"^ConsNote"+String.fromCharCode(2)+txtUtil(jsonObj.ConsNote);      /// 会诊要求
	MyPara = MyPara+"^ConsStaff"+String.fromCharCode(2)+txtUtil(jsonObj.ConsStaff);    /// 会诊专家
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisOutCou");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");

}

/// 分子申请单打印
function Print_MOL(jsonObj){
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期
	
	/// 申请单明细内容
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec); /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(jsonObj.MedRecord);   /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesDiag); /// 临床诊断
	MyPara = MyPara+"^Position"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);   /// 取材部位
	MyPara = MyPara+"^PisCutBasType"+String.fromCharCode(2)+txtUtil(jsonObj.PisCutBasType); ///分子病理取材类型 qunianpeng 2018/2/7
	MyPara = MyPara+"^PisTesItmMol"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesItmMol);  ///分子病理检测项目 qunianpeng 2018/2/7
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisMol");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

///常规
function PrintPis_Xml_New(jsonObj){		   		 
		   		      
	DHCP_GetXMLConfig("InvPrintEncrypt",jsonObj.PrintTemp);
	
	var MyPara = "" + String.fromCharCode(2);
	for (Element in jsonObj){
		MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + jsonObj[Element];
	}
	
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj,MyPara,"");
		   			
}

/// 内容为 undefined 显示空
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}


/// 拆分字符串
function SplitString(TmpString, LimitLen){
	
	var TmpLabelArr = ["","","","","","","","","",""];   /// 初始化空数组
	var Len = 0; j = 0; k = 0;
	/// bianshuai  截取药名
	for (var i=0; i<TmpString.length; i++) {
		var vChar = TmpString.charCodeAt(i);   
		//单字节加1    
		if ((vChar >= 0x0001 && vChar <= 0x007e)||(0xff60 <= vChar && vChar <= 0xff9f)){   
			Len++;   
		}else{   
			Len+=2;   
		}
		
		if(((Len%LimitLen == 0)||(Len%LimitLen == 1))&(Len != 1)){
			
			if ((i - k) < 2) continue;
			TmpLabelArr[j] = TmpString.substr(k, i-k);  /// 截取字符串
			if (j == 4){
				TmpLabelArr[j] = TmpLabelArr[j] + "...";   /// 最后一个字符串后面加...
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

/**去掉字符串前后所有空格*/
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
} 