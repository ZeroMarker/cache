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
	// 获取基础字典项
	obj.GetDictionaryInfo = function (aTypeInfo) {
		var DictionaryInfo = $cm({
			ClassName:"DHCMed.SSService.DictionarySrv",
			QueryName:"QryDictionary",
			ResultSetType:'array',
			aType:aTypeInfo
		},false);
		return DictionaryInfo;
	}
	
	
	
	// 字符串全角字符转半角字符
	obj.FullCharTohalfChar = function (aInputString) {
		var result = '';
	    for (var i = 0; i < aInputString.length; i++) {
	        //获取当前字符的unicode编码
	        var StrCode = aInputString.charCodeAt(i);
	        //unicode编码范围是所有的英文字母以及各种字符
	        if (StrCode >= 65281 && StrCode <= 65373) {
	            //把全角字符的unicode编码转换为对应半角字符的unicode码
	            result += String.fromCharCode(aInputString.charCodeAt(i) - 65248);
	        } else if (StrCode == 12288) {//空格
	            result += String.fromCharCode(aInputString.charCodeAt(i) - 12288 + 32);
	        } else {//原字符返回
	            result += aInputString.charAt(i);
	        }
	    }
	    return result;
	}
	
	
	
	//弹出加载层
	function loadingWindow() {
	    var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#EPDReport"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html($g("数据加载中,请稍候...")).appendTo("#EPDReport").css({ display: "block", left: left, top: top }); 
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
					
					if (Occupation.indexOf($g("其他"))>-1) {
						$('#trOtherOccupation').removeAttr("style");
						$('#lblCardNotice').attr("style","display:none");  
					}	
					var IsUpload =arrCurrRep[26];
					obj.DisplayButtonStatus(LocFlag,RepStatus,IsUpload);		
					if (arrCurrRep[26]=="N"){
						$('#btnUpdateCDC').linkbutton({text:$g('上报CDC')});
					}else{
						$('#btnUpdateCDC').linkbutton({text:$g('取消上报CDC')});
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
		
		// 是否显示传染病报告时间
		if (obj.ReportID) {
			if (ServerObj.EpdRepDateDisplay=='1'){
				$(".RepDate-td").show();
			}else if ((LocFlag=='1')&&(ServerObj.EpdRepDateDisplay=='2' || ServerObj.EpdRepDateDisplay=='' || typeof ServerObj.EpdRepDateDisplay == 'undefined')){
				$(".RepDate-td").show();
			}
		}
		// 允许管理科室修改报告日期
		if((ServerObj.EpdRepDateModify=='1')&&(LocFlag != '0')){
			$('#dtRepDate').datebox('enable');
		}
		
		// Lodop打印
		$('#btnPrintLodop, #btnPrintLodopMain, #btnPrintLodopSub').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintDHCMAEPDReport");		//打印任务的名称
			LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
			LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
			LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)

			if($(this).text().indexOf($g('报告'))>-1){
				LodopPrintURL(LODOP,"dhcma.epd.lodopprint.csp?ReportID="+obj.ReportID);
			}
			if ($(this).text().indexOf($g('附卡'))>-1){
				var CardType = obj.LoadCardType(obj.objCurrReport.split("^")[5].split(CHR_2)[0]);
				if (CardType) {
					LODOP.NewPage();
					if(CardType=="HIV"){
						LodopPrintURL(LODOP,"dhcma.epd.lodophiv.csp?ReportID="+obj.ReportID);
					}
					if(CardType=="STD"){
						LodopPrintURL(LODOP,"dhcma.epd.lodopstd.csp?ReportID="+obj.ReportID);
					}
					if(CardType=="HBV"){
						LodopPrintURL(LODOP,"dhcma.epd.lodophbv.csp?ReportID="+obj.ReportID);
					}
				}
			}
			// LODOP.PREVIEW();		//预览打印
			LODOP.PRINT();			//直接打印

			obj.SaveEPDLogInfo("",$(this).text());

		});
		// 处理备注全角字符转半角字符
		$('#txtResumeText').bind('input propertychange',function(){
		    let inputValue = $('#txtResumeText').val();
		    inputValue = obj.FullCharTohalfChar(inputValue);
		    $('#txtResumeText').val(inputValue);
		})
	}
	/*改变状态的时候，保存日志*/
	obj.SaveEPDLogInfo = function(aRepStatus,aText) {
		// 保存传染病打印日志
		var ret = $m({
			ClassName:"DHCMed.EPD.EpidemicLog",
			MethodName:"Update",
			aInputStr:"^"+obj.ReportID+"^"+aRepStatus+"^"+session['LOGON.CTLOCID']+"^^^"+session['LOGON.USERID']+"^^"+EpisodeID+"^^"+aText,
			aSeparete:"^",
		},false);
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
		var EncryptLevelDesc= EpdPatInfo[19];
		
		$('#PatientName').text(PatientName);			
		$('#PapmiNo').text(PapmiNo);
		$('#InPatientMrNo').text(MrNo);		
		$('#Birthday').text(Birthday);
		$('#Age').text(Age);
		$('#PatSex').text(Sex);
		if (Sex == '女') {
			$('#Sex').removeClass('man').addClass('woman');		
		} else if(Sex == '男')  {
			$('#Sex').removeClass('woman').addClass('man');
		} else{
			$('#Sex').removeClass('man').removeClass('woman').addClass('unknowgender');
		}
		if (!ReportID) {
	    	$('#cboCardType').combobox('setValue',(CardType ? CardTypeCode:''));
	    	$('#cboCardType').combobox('setText',(CardType ? CardType:''));					
			$('#txtPatCardNo').val(PatCardNo);
		}
		if (EncryptLevel =='' && PatLevel =='') {
			$('#PatEncryptLevelSpan').css('display','none');
		}
	    $('#EncryptLevel').text(EncryptLevelDesc);
		$('#PatLevel').text(PatLevel);
		var RepPlace = obj.objCurrRepPlace ? obj.objCurrRepPlace.Description : '';
		$('#RepPlace').text(RepPlace);	
		//$('#RepUser').text(session['LOGON.USERNAME']);
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
	
		var PatAge = ServerObj.EpdPatInfo.split('^')[4];
		var PatientName = $('#PatientName').text();
		
		if (PatAge.indexOf("岁")>-1){
			var PatAgeInfo = PatAge.split('岁')[0].toString();
			if (PatAgeInfo <= parseInt(ServerObj.EpdRepPatRelRequireMaxAge)) {  // 增加条件判断，如果年龄小于等于14，需要带亲属姓名，14岁以上设为空
				if(PatientName==obj.objCurrPatient.RelativeName){
					$('#txtRelationName').val("");	//家长姓名
				}else{
					$('#txtRelationName').val(obj.objCurrPatient.RelativeName);	//家长姓名
				}
			}else{
				$('#txtRelationName').val("");	//家长姓名
			}
		}else if(PatAge==""){
			$('#txtRelationName').val("");	//家长姓名
		}else{
			if(PatientName==obj.objCurrPatient.RelativeName){
				$('#txtRelationName').val("");	//家长姓名
			}else{
				$('#txtRelationName').val(obj.objCurrPatient.RelativeName);	//家长姓名
			}
		}
		if (ServerObj.CurrAddress){
			var arrCurrAdd 		= ServerObj.CurrAddress.split("`");
			var CurrProvinceID 	= arrCurrAdd[0].split('^')[0];
			var CurrProvinceDesc= arrCurrAdd[0].split('^')[1];
			var CurrCityID 		= arrCurrAdd[1].split('^')[0];
			var CurrCityDesc	= arrCurrAdd[1].split('^')[1];
			var CurrCountyID 	= arrCurrAdd[2].split('^')[0];
			var CurrCountyDesc	= arrCurrAdd[2].split('^')[1];
			var CurrVillageID 	= arrCurrAdd[3].split('^')[0];
			var CurrVillageDesc	= arrCurrAdd[3].split('^')[1];
			$('#cboProvince').combobox('setValue',CurrProvinceID);
			$('#cboProvince').combobox('setText',CurrProvinceDesc);
			$('#cboCity').combobox('setValue',CurrCityID);
			$('#cboCity').combobox('setText',CurrCityDesc);
			$('#cboCounty').combobox('setValue',CurrCountyID);
			$('#cboCounty').combobox('setText',CurrCountyDesc);
			$('#cboVillage').combobox('setValue',CurrVillageID);
			$('#cboVillage').combobox('setText',CurrVillageDesc);
		}else if (ServerObj.EpdInitAddressByLocalHospital) {
			// 当HIS建卡中的现住址为空时,传染病报卡默认初始化加载当地医院所在的省、市、县三级
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
		}
		$('#txtAddress').val(ServerObj.PatCurrAddress);
		if (session['LOGON.LANGCODE']=="EN"){
			$('#txtAddress').val($('#cboProvince').combobox('getText')+$('#cboCity').combobox('getText')+$('#cboCounty').combobox('getText')+$('#cboVillage').combobox('getText'));
		}
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
		$('#dtDiagnoseDate').datetimebox('setValue', obj.LoadSysDateTime());
		// 报告日期默认为当天
		$('#dtRepDate').datetimebox('setValue', obj.LoadSysDateTime());
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
	    $('#RepWard').text(arrCurrRep[28].split(CHR_2)[1]);
	    $('#RepLoc').text(arrCurrRep[27].split(CHR_2)[1]);
	    $('#RepPlace').text(arrCurrRep[29].split(CHR_2)[1]);
	    $('#RepUser').text(arrCurrRep[30].split(CHR_2)[1]);
		
		$('#txtTel').val(arrCurrRep[17]);		        //联系电话
		$('#txtCompany').val(arrCurrRep[14]);		    //工作单位
		$('#txtRelationName').val(arrCurrRep[4]);	    //家长姓名
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
		$('#txtAddress').val(arrCurrRep[15]);			//现住址
		
		$('#cboIsInEPD').combobox('setValue',arrCurrRep[43].split(CHR_2)[0]);
		$('#cboIsInEPD').combobox('setText',arrCurrRep[43].split(CHR_2)[1]);
		$('#txtContr').val(arrCurrRep[44]);
		// 加载诊断
		$('#cboDisease').combobox('setValue',arrCurrRep[5].split(CHR_2)[0]);
		$('#cboDisease').combobox('setText',arrCurrRep[5].split(CHR_2)[1]);
		// 加载临床严重程度 add 20200203
		if (arrCurrRep[5].split(CHR_2)[1].indexOf($g("新型冠状"))>-1) {
			$('#cboSeverity').combobox('enable');        
			$('#cboSeverity').combobox('setValue',arrCurrRep[42].split(CHR_2)[0]);
			$('#cboSeverity').combobox('setText',arrCurrRep[42].split(CHR_2)[1]);
		} else {
	        $('#cboSeverity').combobox('disable');         //临床严重程度默认不可选 add 20200203
			$('#cboSeverity').combobox('clear');
        }
        if ((arrCurrRep[5].split(CHR_2)[1]==$g("乙型病毒性肝炎"))||(arrCurrRep[5].split(CHR_2)[1]==$g("丙型病毒性肝炎"))||(arrCurrRep[5].split(CHR_2)[1]==$g("血吸虫病"))||(arrCurrRep[5].split(CHR_2)[1]==$g("其它"))) {
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
		// 报告日期
		$('#dtRepDate').datetimebox('setValue', arrCurrRep[31]+' '+ arrCurrRep[32] );
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
      else if (CardType=='AFP') {
				$('#AFPInfoDIV').attr("style","display:true"); //显示AFP附卡div
			} else if (CardType=='HFMD') {
				$('#HFMDInfoDIV').attr("style","display:true"); //显示HFMD附卡div
			} 
		}else {
			//没有附卡时改变打印按钮状态
			$('#btnPrintLodop .menu-text').text('打印报告');
			$('#btnPrintLodopMain').hide();
			$('#btnPrintLodopSub').hide();
			$('#btnPrintTypes').css('height','');	//改变菜单按钮高度
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
			}
			else if (ItemType==10) { //省市县乡
				$('#'+ItemCode).combobox('setValue',HiddenValue);
				$('#'+ItemCode).combobox('setText',ItemValue);
			} else {
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
			$.messager.alert($g("提示"), aOperationDesc + $g("成功！"), 'info');
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
					if (DetailsId!=""){
						// 消息明细ID不为空时，保存成功回调消息处理接口
						// 关闭消息弹出窗口方法
						$(function() {
							window.close();
							top.HideExecMsgWin();
						});
						/// 执行所有相关消息
						$(function(){
							tkMakeServerCall("websys.DHCMessageInterface","ExecAll",DetailsId) 
						});
					}
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
			$.messager.alert($g("提示"), aOperationDesc + $g("成功！"), 'info');
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
			$.messager.alert($g("提示"), aOperationDesc + $g("失败！返回值：") + strReportID, 'info');
		}
		return obj.ReportID;
	}
	// 数据校验函数
	obj.ValidateContents = function() {
		
		var InputError = "";
		if ($.trim($('#cboOccupation').combobox('getValue')) == "") {
			InputError = InputError + $g("请选择人群分类!")+"<br>";
		}
		if ($.trim($('#cboRegion').combobox('getValue')) == "") {
			InputError = InputError + $g("请选择病人属于!")+"<br>";
		}	
		if ($.trim($('#txtTel').val()) == "") {
			InputError = InputError + $g("请填写联系电话!")+"<br>";
		}
		if (($.trim($('#txtRelationName').val())== "") && (obj.objCurrPatient.Age <= new Number($.trim(ServerObj.EpdRepPatRelRequireMaxAge)))) {
			InputError = InputError + $g("年龄小于等于") + new Number($.trim(ServerObj.EpdRepPatRelRequireMaxAge)) + $g("岁的患者必需填写家长姓名!)"+"<br>");
		}
		if ($.trim($('#cboOccupation').combobox('getText')).indexOf("其他")>-1) {
			if ($.trim($('#txtOtherOccupation').val())==""){
				InputError = InputError + $g("请填写其他人群!")+"<br>";
			}
		}
		//职业为幼托儿童,散居儿童,必须填写家长姓名
		var arrayEpdOccupationToRelName = ServerObj.EpdOccupationToRelName.split("`");
		if ($.trim($('#txtRelationName').val()) == "") {
			for (var i = 0; i < arrayEpdOccupationToRelName.length; i++) {
				if ($('#cboOccupation').combobox('getText') == arrayEpdOccupationToRelName[i]) {
					InputError = InputError + $g("患者人群分类是：") +$('#cboOccupation').combobox('getText') + $g("，请填写家长姓名!")+"<br>";
				}
			}
		}
		
		//家长姓名的首位不能为数字，且不能包含特殊字符
		var txtRelationName = $.trim($('#txtRelationName').val());
		if (txtRelationName != "") {
			if (txtRelationName.length > 20) {
			    InputError = InputError + $g("家长姓名最长为20个字!")+"<br>";
			}
			if(/^[0-9]+|^[0-9]*$|[-_@#%^&*()（），。、',：:;=?$<>《》\/\x22]+/.test(txtRelationName)) {
			    InputError = InputError + $g("家长姓名的首位不能为数字，且不能包含特殊字符!")+"<br>";
			 }
		}
		
		//8岁以下人群分类只能填写“幼托儿童”、“散居儿童”、“学生”等
		var Occupation=$('#cboOccupation').combobox('getText');
		if (obj.objCurrPatient.Age <=8){
			if ((Occupation!="幼托儿童")&&(Occupation!="散居儿童")&&(Occupation!="学生（大中小学）")){
				InputError = InputError + $g("年龄小于等于8岁的患者，人群分类必需填写幼托“幼托儿童”、“散居儿童”、“学生（大中小学）”!")+"<br>";
			}
		}


		// 职业为幼托儿童,学生(大中小学生),工作单位不能填无，必须填写学校(幼儿园)、年级、班级 
		var arrayEpdOccupationToCompany = ServerObj.EpdOccupationToCompany.split("`");
		if ($.trim($('#txtCompany').val()) == "无") {
			for (var i = 0; i < arrayEpdOccupationToCompany.length; i++) {
				if ($('#cboOccupation').combobox('getText') == arrayEpdOccupationToCompany[i]) {
					InputError = InputError + $g("患者人群分类是：") + $('#cboOccupation').combobox('getText') + $g("，请填写学校(幼儿园)、年级、班级!")+"<br>";
				}
			}
		}
		// 判断如果工作单位为空或者为非法字符等,则不允许上报
		if (($.trim($('#txtCompany').val()) == "") || ($.trim($('#txtCompany').val()) == "\\") || ($.trim($('#txtCompany').val()) == "\/")) {
			InputError = InputError + $g("患者工作单位(学校)：请填写工作单位，没有工作单位请填“无”，学生请填写学校、年级、班级!")+"<br>";
		}
	
		if ($.trim($('#txtAddress').val()) == "") {
			InputError = InputError + $g("请填写现住址!")+"<br>";
		}
		
		if ($.trim($('#cboDisease').combobox('getValue')) == "") {
			InputError = InputError + $g("请选择传染病诊断!")+"<br>";
		}
		
		var DiseaseDesc = $('#cboDisease').combobox('getText');
		var SickKind = $('#cboSickKind').combobox('getText');
		var DegreeDesc = $('#cboDegree').combobox('getText');
  		//add 20200203
        if ((DiseaseDesc.indexOf($g("新型冠状"))>-1)&&($.trim($('#cboSeverity').combobox('getValue')) == "")) {
        	InputError = InputError + "当传染病诊断为新型冠状病毒感染时，临床严重程度不允许为空!<br>";
        }
		
		if ((DiseaseDesc.indexOf($g("新型冠状"))>-1)&&($.trim($('#cboIsInEPD').combobox('getValue')) == "")) {
			InputError = InputError + $g("当传染病诊断为新型冠状病毒感染时，请选择是否为境外输入病例!")+"<br>";
		}
		if (($.trim($('#cboIsInEPD').combobox('getText')) =="是") &&($.trim($('#txtContr').val())=="")) {
			InputError = InputError + $g("境外输入病例请填写入境前居住或旅行的国家或地区!")+"<br>";
		}
		// 如果诊断属于“乙肝、丙肝、血吸虫”，则“发病程度”必选“急性 、慢性
		var arrayEpdDiseaseToSickKind=ServerObj.EpdDiseaseToSickKind.split("///");
		for (var i = 0; i < arrayEpdDiseaseToSickKind.length; i++) {
			var arrsubEpdDiseaseToSickKind=arrayEpdDiseaseToSickKind[i].split("~");
			var arrchildEpdDiseaseToSickKind=arrsubEpdDiseaseToSickKind[0].split("`");
			for (var j = 0; j < arrchildEpdDiseaseToSickKind.length; j++){			
				if (DiseaseDesc == arrchildEpdDiseaseToSickKind[j]) {
					if ((DegreeDesc=="临床诊断病例")&&((SickKind.indexOf('未分类')<0)||(!SickKind))){
						InputError = InputError + $g("当传染病诊断是乙型肝炎、丙型肝炎、血吸虫病，且病例分类为临床诊断病例时，发病程度只能选择未分类!")+"<br>";	
					}
					if ((DegreeDesc=="确诊病例")&&((!SickKind)||((SickKind.indexOf('急性')<0)&&(SickKind.indexOf('慢性')<0)))) {
						InputError = InputError + $g("当传染病诊断是乙型肝炎、丙型肝炎、血吸虫病时，且病例分类为临床诊断病例时，发病程度需分急性或慢性填写!")+"<br>";
					}
				}
			}
		}
	    if ((DiseaseDesc=="其它")&&(SickKind !="未分类")) {
			InputError = InputError + $g("当传染病诊断是其它时，发病程度必须为未分类!")+"<br>";

		}
		var PatRegion = $('#cboRegion').combobox('getText');
		if ((PatRegion.indexOf('港澳台') > -1)||(PatRegion.indexOf('外籍') > -1)) {
			//不需要填写身份证
		} else {	
			if ($.trim($('#cboProvince').combobox('getValue')) == "") {
				InputError = InputError + $g("请填写现住址-省!")+"<br>";
			}
			if ($.trim($('#cboCity').combobox('getValue')) == "") {
				InputError = InputError + $g("请填写现住址-市!")+"<br>";
			}
			if ($.trim($('#cboCounty').combobox('getValue')) == "") {
				InputError = InputError + $g("请填写现住址-县!")+"<br>";
			}
			if ($.trim($('#cboVillage').combobox('getValue')) == "") {
				InputError = InputError + $g("请填写现住址-乡!")+"<br>";
			}
			if ($.trim($('#txtRoad').val()) == "") {
				InputError = InputError + $g("请填写现住址-门牌号!")+"<br>";
			}
		}
        if ($.trim($('#cboCardType').combobox('getValue')) == "") {
			InputError = InputError + $g("请选择证件类型!")+"<br>";
		}
		if ($.trim($('#txtPatCardNo').val()) == "") {
			InputError = InputError + $g("请填写有效证件号!")+"<br>";
		}
        // 验证身份证号是否合法(通过正则表达式)
        var PatCardNo = $('#txtPatCardNo').val();
		var CardType=$('#cboCardType').combobox('getText');
		if ((CardType.indexOf('身份证')>-1)&&($.trim(PatCardNo) != "")){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{7}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}$)/.test(PatCardNo))) {
				InputError += $g('输入的身份证号格式不符合规定！请重新输入!')+"<br>";
			}
		}
       	if (CardType=="监护人证件"){
			if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{7}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}$)/.test(PatCardNo))) {
				InputError += $g('输入的监护人证件号(监护人身份证号)格式不符合规定！请重新输入!')+"<br>";
			}
		}
		if ($.trim($('#cboDegree').combobox('getValue')) == "") {
			InputError = InputError + $g("请选择病例分类!")+"<br>";
		}
		var DegreeDesc= $('#cboDegree').combobox('getText');
		if ((DiseaseDesc.indexOf($g('梅毒'))>-1)||(DiseaseDesc==$g('淋病'))) {
			if ((DegreeDesc!=$g("确诊病例"))&&(DegreeDesc!=$g("疑似病例"))) {
				InputError = InputError + $g("当传染病诊断是梅毒、淋病时，病例分类只能是确诊病例和疑似病例!")+"<br>";
			}
		}
		if ((DiseaseDesc==$g('尖锐湿疣'))||(DiseaseDesc==$g('生殖器疱疹'))) {
			if ((DegreeDesc!=$g("确诊病例"))&&(DegreeDesc!=$g("临床诊断病例"))) {
				InputError = InputError + $g("当传染病诊断是尖锐湿疣、生殖器疱疹时，病例分类只能是确诊病例和临床诊断病例!")+"<br>";
			}
		}
		if (DiseaseDesc==$g('生殖道沙眼衣原体感染')) {
			if (DegreeDesc!=$g("确诊病例")) {
				InputError = InputError + $g("当传染病诊断是生殖道沙眼衣原体感染时，病例分类只能是确诊病例!")+"<br>";
			}
		}
		if ((DiseaseDesc.indexOf($g('菌阴'))>-1)&&(DegreeDesc==$g("确诊病例"))) {
			InputError = InputError + $g("当传染病诊断是菌(-)时，病例分类不能是确诊病例!)!")+"<br>";
		}
		if ((DiseaseDesc==$g('艾滋病'))&&(DegreeDesc==$g("疑似病例"))) {
			InputError = InputError + $g("当传染病诊断是艾滋病时，病例分类不能是疑似病例!)!")+"<br>";
		}
		if ((DiseaseDesc==$g('埃博拉出血热'))&&(DegreeDesc!=$g("埃博拉留观病例"))) {
			InputError = InputError + $g("当传染病诊断是埃博拉出血热时，病例分类只能是埃博拉留观病例!")+"<br>";	
		}
		if ((DiseaseDesc.indexOf($g('灰质炎'))>-1)||(DiseaseDesc=='HIV')||
			(DiseaseDesc.indexOf($g('涂阳'))>-1)&&(DiseaseDesc.indexOf($g('仅培阳')>-1))) {
			if ((DegreeDesc==$g("临床诊断病例"))||(DegreeDesc==$g("疑似病例"))) {
				InputError = InputError + $g("当传染病诊断是脊灰、HIV、涂(+)或仅培阳时，病例分类不能是临床诊断病例和疑似病例!")+"<br>";
			}
		}
		if ((DiseaseDesc!=$g('霍乱'))&&(DiseaseDesc.indexOf($g('灰质炎'))<0)&&
			(DiseaseDesc!=$g('乙型病毒性肝炎'))&&(DiseaseDesc.indexOf($g('伤寒'))<0)&&
			(DiseaseDesc!=$g('间日疟'))&&(DiseaseDesc!=$g('恶性疟'))) {
			if ((DegreeDesc=="病原携带者")) {
				InputError = InputError + $g("当传染病诊断是霍乱、脊灰、乙肝、伤寒、副伤寒、间日疟、恶性疟时，病例分类才能是病原携带者!")+"<br>";
			}
		}
		// add 20200206
		var Severity = $('#cboSeverity').combobox('getText');
		if (DiseaseDesc.indexOf($g('新型冠状'))>-1) {
			if ((DegreeDesc!="确诊病例")&&(DegreeDesc!="疑似病例")&&(DegreeDesc!="阳性检测")) {
				InputError = InputError + "当传染病诊断是新型冠状病毒感染时，病例分类只能是疑似病例、确诊病例和阳性检测!<br>";
			}
		}
		if ((DegreeDesc==$g("阳性检测"))&&(Severity!=$g("无症状感染者"))) {   //临床严重程度在新冠肺炎时才可填报故此判断
	        InputError = InputError + $g("阳性检测仅限于新型冠状病毒感染无症状感染者填报!")+"<br>";
        }
			
		var data = $m({      //根据诊断获取传染病类别
			ClassName:"DHCMed.EPDService.InfectionSrv",
			MethodName:"GetMIFKind",
			aDiseaseID:$('#cboDisease').combobox('getValue')
		},false);
		if (data != ''){
			if (data=='AFP') {
				if ((DegreeDesc==$g("确诊病例"))||(DegreeDesc==$g("疑似病例"))) {
					InputError = InputError + $g("当传染病诊断类型是AFP时，病例分类不能是确诊病例和疑似病例!")+"<br>";
				}
			}
		}
		if ($('#dtSickDate').datebox('getValue') == "") {
			InputError = InputError + $g("请选择发病日期!")+"<br>";
		}
		if ($('#dtDiagnoseDate').datebox('getValue') == "") {
			InputError = InputError + $g("请选择诊断日期!")+"<br>";
		}
		var dtSickDateStr = $('#dtSickDate').datebox('getValue');	//发病日期
		var dtDiagnoseDateStr = $('#dtDiagnoseDate').datetimebox('getValue');	//诊断日期
		var dtDeadDateStr = $('#dtDeadDate').datebox('getValue');//死亡日期
		var dtRepDateStr = $('#dtRepDate').datetimebox('getValue');//报告日期
		var sickDate = dtSickDateStr;
		var diagnoseDate = dtDiagnoseDateStr.split(" ")[0];
		var diagnoseTime = dtDiagnoseDateStr.split(" ")[1];
		var DeadDate = dtDeadDateStr;
		var RepDate = dtRepDateStr.split(" ")[0];
		var RepTime = dtRepDateStr.split(" ")[1];
		var thisNowDate = Common_GetDate(new Date());
	  
		if (Common_CompareDate(sickDate,diagnoseDate)>0) {
			$.messager.alert($g("提示"),$g("抱歉，发病日期不能大于诊断日期!"), 'info');
			return false;
		}
		if (Common_CompareDate(sickDate,thisNowDate)>0) {
			$.messager.alert($g("提示"),$g("抱歉，发病日期不能大于当前日期!"), 'info');
			return false;
		}
		if (Common_CompareDate(DeadDate,thisNowDate)>0) {
			$.messager.alert($g("提示"),$g("抱歉，死亡日期不能大于当前日期!"), 'info');
			return false;
		}
		if (Common_CompareDate(sickDate,DeadDate)>0) {
			$.messager.alert($g("提示"),$g("抱歉，发病日期不能大于死亡日期!"), 'info');
			return false;
		}
		if (Common_CompareDate(diagnoseDate,thisNowDate)>0) {
			$.messager.alert($g("提示"),$g("抱歉，诊断日期不能大于当前日期!"), 'info');
			return false;
		}
		if (RepDate!=""){
			if (Common_CompareDate(sickDate,RepDate)>0) {
				$.messager.alert($g("提示"),$g("抱歉，发病日期不能大于报告日期!"), 'info');
				return false;
			}
			if (Common_CompareDate(RepDate,thisNowDate)>0) {
				$.messager.alert($g("提示"),$g("抱歉，报告日期不能大于当前日期!"), 'info');
				return false;
			}
			if (Common_CompareDate(diagnoseDate,RepDate)>0) {
				$.messager.alert($g("提示"),$g("抱歉，诊断日期不能大于报告日期!"), 'info');
				return false;
			}
			if ((diagnoseDate==RepDate)&&(Common_CompareTime(diagnoseTime,RepTime)>0)){
				$.messager.alert($g("提示"),$g("抱歉，诊断日期等于报告日期,诊断时间不能大于报告时间!"), 'info');
				return false;
			}
		}
		if ((obj.ReportID)&&(Common_CompareDate(diagnoseDate,RepDate)>0)){
			$.messager.alert($g("提示"),$g("抱歉，诊断日期不能大于报告日期!"), 'info');
			return false;
		}
			
		//判断附卡项目
		var DiseaseID = $('#cboDisease').combobox('getValue');
		var CardType  = obj.LoadCardType(DiseaseID);
		if (CardType) {
			if (CardType=='HBV') {
				if ($.trim($('#cboHBVHBsAgPositive').combobox('getValue')) == "") {
					InputError = InputError + $g("请选择HBsAg阳性时间!")+"<br>";
				}
				if ($.trim($('#txtHBVALT').val()) == "") {
					InputError = InputError + $g("请填写本次ALT!")+"<br>";
				}
				if ($.trim($('#cboHBVLiverResult').combobox('getValue')) == "") {
					InputError = InputError + $g("请选择肝组织穿刺检测结果!")+"<br>";
				}
				if (($('#dtHBVSymbolDate').datebox('getValue') == "")&&($('#chk-HBVSymbol').checkbox('getValue')=="")&&($('#chk-HBVUnknown').checkbox('getValue')=="")) {
					InputError = InputError + $g("请选择首次出现乙肝症状和体征的时间!")+"<br>";
				}
				if (Common_RadioValue('radHBVDiluteList') == "") {
					InputError = InputError + $g("请选择抗-HBc IgM 1:1000 稀释检测结果!")+"<br>";
				}
				if (Common_RadioValue('radHBVSerumList')=="") {
					InputError = InputError + $g("请选择恢复期血清HBsAg阴转，抗HBs阳转!")+"<br>";
				}			
			} else if (CardType=='HIV') {
				if ($.trim($('#cboHIVDomicileProvince').combobox('getValue')) == "") {
					InputError = InputError + $g("请填写户籍地址-省!")+"<br>";
				}
				if ($.trim($('#cboHIVDomicileCity').combobox('getValue')) == "") {
					InputError = InputError + $g("请填写户籍地址-市!")+"<br>";
				}
				if ($.trim($('#cboHIVDomicileCounty').combobox('getValue')) == "") {
					InputError = InputError + $g("请填写户籍地址-县!")+"<br>";
				}
				if ($.trim($('#cboHIVDomicileVillage').combobox('getValue')) == "") {
					InputError = InputError + $g("请填写户籍地址-乡!")+"<br>";
				}
				if ($.trim($('#txtHIVDomicileRoad').val()) == "") {
					InputError = InputError + $g("请填写户籍地址-门牌号!")+"<br>";
				}
				if ($.trim($('#cboHIVMarriage').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择婚姻状况!")+"<br>";
				}
				if ($.trim($('#cboHIVEducation').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择文化程度!")+"<br>";
				}
				if ($.trim($('#cboHIVStdHistory').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择性病史!")+"<br>";
				}
				var HIVDigSureDate=$('#dtHIVDigSureDate').datebox('getValue')
				if (HIVDigSureDate=="") { 
					InputError = InputError + $g("请选择HIV确诊日期!")+"<br>";
				}
				if(Common_CompareDate(HIVDigSureDate,thisNowDate)>0){
					InputError = InputError + $g("确诊日期不能大于当前日期!")+"<br>";
				}
				if (Common_CheckboxValue('chkHIVDiaTypeList')=="") { 
					InputError = InputError + $g("请选择疾病名称!")+"<br>";
				}
				if (($("#chk-HIVUnmarHistory").checkbox("getValue")!="")&&(!Common_RadioValue("radHIVBusiness"))){
					InputError = InputError + $g("您有非婚异性性接触史,请选择是否商业!")+"<br>";
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
					if (($.trim(DiaTypeList).indexOf($g('梅毒')) > -1)&&(Common_RadioValue('radHIVSexPeriodList')=="")) { 
						InputError = InputError + $g("请选择梅毒分期!")+"<br>";
					}
					if (($.trim(DiaTypeList).indexOf($g('衣原体'))> -1)&&(Common_RadioValue('radHIVTrachomaInfList')=="")) { 
						InputError = InputError + $g("请选择衣原体感染类型!")+"<br>";
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
					&&($('#chk-HIVUnknown').checkbox('getValue')=="")) { 
					
					InputError = InputError + $g("请选择接触史!")+"<br>";
				}
				
				if (($('#chk-HIVDrugHistory').checkbox('getValue')!="")&&($('#num-HIVInjection').val()=="")){
					InputError = InputError + $g("请填写注射器共用情况!")+"<br>";
				}
				if (($('#chk-HIVUnmarHistory').checkbox('getValue')!="")&&($('#num-HIVUnmarried').val()=="")){
					InputError = InputError + $g("请填写非婚性行为情况!")+"<br>";
				}
				if (($('#chk-HIVMSMHistory').checkbox('getValue')!="")&&($('#PatSex').text()=="女")){
					InputError = InputError + $g("患者性别为女，接触史不能选择男男性行为史!")+"<br>";
				}
				if (($('#chk-HIVMSMHistory').checkbox('getValue')!="")&&($('#num-HIVMSM').val()=="")){
					InputError = InputError + $g("请填写同性性行为情况!")+"<br>";
				}
				if (($('#chk-HIVQtResume').checkbox('getValue')!="")&&($('#txt-HIVQtResume').val()=="")){
					InputError = InputError + $g("请填写其他接触史详细情况!")+"<br>";
				}
				if (Common_RadioValue('radHIVPobSourceList')=="") { 
					InputError = InputError + $g("请选择最可能的感染途径!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("其他"))&&($("#txtHIVPosSource").val()=="")) { 
					InputError = InputError + $g("最可能的感染途径为其他,请填写其他感染途径!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("注射毒品"))&&($('#chk-HIVDrugHistory').checkbox('getValue')=="")){
					InputError = InputError + $g("最有可能感染途径为注射毒品,接触史必须包含注射毒品史!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("异性传播"))&&(($('#chk-HIVUnmarHistory').checkbox('getValue')=="")&&($('#chk-HIVFixedCom').checkbox('getValue')==""))){
					InputError = InputError + $g("最有可能感染途径为异性传播,接触史必须包含非婚异性性接触史或配偶/固定性伴阳性!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("同性传播"))&&($('#chk-HIVMSMHistory').checkbox('getValue')=="")){
					InputError = InputError + $g("最有可能感染途径为同性传播,接触史必须包含男男性行为史!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("同性传播"))&&($('#PatSex').text()!=$g("男"))){
					InputError = InputError + $g("最有可能感染途径为同性传播,性别必须为男!")+"<br>";
				}
				if (Common_RadioLabel('radHIVPobSourceList')==$g("性接触+注射毒品")){
					if ($('#chk-HIVDrugHistory').checkbox('getValue')==""){
						InputError = InputError + $g("最有可能感染途径为性接触+注射毒品,接触史必须包含注射毒品史!")+"<br>";
					}
					if (($('#chk-HIVUnmarHistory').checkbox('getValue')=="")&&($('#chk-HIVFixedCom').checkbox('getValue')=="")&&($('#chk-HIVMSMHistory').checkbox('getValue')=="")){
						InputError = InputError + $g("最有可能感染途径为性接触+注射毒品,接触史必须包含'非婚异性性接触史'、'配偶/固定性伴阳性'、'男男性行为史'三者之一或以上!")+"<br>";
					}
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("采血(浆)"))&&($('#chk-HIVBloodDona').checkbox('getValue')=="")){
					InputError = InputError + $g("最有可能感染途径为采血(浆),接触史必须包含献血（浆）史!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("输血/血制品"))&&($('#chk-HIVBloodTran').checkbox('getValue')=="")){
					InputError = InputError + $g("最有可能感染途径为输血/血制品,接触史必须包含输血/血制品史!")+"<br>";
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("母婴传播"))&&($('#chk-HIVMotherPose').checkbox('getValue')=="")){
					InputError = InputError + $g("最有可能感染途径为母婴传播,接触史必须包含母亲阳性!")+"<br>";
				}
				if (Common_RadioLabel('radHIVPobSourceList')==$g("母婴传播")){
					var PatAgeInfo = $('#Age').text();
					if (PatAgeInfo.indexOf($g("岁"))>-1){
						var PatAge = PatAgeInfo.replace(/[^0-9]/ig, "")
						if (PatAge>18){
							InputError = InputError + $g("最有可能感染途径为母婴传播,年龄必须小于18岁!")+"<br>";
						}	
					}
				}
				if ((Common_RadioLabel('radHIVPobSourceList')==$g("职业暴露"))&&($('#chk-HIVExposure').checkbox('getValue')=="")){
					InputError = InputError + $g("最有可能感染途径为职业暴露,接触史必须包含职业暴露史!")+"<br>"; 
				}
				if (Common_RadioValue('radHIVSimSourceList')=="") { 
					InputError = InputError + $g("请选择检测样本来源!")+"<br>";
				}
				
				if ((Common_RadioLabel('radHIVSimSourceList')==$g("其他"))&&($("#txtHIVSimSource").val()=="")) { 
					InputError = InputError + $g("检测样本来源为其他,请填写其他检测样本来源!")+"<br>";
				}
				if ($('#cboHIVTestResult').combobox('getValue')=="") { 
					InputError = InputError + $g("请选择实验室检测结论!")+"<br>";
				}
				var HIVResultDate=$('#dtHIVResultDate').datebox('getValue')
				if (HIVResultDate=="") { 
					InputError = InputError + $g("请选择确认(替代策略)检测阳性日期!")+"<br>";
				}
				if(Common_CompareDate(HIVResultDate,thisNowDate)>0){
					InputError = InputError + $g("确认(替代策略)检测阳性日期不能大于当前日期!")+"<br>";
				}
				if ($('#txtHIVTestCompany').val()=="") {     
					InputError = InputError + $g("请填写确认(替代策略)检测单位!")+"<br>";
				}
				
			} else if (CardType=='STD') {
				if ($.trim($('#cboSTDMarriage').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择婚姻状况!")+"<br>";
				}
				if ($.trim($('#cboSTDEducation').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择文化程度!")+"<br>";
				}
				if ($.trim($('#cboSTDStdHistory').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择性病史!")+"<br>";
				}
				if ($('#dtSTDDigSureDate').datebox('getValue')=="") { 
					InputError = InputError + $g("请选择确诊日期!")+"<br>";
				}
				if (Common_CheckboxValue('chkSTDDiaTypeList')=="") { 
					InputError = InputError + $g("请选择疾病名称!")+"<br>";
				}
				if ($.trim($('#cboSTDDomicileProvince').combobox('getValue')) == "") {
					InputError = InputError + "请填写户籍地址-省!<br>";
				}
				if ($.trim($('#cboSTDDomicileCity').combobox('getValue')) == "") {
					InputError = InputError + "请填写户籍地址-市!<br>";
				}
				if ($.trim($('#cboSTDDomicileCounty').combobox('getValue')) == "") {
					InputError = InputError + "请填写户籍地址-县!<br>";
				}
				if ($.trim($('#cboSTDDomicileVillage').combobox('getValue')) == "") {
					InputError = InputError + "请填写户籍地址-乡!<br>";
				}
				if ($.trim($('#txtSTDDomicileRoad').val()) == "") {
					InputError = InputError + "请填写户籍地址-门牌号!<br>";
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
					
					InputError = InputError + $g("请选择接触史!")+"<br>"; 
				}
				
				if (($('#chk-STDDrugHistory').checkbox('getValue')!="")&&($('#num-STDInjection').val()=="")){
					InputError = InputError + $g("请填写注射器共用情况!")+"<br>";
				}
				if (($('#chk-STDUnmarHistory').checkbox('getValue')!="")&&($('#num-STDUnmarried').val()=="")){
					InputError = InputError + $g("请填写非婚性行为情况!")+"<br>";
				}
				if (($('#chk-STDMSMHistory').checkbox('getValue')!="")&&($('#PatSex').text()==$g("女"))){
					InputError = InputError + $g("患者性别为女，接触史不能选择男男性行为史!")+"<br>";
				}
				if (($('#chk-STDMSMHistory').checkbox('getValue')!="")&&($('#num-STDMSM').val()=="")){
					InputError = InputError + $g("请填写同性性行为情况!")+"<br>";
				}
				if (($('#chk-STDQtResume').checkbox('getValue')!="")&&($('#num-STDQtResume').val()=="")){
					InputError = InputError + $g("请填写其他接触史详细情况!")+"<br>";
				}
				
				if (Common_RadioValue('radSTDPobSourceList')=="") { 
					InputError = InputError + $g("请选择最可能的感染途径!")+"<br>";
				}
				if (Common_RadioValue('radSTDSimSourceList')=="") { 
					InputError = InputError + $g("请选择检测样本来!")+"<br>";
				}
				if ($.trim($('#cboSTDTestResult').combobox('getValue'))=="") { 
					InputError = InputError + $g("请选择实验室检测结论!")+"<br>";
				}
				if ($('#dtSTDResultDate').datebox('getValue')=="") { 
					InputError = InputError + $g("请选择确认(替代策略)检测阳性日期!")+"<br>";
				}
				if ($.trim($('#txtSTDTestCompany').val())=="") {     
					InputError = InputError + $g("请填写确认(替代策略)检测单位!")+"<br>";
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
					
					if (($.trim(DiaTypeList)!="")&&(DiaTypeList.indexOf($g('梅毒')) > -1)&&(Common_RadioValue('radSTDSexPeriodList')=="")) { 
						InputError = InputError + $g("请选择梅毒分期!")+"<br>";
					}
					if (($.trim(STDDiaType)!="")&&(STDDiaType.indexOf($g('衣原体'))> -1)&&(Common_RadioValue('radSTDTrachomaInfList')=="")) { 
						InputError = InputError + $g("请选择衣原体感染类型!")+"<br>";
					}
				
					if (Common_RadioValue('radSTDLabResultList') =="") { 
						InputError = InputError + $g("请选择梅毒实验室检测方法RPR/TRUST定性结果!")+"<br>";
					}
					if (Common_RadioValue('radSTDLabResultList') !="") { 
						var  LabResult = obj.DicManage('EpdSexLabResult',Common_RadioValue('radSTDLabResultList')).Description;
						if ((($.trim(LabResult!=""))&&(LabResult.indexOf($g('未做'))<0))&&(($('#chk-STDUnDo').checkbox('getValue')=="")&&($('#num-STDDt').val() =="" ))) { 
							InputError = InputError + $g("请填写梅毒实验室检测方法RPR/TRUST定性滴度!")+"<br>";
						}
					}
					if (Common_RadioValue('radSTDTPResultList') =="") { 
						InputError = InputError + $g("请填写梅毒实验室检测方法TP暗视野镜检结果!")+"<br>";
					}
					if (Common_RadioValue('radSTDTPHAResultList') =="") { 
						InputError = InputError + $g("请填写梅毒实验室检测方法TPPA/TPHA结果!")+"<br>";
					}
					if (Common_RadioValue('radSTDELISAResultList') =="") { 	
						InputError = InputError + $g("请填写梅毒实验室检测方法TP-ELISA结果!")+"<br>";
					}
					if (($('#txt-STDQtTest').val() !="" )&&(Common_RadioValue('radSTDQTResultList') =="")) { 
						InputError = InputError + $g("请填写梅毒实验室检测方法其它检测方法结果!")+"<br>";
					}
					if (obj.objCurrPatient.Age <= new Number($.trim(ServerObj.EpdRepPatRelRequireMaxAge))) {
						if (Common_RadioValue('radSTDMLabResultList') =="") { 
							InputError = InputError + $g("请选择患儿生母梅毒实验室检测方法RPR/TRUST定性结果!")+"<br>";
						}
						if (Common_RadioValue('radSTDMLabResultList') !="") { 
							var  MLabResult = obj.DicManage('EpdSexLabResult',Common_RadioValue('radSTDMTPResultList')).Description;
							if ((($.trim(MLabResult!=""))&&(MLabResult.indexOf('未做')<0))&&(($('#chk-STDMUnDo').checkbox('getValue')=="")&&($('#num-STDMDt').val() =="" ))) { 
								InputError = InputError + $g("请填写患儿生母梅毒实验室检测方法RPR/TRUST定性滴度!")+"<br>";
							}
						}
						if (Common_RadioValue('radSTDMTPResultList') =="") { 
							InputError = InputError + $g("请填写患儿生母梅毒实验室检测方法TP暗视野镜检!")+"<br>";
						}
						if (Common_RadioValue('radSTDMTPHAResultList') =="") { 
							InputError = InputError + $g("请填写患儿生母梅毒实验室检测方法TPPA/TPHA!")+"<br>";
						}
						if (Common_RadioValue('radSTDMELISAResultList') =="") { 
							InputError = InputError + $g("请填写患儿生母梅毒实验室检测方法TP-ELISA!")+"<br>";
						}
						if (($('#txt-STDMQtTest').val() !="" ) &&(Common_RadioValue('radSTDMQTResultList') =="")) { 
							InputError = InputError + $g("请填写患儿生母梅毒实验室检测方法其它检测方法结果!")+"<br>";
						}
					}
					if (Common_RadioValue('radSTDHaveList') =="" ) {
						InputError = InputError + $g("请选择梅毒临床表现!")+"<br>";						
					}
					if (Common_RadioValue('radSTDHaveList') !="" ) {
						var HaveList = obj.DicManage('EpdemicHave',Common_RadioValue('radSTDHaveList')).Description;
						if  ($.trim(HaveList!="")&&(HaveList.indexOf($g('有'))>-1)) {
							if (Common_CheckboxValue('chkSTDSymbolList') =="" ) { 
								InputError = InputError + $g("请选择梅毒临床具体表现!")+"<br>";	
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
								if ($.trim(SymbolList!="")&&(SymbolList.indexOf($g('其他'))>-1)&&($('#txt-STDQtSymbol').val() =="")) {	
									InputError = InputError + $g("请选择梅毒临床其他表现!")+"<br>";
								}
							}
						}
					}
				}
					
			} else if (CardType=='AFP') {
				if ($('#cboAFPRegion').combobox('getValue') == '') {
					InputError = InputError + $g("请选择病人所属!")+"<br>";
				}
				var AFPRegion = $('#cboAFPRegion').combobox('getText');
				//来就诊地日期
				var AdmPlaceDate = $('#dtAFPAdmPlaceDate').datebox('getValue');
				if ((AFPRegion==$g("异地"))&&(AdmPlaceDate == '')) {
					InputError = InputError + $g("请填写来就诊地日期!")+"<br>";
				} else {
					if (Common_CompareDate(sickDate,AdmPlaceDate)>0) {
						InputError = InputError + $g("来就诊地日期不能大于发病日期!")+"<br>";
					}
					if (Common_CompareDate(AdmPlaceDate,diagnoseDate)>0) {
						InputError = InputError + $g("来就诊地日期必须小于等于诊断日期!")+"<br>";
					}
					if (Common_CompareDate(AdmPlaceDate,thisNowDate)>0) {
						InputError = InputError + $g("来就诊地日期必须小于等于当前日期!")+"<br>";
					}
				}
				var AFPParalyDate = $('#dtAFPParalyDate').datebox('getValue');
				if (AFPParalyDate == '') {
					InputError = InputError + $g("请填写麻痹日期!")+"<br>";
				} else {
					if (Common_CompareDate(sickDate,AFPParalyDate)>0) {
						InputError = InputError + $g("麻痹日期不能大于发病日期!")+"<br>";
					}
					if (Common_CompareDate(AFPParalyDate,diagnoseDate)>0) {
						InputError = InputError + $g("麻痹日期必须小于等于诊断日期!")+"<br>";
					}
				}
				if ($('#cboAFPRegion').combobox('getText') == $g('异地')) {
					if ($('#cboAFPAdmRegion').combobox('getValue') == '') {
						InputError = InputError + $g("请选择就诊地类型!")+"<br>";
					}
					if ($('#dtAFPAdmPlaceDate').datebox('getValue') == '') {
						InputError = InputError + $g("请填写来就诊地日期!")+"<br>";
					}
					if ($.trim($('#cboAFPDomicileProvince').combobox('getValue')) == ""
						|| $.trim($('#cboAFPDomicileProvince').combobox('getValue')) == ""
						|| $.trim($('#cboAFPDomicileCity').combobox('getValue')) == ""
						|| $.trim($('#cboAFPDomicileCounty').combobox('getValue')) == ""
						|| $.trim($('#cboAFPDomicileVillage').combobox('getValue')) == ""
						|| $.trim($('#txtAFPDomicileRoad').val()) == ""
					) {
						InputError = InputError + $g("请填写来就诊地省市县乡及街道门牌号!")+"<br>";
					}
				}
				if ($('#cboIntimate').combobox('getValue') == '') {
					InputError = InputError + $g("诊断为AFP时请选择患者接触情况!")+"<br>";
				}
			} else if (CardType=='HFMD') {
				if ($.trim($('#cboHFMDIntensivePat').combobox('getValue')) == "") {
					InputError = InputError + $g("请选择是否重症患者!")+"<br>";
				}
				if (DiseaseDesc.indexOf($g('手足口'))>-1) {
					if (DegreeDesc==$g("确诊病例") && $('#cboHFMDLaborTestResult').combobox('getValue')=="") {
						InputError = InputError + $g("当传染病诊断是手足口病，病例分类是确诊病例时，实验室结果不能为空!")+"<br>";
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
		
		var dtRepDateStr = $('#dtRepDate').datetimebox('getValue');//报告日期
		
		var RepDate = dtRepDateStr.split(" ")[0];
		var RepTime = dtRepDateStr.split(" ")[1];
		strTmp += RepDate + strDelimiter;       // RepDate
		strTmp += RepTime + strDelimiter;       // RepTime
	
		if (RepStatus==2) { //审核
			strTmp += (strReport[34].split(CHR_2)[0] ? strReport[34].split(CHR_2)[0] : session['LOGON.USERID']) + strDelimiter;    //CheckUser
			strTmp += (strReport[35] ? strReport[35] : tmpList[0]) + strDelimiter;     // CheckDate
			strTmp += (strReport[36] ? strReport[36] : tmpList[1]) + strDelimiter;     // CheckTime
		}else {
			strTmp += (strReport[34] ? strReport[34].split(CHR_2)[0] : '') + strDelimiter;    //CheckUser
			strTmp += (strReport[35] ? strReport[35] : '') + strDelimiter;     // CheckDate
			strTmp += (strReport[36] ? strReport[36] : '') + strDelimiter;     // CheckTime

		}
		strTmp += $.trim($('#txtResumeText').val().replace(/\^/g, "*")) + strDelimiter;
		
		var ReviseReason='';
		if (RepStatus==3) { //订正
			ReviseReason = $('#cboReviseReason').combobox('getText');
		}
		strTmp += (strReport[37] ? strReport[37] : ReviseReason) + strDelimiter;        // Del reason/订正原因的描述
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
		strTmp += $.trim($('#cboIsInEPD').combobox('getValue')) + strDelimiter;   //输入病例
		strTmp += $.trim($('#txtContr').val()) + strDelimiter;  ////
		//strTmp += $('#dtRepDate').datetimebox('getValue') + strDelimiter;  //首次报卡日期
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
			else if (DataType==10) { //省市县乡
				ItemValue = $('#'+ItemCode).combobox('getValue');
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
			$.messager.alert($g("提示"), $g("请选择诊断!"), 'info');
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
		
		//obj.SaveReport(1,strDescription);
		
		CASignLogonModal('EPD','SaveEPDReport',{
			// 待签名数据：主卡字符串+子卡字符串
			signData: obj.SaveToString(obj.objCurrReport, 1) + obj.SaveSubToString()
		},obj.SaveReport,1,strDescription);
		
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
	
	//漏报
	obj.btnOmision_click = function() {
		var InputError = '';
		if ($('#cboDisease').combobox('getValue') == "") {
			InputError = InputError + $g("请选择传染病诊断!")+"<br>";
		}
		if (InputError != '') {
			$.messager.alert($g("提示"),$g("漏报报告，" )+ InputError, 'info');
			return;
		}
		var strDescription=$('#btnOmision').linkbutton('options').text;
		obj.SaveReport(9,strDescription);
	
	}; 
	//复诊
	obj.btnRepeat_click = function() {
		var InputError = '';
		if ($('#cboDisease').combobox('getValue') == "") {
			InputError = InputError + $g("请选择传染病诊断!")+"<br>";
		}
		if (InputError != '') {
			$.messager.alert($g("提示"),$g("复诊报告!") + InputError, 'info');
			return;
		}
		var strDescription=$('#btnRepeat').linkbutton('options').text;
		obj.SaveReport(8,strDescription);
	}; 
	
	// 审核
	obj.btnCheck_click = function() {
		$.messager.confirm($g("审核"), $g("您确定要审核这份传染病报告么？"), function (r) {
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
		$.messager.confirm($g("取消审核"), $g("您确定要取消审核这份传染病报告么？"), function (r) {
			if (r){
				var strDescription =$('#btnUpdoCheck').linkbutton('options').text;
				obj.ReportID = obj.SaveReportAA(1,strDescription,"");
				obj.SaveEPDLogInfo(1,strDescription);
				var ret = obj.SendNews("S00000018",obj.ReportID,1,EpisodeID);
			}
		});
	};
	
	// 订正
	obj.btnCorrect_click = function() {
		$.messager.confirm($g("订正"), $g("您确定要订正这份传染病报告么？"), function (r) {
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
					$.messager.alert($g("提示"),$g("保存被订报告失败！返回值：") + strReportID, 'info');
					return;
				}
				obj.MReportID = strReportID;
				
				//保存订正后的诊断
				var strDescription =$('#btnCorrect').linkbutton('options').text;
				obj.ReportID= obj.SaveReport(3,strDescription);
			
				var ret = obj.SendNews("S00000018",strReportID,6,EpisodeID);  //被订
		        var ret = obj.SendNews("S00000018",obj.ReportID,7,EpisodeID); //订正
				ReportID =obj.ReportID;
				$HUI.dialog('#winEPDReviseReason').close();
			}
		});
	};
	
	//查看被订报告
	obj.btnRevised_click = function() {
		var MepdReportID = $m({                  
			ClassName:"DHCMed.EPD.Epidemic",
			MethodName:"GetRevised",
			aReportID:obj.ReportID
		},false);
		if(!MepdReportID) return;
		var strUrl = "./dhcma.epd.report.csp?1=1"+ "&EpisodeID=" + EpisodeID + "&ReportID=" + MepdReportID ;       	
	    websys_showModal({
			url:strUrl,
			title:$g('传染病报告'),
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:true,
			width:1340,
			height:'90%'
		});
	};
	// 退回
	obj.btnReturn_click = function() {
		$.messager.prompt($g("退回"), $g("请输入退回原因!"), function (r) {
			if (r){
				var strDescription = $('#btnReturn').linkbutton('options').text;
				obj.ReportID=obj.SaveReportAA(5,strDescription,r);
				obj.SaveEPDLogInfo(5,"");
				var ret = obj.SendNews("S00000018",obj.ReportID,3,EpisodeID);
			}else if(r==""){
				$.messager.alert($g("提示"),$g("请填写退回原因"), 'info');
			}	
		});
	};
	
	// 上报CDC
	obj.btnUpdateCDC_click = function() {
		if (obj.objCurrReport){
			var aOperationDesc = $('#btnUpdateCDC').linkbutton('options').text;
			$.messager.confirm(aOperationDesc, $g("您是否要将此报告")+aOperationDesc+"？", function (r) {
				if (r){
					var strReportID = $m({                  
						ClassName:"DHCMed.EPD.Epidemic",
						MethodName:"UpdateUploadStatus",
						aRepID: obj.objCurrReport.split("^")[0], 
						aStatus: (obj.objCurrReport.split("^")[26] == "N" ? "Y" : "N")
					},false);
					if (strReportID > 0) {
						$.messager.alert($g("提示"),aOperationDesc + $g("成功！"), 'info');				
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
							$('#btnUpdateCDC').linkbutton({text:$g('上报CDC')});
						}else{
							$('#btnUpdateCDC').linkbutton({text:$g('取消上报CDC')});
						}
					} else {
						$.messager.alert($g("提示"),aOperationDesc + $g("失败！返回值：") + strReportID, 'info');
					}
				}			    
				
			});
		}
	};
	
	// 作废
	obj.btnDelete_click = function() {
		$.messager.prompt($g("作废"), $g("请输入作废此传染病报告原因!"), function (r) {
			if (r) {
				var strDescription = $('#btnDelete').linkbutton('options').text;
				obj.ReportID=obj.SaveReportAA(7,strDescription,r);
				obj.SaveEPDLogInfo(7,"");
				var ret = obj.SendNews("S00000018",obj.ReportID,4,EpisodeID);
			}else{
				if (r == "") {
					$.messager.alert($g("提示"), $g("作废原因不可为空！"), 'info');
					return;
				}
			}
		});
	};
	// 关闭窗口
	obj.btnClose_click = function() {
		//关闭
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		if ((ServerObj.EpdCloseNeedReason==1)&&(obj.ReportID=="")&&(IFRowID!="")){
			$.messager.prompt($g("关闭"), $g("请填写关闭原因!"), function (r) {
				if (r){
					// 保存传染病提示报卡关闭原因
					var ret = $m({                  
						ClassName:"DHCMed.EPD.EpidemicLog",
						MethodName:"Update",
						aInputStr:"^^^"+session['LOGON.CTLOCID']+"^^^"+session['LOGON.USERID']+"^"+r+"^"+EpisodeID+"^"+IFRowID,
						aSeparete:"^",
					},false);
					websys_showModal('close');
				}else{
					$.messager.alert($g("提示"),$g("关闭原因不能为空!"), 'info');
					return;
				}	
			});
		}else{
			websys_showModal('close');
		}
		if (DetailsId!=""){
			// 消息明细ID不为空，关闭消息弹出窗口方法
			top.HideExecMsgWin();
		}
	};
	
	// 打印
	obj.btnPrint_click = function() {	
		if (!obj.objCurrReport) {
			$.messager.alert($g("错误"), $g("请先保存传染病报告！"), 'error');
			return;
		} else {
			var CardType = obj.LoadCardType(obj.objCurrReport.split("^")[5].split(CHR_2)[0]);
			PrintDataToExcel(obj.objCurrReport.split("^")[0],CardType,'');
		}
		var reportStatus = obj.objCurrReport.split("^")[33].split(CHR_2)[0];
		if (reportStatus > 4) {
			$.messager.alert($g("温馨提示"), $g("只能打印“待审”、“已审“、“订正”、“被订”状态的传染病报告!"),'info');
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
			/*if (ServerObj.EpdCheckOpinion==1){
				$HUI.dialog('#winEPDCheckOpinion').open();
			}else{
				obj.btnCheck_click();	
			}*/
			obj.btnCheck_click();
		});
		$('#btnUpdoCheck').on("click", function(){     //取消审核
			obj.btnUpdoCheck_click();
		});
		$('#btnCorrect').on("click", function(){       //订正
			$('#cboReviseReason').combobox('setValue','');
			$('#cboReviseReason').combobox('setText','');
			$HUI.dialog('#winEPDReviseReason').open();
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
		$('#btnRepeat').on("click", function(){         //复诊
			obj.btnRepeat_click();
		});
		$('#btnOmision').on("click", function(){         //漏报
			obj.btnOmision_click();
		});
		$('#btnRevised').on("click", function(){         //查看被订报告
			obj.btnRevised_click();
		});
		$('#btnOpenEMR').on("click", function(){         //病例浏览
			Common_showEMR(EpisodeID,PatientID,true);
		});
		
		//现住址街道的值改变
		$('#txtRoad').bind('input propertychange', function() {
			var cboProvince = $('#cboProvince').combobox('getText');
			var cboCity = $('#cboCity').combobox('getText');
			var cboCounty = $('#cboCounty').combobox('getText');
			var cboVillage = $('#cboVillage').combobox('getText');
			var txtRoad = $('#txtRoad').val();
			$('#txtAddress').val(cboProvince+cboCity+cboCounty+cboVillage+txtRoad);
		});
		
		//艾滋病附卡 - 户籍地址街道的值改变
		$('#txtHIVDomicileRoad').bind('input propertychange', function() {
			var cboHIVDomicileProvince = $('#cboHIVDomicileProvince').combobox('getText');
			var cboHIVDomicileCity = $('#cboHIVDomicileCity').combobox('getText');
			var cboHIVDomicileCounty = $('#cboHIVDomicileCounty').combobox('getText');
			var cboHIVDomicileVillage = $('#cboHIVDomicileVillage').combobox('getText');
			var txtHIVDomicileRoad = $('#txtHIVDomicileRoad').val();
			$('#txtHIVDomicileAddress').val(cboHIVDomicileProvince+cboHIVDomicileCity+cboHIVDomicileCounty+cboHIVDomicileVillage+txtHIVDomicileRoad);
		});
		
		//AFP附卡 - 就诊地址街道的值改变
		$('#txtAFPDomicileRoad').bind('input propertychange', function() {
			var cboAFPDomicileProvince = $('#cboAFPDomicileProvince').combobox('getText');
			var cboAFPDomicileCity = $('#cboAFPDomicileCity').combobox('getText');
			var cboAFPDomicileCounty = $('#cboAFPDomicileCounty').combobox('getText');
			var cboAFPDomicileVillage = $('#cboAFPDomicileVillage').combobox('getText');
			var txtAFPDomicileRoad = $('#txtAFPDomicileRoad').val();
			$('#txtAFPDomicileAddress').val(cboAFPDomicileProvince+cboAFPDomicileCity+cboAFPDomicileCounty+cboAFPDomicileVillage+txtAFPDomicileRoad);
		});
		
		//传染病病人所属与现住址强制关联
		if (ServerObj.EpdRegionRelateCurrAdd == '1' && ServerObj.EpdInitAddressByLocalHospital != '') {
			var InitAddrArray = ServerObj.EpdInitAddressByLocalHospital.split('`');
			$('#cboRegion').combobox({
				onChange: function(newValue,oldValue) {
					if (newValue == 1) {				//本县区
						$('#cboProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
						$('#cboProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
						$('#cboCity').combobox('setValue',InitAddrArray[1].split('^')[0]);
						$('#cboCity').combobox('setText',InitAddrArray[1].split('^')[1]);
						$('#cboCounty').combobox('setValue',InitAddrArray[2].split('^')[0]);
						$('#cboCounty').combobox('setText',InitAddrArray[2].split('^')[1]);
						$('#cboVillage').combobox('clear');
						$('#txtRoad').val("");
						$('#txtAddress').val("");
						if(TCardType=='AFP'){
							setTimeout(function(){
								$("#cboAFPRegion").combobox("setValue",0);
								$("#cboAFPRegion").combobox("setText",$g("本地"));
								$("#cboAFPAdmRegion").combobox("setValue",$("#cboRegion").combobox("getValue"));
								$("#cboAFPAdmRegion").combobox("setText",$("#cboRegion").combobox("getText"));
							},100);
						}
					} else if (newValue == 2) {		//本市其他县区
						$('#cboProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
						$('#cboProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
						$('#cboCity').combobox('setValue',InitAddrArray[1].split('^')[0]);
						$('#cboCity').combobox('setText',InitAddrArray[1].split('^')[1]);
						$('#cboCounty').combobox('clear');
						$('#cboVillage').combobox('clear');
						$('#txtRoad').val("");
						$('#txtAddress').val("");
						if(TCardType=='AFP'){
							setTimeout(function(){
								$("#cboAFPRegion").combobox("setValue",0);
								$("#cboAFPRegion").combobox("setText",$g("本地"));
								$("#cboAFPAdmRegion").combobox("setValue",$("#cboRegion").combobox("getValue"));
								$("#cboAFPAdmRegion").combobox("setText",$("#cboRegion").combobox("getText"));
							},100);
						}
					} else if (newValue == 3) {		//本省其它地市
						$('#cboProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
						$('#cboProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
						$('#cboCity').combobox('clear');
						$('#cboCounty').combobox('clear');
						$('#cboVillage').combobox('clear');
						$('#txtRoad').val("");
						$('#txtAddress').val("");
					}else if (newValue == 4) {		//外省
						$('#cboProvince').combobox('clear');
						$('#cboCity').combobox('clear');
						$('#cboCounty').combobox('clear');
						$('#cboVillage').combobox('clear');
						$('#txtRoad').val("");
						$('#txtAddress').val("");
					}
					else if (newValue == 5) {		//港澳台
						$('#cboProvince').combobox('clear');
						$('#cboCity').combobox('clear');
						$('#cboCounty').combobox('clear');
						$('#cboVillage').combobox('clear');
						$('#txtRoad').val("");
						$('#txtAddress').val("");
					}
					else if (newValue == 6) {		//外籍
						$('#cboProvince').combobox('clear');
						$('#cboCity').combobox('clear');
						$('#cboCounty').combobox('clear');
						$('#cboVillage').combobox('clear');
						$('#txtRoad').val("");
						$('#txtAddress').val("");
					}
					if(TCardType=='AFP'){
							setTimeout(function(){
								$("#cboAFPRegion").combobox("setValue",0);
								$("#cboAFPRegion").combobox("setText",$g("本地"));
								$("#cboAFPAdmRegion").combobox("setValue",$("#cboRegion").combobox("getValue"));
								$("#cboAFPAdmRegion").combobox("setText",$("#cboRegion").combobox("getText"));
							},100);
						}
					else{
						if(TCardType=='AFP'){
							setTimeout(function(){
								$("#cboAFPRegion").combobox("setValue",1);
								$("#cboAFPRegion").combobox("setText",$g("异地"));
								$("#cboAFPAdmRegion").combobox("setValue",$("#cboRegion").combobox("getValue"));
								$("#cboAFPAdmRegion").combobox("setText",$("#cboRegion").combobox("getText"));
							},100);
						}
					}
					
				}})
			// 省市县乡选择事件
			$('#cboProvince, #cboCity, #cboCounty').combobox({
				onSelect: function(record) {
					if ($('#cboProvince').combobox('getValue') == InitAddrArray[0].split('^')[0]) {
						if ($('#cboCity').combobox('getValue') == InitAddrArray[1].split('^')[0]) {
							if ($('#cboCounty').combobox('getValue') == InitAddrArray[2].split('^')[0]) {
								$('#cboRegion').combobox('setValue', '1')	//本县区
							} else {
								$('#cboRegion').combobox('setValue', '2')	//本市其他县区
							}
						} else {
							$('#cboRegion').combobox('setValue', '3')		//本省其它地市
						}
					} else {
						$('#cboRegion').combobox('setValue', '4')			//外省
					}
				}
			})
		}
		
		//AFP选择异地时默认就诊地址
		$('#cboAFPRegion').combobox({
			onChange: function(newValue,oldValue) {
				//0本地，1异地
				if (newValue==1){
					$('.noLocalPlace').removeAttr("style");
					$('#cboAFPAdmRegion').combobox('setValue', '1')		//默认本县区
					if (ServerObj.EpdNTSEEADDRESS) {
						var arrayArea = ServerObj.EpdNTSEEADDRESS.split("^");
						if (arrayArea[0] && arrayArea[1]) {
							$('#cboAFPDomicileProvince').combobox('setValue',arrayArea[0]);
							$('#cboAFPDomicileProvince').combobox('setText',arrayArea[1]);
						}
						if (arrayArea[2] && arrayArea[3]) {
							$('#cboAFPDomicileCity').combobox('setValue',arrayArea[2]);
							$('#cboAFPDomicileCity').combobox('setText',arrayArea[3]);
						}
						if (arrayArea[4] && arrayArea[5]) {
							$('#cboAFPDomicileCounty').combobox('setValue',arrayArea[4]);
							$('#cboAFPDomicileCounty').combobox('setText',arrayArea[5]);
						}
						if (arrayArea[6] && arrayArea[7]) {
							$('#cboAFPDomicileVillage').combobox('setValue',arrayArea[6]);
							$('#cboAFPDomicileVillage').combobox('setText',arrayArea[7]);
						}
						$('#txtAFPDomicileRoad').val(arrayArea[8]).trigger('input')		//手动触发input事件
					}
				} else {
					$('.noLocalPlace').css('display','none');
					$('#cboAFPAdmRegion').combobox('clear');
					$('#dtAFPAdmPlaceDate').datebox('setValue','');
					$('#cboAFPDomicileProvince').combobox('clear');
					$('#cboAFPDomicileCity').combobox('clear');
					$('#cboAFPDomicileCounty').combobox('clear');
					$('#cboAFPDomicileVillage').combobox('clear');
					$('#txtAFPDomicileRoad').val('').trigger('input')
				}
			}
		})
		$('#cboAFPAdmRegion').combobox({
			onChange: function(newValue,oldValue) {
				if (ServerObj.EpdNTSEEADDRESS) {
					var arrayArea = ServerObj.EpdNTSEEADDRESS.split("^");
					if (newValue == 1) {				//本县区
						$('#cboAFPDomicileProvince').combobox('setValue',arrayArea[0]);
						$('#cboAFPDomicileProvince').combobox('setText',arrayArea[1]);
						$('#cboAFPDomicileCity').combobox('setValue',arrayArea[2]);
						$('#cboAFPDomicileCity').combobox('setText',arrayArea[3]);
						$('#cboAFPDomicileCounty').combobox('setValue',arrayArea[4]);
						$('#cboAFPDomicileCounty').combobox('setText',arrayArea[5]);
						$('#cboAFPDomicileVillage').combobox('setValue',arrayArea[6]);
						$('#cboAFPDomicileVillage').combobox('setText',arrayArea[7]);
						$('#txtAFPDomicileRoad').val(arrayArea[8]).trigger('input')
					} else if (newValue == 2) {		//本市其他县区
						$('#cboAFPDomicileProvince').combobox('setValue',arrayArea[0]);
						$('#cboAFPDomicileProvince').combobox('setText',arrayArea[1]);
						$('#cboAFPDomicileCity').combobox('setValue',arrayArea[2]);
						$('#cboAFPDomicileCity').combobox('setText',arrayArea[3]);
						$('#cboAFPDomicileCounty').combobox('clear');
						$('#cboAFPDomicileVillage').combobox('clear');
						$('#txtAFPDomicileRoad').val('').trigger('input')
					} else if (newValue == 3) {		//本省其它地市
						$('#cboAFPDomicileProvince').combobox('setValue',arrayArea[0]);
						$('#cboAFPDomicileProvince').combobox('setText',arrayArea[1]);
						$('#cboAFPDomicileCity').combobox('clear');
						$('#cboAFPDomicileCounty').combobox('clear');
						$('#cboAFPDomicileVillage').combobox('clear');
						$('#txtAFPDomicileRoad').val('').trigger('input')
					} else {						//外省、港澳台、外籍
						$('#cboAFPDomicileProvince').combobox('clear');
						$('#cboAFPDomicileCity').combobox('clear');
						$('#cboAFPDomicileCounty').combobox('clear');
						$('#cboAFPDomicileVillage').combobox('clear');
						$('#txtAFPDomicileRoad').val('').trigger('input')
					}
				}
			}
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
		$('#btnPrintMore').hide();	  // 打印按钮
		$('#btnRepeat').hide();		  // 复诊按钮
		$('#btnOmision').hide();      // 漏报
		$('#btnRevised').hide();      // 查看被订报告
		$('#btnOpenEMR').show();	  // 病例浏览
		if (PortalFlag != 1) {
			$('#btnClose').show();	    // 关闭窗口按钮 
		} else {
			$('#btnClose').hide();	    // 关闭窗口按钮 
		}
		//被订报告ID
		var MepdReportID = $m({                  
			ClassName:"DHCMed.EPD.Epidemic",
			MethodName:"GetRevised",
			aReportID:obj.ReportID
		},false);
		// 体检安全组隐藏关闭按钮
		if(session['LOGON.CTLOCDESC'] && session['LOGON.CTLOCDESC'].indexOf("体检")!="-1"){
			$('#btnClose').hide();
		}
		// 控制按钮权限，如果 LocFlag=1 代表院感办
		if (LocFlag != '0') {  //管理科室
			switch (RepStatus) {
				case "" : // 无报告
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();		 // 上报按钮
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnRepeat').show();      // 复诊按钮
					$('#btnOmision').show();     //  漏报
					break;
				case "6" : // 草稿
					$('#btnSaveTmp').show();   // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();	   // 上报按钮			
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnReturn').show();		// 退回按钮
					$('#btnDelete').show();		// 作废按钮
					$('#btnRepeat').show();     // 复诊按钮
					$('#btnOmision').show();    // 漏报
					break;
				case "1" : // 待审
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnCheck').show();		// 审核按钮
					$('#btnRepeat').show();     // 复诊按钮
					$('#btnReturn').show();		// 退回按钮
					$('#btnDelete').show();		// 作废按钮
					$('#btnPrintMore').show();	    // 打印按钮
					break;
				case "2" : // 已审
					$('#btnUpdoCheck').show();	// 取消审核按钮
					$('#btnPrintMore').show();	    // 打印按钮
					$('#btnUpdateCDC').show();  // 上报CDC按钮
					if (MepdReportID) {
						$('#btnRevised').show();    // 查看被订报告
					} else {
						$('#btnCorrect').show();    // 订正按钮
					}
					break;
				case "3" : // 订正
					$('#btnCorrect').show();    // 订正按钮
					$('#btnRevised').show();    // 查看被订报告
					$('#btnPrintMore').show();	    // 打印按钮
					$('#btnUpdateCDC').show();    //上报CDC按钮
					if (ServerObj.EpdReviseAllowCheck == 1) {
						$('#btnCheck').show();		// 审核按钮
					}
					break;
				case "4" : // 被订
					$('#btnPrintMore').show();	    // 打印按钮
					break;
				case "5" : // 退回
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnRepeat').show();     // 复诊按钮
					$('#btnDelete').show();		// 作废按钮
					break;
				case "7" : // 作废
					break;
				case "8" : // 复诊
					$('#btnOmision').show();    //  漏报
					$('#btnReturn').show();		// 退回按钮
					$('#btnDelete').show();		// 作废按钮
					break;
				case "9" : // 漏报
					$('#btnSave').show();	   // 上报按钮			
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnRepeat').show();    // 复诊按钮
					$('#btnDelete').show();	   // 作废按钮
					break;
			}
		} else {
			// 医生站
			switch (RepStatus) {
				case "" : // 无报告
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnRepeat').show();     // 复诊按钮
					break;
				case "6" : // 草稿
					$('#btnSaveTmp').show();    // 保存草稿按钮
					$('#btnSaveTmp').linkbutton({text:$g('草稿')});
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('报卡')});
					$('#btnDelete').show();		// 作废按钮
					$('#btnRepeat').show();     // 复诊按钮
					break;
				case "1" : // 待审
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:'修改报卡'});
					$('#btnRepeat').show();     // 复诊按钮
					$('#btnDelete').show();		// 作废按钮
					$('#btnPrintMore').show();	    // 打印按钮
					break;
				case "2" : // 已审
					if (MepdReportID) {
						$('#btnRevised').show();    // 查看被订报告
					} else {
						$('#btnCorrect').show();    // 订正按钮
					}
					$('#btnPrintMore').show();	    // 打印按钮
					break;
				case "3" : // 订正
					$('#btnCorrect').show();    // 订正按钮
					$('#btnRevised').show();    // 查看被订报告
					$('#btnPrintMore').show();	    // 打印按钮
					break;
				case "4" : // 被订
					break;
				case "5" : // 退回
					$('#btnSave').show();		// 上报按钮
					$('#btnSave').linkbutton({text:$g('修改报卡')});
					$('#btnRepeat').show();     // 复诊按钮
					$('#btnDelete').show();		// 作废按钮
					break;
				case "7" : // 作废
					break;
				case "8" : // 复诊
					$('#btnDelete').show();		// 作废按钮
					break;
				case "9" : // 漏报
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
		if (ServerObj.EpdRepeat==''){
			$('#btnRepeat').hide();   // 复诊按钮
		}
		if (ServerObj.EpdOmision==''){
			$('#btnOmision').hide();   // 漏报按钮
		}
		
		if ((RepStatus=='4')||(RepStatus=='7')){			
			obj.DisplayComps();
		}
		
		obj.AllowModAnyDiag = false;	//是否允许修改为任何的诊断
		// 是否允许临床和管理科室修改诊断
		if (obj.ReportID) {
			if((LocFlag == '0')&&(ServerObj.EpdClinicModDiag=="0")){	// LocFlag:0-医生站
				$("#cboDisease").combobox('disable')
			}
			if (LocFlag != '0') {										// LocFlag:1-管理科室
				if (ServerObj.EpdAdminModDiag=="0") {
					$("#cboDisease").combobox('disable')
				} else if (ServerObj.EpdAdminModDiag=="2") {
					obj.AllowModAnyDiag = true;
				}
			}
		}
		// 订正报告且配置信息允许订正之后修改诊断
		if (RepStatus=='3') {
			if (ServerObj.EpdRevisedModDiag=="0") {
				$('#cboDisease').combobox("disable");
			}
			if (LocFlag != '0') {
				if (ServerObj.EpdRevisedModDiag=="2") {
					obj.AllowModAnyDiag = true;
				}
			}
		}
		
		if (UploadCode=="Y"){
			$('#btnSaveTmp').hide();    // 保存草稿按钮
			$('#btnSave').hide();		// 上报按钮
			$('#btnCheck').hide();	    // 审核按钮
			$('#btnUpdoCheck').hide();	// 取消审核按钮
			$('#btnCorrect').hide();    // 订正按钮
			$('#btnReturn').hide();	    // 退回按钮
			$('#btnDelete').hide();     // 作废按钮
			$('#btnOmision').hide();    // 漏报按钮
			$('#btnRevised').hide();    // 查看被订按钮
			$('#btnRepeat').hide();     // 复诊按钮
			$('#btnClose').show();	    // 关闭窗口按钮 
		}
		obj.HideButton();
	};
	/*按钮显示与基础字典中的报告状态的字典项是否有效挂钩*/
	obj.HideButton = function(){
		// w ##Class(DHCMed.SSService.DictionarySrv).GetActiveByType("EpidemicReportStatus")
		var ButtonActiveArg = $m({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetActiveByType",
			argTypeCode:"EpidemicReportStatus"
		},false);
		for (var len=0; len < 9;len++) {        
			var ButtonDescArg 	= ButtonActiveArg.split('!!')[len];
			var ButtonDesc 		= ButtonDescArg.split('^')[0];
			var ButtonActive 	= ButtonDescArg.split('^')[1];
			if ((ButtonDesc=="作废")&&(ButtonActive==0)){
				$('#btnDelete').hide();       // 作废按钮
			}
			if ((ButtonDesc=="复诊")&&(ButtonActive==0)){
				$('#btnRepeat').hide();		  // 复诊按钮
			}
			if ((ButtonDesc=="已审")&&(ButtonActive==0)){
				$('#btnCheck').hide();	      // 审核按钮
				$('#btnUpdoCheck').hide();	  // 取消审核按钮
			}
			if ((ButtonDesc=="待审")&&(ButtonActive==0)){
				$('#btnSave').hide();		  // 上报按钮
			}
			if ((ButtonDesc=="漏报")&&(ButtonActive==0)){
				$('#btnOmision').hide();      // 漏报
			}
			if ((ButtonDesc=="草稿")&&(ButtonActive==0)){
				$('#btnSaveTmp').hide();      // 保存草稿按钮
			}
			if ((ButtonDesc=="订正")&&(ButtonActive==0)){
				$('#btnCorrect').hide();      // 订正按钮
			}
			if ((ButtonDesc=="退回")&&(ButtonActive==0)){
				$('#btnReturn').hide();	      // 退回按钮
			}           
		} 
	}
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
		$('#cboIsInEPD').combobox('disable');      //是否境外输入病例     add 20210120
		$('#cboProvince').combobox('disable');      //省
		$('#cboCity').combobox('disable');          //市
		$('#cboCounty').combobox('disable');        //县
		$('#cboVillage').combobox('disable');       //乡
		
		$('#txtContr').attr('disabled','disabled');	//入境前居住或旅行的国家或地区     add 20210120
		$('#txtOtherOccupation').attr('disabled','disabled');	//其他人群				add20200121
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
			else if ((DataType==4)||(DataType==6)||(DataType==10)) { //字典、字典多选、省市县乡
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
	// 传染病订正原因
	$('#winEPDReviseReason').dialog({
		title: '传染病报告订正原因',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,
		buttons:[{
			text:'保存',
			handler:function(){
				if ($('#cboReviseReason').combobox('getValue') == '') {
					$.messager.alert("提示", '请选择订正原因！', 'info');
					return;
				}
				obj.btnCorrect_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winEPDReviseReason').close();
			}
		}]
	});
	/*//  传染病审核意见
	$('#winEPDCheckOpinion').dialog({
		title: '传染病报告审核意见',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.SaveCheckOpinion();
				$HUI.dialog('#winEPDCheckOpinion').close();
				obj.btnCheck_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winEPDCheckOpinion').close();
			}
		}]
	});*/
	
	//判断某一元素在加载的html中是否存在
	function IsExist(obj) {
		if ($('#'+obj).length > 0) {
			return 1;
		}else {
			return 0;
		}
	}
	/*// 保存审核意见
	obj.SaveCheckOpinion = function(){  
		// 先获取有多少个审核意见字典项
		var objDicInfo = obj.GetDictionaryInfo("EPDCheckOpinion");
		if (objDicInfo.length<1) return;		
		for (var ind=0; ind < objDicInfo.length;ind++) {
			var DicID   = objDicInfo[ind].myid;
			var DicDesc = objDicInfo[ind].Description;
			if (DicDesc=="是否合格"){
				var Opinion = $("input[name='IsQualified']:checked").val();
			}
			if (DicDesc=="是否完整"){
				var Opinion = $("input[name='IsComplete']:checked").val();
			}
			if (DicDesc=="是否及时"){
				var Opinion = $("input[name='IsTimely']:checked").val();
			}
			var DicInputStr = "";
			var DicInputStr =DicInputStr + "^" + obj.ReportID;
			var DicInputStr =DicInputStr + "^" + DicID;
			var DicInputStr =DicInputStr + "^" + Opinion;
			var DicInputStr =DicInputStr + "^" + "";
			var DicInputStr =DicInputStr + "^" + "";
			var DicInputStr =DicInputStr + "^" + session['LOGON.USERID'];
			var retval  = $m({
				ClassName:"DHCMed.EPD.CheckOpinion",
				MethodName:"Update",
				aInputStr:DicInputStr,
				aSeparete:'^'
			},false);
		}
		return retval;
	}*/
}