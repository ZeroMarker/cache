function InitReportWinEvent(obj) {
	
	obj.LoadEvent = function(){
		obj.DisplayRepInfo();
		obj.InitRepPowerByStatus(ReportID);
		obj.RelationToEvents(); // ��ť�����¼� 
		top.$("#WinModalEasyUI").empty();
	}	
	//��ʾ��ť����Ȩ�� ���ݱ���״̬�����Ȩ�޿���
		obj.InitRepPowerByStatus = function(ReportID){		
		$('#btnSave').hide();
		$('#btnPrint').hide();
		$('#btnCanCheck').hide();
		$('#btnDelete').hide();
		$('#btnCheck').hide();
		$('#btnCancle').hide();
		$('#btnReturn').hide();
		$('#btnSaveTemp').hide();
		
		obj.RepStatusCode = $m({                  
			ClassName:"DHCMed.CDService.Service",
			MethodName:"GetReportStatus",
			aReportID:ReportID
		},false);
		
     	switch (obj.RepStatusCode) {
			case "" : // �ޱ��� ֻ���ϱ�
				$('#btnSave').show();
				$('#btnSaveTemp').show();
				$('#btnCancle').show();
				break;
			case "1" : // ����
				$('#btnSave').linkbutton({text:$g('�޸ı���')});
				$('#btnSave').show();
				$('#btnDelete').show();
				if (LocFlag==1){
					$('#btnCheck').show();
					$('#btnReturn').show();
				}
				$('#btnPrint').show();
				$('#btnCancle').show();
				break;
			case "2" : // ���
				if (LocFlag==1){
					$('#btnCanCheck').show();
				}
				$('#btnPrint').show();
				$('#btnCancle').show();
				break;
			case "3" : // ����
				$('#btnCancle').show();
				break;
			case "4" : // �ݸ�
				$('#btnSaveTemp').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
			case "5" : // �˻�
				$('#btnSave').linkbutton({text:$g('�޸ı���')});
				$('#btnSaveTemp').show();
				$('#btnDelete').show();
				$('#btnSave').show();
				$('#btnCancle').show();
				break;
		}
		
		if (tDHCMedMenuOper['Submit']!=1) {//û���ύȨ�ޣ����ر��水ť
			$('#btnSave').hide();
		}
		if (tDHCMedMenuOper['Check']!=1) { //û�����Ȩ�ޣ�������˰�ť
			$('#btnCheck').hide();
			$('#btnCanCheck').hide();
		}
		if (tDHCMedMenuOper['Check']) {
			$('#btnDelete').hide();
		}
	}
	
	obj.DisplayRepInfo = function(){
		if(obj.ReportID==""){
			$('#txtDoctor').val(DocName);
			$('#cboCRReportLoc').combobox('setValue',LocID);                    //��������
			$('#cboCRReportLoc').combobox('setText',LocDesc);                  
			$('#txtOrgan').val(HospDesc);
			$('#dtRepDate').datebox('setValue',Common_GetDate(new Date()));
			if(PatientID!=""){
				var objPat = $cm({                  
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:PatientID
				},false);
				// ��ʼ����������
				var PatStatus = $m({                  
					ClassName:"DHCMed.CD.CRReportGXY",
					MethodName:"GetPatStatusByPaadm",
					aPatientID:PatientID
				},false);
				$('#PatStatus').val(PatStatus);
				
				$('#txtRegNo').val(objPat.PapmiNo);
				$('#txtPatName').val(objPat.PatientName);
				$('#txtSex').val(objPat.Sex);
				var PersonalIDType=objPat.PersonalIDType;				//֤������
				if(PersonalIDType!=$g("�������֤")){
					$('#txtPatCardNo').val("");     
				}
				else{
					$('#txtPatCardNo').val(objPat.PersonalID);                //���֤��
				}
			    $('#txtBirthDay').datebox('setValue',objPat.Birthday); 
				var AgeY=objPat.Age;
				var AgeM=objPat.AgeMonth;
				var AgeD=objPat.AgeDay;
				if (AgeY>0){
					$('#txtAge').val(objPat.Age);
					$('#cboPatAgeDW').combobox('setValue',$g('��'));
				}else if(AgeM>0){
					$('#txtAge').val(objPat.AgeMonth);
					$('#cboPatAgeDW').combobox('setValue',$g('��'));
				}else {
					$('#txtAge').val(objPat.AgeDay);
					$('#cboPatAgeDW').combobox('setValue',$g('��'));
				}
				if (ServerObj.CurrAddress) { // �ֵ�ַ
					$('#cboCurrProvince').combobox('setValue',ServerObj.CurrAddress.split("^")[0]);                    
					$('#cboCurrProvince').combobox('setText',ServerObj.CurrAddress.split("^")[1]);                  
					$('#cboCurrCity').combobox('setValue',ServerObj.CurrAddress.split("^")[2]);                    
					$('#cboCurrCity').combobox('setText',ServerObj.CurrAddress.split("^")[3]);                  
					$('#cboCurrCounty').combobox('setValue',ServerObj.CurrAddress.split("^")[4]);                    
					$('#cboCurrCounty').combobox('setText',ServerObj.CurrAddress.split("^")[5]);                  
					$('#cboCurrVillage').combobox('setValue',ServerObj.CurrAddress.split("^")[6]);                    
					$('#cboCurrVillage').combobox('setText',ServerObj.CurrAddress.split("^")[7]);                  
					$('#txtCurrRoad').val(ServerObj.CurrAddress.split("^")[8]);    
					$('#txtCurrAddress').val(ServerObj.PatCurrAddress);
					if (session['LOGON.LANGCODE']=="EN"){
						$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText'));
					}
				}			
			}
		}else{
			var objRep = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"GetStringById",
				id:obj.ReportID
			},false);
		    var objGXY = $m({                  
				ClassName:"DHCMed.CD.CRReportGXY",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var objPat = $m({                  
				ClassName:"DHCMed.CD.CRReportPAT",
				MethodName:"GetStringByParRef",
				ParRef:obj.ReportID
			},false);
			var arrRep=objRep.split("^");
			var arrGXY=objGXY.split("^");
			var arrPat=objPat.split("^");
			
			// ���߻�����Ϣ
			$('#txtRegNo').val(arrPat[3]);
			$('#txtPatName').val(arrPat[4]);
			$('#txtSex').val(arrPat[6]);
			$('#txtBirthDay').datebox('setValue',arrPat[7]);
			$('#txtPatCardNo').val(arrPat[11]);
			var patAge="";
			var patAgeDW="";
			if(arrPat[8]!=""){
				patAge=arrPat[8];
				patAgeDW=$g("��");
			}else if(arrPat[9]!=""){
				patAge=arrPat[9];
				patAgeDW=$g("��");
			}else{
				patAge=arrPat[10];
				patAgeDW=$g("��");
			}
			$('#txtAge').val(patAge);
			$('#cboPatAgeDW').combobox('setValue',patAgeDW);
			$('#cboNation').combobox('setValue',arrPat[13].split(CHR_1)[0]);
			$('#cboNation').combobox('setText',((arrPat[13].indexOf(CHR_1)>-1) ? arrPat[13].split(CHR_1)[1] : ''));
			$('#cboCurrProvince').combobox('setValue',arrPat[29].split(CHR_1)[0]);
			$('#cboCurrProvince').combobox('setText',((arrPat[29].indexOf(CHR_1)>-1) ? arrPat[29].split(CHR_1)[1] : ''));
			$('#cboCurrCity').combobox('setValue',arrPat[30].split(CHR_1)[0]);
		    $('#cboCurrCity').combobox('setText',((arrPat[30].indexOf(CHR_1)>-1) ? arrPat[30].split(CHR_1)[1] : ''));
			$('#cboCurrCounty').combobox('setValue',arrPat[31].split(CHR_1)[0]);
			$('#cboCurrCounty').combobox('setText',((arrPat[31].indexOf(CHR_1)>-1) ? arrPat[31].split(CHR_1)[1] : ''));
			$('#cboCurrVillage').combobox('setValue',arrPat[32].split(CHR_1)[0]);
			$('#cboCurrVillage').combobox('setText',((arrPat[32].indexOf(CHR_1)>-1) ? arrPat[32].split(CHR_1)[1] : ''));
			$('#txtCurrRoad').val(arrPat[33]);
			$('#txtCurrAddress').val(arrPat[34]);
			
			// ������Ϣ
			$('#cboCRReportLoc').combobox('setValue',arrRep[3]);
			$('#cboCRReportLoc').combobox('setText',arrRep[4]);
			$('#txtDoctor').val(arrRep[5]);
			$('#txtOrgan').val(arrRep[6]);
			$('#dtRepDate').datebox('setValue',arrRep[7]);
			
			// ��Ѫѹ������Ϣ
			$('#txtKPBH').val(arrGXY[0]);
			$('#PatStatus').val(arrGXY[1]);
			$('#txtFamilyCount').val(arrGXY[2]);
			for (var len=0; len < arrGXY[3].split(',').length;len++) {       
				var valueCode = arrGXY[3].split(',')[len];
				$('#chkRelations'+valueCode).checkbox('setValue',(valueCode!=""?true:false));           //�������
			}
			obj.CRGXYZDID = arrGXY[4].split(CHR_1)[0];
			$('#cboCRGXYZD').lookup('setText',arrGXY[4].split(CHR_1)[1]);
			$('#txtCRGXYZDICD').val(arrGXY[5]);
			$('#txtWeight').val(arrGXY[6]);
			$('#txtHeight').val(arrGXY[7]);
			for (var len=0; len < arrGXY[8].split(',').length;len++) {       
				var valueCode = arrGXY[8].split(',')[len];
				$('#chkSymptoms'+valueCode).checkbox('setValue',(valueCode!=""?true:false));           //�������
			}
			$('#txtSSY').val(arrGXY[9]);
			$('#txtSZY').val(arrGXY[10]);
			$('#txtHeartRate').val(arrGXY[11]);
			$('#txtResume').val(arrGXY[12]);
		
		}
	};
	
   obj.GetRepData = function (step) {
		
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+EpisodeID;
		InputStr=InputStr+"^"+"GXY";
		InputStr=InputStr+"^"+step;   //CRReportStatus:1�ϱ���2��ˣ�3����
		InputStr=InputStr+"^"+$.trim($('#cboCRReportLoc').combobox('getValue')); //session['LOGON.CTLOCID'];
		InputStr=InputStr+"^"+$.trim($('#txtDoctor').val());
		InputStr=InputStr+"^"+$.trim($('#txtOrgan').val());
		InputStr=InputStr+"^"+$('#dtRepDate').datebox("getValue"); 
		InputStr=InputStr+"^"+""; 
		InputStr=InputStr+"^"+session['LOGON.USERID'];
		InputStr=InputStr+"^"+"";	 			//��������	11
		InputStr=InputStr+"^"+"";	 			//����ʱ��	12
		InputStr=InputStr+"^"+"0";	 			//��˱��	13
		InputStr=InputStr+"^"+"";	 			//�����	14
		InputStr=InputStr+"^"+"";	 			//�������	15
		InputStr=InputStr+"^"+"";	 			//���ʱ��	16
		InputStr=InputStr+"^"+"0";	 			//�������	17
		InputStr=InputStr+"^"+"";	 			//������	18
		InputStr=InputStr+"^"+"";	 			//��������	19
		InputStr=InputStr+"^"+"";	 			//����ʱ��	20
		InputStr=InputStr+"^"+"";	 			//��ע		21
		InputStr=InputStr+"^"+session['LOGON.CTLOCID'];	//���¿���		22
      
		return InputStr;
	}
	
	obj.GetGXYData = function () {
	
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+$.trim($('#txtKPBH').val());                  // ���
		InputStr=InputStr+"^"+$.trim($('#PatStatus').val());                // ��������
		InputStr=InputStr+"^"+$.trim($('#txtFamilyCount').val());           // ��ͥ��Ա����
		InputStr=InputStr+"^"+Common_CheckboxValue('chkRelations');   	 	// �и�Ѫѹʷ�ĳ�Ա
		InputStr=InputStr+"^"+ obj.CRGXYZDID;								// ��Ѫѹ���ID
		InputStr=InputStr+"^"+$.trim($('#txtCRGXYZDICD').val());            // ��Ѫѹ���ICD
		InputStr=InputStr+"^"+$.trim($('#txtWeight').val());          	  	// ���
		InputStr=InputStr+"^"+$.trim($('#txtHeight').val());           	 	// ����
		InputStr=InputStr+"^"+Common_CheckboxValue('chkSymptoms');   	 	// ֢״
		InputStr=InputStr+"^"+$.trim($('#txtSSY').val());           	 	// ����ѹ
		InputStr=InputStr+"^"+$.trim($('#txtSZY').val());           	 	// ����ѹ
		InputStr=InputStr+"^"+$.trim($('#txtHeartRate').val());           	// ����
		InputStr=InputStr+"^"+$.trim($('#txtResume').val());           	 	// ����
		return InputStr;
	}
	
	obj.GetPatData = function () {
		var Age	  = $.trim($('#txtAge').val());                       //����
		var AgeDW = $.trim($('#cboPatAgeDW').combobox('getValue'));	  //���䵥λ
		var NLS,NLY,NLT="";
		if(AgeDW==$g("��")){
			NLS=Age;
			NLY="";
			NLT="";
		}else if(AgeDW==$g("��")){
			NLY=Age;
			NLT="";
			NLS="";
		}else{
			NLT=Age;
			NLY="";
			NLS="";
		}
		var InputStr=obj.ReportID;
		InputStr=InputStr+"^"+PatientID;   //2
		InputStr = InputStr+"^"+"";	                    					//CRMZH3
		InputStr = InputStr+"^"+"";	                    					//CRZYH4
		InputStr = InputStr+"^"+$.trim($('#txtRegNo').val());						//CRDJH5
		InputStr = InputStr+"^"+$.trim($('#txtPatName').val());						//CRXM6
		InputStr = InputStr+"^"+"";	                                        //CRJZXM7
		InputStr = InputStr+"^"+$.trim($('#txtSex').val());;	                    //CRXB8
		InputStr = InputStr+"^"+$('#txtBirthDay').datebox('getValue');	    //CRCSRQ9
		InputStr = InputStr+"^"+NLS;	                                    //CRNLS10
		InputStr = InputStr+"^"+NLY;	                                    //CRNLY11
		InputStr = InputStr+"^"+NLT;	                                    //CRNLT12
		InputStr = InputStr+"^"+$.trim($('#txtPatCardNo').val());;	                //CRSFZH13
		InputStr = InputStr+"^"+"";	                                        //CRJTDH14
		InputStr = InputStr+"^"+$.trim($('#cboNation').combobox('getValue')); // CRMZ15 ����
		InputStr = InputStr+"^"+"";	    //CRHYZK16
		InputStr = InputStr+"^"+"";	//CRWHCD17
		InputStr = InputStr+"^"+"";	//CRZY18
		InputStr = InputStr+"^"+"";	    //CRGZ19
		InputStr = InputStr+"^"+"";	                                        //CRLXR20
		InputStr = InputStr+"^"+"";	                                        //CRYBRGX21
		InputStr = InputStr+"^"+"";	                    //CRLXDH22
		InputStr = InputStr+"^"+"";	                    //CRGZDW23
		InputStr = InputStr+"^"+""; //$.trim($('#cboPatHJ').combobox('getValue'));;	    //CRHJ24
		InputStr = InputStr+"^"+"";	//CRHJDZS25
		InputStr = InputStr+"^"+"";      //CRHJDZS226
		InputStr = InputStr+"^"+"";    //CRHJDZX27
		InputStr = InputStr+"^"+"";	//CRHJDZX228
		InputStr = InputStr+"^"+"";                     //CRHJDZC29
		InputStr = InputStr+"^"+"";	                //CRHJDZXX30
		InputStr = InputStr+"^"+$.trim($('#cboCurrProvince').combobox('getValue'));	//CRCZDZS31
		InputStr = InputStr+"^"+$.trim($('#cboCurrCity').combobox('getValue'));     //CRCZDZS232
		InputStr = InputStr+"^"+$.trim($('#cboCurrCounty').combobox('getValue'));   //CRCZDZX33
		InputStr = InputStr+"^"+$.trim($('#cboCurrVillage').combobox('getValue'));	//CRCZDZX234
		InputStr = InputStr+"^"+$.trim($('#txtCurrRoad').val());                    //CRCZDZC35
		InputStr = InputStr+"^"+$.trim($('#txtCurrAddress').val());	                //CRCZDZXX36
		return InputStr;
	}
	
	// ��ť�����¼�
	obj.RelationToEvents = function() {
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		$('#btnSaveTemp').on("click", function(){
			obj.btnSaveTemp_click();
		});
		$('#btnDelete').on("click", function(){
			obj.btnDelete_click(); 
		});
		$('#btnCheck').on("click", function(){
			obj.btnCheck_click(); 
		});
		$('#btnCanCheck').on("click", function(){	//ȡ�����
			obj.btnCanCheck_click(); 		
		});
		$('#btnPrint').on("click", function(){
			obj.btnPrint_click(); 
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_click(); 
		});
		$('#btnReturn').on("click", function(){
			$.messager.prompt($g("�˻�"), $g("�������˻�ԭ��!"), function (r) {
				if (r){
					obj.btnReturn_click(r); 
				}else if(r==""){
					$.messager.alert($g("��ʾ"),$g("�˻�ԭ����Ϊ��!"), 'info');
				}	
			});
		});
	}	
	// �ݸ�
	obj.btnSaveTemp_click = function(){
		var RepData=obj.GetRepData(4);
		var GXYData=obj.GetGXYData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:GXYData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("�ݸ����ݱ������!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("�ݸ����ݱ���ɹ���<br>�뼰ʱ���Ƹ�Ѫѹ��Ϣ!"), 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			//׷������Ԫ�أ�����ǿ�Ʊ��汣��ʧ��ʱ�������
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//�½����汣��ɹ��󲻹رմ���ֱ��ˢ��ʱ��������ʾ�հ����⴦��
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		}
	};
	obj.btnSave_click = function(){
		if (obj.CheckReport() != true) return;
		var RepData=obj.GetRepData(1);
		var GXYData=obj.GetGXYData();
		var PatData=obj.GetPatData();
		var ExtraData="";
		
		var ret = $m({                  
			ClassName:"DHCMed.CDService.UpdateService",
			MethodName:"SaveRepData",
			ParRefInfo:RepData,
			ChildInfo:GXYData,
			PatInfo:PatData,
			ExtraInfo:ExtraData
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("���ݱ������!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("���ݱ���ɹ�!"), 'info');
			obj.ReportID=ret;
			obj.DisplayRepInfo();
			obj.InitRepPowerByStatus(obj.ReportID);
			//׷������Ԫ�أ�����ǿ�Ʊ��汣��ʧ��ʱ�������
			top.$("#WinModalEasyUI").append("<input type='hidden' id='flag' value='1'>");
			//�½����汣��ɹ��󲻹رմ���ֱ��ˢ��ʱ��������ʾ�հ����⴦��
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:obj.ReportID
		        });
		    	history.pushState("", "", Url);
		        return;
			}
		}
	};
	obj.btnDelete_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("��δ�ϱ�!"), 'error');
			return;
		}
		$.messager.confirm($g("��ʾ"),$g("��ȷ���Ƿ�����?"),function(r){
			if(r){
				var DeleteStr=obj.ReportID;
				DeleteStr=DeleteStr+"^"+3
				DeleteStr=DeleteStr+"^"+session['LOGON.USERID'];
				DeleteStr=DeleteStr+"^"+session['LOGON.CTLOCID'];
				DeleteStr=DeleteStr+"^"+"DELETE";
				var ret = $m({                  
					ClassName:"DHCMed.CD.CRReport",
					MethodName:"DeleteReport",
					aInput:DeleteStr,
					separete:"^"
				},false);
			
				if(parseInt(ret)<=0){
					$.messager.alert($g("����"),$g("����ʧ��!")+ret, 'error');
					return;
				}else{
					$.messager.alert($g("��ʾ"),$g("�������ϳɹ�!"), 'info');
					obj.InitRepPowerByStatus(obj.ReportID);
				}
			}
		});
	};
	// �˻�
	obj.btnReturn_click = function(r){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("���������ϱ�������"), 'info');
			return;
		}
		var ReturnStr=obj.ReportID;
		ReturnStr=ReturnStr+"^"+5
		ReturnStr=ReturnStr+"^"+session['LOGON.USERID'];
		ReturnStr=ReturnStr+"^"+session['LOGON.CTLOCID'];
		ReturnStr=ReturnStr+"^"+"RETURN";
		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"ReturnReport",
			aInput:ReturnStr,
			separete:"^",
			aReason:r
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("�˻�ʧ��!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("�˻سɹ�!"), 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	obj.btnCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("���������ϱ�������"), 'info');
			return;
		}
		var CheckStr=obj.ReportID;
		CheckStr=CheckStr+"^"+2
		CheckStr=CheckStr+"^"+session['LOGON.USERID'];
		CheckStr=CheckStr+"^"+session['LOGON.CTLOCID'];

		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"CheckReport",
			aInput:CheckStr,
			separete:"^"
		},false);
				
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("�������ʧ��!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("������˳ɹ�!"), 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	};
	//ȡ�����
	obj.btnCanCheck_click = function(){
		if(obj.ReportID==""){
			$.messager.alert($g("����"),$g("���������ϱ�������"), 'info');
			return;
		}
		var CanCheckStr=obj.ReportID;
		CanCheckStr=CanCheckStr+"^"+1
		CanCheckStr=CanCheckStr+"^"+session['LOGON.USERID'];
		CanCheckStr=CanCheckStr+"^"+session['LOGON.CTLOCID'];
		CanCheckStr=CanCheckStr+"^"+"CANCHECK";

		var ret = $m({                  
			ClassName:"DHCMed.CD.CRReport",
			MethodName:"CanCheckReport",
			aInput:CanCheckStr,
			separete:"^"
		},false);
				
		if(parseInt(ret)<=0){
			$.messager.alert($g("����"),$g("ȡ�����ʧ��!")+ret, 'error');
			return;
		}else{
			$.messager.alert($g("��ʾ"),$g("ȡ����˳ɹ�!"), 'info');
			obj.InitRepPowerByStatus(obj.ReportID);
		}
	}
	
	
	obj.btnPrint_click = function(){
		if (obj.ReportID==""){
			$.messager.alert($g("��ʾ"),$g("��ӡʧ�ܣ��Ҳ�����ݱ���") , 'info');
			return
		}
		var LODOP=getLodop();
		LODOP.PRINT_INIT("PrintCDGXYReport");		//��ӡ���������
		LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
		LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//ÿҳ����ӡҳ��
		LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//�˹�˫���ӡ(��ӡ����֧��˫���ӡʱ��1Ϊ˫���ӡ��0Ϊ�����ӡ)
		LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//�Զ�˫���ӡ(��ӡ��֧��˫���ӡʱ��1Ϊ˫���ӡ��0Ϊ�����ӡ)
		LodopPrintURL(LODOP,"dhcma.cd.lodopgxy.csp?ReportID="+obj.ReportID);
		LODOP.PRINT();			//ֱ�Ӵ�ӡ
	};
	obj.btnCancle_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //�ر�
		//websys_showModal֧�ֶ�㵯����ʹ��websys_showModel('close')�ر����һ�ν��� ,websys_showModel('options') �õ����һ�ν��������
		websys_showModal('close');
	};
	
	//���淶
	obj.CheckReport = function(){
		var errStr = "";

		if ($.trim($('#txtPatName').val()) == "") {
			errStr += $g("��������������Ϊ��!<br>");		//��������
		}
		if ($.trim($('#txtSex').val()) == "") {
			errStr += $g("�Ա�����Ϊ��!<br>");		//�Ա�
		}
		if ($.trim($('#txtAge').val()) == "") {
			errStr += $g("���䲻����Ϊ��!<br>");		//����
		}
		if ($.trim($('#cboNation').combobox('getValue')) == "") { //����
			errStr += $g("��ѡ������!<br>");		
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			errStr += $g("���֤�Ų�����Ϊ��!<br>");		//���֤��
		}
		// ���֤��ʽ��֤	
		if ($.trim($('#txtPatCardNo').val()) != ""){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test($.trim($('#txtPatCardNo').val())))) {
				errStr += $g('��������֤�Ÿ�ʽ�����Ϲ涨������������!<br>');
			}
		}
		
		if ($.trim($('#cboCurrProvince').combobox('getValue')) == "") { //ʡ
			errStr += $g("��ѡ���ס��ַʡ!<br>");		
		}
		if ($.trim($('#cboCurrCity').combobox('getValue')) == "") {
			errStr += $g("��ѡ���ס��ַ��!<br>");		//��
		}
		if ($.trim($('#cboCurrCounty').combobox('getValue')) == "") {
			errStr += $g("��ѡ���ס��ַ��!<br>");		//��
		}
		if ($.trim($('#cboCurrVillage').combobox('getValue')) == "") {
			errStr += $g("��ѡ���ס��ַ��/��!<br>");		//��/��
		}
		if ($.trim($('#txtCurrRoad').val()) == "") {
			errStr += $g("��ס��ַ�岻����Ϊ��!<br>");		//��
		}
		if ($.trim($('#txtCurrAddress').val()) == "") {
			errStr += $g("��ס��ַ��ϸ��ַ������Ϊ��!<br>");		//��ϸ��ַ		
		} 
		if ($.trim(Common_CheckboxValue('chkSymptoms')) == "") {
			errStr += $g("��ѡ��֢״!<br>");		//��ϸ��ַ		
		}
		
		if ($.trim($('#txtOrgan').val()) == "") {
			errStr += $g("ȷ��ҽԺ������Ϊ��!<br>");		//ȷ��ҽԺ
		} 
		
	
		if(errStr != "") {
			$.messager.alert($g("��ʾ"), errStr, 'info');
			return false;
		}
		return true;
	}

}


