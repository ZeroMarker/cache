var targetSetUrl = 'dhc.pa.targetsetexe.csp';
var targetSetProxy = new Ext.data.HttpProxy({url: targetSetUrl+'?action=list'});

var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

KPIDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:targetSetUrl+'?action=kpi&str='+encodeURIComponent(Ext.getCmp('KPIField').getRawValue()),method:'POST'})
});

var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel:'指标',
	width:220,
	listWidth : 220,
	allowBlank: false,
	store: KPIDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择指标...',
	name: 'KPIField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var periodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
});

periodDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:targetSetUrl+'?action=period&start=0&str='+encodeURIComponent(Ext.getCmp('periodField').getRawValue())+'&limit='+targetSetPagingToolbar.pageSize,method:'POST'})
});
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '考核期间',
	width:210,
	listWidth : 210,
	allowBlank: false,
	store: periodDs,
	valueField: 'period',
	displayField: 'period',
	triggerAction: 'all',
	emptyText:'请选择考核期间...',
	name: 'periodField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeDataStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var pType = new Ext.form.ComboBox({
	id: 'pType',
	fieldLabel: '期间类型',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeDataStore,
	anchor: '90%',
	value:'', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});


pType.on("select",function(cmb,rec,id){
	//alert(Ext.getCmp('periodField').getRawValue());
	KPIDs.load({params:{start:0, limit:targetSetPagingToolbar.pageSize,str:KPIField.getRawValue()}})
});

KPIField.on("select",function(cmb,rec,id){
	//alert(Ext.getCmp('periodField').getRawValue());
	targetSetDs.load({params:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
});

var targetSetDs = new Ext.data.Store({
	proxy: targetSetProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','jxUnitDr','jxUnitName','tValue','jxUnitCode','bValue','baseValue'
 
		]),
    remoteSort: true
});

targetSetDs.setDefaultSort('rowid', 'DESC');



var targetSetCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '绩效单元代码',
			dataIndex: 'jxUnitCode',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: '绩效单元名称',
			dataIndex: 'jxUnitName',
			width:150,
			align: 'left',
			sortable: true

		},
		{
			header: '目标值',
			dataIndex: 'tValue',
			width: 150,
			align: 'right',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })
		},
		{
			header: '最佳值',
			dataIndex: 'bValue',
			width: 150,
			align: 'right',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })
		},
		{
			header: '基准值',
			dataIndex: 'baseValue',
			width: 150,
			align: 'right',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })
		}
	]);



	
var targetSetSearchField = 'Name';

var targetSetFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '绩效单元代码',value: 'jxUnitCode',checked: false,group: 'targetSetFilter',checkHandler: ontargetSetItemCheck }),
				new Ext.menu.CheckItem({ text: '绩效单元名称',value: 'jxUnitName',checked: true,group: 'targetSetFilter',checkHandler: ontargetSetItemCheck }),
				new Ext.menu.CheckItem({ text: '描述',value: 'tValue',checked: false,group: 'targetSetFilter',checkHandler: ontargetSetItemCheck })
		]}
});

function ontargetSetItemCheck(item, checked)
{
		if(checked) {
				targetSetSearchField = item.value;
				targetSetFilterItem.setText(item.text + ':');
		}
};

var targetSetSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
		listeners: {
			specialkey: {fn:function(field, e) {
			var key = e.getKey();
			if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				targetSetDs.proxy = new Ext.data.HttpProxy({url: targetSetUrl + '?action=list'});
				targetSetDs.load({targetSets:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				targetSetDs.proxy = new Ext.data.HttpProxy({
				url: targetSetUrl + '?action=list&searchField=' + targetSetSearchField + '&searchValue=' + this.getValue()});
				targetSetDs.load({targetSets:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
	    	}
		}
});
targetSetDs.each(function(record){
    alert(record.get('tieOff'));

});
var targetSetPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: targetSetDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',targetSetFilterItem,'-',targetSetSearchBox],
		doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodField').getRawValue();
		B['frequency']=Ext.getCmp('pType').getValue();
		B['KPIDr']=Ext.getCmp('KPIField').getValue()
		B['dir']="asc";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	   }
});

var targetSetMain = new Ext.grid.EditorGridPanel({//表格
		title: '目标值设置',
		store: targetSetDs,
		cm: targetSetCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,
		tbar:['期间:',periodField,'-','期间类型:',pType,'-','指标:',KPIField],
		bbar: targetSetPagingToolbar
});


////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=targetSetDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var tValue = mr[i].data["tValue"].trim();
				var bValue = mr[i].data["bValue"].trim();
				var baseValue = mr[i].data["baseValue"].trim();
                var KPIDr = KPIField.getValue().trim();
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: targetSetUrl+'?action=edit&tValue='+tValue+'&bValue='+bValue+'&baseValue='+baseValue+'&rowid='+myRowid+'&KPIDr='+KPIDr,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								//Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									this.store.commitChanges(); //还原数据修改提示
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='NourRowid') message='需要修改的rowid为空';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
targetSetMain.on("afteredit", afterEdit, targetSetMain);    
targetSetDs.load({params:{start:0, limit:targetSetPagingToolbar.pageSize,period:Ext.getCmp('periodField').getRawValue(),frequency:Ext.getCmp('pType').getValue(),KPIDr:KPIField.getValue()}});
