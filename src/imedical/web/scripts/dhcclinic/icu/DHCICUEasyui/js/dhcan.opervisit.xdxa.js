
var anaestConsent = {
    operSchedule: null
};

$(document).ready(function() {
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
}

/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: print
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });

    $("#btnVisitorSign,#btnPostOpVisitorSign").linkbutton({
        onClick: function() {
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
        }
    });
}

function initDefaultValue(){
    var temperDataArr=dhccl.runServerMethod(ANCLS.BLL.OperData,"GetLastTemperatureData",session.EpisodeID);
    if(temperDataArr && temperDataArr.length>0){
        var temperatureData=temperDataArr[0];
        if(temperatureData.Temperature && $("#Temperature").val()===""){
            $("#Temperature").val(temperatureData.Temperature)
        }
        if(temperatureData.Pulse && $("#Pulse").val()===""){
            $("#Pulse").val(temperatureData.Pulse)
        }
        if(temperatureData.RespRate && $("#Respiration").val()===""){
            $("#Respiration").val(temperatureData.RespRate)
        }
        if(temperatureData.BloodPressure && $("#BloodPressure").val()===""){
            $("#BloodPressure").val(temperatureData.BloodPressure)
        }
        if(temperatureData.Height && $("#PatHeight").val()===""){
            $("#PatHeight").val(temperatureData.Height)
        }
        if(temperatureData.Weight && $("#PatWeight").val()===""){
            $("#PatWeight").val(temperatureData.Weight)
        }
        if(temperatureData.SPO2 && $("#SPO2").val()===""){
            $("#SPO2").val(temperatureData.SPO2)
        }
    }

    var EMRDataArr=dhccl.runServerMethod(ANCLS.BLL.OperData,"GetEMRData",session.EpisodeID);
    if(EMRDataArr && EMRDataArr.length>0){
        var EMRData=EMRDataArr[0];
        if (EMRData.OperHistory && !$("#OperHistory").attr("data-rowid")){
            $("#OperHistory").val(EMRData.OperHistory);
        }
        if (EMRData.AllergyHistory && !$("#AllergyHistory").attr("data-rowid")){
            $("#AllergyHistory").val(EMRData.AllergyHistory);
        }
        if (EMRData.InfectionHistory && !$("#InfectionHistory").attr("data-rowid")){
            $("#InfectionHistory").val(EMRData.InfectionHistory);
        }
        if (EMRData.PastHistory && !$("#PastHistory").attr("data-rowid")){
            $("#PastHistory").val(EMRData.PastHistory);
        }
    }
}

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    anaestConsent.operSchedule = operApplication;
    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatBedCode").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
    $("#PlanOperDesc").text(operApplication.PlanOperDesc);
    $("#PrevDiagnosis").text(operApplication.PrevDiagnosis);
    $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
    $("#OperDate").text(operApplication.OperDate);
}

function print() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function printNoData() {
    var lodop = getLodop();
    createPrintOnePage(lodop, anaestConsent.operSchedule,true);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function createPrintOnePage(lodop, operSchedule,nodata) {
    lodop.PRINT_INIT("OperVisit"+operSchedule.RowId);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    //lodop.ADD_PRINT_IMAGE("2cm","5cm",400,70,"<img src='../service/dhcanop/css/images/logoxa.png'>");
    //lodop.ADD_PRINT_IMAGE(sheetPrintConfig.logo.imgTop,sheetPrintConfig.logo.imgLeft,sheetPrintConfig.logo.imgWidth,sheetPrintConfig.logo.imgHeight,"<img src='"+sheetPrintConfig.logo.imgSrc+"'>");
    var hospital=getHospital(); //YuanLin 20191210 医院名称自动获取
	var printtitle=hospital[0].HOSP_Desc
    //lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 14px;}", 
        ".checkbox-item {margin: 0 10px;}</style>",
		'<h3 style="width: 490pt;text-align: center;font-family:\'黑体\';font-size:24px">'+printtitle+'</h3>',
        '<h3 style="width: 490pt;text-align: center;font-family:\'黑体\';font-size:24px">手术病人术前术后访视表</h3>',
        '<table sytle="width:490pt;" cellpadding="3"><tbody>',
        '<tr><td style="width:30pt;" align="center">科&nbsp;&nbsp;室</td><td style="width:45pt">'+operSchedule.PatDeptDesc+'</td>',
        '<td style="width:30pt;" align="center">床号</td><td style="width:36pt;" colspan="3">'+operSchedule.PatBedCode+'</td>',
        '<td style="width:30pt;" align="center">姓名</td><td style="width:45pt;" colspan="3">'+operSchedule.PatName+'</td>',
        '<td style="width:30pt;" colspan="2" align="right">性别</td><td style="width:30pt;" colspan="3" >'+operSchedule.PatGender+'</td>',
        '<td style="width:30pt;" align="center">年龄</td><td style="width:75pt;">'+operSchedule.PatAge+'</td></tr>',
        '<tr><td colspan="2" align="center">住院号</td><td colspan="4">'+operSchedule.MedcareNo+'</td>',
        '<td colspan="3" align="center">手术名称</td><td colspan="8">'+operSchedule.OperDesc+'</td></tr>',
        '<tr><td colspan="2" align="center">手术日期</td><td colspan="4">'+operSchedule.OperDate+'</td>',
        '<td colspan="3" align="center">麻醉方式</td><td colspan="8">'+operSchedule.PrevAnaMethodDesc+'</td></tr>',
        '<tr><td colspan="17" align="center">术&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;前&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;访&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;视</td></tr>',
        '<tr><td colspan="2" rowspan="4" align="center">查阅病历</td><td align="center">体温</td><td colspan="4">'+$("#Temperature").val()+' ℃</td>',
        '<td colspan="2" align="center">脉搏</td><td colspan="5">'+$("#Pulse").val()+' 次/分</td>',
        '<td width="40" align="center">呼吸</td><td colspan="2">'+$("#Respiration").val()+' 次/分</td></tr>',
        '<tr><td colspan="1" align="center">血压</td><td colspan="4">'+$("#BloodPressure").val()+' mmHg</td>',
        '<td colspan="2" align="center">身高</td><td colspan="5">'+$("#PatHeight").val()+' cm</td>',
        '<td width="20" align="center">体重</td><td colspan="2">'+$("#PatWeight").val()+'  kg</td></tr>',
        '<tr><td colspan="3" align="center">既往病史</td><td colspan="4">'+($("#PastHistory").val() || '')+'</td>',
        '<td colspan="5" align="center">手术史</td><td colspan="3">'+($("#OperHistory").val() || '')+'</td></tr>',
        '<tr><td colspan="3" align="center">过敏史</td><td colspan="4">'+($("#AllergyHistory").val() || '')+'</td>',
        '<td colspan="5" align="center">传染病系列</td><td colspan="3" style="width:135pt;">'+($("#InfectionHistory").val() || '')+'</td></tr>',
        '<tr><td colspan="2" rowspan="4" align="center">评估患者</td><td colspan="3" align="center">皮肤情况</td><td colspan="12">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#SkinCondition").val()==="完好"?"checked":"")+'>完好</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#SkinCondition").val()==="破损"?"checked":"")+'>破损</span></td></tr>',
        '<tr><td colspan="3" align="center">心理状况</td><td colspan="12">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#MentalState").val()==="乐观"?"checked":"")+'>乐观</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#MentalState").val()==="平静"?"checked":"")+'>平静</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#MentalState").val()==="紧张"?"checked":"")+'>紧张</span></td></tr>',
        '<tr><td colspan="3" align="center">肢体活动</td><td colspan="12">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#PhysicalActivity").val()==="正常"?"checked":"")+'>正常</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#PhysicalActivity").val()==="障碍"?"checked":"")+'>障碍</span></td></tr>',
        '<tr><td colspan="3" align="center">血管情况</td><td colspan="12">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#VascularCondition").val()==="显露明显"?"checked":"")+'>显露明显</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#VascularCondition").val()==="显露不明显"?"checked":"")+'>显露不明显</span></td></tr>',
        '<tr><td colspan="2" rowspan="8" align="center">术前宣教</td><td colspan="15">1、自我介绍。</td></tr>',
        '<tr><td colspan="15">2、术前一日正常沐浴，着重清洁以下部位皮肤：手术部位、双侧上肢、下肢、颈部及锁骨周围等。</td></tr>',
        '<tr><td colspan="15">3、术前禁食、禁饮，忌化妆，请勿将贵重物品及现金带入手术室。</td></tr>',
        '<tr><td colspan="15">4、佩戴腕带、手术标识及携带物品。</td></tr>',
        '<tr><td colspan="15">5、术晨请您做好个人卫生：洗脸、刷牙、梳头，更换清洁病服，不穿内衣裤、袜子。</td></tr>',
        '<tr><td colspan="15">6、术前静脉留置针、留置导尿的告知。</td></tr>',
        '<tr><td colspan="15">7、介绍手术环境，麻醉体位的配合方法及重要性。</td></tr>',
        '<tr><td colspan="15">8、做好术前准备，注意休息，迎接手术。</td></tr>',
        '<tr><td colspan="17">特殊问题及注意事项：'+$("#SpecialCondition").val()+'</td></tr>',
        '<tr style="min-height: 40px;"><td colspan="2" align="center">患者/家属签字</td><td colspan="5"></td><td colspan="5" align="center">访视者签字及日期</td><td colspan="5"></td></tr>',
        '<tr><td colspan="17" align="center">术&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;后&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;访&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;视</td></tr>',
        '<tr><td colspan="2" align="center">回访日期</td><td colspan="15"><span id="" class="checkbox-item">'+$("#PostVisitDate").datebox("getValue")+'</span>',
        '<span id="PostopDays" class="checkbox-item">术后第'+$("#PostOpDays").val()+'天</span></td></tr>',
        '<tr><td colspan="2" align="center">精神</td><td colspan="15">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Spirit").val()==="好"?"checked":"")+'>好</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Spirit").val()==="欠佳"?"checked":"")+'>欠佳</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Spirit").val()==="萎靡"?"checked":"")+'>萎靡</span></td></tr>',
        '<tr><td colspan="2" align="center">体温</td><td colspan="15">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#PostOpTemper").val()==="正常"?"checked":"")+'>正常</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#PostOpTemper").val()==="较高"?"checked":"")+'>较高</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#PostOpTemper").val()==="高热"?"checked":"")+'>高热</span></td></tr>',
        '<tr><td colspan="2" align="center">疼痛</td><td colspan="15">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Pain").val()==="有"?"checked":"")+'>有</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Pain").val()==="无"?"checked":"")+'>无</span></td></tr>',
        '<tr><td colspan="2" align="center">伤口愈合</td><td colspan="15">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#WoundHealing").val()==="良好"?"checked":"")+'>良好</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#WoundHealing").val()==="较差"?"checked":"")+'>较差</span></td></tr>',
        '<tr><td colspan="2" align="center">对手术室工作评价</td><td colspan="15">',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Evaluation").val()==="很好"?"checked":"")+'>很好</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Evaluation").val()==="一般"?"checked":"")+'>一般</span>',
        '<span class="checkbox-item"><input type="checkbox" '+($("#Evaluation").val()==="较差"?"checked":"")+'>较差</span></td></tr>',
        '<tr style="min-height: 60px;max-height:100px;"><td colspan="17" valign="top" align="center">您希望我们的工作在哪些方面需要改进，请提出您的宝贵意见，祝您早日康复！<div style="text-align:left;text-indent:2em;">'+$("#Opinion").val()+'</div></td></tr>',
        '<tr style="min-height: 40px;"><td colspan="2" align="center">患者/家属签字</td><td colspan="5"></td><td colspan="5" align="center">访视者签字</td><td colspan="5"></td></tr></tbody></table>'
    ];
    lodop.ADD_PRINT_HTM("3cm","1.5cm","490pt",1000,htmlArr.join(""));
}
function getHospital(){
	var result = null;
    $.ajaxSettings.async = false;
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindHospitalDesc",
        ArgCnt: 0
    }, "json");
    $.ajaxSettings.async = true;
    return result;
}