/*
*ComponentName: FW.Ctrl.ListBox
*xType        : FWListbox
*extendFrom   : Ext.form.Field
*Author       : zhangyubo
*Date         :  
*Date         :  
*Resume       :
*1.可设置本地数据
*2.当远程获取数据时,一次性加载所有数据(当查询条件改变时,点击将再次查询)
*4.可设置受影响的控件,可设置需重新加载的控件
*/
Ext.namespace('FW.Ctrl');

FW.Ctrl.ListBox = Ext.extend(Ext.form.Field, {
    /**
    * @cfg {String} legend Wraps the object with a fieldset and specified legend.
    */
    /**
    * @cfg {Ext.ListView} view The {@link Ext.ListView} used to render the multiselect list.
    */
    /**
    * @cfg {String/Array} dragGroup The ddgroup name(s) for the MultiSelect DragZone (defaults to undefined).
    */
    /**
    * @cfg {String/Array} dropGroup The ddgroup name(s) for the MultiSelect DropZone (defaults to undefined).
    */
    /**
    * @cfg {Boolean} ddReorder Whether the items in the MultiSelect list are drag/drop reorderable (defaults to false).
    */
    ddReorder: false,
    /**
    * @cfg {Object/Array} tbar The top toolbar of the control. This can be a {@link Ext.Toolbar} object, a
    * toolbar config, or an array of buttons/button configs to be added to the toolbar.
    */
    /**
    * @cfg {String} appendOnly True if the list should only allow append drops when drag/drop is enabled
    * (use for lists which are sorted, defaults to false).
    */
    appendOnly: false,
    /**
    * @cfg {Number} width Width in pixels of the control (defaults to 100).
    */
    width: 100,
    /**
    * @cfg {Number} height Height in pixels of the control (defaults to 100).
    */
    height: 100,
    /**
    * @cfg {String/Number} displayField Name/Index of the desired display field in the dataset (defaults to 0).
    */
    displayField: 0,
    /**
    * @cfg {String/Number} valueField Name/Index of the desired value field in the dataset (defaults to 1).
    */
    valueField: 1,
    /**
    * @cfg {Boolean} allowBlank False to require at least one item in the list to be selected, true to allow no
    * selection (defaults to true).
    */
    allowBlank: true,
    /**
    * @cfg {Number} minSelections Minimum number of selections allowed (defaults to 0).
    */
    minSelections: 0,
    /**
    * @cfg {Number} maxSelections Maximum number of selections allowed (defaults to Number.MAX_VALUE).
    */
    maxSelections: Number.MAX_VALUE,
    /**
    * @cfg {String} blankText Default text displayed when the control contains no items (defaults to the same value as
    * {@link Ext.form.TextField#blankText}.
    */
    blankText: Ext.form.TextField.prototype.blankText,
    /**
    * @cfg {String} minSelectionsText Validation message displayed when {@link #minSelections} is not met (defaults to 'Minimum {0}
    * item(s) required').  The {0} token will be replaced by the value of {@link #minSelections}.
    */
    minSelectionsText: 'Minimum {0} item(s) required',
    /**
    * @cfg {String} maxSelectionsText Validation message displayed when {@link #maxSelections} is not met (defaults to 'Maximum {0}
    * item(s) allowed').  The {0} token will be replaced by the value of {@link #maxSelections}.
    */
    maxSelectionsText: 'Maximum {0} item(s) allowed',
    /**
    * @cfg {String} delimiter The string used to delimit between items when set or returned as a string of values
    * (defaults to ',').
    */
    delimiter: ',',
    /**
    * @cfg {Ext.data.Store/Array} store The data source to which this MultiSelect is bound (defaults to <tt>undefined</tt>).
    * Acceptable values for this property are:
    * <div class="mdetail-params"><ul>
    * <li><b>any {@link Ext.data.Store Store} subclass</b></li>
    * <li><b>an Array</b> : Arrays will be converted to a {@link Ext.data.ArrayStore} internally.
    * <div class="mdetail-params"><ul>
    * <li><b>1-dimensional array</b> : (e.g., <tt>['Foo','Bar']</tt>)<div class="sub-desc">
    * A 1-dimensional array will automatically be expanded (each array item will be the combo
    * {@link #valueField value} and {@link #displayField text})</div></li>
    * <li><b>2-dimensional array</b> : (e.g., <tt>[['f','Foo'],['b','Bar']]</tt>)<div class="sub-desc">
    * For a multi-dimensional array, the value in index 0 of each item will be assumed to be the combo
    * {@link #valueField value}, while the value at index 1 is assumed to be the combo {@link #displayField text}.
    * </div></li></ul></div></li></ul></div>
    */

    // private
    defaultAutoCreate: { tag: "div" },

    /**
    * @cfg {Array/json} dataItems 初始化列表的数据。数据格式为[{value:'1',name:'北京'},{value:'2',name:'上海'}]，
    * 即['key', 'value']的格式。也可通过setValue()方法初始化数据。
    */
    dataItems: null,

    //查询的地址
    queryUrl: null,
    //查询数据的参数,为json
    queryParams: null,
    //上次查询的参数
    lastPrams: null,
    //查询时需取得某些控件的值进行查询,在此设定控件的ID
    queryCtrlId: '',
    //值改变时,需重新加载的控件ID
    reloadCtrlId: '',
    //值改变时,需清空值的控件的ID
    resetCtrlId: '',
    // 服务端数据列映射
    storeExpression: null,
    // 提示信息
    tooltip: '',
    /*用于设定控件的初始值*/
    defaultValue: "",
    hideHeader: true,

    // private
    initComponent: function() {
        this.mode = 'local';
        FW.Ctrl.ListBox.superclass.initComponent.call(this);
        this.initStore();

        this.addEvents({
            'dblclick': true,
            'click': true,
            'change': true,
            'drop': true
        });
    },

    initStore: function() {
        this.store = new Ext.data.JsonStore({ fields: [], data: [] });
        if (this.dataItems != null) {
            if (Ext.isArray(this.dataItems)) {
                var allFields = [];
                for (fieldName in this.dataItems[0]) {
                    if (this.dataItems[0].hasOwnProperty(fieldName)) {
                        allFields.push(fieldName);
                    }
                }
                this.store = new Ext.data.JsonStore({ fields: allFields, data: this.dataItems });
            }
            else {
                this.store = Ext.StoreMgr.lookup(this.store);
            }
        }
        else {
            if (this.queryUrl != '' && this.queryUrl != null) {
                this.mode = 'remote';
                //读取远程数据
                var hproxy = new Ext.data.HttpProxy({
                    url: this.queryUrl
                });
                hproxy.addListener('loadexception', this.loadFailture, this);
                this.store = new Ext.data.Store({
                    proxy: hproxy,
                    reader: new Ext.data.JsonReader({ root: 'data' }, this.storeExpression)
                });
                this.store.on('beforeload', function(objStore, opt) {
                    var paramsNow = this.getParams();
                    for (var prop in paramsNow) {
                        opt.params[prop] = paramsNow[prop];
                    }
                    if (this.needQuery(opt.params)) {
                        this.lastPrams = opt.params;
                        return true;
                    }
                    return false;
                }, this);
            }
        }

    },

    needQuery: function(params) {
        if (this.lastPrams == null) {
            return true;
        }
        for (var prop in params) {
            if (params[prop] != this.lastPrams[prop]) {
                return true;
            }
        }
        for (var prop in this.lastPrams) {
            if (params[prop] != this.lastPrams[prop]) {
                return true;
            }
        }
        return false;
    },

    // private
    getParams: function() {
        var params = {};
        if (this.queryParams != null) {
            for (var prop in this.queryParams) {
                params[prop] = this.queryParams[prop];
            }
        }
        if (this.queryCtrlId.trim() != '') {
            var ctrlIds = this.queryCtrlId.trim().split(',');
            for (var i = 0; i < ctrlIds.length; i++) {
                var ctrl = Ext.getCmp(ctrlIds[i]);
                if (ctrl) {
                    params[ctrl.name || ctrl.id] = ctrl.getValue();
                }
            }
        }
        return params;
    },

    // private
    onRender: function(ct, position) {
        FW.Ctrl.ListBox.superclass.onRender.call(this, ct, position);

        var fs = this.fs = new Ext.form.FieldSet({
            renderTo: this.el,
            title: this.legend,
            height: this.height,
            width: this.width,
            style: "padding:0;",
            tbar: this.tbar
        });
        fs.body.addClass('listBoxselect');

        var cols = this.generateCols(this.storeExpression);
        this.view = new Ext.ListView({
            multiSelect: true,
            store: this.store,
            height: this.height,
            //columns: [{ header: 'Value', width: 1, dataIndex: this.displayField}],
            columns: cols,
            columnSort:false,
            //selectedClass:'listBoxselect-selected',
            hideHeaders: this.hideHeader
        });

        fs.add(this.view);

        this.view.on('click', this.onViewClick, this);
        this.view.on('beforeclick', this.onViewBeforeClick, this);
        this.view.on('dblclick', this.onViewDblClick, this);

        this.hiddenName = this.name || Ext.id();
        var hiddenTag = { tag: "input", type: "hidden", value: "", name: this.hiddenName };
        this.hiddenField = this.el.createChild(hiddenTag);
        this.hiddenField.dom.disabled = this.hiddenName != this.name;
        fs.doLayout();
    },
    /**
    * private. 生成BandBox的列。数据来自服务器(this.storeExpression)
    * @param {Array} customExp 必须是数组
    * @return {Array} 返回一个数组
    */
    generateCols: function(storeExp) {
        var cols = [];
        if (storeExp) {
        var objCustom, objAdd;
        for (var i = 0, len = storeExp.length; i < len; i++) {
            objCustom = storeExp[i];
            objAdd = {};
            objAdd.dataIndex = objCustom['name'];
            if (objCustom['caption']) {
                objAdd.header = objCustom['caption'];
                this.hideHeader = false;
            }
            if (objCustom['width']) {
                objAdd.width = objCustom['width'];
            }
            if (!objCustom['hidden']) {
                //objAdd.hidden = objCustom['hidden'];
                cols.push(objAdd);
                }
            }
        }
        else {
            var objAdd = {};
            objAdd.dataIndex = this.displayField;
            objAdd.width = 1;
            cols.push(objAdd);
        }
        return cols;
    },

    // private
    afterRender: function() {
        FW.Ctrl.ListBox.superclass.afterRender.call(this);

        if (this.ddReorder && !this.dragGroup && !this.dropGroup) {
            this.dragGroup = this.dropGroup = 'MultiselectDD-' + Ext.id();
        }

        if (this.draggable || this.dragGroup) {
            this.dragZone = new FW.Ctrl.ListBox.DragZone(this, {
                ddGroup: this.dragGroup
            });
        }
        if (this.droppable || this.dropGroup) {
            this.dropZone = new FW.Ctrl.ListBox.DropZone(this, {
                ddGroup: this.dropGroup
            });
        }
        if (this.mode != 'remote' && this.defaultValue != "") {
            this.setValue(this.defaultValue);
        }

        //设置提示信息
        this.tooltip = this.tooltip.trim();
        if (this.tooltip != "") {
            new Ext.ToolTip({
                target: this.id,
                trakMouse: false,
                maxWidth: 200,
                minWidth: 100,
                html: this.tooltip
            });
        }
        this.fs.doLayout();
    },
    // private
    onViewClick: function(vw, index, node, e) {
        this.fireEvent('change', this, this.getValue(), this.hiddenField.dom.value);
        this.hiddenField.dom.value = this.getValue();
        this.fireEvent('click', this, e);
        this.validate();
        //用于更新受影响的控件
        if (this.oldValue != this.getValue()) {
            if (this.resetCtrlId != '') {
                var resetCtrl = Ext.getCmp(this.resetCtrlId);
                if (resetCtrl) {
                    resetCtrl.reset();
                }
            }
            if (this.reloadCtrlId != '') {
                var reloadCtrl = Ext.getCmp(this.reloadCtrlId);
                if (reloadCtrl) {
                    reloadCtrl.reset();
                    reloadCtrl.reloadData();
                }
            }
        }
    },
    // private
    onViewBeforeClick: function(vw, index, node, e) {
        if (this.disabled || this.readOnly) {
            return false;
        }
        this.oldValue = this.getValue();
        if (!this.multiSelect) {
            var selectionsArray = this.view.getSelectedIndexes();
            if (selectionsArray[0] != index) {
                this.view.clearSelections();
            }
        }
    },
    // private
    onViewDblClick: function(vw, index, node, e) {
        return this.fireEvent('dblclick', vw, index, node, e);
    },
    /**
    * Returns an array of data values for the selected items in the list. The values will be separated
    * by {@link #delimiter}.
    * @return {Array} value An array of string data values
    */
    getValue: function(valueField) {
        var returnArray = [];
        var selectionsArray = this.view.getSelectedIndexes();
        if (selectionsArray.length == 0) { return ''; }
        for (var i = 0; i < selectionsArray.length; i++) {
            returnArray.push(this.store.getAt(selectionsArray[i]).get((valueField != null) ? valueField : this.valueField));
        }
        return returnArray.join(this.delimiter);
    },

    /**
    * Sets a delimited string (using {@link #delimiter}) or array of data values into the list.
    * @param {String/Array} values The values to set
    */
    setValue: function(values) {
        var index;
        var selections = [];
        this.view.clearSelections();
        this.hiddenField.dom.value = '';

        if (!values || (values == '')) {
            return;
        }

        if (!Ext.isArray(values)) { values = values.split(this.delimiter); }
        for (var i = 0; i < values.length; i++) {
            index = this.view.store.indexOf(this.view.store.query(this.valueField,
                new RegExp('^' + values[i] + '$', "i")).itemAt(0));
            selections.push(index);
        }
        this.view.select(selections);
        this.hiddenField.dom.value = this.getValue();
        this.validate();
    },
    /**
    *设定初始值
    */
    setValueAndLoad: function(v) {
        this.defaultValue = v;
        this.store.parentControl = this;
        this.store.load({ callback: this.handleSearchResult });
    },
    // inherit docs
    reset: function() {
        this.setValue('');
    },

    // inherit docs
    getRawValue: function(valueField) {
        var tmp = this.getValue(valueField);
        if (tmp.length) {
            tmp = tmp.split(this.delimiter);
        }
        else {
            tmp = [];
        }
        return tmp;
    },

    // inherit docs
    setRawValue: function(values) {
        setValue(values);
    },

    // inherit docs
    validateValue: function(value) {
        if (value.length < 1) { // if it has no value
            if (this.allowBlank) {
                this.clearInvalid();
                return true;
            } else {
                this.markInvalid(this.blankText);
                return false;
            }
        }
        if (value.length < this.minSelections) {
            this.markInvalid(String.format(this.minSelectionsText, this.minSelections));
            return false;
        }
        if (value.length > this.maxSelections) {
            this.markInvalid(String.format(this.maxSelectionsText, this.maxSelections));
            return false;
        }
        return true;
    },

    // inherit docs
    disable: function() {
        this.disabled = true;
        this.hiddenField.dom.disabled = true;
        this.fs.disable();
    },

    // inherit docs
    enable: function() {
        this.disabled = false;
        this.hiddenField.dom.disabled = false;
        this.fs.enable();
    },

    // inherit docs
    destroy: function() {
        Ext.destroy(this.fs, this.dragZone, this.dropZone);
        FW.Ctrl.ListBox.superclass.destroy.call(this);
    },

    loadData: function() {
        this.store.load({ callback: this.handleSearchResult });
    },
    reloadData: function() {
        this.store.load({ callback: this.handleSearchResult });
    },
    handleSearchResult: function(records, options, success) {
        if (success) {
            if (this.parentControl) {
                this.parentControl.defaultValue = Ext.util.Format.trim(this.parentControl.defaultValue);
                if (this.parentControl.defaultValue != "") {
                    this.parentControl.setValue(this.parentControl.defaultValue);
                    this.parentControl.defaultValue = "";
                    this.parentControl = "";
                }
            }
        }
    },
    loadFailture: function(htproxy, options, response, error) {
        if (response.status == "503") {
            FW.CommonMethod.ShowMessage("E", "页面超时，请重新登录！");
        }
        else {
            FW.CommonMethod.ShowMessage("E", "加载数据失败！");
        }
    }
});

Ext.reg('FWListbox', FW.Ctrl.ListBox);