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
	fieldLabel:'���',
	width:100,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:100,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){
		data=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
	}
	if(cmb.getValue()=="Q"){
		data=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
	}
	if(cmb.getValue()=="H"){
		data=[['1','1~6�ϰ���'],['2','7~12�°���']];
	}
	if(cmb.getValue()=="Y"){
		data=[['0','ȫ��']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '�ڼ�',
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
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
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
			header: '���ܿ���',
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
			width: 200,
			align: 'left',
			sortable: true
	
		},
		{
			header: '����',
			dataIndex: 'score',
			width: 100,
			align: 'right',
			sortable: true

		}
	]);

function unitconfirm(period,rowid,periodType,unitDr,title,schemDr,cycleDr)
{
  // var r=Ext.MessageBox.confirm('��ʾ','ȷʵҪ���ø���ָ������?',handler);("ȷ��Ҫ������ѡ�·ݵ�������");
   Ext.MessageBox.confirm('��ʾ','ȷ���鿴�˿��ҵķ������?', function(btn){
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
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'SurveyTotalScoreFilter',checkHandler: onSurveyTotalScoreItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'SurveyTotalScoreFilter',checkHandler: onSurveyTotalScoreItemCheck })
		]}
});

function onSurveyTotalScoreItemCheck(item, checked)
{
		if(checked) {
				SurveyTotalScoreSearchField = item.value;
				SurveyTotalScoreFilterItem.setText(item.text + ':');
		}
};

var SurveyTotalScoreSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
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
var SurveyTotalScorePagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: SurveyTotalScoreDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"
		//buttons: ['-',SurveyTotalScoreSearchBox]
});

var SurveyTotalScoreMain = new Ext.grid.EditorGridPanel({//���
		title: '�ʾ����շ���',
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
		tbar: ["���:",cycleField,'-',"�ڼ�����:",periodTypeField,'-',"�ڼ�:",periodField],
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
