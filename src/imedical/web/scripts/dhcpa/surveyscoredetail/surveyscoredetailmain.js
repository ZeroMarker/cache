var SurveyScoreDetailUrl = 'dhc.pa.surveyscoreexe.csp';
var SurveyScoreDetailProxy = new Ext.data.HttpProxy({url: SurveyScoreDetailUrl+'?action=getData'});

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
var SurveyScoreDetailDs = new Ext.data.Store({
	proxy: SurveyScoreDetailProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','period','periodType','periodTypeName','schemDr','schemName','unitDr','unitName','ScoreDr','ScoreName','score','userDr','patDr','patName','KPIDr','KPIName'
 
		]),
    remoteSort: true
});

SurveyScoreDetailDs.setDefaultSort('rowid', 'DESC');

SurveyScoreDetailDs.on('beforeload', function(ds, o){
	//alert(SurveyScoreDetailUrl+'?action=getData&schemDr='+getValueByParam('schemDr')+'&rowid='+getValueByParam('rowid')+'&period='+getValueByParam('period')+'&periodType='+getValueByParam('periodType')+'&acceptUnitDr='+getValueByParam('acceptUnitDr')+'&scoreUserDr='+getValueByParam('scoreUserDr'));
	ds.proxy=new Ext.data.HttpProxy({url: SurveyScoreDetailUrl+'?action=getData&schemDr='+getValueByParam('schemDr')+'&rowid='+getValueByParam('rowid')+'&period='+getValueByParam('period')+'&periodType='+getValueByParam('periodType')+'&acceptUnitDr='+getValueByParam('acceptUnitDr')+'&cycleDr='+getValueByParam('cycleDr')+'&scoreUserDr='+getValueByParam('scoreUserDr')+'&patDr='+getValueByParam('patDr')});
});
var SurveyScoreDetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '�ڼ�',
			dataIndex: 'period',
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: '�ڼ�����',
			dataIndex: 'periodTypeName',
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: '����',
			dataIndex: 'schemName',
			width: 150,
			align: 'left',
			sortable: true
	
		},
		{
			header: '������',
			dataIndex: 'ScoreName',
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: '�����',
			dataIndex: 'patName',
			width: 100,
			align: 'left',
			sortable: true
	
		},
		{
			header: 'ָ������',
			dataIndex: 'KPIName',
			width: 150,
			align: 'left',
			sortable: true
	
		},
		{
			header: '����',
			dataIndex: 'score',
			width: 100,
			align: 'right',
			sortable: true
	
		},
		{
			header: '����',
			dataIndex: 'desc',
			width: 200,
			align: 'left',
			sortable: true

		}
	]);


var SurveyScoreDetailSearchField = 'Name';


SurveyScoreDetailDs.each(function(record){
    //alert(record.get('tieOff'));

});


var SurveyScoreDetailMain = new Ext.grid.EditorGridPanel({//���
		title:decodeURI(getValueByParam('title'))+'��������',
		store: SurveyScoreDetailDs,
		cm: SurveyScoreDetailCm,
		trackMouseOver: true,
		region: 'center',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		clicksToEdit: 2,
		stripeRows: true 
		
});


SurveyScoreDetailMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
SurveyScoreDetailDs.load();
