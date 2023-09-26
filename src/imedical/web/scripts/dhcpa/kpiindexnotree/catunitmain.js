var KPIIndexUrl = 'dhc.pa.kpiindexnotreeexe.csp';
var KPIIndexProxy = new Ext.data.HttpProxy({url: KPIIndexUrl+'?action=list',method:'POST'});


var KPIIndexDs = new Ext.data.Store({
	proxy: KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'id','code','name','py','shortcut','dimTypeDr','dimTypeName','target','desc','calUnitDr','calUnitName','extreMum','extreMumName','expression','expName',
			'expName2','expDesc','colTypeDr','colTypeName','scoreMethodCode','scoreMethodName','colDeptDr','colDeptName','dataSource','isHospKPI','isDeptKPI','isMedKPI',
			'isNurKPI','isPostKPI','parent','parentName','level','isStop','isEnd','order','isKPI'
 
		]),
    remoteSort: true
});

//KPIIndexDs.setDefaultSort('id', 'DESC');


var addKPIIndexButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的计量单位',
		iconCls: 'add',
		handler: function(){addKPIIndexFun(KPIIndexDs,KPIIndexMain,KPIIndexPagingToolbar);}
});

var editKPIIndexButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的年度',
		iconCls: 'remove',
		handler: function(){editKPIIndexFun(KPIIndexDs,KPIIndexMain,KPIIndexPagingToolbar);}
});
var KPIIndexCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
    	header:'指标名称',
    	align: 'left',
    	width:200,
    	dataIndex:'name'
	},{
    	header:'指标代码',
    	width:60,
    	dataIndex:'code'
	},{
    	header:'所属维度',
    	align: 'left',
    	width:60,
    	dataIndex:'dimTypeName'
	},{
    	header:'评测目标',
    	align: 'left',
    	width:60,
    	dataIndex:'target'
	},{
    	header:'计量单位',
    	align: 'right',
    	width:60,
    	dataIndex:'calUnitName'
	},{
    	header:'极值',
    	align: 'right',
    	width:40,
    	dataIndex:'extreMumName'
	},{
    	header:'收集方式',
    	align: 'right',
    	width:60,
    	dataIndex:'colTypeName'
	},{
    	header:'评分方法',
    	align: 'right',
    	width:60,
    	dataIndex:'scoreMethodName'
	},{
    	header:'收集部门',
    	align: 'right',
    	width:60,
    	dataIndex:'colDeptName'
	},{
    	header:'上级指标',
    	align: 'right',
    	width:60,
    	dataIndex:'parentName'
	},{
    	header:'末级标志',
    	align: 'right',
    	width:60,
    	dataIndex:'isEnd',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'顺序',
    	align: 'right',
    	width:40,
    	dataIndex:'order'
	},{
    	header:'指标级别',
    	align:'right',
    	width:55,
    	dataIndex:'level'
	},{
    	header:'是否停用',
    	align: 'right',
    	width:55,
    	dataIndex:'isStop',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'KPI 标志',
    	align: 'right',
    	width:50,
    	dataIndex:'isKPI',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	},{
    	header:'指标描述',
    	align: 'center',
    	width:145,
    	dataIndex:'desc'
	}
	]);
	
var KPIIndexSearchField = 'name';

var KPIIndexFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'KPIIndexFilter',checkHandler: onKPIIndexItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'KPIIndexFilter',checkHandler: onKPIIndexItemCheck }),
				new Ext.menu.CheckItem({ text: '描述',value: 'desc',checked: false,group: 'KPIIndexFilter',checkHandler: onKPIIndexItemCheck })
		]}
});

function onKPIIndexItemCheck(item, checked)
{
		if(checked) {
				KPIIndexSearchField = item.value;
				KPIIndexFilterItem.setText(item.text + ':');
		}
};

var KPIIndexSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				KPIIndexDs.proxy = new Ext.data.HttpProxy({url: KPIIndexUrl + '?action=list',method:'POST'});
				KPIIndexDs.load({params:{start:0, limit:KPIIndexPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				KPIIndexDs.proxy = new Ext.data.HttpProxy({
				url: KPIIndexUrl + '?action=list&searchField='+ KPIIndexSearchField + '&searchValue=' + this.getValue(),method:'POST'});
				KPIIndexDs.load({params:{start:0, limit:KPIIndexPagingToolbar.pageSize}});
	    	}
		}
});
KPIIndexDs.each(function(record){
    alert(record.get('tieOff'));

});
var KPIIndexPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: KPIIndexDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',KPIIndexFilterItem,'-',KPIIndexSearchBox]
});

var KPIIndexMain = new Ext.grid.EditorGridPanel({//表格
		title: '指标设置非树状结构',
		store: KPIIndexDs,
		cm: KPIIndexCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addKPIIndexButton,'-'],
		bbar: KPIIndexPagingToolbar
});


KPIIndexMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
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
          var mr=KPIIndexDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["code"].trim()+"^"+mr[i].data["name"].trim()+"^"+mr[i].data["desc"].trim();
                var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: KPIIndexUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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
KPIIndexMain.on("afteredit", afterEdit, KPIIndexMain);    
KPIIndexDs.load({params:{start:0, limit:KPIIndexPagingToolbar.pageSize}});
