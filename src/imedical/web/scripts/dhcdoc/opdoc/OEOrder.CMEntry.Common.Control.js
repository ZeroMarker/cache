/*
Creater：jm
CreateDate：2023-02-14
FileName：OEOrder.CMEntry.Common.Control.js
Description：对于涉及医嘱插入后或前的前端接口，考虑统一封装一层js，独立出对外方法+内部方法
* 封装方法,统一管理第三方接口调用,参照医生站配置->外部接口测试->对外接口接入管理下的关联开启数据

调用说明:
	● InterfaceArr：第三方接口对象，此数组会在加载各接口层JS的时候填充
		接口层示例：Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	● Init：界面初始化，只加载一次
		外层调用方式：Common_ControlObj.Init();
	● xhrRefresh：患者切换初始化
		外层调用方式：Common_ControlObj.xhrRefresh(argObj);
	● BeforeUpdate：医嘱录入审核前调用
		外层调用方式：Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的BeforeUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● BeforeUpdateFuncs：医嘱录入审核前的验证
		内部调用
		CASignCheck			CA验证接口
		Interface			第三方接口（合理用药、国家医保相关）
	● AfterUpdate：医嘱录入审核后调用
		外层调用方式：Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的AfterUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● AfterUpdateFuncs：医嘱录入审核后的方法调用
		内部调用
		SynData				数据同步接口（包含医嘱CA认证保存，CDSS医嘱同步、置到达等）
		Interface			第三方接口（合理用药、国家医保相关）
		OpenSelectDia		处方关联诊断接口
		SaveOrderToEMR		同步医嘱数据至电子病历
	● Interface：其他业务调用，比如相互作用、说明书等
		外层调用方式：Common_ControlObj.Interface("XHZY",argObj);
		外层调用方式：Common_ControlObj.Interface("YDTS",argObj);	
	● UtilFuns：工具类
		内部调用
		ReturnErrData		进行错误信息的提示，并根据提示进行回调是继续审核还是取消审核
		ReturnData			对象返回值(CA验证接口){PassFlag:boolean,Obj:obj}
		AnalysisArg			解析方法入参变量名,并从传入数据中获取到匹配的数据
							入参：回调函数,对象格式业务数据,方法体；出参：按照方法体入参顺序组织的数组				
		AlertErrData		仅进行错误信息的提示

依赖的js(若需要使用对应封装的接口方法)：
	1、CA验证：scripts/dhcdoc/DHCDoc.CASign.js
*/
//接口函数封装
var Common_ControlObj=(function(){
	//接口方法,此数组会在加载各接口层JS的时候填充
	var InterfaceArr=new Array();
	//全局初始化
	function Init(){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.CMOEOrd=="object")&&(typeof obj.CMOEOrd.Init=="function")) {
				obj.CMOEOrd.Init();
			}
		});
	};
	//局部初始化
	function xhrRefresh(argObj){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.CMOEOrd=="object")&&(typeof obj.CMOEOrd.xhrRefresh=="function")) {
				var funcName=obj.CMOEOrd.xhrRefresh.toString();
				var argList=UtilFuns.AnalysisArg("",argObj,funcName)
				if (argList.length==0) {
					obj.CMOEOrd.xhrRefresh();
				}else{
					obj.CMOEOrd.xhrRefresh.apply(null,argList);
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
				callType:调用类型
				isHeaderMenuOpen:是否在头菜单打开签名窗口. 默认true
			}*/
			var iArgObj={
				callType:"OrderSave",
				isHeaderMenuOpen:true	
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
								if ((typeof obj == "object")&&(typeof obj.CMOEOrd == "object")&&(typeof obj.CMOEOrd.BeforeUpdate == "function")) {
									var funcName=obj.CMOEOrd.BeforeUpdate.toString();
									$.extend(argObj, { CallBackFunc: resolve});
									var argList=UtilFuns.AnalysisArg("",argObj,funcName)
									if (argList.length==0) {
										obj.CMOEOrd.BeforeUpdate()
									}else{
										obj.CMOEOrd.BeforeUpdate.apply(null,argList);
									}
								}else{
									resolve(true);
								}
							}).then(function (ret) {
								return new Promise(function (resolve, rejected) {
									if (ret==false || ret.SuccessFlag==false) {
										callBackFun(ret)
								        return false;
									}
									//各个接口如果存在返回值需处理,建议以对象方式返回
									if(typeof(ret)=="object"){
										$.extend(ReturnObj, ret);
										$.extend(argObj, ret); //前一个接口可能存在更新初始入参的情况（比如医嘱串），下一个接口需用使用更新后的医嘱串	
									}
									resolve();
								})
							}).then(function () {
								j++;
								if (j < that.InterfaceArr.length) {
									loop(j);
								} else {
									callBackFunExec();
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
			if (argObj.caIsPass==1) CASignObj.SaveCASign(argObj.CAObj, argObj.OEOrdItemIDs, "A");
		},
		Interface:function(argObj,callBackFun){	//对外接口
			$.each(this.InterfaceArr,function(i,obj){
				if ((typeof obj == "object")&&(typeof obj.CMOEOrd == "object")&&(typeof obj.CMOEOrd.AfterUpdate == "function")) {
					var funcName=obj.CMOEOrd.AfterUpdate.toString();
					var argList=UtilFuns.AnalysisArg("",argObj,funcName)
					if (argList.length==0) {
						obj.CMOEOrd.AfterUpdate();
					}else{
						obj.CMOEOrd.AfterUpdate.apply(null,argList);
					}
				}
			});
		},
		OpenSelectDia:function(argObj){ //处方关联诊断
			var EpisodeID=argObj.EpisodeID;
			var OEOrdItemIDs=argObj.OEOrdItemIDs;
			var precnum=tkMakeServerCall("web.DHCDocDiagLinkToPrse","getAllCheckDiaPrce",EpisodeID,session['LOGON.USERID'],OEOrdItemIDs) 
		  	if (precnum!=""){
				//若诊断数量为1,则直接进行诊断与处方关联
				var GridData=$.cm({
					ClassName:"web.DHCDocDiagLinkToPrse",
					QueryName:"GetDiaQuery",
					Adm:EpisodeID,
					Type:"ALL",
					rows:99999
				},false);
				var total=GridData['total'];
				if (total==1){
					var rtn=$.cm({
						ClassName:"web.DHCDocDiagLinkToPrse",
						MethodName:"Insert",
						dataType:"text",
						PrescNoStr:precnum,
						DiagIdStr:GridData['rows'][0]['diaid'],
						UserDr:session['LOGON.USERID'],
					},false);
				}else{
					if (total==0) return;
					var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+precnum; //+"&ExitFlag="+"Y"
					var awidth="90%"; //screen.availWidth/6*5; 
					var aheight=screen.availHeight/5*4; 
					websys_showModal({
						url:url,
						title:$g('处方关联诊断'),
						iconCls:'icon-w-list',
						width:awidth,height:aheight
					})	
				}
			}
		},
		SaveOrderToEMR:function(argObj){ //同步医嘱数据至电子病历
			if (argObj.PAAdmType == "I") {
		        return true;
		    }
		    var EpisodeID=argObj.EpisodeID;
		    var OrdList = tkMakeServerCall("EMRservice.BL.opInterface", "getOeordXH", EpisodeID, "CHMED")
			if ((typeof(parent.invokeChartFun) === 'function')||(typeof(parent.parent.invokeChartFun) === 'function')) {
			    if (typeof(parent.invokeChartFun) === 'function'){
				    parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "oeordCN", OrdList, "", EpisodeID);
				}else{
					parent.parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "oeordCN", OrdList, "", EpisodeID);
				}
			}
		    return OrdList
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
			UtilFuns.ReturnErrData("对外接口"+func+"异常:"+e.message,callBackFun)
		}
	};
	var UtilFuns={
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
