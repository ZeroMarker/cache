/**
* CreateDate: 	2023-02-24
* Version:		V1.0
* Creator:		nk
* ���̣� 		����ҽΪ��ϵͳ
* scripts/dhcdoc/interface/iMedical/PrescAudit.js
* Description:	��װ��ϵͳ����
* 				��дjs,����ҽ��վ��׼�ӿڲ�淶��д
*
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var _m_DHCPrescAudit_AdtMsgID="";
	var DHCPrescAuditObj = {
		Name:"iMedical_PrescAudit",
		//ҽ��¼��
		OEOrd:{
			Init:function(){
			},
			//���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPrescAudit_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			}
		},
		//�в�ҩ¼��
		CMOEOrd:{
			Init:function(){
			},
			//���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPrescAudit_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			}
		},
		Funcs:{
			//ҽΪ����Ϣ֪ͨ
			ShowAuditPopProcess:function(){
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(DHCPrescAuditObj)
	//
	var DHCPrescAudit_Funcs={
		//ҽΪ����Ϣ֪ͨ
		ShowAuditPopProcess:function(){
			
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			new Promise(function(resolve){
				try{
					DHCPrescAudit_Funcs.DHCAudit(EpisodeID,OrderItemStr,resolve,HLYYLayOut);
				}catch(e){
					$.messager.alert("��ʾ", "ҽΪ��ϵͳ�Զ���֤ͨ��:"+e.message, "info",function(){
						resolve(true);
					});
				}
			}).then(function(AuditObj){
				/**
				*���ؽ��
				* option:����˵��
				* option.AdtMsgID���ڵ�һ�ε��ô�����˽ӿں󣬷��صĶ�������һ��AdtMsgID, ֮���ÿһ�ε��ö���Ҫ��AdtMsgIDֵ��ֵ�������Ϣ�н��е��ã�ֱ������ˢ�»���ҽ�����ɺ�,AdtMsgIDҪ��Ϊ�ա�
				* option.AdtPassFlag:Y(ҩʦ���ͨ��) A(�Զ����ͨ��) N(��˲�ͨ�����ҽ�����)
				* option.AdtUniqueStr="";  // ҩƷΨһ��ʶ��  unique(��ˮ��)_"^"_arciId(ҽ����id)_"^"_seqNo(ҽ�����)_"^"_drugPassFlag(ҩƷͨ����־Y/N)������ʶ����!!�ָ�
				*/
				if ((AuditObj=="")||(AuditObj==null)||(typeof AuditObj=="undefined")) {
					//����Ҫ���ú�����ҩ���߳����쳣
					CallBackFunc({SuccessFlag:true,UpdateFlag:false});
					return;
				}
				if (AuditObj.AdtPassFlag=="N") {
					_m_DHCPrescAudit_AdtMsgID = AuditObj.AdtMsgID;
					$.messager.popover({msg:"��ϵͳҩʦ�ܾ����,��ȷ��.",type:"success",timeout:2000});
					CallBackFunc({
						SuccessFlag:false,UpdateFlag:false
					});
				}
				else if (AuditObj.AdtPassFlag=="Y" || AuditObj.AdtPassFlag=="A") {
					var UpdateOrderItemStr=DHCPrescAudit_Funcs.ResetOrderItemStr(OrderItemStr,AuditObj,HLYYLayOut);
					CallBackFunc({
						SuccessFlag:true,
						UpdateFlag:true,
						OrderItemStr:UpdateOrderItemStr,
						UpdateOrderItemStr:UpdateOrderItemStr
					});
					_m_DHCPrescAudit_AdtMsgID="";
				}else{
					$.messager.confirm('ȷ�϶Ի���',"ҽΪ��ϵͳϵͳ�쳣!"+"<br>"+"����ϵ��Ϣ����!��ȷ�����ҽ��������ȷ����", function(r){
						if (r) {
							//var UpdateOrderItemStr=DHCPrescAudit_Funcs.ResetOrderItemStr(OrderItemStr,AuditObj,HLYYLayOut);
							CallBackFunc({
								SuccessFlag:true,
								UpdateFlag:false
								//UpdateOrderItemStr:UpdateOrderItemStr
							});
							_m_DHCPrescAudit_AdtMsgID="";
						}else{
							CallBackFunc({SuccessFlag:false,UpdateFlag:false});
						}
					});
				}
				return;
			});
		},
		//���ҽ��(�ϲ�ҽ��¼��/�в�ҩ¼��,��̨�������)
		DHCAudit:function (EpisodeID,OrderItemStr,CallBackFunc,HLYYLayOut){
			var ScreenDataObj=DHCPrescAudit_Funcs.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);

			var PdssObj=ScreenDataObj.Patient;
			if(!PdssObj){
				CallBackFunc();
				return "";
			}	
			PdssObj.ItemDis=ScreenDataObj.ScreenDiagList.Diagnoses;
			PdssObj.ItemOrder=ScreenDataObj.ScreenDrugList.OrderDrugs;
			if(PdssObj.ItemOrder=="" || PdssObj.ItemOrder.length==0){
				CallBackFunc();
				return "";
			}
			PdssObj.ItemHisOrder=ScreenDataObj.HisOrderList.OrderDrugs;
			PdssObj.ItemAyg=ScreenDataObj.ScreenAllergenList.Allergens;
			PdssObj.ItemOper=ScreenDataObj.ScreenOperationsList.Operations;
			PdssObj.UseType="Doc";
			new Promise(function(resolve){
				var DHCPdss = new PDSS({});
				var pdss_chkInfo=GlobalObj.hlyy_pdss_chkInfo;
				if(typeof pdss_chkInfo == "undefined")pdss_chkInfo="1";
				DHCPdss.audit(PdssObj, resolve, pdss_chkInfo);  /// �������ӿ�
			}).then(function(PdssOption){
				if(typeof CallBackFunc == "function"){
					CallBackFunc(PdssOption);
				}
			});
		},
		HisScreenData:function (EpisodeID,OrderItemStr,HLYYLayOut){
			//�û�id^����id^Ժ��id^��ȫ��id^ϵͳģʽ(�������ֻ�����ҽԺ,ǰ̨¼���Ϊ��)^�󷽻ص�ID
			var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.GROUPID']+"^";
				ExpStr=ExpStr+"^"+_m_DHCPrescAudit_AdtMsgID;
			var PrescObj=$.cm({
				ClassName:"web.DHCDocHLYYDHC",
				MethodName:"GetPrescInfo",
				EpisodeID:EpisodeID,
				Action:"Audit",
				OrderItemStr:OrderItemStr,
				HLYYLayOut:HLYYLayOut,
				ExpStr:ExpStr
			},false)
			//console.log(PrescJSON)
			if (PrescObj.ResultCode=="-1") {
				$.messager.alert("��ʾ",PrescObj.ResultContent);
				return false;
			}
			if(JSON.stringify(PrescObj) == "{}"){
				return false;	
			}
			return PrescObj;
		},
		ResetOrderItemStr:function(OrderItemStr,MedAuditObj,HLYYLayOut){
			var _m_AdtMsgID=MedAuditObj.AdtMsgID;
			var MedAuditInfo=MedAuditObj.AdtUniqueStr;
			//������Ϣ���µ�ҽ������
			if(typeof(MedAuditInfo)!="undefined"){
				var MedAuditNeedMatchAry=new Array();
				//ҩƷΨһ��ʶ��  unique(ҩƷΨһ��ʶ-��ȫ��ҩ����)_"^"_arciId(ҽ����id)_"^"_seqNo(ҽ�����)_"^"_drugPassFlag(ҩƷͨ����־Y/N)
				//������ʶ����!!�ָ�
				var MedAuditArr=MedAuditInfo.split("!!");
	            for (var i=0;i<MedAuditArr.length;i++) {
	                var oneMedAudit=MedAuditArr[i].split('^');
	                var MedAudit_unique=oneMedAudit[0];
	                var MedAudit_SeqNo=oneMedAudit[2];
	                var MedAudit_drugPassFlag=oneMedAudit[3];
	                var oneMedHLYY=oneMedAudit.join(String.fromCharCode(3));
	                MedAuditNeedMatchAry[MedAudit_SeqNo]={
		                drugPassFlag: MedAudit_drugPassFlag,
		                chkInfo: oneMedHLYY
	                }
	            }
	            var MaxOrderSeqNo="";
				if(HLYYLayOut=="CMOEOrd"){
					var PrescOrderItemAry=OrderItemStr.split(String.fromCharCode(2));
					var tmpOrderItemStr=PrescOrderItemAry[1];
					var OrderItemAry=tmpOrderItemStr.split(String.fromCharCode(1));
		            for (var i=0;i<OrderItemAry.length;i++) {
		                var oneOrderItemAry=OrderItemAry[i].split('^');
		                var ArcimId=oneOrderItemAry[0];
		                var OrderSeqNo=oneOrderItemAry[7];
		                var OrderHLYYInfo=oneOrderItemAry[17];
		                if (MedAuditNeedMatchAry[OrderSeqNo]) {
			                //���󷽷�����Ϣƴ��������ҩ�����Ϣ�ֶΣ���̨��Ҫ�ش�����ϵͳ
			                //֮�����������Ǻ�����ҩϵͳҲҪ���淵��ֵ
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[1]=MedAuditNeedMatchAry[OrderSeqNo].chkInfo;
			                
			                oneOrderItemAry[17]=OrderHLYYInfoAry.join(String.fromCharCode(4));
			                oneOrderItemAry[18]=MedAuditNeedMatchAry[OrderSeqNo].drugPassFlag;
		                }
		                MaxOrderSeqNo=OrderSeqNo;
		                var oneOrderItemStr=oneOrderItemAry.join('^');
		                OrderItemAry[i]=oneOrderItemStr
		            }
		            var tmpOrderItemStr=OrderItemAry.join(String.fromCharCode(1));
		            PrescOrderItemAry[1]=tmpOrderItemStr;
		            OrderItemStr=PrescOrderItemAry.join(String.fromCharCode(2));
				}else{
					var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
		            for (var i=0;i<OrderItemAry.length;i++) {
		                var oneOrderItemAry=OrderItemAry[i].split('^');
		                var ArcimId=oneOrderItemAry[0];
		                var OrderSeqNo=oneOrderItemAry[19];
		                var OrderHLYYInfo=oneOrderItemAry[92];
		                if(typeof OrderHLYYInfo == 'undefined')OrderHLYYInfo="";
		                if (MedAuditNeedMatchAry[OrderSeqNo]) {
			                //���󷽷�����Ϣƴ��������ҩ�����Ϣ�ֶΣ���̨��Ҫ�ش�����ϵͳ
			                //֮�����������Ǻ�����ҩϵͳҲҪ���淵��ֵ
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[1]=MedAuditNeedMatchAry[OrderSeqNo].chkInfo;
			                
			                oneOrderItemAry[92]=OrderHLYYInfoAry.join(String.fromCharCode(4));
			                oneOrderItemAry[94]=MedAuditNeedMatchAry[OrderSeqNo].drugPassFlag;
		                }
		                MaxOrderSeqNo=OrderSeqNo;
		                var oneOrderItemStr=oneOrderItemAry.join('^');
		                OrderItemAry[i]=oneOrderItemStr
		            }
		            OrderItemStr=OrderItemAry.join(String.fromCharCode(1));
				}
	            
	            return OrderItemStr;
			}else{
				return OrderItemStr;	
			}	
		}
	}
})
