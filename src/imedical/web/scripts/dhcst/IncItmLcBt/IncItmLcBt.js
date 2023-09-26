// /名称: 科室库存批次信息
// /描述: 科室库存批次信息
// /编写者：liangjiaquan
// /编写日期: 2015.05.19
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
        groupId:gGroupId,
        listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",SelLocId)
                          StkGrpType.getStore().setBaseParam("userId",gUserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
			}
	    }
    });
    
    
    // 药品类组
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
    	fieldLabel : '类组',
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //标识类组类型
        UserId:gUserId,
        LocId:gLocId,
        anchor : '90%'
    }); 
    
    var InciDesc = new Ext.form.TextField({
                fieldLabel : '药品名称',
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
     * 调用药品窗体并返回结果
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
        //Query();
    }
    
    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
                text : '查询',
                tooltip : '点击查询',
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
	                //Msg.info("error", "亲,该功能还没开发完成,暂时还不能使用···");
	                //return;
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
		ItmLocBatStore.removeAll();
        var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
        var BatchLockType = Ext.getCmp("BatchLockType").getValue();
        var StkLockType = Ext.getCmp("StkLockType").getValue();
        var StockType = Ext.getCmp("StockType").getValue();
        gStrParam=phaLoc+"^"+gIncId+"^"+StkGrpRowId+"^"+BatchLockType+"^"+StockType+"^"+StkLockType;
        var PageSize=StatuTabPagingToolbar.pageSize;
        ItmLocBatStore.setBaseParam('Params',gStrParam);   //分页时基本参数不会丢失
        ItmLocBatStore.load({params:{start:0,limit:PageSize}});
    }
    
    
    
    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
                text : '清屏',
                tooltip : '点击清屏',
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
        SetLogInDept(GetGroupDeptStore,'PhaLoc');
        Ext.getCmp('BatchLockType').setValue('0');
        Ext.getCmp("StockType").setValue('');
        Ext.getCmp("InciDesc").setValue('');
        StkGrpType.getStore().setBaseParam("locId",gLocId)
		StkGrpType.getStore().setBaseParam("userId",gUserId)
		StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
		StkGrpType.getStore().load();
        //ItmLocBatGrid.store.removeAll();
        ItmLocBatGrid.getStore().removeAll();
        ItmLocBatGrid.store.load({params:{start:0,limit:0}});
        ItmLocBatGrid.getView().refresh();
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
                    //Msg.info("error", "亲,该功能还没开发完成,暂时还不能使用···");
                    //return;           
                    save();                     
                }
            });
    
    
    function save(){
        
        var ListDetail="";
        var mr=ItmLocBatStore.getModifiedRecords();
        var data="";
        var rows="";
        for(var i=0;i<mr.length;i++){
            var inclb = mr[i].data["inclb"].trim();
            var batchlocflag=mr[i].data["lockFlag"];
            if(batchlocflag=="N"){batchlocflag="Y";}
            else{batchlocflag="N";} 
            var stkflag=mr[i].data["stkFlag"];
            if(stkflag=="N"){stkflag="Y";}
            else{stkflag="N";} 
            var dataRow =inclb + "^" + batchlocflag + "^" + stkflag;
            if(ListDetail==""){
                ListDetail = dataRow;
            }else{
                ListDetail = ListDetail+xRowDelim()+dataRow;
            }
        }
        var url = DictUrl
                + "incitmlcbtaction.csp?actiontype=SaveBatch";
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
                            //Query();
                            ItmLocBatStore.reload();
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
    
    var StockTypeStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['-1', '负库存'], ['0', '零库存'], ['1', '正库存']]
    });
    var StockType=new Ext.form.ComboBox({
        fieldLabel : '库存类型',
        id : 'StockType',
        name : 'StockType',
        anchor : '90%',
        store : StockTypeStore,
        mode : 'local',
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 240,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('StockType').setValue('');
    
    
    var BatchLockStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['0', '全部'], ['1', '仅禁用'], ['2', '仅可用']]
    });
    var BatchLockType=new Ext.form.ComboBox({
        fieldLabel : '医嘱可用',
        id : 'BatchLockType',
        name : 'BatchLockType',
        anchor : '90%',
        store : BatchLockStore,
        mode : 'local',
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('BatchLockType').setValue('0');
    
    var StkLockStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['0', '全部'], ['1', '仅禁用'], ['2', '仅可用']]
    });
    
    var StkLockType=new Ext.form.ComboBox({
        fieldLabel : '库存可用',
        id : 'StkLockType',
        name : 'StkLockType',
        anchor : '90%',
        store : StkLockStore,
        mode : 'local',
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('StkLockType').setValue('0');
    
    /*
	var InsuCatGrid="";
	//配置数据源
	var gridUrl = 'dhcst.incitmlcbtaction.csp';
	var InsuCatGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=GetInsuCatInfo',method:'GET'});
	var InsuCatGridDs = new Ext.data.Store({
		proxy:InsuCatGridProxy,
	    reader:new Ext.data.JsonReader({
			totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'Rowid'},
			{name:'Type'},
			{name:'ZFPercent'},
			{name:'YBPercent'}
		]),
	    remoteSort:false
	});

	//模型
	var InsuCatGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"医保类型",
	        dataIndex:'Type',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"自付比例",
	        dataIndex:'ZFPercent',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"医保比例",
	        dataIndex:'YBPercent',
	        width:80,
	        align:'left',
	        sortable:true
	    }
	]);

	//初始化默认排序功能
	InsuCatGridCm.defaultSortable = true;

	//表格
	InsuCaGrid = new Ext.grid.GridPanel({
		store:InsuCatGridDs,
		cm:InsuCatGridCm,
		trackMouseOver:true,
		width:200,
		height:100,
		stripeRows:true,
		sm:new Ext.grid.RowSelectionModel({}),
		loadMask:true
	});
	*/
    var ChkLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>医嘱批次禁用</font>',
       dataIndex: 'lockFlag',
       width: 100
    });
    
    var ChkStkLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>库存批次禁用</font>',
       dataIndex: 'stkFlag',
       width: 100
    });
    
    var nm = new Ext.grid.RowNumberer();
    var ItmLocBatCm = new Ext.grid.ColumnModel([nm, {
                header : "Rowid",
                dataIndex : 'inclb',
                width : 50,
                align : 'left',
                sortable : true,
                hidden : true
            },ChkLockFlag,ChkStkLockFlag, {
                header : '代码',
                dataIndex : 'code',
                width : 60,
                align : 'left',
                sortable : true,
                hidden : false
            }, {
                header : "名称",
                dataIndex : 'desc',
                width : 170,
                align : 'left',
                sortable : true
            },{
                header : "规格",
                dataIndex : 'spec',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "厂商",
                dataIndex : 'manf',
                width : 110,
                align : 'left',
                sortable : true
            },{
                header : "批号",
                dataIndex : 'batchNo',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "效期",
                dataIndex : 'batchExp',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "基本单位",
                dataIndex : 'bUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "包装单位",
                dataIndex : 'pUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"库存",
                dataIndex:"stkQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"可用库存",
                dataIndex:"avaQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"进价",
                dataIndex:"Rp",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"售价",
                dataIndex:"Sp",
                width : 80,
                align : 'left',
                sortable : true
            }]);
    ItmLocBatCm.defaultSortable = true;

    // 访问路径
    var DspPhaUrl = DictUrl
                + 'incitmlcbtaction.csp?actiontype=QueryBatch&start=&limit=';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : DspPhaUrl,
                method : "POST"
            });
    // 指定列参数
    var fields = ["inclb","code","desc","spec","manf","batchNo","batchExp","bUomDesc","pUomDesc","stkQty","avaQty","Rp","Sp","lockFlag","stkFlag"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "inclb",
                fields : fields
            });
    // 数据集
    var ItmLocBatStore = new Ext.data.Store({
                proxy : proxy,
                pruneModifiedRecords : true,
                reader : reader
                
            });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store : ItmLocBatStore,
        pageSize : PageSize,
        displayInfo : true,
        displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
        emptyMsg : "No results to display",
        prevText : "上一页",
        nextText : "下一页",
        refreshText : "刷新",
        lastText : "最后页",
        firstText : "第一页",
        beforePageText : "当前页",
        afterPageText : "共{0}页",
        emptyMsg : "没有数据"
    });
    var ItmLocBatGrid = new Ext.grid.EditorGridPanel({
                id:'ItmLocBatGrid',
                region : 'center',
                cm : ItmLocBatCm,
                store : ItmLocBatStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                bbar:StatuTabPagingToolbar,
                plugins: [ChkLockFlag,ChkStkLockFlag],
                loadMask : true
            });

var HisListTab = new Ext.form.FormPanel({
        title:'科室库存批次信息',
        labelWidth : 60,
        height : DHCSTFormStyle.FrmHeight(2),
        labelAlign : 'right',
        region: 'north',
        frame : true,
        tbar : [SearchBT,'-',RefreshBT, '-',SaveBT],            
        items : [{
                    layout:'column',
                    title:'查询条件',
                    xtype:'fieldset',
                    style:DHCSTFormStyle.FrmPaddingV,
                    defaults: {border:false}, 
                    items:[{
                            columnWidth:0.33,
                            xtype:'fieldset',
                            defaults: {width: 150},
                            items:[PhaLoc,StkGrpType]
                          },{
                            columnWidth:0.33,
                            xtype:'fieldset',
                            defaults: {width: 150},
                            items:[StockType,BatchLockType]
                          },{
                            columnWidth:0.33,
                            xtype:'fieldset',
                            defaults: {width: 150},
                            items:[InciDesc,StkLockType]
                          }]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
                layout : 'border',
                items : [  HisListTab,
                    {
                         region: 'center',                                      
                         title: '科室库存项---<font color=blue>蓝色显示的列为可编辑列</font>',
                         layout: 'fit', // specify layout manager for items
                         items: ItmLocBatGrid                             
                    }
                ],
                renderTo : 'mainPanel'
            });
    

    
})