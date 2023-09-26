var SorceLevelUrl = 'dhc.pa.sorcelevelexe.csp';
var SorceLevelProxy = new Ext.data.HttpProxy({url:SorceLevelUrl+'?action=list&active=Y'});


var SorceLevelDs = new Ext.data.Store({
	proxy: SorceLevelProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'sorce',
			'code',
			'name',
			'shortcut',
			'py',
			'active'
 
		]),
    remoteSort: true
});

SorceLevelDs.setDefaultSort('rowid', 'DESC');


var addSorceLevelButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的等级表',
		iconCls: 'add',
		handler: function(){addSorceLevelFun(SorceLevelDs,SorceLevelMain,SorceLevelPagingToolbar);}
});

var editSorceLevelButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的等级',
		iconCls: 'remove',
		handler: function(){editSorceLevelFun(SorceLevelDs,SorceLevelMain,SorceLevelPagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = SorceLevelMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:SorceLevelUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
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
var SorceLevelCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '代码',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '名称',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: '快捷键',
			dataIndex: 'py',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '分数',
			dataIndex: 'sorce',
			width: 200,
			align: 'left',
			sortable: true
		},{
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
	
var SorceLevelSearchField = 'Name';

var SorceLevelFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'SorceLevelFilter',checkHandler: onSorceLevelItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: false,group: 'SorceLevelFilter',checkHandler: onSorceLevelItemCheck })
		]}
});

function onSorceLevelItemCheck(item, checked)
{
		if(checked) {
				SorceLevelSearchField = item.value;
				SorceLevelFilterItem.setText(item.text + ':');
		}
};

var SorceLevelSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				SorceLevelDs.proxy = new Ext.data.HttpProxy({url: SorceLevelUrl + '?action=list'});
				SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SorceLevelDs.proxy = new Ext.data.HttpProxy({
				url: SorceLevelUrl + '?action=list&searchField=' + SorceLevelSearchField + '&searchValue=' + this.getValue()});
				SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
	    	}
		}
});
SorceLevelDs.each(function(record){
    alert(record.get('tieOff'));

});
var SorceLevelPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: SorceLevelDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',SorceLevelFilterItem,'-',SorceLevelSearchBox]
});

var SorceLevelMain = new Ext.grid.EditorGridPanel({//表格
		title: '等级表设置',
		store: SorceLevelDs,
		cm: SorceLevelCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addSorceLevelButton,'-',editSorceLevelButton,'-',delButton],
		bbar: SorceLevelPagingToolbar
});


SorceLevelMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=SorceLevelDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: SorceLevelUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
SorceLevelMain.on("afteredit", afterEdit, SorceLevelMain);    
SorceLevelDs.load({params:{start:0, limit:SorceLevelPagingToolbar.pageSize}});
