/*
*ComponentName: FW.Ctrl.DateBox
*xType        : FWDatebox
*extendFrom   : Ext.form.DateField
*Author       : zhangyubo
*Date         :  
*Resume       :用于处理日期
*/
Ext.namespace("FW.Ctrl");

FW.Ctrl.DateBox = Ext.extend(Ext.form.DateField, {
    /*用于显示提示*/
    tooltip: "",
    /*用于设定显示格式*/
    format: "Y/m/d",
    //本控件的值改变时,需要清空值的控件Id
    resetCtrlId: '',
    //本控件的值改变时,需要重新加载的控件Id
    reloadCtrlId: '',

    initComponent: function() {

    this.format = this.format.replace("YYYY", "Y");
    this.format = this.format.replace("DD", "d");
    this.format = this.format.replace("MM", "m");
    //调用父类构造函数（必须）
    FW.Ctrl.DateBox.superclass.initComponent.apply(this, arguments);
},

    afterRender: function() {
        FW.Ctrl.DateBox.superclass.afterRender.call(this);
        if (Ext.isIE6 || Ext.isIE7 || Ext.isIE8) {
            this.el.setStyle("border-bottom-width", 2);
        }
        //设置提示信息
        this.tooltip = this.tooltip.trim();
        if (this.tooltip != "") {
            new Ext.ToolTip({ target: this.el, trakMouse: false, maxWidth: 200, minWidth: 100, html: this.tooltip });
        };
    },
    
    /*
    *setFormat 
    *设置日期格式
    *parm{string} format 要设定的日期格式
    */
    setFormat: function(format) {
        this.format = format;
    },
    /*
    *setValueByFormat
    *按照指定的格式设定指定的日期
    *parm {format} format 日期格式
    *parm {string} date 指定的日期
    */
    setValueByFormat: function(format, date) {
        if (!Ext.isEmpty(format))
            this.format = format;
        FW.Ctrl.DateBox.superclass.setValue.call(this, date);
    },
   
    /*
    *getDateByFormat
    *按照指定的格式转换日期
    *parm {string} date要转换的日期字符串
    *parm {srting } format 转换的格式
    *@Return {string} 按照指定格式转换后的日期
    */
    getDateByFormat: function(date, format) {
        return Ext.util.Format.date(date, format);
    },
    /**
    * Returns the current date value of the date field.
    * @return {Date} The date value
    */
    getFormatValue : function(){
           return Ext.util.Format.date(FW.Ctrl.DateBox.superclass.getValue.call(this), this.format);
       },
       
    onFocus: function() {
        FW.Ctrl.DateBox.superclass.onFocus.call(this);
        this.oldValue = this.getValue();
    },
    onBlur: function() {
        FW.Ctrl.DateBox.superclass.onBlur.call(this);
        if (this.oldValue != this.getValue()) {
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

Ext.reg('FWDatebox', FW.Ctrl.DateBox);