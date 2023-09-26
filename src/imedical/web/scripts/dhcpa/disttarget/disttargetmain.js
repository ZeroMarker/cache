function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};

var cycleIdCookieNameOfDT="cycleDr";
var schemIdCookieNameOfDT="schemDr";
var deptIdCookieNameOfDT="deptDr";
var kpiIdCookieNameOfDT="kpiDr";
var nameStr=cycleIdCookieNameOfDT+"^"+schemIdCookieNameOfDT+"^"+deptIdCookieNameOfDT+"^"+kpiIdCookieNameOfDT;
var dataStr="";
var count1=0;
var count2=0;
var count3=0;
var count4=0;



var userCode = session['LOGON.USERCODE'];


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
	fieldLabel:'���',
	width:180,
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

/* cycleDs.on('load', function(ds, o){
	cycleField.setValue(getCookie(cycleIdCookieNameOfDT));
	count1=1;
}); */

var schemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','parRef','code','name','shortcut','appSysDr','frequency','KPIDr','KPIName','desc','level','appSys','quency','shortCutFreQuency'])
});

schemDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=schem&searchField=name&searchValue='+encodeURIComponent(Ext.getCmp('schemField').getRawValue())+'&active=Y',method:'POST'})
	
});
var schemField = new Ext.form.ComboBox({
	id: 'schemField',
	fieldLabel: '��ǰ����',
	width:180,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: schemDs,
	anchor: '90%',
	displayField:'shortCutFreQuency',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'ѡ��ǰ����...',
	editable:true,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

/* schemDs.on('load', function(ds, o){
	schemField.setValue(getCookie(schemIdCookieNameOfDT));
	count2=1;
}); */

var deptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitName','shortCut'])
});

deptDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=dept&schemDr='+Ext.getCmp('schemField').getValue(),method:'POST'})
	
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '����',
	width:180,
	listWidth : 200,
	selectOnFocus: false,
	allowBlank: false,
	store: deptDs,
	anchor: '90%',
	displayField: 'shortCut',
	valueField: 'jxUnitDr',
	triggerAction: 'all',
	emptyText:'ѡ�����...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	forceSelection: true
});

/* deptDs.on('load', function(ds, o){
	deptField.setValue(getCookie(deptIdCookieNameOfDT));
	count3=1;
});
 */
var KPIDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


KPIDs.on('beforeload', function(ds, o){
	
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=kpi&schemDr='+Ext.getCmp('schemField').getValue()+'&userCode='+userCode,method:'POST'})
	
});
var KPIField = new Ext.form.ComboBox({
	id: 'KPIField',
	fieldLabel: '',
	width:180,
	listWidth : 200,
	selectOnFocus: false,
	allowBlank: false,
	store: KPIDs,
	anchor: '90%',
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	emptyText:'��ѡ��KPI...',
	editable:false,
	pageSize: 10,
	minChars: 1,
	forceSelection: true
});

/* KPIDs.on('load', function(ds, o){
	KPIField.setValue(getCookie(kpiIdCookieNameOfDT));
	count4=1;
});
 */
schemField.on("select",function(cmb,rec,id ){
    searchFun(cmb.getValue());
});

function searchFun(schemDr){
	deptField.setValue("");
	deptField.setRawValue("");
	//��Ч��λ
    deptDs.load({params:{start:0, limit:deptField.pageSize}});
	KPIField.setValue("");
	KPIField.setRawValue("");
	//KPIָ��
	KPIDs.load({params:{start:0, limit:KPIField.pageSize}});
	
	/* if(getCookie(schemIdCookieNameOfDT)==schemDr){
		setComboValueFromServer(deptField,deptIdCookieNameOfDT);
		setComboValueFromServer(KPIField,kpiIdCookieNameOfDT);
	}else{
		deptDs.on('load', function(ds, o){
			deptField.setValue("");
		});
		KPIDs.on('load', function(ds, o){
			KPIField.setValue("");
		});
	} */
};

var sm = new Ext.grid.CheckboxSelectionModel();

var vouchDetailST = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'../csp/dhc.pa.basedataviewexe.csp'}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}),
	remoteSort: true
});

var autoHisOutMedCm = new Ext.grid.ColumnModel([]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
	title:'Ŀ��ֽ�����',
	region:'north',
	frame:true,
	height:90,
	items:[{
		xtype: 'panel',
		layout:"column",
		hideLabel:true,
		isFormField:true,
		items:[
			{columnWidth:.07,xtype:'label',text: '���:'},
			cycleField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.1,xtype:'label',text: '��ǰ����:'},
			schemField,
			{columnWidth:.02,xtype:'displayfield'},
			{columnWidth:.1,xtype:'label',text: 'KPI ָ��:'},
			KPIField,
			{columnWidth:.50,xtype:'displayfield'},
			{columnWidth:.05,xtype:'button',text: '��ѯ',name: 'bc',tooltip: '��ѯ',handler:function(){find()},iconCls: 'add'}
			]
		},{
			xtype: 'panel',
			layout:"column",
			hideLabel:true,
			isFormField:true,
			items:[
				{columnWidth:.25,xtype:'displayfield'},
				{columnWidth:.057,xtype:'label',text: '��     ��:'},
				deptField,
				{columnWidth:.01,xtype:'displayfield'},
				{columnWidth:.065,xtype:'label',text: '��������:'},
				{columnWidth:.08,xtype:'button',text: '����ϵ������',name: 'gb',tooltip: '����ϵ������',handler:function(){setRate()}},
				{columnWidth:.2,xtype:'displayfield'},
				{columnWidth:.08,xtype:'button',text: '���ݳ�ʼ��',name: 'gb',tooltip: '���ݳ�ʼ��',handler:function(){init()},iconCls: 'remove'},
				{columnWidth:.135,xtype:'displayfield'},
				{columnWidth:.05,xtype:'button',text: '����',name: 'bc',tooltip: '����',handler:function(){update()},iconCls: 'remove'}
			]
		}
	]
});

init2=function(){
	Ext.Ajax.request({
		url:'../csp/dhc.pa.disttargetexe.csp?action=init&cycleDr='+Ext.getCmp('cycleField').getValue()+'&schemDr='+Ext.getCmp('schemField').getValue(),
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'��ʾ',msg:'���ݳ�ʼ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			}else{
				if(jsonData.info=='Copyed'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս���Ѿ���ʼ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='NoCurrRecord'){
					Ext.Msg.show({title:'��ʾ',msg:'û�е�ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='RepCurrRecord'){
					Ext.Msg.show({title:'��ʾ',msg:'�����ǰս��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false1'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Է�����ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false2'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Է�����ϸ��ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false3'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Լӿ۷ַ���ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='false4'){
					Ext.Msg.show({title:'��ʾ',msg:'��ǰս�����䷨��ʼ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				if(jsonData.info=='nullUnit'){
					Ext.Msg.show({title:'��ʾ',msg:'�÷�����û�п���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
			
			}
		},
		scope: this
	});
}

init = function(){
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ��������?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:'../csp/dhc.pa.disttargetexe.csp?action=judgeinit&schemDr='+Ext.getCmp('schemField').getValue(),
					waitMsg:'...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.info=='Copyed'){
							Ext.MessageBox.confirm('��ʾ','��ǰս���Ѿ���ʼ��,Ҫ���³�ʼ����?',
								function(btn) {
									if(btn == 'yes'){
										init2();
									}	
								}
							)
						}else if(jsonData.info=='NoCurrRecord'){
							Ext.Msg.show({title:'��ʾ',msg:'û�е�ǰս��,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else if(jsonData.info=='RepCurrRecord'){
							Ext.Msg.show({title:'��ʾ',msg:'�����ǰս��,������ֹ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}else{
							Ext.MessageBox.confirm('��ʾ','ȷʵҪ��ʼ����?',
								function(btn) {
									if(btn == 'yes'){
										init2();
									}	
								}
							)
						}
					},
					scope: this
				});
			}
		}
	)
}

//======================================================
var tmpStore="";
var pagingToolbar="";
var start=0;

//��ѯ��ť������
find = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	var kpiDr=Ext.getCmp('KPIField').getValue();
	var deptDr=Ext.getCmp('deptField').getValue();
	dataStr=cycleIdCookieNameOfDT+"^"+cycleDr+"!"+schemIdCookieNameOfDT+"^"+schemDr+"!"+deptIdCookieNameOfDT+"^"+deptDr+"!"+kpiIdCookieNameOfDT+"^"+kpiDr;
	setBathCookieValue(dataStr);
	Ext.Ajax.request({
		url:'../csp/dhc.pa.disttargetexe.csp?action=getTitleInfo&cycleDr='+cycleDr+'&schemDr='+schemDr,
		waitMsg:'...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var cmItems = []; 
			var cmConfig = {}; 
			cmItems.push(sm); 
			cmItems.push(new Ext.grid.RowNumberer()); 
			var jsonHeadNum = jsonData.results; 
			var jsonHeadList = jsonData.rows; 
			var tmpDataMapping = [];
			for(var i=0;i<jsonHeadList.length;i++){
				if((jsonHeadList[i].name=="jxUnitDr")||(jsonHeadList[i].name=="KPIDr")||(jsonHeadList[i].name=="DistDr")){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left',hidden:true};
				}
				else if((jsonHeadList[i].name=="jxUnitName")||(jsonHeadList[i].name=="KPIName")){
					cmConfig = {header:jsonHeadList[i].title,dataIndex:jsonHeadList[i].name,width:75,sortable:true,align:'left'};
				}
				else if(jsonHeadList[i].name=="DistName"){
					cmConfig = {
						header:jsonHeadList[i].title,
						dataIndex:jsonHeadList[i].name,
						width:100,
						sortable:true,
						align:'left',
						editor:new Ext.form.ComboBox({
							editable:false,
							valueField: 'value',
							displayField:'value',
							mode:'local',
							triggerAction:'all',
							store:new Ext.data.SimpleStore({
								fields:['value'],
								data:[['1-ȫ��᳹'],['2-�����᳹'],['3-����ϵ��'],['4-���ֽ�']]
							})
						})
					};
				}else{
					var align="left";
					if(i>5){
						align="right";
					}
					cmConfig = {
						header:jsonHeadList[i].title,
						dataIndex:jsonHeadList[i].name, 
						width:75,
						sortable:true,
						renderer:format,
						align:align,
						editor:new Ext.form.TextField({
							allowBlank:true
						})
					};
				}
				cmItems.push(cmConfig); 
				tmpDataMapping.push(jsonHeadList[i].name);
			}
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			
			tmpStore = new Ext.data.Store({
				proxy:new Ext.data.HttpProxy({url:'../csp/dhc.pa.disttargetexe.csp?action=getData&cycleDr='+cycleDr+'&schemDr='+schemDr+'&kpiDr='+kpiDr+'&deptDr='+deptDr, method:'GET'}),
				reader:new Ext.data.JsonReader({
					totalProperty:"results",
					root:'rows'
				},tmpDataMapping),
				remoteSort:true
			});
			autohisoutmedvouchMain.reconfigure(tmpStore,tmpColumnModel);
			
			var ptb = autohisoutmedvouchMain.getTopToolbar();
			if (!ptb || !ptb.bind) {
				ptb = autohisoutmedvouchMain.getBottomToolbar();
			}
			if (ptb && ptb.bind) {
				ptb.unbind(tmpStore);
				if (tmpStore.proxy) {
					ptb.bind(tmpStore);
					ptb.show();
				} else {
					ptb.hide();
				}
				autohisoutmedvouchMain.doLayout();
			}
			tmpStore.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize}});
		},
		scope: this
	});
}

distMethod = function(){
	//����������������¡����ȡ��������������÷��䷽��
	var schemDr=Ext.getCmp('schemField').getValue();
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:200});
		return false;
	}
	
	var schemShortCutF=Ext.getCmp('schemField').getRawValue();
	var rowObj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=rowObj.length;
	
	if(length<1){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
		return false;
	}else{
		//���弨Ч��ԪID�ַ���
		var jxUnitDrStr="";
		//����ֽⷽ��ID�ַ���
		var methodDrStr="";
		
		var infoStr="";
		
		for(var i=0;i<length;i++){
			//������ʱ��Ч��ԪDr����
			var tmpJXUnitDr=rowObj[i].get('jxUnitDr');
			//������ʱ���䷽��Dr����
			var tmpDistDr=rowObj[i].get('DistName').split("-")[0];
			//������ʱָ��Dr����
			var tmpKpiDr=rowObj[i].get('KPIDr');
			var info=tmpJXUnitDr+"^"+tmpDistDr+"^"+tmpKpiDr+"^"+schemDr;
			
			if(infoStr==""){
				infoStr=info;
			}else{
				infoStr=infoStr+"!"+info;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���ø÷�����?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url:'../csp/dhc.pa.disttargetexe.csp?action=setmethod&infoStr='+infoStr,
						waitMsg:'...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'��ʾ',msg:'���䷽���������!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:250});
								find();
							}else{
								if(jsonData.info=='1'){
									Ext.Msg.show({title:'��ʾ',msg:'���䷽������ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
								}
								if(jsonData.info=='NoYear'){
									Ext.Msg.show({title:'��ʾ',msg:'û�и��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
								}
								if(jsonData.info=='NoKPIDr'){
									Ext.Msg.show({title:'��ʾ',msg:'û�и�ָ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
								}
								if(jsonData.info=='ErrCycle'){
									Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Դ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
								}
								if(jsonData.info=='NoMethod'){
									Ext.Msg.show({title:'��ʾ',msg:'���䷽�������ڻ��߶�ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
								}
								if(jsonData.info=='NoDatas'){
									Ext.Msg.show({title:'��ʾ',msg:'û������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
								}
								if(jsonData.info=='NoSchem'){
									Ext.Msg.show({title:'��ʾ',msg:'û�з���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
								}
							}
						},
						scope: this
					});
				}	
			}
		)
	}
}

setRate = function(){
	var cycleDr=Ext.getCmp('cycleField').getValue();
	if((cycleDr=="")||(cycleDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:150});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();	
	if((schemDr=="")||(schemDr=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING,width:150});
		return false;
	}
	var rowObj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=rowObj.length;
	if(length<1){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ����ϵ���ĵ�Ԫ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
		return false;
	}else{
		//������ʱָ��Dr����
		var kpiDr=rowObj[0].get('KPIDr');
		
		
		var numField=new Ext.form.NumberField({
			id:'numField',
			fieldLabel:'����ϵ��',
			width:200,
			allowBlank:true,
			blankText:'����д������ֵ',
			msTarget:'qtip'
		})
		
		var form = new Ext.form.FormPanel({
			height:100,
			width:300,
			frame:true,
			labelSeparator:':',
			labelWidth:60,
			labelAlign:'right',
			items:[
				numField
			]
		});
		
		//��ʼ�����ð�ť
		setButton = new Ext.Toolbar.Button({
			text:'ȷ��'
		});
		
		//�������ð�ť��Ӧ����
		setHandler = function(){
			var num = numField.getValue();
			//���弨Ч��ԪID�ַ���
			var unitDrStr="";
			for(var i=0;i<length;i++){
				//������ʱ��Ч��ԪDr����
				var tmpJXUnitDr=rowObj[i].get('jxUnitDr');
				if(unitDrStr==""){
					unitDrStr=tmpJXUnitDr;
				}else{
					unitDrStr=unitDrStr+"!"+tmpJXUnitDr;
				}
			}
			if(num!=""){
				Ext.Ajax.request({
					url: '../csp/dhc.pa.disttargetexe.csp?action=setrate&schemDr='+schemDr+'&kpiDr='+kpiDr+'&num='+num+'&jxUnitDrStr='+unitDrStr,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							win.close();
							Ext.Msg.show({title:'ע��',msg:'���óɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							start=pagingToolbar.cursor;
							find();
						}else{
							if(jsonData.info=='1'){
								Ext.Msg.show({title:'��ʾ',msg:'����ϵ������ʧ��,�����ѻع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
							}
							if(jsonData.info=='NoYear'){
								Ext.Msg.show({title:'��ʾ',msg:'û�и��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
							if(jsonData.info=='NoKPIDr'){
								Ext.Msg.show({title:'��ʾ',msg:'û�и�ָ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
							}
							if(jsonData.info=='ErrCycle'){
								Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Դ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
							if(jsonData.info=='ErrMonth'){
								Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Եĵ�ǰ�·ݲ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:300});
							}
							if(jsonData.info=='NoData'){
								Ext.Msg.show({title:'��ʾ',msg:'û�����ݸ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
							if(jsonData.info=='NoNum'){
								Ext.Msg.show({title:'��ʾ',msg:'ϵ���Ѿ���ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
							}
						}
					},
					scope: this
				});
			}else{
				Ext.Msg.show({title:'��ʾ',msg:'����д����ϵ��ֵ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
				return false;
			}
		}
	
		//������ð�ť�ļ����¼�
		setButton.addListener('click',setHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			win.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		win = new Ext.Window({
			title: '���ñ���ϵ������',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 150,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyBorder:false, 
			buttonAlign:'center',
			border:false, 
			items:form,
			buttons: [
				setButton,
				cancelButton
			]
		});
	
		//������ʾ
		win.show();
	}
}
var point="";
update = function(){
	var schemName=Ext.getCmp('schemField').getRawValue();
	if((schemName=="")||(schemName=="null")){
		Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
		return false;
	}
	var schemDr=Ext.getCmp('schemField').getValue();
	var frequery=schemName.split("!")[schemName.split("!").length-1];
	
	var obj = autohisoutmedvouchMain.getSelectionModel().getSelections();
	var length=obj.length;
	if(length<1){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ����ϵ���ĵ�Ԫ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}else{
		var dataInfo="";
		for(var i=0;i<length;i++){
			if(frequery=="M"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="ȫ��᳹"){DistDr=1;}
					if(DistName=="�����᳹"){DistDr=2;}
					if(DistName=="����ϵ��"){DistDr=3;}
					if(DistName=="���ֽ�"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var month1=obj[i].get('month1');
				var month2=obj[i].get('month2');
				var month3=obj[i].get('month3');
				var month4=obj[i].get('month4');
				var month5=obj[i].get('month5');
				var month6=obj[i].get('month6');
				var month7=obj[i].get('month7');
				var month8=obj[i].get('month8');
				var month9=obj[i].get('month9');
				var month10=obj[i].get('month10');
				var month11=obj[i].get('month11');
				var month12=obj[i].get('month12');
				
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+month1+"^"+month2+"^"+month3+"^"+month4+"^"+month5+"^"+month6+"^"+month7+"^"+month8+"^"+month9+"^"+month10+"^"+month11+"^"+month12+"^"+DistDr;
				//alert("DistDr="+DistDr);
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
			if(frequery=="Q"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="ȫ��᳹"){DistDr=1;}
					if(DistName=="�����᳹"){DistDr=2;}
					if(DistName=="����ϵ��"){DistDr=3;}
					if(DistName=="���ֽ�"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var Quarter1=obj[i].get('Quarter1');
				var Quarter2=obj[i].get('Quarter2');
				var Quarter3=obj[i].get('Quarter3');
				var Quarter4=obj[i].get('Quarter4');
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+Quarter1+"^"+Quarter2+"^"+Quarter3+"^"+Quarter4+"^"+DistDr;
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
			if(frequery=="H"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="ȫ��᳹"){DistDr=1;}
					if(DistName=="�����᳹"){DistDr=2;}
					if(DistName=="����ϵ��"){DistDr=3;}
					if(DistName=="���ֽ�"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var HYear1=obj[i].get('HYear1');
				var HYear2=obj[i].get('HYear2');
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+HYear1+"^"+HYear2+"^"+DistDr;
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
			if(frequery=="Y"){
				var DistDr="";
				var data="";
				var jxUnitDr=obj[i].get('jxUnitDr');
				var KPIDr=obj[i].get('KPIDr');
				var DistName=obj[i].get('DistName');
				var arr=DistName.split("-");
				if(arr.length==1){
					if(DistName=="ȫ��᳹"){DistDr=1;}
					if(DistName=="�����᳹"){DistDr=2;}
					if(DistName=="����ϵ��"){DistDr=3;}
					if(DistName=="���ֽ�"){DistDr=4;}
				}else{
					DistDr=arr[0];
				}
				var Year=obj[i].get('Year');
				data=jxUnitDr+"^"+schemDr+"^"+KPIDr+"^"+Year+"^"+DistDr;
				if(dataInfo==""){
					dataInfo=data;
				}else{
					dataInfo=dataInfo+"!"+data;
				}
			}
		}
		dataInfo=dataInfo+"%"+frequery;
		
		Ext.Ajax.request({
			url:'../csp/dhc.pa.disttargetexe.csp?action=update&dataInfo='+dataInfo,
			waitMsg:'ˢ����...',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					start=pagingToolbar.cursor;
					find();
				}else{
					if(jsonData.info=='1'){
						Ext.Msg.show({title:'��ʾ',msg:'��������ʧ��,�����ѻع�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
					}
					if(jsonData.info=='NoUpdate'){
						Ext.Msg.show({title:'��ʾ',msg:'û�б�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					}
					if(jsonData.info=='ErrCycle'){
						Ext.Msg.show({title:'��ʾ',msg:'��ǰս�Դ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					}
					if(jsonData.info=='NoData'){
						Ext.Msg.show({title:'��ʾ',msg:'û�����ݸ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:200});
					}
				}
			},
			scope: this
		});
	}
}

pagingToolbar=new Ext.PagingToolbar({
	store:tmpStore,
	pageSize:30,
	displayInfo:true,
	displayMsg: '�� {0} ���� {1} ��,һ�� {2} ��',
	emptyMsg:"û�м�¼"
})

var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
	store:vouchDetailST,
	cm:autoHisOutMedCm,
	region:'center',
	clicksToEdit:1,
	trackMouseOver:true,
	sm:sm,
	stripeRows:true,
	loadMask:true,
	bbar:pagingToolbar
});

vouchDetailST.load();

//��ȡ�������cell��id
autohisoutmedvouchMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	point=columnIndex;
})
