/**
 * 恢复室工作站
 * @author yongyang 20180515
 */

var pacuStation = {
    /**
     * 等待列表
     */
    waitingList: [],
    /**
     * 在床位列表
     */
    inBedList: [],
    /**
     * 完成（转出）列表
     */
    finishedList: [],
    /**
     * 床位
     */
    beds: [],
    banner: null
}

/**
 * 等待列表渲染
 */
var waitingListView = {
    render: function(container, operSchedules) {
        container.empty();
        $.each(operSchedules, function(index, operSchedule) {
            var html = $('<div class="waiting-patient data-binded"></div>')
                .append('<a title="分配床位" href="#" class="arrange-button align-right"><span class="icon-arrow-right"></span></a>')
                .appendTo(container)
                .attr('title', operSchedule.OperationDesc + '\n' + operSchedule.PrevAnaMethodDesc);
            var gender = $('<i class="patient-gender"></i>').appendTo(html);

            if (operSchedule.PatGender === '女') gender.addClass('female icon-mini-female fas fa-female');
            else gender.addClass('male icon-mini-male fas fa-male');

            $('<span class="patient-name">' + operSchedule.PatName + '</span>').appendTo(html);
            $('<span class="patient-age">' + operSchedule.PatAge + '</span>').appendTo(html);
            html.data('data', operSchedule);
        });

        container.children('.waiting-patient').draggable({
            handler: '.patient-name',
            edge: 5,
            proxy: proxy,
            revert: true,
            onStartDrag: function(e) {
                $('.bed-empty').addClass('bed-droppable');
                var schedule = $(this).data('data');
                pacuStation.banner.loadData(schedule);
            },
            onStopDrag: function(e) {
                $(this).css({ position: 'relative', left: 0, top: 0 });
                $('.bed-empty').removeClass('bed-droppable');
            }
        })
    }
}

/**
 * 完成列表渲染
 */
var finishedListView = {
    render: function(container, operSchedules) {
        container.empty();
        $.each(operSchedules, function(index, operSchedule) {
            var html = $('<div class="finished-patient data-binded"></div>')
                .appendTo(container)
                .attr('title', operSchedule.OperationDesc + '\n' + operSchedule.PrevAnaMethodDesc);
            var gender = $('<i class="patient-gender"></i>').appendTo(html);

            if (operSchedule.PatGender === '女') gender.addClass('female icon-mini-female fas fa-female');
            else gender.addClass('male icon-mini-male fas fa-male');

            $('<span class="patient-name">' + operSchedule.PatName + '</span>').appendTo(html);
            $('<span class="patient-age">' + operSchedule.PatAge + '</span>').appendTo(html);
            html.data('data', operSchedule);
        });
    }
}

/**
 * 床位渲染
 */
var bedView = {
    idPrefix: 'pacu_bed_i_',
    render: function(container, beds) {
        container.empty();
        var idPrefix = this.idPrefix;
        $.each(beds, function(index, bed) {
            var html = $('<div class="bed bed-empty data-binded"></div>')
                .attr('id', idPrefix + bed.RowId)
                .appendTo(container);
            $('<div class="bed-header"></div>')
                .append('<span class="bed-occupied-duration"><i class="fas fa-clock-o" style="color:#ccc;font-size:16px;margin-right:3px;"></i><span></span></span>')
                .append('<span class="bed-occupied-monitor icon-monitor"></span>')
                .append('<span class="icon-bed"></span>')
                .append('<span>' + bed.Description + '</span>')
                .append('<span class="bed-patient-name"></span>')
                .appendTo(html);
            $('<div class="bed-main"></div>')
                .append('<a title="安排病人" href="#" class="bed-button"><span>安排病人</span></a>')
                .appendTo(html);
            $('<div class="bed-mask"></div>')
                .append('<i class="fas fa-5x fa-plus"></i>')
                .appendTo(html);

            html.data('data', bed);
        });

        container.children('.bed').droppable({
            accept: '.waiting-patient',
            onDragEnter: function(e, source) {
                $(this).addClass('bed-droppable-hover');
            },
            onDragLeave: function(e, source) {
                $(this).removeClass('bed-droppable-hover');
            },
            onDrop: function(e, source) {
                var operSchedule = $(source).data('data');
                var bed = $(this).data('data');
                arrange(operSchedule, bed);
                $(this).removeClass('bed-droppable');
                $(source).remove();
            }
        })
    }
}

/**
 * 空床位渲染
 */
var emptyBed = {
    render: function(bedDom) {
        var bed = bedDom.data('data');
        bed.occupied = false;
        bedDom.addClass('bed-empty');
        bedDom.removeClass('bed-occupied');
        bedDom.data('oper_schedule', null);
        bedDom.droppable('enable');

        var bedHeader = bedDom.children('.bed-header');
        bedHeader.find('span.bed-patient-name').text('');

        var bedMain = bedDom.children('.bed-main');
        bedMain.removeClass('male');
        bedMain.removeClass('female');
        bedMain.empty().append('<a title="安排病人" href="#" class="bed-button"><span>安排病人</span></a>');

        var bedMask = bedDom.children('.bed-mask');
        if (bedMask.length <= 0) bedMask = $('<div class="bed-mask"></div>').appendTo(bedDom);
        bedMask.empty().append('<i class="fas fa-5x fa-plus"></i>');
        bedMask.attr('style', '');
    }
}

/**
 * 已占床位渲染
 */
var occupiedBed = {
    render: function(bedDom, operSchedule) {
        var bed = bedDom.data('data');
        bed.occupied = true;
        bedDom.removeClass('bed-empty');
        bedDom.addClass('bed-occupied');
        bedDom.data('oper_schedule', operSchedule);
        bedDom.droppable('disable');

        var bedHeader = bedDom.children('.bed-header');
        bedHeader.find('span.bed-patient-name').html(operSchedule.PatName +
            '<span class="bed-patient-gender">' +
            operSchedule.PatGender +
            '</span><span class="bed-patient-age">' +
            operSchedule.PatAge + '</span>');

        var bedMain = bedDom.children('.bed-main');
        var bedMask = bedDom.children('.bed-mask');
        if (bedMask.length <= 0) bedMask = $('<div class="bed-mask"></div>').appendTo(bedDom);
        bedMain.empty();

        var avatarContainer = $('<div class="bed-patient-container bed-patient-icon"></div>').appendTo(bedMain);
        var avatar = $('<span></span>').appendTo(avatarContainer);
        var infoContainer = $('<div class="bed-patient-container bed-patient-info"></div>').appendTo(bedMain);
        infoContainer.append('<div class="bed-patient-info-i"><span>' + operSchedule.RegNo + '</span></div>')
            .append('<div class="bed-patient-info-i"><span>' + (operSchedule.PrevDiagnosisDesc || "") + '</span></div>')
            .append('<div class="bed-patient-info-i"><span>' + operSchedule.OperationDesc + '</span></div>')
            .append('<div class="bed-patient-info-i"><span>' + operSchedule.PrevAnaMethodDesc + '</span></div>')
            .append('<div class="bed-patient-info-i"><span>' + (operSchedule.PACUInDT || "") + '</span></div>')

        var steward = $('<a href="javascript:;" class="bed-patient-info-steward">' + operSchedule.InPACUStewardScore + '</a>').data('data', {
            RowId: operSchedule.InPACUSteward,
            Score: operSchedule.InPACUStewardScore,
            Conscious: operSchedule.InPACUStewardConscious,
            Respiration: operSchedule.InPACUStewardRespiration,
            Motion: operSchedule.InPACUStewardMotion
        });

        $('<div class="bed-patient-info-i"><span>入室评分</span></div>')
            .append(steward)
            .appendTo(infoContainer);

        if (operSchedule.PatGender === '女') {
            avatar.addClass('icon-female');
            bedMain.addClass('female');
        } else {
            avatar.addClass('icon-male');
            bedMain.addClass('male');
        }

        bedMask.empty();
        bedDom.bind('click', function() {
            var schedule = $(this).data('oper_schedule');
            pacuStation.banner.loadData(schedule);
        });

        $('<a href="#" class="patient-button patient-record">恢复记录</a>').linkbutton({
            iconCls: '',
            onClick: recordClickHandler
        }).appendTo(bedMask);
        $('<a href="#" class="patient-button patient-changebed">换床</a>').linkbutton({
            iconCls: '',
            onClick: changeBedClickHandler
        }).appendTo(bedMask);
        $('<a href="#" class="patient-button patient-transfer">转出</a>').linkbutton({
            iconCls: '',
            onClick: transferClickHandler
        }).appendTo(bedMask);
    }
}

/**
 * 安排病人床位的模态框
 */
var arrangeView = {
    init: function() {
        var _this = this;
        this.StewardAssessView = StewardAssessView;
        this.currentPatient = null;
        this.dom = $('<div></div>').appendTo('body');
        var buttons = $('<div></div>');
        var saveButton = $('<a href="#"></a>').linkbutton({
            text: '确认',
            iconCls: 'icon-ok',
            onClick: function() {
                if (_this.form.form('validate')) _this.sendToBed();
                else return;
            }
        }).appendTo(buttons);
        var cancelButton = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.form = $('<form class="arrange-view-form"></form>').appendTo(this.dom);
        this.form.form({});

        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">患者：</span>')
            .appendTo(this.form);
        this.Patient = $('<input type="text" name="Patient">').appendTo(row);
        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">恢复床位：</span>')
            .appendTo(this.form);
        this.Bed = $('<input type="text" name="Bed">').appendTo(row);
        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">入PACU时间：</span>')
            .appendTo(this.form);
        this.DateTime = $('<input type="text" name="DateTime">').appendTo(row);

        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">Steward评分：</span>')
            .appendTo(this.form);
        this.Steward = $('<span class="view-form-text view-form-text-disabled"></span>').appendTo(row);

        this.Steward.click(function() {
            if (_this.canAssessSteward) {
                _this.StewardAssessView.setCallback(function(data) {
                    _this.saveStewardAssess(data);
                });
                var pos = $(this).offset();
                _this.StewardAssessView.position({
                    left: pos.left + 185,
                    top: pos.top
                });
                _this.StewardAssessView.render(_this.StewardData);
                _this.StewardAssessView.open();
            }
        });

        var row = $('<div class="view-form-r changebed-time" style="display:none;"></div>')
            .append('<span class="label">换床时间：</span>')
            .appendTo(this.form);
        this.ChangeDateTime = $('<input type="text" name="DateTime">').appendTo(row)

        this.Patient.combobox({
            textField: 'PatName',
            valueField: 'RowId',
            width: 180,
            onSelect: function(record) {
                _this.currentPatient = record;
                _this.canAssessSteward = true;
                _this.Steward.text(record.InPACUStewardScore);
                _this.Steward.removeClass('view-form-text-disabled');
                _this.StewardData = {
                    RowId: record.InPACUSteward,
                    Score: record.InPACUStewardScore,
                    Conscious: record.InPACUStewardConscious,
                    Respiration: record.InPACUStewardRespiration,
                    Motion: record.InPACUStewardMotion
                }
            }
        });
        this.Bed.combobox({
            textField: 'Description',
            valueField: 'RowId',
            width: 180
        });
        this.DateTime.datetimebox({
            width: 180,
            height: 30,
            formatter: DateTimeFormatter,
            parser: DateTimeParser
        });
        this.ChangeDateTime.datetimebox({
            width: 180,
            height: 30,
            formatter: DateTimeFormatter,
            parser: DateTimeParser
        });

        this.dom.dialog({
            left: 450,
            top: 200,
            height: 300,
            width: 320,
            title: '分配病人到床位',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {},
            onClose: function() {
                _this.clear();
                _this.StewardData = null;
                _this.StewardAssessView.close();
            }
        });
    },
    open: function() {
        if (this.dom) this.dom.dialog('open');
    },
    close: function() {
        if (this.dom) this.dom.dialog('close');
    },
    clear: function() {
        this.form.form('clear');
        this.Steward.addClass('view-form-text-disabled');
        this.canAssessSteward = false;
    },
    setPatient: function(operSchedule) {
        var data = this.Patient.combobox('getData');
        if (data.indexOf(operSchedule) < 0) {
            data.push(operSchedule);
            this.Patient.combobox('loadData', data);
        }
        this.currentPatient = operSchedule;
        this.Patient.combobox('setValue', operSchedule.RowId);
        this.canAssessSteward = true;
        this.Steward.removeClass('view-form-text-disabled');
        this.StewardData = {
            RowId: operSchedule.InPACUSteward,
            Score: operSchedule.InPACUStewardScore,
            Conscious: operSchedule.InPACUStewardConscious,
            Respiration: operSchedule.InPACUStewardRespiration,
            Motion: operSchedule.InPACUStewardMotion
        }

        this.Steward.text(operSchedule.InPACUStewardScore);

        if (operSchedule.PACUInDT)
            this.DateTime.datetimebox('setValue', operSchedule.PACUInDT);
    },
    setBed: function(bed) {
        var data = this.Bed.combobox('getData');
        if (data.indexOf(bed) < 0) {
            data.push(bed);
            this.Bed.combobox('loadData', data);
        }
        this.Bed.combobox('setValue', bed.RowId);
    },
    refreshFormOptions: function() {
        this.Patient.combobox('loadData', getWaitingPatients());
        this.Bed.combobox('loadData', getUnoccupiedBeds());
        var nowDateTime = new Date().format(constant.dateTimeFormat);
        this.DateTime.datetimebox('setValue', nowDateTime);
        this.ChangeDateTime.datetimebox('setValue', nowDateTime);
    },
    changeBed: function(bed) {
        this.form.find('.changebed-time').show();
        this.isChangingBed = true;
        this.formerBed = bed;
    },
    saveStewardAssess: function(data) {
        this.Steward.text(data.Score);
        this.StewardData = $.extend(this.StewardData || {}, data);
        $.extend(this.currentPatient, {
            InPACUSteward: this.StewardData.RowId || '',
            InPACUStewardScore: this.StewardData.Score || '',
            InPACUStewardConscious: this.StewardData.Conscious || '',
            InPACUStewardRespiration: this.StewardData.Respiration || '',
            InPACUStewardMotion: this.StewardData.Motion || '',
            isChangedSteward: 'Y'
        });
    },
    sendToBed: function() {
        var operScheduleId = this.Patient.combobox('getValue');
        var bedId = this.Bed.combobox('getValue');

        var operSchedules = this.Patient.combobox('getData');
        var beds = this.Bed.combobox('getData');

        var operSchedule = null,
            bed = null;
        $.each(operSchedules, function() {
            if (this.RowId === operScheduleId) {
                operSchedule = this;
                return false;
            }
        });
        $.each(beds, function() {
            if (this.RowId === bedId) {
                bed = this;
                return false;
            }
        });

        operSchedule.PACUBed = bedId;
        operSchedule.PACUInDT = convertToTimeStamp(this.DateTime.datetimebox('getValue'));

        if (this.isChangingBed) {
            if (this.formerBed != bed) {
                changeBedSaveHandler(operSchedule, bed, {
                    formerBed: this.formerBed,
                    changeDT: convertToTimeStamp(this.ChangeDateTime.datetimebox('getValue'))
                });
                this.form.find('.changebed-time').hide();
            }
        } else {
            arrange(operSchedule, bed);
        }
        this.close();
    }
}

/**
 * 转移对话框
 */
var transferView = {
    init: function() {
        var _this = this;
        this.StewardAssessView = StewardAssessView;
        this.StewardData = null;
        this.currentPatient = null;
        this.dom = $('<div></div>').appendTo('body');
        var buttons = $('<div></div>');
        var returnButton = $('<a href="#"></a>').linkbutton({
            text: '返回等待区',
            iconCls: 'icon-undo',
            onClick: function() {
                _this.sendToWait();
            }
        }).appendTo(buttons);
        var transferOutButton = $('<a href="#"></a>').linkbutton({
            text: '转出',
            iconCls: 'icon-transfer',
            onClick: function() {
                if (_this.form.form('validate')) _this.transferOut();
                else return;
            }
        }).appendTo(buttons);
        var cancelButton = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.form = $('<form class="transfer-view-form"></form>').appendTo(this.dom);
        this.form.form({});

        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">患者：</span>')
            .appendTo(this.form);
        this.Patient = $('<input type="text" name="Patient">').appendTo(row);
        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">去向：</span>')
            .appendTo(this.form);
        this.Position = $('<input type="text" name="Position">').appendTo(row);
        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">出PACU时间：</span>')
            .appendTo(this.form);
        this.DateTime = $('<input type="text" name="DateTime">').appendTo(row);

        var row = $('<div class="view-form-r"></div>')
            .append('<span class="label">Steward评分：</span>')
            .appendTo(this.form);
        this.Steward = $('<span class="view-form-text view-form-text-disabled"></span>').appendTo(row);

        this.Steward.click(function() {
            if (_this.canAssessSteward) {
                _this.StewardAssessView.setCallback(function(data) {
                    _this.saveStewardAssess(data);
                });
                var pos = $(this).offset();
                _this.StewardAssessView.position({
                    left: pos.left + 185,
                    top: pos.top
                });
                _this.StewardAssessView.render(_this.StewardData);
                _this.StewardAssessView.open();
            }
        });

        this.Patient.combobox({
            textField: 'PatName',
            valueField: 'RowId',
            width: 180,
            readonly: true,
            onSelect: function(record) {
                _this.currentPatient = record;
                _this.canAssessSteward = true;
                _this.Steward.text(record.InPACUStewardScore);
                _this.Steward.removeClass('view-form-text-disabled');
                _this.StewardData = {
                    RowId: record.InPACUSteward,
                    Score: record.InPACUStewardScore,
                    Conscious: record.InPACUStewardConscious,
                    Respiration: record.InPACUStewardRespiration,
                    Motion: record.InPACUStewardMotion
                }
            }
        });
        this.Position.combobox({
            width: 180,
            textField: 'text',
            valueField: 'value',
            data: [{
                    text: '原病区',
                    value: 'Ward'
                },
                {
                    text: 'ICU',
                    value: 'ICU'
                },
                {
                    text: '离院',
                    value: 'Discharge'
                },
                {
                    text: '死亡',
                    value: 'Death'
                }
            ]
        });
        this.DateTime.datetimebox({
            width: 180,
            height: 30,
            formatter: DateTimeFormatter,
            parser: DateTimeParser
        });

        this.dom.dialog({
            left: 450,
            top: 200,
            height: 270,
            width: 360,
            title: '转出',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {
                _this.refreshFormOptions();
            },
            onClose: function() {
                _this.clear();
                _this.StewardData = null;
                _this.currentPatient = null;
                _this.StewardAssessView.close();
            }
        });
    },
    open: function() {
        if (this.dom) this.dom.dialog('open');
    },
    close: function() {
        if (this.dom) this.dom.dialog('close');
    },
    clear: function() {
        this.form.form('clear');
    },
    setPatient: function(operSchedule) {
        this.Patient.combobox('setValue', operSchedule.RowId);

        this.currentPatient = operSchedule;
        this.canAssessSteward = true;
        this.Steward.removeClass('view-form-text-disabled');
        this.StewardData = {
            RowId: operSchedule.OutPACUSteward,
            Score: operSchedule.OutPACUStewardScore,
            Conscious: operSchedule.OutPACUStewardConscious,
            Respiration: operSchedule.OutPACUStewardRespiration,
            Motion: operSchedule.OutPACUStewardMotion
        }

        this.Steward.text(operSchedule.OutPACUStewardScore);
    },
    saveStewardAssess: function(data) {
        this.Steward.text(data.Score);
        this.StewardData = $.extend(this.StewardData || {}, data);
        $.extend(this.currentPatient, {
            OutPACUSteward: this.StewardData.RowId || '',
            OutPACUStewardScore: this.StewardData.Score || '',
            OutPACUStewardConscious: this.StewardData.Conscious || '',
            OutPACUStewardRespiration: this.StewardData.Respiration || '',
            OutPACUStewardMotion: this.StewardData.Motion || '',
            isChangedSteward: 'Y'
        });
    },
    refreshFormOptions: function() {
        this.Patient.combobox('loadData', getInBedPatients());
        this.DateTime.datetimebox('setValue', (new Date()).format(constant.dateTimeFormat));
    },
    transferOut: function() {
        var operScheduleId = this.Patient.combobox('getValue');
        var operSchedules = this.Patient.combobox('getData');
        var operSchedule = null;
        $.each(operSchedules, function() {
            if (this.RowId === operScheduleId) {
                operSchedule = this;
                return false;
            }
        });
        var nextPosition = this.Position.combobox('getValue');
        var PACUOutDT = this.DateTime.datetimebox('getValue');

        operSchedule.PACUOutDT = convertToTimeStamp(PACUOutDT);
        operSchedule.AreaOutTransLoc = nextPosition;
        transfer(operSchedule, nextPosition);
        this.close();
    },
    sendToWait: function() {
        var operScheduleId = this.Patient.combobox('getValue');

        var operSchedules = this.Patient.combobox('getData');

        var operSchedule = null;
        $.each(operSchedules, function() {
            if (this.RowId === operScheduleId) {
                operSchedule = this;
                return false;
            }
        });
        returnToWait(operSchedule);
        this.close();
    }
}

var monitoringView = {
    init: function() {
        this.dom = $('<div class="monitoringview"></div>').appendTo('body');
        this.dom.hide();

        this.header = $('<div class="monitoringview-header"></div>').appendTo(this.dom);

        this.monitorName = $('<span class="monitoringview-monitor"></span>').appendTo(this.header);

        this.btnChangeMonitor = $('<a href="#" class="monitoringview-button icon-change"></a>')
            .appendTo(this.header)
            .bind('click', function() {

            });

        var vitalSignContainer = $('<div class="monitoringview-content"></div>').appendTo(this.dom);

        var row = $('<div class="monitoringview-r"></div>')
            .append('<span class="monitoringview-r-item">HR</span>')
            .append('<span class="monitoringview-r-value"></span>')
            .append('<span class="monitoringview-r-unit">次/分</span>')
            .appendTo(vitalSignContainer);

        var row = $('<div class="monitoringview-r"></div>')
            .append('<span class="monitoringview-r-item">SPO2</span>')
            .append('<span class="monitoringview-r-value"></span>')
            .append('<span class="monitoringview-r-unit">%</span>')
            .appendTo(vitalSignContainer);

        var row = $('<div class="monitoringview-r"></div>')
            .append('<span class="monitoringview-r-item">BP</span>')
            .append('<span class="monitoringview-r-value"></span>')
            .append('<span class="monitoringview-r-unit">mmHg</span>')
            .appendTo(vitalSignContainer);

    },
    render: function(datas) {
        var HR = "",
            SPO2 = "",
            BP = "",
            NBPS = "",
            NBPD = "";

        var length = datas.length;
        for (var i = 0; i < length; i++) {
            var data = datas[i];
            switch (data.DataItemCode) {
                case "HR":
                    HR = data.DataValue;
                    break;
                case "SPO2":
                    SPO2 = data.DataValue;
                    break;
                case "NBPS":
                    NBPS = data.DataValue;
                    break;
                case "NBPD":
                    NBPD = data.DataValue;
                    break;
                default:
                    break;
            }

        }
    }
}

/**
 * Steward评分
 */
var StewardAssessView = {
    init: function() {
        var _this = this;
        this.dom = $('<div class="pacu-assessview"></div>').appendTo('body');
        this.container = $('<div class="pacu-assessview-container"></div>').appendTo(this.dom);

        this.form = $('<form></form>').appendTo(this.container).form({});

        $('<div></div>').appendTo(this.form)
            .append('<div>清醒程度：</div>')
            .append('<input id="pacu_assessview_f_c_2" type="radio" name="Conscious" value="2">')
            .append('<label for="pacu_assessview_f_c_2">完全苏醒</label><br/>')
            .append('<input id="pacu_assessview_f_c_1" type="radio" name="Conscious" value="1">')
            .append('<label for="pacu_assessview_f_c_1">对刺激有反应</label><br/>')
            .append('<input id="pacu_assessview_f_c_0" type="radio" name="Conscious" value="0">')
            .append('<label for="pacu_assessview_f_c_0">对刺激无反应</label><br/>');

        $('<div></div>').appendTo(this.form)
            .append('<div>呼吸道通畅程度：</div>')
            .append('<input id="pacu_assessview_f_r_2" type="radio" name="Respiration" value="2">')
            .append('<label for="pacu_assessview_f_r_2">可按医师吩咐咳嗽</label><br/>')
            .append('<input id="pacu_assessview_f_r_1" type="radio" name="Respiration" value="1">')
            .append('<label for="pacu_assessview_f_r_1">不用支持可以维持呼吸道通畅</label><br/>')
            .append('<input id="pacu_assessview_f_r_0" type="radio" name="Respiration" value="0">')
            .append('<label for="pacu_assessview_f_r_0">呼吸道需要予以支持</label><br/>');

        $('<div></div>').appendTo(this.form)
            .append('<div>肢体活动度：</div>')
            .append('<input id="pacu_assessview_f_m_2" type="radio" name="Motion" value="2">')
            .append('<label for="pacu_assessview_f_m_2">肢体能作有意识的活动</label><br/>')
            .append('<input id="pacu_assessview_f_m_1" type="radio" name="Motion" value="1">')
            .append('<label for="pacu_assessview_f_m_1">肢体无意识活动</label><br/>')
            .append('<input id="pacu_assessview_f_m_0" type="radio" name="Motion" value="0">')
            .append('<label for="pacu_assessview_f_m_0">肢体无活动</label><br/>');

        this.container.find('input').radio({
            onChecked: function() {
                _this.save();
            }
        });

        this.close();
        this.dom.mouseleave(function() {
            _this.clear();
            _this.close();
            _this.callback = null;
        });
        this.initiated = true;
    },
    setCallback: function(callback) {
        this.callback = callback;
    },
    /**
     * 加载数据
     * @param {Module:ANCLS.Model.StewardAssessment}
     */
    render: function(data) {
        this.originalData = data;
        if (data) {
            this.container.find('input[name="Conscious"]').each(function(i, e) {
                if ($(e).val() === data.Conscious) {
                    $(e).radio('setValue', true);
                }
            });
            this.container.find('input[name="Respiration"]').each(function(i, e) {
                if ($(e).val() === data.Respiration) {
                    $(e).radio('setValue', true);
                }
            });
            this.container.find('input[name="Motion"]').each(function(i, e) {
                if ($(e).val() === data.Motion) {
                    $(e).radio('setValue', true);
                }
            });
        }
    },
    /**
     * 保存
     */
    save: function() {
        if (this.callback) {
            var data = this.toData();
            this.callback(data);
        }
    },
    /**
     * 关闭
     */
    close: function() {
        this.dom.hide();
        this.closed = true;
        this.originalData = null;
    },
    /**
     * 打开
     */
    open: function() {
        if (!this.initiated) this.init();
        this.dom.show();
        this.closed = false;
    },
    clear: function() {
        this.form.form('clear');
        this.form.find('input[type="radio"]').each(function(index, e) {
            $($(this).parent()).removeClass('checked');
            $(this).radio('enable');
        });
    },
    setDisplayMode: function() {
        this.form.find('input[type="radio"]').each(function(index, e) {
            $(this).radio('disable');
        });
    },
    position: function(position) {
        this.dom.css({ left: position.left, top: position.top - 80 });
    },
    toData: function() {
        var data = {};
        this.container.find('input[name="Conscious"]').each(function(i, e) {
            if ($(e).radio('getValue')) {
                data.Conscious = $(e).val();
            }
        });
        this.container.find('input[name="Respiration"]').each(function(i, e) {
            if ($(e).radio('getValue')) {
                data.Respiration = $(e).val();
            }
        });
        this.container.find('input[name="Motion"]').each(function(i, e) {
            if ($(e).radio('getValue')) {
                data.Motion = $(e).val();
            }
        });

        data.Score = '';
        if (data.Conscious && data.Respiration && data.Motion) {
            data.Score = Number(data.Conscious) + Number(data.Respiration) + Number(data.Motion);
        }

        return $.extend({}, this.originalData, data);
    }
}

$(document).ready(function() {
    pacuStation.waitingListContainer = $('#waiting_list');
    pacuStation.finishedListContainer = $('#finished_list');
    pacuStation.bedContainer = $('#bed_board');
    pacuStation.banner = window.operScheduleBanner.init('#patinfo_banner', {});
    pacuStation.badges = {
        waitingListCounter: $('#waiting_list_num'),
        finishedListCounter: $('#finished_list_num'),
        bedCounter: $('#entire_beds_num'),
        occupiedBedCounter: $('#occupied_beds_num'),
        availableBedCounter: $('#available_beds_num'),
    }

    pacuStation.waitingListContainer.delegate('.arrange-button', 'click', function() {
        var operSchedule = getBindedData(this);
        arrangePatient(operSchedule);
    });

    pacuStation.waitingListContainer.delegate('.arrange-button', 'mouseenter', function() {
        $($(this).parent()).draggable('disable');
    });

    pacuStation.waitingListContainer.delegate('.arrange-button', 'mouseleave', function() {
        $($(this).parent()).draggable('enable');
    });

    pacuStation.bedContainer.delegate('.bed-button', 'click', function() {
        var bed = getBindedData(this);
        arrangeBed(bed);
    });

    pacuStation.bedContainer.delegate('.bed-occupied .bed-main', 'mouseenter', function() {
        var bedMask = $(this).siblings('.bed-mask');
        slideInMask(bedMask);
    });

    pacuStation.bedContainer.delegate('.bed-occupied', 'mouseleave', function() {
        var bedMask = $(this).children('.bed-mask');
        slideOutMask(bedMask);
    });

    pacuStation.moduleDialog = $('<div></div>').appendTo('body');

    pacuStation.bedContainer.delegate('.bed-patient-info-steward', 'click', function() {
        var data = $(this).data('data');
        StewardAssessView.setDisplayMode();
        StewardAssessView.render(data);
        var pos = $(this).offset();
        StewardAssessView.position({
            left: pos.left + 15,
            top: pos.top
        });
        StewardAssessView.open();
    });

    $('#btn_refresh').click(function() {
        event.stopPropagation();
        event.cancelBubble = true;
        event.preventDefault();
        loadPage();
    });

    StewardAssessView.init();

    //加载模拟数据
    /*$.ajax({
        url: '../service/dhcanop/data/test.pacu.json',
        method: 'GET',
        async: true,
        success: function(data) {
            loadTestData(data);
            refreshDuration();
            refreshBadges();
        }
    });*/


    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindPACUBed',
        ArgCnt: 0
    }, 'json', false, function(data) {
        loadBeds(data);
    });

    loadPage();

    setInterval(refreshDuration, 1000);

    setInterval(loadPage, 300000);
});

function loadPage() {
    $('#load_mask').show();
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperSchedule,
        QueryName: 'FindPACUList',
        ArgCnt: 0
    }, 'json', true, function(data) {
        processOperScheduleList(data);
    });
    setTimeout(function() {
        $('#load_mask').hide();
    }, 500);
}

function loadBeds(data) {
    pacuStation.beds = data || [];
    bedView.render(pacuStation.bedContainer, pacuStation.beds);
}

function processOperScheduleList(data) {
    var waitingList = [];
    var inBedList = [];
    var finishedList = [];
    var length = data.length;

    var operSchedule = null;
    for (var i = 0; i < length; i++) {
        operSchedule = data[i];
        if (operSchedule.PACUInDT && !operSchedule.PACUOutDT) {
            inBedList.push(operSchedule);
        } else if (operSchedule.PACUOutDT) {
            finishedList.push(operSchedule);
        } else {
            waitingList.push(operSchedule);
        }
    }

    loadWaitingList(waitingList);
    loadInBedList(inBedList);
    loadFinishedList(finishedList);
    refreshDuration();
    refreshBadges();
}

function loadWaitingList(data) {
    pacuStation.waitingList = data || [];
    waitingListView.render(pacuStation.waitingListContainer, pacuStation.waitingList);
}

function loadInBedList(data) {
    pacuStation.inBedList = data || [];
    $.each(pacuStation.inBedList, function(index, operSchedule) {
        var bedDom = getBedDom(operSchedule.PACUBed);
        occupiedBed.render(bedDom, operSchedule);
    });
}

function loadFinishedList(data) {
    pacuStation.finishedList = data || [];
    finishedListView.render(pacuStation.finishedListContainer, pacuStation.finishedList);
}

/**
 * 加载测试数据
 */
function loadTestData(data) {
    loadBeds(data.beds);
    loadWaitingList(data.waitingList);
    loadInBedList(data.inBedList);
    loadFinishedList(data.finishedList);
}

/**
 * 刷新床位占用时间
 */
function refreshDuration() {
    $.each(pacuStation.beds, function(index, bed) {
        var bedDom = getBedDom(bed.RowId);
        if (bed.occupied) {
            var operSchedule = bedDom.data('oper_schedule');
            var duration = calculateDuration(operSchedule.PACUInDT);
            bedDom.find('span.bed-occupied-duration span').text(duration);
        } else {
            bedDom.find('span.bed-occupied-duration span').text('');
        }
    });
}

/**
 * 刷新所有徽章的值
 */
function refreshBadges() {
    var badges = pacuStation.badges;
    if (badges.waitingListCounter) badges.waitingListCounter.text(pacuStation.waitingList.length);
    if (badges.finishedListCounter) badges.finishedListCounter.text(pacuStation.finishedList.length);
    if (badges.bedCounter) badges.bedCounter.text(pacuStation.beds.length);

    var occupiedBedNum = 0,
        availableBedNum = 0;
    $.each(pacuStation.beds, function(index, bed) {
        if (bed.occupied) occupiedBedNum++;
        else availableBedNum++;
    });
    if (badges.occupiedBedCounter) badges.occupiedBedCounter.text(occupiedBedNum);
    if (badges.availableBedCounter) badges.availableBedCounter.text(availableBedNum);
}

/**
 * 计算时间间隔
 * @param {string or Date} startDT
 */
function calculateDuration(startDT) {
    var sDate = null,
        eDate = new Date();
    if (startDT instanceof Date) {
        sDate = startDT;
    } else if (typeof startDT === 'string') {
        sDate = new Date().tryParse(startDT, 'yyyy-MM-dd HH:mm');
    } else return 'invalid arguments';

    var span = new TimeSpan(eDate, sDate);

    //return (span.day ? (span.day + '天') : '') + (span.hour ? (span.hour + '时') : '') + span.minute + '分';
    return (span.hour < 10 ? '0' : '') + span.hour + ':' + (span.minute < 10 ? '0' : '') + span.minute + ':' + (span.second < 10 ? '0' : '') + span.second;
}


/**
 * 滑入
 */
function slideInMask(e) {
    var top = 0 - $(e).height();
    $(e).animate({ top: top });
}

/**
 * 滑出
 */
function slideOutMask(e) {
    $(e).animate({ top: 0 });
}

/**
 * 获取等待区的病人
 */
function getWaitingPatients() {
    return pacuStation.waitingList;
}

/**
 * 获取当前在床位病人
 */
function getInBedPatients() {
    return pacuStation.inBedList;
}

/**
 * 获取未被占用的床位
 */
function getUnoccupiedBeds() {
    var result = [];
    $.each(pacuStation.beds, function(index, bed) {
        if (!bed.occupied) result.push(bed);
    });

    return result;
}

/**
 * 安排患者
 */
function arrangePatient(operSchedule) {
    if (!arrangeView.initiated) arrangeView.init();
    arrangeView.refreshFormOptions();
    arrangeView.setPatient(operSchedule);
    arrangeView.open();
}

/**
 * 安排床位
 */
function arrangeBed(bed) {
    if (!arrangeView.initiated) arrangeView.init();
    arrangeView.refreshFormOptions();
    arrangeView.setBed(bed);
    arrangeView.open();
}

/**
 * 安排病人到床位
 * @param {object} operSchedule
 * @param {object} bed
 */
function arrange(operSchedule, bed) {
    var savingDatas = [];
    savingDatas.push({
        ClassName: ANCLS.Model.OperSchedule,
        RowId: operSchedule.RowId,
        PACUInDT: operSchedule.PACUInDT,
        PACUBed: operSchedule.PACUBed,
        isChangedSteward: operSchedule.isChangedSteward || 'N',
        InPACUSteward: operSchedule.InPACUSteward,
        InPACUStewardScore: operSchedule.InPACUStewardScore,
        InPACUStewardConscious: operSchedule.InPACUStewardConscious,
        InPACUStewardRespiration: operSchedule.InPACUStewardRespiration,
        InPACUStewardMotion: operSchedule.InPACUStewardMotion
    });
    savingDatas.push({
        RowId: '',
        OperSchedule: operSchedule.RowId,
        Description: '安排床位',
        StartDT: operSchedule.TheatreOutDT,
        EndDT: operSchedule.PACUInDT,
        FormerLoc: operSchedule.OperRoom,
        TargetLoc: bed.RowId,
        ClassName: ANCLS.Model.PACUTransaction
    })

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "TransactPACU",
        Arg1: dhccl.formatObjects(savingDatas),
        Arg2: session.UserID,
        ArgCnt: 2
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            occupiedBed.render(getBedDom(bed.RowId), operSchedule);
            //刷新等待区...
            var index = pacuStation.waitingList.indexOf(operSchedule); //IE8及以下不支持indexOf
            pacuStation.inBedList.push(operSchedule);
            pacuStation.waitingList.splice(index, 1);
            waitingListView.render(pacuStation.waitingListContainer, pacuStation.waitingList);
            refreshDuration();
            refreshBadges();
        } else {
            dhccl.showMessage(ret, "保存失败！");
        }
    });
}

/**
 * 换床
 */
function changeBed(operSchedule, formerBed) {
    if (!arrangeView.initiated) arrangeView.init();
    arrangeView.refreshFormOptions();
    arrangeView.setPatient(operSchedule);
    arrangeView.setBed(formerBed);
    arrangeView.changeBed(formerBed);
    arrangeView.open();
}

/**
 * 换床保存
 */
function changeBedSaveHandler(operSchedule, bed, additionalData) {
    var savingDatas = [];
    savingDatas.push({
        ClassName: ANCLS.Model.OperSchedule,
        RowId: operSchedule.RowId,
        PACUInDT: operSchedule.PACUInDT,
        PACUBed: operSchedule.PACUBed,
        isChangedSteward: operSchedule.isChangedSteward || 'N',
        InPACUSteward: operSchedule.InPACUSteward,
        InPACUStewardScore: operSchedule.InPACUStewardScore,
        InPACUStewardConscious: operSchedule.InPACUStewardConscious,
        InPACUStewardRespiration: operSchedule.InPACUStewardRespiration,
        InPACUStewardMotion: operSchedule.InPACUStewardMotion
    });
    savingDatas.push({
        RowId: '',
        OperSchedule: operSchedule.RowId,
        Description: '更换床位',
        StartDT: additionalData.changeDT,
        EndDT: additionalData.changeDT,
        FormerLoc: additionalData.formerBed.RowId,
        TargetLoc: bed.RowId,
        ClassName: ANCLS.Model.PACUTransaction
    });

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "TransactPACU",
        Arg1: dhccl.formatObjects(savingDatas),
        Arg2: session.UserID,
        ArgCnt: 2
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            var bedDom = getBedDom(operSchedule.PACUBed);
            occupiedBed.render(bedDom, operSchedule);
            var bedDom = getBedDom(additionalData.formerBed.RowId);
            emptyBed.render(bedDom, operSchedule);
            refreshDuration();
        } else {
            dhccl.showMessage(ret, "失败换床！");
        }
    });
}

/**
 * 转换为时间戳字符串格式
 * @param {string} dateTimeStr 
 * @return {string}
 */
function convertToTimeStamp(dateTimeStr) {
    return new Date().tryParse(dateTimeStr).format(constant.timeStampFormat);
}

/**
 * 转出按钮Handler
 * @param {object} bed 
 */
function transferPatientInBed(bed) {
    var bedDom = getBedDom(bed.RowId);
    var operSchedule = bedDom.data('oper_schedule');
    if (!transferView.initiated) transferView.init();
    transferView.setPatient(operSchedule);
    transferView.open();
}

/**
 * 返回等待区
 * @param {object} operSchedule 
 */
function returnToWait(operSchedule) {
    var bedDom = getBedDom(operSchedule.PACUBed);
    var bed = $(bedDom).data('data');
    operSchedule.PACUBed = '';
    operSchedule.PACUInDT = '';
    bed.occupied = false;
    var nowDateTime = new Date().format(constant.timeStampFormat);

    var savingDatas = [];
    savingDatas.push({
        RowId: operSchedule.RowId,
        PACUInDT: operSchedule.PACUInDT,
        PACUBed: operSchedule.PACUBed,
        ClassName: ANCLS.Model.OperSchedule
    });
    savingDatas.push({
        RowId: '',
        OperSchedule: operSchedule.RowId,
        Description: '返回等待区',
        StartDT: nowDateTime,
        EndDT: nowDateTime,
        FormerLoc: bed.RowId,
        TargetLoc: '',
        ClassName: ANCLS.Model.PACUTransaction
    })
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "TransactPACU",
        Arg1: dhccl.formatObjects(savingDatas),
        Arg2: session.UserID,
        ArgCnt: 2
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            emptyBed.render(bedDom);
            var index = pacuStation.inBedList.indexOf(operSchedule); //IE8及以下不支持indexOf
            pacuStation.inBedList.splice(index, 1);
            pacuStation.waitingList.push(operSchedule);
            waitingListView.render(pacuStation.waitingListContainer, pacuStation.waitingList);
            refreshDuration();
            refreshBadges();
        } else {
            dhccl.showMessage(ret, "返回等待区失败");
        }
    });
}

/**
 * 病人转移
 * @param {object} operSchedule 
 * @param {string} nextLocation
 */
function transfer(operSchedule, nextLocation) {
    var bedDom = getBedDom(operSchedule.PACUBed);
    var bed = $(bedDom).data('data');
    bed.occupied = false;
    var nowDateTime = new Date().format('yyyy-MM-dd HH:mm:ss');
    //保存
    var savingDatas = [];
    savingDatas.push({
        ClassName: ANCLS.Model.OperSchedule,
        RowId: operSchedule.RowId,
        PACUOutDT: operSchedule.PACUOutDT,
        AreaOutTransLoc: operSchedule.AreaOutTransLoc,
        isChangedSteward: operSchedule.isChangedSteward || 'N',
        OutPACUSteward: operSchedule.OutPACUSteward,
        OutPACUStewardScore: operSchedule.OutPACUStewardScore,
        OutPACUStewardConscious: operSchedule.OutPACUStewardConscious,
        OutPACUStewardRespiration: operSchedule.OutPACUStewardRespiration,
        OutPACUStewardMotion: operSchedule.OutPACUStewardMotion
    });
    savingDatas.push({
        RowId: '',
        OperSchedule: operSchedule.RowId,
        Description: '转出PACU',
        StartDT: nowDateTime,
        EndDT: nowDateTime,
        FormerLoc: bed.RowId,
        TargetLoc: '',
        ClassName: ANCLS.Model.PACUTransaction
    })
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.AnaestRecord,
        MethodName: "TransactPACU",
        Arg1: dhccl.formatObjects(savingDatas),
        Arg2: session.UserID,
        ArgCnt: 2
    }, function(ret) {
        if (ret.indexOf("S^") === 0) {
            emptyBed.render(bedDom);

            var index = pacuStation.inBedList.indexOf(operSchedule); //IE8及以下不支持indexOf
            pacuStation.inBedList.splice(index, 1);
            pacuStation.finishedList.push(operSchedule);

            finishedListView.render(pacuStation.finishedListContainer, pacuStation.finishedList);

            refreshDuration();
            refreshBadges();
        } else {
            dhccl.showMessage(ret, "传出失败");
        }
    });
}

/**
 * 根据床位对象RowId获取bed元素
 * @param {string} bedRowId 
 */
function getBedDom(bedRowId) {
    return $('#' + (bedView.idPrefix + bedRowId));
}

/**
 * 获取绑定的数据
 * @param {HTMLElement} element 
 */
function getBindedData(element) {
    var target = $(element).parents('.data-binded');
    return target.data('data');
}

/**
 * 日期格式化
 * @param {*} date 
 */
function DateTimeFormatter(date) {
    if (!date) return;
    return date.format(constant.dateTimeFormat);
}

/**
 * 日期输出
 * @param {*} s 
 */
function DateTimeParser(s) {
    return (new Date()).tryParse(s, constant.dateTimeFormat);
}

/**
 * 拖动代理
 */
function proxy(source) {
    var p = $('<div style="z-index:10000;" class="waiting-patient"></div>').appendTo('body');
    p.css({ 'width': $(source).width(), height: $(source).height() });
    p.html($(source).clone().html());

    return p;
}

/**
 * 恢复记录按钮Handler
 */
function recordClickHandler() {
    var operSchedule = $(this).parents('.bed-occupied').data('oper_schedule');
    var moudleId = '';
    var href = '<iframe scrolling="yes" frameborder="0" src="' + 'dhcan.anaestrecord.csp' +
        '?opsId=' + operSchedule.RowId +
        '&EpisodeID=' + operSchedule.EpisodeID +
        '&moduleCode=AnaestRecord" style="width:100%;height:100%;"></iframe>';
    title = operSchedule.PatName + '的恢复记录';

    pacuStation.moduleDialog.dialog({
        modal: true,
        closed: true,
        width: 1040,
        height: 580,
        content: href
    });
    pacuStation.moduleDialog.dialog("setTitle", title);
    pacuStation.moduleDialog.dialog("open");
}

/**
 * 换床
 */
function changeBedClickHandler() {
    var target = $(this).parents('.data-binded');
    var bed = target.data('data');
    var operSchedule = target.data('oper_schedule');

    changeBed(operSchedule, bed);
}

/**
 * 转移记录按钮Handler
 */
function transferClickHandler() {
    var bed = getBindedData(this);
    transferPatientInBed(bed);
}