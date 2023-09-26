var OutKPIDataUrl = 'dhc.pa.outkpidataexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({url: OutKPIDataUrl+'?action=list'});

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.stratagemexe.csp?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel:'��������',
	width:150,
	listWidth : 150,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name:'cycleField',
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
	selectOnFocus: true,
	width:150,
	listWidth : 150,
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
	fieldLabel: '',
	selectOnFocus: true,
	allowBlank: false,
	width:150,
	listWidth : 150,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'��ѡ��...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

var locSetDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

locSetDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'dhc.pa.outkpidataexe.csp?action=locset&str='+Ext.getCmp('locSetField').getRawValue(),method:'POST'})
});

var locSetField = new Ext.form.ComboBox({
	id: 'locSetField',
	fieldLabel:'�ӿ���',
	width:150,
	listWidth : 150,
	allowBlank: false,
	store: locSetDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ӿ���...',
	name:'locSetField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var OutKPIDataDs = new Ext.data.Store({
	proxy: OutKPIDataProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
      'rowid',
			'outUnitCode',
			'outUnitName',
			'outUnitLocCode',
			'outUnitLocName',
			'unitType',
			'outKpiCode',
			'outKpiName',
			'period',
			'periodType',    
			'actValue',
			'active',
			'handFlag'
 
		]),
    // turn on remote sorting
    remoteSort: true
});

OutKPIDataDs.setDefaultSort('rowid', 'DESC');


var importButton = new Ext.Toolbar.Button({
	text: '����ϵͳ����',
	tooltip: '����ϵͳ����',
	iconCls: 'add',
	handler: function(){
		var cycleDr=Ext.getCmp('cycleField').getValue();
		if(cycleDr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		var periodType=Ext.getCmp('periodTypeField').getValue();
		if(periodType==""){
			Ext.Msg.show({title:'��ʾ',msg:'��ѡ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		var period=Ext.getCmp('periodField').getValue();
		if(period==""){
			Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		var locSetDr=Ext.getCmp('locSetField').getValue();
		var locSetName=Ext.getCmp('locSetField').getRawValue();
		if(locSetDr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}
		
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�����������ָ��������?',
    	    function(btn){
	    	    if(btn == 'yes'){
					Ext.Ajax.request({
						url: OutKPIDataUrl+'?action=import&CycleDr='+cycleDr+'&frequency='+periodType+'&period='+period+'&locSetDr='+locSetDr,
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result,request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'��ʾ',msg:locSetName+'��ָ�����ݵ���ɹ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								OutKPIDataDs.proxy=new Ext.data.HttpProxy({url:OutKPIDataUrl+'?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue(),method:'POST'});
								OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
								//���³���
							}else{
								if(jsonData.info=='NoCycle'){
									Ext.Msg.show({title:'��ʾ',msg:'��Ȳ�����ʧ������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if(jsonData.info=='NoFreq'){
									Ext.Msg.show({title:'��ʾ',msg:'�����ڼ����Ͳ�����ʧ������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if(jsonData.info=='NoPeriod'){
									Ext.Msg.show({title:'��ʾ',msg:'�����ڼ������ʧ������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if(jsonData.info=='NoLocSet'){
									Ext.Msg.show({title:'��ʾ',msg:'�ӿ�ϵͳ������ʧ������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if(jsonData.info=='NoPeriodType'){
									Ext.Msg.show({title:'��ʾ',msg:'�ýӿ�ϵͳ����ֻ��ͨ��ҳ��¼�����Excel�ļ����룬����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								if(jsonData.info=='NoNewPeriod'){
									Ext.Msg.show({title:'��ʾ',msg:'��Чϵͳ��������д�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								Ext.Msg.show({title:'��ʾ',msg:'ָ�����ݵ���ʧ�ܣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							}
						},
						scope: this
					});
			    }
		    }
		);
	}
});

var importHZButton = new Ext.Toolbar.Button({
	text: '���뺣��ϵͳ����',
	tooltip: '���뺣��ϵͳ����',
	iconCls: 'add',
	handler: function(){
		var data3="";
	var freStore="";
	
		var cyDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
	});

	cyDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cy').getRawValue()+'&active=Y',method:'POST'})
	});

	var cy = new Ext.form.ComboBox({
		id: 'cy',
		fieldLabel:'��������',
		//width:180,
		//listWidth : 180,
		allowBlank: false,
		store: cyDs,
		valueField: 'code',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�񿼺�����...',
		name: 'cycleField',
		minChars: 1,
		anchor: '90%',
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	
	var perTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','M-��'],['Q','Q-��'],['H','H-����'],['Y','Y-��']]
	});
	var perType = new Ext.form.ComboBox({
		id: 'perType',
		fieldLabel: '�ڼ�����',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: perTypeStore,
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

	perType.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data3=[['1','01��'],['2','02��'],['3','03��'],['4','04��'],['5','05��'],['6','06��'],['7','07��'],['8','08��'],['9','09��'],['10','10��'],['11','11��'],['12','12��']];
		}
		if(cmb.getValue()=="Q"){
			data3=[['1','01����'],['2','02����'],['3','03����'],['4','04����']];
		}
		if(cmb.getValue()=="H"){
			data3=[['1','1~6�ϰ���'],['2','7~12�°���']];
		}
		if(cmb.getValue()=="Y"){
			data3=[['0','ȫ��']];
		}
		perStore.loadData(data3);
	});
	perStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});

	var Period = new Ext.form.ComboBox({
		id: 'Period',
		fieldLabel: '�ڼ�ֵ',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: perStore,
		anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'��ѡ���ڼ�ֵ...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

		var formPanel = new Ext.form.FormPanel({
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:515,
			width:515,
			frame:true,
			fileUpload:false,
			//applyTo:'form',
			items: [cy,perType,Period]
		});
				
		//���尴ť
		var importSYS = new Ext.Toolbar.Button({
			text:'���ݵ���'
		});
	
	
		
    	var handler2 = function(btn){
			var cycleName=Ext.getCmp('cy').getRawValue();
			if(cycleName==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			var periodType=Ext.getCmp('perType').getValue();
			if(periodType==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			var period=Ext.getCmp('Period').getValue();
			if(period==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
					//alert("aaaaaaaaa");
					var uploadUrl = "http://132.147.160.114:8080/uploadexcel/importsys";
					var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&cycleName="+cycleName;
                                      //alert(upUrl);
						formPanel.getForm().submit({
							url:upUrl,
							method:'POST',
							waitMsg:'���ݵ�����, ���Ե�...',
							success:function(form, action, o) {
								Ext.MessageBox.alert("��ʾ��Ϣ","���ݳɹ�����!");
								//Ext.MessageBox.alert("Information",action.result.mess);
							},
							failure:function(form, action) {
								Ext.MessageBox.alert("Error",action.result.mess);
							}
						});		
		}
		
		//��Ӱ�ť����Ӧ�¼�
	importSYS.addListener('click',handler2,false);

	var window = new Ext.Window({
		title: '�������ָ������',
		width: 400,
		height:200,
		minWidth: 400,
		minHeight: 200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			importSYS
		]
	});
	window.show();
	}
});

//���밴ť
var excelButton = new Ext.Toolbar.Button({
	text: '����Excel����',
    tooltip:'����Excel����',        
    iconCls:'add',
	handler:function(){importExcel()}
			
});

var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
	tooltip: 'ɾ��ѡ��������',
	iconCls: 'add',
	handler: function(){
		delFun(OutKPIDataDs,OutKPIDataMain,OutKPIDataPagingToolbar);
	}
});

Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
             e.stopEvent();   
            var index = this.grid.getView().findRowIndex(t);   
            var cindex = this.grid.getView().findCellIndex(t);   
            var record = this.grid.store.getAt(index);   
            var field = this.grid.colModel.getDataIndex(cindex);   
            var e = {   
                grid : this.grid,   
                record : record,   
                field : field,   
                originalValue : record.data[this.dataIndex],   
                value : !record.data[this.dataIndex],   
                row : index,   
                column : cindex,   
                cancel : false  
            };   
            if (this.grid.fireEvent("validateedit", e) !== false && !e.cancel) {   
                delete e.cancel;   
                record.set(this.dataIndex, !record.data[this.dataIndex]);   
                this.grid.fireEvent("afteredit", e);   
            }
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
	};

var OutKPIDataCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '�ⲿ��λ����',
			dataIndex: 'outUnitCode',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '�ⲿ��λ����',
			dataIndex: 'outUnitName',
			width: 120,
			align: 'left',
			sortable: true

		},
		{
			header: '�������Ҵ���',
			dataIndex: 'outUnitLocCode',
			width: 100,
			align: 'left',
			sortable: true

		},{
			header: '������������',
			dataIndex: 'outUnitLocName',
			width: 120,
			align: 'left',
			sortable: true

		},{
			header: '��λ���',
			dataIndex: 'unitType',
			width: 70,
			align: 'left',
			sortable: true

		},{
			header: '�ⲿָ�����',
			dataIndex: 'outKpiCode',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: '�ⲿָ������',
			dataIndex: 'outKpiName',
			width: 150,
			align: 'left',
			sortable: true

		},{
			header: 'ָ��ʵ��ֵ',
			dataIndex: 'actValue',
			width: 80,
			align: 'right',
			sortable: true

		},{
			header: " ��Ч��־",
			dataIndex: 'active',
			width: 90,
			sortable: true,
			align: 'center',
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "�����־",
			dataIndex: 'handFlag',
			width: 90,
			sortable: true,
			align: 'center',
            renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);



	
var OutKPIDataSearchField = 'outUnitName';

var OutKPIDataFilterItem = new Ext.SplitButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '�ⲿ��λ����',value: 'outUnitCode',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '�ⲿ��λ����',value: 'outUnitName',checked: true,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '�ⲿ��λ�������Ҵ���',value: 'outUnitLocCode',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '�ⲿ��λ������������',value: 'outUnitLocName',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '�ⲿָ�����',value: 'outKpiCode',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '�ⲿָ������',value: 'outKpiName',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: 'ָ��ʵ��ֵ',value: 'actValue',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck }),
				new Ext.menu.CheckItem({ text: '�����־',value: 'handFlag',checked: false,group: 'OutKPIDataFilter',checkHandler: onOutKPIDataItemCheck })
		]}
});

function onOutKPIDataItemCheck(item, checked){
		if(checked) {
				OutKPIDataSearchField = item.value;
				OutKPIDataFilterItem.setText(item.text + ':');
		}
};

var OutKPIDataSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
				OutKPIDataDs.proxy = new Ext.data.HttpProxy({url: OutKPIDataUrl + '?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue()});
				OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				OutKPIDataDs.proxy = new Ext.data.HttpProxy({
				url: OutKPIDataUrl + '?action=list&searchField=' + OutKPIDataSearchField + '&searchValue=' + this.getValue()+'&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue()});
				OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
	    	}
		}
});
OutKPIDataDs.each(function(record){
    alert(record.get('tieOff'));

});
var OutKPIDataPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: OutKPIDataDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',OutKPIDataFilterItem,'-',OutKPIDataSearchBox]
});

var OutKPIDataMain = new Ext.grid.GridPanel({//���
		title:'ָ�����ݲɼ�ά��',
		store:OutKPIDataDs,
		cm:OutKPIDataCm,
		trackMouseOver: true,
		region:'center',
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		frame: true,
		//plugins:checkColumn,
		clicksToEdit: 2,
		stripeRows: true,  
		tbar: ['���:',cycleField,'-','�ڼ�����:',periodTypeField,'-','�ڼ�:',periodField,'-','�ӿ���:',locSetField,'-',importButton,'-',importHZButton,'-',excelButton,'-',delButton],
		bbar: OutKPIDataPagingToolbar

});
periodField.on('select', function(cmb,rec,id){
	OutKPIDataDs.proxy=new Ext.data.HttpProxy({
	url:OutKPIDataUrl+'?action=list&CycleDr='+cycleField.getValue()+'&frequency='+periodTypeField.getValue()+'&period='+periodField.getValue(),method:'POST'
	});
	OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
});
////
function isEdit(value,record){   
    //���̨�ύ����   
   return value;   
  }  
OutKPIDataDs.load({params:{start:0, limit:OutKPIDataPagingToolbar.pageSize}});
