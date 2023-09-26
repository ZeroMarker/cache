(function(){
	Ext.ns("dhcwl.mkpi.CodeCfgType");
})();

dhcwl.mkpi.CodeCfgType=function(){
	//var parentWin=null;
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true},
        {header:'分类编码',dataIndex:'TypeCode',sortable:true, width: 30, sortable: true},
        {header:'分类描述',dataIndex:'TypeDesc', width: 100, sortable: true},
        {header:'执行代码',dataIndex:'TypeExtCode', width: 160, sortable: true},
        {header:'值描述',dataIndex:'TypeValueDes', width: 160, sortable: true},
        {header:'有效标志',dataIndex:'TypeFlag', width: 160, sortable: true},
        {header:'创建/更新日期',dataIndex:'TypeCreateDate', width: 80, sortable: true},      //,renderer:formateDate
        {header:'创建人',dataIndex:'TypeCreateUse', width: 80, sortable: true}
    ]);

    
    var myData = [
        ['1','分类编码1','分类描述1','执行代码1','值描述1','有效标志1','更新日期1','创建人1'],
        ['2','分类编码2','分类描述1','执行代码1','值描述1','有效标志1','更新日期1','创建人1'],
        ['3','分类编码3','分类描述1','执行代码1','值描述1','有效标志1','更新日期1','创建人1'],
        ['4','分类编码4','分类描述1','执行代码1','值描述1','有效标志1','更新日期1','创建人1'],
        ['5','分类编码5','分类描述1','执行代码1','值描述1','有效标志1','更新日期1','创建人1']
    ];
    

   // create the data store
    var store = new Ext.data.ArrayStore({
        fields: [
           {name: 'ID'},
           {name: 'TypeCode'},
           {name: 'TypeDesc'},
           {name: 'TypeExtCode'},
           {name: 'TypeValueDes'},
           {name: 'TypeFlag'},
           {name: 'TypeCreateDate'},
           {name: 'TypeCreateUse'}
        ]
    });

    // manually load local data
    store.loadData(myData);
    
    
    var codecfgtypeGrid = new Ext.grid.GridPanel({
        height:480,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=codecfgtypeForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        }
        /*
         
         ,
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: new Ext.Toolbar([
        ])
        */
    });
    var codecfgtypeForm = new Ext.FormPanel({
        frame: true,
        height: 145,
        labelAlign: 'left',
        //title: '指标分类列表',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:8},
        items:[{
        	html: 'ID：'
        },{
            xtype:'textfield',
            name: 'ID',
            //id: 'ID',
            disabled:true,
            anchor:'95%'
        },{
        	html: '分类编码：'
        },{
            xtype:'textfield',
            name: 'TypeCode',
            id: 'TypeCode',
            anchor:'95%'
            //validator:dhcwl.mkpi.Util.valideValue
        },{
            html: '分类描述：'
        },{
            name: 'TypeDesc',
            id: 'TypeDesc',
            xtype:'textfield',
            anchor:'95%'
        },{
            html:'执行代码：'
        },{
            name:'TypeExtCode',
            id:'TypeExtCode',
            xtype:'textfield',
            flex:1
        },{
            html: '值描述：'
        },{
            name: 'TypeValueDes',
            id: 'TypeValueDes',
            xtype:'textfield',
            flex:1
        }, {
        	html: '有效标志：'
        },{
            name: 'TypeFlag',
            id: 'TypeFlag',
            xtype:'textfield',
            flex:1
        }, {
            html: '创建/更新日期：'
        },{
            xtype:'datefield',
            format :'Y-m-d',
            name: 'TypeCreateDate',
            id: 'TypeCreateDate',
            width:130,
            flex:1
        },{
            //columnWidth:.1,
            html: '创建人：'
        },{
        	xtype:'textfield',
            name: 'TypeCreateUse',
            id: 'TypeCreateUse'
         }]
    });

    
    var codecfgtypePanel =new Ext.Panel({
    	title:'类型代码维护',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 148,
            autoScroll:true,
            items:codecfgtypeForm
        },{
        	region:'center',
        	autoScroll:true,
            items:codecfgtypeGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			codecfgtypeGrid.setHeight(height-150);
    			codecfgtypeGrid.setWidth(width-15);
    		}
    	}
    });
    
    this.mainWin=new Ext.Viewport({
    	id:'maintainCodeCfgType',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        //width:1000,
        //heitht:800,
        items: [codecfgtypePanel]
    });
}


Ext.onReady(function(){
	dhcwl_mkpi_codecfgtype=new dhcwl.mkpi.CodeCfgType();

});

