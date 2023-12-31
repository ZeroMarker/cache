/**
 * 麻醉记录上下文类
 * @author chenchangqing 20170905
 */
function RecordContext(opt) {
    this.options = opt;
    /**
     * 数据最大时间
     */
    this.dataMaxDT = new Date('1/1/1997');
    /**
     * 手术计划ID
     */
    this.opsId = dhccl.getQueryString("opsId");
    /**
     * 数据模块ID
     */
    this.moduleId = session.ModuleID;
    /**
     * 麻醉表单ID
     */
    this.recordSheetID = session['RecordSheetID'];
    /**
     * 麻醉表单配置地址
     */
    this.sheeturl = "../service/dhcanop/data/pacurecord.xdxa.nodata.json";
    /**
     * 上下文Query参数
     */
    this.contextPara = [{
            ListName: "schedules",
            ClassName: ANCLS.BLL.OperSchedule,
            QueryName: "FindOperScheduleList",
            Arg1: "",
            Arg2: "",
            Arg3: "",
            Arg4: this.opsId,
            ArgCnt: 4
        },
        {
            ListName: "operationList",
            ClassName: ANCLS.BLL.OperationList,
            QueryName: "FindOperationList",
            Arg1: this.opsId,
            ArgCnt: 1
        },
        {
            ListName: "planOperationList",
            ClassName: ANCLS.BLL.OperationList,
            QueryName: "FindPlanOperationList",
            Arg1: this.opsId,
            ArgCnt: 1
        },
        {
            ListName: "dataCategories",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDataCategory",
            ArgCnt: 0
        },
        {
            ListName: "categoryItems",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindCategoryItem",
            Arg1: "",
            Arg2: "",
            ArgCnt: 2
        },
        {
            ListName: "vitalSignItems",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindVitalSign",
            Arg1: "",
            ArgCnt: 1
        },
        {
            ListName: "drugItems",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDrugItem",
            ArgCnt: 0
        },
        {
            ListName: "eventItems",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindEventItem",
            Arg1: "",
            ArgCnt: 1
        },
        {
            ListName: "eventDetailItems",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindEventOptions",
            Arg1: "",
            ArgCnt: 1
        },
        {
            ListName: "legends",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindLegends",
            Arg1: "",
            ArgCnt: 1
        },
        {
            ListName: "legendDatas",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindLegendData",
            Arg1: "All",
            ArgCnt: 1
        },
        {
            ListName: "operClassList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperClass",
            ArgCnt: 0
        },
        {
            ListName: "bladeTypeList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBladeType",
            ArgCnt: 0
        },
        {
            ListName: "bodySiteList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBodySite",
            ArgCnt: 0
        },
        {
            ListName: "operPosList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperPosition",
            ArgCnt: 0
        },
        {
            ListName: "asaClassList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindASAClass",
            ArgCnt: 0
        },
        {
            ListName: "paraItems",
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindParaItems",
            Arg1: this.recordSheetID,
            ArgCnt: 1
        },
        {
            ListName: "timeLines",
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindTimeLines",
            Arg1: this.recordSheetID,
            ArgCnt: 1
        },
        {
            ListName: "actionPermissions",
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindActionPermission",
            Arg1: session.GroupID,
            Arg2: this.moduleId,
            Arg3: "Y",
            ArgCnt: 3
        },
        {
            ListName: "operActions",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperActions",
            Arg1: this.moduleId,
            ArgCnt: 1
        },
        {
            ListName: "drugDoseUnits",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "D",
            ArgCnt: 2
        },
        {
            ListName: "units",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "",
            ArgCnt: 2
        },
        {
            ListName: "drugSpeedUnits",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "S",
            ArgCnt: 2
        },
        {
            ListName: "drugConcentrationUnits",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindUom",
            Arg1: "",
            Arg2: "C",
            ArgCnt: 2
        },
        {
            ListName: "drugInstructions",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindInstruction",
            ArgCnt: 0
        },
        {
            ListName: "drugReasons",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindReason",
            Arg1: "A",
            ArgCnt: 1
        },
        {
            ListName: "drugGroups",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDrugGroup",
            ArgCnt: 0
        },
        {
            ListName: "drugGroupItems",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDrugGroupItems",
            ArgCnt: 0
        }
    ];
};

var contextProto = RecordContext.prototype;
contextProto.loadRecordSheet = function() {
    if (this.recordSheetID || !this.opsId) return;
    var _this = this;
    this.recordSheet = null;
    var data = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.RecordSheet,
        QueryName: 'FindRecordSheets',
        Arg1: this.opsId,
        Arg2: this.moduleId,
        ArgCnt: 2
    }, "json", true, function(data) {
        if (data.length > 0)
            _this.recordSheet = data[0];
    });
};
/**
 * 加载麻醉记录上下文数据
 * @author chenchangqing 20170905
 */
contextProto.loadData = function() {
    var queryData = dhccl.getDatas(ANCSP.DataQueries, {
        jsonData: dhccl.formatObjects(this.contextPara)
    }, "json");
    if (queryData) {
        for (var key in queryData) {
            this[key] = queryData[key];
        }
        if (this.schedules && this.schedules.length > 0) {
            this.schedule = this.schedules[0];
            if (this.options.onLoadSchedule) {
                this.options.onLoadSchedule(this.schedule);
            }
        }
    }
};

/**
 * 加载麻醉表单配置信息
 * @author chenchangqing 20170906
 */
contextProto.loadSheet = function() {
    var sheet = null;
    $.ajaxSettings.async = false;
    $.getJSON(this.sheeturl + "?random=" + Math.random(), function(data) {
        sheet = data.sheet;
    });
    $.ajaxSettings.async = true;
    if (sheet) {
        for (var key in sheet) {
            this[key] = sheet[key];
        }
        this.displayAreas = this.content.displayAreas;
        this.displayCategories = this.content.displayAreas.item.displayCategories;
    }
};

contextProto.resetLoadingStatus = function() {
    this.loadingStatus = {
        anaData: false,
        drugData: false,
        eventData: false
    }
}

contextProto.loadingComplete = function() {
    if (this.loadingStatus) {
        return this.loadingStatus.anaData &&
            this.loadingStatus.drugData &&
            this.loadingStatus.eventData
    }
    return false;
}

/**
 * 加载麻醉记录数据
 * @author chenchangqing 20171020
 */
contextProto.loadAnaDatas = function(fn) {
    var _this = this;
    this.resetLoadingStatus();
    this.eventDatas = [];
    this.anaDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.AnaestRecord,
        QueryName: "FindAnaDatas",
        Arg1: this.recordSheetID,
        Arg2: "N",
        ArgCnt: 2
    }, "json", true, function(data) {
        _this.anaDatas = data;
        _this.loadingStatus.anaData = true;
        if (_this.loadingComplete()) {
            _this.regulateAnaDatas();
            if (fn) fn.call(_this);
        }
    });
    this.loadDrugDatas(fn);
    this.loadEventDatas(fn);
};

contextProto.loadDrugDatas = function(fn) {
    var _this = this;
    this.drugDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.AnaestRecord,
        QueryName: "FindDrugDatas",
        Arg1: this.recordSheetID,
        Arg2: 'N',
        ArgCnt: 2
    }, "json", true, function(data) {
        _this.drugDatas = data;
        _this.loadingStatus.drugData = true;
        if (_this.loadingComplete()) {
            _this.regulateAnaDatas();
            if (fn) fn.call(_this);
        }
    });
}

contextProto.loadEventDatas = function(fn) {
    var _this = this;
    this.eventDetailDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.AnaestRecord,
        QueryName: "FindEventDatas",
        Arg1: this.recordSheetID,
        Arg2: 'N',
        ArgCnt: 2
    }, "json", true, function(data) {
        _this.eventDetailDatas = data;
        _this.loadingStatus.eventData = true;
        if (_this.loadingComplete()) {
            _this.regulateAnaDatas();
            if (fn) fn.call(_this);
        }
    });
}

/**
 * 规则化麻醉单数据
 */
contextProto.regulateAnaDatas = function() {
    if (this.anaDatas && this.anaDatas.length > 0) {
        for (var i = 0; i < this.anaDatas.length; i++) {
            var anaData = this.anaDatas[i];
            anaData.StartDT = dhccl.toDateTime(anaData.StartDT);
            anaData.StartDateTime = anaData.StartDT.format(constant.dateTimeFormat);
            anaData.EndDT = dhccl.toDateTime(anaData.EndDT);
            this.setDataMaxDT(anaData.EndDT);
            anaData.EndDateTime = anaData.EndDT.format(constant.dateTimeFormat);
            anaData.ClassName = ANCLS.Model.AnaData;
            anaData.DisplayName = anaData.DataValue;
            anaData.DrugData = this.getDrugData(anaData.RowId);
            anaData.DrugDataList = this.getDrugDataList(anaData.RowId); //如果这里处理太慢的话，可以直接后台传出整理好的anaData
            if (anaData.DrugData) {
                if (anaData.DrugData.Speed) {
                    anaData.DisplayName = anaData.DrugData.Speed + anaData.DrugData.SpeedUnitDesc;
                } else {
                    anaData.DisplayName = anaData.DrugData.DoseQty;
                }
            }
            if (anaData.ItemCategory === "E") { // 关联事件明细数据
                anaData.EventDetailDatas = this.getEventDetailDatas(anaData.RowId);
                anaData.EventDetail = this.getEventDetailStr(anaData.EventDetailDatas);
                this.eventDatas.push(anaData);
            }

        }
        //this.anaDatas.sort(dhccl.compareInstance("StartDT"));
        this.onLoadAnaData();
    }
}

/**
 * 加载个人偏好设置
 */
contextProto.loadPersonalSetting = function(fn) {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindPersonalSetting',
        Arg1: session['ModuleID'],
        Arg2: session['UserID'],
        ArgCnt: 2
    }, 'json', true, function(data) {
        if (fn) fn.call(this, data);
    });
}

var loadingStatus = {
    isTemplateCompleted: function() {
        return this.template && this.templateItem &&
            this.templateData && this.templateDrug && this.templateEvent;
    }
};

/**
 * 加载模板数据
 */
contextProto.loadTemplate = function(fn) {
    var _this = this;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindModuleTemplate',
        Arg1: session['DeptID'],
        Arg2: session['UserID'],
        Arg3: record.context.moduleId,
        ArgCnt: 3
    }, 'json', true, function(data) {
        _this.templates = data;
        loadingStatus.template = true;
        if (loadingStatus.isTemplateCompleted()) {
            _this.regulateTemplate();
            if (fn) fn.call(_this);
        }
    });

    $.extend(loadingStatus, {
        template: false,
        templateItem: false,
        templateData: false,
        templateDrug: false,
        templateEvent: false
    });
    this.loadTemplateItem(fn);
    this.loadTemplateData(fn);
    this.loadTemplateDrug(fn);
    this.loadTemplateEvent(fn);
}

contextProto.loadTemplateItem = function(fn) {
    var _this = this;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindModuleTemplateItem',
        Arg1: session['DeptID'],
        Arg2: session['UserID'],
        Arg3: record.context.moduleId,
        ArgCnt: 3
    }, 'json', true, function(data) {
        _this.templateItems = data;
        loadingStatus.templateItem = true;
        if (loadingStatus.isTemplateCompleted()) {
            _this.regulateTemplate();
            if (fn) fn.call(_this);
        }
    });
}

contextProto.loadTemplateData = function(fn) {
    var _this = this;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindModuleTemplateData',
        Arg1: session['DeptID'],
        Arg2: session['UserID'],
        Arg3: record.context.moduleId,
        ArgCnt: 3
    }, 'json', true, function(data) {
        _this.templateDatas = data;
        loadingStatus.templateData = true;
        if (loadingStatus.isTemplateCompleted()) {
            _this.regulateTemplate();
            if (fn) fn.call(_this);
        }
    });
}

contextProto.loadTemplateDrug = function(fn) {
    var _this = this;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindModuleTemplateDrug',
        Arg1: session['DeptID'],
        Arg2: session['UserID'],
        Arg3: record.context.moduleId,
        ArgCnt: 3
    }, 'json', true, function(data) {
        _this.templateDrugs = data;
        loadingStatus.templateDrug = true;
        if (loadingStatus.isTemplateCompleted()) {
            _this.regulateTemplate();
            if (fn) fn.call(_this);
        }
    });
}

contextProto.loadTemplateEvent = function(fn) {
    var _this = this;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindModuleTemplateEvent',
        Arg1: session['DeptID'],
        Arg2: session['UserID'],
        Arg3: record.context.moduleId,
        ArgCnt: 3
    }, 'json', true, function(data) {
        _this.templateEvents = data;
        loadingStatus.templateEvent = true;
        if (loadingStatus.isTemplateCompleted()) {
            _this.regulateTemplate();
            if (fn) fn.call(_this);
        }
    });
}

/**
 * 规则化用户模板数据
 */
contextProto.regulateTemplate = function() {
    var templates = this.templates;
    var templateItems = this.templateItems;
    var templateDatas = this.templateDatas;
    var templateDrugs = this.templateDrugs;
    var templateEvents = this.templateEvents;

    if (templates && templateItems) {
        var length = templateItems.length;
        var templateLength = templates.length;
        var item = null,
            template = null;
        for (var i = 0; i < length; i++) {
            item = templateItems[i];
            for (var j = 0; j < templateLength; j++) {
                if (templates[j].RowId === item.Template) {
                    var template = templates[j];
                    if (!template.Items) template.Items = [];
                    template.Items.push(item);
                    break;
                }
            }
        }


        var drugDic = {};
        var length = templateDrugs.length;
        for (var i = 0; i < length; i++) {
            if (drugDic[templateDrugs[i].UserPreferedData]) {
                drugDic[templateDrugs[i].UserPreferedData].push(templateDrugs[i]);
            } else {
                drugDic[templateDrugs[i].UserPreferedData] = [templateDrugs[i]];
            }
        }

        var eventDic = {};
        var length = templateEvents.length;
        for (var i = 0; i < length; i++) {
            if (eventDic[templateEvents[i].UserPreferedData]) {
                eventDic[templateEvents[i].UserPreferedData].push(templateEvents[i]);
            } else {
                eventDic[templateEvents[i].UserPreferedData] = [templateEvents[i]];
            }
        }

        var row = null;
        var length = templateDatas.length;
        for (var i = 0; i < length; i++) {
            row = templateDatas[i];
            if (drugDic[row.RowId]) {
                row.DrugDataList = drugDic[row.RowId];
                row.DrugData = drugDic[row.RowId][0];
            }
            if (eventDic[row.RowId]) {
                row.EventDetailDatas = eventDic[row.RowId];
            }
            for (var j = 0; j < templateLength; j++) {
                if (templates[j].RowId === row.Template) {
                    var template = templates[j];
                    if (!template.Data) template.Data = [];
                    template.Data.push(row);
                    break;
                }
            }
        }
    }
}

/**
 * 设置记录的最大时间
 */
contextProto.setDataMaxDT = function(dateTime) {
    if (dateTime >= MAXDATE) dateTime = new Date();
    if (this.dataMaxDT < dateTime) {
        this.dataMaxDT = dateTime
    }
}

/**
 * 当加载完麻醉表单数据后执行的方法
 */
contextProto.onLoadAnaData = function() {
    this.refreshProcedures();
}

contextProto.getDrugData = function(anaDataId) {
    var result = null;
    var length = (this.drugDatas || []).length;
    if (length <= 0) return result;

    for (var i = 0; i < length; i++) {
        var drugData = this.drugDatas[i];
        if (drugData.AnaData === anaDataId) {
            result = drugData;
            break;
        }
    }
    return result;
};

contextProto.getDrugDataList = function(anaDataId) {
    var result = [];
    var length = (this.drugDatas || []).length;
    if (length <= 0) return result;

    for (var i = 0; i < length; i++) {
        var drugData = this.drugDatas[i];
        if (drugData.AnaData === anaDataId) {
            result.push(drugData);
        }
    }
    return result;
}

/**
 * 获取当前页面上所有用药数据
 * @return {Array<Data.AnaData>}
 */
contextProto.getAllDrugDatas = function() {
    var anaDatas = this.anaDatas;
    var length = anaDatas.length;
    var result = [];

    for (var i = 0; i < length; i++) {
        if (anaDatas[i].DrugData) {
            result.push(anaDatas[i]);
        }
    }

    return result;
}

contextProto.getEventDetailDatas = function(anaDataId) {
    var retEventDatas = [];
    if (this.eventDetailDatas && this.eventDetailDatas.length > 0) {
        for (var i = 0; i < this.eventDetailDatas.length; i++) {
            var eventDetailData = this.eventDetailDatas[i];
            if (eventDetailData.AnaData === anaDataId) {
                retEventDatas.push(eventDetailData);
            }
        }
    }
    return retEventDatas;
};

contextProto.getEventDetailStr = function(detailDatas) {
    var retStr = "";
    if (detailDatas && detailDatas.length > 0) {
        for (var i = 0; i < detailDatas.length; i++) {
            var detailData = detailDatas[i];
            if (retStr.length > 0) {
                retStr += "\n";
            }
            retStr += detailData.Description + "：" + detailData.DataValue + detailData.DataUnit;
        }
    }
    return retStr;
};

/**
 * 获取事件数据
 * @param {string} categoryItemId 
 */
contextProto.getEventDatas = function(categoryItemId) {
    var result = [];
    var eventDatas = this.eventDatas;
    if (eventDatas && categoryItemId) {
        var length = eventDatas.length || 0;
        for (var i = 0; i < length; i++) {
            var eventData = eventDatas[i];
            if (eventData.CategoryItem === categoryItemId) {
                result.push(eventData);
            }
        }
    }

    return result;
};

/**
 * 获取麻醉数据
 * @param {string or undefined or null} paramItemId 
 * @param {string or undefined or null} categoryItemId 
 */
contextProto.getAnaDatas = function(paramItemId, categoryItemId) {
    var result = [];
    var anaDatas = this.anaDatas;
    if (anaDatas) {
        var length = anaDatas.length || 0;
        for (var i = 0; i < length; i++) {
            var anaData = anaDatas[i];
            if ((!paramItemId || anaData.ParaItem === paramItemId) &&
                (!categoryItemId || anaData.CategoryItem === categoryItemId)) {
                result.push(anaData);
            }
        }
    }

    return result;
};

/**
 * 初始化上下文逻辑关系
 * @author chenchangqing 20170906
 */
contextProto.initialContext = function() {
    this.loadData();
    this.loadSheet();
    this.loadRecordSheet();
    //this.loadAnaDatas();
    this.setDataCategories();
    this.setLegends();
    this.setVitalSignItems();
    this.setDrugGroups();
    this.setCategoryItems();
    this.setDisplayCategories();
    this.setCategoryParaItems();
    this.setRecordStartDT();
    this.setRecordEndDT();
    this.setTimeLines();
    this.setEventLegendItems();
    this.setProcedures();
};

contextProto.setTimeLines = function() {
    if (this.timeLines && this.timeLines.length > 0) {
        var newTimeLines = [];
        for (var i = 0; i < this.timeLines.length; i++) {
            var timeLine = this.timeLines[i];
            newTimeLines.push(new TimeLine({
                StartDT: timeLine.StartDT,
                EndDT: timeLine.EndDT,
                ColumnMinutes: timeLine.ColumnMinutes
            }));
        }
        this.timeLines.length = 0;
        for (var i = 0; i < newTimeLines.length; i++) {
            var timeLine = newTimeLines[i];
            this.timeLines.push(timeLine);
        }
    }
};

contextProto.loadTimeLines = function() {
    this.timeLines = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindTimeLines",
        Arg1: this.opsId,
        Arg2: this.moduleId,
        ArgCnt: 2
    }, "json", false);
    this.setTimeLines();
};

/**
 * 设置主数据分类，数据分类包含的子类，数据分类包含的数据项
 * @author chenchangqing 20170906
 */
contextProto.setDataCategories = function() {
    var dataCategories = this.dataCategories;
    if (!dataCategories || dataCategories.length < 1) return;
    this.mainCategories = [];
    for (var i = 0; i < dataCategories.length; i++) {
        var dataCategory = dataCategories[i];
        if (!dataCategory.MainCategory || dataCategory.MainCategory === constant.empty) {
            this.mainCategories.push(dataCategory);
        }
        dataCategory.subCategories = [];
        for (var j = 0; j < dataCategories.length; j++) {
            var subCategory = dataCategories[j];
            if (subCategory.MainCategory === dataCategory.RowId) {
                dataCategory.subCategories.push(subCategory);
            }
        }
    }

    if (this.categoryItems && this.categoryItems.length > 0) {
        for (var i = 0; i < dataCategories.length; i++) {
            var dataCategory = dataCategories[i];
            dataCategory.items = [];
            for (var j = 0; j < this.categoryItems.length; j++) {
                var categoryItem = this.categoryItems[j];
                if (dataCategory.RowId === categoryItem.DataCategory) {
                    dataCategory.items.push(categoryItem);
                }
            }
        }
    }
};

/**
 * 获取药品数据分类(主分类)
 * @returns {array} 药品数据分类数组
 */
contextProto.getDrugDataCategories = function() {
    var drugDataCategories = [];
    var dataCategories = this.dataCategories;
    if (!dataCategories || dataCategories.length < 1) return [];
    for (var i = 0; i < dataCategories.length; i++) {
        var dataCategory = dataCategories[i];
        if (!dataCategory.subCategories || dataCategory.subCategories.length < 1) continue;
        if (isDrugMainCategory(dataCategory)) drugDataCategories.push(dataCategory);
    }
    return drugDataCategories;

    function isDrugMainCategory(dataCategory) {
        if (dataCategory.Code === 'Event') return false;
        var length = dataCategory.subCategories.length;
        for (var j = 0; j < length; j++) {
            var subCategory = dataCategory.subCategories[j];
            var itemLength = subCategory.items.length;
            for (var k = 0; k < itemLength; k++) {
                var categoryItem = subCategory.items[k];
                if (categoryItem.ItemCategory === 'D') {
                    return true;
                }
            }
        }
        return false;
    }
};

/**
 * 获取事件数据分类
 * @returns {array} 事件数据分类数组
 * @author chenchangqing 20171123
 */
contextProto.getEventDataCategories = function() {
    var eventDataCategories = [];
    var dataCategories = this.dataCategories;
    if (!dataCategories || dataCategories.length < 1) return eventDataCategories;
    for (var i = 0; i < dataCategories.length; i++) {
        var dataCategory = dataCategories[i];
        if (!dataCategory.items || dataCategory.items.length < 1) continue;
        for (var j = 0; j < dataCategory.items.length; j++) {
            var categoryItem = dataCategory.items[j];
            if (categoryItem.eventItem) {
                eventDataCategories.push(dataCategory);
                break;
            }
        }
    }
    return eventDataCategories;
};

/**
 * 获取间断给药数据分类
 * @returns {array} 间断给药数据分类数组
 * @author chenchangqing 20171123
 */
contextProto.getIntrmiDrugDataCategories = function() {
    var result = [];
    var dataCategories = this.dataCategories;
    if (!dataCategories || dataCategories.length < 1) return result;
    for (var i = 0; i < dataCategories.length; i++) {
        var dataCategory = dataCategories[i];
        if (dataCategory.Code === 'OperationDrug') // 暂时用Code对应，最好修改为别的对应方式
            result.push(dataCategory);
    }
    return result;
};

/**
 * 设置药物组
 */
contextProto.setDrugGroups = function() {
    var groupItems = {};
    var length = this.drugGroupItems.length;
    for (var i = 0; i < length; i++) {
        var drugGroupItem = this.drugGroupItems[i];
        if (groupItems[drugGroupItem.DataItem]) {
            groupItems[drugGroupItem.DataItem].push(drugGroupItem);
        } else {
            groupItems[drugGroupItem.DataItem] = [drugGroupItem];
        }
    }

    var length = this.drugGroups.length;
    for (var i = 0; i < length; i++) {
        var drugGroup = this.drugGroups[i];
        drugGroup.items = groupItems[drugGroup.DataItem] || [];
    }

}

/**
 * 设置数据分类关联的数据项。
 * @author chenchangqing 20170911
 */
contextProto.setCategoryItems = function() {
    this.categoryItemDictionary = {};
    var categoryItemDictionary = this.categoryItemDictionary;
    if (!this.categoryItems || this.categoryItems.length < 0) return;

    for (var i = 0; i < this.categoryItems.length; i++) {
        var categoryItem = this.categoryItems[i];
        categoryItemDictionary[categoryItem.RowId] = categoryItem;
        categoryItemDictionary[categoryItem.ItemCode] = categoryItem;

        categoryItem.vitalSignItem = null;
        if (this.vitalSignItems) {
            var length = this.vitalSignItems.length;
            for (var j = 0; j < length; j++) {
                var vitalSignItem = this.vitalSignItems[j];
                if (categoryItem.DataItem === vitalSignItem.DataItem) {
                    categoryItem.vitalSignItem = vitalSignItem;
                }
            }
        }

        categoryItem.drugItems = [];
        if (this.drugItems) {
            var length = this.drugItems.length;
            for (var j = 0; j < length; j++) {
                var drugItem = this.drugItems[j];
                if (drugItem.DataItem === categoryItem.DataItem) {
                    categoryItem.drugItems.push(drugItem);
                }
            }
            if (categoryItem.drugItems.length > 0) {
                categoryItem.drugItem = categoryItem.drugItems[0];
            }
        }

        categoryItem.eventItem = null;
        if (this.eventItems) {
            var length = this.eventItems.length;
            for (var j = 0; j < this.eventItems.length; j++) {
                var eventItem = this.eventItems[j];
                if (eventItem.DataItem === categoryItem.DataItem) {
                    categoryItem.eventItem = eventItem;
                    break;
                }
            }
        }

        categoryItem.eventDetailItems = [];
        if (this.eventDetailItems) {
            var length = this.eventDetailItems.length;
            for (var j = 0; j < length; j++) {
                var eventDetailItem = this.eventDetailItems[j];
                if (eventDetailItem.DataItem === categoryItem.DataItem) {
                    categoryItem.eventDetailItems.push(eventDetailItem);
                }
            }
        }

        categoryItem.drugGroup = null;
        if (this.drugGroups) {
            var length = this.drugGroups.length;
            for (var j = 0; j < length; j++) {
                var drugGroup = this.drugGroups[j];
                if (drugGroup.DataItem === categoryItem.DataItem) {
                    categoryItem.drugGroup = drugGroup;
                    break;
                }
            }
        }
    }
};

/**
 * 根据数据项(DHCAN.CategoryItem)ID or Code获取数据项对象
 * @param {String} categoryItemIDOrCode - 数据项(DHCAN.CategoryItem)ID
 */
contextProto.getCategoryItem = function(categoryItemIDOrCode) {
    return this.categoryItemDictionary[categoryItemIDOrCode];
};

/**
 * 设置图例关联的图例数据
 * @author chenchangqing 20170911
 */
contextProto.setLegends = function() {
    if (!this.legends || this.legends.length < 1) return;
    if (!this.legendDatas || this.legendDatas.length < 1) return;
    for (var i = 0; i < this.legends.length; i++) {
        var legend = this.legends[i];
        legend.datas = [];
        legend.Width = isNaN(legend.Width) ? legend.Width : Number(legend.Width);
        legend.Height = isNaN(legend.Height) ? legend.Height : Number(legend.Height);
        legend.LineWeight = isNaN(legend.LineWeight) ? legend.LineWeight : Number(legend.LineWeight);
        legend.BasePos = {
            x: Number(legend.BasePosX),
            y: Number(legend.BasePosY)
        };
        for (var j = 0; j < this.legendDatas.length; j++) {
            var legendData = this.legendDatas[j];
            if (legendData.Legend === legend.RowId) {
                legend.datas.push(legendData);
                legendData.StartPos = {
                    x: Number(legendData.StartPosX),
                    y: Number(legendData.StartPosY)
                }
                if (!isNaN(legendData.EndPosX) && !isNaN(legendData.EndPosY)) {
                    legendData.EndPos = {
                        x: Number(legendData.EndPosX),
                        y: Number(legendData.EndPosY)
                    };
                } else {
                    legendData.EndPos = legendData.StartPos;
                }
                legendData.Radius = isNaN(legendData.Radius) ? legendData.Radius : Number(legendData.Radius);
                legendData.RadianMultiple = isNaN(legendData.RadianMultiple) ? legendData.Radius : Number(legendData.RadianMultiple);
            }
        }
    }
};

/**
 * 设置事件图例项目
 * @author chenchangqing 20171122
 */
contextProto.setEventLegendItems = function() {
    if (this.eventItems && this.eventItems.length > 0 && this.displayCategories) {
        var vitalSignCategory = this.displayCategories.VitalSignCategory;
        if (vitalSignCategory && vitalSignCategory.eventLegends && vitalSignCategory.eventLegends.length > 0) {
            var eventLegendItems = [];
            for (var i = 0; i < this.eventItems.length; i++) {
                var eventItem = this.eventItems[i];
                for (var j = 0; j < this.legends.length; j++) {
                    var legend = this.legends[j];
                    if (eventItem.Legend === legend.RowId) {
                        eventItem.legendItem = legend;
                    }
                }
            }
            for (var i = 0; i < vitalSignCategory.eventLegends.length; i++) {
                var eventLegend = vitalSignCategory.eventLegends[i];
                for (var j = 0; j < this.eventItems.length; j++) {
                    var eventItem = this.eventItems[j];
                    if (eventItem.DataItemCode === eventLegend) {
                        eventLegendItems.push(eventItem);
                    }
                }

            }
            this.eventLegendItems = eventLegendItems;
        }
    }
};

/**
 * 设置生命体征项目的图例
 * @author chenchangqing 20170911
 */
contextProto.setVitalSignItems = function() {
    if (!this.vitalSignItems || this.vitalSignItems.length < 1) return;
    for (var i = 0; i < this.vitalSignItems.length; i++) {
        var vitalSignItem = this.vitalSignItems[i];
        for (var j = 0; j < this.legends.length; j++) {
            var legend = this.legends[j];
            if (vitalSignItem.Legend === legend.RowId) {
                vitalSignItem.legendItem = legend;
            }
        }
    }
};

/**
 * 设置显示分类关联的数据分类
 * @author chenchangqing 20170906
 */
contextProto.setDisplayCategories = function() {
    if (!this.displayCategories || this.displayCategories.length < 1 || !this.mainCategories || this.mainCategories.length < 1) return;
    for (var key in this.displayCategories) {
        var displayCategory = this.displayCategories[key];
        for (var j = 0; j < this.mainCategories.length; j++) {
            var mainCategory = this.mainCategories[j];
            if (mainCategory.Code === key) {
                displayCategory.dataCategory = mainCategory;
            }
        }
    }
};

/**
 * 设置显示分类关联的显示项
 * @author chenchangqing 20170906
 */
contextProto.setCategoryParaItems = function() {
    if (!this.paraItems || !this.paraItems instanceof Array) return;
    for (var i = 0; i < this.paraItems.length; i++) {
        var paraItem = this.paraItems[i];
        paraItem.categoryItemObj = this.getCategoryItem(paraItem.CategoryItem);
        if (this.vitalSignItems && this.vitalSignItems.length > 0) {
            for (var j = 0; j < this.vitalSignItems.length; j++) {
                var vitalSignItem = this.vitalSignItems[j];
                if (paraItem.DataItem === vitalSignItem.DataItem) {
                    paraItem.vitalSignItem = vitalSignItem;
                }
            }
        }
        if (this.drugItems && this.drugItems.length > 0) {
            paraItem.drugItems = [];
            for (var j = 0; j < this.drugItems.length; j++) {
                var drugItem = this.drugItems[j];
                if (drugItem.DataItem === paraItem.DataItem) {
                    paraItem.drugItems.push(drugItem);

                }
            }
            if (paraItem.drugItems.length > 0) {
                paraItem.drugItem = paraItem.drugItems[0];
            }
        }
        if (this.dataItems && this.dataItems.length > 0) {
            for (var j = 0; j < this.dataItems.length; j++) {
                var dataItem = this.dataItems[j];
                if (dataItem.RowId === paraItem.DataItem) {
                    paraItem.dataItem = dataItem;
                }
            }
        }
    }
    var categoryIdList = [];
    for (var key in this.displayCategories) {
        var displayCategory = this.displayCategories[key];
        if (!displayCategory.dataCategory) continue;
        var subCategories = displayCategory.dataCategory.subCategories;
        if (!subCategories || subCategories.length < 1) continue;
        categoryIdList = [];
        if (!displayCategory.displayItems) {
            displayCategory.displayItems = [];
        } else {
            displayCategory.displayItems.length = 0;
        }

        categoryIdList.push(displayCategory.dataCategory.RowId);
        for (var subCateIndex = 0; subCateIndex < subCategories.length; subCateIndex++) {
            var subCategory = subCategories[subCateIndex];
            categoryIdList.push(subCategory.RowId);
        }

        for (var paraItemIndex = 0; paraItemIndex < this.paraItems.length; paraItemIndex++) {
            var curParaItem = this.paraItems[paraItemIndex];
            var dataCatIndex = categoryIdList.indexOf(curParaItem.DataCategory);
            if (dataCatIndex >= 0) {
                curParaItem.dataCategoryObj = subCategories[dataCatIndex - 1];
                displayCategory.displayItems.push(curParaItem);
            }
        }
    }
};


/**
 * 设置显示项目对应的数据
 */
contextProto.setDisplayItemDatas = function() {
    var integratingDatas = {};
    var length = this.paraItems.length;
    var dataSequences = [];
    for (var paraItemIndex = 0; paraItemIndex < length; paraItemIndex++) {
        var curParaItem = this.paraItems[paraItemIndex];
        var displayDatas = this.getAnaDatas(curParaItem.RowId);

        if (curParaItem.Code === "OperationEvent" || curParaItem.Code === "OperationDrug") {
            integratingDatas[curParaItem.Code] = {
                paraItem: curParaItem,
                displayDatas: displayDatas
            }
        } else {
            displayDatas.sort(dhccl.compareInstance("StartDT"));
            setDisplayName(curParaItem, displayDatas);
            curParaItem.displayDatas = displayDatas;
        }
        curParaItem.eventDatas = displayDatas;
    }

    this.integrateSpecDatas(integratingDatas);


    function setDisplayName(paraItem, displayDatas) {
        var length = displayDatas.length;
        for (var i = 0; i < length; i++) {
            var displayData = displayDatas[i];
            if (displayData.DrugData) {
                var displayName = '';
                if (!paraItem.CategoryItem && !paraItem.UserDefinedItem) displayName = displayData.DrugData.Description;
                if (displayData.DrugData.TCI === 'Y') {
                    displayName = displayName + 'TCI';
                }
                if (displayData.DrugData.DoseQty) {
                    displayName = displayName + displayData.DrugData.DoseQty;
                    if (paraItem.DoseUnitVisible === 'Y') displayName = displayName + displayData.DrugData.DoseUnitDesc;
                }
                if (displayData.DrugData.Speed) {
                    displayName = displayData.DrugData.Speed;
                    if (paraItem.SpeedUnitVisible === 'Y') displayName = displayName + displayData.DrugData.SpeedUnitDesc;
                }
                if (paraItem.ConcentrationVisible === 'Y' && displayData.DrugData.Concentration)
                    displayName = displayName + '(' + displayData.DrugData.Concentration + displayData.DrugData.ConcentrationUnitDesc + ')';

                if (displayData.DrugDataList && displayData.DrugDataList.length > 1) {
                    var addingDrugName = '';
                    for (var j = 1; j < displayData.DrugDataList.length; j++) {
                        var drugData = displayData.DrugDataList[j];
                        addingDrugName = addingDrugName + '+' + drugData.Description + drugData.DoseQty + drugData.DoseUnitDesc;
                    }

                    displayName = displayName + '(' + addingDrugName + ')';
                }
                displayData.DisplayName = displayName;
            }
        }
    }
}

/**
 * 设置流程
 */
contextProto.setProcedures = function() {
    var procedures = this.procedures;
    var length = procedures.length;
    var procedure = null;
    for (var i = 0; i < length; i++) {
        procedure = procedures[i];
        procedure.eventItem = this.getCategoryItem(procedure.relatedItem);
        procedure.preconditionProcedure = this.getProcedure(procedure.precondition);
    }

    this.refreshProcedures();
}

/**
 * 刷新流程
 */
contextProto.refreshProcedures = function() {
    var procedures = this.procedures;
    var length = procedures.length;
    var procedure = null;
    for (var i = 0; i < length; i++) {
        procedure = procedures[i];
        if (procedure.isEvent && procedure.eventItem)
            procedure.datas = this.getEventDatas(procedure.eventItem.RowId);
        if (procedure.isDocument) {
            //通过流程标识获取文书是否填写
        }
    }

    if (this.options.onRefreshProcedures) {
        this.options.onRefreshProcedures();
    }
}

/**
 * 获取流程
 * @param {string} code
 * @param {string} categoryItemId 
 */
contextProto.getProcedure = function(code, categoryItemId) {
    var procedures = this.procedures;
    var length = procedures.length;
    var procedure = null;
    var result = null;
    if (!code && !categoryItemId) return null;
    for (var i = 0; i < length; i++) {
        procedure = procedures[i];
        if ((code && procedure.id === code) ||
            (categoryItemId &&
                procedure.eventItem &&
                procedure.eventItem.RowId === categoryItemId)) {
            result = procedure;
            break;
        }
    }

    return result;
}

/**
 * 获取所有药品界面项目
 */
contextProto.getDrugParaItems = function() {
    if (!this.paraItems || this.paraItems.length < 1) return [];
    var result = [];
    var length = this.paraItems.length;
    for (var i = 0; i < length; i++) {
        var paraItem = this.paraItems[i];
        if (paraItem.ItemCategory === 'D') {
            result.push(paraItem);
        }
    }

    return result;
}

/**
 * 获取事件界面项目
 */
contextProto.getEventParaItem = function() {
    if (!this.paraItems || this.paraItems.length < 1) return;
    var length = this.paraItems.length;
    var result = null;
    for (var i = 0; i < length; i++) {
        var paraItem = this.paraItems[i];
        if (paraItem.Code === 'OperationEvent') { // 先暂时使用Code匹配
            result = paraItem;
            break;
        }
    }

    return result;
}

/**
 * 获取间断给药界面项目
 */
contextProto.getIntriDrugParaItem = function() {
    if (!this.paraItems || this.paraItems.length < 1) return;
    var length = this.paraItems.length;
    var result = null;
    for (var i = 0; i < length; i++) {
        var paraItem = this.paraItems[i];
        if (paraItem.Code === 'OperationDrug') { // 先暂时使用Code匹配
            result = paraItem;
            break;
        }
    }

    return result;
}

/**
 * 重构特殊显示数据
 * @param {*} integratingDatas
 */
contextProto.integrateSpecDatas = function(integratingItems) {
    var displayDatas = [],
        displayData = null,
        dataIndex = 0;

    for (var key in integratingItems) {
        var item = integratingItems[key];
        displayDatas = displayDatas.concat(item.displayDatas);
    }

    displayDatas.sort(dhccl.compareInstance("StartDT"));

    var seqIndex = 1,
        seqNo = "";

    var length = displayDatas.length;

    for (dataIndex = 0; dataIndex < length; dataIndex++) {
        displayData = displayDatas[dataIndex];
        displayData.categoryItemObj = this.getCategoryItem(displayData.CategoryItem);
        seqNo = seqIndex;
        displayData.seqNo = seqNo;
        displayData.headerNo = displayData.seqNo + ". ";
        displayData.headerText = displayData.StartDT.format(constant.timeFormat) + '  ';
        displayData.header = displayData.seqNo + ". " + displayData.StartDT.format(constant.timeFormat) + '  ';
        displayData.DetailNameList = getDetailNameList(seqNo, displayData);
        seqIndex++;
    }

    displayDatas = [];
    for (var key in integratingItems) {
        var item = integratingItems[key];
        displayDatas = item.displayDatas;
        var length = displayDatas.length;
        var integratedDatas = [];
        var seqNo = 0;
        for (dataIndex = 0; dataIndex < length; dataIndex++) {
            displayData = displayDatas[dataIndex];
            displayData.dataGroup = []; //getDataGroup(displayData, displayDatas);
            seqNo = displayData.seqNo;
            displayData.DisplayName = "" + seqNo;
            integratedDatas.push(displayData);
            if (displayData.dataGroup && displayData.dataGroup.length > 0) {
                dataIndex += displayData.dataGroup.length;
                seqNo = displayData.dataGroup[displayData.dataGroup.length - 1].seqNo;
                displayData.DisplayName += "~" + seqNo;
            }
        }
        item.paraItem.displayDatas = integratedDatas;
    }

    function getDataGroup(displayData, displayDatas) {
        var dataGroup = [];
        for (var j = 0; j < length; j++) {
            var curDisplayData = displayDatas[j];
            if (curDisplayData === displayData) continue;
            if (curDisplayData.StartDT < displayData.StartDT) continue;
            var ts = new TimeSpan(curDisplayData.StartDT, displayData.StartDT);
            if (ts.totalMinutes >= 0 && ts.totalMinutes <= 4) { //抢救模式下有点问题
                dataGroup.push(curDisplayData);
                curDisplayData.isFolded = true;
            }
        }
        return dataGroup;
    }

    function getDetailNameList(seqNo, displayData) {
        var result = [];

        if (displayData.DrugData) {
            if (displayData.DrugDataList) {
                var length = displayData.DrugDataList.length;
                for (var i = 0; i < length; i++) {
                    var drugData = displayData.DrugDataList[i];
                    result.push((drugData.Description || drugData.ArcimDesc) + " " +
                        drugData.DoseQty + drugData.DoseUnitDesc +
                        (drugData.InstructionDesc ? (" " + drugData.InstructionDesc) : "") +
                        (drugData.Note ? (" " + drugData.Note) : ""));
                }
            }
        } else {
            var showItemDesc = '';
            if (displayData.categoryItemObj) {
                var eventItem = displayData.categoryItemObj.eventItem;
                if (eventItem) showItemDesc = eventItem.ShowItemDesc;
            }

            if (showItemDesc === '' || showItemDesc === 'Y') result.push(displayData.DataItemDesc);
            if (displayData.EventDetailDatas && displayData.EventDetailDatas.length > 0) {
                var length = displayData.EventDetailDatas.length;
                for (var i = 0; i < length; i++) {
                    var eventDetail = displayData.EventDetailDatas[i];
                    result.push((eventDetail.Description ? eventDetail.Description + " " : "") +
                        eventDetail.DataValue + eventDetail.Unit);
                }
            }
        }

        return result;
    }
}

/**
 * 获取事件数据
 * @param {*} paraItemCode 
 * @param {*} displayDatas 
 */
contextProto.getEventDisplayDatas = function(paraItemCode, displayDatas) {
    var eventDisplayDatas = [],
        displayData = null,
        dataIndex = 0;
    var eventCategory = this.displayCategories.Event,
        seqIndex = 1,
        seqNo = "";
    var length = displayDatas.length;

    for (dataIndex = 0; dataIndex < length; dataIndex++) {
        displayData = displayDatas[dataIndex];
        displayData.categoryItemObj = this.getCategoryItem(displayData.CategoryItem);
        seqNo = getSeqNo(seqIndex);
        displayData.seqNo = seqNo;
        displayData.header = displayData.seqNo + ". " + displayData.StartDT.format(constant.timeFormat) + ' ';
        displayData.DetailNameList = getDetailNameList(seqNo, displayData);
        seqIndex++;
    }

    for (dataIndex = 0; dataIndex < length; dataIndex++) {
        displayData = displayDatas[dataIndex];
        displayData.dataGroup = getDataGroup(displayData);
        eventDisplayDatas.push(displayData);
        if (displayData.dataGroup && displayData.dataGroup.length > 0) {
            dataIndex += displayData.dataGroup.length;
        }
    }


    seqIndex = 1;
    var length = eventDisplayDatas.length;
    for (dataIndex = 0; dataIndex < length; dataIndex++) {
        displayData = eventDisplayDatas[dataIndex];
        seqNo = getSeqNo(seqIndex);
        displayData.DisplayName = "" + seqNo;
        if (displayData.dataGroup && displayData.dataGroup.length > 0) {
            seqIndex += displayData.dataGroup.length;
            seqNo = getSeqNo(seqIndex);
            displayData.DisplayName += "~" + seqNo;
        }
        seqIndex++;
    }

    return displayDatas;

    function getDataGroup(displayData) {
        var dataGroup = [];
        for (var j = 0; j < length; j++) {
            var curDisplayData = displayDatas[j];
            if (curDisplayData === displayData) continue;
            if (curDisplayData.StartDT < displayData.StartDT) continue;
            var ts = new TimeSpan(curDisplayData.StartDT, displayData.StartDT);
            if (ts.totalMinutes >= 0 && ts.totalMinutes <= 4) { //抢救模式下有点问题
                dataGroup.push(curDisplayData);
                curDisplayData.isFolded = true;
            }
        }
        return dataGroup;
    }

    function getDetailNameList(seqNo, displayData) {
        var result = [];

        if (displayData.DrugData) {
            if (displayData.DrugDataList) {
                var length = displayData.DrugDataList.length;
                for (var i = 0; i < length; i++) {
                    var drugData = displayData.DrugDataList[i];
                    result.push((drugData.Description || drugData.ArcimDesc) + " " +
                        drugData.DoseQty + drugData.DoseUnitDesc +
                        (drugData.InstructionDesc ? (" " + drugData.InstructionDesc) : "") +
                        (drugData.Reason ? (" " + drugData.Reason) : ""));
                }
            }
        } else {
            result.push(displayData.DataItemDesc);
            if (displayData.EventDetailDatas && displayData.EventDetailDatas.length > 0) {
                var length = displayData.EventDetailDatas.length;
                for (var i = 0; i < length; i++) {
                    var eventDetail = displayData.EventDetailDatas[i];
                    result.push(eventDetail.Description + " : " + eventDetail.DataValue + eventDetail.Unit);
                }
            }
        }

        return result;
    }

    function getSeqNo(seqNo) {
        var retNo = seqNo;
        if (eventCategory && eventCategory.seqModes && eventCategory.seqModes.length > 0) {
            for (var seqModeIndex = 0; seqModeIndex < eventCategory.seqModes.length; seqModeIndex++) {
                var seqMode = eventCategory.seqModes[seqModeIndex];
                if (seqMode.item === paraItemCode && seqMode.mode === "letter") {
                    retNo = dhccl.indexToColumn(seqNo);
                }
            }
        }
        return retNo;
    }
};



/**
 * 获取操作功能授权
 * @param {string} operStatusId - 手术状态ID
 * @returns {array} 操作功能授权对象集合
 * @author chenchangqing 20170907
 */
contextProto.getActionPermissions = function() {
    var result = [];
    if (!this.actionPermissions || this.actionPermissions.length < 1) return result;
    for (var i = 0; i < this.actionPermissions.length; i++) {
        var actionPermission = this.actionPermissions[i];
        var arr = actionPermission.OperStatus.split(',');
        if (arr.indexOf(this.schedule.Status) > -1 || actionPermission.OperStatus === "") {
            result.push(actionPermission);
        }
    }
    return result;
};

/**
 * 设置监护开始时间
 * @author chenchangqing 20170907
 */
contextProto.setRecordStartDT = function() {
    this.recordStartDT = new Date();
    if (this.schedule) {
        var recordStartDT = this.schedule.TheatreInDT != "" ? this.schedule.TheatreInDT : this.schedule.OperDateTime;
        this.recordStartDT = new Date(recordStartDT.replace(/-/g, "/"));
    }
};

/**
 * 设置监护结束时间
 * @author chenchangqing 20170907
 */
contextProto.setRecordEndDT = function() {
    if (this.schedule) {
        var recordEndDT = this.schedule.TheatreOutDT;
        if (recordEndDT === "") {
            this.recordEndDT = this.recordStartDT.addHours(this.displayAreas.timeLine.column.count * 6);
        } else {
            this.recordEndDT = new Date(recordEndDT.replace(/-/g, "/"));
        }
    }
};

/**
 * 获取由显示分类数据项生成的菜单项数组
 * @param {object} displayCategory - 显示分类
 * @returns {Array} 菜单项数组
 * @author chenchangqing 20170806
 */
contextProto.getCategoryMenus = function(displayCategory) {
    var menuItems = [];
    if (displayCategory && displayCategory.dataCategory) {
        var dataCategory = displayCategory.dataCategory;
        for (var i = 0; i < dataCategory.subCategories.length; i++) {
            var subCategory = dataCategory.subCategories[i];
            var menuItem = {
                id: subCategory.RowId,
                code: subCategory.Code,
                title: subCategory.Description,
                dataCategory: subCategory,
                onclick: "addDisplayCategory",
                subMenuItems: []
            };
            menuItems.push(menuItem);
            if (subCategory.items && subCategory.items.length > 0) {
                for (var j = 0; j < subCategory.items.length; j++) {
                    var categoryItem = subCategory.items[j];
                    menuItem.subMenuItems.push({
                        id: categoryItem.DataItem,
                        title: categoryItem.ItemDesc,
                        onclick: "addDisplayItem",
                        categoryItem: categoryItem
                    });
                }
            }
        }
    }
    return menuItems;
};

/**
 * 获取上下文菜单
 * @param {AnaestSheet} anaestSheet - 麻醉记录表单对象
 */
contextProto.getContextMenuItems = function(clickInfo) {
    var menuItems = [];
    if (clickInfo && this.contextMenus && this.contextMenus.length > 0) {
        var clickArea = clickInfo.area,
            clickCategory = clickInfo.category,
            clickItem = clickInfo.item,
            clickData = clickInfo.displayData,
            itemArea = this.displayAreas.item,
            dataArea = this.displayAreas.data,
            compareCategoryCode = "";
        if (clickCategory && clickCategory.dataCategory) {
            compareCategoryCode = ";" + clickCategory.dataCategory.Code + ";";
        }
        for (var i = 0; i < this.contextMenus.length; i++) {
            var contextMenu = this.contextMenus[i];
            var relatedArea = this.getDisplayArea(contextMenu.relatedArea);
            if ((relatedArea !== clickArea) || !contextMenu.menuItems) continue;
            if (clickCategory && contextMenu.exclusiveCategory && contextMenu.exclusiveCategory.indexOf(compareCategoryCode) >= 0) continue;
            if (clickCategory && contextMenu.includeCategory && contextMenu.includeCategory.indexOf(compareCategoryCode) < 0) continue;
            for (var j = 0; j < contextMenu.menuItems.length; j++) {
                var menuItem = contextMenu.menuItems[j];
                if (menuItem.needData && !clickData && dataArea === relatedArea) continue;
                if (menuItem.needData && !clickItem && itemArea === relatedArea) continue;
                if (!menuItem.needData && clickData && dataArea === relatedArea) continue;
                if (!menuItem.needData && clickItem && itemArea === relatedArea) continue;
                if (menuItem.needPastingData && !clickInfo.pastingData) continue;

                if (menuItem.type && clickItem.ItemCategory != menuItem.type) continue;
                if (menuItem.needContinualCollect && clickItem.SuspendCollect == "Y") continue;
                if (menuItem.needAutoGenerate && clickItem.AutoGenerate != "Y") continue;
                if (menuItem.needSuspendCollect && clickItem.SuspendCollect != "Y") continue;
                if (menuItem.needContinueData && dataArea === relatedArea &&
                    (clickData.Continuous != "Y" ||
                        (clickData.Continuous === "Y" &&
                            clickInfo.displayData.EndDT <= clickInfo.displayData.StartDT
                        )
                    )
                ) continue;

                if (menuItem.needContinueData && dataArea === relatedArea &&
                    (clickData.Continuous != "Y" ||
                        (clickData.Continuous === "Y" && (typeof menuItem.needStoppedData === 'boolean') &&
                            ((menuItem.needStoppedData && clickInfo.displayData.EndDT >= MAXDATE) ||
                                (!menuItem.needStoppedData && clickInfo.displayData.EndDT < MAXDATE)
                            )
                        )
                    )
                ) continue;

                if (typeof menuItem.needTakeAway === 'boolean' &&
                    ((!clickData.DrugData) ||
                        ((menuItem.needTakeAway && clickData.DrugData.TakingAway != 'Y') ||
                            (!menuItem.needTakeAway && clickData.DrugData.TakingAway === 'Y')))
                ) continue;


                if (typeof menuItem.needSelected === 'boolean' &&
                    ((!clickData) ||
                        ((menuItem.needSelected && !clickData.selected) ||
                            (!menuItem.needSelected && clickData.selected)))
                ) continue;

                menuItems.push(menuItem);
            }
        }
    }
    return menuItems;
};

/**
 * 根据显示区域的key获取显示区域对象
 * @param {String} areaKey - 显示区域key值
 * @returns {Object} 显示区域对象
 * @author chenchangqing 20170804
 */
contextProto.getDisplayArea = function(areaKey) {
    var result = null;
    if (this.displayAreas) {
        for (var key in this.displayAreas) {
            var displayArea = this.displayAreas[key];
            if (key === areaKey) {
                result = displayArea;
                break;
            }
        }
    }
    return result;
};

/**
 * 加载麻醉监护监护项目参数信息
 * @author chenchangqing 20170908
 */
contextProto.loadParaItems = function() {
    this.paraItems = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: "FindParaItems",
        Arg1: this.recordSheetID,
        ArgCnt: 1
    }, "json");
    this.setCategoryParaItems();
    this.setDisplayItemDatas();
};

/**
 * 加载手术计划详细信息
 * @author chenchangqing 20170908
 */
contextProto.loadSchedule = function() {
    this.schedules = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperSchedule,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: this.opsId,
        ArgCnt: 4
    }, "json");

    if (this.schedules && this.schedules.length > 0) {
        this.schedule = this.schedules[0];
        this.setRecordStartDT();
        this.setRecordEndDT();
        if (this.options.onLoadSchedule) {
            this.options.onLoadSchedule(this.schedule);
        }
    }
};

/**
 * 是否已开始（术中）// 预麻间、PACU如何判断？从病人转运记录中获取是否已入室？
 */
contextProto.isStarted = function() {
    return this.schedule.TheatreInDT && this.schedule.TheatreInDT.length > 0;
}

/**
 * 是否已结束（术中）// 预麻间、PACU如何判断？
 */
contextProto.isEnded = function() {
    return this.schedule.TheatreOutDT && this.schedule.TheatreOutDT.length > 0;
}

/**
 * 时间轴对象构造函数
 * @param {object} options - 选项
 * @author chenchangqing 20170831
 */
function TimeLine(options) {
    if (typeof options.StartDT === "string") {
        this.StartDT = dhccl.toDateTime(options.StartDT);
    } else if (options.StartDT instanceof Date) {
        this.StartDT = options.StartDT;
    } else {
        this.StartDT = new Date();
    }
    if (typeof options.EndDT === "string") {
        this.EndDT = dhccl.toDateTime(options.EndDT);
    } else if (options.EndDT instanceof Date) {
        this.EndDT = options.EndDT;
    } else {
        this.EndDT = new Date();
    }
    this.ColumnMinutes = Number(options.ColumnMinutes)
    this.ColumnCount = Math.ceil((this.EndDT.getTime() - this.StartDT.getTime()) / (this.ColumnMinutes * 60000));
    this.inTimeLine = function(dateTime) {
        var result = false;
        if (dateTime instanceof Date) {
            if (!(dateTime > this.EndDT || dateTime < this.StartDT)) {
                result = true;
            }
        }
        return result;
    };
    this.getTimeLine = function(dateTime, getType, totalColCount, defaultColMinutes) {
        var result = null,
            startDT = null,
            endDT = null,
            columnMinutes = defaultColMinutes;

        if (dateTime instanceof Date) {
            if (getType === "Start") {
                startDT = dateTime;
            } else {
                endDT = dateTime;
            }
            if (this.inTimeLine(dateTime)) {
                if (getType === "Start") {
                    endDT = this.EndDT;
                } else {
                    startDT = this.StartDT;
                }
                columnMinutes = this.ColumnMinutes;
            } else {
                if (getType === "Start") {
                    endDT = this.StartDT;
                } else {
                    startDT = this.EndDT;
                }
            }
            if ((startDT instanceof Date) && (endDT instanceof Date) && (endDT > startDT)) {
                result = new TimeLine({
                    StartDT: startDT,
                    EndDT: endDT,
                    ColumnMinutes: columnMinutes
                });
            }
        }
        return result;
    }
}


/**
 * 显示数据对象
 */
function DisplayData(anaData) {
    $.extend(this, anaData);
    return this;
}

DisplayData.prototype = {
    setDisplayName: function() {

    },
    /**
     * 单点时间（结束时间等于开始时间）
     */
    isTimePoint: function() {
        return this.EndDT === this.StartDT;
    },
    /**
     * 一段时间（结束时间不等于开始时间，但结束时间不为空）
     */
    isTimeSpan: function() {
        return (this.EndDT != this.StartDT) && (this.EndDT);
    },
    /**
     * 持续的（未设置结束时间）
     */
    isContinual: function() {
        return this.EndDT === '';
    }
}