function check(arr){

	for (i = 0; i < arr.length; i++)
	{
		//检查这一行的值                 
		for (k = 0; k < arr.length - 1 - i; k++)
		{
			//当前元素
		var a = arr[i]; 

		//当前要对比的元素
		var b = arr[i + 1 + k];  
		if (b==0) {
			continue
		}
		if (a == b)
		{
			return "1";
			
		}
		}
	}
	return 0;
}
function InitReportWinEvent(obj) {
	obj.LoadEvent = function () {
		//搜索框[字典类别]事件
		$('#searchboxT').searchbox({
			searcher: function (value, name) {
				InitPatWin(value);
			}
		});
		// 按钮点击事件
		$('#btnSubmit').click(function (e) {
            var preStatusCode= obj.RepStatusCode
			if (!obj.CheckInputData(2)) {
				return;
			}
			if (obj.Save()) {
                if ((preStatusCode=="5")||(preStatusCode=="6")||(preStatusCode=="2")){
                }else{
                    InitPatWin(2);
                }
				$.messager.popover({ msg: '提交成功！', type: 'success', timeout: 2000 });
			} else {
				$.messager.alert("提示", '提交失败！', 'info');
			};
        });        $('#btnCheck').click(function (e) {
			if (!obj.CheckInputData(3)) {
				return;
			}
			if (obj.Save()) {
				InitPatWin(2);
				$.messager.popover({ msg: '审核成功！', type: 'success', timeout: 2000 });
			} else {
				$.messager.alert("提示", '审核失败！', 'info');
			};
		});
		$('#btnDelete').click(function (e) {
			obj.SaveStatus(4);

		});
		$('#btnReturn').click(function (e) {
			obj.SaveStatus(5);
		});
		$('#btnUnCheck').click(function (e) {
			obj.SaveStatus(6);
		});
		$('#btnExport').click(function (e) {
			var url = "dhccpmrunqianreport.csp?reportName=DHCMAHAICSSReport2020.raq&aReportID=" + ReportID + "&aEpisodeID=" + EpisodeID + "&aSurNumber=" + SurvNumber;
			websys_createWindow(url, 1, "width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		});
		$('#btnClose').click(function (e) {
			websys_showModal('close');
		});
		//点击摘要
		$('#btnAbstractMsg').click(function () {
			var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID=' + EpisodeID + '&PageType=WinOpen';
			websys_showModal({
				url: strUrl,
				title: '医院感染集成视图',
				iconCls: 'icon-w-epr',
				originWindow: window,
				closable: true,
				width: 1320,
				height: '95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
				onBeforeClose: function () {
				}
			});
		});
	}
	// 默认不存在抗菌用药时，下面的表单不可填写
	obj.radCSSIsAnti = function () {
		setTimeout(function () {
			var radCSSIsAnti = $('input[name="radCSSIsAnti"]:checked').val();
			if (radCSSIsAnti == 0) {
				$('#cboCSSMedPurpose').combobox('disable');
				$('#cboCSSCombinedMed').combobox('disable');
				$('#cboCSSZLSbmt').combobox('disable');
				$('#cboCSSISPYSAntiBefre').combobox('disable');
				$('#cboCSSMedPurpose').combobox('clear');
				$('#cboCSSCombinedMed').combobox('clear');
				$('#cboCSSZLSbmt').combobox('clear');
				$('#cboCSSISPYSAntiBefre').combobox('clear');
			}
		}, 100);
	}
	obj.InitButtons = function () {
		if (obj.AdminPower == 1) {
			obj.InitButtons = function () {
				$('.CSSButton').hide();
				//管理员
				switch (obj.RepStatusCode) {
					case '2':       // 提交
						$('#btnDelete').show();
						$('#btnSubmit').show();
						$('#btnExport').show();
						$('#btnCheck').show();
						//$('#btnReturn').show();
						$('#btnDelete').show();
						break;
					case '3':       // 审核
						$('#btnExport').show();
						$('#btnUnCheck').show();
						break;
					case '6':       // 取消审核
						$('#btnSubmit').show();
						$('#btnDelete').show();
						$('#btnCheck').show();
						$('#btnReturn').show();
						break;
					case '4':       // 删除
						break;
					case '5':       // 退回
						$('#btnSubmit').show();
						$('#btnDelete').show();
						break;
					default:
						$('#btnSubmit').show();
						break;
				}
			}
		} else {
			obj.InitButtons = function () {
				//临床
				$('.CSSButton').hide();
				switch (obj.RepStatusCode) {
					case '2':       // 提交
						$('#btnDelete').show();
						$('#btnSubmit').show();
						$('#btnExport').show();
						break;
					case '3':       // 审核
						$('#btnExport').show();
						break;
					case '6':       // 取消审核
						$('#btnSubmit').show();
						$('#btnDelete').show();
						break;
					case '4':       // 删除
						break;
					case '5':       // 退回
						$('#btnSubmit').show();
						$('#btnDelete').show();
						break;
					default:
						$('#btnSubmit').show();
						break;
				}
			}
		}
		//首次加载
		obj.InitButtons();
	}

	// 数据完整性验证
	obj.CheckInputData = function (statusCode) {
		obj.InputRep = obj.Rep_Save(statusCode);			// 报告主表信息
		obj.InputRepLog = obj.RepLog_Save(statusCode);		// 日志
		obj.InputPreFactors = ""; //obj.PreFactor_Save();		// 易感因素
		obj.InputInvasOpers = ""; //obj.InvasOper_Save();		// 侵害性操作
		obj.InputDiag = ""; //obj.DIAG_Save();			// 感染信息
		obj.InputOPS = ""; //obj.OPR_Save();				// 手术信息
		obj.InputLab = ""; //obj.LAB_Save();				// 病原学送检
		obj.InputAnti = ""; //obj.ANT_Save();				// 抗菌药物

		var CSSDiagnos = $("#cboCSSDiagnos").combobox('getValue');
		var CSSIsOpr = $("#cboCSSIsOpr").combobox('getValue');
		var CSSIncisionr = $("#cboCSSIncisionDr").combobox('getValue');
		var InfectionDr = $("#cboIRInfectionDr").combobox('getValue');
		var InfectionDesc = $("#cboIRInfectionDr").combobox('getText');
		var InfCategoryDr = $("#cboInfCategoryDr").combobox('getValue');
		var InfCategoryDesc = $("#cboInfCategoryDr").combobox('getText');

		if (CSSDiagnos == "") {
			$.messager.popover({ msg: '疾病诊断必填！', type: 'error', timeout: 2000 });
			return false;
		}
		if (InfectionDr == "") {
			$.messager.popover({ msg: '感染必填！', type: 'error', timeout: 2000 });
			return false;
		}
		var FirInfDate = "", cboYYInfPos1 = "", cboYYBacteria11 = "", cboYYBacteria12 = "", cboYYBacteria13 = "", cboYYInfPos2 = "", cboYYBacteria21 = "", cboYYBacteria22 = "", cboYYBacteria23 = "", cboYYInfPos3 = "", cboYYBacteria31 = "", cboYYBacteria32 = "", cboYYBacteria33 = "", CSSOperLung = ""
		var cboSQInfPos1 = "", cboSQBacteria11 = "", cboSQBacteria12 = "", cboSQBacteria13 = "", cboSQInfPos2 = "", cboSQBacteria21 = "", cboSQBacteria22 = "", cboSQBacteria23 = "", cboSQInfPos3 = "", cboSQBacteria31 = "", cboSQBacteria32 = "", cboSQBacteria33 = ""
		if (InfectionDesc == "存在") {
			if (InfCategoryDr == "") {
				$.messager.popover({ msg: '当感染存在时,感染分类必选！', type: 'error', timeout: 2000 });
				return false;
			}

			if (InfCategoryDesc == "社区感染") {

				cboSQInfPos1 = $("#cboSQInfPos1").combobox('getValue');
				cboSQBacteria11 = $("#cboSQBacteria11").attr('data-idField');    //$("#cboYYBacteria11").lookup("getValue")
				cboSQBacteria12 = $("#cboSQBacteria12").attr('data-idField');
				cboSQBacteria13 = $("#cboSQBacteria13").attr('data-idField');
				cboSQInfPos2 = $("#cboSQInfPos2").combobox('getValue');
				cboSQBacteria21 = $("#cboSQBacteria21").attr('data-idField');
				cboSQBacteria22 = $("#cboSQBacteria22").attr('data-idField');
				cboSQBacteria23 = $("#cboSQBacteria23").attr('data-idField');
				cboSQInfPos3 = $("#cboSQInfPos3").combobox('getValue');
				cboSQBacteria31 = $("#cboSQBacteria31").attr('data-idField');
				cboSQBacteria32 = $("#cboSQBacteria32").attr('data-idField');
				cboSQBacteria33 = $("#cboSQBacteria33").attr('data-idField');
				if (check([cboSQInfPos1,cboSQInfPos2,cboSQInfPos3])){
					$.messager.popover({ msg: '社区感染部位重复！', type: 'error', timeout: 2000 });
					return false;
				}
				if ((cboSQInfPos1 == "") && (cboSQInfPos2 == "") && (cboSQInfPos3 == "")) {
					$.messager.popover({ msg: '请选择社区感染部位！', type: 'error', timeout: 2000 });
					return false;
				}
			} else if (InfCategoryDesc == "医院感染") {
				FirInfDate = $("#dtFirInf").datebox('getValue');
				cboYYInfPos1 = $("#cboYYInfPos1").combobox('getValue');
				cboYYBacteria11 = $("#cboYYBacteria11").attr('data-idField');
				cboYYBacteria12 = $("#cboYYBacteria12").attr('data-idField');
				cboYYBacteria13 = $("#cboYYBacteria13").attr('data-idField');
				cboYYInfPos2 = $("#cboYYInfPos2").combobox('getValue');
				cboYYBacteria21 = $("#cboYYBacteria21").attr('data-idField');
				cboYYBacteria22 = $("#cboYYBacteria22").attr('data-idField');
				cboYYBacteria23 = $("#cboYYBacteria23").attr('data-idField');
				cboYYInfPos3 = $("#cboYYInfPos3").combobox('getValue');
				cboYYBacteria31 = $("#cboYYBacteria31").attr('data-idField');
				cboYYBacteria32 = $("#cboYYBacteria32").attr('data-idField');
				cboYYBacteria33 = $("#cboYYBacteria33").attr('data-idField');
				CSSOperLung = $("#cboCSSOperLung").combobox('getValue');
				if (check([cboYYInfPos1,cboYYInfPos2,cboYYInfPos3])){
					$.messager.popover({ msg: '医院感染部位重复！', type: 'error', timeout: 2000 });
					return false;
				}
				if ((cboYYInfPos1 == "") && (cboYYInfPos2 == "") && (cboYYInfPos3 == "")) {
					$.messager.popover({ msg: '请选择医院感染部位！', type: 'error', timeout: 2000 });
					return false;
				}
			} else if (InfCategoryDesc == "医院+社区") {
				FirInfDate = $("#dtFirInf").datebox('getValue');
				cboYYInfPos1 = $("#cboYYInfPos1").combobox('getValue');
				cboYYBacteria11 = $("#cboYYBacteria11").attr('data-idField');
				cboYYBacteria12 = $("#cboYYBacteria12").attr('data-idField');
				cboYYBacteria13 = $("#cboYYBacteria13").attr('data-idField');
				cboYYInfPos2 = $("#cboYYInfPos2").combobox('getValue');
				cboYYBacteria21 = $("#cboYYBacteria21").attr('data-idField');
				cboYYBacteria22 = $("#cboYYBacteria22").attr('data-idField');
				cboYYBacteria23 = $("#cboYYBacteria23").attr('data-idField');
				cboYYInfPos3 = $("#cboYYInfPos3").combobox('getValue');
				cboYYBacteria31 = $("#cboYYBacteria31").attr('data-idField');
				cboYYBacteria32 = $("#cboYYBacteria32").attr('data-idField');
				cboYYBacteria33 = $("#cboYYBacteria33").attr('data-idField');
				CSSOperLung = $("#cboCSSOperLung").combobox('getValue');
				cboSQInfPos1 = $("#cboSQInfPos1").combobox('getValue');
				cboSQBacteria11 = $("#cboSQBacteria11").attr('data-idField');
				cboSQBacteria12 = $("#cboSQBacteria12").attr('data-idField');
				cboSQBacteria13 = $("#cboSQBacteria13").attr('data-idField');
				cboSQInfPos2 = $("#cboSQInfPos2").combobox('getValue');
				cboSQBacteria21 = $("#cboSQBacteria21").attr('data-idField');
				cboSQBacteria22 = $("#cboSQBacteria22").attr('data-idField');
				cboSQBacteria23 = $("#cboSQBacteria23").attr('data-idField');
				cboSQInfPos3 = $("#cboSQInfPos3").combobox('getValue');
				cboSQBacteria31 = $("#cboSQBacteria31").attr('data-idField');
				cboSQBacteria32 = $("#cboSQBacteria32").attr('data-idField');
				cboSQBacteria33 = $("#cboSQBacteria33").attr('data-idField');
				if (check([cboSQInfPos1,cboSQInfPos2,cboSQInfPos3])){
					$.messager.popover({ msg: '社区感染部位重复！', type: 'error', timeout: 2000 });
					return false;
				}
				if (check([cboYYInfPos1,cboYYInfPos2,cboYYInfPos3])){
					$.messager.popover({ msg: '医院感染部位重复！', type: 'error', timeout: 2000 });
					return false;
				}
				if ((cboSQInfPos1 == "") && (cboSQInfPos2 == "") && (cboSQInfPos3 == "") ) {
					$.messager.popover({ msg: '请选择社区感染部位！', type: 'error', timeout: 2000 });
					return false;
				}
				if ((cboYYInfPos1 == "") && (cboYYInfPos2 == "") && (cboYYInfPos3 == "")){
					$.messager.popover({ msg: '请选择医院感染部位！', type: 'error', timeout: 2000 });
					return false;
				}
			}
		}
		if ($("#cboYYBacteria11").lookup('getText') == "") {
			cboYYBacteria11 = "";
		}
		if ($("#cboYYBacteria12").lookup('getText') == "") {
			cboYYBacteria12 = "";
		}
		if ($("#cboYYBacteria13").lookup('getText') == "") {
			cboYYBacteria13 = "";
		}
		if ($("#cboYYBacteria21").lookup('getText') == "") {
			cboYYBacteria21 = "";
		}
		if ($("#cboYYBacteria22").lookup('getText') == "") {
			cboYYBacteria22 = "";
		}
		if ($("#cboYYBacteria23").lookup('getText') == "") {
			cboYYBacteria23 = "";
		}

		if ($("#cboYYBacteria31").lookup('getText') == "") {
			cboYYBacteria31 = "";
		}
		if ($("#cboYYBacteria32").lookup('getText') == "") {
			cboYYBacteria32 = "";
		}
		if ($("#cboYYBacteria33").lookup('getText') == "") {
			cboYYBacteria33 = "";
		}
		if ($("#cboSQBacteria11").lookup('getText') == "") {
			cboSQBacteria11 = "";
		}
		if ($("#cboSQBacteria12").lookup('getText') == "") {
			cboSQBacteria12 = "";
		}
		if ($("#cboSQBacteria13").lookup('getText') == "") {
			cboSQBacteria13 = "";
		}
		if ($("#cboSQBacteria21").lookup('getText') == "") {
			cboSQBacteria21 = "";
		}
		if ($("#cboSQBacteria22").lookup('getText') == "") {
			cboSQBacteria22 = "";
		}
		if ($("#cboSQBacteria23").lookup('getText') == "") {
			cboSQBacteria23 = "";
		}
		if ($("#cboSQBacteria31").lookup('getText') == "") {
			cboSQBacteria31 = "";
		}
		if ($("#cboSQBacteria32").lookup('getText') == "") {
			cboSQBacteria32 = "";
		}
		if ($("#cboSQBacteria33").lookup('getText') == "") {
			cboSQBacteria33 = "";
		}
		var IsVD = Common_RadioValue("radIsVD");
		var IsANTVD = Common_RadioValue("radIsANTVD");
		var HBVInf = Common_RadioValue("cboHBVInf");
		var HCVInf = Common_RadioValue("cboHCVInf");
		var HIVInf = Common_RadioValue("cboHIVInf");
		var TPInf = Common_RadioValue("cboTPInf");

		var IsCa = Common_RadioValue("cboIsCa");
		var BloodMT = Common_RadioValue("cboBloodMT");
		var TNB = Common_RadioValue("cboTNB");
		var ARF = Common_RadioValue("cboARF");
		var ARI = Common_RadioValue("cboARI");
		var LC = Common_RadioValue("cboLC");
		var HM = Common_RadioValue("cboHM");
		var ISD = Common_RadioValue("cboISD");
		var Glucocorticoid = Common_RadioValue("cboGlucocorticoid");

		var CSSIsAnti = $("input[name='radCSSIsAnti']:checked").val();
		var CSSMedPurpose = $("#cboCSSMedPurpose").combobox('getValue');
		var CSSCombinedMed = $("#cboCSSCombinedMed").combobox('getValue');
		var CSSZLSbmt = $("#cboCSSZLSbmt").combobox('getValue');
		var CSSISPYSAntiBefre = $("#cboCSSISPYSAntiBefre").combobox('getValue');
		if (CSSIsAnti == "1") {
			if ((CSSMedPurpose == "") || (CSSCombinedMed == "")) {
				$.messager.popover({ msg: '存在抗菌药物使用时,目的和联用情况必选！', type: 'error', timeout: 2000 });
				return false;
			}
		}
		var CHR_35 = "#"
		var IRInfPathogen1 = cboYYInfPos1 + CHR_35 + cboYYBacteria11 + CHR_35 + CHR_35 + cboYYBacteria12 + CHR_35 + CHR_35 + cboYYBacteria13 + CHR_35;
		var IRInfPathogen2 = cboYYInfPos2 + CHR_35 + cboYYBacteria21 + CHR_35 + CHR_35 + cboYYBacteria22 + CHR_35 + CHR_35 + cboYYBacteria23 + CHR_35;
		var IRInfPathogen3 = cboYYInfPos3 + CHR_35 + cboYYBacteria31 + CHR_35 + CHR_35 + cboYYBacteria32 + CHR_35 + CHR_35 + cboYYBacteria33 + CHR_35;
		var IRComInfPathogen1 = cboSQInfPos1 + CHR_35 + cboSQBacteria11 + CHR_35 + CHR_35 + cboSQBacteria12 + CHR_35 + CHR_35 + cboSQBacteria13 + CHR_35;
		var IRComInfPathogen2 = cboSQInfPos2 + CHR_35 + cboSQBacteria21 + CHR_35 + CHR_35 + cboSQBacteria22 + CHR_35 + CHR_35 + cboSQBacteria23 + CHR_35;
		var IRComInfPathogen3 = cboSQInfPos3 + CHR_35 + cboSQBacteria31 + CHR_35 + CHR_35 + cboSQBacteria32 + CHR_35 + CHR_35 + cboSQBacteria33 + CHR_35;
		var TransBloodInf = IsVD + CHR_35 + IsANTVD + CHR_35 + HBVInf + CHR_35 + HCVInf + CHR_35 + HIVInf + CHR_35 + TPInf;
		var BaseRisk = IsCa + CHR_35 + BloodMT + CHR_35 + TNB + CHR_35 + ARF + CHR_35 + ARI + CHR_35 + LC + CHR_35 + HM + CHR_35 + ISD + CHR_35 + Glucocorticoid;

		var cboCSSSpecGL = $("#cboCSSSpecGL").combobox('getValue');
		var cboCSSSpecKS = $("#cboCSSSpecKS").combobox('getValue');
		var cboCSSSpecMZ = $("#cboCSSSpecMZ").combobox('getValue');
		var cboCSSSpecJY = $("#cboCSSSpecJY").combobox('getValue');

		var CRBugsAntiSen = "金黄色葡萄球菌"
			+ "||" + Common_CheckboxValue('chkMRB11')
			+ "||" + Common_CheckboxValue('chkMRB12')
			+ "#凝固酶阴性葡萄球菌"
			+ "||" + Common_CheckboxValue('chkMRB21')
			+ "||" + Common_CheckboxValue('chkMRB22')
			+ "#粪肠球菌"
			+ "||" + Common_CheckboxValue('chkMRB31')
			+ "||" + Common_CheckboxValue('chkMRB32')
			+ "#屎肠球菌"
			+ "||" + Common_CheckboxValue('chkMRB41')
			+ "||" + Common_CheckboxValue('chkMRB42')
			+ "#肺炎链球菌"
			+ "||" + Common_CheckboxValue('chkMRB51')
			+ "#大肠埃希菌"
			+ "||" + Common_CheckboxValue('chkMRB61')
			+ "||" + Common_CheckboxValue('chkMRB62')
			+ "||" + Common_CheckboxValue('chkMRB63')
			+ "#肺炎克雷伯菌"
			+ "||" + Common_CheckboxValue('chkMRB71')
			+ "||" + Common_CheckboxValue('chkMRB72')
			+ "||" + Common_CheckboxValue('chkMRB73')
			+ "#铜绿假单胞菌"
			+ "||" + Common_CheckboxValue('chkMRB81')
			+ "||" + Common_CheckboxValue('chkMRB82')
			+ "||" + Common_CheckboxValue('chkMRB83')
			+ "||" + Common_CheckboxValue('chkMRB84')
			+ "||" + Common_CheckboxValue('chkMRB85')
			+ "||" + Common_CheckboxValue('chkMRB86')
			+ "#鲍曼不动杆菌"
			+ "||" + Common_CheckboxValue('chkMRB91')
			+ "||" + Common_CheckboxValue('chkMRB92');
		
		cboSQMethod1 = $("#cboSQMethod1").combobox('getValue');
		cboSQMethod2 = $("#cboSQMethod2").combobox('getValue');
		cboSQMethod3 = $("#cboSQMethod3").combobox('getValue');
		
		var Input = "";    //CSSID
		Input += CHR_1 + EpisodeID;
		Input += CHR_1 + SurvNumber;
		Input = Input + CHR_1 + session['LOGON.USERNAME'];
		Input = Input + CHR_1 + "1";   						//是否有效   	//5
		Input = Input + CHR_1 + InfectionDr;
		Input = Input + CHR_1 + InfCategoryDr;      	 	//7
		Input = Input + CHR_1 + IRInfPathogen1;
		Input = Input + CHR_1 + IRInfPathogen2;
		Input = Input + CHR_1 + IRInfPathogen3;
		Input = Input + CHR_1 + CSSOperLung;
		Input = Input + CHR_1 + IRComInfPathogen1;
		Input = Input + CHR_1 + IRComInfPathogen2;
		Input = Input + CHR_1 + IRComInfPathogen3;   		//14
		Input = Input + CHR_1 + CSSIsOpr;
		Input = Input + CHR_1 + CSSIncisionr;
		Input = Input + CHR_1 + "";      	 			//手术日期
		Input = Input + CHR_1 + "";       				//手术名称
		Input = Input + CHR_1 + CRBugsAntiSen; 		    //细菌耐药情况
		Input = Input + CHR_1 + CSSIsAnti; 				//抗菌药物使用
		Input = Input + CHR_1 + ""; 					//抗菌药物名称 21
		Input = Input + CHR_1 + CSSMedPurpose; 			//目的
		Input = Input + CHR_1 + CSSCombinedMed; 		// 联用
		Input = Input + CHR_1 + CSSZLSbmt;				// 治疗用药已送细菌培养
		Input = Input + CHR_1 + CSSISPYSAntiBefre;		//送培养时机为抗菌药物使用前
		Input = Input + CHR_1 + "";						//报告是否完成    
		Input = Input + CHR_1 + "";
		Input = Input + CHR_1 + "";	       				 //28
		Input = Input + CHR_1 + $.LOGON.USERID;
		Input = Input + CHR_1 + CSSDiagnos;    			 //30  
		Input = Input + CHR_1 + FirInfDate;
		Input = Input + CHR_1 + TransBloodInf;
		Input = Input + CHR_1 + BaseRisk;

		Input = Input + CHR_1 + cboCSSSpecGL;   //34
		Input = Input + CHR_1 + cboCSSSpecKS;   //35
		Input = Input + CHR_1 + cboCSSSpecMZ;   //36
		Input = Input + CHR_1 + cboCSSSpecJY;   //37
		
		Input = Input + CHR_1 + cboSQMethod1;   //38
		Input = Input + CHR_1 + cboSQMethod2;   //39
		Input = Input + CHR_1 + cboSQMethod3;   //40
		
		obj.InputCSS = Input;

		if (obj.InputCSS == '') {
			return false;
		}
		return true
	}

	// 保存报告内容+状态
	obj.Save = function () {
		var ret = $m({
			ClassName: 'DHCHAI.IRS.INFReportSrv',
			MethodName: 'SaveINFReport',
			aRepInfo: obj.InputRep,
			aPreFactors: obj.InputPreFactors,
			aInvasOpers: obj.InputInvasOpers,
			aDiags: obj.InputDiag,
			aOPSs: obj.InputOPS,
			aLabs: obj.InputLab,
			aAntis: obj.InputAnti,
			aRepLog: obj.InputRepLog,
			aCSS: obj.InputCSS
		}, false)
		if (parseInt(ret) > 0) {
			ReportID = parseInt(ret);
			obj.refreshReportInfo();
			obj.InitButtons();
			var Url=window.location.href;
			Url=rewriteUrl(Url, {
				EpisodeID:obj.InputRep.split(CHR_1)[1],
				ReportID:ReportID,
				RepStatus:obj.InputRep.split(CHR_1)[7]
			});
			history.pushState("", "", Url);
		
			return true;
		} else {
			return false;
		}
	}

	// 保存报告状态
	obj.SaveStatus = function (statusCode) {
		var InputRepLog = obj.RepLog_Save(statusCode);	// 日志
		var ret = $m({
			ClassName: "DHCHAI.IRS.INFReportSrv",
			MethodName: "SaveINFReportStatus",
			aRepLog: InputRepLog,
			separete: CHR_1
		}, false)
		if (parseInt(ret) > 0) {
			obj.refreshReportInfo();
			obj.InitButtons();
			var Url=window.location.href;
			strLog=obj.InputRep.split(CHR_1)
			
			Url=rewriteUrl(Url, {
				ReportID:strLog[0],
				RepStatus:(strLog[1]=="4"?"1":"2")
			});
			history.pushState("", "", Url);
			RepStatus=Common_CheckboxValue('chkStatunit');
			InitPatWin(2);
			return true;
		} else {
			return false;
		}
	}

}

