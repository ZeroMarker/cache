const growthCurveConfig = {
    colCount : 28,
    rowCount : 90,
    xAxis: function(customAxis){
        var xAxisArr = [];
        for(var i=0; i <= this.colCount; i++){
            xAxisArr.push({
                index: i,
                desc: i+22,
                showDesc : (i%2 == 0) ? true : false,
                subDesc: (customAxis)&&(customAxis.length)&&(i >= customAxis.length) ? "" : customAxis[i]
            });
        }
        return xAxisArr;
    },
    yAxisArr:[
        {
            code: "lengthUnit",
            desc: "长度左侧垂直坐标�?,
            unitDesc: "Centimeters",
            startRow: 45,
            endRow: 90,
            minimum: 15,
            maximum: 60,
            interval: 1,
            align: "left"
        },{
            code: "weightUnit",
            desc: "重量右侧垂直坐标�?,
            unitDesc: "Weight(kilograms)",
            startRow: 0,
            endRow: 70,
            minimum: 0,
            maximum: 7,
            interval: 0.1,
            align: "right"
        },{
            code: "weightUnit2",
            desc: "重量左侧垂直坐标�?,
            unitDesc: "Weight(kilograms)",
            startRow: 0,
            endRow: 40,
            minimum: 0,
            maximum: 4,
            interval: 0.1,
            align: "left"
        },{
            code: "lengthUnit2",
            desc: "长度右侧垂直坐标�?,
            unitDesc: "Centimeters",
            startRow: 70,
            endRow: 90,
            minimum: 40,
            maximum: 60,
            interval: 1,
            align: "right"
        }
    ],
    lengend: [
        {
            code: "crossLine",
            desc: "叉线",
            type: "crossLine",
            strokeColor: "red",
            data: [{x:-3,y:3},{x:3,y:-3},{x:-3,y:-3},{x:3,y:3}]
        }
    ],
    strokeColor : "black",
    curve:[
        {
            code: "UpperMaxLengthLimit",
            desc: "男孩头围�?大范�?,
            lineDash: [2,2],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:21.5, textInfo:"5%", fontSize: 12, yOffSet: -8, strokeColor: "red"},{index:12, textInfo:"Length", fontSize: 20, yOffSet: -50, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = 0.0077 * x * x + 1.2601 * x + 27.845;
                return y;
            }
        }
    ]
};

DisplaySheet.prototype.drawAreas = function () {
    for (var i = 0; i < this.currentPage.Areas.length; i++) {
        if(this.currentPage.Areas[i].Code == "growthCurve"){
            this.drawArea(this.currentPage.Areas[i]);
            this.drawGrowthChart(this.currentPage.Areas[i]);
        }else{
            this.drawArea(this.currentPage.Areas[i]);
        }
    }
}

DisplaySheet.prototype.drawGrowthChart = function(area){
    var rect = {
        left: area.DisplayRect.left * this.ratio.x,
        top: area.DisplayRect.top * this.ratio.y,
        width: area.DisplayRect.width * this.ratio.x,
        height: area.DisplayRect.height * this.ratio.y
    };

    //绘制横线
    for(var i=0; i< growthCurveConfig.colCount; i++){
        var lineStartPos = {
            x: rect.left + (rect.width / growthCurveConfig.colCount) * i,
            y: rect.top
        };
        var lineEndPos = {
            x: rect.left + (rect.width / growthCurveConfig.colCount) * i,
            y: rect.top + rect.height
        };
        var lineScalePos = {
            x: rect.left + (rect.width / growthCurveConfig.colCount) * i,
            y: rect.top + rect.height - (rect.height / growthCurveConfig.rowCount) * 0.8
        };

        if((i+2)%4 == 0){
            this.drawContext.drawLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }else{
            this.drawContext.drawDashLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }
        this.drawContext.drawLine(lineScalePos, lineEndPos, growthCurveConfig.strokeStyle);
    }

    //绘制竖线
    for(var j=0; j < growthCurveConfig.rowCount; j++){
        var lineStartPos = {
            x: rect.left,
            y: rect.top + (rect.height / growthCurveConfig.rowCount) * j
        };
        var lineEndPos = {
            x: rect.left + rect.width,
            y: rect.top + (rect.height / growthCurveConfig.rowCount) * j
        }
        var lineScalePos = {
            x: rect.left + (rect.height / growthCurveConfig.rowCount) * 0.8,
            y: rect.top + (rect.height / growthCurveConfig.rowCount) * j
        };

        if( j % 5 == 0){
            this.drawContext.drawLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }else{
            this.drawContext.drawDashLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }
        this.drawContext.drawLine(lineStartPos, lineScalePos, growthCurveConfig.strokeStyle);
    }
    
    //绘制横坐标轴
    this.drawXScale(rect);
    //绘制竖坐标轴
    this.drawYScale(rect);

    this.gender = "";
    var patSex = this.editPluginManager.operAppData["Gender"];
    if(patSex == "�?){
        this.gender = "Boys";
    }else{
        this.gender = "Girls";
    }

    //绘制默认范围曲线
    for(var i=0; i < growthCurveConfig.curve.length; i++){
        if(growthCurveConfig.curve[i].genderType == this.gender){
            this.drawCurve(rect, growthCurveConfig.curve[i]);
        }
    }

    var weightCurve = {
        code: "WeightData",
        desc: "体重",
        lineDash: null,
        strokeColor: "black",
        lengendCode: "crossLine",
        yAxisCode: "weightUnit",
        genderType: null,
        data: this.getWeightDataList()
    };
    console.dir(weightCurve);
    this.drawCurve(rect, weightCurve);

    //绘制性别标识
    var genderPos = {x: rect.left + rect.width * 0.05, y: rect.top + rect.height * 0.45};
    this.drawGenderInfo(this.gender, genderPos, "Sans-serif", "100", "#ddd");
}

DisplaySheet.prototype.drawXScale = function(rect){
    var areaItemStyle = areaItemStyle = this.getStyleByCode("AreaItemStyle");
    var textColor = areaItemStyle.FontStyle.FontColor;
    var fontSize = areaItemStyle.FontStyle.FontSize * this.ratio.fontRatio;
    var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
    
    var xAxisArr = this.getXAxisInfo();
    for(var i=0; i < xAxisArr.length; i++){
        if(!xAxisArr[i].showDesc) continue;

        var text = xAxisArr[i].desc;
        var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle);
        var textPos = {
            x: rect.left - textWidth/2 + rect.width / growthCurveConfig.colCount * i,
            y: rect.top + rect.height
        }
        this.drawContext.drawString(text, textPos, textColor, textStyle);

        var subText = xAxisArr[i].subDesc;
        var subTextWidth = this.canvasContext.measureTextWidth(subText, textColor, textStyle);
        var subTextPos = {
            x: rect.left - subTextWidth/2 + rect.width / growthCurveConfig.colCount * i,
            y: rect.top + rect.height + fontSize * 1.5
        }
        this.drawContext.drawString(subText, subTextPos, textColor, textStyle);
    }
}

DisplaySheet.prototype.drawYScale = function(rect){
    var areaItemStyle = areaItemStyle = this.getStyleByCode("AreaItemStyle");
    var textColor = areaItemStyle.FontStyle.FontColor;
    var fontSize = areaItemStyle.FontStyle.FontSize * this.ratio.fontRatio;
    var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;

    var yAxisArr = growthCurveConfig.yAxisArr;
    for(var i = 0; i < yAxisArr.length; i++){
        var startRow = yAxisArr[i].startRow;
        var endRow = yAxisArr[i].endRow;
        var minValue = yAxisArr[i].minimum;
        var maxValue = yAxisArr[i].maximum;
        var interval = yAxisArr[i].interval;
        var align = yAxisArr[i].align;
        var maxTextWidth = 0;
        var unitDesc = yAxisArr[i].unitDesc;
        for(var j = startRow; j <= endRow; j++){
            if(j%5 ==0){
                var text = (j - startRow) * interval + minValue;

                var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle);
                var textPos = {
                    x: rect.left - textWidth,
                    y: rect.top + rect.height - j * (rect.height / growthCurveConfig.rowCount) - fontSize/2
                }
                if(align == "right"){
                    textPos.x = rect.left + rect.width
                }
                if(j > 0) this.drawContext.drawString(text, textPos, textColor, textStyle);
                if(maxTextWidth < textWidth) maxTextWidth = textWidth;
            }
        }
        var unitDescWidth = this.canvasContext.measureTextWidth(unitDesc, textColor, textStyle);
        var maxTextHeight = endRow * (rect.height / growthCurveConfig.rowCount);
        var unitDescPos = {
            x: rect.left - maxTextWidth *1.5,
            y: rect.top + rect.height - maxTextHeight/2 - unitDescWidth/2 - startRow * (rect.height / growthCurveConfig.rowCount)/2
        }
        if(align == "right"){
            unitDescPos.x = rect.left + rect.width + maxTextWidth * 1.5;
        }
        this.drawContext.drawVerticalString(unitDesc, unitDescPos, textColor, textStyle, fontSize, "", "", 0);
    }
}

DisplaySheet.prototype.drawLengend = function(position, lengend){
    if(lengend.type == "crossLine"){
        var lineStartPos1 = {
            x: position.x + lengend.data[0].x,
            y: position.y + lengend.data[0].y,
        };
        var lineEndPos1 = {
            x: position.x + lengend.data[1].x,
            y: position.y + lengend.data[1].y,
        };

        var lineStartPos2 = {
            x: position.x + lengend.data[2].x,
            y: position.y + lengend.data[2].y,
        };
        var lineEndPos2 = {
            x: position.x + lengend.data[3].x,
            y: position.y + lengend.data[3].y,
        };
        this.drawContext.drawLine(lineStartPos1, lineEndPos1, lengend.strokeColor);
        this.drawContext.drawLine(lineStartPos2, lineEndPos2, lengend.strokeColor);
    }
}

DisplaySheet.prototype.drawCurve = function(rect, curveInfo){
    var yAxisInfo = this.getYAxisByCode(curveInfo.yAxisCode);
    if(curveInfo.data && curveInfo.data.length){
        var lastDataPos = null;
        for(var i=0; i < curveInfo.data.length; i++){
            var singleData = curveInfo.data[i];
            var xPos = rect.left + (rect.width / growthCurveConfig.colCount) * singleData.index;
            var yPos = getYPostionByValue(singleData.value, rect, yAxisInfo);
            if(yPos < rect.top) continue;
            if(yPos > rect.top + rect.height) continue;
            var pos = { x: xPos, y: yPos };
            this.drawLengend(pos, growthCurveConfig.lengend[0]);
            if(i >= 1){
                if(lastDataPos) {
                    if(curveInfo.lineDash){
                        this.drawContext.drawDashLine(lastDataPos, pos, curveInfo.strokeColor, curveInfo.lineDash);
                    }else{
                        this.drawContext.drawLine(lastDataPos, pos, curveInfo.strokeColor);
                    }
                }
            }
            lastDataPos = pos;
        }
    }

    if(curveInfo.fn){
        var lastCurveDataPos = null;
        for(var i = curveInfo.startIndex; i < curveInfo.endIndex; i += 0.1){
            var value = curveInfo.fn(i);
            var xPos = rect.left + (rect.width / growthCurveConfig.colCount) * i;
            var yPos = getYPostionByValue(value, rect, yAxisInfo)
            if(yPos < rect.top) continue;
            if(yPos > rect.top + rect.height) continue;
            var pos = {x: xPos, y: yPos};
            if(lastCurveDataPos){
                if(curveInfo.lineDash){
                    this.drawContext.drawDashLine(lastCurveDataPos, pos, curveInfo.strokeColor, curveInfo.lineDash);
                }else{
                    this.drawContext.drawLine(lastCurveDataPos, pos, curveInfo.strokeColor);
                }
            }
            lastCurveDataPos = pos;
        }
    }
    if(curveInfo.lineInfo && curveInfo.lineInfo.length && curveInfo.fn){
        var areaItemStyle = this.getStyleByCode("AreaItemStyle");
        for(var i = 0; i < curveInfo.lineInfo.length; i++){
            var info = curveInfo.lineInfo[i];
            var value = curveInfo.fn(info.index);
            var xPos = rect.left + (rect.width / growthCurveConfig.colCount) * info.index;
            var yPos = getYPostionByValue(value, rect, yAxisInfo)
            var textColor = info.strokeColor;
            var fontSize = info.fontSize * this.ratio.fontRatio;
            var yOffSet = info.yOffSet * this.ratio.y;
            var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
            var text = info.textInfo;
            var textPos = {x: xPos, y: yPos + yOffSet};
            this.drawContext.drawString(text, textPos, textColor, textStyle);
        }
    }

    function getYPostionByValue(value, rect, yAxisInfo){
        var valueLength = ((yAxisInfo.maximum - yAxisInfo.minimum)/yAxisInfo.interval) / ((yAxisInfo.endRow- yAxisInfo.startRow) * yAxisInfo.interval) * (rect.height / growthCurveConfig.rowCount);
        var yPos = rect.top + rect.height - ((value - yAxisInfo.minimum) * valueLength + yAxisInfo.startRow * (rect.height / growthCurveConfig.rowCount));
        return yPos;
    }
}

DisplaySheet.prototype.getYAxisByCode = function(yAxisCode) {
    var result = null;
    var yAxisArr = growthCurveConfig.yAxisArr;
    for(var i = 0; i < yAxisArr.length; i++){
        var code = yAxisArr[i].code;
        if(code == yAxisCode){
            result = yAxisArr[i];
        }
    }
    return result;
}

DisplaySheet.prototype.drawGenderInfo = function(genderText, textPos, fontFamily, fontSize, textColor){
    var textStyle = "bold " + fontSize * this.ratio.fontRatio + "px " + fontFamily;
    this.drawContext.drawString(genderText, textPos, textColor, textStyle);
}

DisplaySheet.prototype.loadPatWeightInfo = function(){
    var icuaId = dhccl.getQueryString("icuaId");
    var patWeightData = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "web.DHCICUCom",
        QueryName: "FindPatWeight",
        Arg1: icuaId,
        Arg2: "2019-08-29",
        Arg3: "",
        Arg4: "2019-09-04",
        Arg5: "",
        ArgCnt: 5
    }, "json");
    return patWeightData;
}

DisplaySheet.prototype.initSheet = function(){
    this.patWeightData = this.loadPatWeightInfo();

    this.setPageSize();
    this.setCurrentPage(this.sheet.Pages[0].PageNo);
}

DisplaySheet.prototype.getXAxisInfo = function(){
    var xAxisArr = [];
    for(var i=0; i <= growthCurveConfig.colCount; i++){
        var xAxisInfo = {
            index: i,
            desc: i+22,
            showDesc : (i%2 == 0) ? true : false,
            dateTime: "",
            subDesc: ""
        };

        if(i < this.patWeightData.length){
            var datetime = this.patWeightData[i].DateTime;
            var date = datetime.split(' ')[0];
            var dateMonthAndDay = date.split('-')[1] + '-' + date.split('-')[2];
            xAxisInfo.dateTime = datetime;
            xAxisInfo.subDesc = dateMonthAndDay;
        }
        xAxisArr.push(xAxisInfo);
    }
    return xAxisArr;
}

DisplaySheet.prototype.getDataIndexByXAxis = function(singleData){
    var index = null;
    var xAxisArr = this.getXAxisInfo()
    for(var i=0; i< xAxisArr.length; i++){
        if(xAxisArr[i].dateTime == singleData.DateTime){
            index = i;
        }
    }
    return index;
}

DisplaySheet.prototype.getWeightDataList = function(){
    var weightDataList = [];
    for(var i=0; i < this.patWeightData.length; i++){
        var index = this.getDataIndexByXAxis(this.patWeightData[i]);
        if(index == null) continue;
        weightDataList.push({
            index: index,
            value: parseFloat(this.patWeightData[i].Weight)
        });
    }
    return weightDataList;
}

EditPluginManager.prototype.getOperAppData = function () {
    var icuaId = dhccl.getQueryString("icuaId");

    var result = dhccl.runServerMethodNormal("web.DHCICUCom", "GetIcuaInfo", icuaId);
    var currentPatient = {};
    var resultArr = result.split('^');
    if (resultArr.length >= 4) {
        var patBaseInfoArr = resultArr[0].split(String.fromCharCode(3));
        if (patBaseInfoArr.length >= 25) {
            currentPatient.RegisterNo = patBaseInfoArr[0];
            currentPatient.DeptDesc = patBaseInfoArr[1];
            currentPatient.Gender = patBaseInfoArr[3];
            currentPatient.Name = patBaseInfoArr[4];
            currentPatient.BedNo = patBaseInfoArr[6];
            currentPatient.Age = patBaseInfoArr[7];
            currentPatient.WardDesc = patBaseInfoArr[8];
            currentPatient.DoctorName = patBaseInfoArr[11];
            currentPatient.MedicareNo = patBaseInfoArr[12];
            //currentPatient.Diagnosis = patBaseInfoArr[13];
            currentPatient.DOB = patBaseInfoArr[17];
        }
        if (patBaseInfoArr.length >= 27) {
            currentPatient.SecAlias = patBaseInfoArr[25];
            currentPatient.PatLevel = patBaseInfoArr[26];
        }

        var patInfoArr = resultArr[1].split(String.fromCharCode(3));
        if (patInfoArr.length >= 16) {
            currentPatient.AdmDate = patInfoArr[0];
            currentPatient.Diagnosis = patInfoArr[1];
            currentPatient.InICUDays = patInfoArr[2];
            currentPatient.EpisodeId = patInfoArr[3];
            currentPatient.WardId = patInfoArr[4];
            currentPatient.InWardDT = patInfoArr[7];
            currentPatient.IcuaId = patInfoArr[8];
            currentPatient.Height = patInfoArr[9];
            currentPatient.Weight = patInfoArr[10];
            currentPatient.PreDept = patInfoArr[11];
            currentPatient.PreWard = patInfoArr[12];
            currentPatient.ARF = patInfoArr[16];
            currentPatient.CHP = patInfoArr[17];
            if (patInfoArr.length > 18) {
                currentPatient.ICUAResidentCtcpDr = patInfoArr[18];
                currentPatient.ICUAAttendingCtcpDr = patInfoArr[19];
                currentPatient.ICUASurgeryType = patInfoArr[20];
                currentPatient.ICUAInfectedSite = patInfoArr[21];
                currentPatient.ICUAShockType = patInfoArr[22];
                currentPatient.ICUAEyeOpeningCLCSODr = patInfoArr[23];
                currentPatient.ICUAVerbalResponseCLCSODr = patInfoArr[24];
                currentPatient.ICUAMotorResponseCLCSODr = patInfoArr[25];
                currentPatient.ICUAGlascowPoint = patInfoArr[26];
                currentPatient.ICUAAPSPoint = patInfoArr[27];
                currentPatient.ICUAAgePoint = patInfoArr[28];
                currentPatient.ICUACHPPoint = patInfoArr[29];
                currentPatient.ICUAApacheIIPoint = patInfoArr[30];
                currentPatient.ICUADiagnosticCatCLCSODr = patInfoArr[31];
                currentPatient.ICUADeathProbability = patInfoArr[32];

                currentPatient.ICUALeaveCondition = patInfoArr[33]; //病人去向 20140314 whl
                currentPatient.ICUALeaveDate = patInfoArr[34]; //出科日期20140314whl
                currentPatient.ICUALeaveTime = patInfoArr[35]; //出科时间20140314whl

                currentPatient.ICUAChargeNurseDr = patInfoArr[36]; //责任护士 by Lyn 20150427
                currentPatient.ICUASupervisorNurseDr = patInfoArr[37]; //主管护士 by Lyn 20150427
                currentPatient.ICUAHostpitalCode = patInfoArr[38]; //医院编码
                currentPatient.ICUAResidence = patInfoArr[39]; // 住所来源
                currentPatient.ICUAIsEstimatedHeight = patInfoArr[40]; // 是否估计身高
                currentPatient.ICUAIsEstimatedWeight = patInfoArr[41]; // 是否估计体重
                currentPatient.ICUAPregnant = patInfoArr[42]; // 妊娠情况
                currentPatient.ICUAGestation = patInfoArr[43]; // 孕周
                currentPatient.ICUADeliveryDate = patInfoArr[44]; // 分娩日期
                currentPatient.ICUAPreDayCPR = patInfoArr[45]; // CPR
                currentPatient.ICUASourceHospital = patInfoArr[46]; // 医院来源
                currentPatient.ICUASourceLocationType = patInfoArr[47]; // 来源医院科室类型
                currentPatient.ICUAPreHospitalAdmDate = patInfoArr[48]; // 入其他医院时�?
                currentPatient.ICUPMIsEstimatedBirthdate = patInfoArr[49]; // 是否估计出生日期
                currentPatient.ICUPMEthnicity = patInfoArr[50]; //种族
                currentPatient.ICUAArriveAssistance = patInfoArr[51]; //基础心肺疾病
                currentPatient.ICUANoninvasVentilationHour = patInfoArr[52]; //无创呼吸机（小时�?
                currentPatient.ICUAMechanVentilationHour = patInfoArr[53]; //有创呼吸机（小时�?
                currentPatient.ICUACrrtHour = patInfoArr[54]; //CRRT（小时）
                currentPatient.ICUAVasoactiveDrugHour = patInfoArr[55]; //�?管活性药（小时）
                currentPatient.ICUAHavePronePositionDay = patInfoArr[56]; //有俯卧位（天�?
                currentPatient.ICUAIsBrainstemDeath = patInfoArr[57]; //是否脑死�?
                currentPatient.ICUAIsOrganDonation = patInfoArr[58]; //是否器官捐赠
                currentPatient.ICUALimitedTreatment = patInfoArr[59]; //限制治疗
                currentPatient.ICUANEHour = patInfoArr[60]; //去甲肾上腺素（小时）
                currentPatient.ICUAEpiHour = patInfoArr[61]; //肾上腺素（小时）
                currentPatient.ICUADAHour = patInfoArr[62]; //多巴胺（小时�?
                currentPatient.ICUADobuHour = patInfoArr[63]; //多巴酚丁胺（小时�?
                currentPatient.ICUASourceType = patInfoArr[64]; //收治类型
                currentPatient.ICUWardID = patInfoArr[65]; //icu病区ID
                currentPatient.ICULocID = patInfoArr[66]; //icu科室ID
                currentPatient.ICULinkLocIDStr = patInfoArr[67]; //icu科室关联科室ID
                currentPatient.InWardDays = patInfoArr[68]; //入科室天�?
                currentPatient.ICUCanRestart = patInfoArr[69]; //当前记录是否能够再开始监�?
            }
        }
    }
    return currentPatient;
}

EditPluginManager.prototype.getOperDatas = function () {
    return [];
}

EditPluginManager.prototype.getSignatureList = function () {
    return [];
}

EditPluginManager.prototype.setSheetPermission = function () {

}

$(initPage);

function initPage() {

    var moduleId = dhccl.getQueryString("dataModuleId");
    if (moduleId) {
        $.ajax({
            url: ANCSP.MethodService,
            async: true,
            data: {
                ClassName: "web.DHCICUCPrintTemplate",
                MethodName: "GetPrintTemplate",
                Arg1: moduleId,
                ArgCnt: 1
            },
            type: "post",
            success: function (data) {
                let result = $.trim(data);
                if (result) {
                    templateId = result.split("^")[0];
                    let sheetData = $.parseJSON(result.split("^")[1]);
                    initTemplate(sheetData);
                } else {
                    $.messager.alert("错误", "未配置打印模�?", "error");
                }
            }
        });
    }else{
        $.messager.alert("错误", "dataModuleId不对，请传正确的参数!", "error");
    }
}

function initTemplate(data) {
    var sheet = data.Sheet;

    var canvas = document.getElementById("myCanvas");
    var displaySheet = new DisplaySheet({
        canvas: canvas,
        sheet: sheet,
        editMode: true,
        onPageResize: function () {
            HIDPI();
        },
        ratio: {
            x: 1,
            y: 1,
            fontRatio: 1
        }
    });

    $("#btnPrint").linkbutton({
        onClick: function () {
            var valueObject = displaySheet.editPluginManager.getValueObject();
            var tableValuesArray = null;
            var lodopPrintView = window.LodopPrintView.instance;
            if (!lodopPrintView) {
                lodopPrintView = window.LodopPrintView.init({
                    sheetData: sheet,
                    valueObject: valueObject
                });
            } else {
                lodopPrintView.setPrintData(valueObject, tableValuesArray);
            }
            lodopPrintView.print();
        }
    });

    $("#btnRefresh").linkbutton({
        onClick: function () {
            window.location.reload();
        }
    });

    function HIDPI() {
        var ratio = window.devicePixelRatio || 1;
        var canvas = document.getElementById("myCanvas");
        var context = canvas.getContext("2d");
        var oldWidth = canvas.width;
        var oldHeight = canvas.height;
        canvas.width = oldWidth * ratio;
        canvas.height = oldHeight * ratio;
        canvas.style.width = oldWidth + "px";
        canvas.style.height = oldHeight + "px";
        context.scale(ratio, ratio);
    }
}