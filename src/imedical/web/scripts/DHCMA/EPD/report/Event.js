function InitReportWinEvent(obj) {
		
	/**
	*病人对象
	*/
	obj.PatientManage = function () {   
		var objPatientManage = $cm({                  
			ClassName:"DHCMed.Base.Patient",
			MethodName:"GetObjById",
			PAPMIRowId:PatientID
		},false);
		return objPatientManage;
	}
	
	/**
	* 病人就诊信息对象
	*/
	obj.PaadmManage = function () {   
		var objPaadmManage = $cm({                  
			ClassName:"DHCMed.Base.PatientAdm",
			MethodName:"GetObjById",
			paadm:EpisodeID
		},false);
		return objPaadmManage;
	}
	
	/**
	* 获取传染病报告信息
	*/
	obj.RepManage = function (aReportID) {   
	    var objRep = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			MethodName:"GetRepByID",
			aID:aReportID
		},false);
		
		return objRep;
	}

	/**
	*判断状态字典是否存在项目
	*/
	obj.DicManage = function (aType,aCode) {   //返回为对象的方法需重新写	
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
	/**
	*  推送消息
	*/
	obj.SendNews  = function(aProCode,aReportID,aStatus,aEpisodeID) {   // 当前上报科室
		var ret = $m({                  
			ClassName:"DHCMed.SSIO.FromEnsSrv",
			MethodName:"DHCHisInterface",
			aProCode:aProCode,
			aReportID:aReportID,
			aStatus:aStatus,
			aEpisodeID:aEpisodeID
		},false);
		
		return ret;
	}
	 // 当前上报科室
	obj.LoadLoc  = function (aLocID) {  
		var LocInfo = $m({                  
			ClassName:"DHCMed.Base.Ctloc",
			MethodName:"GetStringById",
			ctloc:aLocID,
			separete:''
		},false);
		return LocInfo;
	}
	// 当前上报病区          
	obj.LoadWard  = function (aWardID) {  
		var WardInfo = $m({     		     
			ClassName:"DHCMed.Base.PacWard",
			MethodName:"GetStringById",
			id :aWardID,
			separete:''
		},false);
	
		return WardInfo;
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

    //系统时间
	obj.LoadSysDateTime  = function () {  
		var SysDateTimeStr =  $m({                  
			ClassName:"DHCMed.EPDService.CommonSrv",
			MethodName:"GetSysDateTime"
		},false);
		return SysDateTimeStr;
	}
	//修改报告状态
	obj.UpdateCheckEPD  = function (aReportID,aStatus,aUserID,aDate,aTime,aTXT) {  
		var strReportID = $m({                  
			ClassName:"DHCMed.EPD.Epidemic",
			MethodName:"UpdateCheckEPD",
			MEPDRowid:aReportID, 
			Status:aStatus, 
			CheckUsr:aUserID, 
			CheckDate: aDate, 
			CheckTime: aTime,
			Demo:aTXT
		},false);
		return strReportID;
	}
	obj.UpdateCorrectEPD  = function (aReportID,aStatus,aTXT) {  
		var strReportID = $m({                  
			ClassName:"DHCMed.EPD.Epidemic",
			MethodName:"UpdateCorrectEPD",
			MEPDRowid:aReportID, 
			Status:aStatus, 
			Demo:aTXT
		},false);
		return strReportID;
	}
	//传染病字典
	obj.LoadEpdInfection  = function (aDiagID,aSeparete) {  
		var InfectionStr =  $m({                  
			ClassName:"DHCMed.EPD.Infection",
			MethodName:"GetStringById",
			id :aDiagID, 
			separete:aSeparete
		},false);
		return InfectionStr;
	}
	//获取附卡项目
	obj.GetCardItem = function (aDiseaseID) {
		var CardItem = $cm({
			ClassName:"DHCMed.EPDService.AppendixCardSrv",
			QueryName:"QryAppendixCardItem",
			ResultSetType:'array',
			aDiseaseID:aDiseaseID,
			IsActive: 'Y'
		},false);
		return CardItem;
	}
	//获取附卡项目值
	obj.GetCardItemValue = function (aReportID) {
		var CardItemValue = $cm({
			ClassName:"DHCMed.EPDService.EpidemicSubSrv",
			QueryName:"QryEpidemicSubInfo",
			ResultSetType:'array',
			aReportID:aReportID
		},false);
		return CardItemValue;
	}
	
	//弹出加载层
	function loadingWindow() {
	    var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#EPDReport"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#EPDReport").css({ display: "block", left: left, top: top }); 
	}
	 
	//取消加载层  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}
	
	obj.LoadEvent = function(){
		
		loadingWindow();
		window.setTimeout(function () { 
			obj.LoadDataCss();
			obj.LoadPatInfo();                              // 加载病人信息
			obj.objCurrPatient = obj.PatientManage();       // 当前病人对象 
			// 判断当前报告是否存在，若不存在，则新建；若存在，则根据报告ID加载对应的报告信息
			if (!ReportID) {			
				// 初始化各报告项和附卡信息
				obj.InitReportInfo();
				//设置默认诊断信息
				obj.InitDiseaseCommbo();		
				// 根据报告状态和权限区分标记显示此报告对应的功能按钮
				obj.DisplayButtonStatus(LocFlag,"","N");
			} else {
				// 根据报告ID加载对应的报告信息
				obj.DisplayReportInfo(ReportID);
				
				// 根据报告状态和权限区分标记显示此报告对应的功能按钮
				if (obj.objCurrReport) {
					var arrCurrRep = obj.objCurrReport.split("^");
					var RepStatus =arrCurrRep[33].split(CHR_2)[0];
					var Occupation = arrCurrRep[3].split(CHR_2)[1];
					
					if (Occupation=="其他") {
						$('#trOtherOccupation').removeAttr("style");
						$('#lblCardNotice').attr("style","display:none");  
					}	
					var IsUpload =arrCurrRep[26];
					obj.DisplayButtonStatus(LocFlag,RepStatus,IsUpload);		
					if (arrCurrRep[26]=="N"){
						$('#btnUpdateCDC').linkbutton({text:'上报CDC'});
					}else{
						$('#btnUpdateCDC').linkbutton({text:'取消上报CDC'});
					}
				}
						
			}
			disLoadWindow(); 
		}, 50); 
		 		
		 // 按钮监听事件
		obj.RelationToEvents(); 
	    //追加隐藏元素，用于强制报告保存失败时作废诊断
		if (top.$("#flag").length>0){
			//已经存在隐藏元素，初始赋值为0		
			top.$("#flag").val(0);
		}else {		
			top.$("body").append("<input type='hidden' id='flag' value='0'>");
		}
	}
	
	/**
	 * 根据医生站传递的参数获取病人的基本信息，载入当前报告对应的表单项
	 */
	obj.LoadPatInfo = function() {
	    var arrWardInfo ='';
	    var EpdPatInfo = ServerObj.EpdPatInfo.split('^');
	    var PapmiNo = EpdPatInfo[0];
	    var MrNo = EpdPatInfo[1];
		var PatientName = EpdPatInfo[2];
		var Sex = EpdPatInfo[3];
		var Age = EpdPatInfo[4];
	    var Birthday = EpdPatInfo[5];
	    var AdmType  = EpdPatInfo[10];
		var EncryptLevel= EpdPatInfo[13];
		var PatLevel= EpdPatInfo[14];
		var CardTypeCode = EpdPatInfo[7];
		var PatCardNo = EpdPatInfo[8];
		var CardType = EpdPatInfo[9];
		
		$('#PatientName').text(PatientName);			
		$('#PapmiNo').text(PapmiNo);
		$('#InPatientMrNo').text(MrNo);		
		$('#Birthday').text(Birthday);
		$('#Age').text(Age);
		if (Sex == '女') {
			$('#Sex').removeClass('man').addClass('woman');		
		} else if(Sex == '男')  {
			$('#Sex').removeClass('woman').addClass('man');
		} else{
			debugger;
			$('#Sex').removeClass('man').removeClass('woman').addClass('unknowgender');
			debugger;
		}
		if (!ReportID) {
	    	$('#cboCardType').combobox('setValue',(CardType ? CardTypeCode:''));
	    	$('#cboCardType').combobox('setText',(CardType ? CardType:''));					
			$('#txtPatCardNo').val(PatCardNo);
		}
				
	    $('#EncryptLevel').text(EncryptLevel);
		$('#PatLevel').text(PatLevel);
		var RepPlace = obj.objCurrRepPlace ? obj.objCurrRepPlace.Description : '';
		$('#RepPlace').text(RepPlace);	
		$('#RepUser').text(session['LOGON.USERNAME']);
	}
	
	/**
	 * 新建报告 - 初始化各报告项和附卡信息
	 */
	obj.InitReportInfo = function() {		
		$('#cboSickKind').combobox('disable');         //发病程度默认不可选
		$('#cboSeverity').combobox('disable');         //临床严重程度默认不可选  add 20200203

		$('#txtTel').val(obj.objCurrPatient.RelativeTelephone);		    //联系电话	
		if ($.trim(obj.objCurrPatient.WorkAddress)) {                   // 如果加载HIS建卡的工作单位为空,则默认设置为“无”
			$('#txtCompany').val(obj.objCurrPatient.WorkAddress);
		} else {
			$('#txtCompany').val("无");
		}
	
		if (obj.objCurrPatient.Age <= ServerObj.EpdRepPatRelRequireMaxAge) {  // 增加条件判断，如果年龄小于等于14，需要带亲属姓名，14岁以上设为空
			$('#txtRelationName').val(obj.objCurrPatient.RelativeName);	//家长姓名
		} else {
			$('#txtRelationName').val("");	//家长姓名
		}
		//$('#txtPatCardNo').val(obj.objCurrPatient.PersonalID);		//身份证
		$('#txtAddress').val(obj.objCurrPatient.Address);			//现住址
		
		// 传染病报卡默认初始化加载当地医院所在的省、市、县三级
		var arrayArea = ServerObj.EpdInitAddressByLocalHospital.split("`");
		var initProvince = arrayArea[0].split('^')[0];
		var initCity = arrayArea[1].split('^')[0];
		var initCounty = arrayArea[2].split('^')[0];
		var initProvince2 = arrayArea[0].split('^')[1];
		var initCity2 = arrayArea[1].split('^')[1];
		var initCounty2 = arrayArea[2].split('^')[1];
		var initVillage = ((arrayArea[3]) ? arrayArea[3].split('^')[0]:'');
		var initVillage2 = ((arrayArea[3]) ? arrayArea[3].split('^')[1]:'');
		var initRoad = ((arrayArea[4]) ? arrayArea[4].split('^')[0]:'');
		$('#cboProvince').combobox('setValue',initProvince);
		$('#cboCity').combobox('setValue',initCity);
		$('#cboCounty').combobox('setValue',initCounty);
		$('#cboProvince').combobox('setText',initProvince2);
		$('#cboCity').combobox('setText',initCity2);
		$('#cboCounty').combobox('setText',initCounty2);
		$('#cboVillage').combobox('setValue',initVillage);
		$('#cboVillage').combobox('setText',initVillage2);
		$('#txtRoad').val(initRoad);
		$('#txtAddress').val(ServerObj.PatCurrAddress);
	
		// 初始加载报卡界面，默认传染病患者的密切接触情况为“无相关症状”
		if (ServerObj.EpdInitIntimateKey){
			var arrTmp = ServerObj.EpdInitIntimateKey.split("^");
			$('#cboIntimate').combobox('setValue',arrTmp[1]);
			$('#cboIntimate').combobox('setText',arrTmp[2]);
		}
		if (ServerObj.OccupationInfo){
			$('#cboOccupation').combobox('setValue',((ServerObj.OccupationInfo.split(",")[0]) ? ServerObj.OccupationInfo.split(",")[1]:'')); 
			$('#cboOccupation').combobox('setText',((ServerObj.OccupationInfo.split(",")[0]) ? ServerObj.OccupationInfo.split(",")[2]:'')); 
		}
		// 设置诊断日期默认为当天
		$('#dtDiagnoseDate').datetimebox('setValue', Common_GetCurrDateTime(new Date()));
	}
	
	/**
	 * 核心方法：根据报告ID加载对应的报告信息
	 * @param {} ReportID
	 */
	obj.DisplayReportInfo = function(reportId) {
		
		obj.objCurrReport = obj.RepManage(reportId);
		if(!obj.objCurrReport) return;
        
		var arrCurrRep = obj.objCurrReport.split("^");
		
		$('#RepStatus').text(arrCurrRep[33].split(CHR_2)[1]);
	    //$('#RepWard').text(arrCurrRep[28].split(CHR_2)[1]);
	    //$('#RepLoc').text(arrCurrRep[27].split(CHR_2)[1]);
	    $('#RepPlace').text(arrCurrRep[29].split(CHR_2)[1]);
	    $('#RepUser').text(arrCurrRep[30].split(CHR_2)[1]);
		
		$('#txtTel').val(arrCurrRep[17]);		        //联系电话
		$('#txtCompany').val(arrCurrRep[14]);		    //工作单位
		$('#txtRelationName').val(arrCurrRep[4]);	    //家长姓名
		$('#txtAddress').val(arrCurrRep[15]);			//现住址
		// 加载职业
		$('#cboOccupation').combobox('setValue',arrCurrRep[3].split(CHR_2)[0]);
		$('#cboOccupation').combobox('setText',arrCurrRep[3].split(CHR_2)[1]);
		$('#txtOtherOccupation').val(arrCurrRep[40]); 
		
		//若是2016年更新之前的报卡，证件类型默认显示为居民身份证号，否则加载当前类型
		if(($.trim(obj.objCurrPatient.PersonalID)!="")&&($.trim(arrCurrRep[20])=="")&&($.trim(arrCurrRep[19])=="")){
			$m({                  
				ClassName:"DHCMed.EPDService.CommonSrv",
				MethodName:"GetActiveCardNo",
				PatientID:PatientID,
			},function(CardInfo){
				if (!CardInfo) return;
				var arrPatCard=CardInfo.split("^");
				$('#cboCardType').combobox('setValue',arrPatCard[0]);				
				$('#txtPatCardNo').val(arrPatCard[1]);
			});
		}else{
			// 加载证件类型	
			$('#cboCardType').combobox('setValue',arrCurrRep[19].split(CHR_2)[0]);	
			$('#cboCardType').combobox('setText',arrCurrRep[19].split(CHR_2)[1]);		
			$('#txtPatCardNo').val(arrCurrRep[20]);			
		}
		
		// 加载区域
		$('#cboRegion').combobox('setValue',arrCurrRep[2].split(CHR_2)[0]);
		$('#cboRegion').combobox('setText',arrCurrRep[2].split(CHR_2)[1]);
		// 省市县乡街道
		$('#cboProvince').combobox('setValue',arrCurrRep[21].split(CHR_2)[0]);
		$('#cboProvince').combobox('setText',((arrCurrRep[21].indexOf(CHR_2)>-1) ? arrCurrRep[21].split(CHR_2)[1] : ''));
		$('#cboCity').combobox('setValue',arrCurrRep[22].split(CHR_2)[0]);
		$('#cboCity').combobox('setText',((arrCurrRep[22].indexOf(CHR_2)>-1) ? arrCurrRep[22].split(CHR_2)[1] : ''));
		$('#cboCounty').combobox('setValue',arrCurrRep[23].split(CHR_2)[0]);
		$('#cboCounty').combobox('setText',((arrCurrRep[23].indexOf(CHR_2)>-1) ? arrCurrRep[23].split(CHR_2)[1] : ''));
		$('#cboVillage').combobox('setValue',arrCurrRep[24].split(CHR_2)[0]);
		$('#cboVillage').combobox('setText',((arrCurrRep[24].indexOf(CHR_2)>-1) ? arrCurrRep[24].split(CHR_2)[1] : ''));
		$('#txtRoad').val(arrCurrRep[25]);
		
		// 加载诊断
		$('#cboDisease').combobox('setValue',arrCurrRep[5].split(CHR_2)[0]);
		$('#cboDisease').combobox('setText',arrCurrRep[5].split(CHR_2)[1]);
		// 加载临床严重程度 add 20200203
		if ((arrCurrRep[5].split(CHR_2)[1]=="新型冠状病毒感染的肺炎")||(arrCurrRep[5].split(CHR_2)[1]=="新型冠状病毒肺炎")) {
			$('#cboSeverity').combobox('enable');        
			$('#cboSeverity').combobox('setValue',arrCurrRep[42].split(CHR_2)[0]);
			$('#cboSeverity').combobox('setText',arrCurrRep[42].split(CHR_2)[1]);
		} else {
	        $('#cboSeverity').combobox('disable');         //临床严重程度默认不可选 add 20200203
			$('#cboSeverity').combobox('clear');
        }
        if ((arrCurrRep[5].split(CHR_2)[1]=="乙型病毒性肝炎")||(arrCurrRep[5].split(CHR_2)[1]=="丙型病毒性肝炎")||(arrCurrRep[5].split(CHR_2)[1]=="血吸虫病")||(arrCurrRep[5].split(CHR_2)[1]=="其它")) {
			$('#cboSickKind').combobox('enable');         //发病程度恢复可选
		}else {
			$('#cboSickKind').combobox('clear');          //清空选中值
			$('#cboSickKind').combobox('disable'); 
		}
		// 加载诊断分类
		$('#cboDegree').combobox('setValue',arrCurrRep[9].split(CHR_2)[0]);
		$('#cboDegree').combobox('setText',arrCurrRep[9].split(CHR_2)[1]);			
		// 加载发病程度
		$('#cboSickKind').combobox('setValue',arrCurrRep[12].split(CHR_2)[0]);
		$('#cboSickKind').combobox('setText',arrCurrRep[12].split(CHR_2)[1]);
		
		// 发病日期
		$('#dtSickDate').datebox('setValue',arrCurrRep[8]);
		// 诊断日期
		var DiagDate = arrCurrRep[11].split(" ")[0];
		var DiagTime = arrCurrRep[11].split(" ")[1];
		$('#dtDiagnoseDate').datetimebox('setValue',(DiagDate+' '+DiagTime));  //修改诊断日期为诊断日期时间	
		// 死亡日期
		$('#dtDeadDate').datebox('setValue',arrCurrRep[13]);
		// 加载接触情况
		$('#cboIntimate').combobox('setValue',arrCurrRep[6].split(CHR_2)[0]);
		$('#cboIntimate').combobox('setText',arrCurrRep[6].split(CHR_2)[1]);
		// 加载备注
		$('#txtResumeText').val(arrCurrRep[38]);
		
		//判断附卡项目
		var DiseaseID = arrCurrRep[5].split(CHR_2)[0];
		var CardType  = obj.LoadCardType(DiseaseID);
		if (CardType) {
			if (CardType=='HBV') {
				$('#HBVInfoDIV').attr("style","display:true"); //显示乙肝附卡div
			}
			else if (CardType=='HIV') {
				$('#HIVInfoDIV').attr("style","display:true"); //显示艾滋病附卡div
			}
			else if (CardType=='STD') {
				$('#STDInfoDIV').attr("style","display:true"); //显示性病附卡div	
			}
		}	
		//加载附卡信息
		var objItemValue = obj.GetCardItemValue(reportId);
		if (objItemValue.length<1) return;		
		for (var ind=0; ind < objItemValue.length;ind++) {
			var ItemID   = objItemValue[ind].RowID;
			var HiddenValue = objItemValue[ind].HiddenValue;
			var ItemValue = objItemValue[ind].ItemValue;
			var ItemCode = objItemValue[ind].ItemCode;
			if (ItemCode=="") continue;
			var ItemType = objItemValue[ind].ItemType;
			
			if (ItemType==1) { //文本
				$('#'+ItemCode).val(ItemValue);
			}
			else if (ItemType==2) { //数字
				if (ItemValue=="") continue;
				$('#'+ItemCode).numberbox('setValue',ItemValue);
			}
			else if (ItemType==3) { //日期
				$('#'+ItemCode).datebox('setValue',ItemValue);		
			}
			else if (ItemType==4) { //字典
				$('#'+ItemCode).combobox('setValue',HiddenValue);
				$('#'+ItemCode).combobox('setText',ItemValue);
			}
			else if (ItemType==5) { //是否（单个checkbox）
				$('#'+ItemCode).checkbox('setValue',(HiddenValue=='Y'? true : false));
			}
			else if (ItemType==6) { //字典多选  
				$('#'+ItemCode).combobox('setValues',HiddenValue);
				$('#'+ItemCode).combobox('setText',ItemValue);  //??
			}
			else if (ItemType==7) { //单选列表
				if (HiddenValue=="") continue;
				$HUI.radio('#'+ItemCode+HiddenValue).setValue(true);
			}
			else if (ItemType==8) { //多选列表
				if (HiddenValue=="") continue;
				for (var len=0; len < HiddenValue.split(',').length;len++) {
					var valueCode = HiddenValue.split(',')[len];
					$('#'+ItemCode+valueCode).checkbox('setValue', true);
				}
			}
			else if (ItemType==9) { //复选框
				$('#'+ItemCode).checkbox('setValue',(HiddenValue=='1'? true : false));
			}else {
				continue;
			}
		}	
		
	};
	
	//aStatusCode为报告要求修改为的状态 aOperationDesc为操作说明
	obj.SaveReport = function(aStatusCode,aOperationDesc){
		var strMain = obj.SaveToString(obj.objCurrReport, aStatusCode);	// 主卡字符串
		var strSub = obj.SaveSubToString();		                        // 子卡字符串
	
		var strReportID = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			MethodName:"SaveEpidemicReport",
			ReportStr: strMain, 
			ReportSubStr:strSub
		},false);
		
		if (strReportID > 0) {
			obj.ReportID = strReportID ;
			$.messager.alert("提示", aOperationDesc + "成功！", 'info');
			obj.LoadPatInfo();              		// 根据生成的报告加载病人基本信息
			obj.DisplayReportInfo(strReportID);		// 根据报告ID显示对应的报告信息
			// 显示当前报告状态下的操作按钮状态
			if (obj.objCurrReport) {
				var arrCurrRep = obj.objCurrReport.split("^");
				var RepStatus =arrCurrRep[33].split(CHR_2)[0];
				var IsUpload =arrCurrRep[26];
				obj.DisplayButtonStatus(LocFlag,RepStatus,IsUpload);
			}	
			
			//修改追加隐藏元素，用于强制报告保存失败时作废诊断
			top.$("#flag").val(1);
			//history.length返回一个整数，该整数表示会话历史中元素的数目，包括当前加载的页
			if (history.length>0) {   //非模态窗口弹出
				//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
				if (typeof(history.pushState) === 'function') {
				  	var Url=window.location.href;
			        Url=rewriteUrl(Url, {
				        ReportID:obj.ReportID
			        });
			    	history.pushState("", "", Url);
			    	return obj.ReportID;
				}
			}
		} else {
			$.messager.alert("提示", aOperationDesc + "失败！返回值：" + strReportID, 'info');
		}
		return obj.ReportID;
	}
	//aStatusCode为报告要求修改为的状态 aOperationDesc为操作说明
	obj.SaveReportAA = function(aStatusCode,aOperationDesc,aTXT){
		var strSysDateTime=obj.LoadSysDateTime();
		var tmpList=strSysDateTime.split(" ");
			
		var strReportID = obj.UpdateCheckEPD(obj.ReportID, aStatusCode,session['LOGON.USERID'], tmpList[0], tmpList[1], aTXT);
		if (strReportID > 0) {
			obj.ReportID= strReportID;
			$.messager.alert("提示", aOperationDesc + "成功！", 'info');
			obj.DisplayReportInfo(strReportID);		// 根据报告ID显示对应的报告信息
			
			obj.LoadPatInfo();              		// 根据生成的报告加载病人基本信息
		
			// 显示当前报告状态下的操作按钮状态
			if (obj.objCurrReport) {
				var arrCurrRep = obj.objCurrReport.split("^");
				var RepStatus =arrCurrRep[33].split(CHR_2)[0];
				var IsUpload =arrCurrRep[26];
				obj.DisplayButtonStatus(LocFlag,RepStatus,IsUpload);
			}	
		} else {
			$.messager.alert("提示", aOperationDesc + "失败！返回值：" + strReportID, 'info');
		}
		return obj.ReportID;
	}
	// 数据校验函数
	obj.ValidateContents = function() {
		
		var InputError = "";
		if ($.trim($('#cboOccupation').combobox('getValue')) == "") {
			InputError = InputError + "请选择人群分类!<br>";
		}
		if ($.trim($('#cboRegion').combobox('getValue')) == "") {
			InputError = InputError + "请选择病人属于!<br>";
		}	
		if ($.trim($('#txtTel').val()) == "") {
			InputError = InputError + "请填写联系电话!<br>";
		}
		if (($.trim($('#txtRelationName').val())== "") && (obj.objCurrPatient.Age <= new Number($.trim(ServerObj.EpdRepPatRelRequireMaxAge)))) {
			InputError = InputError + "年龄小于等于" + new Number($.trim(ServerObj.EpdRepPatRelRequireMaxAge)) + "岁的患者必需填写家长姓名!<br>";
		}
		if ($.trim($('#cboOccupation').combobox('getText'))=="其他") {
			if ($.trim($('#txtOtherOccupation').val())==""){
				InputError = InputError + "请填写其他人群!<br>";
			}
		}
		//职业为幼托儿童,散居儿童,必须填写家长姓名
		var arrayEpdOccupationToRelName = ServerObj.EpdOccupationToRelName.split("`");
		if ($.trim($('#txtRelationName').val()) == "") {
			for (var i = 0; i < arrayEpdOccupationToRelName.length; i++) {
				if ($('#cboOccupation').combobox('getText') == arrayEpdOccupationToRelName[i]) {
					InputError = InputError + "患者人群分类是：" +$('#cboOccupation').combobox('getText') + "，请填写家长姓名!<br>";
				}
			}
		}
		//8岁以下人群分类只能填写“幼托儿童”、“散居儿童”、“学生”等
		var Occupation=$('#cboOccupation').combobox('getText');
		if (obj.objCurrPatient.Age <=8){
			if ((Occupation!="幼托儿童")&&(Occupation!="散居儿童")&&(Occupation!="学生（大中小学）")){
				InputError = InputError + "年龄小于等于8岁的患者，人群分类必需填写幼托“幼托儿童”、“散居儿童”、“学生（大中小学）”!<br>";	
			}
		}


		// 职业为幼托儿童,学生(大中小学生),工作单位不能填无，必须填写学校(幼儿园)、年级、班级 
		var arrayEpdOccupationToCompany = ServerObj.EpdOccupationToCompany.split("`");
		if ($.trim($('#txtCompany').val()) == "无") {
			for (var i = 0; i < arrayEpdOccupationToCompany.length; i++) {
				if ($('#cboOccupation').combobox('getText') == arrayEpdOccupationToCompany[i]) {
					InputError = InputError + "患者人群分类是：" + $('#cboOccupation').combobox('getText') + "，请填写学校(幼儿园)、年级、班级!<br>";
				}
			}
		}
		// 判断如果工作单位为空或者为非法字符等,则不允许上报
		if (($.trim($('#txtCompany').val()) == "") || ($.trim($('#txtCompany').val()) == "\\") || ($.trim($('#txtCompany').val()) == "\/")) {
			InputError = InputError + "患者工作单位(学校)：请填写工作单位，没有工作单位请填“无”，学生请填写学校、年级、班级!<br>";
		}
	
		if ($.trim($('#txtAddress').val()) == "") {
			InputError = InputError + "请填写现住址!<br>";
		}
		
		if ($.trim($('#cboDisease').combobox('getValue')) == "") {
			InputError = InputError + "请选择传染病诊断!<br>";
		}
		
		var DiseaseDesc = $('#cboDisease').combobox('getText');
		var SickKind = $('#cboSickKind').combobox('getText');
  		//add 20200203
        if (((DiseaseDesc=="新型冠状病毒感染的肺炎")||(DiseaseDesc=="新型冠状病毒肺炎"))&&($.trim($('#cboSeverity').combobox('getValue')) == "")) {
        	InputError = InputError + "当传染病诊断为新型冠状病毒肺炎时，临床严重程度不允许为空!<br>";
        }
		// 如果诊断属于“乙肝、丙肝、血吸虫”，则“发病程度”必选“急性 、慢性
		var arrayEpdDiseaseToSickKind=ServerObj.EpdDiseaseToSickKind.split("///");
		for (var i = 0; i < arrayEpdDiseaseToSickKind.length; i++) {
			var arrsubEpdDiseaseToSickKind=arrayEpdDiseaseToSickKind[i].split("~");
			var arrchildEpdDiseaseToSickKind=arrsubEpdDiseaseToSickKind[0].split("`");
			for (var j = 0; j < arrchildEpdDiseaseToSickKind.length; j++){			
				if (DiseaseDesc == arrchildEpdDiseaseToSickKind[j]) {
					if ((!SickKind)||((SickKind.indexOf('急性')<0)&&(SickKind.indexOf('慢性')<0))) {
						InputError = InputError + "当传染病诊断是乙型肝炎、丙型肝炎、血吸虫病时，发病程度需分急性或慢性填写!<br>";
					}
				}
			}
		}
	    if ((DiseaseDesc=="其它")&&(SickKind !="未分类")) {
			InputError = InputError + "当传染病诊断是其它时，发病程度必须为未分类!<br>";

		}
		var PatRegion = $('#cboRegion').combobox('getText');
		if ((PatRegion.indexOf('港澳台') > -1)||(PatRegion.indexOf('外籍') > -1)) {
			//不需要填写身份证
		} else {	
			if (($.trim($('#cboProvince').combobox('getValue')) == "")
				|| ($.trim($('#cboCity').combobox('getValue')) == "")
				|| ($.trim($('#cboCounty').combobox('getValue')) == "")
				|| ($.trim($('#cboVillage').combobox('getValue')) == "")
				|| ($.trim($('#txtRoad').val()) == "")) {
				InputError = InputError + "请填写省、市、县、乡、门牌号!<br>";
			}
		}
		
        if ($.trim($('#cboCardType').combobox('getValue')) == "") {
			InputError = InputError + "请选择证件类型!<br>";
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			InputError = InputError + "请填写有效证件号!<br>";
		}
        // 验证身份证号是否合法(通过正则表达式)
        var PatCardNo = $('#txtPatCardNo').val();
		var CardType=$('#cboCardType').combobox('getText');
		if ((CardType.indexOf('身份证')>-1)&&($.trim(PatCardNo) != "")){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test(PatCardNo))) {
				InputError += '输入的身份证号格式不符合规定！请重新输入!<br>';
			}
		}
       	if (CardType=="监护人证件"){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test(PatCardNo))) {
				InputError += '输入的监护人证件号(监护人身份证号)格式不符合规定！请重新输入!<br>';
			}
		}
		if ($.trim($('#cboDegree').combobox('getValue')) == "") {
			InputError = InputError + "请选择病例分类!<br>";
		}
		var DegreeDesc= $('#cboDegree').combobox('getText');
		if ((DiseaseDesc.indexOf('梅毒')>-1)||(DiseaseDesc=='淋病')) {
			if ((DegreeDesc!="确诊病例")&&(DegreeDesc!="疑似病例")) {
				InputError = InputError + "当传染病诊断是梅毒、淋病时，病例分类只能是确诊病例和疑似病例!<br>";
			}
		}
		if ((DiseaseDesc=='尖锐湿疣')||(DiseaseDesc=='生殖器疱疹')) {
			if ((DegreeDesc!="确诊病例")&&(DegreeDesc!="临床诊断病例")) {
				InputError = InputError + "当传染病诊断是尖锐湿疣、生殖器疱疹时，病例分类只能是确诊病例和临床诊断病例!<br>";
			}
		}
		if (DiseaseDesc=='生殖道沙眼衣原体感染') {
			if (DegreeDesc!="确诊病例") {
				InputError = InputError + "当传染病诊断是生殖道沙眼衣原体感染时，病例分类只能是确诊病例!<br>";
			}
		}
		if ((DiseaseDesc.indexOf('菌阴')>-1)&&(DegreeDesc=="确诊病例")) {
			InputError = InputError + "当传染病诊断是菌(-)时，病例分类不能是确诊病例!<br>";	
		}
		if ((DiseaseDesc=='艾滋病')&&(DegreeDesc=="疑似病例")) {
			InputError = InputError + "当传染病诊断是艾滋病时，病例分类不能是疑似病例!<br>";	
		}
		if ((DiseaseDesc=='埃博拉出血热')&&(DegreeDesc!="埃博拉留观病例")) {
			InputError = InputError + "当传染病诊断是埃博拉出血热时，病例分类只能是埃博拉留观病例!<br>";	
		}
		if ((DiseaseDesc.indexOf('灰质炎')>-1)||(DiseaseDesc=='HIV')||
			(DiseaseDesc.indexOf('涂阳')>-1)&&(DiseaseDesc.indexOf('仅培阳')>-1)) {
			if ((DegreeDesc=="临床诊断病例")||(DegreeDesc=="疑似病例")) {
				InputError = InputError + "当传染病诊断是脊灰、HIV、涂(+)或仅培阳时，病例分类不能是临床诊断病例和疑似病例!<br>";
			}
		}
		if ((DiseaseDesc!='霍乱')&&(DiseaseDesc.indexOf('灰质炎')<0)&&
			(DiseaseDesc!='乙型病毒性肝炎')&&(DiseaseDesc.indexOf('伤寒')<0)&&
			(DiseaseDesc!='间日疟')&&(DiseaseDesc!='恶性疟')) {
			if ((DegreeDesc=="病原携带者")) {
				InputError = InputError + "当传染病诊断是霍乱、脊灰、乙肝、伤寒、副伤寒、间日疟、恶性疟时，病例分类才能是病原携带者!<br>";
			}
		}
		// add 20200206
		var Severity = $('#cboSeverity').combobox('getText');
		if ((DiseaseDesc=='新型冠状病毒感染的肺炎')||(DiseaseDesc=='新型冠状病毒肺炎')) {
			if ((DegreeDesc!="确诊病例")&&(DegreeDesc!="疑似病例")&&(DegreeDesc!="阳性检测")) {
				InputError = InputError + "当传染病诊断是新型冠状病毒肺炎时，病例分类只能是疑似病例、确诊病例和阳性检测!<br>";
			}
		}
		if ((DegreeDesc=="阳性检测")&&(Severity!="无症状感染者")) {   //临床严重程度在新冠肺炎时才可填报故此判断
	        InputError = InputError + "“阳性检测”仅限于新型冠状病毒肺炎无症状感染者填报!<br>";
        }
			
		var data = $m({      //根据诊断获取传染病类别
			ClassName:"DHCMed.EPDService.InfectionSrv",
			MethodName:"GetMIFKind",
			aDiseaseID:$('#cboDisease').combobox('getValue')
		},false);
		if (data != ''){
			if (data=='AFP') {
				if ((DegreeDesc=="确诊病例")||(DegreeDesc=="疑似病例")) {
					InputError = InputError + "当传染病诊断类型是AFP时，病例分类不能是确诊病例和疑似病例!<br>";
				}
			}
		}
		if ($('#dtSickDate').datebox('getValue') == "") {
			InputError = InputError + "请选择发病日期!<br>";
		}
		
		if ($('#dtDiagnoseDate').datebox('getValue') == "") {
			InputError = InputError + "请选择诊断日期!<br>";
		}	
       
		var dtSickDateStr = $('#dtSickDate').datebox('getValue');	//发病日期
		var dtDiagnoseDateStr = $('#dtDiagnoseDate').datetimebox('getValue');	//诊断日期
		var dtDeadDateStr = $('#dtDeadDate').datebox('getValue');//死亡日期
		var sickDate = dtSickDateStr;
		var diagnoseDate = dtDiagnoseDateStr.split(" ")[0];
		var DeadDate = dtDeadDateStr;
		var thisNowDate = Common_GetDate(new Date());
	  
		if (Common_CompareDate(sickDate,diagnoseDate)>0) {
			$.messager.alert("提示","抱歉，发病日期不能大于诊断日期!", 'info');
			return false;
		}
		if (Common_CompareDate(sickDate,thisNowDate)>0) {
			$.messager.alert("提示","抱歉，发病日期不能大于当前日期!", 'info');
			return false;
		}
		if (Common_CompareDate(DeadDate,thisNowDate)>0) {
			$.messager.alert("提示","抱歉，死亡日期不能大于当前日期!", 'info');
			return false;
		}
		if (Common_CompareDate(sickDate,DeadDate)>0) {
			$.messager.alert("提示","抱歉，发病日期不能大于死亡日期!", 'info');
			return false;
		}
		if (Common_CompareDate(diagnoseDate,thisNowDate)>0) {
			$.messager.alert("提示","抱歉，诊断日期不能大于当前日期!", 'info');
			return false;
		}
			
		//判断附卡项目
		var DiseaseID = $('#cboDisease').combobox('getValue');
		var CardType  = obj.LoadCardType(DiseaseID);
		if (CardType) {
			if (CardType=='HBV') {
				if ($.trim($('#cboHBVHBsAgPositive').combobox('getValue')) == "") {
					InputError = InputError + "请选择HBsAg阳性时间!<br>";
				}
				if ($.trim($('#txtHBVALT').val()) == "") {
					InputError = InputError + "请填写本次ALT!<br>";
				}
				if ($.trim($('#cboHBVLiverResult').combobox('getValue')) == "") {
					InputError = InputError + "请选择肝组织穿刺检测结果!<br>";
				}
				if (($('#dtHBVSymbolDate').datebox('getValue') == "")&&($('#chk-HBVSymbol').checkbox('getValue')=="")&&($('#chk-HBVUnknown').checkbox('getValue')=="")) {
					InputError = InputError + "请选择首次出现乙肝症状和体征的时间!<br>";
				}
				if (Common_RadioValue('radHBVDiluteList') == "") {
					InputError = InputError + "请选择抗-HBc IgM 1:1000 稀释检测结果!<br>";
				}
				if (Common_RadioValue('radHBVSerumList')=="") {
					InputError = InputError + "请选择恢复期血清HBsAg阴转，抗HBs阳转!<br>";
				}			
			} else if (CardType=='HIV') {
				if ($.trim($('#cboHIVMarriage').combobox('getValue'))=="") { 
					InputError = InputError + "请选择婚姻状况!<br>"; 
				}
				if ($.trim($('#cboHIVEducation').combobox('getValue'))=="") { 
					InputError = InputError + "请选择文化程度!<br>"; 
				}
				if ($.trim($('#cboHIVStdHistory').combobox('getValue'))=="") { 
					InputError = InputError + "请选择性病史!<br>"; 
				}
				var HIVDigSureDate=$('#dtHIVDigSureDate').datebox('getValue')
				if (HIVDigSureDate=="") { 
					InputError = InputError + "请选择确诊日期!<br>"; 
				}
				if(Common_CompareDate(HIVDigSureDate,thisNowDate)>0){
					InputError = InputError + "确诊日期不能大于当前日期!<br>"; 
				}
				if (Common_CheckboxValue('chkHIVDiaTypeList')=="") { 
					InputError = InputError + "请选择疾病名称!<br>"; 
				}
				
			    var HIVDiaTypeCode = Common_CheckboxValue('chkHIVDiaTypeList');
				objHIVDiaType = obj.DicManage('EpdSexDiaType',HIVDiaTypeCode);
               	
				if (Common_CheckboxValue('chkHIVDiaTypeList')!="") { 
					var DiaTypeList = "";				
					var HIVDiaTypeList = Common_CheckboxValue('chkHIVDiaTypeList');
					for (var i = 0; i < HIVDiaTypeList.split(",").length; i++) {
						var HIVDiaTypeCode = HIVDiaTypeList.split(",")[i];
						objHIVDiaType = obj.DicManage('EpdSexDiaType',HIVDiaTypeCode); 
						var HIVDiaType = objHIVDiaType.Description;
						DiaTypeList += HIVDiaType +",";
					}
					if (($.trim(DiaTypeList).indexOf('梅毒') > -1)&&(Common_RadioValue('radHIVSexPeriodList')=="")) { 
						InputError = InputError + "请选择梅毒分期!<br>"; 
					}
					if (($.trim(DiaTypeList).indexOf('衣原体')> -1)&&(Common_RadioValue('radHIVTrachomaInfList')=="")) { 
						InputError = InputError + "请选择衣原体感染类型!<br>"; 
					}
			    }
				if (($('#chk-HIVDrugHistory').checkbox('getValue')=="") 
					&&($('#chk-HIVUnmarHistory').checkbox('getValue')=="")
					&&($('#chk-HIVFixedCom').checkbox('getValue')=="") 
					&&($('#chk-HIVMSMHistory').checkbox('getValue')=="")
					&&($('#chk-HIVBloodDona').checkbox('getValue')=="") 
					&&($('#chk-HIVBloodTran').checkbox('getValue')=="")
					&&($('#chk-HIVMotherPose').checkbox('getValue')=="") 
					&&($('#chk-HIVExposure').checkbox('getValue')=="") 
					&&($('#chk-HIVOperation').checkbox('getValue')=="") 
					&&($('#chk-HIVQtResume').checkbox('getValue')=="")  
					&& ($('#txt-HIVQtResume').val()=="")
					&&($('#chk-HIVUnknown').checkbox('getValue')=="")) { 
					
					InputError = InputError + "请选择接触史!<br>"; 
				}
				
				if (($('#chk-HIVDrugHistory').checkbox('getValue')!="")&&($('#num-HIVInjection').val()=="")){
					InputError = InputError + "请填写注射器共用情况!<br>"; 
				}
				if (($('#chk-HIVUnmarHistory').checkbox('getValue')!="")&&($('#num-HIVUnmarried').val()=="")){
					InputError = InputError + "请填写非婚性行为情况!<br>"; 
				}
				if (($('#chk-HIVMSMHistory').checkbox('getValue')!="")&&($('#num-HIVMSM').val()=="")){
					InputError = InputError + "请填写同性性行为情况!<br>"; 
				}
				if (($('#chk-HIVQtResume').checkbox('getValue')!="")&&($('#num-HIVQtResume').val()=="")){
					InputError = InputError + "请填写其他接触史详细情况!<br>"; 
				}
				
				if (Common_RadioValue('radHIVPobSourceList')=="") { 
					InputError = InputError + "请选择最可能的感染途径!<br>"; 
				}
				if (Common_RadioValue('radHIVSimSourceList')=="") { 
					InputError = InputError + "请选择检测样本来源!<br>"; 
				}
				if ($('#cboHIVTestResult').combobox('getValue')=="") { 
					InputError = InputError + "请选择实验室检测结论!<br>"; 
				}
				var HIVResultDate=$('#dtHIVResultDate').datebox('getValue')
				if (HIVResultDate=="") { 
					InputError = InputError + "请选择确认(替代策略)检测阳性日期!<br>"; 
				}
				if(Common_CompareDate(HIVResultDate,thisNowDate)>0){
					InputError = InputError + "确认(替代策略)检测阳性日期不能大于当前日期!<br>"; 
				}
				if ($('#txtHIVTestCompany').val()=="") {     
					InputError = InputError + "请填写确认(替代策略)检测单位!<br>"; 
				}
				
			} else if (CardType=='STD') {
				if ($.trim($('#cboSTDMarriage').combobox('getValue'))=="") { 
					InputError = InputError + "请选择婚姻状况!<br>"; 
				}
				if ($.trim($('#cboSTDEducation').combobox('getValue'))=="") { 
					InputError = InputError + "请选择文化程度!<br>"; 
				}
				if ($.trim($('#cboSTDStdHistory').combobox('getValue'))=="") { 
					InputError = InputError + "请选择性病史!<br>"; 
				}
				if ($('#dtSTDDigSureDate').datebox('getValue')=="") { 
					InputError = InputError + "请选择确诊日期!<br>"; 
				}
				if (Common_CheckboxValue('chkSTDDiaTypeList')=="") { 
					InputError = InputError + "请选择疾病名称!<br>"; 
				}

				if (($('#chk-STDDrugHistory').checkbox('getValue')=="") 
					&&($('#chk-STDUnmarHistory').checkbox('getValue')=="")
					&&($('#chk-STDFixedCom').checkbox('getValue')=="") 
					&&($('#chk-STDMSMHistory').checkbox('getValue')=="")
					&&($('#chk-STDBloodDona').checkbox('getValue')=="") 
					&&($('#chk-STDBloodTran').checkbox('getValue')=="")
					&&($('#chk-STDMotherPose').checkbox('getValue')=="") 
					&&($('#chk-STDExposure').checkbox('getValue')=="") 
					&&($('#chk-STDOperation').checkbox('getValue')=="") 
					&&($('#chk-STDQtResume').checkbox('getValue')=="")  
					&& ($('#txt-STDQtResume').val()=="")
					&&($('#chk-STDUnknown').checkbox('getValue')=="")) { 
					
					InputError = InputError + "请选择接触史!<br>"; 
				}
				
				if (($('#chk-STDDrugHistory').checkbox('getValue')!="")&&($('#num-STDInjection').val()=="")){
					InputError = InputError + "请填写注射器共用情况!<br>"; 
				}
				if (($('#chk-STDUnmarHistory').checkbox('getValue')!="")&&($('#num-STDUnmarried').val()=="")){
					InputError = InputError + "请填写非婚性行为情况!<br>"; 
				}
				if (($('#chk-STDMSMHistory').checkbox('getValue')!="")&&($('#num-STDMSM').val()=="")){
					InputError = InputError + "请填写同性性行为情况!<br>"; 
				}
				if (($('#chk-STDQtResume').checkbox('getValue')!="")&&($('#num-STDQtResume').val()=="")){
					InputError = InputError + "请填写其他接触史详细情况!<br>"; 
				}
				
				if (Common_RadioValue('radSTDPobSourceList')=="") { 
					InputError = InputError + "请选择最可能的感染途径!<br>"; 
				}
				if (Common_RadioValue('radSTDSimSourceList')=="") { 
					InputError = InputError + "请选择检测样本来!<br>"; 
				}
				if ($.trim($('#cboSTDTestResult').combobox('getValue'))=="") { 
					InputError = InputError + "请选择实验室检测结论!<br>"; 
				}
				if ($('#dtSTDResultDate').datebox('getValue')=="") { 
					InputError = InputError + "请选择确认(替代策略)检测阳性日期!<br>"; 
				}
				if ($.trim($('#txtSTDTestCompany').val())=="") {     
					InputError = InputError + "请填写确认(替代策略)检测单位!<br>"; 
				}
				if (Common_CheckboxValue('chkSTDDiaTypeList')!="") { 
					var DiaTypeList = "";				
					var STDDiaTypeList = Common_CheckboxValue('chkSTDDiaTypeList');
					
					for (var j = 0; j < STDDiaTypeList.split(",").length; j++) {
						var STDDiaTypeCode = STDDiaTypeList.split(",")[j];
						objSTDDiaType = obj.DicManage('EpdSexDiaType',STDDiaTypeCode); 
						var STDDiaType = objSTDDiaType.Description;
						DiaTypeList += STDDiaType +",";
					}
					
					if (($.trim(DiaTypeList)!="")&&(DiaTypeList.indexOf('梅毒') > -1)&&(Common_RadioValue('radSTDSexPeriodList')=="")) { 
						InputError = InputError + "请选择梅毒分期!<br>"; 
					}
					if (($.trim(STDDiaType)!="")&&(STDDiaType.indexOf('衣原体')> -1)&&(Common_RadioValue('radSTDTrachomaInfList')=="")) { 
						InputError = InputError + "请选择衣原体感染类型!<br>"; 
					}
				
					if (Common_RadioValue('radSTDLabResultList') =="") { 
						InputError = InputError + "请选择梅毒实验室检测方法RPR/TRUST定性结果!<br>"; 
					}
					if (Common_RadioValue('radSTDLabResultList') !="") { 
						var  LabResult = obj.DicManage('EpdSexLabResult',Common_RadioValue('radSTDLabResultList')).Description;
						if ((($.trim(LabResult!=""))&&(LabResult.indexOf('未做')<0))&&(($('#chk-STDUnDo').checkbox('getValue')=="")&&($('#num-STDDt').val() =="" ))) { 
							InputError = InputError + "请填写梅毒实验室检测方法RPR/TRUST定性滴度!<br>"; 
						}
					}
					if (Common_RadioValue('radSTDTPResultList') =="") { 
						InputError = InputError + "请填写梅毒实验室检测方法TP暗视野镜检结果!<br>"; 
					}
					if (Common_RadioValue('radSTDTPHAResultList') =="") { 
						InputError = InputError + "请填写梅毒实验室检测方法TPPA/TPHA结果!<br>"; 
					}
					if (Common_RadioValue('radSTDELISAResultList') =="") { 	
						InputError = InputError + "请填写梅毒实验室检测方法TP-ELISA结果!<br>"; 
					}
					if (($('#txt-STDQtTest').val() !="" )&&(Common_RadioValue('radSTDQTResultList') =="")) { 
						InputError = InputError + "请填写梅毒实验室检测方法其它检测方法结果!<br>"; 
					}
					if (obj.objCurrPatient.Age <= new Number($.trim(ServerObj.EpdRepPatRelRequireMaxAge))) {
						if (Common_RadioValue('radSTDMLabResultList') =="") { 
							InputError = InputError + "请选择患儿生母梅毒实验室检测方法RPR/TRUST定性结果!<br>"; 
						}
						if (Common_RadioValue('radSTDMLabResultList') !="") { 
							var  MLabResult = obj.DicManage('EpdSexLabResult',Common_RadioValue('radSTDMTPResultList')).Description;
							if ((($.trim(MLabResult!=""))&&(MLabResult.indexOf('未做')<0))&&(($('#chk-STDMUnDo').checkbox('getValue')=="")&&($('#num-STDMDt').val() =="" ))) { 
								InputError = InputError + "请填写患儿生母梅毒实验室检测方法RPR/TRUST定性滴度!<br>"; 
							}
						}
						if (Common_RadioValue('radSTDMTPResultList') =="") { 
							InputError = InputError + "请填写患儿生母梅毒实验室检测方法TP暗视野镜检!<br>"; 
						}
						if (Common_RadioValue('radSTDMTPHAResultList') =="") { 
							InputError = InputError + "请填写患儿生母梅毒实验室检测方法TPPA/TPHA!<br>"; 
						}
						if (Common_RadioValue('radSTDMELISAResultList') =="") { 
							InputError = InputError + "请填写患儿生母梅毒实验室检测方法TP-ELISA!<br>"; 
						}
						if (($('#txt-STDMQtTest').val() !="" ) &&(Common_RadioValue('radSTDMQTResultList') =="")) { 
							InputError = InputError + "请填写患儿生母梅毒实验室检测方法其它检测方法结果!<br>"; 
						}
					}
					if (Common_RadioValue('radSTDHaveList') =="" ) {
						InputError = InputError + "请选择梅毒临床表现!<br>"; 						
					}
					if (Common_RadioValue('radSTDHaveList') !="" ) {
						var HaveList = obj.DicManage('EpdemicHave',Common_RadioValue('radSTDHaveList')).Description;
						if  ($.trim(HaveList!="")&&(HaveList.indexOf('有')>-1)) {
							if (Common_CheckboxValue('chkSTDSymbolList') =="" ) { 
								InputError = InputError + "请选择梅毒临床具体表现!<br>"; 	
							}
							if (Common_CheckboxValue('chkSTDSymbolList') !="" ) {
								var SymbolList = "";				
								var STDSymbolList = Common_CheckboxValue('chkSTDSymbolList');
								for (var i = 0; i < STDSymbolList.split(",").length; i++) {
									var Symbol = STDSymbolList.split(",")[i];
									objSymbol = obj.DicManage('EpdSexSymbolLst2',Symbol); 
									var HIVDiaType = objSymbol.Description;
									SymbolList += HIVDiaType +",";
								}
								if ($.trim(SymbolList!="")&&(SymbolList.indexOf('其他')>-1)&&($('#txt-STDQtSymbol').val() =="")) {	
									InputError = InputError + "请选择梅毒临床其他表现!<br>"; 
								}
							}
						}
					}
				}
					
			}
		}
		if ($.trim(InputError)) {
			$.messager.alert("提示", InputError, 'info');
			return false;
		}
		return true;
	};

	// 获取传染病上报的主卡字符串
	obj.SaveToString = function(objReport, RepStatus) {
		var strSysDateTime=obj.LoadSysDateTime();
		var tmpList=strSysDateTime.split(" ");
		
		strReport = objReport ? objReport.split('^'):'';
		var strDelimiter = String.fromCharCode(1);
		var strTmp = "";
		if(RepStatus!=3) {  //非订正报告
			strTmp = (strReport ? strReport[0] : "") + strDelimiter;
		}else {  //订正报告
			strTmp = '' + strDelimiter;
		}
		strTmp += (strReport ? strReport[1] : PatientID) + strDelimiter;  // PatientID
		strTmp += $.trim($('#cboRegion').combobox('getValue')) + strDelimiter;

		strTmp += $.trim($('#cboOccupation').combobox('getValue')) + strDelimiter;
		strTmp += $('#txtRelationName').val() + strDelimiter;
		strTmp += $.trim($('#cboDisease').combobox('getValue')) + strDelimiter;
		strTmp += $.trim($('#cboIntimate').combobox('getValue')) + strDelimiter;
		
		var InfDicStr = obj.LoadEpdInfection($('#cboDisease').combobox('getValue'),'');
		var MIFKind = InfDicStr.split('^')[3];
		strTmp += MIFKind + strDelimiter; // DiagnoseType
		strTmp += $('#dtSickDate').datebox('getValue') + strDelimiter;
		strTmp += $.trim($('#cboDegree').combobox('getValue')) + strDelimiter;
		strTmp += $('#dtDiagnoseDate').datetimebox('getValue') + strDelimiter;
		strTmp += $.trim($('#cboSickKind').combobox('getValue')) + strDelimiter;
		strTmp += $('#dtDeadDate').datebox('getValue')+ strDelimiter;
		strTmp += (strReport ? strReport[27].split(CHR_2)[0] : session['LOGON.CTLOCID']) + strDelimiter;    //报告科室

		strTmp += (ServerObj.EpdRepPlaceCode ? ServerObj.EpdRepPlaceCode: '') + strDelimiter;
		strTmp += RepStatus + strDelimiter;
		strTmp += (strReport[30] ? strReport[30].split(CHR_2)[0] : session['LOGON.USERID']) + strDelimiter;  //RepUser
		strTmp += (strReport[31] ? strReport[31] : tmpList[0]) + strDelimiter;       // RepDate
		strTmp += (strReport[32] ? strReport[32] : tmpList[1]) + strDelimiter;       // RepTime
		if (RepStatus==2) { //审核
			strTmp += (strReport[34].split(CHR_2)[0] ? strReport[34].split(CHR_2)[0] : session['LOGON.USERID']) + strDelimiter;    //CheckUser
			strTmp += (strReport[35] ? strReport[35] : tmpList[0]) + strDelimiter;     // CheckDate
			strTmp += (strReport[36] ? strReport[36] : tmpList[1]) + strDelimiter;     // CheckTime
		}else {
			strTmp += (strReport[34] ? strReport[34].split(CHR_2)[0] : '') + strDelimiter;    //CheckUser
			strTmp += (strReport[35] ? strReport[35] : '') + strDelimiter;     // CheckDate
			strTmp += (strReport[36] ? strReport[36] : '') + strDelimiter;     // CheckTime

		}
		strTmp += $.trim($('#txtResumeText').val()) + strDelimiter;
		
		strTmp += (strReport[37] ? strReport[37] : "") + strDelimiter;        // Del reason
		strTmp += (strReport[39] ? strReport[39] : obj.MReportID) + strDelimiter;        // MEPD_Mepd_DR 被订正记录
		strTmp += $.trim($('#txtTel').val()) + strDelimiter;
		strTmp += $.trim($('#txtAddress').val()) + strDelimiter;
		strTmp += $.trim($('#txtCompany').val()) + strDelimiter;
		strTmp += '' + strDelimiter;
		strTmp += (strReport ? strReport[41] : EpisodeID) + strDelimiter;  // 就诊号
		strTmp += (strReport ? strReport[18] : "") + strDelimiter;         // Text2,报告编号
		strTmp += (strReport ? strReport[26] : "N") + strDelimiter;        // 是否上传CDC
		strTmp += $.trim($('#cboProvince').combobox('getValue')) + strDelimiter; // 省
		strTmp += $.trim($('#cboCity').combobox('getValue')) + strDelimiter;     // 市
		strTmp += $.trim($('#cboCounty').combobox('getValue')) + strDelimiter;   // 县
		strTmp += $.trim($('#cboVillage').combobox('getValue')) + strDelimiter;  // 乡
		strTmp += $.trim($('#txtRoad').val()) + strDelimiter;             // 门牌号
		strTmp += (strReport ? strReport[11] : "") + strDelimiter;        // 诊断日期时间
		strTmp += (strReport ? strReport[28].split(CHR_2)[0] : "") + strDelimiter;        // Text3,报告病区
		strTmp += $.trim($('#cboCardType').combobox('getValue')) + strDelimiter;          // Text4
		strTmp += $.trim($('#txtPatCardNo').val()) + strDelimiter;        // Text5
		strTmp += $.trim($('#txtOtherOccupation').val()) + strDelimiter;         // Text6 ,其他人群
		strTmp += $.trim($('#cboSeverity').combobox('getValue')) + strDelimiter;   //临床严重程度
		
		//*******************************************************//
		// 报传染病卡时，对于填写有身份证号码的病人，要求上报时以身份证为准，回写其身份证号、出生日期 
		var PatCardNo = $.trim($('#txtPatCardNo').val());
		var CardType=$('#cboCardType').combobox('getValue');
		if ((PatCardNo)&&(CardType.indexOf('身份证')>-1)) {
			// 如果是幼儿，填写的是监护人身份证，回写身份证会有问题
		}
		//*******************************************************//
		
		return strTmp;
	};
	// 获取传染病上报的子卡字符串
	obj.SaveSubToString = function() {
		var strDelimiter = String.fromCharCode(1);
		var strTmp = "";
	
		var DiseaseID = $('#cboDisease').combobox('getValue');
		var CardItemStr = obj.GetCardItem(DiseaseID);
		if (CardItemStr.length<1) return;
		
		for (var ind=0; ind<CardItemStr.length;ind++) {
			var ItemID   = CardItemStr[ind].ID;
			var ItemCode = CardItemStr[ind].ItemCode;
			if (ItemCode=="") continue;
			if (!IsExist(ItemCode))  continue;  //html中没有的项目不保存
		
			var DataType = CardItemStr[ind].HiddenValueDataType;
			var ItemValue = "";
			
			if (DataType==1) { //文本
				ItemValue = $('#'+ItemCode).val();
			}
			else if (DataType==2) { //数字
				ItemValue = $('#'+ItemCode).numberbox('getValue');
			}
			else if (DataType==3) { //日期
				ItemValue = $('#'+ItemCode).datebox('getValue');
			}
			else if (DataType==4) { //字典
				ItemValue = $('#'+ItemCode).combobox('getValue');
			}
			else if (DataType==5) { //是否（单个checkbox）
				ItemValue = $('#'+ItemCode).checkbox('getValue')? 'Y':'N';
			}
			else if (DataType==6) { //字典多选
				ItemValue = $('#'+ItemCode).combobox('getValues');
			}
			else if (DataType==7) { //单选列表
				ItemValue = Common_RadioValue(ItemCode);
			}
			else if (DataType==8) { //多选列表
				ItemValue = Common_CheckboxValue(ItemCode);
			}
			else if (DataType==9) { //复选框
				ItemValue = $('#'+ItemCode).checkbox('getValue')? '1':'0';
			}
			else{
				 continue;
			}
			
			strRow = "";
			strRow += strDelimiter; // Parref
			strRow += strDelimiter; // Rowid
			strRow += strDelimiter; // childsub
			strRow += ItemValue + strDelimiter; // value
			strRow += ItemID + strDelimiter;   // AppendixItemID
			strRow += ItemCode + strDelimiter; // AppendixItem
			if (strTmp != "") {
				strTmp += String.fromCharCode(2);
			}
			strTmp += strRow;		
		}			
		return strTmp;
	}
    
	// 保存草稿
	obj.btnSaveTmp_click = function() {
		if ($('#cboDisease').combobox('getValue')=="") { 
			$.messager.alert("提示", "请选择诊断!", 'info');
			return;
		}
		var strDescription=$('#btnSaveTmp').linkbutton('options').text;
		obj.ReportID= obj.SaveReport(6,strDescription);
		//推送消息
		var ret = obj.SendNews("S00000018",obj.ReportID,5,EpisodeID);
	}; 
	
	
	// 上报待审
	obj.btnSave_click = function() {
		//报告数据完整性和逻辑性校验
		if (!obj.ValidateContents()) {
			return;
		}
	
		var strDescription=$('#btnSave').linkbutton('options').text;
		obj.SaveReport(1,strDescription);
	
		//推送消息
		var ret = obj.SendNews("S00000018",obj.ReportID,1,EpisodeID);
		
		var result = $m({                  
			ClassName:"DHCMed.EPDService.CasesXSrv",
			MethodName:"IsCasesXByReportID",
			aReportID:obj.ReportID
		},false);
		
		var Flag = result.split('^')[0];
		var CaseXID = result.split('^')[1];
		if (Flag==1) {
			var Hisret = obj.SendNews("S00000040",obj.ReportID,4,EpisodeID);
		}
	};
	
	//管理上报
	obj.btnAdmin_click = function() {
		var InputError = '';
		if ($('#cboDisease').combobox('getValue') == "") {
			InputError = InputError + "请选择传染病诊断!<br>";
		}
		if (InputError != '') {
			$.messager.alert("提示","管理上报报告，" + InputError, 'info');
			return;
		}
		var strDescription=$('#btnAdmin').linkbutton('options').text;
		obj.SaveReport(9,strDescription);
	
	}; 
	//外院已报
	obj.btnOutHospReport_click = function() {
		var InputError = '';
		if ($('#cboDisease').combobox('getValue') == "") {
			InputError = InputError + "请选择传染病诊断!<br>";
		}
		if (InputError != '') {
			$.messager.alert("提示","外院已报报告!" + InputError, 'info');
			return;
		}
		var strDescription=$('#btnOutHospReport').linkbutton('options').text;
		obj.SaveReport(8,strDescription);
	}; 
	
	// 审核
	obj.btnCheck_click = function() {
		$.messager.confirm("审核", "您确定要审核这份传染病报告么？", function (r) {
			if (r){
				//报告数据完整性和逻辑性校验
				if (!obj.ValidateContents()) {
					return;
				}
				var strDescription=$('#btnCheck').linkbutton('options').text;
				obj.SaveReport(2,strDescription);
				var ret = obj.SendNews("S00000018",obj.ReportID,2,EpisodeID);
			}
		});
	};
	
	//取消审核
	obj.btnUpdoCheck_click = function() {
		$.messager.confirm("取消审核", "您确定要取消审核这份传染病报告么？", function (r) {
			if (r){
				var strDescription =$('#btnUpdoCheck').linkbutton('options').text;
				obj.ReportID = obj.SaveReportAA(1,strDescription,"");
				var ret = obj.SendNews("S00000018",obj.ReportID,1,EpisodeID);
			}
		});
	};
	
	// 订正
	obj.btnCorrect_click = function() {
		$.messager.confirm("订正", "您确定要订正这份传染病报告么？", function (r) {
			if (r){
				//报告数据完整性和逻辑性校验
				if (!obj.ValidateContents()) {
					return;
				}
				//保存被订的报告
				var strSysDateTime=obj.LoadSysDateTime();
				var tmpList=strSysDateTime.split(" ");
				var strReportID = obj.UpdateCorrectEPD(obj.ReportID, 4, '');
				if (strReportID <= 0) {
					$.messager.alert("提示","保存被订报告失败！返回值：" + strReportID, 'info');
					return;
				}
				obj.MReportID = strReportID;
				
				//保存订正后的诊断
				var strDescription =$('#btnCorrect').linkbutton('options').text;
				obj.ReportID= obj.SaveReport(3,strDescription);
			
				var ret = obj.SendNews("S00000018",strReportID,6,EpisodeID);//被订
		        var ret = obj.SendNews("S00000018",obj.ReportID,7,EpisodeID);//订正
				ReportID =obj.ReportID
			}
		});
	};
	
	// 退回
	obj.btnReturn_click = function() {
		$.messager.prompt("退回", "请输入退回原因!", function (r) {
			if (r){
				var strDescription = $('#btnReturn').linkbutton('options').text;
				obj.ReportID=obj.SaveReportAA(5,strDescription,r);
	
				var ret = obj.SendNews("S00000018",obj.ReportID,3,EpisodeID);
			}		
		});
	};
	
	// 上报CDC
	obj.btnUpdateCDC_click = function() {
		if (obj.objCurrReport){
			var aOperationDesc = $('#btnUpdateCDC').linkbutton('options').text;
			$.messager.confirm(aOperationDesc, "您是否要将此报告"+aOperationDesc+"？", function (r) {			    
				var strReportID = $m({                  
					ClassName:"DHCMed.EPD.Epidemic",
					MethodName:"UpdateUploadStatus",
					aRepID: obj.objCurrReport.split("^")[0], 
					aStatus: (obj.objCurrReport.split("^")[26] == "N" ? "Y" : "N")
				},false);
			  
				if (strReportID > 0) {
					$.messager.alert("提示",aOperationDesc + "成功！", 'info');				
					obj.DisplayReportInfo(strReportID);		// 根据报告ID显示对应的报告信息
					obj.LoadPatInfo();              		// 根据生成的报告加载病人基本信息
					// 显示当前报告状态下的操作按钮状态
					if (obj.objCurrReport) {
						var arrCurrRep = obj.objCurrReport.split("^");
						var RepStatus =arrCurrRep[33].split(CHR_2)[0];
						var IsUpload =arrCurrRep[26];
						obj.DisplayButtonStatus(LocFlag,RepStatus,IsUpload);
					}	
					var ret = obj.SendNews("S00000018",strReportID,8,EpisodeID);
					var arrCurrRep = obj.objCurrReport.split("^");
					var RepStatus =arrCurrRep[33].split(CHR_2)[0];
					var IsUpload =arrCurrRep[26];
					obj.DisplayButtonStatus(LocFlag,RepStatus,IsUpload);
					
					if (arrCurrRep[26]=="N"){
						$('#btnUpdateCDC').linkbutton({text:'上报CDC'});
					}else{
						$('#btnUpdateCDC').linkbutton({text:'取消上报CDC'});
					}
				} else {
					$.messager.alert("提示",aOperationDesc + "失败！返回值：" + strReportID, 'info');
				}
			});
		}
	};
	
	// 作废
	obj.btnDelete_click = function() {
		$.messager.prompt("作废", "请输入作废此传染病报告原因!", function (r) {
			if (r) {
				var strDescription = $('#btnDelete').linkbutton('options').text;
				
				obj.ReportID=obj.SaveReportAA(7,strDescription,r);
				var ret = obj.SendNews("S00000018",obj.ReportID,4,EpisodeID);
			}
		});
	};
	// 关闭窗口
	obj.btnClose_click = function() {
		//关闭
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	};
	
	// 打印
	obj.btnPrint_click = function() {	
		if (!obj.objCurrReport) {
			$.messager.alert("错误", "请先保存传染病报告！", 'error');
			return;
		} else {
			var CardType = obj.LoadCardType(obj.objCurrReport.split("^")[5].split(CHR_2)[0]);
			PrintDataToExcel(obj.objCurrReport.split("^")[0],CardType,'');
		}
		var reportStatus = obj.objCurrReport.split("^")[33].split(CHR_2)[0];
		if (reportStatus > 4) {
			$.messager.alert("温馨提示", "只能打印“待审”、“已审“、“订正”、“被订”状态的传染病报告!",'info');
			return;
		}
		if ((typeof(IsSecret)!="undefined")&&(IsSecret==1)) {//涉密医院打印时要记录到日志里		
			$m({  // 密级
				ClassName:"DHCMed.SSIO.FromSecSrv",
				MethodName:"GetPatEncryptLevel",
				aPatientID:PatientID,
				ErrMsg:''
			},function(SecretStr){
				if (!SecretStr) return;
				var SecretCode=SecretStr.split('^')[2];
				var ModelName="DHCMedEpdReport";
				var Condition="{ReportID:" +ReportID+"}";
				var Content="{EpisodeID:"+ EpisodeID+",ReportID:"+ ReportID+",ReportStatus:"+ obj.objCurrReport.MEPDStatus+"}";

				var ret= tkMakeServerCall("DHCMed.SSIO.FromSecSrv","EventLog",ModelName,Condition,Content,SecretCode);
			});
		}
	}
	
	 /**
	 * 公用处理函数 - 挂入全部所需监听事件
	 */
	obj.RelationToEvents = function() {
		
		// 按钮触发事件
		$('#btnSaveTmp').on("click", function(){       //保存草稿
			obj.btnSaveTmp_click();
		}); 
		$('#btnSave').on("click", function()  {        //上报待审
			obj.btnSave_click();
		});
		$('#btnCheck').on("click", function(){         //审核
			obj.btnCheck_click();
		});
		$('#btnUpdoCheck').on("click", function(){     //取消审核
			obj.btnUpdoCheck_click();
		});
		$('#btnCorrect').on("click", function(){       //订正
			obj.btnCorrect_click();
		});
		$('#btnReturn').on("click", function(){         //退回
			obj.btnReturn_click();
		});
		$('#btnDelete').on("click", function(){         //作废
			obj.btnDelete_click();
		});
		$('#btnUpdateCDC').on("click", function(){      //上报CDC
			obj.btnUpdateCDC_click();
		});
		$('#btnPrint').on("click", function(){          //打印
			obj.btnPrint_click();
		});
		$('#btnClose').on("click", function(){          //关闭窗口
			obj.btnClose_click();
		});
		$('#btnOutHospReport').on("click", function(){  //外院已报
			obj.btnOutHospReport_click();
		});
		$('#btnAdmin').on("click", function(){     //管理上报
			obj.btnAdmin_click();
		});
		
		//街道失去焦点事件
		$("#txtRoad").keyup(function(){
			var cboProvince = $('#cboProvince').combobox('getText');
			var cboCity = $('#cboCity').combobox('getText');
			var cboCounty = $('#cboCounty').combobox('getText');
			var cboVillage = $('#cboVillage').combobox('getText');
			var txtRoad = $('#txtRoad').val();
			$('#txtAddress').val(cboProvince+cboCity+cboCounty+cboVillage+txtRoad);
		})
	}
	
	 /**
	 * 根据报告状态和权限区分标记显示此报告对应的功能按钮
	 */
	obj.DisplayButtonStatus = function(LocFlag,RepStatus,UploadCode) {
		
		$('#btnSaveTmp').hide();      // 保存草稿按钮
		$('#btnSave').hide();		  // 上报按钮
		$('#btnCheck').hide();	      // 审核按钮
		$('#btnUpdoCheck').hide();	  // 取消审核按钮
		$('#btnCorrect').hide();      // 订正按钮
		$('#btnReturn').hide();	      // 退回按钮
		$('#btnDelete').hide();       // 作废按钮
		$('#btnUpdateCDC').hide();    //上报CDC按钮
		$('#btnPrint').hide();	      // 打印按钮
		$('#btnOutHospReport').hide();  // 外院已报按钮
		$('#btnAdmin').hide();          // 管理上报
		if (PortalFlag != 1) {
			$('#btnClose').show();	    // 关闭窗口按钮 
		} else {
			$('#btnClose').hide();	    // 关闭窗口按钮 
		}
		// 控制按钮权限，如果 LocFlag=1 代表院感办
		if (LocFlag != '0') {
			switch (RepStatus) {
				case "" : // 无报告
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:'草稿'});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'报卡'});
					$('#btnOutHospReport').show();    // 外院已报按钮
					$('#btnAdmin').show();      //  管理上报
					break;
				case "6" : // 草稿
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:'草稿'});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'报卡'});
					$('#btnDelete').show();		// 作废按钮
					$('#btnOutHospReport').show();    // 外院已报按钮
					$('#btnAdmin').show();      //  管理上报
					break;
				case "1" : // 待审
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'修改报卡'});
					$('#btnCheck').show();		// 审核按钮
					$('#btnReturn').show();		// 退回按钮
					$('#btnDelete').show();		// 作废按钮
					$('#btnPrint').show();	    // 打印按钮
					break;
				case "2" : // 已审
					$('#btnUpdoCheck').show();	// 取消审核按钮
					$('#btnCorrect').show();    // 订正按钮
					$('#btnPrint').show();	    // 打印按钮
					$('#btnUpdateCDC').show();  // 上报CDC按钮
					break;
				case "3" : // 订正
					$('#btnCheck').show();		// 审核按钮
					$('#btnCorrect').show();    // 订正按钮
					$('#btnPrint').show();	    // 打印按钮
					break;
				case "4" : // 被订
					$('#btnPrint').show();	    // 打印按钮
					break;
				case "5" : // 退回
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'修改报卡'});
					$('#btnDelete').show();		// 作废按钮
					break;
				case "7" : // 作废
					break;
				case "8" : // 外院已报
					$('#btnDelete').show();		// 作废按钮
					break;
				case "9" : // 管理上报
					$('#btnDelete').show();		// 作废按钮
					break;
			}
		} else {
			// 医生站
			switch (RepStatus) {
				case "" : // 无报告
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:'草稿'});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'报卡'});
					$('#btnOutHospReport').show();    // 外院已报按钮
					break;
				case "6" : // 草稿
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:'草稿'});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'报卡'});
					$('#btnDelete').show();		// 作废按钮
					$('#btnOutHospReport').show();    // 外院已报按钮
					break;
				case "1" : // 待审
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'修改报卡'});
					$('#btnDelete').show();		// 作废按钮
					$('#btnPrint').show();	    // 打印按钮
					break;
				case "2" : // 已审
					$('#btnCorrect').show();    // 订正按钮
					break;
				case "3" : // 订正
					$('#btnCorrect').show();    // 订正按钮
					$('#btnPrint').show();	    // 打印按钮
					break;
				case "4" : // 被订
					break;
				case "5" : // 退回
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'修改报卡'});
					$('#btnDelete').show();		// 作废按钮
					break;
				case "7" : // 作废
					break;
				case "8" : // 外院已报
					$('#btnDelete').show();		// 作废按钮
					break;
			}
		}
		
		//根据状态字典 显示	
		if (ServerObj.EpdSaveTmp==''){
			$('#btnSaveTmp').hide();   // 保存草稿按钮
		}
		if (ServerObj.EpdCorrect==''){
			$('#btnCorrect').hide();   // 订正按钮
		}
		
		if ((RepStatus=='4')||(RepStatus=='7')||(RepStatus=='8')){			
			obj.DisplayComps();
		}
		
		if (UploadCode=="Y"){
			$('#btnSaveTmp').hide();   // 保存草稿按钮
			$('#btnSave').hide();		// 上报按钮
			$('#btnCheck').hide();	    // 审核按钮
			$('#btnUpdoCheck').hide();	// 取消审核按钮
			$('#btnCorrect').hide();   // 订正按钮
			$('#btnReturn').hide();	// 退回按钮
			$('#btnDelete').hide();    // 作废按钮
			$('#btnAdmin').hide();    // 作废按钮
		}
	};
	
	 /**
	 * 显示不可编辑状态
	 */
	obj.DisplayComps = function(){  
		$('#cboOccupation').combobox('disable');   //人群分类
		$('#cboRegion').combobox('disable');       //病人属于
		$('#cboCardType').combobox('disable');     //证件类型
		$('#cboDegree').combobox('disable');       //病例分类
		$('#cboSickKind').combobox('disable');     //发病程度   
		$('#cboIntimate').combobox('disable');     //接触情况
		$('#cboDisease').combobox('disable');       //诊断
		$('#cboSeverity').combobox('disable');     //临床严重程度     add 20200203
		$('#cboProvince').combobox('disable');      //省
		$('#cboCity').combobox('disable');          //市
		$('#cboCounty').combobox('disable');        //县
		$('#cboVillage').combobox('disable');       //乡
		
	    $('#txtPatCardNo').attr('disabled','disabled'); 
		$('#txtTel').attr('disabled','disabled'); 
		$('#txtRelationName').attr('disabled','disabled'); 
		$('#txtCompany').attr('disabled','disabled'); 
		$('#txtRoad').attr('disabled','disabled'); 
		$('#txtAddress').attr('disabled','disabled'); 
		$('#txtResumeText').attr('disabled','disabled');
		$('#dtSickDate').datebox('disable');  
		$('#dtDiagnoseDate').datebox('disable');
		$('#dtDeadDate').datebox('disable');
		
		//附卡置无效
		if (!obj.objCurrReport) return;
		var arrCurrRep = obj.objCurrReport.split("^");
		var DiseaseID = arrCurrRep[5].split(CHR_2)[0];
		var CardItemStr = obj.GetCardItem(DiseaseID);
		if (CardItemStr.length<1) return;
		for (var ind=0; ind<CardItemStr.length;ind++) {
			var ItemID   = CardItemStr[ind].ID;
			var ItemCode = CardItemStr[ind].ItemCode;
			if (ItemCode=="") continue;
			var DataType = CardItemStr[ind].HiddenValueDataType;
			var ItemValue = "";
			
			if ((DataType==1)||(DataType==2)) { // 文本、数字
				$('#'+ItemCode).attr('disabled','disabled');
			}
			else if (DataType==3) { //日期
				$('#'+ItemCode).datebox('disable');
			}
			else if ((DataType==4)||(DataType==6)) { //字典、字典多选
				$('#'+ItemCode).combobox('disable');
			}
			else if ((DataType==5)||(DataType==8)||(DataType==9)) { //是否、多选列表、复选框
				$('#'+ItemCode).checkbox('disable');
			}
			else if (DataType==7) { //单选列表
				$('#'+ItemCode).radio('disable');
			}
		}
	}
	
	//判断某一元素在加载的html中是否存在
	function IsExist(obj) {
		if ($('#'+obj).length > 0) {
			return 1;
		}else {
			return 0;
		}
	}
}