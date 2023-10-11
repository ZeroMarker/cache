/**!
* 日期:   2016-04-03
* 美康合理用药js【新版医嘱录入使用】
* 
* V2.0
* Update 2018-11-01
* tanjishan
* 封装合理用药系统方法，防止变量污染;修正该方法可以被医嘱录入和草药录入同时引用
*/
///初始化
function HLYYY_Init(){
	
}
// 通用第三方药品知识库
function HLYYYDTS_Click(rowid){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//选中一行
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
	if (GlobalObj.CurrCompanyCode=="MK"){
		var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
		var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
		var OrderName=mPiece(ArcimInfo,"^",1);
		PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	}else if (GlobalObj.CurrCompanyCode=="DT"){
        PassFuncs.DTCSFuncs.DTYDTS(OrderARCIMRowid, 1);
	}
}

///通用药品相互作用
function XHZYClickHandler_HLYY(){
	if (GlobalObj.CurrCompanyCode=="MK"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.MKFuncs.MKXHZY();
		}else{
			PassFuncs.MKFuncs.MKXHZYCM();
		}
	}else if(GlobalObj.CurrCompanyCode=="DT"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.DTCSFuncs.DaTongXHZYHander();
		}else{
			PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
		}
	}
}

///审查方法
function HYLLUpdateClick_HLYY(callBackFun){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	//美康同步审查
	if (GlobalObj.McSynCheckMode=="0"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
		}else{
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
		}
		if (XHZYRetCode > 0){
			$.messager.confirm("确认对话框", t['DT_Question'], function (r) {
				callBackFun(r);
			});
		}else{
			callBackFun(true);
		}
	}else{
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.MKFuncs.MKXHZYNoView(callBackFun);
		}else{
			PassFuncs.MKFuncs.MKXHZYNoViewCM(callBackFun);
		}
	}
	/*if (GlobalObj.CurrCompanyCode=="DT"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHander();
		}else{
			XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
		}
		HLYYCheckFlag =1 ;
    }else if(GlobalObj.CurrCompanyCode=="MK"){
	    if (GlobalObj.McSynCheckMode=="0"){
		    //美康同步审查
		    if (GlobalObj.HLYYLayOut=="OEOrd"){
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
			}else{
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
			}
		    HLYYCheckFlag =1 ;
		}else{
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				PassFuncs.MKFuncs.MKXHZYNoView();
			}else{
				PassFuncs.MKFuncs.MKXHZYNoViewCM();
			}
		}
	}
	if (HLYYCheckFlag==1){
		if (XHZYRetCode > 0){
			var PrescCheck =dhcsys_confirm("合理用药检查有警告，你确认通过吗?", true);
			if (PrescCheck ==false) {
				return "-1"
			}
		}
		return 0;
	}else{
		return 100
	}*/
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
		MKXHZYNoView:function (){
			this.MCInit();
			this.HisScreenData();
			if(McRecipeDataList=="") {
				HIS_dealwithPASSCheck(0);
				return false;
			}
			MDC_DoCheck(HIS_dealwithPASSCheck,1);
		},
		//草药录入插入数据审查
		MKXHZYNoViewCM:function (){
			this.MCInit();
			this.HisScreenDataCM();
			if(McRecipeDataList=="") {
				HIS_dealwithPASSCheck(0);
				return false;
			}
			MDC_DoCheck(HIS_dealwithPASSCheck,1);
		},
		MCInit:function(){
			var pass = new Params_MC_PASSclient_In();
		    pass.HospID = session['LOGON.HOSPID'];  
		    pass.UserID =session['LOGON.USERID'];
		    pass.UserName = session['LOGON.USERNAME'];
		    pass.DeptID = session['LOGON.CTLOCID'];
		    pass.DeptName = GlobalObj.CTLOC;
			//pass.IP = "";
			//pass.PCName = "";
			///pass.OSInfo = "";     
			//pass.Resolution = ""; 
			//pass.PassVersion = "";
		    pass.CheckMode ="zy"  //MC_global_CheckMode;
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
			var Orders="";
			var Para1=""
			var rowids=$('#Order_DataGrid').getDataIDs();
			for(var i=0;i<rowids.length;i++){
				var Row=rowids[i];
				var OrderItemRowid=GetCellData(Row,"OrderItemRowid");
				var OrderARCIMRowid=GetCellData(Row,"OrderARCIMRowid");
				var OrderType=GetCellData(Row,"OrderType");
				var OrderDurRowid=GetCellData(Row,"OrderDurRowid");
				var OrderFreqRowid=GetCellData(Row,"OrderFreqRowid");
				var OrderInstrRowid=GetCellData(Row,"OrderInstrRowid");
				var OrderDoseQty=GetCellData(Row,"OrderDoseQty");
				var OrderDoseUOMRowid=GetCellData(Row,"OrderDoseUOMRowid");
		    	var OrderDrugFormRowid=GetCellData(Row,"OrderDrugFormRowid");
				var OrderPHPrescType=GetCellData(Row,"OrderPHPrescType");
				var OrderPriorRowId=GetCellData(Row,"OrderPriorRowid");
				var OrderSeqNo=GetCellData(Row,"id");
				
				//$(Row+"_OrderMKLight").html(str);
				var OrderMasterSeqNo=GetCellData(Row,"OrderMasterSeqNo");
				//var obj=document.getElementById("McRecipeCheckLight_"+OrderSeqNo,Row);
			    //判断是否处理草药
			    if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;}
			    if (OrderType!="R") {continue;}
			    if (OrderARCIMRowid=="") {continue;}
			    if (OrderItemRowid!="") {continue;}
			    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
			    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+OrderPriorRowId+"!"+OrderSeqNo+"!"+Row+"!"+OrderMasterSeqNo;
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
					if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
				}
			}
			if (Orders==""){return;}
			var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return}
			var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
			var TempArr=ret.split(String.fromCharCode(2));
			var PatInfo=TempArr[0];
			var MedCondInfo=TempArr[1];
			var AllergenInfo=TempArr[2];
			var OrderInfo=TempArr[3];
			var PatArr=PatInfo.split("^");
			
			
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];			// 病人编码
			ppi.InHospNo= PatArr[11]
			ppi.VisitCode =PatArr[7]            // 住院次数
			ppi.Name = PatArr[1];				// 病人姓名
			ppi.Sex = PatArr[2];				// 性别
			ppi.Birthday = PatArr[3];			// 出生年月
			
			ppi.HeightCM = PatArr[5];			// 身高
			ppi.WeighKG = PatArr[6];			// 体重
			ppi.DeptCode  = PatArr[8];			// 住院科室
			ppi.DeptName  =PatArr[12]
			ppi.DoctorCode =PatArr[13] ;		// 医生
			ppi.DoctorName =PatArr[9]
			ppi.PatStatus =1
			ppi.UseTime  = PatArr[4];		   	// 使用时间
			ppi.CheckMode = MC_global_CheckMode
			ppi.IsDoSave = 1
			MCpatientInfo  = ppi;
		    var arrayDrug = new Array();
			var pri;
		  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		  	//alert(OrderInfo)
		  	McRecipeCheckLastLightStateArr = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){    
				var OrderArr=OrderInfoArr[i].split("^");
				//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
		        drug = new Params_Mc_Drugs_In();
		        
		        drug.Index = OrderArr[0];             			//药品序号
		        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
		        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
		        drug.DrugName =  OrderArr[2]; 			//药品名称
		        drug.DosePerTime = OrderArr[3]; 	   //单次用量
				drug.DoseUnit =OrderArr[4];   	        //给药单位      
		        drug.Frequency =OrderArr[5]; 	        //用药频次
		        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
		        drug.RouteName = OrderArr[8];   		//给药途径名称
				drug.StartTime = OrderArr[6];			//开嘱时间
		        drug.EndTime = OrderArr[7]; 			//停嘱时间
		        drug.ExecuteTime = ""; 	   				//执行时间
				drug.GroupTag = OrderArr[10]; 	       //成组标记
		        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
		        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
		        drug.DeptCode = GlobalObj.CTLOC.split("-")[1];     //开嘱科室编码
		        drug.DeptName =  GlobalObj.CTLOC; 	  //开嘱科室名称
		        drug.DoctorCode =session['LOGON.USERCODE'];   //开嘱医生编码
		        drug.DoctorName =session['LOGON.USERNAME'];     //开嘱医生姓名
				drug.RecipNo = "";            //处方号
		        drug.Num = "";                //药品开出数量
		        drug.NumUnit = "";            //药品开出数量单位          
		        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
		        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
				drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
				drug.Remark = "";             //医嘱备注 
				drug.driprate = ""; //滴速(120滴/分钟)
				drug.driptime = ""; //滴时间(滴100分钟
				arrayDrug[arrayDrug.length] = drug;
		    
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
			var arrayAllergen = new Array();
			var pai;
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		        
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //序号  
		      	allergen.AllerCode = AllergenArr[0];    //编码
		      	allergen.AllerName = AllergenArr[1];    //名称  
		      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//病生状态类数组
			 var arrayMedCond = new Array();
			var pmi;
		  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		       
		      	var medcond;       
		      	medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i	;              			//诊断序号
		     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
		      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
		 		medcond.RecipNo = "";              //处方号
		      	arrayMedCond[arrayMedCond.length] = medcond;     
		      
			}
			McMedCondArray = arrayMedCond;
			
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
		},
		HisScreenDataCM:function (){
			McRecipeDataList="";
			var Orders="";
			var Para1=""
			var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime",PageLogicObj.defaultDataCache, "1");
		    var CurrDateTimeArr = CurrDateTime.split("^");
		    var CurrDate = CurrDateTimeArr[0];
		    var CurrTime = CurrDateTimeArr[1];
		    var OrderSeqNo=0;
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
				   if (OrderARCIMRowid!=""){
					    var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
						var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
						var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
						OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
						
						var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
						var OrderDrugFormRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2);
						var PHCDoseUOMDesc = mPiece(OrderHiddenPara, String.fromCharCode(3), 9);
		                var PHCDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
						var MasterSeqNo="";
						if (Orders!=""){
							var MasterSeqNo=1;
						}
						var OrderSeqNo=OrderSeqNo+1;
				   		Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+PHCDoseUOMRowid;
					    Para1=Para1+"!"+PrescFrequenceRowid+"!"+PrescDurationRowid+"!"+PrescInstructionID+"!"+OrderDrugFormRowid+"!"+OrderSeqNo+"!"+OrderSeqNo+"!"+MasterSeqNo;
						if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
							if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
						}
				   
				   }
			    }
			}
			if (Orders==""){return;}
			var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return}
			var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
			var TempArr=ret.split(String.fromCharCode(2));
			var PatInfo=TempArr[0];
			var MedCondInfo=TempArr[1];
			var AllergenInfo=TempArr[2];
			var OrderInfo=TempArr[3];
			var PatArr=PatInfo.split("^");
			
			
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];			// 病人编码
			ppi.InHospNo= PatArr[11]
			ppi.VisitCode =PatArr[7]            // 住院次数
			ppi.Name = PatArr[1];				// 病人姓名
			ppi.Sex = PatArr[2];				// 性别
			ppi.Birthday = PatArr[3];			// 出生年月
			
			ppi.HeightCM = PatArr[5];			// 身高
			ppi.WeighKG = PatArr[6];			// 体重
			ppi.DeptCode  = PatArr[8];			// 住院科室
			ppi.DeptName  =PatArr[12]
			ppi.DoctorCode =PatArr[13] ;		// 医生
			ppi.DoctorName =PatArr[9]
			ppi.PatStatus =1
			ppi.UseTime  = PatArr[4];		   	// 使用时间
			ppi.CheckMode = MC_global_CheckMode
			ppi.IsDoSave = 1
			MCpatientInfo  = ppi;
		    var arrayDrug = new Array();
			var pri;
		  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		  	//alert(OrderInfo)
		  	McRecipeCheckLastLightStateArr = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){    
				var OrderArr=OrderInfoArr[i].split("^");
				//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
		        drug = new Params_Mc_Drugs_In();
		        
		        drug.Index = OrderArr[0];             			//药品序号
		        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
		        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
		        drug.DrugName =  OrderArr[2]; 			//药品名称
		        drug.DosePerTime = OrderArr[3]; 	   //单次用量
				drug.DoseUnit =OrderArr[4];   	        //给药单位      
		        drug.Frequency =OrderArr[5]; 	        //用药频次
		        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
		        drug.RouteName = OrderArr[8];   		//给药途径名称
				drug.StartTime = OrderArr[6];			//开嘱时间
		        drug.EndTime = OrderArr[7]; 			//停嘱时间
		        drug.ExecuteTime = ""; 	   				//执行时间
				drug.GroupTag = OrderArr[10]; 	       //成组标记
		        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
		        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
		        drug.DeptCode = GlobalObj.CTLOC.split("-")[1];     //开嘱科室编码
		        drug.DeptName =  GlobalObj.CTLOC; 	  //开嘱科室名称
		        drug.DoctorCode =session['LOGON.USERCODE'];   //开嘱医生编码
		        drug.DoctorName =session['LOGON.USERNAME'];     //开嘱医生姓名
				drug.RecipNo = "";            //处方号
		        drug.Num = "";                //药品开出数量
		        drug.NumUnit = "";            //药品开出数量单位          
		        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
		        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
				drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
				drug.Remark = "";             //医嘱备注 
				drug.driprate = ""; //滴速(120滴/分钟)
				drug.driptime = ""; //滴时间(滴100分钟
				arrayDrug[arrayDrug.length] = drug;
		    
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
			var arrayAllergen = new Array();
			var pai;
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		        
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //序号  
		      	allergen.AllerCode = AllergenArr[0];    //编码
		      	allergen.AllerName = AllergenArr[1];    //名称  
		      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//病生状态类数组
			 var arrayMedCond = new Array();
			var pmi;
		  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		       
		      	var medcond;       
		      	medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i	;              			//诊断序号
		     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
		      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
		 		medcond.RecipNo = "";              //处方号
		      	arrayMedCond[arrayMedCond.length] = medcond;     
		      
			}
			McMedCondArray = arrayMedCond;
			
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
		},
		HisQueryDataById:function (Row){
			var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
			var OrderARCIMCode=mPiece(OrderHiddenPara,String.fromCharCode(1),7);
			var OrderName=GetCellData(Row,"OrderName");
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode; //药品编号
		    drug.CodeName = OrderName;       //药品名称
		    MC_global_queryDrug = drug;	
		}
	},
	DTCSFuncs:{
		//大通 说明书
		DTYDTS:function (Para, ShowType) {
		    var itemid = Para;
		    var myDTYDTSXML = cspRunServerMethod(GlobalObj.GetDTYDTS, itemid);
		    this.dtywzxUI(12, 0, myDTYDTSXML);
		    return;
		},
		///医嘱录入合理用药审查
		DaTongXHZYHander:function () {
		    var Orders = "";
		    var Para1 = "";
		    var myrtn = 0;
		    var rowids = $('#Order_DataGrid').getDataIDs();
		    for (var i = 0; i < rowids.length; i++) {
		        //过滤已审核
		        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
		        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		        if (OrderItemRowid != "" || OrderARCIMRowid == "") { continue; }

		        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
		        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		        var OrderType = GetCellData(rowids[i], "OrderType");
		        var OrderDurRowid = GetCellData(rowids[i], "OrderDurRowid");
		        var OrderFreqRowid = GetCellData(rowids[i], "OrderFreqRowid");
		        var OrderInstrRowid = GetCellData(rowids[i], "OrderInstrRowid");
		        var OrderDoseQty = GetCellData(rowids[i], "OrderDoseQty");
		        var OrderDoseUOMRowid = GetCellData(rowids[i], "OrderDoseUOMRowid");
		        var OrderDrugFormRowid = GetCellData(rowids[i], "OrderDrugFormRowid");
		        var OrderPHPrescType = GetCellData(rowids[i], "OrderPHPrescType")
		        var OrderStartDate = GetCellData(rowids[i], "OrderStartDate")
		        var OrderStartTime = GetCellData(rowids[i], "OrderStartTime")
		        var OrderPriorRowid = GetCellData(rowids[i], "OrderPriorRowid");
		        //传组号
		        var MasterSeqNo = "";
		        var OrderSeqNo = GetCellData(rowids[i], "id");
		        var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
		        if (OrderMasterSeqNo != "") MasterSeqNo = OrderMasterSeqNo;
		        //判断是否处理草药
		        //if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

		        Para1 = OrderARCIMRowid + "!" + OrderDoseQty + "!" + OrderDoseUOMRowid;
		        Para1 = Para1 + "!" + OrderFreqRowid + "!" + OrderDurRowid + "!" + OrderInstrRowid + "!" + OrderDrugFormRowid + "!" + MasterSeqNo + "!" + OrderPriorRowid + "!" + OrderStartDate + "!" + OrderStartTime;
		        if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderType == "R")) {
		            if (Orders == "") { Orders = Para1 } else { Orders = Orders + "^" + Para1 }
		        }
		    }
		    var EpisodeID = GlobalObj.EpisodeID;
		    if (EpisodeID != "") {
		        //var UploadFlag="0";   
		        var DocCode = session['LOGON.USERCODE'];
		        var UserID = session['LOGON.USERID'];
		        //web.DHCandDaTongInterface.GetPrescXML 
		        var myPrescXML = cspRunServerMethod(GlobalObj.GetPrescXML, Orders, EpisodeID, DocCode, UserID);
		        if (GlobalObj.PAAdmType == "I") {
		            myrtn = this.dtywzxUI(28676, 1, myPrescXML);
		        } else {
		            myrtn = this.dtywzxUI(4, 0, myPrescXML);
		        }

		    }
		    return myrtn;
		},
		///中药草大通合理用药审查
		DaTongXHZYHanderCM:function (){
			var Orders = "";
		    var Para1 = "";
		    var myrtn = 0;
		    var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			
			var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime",PageLogicObj.defaultDataCache, "1");
		    var CurrDateTimeArr = CurrDateTime.split("^");
		    var CurrDate = CurrDateTimeArr[0];
		    var CurrTime = CurrDateTimeArr[1];
			
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
				   if (OrderARCIMRowid!=""){
					    var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
						var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
						var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
						OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
						
						var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
						var OrderDrugFormRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2);
						var PHCDoseUOMDesc = mPiece(OrderHiddenPara, String.fromCharCode(3), 9);
		                var PHCDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
						var MasterSeqNo="";
						if (Orders!=""){
							var MasterSeqNo=1;
						}
						Para1 = OrderARCIMRowid + "!" + OrderDoseQty + "!" + PHCDoseUOMRowid;
				        Para1 = Para1 + "!" + PrescFrequenceRowid + "!" + PrescDurationRowid + "!" + PrescInstructionID + "!" + OrderDrugFormRowid + "!" + MasterSeqNo + "!" + OrderPriorRowid + "!" + CurrDate + "!" + CurrTime;
				        if (Orders == "") { Orders = Para1 } else { Orders = Orders + "^" + Para1 }
				   }
			    }
			}
		    var EpisodeID = GlobalObj.EpisodeID;
		    if (EpisodeID != "") {
		        //var UploadFlag="0";   
		        var DocCode = session['LOGON.USERCODE'];
		        var UserID = session['LOGON.USERID'];
		        //web.DHCandDaTongInterface.GetPrescXML 
		        var myPrescXML = cspRunServerMethod(GlobalObj.GetPrescXML, Orders, EpisodeID, DocCode, UserID);
		        if (GlobalObj.PAAdmType == "I") {
		            myrtn = this.dtywzxUI(28676, 1, myPrescXML);
		        } else {
		            myrtn = this.dtywzxUI(4, 0, myPrescXML);
		        }

		    }
		    return myrtn;
		},
		//大通调用公共方法
		dtywzxUI:function (nCode, lParam, sXML) {
		    var result = "";
		    try {
				result = CaesarComponent.dtywzxUI(nCode, lParam, sXML);
			}catch(e){
				$.messager.alert("警告","调用大通合理用药接口失败;失败位置:DHCDocHLYYDT.js下PassFuncs.DTCSFuncs.dtywzxUI"); 
			}
		    return result;
		   
		}
	}
}

///大通相互作用保存到大通服务器
function DaTongXHZYSave(){
	if (GlobalObj.DTDepNotDoUpLoad==1) return 0; 
	var Orders="";
	var Para1="";
	var myrtn=0;
	var rowids=$('#Order_DataGrid').getDataIDs();
	for(var i=0;i<rowids.length;i++){
		//过滤已审核
		var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
		var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
		if(OrderItemRowid != "" || OrderARCIMRowid == ""){continue;}

		var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
		var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
		var OrderType=GetCellData(rowids[i],"OrderType");
		var OrderDurRowid=GetCellData(rowids[i],"OrderDurRowid");
		var OrderFreqRowid=GetCellData(rowids[i],"OrderFreqRowid");
		var OrderInstrRowid=GetCellData(rowids[i],"OrderInstrRowid");
		var OrderDoseQty=GetCellData(rowids[i],"OrderDoseQty");
		var OrderDoseUOMRowid=GetCellData(rowids[i],"OrderDoseUOMRowid");
		var OrderDrugFormRowid=GetCellData(rowids[i],"OrderDrugFormRowid");
		var OrderPHPrescType=GetCellData(rowids[i],"OrderPHPrescType")
		var OrderStartDate=GetCellData(rowids[i],"OrderStartDate")
		var OrderStartTime=GetCellData(rowids[i],"OrderStartTime")
		var OrderPriorRowid=GetCellData(rowids[i],"OrderPriorRowid");
		//传组号
    	var MasterSeqNo="";
    	var OrderSeqNo=GetCellData(rowids[i],"id");
    	var OrderMasterSeqNo=GetCellData(rowids[i],"OrderMasterSeqNo");
    	if(OrderMasterSeqNo!="")MasterSeqNo=OrderMasterSeqNo;		
		//判断是否处理草药
		//if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

		Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
		Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime;
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
	var EpisodeID=GlobalObj.EpisodeID;
	if ((EpisodeID!="")){	
		var DocCode=session['LOGON.USERCODE'];
		var UserID=session['LOGON.USERID'];

		var myPrescXML=cspRunServerMethod(GlobalObj.GetPrescXML,Orders,EpisodeID,DocCode,UserID);
		if (GlobalObj.PAAdmType=="I"){
			myrtn=PassFuncs.DTCSFuncs.dtywzxUI(28685,1,myPrescXML);
		}else{
			myrtn=PassFuncs.DTCSFuncs.dtywzxUI(13,0,myPrescXML);
		}
	}
	return myrtn;
}



