/*
Creater:	jm
CreateDate��2023-02-01
Description:�������׺�����ҩͳһ��װJS
*********************************************
* 1.�ӿڶԽ�ģʽ:���̶�ID+����ͨ
* 2.ҽ�����ǰ�������ӿ�,ҽ����˺�����󷽽ӿ�
	 ����ֱ�ӵ����󷽽���(dhcdoc.hlyyhzyy.opexam.csp),ҽ���ȴ��󷽽��
	 סԺ�����Ҳ˵�(dhcdoc.hlyyhzyy.ipexam.csp),ҽ���������в鿴�󷽽���;ͬʱ֧��ʵʱ��,�·�157�����μ���
* 3.�ṩ�����������������ݻ�д�ķ���,�����XML��ʽ
	 ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SaveExamResult
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var HZYYHLYYObj = {
		Name:"HangZhouYiYao_HLYY",
		//ҽ��¼��
		OEOrd:{
			//��ʼ��
			xhrRefresh:function(EpisodeID,PAAdmType) {
				PassFuncs.xhrRefresh(EpisodeID,PAAdmType);
			},
			//ҽ��¼��-���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			},
			//ҽ��¼��-��˺�
			AfterUpdate:function(EpisodeID,PAAdmType,OEOrdItemIDs) {
				PassFuncs.AfterUpdate(EpisodeID,PAAdmType,OEOrdItemIDs);
			}
		},
		CMOEOrd:{
			//�в�ҩ¼��-���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			},
			//�в�ҩ¼��-��˺�
			AfterUpdate:function(EpisodeID,PAAdmType,OEOrdItemIDs) {
				PassFuncs.AfterUpdate(EpisodeID,PAAdmType,OEOrdItemIDs);
			}
		},
		Funcs:{
			//˵����
			YDTS:function(rowid) {
				PassFuncs.YDTS(rowid);
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(HZYYHLYYObj)
	//
	var PassFuncs={
		LoginInfo:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'],
		//��ʼ��
		xhrRefresh:function(EpisodeID,PAAdmType) {
			//����ż������δ����Ĵ���,�˴��Զ����� ��Ŀ�����Ƿ�����
			if (PAAdmType=="I") return;
			var PrescNoStr=$.cm({
				ClassName:"web.DHCDocHLYYHZYY",
				MethodName:"GetPrescNoStrByAdm",
				dataType:"text",
				EpisodeID:EpisodeID
			},false);
			if (PrescNoStr=="")  return;
			PassFuncs.ShowExamResult(EpisodeID,PAAdmType,PrescNoStr);
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			try{
				var HLYYInfo=$.cm({
					ClassName:"web.DHCDocHLYYHZYY",
					MethodName:"CheckHLYYInfo",
					dataType:"text",
					EpisodeID:EpisodeID,
					OrderItemStr:OrderItemStr,
					HLYYLayOut:HLYYLayOut,
					ExpStr:PassFuncs.LoginInfo
				},false);
				//����Ҫ���ú�����ҩ���߳����쳣
				if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
					CallBackFunc(true);
					return;
				}
				var HLYYArr=HLYYInfo.split("^");
				if (HLYYArr[0]==0){		//����ȼ�<8
					if (HLYYArr[1]!="") {
						$.messager.confirm('ȷ�϶Ի���',"������ҩ��ʾ:"+"<br>"+HLYYArr[1]+"<br>"+"�Ƿ�������?", function(r){
							if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
						});
					}else{
						CallBackFunc(true);
					}
				}else if (HLYYArr[0]=="-1"){	//����ȼ�>=8
					$.messager.alert("��ʾ","������ҩ��ʾ:"+"<br>"+HLYYArr[1]+"<br>"+"�뷵���޸�","info",function(){
						CallBackFunc(false);
					});
				}else{
					$.messager.confirm('ȷ�϶Ի���',"������ҩ��Ԥϵͳ�쳣:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����", function(r){
						if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
					});
				}
				return;
			}catch(e){
				$.messager.alert("��ʾ","������ҩ�Զ���֤ͨ��:"+e.message,"info",function(){
					CallBackFunc(true);
				});
			}
		},
		AfterUpdate:function(EpisodeID,PAAdmType,OEOrdItemIDs){
			try{
				var HLYYInfo=$.cm({
					ClassName:"web.DHCDocHLYYHZYY",
					MethodName:"SaveHLYYInfo",
					dataType:"text",
					EpisodeID:EpisodeID,
					OrderStr:OEOrdItemIDs,
					ExpStr:PassFuncs.LoginInfo
				},false);
				//����Ҫ���ú�����ҩ���߳����쳣
				if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) return;
				//
				var HLYYArr=HLYYInfo.split("^");
				if (HLYYArr[0]!=0){
					$.messager.alert("��ʾ","������ҩ����ӿڵ���ʧ��:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!");
					return false;
				}
				//������ϵͳ-��ʹ�ÿ�����
				PassFuncs.Exam(EpisodeID,PAAdmType,OEOrdItemIDs);
			}catch(e){
				$.messager.alert("��ʾ","������ҩϵͳ�쳣:"+e.message);
				return false;
			}
		},
		Exam:function(EpisodeID,PAAdmType,OEOrdItemIDs){
			var HLYYInfo=$.cm({
				ClassName:"web.DHCDocHLYYHZYY",
				MethodName:"ExamHLYYInfo",
				dataType:"text",
				EpisodeID:EpisodeID,
				OrderStr:OEOrdItemIDs,
				ExpStr:PassFuncs.LoginInfo
			},false);
			//����Ҫ���ú�����ҩ���߳����쳣
			if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) return;
			//
			var HLYYArr=HLYYInfo.split("^");
			if (HLYYArr[0]!=0){
				$.messager.alert("��ʾ","������ҩ�󷽽ӿڵ���ʧ��:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!");
				return false;
			}
			//�����󷽽��
			PassFuncs.Limit(EpisodeID,PAAdmType,OEOrdItemIDs);
		},
		Limit:function(EpisodeID,PAAdmType,OEOrdItemIDs){
			if (PAAdmType=="I"){
				//dhcsys_alert("������ҩ�󷽽ӿڵ��óɹ�,���л���Ӧ����鿴���");
				return false;
				var OrderItemStr=$.m({
				    ClassName:"web.DHCDocHLYYHZYY",
				    MethodName:"GetOrderItemStr",
				    OEOrdItemIDs:OEOrdItemIDs,
				},false);
				var PrescNoStr="";
			}else{
				var OrderItemStr="";
				var PrescNoStr=$.cm({
					ClassName:"web.DHCDocHLYYHZYY",
					MethodName:"GetPrescNoStrByOrder",
					dataType:"text",
					OrderStr:OEOrdItemIDs
				},false);
			}
			//�ж��Ƿ��Ѿ��Զ�ͨ��
			var rtn=$.m({
			    ClassName:"web.DHCDocHLYYHZYY",
			    MethodName:"CheckBeforeUse",
			    EpisodeID:EpisodeID,
			    OEORIRowIdStr:OrderItemStr,
				PrescNoStr:PrescNoStr
			},false);
			if (rtn.split("^")[0]=="0") return;
			PassFuncs.ShowExamResult(EpisodeID,PAAdmType,PrescNoStr,OrderItemStr);
		},
		//չʾ�󷽽��
		ShowExamResult:function(EpisodeID,PAAdmType,PrescNoStr,OrderItemStr){
			var src="dhcdoc.hlyyhzyy.opexam.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+PrescNoStr;
			if (PAAdmType=="I") {
				src="dhcdoc.hlyyhzyy.ipexam.csp?EpisodeID="+EpisodeID+"&OrderItemStr="+OrderItemStr;
			}
		 	websys_showModal({
				url:src,
				title:'������',
				width:screen.availWidth-400,
				height:screen.availHeight-200,
				closable:false,
				HYLLStopOrd:function(EpisodeID,PrescNo,CallBackFun){
					new Promise(function(resolve,rejected){
						var rtn=$.m({
						    ClassName:"web.DHCDocHLYYHZYY",
						    MethodName:"CheckPrescExistOrder",
						    PrescNo:PrescNo
						},false);
						if (rtn.split("!")[0]=="1") {
							if (typeof StopPrescList == "function") {
								StopPrescList(PrescNo,resolve)
							}else{
								StopOrd([],resolve,rtn.split("!")[1]);
							}
						}else{
							CallBackFun(true);
							return;
						}
					}).then(function(){
						//����ͬ��
						if (typeof ReloadGrid == "function") { ReloadGrid("StopOrd"); }
						if (typeof SetScreenSum == "function") { SetScreenSum(); }
						if (typeof OrderMsgChange == "function") { OrderMsgChange(); }
						if (typeof SaveOrderToEMR == "function") { SaveOrderToEMR(); }
					    //������ҩ֪ͨ
						$.m({
							ClassName:"web.DHCDocHLYYHZYY",
							MethodName:"SignHLYYInfo",
							EpisodeID:EpisodeID,DataStr:PrescNo,SignNotes:"",
							UserID:session['LOGON.USERID'],OperType:"U"
						},function(val){
							//
						});
					    CallBackFun(true);
					})
				}
			});
		},
		//˵����
		YDTS:function(rowid){
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				if(!rowid){
					var ids=$('#Order_DataGrid').jqGrid("getGridParam","selarrrow");
					if(!ids.length){
						$.messager.alert("����","��ѡ��һ��ҽ��");  
						return;
					}
					rowid=ids[0];
				}
				var OrderARCIMRowid=GetCellData(rowid,"OrderARCIMRowid");
			}else{
				var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
			}
			if ((typeof OrderARCIMRowid=="undefined")||(OrderARCIMRowid==null)||(OrderARCIMRowid=="")) {
				$.messager.alert("����","��ѡ��һ��ҽ��");  
				return;  
			}
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
			var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
			var OrderName=mPiece(ArcimInfo,"^",1);
			var linkUrl="http://10.0.20.127:9999/pages/zlcx/data-detail.html?webHisId="+OrderARCIMCode+"&hospitalCode=HBZSYZXYY"
			websys_showModal({
				url:linkUrl,
				title:'ҩƷ˵����',
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		}
	}
})
