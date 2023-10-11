/*
Creater：	jm
CreateDate：2022-02-10
FileName：	Reg.Common.Control.js
Description：对于涉及挂号前或后的前端接口，统一封装独立的JS
* 管理第三方接口调用,参照医生站配置->外部接口测试->对外接口接入管理下的关联开启数据

调用说明:
	● InterfaceArr：第三方接口对象，此数组会在加载各接口层JS的时候填充
		接口层示例：Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	● Init：界面初始化，只加载一次
		外层调用方式：Common_ControlObj.Init();
	● BeforeUpdate：挂号前调用
		外层调用方式：Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的BeforeUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● BeforeUpdateFuncs：挂号前的验证
		内部调用
		Interface	第三方接口（国家医保相关）
	● AfterUpdate：挂号后调用
		外层调用方式：Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的AfterUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● AfterUpdateFuncs：挂号后的方法调用
		内部调用
		Interface	第三方接口（国家医保相关）
	● Interface：其他业务调用
		外层调用方式：Common_ControlObj.Interface("XHZY",argObj);
		外层调用方式：Common_ControlObj.Interface("YDTS",argObj);	
	● UtilFuns：工具类
		内部调用
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
			if ((typeof obj=="object")&&(typeof obj.OPAdm=="object")&&(typeof obj.OPAdm.Init=="function")) {
				obj.OPAdm.Init();
			}
		});
	};
	//挂号前
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
								if ((typeof obj == "object")&&(typeof obj.OPAdm == "object")&&(typeof obj.OPAdm.BeforeReg == "function")) {
									var funcName=obj.OPAdm.BeforeReg.toString();
									$.extend(argObj, { CallBackFunc: resolve});
									var argList=UtilFuns.AnalysisArg("",argObj,funcName)
									if (argList.length==0) {
										obj.OPAdm.BeforeReg()
									}else{
										obj.OPAdm.BeforeReg.apply(null,argList);
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
	//挂号后
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
		Interface:function(argObj,callBackFun){	//对外接口
			$.each(this.InterfaceArr,function(i,obj){
				if ((typeof obj == "object")&&(typeof obj.OPAdm == "object")&&(typeof obj.OPAdm.AfterReg == "function")) {
					var funcName=obj.OPAdm.AfterReg.toString();
					var argList=UtilFuns.AnalysisArg("",argObj,funcName)
					if (argList.length==0) {
						obj.OPAdm.AfterReg();
					}else{
						obj.OPAdm.AfterReg.apply(null,argList);
					}
				}
			});
		}
	};
	//统一其它接口调用
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
			$.messager.confirm('确认对话框', ErrMsg+"<br/>请联系信息科!若继续请点击【确定】", function(r){
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
		"BeforeUpdate":BeforeUpdate,
		"AfterUpdate":AfterUpdate,
		"Interface":Interface,
		"InterfaceArr":InterfaceArr
	};
})()
