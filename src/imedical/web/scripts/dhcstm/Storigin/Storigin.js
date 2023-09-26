// 名称: 产地维护
// 编写者: tsr
// 编写日期: 2016-09-20

var Url = 'dhcstm.storiginaction.csp';

var CodeField = new Ext.form.TextField({
    id:'CodeField',
    fieldLabel:'代码',
    allowBlank:true,
    listWidth:150,
    emptyText:'代码...',
    anchor:'90%',
    selectOnFocus:true
});

var DescField = new Ext.form.TextField({
    id:'DescField',
    fieldLabel:'名称',
    allowBlank:true,
    listWidth:150,
    emptyText:'名称...',
    anchor:'90%',
    selectOnFocus:true
});

var HospitalField = new Ext.ux.ComboBox({
	id:'HospitalField',
	fieldLabel : '医院',
	allowBlank:true,
	listWidth:150,
	emptyText:'医院……',
	anchor:'90%',
	selectOnFocus:true,
	store : HospStore,
	listWidth:220
});

var Hosp = new Ext.ux.ComboBox({
	fieldLabel : '医院',
	id : 'Hosp',
	store : HospStore,
	listWidth:298,
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addNewRow();
			}
		}
	}
});
	
var findBT = new Ext.Toolbar.Button({
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
		Query();
    }
});

var addBT = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveBT = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        Save();
    }
});

function addNewRow() {
    var record = Ext.data.Record.create([
        {
            name : 'RowId',
            type : 'int'
        }, {
            name : 'Code',
            type : 'string'
        }, {
            name : 'Desc',
            type : 'string'
        },{
	        name : 'HospDr',
	        type : 'string'
	    }
    ]);                 
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:'',
        HospDr:''
    });               
    StoriginGridDs.add(NewRecord);
    StoriginGrid.startEditing(StoriginGridDs.getCount() - 1, 2);
}
    
var StoriginGrid="";
var StoriginGridProxy= new Ext.data.HttpProxy({url:Url+'?actiontype=query',method:'POST'});
var StoriginGridDs = new Ext.data.Store({
    proxy:StoriginGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'RowId'},
        {name:'Code'},       
        {name:'Desc'},
        {name:'HospDr'},
		{name:'HospName'}
    ]),
	remoteSort:false,
    pruneModifiedRecords:true
});

var StoriginGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
	{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
        header:"代码",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'codeField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        StoriginGrid.startEditing(StoriginGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'descField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                       StoriginGrid.startEditing(StoriginGridDs.getCount() - 1, 4);
                    }
                }
            }
        })
        
    },{
        header:"医院",
        dataIndex:'HospDr',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.grid.GridEditor(Hosp),
		renderer:Ext.util.Format.comboRenderer2(Hosp,'HospDr','HospName')
	}   
]);

var StoriginPagingToolbar = new Ext.PagingToolbar({
    store:StoriginGridDs,
    pageSize:35,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
    doLoad:function(C){
        var B={},
        A=this.getParams();
        B[A.start]=C;
        B[A.limit]=this.pageSize;
        B[A.sort]='RowId';
        B[A.dir]='desc';
        B['CodeField']=Ext.getCmp('CodeField').getValue();
        B['DescField']=Ext.getCmp('DescField').getValue();
        B['Type']=App_StkTypeCode;
        B['HospitalField']=Ext.getCmp('HospitalField').getValue();;
        if(this.fireEvent("beforechange",this,B)!==false){
            this.store.load({params:B});
        }
    }
});

var formPanel = new Ext.form.FormPanel({
    labelwidth : 40,
    autoScroll:true,
    labelAlign : 'right',
    frame : true,
    autoScroll : true,
    bodyStyle : 'padding:5px;',
    tbar:[findBT,'-',addBT,'-',saveBT],
    items : [{
        autoHeight : true,
        items : [{
            xtype : 'fieldset',
            title : '查询条件',
            autoHeight : true,
            items : [{
                layout : 'column',
                items : [{
                    columnWidth : .33,
                    layout : 'form',
                    items : [CodeField]
                }, {
                    columnWidth : .33,
                    layout : 'form',
                    items : [DescField]
                },{
	                columnWidth : .33,
	                layout : 'form',
	                items : [HospitalField]
	                }
                ]
            }]
        }]
    }]
});

StoriginGrid = new Ext.grid.EditorGridPanel({
	id:'StoriginGrid',
	title:'产地信息',
	store:StoriginGridDs,
    cm:StoriginGridCm,
	trackMouseOver:true,
    region:'center',
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    bbar:StoriginPagingToolbar,
    clicksToEdit:1
});

function Save(){
	var mr=StoriginGridDs.getModifiedRecords();
	var data="";
	for(var i=0;i<mr.length;i++){
		var code = mr[i].data["Code"].trim();
		var desc = mr[i].data["Desc"].trim();
		var type = App_StkTypeCode;
		var HospDr = mr[i].data["HospDr"].trim();         
		if((code!="")&&(desc!="")){
			var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+HospDr;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
	}
	if(data==""){
		Msg.info("error", "没有修改或添加新数据!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: Url+'?actiontype=save',
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
					Query();
				}else{
					if(jsonData.info==-1){
						Msg.info("error", "代码重复!");
					}else if(jsonData.info==-2){
						Msg.info("error", "名称重复!");
					}else{
						 Msg.info("error", "保存失败!" +jsonData.info);
					}
					Query();
				}
			},
			scope: this
		});
	}
}

function Query(){
	var CodeField = Ext.getCmp('CodeField').getValue();
	var DescField = Ext.getCmp('DescField').getValue();
	var Type=App_StkTypeCode;
	var HospitalField = Ext.getCmp('HospitalField').getValue();
	StoriginGridDs.load({params:{start:0,limit:StoriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',CodeField:CodeField,DescField:DescField,Type:Type,HospitalField:HospitalField}});
}

//========================模块主页面===============================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
     var panel = new Ext.Panel({
        title:'产地维护',
        activeTab:0,
        region:'north',
        height:150,
        layout:'fit',
        items:[formPanel]                                 
    });
    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[panel,StoriginGrid],
        renderTo:'mainPanel'
    });
	
	Query();
});
	