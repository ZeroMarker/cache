/*
Creater��	jm
CreateDate��2022-02-10
FileName��	Reg.Common.Control.js
Description�������漰�Һ�ǰ����ǰ�˽ӿڣ�ͳһ��װ������JS
* ����������ӿڵ���,����ҽ��վ����->�ⲿ�ӿڲ���->����ӿڽ�������µĹ�����������

����˵��:
	�� InterfaceArr���������ӿڶ��󣬴�������ڼ��ظ��ӿڲ�JS��ʱ�����
		�ӿڲ�ʾ����Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	�� Init�������ʼ����ֻ����һ��
		�����÷�ʽ��Common_ControlObj.Init();
	�� BeforeUpdate���Һ�ǰ����
		�����÷�ʽ��Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		���˵����f:���õ�BeforeUpdateFuncs�����еķ�������(Ϊ�˽���ӿڷ����ڲ�����Promise���ú�this����ָ�򱻸���)
					����Ϊ��ʽ��Σ�������ӿڷ�����ֵ��һ��Ϊ(�����ʽ����,�ص�����)
	�� BeforeUpdateFuncs���Һ�ǰ����֤
		�ڲ�����
		Interface	�������ӿڣ�����ҽ����أ�
	�� AfterUpdate���Һź����
		�����÷�ʽ��Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		���˵����f:���õ�AfterUpdateFuncs�����еķ�������(Ϊ�˽���ӿڷ����ڲ�����Promise���ú�this����ָ�򱻸���)
					����Ϊ��ʽ��Σ�������ӿڷ�����ֵ��һ��Ϊ(�����ʽ����,�ص�����)
	�� AfterUpdateFuncs���Һź�ķ�������
		�ڲ�����
		Interface	�������ӿڣ�����ҽ����أ�
	�� Interface������ҵ�����
		�����÷�ʽ��Common_ControlObj.Interface("XHZY",argObj);
		�����÷�ʽ��Common_ControlObj.Interface("YDTS",argObj);	
	�� UtilFuns��������
		�ڲ�����
		ReturnErrData		���д�����Ϣ����ʾ����������ʾ���лص��Ǽ�����˻���ȡ�����(������ҩ��CDSS���ٴ�·�����)
		ReturnData			���󷵻�ֵ(CA��֤�ӿ�){PassFlag:boolean,Obj:obj}
		AnalysisArg			����������α�����,���Ӵ��������л�ȡ��ƥ�������
							��Σ��ص�����,�����ʽҵ������,�����壻���Σ����շ��������˳����֯������				
		AlertErrData		�����д�����Ϣ����ʾ
*/
//�ӿں�����װ
var Common_ControlObj=(function(){
	//�ӿڷ���,��������ڼ��ظ��ӿڲ�JS��ʱ�����
	var InterfaceArr=new Array();
	//ȫ�ֳ�ʼ��
	function Init(){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.OPAdm=="object")&&(typeof obj.OPAdm.Init=="function")) {
				obj.OPAdm.Init();
			}
		});
	};
	//�Һ�ǰ
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
			return UtilFuns.ReturnErrData("�ӿڷ���"+f+"������.",thisCallBack);
		}
		return DoFunName.apply(this,argAry);	
	};
	var BeforeUpdateFuncs={
		//����ӿ�
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
				UtilFuns.ReturnErrData("���ǰ�ӿ��쳣:"+e.message,callBackFun)
			}
		}
	};
	//�Һź�
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
			return UtilFuns.AlertErrData("��˺�ӿڷ���:"+f+"�����ڡ�",thisCallBack);
		}
		return DoFunName.apply(this,argAry);	
	};
	var AfterUpdateFuncs={
		Interface:function(argObj,callBackFun){	//����ӿ�
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
	//ͳһ�����ӿڵ���
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
			UtilFuns.ReturnErrData("����ӿ�"+func+"�쳣:"+e.message,callBackFun)
		}
	};
	var UtilFuns={
		ReturnErrData:function(ErrMsg,callBackFun){
			$.messager.confirm('ȷ�϶Ի���', ErrMsg+"<br/>����ϵ��Ϣ��!������������ȷ����", function(r){
				if(typeof callBackFun == 'function'){
					callBackFun(r);
				}else{
					return r;	
				}
			})
		},
		AlertErrData:function(ErrMsg,callBackFun){
			$.messager.alert('����', ErrMsg+"<br/>����ϵ��Ϣ��!", "info", function(){
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
