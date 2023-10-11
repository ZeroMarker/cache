/**!
* 日期:   2016-04-03
* 美康合理用药js【新版医嘱录入使用】
* 
* V2.0
* Update 2018-11-01
* tanjishan
* 封装合理用药系统方法，防止变量污染;修正该方法可以被医嘱录入和草药录入同时引用

* V3.0
* Update 2020-11-07
* tanjishan
* 重写回调相关的处理，与美康厂家沟通新增字段，合并药师审方的逻辑
*/
/// 初始化
function HLYYY_Init(){
	PassFuncs.MKFuncs.PASSIM_INIT();
	//$("#YDTS .menu-text").text("医生自查平台");
}

// 通用第三方药品知识库
function HLYYYDTS_Click(rowid){
	//美康的改成医生自查平台
	/*PassFuncs.MKFuncs.MCInit();
	MDC_DoPassCommand(5001);
	return*/
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		if(!rowid){
			var ids =$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
			if(!ids.length){
				$.messager.alert("警告","请选择一条医嘱");  
				return;
			}
			rowid=ids[0];
		}
		var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("警告","请选择一条医嘱");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
	var OrderName=mPiece(ArcimInfo,"^",1);
	//PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	}else{
		PassFuncs.MKFuncs.MKYDTSCM(OrderARCIMCode,OrderName);
	}
}

/// 通用药品相互作用
function XHZYClickHandler_HLYY(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.MKFuncs.MKXHZY();
	}else{
		PassFuncs.MKFuncs.MKXHZYCM();
	}
}

/// 审查方法
function HYLLUpdateClick_HLYYOld(CallBackFunc){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	if (GlobalObj.McSynCheckMode=="0"){
	    //美康同步审查
	    if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
		}else{
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
		}
	    HLYYCheckFlag =1 ;
	}else{
		var MKCallBackFunc=function(Para){
			if (Para===true){
				CallBackFunc(true)
				return
			}
			//4-关注（黄灯）3-慎用（橙灯）2-严重（红灯） 1-禁忌（黑灯）0-没问题（蓝灯）
			var is_pass = MDC_GetSysPrStatus('', '');
			if ((null == is_pass) || (undefined == is_pass)){
                $.messager.alert("提示", "合理用药自动验证通过", "info",function(){
		            CallBackFunc(true);
		        });
                return;
            }else if ((0 == is_pass) || (-1 == is_pass)){
                CallBackFunc(false);return;
            }
            else if (1 == is_pass)
            {
               //验证自动审方结果
				if (parseInt(Para)==1){
					CallBackFunc(false);
				}else if (parseInt(Para)>1){
					$.messager.confirm('确认对话框',"合理用药审查发现问题，是否继续保存医嘱？", function(r){
						if (r) {CallBackFunc(true)}else{CallBackFunc(false);}
					});
				}else{
					CallBackFunc(true);
				}
				return;
            }
			return;
		}
		try{
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				PassFuncs.MKFuncs.MKXHZYNoView(MKCallBackFunc);
			}else{
				PassFuncs.MKFuncs.MKXHZYNoViewCM(MKCallBackFunc);
			}
		}catch(e){
			$.messager.alert("提示", "合理用药自动验证通过:"+e.message, "info",function(){
	            MKCallBackFunc(true);
	        });
		}
		return;
	}
	if (HLYYCheckFlag==1){
		if (XHZYRetCode > 0){
			var PrescCheck =dhcsys_confirm("合理用药检查有警告，你确认通过吗?", true);
			if (PrescCheck ==false) {
				CallBackFunc(false)
			}
		}
		CallBackFunc(true)
	}else{
		CallBackFunc(true)
	}
}


//这个变量封装到对象里的话，美康不一定能识别
var McRecipeDataList="";
var PassFuncs={
	MKFuncs:{
		//美康 说明书
		MKYDTS:function(OrderARCIMCode,OrderName){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(11)
		},
		//美康 查询中药材专论
		MKYDTSCM:function(OrderARCIMCode,OrderName){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(24)
		},
		//西药相互作用
		MKXHZY:function (){
			this.MCInit();
			this.HisScreenData();
			if(McRecipeDataList=="") return false;
			MDC_DoCheck();
		},
		//中草药相互作用
		MKXHZYCM:function (){
			this.MCInit();
			this.HisScreenDataCM();
			if(McRecipeDataList=="") return false;
			MDC_DoCheck();
		},
		//医嘱录入插入数据审查
		MKXHZYNoView:function (CallBackFunc){
			this.MCInit();
			this.HisScreenData();
			if(McRecipeDataList=="") {
				CallBackFunc(true);
				return false;
			}
			MDC_DoCheck(CallBackFunc,1);
		},
		//草药录入插入数据审查
		MKXHZYNoViewCM:function (CallBackFunc){
			this.MCInit();
			this.HisScreenDataCM();
			if(McRecipeDataList=="") {
				CallBackFunc(true);
				return false;
			}
			MDC_DoCheck(CallBackFunc,1);
		},
		MCInit:function(){
			var pass = new Params_MC_PASSclient_In();
		    pass.HospID = session['LOGON.HOSPID'];  
		    pass.UserID =session['LOGON.USERCODE'];
		    pass.UserName = session['LOGON.USERNAME'];
		    pass.DeptID = GlobalObj.LogLocCode;
		    pass.DeptName = GlobalObj.CTLOC;
			//pass.IP = "";
			//pass.PCName = "";
			//pass.OSInfo = "";
			//pass.Resolution = "";
			//pass.PassVersion = "";
		    pass.CheckMode =(GlobalObj.PAAdmType=="I"?"zy":"mz");
		    MCPASSclient = pass;
		},
		HisQueryData:function (OrderARCIMCode,OrderName) {
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode; //药品编号
		    drug.CodeName = OrderName;       //药品名称
		    MC_global_queryDrug = drug;
		},
		HisScreenData:function (){
			McRecipeDataList="";
			var OrderStr="";
			var rowids=$('#Order_DataGrid').getDataIDs();
			for(var i=0;i<rowids.length;i++){
				var Row=rowids[i];
				var OrderItemRowid=GetCellData(Row,"OrderItemRowid");
				if (OrderItemRowid!="") {continue;}
				var OrderARCIMRowid=GetCellData(Row,"OrderARCIMRowid");
				if (OrderARCIMRowid=="") {continue;}
				var OrderType=GetCellData(Row,"OrderType");
				if (OrderType!="R") {continue;}
				var OrderPHPrescType=GetCellData(Row,"OrderPHPrescType");
			    if ((OrderPHPrescType==3)&&(GlobalObj.DTCheckCNMed!="1")){continue;}
			    var OrderSeqNo=GetCellData(Row,"id");
			    var OrderDoseQty=GetCellData(Row,"OrderDoseQty");
			    var OrderDoseUOMRowid=GetCellData(Row,"OrderDoseUOMRowid");
			    var OrderFreqRowid=GetCellData(Row,"OrderFreqRowid");
			    var OrderInstrRowid=GetCellData(Row,"OrderInstrRowid");
			    var OrderStartDateStr=GetCellData(Row,"OrderStartDate");
			    var OrderMasterSeqNo=GetCellData(Row,"OrderMasterSeqNo");
			    var OrderPriorRowId=GetCellData(Row,"OrderPriorRowid");
			    var OrderPriorRemarks=GetCellData(Row,"OrderPriorRemarksRowId");
				OrderPriorRowId=ReSetOrderPriorRowid(OrderPriorRowId,OrderPriorRemarks);
			    var OrderDeptId=session['LOGON.CTLOCID'];
				var OrderUserId=session['LOGON.USERID'];
				var VirtualPrescNo=GlobalObj.EpisodeID+"-001"+rowids.length+"";	//虚拟处方号
			    var OrderPackQty=GetCellData(Row,"OrderPackQty");
				var OrderPackUOMRowid=GetCellData(Row,"OrderPackUOMRowid");
				var OrderDurRowid=GetCellData(Row,"OrderDurRowid");
				var UserReasonId=GetCellData(Row,"UserReasonId");
			    var OrderStageCode=GetCellData(Row,"OrderStageCode");
			    var OrderSpeedFlowRate=GetCellData(Row,"OrderSpeedFlowRate"); 
				var OrderFlowRateUnit=GetCellData(Row,"OrderFlowRateUnitRowId");
			    var OrderRecDepRowid=GetCellData(Row,"OrderRecDepRowid");
				var OrderDepProcNote=GetCellData(Row,"OrderDepProcNote");
				var OrderPhSpecInstr="";	//草药特殊煎煮方法名称
				var OrderFirstDayTimes=GetCellData(Row,"OrderFirstDayTimes");
				var OrderCoverMainIns=GetCellData(Row,"OrderCoverMainIns");
				var BillTypeRowid=GetCellData(Row,"OrderBillTypeRowid");
				var Para=OrderSeqNo+"!"+OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+OrderFreqRowid;
				var Para=Para+"!"+OrderInstrRowid+"!"+OrderStartDateStr+"!"+OrderMasterSeqNo+"!"+OrderPriorRowId+"!"+OrderDeptId;
				var Para=Para+"!"+OrderUserId+"!"+VirtualPrescNo+"!"+OrderPackQty+"!"+OrderPackUOMRowid+"!"+OrderDurRowid;
				var Para=Para+"!"+UserReasonId+"!"+OrderStageCode+"!"+OrderSpeedFlowRate+"!"+OrderFlowRateUnit+"!"+OrderRecDepRowid;
				var Para=Para+"!"+OrderDepProcNote+"!"+OrderPhSpecInstr+"!"+OrderFirstDayTimes+"!"+OrderCoverMainIns+"!"+BillTypeRowid;
				//
				if (OrderStr==""){OrderStr=Para;}else{OrderStr=OrderStr+"^"+Para;}
			}
			if (OrderStr==""){return;}
			var UserID=session['LOGON.USERID'];
			var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",GlobalObj.EpisodeID,OrderStr,UserID);
			var TempArr=ret.split(String.fromCharCode(2));
			//传入病人基本信息接口
			var PatInfo=TempArr[0];
			var PatArr=PatInfo.split("^");
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];		//病人编号
			ppi.InHospNo = PatArr[1];		//门诊号/住院号
			ppi.VisitCode = PatArr[2];		//就诊序号/住院次数
			ppi.Name = PatArr[3];			//病人姓名
			ppi.Sex = PatArr[4];			//病人性别
			ppi.Birthday = PatArr[5];		//出生日期
			ppi.HeightCM = PatArr[6];		//身高
			ppi.WeighKG = PatArr[7];		//体重
			ppi.DeptCode = PatArr[8];		//就诊科室编码
			ppi.DeptName = PatArr[9];		//就诊科室名称
			ppi.DoctorCode = PatArr[10];	//就诊/主管医生编码
			ppi.DoctorName = PatArr[11];	//就诊/主管医生姓名
			ppi.PatStatus = PatArr[12];		//病人类型
			ppi.IsLactation = PatArr[13];	//是否哺乳
			ppi.IsPregnancy = PatArr[14];	//是否妊娠
			ppi.PregStartDate = PatArr[15];	//妊娠开始日期
			ppi.HepDamageDegree = PatArr[16];	//肝损害程序
			ppi.RenDamageDegree = PatArr[17];	//肾损害程序
			ppi.CheckMode = PatArr[18];		//审查模板
			ppi.IsDoSave = PatArr[19];		//是否采集
			ppi.Age = PatArr[20];			//年龄
			ppi.PayClass = PatArr[21];		//费别
			ppi.InHospDate = PatArr[22];	//入院日期
			ppi.OutHospDate = PatArr[23];	//出院日期
			ppi.IsTestEtiology = PatArr[24];	//是否做过病原学检查
			ppi.IDCard = PatArr[25];		//身份证号码
			ppi.Telephone = PatArr[26];		//病人联系电话
			ppi.Urgent = PatArr[27];		//是否加急
			ppi.MedicareType = PatArr[28];	//医保类型
			ppi.IsFast = PatArr[29];		//是否禁食
			ppi.Temperature = PatArr[30];	//体温
			ppi.PatLevel = PatArr[31];		//病人身份(职业)
			ppi.medicalcharge = PatArr[32];	//就医方式
			ppi.hospitallevel = PatArr[33];	//医院级别
			ppi.multidaydosepriv = PatArr[34];	//特殊病人超多日用量审批标记
			ppi.bedno = PatArr[35];		//住院期间床号
			ppi.documentno = PatArr[36];	//病人病案号
			ppi.isdialysis = PatArr[37];	//是否透析病人
			MCpatientInfo  = ppi;
			//传入病人过敏史信息接口
			var AllergenInfo=TempArr[1];
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			var arrayAllergen = new Array();
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //序号  
		      	allergen.AllerCode = AllergenArr[0];	//编码
		      	allergen.AllerName = AllergenArr[1];	//名称  
		      	allergen.AllerSymptom =AllergenArr[3];	//过敏症状 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//传入病人诊断信息接口
			var MedCondInfo=TempArr[2];
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			var arrayMedCond = new Array();
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i;              		//诊断序号
		     	medcond.DiseaseCode = MedCondArr[0];	//诊断编码
		      	medcond.DiseaseName = MedCondArr[1];	//诊断名称
		 		medcond.RecipNo = "";					//处方号
		      	arrayMedCond[arrayMedCond.length] = medcond;
			}
			McMedCondArray = arrayMedCond;
			//传入病人手术信息接口
			var OperationInfo=TempArr[3];
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
			//传入病人用药信息接口
			var OrderInfo=TempArr[4];
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		    var arrayDrug = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){
				var OrderArr=OrderInfoArr[i].split("^");
				var drug = new Params_Mc_Drugs_In();
				drug.Index = OrderArr[0];			//医嘱唯一码
		        drug.OrderNo = OrderArr[1];			//医嘱序号
		        drug.DrugUniqueCode = OrderArr[2];  //药品唯一码
		        drug.DrugName = OrderArr[3]; 		//药品名称
		        drug.DosePerTime = OrderArr[4];		//单次用量
				drug.DoseUnit = OrderArr[5];		//给药单位      
		        drug.Frequency = OrderArr[6];		//用药频次
		        drug.RouteCode = OrderArr[8];		//给药途径编码
		        drug.RouteName = OrderArr[8];		//给药途径名称
				drug.StartTime = OrderArr[9];		//开嘱时间
		        drug.EndTime = OrderArr[10];		//停嘱时间
		        drug.ExecuteTime = OrderArr[11];	//执行时间
				drug.GroupTag = OrderArr[12];		//成组标识
		        drug.IsTempDrug = OrderArr[13];		//是否临时用药 0-长期 1-临时
		        if (GlobalObj.PAAdmType!="I"){
			        drug.IsTempDrug = "0";
		        }
		        drug.OrderType = OrderArr[14];		//医嘱类型 0-在用（默认），1-已作废，2-已停嘱，3-出院带药，4-取药医嘱，9-新开
		        drug.DeptCode = OrderArr[15];		//就诊科室编码
		        drug.DeptName = OrderArr[16];		//就诊科室名称
		        drug.DoctorCode = OrderArr[17];		//就诊医生代码 
		        drug.DoctorName = OrderArr[18];		//就诊医生姓名
				drug.RecipNo = OrderArr[19];		//处方号
		        drug.Num = OrderArr[20];			//药品开出数量
		        drug.NumUnit = OrderArr[21];		//药品开出数量单位     
		        drug.duration = OrderArr[22];		//用药天数
		        drug.Purpose = OrderArr[23];		//用药目的。’1’表示可能预防，’2’表示可能治疗，’3’表示预防，’4’表示治疗，’5’表示预防+治疗, 默认值为’0’
		        drug.OprCode = OrderArr[24];		//药品对应的手术编码
		        drug.MediTime = OrderArr[25]; 		//用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		        drug.driprate = OrderArr[26];		//滴速
		        drug.driptime = OrderArr[27];		//输液时间
		        drug.IsOtherRecip = OrderArr[28];	//是否历史处方药品信息
		        drug.skintest = OrderArr[29];		//皮试结果
		        drug.pharmacycode = OrderArr[30];	//药房编码
		        drug.pharmacyname = OrderArr[31];	//药房名称
		        drug.driprange = OrderArr[32];		//滴速范围
		        drug.doctorpriv = OrderArr[33];		//是否上级授权
		        drug.Remark = OrderArr[34];			//医嘱备注
		        drug.decoction = OrderArr[35];		//草药特殊煎煮方法名称
		        drug.firstdayfreq = OrderArr[36];	//首日用药频次标记
		        drug.dosetype = OrderArr[37];		//剂量类型
		        drug.ischronicdisease = OrderArr[38];	//处方慢性病标识
		        drug.PayClass = OrderArr[39];		//付费方式
				arrayDrug[arrayDrug.length] = drug;
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
		},
		HisScreenDataCM:function (){
			McRecipeDataList="";
			var OrderStr="";
			var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
		    var OrderSeqNo=0;
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val();
					if (OrderARCIMRowid=="") continue;
					var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
					var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
	                var OrderDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
	                var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text();
	                var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns"); 
					var OrderMasterSeqNo="";
					if (OrderStr!=""){OrderMasterSeqNo=1;}
					var OrderSeqNo=OrderSeqNo+1;
					var OrderStartDateStr="";
					var OrderDeptId=session['LOGON.CTLOCID'];
					var OrderUserId=session['LOGON.USERID'];
					var VirtualPrescNo=GlobalObj.EpisodeID+"-001"+rows+"";	//虚拟处方号
					var OrderPackQty="";
					var OrderPackUOMRowid="";
					var BillTypeRowid=GlobalObj.OrderBillTypeRowid
					var Para=OrderSeqNo+"!"+OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+PrescFrequenceRowid;
					var Para=Para+"!"+PrescInstructionID+"!"+OrderStartDateStr+"!"+OrderMasterSeqNo+"!"+OrderPriorRowid+"!"+OrderDeptId;
					var Para=Para+"!"+OrderUserId+"!"+VirtualPrescNo+"!"+OrderPackQty+"!"+OrderPackUOMRowid+"!"+PrescDurRowid;
					var Para=Para+"!"+""+"!"+""+"!"+""+"!"+""+"!"+OrderRecDepRowid;
					var Para=Para+"!"+""+"!"+OrderPhSpecInstr+"!"+""+"!"+OrderCoverMainIns+"!"+BillTypeRowid;
					//
					if (OrderStr==""){OrderStr=Para;}else{OrderStr=OrderStr+"^"+Para;}
			    }
			}
			if (OrderStr==""){return;}
			var UserID=session['LOGON.USERID'];
			var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",GlobalObj.EpisodeID,OrderStr,UserID);
			var TempArr=ret.split(String.fromCharCode(2));
			//传入病人基本信息接口
			var PatInfo=TempArr[0];
			var PatArr=PatInfo.split("^");
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];		//病人编号
			ppi.InHospNo = PatArr[1];		//门诊号/住院号
			ppi.VisitCode = PatArr[2];		//就诊序号/住院次数
			ppi.Name = PatArr[3];			//病人姓名
			ppi.Sex = PatArr[4];			//病人性别
			ppi.Birthday = PatArr[5];		//出生日期
			ppi.HeightCM = PatArr[6];		//身高
			ppi.WeighKG = PatArr[7];		//体重
			ppi.DeptCode = PatArr[8];		//就诊科室编码
			ppi.DeptName = PatArr[9];		//就诊科室名称
			ppi.DoctorCode = PatArr[10];	//就诊/主管医生编码
			ppi.DoctorName = PatArr[11];	//就诊/主管医生姓名
			ppi.PatStatus = PatArr[12];		//病人类型
			ppi.IsLactation = PatArr[13];	//是否哺乳
			ppi.IsPregnancy = PatArr[14];	//是否妊娠
			ppi.PregStartDate = PatArr[15];	//妊娠开始日期
			ppi.HepDamageDegree = PatArr[16];	//肝损害程序
			ppi.RenDamageDegree = PatArr[17];	//肾损害程序
			ppi.CheckMode = PatArr[18];		//审查模板
			ppi.IsDoSave = PatArr[19];		//是否采集
			ppi.Age = PatArr[20];			//年龄
			ppi.PayClass = PatArr[21];		//费别
			ppi.InHospDate = PatArr[22];	//入院日期
			ppi.OutHospDate = PatArr[23];	//出院日期
			ppi.IsTestEtiology = PatArr[24];	//是否做过病原学检查
			ppi.IDCard = PatArr[25];		//身份证号码
			ppi.Telephone = PatArr[26];		//病人联系电话
			ppi.Urgent = PatArr[27];		//是否加急
			ppi.MedicareType = PatArr[28];	//医保类型
			ppi.IsFast = PatArr[29];		//是否禁食
			ppi.Temperature = PatArr[30];	//体温
			ppi.PatLevel = PatArr[31];		//病人身份(职业)
			ppi.medicalcharge = PatArr[32];	//就医方式
			ppi.hospitallevel = PatArr[33];	//医院级别
			ppi.multidaydosepriv = PatArr[34];	//特殊病人超多日用量审批标记
			ppi.bedno = PatArr[35];		//住院期间床号
			ppi.documentno = PatArr[36];	//病人病案号
			ppi.isdialysis = PatArr[37];	//是否透析病人
			MCpatientInfo  = ppi;
			//传入病人过敏史信息接口
			var AllergenInfo=TempArr[1];
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			var arrayAllergen = new Array();
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //序号  
		      	allergen.AllerCode = AllergenArr[0];	//编码
		      	allergen.AllerName = AllergenArr[1];	//名称  
		      	allergen.AllerSymptom =AllergenArr[3];	//过敏症状 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//传入病人诊断信息接口
			var MedCondInfo=TempArr[2];
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			var arrayMedCond = new Array();
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i;              		//诊断序号
		     	medcond.DiseaseCode = MedCondArr[0];	//诊断编码
		      	medcond.DiseaseName = MedCondArr[1];	//诊断名称
		 		medcond.RecipNo = "";					//处方号
		      	arrayMedCond[arrayMedCond.length] = medcond;
			}
			McMedCondArray = arrayMedCond;
			//传入病人手术信息接口
			var OperationInfo=TempArr[3];
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
			//传入病人用药信息接口
			var OrderInfo=TempArr[4];
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		    var arrayDrug = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){
				var OrderArr=OrderInfoArr[i].split("^");
				var drug = new Params_Mc_Drugs_In();
				drug.Index = OrderArr[0];			//医嘱唯一码
		        drug.OrderNo = OrderArr[1];			//医嘱序号
		        drug.DrugUniqueCode = OrderArr[2];  //药品唯一码
		        drug.DrugName = OrderArr[3]; 		//药品名称
		        drug.DosePerTime = OrderArr[4];		//单次用量
				drug.DoseUnit = OrderArr[5];		//给药单位      
		        drug.Frequency = OrderArr[6];		//用药频次
		        drug.RouteCode = OrderArr[7];		//给药途径编码
		        drug.RouteName = OrderArr[8];		//给药途径名称
				drug.StartTime = OrderArr[9];		//开嘱时间
		        drug.EndTime = OrderArr[10];		//停嘱时间
		        drug.ExecuteTime = OrderArr[11];	//执行时间
				drug.GroupTag = OrderArr[12];		//成组标识
		        drug.IsTempDrug = OrderArr[13];		//是否临时用药 0-长期 1-临时
		        drug.OrderType = OrderArr[14];		//医嘱类型 0-在用（默认），1-已作废，2-已停嘱，3-出院带药，4-取药医嘱，9-新开
		        drug.DeptCode = OrderArr[15];		//就诊科室编码
		        drug.DeptName = OrderArr[16];		//就诊科室名称
		        drug.DoctorCode = OrderArr[17];		//就诊医生代码 
		        drug.DoctorName = OrderArr[18];		//就诊医生姓名
				drug.RecipNo = OrderArr[19];		//处方号
		        drug.Num = OrderArr[20];			//药品开出数量
		        drug.NumUnit = OrderArr[21];		//药品开出数量单位     
		        drug.duration = OrderArr[22];		//用药天数
		        drug.Purpose = OrderArr[23];		//用药目的。’1’表示可能预防，’2’表示可能治疗，’3’表示预防，’4’表示治疗，’5’表示预防+治疗, 默认值为’0’
		        drug.OprCode = OrderArr[24];		//药品对应的手术编码
		        drug.MediTime = OrderArr[25]; 		//用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		        drug.driprate = OrderArr[26];		//滴速
		        drug.driptime = OrderArr[27];		//输液时间
		        drug.IsOtherRecip = OrderArr[28];	//是否历史处方药品信息
		        drug.skintest = OrderArr[29];		//皮试结果
		        drug.pharmacycode = OrderArr[30];	//药房编码
		        drug.pharmacyname = OrderArr[31];	//药房名称
		        drug.driprange = OrderArr[32];		//滴速范围
		        drug.doctorpriv = OrderArr[33];		//是否上级授权
		        drug.Remark = OrderArr[34];			//医嘱备注
		        drug.decoction = OrderArr[35];		//草药特殊煎煮方法名称
		        drug.firstdayfreq = OrderArr[36];	//首日用药频次标记
		        drug.dosetype = OrderArr[37];		//剂量类型
		        drug.ischronicdisease = OrderArr[38];	//处方慢性病标识
		        drug.PayClass = OrderArr[39];		//付费方式
				arrayDrug[arrayDrug.length] = drug;
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
		},
		HisQueryDataById:function (Row){
			var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
			var OrderARCIMCode=mPiece(OrderHiddenPara,String.fromCharCode(1),11);
			var OrderName=GetCellData(Row,"OrderName");
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode; //药品编号
		    drug.CodeName = OrderName;       //药品名称
		    MC_global_queryDrug = drug;	
		},
		//初始化美康通讯工具
		PASSIM_INIT:function(){
			if (typeof Params_MC_PASSIM_In !="undefined"){
				var im=new Params_MC_PASSIM_In()
				im.hiscode="0"
				im.doctor=session['LOGON.USERCODE'];
				im.Init()
			}
		}
	}
}

function OnMouseUpRightMenu1(){
	if (event.button==2) {
		if (GlobalObj.HLYYInterface!=1) return;
		var Row=GetRow(FocusRowIndex);
		var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
		var OrderARCIMCode=mPiece(OrderHiddenPara,String.fromCharCode(1),7);
		if(OrderARCIMCode=="") return;
		var OrderType=GetColumnData("OrderType",Row);
		if (OrderType=="R"){
			QueryItemclick();
			OnMouseUpRightMenu(1,-2,"true");
		}
	}
}

function XHZYAJ_Click(){
	if ((DHCDTInterface==1)){
  		MenuClick();
  	}
}

/*function HIS_dealwithPASSCheck(result) {
    if (result > 0) {
        if (confirm("审查出用药问题，你确认需要保存处方吗？")) 
        {
        	var slcode1=MDC_getWarningCode("1");
        	//保存返回值 
         
          var slcode1 = MDC_getWarningCode("1");
         alert("返回结果是:"+slcode1);                	
        	location.reload(true);   //如用户选择“是”，则刷新当前页面
        }
    }
    else {
        alert("没问题");
    }
}*/

///右键弹出
function YLYYOnRightClick(Row){
	if (GlobalObj.HLYYInterface!=1){
		return;
	}
	if (GlobalObj.HLYYLayOut!="OEOrd"){
		return;
	}
	var OrderType=GetCellData(Row,"OrderType");
	if(OrderType!="R") return 
	if (GlobalObj.HLYYInterface==1){
		PassFuncs.MKFuncs.MCInit();
		PassFuncs.MKFuncs.HisQueryDataById(Row);
		McPASS.McRightMenu()
		
		var rowids=GetAllRowId();
		for(var i=0;i<rowids.length;i++){
			if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")=="checked"){
				$("#Order_DataGrid").setSelection(rowids[i],false);
			}				
		}
		if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")!="checked"){
			$("#Order_DataGrid").setSelection(Row,true);
		}
	}	
}
function HYLLUpdateClick_HLYY(CallBackFunc){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	new Promise(function (resolve, rejected) {
		if (GlobalObj.McSynCheckMode=="0"){
			//美康同步审查
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
			}else{
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
			}
			HLYYCheckFlag =1 ;
			resolve(true)
		}else{
			try{
				if (GlobalObj.HLYYLayOut=="OEOrd"){
					PassFuncs.MKFuncs.MKXHZYNoView(resolve);
				}else{
					PassFuncs.MKFuncs.MKXHZYNoViewCM(resolve);
				}
			}catch(e){
				$.messager.alert("提示", "合理用药自动验证通过:"+e.message, "info",function(){
					resolve(true);
				});
			}
		}
	}).then(function (Para) {
		return new Promise(function(resolve,rejected){
			if (Para===true){
				CallBackFunc(true);
				return;
			}
			//https无法引用美康JS,直接返回
			if (typeof MDC_GetSysPrStatus != "function") {
				CallBackFunc(true);
				return;
			}
			//Para：4-关注（黄灯）3-慎用（橙灯）2-严重（红灯） 1-禁忌（黑灯）0-没问题（蓝灯）
			//is_pass：1 通过，0 未通过 -1 待定(未走完流程) 。
			var is_pass = MDC_GetSysPrStatus('', '');
			if ((null == is_pass) || (undefined == is_pass)){
				$.messager.alert("提示", "合理用药自动通过验证", "info",function(){
					CallBackFunc(true);
				});
			}else if ((0 == is_pass) || (-1 == is_pass)){
				CallBackFunc(false);
			}else if (1 == is_pass){		//药师审方通过
				if(parseInt(Para)>0){		//有警示信息提醒医生是否保存
					new Promise(function(resolve,rejected){
						$.messager.confirm('确认对话框',"合理用药审查发现问题，是否继续保存医嘱？", function(r){
							if (r){ CallBackFunc(true); }
							else{ CallBackFunc(false); }
						});
					});
				}else{
					CallBackFunc(true);
				}
			}else{
					CallBackFunc(true);
			}
		})
	})
}