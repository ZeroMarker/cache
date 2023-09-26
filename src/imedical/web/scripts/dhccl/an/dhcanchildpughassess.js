var currentpage={};

$(document).ready(function() {
    currentpage.opaId = dhccl.getUrlParam('opaid');
    initPage();
    loadAssess();
});

function initPage(){
    $('input[type="checkbox"]').each(function(index, item) {
        if ($(this).hasClass('hisui-checkbox')) {
            var options = null;
            if ($(this).data('checkbox')) options = $(this).checkbox('options');
            else  options = $(this).data('iCheck')['o'];
            if (options) {
                options.onCheckChange = onCheckChange;
            }
        }
    });

    $('input[type="radio"]').each(function(index, item) {
        if ($(this).hasClass('hisui-radio')) {
            var options = null;
            if ($(this).data('radio')) options = $(this).radio('options');
            else  options = $(this).data('iCheck')['o'];
            if (options) {
                options.onCheckChange = onCheckChange;
            }
        }
    });

    $('#btnSave').linkbutton({
        onClick:saveAssess
    })
}

function onCheckChange(e){
    if($(this).checkbox('getValue')) {
        $(this).parent().parent().css('color','#4A9FD4');
    }
    else{
        $(this).parent().parent().css('color','black');
    }
    var assessment = toData();
    renderAssessResult(assessment);
}

function loadAssess(){
    $.ajax({
        url: 'dhcclinic.jquery.csp',
        async: true,
        data: {
            ClassName: 'web.DHCANOPAssess',
            QueryName: 'FindChildPughAssess',
            Arg1: currentpage.opaId || '',
            ArgCnt: 1
        },
        type: 'post',
        dataType: 'json',
        success: function(data) {
            if(data && data.rows && data.rows.length>0){
                renderAssess(data.rows[0]);
            }
            else{
                autoCheck();
            }
        }
    });
}

function autoCheck(){
    $.ajax({
        url: 'dhcclinic.jquery.csp',
        async: true,
        data: {
            ClassName: 'web.DHCANOPAssess',
            QueryName: 'AutoAssessChildPugh',
            Arg1: currentpage.opaId || '',
            ArgCnt: 1
        },
        type: 'post',
        dataType: 'json',
        success: function(data) {
            if(data && data.rows && data.rows.length>0){
                renderAssess(data.rows[0]);
                renderAssessResult(toData());
            }
        }
    });
}

function renderAssess(assessment){
    currentpage.assessment=assessment;
    var name,scoreName;
    $('input[type="checkbox"]').each(function(index,e){
        name = $(this).attr('name');
        scoreName = $(this).attr('data-scorename');
        if(name && scoreName && assessment[name]) {
            $(this).checkbox('setValue',true);
        }
        else{
            $(this).checkbox('setValue',false);
        }
    });

    $('input[type="radio"]').each(function(index,e){
        name = $(this).attr('name');
        scoreName = $(this).attr('data-scorename');
        label = $(this).attr('label');
        if(name && scoreName && assessment[name] == label) {
            $(this).radio('setValue',true);
        }
    });

    renderAssessResult(assessment);
}

function renderAssessResult(assessment){
    $('#assess_totalscore').attr('title',assessment['TotalScore'] || '').text(assessment['TotalScore'] || '');
    $('#assess_result').attr('title',assessment['ResultDesc'] || '').text(assessment['Result'] || '');
    $('#assess_mortalityrate').attr('title',assessment['MortalityRate'] || '').text(assessment['MortalityRate'] || '');
    $('#assess_result_note').attr('title',assessment['Note'] || '').text(assessment['Note'] || '');
}

function saveAssess(){
    var assessment = toData();
    //发送至后台
    $.ajax({
        url: 'dhcclinic.jquery.method.csp',
        async: true,
        data: {
            ClassName: 'web.DHCANOPAssess',
            MethodName: 'SaveChildPughAssess',
            Arg1: currentpage.opaId || '',
            Arg2: formatObject(assessment),
            ArgCnt: 2
        },
        type: 'post',
        dataType: 'text',
        success: function(data) {
            if(data && data.indexOf('S^')>-1){
                $.messager.alert("提示", "保存成功！", "info");
            }
            else{
                $.messager.alert("警告", "保存错误，请联系信息管理员!", "error");
            }
        }
    });
}

function toData(){
    var assessment={};
    var totalScore=0;
    var name,scoreName,checked,score;
    $('input[type="checkbox"]').each(function(index,e){
        name = $(this).attr('name');
        scoreName = $(this).attr('data-scorename');
        checked = $(this).checkbox('getValue');
        score = $(this).attr('data-score');
        if(name && scoreName && checked) {
            assessment[name]=$(this).attr('label');
            assessment[scoreName]=score;
            totalScore += Number(score);
        }
    });

    $('input[type="radio"]').each(function(index,e){
        name = $(this).attr('name');
        scoreName = $(this).attr('data-scorename');
        checked = $(this).radio('getValue');
        score = $(this).attr('data-score');
        if(name && scoreName && checked) {
            assessment[name]=$(this).attr('label');
            assessment[scoreName]=score;
            totalScore += Number(score);
        }
    });

    assessment['TotalScore']=totalScore;
    assessment['AssessUser']=session?session["UserID"]:"";
    $.extend(assessment,assessResult(totalScore));

    return assessment;
}

var ResultList=[{
        Result:'A级',
        Min:5,
        Max:6,
        ResultDesc:'5-6分',
        MortalityRate:'',
        Note:'手术危险度小，预后最好，1~2年存活率100%~85%'
    },{
        Result:'B级',
        Min:7,
        Max:9,
        ResultDesc:'7-9分',
        MortalityRate:'',
        Note:'手术危险度中等，1~2年存活率80%~60%'
    },{
        Result:'C级',
        Min:10,
        Max:20,
        ResultDesc:'≥10分',
        MortalityRate:'',
        Note:'手术危险度较大，预后最差，1~2年存活率45%~35%'
    }];

function assessResult(totalScore){
    var length = ResultList.length;
    var result;
    for(var i = 0; i<length; i++){
        result = ResultList[i];
        if(totalScore>=result.Min && totalScore<=result.Max){
            return result;
        }
    }

    return {};
}

function formatObject(dataObject) {
    var result = "",
        resultArr = [],
        propertySplitChar = String.fromCharCode(1),
        valueSplitChar = String.fromCharCode(0);
    if (dataObject) {
        for (var property in dataObject) {
            var propertyStr = property + valueSplitChar + dataObject[property];
            resultArr.push(propertyStr);
        }
        result = resultArr.join(propertySplitChar);
    }
    return result;
}