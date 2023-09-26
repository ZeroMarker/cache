// /名称: 调价单查询
// /描述: 调价单查询
// /编写者：zhangdongmei
// /编写日期: 2013.01.04

Ext.onReady(function(){
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
    var HospId=session['LOGON.HOSPID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // 调价单号
    var AspBatNo= new Ext.ux.TextField({
                fieldLabel : '调价单号',
                id : 'AspBatNo',
                name : 'AspBatNo'
            });

    // 起始日期
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '起始日期',
                id : 'StartDate',
                name : 'StartDate',
                value : new Date().add(Date.DAY,-1)
            });

    // 结束日期
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '结束日期',
                id : 'EndDate',
                name : 'EndDate',
                value : new Date()
            });

    // 类组
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        fieldLabel:'<font color=blue>类     组</font>',
        StkType:App_StkTypeCode,     //标识类组类型
        LocId:gLocId,
        UserId:gUserId,
        anchor : '90%'
       
    }); 
    
    var IncId=new Ext.ux.TextField({
            id:'IncId',
            name:'IncId',
            value:''
    });
        
    var IncDesc=new Ext.ux.TextField({
        id:'IncDesc',
        name:'IncDesc',
        fieldLabel:'物资名称',
        listeners:{
            'specialkey':function(field,e){
                var keycode=e.getKey();
                if(keycode==13){
                    var input=field.getValue();
                    var stkgrpid=Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode,
									"", "N", "", HospId, getDrugList);
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
                    data : [['N', '未审核'], ['A', '已审核未生效'],
                            ['Y', '已生效']]
                });
    var Type = new Ext.ux.LocalComboBox({
                fieldLabel : '调价单状态',
                id : 'Type',
                name : 'Type',
                store : TypeStore
           
            });
        
    // 检索按钮
    var searchBT = new Ext.ux.Button({
                text : '查询',
                tooltip : '点击查询调价信息',
                iconCls : 'page_find',
                handler : function() {
                    searchAspData();
                }
            });

    function searchAspData() {
        
        var StartDate = Ext.getCmp("StartDate").getValue()
        if(StartDate!=null && StartDate!=""){
        	StartDate=StartDate.format(ARG_DATEFORMAT);
        }
        if(StartDate==null||StartDate.length <= 0) {
            Msg.info("warning", "开始日期不能为空！");
            return;
        }
        var EndDate = Ext.getCmp("EndDate").getValue();
        if(EndDate!=null && EndDate!=""){
        	EndDate=EndDate.format(ARG_DATEFORMAT);
        }
        if(EndDate==null||EndDate.length <= 0) {
            Msg.info("warning", "截止日期不能为空！");
            return;
        }

        var AspBatNo = Ext.getCmp("AspBatNo").getValue();
        var StkGrpId=Ext.getCmp("StkGrpType").getValue();
		var IncDesc=Ext.getCmp("IncDesc").getValue();
		if(IncDesc==""){Ext.getCmp("IncId").setValue("");}
		var ItmId=Ext.getCmp("IncId").getValue();
		if(ItmId!=""&ItmId!=null){
			IncDesc="";
		}
        var Status=Ext.getCmp("Type").getValue();
        var Others=AspBatNo+"^"+Status+"^"+ItmId+"^"+StkGrpId+"^"+IncDesc;
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
    }
    */
    // 清空按钮
    var clearBT = new Ext.Toolbar.Button({
                text : '清空',
                tooltip : '点击清空',
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
    var MasterInfoUrl = DictUrl + 'inadjpricebatchaction.csp?actiontype=QueryAspBatNo';
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
                header : "调价单号",
                dataIndex : 'AspBatNo',
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
    var MasterInfoPageToolBar=new Ext.ux.PagingToolbar({
        store:MasterInfoStore,
        pageSize:PageSize
             
    });
    var MasterInfoGrid = new Ext.ux.GridPanel({
        id : 'MasterInfoGrid',
        region:'west',
        width:'250',
        title:'调价单(批次)信息',
        split:true,
        collapsible:true,
        cm : MasterInfoCm,
        sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
        store : MasterInfoStore,
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
    var DetailInfoUrl = DictUrl + 'inadjpricebatchaction.csp?actiontype=QueryAspBatDetail';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : DetailInfoUrl,
                method : "GET"
            });
    
    // 指定列参数
    // rowid 库存分类 物资名称 调价单位 调前售价 调后售价 差价（售价） 调前进价 调后进价 差价（进价） 调价原因 物价文件号 物价文件备案时间 调价人
    var fields = ["AspBatId", "Incib","StkCatDesc", "InciDesc", "AspUomDesc",
            "PriorSpUom", "ResultSpUom", "DiffSpUom", "PriorRpUom",
            "ResultRpUom", "DiffRpUom", "Remark", "WarrentNo",
            "WnoDate", "CreatUserName","AdjUserName","Status","AdjReasonDesc","BatExp"];
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
                header : '物资名称',
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
                header : "制单人",
                dataIndex : 'CreatUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "审核人",
                dataIndex : 'AdjUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "批次/有效期",
                dataIndex : 'BatExp',
                width : 180,
                align : 'left',
                sortable : true
            }]);
    DetailInfoCm.defaultSortable = true;
    var DetailInfoPageToolBar=new Ext.ux.PagingToolbar({
        store:DetailInfoStore,
        pageSize:PageSize
        
    });
    var DetailInfoGrid = new Ext.ux.GridPanel({
		id:'DetailInfoGrid',
		title : '调价单(批次)明细',
		region:'center',
		cm : DetailInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : DetailInfoStore,
		bbar:DetailInfoPageToolBar
	});
    var InfoForm= new Ext.ux.FormPanel({
        title:'调价单(批次)查询',
        id : "InfoForm",
        tbar : [searchBT, '-', clearBT],        
        items : [{
			xtype : 'fieldset',
			title : '查询条件',
			defaults: {border:false,xtype:'fieldset',columnWidth:.3},
			layout: 'column',
			style : 'padding:5px 0px 0px 5px',
			items : [{
				items : [StartDate,EndDate]
			}, {
				items : [AspBatNo,Type]
			}, {
				items : [StkGrpType,IncDesc]
			}]
        }]              
    });
    

    var mainPanel = new Ext.ux.Viewport({
        layout : 'border',
        items : [InfoForm,MasterInfoGrid,DetailInfoGrid]
    });
});
