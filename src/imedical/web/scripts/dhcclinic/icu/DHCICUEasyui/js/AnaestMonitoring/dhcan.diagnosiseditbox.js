/**
 * 诊断编辑
 */
(function($) {
    $.fn.diagnosiseditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.diagnosiseditbox.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("diagnosiseditbox");
            if (!state) {
                $(this).data("diagnosiseditbox", {
                    options: $.extend({}, $.fn.diagnosiseditbox.defaults, options),
                    selectedRows: [],
                    data: []
                })
                state = $(this).data("diagnosiseditbox");

                create(this);
            }
        }
    }

    $.fn.diagnosiseditbox.methods = {
        dataItem: function(target) {
            return $(target).data('DataItem');
        },
        options: function(target) {
            return $(target).data('diagnosiseditbox').options;
        },
        panel: function(target) {
            return $(target).data('diagnosiseditbox').panel;
        },
        setDHCData: function(target, data) {
            var dataItem = $(target).data('DataItem');
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var options = diagnosiseditbox.options;
            $(target).data('DHCData', data);
            var idStr = data[dataItem.valueField] || '';
            var descStr = data[dataItem.textField] || '';

            var idArr = idStr.split('&&&');
            var descArr = descStr.split('；');
            var selectedRows = [];
            if (!((idStr === '') && (descArr === ''))) {
                var length = idArr.length;
                for (var i = 0; i < length; i++) {
                    selectedRows.push({
                        RowId: idArr[i].split('###')[0] || '',
                        Description: descArr[i] || ''
                    });
                }
            }
            diagnosiseditbox.selectedRows = selectedRows;
            options.editView.render(target, selectedRows);
        },
        getDHCData: function(target) {
            var dataItem = $(target).data('DataItem');
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var idArr = [];
            var descArr = [];

            var selectedRows = diagnosiseditbox.selectedRows;
            var length = selectedRows.length;

            for (var i = 0; i < length; i++) {
                idArr.push(selectedRows[i].RowId + '###' + selectedRows[i].Description + '###');
                descArr.push(selectedRows[i].Description)
            }

            var DHCData = {};
            DHCData[dataItem.valueField] = idArr.join('&&&');
            DHCData[dataItem.textField] = descArr.join('；');

            return DHCData;
        },
        isChanged: function(target) {
            var dataItem = $(target).data('DataItem');
            var oldDHCData = $(target).data('DHCData');
            var newDHCData = $(target).diagnosiseditbox('getDHCData');

            return !((oldDHCData[dataItem.valueField] === newDHCData[dataItem.valueField]) &&
                (oldDHCData[dataItem.textField] === newDHCData[dataItem.textField]))
        },
        save: function(target, param) {
            var oldDHCData = $(target).data('DHCData');
            var newDHCData = $(target).diagnosiseditbox('getDHCData');
            var dataItem = $(target).data('DataItem');

            var isChanged = !((oldDHCData[dataItem.valueField] === newDHCData[dataItem.valueField]) &&
                (oldDHCData[dataItem.textField] === newDHCData[dataItem.textField]));

            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var options = diagnosiseditbox.options;
            var selectedRows = diagnosiseditbox.selectedRows;

            var length = selectedRows.length;
            var idArr = [],
                descArr = [];
            for (var i = 0; i < length; i++) {
                idArr.push(selectedRows[i].RowId + '###' + selectedRows[i].Description + '###');
                descArr.push(selectedRows[i].Description);
            }

            var data = {};
            data[dataItem.valueField] = idArr.join('&&&');
            data[dataItem.textField] = descArr.join('；');

            var savingData = $.extend(data, {
                ClassName: dataItem.className,
                RowId: options.operScheduleId
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
                dhccl.saveDatas(dhccl.csp.dataService, savingData, function(result) {
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
            }
        },
        loadData: function(target, data) {
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var options = diagnosiseditbox.options;
            diagnosiseditbox.data = data;
            options.selectionView.render(target, data);
            options.selectionView.selectRows(target);
        },
        filter: function(target, text) {
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var options = diagnosiseditbox.options;
            var param = options.queryParams;
            var addingText = {};
            addingText[options.textField] = text;
            addingText[options.valueField] = text;
            $.extend(param, { q: text });
            $.ajax({
                url: options.url,
                async: true,
                data: param,
                type: "post",
                dataType: 'json',
                success: function(data) {
                    if (data) {
                        data.push(addingText);
                        $(target).diagnosiseditbox('loadData', data);
                    }
                }
            })
        },
        addRow: function(target, row) {
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var options = diagnosiseditbox.options;
            var selectedRows = diagnosiseditbox.selectedRows;

            selectedRows.push(row);
            options.editView.render(target, selectedRows);
        },
        removeRow: function(target, row) {
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var options = diagnosiseditbox.options;
            var selectedRows = diagnosiseditbox.selectedRows;

            var index = selectedRows.indexOf(row);
            if (index > -1) selectedRows.splice(index, 1);
            options.editView.render(target, selectedRows);
            if (row.target) {
                row.target.removeClass('diageditbox-item-selected');
            }
        },
        destory: function(target) {
            $(target).parent().empty();
        },
        close: function(target) {
            var opts = $(target).diagnosiseditbox('options');
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    }

    var editView = {
        render: function(target, data) {
            var options = $(target).data('diagnosiseditbox').options;
            var container = $(target).data('diagnosiseditbox').editViewContainer;
            container.empty();

            $.each(data, function(index, row) {
                $('<span class="tagbox-label" tagbox-index="0" style="height: 16px; line-height: 16px;"></span>')
                    .text(row[options.textField] || '')
                    .append('<a href="javascript:;" class="tagbox-remove"></a></span>')
                    .data('data', row)
                    .appendTo(container);
                $('<input type="hidden">')
                    .attr('name', 'Diagnosis')
                    .val(row[options.valueField] || '')
                    .appendTo(container);
            });
        }
    }

    var selectionView = {
        render: function(target, data) {
            this.data = data;
            var options = $(target).data('diagnosiseditbox').options;
            var container = $(target).data('diagnosiseditbox').selectionViewContainer;
            container.empty();

            var length = data.length;
            for (var i = 0; i < data.length; i++) {
                var element = $('<div class="combobox-item diageditbox-item"></div>')
                    .text(data[i][options.textField])
                    .data('data', data[i])
                    .appendTo(container);
                data[i].target = element;
            }
        },
        selectRows: function(target) {
            var diagnosiseditbox = $(target).data('diagnosiseditbox');
            var selectedRows = diagnosiseditbox.selectedRows;
            var options = $(target).data('diagnosiseditbox').options;
            var selectedRowIds = [];
            var length = (selectedRows || []).length;
            for (var i = 0; i < length; i++) {
                selectedRowIds.push(selectedRows[i][options.valueField]);
            }

            var length = this.data.length;
            for (var i = 0; i < length; i++) {
                var index = selectedRowIds.indexOf(this.data[i][options.valueField]);
                if (index > -1) {
                    selectedRows[index] = this.data[i];
                    this.data[i].target.addClass('diageditbox-item-selected');
                }
            }
        }
    }

    $.fn.diagnosiseditbox.defaults = {
        width: 200,
        height: 30,
        editView: editView,
        selectionView: selectionView
    }

    function create(target) {
        $(target).hide();
        var editViewContainer = $('<div style="min-height:30px;"></div>').appendTo($(target).parent());
        var selectionContainer = $('<div class="background-color:#fff;"></div>').appendTo($(target).parent());

        var options = $(target).diagnosiseditbox('options');
        editViewContainer.width(options.width);
        editViewContainer.panel({ height: 'auto' });

        selectionContainer.width(options.width);
        selectionContainer.panel({ height: 'auto' });

        var selectionViewHeader = $('<div style="padding:5px;"></div>').appendTo(selectionContainer);
        var selectionViewContainer = $('<div style="max-height:200px;overflow-x:hidden;overflow-y:auto;"></div>').appendTo(selectionContainer);

        var searchBox = $('<input type="text">').appendTo(selectionViewHeader);
        searchBox.searchbox({
            width: options.width - 10,
            prompt: '输入简拼或汉字检索',
            buttonIcon: 'icon-search',
            buttonAlign: 'right',
            onClickButton: function(index) {}
        });

        $(searchBox).siblings().find('input.searchbox-text').keyup(function() {
            if (event.keyCode === 13) {
                event.preventDefault();
                event.stopPropagation();
                var text = $(this).val();
                $(target).diagnosiseditbox('filter', text);
            }
        });

        $(searchBox).siblings().find('.searchbox-button').click(function() {
            var text = $(searchBox).siblings().find('input.searchbox-text').val();
            $(target).diagnosiseditbox('filter', text);
        })

        var diagnosiseditbox = $(target).data('diagnosiseditbox');
        diagnosiseditbox.editViewContainer = editViewContainer;
        diagnosiseditbox.selectionViewContainer = selectionViewContainer;

        $(editViewContainer).delegate('.tagbox-remove', 'click', function() {
            var data = $($(this).parent()).data('data');
            $(target).diagnosiseditbox('removeRow', data);
        });

        $(selectionViewContainer).delegate('.diageditbox-item', 'click', function() {
            var data = $(this).data('data');
            $(this).toggleClass('diageditbox-item-selected');

            if ($(this).hasClass('diageditbox-item-selected')) {
                $(target).diagnosiseditbox('addRow', data);
            } else {
                $(target).diagnosiseditbox('removeRow', data);
            }
        });
    }
})(jQuery);