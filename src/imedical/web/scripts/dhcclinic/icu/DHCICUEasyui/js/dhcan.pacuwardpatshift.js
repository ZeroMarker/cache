$(document).ready(function() {
    initPage();
    operDataManager.initFormData();
    operDataManager.setCheckChange();
});

function initPage() {
    $("#dataForm").form("clear");

    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: print
    });

    $("#btnWardNurseSign").linkbutton({
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

    $("#btnPACUNurseSign").linkbutton({
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

function print() {
    var lodop = getLodop();
    drawPage(lodop);
    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW", true);
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW", true);
    lodop.SET_PREVIEW_WINDOW(1, 0, 0, 0, 0, "");
    lodop.PREVIEW();
    //lodop.PRINT();
}

function drawPage(lodop) {
    lodop.PRINT_INIT("创建打印PACU患者回房交接单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "微软雅黑");
    lodop.SET_PRINT_STYLE("FontSize", 10);
    lodop.ADD_PRINT_TEXT(20, 150, 500, 30, "山 西 省 肿 瘤 医 院");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(60, 60, 680, 20, "全麻患者术中血气、电解质、糖及代谢物等检测申请单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_TEXT(110, 80, 660, 15, "请在需要检测的指标左侧白框中划钩，确定检测的指标。");

    lodop.ADD_PRINT_TEXT(150, 80, 340, 15, "如果需要全部检测指标，请在此处签字确定");
    lodop.ADD_PRINT_LINE(165, 340, 165, 460, 0, 1);
    lodop.ADD_PRINT_TEXT(150, 460, 30, 15, "。");

    lodop.ADD_PRINT_HTM(190, 40, 300, 20, '<input type="checkbox">血气分析');
    lodop.ADD_PRINT_HTM(230, 40, 300, 20, '<input type="checkbox">钾测定（干化学法）');
    lodop.ADD_PRINT_HTM(270, 40, 300, 20, '<input type="checkbox">钠测定（干化学法）');
    lodop.ADD_PRINT_HTM(310, 40, 300, 20, '<input type="checkbox">氯测定（干化学法）');
    lodop.ADD_PRINT_HTM(350, 40, 300, 20, '<input type="checkbox">钙测定（干化学法）');
    lodop.ADD_PRINT_HTM(390, 40, 300, 20, '<input type="checkbox">血清碳酸氢盐测定');
    lodop.ADD_PRINT_HTM(430, 40, 300, 20, '<input type="checkbox">血一氧化碳分析');
    lodop.ADD_PRINT_HTM(470, 40, 300, 20, '<input type="checkbox">血红蛋白测定');
    lodop.ADD_PRINT_HTM(510, 40, 300, 20, '<input type="checkbox">红细胞比积测定');

    lodop.ADD_PRINT_HTM(230, 460, 300, 20, '<input type="checkbox">葡萄糖测定（干化学法）');
    lodop.ADD_PRINT_HTM(270, 460, 300, 20, '<input type="checkbox">血浆乳酸测定');
    lodop.ADD_PRINT_HTM(310, 460, 300, 20, '<input type="checkbox">血浆游离血红蛋白测定');
    lodop.ADD_PRINT_HTM(350, 460, 300, 20, '<input type="checkbox">高铁血红蛋白还原测定');
    lodop.ADD_PRINT_HTM(390, 460, 300, 20, '<input type="checkbox">还原型血红蛋白溶解测定');
    lodop.ADD_PRINT_HTM(430, 460, 300, 20, '<input type="checkbox">抗碱血红蛋白测定');
    lodop.ADD_PRINT_HTM(470, 460, 300, 20, '<input type="checkbox">血氧饱和度测定');
    lodop.ADD_PRINT_HTM(510, 460, 300, 20, '<input type="checkbox">血清渗透压测定');

    lodop.ADD_PRINT_TEXT(710, 220, 340, 30, "PACU患者回房交接单");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21); //设置字体
    lodop.SET_PRINT_STYLEA(0, "Bold", 1); //加粗
    lodop.SET_PRINT_STYLEA(0, "AlignJustify", 1) //两端对齐，居中

    lodop.ADD_PRINT_LINE(750, 40, 750, 770, 0, 1);
    lodop.ADD_PRINT_LINE(750, 40, 950, 40, 0, 1);
    lodop.ADD_PRINT_LINE(950, 40, 950, 770, 0, 1);
    lodop.ADD_PRINT_LINE(750, 770, 950, 770, 0, 1);

    lodop.ADD_PRINT_TEXT(760, 50, 100, 15, "术后送回：");
    lodop.ADD_PRINT_HTM(755, 160, 80, 20, '<input type="checkbox" class="PostShiftLoc" value="病房"' + CheckBoxValue("PostShiftLoc", "病房") + '>病房');
    lodop.ADD_PRINT_HTM(755, 260, 80, 20, '<input type="checkbox" class="PostShiftLoc" value="ICU"' + CheckBoxValue("PostShiftLoc", "ICU") + '>ICU');
    lodop.ADD_PRINT_HTM(755, 360, 80, 20, '<input type="checkbox" class="PostShiftLoc" value="其他"' + CheckBoxValue("PostShiftLoc", "其他") + '>其他');

    lodop.ADD_PRINT_TEXT(790, 50, 50, 15, "意识：");
    lodop.ADD_PRINT_LINE(805, 90, 805, 150, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 95, 40, 15, $("#Consciousness").val());

    lodop.ADD_PRINT_TEXT(790, 160, 50, 15, "血压：");
    lodop.ADD_PRINT_LINE(805, 200, 805, 290, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 205, 70, 15, $("#BloodPressure").val());
    lodop.ADD_PRINT_TEXT(790, 290, 60, 15, "mmHg");

    lodop.ADD_PRINT_TEXT(790, 345, 50, 15, "心率：");
    lodop.ADD_PRINT_LINE(805, 385, 805, 435, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 390, 40, 15, $("#Pulse").val());
    lodop.ADD_PRINT_TEXT(790, 435, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(790, 485, 50, 15, "呼吸：");
    lodop.ADD_PRINT_LINE(805, 525, 805, 575, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 530, 40, 15, $("#Respiration").val());
    lodop.ADD_PRINT_TEXT(790, 575, 60, 15, "次/分");

    lodop.ADD_PRINT_TEXT(790, 625, 80, 15, "穿刺部位：");
    lodop.ADD_PRINT_LINE(805, 690, 805, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(790, 695, 80, 15, $("#PunctureSite").val());

    lodop.ADD_PRINT_TEXT(830, 50, 60, 15, "引流：");
    lodop.ADD_PRINT_LINE(845, 90, 845, 240, 0, 1);
    lodop.ADD_PRINT_TEXT(830, 95, 130, 15, $("#Drainage").val());

    lodop.ADD_PRINT_TEXT(830, 240, 60, 15, "皮肤：");
    lodop.ADD_PRINT_HTM(825, 285, 60, 20, '<input type="checkbox" class="PostSkin" value="完整"' + CheckBoxValue("PostSkin", "完整") + '>完整');
    lodop.ADD_PRINT_HTM(825, 345, 60, 20, '<input type="checkbox" class="PostSkin" value="破损"' + CheckBoxValue("PostSkin", "破损") + '>破损');
    lodop.ADD_PRINT_TEXT(830, 400, 50, 15, '（部位');
    lodop.ADD_PRINT_LINE(845, 450, 845, 565, 0, 1);
    lodop.ADD_PRINT_TEXT(830, 455, 100, 15, $("#PostSkinOther").val());
    lodop.ADD_PRINT_TEXT(830, 570, 30, 15, '）');

    lodop.ADD_PRINT_TEXT(830, 600, 50, 15, "其他：");
    lodop.ADD_PRINT_LINE(845, 640, 845, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(830, 645, 120, 15, $("#Other").val());

    lodop.ADD_PRINT_TEXT(870, 50, 80, 15, "病历片子：");
    lodop.ADD_PRINT_LINE(885, 120, 885, 310, 0, 1);
    lodop.ADD_PRINT_TEXT(870, 125, 200, 15, $("#Picture").val());

    lodop.ADD_PRINT_TEXT(870, 340, 60, 15, "备注：");
    lodop.ADD_PRINT_LINE(885, 385, 885, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(870, 390, 370, 15, $("#Note").val());

    lodop.ADD_PRINT_TEXT(910, 50, 100, 15, "病房护士签名：");
    lodop.ADD_PRINT_LINE(925, 150, 925, 330, 0, 1);
    lodop.ADD_PRINT_TEXT(910, 155, 140, 15, $("#WardNurseSign").val());

    lodop.ADD_PRINT_TEXT(910, 310, 120, 15, "PACU护士签名：");
    lodop.ADD_PRINT_LINE(925, 410, 925, 560, 0, 1);
    lodop.ADD_PRINT_TEXT(910, 415, 140, 15, $("#PACUNurseSign").val());

    lodop.ADD_PRINT_TEXT(910, 570, 80, 15, "交接时间：");
    lodop.ADD_PRINT_LINE(925, 640, 925, 765, 0, 1);
    lodop.ADD_PRINT_TEXT(910, 645, 170, 15, $("#PostHandoverTime").datetimebox("getValue"));
}

function CheckBoxValue(formItemName, value) {
    var result = "unchecked";
    var jqArray = $("input[data-formitem='" + formItemName + "']");
    var length = jqArray.size();
    for (var i = 0; i < length; i++) {
        if ((jqArray.eq(i).val() == value) && (jqArray.eq(i).checkbox("getValue"))) {
            result = "checked";
            break;
        }
    }
    return result;
}