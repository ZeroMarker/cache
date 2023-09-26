var SurveyScoreTotalUrl = 'dhc.pa.surveyscoreexe.csp';
var SurveyScoreTotalProxy = new Ext.data.HttpProxy({url:SurveyScoreTotalUrl+'?action=getTotallist&period='+getValueByParam('period')+'&rowid='+getValueByParam('rowid')+'&periodType='+getValueByParam('periodType')+'&unitDr='+getValueByParam('unitDr')+'&schemDr='+getValueByParam('schemDr')+'&cycleDr='+getValueByParam('cycleDr')});
//var userDr=session['LOGON.USERID'];

var SurveyScoreTotalDs = new Ext.data.Store({
	proxy: SurveyScoreTotalProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','period','periodType','periodTypeName','schemDr','schemName','unitDr','unitName','ScoreDr','ScoreName','score','cycleDr','userDr','patDr','patName'
 
		]),
    remoteSort: true
});

SurveyScoreTotalDs.setDefaultSort('rowid', 'DESC');
SurveyScoreTotalDs.on('beforeload', function(ds, o){
	//alert(Ext.getCmp('schemedistField').getValue());
	ds.proxy=new Ext.data.HttpProxy({url:SurveyScoreTotalUrl+'?action=getTotallist&period='+getValueByParam('period')+'&rowid='+getValueByParam('rowid')+'&periodType='+getValueByParam('periodType')+'&unitDr='+getValueByParam('unitDr')+'&schemDr='+getValueByParam('schemDr')+'&cycleDr='+getValueByParam('cycleDr')});
});
function getValueByParam(paras){ 
	var url = location.href; 
	var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
	var paraObj = {} 
	for (i=0; j=paraString[i]; i++){ 
	paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
}
var returnValue = paraObj[paras.toLowerCase()]; 
	if(typeof(returnValue)=="undefined"){ 
	return ""; 
	}else{ 
	return returnValue; 
	} 
} 

  
var SurveyScoreTotalCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '接受科室',
			//dataIndex: 'unitName',
			width: 100,
			align: 'left',
			sortable: true,
			dataIndex: 'unitName',renderer:function(value,meta,record){
					   
					   return "<a onClick=\"unitconfirm('"+record.get('period')+"','"+record.get('rowid')+"','"+record.get('schemDr')+"','"+record.get('cycleDr')+"','"+record.get('periodType')+"','"+record.get('unitDr')+"','"+record.get('userDr')+"','"+record.get('patDr')+"','"+record.get('unitName')+"');\" Style=\"cursor:pointer;\">"+record.get('unitName')+"</a>";
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
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: '调查人',
			dataIndex: 'ScoreName',
			width: 100,
			align: 'left',
			sortable: true

		},
		{
			header: '打分人',
			dataIndex: 'patName',
			width: 100,
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

function unitconfirm(period,rowid,schemDr,cycleDr,periodType,unitDr,userDr,patDr,title)
{
  // var r=Ext.MessageBox.confirm('提示','确实要设置该月指标区间?',handler);("确定要设置所选月份的区间吗？");
   Ext.MessageBox.confirm('提示','确定查看此科室的分数情况?', function(btn){
    if (btn == 'yes'){
        window.open("dhc.pa.surveyscoredetail.csp?schemDr="+schemDr+"&rowid="+rowid+"&period="+period+"&periodType="+periodType+"&acceptUnitDr="+unitDr+"&cycleDr="+cycleDr+"&scoreUserDr="+userDr+"&patDr="+patDr+"&title="+encodeURI(title), "", "toolbar=no,height=500,width=800");
		/*var url="dhc.pa.schemunitdetail.csp?schem="+schemedistField+"&rowid="+rowid+"&extremum="+extremum+"&title="+encodeURI(title);
        window.location=url;
		*/

    }
});
}
var SurveyScoreTotalSearchField = 'Name';

var SurveyScoreTotalFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'SurveyScoreTotalFilter',checkHandler: onSurveyScoreTotalItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'SurveyScoreTotalFilter',checkHandler: onSurveyScoreTotalItemCheck }),
				new Ext.menu.CheckItem({ text: '描述',value: 'active',checked: false,group: 'SurveyScoreTotalFilter',checkHandler: onSurveyScoreTotalItemCheck })
		]}
});

function onSurveyScoreTotalItemCheck(item, checked)
{
		if(checked) {
				SurveyScoreTotalSearchField = item.value;
				SurveyScoreTotalFilterItem.setText(item.text + ':');
		}
};

var SurveyScoreTotalSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				SurveyScoreTotalDs.proxy = new Ext.data.HttpProxy({url: SurveyScoreTotalUrl + '?action=getlist'});
				SurveyScoreTotalDs.load({params:{start:0, limit:SurveyScoreTotalPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				SurveyScoreTotalDs.proxy = new Ext.data.HttpProxy({
				url: SurveyScoreTotalUrl + '?action=getlist&searchField=' + SurveyScoreTotalSearchField + '&searchValue=' + this.getValue()});
				SurveyScoreTotalDs.load({params:{start:0, limit:SurveyScoreTotalPagingToolbar.pageSize}});
	    	}
		}
});
SurveyScoreTotalDs.each(function(record){
    //alert(record.get('tieOff'));

});
var SurveyScoreTotalPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: SurveyScoreTotalDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',SurveyScoreTotalFilterItem,'-',SurveyScoreTotalSearchBox]
});

var SurveyScoreTotalMain = new Ext.grid.EditorGridPanel({//表格
		title:decodeURI(getValueByParam('title'))+'分数情况',
		store: SurveyScoreTotalDs,
		cm: SurveyScoreTotalCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true 
		//tbar: ["期间类型:",periodTypeField,'-',"期间:",periodField],
		//bbar: SurveyScoreTotalPagingToolbar
});


SurveyScoreTotalMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
SurveyScoreTotalDs.load();
