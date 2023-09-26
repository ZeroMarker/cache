examinIncomeFun = function(monthDr, grid, pagingTool, itemLevelSetsDr){


    var tmpUId = "";
    var findCommTabProxy = new Ext.data.HttpProxy({
        url: costDistSetsUrl + '?action=examinincome&monthDr=' + monthDr
    });
    var tmpMonth = "";
    var myAct = "";
    
    var costItemTabDs = new Ext.data.Store({
        proxy: findCommTabProxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        }, ['deptCode', 'deptName']),
        remoteSort: true
    });
    
    costItemTabDs.setDefaultSort('deptCode', 'Desc');
    
    var findCommTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
        header: '部门代码',
        dataIndex: 'deptCode',
        width: 150,
        sortable: true
    }, {
        header: '部门名称',
        dataIndex: 'deptName',
        width: 150,
        sortable: true
    }]);
    
    var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
        pageSize: 15,
        store: costItemTabDs,
        displayInfo: true,
        displayMsg: '当前显示{0} - {1}，共计{2}',
        emptyMsg: "没有数据",
        doLoad: function(C){
            var B = {}, A = this.paramNames;
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['monthDr'] = monthDr;
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({
                    params: B
                });
            }
        }
        
    });
    
    //==========================================================面板==========================================================
    var formPanel = new Ext.grid.GridPanel({
        store: costItemTabDs,
        cm: findCommTabCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        loadMask: true,
        bbar: findCommTabPagingToolbar
    });
    
    var window = new Ext.Window({
        title: '收入数据中以下开单科室,不为直接医疗科室!',
        width: 680,
        height: 500,
        minWidth: 680,
        minHeight: 500,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: formPanel,
        buttons: [{
            text: '取消',
            handler: function(){
                window.close();
            }
        }]
    });
    costItemTabDs.load({
        params: {
            start: 0,
            limit: findCommTabPagingToolbar.pageSize,
            monthDr: monthDr
        }
    });
    window.show();
};
