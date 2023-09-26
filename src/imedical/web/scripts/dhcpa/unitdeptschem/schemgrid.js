var schemUrl = '../csp/dhc.pa.unitdeptschemexe.csp';
var schemProxy = new Ext.data.HttpProxy({url:schemUrl + '?action=schemlist'});


var data="";
var data1=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
var data3=[['1','1~6�ϰ���'],['2','7~12�°���']];
var data4=[['0','00']];

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['M','M-��'],['Q','Q-��'],['H','H-����'],['Y','Y-��']]
});

/*var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return "0"+parseInt(d);

}*/

var yearField= new Ext.form.TextField({
                id:'yearField',
                value:(new Date()).getFullYear(),
                width: 80,
                triggerAction: 'all',
                allowBlank: true,
                fieldLabel: '���',
                emptyText: '',
                name: 'yearField',
                allowBlank: false ,
                regex:/^\d{4}$/,
                regexText:"ֻ�������������",
                editable:true,
                minChars: 1,
				pageSize: 10
            });

var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'Q', //Ĭ��ֵ
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
	var pattern=/^\d{4}$/;
				
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});



//�ڼ�����뷽����ѯ�Ķ�����������
function searchFun(periodType){
	periodField.setValue("");
	periodField.setRawValue("");
	/* if(getCookie(periodTypeCookieName)==periodType){
		setComboActValueFromClientOfChange(periodField,periodCookieName);
	} */
};


periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
/*var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return parseInt(d);

}*/

periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['1','01����'],['2','02����'],['3','03����'],['4','04����']]);
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	//value:getFullPeriodType(new Date()),
	width:100,
	listWidth : 100,
	selectOnFocus: true,
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
var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {
				
				var pattern=/^\d{4}$/;
				
				
				year=yearField.getValue();
				if(
				!pattern.test(year)){
					Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;}
				
				schemDs.load({params:{start:0, limit:schemPagingToolbar.pageSize,period:Ext.getCmp('periodTypeField').getValue(),dir:'asc',sort:'rowid'}});
			
			
			
			}
			
		})
//ҵ���������Դ
var schemDs = new Ext.data.Store({
	proxy: schemProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'frequency'
	]),
	remoteSort: true
});

schemDs.setDefaultSort('rowid', 'desc');

var schemCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '�Բ����',
		dataIndex: 'code',
		width: 100,
		sortable: true
	},{
		header: "�Բ�����",
		dataIndex: 'name',
		width: 180,
		align: 'left',
		sortable: true
	}
]);

//�Բ��ʼ����ť
var InitButton = new Ext.Toolbar.Button({
	text: '�Բ��ʼ��',
    tooltip:'�Բ��ʼ��',        
    iconCls:'add',
	handler:function(){
		var year= yearField.getRawValue();
		var period= periodTypeField.getValue();
		var perioditem= periodField.getValue();
		if((year=="")||(period=="")){
			Ext.Msg.show({title:'ע��',msg:'����д���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  	return false;			
		}
		else{
			Ext.Ajax.request({
			url: 'dhc.pa.unitdeptschemexe.csp?action=init&year='+year+'&period='+period+'&perioditem='+perioditem,
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Ext.Msg.show({title:'ע��',msg:'��ʼ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				else
				{
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if(jsonData.info=='DSCNodata') message='�Բ鶨��������!';
					if(jsonData.info=='UDSNodata') message='��ȷ��ÿ���Բ鶨���Ӧ�����Բ����,Ȼ������!';
					if(jsonData.info=='DSDNodata') message='�뷵�ص��Բ鶨��-����ҳ��,ȷ��ÿ���Բ鶨���Ӧ�����Բ���ϸ,Ȼ������!';
                    Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
			});		
		}
	}
});

var schemPagingToolbar = new Ext.PagingToolbar({//��ҳ������
	pageSize:25,
	store: schemDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodTypeField').getValue();
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({//���
	title: '�Բ鶨��',
	region: 'west',
	width: 550,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: schemDs,
	cm: schemCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['���:',yearField,'-','�ڼ�����:',periodTypeField,'-','�ڼ�:',periodField,'-',findButton,'-',InitButton],
	bbar: schemPagingToolbar
});

var schemRowId = "";
var schemName = "";

SchemGrid.on('rowclick',function(grid,rowIndex,e){
	//������Ч������ˢ�¼�Ч��Ԫ
	var selectedRow = schemDs.data.items[rowIndex];

	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["name"];
	jxUnitGrid.setTitle(schemName+"-��������");
	jxUnitDs.proxy = new Ext.data.HttpProxy({url:jxUnitUrl+'?action=jxunitlist&schemDr='+schemRowId+'&sort=rowid&dir=DESC'});
	jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
});

schemDs.on("beforeload",function(ds){
	jxUnitDs.removeAll();
	schemRowId = "";
	jxUnitGrid.setTitle("������Ϣ");
});
	