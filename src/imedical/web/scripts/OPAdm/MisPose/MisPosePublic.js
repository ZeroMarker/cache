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
	//挂号交易函数   交易金额,患者ID,支付方式,医保交易信息
	RegPay:function(){
			//交易前清空结果
			this.RtnPayJsonObj=""
			if (this.OpenFlag!="Y"){return true}
			
			//Fee,patDr,PayModeDr,InsuJoinStr,
			var inPutArry=new Array(10);
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
			
			//未传入支付方式直接获取界面信息
			if (PayModeDr==""){
				var PayModeValue=$("#PayMode").combobox("getValue");
				if (PayModeValue!="") {
					PayModeDr=PayModeValue.split("^")[0];	
				}	
			}
			//医保交易信息存在 按照医保交易信息获取支付方式和支付信息
			var InsuAdmRowidget=""
			if ((InsuJoinStr!="undefined")&&(InsuJoinStr!="")){
				var InsuJoinArry=InsuJoinStr.split("!")
				var InsuPayStr=InsuJoinArry[0]
				var InsuPayFeeStr=InsuJoinArry[1]
				var InsuPayFeeArry=InsuPayFeeStr.split(String.fromCharCode(2))
				PayModeDr=InsuPayStr.split("^")[3]; //现金支付方式
				InsuAdmInfoDrFind=InsuPayStr.split("^")[1] //医保交易信息
				$.each(InsuPayFeeArry,function(row,FeeData){
					var InsuPayModeAry=FeeData.split('^');
					var InsuPayModeId=InsuPayModeAry[0];
					var InsuPayModeAmount=InsuPayModeAry[1];
					if (PayModeDr==InsuPayModeId){
						Fee=InsuPayModeAmount
					}
				})	
			}
			
			//调用计费组接口判断支付方式是否应该调用动态库接口
			var rtnDllStr=tkMakeServerCall("DHCBILL.Common.DHCBILLCommon","GetCallModeByPayMode",PayModeDr);
			if (rtnDllStr==""){return true}
			var rtnDllArry=rtnDllStr.split("^")
			var PMEHardComDR=rtnDllArry[0]
			if (PMEHardComDR==0){return true}
			
			//验证配置的支付方式
			//if (typeof this.NeedPayMode[PayModeDr]=="undefined"){return true}
			
			//调用计费组第三方支付接口
			var expStr=session['LOGON.CTLOCID']+'^'+session['LOGON.GROUPID']+'^'+session['LOGON.HOSPID']+'^'+session['LOGON.USERID']+'^'+patDr+'^'+""+'^'+"";
			this.PayUserMesage=PayModeDr+"!"+Fee+"!"+expStr+"!"+patDr
			this.PayRtnJsonObj=PayService("OP", PayModeDr, Fee, expStr);
			if (this.PayRtnJsonObj.ResultCode!="0")
			{	dhcsys_alert("调用支付接口失败,错误信息:"+this.PayRtnJsonObj.ResultMsg+",交易ID【"+this.PayRtnJsonObj.ETPRowID+"】");
				this.SetLogMesage(-1,patDr,"患者支付PatDr",this.PayUserMesage,JSON.stringify(this.PayRtnJsonObj))
				return false
			}else{
				this.SetLogMesage(0,patDr,"患者支付PatDr",this.PayUserMesage,JSON.stringify(this.PayRtnJsonObj))
			}
			
			return true
	},
	//挂号成功 关联挂号发票信息和交易信息  挂号表ID
	Relation:function(RegfeeRowId){
			if (this.OpenFlag!="Y"){return true}
		   //挂号之后存在交易结果
		   if ((typeof this.PayRtnJsonObj.ETPRowID!="undefined")&&(this.PayRtnJsonObj.ETPRowID!="")) {
					var PrtRowID=tkMakeServerCall("web.DHCOPAdmRegPay","GetRegInvoiceId",RegfeeRowId);
					var RelaRtn=RelationService(this.PayRtnJsonObj.ETPRowID, PrtRowID, "OP");
					if (RelaRtn.ResultCode!="0") {
						dhcsys_alert("业务ID关联失败,请联系信息运维人员,失败代码:"+RelaRtn.ResultCode+",失败描述："+RelaRtn.ResultMsg+"【RegfeeRowId="+RegfeeRowId+",ETPRowID="+this.PayRtnJsonObj.ETPRowID+",PrtRowID="+PrtRowID);
						this.SetLogMesage(-1,RegfeeRowId,"关联交易和发票 挂号表ID",this.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
						return false
					}else{
						this.SetLogMesage(0,RegfeeRowId,"关联交易和发票 挂号表ID",this.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
					}
					return true
			}
			return true
	},
	//退号调用接口退费
	RefundPay:function(RegRowId){
			if (this.OpenFlag!="Y"){return true}
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
					var rtnValue=RefundPayService("OP",ReceipRowid,StrikeRowID,newPrtRowID,"","OP",expStr)
					if (rtnValue.rtnCode!="0") {
						dhcsys_alert("调用退费接口失败,失败描述:【"+rtnValue.rtnMsg+"】")
						this.SetLogMesage(-1,RegRowId,"退号退费 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return false
					}else{
						this.SetLogMesage(0,RegRowId,"退号退费 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return true
						
					}
				}
			}
			return true
	},
	//医保二次分解调用进行回退
	InsuRefundCase:function(RegRowId){
			if (this.OpenFlag!="Y"){return true}
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
					if (rtnValue.rtnCode!="0") {
						dhcsys_alert("补医保交易,部分退费接口调用失败:【"+rtnValue.rtnMsg+"】")
						this.SetLogMesage(-1,RegRowId,"补医保交易 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return false
					}else{
						this.SetLogMesage(0,RegRowId,"补医保交易 挂号表ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return true
						
					}
				}
			}
			return true
	},
	//挂号失败 异常处理已经收费的订单
	ErrReg:function()
	{
		 if (this.OpenFlag!="Y"){return true}
		 //挂号异常之后，存在第三方交易信息，需要调用退费接口。
		 if ((typeof this.PayRtnJsonObj.ETPRowID!="undefined")&&(this.PayRtnJsonObj.ETPRowID!="")) {
			 var patMesArry=this.PayUserMesage.split("!")
			 var payMode=patMesArry[0] //支付方式
			 var tradeAmt=patMesArry[1] //收费金额
			 var expStr=patMesArry[2] //扩展参数
			 var patDr=patMesArry[3] //患者信息
			 var expStrArrt=expStr.split("^")
			 var newexpStr=expStrArrt[0]+"^"+expStrArrt[1]+"^"+expStrArrt[2]+"^"+expStrArrt[3]
			 
			 var rtnstr=BankCardRefund(this.PayRtnJsonObj.ETPRowID,tradeAmt,"OP","D",payMode,newexpStr)
			 var rtnArry=rtnstr.split("^")
			 if (rtnArry[0]!="0"){
				 dhcsys_alert("挂号失败,调用费用回退接口,退回失败!<br>"+"交易参数:ETPRowID:"+this.PayRtnJsonObj.ETPRowID+" 金额:"+tradeAmt+" 支付方式:"+payMode+" 扩展:"+newexpStr)
				 this.SetLogMesage(-1,patDr,"挂号失败回退 患者PatDr",this.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,rtnstr)
				 return false
			 }
			 else{
				this.SetLogMesage(0,patDr,"挂号失败回退 患者PatDr",this.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,rtnstr)
				return true
			 }
		 }	
	},
	//日志接口
	SetLogMesage:function(){
			if (this.Log!="Y"){return true}
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
			if ((this.LogOnlyError==1)&&(Statu==0)){
				return true
			}
			if (this.LogCacheOrLocal==1){
				//数据库日志
				var rtn=tkMakeServerCall("web.DHCOPAdmRegPay","SetLogMesage",ID,IDTypeDesc,PayMesage,PayRtn,Note,Logmesg,Statu);
			}else if (this.LogCacheOrLocal==1){
				//本机日志	
			}
			return true
	},
	
	//挂号交易支付结果
	PayRtnJsonObj:"", 
	
	//支付交易接口的交易参数
	PayUserMesage:"",
	
	
	
}

