/*
Creater：nk
CreateDate：2022-09-13
FileName：InPatOrderView.Common.Control.js
* 重新设计封装中间层,独立出对外方法+内部方法
* 封装方法,统一管理第三方接口调用,参照医生站配置->外部接口测试->对外接口接入管理下的关联开启数据

调用说明:
	● InterfaceArr：第三方接口对象，此数组会在加载各接口层JS的时候填充
		接口层示例：Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	● Init：界面初始化，只加载一次
		外层调用方式：Common_ControlObj.Init();
	● Interface：其他业务调用，比如相互作用、说明书等
		外层调用方式：Common_ControlObj.Interface("XHZY",argObj);
		外层调用方式：Common_ControlObj.Interface("YDTS",argObj);	
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
			if ((typeof obj=="object")&&(typeof obj.OEOrd=="object")&&(typeof obj.OEOrd.Init=="function")) {
				obj.OEOrd.Init();
			}
		});
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
		//"xhrRefresh":xhrRefresh,
		"Interface":Interface,
		"InterfaceArr":InterfaceArr
		//"LibPhaFunc":LibPhaFunc
	};
})()