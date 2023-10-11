/**
 * @author songchunli
 * HISUI 护理计划制定主js
 * NursePlanMake.js
 */
var PageLogicObj = {
    m_NurQuestionTableGrid: "",
    m_QuestionTargetTableGrid: "", // 护理目标table
    m_QuestionMeasureTableGrid: "", // 护理措施table
    m_QLRealateFactorTableGrid: "", // 非相关因素table
    m_QuestionTypeKW: "",
    m_QuestionTypeKWLight:"",
    m_SelQuestionObj: {
        planID: "",
        questSub: "",
        template: "",
        statusName: $g("未停止"),
        isNQNursingAdvice: "N",
        queName:""
    }, //护理问题最后选中行对象,供计划执行内表格查询用
    m_QSGridSelRecordIdAfterLoad: "", //问题列表表格加载数据成功后需要选中行的ID
    m_QSMeasureEditIndex: "",
    m_selWeek: "", //新增护理措施时，周频次选择的星期串,多个以|分割.存储位置 CF.NUR.NIS.Intervention，字段NIVT_DefaultFreqWeek
    m_WeekTableGridData: "",
	QuestionTypeShowNum:14,
	ifMultiple:"",  //需求2744200 是否多选，这里务必为空   
	//LeaderGROUPID:"@25@52@112@114@", //指定“护士长”安全组ID
	m_NursingRecordTemplateJson:[], //护理记录表头数据配置列表
}
$(function () {
    Init();
    InitEvent();
    if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//炫彩
		$(".hisui-layout").layout('panel', 'center').attr("style","overflow:hidden;padding-left:0px;background-color:#FFFFFF");		
		$("#QuestionMainPanel").css('background-color','#FFFFFF');
	}
});
$(window).load(function () {
    $("#loading").hide();
    if ((ServerObj.IsShowPatInfoBannner!="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
	    InitPatInfoBanner(ServerObj.EpisodeID);
	}    
})
window.addEventListener("resize", ResetDomSize);

function InitEvent() {
	// 护理问题计划撤销 2021.8.31
    $("#BQuestionPlanCancel").click(NursePlanCancelClick);
    // 护理问题计划提交
    $("#BQuestionPlanSumit").click(QuestionPlanSumitClick);
    // 新增护理问题保存
    $("#BQuestionSave").click(BQuestionSaveClick);
    // 新增护理问题弹框-取消按钮事件
    $("#BQuestionWinClose").click(function () {
        $("#QuestionAddWin").window("close");
    });
    // 问题列表查询按钮事件
    /*
    $("#BQuestionFind").click(function () {
        $('#NurQuestionTable').datagrid('reload');
    });    
    */
    $('#ThisWardSearch').parent().hide();   //隐藏仅查阅本病区护理计划复选框
    // 问题关键字回车检索
    $("#QuestionKeyWord").keydown(QuestionKeyWordOnKeyDown);
    if (ServerObj.versionPatientListNew!=1){
	    // 患者姓名、登记号、床号检索
	    /*$('#wardPatientSearchBox').searchbox({
	    	searcher: function(value) {
	    		$HUI.tree('#patientTree','reload');
	    	}
	    });*/

	    $("#wardPatientSearchBox").keydown(function (e) {
	        var key = websys_getKey(e);
	        if (key == 13) {
	            $HUI.tree('#patientTree', 'reload');
	        }
	    });
	    $("#wardPatientSearchBtn").click(function () {
	        $HUI.tree('#patientTree', 'reload');
	    });

	    /*$('#wardPatientCondition').switchbox('options').onSwitchChange = function(){
	    	$HUI.tree('#patientTree','reload');
	    };*/
    }
    $("#switchBtn").click(function () {
        $(".current").removeClass("current");
        if ($(".ant-switch-checked").length) {
            $("#switchBtn").removeClass("ant-switch-checked");
            $($(".switch label")[0]).addClass("current");
        } else {
            $("#switchBtn").addClass("ant-switch-checked");
            $($(".switch label")[1]).addClass("current");
        }
        $HUI.tree('#patientTree', 'reload');
    });

   $("#BWeekFreqSure").click(WeekFreqSureClick);
}
function Init() {
    // 初始化页面默认数据 日期范围、治疗天数等
    SetPageDefaultData();
    // 初始化问题列表查询条件
    InitQSCombobox();
    // 初始化患者列表树
    if(ServerObj.versionPatientListNew!="1"){
	    if (ServerObj.IsShowPatList == "Y"){
	        // 护理分组权限开启时，默认显示责组
	        if (ServerObj.groupFlag == "Y") {
	            $("#switchBtn").addClass("ant-switch-checked");
	            $($(".switch label")[1]).addClass("current");
	        }
	        //InitPatientTree();
	        InitPatientTreeOld();
	    }
	}
    // 初始化患者信息条
    if (ServerObj.IsShowPatInfoBannner == "Y") {
	    SetPatientBarInfo(ServerObj.EpisodeID); 
        $(".PatInfoItem").children().eq(0).css({'left':"0px"});//需求：3152987
    } else {
        ResetDomSize();
    }
    // 初始化护理护理问题Tabel
    InitNurQuestionTableGrid();
    if(ServerObj.versionPatientListNew!="1"){}
    else{
	    $('#main').layout('panel', 'west').panel({
		  onExpand: ResetDomSize,
		  onCollapse: ResetDomSize
	  });
    }
    // 更多/隐藏
    if (PageLogicObj.m_QuestionTypeKWLight){
	    alert("显示");             
	} 
	$("#moreBtn").click(toggleExecInfo);

}
// 查询
function QuestionFind(flag){	
    // 检查$("#ThisWardSearch")是否存在
    if ($('#ThisWardSearch').length > 0) {	
    	var searchcheckbox = document.getElementById('ThisWardSearch');    
        // 将hisui-checkbox $('#ThisWardSearch')取消勾选
        if (flag=="1") searchcheckbox.checked = true; // 本病区查询
        else searchcheckbox.checked = false;			   // 全部查询        
    } 
    // 重新加载表格
    $('#NurQuestionTable').datagrid('reload'); 
}

function SetPageDefaultData() {
	if((ServerObj.portalStartDate!="")&&(ServerObj.portalEndDate!="")){
		$("#QuestionSearchDateFrom").datebox("setValue", ServerObj.portalStartDate);
	    $("#QuestionSearchDateTo").datebox("setValue", ServerObj.portalEndDate);
	}else{	
	    $("#QuestionSearchDateFrom").datebox("setValue", ServerObj.QuestionSearchDateFrom);
	    $("#QuestionSearchDateTo").datebox("setValue", ServerObj.QuestionSearchDateTo);
	}
    /*
    // 2021.7.27 add
    if (ServerObj.IsOpenTreatDays == "Y")
    {
    	$("#days").html($g("计划治疗天数：")+ServerObj.days+$g(" 天"));
    }
    */
}

function InitQSCombobox() {
    // 问题状态 （0：未停止 1：已停止 2：已撤销 3：已作废）
    var cbox = $HUI.combobox("#QSearchStatus", {
        valueField: 'value',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox', //显示成勾选行形式
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: false,
        data: eval("(" + ServerObj.QSearchStatusJson + ")"),
        loadFilter: function (data) {
            var newData = new Array();            
            for (var i = 0; i < data.length; i++) {
	           	//需求：2760059 
	            //停止流程：状态下拉框：未停止、已停止、已作废；评价状态下拉框不显示 
                //评价流程：状态下拉框不显示；评价状态下拉框：未评价、已评价；
                /*
	            if (ServerObj.IsOpenNurEvaluate == "Y"){		            
		            if ((data[i].text == "未停止")||(data[i].text == "已停止"))
	        		continue;
		        }
		        //需求：2592286，隐藏已撤销状态
                if (data[i].text == "已撤销") {
                    continue;
                }
                */
                var value = data[i].value;
                var text = data[i].text;
                newData.push({
                    "value": value.toString(),
                    "text": text
                });
            }
            return newData;
        }
    });
    //评价默认查询状态 约束【护理计划制定】界面中，护理问题“评价状态”默认筛选条件的勾选；
    var QSearchStatus=ServerObj.QPCCNursePlanSearchStatus.split('^');
	for (var j = 0; j < QSearchStatus.length; j++) {
	    if(QSearchStatus[j]!=""){
			$("#QSearchStatus").combobox('select',QSearchStatus[j].toString())
	    }	                
	}
    
    // 评价状态 问题评价状态(0：未评价 1：已评价)
    var cbox = $HUI.combobox("#QSearchEvaluateStatus", {
        rowStyle: 'checkbox', //显示成勾选行形式
        valueField: 'value',
        textField: 'text',
        editable: false,
        multiple: true,
        data: eval("(" + ServerObj.QSearchEvaluateStatusJson + ")"),
        loadFilter: function (data) {	        
            var newData = new Array();
            for (var i = 0; i < data.length; i++) {
                var value = data[i].value;
                var text = data[i].text;
                newData.push({
                    "value": value.toString(),
                    "text": text
                });
            }
            return newData;
        }
    });
    //评价默认查询状态约束【护理计划制定】界面中，护理问题“评价状态”默认筛选条件的勾选；
    var QSearchEvaluateStatus=ServerObj.QPCCNurEvaluateSearchStatus.split('^');
	for (var j = 0; j < QSearchEvaluateStatus.length; j++) {
	    if(QSearchEvaluateStatus[j]!=""){
			$("#QSearchEvaluateStatus").combobox('select',QSearchEvaluateStatus[j].toString())
	    }	                
	}
    // 数据来源
    var cbox = $HUI.combobox("#QSearchDataSource", {
        rowStyle: 'checkbox', //显示成勾选行形式
        valueField: 'value',
        textField: 'text',
        editable: false,
        multiple: true,
        data: eval("(" + ServerObj.QSearchDataSourceJson + ")"),
        loadFilter: function (data) {
            var newData = new Array();
            for (var i = 0; i < data.length; i++) {
                var value = data[i].value;
                var text = data[i].text;
                newData.push({
                    "value": value.toString(),
                    "text": text
                });
            }
            return newData;
        }
    });
}
function PopPatientCareLevel(EpisodeID){
	if (ServerObj.QPCCNursePlanPatientStatus!=""){		
		$cm({
			ClassName: "Nur.NIS.Service.NursingPlan.NursePlanMake",
	    	MethodName: "GetCareLevel",
	    	EpisodeID: EpisodeID,
    	},function (data) {
	    	if((data!="")&&(("^"+ServerObj.QPCCNursePlanPatientStatus+"^").indexOf("^"+data.id+"^") == -1)){
		    	//不包含
		    	$.messager.popover({
	                    msg: "此患者护理级别为：[" + data.desc + "  ]不带入护理问题",
	                    type: 'alert'
	                });
	    	}	    	
		})
	}
}
function InitPatientTreeOld() {
    $HUI.tree('#patientTree', {
        loader: function (param, success, error) {
            // HIS 8.5 版本
            if (ServerObj.version85 == "1") {
                var parameter = {
                    EpisodeID: ServerObj.EpisodeID,
                    WardID: session['LOGON.WARDID'],
                    LocID: session['LOGON.CTLOCID'],
                    GroupFlag: $(".ant-switch-checked").length ? true : false,
                    BabyFlag: '',
                    SearchInfo: $("#wardPatientSearchBox").val(),
                    LangID: session['LOGON.LANGID'],
                    UserID: session['LOGON.USERID']
                };
                $cm({
                    ClassName: "Nur.NIS.Service.Base.Ward",
                    MethodName: "GetWardPatientsNew",
                    wardID: session['LOGON.WARDID'],
                    adm: ServerObj.EpisodeID,
                    groupSort: $(".ant-switch-checked").length ? "true" : "false",
                    babyFlag: "",
                    searchInfo: $("#wardPatientSearchBox").val(),
                    locID: session['LOGON.CTLOCID']
                    //MethodName: "getPatients",
                    //Param: JSON.stringify(parameter)
                }, function (data) {
                    var addIDAndText = function (node) {
                        node.id = node.ID;
                        node.text = node.label;
                        if (node.id === ServerObj.EpisodeID) {
                            node.checked = true;
                        }
                        if (node.children) {
                            node.children.forEach(addIDAndText);
                        }
                    }
                    data.forEach(addIDAndText);
                    success(data);
                });
            }
            else if((ServerObj.version85 == "0")&&(ServerObj.PatientListVersion=="NursingRecord")){
                // 兼容低版本HIS -- 取护理病历病人列表接口 HIS 8.4及以前
                $cm({
                    ClassName: "NurMp.NursingRecords",
                    MethodName: "getWardPatients",
                    wardID: session['LOGON.WARDID'],
                    adm: ServerObj.EpisodeID,
                    groupSort: $(".ant-switch-checked").length ? "true" : "false", //!$('#wardPatientCondition').switchbox('getValue'),
                    babyFlag: '',
                    searchInfo: $("#wardPatientSearchBox").val(), //$HUI.searchbox('#wardPatientSearchBox').getValue(),
                    locID: session['LOGON.CTLOCID'] || '',
                    todayOperFlag: $("#radioTodayOper").radio('getValue')
                }, function (data) {
                    var addIDAndText = function (node) {
                        node.id = node.ID;
                        node.text = node.label;
                        if (node.id === ServerObj.EpisodeID) {
                            node.checked = true;
                        }
                        if (node.children) {
                            node.children.forEach(addIDAndText);
                        }
                    }
                    data.forEach(addIDAndText);
                    success(data);
                });
            }
            else if((ServerObj.version85 == "0")&&(ServerObj.PatientListVersion=="PatientList")) {
                // 兼容低版本HIS -- 取护理病历病人列表接口 HIS 8.2及以前
                var parameter = {					
					WardID: session['LOGON.WARDID'],
					EpisodeID: ServerObj.EpisodeID,
					LocID: session['LOGON.CTLOCID'],
					GroupFlag: $(".ant-switch-checked").length ? "true" : "false", //$('#wardPatientCondition').switchbox('getValue') == true ? 'N' : 'Y',
					BabyFlag: '',
					SearchInfo: $("#wardPatientSearchBox").val(),//$HUI.searchbox('#wardPatientSearchBox').getValue(),
					LangID: session['LOGON.LANGID'],
					UserID: session['LOGON.USERID'],
					StartDate: '', //ShowSearchDate == 1 ? $('#startDate').datebox('getValue') : '',
					EndDate: '', //ShowSearchDate == 1 ? $('#endDate').datebox('getValue') : ''
				};
                $cm({
					ClassName: 'NurMp.Service.Patient.List',
					MethodName: 'getPatients',
					Param: JSON.stringify(parameter)
				}, function (data) {
                    var addIDAndText = function (node) {
                        node.id = node.ID;
                        node.text = node.label;
                        if (node.id === ServerObj.EpisodeID) {
                            node.checked = true;
                        }
                        if (node.children) {
                            node.children.forEach(addIDAndText);
                        }
                    }         
                    data.WardPatients.forEach(addIDAndText);
                    success(data.WardPatients);
                });
            }

        },
        onLoadSuccess: function (node, data) {	        
            var addIDAndText = function (node) {
                node.id = node.ID;
                node.text = node.label;
                if ((typeof node.icons != 'undefined') && (!!node.icons)) {
                    $.each(node.icons.reverse(), function (index, value) {
                        $("#patientTree > li > ul > li > div > span:contains(" + node.text + ")").after("<img style='margin:6px;' src='" + value + "'/>");
                    });
                }
                if (node.children) {
                    node.children.forEach(addIDAndText);
                }
            }   
	        data.forEach(addIDAndText);	  
            if (!!ServerObj.EpisodeID) {
                var selNode = $('#patientTree').tree('find', ServerObj.EpisodeID);
                $('#patientTree').tree('select', selNode.target);
                SetQuestionBtnStatus(selNode.bedCode);
            }
        },
        lines: true,
        onClick: function (node) {
			PageLogicObj.ifMultiple=""    //需求2744200 切换患者需要将ifMultiple置为空
            patNode = node;
            if (!!node.episodeID) {
                var Args = {};
                Args.adm = node.id;
                xhrRefresh(Args);
                //2022.01.20 产品部要求不进行头菜单患者切换
                                
                //if (ServerObj.SwitchSysPat !="N"){
                //	var frm = dhcsys_getmenuform();
                //	if (frm) {
                //		frm.EpisodeID.value = node.episodeID;
                //		frm.PatientID.value = node.patientID;
                //	}
                //}
                SetQuestionBtnStatus(node.bedCode);
            }
        }
    });
}

function SetQuestionBtnStatus(bedCode) {
    if (bedCode) {
        $("#AddQuestion,#CopyQuestion").linkbutton('enable');
    } else {
        $("#AddQuestion,#CopyQuestion").linkbutton('disable');
    }
}
// 局部刷新用
function xhrRefresh(Args) {
    try {
        var EpisPatInfo = tkMakeServerCall("Nur.NIS.Service.NursingPlan.NursePlanMake", "InitPatInfoViewGlobal", Args.adm);
        InitPatInfoViewService(EpisPatInfo);
        if (ServerObj.IsShowPatInfoBannner == "Y") {
            SetPatientBarInfo(Args.adm);
        }
        SetPageDefaultData();
        $.extend(PageLogicObj, {
            m_QSGridSelRecordIdAfterLoad: "",
            m_QSMeasureEditIndex: "",
            m_SelQuestionObj: {
                planID: "",
                questSub: "",
                template: "",
                statusName: $g("未停止"),
                isNQNursingAdvice: "N",
                queName:""
            }
        });
        // 重现加载表格数据
        ReloadDataGrid();
        $("#QuestionMakePanel").panel("setTitle", $g("计划制定"));        
        SetNurPalnBtnStatus();
        SetNurPalnBtnCstatus();
        SetNurPalnBtnPermission(); //2022-10-19 add
        
    } catch (e) {
        //此方法局部刷新和页面初始化时会调用,如果报错可能导致错误难排查,需加错误提示性信息
        $.messager.alert("提示", "调用IxhrRefresh函数异常,错误信息：" + e.message);
        return false;
    }
}

function ReloadDataGrid() {
    //重新加载护理问题列表
    $("#NurQuestionTable").datagrid('load');
    if (PageLogicObj.m_QuestionMeasureTableGrid) {
        if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
            $("#QLRealateFactorTable").datagrid("load");
        }
        if (ServerObj.IsOpenQuestionTarget == "Y") {
            $("#QuestionTargetTable").datagrid("load");
        }
        $("#QuestionMeasureTable").datagrid("load");
    }
}
//患者树勾选/取消勾选时调用
function patientTreeCheckChangeHandle()
{
	PageLogicObj.ifMultiple=""    // 需求2744200 切换患者需要将ifMultiple置为空
	var node =""
	if (_PatListGV.ifMultiCheck==1){}
	else{
		var node = $('#patientTree').tree('getSelected');
	}	
    if(node){
	    var Args = {};
        Args.adm = node.episodeID;
        xhrRefresh(Args);
        SetQuestionBtnStatus(node.bedCode);
        // 2023-02-21 add 需求序号：3147421 增加“计划启用患者类型”
        PopPatientCareLevel(node.episodeID);        
	}	
}
// 加载患者信息条数据（顶部）
function SetPatientBarInfo(EpisodeID) {
	if (ServerObj.versionIsInfoBarNew=="1"){
		//2023.02.28 医生站关于病人信息栏的调用修改
		$(".ctcAEPatBar").css('height', 40 + 'px');
		// 修复：先点一个患者不超长的再连续点两个超长的会出现悬浮框和实际患者不一致的情况
		//var $container=$('.pat-info-container');
		//$container.popover('destroy');
		InitPatInfoBanner(EpisodeID);	    
		ResetDomSize();

	}else{
		if (ServerObj.versionIsInfoBarOld=="1"){
			//HIS 版本8.2以上至8.5
		    var html = $m({
		        ClassName: "web.DHCDoc.OP.AjaxInterface",
		        MethodName: "GetOPInfoBar",
		        CONTEXT: "",
		        EpisodeID: ServerObj.EpisodeID
		    }, false);
		    if (html != "") {
		        $(".PatInfoItem").html(reservedToHtml(html));
		        var height = $(".ctcAEPatBar .PatInfoItem").height();        
		        if (ServerObj.versionPatientListNew!="1"){
			        $(".ctcAEPatBar").css('height', 50 + 'px');
			    }
		        else{
			        $(".ctcAEPatBar").css('height', height + 'px');
			    }
		        ResetDomSize();
		    } else {
		        $(".PatInfoItem").html($g("获取病人信息失败。请检查【患者信息展示】配置。"));
		    }
		}else{
			//HIS 版本8.2 护理计划制定页面无患者信息
			GetPatBaseInfo();			
			var height = $(".ctcAEPatBar .PatInfoItem").height();			       
	        if (ServerObj.versionPatientListNew!="1"){
		        $(".ctcAEPatBar").css('height', 35 + 'px');
		    }
	        else{
		        $(".ctcAEPatBar").css('height', height + 'px');
		    }
	        ResetDomSize();			
		}
	}
    function reservedToHtml(str) {
        var replacements = {
            "&lt;": "<",
            "&#60;": "<",
            "&gt;": ">",
            "&#62;": ">",
            "&quot;": "\"",
            "&#34;": "\"",
            "&apos;": "'",
            "&#39;": "'",
            "&amp;": "&",
            "&#38;": "&"
        };
        return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
            return replacements[v];
        });
    }
    $("#wardPatientCondition").css('margin-top','0px'); //需求：3152987
}
/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":ServerObj.EpisodeID, "PPFlag":"N"},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "女"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
			}
		})
	},'json',false)
}
function ResetDomSize() {
    if (ServerObj.IsShowPatList=="Y"){
    	var innerHeight = window.innerHeight-8;
	    // center
	    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        height: '100%',
	        width: '100%',
	    });	
	    // 患者列表高度
	    if(ServerObj.versionPatientListNew!="1"){	    
		    $("#patientList").panel('resize', {
		        height: innerHeight - 37
		    });
		    $("#patientListTree").panel('resize', {
		        height: innerHeight - 100
		    });	    
	    }else{
		    var innerWidth= window.innerWidth-8;
			var ele = document.getElementById("patient_search");
			if (ele!=null){      //修复Bug
				var style=window.getComputedStyle ? window.getComputedStyle(ele,null) : ele.currentStyle;
				var display=style["display"];
				if (display=="block"){
					$("#main").layout("resize").layout('panel', 'center').panel('resize', {
			        	left: 225,
			        	width: innerWidth-225
			    	});
				}
				else if (display=="none"){
					$("#main").layout("resize").layout('panel', 'center').panel('resize', {
			        	left: 28,
			        	width: innerWidth-28      	
			    	});
				}
			}
	    }
    }else{
    	var innerHeight = window.innerHeight-8;
    	var innerWidth= window.innerWidth-8;
	    // center
	    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        height: '100%',
	        width: '100%',
	    });
		$("#main").layout("resize").layout('panel', 'center').panel('resize', {
        	left: 0,
        	width: innerWidth,
    	});	    
	}
    if (ServerObj.IsShowPatInfoBannner=="Y"){
	    var PatBarHeight= $(".ctcAEPatBar").height();
	    var SearchTableHeight = $("#SearchTablePanel").outerHeight();
		// 患者信息条下方整体高度
		$("#QuestionMainPanel").css('height', innerHeight - PatBarHeight );		
		// 护理问题panel
	    $("#QuestionPanel").panel('resize', {
	        height: parseInt((innerHeight - PatBarHeight) * 0.5),   
	        width:'100%'
	    });
	    //查询表格panel
	    //var SearchTableHeight = document.getElementsByClassName("search-table")[0].clientHeight;
	    $("#SearchTablePanel").panel('resize', {
	        width:'100%',
	        height :SearchTableHeight,
	    });
	    
		//护理问题表格
		$("#QuestionPanel-table").css('height', $("#QuestionPanel").height()-SearchTableHeight)
		$("#QuestionPanel-table").css('width', $("#QuestionPanel").width()-5);
		/*
		if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//炫彩
			$("#NurQuestionTable").datagrid("resize",{  
		            height : $("#QuestionPanel").height()-SearchTableHeight,
		            width : $("#QuestionPanel").width()-5
		    });
	   	}else if((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)){//极简
			$("#NurQuestionTable").datagrid("resize",{  
		            height : $("#QuestionPanel").height()-SearchTableHeight,
		            width : $("#QuestionPanel").width()-5
		    });	   		
	   	}else{
			$("#NurQuestionTable").datagrid("resize",{  
		            height : $("#QuestionPanel").height()-SearchTableHeight,
		            width : $("#QuestionPanel").width()-5
		    });		   	
		}
		*/
		$("#NurQuestionTable").datagrid("resize",{  
	            height : $("#QuestionPanel").height()-SearchTableHeight,
	            width : $("#QuestionPanel").width()-5
	    });
	    		    
	    if (ServerObj.versionIsInfoBarNew=="1"){
		    // 计划制定高度
		    $("#QuestionMakePanel").panel('resize', {
		        height: innerHeight - $("#QuestionPanel").height() - PatBarHeight - 40
		    });
		}else{
		    // 计划制定高度
		    $("#QuestionMakePanel").panel('resize', {
		        height: innerHeight - $("#QuestionPanel").height() - $(".ctcAEPatBar .PatInfoItem").height() - 56 //-39
		    });
		}
    }else{
	    var PatBarHeight= 0;
	    var SearchTableHeight = $("#SearchTablePanel").outerHeight();
		// 患者信息条下方整体高度
		$("#QuestionMainPanel").css('margin-left', 0 );	
		$("#QuestionMainPanel").css('height', innerHeight - PatBarHeight );		
		// 护理问题panel
	    $("#QuestionPanel").panel('resize', {
	        height: parseInt((innerHeight - PatBarHeight) * 0.5),   
	        width:'100%'
	    });
	    //查询表格panel
	    //var SearchTableHeight = document.getElementsByClassName("search-table")[0].clientHeight;
	    $("#SearchTablePanel").panel('resize', {
	        width:'100%',
	        height :SearchTableHeight,
	    });
		//护理问题表格
		$("#QuestionPanel-table").css('height', $("#QuestionPanel").height()-SearchTableHeight)
		$("#QuestionPanel-table").css('width', $("#QuestionPanel").width()-5);
		$("#NurQuestionTable").datagrid("resize",{  
	            height : $("#QuestionPanel").height()-SearchTableHeight,
	            width : $("#QuestionPanel").width()-5
	    });
	    if (ServerObj.versionIsInfoBarNew=="1"){
		    // 计划制定高度
		    $("#QuestionMakePanel").panel('resize', {
		        //height: innerHeight - $("#QuestionPanel").height() - PatBarHeight-76
		        height: innerHeight - $("#QuestionPanel").parent().height() - PatBarHeight -$("#split-div").height()
		    });
		}else{
		    // 计划制定高度
		    $("#QuestionMakePanel").panel('resize', {
		        height: innerHeight - $("#QuestionPanel").parent().height() - $(".ctcAEPatBar .PatInfoItem").height()-$("#split-div").height()
		    });
		}	    
	}
	if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//炫彩
	    // 计划制定panel内三个子判断高度
	    $("#QLRealateFactorPanel,#QuestionTargetPanel,#QuestionMeasurePanel").panel('resize', {
		    //height: $("#QuestionMakePanel").height() - 4   //x轴无滚动条
	        height: $("#QuestionMakePanel").height() - 17	 //x轴有滚动条
	    }); 
   	}else if((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)){//极简
	    $("#QLRealateFactorPanel,#QuestionTargetPanel,#QuestionMeasurePanel").panel('resize', {
		    //height: $("#QuestionMakePanel").height() - 4   //x轴无滚动条
	        height: $("#QuestionMakePanel").height() - 12	 //x轴有滚动条
	    });
	}else{
	    $("#QLRealateFactorPanel,#QuestionTargetPanel,#QuestionMeasurePanel").panel('resize', {
		    //height: $("#QuestionMakePanel").height() - 4   //x轴无滚动条
	        height: $("#QuestionMakePanel").height() - 17	 //x轴有滚动条
	    });
	}
    setTimeout(function () {
        // 计划制定panel内三个子panel的宽度
        ResetQuestionMakePanelWidth();
    },200);
}



// 护理措施撤销 2021.8.31 add
function NursePlanCancelClick() {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    if (QueSelRows.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    } else if (QueSelRows.length > 1) {
        $.messager.popover({
            msg: '请选择一条护理问题！',
            type: 'error'
        });
        return false;
    }
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questionSub = recordId.split("||")[1];
    var isNQNursingAdvice = QueSelRows[0].isNQNursingAdvice;

    // 撤销非评估相关因素
    if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
        var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
        var sumitfactorDRRArr = new Array();
        for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
            var statusName = QLRealateFactorSelRows[i].statusName;
            if (statusName == "作废") {
                $.messager.popover({
                    msg: '已作废的非相关评估因素记录不能撤销！',
                    type: 'error'
                });
                return false;
            }
            var obj = {
                factorDR: QLRealateFactorSelRows[i].factorDR,
                recordID: QLRealateFactorSelRows[i].recordID
            };
            sumitfactorDRRArr.push(obj);
        }
        if (sumitfactorDRRArr.length > 0) {
            var rtnResult = $m({
                ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
                MethodName: "CancelFactorRecordNew",
                planID: planID,
                questionSub: questionSub,
                optID: session['LOGON.USERID'],
                factorArr: JSON.stringify(sumitfactorDRRArr)
            }, false)
            if (rtnResult != "0") {
                $.messager.popover({
                    msg: '撤销非相关因素失败：' + rtnResult,
                    type: 'error'
                });
                return false;
            }
        }
    }

    // 撤销护理目标
    if (ServerObj.IsOpenQuestionTarget == "Y") {
        var QuestionTargetTableSelRows = $("#QuestionTargetTable").datagrid("getSelections");
        var sumitgoalDRRArr = new Array();
        for (var i = 0; i < QuestionTargetTableSelRows.length; i++) {
            var goalStatus = QuestionTargetTableSelRows[i].goalStatus;
            if (goalStatus == $g("作废")) {
                $.messager.popover({
                    msg: '已作废的护理目标不能撤销！',
                    type: 'error'
                });
                return false;
            }
            var recordID = QuestionTargetTableSelRows[i].recordID;
            if (!recordID || recordID == "") {
                $.messager.popover({
                    msg: '未提交的护理目标不能撤销！',
                    type: 'error'
                });
                return false;
            }
            var obj = {
                goalDR: QuestionTargetTableSelRows[i].goalDR,
                recordID: recordID
            };
            sumitgoalDRRArr.push(obj);
        }
        if (sumitgoalDRRArr.length > 0) {
            var rtnResult = $m({
                ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
                MethodName: "CancelGoalRecordNew",
                planID: planID,
                questionSub: questionSub,
                optID: session['LOGON.USERID'],
                goalArr: JSON.stringify(sumitgoalDRRArr)
            }, false)
            if (rtnResult != "0") {
                $.messager.popover({
                    msg: '撤销目标失败：' + rtnResult,
                    type: 'error'
                });
                return false;
            }
        }
    }

    // 撤销护理措施
    var QuestionMeasureTableSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
    var sumitintervDRRArr = new Array();
    for (var i = 0; i < QuestionMeasureTableSelRows.length; i++) {
        var statusName = QuestionMeasureTableSelRows[i].statusName;
        if (statusName == $g("停止")) {
            $.messager.popover({
                msg: "停止状态的护理措施不能撤销！",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("作废")) {
            $.messager.popover({
                msg: "作废状态的护理措施不能撤销！",
                type: 'error'
            });
            return false;
        } else if (!statusName || statusName == "") {
            $.messager.popover({
                msg: "未提交的护理措施不能撤销！",
                type: 'error'
            });
            return false;
        }
        var recordID = QuestionMeasureTableSelRows[i].recordID;
        var obj = {
            intervdr: QuestionMeasureTableSelRows[i].intervDR,
            rowID: QuestionMeasureTableSelRows[i].rowID
        };
        sumitintervDRRArr.push(obj);
    }
    if (sumitintervDRRArr.length > 0) {
        var rtnResult = $m({
            ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
            MethodName: "CancelCommitIntervRecord",
            planID: planID,
            questionSub: questionSub,
            optID: session['LOGON.USERID'],
            locDr: session['LOGON.CTLOCID'],
            wardDr: session['LOGON.WARDID'],
            isNQNursingAdvice: isNQNursingAdvice,
            intervArr: JSON.stringify(sumitintervDRRArr)
        }, false)
        if (rtnResult != "0") {
            $.messager.popover({
                msg: '撤销措施失败：' + rtnResult,
                type: 'error'
            });
            return false;
        }

        $.messager.popover({
            msg: '撤销成功！',
            type: 'success'
        });
    }
    PageLogicObj.m_QSGridSelRecordIdAfterLoad = recordId;
    $("#NurQuestionTable").datagrid('load');
}

// 护理问题计划提交
function QuestionPlanSumitClick() {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    if (QueSelRows.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    } else if (QueSelRows.length > 1) {
        $.messager.popover({
            msg: '请选择一条护理问题！',
            type: 'error'
        });
        return false;
    }else if ((QueSelRows[0].statusName ==$g("已停止"))||(QueSelRows[0].cstatus ==$g("已评价"))) {
        $.messager.popover({
            msg: '护理问题已停止/已评价！',
            type: 'error'
        });
        return false;
    }
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questionSub = recordId.split("||")[1];
    var isNQNursingAdvice = QueSelRows[0].isNQNursingAdvice;
    // 提交非评估相关因素
    if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
        var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
        var sumitfactorDRRArr = new Array();
        for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
            var statusName = QLRealateFactorSelRows[i].statusName;
            if (statusName == "作废") {
                $.messager.popover({
                    msg: '已作废的非相关评估因素记录不能提交！',
                    type: 'error'
                });
                return false;
            }
            var recordID = QLRealateFactorSelRows[i].recordID;
            if (recordID) continue;
            sumitfactorDRRArr.push(QLRealateFactorSelRows[i].factorDR);
        }
        if (sumitfactorDRRArr.length > 0) {
            var rtnJson = $.cm({
                ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
                MethodName: "CommitFactorRecord",
                planID: planID,
                questionSub: questionSub,
                optID: session['LOGON.USERID'],
                locDr: session['LOGON.CTLOCID'],
                wardDr: session['LOGON.WARDID'],
                factorDRList: sumitfactorDRRArr.join("^")
            }, false)
            if (rtnJson.errcode < 0) {
                $.messager.popover({
                    msg: '提交护理问题非相关因素失败！' + rtnJson.errinfo,
                    type: 'error'
                });
                return false;
            }
        }
    }
    // 提交护理目标
    if (ServerObj.IsOpenQuestionTarget == "Y") {
        var QuestionTargetTableSelRows = $("#QuestionTargetTable").datagrid("getSelections");
        var sumitgoalDRRArr = new Array();
        for (var i = 0; i < QuestionTargetTableSelRows.length; i++) {
            var goalStatus = QuestionTargetTableSelRows[i].goalStatus;
            if (goalStatus == $g("作废")) {
                $.messager.popover({
                    msg: '已作废的护理目标记录不能提交！',
                    type: 'error'
                });
                return false;
            }
            var recordID = QuestionTargetTableSelRows[i].recordID;
            if (recordID) continue;
            sumitgoalDRRArr.push(QuestionTargetTableSelRows[i].goalDR);
        }
        if (sumitgoalDRRArr.length > 0) {
            var rtnJson = $.cm({
                ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
                MethodName: "SaveGoalRecord",
                planID: planID,
                questionSub: questionSub,
                optID: session['LOGON.USERID'],
                locDr: session['LOGON.CTLOCID'],
                wardDr: session['LOGON.WARDID'],
                goalArr: JSON.stringify(sumitgoalDRRArr)
            }, false)
            if (rtnJson.errcode < 0) {
                $.messager.popover({
                    msg: '提交护理目标失败！' + rtnJson,
                    type: 'error'
                });
                return false;
            }
        }
    }
    // 提交护理措施
    var QuestionMeasureTableSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
    var sumitintervDRRArr = new Array();
    for (var i = 0; i < QuestionMeasureTableSelRows.length; i++) {
        var statusName = QuestionMeasureTableSelRows[i].statusName;
        if (statusName == $g("停止")) {
            $.messager.popover({
                msg: "停止状态的护理措施不能提交！",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("作废")) {
            $.messager.popover({
                msg: "作废状态的护理措施不能提交！",
                type: 'error'
            });
            return false;
        }
        var recordID = QuestionMeasureTableSelRows[i].recordID;
        if (recordID) continue;
        var week = QuestionMeasureTableSelRows[i].week;
        var defFreqWeek = QuestionMeasureTableSelRows[i].defFreqWeek;
        if (!defFreqWeek) defFreqWeek = "";
        if (!week) week = defFreqWeek;
        var startDateTime = QuestionMeasureTableSelRows[i].startDatetime;
        if (startDateTime) {
            var startDate = startDateTime.split(" ")[0];
            var startTime = startDateTime.split(" ")[1];
            if (dtseparator == "/") {
                var tmpdate = startDate.split("/")[2] + "-" + startDate.split("/")[1] + "-" + startDate.split("/")[0]
                var tmpdate1 = new Date(tmpdate.replace("-", "/").replace("-", "/"));
            } else {
                var tmpdate = startDate;
                var tmpdate1 = new Date(startDate.replace("-", "/").replace("-", "/"));
            }
            var CurDate = new Date();
            var end = new Date(CurDate.getFullYear() + "/" + (CurDate.getMonth() + 1) + '/' + CurDate.getDate());
            if (tmpdate1 < end) {
                $.messager.popover({
                    msg: "措施日期应大于等于当天：" + myformatter(end) + "！",
                    type: 'error'
                });
                return false;
            }
            if (!IsValidTime(startTime)) {
                $.messager.popover({
                    msg: "措施开始时间格式不正确! 时:分,如11:05",
                    type: 'error'
                });
                return false;
            }
            //var CurTime=GetCurTime("N");
            var timeStr = tmpdate + " " + startTime;
            if (+new Date() - 60000 > +new Date(timeStr)) {
                //if (parseInt(startTime.split(":")[1]) < parseInt(CurTime.split(":")[1])) {
                $.messager.popover({
                    msg: "措施开始时间应大于当前时间！",
                    type: 'error'
                });
                return false;
            }
        }
        var freqDR = QuestionMeasureTableSelRows[i].freqDR;
        if (!freqDR) freqDR = QuestionMeasureTableSelRows[i].defFreq;
        if ((isNQNursingAdvice == "Y") && (!freqDR)) {
            var intervName = QuestionMeasureTableSelRows[i].intervName;
            $.messager.popover({
                msg: "<font color=red>" + intervName + "</font>需要选择执行频率！",
                type: 'error'
            });
            return false;
        }
        var obj = {
            intervdr: QuestionMeasureTableSelRows[i].intervDR,
            freqdr: freqDR,
            rowID: QuestionMeasureTableSelRows[i].rowID,
            startDateTime: startDateTime,
            week: week
        };
        sumitintervDRRArr.push(obj);
    }
    if (sumitintervDRRArr.length > 0) {
        var rtnJson = $.cm({
            ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
            MethodName: "SaveIntervRecord",
            planID: planID,
            questionSub: questionSub,
            optID: session['LOGON.USERID'],
            locDr: session['LOGON.CTLOCID'],
            wardDr: session['LOGON.WARDID'],
            isNQNursingAdvice: isNQNursingAdvice,
            intervArr: JSON.stringify(sumitintervDRRArr)
        }, false)
        if (rtnJson.errcode < 0) {
            $.messager.popover({
                msg: '提交护理措施失败！' + rtnJson.errinfo,
                type: 'error'
            });
            return false;
        }
    }
    $.messager.popover({
        msg: '提交成功！',
        type: 'success'
    });
    PageLogicObj.m_QSGridSelRecordIdAfterLoad = recordId;
    $("#NurQuestionTable").datagrid('load');
    if (ServerObj.QPCCOpenNurPlanTrans=="Y"){
	    var Type="NURPLAN";
	    var TransferDesc=ServerObj.QPCCNurPlanTransFormat;
    	showTransferRecordWin(Type,TransferDesc,recordId);
    }
}
//转入护理记录
//------Start----------
function showTransferRecordWin(Type,TransferDesc,recordIds){
	var errmsg=""
	destroyDialog("QuestionDiag");
	var Content=initDiagDivHtml("transferRecord");
    var iconCls="icon-w-edit";
	createModalDialog("QuestionDiag",$g("转入护理记录"), 747, 465,iconCls,$g("确定"),Content,'transferRecord("'+Type+'","'+recordIds+'")');
	InitPatIfoBar(ServerObj.EpisodeID);
	// 转入护理记录 数据引用无法弹框 bug fix 
	//$("#BDataRefer").click(referHandlerClick);
	InitNursingRecordTemplate();
	$("#TransferDate").datebox("setValue",ServerObj.CurrentDate);
	$("#TransferTime").timespinner("setValue",GetCurTime("N"));
	$("#TransferUser").val(session['LOGON.USERNAME']);
	if (session['LOGON.LANGCODE']!='CN'){
		var username=$cm({
		    ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		    MethodName:"getUserNameDesc",
		    executeUser:session['LOGON.USERNAME'],
		    dataType: "text"
		},false);
		$("#TransferUser").val(username);
	}
	var TransferDescArr=$cm({
	    ClassName:"Nur.NIS.Service.NursingPlan.NPBasicData",
	    MethodName:"TransFormat",
	    episodeID:ServerObj.EpisodeID,
	    TransferDesc:TransferDesc,
	    RecordIDs:recordIds,
	},false);
	for (i=0;i<TransferDescArr.length;i++){
		var keyword=Object.keys(TransferDescArr[i]);
		//var desc=Object.values(TransferDescArr[i]);
		//医为浏览器
		var desc = Object.keys(TransferDescArr[i]).map(function(key) {
		    return TransferDescArr[i][key];
		});
		TransferDesc=TransferDesc.replace('['+keyword+']',desc);
	}
	//var tempString = getMergeDesc(TransferDescArr.join("  "))
	// $("#exeDesc").html(exeDescArr.join("&#13;"))
	var tempString = getMergeDesc(TransferDesc)
	$("#TransferDesc").html(tempString);
}
function transferRecord(Type,recordId){
	var sels= $("#NurQuestionTable").datagrid("getSelections");	
	if (sels.length==0){
		//重新选中护理问题
		if ((Type=="NURQE")&&(recordId)) {
	        var index = $('#NurQuestionTable').datagrid("getRowIndex", recordId);
	        if (index >= 0) {
	            $('#NurQuestionTable').datagrid("checkRow", index);
	            //PageLogicObj.m_QSGridSelRecordIdAfterLoad = "";
	        }
	    }
		sels= $("#NurQuestionTable").datagrid("getSelections");
		//重新获取护理问题
		
	}
	var RecordIds=[],recordDataArr=[];
	var EmrRecordId="";
	if (recordId!=""){
		EmrRecordId=$.cm({
			ClassName:"Nur.NIS.Service.NursingPlan.QuestionRecord",
			MethodName:"GetEmrRecordIdByRecordID",
			recordID:recordId,
			type:Type,
			dataType:"text"
		},false)
	}
	if (sels.length>0){
		for (var i=0;i<sels.length;i++){
			var RecordId=sels[i].recordId;
			if (!RecordId) continue;
			RecordIds.push(RecordId);
			if((Type!="")&&(Type=="NURPLAN")){
				EmrRecordId=sels[i].NQRECNPEmrRecordId
			}else if((Type!="")&&(Type=="NURQS")){
				EmrRecordId=sels[i].NQRECSEmrRecordId		
			}else if((Type!="")&&(Type=="NURQE")){
				EmrRecordId=sels[i].NQRECEEmrRecordId		
			}
			recordDataArr.push({
				episodeID:ServerObj.EpisodeID,
				locID:session['LOGON.CTLOCID'],
				userID:session['LOGON.USERID'],
				transdate:$("#TransferDate").datebox("getValue"),
				transtime:$("#TransferTime").timespinner("getValue"),
				transDesc:$("#TransferDesc").val(),
				emrRecordId:EmrRecordId,
				DescFlag:true, // 否有更改的标识
				record:[]
			});
		}
	}else{
		var RecordId=recordId;
		RecordIds.push(RecordId);
		recordDataArr.push({
			episodeID:ServerObj.EpisodeID,
			locID:session['LOGON.CTLOCID'],
			userID:session['LOGON.USERID'],
			transdate:$("#TransferDate").datebox("getValue"),
			transtime:$("#TransferTime").timespinner("getValue"),
			transDesc:$("#TransferDesc").val(),
			emrRecordId:EmrRecordId,
			DescFlag:true, // 否有更改的标识
			record:[]
		});		
	}
	var nurseRecordEntryTplId=""
	var templategrid = $('#NursingRecordTemplate').combogrid("grid");
	var templaterowdata = templategrid.datagrid('getSelected');
	if (!((templaterowdata==null)||(templaterowdata.length == 0))){
		var nurseRecordEntryTplId=templaterowdata.nurseRecordEntryTplId;
	}
	var TransFlag = $("#SureTrans").checkbox("getValue") ? 1 : "";
	//todo 多患者怎么批量转入
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		MethodName:"BatchTransferNursingRecord",
		userId:session['LOGON.USERID'],
		RecordIds:RecordIds.join("^"),
		recordData:JSON.stringify(recordDataArr),
		transferFlag:$("#SureTrans").checkbox("getValue") ? 1 : "",
		transferDesc: $("#TransferDesc").val(),
		hospDR:session['LOGON.HOSPID'],
		sessionArrayJson:GetSessionInfo(),
		nurseRecordEntryTplId:nurseRecordEntryTplId,
		Type:Type,
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			bakPatInfoBanner();
			destroyDialog("QuestionDiag");
			if (TransFlag!=""){
				$.messager.popover({msg:'转入护理记录成功！',type:'success'});
			}else{
				$.messager.popover({msg:'未勾选确认转入！',type:'error'});
			}
		}else{
			$.messager.popover({msg:'转入护理记录失败！'+rtn,type:'error'});
		}
	})

}

// 转入护理记录去重
function getMergeDesc(text)
{
	var textAll = text
	//var arr = textAll.split("&#13;");
	var arr = textAll.split("  ");
	var obj = {};
	var tmp = [];
	for(var i = 0 ;i< arr.length;i++){
	   if( !obj[arr[i]] ){
	      obj[arr[i]] = 1;
	      tmp.push(arr[i]);
	   }
	}
	
	//var finalstr = tmp.join("&#13;");
	var finalstr = tmp.join("  ");
	var tmp = null;
	return finalstr;
}
// 加载患者信息条数据（弹框）
function InitPatIfoBar(EpisodeID){
	if ((ServerObj.IsShowPatInfoBannner=="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
		//2023.02.28 医生站关于病人信息栏的调用修改
		InitPatInfoBanner(ServerObj.EpisodeID);
		/*
		setTimeout(function () {
			container=$('.pat-info-container')[1];
			
			try{
		        $(container).popover({
		            width: $(container).width(),
		            trigger:'hover',
		            arrow:false,
		            isTopZindex:true,
		            placement:'bottom',
		            content:"<div class='patinfo-hover-content'>"+$('.pat-info-container')[1].innerHTML+"</div>"
		        });
		        $(container).css('width','calc(100% - 8px)').before('<div class="pat-info-over">...</div>');
			}catch(err){
				console.info(err)
			}

		},50);
		*/		
	}	else if ((ServerObj.IsShowPatInfoBannner!="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
		var _patinfobanner=$("#patinfobanner");	
		var banner_bak=$("#PatInfoBannner").contents();
		//$('#patinfobanner').html('');
		if (_patinfobanner.length>0){	
			$("#patinfobanner").append(banner_bak);
		}
	}else{
		//HIS 版本8.2以上至8.5
		$.cm({
			ClassName:"Nur.NIS.Service.Base.Patient",
			MethodName:"GetPatient",
			EpisodeID:EpisodeID
		},function(PatInfo){
			var _$patInfo=$(".patInfoBanner_patInfoText");
			var sex=PatInfo.sex;
			if (sex =="女") {
				_$patInfo.append('<img src="../images/uiimages/bed/fmaleAvatar.png" alt="" class="patSexIcon">');
			}else{
				_$patInfo.append('<img src="../images/uiimages/bed/maleAvatar.png" alt="" class="patSexIcon">');
			}
			_$patInfo.append("<span class='patInfoBanner_patInfoText--name'>"+PatInfo.bedCode+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--name'>"+PatInfo.name+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.age+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.regNo+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.admReason+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.ctLocDesc+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.wardDesc+"</span>");
			$.cm({
				ClassName:"Nur.NIS.Service.Base.Patient",
				MethodName:"GetChunkIcons",
				episodeIDString:EpisodeID
			},function(icons){
				icons=icons[0];
				_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
				var appendHtml="<span class='patInfoBanner_patInfoText--otherInfo'>"
				_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>");
				for (var i=0;i<icons.length;i++){
					var src=icons[i].src;
					if (!src) continue;
					var title=icons[i].title;

					appendHtml+='<a href="#"><img src="../images/'+src+'" alt="'+title+'" title="'+title+'" class="patInfoBanner_patInfoIcon--icon"></a>';
				}
				appendHtml+="</span>";
				_$patInfo.append(appendHtml);
			})
		})
		
	}
}
// 拼接session信息
function GetSessionInfo()
{
	var websysSession = {}
	websysSession["LOGON.CTLOCID"] = session['LOGON.CTLOCID']
	websysSession["LOGON.WARDID"] = session['LOGON.WARDID']
	websysSession["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC']
	websysSession["LOGON.USERID"] = session['LOGON.USERID']
	websysSession["LOGON.SSUSERLOGINID"] = session['LOGON.SSUSERLOGINID']
	
	return JSON.stringify(websysSession);
}

function GetTransferDesc(episodeID,TransferDesc,recordIds)
{
	$cm({
	    ClassName:"Nur.NIS.Service.NursingPlan.NPBasicData",
	    MethodName:"TransFormat",
	    episodeID:episodeID,
	    TransferDesc:TransferDesc,
	    RecordIDs:recordIds,
	},function(jsonData){
	   return jsonData	     
	});	
}


//------End-----------
function InitNurQuestionTableGrid() {
    var ToolBar = [{
        id: "AddQuestion",
        text: '新增',
        iconCls: '	icon-add',
        handler: function () {
            InitEditWindow();
            $("#QuestionAddWin").window("open");
            if ((!PageLogicObj.m_QuestionTypeKW)||(!PageLogicObj.m_QuestionTypeKWLight)){
                InitQuestionTypeKW();         
            }
            InitQuestionTreeList();
        }
    }, {
        id: "CopyQuestion",
        text: '复制',
        iconCls: 'icon-copy',
        handler: function () {
            NurQuestionCopy('','');
        }
    }, '-', {
        id: "QuestionEvaluate",
        text: '评价',
        iconCls: 'icon-edit',
        handler: function () {	        	        
            ShowQuestionEvaluateWin();
        }
    }, {
        id: "QuestionRevokeEvaluate",
        text: '撤销评价',
        iconCls: 'icon-cancel-order',
        handler: function () {
	        RevokeQuestionComments();	        
            
        }
    },{
        id: "QuestionEvaluateAudit",
        text: '评价审核',
        iconCls: 'icon-person-seal',
        handler: function () {
            NurPlanEvaluateAudit();
        }
    }, '-', {
        id: "QuestionStop",
        text: '停止',
        iconCls: 'icon-stop-order',
        handler: function () {
            ShowNurQuestionStopWin();
        }
    }, {
        id: "QuestionCancel",
        text: '撤销',
        iconCls: 'icon-cancel-order',
        handler: function () {
            ShowNurQuestionCancelWin();
        }
    }, {
        id: "QuestionUnUse",
        text: '作废',
        iconCls: 'icon-abort-order',
        handler: function () {
            ShowNurQuestionUnUserWin();
        }
    }, {
        id: "QuestionRevokeUnUse",
        text: '撤销作废',
        iconCls: 'icon-back',
        handler: function () {
            NurQuestionRevokeUnUse();
        }
    }, '-', {
        id: "RowMoveUp",
        iconCls: 'icon-arrow-top',
        handler: function () {
            QuestionTableMove("up");
        }
    }, {
        id: "RowMoveDown",
        iconCls: 'icon-arrow-bottom',
        handler: function () {
            QuestionTableMove("down");
        }
    }, '-', {
	    id: "NurPlanReview",
        text: '计划审核',
        iconCls: 'icon-paper-upgrade-add',
        handler: function () {
	        NurPlanReview();            
        }
    },  {
	    id: "CancelNurPlanReview",
        text: '撤销计划审核',
        iconCls: 'icon-paper-x',
        handler: function () {
	        RevokeNurPlanReview();            
        }
    },'-', {
	    id:"PrintButton",
        text: '打印护理计划单',
        iconCls: 'icon-print',
        handler: function () {
            NurQuestionPlanPrint();
        }
    },  {
	    id:"CheckboxPrint",
        text: '按勾选打印护理计划单',
        iconCls: 'icon-print',
        handler: function () {
            NurQuestionPlanPrint(1);
        }
    },'-',{
	    id: "EditDateTime",
	    text: '修改创建时间',	    
        iconCls: 'icon-edit',
        handler: function () {
            EditDateTime("Question");
        }
	},{ // 需求2744200
		id:"ifMultiple_btn",
		text:'<label style="color:black;"><span title="设置表格是否可选多行，导出多条数据或批量删除使用" '+
		'style=\'color: red;padding-top:10px\' class=\'hisui-tooltip\'>*</span> '+ $g("选多行") +'</label>',
	}];
    var Columns = [
        [{
                field: 'NQRECSerialNo',
                title: '优先级',
                //width: 60, 
                //width: $(this).width()*(60/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(60/1035) : 60,
                editor: {
                    type: 'numberbox'
                }
            },
            {
                field: 'createDateTime',
                title: '创建时间',
                //width: 160,
                //width: $(this).width()*(160/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(160/1035) : 160,
            },
            {
                field: 'createUser',
                title: '创建护士',
                //width: 80,
                //width: $(this).width()*(80/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'statusName',
                title: '状态',
                //width: 70,
                //width: $(this).width()*(70/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(70/1035) : 70,
            },
            {
                field: 'cstatus',
                title: '评价状态',
                //width: 70,
                //width: $(this).width()*(70/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(70/1035) : 70,
            },
            {
                field: 'source',
                title: '来源',
                //width: 100,
                //width: $(this).width()*(100/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(100/1035) : 100,
            },
            {
                field: 'playDays',
                title: '目标达成天数',
                //width: 95,
                //width: $(this).width()*(95/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(95/1035) : 95,
                editor: {
                    type: 'numberbox'
                },
            },
            {
                field: 'playDate',
                title: '计划到期日',
                //width: 100,
                //width: $(this).width()*(100/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(100/1035) : 100,
                styler: function (value, row, index) {
                    if ((value != "") && (value != " ")) {
                        if (!CompareDate(value, ServerObj.CurrentDate)) {
                            return 'background-color:#FF5252;color:#FFFFFF;';
                        }
                    }
                }
            },
            {
                field: 'result',
                title: '评价结果',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            }, {
                field: 'evlRemark',
                title: '评价备注',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'evlUser',
                title: '评价人',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'evlTime',
                title: '评价时间',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            }, 
            {
                field: 'cancelEvlUser',
                title: '撤销评价人',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },          
            {
                field: 'cancelEvlTime',
                title: '撤销评价时间',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'EvlAuditUser',
                title: '评价审核人',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },          
            {
                field: 'EvlAuditTime',
                title: '评价审核时间',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'stopDateTime',
                title: '停止时间',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'stopUser',
                title: '停止护士',
                //width: 80
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'stopReason',
                title: '停止原因',
                //width: 150
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            /*{ field: 'cancelDateTime', title: '撤销时间',width:150},
            { field: 'cancelUser', title: '撤销护士',width:80},
            { field: 'cancelReason', title: '撤销原因',width:150}*/
            {
                field: 'abolishDateTime',
                title: '作废时间',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'abolishUser',
                title: '作废护士',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'abolishReason',
                title: '作废原因',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'planReviewUser',
                title: '计划审核人',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'planReviewTime',
                title: '计划审核时间',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'cancelplanReviewUser',
                title: '撤销计划审核人',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'cancelplanReviewTime',
                title: '撤销计划审核时间',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            }
        ]
    ];
    PageLogicObj.m_NurQuestionTableGrid = $('#NurQuestionTable').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        loadMsg: $g('加载中..'),
        pagination: true,
        rownumbers: false,
        idField: "recordId",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        nowrap: false,
        /*此处为false*/
        frozenColumns: [
            [{
                    field: 'recordId',
                    checkbox: 'true'
                },
                {
                    field: 'queName',
                    title: '护理问题',
                    width: fixWidth(0.16),
                    wordBreak: "break-all", //220
                    formatter: function (value, row, index) {
                        var newValue = value;
                        if (row.assessList != "[]") {
                            var style = "";
                            var FontColor = GetStatusFontColor(row.statusName);
                            if (FontColor) {
                                style = "color:" + FontColor + ";";
                            }
                            newValue = '<a style= "' + style + '"id= "' + row["recordId"] + '"onmouseover="ShowQueAssessList(this)">' + value + '</a>';
                        }
                        // 1:该问题的护理计划已制定，已确定护理目标、护理措施 --显示绿色对勾
                        // 2:触发数据已调整  --显示告警图标，三角中间一个叹号
                        // 3:临时医嘱触发的护理问题 临!
                        // 4:触发问题的长期医嘱已停止 长!
                        if (row.linkQueShowFlag) {
                            for (var i = 0; i < row.linkQueShowFlag.split("^").length; i++) {
                                var linkQueShowFlag = row.linkQueShowFlag.split("^")[i];
                                if (linkQueShowFlag == 1) {                                    
                                    if ((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)) {
	                                    newValue += '<span style="padding-left:5px;" class="icon icon-accept">&nbsp;</span>'
                                    }else{
	                                    newValue += '<img style="vertical-align:-3px;padding-left:5px;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png"/>';
	                                }
                                }
                                if (linkQueShowFlag == 2) {                                    
                                	if ((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)) {
	                                    newValue += '<span class="icon icon-alert-red">&nbsp;</span>'
                                    }else{
	                                    newValue += '<img style="vertical-align:-3px;padding-left:5px;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/alert_red.png"/>';
	                                }
                                }
                                if (linkQueShowFlag == 3) {
                                    newValue += '<span style="color:red;padding-left:5px;">' + $g("临!") + '</span>';
                                }
                                if (linkQueShowFlag == 4) {
                                    newValue += '<span style="color:red;padding-left:5px;">' + $g("长!") + '</span>';
                                }
                            }
                        }
                        return newValue;
                    },
                    styler: function (value, row, index) {
                        var FontColor = GetStatusFontColor(row.statusName);
                        if (FontColor) {
                            return 'color:' + FontColor + ";";
                        }
                    }
                }
            ]
        ],
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.QuestionRecord&QueryName=GetPatientQuestionList",
        onBeforeLoad: function (param) {
            $('#NurQuestionTable').datagrid("unselectAll");
            $.extend(PageLogicObj, {
                m_SelQuestionObj: {
                    planID: "",
                    questSub: "",
                    template: "",
                    statusName: $g("未停止"),
                    isNQNursingAdvice: "N",
                    queName:"",
                }
            });
            if (PageLogicObj.m_QuestionMeasureTableGrid) {
                if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
                    $("#QLRealateFactorTable").datagrid("load");
                }
                if (ServerObj.IsOpenQuestionTarget == "Y") {
                    $("#QuestionTargetTable").datagrid("load");
                }
                $("#QuestionMeasureTable").datagrid("load");
            }
            param = $.extend(param, {
                episodeID: ServerObj.EpisodeID,
                dateFrom: $("#QuestionSearchDateFrom").datebox('getValue'),
                dateTo: $("#QuestionSearchDateTo").datebox('getValue'),
                status: $("#QSearchEvaluateStatus").combobox('getValues').join("^"),
                queStatus: $("#QSearchStatus").combobox('getValues').join("^"),
                source: $("#QSearchDataSource").combobox('getValues').join("^"),
                searchName: $.trim($("#QuestionKeyWord").val()),

            });
            var ThisWardSearchFlag=$("#ThisWardSearch").is(':checked');
            if(ThisWardSearchFlag){
            	param = $.extend(param, {wardid:session['LOGON.WARDID']});
            }
        },
        onLoadSuccess: function (data) {
	       	//打印提示
   			toopTip("#PrintButton","bottom",$g("全部打印"));
	        // 隐藏按勾选打印按钮	        
	        $("#CheckboxPrint").hide(); 
            var hideColumns = "";
            // 是否启用护理评价
            // 评价流程：评价状态下拉框：未评价、已评价；
            if (ServerObj.IsOpenNurEvaluate == "Y") {   // 评价流程
                $("#QuestionStop").hide();              //隐藏停止按钮
                //$("#QuestionUnUse").hide();  		    //隐藏作废按钮
                //$("#QuestionRevokeUnUse").hide();  	//隐藏撤销作废按钮                  
                //状态下拉框不显示 
                //$("#QSearchStatus").parent().prev().hide();
                //$("#QSearchStatus").parent().hide();  
                // 隐藏列                              
                //var hideColumns = "statusName^stopDateTime^stopUser^stopReason^abolishDateTime^abolishUser^abolishReason";
                var hideColumns = "stopDateTime^stopUser^stopReason";
            } else {      								// 停止流程            
                $("#QSearchEvaluateStatus").parent().prev().hide(); //需求：2569992
                $("#QSearchEvaluateStatus").parent().hide(); //需求：2569992

                $("#QuestionEvaluate,#QuestionEvaluateAudit").hide();
                $("#QuestionEvaluate").parent().prev().hide();
                var hideColumns = "cstatus^result^evlUser^evlTime^evlRemark^cancelEvlUser^cancelEvlTime^EvlAuditUser^EvlAuditTime";
                // 不启用护理评价时,判断护理问题是否启用停止
                if (ServerObj.StopApplyToQuestion != "Y") {
                    $("#QuestionStop").hide();
                    hideColumns += "^stopDateTime^stopUser^stopReason";
                }
            }
            // 是否启用评价审核
            if (ServerObj.IsOpenNurEvaluateAudit != "Y") {
            	$("#QuestionEvaluateAudit").hide();
            	hideColumns += "^EvlAuditUser^EvlAuditTime";
            }else{
	            if ((ServerObj.QPCCNursePlanEvalPermission!="")&&(("^"+ServerObj.QPCCNursePlanEvalPermission+"^").indexOf("^"+session['LOGON.USERID']+"^")==-1)){
                	// 登录用户没有评价审核权限
                  	$("#QuestionEvaluateAudit").hide();
                	hideColumns += "^EvlAuditUser^EvlAuditTime";
	            }	            
	        }
            // ----2022-10-19 add---
            //是否允许撤销评价
            if (ServerObj.QPCCOpenCancelNurEvaluate != "Y") {
                $("#QuestionRevokeEvaluate").hide();
                hideColumns += "^cancelEvlUser^cancelEvlTime";
            }
            //是否进行计划审核
            if (ServerObj.QPCCOpenNurPlanReview != "Y") {
                $("#NurPlanReview").hide();
                hideColumns += "^planReviewUser^planReviewTime";
	            //是否允许撤销计划审核
	            if (ServerObj.QPCCOpenCancelNurPlanReview != "Y") {
	                $("#CancelNurPlanReview").hide();
	                $("#CancelNurPlanReview").parent().next().hide();
	                hideColumns += "^cancelplanReviewUser^cancelplanReviewTime";
	            }
            }else{
	           	//是否允许撤销计划审核
	            if (ServerObj.QPCCOpenCancelNurPlanReview != "Y") {
	                $("#CancelNurPlanReview").hide();
	                hideColumns += "^cancelplanReviewUser^cancelplanReviewTime";
	            }
	            
	        }
	        
            //是否显示目标达成天数
            if (ServerObj.QPCCOpenPlayDays!="Y"){
	            hideColumns += "^playDays^playDate";
	        }else{
		        if (ServerObj.QPCCDefaultPlayDays!=""){
		        	var rows=$('#NurQuestionTable').datagrid("getRows");
			        for (var rowIndex=0;rowIndex<rows.length;rowIndex++){
				        $('#NurQuestionTable').datagrid('beginEdit',rowIndex);
			        	var Editors = $('#NurQuestionTable').datagrid('getEditors', rowIndex);
			        	 Editors.forEach(function (value, index, array) {
				        	 if (array[index].field == "playDays") {
					        	 if ($(array[index].target).numberbox('getValue')=="")
					        	 $(array[index].target).numberbox('setValue',ServerObj.QPCCDefaultPlayDays);
					        	 playDaysChange(array[index].target);
		                    }
				       	 });		        
			        }
		        }
		        
		    } 
		    //是否需自定评价备注
		    if (ServerObj.QPCCOpenNurSelfDefEvaluate!="Y"){
			    hideColumns += "^evlRemark";
			}          
            //是否启用护理问题优先级
            if (ServerObj.IsOpenQuestionPriority != "Y") {
                $("#RowMoveUp,#RowMoveDown").hide();
                $("#RowMoveUp").parent().prev().hide();
                // 隐藏 优先级列
                hideColumns += "^NQRECSerialNo";
            }

            // 撤销不适用于护理计划
            if (ServerObj.CancelApplyToQuestion != "Y") {
                $("#QuestionCancel").hide();
            }
            // 作废不适用于护理计划
            if (ServerObj.UnUserApplyToQuestion != "Y") {
                $("#QuestionUnUse,#QuestionRevokeUnUse").hide();
                hideColumns += "^abolishDateTime^abolishUser^abolishReason";
                if ((ServerObj.StopApplyToQuestion != "Y") && (ServerObj.CancelApplyToQuestion != "Y") && (ServerObj.IsOpenNurEvaluate != "Y")) {
                    $("#QuestionStop").parent().prev().hide();
                }
            }
            /*
            // 是否允许修改护理计划创建时间
            if(ServerObj.QPCCEditDateTime != "Y"){
	            $("#EditDateTime").hide();	            
	        }
	        */
	        // 隐藏 【修改创建时间】按钮 转为双击单元格修改
	        $("#EditDateTime").hide();
	        // 隐藏列
            if (hideColumns != "") {
                for (var i = 0; i < hideColumns.split("^").length; i++) {
                    var hideColumn = hideColumns.split("^")[i];
                    if (!hideColumn) continue;
                    $('#NurQuestionTable').datagrid("hideColumn", hideColumn);
                }
            }
            
            // 处理护理计划提交后,护理问题检索成功若检索结果中包含上一次提交的记录则自动选中
            setTimeout(function () {
                if (PageLogicObj.m_QSGridSelRecordIdAfterLoad) {
                    var FindRowFlag = "N";
                    if (data.total > 0) {
                        var index = $('#NurQuestionTable').datagrid("getRowIndex", PageLogicObj.m_QSGridSelRecordIdAfterLoad);
                        if (index >= 0) {
                            $('#NurQuestionTable').datagrid("checkRow", index);
                            PageLogicObj.m_QSGridSelRecordIdAfterLoad = "";
                            FindRowFlag = "Y";
                        }
                    }
                    if (FindRowFlag == "N") {
                        if (PageLogicObj.m_QuestionMeasureTableGrid) {
                            if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
                                $("#QLRealateFactorTable").datagrid("load");
                            }
                            if (ServerObj.IsOpenQuestionTarget == "Y") {
                                $("#QuestionTargetTable").datagrid("load");
                            }
                            $("#QuestionMeasureTable").datagrid("load");
                        }
                    }
                }
            })            
            // 需求2744200护理计划增加多选功能，可进行批量操作
            //在 HTML 页面上创建一个自定义复选框，它将根据页面对象中的 'ifMultiple' 字段的值而自动设置其选中或未选中状态，并为其添加 change 事件。change 事件将改变 singleSelect 属性值，从而使 datagrid 控件支持单选/多选状态。
			$(document).ready(function () {
				var inputlength = $("[id=ifMultiple]").length
		        var toolbarlength = $("[id=ifMultiple_toolbar]").length
				if(toolbarlength==0) {
					$("#ifMultiple_btn").parent().wrapInner("<div id= \"ifMultiple_toolbar\" style=\"align-items: center;\"></div>");
					$("#ifMultiple_toolbar").css({display:"flex"});
				}
				if (PageLogicObj.ifMultiple=="true"){
					if(inputlength==0) {						
						$('<input class="hisui-checkbox" type="checkbox" checked="true" id="ifMultiple" style="width: 15px;height: 15px;margin-top: 0px;padding-top: 0px;"></input>').appendTo("#ifMultiple_toolbar");
					}else{
						$("#ifMultiple_toolbar").attr("checked","true")
					}					
				}else {
					if(inputlength==0) {						
						$('<input class="hisui-checkbox" type="checkbox" id="ifMultiple" style="width: 15px;height: 15px;margin-top: 0px;padding-top: 0px;"></input>').appendTo("#ifMultiple_toolbar");
					}else{
						$("#ifMultiple_toolbar").attr("checked","false")
					}
				}			
				$("#ifMultiple_btn").removeAttr("class");  //取消点击
				//自定义checkbox加change事件	
				$('#ifMultiple').change(function() {
					if($(this).is(':checked')){
						$("#ifMultiple").val('true')
						PageLogicObj.ifMultiple='true'
						$("#NurQuestionTable").datagrid({ singleSelect: false,})			
					}else{
						$("#ifMultiple").val('false')
						PageLogicObj.ifMultiple='false'
						$("#NurQuestionTable").datagrid({ singleSelect: true,})						
					}
				});	
			});
			//datagrid冻结列，行错位
			$(this).datagrid("fixRowHeight");
			var rowDoms =$(this).parent().children().find(".datagrid-btable .datagrid-row");
			if(rowDoms.length>0){
				for(var i=0;i<rowDoms.length/2;i++){
					var rowDom=rowDoms[i];
					var rowDom2=rowDoms[i+rowDoms.length/2];
					$(rowDom).height($(rowDom2).height());
				}
			}			
        },
        loadFilter: function (data) {
            // todo 优化若修改后台输出列checked名字是否可以,checked列会导致表格加载成功后checkbox自动勾选
            var NewRows = new Array();
            for (var i = 0; i < data.rows.length; i++) {
                var obj = data.rows[i];
                delete obj.checked;
                NewRows.push(obj);
            }
            return {
                rows: NewRows,
                total: data.total
            };
        },
        //这段代码在onClickCell() 函数中，为每个特定的单元格绑定了特定的监听函数［playDaysChange()，NQRECSerialNoChange()］, 当立即取消选中一行或者当一行被双击激活编辑时，会触发监听函数中的特定事件，这就是为什么取消选中框会重新被选中的原因。
        onClickCell: function (rowIndex, field, value) {
            if ((field == "playDays") || (field == "NQRECSerialNo")) {
                $('#NurQuestionTable').datagrid("beginEdit", rowIndex);
                var Editors = $('#NurQuestionTable').datagrid('getEditors', rowIndex);

                Editors.forEach(function (value, index, array) {
                    if (array[index].field == field) {
                        $(array[index].target).focus().select();
                    }
                    if (array[index].field == "playDays") {
                        //var EditorIndex=0;
                        //if ((ServerObj.IsOpenQuestionPriority =="Y")||(Editors.length >= 2)) {
                        //	EditorIndex=1;
                        //}

                        $(array[index].target).bind('keyup', function (e) {
                            var code = e.keyCode || e.which;
                            if (code == 13) {
                                playDaysChange(array[index].target);
                            }
                        });
                        $(array[index].target).bind('change', function (e) {
                            playDaysChange(array[index].target);
                        });
                    } else if (array[index].field == "NQRECSerialNo") {

                        $(array[index].target).bind('keyup', function (e) {
                            var code = e.keyCode || e.which;
                            if (code == 13) {
                                NQRECSerialNoChange(array[index].target);
                            }
                        });
                        $(array[index].target).bind('change', function (e) {
                            NQRECSerialNoChange(array[index].target);
                        });
                    }
                });
            }
        },
        onDblClickCell: function(index,field,value){
	        if ((field == "createDateTime")&&(ServerObj.QPCCEditDateTime == "Y")) {
		        	var QPCCNurPlanPermission=ServerObj.QPCCNurPlanPermission;
		        	var row=$("#NurQuestionTable").datagrid("getRows");		        	
					if (QPCCNurPlanPermission=="S&L"){
						//勾选 【本人】和【护士长】，创建者和护士长有护理计划的修改创建时间操作权限配置
						if ((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(session['LOGON.USERID']==row[index].createUserId)){
							EditDateTime("Question");							
						}
					}else if (QPCCNurPlanPermission=="S"){
						//勾选【本人】，只有创建者有护理计划的修改创建时间操作权限配置
						if (session['LOGON.USERID']==row[index].createUserId){
							EditDateTime("Question");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//勾选【护士长】，只有护士长有护理计划的修改创建时间操作权限配置
						if (session['LOGON.GROUPDESC'].indexOf('护士长')!=-1){
							EditDateTime("Question");
						}		
					} else if (QPCCNurPlanPermission==""){
						//如果未勾选“本人”或“护士长”，则表示本病区所有护士均可操作，不设权限
					}		        
		    }	        
	    },
        onSelect: function (rowIndex, rowData) {
            SetSelQuestionObj(rowData);
            $("#QuestionMakePanel").panel("setTitle", $g("计划制定") + " <font color=red>" + rowData.queName + "</font>");
            if (!PageLogicObj.m_QuestionMeasureTableGrid) {
                // 初始化非相关因素、护理目标、护理措施表格
                // 是否启用非评估相关因素
                if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
                    InitQLRealateFactorTableGrid();
                }
                // 是否启用护理目标
                if (ServerObj.IsOpenQuestionTarget == "Y") {
                    InitQuestionTargetTableGrid();
                }
                InitQuestionMeasureTableGrid();
            } else {
                if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
                    $("#QLRealateFactorTable").datagrid("load");
                }
                if (ServerObj.IsOpenQuestionTarget == "Y") {
                    $("#QuestionTargetTable").datagrid("load");
                }
                $("#QuestionMeasureTable").datagrid("load");
            }            
            SetNurPalnBtnStatus(rowData.statusName);            
            SetNurPalnBtnCstatus(rowData.cstatus);            
            SetNurPalnBtnPermission(rowData.createUserId,rowData.planReviewUserID); //2022-10-19 add
            var selRows=$("#NurQuestionTable").datagrid("getSelections");	
	        //打印提示
			if (selRows.length>=1){
   				toopTip("#PrintButton","bottom",$g("按勾选打印"));
			}else{
				toopTip("#PrintButton","bottom",$g("全部打印"));
			}            
        },
        onUnselect: function (rowIndex, rowData) {
	        var selRows=$("#NurQuestionTable").datagrid("getSelections");	
	        //打印提示
	        if (selRows.length>=1){
   				toopTip("#PrintButton","bottom",$g("按勾选打印"));
	        }else{
				toopTip("#PrintButton","bottom",$g("全部打印"));
			}
	    },
    })
    /*
    // 2021.7.27 add
    if (ServerObj.IsOpenTreatDays == "Y")
    {
    	$("#QuestionPanel-table .datagrid-toolbar tr").append("<td class='days-td'><span id='days'>"+$g("计划治疗天数：")+ServerObj.days+$g(" 天")+"</span></td>");
    }
    */
}

function InitQLRealateFactorTableGrid() {
    var ToolBar = [{
        text: '新增',
        iconCls: '	icon-add',
        handler: function () {
            ShowAddQLRealateFactorWin();
        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            DelQLRealateFactor();
        }
    }];
    /*if (ServerObj.CancelApplyToQuestionRealateFactor =="Y") {
    	ToolBar.push("-");
    	ToolBar.push({
    			text: '撤销',
    			iconCls: 'icon-cancel-order',
    			handler: function() {
    				ShowQLRealateFactorCancelWin();
    			}
    	})
    }*/
    if (ServerObj.UnUserApplyToQuestionRealateFactor == "Y") {
        ToolBar.push("-");
        ToolBar.push({
            text: '作废',
            iconCls: 'icon-abort-order',
            handler: function () {
                ShowQLRealateFactorUnUseWin();
            }
        })
        ToolBar.push({
            text: '撤销作废',
            iconCls: 'icon-back',
            handler: function () {
                RevokeUnUseFactorRecord();
            }
        })

        
    }
    //将时间修改按钮转移到双击单元格
    /*
    if (ServerObj.QPCCEditDateTime == "Y"){
	    ToolBar.push({
	        text: '时间修改',
	        iconCls: 'icon-edit',
	        handler: function () {
            EditDateTime("QLRealate");
	        }
	    })	        
	 }
	 */
    var Columns = [
        [{
                field: 'statusName',
                title: '状态',
                width: 60
            },
            {
                field: 'createAt',
                title: '创建时间',
                width: 160
            },
            {
                field: 'recordUser',
                title: '护士',
                width: 80
            },
            {
                field: 'dataSource',
                title: '数据来源',
                width: 80
            }
        ]
    ];
    PageLogicObj.m_QLRealateFactorTableGrid = $('#QLRealateFactorTable').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: false,
        autoRowHeight: false,
        loadMsg: $g('加载中..'),
        pagination: true,
        rownumbers: false,
        idField: "factorDR",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        nowrap: false,
        /*此处为false*/
        rowStyler: function (index, row) {
            if ((row.recordID) && (row.statusName == $g("提交"))) {
                return 'background:' + ServerObj.SumitedRowColor + ';';
            }
        },
        frozenColumns: [
            [{
                    field: 'factorDR',
                    checkbox: 'true'
                },
                {
                    field: 'factorName',
                    title: '非评估相关因素',
                    width: 200,
                    wordBreak: "break-all",
                    formatter: function (value, row, index) {
                        if ((!row.statusName) && (row.dataSource == $g("手动录入")) && (PageLogicObj.m_SelQuestionObj.statusName == $g("未停止"))) {
                            return '<span>' + value + '</span><a class="measure_editcls" onclick="EditQuestionFactor(\'' + row["factorDR"] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png"/></a>';
                        } else {
                            return value;
                        }
                    },
                    styler: function (value, row, index) {
                        var FontColor = GetStatusFontColor(row.statusName);
                        if (FontColor) {
                            return 'color:' + FontColor + ";";
                        }
                    }
                }
            ]
        ],
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.GoalInterventionRecord&QueryName=QueryRelateFactorByQuestID",
        onBeforeLoad: function (param) {
            $('#QLRealateFactorTable').datagrid("unselectAll");
            param = $.extend(param, {
                planID: PageLogicObj.m_SelQuestionObj.planID,
                questSub: PageLogicObj.m_SelQuestionObj.questSub
            });
        },
        onDblClickCell: function(index,field,value){
	        if ((field == "createAt")&&(ServerObj.QPCCEditDateTime == "Y")) {
		        	var QPCCNurPlanPermission=ServerObj.QPCCNurPlanPermission;
		        	var row=$("#QLRealateFactorTable").datagrid("getRows");		        	
					if (QPCCNurPlanPermission=="S&L"){
						//勾选 【本人】和【护士长】，创建者和护士长有护理计划的修改创建时间操作权限配置
						if ((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(session['LOGON.USERID']==row[index].recordUserId)){
							EditDateTime("QLRealate");						
						}
					}else if (QPCCNurPlanPermission=="S"){
						//勾选【本人】，只有创建者有护理计划的修改创建时间操作权限配置
						if (session['LOGON.USERID']==row[index].recordUserId){
							EditDateTime("QLRealate");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//勾选【护士长】，只有护士长有护理计划的修改创建时间操作权限配置
						if (session['LOGON.GROUPDESC'].indexOf('护士长')!=-1){
							EditDateTime("QLRealate");
						}		
					} else if (QPCCNurPlanPermission==""){
						//如果未勾选“本人”或“护士长”，则表示本病区所有护士均可操作，不设权限
					}		        
		    }	        
	    },
    })
}

function InitQuestionTargetTableGrid() {
    var ToolBar = [{
        text: '新增',
        iconCls: '	icon-add',
        handler: function () {
            ShowAddQuestionTargetWin();
        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            DelQuestionTarget();
        }
    }];
    /*if (ServerObj.CancelApplyToQuestionTarget =="Y") {
    	ToolBar.push("-");
    	ToolBar.push({
    			text: '撤销',
    			iconCls: 'icon-cancel-order',
    			handler: function() {
    				ShowQuestionTargetCancelWin();
    			}
    	})
    }*/
    if (ServerObj.UnUserApplyToQuestionTarget == "Y") {
        ToolBar.push("-");
        ToolBar.push({
            text: '作废',
            iconCls: 'icon-abort-order',
            handler: function () {
                ShowQuestionTargetUnUseWin();
            }
        })
        ToolBar.push({
            text: '撤销作废',
            iconCls: 'icon-back',
            handler: function () {
                RevokeUnUseQuestionTarget();
            }
        })
    }
    //将时间修改按钮转移到双击单元格
    /*
    if (ServerObj.QPCCEditDateTime == "Y"){
	    ToolBar.push({
	        text: '时间修改',
	        iconCls: 'icon-edit',
	        handler: function () {
	            EditDateTime("Target");
	        }
	    })	        
	}
	*/
    var Columns = [
        [{
                field: 'goalStatus',
                title: '状态',
                width: 60
            },
            {
                field: 'createAt',
                title: '创建时间',
                width: 160
            },
            {
                field: 'sign',
                title: '护士签名',
                width: 80
            },
            {
                field: 'dataSource',
                title: '数据来源',
                width: 80
            }
        ]
    ];
    PageLogicObj.m_QuestionTargetTableGrid = $('#QuestionTargetTable').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: false,
        autoRowHeight: false,
        loadMsg: $g('加载中..'),
        pagination: true,
        rownumbers: false,
        idField: "goalDR",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        nowrap: false,
        /*此处为false*/
        rowStyler: function (index, row) {
            if ((row.recordID) && (row.goalStatus == $g("提交"))) {
                return 'background:' + ServerObj.SumitedRowColor + ';';
            }
        },
        frozenColumns: [
            [{
                    field: 'goalDR',
                    checkbox: 'true'
                },
                {
                    field: 'goalName',
                    title: '护理目标',
                    width: 200,
                    wordBreak: "break-all",
                    formatter: function (value, row, index) {
                        if ((!row.recordID) && (row.goalStatus == "") && (row.dataSource == $g("手动录入")) && (PageLogicObj.m_SelQuestionObj.statusName == $g("未停止"))) {
                            return '<span>' + value + '</span><a class="measure_editcls" onclick="EditQuestionTarget(\'' + row["goalDR"] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png"/></a>';
                        } else {
                            return value;
                        }
                    },
                    styler: function (value, row, index) {
                        var FontColor = GetStatusFontColor(row.goalStatus);
                        if (FontColor) {
                            return 'color:' + FontColor + ";";
                        }
                    }
                }
            ]
        ],
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.GoalInterventionRecord&QueryName=QueryGoalByQestID",
        onBeforeLoad: function (param) {
            $('#QuestionTargetTable').datagrid("unselectAll");
            param = $.extend(param, {
                planID: PageLogicObj.m_SelQuestionObj.planID,
                questSub: PageLogicObj.m_SelQuestionObj.questSub
            });
        }, 
        onDblClickCell: function(index,field,value){
	        if ((field == "createAt")&&(ServerObj.QPCCEditDateTime == "Y")) {
		        	var QPCCNurPlanPermission=ServerObj.QPCCNurPlanPermission;
		        	var row=$("#QuestionTargetTable").datagrid("getRows");		        	
					if (QPCCNurPlanPermission=="S&L"){
						//勾选 【本人】和【护士长】，创建者和护士长有护理计划的修改创建时间操作权限配置
						if ((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(session['LOGON.USERID']==row[index].nurId)){
							EditDateTime("Target");					
						}
					}else if (QPCCNurPlanPermission=="S"){
						//勾选【本人】，只有创建者有护理计划的修改创建时间操作权限配置
						if (session['LOGON.USERID']==row[index].nurId){
							EditDateTime("Target");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//勾选【护士长】，只有护士长有护理计划的修改创建时间操作权限配置
						if (session['LOGON.GROUPDESC'].indexOf('护士长')!=-1){
							EditDateTime("Target");
						}		
					} else if (QPCCNurPlanPermission==""){
						//如果未勾选“本人”或“护士长”，则表示本病区所有护士均可操作，不设权限
					}		        
		    }	        
	    },
    })
}

function InitQuestionMeasureTableGrid() {
    var ToolBar = [{
        text: '新增',
        iconCls: '	icon-add',
        handler: function () {
            ShowAddQuestionMeasureWin();
        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            DelQuestionMeasure();
        }
    }];
    if (ServerObj.StopApplyToQuestionMeasure == "Y") {
        ToolBar.push("-");
        ToolBar.push({
            text: '停止',
            iconCls: 'icon-stop-order',
            handler: function () {
                ShowQuestionMeasureStopWin();
            }
        });
    }
    if (ServerObj.UnUserApplyToQuestionMeasure == "Y") {
        if (ServerObj.StopApplyToQuestionMeasure != "Y") {
            ToolBar.push("-");
        }
        ToolBar.push({
            text: '作废',
            iconCls: 'icon-abort-order',
            handler: function () {
                ShowQuestionMeasureUnUseWin();
            }
        })
        ToolBar.push({
            text: '撤销作废',
            iconCls: 'icon-back',
            handler: function () {
                RevokeUnUseQuestionMeasure();
            }
        })
    }
    //将时间修改按钮转移到双击单元格
    /*
    if (ServerObj.QPCCEditDateTime == "Y"){	    
        ToolBar.push({
	        text: '时间修改',
	        iconCls: 'icon-edit',
	        handler: function () {
	            EditDateTime("Intervention");
	        }
	    })
	}
	*/
    var Columns = [
        [{
                field: 'defFreqName',
                title: '执行频率',
                width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        // 增加就诊id入参 2021.7.5
                        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionFreq&rows=99999&active=Y&episodeID=" + ServerObj.EpisodeID,
                        valueField: 'id',
                        textField: 'name',
                        loadFilter: function (data) {
                            var newData = new Array();
                            for (var i = 0; i < data.total; i++) {
                                var obj = data.rows[i];
                                obj.name = obj.code + "(" + obj.namec + ")";
                                newData.push(obj);
                            }
                            return newData;
                        },
                        onSelect: function (rec) {
                            if (rec) {
                                // 注释掉源代码
                                //var rows=$("#QuestionMeasureTable").datagrid("selectRow",PageLogicObj.m_QSMeasureEditIndex).datagrid("getSelected");
                                // 2021.6.2 护理措施表格中每次选频次，都会把第一条的频次替换掉 bug fix start
                                $("#QuestionMeasureTable").datagrid("selectRow", PageLogicObj.m_QSMeasureEditIndex).datagrid("getSelected");
                                var rows = $("#QuestionMeasureTable").datagrid("getRows")[PageLogicObj.m_QSMeasureEditIndex];
                                // end
                                rows.freqDR = rec.id;
                                if (rec.weekFlag == "Yes") {
                                    var disposing = rec.disposing;
                                    var intervName = rows.intervName;
                                    InitWeekFreqWin(intervName);
                                    InitWeekTable(rec.name, disposing);
                                    $("#WeekFreqWin").window("open");
                                } else {
                                    var Editors = $('#QuestionMeasureTable').datagrid('getEditors', PageLogicObj.m_QSMeasureEditIndex);
                                    if (Editors.length > 1) {
                                        var startDatetime = $(Editors[1].target).datetimebox('getValue');
                                    } else {
                                        var startDatetime = rec.id;
                                    }
                                    $(this).combobox("hidePanel");
                                    $('#QuestionMeasureTable').datagrid('updateRow', {
                                        index: PageLogicObj.m_QSMeasureEditIndex,
                                        row: {
                                            freqDR: rec.id,
                                            exectime: rec.disposing,
                                            defFreqName: rec.name,
                                            startDatetime: startDatetime
                                        }
                                    });
                                    PageLogicObj.m_QSMeasureEditIndex = "";
                                }
                            }
                        }
                    }
                }
            }, //defFreq 频次优化 query中返回执行频率描述
            {
                field: 'exectime',
                title: '计划执行时间',
                width: 100,
                showTip: true,
                tipWidth: 350,
                tipPosition: 'top'
            },
            {
                field: 'startDatetime',
                title: '开始时间',
                width: 150,
                editor: {
                    type: 'datetimebox',
                    options: {
                        showSeconds: false,
                        onHidePanel: function () {
                            var Editors = $('#QuestionMeasureTable').datagrid('getEditors', PageLogicObj.m_QSMeasureEditIndex);
                            var startDatetime = $(Editors[1].target).datetimebox('getValue');
                            $('#QuestionMeasureTable').datagrid('updateRow', {
                                index: PageLogicObj.m_QSMeasureEditIndex,
                                row: {
                                    startDatetime: startDatetime
                                }
                            });
                            PageLogicObj.m_QSMeasureEditIndex = "";
                        }
                    }
                }
            },
            {
                field: 'statusName',
                title: '状态',
                width: 60
            },
            {
                field: 'dataSource',
                title: '来源',
                width: 80
            },
            {
                field: 'createdAt',
                title: '创建时间',
                width: 160
            },
            {
                field: 'sign',
                title: '提交人',
                width: 80
            },
            // 2021.8.30 add 停止、作废信息
            {
                field: 'stopUser',
                title: '停止人',
                width: 80
            },
            {
                field: 'stopDatetime2',
                title: '停止时间',
                width: 160,
				formatter: function(value,row,index){
				if (row.statusName==$g("作废")){
					 return "";
					}
				else{
					return value;
					}
				}
            },
            {
                field: 'stopReason',
                title: '停止原因',
                width: 160
            },
            {
                field: 'cancelUser',
                title: '作废人',
                width: 80
            },
            {
                field: 'cancelDatetime2',
                title: '作废时间',
                width: 160
            },
            {
                field: 'cancelReason',
                title: '作废原因',
                width: 160
            }
        ]
    ];
    var MeasureTableFitColumns = (ServerObj.IsOpenQLQLRealateFactor == "Y" ? false : (ServerObj.IsOpenQuestionTarget == "Y" ? false : true));
    PageLogicObj.m_QuestionMeasureTableGrid = $('#QuestionMeasureTable').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: MeasureTableFitColumns,
        autoRowHeight: false,
        loadMsg: '加载中..',
        pagination: true,
        rownumbers: false,
        idField: "intervDR",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        autoSizeColumn: false,
        nowrap: false,
        /*此处为false*/
        rowStyler: function (index, row) {
            if ((row.recordID) && (row.statusName == $g("提交"))) {
                return 'background:' + ServerObj.SumitedRowColor + ';';
            }
        },
        frozenColumns: [
            [{
                    field: 'intervDR',
                    checkbox: 'true'
                },
                {
                    field: 'intervName',
                    title: '护理措施',
                    width: (MeasureTableFitColumns ? fixWidth(0.25) : 200),
                    wordBreak: "break-all",
                    formatter: function (value, row, index) {
                        if ((row.statusName == "") && (row.dataSource == $g("手动加入")) && (PageLogicObj.m_SelQuestionObj.statusName == $g("未停止"))) {
                            return '<span>' + value + '</span><a class="measure_editcls" onclick="EditQuestionMeasure(\'' + row["intervDR"] + '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png"/></a>';
                        } else {
                            return value;
                        }
                    },
                    styler: function (value, row, index) {
                        var FontColor = GetStatusFontColor(row.statusName);
                        if (FontColor) {
                            return 'color:' + FontColor + ";";
                        }
                    }
                }
            ]
        ],
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.GoalInterventionRecord&QueryName=QueryInterventionByQestID",
        onBeforeLoad: function (param) {
            $.extend(PageLogicObj, {
                m_QSMeasureEditIndex: ""
            });
            $('#QuestionMeasureTable').datagrid("unselectAll");
            param = $.extend(param, {
                planID: PageLogicObj.m_SelQuestionObj.planID,
                questSub: PageLogicObj.m_SelQuestionObj.questSub,
                template: "", //PageLogicObj.m_SelQuestionObj.template
                singAdvice: "Y",
                hospDR: session['LOGON.HOSPID']
            });
        },
        onClickCell: function (rowIndex, field, value) {
            var row = $('#QuestionMeasureTable').datagrid("getRows");
            if (((field == "defFreqName") || (field == "startDatetime")) && (row[rowIndex].statusName == "") && (PageLogicObj.m_SelQuestionObj.isNQNursingAdvice == "Y")) {
                if (PageLogicObj.m_QSMeasureEditIndex !== "") {
                    $('#QuestionMeasureTable').datagrid("endEdit", PageLogicObj.m_QSMeasureEditIndex);
                }
                $('#QuestionMeasureTable').datagrid("beginEdit", rowIndex);
                var Editors = $('#QuestionMeasureTable').datagrid('getEditors', rowIndex);
                if (field == "defFreqName") {
                    $(Editors[0].target).next('span').find('input').focus().select();
                } else if (field == "startDatetime") {
                    $(Editors[1].target).next('span').find('input').focus().select();
                }
                PageLogicObj.m_QSMeasureEditIndex = rowIndex;
            }
        },
        onDblClickCell: function(index,field,value){
	        if ((field == "createdAt")&&(ServerObj.QPCCEditDateTime == "Y")) {
		        	var QPCCNurPlanPermission=ServerObj.QPCCNurPlanPermission;
		        	var row=$("#QuestionMeasureTable").datagrid("getRows");		        	
					if (QPCCNurPlanPermission=="S&L"){
						//勾选 【本人】和【护士长】，创建者和护士长有护理计划的修改创建时间操作权限配置
						if ((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(session['LOGON.USERID']==row[index].nurId)){
							EditDateTime("Intervention");			
						}
					}else if (QPCCNurPlanPermission=="S"){
						//勾选【本人】，只有创建者有护理计划的修改创建时间操作权限配置
						if (session['LOGON.USERID']==row[index].nurId){
							EditDateTime("Intervention");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//勾选【护士长】，只有护士长有护理计划的修改创建时间操作权限配置
						if (session['LOGON.GROUPDESC'].indexOf('护士长')!=-1){
							EditDateTime("Intervention");
						}		
					} else if (QPCCNurPlanPermission==""){
						//如果未勾选“本人”或“护士长”，则表示本病区所有护士均可操作，不设权限
					}		        
		    }	        
	    },
    })
}

function fixWidth(percent) {
    return (document.body.clientWidth - 5) * percent;
}

function SetSelQuestionObj(rowData) {
    var recordId = rowData.recordId;
    var planID = recordId.split("||")[0];
    var questSub = recordId.split("||")[1];
    var isNQNursingAdvice = rowData.isNQNursingAdvice;    
    var statusName = rowData.statusName;
    var queName = rowData.queName;
    PageLogicObj.m_SelQuestionObj = {
        planID: planID,
        questSub: questSub,
        //template: templateArr.join("@"),
        statusName: statusName,
        isNQNursingAdvice: isNQNursingAdvice,
        queName:queName,
    }    
    //2022-11-03 add
    $.extend(PageLogicObj.m_SelQuestionObj,rowData);
    
    var template = rowData.template;
    var templateJson = $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "GetReasonByTemplateId",
        IDs: template
    }, false)
    var templateArr = new Array();
    for (var i = 0; i < templateJson.length; i++) {
        templateArr.push(templateJson[i].ID);
    }
    PageLogicObj.m_SelQuestionObj.template=templateArr.join("@");

}
// 初始化与护理计划通用配置相关的变量集
function InitNurPlanComConfigService(NurPlanComConfigObj) {
    //var NurPlanComConfigObj=eval("("+NurPlanComConfig+")");
    $.extend(ServerObj, NurPlanComConfigObj);
    // 是否启用非评估相关因素
    /*if (ServerObj.IsOpenQLQLRealateFactor !="Y") {
    	$("#QLRealateFactorPanel").parent().hide();
    }
    // 是否启用护理目标
    if (ServerObj.IsOpenQuestionTarget !="Y") {
    	$("#QuestionTargetPanel").parent().hide();
    }*/
}
// 初始化与护理计划通用配置扩展表相关的变量集
function InitNurPlanComConfigExtService(NurPlanComConfigExtJson) {
    var ComConfigExt = [];
    for (var i = 0; i < NurPlanComConfigExtJson.length; i++) {
	    var permission={
		    'QPCCEOpenCopyQuestion':NurPlanComConfigExtJson[i].QPCCEOpenCopyQuestion,
		    'QPCCEOpenFillOutcome':NurPlanComConfigExtJson[i].QPCCEOpenFillOutcome,
		    'QPCCEOpenReasonRequired':NurPlanComConfigExtJson[i].QPCCEOpenReasonRequired
    	}
		//ComConfigExt[NurPlanComConfigExtJson[i].QPCCECode]=permission;
		ComConfigExt[NurPlanComConfigExtJson[i].QPCCEDescription]=permission;	    
    }
    $.extend(ServerObj,{'ComConfigExt': ComConfigExt});
}
// 初始化与选中患者相关的变量集
function InitPatInfoViewService(EpisPatInfo) {
    try {
        var EpisPatInfoObj = eval("(" + EpisPatInfo + ")");
        $.extend(ServerObj, EpisPatInfoObj);
    } catch (e) {
        //此方法局部刷新和页面初始化时会调用,如果报错可能导致错误难排查,需加错误提示性信息
        $.messager.alert("提示", "调用InitPatInfoViewGlobal函数异常,错误信息：" + e.message);
        return false;
    }
}
// 计划制定panel内三个子panel的宽度
function ResetQuestionMakePanelWidth() {
    var MaxWidth = $("#QuestionMakePanel").width(); 
	//var ctcAEPatBarWidth=$("div.ctcAEPatBar").width();  
    var PanelSpaceNum = 4;
    var QLRealateFactorPanelW = $("#QLRealateFactorPanel").parent().width();
    var QuestionTargetPanelW = $("#QuestionTargetPanel").parent().width();
    if (ServerObj.IsOpenQLQLRealateFactor != "Y") {
        QLRealateFactorPanelW = 0;
        PanelSpaceNum--;
        $("#QLRealateFactorPanel").parent().hide();
    } else {
	    if(ServerObj.versionPatientListNew!="1"){
		    QLRealateFactorPanelW = parseInt(MaxWidth * 0.25);
		}
	    else{
        	QLRealateFactorPanelW = parseInt(MaxWidth * 0.335);
	    }
        $("#QLRealateFactorPanel").panel('resize', {
            width: QLRealateFactorPanelW,
        });
        $("#QLRealateFactorPanel").parent().css({display:'inline-block'})
    }
    if (ServerObj.IsOpenQuestionTarget != "Y") {
        QuestionTargetPanelW = 0;
        PanelSpaceNum--;
        $("#QuestionTargetPanel").parent().hide();
    } else {
        QuestionTargetPanelW = parseInt(MaxWidth * 0.335)
        $("#QuestionTargetPanel").panel('resize', {
            width: QuestionTargetPanelW,
        });
        $("#QuestionTargetPanel").parent().css({display:'inline-block'})
    }
    $("#QuestionMeasurePanel").panel('resize', {
        //width: MaxWidth - QLRealateFactorPanelW - QuestionTargetPanelW - (PanelSpaceNum * 4) - 4,   //需求序号:3152987 页码需一行展示，加宽面板宽度,给"计划制定"面板加横向滚动条
        width: MaxWidth - QLRealateFactorPanelW - QuestionTargetPanelW - (PanelSpaceNum * 4) + 60,
    });
    $("#QuestionMeasurePanel").parent().css({display:'inline-block'})

    //$("#NurQuestionTable").datagrid('resize');
    
}

function ShowQueAssessList(that) {
    var recordId = that.id;
    var index = $('#NurQuestionTable').datagrid('getRowIndex', recordId);
    var rows = $('#NurQuestionTable').datagrid('getRows');
    var assessList = rows[index].assessList;
    var assessListJson = eval("(" + assessList + ")");
    var height = 31;
    //assessList: "[{"Id":"","source":"评估带入","status":"提交","trggerTime":"","trigger":"lv-体温单test 腋温（℃）"}]"
    // 来源 触发因素 状态 触发时间 记录ID
    $(that).webuiPopover({
        title: '',
        content: function () {
            var html = [];
            html.push('<ul class="related-factors">');
            html.push('<li class="title"><p class="assess-source">' + $g("来源") + '</p><p class="assess-factors">' + $g("触发因素") + '</p><p class="assess-status">' + $g("状态") + '</p><p class="assess-trggerTime">' + $g("触发时间") + '</p><p class="assess-id">' + $g("记录ID") + '</p></li>');
            for (var i in assessListJson) {
                html.push('<li>');
                html.push('<p class="assess-source">' + assessListJson[i].source + '</p>')
                html.push('<p class="assess-factors">' + assessListJson[i].trigger + '</p>');
                html.push('<p class="assess-status">' + assessListJson[i].status + '</p>');
                html.push('<p class="assess-trggerTime">' + assessListJson[i].trggerTime + '</p>');
                html.push('<p class="assess-id">' + assessListJson[i].Id + '</p>');
                html.push('</li>');
            }
            html.push('</ul>');
            var htmlCode = html.join('');
            delete html;
            return htmlCode;
        },
        trigger: 'hover',
        placement: 'right',
        style: 'inverse',
        height: (height * assessListJson.length) + 32
    });
    $(that).webuiPopover('show');
}

function InitEditWindow() {
    $("#QuestionAddWin").window({
        modal: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closed: true,
        onClose: function () {
            $("#QuestationKeySearch").searchbox('setValue', '');
            $("#QuestionTypeKW").keywords("clearAllSelected");
            $("#QuestionTypeKW").keywords("switchById", "ALL");
        }
    });
    var date = new Date();
	//var NowDateTime = date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
	var NowDateTime   = date.getFullYear()+"-"+('0' + (date.getMonth() + 1)).slice(-2)+"-"+('0' + date.getDate()).slice(-2)+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();

	//在【新增护理问题】弹框中追加日期、时间控件，默认为系统当前时间
	if((ServerObj.QPCCEditDateTime!="")&(ServerObj.QPCCEditDateTime!="Y")){
		//是否允许修改手动新增问题时间 选择“是”，则该日期、时间允许修改，选择“否”，则禁止修改；
		$("#QuestationDataTimeBox").datetimebox({ disabled: true });
	}
	$("#QuestationDataTimeBox").datetimebox('setValue',NowDateTime);
	$.cm({
        ClassName: "Nur.CommonInterface.Patient",
        MethodName: "getInHospDateTime",
        episodeID: ServerObj.EpisodeID,
        dataType: "text"
    },function (rtn) {	    
	    var InHospDateTime=rtn;
	    $('#InHospDataTimeBox').datetimebox('setValue',InHospDateTime);	    
	});
	
	$('#InHospDataTimeBox').next().css({ visibility:'hidden' });
    
}

function InitQuestionTypeKW() {
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionSetting",
        QueryName: "QueryQuestionType",
        name: "",
        hospitalID: session['LOGON.HOSPID']
    }, function (jsonData) {
        var NewRows = [];
        NewRows.push({
	        "id": "ALL",
	        "text": $g("全部"),
	        selected: true
	    });
		for (var i = 0; i < jsonData.total; i++) {
			var obj = jsonData.rows[i];
	        obj.text = obj.desc;
	        NewRows.push(obj);
	        if ((i===PageLogicObj.QuestionTypeShowNum)&&(PageLogicObj.m_QuestionTypeKWLight=="")){
	    		PageLogicObj.m_QuestionTypeKWLight =JSON.parse(JSON.stringify(NewRows));
		    }
	    }
        PageLogicObj.m_QuestionTypeKW = NewRows;
        if (!PageLogicObj.m_QuestionTypeKWLight){
	        $("#moreBtn").hide();
	    }        
        $("#QuestionTypeKW").keywords({
            items: PageLogicObj.m_QuestionTypeKW,
            onSelect: function (v) {
                var QuestionTypeSels = $("#QuestionTypeKW").keywords('getSelected');
                if ((v.id != "ALL") && (QuestionTypeSels[0].id == "ALL")) {
                    $("#QuestionTypeKW").keywords("switchById", "ALL");
                } else if (QuestionTypeSels[0].id == "ALL") {
                    for (var i = 1; i < QuestionTypeSels.length; i++) {
                        $("#QuestionTypeKW").keywords("switchById", QuestionTypeSels[i].id);
                    }
                }
                $("#QuestionTreeGridTab").treegrid('reload');
            },
            onUnselect: function (v) {
                if (v.id != "ALL") {
                    var QuestionTypeSels = $("#QuestionTypeKW").keywords('getSelected');
                    if (QuestionTypeSels.length == 0) {
                        $("#QuestionTypeKW").keywords("switchById", "ALL");
                    } else {
                        $("#QuestionTreeGridTab").treegrid('reload');
                    }
                }
            },
        });
    })
}

function InitQuestionTreeList() {
    var Columns = [
        [{
                field: 'queTypeName',
                title: '问题类别',
                width: 200,
                sortable: true
            },
            {
                field: 'queName',
                title: '问题描述',
                width: 340,
                sortable: true
            }
        ]
    ];
    $HUI.treegrid('#QuestionTreeGridTab', {
        singleSelect: false,
        idField: 'queRowID',
        treeField: 'queTypeName',
        headerCls: 'panel-header-gray',
        fit: true,
        border: false,
        columns: Columns,
        animate: true,
        checkbox: true,
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.QuestionRecord&QueryName=GetQuestionList&rows=99999",
        loadFilter: function (data) {
            var NewRows = new Array();
            for (var i = 0; i < data.total; i++) {
                var obj = data.rows[i];
                delete obj.checked;
                var childs = eval("(" + obj.childs + ")");
                for (var j = 0; j < childs.length; j++) {
                    delete childs[j].checked;
                }
                obj.children = childs;
                NewRows.push(obj);
            }
            return {
                rows: NewRows,
                total: data.total
            };
        },
        onBeforeLoad: function (row, param) {
            $("#QuestionTreeGridTab").treegrid("unselectAll");
            var qustionTypes = [];
            var QuestionTypeSels = $("#QuestionTypeKW").keywords('getSelected');
            for (var i = 0; i < QuestionTypeSels.length; i++) {
                var id = QuestionTypeSels[i].id;
                if ((id) && (id != "ALL")) {
                    qustionTypes.push(QuestionTypeSels[i].id);
                }
            }
            $.extend(param, {
                wardID: session['LOGON.WARDID'],
                qustionName: $("#QuestationKeySearch").searchbox('getValue'),
                qustionTypes: qustionTypes.join("|"),
                episodeID: ServerObj.EpisodeID,
                hospitalDR: session['LOGON.HOSPID']
            });
        },
        onLoadSuccess: function (row, data) {
            $("#QuestionTreeGridTab").treegrid("collapseAll");
            $("#QuestionTreePanel").panel('resize', {
                height: $("#QuestionAddWin").height() - $("#QuestionTreeSearchPanel").height() - 77
            });
        }
        /*,
        		onClickRow:function(nodeId){
        			var Children=$("#QuestionTreeGridTab").treegrid("getChildren",nodeId);
        			if (Children.length>0){
        				$("#QuestionTreeGridTab").treegrid("unselect",nodeId); //.treegrid("toggle",nodeId)
        			}else{
        				var CheckedNodeArr=$("#QuestionTreeGridTab").treegrid("getCheckedNodes");
        				if ((CheckedNodeArr.length ==0)||($.hisui.indexOfArray(CheckedNodeArr,"queRowID",nodeId)) <0){
        					$("#QuestionTreeGridTab").treegrid("checkNode",nodeId);
        				}else{
        					$("#QuestionTreeGridTab").treegrid("uncheckNode",nodeId);
        				}
        				
        			}
        		}*/
    });
}

function QuestationKeySearchChange() {
    $("#QuestionTreeGridTab").treegrid('reload');
}
// 护理问题新增保存
function BQuestionSaveClick() {
	var now = new Date();
	//var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	var nowDateTime=now.getFullYear()+"-"+('0' + (now.getMonth() + 1)).slice(-2)+"-"+('0' + now.getDate()).slice(-2)+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	
    var selRows = $("#QuestionTreeGridTab").treegrid("getCheckedNodes");
    if (selRows.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    }
    var queRowIDArr = new Array();
    for (var i = 0; i < selRows.length; i++) {
        if ((selRows[i].children) && (selRows[i].children.length > 0)) continue;
        queRowIDArr.push(selRows[i].queRowID);
    }
    var InHospDateTime=$('#InHospDataTimeBox').datetimebox('getValue');
    var datetime = $('#QuestationDataTimeBox').datetimebox('getValue');

	//时间调整范围介于系统当前时间与患者入科时间之间，如果修改时间超出，则给予消息反馈
	if(InHospDateTime==""){
		$.messager.popover({
            msg: '未能获取入院时间！',
            type: 'error'
        });
		return false;
	}
	if(!CompareDateFromCreatToNow(datetime,InHospDateTime,nowDateTime)){
		$.messager.popover({
            msg: '修改时间超出患者入院时间或系统当前时间！',
            type: 'error'
        });
        return false;
	}
	indate = datetime.split(" ")[0];
	intime = datetime.split(" ")[1];
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "SaveNewQuestionRecord",
        episodeID: ServerObj.EpisodeID,
        wardID: session['LOGON.WARDID'],
        userID: session['LOGON.USERID'],
        dataArr: queRowIDArr.join("|"),
        ignoreFlag: "",
        assessName: "",
        assessContent: "",
        emrCode: "",
        assessRowId: "",
        emrRecordId: "",
        hospitalID: session['LOGON.HOSPID'],
        date:indate,
        time:intime,
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $("#QuestionAddWin").window("close");
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: "保存失败！" + rtn,
                type: 'error'
            });
        }
    })
}
// 护理问题复制
function NurQuestionCopy(queDR,queName,recordId) {
	var ConfirmMsgHtml = [];
    ConfirmMsgHtml.push("<div class='confirm'><p class='title'>" + $g("确定要复制以下护理问题吗？") + "</p><p class='content'>" + $g("护理问题提交后只允许停止或撤销！") + "</p></div>");
    ConfirmMsgHtml.push("<ul class='question' style='width:194px'>");
    ConfirmMsgHtml.push("<li class='title'>" + $g("护理问题") + "</li>");
    var selRows = $('#NurQuestionTable').datagrid('getSelections');
	if ((queDR!="")&&(queName!="")&&(recordId!="")){
		ConfirmMsgHtml.push("<li>" + queName + "</li>");   

    }else{		
	    if (selRows.length == 0) {
	        $.messager.popover({
	            msg: $g("请选择需要复制的护理问题！"),
	            type: 'error'
	        });
	        return false;
	    }
	    var queRowIDArr = new Array();
	    for (var i = 0; i < selRows.length; i++) {
	        var statusName = selRows[i].statusName;
	        if (statusName == $g("未停止")) {
	            $.messager.popover({
	                msg: '" 未停止 "状态的护理问题不能复制！',
	                type: 'error'
	            });
	            return false;
	        }
	        queRowIDArr.push(selRows[i].queRowId);
	        ConfirmMsgHtml.push("<li>" + selRows[i].queName + "</li>");
	    }
	}    
    ConfirmMsgHtml.push("</ul>");
    var ConfirmMsgHtmlCode = ConfirmMsgHtml.join('');
    delete ConfirmMsgHtml;
    $.messager.confirm('确认对话框', ConfirmMsgHtmlCode, function (r) {
        if (r) {
            $.cm({
                ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
                MethodName: "CopyQuestionRecord",
                episodeID: ServerObj.EpisodeID,
                wardID: session['LOGON.WARDID'],
                userID: session['LOGON.USERID'],
                //dataArr: queRowIDArr.join("|"),
                dataArr: (queDR=="" ? queRowIDArr.join("|"):queDR),
                dataType: "text"
            }, function (rtn) {
                if (rtn == 0) {
                    $("#NurQuestionTable").datagrid('load');

                } else {
                    $.messager.popover({
                        msg: '复制失败！' + rtn,
                        type: 'error'
                    });
                }
	            //转入护理记录
			    if ((queDR!="")&&(queName!="")&&(recordId!="")&&(ServerObj.QPCCOpenNurEvaluateTrans=="Y")){				    
				    var Type="NURQE";
				    var TransferDesc=ServerObj.QPCCNurEvaluateTransFormat;
			    	showTransferRecordWin(Type,TransferDesc,recordId);
			    }
            })
        }else{
			//转入护理记录
		    if ((queDR!="")&&(queName!="")&&(recordId!="")&&(ServerObj.QPCCOpenNurEvaluateTrans=="Y")){			    
			    var Type="NURQE";
			    var TransferDesc=ServerObj.QPCCNurEvaluateTransFormat;
		    	showTransferRecordWin(Type,TransferDesc,recordId);
		    }
        }
    });
}
// 护理问题评价弹框
function ShowQuestionEvaluateWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '请选择一条护理问题进行评价！',
            type: 'error'
        });
        return false;
    } else if (sels[0].result == $g("已解决")) {
        $.messager.popover({
            msg: '该护理问题已解决！',
            type: 'error'
        });
        return false;
    } else if (sels[0].statusName == $g("撤销")) {
        $.messager.popover({
            msg: '该护理问题已撤销！',
            type: 'error'
        });
        return false;
    } else if (sels[0].statusName == $g("作废")) {
        $.messager.popover({
            msg: '该护理问题已作废！',
            type: 'error'
        });
        return false;
    //}else if ((sels[0].cstatus == $g("已评价"))&&(sels[0].result == $g("完全解决"))) {
	  }else if (sels[0].cstatus == $g("已评价")) {
        $.messager.popover({
            msg: '该护理问题已评价！不能修改评价结果！',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("QuestionEvaluate");
    var iconCls = "";
    var date = new Date();
	//var NowDateTime = date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes();
	var NowDateTime=date.getFullYear()+"-"+('0' + (date.getMonth() + 1)).slice(-2)+"-"+('0' + date.getDate()).slice(-2)+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
    
    if ((ServerObj.QPCCOpenNurSelfDefEvaluate!="")&(ServerObj.QPCCOpenNurSelfDefEvaluate=="Y")){
    	createModalDialog("QuestionDiag", $g("护理问题评价"), 350, 217, iconCls, $g("确定"), Content, 'SaveQuestionComments("'+NowDateTime+'")');
    }else{
	    createModalDialog("QuestionDiag", $g("护理问题评价"), 350, 180, iconCls, $g("确定"), Content, 'SaveQuestionComments("'+NowDateTime+'")');
	}
	//在【护理问题评价】弹框中，追加日期、时间控件，默认为系统当前时间
	if((ServerObj.QPCCEvaluationEditDateTime!="")&(ServerObj.QPCCEvaluationEditDateTime!="Y")){
		//是否允许修改评价时间选择“是”，则该日期、时间允许修改，选择“否”，则禁止修改；
		$('#QEEditDataTimeBox').datetimebox({ disabled: true });
	}
	$('#QEEditDataTimeBox').datetimebox('setValue',NowDateTime);
    $("#QuestionEvaluateResult").combobox({
        editable: false,
        mode: 'local',
        multiple: false,
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'text',
        data: eval("(" + ServerObj.QuestionEvaluateResultJson + ")"),
        onSelect: function (rec) {
            if ((rec) && (rec.code == "03")) { //代码03代表问题已解决

                $.messager.alert("提示", "评价结果 <font color=red>" + rec.text + "</font> 提交后，该护理问题评价结果不可修改！");
            }
        }
    });
    $('#QuestionEvaluateResult').next('span').find('input').focus();
}
// 保存护理问题评价结果
function SaveQuestionComments(nowDateTime) {
	var inDate="",inTime="",Remark="";
	if (nowDateTime==""){
		var date = new Date();
		//var nowDateTime=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes();
		var nowDateTime=date.getFullYear()+"-"+('0' + (date.getMonth() + 1)).slice(-2)+"-"+('0' + date.getDate()).slice(-2)+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
	}
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    var recordId = sels[0].recordId;
    var queDR= sels[0].queRowId;
    var queName=sels[0].queName;
    var createDateTime=sels[0].createDateTime
    var questionSub = recordId.split("||")[1];
    var QuestionEvaluateResult = $("#QuestionEvaluateResult").combobox("getText");
    if (!QuestionEvaluateResult) {
        $.messager.popover({
            msg: '请选择评价结果！',
            type: 'error'
        });
        $('#QuestionEvaluateResult').next('span').find('input').focus();
        return false;
    }
    //需求序号2848261护理问题评价时不能选择时间
    var datetime = $('#QEEditDataTimeBox').datetimebox('getValue');
	inDate = datetime.split(" ")[0];
	inTime = datetime.split(" ")[1];
	//时间调整范围介于系统当前时间与护理问题创建时间之间，如果修改时间超出，则给予消息反馈
	if(!CompareDateFromCreatToNow(datetime,createDateTime,nowDateTime)){
		$.messager.popover({
            msg: '修改时间超出护理问题创建时间或系统当前时间！',
            type: 'error'
        });
        return false;
	}
	// 添加自定评价备注
	if ((ServerObj.QPCCOpenNurSelfDefEvaluate!="")&(ServerObj.QPCCOpenNurSelfDefEvaluate=="Y")){
		Remark=$('#QuestionEvaluateRemark').val();
	}
 	
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "SaveQuestionComments",
        admDR: ServerObj.EpisodeID,
        questionSub: questionSub,
        status: QuestionEvaluateResult,
        optID: session['LOGON.USERID'],
        date:inDate,
        time:inTime, 
        remark:Remark,   
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            destroyDialog("QuestionDiag"); 
            if (ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenCopyQuestion=="Y"){
	            //是否复制问题如果勾选，则表示当评价或停止原因选择该描述时，提醒用户是否复制该护理问题          
	        	$.messager.confirm("提示", queName+'护理问题评价/停止结果为'+QuestionEvaluateResult+',是否复制该护理问题？', function (res) {
					if (res){						
						//确定,复制该护理问题
						NurQuestionCopy(queDR,queName,recordId);
					}
					else{
						//取消，如果“未复制问题是否填写转归”勾选，填写转归原因
						if (ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenFillOutcome=="Y"){
							//填写转归原因
							ShowQPCCTransReasonWin(questionSub,QuestionEvaluateResult,recordId);
						}
						return;
					}									
				});
            }
			$("#NurQuestionTable").datagrid('load'); 			
        } else {
            $.messager.popover({
                msg: '护理问题评价失败！',
                type: 'error'
            });
        }
       
    });    
}
// 转归原因弹框
function ShowQPCCTransReasonWin(questionSub,QuestionEvaluateResult,recordId) {
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("QPCCTransReason");
    var iconCls = "";
    if (ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenReasonRequired=="Y"){
	    // 转归原因必填 弹出提示框
		createModalDialog("QuestionDiag", $g("转归原因"), 350, 150, iconCls, $g("确定"), Content, 'SaveQPCCTransReason('+(questionSub)+',\"'+QuestionEvaluateResult+'\",\"'+recordId+'\")',$g('取消'),'CXQPCCEOpenReasonRequired()');
    }else{
		createModalDialog("QuestionDiag", $g("转归原因"), 350, 150, iconCls, $g("确定"), Content, 'SaveQPCCTransReason('+(questionSub)+',\"'+QuestionEvaluateResult+'\",\"'+recordId+'\")');
	}
    $("#QuestionTransReason").combobox({
        editable: false,
        mode: 'local',
        multiple: false,
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'text',
        data: eval("(" + ServerObj.QPCCTransReasonJson + ")"),
        onSelect: function (rec) {
        }
    });
    /*
    if (ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenReasonRequired=="Y"){
	    // 转归原因必填，禁用取消按钮
	    //$("#DialogCancelBtn").css({"pointer-events":" none"});
    }
    */
}
function CXQPCCEOpenReasonRequired(){
	$.messager.popover({
		msg: '转归原因必填！',
	    type: 'error'
	});
	return;
}
// 保存护理问题转归原因
function SaveQPCCTransReason(questionSub,QuestionEvaluateResult,recordId) {
	var TransReason='';
	TransReason=$("#QuestionTransReason").combobox("getText");
	if ((QuestionEvaluateResult!="")&&((ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenReasonRequired=="Y"))&&(TransReason.length == 0)) {
        $.messager.popover({
            msg: '转归原因必填！',
            type: 'error'
        });
        return false;
    }
    if ((questionSub!="")||(typeof(questionSub) != "undefined")) {
		$.cm({
	        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
	        MethodName: "SaveQuestionTransReason",
	        admDR: ServerObj.EpisodeID,
	        questionSub: questionSub,
	        transreason:TransReason,   
	        dataType: "text"
	    }, function (rtn) {
		    if (rtn == 0) {			    
			    destroyDialog("QuestionDiag");
			}else {
	            $.messager.popover({
	                msg: '保存转归原因失败！',
	                type: 'error'
	            });          
        	}
        	//转入护理记录
		    if (ServerObj.QPCCOpenNurEvaluateTrans=="Y"){
			    var Type="NURQE";
			    var TransferDesc=ServerObj.QPCCNurEvaluateTransFormat;
		    	showTransferRecordWin(Type,TransferDesc,recordId);
		    } 
		});
    }
}
// 护理问题撤销评价
function RevokeQuestionComments() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要撤销评价的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var cstatus = sels[i].cstatus;
        if (cstatus != $g("已评价")) {
            $.messager.popover({
                msg: '只能撤销状态为" 已评价 "的护理问题！',
                type: 'error'
            });
            return false;
        }
        selRecordArr.push(sels[i].recordId);
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "RevokeQuestionComments",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '护理问题撤销评价失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理计划评价审核
function NurPlanEvaluateAudit() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要审核的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var cstatus = sels[i].cstatus;
        if (cstatus == $g("未评价")) {
            $.messager.popover({
                msg: '不能审核状态为" 未评价 "的护理问题！',
                type: 'error'
            });
            return false;
        }
        selRecordArr.push(sels[i].recordId);
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "NurEvaluateAudit",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '护理问题审核失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理问题审核
function NurPlanReview() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要审核的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var cstatus = sels[i].cstatus;
        var statuesName = sels[i].statuesName;
        if ((cstatus == $g("未评价"))||(statuesName == $g("未停止"))) {
            $.messager.popover({
                msg: '不能审核状态为" 未评价 "或" 未停止 "的护理问题！',
                type: 'error'
            });
            return false;
        }else if(sels[i].planReviewUser!=""){
	        $.messager.popover({
                msg: '已审核无需再次审核！',
                type: 'error'
            });
            return false;
	    }
        selRecordArr.push(sels[i].recordId);
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "NurPlanReview",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '护理问题审核失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理问题撤销审核
function RevokeNurPlanReview() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要审核的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var planReviewUser = sels[i].planReviewUser;
        if (planReviewUser == "") {
            $.messager.popover({
                msg: '只能撤销已审核的护理问题！',
                type: 'error'
            });
            return false;
        }
        selRecordArr.push(sels[i].recordId);
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "RevokeNurPlanReview",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '撤销护理问题审核失败！' + rtn,
                type: 'error'
            });
        }
    })
}
function CompareDate(date1, date2) {
    var date1 = myparser(date1);
    var date2 = myparser(date2);
    if (date2 < date1) {
        return true;
    }
    return false;
}
/*
function CompareDateFromCreatToNow(time,beginTime ,endTime) {
	var times=time.replace(/-/g,"/");
	var beginTimes =beginTime.replace(/-/g,"/");
    var endTimes =endTime.replace(/-/g,"/");
    var a =(Date.parse(times)-Date.parse(beginTimes))/3600/1000;
    var b =(Date.parse(times)-Date.parse(endTimes))/3600/1000;    
    if ((a>=0)&(b<=0)) return true;
    return false;
}
*/
function parseDate(dateStr) {
	var formats = [
		/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/,    //"dd/MM/yyyy"
		/^(\d{1,2})-(\d{1,2})-(\d{4})$/,	  //"dd-MM-yyyy"
		/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/,    //"MM/dd/yyyy"
		/^(\d{1,2})-(\d{1,2})-(\d{4})$/,      //"MM-dd-yyyy"
		/(\d{4})\/(\d{2})\/(\d{2})/,          //"yyyy/MM/dd"
		/(\d{4})-(\d{2})-(\d{2})/,            //"yyyy-MM-dd"
	];
	var data = dateStr.split(' ')[0];
	var time = dateStr.split(' ')[1];
	var a,b,c
	if (data!=""){
		for (var i = 0; i < formats.length; i++) {
	  		var format = formats[i];
			var match = data.match(format);
			if (match&&((time=="")||(typeof(time)=="undefined"))) {
				//[,a,b,c] = match;
				//兼容IE
				a=match[1];
				b=match[2];
				c=match[3];
				if (format === formats[0] || format === formats[1]) {
					return new Date(c, b-1, a);
				}
				else if (format === formats[2] || format === formats[3]) {
					return new Date(c, a - 1, b);					
				} else {
					return new Date(a, b - 1, c);
				}
			}else if (match&&((time!="")||(typeof(time)!="undefined"))) {
				//[,a,b,c] = match;
				a=match[1];
				b=match[2];
				c=match[3];
				if (format === formats[0] || format === formats[1]) {
					var NewDateTime=c + "-"+('0' + b).slice(-2)+"-"+('0' + a).slice(-2)+" "+time;
					return new Date(NewDateTime.replace(/-/g, "/"));
				}
				else if (format === formats[2] || format === formats[3]) {
					var NewDateTime=c + "-"+('0' + a).slice(-2)+"-"+('0' + b).slice(-2)+" "+time;
					return new Date(NewDateTime.replace(/-/g, "/"));
				} else {
					var NewDateTime=a + "-"+('0' + b).slice(-2)+"-"+('0' + c).slice(-2)+" "+time;
					return new Date(NewDateTime.replace(/-/g, "/"));
				}				
			}
		}
	}

}
function CompareDateFromCreatToNow(time, beginTime, endTime) {
	try {
		var parsedTime = parseDate(time.split(' ')[0]);
		var parsedBeginTime = parseDate(beginTime.split(' ')[0]);
		var parsedEndTime = parseDate(endTime.split(' ')[0]);
		var timeDiffBegin = (parsedTime - parsedBeginTime) / 3600 / 1000;
		var timeDiffEnd = (parsedTime - parsedEndTime) / 3600 / 1000;
		return timeDiffBegin >= 0 && timeDiffEnd <= 0;
	} catch (error) {
		console.error('Error:', error.message);
		return false;
	}
}
function myformatter(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    if (dtseparator == "-") return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
    else if (dtseparator == "/") return (d < 10 ? ('0' + d) : d) + "/" + (m < 10 ? ('0' + m) : m) + "/" + y
    else return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
}

function myparser(s) {
    if (!s) return new Date();
    if (dtseparator == "/") {
        var ss = s.split('/');
        var y = parseInt(ss[2], 10);
        var m = parseInt(ss[1], 10);
        var d = parseInt(ss[0], 10);
    } else {
        var ss = s.split('-');
        var y = parseInt(ss[0], 10);
        var m = parseInt(ss[1], 10);
        var d = parseInt(ss[2], 10);
    }
    if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
        return new Date(y, m - 1, d);
    } else {
        return new Date();
    }
}

function destroyDialog(id) {
    $("body").remove("#" + id); //移除存在的Dialog
    $("#" + id).dialog('destroy');
}

function QuestionKeyWordOnKeyDown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        $('#NurQuestionTable').datagrid('reload');
    }
}
// 停止护理问题弹框
function ShowNurQuestionStopWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要停止的护理问题！',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("未停止")) {
            $.messager.popover({
                msg: '只能停止状态为" 未停止 "的护理问题！',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("Stop");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("停止护理问题"), 350, 200, iconCls, $g("确定"), Content, "NurQuestionStop()");
    InitStopReason();
}
// 撤销护理问题弹框
function ShowNurQuestionCancelWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要撤销的护理问题！',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("未停止")) {
            $.messager.popover({
                msg: '只能撤销状态为" 未停止 "的护理问题！',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("Cancel");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("撤销护理问题"), 350, 200, iconCls, $g("确定"), Content, "NurQuestionCancel()");
    InitCancelReason();
}
// 作废护理问题弹框
function ShowNurQuestionUnUserWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: $g('请选择需要作废的护理问题！'),
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        /*
        if (statusName != $g("未停止")) {
            $.messager.popover({
                msg: $g("只能作废状态为未停止的护理问题！"),
                type: 'error'
            });
            return false;
        }
        */
        //需求序号	3226650 【标化需求】护士误操作，需作废已停止的护理问题，目前无法作废，需更新修改。
        if ((statusName == $g("已撤销"))||(statusName == $g("已作废"))) {
            $.messager.popover({
                msg: $g("只能作废状态为未停止或已停止的护理问题！"),
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("UnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("作废护理问题"), 350, 156, iconCls, $g("确定"), Content, "NurQuestionUnUse()");
    InitUnUseReason();
}
// 护理问题撤销
function NurQuestionCancel() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要撤销的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("未停止")) {
            $.messager.popover({
                msg: '只能撤销状态为" 未停止 "的护理问题！',
                type: 'error'
            });
            return false;
        }
        selRecordArr.push(sels[i].recordId);
    }
    var CancelReasonObj = GetCancelReasonObj();
    if (CancelReasonObj.successFlag == false) {
        return false;
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "CancelQuestion",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        reason: CancelReasonObj.CancelReason,
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '撤销护理问题成功！',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '撤销护理问题失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理问题停止
function NurQuestionStop() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要停止的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("未停止")) {
            $.messager.popover({
                msg: '只能停止状态为" 未停止 "的护理问题！',
                type: 'error'
            });
            return false;
        }
        selRecordArr.push(sels[i].recordId);
    }
    var StopReasonObj = GetStopReasonObj();
    if (StopReasonObj.successFlag == false) {
        return false;
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "StopQuestion",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        reason: StopReasonObj.StopReason,
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '停止护理问题成功！',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#NurQuestionTable").datagrid('load');
            //转入护理记录
		   if (ServerObj.QPCCOpenNurQuestionStopTrans=="Y"){
			    var Type="NURQS";
			    var TransferDesc=ServerObj.QPCCNurQuestionStopTransFormat;
		    	showTransferRecordWin(Type,TransferDesc,'');
		    }          
        } else {
            $.messager.popover({
                msg: '停止护理失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理问题作废
function NurQuestionUnUse() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        selRecordArr.push(sels[i].recordId);
    }
    var UnUseReasonObj = GetUnUseReasonObj();
    if (UnUseReasonObj.successFlag == false) {
        return false;
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "AbolishQuestion",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        recordID: selRecordArr.join("^"),
        reason: UnUseReasonObj.UnUseReason,
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            destroyDialog("QuestionDiag");
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '作废护理问题失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理问题撤销作废(作废逆流程)
function NurQuestionRevokeUnUse() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要撤销作废的护理问题！',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("已作废")) {
            $.messager.popover({
                msg: '只能撤销状态为" 已作废 "的护理问题！',
                type: 'error'
            });
            return false;
        }
        selRecordArr.push(sels[i].recordId);
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "RevokeAbolishQuestion",
        episodeID: ServerObj.EpisodeID,
        userID: session['LOGON.USERID'],
        recordID: selRecordArr.join("^"),
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '撤销作废护理问题失败！' + rtn,
                type: 'error'
            });
        }
    })
}

function initDiagDivHtml(type) {
    if (type == "UnUse") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html += '<div class="messager-icon messager-question"></div>'
        html += '<div style="margin-left:42px;">'
        html += '<div class="confirm"><p class="title">' + $g("确定要作废选择的记录吗？") + '</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="UnUseReason" style="margin-right:10px;">' + $g("作废原因") + '</label>'
        html += '<input id="UnUseReason" class="textbox" style="width:180px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    } else if (type == "Stop") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html += '<div class="messager-icon messager-question"></div>'
        html += '<div style="margin-left:42px;">'
        html += '<div class="confirm"><p class="title">' + $g("确定要停止选择的记录吗？") + '</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="StopReason" style="margin-right:10px;">' + $g("停止原因") + '</label>'
        html += '<input id="StopReason" class="textbox" style="width:180px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    } else if (type == "AddQuestionTarget") {
        var html = "<div id='QuestionWin' class='messager-body' style='padding-bottom:0;'>"
        html += '<div>'
        //html +='<label class="clsRequired r-label">护理目标</label>'
        html += '<textarea id="QuestionTarget" style="width:325px;height:97px;"></textarea>'
        html += '</div>'
        html += "</div>"
    } else if (type == "AddQuestionMeasure") {
        var html = "<div id='QuestionWin' style='overflow:hidden;'>"
        html += "	<table class='search-table' style='border:none;'>"
        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("措施类别") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='InterventionType' class='textbox' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label' style='vertical-align:top;'>"
        html += '<label class="clsRequired">' + $g("措施短描述") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <textarea class='hisui-validatebox' id='TextareaElement_measure' name='TextareaElement_measure' style='height:80px;width:300px;box-sizing:border-box;border-radius:2px;'></textarea>"
        html += "	 </td>"
        html += "	 </tr>"

        /* 手动新增措施 取消相关因素选择
        html +="	 <tr>"
        	html +="	 <td class='r-label'>"
        		html += '<label for="InterventionRecord">'+$g("相关因素")+'</label>'
        	html +="	 </td>"
        	html +="	 <td>"
        		html +="	 <input id='InterventionRecord' class='textbox' style='width:300px;'></input>"
        	html +="	 </td>"
        html +="	 </tr>"
        */

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label for ="InterventionFreq" class="clsRequired">' + $g("执行频率") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='InterventionFreq' class='textbox' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("启用日期") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='startdate' class='hisui-datebox textbox' required='required' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label>' + $g("停用日期") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='enddate' class='hisui-datebox textbox' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	</table>"
        html += "</div>"
    } else if (type == "NurQuestionnMeasureStop") {
        var html = "<div id='QuestionWin' style=''>"
        html += "	<table class='search-table' style='border:none;'>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("停止日期") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='MeasureStopDate' class='hisui-datebox textbox' required='required' style='width:156px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("停止时间") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='MeasureStopTime' class='hisui-timespinner textbox' data-options='showSeconds:false' required='required'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label for ="StopReason">' + $g("停止原因") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='StopReason' class='hisui-combobox textbox' style='width:156px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"
        html += "	</table>"
        html += "</div>"
    } else if (type == "NurQuestionnMeasureUnUse") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html += '<div class="messager-icon messager-question"></div>'
        html += '<div style="margin-left:42px;">'
        html += '<div class="confirm"><p class="title">' + $g("确定要作废选择的护理措施吗？") + '</p><p style="color:red;margin-top:10px;">' + $g("护理措施作废后,关联的护理任务将自动作废,是否继续？") + '</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="UnUseReason" style="margin-right:10px;">' + $g("作废原因") + '</label>'
        html += '<input id="UnUseReason" class="hisui-combobox textbox" style="width:176px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    } else if (type == "QuestionEvaluate") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        
        // 需求序号2848261护理问题评价时不能选择时间
        html += '<div>'
        html += '<label class="clsRequired r-label">' + $g("评价时间") + '</label>'
        html +='<input class="hisui-datetimebox" id="QEEditDataTimeBox" data-options="required:true,showSeconds:false" style="width:255px">'
        html += '</div>'
        
        html += '<div style="margin-top:10px;">'
        html += '<label class="clsRequired r-label">' + $g("评价结果") + '</label>'
        html += '<input id="QuestionEvaluateResult" class="textbox" style="width:255px;"></input>'
        html += '</div>'
        if ((ServerObj.QPCCOpenNurSelfDefEvaluate!="")&(ServerObj.QPCCOpenNurSelfDefEvaluate=="Y")){
			//2758853【护理计划配置】业务界面整合 add 评价备注
	        html += '<div id="Div-EvaluateRemark" style="margin-top:10px;display: table">'
	        html += '<label class="r-label" for="QuestionEvaluateRemark" style="display: table-cell; vertical-align: middle;">' + $g("评价备注") + '</label>'
	        html += '<textarea id="QuestionEvaluateRemark" class="textbox" style="width:246px;"></textarea>'
	        html += '</div>'
        }
        html += "</div>"
    } else if (type == "EditQuestionMeasure") {
        var html = "<div id='QuestionWin' class='messager-body' style='padding-bottom:0;'>"
        html += '<div>'
        html += '<textarea id="QuestionMeasure" style="width:325px;height:97px;"></textarea>'
        html += '</div>'
        html += "</div>"
    } else if (type == "EditQuestionTarget") {
        var html = "<div id='QuestionWin' class='messager-body' style='padding-bottom:0;'>"
        html += '<div>'
        html += '<textarea id="QuestionTarget" style="width:325px;height:97px;"></textarea>'
        html += '</div>'
        html += "</div>"
    } else if (type == "AddQLRealateFactor") {
        var html = "<div id='QuestionWin' class='messager-body' style='padding-bottom:0;'>"
        html += '<div>'
        html += '<textarea id="QLRealateFactor" style="width:325px;height:97px;border-radius:2px;"></textarea>'
        html += '</div>'
        html += "</div>"
    } else if (type == "Cancel") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html += '<div class="messager-icon messager-question"></div>'
        html += '<div style="margin-left:42px;">'
        html += '<div class="confirm"><p class="title">确定要撤销选择的记录吗？</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="CancelReason" class="r-label">' + $g("撤销原因") + '</label>'
        html += '<input id="CancelReason" class="textbox" style="width:210px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    }else if (type == "EditDataTime") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html +='<table>'
		html +='<tr>'
		html +='<td class="r-label">修改日期时间为 ：</td>'
		html +='<td>'
		html +='<input class="hisui-datetimebox" id="EditDataTimeBox" value="${notices.release_time}" data-options="required:true,showSeconds:false" style="width:180px">'
		html +='</td>'
		html +='</tr>'
		html +='<tr id="tr-LimitEditDataTime">'
		html +='<td class="r-label">限制时间为 ：</td>'
		html +='<td>'
		html +='<input class="hisui-datetimebox" id="LimitEditDataTimeBox" data-options="required:true,showSeconds:true" style="width:180px">'
		html +='</td>'
		html +='</tr>'
		html +='</table>'
		html += "</div>"
    }else if(type=="QPCCTransReason"){
	    var html = "<div id='QuestionWin' class='messager-body'>"
        html +='<table>'
		html +='<tr>'
		html +='<td><label>转归原因:</label></td>'
		html +='<td>'
		html += '<input id="QuestionTransReason" class="textbox" style="width:245px;"></input>'
		html +='</td>'
		html +='</tr>'
	}else if(type =="transferRecord"){
		var html="<div id='transferRecord'>"
				html +='<div id="patinfobanner" style="padding:10px;display: flex;">'
				if((ServerObj.IsShowPatInfoBannner=="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
					//2023.02.28 医生站关于病人信息栏的调用修改	
					html +='<div class="pat-info-container"></div>'		
					//html +='<div class="pat-info-over">...</div>'					
				}else if((ServerObj.IsShowPatInfoBannner!="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
					//床位图跳转
				}else{
					//HIS 版本8.2以上至8.5
					html +='<div class="patInfoBanner_patInfoText"></div>'					
				}					
				html +='</div>'
				html +='<table>'					
					/*
					html +='<p class="remind">'+$g("转入护理记录")+'</p>' //'<a class="hisui-linkbutton" id="BDataRefer" style="margin-left:10px;">'+$g("数据引用")+'</a>'
					html +='<div>'
						html +=" <textarea id='TransferDesc' style='margin:0 10px;height:140px;width:720px;border-radius:2px;'></textarea>"
					html +='</div>'
					html +='<div style="margin:10px 0 0 4px;">'
						html +='<input id="SureTrans" class="hisui-checkbox" type="checkbox" data-options="checked:true" label="'+$g("确认要将以上结果<span>转入护理记录</span>吗？")+'"'
					html +='</div>'
					html +='<div style="margin:10px 0 10px 7px;">'
						html +='<label style="margin-right:10px;">'+$g("转入时间")+'</label>'
						html +="<input id='TransferDate' class='hisui-datebox textbox r-label' style='width:120px;'></input>"
						html +="<span style='margin:0 5px;'></span>"
						html +="<input id='TransferTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:80px;'></input>"
					html += "</div>"
					html +='<div style="margin:10px 0 0 7px;">'
						html +='<label style="margin-right:10px;">'+$g("转入护士")+'</label>'
						html +="<input id='TransferUser' class='textbox' disabled style='width:203px;'></input>"
					html += "</div>"					
					*/
					html +='<tr ><td  style="padding: 0px 0 10px 10px; width: 115px;text-align:right">'+$g("执行结果描述")+'</td></tr>'
					html +='<tr>'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +=" <td><textarea id='TransferDesc' style='margin:0 10px;height:120px;width:590px;border-radius:2px;'></textarea></td>"
					html +='</tr>'
					html +='<tr style="margin:10px 0 0 0px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +='<td style="padding:10px 0 0 10px;"><input id="SureTrans" class="hisui-checkbox" type="checkbox" data-options="checked:true" label="'+$g("确认要将以上执行结果<span>转入护理记录</span>吗？")+'">'
					html +='</tr>'
					html +='<tr style="margin:10px 0 0 0px;">'
						html +='<td style="padding:10px 0px 0 10px;text-align:right""><label for="NursingRecordTemplate">'+$g("护理记录单")+'</label></td>'
						html +='<td style="padding:10px 10px 0 10px"><input class="hisui-combogrid" style=" width:360px; "id="NursingRecordTemplate"/></td>'
					html +='</tr>'
					html +='<tr style="margin:10px 0 10px 0px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("转入时间")+'</label></td>'
						html +="<td style='padding:10px'><input id='TransferDate' class='hisui-datebox textbox r-label' style='width:120px;'></input>"
						html +="<span style='margin:0 5px;'></span>"
						html +="<input id='TransferTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:80px;'></input></td>"
					html += "</tr>"
					html +='<tr style="margin:10px 0 0 0px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("转入护士")+'</label></td>'
						html +="<td style='padding:0px 10px 0px 10px'><input id='TransferUser' class='textbox' disabled style='width:203px;'></input></td>"
					html += "</tr>"					
				html +='</table>'
			html += "</div>"
	}
    return html;
}
/**
 * Dialog 动态的绑定Click事件
 */
 function extendDialog(){
	$.extend($.fn.dialog.methods, {
	    bindButtonEvents: function (jq, param) {
	        return jq.each(function () {
	            var dialog = $(this);
	            dialog.parent().on('click', '.dialog-button a', function (e) {
	                var text = $(this).linkbutton('options').text;
	                var method = param[text];
	                if (method) { method(); }
	            });
	        });
	    }
	});
}
 
function bakPatInfoBanner(){
	if((ServerObj.IsShowPatInfoBannner!="Y")&&(ServerObj.versionIsInfoBarNew=="1")){			        
		var _PatInfoBannner=$("#PatInfoBannner");	
		var banner_bak=$("#patinfobanner").contents();
		//$('#patinfobanner').html('');
		if (_PatInfoBannner.length>0){	
			$("#PatInfoBannner").append(banner_bak);
		}
	}	 
 }
/**
 * 创建一个模态 Dialog
 * @param id divId
 * @param _url Div链接
 * @param _title 标题
 * @param _width 宽度
 * @param _height 高度
 * @param _icon ICON图标
 * @param _btntext 确定按钮text
 */
function createModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event,_btncxtext,_cxevent) {
    if (_btntext == "") {
        var buttons = [];
    } else {
        var buttons = [{
            text: _btntext,
            //iconCls:_icon,
            handler: function () {
                if (_event != "") eval(_event);
            }
        }]
    }
    //如果去掉关闭按钮，当用户点击窗体右上角X关闭时，窗体无法回调界面销毁事件，需要基础平台协助处理
    if ((_btncxtext=="")||(typeof(_btncxtext)=="undefined")){
	    buttons.push({
		    id:'DialogCancelBtn',
	        text: $g('取消'),
	        handler: function () {
		        bakPatInfoBanner();
	            destroyDialog(id);
	        }
	    });
    }else{
	   	buttons.push({
		    id:'DialogCancelBtn',
	        text: _btncxtext,
	        handler: function () {
	            if ((_cxevent != "")||(typeof(_cxevent)!="undefined")) eval(_cxevent);
	        }
	    });
	}
    $("body").append("<div id='" + id + "' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#" + id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: false,
        content: _content,
        buttons: buttons
    });
}

// 打印护理计划单
function NurQuestionPlanPrint(selFlag) {	
	var QPCCNursePlanPrintStatus=ServerObj.QPCCNursePlanPrintStatus
	var arrLimitStr=getPrintStatusLimitStr();
	
    // 外部数据源打印bug fix
    var locationURL = window.location.href.split("/csp/")[0]; // + "/"
    var rows = "",cstatus="",statusName="",queName=""
    /*
    if (selFlag) {
        var dataSourceRow = $('#NurQuestionTable').datagrid('getChecked');
        if (dataSourceRow.length == 0) {
            $.messager.popover({
                msg: '请选择一条数据源!',
                type: 'info'
            });
            return;
        }
        rows = "*"
        $.each(dataSourceRow, function (index, item) {
            rows = rows + item.recordId + "*"
        });
    }
    */    
    var dataSourceRow = $('#NurQuestionTable').datagrid('getChecked');    
    if ((dataSourceRow.length>0)||(selFlag)) {
	    // 按勾选打印护理计划单
	    //需求2987696
	    rows = "@"+session['LOGON.CTLOCID']+"@*"
        $.each(dataSourceRow, function (index, item) {
            //rows = rows==""?item.recordId: (rows + "@"+ item.recordId )
			rows = rows + item.recordId + "*";
			if ((item.statusName=="未停止")||(item.cstatus=="未评价")){
				cstatus=cstatus+"@"+item.cstatus;
				statusName=statusName+"@"+item.statusName;
				queName=queName+"【"+item.queName+"】";
			}						
        });        
        if(ServerObj.QPCCNursePlanPrintStatusLimit.indexOf("Limit")!=-1) {
			// 勾选 【流程控制】
			if(((arrLimitStr.indexOf("未评价")!=-1)&&(cstatus.indexOf("未评价")!=-1))||((arrLimitStr.indexOf("未停止")!=-1)&&(statusName.indexOf("未停止")!=-1))){
				// 护理计划单打印限制控制 勾选【未停止】 或 【未评价】
				$.messager.alert("提示", queName+"护理问题未评价或未停止，请评价或停止后，再打印护理计划单",'error')
				return;
			}else{
				//护理计划打印模板
				if(ServerObj.QPCCNurPlanPrintTemplate!=""){
					AINursePrintAll(locationURL, ServerObj.QPCCNurPlanPrintTemplate, ServerObj.EpisodeID, rows);	
				}else{
					AINursePrintAll(locationURL, "DHCNURMoudPrnHLJHD", ServerObj.EpisodeID, rows);	
	
				}
			}	
		}else{
			// 未勾选 【流程控制】
			if(((arrLimitStr.indexOf("未评价")!=-1)&&(cstatus.indexOf("未评价")!=-1))||((arrLimitStr.indexOf("未停止")!=-1)&&(statusName.indexOf("未停止")!=-1))){
				$.messager.confirm("提示", queName+"护理问题未停止或未评价，是否继续打印护理计划单？", function (res) {
					if (res){
						//护理计划打印模板
						if(ServerObj.QPCCNurPlanPrintTemplate!=""){
							AINursePrintAll(locationURL, ServerObj.QPCCNurPlanPrintTemplate, ServerObj.EpisodeID, rows);	
						}else{
							AINursePrintAll(locationURL, "DHCNURMoudPrnHLJHD", ServerObj.EpisodeID, rows);			
						}
					}
					else{
						return;
					}									
				});
			}else{
				//护理计划打印模板
				if(ServerObj.QPCCNurPlanPrintTemplate!=""){
					AINursePrintAll(locationURL, ServerObj.QPCCNurPlanPrintTemplate, ServerObj.EpisodeID, rows);	
				}else{
					AINursePrintAll(locationURL, "DHCNURMoudPrnHLJHD", ServerObj.EpisodeID, rows);			
				}			
			}		
		}
	}
	else{
	//  打印全部护理计划单
		if(ServerObj.QPCCNurPlanPrintTemplate!=""){
			AINursePrintAll(locationURL, ServerObj.QPCCNurPlanPrintTemplate, ServerObj.EpisodeID, rows);	
		}else{
			AINursePrintAll(locationURL, "DHCNURMoudPrnHLJHD", ServerObj.EpisodeID, rows);			
		}	
	}
    //AINursePrintAll(locationURL,"DHCNURMoudPrnHLJHD",ServerObj.EpisodeID,"");
}
function getPrintStatusLimitStr(){
	var QPCCNursePlanPrintStatusLimit=ServerObj.QPCCNursePlanPrintStatusLimit
	var arrLimit = QPCCNursePlanPrintStatusLimit.split('^');
	for (i in arrLimit){		
		if (arrLimit[i].toString()=="00"){
			arrLimit[i]="未停止"			
		}else if(arrLimit[i].toString()=="01"){
			arrLimit[i]="未评价"	
		}
	}
	var arrLimitStr=arrLimit.join('@');
	return arrLimitStr;
}

function playDaysChange(target) {
    if (typeof (target) == 'string') target = '#' + target;
    var index = $(target).parents("[datagrid-row-index]").attr("datagrid-row-index");
    if (!index) index = "";
    var Editors = $('#NurQuestionTable').datagrid('getEditors', index);
    if ((ServerObj.IsOpenQuestionPriority == "Y") || (Editors.length >= 2)) {
        var playDays = $(Editors[1].target).val();
    } else {
        var playDays = $(Editors[0].target).val();
    }
    if (((playDays) && (!isPositiveInteger(playDays))) || (playDays === 0)) {
        if ($(".window-mask").is(":visible")) {
            return false;
        }
        $.messager.alert("提示", "目标达成天数只能为大于0的正整数！ ", "info", function () {
            $(target).focus();
        });
        return false;
    }
    if (1 != 1) {
        /* 好多项目无法提供准确的治疗天数，目前只有舟山在用，去掉此限制 2021.6.28
    if ((ServerObj.days!="")&&(Number(playDays) > Number(ServerObj.days))) {
		if ($(".window-mask").is(":visible")){
			return false;
		}
	    $.messager.alert("提示","目标达成天数: "+ playDays +" 不能超过治疗天数: "+ServerObj.days+"天","info",function(){
		    $(target).focus();
		}); 
		return false;
	*/
    } else {
        var rows = $('#NurQuestionTable').datagrid('getRows');
        var rtn = $.m({
            ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
            MethodName: "SavePalyDays",
            RowId: rows[index].recordId,
            Days: playDays
        }, false);
        if (playDays) {
            var createDateTime = rows[index].createDateTime;
            var createDate = createDateTime.split(" ")[0];
            if (createDate.indexOf("/") >= 0) {
                createDate = createDate.split("/")[2] + "-" + createDate.split("/")[1] + "-" + createDate.split("/")[0];
            } else {
                createDate = createDate.replace(/\-/g, "/"); //createDate.replaceAll("-", "/");
            }
            var date = new Date(createDate);
            date.setDate(date.getDate() + parseInt(playDays));
            var playDate = myformatter(date);
        } else {
            var playDate = "";
        }
        $('#NurQuestionTable').datagrid('updateRow', {
            index: index,
            row: {
                playDate: playDate,
                playDays: playDays
            }
        });
    }
    return true;
}

function NQRECSerialNoChange(target) {
    if (typeof (target) == 'string') target = '#' + target;
    var index = $(target).parents("[datagrid-row-index]").attr("datagrid-row-index");
    if (!index) index = "";
    var Editors = $('#NurQuestionTable').datagrid('getEditors', index);
    var NQRECSerialNo = $(Editors[0].target).val();
    if ((NQRECSerialNo) && (!isPositiveInteger(NQRECSerialNo))) {
        if ($(".window-mask").is(":visible")) {
            return false;
        }
        $.messager.alert("提示", "优先级只能为正整数！", "info", function () {
            $(target).focus();
        });
        return false;
    } else {
        var rows = $('#NurQuestionTable').datagrid('getRows');
        var rtn = $.m({
            ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
            MethodName: "UpdateQuestionRecordSerialNo",
            recordId: rows[index].recordId,
            SerNo: NQRECSerialNo
        }, false);
        $('#NurQuestionTable').datagrid("endEdit", index);
        $('#NurQuestionTable').datagrid("load");
    }
    return true;
}
//是否为正整数
function isPositiveInteger(s) {
    var re = /^[0-9]+$/;
    return re.test(s)
}
// 弹出新增非评估相关因素框
function ShowAddQLRealateFactorWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '请选择一条护理问题！',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("AddQLRealateFactor");
    var iconCls = "icon-w-add";
    createModalDialog("QuestionDiag", $g("手动新增非评估相关因素"), 350, 200, iconCls, $g("确定"), Content, "SaveQLRealateFactor()");
    $("#QLRealateFactor").focus();
}
// 手动加入且状态为空的费相关因素描述修改
function EditQuestionFactor(factorDR) {
    var index = $("#QLRealateFactorTable").datagrid("getRowIndex", factorDR);
    var Rows = $("#QLRealateFactorTable").datagrid("getRows");
    var factorName = Rows[index].factorName;
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("AddQLRealateFactor");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("修改非相关评估因素"), 350, 200, iconCls, $g("确定"), Content, "SaveQLRealateFactor(" + factorDR + ")");
    $("#QLRealateFactor").val(factorName).focus();
}
//保存非评估相关因素
function SaveQLRealateFactor(factorDR) {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var recordId = QueSelRows[0].recordId;
    var questionDR = QueSelRows[0].queRowId;
    if (!factorDR) factorDR = "";
    if (factorDR) {
        var index = $("#QLRealateFactorTable").datagrid("getRowIndex", factorDR);
    }
    var QLRealateFactor = $.trim($("#QLRealateFactor").val());
    if (!QLRealateFactor) {
        $.messager.popover({
            msg: '非相关因素不能为空！',
            type: 'error'
        });
        $('#QLRealateFactor').focus();
        return false;
    }
    var rtn = $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "AddFactorRecord",
        factorDR: factorDR,
        questionDR: questionDR,
        desc: QLRealateFactor,
        userId: session['LOGON.USERID'],
        locDr: session['LOGON.CTLOCID'],
        privateEpID: ServerObj.EpisodeID
    }, false)
    if (rtn == 0) {
        if (factorDR) {
            destroyDialog("QuestionDiag");
            $('#QLRealateFactorTable').datagrid('updateRow', {
                index: index,
                row: {
                    factorName: QLRealateFactor
                }
            });
        } else {
            destroyDialog("QuestionDiag");
            //$("#QLRealateFactor").val("").focus();
            $("#QLRealateFactorTable").datagrid('reload');
        }
    } else {
        $.messager.popover({
            msg: '保存非相关因素失败！' + rtn,
            type: 'error'
        });
    }
}
// 删除非评估相关因素,多个护理目标以^分割
function DelQLRealateFactor() {
    var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
    if (QLRealateFactorSelRows.length == 0) {
        $.messager.popover({
            msg: '请选择需要删除的非评估相关因素！',
            type: 'error'
        });
        return false;
    }
    var delfactorDRRArr = new Array();
    for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
        var recordID = QLRealateFactorSelRows[i].recordID;
        if (recordID) {
            $.messager.popover({
                msg: '已提交的数据不能删除！',
                type: 'error'
            });
            return false;
        }
        var private = QLRealateFactorSelRows[i].private;
        if (!private) {
            $.messager.popover({
                msg: '系统自动带入的数据不能删除！',
                type: 'error'
            });
            return false;
        }
        delfactorDRRArr.push(QLRealateFactorSelRows[i].factorDR);
    }
    if (delfactorDRRArr.length == 0) {
        $.messager.popover({
            msg: '请选择需要删除的非评估相关因素！',
            type: 'error'
        });
        return false;
    }
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "DeleteFactorRecord",
        factorDRList: delfactorDRRArr.join("^")
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '删除非评估相关因素成功！',
                type: 'success'
            });
            $("#QLRealateFactorTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '删除非评估相关因素失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 弹出非相关因素撤销原因框
/*function ShowQLRealateFactorCancelWin(){
	destroyDialog("QuestionDiag");
	var sels=$('#QLRealateFactorTable').datagrid('getSelections');
	if (sels.length==0){
		$.messager.popover({msg:'请选择需要撤销的非评估相关因素！',type:'error'});
		return false;
	}
	for (var i=0;i<sels.length;i++){
		var recordID=sels[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'未提交的非评估相关因素不能撤销！',type:'error'});
			return false;
		}
	}
	var Content=initDiagDivHtml("Cancel");
    var iconCls="";
    createModalDialog("QuestionDiag","撤销非评估相关问题", 350, 200,iconCls,"确定",Content,"CancelQLRealateFactor()");
    InitCancelReason();
}
// 非相关因素撤销
function CancelQLRealateFactor(){
	var QLRealateFactorSelRows=$("#QLRealateFactorTable").datagrid("getSelections");
	if (QLRealateFactorSelRows.length ==0) {
		$.messager.popover({msg:'请选择需要撤销的非评估相关因素！',type:'error'});
		return false;
	}
	var canelrecordIDRArr=new Array();
	for (var i=0;i< QLRealateFactorSelRows.length ;i++){
		var recordID=QLRealateFactorSelRows[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'未提交的非评估相关因素不能撤销！',type:'error'});
			return false;
		}
		canelrecordIDRArr.push(QLRealateFactorSelRows[i].recordID);
	}
	var CancelReasonObj=GetCancelReasonObj();
	if (CancelReasonObj.successFlag ==false) {
		return false;
	}
	var QueSelRows=$("#NurQuestionTable").datagrid("getSelections");
	var recordId=QueSelRows[0].recordId;
	var planID=recordId.split("||")[0];
	var questSub=recordId.split("||")[1];
	$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
		MethodName:"CancelFactorRecord",
		userId:session['LOGON.USERID'],
		planID:planID, 
		questSub:questSub,
		recordIdList:canelrecordIDRArr.join("^"),
		cancelReason:CancelReasonObj.CancelReason
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg:'撤销非评估相关因素成功！',type:'success'});
			destroyDialog("QuestionDiag");
			$("#QLRealateFactorTable").datagrid('reload');
			return false;
		}else{
			$.messager.alert("提示","撤销非评估相关因素失败！"+rtn);
		}
	})
}*/
// 非相关因素作废
function ShowQLRealateFactorUnUseWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QLRealateFactorTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要作废的非评估相关因素！',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var recordID = sels[i].recordID;
        var statusName = sels[i].statusName;
        if (statusName == "作废") {
            $.messager.popover({
                msg: '" 作废 "的非评估相关因素不能再次作废！',
                type: 'error'
            });
            return false;
        }
        if (!recordID) {
            $.messager.popover({
                msg: '未提交的非评估相关因素不能作废！',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("UnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("作废非评估相关问题"), 350, 200, iconCls, $g("确定"), Content, "UnUseQLRealateFactor()");
    InitUnUseReason();
}
// 非相关因素作废
function UnUseQLRealateFactor() {
    var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
    var unUseRecordIDRArr = new Array();
    for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
        unUseRecordIDRArr.push(QLRealateFactorSelRows[i].recordID);
    }
    var UnUseReasonObj = GetUnUseReasonObj();
    if (UnUseReasonObj.successFlag == false) {
        return false;
    }
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questSub = recordId.split("||")[1];
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "UnUseFactorRecord",
        userId: session['LOGON.USERID'],
        planID: planID,
        questSub: questSub,
        recordIdList: unUseRecordIDRArr.join("^"),
        cancelReason: UnUseReasonObj.UnUseReason
    }, function (rtn) {
        if (rtn == 0) {
            destroyDialog("QuestionDiag");
            $("#QLRealateFactorTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '作废非评估相关因素失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 撤销作废非相关因素
function RevokeUnUseFactorRecord() {
    var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
    if (QLRealateFactorSelRows.length == 0) {
        $.messager.popover({
            msg: '请选择已作废的非评估相关因素记录！',
            type: 'error'
        });
        return false;
    }
    var unUseRecordIDRArr = new Array();
    for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
        var recordID = QLRealateFactorSelRows[i].recordID;
        var statusName = QLRealateFactorSelRows[i].statusName;
        if (statusName != "作废") {
            $.messager.popover({
                msg: '非" 作废 "状态的非评估相关因素不能撤销作废！',
                type: 'error'
            });
            return false;
        }
        unUseRecordIDRArr.push(recordID);
    }
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questSub = recordId.split("||")[1];
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "RevokeUnUseFactorRecord",
        userId: session['LOGON.USERID'],
        planID: planID,
        questSub: questSub,
        recordIdList: unUseRecordIDRArr.join("^")
    }, function (rtn) {
        if (rtn == 0) {
            $("#QLRealateFactorTable").datagrid('reload');
        } else {
            $.messager.popover({
                msg: '撤销作废非评估相关因素失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 弹出新增护理目标框
function ShowAddQuestionTargetWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '请选择一条护理问题！',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("AddQuestionTarget");
    var iconCls = "icon-w-add";
    createModalDialog("QuestionDiag", $g("手动新增护理目标"), 350, 200, iconCls, $g("确定"), Content, "SaveQuestionTarget()");
    $("#QuestionTarget").focus();
}
// 护理目标保存
function SaveQuestionTarget(goalDR) {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var recordId = QueSelRows[0].recordId;
    var questionDR = QueSelRows[0].queRowId;
    if (!goalDR) goalDR = "";
    if (goalDR) {
        var index = $("#QuestionTargetTable").datagrid("getRowIndex", goalDR);
    }
    var QuestionTarget = $.trim($("#QuestionTarget").val());
    if (!QuestionTarget) {
        $.messager.popover({
            msg: '请输入护理目标！',
            type: 'error'
        });
        $("#QuestionTarget").focus();
        return false;
    }
    var rtn = $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "AddGoalRecordManual",
        planID: recordId.split("||")[0],
        questionSub: recordId.split("||")[1],
        optID: "",
        locDr: session['LOGON.CTLOCID'],
        wardDr: session['LOGON.WARDID'],
        desc: QuestionTarget,
        questionDR: questionDR,
        GoalRowId: goalDR,
        NGPrivateEpID: ServerObj.EpisodeID
    }, false)
    if (rtn >= 0) {
        if (goalDR) {
            $('#QuestionTargetTable').datagrid('updateRow', {
                index: index,
                row: {
                    goalName: QuestionTarget
                }
            });
            destroyDialog("QuestionDiag");
        } else {
            destroyDialog("QuestionDiag");
            //$("#QuestionTarget").val("").focus();
            $("#QuestionTargetTable").datagrid('reload');
        }
    } else {
        $.messager.popover({
            msg: '保存护理目标失败！' + rtn,
            type: 'error'
        });
        $("#QuestionTarget").focus();
    }
}
// 手动加入且状态为空的护理目标描述修改
function EditQuestionTarget(goalDR) {
    var index = $("#QuestionTargetTable").datagrid("getRowIndex", goalDR);
    var Rows = $("#QuestionTargetTable").datagrid("getRows");
    var goalName = Rows[index].goalName;
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("EditQuestionTarget");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("修改护理目标"), 350, 200, iconCls, $g("确定"), Content, "SaveQuestionTarget(" + goalDR + ")");
    $("#QuestionTarget").val(goalName).focus();
}
// 删除护理目标,多个护理目标以^分割
function DelQuestionTarget() {
    var QueTargetSelRows = $("#QuestionTargetTable").datagrid("getSelections");
    if (QueTargetSelRows.length == 0) {
        $.messager.popover({
            msg: '请选择需要删除的护理目标！',
            type: 'error'
        });
        return false;
    }
    var delGoalDRArr = new Array();
    for (var i = 0; i < QueTargetSelRows.length; i++) {
        var recordID = QueTargetSelRows[i].recordID;
        if (recordID) {
            $.messager.popover({
                msg: '已提交的护理目标不能删除！',
                type: 'error'
            });
            return false;
        }
        var dataSource = QueTargetSelRows[i].dataSource;
        if (dataSource == $g("系统带入")) {
            $.messager.popover({
                msg: '系统自动带入的护理目标不能删除！',
                type: 'error'
            });
            return false;
        }
        delGoalDRArr.push(QueTargetSelRows[i].goalDR);
    }
    if (delGoalDRArr.length == 0) {
        $.messager.popover({
            msg: '请选择需要删除的护理目标！',
            type: 'error'
        });
        return false;
    }
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "delGoalRecordManual",
        GoalId: delGoalDRArr.join("^")
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '删除护理目标成功！',
                type: 'success'
            });
            $("#QuestionTargetTable").datagrid('reload');
        } else {
            $.messager.popover({
                msg: '删除护理目标失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 弹出护理目标撤销框
/*function ShowQuestionTargetCancelWin(){
	destroyDialog("QuestionDiag");
	var sels=$('#QuestionTargetTable').datagrid('getSelections');
	if (sels.length==0){
		$.messager.popover({msg:'请选择需要撤销的护理目标！',type:'error'});
		return false;
	}
	for (var i=0;i<sels.length;i++){
		var recordID=sels[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'未提交的护理目标不能撤销！',type:'error'});
			return false;
		}
	}
	var Content=initDiagDivHtml("Cancel");
    var iconCls="";
    createModalDialog("QuestionDiag","撤销护理目标", 350, 200,iconCls,"确定",Content,"CancelQuestionTarget()");
    InitCancelReason();
}
// 撤销护理目标
function CancelQuestionTarget(){
	var QueSelRows=$("#NurQuestionTable").datagrid("getSelections");
	if (QueSelRows.length ==0) {
		$.messager.popover({msg:'请先选择护理问题！',type:'error'});
		return false;
	}else if(QueSelRows.length > 1){
		$.messager.popover({msg:'请选择一条护理问题！',type:'error'});
		return false;
	}
	var recordId=QueSelRows[0].recordId;
	var planID=recordId.split("||")[0];
	var questionSub=recordId.split("||")[1];
	var sels=$('#QuestionTargetTable').datagrid('getSelections');
	var selRecordArr=new Array();
	for (var i=0;i<sels.length;i++){
		var recordID=sels[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'未提交的护理目标不能撤销！',type:'error'});
			return false;
		}
		selRecordArr.push(recordID);
	}
	var CancelReasonObj=GetCancelReasonObj();
	if (CancelReasonObj.successFlag ==false) {
		return false;
	}
	$.cm({
	    ClassName:"Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
	    MethodName:"CancelGoalRecord",
		userId:session['LOGON.USERID'],
		planID:planID,
		questSub:questionSub,
		recordIdList:selRecordArr.join("^"),
		CancelReason:CancelReasonObj.CancelReason,
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			$.messager.popover({msg:'撤销护理目标成功！',type:'success'});
			destroyDialog("QuestionDiag");
			$("#QuestionTargetTable").datagrid('load');
		}else{
			$.messager.alert("提示","撤销护理目标失败！"+rtn);
		}
	})
}*/
// 弹出护理目标作废框
function ShowQuestionTargetUnUseWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QuestionTargetTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要作废的护理目标！',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var recordID = sels[i].recordID;
        if (!recordID) {
            $.messager.popover({
                msg: '未提交的护理目标不能作废！',
                type: 'error'
            });
            return false;
        }
        var goalStatus = sels[i].goalStatus;
        if (goalStatus == "作废") {
            $.messager.popover({
                msg: '已" 作废 "的护理目标记录不能再次作废！',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("UnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("作废护理目标"), 350, 200, iconCls, $g("确定"), Content, "UnUseQuestionTarget()");
    InitUnUseReason();
}
// 作废护理目标
function UnUseQuestionTarget() {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questionSub = recordId.split("||")[1];
    var sels = $('#QuestionTargetTable').datagrid('getSelections');
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        selRecordArr.push(sels[i].recordID);
    }
    var UnUseReasonObj = GetUnUseReasonObj();
    if (UnUseReasonObj.successFlag == false) {
        return false;
    }
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "UnUseGoalRecord",
        userId: session['LOGON.USERID'],
        planID: planID,
        questSub: questionSub,
        recordIdList: selRecordArr.join("^"),
        CancelReason: UnUseReasonObj.UnUseReason,
        dataType: "text"
    }, function (rtn) {
        if (rtn == 0) {
            destroyDialog("QuestionDiag");
            $("#QuestionTargetTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '作废护理目标失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 撤销作废护理目标
function RevokeUnUseQuestionTarget() {
    var sels = $("#QuestionTargetTable").datagrid("getSelections");
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择已作废的护理目标记录！',
            type: 'error'
        });
        return false;
    }
    var unUseRecordIDRArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var recordID = sels[i].recordID;
        var goalStatus = sels[i].goalStatus;
        if (goalStatus != "作废") {
            $.messager.popover({
                msg: '非" 作废 "的护理目标记录不能撤销作废！',
                type: 'error'
            });
            return false;
        }
        unUseRecordIDRArr.push(recordID);
    }
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questSub = recordId.split("||")[1];
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "RevokeUnUseGoalRecord",
        userId: session['LOGON.USERID'],
        planID: planID,
        questSub: questSub,
        recordIdList: unUseRecordIDRArr.join("^")
    }, function (rtn) {
        if (rtn == 0) {
            $("#QuestionTargetTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '撤销作废护理目标失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 弹出新增护理措施框
function ShowAddQuestionMeasureWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '请选择一条护理问题！',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("AddQuestionMeasure");
    var iconCls = "icon-w-add";
    // gaoshan add -- 410, 400
    createModalDialog("QuestionDiag", $g("新增护理措施"), 410, 337, iconCls, $g("确定"), Content, "SaveQuestionMeasure()");
    InitQuestionMeasureWin();
    // 新增措施右键引用医嘱 gaoshan add 20210609 start
    rightHandler('TextareaElement_measure')
    // RefHandler('TextareaElement_measure',false,true,false);
    // end
}

// 重写病历的方法 start
var curElement = null;

function rightHandler(formId) {
    var selector = $.type(formId) == 'object' ? formId : '#' + formId;
    $(selector).bind('contextmenu', function (e) {
        if ($('#menu').length == 0) {
            $('body').append(document.getElementById('menuTemplate').innerHTML);
            $('#menu').menu();
        }
        $('#menu').empty();
        //添加引用
        $('#menu').menu('appendItem', {
            id: 'menuRefer',
            text: '引用',
            iconCls: 'icon-paper-link-pen',
            onclick: createDialog
        });

        e.preventDefault();
        $('#menu').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
    });

    $(selector).mouseup(function (e) {
        curElement = e.target;
    });
}

function createDialog() {

    // 只有医嘱 页签
    var tabItems = new Array();
    tabItems.push("Order")

    var topFrame = topWindow(window);

    // 2021.6.21 update
    topFrame.$('body').remove('#dialogRefer2'); //移除存在的Dialog
    topFrame.$('#dialogRefer2').dialog('destroy');

    if (topFrame.$('#dialogRefer2').length == 0) {
        topFrame.$('body').append(document.getElementById('dialogReferTemplate').innerHTML);
        topFrame.$('#dialogRefer2').dialog();
    }

    referHandlerClick(tabItems);

    //$('#btnRefer').bind('click', sureReferHandler);
    //$('#btnClose').bind('click', closeHandler);
    //topFrame.$('#btnClear').bind('click', topFrame.Knowledge.ClearHandler);

    topFrame.$('#btnRefer').on('click', function () {
        sureReferHandler();
    })
    topFrame.$('#btnClose').on('click', function () {
        closeHandler();
    })


}

// 获取url参数
function getQueryVariable(variable) {
    var query = window.location.search;
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) {
            return pair[1];
        }
    }
    return "0";
}

// 判断是否是病历跳转标识
function isRedirect() {
    var cspRedirect = getQueryVariable("Redirect")
    // 由护理病历跳转到护理计划
    if (cspRedirect == "1") {
        return true;
    }
    return false;
}

function getRealObj() {
    var parentWin = window.parent.document.getElementById("dialogRefer2");
    var dialogObj = $('#dialogRefer2')
    // 由护理病历跳转到护理计划
    if (isRedirect()) {
        var topFrame = topWindow(window);
        dialogObj = topFrame.$('#dialogRefer2') //$(parentWin)
    }
    return dialogObj;
}

/**
 * @description: 弹窗
 */
function referHandlerClick(tabs) {
    var dialogObj = getRealObj()

    // url 解码
    //var xx = decodeURI(decodeURI(getQueryVariable("formatItemValue")))

    //var tabsArr=["Order"];
    //var url = "nur.hisui.nurseRefer.comm.csp?EpisodeID=" + EpisodeID + "&Tabs=" + tabsArr.join(",") ;

    var url = "nur.hisui.nurseplan.refer.csp?EpisodeID=" + EpisodeID + "&Tabs=" + tabs;
    // MWToken 改造
    url = getIframeUrl(url);
    // 病历跳转标识
    var isRedirectFlag = isRedirect()
    var initWidth = $(window).width() - 600
    if (isRedirectFlag) {
        initWidth = $(window).width() - 300
    }
    dialogObj.dialog({
        // $('#dialogRefer2').dialog({  
        title: '引用',
        width: initWidth,
        height: $(window).height() - 10,
        cache: false,
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true
    });
    //$("#dialogRefer2").dialog("open");
    dialogObj.dialog("open");
}

function sureReferHandler() { // 参考 rightClickHandler.js 方法
    var topFrame = topWindow(window);

    var groupID = 'groupOrder';
    var result = '';

    var subWin = topFrame.$("#iframeRefer")[0].contentWindow
    var rows = subWin.$('#dataGrid').datagrid('getSelections');
    if (rows.length == 0) {
        topFrame.$.messager.popover({
            msg: '请选择需要引入的内容！',
            type: 'error'
        });
        return;
    }
    var wordsArr = subWin.$('#' + groupID).keywords('getSelected');
    if (wordsArr.length == 0) {
        topFrame.messager.popover({
            msg: '请选择需要引入的列！',
            type: 'error'
        });
        return;
    }
    $.each(rows, function (index, row) {
        var subResult = '';
        $.each(wordsArr, function (i, word) {
            var checkName = word.id.substr(groupID.length);
            var itemData = eval("row." + checkName);
            itemData = String(itemData);
            subResult = !subResult ? itemData : subResult + ' ' + itemData;
        });
        result = !!result ? result + '，' + subResult : subResult;
    });
    var curPosition = topFrame.Knowledge.GetCursortPosition(curElement);
    updateRefer(curElement, result, curPosition);
    closeHandler();
}


function updateRefer(curElement, editContent, curPosition) {
    var startText = curPosition == 0 ? '' : curElement.value.substring(0, curPosition);
    if (startText.trim() == '/') {
        startText = '';
    }
    var endText = curElement.value.substring(curPosition);
    SetOneValue(curElement.id, startText + editContent + endText);
}

function clearHandler() {
    /*
    var textEdit = $('#iframeRefer').contents().find('#textEdit')[0];
    $(textEdit).val('');
    var btnClear = $('#iframeRefer').contents().find('#btnClearTree')[0];
    if (btnClear) btnClear.click();
    */
}

function closeHandler() {
    //var dialogObj = getRealObj()
    var topFrame = topWindow(window);
    topFrame.$('#dialogRefer2').dialog('close');
}

function topWindow(currentWindow) {
    if (!!currentWindow.parent) {
        if (!currentWindow.parent.TemplateIndentity) {
            return currentWindow;
        }
        return topWindow(currentWindow.parent);
    }
    return currentWindow;
}
// end

/*
function SetOneValue(id, val)
{
	alert('asdsad')
}
*/

// 初始化护理措施弹框数据
function InitQuestionMeasureWin() {
    // 措施类别
    $("#InterventionType").combobox({
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindInterventionType&rows=99999",
        mode: 'remote',
        method: "Get",
        multiple: false,
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'NewName',
        onBeforeLoad: function (param) {
            param.nameCN = param['q'];
            param.hospDR = session['LOGON.HOSPID'];
        },
        loadFilter: function (data) {
            // todo 优化 改成query直接返回显示值
            var newData = new Array();
            for (var i = 0; i < data.total; i++) {
                var obj = data.rows[i];
                obj.NewName = obj.shortNameEN + obj.shortNameCN;
                newData.push(obj);
            }
            return newData;
        },
        onLoadSuccess: function () {
            var data = $("#InterventionType").combobox('getData');
            if (data.length > 0) {
                $("#InterventionType").combobox("select", data[0].id);
            }
        }
    });
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var template = QueSelRows[QueSelRows.length - 1].template;
    // 相关因素
    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "GetReasonByTemplateId",
        IDs: template
    }, function (templateJson) {
        $("#InterventionRecord").combobox({
            mode: 'local',
            multiple: false,
            selectOnNavigation: true,
            valueField: 'ID',
            textField: 'ReportItem',
            data: templateJson
        });
    })
    // 执行频率
    $("#InterventionFreq").combobox({
        // 增加就诊id入参 2021.7.5
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionFreq&rows=99999&episodeID=" + ServerObj.EpisodeID,
        mode: 'remote',
        method: "Get",
        multiple: false,
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'name',
        disabled: PageLogicObj.m_SelQuestionObj.isNQNursingAdvice == "Y" ? false : true,
        loadFilter: function (data) {
            // todo 优化 改成query直接返回显示值
            var newData = new Array();
            for (var i = 0; i < data.total; i++) {
                var obj = data.rows[i];
                obj.name = obj.code + "(" + obj.namec + ")";
                newData.push(obj);
            }
            return newData;
        },
        onBeforeLoad: function (param) {
            param.codeIn = param['q'];
            param.active = "Y";
            param.hospicalID = session['LOGON.HOSPID'];
        },
        onLoadSuccess: function () {
            if (PageLogicObj.m_SelQuestionObj.isNQNursingAdvice == "Y") {
                $("label[for='InterventionFreq']").addClass("clsRequired");
            } else {
                $("label[for='InterventionFreq']").removeClass("clsRequired");
            }
        },
        onSelect: function (rec) {
            if (rec) {
                PageLogicObj.m_selWeek = "";
                if (rec.weekFlag == "Yes") {
                    InitWeekFreqWin($g("周频次星期选择"));
                    InitWeekTable(rec.name, rec.disposing);
                    $("#WeekFreqWin").window("open");
                }
            }
        }
    });
    $("#startdate").datebox('setValue', ServerObj.CurrentDate);
    $("#enddate").datebox('setValue', "");
    $('#InterventionType').next('span').find('input').focus();
}
// 保存护理措施
function SaveQuestionMeasure(intervDR) {
    if (!intervDR) intervDR = "";
    if (intervDR) {
        var index = $("#QuestionMeasureTable").datagrid("getRowIndex", intervDR);
        var QueRows = $("#QuestionMeasureTable").datagrid("getRows");
        var intervName = QueRows[index].intervName;
        var NewintervName = $.trim($("#QuestionMeasure").val());
        if (!NewintervName) {
            $.messager.popover({
                msg: '护理措施不能为空！',
                type: 'error'
            });
            $('#QuestionMeasure').focus();
            return false;
        }
        $.m({
            ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
            MethodName: "UpdatePrivateInterDesc",
            episodeID: ServerObj.EpisodeID,
            intervDR: intervDR,
            desc: NewintervName,
            userId: session['LOGON.USERID']
        }, function (rtn) {
            if (rtn == 0) {
                $.messager.popover({
                    msg: '修改护理措施成功！',
                    type: 'success'
                });
                destroyDialog("QuestionDiag");
                $('#QuestionMeasureTable').datagrid('updateRow', {
                    index: index,
                    row: {
                        intervName: NewintervName
                    }
                });
            } else {
                $.messager.popover({
                    msg: '修改护理措施失败！' + rtn,
                    type: 'error'
                });
            }
        })
    } else {
        var InterventionType = $("#InterventionType").combobox('getValue');
        var index = $.hisui.indexOfArray($('#InterventionType').combobox("getData"), "id", InterventionType);
        if (index < 0) {
            $.messager.popover({
                msg: '请选择措施类别！',
                type: 'error'
            });
            $('#InterventionType').next('span').find('input').focus();
            return false;
        }
        var measure = $.trim($("#TextareaElement_measure").val());
        if (!measure) {
            $.messager.popover({
                msg: '请输入措施短描述！',
                type: 'error'
            });
            $('#TextareaElement_measure').focus();
            return false;
        }
        // 去掉相关因素 2021.7.3
        var InterventionRecord = "" //$("#InterventionRecord").combobox('getValue');
        if (!InterventionRecord) InterventionRecord = "";
        var InterventionRecordData = "" //$('#InterventionRecord').combobox("getData");
        if (InterventionRecord) {
            var index = $.hisui.indexOfArray(InterventionRecordData, "ID", InterventionRecord);
            if (index < 0) {
                $.messager.popover({
                    msg: '请在下拉框中选择相关因素！',
                    type: 'error'
                });
                $('#InterventionRecord').next('span').find('input').focus();
                return false;
            }
        }
        var InterventionFreq = "";
        if (PageLogicObj.m_SelQuestionObj.isNQNursingAdvice == "Y") {
            var InterventionFreq = $("#InterventionFreq").combobox('getValue');
            var index = $.hisui.indexOfArray($('#InterventionFreq').combobox("getData"), "id", InterventionFreq);
            if (index < 0) {
                $.messager.popover({
                    msg: '请选择执行频率！',
                    type: 'error'
                });
                $('#InterventionFreq').next('span').find('input').focus();
                return false;
            }
        }
        var startdate = $("#startdate").combobox('getValue');
        if (!startdate) {
            $.messager.popover({
                msg: '请输入启用日期！',
                type: 'error'
            });
            $('#startdate').next('span').find('input').focus();
            return false;
        }
        var enddate = $("#enddate").combobox('getValue');
        if (enddate) {
            if (CompareDate(startdate, enddate)) {
                $.messager.popover({
                    msg: '停用日期不能晚于启用日期！',
                    type: 'error'
                });
                $('#enddate').next('span').find('input').focus();
                return false;
            }
        }
        var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
        var questionDR = QueSelRows[0].queRowId;
        //userID, locDR, wardDR, intTypeID, intShortName, intLongName, 
        //intEnableDate, intStopDate, defFreq, appArea, questionDR, episodeID, resonID, hospDR
        $.m({
            ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
            MethodName: "SaveNewInterventionList",
            userID: session['LOGON.USERID'],
            locDR: session['LOGON.CTLOCID'],
            wardDR: session['LOGON.WARDID'],
            intTypeID: InterventionType,
            intShortName: measure,
            intLongName: measure,
            intEnableDate: startdate,
            intStopDate: enddate,
            defFreq: InterventionFreq,
            appArea: "",
            questionDR: questionDR,
            episodeID: ServerObj.EpisodeID,
            resonID: InterventionRecord,
            hospDR: session['LOGON.HOSPID'],
            freqWeek: PageLogicObj.m_selWeek
        }, function (rtn) {
            if (rtn == 0) {
                $.messager.popover({
                    msg: '新增护理措施成功！',
                    type: 'success'
                });
                /*$("#InterventionType").combobox("select",$('#InterventionType').combobox("getData")[0].id);
                $("#measure").val("");
                $("#InterventionFreq,#InterventionRecord").combobox("select","");
                $("#startdate").datebox('setValue',ServerObj.CurrentDate);
                $("#enddate").datebox('setValue',"");
                $("#QuestionMeasureTable").datagrid('reload');
                $('#InterventionType').next('span').find('input').focus();*/
                PageLogicObj.m_selWeek = "";
                destroyDialog("QuestionDiag");
                $("#QuestionMeasureTable").datagrid('reload');
            } else {
                $.messager.popover({
                    msg: '新增护理措施失败！' + rtn,
                    type: 'error'
                });
            }
        })
    }
}
// 手动加入且状态为空的护理措施描述修改
function EditQuestionMeasure(intervDR) {
    PageLogicObj.m_selWeek = "";
    var index = $("#QuestionMeasureTable").datagrid("getRowIndex", intervDR);
    var QueRows = $("#QuestionMeasureTable").datagrid("getRows");
    var intervName = QueRows[index].intervName;
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("EditQuestionMeasure");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("修改护理措施"), 350, 200, iconCls, $g("确定"), Content, "SaveQuestionMeasure(" + intervDR + ")");
    $("#QuestionMeasure").val(intervName).focus();
}
// 删除护理措施,多个护理措施以^分割
function DelQuestionMeasure() {
    var QuestionMeasureSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
    if (QuestionMeasureSelRows.length == 0) {
        $.messager.popover({
            msg: '请选择需要删除的护理措施！',
            type: 'error'
        });
        return false;
    }
    var delintervDRArr = new Array();
    var delrowIDArr = new Array();
    for (var i = 0; i < QuestionMeasureSelRows.length; i++) {
        var dataSource = QuestionMeasureSelRows[i].dataSource;
        if (dataSource == $g("系统带入")) {
            $.messager.popover({
                msg: '系统带入的护理措施不能删除！',
                type: 'error'
            });
            return false;
        }
        var statusName = QuestionMeasureSelRows[i].statusName;
        if ((statusName == $g("停止")) || (statusName == $g("作废"))) {
            $.messager.popover({
                msg: '停止/作废的护理措施禁止删除！',
                type: 'error'
            });
            return false;
        }
        var intervDR = QuestionMeasureSelRows[i].intervDR;
        var rowID = QuestionMeasureSelRows[i].rowID;
        delintervDRArr.push(intervDR);
        delrowIDArr.push(rowID);

    }
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    var questionDR = QueSelRows[0].queRowId;
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "DeleteNewInterventions",
        userID: session['LOGON.USERID'],
        episodeID: ServerObj.EpisodeID,
        questionDR: questionDR,
        interventionDRList: delintervDRArr.join("^"),
        interventionIDList: delrowIDArr.join("^")
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '删除护理措施成功！',
                type: 'success'
            });
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '删除护理措施失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理措施停止弹框
function ShowQuestionMeasureStopWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '请选择需要停止的护理措施！',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        var rowID = sels[i].rowID;
        if (rowID == "") {
            $.messager.popover({
                msg: '未提交的护理措施不能停止！',
                type: 'error'
            });
            return false;
        } else if (statusName == $g("作废")) {
            $.messager.popover({
                msg: '已作废的护理措施不能停止！',
                type: 'error'
            });
            return false;
        } else if (statusName == $g("停止")) {
            $.messager.popover({
                msg: '已停止的护理措施不能再次停止！',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("NurQuestionnMeasureStop");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("护理措施停止"), 250, 207, iconCls, $g("确定"), Content, "NurQuestionMeasureStop()");
    InitStopReason();
    $("#MeasureStopDate").datebox("setValue", ServerObj.CurrentDate);
    $("#MeasureStopTime").timespinner('setValue', GetCurTime("N"));
    $("#MeasureStopTime").focus();
}
// 护理措施停止
function NurQuestionMeasureStop() {
    var MeasureStopDate = $("#MeasureStopDate").datebox("getValue");
    if (!MeasureStopDate) {
        $.messager.popover({
            msg: '停止日期不能为空',
            type: 'error'
        });
        $('#MeasureStopDate').next('span').find('input').focus();
        return false;
    } else {
        if (dtseparator == "/") {
            var tmpdate = MeasureStopDate.split("/")[2] + "-" + MeasureStopDate.split("/")[1] + "-" + MeasureStopDate.split("/")[0]
            var tmpdate1 = new Date(tmpdate.replace("-", "/").replace("-", "/"));
        } else {
            var tmpdate = MeasureStopDate;
            var tmpdate1 = new Date(MeasureStopDate.replace("-", "/").replace("-", "/"));
        }
        //  需求序号:2795419  护理计划的措施停止时间限制到当天需要放开到措施的开始时间
        var rows = $("#QuestionMeasureTable").datagrid('getSelections');
        for (var i=0; i<rows.length;i++){
	        var startDate = rows[i].startDatetime.split(" ")[0]
	        startDate = Date.parse(startDate.replace(/\-/g,'/'))
	        StopDate = Date.parse(MeasureStopDate.replace(/\-/g,'/'))
	        if (startDate>StopDate){
		        $.messager.popover({
		            msg: '停止日期不能小于开始日期',
		            type: 'error'
			    });        
			    $('#MeasureStopDate').next('span').find('input').focus();
        		return false;		        
		    }	        
	    }
        /*
        var CurDate = new Date();
        var end = new Date(CurDate.getFullYear() + "/" + (CurDate.getMonth() + 1) + '/' + CurDate.getDate());
        if (tmpdate1 < end) {
            $.messager.popover({
                msg: "停止日期应大于等于当天：" + myformatter(end) + "！",
                type: 'error'
            });
            $('#MeasureStopDate').next('span').find('input').focus();
            return false;
        }
        */
    }
    var MeasureStopTime = $("#MeasureStopTime").timespinner("getValue");
    if (MeasureStopTime == "") {
        $.messager.popover({
            msg: "停止时间不能为空！",
            type: 'error'
        });
        $('#MeasureStoptime').focus();
        return false;
    }
    if (!IsValidTime(MeasureStopTime)) {
        $.messager.popover({
            msg: "停止时间格式不正确! 时:分,如11:05",
            type: 'error'
        });
        $('#MeasureStopTime').next('span').find('input').focus();
        return false;
    }
    //  需求序号:2795419  护理计划的措施停止时间限制到当天需要放开到措施的开始时间
    for (var i=0; i<rows.length;i++){
	    var startDateTime = rows[i].startDatetime;
	    MeasureStopDateTime = MeasureStopDate+" "+MeasureStopTime;
	    if (+new Date(startDateTime)>+new Date(MeasureStopDateTime)){
	        $.messager.popover({
	            msg: '停止时间不能小于开始时间',
	            type: 'error'
		    });        
	        $('#MeasureStopTime').next('span').find('input').focus();
	        return false;		        
	    }
    }	        
	/*
    //var CurTime=GetCurTime("N");
    var timeStr = tmpdate + " " + MeasureStopTime;
    if (+new Date() - 60000 > +new Date(timeStr)) {
        //if (parseInt(MeasureStopTime.split(":")[1]) < parseInt(CurTime.split(":")[1])) {
        $.messager.popover({
            msg: "停止时间应大于当前时间！",
            type: 'error'
        });
        $('#MeasureStopTime').next('span').find('input').focus();
        return false;
    }
    */
    var StopReasonObj = GetStopReasonObj();
    if (StopReasonObj.successFlag == false) {
        return false;
    }
    var QuestionMeasureSelRows = $('#QuestionMeasureTable').datagrid('getSelections');
    var delrowIDArr = new Array();
    for (var i = 0; i < QuestionMeasureSelRows.length; i++) {
        delrowIDArr.push(QuestionMeasureSelRows[i].rowID);
    }
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "StopInterventions",
        userID: session['LOGON.USERID'],
        intRecordIDs: delrowIDArr.join("^"),
        stopDate: MeasureStopDate,
        stopTime: MeasureStopTime,
        StopReason: StopReasonObj.StopReason
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '停止护理措施成功！',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '停止护理措施失败！' + rtn,
                type: 'error'
            });
        }
    })
}
// 护理措施作废弹框
function ShowQuestionMeasureUnUseWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: "请选择需要作废的护理措施！",
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        var rowID = sels[i].rowID;
        if (rowID == "") {
            $.messager.popover({
                msg: "未提交的护理措施不能作废！",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("作废")) {
            $.messager.popover({
                msg: "已作废的护理措施不能再次作废！",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("停止")) {
            $.messager.popover({
                msg: "已停止的护理措施不能作废！",
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("NurQuestionnMeasureUnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("作废护理措施"), 350, 205, iconCls, $g("确定"), Content, "NurQuestionMeasureUnUse()");
    InitUnUseReason();
}
//作废护理措施
function NurQuestionMeasureUnUse() {
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: "请选择需要作废的护理措施！",
            type: 'error'
        });
        return false;
    }
    var UnUserowIDArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        var rowID = sels[i].rowID;
        if (rowID == "") {
            $.messager.popover({
                msg: "未提交的护理措施不能作废！",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("作废")) {
            $.messager.popover({
                msg: "已作废的护理措施不能再次作废！",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("停止")) {
            $.messager.popover({
                msg: "已停止的护理措施不能作废！",
                type: 'error'
            });
            return false;
        }
        UnUserowIDArr.push(rowID);
    }
    var UnUseReasonObj = GetUnUseReasonObj();
    if (UnUseReasonObj.successFlag == false) {
        return false;
    }
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "CancelInterventions",
        userID: session['LOGON.USERID'],
        intRecordIDs: UnUserowIDArr.join("^"),
        cancelReason: UnUseReasonObj.UnUseReason
    }, function (rtn) {
        if (rtn == 0) {
            $.messager.popover({
                msg: '作废护理措施成功！',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '作废护理措施失败！' + rtn,
                type: 'error'
            });
        }
    })
}
//撤销作废护理措施
function RevokeUnUseQuestionMeasure() {
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: "请选择需要撤销作废的护理措施！",
            type: 'error'
        });
        return false;
    }
    var UnUserowIDArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("作废")) {
            $.messager.popover({
                msg: '非" 作废 "状态的护理措施不能撤销作废！',
                type: 'error'
            });
            return false;
        }
        var rowID = sels[i].rowID;
        UnUserowIDArr.push(rowID);
    }
    $.m({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "RevokeCancelInterventions",
        userID: session['LOGON.USERID'],
        intRecordIDs: UnUserowIDArr.join("^")
    }, function (rtn) {
        if (rtn == 0) {
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '撤销作废护理措施失败！' + rtn,
                type: 'error'
            });
        }
    })
}

function IsValidTime(time) {
    if (time.split(":").length == 3) {
        var TIME_FORMAT = /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
    } else if (time.split(":").length == 2) {
        var TIME_FORMAT = /^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;
    } else {
        return false;
    }
    if (!TIME_FORMAT.test(time)) return false;
    return true;
}

function GetCurTime(IsShowSeconds) {
    function p(s) {
        return s < 10 ? '0' + s : s;
    }
    var myDate = new Date();
    var h = myDate.getHours(); //获取当前小时数(0-23)
    var m = myDate.getMinutes(); //获取当前分钟数(0-59)
    var s = myDate.getSeconds();
    if (IsShowSeconds == "Y") {
        var nowTime = p(h) + ':' + p(m) + ":" + p(s);
    } else {
        var nowTime = p(h) + ':' + p(m);
    }
    return nowTime;
}

function GetStatusFontColor(statusName) {
    var FontColor = "#000000";
    if (statusName.indexOf($g("撤销")) >= 0) {
        FontColor = ServerObj.CancelFontColor;
    } else if (statusName.indexOf($g("作废")) >= 0) {
        FontColor = ServerObj.UnUserFontColor;
    } else if ((statusName.indexOf($g("停止")) >= 0) && (statusName != $g("未停止"))) {
        FontColor = ServerObj.StopFontColor;
    }else if ((ServerObj.QPCCOpenNurEvaluate=="Y")&&(statusName.indexOf($g("评价")) >= 0) && (statusName != $g("未评价"))) {
        FontColor = ServerObj.StopFontColor;
    }
    return FontColor;
}

function SetNurPalnBtnStatus(statusName) {
    // 问题状态为作废、撤销 --下面三个表格的按钮都是非活、含右侧的提交按钮
    if ((statusName == $g("已撤销")) || (statusName == $g("已作废"))) {
        $("#BQuestionPlanSumit").hide();
        $("#BQuestionPlanCancel").hide();
        $("#QuestionEvaluate,#QuestionCancel,#QuestionUnUse,#QuestionStop").linkbutton('disable');
        if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
            $("#QLRealateFactorPanel .datagrid-toolbar a").linkbutton('disable');
        }
        if (ServerObj.IsOpenQuestionTarget == "Y") {
            $("#QuestionTargetPanel .datagrid-toolbar a").linkbutton('disable');
        }
        $("#QuestionMeasurePanel .datagrid-toolbar a").linkbutton('disable');
    } else {
        $("#BQuestionPlanSumit").show();
        $("#BQuestionPlanCancel").show();
        $("#QuestionEvaluate,#QuestionCancel,#QuestionUnUse,#QuestionStop").linkbutton('enable');
        if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
            $("#QLRealateFactorPanel .datagrid-toolbar a").linkbutton('enable');
        }
        if (ServerObj.IsOpenQuestionTarget == "Y") {
            $("#QuestionTargetPanel .datagrid-toolbar a").linkbutton('enable');
        }
        $("#QuestionMeasurePanel .datagrid-toolbar a").linkbutton('enable');
    }
    // 已作废的护理问题才能撤销作废
    if (statusName == "已作废") {
        $("#QuestionRevokeUnUse").linkbutton('enable');
    } else {
        $("#QuestionRevokeUnUse").linkbutton('disable');
    }

}
function SetNurPalnBtnCstatus(cstatus) {
	// 已评价的护理问题才能撤销评价
    if (cstatus == "已评价") {
        $("#QuestionRevokeEvaluate").linkbutton('enable');
    } else {
        $("#QuestionRevokeEvaluate").linkbutton('disable');
    }
}
//护理计划修改权限限制
function SetNurPalnBtnPermission(InsertUserId,PlanReviewUserId) {
	// 护理计划的作废、撤销作废、评价、撤销评价、停止等操作权限配置
	var QPCCNurPlanPermission=ServerObj.QPCCNurPlanPermission;
	// 是否进行计划审核权限
	var QPCCNurPlanReviewPermission=ServerObj.QPCCNurPlanReviewPermission;
	// 是否允许撤销计划审核权限
	var QPCCNPRCancelPermission=ServerObj.QPCCNPRCancelPermission;
	
	/*
	if (QPCCNurPlanPermission=="S&L"){
		//勾选 【本人】和【护士长】，创建者和护士长有护理计划的修改、删除、作废、撤销、评价、停止等操作权限配置
		if (!((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(session['LOGON.USERNAME']==InsertUser))){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}
	}else if (QPCCNurPlanPermission=="S"){
		//勾选【本人】，只有创建者有护理计划的修改、删除、作废、撤销、评价、停止等操作权限配置
		if (!(session['LOGON.USERNAME']==InsertUser)){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
	}else if(QPCCNurPlanPermission=="L") {
		//勾选【护士长】，只有护士长有护理计划的修改、删除、作废、撤销、评价、停止等操作权限配置
		if (!(session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}		
	} else if (QPCCNurPlanPermission==""){
		//如果未勾选“本人”或“护士长”，则表示本病区所有护士均可操作，不设权限
	}
	*/
	var LOGONGROUPID = "@"+session['LOGON.GROUPID']+"@"
	if (!((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(ServerObj.LeaderGROUPID.indexOf(LOGONGROUPID)!=-1)||(session['LOGON.USERID']==InsertUserId))){
		// 不是护士长不是本人（创建人）
		//未勾选【本人】或【护士长】，本病区所有护士均可操作，不设权限	
		if (QPCCNurPlanPermission!=""){					
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
		//审核权限勾选 非空  用户不拥有护理计划审核权限
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			if (QPCCNurPlanReviewPermission!=""){
				$("#NurPlanReview").linkbutton('disable');
			}else{
				$("#NurPlanReview").linkbutton('enable');
			}
		}
		//谁审核谁撤销
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			//不是护士长不是创建人不是审核人		
			//审核权限勾选 非空  用户不拥有护理计划撤销审核权限
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				if (QPCCNPRCancelPermission!=""){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');
				}
			}
		}
	}else if (((session['LOGON.GROUPDESC'].indexOf('护士长')!=-1)||(ServerObj.LeaderGROUPID.indexOf(LOGONGROUPID)!=-1))&&(session['LOGON.USERID']!=InsertUserId)){
		//是护士长不是本人（创建人）
		//勾选【本人】护士长不拥有护理计划的作废、撤销作废、评价、撤销评价、停止等操作权限配置
		if(QPCCNurPlanPermission=="S"){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
		// 勾选【本人】护士长不拥有护理计划审核权限
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			if (QPCCNurPlanReviewPermission=="S"){
				$("#NurPlanReview").linkbutton('disable');
			}else{
				$("#NurPlanReview").linkbutton('enable');
			}
		}
		//谁审核谁撤销
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			//是护士长不是创建人不是审核人
			// 勾选【本人】护士长不拥有护理计划撤销审核权限
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				if (QPCCNPRCancelPermission=="S"){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');
				}
			}
			
		}
	}else if ((session['LOGON.USERID']==InsertUserId)&&((session['LOGON.GROUPDESC'].indexOf('护士长')==-1)||(ServerObj.LeaderGROUPID.indexOf(LOGONGROUPID)==-1))){
		// 不是护士长是本人 （创建人）
		// 勾选【本人】或【本人和护士长】创建者有护理计划的作废、撤销作废、评价、撤销评价、停止等操作权限配置
		if (QPCCNurPlanPermission=="L"){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
		// 勾选【护士长】创建者不拥有护理计划审核权限
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			if (QPCCNurPlanReviewPermission=="L"){
				$("#NurPlanReview").linkbutton('disable');
			}else{
				$("#NurPlanReview").linkbutton('enable');
			}
		}
		//谁审核谁撤销
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			// 不是护士长是创建人不是审核人
			// 勾选【护士长】创建者不拥有护理计划撤销审核权限
			// 勾选【本人】创建者不拥有护理计划撤销审核权限
			// 即审核权限勾选 为空 创建者才拥有护理计划撤销审核权限			
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				if (QPCCNurPlanReviewPermission!=""){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');
				}
			}
		}
	}else{
		//是护士长是本人(创建人)
		//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			$("#NurPlanReview").linkbutton('enable');
		}
		//谁审核谁撤销
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			//是护士长是创建人不是审核人
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				// 勾选【本人】创建者不拥有护理计划撤销审核权限
				if (QPCCNPRCancelPermission=="S"){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');	
				}		
			}
		}	
	}	
}

function InitWeekFreqWin(title) {
    $("#WeekFreqWin").window({
        title: title,
        modal: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closed: false,
        closable: false
    });
}

function WeekFreqSureClick() {
    var selRows = $("#WeekTable").datagrid('getSelections');
    if (selRows.length == 0) {
        $.messager.popover({
            msg: '请选择星期！',
            type: 'error'
        });
        return false;
    }
    var weekArr = new Array();
    for (var i = 0; i < selRows.length; i++) {
        weekArr.push(selRows[i].id);
    }
    if ($("#InterventionFreq").length) {
        // 新增护理措施-执行频率选择周频次
        PageLogicObj.m_selWeek = weekArr.join("|");
        $("#WeekFreqWin").window("close");
    } else {
        // 护理措施修改执行频率
        var rows = $("#QuestionMeasureTable").datagrid("selectRow", PageLogicObj.m_QSMeasureEditIndex).datagrid("getSelected");
        var freqDR = rows.freqDR;
        var week = weekArr.join("|");
        var title = $("#WeekTable").datagrid("options").title;
        var defFreqName = title.split(" ")[0];
        var disposing = title.split(" ")[1];
        var Editors = $('#QuestionMeasureTable').datagrid('getEditors', PageLogicObj.m_QSMeasureEditIndex);
        if (Editors.length > 1) {
            var startDatetime = $(Editors[1].target).datetimebox('getValue');
        } else {
            var startDatetime = rec.id;
        }
        $('#QuestionMeasureTable').datagrid('updateRow', {
            index: PageLogicObj.m_QSMeasureEditIndex,
            row: {
                freqDR: freqDR,
                exectime: week.replace(/\|/g, "-") + " " + disposing, //week.replaceAll("|", "-")+" "+disposing,
                week: week,
                defFreqWeek: "",
                defFreqName: defFreqName,
                startDatetime: startDatetime
            }
        });
        $("#WeekFreqWin").window("close");
        PageLogicObj.m_QSMeasureEditIndex = "";
    }
}

function InitCancelReason() {
    $HUI.combobox("#CancelReason", {
        multiple: false,
        mode: "remote",
        method: "GET",
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'text',
        data: eval("(" + ServerObj.CancelReasonJson + ")")
    });
    if (ServerObj.CancelMustReason == "Y") {
        $("label[for='CancelReason']").addClass("clsRequired");
    } else {
        $("label[for='CancelReason']").removeClass("clsRequired");
    }
    $("#CancelReason").combobox("setValue", "").combobox("setText", "");
    $('#CancelReason').next('span').find('input').focus();
}

function InitStopReason() {
    $HUI.combobox("#StopReason", {
        multiple: false,
        mode: "remote",
        method: "GET",
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'text',
        data: eval("(" + ServerObj.QSStopReasonJson + ")")
    });
    if (ServerObj.StopMustReason == "Y") {
        $("label[for='StopReason']").addClass("clsRequired");
    } else {
        $("label[for='StopReason']").removeClass("clsRequired");
    }
    $("#StopReason").combobox("setValue", "").combobox("setText", "");
    $("#StopReason").next('span').find('input').focus();
}

function InitUnUseReason() {
    $HUI.combobox("#UnUseReason", {
        multiple: false,
        mode: "remote",
        method: "GET",
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'text',
        data: eval("(" + ServerObj.UnUseReasonJson + ")")
    });
    if (ServerObj.UnUserMustReason == "Y") {
        $("label[for='UnUseReason']").addClass("clsRequired");
    } else {
        $("label[for='UnUseReason']").removeClass("clsRequired");
    }
    $("#UnUseReason").combobox("setValue", "").combobox("setText", "");
    $("#UnUseReason").next('span').find('input').focus();
}

function GetStopReasonObj() {
    var StopReasonObj = {
        "successFlag": true,
        "StopReason": ""
    }
    var StopReason = $.trim($("#StopReason").combobox("getText"));
    $.extend(StopReasonObj, {
        StopReason: StopReason
    });
    if (ServerObj.StopMustReason == "Y") {
        if (!StopReason) {
            $.messager.popover({
                msg: "请选择/输入停止原因",
                type: 'error'
            });
            $('#StopReason').next('span').find('input').focus();
            $.extend(StopReasonObj, {
                successFlag: false
            });
            return StopReasonObj;
        }
    }
    return StopReasonObj;
}

function GetCancelReasonObj() {
    var CancelReasonObj = {
        "successFlag": true,
        "CancelReason": ""
    }
    var CancelReason = $.trim($("#CancelReason").combobox("getText"));
    $.extend(CancelReasonObj, {
        CancelReason: CancelReason
    });
    if (ServerObj.CancelMustReason == "Y") {
        if (!CancelReason) {
            $.messager.popover({
                msg: "请选择/输入撤销原因！",
                type: 'error'
            });
            $('#CancelReason').next('span').find('input').focus();
            $.extend(CancelReasonObj, {
                successFlag: false
            });
            return CancelReasonObj;
        }
    }
    return CancelReasonObj;
}

function GetUnUseReasonObj() {
    var UnUseReasonObj = {
        "successFlag": true,
        "UnUseReason": ""
    }
    var UnUseReason = $.trim($("#UnUseReason").combobox("getText"));
    $.extend(UnUseReasonObj, {
        UnUseReason: UnUseReason
    });
    if (ServerObj.UnUserMustReason == "Y") {
        if (!UnUseReason) {
            $.messager.popover({
                msg: "请选择/输入作废原因！",
                type: 'error'
            });
            $('#UnUseReason').next('span').find('input').focus();
            $.extend(UnUseReasonObj, {
                successFlag: false
            });
            return UnUseReasonObj;
        }
    }
    return UnUseReasonObj;
}

function QuestionTableMove(Type) {
    var row = $("#NurQuestionTable").datagrid('getSelected');
    if ((row==null)||(row.length == 0)) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    }
    var index = $("#NurQuestionTable").datagrid('getRowIndex', row);
    var data = $("#NurQuestionTable").datagrid('getData');
    var Len = data.rows.length;
    if (Type == "up") {
        if (index != 0) {
            var toup = data.rows[index];
            var todown = data.rows[index - 1];
            var TopNQRECSerialNo = toup.NQRECSerialNo;
            if (!TopNQRECSerialNo) {
                $.messager.popover({
                    msg: "优先级为空时请输入优先级进行调整！",
                    type: 'error'
                });
                return false;
            }
            var DwNQRECSerialNo = todown.NQRECSerialNo;
            if (!DwNQRECSerialNo) {
                $.messager.popover({
                    msg: "优先级为空时请输入优先级进行调整！",
                    type: 'error'
                });
                return false;
            }
            todown.NQRECSerialNo = TopNQRECSerialNo;
            toup.NQRECSerialNo = DwNQRECSerialNo;
            data.rows[index] = todown;
            data.rows[index - 1] = toup;
            $('#NurQuestionTable').datagrid('refreshRow', index);
            $('#NurQuestionTable').datagrid('refreshRow', index - 1).datagrid('selectRow', index - 1);
            UpdateSerialNO(todown.recordId, todown.NQRECSerialNo, todown.ARCIMRowid)
            UpdateSerialNO(toup.recordId, toup.NQRECSerialNo, toup.ARCIMRowid)
        }
    } else if (Type == "down") {
        if (index != Len - 1) {
            var todown = data.rows[index];
            var toup = data.rows[index + 1];
            var TopNQRECSerialNo = toup.NQRECSerialNo;
            if (!TopNQRECSerialNo) {
                $.messager.popover({
                    msg: "优先级为空时请输入优先级进行调整！",
                    type: 'error'
                });
                return false;
            }
            var DwNQRECSerialNo = todown.NQRECSerialNo;
            if (!DwNQRECSerialNo) {
                $.messager.popover({
                    msg: "优先级为空时请输入优先级进行调整！",
                    type: 'error'
                });
                return false;
            }
            todown.NQRECSerialNo = TopNQRECSerialNo;
            toup.NQRECSerialNo = DwNQRECSerialNo;
            data.rows[index + 1] = todown;
            data.rows[index] = toup;
            $('#NurQuestionTable').datagrid('refreshRow', index);
            $('#NurQuestionTable').datagrid('refreshRow', index + 1).datagrid('selectRow', index + 1);
            UpdateSerialNO(todown.recordId, todown.NQRECSerialNo)
            UpdateSerialNO(toup.recordId, toup.NQRECSerialNo)
        }
    }
}
///更新序列
function UpdateSerialNO(recordId, SerNo) {
    var rtn = tkMakeServerCall("Nur.NIS.Service.NursingPlan.QuestionRecord", "UpdateQuestionRecordSerialNo", recordId, SerNo)
    return rtn
}

function InitWeekTable(FreqName, FreqDisposing) {
    if (PageLogicObj.m_WeekTableGridData) {
        $('#WeekTable').datagrid("unselectAll");
    } else {
        PageLogicObj.m_WeekTableGridData = $("#WeekTable").datagrid({
            headerCls: 'panel-header-gray',
            title: FreqName + " " + FreqDisposing,
            height: 300,
            fit: true,
            border: false,
            striped: true,
            singleSelect: false,
            fitColumns: false,
            autoRowHeight: false,
            rownumbers: false,
            pagination: false,
            rownumbers: false,
            idField: 'id',
            columns: [
                [{
                        field: 'id',
                        checkbox: 'true'
                    },
                    {
                        field: 'text',
                        title: $g('星期'),
                        width: 520
                    }
                ]
            ],
            data: [{
                    "id": "1",
                    "text": $g("星期一")
                }, {
                    "id": "2",
                    "text": $g("星期二")
                }, {
                    "id": "3",
                    "text": $g("星期三")
                },
                {
                    "id": "4",
                    "text": $g("星期四")
                }, {
                    "id": "5",
                    "text": $g("星期五")
                }, {
                    "id": "6",
                    "text": $g("星期六")
                },
                {
                    "id": "7",
                    "text": $g("星期天")
                }
            ]
        });
    }
}


//更多、隐藏
function toggleExecInfo(){
	var Height=Math.round($("#QuestionTreeSearchPanel").height())+1;
	//if ($("#QuestionTypeKW").hasClass('expanded')){
	//	$("#QuestionTypeKW").removeClass('expanded');
	if ($('#moreBtn').linkbutton("options").text=="更多"){		
		$("#QuestionTypeKW").removeClass('expanded');	
		$("#moreBtn").linkbutton({ iconCls: 'icon-w-arrow-up'});
		$('#moreBtn').linkbutton({text:'隐藏'});
		$("#QuestionTypeKW").keywords({items: PageLogicObj.m_QuestionTypeKW});
		var Height=$("#QuestionTreePanel").height()+parseInt((Height-$("#QuestionTreeSearchPanel").height()));		
		//$("#moreBtn")[0].innerText="更多";
	    //$("#QuestionTypeKW").hide(); //#dashline
	    //setHeight("-39");
	}else{
		//$("#QuestionTypeKW").addClass('expanded');
		$("#moreBtn").linkbutton({ iconCls: 'icon-w-arrow-down'});
		$('#moreBtn').linkbutton({text:'更多'});		
		$("#QuestionTypeKW").keywords({items: PageLogicObj.m_QuestionTypeKWLight});
		var Height=$("#QuestionTreePanel").height()+parseInt((Height-$("#QuestionTreeSearchPanel").height()));
		//$("#moreBtn")[0].innerText="隐藏";
	    //$("#QuestionTypeKW").show(); //#dashline
	    //setHeight('39');	    
	}
	if(Height) $("#QuestionTreePanel").panel('resize',{height:Height});

	/*
		function setHeight(num){
	        var c=$("#OrdSearch-div");
	        var p=c.layout('panel', 'north');
	        var Height=parseInt(p.outerHeight())+parseInt(num);
	        p.panel('resize',{height:Height}); 
	        
			var p = c.layout('panel','center');	// get the center panel
			var Height = parseInt(p.outerHeight())-parseInt(num);
			p.panel('resize', {height:Height})
			if (ServerObj.PageShowFromWay=="ShowFromEmr"){
				if (+num>0) p.panel('resize',{top:124});
				else p.panel('resize',{top:84});
			}else{
				if (+num>0) p.panel('resize',{top:84});
				else p.panel('resize',{top:44});
			}
	    }
	 */
}
// 修改日期时间
function EditDateTime(type){
	var queids = new Array();
	var isAdvice= new Array();  //是否生成护嘱
	var row = $("#NurQuestionTable").datagrid('getSelections');
    if (row.length == 0) {
        $.messager.popover({
            msg: '请先选择护理问题！',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < row.length; i++){
	    queids.push(row[i].recordId);
	    isAdvice.push(row[i].isNQNursingAdvice);
	    if (row[i].source!="手动添加"){
		    $.messager.popover({
            msg: '请选择手动添加的护理问题！',
            type: 'error'
        });
        return false;
		}else if (row[i].result == "已解决") {
        $.messager.popover({
            msg: '该护理问题已解决！不能修改日期时间',
            type: 'error'
        });
        return false;
    	} else if (row[i].statusName == "已停止") {
        $.messager.popover({
            msg: '该护理问题已停止！不能修改日期时间',
            type: 'error'
        });
        return false;
    	} else if (row[i].statusName == "已作废") {
        $.messager.popover({
            msg: '该护理问题已作废！不能修改日期时间',
            type: 'error'
        });
        return false;
    	}else if (row[i].statusName == "已撤销") {
        	$.messager.popover({
            msg: '该护理问题已撤销！不能修改日期时间',
            type: 'error'
        });
        return false;
    	}		
	}
	var queidstr=queids.join("^");
	var isAdvicestr=isAdvice.join("^");
	if (type=="Question"){
		ShowEditDateTimeWin(type,queidstr,"")
	}else if(type=="QLRealate"){
		var qlrtrow = $("#QLRealateFactorTable").datagrid('getSelections');
		if (qlrtrow.length == 0) {
	        $.messager.popover({
	            msg: '请先选择非评估相关因素！',
	            type: 'error'
	        });
	        return false;
	    }else{
		    var count=0
		    for (var i = 0; i < qlrtrow.length; i++){
			    if (qlrtrow[i].statusName != "提交") {			    
			        $.messager.popover({
			            msg: '非提交的非评估相关因素不能修改时间',
			            type: 'error'
			        });		
			        count++;		        	            
			        return false;
		    	}		    		
			}
			if (count==0) ShowEditDateTimeWin(type,queidstr,"")
	    }
	}else if(type=="Target"){
		var targetrow = $("#QuestionTargetTable").datagrid('getSelections');
		if (targetrow.length == 0) {
	        $.messager.popover({
	            msg: '请先选择护理目标！',
	            type: 'error'
	        });
	        return false;
	    }else{
		    var count=0
		    for (var i = 0; i < targetrow.length; i++){
			    if (targetrow[i].goalStatus != "提交") {			    
			        $.messager.popover({
			            msg: '非提交的护理目标不能修改时间',
			            type: 'error'
			        });		
			        count++;		        	            
			        return false;
		    	}		    		
			}
			if (count==0) ShowEditDateTimeWin(type,queidstr,"")
	    }		
	}else if(type=="Intervention"){
		var interrow = $("#QuestionMeasureTable").datagrid('getSelections');
		if (interrow.length == 0) {
	        $.messager.popover({
	            msg: '请先选择护理措施！',
	            type: 'error'
	        });
	        return false;
	    }else{
		    var count=0
		    for (var i = 0; i < interrow.length; i++){
			    if (interrow[i].statusName != "提交") {			    
			        $.messager.popover({
			            msg: '非提交的护理措施不能修改时间',
			            type: 'error'
			        });		
			        count++;		        	            
			        return false;
		    	}		    		
			}
			if (count==0) ShowEditDateTimeWin(type,queidstr,isAdvicestr)
	    }		

	}
}
// 修改日期时间弹窗
function ShowEditDateTimeWin(type,queidstr,isAdvicestr){
	destroyDialog("QuestionDiag");
	var iconCls = "icon-w-edit";
	var Content = initDiagDivHtml("EditDataTime");
	if (type=="Question"){	  
	    createModalDialog("QuestionDiag", $g("修改日期时间"), 350, 165, iconCls, $g("确定"), Content, "SaveQuestionDateTime()");
		$.cm({
	        ClassName: "Nur.CommonInterface.Patient",
	        MethodName: "getInHospDateTime",
	        episodeID: ServerObj.EpisodeID,
	        dataType: "text"
	    },function (rtn) {	    
		    var InHospDateTime=rtn;
		    $('#LimitEditDataTimeBox').datetimebox('setValue',InHospDateTime);	    
		});	
		$('#tr-LimitEditDataTime').hide();			
		//$('#LimitEditDataTimeBox').next().css({ visibility:'hidden' });
	}else if (type=="QLRealate"){		
	    createModalDialog("QuestionDiag", $g("修改日期时间"), 350, 165, iconCls, $g("确定"), Content, "SaveQLRealateDateTime(\""+queidstr+"\")");
		$('#tr-LimitEditDataTime').hide();
	}else if (type=="Target"){		
	    createModalDialog("QuestionDiag", $g("修改日期时间"), 350, 165, iconCls, $g("确定"), Content, "SaveTargetDateTime(\""+queidstr+"\")");
		$('#tr-LimitEditDataTime').hide();
	}else if (type=="Intervention"){		
	    createModalDialog("QuestionDiag", $g("修改日期时间"), 350, 165, iconCls, $g("确定"), Content, "SaveInterventionDateTime(\""+queidstr+"\",\""+isAdvicestr+"\")");
		$('#tr-LimitEditDataTime').hide();
	}
}
// 保存护理问题创建时间
function SaveQuestionDateTime(){
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	var LimitEditDataTime=$('#LimitEditDataTimeBox').datetimebox('getValue');
	var now = new Date();
	//var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	var nowDateTime=now.getFullYear()+"-"+('0' + (now.getMonth() + 1)).slice(-2)+"-"+('0' + now.getDate()).slice(-2)+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	
	//时间调整范围介于系统当前时间与患者入科时间之间，如果修改时间超出，则给予消息反馈
	if(LimitEditDataTime==""){
		$.messager.popover({
            msg: '未能获取入院时间！',
            type: 'error'
        });
		return false;
	}
	if(!CompareDateFromCreatToNow(datetime,LimitEditDataTime,nowDateTime)){
		$.messager.popover({
            msg: '修改时间超出患者入院时间或系统当前时间！',
            type: 'error'
        });
        return false;
	}
	var row = $("#NurQuestionTable").datagrid('getSelections');
	var rowids = new Array();
	for (var i = 0; i < row.length; i++){
		rowids.push(row[i].recordId)	
	}
	var rowidstr=rowids.join("^");
	    $.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.QuestionRecord",
        MethodName: "EditQuestionRecordCreatDateTime",
        RecordRowids: rowidstr,
        Date: date,
        Time: time,
    }, function (rtn) {
        if (rtn == 0) {
            $("#QuestionDiag").window("close");
            $("#NurQuestionTable").datagrid('load');
        }  else if(rtn == 1) {
            $.messager.popover({
                msg: "保存失败！修改时间大于当前时间" ,
                type: 'error'
            });
        }else {
            $.messager.popover({
                msg: "保存失败！" + rtn,
                type: 'error'
            });
        }
    })

}
// 保存非评估相关因素创建时间
function SaveQLRealateDateTime(queidstr){
	var row = $("#QLRealateFactorTable").datagrid('getSelections');
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	// 限制非评估相关因素修改时间：当前时间2天内
	if(!isBeforeTwoDays(datetime)) {
        $.messager.popover({
            msg: "修改时间范围是当前时间2天以内 " ,
            type: 'error'
        });
        return false;
    }
	var rowids = new Array();
	for (var i=0;i<queidstr.split('^').length;i++){
		for (var j = 0; j < row.length; j++){
			rowids.push(queidstr.split('^')[i]+"||"+row[j].recordID)
		}
	}
	var rowidstr=rowids.join("^");
	if ((date=="")||(time==""))
	{
	    $.messager.popover({
            msg: "请选择日期与时间" ,
            type: 'error'
        });
        return false;
	}
	$.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "EditQLRealateRecordCreatDateTime",
        RecordRowids: rowidstr,
        Date: date,
        Time: time,
    }, function (rtn) {
        if (rtn == 0) {
            $("#QuestionDiag").window("close");
            $("#QLRealateFactorTable").datagrid('load');
        }  else if(rtn == 1) {
            $.messager.popover({
                msg: "保存失败！修改时间大于当前时间" ,
                type: 'error'
            });
        }else {
            $.messager.popover({
                msg: "保存失败！" + rtn,
                type: 'error'
            });
        }
    })
}
// 保存护理目标创建时间
function SaveTargetDateTime(queidstr){
	var row = $("#QuestionTargetTable").datagrid('getSelections');
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	// 限制护理目标修改时间：当前时间2天内
	if(!isBeforeTwoDays(datetime)) {
        $.messager.popover({
            msg: "修改时间范围是当前时间2天以内 " ,
            type: 'error'
        });
        return false;
    }
	var rowids = new Array();
	for (var i=0;i<queidstr.split('^').length;i++){
		for (var j = 0; j < row.length; j++){
			rowids.push(queidstr.split('^')[i]+"||"+row[j].recordID)
		}
	}
	var rowidstr=rowids.join("^");
	if ((date=="")||(time==""))
	{
	    $.messager.popover({
            msg: "请选择日期与时间" ,
            type: 'error'
        });
        return false;
	}
	$.cm({
        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
        MethodName: "EditTargetRecordCreatDateTime",
        RecordRowids: rowidstr,
        Date: date,
        Time: time,
    }, function (rtn) {
        if (rtn == 0) {
            $("#QuestionDiag").window("close");
            $("#QuestionTargetTable").datagrid('load');
        }  else if(rtn == 1) {
            $.messager.popover({
                msg: "保存失败！修改时间大于当前时间" ,
                type: 'error'
            });
        }else {
            $.messager.popover({
                msg: "保存失败！" + rtn,
                type: 'error'
            });
        }
    })
}
// 保存护理措施创建时间
function SaveInterventionDateTime(queidstr,isAdvicestr){
	var startDateTime = $('#EditDataTimeBox').datetimebox('getValue');
	// 限制护理措施修改时间：当前时间2天内
	if(!isBeforeTwoDays(startDateTime)) {
        $.messager.popover({
            msg: "修改时间范围是当前时间2天以内 " ,
            type: 'error'
        });
        return false;
    }
	for (var i=0;i<queidstr.split('^').length;i++){
		var planID=queidstr.split('^')[i].split("||")[0];
		var questionSub=queidstr.split('^')[i].split("||")[1];
		var isNQNursingAdvice=isAdvicestr.split('^')[i]
		// 1、撤销提交护理措施（清理相关任务，防止因修改措施时间导致任务异常）
		var QuestionMeasureTableSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
	    var revokeintervDRRArr = new Array();
	    // 需求 2922707
	    var submitintervDRRArr = new Array();
	    for (var i = 0; i < QuestionMeasureTableSelRows.length; i++) {
		    // 已经判断措施状态只能为"提交"，此处不需要再次判断
	        // 提交措施数组
	        //week.replace(/\|/g, "-")
	        var exectime = QuestionMeasureTableSelRows[i].exectime;
	        if (isWeek(exectime.split(" ")[0])) {
		        var week = exectime.split(" ")[0].replace(/\-/g, "|")
		    }
	        else{
		        var week =""
		    }
		    var defFreqWeek = QuestionMeasureTableSelRows[i].defFreqWeek;
		    if (!defFreqWeek) defFreqWeek = "";
		    if (!week) week = defFreqWeek;
    		// 对选择日期进行校验
	        if (startDateTime) {
	            var startDate = startDateTime.split(" ")[0];
	            var startTime = startDateTime.split(" ")[1];
	            if (dtseparator == "/") {
	                var tmpdate = startDate.split("/")[2] + "-" + startDate.split("/")[1] + "-" + startDate.split("/")[0]
	                var tmpdate1 = new Date(tmpdate.replace("-", "/").replace("-", "/"));
	            } else {
	                var tmpdate = startDate;
	                var tmpdate1 = new Date(startDate.replace("-", "/").replace("-", "/"));
	            }
	            var CurDate = new Date();
	            var end = new Date(CurDate.getFullYear() + "/" + (CurDate.getMonth() + 1) + '/' + CurDate.getDate());
	            /*
	            if (tmpdate1 < end) {
	                $.messager.popover({
	                    msg: "措施日期应大于等于当天：" + myformatter(end) + "！",
	                    type: 'error'
	                });
	                return false;
	            }
	            */
	            if (!IsValidTime(startTime)) {
	                $.messager.popover({
	                    msg: "措施开始时间格式不正确! 时:分,如11:05",
	                    type: 'error'
	                });
	                return false;
	            }
	            //var CurTime=GetCurTime("N");
	            var timeStr = tmpdate + " " + startTime;			            
	            /*
	            if (+new Date() - 60000 > +new Date(timeStr)) {
	                //if (parseInt(startTime.split(":")[1]) < parseInt(CurTime.split(":")[1])) {
	                $.messager.popover({
	                    msg: "措施开始时间应大于当前时间！",
	                    type: 'error'
	                });
	                return false;
	            }
	            */
	        }
    		var freqDR = QuestionMeasureTableSelRows[i].freqDR;
	        if (!freqDR) freqDR = QuestionMeasureTableSelRows[i].defFreq;
	        if ((isNQNursingAdvice == "Y") && (!freqDR)) {
	            var intervName = QuestionMeasureTableSelRows[i].intervName;
	            $.messager.popover({
	                msg: "<font color=red>" + intervName + "</font>需要选择执行频率！",
	                type: 'error'
	            });
	            return false;
	        }
		   	var submitobj={
	            intervdr: QuestionMeasureTableSelRows[i].intervDR,
	            freqdr: freqDR,
	            rowID: '',     // insert
	            startDateTime: startDateTime,
	            week: week
		    };
	        submitintervDRRArr.push(submitobj);
	        
	        // 撤销措施数组
			var recordID = QuestionMeasureTableSelRows[i].recordID;
	        var revokeobj = {
	            intervdr: QuestionMeasureTableSelRows[i].intervDR,
	            rowID: QuestionMeasureTableSelRows[i].rowID
	        };
	        revokeintervDRRArr.push(revokeobj);
		}
	    if (revokeintervDRRArr.length > 0) {
		    var rtnResult = $m({
		        ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
		        MethodName: "CancelCommitIntervRecord",
		        planID: planID,
		        questionSub: questionSub,
		        optID: session['LOGON.USERID'],
		        locDr: session['LOGON.CTLOCID'],
		        wardDr: session['LOGON.WARDID'],
		        isNQNursingAdvice: isNQNursingAdvice,
		        intervArr: JSON.stringify(revokeintervDRRArr)
		    }, false);
		    if (rtnResult != "0") {
		            $.messager.popover({
		                msg: '修改护理措施时间失败：' + rtnResult,
		                type: 'error'
		            });
		            return false;
		    }
		    else{
			    // 2、如果撤销成功，则执行提交护理措施(更新日期时间)
				if (submitintervDRRArr.length > 0) {
			        var rtnJson = $.cm({
			            ClassName: "Nur.NIS.Service.NursingPlan.GoalInterventionRecord",
			            MethodName: "SaveIntervRecord",
			            planID: planID,
			            questionSub: questionSub,
			            optID: session['LOGON.USERID'],
			            locDr: session['LOGON.CTLOCID'],
			            wardDr: session['LOGON.WARDID'],
			            isNQNursingAdvice: isNQNursingAdvice,
			            intervArr: JSON.stringify(submitintervDRRArr),
			            isEditDateTime:"Y"    // Y：护理措施的开始时间、创建时间都等于要修改的时间  非Y：只有开始时间等于要修改的时间，创建时间为系统时间
			        }, false)
			        if (rtnJson.errcode < 0) {
			            $.messager.popover({
			                msg: '提交护理措施失败！' + rtnJson.errinfo,
			                type: 'error'
			            });
			            return false;
			        }
			    }
			    $.messager.popover({
			        msg: '提交成功！',
			        type: 'success'
			    });
			    PageLogicObj.m_QSGridSelRecordIdAfterLoad = queidstr;
			    $("#QuestionDiag").window("close");
			    $("#NurQuestionTable").datagrid('load');
			}
	    }
    }
}
// 判断日期在当前日期前2天内
function isBeforeTwoDays(date) {
    var now = new Date();
    var nowTime = now.getTime();
    var twoDays = 2 * 24 * 60 * 60 * 1000;
    var twoDaysBefore = new Date(nowTime - twoDays);
    var twoDaysBeforeTime = twoDaysBefore.getTime();
    //var date = new Date(date);
    var date = parseDate(date);
    var dateTime = date.getTime();
    if ((dateTime >= twoDaysBeforeTime) && (dateTime <= nowTime)) {
        return true;
    } else {
        return false;
    }
}
// 星期判断
function isWeek(value) {
    var reg = /^([1-7]{1})(-[1-7]{1})*$/;
    return reg.test(value);
}
function toopTip(idOrClass,position,showText){
    $(idOrClass).tooltip({
        position: position,
        content: '<span style="color:#6A6A6A">' + showText + '</span>',
        onShow: function(){
            $(this).tooltip('tip').css({
                backgroundColor: '#ffffff',
                borderColor: '#ff8c40'
            });
        }
    });
}
// MWToken 改造
function getIframeUrl(url){
	if ('undefined'!==typeof websys_getMWToken){
		if(url.indexOf("?")==-1){
			url = url+"?MWToken="+websys_getMWToken()
		}else{
			url = url+"&MWToken="+websys_getMWToken()
		}
	}
	return url
}
function InitNursingRecordTemplateJson(){
	PageLogicObj.m_NursingRecordTemplateJson=$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.EMRLinkItem",
		QueryName:"GetEMRLinkItemList",
		hospDR:session['LOGON.HOSPID'],
	},false);
}
// 初始化转入护理记录单
function InitNursingRecordTemplate(){
	InitNursingRecordTemplateJson();
	$('#NursingRecordTemplate').combogrid({
		mode: "local",
		valueField:'nurseRecordEntryTplId',
		textField:'nurseRecordEntryTpl',
		mode: "local",
		multiple:false,
		data:PageLogicObj.m_NursingRecordTemplateJson.rows,		
		columns:[[
			{field:'nurseRecordEntryTpl',title:'表单录入模板',width:206,sortable:true},
			{field:'locsName',title:'生效科室',width:150,sortable:true}
        ]],
	});
}
function reverseChild(parentstr,childstr){
	 var parent=$(parentstr);
     var children = parent.find(childstr).prevObject.toArray().reverse();
     $(children).each(function(index,child){
	     $(child).insertBefore(parent.find(child).eq(index));
	 });

}
