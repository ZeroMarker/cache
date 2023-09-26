// 名称:单据号自动生成规则
// 编写日期:2012-06-6
//=========================定义全局变量=================================
var StkSysCounteId = "";
//=========================定义全局变量=================================
//=========================单据号自动生成规则===========================
var HospFlag = new Ext.grid.CheckColumn({
	header:'医院',
	dataIndex:'Hosp',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
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

var CatGrpFlag = new Ext.grid.CheckColumn({
	header:'类组',
	dataIndex:'CatGrp',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var YearFlag = new Ext.grid.CheckColumn({
	header:'年',
	sortable:true,
	dataIndex:'Year',
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var MonthFlag = new Ext.grid.CheckColumn({
	header:'月',
	dataIndex:'Month',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});

var DayFlag = new Ext.grid.CheckColumn({
	header:'日',
	dataIndex:'Day',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});


var CountByLocFlag = new Ext.grid.CheckColumn({
	header:'按科室',
	dataIndex:'CountByLoc',
	sortable:true,
	width:80,
	renderer:function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(((v=="Y")||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
});


var StkSysCounteGrid="";
//配置数据源
var StkSysCounteGridUrl = 'dhcstm.stksyscounteaction.csp';
var StkSysCounteGridProxy= new Ext.data.HttpProxy({url:StkSysCounteGridUrl+'?actiontype=selectAll&StkType='+App_StkTypeCode,method:'GET'});
var StkSysCounteGridDs = new Ext.data.Store({
	proxy:StkSysCounteGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'AppId'},
		{name:'AppCode'},
		{name:'AppDesc'},
		{name:'Hosp'},
		{name:'Loc'},
		{name:'CatGrp'},
		{name:'Prefix'},
		{name:'Year'},
		{name:'Month'},
		{name:'Day'},
		{name:'NoLength'},
		{name:'CountByLoc'}
		
	]),
    remoteSort:false
});

//模型
var StkSysCounteGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'AppCode',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'AppDesc',
        width:200,
        align:'left',
        sortable:true
    },HospFlag,LocFlag,CatGrpFlag,{
        header:"前缀",
        dataIndex:'Prefix',
        width:80,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'prefixField'
        })
    },YearFlag,MonthFlag,DayFlag,{
        header:"序号长度",
        dataIndex:'NoLength',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'lengthField',
            allowBlank:false
        })
    },CountByLocFlag
]);

//初始化默认排序功能
StkSysCounteGridCm.defaultSortable = true;

var saveStkSysCounte = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//rowid^应用程序id^医院标志^科室标志^类组标志^单号前缀^年^月^日^序号长度
		//RowId^AppId^AppCode^AppDesc^Hosp^Loc^CatGrp^Prefix^Year^Month^Day^NoLength
		if(StkSysCounteGrid.activeEditor != null){
			StkSysCounteGrid.activeEditor.completeEdit();
		}
		//获取所有的新记录 
		var mr=StkSysCounteGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var rowId = mr[i].data["RowId"];
			var appId = mr[i].data["AppId"];
			var hosp = (mr[i].data["Hosp"]=="Y"?'Y':'N');
			var loc = (mr[i].data["Loc"]=="Y"?'Y':'N');
			var catGrp = (mr[i].data["CatGrp"]=="Y"?'Y':'N');
			var prefix = mr[i].data["Prefix"].trim();
			var year = (mr[i].data["Year"]=="Y"?'Y':'N');
			var month = (mr[i].data["Month"]=="Y"?'Y':'N');
			var day = (mr[i].data["Day"]=="Y"?'Y':'N');
			var length = mr[i].data["NoLength"];
			var CountByLoc =mr[i].data["CountByLoc"];
			
			var dataRow = rowId+"^"+appId+"^"+hosp+"^"+loc+"^"+catGrp+"^"+prefix+"^"+year+"^"+month+"^"+day+"^"+length+"^"+CountByLoc;
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
				url: StkSysCounteGridUrl+'?actiontype=save',
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
						StkSysCounteGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("error","名称重复!");
						}else{
							Msg.info("error","保存失败!");
						}
					}
				},
				scope: this
			});
		}
    }
});

var synAppBtn = new Ext.Toolbar.Button({
	text:'同步应用',
	tooltip:'同步应用',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synRet = tkMakeServerCall("web.DHCSTM.Tools.CreateApp","App");
		Msg.info('success', '同步成功!');
		StkSysCounteGridDs.reload();
	}
});

//表格
StkSysCounteGrid = new Ext.grid.EditorGridPanel({
	store:StkSysCounteGridDs,
	cm:StkSysCounteGridCm,
	trackMouseOver:true,
	stripeRows:true,
	plugins:[HospFlag,LocFlag,CatGrpFlag,YearFlag,MonthFlag,DayFlag,CountByLocFlag],
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[synAppBtn, '-', saveStkSysCounte],
	clicksToEdit:1
});

StkSysCounteGridDs.load();
//=========================单据号自动生成规则===========================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkSysCountePanel = new Ext.Panel({
		title:'单号生成规则',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[StkSysCounteGrid]                                 
	});
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[StkSysCountePanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================