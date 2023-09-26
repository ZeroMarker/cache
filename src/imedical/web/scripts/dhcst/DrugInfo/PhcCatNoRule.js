// 名称:药学分理代码自动生成规则
// 编写日期:2014-08-18
//=========================定义全局变量=================================
var StkSysCounteId = "";
//=========================定义全局变量=================================
//=========================药学分理代码自动生成规则===========================
HospStore.load();
    var Hosp = new Ext.form.ComboBox({
	fieldLabel : '医院',
	id : 'Hosp',
	name : 'Hosp',
	anchor : '90%',
	width : 120,
	store : HospStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '医院...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				//addRow();	
			}
		}
	}
});

var LocFlag = new Ext.grid.CheckColumn({
	header:'科室',
	dataIndex:'Loc',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});





var StkSysCounteGrid="";
//配置数据源
var PhCatNoGridUrl = 'dhcst.phccatnoruleaction.csp';
var PhCatNoGridProxy= new Ext.data.HttpProxy({url:PhCatNoGridUrl+'?actiontype=GetNoRule',method:'GET'});
var PhCatNoGridDs = new Ext.data.Store({
	proxy:PhCatNoGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'NoLevel'},
		{name:'NoLength'},
		{name:'NoStart'},
		{name:'Hospital'}
	]),
    remoteSort:false
});

//模型
var PhCatNoGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"级别",
        dataIndex:'NoLevel',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.NumberField({
			id:'NoLevelField',
            allowBlank:false
        })
    },{
        header:"序号长度",
        dataIndex:'NoLength',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'lengthField',
            allowBlank:false
        })
    },{
        header:"开始数值",
        dataIndex:'NoStart',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'NoStartField'
        })
    },{
        header:"医院",
        dataIndex:'Hospital',
        width:200,
        align:'left',
        sortable:true,
        editor:new Ext.grid.GridEditor(Hosp),
		renderer:Ext.util.Format.comboRenderer(Hosp)
	 }
]);

//初始化默认排序功能
PhCatNoGridCm.defaultSortable = true;
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'NoLevel',
			type : 'string'
		}, {
			name : 'NoLength',
			type : 'string'
		}, {
			name : 'NoStart',
			type : 'string'
		}, {
			name : 'Hospital',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		Hospital:''
	});
					
	PhCatNoGridDs.add(NewRecord);
	PhCatNoGrid.startEditing(PhCatNoGridDs.getCount() - 1, 1);
   }

var saveCatNoRule = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//rowid^应用程序id^医院标志^科室标志^类组标志^单号前缀^年^月^日^序号长度
		//RowId^AppId^AppCode^AppDesc^Hosp^Loc^CatGrp^Prefix^Year^Month^Day^NoLength
		if(PhCatNoGrid.activeEditor != null){
			PhCatNoGrid.activeEditor.completeEdit();
		}
		//获取所有的新记录 
		var mr=PhCatNoGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var rowId = mr[i].data["RowId"];
			var NoLevel = mr[i].data["NoLevel"];
			var NoLength = (mr[i].data["NoLength"]);
			var NoStart = (mr[i].data["NoStart"]);
			var Hospital = (mr[i].data["Hospital"]);
			
			
			var dataRow = rowId+"^"+NoLevel+"^"+NoLength+"^"+NoStart+"^"+Hospital;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data==""){
			Msg.info("error","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: PhCatNoGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
						PhCatNoGridDs.load();
					}else{
						
							Msg.info("error","保存失败!");
						
					}
				},
				scope: this
			});
		}
    }
});
var NewBT = new Ext.Toolbar.Button({
			text : '新建',
			tooltip : '点击新建',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				    addNewRow();
				
			}
     })

//表格
PhCatNoGrid = new Ext.grid.EditorGridPanel({
	store:PhCatNoGridDs,
	cm:PhCatNoGridCm,
	trackMouseOver:true,
	height:665,
	stripeRows:true,
	//plugins:[HospFlag,LocFlag,CatGrpFlag,YearFlag,MonthFlag,DayFlag],
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[NewBT,'-',saveCatNoRule],
	clicksToEdit:1
});

PhCatNoGridDs.load();
//=========================单据号自动生成规则===========================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PhCatNoPanel = new Ext.Panel({
		title:'单号生成规则',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[PhCatNoGrid]                                 
	});
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[PhCatNoPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================