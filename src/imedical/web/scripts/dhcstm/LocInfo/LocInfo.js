// 名称:科室扩展信息
// 编写日期:2012-05-23

//=========================科室扩展信息=============================
var conditionCodeField = new Ext.form.TextField({
    id:'conditionCode',
    fieldLabel:'代码',
    allowBlank:true,
    listWidth:180,
    emptyText:'代码...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionDescField = new Ext.form.TextField({
    id:'conditionDesc',
    fieldLabel:'名称',
    allowBlank:true,
    listWidth:150,
    emptyText:'名称...',
    anchor:'90%',
    selectOnFocus:true
});

var LocInfoTypeStore = new Ext.data.SimpleStore({
    fields:['key', 'keyValue'],
    data:[["R",'药库'], ["I",'住院药房'], ["O",'门诊药房'], ["A",'器械材料'], ["G",'总务药房'], ["E",'其他']]
});

var conditionTypeField = new Ext.form.ComboBox({
    id:'conditionTypeField',
    fieldLabel:'库房类别',
    anchor:'90%',
    listWidth:222,
    allowBlank:true,
    store:LocInfoTypeStore,
    value:'', // 默认值"全部查询"
    valueField:'key',
    displayField:'keyValue',
    emptyText:'科室类别...',
    triggerAction:'all',
    minChars:1,
    selectOnFocus:true,
    forceSelection:true,
    editable:true,
    mode:'local'
});

var conditionLocGField = new Ext.ux.ComboBox({
    id:'conditionLocG',
    fieldLabel:'科室组',
    anchor:'90%',
    listWidth:222,
    allowBlank:true,
    store:StkLocGrpStore,
    valueField:'RowId',
    displayField:'Description',
    emptyText:'科室组...',
    filterName:'str'
});

var conditionItemGField = new Ext.ux.ComboBox({
    id:'conditionItemG',
    anchor:'90%',
    fieldLabel:'项目组',
    listWidth:220,
    allowBlank:true,
    store:StkItemGrpStore,
    valueField:'RowId',
    displayField:'Description',
    emptyText:'项目组...',
    filterName:'str'
});

var conditionMainLocField=new Ext.ux.LocComboBox({
    id:'conditionMainLoc',
    anchor:'90%',
    fieldLabel:'支配科室',
    emptyText:'支配科室...',
	defaultLoc:''
});

//激活状态
var ActiveFlag = new Ext.form.RadioGroup({
			id:'active',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'全部',name:'ActiveFlag',id:'ActiveFlag_All',inputValue:'A',checked:true},
				{boxLabel:'激活',name:'ActiveFlag',id:'ActiveFlag_Yes',inputValue:'Y'},
				{boxLabel:'未激活',name:'ActiveFlag',id:'ActiveFlag_No',inputValue:'N'}
			]
		});
/*
var stateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [["A",'全部'], ["N",'未激活'], ["Y",'激活']]
	});
var activeField = new Ext.form.ComboBox({
		id: 'active',
		fieldLabel: '激活状态',
		allowBlank: true,
		store: stateStore,
		value: 'A', // 默认值"激活"
		valueField:'key',
		displayField:'keyValue',
		triggerAction:'all',
		anchor: '50%',
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		mode: 'local'
	});

var ReqAllItmField = new Ext.form.Checkbox({
	id : 'ReqAllItm',
	anchor:'90%',
	hideLabel : true,
	boxLabel : '申请科室外项目',
	allowBlank:false,
	checked:false
	});
*/
//允许项目外标识
var ReqAllItmFlag = new Ext.form.RadioGroup({
			id:'ReqAllItm',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'全部',name:'ReqAllItmFlag',id:'ReqAllItmFlag_All',inputValue:'',checked:true},
				{boxLabel:'允许申请科室外项目',name:'ReqAllItmFlag',id:'ReqAllItmFlag_Yes',inputValue:'Y'},
				{boxLabel:'不允许申请科室外项目',name:'ReqAllItmFlag',id:'ReqAllItmFlag_No',inputValue:'N'}
			]
		});

var LocInfoTypeField = new Ext.form.ComboBox({
    id:'LocInfoType',
    fieldLabel:'库房类别',
    anchor:'90%',
    listWidth:210,
    allowBlank:true,
    store:LocInfoTypeStore,
    value:'', // 默认值"全部查询"
    valueField:'key',
    displayField:'keyValue',
    emptyText:'科室类别...',
    triggerAction:'all',
    emptyText:'',
    minChars:1,
    selectOnFocus:true,
    forceSelection:true,
    editable:true,
    mode:'local'
});

var SlgG = new Ext.ux.ComboBox({
    id:'SlgG',
    fieldLabel:'科室组',
    anchor:'90%',
    listWidth:220,
    allowBlank:true,
    store:StkLocGrpStore,
    valueField:'RowId',
    displayField:'Description',
    emptyText:'科室组...',
    filterName:'str'
});

var LigG = new Ext.ux.ComboBox({
    fieldLabel : '项目组',
    id : 'LigG',
    name : 'LigG',
    anchor : '90%',
    width : 120,
    store : StkItemGrpStore,
    valueField : 'RowId',
    displayField : 'Description',
    emptyText : '项目组...'
});

var MainLocCb = new Ext.ux.LocComboBox({
    id:'MainLoc',
    anchor:'90%',
    fieldLabel:'支配科室',
    emptyText:'支配科室...',
	defaultLoc:''
});

var PrintModeStore = new Ext.data.SimpleStore({
	fields:['RowId', 'Description'],
	data : [['MM', 'MM'], ['MO', 'MO'], ['MR', 'MR'], ['MF', 'MF']]
});
var PrintModeField = new Ext.form.ComboBox({
    fieldLabel : '打印模式',
    store : PrintModeStore,
    valueField : 'RowId',
    displayField : 'Description',
    emptyText : '打印模式...',
    triggerAction : 'all',
    selectOnFocus : true,
    forceSelection : true,
    mode : 'local'
});
//自动月报标志
var AutoMonFlag= new Ext.form.RadioGroup({
			id:'AutoMonFlag',
			columns:3,
			anchor : '90%',
			width : 300,
			items:[
				{boxLabel:'全部',name:'AutoMonFlag',id:'AutoMonFlag_All',inputValue:'',checked:true},
				{boxLabel:'自动生成月报',name:'AutoMonFlag',id:'AutoMonFlag_Yes',inputValue:'Y'},
				{boxLabel:'非自动生成月报',name:'AutoMonFlag',id:'AutoMonFlag_No',inputValue:'N'}
			]
		});
/*
var AutoMonFlagField = new Ext.form.Checkbox({
    id: 'AutoMonFlag',
    anchor:'90%',
	hideLabel : true,
	boxLabel : '自动月报标志',
    allowBlank:false,
    checked:false
});
*/
var LocInfoGrid="";
//配置数据源
var LocInfoGridUrl = 'dhcstm.locinfoaction.csp';
var LocInfoGridProxy= new Ext.data.HttpProxy({url:LocInfoGridUrl+'?actiontype=query',method:'POST'});
var LocInfoGridDs = new Ext.data.Store({
    proxy:LocInfoGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results'
    }, [
        {name:'Rowid'},
        {name:'Code'},
        {name:'Desc'},
        {name:'LigId'},
        {name:'LigDesc'},
        {name:'SlgId'},
        {name:'SlgDesc'},
        {name:'Type'},
        {name:'MainLoc'},
        {name:'MainLocDesc'},
        {name:'Active'},
        {name:'ReqAllItm'},
        {name:'ReportSeq'},
		{name:'AutoMonFlag'},
		{name:'ReqLimitAmt'},
		{name:'ReqAmt'},
	'PrintMode'
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
});

var ActiveF = new Ext.grid.CheckColumn({
    header:'激活标识',
    dataIndex:'Active',
    anchor:'90%',
    sortable:true
});

var ReqAllItmF = new Ext.grid.CheckColumn({
	header:'允许项目外标识',
	dataIndex: 'ReqAllItm',
	anchor : '90%',
	sortable:true,
	width : 120
	});
var AutoMonF = new Ext.grid.CheckColumn({
    header:'自动月报标志',
    dataIndex:'AutoMonFlag',
    anchor:'90%',
    sortable:true
});

//模型
var sm=new Ext.grid.CheckboxSelectionModel({});
var LocInfoGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),sm,
     {
        header:"代码",
        dataIndex:'Code',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true
    },{
        header:"科室组",
        dataIndex:'SlgId',
        width:150,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(SlgG),
        renderer : Ext.util.Format.comboRenderer2(SlgG,"SlgId","SlgDesc")
    },{
        header:"项目组",
        dataIndex:'LigId',
        width:150,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(LigG),
        renderer : Ext.util.Format.comboRenderer2(LigG,"LigId","LigDesc")
    },{
        header:"库房类别",
        dataIndex:'Type',
        width:150,
        align:'left',
        sortable:true,
        renderer: Ext.util.Format.comboRenderer(LocInfoTypeField),
        editor: new Ext.grid.GridEditor(LocInfoTypeField)
    },{
    	header:"支配科室",
        dataIndex:'MainLoc',
        width:150,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(MainLocCb),
        renderer:Ext.util.Format.comboRenderer2(MainLocCb,"MainLoc","MainLocDesc")
    },
    ActiveF,ReqAllItmF,
    {
        header:"科室顺序",
        dataIndex:'ReportSeq',
        width:80,
        align:'left',
        sortable:true,
        editor : new Ext.grid.GridEditor(new Ext.form.TextField({}))
    },{
		header : '打印模式',
		dataIndex : 'PrintMode',
		width : 100,
		align : 'left',
		editor : new Ext.grid.GridEditor(PrintModeField),
		renderer : Ext.util.Format.comboRenderer(PrintModeField)
	},AutoMonF,{
		header:"请求限额",
        dataIndex:'ReqLimitAmt',
        width:100,
        align:'right',
        editor: new Ext.grid.GridEditor(new Ext.form.NumberField({}))
	},{
		header:"已请求额",
        dataIndex:'ReqAmt',
        width:100,
        align:'right'
	}
]);
//初始化默认排序功能
LocInfoGridCm.defaultSortable = true;

var clearLocInfo = new Ext.Toolbar.Button({
    text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
    width : 70,
    height : 30,
    handler:function(){
        Ext.getCmp('conditionCode').setValue("");
        Ext.getCmp('conditionDesc').setValue("");
        Ext.getCmp('conditionTypeField').setValue("");
        Ext.getCmp('conditionLocG').setValue("");
        Ext.getCmp('conditionLocG').setRawValue("");
        Ext.getCmp('conditionItemG').setValue("");
        Ext.getCmp('conditionItemG').setRawValue("");
        Ext.getCmp('conditionMainLoc').setValue("");
        Ext.getCmp('ActiveFlag_All').setValue(true);
        Ext.getCmp('ReqAllItmFlag_All').setValue(true);
		Ext.getCmp('AutoMonFlag_All').setValue(true);
        LocInfoGrid.getStore().removeAll();
        LocInfoGrid.getView().refresh();
    }
});

var findLocInfo = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
    	var code=Ext.getCmp('conditionCode').getValue();
    	var desc=Ext.getCmp('conditionDesc').getValue();
    	var LocG=Ext.getCmp('conditionLocG').getValue();
    	var ItemG=Ext.getCmp('conditionItemG').getValue();
    	var type=Ext.getCmp('conditionTypeField').getValue();
    	var mainLoc=Ext.getCmp('conditionMainLoc').getValue();
    	var activeFlag=Ext.getCmp('active').getValue().getGroupValue();
    	//var ReqAllItmFlag=Ext.getCmp('ReqAllItm').getValue()==true?'Y':'N';
    	var ReqAllItmFlag=Ext.getCmp('ReqAllItm').getValue().getGroupValue();
		//var AutoMonFlag=Ext.getCmp('AutoMonFlag').getValue()==true?'Y':'N';
		var AutoMonFlag=Ext.getCmp('AutoMonFlag').getValue().getGroupValue();
    	var filterStr=code+"^"+desc+"^"+LocG+"^"+ItemG+"^"+type+"^"+activeFlag+"^"+mainLoc+"^"+ReqAllItmFlag+"^"+AutoMonFlag;
    	LocInfoGridDs.setBaseParam("sort",'Rowid');
    	LocInfoGridDs.setBaseParam("dir",'desc');
    	LocInfoGridDs.setBaseParam("filterStr",filterStr);
        LocInfoGridDs.load({params:{start:0,limit:LocInfoPagingToolbar.pageSize}});
    }
});

var setFrLocButton=new Ext.Toolbar.Button({
	text:'设置补货科室',
	width:70,
	height:30,
	iconCls : 'page_gear',
	handler:function()
	{
		var sm=LocInfoGrid.getSelectionModel();		
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning","请选择科室！");
			return;
		}
		var loc=rec.get('Rowid');
		if (loc=='') return;
		var locDesc=rec.get('Desc');
		setTransferFrLoc(loc,locDesc);		
	}
});
var setLocClaGrpButton=new Ext.Toolbar.Button({
	text:'设置科室项目分组',
	width:70,
	height:30,
	iconCls:'page_gear',
	handler:function()
	{
		var sm=LocInfoGrid.getSelectionModel();
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning","请选择科室！")
			return;
		}
		var loc=rec.get('Rowid');
		if(loc==''){ 
			Msg.info("warning","请选择科室！")
			return;
		   }
		var locDesc=rec.get('Desc');
		setLocClaGrp(loc,locDesc);
	}
});
var setFrLocButton1=new Ext.Toolbar.Button({
	text:'设置供应仓库(分类)',
	width:70,
	height:30,
	iconCls : 'page_gear',
	handler:function()
	{
		var sm=LocInfoGrid.getSelectionModel();		
		var rec=sm.getSelected();
		if(rec==null){
			Msg.info("warning","请选择科室！")
			return;
		}
		var loc=rec.get('Rowid');
		if (loc=='') return;
		var locDesc=rec.get('Desc');
		setTransStkCatferFrLoc(loc,locDesc);		
	}
});
var saveLocInfo = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
		if(LocInfoGrid.activeEditor != null){
			LocInfoGrid.activeEditor.completeEdit();
		} 
        //获取所有的新记录 
        var mr=LocInfoGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var LlgId = mr[i].data["LigId"];
            var SlgId = mr[i].data["SlgId"];
            var PrintMode = mr[i].data['PrintMode'];
            var dataRow = mr[i].data["Rowid"]+"^"+LlgId+"^"+SlgId+"^"+mr[i].data["Type"]+"^"+mr[i].data["Active"]
            	+"^"+mr[i].data['MainLoc']+"^"+mr[i].data['ReqAllItm']+"^"+mr[i].data['ReportSeq']+"^"+PrintMode
				+"^"+mr[i].data["AutoMonFlag"]+"^"+mr[i].data['ReqLimitAmt'];
            if(data==""){
                data = dataRow;
            }else{
                data = data+xRowDelim()+dataRow;
            }
        }
        if(data==""){
            Msg.info("error", "没有修改或添加新数据!");
            return false;
        }else{
            var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
            Ext.Ajax.request({
                url: LocInfoGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                	 mask.hide();
                    Msg.info("error", "请检查网络连接!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success", "保存成功!");
                        LocInfoGridDs.commitChanges();
						LocInfoGridDs.reload();
                    }else{
                        Msg.info("error", "保存失败!" +jsonData.info);
                    }
                },
                scope: this
            });
        }
    }
});
var SendLocInfoBT = new Ext.Toolbar.Button({
			id : "SendLocInfoBT",
			text : '发送科室信息到平台',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
				    var rowDataArr=LocInfoGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(rowDataArr)) {
						Msg.info("warning", "请选择需要发送的科室信息!");
						return;
					}
					var LocIdStr="";
					for (var i=0;i<rowDataArr.length;i++){
						var rowData=rowDataArr[i];
						var LocRowId = rowData.get("Rowid");
						if (LocIdStr==""){
							LocIdStr=LocRowId;
						}else{
							LocIdStr=LocIdStr+"^"+LocRowId;
						}
					}
					if (Ext.isEmpty(LocIdStr)) {
						Msg.info("warning", "请选择需要发送的科室信息!");
						return;
					}
					SendLocInfo(LocIdStr);
			}
});
function SendLocInfo(LocIdStr){
	 	var url = LocInfoGridUrl+"?actiontype=SendLocInfo";
        var loadMask=ShowLoadMask(Ext.getBody(),"发送信息中...");
        Ext.Ajax.request({
                    url : url,
                    method : 'POST',
                    params:{LocIdStr:LocIdStr},
                    waitMsg : '处理中...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success", "发送成功!");
                            findLocInfo.handler();
                        } else {
                            var ret=jsonData.info;
                            Msg.info("error", jsonData.info);
                            findLocInfo.handler();
                        }
                    },
                    scope : this
                });
        loadMask.hide();
}
var formPanel = new Ext.ux.FormPanel({
    title:'科室扩展信息',
    tbar:[findLocInfo,'-',saveLocInfo,'-',clearLocInfo,'-',setFrLocButton,'-',setFrLocButton1,'-',setLocClaGrpButton,'-',SendLocInfoBT],
    items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .28,
				items : [conditionCodeField,conditionLocGField,conditionMainLocField]
			}, {
				columnWidth : .28,
				items : [conditionDescField,conditionItemGField,conditionTypeField]
			}, {
				columnWidth : .42,
				items : [ActiveFlag,ReqAllItmFlag,AutoMonFlag]
		}]
    }]
});

//分页工具栏
var LocInfoPagingToolbar = new Ext.PagingToolbar({
    store:LocInfoGridDs,
    pageSize:PageSize,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
LocInfoGrid = new Ext.grid.EditorGridPanel({
	id:'LocInfoGrid',
    store:LocInfoGridDs,
    cm:LocInfoGridCm,
    trackMouseOver:true,
    region:'center',
    stripeRows:true,
    sm: sm,
    plugins: [ActiveF,ReqAllItmF,AutoMonF],    
    loadMask:true,
    bbar:LocInfoPagingToolbar,
    clicksToEdit:2
});

//=========================科室扩展信息=============================

//===========模块主页面=============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,LocInfoGrid]
    });
});
//===========模块主页面=============================================