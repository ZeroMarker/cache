var SurveyTotalScoreUrl = 'dhc.pa.surveyscoreexe.csp';
var SurveyTotalScoreProxy = new Ext.data.HttpProxy({url: SurveyTotalScoreUrl+'?action=getlist'});


var SurveyTotalScoreDs = new Ext.data.Store({
	proxy: SurveyTotalScoreProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','period','periodType','periodTypeName','schemDr','schemName','unitDr','unitName','score'
 
		]),
    remoteSort: true
});

SurveyTotalScoreDs.setDefaultSort('rowid', 'DESC');

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'年度',
	width:100,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:100,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
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

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6上半年'],['2','7~12下半年']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '期间',
	width:100,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodField.on("select",function(cmb,rec,id){
   var period=Ext.getCmp('periodField').getValue();
   if(period<10){
		period="0"+""+period;
	}
   SurveyTotalScoreDs.proxy=new Ext.data.HttpProxy({url: SurveyTotalScoreUrl+'?action=getlist&period='+period+'&periodType='+periodTypeField.getValue()+'&cycleDr='+cycleField.getValue()});
   SurveyTotalScoreDs.load({params:{start:0, limit:SurveyTotalScorePagingToolbar.pageSize}});
   });
var SurveyTotalScoreCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '接受科室',
			//dataIndex: 'unitName',
			width: 100,
			align: 'left',
			sortable: true,
			dataIndex: 'unitName',renderer:function(value,meta,record){
					   var period=Ext.getCmp('periodField').getValue();
					    if(period<10){
							period="0"+""+period;
						}
					   return "<a onClick=\"unitconfirm('"+period+"','"+record.get('rowid')+"','"+periodTypeField.getValue()+"','"+record.get('unitDr')+"','"+record.get('unitName')+"','"+record.get('schemDr')+"','"+cycleField.getValue()+"');\" Style=\"cursor:pointer;\">"+record.get('unitName')+"</a>";
						}

		},{
			header: '期间',
			dataIndex: 'period',
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: '期间类型',
			dataIndex: 'periodTypeName',
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: '方案',
			dataIndex: 'schemName',
			width: 200,
			align: 'left',
			sortable: true
	
		},
		{
			header: '分数',
			dataIndex: 'score',
			width: 100,
			align: 'right',
			sortable: true

		}
	]);

function unitconfirm(period,rowid,periodType,unitDr,title,schemDr,cycleDr)
{
  // var r=Ext.MessageBox.confirm('提示','确实要设置该月指标区间?',handler);("确定要设置所选月份的区间吗？");
   Ext.MessageBox.confirm('提示','确定查看此科室的分数情况?', function(btn){
    if (btn == 'yes'){
        //alert(period);
		window.open("dhc.pa.surveyscoretotal.csp?period="+period+"&rowid="+rowid+"&periodType="+periodType+"&unitDr="+unitDr+"&schemDr="+schemDr+"&cycleDr="+cycleDr+"&title="+encodeURI(title), "", "toolbar=no,height=500,width=800");
		/*var url="dhc.pa.schemunitdetail.csp?schem="+schemedistField+"&rowid="+rowid+"&extremum="+extremum+"&title="+encodeURI(title);
        window.location=url;
		*/

    }
});
   
}	
var SurveyTotalScoreSearchField = 'Name';

var SurveyTotalScoreFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'SurveyTotalScoreFilter',checkHandler: onSurveyTotalScoreItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'SurveyTotalScoreFilter',checkHandler: onSurveyTotalScoreItemCheck })
		]}
});

function onSurveyTotalScoreItemCheck(item, checked)
{
		if(checked) {
				SurveyTotalScoreSearchField = item.value;
				SurveyTotalScoreFilterItem.setText(item.text + ':');
		}
};

var SurveyTotalScoreSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				SurveyTotalScoreDs.proxy = new Ext.data.HttpProxy({url: SurveyTotalScoreUrl + '?action=getlist'});
				SurveyTotalScoreDs.load({params:{start:0, limit:SurveyTotalScorePagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SurveyTotalScoreDs.proxy = new Ext.data.HttpProxy({
				url: SurveyTotalScoreUrl + '?action=getlist&searchField=' + SurveyTotalScoreSearchField + '&searchValue=' + this.getValue()});
				SurveyTotalScoreDs.load({params:{start:0, limit:SurveyTotalScorePagingToolbar.pageSize}});
	    	}
		}
});
SurveyTotalScoreDs.each(function(record){
    //alert(record.get('tieOff'));

});
var SurveyTotalScorePagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: SurveyTotalScoreDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"
		//buttons: ['-',SurveyTotalScoreSearchBox]
});

var SurveyTotalScoreMain = new Ext.grid.EditorGridPanel({//表格
		title: '问卷最终分数',
		store: SurveyTotalScoreDs,
		cm: SurveyTotalScoreCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: ["年度:",cycleField,'-',"期间类型:",periodTypeField,'-',"期间:",periodField],
		bbar: SurveyTotalScorePagingToolbar
});


SurveyTotalScoreMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
SurveyTotalScoreDs.load({params:{start:0, limit:SurveyTotalScorePagingToolbar.pageSize}});
