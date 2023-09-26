// /名称: 实盘数确认
// /描述:  实盘数确认
// /编写者：zhangdongmei
// /编写日期: 2012.09.10
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams='';
    var gStrParams='';
    var url=DictUrl+'instktkaction.csp';
    Ext.Ajax.timeout = 900000;
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
                groupId:gGroupId
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
            
    var LocManaGrp = new Ext.form.ComboBox({
                fieldLabel : '管理组',
                id : 'LocManaGrp',
                name : 'LocManaGrp',
                //anchor : '95%',
                width : 140,
                store : LocManGrpStore,
                valueField : 'RowId',
                displayField : 'Description',
                allowBlank : true,
                triggerAction : 'all',
                emptyText : '管理组...',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                pageSize : 20,
                listWidth : 250,
                valueNotFoundText : '',
                listeners:{
                    'expand':function(combox){
                            var LocId=Ext.getCmp('PhaLoc').getValue();
                            LocManGrpStore.load({params:{start:0,limit:20,locId:LocId}});   
                    }
                }
            });     
        
    var PhaWindow = new Ext.form.ComboBox({
            fieldLabel : '实盘窗口',
            id : 'PhaWindow',
            name : 'PhaWindow',
            //anchor : '95%',
            width : 140,
            store : PhaWindowStore,
            valueField : 'RowId',
            displayField : 'Description',
            allowBlank : true,
            triggerAction : 'all',
            emptyText : '实盘窗口...',
            selectOnFocus : true,
            forceSelection : true,
            minChars : 1,
            pageSize : 20,
            listWidth : 250,
            valueNotFoundText : '',
            listeners:{
                'beforequery':function(e){
                    var desc=Ext.getCmp('PhaWindow').getRawValue();
                    if(desc!=null || desc.length>0){
                        PhaWindowStore.load({params:{start:0,limit:20,Desc:desc}});
                    }
                }
            }
        });         
    
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //标识类组类型
        LocId:gLocId,
        UserId:gUserId,
        width : 140
    }); 

    var DHCStkCatGroup = new Ext.form.ComboBox({
                fieldLabel : '库存分类',
                id : 'DHCStkCatGroup',
                name : 'DHCStkCatGroup',
                anchor : '90%',
                width : 140,
                store : StkCatStore,
                valueField : 'RowId',
                displayField : 'Description',
                allowBlank : true,
                triggerAction : 'all',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                valueNotFoundText : '',
                listeners:{
                    'beforequery':function(e){
                        var grp=Ext.getCmp("StkGrpType").getValue();
                        StkCatStore.removeAll();
                        StkCatStore.load({params:{start:0,limit:20,StkGrpId:grp}})
                    }
                }
            });
        
    var StkBin = new Ext.form.ComboBox({
        fieldLabel : '货位',
        id : 'StkBin',
        name : 'StkBin',
        anchor : '90%',
        width : 140,
        store : LocStkBinStore,
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
        enableKeyEvents : true,
        listeners : {
            'expand' : function(e) {
                var LocId=Ext.getCmp("PhaLoc").getValue();
                LocStkBinStore.load({params:{LocId:LocId,Desc:Ext.getCmp('StkBin').getRawValue(),start:0,limit:20}});                   
            }
        }
    }); 
    
    var NullInputFlag=new Ext.form.RadioGroup({
        id:'NullInputFlag',
        anchor: '95%',
        columns: 1,
        style: 'padding:5px 5px 5px 5px;',
        items : [{
                    checked: true,                           
                    boxLabel: '未填数默认为0',
                    id: 'InputSelFlag1',
                    name:'InputSelFlag',
                    inputValue: 0
                },{
                    checked: false,                          
                    boxLabel: '未填数默认为账盘数',
                    id: 'InputSelFlag2',
                    name:'InputSelFlag',
                    inputValue: '1'                           
                }]  
    });
    
	var TkComplete=new Ext.form.Checkbox({
		fieldLabel:'实盘完成',
		id:'TkComplete',
		name:'TkComplete',
		width:80,
		disabled:false
		//checked :true
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
        
        var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
        var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
        var PhaLoc = Ext.getCmp("PhaLoc").getValue();   
        if(PhaLoc==""){
            Msg.info("warning", "请选择盘点科室!");
            return;
        }
        if(StartDate==""||EndDate==""){
            Msg.info("warning", "请选择开始日期和截止日期!");
            return;
        }
        var CompFlag='Y';       //账盘完成
        //var TkComplete='N';  //实盘完成标志
        var TkComplete=(Ext.getCmp('TkComplete').getValue()==true?'Y':'N');;  //实盘完成标志
        var AdjComplete='N';    //调整完成标志
        var Page=GridPagingToolbar.pageSize;
        gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
        
       if(TkComplete=="Y"){changeButtonEnable('0^1')}
       else{changeButtonEnable('1^0')}
        
        MasterInfoStore.removeAll();
        InstItmStore.removeAll();
        InstItmStore.load({params:{start:0,limit:0}});
	 	InstItmGrid.getView().refresh();
        InstiStore.removeAll();
        InstDetailStore.removeAll();
        
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('sort','instNo');
		MasterInfoStore.setBaseParam('dir','asc');
		MasterInfoStore.setBaseParam('Params',gStrParams);
		MasterInfoStore.removeAll();
        MasterInfoStore.load({params:{start:0, limit:Page}});
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
    
		// 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '另存',
				tooltip : '另存为Excel',
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(InstItmGrid);
				}
			});
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
        
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StkBin").setValue('');
        //Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("PhaWindow").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        
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
        if(InputType==0){
        	Msg.info("warning","该盘点单尚未进行实盘录入!");
        	return;
        }
        var InputSelValue="";
        var selectRadio = Ext.getCmp('NullInputFlag').getValue();   
        if(selectRadio){
            InputSelValue =selectRadio.inputValue;    // selectRadio.getValue();                
        }
        
        if(InputSelValue===""){
            Msg.info('warning','请选择未填实盘数默认方式!');
            return;
        }
        if(Inst==null || Inst==""){
            Msg.info('warning','没有需要确认汇总的盘点单!');
            return;
        }
        var mask=ShowLoadMask(Ext.getBody(),"处理中...");
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'StkTkCompletet',Inst:Inst,UserId:gUserId,InputNullFlag:InputSelValue,InputType:InputType},
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
                
                mask.hide();
            }       
        });
    }
     var CancelCompleteBT = new Ext.Toolbar.Button({
                text : '取消汇总',
                tooltip : '取消汇总',
                iconCls : 'page_gear',
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
                    }else if(ret=='-5'){
                        Msg.info('error','部分记录已经完成调整，请在盘点调整界面修改实盘数量继续完成盘点！');
                    }else{
                        Msg.info('error','操作失败:'+ret);
                    }
                }
                mask.hide();
            }       
        });
     }
            
            
            
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
            return '管理药';
        }else{
            return '非管理药'
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
                header : '管理药标志',
                dataIndex : 'manFlag',
                width : 50,
                align : 'left',
                renderer:renderManaFlag,
                sortable : true
            }, {
                header : "账盘单位",
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
                    if(value==1){
                        return "分批次";
                    }else if(value==2){
                        return "按品种";
                    }else{
                        return "";
                    }                   
                }
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
                    emptyMsg : "没有数据"
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
        var size=StatuTabPagingToolbar.pageSize;
        var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
        var Inst=selectRow.get("inst");
        gStrDetailParams=Inst;   //+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
        InstiStore.removeAll();
        InstDetailStore.removeAll(); 
        InstItmStore.removeAll();
        InstItmStore.load({
        	params:{actiontype:'CollectItmCountQty',start:0,limit:size,sort:'Rowid',dir:'ASC',Params:gStrDetailParams},
        	callback:function(r,options,success){
        		if(success==false){
        			Ext.MessageBox.alert("查询错误", InstItmStore.reader.jsonData.Error);
        		}
        	}
        });
    }
    
    //-------药品汇总grid----------------------------------------------------------
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
                width : 150,
                align : 'right',
                sortable : true
            },{
                header:'实盘数量',
                dataIndex:'CountQty',
                width:150,
                align:'right',
                sortable:true
            }, {
                header : '冻结数量(基本单位)',
                dataIndex : 'FreezeBQty',
                width : 150,
                align : 'right',
                sortable : false,
                hidden:true
            },{
                header:'实盘数量(基本单位)',
                dataIndex:'CountBQty',
                width:150,
                align:'right',
                sortable:true,
                sortable : false,
                hidden:true
            },{
                header:'冻结进价金额',
                dataIndex:'FreezeRpAmt',
                width:150,
                align:'right',
                sortable:true,
                sortable : false
            },{
                header:'实盘进价金额',
                dataIndex:'CountRpAmt',
                width:150,
                align:'right',
                sortable:true,
                sortable : false
            }]);
    InstItmGridCm.defaultSortable = true;

    // 数据集
    var InstItmStore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                    url : url,
                    method : "POST"
                }),
                reader :  new Ext.data.JsonReader({
                    root : 'rows',
                    totalProperty : "results",
                    id : "Rowid",
                    fields : ["Rowid","Inci", "InciCode", "InciDesc", "Spec","PurUomDesc","FreezeQty", "CountQty", "CountDate", "CountTime","FreezeBQty","CountBQty","FreezeRpAmt","CountRpAmt"]
                }),
                remoteSort:true
    });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
                store : InstItmStore,
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
                    B[A.dir]='asc';
                    B['Params']=gStrDetailParams;
                    B['actiontype']='CollectItmCountQty';
                    if(this.fireEvent("beforechange",this,B)!==false){
                        this.store.load({params:B});
                    }
                }
            });
    var InstItmGrid = new Ext.grid.GridPanel({
            id:'InstItmGrid',
            cm : InstItmGridCm,
            store : InstItmStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            bbar:StatuTabPagingToolbar,
            loadMask : true,
            viewConfig:{
	            	getRowClass : function(record,rowIndex,rowParams,store){ 
						var freezeqty=record.get("FreezeBQty");
						var countqty=record.get("CountBQty");
						var colorflag="";					
						if (Number(freezeqty)>Number(countqty)) {colorflag="-1";}
						else if (Number(freezeqty)<Number(countqty)) {colorflag="1";}
						switch(colorflag){
							case "1":
								return 'classAquamarine';
								break;
							case "-1":
								return 'classSalmon';
								break;
						}
					}
            }
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
    
    //-------药品汇总grid----------------------------------------------------------
    
    //-------药品批次grid----------------------------------------------------------
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
                width : 100,
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
            id:'InstiGrid',
            cm : InstiGridCm,
            store : InstiStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true,
                    viewConfig:{
	            	getRowClass : function(record,rowIndex,rowParams,store){ 
						var freezeqty=record.get("FreQty");
						var countqty=record.get("CountQty");
						var colorflag="";					
						if (Number(freezeqty)>Number(countqty)) {colorflag="-1";}
						else if (Number(freezeqty)<Number(countqty)) {colorflag="1";}
						switch(colorflag){
							case "1":
								return 'classAquamarine';
								break;
							case "-1":
								return 'classSalmon';
								break;
						}
					}
            }
        });     
    //-------药品批次grid----------------------------------------------------------
    
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
                width : 100,
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
                width:90,
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
            id:'InstDetailGrid',
            cm : InstDetailGridCm,
            store : InstDetailStore,
            trackMouseOver : true,
            stripeRows : true,
            height:400,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
            loadMask : true
        });
        
    //-------实盘明细grid----------------------------------------------------------
        
        var formMain=new Ext.form.FormPanel({
            labelWidth : 80,
            labelAlign : 'right',
            autoScroll : false,
            frame:true,
            tbar:[QueryBT,'-',CompleteBT,'-',CancelCompleteBT,'-',SaveAsBT],
        	items:[{
				xtype:'fieldset',
				title:'查询条件',
				style:DHCSTFormStyle.FrmPaddingV,
				defaults:{width:160},
				items : [PhaLoc,StartDate,EndDate,TkComplete,NullInputFlag]					
			}]
        
        });
        // 5.2.页面布局
        var mainPanel = new Ext.Viewport({
                    layout : 'border',
                    items :  [{
                                region:'west',  
                                width:350,
                                minSize:250,
                                maxSize:400,
                                //autoScroll:true,
                                split: true,
                                //collapsible: true, 
                                title:'盘点单-实盘数汇总',
                                layout:'border',
                                items:[{
                                            region:'north',
                                            height:DHCSTFormStyle.FrmHeight(6)-10,
                                            layout:'fit',                                           
                                            items:[formMain ]
                                       },{
                                            region:'center',
                                            layout:'fit',
                                            autoScroll:false,
                                            items:[MasterInfoGrid]
                                       }]
                                
                            },{
                                region:'center',
                                title:'盘点明细',
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
                                                title:'实盘批次明细',
                                                region:'east',
                                                width:500,
                                                split:true,
                                                minSize:50,
                                                maxSize:500,
                                                //collapsible: true,
                                                layout:'fit',
                                                items:[InstDetailGrid]
                                            },{
	                                         title:'账盘批次明细',
                                                region:'center',
                                                layout:'fit',
                                                items:[InstiGrid]
                                            }]
                                
                            }],                 
                    renderTo : 'mainPanel'
        });
    
        Query();
})