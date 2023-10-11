/**
 * @author songchunli
 * HISUI ����ƻ��ƶ���js
 * NursePlanMake.js
 */
var PageLogicObj = {
    m_NurQuestionTableGrid: "",
    m_QuestionTargetTableGrid: "", // ����Ŀ��table
    m_QuestionMeasureTableGrid: "", // �����ʩtable
    m_QLRealateFactorTableGrid: "", // ���������table
    m_QuestionTypeKW: "",
    m_QuestionTypeKWLight:"",
    m_SelQuestionObj: {
        planID: "",
        questSub: "",
        template: "",
        statusName: $g("δֹͣ"),
        isNQNursingAdvice: "N",
        queName:""
    }, //�����������ѡ���ж���,���ƻ�ִ���ڱ���ѯ��
    m_QSGridSelRecordIdAfterLoad: "", //�����б���������ݳɹ�����Ҫѡ���е�ID
    m_QSMeasureEditIndex: "",
    m_selWeek: "", //���������ʩʱ����Ƶ��ѡ������ڴ�,�����|�ָ�.�洢λ�� CF.NUR.NIS.Intervention���ֶ�NIVT_DefaultFreqWeek
    m_WeekTableGridData: "",
	QuestionTypeShowNum:14,
	ifMultiple:"",  //����2744200 �Ƿ��ѡ���������Ϊ��   
	//LeaderGROUPID:"@25@52@112@114@", //ָ������ʿ������ȫ��ID
	m_NursingRecordTemplateJson:[], //�����¼��ͷ���������б�
}
$(function () {
    Init();
    InitEvent();
    if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//�Ų�
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
	// ��������ƻ����� 2021.8.31
    $("#BQuestionPlanCancel").click(NursePlanCancelClick);
    // ��������ƻ��ύ
    $("#BQuestionPlanSumit").click(QuestionPlanSumitClick);
    // �����������Ᵽ��
    $("#BQuestionSave").click(BQuestionSaveClick);
    // �����������ⵯ��-ȡ����ť�¼�
    $("#BQuestionWinClose").click(function () {
        $("#QuestionAddWin").window("close");
    });
    // �����б��ѯ��ť�¼�
    /*
    $("#BQuestionFind").click(function () {
        $('#NurQuestionTable').datagrid('reload');
    });    
    */
    $('#ThisWardSearch').parent().hide();   //���ؽ����ı���������ƻ���ѡ��
    // ����ؼ��ֻس�����
    $("#QuestionKeyWord").keydown(QuestionKeyWordOnKeyDown);
    if (ServerObj.versionPatientListNew!=1){
	    // �����������ǼǺš����ż���
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
    // ��ʼ��ҳ��Ĭ������ ���ڷ�Χ������������
    SetPageDefaultData();
    // ��ʼ�������б��ѯ����
    InitQSCombobox();
    // ��ʼ�������б���
    if(ServerObj.versionPatientListNew!="1"){
	    if (ServerObj.IsShowPatList == "Y"){
	        // �������Ȩ�޿���ʱ��Ĭ����ʾ����
	        if (ServerObj.groupFlag == "Y") {
	            $("#switchBtn").addClass("ant-switch-checked");
	            $($(".switch label")[1]).addClass("current");
	        }
	        //InitPatientTree();
	        InitPatientTreeOld();
	    }
	}
    // ��ʼ��������Ϣ��
    if (ServerObj.IsShowPatInfoBannner == "Y") {
	    SetPatientBarInfo(ServerObj.EpisodeID); 
        $(".PatInfoItem").children().eq(0).css({'left':"0px"});//����3152987
    } else {
        ResetDomSize();
    }
    // ��ʼ������������Tabel
    InitNurQuestionTableGrid();
    if(ServerObj.versionPatientListNew!="1"){}
    else{
	    $('#main').layout('panel', 'west').panel({
		  onExpand: ResetDomSize,
		  onCollapse: ResetDomSize
	  });
    }
    // ����/����
    if (PageLogicObj.m_QuestionTypeKWLight){
	    alert("��ʾ");             
	} 
	$("#moreBtn").click(toggleExecInfo);

}
// ��ѯ
function QuestionFind(flag){	
    // ���$("#ThisWardSearch")�Ƿ����
    if ($('#ThisWardSearch').length > 0) {	
    	var searchcheckbox = document.getElementById('ThisWardSearch');    
        // ��hisui-checkbox $('#ThisWardSearch')ȡ����ѡ
        if (flag=="1") searchcheckbox.checked = true; // ��������ѯ
        else searchcheckbox.checked = false;			   // ȫ����ѯ        
    } 
    // ���¼��ر��
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
    	$("#days").html($g("�ƻ�����������")+ServerObj.days+$g(" ��"));
    }
    */
}

function InitQSCombobox() {
    // ����״̬ ��0��δֹͣ 1����ֹͣ 2���ѳ��� 3�������ϣ�
    var cbox = $HUI.combobox("#QSearchStatus", {
        valueField: 'value',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: false,
        data: eval("(" + ServerObj.QSearchStatusJson + ")"),
        loadFilter: function (data) {
            var newData = new Array();            
            for (var i = 0; i < data.length; i++) {
	           	//����2760059 
	            //ֹͣ���̣�״̬������δֹͣ����ֹͣ�������ϣ�����״̬��������ʾ 
                //�������̣�״̬��������ʾ������״̬������δ���ۡ������ۣ�
                /*
	            if (ServerObj.IsOpenNurEvaluate == "Y"){		            
		            if ((data[i].text == "δֹͣ")||(data[i].text == "��ֹͣ"))
	        		continue;
		        }
		        //����2592286�������ѳ���״̬
                if (data[i].text == "�ѳ���") {
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
    //����Ĭ�ϲ�ѯ״̬ Լ��������ƻ��ƶ��������У��������⡰����״̬��Ĭ��ɸѡ�����Ĺ�ѡ��
    var QSearchStatus=ServerObj.QPCCNursePlanSearchStatus.split('^');
	for (var j = 0; j < QSearchStatus.length; j++) {
	    if(QSearchStatus[j]!=""){
			$("#QSearchStatus").combobox('select',QSearchStatus[j].toString())
	    }	                
	}
    
    // ����״̬ ��������״̬(0��δ���� 1��������)
    var cbox = $HUI.combobox("#QSearchEvaluateStatus", {
        rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
    //����Ĭ�ϲ�ѯ״̬Լ��������ƻ��ƶ��������У��������⡰����״̬��Ĭ��ɸѡ�����Ĺ�ѡ��
    var QSearchEvaluateStatus=ServerObj.QPCCNurEvaluateSearchStatus.split('^');
	for (var j = 0; j < QSearchEvaluateStatus.length; j++) {
	    if(QSearchEvaluateStatus[j]!=""){
			$("#QSearchEvaluateStatus").combobox('select',QSearchEvaluateStatus[j].toString())
	    }	                
	}
    // ������Դ
    var cbox = $HUI.combobox("#QSearchDataSource", {
        rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
		    	//������
		    	$.messager.popover({
	                    msg: "�˻��߻�����Ϊ��[" + data.desc + "  ]�����뻤������",
	                    type: 'alert'
	                });
	    	}	    	
		})
	}
}
function InitPatientTreeOld() {
    $HUI.tree('#patientTree', {
        loader: function (param, success, error) {
            // HIS 8.5 �汾
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
                // ���ݵͰ汾HIS -- ȡ�����������б�ӿ� HIS 8.4����ǰ
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
                // ���ݵͰ汾HIS -- ȡ�����������б�ӿ� HIS 8.2����ǰ
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
			PageLogicObj.ifMultiple=""    //����2744200 �л�������Ҫ��ifMultiple��Ϊ��
            patNode = node;
            if (!!node.episodeID) {
                var Args = {};
                Args.adm = node.id;
                xhrRefresh(Args);
                //2022.01.20 ��Ʒ��Ҫ�󲻽���ͷ�˵������л�
                                
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
// �ֲ�ˢ����
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
                statusName: $g("δֹͣ"),
                isNQNursingAdvice: "N",
                queName:""
            }
        });
        // ���ּ��ر������
        ReloadDataGrid();
        $("#QuestionMakePanel").panel("setTitle", $g("�ƻ��ƶ�"));        
        SetNurPalnBtnStatus();
        SetNurPalnBtnCstatus();
        SetNurPalnBtnPermission(); //2022-10-19 add
        
    } catch (e) {
        //�˷����ֲ�ˢ�º�ҳ���ʼ��ʱ�����,���������ܵ��´������Ų�,��Ӵ�����ʾ����Ϣ
        $.messager.alert("��ʾ", "����IxhrRefresh�����쳣,������Ϣ��" + e.message);
        return false;
    }
}

function ReloadDataGrid() {
    //���¼��ػ��������б�
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
//��������ѡ/ȡ����ѡʱ����
function patientTreeCheckChangeHandle()
{
	PageLogicObj.ifMultiple=""    // ����2744200 �л�������Ҫ��ifMultiple��Ϊ��
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
        // 2023-02-21 add ������ţ�3147421 ���ӡ��ƻ����û������͡�
        PopPatientCareLevel(node.episodeID);        
	}	
}
// ���ػ�����Ϣ�����ݣ�������
function SetPatientBarInfo(EpisodeID) {
	if (ServerObj.versionIsInfoBarNew=="1"){
		//2023.02.28 ҽ��վ���ڲ�����Ϣ���ĵ����޸�
		$(".ctcAEPatBar").css('height', 40 + 'px');
		// �޸����ȵ�һ�����߲������������������������Ļ�����������ʵ�ʻ��߲�һ�µ����
		//var $container=$('.pat-info-container');
		//$container.popover('destroy');
		InitPatInfoBanner(EpisodeID);	    
		ResetDomSize();

	}else{
		if (ServerObj.versionIsInfoBarOld=="1"){
			//HIS �汾8.2������8.5
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
		        $(".PatInfoItem").html($g("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�"));
		    }
		}else{
			//HIS �汾8.2 ����ƻ��ƶ�ҳ���޻�����Ϣ
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
    $("#wardPatientCondition").css('margin-top','0px'); //����3152987
}
/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":ServerObj.EpisodeID, "PPFlag":"N"},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
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
	    // �����б�߶�
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
			if (ele!=null){      //�޸�Bug
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
		// ������Ϣ���·�����߶�
		$("#QuestionMainPanel").css('height', innerHeight - PatBarHeight );		
		// ��������panel
	    $("#QuestionPanel").panel('resize', {
	        height: parseInt((innerHeight - PatBarHeight) * 0.5),   
	        width:'100%'
	    });
	    //��ѯ���panel
	    //var SearchTableHeight = document.getElementsByClassName("search-table")[0].clientHeight;
	    $("#SearchTablePanel").panel('resize', {
	        width:'100%',
	        height :SearchTableHeight,
	    });
	    
		//����������
		$("#QuestionPanel-table").css('height', $("#QuestionPanel").height()-SearchTableHeight)
		$("#QuestionPanel-table").css('width', $("#QuestionPanel").width()-5);
		/*
		if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//�Ų�
			$("#NurQuestionTable").datagrid("resize",{  
		            height : $("#QuestionPanel").height()-SearchTableHeight,
		            width : $("#QuestionPanel").width()-5
		    });
	   	}else if((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)){//����
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
		    // �ƻ��ƶ��߶�
		    $("#QuestionMakePanel").panel('resize', {
		        height: innerHeight - $("#QuestionPanel").height() - PatBarHeight - 40
		    });
		}else{
		    // �ƻ��ƶ��߶�
		    $("#QuestionMakePanel").panel('resize', {
		        height: innerHeight - $("#QuestionPanel").height() - $(".ctcAEPatBar .PatInfoItem").height() - 56 //-39
		    });
		}
    }else{
	    var PatBarHeight= 0;
	    var SearchTableHeight = $("#SearchTablePanel").outerHeight();
		// ������Ϣ���·�����߶�
		$("#QuestionMainPanel").css('margin-left', 0 );	
		$("#QuestionMainPanel").css('height', innerHeight - PatBarHeight );		
		// ��������panel
	    $("#QuestionPanel").panel('resize', {
	        height: parseInt((innerHeight - PatBarHeight) * 0.5),   
	        width:'100%'
	    });
	    //��ѯ���panel
	    //var SearchTableHeight = document.getElementsByClassName("search-table")[0].clientHeight;
	    $("#SearchTablePanel").panel('resize', {
	        width:'100%',
	        height :SearchTableHeight,
	    });
		//����������
		$("#QuestionPanel-table").css('height', $("#QuestionPanel").height()-SearchTableHeight)
		$("#QuestionPanel-table").css('width', $("#QuestionPanel").width()-5);
		$("#NurQuestionTable").datagrid("resize",{  
	            height : $("#QuestionPanel").height()-SearchTableHeight,
	            width : $("#QuestionPanel").width()-5
	    });
	    if (ServerObj.versionIsInfoBarNew=="1"){
		    // �ƻ��ƶ��߶�
		    $("#QuestionMakePanel").panel('resize', {
		        //height: innerHeight - $("#QuestionPanel").height() - PatBarHeight-76
		        height: innerHeight - $("#QuestionPanel").parent().height() - PatBarHeight -$("#split-div").height()
		    });
		}else{
		    // �ƻ��ƶ��߶�
		    $("#QuestionMakePanel").panel('resize', {
		        height: innerHeight - $("#QuestionPanel").parent().height() - $(".ctcAEPatBar .PatInfoItem").height()-$("#split-div").height()
		    });
		}	    
	}
	if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//�Ų�
	    // �ƻ��ƶ�panel���������жϸ߶�
	    $("#QLRealateFactorPanel,#QuestionTargetPanel,#QuestionMeasurePanel").panel('resize', {
		    //height: $("#QuestionMakePanel").height() - 4   //x���޹�����
	        height: $("#QuestionMakePanel").height() - 17	 //x���й�����
	    }); 
   	}else if((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)){//����
	    $("#QLRealateFactorPanel,#QuestionTargetPanel,#QuestionMeasurePanel").panel('resize', {
		    //height: $("#QuestionMakePanel").height() - 4   //x���޹�����
	        height: $("#QuestionMakePanel").height() - 12	 //x���й�����
	    });
	}else{
	    $("#QLRealateFactorPanel,#QuestionTargetPanel,#QuestionMeasurePanel").panel('resize', {
		    //height: $("#QuestionMakePanel").height() - 4   //x���޹�����
	        height: $("#QuestionMakePanel").height() - 17	 //x���й�����
	    });
	}
    setTimeout(function () {
        // �ƻ��ƶ�panel��������panel�Ŀ��
        ResetQuestionMakePanelWidth();
    },200);
}



// �����ʩ���� 2021.8.31 add
function NursePlanCancelClick() {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    if (QueSelRows.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    } else if (QueSelRows.length > 1) {
        $.messager.popover({
            msg: '��ѡ��һ���������⣡',
            type: 'error'
        });
        return false;
    }
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questionSub = recordId.split("||")[1];
    var isNQNursingAdvice = QueSelRows[0].isNQNursingAdvice;

    // �����������������
    if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
        var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
        var sumitfactorDRRArr = new Array();
        for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
            var statusName = QLRealateFactorSelRows[i].statusName;
            if (statusName == "����") {
                $.messager.popover({
                    msg: '�����ϵķ�����������ؼ�¼���ܳ�����',
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
                    msg: '�������������ʧ�ܣ�' + rtnResult,
                    type: 'error'
                });
                return false;
            }
        }
    }

    // ��������Ŀ��
    if (ServerObj.IsOpenQuestionTarget == "Y") {
        var QuestionTargetTableSelRows = $("#QuestionTargetTable").datagrid("getSelections");
        var sumitgoalDRRArr = new Array();
        for (var i = 0; i < QuestionTargetTableSelRows.length; i++) {
            var goalStatus = QuestionTargetTableSelRows[i].goalStatus;
            if (goalStatus == $g("����")) {
                $.messager.popover({
                    msg: '�����ϵĻ���Ŀ�겻�ܳ�����',
                    type: 'error'
                });
                return false;
            }
            var recordID = QuestionTargetTableSelRows[i].recordID;
            if (!recordID || recordID == "") {
                $.messager.popover({
                    msg: 'δ�ύ�Ļ���Ŀ�겻�ܳ�����',
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
                    msg: '����Ŀ��ʧ�ܣ�' + rtnResult,
                    type: 'error'
                });
                return false;
            }
        }
    }

    // ���������ʩ
    var QuestionMeasureTableSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
    var sumitintervDRRArr = new Array();
    for (var i = 0; i < QuestionMeasureTableSelRows.length; i++) {
        var statusName = QuestionMeasureTableSelRows[i].statusName;
        if (statusName == $g("ֹͣ")) {
            $.messager.popover({
                msg: "ֹͣ״̬�Ļ����ʩ���ܳ�����",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("����")) {
            $.messager.popover({
                msg: "����״̬�Ļ����ʩ���ܳ�����",
                type: 'error'
            });
            return false;
        } else if (!statusName || statusName == "") {
            $.messager.popover({
                msg: "δ�ύ�Ļ����ʩ���ܳ�����",
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
                msg: '������ʩʧ�ܣ�' + rtnResult,
                type: 'error'
            });
            return false;
        }

        $.messager.popover({
            msg: '�����ɹ���',
            type: 'success'
        });
    }
    PageLogicObj.m_QSGridSelRecordIdAfterLoad = recordId;
    $("#NurQuestionTable").datagrid('load');
}

// ��������ƻ��ύ
function QuestionPlanSumitClick() {
    var QueSelRows = $("#NurQuestionTable").datagrid("getSelections");
    if (QueSelRows.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    } else if (QueSelRows.length > 1) {
        $.messager.popover({
            msg: '��ѡ��һ���������⣡',
            type: 'error'
        });
        return false;
    }else if ((QueSelRows[0].statusName ==$g("��ֹͣ"))||(QueSelRows[0].cstatus ==$g("������"))) {
        $.messager.popover({
            msg: '����������ֹͣ/�����ۣ�',
            type: 'error'
        });
        return false;
    }
    var recordId = QueSelRows[0].recordId;
    var planID = recordId.split("||")[0];
    var questionSub = recordId.split("||")[1];
    var isNQNursingAdvice = QueSelRows[0].isNQNursingAdvice;
    // �ύ�������������
    if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
        var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
        var sumitfactorDRRArr = new Array();
        for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
            var statusName = QLRealateFactorSelRows[i].statusName;
            if (statusName == "����") {
                $.messager.popover({
                    msg: '�����ϵķ�����������ؼ�¼�����ύ��',
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
                    msg: '�ύ����������������ʧ�ܣ�' + rtnJson.errinfo,
                    type: 'error'
                });
                return false;
            }
        }
    }
    // �ύ����Ŀ��
    if (ServerObj.IsOpenQuestionTarget == "Y") {
        var QuestionTargetTableSelRows = $("#QuestionTargetTable").datagrid("getSelections");
        var sumitgoalDRRArr = new Array();
        for (var i = 0; i < QuestionTargetTableSelRows.length; i++) {
            var goalStatus = QuestionTargetTableSelRows[i].goalStatus;
            if (goalStatus == $g("����")) {
                $.messager.popover({
                    msg: '�����ϵĻ���Ŀ���¼�����ύ��',
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
                    msg: '�ύ����Ŀ��ʧ�ܣ�' + rtnJson,
                    type: 'error'
                });
                return false;
            }
        }
    }
    // �ύ�����ʩ
    var QuestionMeasureTableSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
    var sumitintervDRRArr = new Array();
    for (var i = 0; i < QuestionMeasureTableSelRows.length; i++) {
        var statusName = QuestionMeasureTableSelRows[i].statusName;
        if (statusName == $g("ֹͣ")) {
            $.messager.popover({
                msg: "ֹͣ״̬�Ļ����ʩ�����ύ��",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("����")) {
            $.messager.popover({
                msg: "����״̬�Ļ����ʩ�����ύ��",
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
                    msg: "��ʩ����Ӧ���ڵ��ڵ��죺" + myformatter(end) + "��",
                    type: 'error'
                });
                return false;
            }
            if (!IsValidTime(startTime)) {
                $.messager.popover({
                    msg: "��ʩ��ʼʱ���ʽ����ȷ! ʱ:��,��11:05",
                    type: 'error'
                });
                return false;
            }
            //var CurTime=GetCurTime("N");
            var timeStr = tmpdate + " " + startTime;
            if (+new Date() - 60000 > +new Date(timeStr)) {
                //if (parseInt(startTime.split(":")[1]) < parseInt(CurTime.split(":")[1])) {
                $.messager.popover({
                    msg: "��ʩ��ʼʱ��Ӧ���ڵ�ǰʱ�䣡",
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
                msg: "<font color=red>" + intervName + "</font>��Ҫѡ��ִ��Ƶ�ʣ�",
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
                msg: '�ύ�����ʩʧ�ܣ�' + rtnJson.errinfo,
                type: 'error'
            });
            return false;
        }
    }
    $.messager.popover({
        msg: '�ύ�ɹ���',
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
//ת�뻤���¼
//------Start----------
function showTransferRecordWin(Type,TransferDesc,recordIds){
	var errmsg=""
	destroyDialog("QuestionDiag");
	var Content=initDiagDivHtml("transferRecord");
    var iconCls="icon-w-edit";
	createModalDialog("QuestionDiag",$g("ת�뻤���¼"), 747, 465,iconCls,$g("ȷ��"),Content,'transferRecord("'+Type+'","'+recordIds+'")');
	InitPatIfoBar(ServerObj.EpisodeID);
	// ת�뻤���¼ ���������޷����� bug fix 
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
		//ҽΪ�����
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
		//����ѡ�л�������
		if ((Type=="NURQE")&&(recordId)) {
	        var index = $('#NurQuestionTable').datagrid("getRowIndex", recordId);
	        if (index >= 0) {
	            $('#NurQuestionTable').datagrid("checkRow", index);
	            //PageLogicObj.m_QSGridSelRecordIdAfterLoad = "";
	        }
	    }
		sels= $("#NurQuestionTable").datagrid("getSelections");
		//���»�ȡ��������
		
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
				DescFlag:true, // ���и��ĵı�ʶ
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
			DescFlag:true, // ���и��ĵı�ʶ
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
	//todo �໼����ô����ת��
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
				$.messager.popover({msg:'ת�뻤���¼�ɹ���',type:'success'});
			}else{
				$.messager.popover({msg:'δ��ѡȷ��ת�룡',type:'error'});
			}
		}else{
			$.messager.popover({msg:'ת�뻤���¼ʧ�ܣ�'+rtn,type:'error'});
		}
	})

}

// ת�뻤���¼ȥ��
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
// ���ػ�����Ϣ�����ݣ�����
function InitPatIfoBar(EpisodeID){
	if ((ServerObj.IsShowPatInfoBannner=="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
		//2023.02.28 ҽ��վ���ڲ�����Ϣ���ĵ����޸�
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
		//HIS �汾8.2������8.5
		$.cm({
			ClassName:"Nur.NIS.Service.Base.Patient",
			MethodName:"GetPatient",
			EpisodeID:EpisodeID
		},function(PatInfo){
			var _$patInfo=$(".patInfoBanner_patInfoText");
			var sex=PatInfo.sex;
			if (sex =="Ů") {
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
// ƴ��session��Ϣ
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
        text: '����',
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
        text: '����',
        iconCls: 'icon-copy',
        handler: function () {
            NurQuestionCopy('','');
        }
    }, '-', {
        id: "QuestionEvaluate",
        text: '����',
        iconCls: 'icon-edit',
        handler: function () {	        	        
            ShowQuestionEvaluateWin();
        }
    }, {
        id: "QuestionRevokeEvaluate",
        text: '��������',
        iconCls: 'icon-cancel-order',
        handler: function () {
	        RevokeQuestionComments();	        
            
        }
    },{
        id: "QuestionEvaluateAudit",
        text: '�������',
        iconCls: 'icon-person-seal',
        handler: function () {
            NurPlanEvaluateAudit();
        }
    }, '-', {
        id: "QuestionStop",
        text: 'ֹͣ',
        iconCls: 'icon-stop-order',
        handler: function () {
            ShowNurQuestionStopWin();
        }
    }, {
        id: "QuestionCancel",
        text: '����',
        iconCls: 'icon-cancel-order',
        handler: function () {
            ShowNurQuestionCancelWin();
        }
    }, {
        id: "QuestionUnUse",
        text: '����',
        iconCls: 'icon-abort-order',
        handler: function () {
            ShowNurQuestionUnUserWin();
        }
    }, {
        id: "QuestionRevokeUnUse",
        text: '��������',
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
        text: '�ƻ����',
        iconCls: 'icon-paper-upgrade-add',
        handler: function () {
	        NurPlanReview();            
        }
    },  {
	    id: "CancelNurPlanReview",
        text: '�����ƻ����',
        iconCls: 'icon-paper-x',
        handler: function () {
	        RevokeNurPlanReview();            
        }
    },'-', {
	    id:"PrintButton",
        text: '��ӡ����ƻ���',
        iconCls: 'icon-print',
        handler: function () {
            NurQuestionPlanPrint();
        }
    },  {
	    id:"CheckboxPrint",
        text: '����ѡ��ӡ����ƻ���',
        iconCls: 'icon-print',
        handler: function () {
            NurQuestionPlanPrint(1);
        }
    },'-',{
	    id: "EditDateTime",
	    text: '�޸Ĵ���ʱ��',	    
        iconCls: 'icon-edit',
        handler: function () {
            EditDateTime("Question");
        }
	},{ // ����2744200
		id:"ifMultiple_btn",
		text:'<label style="color:black;"><span title="���ñ���Ƿ��ѡ���У������������ݻ�����ɾ��ʹ��" '+
		'style=\'color: red;padding-top:10px\' class=\'hisui-tooltip\'>*</span> '+ $g("ѡ����") +'</label>',
	}];
    var Columns = [
        [{
                field: 'NQRECSerialNo',
                title: '���ȼ�',
                //width: 60, 
                //width: $(this).width()*(60/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(60/1035) : 60,
                editor: {
                    type: 'numberbox'
                }
            },
            {
                field: 'createDateTime',
                title: '����ʱ��',
                //width: 160,
                //width: $(this).width()*(160/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(160/1035) : 160,
            },
            {
                field: 'createUser',
                title: '������ʿ',
                //width: 80,
                //width: $(this).width()*(80/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'statusName',
                title: '״̬',
                //width: 70,
                //width: $(this).width()*(70/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(70/1035) : 70,
            },
            {
                field: 'cstatus',
                title: '����״̬',
                //width: 70,
                //width: $(this).width()*(70/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(70/1035) : 70,
            },
            {
                field: 'source',
                title: '��Դ',
                //width: 100,
                //width: $(this).width()*(100/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(100/1035) : 100,
            },
            {
                field: 'playDays',
                title: 'Ŀ��������',
                //width: 95,
                //width: $(this).width()*(95/1035),
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(95/1035) : 95,
                editor: {
                    type: 'numberbox'
                },
            },
            {
                field: 'playDate',
                title: '�ƻ�������',
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
                title: '���۽��',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            }, {
                field: 'evlRemark',
                title: '���۱�ע',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'evlUser',
                title: '������',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'evlTime',
                title: '����ʱ��',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            }, 
            {
                field: 'cancelEvlUser',
                title: '����������',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },          
            {
                field: 'cancelEvlTime',
                title: '��������ʱ��',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'EvlAuditUser',
                title: '���������',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },          
            {
                field: 'EvlAuditTime',
                title: '�������ʱ��',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'stopDateTime',
                title: 'ֹͣʱ��',
                //width: 150,
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'stopUser',
                title: 'ֹͣ��ʿ',
                //width: 80
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'stopReason',
                title: 'ֹͣԭ��',
                //width: 150
                //width: $(this).width() * (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            /*{ field: 'cancelDateTime', title: '����ʱ��',width:150},
            { field: 'cancelUser', title: '������ʿ',width:80},
            { field: 'cancelReason', title: '����ԭ��',width:150}*/
            {
                field: 'abolishDateTime',
                title: '����ʱ��',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'abolishUser',
                title: '���ϻ�ʿ',
                //width: 80,
                //width:$(this).width() *(80/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'abolishReason',
                title: '����ԭ��',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'planReviewUser',
                title: '�ƻ������',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'planReviewTime',
                title: '�ƻ����ʱ��',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(150/1035) : 150,
            },
            {
                field: 'cancelplanReviewUser',
                title: '�����ƻ������',
                //width: 150,
                //width:$(this).width()* (150/1035)
                width : ServerObj.versionPatientListNew=="1" ? $(this).width()*(80/1035) : 80,
            },
            {
                field: 'cancelplanReviewTime',
                title: '�����ƻ����ʱ��',
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
        loadMsg: $g('������..'),
        pagination: true,
        rownumbers: false,
        idField: "recordId",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        nowrap: false,
        /*�˴�Ϊfalse*/
        frozenColumns: [
            [{
                    field: 'recordId',
                    checkbox: 'true'
                },
                {
                    field: 'queName',
                    title: '��������',
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
                        // 1:������Ļ���ƻ����ƶ�����ȷ������Ŀ�ꡢ�����ʩ --��ʾ��ɫ�Թ�
                        // 2:���������ѵ���  --��ʾ�澯ͼ�꣬�����м�һ��̾��
                        // 3:��ʱҽ�������Ļ������� ��!
                        // 4:��������ĳ���ҽ����ֹͣ ��!
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
                                    newValue += '<span style="color:red;padding-left:5px;">' + $g("��!") + '</span>';
                                }
                                if (linkQueShowFlag == 4) {
                                    newValue += '<span style="color:red;padding-left:5px;">' + $g("��!") + '</span>';
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
                    statusName: $g("δֹͣ"),
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
	       	//��ӡ��ʾ
   			toopTip("#PrintButton","bottom",$g("ȫ����ӡ"));
	        // ���ذ���ѡ��ӡ��ť	        
	        $("#CheckboxPrint").hide(); 
            var hideColumns = "";
            // �Ƿ����û�������
            // �������̣�����״̬������δ���ۡ������ۣ�
            if (ServerObj.IsOpenNurEvaluate == "Y") {   // ��������
                $("#QuestionStop").hide();              //����ֹͣ��ť
                //$("#QuestionUnUse").hide();  		    //�������ϰ�ť
                //$("#QuestionRevokeUnUse").hide();  	//���س������ϰ�ť                  
                //״̬��������ʾ 
                //$("#QSearchStatus").parent().prev().hide();
                //$("#QSearchStatus").parent().hide();  
                // ������                              
                //var hideColumns = "statusName^stopDateTime^stopUser^stopReason^abolishDateTime^abolishUser^abolishReason";
                var hideColumns = "stopDateTime^stopUser^stopReason";
            } else {      								// ֹͣ����            
                $("#QSearchEvaluateStatus").parent().prev().hide(); //����2569992
                $("#QSearchEvaluateStatus").parent().hide(); //����2569992

                $("#QuestionEvaluate,#QuestionEvaluateAudit").hide();
                $("#QuestionEvaluate").parent().prev().hide();
                var hideColumns = "cstatus^result^evlUser^evlTime^evlRemark^cancelEvlUser^cancelEvlTime^EvlAuditUser^EvlAuditTime";
                // �����û�������ʱ,�жϻ��������Ƿ�����ֹͣ
                if (ServerObj.StopApplyToQuestion != "Y") {
                    $("#QuestionStop").hide();
                    hideColumns += "^stopDateTime^stopUser^stopReason";
                }
            }
            // �Ƿ������������
            if (ServerObj.IsOpenNurEvaluateAudit != "Y") {
            	$("#QuestionEvaluateAudit").hide();
            	hideColumns += "^EvlAuditUser^EvlAuditTime";
            }else{
	            if ((ServerObj.QPCCNursePlanEvalPermission!="")&&(("^"+ServerObj.QPCCNursePlanEvalPermission+"^").indexOf("^"+session['LOGON.USERID']+"^")==-1)){
                	// ��¼�û�û���������Ȩ��
                  	$("#QuestionEvaluateAudit").hide();
                	hideColumns += "^EvlAuditUser^EvlAuditTime";
	            }	            
	        }
            // ----2022-10-19 add---
            //�Ƿ�����������
            if (ServerObj.QPCCOpenCancelNurEvaluate != "Y") {
                $("#QuestionRevokeEvaluate").hide();
                hideColumns += "^cancelEvlUser^cancelEvlTime";
            }
            //�Ƿ���мƻ����
            if (ServerObj.QPCCOpenNurPlanReview != "Y") {
                $("#NurPlanReview").hide();
                hideColumns += "^planReviewUser^planReviewTime";
	            //�Ƿ��������ƻ����
	            if (ServerObj.QPCCOpenCancelNurPlanReview != "Y") {
	                $("#CancelNurPlanReview").hide();
	                $("#CancelNurPlanReview").parent().next().hide();
	                hideColumns += "^cancelplanReviewUser^cancelplanReviewTime";
	            }
            }else{
	           	//�Ƿ��������ƻ����
	            if (ServerObj.QPCCOpenCancelNurPlanReview != "Y") {
	                $("#CancelNurPlanReview").hide();
	                hideColumns += "^cancelplanReviewUser^cancelplanReviewTime";
	            }
	            
	        }
	        
            //�Ƿ���ʾĿ��������
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
		    //�Ƿ����Զ����۱�ע
		    if (ServerObj.QPCCOpenNurSelfDefEvaluate!="Y"){
			    hideColumns += "^evlRemark";
			}          
            //�Ƿ����û����������ȼ�
            if (ServerObj.IsOpenQuestionPriority != "Y") {
                $("#RowMoveUp,#RowMoveDown").hide();
                $("#RowMoveUp").parent().prev().hide();
                // ���� ���ȼ���
                hideColumns += "^NQRECSerialNo";
            }

            // �����������ڻ���ƻ�
            if (ServerObj.CancelApplyToQuestion != "Y") {
                $("#QuestionCancel").hide();
            }
            // ���ϲ������ڻ���ƻ�
            if (ServerObj.UnUserApplyToQuestion != "Y") {
                $("#QuestionUnUse,#QuestionRevokeUnUse").hide();
                hideColumns += "^abolishDateTime^abolishUser^abolishReason";
                if ((ServerObj.StopApplyToQuestion != "Y") && (ServerObj.CancelApplyToQuestion != "Y") && (ServerObj.IsOpenNurEvaluate != "Y")) {
                    $("#QuestionStop").parent().prev().hide();
                }
            }
            /*
            // �Ƿ������޸Ļ���ƻ�����ʱ��
            if(ServerObj.QPCCEditDateTime != "Y"){
	            $("#EditDateTime").hide();	            
	        }
	        */
	        // ���� ���޸Ĵ���ʱ�䡿��ť תΪ˫����Ԫ���޸�
	        $("#EditDateTime").hide();
	        // ������
            if (hideColumns != "") {
                for (var i = 0; i < hideColumns.split("^").length; i++) {
                    var hideColumn = hideColumns.split("^")[i];
                    if (!hideColumn) continue;
                    $('#NurQuestionTable').datagrid("hideColumn", hideColumn);
                }
            }
            
            // ������ƻ��ύ��,������������ɹ�����������а�����һ���ύ�ļ�¼���Զ�ѡ��
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
            // ����2744200����ƻ����Ӷ�ѡ���ܣ��ɽ�����������
            //�� HTML ҳ���ϴ���һ���Զ��帴ѡ����������ҳ������е� 'ifMultiple' �ֶε�ֵ���Զ�������ѡ�л�δѡ��״̬����Ϊ����� change �¼���change �¼����ı� singleSelect ����ֵ���Ӷ�ʹ datagrid �ؼ�֧�ֵ�ѡ/��ѡ״̬��
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
				$("#ifMultiple_btn").removeAttr("class");  //ȡ�����
				//�Զ���checkbox��change�¼�	
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
			//datagrid�����У��д�λ
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
            // todo �Ż����޸ĺ�̨�����checked�����Ƿ����,checked�лᵼ�±����سɹ���checkbox�Զ���ѡ
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
        //��δ�����onClickCell() �����У�Ϊÿ���ض��ĵ�Ԫ������ض��ļ���������playDaysChange()��NQRECSerialNoChange()��, ������ȡ��ѡ��һ�л��ߵ�һ�б�˫������༭ʱ���ᴥ�����������е��ض��¼��������Ϊʲôȡ��ѡ�п�����±�ѡ�е�ԭ��
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
						//��ѡ �����ˡ��͡���ʿ�����������ߺͻ�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if ((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(session['LOGON.USERID']==row[index].createUserId)){
							EditDateTime("Question");							
						}
					}else if (QPCCNurPlanPermission=="S"){
						//��ѡ�����ˡ���ֻ�д������л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.USERID']==row[index].createUserId){
							EditDateTime("Question");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//��ѡ����ʿ������ֻ�л�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1){
							EditDateTime("Question");
						}		
					} else if (QPCCNurPlanPermission==""){
						//���δ��ѡ�����ˡ��򡰻�ʿ���������ʾ���������л�ʿ���ɲ���������Ȩ��
					}		        
		    }	        
	    },
        onSelect: function (rowIndex, rowData) {
            SetSelQuestionObj(rowData);
            $("#QuestionMakePanel").panel("setTitle", $g("�ƻ��ƶ�") + " <font color=red>" + rowData.queName + "</font>");
            if (!PageLogicObj.m_QuestionMeasureTableGrid) {
                // ��ʼ����������ء�����Ŀ�ꡢ�����ʩ���
                // �Ƿ����÷������������
                if (ServerObj.IsOpenQLQLRealateFactor == "Y") {
                    InitQLRealateFactorTableGrid();
                }
                // �Ƿ����û���Ŀ��
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
	        //��ӡ��ʾ
			if (selRows.length>=1){
   				toopTip("#PrintButton","bottom",$g("����ѡ��ӡ"));
			}else{
				toopTip("#PrintButton","bottom",$g("ȫ����ӡ"));
			}            
        },
        onUnselect: function (rowIndex, rowData) {
	        var selRows=$("#NurQuestionTable").datagrid("getSelections");	
	        //��ӡ��ʾ
	        if (selRows.length>=1){
   				toopTip("#PrintButton","bottom",$g("����ѡ��ӡ"));
	        }else{
				toopTip("#PrintButton","bottom",$g("ȫ����ӡ"));
			}
	    },
    })
    /*
    // 2021.7.27 add
    if (ServerObj.IsOpenTreatDays == "Y")
    {
    	$("#QuestionPanel-table .datagrid-toolbar tr").append("<td class='days-td'><span id='days'>"+$g("�ƻ�����������")+ServerObj.days+$g(" ��")+"</span></td>");
    }
    */
}

function InitQLRealateFactorTableGrid() {
    var ToolBar = [{
        text: '����',
        iconCls: '	icon-add',
        handler: function () {
            ShowAddQLRealateFactorWin();
        }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function () {
            DelQLRealateFactor();
        }
    }];
    /*if (ServerObj.CancelApplyToQuestionRealateFactor =="Y") {
    	ToolBar.push("-");
    	ToolBar.push({
    			text: '����',
    			iconCls: 'icon-cancel-order',
    			handler: function() {
    				ShowQLRealateFactorCancelWin();
    			}
    	})
    }*/
    if (ServerObj.UnUserApplyToQuestionRealateFactor == "Y") {
        ToolBar.push("-");
        ToolBar.push({
            text: '����',
            iconCls: 'icon-abort-order',
            handler: function () {
                ShowQLRealateFactorUnUseWin();
            }
        })
        ToolBar.push({
            text: '��������',
            iconCls: 'icon-back',
            handler: function () {
                RevokeUnUseFactorRecord();
            }
        })

        
    }
    //��ʱ���޸İ�ťת�Ƶ�˫����Ԫ��
    /*
    if (ServerObj.QPCCEditDateTime == "Y"){
	    ToolBar.push({
	        text: 'ʱ���޸�',
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
                title: '״̬',
                width: 60
            },
            {
                field: 'createAt',
                title: '����ʱ��',
                width: 160
            },
            {
                field: 'recordUser',
                title: '��ʿ',
                width: 80
            },
            {
                field: 'dataSource',
                title: '������Դ',
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
        loadMsg: $g('������..'),
        pagination: true,
        rownumbers: false,
        idField: "factorDR",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        nowrap: false,
        /*�˴�Ϊfalse*/
        rowStyler: function (index, row) {
            if ((row.recordID) && (row.statusName == $g("�ύ"))) {
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
                    title: '�������������',
                    width: 200,
                    wordBreak: "break-all",
                    formatter: function (value, row, index) {
                        if ((!row.statusName) && (row.dataSource == $g("�ֶ�¼��")) && (PageLogicObj.m_SelQuestionObj.statusName == $g("δֹͣ"))) {
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
						//��ѡ �����ˡ��͡���ʿ�����������ߺͻ�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if ((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(session['LOGON.USERID']==row[index].recordUserId)){
							EditDateTime("QLRealate");						
						}
					}else if (QPCCNurPlanPermission=="S"){
						//��ѡ�����ˡ���ֻ�д������л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.USERID']==row[index].recordUserId){
							EditDateTime("QLRealate");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//��ѡ����ʿ������ֻ�л�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1){
							EditDateTime("QLRealate");
						}		
					} else if (QPCCNurPlanPermission==""){
						//���δ��ѡ�����ˡ��򡰻�ʿ���������ʾ���������л�ʿ���ɲ���������Ȩ��
					}		        
		    }	        
	    },
    })
}

function InitQuestionTargetTableGrid() {
    var ToolBar = [{
        text: '����',
        iconCls: '	icon-add',
        handler: function () {
            ShowAddQuestionTargetWin();
        }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function () {
            DelQuestionTarget();
        }
    }];
    /*if (ServerObj.CancelApplyToQuestionTarget =="Y") {
    	ToolBar.push("-");
    	ToolBar.push({
    			text: '����',
    			iconCls: 'icon-cancel-order',
    			handler: function() {
    				ShowQuestionTargetCancelWin();
    			}
    	})
    }*/
    if (ServerObj.UnUserApplyToQuestionTarget == "Y") {
        ToolBar.push("-");
        ToolBar.push({
            text: '����',
            iconCls: 'icon-abort-order',
            handler: function () {
                ShowQuestionTargetUnUseWin();
            }
        })
        ToolBar.push({
            text: '��������',
            iconCls: 'icon-back',
            handler: function () {
                RevokeUnUseQuestionTarget();
            }
        })
    }
    //��ʱ���޸İ�ťת�Ƶ�˫����Ԫ��
    /*
    if (ServerObj.QPCCEditDateTime == "Y"){
	    ToolBar.push({
	        text: 'ʱ���޸�',
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
                title: '״̬',
                width: 60
            },
            {
                field: 'createAt',
                title: '����ʱ��',
                width: 160
            },
            {
                field: 'sign',
                title: '��ʿǩ��',
                width: 80
            },
            {
                field: 'dataSource',
                title: '������Դ',
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
        loadMsg: $g('������..'),
        pagination: true,
        rownumbers: false,
        idField: "goalDR",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        nowrap: false,
        /*�˴�Ϊfalse*/
        rowStyler: function (index, row) {
            if ((row.recordID) && (row.goalStatus == $g("�ύ"))) {
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
                    title: '����Ŀ��',
                    width: 200,
                    wordBreak: "break-all",
                    formatter: function (value, row, index) {
                        if ((!row.recordID) && (row.goalStatus == "") && (row.dataSource == $g("�ֶ�¼��")) && (PageLogicObj.m_SelQuestionObj.statusName == $g("δֹͣ"))) {
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
						//��ѡ �����ˡ��͡���ʿ�����������ߺͻ�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if ((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(session['LOGON.USERID']==row[index].nurId)){
							EditDateTime("Target");					
						}
					}else if (QPCCNurPlanPermission=="S"){
						//��ѡ�����ˡ���ֻ�д������л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.USERID']==row[index].nurId){
							EditDateTime("Target");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//��ѡ����ʿ������ֻ�л�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1){
							EditDateTime("Target");
						}		
					} else if (QPCCNurPlanPermission==""){
						//���δ��ѡ�����ˡ��򡰻�ʿ���������ʾ���������л�ʿ���ɲ���������Ȩ��
					}		        
		    }	        
	    },
    })
}

function InitQuestionMeasureTableGrid() {
    var ToolBar = [{
        text: '����',
        iconCls: '	icon-add',
        handler: function () {
            ShowAddQuestionMeasureWin();
        }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function () {
            DelQuestionMeasure();
        }
    }];
    if (ServerObj.StopApplyToQuestionMeasure == "Y") {
        ToolBar.push("-");
        ToolBar.push({
            text: 'ֹͣ',
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
            text: '����',
            iconCls: 'icon-abort-order',
            handler: function () {
                ShowQuestionMeasureUnUseWin();
            }
        })
        ToolBar.push({
            text: '��������',
            iconCls: 'icon-back',
            handler: function () {
                RevokeUnUseQuestionMeasure();
            }
        })
    }
    //��ʱ���޸İ�ťת�Ƶ�˫����Ԫ��
    /*
    if (ServerObj.QPCCEditDateTime == "Y"){	    
        ToolBar.push({
	        text: 'ʱ���޸�',
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
                title: 'ִ��Ƶ��',
                width: 100,
                editor: {
                    type: 'combobox',
                    options: {
                        // ���Ӿ���id��� 2021.7.5
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
                                // ע�͵�Դ����
                                //var rows=$("#QuestionMeasureTable").datagrid("selectRow",PageLogicObj.m_QSMeasureEditIndex).datagrid("getSelected");
                                // 2021.6.2 �����ʩ�����ÿ��ѡƵ�Σ�����ѵ�һ����Ƶ���滻�� bug fix start
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
            }, //defFreq Ƶ���Ż� query�з���ִ��Ƶ������
            {
                field: 'exectime',
                title: '�ƻ�ִ��ʱ��',
                width: 100,
                showTip: true,
                tipWidth: 350,
                tipPosition: 'top'
            },
            {
                field: 'startDatetime',
                title: '��ʼʱ��',
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
                title: '״̬',
                width: 60
            },
            {
                field: 'dataSource',
                title: '��Դ',
                width: 80
            },
            {
                field: 'createdAt',
                title: '����ʱ��',
                width: 160
            },
            {
                field: 'sign',
                title: '�ύ��',
                width: 80
            },
            // 2021.8.30 add ֹͣ��������Ϣ
            {
                field: 'stopUser',
                title: 'ֹͣ��',
                width: 80
            },
            {
                field: 'stopDatetime2',
                title: 'ֹͣʱ��',
                width: 160,
				formatter: function(value,row,index){
				if (row.statusName==$g("����")){
					 return "";
					}
				else{
					return value;
					}
				}
            },
            {
                field: 'stopReason',
                title: 'ֹͣԭ��',
                width: 160
            },
            {
                field: 'cancelUser',
                title: '������',
                width: 80
            },
            {
                field: 'cancelDatetime2',
                title: '����ʱ��',
                width: 160
            },
            {
                field: 'cancelReason',
                title: '����ԭ��',
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
        loadMsg: '������..',
        pagination: true,
        rownumbers: false,
        idField: "intervDR",
        pageSize: 15,
        pageList: [15, 50, 100, 200],
        columns: Columns,
        toolbar: ToolBar,
        autoSizeColumn: false,
        nowrap: false,
        /*�˴�Ϊfalse*/
        rowStyler: function (index, row) {
            if ((row.recordID) && (row.statusName == $g("�ύ"))) {
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
                    title: '�����ʩ',
                    width: (MeasureTableFitColumns ? fixWidth(0.25) : 200),
                    wordBreak: "break-all",
                    formatter: function (value, row, index) {
                        if ((row.statusName == "") && (row.dataSource == $g("�ֶ�����")) && (PageLogicObj.m_SelQuestionObj.statusName == $g("δֹͣ"))) {
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
						//��ѡ �����ˡ��͡���ʿ�����������ߺͻ�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if ((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(session['LOGON.USERID']==row[index].nurId)){
							EditDateTime("Intervention");			
						}
					}else if (QPCCNurPlanPermission=="S"){
						//��ѡ�����ˡ���ֻ�д������л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.USERID']==row[index].nurId){
							EditDateTime("Intervention");
						}
					}else if(QPCCNurPlanPermission=="L") {
						//��ѡ����ʿ������ֻ�л�ʿ���л���ƻ����޸Ĵ���ʱ�����Ȩ������
						if (session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1){
							EditDateTime("Intervention");
						}		
					} else if (QPCCNurPlanPermission==""){
						//���δ��ѡ�����ˡ��򡰻�ʿ���������ʾ���������л�ʿ���ɲ���������Ȩ��
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
// ��ʼ���뻤��ƻ�ͨ��������صı�����
function InitNurPlanComConfigService(NurPlanComConfigObj) {
    //var NurPlanComConfigObj=eval("("+NurPlanComConfig+")");
    $.extend(ServerObj, NurPlanComConfigObj);
    // �Ƿ����÷������������
    /*if (ServerObj.IsOpenQLQLRealateFactor !="Y") {
    	$("#QLRealateFactorPanel").parent().hide();
    }
    // �Ƿ����û���Ŀ��
    if (ServerObj.IsOpenQuestionTarget !="Y") {
    	$("#QuestionTargetPanel").parent().hide();
    }*/
}
// ��ʼ���뻤��ƻ�ͨ��������չ����صı�����
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
// ��ʼ����ѡ�л�����صı�����
function InitPatInfoViewService(EpisPatInfo) {
    try {
        var EpisPatInfoObj = eval("(" + EpisPatInfo + ")");
        $.extend(ServerObj, EpisPatInfoObj);
    } catch (e) {
        //�˷����ֲ�ˢ�º�ҳ���ʼ��ʱ�����,���������ܵ��´������Ų�,��Ӵ�����ʾ����Ϣ
        $.messager.alert("��ʾ", "����InitPatInfoViewGlobal�����쳣,������Ϣ��" + e.message);
        return false;
    }
}
// �ƻ��ƶ�panel��������panel�Ŀ��
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
        //width: MaxWidth - QLRealateFactorPanelW - QuestionTargetPanelW - (PanelSpaceNum * 4) - 4,   //�������:3152987 ҳ����һ��չʾ���ӿ������,��"�ƻ��ƶ�"���Ӻ��������
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
    //assessList: "[{"Id":"","source":"��������","status":"�ύ","trggerTime":"","trigger":"lv-���µ�test Ҹ�£��棩"}]"
    // ��Դ �������� ״̬ ����ʱ�� ��¼ID
    $(that).webuiPopover({
        title: '',
        content: function () {
            var html = [];
            html.push('<ul class="related-factors">');
            html.push('<li class="title"><p class="assess-source">' + $g("��Դ") + '</p><p class="assess-factors">' + $g("��������") + '</p><p class="assess-status">' + $g("״̬") + '</p><p class="assess-trggerTime">' + $g("����ʱ��") + '</p><p class="assess-id">' + $g("��¼ID") + '</p></li>');
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

	//�ڡ������������⡿������׷�����ڡ�ʱ��ؼ���Ĭ��Ϊϵͳ��ǰʱ��
	if((ServerObj.QPCCEditDateTime!="")&(ServerObj.QPCCEditDateTime!="Y")){
		//�Ƿ������޸��ֶ���������ʱ�� ѡ���ǡ���������ڡ�ʱ�������޸ģ�ѡ�񡰷񡱣����ֹ�޸ģ�
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
	        "text": $g("ȫ��"),
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
                title: '�������',
                width: 200,
                sortable: true
            },
            {
                field: 'queName',
                title: '��������',
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
// ����������������
function BQuestionSaveClick() {
	var now = new Date();
	//var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	var nowDateTime=now.getFullYear()+"-"+('0' + (now.getMonth() + 1)).slice(-2)+"-"+('0' + now.getDate()).slice(-2)+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	
    var selRows = $("#QuestionTreeGridTab").treegrid("getCheckedNodes");
    if (selRows.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
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

	//ʱ�������Χ����ϵͳ��ǰʱ���뻼�����ʱ��֮�䣬����޸�ʱ�䳬�����������Ϣ����
	if(InHospDateTime==""){
		$.messager.popover({
            msg: 'δ�ܻ�ȡ��Ժʱ�䣡',
            type: 'error'
        });
		return false;
	}
	if(!CompareDateFromCreatToNow(datetime,InHospDateTime,nowDateTime)){
		$.messager.popover({
            msg: '�޸�ʱ�䳬��������Ժʱ���ϵͳ��ǰʱ�䣡',
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
                msg: "����ʧ�ܣ�" + rtn,
                type: 'error'
            });
        }
    })
}
// �������⸴��
function NurQuestionCopy(queDR,queName,recordId) {
	var ConfirmMsgHtml = [];
    ConfirmMsgHtml.push("<div class='confirm'><p class='title'>" + $g("ȷ��Ҫ�������»���������") + "</p><p class='content'>" + $g("���������ύ��ֻ����ֹͣ������") + "</p></div>");
    ConfirmMsgHtml.push("<ul class='question' style='width:194px'>");
    ConfirmMsgHtml.push("<li class='title'>" + $g("��������") + "</li>");
    var selRows = $('#NurQuestionTable').datagrid('getSelections');
	if ((queDR!="")&&(queName!="")&&(recordId!="")){
		ConfirmMsgHtml.push("<li>" + queName + "</li>");   

    }else{		
	    if (selRows.length == 0) {
	        $.messager.popover({
	            msg: $g("��ѡ����Ҫ���ƵĻ������⣡"),
	            type: 'error'
	        });
	        return false;
	    }
	    var queRowIDArr = new Array();
	    for (var i = 0; i < selRows.length; i++) {
	        var statusName = selRows[i].statusName;
	        if (statusName == $g("δֹͣ")) {
	            $.messager.popover({
	                msg: '" δֹͣ "״̬�Ļ������ⲻ�ܸ��ƣ�',
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
    $.messager.confirm('ȷ�϶Ի���', ConfirmMsgHtmlCode, function (r) {
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
                        msg: '����ʧ�ܣ�' + rtn,
                        type: 'error'
                    });
                }
	            //ת�뻤���¼
			    if ((queDR!="")&&(queName!="")&&(recordId!="")&&(ServerObj.QPCCOpenNurEvaluateTrans=="Y")){				    
				    var Type="NURQE";
				    var TransferDesc=ServerObj.QPCCNurEvaluateTransFormat;
			    	showTransferRecordWin(Type,TransferDesc,recordId);
			    }
            })
        }else{
			//ת�뻤���¼
		    if ((queDR!="")&&(queName!="")&&(recordId!="")&&(ServerObj.QPCCOpenNurEvaluateTrans=="Y")){			    
			    var Type="NURQE";
			    var TransferDesc=ServerObj.QPCCNurEvaluateTransFormat;
		    	showTransferRecordWin(Type,TransferDesc,recordId);
		    }
        }
    });
}
// �����������۵���
function ShowQuestionEvaluateWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '��ѡ��һ����������������ۣ�',
            type: 'error'
        });
        return false;
    } else if (sels[0].result == $g("�ѽ��")) {
        $.messager.popover({
            msg: '�û��������ѽ����',
            type: 'error'
        });
        return false;
    } else if (sels[0].statusName == $g("����")) {
        $.messager.popover({
            msg: '�û��������ѳ�����',
            type: 'error'
        });
        return false;
    } else if (sels[0].statusName == $g("����")) {
        $.messager.popover({
            msg: '�û������������ϣ�',
            type: 'error'
        });
        return false;
    //}else if ((sels[0].cstatus == $g("������"))&&(sels[0].result == $g("��ȫ���"))) {
	  }else if (sels[0].cstatus == $g("������")) {
        $.messager.popover({
            msg: '�û������������ۣ������޸����۽����',
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
    	createModalDialog("QuestionDiag", $g("������������"), 350, 217, iconCls, $g("ȷ��"), Content, 'SaveQuestionComments("'+NowDateTime+'")');
    }else{
	    createModalDialog("QuestionDiag", $g("������������"), 350, 180, iconCls, $g("ȷ��"), Content, 'SaveQuestionComments("'+NowDateTime+'")');
	}
	//�ڡ������������ۡ������У�׷�����ڡ�ʱ��ؼ���Ĭ��Ϊϵͳ��ǰʱ��
	if((ServerObj.QPCCEvaluationEditDateTime!="")&(ServerObj.QPCCEvaluationEditDateTime!="Y")){
		//�Ƿ������޸�����ʱ��ѡ���ǡ���������ڡ�ʱ�������޸ģ�ѡ�񡰷񡱣����ֹ�޸ģ�
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
            if ((rec) && (rec.code == "03")) { //����03���������ѽ��

                $.messager.alert("��ʾ", "���۽�� <font color=red>" + rec.text + "</font> �ύ�󣬸û����������۽�������޸ģ�");
            }
        }
    });
    $('#QuestionEvaluateResult').next('span').find('input').focus();
}
// ���滤���������۽��
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
            msg: '��ѡ�����۽����',
            type: 'error'
        });
        $('#QuestionEvaluateResult').next('span').find('input').focus();
        return false;
    }
    //�������2848261������������ʱ����ѡ��ʱ��
    var datetime = $('#QEEditDataTimeBox').datetimebox('getValue');
	inDate = datetime.split(" ")[0];
	inTime = datetime.split(" ")[1];
	//ʱ�������Χ����ϵͳ��ǰʱ���뻤�����ⴴ��ʱ��֮�䣬����޸�ʱ�䳬�����������Ϣ����
	if(!CompareDateFromCreatToNow(datetime,createDateTime,nowDateTime)){
		$.messager.popover({
            msg: '�޸�ʱ�䳬���������ⴴ��ʱ���ϵͳ��ǰʱ�䣡',
            type: 'error'
        });
        return false;
	}
	// ����Զ����۱�ע
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
	            //�Ƿ������������ѡ�����ʾ�����ۻ�ֹͣԭ��ѡ�������ʱ�������û��Ƿ��Ƹû�������          
	        	$.messager.confirm("��ʾ", queName+'������������/ֹͣ���Ϊ'+QuestionEvaluateResult+',�Ƿ��Ƹû������⣿', function (res) {
					if (res){						
						//ȷ��,���Ƹû�������
						NurQuestionCopy(queDR,queName,recordId);
					}
					else{
						//ȡ���������δ���������Ƿ���дת�顱��ѡ����дת��ԭ��
						if (ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenFillOutcome=="Y"){
							//��дת��ԭ��
							ShowQPCCTransReasonWin(questionSub,QuestionEvaluateResult,recordId);
						}
						return;
					}									
				});
            }
			$("#NurQuestionTable").datagrid('load'); 			
        } else {
            $.messager.popover({
                msg: '������������ʧ�ܣ�',
                type: 'error'
            });
        }
       
    });    
}
// ת��ԭ�򵯿�
function ShowQPCCTransReasonWin(questionSub,QuestionEvaluateResult,recordId) {
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("QPCCTransReason");
    var iconCls = "";
    if (ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenReasonRequired=="Y"){
	    // ת��ԭ����� ������ʾ��
		createModalDialog("QuestionDiag", $g("ת��ԭ��"), 350, 150, iconCls, $g("ȷ��"), Content, 'SaveQPCCTransReason('+(questionSub)+',\"'+QuestionEvaluateResult+'\",\"'+recordId+'\")',$g('ȡ��'),'CXQPCCEOpenReasonRequired()');
    }else{
		createModalDialog("QuestionDiag", $g("ת��ԭ��"), 350, 150, iconCls, $g("ȷ��"), Content, 'SaveQPCCTransReason('+(questionSub)+',\"'+QuestionEvaluateResult+'\",\"'+recordId+'\")');
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
	    // ת��ԭ��������ȡ����ť
	    //$("#DialogCancelBtn").css({"pointer-events":" none"});
    }
    */
}
function CXQPCCEOpenReasonRequired(){
	$.messager.popover({
		msg: 'ת��ԭ����',
	    type: 'error'
	});
	return;
}
// ���滤������ת��ԭ��
function SaveQPCCTransReason(questionSub,QuestionEvaluateResult,recordId) {
	var TransReason='';
	TransReason=$("#QuestionTransReason").combobox("getText");
	if ((QuestionEvaluateResult!="")&&((ServerObj.ComConfigExt[QuestionEvaluateResult].QPCCEOpenReasonRequired=="Y"))&&(TransReason.length == 0)) {
        $.messager.popover({
            msg: 'ת��ԭ����',
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
	                msg: '����ת��ԭ��ʧ�ܣ�',
	                type: 'error'
	            });          
        	}
        	//ת�뻤���¼
		    if (ServerObj.QPCCOpenNurEvaluateTrans=="Y"){
			    var Type="NURQE";
			    var TransferDesc=ServerObj.QPCCNurEvaluateTransFormat;
		    	showTransferRecordWin(Type,TransferDesc,recordId);
		    } 
		});
    }
}
// �������⳷������
function RevokeQuestionComments() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ�������۵Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var cstatus = sels[i].cstatus;
        if (cstatus != $g("������")) {
            $.messager.popover({
                msg: 'ֻ�ܳ���״̬Ϊ" ������ "�Ļ������⣡',
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
                msg: '�������⳷������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// ����ƻ��������
function NurPlanEvaluateAudit() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ��˵Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var cstatus = sels[i].cstatus;
        if (cstatus == $g("δ����")) {
            $.messager.popover({
                msg: '�������״̬Ϊ" δ���� "�Ļ������⣡',
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
                msg: '�����������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �����������
function NurPlanReview() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ��˵Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var cstatus = sels[i].cstatus;
        var statuesName = sels[i].statuesName;
        if ((cstatus == $g("δ����"))||(statuesName == $g("δֹͣ"))) {
            $.messager.popover({
                msg: '�������״̬Ϊ" δ���� "��" δֹͣ "�Ļ������⣡',
                type: 'error'
            });
            return false;
        }else if(sels[i].planReviewUser!=""){
	        $.messager.popover({
                msg: '����������ٴ���ˣ�',
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
                msg: '�����������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �������⳷�����
function RevokeNurPlanReview() {
	var sels = $('#NurQuestionTable').datagrid('getSelections');
	if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ��˵Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var planReviewUser = sels[i].planReviewUser;
        if (planReviewUser == "") {
            $.messager.popover({
                msg: 'ֻ�ܳ�������˵Ļ������⣡',
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
                msg: '���������������ʧ�ܣ�' + rtn,
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
				//����IE
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
    $("body").remove("#" + id); //�Ƴ����ڵ�Dialog
    $("#" + id).dialog('destroy');
}

function QuestionKeyWordOnKeyDown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        $('#NurQuestionTable').datagrid('reload');
    }
}
// ֹͣ�������ⵯ��
function ShowNurQuestionStopWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫֹͣ�Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("δֹͣ")) {
            $.messager.popover({
                msg: 'ֻ��ֹͣ״̬Ϊ" δֹͣ "�Ļ������⣡',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("Stop");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("ֹͣ��������"), 350, 200, iconCls, $g("ȷ��"), Content, "NurQuestionStop()");
    InitStopReason();
}
// �����������ⵯ��
function ShowNurQuestionCancelWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ�����Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("δֹͣ")) {
            $.messager.popover({
                msg: 'ֻ�ܳ���״̬Ϊ" δֹͣ "�Ļ������⣡',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("Cancel");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("������������"), 350, 200, iconCls, $g("ȷ��"), Content, "NurQuestionCancel()");
    InitCancelReason();
}
// ���ϻ������ⵯ��
function ShowNurQuestionUnUserWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: $g('��ѡ����Ҫ���ϵĻ������⣡'),
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        /*
        if (statusName != $g("δֹͣ")) {
            $.messager.popover({
                msg: $g("ֻ������״̬Ϊδֹͣ�Ļ������⣡"),
                type: 'error'
            });
            return false;
        }
        */
        //�������	3226650 ���껯���󡿻�ʿ���������������ֹͣ�Ļ������⣬Ŀǰ�޷����ϣ�������޸ġ�
        if ((statusName == $g("�ѳ���"))||(statusName == $g("������"))) {
            $.messager.popover({
                msg: $g("ֻ������״̬Ϊδֹͣ����ֹͣ�Ļ������⣡"),
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("UnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("���ϻ�������"), 350, 156, iconCls, $g("ȷ��"), Content, "NurQuestionUnUse()");
    InitUnUseReason();
}
// �������⳷��
function NurQuestionCancel() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ�����Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("δֹͣ")) {
            $.messager.popover({
                msg: 'ֻ�ܳ���״̬Ϊ" δֹͣ "�Ļ������⣡',
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
                msg: '������������ɹ���',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#NurQuestionTable").datagrid('load');
        } else {
            $.messager.popover({
                msg: '������������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// ��������ֹͣ
function NurQuestionStop() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫֹͣ�Ļ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("δֹͣ")) {
            $.messager.popover({
                msg: 'ֻ��ֹͣ״̬Ϊ" δֹͣ "�Ļ������⣡',
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
                msg: 'ֹͣ��������ɹ���',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#NurQuestionTable").datagrid('load');
            //ת�뻤���¼
		   if (ServerObj.QPCCOpenNurQuestionStopTrans=="Y"){
			    var Type="NURQS";
			    var TransferDesc=ServerObj.QPCCNurQuestionStopTransFormat;
		    	showTransferRecordWin(Type,TransferDesc,'');
		    }          
        } else {
            $.messager.popover({
                msg: 'ֹͣ����ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// ������������
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
                msg: '���ϻ�������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �������⳷������(����������)
function NurQuestionRevokeUnUse() {
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ�������ϵĻ������⣡',
            type: 'error'
        });
        return false;
    }
    var selRecordArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("������")) {
            $.messager.popover({
                msg: 'ֻ�ܳ���״̬Ϊ" ������ "�Ļ������⣡',
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
                msg: '�������ϻ�������ʧ�ܣ�' + rtn,
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
        html += '<div class="confirm"><p class="title">' + $g("ȷ��Ҫ����ѡ��ļ�¼��") + '</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="UnUseReason" style="margin-right:10px;">' + $g("����ԭ��") + '</label>'
        html += '<input id="UnUseReason" class="textbox" style="width:180px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    } else if (type == "Stop") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html += '<div class="messager-icon messager-question"></div>'
        html += '<div style="margin-left:42px;">'
        html += '<div class="confirm"><p class="title">' + $g("ȷ��Ҫֹͣѡ��ļ�¼��") + '</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="StopReason" style="margin-right:10px;">' + $g("ֹͣԭ��") + '</label>'
        html += '<input id="StopReason" class="textbox" style="width:180px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    } else if (type == "AddQuestionTarget") {
        var html = "<div id='QuestionWin' class='messager-body' style='padding-bottom:0;'>"
        html += '<div>'
        //html +='<label class="clsRequired r-label">����Ŀ��</label>'
        html += '<textarea id="QuestionTarget" style="width:325px;height:97px;"></textarea>'
        html += '</div>'
        html += "</div>"
    } else if (type == "AddQuestionMeasure") {
        var html = "<div id='QuestionWin' style='overflow:hidden;'>"
        html += "	<table class='search-table' style='border:none;'>"
        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("��ʩ���") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='InterventionType' class='textbox' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label' style='vertical-align:top;'>"
        html += '<label class="clsRequired">' + $g("��ʩ������") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <textarea class='hisui-validatebox' id='TextareaElement_measure' name='TextareaElement_measure' style='height:80px;width:300px;box-sizing:border-box;border-radius:2px;'></textarea>"
        html += "	 </td>"
        html += "	 </tr>"

        /* �ֶ�������ʩ ȡ���������ѡ��
        html +="	 <tr>"
        	html +="	 <td class='r-label'>"
        		html += '<label for="InterventionRecord">'+$g("�������")+'</label>'
        	html +="	 </td>"
        	html +="	 <td>"
        		html +="	 <input id='InterventionRecord' class='textbox' style='width:300px;'></input>"
        	html +="	 </td>"
        html +="	 </tr>"
        */

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label for ="InterventionFreq" class="clsRequired">' + $g("ִ��Ƶ��") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='InterventionFreq' class='textbox' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("��������") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='startdate' class='hisui-datebox textbox' required='required' style='width:300px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label>' + $g("ͣ������") + '</label>'
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
        html += '<label class="clsRequired">' + $g("ֹͣ����") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='MeasureStopDate' class='hisui-datebox textbox' required='required' style='width:156px;'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label class="clsRequired">' + $g("ֹͣʱ��") + '</label>'
        html += "	 </td>"
        html += "	 <td>"
        html += "	 <input id='MeasureStopTime' class='hisui-timespinner textbox' data-options='showSeconds:false' required='required'></input>"
        html += "	 </td>"
        html += "	 </tr>"

        html += "	 <tr>"
        html += "	 <td class='r-label'>"
        html += '<label for ="StopReason">' + $g("ֹͣԭ��") + '</label>'
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
        html += '<div class="confirm"><p class="title">' + $g("ȷ��Ҫ����ѡ��Ļ����ʩ��") + '</p><p style="color:red;margin-top:10px;">' + $g("�����ʩ���Ϻ�,�����Ļ��������Զ�����,�Ƿ������") + '</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="UnUseReason" style="margin-right:10px;">' + $g("����ԭ��") + '</label>'
        html += '<input id="UnUseReason" class="hisui-combobox textbox" style="width:176px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    } else if (type == "QuestionEvaluate") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        
        // �������2848261������������ʱ����ѡ��ʱ��
        html += '<div>'
        html += '<label class="clsRequired r-label">' + $g("����ʱ��") + '</label>'
        html +='<input class="hisui-datetimebox" id="QEEditDataTimeBox" data-options="required:true,showSeconds:false" style="width:255px">'
        html += '</div>'
        
        html += '<div style="margin-top:10px;">'
        html += '<label class="clsRequired r-label">' + $g("���۽��") + '</label>'
        html += '<input id="QuestionEvaluateResult" class="textbox" style="width:255px;"></input>'
        html += '</div>'
        if ((ServerObj.QPCCOpenNurSelfDefEvaluate!="")&(ServerObj.QPCCOpenNurSelfDefEvaluate=="Y")){
			//2758853������ƻ����á�ҵ��������� add ���۱�ע
	        html += '<div id="Div-EvaluateRemark" style="margin-top:10px;display: table">'
	        html += '<label class="r-label" for="QuestionEvaluateRemark" style="display: table-cell; vertical-align: middle;">' + $g("���۱�ע") + '</label>'
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
        html += '<div class="confirm"><p class="title">ȷ��Ҫ����ѡ��ļ�¼��</p></div>'
        html += '<div style="margin-top:10px;">'
        html += '<label for="CancelReason" class="r-label">' + $g("����ԭ��") + '</label>'
        html += '<input id="CancelReason" class="textbox" style="width:210px;"></input>'
        html += '</div>'
        html += "	 </div>"
        html += "</div>"
    }else if (type == "EditDataTime") {
        var html = "<div id='QuestionWin' class='messager-body'>"
        html +='<table>'
		html +='<tr>'
		html +='<td class="r-label">�޸�����ʱ��Ϊ ��</td>'
		html +='<td>'
		html +='<input class="hisui-datetimebox" id="EditDataTimeBox" value="${notices.release_time}" data-options="required:true,showSeconds:false" style="width:180px">'
		html +='</td>'
		html +='</tr>'
		html +='<tr id="tr-LimitEditDataTime">'
		html +='<td class="r-label">����ʱ��Ϊ ��</td>'
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
		html +='<td><label>ת��ԭ��:</label></td>'
		html +='<td>'
		html += '<input id="QuestionTransReason" class="textbox" style="width:245px;"></input>'
		html +='</td>'
		html +='</tr>'
	}else if(type =="transferRecord"){
		var html="<div id='transferRecord'>"
				html +='<div id="patinfobanner" style="padding:10px;display: flex;">'
				if((ServerObj.IsShowPatInfoBannner=="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
					//2023.02.28 ҽ��վ���ڲ�����Ϣ���ĵ����޸�	
					html +='<div class="pat-info-container"></div>'		
					//html +='<div class="pat-info-over">...</div>'					
				}else if((ServerObj.IsShowPatInfoBannner!="Y")&&(ServerObj.versionIsInfoBarNew=="1")){
					//��λͼ��ת
				}else{
					//HIS �汾8.2������8.5
					html +='<div class="patInfoBanner_patInfoText"></div>'					
				}					
				html +='</div>'
				html +='<table>'					
					/*
					html +='<p class="remind">'+$g("ת�뻤���¼")+'</p>' //'<a class="hisui-linkbutton" id="BDataRefer" style="margin-left:10px;">'+$g("��������")+'</a>'
					html +='<div>'
						html +=" <textarea id='TransferDesc' style='margin:0 10px;height:140px;width:720px;border-radius:2px;'></textarea>"
					html +='</div>'
					html +='<div style="margin:10px 0 0 4px;">'
						html +='<input id="SureTrans" class="hisui-checkbox" type="checkbox" data-options="checked:true" label="'+$g("ȷ��Ҫ�����Ͻ��<span>ת�뻤���¼</span>��")+'"'
					html +='</div>'
					html +='<div style="margin:10px 0 10px 7px;">'
						html +='<label style="margin-right:10px;">'+$g("ת��ʱ��")+'</label>'
						html +="<input id='TransferDate' class='hisui-datebox textbox r-label' style='width:120px;'></input>"
						html +="<span style='margin:0 5px;'></span>"
						html +="<input id='TransferTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:80px;'></input>"
					html += "</div>"
					html +='<div style="margin:10px 0 0 7px;">'
						html +='<label style="margin-right:10px;">'+$g("ת�뻤ʿ")+'</label>'
						html +="<input id='TransferUser' class='textbox' disabled style='width:203px;'></input>"
					html += "</div>"					
					*/
					html +='<tr ><td  style="padding: 0px 0 10px 10px; width: 115px;text-align:right">'+$g("ִ�н������")+'</td></tr>'
					html +='<tr>'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +=" <td><textarea id='TransferDesc' style='margin:0 10px;height:120px;width:590px;border-radius:2px;'></textarea></td>"
					html +='</tr>'
					html +='<tr style="margin:10px 0 0 0px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +='<td style="padding:10px 0 0 10px;"><input id="SureTrans" class="hisui-checkbox" type="checkbox" data-options="checked:true" label="'+$g("ȷ��Ҫ������ִ�н��<span>ת�뻤���¼</span>��")+'">'
					html +='</tr>'
					html +='<tr style="margin:10px 0 0 0px;">'
						html +='<td style="padding:10px 0px 0 10px;text-align:right""><label for="NursingRecordTemplate">'+$g("�����¼��")+'</label></td>'
						html +='<td style="padding:10px 10px 0 10px"><input class="hisui-combogrid" style=" width:360px; "id="NursingRecordTemplate"/></td>'
					html +='</tr>'
					html +='<tr style="margin:10px 0 10px 0px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ת��ʱ��")+'</label></td>'
						html +="<td style='padding:10px'><input id='TransferDate' class='hisui-datebox textbox r-label' style='width:120px;'></input>"
						html +="<span style='margin:0 5px;'></span>"
						html +="<input id='TransferTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:80px;'></input></td>"
					html += "</tr>"
					html +='<tr style="margin:10px 0 0 0px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ת�뻤ʿ")+'</label></td>'
						html +="<td style='padding:0px 10px 0px 10px'><input id='TransferUser' class='textbox' disabled style='width:203px;'></input></td>"
					html += "</tr>"					
				html +='</table>'
			html += "</div>"
	}
    return html;
}
/**
 * Dialog ��̬�İ�Click�¼�
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
 * ����һ��ģ̬ Dialog
 * @param id divId
 * @param _url Div����
 * @param _title ����
 * @param _width ���
 * @param _height �߶�
 * @param _icon ICONͼ��
 * @param _btntext ȷ����ťtext
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
    //���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
    if ((_btncxtext=="")||(typeof(_btncxtext)=="undefined")){
	    buttons.push({
		    id:'DialogCancelBtn',
	        text: $g('ȡ��'),
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

// ��ӡ����ƻ���
function NurQuestionPlanPrint(selFlag) {	
	var QPCCNursePlanPrintStatus=ServerObj.QPCCNursePlanPrintStatus
	var arrLimitStr=getPrintStatusLimitStr();
	
    // �ⲿ����Դ��ӡbug fix
    var locationURL = window.location.href.split("/csp/")[0]; // + "/"
    var rows = "",cstatus="",statusName="",queName=""
    /*
    if (selFlag) {
        var dataSourceRow = $('#NurQuestionTable').datagrid('getChecked');
        if (dataSourceRow.length == 0) {
            $.messager.popover({
                msg: '��ѡ��һ������Դ!',
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
	    // ����ѡ��ӡ����ƻ���
	    //����2987696
	    rows = "@"+session['LOGON.CTLOCID']+"@*"
        $.each(dataSourceRow, function (index, item) {
            //rows = rows==""?item.recordId: (rows + "@"+ item.recordId )
			rows = rows + item.recordId + "*";
			if ((item.statusName=="δֹͣ")||(item.cstatus=="δ����")){
				cstatus=cstatus+"@"+item.cstatus;
				statusName=statusName+"@"+item.statusName;
				queName=queName+"��"+item.queName+"��";
			}						
        });        
        if(ServerObj.QPCCNursePlanPrintStatusLimit.indexOf("Limit")!=-1) {
			// ��ѡ �����̿��ơ�
			if(((arrLimitStr.indexOf("δ����")!=-1)&&(cstatus.indexOf("δ����")!=-1))||((arrLimitStr.indexOf("δֹͣ")!=-1)&&(statusName.indexOf("δֹͣ")!=-1))){
				// ����ƻ�����ӡ���ƿ��� ��ѡ��δֹͣ�� �� ��δ���ۡ�
				$.messager.alert("��ʾ", queName+"��������δ���ۻ�δֹͣ�������ۻ�ֹͣ���ٴ�ӡ����ƻ���",'error')
				return;
			}else{
				//����ƻ���ӡģ��
				if(ServerObj.QPCCNurPlanPrintTemplate!=""){
					AINursePrintAll(locationURL, ServerObj.QPCCNurPlanPrintTemplate, ServerObj.EpisodeID, rows);	
				}else{
					AINursePrintAll(locationURL, "DHCNURMoudPrnHLJHD", ServerObj.EpisodeID, rows);	
	
				}
			}	
		}else{
			// δ��ѡ �����̿��ơ�
			if(((arrLimitStr.indexOf("δ����")!=-1)&&(cstatus.indexOf("δ����")!=-1))||((arrLimitStr.indexOf("δֹͣ")!=-1)&&(statusName.indexOf("δֹͣ")!=-1))){
				$.messager.confirm("��ʾ", queName+"��������δֹͣ��δ���ۣ��Ƿ������ӡ����ƻ�����", function (res) {
					if (res){
						//����ƻ���ӡģ��
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
				//����ƻ���ӡģ��
				if(ServerObj.QPCCNurPlanPrintTemplate!=""){
					AINursePrintAll(locationURL, ServerObj.QPCCNurPlanPrintTemplate, ServerObj.EpisodeID, rows);	
				}else{
					AINursePrintAll(locationURL, "DHCNURMoudPrnHLJHD", ServerObj.EpisodeID, rows);			
				}			
			}		
		}
	}
	else{
	//  ��ӡȫ������ƻ���
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
			arrLimit[i]="δֹͣ"			
		}else if(arrLimit[i].toString()=="01"){
			arrLimit[i]="δ����"	
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
        $.messager.alert("��ʾ", "Ŀ��������ֻ��Ϊ����0���������� ", "info", function () {
            $(target).focus();
        });
        return false;
    }
    if (1 != 1) {
        /* �ö���Ŀ�޷��ṩ׼ȷ������������Ŀǰֻ����ɽ���ã�ȥ�������� 2021.6.28
    if ((ServerObj.days!="")&&(Number(playDays) > Number(ServerObj.days))) {
		if ($(".window-mask").is(":visible")){
			return false;
		}
	    $.messager.alert("��ʾ","Ŀ��������: "+ playDays +" ���ܳ�����������: "+ServerObj.days+"��","info",function(){
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
        $.messager.alert("��ʾ", "���ȼ�ֻ��Ϊ��������", "info", function () {
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
//�Ƿ�Ϊ������
function isPositiveInteger(s) {
    var re = /^[0-9]+$/;
    return re.test(s)
}
// ��������������������ؿ�
function ShowAddQLRealateFactorWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '��ѡ��һ���������⣡',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("AddQLRealateFactor");
    var iconCls = "icon-w-add";
    createModalDialog("QuestionDiag", $g("�ֶ������������������"), 350, 200, iconCls, $g("ȷ��"), Content, "SaveQLRealateFactor()");
    $("#QLRealateFactor").focus();
}
// �ֶ�������״̬Ϊ�յķ�������������޸�
function EditQuestionFactor(factorDR) {
    var index = $("#QLRealateFactorTable").datagrid("getRowIndex", factorDR);
    var Rows = $("#QLRealateFactorTable").datagrid("getRows");
    var factorName = Rows[index].factorName;
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("AddQLRealateFactor");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("�޸ķ������������"), 350, 200, iconCls, $g("ȷ��"), Content, "SaveQLRealateFactor(" + factorDR + ")");
    $("#QLRealateFactor").val(factorName).focus();
}
//����������������
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
            msg: '��������ز���Ϊ�գ�',
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
            msg: '������������ʧ�ܣ�' + rtn,
            type: 'error'
        });
    }
}
// ɾ���������������,�������Ŀ����^�ָ�
function DelQLRealateFactor() {
    var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
    if (QLRealateFactorSelRows.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫɾ���ķ�����������أ�',
            type: 'error'
        });
        return false;
    }
    var delfactorDRRArr = new Array();
    for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
        var recordID = QLRealateFactorSelRows[i].recordID;
        if (recordID) {
            $.messager.popover({
                msg: '���ύ�����ݲ���ɾ����',
                type: 'error'
            });
            return false;
        }
        var private = QLRealateFactorSelRows[i].private;
        if (!private) {
            $.messager.popover({
                msg: 'ϵͳ�Զ���������ݲ���ɾ����',
                type: 'error'
            });
            return false;
        }
        delfactorDRRArr.push(QLRealateFactorSelRows[i].factorDR);
    }
    if (delfactorDRRArr.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫɾ���ķ�����������أ�',
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
                msg: 'ɾ��������������سɹ���',
                type: 'success'
            });
            $("#QLRealateFactorTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: 'ɾ���������������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// ������������س���ԭ���
/*function ShowQLRealateFactorCancelWin(){
	destroyDialog("QuestionDiag");
	var sels=$('#QLRealateFactorTable').datagrid('getSelections');
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ����Ҫ�����ķ�����������أ�',type:'error'});
		return false;
	}
	for (var i=0;i<sels.length;i++){
		var recordID=sels[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'δ�ύ�ķ�����������ز��ܳ�����',type:'error'});
			return false;
		}
	}
	var Content=initDiagDivHtml("Cancel");
    var iconCls="";
    createModalDialog("QuestionDiag","�����������������", 350, 200,iconCls,"ȷ��",Content,"CancelQLRealateFactor()");
    InitCancelReason();
}
// ��������س���
function CancelQLRealateFactor(){
	var QLRealateFactorSelRows=$("#QLRealateFactorTable").datagrid("getSelections");
	if (QLRealateFactorSelRows.length ==0) {
		$.messager.popover({msg:'��ѡ����Ҫ�����ķ�����������أ�',type:'error'});
		return false;
	}
	var canelrecordIDRArr=new Array();
	for (var i=0;i< QLRealateFactorSelRows.length ;i++){
		var recordID=QLRealateFactorSelRows[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'δ�ύ�ķ�����������ز��ܳ�����',type:'error'});
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
			$.messager.popover({msg:'����������������سɹ���',type:'success'});
			destroyDialog("QuestionDiag");
			$("#QLRealateFactorTable").datagrid('reload');
			return false;
		}else{
			$.messager.alert("��ʾ","�����������������ʧ�ܣ�"+rtn);
		}
	})
}*/
// �������������
function ShowQLRealateFactorUnUseWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QLRealateFactorTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ���ϵķ�����������أ�',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var recordID = sels[i].recordID;
        var statusName = sels[i].statusName;
        if (statusName == "����") {
            $.messager.popover({
                msg: '" ���� "�ķ�����������ز����ٴ����ϣ�',
                type: 'error'
            });
            return false;
        }
        if (!recordID) {
            $.messager.popover({
                msg: 'δ�ύ�ķ�����������ز������ϣ�',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("UnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("���Ϸ������������"), 350, 200, iconCls, $g("ȷ��"), Content, "UnUseQLRealateFactor()");
    InitUnUseReason();
}
// �������������
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
                msg: '���Ϸ������������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �������Ϸ��������
function RevokeUnUseFactorRecord() {
    var QLRealateFactorSelRows = $("#QLRealateFactorTable").datagrid("getSelections");
    if (QLRealateFactorSelRows.length == 0) {
        $.messager.popover({
            msg: '��ѡ�������ϵķ�����������ؼ�¼��',
            type: 'error'
        });
        return false;
    }
    var unUseRecordIDRArr = new Array();
    for (var i = 0; i < QLRealateFactorSelRows.length; i++) {
        var recordID = QLRealateFactorSelRows[i].recordID;
        var statusName = QLRealateFactorSelRows[i].statusName;
        if (statusName != "����") {
            $.messager.popover({
                msg: '��" ���� "״̬�ķ�����������ز��ܳ������ϣ�',
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
                msg: '�������Ϸ������������ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// ������������Ŀ���
function ShowAddQuestionTargetWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '��ѡ��һ���������⣡',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("AddQuestionTarget");
    var iconCls = "icon-w-add";
    createModalDialog("QuestionDiag", $g("�ֶ���������Ŀ��"), 350, 200, iconCls, $g("ȷ��"), Content, "SaveQuestionTarget()");
    $("#QuestionTarget").focus();
}
// ����Ŀ�걣��
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
            msg: '�����뻤��Ŀ�꣡',
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
            msg: '���滤��Ŀ��ʧ�ܣ�' + rtn,
            type: 'error'
        });
        $("#QuestionTarget").focus();
    }
}
// �ֶ�������״̬Ϊ�յĻ���Ŀ�������޸�
function EditQuestionTarget(goalDR) {
    var index = $("#QuestionTargetTable").datagrid("getRowIndex", goalDR);
    var Rows = $("#QuestionTargetTable").datagrid("getRows");
    var goalName = Rows[index].goalName;
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("EditQuestionTarget");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("�޸Ļ���Ŀ��"), 350, 200, iconCls, $g("ȷ��"), Content, "SaveQuestionTarget(" + goalDR + ")");
    $("#QuestionTarget").val(goalName).focus();
}
// ɾ������Ŀ��,�������Ŀ����^�ָ�
function DelQuestionTarget() {
    var QueTargetSelRows = $("#QuestionTargetTable").datagrid("getSelections");
    if (QueTargetSelRows.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫɾ���Ļ���Ŀ�꣡',
            type: 'error'
        });
        return false;
    }
    var delGoalDRArr = new Array();
    for (var i = 0; i < QueTargetSelRows.length; i++) {
        var recordID = QueTargetSelRows[i].recordID;
        if (recordID) {
            $.messager.popover({
                msg: '���ύ�Ļ���Ŀ�겻��ɾ����',
                type: 'error'
            });
            return false;
        }
        var dataSource = QueTargetSelRows[i].dataSource;
        if (dataSource == $g("ϵͳ����")) {
            $.messager.popover({
                msg: 'ϵͳ�Զ�����Ļ���Ŀ�겻��ɾ����',
                type: 'error'
            });
            return false;
        }
        delGoalDRArr.push(QueTargetSelRows[i].goalDR);
    }
    if (delGoalDRArr.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫɾ���Ļ���Ŀ�꣡',
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
                msg: 'ɾ������Ŀ��ɹ���',
                type: 'success'
            });
            $("#QuestionTargetTable").datagrid('reload');
        } else {
            $.messager.popover({
                msg: 'ɾ������Ŀ��ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// ��������Ŀ�곷����
/*function ShowQuestionTargetCancelWin(){
	destroyDialog("QuestionDiag");
	var sels=$('#QuestionTargetTable').datagrid('getSelections');
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ����Ҫ�����Ļ���Ŀ�꣡',type:'error'});
		return false;
	}
	for (var i=0;i<sels.length;i++){
		var recordID=sels[i].recordID;
		if (!recordID) {
			$.messager.popover({msg:'δ�ύ�Ļ���Ŀ�겻�ܳ�����',type:'error'});
			return false;
		}
	}
	var Content=initDiagDivHtml("Cancel");
    var iconCls="";
    createModalDialog("QuestionDiag","��������Ŀ��", 350, 200,iconCls,"ȷ��",Content,"CancelQuestionTarget()");
    InitCancelReason();
}
// ��������Ŀ��
function CancelQuestionTarget(){
	var QueSelRows=$("#NurQuestionTable").datagrid("getSelections");
	if (QueSelRows.length ==0) {
		$.messager.popover({msg:'����ѡ�������⣡',type:'error'});
		return false;
	}else if(QueSelRows.length > 1){
		$.messager.popover({msg:'��ѡ��һ���������⣡',type:'error'});
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
			$.messager.popover({msg:'δ�ύ�Ļ���Ŀ�겻�ܳ�����',type:'error'});
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
			$.messager.popover({msg:'��������Ŀ��ɹ���',type:'success'});
			destroyDialog("QuestionDiag");
			$("#QuestionTargetTable").datagrid('load');
		}else{
			$.messager.alert("��ʾ","��������Ŀ��ʧ�ܣ�"+rtn);
		}
	})
}*/
// ��������Ŀ�����Ͽ�
function ShowQuestionTargetUnUseWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QuestionTargetTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫ���ϵĻ���Ŀ�꣡',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var recordID = sels[i].recordID;
        if (!recordID) {
            $.messager.popover({
                msg: 'δ�ύ�Ļ���Ŀ�겻�����ϣ�',
                type: 'error'
            });
            return false;
        }
        var goalStatus = sels[i].goalStatus;
        if (goalStatus == "����") {
            $.messager.popover({
                msg: '��" ���� "�Ļ���Ŀ���¼�����ٴ����ϣ�',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("UnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("���ϻ���Ŀ��"), 350, 200, iconCls, $g("ȷ��"), Content, "UnUseQuestionTarget()");
    InitUnUseReason();
}
// ���ϻ���Ŀ��
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
                msg: '���ϻ���Ŀ��ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �������ϻ���Ŀ��
function RevokeUnUseQuestionTarget() {
    var sels = $("#QuestionTargetTable").datagrid("getSelections");
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ�������ϵĻ���Ŀ���¼��',
            type: 'error'
        });
        return false;
    }
    var unUseRecordIDRArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var recordID = sels[i].recordID;
        var goalStatus = sels[i].goalStatus;
        if (goalStatus != "����") {
            $.messager.popover({
                msg: '��" ���� "�Ļ���Ŀ���¼���ܳ������ϣ�',
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
                msg: '�������ϻ���Ŀ��ʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �������������ʩ��
function ShowAddQuestionMeasureWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#NurQuestionTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    } else if (sels.length > 1) {
        $.messager.popover({
            msg: '��ѡ��һ���������⣡',
            type: 'error'
        });
        return false;
    }
    var Content = initDiagDivHtml("AddQuestionMeasure");
    var iconCls = "icon-w-add";
    // gaoshan add -- 410, 400
    createModalDialog("QuestionDiag", $g("���������ʩ"), 410, 337, iconCls, $g("ȷ��"), Content, "SaveQuestionMeasure()");
    InitQuestionMeasureWin();
    // ������ʩ�Ҽ�����ҽ�� gaoshan add 20210609 start
    rightHandler('TextareaElement_measure')
    // RefHandler('TextareaElement_measure',false,true,false);
    // end
}

// ��д�����ķ��� start
var curElement = null;

function rightHandler(formId) {
    var selector = $.type(formId) == 'object' ? formId : '#' + formId;
    $(selector).bind('contextmenu', function (e) {
        if ($('#menu').length == 0) {
            $('body').append(document.getElementById('menuTemplate').innerHTML);
            $('#menu').menu();
        }
        $('#menu').empty();
        //�������
        $('#menu').menu('appendItem', {
            id: 'menuRefer',
            text: '����',
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

    // ֻ��ҽ�� ҳǩ
    var tabItems = new Array();
    tabItems.push("Order")

    var topFrame = topWindow(window);

    // 2021.6.21 update
    topFrame.$('body').remove('#dialogRefer2'); //�Ƴ����ڵ�Dialog
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

// ��ȡurl����
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

// �ж��Ƿ��ǲ�����ת��ʶ
function isRedirect() {
    var cspRedirect = getQueryVariable("Redirect")
    // �ɻ�������ת������ƻ�
    if (cspRedirect == "1") {
        return true;
    }
    return false;
}

function getRealObj() {
    var parentWin = window.parent.document.getElementById("dialogRefer2");
    var dialogObj = $('#dialogRefer2')
    // �ɻ�������ת������ƻ�
    if (isRedirect()) {
        var topFrame = topWindow(window);
        dialogObj = topFrame.$('#dialogRefer2') //$(parentWin)
    }
    return dialogObj;
}

/**
 * @description: ����
 */
function referHandlerClick(tabs) {
    var dialogObj = getRealObj()

    // url ����
    //var xx = decodeURI(decodeURI(getQueryVariable("formatItemValue")))

    //var tabsArr=["Order"];
    //var url = "nur.hisui.nurseRefer.comm.csp?EpisodeID=" + EpisodeID + "&Tabs=" + tabsArr.join(",") ;

    var url = "nur.hisui.nurseplan.refer.csp?EpisodeID=" + EpisodeID + "&Tabs=" + tabs;
    // MWToken ����
    url = getIframeUrl(url);
    // ������ת��ʶ
    var isRedirectFlag = isRedirect()
    var initWidth = $(window).width() - 600
    if (isRedirectFlag) {
        initWidth = $(window).width() - 300
    }
    dialogObj.dialog({
        // $('#dialogRefer2').dialog({  
        title: '����',
        width: initWidth,
        height: $(window).height() - 10,
        cache: false,
        content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true
    });
    //$("#dialogRefer2").dialog("open");
    dialogObj.dialog("open");
}

function sureReferHandler() { // �ο� rightClickHandler.js ����
    var topFrame = topWindow(window);

    var groupID = 'groupOrder';
    var result = '';

    var subWin = topFrame.$("#iframeRefer")[0].contentWindow
    var rows = subWin.$('#dataGrid').datagrid('getSelections');
    if (rows.length == 0) {
        topFrame.$.messager.popover({
            msg: '��ѡ����Ҫ��������ݣ�',
            type: 'error'
        });
        return;
    }
    var wordsArr = subWin.$('#' + groupID).keywords('getSelected');
    if (wordsArr.length == 0) {
        topFrame.messager.popover({
            msg: '��ѡ����Ҫ������У�',
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
        result = !!result ? result + '��' + subResult : subResult;
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

// ��ʼ�������ʩ��������
function InitQuestionMeasureWin() {
    // ��ʩ���
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
            // todo �Ż� �ĳ�queryֱ�ӷ�����ʾֵ
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
    // �������
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
    // ִ��Ƶ��
    $("#InterventionFreq").combobox({
        // ���Ӿ���id��� 2021.7.5
        url: $URL + "?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionFreq&rows=99999&episodeID=" + ServerObj.EpisodeID,
        mode: 'remote',
        method: "Get",
        multiple: false,
        selectOnNavigation: true,
        valueField: 'id',
        textField: 'name',
        disabled: PageLogicObj.m_SelQuestionObj.isNQNursingAdvice == "Y" ? false : true,
        loadFilter: function (data) {
            // todo �Ż� �ĳ�queryֱ�ӷ�����ʾֵ
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
                    InitWeekFreqWin($g("��Ƶ������ѡ��"));
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
// ���滤���ʩ
function SaveQuestionMeasure(intervDR) {
    if (!intervDR) intervDR = "";
    if (intervDR) {
        var index = $("#QuestionMeasureTable").datagrid("getRowIndex", intervDR);
        var QueRows = $("#QuestionMeasureTable").datagrid("getRows");
        var intervName = QueRows[index].intervName;
        var NewintervName = $.trim($("#QuestionMeasure").val());
        if (!NewintervName) {
            $.messager.popover({
                msg: '�����ʩ����Ϊ�գ�',
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
                    msg: '�޸Ļ����ʩ�ɹ���',
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
                    msg: '�޸Ļ����ʩʧ�ܣ�' + rtn,
                    type: 'error'
                });
            }
        })
    } else {
        var InterventionType = $("#InterventionType").combobox('getValue');
        var index = $.hisui.indexOfArray($('#InterventionType').combobox("getData"), "id", InterventionType);
        if (index < 0) {
            $.messager.popover({
                msg: '��ѡ���ʩ���',
                type: 'error'
            });
            $('#InterventionType').next('span').find('input').focus();
            return false;
        }
        var measure = $.trim($("#TextareaElement_measure").val());
        if (!measure) {
            $.messager.popover({
                msg: '�������ʩ��������',
                type: 'error'
            });
            $('#TextareaElement_measure').focus();
            return false;
        }
        // ȥ��������� 2021.7.3
        var InterventionRecord = "" //$("#InterventionRecord").combobox('getValue');
        if (!InterventionRecord) InterventionRecord = "";
        var InterventionRecordData = "" //$('#InterventionRecord').combobox("getData");
        if (InterventionRecord) {
            var index = $.hisui.indexOfArray(InterventionRecordData, "ID", InterventionRecord);
            if (index < 0) {
                $.messager.popover({
                    msg: '������������ѡ��������أ�',
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
                    msg: '��ѡ��ִ��Ƶ�ʣ�',
                    type: 'error'
                });
                $('#InterventionFreq').next('span').find('input').focus();
                return false;
            }
        }
        var startdate = $("#startdate").combobox('getValue');
        if (!startdate) {
            $.messager.popover({
                msg: '�������������ڣ�',
                type: 'error'
            });
            $('#startdate').next('span').find('input').focus();
            return false;
        }
        var enddate = $("#enddate").combobox('getValue');
        if (enddate) {
            if (CompareDate(startdate, enddate)) {
                $.messager.popover({
                    msg: 'ͣ�����ڲ��������������ڣ�',
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
                    msg: '���������ʩ�ɹ���',
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
                    msg: '���������ʩʧ�ܣ�' + rtn,
                    type: 'error'
                });
            }
        })
    }
}
// �ֶ�������״̬Ϊ�յĻ����ʩ�����޸�
function EditQuestionMeasure(intervDR) {
    PageLogicObj.m_selWeek = "";
    var index = $("#QuestionMeasureTable").datagrid("getRowIndex", intervDR);
    var QueRows = $("#QuestionMeasureTable").datagrid("getRows");
    var intervName = QueRows[index].intervName;
    destroyDialog("QuestionDiag");
    var Content = initDiagDivHtml("EditQuestionMeasure");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("�޸Ļ����ʩ"), 350, 200, iconCls, $g("ȷ��"), Content, "SaveQuestionMeasure(" + intervDR + ")");
    $("#QuestionMeasure").val(intervName).focus();
}
// ɾ�������ʩ,��������ʩ��^�ָ�
function DelQuestionMeasure() {
    var QuestionMeasureSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
    if (QuestionMeasureSelRows.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫɾ���Ļ����ʩ��',
            type: 'error'
        });
        return false;
    }
    var delintervDRArr = new Array();
    var delrowIDArr = new Array();
    for (var i = 0; i < QuestionMeasureSelRows.length; i++) {
        var dataSource = QuestionMeasureSelRows[i].dataSource;
        if (dataSource == $g("ϵͳ����")) {
            $.messager.popover({
                msg: 'ϵͳ����Ļ����ʩ����ɾ����',
                type: 'error'
            });
            return false;
        }
        var statusName = QuestionMeasureSelRows[i].statusName;
        if ((statusName == $g("ֹͣ")) || (statusName == $g("����"))) {
            $.messager.popover({
                msg: 'ֹͣ/���ϵĻ����ʩ��ֹɾ����',
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
                msg: 'ɾ�������ʩ�ɹ���',
                type: 'success'
            });
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: 'ɾ�������ʩʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �����ʩֹͣ����
function ShowQuestionMeasureStopWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: '��ѡ����Ҫֹͣ�Ļ����ʩ��',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        var rowID = sels[i].rowID;
        if (rowID == "") {
            $.messager.popover({
                msg: 'δ�ύ�Ļ����ʩ����ֹͣ��',
                type: 'error'
            });
            return false;
        } else if (statusName == $g("����")) {
            $.messager.popover({
                msg: '�����ϵĻ����ʩ����ֹͣ��',
                type: 'error'
            });
            return false;
        } else if (statusName == $g("ֹͣ")) {
            $.messager.popover({
                msg: '��ֹͣ�Ļ����ʩ�����ٴ�ֹͣ��',
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("NurQuestionnMeasureStop");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("�����ʩֹͣ"), 250, 207, iconCls, $g("ȷ��"), Content, "NurQuestionMeasureStop()");
    InitStopReason();
    $("#MeasureStopDate").datebox("setValue", ServerObj.CurrentDate);
    $("#MeasureStopTime").timespinner('setValue', GetCurTime("N"));
    $("#MeasureStopTime").focus();
}
// �����ʩֹͣ
function NurQuestionMeasureStop() {
    var MeasureStopDate = $("#MeasureStopDate").datebox("getValue");
    if (!MeasureStopDate) {
        $.messager.popover({
            msg: 'ֹͣ���ڲ���Ϊ��',
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
        //  �������:2795419  ����ƻ��Ĵ�ʩֹͣʱ�����Ƶ�������Ҫ�ſ�����ʩ�Ŀ�ʼʱ��
        var rows = $("#QuestionMeasureTable").datagrid('getSelections');
        for (var i=0; i<rows.length;i++){
	        var startDate = rows[i].startDatetime.split(" ")[0]
	        startDate = Date.parse(startDate.replace(/\-/g,'/'))
	        StopDate = Date.parse(MeasureStopDate.replace(/\-/g,'/'))
	        if (startDate>StopDate){
		        $.messager.popover({
		            msg: 'ֹͣ���ڲ���С�ڿ�ʼ����',
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
                msg: "ֹͣ����Ӧ���ڵ��ڵ��죺" + myformatter(end) + "��",
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
            msg: "ֹͣʱ�䲻��Ϊ�գ�",
            type: 'error'
        });
        $('#MeasureStoptime').focus();
        return false;
    }
    if (!IsValidTime(MeasureStopTime)) {
        $.messager.popover({
            msg: "ֹͣʱ���ʽ����ȷ! ʱ:��,��11:05",
            type: 'error'
        });
        $('#MeasureStopTime').next('span').find('input').focus();
        return false;
    }
    //  �������:2795419  ����ƻ��Ĵ�ʩֹͣʱ�����Ƶ�������Ҫ�ſ�����ʩ�Ŀ�ʼʱ��
    for (var i=0; i<rows.length;i++){
	    var startDateTime = rows[i].startDatetime;
	    MeasureStopDateTime = MeasureStopDate+" "+MeasureStopTime;
	    if (+new Date(startDateTime)>+new Date(MeasureStopDateTime)){
	        $.messager.popover({
	            msg: 'ֹͣʱ�䲻��С�ڿ�ʼʱ��',
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
            msg: "ֹͣʱ��Ӧ���ڵ�ǰʱ�䣡",
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
                msg: 'ֹͣ�����ʩ�ɹ���',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: 'ֹͣ�����ʩʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
// �����ʩ���ϵ���
function ShowQuestionMeasureUnUseWin() {
    destroyDialog("QuestionDiag");
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: "��ѡ����Ҫ���ϵĻ����ʩ��",
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        var rowID = sels[i].rowID;
        if (rowID == "") {
            $.messager.popover({
                msg: "δ�ύ�Ļ����ʩ�������ϣ�",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("����")) {
            $.messager.popover({
                msg: "�����ϵĻ����ʩ�����ٴ����ϣ�",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("ֹͣ")) {
            $.messager.popover({
                msg: "��ֹͣ�Ļ����ʩ�������ϣ�",
                type: 'error'
            });
            return false;
        }
    }
    var Content = initDiagDivHtml("NurQuestionnMeasureUnUse");
    var iconCls = "icon-w-edit";
    createModalDialog("QuestionDiag", $g("���ϻ����ʩ"), 350, 205, iconCls, $g("ȷ��"), Content, "NurQuestionMeasureUnUse()");
    InitUnUseReason();
}
//���ϻ����ʩ
function NurQuestionMeasureUnUse() {
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: "��ѡ����Ҫ���ϵĻ����ʩ��",
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
                msg: "δ�ύ�Ļ����ʩ�������ϣ�",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("����")) {
            $.messager.popover({
                msg: "�����ϵĻ����ʩ�����ٴ����ϣ�",
                type: 'error'
            });
            return false;
        } else if (statusName == $g("ֹͣ")) {
            $.messager.popover({
                msg: "��ֹͣ�Ļ����ʩ�������ϣ�",
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
                msg: '���ϻ����ʩ�ɹ���',
                type: 'success'
            });
            destroyDialog("QuestionDiag");
            $("#QuestionMeasureTable").datagrid('reload');
            return false;
        } else {
            $.messager.popover({
                msg: '���ϻ����ʩʧ�ܣ�' + rtn,
                type: 'error'
            });
        }
    })
}
//�������ϻ����ʩ
function RevokeUnUseQuestionMeasure() {
    var sels = $('#QuestionMeasureTable').datagrid('getSelections');
    if (sels.length == 0) {
        $.messager.popover({
            msg: "��ѡ����Ҫ�������ϵĻ����ʩ��",
            type: 'error'
        });
        return false;
    }
    var UnUserowIDArr = new Array();
    for (var i = 0; i < sels.length; i++) {
        var statusName = sels[i].statusName;
        if (statusName != $g("����")) {
            $.messager.popover({
                msg: '��" ���� "״̬�Ļ����ʩ���ܳ������ϣ�',
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
                msg: '�������ϻ����ʩʧ�ܣ�' + rtn,
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
    var h = myDate.getHours(); //��ȡ��ǰСʱ��(0-23)
    var m = myDate.getMinutes(); //��ȡ��ǰ������(0-59)
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
    if (statusName.indexOf($g("����")) >= 0) {
        FontColor = ServerObj.CancelFontColor;
    } else if (statusName.indexOf($g("����")) >= 0) {
        FontColor = ServerObj.UnUserFontColor;
    } else if ((statusName.indexOf($g("ֹͣ")) >= 0) && (statusName != $g("δֹͣ"))) {
        FontColor = ServerObj.StopFontColor;
    }else if ((ServerObj.QPCCOpenNurEvaluate=="Y")&&(statusName.indexOf($g("����")) >= 0) && (statusName != $g("δ����"))) {
        FontColor = ServerObj.StopFontColor;
    }
    return FontColor;
}

function SetNurPalnBtnStatus(statusName) {
    // ����״̬Ϊ���ϡ����� --�����������İ�ť���Ƿǻ���Ҳ���ύ��ť
    if ((statusName == $g("�ѳ���")) || (statusName == $g("������"))) {
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
    // �����ϵĻ���������ܳ�������
    if (statusName == "������") {
        $("#QuestionRevokeUnUse").linkbutton('enable');
    } else {
        $("#QuestionRevokeUnUse").linkbutton('disable');
    }

}
function SetNurPalnBtnCstatus(cstatus) {
	// �����۵Ļ���������ܳ�������
    if (cstatus == "������") {
        $("#QuestionRevokeEvaluate").linkbutton('enable');
    } else {
        $("#QuestionRevokeEvaluate").linkbutton('disable');
    }
}
//����ƻ��޸�Ȩ������
function SetNurPalnBtnPermission(InsertUserId,PlanReviewUserId) {
	// ����ƻ������ϡ��������ϡ����ۡ��������ۡ�ֹͣ�Ȳ���Ȩ������
	var QPCCNurPlanPermission=ServerObj.QPCCNurPlanPermission;
	// �Ƿ���мƻ����Ȩ��
	var QPCCNurPlanReviewPermission=ServerObj.QPCCNurPlanReviewPermission;
	// �Ƿ��������ƻ����Ȩ��
	var QPCCNPRCancelPermission=ServerObj.QPCCNPRCancelPermission;
	
	/*
	if (QPCCNurPlanPermission=="S&L"){
		//��ѡ �����ˡ��͡���ʿ�����������ߺͻ�ʿ���л���ƻ����޸ġ�ɾ�������ϡ����������ۡ�ֹͣ�Ȳ���Ȩ������
		if (!((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(session['LOGON.USERNAME']==InsertUser))){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}
	}else if (QPCCNurPlanPermission=="S"){
		//��ѡ�����ˡ���ֻ�д������л���ƻ����޸ġ�ɾ�������ϡ����������ۡ�ֹͣ�Ȳ���Ȩ������
		if (!(session['LOGON.USERNAME']==InsertUser)){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
	}else if(QPCCNurPlanPermission=="L") {
		//��ѡ����ʿ������ֻ�л�ʿ���л���ƻ����޸ġ�ɾ�������ϡ����������ۡ�ֹͣ�Ȳ���Ȩ������
		if (!(session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}		
	} else if (QPCCNurPlanPermission==""){
		//���δ��ѡ�����ˡ��򡰻�ʿ���������ʾ���������л�ʿ���ɲ���������Ȩ��
	}
	*/
	var LOGONGROUPID = "@"+session['LOGON.GROUPID']+"@"
	if (!((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(ServerObj.LeaderGROUPID.indexOf(LOGONGROUPID)!=-1)||(session['LOGON.USERID']==InsertUserId))){
		// ���ǻ�ʿ�����Ǳ��ˣ������ˣ�
		//δ��ѡ�����ˡ��򡾻�ʿ���������������л�ʿ���ɲ���������Ȩ��	
		if (QPCCNurPlanPermission!=""){					
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
		//���Ȩ�޹�ѡ �ǿ�  �û���ӵ�л���ƻ����Ȩ��
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			if (QPCCNurPlanReviewPermission!=""){
				$("#NurPlanReview").linkbutton('disable');
			}else{
				$("#NurPlanReview").linkbutton('enable');
			}
		}
		//˭���˭����
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			//���ǻ�ʿ�����Ǵ����˲��������		
			//���Ȩ�޹�ѡ �ǿ�  �û���ӵ�л���ƻ��������Ȩ��
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				if (QPCCNPRCancelPermission!=""){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');
				}
			}
		}
	}else if (((session['LOGON.GROUPDESC'].indexOf('��ʿ��')!=-1)||(ServerObj.LeaderGROUPID.indexOf(LOGONGROUPID)!=-1))&&(session['LOGON.USERID']!=InsertUserId)){
		//�ǻ�ʿ�����Ǳ��ˣ������ˣ�
		//��ѡ�����ˡ���ʿ����ӵ�л���ƻ������ϡ��������ϡ����ۡ��������ۡ�ֹͣ�Ȳ���Ȩ������
		if(QPCCNurPlanPermission=="S"){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
		// ��ѡ�����ˡ���ʿ����ӵ�л���ƻ����Ȩ��
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			if (QPCCNurPlanReviewPermission=="S"){
				$("#NurPlanReview").linkbutton('disable');
			}else{
				$("#NurPlanReview").linkbutton('enable');
			}
		}
		//˭���˭����
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			//�ǻ�ʿ�����Ǵ����˲��������
			// ��ѡ�����ˡ���ʿ����ӵ�л���ƻ��������Ȩ��
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				if (QPCCNPRCancelPermission=="S"){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');
				}
			}
			
		}
	}else if ((session['LOGON.USERID']==InsertUserId)&&((session['LOGON.GROUPDESC'].indexOf('��ʿ��')==-1)||(ServerObj.LeaderGROUPID.indexOf(LOGONGROUPID)==-1))){
		// ���ǻ�ʿ���Ǳ��� �������ˣ�
		// ��ѡ�����ˡ��򡾱��˺ͻ�ʿ�����������л���ƻ������ϡ��������ϡ����ۡ��������ۡ�ֹͣ�Ȳ���Ȩ������
		if (QPCCNurPlanPermission=="L"){
			$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('disable');
		}else{
			//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		}
		// ��ѡ����ʿ���������߲�ӵ�л���ƻ����Ȩ��
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			if (QPCCNurPlanReviewPermission=="L"){
				$("#NurPlanReview").linkbutton('disable');
			}else{
				$("#NurPlanReview").linkbutton('enable');
			}
		}
		//˭���˭����
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			// ���ǻ�ʿ���Ǵ����˲��������
			// ��ѡ����ʿ���������߲�ӵ�л���ƻ��������Ȩ��
			// ��ѡ�����ˡ������߲�ӵ�л���ƻ��������Ȩ��
			// �����Ȩ�޹�ѡ Ϊ�� �����߲�ӵ�л���ƻ��������Ȩ��			
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				if (QPCCNurPlanReviewPermission!=""){
					$("#CancelNurPlanReview").linkbutton('disable');
				}else{
					$("#CancelNurPlanReview").linkbutton('enable');
				}
			}
		}
	}else{
		//�ǻ�ʿ���Ǳ���(������)
		//$("#QuestionEvaluate,#QuestionRevokeEvaluate,#QuestionStop,#QuestionUnUse,#QuestionRevokeUnUse").linkbutton('enable');
		if (ServerObj.QPCCOpenNurPlanReview=="Y"){
			$("#NurPlanReview").linkbutton('enable');
		}
		//˭���˭����
		if(session['LOGON.USERID']==PlanReviewUserId){
			$("#CancelNurPlanReview").linkbutton('enable');
		}else{
			//�ǻ�ʿ���Ǵ����˲��������
			if (ServerObj.QPCCOpenCancelNurPlanReview=="Y"){
				// ��ѡ�����ˡ������߲�ӵ�л���ƻ��������Ȩ��
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
            msg: '��ѡ�����ڣ�',
            type: 'error'
        });
        return false;
    }
    var weekArr = new Array();
    for (var i = 0; i < selRows.length; i++) {
        weekArr.push(selRows[i].id);
    }
    if ($("#InterventionFreq").length) {
        // ���������ʩ-ִ��Ƶ��ѡ����Ƶ��
        PageLogicObj.m_selWeek = weekArr.join("|");
        $("#WeekFreqWin").window("close");
    } else {
        // �����ʩ�޸�ִ��Ƶ��
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
                msg: "��ѡ��/����ֹͣԭ��",
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
                msg: "��ѡ��/���볷��ԭ��",
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
                msg: "��ѡ��/��������ԭ��",
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
            msg: '����ѡ�������⣡',
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
                    msg: "���ȼ�Ϊ��ʱ���������ȼ����е�����",
                    type: 'error'
                });
                return false;
            }
            var DwNQRECSerialNo = todown.NQRECSerialNo;
            if (!DwNQRECSerialNo) {
                $.messager.popover({
                    msg: "���ȼ�Ϊ��ʱ���������ȼ����е�����",
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
                    msg: "���ȼ�Ϊ��ʱ���������ȼ����е�����",
                    type: 'error'
                });
                return false;
            }
            var DwNQRECSerialNo = todown.NQRECSerialNo;
            if (!DwNQRECSerialNo) {
                $.messager.popover({
                    msg: "���ȼ�Ϊ��ʱ���������ȼ����е�����",
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
///��������
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
                        title: $g('����'),
                        width: 520
                    }
                ]
            ],
            data: [{
                    "id": "1",
                    "text": $g("����һ")
                }, {
                    "id": "2",
                    "text": $g("���ڶ�")
                }, {
                    "id": "3",
                    "text": $g("������")
                },
                {
                    "id": "4",
                    "text": $g("������")
                }, {
                    "id": "5",
                    "text": $g("������")
                }, {
                    "id": "6",
                    "text": $g("������")
                },
                {
                    "id": "7",
                    "text": $g("������")
                }
            ]
        });
    }
}


//���ࡢ����
function toggleExecInfo(){
	var Height=Math.round($("#QuestionTreeSearchPanel").height())+1;
	//if ($("#QuestionTypeKW").hasClass('expanded')){
	//	$("#QuestionTypeKW").removeClass('expanded');
	if ($('#moreBtn').linkbutton("options").text=="����"){		
		$("#QuestionTypeKW").removeClass('expanded');	
		$("#moreBtn").linkbutton({ iconCls: 'icon-w-arrow-up'});
		$('#moreBtn').linkbutton({text:'����'});
		$("#QuestionTypeKW").keywords({items: PageLogicObj.m_QuestionTypeKW});
		var Height=$("#QuestionTreePanel").height()+parseInt((Height-$("#QuestionTreeSearchPanel").height()));		
		//$("#moreBtn")[0].innerText="����";
	    //$("#QuestionTypeKW").hide(); //#dashline
	    //setHeight("-39");
	}else{
		//$("#QuestionTypeKW").addClass('expanded');
		$("#moreBtn").linkbutton({ iconCls: 'icon-w-arrow-down'});
		$('#moreBtn').linkbutton({text:'����'});		
		$("#QuestionTypeKW").keywords({items: PageLogicObj.m_QuestionTypeKWLight});
		var Height=$("#QuestionTreePanel").height()+parseInt((Height-$("#QuestionTreeSearchPanel").height()));
		//$("#moreBtn")[0].innerText="����";
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
// �޸�����ʱ��
function EditDateTime(type){
	var queids = new Array();
	var isAdvice= new Array();  //�Ƿ����ɻ���
	var row = $("#NurQuestionTable").datagrid('getSelections');
    if (row.length == 0) {
        $.messager.popover({
            msg: '����ѡ�������⣡',
            type: 'error'
        });
        return false;
    }
    for (var i = 0; i < row.length; i++){
	    queids.push(row[i].recordId);
	    isAdvice.push(row[i].isNQNursingAdvice);
	    if (row[i].source!="�ֶ����"){
		    $.messager.popover({
            msg: '��ѡ���ֶ���ӵĻ������⣡',
            type: 'error'
        });
        return false;
		}else if (row[i].result == "�ѽ��") {
        $.messager.popover({
            msg: '�û��������ѽ���������޸�����ʱ��',
            type: 'error'
        });
        return false;
    	} else if (row[i].statusName == "��ֹͣ") {
        $.messager.popover({
            msg: '�û���������ֹͣ�������޸�����ʱ��',
            type: 'error'
        });
        return false;
    	} else if (row[i].statusName == "������") {
        $.messager.popover({
            msg: '�û������������ϣ������޸�����ʱ��',
            type: 'error'
        });
        return false;
    	}else if (row[i].statusName == "�ѳ���") {
        	$.messager.popover({
            msg: '�û��������ѳ����������޸�����ʱ��',
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
	            msg: '����ѡ�������������أ�',
	            type: 'error'
	        });
	        return false;
	    }else{
		    var count=0
		    for (var i = 0; i < qlrtrow.length; i++){
			    if (qlrtrow[i].statusName != "�ύ") {			    
			        $.messager.popover({
			            msg: '���ύ�ķ�����������ز����޸�ʱ��',
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
	            msg: '����ѡ����Ŀ�꣡',
	            type: 'error'
	        });
	        return false;
	    }else{
		    var count=0
		    for (var i = 0; i < targetrow.length; i++){
			    if (targetrow[i].goalStatus != "�ύ") {			    
			        $.messager.popover({
			            msg: '���ύ�Ļ���Ŀ�겻���޸�ʱ��',
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
	            msg: '����ѡ�����ʩ��',
	            type: 'error'
	        });
	        return false;
	    }else{
		    var count=0
		    for (var i = 0; i < interrow.length; i++){
			    if (interrow[i].statusName != "�ύ") {			    
			        $.messager.popover({
			            msg: '���ύ�Ļ����ʩ�����޸�ʱ��',
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
// �޸�����ʱ�䵯��
function ShowEditDateTimeWin(type,queidstr,isAdvicestr){
	destroyDialog("QuestionDiag");
	var iconCls = "icon-w-edit";
	var Content = initDiagDivHtml("EditDataTime");
	if (type=="Question"){	  
	    createModalDialog("QuestionDiag", $g("�޸�����ʱ��"), 350, 165, iconCls, $g("ȷ��"), Content, "SaveQuestionDateTime()");
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
	    createModalDialog("QuestionDiag", $g("�޸�����ʱ��"), 350, 165, iconCls, $g("ȷ��"), Content, "SaveQLRealateDateTime(\""+queidstr+"\")");
		$('#tr-LimitEditDataTime').hide();
	}else if (type=="Target"){		
	    createModalDialog("QuestionDiag", $g("�޸�����ʱ��"), 350, 165, iconCls, $g("ȷ��"), Content, "SaveTargetDateTime(\""+queidstr+"\")");
		$('#tr-LimitEditDataTime').hide();
	}else if (type=="Intervention"){		
	    createModalDialog("QuestionDiag", $g("�޸�����ʱ��"), 350, 165, iconCls, $g("ȷ��"), Content, "SaveInterventionDateTime(\""+queidstr+"\",\""+isAdvicestr+"\")");
		$('#tr-LimitEditDataTime').hide();
	}
}
// ���滤�����ⴴ��ʱ��
function SaveQuestionDateTime(){
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	var LimitEditDataTime=$('#LimitEditDataTimeBox').datetimebox('getValue');
	var now = new Date();
	//var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	var nowDateTime=now.getFullYear()+"-"+('0' + (now.getMonth() + 1)).slice(-2)+"-"+('0' + now.getDate()).slice(-2)+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
	
	//ʱ�������Χ����ϵͳ��ǰʱ���뻼�����ʱ��֮�䣬����޸�ʱ�䳬�����������Ϣ����
	if(LimitEditDataTime==""){
		$.messager.popover({
            msg: 'δ�ܻ�ȡ��Ժʱ�䣡',
            type: 'error'
        });
		return false;
	}
	if(!CompareDateFromCreatToNow(datetime,LimitEditDataTime,nowDateTime)){
		$.messager.popover({
            msg: '�޸�ʱ�䳬��������Ժʱ���ϵͳ��ǰʱ�䣡',
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
                msg: "����ʧ�ܣ��޸�ʱ����ڵ�ǰʱ��" ,
                type: 'error'
            });
        }else {
            $.messager.popover({
                msg: "����ʧ�ܣ�" + rtn,
                type: 'error'
            });
        }
    })

}
// ���������������ش���ʱ��
function SaveQLRealateDateTime(queidstr){
	var row = $("#QLRealateFactorTable").datagrid('getSelections');
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	// ���Ʒ�������������޸�ʱ�䣺��ǰʱ��2����
	if(!isBeforeTwoDays(datetime)) {
        $.messager.popover({
            msg: "�޸�ʱ�䷶Χ�ǵ�ǰʱ��2������ " ,
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
            msg: "��ѡ��������ʱ��" ,
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
                msg: "����ʧ�ܣ��޸�ʱ����ڵ�ǰʱ��" ,
                type: 'error'
            });
        }else {
            $.messager.popover({
                msg: "����ʧ�ܣ�" + rtn,
                type: 'error'
            });
        }
    })
}
// ���滤��Ŀ�괴��ʱ��
function SaveTargetDateTime(queidstr){
	var row = $("#QuestionTargetTable").datagrid('getSelections');
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	// ���ƻ���Ŀ���޸�ʱ�䣺��ǰʱ��2����
	if(!isBeforeTwoDays(datetime)) {
        $.messager.popover({
            msg: "�޸�ʱ�䷶Χ�ǵ�ǰʱ��2������ " ,
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
            msg: "��ѡ��������ʱ��" ,
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
                msg: "����ʧ�ܣ��޸�ʱ����ڵ�ǰʱ��" ,
                type: 'error'
            });
        }else {
            $.messager.popover({
                msg: "����ʧ�ܣ�" + rtn,
                type: 'error'
            });
        }
    })
}
// ���滤���ʩ����ʱ��
function SaveInterventionDateTime(queidstr,isAdvicestr){
	var startDateTime = $('#EditDataTimeBox').datetimebox('getValue');
	// ���ƻ����ʩ�޸�ʱ�䣺��ǰʱ��2����
	if(!isBeforeTwoDays(startDateTime)) {
        $.messager.popover({
            msg: "�޸�ʱ�䷶Χ�ǵ�ǰʱ��2������ " ,
            type: 'error'
        });
        return false;
    }
	for (var i=0;i<queidstr.split('^').length;i++){
		var planID=queidstr.split('^')[i].split("||")[0];
		var questionSub=queidstr.split('^')[i].split("||")[1];
		var isNQNursingAdvice=isAdvicestr.split('^')[i]
		// 1�������ύ�����ʩ������������񣬷�ֹ���޸Ĵ�ʩʱ�䵼�������쳣��
		var QuestionMeasureTableSelRows = $("#QuestionMeasureTable").datagrid("getSelections");
	    var revokeintervDRRArr = new Array();
	    // ���� 2922707
	    var submitintervDRRArr = new Array();
	    for (var i = 0; i < QuestionMeasureTableSelRows.length; i++) {
		    // �Ѿ��жϴ�ʩ״ֻ̬��Ϊ"�ύ"���˴�����Ҫ�ٴ��ж�
	        // �ύ��ʩ����
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
    		// ��ѡ�����ڽ���У��
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
	                    msg: "��ʩ����Ӧ���ڵ��ڵ��죺" + myformatter(end) + "��",
	                    type: 'error'
	                });
	                return false;
	            }
	            */
	            if (!IsValidTime(startTime)) {
	                $.messager.popover({
	                    msg: "��ʩ��ʼʱ���ʽ����ȷ! ʱ:��,��11:05",
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
	                    msg: "��ʩ��ʼʱ��Ӧ���ڵ�ǰʱ�䣡",
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
	                msg: "<font color=red>" + intervName + "</font>��Ҫѡ��ִ��Ƶ�ʣ�",
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
	        
	        // ������ʩ����
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
		                msg: '�޸Ļ����ʩʱ��ʧ�ܣ�' + rtnResult,
		                type: 'error'
		            });
		            return false;
		    }
		    else{
			    // 2����������ɹ�����ִ���ύ�����ʩ(��������ʱ��)
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
			            isEditDateTime:"Y"    // Y�������ʩ�Ŀ�ʼʱ�䡢����ʱ�䶼����Ҫ�޸ĵ�ʱ��  ��Y��ֻ�п�ʼʱ�����Ҫ�޸ĵ�ʱ�䣬����ʱ��Ϊϵͳʱ��
			        }, false)
			        if (rtnJson.errcode < 0) {
			            $.messager.popover({
			                msg: '�ύ�����ʩʧ�ܣ�' + rtnJson.errinfo,
			                type: 'error'
			            });
			            return false;
			        }
			    }
			    $.messager.popover({
			        msg: '�ύ�ɹ���',
			        type: 'success'
			    });
			    PageLogicObj.m_QSGridSelRecordIdAfterLoad = queidstr;
			    $("#QuestionDiag").window("close");
			    $("#NurQuestionTable").datagrid('load');
			}
	    }
    }
}
// �ж������ڵ�ǰ����ǰ2����
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
// �����ж�
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
// MWToken ����
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
// ��ʼ��ת�뻤���¼��
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
			{field:'nurseRecordEntryTpl',title:'��¼��ģ��',width:206,sortable:true},
			{field:'locsName',title:'��Ч����',width:150,sortable:true}
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
