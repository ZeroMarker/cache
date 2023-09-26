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
            QueryName: 'FindGoldmanAssess',
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
            QueryName: 'AutoAssessGoldman',
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
            MethodName: 'SaveGoldmanAssess',
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

    assessment['TotalScore']=totalScore;
    assessment['AssessUser']=session?session["UserID"]:"";
    $.extend(assessment,assessResult(totalScore));

    return assessment;
}

var ResultList=[{
        Result:'1级',
        Min:1,
        Max:5,
        ResultDesc:'0-5分=1%',
        MortalityRate:'0.2%',
        Note:''
    },{
        Result:'2级',
        Min:6,
        Max:12,
        ResultDesc:'6-12分=7%',
        MortalityRate:'2%',
        Note:''
    },{
        Result:'3级',
        Min:13,
        Max:25,
        ResultDesc:'13-25分=14%',
        MortalityRate:'>2%',
        Note:'手术危险性较大'
    },{
        Result:'4级',
        Min:26,
        Max:26,
        ResultDesc:'26分=78%',
        MortalityRate:'56%',
        Note:'手术危险性较大'
    },{
        Result:'5级',
        Min:26,
        Max:100,
        ResultDesc:'大于26分',
        MortalityRate:'>56%',
        Note:'只宜施行急救手术'
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