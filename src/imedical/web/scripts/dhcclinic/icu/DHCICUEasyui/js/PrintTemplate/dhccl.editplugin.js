/**
 * 文本框
 */
var TextboxPlugin = (function () {
    function TextboxPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    TextboxPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<input type="text" id="' + this.areaItem.Code + '" class="textbox" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale),
            "color": "blue"
        });
        this.editBox.on('change', function () {
            if ($this.onValueChanged) {
                $this.onValueChanged($this);
            }
            if ($this.areaItem.OnValueChanged) {
                try {
                    eval($this.areaItem.OnValueChanged + "()");
                } catch (err) {
                    console.error(err);
                }
            }
        });
        this.editBox.on('dblclick', function () {
            if ($this.areaItem.DataEditView) {
                var view = dataEditView[$this.areaItem.DataEditView];
                if(view){
                    view(function(val){
                        $this.setValue(val)
                    }, $this.getValue());
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    TextboxPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    TextboxPlugin.prototype.getValue = function () {
        return this.editBox.val();
    };

    TextboxPlugin.prototype.setValue = function (value) {
        this.editBox.val(value);
    };

    TextboxPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    TextboxPlugin.prototype.getScoreValue = function () {
        return this.getValue();
    };

    TextboxPlugin.prototype.disable = function () {
        this.editBox.attr("disabled", true);
    };

    TextboxPlugin.prototype.enable = function () {
        this.editBox.attr("disabled", false);
    };

    TextboxPlugin.prototype.clear = function () {
        this.editBox.val("");
    };

    TextboxPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    return TextboxPlugin;
}());

/**
 * 选择框
 */
var CheckboxPlugin = (function () {
    function CheckboxPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.code = areaItem.Code;
        this.editType = areaItem.Type;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    CheckboxPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<input type="checkbox" id="' + this.code + '" class="hisui-checkbox" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width + 2,
            "height": $this.editBoxRect.height + 2,
        });
        this.editBox.data("areaItem", this.areaItem);
        this.editBox.checkbox({
            onCheckChange: function (e, value) {
                var currentAreaItem = $(this).data("areaItem");
                if (value && currentAreaItem.Group && !currentAreaItem.Multiple) {
                    var groupSelector = "input[type='checkbox']";
                    $(groupSelector).each(function (index, item) {
                        var areaItem = $(this).data("areaItem");
                        if (areaItem.Code != currentAreaItem.Code && areaItem.Group == currentAreaItem.Group) {
                            $(this).checkbox("setValue", false);
                        }
                    });
                }
                if ($this.onValueChanged) {
                    $this.onValueChanged($this);
                }
                if ($this.areaItem.OnValueChanged) {
                    try {
                        eval($this.areaItem.OnValueChanged + "()");
                    } catch (err) {
                        console.error(err);
                    }
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    CheckboxPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    CheckboxPlugin.prototype.getValue = function () {
        var value = "";
        var checked = this.editBox.checkbox("getValue");
        if (checked) {
            if (this.areaItem.Desc) {
                value = this.areaItem.Desc;
            } else {
                value = this.areaItem.Code;
            }
        }
        return value;
    };

    CheckboxPlugin.prototype.setValue = function (value) {
        if ((this.areaItem.Desc && value == this.areaItem.Desc) || (this.areaItem.Code && value == this.areaItem.Code)) {
            this.editBox.checkbox("setValue", true);
        } else {
            this.editBox.checkbox("setValue", false);
        }
    };

    CheckboxPlugin.prototype.getPrintValue = function () {
        return this.editBox.checkbox("getValue");
    };

    CheckboxPlugin.prototype.getScoreValue = function () {
        var value = "";
        if (this.editBox.checkbox("getValue")) {
            value = this.areaItem.ScoreValue;
        }
        return value;
    };

    CheckboxPlugin.prototype.disable = function () {
        this.editBox.checkbox("disable");
    };

    CheckboxPlugin.prototype.enable = function () {
        this.editBox.checkbox("enable");
    };

    CheckboxPlugin.prototype.clear = function () {
        this.editBox.checkbox("setValue", false);
    };

    CheckboxPlugin.prototype.validate = function () {
        return true;
    };

    return CheckboxPlugin;
}());

/**
 * 组合框
 */
var ComboboxPlugin = (function () {
    function ComboboxPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.editType = areaItem.Type;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    ComboboxPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<select id="' + this.areaItem.Code + '" class="hisui-combobox" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale),
            "color": "blue"
        });
        var idField = "id",
            textField = "text";
        var data = [];
        if (this.areaItem.Options) {
            var optionArr = this.areaItem.Options.split(";")
            for (var i = 0; i < optionArr.length; i++) {
                var id = "",
                    text = "";
                var option = optionArr[i];
                var optStrArray = option.split(":");
                if (optStrArray.length == 1) id = optStrArray[0], text = optStrArray[0];
                if (optStrArray.length == 2) id = optStrArray[0], text = optStrArray[1];
                data.push({
                    id: id,
                    text: text
                });
            }
        }
        if (this.areaItem.ClassName && this.areaItem.QueryName && this.areaItem.ValueField && this.areaItem.TextField) {
            idField = this.areaItem.ValueField;
            textField = this.areaItem.TextField;
            var queryParas = {
                ClassName: $this.areaItem.ClassName,
                QueryName: $this.areaItem.QueryName,
                ArgCnt: 0
            };
            if (this.areaItem.QueryParams) {
                var count = 0;
                var paraArr = this.areaItem.QueryParams.split(";")
                for (var i = 0; i < paraArr.length; i++) {
                    var para = paraArr[i];
                    count++;
                    if (session[para]) {
                        queryParas["Arg" + count] = session[para];
                    } else {
                        queryParas["Arg" + count] = para;
                    }
                }
                queryParas.ArgCnt = count;
            }
            data = dhccl.getDatas(ANCSP.DataQuery, queryParas, "json");
        }

        this.editBox.combobox({
            data: data,
            valueField: idField,
            textField: textField,
            multiple: $this.areaItem.Multiple,
            rowStyle: $this.areaItem.Multiple ? 'checkbox' : '',
            onChange: function (newValue, oldValue) {
                if ($this.onValueChanged) {
                    $this.onValueChanged($this);
                }
                if ($this.areaItem.OnValueChanged) {
                    try {
                        eval($this.areaItem.OnValueChanged + "()");
                    } catch (err) {
                        console.error(err);
                    }
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    ComboboxPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    ComboboxPlugin.prototype.getValue = function () {
        var value = this.editBox.combobox("getValues");
        if (value == "" || value.length == 0) {
            return this.editBox.combobox("getText");
        } else {
            return value.join(',');
        }
    };

    ComboboxPlugin.prototype.setValue = function (value) {
        if (value == "") {
            this.editBox.combobox("setValues", []);
        } else {
            this.editBox.combobox("setValues", value.split(','));
        }
    };

    ComboboxPlugin.prototype.getPrintValue = function () {
        return this.editBox.combobox("getText");
    };

    ComboboxPlugin.prototype.getScoreValue = function () {
        return this.editBox.combobox("getValue");
    };

    ComboboxPlugin.prototype.disable = function () {
        this.editBox.combobox("disable");
    };

    ComboboxPlugin.prototype.enable = function () {
        this.editBox.combobox("enable");
    };

    ComboboxPlugin.prototype.clear = function () {
        this.setValue("");
    };

    ComboboxPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    return ComboboxPlugin;
}());

/**
 * 多行文本框
 */
var TextareaPlugin = (function () {
    function TextareaPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.code = areaItem.Code;
        this.editType = areaItem.Type;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    TextareaPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<textarea id="' + this.code + '" class="textbox" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width,
            "height": $this.editBoxRect.height,
            "color": "blue"
        });
        this.editBox.on('change', function () {
            if ($this.onValueChanged) {
                $this.onValueChanged($this);
            }
        });
        this.editBox.on('dblclick', function () {
            if ($this.areaItem.DataEditView) {
                var view = dataEditView[$this.areaItem.DataEditView];
                if(view){
                    view(function(val){
                        $this.setValue(val)
                    }, $this.getValue());
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    TextareaPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    TextareaPlugin.prototype.getValue = function () {
        return this.editBox.val();
    };

    TextareaPlugin.prototype.setValue = function (value) {
        this.editBox.val(value);
    };

    TextareaPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    TextareaPlugin.prototype.getScoreValue = function () {
        return this.getValue();
    };

    TextareaPlugin.prototype.disable = function () {
        this.editBox.attr("disabled", true);
    };

    TextareaPlugin.prototype.enable = function () {
        this.editBox.attr("disabled", false);
    };

    TextareaPlugin.prototype.clear = function () {
        this.editBox.val("");
    };

    TextareaPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    return TextareaPlugin;
}());

/**
 * 日期框
 */
var DateboxPlugin = (function () {
    function DateboxPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.code = areaItem.Code;
        this.editType = areaItem.Type;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    DateboxPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<input id="' + this.code + '" class="hisui-datebox" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width + 2,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale)
        });
        this.editBox.datebox({
            onChange: function (newValue, oldValue) {
                if ($this.onValueChanged) {
                    $this.onValueChanged($this);
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    DateboxPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    DateboxPlugin.prototype.getValue = function () {
        return this.editBox.datebox("getValue");
    };

    DateboxPlugin.prototype.setValue = function (value) {
        this.editBox.datebox("setValue", value);
        if (value == "now") {
            this.editBox.datebox("setValue", this.getNowDate());
        }
    };

    DateboxPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    DateboxPlugin.prototype.getScoreValue = function () {
        return "";
    };

    DateboxPlugin.prototype.disable = function () {
        this.editBox.datebox("disable");
    };

    DateboxPlugin.prototype.enable = function () {
        this.editBox.datebox("enable");
    };

    DateboxPlugin.prototype.clear = function () {
        this.setValue("");
    };

    DateboxPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    DateboxPlugin.prototype.getNowDate = function () {
        var date = new Date();
        var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
        var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0" + (date.getMonth() + 1);
        return date.getFullYear() + '-' + month + '-' + day;
    }

    return DateboxPlugin;
}());

/**
 * 时间框
 */
var TimespinnerPlugin = (function () {
    function TimespinnerPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    TimespinnerPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<input id="' + this.areaItem.Code + '" class="hisui-timespinner" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width + 2,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale)
        });

        this.editBox.timespinner({
            onChange: function (newValue, oldValue) {
                if ($this.onValueChanged) {
                    $this.onValueChanged($this);
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    TimespinnerPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    TimespinnerPlugin.prototype.getValue = function () {
        return this.editBox.timespinner("getValue");
    };

    TimespinnerPlugin.prototype.setValue = function (value) {
        this.editBox.timespinner("setValue", value);
        if (value == "now") {
            this.editBox.timespinner("setValue", this.getNowTime());
        }
    };

    TimespinnerPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    TimespinnerPlugin.prototype.getScoreValue = function () {
        return "";
    };

    TimespinnerPlugin.prototype.disable = function () {
        this.editBox.timespinner("disable");
    };

    TimespinnerPlugin.prototype.enable = function () {
        this.editBox.timespinner("enable");
    };

    TimespinnerPlugin.prototype.clear = function () {
        this.setValue("");
    };

    TimespinnerPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    TimespinnerPlugin.prototype.getNowTime = function () {
        var date = new Date();
        var hour = date.getHours();
        var min = date.getMinutes();
        var sec = date.getSeconds();
        return hour + ":" + min + ":" + sec;
    }

    return TimespinnerPlugin;
}());

/**
 * 日期时间框
 */
var DatetimeboxPlugin = (function () {
    function DatetimeboxPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.code = areaItem.Code;
        this.editType = areaItem.Type;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    DatetimeboxPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<input id="' + this.areaItem.Code + '" class="hisui-datetimebox" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width + 2,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale)
        });
        this.editBox.datetimebox({
            showSeconds: false,
            onChange: function (newValue, oldValue) {
                if ($this.onValueChanged) {
                    $this.onValueChanged($this);
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    DatetimeboxPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    DatetimeboxPlugin.prototype.getValue = function () {
        return this.editBox.datetimebox("getValue");
    };

    DatetimeboxPlugin.prototype.setValue = function (value) {
        this.editBox.datetimebox("setValue", value);
        if (value == "now") {
            this.editBox.datetimebox("setValue", this.getNowDateTime());
        }
    };

    DatetimeboxPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    DatetimeboxPlugin.prototype.getScoreValue = function () {
        return "";
    };

    DatetimeboxPlugin.prototype.disable = function () {
        this.editBox.datetimebox("disable");
    };

    DatetimeboxPlugin.prototype.enable = function () {
        this.editBox.datetimebox("enable");
    };

    DatetimeboxPlugin.prototype.clear = function () {
        this.setValue("");
    };

    DatetimeboxPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    DatetimeboxPlugin.prototype.getNowDateTime = function () {
        var date = new Date();
        var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
        var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0" + (date.getMonth() + 1);
        var hour = date.getHours();
        var min = date.getMinutes();
        var sec = date.getSeconds();
        return date.getFullYear() + '-' + month + '-' + day + " " + hour + ":" + min + ":" + sec;
    }

    return DatetimeboxPlugin;
}());

/**
 * 数字框
 */
var NumberspinnerPlugin = (function () {
    function NumberspinnerPlugin(areaItem, editBoxRect, onValueChanged, editContainer) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    NumberspinnerPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<input id="' + this.areaItem.Code + '" class="hisui-numberspinner" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width + 2,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale)
        });

        var min = this.areaItem.Min ? parseInt(this.areaItem.Min) : null;
        var max = this.areaItem.Max ? parseInt(this.areaItem.Max) : null;
        var precision = this.areaItem.Precision ? parseInt(this.areaItem.Precision) : 0;
        this.editBox.numberspinner({
            min: min,
            max: max,
            precision: precision,
            onChange: function (newValue, oldValue) {
                if ($this.onValueChanged) {
                    $this.onValueChanged($this)
                }
                if ($this.areaItem.OnValueChanged) {
                    try {
                        eval($this.areaItem.OnValueChanged + "()");
                    } catch (err) {
                        console.error(err);
                    }
                }
            }
        });
        if (!this.areaItem.Editable) this.disable();
    };

    NumberspinnerPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    NumberspinnerPlugin.prototype.getValue = function () {
        return this.editBox.numberspinner("getValue");
    };

    NumberspinnerPlugin.prototype.setValue = function (value) {
        this.editBox.numberspinner("setValue", value);
    };

    NumberspinnerPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    NumberspinnerPlugin.prototype.getScoreValue = function () {
        return "";
    };

    NumberspinnerPlugin.prototype.disable = function () {
        this.editBox.numberspinner("disable");
    };

    NumberspinnerPlugin.prototype.enable = function () {
        this.editBox.numberspinner("enable");
    };

    NumberspinnerPlugin.prototype.clear = function () {
        this.setValue("");
    };

    NumberspinnerPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    return NumberspinnerPlugin;
}());

/**
 * 签名框
 */
var SignaturePlugin = (function () {
    function SignaturePlugin(areaItem, editBoxRect, onValueChanged, editContainer, getUserFillData) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.getUserFillData = getUserFillData;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    SignaturePlugin.prototype.init = function () {
        var $this = this;
        if(this.areaItem.UserSign){
            this.editBox = $('<input id="' + this.areaItem.Code + '" class="hisui-triggerbox signature" data-userSign="true" />').appendTo(this.editContainer);
        }else{
            this.editBox = $('<input id="' + this.areaItem.Code + '" class="hisui-triggerbox signature" />').appendTo(this.editContainer);
        }
        
        this.editBox.css({
            "width": $this.editBoxRect.width,
            "height": parseInt($this.editBoxRect.height * $this.boxHeightScale)
        });

        this.editBox.triggerbox({
            icon: 'icon-w-edit',
            prompt: this.areaItem.Desc /*,
            handler: function () {
                var signCode = $(this).attr("id");
                var title = $this.areaItem.Desc;
                var CareProvType = "";
                var operDatas = $this.getUserFillData();
                var originalData = JSON.stringify(operDatas);
                var CASign = new CASignature({
                    title: title || "",
                    contentData: originalData,
                    signCode: signCode,
                    signBox: "#" + signCode,
                    imgBox: "",
                    CareProvType: CareProvType
                });
                CASign.open();
            }*/
        });

        // var textbox = $(this.editBox).triggerbox("textbox");
        // textbox.attr("disabled", "disabled");

        if (!this.areaItem.Editable) {
            this.disable();
        }
    };

    SignaturePlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    SignaturePlugin.prototype.getValue = function () {
        return this.editBox.triggerbox("getValue");
    };

    SignaturePlugin.prototype.setValue = function (value) {
        this.editBox.triggerbox("setValue", value);
    };

    SignaturePlugin.prototype.getPrintValue = function () {
        var imageBase64String = $("#" + this.areaItem.Code + "Image").attr("src");
        if (imageBase64String) {
            return ""
        }
        else {
            return this.getValue();
        }
    };

    SignaturePlugin.prototype.getScoreValue = function () {
        return "";
    };

    SignaturePlugin.prototype.disable = function () {
        this.editBox.triggerbox("disable");
    };

    SignaturePlugin.prototype.enable = function () {
        //this.editBox.triggerbox("enable");
    };

    SignaturePlugin.prototype.clear = function () {
        this.setValue("");
    };

    SignaturePlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    return SignaturePlugin;
}());


/**
 * 图片签名项
 */
var ImgSignPlugin = (function () {
    function ImgSignPlugin(areaItem, editBoxRect, onValueChanged, editContainer, getUserFillData) {
        this.areaItem = areaItem;
        this.editBoxRect = editBoxRect;
        this.onValueChanged = onValueChanged;
        this.editContainer = editContainer;
        this.getUserFillData = getUserFillData;
        this.editBox = null;
        this.boxHeightScale = 1.2;

        this.init();
    }

    ImgSignPlugin.prototype.init = function () {
        var $this = this;
        this.editBox = $('<img id="' + this.areaItem.Code + '" />').appendTo(this.editContainer);
        this.editBox.css({
            "width": $this.editBoxRect.width + 2,
            "height": $this.editBoxRect.height + 2
        });

        if(this.areaItem.SignType == "handSign" || this.areaItem.SignType == "handAndFingerSign"){
            this.loadHandSignImage(session.RecordSheetID, this.areaItem.Code); //加载手写签名
            this.editBox.click(function () {
                var signCode = $this.areaItem.Code;
                var title = $this.areaItem.Desc;
                var originalData = JSON.stringify($this.operDatas);
                var signLevel = "";
                if ($this.areaItem.SignType == "handSign") signLevel = "HandSign";
                handSign.sign({ //调用手写签名方法
                    actionType: "Append",
                    signUserId: session.ExtUserID,
                    userCode: session.ExtUserCode,
                    instanceId: session.RecordSheetID,
                    signCode : signCode,
                    originalData : originalData,
                    signLevel : signLevel,
                    plainText:  "test",
                    signDocument: function(instanceId, imgType, signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage){
                        if (img) { //手写签名成功方法
                            var fingerImageSrc = "data:image/gif;base64," + img;
                            $("#"+signCode).attr("src", fingerImageSrc);
                            return {
                                result: "OK"
                            };
                        }
                    },
                    unSignedDocument: function(){
                        
                    },
                    saveSignedDocument: function(instanceId, signUserId, signLevel, signId, Digest, signType, Path, actionType){
                        return '';
                    }
                });
            });
            
            this.editBox.contextmenu(function(e) {
                e.preventDefault() // 阻止右键菜单默认行为
                var signCode = $this.areaItem.Code;
                $.messager.confirm("提示","是否删除已有签名？",function(r){
                    if(r){
                        var saveRet = dhccl.runServerMethodNormal("CIS.AN.CA.AnySign","RemoveSignature",session.RecordSheetID, signCode);
                        if(saveRet.indexOf("S^")===0){
                            $this.editBox.attr("src", "");
                            $.messager.popover({
                                msg: "删除签名成功",
                                type: "success"
                            });
                        }else{
                            $.messager.alert("提示","删除签名失败，原因："+saveRet,"error");
                        }
                    }
                });
            });
        }else{
            this.editBox.click(function () {
                var signCode = $this.areaItem.Code;
                var title = $this.areaItem.Desc;
                var originalData = JSON.stringify($this.operDatas);
                var CASign = new CASignature({
                    title: title || "",
                    contentData: originalData,
                    signCode: signCode,
                    signBox: "",
                    imgBox: "#" + signCode
                });
                CASign.open();
            });
            this.editBox.contextmenu(function(e) {
                e.preventDefault() // 阻止右键菜单默认行为
                var signCode = $this.areaItem.Code;
                if ($this.editBox.attr("src")){
                    $.messager.confirm("提示","是否删除已有签名？",function(r){
                        if(r){
                            var saveRet=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"RemoveSignature",session.RecordSheetID,signCode);
                            if(saveRet.indexOf("S^")===0){
                                $this.editBox.attr("src", "");
                                $.messager.popover({
                                    msg: "删除签名成功",
                                    type: "success"
                                });
                            }else{
                                $.messager.alert("提示","删除签名失败，原因："+saveRet,"error");
                            }
                        }
                    });
                }
                
            });
        }

        if (!this.areaItem.Editable) {
            this.disable();
        }
    };

    ImgSignPlugin.prototype.loadHandSignImage = function (recordSheetId,signCode) {
        var imgDataStr = dhccl.runServerMethodNormal("CIS.AN.CA.AnySign","GetAnySignImage",recordSheetId,signCode);
        if(imgDataStr){
            var imgDataArr = imgDataStr.split(String.fromCharCode(1));
            for(var i=0;i<imgDataArr.length;i++){
                var curImgDataStr=imgDataArr[i];
                var curImgDataArr=curImgDataStr.split(String.fromCharCode(0));
                var signImage=curImgDataArr[1];
                var fingerImage=curImgDataArr[2];
                if(signImage) $("#"+signCode).attr("src", "data:image/gif;base64,"+signImage);
                if(fingerImage) $("#"+signCode).attr("src", "data:image/gif;base64,"+fingerImage);
            }
        }
    };

    ImgSignPlugin.prototype.getEditBox = function () {
        return this.editBox;
    };

    ImgSignPlugin.prototype.getValue = function () {
        return (this.editBox)[0].src;
    };

    ImgSignPlugin.prototype.setValue = function (value) {
        this.editBox.attr("src", "data:image/png;base64," + value);
    };

    ImgSignPlugin.prototype.getPrintValue = function () {
        return this.getValue();
    };

    ImgSignPlugin.prototype.getScoreValue = function () {
        return "";
    };

    ImgSignPlugin.prototype.disable = function () {

    };

    ImgSignPlugin.prototype.enable = function () {

    };

    ImgSignPlugin.prototype.clear = function () {
        this.editBox.attr("src", "");
    };

    ImgSignPlugin.prototype.validate = function () {
        if (this.areaItem.Required && this.getValue() == "") {
            return false;
        } else {
            return true;
        }
    };

    return ImgSignPlugin;
}());


/**
 * 编辑框控件
 * @param {*} opts 
 */
function EditPlugin(opts) {
    this.target = opts.target;
    this.areaItem = opts.areaItem;
    this.editBoxRect = opts.editBoxRect;
    this.code = opts.areaItem.Code;
    this.editType = opts.areaItem.Type;
    this.onValueChanged = opts.onValueChanged;
    this.getUserFillData = opts.getUserFillData;
    this.editBox = null;
    this.RowId = "";
    this.originalValue = null;
    this.dataSource = null;
    this.pageNo = opts.pageNo;
    this.operDatas = [];

    this.init();
}

EditPlugin.prototype = {
    constructor: EditPlugin,

    init: function () {
        var target = this.target;
        this.parent = $(target).parent();
        var offsetX = target.getBoundingClientRect().left - target.parentNode.getBoundingClientRect().left;
        var offsetY = target.getBoundingClientRect().top - target.parentNode.getBoundingClientRect().top;
        this.parent.css({
            "position": "relative"
        });
        this.boxHeightScale = 1.2;
        this.editBoxPlugin = null;
        this.render(offsetX, offsetY);
    },

    render: function (offsetX, offsetY) {
        var $this = this;
        this.editContainer = $('<div></div>');
        this.editContainer.css({
            "position": "absolute",
            "top": $this.editBoxRect.top - 6, //+ offsetX - 4,
            "left": $this.editBoxRect.left, //+ offsetY - 3,
            "width": $this.editBoxRect.width, //+ 5,
            "height": $this.editBoxRect.height, //+ 5,
            "float": "left",
            "padding": 0,
            "margin": 0,
            "z-index": 100
        });
        $(this.parent).append(this.editContainer);

        switch (this.editType) {
            case "textbox":
                this.editBoxPlugin = new TextboxPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "checkbox":
                this.editBoxPlugin = new CheckboxPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "combobox":
                this.editBoxPlugin = new ComboboxPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "datebox":
                this.editBoxPlugin = new DateboxPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "datetimebox":
                this.editBoxPlugin = new DatetimeboxPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "timespinner":
                this.editBoxPlugin = new TimespinnerPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "numberspinner":
                this.editBoxPlugin = new NumberspinnerPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "textarea":
                this.editBoxPlugin = new TextareaPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer);
                break;
            case "signature":
                this.editBoxPlugin = new SignaturePlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer, this.getUserFillData);
                break;
            case "imgsign":
                this.editBoxPlugin = new ImgSignPlugin(this.areaItem, this.editBoxRect, this.onValueChanged, this.editContainer, this.getUserFillData);
                break;
            default:
                break;
        }

    },

    setValue: function (value) {
        if (this.editBoxPlugin) this.editBoxPlugin.setValue(value);
    },

    getValue: function () {
        var value = "";
        if (this.editBoxPlugin) value = this.editBoxPlugin.getValue();
        return value;
    },

    getPrintValue: function () {
        var value = "";
        if (this.editBoxPlugin) value = this.editBoxPlugin.getPrintValue();
        return value;
    },

    getScoreValue: function () {
        var value = "";
        if (this.editBoxPlugin) value = this.editBoxPlugin.getScoreValue();
        return value;
    },

    disable: function () {
        if (this.editBoxPlugin) this.editBoxPlugin.disable();
    },

    enable: function () {
        if (this.editBoxPlugin) this.editBoxPlugin.enable();
    },

    clear: function () {
        if (this.editBoxPlugin) this.editBoxPlugin.clear();
    },

    destroy: function () {
        this.editContainer.remove();
    },

    hide: function () {
        this.editContainer.hide();
    },

    show: function () {
        this.editContainer.show();
    },

    validate: function () {
        if (this.editBoxPlugin) {
            return this.editBoxPlugin.validate();
        } else {
            return true;
        }
    }
}