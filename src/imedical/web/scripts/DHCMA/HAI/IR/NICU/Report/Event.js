function InitNICUReportWinEvent(obj) {
	obj.ReportID=RepID;
	
    //更新按钮
    obj.InitButtons = function (RepStatus) {
        switch (RepStatus) {
            case 1:   //保存
                $('#btnSaveN').show();
                $('#btnSubmitN').show();
                $('#btnCheckN').hide();
                $('#btnDeleteN').show();
                break;
            case 2:    //提交
                $('#btnSaveN').hide();
                $('#btnSubmitN').hide();
                $('#btnCheckN').show();
                $('#btnDeleteN').show();
                break;
            case 3:    //审核
                $('#btnSaveN').hide();
                $('#btnSubmitN').hide();
                $('#btnCheckN').hide();
                $('#btnDeleteN').hide();
                break;
            case 4:   //删除
                $('#btnSaveN').hide();
                $('#btnSubmitN').hide();
                $('#btnCheckN').hide();
                $('#btnDeleteN').hide();
                break;
            default:
                $('#btnSaveN').show();
                $('#btnSubmitN').show();
                $('#btnCheckN').hide();
                $('#btnDeleteN').hide();
                break;
        }
    }
    //初始化NICU
    obj.LoadEvent = function () {
        //初始化患者基本信息
        var PaadmInfo = $cm({
            ClassName: "DHCHAI.DPS.PAAdmSrv",
            QueryName: "QryAdmInfo",
            aEpisodeID: Paadm
        }, false);
        if (PaadmInfo.total > 0) {
            var AdmInfo = PaadmInfo.rows[0];

            $('#pRegNoN').val(AdmInfo.PapmiNo);
            $('#pNameN').val(AdmInfo.PatName);
            $('#pNoN').val(AdmInfo.MrNo);
            $('#pSexN').val(AdmInfo.Sex);
            $('#pAgeN').val(AdmInfo.Age);
            $('#pAdmDateN').val(AdmInfo.AdmDate);
            $('#pDisDateN').val(AdmInfo.DischDate);
            $('#pPatWeightN').val(AdmInfo.AdmitWeight);
        }
        //初始化评分
        var RepInfo = $m({
            ClassName: "DHCHAI.IRS.INFReportSrv",
            MethodName: "GetICURepList",
            aRepID: RepID
        }, false);
        $('#APACHEN').val(RepInfo.split("^")[5]);

        obj.refreshgridNICUOE(Paadm, 0); //初始化医嘱
        obj.refreshPICCN1();  //刷新PICC
        obj.refreshVAPN();   //刷新VAP
        obj.refreshPICCN2();    //刷新UC

        var RepStatus = "";
        if (RepInfo.split("^")[1] == "保存") var RepStatus = 1;
        if (RepInfo.split("^")[1] == "提交") var RepStatus = 2;
        if (RepInfo.split("^")[1] == "审核") var RepStatus = 3;
        if (RepInfo.split("^")[1] == "删除") var RepStatus = 4;
        obj.InitButtons(RepStatus);
        
        if (RepInfo.split("^")[1] == "审核"){
	         $("#btnPICCAddN1").linkbutton("disable");
	         $("#btnPICCDelN1").linkbutton("disable");
	         $("#btnVAPAddN").linkbutton("disable");
			 $("#btnVAPDelN").linkbutton("disable");
			 $("#btnPICCAddN2").linkbutton("disable");
			 $("#btnPICCDelN2").linkbutton("disable");
	        }
        if (RepInfo.split("^")[1] == "删除"){
	        $("#btnPICCAddN1").linkbutton("disable");
	         $("#btnPICCDelN1").linkbutton("disable");
	         $("#btnVAPAddN").linkbutton("disable");
			 $("#btnVAPDelN").linkbutton("disable");
			 $("#btnPICCAddN2").linkbutton("disable");
			 $("#btnPICCDelN2").linkbutton("disable");
	        }
    };
    //刷新患者医嘱明细
    obj.refreshgridNICUOE = function (iPaAdm, iFlag) {
        $("#gridNICUOE").datagrid("loading");
        $cm({
            ClassName: "DHCHAI.IRS.ICULogSrv",
                QueryName: "QryICUAdmOeItem",
                aPaAdm: iPaAdm,
                aFlag: iFlag,
                page: 1,
                rows: 999
        }, function (rs) {
            $('#gridNICUOE').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    
	//ICU三管医嘱点击
    $("#btnICUAllN").on('click', function () {
        $('#btnICUAllN').css("background-color", "#dbedf9");
        $('#btnICUPICCN').css("background-color", "white");
        $('#btnICUVAPN').css("background-color", "white");
        obj.refreshgridNICUOE(Paadm, 0);
    })
    $("#btnICUPICCN").on('click', function () {
        $('#btnICUAllN').css("background-color", "white");
        $('#btnICUPICCN').css("background-color", "#dbedf9");
        $('#btnICUVAPN').css("background-color", "white");
        obj.refreshgridNICUOE(Paadm, 1);
    })
    $("#btnICUVAPN").on('click', function () {
        $('#btnICUAllN').css("background-color", "white");
        $('#btnICUPICCN').css("background-color", "white");
        $('#btnICUVAPN').css("background-color", "#dbedf9");
        obj.refreshgridNICUOE(Paadm, 2);
   })
    //保存登记表
    $('#btnSaveN').on('click', function () {
            //APACHEⅡ评分
        var IRAPACHEScore = $('#APACHEN').val();
        if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
            $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
            return;
        }

        var ret = obj.RepSaveN("3", "1");
        if (parseInt(ret) > 0) {
            $.messager.alert("提示", "保存成功!", 'info');
            obj.InitButtons(1);
        }
        else {
            $.messager.alert("提示", "保存失败!", 'info');
        }
    });
    
	//提交登记表
    $('#btnSubmitN').on('click', function () {
            //APACHEⅡ评分
        var IRAPACHEScore = $('#APACHEN').val();
        if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
            $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
            return;
        }
        var ret = obj.RepSaveN("3", "2");
        if (parseInt(ret) > 0) {
            $.messager.alert("提示", "提交成功!", 'info');
            obj.InitButtons(2);
            }
        else {
            $.messager.alert("提示", "提交失败!", 'info');
		}
	})
     
	 //审核登记表
    $('#btnCheckN').on('click', function () {
            //APACHEⅡ评分
        var IRAPACHEScore = $('#APACHEN').val();
        if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
            $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
            return;
        }

        var ret = obj.RepSaveN("3", "3");
        if (parseInt(ret) > 0) {
            $.messager.alert("提示", "审核成功!", 'info');
            obj.InitButtons(3);
		}
        else {
            $.messager.alert("提示", "审核失败!", 'info');
        }
    })
                //删除登记表
    $('#btnDeleteN').on('click', function () {
            //APACHEⅡ评分
        var IRAPACHEScore = $('#APACHEN').val();
        if ((IRAPACHEScore != "") && (IRAPACHEScore > 71)) {
            $.messager.alert("错误提示", "APACHEⅡ评分数据错误，请录入不大于71的0-9的数字!", 'info');
            return;
        }
        $.messager.confirm("提示", "确认是否删除", function (r) {				
			if (r) {				
				var ret = obj.RepSaveN("3", "4");
				if (parseInt(ret) > 0) {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                	obj.InitButtons(4);
                	return;
					
				} else {
					$.messager.alert("提示", "删除失败!", 'info');		
				}
			}
		});
	})
    obj.RepSaveN = function (repType, repStatus) {
        var ID =obj.ReportID;
        
        //var Paadm = Paadm;
        var IRRepType = "3";   //ICU调查表类型
        var IRRepDate = "";
        var IRRepTime = "";     //报告时间
        var IRRepLocDr = LocDr;  //调查科室 ？= 当前科室 Data.LocID
        var IRRepUser = $.LOGON.USERID;   //$.LOGON.USERID
        var IRStatusDr = repStatus;
        var IRLinkDiags = "";   // 感染诊断
        var IRLinkICDs = "";    //疾病诊断
        var IRLinkLabs = "";    //IRLinkAntis
        var IRLinkAntis = "";
        var IRLinkOPSs = "";  //
        var IRLinkMRBs = "";
        var IRLinkInvOpers = "";  //
        var IRLinkPreFactDrs = ""; //易感因素
        var IRLinkICUUCs = "";  //

        var IRLinkICUVAPs = "";  //呼吸机

        var IRLinkICUPICCs = "";

        var IRDiagnosisBasis = ""; //诊断依据
        var IRDiseaseCourse = ""; //
        var IRInLocDr = "";  //入科来源
        var IROutLocDr = "";    //出科方向
        var IRInDate = ""; //入科时间
        var IROutDate = ""; //出科时间 

        var IROutIntubats = ""; //出ICU带管情况 List # 分割多个值
        var IROut48Intubats = ""; //出ICU48带管情况 list  # 分割多个值
        //APACHEⅡ评分
        var IRAPACHEScore = $('#APACHEN').val();
        if (repType == "2") {

        }
        else if (repType == "3") {
	        //保存体重 没有体重=体重必填 and 回写到护理记录 出生体重里
            var patWeight = $('#pPatWeightN').val();
            if (patWeight == "") {
                $.messager.alert("错误提示", "出生体重不允许为空!", 'info');
                return;
            }
            var rstW = $m({
                ClassName: "DHCHAI.DPS.PAAdmSrv",
                MethodName: "UpdateWeight",
                aEpisodeID: Paadm,
                aPatWeight: patWeight
            }, false);
            if (rstW!= "1") {
                $.messager.alert("错误提示", "出生体重保存失败!", 'info');
                return;
            }
            //PICC
            var rows = $('#gridPICCN1').datagrid('getRows');
            var IRLinkICUPICCs = "";
            for (var i = 0; i < rows.length; i++) {
             
                var InputStr = rows[i].ID;;
                InputStr += "^" + Paadm;
                InputStr += "^" + LocDr;
                InputStr += "^" + rows[i].IRIntuDate;
                InputStr += "^" + "";
                InputStr += "^" + rows[i].IRExtuDate;
                InputStr += "^" + "";
                InputStr += "^" + rows[i].IRPICCType;
                InputStr += "^" + rows[i].IRPICCCnt;
                InputStr += "^" + rows[i].IRPICCPos;
                InputStr += "^" + rows[i].IROperDoc;
                InputStr += "^" + rows[i].IROperLoc;
                InputStr += "^" + rows[i].IRIsInf;
                InputStr += "^" + rows[i].IRInfDate;
                InputStr += "^" + rows[i].IRInfSymptoms;
                InputStr += "^" + rows[i].IRBacteria;
                InputStr += "^" + $.LOGON.USERID;
                InputStr += "^" + 0;     //是否审核
        // var InputStr = ID;
        // InputStr += "^" + Paadm;
        // InputStr += "^" + LocID;
        // InputStr += "^" + IRIntuDate;
        // InputStr += "^" + "";
        // InputStr += "^" + IRExtuDate;
        // InputStr += "^" + "";
        // InputStr += "^" + IRPICCType;
        // InputStr += "^" + IRPICCCnt;
        // InputStr += "^" + IRPICCPos;
        // InputStr += "^" + IROperDoc;
        // InputStr += "^" + IROperLoc;
        // InputStr += "^" + IRIsInf;
        // InputStr += "^" + IRInfDate;
        // InputStr += "^" + IRInfSymptoms;
        // InputStr += "^" + IRBacteria;
        // InputStr += "^" + UpdateUserDr;
        // InputStr += "^" + 0;     //是否审核
                var flg = $m({
                    ClassName: "DHCHAI.IR.INFICUPICC",
                    MethodName: "Update",
                    InStr: InputStr,
                    aSeparete: "^"
                }, false);
                if (parseInt(flg) <= 0) {
                    $.messager.alert("错误提示", "中央导管第" + i + 1 + "条数据保存失败!", 'info');
                    obj.gridPICCN1.deleteRow(  //删除一个新行
                        rows[i])
                    return;
                }
                else {
                    if (IRLinkICUPICCs == "") {
                        IRLinkICUPICCs = rows[i].ID;
                    }
                    else {
                        IRLinkICUPICCs = IRLinkICUPICCs + "," + rows[i].ID;
                    }
                   
                }

            }
            obj.refreshPICCN1()
            //VAP
            var rows = $('#gridVAPN').datagrid('getRows');
            var IRLinkICUVAPs = "";

            for (var i = 0; i < rows.length; i++) {
               
                var InputStr = rows[i].ID;;
                InputStr += "^" + Paadm;
                InputStr += "^" + LocDr;
                InputStr += "^" + rows[i].IRIntuDate;
                InputStr += "^" + "";
                InputStr += "^" + rows[i].IRExtuDate;
                InputStr += "^" + "";
                InputStr += "^" + rows[i].IRVAPType;
                InputStr += "^" + rows[i].IROperDoc;
                InputStr += "^" + rows[i].IROperLoc;
                InputStr += "^" + rows[i].IRIsInf;
                InputStr += "^" + rows[i].IRInfDate;
                InputStr += "^" + rows[i].IRInfSymptoms;
                InputStr += "^" + rows[i].IRBacteria;
                InputStr += "^" + $.LOGON.USERID;
                InputStr += "^" + 0;     //是否审核
        // InputStr += "^" + Paadm;
        // InputStr += "^" + LocID;
        // InputStr += "^" + IRIntuDate;
        // InputStr += "^" + IRIntuTime;
        // InputStr += "^" + IRExtuDate;
        // InputStr += "^" + IRExtuTime;
        // InputStr += "^" + IRVAPType;
        // InputStr += "^" + IROperDoc;
        // InputStr += "^" + IROperLoc;
        // InputStr += "^" + IRIsInf;
        // InputStr += "^" + IRInfDate;
        // InputStr += "^" + IRInfSymptoms;
        // InputStr += "^" + IRBacteria;
        // InputStr += "^" + UpdateUserDr;
        // InputStr += "^" + 0;     //是否审核
                var flg = $m({
                    ClassName: "DHCHAI.IR.INFICUVAP",
                    MethodName: "Update",
                    InStr: InputStr,
                    aSeparete: "^"
                }, false);
                if (parseInt(flg) <= 0) {
                    $.messager.alert("错误提示", "气管插拔第" + i + 1 + "条数据保存失败!", 'info');
                    obj.gridPICCN1.deleteRow(  //删除一个新行
                        rows[i])
                    return;
                }
                else {
                    if (IRLinkICUVAPs == "") {
                        IRLinkICUVAPs = rows[i].ID;
                    }
                    else {
                        IRLinkICUVAPs = IRLinkICUVAPs + "," + rows[i].ID;
                    }
                   
                }

            }
            obj.refreshVAPN()

                //UC
            var rows = $('#gridPICCN2').datagrid('getRows');
            var IRLinkICUUCs = "";  
            for (var i = 0; i < rows.length; i++) {           
                var InputStr = rows[i].ID;;
                InputStr += "^" + Paadm;
                InputStr += "^" + LocDr;
                InputStr += "^" + rows[i].IRIntuDate;
                InputStr += "^" + "";
                InputStr += "^" + rows[i].IRExtuDate;
                InputStr += "^" + "";
                InputStr += "^" + rows[i].IRUCType;
                InputStr += "^" + rows[i].IROperDoc;
                InputStr += "^" + rows[i].IROperLoc;
                InputStr += "^" + rows[i].IRIsInf;
                InputStr += "^" + rows[i].IRInfDate;
                InputStr += "^" + rows[i].IRInfSymptoms;
                InputStr += "^" + rows[i].IRBacteria;
                InputStr += "^" + $.LOGON.USERID;
                InputStr += "^" + 0;     //是否审核
     // InputStr += "^" + Paadm;
        // InputStr += "^" + LocID;
        // InputStr += "^" + IRIntuDate;
        // InputStr += "^" + IRIntuTime;
        // InputStr += "^" + IRExtuDate;
        // InputStr += "^" + IRExtuTime;
        // InputStr += "^" + IRUCType;
        // InputStr += "^" + IROperDoc;
        // InputStr += "^" + IROperLoc;
        // InputStr += "^" + IRIsInf;
        // InputStr += "^" + IRInfDate;
        // InputStr += "^" + IRInfSymptoms;
        // InputStr += "^" + IRBacteria;
        // InputStr += "^" + UpdateUserDr;
        // InputStr += "^" + 0;     //是否审核

                var flg = $m({
                    ClassName: "DHCHAI.IR.INFICUUC",
                    MethodName: "Update",
                    InStr: InputStr,
                    aSeparete: "^"
                }, false);
                if (parseInt(flg) <= 0) {
                    $.messager.alert("错误提示", "脐静脉第" + i + 1 + "条数据保存失败!", 'info');
                    obj.gridPICCN1.deleteRow(  //删除一个新行
                        rows[i])
                    return;
                }
                else {
                    if (IRLinkICUUCs == "") {
                        IRLinkICUUCs = rows[i].ID;
                    }
                    else {
                        IRLinkICUUCs = IRLinkICUUCs + "," + rows[i].ID;
                    }
                   
                }

            }
            obj.refreshPICCN2()
        }
        var InputStr = ID;
        InputStr += "^" + Paadm;
        InputStr += "^" + IRRepType;
        InputStr += "^" + IRRepDate;
        InputStr += "^" + IRRepTime;
        InputStr += "^" + IRRepLocDr;
        InputStr += "^" + IRRepUser;  //
        InputStr += "^" + IRStatusDr;
        InputStr += "^" + IRLinkDiags;
        InputStr += "^" + IRLinkICDs;
        InputStr += "^" + IRLinkLabs;
        InputStr += "^" + IRLinkAntis;
        InputStr += "^" + IRLinkOPSs;
        InputStr += "^" + IRLinkMRBs;
        InputStr += "^" + IRLinkInvOpers;
        InputStr += "^" + IRLinkPreFactDrs;
        InputStr += "^" + IRLinkICUUCs;
        InputStr += "^" + IRLinkICUVAPs;
        InputStr += "^" + IRLinkICUPICCs;
        InputStr += "^" + IRInLocDr;
        InputStr += "^" + IROutLocDr;
        InputStr += "^" + IRInDate;
        InputStr += "^" + IROutDate;
        InputStr += "^" + IRAPACHEScore;
        InputStr += "^" + IROutIntubats;
        InputStr += "^" + IROut48Intubats;

        var retval = $m({
            ClassName: "DHCHAI.IRS.INFReportSrv",
            MethodName: "UpdateReport",
            aInputStr: InputStr,
            aSeparete: "^"
        }, false);

        obj.ReportID = retval;
        return retval;
    }
    //NICU->中心静脉表格
    //1.加载表格
    obj.gridPICCN1 = $HUI.datagrid("#gridPICCN1", {
        title: '中央导管',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',
        singleSelect: true,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        columns: [[
			{ field: 'IRIntuDate', title: '置管时间', width: 80, align: 'center' },
            { field: 'IRExtuDate', title: '拔管时间', width: 80, align: 'center' },
			{ field: 'IRIsInf', title: '是否感染', width: 80, align: 'center',
                formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1")
			            rst = '是';
			        else
			            rst = '否';
			        return rst
			    }
			},
            { field: 'IRInfDate', title: '感染日期', width: 100, align: 'center' },
            { field: 'IRBacteriaDesc', title: '病原体', width: 100, align: 'center' }
        ]],
        onDblClickRow: function (rowIndex, rowData) {
			if (rowIndex > -1) {
				obj.SelectPICCDataN1 = rowData;
                obj.rowIndexN1=rowIndex;
				$('#LayerPICCN1').show();
				obj.OpenLayerPICCN1();
			}
		},
		onLoadSuccess: function (data) {
			dispalyEasyUILoad(); //隐藏效果
		}
	});
            //2.刷新中央导管
    obj.refreshPICCN1 = function () {
        //var Paadm = Paadm;
        var LocID = LocDr;
        $("#gridPICCN1").datagrid("loading"); //加载中提示信息
        $cm({
			ClassName: 'DHCHAI.IRS.INFICUPICCSrv',
			QueryName: 'QryICUPICCByPaadm',
			ResultSetType: "array",
			aPaadm: Paadm,
			aLocDr: LocID,
			page: 1,
			rows: 999
        }, function (rs) {
            $('#gridPICCN1').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
            //3.打开中央静脉编辑
    obj.OpenLayerPICCN1 = function () {
	   
        var rowData = obj.SelectPICCDataN1;
        $HUI.dialog('#LayerPICCN1', {
			title: "中央导管-编辑",
			iconCls: 'icon-w-paper',
			modal: true,
			isTopZindex: true
		})
        Common_ComboToBact("cboIRBacteriaN1");
        if (rowData != "") {
            var IRIntuDate = rowData.IRIntuDate;
            var IRExtuDate = rowData.IRExtuDate;
            $('#txtIRIntuDateN1').datebox('setValue', IRIntuDate);
            $('#txtIRExtuDateN1').datebox('setValue', IRExtuDate);

            var IsActive = rowData["IRIsInf"];
            if (IsActive == "1") {
                $('#chkIRIsInfN1').checkbox('setValue', true);
            }
            else {
                $('#chkIRIsInfN1').checkbox('setValue', false);
                $('#txtIRInfDateN1').datebox('disable');
                $('#cboIRBacteriaN1').combobox('disable');
            }

            var IRInfDate = rowData.IRInfDate;
            $('#txtIRInfDateN1').datebox('setValue', IRInfDate);

            var IRBacteria = rowData.IRBacteria
            var IRBacteriaDesc = rowData.IRBacteriaDesc
            $('#cboIRBacteriaN1').combobox('setValue', IRBacteria);
            $('#cboIRBacteriaN1').combobox('setText', IRBacteriaDesc);
        }
        else {
            $('#txtIRIntuDateN1').datebox('setValue', '');
            $('#txtIRExtuDateN1').datebox('setValue', '');
            $('#chkIRIsInfN1').checkbox('setValue', false);
            $('#txtIRInfDateN1').datebox('setValue', '');
            $('#cboIRBacteriaN1').combobox('setValue', '');
            $('#txtIRInfDateN1').datebox('disable');
            $('#cboIRBacteriaN1').combobox('disable');
        }
    }
            //4.勾选是否感染
    $HUI.checkbox("[name='chkIRIsInfN1']", {
        onChecked: function (e, value) {
            $('#txtIRInfDateN1').combobox('enable');
            $('#txtIRInfDateN1').combobox('clear');
            $('#cboIRBacteriaN1').combobox('enable');
            $('#cboIRBacteriaN1').combobox('clear');
        },
        onUnchecked: function (e, value) {
			$('#txtIRInfDateN1').datebox('disable');
            $('#txtIRInfDateN1').combobox('clear');
			$('#cboIRBacteriaN1').combobox('disable');
            $('#cboIRBacteriaN1').combobox('clear');
		}
	});
            //5.保存中央导管
    $('#btnPICCSaveN1').on('click', function () {
        var RowData = obj.SelectPICCDataN1;
        var ID = (RowData!="" ? RowData.ID : "");
        var rowIndex = obj.rowIndexN1;
        //var Paadm = Paadm;
        var LocID = LocDr;  //调查科室 ？= 当前科室 rd.LocID
        var IRIntuDate = $('#txtIRIntuDateN1').combobox('getValue');
        var IRIntuTime = "";  //插管时间
        var IRExtuDate = $('#txtIRExtuDateN1').combobox('getValue');
        var IRExtuTime = "";   //拔管时间
        var IRPICCType = "";
        var IRPICCCnt = "";
        var IRPICCPos = "";
        var IROperDoc = "";
        var IROperLoc = "";
        var IRIsInf = $('#chkIRIsInfN1').checkbox('getValue') ? '1' : '0';
        var IRInfDate = $('#txtIRInfDateN1').combobox('getValue');
        var IRInfSymptoms = "";
        var IRBacteria = $('#cboIRBacteriaN1').combobox('getValue');
        var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID
        
        var IRBacteriaDesc = $('#cboIRBacteriaN1').combobox('getText');
        
            //日期校验
        if (IRIntuDate == "") {
            $.messager.alert("错误提示", "置管日期不可以为空!", 'info');
            return;
        }
        if (IRExtuDate == "") {
            $.messager.alert("错误提示", "拔管日期不可以为空!", 'info');
            return;
        }
        if (IRIntuDate>IRExtuDate) {
            $.messager.alert("错误提示", "拔管日期不能早于置管日期!", 'info');
            return;
        }
        if ((IRIsInf==1)&&(!IRInfDate)) {
	        $.messager.alert("错误提示", "发生感染请填写感染日期!", 'info');
            return;
        }
            var row = {
                ID: ID,
                IRIntuDate: IRIntuDate,
                IRExtuDate: IRExtuDate,
                IRPICCType:IRPICCType,
                IRPICCCnt:IRPICCCnt,
                IRPICCPos:IRPICCPos,
                IROperDoc:IROperDoc,
                IROperLoc:IROperLoc,
                IRIsInf: IRIsInf,
                IRInfDate: IRInfDate,
                IRInfSymptoms:IRInfSymptoms,
                IRBacteria: IRBacteria,  //病原体
                IRBacteriaDesc:IRBacteriaDesc,
                UpdateUserDr: $.LOGON.USERID  //$.LOGON.USERID
            }
            if (parseInt(rowIndex) > -1) {  //修改
                obj.gridPICCN1.updateRow({  //更新指定行
                    index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                    row: row
                    });
                } else {	//添加
                    obj.gridPICCN1.appendRow(  //插入一个新行
                        row
                    );
                }
                $HUI.dialog('#LayerPICCN1').close();
 	 })
            //6.关闭中央导管
    $('#btnPICCCloseN1').on('click', function () {
        $HUI.dialog('#LayerPICCN1').close();
    })
            //7.添加中央导管
    $('#btnPICCAddN1').on('click', function () {
        obj.SelectPICCDataN1 = "";    //清空数据
        $('#LayerPICCN1').show();
        obj.OpenLayerPICCN1();
    })
            //8.删除中央导管
    $('#btnPICCDelN1').on('click', function () {
        var selectObj = obj.gridPICCN1.getSelected();
        if (!selectObj) {
            $.messager.alert("提示", "请选择一行要删除的数据!", 'info');
            return;
        } else {
            var rowDataID = obj.gridPICCN1.getSelected()["ID"];
            var index = obj.gridPICCN1.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
            if (rowDataID == "") {
                $.messager.confirm("提示", "是否要删除?", function (r) {
                    if (r) {
                        obj.gridPICCN1.deleteRow(index);
                        obj.SelectPICCDataN1 = ""
                        obj.rowIndexN1=""
                    }
                });
            }
            else {
                $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                    if (r) {
                        var flg = $m({
                            ClassName: "DHCHAI.IR.INFICUPICC",
                            MethodName: "DeleteById",
                            Id: rowDataID
                        }, false);
                        if ((parseInt(flg) == -1)) {
                            $.messager.alert("错误提示", "删除数据错误!", 'info');
                            return
                        } else {
                            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                            obj.SelectPICCDataN1 = ""
                            obj.rowIndexN1=""
                            obj.gridPICCN1.deleteRow(index);
                           // obj.refreshPICC();//刷新当前页
                        }
                    }
                });
            }
        }
    })
    //NICU->气管插拔
    //1.加载表格
    obj.gridVAPN = $HUI.datagrid("#gridVAPN", {
        title: '气管插拔',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-resort',
		singleSelect: true,
		nowrap: true, fitColumns: true,
		loadMsg: '数据加载中...',
		columns: [[
			{ field: 'IRIntuDate', title: '置管时间', width: 80, align: 'center' },
            { field: 'IRExtuDate', title: '拔管时间', width: 100, align: 'center' },
            { field: 'IRIsInf', title: '是否感染', width: 80, align: 'center',
                formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1")
			            rst = '是';
			        else
			            rst = '否';
			        return rst
			    }
			},
            { field: 'IRInfDate', title: '感染日期', width: 100, sortable: true, align: 'center' },
            { field: 'IRBacteriaDesc', title: '病原体', width: 80, align: 'center' },
         ]],
         onDblClickRow: function (rowIndex, rowData) {
			if (rowIndex > -1) {
				obj.SelectVAPDataN = rowData;
                obj.rowIndexVPN=rowIndex;
				$('#LayerVAPN').show();

				obj.OpenLayerVAPN();
			}
		},
		onLoadSuccess: function (data) {
			dispalyEasyUILoad(); //隐藏效果
		}
	});
            //2.刷新表格
    obj.refreshVAPN = function () {
        //var Paadm = Paadm;
        var LocID = LocDr;
        $("#gridVAPN").datagrid("loading"); //加载中提示信息
        $cm({
			ClassName: 'DHCHAI.IRS.INFICUVAPSrv',
				QueryName: 'QryICUVAPByPaadm',
				ResultSetType: "array",
				aPaadm: Paadm,
				aLocID: LocID,
				page: 1,
				rows: 999
        }, function (rs) {
            $('#gridVAPN').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
            //3.打开气管插拔
    obj.OpenLayerVAPN = function () {
        var rowData = obj.SelectVAPDataN;
        $HUI.dialog('#LayerVAPN', {
			title: "气管插拔-编辑",
			iconCls: 'icon-w-paper',
			modal: true,
			isTopZindex: true
		});
		Common_ComboToBact("cboIRBacteriaVN");

		if (rowData != "") {
            var IRIntuDate = rowData.IRIntuDate;
            var IRExtuDate = rowData.IRExtuDate;
            $('#txtIRIntuDateVN').datebox('setValue', IRIntuDate);
            $('#txtIRExtuDateVN').datebox('setValue', IRExtuDate);

            var IsActive = rowData["IRIsInf"];
            if (IsActive == "1") {
                $('#chkIRIsInfVN').checkbox('setValue', true);
            }
            else {
                $('#chkIRIsInfVN').checkbox('setValue', false);
                $('#txtIRInfDateVN').datebox('disable');
                $('#cboIRBacteriaVN').combobox('disable');
            }

            var IRInfDate = rowData.IRInfDate;
            $('#txtIRInfDateVN').datebox('setValue', IRInfDate);

            var IRBacteria = rowData.IRBacteria
            var IRBacteriaDesc = rowData.IRBacteriaDesc
            $('#cboIRBacteriaVN').combobox('setValue', IRBacteria);
            $('#cboIRBacteriaVN').combobox('setText', IRBacteriaDesc);
        }
        else {
            $('#txtIRIntuDateVN').datebox('setValue', '');
            $('#txtIRExtuDateVN').datebox('setValue', '');
            $('#chkIRIsInfVN').checkbox('setValue', false);
            $('#txtIRInfDateVN').datebox('setValue', '');
            $('#cboIRBacteriaVN').combobox('setValue', '');
            $('#txtIRInfDateVN').datebox('disable');
            $('#cboIRBacteriaVN').combobox('disable');
        }
    }
            //4.勾选是否感染
    $HUI.checkbox("[name='chkIRIsInfVN']", {
        onChecked: function (e, value) {
            $('#txtIRInfDateVN').combobox('enable');
            $('#txtIRInfDateVN').combobox('clear');
            $('#cboIRBacteriaVN').combobox('enable');
            $('#cboIRBacteriaVN').combobox('clear');
        },
        onUnchecked: function (e, value) {
            $('#txtIRInfDateVN').datebox('disable');
            $('#txtIRInfDateVN').combobox('clear');
            $('#cboIRBacteriaVN').combobox('disable');
            $('#cboIRBacteriaVN').combobox('clear');
        }
    });
            //5.保存气管插拔
    $('#btnVAPSaveN').on('click', function () {
        var RowData = obj.SelectVAPDataN;
        var ID = (RowData?RowData.ID : "");
        var rowIndex = obj.rowIndexVPN;
        //var Paadm = Paadm;
        var LocID = LocDr;
        var IRIntuDate = $('#txtIRIntuDateVN').combobox('getValue');
        var IRIntuTime = "";  //插管时间
        var IRExtuDate = $('#txtIRExtuDateVN').combobox('getValue');
        var IRExtuTime = "";   //拔管时间
        var IRVAPType = "";
        var IROperDoc = "";
        var IROperLoc = "";
        var IRIsInf = $('#chkIRIsInfVN').checkbox('getValue') ? '1' : '0';//是否有效
        var IRInfDate = $('#txtIRInfDateVN').datebox('getValue');
        var IRInfSymptoms = "";
        var IRBacteria = $('#cboIRBacteriaVN').combobox('getValue');  //病原体
        var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID
        var IRBacteriaDesc = $('#cboIRBacteriaVN').combobox('getText');
            //日期校验
        if (IRIntuDate == "") {
            $.messager.alert("错误提示", "置管时间不可以为空!", 'info');
            return;
        }
         if (IRExtuDate == "") {
            $.messager.alert("错误提示", "拔管时间不可以为空!", 'info');
            return;
        }
        if (IRIntuDate>IRExtuDate) {
            $.messager.alert("错误提示", "拔管时间不能早于置管时间!", 'info');
            return;
        }
        if ((IRIsInf==1)&&(!IRInfDate)) {
	        $.messager.alert("错误提示", "发生感染请填写感染日期!", 'info');
            return;
        }

        var row = {
            ID: ID,
            IRIntuDate: IRIntuDate,
            IRIntuTime:IRIntuTime,
            IRExtuDate: IRExtuDate,
            IRExtuTime:IRExtuTime,
            IRVAPType:IRVAPType,
            IROperDoc:IROperDoc,
            IROperLoc:IROperLoc,
            IRIsInf: IRIsInf,
            IRInfDate: IRInfDate,
            IRInfSymptoms:IRInfSymptoms,
            IRBacteria: IRBacteria,  //病原体
            IRBacteriaDesc:IRBacteriaDesc,
            UpdateUserDr: $.LOGON.USERID  //$.LOGON.USERID
        }
        if (parseInt(rowIndex) > -1) {  //修改
            obj.gridVAPN.updateRow({  //更新指定行
                index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                row: row
                });
            } else {	//添加
                obj.gridVAPN.appendRow(  //插入一个新行
                    row
                );
            }
            $HUI.dialog('#LayerVAPN').close();
    })
            //6.关闭气管插拔
    $('#btnVAPCloseN').on('click', function () {
        $HUI.dialog('#LayerVAPN').close();
    })
            //7.添加气管插拔
    $('#btnVAPAddN').on('click', function () {
        obj.SelectVAPDataN = "";    //清空数据
        $('#LayerVAPN').show();
        obj.OpenLayerVAPN();
    })
            //8.删除气管插拔
    $('#btnVAPDelN').on('click', function () {
        var selectObj = obj.gridVAPN.getSelected();
        if (!selectObj) {
            $.messager.alert("提示", "请选择一行要删除的数据!", 'info');
            return;
        } else {
            var rowDataID = obj.gridVAPN.getSelected()["ID"];
            var index = obj.gridVAPN.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
            if (rowDataID == "") {
                $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                    if (r) {
                        obj.gridVAPN.deleteRow(index);
                        obj.SelectVAPDataN = ""
                        obj.rowIndexVPN=""
                    }
                });
            }
            else {
                $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                    if (r) {
                        var flg = $m({
                            			ClassName: "DHCHAI.IR.INFICUVAP",
                            			MethodName: "DeleteById",
                            			Id: rowDataID
                            		}, false);
                                    if ((parseInt(flg) == -1)) {
                                        $.messager.alert("错误提示", "删除数据错误!", 'info');
                                    } else {
                            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                            obj.SelectVAPDataN = ""
                            obj.rowIndexVPN=""
                            obj.gridVAPN.deleteRow(index);
                        }
                    }
                });
            }
        }
    })

    //NICU->脐静脉
    //1.加载表格
    obj.gridPICCN2 = $HUI.datagrid("#gridPICCN2", {
        title: '脐静脉',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-resort',
		singleSelect: true,
		nowrap: true, fitColumns: true,
		loadMsg: '数据加载中...',
		columns: [[
			{ field: 'IRIntuDate', title: '置管时间', width: 80, align: 'center' },
            { field: 'IRExtuDate', title: '拔管时间', width: 80, align: 'center' },
            { field: 'IRIsInf', title: '是否感染', width: 80, align: 'center',
                formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1")
			            rst = '是';
			        else
			            rst = '否';
			        return rst
			    }
			},
            { field: 'IRInfDate', title: '感染日期', width: 100, align: 'center' },
            { field: 'IRBacteriaDesc', title: '病原体', width: 100, align: 'center' }
        ]],
        onDblClickRow: function (rowIndex, rowData) {
            if (rowIndex > -1) {
                obj.SelectPICCDataN2 = rowData;
                obj.rowIndexN2=rowIndex
                $('#LayerPICCN2').show();
                obj.OpenLayerPICCN2();
            }
        },
        onLoadSuccess: function (data) {
           dispalyEasyUILoad(); //隐藏效果
        }
    });
            //2.刷新表格
    obj.refreshPICCN2 = function () {
        //var Paadm = Paadm;
        var LocID = LocDr;
        $("#gridPICCN2").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.INFICUUCSrv',
			QueryName: 'QryICUUCByPaadm',
			ResultSetType: "array",
			aPaadm: Paadm,
			aLocID: LocID,
			page: 1,
			rows: 999
        }, function (rs) {
			$('#gridPICCN2').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
			});
		}
            //3.打开脐静脉编辑
    obj.OpenLayerPICCN2 = function () {
        var rowData = obj.SelectPICCDataN2;
        $HUI.dialog('#LayerPICCN2', {
			title: "脐静脉-编辑",
			iconCls: 'icon-w-paper',
			modal: true,
			isTopZindex: true
		})
		Common_ComboToBact("cboIRBacteriaN2");

        if (rowData != "") {
            var IRIntuDate = rowData.IRIntuDate;
            var IRExtuDate = rowData.IRExtuDate;
            $('#txtIRIntuDateN2').datebox('setValue', IRIntuDate);
            $('#txtIRExtuDateN2').datebox('setValue', IRExtuDate);

            var IsActive = rowData["IRIsInf"];
            if (IsActive == "1") {
                $('#chkIRIsInfN2').checkbox('setValue', true);
            }
            else {
                $('#chkIRIsInfN2').checkbox('setValue', false);
                $('#txtIRInfDateN2').datebox('disable');
                $('#cboIRBacteriaN2').combobox('disable');
           }

            var IRInfDate = rowData.IRInfDate;
            $('#txtIRInfDateN2').datebox('setValue', IRInfDate);

            var IRBacteria = rowData.IRBacteria
            var IRBacteriaDesc = rowData.IRBacteriaDesc
            $('#cboIRBacteriaN2').combobox('setValue', IRBacteria);
            $('#cboIRBacteriaN2').combobox('setText', IRBacteriaDesc);
		}
        else {
            $('#txtIRIntuDateN2').datebox('setValue', '');
            $('#txtIRExtuDateN2').datebox('setValue', '');
            $('#chkIRIsInfN2').checkbox('setValue', false);
            $('#txtIRInfDateN2').datebox('setValue', '');
            $('#cboIRBacteriaN2').combobox('setValue', '');
            $('#txtIRInfDateN2').datebox('disable');
            $('#cboIRBacteriaN2').combobox('disable');
        }
    }
            //4.勾选是否感染
    $HUI.checkbox("[name='chkIRIsInfN2']", {
        onChecked: function (e, value) {
            $('#txtIRInfDateN2').combobox('enable');
            $('#txtIRInfDateN2').combobox('clear');
            $('#cboIRBacteriaN2').combobox('enable');
            $('#cboIRBacteriaN2').combobox('clear');
        },
        onUnchecked: function (e, value) {
			$('#txtIRInfDateN2').datebox('disable');
            $('#txtIRInfDateN2').combobox('clear');
			$('#cboIRBacteriaN2').combobox('disable');
            $('#cboIRBacteriaN2').combobox('clear');
		}
	});
            //5.保存脐静脉
    $('#btnPICCSaveN2').on('click', function () {
        var RowData = obj.SelectPICCDataN2;
        var ID = (RowData ? RowData.ID : "");
        var rowIndex = obj.rowIndexN2;
        //var Paadm = Paadm;
        var LocID = LocDr;  //调查科室 ？= 当前科室 rd.LocID

        var IRIntuDate = $('#txtIRIntuDateN2').combobox('getValue');
        var IRIntuTime = "";  //插管时间
        var IRExtuDate = $('#txtIRExtuDateN2').combobox('getValue');
        var IRExtuTime = "";   //拔管时间
        var IRUCType = "";
        var IROperDoc = "";
        var IROperLoc = "";
        var IRIsInf = $('#chkIRIsInfN2').checkbox('getValue') ? '1' : '0';
        var IRInfDate = $('#txtIRInfDateN2').combobox('getValue');
        var IRInfSymptoms = "";
        var IRBacteria = $('#cboIRBacteriaN2').combobox('getValue');
        var UpdateUserDr = $.LOGON.USERID;   //$.LOGON.USERID  
        var IRBacteriaDesc = $('#cboIRBacteriaN2').combobox('getText');
            //日期校验
        if (IRIntuDate == "") {
            $.messager.alert("错误提示", "置管日期不可以为空!", 'info');
            return;
        }
        if (IRExtuDate == "") {
            $.messager.alert("错误提示", "拔管日期不可以为空!", 'info');
            return;
        }
        if (IRIntuDate>IRExtuDate) {
            $.messager.alert("错误提示", "拔管日期不能早于置管日期!", 'info');
            return;
        }
		if ((IRIsInf==1)&&(!IRInfDate)) {
	        $.messager.alert("错误提示", "发生感染请填写感染日期!", 'info');
            return;
        }

        var row = {
            ID: ID,
            IRIntuDate: IRIntuDate,
            IRIntuTime:IRIntuTime,
            IRExtuDate: IRExtuDate,
            IRExtuTime:IRExtuTime,
            IRUCType:IRUCType,
            IROperDoc:IROperDoc,
            IROperLoc:IROperLoc,
            IRIsInf: IRIsInf,
            IRInfDate: IRInfDate,
            IRInfSymptoms:IRInfSymptoms,
            IRBacteria: IRBacteria,  //病原体
            IRBacteriaDesc:IRBacteriaDesc,
            UpdateUserDr: $.LOGON.USERID  //$.LOGON.USERID
        }
        if (parseInt(rowIndex) > -1) {  //修改
            obj.gridPICCN2.updateRow({  //更新指定行
                index: rowIndex,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                row: row
                });
            } else {	//添加
                obj.gridPICCN2.appendRow(  //插入一个新行
                    row
                );
            }
            $HUI.dialog('#LayerPICCN2').close();
  })
        //6.关闭中央导管
$('#btnPICCCloseN2').on('click', function () {
    $HUI.dialog('#LayerPICCN2').close();
    })
            //6.关闭脐静脉
    $('#btnPICCCloseN2').on('click', function () {
        $HUI.dialog('#LayerPICCN2').close();
    })
            //7.添加脐静脉
    $('#btnPICCAddN2').on('click', function () {
        obj.SelectPICCDataN2 = "";    //清空数据
        $('#LayerPICCN2').show();
        obj.OpenLayerPICCN2();
    })
            //8.删除脐静脉
    $('#btnPICCDelN2').on('click', function () {

    var selectObj = obj.gridPICCN2.getSelected();
    if (!selectObj) {
        $.messager.alert("提示", "请选择一行要删除的数据!", 'info');
        return;
    } else {
        var rowDataID = obj.gridPICCN2.getSelected()["ID"];
        var index = obj.gridPICCN2.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
        if (rowDataID == "") {
            $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                if (r) {
                    obj.gridPICCN2.deleteRow(index);
                    obj.SelectPICCDataN2= ""
                    obj.rowIndexN2=""
                }
            });
        }
        else {
            $.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
                if (r) {
                    var flg = $m({
                                    ClassName: "DHCHAI.IR.INFICUUC",
                                    MethodName: "DeleteById",
                                    Id: rowDataID
                                }, false);
                                if ((parseInt(flg) == -1)) {
                                    $.messager.alert("错误提示", "删除数据错误!", 'info');
                                } else {
                        $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                        obj.SelectPICCDataN2= ""
                        obj.rowIndexN2=""
                        obj.gridPICCN2.deleteRow(index);
                    }
                }
            });
        }
    }
     })
   
}