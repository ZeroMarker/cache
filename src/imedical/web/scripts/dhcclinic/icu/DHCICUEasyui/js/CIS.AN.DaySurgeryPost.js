
var anaestConsent = {
    operSchedule: null
};
var EpisodeID=dhccl.getQueryString("EpisodeID");
var opsId = dhccl.getQueryString("opsId");
$(document).ready(function() {
    $("#IsCanDayOper").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"Y",
            desc:"是"
        },{
            code:"N",
            desc:"否"
        }]
    });
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
});

/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    initDelegates();
    initDefaultValue();
    setDefaultPatInfo();
    //signCommon.loadSignature();
}
function setDefaultPatInfo()
{
    /*
    var banner=operScheduleBanner.init('#patinfo_banner', {});
        dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindPatient",
            Arg1: EpisodeID,
            ArgCnt: 1
        }, "json", true, function(appDatas) {
            if (appDatas && appDatas.length > 0) {
                banner.loadData(appDatas[0]);
                $("#btnOperList").hide();
            }
        });
        */
             dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json", true, function(patDatas) {
             var patStr=patDatas[0];
            
              $("#PatName").prop("innerText",patStr.PatName);
              
              $("#RegNo").prop("innerText",patStr.RegNo);
             
              $("#MedcareNo").prop("innerText",patStr.MedcareNo);
            
              $("#PatAge").prop("innerText",patStr.PatAge);
             
              $("#PatDeptDesc").prop("innerText",patStr.PatDeptDesc);
              
              $("#AdmReason").prop("innerText",patStr.AdmReason);
              $("#PatGender").prop("innerText",patStr.PatGender);
              $("#PatWardDesc").prop("innerText",patStr.PatWardDesc);
             
              $("#PatBedCode").prop("innerText",patStr.PatBedCode);
                var PatGender=patStr.PatGender;
              $("#patSeximg").prop("innerText","");
              if(PatGender=="男"){
                var imghtml="<img src='../service/dhcanop/img/man.png' style='margin-top:-5px'/>";
                $("#patSeximg").append(imghtml);
            }else if(PatGender=="女"){
                var imghtml="<img src='../service/dhcanop/img/woman.png' />";
                $("#patSeximg").append(imghtml);
            }
            $("#EpisodeID").val(patStr.EpisodeID);
            $("#PatDeptID").val(patStr.PatDeptID);
            $("#PatWardID").val(patStr.PatWardID);
            $("#PatBedID").val(patStr.PatBedID);
            $("#PatDOB").val(patStr.PatDOB);
            $("#CardID").val(patStr.CardID);

            $("#AdmDate").val(patStr.AdmDate);
            operDataManager.initFormData(loadApplicationData(patStr));
            operDataManager.setCheckChange();

            })



}
var score1=0,score2=0,score3=0,score4=0,score5=0,score6=0,totalScore=0;
function testScore(itemscore,val2,value)
{
   var score11=$('#'+val2).prop('value');
   if(itemscore=='score1')
   {score1=score11;
   }
   else if(itemscore=='score2')
   {score2=score11;
   }
   else if(itemscore=='score3')
   {score3=score11;
   }
   else if(itemscore=='score4')
   {score4=score11;
   }
   else if(itemscore=='score5')
   {score5=score11;
   }
   else{
   }
   totalScore=parseInt(parseInt(totalScore)+parseInt(score11));
   //totalScore=parseInt(parseInt(score1)+parseInt(score2)+parseInt(score3)+parseInt(score4)+parseInt(score5));
   $('#PostAldreteScore').val(totalScore)
   //alert(score1+"/"+score2+"/"+score3+"/"+score4+"/"+score5)
}
/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
            //$.messager.alert("提示","保存成功","info");
            window.parent.closePreDaySurgery();
        }
    });


    $("#btnClose").linkbutton({
        onClick: function() {
            window.parent.closePreDaySurgery();
        }
    });
	
	$('input[type="checkbox"]').each(function(index, item) {
        if ($(this).hasClass('hisui-checkbox')) {
            var options = null;
            if ($(this).data('checkbox')) options = $(this).checkbox('options');
            else options = $(this).data('iCheck')['o'];
            if (options) {
                options.onUnchecked = onUnchecked;
            }
        }
    });
}

function onUnchecked(e) {
    var score=$(this).prop('value');
	var PostAldreteScore=$('#PostAldreteScore').val();
    totalScore=parseInt(parseInt(PostAldreteScore)-parseInt(score));
	$('#PostAldreteScore').val(totalScore);
}

function initDefaultValue(){

    
}

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    anaestConsent.operSchedule = operApplication;
    $("#PreDiagnosisDesc").val(operApplication.PrevDiagnosisDesc);
    // $("#PlanOperDescs").val(operApplication.PlanOperDesc);
     $("#PreAnaMethod").val(operApplication.PrevAnaMethodDesc);
    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatBedCode").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
   
   $("#PlanOperDesc").val(operApplication.PlanOperDesc);
    //$("#PrevDiagnosis").text(operApplication.PrevDiagnosis);
   
   $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
    $("#OperDate").text(operApplication.OperDate);
    
}

