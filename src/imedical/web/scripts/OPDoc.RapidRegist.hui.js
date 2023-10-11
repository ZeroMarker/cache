if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
$(function(){
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//�¼���ʼ��
	InitEvent();
});
function InitEvent(){
   $("#RegistSave").click(SaveClickHandler);
   $("#BReadCard").click(ReadCardClickHandler);
   document.onkeydown = DocumentOnKeyDown;
}
function PageHandle(){
	InitDeptList();
	$("#CardNo").focus();
	LoadRegConDisList()
	LoadPayMode();
}
function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			PatNoKeydownHandler(e);
			return false;
		}
		return true;
	}
}
function InitDeptList(){
	$.cm({
		ClassName:"web.DHCDoc.OP.PatConfigQuery",
		QueryName:"GetOPDeptStr",
		UserId:session['LOGON.USERID'],
		AdmType:ServerObj.AdmType,
		LocId:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#LocList", {
			valueField: 'ID',
			textField: 'DESC', 
			panelHeight:'126',
			disabled:true,
			data: jsonData.rows,
			filter: function(q, row){
				return (row["DESC"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect: function (rec) {
				var LocId=rec.ID;
				LoadMarkDocList(LocId);
				LoadRegConDisList();
			},
			onChange:function(newValue,oldValue){
				if (newValue==""){
					var sbox = $HUI.combobox("#MarkDocList");
					sbox.select("");
				}
			},
			onLoadSuccess:function(){
				var sbox = $HUI.combobox("#LocList");
					sbox.select(session['LOGON.CTLOCID']);
			}
	   });
    });
}
function LoadRegConDisList() {
	var DepRowId=$('#LocList').combobox('getValue');
	var DocRowId=$('#MarkDocList').combobox('getValue');
	var ExpStr=DepRowId+"^"+DocRowId;
	$.m({
		ClassName:"web.DHCRegConDisCount", 
		MethodName:"ReadDHCRegConDisCountBroker",
		JSFunName:"GetRegConToHUIJson",
		ListName:"",
		PatientID:$('#PatientID').val(),
		BillTypeID:"",
		ExpStr:ExpStr
	},function(Data){
		var cbox = $HUI.combobox("#RegConDisList", {
				valueField: 'id',
				textField: 'text', 
				panelHeight:'160',
				editable:true,
				data: JSON.parse(Data),
		})
	})
}
function LoadMarkDocList(LocId){
	$.q({
		ClassName:"web.DHCDoc.OP.PatConfigQuery",
		QueryName:"FindDocMarkStr",
		UserId:session['LOGON.USERID'],
		LocID:LocId,
		rows:99999
   },function(jsonData){
	   var cbox = $HUI.combobox("#MarkDocList", {
			valueField: 'ID',
			textField: 'DESC',
			panelHeight:'126',
			//value:defaultReg,
			data: jsonData.rows,
			onSelect: function (rec) {
				LoadRegConDisList();
			},
			onLoadSuccess:function(data){
				//��ǰ��¼ҽ�������г�����Դ(����ʱ��)Ĭ�ϵ�ǰҽ��
				/*
				    ��ǰ��¼ҽ�������޳�����Դ,��ҽ���ű�����г�����Դ����Ĭ�ϴ˳���ű�.
					�����Ӧ����ű𣬽���һ���ű��г�����ԴĬ�ϴ˺ű�.
					����ű�����ж���ű���Ĭ��Ϊ��
				*/
				//��ǰ��¼ҽ�����ű���վ��޳�����Դ,����ҽ���ű����Ĭ��
				var RBResRowIdStr="";
				var data=$(this).combobox('getData');
				for (var i=0;i<data.length;i++){
					var ResRowid=data[i].ResRowID;
					if (RBResRowIdStr=="") RBResRowIdStr=ResRowid;
					else  RBResRowIdStr=RBResRowIdStr+"^"+ResRowid;
				}
				if(RBResRowIdStr!=""){
					$.m({
						ClassName:"web.DHCDoc.OP.PatConfigQuery",
						MethodName:"GetDefaultResource",
						UserID:session['LOGON.USERID'],
						RBResRowIdStr:RBResRowIdStr
				   },function(defaultReg){
					   if (defaultReg!=""){
							$("#MarkDocList").combobox('select',defaultReg);
						}
				   })
				}
			}
	   });
   });
}
function CardNoKeydownHandler(e){
   var key=websys_getKey(e);
   var CardNo=$("#CardNo").val();
   if (key==13) {
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
		return false;
   }
}
function CardTypeCallBack(myrtn){
    var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			$("#CardTypeRowID").val(myary[8]);
			$("#Securityno").val(myary[2]);
			SetPatientInfo(PatientNo,CardNo,PatientID);
			event.keyCode=13;			
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч!","info",function(){
				$("#CardNo").focus();
			});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardTypeRowID").val(myary[8]);
			$("#Securityno").val(myary[2]);
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			SetPatientInfo(PatientNo,CardNo,PatientID);
			event.keyCode=13;
			break;
		default:
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	if (CardNo!="") {
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, $("#CardTypeRowID").val())
		if (TemporaryCardFlag=="Y") {
			$.messager.alert("��ʾ","��ʱ�����ܽ��о���Ǽ�!")
			$("#CardNo,#PatName,#PatNo").val("");
			return false;
		}
	}
	$("#PatientID").val(PatientID);
	if (PatientID==""){
		ClearPatInfo();
		return;
	}
	var PatInfo=$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "GetPatDetailBroker",
	    dataType:"text",
	    itmjs:"",
	    itmjsex:"GetPatDetailToHUI",
	    val:PatientNo,
    },false);
    if (PatInfo!=""){
	    var Patdetail=PatInfo.split("^");
		var NeedAddPatInfo=Patdetail[32]
		if (NeedAddPatInfo!=""){
			$.messager.alert("��ʾ",$g("����")+"<font style='color:red'>"+$g(NeedAddPatInfo)+"</font>"+$g("����Ϊ�գ��赽�Һ��շѴ�������Ϣ��"),"info",function(){
				ClearPatInfo();
			})
			return false;
		}
	    $("#PatName").val(Patdetail[0]);
		if (Patdetail[27] =="Y") {
			$.messager.alert("��ʾ","�����ѹ�!","info",function(){
				ClearPatInfo();
				$("#CardNo").focus();
			})
			return false;
		}
		var StayStatus=Patdetail[31];
		if (StayStatus==2) {
			$.messager.alert("��ʾ","�����ڼ�������!")
			return false;
		} else if (StayStatus==1) {
			$.messager.alert("��ʾ","���ߵ�ǰ��סԺ!")
			return false;
		}
		
		var AgeLimitInfo=Patdetail[28];
		var CheckObj={"TelNo":Patdetail[21],"IDTypeID":Patdetail[30],"IDCardNo":Patdetail[25]};
		var RetObj=DHCWeb_IsTelOrMobile(CheckObj);
		if ((RetObj.Flag!="0") || (AgeLimitInfo!="")){
			var TelLimitInfo=RetObj.Desc||AgeLimitInfo;
			$.messager.alert("��ʾ",TelLimitInfo+" �����޸ģ��赽�Һ��շѴ�������Ϣ��","info")
			
		}
		LoadPatEncryptLevel(PatientID);
		LoadAccInfo(PatientID);
		LoadRegConDisList();
		$('#MarkDocList').next('span').find('input').focus();		
    }else{
		$.messager.alert("��ʾ","û���ҵ���Ч������Ϣ!","info",function(){
			ClearPatInfo();
			$("#CardNo").focus();
		})
		return false;
	}
}
function ClearPatInfo(){
	$("#CardNo,#PatName,#PatNo").val("");
	$("#PatientID").val("");
}

function LoadPatEncryptLevel(PatientID){
	$.m({
		ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
		MethodName:"GetPatEncryptLevel",
		PAPMIRowId:PatientID
	},function(PatEncryptLevel){
		var PatEncryptLevelArr=PatEncryptLevel.split("^");
		$("#PoliticalLevel").val(PatEncryptLevelArr[1]);
		$("#SecretLevel").val(PatEncryptLevelArr[3]);
	});
}
function LoadAccInfo(){
	$.m({
		ClassName:"web.UDHCAccManageCLS7",
		MethodName:"getaccinfofromcardno",
		cardno:$("#CardNo").val(),
		securityno:$("#Securityno").val(),
		CardTypeDR:$("#CardTypeRowID").val(),
		AdmStr:"",
		CheckSecurityFlag:"",
		ExpStr:""
	},function(AccInfo){
		var AccLeft=AccInfo.split("^")[3];
		if (AccLeft!="") {
			$("#AccLeft").html($g("���: ")+AccLeft+$g("Ԫ"));
		}
	});
}
function PatNoKeydownHandler(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var m_PatientNoLength=10;
		var PatNo=$("#PatNo").val();
		if (PatNo!=""){
			if ((PatNo.length<m_PatientNoLength)&&(m_PatientNoLength!=0)) {
				for (var i=(m_PatientNoLength-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
		}
		$("#PatNo").val(PatNo);
		CheckPatientNoNew(PatNo);
		return false;
	}
}
function CheckPatientNoNew(PatNo)
{
	$.m({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetCardNoByPatientNo",
		PatientNo:PatNo
	},function(CardNoStr){
		var CardInfoArr=CardNoStr.split("^");
		var CardNo=CardInfoArr[0]
		if (CardNo=="") {
			var PatientID=CardInfoArr[3];
			var UnitRegNo=$.cm({
			    ClassName : "web.DHCOPAdmReg",
			    MethodName : "GetUnitedRegNo",
			    dataType:"text",
			    PatientID:PatientID,
		    },false);
			if (UnitRegNo!=""){
				$.messager.alert("��ʾ",PatNo+" �õǼǺ��ѱ��ϲ��������ǼǺ�Ϊ<font style='color:red'>"+UnitRegNo+"</font>!","info",function(){
					$("#PatNo").val("").focus();
					$("#CardNo,#PatName").val("");
					SetPatientInfo("","","")
				})
				return false;
			}
			$.messager.alert("��ʾ","�õǼǺ��޶�Ӧ������Ϣ,�뽨��!","info",function(){
				$("#PatNo").focus();
			})
			$("#CardNo,#PatName").val("");
			SetPatientInfo("","","")
			return false;
		}
		//�Ϳ��Żس��¼�����һ��
		$("#CardTypeRowID").val(CardInfoArr[1]);
		$("#CardTypeNew").val(CardInfoArr[2]);
		$("#CardNo").val(CardNo);
		$("#PatNo").val(PatNo);
		$("#Securityno").val(CardInfoArr[6]);		//��Ҫ����У���룬��Ȼ����ڿ��ź͵ǼǺŻس���������Ϣ��һ��
		SetPatientInfo(PatNo,CardNo,CardInfoArr[3]);
		return
			
		var CardTypeRowId=CardInfoArr[1];
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, CardTypeRowId)
		if (TemporaryCardFlag=="Y") {
			$.messager.alert("��ʾ","��ʱ�����ܽ��о���Ǽ�!","info",function(){
				$("#CardNo,#PatName,#PatNo").val("");
				$("#PatNo").focus();
			})
			return false;
		}
		var IsDeceased=CardInfoArr[7];
		if (IsDeceased=="Y") {
			$.messager.alert("��ʾ","����������!","info",function(){
				$("#CardNo,#PatName,#PatNo").val("");
				$("#PatNo").focus();
			})
			return false;
		}
		var rResult=$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetInHospOrStayStatus",
			PatientID:CardInfoArr[3],
			dataType:"text"
		},false);
		if (rResult==2) {
			$.messager.alert("��ʾ","�����ڼ�������!")
			return false;
		} else if (rResult==1) {
			$.messager.alert("��ʾ","���ߵ�ǰ��סԺ!")
			return false;
		}
		$("#CardTypeRowID").val(CardTypeRowId);
		$("#CardTypeNew").val(CardInfoArr[2]);
		$("#CardNo").val(CardNo);
		$("#PatName").val(CardInfoArr[4]);
		$("#PatientID").val(CardInfoArr[3]);
		$('#MarkDocList').next('span').find('input').focus();
		if (CardInfoArr[3]!=""){
			LoadPatEncryptLevel(CardInfoArr[3]);
			LoadAccInfo();
			LoadRegConDisList();
		}
	});
}

function SaveClickHandler(){
	var PatientID=$("#PatientID").val();
	var DepRowId=$('#LocList').combobox('getValue');
	var DocRowId=$('#MarkDocList').combobox('getValue');
	var RegConDisId=""
	if (ServerObj.RegConDisForRapidReg=="1"){
		if ($("#RegConDisList").combobox("getData").length>0) {
			RegConDisId=$("#RegConDisList").combobox("getValue")
		}
	}
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var ASRowId="";
	var FeeStr="1||1||0||0";
	var PayModeCode=""
	var AccRowId="",BillAmount=0,ETPRowID="",AdmReason="";
	var InsuJoinStr="",InsuAdmInfoDr="",InsuDivDr="",InsuPayFeeStr="";
	var RegExpStr=$("#CardTypeRowID").val()+"^"+$('#CardNo').val();
	new Promise(function(resolve,rejected){
		CheckBeforeSave(resolve);
	}).then(function(ret){	
		return new Promise(function(resolve,rejected){
			if (!ret) return false;
			$.m({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"GetRapidASRowId",
				loc:DepRowId,
				user:session['LOGON.USERID'],
				MarkType:"",
				SecheduleDate:"",
				TimeRangeId:"",
				DocId:DocRowId
			},function(ret){
				ASRowId=ret;
				resolve()
			});
		});
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			if (ASRowId==""){
				var IrrScheduleFlag=$.cm({
					ClassName:"web.DHCRBApptSchedule",
					MethodName:"CheckInsertOneIrrSchedule",
					LocID:DepRowId, DocID :DocRowId, SecheduleDate:"", TimeRangeId:"",
					dataType:"text"
				},false)
				if (IrrScheduleFlag!=0){
					$.messager.alert("��ʾ","û���ҵ������¼,���ߴ�δ�Ű�.");
					return false;
				}
			}
			resolve();
		});
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			$.messager.confirm('ȷ�϶Ի���', '�Ƿ���ȡ����?', function(r){
				if (!r){
				    FeeStr="0||0||0||0";
				}
				resolve()
			});
		});
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			if (ServerObj.DocOPRegistBill!="1"){
				resolve()
			}else{
				PayModeCode=GetPayModeCode();
				if (PayModeCode==""){
					$.messager.alert("��ʾ","֧����ʽΪ�գ���ѡ����ʵ�֧����ʽ.");
					return false;
				}
				var myrtn=$.cm({
					ClassName:"web.DHCRBApptSchedule",
					MethodName:"OPDocRegistInsertIrrSchedule",
					LocID:DepRowId, DocRowId:DocRowId, PatientID:PatientID, BillType:"", RegConDisId:RegConDisId,
					ASRowId:ASRowId,FeeStr:FeeStr,dataType:"text"
				},false)
				if (myrtn.split("^")[0] == 0) {
					ASRowId=myrtn.split("^")[1];
					BillAmount=myrtn.split("^")[2];
					AdmReason=myrtn.split("^")[3];
				} else {
					$.messager.alert("��ʾ", myrtn.split("^")[1], "info");
					return false;
				}
				var CardTypeRowID=$("#CardTypeRowID").val();
				var CardNo=$("#CardNo").val();
				if (PayModeCode=="CPP"){
					(function(callBackFun){
						new Promise(function(resolve,rejected){
							DHCACC_CheckMCFPay(BillAmount,CardNo,"",CardTypeRowID,"",resolve);
						}).then(function(ren){
							var myary=ren.split("^");
							if (myary[0]!='0'){
								if (myary[0]=='-204'){
									$.messager.alert("��ʾ","���û����˻�������,���ܰ���֧��,���ҹ���Ա����!")
									return false;
								}else if (myary[0]=='-205'){
									ChangePayMode();
									return false;	
								}else if (myary[0]=='-206'){
									$.messager.alert("��ʾ","�����벻һ��,��ʹ��ԭ��!")
									return false;
								}else if(myary[0]=='-201'){
									$.messager.alert("��ʾ","�û��߲�������Ч�˻�������ʹ��Ԥ����֧��!")
									return false;
								}
							}else{
								AccRowId=myary[1];
							}
							callBackFun();
						})
					})(resolve);
				}else{
					resolve();
				}
			}
		});
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			if ((ServerObj.DocOPRegistBill!="1")||(ServerObj.DocOPRegistInsu!="1")){
				resolve();
			}else{
				//ҽ��ʵʱ����
				
				var UseInsuFlag="N",UPatientName="",RegType="",FreeRegFeeFlag="",InsuReadCardInfo="",RetInsuGSInfo="";
				
				var EnableInsuBillFlag=IsEnableInsuBill(PatientID,ASRowId,UseInsuFlag,AdmReason,InsuReadCardInfo)
				if (EnableInsuBillFlag==true) {
					var InsuBillParamsObj={};
					InsuBillParamsObj.PatientID=PatientID;
					InsuBillParamsObj.UPatientName="";
					InsuBillParamsObj.UserID=UserID;
					InsuBillParamsObj.ASRowId=ASRowId;
					InsuBillParamsObj.AdmReasonId=AdmReason;
					//[��ѡ]�Һ���֯�ķ��ô���Ĭ��Ϊ"1||1||||||||"
					InsuBillParamsObj.FeeStr=FeeStr;
					//[��ѡ]�Һ����Ĭ��Ϊ��
					InsuBillParamsObj.RegType=RegType;
					//[��ѡ]�Һŷ���ѱ�ʶ��Ĭ��Ϊ��
					InsuBillParamsObj.FreeRegFeeFlag=FreeRegFeeFlag;
					//[��ѡ]��ҽ����������Ϣ��Ĭ��Ϊ��
					InsuBillParamsObj.InsuReadCardInfo=InsuReadCardInfo;
					//[��ѡ]����ҽ����Ϣ��Ĭ��Ϊ��
					InsuBillParamsObj.RetInsuGSInfo=RetInsuGSInfo;
					//�˻�ID
					InsuBillParamsObj.AccRowId=AccRowId;
					//�����Ը�֧����ʽ����
					InsuBillParamsObj.PayModeCode=PayModeCode;
					InsuJoinStr=CallInsuBill(InsuBillParamsObj);
					if (InsuJoinStr!="") {
						var myAry=InsuJoinStr.split("^");
						var ConFlag=myAry[0];
						if (ConFlag==0){
							InsuAdmInfoDr=myAry[1];
							InsuDivDr=myAry[2];
							InsuPayFeeStr=InsuJoinStr.split("!")[1];
						}else{
							$.messager.alert("��ʾ","ҽ������ʧ��!");
							return false;
						}
			
						if (InsuPayFeeStr!=""){
							var InsuTotalAmount=GetInsuTotalAmount(InsuPayFeeStr);
							var TotalAmount=InsuTotalAmount.split("^")[0];
							var CashFee=InsuTotalAmount.split("^")[1];
							
							if(parseFloat(TotalAmount)!=parseFloat(BillAmount)){
								$.messager.alert("��ʾ","��ǰ�۸���ʵʱ�����ϴ��ܼ۸�һ��?��ȷ��ҽ���۸�!");
								return false;
							}
						}
					}
				}
				resolve();
			}
		});
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			if (ServerObj.DocOPRegistBill!="1"){
				resolve();
			}else{
				//���������׽ӿ�
				RegPayObj.RegPay(BillAmount,PatientID,"",InsuJoinStr,"","","","","","","OP",resolve)
			}
		});
	}).then(function(rtnPay){
		return new Promise(function(resolve,rejected){
			if (ServerObj.DocOPRegistBill!="1"){
				resolve();
			}else{
				PayModeCode=RegPayObj.PayModeCode;
				if (!rtnPay){
					//����ʧ�������ҽ������Ҫ����
					ReturnInsuOPReg(PatientID,InsuAdmInfoDr,ASRowId,AdmReason)
					return false;
				}
					
				if ((typeof RegPayObj.PayRtnJsonObj!="undefined")&&(typeof RegPayObj.PayRtnJsonObj.ETPRowID!="undefined")&&(RegPayObj.PayRtnJsonObj.ETPRowID!="")) {
					ETPRowID=RegPayObj.PayRtnJsonObj.ETPRowID;
				}
				resolve();
			}
		})
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			$.m({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"OPDocRapidRegistBroker",
				PatientID:PatientID,
				ASRowId:ASRowId,
				AdmReason:"",
				FeeStr:FeeStr,
				user:session['LOGON.USERID'],
				group:session['LOGON.GROUPID'],
				LocID:DepRowId,
				DocRowId:DocRowId,
				TimeRangeRowId:"",
				PayModeCode:PayModeCode,
				AccRowId:AccRowId,
				RegConDisId:RegConDisId,
				InsuJoinStr:InsuJoinStr,
				ETPRowID:ETPRowID,
				RegExpStr:RegExpStr
			},function(ret){
				resolve(ret);
			})
		});
	}).then(function(ret){	
		return new Promise(function(resolve,rejected){
			var TempArr=ret.split("^");
			if (TempArr[0]!="0"){
				//����ʧ�������ҽ������Ҫ����
				ReturnInsuOPReg(PatientID,InsuAdmInfoDr,ASRowId,AdmReason)
				//������֧�����׽ӿ��˻�
				RegPayObj.ErrReg();
				if (TempArr[0]=="-101"){
					$.messager.alert("��ʾ","û���ҵ������¼,���ߴ�δ�Ű�.");
					return false;
				}else if (TempArr[0]=="-102") {
					$.messager.alert("��ʾ","�˲����Ѿ�������ͬ�ĵǼǼ�¼,��ʹ�ò����б��ѯ.");
					return false;
				}else{
					var errmsg=TempArr[0];
					if (TempArr[0]=="-201")  errmsg="���ɾ����¼ʧ��!";
					if (TempArr[0]=="-202")  errmsg="ȡ�Ų��ɹ�!";
					if (TempArr[0]=="-2121")  errmsg="����ԤԼ״̬ʧ��!";
					if (TempArr[0]=="-2122")  errmsg="ϵͳæ,���Ժ�����!";
					if (TempArr[0]=="-206")  errmsg="����Һŷ�ҽ��ʧ��!";
					if (TempArr[0]=="-207")  errmsg="��������ҽ��ʧ��!";
					if (TempArr[0]=="-208")  errmsg="������շ�ҽ��ʧ��!";
					if (TempArr[0]=="-209")  errmsg="����ԤԼ��ҽ��ʧ��!";
					if (TempArr[0]=="-210")  errmsg="�Ʒ�ʧ��!";
					if (TempArr[0]=="-211")  errmsg="����Һż�¼ʧ��!";
					if (TempArr[0]=="-212")  errmsg="����кŶ���ʧ��!";
					if (TempArr[0]=="-301")  errmsg="����ÿ��ÿ��ɹ��޶�,�����ٹҺŻ�ԤԼ!";
					if (TempArr[0]=="-302")  errmsg="����ÿ��ÿ��ɹ���ͬ�ŵ��޶�!";
					if (TempArr[0]=="-303")  errmsg="����ÿ��ÿ��ɹ���ͬ���Һŵ��޶�!";
					if (TempArr[0]=="-401")  errmsg="��û�е��Һ�ʱ��!";
					if (TempArr[0]=="-402")  errmsg="��δ��ԤԼʱ��!";
					if (TempArr[0]=="-403")  errmsg="��δ���Ӻ�ʱ��!";
					if (TempArr[0]=="-404")  errmsg="�Ѿ����˴��Ű��¼����ʱ���!";
					if (TempArr[0]=="-2010") errmsg="����ҽ���Һ���Ϣʧ��!";
					if (TempArr[0]=="-304") errmsg="����ÿ��ÿ����ͬʱ��ͬ����ͬҽ���޶�!";
					if (TempArr[0]=="-405")  errmsg="��ȥ�Һ����ý���ά�����ҽ��!";
					$.messager.alert("��ʾ","ʧ��!"+errmsg);
					return false;
				}
			}else{
				$.messager.popover({msg: '�ɹ�!',type:'success'});
				if (ServerObj.winfrom == "outpatlist") {
					if(parent.CloseHISUIWindow){
						parent.LoadOutPatientDataGrid();
						parent.switchPatient(PatientID,TempArr[1],TempArr[2]);
						parent.CloseHISUIWindow();
					}else{
						var opts=websys_showModal("options");
						opts.LoadOutPatientDataGrid();
						websys_showModal("close");
					}
				}else if(ServerObj.winfrom == "opcharge"){
					var EpisodeID=TempArr[1];
					var opts=websys_showModal("options");
					opts.callbackFunc($("#CardNo").val(), $("#CardTypeRowID").val(), PatientID);
					websys_showModal("close");
				}else{
					var StartTMENU=$.cm({
						ClassName:"web.DHCDocOrderEntry",
						MethodName:"GetStartTMENU",
						GroupID:session["LOGON.GROUPID"],
						dataType:"text"
					},false);
					var EpisodeID=TempArr[1];	
					var menuWin=websys_getMenuWin();
					if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
					var frm=dhcsys_getmenuform();
					if (frm){
					var frmPatientID=frm.PatientID;
					var frmEpisodeID=frm.EpisodeID;
					var frmmradm=frm.mradm;
					var mradm=TempArr[2];
					frmPatientID.value=PatientID;
					frmEpisodeID.value=EpisodeID;
					frmmradm.value=mradm;
					}
					var lnk="websys.csp?a=a&TMENU="+StartTMENU;
					if (StartTMENU!=""){
						//��ȡ��Ӧ�˵����ʽ
						var ValueExpression=$.cm({
							ClassName:"web.DHCDocOrderEntry",
							MethodName:"GetValueExpressionByMenuId",
							LoopMenu:StartTMENU,
							dataType:"text"
						},false);
						if (ValueExpression!="") lnk=lnk+ValueExpression.replace(/^[\'\"]+|[\'\"]+$/g,"");
					}
					if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
					window.location=lnk;
				}
			}
		});
	});
}
///�жϿ��Ƿ�����ʱ��
function CheckTemporaryCard(CardNo, CardTypeDr) {
	var TemporaryCardFlag=$.cm({
		ClassName:"web.DHCBL.CARD.UCardRefInfo",
		MethodName:"GetTemporaryCardFlag",
		CardTypeId:CardTypeDr,
		CardNo:CardNo,
		dataType:"text"
	},false)
	return TemporaryCardFlag
}
function ReadCardClickHandler(){
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

function LoadPayMode(){
	$.cm({ 
		ClassName:"web.UDHCOPGSConfig", 
		QueryName:"ReadGSINSPMList",
		GPRowID:session['LOGON.GROUPID'],
		HospID:session['LOGON.HOSPID'],
		TypeFlag:"REG",
		rows:9999
	},function(Data){
		var cbox = $HUI.combobox("#PayMode", {
				valueField: 'CTPMRowID',
				textField: 'CTPMDesc', 
				editable:false,
				data: Data.rows
		 });
	});
}
function GetPayModeCode(){
	var PayModeValue=$("#PayMode").combobox("getValue");
	if (PayModeValue!="") {
		var PayModeData=$("#PayMode").combobox('getData');
		var index=$.hisui.indexOfArray(PayModeData,"CTPMRowID",PayModeValue);
		var PayModeCode= PayModeData[index].CTPMCode;
		return PayModeCode;
	}
	return "";
}

function ChangePayMode(){
	var PayModeData=$("#PayMode").combobox('getData');
	var index=$.hisui.indexOfArray(PayModeData,"CTPMRowID",ServerObj.CashPayModeID);
	if (index>=0){
		$.messager.confirm("ȷ�ϵ�����","�ʻ�����,�Ƿ��л����ֽ�֧����ʽ?",function(r){
			if (r) {
				$("#PayMode").combobox("select",ServerObj.CashPayModeID);
			}
		});
	}else{
		$.messager.alert("��ʾ","�ʻ�����,��ѡ������֧����ʽ!");
		return false;
	}
	return true;
}

function CheckBeforeSave(callBackFun){
	var PatientID=$("#PatientID").val();
	if (PatientID==""){
		$.messager.alert("��ʾ","�����벡�˿���!","info",function(){
			$('#CardNo').focus();
		})
		callBackFun(false);
		return false;
	}
	var DepRowId=$('#LocList').combobox('getValue');
	var DocRowId=$('#MarkDocList').combobox('getValue');
	if (DocRowId==""){
		$.messager.alert("��ʾ","��ѡ��ű�!","info",function(){
			$('#MarkDocList').next('span').find('input').focus();
		})
		callBackFun(false);
		return false;
	}
	var rResult=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetInHospOrStayStatus",
		PatientID:PatientID,
		dataType:"text"
	},false);
	if (rResult==2) {
		$.messager.alert("��ʾ","�����ڼ�������!");
		callBackFun(false);
		return false;
	} else if (rResult==1) {
		$.messager.alert("��ʾ","���ߵ�ǰ��סԺ!");
		callBackFun(false);
		return false;
	}
	var myrtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"CheckRegDeptAgeSex",
		dataType:"text",
		ASRowId:"",
		PatientID:PatientID,
		LocRowid:DepRowId
	},false);
	var Flag=myrtn.split(String.fromCharCode(2))[0];
	if (Flag!="0") {
		var msg="";
		var AllowSexDesc=myrtn.split(String.fromCharCode(2))[1];
		if (AllowSexDesc!="") msg="�˿���֧���Ա�"+AllowSexDesc+"��";
		var AgeRange=myrtn.split(String.fromCharCode(2))[2];
		if (AgeRange!="") {
			if (msg=="") {
				msg="�˿���֧�������:"+AgeRange;
			}else{
				msg=msg+","+"�˿���֧������Ρ�"+AgeRange+"��";
			}
		}
		$.messager.alert("��ʾ","������Ҵ˿���,"+msg);
		callBackFun(false);
		return false;
	}
	
	var SessionStr=GetSessionStr();
	var CheckRet=$.cm({
		ClassName:"web.DHCRBAppointment",
		MethodName:"CheckRegAppInfo",
		PatientID:PatientID,
		RegLocID:DepRowId,
		SessionStr:SessionStr,
		dataType:"text"
	},false);
	var CheckArr=CheckRet.split("^");
	if (CheckArr[0]!="0"){
		$.messager.confirm('ȷ�϶Ի���', CheckArr[1]+' ��Ҫ��ȡ��ԤԼ�Ż�ȡ�Ų��ܱ���Һţ��Ƿ�ȡ��ԤԼ?', function(r){
			if (r){
				websys_showModal({
					url:"../csp/opadm.appcancel.hui.csp?PatientID="+PatientID,
					title:'ȡ��ԤԼ��¼',
					width:((top.screen.width - 100)),
					height:(top.screen.height - 120),
					onClose:function(){
						var CheckRet=$.cm({
							ClassName:"web.DHCRBAppointment",
							MethodName:"CheckRegAppInfo",
							PatientID:PatientID,
							SessionStr:SessionStr,
							dataType:"text"
						},false);
						if (CheckRet.split("^")[0]!="0"){
							callBackFun(false);	
						}else{
							callBackFun(true);
						}
					}
				})
			}else{
				callBackFun(false)	
			}
		});
	}else{
		callBackFun(true)
	}
	return true;
}