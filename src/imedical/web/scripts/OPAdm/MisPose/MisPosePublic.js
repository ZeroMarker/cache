//���üƷ�����������׽ӿ�
var RegPayObj={
	//�Ƿ�����Y/N ȫ��֧���ӿ�
	OpenFlag:"Y",
	//�Ƿ�����־���� Y ����/N ������
	Log:"Y",
	//1 �����ݿ���־  2 ���Ա�����־ 
	LogCacheOrLocal:"1",
	//1 ֻ��¼������Ϣ 2 ��¼������Ϣ����������
	LogOnlyError:"2",
	//�ҺŽ���֧�����
	PayRtnJsonObj:"", 
	//֧�����׽ӿڵĽ��ײ���
	PayUserMesage:"",
	//��ҽ���������õ�֧����ʽCode
	PayModeCode:"",
	//�ҺŽ��׺���   ���׽��,����ID,֧����ʽ,ҽ��������Ϣ
	RegPay:function(){
		//����ǰ��ս��
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
		var Fee=inPutArry[0]; //֧�����
		var patDr=inPutArry[1]; //����ID
		var PayModeDr=inPutArry[2]; //֧����ʽ
		var InsuJoinStr=inPutArry[3]; //ҽ��������Ϣ
		var test=inPutArry[6];
		var Resouce=inPutArry[10];	//������Դ
		var callbackexecFunc=inPutArry[11];
		
		//ҽ��������Ϣ���� ����ҽ��������Ϣ��ȡ֧����ʽ��֧����Ϣ
		var InsuAdmRowidget=""
		if ((InsuJoinStr!="undefined")&&(InsuJoinStr!="")){
			var InsuJoinArry=InsuJoinStr.split("!")
			var InsuPayStr=InsuJoinArry[0]
			var InsuPayFeeStr=InsuJoinArry[1]
			var InsuPayFeeArry=InsuPayFeeStr.split(String.fromCharCode(2))
			PayModeDr=InsuPayStr.split("^")[3]; 		//Ϊ��ֹҽ�����ڵ�����������ѡ��֧����ʽ��������ѡ���֧����ʽΪ��
			InsuAdmInfoDrFind=InsuPayStr.split("^")[1]  //ҽ��������Ϣ
			$.each(InsuPayFeeArry,function(row,FeeData){
				var InsuPayModeAry=FeeData.split('^');
				var InsuPayModeId=InsuPayModeAry[0];
				var InsuPayModeAmount=InsuPayModeAry[1];
				if (PayModeDr==InsuPayModeId){
					Fee=InsuPayModeAmount
				}
			})	
		}
		//δ����֧����ʽֱ�ӻ�ȡ������Ϣ
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
		//���üƷ���ӿ��ж�֧����ʽ�Ƿ�Ӧ�õ��ö�̬��ӿ�
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
		
		//��֤���õ�֧����ʽ
		//if (typeof RegPayObj.NeedPayMode[PayModeDr]=="undefined"){return true}
		
		//���üƷ��������֧���ӿ�
		var expStr=session['LOGON.CTLOCID']+'^'+session['LOGON.GROUPID']+'^'+session['LOGON.HOSPID']+'^'+session['LOGON.USERID']+'^'+patDr+'^'+""+'^'+"";
		RegPayObj.PayUserMesage=PayModeDr+"!"+Fee+"!"+expStr+"!"+patDr;
		if (Resouce=="CARD") tradeType="CARD";
		else  tradeType="REG";		//Ĭ�ϹҺ�ҵ��
		RegPayObj.SetLogMesage(0,patDr,"����֧��PatDr:1",RegPayObj.PayUserMesage,"�շѿ�ʼ")
		
		PayService(tradeType, PayModeDr, Fee, expStr,PayServiceAfter);
		function PayServiceAfter(rtnValue){
			RegPayObj.PayRtnJsonObj=rtnValue;
			if (RegPayObj.PayRtnJsonObj.ResultCode!="0"){	
				$.messager.alert("����","����֧���ӿ�ʧ��,������Ϣ:"+RegPayObj.PayRtnJsonObj.ResultMsg+",����ID��"+RegPayObj.PayRtnJsonObj.ETPRowID+"��");
				RegPayObj.SetLogMesage(-1,patDr,"����֧��PatDr",RegPayObj.PayUserMesage,JSON.stringify(RegPayObj.PayRtnJsonObj))
				callbackexecFunc(false);
				return false;
			}else{
				RegPayObj.SetLogMesage(0,patDr,"����֧��PatDr",RegPayObj.PayUserMesage,JSON.stringify(RegPayObj.PayRtnJsonObj))
			}
			callbackexecFunc(true);
			return true
		}
	},
	//�Һųɹ� �����Һŷ�Ʊ��Ϣ�ͽ�����Ϣ  �Һű�ID
	Relation:function(RegfeeRowId,tradeType){
		if (RegPayObj.OpenFlag!="Y"){return true}
		//�������ͣ�Ĭ�ϹҺ�
		if (typeof tradeType=="undefined") tradeType="REG"	
	   	//�Һ�֮����ڽ��׽��
	   	if ((typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
			if (tradeType=="CARD") var PrtRowID=RegfeeRowId;	//�����׼�¼����ξ��ǿ���ƱID
			else var PrtRowID=tkMakeServerCall("web.DHCOPAdmRegPay","GetRegInvoiceId",RegfeeRowId);
			var RelaRtn=RelationService(RegPayObj.PayRtnJsonObj.ETPRowID, PrtRowID, tradeType);
			if (RelaRtn.ResultCode!="0") {
				$.messager.alert("����","ҵ��ID����ʧ��,����ϵ��Ϣ��ά��Ա,ʧ�ܴ���:"+RelaRtn.ResultCode+",ʧ��������"+RelaRtn.ResultMsg+"��RegfeeRowId="+RegfeeRowId+",ETPRowID="+RegPayObj.PayRtnJsonObj.ETPRowID+",PrtRowID="+PrtRowID);
				RegPayObj.SetLogMesage(-1,RegfeeRowId,"�������׺ͷ�Ʊ �Һű�ID",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
				return false
			}else{
				RegPayObj.SetLogMesage(0,RegfeeRowId,"�������׺ͷ�Ʊ �Һű�ID",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
			}
			return true
		}
		return true
	},
	//�˺ŵ��ýӿ��˷�
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
				//����֧���˷�
				//@param {[String]} tradeType      [ҵ������] (�Һź��շѴ�OP ��촫PE סԺ�շ�IP סԺѺ��DEP)
				//@param {[String]} receipRowID    [ԭҵ��ID] 
				//@param {[String]} abortPrtRowID  [��ҵ��ID]
				//@param {[String]} newPrtRowID    [�����˷�������Ʊ]
				//@param {[String]} refundAmt    	[�˿���  ��Ժ��Ѻ���������˻���� �ش�]
				//@param {[String]} originalType   [ԭҵ������  ����ҵ��ش�] (�Һź��շѴ�OP ��촫PE סԺ�շ�IP סԺѺ��DEP)
				//@param {[String]} expStr    		[��չ��(����^��ȫ��^Ժ��^����ԱID)]
				var newPrtRowID="";
				var expStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.USERID'];
				
				var rtnValue=RefundPayService("REG",ReceipRowid,StrikeRowID,newPrtRowID,"","REG",expStr)
				if (rtnValue.ResultCode!="0") {
					$.messager.alert("����","�����˷ѽӿ�ʧ��,ʧ������:��"+rtnValue.ResultMsg+"��")
					RegPayObj.SetLogMesage(-1,RegRowId,"�˺��˷� �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return false
				}else{
					RegPayObj.SetLogMesage(0,RegRowId,"�˺��˷� �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return true
					
				}
			}
		}
		return true
	},
	//�˿��ѵ��ýӿ��˷�
	RefundCardPay:function(NewCardINVRowID,CardINVRowID){
		var ReceipRowid=CardINVRowID
		var StrikeRowID=NewCardINVRowID
		var myPRTRowID=""
		
		//����֧���˷�
		//@param {[String]} tradeType      [ҵ������] (�Һź��շѴ�OP ��촫PE סԺ�շ�IP סԺѺ��DEP)
		//@param {[String]} receipRowID    [ԭҵ��ID] 
		//@param {[String]} abortPrtRowID  [��ҵ��ID]
		//@param {[String]} newPrtRowID    [�����˷�������Ʊ]
		//@param {[String]} refundAmt    	[�˿���  ��Ժ��Ѻ���������˻���� �ش�]
		//@param {[String]} originalType   [ԭҵ������  ����ҵ��ش�] (�Һź��շѴ�OP ��촫PE סԺ�շ�IP סԺѺ��DEP)
		//@param {[String]} expStr    		[��չ��(����^��ȫ��^Ժ��^����ԱID)]
		var newPrtRowID="";
		var expStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.USERID'];
		
		var rtnValue=RefundPayService("CARD",ReceipRowid,StrikeRowID,newPrtRowID,"","CARD",expStr)
		if (rtnValue.ResultCode!="0") {
			$.messager.alert("����","�����˷ѽӿ�ʧ��,ʧ������:��"+rtnValue.ResultMsg+"��")
			RegPayObj.SetLogMesage(-1,ReceipRowid,"�˿��˷� �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr,JSON.stringify(rtnValue))
			return false
		}else{
			RegPayObj.SetLogMesage(0,ReceipRowid,"�˿��˷� �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr,JSON.stringify(rtnValue))
			return true
			
		}
		
		
		return true
	},
	//ҽ�����ηֽ���ý��л���
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
				//����֧���˷�
				//@param {[String]} tradeType      [ҵ������] (�Һź��շѴ�OP ��촫PE סԺ�շ�IP סԺѺ��DEP)
				//@param {[String]} receipRowID    [ԭҵ��ID] 
				//@param {[String]} abortPrtRowID  [��ҵ��ID]
				//@param {[String]} newPrtRowID    [�����˷�������Ʊ]
				//@param {[String]} refundAmt    	[�˿���  ��Ժ��Ѻ���������˻���� �ش�]
				//@param {[String]} originalType   [ԭҵ������  ����ҵ��ش�] (�Һź��շѴ�OP ��촫PE סԺ�շ�IP סԺѺ��DEP)
				//@param {[String]} expStr    		[��չ��(����^��ȫ��^Ժ��^����ԱID)]
				var newPrtRowID="";
				var expStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.USERID'];
				var rtnValue=RefundPayService("OP",ReceipRowid,StrikeRowID,myPRTRowID,"","OP",expStr)
				if (rtnValue.ResultCode!="0") {
					$.messager.alert("����","��ҽ������,�����˷ѽӿڵ���ʧ��:��"+rtnValue.rtnMsg+"��")
					RegPayObj.SetLogMesage(-1,RegRowId,"��ҽ������ �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return false
				}else{
					RegPayObj.SetLogMesage(0,RegRowId,"��ҽ������ �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
					return true
					
				}
			}
		}
		return true
	},
	//�Һ�ʧ�� �쳣�����Ѿ��շѵĶ���
	ErrReg:function(){
		if (RegPayObj.OpenFlag!="Y"){return true}
		//�Һ��쳣֮�󣬴��ڵ�����������Ϣ����Ҫ�����˷ѽӿڡ�
		if ((typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
			var patMesArry=RegPayObj.PayUserMesage.split("!")
			var payMode=patMesArry[0] //֧����ʽ
			var tradeAmt=patMesArry[1] //�շѽ��
			var expStr=patMesArry[2] //��չ����
			var patDr=patMesArry[3] //������Ϣ
			var expStrArrt=expStr.split("^")
			var newexpStr=expStrArrt[0]+"^"+expStrArrt[1]+"^"+expStrArrt[2]+"^"+expStrArrt[3]

			//var rtnstr=BankCardRefund(RegPayObj.PayRtnJsonObj.ETPRowID,tradeAmt,"OP","D",payMode,newexpStr)
			var rtnValue=CancelPayService(RegPayObj.PayRtnJsonObj.ETPRowID,newexpStr)
			if (rtnValue.ResultCode!="0"){
				$.messager.alert("����","�Һ�ʧ��,���÷��û��˽ӿ�,�˻�ʧ��!<br>"+"���ײ���:ETPRowID:"+RegPayObj.PayRtnJsonObj.ETPRowID+" ���:"+tradeAmt+" ֧����ʽ:"+payMode+" ��չ:"+newexpStr)
				RegPayObj.SetLogMesage(-1,patDr,"�Һ�ʧ�ܻ��� ����PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return false
			}else{
				RegPayObj.SetLogMesage(0,patDr,"�Һ�ʧ�ܻ��� ����PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return true
			}
		}	
	},
	//����ʧ�� �쳣�����Ѿ��շѵĶ���
	ErrCard:function(){
		if (RegPayObj.OpenFlag!="Y"){return true}
		if ((typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
			var patMesArry=RegPayObj.PayUserMesage.split("!")
			var expStr=patMesArry[2] //��չ����
			var patDr=patMesArry[3] //������Ϣ
			var expStrArrt=expStr.split("^")
			var newexpStr=expStrArrt[0]+"^"+expStrArrt[1]+"^"+expStrArrt[2]+"^"+expStrArrt[3]
			var rtnValue=CancelPayService(RegPayObj.PayRtnJsonObj.ETPRowID,newexpStr)
			if (rtnValue.ResultCode!="0"){
				$.messager.alert("����","����ʧ��,���÷��û��˽ӿ�,�˻�ʧ��!<br>"+"���ײ���:ETPRowID:"+RegPayObj.PayRtnJsonObj.ETPRowID+" ��չ:"+newexpStr)
				RegPayObj.SetLogMesage(-1,patDr,"����ʧ�ܻ��� ����PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return false
			}else{
				RegPayObj.SetLogMesage(0,patDr,"����ʧ�ܻ��� ����PatDr",RegPayObj.PayRtnJsonObj.ETPRowID+"!"+newexpStr+"!"+patDr,JSON.stringify(rtnValue))
				return true
			}
		}	
	},
	
	//��־�ӿ�
	SetLogMesage:function(){
		if (RegPayObj.Log!="Y"){return true}
		var inPutArry=new Array(10)
		$.each(inPutArry,function(row,data){inPutArry[row]=""})
		var myCount=0;
		for(var iarg=0;iarg <arguments.length;iarg++){
			inPutArry[iarg]=arguments[iarg]
		}
		//��־��Ϣ
		var Statu=inPutArry[0] //״̬ 0�ɹ�����Ϣ ����ʧ�ܵ���Ϣ 
		var ID=inPutArry[1] //ID
		var IDTypeDesc=inPutArry[2] //ID��������
		var PayMesage=inPutArry[3] //������Ϣ
		var PayRtn=inPutArry[4] //������Ϣ
		var Note=inPutArry[5] //��ע
		var Logmesg=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+ClientIPAddress+"^"+"";
		if ((RegPayObj.LogOnlyError==1)&&(Statu==0)){
			return true
		}
		if (RegPayObj.LogCacheOrLocal==1){
			//���ݿ���־
			var rtn=tkMakeServerCall("web.DHCOPAdmRegPay","SetLogMesage",ID,IDTypeDesc,PayMesage,PayRtn,Note,Logmesg,Statu);
		}else if (RegPayObj.LogCacheOrLocal==1){
			//������־	
		}
		return true
	}
		
}

