/**
* CreateDate: 	2023-02-13 
* Version:		V2.0
* Creator:		nk
* ���̣� 		����ҽΪ������ҩ
* scripts/dhcdoc/interface/iMedical/HLYY.js
* Description:	��װ������ҩϵͳ��������ֹ������Ⱦ;�����÷������Ա�ҽ��¼��Ͳ�ҩ¼��ͬʱ����
* ��дjs,����ҽ��վ��׼�ӿڲ�淶��д
*
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var DHCHLYYObj = {
		Name:"iMedical_HLYY",
		//ҽ��¼��
		OEOrd:{
			Init:function(){
				DHCPass_Funcs.ShowAuditPopProcess();	
			},
			//���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPass_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			}
		},
		//�в�ҩ¼��
		CMOEOrd:{
			Init:function(){
				DHCPass_Funcs.ShowAuditPopProcess();	
			},
			//���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				DHCPass_Funcs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			}
		},
		Funcs:{
			//�໥����(���ڵ���໥���ð�ťʱ����)
			XHZY:function(EpisodeID) {
				var e = window.event || e;
				if (!e) return;
				if (!e.currentTarget) return;
				if (e.currentTarget.id!="XHZY") return;
				DHCPass_Funcs.XHZY(EpisodeID);
			},
			//˵����
			YDTS:function(ARCIMRowid) {
				try{
					DHCPass_Funcs.YDTS(ARCIMRowid);
				}catch(e){
					$.messager.alert("����","������ҩ˵�����쳣:"+e.message,"error");
				}	
			},
			//ҽΪ����Ϣ֪ͨ
			ShowAuditPopProcess:function(){
				DHCPass_Funcs.ShowAuditPopProcess();	
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(DHCHLYYObj)
	//
	var DHCPass_Funcs={
		//ҽΪ����Ϣ֪ͨ
		ShowAuditPopProcess:function(){
			//Modify20230224 �ѶԽ���ϵͳ
			/*
			try{
				_openShowAuditPopProcess({"userType":"Doc"});	
			}catch(e){
				
			}
			*/
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			$.extend(GlobalObj,{
				hlyy_pdss_chkInfo:""	
			})
			new Promise(function(resolve){
				try{
					DHCPass_Funcs.DHCXHZY(EpisodeID,OrderItemStr,resolve,HLYYLayOut);
				}catch(e){
					$.messager.alert("��ʾ", "ҽΪ������ҩ�Զ���֤ͨ��:"+e.message, "info",function(){
						resolve(true);
					});
				}
			}).then(function(HLYYInfo){
				if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
					//����Ҫ���ú�����ҩ���߳����쳣
					CallBackFunc({SuccessFlag:true,UpdateFlag:false});
					return;
				}
				GlobalObj.hlyy_pdss_chkInfo=HLYYInfo.MsgID+"&"+HLYYInfo.manLevel+"&"+HLYYInfo.passFlag+"&"+HLYYInfo.manLev;
				//ͨ��������ҩ�ķ����޸ĺ�ǿ����˲������ж�pdssFlag��ֵ������1��ֱ������ҽ��������0��������ҽ��
				if (HLYYInfo.passFlag=="1") {
					var UpdateOrderItemStr=DHCPass_Funcs.ResetOrderItemStr(OrderItemStr,HLYYInfo.drugUniqueStr,HLYYLayOut);
					CallBackFunc({
						SuccessFlag:true,
						UpdateFlag:true,
						OrderItemStr:UpdateOrderItemStr,
						UpdateOrderItemStr:UpdateOrderItemStr
					});
				}else if (HLYYInfo.passFlag=="0"){
					CallBackFunc({
						SuccessFlag:false,
						UpdateFlag:false
					});
				}else{
					$.messager.confirm('ȷ�϶Ի���',"������ҩ��Ԥϵͳ�쳣!"+"<br>"+"����ϵ��Ϣ����!��ȷ�����ҽ��������ȷ����", function(r){
						if (r) {
							//var UpdateOrderItemStr=DHCPass_Funcs.ResetOrderItemStr(OrderItemStr,HLYYInfo.drugUniqueStr,HLYYLayOut);
							CallBackFunc({
								SuccessFlag:true,
								UpdateFlag:false
								//UpdateOrderItemStr:UpdateOrderItemStr
							});
						}else{
							CallBackFunc({SuccessFlag:false,UpdateFlag:false});
						}
					});
				}
				return;
			});
		},
		//���ҽ��(�ϲ�ҽ��¼��/�в�ҩ¼��,��̨�������)
		DHCXHZY:function (EpisodeID,OrderItemStr,CallBackFunc,HLYYLayOut){
			var ScreenDataObj=DHCPass_Funcs.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);

			var PdssObj=ScreenDataObj.Patient;
			if(!PdssObj){CallBackFunc(); return "";}	
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
				DHCPdss.refresh(PdssObj, resolve, 1);  /// �������ӿ�
				if  (DHCPdss.passFlag==1) resolve(DHCPdss);
			}).then(function(PdssOption){
				if(typeof CallBackFunc == "function"){
					CallBackFunc(PdssOption);
				}
			});
		},
		//�໥����
		XHZY:function (EpisodeID){
			new Promise(function(resolve,rejected){
				GetOrderDataOnAdd(resolve);
			}).then(function(OrderItemStr){
				if (OrderItemStr=="") {
					$.messager.alert("��ʾ","û���¿�ҽ��");
					return false;
				}
				var HLYYLayOut=GlobalObj.HLYYLayOut;
	    		DHCPass_Funcs.DHCXHZY(EpisodeID,OrderItemStr,"",HLYYLayOut);
			})
		},
		YDTS:function (ARCIMRowid){
			if ((typeof ARCIMRowid=="undefined")||(ARCIMRowid==null)||(ARCIMRowid=="")) {
				$.messager.alert("����","��ѡ��һ��ҽ��");  
				return;  
			}
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",ARCIMRowid);
			var ArcimInfoAry=ArcimInfo.split("^");
			var OrderARCIMCode=ArcimInfoAry[0];
			var OrderName=ArcimInfoAry[1];
			DHCPass_Funcs.DHCYDTS(OrderARCIMCode,OrderName);
		},
		//˵����
		DHCYDTS:function(OrderARCIMCode,OrderName){
			var IncId=""
			//linkUrl="dhcckb.wiki.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName;
			var linkUrl="dhcckb.pdss.instruction.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName
			websys_showModal({
				url:linkUrl,
				title:$g('ҩƷ˵����'),
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		},
		HisScreenData:function (EpisodeID,OrderItemStr,HLYYLayOut){
			//�û�id^����id^Ժ��id^ϵͳģʽ(�������ֻ�����ҽԺ,ǰ̨¼���Ϊ��)
			var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.GROUPID'];
			var PrescObj=$.cm({
				ClassName:"web.DHCDocHLYYDHC",
				MethodName:"GetPrescInfo",
				EpisodeID:EpisodeID,
				Action:"",
				OrderItemStr:OrderItemStr,
				HLYYLayOut:HLYYLayOut,
				ExpStr:ExpStr
			},false)
			if (PrescObj.ResultCode=="-1") {
				$.messager.alert("��ʾ",PrescObj.ResultContent);
				return false;
			}
			if(JSON.stringify(PrescObj) == "{}"){
				return false;	
			}
			return PrescObj;
		},
		ResetOrderItemStr:function(OrderItemStr,MedHLYYInfo,HLYYLayOut){
			//��������ҩ�����Ϣ���µ�ҽ������
			if(typeof(MedHLYYInfo)!="undefined"){
				var MedHLYYNeedMatchAry=new Array();
				//ҩƷΨһ��ʶ��  unique(ҩƷΨһ��ʶ-��ȫ��ҩ����)_"^"_arciId(ҽ����id)_"^"_seqNo(ҽ�����)_"^"_drugPassFlag(ҩƷͨ����־Y/N)
				//������ʶ����!!�ָ�
				var MedHLYYArr=MedHLYYInfo.split("!!");
	            for (var i=0;i<MedHLYYArr.length;i++) {
	                var oneMedHLYYArr=MedHLYYArr[i].split('^');
	                var MedHLYY_unique=oneMedHLYYArr[0];
	                var MedHLYY_SeqNo=oneMedHLYYArr[2];
	                var oneMedHLYY=oneMedHLYYArr.join(String.fromCharCode(3)); //��ҩ�õ�$c(2)
	                MedHLYYNeedMatchAry[MedHLYY_SeqNo]=oneMedHLYY;
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
		                if (MedHLYYNeedMatchAry[OrderSeqNo]) {
			                //���󷽷�����Ϣƴ��������ҩ�����Ϣ�ֶΣ���̨��Ҫ�ش�����ϵͳ
			                //֮��������������ϵͳҲҪ���淵��ֵ
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[0]=MedHLYYNeedMatchAry[OrderSeqNo];
			                oneOrderItemAry[17]=OrderHLYYInfoAry.join(String.fromCharCode(4));;
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
		                if (MedHLYYNeedMatchAry[OrderSeqNo]) {
			                //��������ҩ�����Ϣƴ��������ҩ�����Ϣ�ֶΣ���̨��Ҫ�ش���������ҩϵͳ
			                //֮��������������ϵͳҲҪ���淵��ֵ
			                var OrderHLYYInfoAry=OrderHLYYInfo.split(String.fromCharCode(4));
			                OrderHLYYInfoAry[0]=MedHLYYNeedMatchAry[OrderSeqNo];
			                
			                oneOrderItemAry[92]=OrderHLYYInfoAry.join(String.fromCharCode(4));
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
