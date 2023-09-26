// /名称: 科室库存上下限维护
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gIncId='';
    var gGroupId=session['LOGON.GROUPID'];  
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];

    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel : '科室',
        id : 'PhaLoc',
        name : 'PhaLoc',
        anchor : '90%',
        valueNotFoundText : '',
        groupId:gGroupId
    });
    
    // 物资类组
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //标识类组类型
        UserId:gUserId,
        LocId:gLocId,
        anchor : '90%'
    }); 
    
    var InciDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var inputDesc=field.getValue();
					var stkGrp=Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(inputDesc,stkGrp);
				}
			}
		}
	});
    /**
     * 调用物资窗体并返回结果
     */
    function GetPhaOrderInfo(item, stktype) {
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
        }
    }
    /**
     * 返回方法
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        gIncId = record.get("InciDr");
        var incDesc=record.get("InciDesc");
        Ext.getCmp("InciDesc").setValue(incDesc);
    }
    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '点击查询',
		iconCls : 'page_find',
		width : 70,
		height : 30,
		handler : function() {
			Query();
		}
	});

    /**
     * 查询方法
     */
    function Query() {
        // 必选条件
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (phaLoc == null || phaLoc.length <= 0) {
            Msg.info("warning", "科室不能为空！");
            Ext.getCmp("PhaLoc").focus();
            return;
        }
        if(Ext.getCmp("InciDesc").getValue()==""){
            gIncId="";
        }
        var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
        gStrParam=phaLoc+"^"+gIncId+"^"+StkGrpRowId;
        var PageSize=StatuTabPagingToolbar.pageSize;
        ItmLocStore.setBaseParam('Params',gStrParam);   //分页时基本参数不会丢失
        ItmLocStore.removeAll();
        ItmLocStore.load({params:{start:0,limit:PageSize}});
    }
    
    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		iconCls : 'page_clearscreen',
		width : 70,
		height : 30,
		handler : function() {
			clearData();
		}
	});

    /**
     * 清空方法
     */
    function clearData() {
        gStrParam='';   
        gIncId='';
        Ext.getCmp("StkGrpType").setValue("");
        Ext.getCmp("StkGrpType").getStore().load();
        SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
        Ext.getCmp("InciDesc").setValue('');
        ItmLocGrid.store.removeAll();
        ItmLocGrid.getView().refresh();
    }
    
    // 保存按钮
    var SaveBT = new Ext.Toolbar.Button({
		id : "SaveBT",
		text : '保存',
		tooltip : '点击保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			// 保存科室库存管理信息
			if(CheckDataBeforeSave()==true){                  
				save(); 
			}                    
		}
	});
    function CheckDataBeforeSave(){
	    var rowCount = ItmLocGrid.getStore().getCount();
        for (var i = 0; i < rowCount; i++) {
            var rowData = ItmLocStore.getAt(i); 
            //新增或数据发生变化时执行下述操作           
			var MaxQty=rowData.get("MaxQty");
			var MinQty=rowData.get("MinQty");
			MaxQty=parseFloat(MaxQty)
			MinQty=parseFloat(MinQty)
			if((MaxQty!=0)&&(MaxQty<MinQty)){
				var n=i+1
				Msg.info("warning","第"+n+"行库存上限小于库存下限!");
				return
			} 
		}
	    return true;	    
    }  
	          
    function save(){       
        var ListDetail="";
		var mr=ItmLocStore.getModifiedRecords();
		var data="";
		var rows="";
		for(var i=0;i<mr.length;i++){
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var ILERowId = mr[i].data["ILERowId"].trim();
			var SpecRowId = mr[i].data["SpecRowId"].trim();
			var Inci = mr[i].data["Inci"];
			var SpecDesc = mr[i].data["SpecDesc"];
			var MaxQty = mr[i].data["MaxQty"];
			var MinQty = mr[i].data["MinQty"];	
			var dataRow =LocId+"^"+ILERowId+"^"+SpecRowId +"^"+Inci+"^"+SpecDesc+"^"+MaxQty+"^"+MinQty;
			
			if(ListDetail==""){
				ListDetail = dataRow;
			}else{
				ListDetail = ListDetail+xRowDelim()+dataRow;
			}
		}
		var url = DictUrl
				+ "locitmlimitsaction.csp?actiontype=Save";
		Ext.Ajax.request({
			url : url,
			params:{Detail:ListDetail},
			method : 'POST',
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					 
					Msg.info("success", "保存成功!");
					// 刷新界面
					Query();

				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "没有需要保存的数据!");
					}else {
						Msg.info("error", "部分明细保存不成功："+ret);
					}
					
				}
			},
			scope : this
		});
    }

    var nm = new Ext.grid.RowNumberer();
    var ItmLocCm = new Ext.grid.ColumnModel([nm, {
			header : "SpecRowId",
			dataIndex : 'SpecRowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "ILERowId",
			dataIndex : 'ILERowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "Inci",
			dataIndex : 'Inci',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'InciCode',
			width : 140,
			align : 'left',
			sortable : true,
			hidden : false
		}, {
			header : "物资名称",
			dataIndex : 'InciDesc',
			width : 200,
			align : 'left',
			sortable : true
		},{
			header : "具体规格",
			dataIndex : 'SpecDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "基本单位",
			dataIndex : 'BUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "包装单位",
			dataIndex : 'PUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "<font color=blue>库存上限</font>",
			dataIndex : 'MaxQty',
			width : 100,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true,
				listeners:{
					specialkey: function(field, e){
						var num=e.getKey();						
						if(num == e.ENTER){                                 
							var index=GetColIndex(ItmLocGrid,"MinQty");
							var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
							var row=cell[0];
							ItmLocGrid.startEditing(row,index);
						}
					}
				}
			})			
		},{
			header:"<font color=blue>库存下限</font>",
			dataIndex:"MinQty",
			width : 100,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true,
				listeners:{
					specialkey:function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER) {
								addNewRow()
						}
					}
				}
			})		
		}]);
    ItmLocCm.defaultSortable = true;

    // 访问路径
    var DspPhaUrl = DictUrl
                + 'locitmlimitsaction.csp?actiontype=Query&start=&limit=';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : DspPhaUrl,
                method : "POST"
            });
    // 指定列参数
    var fields = ["SpecRowId","ILERowId", "Inci", "InciCode", "InciDesc","SpecDesc","BUomDesc","PUomDesc","MaxQty","MinQty"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "SpecRowId",
		fields : fields
	});
    // 数据集
    var ItmLocStore = new Ext.data.Store({
		proxy : proxy,
		pruneModifiedRecords : true,
		reader : reader
		
	});
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store : ItmLocStore,
        pageSize : PageSize,
        displayInfo : true
    });
	var ItmLocGrid = new Ext.ux.EditorGridPanel({
		region: 'center',
		id : 'ItmLocGrid',
		title: '科室库存项<font color=blue>蓝色显示的列为可编辑列</font>',
		id:'ItmLocGrid',
		cm : ItmLocCm,
		store : ItmLocStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.grid.CellSelectionModel({}),
		clicksToEdit : 1,
		bbar:StatuTabPagingToolbar,
		loadMask : true
	});
/*
    var HisListTab = new Ext.ux.FormPanel({
        title:'科室库存上下限维护',
        tbar : [SearchBT, '-',SaveBT,'-',RefreshBT],            
        items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',
			style : 'padding:5px 0px 0px 5px',
			defaults:{border:false,xtype:'fieldset'},
			items:[{
					columnWidth:0.3,
					items:[PhaLoc]
				},{
					columnWidth:0.3,
					items:[StkGrpType]
				},{
					columnWidth:0.3,
					items:[InciDesc]
				}]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [  HisListTab,ItmLocGrid],
		renderTo : 'mainPanel'
	}); 
	*/
    var HisListTab = new Ext.form.FormPanel({
        title:'科室库存上下限维护',
        labelwidth : 30,
        height : 120,
        labelAlign : 'right',
        region: 'north',
        frame : true,
        tbar : [SearchBT, '-',SaveBT,'-',RefreshBT],            
        items : [{
			layout:'column',
			title:'查询条件',
			xtype:'fieldset',
			style:'padding:0px 0px 0px 0px;',
			defaults: {border:false}, 
			items:[{
					columnWidth:0.34,
					xtype:'fieldset',
					defaults: {width: 180},
					items:[PhaLoc]
				},{
					columnWidth:0.33,
					xtype:'fieldset',
					defaults: {width: 180},
					items:[StkGrpType]
				},{
					columnWidth:0.33,
					xtype:'fieldset',
					defaults: {width: 150},
					items:[InciDesc]    
				}]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [  HisListTab,
			{
				region: 'center',                                      
				//title: '科室库存项---<font color=blue>蓝色显示的列为可编辑列</font>',
				layout: 'fit', // specify layout manager for items
				items: ItmLocGrid                             
			}
		],
		renderTo : 'mainPanel'
	});  
})