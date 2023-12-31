
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

    $("#btnPrintDesign").linkbutton({
        onClick: printDesign
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

function printDesign(){
    var lodop = getLodop();
    var designCode=lodop.PRINT_DESIGN();
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
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_IMAGE(30,200,"8.1cm","1.35cm","<img src='../service/dhcanop/css/images/logoxa.png'>");
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    lodop.ADD_PRINT_TEXT(90, 333, 620, 30, "日间手术麻醉记录单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    var defaultOpts={
        titleHeight:15,
        valueHeight:15,
        lineWidth:100,
        startPos:{x:0,y:0},
        lineHeight:30,
        textSize:{width:15,height:15,padding:3},
        checkBoxSize:{width:15,height:15},
        emptyValue:"",
        itemMargin:10
    };

    var basePos={x:40,y:130},startPos={x:70,y:130};
    var optGroup=[{
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:120,
        titleWidth:35,
        unitWidth:0,
        startPos:startPos,
        title:"科室",
        value:""
    },{
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:60,
        titleWidth:35,
        unitWidth:0,
        startPos:startPos,
        title:"床号",
        value:""
    },{
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:100,
        titleWidth:50,
        unitWidth:0,
        startPos:startPos,
        title:"住院号",
        value:""
    },{
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:100,
        titleWidth:25,
        unitWidth:0,
        startPos:startPos,
        title:"ID",
        value:""
    },{
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:80,
        titleWidth:35,
        unitWidth:0,
        startPos:startPos,
        title:"日期",
        value:""
    }];
    drawTitleValueLineGroup(lodop,optGroup);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    var rectSize={width:90,height:defaultOpts.lineHeight};
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectSize.height},
        startPos:startPos,
        title:"姓名"
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:""
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:"性别"
    },{
        rectSize:{width:60,height:rectSize.height},
        startPos:startPos,
        title:""
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:"年龄"
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:""
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:"体重"
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:""
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectSize.height},
        startPos:startPos,
        title:"术前诊断"
    },{
        rectSize:{width:600,height:rectSize.height},
        startPos:startPos,
        title:""
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectSize.height},
        startPos:startPos,
        title:"术后诊断"
    },{
        rectSize:{width:600,height:rectSize.height},
        startPos:startPos,
        title:""
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectSize.height},
        startPos:startPos,
        title:"ASA分级"
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:""
    },{
        rectSize:rectSize,
        startPos:startPos,
        title:"合并疾患"
    },{
        rectSize:{width:420,height:rectSize.height},
        startPos:startPos,
        title:""
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectSize.height},
        startPos:startPos,
        title:"拟行手术或操作"
    },{
        rectSize:{width:600,height:rectSize.height},
        startPos:startPos,
        title:""
    }]);

    var startPosY=startPos.y+(defaultOpts.lineHeight-defaultOpts.checkBoxSize.height)/2;
    var startPosX=startPos.x+5;
    drawCheckBoxGroup(lodop,[{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无痛人流",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无痛取环",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无痛诊刮",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无痛胃镜",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无痛肠镜",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无痛膀胱镜",
        textSize:{width:72,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"其他:",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectSize.height},
        startPos:startPos,
        title:"操作起止时间"
    },{
        rectSize:{width:600,height:rectSize.height},
        startPos:startPos,
        title:"     年    月    日  至      年   月   日"
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:2*defaultOpts.lineHeight},
        startPos:startPos,
        title:"麻醉或镇痛方式"
    },{
        rectSize:{width:600,height:2*defaultOpts.lineHeight},
        startPos:startPos,
        title:""
    }]);

    startPosY=startPos.y+(defaultOpts.lineHeight-defaultOpts.checkBoxSize.height)/2;
    startPosX=startPos.x+5;
    drawCheckBoxGroup(lodop,[{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"静脉全麻",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"静吸全麻",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"气管插管",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"喉罩",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"局麻强化",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"MAC",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    }]);

    startPosY+=defaultOpts.lineHeight;
    drawCheckBoxGroup(lodop,[{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"硬膜外阻滞",
        textSize:{width:80,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"神经丛或神经干阻滞：",
        textSize:{width:280,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"其他",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    }]);

    startPos.y+=defaultOpts.lineHeight*2;
    startPos.x=basePos.x;
    var valueArray=[
        "BP：      mmHg   P：    bpm   R：    次/分  SPO2：   %  神志：    行动：",
        "                  困难气道：□ 有  □ 无",
        "心功能分级：□ Ⅰ  □ Ⅱ  □ Ⅲ  □ Ⅳ    ECG：□ 正常  □ 异常           ",
        "胸片：□ 正常  □ 异常            心脏超声：□ 正常  □ 异常              ",
        "化验结果：□ 正常  □ 异常                           其他：               ",
    ];
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:5*defaultOpts.lineHeight},
        startPos:startPos,
        title:"术前情况"
    },{
        rectSize:{width:600,height:5*defaultOpts.lineHeight},
        startPos:startPos,
        title:"",
    }]);

    startPosY=startPos.y+5;
    startPosX=startPos.x+5;
    lodop.ADD_PRINT_TEXT(startPosY,startPosX,"100%",defaultOpts.titleHeight,"BP：    mmHg   P：  bpm   R：  次/分  SPO2：  % 神志：    行动：");

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    var opts={
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:100,
        titleWidth:250,
        unitWidth:0,
        startPos:{x:startPosX,y:startPosY},
        title:"既往史(过敏史、麻醉史、特殊病史):",
        value:""
    };
    drawTitleValueLine(lodop,opts);

    startPosX+=opts.lineWidth+opts.titleWidth+defaultOpts.itemMargin;
    drawCheckBoxGroup(lodop,[{
        title:"困难气道：",
        titleWidth:70,
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"有",
        textSize:{width:30,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"无",
        textSize:{width:30,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    }]);

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    var lastStartPosX=drawCheckBoxGroup(lodop,[{
        title:"心功能分级：",
        titleWidth:90,
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"Ⅰ",
        textSize:{width:20,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"Ⅱ",
        textSize:{width:20,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"Ⅲ",
        textSize:{width:20,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"Ⅳ",
        textSize:{width:20,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    }]);

    startPosX=lastStartPosX+defaultOpts.itemMargin;
    drawCheckBoxGroup(lodop,[{
        title:"ECG：",
        titleWidth:35,
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"正常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"异常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:80,
        infoLineValue:""
    }]);

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    lastStartPosX=drawCheckBoxGroup(lodop,[{
        title:"胸片：",
        titleWidth:40,
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"正常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"异常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:80,
        infoLineValue:""
    }]);

    startPosX=lastStartPosX+defaultOpts.itemMargin;
    drawCheckBoxGroup(lodop,[{
        title:"心脏超声：",
        titleWidth:80,
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"正常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"异常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:80,
        infoLineValue:""
    }]);

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    lastStartPosX=drawCheckBoxGroup(lodop,[{
        title:"化验结果：",
        titleWidth:80,
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"正常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"异常",
        textSize:{width:40,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:100,
        infoLineValue:""
    }]);

    startPosX=lastStartPosX+defaultOpts.itemMargin;
    opts={
        titleHeight:defaultOpts.titleHeight,
        valueHeight:defaultOpts.valueHeight,
        lineWidth:160,
        titleWidth:40,
        unitWidth:0,
        startPos:{x:startPosX,y:startPosY},
        title:"其他：",
        value:""
    };
    drawTitleValueLine(lodop,opts);


    
    startPos.y+=defaultOpts.lineHeight*5;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:4*defaultOpts.lineHeight},
        startPos:startPos,
        title:"麻醉用药\r\n辅助用药"
    },{
        rectSize:{width:600,height:4*defaultOpts.lineHeight},
        startPos:startPos,
        title:""
    }]);

    startPosY=startPos.y+(defaultOpts.lineHeight-defaultOpts.checkBoxSize.height)/2;
    startPosX=startPos.x+5;
    drawCheckBoxGroup(lodop,[{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"丙泊酚：",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"依托咪酯：",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"咪唑安定：",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    }]);

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    drawCheckBoxGroup(lodop,[{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"芬太尼：",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"瑞芬太尼：",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"舒芬太尼：",
        textSize:{width:70,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    }]);

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    drawCheckBoxGroup(lodop,[{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"局麻药：",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:150,
        infoLineValue:""
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"阿托品：",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    },{
        startPos:{
            x:startPosX,
            y:startPosY
        },
        checked:false,
        text:"麻黄碱：",
        textSize:{width:60,height:defaultOpts.textSize.height},
        emptyValue:defaultOpts.emptyValue,
        infoLineWidth:50,
        infoLineValue:"",
        infoLineUnit:"mg",
        lineUnitWidth:30
    }]);

    startPosY+=defaultOpts.lineHeight;
    startPosX=startPos.x+5;
    lodop.ADD_PRINT_TEXT(startPosY,startPosX,"100%","100%","其他");

    startPos.y+=defaultOpts.lineHeight*4;
    startPos.x=basePos.x;
    var rectHeight=4*defaultOpts.lineHeight+15;
    valueArray=[
        "麻醉前 时点：     BP：      mmHg   HR：    bpm   R：    次/分  SPO2：   %",
        "手术中 时点：     BP：      mmHg   HR：    bpm   R：    次/分  SPO2：   %",
        "       时点：     BP：      mmHg   HR：    bpm   R：    次/分  SPO2：   %",
        "       时点：     BP：      mmHg   HR：    bpm   R：    次/分  SPO2：   %",
        "苏醒期 时点：     BP：      mmHg   HR：    bpm   R：    次/分  SPO2：   %",
        "麻醉过程总结："
    ];
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectHeight},
        startPos:startPos,
        title:"术中情况"
    },{
        rectSize:{width:600,height:rectHeight},
        startPos:startPos,
        title:"",
        value:valueArray.join("\r\n")
    }]);

    startPos.y+=rectHeight;
    startPos.x=basePos.x;
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:defaultOpts.lineHeight},
        startPos:startPos,
        title:"术后情况"
    },{
        rectSize:{width:600,height:defaultOpts.lineHeight},
        startPos:startPos,
        title:"",
        value:"Steward评分：          分  其他：",
        valueVAlignment:"center"
    }]);

    startPos.y+=defaultOpts.lineHeight;
    startPos.x=basePos.x;
    rectHeight=2*defaultOpts.lineHeight+10;
    valueArray=[
        "1、卧床休息监护大于30分钟，24小时不能从事高危（如开车等）作业；",
        "2、神志完全清醒，能正确定向、站立行走无眩晕，可由家属陪伴回家；",
        "3、门诊随访。"
    ];
    drawRectAndTitleGroup(lodop,[{
        rectSize:{width:120,height:rectHeight},
        startPos:startPos,
        title:"麻醉后医嘱"
    },{
        rectSize:{width:510,height:rectHeight},
        startPos:startPos,
        title:"",
        value:valueArray.join("\r\n")
    },{
        rectSize:{width:90,height:rectHeight},
        startPos:startPos,
        title:"",
        value:"麻醉医生"
    }]);
}