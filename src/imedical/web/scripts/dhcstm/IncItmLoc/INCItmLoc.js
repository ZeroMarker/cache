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

    var NotUseFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : '包含不可用',
        id : 'NotUseFlag',
        name : 'NotUseFlag',
        anchor : '90%',
        checked : false
    });
    
    var StkBin = new Ext.form.ComboBox({
        fieldLabel : '货位',
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
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('StockType').setValue('');
    
    var LocManGrp=new Ext.form.ComboBox({
        fieldLabel : '管理组',
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
        fieldLabel : '管理组',
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
    
	var wareHouseCb = new Ext.ux.LocComboBox({
		id:'wareHouseCb',
		anchor:'90%',
		fieldLabel:'供应仓库',
		emptyText:'供应仓库...',
		defaultLoc:''
	});
	
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
        var StockType = Ext.getCmp("StockType").getValue();
        var IncludeNotUse=(Ext.getCmp("NotUseFlag").getValue()==true?1:0);
        var StkBinId=Ext.getCmp("StkBin").getValue();
        var LocManGrpId=Ext.getCmp("LocManGrp").getValue();
        gStrParam=phaLoc+"^"+gIncId+"^"+StkGrpRowId+"^"+IncludeNotUse+"^"+StkBinId+"^^"+StockType+"^"+LocManGrpId;
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
        Ext.getCmp("NotUseFlag").setValue(false);
        Ext.getCmp("StkBin").setValue('');
        Ext.getCmp("StockType").setValue('');
        Ext.getCmp("LocManGrp").setValue('');
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
			var Rowid = rowData.get("incil");
			var Incsc = rowData.get("incsb");
			var RepLev=rowData.get("repLev");
			var RepQty=rowData.get("repQty");
			var MaxQty=rowData.get("maxQty");
			var MinQty=rowData.get("minQty");
			var LockFlag=rowData.get("lockFlag");
			var SpStkBin=rowData.get("spStkBin");
			var EnforceStock='';
			var PivaFlag=rowData.get("pivaPack");
			var Lmg=rowData.get("inciLmg");
			var PlanFlag=rowData.get("planFlag");
			var wareHouse=rowData.get("wareHouse");
			var purBasQty=rowData.get("PurBasQty");
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
			var Rowid = mr[i].data["incil"].trim();
			var Incsc = mr[i].data["incsb"].trim();
			var RepLev = mr[i].data["repLev"];
			var RepQty = mr[i].data["repQty"];
			var MaxQty = mr[i].data["maxQty"];
			var EnforceStock='';
			var MinQty = mr[i].data["minQty"];
			var LockFlag = mr[i].data["lockFlag"];
			var SpStkBin = mr[i].data["spStkBin"];
			var PivaFlag = mr[i].data["pivaPack"];       
			var ManFlag = mr[i].data["manFlag"].trim();
			ManFlag=ManFlag=='Y'?1:0;	//按1,0保存	        
			var Lmg = mr[i].data["inciLmg"].trim();
			var PlanFlag = mr[i].data["planFlag"].trim();
			var wareHouse = mr[i].data["wareHouse"].trim();
			var ZeroStk = mr[i].data["ZeroStk"];
			var purBasQty=mr[i].data["PurBasQty"];
			var PurCircleDay=mr[i].data["PurCircleDay"];
			var CarryCycleDay=mr[i].data["CarryCycleDay"];
			
			var dataRow =Rowid + "^" + Incsc+"^"+RepLev+"^"+RepQty+"^"+MaxQty+"^"+MinQty+"^"+LockFlag
				+"^"+SpStkBin+"^"+EnforceStock+"^"+PivaFlag+"^"+ManFlag+"^"+Lmg+"^"+PlanFlag+"^"+wareHouse
				+"^"+ZeroStk+"^"+purBasQty+"^"+PurCircleDay+"^"+CarryCycleDay;
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
    var SendLocLimitBT = new Ext.Toolbar.Button({
			id : "SendLocLimitBT",
			text : '发送信息到平台',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
				   	var LocId=Ext.getCmp("PhaLoc").getValue();
					if (Ext.isEmpty(LocId)) {
						var ret=confirm("科室为空则是否同步所有科室库存上下限信息?");
						if (ret==true)
						{
							SendLocLimit(LocId);
						}
					}else{
						SendLocLimit(LocId);
					}
			}
	});
	function SendLocLimit(LocId){
		 var url = DictUrl+"incitmlocaction.csp?actiontype=SendLocLimit";
	        var loadMask=ShowLoadMask(Ext.getBody(),"发送信息中...");
	        Ext.Ajax.request({
	                    url : url,
	                    method : 'POST',
	                    params:{LocId:LocId},
	                    waitMsg : '处理中...',
	                    success : function(result, request) {
	                        var jsonData = Ext.util.JSON.decode(result.responseText);
	                        if (jsonData.success == 'true') {
	                            Msg.info("success", "发送成功!");
	                        } else {
	                            var ret=jsonData.info;
	                            Msg.info("error", jsonData.info);
	                        }
	                    },
	                    scope : this
	                });
	        loadMask.hide();
	}
    var GridStkBin = new Ext.ux.ComboBox({
        fieldLabel : '货位',
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
       header: '<font color=blue>加锁标志</font>',
       dataIndex: 'lockFlag',
       width: 80
    });
    
    var ChkPivaFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>配液打包标志</font>',
       dataIndex: 'pivaPack',
       width: 80
    });
    
    var ChkManFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>重点关注标志</font>',
        dataIndex:'manFlag',
        width:80
    });
    var ChkPlanFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>自动采购标志</font>',
        dataIndex:'planFlag',
        width:80
    })
    var ZeroStkFlag=new Ext.grid.CheckColumn({
        header:'<font color=blue>零库存标志</font>',
        dataIndex:'ZeroStk',
        width:80
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
			header : '代码',
			dataIndex : 'code',
			width : 140,
			align : 'left',
			sortable : true,
			hidden : false
		}, {
			header : "名称",
			dataIndex : 'desc',
			width : 200,
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
			width : 200,
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
			header : "<font color=blue>库存上限</font>",
			dataIndex : 'maxQty',
			width : 80,
			align : 'right',
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
			header:"<font color=blue>库存下限</font>",
			dataIndex:"minQty",
			width : 80,
			align : 'right',
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
			header:"库存",
			dataIndex:"stkQty",
			width : 80,
			align : 'right',
			sortable : true
		},{
			header:"可用库存",
			dataIndex:"avaQty",
			width : 80,
			align : 'right',
			sortable : true
		},{
			header:"<font color=blue>标准库存</font>",
			dataIndex:"repQty",
			width : 80,
			align : 'right',
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
			header:"<font color=blue>请求基数</font>",
			dataIndex:"repLev",
			width : 80,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true,
				listeners:{
					specialkey:function(field,e){
						var keycode=e.getKey();
						if(keycode==e.ENTER){
							var col=GetColIndex(ItmLocGrid,"PurBasQty");
							var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
							var row=cell[0];
							ItmLocGrid.startEditing(row,col);
						}
					}
				}
			})		
		},{
			header:"<font color=blue>采购基数</font>",
			dataIndex:"PurBasQty",
			width : 80,
			align : 'right',
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
			header:"<font color=blue>货位</font>",
			dataIndex:"incsb",
			width : 100,
			align : 'left',
			sortable : true,
			editor:GridStkBin,
			renderer:Ext.util.Format.comboRenderer2(GridStkBin,"incsb","sbDesc")
		},{
			header:"<font color=blue>备用货位</font>",
			dataIndex:"spStkBin",
			width : 100,
			align : 'left',
			sortable : true,
			editor:new Ext.form.TextField({
				listeners:{
					specialkey:function(field,e){
						var keycode=e.getKey();
						if(keycode==e.ENTER){
							var col=GetColIndex(ItmLocGrid,"inciLmg");
							var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
							var row=cell[0];
							ItmLocGrid.startEditing(row,col);
						}
					}
				}
			})
		},/*{
			header : "管制分类",
			dataIndex : 'phcpoCode',
			width : 100,
			align : 'left',
			sortable : true
		},*/
		ChkLockFlag,
		ChkManFlag,
		{ 
			header:'<font color=blue>管理组</font>',
			dataIndex:'inciLmg',
			editor:LocManGrpG,
			width : 100,
			renderer:Ext.util.Format.comboRenderer2(LocManGrp,"inciLmg","inciLmgDesc")		
		},{
			header : "<font color=blue>供应仓库</font>",
			dataIndex : 'wareHouse',
			width:150,
			align:'left',
			sortable:true,
			editor:new Ext.grid.GridEditor(wareHouseCb),
			renderer:Ext.util.Format.comboRenderer2(wareHouseCb,"wareHouse","wareHouseDesc")			
		},ZeroStkFlag,
		ChkPlanFlag,
		{
			header : "不可用",
			dataIndex : 'NotUseFlag',
			width : 60,
			align : 'center',
			renderer : function(v) {
				if (v == "Y")
					return "<div class='ux-lovcombo-icon-checked ux-lovcombo-icon' style='background-position:0 -13px;'>&nbsp;</div>";
				else
					return "<div class='ux-lovcombo-icon-unchecked ux-lovcombo-icon'>&nbsp;</div>"
			},
			sortable : true
		},{
			header:"采购周期",
			dataIndex:"PurCircleDay",
			width : 80,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true,
				listeners:{
					specialkey:function(field,e){
						var keycode=e.getKey();
						if(keycode==e.ENTER){
							var col=GetColIndex(ItmLocGrid,"CarryCycleDay");
							var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
							var row=cell[0];
							ItmLocGrid.startEditing(row,col);
						}
					}
				}
			})		
		},{
			header:"配送周期",
			dataIndex:"CarryCycleDay",
			width : 80,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true
			})		
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
    "sp","wareHouse","wareHouseDesc","ZeroStk","PurBasQty","CarryCycleDay","PurCircleDay"];
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
		title: '科室库存项---<font color=blue>蓝色显示的列为可编辑列</font>',
		id:'ItmLocGrid',
		cm : ItmLocCm,
		store : ItmLocStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.grid.CellSelectionModel({}),
		clicksToEdit : 1,
		bbar:StatuTabPagingToolbar,
		plugins: [ChkLockFlag,ChkPivaFlag,ChkManFlag,ChkPlanFlag,ZeroStkFlag],
		loadMask : true
	});

    var HisListTab = new Ext.ux.FormPanel({
        title:'科室库管信息维护',
        tbar : [SearchBT, '-',SaveBT,'-',RefreshBT,'-',SendLocLimitBT],            
        items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',
			style : 'padding:5px 0px 0px 5px',
			defaults:{border:false,xtype:'fieldset'},
			items:[{
					columnWidth:0.3,
					items:[PhaLoc,StkGrpType]
				},{
					columnWidth:0.3,
					items:[InciDesc,StockType]
				},{
					columnWidth:0.25,
					items:[StkBin,LocManGrp]
				},{
					columnWidth:0.15,
					items:[NotUseFlag]    
				}]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [  HisListTab,ItmLocGrid],
		renderTo : 'mainPanel'
	});   
})