function InitReportWinEvent(obj) {		
	/* ��ȡ����ϱ��β���������Ϣ */
	obj.ReportManage = function (aID) {   //�����淵�ض���ķ��������⣬ʹ�÷����ַ�������	
		var objRep = $m({                  
			ClassName:"DHCMed.EPDService.HCVReportSrv",
			MethodName:"GetRepByID",
			aID:aID
		},false);
		return objRep;
	}
	
	// ��ǰ�ϱ��û�
	obj.LoadUser  = function (aUserID) { 
		var UserInfo = $m({                  
			ClassName:"DHCMed.Base.SSUser",
			MethodName:"GetStringById",
			id:aUserID,
			separete:''
		},false);
		return UserInfo;
	} 
	
	//�ж�״̬�ֵ��Ƿ������Ŀ
	obj.IsExistDic = function (aType,aCode) {   
		var objDicManage = $cm({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetObjByCode",
			argType:aType,
			argCode:aCode,
			argIsActive:1
		},false);
		if ($.isEmptyObject(objDicManage)) return false;   //�ж϶����Ƿ�Ϊ��
		
		return objDicManage;
	}

	//�����Ϣ
	obj.LoadUserInfo = function() {
		obj.objCurrUser = obj.LoadUser(session['LOGON.USERID']);
		arrUserInfo = obj.objCurrUser.split('^');
		$('#txtRepUser').val(arrUserInfo[2]);		//��ǰ���
		var thisNowDate = Common_GetDate(new Date());
		$('#dtRepDate').datebox('setValue',thisNowDate);  //Ĭ���������Ϊ��ǰ����
	}

	//�������ز�
	function loadingWindow() {
	    var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#HCVReport"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html($g("���ݼ�����,���Ժ�...")).appendTo("#HCVReport").css({ display: "block", left: left, top: top }); 
	}
	 
	//ȡ�����ز�  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}

	obj.LoadEvent = function(){
		loadingWindow();
		window.setTimeout(function () {
			obj.LoadPatInfo();
			obj.LoadDicInfo(); 
			obj.LoadUserInfo();		
			obj.refreshFormInfo(obj.ReportID);
			disLoadWindow();
		}, 50); 
		obj.RelationToEvents (); // ��ť�����¼�
		
		//׷������Ԫ�أ�����ǿ�Ʊ��汣��ʧ��ʱ�������
		if (top.$("#flag").length>0){
			//�Ѿ���������Ԫ�أ���ʼ��ֵΪ0		
			top.$("#flag").val(0);
		}else {		
			top.$("body").append("<input type='hidden' id='flag' value='0'>");
		}
	}
		
	// ****************************** ������ refresh
    obj.refreshFormInfo = function(reportID) {
    	obj.showReportData(reportID);    // RepInfo
        
		var check = false, statusCode = ""; // 1���� 2���� 5�˻� 6�ݸ� 7����
		
		if (reportID) {	
        	statusCode = obj.SatusCode;
		}
        if (statusCode==2 || statusCode==7 ) { check = true; }  // �������ϲ������޸�
        obj.setFormDisabled(check);
        obj.showReportButton(statusCode);
    }
    
    obj.showReportData = function(reportID) {
	    $('#txtOrganName').val(HospDesc);
	    $('#txtOrganID').val(ServerObj.OrganID);
        var arrCurrRep = '';
        if (reportID!="") { 
            objCurrReport = obj.ReportManage(reportID); 
            arrCurrRep=objCurrReport.split("^");
        }      	
		var OrganName= "",OrganID= "",SerialNum= "",EducationID= "",EducationDesc= "",MarrigeID= "",MarrigeDesc= "",PerMonIncomeID= "",PerMonIncomeDesc="";
		var MedInsTypeID="",MedInsTypeDesc= "",MedInsTypeExt= "",TestPosDate="",TestMethodID="",TestMethodDesc="",TestReasonExt="",RecheckDate="";
		var RechMethodID= "",RechMethodDesc= "",ResultsID= "",ResultsDesc= "",NucleinRetExt= "",BloodDate= "",EntryDate= "",ReferDate= "",ReferResultID= "",ReferResultDesc= "";
		var CardNo= "",TreatmentDate= "",UntreatedExt= "",RepUser= "",RepDate= "",Resume="";

        if (arrCurrRep) {   // ������Ϣ 
			StatusID		= arrCurrRep[3].split(CHR_2)[0];
			SatusCode		= arrCurrRep[3].split(CHR_2)[1]; 
			obj.SatusCode   = SatusCode;
			StatusDesc		= arrCurrRep[3].split(CHR_2)[2];  
			OrganName		= arrCurrRep[4]; 			
			OrganID         = arrCurrRep[5];
			SerialNum       = arrCurrRep[6];
			EducationID     = arrCurrRep[7].split(CHR_2)[0];
			EducationDesc   = arrCurrRep[7].split(CHR_2)[2];
			MarrigeID       = arrCurrRep[8].split(CHR_2)[0];       
			MarrigeDesc		= arrCurrRep[8].split(CHR_2)[2]; 
			PerMonIncomeID  = arrCurrRep[9].split(CHR_2)[0]; 
			PerMonIncomeDesc= arrCurrRep[9].split(CHR_2)[2]; 
			MedInsTypeID   	= arrCurrRep[10].split(CHR_2)[0];    
			MedInsTypeDesc  = arrCurrRep[10].split(CHR_2)[2];                            
			MedInsTypeExt	= arrCurrRep[11];     
			TestPosDate     = arrCurrRep[12];                    
			TestMethodID	= arrCurrRep[13].split(CHR_2)[0];  
			TestMethodDesc  = arrCurrRep[13].split(CHR_2)[2];                           
			TestReasonID    = arrCurrRep[14].split(CHR_2)[0];
			TestReasonCode	= arrCurrRep[14].split(CHR_2)[1];
			TestReasonExt   = arrCurrRep[15];     
			RecheckDate     = arrCurrRep[16];  
			IsRecheck       = arrCurrRep[17].split(CHR_2)[0];  			
			RechMethodID    = arrCurrRep[18].split(CHR_2)[0];
			RechMethodDesc  = arrCurrRep[18].split(CHR_2)[2];
			ResultsID   	= arrCurrRep[19].split(CHR_2)[0];
			ResultsDesc     = arrCurrRep[19].split(CHR_2)[2];
			NucleinRet      = arrCurrRep[20].split(CHR_2)[0];  
			NucleinRetExt	= arrCurrRep[21];
			BloodDate		= arrCurrRep[22];      	
			IsCheck         = arrCurrRep[23].split(CHR_2)[0];      
			EntryDate		= arrCurrRep[24];                         
			CardNo          = arrCurrRep[25];        
			ReferDate       = arrCurrRep[26];
			IsRefer  		= arrCurrRep[27].split(CHR_2)[0];                          
			ReferResultID   = arrCurrRep[28].split(CHR_2)[0]; 
			ReferResultDesc = arrCurrRep[28].split(CHR_2)[2]; 
			TreatmentDate	= arrCurrRep[29];                       
			UntreatedDR     = arrCurrRep[30].split(CHR_2)[0];  
			UntreatedExt	= arrCurrRep[31];                    
			RepUser         = arrCurrRep[32];
			RepDate         = arrCurrRep[33];
			Resume          = arrCurrRep[34];     	
			if (TestReasonID) {
				//$HUI.radio("#RadTestReason-"+TestReasonID).setValue(true); // �״ο�������ʵ���Ҽ����Ҫԭ��
				$('#RadTestReason'+TestReasonID).radio('setValue',true);                
			}
			if (IsRecheck) {
				$HUI.radio("#IsRecheck-"+IsRecheck).setValue(true); // ���帴���Ƿ���
			}
			if (NucleinRet) {
				$HUI.radio("#RadNucleinRet-"+NucleinRet).setValue(true); // ���κ�������
			}
			if (IsCheck) {
				$HUI.radio("#IsCheck-"+IsCheck).setValue(true); // �Ƿ��Ѫ
			}
			if (IsRefer) {
				$HUI.radio("#IsRefer-"+IsRefer).setValue(true); // �Ƿ�ת��
			}
			if (UntreatedDR) {
				$('#RadUntreated'+UntreatedDR).radio('setValue',true);     // δ����ԭ��           
			}	
			$('#txtRepUser').val(RepUser);
	    	$('#dtRepDate').datebox('setValue',RepDate);	    
	      	$('#txtOrganName').val(OrganName);
	    	$('#txtOrganID').val(OrganID);
        } 
       		
	    $('#txtSerialNum').val(SerialNum);
	    $('#cboEducation').combobox('setValue',EducationID);
	    $('#cboEducation').combobox('setText',EducationDesc);
	    $('#cboMarrige').combobox('setValue',MarrigeID);
	    $('#cboMarrige').combobox('setText',MarrigeDesc);
	    $('#cboPerMonIncome').combobox('setValue',PerMonIncomeID);
	    $('#cboPerMonIncome').combobox('setText',PerMonIncomeDesc);
	    $('#cboMedInsType').combobox('setValue',MedInsTypeID);
	    $('#cboMedInsType').combobox('setText',MedInsTypeDesc);
	    $('#txtMedInsType').val(MedInsTypeExt);	    
	    $('#dtTestPosDate').datebox('setValue',TestPosDate);
	    $('#cboTestMethod').combobox('setValue',TestMethodID);
	    $('#cboTestMethod').combobox('setText',TestMethodDesc);	    
	    $('#txtTestReason').val(TestReasonExt);
	    $('#dtRecheckDate').datebox('setValue',RecheckDate);
		$('#cboRechMethod').combobox('setValue',RechMethodID);
	    $('#cboRechMethod').combobox('setText',RechMethodDesc);    
		$('#cboResults').combobox('setValue',ResultsID);
	    $('#cboResults').combobox('setText',ResultsDesc);    	    
	    $('#txtNucleinRet').val(NucleinRetExt);
	    $('#dtBloodDate').datebox('setValue',BloodDate);
	    $('#dtEntryDate').datebox('setValue',EntryDate);
	    $('#txtCardNo').val(CardNo);
	    $('#dtReferDate').datebox('setValue',ReferDate);
	    $('#cboReferResult').combobox('setValue',ReferResultID);
	    $('#cboReferResult').combobox('setText',ReferResultDesc);
	    $('#dtTreatmentDate').datebox('setValue',TreatmentDate);
	    $('#txtUntreated').val(UntreatedExt);
	    $('#txtResume').val(Resume);
	    
    }
    
	//��ʾ���水ť
	obj.showReportButton = function(statusCode) {
		$('#btnSaveTmp').hide();	// �ݸ�
		$('#btnSave').hide();		// ����
		$('#btnCheck').hide();		// ���
		$('#btnUpdoCheck').hide();	// ȡ�����	
		$('#btnReturn').hide();		// �˻�
		$('#btnDelete').hide();	    // ����	
		$('#btnPrintLodop').hide();	// ��ӡ		
		$('#btnClose').show();	    // �ر�
		// 1���� 2���� 5�˻� 4�ݸ� 7����
		if (LocFlag==0) {	// ҽ��վ
			switch (statusCode) {
				case "" : // �ޱ���
					$('#btnSaveTmp').show();    // ����ݸ尴ť
					$('#btnSaveTmp').linkbutton({text:$g('�ݸ�')});
					$('#btnSave').show();		// �ϱ���ť
					$('#btnSave').linkbutton({text:$g('����')});
					break;
				case "1" : // ����
					$('#btnSave').show();	
					$('#btnSave').linkbutton({text:$g('�޸ı���')});
					$('#btnDelete').show();	    // ����
					$('#btnPrintLodop').show();	 
					break;
				case "2" : // ����
					$('#btnPrintLodop').show();	    // ��ӡ��ť
					break;
				case "5" : // �˻�
					$('#btnSave').show();		// �ϱ���ť
					$('#btnSave').linkbutton({text:$g('�޸ı���')});
					$('#btnDelete').show();		// ���ϰ�ť
					break;					
				case "6" : // �ݸ�
					$('#btnSaveTmp').show();    // ����ݸ尴ť
					$('#btnSaveTmp').linkbutton({text:$g('�ݸ�')});
					$('#btnSave').show();		// �ϱ���ť
					$('#btnSave').linkbutton({text:$g('����')});
					$('#btnDelete').show();		// ���ϰ�ť
					break;
				case "7" : // ����
					break;
			}
		} else if (LocFlag==1) {    // �������
			switch (statusCode) {
				case "" : // �ޱ���
					$('#btnSaveTmp').show();    // ����ݸ尴ť
					$('#btnSaveTmp').linkbutton({text:$g('�ݸ�')});
					$('#btnSave').show();		 // �ϱ���ť
					$('#btnSave').linkbutton({text:$g('����')});
					break;
				case "1" : // ����
					$('#btnSave').show();		// �ϱ���ť
					$('#btnSave').linkbutton({text:$g('�޸ı���')});
					$('#btnCheck').show();		// ��˰�ť
					$('#btnReturn').show();		// �˻ذ�ť
					$('#btnDelete').show();		// ���ϰ�ť
					$('#btnPrintLodop').show();	    // ��ӡ��ť
					break;
				case "2" : // ����
					$('#btnUpdoCheck').show();	// ȡ����˰�ť
					$('#btnPrintLodop').show();	    // ��ӡ��ť
					break;
				case "5" : // �˻�
					$('#btnSave').show();		// �ϱ���ť
					$('#btnSave').linkbutton({text:$g('�޸ı���')});
					$('#btnDelete').show();		// ���ϰ�ť
					break;
				case "6" : // �ݸ�
					$('#btnSaveTmp').show();   // ����ݸ尴ť
					$('#btnSaveTmp').linkbutton({text:$g('�ݸ�')});
					$('#btnSave').show();	   // �ϱ���ť			
					$('#btnSave').linkbutton({text:$g('����')});
					$('#btnReturn').show();		// �˻ذ�ť
					$('#btnDelete').show();		// ���ϰ�ť
					break;
				case "7" : // ����
					break;            
        	}
		}
	}
	
	//���治�ɱ༭
	obj.setFormDisabled = function(check) {
        if (check) {
            $('#txtOrganName').attr('disabled','disabled');
            $('#txtOrganID').attr('disabled','disabled');
            $('#txtPatName').attr('disabled','disabled');
            $('#txtPatSex').attr('disabled','disabled');           
            $('#dtBirthday').datebox('disable');
            $('#txtAge').attr('disabled','disabled');
            $('#cboEducation').combobox('disable');
            $('#cboMarrige').combobox('disable');
            $('#cboPerMonIncome').combobox('disable');
            $('#cboMedInsType').combobox('disable');
            $('#txtMedInsType').attr('disabled','disabled');           
            $('#dtTestPosDate').datebox('disable');           
            $('#cboTestMethod').combobox('disable');           
            $('#RadTestReason').radio('disable');
            $('#IsRecheck-1').radio('disable');
            $('#IsRecheck-0').radio('disable');
            $('#dtRecheckDate').datebox('disable');
            $('#cboRechMethod').combobox('disable');
            $('#cboResults').combobox('disable');
            $('#RadNucleinRet-1').radio('disable');
            $('#RadNucleinRet-0').radio('disable');          
            $('#txtNucleinRet').attr('disabled','disabled');   
            $('#IsCheck-1').radio('disable');
            $('#IsCheck-0').radio('disable');                      
            $('#dtBloodDate').datebox('disable');
            $('#dtEntryDate').datebox('disable');           
            $('#txtCardNo').attr('disabled','disabled');
            $('#IsRefer-1').radio('disable');
            $('#IsRefer-0').radio('disable');                      
            $('#dtReferDate').datebox('disable');
            $('#cboReferResult').combobox('disable');
            $('#dtTreatmentDate').datebox('disable');
            $('#RadUntreated').radio('disable');          
            $('#txtUntreated').attr('disabled','disabled');
            $('#dtRepDate').datebox('disable');        
            $('#txtRepUser').attr('disabled','disabled');
            $('#txtResume').attr('disabled','disabled');
            
        } 
    }
	/* ���ô����� - ����ȫ����������¼� */
	obj.RelationToEvents = function() {	
		//���汨��ݸ�
		$('#btnSaveTmp').on("click", function(){
			obj.btnSaveTmp_click(); 
		});
		//�ϱ�����
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		//��˱���
		$('#btnCheck').on("click", function(){
			obj.btnCheck_click(); 
		});
		//ȡ����˱���
		$('#btnUpdoCheck').on("click", function(){
            $.messager.confirm($g("��ʾ"), $g("��ȷ���Ƿ�ȡ�����?"), function (r) {
                if (r){
                    obj.btnCancheck_click(); 
                }
            });
		});
		//�˻ر���
        $('#btnReturn').on("click", function(){
            $.messager.prompt($g("�˻�"), $g("�������˻�ԭ��!"), function (r) {
                if (r){
                    obj.btnReturn_click(r); 
                }
            });
        });		
		//ɾ�����ϱ���
		$('#btnDelete').on("click", function(){
			$.messager.confirm($g("��ʾ"), $g("��ȷ���Ƿ����ϣ�"), function (r) {
				if (r){
					obj.btnDelete_click(); 
				}
			});
		});
		//�رձ������
		$('#btnClose').on("click", function(){
			obj.btnClose_click(); 
		});	
		
		// Lodop��ӡ
		$('#btnPrintLodop').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintDHCMAHCVReport");		//��ӡ���������
			LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//ÿҳ����ӡҳ��
			LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//�˹�˫���ӡ(��ӡ����֧��˫���ӡʱ��1Ϊ˫���ӡ��0Ϊ�����ӡ)
			LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//�Զ�˫���ӡ(��ӡ��֧��˫���ӡʱ��1Ϊ˫���ӡ��0Ϊ�����ӡ)
			LodopPrintURL(LODOP,"dhcma.epd.hcvlodopprint.csp?ReportID="+obj.ReportID);
			//LODOP.PREVIEW();		//Ԥ����ӡ
			LODOP.PRINT();			//ֱ�Ӵ�ӡ
		});
	
	}
	
	//����ݸ尴ť
	obj.btnSaveTmp_click = function() {
		obj.saveReportInfo(6, "^");		
	}
	//�ϱ���ť
	obj.btnSave_click = function() {
		obj.saveReportInfo(1, "^");		
	}
	 // ���
	obj.btnCheck_click = function() {   
        obj.saveReportStatus(2, "^", "");
    }
    // ȡ�����
    obj.btnCancheck_click = function() {    
        obj.saveReportStatus(1, "^", "");
    }   
	// �˻�
    obj.btnReturn_click = function(r) {  
        obj.saveReportStatus(5, "^", r);
    }
	// ���ϰ�ť
	obj.btnDelete_click = function() {  
        obj.saveReportStatus(7, "^", "");
    }
	//�رհ�ť
	obj.btnClose_click = function() {
		websys_showModal('close');
	}
	
	//���汨��״̬
    obj.saveReportStatus = function(statusCode, separate, reason) {
        var statusID = "";
        obj.objCurrUser = obj.LoadUser(session['LOGON.USERID']);
		arrUserInfo = obj.objCurrUser.split('^');
		checkUser = arrUserInfo[2];		//��ǰ���

        var objStatus = obj.IsExistDic("EpidemicReportStatus", statusCode);
        if (objStatus) { statusID = objStatus.ID; }
        if (obj.ReportID=="" || statusID=="") {
            $.messager.alert($g("��ʾ"), $g("����ʧ��!"), 'info');
            return;
        }
        var checkDate = "";
        var inputStr = obj.ReportID;
        inputStr = inputStr + separate + statusID;
        inputStr = inputStr + separate + checkUser;
        inputStr = inputStr + separate + checkDate;
        inputStr = inputStr + separate + reason;
        
        var ret = $m({ 
            ClassName:"DHCMed.EPD.HCVReport",
            MethodName:"UpdateStatus",
            aInputStr:inputStr, 
            aSeparate:separate
        },false);
        if (ret>0) {
            $.messager.alert($g("��ʾ"), $g("�����ɹ�!"), 'info');
            obj.refreshFormInfo(ret);
        } else {
            $.messager.alert($g("��ʾ"), $g("����ʧ��!"), 'info');
        }
    }

	// ****************************** ������ ���汨����Ϣ 
    obj.saveReportInfo = function(statusCode, separate) {
        var errorStr = "";
        var inputStr = obj.saveReportStr(statusCode, separate);
        if (inputStr=="") { return; } 
        var retRep = $m({ 
            ClassName:"DHCMed.EPD.HCVReport",
            MethodName:"Update",
            aInputStr:inputStr, 
            aSeparate:separate
        },false);
        
        //����ֵ�Ǳ���ID��������0���ɹ���
        if (retRep>0) {
			obj.ReportID = retRep ;
            errorStr = $g("����ɹ�!");
            obj.refreshFormInfo(retRep);
            //�½����汣��ɹ��󲻹رմ���ֱ��ˢ��ʱ��������ʾ�հ����⴦��
            if (typeof(history.pushState) === 'function') {
                var Url=window.location.href;
        		Url=rewriteUrl(Url, { ReportID:retRep });
				history.pushState("", "", Url);
            }
            //�޸�׷������Ԫ�أ�����ǿ�Ʊ��汣��ʧ��ʱ�������
			top.$("#flag").val(1);
        } else {
            errorStr = errorStr + $g("������Ϣ����ʧ��!");
        }
        $.messager.alert($g("��ʾ"), errorStr, 'info');
    }
	// ****************************** ������ ���汨����Ϣ����

	// ****************************** ������ ���汨���ַ���
	obj.saveReportStr = function(statusCode, separate) {
        var StatusID = "";
        var objStatus = obj.IsExistDic("EpidemicReportStatus", statusCode);
        if (objStatus) { StatusID = objStatus.ID; }
        
        var IsRecheck = Common_RadioValue("IsRecheck");			// δ������
        var NucleinRet 	= Common_RadioValue("RadNucleinRet");	// ���κ�������
        var IsCheck 	= Common_RadioValue("IsCheck");			// δ��Ѫ
        var IsRefer 	= Common_RadioValue("IsRefer");			// δת��  
		
        var OrganName        = $.trim($('#txtOrganName').val());
        var OrganID          = $.trim($('#txtOrganID').val());
       	var SerialNum 		 = $.trim($('#txtSerialNum').val());
        var Education        = $.trim($('#cboEducation').combobox('getValue'));
		var EducationDesc    = $.trim($('#cboEducation').combobox('getText'));
		var Marrige          = $.trim($('#cboMarrige').combobox('getValue'));
		var MarrigeDesc      = $.trim($('#cboMarrige').combobox('getText'));
		var PerMonIncome     = $.trim($('#cboPerMonIncome').combobox('getValue'));
		var PerMonIncomeeDesc= $.trim($('#cboPerMonIncome').combobox('getText'));
		var MedInsType       = $.trim($('#cboMedInsType').combobox('getValue'));
		var MedInsTypeDesc   = $.trim($('#cboMedInsType').combobox('getText'));
		var MedInsTypeExt    = $.trim($('#txtMedInsType').val());
		var TestPosDate      = $.trim($('#dtTestPosDate').datebox('getValue'));
		var TestMethod       = $.trim($('#cboTestMethod').combobox('getValue'));
		var TestMethodDesc   = $.trim($('#cboTestMethod').combobox('getText'));
		var TestReasonDR     = Common_RadioValue('RadTestReason');               // �״μ��ԭ��ID
		var TestReasonDesc   = Common_RadioLabel('RadTestReason');               // �״μ��ԭ��Desc
		var TestReasonExt    = $.trim($('#txtTestReason').val());
		var RecheckDate      = $.trim($('#dtRecheckDate').datebox('getValue'));
		var RechMethod       = $.trim($('#cboRechMethod').combobox('getValue'));
		var RechMethodDesc   = $.trim($('#cboRechMethod').combobox('getText'));
		var Results          = $.trim($('#cboResults').combobox('getValue'));
		var ResultsDesc      = $.trim($('#cboResults').combobox('getText'));
		var NucleinRetExt    = $.trim($('#txtNucleinRet').val());
		var BloodDate        = $.trim($('#dtBloodDate').datebox('getValue'));
		var EntryDate        = $.trim($('#dtEntryDate').datebox('getValue'));
		var CardNo           = $.trim($('#txtCardNo').val());
		var ReferDate        = $.trim($('#dtReferDate').datebox('getValue'));
		var ReferResult      = $.trim($('#cboReferResult').combobox('getValue'));
		var ReferResultDesc  = $.trim($('#cboReferResult').combobox('getText'));
		var TreatmentDate    = $.trim($('#dtTreatmentDate').datebox('getValue'));
		var UntreatedDR      = Common_RadioValue('RadUntreated');               // �״μ��ԭ��ID
		var UntreatedDesc    = Common_RadioLabel('RadUntreated');               // �״μ��ԭ��Desc
		var UntreatedExt     = $.trim($('#txtUntreated').val());
        var RepUser          = $.trim($('#txtRepUser').val());
        var RepDate          = $.trim($('#dtRepDate').datebox('getValue'));
     	var Resume       	 = $.trim($('#txtResume').val());
     
        if ((statusCode==1)||(statusCode==2)) {
            var errorStr = "";
            if (Education=="") { errorStr = errorStr + $g("����д�Ļ��̶�!")+"<br>"; }
			if (Marrige=="") { errorStr = errorStr + $g("����д����״��!")+"<br>"; }
			if (PerMonIncome=="") { errorStr = errorStr + $g("����д����������!")+"<br>"; }
			if (MedInsType=="") { errorStr = errorStr + $g("����дҽ������!")+"<br>"; }
			if ((MedInsTypeDesc=="����")&&(MedInsTypeExt=="")) { errorStr = errorStr + $g("����д����ҽ������!")+"<br>"; }
			if (TestPosDate=="") { errorStr = errorStr + $g("����д�״ο���������!")+"<br>"; }
			if (TestMethod=="") { errorStr = errorStr + $g("����д�״ο����ⷽ��!")+"<br>"; }
			if (TestReasonDR=="") { errorStr = errorStr + $g("����д�״ο�������ʵ���Ҽ����Ҫԭ��!")+"<br>"; }	
			if ((TestReasonDesc=="����")&&(TestReasonExt=="")) { errorStr = errorStr + $g("����д���������Ҫԭ��!")+"<br>"; }
			if (IsRecheck=="") { errorStr = errorStr + $g("����д�Ƿ��帴��!")+"<br>"; }
			if ((RecheckDate=="")&&(IsRecheck==1)) { errorStr = errorStr + $g("����д���帴������!")+"<br>"; }			
			if (NucleinRet=="") { errorStr = errorStr + $g("����д���κ�����!")+"<br>"; }						
			if ((NucleinRet==1)&&(NucleinRetExt=="")) { errorStr = errorStr + $g("���κ�����Ϊ���ԣ�����д��������!")+"<br>"; }	
			if (IsCheck=="") { errorStr = errorStr + $g("����д�Ƿ��Ѫ!")+"<br>"; }					
			if ((BloodDate=="")&&(IsCheck=="1")) { errorStr = errorStr + $g("����д��Ѫ����!")+"<br>"; }
			if (EntryDate=="") { errorStr = errorStr + $g("����д����ֱ��¼������!")+"<br>"; }
			if (IsRefer=="") { errorStr = errorStr + $g("����д�Ƿ�ת��!")+"<br>"; }
			if ((ReferDate=="")&&(IsRefer=="1")) { errorStr = errorStr + $g("����дת����������!")+"<br>"; }
			if ((ReferResultDesc=="��ҽԺ��������������")&&(TreatmentDate=="")) { errorStr = errorStr + $g("����д���ƿ�ʼ����!")+"<br>"; }	      				
			if ((ReferResultDesc=="��ҽԺδ��������������")&&(UntreatedDR=="")) { errorStr = errorStr + $g("����дδ����ԭ��!")+"<br>"; }	      	
			if ((UntreatedDesc=="����")&&(UntreatedExt=="")) { errorStr = errorStr + $g("����д����δ����ԭ��!")+"<br>"; }
			
            var thisNowDate = Common_GetDate(new Date());
      	  	if (Common_CompareDate(RepDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ��������ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(BloodDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ����Ѫ���ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(TestPosDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ���״ο��������ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(RecheckDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ�����帴�����ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(EntryDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ������ֱ��¼�����ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(ReferDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ��ת�����ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }
            
            if (Common_CompareDate(TreatmentDate,thisNowDate)>0) {
                $.messager.alert($g("��ʾ"),$g("��Ǹ�����ƿ�ʼ���ڲ��ܴ��ڵ�ǰ����!")+"<br>", 'info');
                return false;
            }

            if (errorStr!="") {
                $.messager.alert($g("��ʾ"), errorStr, 'info');
                return "";
            }
        }
       
        var tmpStr = obj.ReportID;  // inputStr
		tmpStr = tmpStr + separate + EpisodeID;
		tmpStr = tmpStr + separate + PatientID;
		tmpStr = tmpStr + separate + StatusID;  //4
		tmpStr = tmpStr + separate + OrganName;
		tmpStr = tmpStr + separate + OrganID;
		tmpStr = tmpStr + separate + SerialNum;
		tmpStr = tmpStr + separate + Education;
		tmpStr = tmpStr + separate + Marrige;
		tmpStr = tmpStr + separate + PerMonIncome;
		tmpStr = tmpStr + separate + MedInsType;
		tmpStr = tmpStr + separate + MedInsTypeExt;  //12
		tmpStr = tmpStr + separate + TestPosDate;
		tmpStr = tmpStr + separate + TestMethod;
		tmpStr = tmpStr + separate + TestReasonDR;
		tmpStr = tmpStr + separate + TestReasonExt;
		tmpStr = tmpStr + separate + RecheckDate; 	//17
		tmpStr = tmpStr + separate + IsRecheck;
		tmpStr = tmpStr + separate + RechMethod;
		tmpStr = tmpStr + separate + Results;
		tmpStr = tmpStr + separate + NucleinRet;
		tmpStr = tmpStr + separate + NucleinRetExt;	 //22
		tmpStr = tmpStr + separate + BloodDate;
		tmpStr = tmpStr + separate + IsCheck;
		tmpStr = tmpStr + separate + EntryDate;
		tmpStr = tmpStr + separate + CardNo;
		tmpStr = tmpStr + separate + IsRefer;	  //27
		tmpStr = tmpStr + separate + ReferResult;
		tmpStr = tmpStr + separate + TreatmentDate;
		tmpStr = tmpStr + separate + UntreatedDR;
		tmpStr = tmpStr + separate + UntreatedExt;	 //31
		tmpStr = tmpStr + separate + RepUser;
		tmpStr = tmpStr + separate + RepDate;
		tmpStr = tmpStr + separate + Resume;
		tmpStr = tmpStr + separate + ReferDate;	  //35
		tmpStr = tmpStr + separate + '';		 //36�����
		tmpStr = tmpStr + separate + '';		//37�������
     
        return tmpStr;
    }
    // ****************************** ������ ���汨���ַ�������

}