// /名称: 调价单查询
// /描述: 调价单查询
// /编写者：zhangdongmei
// /编写日期: 2013.01.04

Ext.onReady(function(){
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // 调价单号
    var AspBatNo= new Ext.form.TextField({
                fieldLabel : $g('调价单号'),
                id : 'AspBatNo',
                name : 'AspBatNo',
                anchor:'90%',
                width : 120
            });

    // 起始日期
    var StartDate = new Ext.ux.DateField({
                fieldLabel : $g('起始日期'),
                id : 'StartDate',
                name : 'StartDate',
                anchor:'90%',
                width : 120,
                value : new Date().add(Date.DAY,-1)
            });

    // 结束日期
    var EndDate = new Ext.ux.DateField({
                fieldLabel : $g('结束日期'),
                id : 'EndDate',
                name : 'EndDate',
                anchor:'90%',
                width : 120,
                value : new Date()
            });

    // 药品类组
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        fieldLabel:'<font color=blue>'+$g('类　　组')+'</font>',
        StkType:App_StkTypeCode,     //标识类组类型
        LocId:gLocId,
        UserId:gUserId,
        width : 150,
        anchor:'90%'
    }); 
    
    var IncId=new Ext.form.TextField({
            id:'IncId',
            name:'IncId',
            value:''
    });
        
    var IncDesc=new Ext.form.TextField({
        id:'IncDesc',
        name:'IncDesc',
        fieldLabel:$g('药品名称'),
        width:150,
        anchor:'90%',
        listeners:{
            'specialkey':function(field,e){
                var keycode=e.getKey();
                if(keycode==13){
                    var input=field.getValue();
                    var stkgrpid=Ext.getCmp("StkGrpType").getValue();
                    GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode, "", "N","", "", getDrugList);
                }
            }
        }
    });
    
    /**
     * 返回方法
    */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var inciCode=record.get("InciCode");
        var inciDesc=record.get("InciDesc");
        Ext.getCmp("IncId").setValue(inciDr);
        Ext.getCmp("IncDesc").setValue(inciDesc);
    }
    
    var TypeStore = new Ext.data.SimpleStore({
                    fields : ['RowId', 'Description'],
                    data : [['N', $g('未审核')], ['A', $g('已审核未生效')],
                            ['Y', $g('已生效')]]
                });
    var Type = new Ext.form.ComboBox({
                fieldLabel : $g('调价单状态'),
                id : 'Type',
                name : 'Type',
                width : 100,
                store : TypeStore,
                triggerAction : 'all',
                mode : 'local',
                valueField : 'RowId',
                displayField : 'Description',
                anchor:'90%',
                allowBlank : true,
                triggerAction : 'all',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                editable : true,
                valueNotFoundText : ''
            });
        
    // 检索按钮
    var searchBT = new Ext.Toolbar.Button({
                text : $g('查询'),
                tooltip : $g('点击查询调价信息'),
                iconCls : 'page_find',
                height:30,
                width:70,
                handler : function() {
                    searchAspData();
                }
            });

    function searchAspData() {
        
        var StartDate = Ext.getCmp("StartDate").getValue()
        if(StartDate!=null && StartDate!=""){
        	StartDate=StartDate.format(App_StkDateFormat);
        }
        if(StartDate==null||StartDate.length <= 0) {
            Msg.info("warning", $g("开始日期不能为空！"));
            return;
        }
        var EndDate = Ext.getCmp("EndDate").getValue();
        if(EndDate!=null && EndDate!=""){
        	EndDate=EndDate.format(App_StkDateFormat);
        }
        if(EndDate==null||EndDate.length <= 0) {
            Msg.info("warning", $g("截止日期不能为空！"));
            return;
        }

        var AspBatNo = Ext.getCmp("AspBatNo").getValue();
        var StkGrpId=Ext.getCmp("StkGrpType").getValue();        
        if(Ext.getCmp("IncDesc").getValue()==""){
	        Ext.getCmp("IncId").setValue("");
		}
		var ItmId=Ext.getCmp("IncId").getValue(); 
        var Status=Ext.getCmp("Type").getValue();
        var Others=AspBatNo+"^"+Status+"^"+ItmId+"^"+StkGrpId;
        MasterInfoStore.setBaseParam("StartDate",StartDate);
        MasterInfoStore.setBaseParam("EndDate",EndDate);
        MasterInfoStore.setBaseParam("Others",Others);
        var PageSize=MasterInfoPageToolBar.pageSize;
        MasterInfoStore.removeAll();
        DetailInfoGrid.getStore().removeAll();
        MasterInfoStore.load({
        	params:{start:0,limit:PageSize},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error",$g("查询错误，请查看日志!"));
        		}else{
        			if(r.length>0){
        				MasterInfoGrid.getSelectionModel().selectFirstRow();
	     				MasterInfoGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				MasterInfoGrid.getView().focusRow(0);
        			}
        		}
        	}
        });  
    }
		// 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : $g('另存'),
				tooltip : $g('另存为Excel'),
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(DetailInfoGrid);
					//gridSaveAsExcel(StockQtyGrid);
				}
			});
    // 清空按钮
    var clearBT = new Ext.Toolbar.Button({
                text : $g('清屏'),
                tooltip : $g('点击清屏'),
                iconCls : 'page_clearscreen',
                height:30,
                width:70,
                handler : function() {
                    clearData();
                }
            });

    function clearData() {
        Ext.getCmp("AspBatNo").setValue("");
        Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
        Ext.getCmp("EndDate").setValue(new Date());
        Ext.getCmp("StkGrpType").getStore().load();
        Ext.getCmp("Type").setValue("");
        Ext.getCmp("IncDesc").setValue("");
        MasterInfoGrid.getStore().removeAll();
        MasterInfoGrid.getView().refresh();
        //DetailInfoPageToolBar.bind(DetailInfoGrid.getStore());
        DetailInfoGrid.getStore().removeAll();
        DetailInfoGrid.getView().refresh();
        
        
          DetailInfoGrid.getStore().totalLength=0;
         
          DetailInfoPageToolBar.updateInfo();
          DetailInfoPageToolBar.first.setDisabled(true);
          DetailInfoPageToolBar.prev.setDisabled(true);
          DetailInfoPageToolBar.next.setDisabled(true);
          DetailInfoPageToolBar.last.setDisabled(true); 
         
    }

    // 访问路径
    var MasterInfoUrl = DictUrl + 'inadjpriceactionbatch.csp?actiontype=QueryAspBatNo';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : MasterInfoUrl,
                method : "POST"
            });
    // 指定列参数
    // 调价单号 最近一次更新日期 最近一次更新人
    // 
    var fields = ["AspBatNo", "AspDate", "AspUser"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "AspBatNo",
                fields : fields
            });
    // 数据集
    var MasterInfoStore = new Ext.data.Store({
                proxy : proxy,
                reader : reader,
                baseParams:{
                    StartDate:'',
                    EndDate:'',
                    Others:''               
                }
            });
    var nm = new Ext.grid.RowNumberer();
    var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
                header : $g("调价单号"),
                dataIndex : 'AspBatNo',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : $g("最后更新日期"),
                dataIndex : 'AspDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : $g('操作人'),
                dataIndex : 'AspUser',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    MasterInfoCm.defaultSortable = true;
    var MasterInfoPageToolBar=new Ext.PagingToolbar({
        store:MasterInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
        emptyMsg:$g('没有记录'),
        firstText:$g('第一页'),
        lastText:$g('最后一页'),
        nextText:$g('下一页'),
        prevText:$g('上一页')      
    });
    var MasterInfoGrid = new Ext.grid.GridPanel({
        id : 'MasterInfoGrid',
//        title : '调价单信息',
        height : 170,
        cm : MasterInfoCm,
        sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
        store : MasterInfoStore,
        trackMouseOver : true,
        stripeRows : true,
        loadMask : true,
        bbar:MasterInfoPageToolBar
    });

    // 添加表格单击行事件
    MasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
        var aspBatNo = MasterInfoStore.getAt(rowIndex).get("AspBatNo");
        var status=Ext.getCmp("Type").getValue();
        var stkgrpid=Ext.getCmp("StkGrpType").getValue();
        var incid=Ext.getCmp("IncId").getValue();
        DetailInfoStore.setBaseParam("AspBatNo",aspBatNo);
        DetailInfoStore.setBaseParam("Status",status);
        DetailInfoStore.setBaseParam("StkGrpId",stkgrpid);
        DetailInfoStore.setBaseParam("IncId",incid);
        
        var pageSize=DetailInfoPageToolBar.pageSize;
        DetailInfoStore.load({params:{start:0,limit:pageSize}});
    });

    // 访问路径
    var DetailInfoUrl = DictUrl + 'inadjpriceactionbatch.csp?actiontype=QueryAspBatDetail';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : DetailInfoUrl,
                method : "GET"
            });
    
    // 指定列参数
    // rowid 库存分类 药品名称 调价单位 调前售价 调后售价 差价（售价） 调前进价 调后进价 差价（进价） 调价原因 物价文件号 物价文件备案时间 调价人
    var fields = ["AspBatId", "Incib","StkCatDesc", "InciDesc", "AspUomDesc",
            "PriorSpUom", "ResultSpUom", "DiffSpUom", "PriorRpUom",
            "ResultRpUom", "DiffRpUom", "Remark", "WarrentNo",
            "WnoDate", "CreatUserName","AdjUserName","Status","AdjReasonDesc"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "AspBatId",
                fields : fields
            });
    // 数据集
    var DetailInfoStore = new Ext.data.Store({
        proxy : proxy,
        reader : reader,
        baseParams:{
            AspBatNo:'',
            Status:'',
            StkGrpId:'',
            IncId:''
        }
    });
    
    var nm = new Ext.grid.RowNumberer();
    var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
                header : "AspBatId",
                dataIndex : 'AspBatId',
                width : 100,
                align : 'left',
                sortable : true,
                hidden : true
            }, {   
		  header : "Incib",
		  dataIndex : 'Incib',
		  width : 80,
		  align : 'left',
		  sortable : true,
		  hidden : true
	     }, {
                header : $g("状态"),
                dataIndex : 'Status',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("库存分类"),
                dataIndex : 'StkCatDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g('药品名称'),
                dataIndex : 'InciDesc',
                width : 180,
                align : 'left',
                sortable : true
            }, {
                header : $g("调价单位"),
                dataIndex : 'AspUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("调前售价"),
                dataIndex : 'PriorSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("调后售价"),
                dataIndex : 'ResultSpUom',
                width : 80,
                align : 'right'
            }, {
                header : $g("差价(售价)"),
                dataIndex : 'DiffSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("调前进价"),
                dataIndex : 'PriorRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("调后进价"),
                dataIndex : 'ResultRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("差价(进价)"),
                dataIndex : 'DiffRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("调价原因"),
                dataIndex : 'AdjReasonDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("物价文件号"),
                dataIndex : 'WarrentNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("物价文件日期"),
                dataIndex : 'WnoDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : $g("建单人"),
                dataIndex : 'CreatUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : $g("调价人"),
                dataIndex : 'AdjUserName',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    DetailInfoCm.defaultSortable = true;
    var DetailInfoPageToolBar=new Ext.PagingToolbar({
        store:DetailInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
        emptyMsg:$g('没有记录'),
        firstText:$g('第一页'),
        lastText:$g('最后一页'),
        nextText:$g('下一页'),
        prevText:$g('上一页')      
    });
    var DetailInfoGrid = new Ext.grid.GridPanel({
                title : $g('调价单(批次)明细'),
                height : 170,
                cm : DetailInfoCm,
                sm : new Ext.grid.RowSelectionModel({
                            singleSelect : true
                        }),
                store : DetailInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                loadMask : true,
                bbar:DetailInfoPageToolBar
            });

    // 双击事件
   // MasterInfoGrid.on('rowdblclick', function() {
    //            returnData();
   //         });

    var InfoForm= new Ext.form.FormPanel({
        frame : true,
        labelWidth: 80, 
        title:$g('调价单(批次)查询'),
        labelAlign : 'right',
        id : "InfoForm",
        tbar : [searchBT, '-',clearBT ,'-',SaveAsBT],        
        items : [{
            xtype : 'fieldset',
            title : $g('查询条件'),
            autoHeight : true,
            style: DHCSTFormStyle.FrmPaddingV,
            defaults: {border:false},    // Default config options for child items
            layout: 'column',    // Specifies that the items will now be arranged in columns
            items : [{
                columnWidth : .3,
                xtype:'fieldset',
                autoHeight: true,
                items : [StartDate,EndDate]
            }, {
                columnWidth : .3,
                xtype:'fieldset',
                autoHeight: true,
                items : [AspBatNo,Type]
            }, {
                columnWidth : .3,
                xtype:'fieldset',
                
                items : [StkGrpType,IncDesc]
            }]
        }]              
    });
    

    var mainPanel = new Ext.Viewport({
        layout : 'border',
        items : [{
            region:'north',
            height:DHCSTFormStyle.FrmHeight(2),
            layout:'fit',
            items:InfoForm
        },{ title : $g('调价单(批次)信息'),
            region:'west',
            width:250,
            split:true,
            collapsible:true,
            minSize:200,
            maxSize:350,
            layout:'fit',
            margins: '0 5 0 0',
            items:MasterInfoGrid
        },{
            region:'center',
            layout:'fit',
            items:DetailInfoGrid
        }]
    });
    
    
    
    
});
