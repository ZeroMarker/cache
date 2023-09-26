function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
var cycleIdCookieName="bdvCycleDr";
var periodTypeNameCookieName="bdvPeriodTypeName";
var periodTypeCookieName="bdvPeriodType";
var periodCookieName="bdvPeriod";
var groupIdCookieName="bdvGroupDr";
var nameStr=cycleIdCookieName+"^"+periodTypeNameCookieName+"^"+periodTypeCookieName+"^"+periodCookieName+"^"+groupIdCookieName;
var dataStr="";

var data="";
var data1=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
var data3=[['1','1~6�ϰ���'],['2','7~12�°���']];
var data4=[['0','00']];
var count1=0;
var count2=0;

var monthStore="";

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'��������',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

cycleDs.on('load', function(ds, o){
	//cycleField.setValue(getCookie(cycleIdCookieName));
	//count1=1;
});

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:180,
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
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});

periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	width:180,
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

//����ҳ��ʱ��Ⱦ�ؼ�
setComboValueFromClientOfNotChange(periodTypeField,periodTypeNameCookieName,periodTypeCookieName);

if(getCookie(periodTypeCookieName)=="M"){data=data1;}
if(getCookie(periodTypeCookieName)=="Q"){data=data2;}
if(getCookie(periodTypeCookieName)=="H"){data=data3;}
if(getCookie(periodTypeCookieName)=="Y"){data=data4;}
//����ҳ��ʱ��Ⱦ�ؼ�
setComboValueFromClientOfChange(periodStore,data,periodField,periodCookieName);

//�ڼ�����뷽����ѯ�Ķ�����������
function searchFun(periodType){
	periodField.setValue("");
	periodField.setRawValue("");
	/* if(getCookie(periodTypeCookieName)==periodType){
		setComboActValueFromClientOfChange(periodField,periodCookieName);
	} */
};

var groupDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

groupDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.basedataviewexe.csp?action=group&str='+encodeURIComponent(Ext.getCmp('groupField').getRawValue()),method:'POST'})
	
});

var groupField = new Ext.form.ComboBox({
	id: 'groupField',
	fieldLabel:'����',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: groupDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'groupField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

groupDs.on('load', function(ds, o){
	//groupField.setValue(getCookie(groupIdCookieName));
	//count2=1;
});

//==============================================================================================================================

var vouchDetailST = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'../csp/dhc.pa.basedataviewexe.csp'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}),
		remoteSort: true
	});

var autoHisOutMedCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer()
]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:'�������ݲ�ѯ',
		region:'north',
		frame:true,
		height:140,
		items:[{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
					{columnWidth:.07,xtype:'label',text: '���:'},
					cycleField,
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.14,xtype:'label',text: '�ڼ�����:'},
					periodTypeField,
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.07,xtype:'label',text: '�ڼ�:'},
					periodField,
					{columnWidth:.01,xtype:'displayfield'},
					{columnWidth:.14,xtype:'label',text: '��ʾ����:'},
					groupField
				]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[{columnWidth:.9,xtype: 'displayfield',value: '<font size="5px"><center>�� �� �� �� �� ѯ</center></font>'}]
			},{
				xtype: 'panel',
				layout:"column",
				hideLabel:true,
				isFormField:true,
				items:[
					{columnWidth:.41,xtype:'displayfield'},
					{columnWidth:.4,xtype:'displayfield',value:''},
					{columnWidth:.05,xtype:'button',text: '��ѯ',name: 'bc',tooltip: '��ѯ',handler:function(){find()},iconCls: 'add'},
					{columnWidth:.05,xtype:'button',text: '���',name: 'gb',tooltip: '���',handler:function(){audit()},iconCls: 'remove'}
				]
			}
		]
});

find = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	var periodTypeName=Ext.getCmp('periodTypeField').getRawValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񿼺��ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var groupDr=Ext.getCmp('groupField').getValue();
	if((groupDr=="")||(groupDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ָ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}

	dataStr=cycleIdCookieName+"^"+cycleDr+"!"+groupIdCookieName+"^"+groupDr+"!"+periodCookieName+"^"+period+"!"+periodTypeCookieName+"^"+periodType+"!"+periodTypeNameCookieName+"^"+periodTypeName;
	setBathCookieValue(dataStr);
	
	Ext.Ajax.request({
		url:'../csp/dhc.pa.basedataviewexe.csp?action=getTitleInfo&groupDr='+groupDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var cmItems = []; 
			var cmConfig = {}; 
			cmItems.push(new Ext.grid.RowNumberer()); 
			var jsonHeadNum = jsonData.results; 
			var jsonHeadList = jsonData.rows; 
			var tmpDataMapping = [];
			for(var i=0;i<jsonHeadList.length;i++){
				if(jsonHeadList[i].title=="��Ч��ԪID"){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left',hidden:true};
				}else{
					if((jsonHeadList[i].title=="��Ч��Ԫ����")||(jsonHeadList[i].title=="��Ч��Ԫ����")){
						cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left'};
					}else{
						cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:80,renderer:format,sortable:true,align:'right'};
					}
				}
				cmItems.push(cmConfig); 
				tmpDataMapping.push(jsonHeadList[i].name);
			}
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			
			var length=jsonHeadList[2].name.split("-").length;
			var publicName=jsonHeadList[2].name.split("-")[0];
						
			var tmpStore = new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.basedataviewexe.csp?action=getData&groupDr='+groupDr+'&publicName='+publicName+'&cycleDr='+cycleDr+'&periodType='+periodType+'&period='+period, method:'GET'
				}),
				reader:new Ext.data.JsonReader({
					totalProperty:"results",
					root:'rows'
				},tmpDataMapping),
				remoteSort:true
			});
			autohisoutmedvouchMain.reconfigure(tmpStore,tmpColumnModel);
			tmpStore.load();
		},
		scope: this
	});
}

audit = function(){
	var userCode = session['LOGON.USERCODE'];
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var periodType=Ext.getCmp('periodTypeField').getValue();
	if((periodType=="")||(periodType=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ڼ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var period=Ext.getCmp('periodField').getValue();
	if((period=="")||(period=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񿼺��ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var groupDr=Ext.getCmp('groupField').getValue();
	if((groupDr=="")||(groupDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ָ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:250});
		return false;
	}
	var str=Ext.getCmp('cycleField').getRawValue()+Ext.getCmp('periodField').getRawValue()+Ext.getCmp('groupField').getRawValue();
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ���'+str+'��������?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.basedataviewexe.csp?action=audit&groupDr='+groupDr+'&cycleDr='+cycleDr+'&periodType='+periodType+'&period='+period+'&userCode='+userCode,
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'��˳ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
						}else{
							if(jsonData.info=='1'){
								Ext.Msg.show({title:'��ʾ',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler,width:250});
							}
						}
					},
					scope: this
				});
			}
		}
	)
}


var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	stripeRows:true,
	loadMask:true
});

vouchDetailST.load();
