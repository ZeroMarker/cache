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
	//�ҺŽ��׺���   ���׽��,����ID,֧����ʽ,ҽ��������Ϣ
	RegPay:function(){
			//����ǰ��ս��
			this.RtnPayJsonObj=""
			if (this.OpenFlag!="Y"){return true}
			
			//Fee,patDr,PayModeDr,InsuJoinStr,
			var inPutArry=new Array(10);
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
			
			//δ����֧����ʽֱ�ӻ�ȡ������Ϣ
			if (PayModeDr==""){
				var PayModeValue=$("#PayMode").combobox("getValue");
				if (PayModeValue!="") {
					PayModeDr=PayModeValue.split("^")[0];	
				}	
			}
			//ҽ��������Ϣ���� ����ҽ��������Ϣ��ȡ֧����ʽ��֧����Ϣ
			var InsuAdmRowidget=""
			if ((InsuJoinStr!="undefined")&&(InsuJoinStr!="")){
				var InsuJoinArry=InsuJoinStr.split("!")
				var InsuPayStr=InsuJoinArry[0]
				var InsuPayFeeStr=InsuJoinArry[1]
				var InsuPayFeeArry=InsuPayFeeStr.split(String.fromCharCode(2))
				PayModeDr=InsuPayStr.split("^")[3]; //�ֽ�֧����ʽ
				InsuAdmInfoDrFind=InsuPayStr.split("^")[1] //ҽ��������Ϣ
				$.each(InsuPayFeeArry,function(row,FeeData){
					var InsuPayModeAry=FeeData.split('^');
					var InsuPayModeId=InsuPayModeAry[0];
					var InsuPayModeAmount=InsuPayModeAry[1];
					if (PayModeDr==InsuPayModeId){
						Fee=InsuPayModeAmount
					}
				})	
			}
			
			//���üƷ���ӿ��ж�֧����ʽ�Ƿ�Ӧ�õ��ö�̬��ӿ�
			var rtnDllStr=tkMakeServerCall("DHCBILL.Common.DHCBILLCommon","GetCallModeByPayMode",PayModeDr);
			if (rtnDllStr==""){return true}
			var rtnDllArry=rtnDllStr.split("^")
			var PMEHardComDR=rtnDllArry[0]
			if (PMEHardComDR==0){return true}
			
			//��֤���õ�֧����ʽ
			//if (typeof this.NeedPayMode[PayModeDr]=="undefined"){return true}
			
			//���üƷ��������֧���ӿ�
			var expStr=session['LOGON.CTLOCID']+'^'+session['LOGON.GROUPID']+'^'+session['LOGON.HOSPID']+'^'+session['LOGON.USERID']+'^'+patDr+'^'+""+'^'+"";
			this.PayUserMesage=PayModeDr+"!"+Fee+"!"+expStr+"!"+patDr
			this.PayRtnJsonObj=PayService("OP", PayModeDr, Fee, expStr);
			if (this.PayRtnJsonObj.ResultCode!="0")
			{	dhcsys_alert("����֧���ӿ�ʧ��,������Ϣ:"+this.PayRtnJsonObj.ResultMsg+",����ID��"+this.PayRtnJsonObj.ETPRowID+"��");
				this.SetLogMesage(-1,patDr,"����֧��PatDr",this.PayUserMesage,JSON.stringify(this.PayRtnJsonObj))
				return false
			}else{
				this.SetLogMesage(0,patDr,"����֧��PatDr",this.PayUserMesage,JSON.stringify(this.PayRtnJsonObj))
			}
			
			return true
	},
	//�Һųɹ� �����Һŷ�Ʊ��Ϣ�ͽ�����Ϣ  �Һű�ID
	Relation:function(RegfeeRowId){
			if (this.OpenFlag!="Y"){return true}
		   //�Һ�֮����ڽ��׽��
		   if ((typeof this.PayRtnJsonObj.ETPRowID!="undefined")&&(this.PayRtnJsonObj.ETPRowID!="")) {
					var PrtRowID=tkMakeServerCall("web.DHCOPAdmRegPay","GetRegInvoiceId",RegfeeRowId);
					var RelaRtn=RelationService(this.PayRtnJsonObj.ETPRowID, PrtRowID, "OP");
					if (RelaRtn.ResultCode!="0") {
						dhcsys_alert("ҵ��ID����ʧ��,����ϵ��Ϣ��ά��Ա,ʧ�ܴ���:"+RelaRtn.ResultCode+",ʧ��������"+RelaRtn.ResultMsg+"��RegfeeRowId="+RegfeeRowId+",ETPRowID="+this.PayRtnJsonObj.ETPRowID+",PrtRowID="+PrtRowID);
						this.SetLogMesage(-1,RegfeeRowId,"�������׺ͷ�Ʊ �Һű�ID",this.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
						return false
					}else{
						this.SetLogMesage(0,RegfeeRowId,"�������׺ͷ�Ʊ �Һű�ID",this.PayRtnJsonObj.ETPRowID+"!"+PrtRowID+"!"+RegfeeRowId,JSON.stringify(RelaRtn))
					}
					return true
			}
			return true
	},
	//�˺ŵ��ýӿ��˷�
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
					var rtnValue=RefundPayService("OP",ReceipRowid,StrikeRowID,newPrtRowID,"","OP",expStr)
					if (rtnValue.rtnCode!="0") {
						dhcsys_alert("�����˷ѽӿ�ʧ��,ʧ������:��"+rtnValue.rtnMsg+"��")
						this.SetLogMesage(-1,RegRowId,"�˺��˷� �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return false
					}else{
						this.SetLogMesage(0,RegRowId,"�˺��˷� �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return true
						
					}
				}
			}
			return true
	},
	//ҽ�����ηֽ���ý��л���
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
					if (rtnValue.rtnCode!="0") {
						dhcsys_alert("��ҽ������,�����˷ѽӿڵ���ʧ��:��"+rtnValue.rtnMsg+"��")
						this.SetLogMesage(-1,RegRowId,"��ҽ������ �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return false
					}else{
						this.SetLogMesage(0,RegRowId,"��ҽ������ �Һű�ID",ReceipRowid+"!"+StrikeRowID+"!"+newPrtRowID+"!"+expStr+"!"+RegRowId,JSON.stringify(rtnValue))
						return true
						
					}
				}
			}
			return true
	},
	//�Һ�ʧ�� �쳣�����Ѿ��շѵĶ���
	ErrReg:function()
	{
		 if (this.OpenFlag!="Y"){return true}
		 //�Һ��쳣֮�󣬴��ڵ�����������Ϣ����Ҫ�����˷ѽӿڡ�
		 if ((typeof this.PayRtnJsonObj.ETPRowID!="undefined")&&(this.PayRtnJsonObj.ETPRowID!="")) {
			 var patMesArry=this.PayUserMesage.split("!")
			 var payMode=patMesArry[0] //֧����ʽ
			 var tradeAmt=patMesArry[1] //�շѽ��
			 var expStr=patMesArry[2] //��չ����
			 var patDr=patMesArry[3] //������Ϣ
			 var expStrArrt=expStr.split("^")
			 var newexpStr=expStrArrt[0]+"^"+expStrArrt[1]+"^"+expStrArrt[2]+"^"+expStrArrt[3]
			 
			 var rtnstr=BankCardRefund(this.PayRtnJsonObj.ETPRowID,tradeAmt,"OP","D",payMode,newexpStr)
			 var rtnArry=rtnstr.split("^")
			 if (rtnArry[0]!="0"){
				 dhcsys_alert("�Һ�ʧ��,���÷��û��˽ӿ�,�˻�ʧ��!<br>"+"���ײ���:ETPRowID:"+this.PayRtnJsonObj.ETPRowID+" ���:"+tradeAmt+" ֧����ʽ:"+payMode+" ��չ:"+newexpStr)
				 this.SetLogMesage(-1,patDr,"�Һ�ʧ�ܻ��� ����PatDr",this.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,rtnstr)
				 return false
			 }
			 else{
				this.SetLogMesage(0,patDr,"�Һ�ʧ�ܻ��� ����PatDr",this.PayRtnJsonObj.ETPRowID+"!"+tradeAmt+"!"+payMode+"!"+newexpStr+"!"+patDr,rtnstr)
				return true
			 }
		 }	
	},
	//��־�ӿ�
	SetLogMesage:function(){
			if (this.Log!="Y"){return true}
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
			if ((this.LogOnlyError==1)&&(Statu==0)){
				return true
			}
			if (this.LogCacheOrLocal==1){
				//���ݿ���־
				var rtn=tkMakeServerCall("web.DHCOPAdmRegPay","SetLogMesage",ID,IDTypeDesc,PayMesage,PayRtn,Note,Logmesg,Statu);
			}else if (this.LogCacheOrLocal==1){
				//������־	
			}
			return true
	},
	
	//�ҺŽ���֧�����
	PayRtnJsonObj:"", 
	
	//֧�����׽ӿڵĽ��ײ���
	PayUserMesage:"",
	
	
	
}

