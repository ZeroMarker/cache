//�����õ����෽���Ͳ�������
var  appointmentInfo = {
	Session:{
		group_rowid:session['LOGON.GROUPID'],
		group_desc:session['LOGON.GROUPDESC'],
		user_rowid:session['LOGON.USERID'],
		user_name:session['LOGON.USERNAME'],
		user_locid:session['LOGON.CTLOCID']
	},
	URL:{
		//���ԤԼ
		AutoSchedule:"dhc.ris.examorder.method.csp?act=AutoSchedule",
		SelectScheduleResource:"dhc.ris.examorder.method.csp?act=SelectScheduleResource",
		CancelSchedule:"dhc.ris.examorder.method.csp?act=CancelSchedule",
		SaveSchedule:"dhc.ris.examorder.method.csp?act=SaveSchedule",
		BookOrder:"dhc.ris.examorder.method.csp?act=BookOrder",
		CancelBook:"dhc.ris.examorder.method.csp?act=CancelBook",
		CancelSave:"dhc.ris.examorder.method.csp?act=CancelSave",
		SaveBooked:"dhc.ris.examorder.method.csp?act=SaveBooked"
		
		
	},
	Local:
	{
		computerName:GetComputerName(),
		IpAddr:getLocalIP()
	}
};


//�����б�
var dateRecord = new Ext.data.Record.create([
	{name:'date',type:'string'},
	{name:'week',type:'string'},
	{name:'dateDesc',type:'string'}
]);

var dateStore = new Ext.data.Store({
	reader:new Ext.data.ArrayReader({},dateRecord)
});


function showWeek(num)
{
	var Week = ['��','һ','��','��','��','��','��'];  
    var str = '����' + Week[num]; 
    return str;
}

//ʱ��ο�ѡ��
var timeSpan = [
	['һ��','7'],
	['����','14'],
	['һ��','30'],
	['����','60'],
	['����','90']
];

var timeSpanRecord = new Ext.data.Record.create([
	{name:'desc',type:'string'},
	{name:'days',type:'string'}
]);

var timeSpanStore = new Ext.data.Store({
	proxy:new Ext.data.MemoryProxy(timeSpan),
	reader:new Ext.data.ArrayReader({},timeSpanRecord)
});



/////�����Ŀ�Ŀ�ԤԼ��Դ�б�
var modalityStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	url:ExtToolSetting.RunQueryPageURL
}));

var modalityStore = new Ext.data.Store({
	proxy:modalityStoreProxy,
	reader:new Ext.data.JsonReader({
		root:'record'
	},
	[
		{name:'modalityDesc',mapping:'ResourceDesc'},
		{name:'date',mapping:'BookedDate'},
		{name:'timespan',mapping:'TimeDesc'},
		{name:'number',mapping:'ReUnLockBKNumber'},
		{name:'rowid',mapping:'SchRowid'},
		{name:'modalityDr',mapping:'ResID'},
		{name:'view',mapping:'View'},
		{name:'MaxNumber',mapping:'MaxNumber'}
	])
});
modalityStoreProxy.on('beforeload',modalityStoreProxyBeforeload);
modalityStore.on('load',modalityStoreload);

function modalityStoreProxyBeforeload(objProxy,param)
{
	//var selRecord = serviceOrderGrid.getSelectionModel().getSelections();
	//if (  selRecord==null  ||selRecord.length != 1)
	//	return;
	//var arcItmDr=selRecord[0].data.arcItmDr;
	var arcItmDr=g_examItemFieldSetId.split("^")[0];
	//alert(arcItmDr);
	var OeordItemDr=g_examItemFieldSetId.split("^")[1];
	var startDate=dateStore.getAt(0).get('date');
	var endDate=dateStore.getAt(dateStore.getCount()-1).get('date');
	if ( arcItmDr == "" || startDate=="" || endDate=="")
	{
		alert('��������Ϊ��!');
		return;
	}
	
	param.ClassName='web.DHCRisResApptSchudleSystem';
	param.QueryName='QuerySchduleDetail';
	param.Arg1 = arcItmDr;  //Ext.getCmp('examItemRadioGroup').getValue().inputValue+"^";
	param.Arg2=startDate;
	param.Arg3=endDate;
	param.Arg4=OeordItemDr;
	param.ArgCnt = 4;
}

function modalityStoreload()
{	
	addModalityScheduleOld();
}