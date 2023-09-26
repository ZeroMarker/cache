var JXQMConditionUrl = 'dhc.qm.conditionexe.csp';
var JXQMConditionProxy = new Ext.data.HttpProxy({url: JXQMConditionUrl+'?action=list'});


var JXQMConditionDs = new Ext.data.Store({
	proxy: JXQMConditionProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'shortcut',
			'desc',
			'active'
 
		]),
    remoteSort: true
});

JXQMConditionDs.setDefaultSort('rowid', 'DESC');


var addJXQMConditionButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加质量管理条件',
		iconCls: 'add',
		handler: function(){addJXQMConditionFun(JXQMConditionDs,JXQMConditionMain,JXQMConditionPagingToolbar);}
});

var delJXQMConditionButton  = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除选定的条件',
		iconCls: 'remove',
		handler: function(){delFun(JXQMConditionDs, JXQMConditionMain, JXQMConditionPagingToolbar);}
});

var JXQMConditionCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '代码',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
               allowBlank: false
           })
		},
		{
			header: '名称',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
               allowBlank: false
           })

		},
		{
			header: '描述',
			dataIndex: 'desc',
			width: 100,
			align: 'left',
			sortable: true,
			renderer:isEdit,
			editor: new Ext.form.TextField({
           })

		}

	]);



	
var JXQMConditionSearchField = 'Name';

var JXQMConditionFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'JXQMConditionFilter',checkHandler: onJXQMConditionItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'JXQMConditionFilter',checkHandler: onJXQMConditionItemCheck }),
				new Ext.menu.CheckItem({ text: '描述',value: 'desc',checked: false,group: 'JXQMConditionFilter',checkHandler: onJXQMConditionItemCheck })
		]}
});

function onJXQMConditionItemCheck(item, checked)
{
		if(checked) {
				JXQMConditionSearchField = item.value;
				JXQMConditionFilterItem.setText(item.text + ':');
		}
};

var JXQMConditionSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				JXQMConditionDs.proxy = new Ext.data.HttpProxy({url: JXQMConditionUrl + '?action=list'});
				JXQMConditionDs.load({params:{start:0, limit:JXQMConditionPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				JXQMConditionDs.proxy = new Ext.data.HttpProxy({
				url: JXQMConditionUrl + '?action=list&searchField=' + JXQMConditionSearchField + '&searchValue=' + this.getValue()});
				JXQMConditionDs.load({params:{start:0, limit:JXQMConditionPagingToolbar.pageSize}});
	    	}
		}
});
JXQMConditionDs.each(function(record){
    alert(record.get('tieOff'));

});
var JXQMConditionPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: JXQMConditionDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',JXQMConditionFilterItem,'-',JXQMConditionSearchBox]
});

var JXQMConditionMain = new Ext.grid.EditorGridPanel({//表格
		title: '条件维护',
		store: JXQMConditionDs,
		cm: JXQMConditionCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addJXQMConditionButton,'-',delJXQMConditionButton,'-'],
		bbar: JXQMConditionPagingToolbar
});


JXQMConditionMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=JXQMConditionDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim()+"^"+mr[i].data["active"];
                var myRowid = mr[i].data["rowid"].trim();				
     }  
	 Ext.Ajax.request({
							url: JXQMConditionUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
JXQMConditionMain.on("afteredit", afterEdit, JXQMConditionMain);    
JXQMConditionDs.load({params:{start:0, limit:JXQMConditionPagingToolbar.pageSize}});
