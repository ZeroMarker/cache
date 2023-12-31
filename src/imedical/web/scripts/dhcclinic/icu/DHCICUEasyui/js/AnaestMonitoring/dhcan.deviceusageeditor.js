/**
 * 使用设备编辑
 * @author yongyang 20180510
 */

(function(global, factory) {
    if (!global.DeviceUsageEditor) factory(global.DeviceUsageEditor = {});
}(this, function(exports) {

    exports.init = function(opt) {
        var view = new DeviceUsageEditor(opt);
        exports.instance = view;
        return view;
    }

    var deviceIdPrefix = 'device_usage_editor_d_i_';

    function DeviceUsageEditor(opt) {
        this.options = $.extend({ width: 400, height: 300 }, opt);
        this.saveHandler = opt.saveHandler;
        this.removedUsages = [];
        this.currentUsages = [];
        this.changedUsages = [];
        this.usagesView = usagesView;
        this.groupsView = groupsView;
        this.editView = editView;
        this.init();
    }

    DeviceUsageEditor.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 300,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '更换使用设备',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.dom.delegate('.device-usage-editor-g-i', 'click', function() {
                var e_this = $(this);
                var group = $(this).data('group');
                var currentDevice = $(this).data('data');
                var cancelled = false;
                group.target.find('.device-selected').each(function(index, e) {
                    cancelled = true;
                    var usage = $(this).data('usage');
                    var device = $(this).data('data');
                    if (currentDevice === device) {
                        $.messager.confirm('删除设备停止记录', '您确定需要删除设备' + usage.EquipDesc + '的使用记录吗？', function(confirmed) {
                            if (confirmed) {
                                _this.removeUsage(usage);
                                $(e_this).removeClass('device-selected');
                                $(e_this).data('usage', null);
                            }
                        });
                    } else {
                        $.messager.confirm('设备停止使用', '您确定需要停止设备' + usage.EquipDesc + '的使用吗？', function(confirmed) {
                            if (confirmed) {
                                _this.editView.render(usage);
                                _this.editView.defaultEndDT();
                                _this.editView.open(function(data) {
                                    $(e).removeClass('device-selected');
                                    $(e).data('usage', null);;
                                    _this.createUsage(e_this);
                                });
                            }
                        });
                    }
                });

                if (!cancelled) {
                    _this.createUsage(e_this);
                }
            });

            this.container = $(this.dom.find('.dialog-content'));
            this.usageContainer = $('<div class="device-usage-view"></div>').appendTo(this.container);
            this.groupContainer = $('<div></div>').appendTo(this.container);

            this.editView.init(function(usage) {
                _this.editUsage(usage);
                singleUsageView.render(usage.target, usage);
                if (usage.EndDate === '') {
                    usage.selectionTarget.removeClass('device-occupied')
                        .addClass('device-selected');
                }
            });

            this.usageContainer.delegate('a.device-usage-btn-edit', 'click', function() {
                var usage = $($(this).parent()).data('data');
                _this.editView.render(usage);
                _this.editView.open();
            });

            this.usageContainer.delegate('a.device-usage-btn-remove', 'click', function() {
                var usage = $($(this).parent()).data('data');
                $.messager.confirm('删除设备停止记录', '您确定需要删除设备' + usage.EquipDesc + '的使用记录吗？', function(confirmed) {
                    if (confirmed) {
                        _this.removeUsage(usage);
                        $(usage.selectionTarget).removeClass('device-selected');
                        $(usage.selectionTarget).data('usage', null);
                    }
                });
            });
        },
        loadData: function(data) {
            this.data = data;
            this.groups = groupingDevices(data);
            this.groupsView.render(this.groupContainer, this.groups);
            this.selectCurrentUsage();
        },
        setCurrentUsage: function(currentUsages) {
            this.currentUsages = currentUsages;
            this.usagesView.render(this.usageContainer, this.currentUsages);
            this.selectCurrentUsage();
        },
        setDefaultDT: function(datetime) {
            this.defaultDT = datetime;
        },
        selectCurrentUsage: function() {
            if (this.currentUsages) {
                var length = this.currentUsages.length;
                for (var i = 0; i < length; i++) {
                    var usage = this.currentUsages[i];
                    var foundDevice = this.dom.find('#' + deviceIdPrefix + usage.Equip);
                    if (usage.EndDate === '') {
                        foundDevice.removeClass('device-occupied')
                            .addClass('device-selected');
                    }
                    foundDevice.data('usage', usage);
                    usage.selectionTarget = foundDevice;
                }
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        createUsage: function(e) {
            $(e).addClass('device-selected');
            var group = $(e).data('group');
            var currentDevice = $(e).data('data');
            var lastEndDT = new Date().tryParse(this.defaultDT);
            var length = this.currentUsages.length;
            for (var i = 0; i < length; i++) {
                var usage = this.currentUsages[i];
                if (usage.EquipType === group.key) {
                    if (usage.EndDate != '') {
                        var endDT = new Date().tryParse(usage.EndDate + ' ' + usage.EndTime);
                        if (lastEndDT < endDT) lastEndDT = endDT;
                    }
                }
            }

            var startDT = lastEndDT.format(constant.dateTimeFormat);
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }

            var usage = {
                Equip: currentDevice.RowId,
                EquipDesc: currentDevice.EquipDesc,
                EquipType: currentDevice.EquipType,
                EquipTypeDesc: currentDevice.EquipTypeDesc,
                StartDate: startDate,
                StartTime: startTime,
                StartDT: startDT,
                EndDate: '',
                EndTime: '',
                EndDT: ''
            }
            $(e).data('usage', usage);
            usage.selectionTarget = $(e);
            this.addUsage(usage);
        },
        removeUsage: function(usage) {
            usage.isRemoved = true;
            this.removedUsages.push(usage);
            var index = this.changedUsages.indexOf(usage);
            if (index > -1) this.changedUsages.splice(index, 1);
            var index = this.currentUsages.indexOf(usage);
            if (index > -1) this.currentUsages.splice(index, 1);
            this.usagesView.render(this.usageContainer, this.currentUsages);
        },
        editUsage: function(usage) {
            if (this.changedUsages.indexOf(usage) < 0)
                this.changedUsages.push(usage);
        },
        addUsage: function(usage) {
            this.changedUsages.push(usage);
            this.currentUsages.push(usage);
            this.usagesView.render(this.usageContainer, this.currentUsages);
        },
        save: function() {
            var deviceUsages = [];
            deviceUsages = deviceUsages.concat(this.changedUsages);

            var length = this.removedUsages.length;
            for (var i = 0; i < length; i++) {
                var usage = this.removedUsages[i];
                if (usage.RowId) deviceUsages.push($.extend(usage, { isRemoved: 'Y' }));
            }
            var length = deviceUsages.length;
            var savingDatas = [],
                row;
            for (var i = 0; i < length; i++) {
                row = deviceUsages[i];
                savingDatas.push({
                    RowId: row.RowId || '',
                    Equip: row.Equip || '',
                    EquipDesc: row.EquipDesc || '',
                    EquipType: row.EquipType || '',
                    EquipTypeDesc: row.EquipTypeDesc || '',
                    StartDate: row.StartDate || '',
                    StartTime: row.StartTime || '',
                    StartDT: row.StartDT || '',
                    EndDate: row.EndDate || '',
                    EndTime: row.EndTime || '',
                    EndDT: row.EndDT || '',
                    isRemoved: row.isRemoved || ''
                });
            }

            if (this.saveHandler) this.saveHandler.call(this, savingDatas);
            this.close();
        },
        clear: function() {
            this.usageContainer.empty();
            this.groupContainer.empty();
            this.changedUsages = [];
            this.currentUsages = [];
            this.removedUsages = [];
        }
    }

    /**
     * 设备分组
     * @param {Array<data.Device>} devices 
     */
    function groupingDevices(devices) {
        var result = [];
        var groups = [];
        var currentGroup = null;
        $.each(devices, function(index, device) {
            var groupIndex = groups.indexOf(device.EquipType);
            currentGroup = null;
            if (groupIndex < 0) {
                groups.push(device.EquipType);
                currentGroup = {
                    key: device.EquipType,
                    desc: device.EquipTypeDesc,
                    items: []
                };
                result.push(currentGroup);
            } else {
                currentGroup = result[groupIndex];
            }

            currentGroup.items.push(device);
        });

        return result;
    };

    var editView = {
        init: function(callback) {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.callback = callback;
            this.initForm();

            var buttons = $('<div></div>');
            var btn_confirm = $('<a href="#"></a>').linkbutton({
                text: '确定',
                iconCls: 'icon-ok',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 300,
                top: 50,
                height: 240,
                width: 300,
                title: '修改设备使用记录',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
        },
        initForm: function() {
            this.form = $('<form></form>').appendTo(this.dom);
            this.form.form({});

            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);

            var row = $('<div class="editview-f-r"><label class="label">设备：</label></div>').appendTo(this.form);
            this.EquipDesc = $('<input type="text" name="EquipDesc" readonly style="width:177px;">').appendTo(row);
            this.EquipDesc.validatebox({
                width: 180,
                readonly: true,
                novalidate: true
            });

            var row = $('<div class="editview-f-r"><label class="label">开始时间：</label></div>').appendTo(this.form);
            this.StartDT = $('<input type="text" name="StartDT">').appendTo(row);
            this.StartDT.datetimebox({
                width: 180
            });

            var row = $('<div class="editview-f-r"><label class="label">停用时间：</label></div>').appendTo(this.form);
            this.EndDT = $('<input type="text" name="EndDT">').appendTo(row);
            this.EndDT.datetimebox({
                width: 180
            });
        },
        defaultEndDT: function() {
            this.EndDT.datetimebox("setValue", new Date().format(constant.dateTimeFormat));
        },
        render: function(usage) {
            this.data = usage;
            this.form.form('load', usage)
        },
        toData: function() {
            var startDT = this.StartDT.datetimebox("getValue");
            var arr = startDT.split(' ');
            var startDate = startTime = '';
            if (arr.length > 1) {
                startDate = arr[0];
                startTime = arr[1];
            }
            var endDT = this.EndDT.datetimebox("getValue");
            var arr = endDT.split(' ');
            var endDate = endTime = '';
            if (arr.length > 1) {
                endDate = arr[0];
                endTime = arr[1];
            }

            return $.extend(this.data, {
                StartDate: startDate,
                StartTime: startTime,
                StartDT: startDT,
                EndDate: endDate,
                EndTime: endTime,
                EndDT: endDT
            });
        },
        save: function() {
            var data = this.toData();
            if (this.callback) this.callback(data);
            if (this.onSave) this.onSave();
        },
        open: function(onSave) {
            this.onSave = onSave;
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.form.form('clear');
        }
    }

    var singleUsageView = {
        render: function(container, usage) {
            container.empty();
            container.data('data', usage);
            usage.target = container;
            $('<a href="javascript:;" title="修改此条设备使用记录" class="device-usage-view-button device-usage-btn-edit"></a>')
                .append('<span class="icon icon-edit"></span>')
                .appendTo(container);
            $('<a href="javascript:;" title="删除此条设备使用记录" class="device-usage-view-button device-usage-btn-remove"></a>')
                .append('<span class="icon icon-remove"></span>')
                .appendTo(container);
            container.append('<span>' + usage.EquipTypeDesc + '</span>')
                .append('<span>' + usage.EquipDesc + '</span>')
                .append('<span class="device-usage-time">' + usage.StartDT + '~' + usage.EndTime + '</span>')
        }
    }

    var usagesView = {
        render: function(container, usages) {
            container.empty();
            $.each(usages, function(index, usage) {
                var dom = $('<div class="device-usage-view-i"></div>').appendTo(container);
                singleUsageView.render(dom, usage);
            });
        }
    }

    var groupsView = {
        render: function(container, groups) {
            var groupRender = groupView.render;
            $.each(groups, function(index, group) {
                var groupDom = $('<div class="device-usage-editor-group"></div>').appendTo(container);
                groupRender.call(this, groupDom, group);
            })
        }
    };

    var groupView = {
        render: function(container, group) {
            group.target = container;
            var header = $('<span></span>')
                .text(group.desc)
                .appendTo($('<div class="device-usage-editor-g-header"></div>').appendTo(container));
            var deviceContainer = $('<div class="device-usage-editor-g-container"></div>').appendTo(container);
            var deviceRender = deviceView.render;
            var length = group.items.length;
            var device = null;
            for (var i = 0; i < length; i++) {
                device = group.items[i];
                var dom = $('<a href="#" class="device-usage-editor-g-i"></a>').appendTo(container);
                dom.data('group', group);
                deviceRender.call(this, dom, device);
            }
        }
    };

    var deviceView = {
        render: function(container, device) {
            container.attr('id', deviceIdPrefix + device.RowId);
            //$('<span class="badge"></span>').text(device.EquipCode).appendTo(container);
            $('<span></span>').text(device.EquipDesc).appendTo(container);
            if (device.Occupied) {
                container.addClass('device-occupied');
                container.attr('title', '此设备正在' + device.CurrentLocation + '运行!');
            }
            container.data('data', device);
            device.target = container;
        }
    };
}))