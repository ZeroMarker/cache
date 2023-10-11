/**!
* ����:   2021-03-29
* ��Ʒ�������ҩjs��8.4.1��
* 
* V1.0
* DHCDocHLYYDHC.js
* ��װ������ҩϵͳ��������ֹ������Ⱦ;�����÷������Ա�ҽ��¼��Ͳ�ҩ¼��ͬʱ����
*/

function HLYYY_Init(){
	//PassFuncs.DHCFuncs.openShowAuditPopProcess();	
}

function HYLL_openShowAuditPopProcess(){
	if (GlobalObj.HLYYInterface==1){
		PassFuncs.DHCFuncs.openShowAuditPopProcess();
	}	
}

// ͨ�õ�����ҩƷ֪ʶ��
function HLYYYDTS_Click(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//ѡ��һ��
		var ids=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow"); 			
		if(ids==null || ids.length==0 || ids.length > 1) {  
			$.messager.alert("����","��ѡ��һ��ҽ��");  
			return;  
		}
		var OrderARCIMRowid = GetCellData(ids[0], "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("����","��ѡ��һ��ҽ��");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0); //ҽ��code
	var OrderName=mPiece(ArcimInfo,"^",1); //ҽ������
	PassFuncs.DHCFuncs.DHCYDTS(OrderARCIMCode,OrderName);
   
}

///��鷽��
function HYLLUpdateClick_HLYY(CallBackFunc,OrderItemStr,Mode,DHCHLYYInfo){
	if (Mode=="Check") {	//��Ԥ
		var rtn=DHCUpdateClick_Check(CallBackFunc,OrderItemStr,Mode);
	}
	else if (Mode=="CheckCM") {	//��Ԥ
		var rtn=DHCUpdateClick_Check(CallBackFunc,OrderItemStr,Mode);
	}
	else if (Mode=="Save") {		//����
		var rtn=DHCUpdateClick_Save(CallBackFunc,OrderItemStr,DHCHLYYInfo);
	}
	return;
}
function DHCUpdateClick_Check(CallBackFunc,OrderItemStr,Mode) {
	
	new Promise(function(resolve){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.DHCFuncs.DHCXHZY(OrderItemStr,resolve);
		}else{
			PassFuncs.DHCFuncs.DHCXHZYCM(OrderItemStr,resolve);
		}
	}).then(function(HLYYInfo){
		if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
			//����Ҫ���ú�����ҩ���߳����쳣
			CallBackFunc(true);
			return;
		}
		if (HLYYInfo.passFlag=="1") {
			GlobalObj.DHCHLYYInfo=HLYYInfo.drugUniqueStr;
			CallBackFunc(true);
		}else if (HLYYInfo.passFlag=="0"){
			GlobalObj.DHCHLYYInfo=HLYYInfo.drugUniqueStr;
			CallBackFunc(false);
		}else{
			$.messager.confirm('ȷ�϶Ի���',"������ҩ��Ԥϵͳ�쳣:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����", function(r){
				if (r) {
					GlobalObj.DHCHLYYInfo=HLYYInfo.drugUniqueStr;
					CallBackFunc(true);
				}else{
					CallBackFunc(false);
				}
			});
		}
		return;
	});
}

var PassFuncs={
	DHCFuncs:{
		//PassFuncs.DHCFuncs.openShowAuditPopProcess()
		openShowAuditPopProcess:function(){
			try{
				_openShowAuditPopProcess({"userType":"Doc"});	
			}catch(e){
				
			}
		},
		DHCPdssCallBack:function(option){
			//if (option.controlFlag=="Y") option.close() 
		},
        DHCYDTS:function(OrderARCIMCode,OrderName){
			var IncId=""
			//linkUrl="dhcckb.wiki.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName;
			var linkUrl="dhcckb.pdss.instruction.csp?IncId="+IncId+"&IncCode="+OrderARCIMCode+"&IncDesc="+OrderName
			websys_showModal({
				url:linkUrl,
				title:'ҩƷ˵����',
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		},
		DHCXHZY:function(OrderItemStr,CallBackFunc){
			if ((!OrderItemStr)||(OrderItemStr=="")||(OrderItemStr=="undefied")) {CallBackFunc(); return "";}
			var PdssObj=this.HisQueryAdmInfoData();
			if(!PdssObj){CallBackFunc(); return "";}
			var AdmDiagnos=this.HisQueryDiagnosData();
			if (!AdmDiagnos){CallBackFunc(); return "";}
			
			var AdmOrdItem=this.HisQueryOrdData(OrderItemStr);
			if (!AdmOrdItem){CallBackFunc(); return "";}
			PdssObj.ItemDis=AdmDiagnos;
			PdssObj.ItemOrder=AdmOrdItem.ItemOrder;
			PdssObj.ItemHisOrder=AdmOrdItem.ItemHisOrder;
			PdssObj.ItemAyg=this.HisAllergiesData();
			PdssObj.ItemOper=this.HisOperationsData();
			PdssObj.UseType="Doc";
			new Promise(function(resolve){
				var DHCPdss = new PDSS({});
				//DHCPdss.passFlag=1;
				//resolve(DHCPdss);
				DHCPdss.refresh(PdssObj, resolve, 1);  /// �������ӿ�
				if  (DHCPdss.passFlag==1) resolve(DHCPdss);
				//if  ((DHCPdss.passFlag==0)&&(DHCPdss.manLev!="forbid")) resolve(DHCPdss);
			}).then(function(PdssOption){
				//PdssOption.close();
				//resolve();
				CallBackFunc(PdssOption);
			});
		},
		DHCXHZYCM:function(OrderItemStr,CallBackFunc){
			if ((!OrderItemStr)||(OrderItemStr=="")||(OrderItemStr=="undefied")) {CallBackFunc(); return "";}
			var PdssObj=this.HisQueryAdmInfoData();
			if(!PdssObj){CallBackFunc(); return "";}
			var AdmDiagnos=this.HisQueryDiagnosData();
			if (!AdmDiagnos){CallBackFunc(); return "";}
			
			var AdmOrdItem=this.HisQueryOrdDataCM(OrderItemStr);
			if (!AdmOrdItem){CallBackFunc(); return "";}
			PdssObj.ItemDis=AdmDiagnos;
			PdssObj.ItemOrder=AdmOrdItem.ItemOrder;
			PdssObj.ItemHisOrder=AdmOrdItem.ItemHisOrder;
			PdssObj.ItemAyg=this.HisAllergiesData();
			PdssObj.ItemOper=this.HisOperationsData();
			PdssObj.UseType="Doc";
			new Promise(function(resolve){
				var DHCPdss = new PDSS({});
				DHCPdss.refresh(PdssObj, resolve, 1);  /// �������ӿ�
				if  (DHCPdss.passFlag==1) resolve(DHCPdss);
			}).then(function(PdssOption){
				CallBackFunc(PdssOption);
				//resolve();
			});
			//return RetPdssObj;
		},
		HisOperationsData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//��ȡ���߹�����Ϣ 
			var OperationsInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetOperationsInfo",EpisodeID);
			if (OperationsInfo=="") {
				return false;
			}
			var ArrayOperations = new Array();
			var OperationsInfoArr=OperationsInfo.split(String.fromCharCode(1));
			for(var i=0; i<OperationsInfoArr.length ;i++){			
				var OperationsArr=OperationsInfoArr[i].split("^");
		      	var Operations={};       
				Operations.id = OperationsArr[0];        //��ϱ���
		      	Operations.item = OperationsArr[1];     //�������
				ArrayOperations[ArrayOperations.length] = Operations;    
			}
			return ArrayOperations;
		},
		HisAllergiesData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//��ȡ���߹�����Ϣ 
			var AllergiesInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetAllergiesInfo",EpisodeID);
			if (AllergiesInfo=="") {
				return false;
			}
			var ArrayAllergies = new Array();
			var AllergiesInfoArr=AllergiesInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergiesInfoArr.length ;i++){			
				var Allergiesrr=AllergiesInfoArr[i].split("^");
		      	var Allergies={};       
				Allergies.id = Allergiesrr[0];        //��ϱ���
		      	Allergies.item = Allergiesrr[1];     //�������
				ArrayAllergies[ArrayAllergies.length] = Allergies;    
			}
			return ArrayAllergies;
		},
		HisQueryAdmInfoData:function(){
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){
				return false;
			}
			//��ȡ���߾�����Ϣ 
			var PatInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetPrescInfo",EpisodeID);
			if (PatInfo=="") {
				return false;
			}
			var PatArr=PatInfo.split("^");
			var SpecGrpsDesc=PatArr[8];
			var SpecGrpsAry=[];
			if(SpecGrpsDesc!=""){
				SpecGrpsAry=SpecGrpsDesc.split(String.fromCharCode(1));	
			}
			var DHCRecipeDataObj={}
			DHCRecipeDataObj.MsgID=""	//��־���id	����
			DHCRecipeDataObj.Action=""	//Ӧ�ó�����CheckRule����ҩ���,EduRule ��ҩָ��������
			DHCRecipeDataObj.PatName = PatArr[1];				// ��������
			DHCRecipeDataObj.SexProp = PatArr[2];				// �Ա�
			DHCRecipeDataObj.AgeProp = PatArr[3];			// ��������
			DHCRecipeDataObj.Height = PatArr[4];			// ���
			DHCRecipeDataObj.Weight = PatArr[5];			// ����
			DHCRecipeDataObj.BillType= PatArr[6];				//�ѱ� (ҽ��,�Է�)	����
			DHCRecipeDataObj.BloodPress= PatArr[7];				//Ѫѹ	����
			DHCRecipeDataObj.SpecGrps= SpecGrpsAry;				//������Ⱥ	����
			DHCRecipeDataObj.ProfessProp= PatArr[9];				//ְҵ	����
			DHCRecipeDataObj.PatType= PatArr[10];				//��������(����,סԺ,����)	����
			DHCRecipeDataObj.PatLoc= PatArr[11];			//�������	����
			DHCRecipeDataObj.MainDoc= PatArr[12];				//����ҽ��	����
			DHCRecipeDataObj.Group= session['LOGON.GROUPDESC'];	 //��ȫ��-����(��¼��Ϣ)	����(2020/12/1)
			DHCRecipeDataObj.Hospital= session['LOGON.HOSPDESC'];		//ҽԺ-����(��¼��Ϣ)	����(2020/12/1)
			DHCRecipeDataObj.LgCtLoc = session['LOGON.CTLOCDESC'];		//��¼����-����(��¼��Ϣ)	����(2020/12/1)
			DHCRecipeDataObj.LgUser = session['LOGON.USERNAME'];	//��¼�û�-����(��¼��Ϣ)	����(2020/12/1)
			DHCRecipeDataObj.Profess = "";				//ְ��-����(��¼��Ϣ)	����(2020/12/1)
			DHCRecipeDataObj.EpisodeID = EpisodeID;				//����ID	����
			return DHCRecipeDataObj;
		},
		HisQueryDiagnosData:function(){
			///var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			//��ȡ�����Ϣ 
			var MedCondInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetMRDiagnos",EpisodeID);
			if (MedCondInfo==""){
				return false;
			}
			var ArrayMedCond = new Array();
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var Medcond={};       
				Medcond.id = MedCondArr[0];        //��ϱ���
		      	Medcond.item = MedCondArr[1];     //�������
				ArrayMedCond[ArrayMedCond.length] = Medcond;    
			}
			return ArrayMedCond;
		},
		HisQueryOrdDataCM:function(OrderItemStr){
			if (OrderItemStr==""){return false;}
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return false;}
			//��ȡҽ����Ϣ  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,OrderItemStr,"CMOEOrd");
			if (RetOrderInfo==""){
				return false;
			}
			var OutPutObj={};
			var OrderInfo=RetOrderInfo.split(String.fromCharCode(2))[0]; 
			if (OrderInfo=="") return false;
			var HisOrderInfo=RetOrderInfo.split(String.fromCharCode(2))[1]; 
			var ArrayOrder=new Array();
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<OrderInfoArr.length ;i++){			
				var OrderArr=OrderInfoArr[i].split("^");
		      	var ItemOrder={};   
				ItemOrder.SeqNo=OrderArr[0]; //	ҽ�����	����
				ItemOrder.PhDesc=OrderArr[1]; //	ҩƷ����	����
				ItemOrder.FormProp=OrderArr[2]; //	����	����
				ItemOrder.OnceDose=OrderArr[3]; //	���μ���	����
				ItemOrder.Unit=OrderArr[4]; //	���μ�����λ	����
				ItemOrder.DrugPreMet=OrderArr[5]; //	�÷�	����
				ItemOrder.DrugFreq=OrderArr[6]; //	Ƶ��	����
				ItemOrder.Treatment=OrderArr[7]; //	�Ƴ�	����
				ItemOrder.id=OrderArr[8]; //	��ʶ	����
				ItemOrder.LinkSeqNo=OrderArr[9]; //	�������(1, 1.1, 1.2)	����
				ItemOrder.OrdDate=OrderArr[10]; //	ҽ������	����
				ItemOrder.IsFirstUseProp=OrderArr[11]; //	�Ƿ��״�(�״�/���״�)	����
				ItemOrder.DurgSpeedProp=OrderArr[12]; //	��ҩ�ٶ�	����
				ItemOrder.DrugSpeedPropUnit=OrderArr[13]; //	��ҩ�ٶȵ�λ	����
				ItemOrder.OrdEndDate=OrderArr[14]; //	ҽ��ֹͣ����	����(2020/12/17����)
				ItemOrder.ArciMastId=OrderArr[15]; //	ҽ����ID	����        
				ArrayOrder[ArrayOrder.length] = ItemOrder;    
			}
			if (ArrayOrder.length>0) OutPutObj.ItemOrder = ArrayOrder;
			if ((!HisOrderInfo)||(HisOrderInfo=="")||(HisOrderInfo=="undefined")) return OutPutObj;
			var ArrayHisOrder=new Array();
			var HisOrderInfo=HisOrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<HisOrderInfo.length ;i++){			
				var HisOrderArr=HisOrderInfo[i].split("^");
		      	var ItemHisOrder={};   
				ItemHisOrder.SeqNo=HisOrderArr[0]; //	ҽ�����	����
				ItemHisOrder.PhDesc=HisOrderArr[1]; //	ҩƷ����	����
				ItemHisOrder.FormProp=HisOrderArr[2]; //	����	����
				ItemHisOrder.OnceDose=HisOrderArr[3]; //	���μ���	����
				ItemHisOrder.Unit=HisOrderArr[4]; //	���μ�����λ	����
				ItemHisOrder.DrugPreMet=HisOrderArr[5]; //	�÷�	����
				ItemHisOrder.DrugFreq=HisOrderArr[6]; //	Ƶ��	����
				ItemHisOrder.Treatment=HisOrderArr[7]; //	�Ƴ�	����
				ItemHisOrder.id=HisOrderArr[8]; //	��ʶ	����
				ItemHisOrder.LinkSeqNo=HisOrderArr[9]; //	�������(1, 1.1, 1.2)	����
				ItemHisOrder.OrdDate=HisOrderArr[10]; //	ҽ������	����
				ItemHisOrder.IsFirstUseProp=HisOrderArr[11]; //	�Ƿ��״�(�״�/���״�)	����
				ItemHisOrder.DurgSpeedProp=HisOrderArr[12]; //	��ҩ�ٶ�	����
				ItemHisOrder.DrugSpeedPropUnit=HisOrderArr[13]; //	��ҩ�ٶȵ�λ	����
				ItemHisOrder.OrdEndDate=HisOrderArr[14]; //	ҽ��ֹͣ����	����(2020/12/17����)
				ItemHisOrder.ArciMastId=HisOrderArr[15]; //	ҽ����ID	����    
				ArrayHisOrder[ArrayHisOrder.length] = ItemHisOrder;    
			}
			if (ArrayHisOrder.length>0) OutPutObj.ItemHisOrder = ArrayHisOrder;
			return OutPutObj;
		},
        HisQueryOrdData:function (OrderItemStr){
			if ((OrderItemStr=="")||(OrderItemStr=="undefined")){return false;}
			///var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if ((EpisodeID=="")||(EpisodeID=="undefined")){return false;}
			//��ȡҽ����Ϣ  
			var RetOrderInfo=tkMakeServerCall("web.DHCDocHLYYDHC","GetInsertItemOrder",EpisodeID,OrderItemStr);
			if (RetOrderInfo==""){
				return false;
			}
			var OutPutObj={};
			var OrderInfo=RetOrderInfo.split(String.fromCharCode(2))[0]; 
			if (OrderInfo=="") return false;
			var HisOrderInfo=RetOrderInfo.split(String.fromCharCode(2))[1]; 
			var ArrayOrder=new Array();
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<OrderInfoArr.length ;i++){			
				var OrderArr=OrderInfoArr[i].split("^");
		      	var ItemOrder={};    
				ItemOrder.SeqNo=OrderArr[0]; //	ҽ�����	����
				ItemOrder.PhDesc=OrderArr[1]; //	ҩƷ����	����
				ItemOrder.FormProp=OrderArr[2]; //	����	����
				ItemOrder.OnceDose=OrderArr[3]; //	���μ���	����
				ItemOrder.Unit=OrderArr[4]; //	���μ�����λ	����
				ItemOrder.DrugPreMet=OrderArr[5]; //	�÷�	����
				ItemOrder.DrugFreq=OrderArr[6]; //	Ƶ��	����
				ItemOrder.Treatment=OrderArr[7]; //	�Ƴ�	����
				ItemOrder.id=OrderArr[8]; //	��ʶ	����
				ItemOrder.LinkSeqNo=OrderArr[9]; //	�������(1, 1.1, 1.2)	����
				ItemOrder.OrdDate=OrderArr[10]; //	ҽ������	����
				ItemOrder.IsFirstUseProp=OrderArr[11]; //	�Ƿ��״�(�״�/���״�)	����
				ItemOrder.DurgSpeedProp=OrderArr[12]; //	��ҩ�ٶ�	����
				ItemOrder.DrugSpeedPropUnit=OrderArr[13]; //	��ҩ�ٶȵ�λ	����
				ItemOrder.OrdEndDate=OrderArr[14]; //	ҽ��ֹͣ����	����(2020/12/17����)
				ItemOrder.ArciMastId=OrderArr[15]; //	ҽ����ID	���� 
				ArrayOrder[ArrayOrder.length] = ItemOrder;    
			}
			if (ArrayOrder.length>0) OutPutObj.ItemOrder = ArrayOrder;
			if ((!HisOrderInfo)||(HisOrderInfo=="")||(HisOrderInfo=="undefined")) return OutPutObj;
			var ArrayHisOrder=new Array();
			var HisOrderInfo=HisOrderInfo.split(String.fromCharCode(1));
			for(var i=0; i<HisOrderInfo.length ;i++){			
				var HisOrderArr=HisOrderInfo[i].split("^");
		      	var ItemHisOrder={}; 
				ItemHisOrder.SeqNo=HisOrderArr[0]; //	ҽ�����	����
				ItemHisOrder.PhDesc=HisOrderArr[1]; //	ҩƷ����	����
				ItemHisOrder.FormProp=HisOrderArr[2]; //	����	����
				ItemHisOrder.OnceDose=HisOrderArr[3]; //	���μ���	����
				ItemHisOrder.Unit=HisOrderArr[4]; //	���μ�����λ	����
				ItemHisOrder.DrugPreMet=HisOrderArr[5]; //	�÷�	����
				ItemHisOrder.DrugFreq=HisOrderArr[6]; //	Ƶ��	����
				ItemHisOrder.Treatment=HisOrderArr[7]; //	�Ƴ�	����
				ItemHisOrder.id=HisOrderArr[8]; //	��ʶ	����
				ItemHisOrder.LinkSeqNo=HisOrderArr[9]; //	�������(1, 1.1, 1.2)	����
				ItemHisOrder.OrdDate=HisOrderArr[10]; //	ҽ������	����
				ItemHisOrder.IsFirstUseProp=HisOrderArr[11]; //	�Ƿ��״�(�״�/���״�)	����
				ItemHisOrder.DurgSpeedProp=HisOrderArr[12]; //	��ҩ�ٶ�	����
				ItemHisOrder.DrugSpeedPropUnit=HisOrderArr[13]; //	��ҩ�ٶȵ�λ	����
				ItemHisOrder.OrdEndDate=HisOrderArr[14]; //	ҽ��ֹͣ����	����(2020/12/17����)
				ItemHisOrder.ArciMastId=HisOrderArr[15]; //	ҽ����ID	����   
				ArrayHisOrder[ArrayHisOrder.length] = ItemHisOrder;    
			}
			if (ArrayHisOrder.length>0) OutPutObj.ItemHisOrder = ArrayHisOrder;
			return OutPutObj;
		}
    }
}

///ͨ��ҩƷ�໥����
function XHZYClickHandler_HLYY(){
	return ;
	new Promise(function(resolve){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.DHCFuncs.DHCXHZY("",resolve);
	}else{
		PassFuncs.DHCFuncs.DHCXHZYCM("",resolve);
	}
	});
}

function DHCUpdateClick_Save(CallBackFunc,OrderItemStr,DHCHLYYInfo) {
	var OrderItemAry = OrderItemStr.split("^");
	var OrderItemLen = OrderItemAry.length;
	var ApplyOrdIdAllStr = ""
	var HLYYInfoAry = DHCHLYYInfo.split("!!");
	var HLYYInfoLen = HLYYInfoAry.length;
	for (var k = 0; k < HLYYInfoLen; k++) {
		var TempOrderItemAry = OrderItemAry[k].split("*");
		if (TempOrderItemAry.length < 2) continue;
		var newOrdIdDR = TempOrderItemAry[1];
		var TempHLYYInfoAry = HLYYInfoAry[k].split("^");
		var unique = TempHLYYInfoAry[0];
		var drugPassFlag = TempHLYYInfoAry[3];

		if (ApplyOrdIdAllStr == "") ApplyOrdIdAllStr = newOrdIdDR+ "^" + unique+ "^" +drugPassFlag;
		else ApplyOrdIdAllStr = ApplyOrdIdAllStr + "!!" + newOrdIdDR+ "^" + unique+ "^" +drugPassFlag;
	}
	if (ApplyOrdIdAllStr != "") {
		$.cm({
			ClassName:"web.DHCDocHLYYDHC",
			MethodName:"SaveHLYYInfo",
			dataType:"text",
			EpisodeID:GlobalObj.EpisodeID,
			FeedBackStr:ApplyOrdIdAllStr,
			ExpStr:""
		},function(ret){
			if(typeof CallBackFunc == 'function'){
				CallBackFunc(ret);	
			}
		});
	}
	return true;
}