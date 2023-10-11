
/*mutiselect.js文件中下拉单选的部分脚本*/
//下拉单选
(function ($) {
    function getRadioId(comboboxId, val) {
        return comboboxId + "_" + val;
    }
    function getRadioname(comboboxId) {
        return comboboxId + "_name";
    }
    var methods = {
        init: function (options) {
            var defaults = {
                //required: false,
                //editable: false,
                onChange: function () { },
                //multiple: false
                //   , valueField: "id"
                //  , textField: "text"

            }
            var endOptions = $.extend(defaults, options);
            this.each(function () {
                var _this = $(this);
                var id = _this.attr("id");
				
				
				endOptions.formatter=function (row) {
					var opts;
					var val = row[endOptions.valueField];
					var text = row[endOptions.textField];
					var RadioId = getRadioId(id, val);
					var Radioname = getRadioname(id);
					if (row.selected == true) {
						opts = "<input style='height:13px' type='radio' checked='checked' id='" + RadioId + "' name='" + Radioname + "' value='" + val + "'>" + text;
					} else {
						opts = "<input style='height:13px' type='radio' id='" + RadioId + "' name='" + Radioname + "' value='" + val + "'>" + text;
					}
					return opts;
				}
				endOptions.oldonSelect = endOptions.onSelect;
				endOptions.onSelect=function (rec) {
					if (rec) {
						var val = rec[endOptions.valueField];
						var RadioId = getRadioId(id, val);
						$("#" + RadioId).prop('checked', true);

						if (endOptions.oldonSelect) {
							endOptions.oldonSelect(rec);
						}
					}
				}
				endOptions.oldonUnselect = endOptions.onUnselect;
				endOptions.onUnselect=function (rec) {
					var val = rec[endOptions.valueField];
					var RadioId = getRadioId(id, val);
					$("#" + RadioId).prop('checked', false);

					if (endOptions.oldonUnselect) {
						endOptions.oldonUnselect(rec);
					}
				}
				
                $(_this).combobox(endOptions);
            });
        },
        enable: function (isenable) {
            var _this = $(this);
            if (isenable) {
                $(_this).combobox("enable");
            }
            else {
                $(_this).combobox("disable");
            }
        },
        disable: function (isenable) {
            var _this = $(this);
            if (isenable) {
                $(_this).combobox("disable");
            }
            else {
                $(_this).combobox("enable");
            }
        },
        setValue: function (vals) {
            var _this = $(this);
            var id = _this.attr("id");
            $(_this).combobox("setValue", vals);
            var RadioId = getRadioId(id, vals);
            $("#" + RadioId).prop('checked', true);
            var itemselect = null;
            var valueField = $(_this).combobox('options').valueField;
            for (var i = 0; i < datas.length; i++) {
                if (datas[i][valueField] == vals[0]) {
                    itemselect = datas[i];
                    break;
                }
            }
            if (itemselect != null)
                $(_this).combobox('options').onSelect.call($('#' + id)[0], itemselect);

        },
        setValues: function (vals) {
            var _this = $(this);
            var id = _this.attr("id");//单选只能选择一个，
            if (vals.length > 0) {
                var tempval = vals[0];
                $(_this).combobox("setValue", tempval);
                var RadioId = getRadioId(id, tempval);
                $("#" + RadioId).prop('checked', true);
                var datas = $(_this).combobox("getData");
                var itemselect = null;
                var valueField = $(_this).combobox('options').valueField;
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i][valueField] == vals[0]) {
                        itemselect = datas[i];
                        break;
                    }
                }
                if (itemselect != null)
                    $(_this).combobox('options').onSelect.call($('#' + id)[0], itemselect);
            }
             
        },
        loadData: function (data) {
            var _this = $(this);
            $(_this).combobox("loadData", data);
        },
        options: function () {
            var _this = $(this);
            return $(_this).combobox("options");
        },
        getValue: function () {
            var _this = $(this);
            var re = $(_this).combobox("getValue");
            return re == undefined ? "" : re;
        },
        getValues: function () {
            var _this = $(this);
            var re = $(_this).combobox("getValues");
            return re == undefined ? [] : re;
        },
        getData: function () {
            var _this = $(this);
            var re = $(_this).combobox("getData");
            return re == undefined ? [] : re;
        }
    };

    $.fn.DropDropRadio = function (method) {
        // 方法调用
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof method === 'object' || !method) {
            return methods.init.apply(this, arguments);
        } else {
            $.error('Method ' + method + 'does not exist on mutiselect.js');
        }
    };
})(jQuery);

