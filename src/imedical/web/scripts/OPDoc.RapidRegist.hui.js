if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
	 document.getElementsByTagName('head')[0].appendChild(script);
}
$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
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
				//当前登录医生当天有出诊资源(不论时段)默认当前医生
				/*
				    当前登录医生当天无出诊资源,但医生号别对照有出诊资源，则默认此出诊号别.
					如果对应多个号别，仅有一个号别有出诊资源默认此号别.
					如果号别对照有多个号别出诊，默认为空
				*/
				//当前登录医生及号别对照均无出诊资源,按照医生号别对照默认
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
		case "0": //卡有效有帐户
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
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardNo").focus();
			});
			break;
		case "-201": //卡有效无帐户
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
			$.messager.alert("提示","临时卡不能进行就诊登记!")
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
			$.messager.alert("提示",$g("患者")+"<font style='color:red'>"+$g(NeedAddPatInfo)+"</font>"+$g("不能为空，需到挂号收费处完善信息！"),"info",function(){
				ClearPatInfo();
			})
			return false;
		}
	    $("#PatName").val(Patdetail[0]);
		if (Patdetail[27] =="Y") {
			$.messager.alert("提示","患者已故!","info",function(){
				ClearPatInfo();
				$("#CardNo").focus();
			})
			return false;
		}
		var StayStatus=Patdetail[31];
		if (StayStatus==2) {
			$.messager.alert("提示","患者在急诊留观!")
			return false;
		} else if (StayStatus==1) {
			$.messager.alert("提示","患者当前在住院!")
			return false;
		}
		
		var AgeLimitInfo=Patdetail[28];
		var CheckObj={"TelNo":Patdetail[21],"IDTypeID":Patdetail[30],"IDCardNo":Patdetail[25]};
		var RetObj=DHCWeb_IsTelOrMobile(CheckObj);
		if ((RetObj.Flag!="0") || (AgeLimitInfo!="")){
			var TelLimitInfo=RetObj.Desc||AgeLimitInfo;
			$.messager.alert("提示",TelLimitInfo+" 如需修改，需到挂号收费处完善信息！","info")
			
		}
		LoadPatEncryptLevel(PatientID);
		LoadAccInfo(PatientID);
		LoadRegConDisList();
		$('#MarkDocList').next('span').find('input').focus();		
    }else{
		$.messager.alert("提示","没有找到有效患者信息!","info",function(){
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
			$("#AccLeft").html($g("余额: ")+AccLeft+$g("元"));
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
				$.messager.alert("提示",PatNo+" 该登记号已被合并，保留登记号为<font style='color:red'>"+UnitRegNo+"</font>!","info",function(){
					$("#PatNo").val("").focus();
					$("#CardNo,#PatName").val("");
					SetPatientInfo("","","")
				})
				return false;
			}
			$.messager.alert("提示","该登记号无对应卡号信息,请建卡!","info",function(){
				$("#PatNo").focus();
			})
			$("#CardNo,#PatName").val("");
			SetPatientInfo("","","")
			return false;
		}
		//和卡号回车事件保持一致
		$("#CardTypeRowID").val(CardInfoArr[1]);
		$("#CardTypeNew").val(CardInfoArr[2]);
		$("#CardNo").val(CardNo);
		$("#PatNo").val(PatNo);
		$("#Securityno").val(CardInfoArr[6]);		//需要设置校验码，不然会存在卡号和登记号回车后的余额信息不一致
		SetPatientInfo(PatNo,CardNo,CardInfoArr[3]);
		return
			
		var CardTypeRowId=CardInfoArr[1];
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, CardTypeRowId)
		if (TemporaryCardFlag=="Y") {
			$.messager.alert("提示","临时卡不能进行就诊登记!","info",function(){
				$("#CardNo,#PatName,#PatNo").val("");
				$("#PatNo").focus();
			})
			return false;
		}
		var IsDeceased=CardInfoArr[7];
		if (IsDeceased=="Y") {
			$.messager.alert("提示","患者已死亡!","info",function(){
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
			$.messager.alert("提示","患者在急诊留观!")
			return false;
		} else if (rResult==1) {
			$.messager.alert("提示","患者当前在住院!")
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
					$.messager.alert("提示","没有找到出诊记录,或者从未排班.");
					return false;
				}
			}
			resolve();
		});
	}).then(function(){	
		return new Promise(function(resolve,rejected){
			$.messager.confirm('确认对话框', '是否收取诊查费?', function(r){
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
					$.messager.alert("提示","支付方式为空，请选择合适的支付方式.");
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
					$.messager.alert("提示", myrtn.split("^")[1], "info");
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
									$.messager.alert("提示","此用户的账户被冻结,不能办理支付,请找管理员处理!")
									return false;
								}else if (myary[0]=='-205'){
									ChangePayMode();
									return false;	
								}else if (myary[0]=='-206'){
									$.messager.alert("提示","卡号码不一致,请使用原卡!")
									return false;
								}else if(myary[0]=='-201'){
									$.messager.alert("提示","该患者不存在有效账户，不能使用预交金支付!")
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
				//医保实时结算
				
				var UseInsuFlag="N",UPatientName="",RegType="",FreeRegFeeFlag="",InsuReadCardInfo="",RetInsuGSInfo="";
				
				var EnableInsuBillFlag=IsEnableInsuBill(PatientID,ASRowId,UseInsuFlag,AdmReason,InsuReadCardInfo)
				if (EnableInsuBillFlag==true) {
					var InsuBillParamsObj={};
					InsuBillParamsObj.PatientID=PatientID;
					InsuBillParamsObj.UPatientName="";
					InsuBillParamsObj.UserID=UserID;
					InsuBillParamsObj.ASRowId=ASRowId;
					InsuBillParamsObj.AdmReasonId=AdmReason;
					//[可选]挂号组织的费用串，默认为"1||1||||||||"
					InsuBillParamsObj.FeeStr=FeeStr;
					//[可选]挂号类别，默认为空
					InsuBillParamsObj.RegType=RegType;
					//[可选]挂号费免费标识，默认为空
					InsuBillParamsObj.FreeRegFeeFlag=FreeRegFeeFlag;
					//[可选]读医保卡返回信息，默认为空
					InsuBillParamsObj.InsuReadCardInfo=InsuReadCardInfo;
					//[可选]工商医保信息，默认为空
					InsuBillParamsObj.RetInsuGSInfo=RetInsuGSInfo;
					//账户ID
					InsuBillParamsObj.AccRowId=AccRowId;
					//个人自付支付方式代码
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
							$.messager.alert("提示","医保结算失败!");
							return false;
						}
			
						if (InsuPayFeeStr!=""){
							var InsuTotalAmount=GetInsuTotalAmount(InsuPayFeeStr);
							var TotalAmount=InsuTotalAmount.split("^")[0];
							var CashFee=InsuTotalAmount.split("^")[1];
							
							if(parseFloat(TotalAmount)!=parseFloat(BillAmount)){
								$.messager.alert("提示","当前价格与实时结算上传总价格不一致?请确认医嘱价格!");
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
				//第三方交易接口
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
					//交易失败如果是医保的需要回退
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
				//交易失败如果是医保的需要回退
				ReturnInsuOPReg(PatientID,InsuAdmInfoDr,ASRowId,AdmReason)
				//第三方支付交易接口退回
				RegPayObj.ErrReg();
				if (TempArr[0]=="-101"){
					$.messager.alert("提示","没有找到出诊记录,或者从未排班.");
					return false;
				}else if (TempArr[0]=="-102") {
					$.messager.alert("提示","此病人已经存在相同的登记记录,请使用病人列表查询.");
					return false;
				}else{
					var errmsg=TempArr[0];
					if (TempArr[0]=="-201")  errmsg="生成就诊记录失败!";
					if (TempArr[0]=="-202")  errmsg="取号不成功!";
					if (TempArr[0]=="-2121")  errmsg="更新预约状态失败!";
					if (TempArr[0]=="-2122")  errmsg="系统忙,请稍后重试!";
					if (TempArr[0]=="-206")  errmsg="插入挂号费医嘱失败!";
					if (TempArr[0]=="-207")  errmsg="插入诊查费医嘱失败!";
					if (TempArr[0]=="-208")  errmsg="插入假日费医嘱失败!";
					if (TempArr[0]=="-209")  errmsg="插入预约费医嘱失败!";
					if (TempArr[0]=="-210")  errmsg="计费失败!";
					if (TempArr[0]=="-211")  errmsg="插入挂号记录失败!";
					if (TempArr[0]=="-212")  errmsg="插入叫号队列失败!";
					if (TempArr[0]=="-301")  errmsg="超过每人每天可挂限额,不能再挂号或预约!";
					if (TempArr[0]=="-302")  errmsg="超过每人每天可挂相同号的限额!";
					if (TempArr[0]=="-303")  errmsg="超过每人每天可挂相同科室号的限额!";
					if (TempArr[0]=="-401")  errmsg="还没有到挂号时间!";
					if (TempArr[0]=="-402")  errmsg="还未到预约时间!";
					if (TempArr[0]=="-403")  errmsg="还未到加号时间!";
					if (TempArr[0]=="-404")  errmsg="已经过了此排班记录出诊时间点!";
					if (TempArr[0]=="-2010") errmsg="更新医保挂号信息失败!";
					if (TempArr[0]=="-304") errmsg="超过每人每天相同时段同科室同医生限额!";
					if (TempArr[0]=="-405")  errmsg="请去挂号设置界面维护免费医嘱!";
					$.messager.alert("提示","失败!"+errmsg);
					return false;
				}
			}else{
				$.messager.popover({msg: '成功!',type:'success'});
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
						//获取相应菜单表达式
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
///判断卡是否是临时卡
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
		$.messager.confirm("确认弹出框","帐户余额不足,是否切换到现金支付方式?",function(r){
			if (r) {
				$("#PayMode").combobox("select",ServerObj.CashPayModeID);
			}
		});
	}else{
		$.messager.alert("提示","帐户余额不足,请选择其他支付方式!");
		return false;
	}
	return true;
}

function CheckBeforeSave(callBackFun){
	var PatientID=$("#PatientID").val();
	if (PatientID==""){
		$.messager.alert("提示","请输入病人卡号!","info",function(){
			$('#CardNo').focus();
		})
		callBackFun(false);
		return false;
	}
	var DepRowId=$('#LocList').combobox('getValue');
	var DocRowId=$('#MarkDocList').combobox('getValue');
	if (DocRowId==""){
		$.messager.alert("提示","请选择号别!","info",function(){
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
		$.messager.alert("提示","患者在急诊留观!");
		callBackFun(false);
		return false;
	} else if (rResult==1) {
		$.messager.alert("提示","患者当前在住院!");
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
		if (AllowSexDesc!="") msg="此科室支持性别【"+AllowSexDesc+"】";
		var AgeRange=myrtn.split(String.fromCharCode(2))[2];
		if (AgeRange!="") {
			if (msg=="") {
				msg="此科室支持年龄段:"+AgeRange;
			}else{
				msg=msg+","+"此科室支持年龄段【"+AgeRange+"】";
			}
		}
		$.messager.alert("提示","不允许挂此科室,"+msg);
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
		$.messager.confirm('确认对话框', CheckArr[1]+' 需要先取消预约号或取号才能便民挂号，是否取消预约?', function(r){
			if (r){
				websys_showModal({
					url:"../csp/opadm.appcancel.hui.csp?PatientID="+PatientID,
					title:'取消预约记录',
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