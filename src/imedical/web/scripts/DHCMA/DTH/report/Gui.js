$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();       	
	
	obj.TemplateVersion = ServerObj.TemplateVersion;
	obj.SwitchPrint = ServerObj.SwitchPrint;
	obj.IsUpdatePatientInfo = ServerObj.IsUpdatePatientInfo;
	obj.DiagnoseUnit = ServerObj.DiagnoseUnit;
	obj.PrintValue = ServerObj.PrintValue;
	obj.OccupationList = ServerObj.OccupationList;
	obj.IsNewBorn = ServerObj.IsNewBorn;
	obj.PatEncryptLevel = ServerObj.PatEncryptLevel;
	obj.CardInfo = ServerObj.CardInfo;
	obj.MrNo = ServerObj.MrNo;
	obj.IsChild =ServerObj.IsChild;
	obj.MReportID =ServerObj.MReportID;
	obj.MaritalInfo =ServerObj.MaritalInfo;
	obj.EducationInfo =ServerObj.EducationInfo;
	
	obj.RepStatusCode = '';
	obj.IsActive = '';
    if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 
	
	//死亡证明报告权限
	if (typeof tDHCMedMenuOper=="undefined") {
		$.messager.alert("提示","您没有操作权限，请找相关人员增加权限!",'info');
		return;
	}
	//界面下拉框初始化
	//病人基本信息
	obj.cboCardType   = Common_ComboToDic("cboCardType","DTHCardType","",HospitalID);     // 证件类型
	obj.cboMarital    = Common_ComboToDic("cboMarital","DTHMarriage","",HospitalID);        // 婚姻状况
	obj.cboEducation  = Common_ComboToDic("cboEducation","DTHEducation","",HospitalID);     // 文化程度
	obj.cboOccupation = Common_ComboToDic("cboOccupation","DTHCareer","",HospitalID);       // 职业
	obj.cboWorkType   = Common_ComboToDic("cboWorkType","DMJOBTYPE","",HospitalID);         // 工作类型
	//户籍地址
	obj.cboRegProvince = Common_ComboToArea2("cboRegProvince","1");            // 省
	obj.cboRegCity = Common_ComboToArea2("cboRegCity","cboRegProvince");       // 市
	obj.cboRegCounty = Common_ComboToArea2("cboRegCounty","cboRegCity");       // 县
	obj.cboRegVillage = Common_ComboToArea2("cboRegVillage","cboRegCounty");   // 乡
	obj.RegCity = $HUI.combobox('#cboRegProvince', {
		onChange:function(newValue,oldValue){
			$('#cboRegCity').combobox('clear');
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
		}
	});
	obj.RegCounty = $HUI.combobox('#cboRegCity', {
		onChange:function(newValue,oldValue){
			$('#cboRegCounty').combobox('clear');
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
		}
	});
	obj.RegVillage = $HUI.combobox('#cboRegCounty', {
		onChange:function(newValue,oldValue){
			$('#cboRegVillage').combobox('clear');
			$('#txtRegRoad').val('');
		}
	});
	$HUI.combobox('#cboRegVillage', {
		onSelect:function(record){
			if (record) {
			    $('#txtRegRoad').val('');
				$('#txtRegAddress').val($('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText'));
			}
		}
	});
	//常住地址
	obj.cboCurrProvince = Common_ComboToArea2("cboCurrProvince","1");                   // 省
	obj.cboCurrCity = Common_ComboToArea2("cboCurrCity","cboCurrProvince");             // 市
	obj.cboCurrCounty = Common_ComboToArea2("cboCurrCounty","cboCurrCity");             // 县
	obj.cboCurrVillage = Common_ComboToArea2("cboCurrVillage","cboCurrCounty");         // 乡
	obj.CurrCity = $HUI.combobox('#cboCurrProvince', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCity').combobox('clear');
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
		}
	});
	obj.CurrCounty = $HUI.combobox('#cboCurrCity', {
		onChange:function(newValue,oldValue){
			$('#cboCurrCounty').combobox('clear');
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
		}
	});
	
	obj.CurrVillage = $HUI.combobox('#cboCurrCounty', {
		onChange:function(newValue,oldValue){
			$('#cboCurrVillage').combobox('clear');
			$('#txtCurrRoad').val('');
		}
	});
	$HUI.combobox('#cboCurrVillage', {
		onSelect:function(record){
			if (record) {
			    $('#txtCurrRoad').val('');
				$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText'));
			}
		}
	});
 
	obj.cboFamCardType = Common_ComboToDic("cboFamCardType","DTHCardType","",HospitalID);         //家属证件类型
	obj.cboFamRelation = Common_ComboToDic("cboFamRelation","DTHFamilyRelation","",HospitalID);   //家属与死者关系
	obj.cboDeathPlace  = Common_ComboToDic("cboDeathPlace","DTHDeathAddress","",HospitalID);      //死亡地点
	obj.cboPregnancies = Common_ComboToDic("cboPregnancies","DTHPregnancies","",HospitalID);      //妊娠期或终止妊娠42天内

	//死亡证明明细信息
    obj.cboAReason = Common_LookupToICD("cboAReason","txtAReasonICD");     //(a)直接导致死亡的疾病或情况
	obj.cboATime   = Common_ComboToDic("cboATime","DTHDeathTimes","",HospitalID);        //时间单位
	obj.cboBReason = Common_LookupToICD("cboBReason","txtBReasonICD");     //(b)引起(a)的疾病或情况
	obj.cboBTime   = Common_ComboToDic("cboBTime","DTHDeathTimes","",HospitalID);        //时间单位
	obj.cboCReason = Common_LookupToICD("cboCReason","txtCReasonICD");     //(c)引起(b)的疾病或情况
	obj.cboCTime   = Common_ComboToDic("cboCTime","DTHDeathTimes","",HospitalID);        //时间单位
	obj.cboDReason = Common_LookupToICD("cboDReason","txtDReasonICD");     //(d)引起(c)的疾病或情况
	obj.cboDTime   = Common_ComboToDic("cboDTime","DTHDeathTimes","",HospitalID);     
	obj.cboDamageDiagnose = Common_LookupToICD("cboDamageDiagnose","txtDamageDiagnoseICD");   //损伤中毒诊断
	obj.cboOtherDiagnose  = Common_LookupToICD("cboOtherDiagnose","txtOtherDiagnoseICD");     //其他诊断
	obj.cboOtherDiagnoseTime = Common_ComboToDic("cboOtherDiagnoseTime","DTHDeathTimes","",HospitalID);     //时间单位
	obj.cboDiagnoseUnit   = Common_ComboToDic("cboDiagnoseUnit","DTHDiagnoseUnit","",HospitalID);           //诊断单位
	obj.cboDiagnoseBasis  = Common_ComboToDic("cboDiagnoseBasis","DTHDiagnoseBasis","",HospitalID);         //诊断依据
	
	//调查记录
  	obj.cboExamRelation = Common_ComboToDic("cboExamRelation","DTHFamilyRelation","",HospitalID);  //与死者关系
	
    //根本死因
	obj.cboBaseReason = Common_LookupToICD("cboBaseReason","txtBaseReasonICD");  //根本死因
	obj.cboDamage     = Common_LookupToICD("cboDamage","txtDamageICD");          //损伤中毒
    $("#cboBaseReason").lookup({onSelect:function(index,rowData){
		 var ICD10=rowData['ICD10'];
		 $("#txtBaseReasonICD").val(ICD10);            //给相关的ICD10赋值
		 if($("#chkNewBorn").val())$("#txtICD10").val(ICD10);
	}});

	//5岁以下儿童死亡证明书
	obj.LoadChildInfo = function() {
		obj.cboSex = Common_ComboToDic("cboSex","DTCSex","",HospitalID);	                                    // 性别 1--男 2--女 3--性别不明
		obj.cboRegType = Common_ComboToDic("cboRegType","DTCRegType","",HospitalID);	                        // 户籍类型 1--本地户籍 2--非本地户籍居住1年以下 3--非本地户籍居住1年以上
		obj.cboWeightType = Common_ComboToDic("cboWeightType","DTCWeightType","",HospitalID);	                // 出生体重类别：1--测量 2--估计
		obj.cboBirthdayPlace = Common_ComboToDic("cboBirthdayPlace","DTCBirthdayPlace","",HospitalID);	    // 出生地点 1--省（市）医院 2--区县医院 3--街道（乡镇）卫生院 4--村（诊断）卫生室 5--途中  6--家中
		obj.cboDeathPosition = Common_ComboToDic("cboDeathPosition","DTCDeathPosition","",HospitalID);	    // 死亡地点 1--医院 2--途中 3--家中
		obj.cboCareBeforeDeath = Common_ComboToDic("cboCareBeforeDeath","DTCCareBeforeDeath","",HospitalID);	// 死亡前治疗 1--住院 2--门诊 3--未治疗
		obj.cboDiagnoseLv = Common_ComboToDic("cboDiagnoseLv","DTCDiagnoseLv","",HospitalID);	                // 诊断级别 1--省（市） 2--区县 3--街道（乡镇） 4--村（诊所） 5--未就诊
		obj.cboNotCareReason = Common_ComboToDic("cboNotCareReason","DTCNotCareReason","",HospitalID);	    // 未治疗或未就医主要原因 1--经济原因 2--交通不便 3--来不及送医院 4--家长认为病情不严重 5--风俗习惯 6--其他（请注明）
		obj.cboChildDiagBasis = Common_ComboToDic("cboChildDiagBasis","DTCDiagnoseBasis","",HospitalID);	    // 最高诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
		obj.cboCategory = Common_ComboToDic("cboCategory","DTCCategory","",HospitalID);	                    // 分类编号 01-痢疾 02--败血症 03-麻疹 ...
    }
	//孕产妇死亡登记副卡
	obj.LoadMaternalInfo = function() {
		//常住址
		obj.cboConProvince = Common_ComboToArea2("cboConProvince","1");               // 省
		obj.cboConCity = Common_ComboToArea2("cboConCity","cboConProvince");		  // 市
		obj.cboConCounty = Common_ComboToArea2("cboConCounty","cboConCity");          // 县
		obj.cboConVillage = Common_ComboToArea2("cboConVillage","cboConCounty");      // 乡
		obj.ConCity = $HUI.combobox('#cboConProvince', {
			onChange:function(newValue,oldValue){
				$('#cboConCity').combobox('clear');
				$('#cboConCounty').combobox('clear');
				$('#cboConVillage').combobox('clear');
			}
		});
		obj.ConCounty = $HUI.combobox('#cboConCity', {
			onChange:function(newValue,oldValue){
				$('#cboConCounty').combobox('clear');
				$('#cboConVillage').combobox('clear');
			}
		});
		
		obj.ConVillage = $HUI.combobox('#cboConCounty', {
			onChange:function(newValue,oldValue){
				$('#cboConVillage').combobox('clear');
			}
		});
		
		//现住址
		obj.cboTempProvince = Common_ComboToArea2("cboTempProvince","1");               // 省
		obj.cboTempCity = Common_ComboToArea2("cboTempCity","cboTempProvince");		    // 市
		obj.cboTempCounty = Common_ComboToArea2("cboTempCounty","cboTempCity");         // 县
		obj.cboTempVillage = Common_ComboToArea2("cboTempVillage","cboTempCounty");     // 乡
		obj.TempCity = $HUI.combobox('#cboTempProvince', {
			onChange:function(newValue,oldValue){
				$('#cboTempCity').combobox('clear');
				$('#cboTempCounty').combobox('clear');
				$('#cboTempVillage').combobox('clear');
			}
		});
		obj.TempCounty = $HUI.combobox('#cboTempCity', {
			onChange:function(newValue,oldValue){
				$('#cboTempCounty').combobox('clear');
				$('#cboTempVillage').combobox('clear');
			}
		});
		
		obj.TempVillage = $HUI.combobox('#cboTempCounty', {
			onChange:function(newValue,oldValue){
				$('#cboTempVillage').combobox('clear');
			}
		});
		
		obj.cboMRegType = Common_ComboToDic("cboMRegType","DTMRegType","",HospitalID);	// 户口 1. 本地    2. 非本地 
		obj.cboIsPlan = Common_ComboToDic("cboIsPlan","DTMIsPlan","",HospitalID);	// 计划内外
		obj.cboNation = Common_ComboToDic("cboNation","DTMNation","",HospitalID);	  //民族  1. 汉族   2. 少数民族 
		obj.cboMEducation = Common_ComboToDic("cboMEducation","DTMEducation","",HospitalID);	// 文化程度    1. 大专及以上  2. 高中或中专 3. 初中   4. 小学   5. 文盲
		obj.cboFamilIncome = Common_ComboToDic("cboFamilIncome","DTMFamilIncome","",HospitalID);	// 家庭年人均收入（元）1. <1000元   2. 1000元~   3. 2000元~   4. 4000元~   5. 8000元~ 
		obj.cboConType= Common_ComboToDic("cboConType","DTMConType","",HospitalID);	// 居住地区 1. 平原  2.山区  3. 其他地区 
		
		obj.radLastMenList = Common_chkRadioToDic("radLastMenList","DTMLastMenType",2);	    // 末次月经类型  0. 流产或分娩后未来月经而再次妊娠      1.不详
		obj.radDeliDateList = Common_chkRadioToDic("radDeliDateList","DTMDeliDateType",2);	// 分娩时间分类  0. 未分娩或28周以前流产      1. 不详 
		obj.radDeliveryPosList = Common_chkRadioToDic("radDeliveryPosList","DTMDeliveryPosition",5);    // 分娩地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院 4. 村接生室 5.家中    6. 途中    7. 其它    9.不详
		obj.radDeathPosList = Common_chkRadioToDic("radDeathPosList","DTMDeathPosition",5);             // 死亡地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院 4. 村接生室5.家中    6. 途中    7. 其它    9.不详
		obj.radDeliveryWayList = Common_chkRadioToDic("radDeliveryWayList","DTMDeliveryWay",5);         // 分娩方式  0. 未娩    1. 自然产   2. 阴道手术产  3. 剖宫产 
		obj.cboIsNewWay = Common_ComboToDic("cboIsNewWay","DTMIsNewWay","",HospitalID);	// 新法接生  1. 是      2. 否  
		obj.cboDeliveryer = Common_ComboToDic("cboDeliveryer","DTMDeliveryer","",HospitalID);	// 接生者    1. 医务人员  2. 乡村医生 3. 接生员  4. 其他人员 
		obj.cboIsPreCheck = Common_ComboToDic("cboIsPreCheck","DTMIsPreCheck","",HospitalID);	// 产前检查  1. 有      2. 无 
		obj.cboMDiagnoseBasis = Common_ComboToDic("cboMDiagnoseBasis","DTMDiagnoseBasis","",HospitalID);	// 死因诊断依据    1. 尸检   2. 病理    3. 临床   4. 死后推断  
		obj.cboMCategory = Common_ComboToDic("cboMCategory","DTMCategory","",HospitalID);	   // 死因分类    01流产   02异位妊娠  03妊娠剧吐 ...
		obj.radProResultList = Common_chkRadioToDic("radProResultList","DTMProResult",2);       //省级医疗保健机构评审结果  1. 可避免   2. 不可避免 
		obj.radProReasonList = Common_chkRadioToDic("radProReasonList","DTMProReason",3);       // 省级 影响死亡的主要因素       编号1    编号2  编号3
		obj.radConResultList = Common_chkRadioToDic("radConResultList","DTMCountryResult",2);       //国家级评审结果  1. 可避免   2. 不可避免 
		obj.radConReasonList = Common_chkRadioToDic("radConReasonList","DTMCountryReason",3);       // 国家 影响死亡的主要因素       编号1    编号2  编号3
	}	
	
	// ****************************** ↓↓↓ 弹出窗口
	//初始化-首联打印授权
	obj.UserSignOne = $('#UserSignOne').dialog({
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'确定',
			handler:function(){
				obj.InitPopStorageOneEvent();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#UserSignOne').window("close");
			}
		}]
	});
	//初始化-三联打印授权
	obj.UserSignThree = $('#UserSignThree').dialog({
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'确定',
			handler:function(){
				obj.InitPopStorageEvent();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#UserSignThree').window("close");
			}
		}]
	});
	
	//初始化-三联重复打印原因录入
	obj.PrintReason = $('#PrintReason').dialog({
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.InitPrintReasonThree();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#PrintReason').window("close");
			}
		}]
	});
	
	
	//初始化-纸单号
	var Title ='请录入纸单号：1~7位数字';
	if ((SSHospCode=="11-DT")||(SSHospCode=="11-XH")){
		Title ='纸单号';
	}
	obj.PaperNoWin = $('#PaperNoWin').dialog({
		title: Title,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.IsActive = obj.InitPaperNo();
			}
		},{
			text:'退出',
			handler:function(){
				$('#PaperNoWin').window("close");
			}
		}]
	});
    //******************************************弹出窗口 ↑↑↑ 
    
	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
