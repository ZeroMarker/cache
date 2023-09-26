/**
 *  名称:	 批准文号前缀维护
 *  编写人:  yunhaibao
 *  编写日期:2018-01-18
*/

function addNewRow() {
	var record = Ext.data.Record.create([{
			name : 'Desc',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		Desc:''
	});
					
	ItmRemarkGridDs.add(NewRecord);
	ItmRemarkGrid.startEditing(ItmRemarkGridDs.getCount() - 1, 1);
}
	
var ItmRemarkGrid="";
//配置数据源
var ItmRemarkUrl = 'dhcst.itmremark.action.csp';
var ItmRemarkGridProxy= new Ext.data.HttpProxy({url:ItmRemarkUrl+'?actiontype=Query',method:'POST'});
var ItmRemarkGridDs = new Ext.data.Store({
	proxy:ItmRemarkGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'Desc'}
	]),
    remoteSort:false
});

//模型
var ItmRemarkGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"名称",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    }
]);

//初始化默认排序功能
ItmRemarkGridCm.defaultSortable = true;
var addItmRemark = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmRemark = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:Save
});

function Save(){
	//获取所有的新记录 
	var records=ItmRemarkGridDs.getCount();
	var dataArr=[];
	for(var i=0;i<records;i++){
		var desc = ItmRemarkGridDs.getAt(i).get("Desc").trim();
		if(desc!=""){
			if (dataArr.indexOf(desc)<0){
				dataArr.push(desc);
			}
		}
	}
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
	Ext.Ajax.request({
		url: ItmRemarkUrl+'?actiontype=Save',
		params:{listData:dataArr.join("^")},
		failure: function(result, request) {
			mask.hide();
			Msg.info("error", "请检查网络连接!");
			ItmRemarkGridDs.commitChanges();
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			 mask.hide();
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
			}else{
			}
			ItmRemarkGridDs.commitChanges();
			ItmRemarkGridDs.load();
		},
		scope: this
	});
}

var deleteItmRemark = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmRemarkGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", "请选择数据!");
			return false;
		}else{
			var record = ItmRemarkGrid.getStore().getAt(cell[0]);
			ItmRemarkGridDs.remove(record);
			Save();
		}
    }
});

//表格
ItmRemarkGrid = new Ext.grid.EditorGridPanel({
	store:ItmRemarkGridDs,
	cm:ItmRemarkGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmRemark,'-',saveItmRemark,'-',deleteItmRemark],
	clicksToEdit:1,
	height:770
});

ItmRemarkGridDs.load();

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'批准文号前缀维护',
		region:'center',
		items:[ItmRemarkGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});