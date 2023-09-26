// 名称:低值品物资维护
// 编写日期:2014-06-20  

//=========================科室对照=============================
var gUserId = session['LOGON.USERID'];  
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

// 类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
    id : 'StkGrpType',
    name : 'StkGrpType',
    StkType:App_StkTypeCode,     //标识类组类型
    LocId:gLocId,
    UserId:gUserId,
    anchor:'90%'
});
// 物资inci
var Inci = new Ext.form.TextField({
    fieldLabel : 'Inci',
    id : 'Inci',
    name : 'Inci',
    anchor : '90%',
    valueNotFoundText : '',
    value:""
        });
// 物资名称
var InciDesc = new Ext.form.TextField({
    fieldLabel :'物资名称',
    id:'InciDesc',
    name:'InciDesc',
    anchor:'90%',
    listeners : {
    specialkey : function(field, e) {
    if (e.getKey() == Ext.EventObject.ENTER) {
        var stktype = Ext.getCmp("StkGrpType").getValue();
        //var stktype =296    //只显示低值耗材
        
        GetPhaOrderInfo2(field.getValue(), stktype);
                    }
                }
            }
        });
        
    /*var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel : '科室',
        id : 'PhaLoc',
        name : 'PhaLoc',
        anchor : '90%',
        valueNotFoundText : '',
        groupId:gGroupId
    });*/
    
 var PhaLoc=new Ext.ux.LocComboBox({
    id:'PhaLoc',
    anchor:'90%',
    fieldLabel:'科室名称',
    emptyText:'请选择...',
    defaultLoc:''
});
var PublicBiddingStore = new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['1', '库外试剂'], ['0', '库内试剂']]
    });
    var PublicBidding = new Ext.form.ComboBox({
        fieldLabel : '类型',
        id : 'PublicBidding',
        name : 'PublicBidding',
        anchor : '90%',
        store : PublicBiddingStore,
        valueField : 'RowId',
        displayField : 'Description',
        mode : 'local',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        listWidth : 150,
        forceSelection : true
    });    
    
//调用药品窗体并返回结果
function GetPhaOrderInfo2(item, group) {
                        
    if (item != null && item.length > 0) {
        GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
                        getDrugList2);
        }
}   
// 返回方法
function getDrugList2(record) {
    if (record == null || record == "") {
        return;
    }
    var inciDr = record.get("InciDr");
    var inciCode=record.get("InciCode");
    var inciDesc=record.get("InciDesc");
    Ext.getCmp("Inci").setValue(inciDr);
    Ext.getCmp("InciDesc").setValue(inciDesc);
}
function GetPhaOrderInfo(item, group) {
                        
            if (item != null && item.length > 0) {
                GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
                        getDrugList);
            }
        }

function getDrugList(record) {
    if (record == null || record == "") {
        return;
        }
    var cell = LVConfigGrid.getSelectionModel().getSelectedCell();
            // 选中行
    var row = cell[0];
    var rowData = LVConfigGrid.getStore().getAt(row);
    var inciDr = record.get("InciDr");
    var inciCode=record.get("InciCode");
    var inciDesc=record.get("InciDesc");
    var spec=record.get("Spec");
    
     rowData.set("RowId",inciDr);
     rowData.set("InciCode",inciCode);
     rowData.set("InciDesc",inciDesc);
     rowData.set("Spec",spec);
     var colindex=GetColIndex(LVConfigGrid,"LocDescId");
     LVConfigGrid.startEditing(cell[0],colindex);
}
var findLVConfig = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
        
        Query();
        
    }
});
function deleteDetail()
{
    var cell = ConfigGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
                Msg.info("error","请选择数据!");
               return false;}
         else{ 
               var record = ConfigGrid.getStore().getAt(cell[0]);
               var RowId = record.get("LvRowId");
            
                Ext.MessageBox.confirm('提示','确定要删除选定的行?',
                function(btn){
                       if(btn=="yes"){
                           
                           var url = "dhcstm.LVConfigaction.csp?actiontype=DeleteEj&lvrowid="+RowId;
                           var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
                           Ext.Ajax.request({
                              url:url,
                               waitMsg:'删除中...',
                                failure: function(result, request) {
                                    Msg.info("error","请检查网络连接!");
                                     mask.hide();
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                     if (jsonData.success=='true') {
                                        Msg.info("success","删除成功!");
                                        //Query()
                                        ConfigGridDs.reload();
                                      }
                                      else{
                                        Msg.info("error","删除失败!");
                                    }
                                },
                                scope: this
                               });
                               
                               }
                           
                           })
      
    
                 }
}
function updateOrder(){
    var ListDetail="";
    var rowCount = ConfigGrid.getStore().getCount();
    for (var i = 0; i < rowCount; i++) {
        var rowData = ConfigGridDs.getAt(i);
        //新增或数据发生变化时执行下述操作
        if(rowData.data.newRecord || rowData.dirty){
            
            var RowId=rowData.get("LvRowId"); 
            var InciId=rowData.get("LvInciId");
            
            var LocCode=rowData.get("LvLocDescId");  
            
            var LVNumber=rowData.get("LvLVNumber");
            var cat=rowData.get("PublicBidding")
            var LvMonthNumber=rowData.get("LvMonthNumber");
                
            if(InciId=="")
            {Msg.info("error","第"+(i+1)+"行数据不完整!");return}
         
            var str= RowId + "^"+ InciId+"^"+LocCode+"^"+LVNumber+"^"+cat+"^"+LvMonthNumber
            if(ListDetail==""){
                ListDetail=str;
            }else{
                ListDetail=ListDetail+RowDelim+str;
            }
        }
    }   
    
    if(ListDetail==""){
        Msg.info("error","没有修改或添加新数据!");
        return false;
    }else{
        //alert(ListDetail);
        var url ="dhcstm.lvconfigaction.csp?actiontype=updateEjLvConfig";
        var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
        Ext.Ajax.request({
            url : url,
            method : 'POST',
            params:{LvListDetail:ListDetail},
            waitMsg : '处理中...',
            success : function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                mask.hide();        
                if (jsonData.success == 'true') {
                    // 刷新界面
                    Msg.info("success", "保存成功!");
                    //Query()
                    ConfigGridDs.reload();
                }else{
                    var ret=jsonData.info;
                    Msg.info("error", "保存不成功："+ret);
                    
                }
            },
            scope : this
        });
    }
}
var SaveBT = new Ext.Toolbar.Button({
    id : "SaveBT",
    text : '保存',
    tooltip : '点击保存',
    width : 70,
    height : 30,
    iconCls : 'page_save',
    handler : function() {saveOrder();}
    });


 var LocDesc = new Ext.ux.LocComboBox({
    id:'LocDesc',
    anchor:'90%',
    fieldLabel:'科室名称',
    emptyText:'请选择...',
    defaultLoc:'',
     listeners : {
                specialkey : function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        //Ext.GetColIndex('LVNumber').focus(); 
                        var cell = LVConfigGrid.getSelectionModel().getSelectedCell();
                         var colIndex=GetColIndex(LVConfigGrid,'LVNumber');
                         LVConfigGrid.startEditing(cell[0], colIndex);
                    }
                }
            }
});

//模型 RowId InciId InciDesc Spec LocDescId  LVNumber
var nm = new Ext.grid.RowNumberer();
var LVConfigGridCm = new Ext.grid.ColumnModel([nm,{
        header : "RowId",
        dataIndex : 'RowId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        },
        {
        header : "物资代码",
        dataIndex : 'InciCode',
        width : 110,
        align : 'left',
        sortable : true
        },{
        header:"物资名称",
        dataIndex:'InciDesc',
        width:250,
        align:'left',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.TextField({
                                selectOnFocus : true,
                                allowBlank : false,
                                listeners : {
                                    specialkey : function(field, e) {
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                            var group = Ext.getCmp("StkGrpType").getValue();
                                            GetPhaOrderInfo(field.getValue(),group);
                                            
                                        }
                                    }
                                }
                            }))
      },{
        header : "规格",
        dataIndex : 'Spec',
        width : 100,
        align : 'left',
        sortable : true
        },{
        header : "科室名称",
        dataIndex : 'LocDescId',
        width : 110,
        align : 'left',
        sortable : true,
        editor : new Ext.grid.GridEditor(LocDesc),
        renderer :Ext.util.Format.comboRenderer2(LocDesc,"LocDescId","LocDesc") 
        },{
        header : "类型",
        dataIndex : 'PublicBidding',
        width : 110,
        align : 'left',
        sortable : true,
        editor : new Ext.grid.GridEditor(PublicBidding),
        renderer :Ext.util.Format.comboRenderer2

(PublicBidding,"PublicBidding","PublicBiddingDesc") 
        },{
        header:"次限制数量",
        dataIndex:'LVNumber',
        width:90,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({
                                //selectOnFocus : true
                                
                            }))
      },{
        header:"月限制数量",
        dataIndex:'LVMonthNumber',
        width:90,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({
                                //selectOnFocus : true
                                
                            }))
      }
]);
//初始化默认排序功能
LVConfigGridCm.defaultSortable = true;




// 访问路径
var DetailUrl ='dhcstm.lvconfigaction.csp?actiontype=find';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
            url : DetailUrl,
            method : "POST"
    });
        
// 指定列参数
        //RowId InciId  InciCode InciDesc Spec LocDescId  LVNumber
var fields = ["RowId", "InciCode","InciDesc","Spec", 

"LocDescId","LocDesc","LVNumber","LVMonthNumber"];
        
        
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
        root : 'rows',
        totalProperty : "results",
        id : "RowId",
        fields : fields
});
// 数据集
var LVConfigGridDs = new Ext.data.Store({
        proxy : proxy,
        reader : reader
});  
            
//保存供应项目明细
function saveOrder(){
    var ListDetail="";
    var rowCount = LVConfigGrid.getStore().getCount();
    for (var i = 0; i < rowCount; i++) {
        var rowData = LVConfigGridDs.getAt(i);
        //新增或数据发生变化时执行下述操作
        if(rowData.data.newRecord || rowData.dirty){
            
            //var RowId=rowData.get("RowId"); 
            var InciId=rowData.get("RowId");
            
            var LocCode=rowData.get("LocDescId");  
            
            var LVNumber=rowData.get("LVNumber");    
            var LVScat=rowData.get("PublicBidding");
            var LVMonthNumber=rowData.get("LVMonthNumber");
            if(InciId==""||LocCode=="")
            {Msg.info("error","第"+(i+1)+"行数据不完整!");return}
         
            var str= InciId+"^"+LocCode+"^"+LVNumber+"^"+LVScat+"^"+LVMonthNumber
            if(ListDetail==""){
                ListDetail=str;
            }else{
                ListDetail=ListDetail+RowDelim+str;
            }
        }
    }   
    
    if(ListDetail==""){
        Msg.info("error","没有修改或添加新数据!");
        return false;
    }else{
        
        var url ="dhcstm.lvconfigaction.csp?actiontype=saveEjlocqty";
        var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
        Ext.Ajax.request({
            url : url,
            method : 'POST',
            params:{ListData:ListDetail},
            waitMsg : '处理中...',
            success : function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                mask.hide();        
                if (jsonData.success == 'true') {
                    // 刷新界面
                    Msg.info("success", "保存成功!");
                    Query()
                }else{
                    var ret=jsonData.info;
                    Msg.info("error", "保存不成功："+ret);
                    
                }
            },
            scope : this
        });
    }
}
           
//查询函数
function Query()
{
   
    LVConfigGridDs.removeAll();
    ConfigGridDs.removeAll();
    var parm=setParam();
    if(parm==-1){
        return;
    }else{
        LVConfigGridDs.setBaseParam('Param',setParam())
        LVConfigGridDs.load({
        params:{start:0,limit:LVConfigPagingToolbar.pageSize}
    });  
    }
   
}
// 查询条件的拼接
function setParam(){
    var stc = Ext.getCmp("StkGrpType").getValue();
    if(stc==""){
        Msg.info("warning","请选择类组");
        return -1;
    }
    var inic = Ext.getCmp("Inci").getValue();
    var desc = Ext.getCmp("InciDesc").getRawValue();
    if(desc==""||desc==null){
        inic="";
        
    }
    var loc = Ext.getCmp("PhaLoc").getValue();
    //alert(stc+"^"+inic+"^"+loc)
    return stc+"^"+inic+"^"+loc+"^"+gUserId;
}

      
var formPanel = new Ext.form.FormPanel({
    region : 'north',
	//autoHeight : true,
	title : '科室限量维护',
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	tbar : [findLVConfig,'-',SaveBT],
	height:135,
    bodyStyle : 'padding:10px 0px 0px 0px;',
	//layout: 'fit',
	items : [{
			xtype : 'fieldset',
			title : '查询信息',
			layout : 'column',
			autoHeight:true,
			defaults : {border : false},
			items : [{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [StkGrpType]
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [InciDesc]
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [PhaLoc]
			}
		    ]
    }]
    
  });
//tbar:[findLVConfig,'-',SaveBT],
//分页工具栏
var LVConfigPagingToolbar = new Ext.PagingToolbar({
    store:LVConfigGridDs,
    pageSize:15,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
LVConfigGrid = new Ext.grid.EditorGridPanel({
    store:LVConfigGridDs,
    cm:LVConfigGridCm,
    title:'物资待维护明细',
    trackMouseOver:true,
    clicksToEdit:1,
    region:'west',
    width:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    listeners : {
        rowclick : function(grid,rowIndex,e){
            var inci = grid.store.getAt(rowIndex).get('RowId');
            var stc = Ext.getCmp("StkGrpType").getValue();
            var loc = Ext.getCmp("PhaLoc").getValue();
            var datalist=stc+"^"+inci+"^"+loc
            ConfigGridDs.removeAll(); 
            ConfigGridDs.setBaseParam('QueryParam',datalist)
            ConfigGridDs.load({params:{start:0,limit:ConfigPagingToolbar.pageSize}
    });
        }
    },
    bbar:LVConfigPagingToolbar
});
//==========================物资对照=============================

//=========================Lv====================================
//模型 RowId InciId InciDesc Spec LocDescId  LVNumber
var mm = new Ext.grid.RowNumberer();
var ConfigGridCm = new Ext.grid.ColumnModel([mm,{
        header : "LvRowId",
        dataIndex : 'LvRowId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        },{
        header : "LvInciId",
        dataIndex : 'LvInciId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        }, {
        header : "物资代码",
        dataIndex : 'LvInciCode',
        width : 150,
        align : 'left',
        sortable : true,
        hidden : true
        },{
        header:"物资名称",
        dataIndex:'LvInciDesc',
        width:250,
        align:'left',
        sortable:true,
        hidden : true
        
        },{
        header : "规格",
        dataIndex : 'LvSpec',
        width : 150,
        align : 'left',
        sortable : true,
        hidden : true
        },{
        header : "科室id",
        dataIndex : 'LvLocDescId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        
        },{
        header : "科室名称",
        dataIndex : 'LvLocDesc',
        width : 150,
        align : 'left',
        sortable : true
        
        },{
        header:"次限制数量",
        dataIndex:'LvLVNumber',
        width:100,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({}))
      },{
        header:"月限制数量",
        dataIndex:'LvMonthNumber',
        width:100,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({}))
      }
      ,{
        header : "类型",
        dataIndex : 'Stkcat',
        width : 150,
        align : 'left',
        renderer:function(v){
            if(v=="0"){
                return "库内试剂"
            }
            else if(v=="1"){
                return "库外试剂"
            }else{
                return ""
            }
        },
        sortable : true
        
        }
]);
//初始化默认排序功能
ConfigGridCm.defaultSortable = true;




// 访问路径
var LvDetailUrl ='dhcstm.lvconfigaction.csp?actiontype=queryEj';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
            url : LvDetailUrl,
            method : "POST"
    });
        
// 指定列参数
        //RowId InciId  InciCode InciDesc Spec LocDescId  LVNumber
var fields = ["LvRowId", "LvInciId", "LvInciCode","LvInciDesc","LvSpec", 

"LvLocDescId","LvLocDesc","LvLVNumber","Stkcat","LvMonthNumber"];
        
        
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
        root : 'rows',
        totalProperty : "results",
        fields : fields
});
// 数据集
var ConfigGridDs = new Ext.data.Store({
        proxy : proxy,
        reader : reader
});  
            

           

  


//分页工具栏
var ConfigPagingToolbar = new Ext.PagingToolbar({
    store:ConfigGridDs,
    pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
var DeleteBT = new Ext.Toolbar.Button({
        id : "DeleteBT",
        text : '删除',
        tooltip : '点击删除',
        width : 70,
        height : 30,
        iconCls : 'page_delete',
        handler : function() {
            //CancleComplete();
            deleteDetail();
        }
    });
var UpdateBT = new Ext.Toolbar.Button({
        id : "UpdateBT",
        text : '修改',
        tooltip : '点击修改',
        width : 70,
        height : 30,
        iconCls : 'page_gear',
        handler : function() {
            updateOrder();
        }
    }); 
ConfigGrid = new Ext.grid.EditorGridPanel({
    store:ConfigGridDs,
    cm:ConfigGridCm,
    title:'物资已维护明细',
    trackMouseOver:true,
    region:'center',
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    clicksToEdit:1,
    tbar:{items:[DeleteBT,'-',UpdateBT]},
    bbar:ConfigPagingToolbar
    
});

    
//===========模块主页面===========================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  
    var mainPanel = new Ext.Viewport({
        layout:'border',
        items:[formPanel,LVConfigGrid,ConfigGrid]
    });
});
    
//===========模块主页面===========================================