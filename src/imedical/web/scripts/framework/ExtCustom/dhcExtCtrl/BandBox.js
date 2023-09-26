/*
*ComponentName: FW.Ctrl.BandBox
*xType        : FWBandbox
*extendFrom   : Ext.form.TriggerFiel
*Author       :  
*Date         :  
*Date         :  
*Resume       :
*1.可以显示多个字段
*2.动态分页显示远程数据
*3.当可输入时,在文本框中输入信息，点击enter键进行后台查询
*5.可设置父控件
*6.可设置受影响的控件,可设置需重新加载的控件
*/

Ext.namespace('FW.Ctrl');

FW.Ctrl.BandBox = Ext.extend(Ext.form.TwinTriggerField, {
    /**
    * 第一个触发器的css类，有一个删除符号图片
    */
    trigger1Class: 'x-form-clear-trigger',

    /**
    * 第二个触发器的css类，有一个放大镜/查询符号图片
    */
    trigger2Class: 'x-form-search-trigger',
    // list的shadow模式
    shadow: 'sides',
    // list的样式类
    listClass: '',
    // list的对齐方式。默认为文本输入框的左下角。
    listAlign: 'tl-bl?',
    /**
    * @cfg {Number} width BandBox控件的宽度。默认180。
    */
    width: 180,

    /**
    * @cfg {String} mode 数据来源。接受以下值：
    * 	-	'remote': 默认，加载远程服务器中的数据，单击第二个触发器将自动的加载数据（即调用Store.load()），
    * 	-	'local': 加载本地数据。例如：

     */
    mode: 'remote',
    loginUrl: '../LogIn.aspx',
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
    //父控件Id,当父控件的值为空时，点击本控件将不显示下拉列表
    parentCtrlId: '',
    // 服务端数据列映射
    storeExpression: null,
    //每页显示的数据数
    pageSize: 20,
    // 提示信息
    tooltip: '',
    /**
    * @cfg {String} displayField（必须） 显示在输入文本框中的值，
    */
    displayField: '',

    /**
    * @cfg {String} valueField （可选）返回选中行的valueField列的值。
    */
    valueField: '',
    /**
    * @cfg {Ext.data.Record} selectedRecord 当前选中的记录。
    */
    selectedRecord: null,

    /*用于设定控件的初始值*/
    defaultValue: '',
    //grid高度
    gridHeight: 250,
    gridWidth: null,


    /**
    * @cfg {Object} view（必须）BandBox的下拉列表。view中有以下属性：
    * 		- @cfg {Array} columns（必须） 下拉列表的列定义，可参考GridPanel的columns。
    * 		- @cfg {Number} height（可选） 下拉列表的高度，可参考GridPanel的height。
    * 		- @cfg {Number} wdith（可选） 下拉列表的宽度，可参考GridPanel的width。
    * 		- @cfg {String} title（可选） 下拉列表的标题，可参考GridPanel的title。
    * 		- @cfg {String} loadMask（可选） Store加载数据时显示蒙版效果时显示的信息，
    * 			可参考GridPanel的loadMask。
    * 
    * 例如：
    view: {
    columns: [
    {header: 'postId', width: 160, dataIndex: 'postId'},
    {header: 'title', width: 75, dataIndex: 'title'},
    {header: 'topicId', width: 75,dataIndex: 'topicId'},
    {header: 'author', width: 75, dataIndex: 'author'},
    {header: 'lastPost', width: 85, dataIndex: 'lastPost'}
    ],
    viewHeight: 300,
    viewWidth: 500,
    title: 'Array Grid'
    }
    */

    initComponent: function() {
        FW.Ctrl.BandBox.superclass.initComponent.call(this);

        this.addEvents(
            'expand',
            'collapse',
            'select',
            'reconfigure'
        );

        this.initStore();
    },

    /**
    * 初始化Store。
    */
    initStore: function() {
        if (this.displayField != '' && this.valueField != '' && this.storeExpression != null) {
            //初始化store
            var hproxy = new Ext.data.HttpProxy({
                url: this.queryUrl.trim()
            });
            hproxy.addListener('loadexception', this.loadFailture, this);
            this.store = new Ext.data.Store({
                proxy: hproxy,
                reader: new Ext.data.JsonReader({ root: 'data', totalProperty: 'totalProperty' }, this.storeExpression)
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

            var cols = this.generateCols(this.storeExpression);
            cols.unshift(new Ext.grid.RowNumberer());
            if (!this.gridWidth) {
                this.gridWidth = this.width;
            }
            this.view = {
                columns: cols,
                width: this.gridWidth,
                loadMask: { msg: 'Loading...' }
            };
        }
    },

    /**
    * private. 生成BandBox的列。数据来自服务器(this.storeExpression)
    * @param {Array} customExp 必须是数组
    * @return {Array} 返回一个数组
    */
    generateCols: function(storeExp) {
        var cols = [];
        var objCustom, objAdd;
        for (var i = 0, len = storeExp.length; i < len; i++) {
            objCustom = storeExp[i];
            objAdd = {};
            objAdd.dataIndex = objCustom['name'];
            objAdd.header = objCustom['caption'];
            if (objCustom['width']) {
                objAdd.width = objCustom['width'];
            }
            if (objCustom['hidden']) {
                objAdd.hidden = objCustom['hidden'];
            }
            cols.push(objAdd);
        }
        return cols;
    },

    // private
    onRender: function(ct, position) {
        FW.Ctrl.BandBox.superclass.onRender.call(this, ct, position);
        if (Ext.isGecko) {
            this.el.dom.setAttribute('autocomplete', 'off');
        }
        //this.initEvents();
        this.initList();
        if (Ext.isIE6 || Ext.isIE7 || Ext.isIE8) {
            this.el.setStyle('border-bottom-width', 2);
        }
    },

    // private
    afterRender: function() {
        FW.Ctrl.BandBox.superclass.afterRender.call(this);
        //设置提示信息
        this.tooltip = Ext.util.Format.trim(this.tooltip);
        if (this.tooltip != '') {
            new Ext.ToolTip({ target: this.el, trakMouse: false, maxWidth: 200, minWidth: 100, html: this.tooltip });
        }
    },

    // override. 初始化事件
    initEvents: function() {
        FW.Ctrl.BandBox.superclass.initEvents.call(this);
        this.el.on('keyup', function(e, target) {
            if (e.getKey() == e.ENTER) {
                if (this.parentCtrlId != '' && Ext.getCmp(this.parentCtrlId).getValue() == '') {
                    return;
                }
                if (this.isExpanded()) {
                    this.doSearch(false);
                    this.el.focus();
                } else {
                    this.onFocus({});
                    this.expand();
                    this.doSearch(false);
                    this.el.focus();
                }

                this.triggers[0].show();
                e.stopPropagation();
            }
            if (e.getKey() == e.DOWN) {
                this.pressDownKey(e)
            }
            if (e.getKey() == e.ESC) {
                this.collapse();
            }
            if (this.getRawValue().trim() == "") {
                this.setValue("");
                this.el.dom.value = '';
                this.triggers[0].hide();
                this.selectedRecord = null;
            }
        }, this);

        this.on('blur', this.onBeforeBlur, this);
    },

    // private. 初始化list（BandBox的下拉列表），其为浮动的，用于包裹一个Ext.grid.GridPanel
    initList: function() {
        if (!this.list) {
            var cls = 'x-combo-list',
                listParent = Ext.getDom(this.getListParent() || Ext.getBody()),
                zindex = parseInt(Ext.fly(listParent).getStyle('z-index'), 10);
            if (!zindex) {
                zindex = this.getParentZIndex();
            }
            this.list = new Ext.Layer({
                parentEl: listParent,
                shadow: this.shadow,
                cls: [cls, this.listClass].join(' '),
                constrain: false,
                zindex: (zindex || 12000) + 5
            });
        }
    },

    // 取得list的父容器
    getListParent: function() {
        return document.body;
    },
    // 取得this的父容器的z-index
    getParentZIndex: function() {
        var zindex;
        if (this.ownerCt) {
            this.findParentBy(function(ct) {
                zindex = parseInt(ct.getPositionEl().getStyle('z-index'), 10);
                return !!zindex;
            });
        }
        return zindex;
    },

    // 第一个触发器被Click时调用
    onTrigger1Click: function() {
        this.el.dom.value = '';
        this.triggers[0].hide();
        this.selectedRecord = null;

        this.onBeforeBlur();
    },

    // 第二个触发器被Click时调用
    onTrigger2Click: function() {
        if (this.readOnly || this.disabled) {
            return;
        }
        if (this.parentCtrlId != '' && Ext.getCmp(this.parentCtrlId).getValue() == '') {
            return;
        }
        var v = this.getRawValue();

        if (this.isExpanded()) { 					// 已展开
            this.doSearch(true);
            this.el.focus();
        } else {									//	已收起
            this.onFocus({});
            this.expand();
            this.doSearch(true);
            this.el.focus();
        }

        this.triggers[0].show();
    },

    // 展开BandBox下拉列表
    expand: function() {
        if (this.isExpanded() || !this.hasFocus) {
            return;
        }
        if (this.gridPanel == null) {
            this.generateGridPanel();
        }
        this.list.alignTo.apply(this.list, [this.el].concat(this.listAlign));
        var listParent = Ext.getDom(this.getListParent() || Ext.getBody()),
        zindex = parseInt(Ext.fly(listParent).getStyle('z-index'), 10);
        if (!zindex) {
            zindex = this.getParentZIndex();
        }
        if (zindex) {
            this.list.setZIndex(zindex + 5);
        }
        this.list.show();

        if (Ext.isGecko2) {
            this.innerList.setOverflow('auto'); // necessary for FF 2.0/Mac
        }
        // 侦听body中的事件，当在body中滚动鼠标滚轮或单击鼠标时，若已展开BandBox下拉列表，则将其隐藏。
        this.mon(Ext.getDoc(), {
            scope: this,
            mousewheel: this.collapseIf,
            mousedown: this.collapseIf
        });
        this.fireEvent('expand', this);
    },

    // 收起BandBox下拉列表
    collapse: function() {
        if (!this.isExpanded()) {
            return;
        }
        this.list.hide();

        // 移除侦听body中的事件
        Ext.getDoc().un('mousewheel', this.collapseIf, this);
        Ext.getDoc().un('mousedown', this.collapseIf, this);
        this.fireEvent('collapse', this);
    },

    // private 是否收起BandBox下拉列表
    collapseIf: function(e) {
        if (!this.isDestroyed && !e.within(this.wrap) && !e.within(this.list)) {
            this.collapse();
        }
    },

    /**
    * 如果下拉列表是展开的则返回true，否则返回false。
    * @return {Boolean}
    */
    isExpanded: function() {
        return this.list && this.list.isVisible();
    },

    /**
    * 该方法仅用于初始化一个GridPanel对象和PagingToolbar。
    * 若view中设置了高宽就是使用view中的高宽，否则就根据getColumnModel().getTotalWidth()设置宽度，
    * 高度为autoHeight:true(即自动)
    * @private
    */
    generateGridPanel: function() {
        if (this.store && this.view) {
            this.gridPanel = new Ext.grid.GridPanel({
                store: this.store,
                columns: this.view.columns,
                width: this.view.width,
                height: this.gridHeight,
                title: this.view.title,
                loadMask: this.view.loadMask,
                stripeRows: true,
                stateful: true,
                columnLines: true,
                enableHdMenu: false,
                bodyCssClass: this.itemStyle,
                stateId: 'grid-' + this.list.id,
                cls: this.cls,
                listeners: {
                    rowclick: this.rowClick,
                    keydown: this.gridPanelKeydown,
                    scope: this
                }
            });

            this.gridPanel.render(this.list);
            this.list.applyStyles('text-align:left;');
            this.changeGridPanelHeight();
            // 没有设置宽度就使用getColumnModel().getTotalWidth()的值来设置宽度
            if (!this.view.width) {
                var columnModelWidth = this.gridPanel.getColumnModel().getTotalWidth() + 22;
                this.gridPanel.width = columnModelWidth;
                this.gridPanel.setWidth(columnModelWidth);
            }
            // 是否显示分页条
            if (this.pageSize > 0) {
                this.pagingBar = new Ext.PagingToolbar({
                    store: this.store,
                    pageSize: this.pageSize,
                    width: this.gridPanel.width
                });
                this.pagingBar.render(this.list);
            }

            // resizable工具条
            this.resizableBar();
        }
    },

    // private。单击GridPanel中某行将执行该函数。
    rowClick: function(gridPanel, rowIndex, e) {
        var oldValue = this.getValue();
        var r = this.selectedRecord = this.store.getAt(rowIndex);
        this.setValue(r.data[this.displayField]);
        this.collapse();
        this.fireEvent('select', this, r, rowIndex);
        //用于更新受影响的控件
        if (oldValue != this.getValue()) {
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

    /**
    * 取得valueField对应列的值或者输入文本框中的值。
    * 	-	若配置了valueField选项，且选中下拉列表中的某行，则返回的是valueField对应列的值，否则返回null。
    * 	-	若没有配置valueField选项，则返回的是输入文本框中的值。
    * @return {String} 输入文本框中的值或者valueField对应列的值。
    */
    getValue: function() {
        if (this.valueField) {
            if (Ext.isDefined(this.value) && this.selectedRecord) {
                return this.selectedRecord.data[this.valueField];
            } else {
                return '';
            }
        } else {
            return FW.Ctrl.BandBox.superclass.getValue.call(this);
        }
    },

    // 取得输入文本框中的值。
    getRawValue: function() {
        return FW.Ctrl.BandBox.superclass.getRawValue.call(this);
    },

    doSearch: function(queryAll) {
        var paramsNow = {};
        if (!queryAll) {
            paramsNow[this.name || this.id] = this.getRawValue();
            this.store.baseParams[this.name || this.id] = this.getRawValue();
        }
        else {
            paramsNow[this.name || this.id] = '';
            this.store.baseParams[this.name || this.id] = '';
        }
        var paramNames = this.store.paramNames;
        paramsNow[paramNames.start] = 0;
        paramsNow[paramNames.limit] = this.pageSize;
        this.store.load({ params: paramsNow, callback: this.handleSearchResult });
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


    /**
    * private. store加载完数据后改变GridPanel的高度
    */
    changeGridPanelHeight: function() {
        this.store.on('load', function(obj, records) {
            if (!this.gridPanel.height) { // gridPanel没有配置height的处理
                var height = (this.store.getCount() + 1) * 23;
                if (height < 150) {
                    this.gridPanel.setHeight(150);
                } else {
                    this.gridPanel.setHeight(height);
                }
            }
            this.list.setHeight(this.gridPanel.getHeight() +
    			(this.pagingBar ? this.pagingBar.getHeight() : 0));
        }, this);
    },

    /**
    * private. 给this.list加上resizable工具条
    */
    resizableBar: function() {
        var resizer = new Ext.Resizable(this.list.id, {
            handles: 'se',
            minHeight: 100,
            pinned: true
        });
        resizer.on('resize', this.resizableHandler, this);
    },
    // private
    resizableHandler: function(target, width, height, e) {
        if (this.pagingBar) {
            var h = height - this.pagingBar.getHeight();
            this.gridPanel.setSize(width, h);
            this.pagingBar.setWidth(width);
        } else {
            this.gridPanel.setSize(width, height);
        }
        this.gridPanel.syncSize();
        // 修正bandbox下拉框拖拽改变大小后有阴影
        this.list.show();
    },
    // private
    validateBlur: function() {
        return !this.list || !this.list.isVisible();
    },
    // 焦点离开BandBox时触发
    onBeforeBlur: function(e, target, option) {
        var selRec = this.selectedRecord
        if (selRec) {
            var df = selRec.data[this.displayField];
            if (this.getRawValue() != df && this.getRawValue().trim() == "") {
                this.setValue("");
            }
            else {
                this.setValue(df);
            }
        } else {
            this.setValue('');
        }
        this.validate();
    },

    // override. 验证输入是否符合要求
    validateValue: function(value) {
        if (value.length < 1) {
            if (this.allowBlank) {
                this.clearInvalid();
                return true;
            } else {
                this.markInvalid(this.blankText);
                return false;
            }
        }
        return true;
    },

    /**
    * 按下方向键(↓)
    */
    pressDownKey: function(e) {
        if (this.isExpanded()) {
            this.gridPanel.getSelectionModel().selectFirstRow();
            this.gridPanel.getView().focusRow(0);
        }
    },

    /**
    * 侦听GridPanel的keydown事件。按下ENTER键后选中行，按下ESC键收起GridPanel。
    */
    gridPanelKeydown: function(e) {
        if (e.getKey() == e.ENTER) {
            var record = this.gridPanel.getSelectionModel().getSelected();
            this.rowClick(this.gridPanel, this.store.indexOf(record));
        }
        if (e.getKey() == e.ESC) {
            this.collapse();
            this.el.focus();
        }
        // 取消事件冒泡，避免可能影响其它组件的keyDown事件，例如Button设置了快捷键Enter
        e.stopPropagation();
    },

    //设定初始值
    setInitValue: function(v) {
        var text = '';
        if (this.valueField) {
            var r = this.findRecord(this.valueField, v);
            this.selectedRecord = r;
            if (r) {
                text = r.data[this.displayField];
            } else if (Ext.isDefined(this.valueNotFoundText)) {
                text = this.valueNotFoundText;
            }
        }
        FW.Ctrl.BandBox.superclass.setValue.call(this, text);

        this.value = v;
    },

    // private
    findRecord: function(prop, value) {
        var record;
        if (this.store.getCount() > 0) {
            this.store.each(function(r) {
                if (r.data[prop] == value) {
                    record = r;
                    return false;
                }
            });
        }
        return record;
    },

    setValueAndLoad: function(v) {

        this.defaultValue = v;
        this.store.parentControl = this;
        this.store.load({ callback: this.handleSearchResult });
    },
    setInitValueAndText: function(v, t) {
        var data = {};
        data[this.valueField] = v;
        data[this.displayField] = t;
        this.selectedRecord = {};
        this.selectedRecord.data = data
        FW.Ctrl.BandBox.superclass.setValue.call(this, t);
        return this;
    },

    handleSearchResult: function(records, options, success) {
        if (success) {
            if (this.parentControl) {
                this.parentControl.defaultValue = Ext.util.Format.trim(this.parentControl.defaultValue);
                if (this.parentControl.defaultValue != '') {
                    this.parentControl.setInitValue(this.parentControl.defaultValue);
                    this.parentControl.defaultValue = '';
                    this.parentControl = null;
                }
            }
        }
    },

    loadFailture: function(htproxy, options, response, error) {
        if (response.status == "503") {
            FW.CommonMethod.ShowMessage("E", "页面超时，请重新登录！");
        }
        else {
            FW.CommonMethod.ShowMessage("E", "操作失败！");
        }
    }

});

Ext.reg('FWBandbox', FW.Ctrl.BandBox);