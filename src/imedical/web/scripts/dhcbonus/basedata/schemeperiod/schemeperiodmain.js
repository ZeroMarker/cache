/**
  *name:tab of database
  *author:liuyang
  *Date:2011-1-10
 */
 function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};
var SchemePeriodTabUrl = '../csp/dhc.bonus.schemeperiodexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ

var SchemePeriodTabProxy= new Ext.data.HttpProxy({url:SchemePeriodTabUrl + '?action=list'});
var SchemePeriodTabDs = new Ext.data.Store({
	proxy: SchemePeriodTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
	
		'rowid',
		'bonusYear',
		'bonusPeriod',
		'startDate',
		'endDate',
	
		'type',
		{name:'endDate',type:'date',dateFormat:'Y-m-d'},
		{name:'startDate',type:'date',dateFormat:'Y-m-d'}
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
SchemePeriodTabDs.setDefaultSort('rowid', 'name');

//���ݿ�����ģ��
var SchemePeriodTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '�������',
        dataIndex: 'bonusYear',
        width: 100,		  
        sortable: true
    },{
    	header: '�����ڼ�',
        dataIndex: 'bonusPeriod',
        width: 100,
        sortable: true
    },{
    	header: '��ʼʱ��',
        dataIndex: 'startDate',
        width: 150,
		renderer:formatDate,
        sortable: true
    },{
    	header: '����ʱ��',
        dataIndex: 'endDate',
        width: 150,
		renderer:formatDate,
        sortable: true
    }
    
]);

//��ʼ��Ĭ��������
SchemePeriodTabCm.defaultSortable = true;


//��ʼ�������ֶ�
var SchemePeriodSearchField ='name';

//����������
var SchemePeriodFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '�������',
			value: 'bonusYear',
			checked: false ,
			group: 'SchemePeriodFilter',
			checkHandler: onSchemePeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '�����ڼ�',
			value: 'bonusPeriod',
			checked: true,
			group: 'SchemePeriodFilter',
			checkHandler: onSchemePeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '��ʼʱ��',
			value: 'startDate',
			checked: true,
			group: 'SchemePeriodFilter',
			
			checkHandler: onSchemePeriodItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����ʱ��',
			value: 'endDate',
			checked: true,
			renderer:formatDate,
			group: 'SchemePeriodFilter',
			checkHandler: onSchemePeriodItemCheck 
		})
	]}
});

//����������Ӧ����
function onSchemePeriodItemCheck (item, checked){
	if(checked) {
		SchemePeriodSearchField = item.value;
		SchemePeriodFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var SchemePeriodSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			SchemePeriodTabDs.proxy = new Ext.data.HttpProxy({url:  SchemePeriodTabUrl + '?action=list'});
			SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				SchemePeriodTabDs.proxy = new Ext.data.HttpProxy({
				url: SchemePeriodTabUrl + '?action=list&searchField=' + SchemePeriodSearchField + '&searchValue=' + this.getValue()});
	        	SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
	    	}
	}
});



//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){	
var data="";
var data1=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
var data3=[['01','1~6�ϰ���'],['02','7~12�°���']];
var data4=[['00','00']];

		var yearField = new Ext.form.TextField({
			id:'yearField',
			fieldLabel: '�������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(yearField.getValue()!=""){
							periodTypeField.focus();
						}else{
							Handler = function(){yearField.focus();}
							Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
	var periodTypeStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '�ڼ�����',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodTypeField.getValue()!=""){
							periodField.focus();
						}else{
							Handler = function(){periodTypeField.focus();}
							Ext.Msg.show({title:'����',msg:'�ڼ����Ͳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});

periodTypeField.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	
});

periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '�ڼ�',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodField.getValue()!=""){
							startDate.focus();
						}else{
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'����',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});


var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '��ʼʱ��',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'',
		anchor: '90%',
			isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(startDate.getValue()!=""){
							endDate.focus();
						}else{
							Handler = function(){startDate.focus();}
							Ext.Msg.show({title:'����',msg:'��ʼʱ��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '����ʱ��',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		emptyText:'',
		anchor: '90%',
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
});
		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				yearField,
				periodTypeField,
				periodField,
				startDate,
				endDate
			]
		});
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
		
			var yeardr = yearField.getValue();
			var typedr = periodTypeField.getValue();
			var perioddr=periodField.getValue();
			var startdr1=startDate.getValue();
			var enddr1=endDate.getValue();
			
			if(startDate.getValue()!="")
			{
			 var startdr=startDate.getValue().format('Y-m-d');
			}
			if(endDate.getValue()!="")
			{
			 var enddr=endDate.getValue().format('Y-m-d');
			}
			yeardr = trim(yeardr);
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
			//alert("yeardr"+yeardr+"typedr"+typedr+"perioddr"+perioddr+"startdr"+startdr+"enddr"+enddr);
			if(yeardr==""){
				Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(typedr==""){
				Ext.Msg.show({title:'����',msg:'�ڼ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(perioddr==""){
				Ext.Msg.show({title:'����',msg:'�ڼ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(startdr1==""){
				Ext.Msg.show({title:'����',msg:'��ʼʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(enddr1==""){
				Ext.Msg.show({title:'����',msg:'����ʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(enddr1<=startdr1){
				Ext.Msg.show({title:'����',msg:'����ʱ��С�ڿ�ʼʱ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.schemeperiodexe.csp?action=add&yeardr='+yeardr+'&typedr='+typedr+'&perioddr='+perioddr+'&startdr='+startdr+'&enddr='+enddr,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){endDate.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){endDate.focus();}
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
								var message="�������ڼ��Ѵ���";
								
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
		}
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '��Ӽ�¼',
			width: 400,
			height:300,
			minWidth: 400, 
			minHeight: 300,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//������ʾ
		addwin.show();
	}
});


//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
     iconCls: 'option',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=SchemePeriodTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
var data="";
var data1=[['01','01��'],['02','02��'],['03','03��'],['04','04��'],['05','05��'],['06','06��'],['07','07��'],['08','08��'],['09','09��'],['10','10��'],['11','11��'],['12','12��']];
var data2=[['01','01����'],['02','02����'],['03','03����'],['04','04����']];
var data3=[['01','1~6�ϰ���'],['02','7~12�°���']];
var data4=[['00','00']];


	var year1Field = new Ext.form.TextField({
			id:'year1Field',
			fieldLabel: '�������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'�������...',
			valueNotFoundText:rowObj[0].get("bonusYear"),
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(year1Field.getValue()!=""){
							periodType1Field.focus();
						}else{
							Handler = function(){year1Field.focus();}
							Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var periodType1Store = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
});
var periodType1Field = new Ext.form.ComboBox({
	id: 'periodType1Field',
	fieldLabel: '�ڼ�����',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: periodType1Store,
	anchor: '90%',
	value:'', //Ĭ��ֵ
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'',
	mode: 'local', //����ģʽ
	valueNotFoundText:rowObj[0].get("type"),
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodType1Field.getValue()!=""){
							period1Field.focus();
						}else{
							Handler = function(){periodType1Field.focus();}
							Ext.Msg.show({title:'����',msg:'�ڼ����Ͳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});

periodType1Field.on("select",function(cmb,rec,id){
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	period1Store.loadData(data);
	
});

period1Store = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});

var period1Field = new Ext.form.ComboBox({
	id: 'period1Field',
	fieldLabel: '�ڼ�',
	width:180,
	//listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: period1Store,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueNotFoundText:rowObj[0].get("bonusPeriod"),
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ���ڼ�...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true,
	isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(period1Field.getValue()!=""){
							start1Date.focus();
						}else{
							Handler = function(){period1Field.focus();}
							Ext.Msg.show({title:'����',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
	var start1Date = new Ext.form.DateField({
		id: 'start1Date',
		fieldLabel: '��ʼʱ��',
		allowBlank: false,
		dateFormat: 'Y-m-d',
		valueNotFoundText:rowObj[0].get("startDate"),
		emptyText:'ѡ��ʼʱ��...',
		anchor: '90%',
			isteners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(start1Date.getValue()!=""){
							end1Date.focus();
						}else{
							Handler = function(){start1Date.focus();}
							Ext.Msg.show({title:'����',msg:'��ʼʱ��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
});
var end1Date = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '����ʱ��',
		allowBlank: false,
		valueNotFoundText:rowObj[0].get("endDate"),
		dateFormat: 'Y-m-d',
		emptyText:'ѡ�����ʱ��...',
		anchor: '90%',
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
});
	
		
		//���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				year1Field,
				periodType1Field,
				period1Field,
				start1Date,
				end1Date
			]
		});
	
		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			year1Field.setValue(rowObj[0].get("bonusYear"));
			periodType1Field.setValue(rowObj[0].get("type"));
			
			period1Field.setValue(rowObj[0].get("bonusPeriod"));	
			start1Date.setValue(rowObj[0].get("startDate"));	
			end1Date.setValue(rowObj[0].get("endDate"));		
			
		});
		
		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){
			
			var yeardr = year1Field.getValue();
			
			var typedr = periodType1Field.getValue();
			
			var perioddr=period1Field.getValue();
			var start=start1Date.getValue();
			var end=end1Date.getValue();
			
			if(start1Date.getValue()!="")
			{
			 var startdr=start1Date.getValue().format('Y-m-d');
			}
			if(end1Date.getValue()!="")
			{
			 var enddr=end1Date.getValue().format('Y-m-d');
			}
			yeardr = trim(yeardr);
			var temDate=""
			if(start1Date>end1Date){
				temDate=start1Date;
				start1Date=end1Date;
				end1Date=tem1Date;
			}
			//alert("yeardr"+yeardr+"typedr"+typedr+"perioddr"+perioddr+"startdr"+startdr+"enddr"+enddr);
			if(yeardr==""){
				Ext.Msg.show({title:'����',msg:'���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(typedr==""){
				Ext.Msg.show({title:'����',msg:'�ڼ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(perioddr==""){
				Ext.Msg.show({title:'����',msg:'�ڼ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(start==""){
				Ext.Msg.show({title:'����',msg:'��ʼʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(end==""){
				Ext.Msg.show({title:'����',msg:'����ʱ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(end<=start){
				Ext.Msg.show({title:'����',msg:'����ʱ��С�ڿ�ʼʱ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.schemeperiodexe.csp?action=edit&rowid='+rowid+'&yeardr='+yeardr+'&typedr='+typedr+'&perioddr='+perioddr+'&startdr='+startdr+'&enddr='+enddr,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){end1Date.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
						editwin.close();						
					}
					else
						{
							var message="��ѡ����ڼ��Ѵ���";
						
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
		}
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ���޸�'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ļ�¼',
			width: 400,
			height:250,
			minWidth: 400, 
			minHeight: 250,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//������ʾ
		editwin.show();
	}
});


//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=SchemePeriodTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.schemeperiodexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});



//��ҳ������
var SchemePeriodTabPagingToolbar = new Ext.PagingToolbar({
    store: SchemePeriodTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',SchemePeriodFilterItem,'-',SchemePeriodSearchBox]
	
	
});

//���
var SchemePeriodTab = new Ext.grid.EditorGridPanel({
	title: '������������',
	store: SchemePeriodTabDs,
	cm: SchemePeriodTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:SchemePeriodTabPagingToolbar
});
SchemePeriodTabDs.load({params:{start:0, limit:SchemePeriodTabPagingToolbar.pageSize}});
