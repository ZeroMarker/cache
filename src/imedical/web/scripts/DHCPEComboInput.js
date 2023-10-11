/** 
 * 名称：DHCPEComboInput.js
 * 功能：获取焦点时弹出对应类型的弹框
 * 创建：zhongricheng
 * 日期：2020-11-03
 * 注意：引用该js时，需放在调用的js之前
 */

/** 
 * 会生成一个 class 为 comboinput_data_点击的控件ID 的 div panel
 * div panel 下的数据 div ID 为 data_点击的控件ID
 * 
 * 初始化参数
 * position			弹出位置 top bottom custom  默认 bottom
 * title			表格标题 目前没效果
 * panelEvent		操作事件 默认 focus
 * panelHeight		弹出框 高度
 * comboType		弹出类型   datagrid 表格   keywords 关键字
 * comboParams		弹出类型对应的参数 object
 * panelWidth panelTop panelLeft   弹出位置为 custom 时 生效
 *
 * 扩展方法
 * load				传参为comboParams，弹出类型对应的参数 object
 */

(function ($) {  // 不影响外部方法
    function escapeJquery(srcString) {
        // 转义之后的结果
        var escapseResult = srcString;

        // javascript正则表达式中的特殊字符
        var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[", "]", "|", "{", "}"];

        // jquery中的特殊字符,不是正则表达式中的特殊字符
        var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"", ":", ";", "<", ">", ",", "/"];

        for (var i = 0; i < jsSpecialChars.length; i++) {
            escapseResult = escapseResult.replace(new RegExp("\\" + jsSpecialChars[i], "g"), "\\" + jsSpecialChars[i]);
        }

        for (var i = 0; i < jquerySpecialChars.length; i++) {
            escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i], "g"), "\\" + jquerySpecialChars[i]);
        }

        return escapseResult;
    }

    function load(target, opts, type) {
        var _t = $(target);
        if (type == "init") {
            // dom对象绑定opts，便于代码获取
            _t.data(opts);

            var _panelEvent = _t.data().panelEvent;
            if (_panelEvent == "undefined" || _panelEvent == undefined || _panelEvent == "") _panelEvent = "focus";

            var _id = "data_" + target.id;
            var _params = _t.data();
            var _title = _params.title;
            var _combotype = _params.comboType;
            var _panelHeight = _params.panelHeight;
            var _comboParams = _params.comboParams;
            var _position = _params.position;
            if (_title == "undefined" || _title == undefined) _title = "";
            if (_position == "undefined" || _position == undefined || _position == "") _position = "bottom";

            // 获取点击元素对应属性
            var _border_l_w = parseFloat(_t.css("border-left-width"));
            var _border_r_w = parseFloat(_t.css("border-right-width"));
            var _width = _t.outerWidth() - (isNaN(_border_l_w) ? 0 : _border_l_w) - (isNaN(_border_r_w) ? 0 : _border_r_w);  //width();
            var _height = _t.outerHeight();  // height();

            var _border = _t.css('border') || (_t.css('border-top-width') + " " + _t.css('border-top-style') + " " + _t.css('border-top-color'));
            var _border_radius = _t.css('border-radius') || _t.css('-webkit-border-radius') || _t.css('-moz-border-radius') || _t.css('-o-border-radius') || _t.css('border-top-left-radius');

            // 设置位置及宽高
            if (_position == "custom") {
                var _panelWidth = _params.panelWidth;
                var _panelTop = _params.panelTop;
                var _panelLeft = _params.panelLeft;
            } else if (_position == "top") {
                var _panelWidth = _width;
                var _panelTop = _t.position().top - (_panelHeight + 2) - 2;
                var _panelLeft = _t.position().left;
            } else {
                var _panelWidth = _width;
                var _panelTop = _t.position().top + _height + 2;
                var _panelLeft = _t.position().left;
            }
            if (_panelHeight == "undefined" || _panelHeight == undefined || _panelHeight == "") _panelHeight = 100;
            if (_panelWidth == "undefined" || _panelWidth == undefined || _panelWidth == "") _panelWidth = 100;
            if (_panelTop == "undefined" || _panelTop == undefined || _panelTop == "") _panelTop = 100;
            if (_panelLeft == "undefined" || _panelLeft == undefined || _panelLeft == "") _panelLeft = 100;

            if (_combotype != "undefined" && _combotype != undefined && _combotype != "" && _comboParams != "undefined" && _comboParams != undefined && _comboParams != "") {  // 追加表格
                var combo_str = "";
                if (_combotype == "datagrid") {
                    combo_str = "<table class='hisui-datagrid' id='" + _id + "'></table>";
                } else if (_combotype == "keywords") {
                    combo_str = "<div id='" + _id + "' style='width: " + _panelWidth + "px; height: " + _panelHeight + "px; overflow: auto;'></div>";
                } else {
                    return false;
                }

                // TODO panel中title未显示
                var div_css = "display: none; background-color: #fff; width: " + _panelWidth + "px; height: " + _panelHeight + "px; position: absolute; top: " + _panelTop + "px; left: " + _panelLeft + "px; border: " + _border + "; border-radius: " + _border_radius + "; z-index: 100;";
                var div_options = "headerCls:'panel-header-gray'";// + (_title==""?",bodyCls:'panel-body-gray'":"");
                var div_str = "<div class=\"hisui-panel comboinput_" + _id + "\" title=\"" + _title + "\" style=\"" + div_css + "\" data-options=\"" + div_options + "\">" + combo_str + "</div>";

                _t.after(div_str);

                if (_combotype == "datagrid") {
                    //$HUI.datagrid("#" + _id, _comboParams)
                    $("#" + escapeJquery(_id) + "").datagrid(_comboParams);

                } else if (_combotype == "keywords") {
                    $("#" + escapeJquery(_id) + "").keywords(_comboParams);

                }
            }
            _t.on(_panelEvent, function () {
                var _t = $(this);
                var _id = "data_" + this.id;
                _t.nextAll("div.comboinput_" + escapeJquery(_id)).show();

                var _params = _t.data();

                var _combotype = _params.comboType;
                // 界面初始化控件
                if (_combotype == "datagrid") {
                    //$HUI.datagrid("#" + _id, _comboParams)
                    $("#" + escapeJquery(_id) + "").datagrid("load", _params.comboParams.queryParams);

                } else if (_combotype == "keywords") {
                    $("#" + escapeJquery(_id) + "").keywords(_comboParams);

                }

            });

            _t.on("blur", function () {
                var _t = $(this);
                var _id = "data_" + this.id;
                $("body").on("click", function (e) {
                    if (_t.is(":focus")) {
                        $("body").off("click");
                    } else if ($(e.target).parents().hasClass("comboinput_" + escapeJquery(_id))) {

                    } else if ($(e.target).hasClass("comboinput_" + escapeJquery(_id))) {

                    } else {
                        _t.nextAll("div.comboinput_" + escapeJquery(_id)).hide();
                        //_t.nextAll('div.comboinput').remove();
                        $("body").off("click");
                    }
                });
            });
        } else {
            // 更新dom对象绑定的opts
            var inputval = _t.data("comboParams");
            for (var key in opts) {
                inputval[key] = opts[key];
            }
        }
    };

    // 初始化
    $.fn.comboinput = function (opts, param, func) {
        var _t = this[0];
        if (typeof opts == "string" && opts.constructor == String) { // Object.prototype.toString.call(opts) === "[object String]"
            $.fn.comboinput.method[opts](_t, param);
        } else {
            var _id = _t.id;
            if (_id == "undefined" || _id == undefined || _id == "") {

            } else {
                load(_t, opts, "init")
            }
        }
    };

    $.fn.comboinput.method = {
        load: function (target, param) {
            load(target, param, "load");
        }
    };
})(jQuery);