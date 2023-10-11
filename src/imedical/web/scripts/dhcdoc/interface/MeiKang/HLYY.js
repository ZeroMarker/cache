/*
Creater:	jm
CreateDate：2023-01-30
Description:美康合理用药统一封装JS
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var McRecipeDataList="";
	var MKHLYYObj = {
		Name:"MeiKang_HLYY",
		//医嘱录入
		OEOrd:{
			//初始化
			Init:function() {
				PassFuncs.PASSIM_INIT();
			},
			//审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			}
		},
		//中草药录入
		CMOEOrd:{
			//初始化
			Init:function() {
				PassFuncs.PASSIM_INIT();
			},
			//审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			}
		},
		Funcs:{
			//相互作用(仅在点击相互作用按钮时弹出)
			XHZY:function(EpisodeID) {
				var e = window.event || e;
				if (!e) return;
				if (!e.currentTarget) return;
				if (e.currentTarget.id!="XHZY") return;
				PassFuncs.XHZY(EpisodeID);
			},
			//说明书
			YDTS:function(ARCIMRowid) {
				try{
					PassFuncs.YDTS(ARCIMRowid);
				}catch(e){
					$.messager.alert("警告","美康合理用药说明书异常:"+e.message,"error");
				}	
			},
			//右键弹出
			RightClick:function(rowid) {
				try{
				PassFuncs.RightClick(rowid);
				}catch(e){
					$.messager.alert("警告","美康合理用药右键异常:"+e.message);
				}
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	//
	var PassFuncs={
		//初始化美康通讯工具
		PASSIM_INIT:function(){
			if (typeof Params_MC_PASSIM_In !="undefined"){
				var im=new Params_MC_PASSIM_In()
				im.hiscode="0"
				im.doctor=session['LOGON.USERCODE'];
				im.Init()
			}
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			//美康现在只支持异步调用了
			new Promise(function (resolve, rejected) {
				try{
					PassFuncs.MKXHZYNoView(resolve,EpisodeID,OrderItemStr,HLYYLayOut);
				}catch(e){
					$.messager.alert("提示", "合理用药自动验证通过:"+e.message, "info",function(){
						resolve(true);
					});
				}
			}).then(function (Para) {
				if (Para===true){
					CallBackFunc(true);
					return;
				}
				//https无法引用美康JS,直接返回
				if (typeof MDC_GetSysPrStatus!="function") {
					CallBackFunc(true);
					return;
				}
				//Para: 4-关注（黄灯）3-慎用（橙灯）2-严重（红灯） 1-禁忌（黑灯）0-没问题（蓝灯）
				//is_pass: 1 通过，0 未通过 -1 待定(未走完流程) 
				var is_pass = MDC_GetSysPrStatus('', '');
				if ((null == is_pass) || (undefined == is_pass)){
					$.messager.alert("提示", "合理用药自动通过验证", "info",function(){
						CallBackFunc(true);
					});
				}else if ((0 == is_pass) || (-1 == is_pass)){
					CallBackFunc(false);
				}else if (1 == is_pass){		//药师审方通过
					if (parseInt(Para)==1){
						CallBackFunc(false);
					}else if(parseInt(Para)>1){		//有警示信息提醒医生是否保存
						$.messager.confirm('确认对话框',"合理用药审查发现问题，是否继续保存医嘱？", function(r){
							if (r) {CallBackFunc(true)}else{CallBackFunc(false);}
						});
					}else{
						CallBackFunc(true);
					}
				}else{
					CallBackFunc(true);
				}
			})
		},
		//审核医嘱(合并医嘱录入/中草药录入,后台拆分数据)
		MKXHZYNoView:function (callBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			this.MCInit();
			this.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);
			if (McRecipeDataList=="") {
				callBackFunc(true);
				return false;
			}
			MDC_DoCheck(callBackFunc,1);
		},
		//相互作用
		XHZY:function (EpisodeID){
			new Promise(function(resolve,rejected){
				GetOrderDataOnAdd(resolve);
			}).then(function(OrderItemStr){
				if (OrderItemStr=="") {
					$.messager.alert("提示","没有新开医嘱");
					return false;
				}
				var HLYYLayOut=GlobalObj.HLYYLayOut;
	    		PassFuncs.MKXHZY(EpisodeID,OrderItemStr,HLYYLayOut);
			})
		},
		//相互作用
		MKXHZY:function (EpisodeID,OrderItemStr,HLYYLayOut){
			this.MCInit();
			this.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);
			if (McRecipeDataList=="") return false;
			MDC_DoCheck("",1);
		},
		YDTS:function (ARCIMRowid){
			if ((typeof ARCIMRowid=="undefined")||(ARCIMRowid==null)||(ARCIMRowid=="")) {
				$.messager.alert("警告","请选择一条医嘱");  
				return;  
			}
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",ARCIMRowid);
			var ArcimInfoAry=ArcimInfo.split("^");
			var OrderARCIMCode=ArcimInfoAry[0];
			var OrderName=ArcimInfoAry[1];
			var RefCode=51;
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				RefCode=11;
			}else if (GlobalObj.HLYYLayOut=="CMOEOrd"){
				RefCode=24;
			}
			PassFuncs.MKYDTS(OrderARCIMCode,OrderName,RefCode);
		},
		//说明书(11-药品说明书,51-重要信息(浮动窗口),24-中药材专论)
		MKYDTS:function(OrderARCIMCode,OrderName,RefCode){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(RefCode);
		},
		MCInit:function(){
			var pass = new Params_MC_PASSclient_In();
			pass.HospID = session['LOGON.HOSPID'];  
			pass.UserID =session['LOGON.USERCODE'];
			pass.UserName = session['LOGON.USERNAME'];
			pass.DeptID = GlobalObj.LogLocCode;
			pass.DeptName = GlobalObj.LogLocDesc;
			pass.CheckMode =(GlobalObj.PAAdmType=="I"?"zy":"mz");
			MCPASSclient = pass;
		},
		HisScreenData:function (EpisodeID,OrderItemStr,HLYYLayOut){
			McRecipeDataList="";
			//用户id^科室id^院区id^系统模式(用于区分互联网医院,前台录入可为空)
			var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+"";
			var PrescJSON=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,OrderItemStr,HLYYLayOut,ExpStr);
			var PrescObj=$.parseJSON(PrescJSON);
			//console.log(PrescJSON)
			if (PrescObj.ResultCode=="-1") {
				$.messager.alert("提示",PrescObj.ResultContent);
				return;
			}
			//传入病人基本信息
			MCpatientInfo = PrescObj.Patient;
			//传入病人过敏信息
			McAllergenArray = PrescObj.ScreenAllergenList.ScreenAllergens;
			//传入病人诊断信息
			McMedCondArray = PrescObj.ScreenMedCondList.ScreenMedConds;
			//传入病人手术信息
			McOperationArray = new Array();
			//传入病人药品信息
			McDrugsArray = PrescObj.ScreenDrugList.ScreenDrugs;
			McRecipeDataList = PrescObj.ScreenDrugList.ScreenDrugs;
			//传入病人检验信息
			McLabArray = PrescObj.ScreenLabList.ScreenLabs;
			//传入病人检查信息
			McExamArray = PrescObj.ScreenExamList.ScreenExams;
		},
		HisQueryData:function (OrderARCIMCode,OrderName) {
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode;	//药品编号
		    drug.CodeName = OrderName;				//药品名称
		    MC_global_queryDrug = drug;
		},
		RightClick:function (rowid){
			if (GlobalObj.HLYYLayOut!="OEOrd") return;
			var OrderType=GetCellData(rowid,"OrderType");
			if (OrderType!="R") return;
			var OrderARCIMRowid=GetCellData(rowid,"OrderARCIMRowid");
			if (OrderARCIMRowid=="") return;
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
			var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
			var OrderName=mPiece(ArcimInfo,"^",1);
			//
			PassFuncs.MCInit();
			PassFuncs.HisQueryData(OrderARCIMCode,OrderName);
			McPASS.McRightMenu();
			//
			var rowids=GetAllRowId();
			for(var i=0;i<rowids.length;i++){
				if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")=="checked"){
					$("#Order_DataGrid").setSelection(rowids[i],false);
				}				
			}
			if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")!="checked"){
				$("#Order_DataGrid").setSelection(rowid,true);
			}
		}
	}
})
