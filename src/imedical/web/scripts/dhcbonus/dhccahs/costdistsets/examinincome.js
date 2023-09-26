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
        header: '���Ŵ���',
        dataIndex: 'deptCode',
        width: 150,
        sortable: true
    }, {
        header: '��������',
        dataIndex: 'deptName',
        width: 150,
        sortable: true
    }]);
    
    var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
        pageSize: 15,
        store: costItemTabDs,
        displayInfo: true,
        displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
        emptyMsg: "û������",
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
    
    //==========================================================���==========================================================
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
        title: '�������������¿�������,��Ϊֱ��ҽ�ƿ���!',
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
            text: 'ȡ��',
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
