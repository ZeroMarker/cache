//
/**
 * 麻醉医生编辑界面
 * @param {object} options - 初始化对象 or 方法名
 * @param {object} param - 方法参数
 * @returns {object} 初始化之后的返回对象 or 方法执行结果
 * @author yongyang 20171114
 */
(function($) {
    $.fn.anesthetisteditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.anesthetisteditbox.methods[options];
            if (method) return method(this, param);
        } else {
            var state = $(this).data("anesthetisteditbox");
            if (state) {
                $.extend(state.options, options)
            } else {
                $(this).data("anesthetisteditbox", {
                    options: $.extend({}, $.fn.anesthetisteditbox.defaults, options),
                    data: []
                });
            }
            _initiate(this);
        }
    };

    $.fn.anesthetisteditbox.methods = {
        options: function(target) {
            return $(target).data("anesthetisteditbox").options;
        },
        form: function(target) {
            return $(target).data("form");
        },
        dataItem: function(target) {
            return $(target).data("DataItem");
        },
        setDHCData: function(target, data) {
            $(target).data("DHCData", data);
            var dataItem = $(target).data("DataItem");
            var form = $(target).anesthetisteditbox("form");
            $(form).form("load", data);
            $(target).val(data[dataItem.code] || "");
        },
        getDHCData: function(target) {
            var form = $(target).anesthetisteditbox("form");
            setFormReady(target);
            var data = $(form).serializeJson();

            // 多选的项目，serializeJson后不会包含全部值
            // 是因为存储值的也是input，其name和初始化的input的name一样
            // 多选的项目对应值有多个input
            var iAnaAssistant = $(form).find("input#anesthetisteditbox-assistant");
            data.AnaAssistant = $(iAnaAssistant).val();

            return data;
        },
        destory: function(target) {
            //$("#anesthetisteditbox-supervisor,#anesthetisteditbox-doctor,#anesthetisteditbox-assistant").combobox("destory");
        },
        save: function(target, param) {
            var opts = $(target).anesthetisteditbox("options");
            var dataItem = $(target).anesthetisteditbox("dataItem");
            var DHCData = $(target).anesthetisteditbox("getDHCData");
            var shift = $(target).data('shift');
            var form = $(target).data('form');

            if (!form.form('validate')) {
                return false;
            }

            var savingData = $.extend({}, DHCData, {
                ClassName: dataItem.className
            });

            var originalText = dataItem.value;
            var presentText = savingData.AnaCareProv;

            if (opts.onBeforeSave) {
                if (!opts.onBeforeSave.call(target, savingData)) return true;
            }

            if (originalText != presentText) {
                if (!param || !param.needConfirm) saveData();
                else {
                    $.messager.confirm("请确认保存当前修改",
                        "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改:" + originalText + " → " + presentText + "</div><div><em>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                        saveData);
                }

                return false;
            }

            return true;

            function saveData() {
                shift.save();

                dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                    if (result.indexOf("S^") >= 0) {
                        if (opts.onSaveSuccess) {
                            opts.onSaveSuccess.call(target, DHCData);
                        }
                    } else {
                        if (opts.onSaveError) {
                            opts.onSaveError.call(target);
                        }
                    }
                });
            }
        },
        close: function(target) {
            var opts = $(target).anesthetisteditbox("options");
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    };

    $.fn.anesthetisteditbox.defaults = {
        width: 410,
        height: 330,
        onSaveSuccess: null,
        onSaveError: null,
        onClose: null
    }

    function _initiate(target) {
        $(target).validatebox({ novalidate: true });
        var opts = $(target).anesthetisteditbox("options");
        var width = opts.width;
        var height = opts.height;
        $(target).attr("readOnly", true);
        $(target).attr("width", width);

        var htmlArr = [];
        htmlArr.push("<div class='anesthetisteditbox-panel'><form>");
        htmlArr.push("<div class='editview-f-r'>");
        htmlArr.push("<label for='anesthetisteditbox-doctor' class='label'>麻醉医生:</label>");
        htmlArr.push("<input id='anesthetisteditbox-doctor' data-options=\"required:true\">");
        htmlArr.push("</div><div class='editview-f-r'>");
        htmlArr.push("<label for='anesthetisteditbox-assistant' class='label'>麻醉助手:</label>");
        htmlArr.push("<input id='anesthetisteditbox-assistant' name='AnaAssistant'>");
        htmlArr.push("</div><div class='editview-f-r'>");
        htmlArr.push("<label for='anesthetisteditbox-supervisor' class='label'>麻醉指导:</label>");
        htmlArr.push("<input id='anesthetisteditbox-supervisor'>");
        htmlArr.push("</div><div class='editview-f-r'>");
        htmlArr.push("<label for='anesthetisteditbox-intern' class='label'>实习进修:</label>");
        htmlArr.push("<input id='anesthetisteditbox-intern' class='textbox' name='AnaStaff' style='width:174px;'>");
        htmlArr.push("</div>");
        htmlArr.push("<input type='hidden' name='RowId'>");
        htmlArr.push("<input type='hidden' name='AnaExpert'>");
        htmlArr.push("<input type='hidden' name='Anesthesiologist'>");
        htmlArr.push("<input type='hidden' name='AnaAssistant'>");
        htmlArr.push("<input type='hidden' name='AnaCareProv'>");
        htmlArr.push("<input type='hidden' name='AnaAssistantDesc'>");
        htmlArr.push("<input type='hidden' name='AnaExpertDesc'>");
        htmlArr.push("<input type='hidden' name='AnesthesiologistDesc'>");
        htmlArr.push("</form></div>");

        var panel = $(htmlArr.join(""));
        $(target).after(panel);
        $(target).after("<style>.anesthetisteditbox-panel{overflow-x:hidden;overflow-y:auto;}</style>");

        var shiftelement = $('<div class="editview-f-r"></div>').appendTo(panel);
        var shift = new UserShift(shiftelement, {
            url: ANCSP.DataQuery,
            queryParams: {
                ClassName: ANCLS.BLL.DataQueries,
                QueryName: 'FindOperShift',
                Arg1: session.OPSID || '',
                Arg2: session.DeptID || '',
                Arg3: 'A',
                ArgCnt: 3
            },
            saveHandler: function(data) {
                var length = data.length;
                for (var i = 0; i < length; i++) {
                    $.extend(data[i], {
                        ClassName: ANCLS.Model.OperShift,
                        OperSchedule: session.OPSID,
                        CareProvDept: session.DeptID,
                        ShiftType: 'A',
                        target: ''
                    });
                }

                dhccl.saveDatas(ANCSP.MethodService, {
                    ClassName: ANCLS.BLL.OperShift,
                    MethodName: "SaveShift",
                    Arg1: session.OPSID,
                    Arg2: dhccl.formatObjects(data),
                    Arg3: session.UserID,
                    ArgCnt: 3
                }, function(data) {
                    if (data.indexOf("S^") === 0) {

                    } else {
                        dhccl.showMessage(data, "保存交接班记录错误");
                    }

                });
            }
        });
        $(target).data('shift', shift);
        this.datacontainer = $('<div></div>').appendTo(panel);

        $(panel).css({
            position: "absolute",
            "z-index": 1000,
            top: -231,
            left: 1,
            width: 300,
            height: 230,
            'background-color': '#fff',
            border: '1px solid #509de1'
        });

        $(panel).on('keyup', 'input', function(e) {
            var event = e || window.event;
            if (event.keyCode == 13) {
                event.preventDefault();
                event.stopPropagation();
                return false;
            }
        })

        var form = $(panel).find("form");
        $(form).form({
            onLoadSuccess: function(data) {
                var iAnaExpert = $(this).find("input#anesthetisteditbox-supervisor");
                var iAnesthesiologist = $(this).find("input#anesthetisteditbox-doctor");
                var iAnaAssistant = $(this).find("input#anesthetisteditbox-assistant");

                $(iAnaExpert).combobox('setValue', data.AnaExpert);
                $(iAnesthesiologist).combobox('setValue', data.Anesthesiologist);
                $(iAnaAssistant).careprovtagbox("setValue", data.AnaAssistant);
            }
        });

        $(target).data("form", form);

        _initiateControls(target);
    }


    function setFormReady(target) {
        var form = $(target).data("form");
        var iAnaExpert = $(form).find("input#anesthetisteditbox-supervisor");
        var iAnesthesiologist = $(form).find("input#anesthetisteditbox-doctor");
        var iAnaAssistant = $(form).find("input#anesthetisteditbox-assistant");
        var iAnaAddtionalStaff = $(form).find("input#anesthetisteditbox-intern");

        var iAnaCareProv = $(form).find("input[name='AnaCareProv']");
        var iAnaAssistantDesc = $(form).find("input[name='AnaAssistantDesc']");
        var iAnaExpertDesc = $(form).find("input[name='AnaExpertDesc']");
        var iAnesthesiologistDesc = $(form).find("input[name='AnesthesiologistDesc']");
        var hAnaExpert = $(form).find("input[name='AnaExpert']");
        var hAnesthesiologist = $(form).find("input[name='Anesthesiologist']");

        var anaExpertDesc = $(iAnaExpert).combobox("getText");
        var anesthesiologist = $(iAnesthesiologist).combobox("getText");
        var anaExpert = $(iAnaExpert).combobox("getValue");
        var anesthesiologistId = $(iAnesthesiologist).combobox("getValue");
        var anaAssistant = $(iAnaAssistant).careprovtagbox("getText");
        var anaAssistantValues = $(iAnaAssistant).careprovtagbox("getValues");
        $(iAnaAssistant).val(anaAssistantValues.join(","));
        var anaAddtionalStaff = $(iAnaAddtionalStaff).validatebox("getValue");

        $(hAnaExpert).val(anaExpert);
        $(hAnesthesiologist).val(anesthesiologistId);
        $(iAnaExpertDesc).val(anaExpertDesc);
        $(iAnesthesiologistDesc).val(anesthesiologist);
        $(iAnaAssistantDesc).val(anaAssistant);

        var anaCareProvArr = [];

        if (anesthesiologist) anaCareProvArr.push(anesthesiologist);
        if (anaAssistant) anaCareProvArr.push(anaAssistant);
        if (anaExpertDesc) anaCareProvArr.push(anaExpertDesc);
        if (anaAddtionalStaff) anaCareProvArr.push(anaAddtionalStaff);

        var shift = $(target).data('shift');
        shift.completeCareProv(anaCareProvArr);

        $(iAnaCareProv).val(anaCareProvArr.join(","));
    }

    function _initiateControls(target) {
        var opts = $(target).anesthetisteditbox("options");
        var url = ANCSP.DataQuery,
            param = opts.queryParams,
            dataType = "json";
        var careprovList = dhccl.getDatas(url, param, dataType);
        var width = 180;

        $("#anesthetisteditbox-supervisor,#anesthetisteditbox-doctor").combobox({
            textField: "Description",
            valueField: "RowId",
            limitToList: true,
            width: width,
            filter: function(q, row) {
                q = q.toUpperCase();
                var opts = $(this).combobox('options');
                return (row[opts.valueField] === q) || (row[opts.textField].indexOf(q) > -1) || ((row['ShortDesc'] || '').indexOf(q) > -1);
            }
        });

        $("#anesthetisteditbox-assistant").careprovtagbox({
            textField: "Description",
            valueField: "RowId",
            groupField: "FirstChar",
            filterFields: ["Description", "ShortDesc"],
            hasDownArrow: true,
            multiple: true,
            selectOnNavigation: false,
            data: careprovList
        });

        $("#anesthetisteditbox-supervisor,#anesthetisteditbox-doctor").combobox("loadData", careprovList);

        $("#anesthetisteditbox-intern").validatebox({
            width: width,
            novalidate: true
        });

        $("#anesthetisteditbox-shift-add").linkbutton({
            onClick: function() {

            }
        });

        var shift = $(target).data('shift');
        shift.setOptions({
            dialog: {
                careprovs: careprovList
            }
        });
    }


    function UserShift(dom, opts) {
        this.dom = $(dom);
        this.saveHandler = opts.saveHandler;
        this.options = $.extend({ width: 380, height: 390 }, opts);
        this.view = shiftview;
        this.disabled = !session.Editable;
        this.changed = false;
        this.init();
    }

    UserShift.prototype = {
        constructor: UserShift,
        init: function() {
            var _this = this;
            this.dialog = new ShiftDialog(this, this.options.dialog || {});
            this.dom.append('<label class="label">交接班：</label><a href="#" class="btn-shift-add extend-btn" title="添加交接班记录"><span class="icon icon-add"></span></a>');
            this.datacontainer = $('<div></div>').appendTo(this.dom);
            if (this.disabled) {
                this.dom.addClass('plugin-disabled');
            }

            this.dom.delegate('.btn-shift-add', 'click', function() {
                if (_this.options.onOpenDialog) {
                    _this.options.onOpenDialog.call(_this);
                }
                _this.dialog.open();
            });

            this.dom.delegate('.btn-shift-edit', 'click', function() {
                var shiftTarget = $(this).parent();
                var row = $(shiftTarget).data('data');
                var index = $(shiftTarget).attr('data-index');

                if (_this.options.onOpenDialog) {
                    _this.options.onOpenDialog.call(_this);
                }
                _this.dialog.open();
                _this.dialog.loadData(row);
            });

            this.dom.delegate('.btn-shift-delete', 'click', function() {
                var shiftTarget = $(this).parent();
                var row = $(shiftTarget).data('data');

                $.messager.confirm('删除确认', '您确认删除此条交接记录吗？', function(isConfirmed) {
                    if (isConfirmed) {
                        row.isRemoved = 'Y';
                        $(shiftTarget).hide();
                    }
                });
            });

            if (this.options.data) {
                this.loadData(this.options.data);
            } else if (this.options.url) {
                this.load();
            }
        },
        load: function() {
            var _this = this;
            var url = this.options.url;
            var queryParams = this.options.queryParams;

            if (url && queryParams) {
                $.ajax({
                    url: url,
                    async: true,
                    data: queryParams,
                    type: "post",
                    dataType: 'json',
                    success: function(data) {
                        _this.loadData(data);
                    }
                });
            }
        },
        reload: function(param) {
            $.extend(this.options.queryParams, param || {});
            this.load();
        },
        loadData: function(data) {
            var length = data.length;
            this.options.data = data;

            this.datacontainer.empty();
            var row, element;
            for (var i = 0; i < length; i++) {
                row = data[i];
                element = $('<div class="usv-shift" data-index=' + i + '></div>').appendTo(this.datacontainer);
                this.view.render(element, row);
            }
        },
        setOptions: function(opts) {
            $.extend(this.options, opts);
            this.dialog.setOptions(opts.dialog || {});
        },
        updateRow: function(row) {
            var data = this.options.data;
            var index = data.indexOf(row);
            if (index > -1) {
                this.view.render(row.target, row);
            } else {
                index = data.length;
                data.push(row);
                element = $('<div class="usv-shift" data-index=' + i + '></div>').appendTo(this.datacontainer);
                this.view.render(element, row);
            }
        },
        completeCareProv: function(careProvArr) {
            var data = this.options.data;
            var length = data.length;
            var row, index = -1,
                tIndex = -1;

            for (var i = 0; i < length; i++) {
                row = data[i];
                if (row.isRemoved != 'Y') {
                    index = careProvArr.indexOf(row.ShiftCareProvDesc);
                    tIndex = careProvArr.indexOf(row.ReliefCareProvDesc);
                    if (index > -1 && tIndex < 0) careProvArr.splice(index + 1, 0, row.ReliefCareProvDesc);
                    else if (index < 0 && tIndex > -1) careProvArr.splice(tIndex, 0, row.ShiftCareProvDesc);
                    else if (index < 0 && tIndex < 0) {
                        careProvArr.push(row.ShiftCareProvDesc);
                        careProvArr.push(row.ReliefCareProvDesc);
                    }
                }
            }
        },
        save: function() {
            var data = this.options.data;
            var length = data.length;
            var savingData = [];
            var row;
            for (var i = 0; i < length; i++) {
                row = data[i];
                if (row.RowId || row.isRemoved != 'Y') savingData.push(row);
            }

            if (savingData.length > 0 && this.saveHandler) this.saveHandler(savingData);
        }
    }

    var shiftview = {
        render: function(container, shift) {
            container.empty();
            container.data('data', shift);
            shift.target = container;

            var detailcontainer = $('<span class="usv-shift-i"></span>').appendTo(container);
            $('<span class="usv-shift-detail usv-shift-detail-handover"></span>').text(shift.ShiftCareProvDesc).appendTo(detailcontainer);
            $('<span class="usv-shift-detail usv-shift-detail-arrow"></span>').appendTo(detailcontainer);
            $('<span class="usv-shift-detail usv-shift-detail-takeover"></span>').text(shift.ReliefCareProvDesc).appendTo(detailcontainer);
            $('<span class="usv-shift-detail usv-shift-detail-time"></span>').attr('title', shift.ShiftDateTime).text(shift.ShiftTime).appendTo(detailcontainer);
            $('<a class="extend-btn btn-shift-edit" title="修改此条交接班数据"><span class="icon icon-edit"></span></a>').appendTo(container);
            $('<a class="extend-btn btn-shift-delete" title="删除此条交接班数据"><span class="icon icon-cancel"></span></a>').appendTo(container);
        }
    }

    function ShiftDialog(parent, opts) {
        this.parent = parent;
        this.options = $.extend({
            width: 300,
            height: 220,
            careprovs: []
        }, opts);
        this.init();
    }

    ShiftDialog.prototype = {
        constructor: ShiftDialog,
        /**
         * 初始化
         */
        init: function() {
            this.dom = $('<div class="shift-dialog"></div>').appendTo('body');
            this.form = $('<form></form>').appendTo(this.dom);
            this.initDialog();
            this.initForm();
        },
        initDialog: function() {
            var _this = this;
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
                iconCls: 'icon-close',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);
            this.dom.dialog({
                left: 300,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '麻醉交接班',
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
        /**
         * 初始化表单
         */
        initForm: function() {
            this.form.form({});
            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            var careprovs = this.options.careprovs;

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<label class="label" >交班医生：</label>').appendTo(row);
            this.ShiftCareProvID = $('<input type="text" name="ShiftCareProvID">').appendTo(row);
            this.ShiftCareProvID.combobox({
                textField: 'Description',
                valueField: 'RowId',
                required: true,
                limitToList: true,
                width: 180,
                data: careprovs
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<label class="label" >接班医生：</label>').appendTo(row);
            this.ReliefCareProvID = $('<input type="text" name="ReliefCareProvID">').appendTo(row);
            this.ReliefCareProvID.combobox({
                textField: 'Description',
                valueField: 'RowId',
                required: true,
                limitToList: true,
                width: 180,
                data: careprovs
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<label class="label" >交接时间：</label>').appendTo(row);
            this.ShiftDateTime = $('<input type="text" name="ShiftDateTime">').appendTo(row);
            this.ShiftDateTime.datetimebox({
                width: 180,
                required: true
            });
        },
        setOptions: function(opts) {
            $.extend(this.options, opts);

            var careprovs = this.options.careprovs;
            this.ShiftCareProvID.combobox('loadData', careprovs);
            this.ReliefCareProvID.combobox('loadData', careprovs);
        },
        loadData: function(data) {
            this.originalData = data;
            this.RowId.val(data.RowId);
            this.ShiftCareProvID.combobox('setValue', data.ShiftCareProvID);
            this.ReliefCareProvID.combobox('setValue', data.ReliefCareProvID);
            this.ShiftDateTime.datetimebox('setValue', data.ShiftDateTime);
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.form.form('clear');
            this.originalData = null;
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
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
            if (this.validate()) {
                var data = this.toData();
                if (this.originalData) data = $.extend(this.originalData, data);
                if (this.parent && this.parent.updateRow) this.parent.updateRow(data);
                this.close();
            }
        },
        /**
         * 校验填写
         */
        validate: function() {
            return this.form.form('validate');
        },
        /**
         * 生成数据
         */
        toData: function() {
            var data = null;
            var ShiftCareProvID = this.ShiftCareProvID.combobox('getValue');
            var ReliefCareProvID = this.ReliefCareProvID.combobox('getValue');
            var ShiftDateTime = this.ShiftDateTime.datetimebox('getValue');
            var datetimearray = ShiftDateTime.split(' ');

            data = {
                ShiftCareProvID: ShiftCareProvID,
                ShiftCareProvDesc: this.ShiftCareProvID.combobox('getText'),
                ReliefCareProvID: ReliefCareProvID,
                ReliefCareProvDesc: this.ReliefCareProvID.combobox('getText'),
                ShiftType: 'A',
                ShiftTypeName: '麻醉',
                ShiftDateTime: ShiftDateTime,
                ShiftDate: datetimearray[0] || '',
                ShiftTime: datetimearray[1] || '',
            };

            return data;
        }
    }
})(jQuery);