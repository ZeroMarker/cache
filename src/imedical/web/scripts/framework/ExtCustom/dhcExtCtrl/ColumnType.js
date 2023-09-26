/**
* @class Ext.grid.BoolColumn 
* @extends Ext.grid.Column
* <p>A Column definition class which renders a Boolen data field according to a {@link #format} string.  See the
* {@link Ext.grid.Column#xtype xtype} config option of {@link Ext.grid.Column} for more details.</p>
*/
Ext.grid.BoolColumn = Ext.extend(Ext.grid.Column, {
    /**
    * @cfg {String} trueText
    * The string returned by the renderer when the column value is not falsy (defaults to <tt>'true'</tt>).
    */
    trueText: '是',
    /**
    * @cfg {String} falseText
    * The string returned by the renderer when the column value is falsy (but not undefined) (defaults to
    * <tt>'false'</tt>).
    */
    falseText: '否',
    /**
    * @cfg {String} undefinedText
    * The string returned by the renderer when the column value is undefined (defaults to <tt>'&amp;#160;'</tt>).
    */
    undefinedText: '&#160;',

    constructor: function(cfg) {
        Ext.grid.BooleanColumn.superclass.constructor.call(this, cfg);
        var t = this.trueText, f = this.falseText, u = this.undefinedText;
        this.renderer = function(v) {
            if (v === undefined) {
                return u;
            }
            if (!v || v.toLowerCase() === 'false' || v === '0' || Boolean(v) === false) {
                return f;
            }
            return t;
        };
    }
});

// apply the custom column type to the prototype
Ext.apply(Ext.grid.Column.types, {
boolColumn: Ext.grid.BoolColumn
});


/**
* @class Ext.grid.CheckBoxColumn
* @extends Ext.grid.Column
* <p>A Column definition class which renders a Boolendata field according to a {@link #format} string.  See the
* {@link Ext.grid.Column#xtype xtype} config option of {@link Ext.grid.Column} for more details.</p>
*/
Ext.grid.CheckBoxColumn = Ext.extend(Ext.grid.Column, {
    constructor: function(cfg) {
        Ext.grid.CheckBoxColumn.superclass.constructor.call(this, cfg);
    },
    renderer: function(value, metaData, record, rowIndex, colIndex, store) {
    if (value === undefined || !value || value.toLowerCase() === 'false' || value === '0' || Boolean(value) === false) {
            return "<input type=\"checkbox\" onclick=\"this.checked=!this.checked\" />";
        }
        else {
            return "<input type=\"checkbox\" onclick=\"this.checked=!this.checked\"  checked />";
        }

    }
});

// apply the custom column type to the prototype
Ext.apply(Ext.grid.Column.types, {
    checkBoxColumn: Ext.grid.CheckBoxColumn
});

/**
* @class Ext.grid.CurrencyColumn
* @extends Ext.grid.CurrencyColumn
* <p>A Column definition class which renders a Currency data field according to a {@link #format} string.  See the
* {@link Ext.grid.Column#xtype xtype} config option of {@link Ext.grid.Column} for more details.</p>
*/
Ext.grid.CurrencyColumn = Ext.extend(Ext.grid.Column, {
    /**
    * @cfg {String} format
    * A formatting string as used by {@link Ext.util.Format#number} to format a numeric value for this Column
    * (defaults to <tt>'0,000.00'</tt>).
    */
    format: '0,000.00',
    constructor: function(cfg) {
        Ext.grid.NumberColumn.superclass.constructor.call(this, cfg);
        this.renderer = Ext.util.Format.numberRenderer(this.format);
    }
});
// apply the custom column type to the prototype
Ext.apply(Ext.grid.Column.types, {
currencyColumn: Ext.grid.CurrencyColumn
});


/**
* @class Ext.grid.ImageColumn
* @extends Ext.grid.Column
* <p>A Column definition class which renders a image data field according to a {@link #format} string.  See the
* {@link Ext.grid.Column#xtype xtype} config option of {@link Ext.grid.Column} for more details.</p>
*/
Ext.grid.ImageColumn = Ext.extend(Ext.grid.Column, {
    /**
    *@cfg {Boolean} sortable 是否可排序
    */
    sortable: false,
    imgUrl:'',
    constructor: function(cfg) {
        Ext.grid.ImageColumn.superclass.constructor.call(this, cfg);
    },
    renderer: function(value, metaData, record, rowIndex, colIndex, store) {
        if (Ext.util.Format.trim(value) != "") {
            return "<img src=\"" + this.imgUrl + value + "\"  onload=\"javascript:if(this.height>this.width){if(this.height> " + this.height + "){this.height=" + this.height + ";}}else{if(this.width> " + this.width + " ){this.width=" + this.width + ";} }\"/>"
        }
        else {
            return "";
        }
    }
});

// apply the custom column type to the prototype
Ext.apply(Ext.grid.Column.types, {
imageColumn: Ext.grid.ImageColumn
});

/**
* @class Ext.grid.ButtonColumn
* @extends Ext.grid.Column
* <p>A Column definition class which renders to display an clickable element in the column<p>
*/
Ext.grid.ButtonColumn = Ext.extend(Ext.grid.Column, {
    hideable: false,
    menuDisabled: 'true',
    /**
    *@cfg {String} 图标	
    */
    icon: '',
    //点击时调用的方法
    click: null,
    //按钮上显示的文本
    Text: '',
    /**
    *@cfg {Boolean} sortable 是否可排序
    */
    sortable: false,
    header: '&#160;',
    constructor: function(cfg) {
        Ext.grid.ButtonColumn.superclass.constructor.call(this, cfg);
    },
    processEvent: function(name, e, grid, rowIndex, colIndex) {
        var ctrType = e.getTarget().attributes["type"];
        if (!ctrType) {
            ctrType = e.getTarget().parentElement.attributes["type"];
        }
        if (ctrType && ctrType.nodeValue === "btn") {
            if (name == 'click') {
                this.onClick(this, grid, rowIndex, e);
            }
        }
        return Ext.grid.ButtonColumn.superclass.processEvent.apply(this, arguments);
    },
    renderer: function(v, p, record) {
        var img = "";
        if (this.icon && this.icon != "") {
            img = "<img src='" + this.icon + "' onload='javascript:if(this.height>this.width){if(this.height> 15){this.height=15;}}else{if(this.width> 15){this.width=15;} }'>";
        }
        var s = '<div type="btn" class="gridbtn_mouseout" onmouseover="this.className=\'gridbtn_mouseover\'" onmouseout="this.className=\'gridbtn_mouseout\'" onmousedown="this.className=\'gridbtn_mousedown\'">{0} {1}</div>';
        return String.format(s, img, this.Text);
    },
    destroy: function() {
        delete this.items;
        return Ext.grid.ButtonColumn.superclass.destroy.apply(this, arguments);
    },
    onClick: function(thisCol, grid, rowIndex, e) {
        if (this.click != null) {
            var fnClick = eval(this.click);
            if (Ext.isFunction(fnClick)) {
                var record = grid.store.reader.jsonData.data[rowIndex];
                var fnResult = fnClick.call(this, grid, record);
                if (!fnResult) {
                    return;
                }
            }
        }
    }
});

// apply the custom column type to the prototype
Ext.apply(Ext.grid.Column.types, {
buttonColumn: Ext.grid.ButtonColumn
});

/**
* @class Ext.grid.LinkColumn
* @extends Ext.grid.Column
* <p>A Column definition class which renders to display an clickable element in the column<p>
*/
Ext.grid.LinkColumn = Ext.extend(Ext.grid.Column, {
    hideable: false,
    header: '&#160;',
    menuDisabled: 'true',
    /**
    *@cfg {String} 图标	
    */
    icon: '',
    //点击时调用的方法
    click: null,
    /**
    *@cfg {Boolean} sortable 是否可排序
    */
    sortable: false,

    constructor: function(cfg) {
        Ext.grid.LinkColumn.superclass.constructor.call(this, cfg);
    },

    renderer: function(v, p, record) {
        var s = "<a type=\"link\" href=\"####\">{0}{1}</a>";
        var img = "";
        if (this.icon && this.icon != "") {
            img = "<img src='" + this.icon + "' onload='javascript:if(this.height>this.width){if(this.height> 15){this.height=15;}}else{if(this.width> 15){this.width=15;} }'>";
        }
        return String.format(s, img, this.Text);
    },
    processEvent: function(name, e, grid, rowIndex, colIndex) {
        if (e.getTarget().type === "link") {
            if (name == 'click') {
                this.onClick(this, grid, rowIndex, e);
            }
        }
        return Ext.grid.LinkColumn.superclass.processEvent.apply(this, arguments);
    },
    destroy: function() {
        delete this.items;
        return Ext.grid.LinkColumn.superclass.destroy.apply(this, arguments);
    },
    onClick: function(thisCol, grid, rowIndex, e) {
        if (this.click != null) {
            var fnClick = eval(this.click);
            if (Ext.isFunction(fnClick)) {
                var record = grid.store.reader.jsonData.data[rowIndex];
                var fnResult = fnClick.call(this, grid, record);
                if (!fnResult) {
                    return;
                }
            }
        }
    }
});

// apply the custom column type to the prototype
Ext.apply(Ext.grid.Column.types, {
linkColumn: Ext.grid.LinkColumn
});