/*
Creater:	jm
CreateDate��2023-02-13
Description:�������ҽ��������תͳһ��װJS
*********************************************
<1>�������
������ת:��ָϵͳ����ҽԺ,����Ժ�ڴ����Ե��ӻ�����ʽͬ����ת��Ժ���ָ������ҩ��,����߿�ͨ��
	�õ��Ӵ����ڵ���Ϣ��ָ��ʵ��ҩ��������ƽ̨�����򵽰�������ҩ���ڵ����ҽҩ��Ʒ�Ĺ���.
˫ͨ��:��ָ������ҩ;����������ҽԺ�򶨵�ҩ��.ҽ������ͨ��"˫ͨ��",���ϻ����ܹ���������ҽ����̸��ҩ,
	���ͬʱ,���ϻ����ڶ���ҽҩ��������̸��ҩƷʱ�����ܵ�ҽ�������������ұ�������һ��.
<2>HIS���콨�鷽��(�ͽӿ�û�й�ϵ,��Ҫ��Ϊ�˶�����HIS������)
1������˫ͨ��ҩ���Ľ��տ���,�������ݽ��տ����ж��Ƿ��ϴ�
2���������༰��Ӧ��˫ͨ��ҩƷ,�������ּ�ά����Ӧ�Ľ��տ���;Ҳ����ʹ��ԭ������,����ԭ�����಻һ��������תĿ¼����
3�����յ�˫ͨ��ҩ����ҩƷ���п�浼��,��ΪҪȥԺ����ҩ,���п���ʹ��������(���漰ҽ���ӿ�,��Ϊ����ͨHIS���У������)
4��������ݶ���(����: ҽ��ҵ������->ҽ���ֵ�����->ҽ��ϵͳ���ã�����ʹ�ã�)
	drugmedcwaycodeCon00A	��ҩ;������ҽ��
	usedfrquCon00A			Ƶ�ζ���ҽ��
	PackUOMCon00			��λ����ҽ��
	ProfttlCon00A			ְ�ƶ���ҽ��
	CredTypeCon00A			֤�����Ͷ���ҽ��
<3>�ص�˵��
1��ҽ������ҽ����,��ҽ��վ�������,ҽ��������ϴ�,�ϴ���������������,��ҽ��վ�ṩ�ӿ�,�ӿڵ��óɹ������ݷ��ظ�ҽ��վ���б��档
2�����ҽ����:	�Զ�����Ԥ����->���ɴ���Base64��Ϣ->ǩ��->�ϴ�(�����:���·�CheckPrescPrint)
3������ҽ��ǰ:	��ȡ���д�ֹͣҽ��		##class(web.DHCOEOrdItem).GetOrdList
				�жϴ����Ƿ��Ѿ����	##class(web.DHCDocInPatPortalCommon).CheckMulOrdDealPermission
4������ҽ����:	�Զ����ó���(�����:���·�CheckPrescUndo)
5����ط�������
	�ӿڶ�����: DHCDoc.Interface.Inside.InsuPresc.Relate.cls
	**********������һ�ӿ�ǰ,���ȷ�����ļ����з���������ȷ����**********
	����HIS��: DHCDoc.Interface.Inside.InsuPresc.Order.cls
	  (1)�ж��Ƿ���е��Ӵ����ϴ�: CheckIsUpldByOrder
	  (2)��ӡģ�帳ֵ: GetPrintInfoByPrescNo
	  (3)���洦����ת����: SavePrescBaseData
	     ����: DOC.Interface.PrescBase.cls
	�����ϴ�XMLģ��: DHCOutPrescXYYBCFZX
6��Ŀǰ��ѯ����û�м��ɣ���Ҫ��������
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var DROutPrescObj = {
		Name:"DongRuan_OutPresc",
		OEOrd:{
			//ҽ��¼��-��˺�
			AfterUpdate:function(EpisodeID,OEOrdItemIDs) {
				OutPrescFuncs.CheckPrescPrint(EpisodeID,OEOrdItemIDs);
			}
		},
		CMOEOrd:{
			//�в�ҩ¼��-��˺�
			AfterUpdate:function(EpisodeID,OEOrdItemIDs) {
				//OutPrescFuncs.CheckPrescPrint(EpisodeID,OEOrdItemIDs);
			}
		},
		Funcs:{
			//ͣҽ��
			CheckPrescUndo:function(EpisodeID,OrdList) {
				OutPrescFuncs.CheckPrescUndo(EpisodeID,OrdList);
			},
			//���Ӵ�����Ϣ��ѯ
			hospRxDetlQuery:function(EpisodeID,PrescNo) {
				OutPrescFuncs.hospRxDetlQuery(EpisodeID,PrescNo);
			},
			//���Ӵ�����˽����ѯ
			rxChkInfoQuery:function(EpisodeID,PrescNo) {
				OutPrescFuncs.rxChkInfoQuery(EpisodeID,PrescNo);
			},
			//���Ӵ���ȡҩ�����ѯ
			rxSetlInfoQuery:function(EpisodeID,PrescNo) {
				OutPrescFuncs.rxSetlInfoQuery(EpisodeID,PrescNo);
			}
		}
	}
	Common_ControlObj.InterfaceArr.push(DROutPrescObj);
	//
	var OutPrescFuncs={
		LoginInfo: session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID'],
		CheckPrescPrint: function(EpisodeID,OEOrdItemIDs) {
			try{
				$.cm({
					ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
					MethodName:"GetPrescStrByOrdList",
					dataType:"text",
					OrderStr:OEOrdItemIDs
				},function(PrescStr){
					if (PrescStr=="") return;
					var PrescArr=PrescStr.split("^");
					for (var i = 0; i < PrescArr.length; i++) {
						var PrescNo=PrescArr[i];
						var Obj = {
							"EpisodeID":EpisodeID,
							"PrescNo":PrescNo,
							"UpldFlag":"Y"
						}
						OutPrescObj.uploadChk(Obj);
					}
				})
			}catch(e){
				dhcsys_alert("���Ӵ����ϴ��쳣:"+e.message);
			}
	    },
	    //Ԥ����
		uploadChk: function(Obj) {
	        $.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"uploadChk",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",Obj.PrescNo+" Ԥ����ʧ��:"+rtn.split("^")[1]);
					return false;
				}
				OutPrescObj.CreatePDFBase64(Obj);
			})
	    },
	    //����Base64ֵ
		CreatePDFBase64: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"GetPrintInfoByPrescNo",
				dataType:"text",
				EpisodeID:Obj.EpisodeID,PrescNo:Obj.PrescNo
			},function(JsonStr){
				if (JsonStr=="") {
					$.messager.alert("��ʾ",Obj.PrescNo+" "+"��ȡ��ӡ����ʧ��");
					OutPrescObj.LoadOrderListTab();
					return false;
				}
				var PrtObj = eval('(' + JsonStr + ')');
				var PrtXML = OutPrescObj.GetPrintXmlFromObj(PrtObj);
				//���û���ƽ̨�ӿ�,��������
				DHC_PrintByLodop("",PrtXML.MyPara,PrtXML.MyList,[],"DHCOutPrescXYYBCFZX",{
					printListByText: true,
					windowCloseOnBase64: true,
					onCreatePDFBase64: function(Base64Str) {
						if (Base64Str == "") {
							$.messager.alert("��ʾ",Obj.PrescNo+" "+"δ���ɴ���Base64����,�޷��ϴ�!");
							OutPrescObj.LoadOrderListTab();
							return false;
						}
						$.cm({
							ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
							MethodName:"SaveBase64",
							dataType:"text",
							PrescNo:Obj.PrescNo,Base64Str:Base64Str
						},function(rtn){
							if (rtn.split("^")[0]!="0") {
								$.messager.alert("��ʾ",Obj.PrescNo+" "+rtn.split("^")[1]);
								OutPrescObj.LoadOrderListTab();
								return false;
							}
							OutPrescObj.rxFixmedinsSign(Obj);
						}) 
					}
				});
			})
		},
		//���Ӵ���ҽ������ǩ��
		rxFixmedinsSign: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxFixmedinsSign",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",Obj.PrescNo+" ǩ��ʧ��:"+rtn.split("^")[1]);
					OutPrescObj.LoadOrderListTab();
					return false;
				}
				if (Obj.UpldFlag=="Y") {
					OutPrescObj.rxFileUpld(Obj);
				}
			})
		},
		//���Ӵ����ϴ�
		rxFileUpld: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxFileUpld",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",Obj.PrescNo+" �ϴ�ʧ��:"+rtn.split("^")[1]);
					OutPrescObj.LoadOrderListTab();
					return false;
				}
				$.messager.show({title:"��ʾ",msg:Obj.PrescNo+" "+"���Ӵ����ϴ��ɹ�!"});
				OutPrescObj.LoadOrderListTab();
			})
		},
		//���Ӵ�������
		CheckPrescUndo: function(EpisodeID,OrdList) {
			try{
				$.cm({
					ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
					MethodName:"GetPrescOrdListByStop",
					dataType:"text",
					EpisodeID:EpisodeID,OrderStr:OrdList
				},function(PrescOrdList){
					var SuccPrescStr=PrescOrdList.split("###")[1];
					if (SuccPrescStr=="") return;
					var PrescArr=SuccPrescStr.split("^");
					for (var i = 0; i < PrescArr.length; i++) {
						var PrescNo=PrescArr[i];
						var Obj = {
							"EpisodeID": EpisodeID,
							"PrescNo": PrescNo,
						};
						OutPrescObj.rxUndo(Obj);
					}
				})
			}catch(e){
				dhcsys_alert("���Ӵ��������쳣:"+e.message);
			}
	    },
		rxUndo: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxUndo",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",Obj.PrescNo+" ����ʧ��:"+rtn.split("^")[1]);
					return false;
				}
				$.messager.show({title:"��ʾ",msg:Obj.PrescNo+" "+"���Ӵ��������ɹ�!"});
				OutPrescObj.LoadOrderListTab();
			})
		},
		//���Ӵ�����Ϣ��ѯ
		hospRxDetlQuery: function(EpisodeID,PrescNo) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"hospRxDetlQuery",EpisodeID:EpisodeID,
				PrescNo:PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",PrescNo+" "+rtn.split("^")[1]);
					return false;
				}
				$.messager.alert("��ʾ",PrescNo+" "+"��Ϣ��ѯ�ɹ�:<br>"+rtn.split("^")[1]).window({width:1000,left:300});
			})
		},
		//���Ӵ�����˽����ѯ
		rxChkInfoQuery: function(EpisodeID,PrescNo) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxChkInfoQuery",EpisodeID:EpisodeID,
				PrescNo:PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",PrescNo+" "+rtn.split("^")[1]);
					return false;
				}
				$.messager.alert("��ʾ",PrescNo+" "+"��˽����ѯ�ɹ�:<br>"+rtn.split("^")[1]).window({width:1000,left:300});
			})
		},
		//���Ӵ���ȡҩ�����ѯ
		rxSetlInfoQuery: function(EpisodeID,PrescNo) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxSetlInfoQuery",EpisodeID:EpisodeID,
				PrescNo:PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("��ʾ",PrescNo+" "+rtn.split("^")[1]);
					return false;
				}
				$.messager.alert("��ʾ",PrescNo+" "+"ȡҩ�����ѯ�ɹ�:<br>"+rtn.split("^")[1]).window({width:1000,left:300});
			})
		},
		//ˢ�½���
		LoadOrderListTab: function() {
	        if (typeof LoadOrderListTabDataGrid == "function") {
	            LoadOrderListTabDataGrid()
	        }
		},
		//����Ԥ��(����ƽ̨�ӿ�)
		getPdf: function(PrescNo,Type) {
			try{
				/**
				 * ����base64���ַ�������PDF�ļ�Ԥ�����ɿ��������أ��ɴ�ӡ��
				 * @param {*} base64Str ע��Ҫ����ͷ���ַ���������data:application/pdf;base64,JVBEXXXXX...
				 */
				var base64Str=tkMakeServerCall("DHCDoc.Interface.Inside.InsuPresc.Order","GetPrescBase64",PrescNo,Type);
				if (base64Str=="") {
					$.messager.alert("��ʾ",PrescNo+" δ��ѯ����Ӧ��base64����");
					return false;
				}
				if (base64Str.indexOf("data:application/pdf;base64")==-1) {
					base64Str="data:application/pdf;base64,"+base64Str;
				}
				//�����ļ�������·������
				var href = '../scripts_lib/pdfjs-base64ToPDF/web/viewer.html';	
				window["base64String"] = base64Str;
				window.open(href, "pdf");
			}catch(e){
				dhcsys_alert("���Ӵ���Ԥ���쳣:"+e.message);
			}
		},
	    //������������Ϊxml��ӡ��Ҫ�ĸ�ʽ
		GetPrintXmlFromObj: function(PrintObj) {
	        var PInpara = "";
	        var PInlist = "";
	        for (var id in PrintObj) {
	            if (id == "MyList") {
	                PInlist = PrintObj[id];
	            } else {
	                if (PInpara == "") {
	                    PInpara = id + String.fromCharCode(2) + PrintObj[id]
	                } else {
	                    PInpara += "^" + id + String.fromCharCode(2) + PrintObj[id]
	                }
	            }
	        }
	        var PrintXml = {
	            MyPara: PInpara,
	            MyList: PInlist
	        }
	        return PrintXml;
	    }
	}
})
