var sortGrid = new Ext.grid.GridPanel({ 


    border:false, 
    ds:sortds, 
    AllowPaging:true, 
    cm: new Ext.grid.ColumnModel([ 
        new Ext.grid.RowNumberer(), 
        {header: "类型ID", width: 80, sortable: true,locked:true, dataIndex: 'sortId'}, 
        {header: "类型名称", width: 200, sortable: true,locked:false, dataIndex: 'sortName'}, 
        {header: "父类型ID", width: 80, sortable: true, locked:false,dataIndex: 'parentSortId'}, 
        {header: "所属图书数", width: 80, sortable: true,locked:false, dataIndex: 'sortNumber'} 
        
    ]), 

    viewConfig: { 
        forceFit:true 
    }, 
    bbar : new Ext.PagingToolbar({  
        id: 'sortPagebar',  
        pageSize:15,  
        store:sortds,  
        displayInfo:true, 
        }), 

    tbar:[{ 
        text:'增加图书分类', 
        tooltip:'Add a new sort', 
        iconCls:'add', 
        handler:function(){ alert(1);} 
      
        },{ 
        text:'删除图书分类', 
        tooltip:'Remove a sort,the sort can not be empty', 
        iconCls:'remove', 
        handler:function(){ 
      
        } 
    }], 
    
}); 


MyDesktop.SortWindow = Ext.extend(Ext.app.Module, { 
    id:'sort-win', 
    init : function(){ 
        this.launcher = { 
            text: '分类管理', 
            iconCls:'icon-sort-grid', 
            handler : this.createWindow, 
            scope: this 
        } 
    }, 

    createWindow : function(){ 
        var desktop = this.app.getDesktop(); 
        var win = desktop.getWindow('sort-win'); 
        if(!win){ 
            win = desktop.createWindow({ 
                id: 'sort-win', 
                title:'分类管理', 
                width:600, 
                height:423, 
                iconCls: 'icon-sort-grid', 
                shim:false, 
                animCollapse:false, 
                constrainHeader:true, 

                layout: 'fit', 
                items:[ 
                  sortGrid 
                ] 
            }); 
        } 
        sortds.load({params:{start:0, limit:15}}); 
        win.show(); 
    }, 
    
    
}); 
