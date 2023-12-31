//
/**
 * 个人偏好设置
 * @author yongyang 20181217
 */

(function(global, factory) {
    if (!global.PersonalSettingView) factory(global.PersonalSettingView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new PersonalSettingView(opt);
        return exports.instance;
    }

    exports.open = function() {
        if (exports.instance) exports.instance.open();
        else {
            $.messager.alert('错误', '药品项目属性界面未初始化', 'icon-error');
        }
    }

    exports.instance = null;

    /**
     * 个人偏好设置界面
     * @param {object} opt 
     */
    function PersonalSettingView(opt) {
        this.options = $.extend(opt, {
            width: 360,
            height: 290
        });
        this.saveHandler = opt.saveHandler;
        this.editform = editform;
        this.loaded = false;
        this.init();
    }

    PersonalSettingView.prototype = {
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

            this.initForm();
            this.dom.dialog({
                left: 300,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '个人偏好设置',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });
            this.initiated = true;
        },
        initForm: function() {
            this.editform.init(this.dom);
            this.editform.setDefaultValue();
        },
        /**
         * 加载数据
         */
        loadData: function(data) {
            this.data = data;
            this.editform.load(data);
            this.loaded = true;
        },
        /**
         * 加载选项
         * @param {*} dataList 
         */
        setComboDataSource: function(dataList) {
            this.editform.setComboDataSource(dataList);
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.editform.clear();
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
            if (this.data) this.editform.load(this.data);
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 保存
         */
        save: function() {
            if (!this.editform.validate()) return;
            var data = this.editform.toData();
            $.extend(data, {
                DataModule: session.ModuleID,
                UserID: session.UserID
            });
            if (this.saveHandler) {
                this.saveHandler(data);
                this.close();
            }
        }
    }

    var editform = {
        init: function(container) {
            var _this = this;

            this.dom = $('<form class="personalsettingview-form"></form>').appendTo(container);
            this.dom.form({});

            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.dom);

            var group = $('<div class="editview-f-group"></div>').appendTo(this.dom);
            var group_header = $('<div class="editview-f-group-header"><span class="header-text">开始监护时</span></div>').appendTo(group);
            //var row = $('<div class="editview-f-r" title="开始监护后自动加载科室设置的默认事件，如果您只需要自动加载自己设置的模板数据，请取消勾选此项"><label for="personalsettingview_AutoCreateEvent" class="label">自动生成默认事件：</label></div>').appendTo(group);
            //this.AutoCreateEvent = $('<input id="personalsettingview_AutoCreateEvent" type="checkbox" name="AutoCreateEvent">').appendTo(row);
            //this.AutoCreateEvent.checkbox({});

            var row = $('<div class="editview-f-r" title="开始监护后自动加载您预设好的此项模板，为空则不自动加载模板"><label for="personalsettingview_AutoApplyTemplate" class="label">自动应用模板：</label></div>').appendTo(group);
            this.AutoApplyTemplate = $('<input type="text" name="AutoApplyTemplate">').appendTo(row);
            this.AutoApplyTemplate.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 150
            });
        },
        load: function(data) {
            if (data && data.length > 0) {
                this.originalData = data[0];
                //this.AutoCreateEvent.checkbox('setValue', this.originalData.AutoCreateEvent === 'Y');
                this.AutoApplyTemplate.combobox('setValue', this.originalData.AutoApplyTemplate);
                this.RowId.val(this.originalData.RowId);
            }
        },
        setComboDataSource: function(dataList) {
            this.AutoApplyTemplate.combobox('loadData', dataList.templates || []);
        },
        setDefaultValue: function() {
            //this.AutoCreateEvent.checkbox('setValue', true);
            //$(this.AutoCreateEvent.parent()).addClass('checked');
        },
        clear: function() {
            //this.dom.form('clear');
        },
        validate: function() {
            return true;
        },
        toData: function() {
            return {
                RowId: this.RowId.val(),
               // AutoCreateEvent: this.AutoCreateEvent.prop('checked') ? 'Y' : 'N',
                AutoApplyTemplate: this.AutoApplyTemplate.combobox('getValue') || ''
            }
        }
    }
}));