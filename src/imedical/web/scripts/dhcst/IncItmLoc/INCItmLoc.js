// /名称: 科室库存项维护
// /描述: 科室库存项维护
// /编写者：zhangdongmei
// /编写日期: 2012.08.21
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gIncId='';
    var gGroupId=session['LOGON.GROUPID'];  
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];

    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel : $g('科室'),
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
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //标识类组类型
        UserId:gUserId,
        LocId:gLocId,
        anchor : '90%',
        fieldLabel : $g('类组')
    }); 
    
    var InciDesc = new Ext.form.TextField({
                fieldLabel : $g('药品名称'),
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
    }

    var NotUseFlag = new Ext.form.Checkbox({
        fieldLabel : $g('包含不可用'),
        id : 'NotUseFlag',
        name : 'NotUseFlag',
        //anchor : '90%',
        checked : false
    });
    
    //加锁标致下拉框
	var LockFlagStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [['ALL', $g('门诊/住院')], ['OUT', $g('门诊')], ['IN', $g('住院')]]
			});
	var LockFlagCon = new Ext.form.ComboBox({
				fieldLabel : $g('加锁标志'),
				id : 'LockFlagCon',
				name : 'LockFlagCon',
				anchor : '90%',
				store : LockFlagStore,
				triggerAction : 'all',
				mode : 'local',
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				valueNotFoundText : ''
			});
    
    
    var StkBin = new Ext.form.ComboBox({
        fieldLabel : $g('货位'),
        id : 'StkBin',
        name : 'StkBin',
        anchor : '90%',
        store : LocStkBinStore,
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 10,
        listWidth : 250,
        valueNotFoundText : '',
        listeners : {
            'beforequery' : function(e) {
            	LocStkBinStore.removeAll();
                var LocId=Ext.getCmp("PhaLoc").getValue();
                LocStkBinStore.setBaseParam('LocId',LocId);
                LocStkBinStore.setBaseParam('Desc',Ext.getCmp('StkBin').getRawValue());
                LocStkBinStore.load({params:{start:0,limit:10}});                   
            }
        }
    }); 
    
    var StockTypeStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['-1', $g('负库存')], ['0', $g('零库存')], ['1', $g('正库存')]]
    });
    var StockType=new Ext.form.ComboBox({
        fieldLabel : $g('库存类型'),
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
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('StockType').setValue('');
    
    var LocManGrp=new Ext.form.ComboBox({
        fieldLabel : $g('管理组'),
        id : 'LocManGrp',
        name : 'LocManGrp',
        anchor : '90%',
        store : LocManGrpStore,
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
        enableKeyEvents : true,
        listeners:{
            'beforequery':function(e){
                this.store.removeAll();
                var loc=Ext.getCmp("PhaLoc").getValue();
                LocManGrpStore.load({params:{locId:loc}});              
            }
        }
    });
    var LocManGrpG=new Ext.form.ComboBox({
        fieldLabel : $g('管理组'),
        id : 'LocManGrpG',
        name : 'LocManGrpG',
        anchor : '90%',
        store : LocManGrpStore,
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
        enableKeyEvents : true,
        listeners:{
            'beforequery':function(e){
                this.store.removeAll();
                var loc=Ext.getCmp("PhaLoc").getValue();
                LocManGrpStore.load({params:{locId:loc}});              
            }
        }
    });
    
    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
                text : $g('查询'),
                tooltip : $g('点击查询'),
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
            Msg.info("warning", $g("科室不能为空！"));
            Ext.getCmp("PhaLoc").focus();
            return;
        }
        if(Ext.getCmp("InciDesc").getValue()==""){
            gIncId="";
        }
		ItmLocStore.removeAll();
        var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
        var StockType = Ext.getCmp("StockType").getValue();
        var IncludeNotUse=(Ext.getCmp("NotUseFlag").getValue()==true?1:0);
        var LockFlagCon=Ext.getCmp("LockFlagCon").getValue();
        var StkBinId=Ext.getCmp("StkBin").getValue();
        var LocManGrpId=Ext.getCmp("LocManGrp").getValue();
        gStrParam=[phaLoc,gIncId,StkGrpRowId,IncludeNotUse,StkBinId,"",StockType,LocManGrpId,LockFlagCon].join("^");
        var PageSize=StatuTabPagingToolbar.pageSize;
        ItmLocStore.setBaseParam('Params',gStrParam);   //分页时基本参数不会丢失
        ItmLocStore.load({
	        params:{start:0,limit:PageSize},
			callback : function(o,response,success) { 
				if (success == false){  
					Ext.MessageBox.alert($g("查询错误"),ItmLocStore.reader.jsonData.Error);  
				}
			}});

    }
		// 另存按钮
	var SaveAsBT = new Ext.Toolbar.Button({
		text : $g('另存'),
		tooltip : $g('另存为Excel'),
		iconCls : 'page_excel',
		width : 70,
		height : 30,
		handler : function() {
			ExportAllToExcel(ItmLocGrid);
			//gridSaveAsExcel(StockQtyGrid);
		}
	});
    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
        text : $g('清空'),
        tooltip : $g('点击清空'),
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
        SetLogInDept(GetGroupDeptStore,'PhaLoc')
        Ext.getCmp("InciDesc").setValue('');
        Ext.getCmp("NotUseFlag").setValue(false);
        
        Ext.getCmp("StkBin").setValue('');
        Ext.getCmp("StockType").setValue('');
        Ext.getCmp("LocManGrp").setValue('');
        Ext.getCmp("LockFlagCon").setValue('');
        
        StkGrpType.getStore().setBaseParam("locId",gLocId);
		StkGrpType.getStore().setBaseParam("userId",gUserId);
		StkGrpType.getStore().setBaseParam("type",App_StkTypeCode);
		StkGrpType.getStore().load();
        //ItmLocGrid.store.removeAll();
        ItmLocGrid.getStore().removeAll();
        ItmLocGrid.store.load({params:{start:0,limit:0}});
        ItmLocGrid.getView().refresh();
    }
    
    // 保存按钮
    var SaveBT = new Ext.Toolbar.Button({
        id : "SaveBT",
        text : $g('保存'),
        tooltip : $g('点击保存'),
        width : 70,
        height : 30,
        iconCls : 'page_save',
        handler : function() {	
            // 保存科室库存管理信息                   
            save();                     
        }
    });
    
    function save(){    
    	var ListDetail="";
        var mr=ItmLocStore.getModifiedRecords();
        var data="";
        var rows="";
        for(var i=0;i<mr.length;i++){
            var Rowid = mr[i].data["incil"].trim();
            var Incsc = mr[i].data["incsb"].trim();
            var RepLev = mr[i].data["repLev"];
            var RepQty = mr[i].data["repQty"];
            var MaxQty = mr[i].data["maxQty"];
             var EnforceStock='';
            var MinQty = mr[i].data["minQty"];
            var LockFlag = mr[i].data["lockFlag"];
            var InLockFlag = mr[i].data["InLockFlag"];
            var SpStkBin = mr[i].data["spStkBin"];
            var PivaFlag = mr[i].data["pivaPack"];  //配液打包标志
            //var sd = mr[i].data["SdDesc"].trim();         
            var ManFlag = mr[i].data["manFlag"].trim();   
            ManFlag=ManFlag=='Y'?1:0;	//按1,0保存      
            //var mt = mr[i].data["MtDesc"].trim();         
            var Lmg = mr[i].data["inciLmg"].trim();
            var PlanFlag = mr[i].data["planFlag"].trim();
            var IfPivaFlag=mr[i].data["pivaflag"].trim();  //是否配液
            var DrugSendFlag=mr[i].data["drugsendflag"].trim();
            var DrugPackFlag=mr[i].data["drugpackflag"].trim();
           if((MaxQty != "") && (MinQty != "")&&(Number(MaxQty)<Number(MinQty))){Msg.info("warning",$g("库存上限不能小于下限!"));return;}

            var dataRow =Rowid + "^" + Incsc+"^"+RepLev+"^"+RepQty+"^"+MaxQty+"^"+MinQty+"^"+LockFlag
                +"^"+SpStkBin+"^"+EnforceStock+"^"+PivaFlag+"^"+ManFlag+"^"+Lmg+"^"+PlanFlag+"^"+IfPivaFlag
                +"^"+DrugSendFlag+"^"+DrugPackFlag+"^"+InLockFlag;
            //alert(dataRow);
            if(ListDetail==""){
                
                ListDetail = dataRow;
            }else{
                ListDetail = ListDetail+xRowDelim()+dataRow;
            }
        }
        var url = DictUrl
                + "incitmlocaction.csp?actiontype=Save";
        Ext.Ajax.request({
                    url : url,
                    params:{Detail:ListDetail},
                    method : 'POST',
                    waitMsg : $g('处理中...'),
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON
                                .decode(result.responseText);
                        if (jsonData.success == 'true') {
                             
                            Msg.info("success", $g("保存成功!"));
                            // 刷新界面
                            Query();

                        } else {
                            var ret=jsonData.info;
                            if(ret==-1){
                                Msg.info("error", $g("没有需要保存的数据!"));
                            }else {
                                Msg.info("error", $g("部分明细保存不成功：")+ret);
                            }
                            
                        }
                    },
                    scope : this
                });

    }
    
      // 生成上下限
    var CreatLimtBT = new Ext.Toolbar.Button({
                text : $g('生成上下限'),
                tooltip : $g('点击生成上下限'),
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
                    CreatLimtsConWin(Query);
                }
            });
    
    var GridStkBin = new Ext.ux.ComboBox({
        fieldLabel : $g('货位'),
        id : 'GridStkBin',
        name : 'GridStkBin',
        anchor : '90%',
        store : LocStkBinStore,
        valueField : 'RowId',
        displayField : 'Description',
		filterName : 'Desc',
		params : {LocId:'PhaLoc'}
    }); 
    
    var ChkLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>'+$g('门诊加锁')+'</font>',
       dataIndex: 'lockFlag',
       width: 80
    });
    
    var ChkInLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>'+$g('住院加锁')+'</font>',
       dataIndex: 'InLockFlag',
       width: 80
    });
    
    var ChkPivaFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>'+$g('配液打包标志')+'</font>',
       dataIndex: 'pivaPack',
       width: 80
    });
    
    var ChkManFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('管理药标志')+'</font>',
        dataIndex:'manFlag',
        width:80
    });
    var ChkPlanFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('自动采购标志')+'</font>',
        dataIndex:'planFlag',
        width:80
    })
    var PivaFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('是否配液标志')+'</font>',
        dataIndex:'pivaflag',
        width:80
    })
    var DrugSendFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('发药机标志')+'</font>',
        dataIndex:'drugsendflag',
        sortable : true,
        width:80
    })
    var DrugPackFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>'+$g('分包机标志')+'</font>',
        dataIndex:'drugpackflag',
        width:80,
        sortable : true
    })

    var nm = new Ext.grid.RowNumberer();
    var ItmLocCm = new Ext.grid.ColumnModel([nm, {
                header : "Rowid",
                dataIndex : 'incil',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : true
            }, {
                header : $g('代码'),
                dataIndex : 'code',
                width : 80,
                align : 'left',
                sortable : true,
                hidden : false
            }, {
                header : $g("名称"),
                dataIndex : 'desc',
                width : 200,
                align : 'left',
                sortable : true
            },{
                header : $g("规格"),
                dataIndex : 'spec',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : $g("生产企业"),
                dataIndex : 'manf',
                width : 200,
                align : 'left',
                sortable : true
            },{
                header : $g("基本单位"),
                dataIndex : 'bUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : $g("包装单位"),
                dataIndex : 'pUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "<font color=blue>"+$g("库存上限")+"</font>",
                dataIndex : 'maxQty',
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey: function(field, e){
                            var num=e.getKey();
                            
                            if(num == e.ENTER){                                 
                                var index=GetColIndex(ItmLocGrid,"minQty");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,index);
                            }
                        }
                    }
                })
                
            },{
                header:"<font color=blue>"+$g("库存下限")+"</font>",
                dataIndex:"minQty",
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey:function(field,e){
                            var keycode=e.getKey();
                            if(keycode==e.ENTER){
                                var index=GetColIndex(ItmLocGrid,"repQty");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,index);
                            }
                        }
                    }
                })
            
            },{
                header:$g("库存"),
                dataIndex:"stkQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:$g("可用库存"),
                dataIndex:"avaQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"<font color=blue>"+$g("标准库存")+"</font>",
                dataIndex:"repQty",
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey:function(field,e){
                            var keycode=e.getKey();
                            if(keycode==e.ENTER){
                                var col=GetColIndex(ItmLocGrid,"repLev");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,col);
                            }
                        }
                    }
                })
            
            },{
                header:"<font color=blue>"+$g("补货标准")+"</font>",
                dataIndex:"repLev",
                width : 80,
                align : 'left',
                sortable : true,
                editor:new Ext.form.NumberField({
                    selectOnFocus:true,
                    listeners:{
                        specialkey:function(field,e){
                            var keycode=e.getKey();
                            if(keycode==e.ENTER){
                                var col=GetColIndex(ItmLocGrid,"incsb");
                                var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
                                var row=cell[0];
                                ItmLocGrid.startEditing(row,col);
                            }
                        }
                    }
                })
            
            },{
				header:$g("货位"),
                dataIndex:"incsb",
                width : 150,
                align : 'left',
                sortable : true
            },{
                header:"<font color=blue>"+$g("备用货位")+"</font>",
                dataIndex:"spStkBin",
                width : 100,
                align : 'left',
                sortable : true,
                hidden:true,
                editor:new Ext.form.TextField({
                    
                })          
            },{
                header : $g("管制分类"),
                dataIndex : 'phcpoCode',
                width : 100,
                align : 'left',
                sortable : true
            },
            { 
                header:"<font color=blue>"+$g("管理组")+"</font>",
                dataIndex:'inciLmg',
                editor:LocManGrpG,
                width : 100,
                renderer:Ext.util.Format.comboRenderer2(LocManGrp,"inciLmg","inciLmgDesc")   
            },
            ChkLockFlag,
            ChkInLockFlag,
            ChkPivaFlag,
            ChkManFlag,
            PivaFlag,
            DrugSendFlag,
            DrugPackFlag,
            ChkPlanFlag,
            {
            header : $g("不可用"),
            dataIndex : 'NotUseFlag',
            width : 75,
            align : 'center',
            renderer : function(v,p,record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            },
			sortable : true
            },{
                header:$g("加锁更新人"),
                dataIndex:"lastUpdUser",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:$g("加锁更新日期"),
                dataIndex:"lastUpdDate",
                width : 100,
                align : 'left',
                sortable : true
            },{
                header:$g("加锁更新时间"),
                dataIndex:"lastUpdTime",
                width : 100,
                align : 'left',
                sortable : true
            }
			]);
    ItmLocCm.defaultSortable = true;

    // 访问路径
    var DspPhaUrl = DictUrl
                + 'incitmlocaction.csp?actiontype=Query&start=&limit=';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
                url : DspPhaUrl,
                method : "POST"
            });
    // 指定列参数
    var fields = ["incil", "inci", "code","desc","spec","manf","pUom","pUomDesc","bUom",
    "bUomDesc","maxQty","minQty","stkQty","avaQty","repQty","repLev","incsb","sbDesc","phcpoCode",
    "lockFlag","spStkBin","pivaPack","manFlag","inciLmg","inciLmgDesc","planFlag","NotUseFlag",
    "sp","pivaflag","drugsendflag","drugpackflag","lastUpdUser","lastUpdDate","lastUpdTime","InLockFlag"]; 
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "incil",
                fields : fields
            });
    // 数据集
    var ItmLocStore = new Ext.data.Store({
                proxy : proxy,
                pruneModifiedRecords : true,
                reader : reader,
                remoteSort:true
            });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store : ItmLocStore,
        pageSize : PageSize,
        displayInfo : true,
        displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg : "No results to display",
        prevText : $g("上一页"),
        nextText : $g("下一页"),
        refreshText : $g("刷新"),
        lastText :$g( "最后页"),
        firstText : $g("第一页"),
        beforePageText : $g("当前页"),
        afterPageText : $g("共{0}页"),
        emptyMsg :$g( "没有数据")
    });
    var ItmLocGrid = new Ext.grid.EditorGridPanel({
                id:'ItmLocGrid',
                region : 'center',
                cm : ItmLocCm,
                store : ItmLocStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                bbar:StatuTabPagingToolbar,
                plugins: [ChkLockFlag,ChkInLockFlag,ChkPivaFlag,ChkManFlag,ChkPlanFlag,PivaFlag,DrugSendFlag,DrugPackFlag],
                loadMask : true
            });




    var HisListTab = new Ext.form.FormPanel({
        title:$g('科室药品信息维护'),
        labelWidth : 80,
        height : DHCSTFormStyle.FrmHeight(3),
        labelAlign : 'right',
        region: 'north',
        frame : true,
        tbar : [SearchBT, '-',SaveBT,'-',CreatLimtBT,'-',SaveAsBT,'-',RefreshBT],            
        items : [{
            layout:'column',
            title:$g('查询条件'),
            xtype:'fieldset',
            style:DHCSTFormStyle.FrmPaddingV,
            defaults: {border:false}, 
            items:[{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 180},
                    items:[PhaLoc,StkGrpType,LockFlagCon]
                  },{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 180},
                    items:[InciDesc,StockType]
                  },{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 150},
                    items:[StkBin,LocManGrp]    
                  },{
                    columnWidth:0.25,
                    xtype:'fieldset',
                    defaults: {width: 150},
                    items:[NotUseFlag]    
                  }
                  
                  
                  ]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout : 'border',
        items : [  HisListTab,
            {
                 region: 'center',                                      
                 title: $g('科室库存项---<font color=blue>蓝色显示的列为可编辑列</font>'),
                 layout: 'fit', // specify layout manager for items
                 items: ItmLocGrid                             
            }
        ],
        renderTo : 'mainPanel'
    });
	})