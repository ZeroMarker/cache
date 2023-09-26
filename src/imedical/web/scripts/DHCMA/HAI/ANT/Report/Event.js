function InitReportWinEvent(obj){
	CheckSpecificKey();
	
	obj.LoadEvent = function(args){
		// 初始化报告信息
		obj.refreshReportInfo();
		obj.InitButtons();
		
	};

	obj.InitButtons = function(){
		// 初始化功能按钮
		$('#btnSubmit').hide();
		$('#btnCheck').hide();
		$('#btnDelete').hide();
		$('#btnReturn').hide();
		$('#btnUnCheck').hide();
		$('#btnClose').hide();
		switch (obj.StatusDesc){
			case '2': 	// 提交
				if(LocFlag==1){
					$('#btnSubmit').show();
					$('#btnDelete').show();
					$('#btnClose').show();
				}else{
					$('#btnSubmit').linkbutton({text:'修改'});
					$('#btnSubmit').show();
					$('#btnCheck').show();
					$('#btnDelete').show();
					$('#btnReturn').show();
					$('#btnClose').show();
				}
				break;
			case '3':    		// 审核
				if(LocFlag==1){
					$('#btnClose').show();
				}else{
					$('#btnUnCheck').show();
					$('#btnClose').show();
				}
				break;
			case '6':    // 取消审核
				if(LocFlag==1){
					$('#btnSubmit').show();
					$('#btnDelete').show();
					$('#btnClose').show();
				}else{
					$('#btnCheck').show();
					$('#btnDelete').show();
					$('#btnReturn').show();
					$('#btnClose').show();
				}
				break;
			case '4':      // 删除

				break;
			case '5':     // 退回
				if(LocFlag==1){
					$('#btnSubmit').show();
					$('#btnDelete').show();
					$('#btnClose').show();
				}else{
					$('#btnClose').show();
				}
				break;
			default:
				$('#btnSubmit').show();
				$('#btnClose').show();
				break;
		}
	}
	
	// 提交按钮click事件
	$('#btnSubmit').click(function (e) {
		//检查报告完整性
		var errInfo = obj.CheckReport();
		if (!errInfo){
			return ;
		}
    	if (obj.SaveReport('2')){
			$.messager.popover({msg: '提交成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("提示", '提交失败！', 'info');
    	};
	});
	
	// 审核按钮click事件
	$('#btnCheck').click(function (e) {
		//检查报告完整性
		var errInfo = obj.CheckReport();
		if (!errInfo){
			return ;
		}
    	if (obj.SaveReport('3')){
			$.messager.popover({msg: '审核成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("提示", '审核失败！', 'info');
    	};
	});
	
	// 删除按钮click事件
	$('#btnDelete').click(function (e) {
		$.messager.confirm("提示", "确认是否删除", function (r) {
			if (r){				
				if (obj.SaveRepStatus(4)){
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
				}else{
					$.messager.alert("提示", '删除失败！', 'info');
				};
			}
		});
	});
	
	// 退回按钮click事件
	$('#btnReturn').click(function (e) {
		$.messager.confirm("退回报告", "您确定要退回这份报告吗？", function(r){
			if (r){
				$.messager.prompt("退回报告", "请输入退回原因!", function(txt){
					if (txt){
						if(obj.SaveRepStatus(5,txt)){
							$.messager.popover({msg:  "退回成功！",type:'success',timeout: 2000});
						} else {
							$.messager.alert("提示", "退回失败！",'info');
						}
					}else if (txt==='') {
						$.messager.alert("提示", "未输入退回原因,报告不能退回！",'info');
					}
				});
			}
			
		});
	});
	
	// 取消审核按钮click事件
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveRepStatus(6)){
			$.messager.popover({msg: '取消审核成功！',type:'success',timeout: 2000});	
    	}else{
    		$.messager.alert("提示", '取消审核失败！', 'info');
    	};
	});
	
	//关闭按钮click事件
	$('#btnClose').click(function(e){
		websys_showModal('close');
	});
	
	$('#cboUseDrugRes').combobox('disable');	//设置默认不可编辑
	$HUI.combobox("#cboAdjustPlan",{
		onSelect:function(data){
			if (data.DicDesc=="其他"){
				$('#txtAdjustPlanTxt').attr('disabled',false);	
			}else{
				$('#txtAdjustPlanTxt').val('');
				$('#txtAdjustPlanTxt').attr('disabled',true);	
			}
		}
	});
	$('#cboAdjustPlan').combobox('disable');		//设置默认不可编辑
	$('#txtAdjustPlanTxt').attr('disabled',true);	//设置默认不可编辑
	$('#txtEndDate').datebox({   	//停药日期
		onSelect:function(date){
			if (date) {	
				$('#cboAdjustPlan').combobox("enable");
				$('#cboUseDrugRes').combobox("enable");
			}else{
				$('#cboAdjustPlan').combobox('clear');
				$('#cboAdjustPlan').combobox('disable');
				$('#cboUseDrugRes').combobox('clear');
				$('#cboUseDrugRes').combobox('disable');
			}
		}
	});
	
	$('#cboInfDiagnos').combobox('disable');		//设置默认不可编辑
	$('#chkIsInfection').checkbox({   	
		onCheckChange:function(e,value){
			if (value) {	
				$('#cboInfDiagnos').combobox('enable');
			}else{
				$('#cboInfDiagnos').combobox('clear');
				$('#cboInfDiagnos').combobox('disable');
			}
		}
	});
	
	
	$("input[name='chkUnReaction'][label='无']").checkbox({
		onCheckChange:function(e,value){
			if(value){
				$('#cboSpecimen').combobox('disable');
				$('#cboSpecimen2').combobox('disable');
				$('#cboSpecimen3').combobox('disable');
				$('#txtCollDate').datebox('disable');
				$('#txtCollDate2').datebox('disable');
				$('#txtCollDate3').datebox('disable');
				$('#txtAuthDate').datebox('disable');
				$('#txtAuthDate2').datebox('disable');
				$('#txtAuthDate3').datebox('disable');
			}else{
				$('#cboSpecimen').combobox('enable');
				$('#cboSpecimen2').combobox('enable');
				$('#cboSpecimen3').combobox('enable');
				$('#txtCollDate').datebox('enable');
				$('#txtCollDate2').datebox('enable');
				$('#txtCollDate3').datebox('enable');
				$('#txtAuthDate').datebox('enable');
				$('#txtAuthDate2').datebox('enable');
				$('#txtAuthDate3').datebox('enable');
			}
		}	
	});

	//双击列事件
	obj.openHandler = function(rowIndex,rowData){
		$('#cboSpecimen').combobox('setValue',rowData.SpecimenID);       //铜绿假单胞菌送检标本
		$('#cboSpecimen').combobox('setText',rowData.SpecimenDesc);
		$('#txtCollDate').datebox('setValue',rowData.CollDate);       //铜绿假单胞菌送检时间	
		$('#txtAuthDate').datebox('setValue',rowData.AuthDate);       //铜绿假单胞菌报告时间
		$('#cboSpecimen2').combobox('setValue',rowData.Specimen2ID);       //不动杆菌送检标本
		$('#cboSpecimen2').combobox('setText',rowData.Specimen2Desc);
		$('#txtCollDate2').datebox('setValue',rowData.CollDate2);       //不动杆菌送检时间	
		$('#txtAuthDate2').datebox('setValue',rowData.AuthDate2);       //不动杆菌报告时间
		$('#cboSpecimen3').combobox('setValue',rowData.Specimen3ID);       //肠杆菌送检标本
		$('#cboSpecimen3').combobox('setText',rowData.Specimen3Desc);
		$('#txtCollDate3').datebox('setValue',rowData.CollDate3);       //肠杆菌送检时间	
		$('#txtAuthDate3').datebox('setValue',rowData.AuthDate3);       //肠杆菌报告时间
		$('#txtDoseQty').val(rowData.OEDoseQty);		//剂量
		$('#txtFreq').val(rowData.OEFreqDesc);		    //用法
		$('#txtSttDate').datebox('setValue',rowData.OESttDate);         //用药日期
		$('#txtEndDate').datebox('setValue',rowData.OEXDate);           //停药日期
		if (rowData.OEXDate) {
			$('#cboAdjustPlan').combobox("enable");
			$('#cboUseDrugRes').combobox("enable");
		} else {
			$('#cboAdjustPlan').combobox('clear');
			$('#cboAdjustPlan').combobox('disable');
			$('#cboUseDrugRes').combobox('clear');
			$('#cboUseDrugRes').combobox('disable');
		}
		var AntiMastDesc = rowData.AntiMastDesc;
		if (AntiMastDesc) {	
			var AntiMastID = $m({
				ClassName : "DHCHAI.BTS.DictionarySrv",
				MethodName: "GetIDByDesc",
				aType: "ANTAntibiotic",
				aDesc: AntiMastDesc
			},false);
			$('#cboAntiDurg').combobox('setValue',AntiMastID);       //用药名称
			$('#cboAntiDurg').combobox('setText',AntiMastDesc);
		}
		
	}
	//取值报告信息
	obj.GetRepData = function(){
		var ReportDr        = obj.RepObj.ReportDr;                                  //报告ID
		var EpisodeDr       = obj.RepObj.EpisodeDr;	                                //就诊号
		var PatName         = obj.RepObj.PatName;		                            //姓名
		var MrNo            = obj.RepObj.MrNo;		                                //住院号
		var Age             = obj.RepObj.Age;			                            //患者年龄
		var Age             = parseInt(Age);
		var BabyMonth       = "";					                                //婴幼儿月龄
		var BabyDay         = "";                                                   //婴儿出生天数
		var Sex				= obj.RepObj.SexDesc;                                    //性别
		var OrdLocDr        = $('#cboOrdLoc').combobox('getValue');                 //科室
		var AdmDate         = obj.RepObj.AdmDate;                                   //入院日期
		var StatusCode      = '';                                                   //状态
		var Opinion         = "";                                                   //退回/作废原因
		if($('#txtRepStatus').val()!=''){
			debugger
			var RepDate     = obj.RepObj.RepDate;									//报告日期
			var RepTime		= obj.RepObj.RepTime; 									//报告时间
			var RepUserDr   = obj.RepObj.RepUserDr;       							//报告人
			var RepLocDr    = obj.RepObj.RepLocDr;                                  //报告科室
		}else{
			obj.RepDate     = Common_GetDate(new Date());
			var RepDate     = obj.RepDate;                                          //报告日期
			obj.RepTime     = Common_GetTime(new Date());
			var RepTime     = obj.RepTime;                                          //报告时间
			var RepUserDr   = $.LOGON.USERID;                                       //报告人
			var RepLocDr    = $.LOGON.LOCID;                                        //报告科室
		}
		var CheckDate       = "";                                                   //审核日期
		var CheckTime       = "";                                                   //审核时间	
		var CheckUserDr     = "";                                                   //审核人
		var AdmDiagnos      = $('#txtAdmDiagnos').val();                            //入院诊断
		var APACHEII        = $('#txtAPACHEII').val();                              //APACHEII评分		
		var InfPos          = $('#cboInfPos').combobox('getValue');                 //感染部位
		var InfDiagnos      = $('#cboInfDiagnos').combobox('getValue');             //感染诊断
		var IsInfection     = $('#chkIsInfection').checkbox('getValue')? '1':'0';   //是否院感	
		var Indication      = $('#cboIndication').combobox('getValue');	            //适应症
		var QuePower        = $('#cboQuePower').combobox('getValue');	            //处方权限
		var AntiDurg        = $('#cboAntiDurg').combobox('getValue');	            //用药名称
		var DoseQty         = $('#txtDoseQty').val();                               //剂量
		var Freq            = $('#txtFreq').val();                                  //用法
		var MonthTime       = $('#txtMonthTime').val();	                            //用药次数
		var SttDate         = $('#txtSttDate').datebox('getValue');	                //用药日期
		var EndDate         = $('#txtEndDate').datebox('getValue');                 //停药日期
		var AdjustPlan      = $('#cboAdjustPlan').combobox('getValue');             //调整方案
		var AdjustPlanT     = $('#cboAdjustPlan').combobox('getText');
		var AdjustPlanTxt   = $('#txtAdjustPlanTxt').val();                         //调整方案选择其他
		var UseDrugRes      = $('#cboUseDrugRes').combobox('getValue');             //用药效果
		var IsEtiologyEvi	= $HUI.radio("input[name='IsEtiologyEvi']").getValue()? '1':'0'
		var UnReaction      = Common_CheckboxValue("chkUnReaction");	            //不良反应
		var Specimen        = $('#cboSpecimen').combobox('getValue');	            //送检标本	
		var CollDate        = $('#txtCollDate').datebox('getValue');                //送检时间
		var AuthDate        = $('#txtAuthDate').datebox('getValue');	            //审核时间
		var Specimen2       = $('#cboSpecimen2').combobox('getValue');              //送检标本
		var CollDate2       = $('#txtCollDate2').datebox('getValue');               //送检时间
		var AuthDate2       = $('#txtAuthDate2').datebox('getValue');	            //审核时间
		var Specimen3       = $('#cboSpecimen3').combobox('getValue');              //送检标本
		var CollDate3       = $('#txtCollDate3').datebox('getValue');               //送检时间
		var AuthDate3       = $('#txtAuthDate3').datebox('getValue');               //审核时间
		
		var Input = ReportDr;                            //ID
		Input = Input + CHR_1 + EpisodeDr;               //就诊号
		Input = Input + CHR_1 + PatName;                 //姓名
		Input = Input + CHR_1 + MrNo;                    //登记号
		Input = Input + CHR_1 + Age;                     //年龄
		Input = Input + CHR_1 + BabyMonth;               //婴儿出生月龄
		Input = Input + CHR_1 + BabyDay;                 //婴儿出生天数
		Input = Input + CHR_1 + Sex;                   	 //性别
		Input = Input + CHR_1 + OrdLocDr;                //科室
		Input = Input + CHR_1 + AdmDiagnos;              //入院诊断
		Input = Input + CHR_1 + APACHEII;                //入ICU后初次APACHE II评分
		Input = Input + CHR_1 + AdmDate;                 //入院日期
		Input = Input + CHR_1 + StatusCode;              //状态(保存1、审核2)
		Input = Input + CHR_1 + Opinion;                 //操作意见
		Input = Input + CHR_1 + RepDate;                 //报告日期
		Input = Input + CHR_1 + RepTime;                 //报告时间
		Input = Input + CHR_1 + RepUserDr;               //报告人
		Input = Input + CHR_1 + RepLocDr;                //报告科室
		Input = Input + CHR_1 + CheckDate;               //审核日期
		Input = Input + CHR_1 + CheckTime;               //审核时间
		Input = Input + CHR_1 + CheckUserDr;             //审核人
		Input = Input + CHR_1 + IsInfection;             //是否感染
		Input = Input + CHR_1 + InfPos;                  //感染部位
		Input = Input + CHR_1 + InfDiagnos;              //感染诊断
		Input = Input + CHR_1 + Indication;              //适应症
		Input = Input + CHR_1 + QuePower;                //处方权限
		Input = Input + CHR_1 + AntiDurg;                //用药名称
		Input = Input + CHR_1 + MonthTime;               //用药次数(本月第几次用药)
		Input = Input + CHR_1 + SttDate;                 //用药日期
		Input = Input + CHR_1 + EndDate;                 //停药日期
		Input = Input + CHR_1 + Freq;                    //用法(频次)(*次/日)
		Input = Input + CHR_1 + DoseQty;                 //剂量(*g)
		Input = Input + CHR_1 + UseDrugRes;              //用药效果
		Input = Input + CHR_1 + AdjustPlan;              //调整方案
		Input = Input + CHR_1 + AdjustPlanTxt;           //调整方案其他
		Input = Input + CHR_1 + UnReaction.replace(/,/g,"#");  //不良反应
		Input = Input + CHR_1 + Specimen;                //送检标本
		Input = Input + CHR_1 + CollDate;                //送检时间
		Input = Input + CHR_1 + AuthDate;                //审核时间
		Input = Input + CHR_1 + Specimen2;               //送检标本2
		Input = Input + CHR_1 + CollDate2;               //送检时间2
		Input = Input + CHR_1 + AuthDate2;               //审核时间2
		Input = Input + CHR_1 + Specimen3;               //送检标本3
		Input = Input + CHR_1 + CollDate3;               //送检时间3
		Input = Input + CHR_1 + AuthDate3;               //审核时间3
		Input = Input + CHR_1 + IsEtiologyEvi;           //是否病原学送检
		Input = Input + CHR_1 + OrdItemID;
	
		return Input;
	}
	
	// 数据完整性验证
	obj.CheckReport = function(){
		var errinfo = "";
		var Sex				=$('#txtSex').val();								  
		if(Sex==""){
			errinfo = errinfo + "患者性别不能为空!<br>";
		}	  
		var OrdLocID		= $('#cboOrdLoc').combobox('getValue');
		if(OrdLocID==""){
			errinfo = errinfo + "医嘱科室不能为空！<br>";	
		}
		var InfPos          = $('#cboInfPos').combobox('getValue');                 //感染部位
		if(InfPos==""){
			errinfo = errinfo + "感染部位不能为空!<br>";
		}
		var InfDiagnos      = $('#cboInfDiagnos').combobox('getValue');             //感染诊断
		/*if(InfDiagnos==""){
			errinfo = errinfo + "感染诊断不能为空!<br>";
		}*/
		var IsInfection     = $('#chkIsInfection').checkbox('getValue')? '1':'0';   //是否院感
		if((IsInfection==1)&&(InfDiagnos=="")){
			errinfo = errinfo + "感染诊断不能为空!<br>";
		}
		var Indication      = $('#cboIndication').combobox('getValue');	            //适应症
		if(Indication==""){
			errinfo = errinfo + "适应症不能为空!<br>";
		}
		var QuePower        = $('#cboQuePower').combobox('getValue');	            //处方权限
		if(QuePower==""){
			errinfo = errinfo + "处方权限不能为空!<br>";
		}
		var AntiDurg        = $('#cboAntiDurg').combobox('getValue');	            //用药名称
		if(AntiDurg==""){
			errinfo = errinfo + "用药名称不能为空!<br>";
		}
		var DoseQty         = $('#txtDoseQty').val();                               //剂量
		if(DoseQty==""){
			errinfo = errinfo + "剂量不能为空!<br>";
		}
		/*var Freq            = $('#txtFreq').val();                                  //用法
		var regPos = /^\d+(\.\d+)?$/;
		if(Freq==""){
			errinfo = errinfo + "用法(次/日)不能为空!<br>";
		}else if(!regPos.test(Freq)){
			errinfo = errinfo + "用法(次/日)应该为数字!<br>";
		}*/
		var MonthTime       = $('#txtMonthTime').val();	                            //用药次数
		if(MonthTime==""){
			errinfo = errinfo + "本月第几次用药不能为空!<br>";
		}
		var SttDate         = $('#txtSttDate').datebox('getValue');	                //用药日期
		if(SttDate==""){
			errinfo = errinfo + "用药日期不能为空!<br>";
		}
		var EndDate         = $('#txtEndDate').datebox('getValue');                 //停药日期
		var AdjustPlan      = $('#cboAdjustPlan').combobox('getValue');             //调整方案
		var AdjustPlanT     = $('#cboAdjustPlan').combobox('getText');
		if((EndDate!="")&&(AdjustPlan=="")){
			errinfo = errinfo + "调整方案不能为空!<br>";
		}
		var AdjustPlanTxt   = $('#txtAdjustPlanTxt').val();                         //调整方案选择其他
		if ((EndDate!="")&&(AdjustPlanT=="其他")&&(AdjustPlanTxt=="")) {
			errinfo = errinfo + "其他调整方案不能为空!<br>";
		}
		var UseDrugRes      = $('#cboUseDrugRes').combobox('getValue');             //用药效果
		if((EndDate!="")&&(UseDrugRes=="")) {
			errinfo = errinfo + "用药效果不能为空!<br>";
		}
		var IsEtiologyEvi	= $HUI.radio("input[name='IsEtiologyEvi']").getValue()? '1':'0'
		if((IsEtiologyEvi==1)&&(objEti.gridEtiologyEvi.getRows().length==0)){
			errinfo = errinfo + "病原学证据为空!<br>";
		}
		var UnReaction      = Common_CheckboxLabel("chkUnReaction");	            //不良反应
		if((EndDate!="")&&(UnReaction=="")){
			errinfo = errinfo + "不良反应不能为空!<br>";
		}
		if ((UnReaction!="无")&&(UnReaction.indexOf("无")!=-1)){
			errinfo = errinfo + "不良反应中已选择“无”，不能勾选其他项目!<br>";
		}
		var Specimen        = $('#cboSpecimen').combobox('getValue');	            //送检标本
		var CollDate        = $('#txtCollDate').datebox('getValue');                //送检时间
		var AuthDate        = $('#txtAuthDate').datebox('getValue');	            //审核时间
		if(Specimen==""){
			if((CollDate)||(AuthDate)){
				errinfo = errinfo + "碳青霉烯耐药铜绿假单胞菌送检标本为空，不能填写送检时间、审核时间!<br>";
			}
		}else{
			if(Common_CompareDate(CollDate,AuthDate)>0){
				errinfo = errinfo + "碳青霉烯耐药铜绿假单胞菌送检时间不能在审核时间之后!<br>";
			}
		}
		var Specimen2       = $('#cboSpecimen2').combobox('getValue');              //送检标本
		var CollDate2       = $('#txtCollDate2').datebox('getValue');               //送检时间
		var AuthDate2       = $('#txtAuthDate2').datebox('getValue');	            //审核时间
		if(Specimen2==""){
			if((CollDate2)||(AuthDate2)){
				errinfo = errinfo + "碳青霉烯耐药不动杆菌送检标本为空，不能填写送检时间、审核时间!<br>";
			}
		}else{
			if(Common_CompareDate(CollDate2,AuthDate2)>0){
				errinfo = errinfo + "碳青霉烯耐药不动杆菌送检时间不能在审核时间之后!<br>";
			}
		}
		var Specimen3       = $('#cboSpecimen3').combobox('getValue');              //送检标本
		var CollDate3       = $('#txtCollDate3').datebox('getValue');               //送检时间
		var AuthDate3       = $('#txtAuthDate3').datebox('getValue');               //审核时间
		if(Specimen3==""){
			if((CollDate3)||(AuthDate3)){
				errinfo = errinfo + "碳青霉烯耐药肠杆菌送检标本为空，不能填写送检时间、审核时间!<br>";
			}
		}else{
			if(Common_CompareDate(CollDate3,AuthDate3)>0){
				errinfo = errinfo + "碳青霉烯耐药肠杆菌送检时间不能在审核时间之后!<br>";
			}
		}
		//判断ICU患者		
		var OrdLocDesc = $('#cboOrdLoc').combobox('getText');
		var APACHEII = $.trim($('#txtAPACHEII').val());
		if ((OrdLocDesc=="ICU")&&(APACHEII=="")) {
			errinfo = errinfo + "开医嘱科室为ICU科室，APACHE II评分不能为空!<br>";
		}																						 											   
		if (errinfo !='') {
			$.messager.alert("提示", errinfo, 'info');
			return  false;
		}
		return true;
	}
	// 保存报告（新建、提交）
	obj.SaveReport = function (aStatusCode,aOpinion){
		if (typeof(aStatusCode)=='undefined'){
			aStatusCode='';
		}
		if (typeof(aOpinion)=='undefined'){
			aOpinion='';
		}
		
		//报告信息
		var RepInfo    = obj.GetRepData();
		var EviInfo    = objEti.GetRepEviData();
		//操作状态信息
		var LogInfo = aStatusCode;           //状态（保存1、审核2）
		LogInfo += CHR_1 + $.LOGON.LOCID;     //操作科室
		LogInfo += CHR_1 + $.LOGON.USERID;    //操作人
		LogInfo += CHR_1 + aOpinion;           //处置意见
		var ret = $m({
			ClassName   : "DHCHAI.ANTS.ReportSrv",
			MethodName  : "SaveReport",
			aRepInfo    : RepInfo,
			aEviInfo    : EviInfo ,
			aLogInfo    : LogInfo,
			aSeparete   : CHR_1
		},false);
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshReportInfo();	// 初始化报告主表信息
    		obj.InitButtons();	// 初始化按钮
			
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:ReportID
		        });
		    	history.pushState("", "", Url);
		        return true;
			}
    		return true;
    	}else{
    		return false;
    	}
	}
	
	// 保存操作状态（审核、删除、退回、取消审核）
	obj.SaveRepStatus = function (aStatusCode,aOpinion){
		if (typeof(aStatusCode)=='undefined'){
			aStatusCode='';
		}
		if (typeof(aOpinion)=='undefined'){
			aOpinion='';
		}
		
		//操作状态信息
		var LogInfo = aStatusCode;           //状态（保存1、提交2、审核3、删除4、退回5、取消审核6）
		LogInfo += CHR_1 + $.LOGON.LOCID;     //操作科室
		LogInfo += CHR_1 + $.LOGON.USERID;    //操作人
		LogInfo += CHR_1 + aOpinion;           //处置意见
		
		var ret = $m({
			ClassName : "DHCHAI.ANTS.ReportSrv",
			MethodName: "SaveRepStatus",
			aReportID : ReportID,
			aLogInfo  : LogInfo,
			aSeparete : CHR_1
		},false);
    	if (parseInt(ret)>0){
    		obj.refreshReportInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}
	
	//初始化报告信息
	obj.refreshReportInfo = function(){
		
		if (ReportID) {
			var reportInfo = $cm({
				ClassName:"DHCHAI.ANTS.ReportSrv",
				QueryName:"QryAntiReport",
				aReportDr: ReportID,
				aEpisodeDr:EpisodeID
			},false)
			if(reportInfo.total>0){
				obj.RepObj = reportInfo.rows[0];
				$('#txtPatName').val(obj.RepObj.PatName);
				$('#txtMrNo').val(obj.RepObj.MrNo);
				$('#txtAge').val(obj.RepObj.Age);
				$('#txtSex').val(obj.RepObj.SexDesc);
				if (obj.RepObj.OrdLocDr){											   
					$('#cboOrdLoc').combobox('setValue',obj.RepObj.OrdLocDr);
					$('#cboOrdLoc').combobox('setText',obj.RepObj.OrdLocDesc);
				}
				$('#txtAdmDate').val(obj.RepObj.AdmDate);
				$('#txtDischDate').val(obj.RepObj.DischDate);
				$('#txtRepStatus').val(obj.RepObj.StatusDesc);
				obj.StatusDesc=obj.RepObj.StatusCode;
				var RepDateTime = obj.RepObj.RepDate + ' ' + obj.RepObj.RepTime;
				$('#txtRepDateTime').val(RepDateTime);
				
				$('#txtAdmDiagnos').val(obj.RepObj.Diagnos);	                   //入院诊断
				$('#txtAPACHEII').val(obj.RepObj.APACHEII);	                       //APACHE II评分
				$('#cboInfPos').combobox('setValue',obj.RepObj.InfPosDr);          //感染部位
				$('#cboInfPos').combobox('setText',obj.RepObj.InfPosDesc);
				$('#cboInfDiagnos').combobox('setValue',obj.RepObj.InfDiagnosDr)   //感染诊断
				$('#cboInfDiagnos').combobox('setText',obj.RepObj.InfDiagnosDesc);
				$('#chkIsInfection').checkbox('setValue', (obj.RepObj.IsInfection=='1' ? true:false));   //是否院感	
				$('#cboIndication').combobox('setValue',obj.RepObj.IndicationDr)   //适应症
				$('#cboIndication').combobox('setText',obj.RepObj.IndicationDesc);
				$('#cboQuePower').combobox('setValue',obj.RepObj.QuePowerDr)       //处方权限
				$('#cboQuePower').combobox('setText',obj.RepObj.QuePowerDesc);
				$('#cboAntiDurg').combobox('setValue',obj.RepObj.AntiDurgDr)       //用药名称
				$('#cboAntiDurg').combobox('setText',obj.RepObj.AntiDurgDesc);
				$('#txtDoseQty').val(obj.RepObj.DoseQty)                           //剂量
				$('#txtFreq').val(obj.RepObj.Freq)                                 //用法
				$('#txtMonthTime').val(obj.RepObj.MonthTime)                       //用药次数
				$('#txtSttDate').datebox('setValue',obj.RepObj.SttDate)            //用药日期
				$('#txtEndDate').datebox('setValue',obj.RepObj.EndDate)            //停药日期
				$('#cboAdjustPlan').combobox('setValue',obj.RepObj.AdjustPlanDr)   //调整方案
				$('#cboAdjustPlan').combobox('setText',obj.RepObj.AdjustPlanDesc);
				$('#txtAdjustPlanTxt').val(obj.RepObj.AdjustPlanTxt)               //其他调整方案
				$('#cboUseDrugRes').combobox('setValue',obj.RepObj.UseDrugResDr)   //用药效果
				$('#cboUseDrugRes').combobox('setText',obj.RepObj.UseDrugResDesc);
				$('#cboSpecimen').combobox('setValue',obj.RepObj.SpecimenDr)       //送检标本
				$('#cboSpecimen').combobox('setText',obj.RepObj.SpecimenDesc);
				$('#txtCollDate').datebox('setValue',obj.RepObj.CollDate)          //送检时间
				$('#txtAuthDate').datebox('setValue',obj.RepObj.AuthDate)          //报告(审核)时间
				$('#cboSpecimen2').combobox('setValue',obj.RepObj.Specimen2Dr)     //送检标本
				$('#cboSpecimen2').combobox('setText',obj.RepObj.Specimen2Desc);
				$('#txtCollDate2').datebox('setValue',obj.RepObj.CollDate2)        //送检时间
				$('#txtAuthDate2').datebox('setValue',obj.RepObj.AuthDate2)        //报告(审核)时间
				$('#cboSpecimen3').combobox('setValue',obj.RepObj.Specimen3Dr)     //送检标本
				$('#cboSpecimen3').combobox('setText',obj.RepObj.Specimen3Desc);
				$('#txtCollDate3').datebox('setValue',obj.RepObj.CollDate3)        //送检时间
				$('#txtAuthDate3').datebox('setValue',obj.RepObj.AuthDate3)        //报告(审核)时间
				
				//不良反应
				var UnReaction = obj.RepObj.UnReaction;
				UnReaction = '#' + UnReaction + '#';
				$("input[name='chkUnReaction']").each(function(){
					$(this).checkbox('setValue',false);
					var str = '#' + $(this).val() + '#';
					if (UnReaction.indexOf(str)>-1){
						$(this).checkbox('setValue',true);
					}
				})
				
				//加载病原学证据
				$cm({
					ClassName:"DHCHAI.ANTS.ReportSrv",
					QueryName:"QryEtiologyEvi",
					aReportID:ReportID
				},function(rs){
					$('#gridEtiologyEvi').datagrid('loadData', rs);		
					if (rs.total>0) {
						$HUI.radio("input[name='IsEtiologyEvi'][value='true']").setValue(true); //病原学证据
					}
				});
			
			} else {
				$.messager.alert("提示", '报告初始化失败！', 'info');
			}
		}else {
			var reportInfo = $cm({
				ClassName:"DHCHAI.ANTS.ReportSrv",
				QueryName:"QryAntiReport",
				aEpisodeDr:EpisodeID
			},false)
			if(reportInfo.total>0){
				obj.RepObj = reportInfo.rows[0];
				$('#txtPatName').val(obj.RepObj.PatName);
				$('#txtMrNo').val(obj.RepObj.MrNo);
				$('#txtAge').val(obj.RepObj.Age);
				$('#txtSex').val(obj.RepObj.SexDesc);
				$('#txtAdmDate').val(obj.RepObj.AdmDate);
				$('#txtDischDate').val(obj.RepObj.DischDate);
				$('#txtAdmDiagnos').val(obj.RepObj.AdmitDiag);
				$('#chkIsInfection').checkbox('setValue', (obj.RepObj.IsInfection=='1' ? true:false));   //是否院感	
				if ($('#txtEndDate').datebox('getValue')){
					var UnReactionInfo = $cm({
						ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
						QueryName:"QryUnReaction",
						aEpisodeDr:EpisodeID
					},false)
					$('#cboSpecimen').combobox('setValue',UnReactionInfo.SpecimenID)       //送检标本
					$('#cboSpecimen').combobox('setText',UnReactionInfo.SpecimenDesc);
					$('#txtCollDate').datebox('setValue',UnReactionInfo.CollDate)          //送检时间
					$('#txtAuthDate').datebox('setValue',UnReactionInfo.AuthDate)          //报告(审核)时间
					$('#cboSpecimen2').combobox('setValue',UnReactionInfo.Specimen2ID)     //送检标本
					$('#cboSpecimen2').combobox('setText',UnReactionInfo.Specimen2Desc);
					$('#txtCollDate2').datebox('setValue',UnReactionInfo.CollDate2)        //送检时间
					$('#txtAuthDate2').datebox('setValue',UnReactionInfo.AuthDate2)        //报告(审核)时间
					$('#cboSpecimen3').combobox('setValue',UnReactionInfo.Specimen3ID)     //送检标本
					$('#cboSpecimen3').combobox('setText',UnReactionInfo.Specimen3Desc);
					$('#txtCollDate3').datebox('setValue',UnReactionInfo.CollDate3)        //送检时间
					$('#txtAuthDate3').datebox('setValue',UnReactionInfo.AuthDate3)        //报告(审核)时间
				}
				
				if (OrdItemID) {
					var OrdInfo = $m({
						ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
						MethodName:"GeOrdItemInfo",
						aOrdItemID:OrdItemID
					},false);
					var arrOrd = OrdInfo.split("^");
					var OrdLocDesc =arrOrd[5]; 
					var OEDoseQty =arrOrd[6]; 
					var OEFreqDesc =arrOrd[8]; 
					var OESttDate =arrOrd[2]; 
					var OEXDate =arrOrd[3]; 
					var AntiMastDesc =arrOrd[11]; 
					
					if (OrdLocDesc) {	
						var OrdLocID = $m({   //根据开医嘱科室查找科室名称对应的字典ID
							ClassName : "DHCHAI.BTS.DictionarySrv",
							MethodName: "GetIDByDesc",
							aType: "ANTDepartment",
							aDesc: OrdLocDesc
						},false);
						if (OrdLocID) {
							$('#cboOrdLoc').combobox('setValue',OrdLocID);
							$('#cboOrdLoc').combobox('setText',OrdLocDesc);
						}
					}
					$('#txtDoseQty').val(OEDoseQty);		//剂量
					$('#txtFreq').val(OEFreqDesc);		    //用法
					$('#txtSttDate').datebox('setValue',OESttDate);         //用药日期
					$('#txtEndDate').datebox('setValue',OEXDate);           //停药日期
					if (OEXDate) {
						$('#cboAdjustPlan').combobox("enable");
						$('#cboUseDrugRes').combobox("enable");
					} else {
						$('#cboAdjustPlan').combobox('clear');
						$('#cboAdjustPlan').combobox('disable');
						$('#cboUseDrugRes').combobox('clear');
						$('#cboUseDrugRes').combobox('disable');
					}
				
					if (AntiMastDesc) {	
						var AntiMastID = $m({
							ClassName : "DHCHAI.BTS.DictionarySrv",
							MethodName: "GetIDByDesc",
							aType: "ANTAntibiotic",
							aDesc: AntiMastDesc
						},false);
						if(AntiMastID){								  
							$('#cboAntiDurg').combobox('setValue',AntiMastID);       //用药名称
							$('#cboAntiDurg').combobox('setText',AntiMastDesc);
						}
					}
				}
			}else {
				$.messager.alert("提示", '报告初始化失败！', 'info');
			}
		}
	}
}

