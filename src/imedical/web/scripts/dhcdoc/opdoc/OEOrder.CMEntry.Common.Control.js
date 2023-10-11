/*
Creater��jm
CreateDate��2023-02-14
FileName��OEOrder.CMEntry.Common.Control.js
Description�������漰ҽ��������ǰ��ǰ�˽ӿڣ�����ͳһ��װһ��js�����������ⷽ��+�ڲ�����
* ��װ����,ͳһ����������ӿڵ���,����ҽ��վ����->�ⲿ�ӿڲ���->����ӿڽ�������µĹ�����������

����˵��:
	�� InterfaceArr���������ӿڶ��󣬴�������ڼ��ظ��ӿڲ�JS��ʱ�����
		�ӿڲ�ʾ����Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	�� Init�������ʼ����ֻ����һ��
		�����÷�ʽ��Common_ControlObj.Init();
	�� xhrRefresh�������л���ʼ��
		�����÷�ʽ��Common_ControlObj.xhrRefresh(argObj);
	�� BeforeUpdate��ҽ��¼�����ǰ����
		�����÷�ʽ��Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		���˵����f:���õ�BeforeUpdateFuncs�����еķ�������(Ϊ�˽���ӿڷ����ڲ�����Promise���ú�this����ָ�򱻸���)
					����Ϊ��ʽ��Σ�������ӿڷ�����ֵ��һ��Ϊ(�����ʽ����,�ص�����)
	�� BeforeUpdateFuncs��ҽ��¼�����ǰ����֤
		�ڲ�����
		CASignCheck			CA��֤�ӿ�
		Interface			�������ӿڣ�������ҩ������ҽ����أ�
	�� AfterUpdate��ҽ��¼����˺����
		�����÷�ʽ��Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		���˵����f:���õ�AfterUpdateFuncs�����еķ�������(Ϊ�˽���ӿڷ����ڲ�����Promise���ú�this����ָ�򱻸���)
					����Ϊ��ʽ��Σ�������ӿڷ�����ֵ��һ��Ϊ(�����ʽ����,�ص�����)
	�� AfterUpdateFuncs��ҽ��¼����˺�ķ�������
		�ڲ�����
		SynData				����ͬ���ӿڣ�����ҽ��CA��֤���棬CDSSҽ��ͬ�����õ���ȣ�
		Interface			�������ӿڣ�������ҩ������ҽ����أ�
		OpenSelectDia		����������Ͻӿ�
		SaveOrderToEMR		ͬ��ҽ�����������Ӳ���
	�� Interface������ҵ����ã������໥���á�˵�����
		�����÷�ʽ��Common_ControlObj.Interface("XHZY",argObj);
		�����÷�ʽ��Common_ControlObj.Interface("YDTS",argObj);	
	�� UtilFuns��������
		�ڲ�����
		ReturnErrData		���д�����Ϣ����ʾ����������ʾ���лص��Ǽ�����˻���ȡ�����
		ReturnData			���󷵻�ֵ(CA��֤�ӿ�){PassFlag:boolean,Obj:obj}
		AnalysisArg			����������α�����,���Ӵ��������л�ȡ��ƥ�������
							��Σ��ص�����,�����ʽҵ������,�����壻���Σ����շ��������˳����֯������				
		AlertErrData		�����д�����Ϣ����ʾ

������js(����Ҫʹ�ö�Ӧ��װ�Ľӿڷ���)��
	1��CA��֤��scripts/dhcdoc/DHCDoc.CASign.js
*/
//�ӿں�����װ
var Common_ControlObj=(function(){
	//�ӿڷ���,��������ڼ��ظ��ӿڲ�JS��ʱ�����
	var InterfaceArr=new Array();
	//ȫ�ֳ�ʼ��
	function Init(){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.CMOEOrd=="object")&&(typeof obj.CMOEOrd.Init=="function")) {
				obj.CMOEOrd.Init();
			}
		});
	};
	//�ֲ���ʼ��
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
				callType:��������
				isHeaderMenuOpen:�Ƿ���ͷ�˵���ǩ������. Ĭ��true
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
									//�����ӿ�������ڷ���ֵ�账��,�����Զ���ʽ����
									if(typeof(ret)=="object"){
										$.extend(ReturnObj, ret);
										$.extend(argObj, ret); //ǰһ���ӿڿ��ܴ��ڸ��³�ʼ��ε����������ҽ����������һ���ӿ�����ʹ�ø��º��ҽ����	
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
			if (argObj.caIsPass==1) CASignObj.SaveCASign(argObj.CAObj, argObj.OEOrdItemIDs, "A");
		},
		Interface:function(argObj,callBackFun){	//����ӿ�
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
		OpenSelectDia:function(argObj){ //�����������
			var EpisodeID=argObj.EpisodeID;
			var OEOrdItemIDs=argObj.OEOrdItemIDs;
			var precnum=tkMakeServerCall("web.DHCDocDiagLinkToPrse","getAllCheckDiaPrce",EpisodeID,session['LOGON.USERID'],OEOrdItemIDs) 
		  	if (precnum!=""){
				//���������Ϊ1,��ֱ�ӽ�������봦������
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
						title:$g('�����������'),
						iconCls:'icon-w-list',
						width:awidth,height:aheight
					})	
				}
			}
		},
		SaveOrderToEMR:function(argObj){ //ͬ��ҽ�����������Ӳ���
			if (argObj.PAAdmType == "I") {
		        return true;
		    }
		    var EpisodeID=argObj.EpisodeID;
		    var OrdList = tkMakeServerCall("EMRservice.BL.opInterface", "getOeordXH", EpisodeID, "CHMED")
			if ((typeof(parent.invokeChartFun) === 'function')||(typeof(parent.parent.invokeChartFun) === 'function')) {
			    if (typeof(parent.invokeChartFun) === 'function'){
				    parent.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "oeordCN", OrdList, "", EpisodeID);
				}else{
					parent.parent.invokeChartFun('���ﲡ��', 'updateEMRInstanceData', "oeordCN", OrdList, "", EpisodeID);
				}
			}
		    return OrdList
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
			UtilFuns.ReturnErrData("����ӿ�"+func+"�쳣:"+e.message,callBackFun)
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
