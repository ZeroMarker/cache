/**
 * 医护人员多选框
 */
(function($) {
    $.fn.careproveditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.careproveditbox.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("careproveditbox");
            if (!state) {
                $(this).data("careproveditbox", {
                    options: $.extend({}, $.fn.careproveditbox.defaults, options),
                    selectedRows: [],
                    data: []
                })
                state = $(this).data("careproveditbox");

                create(this);
                request(this);
            }
        }
    }

    $.fn.careproveditbox.methods = {
        dataItem: function(target) {
            return $(target).data('DataItem');
        },
        options: function(target) {
            return $(target).data('careproveditbox').options;
        },
        panel: function(target) {
            return $(target).data('careproveditbox').panel;
        },
        setDHCData: function(target, data) {
            var dataItem = $(target).data('DataItem');
            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;
            $(target).data('DHCData', data);
            var idStr = data[dataItem.valueField] || '';
            var descStr = data[dataItem.textField] || '';

            var idArr = idStr.split(',');
            var descArr = descStr.split(',');
            var selectedRows = [];
            if (!((idStr === '') && (descStr === ''))) {
                var length = idArr.length;
                for (var i = 0; i < length; i++) {
                    selectedRows.push({
                        RowId: idArr[i],
                        Description: descArr[i] || ''
                    });
                }
            }
            careproveditbox.selectedRows = selectedRows;
            options.editView.render(target, selectedRows);
        },
        getDHCData: function(target) {
            var dataItem = $(target).data('DataItem');
            var careproveditbox = $(target).data('careproveditbox');
            var idArr = [];
            var descArr = [];

            var selectedRows = careproveditbox.selectedRows;
            var length = selectedRows.length;

            for (var i = 0; i < length; i++) {
                idArr.push(selectedRows[i].RowId);
                descArr.push(selectedRows[i].Description)
            }

            var DHCData = {};
            DHCData[dataItem.valueField] = idArr.join(',');
            DHCData[dataItem.textField] = descArr.join(',');

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
            var newDHCData = $(target).careproveditbox('getDHCData');

            return !((oldDHCData[dataItem.valueField] === newDHCData[dataItem.valueField]) &&
                (oldDHCData[dataItem.textField] === newDHCData[dataItem.textField]))
        },
        save: function(target, param) {
            var oldDHCData = $(target).data('DHCData');
            var newDHCData = $(target).careproveditbox('getDHCData');
            var dataItem = $(target).data('DataItem');

            var isChanged = !((oldDHCData[dataItem.valueField] === newDHCData[dataItem.valueField]) &&
                (oldDHCData[dataItem.textField] === newDHCData[dataItem.textField]));

            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;
            var selectedRows = careproveditbox.selectedRows;

            var length = selectedRows.length;
            var savingArr = [];
            for (var i = 0; i < length; i++) {
                savingArr.push(selectedRows[i].RowId);
            }

            var data = {};
            data[dataItem.valueField] = savingArr.join(',');
            for (var field in newDHCData) {
                if (field != dataItem.valueField && field != dataItem.textField) {
                    data[field] = newDHCData[field];
                }
            }

            var savingData = $.extend(data, {
                ClassName: dataItem.className,
                RowId: oldDHCData.RowId
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
            }
        },
        loadData: function(target, data) {
            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;
            careproveditbox.data = data;
            careproveditbox.groups = groupingData(target, data);
            options.selectionView.render(target, careproveditbox.groups);
            options.selectionView.selectRows(target);
        },
        reload: function(target) {
            request(target);
        },
        filter: function(target, text) {
            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;
            var groups = careproveditbox.groups || [];
            var param = options.queryParams;
            var filterFields = options.filterFields;
            var upperText = text.toUpperCase();

            var length = groups.length;
            var group, itemLength, item, ifMatch,
                ifGroupMatch, fieldLength, field;
            for (var i = 0; i < length; i++) {
                group = groups[i];
                itemLength = group.items.length;
                ifGroupMatch = false;
                for (var j = 0; j < itemLength; j++) {
                    item = group.items[j];
                    ifMatch = false;
                    fieldLength = filterFields.length;
                    for (var k = 0; k < fieldLength; k++) {
                        field = filterFields[k];
                        if (item[field].indexOf(text) > -1 || item[field].indexOf(upperText) > -1) {
                            ifMatch = true;
                            break;
                        }
                    }
                    if (ifMatch) {
                        item.target.show();
                    } else {
                        item.target.hide();
                    }
                    ifGroupMatch = ifGroupMatch || ifMatch;
                }

                if (ifGroupMatch) {
                    group.target.show();
                } else {
                    group.target.hide();
                }
            }
        },
        getRows: function(target) {
            var careproveditbox = $(target).data('careproveditbox');
            return careproveditbox.selectedRows
        },
        addRow: function(target, row) {
            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;

            if (!options.multiple) {
                $(target).careproveditbox('removeAll');
            }

            var selectedRows = careproveditbox.selectedRows;

            selectedRows.push(row);
            options.editView.render(target, selectedRows);
        },
        removeAll: function(target) {
            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;
            var selectedRows = careproveditbox.selectedRows;

            var length = selectedRows.length;
            var row;
            for (var i = 0; i < length; i++) {
                row = selectedRows[i];
                $(target).careproveditbox('removeRow', row);
            }
        },
        removeRow: function(target, row) {
            var careproveditbox = $(target).data('careproveditbox');
            var options = careproveditbox.options;
            var selectedRows = careproveditbox.selectedRows;

            var index = selectedRows.indexOf(row);
            if (index > -1) selectedRows.splice(index, 1);
            options.editView.render(target, selectedRows);
            if (row.target) {
                row.target.removeClass('careproveditbox-item-selected');
            }
        },
        destory: function(target) {
            $(target).parent().empty();
        },
        close: function(target) {
            var opts = $(target).careproveditbox('options');
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    }

    var editView = {
        render: function(target, data) {
            var options = $(target).data('careproveditbox').options;
            var container = $(target).data('careproveditbox').editViewContainer;
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
        render: function(target, groups) {
            this.groups = groups;
            var data = [];
            var container = $(target).data('careproveditbox').selectionViewContainer;
            container.empty();

            var length = this.groups.length;
            var element, group;
            for (var i = 0; i < length; i++) {
                group = this.groups[i];
                element = $('<div class="combobox-group careproveditbox-group"></div>').appendTo(container);
                groupview.render(target, element, group);
                data = data.concat(group.items);
            }

            var userDefinedContainer = $('<div style="margin:5px;"></div>').appendTo(container);
            var addButton = $('<div class="careproveditbox-button careproveditbox-add">+</div>').appendTo(userDefinedContainer);
            var textInput = $('<div class="careproveditbox-textinput" style="display:none;"></div>').appendTo(userDefinedContainer);
            $('<input class="textbox">').appendTo(textInput);
            $('<span class="careproveditbox-button careproveditbox-ok">√</span>').appendTo(textInput);

            this.data = data;
        },
        selectRows: function(target) {
            var careproveditbox = $(target).data('careproveditbox');
            var selectedRows = careproveditbox.selectedRows;
            var options = $(target).data('careproveditbox').options;
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
                    this.data[i].target.addClass('careproveditbox-item-selected');
                }
            }
        }
    }

    function request(target) {
        var careproveditbox = $(target).data('careproveditbox');
        var options = careproveditbox.options;
        var param = options.queryParams;
        $.ajax({
            url: options.url,
            async: true,
            data: param,
            type: "post",
            dataType: 'json',
            success: function(data) {
                if (data) {
                    $(target).careproveditbox('loadData', data);
                }
            }
        });
    }

    function groupingData(target, data) {
        var groupDic = [];
        var groups = [];
        var options = $(target).data('careproveditbox').options;
        var groupField = options.groupField;

        var length = data.length;
        var row, index;
        for (var i = 0; i < length; i++) {
            row = data[i];
            index = groupDic.indexOf(row[groupField]);
            if (index > -1) {
                groups[index].items.push(row);
            } else {
                groupDic.push(row[groupField]);
                groups.push({
                    key: row[groupField],
                    items: [row]
                })
            }
        }
        return groups;
    }

    var groupview = {
        render: function(target, container, group) {
            container.data('data', group);
            group.target = container;
            var options = $(target).data('careproveditbox').options;

            $('<div class="combobox-group-header careproveditbox-group-header"></div>')
                .append('<span class="header-text">' + group.key + '</span>')
                .appendTo(container);
            var itemsContainer = $('<div class="combobox-group-items careproveditbox-group-items"></div>')
                .appendTo(container);
            var length = group.items.length;
            for (var i = 0; i < length; i++) {
                var element = $('<div class="combobox-item careproveditbox-item"></div>')
                    .text(group.items[i][options.textField])
                    .attr('data-value', group.items[i][options.valueField])
                    .data('data', group.items[i])
                    .appendTo(itemsContainer);
                group.items[i].target = element;
            }
        }
    }

    $.fn.careproveditbox.defaults = {
        width: 200,
        height: 30,
        editView: editView,
        selectionView: selectionView
    }

    function create(target) {
        $(target).hide();
        var editViewContainer = $('<div style="min-height:30px;"></div>').appendTo($(target).parent());
        var selectionContainer = $('<div class="background-color:#fff;"></div>').appendTo($(target).parent());

        editViewContainer.data('relatedview', selectionContainer);

        selectionContainer.on('mouseleave', function() {
            $(this).hide();
        });
        editViewContainer.on('mouseenter', function() {
            var view = $(this).data('relatedview');
            if (view) view.show();
        });

        var options = $(target).careproveditbox('options');
        editViewContainer.width(options.width);
        editViewContainer.panel({ height: 'auto' });

        var viewwidth = 200;
        selectionContainer.width(viewwidth);
        selectionContainer.panel({ height: 'auto' });

        var selectionViewHeader = $('<div style="padding:5px;"></div>').appendTo(selectionContainer);
        var selectionViewContainer = $('<div style="max-height:150px;overflow-x:hidden;overflow-y:auto;"></div>').appendTo(selectionContainer);

        var searchBox = $('<input type="text">').appendTo(selectionViewHeader);
        searchBox.searchbox({
            width: viewwidth - 10,
            prompt: '输入简拼或汉字检索',
            buttonIcon: 'icon-search',
            buttonAlign: 'right',
            onClickButton: function(index) {

            }
        });

        $(searchBox).siblings().find('input.searchbox-text').keyup(function() {
            event.preventDefault();
            event.stopPropagation();
            var text = $(this).val();
            $(target).careproveditbox('filter', text);
        });

        $(searchBox).siblings().find('.searchbox-button').click(function() {
            var text = $(searchBox).find('input.searchbox-text').val();
            $(target).careproveditbox('filter', text);
        })

        var careproveditbox = $(target).data('careproveditbox');
        careproveditbox.editViewContainer = editViewContainer;
        careproveditbox.selectionViewContainer = selectionViewContainer;

        $(editViewContainer).delegate('.tagbox-remove', 'click', function() {
            var data = $($(this).parent()).data('data');
            $(target).careproveditbox('removeRow', data);
        });

        $(selectionViewContainer).delegate('.careproveditbox-item', 'click', function() {
            var data = $(this).data('data');
            $(this).toggleClass('careproveditbox-item-selected');

            if ($(this).hasClass('careproveditbox-item-selected')) {
                $(target).careproveditbox('addRow', data);
            } else {
                $(target).careproveditbox('removeRow', data);
            }
        });

        $(selectionViewContainer).delegate('.careproveditbox-add', 'click', function() {
            var textInput = $(this).siblings('.careproveditbox-textinput');
            $(this).hide();
            textInput.show();
        });

        $(selectionViewContainer).delegate('.careproveditbox-textinput input', 'keyup', function(e) {
            var value = $(this).val();
            if (e.keyCode == "13" && value) {
                var textInput = $(this).parent();
                e.preventDefault();
                e.stopPropagation();

                var options = $(target).data('careproveditbox').options;

                var data = {};
                data[options.textField] = value;
                data[options.valueField] = value;

                $(target).careproveditbox('addRow', data);

                $(this).val('');
                var addBtn = textInput.siblings('.careproveditbox-add');
                textInput.hide();
                addBtn.show();
            }
        });

        $(selectionViewContainer).delegate('.careproveditbox-ok', 'click', function() {
            var textInput = $(this).parent();
            var value = textInput.find('input').val();
            if (value) {
                var options = $(target).data('careproveditbox').options;

                var data = {};
                data[options.textField] = value;
                data[options.valueField] = value;

                $(target).careproveditbox('addRow', data);

                textInput.find('input').val('');
                var addBtn = textInput.siblings('.careproveditbox-add');
                textInput.hide();
                addBtn.show();
            }
        });
    }
})(jQuery);