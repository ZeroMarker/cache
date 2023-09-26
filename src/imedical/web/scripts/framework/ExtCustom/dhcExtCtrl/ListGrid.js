/*
*ComponentName: FW.Ctrl.ListGrid
*xType        : FWListGrid
*extendFrom   : Ext.grid.GridPanel
*Author       : zhangyubo
*Date         :  
*Date         :  
*Resume       :
*1.设置好grid的查询地址，参数后，调用loadData方法可直接查询
*/
Ext.ns("FW.Ctrl");
/**
*@constructor
*@param {Object} config The configuration options
*/
FW.Ctrl.ListGrid = Ext.extend(Ext.grid.GridPanel, {
    //该grid的所有列,[{ colName:'..', dataIndex:'..', tooltip: '..', header: '..', sortable: true', width: 30, hidden:false},...]
    allColumns: null,
    //查询的地址
    queryUrl: null,
    loginUrl: '../LogIn.aspx',
    //查询数据的参数,为json
    queryParams: null,
    //查询时需取得某些控件的值进行查询,在此设定控件的ID
    queryCtrlId: '',
    //取得参数的方法
    getParamFn: null,
    /**@cfg {Boolean}	paging false to not create pagingToolbar in the bbar.
    */
    paging: true,
    /**
    *@cfg {Number} pageSize pagingToolbar.pageSize. default 20.
    */
    pageSize: 20,
    autoDestroy: true,
    autoScroll: true,
    frame: true,
    split: true,
    border: true,
    bodyBorder: true,
    headerAsText: true,
    columnLines: true,
    loadMask: true,
    loadMask: { msg: '正在加载数据,请稍侯……' },
    stripeRows: false,
    multiSelect: false,
    showRowNo: true,
    showSelectColumn: true,
    //是否准许收缩 
    collapsible: false,
    //默认排序
    defaultSort: '',
    /**
    *@private
    */
    initComponent: function(config) {
        this.bbar = new Ext.PagingToolbar({ pageSize: this.pageSize });
        FW.Ctrl.ListGrid.superclass.initComponent.call(this, config);
        if (this.region && this.region=="center" && isNaN(this.width)){
        	this.autoWidth = true;
        }
        //this.height = this.height + 24;
        //this.width = this.width + 16;
        var gridColumns = this.allColumns;
        var checkboxCol = null;
        gridColumns.reverse();
        if (gridColumns) {
            if (this.showSelectColumn) {
                if (!Ext.isString(this.width)) {
                	this.width = this.width + 20;
                }
                if (this.multiSelect) {
                    checkboxCol = new Ext.grid.CheckboxSelectionModel({ singleSelect: false });
                    gridColumns.push(checkboxCol);
                }
                else {
                    checkboxCol = new Ext.grid.CheckboxSelectionModel({ singleSelect: true });
                    gridColumns.push(checkboxCol);
                }
            }
            if (this.showRowNo) {
                if (!Ext.isString(this.width)) {
                	this.width = this.width + 23;
	            }
                gridColumns.push(new Ext.grid.RowNumberer());
            }
        }
        gridColumns.reverse();
        this.colModel = new Ext.grid.ColumnModel(gridColumns);
        this.selModel = checkboxCol;
        if (!this.store) {
            this.createByColModel(this.allColumns);
        }
    },
    /**
    *@private
    */
    onRender: function(ct, position) {
        FW.Ctrl.ListGrid.superclass.onRender.apply(this, arguments);
    },
    /**
    *@private
    *通过colMode生成store和pagingToolbar
    */
    createByColModel: function(allColumns) {
        var fields = [];
        if (this.rowNumberer === true) { colModel.config.unshift(new Ext.grid.RowNumberer()); }
        Ext.each(allColumns, function(c) {
            if (c.dataIndex && Ext.util.Format.trim(c.dataIndex) != "") {
                fields.push(c.dataIndex);
            }
        });
        var hproxy = new Ext.data.HttpProxy({
            url: this.queryUrl
        });
        hproxy.addListener('loadexception', this.loadFailture, this);
        this.store = new Ext.data.JsonStore({
            autoDestroy: true,
            //url: this.queryUrl,
            proxy: hproxy,
            root: 'data',
            totalProperty: 'totalProperty',
            fields: fields,
            remoteSort: true
        });
        if (this.defaultSort != "") {
            this.store.setDefaultSort(this.defaultSort, 'desc');
        }

        if (this.paging !== false) {
            this.bottomToolbar.bind(this.store);
        }
    },
    /**
    *@return {Ext.data.Record} the first selected record
    */
    getSelected: function() {
        return this.getSelectionModel().getSelected();
    },
    /**
    *@return {Ext.data.Record[]} the selected records
    */
    getSelections: function() {
        return this.getSelectionModel().getSelections();
    },
    /**
    *@return {Number} total number of the selected records 
    */
    getSelectionsCount: function() {
        return this.getSelectionModel().getCount();
    },
    /**
    *@param {Number} index
    *@return {Ext.data.Record} the Record at the specified index.
    */
    getAt: function(index) {
        return this.getStore().getAt(index);
    },
    /**
    *@return {Number} the count of the store record
    */
    getCount: function() {
        return this.getStore().getCount();
    },
    /**
    *@param {Number} rowNo 行号
    *@param {String/Number} colName col->dataIndex/列号 建议使用store的列名
    *@return {Object} the value of the grid'cell
    */
    getCell: function(rowNo, colName) {
        if (typeof colName === 'number') {
            colName = this.getStore().fields.keys[colName];
        }
        return this.getAt(rowNo).get(colName);
    },
    /**
    *@return {Array[Ext.data.Record]} An array of {@link Ext.data.Record Records} containing outstanding
    * modifications.
    */
    getModifiedRecords: function() {
        this.getStore().getModifiedRecords();
    },
    loadData: function() {
        var paramsNow = this.getParams();
        this.store.baseParams = paramsNow;
        this.store.load();
    },
    // private
    getParams: function() {
        var params = {};
        var paramNames = this.store.paramNames;
        params[paramNames.start] = 0;
        params[paramNames.limit] = this.pageSize;
        if (this.queryParams != null) {
            for (var prop in this.queryParams) {
                params[prop] = this.queryParams[prop];
            }
        }
        if (this.getParamFn != null) {
            var excuteFunction = eval(this.getParamFn);
            if (Ext.isFunction(excuteFunction)) {
                var rstParam = excuteFunction.call();
                for (var prop in rstParam) {
                    params[prop] = rstParam[prop];
                }
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
    afterRender: function() {
        FW.Ctrl.ListGrid.superclass.afterRender.call(this);
    },
    loadFailture: function(htproxy, options, response, error) {
        FW.CommonMethod.ShowMessage("E", "操作失败！");
    }
});
Ext.reg('FWListgrid', FW.Ctrl.ListGrid);