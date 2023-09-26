// /名称: 调价单查询
// /描述: 调价单查询
// /编写者：zhangdongmei
// /编写日期: 2013.01.04

Ext.onReady(function(){
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
    var gHospid=session['LOGON.HOSPID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // 调价单号
    var AspNo= new Ext.form.TextField({
                fieldLabel : '调价单号',
                id : 'AspNo',
                name : 'AspNo',
                anchor:'90%',
                width : 120
            });

    // 起始日期
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '起始日期',
                id : 'StartDate',
                name : 'StartDate',
                anchor:'90%',
                width : 120,
                value : new Date().add(Date.DAY,-1)
            });

    // 结束日期
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '结束日期',
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
        fieldLabel:'<font color=blue>类     组</font>',
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
        fieldLabel:'药品名称',
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
                    data : [['No', '未审核'], ['Audit', '已审核未生效'],
                            ['Yes', '已生效']]
                });
    var Type = new Ext.form.ComboBox({
                fieldLabel : '调价单状态',
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
         var PrintBT = new Ext.Toolbar.Button({
                text : '打印',
                tooltip : '点击打印',
                iconCls : 'page_print',
                height:30,
                width:70,
                handler : function() {
	                var record = MasterInfoGrid.getSelectionModel().getSelected();
	    			var aspno = record.get("AspNo");
                    PrintAdjPrice(aspno);
                }
            });   
    // 检索按钮
    var searchBT = new Ext.Toolbar.Button({
                text : '查询',
                tooltip : '点击查询调价信息',
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
            Msg.info("warning", "开始日期不能为空！");
            return;
        }
        var EndDate = Ext.getCmp("EndDate").getValue();
        if(EndDate!=null && EndDate!=""){
        	EndDate=EndDate.format(App_StkDateFormat);
        }
        if(EndDate==null||EndDate.length <= 0) {
            Msg.info("warning", "截止日期不能为空！");
            return;
        }

        var AspNo = Ext.getCmp("AspNo").getValue();
        var StkGrpId=Ext.getCmp("StkGrpType").getValue();
       
        if(Ext.getCmp("IncDesc").getValue()==""){
	       Ext.getCmp("IncId").setValue("");  
	    }   
        var ItmId=Ext.getCmp("IncId").getValue();  
        var Status=Ext.getCmp("Type").getValue();
        
        var Others=AspNo+"^"+Status+"^"+ItmId+"^"+StkGrpId+"^"+gHospid;
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
        			Msg.info("error","查询错误，请查看日志!");
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

    /*
    // 变更按钮是否可用
    function changeButtonEnable(str) {
        var list = str.split("^");
        for (var i = 0; i < list.length; i++) {
            if (list[i] == "1") {
                list[i] = false;
            } else {
                list[i] = true;
            }
        }

        Ext.getCmp("SearchInItBT").setDisabled(list[0]);
        Ext.getCmp("SearchRqNoBT").setDisabled(list[1]);
        Ext.getCmp("ClearBT").setDisabled(list[2]);
        Ext.getCmp("AddBT").setDisabled(list[3]);
        Ext.getCmp("SaveBT").setDisabled(list[4]);
        Ext.getCmp("DeleteBT").setDisabled(list[5]);
        Ext.getCmp("DeleteDrugBT").setDisabled(list[6]);
        Ext.getCmp("CheckBT").setDisabled(list[7]);
    }*/
		// 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '另存',
				tooltip : '另存为Excel',
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
                text : '清屏',
                tooltip : '点击清屏',
                iconCls : 'page_clearscreen',
                height:30,
                width:70,
                handler : function() {
                    clearData();
                }
            });

    function clearData() {
        Ext.getCmp("AspNo").setValue("");
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
    var MasterInfoUrl = DictUrl + 'inadjpriceaction.csp?actiontype=QueryAspNo';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : MasterInfoUrl,
                method : "POST"
            });
    // 指定列参数
    // 调价单号 最近一次更新日期 最近一次更新人
    // 
    var fields = ["AspNo", "AspDate", "AspUser"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "AspNo",
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
                header : "调价单号",
                dataIndex : 'AspNo',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : "最后更新日期",
                dataIndex : 'AspDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : '操作人',
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
        displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg:'没有记录',
        firstText:'第一页',
        lastText:'最后一页',
        nextText:'下一页',
        prevText:'上一页'      
    });
    var MasterInfoGrid = new Ext.grid.GridPanel({
        id : 'MasterInfoGrid',
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
        var aspno = MasterInfoStore.getAt(rowIndex).get("AspNo");
        var status=Ext.getCmp("Type").getValue();
        var stkgrpid=Ext.getCmp("StkGrpType").getValue();
        var incid=Ext.getCmp("IncId").getValue();
        DetailInfoStore.setBaseParam("AspNo",aspno);
        DetailInfoStore.setBaseParam("Status",status);
        DetailInfoStore.setBaseParam("StkGrpId",stkgrpid);
        DetailInfoStore.setBaseParam("IncId",incid);
        
        var pageSize=DetailInfoPageToolBar.pageSize;
        DetailInfoStore.load({params:{start:0,limit:pageSize}});
    });

    // 访问路径
    var DetailInfoUrl = DictUrl + 'inadjpriceaction.csp?actiontype=QueryAspDetail';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : DetailInfoUrl,
                method : "GET"
            });
    
    // 指定列参数
    // rowid 库存分类 药品名称 调价单位 调前售价 调后售价 差价（售价） 调前进价 调后进价 差价（进价） 调价原因 物价文件号 物价文件备案时间 调价人
    var fields = ["AspId", "StkCatDesc", "InciDesc", "AspUomDesc",
            "PriorSpUom", "ResultSpUom", "DiffSpUom", "PriorRpUom",
            "ResultRpUom", "DiffRpUom", "Remark", "WarrentNo",
            "WnoDate","CreatUserName","AuditUserName","Status","AdjReasonDesc"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "AspId",
                fields : fields
            });
    // 数据集
    var DetailInfoStore = new Ext.data.Store({
        proxy : proxy,
        reader : reader,
        baseParams:{
            AspNo:'',
            Status:'',
            StkGrpId:'',
            IncId:''
        },
        remoteSort:true
    });
    
    var nm = new Ext.grid.RowNumberer();
    var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
                header : "AspId",
                dataIndex : 'AspId',
                width : 100,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "状态",
                dataIndex : 'Status',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "库存分类",
                dataIndex : 'StkCatDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : '药品名称',
                dataIndex : 'InciDesc',
                width : 180,
                align : 'left',
                sortable : true
            }, {
                header : "调价单位",
                dataIndex : 'AspUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "调前售价",
                dataIndex : 'PriorSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "调后售价",
                dataIndex : 'ResultSpUom',
                width : 80,
                align : 'right'
            }, {
                header : "差价(售价)",
                dataIndex : 'DiffSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "调前进价",
                dataIndex : 'PriorRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "调后进价",
                dataIndex : 'ResultRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "差价(进价)",
                dataIndex : 'DiffRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "调价原因",
                dataIndex : 'AdjReasonDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "物价文件号",
                dataIndex : 'WarrentNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "物价文件日期",
                dataIndex : 'WnoDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "建单人",
                dataIndex : 'CreatUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "审核人",
                dataIndex : 'AuditUserName',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    DetailInfoCm.defaultSortable = true;
    var DetailInfoPageToolBar=new Ext.PagingToolbar({
        store:DetailInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg:'没有记录',
        firstText:'第一页',
        lastText:'最后一页',
        nextText:'下一页',
        prevText:'上一页'      
    });
    var DetailInfoGrid = new Ext.grid.GridPanel({
                title : '调价单明细',
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
        title:'调价单查询',
        labelAlign : 'right',
        id : "InfoForm",
        autoHeight:true,
        tbar : [searchBT,'-', clearBT,'-',SaveAsBT, '-',PrintBT],        
        items : [{
                    xtype : 'fieldset',
                    title : '查询条件',
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
                        items : [AspNo,Type]
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
        },{ title : '调价单信息',
            region:'west',
            width:document.body.clientWidth*0.25,
            split:true,
            collapsible:true,
            minSize:document.body.clientWidth*0.1,
            maxSize:document.body.clientWidth*0.5,
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
