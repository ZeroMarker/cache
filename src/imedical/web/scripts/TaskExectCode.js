(function(){
	Ext.ns("dhcwl.mkpi.TaskExectCode");
})();
dhcwl.mkpi.TaskExectCode=function(){
	var parentWin=null;
	var columnModel = new Ext.grid.ColumnModel([
        {header:'填写执行代码格式',dataIndex:'ExeCodeWrite',sortable:true, width: 300, sortable: true
        },{header:'调用执行代码格式',dataIndex:'ExeCodeCall', width: 360, sortable: true 
        },{header:'代码版本',dataIndex:'ExeCodeVersion', width: 60, sortable: true 
        },{header:'创建/修改日期',dataIndex:'ExcCodeCUDate', width: 160, sortable: true 
        },{header:'代码编写者',dataIndex:'ExeCodeCreator', width: 180, sortable: true
        },{header:'适用范围',dataIndex:'ExcCodeApplicable', width: 80, sortable: true
        },{header:'执行代码功能描述及其说明',dataIndex:'ExcCodeDescription', width: 380, sortable: true
        }
    ]);
    //定义指标的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/executecodeservice.csp?action=SECKPIEXCList'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'ExeCodeWrite'},
            	{name: 'ExeCodeCall'},
            	{name: 'ExeCodeVersion'},
            	{name: 'ExcCodeCUDate'},
            	{name: 'ExeCodeCreator'},
            	{name: 'ExcCodeApplicable'},
            	{name: 'ExcCodeDescription'}
       		]
    	})
    });
    var selectedValue="";
    var exeCodeGrid = new Ext.grid.GridPanel({
    	width : 600,
		height : 400,
        resizeAble:true,
        loadMask:true,
        //autoHeight:true,
        enableColumnResize :true,
        store: store,
        cm: columnModel,
        autoScroll: true,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		return;
            		var rd=sm.getSelected();
            		var exeCodeWrite=rd.get('ExeCodeWrite');
            		//parentWin.setSelectValue(exeCodeWrite);
            		selectedValue=exeCodeWrite;
            		parentWin.setSelectValue(selectedValue);
            		exeCodeWin.close();
            		dhcwl_mkpi_executeCodeWin=null;
            		//exeCodeWin.hide();
                }
            }
        }),
        listeners:{
        	'celldblclick':function( thisGrid, rowIndex,columnIndex, event){
        		var rd=thisGrid.getSelectionModel().getSelected();
        		var exeCodeWrite=rd.get('ExeCodeWrite');
        		//parentWin.setSelectValue(exeCodeWrite);
        		selectedValue=exeCodeWrite;
        		parentWin.setSelectValue(selectedValue);
        		exeCodeWin.close();
        		dhcwl_mkpi_executeCodeWin=null;
        	}
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 16,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
    });
    store.load({params:{start:0,limit:16}});
    var exeCodeWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 600,
		height : 400,
		autoScroll:true,
		plain : true,
		title : '指标区间任务执行代码选取',
		id : 'dhcwl_mkpi_executeCodeWin',
		//closeAction:'hide',
		closable : true,
		items : exeCodeGrid,
		listeners:{
			'close':function(){
				exeCodeWin.destroy();
				exeCodeWin.close();
				if(dhcwl_mkpi_executeCodeWin){
					dhcwl_mkpi_executeCodeWin=null;
				}
			}
		}
	});
	//exeCodeWin.hide(this);
    this.setParentWin=function(parent){
    	parentWin=parent;
    }
    this.getSelectValue=function(){
    	return selectedValue;
    }
    this.showWin=function(){
    	exeCodeWin.show();
    }
}