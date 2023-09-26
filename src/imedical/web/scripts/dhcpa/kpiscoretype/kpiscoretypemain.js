var KpiScoreTypeUrl = 'dhc.pa.kpiscoretypeexe.csp';
var KpiScoreTypeProxy = new Ext.data.HttpProxy({url:KpiScoreTypeUrl+'?action=list&active=Y'});
var userCode = session['LOGON.USERCODE'];

var KpiScoreTypeDs = new Ext.data.Store({
	proxy: KpiScoreTypeProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','KpiDr','KPIName','directScore','levelScore','active'
 
		]),
    remoteSort: true
});

KpiScoreTypeDs.setDefaultSort('rowid', 'DESC');


var addKpiScoreTypeButton = new Ext.Toolbar.Button({
		text: '初始化',
		tooltip: '初始化指标类型',
		iconCls: 'add',
		handler: function(){init();}
});

var editKpiScoreTypeButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的调查问卷指标',
		iconCls: 'remove',
		handler: function(){editKpiScoreTypeFun(KpiScoreTypeDs,KpiScoreTypeMain,KpiScoreTypePagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = KpiScoreTypeMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的调查问卷指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:KpiScoreTypeUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
								}else{
									var message="删除错误";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});
var KpiScoreTypeCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '指标名称',
			dataIndex: 'KPIName',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "直接分数",
			dataIndex: 'directScore',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: "等级分数",
			dataIndex: 'levelScore',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: "有效标志",
			dataIndex: 'active',
			width: 90,
			sortable: true,
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		}
	]);
	
var KpiScoreTypeSearchField = 'Name';

var KpiScoreTypeFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'KpiScoreTypeFilter',checkHandler: onKpiScoreTypeItemCheck })
		]}
});

function onKpiScoreTypeItemCheck(item, checked)
{
		if(checked) {
				KpiScoreTypeSearchField = item.value;
				KpiScoreTypeFilterItem.setText(item.text + ':');
		}
};

var KpiScoreTypeSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				KpiScoreTypeDs.proxy = new Ext.data.HttpProxy({url: KpiScoreTypeUrl + '?action=list'});
				KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KpiScoreTypeDs.proxy = new Ext.data.HttpProxy({
				url: KpiScoreTypeUrl + '?action=list&searchField=' + KpiScoreTypeSearchField + '&searchValue=' + this.getValue()});
				KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
	    	}
		}
});
KpiScoreTypeDs.each(function(record){
    alert(record.get('tieOff'));

});
var KpiScoreTypePagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: KpiScoreTypeDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',KpiScoreTypeFilterItem,'-',KpiScoreTypeSearchBox]
});

var KpiScoreTypeMain = new Ext.grid.EditorGridPanel({//表格
		title: '调查问卷指标维护',
		store: KpiScoreTypeDs,
		cm: KpiScoreTypeCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addKpiScoreTypeButton,'-',editKpiScoreTypeButton,'-',delButton],
		bbar: KpiScoreTypePagingToolbar
});

init = function(){
	Ext.MessageBox.confirm('提示','确实要初始化数据吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:KpiScoreTypeUrl+'?action=add',
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'数据初始化完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
						}else{
							if(jsonData.info=='ERROR'){
								Ext.Msg.show({title:'提示',msg:'多个当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='No'){
								Ext.Msg.show({title:'提示',msg:'没有当前战略!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
							if(jsonData.info=='false'){
								Ext.Msg.show({title:'提示',msg:'当前战略下指标类型初始化失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
						}
					},
					scope: this
				});
			}
		}
	)
}
KpiScoreTypeMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=KpiScoreTypeDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: KpiScoreTypeUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
KpiScoreTypeMain.on("afteredit", afterEdit, KpiScoreTypeMain);    
KpiScoreTypeDs.load({params:{start:0, limit:KpiScoreTypePagingToolbar.pageSize}});
