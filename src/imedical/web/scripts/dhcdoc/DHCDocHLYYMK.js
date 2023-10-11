/**!
* ����:   2016-04-03
* ����������ҩjs���°�ҽ��¼��ʹ�á�
* 
* V2.0
* Update 2018-11-01
* tanjishan
* ��װ������ҩϵͳ��������ֹ������Ⱦ;�����÷������Ա�ҽ��¼��Ͳ�ҩ¼��ͬʱ����

* V3.0
* Update 2020-11-07
* tanjishan
* ��д�ص���صĴ������������ҹ�ͨ�����ֶΣ��ϲ�ҩʦ�󷽵��߼�
*/
/// ��ʼ��
function HLYYY_Init(){
	PassFuncs.MKFuncs.PASSIM_INIT();
	//$("#YDTS .menu-text").text("ҽ���Բ�ƽ̨");
}

// ͨ�õ�����ҩƷ֪ʶ��
function HLYYYDTS_Click(rowid){
	//�����ĸĳ�ҽ���Բ�ƽ̨
	/*PassFuncs.MKFuncs.MCInit();
	MDC_DoPassCommand(5001);
	return*/
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		if(!rowid){
			var ids =$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
			if(!ids.length){
				$.messager.alert("����","��ѡ��һ��ҽ��");  
				return;
			}
			rowid=ids[0];
		}
		var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("����","��ѡ��һ��ҽ��");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
	var OrderName=mPiece(ArcimInfo,"^",1);
	//PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	}else{
		PassFuncs.MKFuncs.MKYDTSCM(OrderARCIMCode,OrderName);
	}
}

/// ͨ��ҩƷ�໥����
function XHZYClickHandler_HLYY(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.MKFuncs.MKXHZY();
	}else{
		PassFuncs.MKFuncs.MKXHZYCM();
	}
}

/// ��鷽��
function HYLLUpdateClick_HLYYOld(CallBackFunc){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	if (GlobalObj.McSynCheckMode=="0"){
	    //����ͬ�����
	    if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
		}else{
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
		}
	    HLYYCheckFlag =1 ;
	}else{
		var MKCallBackFunc=function(Para){
			if (Para===true){
				CallBackFunc(true)
				return
			}
			//4-��ע���Ƶƣ�3-���ã��ȵƣ�2-���أ���ƣ� 1-���ɣ��ڵƣ�0-û���⣨���ƣ�
			var is_pass = MDC_GetSysPrStatus('', '');
			if ((null == is_pass) || (undefined == is_pass)){
                $.messager.alert("��ʾ", "������ҩ�Զ���֤ͨ��", "info",function(){
		            CallBackFunc(true);
		        });
                return;
            }else if ((0 == is_pass) || (-1 == is_pass)){
                CallBackFunc(false);return;
            }
            else if (1 == is_pass)
            {
               //��֤�Զ��󷽽��
				if (parseInt(Para)==1){
					CallBackFunc(false);
				}else if (parseInt(Para)>1){
					$.messager.confirm('ȷ�϶Ի���',"������ҩ��鷢�����⣬�Ƿ��������ҽ����", function(r){
						if (r) {CallBackFunc(true)}else{CallBackFunc(false);}
					});
				}else{
					CallBackFunc(true);
				}
				return;
            }
			return;
		}
		try{
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				PassFuncs.MKFuncs.MKXHZYNoView(MKCallBackFunc);
			}else{
				PassFuncs.MKFuncs.MKXHZYNoViewCM(MKCallBackFunc);
			}
		}catch(e){
			$.messager.alert("��ʾ", "������ҩ�Զ���֤ͨ��:"+e.message, "info",function(){
	            MKCallBackFunc(true);
	        });
		}
		return;
	}
	if (HLYYCheckFlag==1){
		if (XHZYRetCode > 0){
			var PrescCheck =dhcsys_confirm("������ҩ����о��棬��ȷ��ͨ����?", true);
			if (PrescCheck ==false) {
				CallBackFunc(false)
			}
		}
		CallBackFunc(true)
	}else{
		CallBackFunc(true)
	}
}


//���������װ��������Ļ���������һ����ʶ��
var McRecipeDataList="";
var PassFuncs={
	MKFuncs:{
		//���� ˵����
		MKYDTS:function(OrderARCIMCode,OrderName){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(11)
		},
		//���� ��ѯ��ҩ��ר��
		MKYDTSCM:function(OrderARCIMCode,OrderName){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(24)
		},
		//��ҩ�໥����
		MKXHZY:function (){
			this.MCInit();
			this.HisScreenData();
			if(McRecipeDataList=="") return false;
			MDC_DoCheck();
		},
		//�в�ҩ�໥����
		MKXHZYCM:function (){
			this.MCInit();
			this.HisScreenDataCM();
			if(McRecipeDataList=="") return false;
			MDC_DoCheck();
		},
		//ҽ��¼������������
		MKXHZYNoView:function (CallBackFunc){
			this.MCInit();
			this.HisScreenData();
			if(McRecipeDataList=="") {
				CallBackFunc(true);
				return false;
			}
			MDC_DoCheck(CallBackFunc,1);
		},
		//��ҩ¼������������
		MKXHZYNoViewCM:function (CallBackFunc){
			this.MCInit();
			this.HisScreenDataCM();
			if(McRecipeDataList=="") {
				CallBackFunc(true);
				return false;
			}
			MDC_DoCheck(CallBackFunc,1);
		},
		MCInit:function(){
			var pass = new Params_MC_PASSclient_In();
		    pass.HospID = session['LOGON.HOSPID'];  
		    pass.UserID =session['LOGON.USERCODE'];
		    pass.UserName = session['LOGON.USERNAME'];
		    pass.DeptID = GlobalObj.LogLocCode;
		    pass.DeptName = GlobalObj.CTLOC;
			//pass.IP = "";
			//pass.PCName = "";
			//pass.OSInfo = "";
			//pass.Resolution = "";
			//pass.PassVersion = "";
		    pass.CheckMode =(GlobalObj.PAAdmType=="I"?"zy":"mz");
		    MCPASSclient = pass;
		},
		HisQueryData:function (OrderARCIMCode,OrderName) {
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode; //ҩƷ���
		    drug.CodeName = OrderName;       //ҩƷ����
		    MC_global_queryDrug = drug;
		},
		HisScreenData:function (){
			McRecipeDataList="";
			var OrderStr="";
			var rowids=$('#Order_DataGrid').getDataIDs();
			for(var i=0;i<rowids.length;i++){
				var Row=rowids[i];
				var OrderItemRowid=GetCellData(Row,"OrderItemRowid");
				if (OrderItemRowid!="") {continue;}
				var OrderARCIMRowid=GetCellData(Row,"OrderARCIMRowid");
				if (OrderARCIMRowid=="") {continue;}
				var OrderType=GetCellData(Row,"OrderType");
				if (OrderType!="R") {continue;}
				var OrderPHPrescType=GetCellData(Row,"OrderPHPrescType");
			    if ((OrderPHPrescType==3)&&(GlobalObj.DTCheckCNMed!="1")){continue;}
			    var OrderSeqNo=GetCellData(Row,"id");
			    var OrderDoseQty=GetCellData(Row,"OrderDoseQty");
			    var OrderDoseUOMRowid=GetCellData(Row,"OrderDoseUOMRowid");
			    var OrderFreqRowid=GetCellData(Row,"OrderFreqRowid");
			    var OrderInstrRowid=GetCellData(Row,"OrderInstrRowid");
			    var OrderStartDateStr=GetCellData(Row,"OrderStartDate");
			    var OrderMasterSeqNo=GetCellData(Row,"OrderMasterSeqNo");
			    var OrderPriorRowId=GetCellData(Row,"OrderPriorRowid");
			    var OrderPriorRemarks=GetCellData(Row,"OrderPriorRemarksRowId");
				OrderPriorRowId=ReSetOrderPriorRowid(OrderPriorRowId,OrderPriorRemarks);
			    var OrderDeptId=session['LOGON.CTLOCID'];
				var OrderUserId=session['LOGON.USERID'];
				var VirtualPrescNo=GlobalObj.EpisodeID+"-001"+rowids.length+"";	//���⴦����
			    var OrderPackQty=GetCellData(Row,"OrderPackQty");
				var OrderPackUOMRowid=GetCellData(Row,"OrderPackUOMRowid");
				var OrderDurRowid=GetCellData(Row,"OrderDurRowid");
				var UserReasonId=GetCellData(Row,"UserReasonId");
			    var OrderStageCode=GetCellData(Row,"OrderStageCode");
			    var OrderSpeedFlowRate=GetCellData(Row,"OrderSpeedFlowRate"); 
				var OrderFlowRateUnit=GetCellData(Row,"OrderFlowRateUnitRowId");
			    var OrderRecDepRowid=GetCellData(Row,"OrderRecDepRowid");
				var OrderDepProcNote=GetCellData(Row,"OrderDepProcNote");
				var OrderPhSpecInstr="";	//��ҩ������󷽷�����
				var OrderFirstDayTimes=GetCellData(Row,"OrderFirstDayTimes");
				var OrderCoverMainIns=GetCellData(Row,"OrderCoverMainIns");
				var BillTypeRowid=GetCellData(Row,"OrderBillTypeRowid");
				var Para=OrderSeqNo+"!"+OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+OrderFreqRowid;
				var Para=Para+"!"+OrderInstrRowid+"!"+OrderStartDateStr+"!"+OrderMasterSeqNo+"!"+OrderPriorRowId+"!"+OrderDeptId;
				var Para=Para+"!"+OrderUserId+"!"+VirtualPrescNo+"!"+OrderPackQty+"!"+OrderPackUOMRowid+"!"+OrderDurRowid;
				var Para=Para+"!"+UserReasonId+"!"+OrderStageCode+"!"+OrderSpeedFlowRate+"!"+OrderFlowRateUnit+"!"+OrderRecDepRowid;
				var Para=Para+"!"+OrderDepProcNote+"!"+OrderPhSpecInstr+"!"+OrderFirstDayTimes+"!"+OrderCoverMainIns+"!"+BillTypeRowid;
				//
				if (OrderStr==""){OrderStr=Para;}else{OrderStr=OrderStr+"^"+Para;}
			}
			if (OrderStr==""){return;}
			var UserID=session['LOGON.USERID'];
			var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",GlobalObj.EpisodeID,OrderStr,UserID);
			var TempArr=ret.split(String.fromCharCode(2));
			//���벡�˻�����Ϣ�ӿ�
			var PatInfo=TempArr[0];
			var PatArr=PatInfo.split("^");
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];		//���˱��
			ppi.InHospNo = PatArr[1];		//�����/סԺ��
			ppi.VisitCode = PatArr[2];		//�������/סԺ����
			ppi.Name = PatArr[3];			//��������
			ppi.Sex = PatArr[4];			//�����Ա�
			ppi.Birthday = PatArr[5];		//��������
			ppi.HeightCM = PatArr[6];		//���
			ppi.WeighKG = PatArr[7];		//����
			ppi.DeptCode = PatArr[8];		//������ұ���
			ppi.DeptName = PatArr[9];		//�����������
			ppi.DoctorCode = PatArr[10];	//����/����ҽ������
			ppi.DoctorName = PatArr[11];	//����/����ҽ������
			ppi.PatStatus = PatArr[12];		//��������
			ppi.IsLactation = PatArr[13];	//�Ƿ���
			ppi.IsPregnancy = PatArr[14];	//�Ƿ�����
			ppi.PregStartDate = PatArr[15];	//���￪ʼ����
			ppi.HepDamageDegree = PatArr[16];	//���𺦳���
			ppi.RenDamageDegree = PatArr[17];	//���𺦳���
			ppi.CheckMode = PatArr[18];		//���ģ��
			ppi.IsDoSave = PatArr[19];		//�Ƿ�ɼ�
			ppi.Age = PatArr[20];			//����
			ppi.PayClass = PatArr[21];		//�ѱ�
			ppi.InHospDate = PatArr[22];	//��Ժ����
			ppi.OutHospDate = PatArr[23];	//��Ժ����
			ppi.IsTestEtiology = PatArr[24];	//�Ƿ�������ԭѧ���
			ppi.IDCard = PatArr[25];		//���֤����
			ppi.Telephone = PatArr[26];		//������ϵ�绰
			ppi.Urgent = PatArr[27];		//�Ƿ�Ӽ�
			ppi.MedicareType = PatArr[28];	//ҽ������
			ppi.IsFast = PatArr[29];		//�Ƿ��ʳ
			ppi.Temperature = PatArr[30];	//����
			ppi.PatLevel = PatArr[31];		//�������(ְҵ)
			ppi.medicalcharge = PatArr[32];	//��ҽ��ʽ
			ppi.hospitallevel = PatArr[33];	//ҽԺ����
			ppi.multidaydosepriv = PatArr[34];	//���ⲡ�˳����������������
			ppi.bedno = PatArr[35];		//סԺ�ڼ䴲��
			ppi.documentno = PatArr[36];	//���˲�����
			ppi.isdialysis = PatArr[37];	//�Ƿ�͸������
			MCpatientInfo  = ppi;
			//���벡�˹���ʷ��Ϣ�ӿ�
			var AllergenInfo=TempArr[1];
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			var arrayAllergen = new Array();
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //���  
		      	allergen.AllerCode = AllergenArr[0];	//����
		      	allergen.AllerName = AllergenArr[1];	//����  
		      	allergen.AllerSymptom =AllergenArr[3];	//����֢״ 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//���벡�������Ϣ�ӿ�
			var MedCondInfo=TempArr[2];
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			var arrayMedCond = new Array();
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i;              		//������
		     	medcond.DiseaseCode = MedCondArr[0];	//��ϱ���
		      	medcond.DiseaseName = MedCondArr[1];	//�������
		 		medcond.RecipNo = "";					//������
		      	arrayMedCond[arrayMedCond.length] = medcond;
			}
			McMedCondArray = arrayMedCond;
			//���벡��������Ϣ�ӿ�
			var OperationInfo=TempArr[3];
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
			//���벡����ҩ��Ϣ�ӿ�
			var OrderInfo=TempArr[4];
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		    var arrayDrug = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){
				var OrderArr=OrderInfoArr[i].split("^");
				var drug = new Params_Mc_Drugs_In();
				drug.Index = OrderArr[0];			//ҽ��Ψһ��
		        drug.OrderNo = OrderArr[1];			//ҽ�����
		        drug.DrugUniqueCode = OrderArr[2];  //ҩƷΨһ��
		        drug.DrugName = OrderArr[3]; 		//ҩƷ����
		        drug.DosePerTime = OrderArr[4];		//��������
				drug.DoseUnit = OrderArr[5];		//��ҩ��λ      
		        drug.Frequency = OrderArr[6];		//��ҩƵ��
		        drug.RouteCode = OrderArr[8];		//��ҩ;������
		        drug.RouteName = OrderArr[8];		//��ҩ;������
				drug.StartTime = OrderArr[9];		//����ʱ��
		        drug.EndTime = OrderArr[10];		//ͣ��ʱ��
		        drug.ExecuteTime = OrderArr[11];	//ִ��ʱ��
				drug.GroupTag = OrderArr[12];		//�����ʶ
		        drug.IsTempDrug = OrderArr[13];		//�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
		        if (GlobalObj.PAAdmType!="I"){
			        drug.IsTempDrug = "0";
		        }
		        drug.OrderType = OrderArr[14];		//ҽ������ 0-���ã�Ĭ�ϣ���1-�����ϣ�2-��ͣ����3-��Ժ��ҩ��4-ȡҩҽ����9-�¿�
		        drug.DeptCode = OrderArr[15];		//������ұ���
		        drug.DeptName = OrderArr[16];		//�����������
		        drug.DoctorCode = OrderArr[17];		//����ҽ������ 
		        drug.DoctorName = OrderArr[18];		//����ҽ������
				drug.RecipNo = OrderArr[19];		//������
		        drug.Num = OrderArr[20];			//ҩƷ��������
		        drug.NumUnit = OrderArr[21];		//ҩƷ����������λ     
		        drug.duration = OrderArr[22];		//��ҩ����
		        drug.Purpose = OrderArr[23];		//��ҩĿ�ġ���1����ʾ����Ԥ������2����ʾ�������ƣ���3����ʾԤ������4����ʾ���ƣ���5����ʾԤ��+����, Ĭ��ֵΪ��0��
		        drug.OprCode = OrderArr[24];		//ҩƷ��Ӧ����������
		        drug.MediTime = OrderArr[25]; 		//��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
		        drug.driprate = OrderArr[26];		//����
		        drug.driptime = OrderArr[27];		//��Һʱ��
		        drug.IsOtherRecip = OrderArr[28];	//�Ƿ���ʷ����ҩƷ��Ϣ
		        drug.skintest = OrderArr[29];		//Ƥ�Խ��
		        drug.pharmacycode = OrderArr[30];	//ҩ������
		        drug.pharmacyname = OrderArr[31];	//ҩ������
		        drug.driprange = OrderArr[32];		//���ٷ�Χ
		        drug.doctorpriv = OrderArr[33];		//�Ƿ��ϼ���Ȩ
		        drug.Remark = OrderArr[34];			//ҽ����ע
		        drug.decoction = OrderArr[35];		//��ҩ������󷽷�����
		        drug.firstdayfreq = OrderArr[36];	//������ҩƵ�α��
		        drug.dosetype = OrderArr[37];		//��������
		        drug.ischronicdisease = OrderArr[38];	//�������Բ���ʶ
		        drug.PayClass = OrderArr[39];		//���ѷ�ʽ
				arrayDrug[arrayDrug.length] = drug;
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
		},
		HisScreenDataCM:function (){
			McRecipeDataList="";
			var OrderStr="";
			var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
		    var OrderSeqNo=0;
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val();
					if (OrderARCIMRowid=="") continue;
					var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
					var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
	                var OrderDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
	                var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text();
	                var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns"); 
					var OrderMasterSeqNo="";
					if (OrderStr!=""){OrderMasterSeqNo=1;}
					var OrderSeqNo=OrderSeqNo+1;
					var OrderStartDateStr="";
					var OrderDeptId=session['LOGON.CTLOCID'];
					var OrderUserId=session['LOGON.USERID'];
					var VirtualPrescNo=GlobalObj.EpisodeID+"-001"+rows+"";	//���⴦����
					var OrderPackQty="";
					var OrderPackUOMRowid="";
					var BillTypeRowid=GlobalObj.OrderBillTypeRowid
					var Para=OrderSeqNo+"!"+OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+PrescFrequenceRowid;
					var Para=Para+"!"+PrescInstructionID+"!"+OrderStartDateStr+"!"+OrderMasterSeqNo+"!"+OrderPriorRowid+"!"+OrderDeptId;
					var Para=Para+"!"+OrderUserId+"!"+VirtualPrescNo+"!"+OrderPackQty+"!"+OrderPackUOMRowid+"!"+PrescDurRowid;
					var Para=Para+"!"+""+"!"+""+"!"+""+"!"+""+"!"+OrderRecDepRowid;
					var Para=Para+"!"+""+"!"+OrderPhSpecInstr+"!"+""+"!"+OrderCoverMainIns+"!"+BillTypeRowid;
					//
					if (OrderStr==""){OrderStr=Para;}else{OrderStr=OrderStr+"^"+Para;}
			    }
			}
			if (OrderStr==""){return;}
			var UserID=session['LOGON.USERID'];
			var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",GlobalObj.EpisodeID,OrderStr,UserID);
			var TempArr=ret.split(String.fromCharCode(2));
			//���벡�˻�����Ϣ�ӿ�
			var PatInfo=TempArr[0];
			var PatArr=PatInfo.split("^");
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];		//���˱��
			ppi.InHospNo = PatArr[1];		//�����/סԺ��
			ppi.VisitCode = PatArr[2];		//�������/סԺ����
			ppi.Name = PatArr[3];			//��������
			ppi.Sex = PatArr[4];			//�����Ա�
			ppi.Birthday = PatArr[5];		//��������
			ppi.HeightCM = PatArr[6];		//���
			ppi.WeighKG = PatArr[7];		//����
			ppi.DeptCode = PatArr[8];		//������ұ���
			ppi.DeptName = PatArr[9];		//�����������
			ppi.DoctorCode = PatArr[10];	//����/����ҽ������
			ppi.DoctorName = PatArr[11];	//����/����ҽ������
			ppi.PatStatus = PatArr[12];		//��������
			ppi.IsLactation = PatArr[13];	//�Ƿ���
			ppi.IsPregnancy = PatArr[14];	//�Ƿ�����
			ppi.PregStartDate = PatArr[15];	//���￪ʼ����
			ppi.HepDamageDegree = PatArr[16];	//���𺦳���
			ppi.RenDamageDegree = PatArr[17];	//���𺦳���
			ppi.CheckMode = PatArr[18];		//���ģ��
			ppi.IsDoSave = PatArr[19];		//�Ƿ�ɼ�
			ppi.Age = PatArr[20];			//����
			ppi.PayClass = PatArr[21];		//�ѱ�
			ppi.InHospDate = PatArr[22];	//��Ժ����
			ppi.OutHospDate = PatArr[23];	//��Ժ����
			ppi.IsTestEtiology = PatArr[24];	//�Ƿ�������ԭѧ���
			ppi.IDCard = PatArr[25];		//���֤����
			ppi.Telephone = PatArr[26];		//������ϵ�绰
			ppi.Urgent = PatArr[27];		//�Ƿ�Ӽ�
			ppi.MedicareType = PatArr[28];	//ҽ������
			ppi.IsFast = PatArr[29];		//�Ƿ��ʳ
			ppi.Temperature = PatArr[30];	//����
			ppi.PatLevel = PatArr[31];		//�������(ְҵ)
			ppi.medicalcharge = PatArr[32];	//��ҽ��ʽ
			ppi.hospitallevel = PatArr[33];	//ҽԺ����
			ppi.multidaydosepriv = PatArr[34];	//���ⲡ�˳����������������
			ppi.bedno = PatArr[35];		//סԺ�ڼ䴲��
			ppi.documentno = PatArr[36];	//���˲�����
			ppi.isdialysis = PatArr[37];	//�Ƿ�͸������
			MCpatientInfo  = ppi;
			//���벡�˹���ʷ��Ϣ�ӿ�
			var AllergenInfo=TempArr[1];
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			var arrayAllergen = new Array();
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //���  
		      	allergen.AllerCode = AllergenArr[0];	//����
		      	allergen.AllerName = AllergenArr[1];	//����  
		      	allergen.AllerSymptom =AllergenArr[3];	//����֢״ 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//���벡�������Ϣ�ӿ�
			var MedCondInfo=TempArr[2];
			var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			var arrayMedCond = new Array();
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		      	var medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i;              		//������
		     	medcond.DiseaseCode = MedCondArr[0];	//��ϱ���
		      	medcond.DiseaseName = MedCondArr[1];	//�������
		 		medcond.RecipNo = "";					//������
		      	arrayMedCond[arrayMedCond.length] = medcond;
			}
			McMedCondArray = arrayMedCond;
			//���벡��������Ϣ�ӿ�
			var OperationInfo=TempArr[3];
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
			//���벡����ҩ��Ϣ�ӿ�
			var OrderInfo=TempArr[4];
			var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		    var arrayDrug = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){
				var OrderArr=OrderInfoArr[i].split("^");
				var drug = new Params_Mc_Drugs_In();
				drug.Index = OrderArr[0];			//ҽ��Ψһ��
		        drug.OrderNo = OrderArr[1];			//ҽ�����
		        drug.DrugUniqueCode = OrderArr[2];  //ҩƷΨһ��
		        drug.DrugName = OrderArr[3]; 		//ҩƷ����
		        drug.DosePerTime = OrderArr[4];		//��������
				drug.DoseUnit = OrderArr[5];		//��ҩ��λ      
		        drug.Frequency = OrderArr[6];		//��ҩƵ��
		        drug.RouteCode = OrderArr[7];		//��ҩ;������
		        drug.RouteName = OrderArr[8];		//��ҩ;������
				drug.StartTime = OrderArr[9];		//����ʱ��
		        drug.EndTime = OrderArr[10];		//ͣ��ʱ��
		        drug.ExecuteTime = OrderArr[11];	//ִ��ʱ��
				drug.GroupTag = OrderArr[12];		//�����ʶ
		        drug.IsTempDrug = OrderArr[13];		//�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
		        drug.OrderType = OrderArr[14];		//ҽ������ 0-���ã�Ĭ�ϣ���1-�����ϣ�2-��ͣ����3-��Ժ��ҩ��4-ȡҩҽ����9-�¿�
		        drug.DeptCode = OrderArr[15];		//������ұ���
		        drug.DeptName = OrderArr[16];		//�����������
		        drug.DoctorCode = OrderArr[17];		//����ҽ������ 
		        drug.DoctorName = OrderArr[18];		//����ҽ������
				drug.RecipNo = OrderArr[19];		//������
		        drug.Num = OrderArr[20];			//ҩƷ��������
		        drug.NumUnit = OrderArr[21];		//ҩƷ����������λ     
		        drug.duration = OrderArr[22];		//��ҩ����
		        drug.Purpose = OrderArr[23];		//��ҩĿ�ġ���1����ʾ����Ԥ������2����ʾ�������ƣ���3����ʾԤ������4����ʾ���ƣ���5����ʾԤ��+����, Ĭ��ֵΪ��0��
		        drug.OprCode = OrderArr[24];		//ҩƷ��Ӧ����������
		        drug.MediTime = OrderArr[25]; 		//��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
		        drug.driprate = OrderArr[26];		//����
		        drug.driptime = OrderArr[27];		//��Һʱ��
		        drug.IsOtherRecip = OrderArr[28];	//�Ƿ���ʷ����ҩƷ��Ϣ
		        drug.skintest = OrderArr[29];		//Ƥ�Խ��
		        drug.pharmacycode = OrderArr[30];	//ҩ������
		        drug.pharmacyname = OrderArr[31];	//ҩ������
		        drug.driprange = OrderArr[32];		//���ٷ�Χ
		        drug.doctorpriv = OrderArr[33];		//�Ƿ��ϼ���Ȩ
		        drug.Remark = OrderArr[34];			//ҽ����ע
		        drug.decoction = OrderArr[35];		//��ҩ������󷽷�����
		        drug.firstdayfreq = OrderArr[36];	//������ҩƵ�α��
		        drug.dosetype = OrderArr[37];		//��������
		        drug.ischronicdisease = OrderArr[38];	//�������Բ���ʶ
		        drug.PayClass = OrderArr[39];		//���ѷ�ʽ
				arrayDrug[arrayDrug.length] = drug;
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
		},
		HisQueryDataById:function (Row){
			var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
			var OrderARCIMCode=mPiece(OrderHiddenPara,String.fromCharCode(1),11);
			var OrderName=GetCellData(Row,"OrderName");
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode; //ҩƷ���
		    drug.CodeName = OrderName;       //ҩƷ����
		    MC_global_queryDrug = drug;	
		},
		//��ʼ������ͨѶ����
		PASSIM_INIT:function(){
			if (typeof Params_MC_PASSIM_In !="undefined"){
				var im=new Params_MC_PASSIM_In()
				im.hiscode="0"
				im.doctor=session['LOGON.USERCODE'];
				im.Init()
			}
		}
	}
}

function OnMouseUpRightMenu1(){
	if (event.button==2) {
		if (GlobalObj.HLYYInterface!=1) return;
		var Row=GetRow(FocusRowIndex);
		var OrderHiddenPara=GetColumnData("OrderHiddenPara",Row);
		var OrderARCIMCode=mPiece(OrderHiddenPara,String.fromCharCode(1),7);
		if(OrderARCIMCode=="") return;
		var OrderType=GetColumnData("OrderType",Row);
		if (OrderType=="R"){
			QueryItemclick();
			OnMouseUpRightMenu(1,-2,"true");
		}
	}
}

function XHZYAJ_Click(){
	if ((DHCDTInterface==1)){
  		MenuClick();
  	}
}

/*function HIS_dealwithPASSCheck(result) {
    if (result > 0) {
        if (confirm("������ҩ���⣬��ȷ����Ҫ���洦����")) 
        {
        	var slcode1=MDC_getWarningCode("1");
        	//���淵��ֵ 
         
          var slcode1 = MDC_getWarningCode("1");
         alert("���ؽ����:"+slcode1);                	
        	location.reload(true);   //���û�ѡ���ǡ�����ˢ�µ�ǰҳ��
        }
    }
    else {
        alert("û����");
    }
}*/

///�Ҽ�����
function YLYYOnRightClick(Row){
	if (GlobalObj.HLYYInterface!=1){
		return;
	}
	if (GlobalObj.HLYYLayOut!="OEOrd"){
		return;
	}
	var OrderType=GetCellData(Row,"OrderType");
	if(OrderType!="R") return 
	if (GlobalObj.HLYYInterface==1){
		PassFuncs.MKFuncs.MCInit();
		PassFuncs.MKFuncs.HisQueryDataById(Row);
		McPASS.McRightMenu()
		
		var rowids=GetAllRowId();
		for(var i=0;i<rowids.length;i++){
			if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")=="checked"){
				$("#Order_DataGrid").setSelection(rowids[i],false);
			}				
		}
		if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")!="checked"){
			$("#Order_DataGrid").setSelection(Row,true);
		}
	}	
}
function HYLLUpdateClick_HLYY(CallBackFunc){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	new Promise(function (resolve, rejected) {
		if (GlobalObj.McSynCheckMode=="0"){
			//����ͬ�����
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
			}else{
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
			}
			HLYYCheckFlag =1 ;
			resolve(true)
		}else{
			try{
				if (GlobalObj.HLYYLayOut=="OEOrd"){
					PassFuncs.MKFuncs.MKXHZYNoView(resolve);
				}else{
					PassFuncs.MKFuncs.MKXHZYNoViewCM(resolve);
				}
			}catch(e){
				$.messager.alert("��ʾ", "������ҩ�Զ���֤ͨ��:"+e.message, "info",function(){
					resolve(true);
				});
			}
		}
	}).then(function (Para) {
		return new Promise(function(resolve,rejected){
			if (Para===true){
				CallBackFunc(true);
				return;
			}
			//https�޷���������JS,ֱ�ӷ���
			if (typeof MDC_GetSysPrStatus != "function") {
				CallBackFunc(true);
				return;
			}
			//Para��4-��ע���Ƶƣ�3-���ã��ȵƣ�2-���أ���ƣ� 1-���ɣ��ڵƣ�0-û���⣨���ƣ�
			//is_pass��1 ͨ����0 δͨ�� -1 ����(δ��������) ��
			var is_pass = MDC_GetSysPrStatus('', '');
			if ((null == is_pass) || (undefined == is_pass)){
				$.messager.alert("��ʾ", "������ҩ�Զ�ͨ����֤", "info",function(){
					CallBackFunc(true);
				});
			}else if ((0 == is_pass) || (-1 == is_pass)){
				CallBackFunc(false);
			}else if (1 == is_pass){		//ҩʦ��ͨ��
				if(parseInt(Para)>0){		//�о�ʾ��Ϣ����ҽ���Ƿ񱣴�
					new Promise(function(resolve,rejected){
						$.messager.confirm('ȷ�϶Ի���',"������ҩ��鷢�����⣬�Ƿ��������ҽ����", function(r){
							if (r){ CallBackFunc(true); }
							else{ CallBackFunc(false); }
						});
					});
				}else{
					CallBackFunc(true);
				}
			}else{
					CallBackFunc(true);
			}
		})
	})
}