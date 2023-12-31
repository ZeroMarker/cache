/**
 * 手术流程展示区域
 * @author yongyang 20180508
 */

(function(global, factory) {
    if (!global.ProcedureBoard) factory(global.ProcedureBoard = {});
}(this, function(exports) {

    exports.init = function(dom, opt) {
        var view = new ProcedureBoard(dom, opt);
        exports.instance = view;
        return view;
    }

    function ProcedureBoard(dom, opt) {
        this.dom = $(dom);
        this.options = opt;
        this.onClick = opt.onClick;
        this.init();
    }

    ProcedureBoard.prototype = {
        /**
         * 初始化区域
         */
        init: function() {
            var _this = this;
            this.dom.addClass('procedure-board');
            this.Filter = $('<input type="text" name="Filter">').appendTo($('<div class="pb-filter"></div>').appendTo(this.dom));
            this.Filter.combobox({
                width: 170,
                textField: 'text',
                valueField: 'value',
                value: 'All',
                data: [
                    { text: '全部', value: 'All' },
                    { text: '已完成', value: 'Finished' },
                    { text: '未完成', value: 'Unfinished' }
                ]
            });

            this.procedureContainer = $('<div class="pb-container"></div>').appendTo(this.dom);
            this.procedureContainer.delegate('.pb-procedure', 'click', function() {
                var procedure = $(this).data('data');
                _this.trigger(procedure);
            });
        },
        /**
         * 加载数据，刷新区域显示
         */
        loadData: function(procedures) {
            this.data = procedures;
            this.refresh();
        },
        /**
         * 显示
         */
        refresh: function() {
            var filter = this.Filter.combobox('getValue');
            var filteredData = filterData(this.data, filter);
            view.render(this.procedureContainer, filteredData);
        },
        trigger: function(procedure) {
            if (this.onClick) {
                this.onClick.call(this, procedure);
            }
        }
    }

    var view = {
        render: function(container, procedures) {
            container.hide();
            container.empty();

            $.each(procedures, function(index, row) {
                container.append(createProcedureRow(row));
            });

            container.show();

            function createProcedureRow(procedure) {
                var htmlRow = $('<a href="#" class="pb-procedure"></a>');
                var icon = $('<span class="pb-procedure-i-icon"></span>').appendTo(htmlRow);
                var finished = false;

                if (procedure.eventItem) {
                    if (procedure.datas && procedure.datas.length > 0) {
                        procedure.finished = true;
                        var dateTime = procedure.datas[0].StartDT;
                        procedure.finishDT = dateTime.format(constant.dateTimeFormat);
                        procedure.finishTime = dateTime.format(constant.timeFormat);
                    } else {
                        //procedure.finished = false;
                        //procedure.finishDT = '';
                        //procedure.finishTime = '';
                    }
                }

                finished = procedure.finished;
                if (finished) {
                    htmlRow.addClass('pb-procedure-finished');
                    icon.addClass('icon-ok');
                    htmlRow.attr('title', '[' + procedure.type + '] ' +
                        procedure.name +
                        ((procedure.tags && procedure.tags.length > 0) ? ('(' + procedure.tags.join(' ') + ')') : '') +
                        ' 于' + procedure.finishDT + '完成');
                }
                if (procedure.required) {
                    htmlRow.addClass('pb-procedure-required');
                    if (!finished) htmlRow.attr('title', '必要流程');
                }
                htmlRow.append('<div class="pb-procedure-i-type">' + procedure.typeDesc + '</div>');

                var name = $('<div class="pb-procedure-i-name"></div>').appendTo(htmlRow);
                name.append('<span class="pb-procedure-i-name-text">' + procedure.name + '</span>');
                if (finished && procedure.finishTime) {
                    name.append('<span class="pb-procedure-i-time" title="' + procedure.finishDT + '">' + procedure.finishTime + '</span>');
                }

                var tags = $('<div class="pb-procedure-i-tags"></div>').appendTo(htmlRow);
                $.each(procedure.tags, function(tagIndex, tag) {
                    tags.append('<div class="pb-procedure-i-tag">' + tag + '</div>');
                });

                htmlRow.data('data', procedure);
                return htmlRow;
            }
        }
    }

    function filterData(data, filter) {
        var result = [];
        if (filter === 'All') return data;
        else {
            $.each(data, function(index, row) {
                if (row.finished == (filter == 'finished')) result.push(row);
            })
        }

        return result;
    }
}))