/**
 * Steward评分
 * @author yongyang 20180613
 */
(function($) {
    $.fn.stewardeditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.stewardeditbox.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("stewardeditbox");
            if (!state) {
                $(this).data("stewardeditbox", {
                    options: $.extend({}, $.fn.stewardeditbox.defaults, options),
                    data: []
                })
                state = $(this).data("stewardeditbox");

                create(this);
                request(this);
            }
        }
    }

    $.fn.stewardeditbox.methods = {
        dataItem: function(target) {
            return $(target).data('DataItem');
        },
        options: function(target) {
            return $(target).data('stewardeditbox').options;
        },
        panel: function(target) {
            return $(target).data('stewardeditbox').panel;
        },
        setDHCData: function(target, data) {
            var dataItem = $(target).data('DataItem');
            var stewardeditbox = $(target).data('stewardeditbox');
            var options = stewardeditbox.options;
            $(target).data('DHCData', data);
        },
        getDHCData: function(target) {
            var dataItem = $(target).data('DataItem');
            var stewardeditbox = $(target).data('stewardeditbox');
            var oldDHCData = $(target).data('DHCData', data);

            var detailContainer = stewardeditbox.detailContainer;
            var data = detailContainer.toData();

            var DHCData = {};
            DHCData[dataItem.valueField] = oldDHCData[dataItem.valueField] || '';
            DHCData[dataItem.textField] = data.Score;

            var length = dataItem.fields.length;
            var field;
            for (var i = 0; i < length; i++) {
                field = dataItem.fields[i];
                if (dataItem.valueField != field && dataItem.textField != field) {
                    DHCData[field] = DHCData[dataItem.valueField];
                }
            }

            return DHCData;
        },
        isChanged: function(target) {
            var dataItem = $(target).data('DataItem');
            var oldDHCData = $(target).data('DHCData');
            var newDHCData = $(target).stewardeditbox('getDHCData');

            return !((oldDHCData[dataItem.valueField] === newDHCData[dataItem.valueField]) &&
                (oldDHCData[dataItem.textField] === newDHCData[dataItem.textField]))
        },
        save: function(target, param) {
            var oldDHCData = $(target).data('DHCData');
            var newDHCData = $(target).stewardeditbox('getDHCData');
            var dataItem = $(target).data('DataItem');
            var stewardeditbox = $(target).data('stewardeditbox');
            var detailContainer = stewardeditbox.detailContainer;
            var options = stewardeditbox.options;
            var newData = detailContainer.toData();
            var originalData = stewardeditbox.data || [];

            var isChanged = !((originalData['Conscious'] === newData['Conscious']) &&
                (originalData['Respiration'] === newData['Respiration']) &&
                (originalData['Motion'] === newData['Motion']));

            var stewardeditbox = $(target).data('stewardeditbox');
            var options = stewardeditbox.options;

            var savingData = {
                ClassName: dataItem.className,
                RowId: oldDHCData.RowId
            };

            var savingDetailData = $.extend({}, newData, {
                ClassName: dataItem.detailClassName,
                OperSchedule: options.operScheduleId
            });

            if (isChanged) {
                if (!param || !param.needConfirm) saveData();
                else {
                    $.messager.confirm("请确认保存当前修改",
                        "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改:" + originalText + " → " + presentText + "</div><div><em>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                        function(confirmed) { if (confirmed) saveData(); });
                }

                return false;
            }

            return true;

            function saveData() {
                dhccl.saveDatas(ANCSP.DataService, savingDetailData, function(result) {
                    if (result.indexOf("S^") >= 0) {
                        var detailRowId = savingDetailData['RowId'] || result.split("S^")[1] || "";
                        savingData[dataItem.valueField] = detailRowId;
                        oldDHCData[dataItem.valueField] = detailRowId;
                        $(target).data('DHCData', oldDHCData);
                        newDHCData[dataItem.valueField] = detailRowId;
                        newDHCData[dataItem.textField] = newData.Score;
                        for (var field in newDHCData) {
                            if (field != dataItem.valueField && field != dataItem.textField) {
                                newDHCData[field] = detailRowId;
                                savingData[field] = detailRowId;
                            }
                        }
                        dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                            if (result.indexOf("S^") >= 0) {
                                if (options.onSaveSuccess) {
                                    options.onSaveSuccess.call(target, newDHCData);
                                }
                            } else {
                                if (options.onSaveError) {
                                    options.onSaveError.call(target, result);
                                }
                            }
                        });
                    } else {
                        if (options.onSaveError) {
                            options.onSaveError.call(target, result);
                        }
                    }
                });
            }
        },
        loadData: function(target, data) {
            var stewardeditbox = $(target).data('stewardeditbox');
            var options = stewardeditbox.options;
            stewardeditbox.data = data[0];
            stewardeditbox.detailContainer.render(stewardeditbox.data);
        },
        reload: function(target) {
            request(target);
        },
        clear: function() {

        },
        validate: function() {
            return true;
        }
    }

    $.fn.stewardeditbox.defaults = {
        infoItemPrefix: "stewardeditbox_input_i_",
        index: 0,
        width: 500,
        height: 150
    }

    /**
     * 创建Steward明细编辑界面
     */
    function create(target) {
        var options = $(target).stewardeditbox("options");
        var stewardeditbox = $(target).data('stewardeditbox');
        $(target).addClass("textbox");
        $(target).attr("readOnly", true);
        $(target).attr("width", options.width);

        $.fn.stewardeditbox.defaults.index++;

        stewardeditbox.detailContainer = new detailContainer(target);
        stewardeditbox.detailContainer.open();
    }

    function detailContainer(target) {
        this.target = target;
        var options = $(target).stewardeditbox('options');
        this.width = 220;
        this.init(target);
    }

    detailContainer.prototype = {
        constructor: detailContainer,
        init: function(target) {
            var _this = this;
            this.dom = $('<div class="panel combo-p stewardeditbox-detailcontainer"></div>').appendTo('body');
            this.dom.width(this.width);
            this.dom.panel({ height: 'auto' });
            this.dom.on('mouseleave', function() {
                $(this).hide();
            });
            $(target).on('mouseenter', function() {
                _this.open();
            });
            this.dom.delegate('input', 'click', function() {
                _this.onChange();
            });
            this.dom.delegate('label', 'click', function() {
                _this.onChange();
            });
            this.initForm();
            return this.dom;
        },
        initForm: function() {
            this.form = $('<form></form>').appendTo(this.dom);
            this.form.form({});

            $('<div></div>').appendTo(this.form)
                .append('<div style="font-weight:bold;">清醒程度：</div>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_c_2" type="radio" name="Conscious" value="2">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_c_2">完全苏醒</label><br/>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_c_1" type="radio" name="Conscious" value="1">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_c_1">对刺激有反应</label><br/>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_c_0" type="radio" name="Conscious" value="0">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_c_0">对刺激无反应</label><br/>');

            $('<div></div>').appendTo(this.form)
                .append('<div style="font-weight:bold;">呼吸道通畅程度：</div>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_r_2" type="radio" name="Respiration" value="2">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_r_2">可按医师吩咐咳嗽</label><br/>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_r_1" type="radio" name="Respiration" value="1">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_r_1">不用支持可以维持呼吸道通畅</label><br/>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_r_0" type="radio" name="Respiration" value="0">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_r_0">呼吸道需要予以支持</label><br/>');

            $('<div></div>').appendTo(this.form)
                .append('<div style="font-weight:bold;">肢体活动度：</div>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_m_2" type="radio" name="Motion" value="2">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_m_2">肢体能作有意识的活动</label><br/>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_m_1" type="radio" name="Motion" value="1">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_m_1">肢体无意识活动</label><br/>')
                .append('<input id="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_m_0" type="radio" name="Motion" value="0">')
                .append('<label for="i_' + $.fn.stewardeditbox.defaults.index + '_stewardasess_f_m_0">肢体无活动</label><br/>');
        },
        /**
         * 加载数据
         * @param {Module:ANCLS.Model.StewardAssessment}
         */
        render: function(data) {
            this.originalData = data;
            if (data) {
                this.form.find('input[name="Conscious"]').each(function(i, e) {
                    if ($(e).val() === data.Conscious) {
                        $(e).prop('checked', true);
                    }
                });
                this.form.find('input[name="Respiration"]').each(function(i, e) {
                    if ($(e).val() === data.Respiration) {
                        $(e).prop('checked', true);
                    }
                });
                this.form.find('input[name="Motion"]').each(function(i, e) {
                    if ($(e).val() === data.Motion) {
                        $(e).prop('checked', true);
                    }
                });
                $(this.target).val(data.Score);
            }
        },
        onChange: function() {
            var data = this.toData();
            $(this.target).val(data.Score);
        },
        toData: function() {
            var data = {};
            this.form.find('input[name="Conscious"]').each(function(i, e) {
                if ($(e).prop('checked')) {
                    data.Conscious = $(e).val();
                }
            });
            this.form.find('input[name="Respiration"]').each(function(i, e) {
                if ($(e).prop('checked')) {
                    data.Respiration = $(e).val();
                }
            });
            this.form.find('input[name="Motion"]').each(function(i, e) {
                if ($(e).prop('checked')) {
                    data.Motion = $(e).val();
                }
            });

            data.Score = '';
            if (data.Conscious && data.Respiration && data.Motion) {
                data.Score = Number(data.Conscious) + Number(data.Respiration) + Number(data.Motion);
            }

            return $.extend({}, this.originalData, data);
        },
        visible: function() {
            return this.dom.is(':hidden');
        },
        clear: function() {
            this.form.form('clear');
            this.form.find('input').each(function(i, e) {
                $(e).prop('checked', false);
                $($(e).parent()).removeClass('checked');
            });
        },
        open: function() {
            var offset = this.target.offset();
            var height = this.target.height();
            var width = this.target.width();
            this.dom.css({
                top: offset.top + height + 6,
                left: offset.left + width - this.width + 10
            });
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        }
    }

    function request(target) {
        var stewardeditbox = $(target).data('stewardeditbox');
        var options = stewardeditbox.options;
        var param = options.queryParams;
        var url = options.url || ANCSP.DataQueries;
        if (param && url) {
            $.ajax({
                url: url,
                async: true,
                data: param,
                type: "post",
                dataType: 'json',
                success: function(data) {
                    if (data) {
                        $(target).stewardeditbox('loadData', data);
                    }
                }
            });
        }

        if (options.data && options.data.length > 0) {
            $(target).stewardeditbox('loadData', options.data);
        }
    }
})(jQuery);