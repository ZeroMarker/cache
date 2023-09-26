//科室对照
//2013-12-16
//taosongrui
var DescField = new Ext.form.TextField({
	id:'DescField',
	allowBlank:true
});

var DefLocList = new Ext.ux.LocComboBox({
	fieldLabel : '科室',
	id : 'DefLocList',
	name : 'DefLocList',
	anchor : '90%',
	width : 120,
	store : DeptLocStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	emptyText : '科室...',
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		beforeselect:function(combo,record,index){
			var locId=record.get(this.valueField);
			var url=DepartmentGridUrl+'?actiontype=select&description='+locId;
			var result=ExecuteDBSynAccess(url);
			var resultInfo=Ext.util.JSON.decode(result);
			if(resultInfo.success=="true"){
				this.setValue(locId);
				var col=GetColIndex(DepartmentGrid,'HISCode');
				DepartmentGrid.startEditing(DepartmentGridDs.getCount() - 1,col);
			}else{
				Msg.info("error","存在相同的科室!");
				var col=GetColIndex(DepartmentGrid,'LocId');
				DepartmentGrid.startEditing(DepartmentGridDs.getCount() - 1,col);
				return false;
			}
		}
	}
});

//配置数据源
var DepartmentGridUrl='dhcstm.departmentaction.csp';
var DepartmentGridProxy=new Ext.data.HttpProxy({url:DepartmentGridUrl+'?actiontype=query',method:'POST'});
var DepartmentGridDs = new Ext.data.Store({
	proxy:DepartmentGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	},[
		{name:'RowId'},
		{name:'LocId'},
		{name:'Desc'},
		{name:'HISCode'},
		{name:'HISDesc'}
	]),
	remoteSort:false,
	pruneModifiedRecords:true
})

var DepartmentGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
		header:"名称",
		dataIndex:'LocId',
		width:300,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(DefLocList,'LocId','Desc'),
		editor:new Ext.grid.GridEditor(DefLocList)
	},{
		header:"HIS科室代码",
		dataIndex:'HISCode',
		width:180,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DepartmentGrid.startEditing(DepartmentGridDs.getCount() - 1,3);
					}
				}
			}
		})
	},{
		header:"HIS科室名称",
		dataIndex:'HISDesc',
		width:300,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
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

var queryDepartment = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		DepartmentGridDs.setBaseParam('sort','Rowid');
		DepartmentGridDs.setBaseParam('dir','desc');
		DepartmentGridDs.setBaseParam('descfield',Ext.getCmp('DescField').getValue());
		DepartmentGridDs.removeAll();
		DepartmentGridDs.load({params:{start:0,limit:9999}});
	}
});

var addDepartment=new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width:70,
	height:30,
	handler:function(){
		var rowCount =DepartmentGrid.getStore().getCount();
		if(rowCount>0){
			var rowData = DepartmentGridDs.data.items[rowCount - 1];
			var data=rowData.get("Desc")
			if(data=="" || data.length<=0){
				Msg.info("warning","已存在新建行");
				DepartmentGrid.startEditing(DepartmentGridDs.getCount()-1,1)
				return;
			}
		}
		addNewRow()
	}
});

function addNewRow(){
	var NewRecord = CreateRecordInstance(DepartmentGridDs.fields);
	DepartmentGridDs.add(NewRecord);
	DepartmentGrid.startEditing(DepartmentGridDs.getCount()-1,1)
}

var saveDepartment=new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width:70,
	height:30,
	handler:function(){
		if(DepartmentGrid.activeEditor!=null){
			DepartmentGrid.activeEditor.completeEdit();
		}
		if(beforesave()==true){
			save();	
		}
	}
})
//保存科室对应关系
function save(){
	//获取所有的新记录 
	var mr=DepartmentGridDs.getModifiedRecords();
	var data="";
	for (i=0;i<mr.length;i++){
		var desc=mr[i].data["LocId"];
		var HIScode=mr[i].data["HISCode"].trim();
		var HISdesc=mr[i].data["HISDesc"].trim();
		if((desc!="")&&(HIScode!="")&&(HISdesc!="")){
			var dataRow=mr[i].data["RowId"]+"^"+desc+"^"+HIScode+"^"+HISdesc
			if(data==""){
				data=dataRow
			}
			else{
				data=data+xRowDelim()+dataRow   
			}	 
		}
	}		
	if(data==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:DepartmentGridUrl+'?actiontype=save',
			params:{data:data},
			failure:function(result,request){
				mask.hide();
				Msg.info("error","请检查网络连接!")
			},
			success:function(result,request){
				var jsonData=Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if(jsonData.success=='true'){
					Msg.info("success","保存成功!");
					queryDepartment.handler();
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error","存在相同科室!");
					}else if(ret==-2){
						Msg.info("error","存在相同His科室代码!");
					}else{
						Msg.info("error","保存失败:"+ret);
					}
				}
			},
			scope:this
		});
	}	
}
function beforesave(){
	var rowCount = DepartmentGrid.getStore().getCount();
	for (var i = 0; i < rowCount - 1; i++) {
		for (var j = i + 1; j < rowCount; j++) {
			var item_i = DepartmentGridDs.getAt(i).get("Desc");
			var item_j = DepartmentGridDs.getAt(j).get("Desc");
			if (item_i != "" && item_j != ""&& item_i == item_j) {
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning", "科室重复，请重新输入!");
				return false;
			}
		}
	}
	return true;
}
// 变换行颜色
function changeBgColor(row, color) {
	DepartmentGrid.getView().getRow(row).style.backgroundColor = color;
}

var deleteDepartment=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width:70,
	height:30,
	handler:function(){
		deleteDetail();
	}
})
//删除函数	
function deleteDetail(){
	var cell=DepartmentGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}else{
		var record=DepartmentGrid.getStore().getAt(cell[0]);
		var RowId=record.get("RowId");
		if (RowId!=""){
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
			function(btn){
				if(btn=="yes"){
					var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
					Ext.Ajax.request({
						url:DepartmentGridUrl+'?actiontype=delete&rowid='+RowId,
						waitMsg:'删除中...',
						failure: function(result, request) {
							mask.hide();
							Msg.info("error", "请检查网络连接!");
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							 mask.hide();
							if (jsonData.success=='true') {
								Msg.info("success", "删除成功!");
								DepartmentGridDs.reload();
							}else{
								Msg.info("error", "删除失败!");
							}
						},
						scope: this
					});
				}
			})
		}else{
			var rowInd=cell[0];
			if(rowInd>=0){
				DepartmentGrid.getStore().removeAt(rowInd);
			}
		}
	}
}
var MastPagingToolbar = new Ext.PagingToolbar({
	store:DepartmentGridDs,
	pageSize:30,
	displayInfo:true
});

var DepartmentGrid = new Ext.ux.EditorGridPanel({
	region:'center',
	title:'科室对照',
	store:DepartmentGridDs,
	cm:DepartmentGridCm,
	sm:new Ext.grid.CellSelectionModel({}),
	clicksToEdit:1,
	//bbar:MastPagingToolbar,
	tbar:['描述:',DescField,'-',queryDepartment,'-',addDepartment,'-',saveDepartment,'-',deleteDepartment],
	listeners:{
		beforeedit:function(e){
			if((e.field=='LocId')&&e.record.get('RowId')!=""){
				e.cancel=true;
			}
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[DepartmentGrid],
		renderTo:'mainPanel'
	});
	queryDepartment.handler();
})
