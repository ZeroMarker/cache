function InitReportWinEvent(obj) {		
	/* 获取新诊断丙肝病例报告信息 */
	obj.ReportManage = function (aID) {   //本报告返回对象的方法有问题，使用返回字符串方法	
		var objRep = $m({                  
			ClassName:"DHCMed.EPDService.HCVReportSrv",
			MethodName:"GetRepByID",
			aID:aID
		},false);
		return objRep;
	}
	
	// 当前上报用户
	obj.LoadUser  = function (aUserID) { 
		var UserInfo = $m({                  
			ClassName:"DHCMed.Base.SSUser",
			MethodName:"GetStringById",
			id:aUserID,
			separete:''
		},false);
		return UserInfo;
	} 
	
	//判断状态字典是否存在项目
	obj.IsExistDic = function (aType,aCode) {   
		var objDicManage = $cm({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetObjByCode",
			argType:aType,
			argCode:aCode,
			argIsActive:1
		},false);
		if ($.isEmptyObject(objDicManage)) return false;   //判断对象是否为空
		
		return objDicManage;
	}

	//填报人信息
	obj.LoadUserInfo = function() {
		obj.objCurrUser = obj.LoadUser(session['LOGON.USERID']);
		arrUserInfo = obj.objCurrUser.split('^');
		$('#txtRepUser').val(arrUserInfo[2]);		//当前填报人
		var thisNowDate = Common_GetDate(new Date());
		$('#dtRepDate').datebox('setValue',thisNowDate);  //默认填表日期为当前日期
	}

	//弹出加载层
	function loadingWindow() {
	    var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#HCVReport"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html($g("数据加载中,请稍候...")).appendTo("#HCVReport").css({ display: "block", left: left, top: top }); 
	}
	 
	//取消加载层  
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
		obj.RelationToEvents (); // 按钮监听事件
		
		//追加隐藏元素，用于强制报告保存失败时作废诊断
		if (top.$("#flag").length>0){
			//已经存在隐藏元素，初始赋值为0		
			top.$("#flag").val(0);
		}else {		
			top.$("body").append("<input type='hidden' id='flag' value='0'>");
		}
	}
		
	// ****************************** ↓↓↓ refresh
    obj.refreshFormInfo = function(reportID) {
    	obj.showReportData(reportID);    // RepInfo
        
		var check = false, statusCode = ""; // 1待审 2已审 5退回 6草稿 7作废
		
		if (reportID) {	
        	statusCode = obj.SatusCode;
		}
        if (statusCode==2 || statusCode==7 ) { check = true; }  // 已审、作废不允许修改
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

        if (arrCurrRep) {   // 报告信息 
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
				//$HUI.radio("#RadTestReason-"+TestReasonID).setValue(true); // 首次抗体阳性实验室检测主要原因
				$('#RadTestReason'+TestReasonID).radio('setValue',true);                
			}
			if (IsRecheck) {
				$HUI.radio("#IsRecheck-"+IsRecheck).setValue(true); // 抗体复检是否检测
			}
			if (NucleinRet) {
				$HUI.radio("#RadNucleinRet-"+NucleinRet).setValue(true); // 丙肝核酸检测结果
			}
			if (IsCheck) {
				$HUI.radio("#IsCheck-"+IsCheck).setValue(true); // 是否采血
			}
			if (IsRefer) {
				$HUI.radio("#IsRefer-"+IsRefer).setValue(true); // 是否转介
			}
			if (UntreatedDR) {
				$('#RadUntreated'+UntreatedDR).radio('setValue',true);     // 未治疗原因           
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
    
	//显示报告按钮
	obj.showReportButton = function(statusCode) {
		$('#btnSaveTmp').hide();	// 草稿
		$('#btnSave').hide();		// 报卡
		$('#btnCheck').hide();		// 审核
		$('#btnUpdoCheck').hide();	// 取消审核	
		$('#btnReturn').hide();		// 退回
		$('#btnDelete').hide();	    // 作废	
		$('#btnPrintLodop').hide();	// 打印		
		$('#btnClose').show();	    // 关闭
		// 1待审 2已审 5退回 4草稿 7作废
		if (LocFlag==0) {	// 医生站
			switch (statusCode) {
				case "" : // 无报告
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('报卡')});
					break;
				case "1" : // 待审
					$('#btnSave').show();	
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnDelete').show();	    // 作废
					$('#btnPrintLodop').show();	 
					break;
				case "2" : // 已审
					$('#btnPrintLodop').show();	    // 打印按钮
					break;
				case "5" : // 退回
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnDelete').show();		// 作废按钮
					break;					
				case "6" : // 草稿
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnDelete').show();		// 作废按钮
					break;
				case "7" : // 作废
					break;
			}
		} else if (LocFlag==1) {    // 管理科室
			switch (statusCode) {
				case "" : // 无报告
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();		 // 上报按钮
					$('#btnSave').linkbutton({text:$g('报卡')});
					break;
				case "1" : // 待审
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnCheck').show();		// 审核按钮
					$('#btnReturn').show();		// 退回按钮
					$('#btnDelete').show();		// 作废按钮
					$('#btnPrintLodop').show();	    // 打印按钮
					break;
				case "2" : // 已审
					$('#btnUpdoCheck').show();	// 取消审核按钮
					$('#btnPrintLodop').show();	    // 打印按钮
					break;
				case "5" : // 退回
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnDelete').show();		// 作废按钮
					break;
				case "6" : // 草稿
					$('#btnSaveTmp').show();   // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();	   // 上报按钮			
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnReturn').show();		// 退回按钮
					$('#btnDelete').show();		// 作废按钮
					break;
				case "7" : // 作废
					break;            
        	}
		}
	}
	
	//界面不可编辑
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
	/* 公用处理函数 - 挂入全部所需监听事件 */
	obj.RelationToEvents = function() {	
		//保存报告草稿
		$('#btnSaveTmp').on("click", function(){
			obj.btnSaveTmp_click(); 
		});
		//上报报告
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		//审核报告
		$('#btnCheck').on("click", function(){
			obj.btnCheck_click(); 
		});
		//取消审核报告
		$('#btnUpdoCheck').on("click", function(){
            $.messager.confirm($g("提示"), $g("请确认是否取消审核?"), function (r) {
                if (r){
                    obj.btnCancheck_click(); 
                }
            });
		});
		//退回报告
        $('#btnReturn').on("click", function(){
            $.messager.prompt($g("退回"), $g("请输入退回原因!"), function (r) {
                if (r){
                    obj.btnReturn_click(r); 
                }
            });
        });		
		//删除作废报告
		$('#btnDelete').on("click", function(){
			$.messager.confirm($g("提示"), $g("请确认是否作废？"), function (r) {
				if (r){
					obj.btnDelete_click(); 
				}
			});
		});
		//关闭报告界面
		$('#btnClose').on("click", function(){
			obj.btnClose_click(); 
		});	
		
		// Lodop打印
		$('#btnPrintLodop').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintDHCMAHCVReport");		//打印任务的名称
			LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
			LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，1为双面打印，0为单面打印)
			LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，1为双面打印，0为单面打印)
			LodopPrintURL(LODOP,"dhcma.epd.hcvlodopprint.csp?ReportID="+obj.ReportID);
			//LODOP.PREVIEW();		//预览打印
			LODOP.PRINT();			//直接打印
		});
	
	}
	
	//保存草稿按钮
	obj.btnSaveTmp_click = function() {
		obj.saveReportInfo(6, "^");		
	}
	//上报按钮
	obj.btnSave_click = function() {
		obj.saveReportInfo(1, "^");		
	}
	 // 审核
	obj.btnCheck_click = function() {   
        obj.saveReportStatus(2, "^", "");
    }
    // 取消审核
    obj.btnCancheck_click = function() {    
        obj.saveReportStatus(1, "^", "");
    }   
	// 退回
    obj.btnReturn_click = function(r) {  
        obj.saveReportStatus(5, "^", r);
    }
	// 作废按钮
	obj.btnDelete_click = function() {  
        obj.saveReportStatus(7, "^", "");
    }
	//关闭按钮
	obj.btnClose_click = function() {
		websys_showModal('close');
	}
	
	//保存报告状态
    obj.saveReportStatus = function(statusCode, separate, reason) {
        var statusID = "";
        obj.objCurrUser = obj.LoadUser(session['LOGON.USERID']);
		arrUserInfo = obj.objCurrUser.split('^');
		checkUser = arrUserInfo[2];		//当前填报人

        var objStatus = obj.IsExistDic("EpidemicReportStatus", statusCode);
        if (objStatus) { statusID = objStatus.ID; }
        if (obj.ReportID=="" || statusID=="") {
            $.messager.alert($g("提示"), $g("操作失败!"), 'info');
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
            $.messager.alert($g("提示"), $g("操作成功!"), 'info');
            obj.refreshFormInfo(ret);
        } else {
            $.messager.alert($g("提示"), $g("操作失败!"), 'info');
        }
    }

	// ****************************** ↓↓↓ 保存报告信息 
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
        
        //返回值是报告ID，若大于0，成功！
        if (retRep>0) {
			obj.ReportID = retRep ;
            errorStr = $g("保存成功!");
            obj.refreshFormInfo(retRep);
            //新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
            if (typeof(history.pushState) === 'function') {
                var Url=window.location.href;
        		Url=rewriteUrl(Url, { ReportID:retRep });
				history.pushState("", "", Url);
            }
            //修改追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#flag").val(1);
        } else {
            errorStr = errorStr + $g("报告信息保存失败!");
        }
        $.messager.alert($g("提示"), errorStr, 'info');
    }
	// ****************************** ↑↑↑ 保存报告信息结束

	// ****************************** ↓↓↓ 保存报告字符串
	obj.saveReportStr = function(statusCode, separate) {
        var StatusID = "";
        var objStatus = obj.IsExistDic("EpidemicReportStatus", statusCode);
        if (objStatus) { StatusID = objStatus.ID; }
        
        var IsRecheck = Common_RadioValue("IsRecheck");			// 未做复检
        var NucleinRet 	= Common_RadioValue("RadNucleinRet");	// 丙肝核酸检测结果
        var IsCheck 	= Common_RadioValue("IsCheck");			// 未采血
        var IsRefer 	= Common_RadioValue("IsRefer");			// 未转介  
		
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
		var TestReasonDR     = Common_RadioValue('RadTestReason');               // 首次检测原因ID
		var TestReasonDesc   = Common_RadioLabel('RadTestReason');               // 首次检测原因Desc
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
		var UntreatedDR      = Common_RadioValue('RadUntreated');               // 首次检测原因ID
		var UntreatedDesc    = Common_RadioLabel('RadUntreated');               // 首次检测原因Desc
		var UntreatedExt     = $.trim($('#txtUntreated').val());
        var RepUser          = $.trim($('#txtRepUser').val());
        var RepDate          = $.trim($('#dtRepDate').datebox('getValue'));
     	var Resume       	 = $.trim($('#txtResume').val());
     
        if ((statusCode==1)||(statusCode==2)) {
            var errorStr = "";
            if (Education=="") { errorStr = errorStr + $g("请填写文化程度!")+"<br>"; }
			if (Marrige=="") { errorStr = errorStr + $g("请填写婚姻状况!")+"<br>"; }
			if (PerMonIncome=="") { errorStr = errorStr + $g("请填写个人月收入!")+"<br>"; }
			if (MedInsType=="") { errorStr = errorStr + $g("请填写医保类型!")+"<br>"; }
			if ((MedInsTypeDesc=="其他")&&(MedInsTypeExt=="")) { errorStr = errorStr + $g("请填写其他医保类型!")+"<br>"; }
			if (TestPosDate=="") { errorStr = errorStr + $g("请填写首次抗体检测日期!")+"<br>"; }
			if (TestMethod=="") { errorStr = errorStr + $g("请填写首次抗体检测方法!")+"<br>"; }
			if (TestReasonDR=="") { errorStr = errorStr + $g("请填写首次抗体阳性实验室检测主要原因!")+"<br>"; }	
			if ((TestReasonDesc=="其他")&&(TestReasonExt=="")) { errorStr = errorStr + $g("请填写其他检测主要原因!")+"<br>"; }
			if (IsRecheck=="") { errorStr = errorStr + $g("请填写是否抗体复检!")+"<br>"; }
			if ((RecheckDate=="")&&(IsRecheck==1)) { errorStr = errorStr + $g("请填写抗体复检日期!")+"<br>"; }			
			if (NucleinRet=="") { errorStr = errorStr + $g("请填写丙肝核酸结果!")+"<br>"; }						
			if ((NucleinRet==1)&&(NucleinRetExt=="")) { errorStr = errorStr + $g("丙肝核酸结果为阳性，请填写病毒载量!")+"<br>"; }	
			if (IsCheck=="") { errorStr = errorStr + $g("请填写是否采血!")+"<br>"; }					
			if ((BloodDate=="")&&(IsCheck=="1")) { errorStr = errorStr + $g("请填写采血日期!")+"<br>"; }
			if (EntryDate=="") { errorStr = errorStr + $g("请填写网络直报录入日期!")+"<br>"; }
			if (IsRefer=="") { errorStr = errorStr + $g("请填写是否转介!")+"<br>"; }
			if ((ReferDate=="")&&(IsRefer=="1")) { errorStr = errorStr + $g("请填写转介治疗日期!")+"<br>"; }
			if ((ReferResultDesc=="到医院启动抗病毒治疗")&&(TreatmentDate=="")) { errorStr = errorStr + $g("请填写治疗开始日期!")+"<br>"; }	      				
			if ((ReferResultDesc=="到医院未启动抗病毒治疗")&&(UntreatedDR=="")) { errorStr = errorStr + $g("请填写未治疗原因!")+"<br>"; }	      	
			if ((UntreatedDesc=="其他")&&(UntreatedExt=="")) { errorStr = errorStr + $g("请填写其他未治疗原因!")+"<br>"; }
			
            var thisNowDate = Common_GetDate(new Date());
      	  	if (Common_CompareDate(RepDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，填表日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(BloodDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，采血日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(TestPosDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，首次抗体检测日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(RecheckDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，抗体复检日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(EntryDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，网络直报录入日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }
            if (Common_CompareDate(ReferDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，转介日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }
            
            if (Common_CompareDate(TreatmentDate,thisNowDate)>0) {
                $.messager.alert($g("提示"),$g("抱歉，治疗开始日期不能大于当前日期!")+"<br>", 'info');
                return false;
            }

            if (errorStr!="") {
                $.messager.alert($g("提示"), errorStr, 'info');
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
		tmpStr = tmpStr + separate + '';		 //36审核人
		tmpStr = tmpStr + separate + '';		//37审核日期
     
        return tmpStr;
    }
    // ****************************** ↑↑↑ 保存报告字符串结束

}