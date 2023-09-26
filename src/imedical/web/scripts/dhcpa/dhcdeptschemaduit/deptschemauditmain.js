var userCode = session['LOGON.USERCODE'];
var DeptAuditUrl = 'dhc.pa.deptschemauditexe.csp';
var DeptAuditProxy = new Ext.data.HttpProxy({url: DeptAuditUrl+'?action=list'});
var DeptIndexProxy = new Ext.data.HttpProxy({url: DeptAuditUrl+'?action=name&start=0&parent=0&limit=25'});
var DeptAuditDs = new Ext.data.Store({
	proxy: DeptAuditProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'DSArowid','ssusr_name','dsc_name'
 
		]),
    remoteSort: true
});




DeptAuditDs.setDefaultSort('DSArowid', 'DESC');




var DeptAuditCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		
		{
			header: '用户名称',
			dataIndex: 'ssusr_name',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '自查名称',
			dataIndex: 'dsc_name',
			width: 150,
			align: 'left',
			sortable: true
		}
	]);
	
var DeptAuditSearchField = 'name';

var DeptAuditFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '自查名称',value: 'DSA_userDr',checked: false,group: 'DeptAuditFilter',checkHandler: onDeptAuditItemCheck }),
			new Ext.menu.CheckItem({ text: '用户名称',value: 'SSUSR_RowId',checked: false,group: 'DeptAuditFilter',checkHandler: onDeptAuditItemCheck })
		]}
});
function onDeptAuditItemCheck(item, checked)
{
		if(checked) {
				DeptAuditSearchField = item.value;
				DeptAuditFilterItem.setText(item.text + ':');
		}
}

var DeptAuditSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				DeptAuditDs.proxy = new Ext.data.HttpProxy({url:DeptAuditUrl + '?action=list'});
				DeptAuditDs.load({params:{start:0, limit:DeptAuditPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				DeptAuditDs.proxy = new Ext.data.HttpProxy({
				url: DeptAuditUrl + '?action=list&searchField=' + DeptAuditSearchField + '&searchValue=' + encodeURIComponent(this.getValue())});
				DeptAuditDs.load({params:{start:0, limit:DeptAuditPagingToolbar.pageSize}});
	    	}
		}
});
DeptAuditDs.each(function(record){
    alert(record.get('tieOff'));

});
var DeptAuditPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: DeptAuditDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',DeptAuditFilterItem,'-',DeptAuditSearchBox]
});

var addAdjustButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的方案',
		iconCls: 'add',
		handler: function(){addSchemFun(DeptAuditDs,DeptAuditMain,DeptAuditPagingToolbar);
		}
});
var editAdjustButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改新的方案',
		iconCls: 'add',
		handler: function(){editSchemFun(DeptAuditDs,DeptAuditMain,DeptAuditPagingToolbar);
		}
});
var delAdjustButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除选择的方案',
		iconCls: 'remove',
		handler: function(){delSchemFun(DeptAuditDs,DeptAuditMain,DeptAuditPagingToolbar);
		}
});

var DeptAuditMain = new Ext.grid.EditorGridPanel({//表格
		title: '自查权限设置',
		store: DeptAuditDs,
		cm: DeptAuditCm,
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
		bbar: DeptAuditPagingToolbar
});


DeptAuditMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=DeptAuditDs.getModifiedRecords();//获取所有更新过的记录 
		   
               //var data = Ext.getCmp('editcom').getValue()+"^"+userCode;
               var Dept = Ext.getCmp('editcom').getValue();
				var userDr = userCode;
				
	 Ext.Ajax.request({
							url: DeptAuditUrl+'?action=edit&DschemDr='+Dept+'&DuserDr='+userDr+'&rowid='+myRowid,
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
									if(jsonData.info=='') message='输入的数据为空!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
DeptAuditMain.on("afteredit", afterEdit, DeptAuditMain);  
DeptAuditDs.load({params:{start:0, limit:DeptAuditPagingToolbar.pageSize}});
