function InOpRoom(opt) {
    this.options = $.extend({ width: 266, height: 127 }, opt);
    this.saveHandler = opt.saveHandler;
    this.init();
    //this.myfun();
}


InOpRoom.prototype = {
    init: function () {
        var _this = this;
        this.dom = $('<div></div>').appendTo('body');
        var buttons = $('<div></div>');
        var btn_save = $('<a href="#"></a>').linkbutton({
            text: '保存',
            iconCls: 'icon-w-save',
            onClick: function () {
                _this.save();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-w-close',
            onClick: function () {
                _this.close();
            }
        }).appendTo(buttons);

        this.initForm();

        this.dom.dialog({
            left: 502,
            top: 252,
            height: this.options.height,
            width: this.options.width,
            title: '入手术室时间',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function () { },
            onClose: function () {
                _this.clear();
            }
        });
    },
    // 增加自定义方法，用于双击事件，加载当前事件。
    myfun: function () {
        $(".combo-text").on("dblclick", function () {
            var date = new Date();
            var _this = $(this).parent().prev();

            if (_this.hasClass("hisui-datebox")) {
                var value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
                _this.datebox('setValue', value);
            } else if (_this.hasClass("hisui-datetimebox")) {
                var value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
                _this.datetimebox('setValue', value);
            }
        });

        $(".hisui-timespinner").dblclick(function () {
            var now = (new Date()).format("HH:mm");
            $(this).val(now);
        });
    },
    initForm: function () {
        this.form = $('<form></form>').appendTo(this.dom);
        this.form.form({});

        var timeRow = $('<div class="editview-f-r" style="margin:10px;"></div').appendTo(this.form);
        var label = $('<div class="form-title">开始时间</div>').appendTo(timeRow);
        // <input type="text" name="StartDT">
        //<input type="text" id="OpStartDT" class="hisui-datetimebox operdata" data-options="showSeconds:false">
        this.StartDT = $('<input type="text" name="StartDT" class="hisui-datetimebox" data-options="showSeconds:false">').appendTo(timeRow);
        this.StartDT.datetimebox({
            width: 180,
            label: label
        });

        // this.StartDT.datetimebox('initiateWheelListener');
        //this.StartDT.datetimebox('initiateKeyUpListener');
    },
    default: function () {
        this.StartDT.datetimebox('setValue', new Date().format("yyyy-MM-dd HH:mm"));
    },
    open: function () {
        this.dom.dialog('open');
    },
    close: function () {
        this.dom.dialog('close');
    },
    loadData: function (data) {
        if (data) {
            this.StartDT.datetimebox('setValue', data.startDT);
            this.dom.dialog('setTitle', data.title);
        } else {
            this.default();
        }
    },
    clear: function () {
        this.form.form('clear');
    },
    validate: function () {
        var _this = this;
        var startDateTime = this.StartDT.datetimebox("getValue");
        var startDate = startDateTime.substr(0, 10);
        var today = new Date().format("yyyy-MM-dd");
        if (startDate !== today) {
            $.messager.confirm('入手术室时间可能有误', '您输入的开始监护时间不是当天，是否继续操作<span style="color:red;">' + startDateTime, function (confirmed) {
                if (confirmed) {
                    if (_this.saveHandler)
                        _this.saveHandler({
                            startDT: startDateTime

                        });
                } else {
                    _this.StartDT.datetimebox('focus');
                }
            });
            return false;
        }
        return true;
    },
    save: function () {
        if (!this.validate()) return;
        if (this.saveHandler)
            this.saveHandler({
                startDT: this.StartDT.datetimebox("getValue")
            });
    }
}
