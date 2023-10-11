/*
Creater��nk
CreateDate��2022-09-13
FileName��InPatOrderView.Common.Control.js
* ������Ʒ�װ�м��,���������ⷽ��+�ڲ�����
* ��װ����,ͳһ����������ӿڵ���,����ҽ��վ����->�ⲿ�ӿڲ���->����ӿڽ�������µĹ�����������

����˵��:
	�� InterfaceArr���������ӿڶ��󣬴�������ڼ��ظ��ӿڲ�JS��ʱ�����
		�ӿڲ�ʾ����Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	�� Init�������ʼ����ֻ����һ��
		�����÷�ʽ��Common_ControlObj.Init();
	�� Interface������ҵ����ã������໥���á�˵�����
		�����÷�ʽ��Common_ControlObj.Interface("XHZY",argObj);
		�����÷�ʽ��Common_ControlObj.Interface("YDTS",argObj);	
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
			if ((typeof obj=="object")&&(typeof obj.OEOrd=="object")&&(typeof obj.OEOrd.Init=="function")) {
				obj.OEOrd.Init();
			}
		});
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
		//"xhrRefresh":xhrRefresh,
		"Interface":Interface,
		"InterfaceArr":InterfaceArr
		//"LibPhaFunc":LibPhaFunc
	};
})()