/*
Creater��	jm
CreateDate��2023-02-28
FileName��	scripts/dhcdoc/DiagnosEntry.Common.Control
Description�������漰��ϲ���ǰ���ǰ�˽ӿڣ�����ͳһ��װһ��js���ö�����js��
* ��װ����,ͳһ����������ӿڵ���,����ҽ��վ����->�ⲿ�ӿڲ���->����ӿڽ�������µĹ�����������

����˵��:
	�� InterfaceArr���������ӿڶ��󣬴�������ڼ��ظ��ӿڲ�JS��ʱ�����
		�ӿڲ�ʾ����Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	�� Init�������ʼ����ֻ����һ��
		�����÷�ʽ��Common_ControlObj.Init();
	�� xhrRefresh�������л���ʼ��
		�����÷�ʽ��Common_ControlObj.xhrRefresh(argObj);
	�� BeforeUpdate����ϲ���ǰ����
		�����÷�ʽ��Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		���˵����f:���õ�BeforeUpdateFuncs�����еķ�������(Ϊ�˽���ӿڷ����ڲ�����Promise���ú�this����ָ�򱻸���)
					����Ϊ��ʽ��Σ�������ӿڷ�����ֵ��һ��Ϊ(�����ʽ����,�ص�����)
	�� BeforeUpdateFuncs����ϲ���ǰ����֤
		�ڲ�����
		CASignCheck				CA��֤�ӿ�
		Interface				�������ӿ�
		CDSSCheck				CDSS��ǰԤ���ӿ�
		CheckReportBeforeInsert	����ҽ����ӿ��ж���ϱ���
	�� AfterUpdate����ϲ�������
		�����÷�ʽ��Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		���˵����f:���õ�AfterUpdateFuncs�����еķ�������(Ϊ�˽���ӿڷ����ڲ�����Promise���ú�this����ָ�򱻸���)
					����Ϊ��ʽ��Σ�������ӿڷ�����ֵ��һ��Ϊ(�����ʽ����,�ص�����)
	�� AfterUpdateFuncs����ϲ����ķ�������
		�ڲ�����
		SynData					����ͬ���ӿ�(����CA��֤����,CDSSҽ��ͬ����)
		ShowCPW					�뾶���ӿ�
		SaveMRDiagnosToEMR		ͬ��������������Ӳ���
		Interface				�������ӿ�
	�� Interface������ҵ�����
		�����÷�ʽ��Common_ControlObj.Interface("DrgsRefresh",argObj);
	�� UtilFuns��������
		�ڲ�����
		FormatOrderStr		��ʽ��ҽ����˵�ҽ����Ϣ��(Ŀǰ��δ����)
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
			if ((typeof obj=="object")&&(typeof obj.Diag=="object")&&(typeof obj.Diag.Init=="function")) {
				obj.Diag.Init();
			}
		});
	};
	//�ֲ���ʼ��
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
	//ҽ��¼��-���ǰ
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
		//CA��֤
		CASignCheck:function(argObj,callBackFun) {
			/*argObj={
				callType:��������,
				isHeaderMenuOpen:�Ƿ���ͷ�˵���ǩ������. Ĭ��true
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
										callBackFun(ret); //��������ʱ�����callBackFun�ص�����
								        return false;
									}
									//�����ӿ�������ڷ���ֵ�账��,�����Զ���ʽ����
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
									callBackFunExec();//loopѭ������ʱ�����resolve����
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
		},
		CDSSCheck:function(argObj,callBackFun) {//CDSS��ǰԤ��
			/*argObj={
				EpisodeID:����ID,
				DiagItemStr:�����Ϣ��
			}*/
			try{
				if (typeof CDSSObj=='object'){	
					CDSSObj.CheckDiagnos(argObj.EpisodeID,argObj.DiagItemStr,callBackFun);
				}else{
					callBackFun(true);	
				}
			}catch(e){
				UtilFuns.ReturnErrData("CDSS��ǰԤ���ӿڵ����쳣:"+e.message,callBackFun);
			}
		},
		CheckReportBeforeInsert:function(argObj,callBackFun) {	//����ҽ����ӿ��ж���ϱ���
			/*argObj={
				EpisodeID:����ID,
				DiagItemStr:�����Ϣ��
			}*/
			try{
				if (typeof CheckReportBeforeInsert=='function'){
					CheckReportBeforeInsert(argObj.DiagItemStr,callBackFun);
				}else{
					callBackFun(argObj.DiagItemStr);	
				}
			}catch(e){
				UtilFuns.ReturnErrData("��Ⱦ�������ӿڵ����쳣:"+e.message,callBackFun);
			}
		}
	};
	//ҽ��¼��-��˺�
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
		SynData:function(argObj) {	//����ͬ��
			var DiagItemIDs=argObj.DiagItemIDs;
			var CACallType=argObj.CACallType;
			//
			if (argObj.caIsPass==1) CASignObj.SaveCASign(argObj.CAObj, DiagItemIDs, CACallType);
			if (typeof CDSSObj=='object') CDSSObj.SynDiagnos(argObj.EpisodeID, DiagItemIDs);
		},
		ShowCPW:function(argObj) {	//�뾶���
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
		SaveMRDiagnosToEMR:function(argObj){	//ͬ��������������Ӳ���
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
						opts.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
					}else{
						opts.invokeChartFun('�ż��ﲡ����¼', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
					}
				}else if ((typeof(parent.invokeChartFun) === 'function')||((window.dialogArguments)&&(window.dialogArguments.parent)&&(typeof(window.dialogArguments.parent.parent.invokeChartFun) === 'function'))) {
					if (typeof(parent.invokeChartFun) === 'function'){
						if (PAAdmType!="E"){
							parent.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}else{
							parent.invokeChartFun('�ż��ﲡ����¼', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}
					}else{
						if(PAAdmType!="E"){
							window.dialogArguments.parent.parent.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}else{
							window.dialogArguments.parent.parent.invokeChartFun('�ż��ﲡ����¼', 'updateEMRInstanceData', "diag", ret, "", EpisodeID);
						}
					}
				}
			}catch(e) {
				return false;
			}
		},
		Interface:function(argObj,callBackFun){	//����ӿ�
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
	//ͳһ�����ӿڵ���,�����໥����,˵�����
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
			UtilFuns.AlertErrData("����ӿ�-"+func+"�쳣:"+e.message,callBackFun)
		}
	};
	var UtilFuns={
		FormatOrderStr:function(argObj){
			//��ʽ��ҽ����˵�ҽ����Ϣ��
			//Ŀǰ��δ����
			/*argObj{
				DataType:��Ҫ����������	
				OrderItemStr:��ʼ��ҽ����Ϣ��
			}*/
			var FormatOrderData="";
			var DataType=argObj.DataType;
			var OrderItemStr=argObj.OrderItemStr;
			FormatOrderData=OrderItemStr;
			return FormatOrderData;
		},
		ReturnErrData:function(ErrMsg,callBackFun){
			$.messager.confirm('ȷ�϶Ի���', ErrMsg+"<br/>����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����", function(r){
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
		},
		///����Promise�����ļ�
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
					 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
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
