var userCode = session['LOGON.USERCODE'];


var KPIAuditUrl = 'dhc.pa.kpiauditexe.csp';
var KPIAuditProxy = new Ext.data.HttpProxy({url: KPIAuditUrl+'?action=list'});
var KPIIndexUrl = 'dhcc.pa.kpiindexexe.csp';
var KPIIndexProxy = new Ext.data.HttpProxy({url: KPIAuditUrl+'?action=kpi&start=0&parent=0&limit=25'});
var KPIAuditDs = new Ext.data.Store({
	proxy: KPIAuditProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','KPIDr','KPIName','UserDr','UserName'
 
		]),
    remoteSort: true
});


//alert(KPIAuditDs.getAt(2));

KPIAuditDs.setDefaultSort('rowid', 'DESC');


var KPIIndexDs = new Ext.data.Store({
	proxy:KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
KPIIndexDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:KPIAuditUrl+'?action=kpi&start=0&parent=0&limit=25'});
});

var KPIAuditCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: 'KPI指标',
			dataIndex: 'KPIName',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '用户名',
			dataIndex: 'UserName',
			width: 150,
			align: 'left',
			sortable: true
		}
	]);
	
var KPIAuditSearchField = 'name';

var KPIAuditFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '用户名',value: 'UserDr',checked: false,group: 'KPIAuditFilter',checkHandler: onKPIAuditItemCheck }),
			new Ext.menu.CheckItem({ text: 'KPI指标',value: 'KPIDr',checked: false,group: 'KPIAuditFilter',checkHandler: onKPIAuditItemCheck })
		]}
});

function onKPIAuditItemCheck(item, checked)
{
		if(checked) {
				KPIAuditSearchField = item.value;
				KPIAuditFilterItem.setText(item.text + ':');
		}
}

var KPIAuditSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 100,
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
				KPIAuditDs.proxy = new Ext.data.HttpProxy({url: KPIAuditUrl + '?action=list'});
				KPIAuditDs.load({params:{start:0, limit:KPIAuditPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KPIAuditDs.proxy = new Ext.data.HttpProxy({
				url: KPIAuditUrl + '?action=list&searchField=' + KPIAuditSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				KPIAuditDs.load({params:{start:0, limit:KPIAuditPagingToolbar.pageSize}});
	    	}
		}
});
KPIAuditDs.each(function(record){
    alert(record.get('tieOff'));

});
var KPIAuditPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: KPIAuditDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',KPIAuditFilterItem,'-',KPIAuditSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的方案',
		iconCls: 'add',
		handler: function(){addSchemFun(KPIAuditDs,KPIAuditMain,KPIAuditPagingToolbar);
		}
});
var editAdjustButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改新的方案',
		iconCls: 'add',
		handler: function(){editSchemFun(KPIAuditDs,KPIAuditMain,KPIAuditPagingToolbar);
		}
});
var delAdjustButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除选择的方案',
		iconCls: 'remove',
		handler: function(){delSchemFun(KPIAuditDs,KPIAuditMain,KPIAuditPagingToolbar);
		}
});

var KPIAuditMain = new Ext.grid.EditorGridPanel({//表格
		title: '用户KPI权限设置',
		store: KPIAuditDs,
		cm: KPIAuditCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		width:550,
		//clicksToEdit: 2,
		stripeRows: true, 
        tbar:[addAdjustButton,editAdjustButton,delAdjustButton],		
		bbar: KPIAuditPagingToolbar
});


KPIAuditMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
function isEdit(value,record){   
    //向后台提交请求   
   return value;   
  }  
function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=KPIAuditDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = Ext.getCmp('editcom').getValue()+"^"+userCode;
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: KPIAuditUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
									if(jsonData.info=='RepKPI') message='输入的KPI已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
KPIAuditMain.on("afteredit", afterEdit, KPIAuditMain);  
KPIAuditDs.load({params:{start:0, limit:KPIAuditPagingToolbar.pageSize}});
