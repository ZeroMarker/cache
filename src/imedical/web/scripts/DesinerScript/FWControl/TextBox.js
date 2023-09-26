/*
*ComponentName: FW.Ctrl.TextField
*xType        : FWTextbox
*extendFrom   : Ext.form.TextField
*Author       : zhangyubo
*Date         :  
*Date         :  
*Resume       :指定文本框类型，能进行验证
*/

Ext.namespace('FW.Ctrl');

Ext.apply(Ext.form.VTypes, {
    'age': function(v, field) {
        if (v == '') {
            return true;
        }
        var age = /^[1-9]$|^[1-9][0-9]$|^1[01][0-9]$/;
        if (Number(v)) {
            v = parseInt(v, 10);
            if (age.test(v)) {
                field.setRawValue(v);
                return true;
            }
            else {
                return false;
            }
        }
        return false;
    },
    'ageText': '请输入正确的年龄(1-120岁)',
    'ageMask': /[0-9]/i,

    'price': function(v, field) {
        if (v == '') {
            return true;
        }
        var price = /^[0-9]{0,9}$|^[0-9]{0,9}[\.][0-9]{1,2}$|^0$/;
        if (v.length > 1 && v.indexOf('0') == 0 && v.indexOf('0.') != 0) {
            v = v.substr(1, v.length - 1);
            if (price.test(v)) {
                field.setRawValue(v);
                return true;
            }
        }
        return price.test(v);
    },
    'priceText': '请输入正确的价格(0-999999999.99)',
    'priceMask': /[0-9.]/i,

    'amount': function(v, field) {
        if (v == '') {
            return true;
        }
        var amount = /^[0-9]*$/;
        var value = field.getValue();
        if (Number(value)) {
            v = Number(value);
            if (amount.test(v)) {
                field.setRawValue(v);
                return true;
            }
        }
        return amount.test(v);
    },
    'amountText': '请输入数字',
    'amountMask': /[0-9]/i,

    'number': function(v) {
        if (v == '') {
            return true;
        }
        var number = /^[0-9]*$/;
        return number.test(v);
    },
    'numberText': '请输入数字',
    'numberMask': /[0-9]/i,

    'password': function(v) {
        if (v == '') {
            return true;
        }
        var password = /^[a-zA-Z0-9_]*$/;
        return password.test(v);
    },
    'passwordText': '密码只能为字母,数字,下划线',
    'passwordMask': /[a-zA-Z0-9_]/i,
    
    'character': function(v) {
        if (v == '') {
            return true;
        }
        var character = /^[a-zA-Z0-9_.\/]*$/;
        return character.test(v);
    },
    'characterText': '请输入正确的地址',
    'characterMask': /[a-zA-Z0-9_.\/]/i
});

FW.Ctrl.TextBox = Ext.extend(Ext.form.TextField, {
    sideEl: undefined,
    vtype: '',
    //提示文本
    tooltip: '',
    //本控件的值改变时,需要清空值的控件Id
    resetCtrlId: '',
    //本控件的值改变时,需要重新加载的控件Id
    reloadCtrlId: '',
    beforeBlur: null,
    initComponent: function() {
        FW.Ctrl.TextBox.superclass.initComponent.apply(this);
        switch (this.vtype.toLowerCase()) {
            case "password": this.inputType = 'password';
                break;
        }
    },

    initEvents: function() {
        FW.Ctrl.TextBox.superclass.initEvents.call(this);

        if (this.maxLength != Number.MAX_VALUE) {
            this.enableKeyEvents = true;
            this.mon(this.el, 'keypress', this.onKeyPress, this);
        }
    },

    /**
    * keypress事件 在键盘按下时限制最大输入长度
    * @param {Ext.element} o事件目标
    * @param {Ext.EventObject} evt 事件对象
    */
    onKeyPress: function(o, evt) {
        if (this.el.dom.value.length >= this.maxLength) {
            this.setValue(this.el.dom.value.substr(0, this.maxLength - 1));
            return false;
        }
    },

    onRender: function(ct, position) {
        FW.Ctrl.TextBox.superclass.onRender.call(this, ct, position);

        //添加必填提示元素
        //if ((this.allowBlank == false) && !this.triggerAction) {
        //            this.sideEl = ct.createChild({
        //                id: this.id + 'sideEl',
        //                tag: 'div',
        //                html: '<font color="red">*</font>'
        //            });

        //            this.sideEl.setStyle({
        //                'padding-left': '2px',
        //                'display': 'inline-block',
        //                'display': 'inline',
        //                'left': parseInt(this.x) + parseInt(this.width),
        //                'top': parseInt(this.y) + parseInt(this.height) / 2 - parseInt(this.sideEl.getHeight()) / 2
        //            });

        //            this.sideEl.setStyle('position', 'absolute');
        //}
    },

    afterRender: function() {
        FW.Ctrl.TextBox.superclass.afterRender.call(this);
        //设置提示信息
        this.tooltip = Ext.util.Format.trim(this.tooltip);
        if (this.tooltip != '') {
            new Ext.ToolTip({ target: this.el, trakMouse: false, maxWidth: 200, minWidth: 100, html: this.tooltip });
        };
    },
    show: function() {
        Ext.form.TextField.superclass.show.apply(this);
        if (this.sideEl != undefined || this.sideEl != null)
            this.sideEl.show();
    },
    hide: function() {
        Ext.form.TextField.superclass.hide.apply(this);
        if (this.sideEl != undefined || this.sideEl != null)
            this.sideEl.hide();
    },
    onFocus: function() {
        FW.Ctrl.TextBox.superclass.onFocus.call(this);
        this.oldValue = this.getValue();
    },
    onBlur: function() {
        FW.Ctrl.TextBox.superclass.onBlur.call(this);
        if (this.oldValue != this.getValue()) {
            if (this.beforeBlur) {
                this.beforeBlur.call(this);
            }
            if (this.resetCtrlId) {
                var resetCtrl = Ext.getCmp(this.resetCtrlId);
                if (resetCtrl) {
                    resetCtrl.reset();
                }
            }
            if (!this.activeError) {
                if (this.reloadCtrlId) {
                    var reloadCtrl = Ext.getCmp(this.reloadCtrlId);
                    if (reloadCtrl) {
                        reloadCtrl.reloadData();
                    }
                }
            }
        }
    }

});

Ext.reg('FWTextBox', FW.Ctrl.TextBox);