/*
Creater：	jm
CreateDate：2023-02-28
FileName：	scripts/dhcdoc/DiagnosEntry.Common.Control
Description：对于涉及诊断插入前后的前端接口，考虑统一封装一层js（用独立的js）
* 封装方法,统一管理第三方接口调用,参照医生站配置->外部接口测试->对外接口接入管理下的关联开启数据

调用说明:
	● InterfaceArr：第三方接口对象，此数组会在加载各接口层JS的时候填充
		接口层示例：Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	● Init：界面初始化，只加载一次
		外层调用方式：Common_ControlObj.Init();
	● xhrRefresh：患者切换初始化
		外层调用方式：Common_ControlObj.xhrRefresh(argObj);
	● BeforeUpdate：诊断插入前调用
		外层调用方式：Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的BeforeUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● BeforeUpdateFuncs：诊断插入前的验证
		内部调用
		CASignCheck				CA验证接口
		Interface				第三方接口
		CDSSCheck				CDSS事前预警接口
		CheckReportBeforeInsert	调用医政组接口判断诊断报告
	● AfterUpdate：诊断插入后调用
		外层调用方式：Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的AfterUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● AfterUpdateFuncs：诊断插入后的方法调用
		内部调用
		SynData					数据同步接口(包含CA认证保存,CDSS医嘱同步等)
		ShowCPW					入径检查接口
		SaveMRDiagnosToEMR		同步诊断数据至电子病历
		Interface				第三方接口
	● Interface：其他业务调用
		外层调用方式：Common_ControlObj.Interface("DrgsRefresh",argObj);
	● UtilFuns：工具类
		内部调用
		FormatOrderStr		格式化医嘱审核的医嘱信息串(目前暂未处理)
		ReturnErrData		进行错误信息的提示，并根据提示进行回调是继续审核还是取消审核(合理用药、CDSS、临床路径检查)
		ReturnData			对象返回值(CA验证接口){PassFlag:boolean,Obj:obj}
		AnalysisArg			解析方法入参变量名,并从传入数据中获取到匹配的数据
							入参：回调函数,对象格式业务数据,方法体；出参：按照方法体入参顺序组织的数组				
		AlertErrData		仅进行错误信息的提示
*/
//接口函数封装
var Common_ControlObj=(function(){
	//接口方法,此数组会在加载各接口层JS的时候填充
	var InterfaceArr=new Array();
	//全局初始化
	function Init(){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.Diag=="object")&&(typeof obj.Diag.Init=="function")) {
				obj.Diag.Init();
			}
		});
	};
	//局部初始化
	function xhrRefresh(argObj){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.Diag=="object")&&(typeof obj.Diag.xhrRefresh=="function")) {
				var funcName=obj.Diag.xhrRefresh.toString();
				var argList=UtilFuns.AnalysisArg("",argObj,funcName)
				if (argList.length==0) {
					obj.Diag.xhrRefresh();
				}else{
					obj.Diag.xhrRefresh.apply(null,argList);
				}
			}
		});
	};
	//医嘱录入-审核前
	function BeforeUpdate(f){
		var DoFunName=eval("("+"BeforeUpdateFuncs."+f+")");
		var thisCallBack="";
		var argAry=[];
		for(var i=1;i < arguments.length; i++){
			if(typeof arguments[i] == 'function'){
				thisCallBack=arguments[i];
			}
			argAry.push(arguments[i]);
		}
		if(typeof DoFunName == "undefined"){
			for(key in this){
				if(typeof this[key]	=="object"){
					DoFunName=eval("("+"this[key]."+f+")");	
					if(typeof DoFunName != "undefined"){
						break;
					}
				}
			}
		}
		if(typeof DoFunName == "undefined"){
			return UtilFuns.ReturnErrData("接口方法"+f+"不存在.",thisCallBack);
		}
		return DoFunName.apply(this,argAry);	
	};
	var BeforeUpdateFuncs={
		//CA验证
		CASignCheck:function(argObj,callBackFun) {
			/*argObj={
				callType:调用类型,
				isHeaderMenuOpen:是否在头菜单打开签名窗口. 默认true
			}*/
			var iArgObj={
				callType:"DiagSave",
				isHeaderMenuOpen:false	
			}
			$.extend(iArgObj,argObj)
		    new Promise(function(resolve,rejected){
			    var CAObj = {
					"caIsPass": "0"
				}
				if(typeof CASignObj != "undefined"){
					CASignObj.CASignLogin(resolve,iArgObj.callType,iArgObj.isHeaderMenuOpen);
				}else{
					resolve(CAObj);	
				}
			}).then(function(CAObj){
				var myArgObj={};
		    	if (CAObj == false) {
			    	myArgObj = {
				    	PassFlag:false
			    	}
		    	}else{
		    		myArgObj = {
			    		PassFlag:true,
			    		CAObj:CAObj
		    		};
		    	}
		    	return UtilFuns.ReturnData(myArgObj,callBackFun);
			})
		},
		//对外接口
		Interface:function(argObj,callBackFun) {
			var that=this;
			try {
				var ReturnObj={SuccessFlag:true};
				new Promise(function (resolve, rejected) {
					(function (callBackFunExec) {
						function loop(j) {
							new Promise(function (resolve, rejected) {
								var obj=that.InterfaceArr[j];
								if ((typeof obj == "object")&&(typeof obj.Diag == "object")&&(typeof obj.Diag.BeforeUpdate == "function")) {
									var funcName=obj.Diag.BeforeUpdate.toString();
									$.extend(argObj, { CallBackFunc: resolve});
									var argList=UtilFuns.AnalysisArg("",argObj,funcName)
									if (argList.length==0) {
										obj.Diag.BeforeUpdate()
									}else{
										obj.Diag.BeforeUpdate.apply(null,argList);
									}
								}else{
									resolve(true);
								}
							}).then(function (ret) {
								return new Promise(function (resolve, rejected) {
									if (ret==false || ret.SuccessFlag==false) {
										callBackFun(ret); //方法调用时传入的callBackFun回调方法
								        return false;
									}
									//各个接口如果存在返回值需处理,建议以对象方式返回
									if(typeof(ret)=="object"){
										$.extend(ReturnObj, ret);	
									}
									resolve();
								})
							}).then(function () {
								j++;
								if (j < that.InterfaceArr.length) {
									loop(j);
								} else {
									callBackFunExec();//loop循环调用时传入的resolve方法
								}
							})
						}
						loop(0)
					})(resolve);
				}).then(function () {
					callBackFun(ReturnObj);
				})
			} catch (e) {
				UtilFuns.ReturnErrData("审核前接口异常:"+e.message,callBackFun)
			}
		},
		CDSSCheck:function(argObj,callBackFun) {//CDSS事前预警
			/*argObj={
				EpisodeID:就诊ID,
				DiagItemStr:诊断信息串
			}*/
			try{
				if (typeof CDSSObj=='object'){	
					CDSSObj.CheckDiagnos(argObj.EpisodeID,argObj.DiagItemStr,callBackFun);
				}else{
					callBackFun(true);	
				}
			}catch(e){
				UtilFuns.ReturnErrData("CDSS事前预警接口调用异常:"+e.message,callBackFun);
			}
		},
		CheckReportBeforeInsert:function(argObj,callBackFun) {	//调用医政组接口判断诊断报告
			/*argObj={
				EpisodeID:就诊ID,
				DiagItemStr:诊断信息串
			}*/
			try{
				if (typeof CheckReportBeforeInsert=='function'){
					CheckReportBeforeInsert(argObj.DiagItemStr,callBackFun);
				}else{
					callBackFun(argObj.DiagItemStr);	
				}
			}catch(e){
				UtilFuns.ReturnErrData("传染病报卡接口调用异常:"+e.message,callBackFun);
			}
		}
	};
	//医嘱录入-审核后
	function AfterUpdate(f){
		var DoFunName=eval("("+"AfterUpdateFuncs."+f+")");
		var thisCallBack="";
		var argAry=[];
		for(var i=1;i < arguments.length; i++){
			if(typeof arguments[i] == 'function'){
				thisCallBack=arguments[i];
			}
			argAry.push(arguments[i]);
		}
		if(typeof DoFunName == "undefined"){
			return UtilFuns.AlertErrData("审核后接口方法:"+f+"不存在。",thisCallBack);
		}
		return DoFunName.apply(this,argAry);	
	};
	var AfterUpdateFuncs={
		SynData:function(argObj) {	//数据同步
			var DiagItemIDs=argObj.DiagItemIDs;
			var CACallType=argObj.CACallType;
			//
			if (argObj.caIsPass==1) CASignObj.SaveCASign(argObj.CAObj, DiagItemIDs, CACallType);
			if (typeof CDSSObj=='object') CDSSObj.SynDiagnos(argObj.EpisodeID, DiagItemIDs);
		},
		ShowCPW:function(argObj) {	//入径检查
			var MRDiagnosCount=0;
			var DiagItemIDs=argObj.DiagItemIDs;
			for (var i=0;i<DiagItemIDs.split('^').length;i++){
				var MRDiagnosRowid=DiagItemIDs.split('^')[i].split(String.fromCharCode(1))[0];
				var MRCICDRowid=DiagItemIDs.split('^')[i].split(String.fromCharCode(1))[1];
				if (MRDiagnosRowid=="") continue;
				MRDiagnosCount=MRDiagnosCount+1;
			}
			if (MRDiagnosCount>0) {
				ShowCPW(argObj.EpisodeID,argObj.PAAdmType);
			}
		},
		SaveMRDiagnosToEMR:function(argObj){	//同步诊断数据至电子病历
			var PAAdmType=argObj.PAAdmType;
			var EpisodeID=argObj.EpisodeID;
			//
			if (PAAdmType == "I") {
		        return true;
		    }
		    var ret=tkMakeServerCall("EMRservice.BL.opInterface","getDiagDataXH",EpisodeID,"@","");
			try {
				var opts=websys_showModal('options');
				if (opts&&opts.invokeChartFun){
					if (PAAdmType!="E"){
						opts.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
					}else{
						opts.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
					}
				}else if ((typeof(parent.invokeChartFun) === 'function')||((window.dialogArguments)&&(window.dialogArguments.parent)&&(typeof(window.dialogArguments.parent.parent.invokeChartFun) === 'function'))) {
					if (typeof(parent.invokeChartFun) === 'function'){
						if (PAAdmType!="E"){
							parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}else{
							parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}
					}else{
						if(PAAdmType!="E"){
							window.dialogArguments.parent.parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}else{
							window.dialogArguments.parent.parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}
					}
				}
			}catch(e) {
				return false;
			}
		},
		Interface:function(argObj,callBackFun){	//对外接口
			$.each(this.InterfaceArr,function(i,obj){
				if ((typeof obj == "object")&&(typeof obj.Diag == "object")&&(typeof obj.Diag.AfterUpdate == "function")) {
					var funcName=obj.Diag.AfterUpdate.toString();
					var argList=UtilFuns.AnalysisArg("",argObj,funcName)
					if (argList.length==0) {
						obj.Diag.AfterUpdate();
					}else{
						obj.Diag.AfterUpdate.apply(null,argList);
					}
				}
			});
		}
	};
	//统一其它接口调用,比如相互作用,说明书等
	function Interface(func,argObj,callBackFun){
		try {
	    	$.each(this.InterfaceArr,function(i,obj){
				if ((typeof obj == "object")&&(typeof obj.Funcs == "object")&&(typeof obj.Funcs[func] == "function")) {
					var funcName=obj.Funcs[func].toString();
					var argList=UtilFuns.AnalysisArg("",argObj,funcName)
					if (argList.length==0) {
						obj.Funcs[func]();
					}else{
						obj.Funcs[func].apply(null,argList);
					}
				}
			})
		} catch (e) {
			UtilFuns.AlertErrData("对外接口-"+func+"异常:"+e.message,callBackFun)
		}
	};
	var UtilFuns={
		FormatOrderStr:function(argObj){
			//格式化医嘱审核的医嘱信息串
			//目前暂未处理
			/*argObj{
				DataType:需要的数据类型	
				OrderItemStr:初始的医嘱信息串
			}*/
			var FormatOrderData="";
			var DataType=argObj.DataType;
			var OrderItemStr=argObj.OrderItemStr;
			FormatOrderData=OrderItemStr;
			return FormatOrderData;
		},
		ReturnErrData:function(ErrMsg,callBackFun){
			$.messager.confirm('确认对话框', ErrMsg+"<br/>请联系信息科!若确认审核医嘱请点击【确定】", function(r){
				if(typeof callBackFun == 'function'){
					callBackFun(r);
				}else{
					return r;	
				}
			})
		},
		AlertErrData:function(ErrMsg,callBackFun){
			$.messager.alert('警告', ErrMsg+"<br/>请联系信息科!", "info", function(){
				if(typeof callBackFun == 'function'){
					callBackFun(false);
				}else{
					return false;	
				}
			});
		},
		ReturnData:function(argObj,callBackFun){
			var ReturnObj={
				PassFlag:true
			}
			$.extend(ReturnObj, argObj);
			if(typeof callBackFun=="function"){
		    	callBackFun(ReturnObj);
	    	}
	    	return ReturnObj;
		},
		AnalysisArg:function(callBackFun,dataObj,funcName) {
			var argList=[];
			var argStr=funcName.split(")")[0].split("(")[1];
			if (argStr!="") {
				var argArr=argStr.split(",");
				$.each(argArr, function(i,argName){
					var argValue=dataObj[argName];
					if (typeof argValue == "undefined") argValue="";
					argList.push(argValue);
				});
			}
			if(typeof callBackFun == 'function'){
				callBackFun(argList);
			}else{
				return argList;	
			}
		},
		///加载Promise所需文件
		LoadJS:function (){
			$("script").each(function(i,e){
				if(e.src.indexOf("bluebird.min.js")>=0){
					var bluebirdFlag=true;
				}
			});
			if(!bluebirdFlag){
				if (websys_isIE==true) {
					 var script = document.createElement('script');
					 script.type = 'text/javaScript';
					 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
					 document.getElementsByTagName('head')[0].appendChild(script);
				}
			}
		}
	};
	return {
		"Init":Init,
		"xhrRefresh":xhrRefresh,
		"BeforeUpdate":BeforeUpdate,
		"AfterUpdate":AfterUpdate,
		"Interface":Interface,
		"InterfaceArr":InterfaceArr
	};
})()
