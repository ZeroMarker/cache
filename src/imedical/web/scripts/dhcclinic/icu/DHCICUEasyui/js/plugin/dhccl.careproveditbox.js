/**
 * 医护人员多选框
 */
(function($) {
    $.fn.careprovtagbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.careprovtagbox.methods[options];
            if (method) return method($(this), param);
        } else {
            return this.each(function() {
                var state = $(this).data("careprovtagbox");
                if (!state) {
                    $(this).data("careprovtagbox", {
                        options: $.extend({}, $.fn.careprovtagbox.defaults, options),
                        selectedRows: [],
                        data: []
                    })
                    state = $(this).data("careprovtagbox");

                    create(this);
                    request(this);
                }
            });
        }
    }

    $.fn.careprovtagbox.methods = {
        options: function(target) {
            return $(target).data('careprovtagbox').options;
        },
        panel: function(target) {
            return $(target).data('careprovtagbox').panel;
        },
        /**
         * 获取值，以,分割
         * @param {*} target 
         */
        getValue: function(target) {
            var values = $(target).careprovtagbox('getValues');
            return values.join(',');
        },
        /**
         * 获取显示值，以,分割
         * @param {*} target 
         */
        getText: function(target) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var selectedRows = careprovtagbox.selectedRows;
            var length = selectedRows.length;
            var values = [];

            for (var i = 0; i < length; i++) {
                values.push(selectedRows[i][options.textField]);
            }

            return values.join(',');
        },
        /**
         * 设置值，以,分割
         * @param {*} target 
         * @param {String} value
         */
        setValue: function(target, value) {
            var values = value.split(',');
            $(target).careprovtagbox('setValues', values);
            return $(target);
        },
        /**
         * 获取值，数组
         * @param {*} target 
         * @return {Array<String>}
         */
        getValues: function(target) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var selectedRows = careprovtagbox.selectedRows;
            var length = selectedRows.length;
            var values = [];

            for (var i = 0; i < length; i++) {
                values.push(selectedRows[i][options.valueField]);
            }

            return values;
        },
        /**
         * 设置值，数组
         * @param {*} target 
         * @param {Array<String>} values
         */
        setValues: function(target, values) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var selectedRows = [];
            var length = values.length;
            var row;
            for (var i = 0; i < length; i++) {
                row = $(target).careprovtagbox('getRow', values[i]);
                if (row) selectedRows.push(row);
            }
            careprovtagbox.selectedRows = selectedRows;
            options.editView.render(target, selectedRows);
        },
        loadData: function(target, data) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            careprovtagbox.data = data;
            careprovtagbox.groups = groupingData(target, data);
            options.selectionView.render(target, careprovtagbox.groups);
            options.selectionView.selectRows(target);
        },
        reload: function(target) {
            request(target);
        },
        filter: function(target, text) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var groups = careprovtagbox.groups || [];
            var param = options.queryParams;
            var filterFields = options.filterFields;
            text = text || '';
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
        /**
         * 获取行
         * @param {String} idOrDesc 
         */
        getRow: function(target, idOrDesc) {
            if (!idOrDesc) return null;
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var data = careprovtagbox.data;
            var length = data.length;
            var row;
            for (var i = 0; i < length; i++) {
                row = data[i];
                if (idOrDesc == row[options.valueField] || idOrDesc == row[options.textField])
                    return row;
            }

            return null;
        },
        addRow: function(target, row) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var selectedRows = careprovtagbox.selectedRows;

            selectedRows.push(row);
            options.editView.render(target, selectedRows);

            if (options.onSelect) {
                options.onSelect.call(target, row);
            }
            if (options.onChange) {
                options.onChange.call(target, row, selectedRows);
            }
        },
        removeRow: function(target, row) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var options = careprovtagbox.options;
            var selectedRows = careprovtagbox.selectedRows;

            var index = selectedRows.indexOf(row);
            if (index > -1) selectedRows.splice(index, 1);
            options.editView.render(target, selectedRows);
            if (row.target) {
                row.target.removeClass('careproveditbox-item-selected');
            }

            if (options.onUnselect) {
                options.onUnselect.call(target, row);
            }
            if (options.onChange) {
                options.onChange.call(target, row, selectedRows);
            }
        },
        openSelectionView: function(target) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var selectionContainer = careprovtagbox.selectionContainer;
            selectionContainer.open();
        },
        destory: function(target) {
            $(target).parent().empty();
        },
        close: function(target) {
            var opts = $(target).careprovtagbox('options');
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    }

    var editView = {
        render: function(target, data) {
            var options = $(target).data('careprovtagbox').options;
            var container = $(target).data('careprovtagbox').editViewContainer;
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
            var container = $(target).data('careprovtagbox').selectionViewContainer;
            container.empty();

            var length = this.groups.length;
            var element, group;
            for (var i = 0; i < length; i++) {
                group = this.groups[i];
                element = $('<div class="combobox-group careproveditbox-group"></div>').appendTo(container);
                groupview.render(target, element, group);
                data = data.concat(group.items);
            }

            this.data = data;
        },
        selectRows: function(target) {
            var careprovtagbox = $(target).data('careprovtagbox');
            var selectedRows = careprovtagbox.selectedRows;
            var options = $(target).data('careprovtagbox').options;
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
        var careprovtagbox = $(target).data('careprovtagbox');
        var options = careprovtagbox.options;
        var param = options.queryParams;
        if (param && options.url){
            $.ajax({
                url: options.url,
                async: true,
                data: param,
                type: "post",
                dataType: 'json',
                success: function(data) {
                    if (data) {
                        $(target).careprovtagbox('loadData', data);
                    }
                }
            });
        }

        if (options.data && options.data.length>0){
            $(target).careprovtagbox('loadData',options.data);
        }
    }

    function groupingData(target, data) {
        var groupDic = [];
        var groups = [];
        var options = $(target).data('careprovtagbox').options;
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
            var options = $(target).data('careprovtagbox').options;

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

    $.fn.careprovtagbox.defaults = {
        width: 180,
        height: 30,
        editView: editView,
        selectionView: selectionView
    }

    function selectionContainer(target, relatedContainer) {
        this.relatedContainer = relatedContainer;
        var options = $(target).careprovtagbox('options');
        this.width = options.width;
        this.init(target);
    }

    selectionContainer.prototype = {
        constructor: selectionContainer,
        init: function(target) {
            this.dom = $('<div class="panel combo-p" style="position:absolute;z-index:100006;min-height:28px;display:none;position:absolute;"></div>').appendTo('body');
            this.dom.width(this.width);
            this.dom.panel({ height: 'auto' });
            this.dom.on('mouseleave',function(){
                $(this).hide();
            });

            var selectionViewHeader = $('<div style="padding:5px;"></div>').appendTo(this.dom);
            var selectionViewContainer = $('<div style="max-height:150px;overflow-x:hidden;overflow-y:auto;"></div>').appendTo(this.dom);

            var searchBox = $('<input type="text">').appendTo(selectionViewHeader);
            searchBox.searchbox({
                width: this.width - 10,
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
                $(target).careprovtagbox('filter', text);
            });

            $(searchBox).siblings().find('.searchbox-button').click(function() {
                var text = $(searchBox).find('input.searchbox-text').val();
                $(target).careprovtagbox('filter', text);
            });

            var careprovtagbox = $(target).data('careprovtagbox');
            careprovtagbox.selectionViewContainer = selectionViewContainer;

            $(selectionViewContainer).delegate('.careproveditbox-item', 'click', function() {
                var data = $(this).data('data');
                $(this).toggleClass('careproveditbox-item-selected');

                if ($(this).hasClass('careproveditbox-item-selected')) {
                    $(target).careprovtagbox('addRow', data);
                } else {
                    $(target).careprovtagbox('removeRow', data);
                }

                $(target).careprovtagbox('openSelectionView');
            });

            return this.dom;
        },
        visible: function() {
            return this.dom.is(':hidden');
        },
        open: function() {
            var offset = this.relatedContainer.offset();
            var height = this.relatedContainer.height();
            this.dom.css({
                top: offset.top + height,
                left: offset.left
            });
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        }
    }

    function create(target) {
        $(target).hide();
        var targetContainer = $('<span class="dhccl-careproveditbox combo" style="display:inline-block;"></span>');
        $(target).after(targetContainer);

        var options = $(target).careprovtagbox('options');
        targetContainer.width(options.width - 2);

        var editViewContainer = $('<span style="background-color:#fff;display:inline-block;min-height:25px;padding-bottom:3px;"></span>').appendTo(targetContainer);
        editViewContainer.width(options.width - 32);
        editViewContainer.height('auto');

        var arrow = $('<span><span class="combo-arrow" style="height: 28px;"></span></span>').appendTo(targetContainer);
        arrow.click(function() {
            var careprovtagbox = $(target).data('careprovtagbox');
            var selectionContainer = careprovtagbox.selectionContainer;
            if (selectionContainer.visible()) {
                selectionContainer.open();
            } else {
                selectionContainer.close();
            }
        });

        var careprovtagbox = $(target).data('careprovtagbox');
        careprovtagbox.editViewContainer = editViewContainer;

        $(editViewContainer).delegate('.tagbox-remove', 'click', function() {
            var data = $($(this).parent()).data('data');
            $(target).careprovtagbox('removeRow', data);
            var careprovtagbox = $(target).data('careprovtagbox');
            var selectionContainer = careprovtagbox.selectionContainer;
            if (!selectionContainer.visible()) {
                selectionContainer.open();
            }
        });

        careprovtagbox.selectionContainer = new selectionContainer(target, targetContainer);
    }
})(jQuery);