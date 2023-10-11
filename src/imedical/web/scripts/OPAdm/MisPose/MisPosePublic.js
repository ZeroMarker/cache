//调用计费组第三方交易接口
var RegPayObj={
	//是否启用Y/N 全局支付接口
	OpenFlag:"Y",
	//是否开启日志功能 Y 开启/N 不开启
	Log:"Y",
	//1 是数据库日志  2 电脑本机日志 
	LogCacheOrLocal:"1",
	//1 只记录错误消息 2 记录错误消息和正常交易
	LogOnlyError:"2",
	//挂号交易支付结果
	PayRtnJsonObj:"", 
	//支付交易接口的交易参数
	PayUserMesage:"",
	//被医保弹窗重置的支付方式Code
	PayModeCode:"",
	//挂号交易函数   交易金额,患者ID,支付方式,医保交易信息
	RegPay:function(){
		//交易前清空结果
		RegPayObj.RtnPayJsonObj=""
		RegPayObj.PayRtnJsonObj=""
		RegPayObj.PayModeCode=""
		if (RegPayObj.OpenFlag!="Y"){return true}
		
		//Fee,patDr,PayModeDr,InsuJoinStr,
		var inPutArry=new Array(12);
		$.each(inPutArry,function(row,data){inPutArry[row]=""})
		
		var myCount=0;
		for(var iarg=0;iarg <arguments.length;iarg++){
			inPutArry[iarg]=arguments[iarg]
		}
		var Fee=inPutArry[0]; //支付金额
		var patDr=inPutArry[1]; //患者ID
		var PayModeDr=inPutArry[2]; //支付方式
		var InsuJoinStr=inPutArry[3]; //医保交易信息
		var test=inPutArry[6];
		var Resouce=inPutArry[10];	//调用来源
		var callbackexecFunc=inPutArry[11];
		
		//医保交易信息存在 按照医保交易信息获取支付方式和支付信息
		var InsuAdmRowidget=""
		if ((InsuJoinStr!="undefined")&&(InsuJoinStr!="")){
			var InsuJoinArry=InsuJoinStr.split("!")
			var InsuPayStr=InsuJoinArry[0]
			var InsuPayFeeStr=InsuJoinArry[1]
			var InsuPayFeeArry=InsuPayFeeStr.split(String.fromCharCode(2))
			PayModeDr=InsuPayStr.split("^")[3]; 		//为防止医保组在弹窗界面重新选择支付方式，以他们选择的支付方式为主
			InsuAdmInfoDrFind=InsuPayStr.split("^")[1]  //医保交易信息
			$.each(InsuPayFeeArry,function(row,FeeData){
				var InsuPayModeAry=FeeData.split('^');
				var InsuPayModeId=InsuPayModeAry[0];
				var InsuPayModeAmount=InsuPayModeAry[1];
				if (PayModeDr==InsuPayModeId){
					Fee=InsuPayModeAmount
				}
			})	
		}
		//未传入支付方式直接获取界面信息
		if (PayModeDr==""){
			var PayModeValue=$("#PayMode").combobox("getValue");
			if (PayModeValue!="") {
				PayModeDr=PayModeValue.split("^")[0];	
			}	
		}
		if (PayModeDr!=""){
			var PayModeData=$("#PayMode").combobox('getData');
			if (Resouce=="CARD"){
			for(var iPayModeData=0;iPayModeData <PayModeData.length;iPayModeData++){
					OnePayMode=PayModeData[iPayModeData]
					if (PayModeData[iPayModeData].id.split("^")[0]==PayModeDr){
						RegPayObj.PayModeCode =PayModeData[iPayModeData].id.split("^")[1] 
						}
				}
			}else{
				var index=$.hisui.indexOfArray(PayModeData,"CTPMRowID",PayModeDr);
				RegPayObj.PayModeCode = PayModeData[index].CTPMCode;
				}
		}
		//调用计费组接口判断支付方式是否应该调用动态库接口
		var rtnDllStr=tkMakeServerCall("DHCBILL.Common.DHCBILLCommon","GetCallModeByPayMode",PayModeDr);
		if (rtnDllStr==""){
			callbackexecFunc(true);
			return true;
		}
		var rtnDllArry=rtnDllStr.split("^");
		var PMEHardComDR=rtnDllArry[0];
		if (PMEHardComDR==0){
			callbackexecFunc(true);
			return true;
		}
		
		//验证配置的支付方式
		//if (typeof RegPayObj.NeedPayMode[PayModeDr]=="undefined"){return true}
		
		//调用计费组第三方支付接口
		var expStr=session['LOGON.CTLOCID']+'^'+session['LOGON.GROUPID']+'^'+session['LOGON.HOSPID']+'^'+session['LOGON.USERID']+'^'+patDr+'^'+""+'^'+"";
		RegPayObj.PayUserMesage=PayModeDr+"!"+Fee+"!"+expStr+"!"+patDr;
		if (Resouce=="CARD") tradeType="CARD";
		else  tradeType="REG";		//默认挂号业务
		RegPayObj.SetLogMesage(0,patDr,"患者支付PatDr:1",RegPayObj.PayUserMesage,"收费开始")
		
		PayService(tradeType, PayModeDr, Fee, expStr,PayServiceAfter);
		function PayServiceAfter(rtnValue){
			RegPayObj.PayRtnJsonObj=rtnValue;
			if (RegPayObj.PayRtnJsonObj.ResultCode!="0"){	
				$.messager.alert("警告","调用支付接口失败,错误信息:"+RegPayObj.PayRtnJsonObj.ResultMsg+",交易ID【"+RegPayObj.PayRtnJsonObj.ETPRowID+"】");
				RegPayObj.SetLogMesage(-1,patDr,"患者支付PatDr",RegPayObj.PayUserMesage,JSON.stringify(RegPayObj.PayRtnJsonObj))
				callbackexecFunc(false);
				return false;
			}else{
				RegPayObj.SetLogMesage(0,patDr,"患者支付PatDr",RegPayObj.PayUserMesage,JSON.stringify(RegPayObj.PayRtnJsonObj))
			}
			callbackexecFunc(true);
			return true
		}
	},
	//挂号成功 关联挂号发票信息和交易信息  挂号表ID
	Relation:function(RegfeeRowId,tradeType){
		if (RegPayObj.OpenFlag!="Y"){return true}
		//交易类型，默认挂号
		if (typeof tradeType=="undefined") tradeType="REG"	
	   	//挂号之后存在交易结果
	   	if ((typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
			if (tradeType=="CARD") var PrtRowID=RegfeeRowId;	//卡交易记录，入参就是卡发票ID
			else var PrtRowID=tkMakeServerCall("web.DHCOPAdmRegPay","GetRegInvoiceId",RegfeeRowId);
			var RelaRtn=RelationService(RegPayObj.PayRtnJsonObj.ETPRowID, PrtRowID, tradeType);
			if (RelaRtn.ResultCode!="0") {
				$.messager.alert("警告","业务ID关联失败,请联系信息运维人员,失败代码:"+RelaRtn.ResultCode+",失败描述："+RelaRtn.ResultMsg+"【RegfeeRowId="+RegfeeRowId+",ETPRowID="+RegPayObj.PayRtnJsonObj.ETPRowID+",PrtRowID="+PrtRowID);
				RegPayObj.SetLogMesage(-1,RegfeeRowId,"关联交易和发票 挂号表ID",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
				return false
			}else{
				RegPayObj.SetLogMesage(0,RegfeeRowId,"关联交易和发票 挂号表ID",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
			}
			return true
		}
		return true
	},
	//退号调用接口退费
	RefundPay:function(RegRowId){
		if (RegPayObj.OpenFlag!="Y"){return true}
		var INVIdStr=tkMakeServerCall("web.DHCOPAdmRegPay","GetMisposINVIdStr",RegRowId);
		if (INVIdStr!="") {
			var ReceipRowid=INVIdStr.split('^')[0];
			var StrikeRowID=INVIdStr.split('^')[1];
			var myPRTRowID=INVIdStr.split('^')[2];
			var CallPaySerInfo=tkMakeServerCall("DHCBILL.Common.DHCBILLCommon","GetPayServicePayMode","",ReceipRowid,"OP");
			var CallPaySerFlag=CallPaySerInfo.split("^")[0];
			if (CallPaySerFlag=="Y") {
				//调用支付退费
				//@param {[String]} tradeType      [业务类型] (挂号和收费传OP 体检传PE 住院收费IP 住院押金DEP)
				//@param {[String]} receipRowID    [原业务ID] 
				//@param {[String]} abortPrtRowID  [新业务ID]
				//@param {[String]} newPrtRowID    [门诊退费重收新票]
				//@param {[String]} refundAmt    	[退款金额  出院退押金、门诊退账户余额 必传]
				//@param {[String]} originalType   [原业务类型  交叉业务必传] (挂号和收费传OP 体检传PE 住院收费IP 住院押金DEP)
				//@param {[String]} expStr    		[扩展串(科室^安全组^院区^操作员ID)]
				var newPrtRowID="";
				var expStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.USERID'];
				
				var rtnValue=RefundPayService("REG",ReceipRowid,StrikeRowID,newPrtRowID,"","REG",expStr)
				if (rtnValue.ResultCode!="0") {
					$.messager.alert("警告","调用退费接口失败,失败描述:【"+rtnValue.ResultMsg+"】")
					RegPayObj.SetLogMesage(-1,RegRowId,"退号退费 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return false
				}else{
					RegPayObj.SetLogMesage(0,RegRowId,"退号退费 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return true
					
				}
			}
		}
		return true
	},
	//退卡费调用接口退费
	RefundCardPay:function(NewCardINVRowID,CardINVRowID){
		var ReceipRowid=CardINVRowID
		var StrikeRowID=NewCardINVRowID
		var myPRTRowID=""
		
		//调用支付退费
		//@param {[String]} tradeType      [业务类型] (挂号和收费传OP 体检传PE 住院收费IP 住院押金DEP)
		//@param {[String]} receipRowID    [原业务ID] 
		//@param {[String]} abortPrtRowID  [新业务ID]
		//@param {[String]} newPrtRowID    [门诊退费重收新票]
		//@param {[String]} refundAmt    	[退款金额  出院退押金、门诊退账户余额 必传]
		//@param {[String]} originalType   [原业务类型  交叉业务必传] (挂号和收费传OP 体检传PE 住院收费IP 住院押金DEP)
		//@param {[String]} expStr    		[扩展串(科室^安全组^院区^操作员ID)]
		var newPrtRowID="";
		var expStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.USERID'];
		
		var rtnValue=RefundPayService("CARD",ReceipRowid,StrikeRowID,newPrtRowID,"","CARD",expStr)
		if (rtnValue.ResultCode!="0") {
			$.messager.alert("警告","调用退费接口失败,失败描述:【"+rtnValue.ResultMsg+"】")
			RegPayObj.SetLogMesage(-1,ReceipRowid,"退卡退费 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr,JSON.stringify(rtnValue))
			return false
		}else{
			RegPayObj.SetLogMesage(0,ReceipRowid,"退卡退费 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr,JSON.stringify(rtnValue))
			return true
			
		}
		
		
		return true
	},
	//医保二次分解调用进行回退
	InsuRefundCase:function(RegRowId){
		if (RegPayObj.OpenFlag!="Y"){return true}
		var INVIdStr=tkMakeServerCall("web.DHCOPAdmRegPay","GetMisposINVIdStr",RegRowId,1);
		if (INVIdStr!="") {
			var ReceipRowid=INVIdStr.split('^')[0];
			var StrikeRowID=INVIdStr.split('^')[1];
			var myPRTRowID=INVIdStr.split('^')[2];
			var CallPaySerInfo=tkMakeServerCall("DHCBILL.Common.DHCBILLCommon","GetPayServicePayMode","",ReceipRowid,"OP");
			var CallPaySerFlag=CallPaySerInfo.split("^")[0];
			if (CallPaySerFlag=="Y") {
				//调用支付退费
				//@param {[String]} tradeType      [业务类型] (挂号和收费传OP 体检传PE 住院收费IP 住院押金DEP)
				//@param {[String]} receipRowID    [原业务ID] 
				//@param {[String]} abortPrtRowID  [新业务ID]
				//@param {[String]} newPrtRowID    [门诊退费重收新票]
				//@param {[String]} refundAmt    	[退款金额  出院退押金、门诊退账户余额 必传]
				//@param {[String]} originalType   [原业务类型  交叉业务必传] (挂号和收费传OP 体检传PE 住院收费IP 住院押金DEP)
				//@param {[String]} expStr    		[扩展串(科室^安全组^院区^操作员ID)]
				var newPrtRowID="";
				var expStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.USERID'];
				var rtnValue=RefundPayService("OP",ReceipRowid,StrikeRowID,myPRTRowID,"","OP",expStr)
				if (rtnValue.ResultCode!="0") {
					$.messager.alert("警告","补医保交易,部分退费接口调用失败:【"+rtnValue.rtnMsg+"】")
					RegPayObj.SetLogMesage(-1,RegRowId,"补医保交易 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return false
				}else{
					RegPayObj.SetLogMesage(0,RegRowId,"补医保交易 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return true
					
				}
			}
		}
		return true
	},
	//挂号失败 异常处理已经收费的订单
	ErrReg:function(){
		if (RegPayObj.OpenFlag!="Y"){return true}
		//挂号异常之后，存在第三方交易信息，需要调用退费接口。
		if ((typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
			var patMesArry=RegPayObj.PayUserMesage.split("!")
			var payMode=patMesArry[0] //支付方式
			var tradeAmt=patMesArry[1] //收费金额
			var expStr=patMesArry[2] //扩展参数
			var patDr=patMesArry[3] //患者信息
			var expStrArrt=expStr.split("^")
			var newexpStr=expStrArrt[0]+"^"+expStrArrt[1]+"^"+expStrArrt[2]+"^"+expStrArrt[3]

			//var rtnstr=BankCardRefund(RegPayObj.PayRtnJsonObj.ETPRowID,tradeAmt,"OP","D",payMode,newexpStr)
			var rtnValue=CancelPayService(RegPayObj.PayRtnJsonObj.ETPRowID,newexpStr)
			if (rtnValue.ResultCode!="0"){
				$.messager.alert("警告","挂号失败,调用费用回退接口,退回失败!<br>"+"交易参数:ETPRowID:"+RegPayObj.PayRtnJsonObj.ETPRowID+" 金额:"+tradeAmt+" 支付方式:"+payMode+" 扩展:"+newexpStr)
				RegPayObj.SetLogMesage(-1,patDr,"挂号失败回退 患者PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return false
			}else{
				RegPayObj.SetLogMesage(0,patDr,"挂号失败回退 患者PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return true
			}
		}	
	},
	//发卡失败 异常处理已经收费的订单
	ErrCard:function(){
		if (RegPayObj.OpenFlag!="Y"){return true}
		if ((typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
			var patMesArry=RegPayObj.PayUserMesage.split("!")
			var expStr=patMesArry[2] //扩展参数
			var patDr=patMesArry[3] //患者信息
			var expStrArrt=expStr.split("^")
			var newexpStr=expStrArrt[0]+"^"+expStrArrt[1]+"^"+expStrArrt[2]+"^"+expStrArrt[3]
			var rtnValue=CancelPayService(RegPayObj.PayRtnJsonObj.ETPRowID,newexpStr)
			if (rtnValue.ResultCode!="0"){
				$.messager.alert("警告","建卡失败,调用费用回退接口,退回失败!<br>"+"交易参数:ETPRowID:"+RegPayObj.PayRtnJsonObj.ETPRowID+" 扩展:"+newexpStr)
				RegPayObj.SetLogMesage(-1,patDr,"建卡失败回退 患者PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return false
			}else{
				RegPayObj.SetLogMesage(0,patDr,"建卡失败回退 患者PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return true
			}
		}	
	},
	
	//日志接口
	SetLogMesage:function(){
		if (RegPayObj.Log!="Y"){return true}
		var inPutArry=new Array(10)
		$.each(inPutArry,function(row,data){inPutArry[row]=""})
		var myCount=0;
		for(var iarg=0;iarg <arguments.length;iarg++){
			inPutArry[iarg]=arguments[iarg]
		}
		//日志信息
		var Statu=inPutArry[0] //状态 0成功的消息 其他失败的消息 
		var ID=inPutArry[1] //ID
		var IDTypeDesc=inPutArry[2] //ID类型描述
		var PayMesage=inPutArry[3] //交易信息
		var PayRtn=inPutArry[4] //返回信息
		var Note=inPutArry[5] //备注
		var Logmesg=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+ClientIPAddress+"^"+"";
		if ((RegPayObj.LogOnlyError==1)&&(Statu==0)){
			return true
		}
		if (RegPayObj.LogCacheOrLocal==1){
			//数据库日志
			var rtn=tkMakeServerCall("web.DHCOPAdmRegPay","SetLogMesage",ID,IDTypeDesc,PayMesage,PayRtn,Note,Logmesg,Statu);
		}else if (RegPayObj.LogCacheOrLocal==1){
			//本机日志	
		}
		return true
	}
		
}

