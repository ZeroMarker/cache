// /名称: 盘点单调整
// /描述: 盘点单调整
// /编写者：zhangdongmei
// /编写日期: 2012.09.12
var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM')
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParams='';
    var gRowid='';
    var gGroupId=session["LOGON.GROUPID"];
    var url=DictUrl+'instktkaction.csp';
    var PhaLoc = new Ext.ux.LocComboBox({
                fieldLabel : '科室',
                id : 'PhaLoc',
                name : 'PhaLoc',
                anchor : '90%',
                emptyText : '科室...',
                groupId:gGroupId
            });
    
    // 起始日期
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '起始日期',
                id : 'StartDate',
                value : new Date().add(Date.DAY, - 30)
            });

    // 结束日期
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '结束日期',
                id : 'EndDate',
                value : new Date()
            });
    
    // 查询按钮
    var QueryBT = new Ext.Toolbar.Button({
                text : '查询',
                tooltip : '点击查询',
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    Query();
                }
            });
    
    //查询盘点单
    function Query(){
    
        var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
        var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
        var PhaLoc = Ext.getCmp("PhaLoc").getValue();   
        if(PhaLoc==""){
            Msg.info("warning", "请选择盘点科室!");
            return;
        }
        if(StartDate==""||EndDate==""){
            Msg.info("warning", "请选择开始日期和截止日期!");
            return;
        }
        var CompFlag='Y';
        var TkComplete='Y';  //实盘完成标志
        var AdjComplete='N';    //调整完成标志
        var Page=GridPagingToolbar.pageSize;
        gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
        MasterInfoStore.load({params:{actiontype:'Query',start:0, limit:Page,sort:'instNo',dir:'asc',Params:gStrParams}});
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
        
        gStrParams='';
        var stDate=new Date().add(Date.DAY, - 30);
        var edDate=new Date();
        Ext.getCmp("StartDate").setValue(stDate);
        Ext.getCmp("EndDate").setValue(edDate);
        MasterInfoStore.removeAll();
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    var CompleteBT=new Ext.Toolbar.Button({
        text:'确认',
        tooltip:'点击确认',
        iconCls:'page_gear',
        width:70,
        height:30,
        handler:function(){
            Complete();
        }
    });
    
    function Complete(){
        
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        if(selectRow==null || selectRow==""){
            Msg.info("Warning","请选择要调整的盘点单!");
            return;
        }
       
        var inst=selectRow.get('inst');
        if(inst==null || inst==""){
            Msg.info("Warning","请选择要调整的盘点单!");
            return;
        }
        var userId=session['LOGON.USERID'];
        var mask=ShowLoadMask(Ext.getBody(),"处理中...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'StkTkAdj',Inst:inst,UserId:userId},
            method:'post',
            waitMsg:'处理中...',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                 mask.hide();
                if(jsonData.success=='true'){
                    Msg.info("success","调整成功!");
                    Query();
                    InstDetailGrid.store.removeAll();
                    InstDetailGrid.getView().refresh();
                }else{
                    var ret=jsonData.info;
                    if(ret==-1){
                        Msg.info("error","该盘点单帐盘尚未完成!");
                    }else if(ret==-2){
                        Msg.info("error","该盘点单实盘数尚未汇总!");
                    }else if(ret==-3){
                        Msg.info("error","该盘点单已经调整!");
                    }else if(ret==-4){
                        Msg.info("error","保存调整单失败!");
                    }else if(ret==-6){
                        Msg.info("error","保存调整明细失败!");
                    }else if(ret==-8){
                        Msg.info("error","调整审核失败!");
                    }else{
                        Msg.info("error","操作失败："+ret);
                    }
                }
                
               
            }           
        });
    }
	
	var PrintBT = new Ext.Toolbar.Button({
		text:'打印',
		tooltip:'点击打印盘点单',
		iconCls:'page_print',
		width:70,
		height:30,
		handler:function(){
			var selectRow = MasterInfoGrid.getSelectionModel().getSelected();
			if(Ext.isEmpty(selectRow)){
				Msg.info("warning", "请选择要打印的盘点单!");
				return;
			}
			var inst = selectRow.get('inst');
			PrintINStk(inst,0);
		}
	});
    
    // 指定列参数
    var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
            "adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "inst",
                fields : fields
            });
    // 数据集
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : url,
                method : "POST"
            });
    var MasterInfoStore = new Ext.data.Store({
                proxy : proxy,
                reader : reader
            }); 
    function renderManaFlag(value){
        if(value=='Y'){
            return '重点关注';
        }else{
            return '非重点关注'
        }   
    }
    function renderYesNo(value){
        if(value=='Y'){
            return '是';
        }else{
            return '否'
        }   
    }
    var nm = new Ext.grid.RowNumberer();
    var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
                header : "RowId",
                dataIndex : 'inst',
                width : 100,
                align : 'left',
                sortable : true,
                hidden : true,
                hideable : false
            }, {
                header : "盘点单号",
                dataIndex : 'instNo',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : "盘点日期",
                dataIndex : 'date',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : '盘点时间',
                dataIndex : 'time',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : '盘点人',
                dataIndex : 'userName',
                width : 70,
                align : 'left',
                sortable : true
            }, {
                header : '重点关注标志',
                dataIndex : 'manFlag',
                width : 80,
                align : 'left',
                renderer:renderManaFlag,
                sortable : true
            }, {
                header : "帐盘单位",
                dataIndex : 'freezeUom',
                width : 80,
                align : 'left',
                renderer:function(value){
                    if(value==1){
                        return '入库单位';
                    }else{
                        return '基本单位';
                    }
                },
                sortable : true
            }, {
                header : "包含不可用",
                dataIndex : 'includeNotUse',
                width : 80,
                align : 'center',
                renderer:renderYesNo,
                sortable : true
            }, {
                header : "仅不可用",
                dataIndex : 'onlyNotUse',
                renderer:renderYesNo,
                width : 60,
                align : 'center',
                sortable : true
            }, {
                header : "类组",
                dataIndex : 'scgDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "库存分类",
                dataIndex : 'scDesc',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "开始货位",
                dataIndex : 'frSb',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "截止货位",
                dataIndex : 'toSb',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    MasterInfoCm.defaultSortable = true;
    var GridPagingToolbar = new Ext.PagingToolbar({
                    store : MasterInfoStore,
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
                    emptyMsg : "没有数据",
                    doLoad:function(C){
                        var B={},
                        A=this.getParams();
                        B[A.start]=C;
                        B[A.limit]=this.pageSize;
                        B[A.sort]='Rowid';
                        B[A.dir]='desc';
                        B['Params']=gStrParams;
                        B['actiontype']='Query';
                        if(this.fireEvent("beforechange",this,B)!==false){
                            this.store.load({params:B});
                        }
                    }
                });
    var MasterInfoGrid = new Ext.grid.GridPanel({
                id : 'MasterInfoGrid',
                title : '',
                height : 170,
                cm : MasterInfoCm,
                sm : new Ext.grid.RowSelectionModel({
                            singleSelect : true
                        }),
                store : MasterInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                loadMask : true,
                bbar:[GridPagingToolbar]
            });
    
    MasterInfoGrid.on('rowclick',function(grid,rowindex,e){
        var selectRow=MasterInfoStore.getAt(rowindex);
        gRowid=selectRow.get('inst');
        InstDetailStore.setBaseParam('Parref', gRowid);
        var VarianceFlag = Ext.getCmp('VarianceFlag').getValue().getGroupValue();
        var Others = VarianceFlag;
        InstDetailStore.setBaseParam('Params', Others);
        var size=StatuTabPagingToolbar.pageSize;
        InstDetailStore.load({params:{start:0,limit:size}});
    });
            
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'rowid',
                width : 80,
                align : 'left',
                hidden : true
            },{
                header:"inclb",
                dataIndex:'inclb',
                width:80,
                align:'left',
                hidden:true
            },{
                header : '物资代码',
                dataIndex : 'code',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "物资名称",
                dataIndex : 'desc',
                width : 200,
                align : 'left',
                sortable : true
            }, {
                header : "规格",
                dataIndex : 'spec',
                width : 80,
                align : 'left'
            },{
                header:'批号',
                dataIndex:'batchNo',
                width:80,
                align:'left'
            }, {
                header:'效期',
                dataIndex:'expDate',
                width:100,
                align:'left'
            }, {
                header : "单位",
                dataIndex : 'uomDesc',
                width : 60,
                align : 'left'
            }, {
                header : "进价",
                dataIndex : 'rp',
                width : 60,
                align : 'right'
            }, {
                header : '冻结数量',
                dataIndex : 'freQty',
                width : 80,
                align : 'right'
            },{
                header:'实盘数量',
                dataIndex:'countQty',
                width:80,
                align:'right'            
            },{
                header:'损益数量',
                dataIndex:'variance',
                width:80,
                align:'right'             
            },{
                header:'冻结金额',
                dataIndex:'freezeRpAmt',
                width:80,
                align:'right'
            },{
                header:'实盘金额',
                dataIndex:'countRpAmt',
                width:80,
                align:'right'
            },{
                header:'损益进价金额',
                dataIndex:'varianceRpAmt',
                width:80,
                align:'right'
            },{
                header : "厂商",
                dataIndex : 'manf',
                width : 100,
                align : 'left'
            }]);

    // 数据集
    var InstDetailStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "instw",
                    fields : ["rowid","inclb", "inci", "code", "desc","spec", "manf", "batchNo", "expDate",
                            "freQty", "uom", "uomDesc", "countQty","freDate","freTime","rp","freezeRpAmt","countRpAmt",
                            "countDate","countTime","countPersonName","variance","varianceRpAmt"]
                }),
                remoteSort:true,
                baseParams : {
                	actiontype:'QueryDetail',
                	sort:'desc',
                	dir:'ASC'
                }
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstDetailStore,
                pageSize : PageSize,
                displayInfo : true
            });
    
    var InstDetailGrid = new Ext.ux.EditorGridPanel({
                id:'InstDetailGrid',
                region : 'center',
                cm : InstDetailGridCm,
                store : InstDetailStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.RowSelectionModel(),
                loadMask : true,
                bbar : StatuTabPagingToolbar
            });

	var VarianceFlag=new Ext.form.RadioGroup({
		id:'VarianceFlag',
		columns:3,
		itemCls: 'x-check-group-alt',
		hideLabel : true,
		items:[
			{boxLabel:'仅盘盈',name:'loss',id:'onlySurplus',inputValue:1},
			{boxLabel:'仅盘亏',name:'loss',id:'onlyLoss',inputValue:2},
			{boxLabel:'仅无损益',name:'loss',id:'onlyBalance',inputValue:3},
			{boxLabel:'仅有损益',name:'loss',id:'onlyNotBalance',inputValue:4},
			{boxLabel:'全部',name:'loss',inputValue:0,id:'all',checked:true}
		],
		listeners : {
			change : function(radioGroup, checked){
				if(checked.getValue() == true){
					var record = MasterInfoGrid.getSelectionModel().getSelected();
					if(Ext.isEmpty(record)){
						return;
					}
					var rowIndex = MasterInfoGrid.getStore().indexOf(record);
					MasterInfoGrid.fireEvent('rowclick', MasterInfoGrid, rowIndex);
				}
			}
		}
	});
	
	var form = new Ext.form.FormPanel({
		region: 'north',
		autoHeight : true,
		labelAlign : 'right',
		frame : true,
		title:'盘点调整',
		bodyStyle : 'padding:5px 0px 0px 0px;',
		tbar:[QueryBT,'-',CompleteBT,'-',RefreshBT,'-',PrintBT],
		layout : 'column',
		items:[{
			columnWidth : 0.5,
			xtype:'fieldset',
			title:'查询条件',
			layout: 'column',
			items : [{
				columnWidth: 0.5,
				layout: 'form',
				items: [PhaLoc]
			},{
				columnWidth: 0.5,
				layout: 'form',
				items: [StartDate, EndDate]
			}]
		},{
			style : 'margin-left:10px',
			columnWidth : 0.5,
			xtype:'fieldset',
			title:'单据过滤',
			layout: 'column',
			items : [{
				columnWidth: 0.6,
				layout: 'form',
				items: [VarianceFlag]
			}]
		}]
	});

    var mainPanel = new Ext.ux.Viewport({
                layout : 'border',
                items : [form,{
                        region: 'west',
                        split: true,
                        collapsible: true,
                        width: 300,
                        minSize:250,
                        maxSize:400,
                        layout: 'fit',
                        items: MasterInfoGrid
                    }, {
                        region: 'center',
                        layout:'fit',
                        items:[InstDetailGrid]
                    }
                ],
                renderTo : 'mainPanel'
    });
    
    Query();
})