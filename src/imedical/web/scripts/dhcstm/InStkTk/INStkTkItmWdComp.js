// /名称: 实盘数汇总
// /描述:  实盘数汇总
// /编写者：zhangdongmei
// /编写日期: 2012.09.10
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams='';
    var gStrParams='';
    var url=DictUrl+'instktkaction.csp';
    var gGroupId=session["LOGON.GROUPID"];
    var gLocId=session["LOGON.CTLOCID"];
    var gUserId=session["LOGON.USERID"];
    var PhaLoc = new Ext.ux.LocComboBox({
                fieldLabel : '科室',
                id : 'PhaLoc',
                name : 'PhaLoc',
                anchor : '90%',
                width : 160,
                emptyText : '科室...',
                listWidth : 250,
                //hideLabel:true,
                valueNotFoundText : '',
                groupId:gGroupId,
                stkGrpId : 'StkGrpType'
            });
    
    // 起始日期
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '起始日期',
                id : 'StartDate',
                name : 'StartDate',
                anchor : '90%',
                
                width : 120,
                value : new Date().add(Date.DAY, - 7)
            });

    // 结束日期
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '结束日期',
                id : 'EndDate',
                name : 'EndDate',
                anchor : '90%',
                
                width : 120,
                value : new Date()
            });

    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //标识类组类型
        LocId:gLocId,
        UserId:gUserId,
        width : 140,
        childCombo : 'DHCStkCatGroup'
    }); 

    var DHCStkCatGroup = new Ext.ux.ComboBox({
                fieldLabel : '库存分类',
                id : 'DHCStkCatGroup',
                name : 'DHCStkCatGroup',
                anchor : '90%',
                width : 140,
                store : StkCatStore,
                valueField : 'RowId',
                displayField : 'Description',
                params : {StkGrpId : 'StkGrpType'}
            });

    // 查询盘点单
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
    
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
        
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
        var CompFlag='Y';       //帐盘完成
        //var TkComplete='N';  //实盘完成标志
        var TkComplete=(Ext.getCmp('TkComplete').getValue()==true?'Y':'N');;  //实盘完成标志
        var AdjComplete='N';    //调整完成标志
        var Page=GridPagingToolbar.pageSize;
        gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
        
        if(TkComplete=="Y"){changeButtonEnable('0^1')}
        else{changeButtonEnable('1^0')}
        
        MasterInfoStore.removeAll();
        InstItmStore.removeAll();
        InstiStore.removeAll();
        InstDetailStore.removeAll();
        
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('sort','instNo');
		MasterInfoStore.setBaseParam('dir','asc');
		MasterInfoStore.setBaseParam('Params',gStrParams);
		MasterInfoStore.removeAll();
        MasterInfoStore.load({params:{start:0, limit:Page}});
    }
    
    // 查询实盘明细按钮
    var SearchBT = new Ext.Toolbar.Button({
                text : '查询',
                tooltip : '点击查询',
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    QueryDetail();
                }
            });
    
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
        
        Ext.getCmp("DHCStkCatGroup").setValue('');
        //Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("StkGrpType").setValue('');
        
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    var CompleteBT=new Ext.Toolbar.Button({
        text:'确认完成',
        tooltip:'确认完成',
        iconCls:'page_gear',
        width:70,
        height:30,
        handler:function(){
            Complete();
        }
    });
    
    //保存实盘数据
    function Complete(){
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        if(selectRow==null){
        	Msg.info("warning","没有需要确认汇总的盘点单!");
        	return;
        }
        var Inst=selectRow.get("inst");
        var InputType=selectRow.get("InputType");
        if(InputType==''){
        	Msg.info("warning","该盘点单尚未进行实盘录入!");
        	return;
        }
       
        var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'StkTkCompletet',Inst:Inst,UserId:gUserId,InputType:InputType},
            method:'post',
            waitMsg:'处理中...',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                 mask.hide();
                if(jsonData.success=='true'){
                    Msg.info('success','操作成功!');
                    Query();
                }else{
                    var ret=jsonData.info;
                    if(ret=='-1'){
                        Msg.info('warning','没有需要确认的盘点单!');
                    }else if(ret=='-99'){
                        Msg.info('error','加锁失败!');
                    }else if(ret=='-2'){
                        Msg.info('error','实盘数已经确认汇总!');
                    }else if(ret=='-5'){
                        Msg.info('error','汇总实盘数失败!');
                    }else if(ret=='-100'){
                        Msg.info('error','更新实盘标志失败!');
                    }else{
                        Msg.info('error','操作失败:'+ret);
                    }
                }
            }       
        });
    }
     var TkComplete=new Ext.form.Checkbox({
		fieldLabel:'汇总完成',
		id:'TkComplete',
		name:'TkComplete',
		width:80,
		disabled:false
		//checked :true
	});
    //取消完成
    var CancelCompleteBT = new Ext.Toolbar.Button({
                text : '<font color=red>取消完成</font>',
                tooltip : '取消汇总',
                iconCls:'page_gear',
                width : 70,
                height : 30,
                handler : function(){
                    Cancel();
                }
            });

     function Cancel(){
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        if(selectRow==null){
        	Msg.info("warning","没有需要取消汇总的盘点单!");
        	return;
        }
        
	    Ext.MessageBox.confirm("取消汇总","是否确认取消汇总该盘点单!",function(btn){
		    if(btn == 'yes'){
			    var Inst=selectRow.get("inst");
                var mask=ShowLoadMask(Ext.getBody(),"处理中...");
		        Ext.Ajax.request({
		            url:url,
		            params:{actiontype:'StkCancelComplete',Inst:Inst},
		            method:'post',
		            waitMsg:'处理中...',
		            success:function(response,opt){
		                var jsonData=Ext.util.JSON.decode(response.responseText);
		                if(jsonData.success=='true'){
		                    Msg.info('success','操作成功!');
		                    Query();
		                }else{
		                    var ret=jsonData.info;
		                    if(ret=='-1'){
		                        Msg.info('warning','没有需要确认的盘点单!');
		                    }else if(ret=='-2'){
		                        Msg.info('error','没有需要确认的盘点单!');
		                    }else if(ret=='-3'){
		                        Msg.info('error','实盘数已经确认盘点!');
		                    }else if(ret=='-4'){
		                        Msg.info('error','该记录没有汇总！');
		                    }else{
		                        Msg.info('error','操作失败:'+ret);
		                    }
		                }
		                mask.hide();
		            }       
		        })} 
		        });
     }
        function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			//查询^清除^新增^保存^删除^完成^取消完成
			CompleteBT.setDisabled(list[0]);
			CancelCompleteBT.setDisabled(list[1]);
    }     
    // 指定列参数
    // 指定列参数
    var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
            "adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","InputType"];
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
    
    function renderCompFlag(value){
        if(value=='Y'){
            return '完成';
        }else{
            return '未完成'
        }   
    }
    function renderManaFlag(value){
        if(value=='Y'){
            return '是';
        }else{
            return '否'
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
                header : '重点关注',
                dataIndex : 'manFlag',
                width : 50,
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
                width : 50,
                align : 'center',
                renderer:renderYesNo,
                sortable : true
            }, {
                header : "仅不可用",
                dataIndex : 'onlyNotUse',
                renderer:renderYesNo,
                width : 50,
                align : 'center',
                sortable : true
            }, {
                header : "类组",
                dataIndex : 'scgDesc',
                width : 100,
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
            },{
                header : "实盘类型",
                dataIndex : 'InputType',
                width : 100,
                align : 'left',
                sortable : true,
                renderer:function(value){
                    if(value=='1'){
                        return "分批次";
                    }else if(value=='2'){
                        return "按品种";
                    }else if(value=='3'){
						return "按高值条码";
					}else{
                        return value;
                    }
                }
            }]);
    MasterInfoCm.defaultSortable = true;
    var GridPagingToolbar = new Ext.PagingToolbar({
                    store : MasterInfoStore,
                    pageSize : PageSize,
                    displayInfo : true
                });
    var MasterInfoGrid = new Ext.grid.GridPanel({
                id : 'MasterInfoGrid',
                title : '',
                height : 450,
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
        // 双击事件
    MasterInfoGrid.on('rowclick', function(grid,rowindex,e) {
        QueryDetail();
    });
    
    //查找盘点单及明细信息
    function QueryDetail(){
        
        //查询盘点单明细
        //var StkGrpId=Ext.getCmp('StkGrpType').getValue();
        //var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
        var size=StatuTabPagingToolbar.pageSize;
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        var Inst=selectRow.get("inst");
        gStrDetailParams=Inst;   //+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
        InstiStore.removeAll();
        InstDetailStore.removeAll(); 
        InstItmStore.removeAll();
        InstItmStore.setBaseParam('sort', 'Inci');
        InstItmStore.setBaseParam('dir', 'ASC');
        InstItmStore.setBaseParam('Params', gStrDetailParams);
        InstItmStore.load({
        	params:{start:0,limit:size},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error","查询错误, 请查看日志!");
        		}
        	}
        });
    }
    
    //-------物资汇总grid----------------------------------------------------------
    var nm = new Ext.grid.RowNumberer();
    var InstItmGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'Rowid',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "Inci",
                dataIndex : 'Inci',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header : '代码',
                dataIndex : 'InciCode',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "名称",
                dataIndex : 'InciDesc',
                width : 250,
                align : 'left',
                sortable : true
            }, {
                header : "规格",
                dataIndex : 'Spec',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : '冻结数量',
                dataIndex : 'FreezeQty',
                width : 120,
                align : 'right',
                sortable : true
            },{
                header:'实盘数量',
                dataIndex:'CountQty',
                width:120,
                align:'right',
                sortable:true
            },{
                header:'最新进价(入库单位)',
                dataIndex:'LastRp',
                width:150,
                align:'right'
            }]);
    InstItmGridCm.defaultSortable = true;

    // 数据集
    var InstItmStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url + '?actiontype=CollectItmCountQty',
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Rowid",
                    fields : ["Rowid","Inci", "InciCode", "InciDesc", "Spec","PurUomDesc","FreezeQty", "CountQty", "LastRp"]
                })
    });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstItmStore,
                pageSize : PageSize,
                displayInfo : true
            });
    var InstItmGrid = new Ext.grid.GridPanel({
    		title : '物资汇总',
            id:'InstItmGrid',
            cm : InstItmGridCm,
            store : InstItmStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            view : new Ext.grid.GridView({forceFit : true}),
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            bbar:StatuTabPagingToolbar,
            loadMask : true
        });
    // 单击事件
    InstItmGrid.on('rowclick', function(grid,rowindex,e) {
        var selectRow=InstItmGrid.getSelectionModel().getSelected();
        var inci=selectRow.get("Inci");
        var inst=gStrDetailParams;
        InstiStore.removeAll();
        InstDetailStore.removeAll();
        InstiStore.load({
        	params:{actiontype:'QueryItmTkWd',Inst:inst,Inci:inci},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error","查询有误,请查看日志!");
        			return;
        		}
        	}
        });
        InstDetailStore.load({
        	params:{actiontype:'QueryItmTkWdDetail',Inst:inst,Inci:inci},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error","查询有误,请查看日志!");
        			return;
        		}
        	}
        });       
    });
    
    //-------物资汇总grid----------------------------------------------------------
    
    //-------物资批次grid----------------------------------------------------------
    var nm = new Ext.grid.RowNumberer();
    var InstiGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'Insti',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "Inclb",
                dataIndex : 'Inclb',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header : '批号',
                dataIndex : 'BatNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "效期",
                dataIndex : 'ExpDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "单位",
                dataIndex : 'FreUomDesc',
                width : 60,
                align : 'left',
                sortable : true
            }, {
                header : '冻结数量',
                dataIndex : 'FreQty',
                width : 80,
                align : 'right',
                sortable : true
            },{
                header:'实盘数量',
                dataIndex:'CountQty',
                width:80,
                align:'right',
                sortable:true
            }]);
    InstiGridCm.defaultSortable = true;

    // 数据集
    var InstiStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Insti",
                    fields : ["Insti","Inclb", "BatNo", "ExpDate", "FreUomDesc","FreQty","CountQty"]
                })
    });
    
    var InstiGrid = new Ext.grid.GridPanel({
    		title : '批次汇总',
            id:'InstiGrid',
            cm : InstiGridCm,
            store : InstiStore,
            trackMouseOver : true,
            stripeRows : true,
            view : new Ext.grid.GridView({forceFit : true}),
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true
        });     
    //-------物资批次grid----------------------------------------------------------
    
    //-------实盘明细grid----------------------------------------------------------
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
                header : "rowid",
                dataIndex : 'Rowid',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : "Inclb",
                dataIndex : 'Inclb',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            },{
                header : '批号',
                dataIndex : 'BatNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "效期",
                dataIndex : 'ExpDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "单位",
                dataIndex : 'CountUom',
                width : 60,
                align : 'left',
                sortable : true
            },{
                header:'实盘数量',
                dataIndex:'CountQty',
                width:80,
                align:'right',
                sortable:true
            },{
                header:'实盘日期',
                dataIndex:'CountDate',
                width:80,
                align:'right',
                sortable:true
            },{
                header : "实盘时间",
                dataIndex : 'CountTime',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "实盘人",
                dataIndex : 'CountUserName',
                width : 80,
                align : 'left',
                sortable : true
            }]);
    InstDetailGridCm.defaultSortable = true;

    // 数据集
    var InstDetailStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Rowid",
                    fields : ["Rowid","Inclb", "BatNo", "ExpDate", "CountUom","CountQty","CountDate", "CountTime", "CountUserName"]
                })
    });
    
    var InstDetailGrid = new Ext.grid.GridPanel({
    		title: '批次明细',
            id:'InstDetailGrid',
            cm : InstDetailGridCm,
            store : InstDetailStore,
            trackMouseOver : true,
            stripeRows : true,
            view : new Ext.grid.GridView({forceFit : true}),
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true
        });
        
    //-------实盘明细grid----------------------------------------------------------
        
    var formMain=new Ext.form.FormPanel({
    	region : 'north',
    	autoHeight : true,
        labelAlign : 'right',
        bodyStyle : 'padding:10px 0px 0px 0px;',
        style: 'padding:0 0 0 0;',
        frame:true,
        tbar:[QueryBT,'-',CompleteBT,'-',CancelCompleteBT],
        items:[{
        	xtype : 'fieldset',
        	title : '查询条件',
        	items :[PhaLoc,StartDate,EndDate,TkComplete]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.ux.Viewport({
                layout : 'border',
                items :  [{
                            region:'west',  
                            width:300,
                            minSize:250,
                            maxSize:400,
                            split: true,
                            collapsible: true, 
                            title:'盘点单-实盘数汇总',
                            layout:'border',
                            items:[formMain,{
                                        region:'center',
                                        layout:'fit',
                                        items:[MasterInfoGrid]
                                   }]
                        },{
                            region:'center',
                            layout:'border',
                            items:[{
                                        region:'north',
                                        height:400,
                                        minSize:250,
                                        maxSize:400,
                                        split: true,
                                        //collapsible: true, 
                                        layout:'fit',
                                        items:[InstItmGrid ]
                                   },{
                                        region:'east',
                                        width : '55%',
                                        split:true,
                                        minSize:50,
                                        maxSize:500,
                                        //collapsible: true,
                                        layout:'fit',
                                        items:[InstDetailGrid]
                                    },{
                                        region:'center',
                                        layout:'fit',
                                        items:[InstiGrid]
                                    }]
                            
                        }],                 
                renderTo : 'mainPanel'
    });

    Query();
})