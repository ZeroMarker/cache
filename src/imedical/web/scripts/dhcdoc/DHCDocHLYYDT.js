/**!
* ����:   2016-04-03
* ����������ҩjs���°�ҽ��¼��ʹ�á�
* 
* V2.0
* Update 2018-11-01
* tanjishan
* ��װ������ҩϵͳ��������ֹ������Ⱦ;�����÷������Ա�ҽ��¼��Ͳ�ҩ¼��ͬʱ����
*/
///��ʼ��
function HLYYY_Init(){
	
}
// ͨ�õ�����ҩƷ֪ʶ��
function HLYYYDTS_Click(rowid){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//ѡ��һ��
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
	if (GlobalObj.CurrCompanyCode=="MK"){
		var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
		var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
		var OrderName=mPiece(ArcimInfo,"^",1);
		PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	}else if (GlobalObj.CurrCompanyCode=="DT"){
        PassFuncs.DTCSFuncs.DTYDTS(OrderARCIMRowid, 1);
	}
}

///ͨ��ҩƷ�໥����
function XHZYClickHandler_HLYY(){
	if (GlobalObj.CurrCompanyCode=="MK"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.MKFuncs.MKXHZY();
		}else{
			PassFuncs.MKFuncs.MKXHZYCM();
		}
	}else if(GlobalObj.CurrCompanyCode=="DT"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.DTCSFuncs.DaTongXHZYHander();
		}else{
			PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
		}
	}
}

///��鷽��
function HYLLUpdateClick_HLYY(callBackFun){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	//����ͬ�����
	if (GlobalObj.McSynCheckMode=="0"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
		}else{
			XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
		}
		if (XHZYRetCode > 0){
			$.messager.confirm("ȷ�϶Ի���", t['DT_Question'], function (r) {
				callBackFun(r);
			});
		}else{
			callBackFun(true);
		}
	}else{
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			PassFuncs.MKFuncs.MKXHZYNoView(callBackFun);
		}else{
			PassFuncs.MKFuncs.MKXHZYNoViewCM(callBackFun);
		}
	}
	/*if (GlobalObj.CurrCompanyCode=="DT"){
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHander();
		}else{
			XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
		}
		HLYYCheckFlag =1 ;
    }else if(GlobalObj.CurrCompanyCode=="MK"){
	    if (GlobalObj.McSynCheckMode=="0"){
		    //����ͬ�����
		    if (GlobalObj.HLYYLayOut=="OEOrd"){
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenData();
			}else{
				XHZYRetCode =PassFuncs.MKFuncs.HisScreenDataCM();
			}
		    HLYYCheckFlag =1 ;
		}else{
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				PassFuncs.MKFuncs.MKXHZYNoView();
			}else{
				PassFuncs.MKFuncs.MKXHZYNoViewCM();
			}
		}
	}
	if (HLYYCheckFlag==1){
		if (XHZYRetCode > 0){
			var PrescCheck =dhcsys_confirm("������ҩ����о��棬��ȷ��ͨ����?", true);
			if (PrescCheck ==false) {
				return "-1"
			}
		}
		return 0;
	}else{
		return 100
	}*/
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
		MKXHZYNoView:function (){
			this.MCInit();
			this.HisScreenData();
			if(McRecipeDataList=="") {
				HIS_dealwithPASSCheck(0);
				return false;
			}
			MDC_DoCheck(HIS_dealwithPASSCheck,1);
		},
		//��ҩ¼������������
		MKXHZYNoViewCM:function (){
			this.MCInit();
			this.HisScreenDataCM();
			if(McRecipeDataList=="") {
				HIS_dealwithPASSCheck(0);
				return false;
			}
			MDC_DoCheck(HIS_dealwithPASSCheck,1);
		},
		MCInit:function(){
			var pass = new Params_MC_PASSclient_In();
		    pass.HospID = session['LOGON.HOSPID'];  
		    pass.UserID =session['LOGON.USERID'];
		    pass.UserName = session['LOGON.USERNAME'];
		    pass.DeptID = session['LOGON.CTLOCID'];
		    pass.DeptName = GlobalObj.CTLOC;
			//pass.IP = "";
			//pass.PCName = "";
			///pass.OSInfo = "";     
			//pass.Resolution = ""; 
			//pass.PassVersion = "";
		    pass.CheckMode ="zy"  //MC_global_CheckMode;
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
			var Orders="";
			var Para1=""
			var rowids=$('#Order_DataGrid').getDataIDs();
			for(var i=0;i<rowids.length;i++){
				var Row=rowids[i];
				var OrderItemRowid=GetCellData(Row,"OrderItemRowid");
				var OrderARCIMRowid=GetCellData(Row,"OrderARCIMRowid");
				var OrderType=GetCellData(Row,"OrderType");
				var OrderDurRowid=GetCellData(Row,"OrderDurRowid");
				var OrderFreqRowid=GetCellData(Row,"OrderFreqRowid");
				var OrderInstrRowid=GetCellData(Row,"OrderInstrRowid");
				var OrderDoseQty=GetCellData(Row,"OrderDoseQty");
				var OrderDoseUOMRowid=GetCellData(Row,"OrderDoseUOMRowid");
		    	var OrderDrugFormRowid=GetCellData(Row,"OrderDrugFormRowid");
				var OrderPHPrescType=GetCellData(Row,"OrderPHPrescType");
				var OrderPriorRowId=GetCellData(Row,"OrderPriorRowid");
				var OrderSeqNo=GetCellData(Row,"id");
				
				//$(Row+"_OrderMKLight").html(str);
				var OrderMasterSeqNo=GetCellData(Row,"OrderMasterSeqNo");
				//var obj=document.getElementById("McRecipeCheckLight_"+OrderSeqNo,Row);
			    //�ж��Ƿ����ҩ
			    if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;}
			    if (OrderType!="R") {continue;}
			    if (OrderARCIMRowid=="") {continue;}
			    if (OrderItemRowid!="") {continue;}
			    Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
			    Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+OrderPriorRowId+"!"+OrderSeqNo+"!"+Row+"!"+OrderMasterSeqNo;
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
					if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
				}
			}
			if (Orders==""){return;}
			var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return}
			var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
			var TempArr=ret.split(String.fromCharCode(2));
			var PatInfo=TempArr[0];
			var MedCondInfo=TempArr[1];
			var AllergenInfo=TempArr[2];
			var OrderInfo=TempArr[3];
			var PatArr=PatInfo.split("^");
			
			
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];			// ���˱���
			ppi.InHospNo= PatArr[11]
			ppi.VisitCode =PatArr[7]            // סԺ����
			ppi.Name = PatArr[1];				// ��������
			ppi.Sex = PatArr[2];				// �Ա�
			ppi.Birthday = PatArr[3];			// ��������
			
			ppi.HeightCM = PatArr[5];			// ���
			ppi.WeighKG = PatArr[6];			// ����
			ppi.DeptCode  = PatArr[8];			// סԺ����
			ppi.DeptName  =PatArr[12]
			ppi.DoctorCode =PatArr[13] ;		// ҽ��
			ppi.DoctorName =PatArr[9]
			ppi.PatStatus =1
			ppi.UseTime  = PatArr[4];		   	// ʹ��ʱ��
			ppi.CheckMode = MC_global_CheckMode
			ppi.IsDoSave = 1
			MCpatientInfo  = ppi;
		    var arrayDrug = new Array();
			var pri;
		  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		  	//alert(OrderInfo)
		  	McRecipeCheckLastLightStateArr = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){    
				var OrderArr=OrderInfoArr[i].split("^");
				//����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
		        drug = new Params_Mc_Drugs_In();
		        
		        drug.Index = OrderArr[0];             			//ҩƷ���
		        drug.OrderNo =OrderArr[0]; 		        		//ҽ����
		        drug.DrugUniqueCode = OrderArr[1];  	//ҩƷ����
		        drug.DrugName =  OrderArr[2]; 			//ҩƷ����
		        drug.DosePerTime = OrderArr[3]; 	   //��������
				drug.DoseUnit =OrderArr[4];   	        //��ҩ��λ      
		        drug.Frequency =OrderArr[5]; 	        //��ҩƵ��
		        drug.RouteCode = OrderArr[8]; 	   		//��ҩ;������
		        drug.RouteName = OrderArr[8];   		//��ҩ;������
				drug.StartTime = OrderArr[6];			//����ʱ��
		        drug.EndTime = OrderArr[7]; 			//ͣ��ʱ��
		        drug.ExecuteTime = ""; 	   				//ִ��ʱ��
				drug.GroupTag = OrderArr[10]; 	       //������
		        drug.IsTempDrug = OrderArr[11];          //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
		        drug.OrderType = 0;    //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
		        drug.DeptCode = GlobalObj.CTLOC.split("-")[1];     //�������ұ���
		        drug.DeptName =  GlobalObj.CTLOC; 	  //������������
		        drug.DoctorCode =session['LOGON.USERCODE'];   //����ҽ������
		        drug.DoctorName =session['LOGON.USERNAME'];     //����ҽ������
				drug.RecipNo = "";            //������
		        drug.Num = "";                //ҩƷ��������
		        drug.NumUnit = "";            //ҩƷ����������λ          
		        drug.Purpose = 0;             //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
		        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
				drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
				drug.Remark = "";             //ҽ����ע 
				drug.driprate = ""; //����(120��/����)
				drug.driptime = ""; //��ʱ��(��100����
				arrayDrug[arrayDrug.length] = drug;
		    
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
			var arrayAllergen = new Array();
			var pai;
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		        
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //���  
		      	allergen.AllerCode = AllergenArr[0];    //����
		      	allergen.AllerName = AllergenArr[1];    //����  
		      	allergen.AllerSymptom =AllergenArr[3]; //����֢״ 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//����״̬������
			 var arrayMedCond = new Array();
			var pmi;
		  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		       
		      	var medcond;       
		      	medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i	;              			//������
		     	medcond.DiseaseCode = MedCondArr[0];        //��ϱ���
		      	medcond.DiseaseName = MedCondArr[1];     //�������
		 		medcond.RecipNo = "";              //������
		      	arrayMedCond[arrayMedCond.length] = medcond;     
		      
			}
			McMedCondArray = arrayMedCond;
			
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
		},
		HisScreenDataCM:function (){
			McRecipeDataList="";
			var Orders="";
			var Para1=""
			var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime",PageLogicObj.defaultDataCache, "1");
		    var CurrDateTimeArr = CurrDateTime.split("^");
		    var CurrDate = CurrDateTimeArr[0];
		    var CurrTime = CurrDateTimeArr[1];
		    var OrderSeqNo=0;
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
				   if (OrderARCIMRowid!=""){
					    var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
						var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
						var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
						OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
						
						var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
						var OrderDrugFormRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2);
						var PHCDoseUOMDesc = mPiece(OrderHiddenPara, String.fromCharCode(3), 9);
		                var PHCDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
						var MasterSeqNo="";
						if (Orders!=""){
							var MasterSeqNo=1;
						}
						var OrderSeqNo=OrderSeqNo+1;
				   		Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+PHCDoseUOMRowid;
					    Para1=Para1+"!"+PrescFrequenceRowid+"!"+PrescDurationRowid+"!"+PrescInstructionID+"!"+OrderDrugFormRowid+"!"+OrderSeqNo+"!"+OrderSeqNo+"!"+MasterSeqNo;
						if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
							if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
						}
				   
				   }
			    }
			}
			if (Orders==""){return;}
			var DocName=session['LOGON.USERNAME'];
			var EpisodeID=GlobalObj.EpisodeID;
			if (EpisodeID==""){return}
			var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
			var TempArr=ret.split(String.fromCharCode(2));
			var PatInfo=TempArr[0];
			var MedCondInfo=TempArr[1];
			var AllergenInfo=TempArr[2];
			var OrderInfo=TempArr[3];
			var PatArr=PatInfo.split("^");
			
			
			var ppi = new Params_MC_Patient_In();
			ppi.PatCode = PatArr[0];			// ���˱���
			ppi.InHospNo= PatArr[11]
			ppi.VisitCode =PatArr[7]            // סԺ����
			ppi.Name = PatArr[1];				// ��������
			ppi.Sex = PatArr[2];				// �Ա�
			ppi.Birthday = PatArr[3];			// ��������
			
			ppi.HeightCM = PatArr[5];			// ���
			ppi.WeighKG = PatArr[6];			// ����
			ppi.DeptCode  = PatArr[8];			// סԺ����
			ppi.DeptName  =PatArr[12]
			ppi.DoctorCode =PatArr[13] ;		// ҽ��
			ppi.DoctorName =PatArr[9]
			ppi.PatStatus =1
			ppi.UseTime  = PatArr[4];		   	// ʹ��ʱ��
			ppi.CheckMode = MC_global_CheckMode
			ppi.IsDoSave = 1
			MCpatientInfo  = ppi;
		    var arrayDrug = new Array();
			var pri;
		  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
		  	//alert(OrderInfo)
		  	McRecipeCheckLastLightStateArr = new Array();
			for(var i=0; i<OrderInfoArr.length ;i++){    
				var OrderArr=OrderInfoArr[i].split("^");
				//����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
		        drug = new Params_Mc_Drugs_In();
		        
		        drug.Index = OrderArr[0];             			//ҩƷ���
		        drug.OrderNo =OrderArr[0]; 		        		//ҽ����
		        drug.DrugUniqueCode = OrderArr[1];  	//ҩƷ����
		        drug.DrugName =  OrderArr[2]; 			//ҩƷ����
		        drug.DosePerTime = OrderArr[3]; 	   //��������
				drug.DoseUnit =OrderArr[4];   	        //��ҩ��λ      
		        drug.Frequency =OrderArr[5]; 	        //��ҩƵ��
		        drug.RouteCode = OrderArr[8]; 	   		//��ҩ;������
		        drug.RouteName = OrderArr[8];   		//��ҩ;������
				drug.StartTime = OrderArr[6];			//����ʱ��
		        drug.EndTime = OrderArr[7]; 			//ͣ��ʱ��
		        drug.ExecuteTime = ""; 	   				//ִ��ʱ��
				drug.GroupTag = OrderArr[10]; 	       //������
		        drug.IsTempDrug = OrderArr[11];          //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
		        drug.OrderType = 0;    //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
		        drug.DeptCode = GlobalObj.CTLOC.split("-")[1];     //�������ұ���
		        drug.DeptName =  GlobalObj.CTLOC; 	  //������������
		        drug.DoctorCode =session['LOGON.USERCODE'];   //����ҽ������
		        drug.DoctorName =session['LOGON.USERNAME'];     //����ҽ������
				drug.RecipNo = "";            //������
		        drug.Num = "";                //ҩƷ��������
		        drug.NumUnit = "";            //ҩƷ����������λ          
		        drug.Purpose = 0;             //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
		        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
				drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
				drug.Remark = "";             //ҽ����ע 
				drug.driprate = ""; //����(120��/����)
				drug.driptime = ""; //��ʱ��(��100����
				arrayDrug[arrayDrug.length] = drug;
		    
			}
			McDrugsArray = arrayDrug;
			McRecipeDataList = arrayDrug;
			var arrayAllergen = new Array();
			var pai;
			var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
			for(var i=0; i<AllergenInfoArr.length ;i++){
				var AllergenArr=AllergenInfoArr[i].split("^");
		        
		     	var allergen = new Params_Mc_Allergen_In();
		     	allergen.Index = i;        //���  
		      	allergen.AllerCode = AllergenArr[0];    //����
		      	allergen.AllerName = AllergenArr[1];    //����  
		      	allergen.AllerSymptom =AllergenArr[3]; //����֢״ 
		      	 
				arrayAllergen[arrayAllergen.length] = allergen;
			}
			McAllergenArray = arrayAllergen;
			//����״̬������
			 var arrayMedCond = new Array();
			var pmi;
		  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
			for(var i=0; i<MedCondInfoArr.length ;i++){			
				var MedCondArr=MedCondInfoArr[i].split("^");
		       
		      	var medcond;       
		      	medcond = new Params_Mc_MedCond_In();
		      	medcond.Index = i	;              			//������
		     	medcond.DiseaseCode = MedCondArr[0];        //��ϱ���
		      	medcond.DiseaseName = MedCondArr[1];     //�������
		 		medcond.RecipNo = "";              //������
		      	arrayMedCond[arrayMedCond.length] = medcond;     
		      
			}
			McMedCondArray = arrayMedCond;
			
			var arrayoperation = new Array();
			McOperationArray = arrayoperation;
		},
		HisQueryDataById:function (Row){
			var OrderHiddenPara=GetCellData(Row,"OrderHiddenPara");
			var OrderARCIMCode=mPiece(OrderHiddenPara,String.fromCharCode(1),7);
			var OrderName=GetCellData(Row,"OrderName");
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode; //ҩƷ���
		    drug.CodeName = OrderName;       //ҩƷ����
		    MC_global_queryDrug = drug;	
		}
	},
	DTCSFuncs:{
		//��ͨ ˵����
		DTYDTS:function (Para, ShowType) {
		    var itemid = Para;
		    var myDTYDTSXML = cspRunServerMethod(GlobalObj.GetDTYDTS, itemid);
		    this.dtywzxUI(12, 0, myDTYDTSXML);
		    return;
		},
		///ҽ��¼�������ҩ���
		DaTongXHZYHander:function () {
		    var Orders = "";
		    var Para1 = "";
		    var myrtn = 0;
		    var rowids = $('#Order_DataGrid').getDataIDs();
		    for (var i = 0; i < rowids.length; i++) {
		        //���������
		        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
		        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		        if (OrderItemRowid != "" || OrderARCIMRowid == "") { continue; }

		        var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
		        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
		        var OrderType = GetCellData(rowids[i], "OrderType");
		        var OrderDurRowid = GetCellData(rowids[i], "OrderDurRowid");
		        var OrderFreqRowid = GetCellData(rowids[i], "OrderFreqRowid");
		        var OrderInstrRowid = GetCellData(rowids[i], "OrderInstrRowid");
		        var OrderDoseQty = GetCellData(rowids[i], "OrderDoseQty");
		        var OrderDoseUOMRowid = GetCellData(rowids[i], "OrderDoseUOMRowid");
		        var OrderDrugFormRowid = GetCellData(rowids[i], "OrderDrugFormRowid");
		        var OrderPHPrescType = GetCellData(rowids[i], "OrderPHPrescType")
		        var OrderStartDate = GetCellData(rowids[i], "OrderStartDate")
		        var OrderStartTime = GetCellData(rowids[i], "OrderStartTime")
		        var OrderPriorRowid = GetCellData(rowids[i], "OrderPriorRowid");
		        //�����
		        var MasterSeqNo = "";
		        var OrderSeqNo = GetCellData(rowids[i], "id");
		        var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
		        if (OrderMasterSeqNo != "") MasterSeqNo = OrderMasterSeqNo;
		        //�ж��Ƿ����ҩ
		        //if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

		        Para1 = OrderARCIMRowid + "!" + OrderDoseQty + "!" + OrderDoseUOMRowid;
		        Para1 = Para1 + "!" + OrderFreqRowid + "!" + OrderDurRowid + "!" + OrderInstrRowid + "!" + OrderDrugFormRowid + "!" + MasterSeqNo + "!" + OrderPriorRowid + "!" + OrderStartDate + "!" + OrderStartTime;
		        if ((OrderARCIMRowid != "") && (OrderItemRowid == "") && (OrderType == "R")) {
		            if (Orders == "") { Orders = Para1 } else { Orders = Orders + "^" + Para1 }
		        }
		    }
		    var EpisodeID = GlobalObj.EpisodeID;
		    if (EpisodeID != "") {
		        //var UploadFlag="0";   
		        var DocCode = session['LOGON.USERCODE'];
		        var UserID = session['LOGON.USERID'];
		        //web.DHCandDaTongInterface.GetPrescXML 
		        var myPrescXML = cspRunServerMethod(GlobalObj.GetPrescXML, Orders, EpisodeID, DocCode, UserID);
		        if (GlobalObj.PAAdmType == "I") {
		            myrtn = this.dtywzxUI(28676, 1, myPrescXML);
		        } else {
		            myrtn = this.dtywzxUI(4, 0, myPrescXML);
		        }

		    }
		    return myrtn;
		},
		///��ҩ�ݴ�ͨ������ҩ���
		DaTongXHZYHanderCM:function (){
			var Orders = "";
		    var Para1 = "";
		    var myrtn = 0;
		    var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			
			var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime",PageLogicObj.defaultDataCache, "1");
		    var CurrDateTimeArr = CurrDateTime.split("^");
		    var CurrDate = CurrDateTimeArr[0];
		    var CurrTime = CurrDateTimeArr[1];
			
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
				   if (OrderARCIMRowid!=""){
					    var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
						var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
						var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
						OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
						
						var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
						var OrderDrugFormRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2);
						var PHCDoseUOMDesc = mPiece(OrderHiddenPara, String.fromCharCode(3), 9);
		                var PHCDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
						var MasterSeqNo="";
						if (Orders!=""){
							var MasterSeqNo=1;
						}
						Para1 = OrderARCIMRowid + "!" + OrderDoseQty + "!" + PHCDoseUOMRowid;
				        Para1 = Para1 + "!" + PrescFrequenceRowid + "!" + PrescDurationRowid + "!" + PrescInstructionID + "!" + OrderDrugFormRowid + "!" + MasterSeqNo + "!" + OrderPriorRowid + "!" + CurrDate + "!" + CurrTime;
				        if (Orders == "") { Orders = Para1 } else { Orders = Orders + "^" + Para1 }
				   }
			    }
			}
		    var EpisodeID = GlobalObj.EpisodeID;
		    if (EpisodeID != "") {
		        //var UploadFlag="0";   
		        var DocCode = session['LOGON.USERCODE'];
		        var UserID = session['LOGON.USERID'];
		        //web.DHCandDaTongInterface.GetPrescXML 
		        var myPrescXML = cspRunServerMethod(GlobalObj.GetPrescXML, Orders, EpisodeID, DocCode, UserID);
		        if (GlobalObj.PAAdmType == "I") {
		            myrtn = this.dtywzxUI(28676, 1, myPrescXML);
		        } else {
		            myrtn = this.dtywzxUI(4, 0, myPrescXML);
		        }

		    }
		    return myrtn;
		},
		//��ͨ���ù�������
		dtywzxUI:function (nCode, lParam, sXML) {
		    var result = "";
		    try {
				result = CaesarComponent.dtywzxUI(nCode, lParam, sXML);
			}catch(e){
				$.messager.alert("����","���ô�ͨ������ҩ�ӿ�ʧ��;ʧ��λ��:DHCDocHLYYDT.js��PassFuncs.DTCSFuncs.dtywzxUI"); 
			}
		    return result;
		   
		}
	}
}

///��ͨ�໥���ñ��浽��ͨ������
function DaTongXHZYSave(){
	if (GlobalObj.DTDepNotDoUpLoad==1) return 0; 
	var Orders="";
	var Para1="";
	var myrtn=0;
	var rowids=$('#Order_DataGrid').getDataIDs();
	for(var i=0;i<rowids.length;i++){
		//���������
		var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
		var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
		if(OrderItemRowid != "" || OrderARCIMRowid == ""){continue;}

		var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
		var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
		var OrderType=GetCellData(rowids[i],"OrderType");
		var OrderDurRowid=GetCellData(rowids[i],"OrderDurRowid");
		var OrderFreqRowid=GetCellData(rowids[i],"OrderFreqRowid");
		var OrderInstrRowid=GetCellData(rowids[i],"OrderInstrRowid");
		var OrderDoseQty=GetCellData(rowids[i],"OrderDoseQty");
		var OrderDoseUOMRowid=GetCellData(rowids[i],"OrderDoseUOMRowid");
		var OrderDrugFormRowid=GetCellData(rowids[i],"OrderDrugFormRowid");
		var OrderPHPrescType=GetCellData(rowids[i],"OrderPHPrescType")
		var OrderStartDate=GetCellData(rowids[i],"OrderStartDate")
		var OrderStartTime=GetCellData(rowids[i],"OrderStartTime")
		var OrderPriorRowid=GetCellData(rowids[i],"OrderPriorRowid");
		//�����
    	var MasterSeqNo="";
    	var OrderSeqNo=GetCellData(rowids[i],"id");
    	var OrderMasterSeqNo=GetCellData(rowids[i],"OrderMasterSeqNo");
    	if(OrderMasterSeqNo!="")MasterSeqNo=OrderMasterSeqNo;		
		//�ж��Ƿ����ҩ
		//if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

		Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
		Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime;
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
	var EpisodeID=GlobalObj.EpisodeID;
	if ((EpisodeID!="")){	
		var DocCode=session['LOGON.USERCODE'];
		var UserID=session['LOGON.USERID'];

		var myPrescXML=cspRunServerMethod(GlobalObj.GetPrescXML,Orders,EpisodeID,DocCode,UserID);
		if (GlobalObj.PAAdmType=="I"){
			myrtn=PassFuncs.DTCSFuncs.dtywzxUI(28685,1,myPrescXML);
		}else{
			myrtn=PassFuncs.DTCSFuncs.dtywzxUI(13,0,myPrescXML);
		}
	}
	return myrtn;
}



