var SurveyScoreUrl = 'dhc.pa.surveyscoreexe.csp';
var SurveyScoreProxy = new Ext.data.HttpProxy({url:SurveyScoreUrl+'?action=list&active=Y'});
var userCode = session['LOGON.USERCODE'];

var SurveyScoreDs = new Ext.data.Store({
	proxy: SurveyScoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','userDr','userName','unitDr','unitName','unitType','unitTypeName','acceptUnitDr','acceptUnitName','acceptUnitType','acceptUnitTypeName','kpiDr','KPIName','scoreLevelDr','scoreLevel','directScore','period','periodType','schemDr','schemName','active'
 
		]),
    remoteSort: true
});

SurveyScoreDs.setDefaultSort('rowid', 'DESC');


var addSurveyScoreButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加调查问卷指标',
		iconCls: 'add',
		handler: function(){addSurveyScoreFun(SurveyScoreDs,SurveyScoreMain,SurveyScorePagingToolbar);}
});

var editSurveyScoreButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选定的调查问卷指标',
		iconCls: 'remove',
		handler: function(){editSurveyScoreFun(SurveyScoreDs,SurveyScoreMain,SurveyScorePagingToolbar);}
});
var delButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = SurveyScoreMain.getSelectionModel().getSelections();;
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的调查问卷指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:SurveyScoreUrl+'?action=del&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									//alert("删除成功!");
									SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize,active:"Y"}});
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
var SurveyScoreCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '用户',
			dataIndex: 'userName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: '打分科室',
			dataIndex: 'unitName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: '打分科室类型',
			dataIndex: 'unitTypeName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: '接受科室',
			dataIndex: 'acceptUnitName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: '接受科室类型',
			dataIndex: 'acceptUnitTypeName',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: '指标名称',
			dataIndex: 'KPIName',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "直接分数",
			dataIndex: 'directScore',
			width: 60,
			align: 'right',
			sortable: true
		},
		{
			header: "等级",
			dataIndex: 'scoreLevel',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header: "期间",
			dataIndex: 'period',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: "期间类型",
			dataIndex: 'periodType',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "方案",
			dataIndex: 'schemName',
			width: 100,
			align: 'left',
			sortable: true
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
	
var SurveyScoreSearchField = 'Name';

var SurveyScoreFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'SurveyScoreFilter',checkHandler: onSurveyScoreItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'SurveyScoreFilter',checkHandler: onSurveyScoreItemCheck }),
				new Ext.menu.CheckItem({ text: '描述',value: 'active',checked: false,group: 'SurveyScoreFilter',checkHandler: onSurveyScoreItemCheck })
		]}
});

function onSurveyScoreItemCheck(item, checked)
{
		if(checked) {
				SurveyScoreSearchField = item.value;
				SurveyScoreFilterItem.setText(item.text + ':');
		}
};

var SurveyScoreSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				SurveyScoreDs.proxy = new Ext.data.HttpProxy({url: SurveyScoreUrl + '?action=list'});
				SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SurveyScoreDs.proxy = new Ext.data.HttpProxy({
				url: SurveyScoreUrl + '?action=list&searchField=' + SurveyScoreSearchField + '&searchValue=' + this.getValue()});
				SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize}});
	    	}
		}
});
SurveyScoreDs.each(function(record){
    alert(record.get('tieOff'));

});
var SurveyScorePagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: SurveyScoreDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',SurveyScoreFilterItem,'-',SurveyScoreSearchBox]
});

var SurveyScoreMain = new Ext.grid.EditorGridPanel({//表格
		title: '调查问卷指标明细',
		store: SurveyScoreDs,
		cm: SurveyScoreCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//clicksToEdit: 2,
		stripeRows: true,  
		tbar: [addSurveyScoreButton,'-',editSurveyScoreButton,'-',delButton],
		bbar: SurveyScorePagingToolbar
});


SurveyScoreMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});


 
SurveyScoreDs.load({params:{start:0, limit:SurveyScorePagingToolbar.pageSize}});
