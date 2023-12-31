
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

    $("#btnSign,#btnPatSign,#btnAgentSign").linkbutton({
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
    $("#PlanOperationDesc").text(operApplication.OperInfo);
    $("#PrevDiagnosisDesc").text(operApplication.PrevDiagnosisDesc);
    $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
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

function createPrintOnePage(lodop, operSchedule,noData) {
    lodop.PRINT_INIT("ANWardShift"+operSchedule.RowId);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    
    // lodop.ADD_PRINT_TEXT(30, -105, 620, 30, "厦门大学附属翔安医院");
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    var prtConfig=sheetPrintConfig;
    lodop.ADD_PRINT_IMAGE(prtConfig.logo.imgTop,prtConfig.logo.imgLeft,prtConfig.logo.imgWidth,prtConfig.logo.imgHeight,"<img src='"+prtConfig.logo.imgSrc+"'>");
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
	
	lodop.ADD_PRINT_TEXT(110, 333, 620, 30, "麻醉科与病房交接单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    lodop.SET_PRINT_STYLE("FontSize", 11);

    var linePaddingTop = 16,
        linePaddingRight = 5,
        textMarginLeft = 50;
    var width = 50,
        height = 27;
    var startPos = {
        x: textMarginLeft,
        y: 130
    }

    var rectHeight=3*height+20;
    var nextRectY=startPos.y+rectHeight+14;
    lodop.ADD_PRINT_RECT(startPos.y+14,startPos.x-10,700,rectHeight,0,1);
    width=35;
    startPos.x=textMarginLeft;
    startPos.y+=height;
    
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "姓名");
    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, noData===true?"":operSchedule.PatName);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "性别");
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, noData===true?"":operSchedule.PatGender);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "年龄");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, noData===true?"":operSchedule.PatAge);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "科室");
    startPos.x += width;
    width = 120;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, noData===true?"":operSchedule.PatDeptDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "床号");
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, noData===true?"":operSchedule.PatBedCode);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "住院号");
    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, noData===true?"":operSchedule.MedcareNo);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    var padding = {
        top: 8,
        left: 5
    }
    startPos.x = textMarginLeft;
    startPos.y += height;
    width=35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "身高");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PatHeight").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width=30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "cm");

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "体重");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PatWeight").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "kg");

    startPos.x += width;
    width = 35;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "血型");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#ABO").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "RH(D)");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#RH").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "ASA分级");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#ASAClass").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SourceType").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x = textMarginLeft;
    startPos.y += height;
    width = 65;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "麻醉方法");

    startPos.x += width;
    width = 405;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, noData===true?"":operSchedule.AnaestMethod);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "体位");
    startPos.x += width;
    width = 110;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, noData===true?"":operSchedule.OperPosDesc);
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);


    startPos.y=nextRectY;
    startPos.x=textMarginLeft;
    rectHeight=10*height+20;
    lodop.ADD_PRINT_RECT(startPos.y,startPos.x-10,700,rectHeight,0,1);
    nextRectY=startPos.y+rectHeight;

    startPos.y+=10;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "麻醉总结");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    startPos.y+=height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "全身麻醉");

    startPos.y+=height;
    var leftPadding=10;
    startPos.x+=leftPadding;
    width=150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "1、气管插管 插管困难");
    startPos.x+=width;
    // width=100;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#MallampatiAirwayClass").combobox("getText"));
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x+=width+leftPadding;
    // width=60;
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x,"100%" , 15, "");
    // startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#TubeDifficulty").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "插管成功");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#TubeSuccess").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    
    startPos.x=textMarginLeft;
    startPos.y+=height;
    var leftPadding=10;
    startPos.x+=leftPadding;
    width=170;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "2、麻醉效果评价 全身麻醉");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#GeneralAnesthesiaEffect").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "椎管内麻醉");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#IntraspinalAnesthesiaEffect").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "神经阻滞");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#NerveBlockEffect").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "椎管内麻醉");

    startPos.y+=height;
    var leftPadding=10;
    startPos.x+=leftPadding;
    width=170;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "1、椎管内麻醉 穿刺顺利");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#PunctureSuccess").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "硬膜外隙出血");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#EpiduralHemorrhage").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "硬膜外导管拔除");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#EpiduralTubeOut").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x=textMarginLeft;
    startPos.y+=height;
    var leftPadding=10;
    startPos.x+=leftPadding;
    width=170;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "2、麻醉效果评价 麻醉平面");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#AnesthesiaPlane").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "单侧阻滞");
    startPos.x+=width;
    width=120;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#UnilateralBlock").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "阻滞不全");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#IncompleteBlock").combobox("getText"));
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    
	startPos.y+=height;
    startPos.x=textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "神经阻滞");
	
    startPos.x=textMarginLeft;
    startPos.y+=height;
    var leftPadding=10;
    startPos.x+=leftPadding;
    width=120;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "1、臂丛/颈丛：");
    startPos.x+=width;

    var checkBoxValue=$("#BrachialPlexusSite").val(),compareValue="左",emptyValue="";
    var checkBoxSize={width:12,height:12,padding:5,margin:10},textSize={width:15,height:15,padding:3};
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });
    
    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="右";
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x=textMarginLeft;
    startPos.y+=height;
    width=660;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, "100%", $("#IntraspinalAnesthesiaOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    // startPos.x=textMarginLeft;
    // startPos.y+=height;
    // lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y=nextRectY;
    startPos.x=textMarginLeft;
    rectHeight=19*height+20;
    lodop.ADD_PRINT_RECT(startPos.y,startPos.x-10,700,rectHeight,0,1);
    nextRectY=startPos.y+rectHeight;

    startPos.y+=10;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "返抵病房/ICU时病情及注意事项");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    startPos.y+=height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "一、病情");

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "时间：");
    startPos.x+=width;
    width=150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + padding.left, width, 15, $("#ShiftDT").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.x+=width;
    width=50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "神智：");
    startPos.x+=width;
    checkBoxValue=$("#Intelligence").val();
    compareValue="清醒";
    textSize.width=40;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="嗜睡";
    textSize.width=40;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="深睡";
    textSize.width=40;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="躁动";
    textSize.width=40;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="昏迷";
    textSize.width=40;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="麻醉状态";
    textSize.width=70;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });


    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "血压");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#BloodPressure").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "mmHg");

    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "脉搏");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#Pulse").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "次/分");

    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "呼吸");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#Respiration").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "次/分");

    startPos.x += width;
    width=40;
    lodop.ADD_PRINT_HTML(startPos.y, startPos.x, width, 20, "<span style='font-size:12px'>SpO<sub>2</sub></span>");
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SPO2").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width=30;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "%");

    startPos.x += width;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 20, "其他");
    startPos.x += width;
    width = 80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#OtherVitalSign").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "二、注意事项");

    

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    checkBoxValue=$("#AttentionItem").val();
    compareValue="吸氧";
    textSize.width=40;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="BP、ECG、HR、SpO2监测";
    textSize.width=180;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="观察肌张力恢复情况";
    textSize.width=180;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    compareValue="观察呼吸和循环系统的稳定情况";
    textSize.width=240;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    startPos.x+=checkBoxSize.width+checkBoxSize.padding+textSize.width;
    compareValue="观察挠或足背动脉搏动";
    textSize.width=160;
    drawCheckBoxAndValue(lodop,{
        startPos:{
            x:startPos.x,
            y:startPos.y
        },
        checked:(checkBoxValue.indexOf(compareValue)>-1),
        text:compareValue,
        textSize:textSize,
        emptyValue:emptyValue
    });

    

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "其他");
    startPos.x+=width;
    width=400;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PatConditionOther").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "注：若有麻醉相关情况及时请麻醉会诊");
    
    startPos.y+=height;
    startPos.x=textMarginLeft;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 100, 15, "三、术后镇痛");

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=120;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "1、术后镇痛途径");
    startPos.x+=width;
    width=400;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCAMethod").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=100;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "2、配方");

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "药品1");
    startPos.x+=width;
    width=150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADrug1").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x+=width;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "剂量");
    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADoseQty1").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "药品2");
    startPos.x+=width;
    width=150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADrug2").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x+=width;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "剂量");
    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADoseQty2").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "药品3");
    startPos.x+=width;
    width=150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADrug3").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x+=width;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "剂量");
    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADoseQty3").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "药品4");
    startPos.x+=width;
    width=150;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADrug4").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x+=width;
    width=40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "剂量");
    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#PCADoseQty4").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);

    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "用法");
    startPos.x+=width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "bolus");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#Bolus").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "ml");

    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "锁定时间");
    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#LockTime").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "min");

    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "输注速率");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#TransSpeed").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "ml");

    startPos.x += width;
    width = 40;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "自控");
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, $("#SelfControl").val());
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x += width;
    width = 60;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "ml/次");


    startPos.y+=height;
    startPos.x=textMarginLeft+leftPadding;
    width=200;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "3、注意镇痛泵的开关");

    startPos.y+=height;
    startPos.x=textMarginLeft+300;
    width=70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "麻醉医生");
    startPos.x+=width;
    width=80;
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
    startPos.x+=width;
    width=90;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, width, 15, "病区接班人");
    startPos.x+=width;
    width=100;
    lodop.ADD_PRINT_LINE(startPos.y + linePaddingTop, startPos.x, startPos.y + linePaddingTop, startPos.x + width - linePaddingRight, 0, 1);
}