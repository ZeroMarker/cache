function InitReportWinEvent(obj) {
    obj.ReportManage = function (aID) { //使用返回字符串方法  
        var objRep = $m({ 
            ClassName:"DHCMed.EPDService.NCPInvestigationSrv",
            MethodName:"GetInvDataByID",
            aReportID:aID
        },false);
        return objRep;
    }
    
    //判断状态字典是否存在项目
	obj.IsExistDic = function (aType,aCode) {   //返回为对象的方法需重新写	
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
	
    //弹出加载层
    function loadingWindow() {
    	var left = ($(window).outerWidth(true) - 190) / 2; 
        var top = ($(window).height() - 35) / 2; 
        var height = $(window).height() * 2; 
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#EPDInvReport"); 
        $("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#EPDInvReport").css({ display: "block", left: left, top: top }); 
    }  

    //取消加载层 
    function disLoadWindow() {
    	$(".datagrid-mask").remove();
    	$(".datagrid-mask-msg").remove();
    }

    obj.LoadEvent = function(){
        loadingWindow();
        window.setTimeout(function () { 
            obj.BuildSign();
            obj.LoadDicInfo(); 
            obj.showEpdData(); 
            obj.refreshFormInfo(obj.reportID);
            disLoadWindow(); 
        }, 100); 
        obj.RelationToEvents (); // 按钮监听事件
    }
    //加载传染病信息
    obj.showEpdData = function() {
	    var arrEpdData =  obj.EpidemicList.split("^");
	    $('#EpdTips').append('本调查登记表关联传染病报告:'+arrEpdData[17]+' 报告日期:'+arrEpdData[25]+' 当前报告状态:'+arrEpdData[24]);
	    $('#txtPapmiNo').val(arrEpdData[2]);
		$('#txtInPatientMrNo').val(arrEpdData[3]);		
		$('#txtPatientName').val(arrEpdData[4]);					
		$('#txtRelationName').val(arrEpdData[8]);				
		$('#txtSex').val(arrEpdData[5]);				
		$('#dtBirthday').datebox('setValue',arrEpdData[7]);					
		$('#txtAge').val(arrEpdData[6]);				
		$('#txtTel').val(arrEpdData[16]);		
		$('#txtProvince').val(arrEpdData[19]);
		$('#txtCity').val(arrEpdData[20]);
		$('#txtCounty').val(arrEpdData[21]);
		$('#txtVillage').val(arrEpdData[22]);
		$('#txtRoad').val(arrEpdData[23]);
		$('#dtSickDate').datebox('setValue',arrEpdData[11]);
		$('#dtDiagnoseDate').datebox('setValue',arrEpdData[13]);
		$('#txtDiagnose').val(arrEpdData[12]);
		$('#txtSeverity').val(arrEpdData[15]);
	
		if (!obj.reportID) {
			$('#txtIdentity').val(arrEpdData[18]);
			$('#txtRepUser').val(session['LOGON.USERNAME']);
			$('#dtRepDate').datebox('setValue', Common_GetDate(new Date()));
		}
    }

    // ****************************** ↓↓↓ refresh
    obj.refreshFormInfo = function(reportID) {
        obj.reportID = reportID;
        obj.showReportData(reportID);    // RepInfo
        
		 var check = false, statusCode = ""; // 1待审 2已审 5退回 6草稿 7删除

        if (reportID) { 
           statusCode = obj.SatusCode;
            obj.gridSampleLoad(reportID);   // SampleInfo   
        }
        if (statusCode==2 || statusCode==7 ) { check = true; }  // 已审、删除不允许修改
		
        obj.clearSampleData();
        obj.DelListSample = "";
        obj.setFormDisabled(check);
        obj.showReportButton(statusCode);
    }

	obj.gridSampleLoad = function(reportID){    
        $cm ({
            ClassName:"DHCMed.EPDService.NCPInvestigationSrv",
            QueryName:"QryReportSample",        
            aReportID: reportID
        },function(rs){
           $('#gridSampleInfo').datagrid('loadData', rs);              
        });
	}
    obj.setFormDisabled = function(check) {
        if (check) {
			var chkSymPtoms = document.getElementsByName("chkSymPtoms");
            if (chkSymPtoms) {
              	for (var i=0; i<chkSymPtoms.length; i++) {
                    $('#'+chkSymPtoms[i].id).checkbox('disable');   
                }
            }
            
            var chkComplication = document.getElementsByName("chkComplication");
            if (chkComplication) {
              	for (var i=0; i<chkComplication.length; i++) {
                    $('#'+chkComplication[i].id).checkbox('disable');   
                }
            } 
            
            var chkPreAnamnesis = document.getElementsByName("chkPreAnamnesis");
            if (chkPreAnamnesis) {
              	for (var i=0; i<chkPreAnamnesis.length; i++) {
                    $('#'+chkPreAnamnesis[i].id).checkbox('disable');   
                }
            } 
            $('#txtIdentity').attr('disabled','disabled');
            $('#txtRepCompany').attr('disabled','disabled');
            $('#dtRepDate').datebox('disable');
            $('#txtTemperature').attr('disabled','disabled');
            $('#txtSymPtom').attr('disabled','disabled');
            
            $('#IsComplication-1').radio('disable');
            $('#IsComplication-0').radio('disable');
            $('#txtComplication').attr('disabled','disabled');   
            $('#IsBloodTest-1').radio('disable');
            $('#IsBloodTest-0').radio('disable');
            $('#dtBloodTestDate').datebox('disable');
            $('#numWBC').attr('disabled','disabled');
            $('#numLymphocyte').attr('disabled','disabled');
            $('#numLymphocytePer').attr('disabled','disabled');
            $('#numNePer').attr('disabled','disabled');
            $('#cboChestXray').combobox('disable');
            $('#dtChestXrayDate').datebox('disable');
            $('#cboChestCT').combobox('disable');
            $('#dtChestCTDate').datebox('disable');
            $('#IsMedical-1').radio('disable');
            $('#IsMedical-0').radio('disable');  
            $('#dtFirstAdmDate').datebox('disable');
            $('#txtAdmHospital').attr('disabled','disabled');
            $('#IsIsolated-1').radio('disable');
            $('#IsIsolated-0').radio('disable');  
            $('#dtIsolatedDate').datebox('disable');
            $('#IsInHosp-1').radio('disable');
            $('#IsInHosp-0').radio('disable');  
            $('#dtInHospDate').datebox('disable');
            $('#IsInICU-1').radio('disable');
            $('#IsInICU-0').radio('disable');  
            $('#dtInICUDate').datebox('disable');
            
            $('#cboOccupation').combobox('disable');
            $('#txtOccupation').attr('disabled','disabled');
            $('#IsGravida-1').radio('disable');
            $('#IsGravida-0').radio('disable');
            $('#txtPreAnamnesis').attr('disabled','disabled');
                              
            $('#cboTravelLive').combobox('disable');
            $('#IsContactFever-1').radio('disable');
            $('#IsContactFever-0').radio('disable'); 
            $('#IsContactTrave-1').radio('disable');
            $('#IsContactTrave-0').radio('disable'); 
            $('#IsContactDiag-1').radio('disable');
            $('#IsContactDiag-0').radio('disable');      
            $('#cboGather').combobox('disable');
            $('#IsTreatment-1').radio('disable');
            $('#IsTreatment-0').radio('disable');         
            $('#cboMarket').combobox('disable');
            $('#txtDistance').attr('disabled','disabled');          
            $('#cboIsMarket').combobox('disable');
            $('#cboMarketType').combobox('disable');
        
            $('#dtSampleDate').datebox('disable');
            $('#cboSampleType').combobox('disable');
            $('#cboSampleResult').combobox('disable');
            $('#btnSaveSample').linkbutton('disable');
            $('#btnDeleteSample').linkbutton('disable');           

        }else {
           
            var chkSymPtoms = document.getElementsByName("chkSymPtoms");
            if (chkSymPtoms) {
              	for (var i=0; i<chkSymPtoms.length; i++) {
                    $('#'+chkSymPtoms[i].id).checkbox('enable');   
                }
            }
            
            var chkPreAnamnesis = document.getElementsByName("chkPreAnamnesis");
            if (chkPreAnamnesis) {
              	for (var i=0; i<chkPreAnamnesis.length; i++) {
                    $('#'+chkPreAnamnesis[i].id).checkbox('enable');   
                }
            } 
           
            $('#IsComplication-1').radio('enable');
            $('#IsComplication-0').radio('enable');              
            $('#IsBloodTest-1').radio('enable');
            $('#IsBloodTest-0').radio('enable');
            $('#cboChestXray').combobox('enable');
            $('#cboChestCT').combobox('enable');
            $('#IsMedical-1').radio('enable');
            $('#IsMedical-0').radio('enable');  
            $('#IsIsolated-1').radio('enable');
            $('#IsIsolated-0').radio('enable');  
            $('#IsInHosp-1').radio('enable');
            $('#IsInHosp-0').radio('enable');  
            $('#IsInICU-1').radio('enable');
            $('#IsInICU-0').radio('enable');  
            
            $('#cboOccupation').combobox('enable');
            $('#IsGravida-1').radio('enable');
            $('#IsGravida-0').radio('enable');
                      
            $('#cboTravelLive').combobox('enable');
            $('#IsContactFever-1').radio('enable');
            $('#IsContactFever-0').radio('enable');
             $('#IsContactTrave-1').radio('enable');
            $('#IsContactTrave-0').radio('enable');   
            $('#IsContactDiag-1').radio('enable');
            $('#IsContactDiag-0').radio('enable');      
            $('#cboGather').combobox('enable');
            $('#IsTreatment-1').radio('enable');
            $('#IsTreatment-0').radio('enable');         
            $('#cboMarket').combobox('enable');
            $('#cboIsMarket').combobox('enable');
        
            $('#dtSampleDate').datebox('enable');
            $('#cboSampleType').combobox('enable');
            $('#cboSampleResult').combobox('enable');
            $('#btnSaveSample').linkbutton('enable');
            $('#btnDeleteSample').linkbutton('enable');
        }       
    }

    
    obj.showReportButton = function(statusCode) {

        $('#btnSaveTmp').hide();    // 草稿
        $('#btnSaveRep').hide();    // 报卡
        $('#btnExecheck').hide();   // 审核
        $('#btnCancheck').hide();   // 取消审核
        $('#btnReturn').hide();  // 退回
        $('#btnDelete').hide();  // 删除
        $('#btnClose').show();   // 关闭

        //1待审 2已审 5退回 6草稿 7删除
        if (LocFlag==0) {   // 医生站
            if (statusCode==1) {     // 待审
                $('#btnSaveRep').show();    // 报卡
                $('#btnSaveRep').linkbutton({text:'修改报卡'});
                $('#btnDelete').show();  // 删除
                //$('#btnPrint').show();        // 打印

            } else if (statusCode==2) { // 已审              
            //
            } else if (statusCode==5) { // 退回
                $('#btnSaveRep').show();    // 报卡
                $('#btnSaveRep').linkbutton({text:'修改报卡'});
                $('#btnDelete').show();  // 删除
            } else if (statusCode==6) { // 草稿
                $('#btnSaveTmp').show();    // 草稿
                $('#btnSaveRep').show();    // 报卡
                $('#btnDelete').show();     // 删除
            } else if (statusCode==7) { // 删除
                //
            } else {                    // 无报告
                $('#btnSaveTmp').show();    // 草稿
                $('#btnSaveRep').show();    // 报卡
            }

        } else if (LocFlag==1) {    // 管理科室
            if (statusCode==1) {            // 待审
                $('#btnSaveRep').show();    // 报卡
                $('#btnSaveRep').linkbutton({text:'修改报卡'});
                $('#btnExecheck').show();   // 审核
                $('#btnReturn').show();  // 退回
                $('#btnDelete').show();  // 删除
                //$('#btnPrint').show();        // 打印

            } else if (statusCode==2) { // 已审
                $('#btnCancheck').show();   // 取消审核
                //$('#btnPrint').show();        // 打印
            } else if (statusCode==5) { // 退回
                $('#btnSaveRep').show();    // 报卡
                $('#btnSaveRep').linkbutton({text:'修改报卡'});
                $('#btnDelete').show();  // 删除
            } else if (statusCode==6) { // 草稿
                $('#btnSaveTmp').show();    // 草稿
                $('#btnSaveRep').show();    // 报卡
                $('#btnDelete').show();     // 删除
            } else if (statusCode==7) { // 删除
                //
            } else {                    // 无报告
                $('#btnSaveTmp').show();    // 草稿
                $('#btnSaveRep').show();    // 报卡
            }
        }
    }
  
   
    obj.showReportData = function(reportID) {
        var arrCurrRep = '';
        if (reportID!="") { 
            obj.CurrReport = obj.ReportManage(reportID); 
            arrCurrRep=obj.CurrReport.split("^");
        }
       
		var IsComplication= "",IsBloodTest= "",IsMedical= "",IsIsolated= "",IsInHosp= "",IsInICU= "",IsGravida= "",IsContactFever= "",IsContactTrave="",IsContactDiag= "",IsTreatment="";
		var CardNo="",Identity= "",RepCompany= "",ReportLoc="",ReportUser="",ReportDate="",ReportTime="",CheckUser="",CheckDate="",SymPtoms= "",Temperature= "",SymPtomExt= "",Complication= "",ComplicationDesc= "",ComplicationExt="";
		var BloodTestDate= "",WBC= "",Lymphocyte= "",LymphocytePer= "",NePer= "",ChestXrayID= "",ChestXrayDesc= "",ChestXrayDate= "",ChestCTID= "",ChestCTDesc= "",ChestCTDate= "";
		var FirstAdmDate= "",AdmHospital= "",IsolatedDate= "",InHospDate= "",InICUDate="",OccupationID= "",OccupationDesc= "",OccupationExt= "",PreAnamnesis= "",PreAnamnesisExt= "";
		var TravelLiveID= "",TravelLiveDesc= "",GatherID= "",GatherDesc= "",MarketID= "",MarketDesc= "",Distance="",IsMarketID= "",IsMarketDesc= "",MarketTypeID="",MarketTypeDesc="";

        if (arrCurrRep) {   // 报告信息 
			CardNo          = arrCurrRep[1];
			StatusID		= arrCurrRep[4].split(CHR_2)[0];
			SatusCode		= arrCurrRep[4].split(CHR_2)[1]; 
			obj.SatusCode   = SatusCode;
			StatusDesc		= arrCurrRep[4].split(CHR_2)[2];  	
			Identity        = arrCurrRep[5];
			obj.EpdID       = arrCurrRep[6];
			SymPtoms        = arrCurrRep[7].split(CHR_2)[0];
			Temperature     = arrCurrRep[8];       
			SymPtomExt      = arrCurrRep[9]; 
			IsComplication	= arrCurrRep[10].split(CHR_2)[0];                                  
			Complication	= arrCurrRep[11].split(CHR_2)[0];     
			ComplicationExt = arrCurrRep[12];                                   
			IsBloodTest		= arrCurrRep[13].split(CHR_2)[0];                             
			BloodTestDate   = arrCurrRep[14];    
			WBC             = arrCurrRep[15];
			Lymphocyte      = arrCurrRep[16];     
			LymphocytePer   = arrCurrRep[17];  
			NePer           = arrCurrRep[18];
			ChestXrayID		= arrCurrRep[19].split(CHR_2)[0];
			ChestXrayDesc	= arrCurrRep[19].split(CHR_2)[2];      	
			ChestXrayDate   = arrCurrRep[20];    
			ChestCTID		= arrCurrRep[21].split(CHR_2)[0];
			ChestCTDesc		= arrCurrRep[21].split(CHR_2)[2];      	
			ChestCTDate     = arrCurrRep[22];      
			IsMedical		= arrCurrRep[23].split(CHR_2)[0];                         
			FirstAdmDate    = arrCurrRep[24];        
			AdmHospital     = arrCurrRep[25];
			IsIsolated		= arrCurrRep[26].split(CHR_2)[0];                          
			IsolatedDate    = arrCurrRep[27]; 
			IsInHosp		= arrCurrRep[28].split(CHR_2)[0];                       
			InHospDate     	= arrCurrRep[29];  
			IsInICU			= arrCurrRep[30].split(CHR_2)[0];                    
			InICUDate       = arrCurrRep[31];
			OccupationID	= arrCurrRep[32].split(CHR_2)[0];
			OccupationDesc	= arrCurrRep[32].split(CHR_2)[2];	
			OccupationExt   = arrCurrRep[33];
			IsGravida		= arrCurrRep[34].split(CHR_2)[0];                        
			PreAnamnesis	= arrCurrRep[35].split(CHR_2)[0];     
			PreAnamnesisExt = arrCurrRep[36];           
			TravelLiveID	= arrCurrRep[37].split(CHR_2)[0]; 
			TravelLiveDesc	= arrCurrRep[37].split(CHR_2)[2];	
			IsContactFever	= arrCurrRep[38].split(CHR_2)[0];                              
			IsContactTrave	= arrCurrRep[39].split(CHR_2)[0];
		    IsContactDiag   = arrCurrRep[40].split(CHR_2)[0];                    
			GatherID		= arrCurrRep[41].split(CHR_2)[0];  
			GatherDesc		= arrCurrRep[41].split(CHR_2)[2];          	
			IsTreatment     = arrCurrRep[42];
			MarketID		= arrCurrRep[43].split(CHR_2)[0];
			MarketDesc		= arrCurrRep[43].split(CHR_2)[2];	
			Distance        = arrCurrRep[44];
			IsMarketID		= arrCurrRep[45].split(CHR_2)[0]; 
			IsMarketDesc	= arrCurrRep[45].split(CHR_2)[2]; 	
			MarketTypeID	= arrCurrRep[46].split(CHR_2)[0];
			MarketTypeDesc	= arrCurrRep[46].split(CHR_2)[2];	
			RepCompany      = arrCurrRep[47];    
			ReportLoc       = arrCurrRep[48];    
			ReportUser      = arrCurrRep[49];
			ReportDate      = arrCurrRep[50];
			ReportTime      = arrCurrRep[51]; 
			CheckUser       = arrCurrRep[52];
			CheckDate       = arrCurrRep[53];    
        } 
       
        if (IsComplication) {
			$HUI.radio("#IsComplication-"+IsComplication).setValue(true); // 有无并发症
		}
		if (IsBloodTest) {
			$HUI.radio("#IsBloodTest-"+IsBloodTest).setValue(true); // 血常规检查是否检测
		}
		if (IsMedical) {
			$HUI.radio("#IsMedical-"+IsMedical).setValue(true); // 发病后是否就诊
		}
		if (IsIsolated) {
			$HUI.radio("#IsIsolated-"+IsIsolated).setValue(true); // 是否隔离
		}
		if (IsInHosp) {
			$HUI.radio("#IsInHosp-"+IsInHosp).setValue(true); // 是否住院
		}
		if (IsInICU) {
			$HUI.radio("#IsInICU-"+IsInICU).setValue(true); // 是否收住 ICU 治疗
		}
		if (IsGravida) {
			$HUI.radio("#IsGravida-"+IsGravida).setValue(true); // 患者是否孕妇
		}
		if (IsContactFever) {
			$HUI.radio("#IsContactFever-"+IsContactFever).setValue(true); // 是否接触过有武汉或其他有本地病例持续传播地区有发热或有呼吸道症状的人
		}	
		if (IsContactTrave) {
			$HUI.radio("#IsContactTrave-"+IsContactTrave).setValue(true); // 是否接触过有武汉或其他有本地病例持续传播地区旅行史或居住史的人
		}
		if (IsContactDiag) {
			$HUI.radio("#IsContactDiag-"+IsContactDiag).setValue(true); // 是否有确诊病例、轻症病例或无症状感染者的接触史
		}
		if (IsTreatment) {
			$HUI.radio("#IsTreatment-"+IsTreatment).setValue(true); // 是否有医疗机构就诊史
		}
		
		$('#txtCardNo').val(CardNo)
		if (Identity) {
        	$('#txtIdentity').val(Identity);
		}
	    $('#txtRepCompany').val(RepCompany);
	    if (ReportDate) {
	    	$('#dtRepDate').datebox('setValue',ReportDate);
	    }
	    if (ReportUser) {
		    $('#txtRepUser').val(ReportUser);
	    }
	    if (ReportUser) {
		    $('#txtRepStatus').val(StatusDesc);
	    }
	     // 症状体征无需再次赋值 
	    if (Complication.split(',')) { // 并发症（多选）
		    for (var len=0; len < Complication.split(',').length;len++) {          
				var value = Complication.split(',')[len];
				if (!value) continue;
				$('#chkComplication'+value).checkbox('setValue', (value!="" ? true:false));                
			}
	    }   
	    $('#txtComplication').val(ComplicationExt);
	    $('#dtBloodTestDate').datebox('setValue',BloodTestDate);
	    $('#numWBC').val(WBC);
	    $('#numLymphocyte').val(Lymphocyte);
	    $('#numLymphocytePer').val(LymphocytePer);
	    $('#numNePer').val(NePer);
	    $('#cboChestXray').combobox('setValue',ChestXrayID);
	    $('#cboChestXray').combobox('setText',ChestXrayDesc);
	    $('#dtChestXrayDate').datebox('setValue',ChestXrayDate);
	    $('#cboChestCT').combobox('setValue',ChestCTID);
	    $('#cboChestCT').combobox('setText',ChestCTDesc);
	    $('#dtChestCTDate').datebox('setValue',ChestCTDate);
	    $('#dtFirstAdmDate').datebox('setValue',FirstAdmDate);
	    $('#txtAdmHospital').val(AdmHospital);
	    $('#dtIsolatedDate').datebox('setValue',IsolatedDate);
	    $('#dtInHospDate').datebox('setValue',InHospDate);
	    $('#dtInICUDate').datebox('setValue',InICUDate);
	    $('#cboOccupation').combobox('setValue',OccupationID);
	    $('#cboOccupation').combobox('setText',OccupationDesc);
	    $('#txtOccupation').val(OccupationExt);
	    if (PreAnamnesis.split(',')) {  // 既往病史（多选） 
	    	for (var len=0; len < PreAnamnesis.split(',').length;len++) {        
				var value = PreAnamnesis.split(',')[len];
				if (!value) continue;
				$('#chkPreAnamnesis'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
	    } 
	               
	    $('#txtPreAnamnesis').val(PreAnamnesisExt);
	    $('#cboTravelLive').combobox('setValue',TravelLiveID);
	    $('#cboTravelLive').combobox('setText',TravelLiveDesc);
	    $('#cboGather').combobox('setValue',GatherID);
	    $('#cboGather').combobox('setText',GatherDesc);
	   
	    $('#cboMarket').combobox('setValue',MarketID);
	    $('#cboMarket').combobox('setText',MarketDesc);
	    $('#txtDistance').val(Distance);    
	    $('#cboIsMarket').combobox('setValue',IsMarketID);
	    $('#cboIsMarket').combobox('setText',IsMarketDesc);
	    $('#cboMarketType').combobox('setValue',MarketTypeID);
	    $('#cboMarketType').combobox('setText',MarketTypeDesc);
	
		if (ChestXrayDesc=="有"){	
			$('#dtChestXrayDate').datebox('enable');
        }
		if (ChestCTDesc=="有"){	
			$('#dtChestCTDate').datebox('enable');
        }
		if (OccupationDesc=="其他"){	
			$('#txtOccupation').removeAttr("disabled");
        }
		if (MarketDesc=="是"){	
			$('#txtDistance').removeAttr('disabled');
        }
		if (IsMarketDesc=="是"){	
			$('#cboMarketType').combobox('enable'); 
		}
    }
    // ****************************** ↑↑↑ refresh

    // 按钮触发事件
    obj.RelationToEvents = function() {
        $('#btnSaveSample').on("click", function(){
            obj.btnSaveSample_click(); 
        });

        $('#btnDeleteSample').on("click", function(){
            obj.btnDeleteSample_click(); 
        });      

        $('#btnSaveTmp').on("click", function(){
            obj.btnSaveTmp_click();
        });

        $('#btnSaveRep').on("click", function(){
            obj.btnSaveRep_click(); 
        });

        $('#btnExecheck').on("click", function(){
            obj.btnExecheck_click();    
        });

        $('#btnCancheck').on("click", function(){
            $.messager.confirm("提示", "请确认是否取消审核?", function (r) {
                if (r){
                    obj.btnCancheck_click(); 
                }
            });
        });

        $('#btnReturn').on("click", function(){
            $.messager.confirm("提示", "请确认是否退回?", function (r) {
                if (r){
                    obj.btnReturn_click(); 
                }
            });
        });

        $('#btnDelete').on("click", function(){
            $.messager.confirm("提示", "请确认是否作废？", function (r) {
                if (r){
                    obj.btnDelete_click(); 
                }
            });
        }); 

        $('#btnClose').on("click", function(){
            obj.btnClose_click(); 
        });
    }

    // ****************************** ↓↓↓ sample func
    obj.btnSaveSample_click = function() {
        var errorStr = "";      
        var SampleDate = $('#dtSampleDate').datebox('getValue');    
        var SampleTypeID = $.trim($('#cboSampleType').combobox('getValue'));
        var SampleTypeDesc = $.trim($('#cboSampleType').combobox('getText'));
        var SampleResultID = $.trim($('#cboSampleResult').combobox('getValue'));
        var SampleResultDesc = $.trim($('#cboSampleResult').combobox('getText'));
        
        if (SampleDate=="") { errorStr = errorStr + "请填写采样日期!"; }
        if (SampleTypeID=="") { errorStr = errorStr + "请选择样本类型!"; }
        if (SampleResultID=="") { errorStr = errorStr + "请选择采样结果!"; }          

        var thisNowDate = Common_GetDate(new Date());
     	if (Common_CompareDate(SampleDate,thisNowDate)>0) {
            $.messager.alert("提示","抱歉，采样日期不能大于当前日期!", 'info');
            return ;
        }
    
        if (errorStr!="") {
            $.messager.alert("提示", errorStr,'info');
            return;
        }

        var ID = "";
        var selectObj = obj.gridSample.getSelected();
        if (selectObj) {
            var ind = obj.gridSample.getRowIndex(selectObj); //获取当前选中行的行号(从0开始)
            obj.gridSample.updateRow({ //更新指定行
                index: ind,  // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                row: {
                    ID:selectObj.ID,
                    SampleDate: SampleDate,
                    SampleTypeID: SampleTypeID,
                    SampleTypeDesc: SampleTypeDesc,
                    SampleResultID: SampleResultID,
                    SampleResultDesc: SampleResultDesc
                }
            });
        } else {
            obj.gridSample.appendRow({ //追加一个新行。新行将被添加到最后的位置。
                ID: '',
                SampleDate: SampleDate,
                SampleTypeID: SampleTypeID,
                SampleTypeDesc: SampleTypeDesc,
                SampleResultID: SampleResultID,
                SampleResultDesc: SampleResultDesc  
            });
            //insertRow 插入一个新行,新行在最前
        }       
        obj.clearSampleData();
    }

    obj.btnDeleteSample_click = function() {
        var selectObj = obj.gridSample.getSelected();
        var index = obj.gridSample.getRowIndex(selectObj); //获取当前选中行的行号(从0开始)      

        if (!selectObj) {
            $.messager.alert("提示", "请选中一条记录!", 'info');
            return;
        }else {
            $.messager.confirm("提示", "确认要删除该条实验室样本采集数据?", function (r) {
                if (r){         
                    if (selectObj.ID!="") {
                        obj.DelListSample = obj.DelListSample + selectObj.ID + ",";
                    }       
                    obj.gridSample.deleteRow(index);
                    obj.clearSampleData();
                }
            });
        }                       
    }   
    
    obj.gridSample_rowclick = function() {
        var objRec = obj.gridSample.getSelected();
        obj.showSampleData(objRec);  
    }
    
    obj.clearSampleData = function() {
	    obj.SampleRowID="";
        $('#dtSampleDate').datebox('clear');
        $('#cboSampleType').combobox('clear'); 
        $('#cboSampleResult').combobox('clear'); 
        obj.gridSample.clearSelections(); //清除选中行
    }

    obj.showSampleData = function(objRow) {
        $('#dtSampleDate').datebox('setValue',objRow.SampleDate);
        $('#cboSampleType').combobox('setValue',objRow.SampleTypeID);
        $('#cboSampleType').combobox('setText',objRow.SampleTypeDesc);      
        $('#cboSampleResult').combobox('setValue',objRow.SampleResultID);
        $('#cboSampleResult').combobox('setText',objRow.SampleResultDesc); 
	}
    // ****************************** ↑↑↑ sample func
    

    // ****************************** ↓↓↓ report func   // 1待审 2已审 5退回 6草稿 7删除
    obj.btnSaveTmp_click = function() { // 草稿
        obj.saveReportInfo(6, "^");
    }  

    obj.btnSaveRep_click = function() { // 报卡
        obj.saveReportInfo(1, "^");
    }

    obj.btnExecheck_click = function() {    // 审核
        obj.saveReportStatus(2, "^");
    }
    
    obj.btnCancheck_click = function() {    // 取消审核
        obj.saveReportStatus(1, "^");
    }   

    obj.btnReturn_click = function() {  // 退回
        obj.saveReportStatus(5, "^");

    }
    obj.btnDelete_click = function() {  // 作废
        obj.saveReportStatus(7, "^");
    } 

    obj.btnClose_click = function() { //关闭
        websys_showModal('close');
    }
    // ****************************** ↑↑↑ report func
   
    // ****************************** ↓↓↓ save
    obj.saveReportStatus = function(statusCode, separate) {

        var statusID = "", checkUser = session['LOGON.USERID'];
        var objStatus = obj.IsExistDic("EpidemicReportStatus", statusCode);
        if (objStatus) { statusID = objStatus.ID; }
        if (obj.reportID=="" || statusID=="") {
            $.messager.alert("提示", "操作失败!", 'info');
            return;
        }
        var checkDate = "", checkTime = "", resume = "";
        var inputStr = obj.reportID;
        inputStr = inputStr + separate + statusID;
        inputStr = inputStr + separate + checkUser;
        inputStr = inputStr + separate + checkDate;
        inputStr = inputStr + separate + checkTime;
   
        var ret = $m({ 
            ClassName:"DHCMed.EPD.NCPInvestigation",
            MethodName:"UpdateStatus",
            aInputStr:inputStr, 
            aSeparate:separate
        },false);
        if (ret>0) {
            $.messager.alert("提示", "操作成功!", 'info');
            obj.refreshFormInfo(ret);
        } else {
            $.messager.alert("提示", "操作失败!", 'info');
        }
    }

    obj.saveReportInfo = function(statusCode, separate) {
        var errorStr = "";
        var inputStr = obj.saveReportStr(statusCode, separate);
        if (inputStr=="") { return; } 

        var retRep = $m({ 
            ClassName:"DHCMed.EPD.NCPInvestigation",
            MethodName:"Update",
            aInputStr:inputStr, 
            aSeparate:separate
        },false);
        
        if (retRep>0) {
            var retSample = obj.saveSample(retRep, separate);
            if (retSample<0) { errorStr = errorStr + "实验室检测保存失败!"; }
        } else {
            errorStr = errorStr + "报告信息保存失败!";
        }

        if (errorStr=="") {
            errorStr = "保存成功!";
            obj.refreshFormInfo(retRep);
            //新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
            if (typeof(history.pushState) === 'function') {
                var Url=window.location.href;
        		Url=rewriteUrl(Url, { ReportID:retRep });
				history.pushState("", "", Url);
            }
        }
        $.messager.alert("提示", errorStr, 'info');
    }

    obj.saveSample = function(reportID, separate) {
        var sampleFlg = "";
        var rows = obj.gridSample.getRows(); //返回当前页的所有行
        var sampleLength = rows.length;     

        for (var i=0; i< sampleLength; i++) {   // Update
            var tmpSample = rows[i];
            var subID = "";
            if (tmpSample.ID!="") { subID = tmpSample.ID.split("||")[1]; }       
            var SampleTypeID = tmpSample.SampleTypeID;
            var SampleResultID = tmpSample.SampleResultID;
            var SampleDate = tmpSample.SampleDate;    

            var inputStr = reportID;    // input
            inputStr = inputStr + separate + subID;
            inputStr = inputStr + separate + SampleTypeID;
            inputStr = inputStr + separate + SampleResultID;
            inputStr = inputStr + separate + SampleDate;

            var ret = $m({ 
                ClassName:"DHCMed.EPD.NCPSample",
                MethodName:"Update",
                aInputStr:inputStr,
                aSeparate:separate
            },false); 
            if (ret<=0) { sampleFlg = sampleFlg - 1; }
        }

        if (obj.DelListSample!="") {    // Delete
            obj.DelListSample = obj.DelListSample.substring(0, obj.DelListSample.length-1);
          	var objDelList = obj.DelListSample.split(",");
            for (var j=0; j<objDelList.length; j++) {
                var ret = $m({ 
                    ClassName:"DHCMed.EPD.NCPSample",
                    MethodName:"DeleteById",
                    aID:objDelList[j]
                },false); 
                if (ret<=0) { sampleFlg = sampleFlg - 1; }
            }
        }   
        return sampleFlg;
    }

    obj.saveReportStr = function(statusCode, separate) {
        var StatusID = "";
        var objStatus = obj.IsExistDic("EpidemicReportStatus", statusCode);
        if (objStatus) { StatusID = objStatus.ID; }
        
      
        var IsComplication = $("input[name=IsComplication]:checked").val();       // 有无并发症
        var IsBloodTest = $("input[name=IsBloodTest]:checked").val();             // 血常规检查是否检测
        var IsMedical = $("input[name=IsMedical]:checked").val();                 // 发病后是否就诊
        var IsIsolated = $("input[name=IsIsolated]:checked").val();               // 是否隔离
        var IsInHosp = $("input[name=IsInHosp]:checked").val();                   // 是否住院
        var IsInICU = $("input[name=IsInICU]:checked").val();                     // 是否收住 ICU 治疗
        var IsGravida = $("input[name=IsGravida]:checked").val();                 // 患者是否孕妇
        var IsContactFever = $("input[name=IsContactFever]:checked").val();       // 是否接触过有武汉或其他有本地病例持续传播地区有发热或有呼吸道症状的人
        var IsContactTrave = $("input[name=IsContactTrave]:checked").val();       // 是否接触过有武汉或其他有本地病例持续传播地区旅行史或居住史的人
        var IsContactDiag = $("input[name=IsContactDiag]:checked").val();         // 是否有确诊病例、轻症病例或无症状感染者的接触史
        var IsTreatment = $("input[name=IsTreatment]:checked").val();             // 是否有医疗机构就诊史
        
        var CardNo           = $.trim($('#txtCardNo').val());
        var Identity         = $.trim($('#txtIdentity').val());
        var RepCompany       = $.trim($('#txtRepCompany').val());
        var RepDate          = $.trim($('#dtRepDate').datebox('getValue'));
		var SymPtoms         = Common_CheckboxValue('chkSymPtoms');               // 症状和体征
		var SymPtomsDesc     = Common_CheckboxLabel('chkSymPtoms');               // 症状和体征
		var Temperature      = $.trim($('#txtTemperature').val());
		var SymPtomExt       = $.trim($('#txtSymPtom').val());	
		var Complication     = Common_CheckboxValue('chkComplication');
		var ComplicationDesc = Common_CheckboxLabel('chkComplication');
		var ComplicationExt  = $.trim($('#txtComplication').val());
		var BloodTestDate    = $.trim($('#dtBloodTestDate').datebox('getValue'));
		var WBC              = $.trim($('#numWBC').val());
		var Lymphocyte       = $.trim($('#numLymphocyte').val());
		var LymphocytePer    = $.trim($('#numLymphocytePer').val());
		var NePer            = $.trim($('#numNePer').val());
		var ChestXray        = $.trim($('#cboChestXray').combobox('getValue'));
		var ChestXrayDesc    = $.trim($('#cboChestXray').combobox('getText'));
		var ChestXrayDate    = $.trim($('#dtChestXrayDate').datebox('getValue'));
		var ChestCT          = $.trim($('#cboChestCT').combobox('getValue'));
		var ChestCTDesc      = $.trim($('#cboChestCT').combobox('getText'));
		var ChestCTDate      = $.trim($('#dtChestCTDate').datebox('getValue'));
		var FirstAdmDate     = $.trim($('#dtFirstAdmDate').datebox('getValue'));
		var AdmHospital      = $.trim($('#txtAdmHospital').val());
		var IsolatedDate     = $.trim($('#dtIsolatedDate').datebox('getValue'));
		var InHospDate       = $.trim($('#dtInHospDate').datebox('getValue'));
		var InICUDate        = $.trim($('#dtInICUDate').datebox('getValue'));
		var Occupation       = $.trim($('#cboOccupation').combobox('getValue'));
		var OccupationDesc   = $.trim($('#cboOccupation').combobox('getText'));
		var OccupationExt    = $.trim($('#txtOccupation').val());
		var PreAnamnesis     = Common_CheckboxValue('chkPreAnamnesis');
		var PreAnamnesisDesc = Common_CheckboxLabel('chkPreAnamnesis');
		var PreAnamnesisExt  = $.trim($('#txtPreAnamnesis').val());
		var TravelLive       = $.trim($('#cboTravelLive').combobox('getValue'));
		var TravelLiveDesc   = $.trim($('#cboTravelLive').combobox('getText'));
		var Gather           = $.trim($('#cboGather').combobox('getValue'));
		var GatherDesc       = $.trim($('#cboGather').combobox('getText'));
		var Market           = $.trim($('#cboMarket').combobox('getValue'));
		var MarketDesc       = $.trim($('#cboMarket').combobox('getText'));
		var Distance         = $.trim($('#txtDistance').val());
		var IsMarket         = $.trim($('#cboIsMarket').combobox('getValue'));
		var IsMarketDesc     = $.trim($('#cboIsMarket').combobox('getText'));
		var MarketType       = $.trim($('#cboMarketType').combobox('getValue'));
		var MarketTypeDesc   = $.trim($('#cboMarketType').combobox('getText'));           
        var RepLoc           = session['LOGON.CTLOCID'];
        var RepUser          = session['LOGON.USERID'];
     
        if ((statusCode==1)||(statusCode==2)) {
            var errorStr = "";
			if (Identity=="") { errorStr = errorStr + "请填写身份证号!<br>"; }
			if (RepCompany=="") { errorStr = errorStr + "请填写调查单位!<br>"; }
			if (RepDate=="") { errorStr = errorStr + "请填写调查日期!<br>"; }
			if (SymPtoms=="") { errorStr = errorStr + "请填写症状和体征!<br>"; }
			if ((SymPtomsDesc.indexOf('发热')>0)&&(Temperature=="")) { errorStr = errorStr + "请填写症状和体征!<br>"; }
			if ((SymPtomsDesc.indexOf('其他')>0)&&(SymPtomExt=="")) { errorStr = errorStr + "请填写其他症状和体征!<br>"; }
			if ((SymPtomExt)&&((Temperature>42)||(Temperature<35))) { errorStr = errorStr + "请检查最高体温填写是否有误!<br>"; }
			if (IsComplication=="") { errorStr = errorStr + "请填写有无并发症!<br>"; }
			if ((IsComplication==1)&&(Complication=="")) { errorStr = errorStr + "请填写并发症!<br>"; }
			if ((ComplicationDesc.indexOf('其他')>0)&&(ComplicationExt=="")) { errorStr = errorStr + "请填写其他并发症!<br>"; }
			if (IsBloodTest=="") { errorStr = errorStr + "请填写血常规检查是否检测!<br>"; }	
			if ((IsBloodTest==1)&&(BloodTestDate=="")) { errorStr = errorStr + "请填写血常规检查检测时间!<br>"; }
			if ((IsBloodTest==1)&&(WBC=="")) { errorStr = errorStr + "请填写WBC（白细胞数）!<br>"; }
			if ((IsBloodTest==1)&&(Lymphocyte=="")) { errorStr = errorStr + "请填写L（淋巴细胞数）!<br>"; }
			if ((IsBloodTest==1)&&(LymphocytePer=="")) { errorStr = errorStr + "请填写L （淋巴细胞百分比）!<br>"; }
			if ((IsBloodTest==1)&&(NePer=="")) { errorStr = errorStr + "请填写N（中性粒细胞百分比）!<br>"; }
			if (ChestXray=="") { errorStr = errorStr + "请填写胸部Ｘ线检测是否有肺炎影像学特征!<br>"; }	      	
			if ((ChestXrayDesc=="有")&&(ChestXrayDate=="")) { errorStr = errorStr + "请填写胸部 Ｘ线 检测检测时间!<br>"; }
			if (ChestCT=="") { errorStr = errorStr + "请填写胸部CT线检测是否有肺炎影像学特征!<br>"; }	
			if ((ChestCTDesc=="有")&&(ChestCTDate=="")) { errorStr = errorStr + "请填写胸部 CT 检测检测时间!<br>"; }
			if (IsMedical=="") { errorStr = errorStr + "请填写发病后是否就诊!<br>"; }
			if ((IsMedical==1)&&(FirstAdmDate=="")) { errorStr = errorStr + "请填写发病后首次就诊日期!<br>"; }
			if ((IsMedical==1)&&(AdmHospital=="")) { errorStr = errorStr + "请填写发病后就诊医院名称!<br>"; }
			if (IsIsolated=="") { errorStr = errorStr + "请填写是否隔离!<br>"; }
			if ((IsIsolated==1)&&(IsolatedDate=="")) { errorStr = errorStr + "请填写隔离开始日期!<br>"; }
			if (IsInHosp=="") { errorStr = errorStr + "请填写是否住院!<br>"; }				
			if ((IsInHosp==1)&&(InHospDate=="")) { errorStr = errorStr + "请填写入院日期!<br>"; }
			if (IsInICU=="") { errorStr = errorStr + "请填写是否收住ICU治疗!<br>"; }
			if ((IsInICU==1)&&(InICUDate=="")) { errorStr = errorStr + "请填写入 ICU日期!<br>"; }
			if (Occupation=="") { errorStr = errorStr + "请填写患者是否是以下特定职业人群!<br>"; }
			if ((OccupationDesc=='其他')&&(OccupationExt=="")) { errorStr = errorStr + "请填写其他职业!<br>"; }
			if (IsGravida=="") { errorStr = errorStr + "请填写患者是否孕妇!<br>"; }
			if (PreAnamnesis=="") { errorStr = errorStr + "请填写既往病史!<br>"; }
			if ((PreAnamnesisDesc.indexOf('其他')>0)&&(PreAnamnesisExt=="")) { errorStr = errorStr + "请填写其他既往病史!<br>"; }
			if (TravelLive=="") { errorStr = errorStr + "请填写是否有武汉或其他有本地病例持续传播地区的旅行史或居住史!<br>"; }
			if (IsContactFever=="") { errorStr = errorStr + "请填写是否接触过有武汉或其他有本地病例持续传播地区有发热或有呼吸道症状的人!<br>"; }
			if (IsContactTrave=="") { errorStr = errorStr + "请填写是是否接触过有武汉或其他有本地病例持续传播地区旅行史或居住史的人!<br>"; }		
			if (IsContactDiag=="") { errorStr = errorStr + "请填写是否有确诊病例、轻症病例或无症状感染者的接触史!<br>"; }
			if (Gather=="") { errorStr = errorStr + "请填写患者同一家庭、工作单位、托幼机构或学校等集体单位是否有聚集性发病!<br>"; }
			if (IsTreatment=="") { errorStr = errorStr + "请填写是否有医疗机构就诊史!<br>"; }
			if (Market=="") { errorStr = errorStr + "请填写居住地点(村庄/居民楼)周围是否有农贸市场!<br>"; }
			if ((MarketDesc=="是")&&(Distance=="")) { errorStr = errorStr + "请填写农贸市场距离您家大约距离!<br>"; }
			if (IsMarket=="") { errorStr = errorStr + "请填写是否去过农贸市场!<br>"; }
			if ((IsMarket=="是")&&(MarketType=="")) { errorStr = errorStr + "请填写病例是农贸市场类型!<br>"; }
		
																																				
            // 身份证格式验证  
            if ($.trim(Identity) != ""){
                if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test(Identity))) {
                  errorStr += '输入的身份证号格式不符合规定！请重新输入!<br>';
                }
            }

            var thisNowDate = Common_GetDate(new Date());
      	  	if (Common_CompareDate(RepDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，调查日期不能大于当前日期!<br>", 'info');
                return false;
            }
            if (Common_CompareDate(BloodTestDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，血常规检查日期不能大于当前日期!<br>", 'info');
                return false;
            }
            if (Common_CompareDate(ChestXrayDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，胸部Ｘ线检测日期不能大于当前日期!<br>", 'info');
                return false;
            }
            if (Common_CompareDate(ChestCTDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，胸部CT检测日期不能大于当前日期!<br>", 'info');
                return false;
            }
            if (Common_CompareDate(FirstAdmDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，首次就诊日期不能大于当前日期!<br>", 'info');
                return false;
            }
            if (Common_CompareDate(InHospDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，入院日期不能大于当前日期!<br>", 'info');
                return false;
            }
            
            if (Common_CompareDate(InICUDate,thisNowDate)>0) {
                $.messager.alert("提示","抱歉，入ICU日期不能大于当前日期!<br>", 'info');
                return false;
            }

            if (errorStr!="") {
                $.messager.alert("提示", errorStr, 'info');
                return "";
            }
        }
       

        var tmpStr = obj.reportID;  // inputStr
        tmpStr = tmpStr + separate + CardNo;
		tmpStr = tmpStr + separate + EpisodeID;
		tmpStr = tmpStr + separate + PatientID;
		tmpStr = tmpStr + separate + StatusID;
		tmpStr = tmpStr + separate + Identity;
		tmpStr = tmpStr + separate + obj.EpdID;
		tmpStr = tmpStr + separate + SymPtoms;
		tmpStr = tmpStr + separate + Temperature;
		tmpStr = tmpStr + separate + SymPtomExt;
		tmpStr = tmpStr + separate + IsComplication;
		tmpStr = tmpStr + separate + Complication;
		tmpStr = tmpStr + separate + ComplicationExt;
		tmpStr = tmpStr + separate + IsBloodTest;
		tmpStr = tmpStr + separate + BloodTestDate;
		tmpStr = tmpStr + separate + WBC;
		tmpStr = tmpStr + separate + Lymphocyte;
		tmpStr = tmpStr + separate + LymphocytePer;
		tmpStr = tmpStr + separate + NePer;
		tmpStr = tmpStr + separate + ChestXray;
		tmpStr = tmpStr + separate + ChestXrayDate;
		tmpStr = tmpStr + separate + ChestCT;
		tmpStr = tmpStr + separate + ChestCTDate;
		tmpStr = tmpStr + separate + IsMedical;
		tmpStr = tmpStr + separate + FirstAdmDate;
		tmpStr = tmpStr + separate + AdmHospital;
		tmpStr = tmpStr + separate + IsIsolated;
		tmpStr = tmpStr + separate + IsolatedDate;
		tmpStr = tmpStr + separate + IsInHosp;
		tmpStr = tmpStr + separate + InHospDate;
		tmpStr = tmpStr + separate + IsInICU;
		tmpStr = tmpStr + separate + InICUDate;
		tmpStr = tmpStr + separate + Occupation;
		tmpStr = tmpStr + separate + OccupationExt;
		tmpStr = tmpStr + separate + IsGravida;
		tmpStr = tmpStr + separate + PreAnamnesis;
		tmpStr = tmpStr + separate + PreAnamnesisExt;
		tmpStr = tmpStr + separate + TravelLive;
		tmpStr = tmpStr + separate + IsContactFever;
		tmpStr = tmpStr + separate + IsContactTrave;
		tmpStr = tmpStr + separate + IsContactDiag;
		tmpStr = tmpStr + separate + Gather;
		tmpStr = tmpStr + separate + IsTreatment;
		tmpStr = tmpStr + separate + Market;
		tmpStr = tmpStr + separate + Distance;
		tmpStr = tmpStr + separate + IsMarket;
		tmpStr = tmpStr + separate + MarketType;
		tmpStr = tmpStr + separate + RepCompany;
		tmpStr = tmpStr + separate + RepLoc;
		tmpStr = tmpStr + separate + RepUser;
		tmpStr = tmpStr + separate + RepDate;
		tmpStr = tmpStr + separate + '';
		tmpStr = tmpStr + separate + '';
		tmpStr = tmpStr + separate + '';
		tmpStr = tmpStr + separate + '';
     
        return tmpStr;
    }
    // ****************************** ↑↑↑ save
}
