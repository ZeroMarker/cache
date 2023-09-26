var ParamUrl = 'dhc.pa.adjustexe.csp';
var ParamProxy = new Ext.data.HttpProxy({url: ParamUrl+'?action=list'});
var StratagemTabUrl = '../csp/dhc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '考核周期',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择考核周期...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
cycleField.on("select",function(cmb,rec,id ){
    stratagemDs.proxy=new Ext.data.HttpProxy({url:'dhc.pa.schemlistexe.csp?action=stratagem&cycle='+Ext.getCmp('cycleField').getValue()});
	stratagemDs.load({params:{start:0, limit:stratagemField.pageSize}});
});

var stratagemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

stratagemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:ParamUrl+'?action=stratagem&cycle='+Ext.getCmp('cycleField').getValue()})
});

var stratagemField = new Ext.form.ComboBox({
	id: 'stratagemField',
	fieldLabel: '战略',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: stratagemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择战略...',
	name: 'stratagemField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
stratagemField.on("select",function(cmb,rec,id ){
    sunfind(cmb.getValue());    
});

function sunfind(str){
	ParamDs.proxy=new Ext.data.HttpProxy({url:ParamUrl+'?action=list&stratagem='+str});
	ParamDs.load({params:{start:0, limit:stratagemField.pageSize}});
};
var ParamDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'parId',
			'parRef',
			{name:'date',type:'date',dateFormat:'Y-m-d'},
			'yearName',
			'user',
			'userId',
			'info',
 
		]),
    remoteSort: true
});

ParamDs.setDefaultSort('rowid', 'DESC');



var ParamCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '年份',
			dataIndex: 'yearName',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '战略目标',
			dataIndex: 'parRef',
			width: 100,
			align: 'left',
			sortable: true			
		},
		{
			header: '调整人',
			dataIndex: 'user',
			width:100,
			align: 'left',
			sortable: true
		},
		{
			header: "调整日期",
			dataIndex: 'date',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: '调整说明',
			dataIndex: 'info',
			width: 250,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextArea({
           })
		}
	]);
	
var ParamSearchField = 'name';

var ParamFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '描述',value: 'info',checked: false,group: 'ParamFilter',checkHandler: onParamItemCheck })
		]}
});

function onParamItemCheck(item, checked)
{
		if(checked) {
				ParamSearchField = item.value;
				ParamFilterItem.setText(item.text + ':');
		}
};

var ParamSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				ParamDs.proxy = new Ext.data.HttpProxy({url: ParamUrl + '?action=list'});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				ParamDs.proxy = new Ext.data.HttpProxy({
				url: ParamUrl + '?action=list&searchField=' + ParamSearchField + '&searchValue=' + this.getValue()});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
	    	}
		}
});
ParamDs.each(function(record){
    alert(record.get('tieOff'));

});
var ParamPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: ParamDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',ParamFilterItem,'-',ParamSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的方案调整',
		iconCls: 'add',
		handler: function(){addAdjustFun(ParamDs,ParamMain,ParamPagingToolbar);
		}
});

var ParamMain = new Ext.grid.EditorGridPanel({//表格
		title: '战略调整设置',
		store: ParamDs,
		cm: ParamCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true, 
        tbar:['年度:',cycleField,'-','战略:',stratagemField,'-',addAdjustButton],		
		bbar: ParamPagingToolbar
});


ParamMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});

////
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=ParamDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = Ext.getCmp('stratagemField').getValue().trim()+"^"+userCode+"^"+mr[i].data["info"].trim();
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: ParamUrl+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									this.store.commitChanges(); //还原数据修改提示
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
ParamMain.on("afteredit", afterEdit, ParamMain);    
ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
