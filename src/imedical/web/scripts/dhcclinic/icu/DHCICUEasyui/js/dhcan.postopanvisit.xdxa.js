
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

    $("#btnPrintNoData").linkbutton({
        onClick: printNoData
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });

    $("#btnAnaDocSign").linkbutton({
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
    $("#OperationDesc").text(operApplication.OperInfo);
    $("#PostDiagnosisDesc").text(operApplication.PostDiagnosisDesc);
    $("#AnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
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
    lodop.PRINT_INIT("PostAnaVisit"+operSchedule.RowId);
    var prtConfig=sheetPrintConfig,
        logoMargin=prtConfig.logo.margin,
        logoSize=prtConfig.logo.size,
        titleFont=prtConfig.title.font,
        titleSize=prtConfig.title.size,
        titleMargin=prtConfig.title.margin,
        contentSize=prtConfig.content.size,
        contentFont=prtConfig.content.font;
    lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    lodop.SET_PRINT_STYLE("FontName", contentFont.name);
    lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    
    var startPos={
        x:prtConfig.paper.margin.left,
        y:logoMargin.top+logoSize.height+logoMargin.bottom
    };
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "麻醉总结交接及随访单");
    lodop.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var htmlArr=[
        "<style> p {margin:5px auto;font-size:14px;} .patinfo-title {margin-right:1px;}",
        ".patInfo {display:inline-block;min-width:10px;margin-right:15px;height:18px;border:none;border-bottom:1px solid #000;} .title {font-weight:bold;margin:10px 0 5px 0;}",
        ".contenttitle {display:inline-block;min-width:110px;text-align:right;} .contentvalue {display:inline-block;min-width:50px;height:20px;border:none;border-bottom:1px solid #000;margin-right:5px;}",
        ".checkboxlist {margin-right:10px;} .contentunit {margin-right:10px;} .drugLine {width:120px;} .signrow {margin:10px auto;}",
        ".contentitem-right {display:inline-block;min-width:70px;text-align:right;}",
        "</style>",
        "<p><span class='patinfo-title'>姓名：</span><span class='patinfo' style='width:60px;'>"+(nodata?"":operSchedule.PatName)+"</span>",
        "<span class='patinfo-title'>性别：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.PatGender)+"</span>",
        "<span class='patinfo-title'>年龄：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.PatAge)+"</span>",
        "<span class='patinfo-title'>科室：</span><span class='patinfo' style='width:70px;'>"+(nodata?"":operSchedule.PatDeptDesc)+"</span>",
        "<span class='patinfo-title'>床号：</span><span class='patinfo' style='width:20px;'>"+(nodata?"":operSchedule.PatBedCode)+"</span>",
        "<span class='patinfo-title'>病案号：</span><span class='patinfo' style='width:70px;'>"+(nodata?"":operSchedule.MedcareNo)+"</span></p>",
        "<p><span class='patinfo-title'>身高：</span><span class='patinfo' style='width:60px;'>"+(nodata?"":operSchedule.PatHeight)+"</span>",
        "<span class='patinfo-title'>体重：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.PatWeight)+"</span>",
        "<span class='patinfo-title'>血型：</span><span class='patinfo' style='width:30px;'>"+(nodata?"":operSchedule.ABO)+"</span>",
        "<span class='patinfo-title'>RH(D)：</span><span class='patinfo' style='width:40px;'>"+(nodata?"":operSchedule.RH)+"</span>",
        "<span class='patinfo-title'>ASA分级：</span><span class='patinfo' style='width:20px;'>"+(nodata?"":operSchedule.ASAClass)+"</span>",
        "<span class='patinfo-title'>手术体位：</span><span class='patinfo' style='width:50px;'>"+(nodata?"":operSchedule.OperPosDesc)+"</span></p>",
        "<p><span class='patinfo-title'>术后诊断：</span><span class='patinfo' style='width:240px;'>"+(nodata?"":operSchedule.PrevDiagnosisDesc)+"</span>",
        "<span class='patinfo-title'>麻醉方法：</span><span class='patinfo' style='width:240px;'>"+(nodata?"":operSchedule.AnaestMethodInfo)+"</span></p>",
        "<p><span class='patinfo-title'>实施手术：</span><span class='patinfo' style='width:565px;'>"+(nodata?"":operSchedule.OperationDesc)+"</span></p>",
        "<p class='title'>术毕情况</p>",
        "<p><span class='contenttitle'>生命体征：</span><span class='contentitem'>BP：</span><span class='contentvalue'>"+$("#BloodPressure").val()+"</span><span class='contentunit'>mmHg</span>",
        "<span class='contentitem'>HR：</span><span class='contentvalue'>"+$("#HR").val()+"</span><span class='contentunit'>次/分</span>",
        "<span class='contentitem'>R：</span><span class='contentvalue'>"+$("#Respiration").val()+"</span><span class='contentunit'>次/分</span>",
        "<span class='contentitem'>SpO<sub>2</sub>：</span><span class='contentvalue'>"+$("#SPO2").val()+"</span><span class='contentunit'>%</span></p>",
        "<p><span class='contenttitle'>意识：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#IntelligenceCHK1").checkbox("getValue")===true?"checked":"")+">清醒",
        "<input type='checkbox' "+($("#IntelligenceCHK2").checkbox("getValue")===true?"checked":"")+">嗜睡",
        "<input type='checkbox' "+($("#IntelligenceCHK3").checkbox("getValue")===true?"checked":"")+">昏迷",
        "<input type='checkbox' "+($("#IntelligenceCHK4").checkbox("getValue")===true?"checked":"")+">死亡</span>",
        "<span class='contenttitle'>气管导管：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#TubeOutStatusCHK1").checkbox("getValue")===true?"checked":"")+">拔除",
        "<input type='checkbox' "+($("#TubeOutStatusCHK2").checkbox("getValue")===true?"checked":"")+">未拔</span></p>",
        "<p><span class='contenttitle'>送往场所：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#PatTransferCHK1").checkbox("getValue")===true?"checked":"")+">病房",
        "<input type='checkbox' "+($("#PatTransferCHK2").checkbox("getValue")===true?"checked":"")+">麻醉后恢复室(PACU)",
        "<input type='checkbox' "+($("#PatTransferCHK3").checkbox("getValue")===true?"checked":"")+">重症监护室(ICU)</span> </p>",
        "<p class='title'>麻醉与镇痛</p>",
        "<p><span class='contenttitle'>神经阻滞麻醉：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#NerveBlockCHK1").checkbox("getValue")===true?"checked":"")+">否",
        "<input type='checkbox' "+($("#NerveBlockCHK2").checkbox("getValue")===true?"checked":"")+">是</span>",
        "<span class='contentitem'>阻滞部位</span><span class='contentvalue'>"+$("#BlockSite").val()+"</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#NerveBlockComplicationsCHK1").checkbox("getValue")===true?"checked":"")+">穿刺部位血肿",
        "<input type='checkbox' "+($("#NerveBlockComplicationsCHK2").checkbox("getValue")===true?"checked":"")+">神经损伤",
        "<input type='checkbox' "+($("#NerveBlockComplicationsCHK3").checkbox("getValue")===true?"checked":"")+">感染",
        "<input type='checkbox' "+($("#NerveBlockComplicationsCHK4").checkbox("getValue")===true?"checked":"")+">血气胸",
        "<input type='checkbox' "+($("#NerveBlockComplicationsCHK5").checkbox("getValue")===true?"checked":"")+">其他</span></p>",
        
        "<p><span class='contenttitle'>椎管内麻醉：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#ISAnesthesiaCHK1").checkbox("getValue")===true?"checked":"")+">否",
        "<input type='checkbox' "+($("#ISAnesthesiaCHK2").checkbox("getValue")===true?"checked":"")+">是</span>",
        "<span class='contentitem'>穿刺点：</span><span class='contentvalue'>"+$("#PunctureSite").val()+"</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#ISAnaComplicationsCHK1").checkbox("getValue")===true?"checked":"")+">穿刺点疼痛、红肿",
        "<input type='checkbox' "+($("#ISAnaComplicationsCHK2").checkbox("getValue")===true?"checked":"")+">神经损伤",
        "<input type='checkbox' "+($("#ISAnaComplicationsCHK3").checkbox("getValue")===true?"checked":"")+">硬脊膜穿破后头痛",
        "<p><span class='contenttitle'></span><input type='checkbox' "+($("#ISAnaComplicationsCHK4").checkbox("getValue")===true?"checked":"")+">椎管内血肿</span>",
        "<span class='contenttitle'></span><span class='contenttitle-n'>四肢肌力及感觉：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#LimbMuscleCHK1").checkbox("getValue")===true?"checked":"")+">正常 ",
        "<input type='checkbox' "+($("#LimbMuscleCHK2").checkbox("getValue")===true?"checked":"")+">减退",
        "<input type='checkbox' "+($("#LimbMuscleCHK3").checkbox("getValue")===true?"checked":"")+">消失</span></p>",
        "<p><span class='contenttitle'>全身麻醉：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#GeneralAnesthesiaCHK1").checkbox("getValue")===true?"checked":"")+">否",
        "<input type='checkbox' "+($("#GeneralAnesthesiaCHK2").checkbox("getValue")===true?"checked":"")+">是</span>",
        "<span class='contenttitle-n'>插管困难：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#TubeDiffcultyCHK1").checkbox("getValue")===true?"checked":"")+">否",
        "<input type='checkbox' "+($("#TubeDiffcultyCHK2").checkbox("getValue")===true?"checked":"")+">是</span>",
        "<span class='contentitem'>插管次数：</span><span class='contentvalue'>"+$("#TubeCount").numberbox("getValue")+"</span></p>",
        "<p><span class='contenttitle'>术后镇痛：</span>",
        "<span class='contentitem'>药品1：</span><span class='contentvalue drugLine'>"+$("#PCADrug1").val()+"</span>",
        "<span class='contentitem'>剂量：</span><span class='contentvalue'>"+$("#PCADoseQty1").val()+"</span>",
        "<span class='contentitem-right'>途径：</span><span class='contentvalue'>"+$("#PCAMethod").val()+"</span>",
        "<span class='contentitem-right'>自控：</span><span class='contentvalue'>"+$("#SelfControl").val()+"</span><span class='contentunit'>ml/次</span></p>",
        "<p><span class='contenttitle'></span>",
        "<span class='contentitem'>药品2：</span><span class='contentvalue drugLine'>"+$("#PCADrug2").val()+"</span>",
        "<span class='contentitem'>剂量：</span><span class='contentvalue'>"+$("#PCADoseQty2").val()+"</span>",
        "<span class='contentitem-right'>总容量：</span><span class='contentvalue'>"+$("#TotalVol").val()+"</span>",
        "<span class='contentitem-right'>锁定时间：</span><span class='contentvalue'>"+$("#LockTime").val()+"</span><span class='contentunit'>min</span></p>",
        "<p><span class='contenttitle'></span>",
        "<span class='contentitem'>药品3：</span><span class='contentvalue drugLine'>"+$("#PCADrug3").val()+"</span>",
        "<span class='contentitem'>剂量：</span><span class='contentvalue'>"+$("#PCADoseQty3").val()+"</span>",
        "<span class='contentitem-right'>负荷量：</span><span class='contentvalue'>"+$("#Capacity").val()+"</span></p>",
        "<p><span class='contenttitle'></span>",
        "<span class='contentitem'>药品4：</span><span class='contentvalue drugLine'>"+$("#PCADrug4").val()+"</span>",
        "<span class='contentitem'>剂量：</span><span class='contentvalue'>"+$("#PCADoseQty4").val()+"</span>",
        "<span class='contentitem-right'>输注速率：</span><span class='contentvalue'>"+$("#TransSpeed").val()+"</span><span class='contentunit'>ml/h</span></p>",
        "<p><span class='contenttitle'>其他情况：</span><span class='contentvalue' style='width:540px;'>"+$("#OtherCondition").val()+"</span></p>",
        "<p class='title'>返抵病房/ICU时生命体征及注意事项</p>",
        "<p><span class='contenttitle'>生命体征：</span><span class='contentitem'>时间：</span><span class='contentvalue'>"+$("#ShiftDT").datetimebox("getValue")+"</span>",
        "<span class='contenttitle-n'>神志：</span><span class='checkboxlist'><input type='checkbox' "+($("#SenseCHK1").checkbox("getValue")===true?"checked":"")+">清醒",
        "<input type='checkbox' "+($("#SenseCHK2").checkbox("getValue")===true?"checked":"")+">嗜睡",
        "<input type='checkbox' "+($("#SenseCHK3").checkbox("getValue")===true?"checked":"")+">躁动",
        "<input type='checkbox' "+($("#SenseCHK4").checkbox("getValue")===true?"checked":"")+">昏迷",
        "<input type='checkbox' "+($("#SenseCHK5").checkbox("getValue")===true?"checked":"")+">麻醉状态 </span></p>",
        "<p><span class='contenttitle'></span>",
        "<span class='contentitem'>BP：</span><span class='contentvalue'>"+$("#TransBloodPressure").val()+"</span><span class='contentunit'>mmHg</span>",
        "<span class='contentitem'>HR：</span><span class='contentvalue'>"+$("#TransHR").val()+"</span><span class='contentunit'>次/分</span>",
        "<span class='contentitem'>R：</span><span class='contentvalue'>"+$("#TransRespiration").val()+"</span><span class='contentunit'>次/分</span>",
        "<span class='contentitem'>SpO<sub>2</sub>：</span><span class='contentvalue'>"+$("#TransSPO2").val()+"</span><span class='contentunit'>%</span></p>",
        "<p><span class='contenttitle'>注意事项：</span>",
        "<span class='checkboxlist'><input type='checkbox' "+($("#AttentionItemCHK1").checkbox("getValue")===true?"checked":"")+">吸氧",
        "<input type='checkbox' "+($("#AttentionItemCHK2").checkbox("getValue")===true?"checked":"")+">BP、ECG、HR、SpO2监测",
        "<input type='checkbox' "+($("#AttentionItemCHK3").checkbox("getValue")===true?"checked":"")+">观察肌张力恢复情况</span></p>",
        "<p><span class='contenttitle'></span><span class='checkboxlist'><input type='checkbox' "+($("#AttentionItemCHK4").checkbox("getValue")===true?"checked":"")+">观察呼吸和循环系统的稳定情况",
        "<input type='checkbox' "+($("#AttentionItemCHK5").checkbox("getValue")===true?"checked":"")+">观察桡或足背动脉搏动</span><span class='contentitem'>其他：</span><span class='contentvalue'></span></p>",
        "<p class='signrow'><span class='contenttitle'>麻醉医生签名：</span>__________________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签名日期：______年____月____日</p>",
        "<p class='title'>随访记录</p>",
        "<p><span class='contenttitle'>生命体征：</span>",
        "<span class='contentitem'>BP：</span><span class='contentvalue'>"+$("#VisitBP").val()+"</span><span class='contentunit'>mmHg</span>",
        "<span class='contentitem'>HR：</span><span class='contentvalue'>"+$("#VisitHR").val()+"</span><span class='contentunit'>次/分</span>",
        "<span class='contentitem'>R：</span><span class='contentvalue'>"+$("#VisitResp").val()+"</span><span class='contentunit'>次/分</span>",
        "<span class='contentitem'>SpO<sub>2</sub>：</span><span class='contentvalue'>"+$("#VisitSPO2").val()+"</span><span class='contentunit'>%</span></p>",
        //"<p><span class='contenttitle'>镇痛评分：</span><span class='contentvalue'>"+$("#PCAScore").combobox("getText")+"</span>",
        //"<span class='contenttitle-n'>镇静评分：</span><span class='contentvalue'>"+$("#SedationScore").combobox("getText")+"</span>",
        "<p><span class='contenttitle'>术中知晓：</span><span class='checkboxlist'><input type='checkbox' "+($("#OperAwarenessCHK1").checkbox("getValue")===true?"checked":"")+">无",
        "<input type='checkbox' "+($("#OperAwarenessCHK2").checkbox("getValue")===true?"checked":"")+">听觉",
        "<input type='checkbox' "+($("#OperAwarenessCHK3").checkbox("getValue")===true?"checked":"")+">痛觉</span></p>",
        "<p><span class='contenttitle'>不良反应：</span>",
        "<span class='contenttitle-n'> 头晕：</span><span class='contentvalue'>"+$("#Dizziness").combobox("getText")+"</span>",
        "<span class='contenttitle-n'>恶心呕吐：</span><span class='contentvalue'>"+$("#Vomit").combobox("getText")+"</span>",
        "<span class='contenttitle-n'>瘙痒：</span><span class='contentvalue'>"+$("#Itching").combobox("getText")+"</span>",
        "<span class='contenttitle-n'>尿潴留：</span><span class='contentvalue'>"+$("#UrinaryRetention").combobox("getText")+"</span></p>",
        "<p><span class='contenttitle'></span>",
        "<span class='contenttitle-n'>运动障碍：</span><span class='contentvalue'>"+$("#MovementDisorder").combobox("getText")+"</span>",
        "<span class='contenttitle-n'>感觉异常：</span><span class='contentvalue'>"+$("#FeelingAbnormal").combobox("getText")+"</span></p>",
        "<p class='signrow'><span class='contenttitle'>麻醉医生签名：</span>__________________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签名日期：______年____月____日</p>"
    ];

    startPos.y+=titleSize.height+titleMargin.bottom;
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, contentSize.width, contentSize.height, htmlArr.join(""));
}