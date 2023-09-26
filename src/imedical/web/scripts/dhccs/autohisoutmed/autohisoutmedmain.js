//var accountingPeriodST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['1','01'],
//				['2','02'],
//				['3','03'],
//				['4','04']]
//	});
	
var accountingPeriodST = new Ext.data.Store({
    autoLoad: true,
    proxy:"",
    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['render','rowid'])
});

accountingPeriodST.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=ACCTYearPeriodList&searchField=name&searchValue=' + Ext.getCmp('accountingPeriodCB').getRawValue(), method:'GET'});
        }
    );	
	
var accountingPeriodCB = new Ext.form.ComboBox({
		id:'accountingPeriodCB',
		store: accountingPeriodST,
		valueField:'rowid',
		displayField:'render',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ�����ڼ�...',
		allowBlank: false,
		name:'accountingPeriodCB',
		selectOnFocus: true,
		//mode:'local',
		forceSelection: true
	});
	
////////////////////////////////////////////////////
var docNoST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','1'],
				['2','2'],
				['3','3'],
				['4','4']]
	});
		
var docNoCB = new Ext.form.ComboBox({
		id:'docNoCB',
		store: docNoST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'docNoCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});
		

var docNoCB2 = new Ext.form.ComboBox({
		id:'docNoCB2',
		store: docNoST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'docNoCB2',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});
	
/////////////////////////////////////////////////////
//var businessTypeST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['1','1.�ɹ����'],
//				['2','2.����ҩƷ���'],
//				['3','3.ҩ�����'],
//				['4','4.�м۵���'],
//				['5','5.��۵���'],
//				['6','6.�Ƽ�����ҩ'],
//				['7','7.�Ƽ�����ҩ'],
//				['8','8.��������'],
//				['9','9.��ӯ'],
//				['10','10�̿�'],
//				['11','11�˻�']]
//	});

var businessTypeST = new Ext.data.Store({
    autoLoad: true,
    proxy:"",
    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['name','code','rowid'])
});

businessTypeST.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=ACCTSysBusiTypeList&searchField=name&searchValue=' + Ext.getCmp('businessTypeCB').getRawValue(), method:'GET'});
        }
    );	
	
var businessTypeCB = new Ext.form.ComboBox({
		id:'businessTypeCB',
		store: businessTypeST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'businessTypeCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});
	
businessTypeCB.on(
        'select',
        function(combo, record, index ) {
				var tmpV = combo.getValue();
				//alert(tmpV);
				if(tmpV==5||tmpV==10){
					autohisoutmedMain.reconfigure(autoHisOutMedSt,autoHisOutMedCm1);
				}else if(tmpV==8){
					autohisoutmedMain.reconfigure(autoHisOutMedSt,autoHisOutMedCm2);
				}else if(tmpV==7){
					autohisoutmedMain.reconfigure(autoHisOutMedSt,autoHisOutMedCm3);
				}
            }
    );	

//////////////////////////////////////////////////	
var pharmacyAndDrugStoreST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','��ҩ��'],
				['2','��ҩ��']]
	});
	
var pharmacyAndDrugStoreCB = new Ext.form.ComboBox({
		id:'pharmacyAndDrugStoreCB',
		store: pharmacyAndDrugStoreST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'pharmacyAndDrugStoreCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

////////////////////////////////////////////////////
//var locsST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['1','���ʿ�']]
//	});

var locsST = new Ext.data.Store({
    autoLoad: true,
    proxy:"",
    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['name','code','rowid'])
});

locsST.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=CTLOCList&searchField=name&searchValue=' + locsCB.getRawValue(), method:'GET'});
        }
    );	
	
var locsCB = new Ext.form.ComboBox({
		id:'locsCB',
		store: locsST,
		valueField:'name',
		displayField:'name',
		//typeAhead:true,  ע��ɾ��
		pageSize:10,
		minChars:1,
		width:250,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'locsCB',
		selectOnFocus: true,
		//mode:'local',
		forceSelection: true
	});

//////////////////////////////////////////////////
var genedST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','��'],
				['2','��']]
	});
	
var genedCB = new Ext.form.ComboBox({
		id:'genedCB',
		store: genedST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'genedCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

//////////////////////////////////////////////////
var genTypeST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','��������'],
				['2','��������'],
				['3','��������']]
	});
	
var genTypeCB = new Ext.form.ComboBox({
		id:'genTypeCB',
		store: genTypeST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'genTypeCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

///////////////////////////////////////////////////	
var suppliersST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','����ͬ������ҩ��']]
	});
	
var suppliersCB = new Ext.form.ComboBox({
		id:'suppliersCB',
		store: suppliersST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'suppliersCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

/////////////////////////////////////////////////
var managersST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','����']]
	});
	
var managersCB = new Ext.form.ComboBox({
		id:'managersCB',
		store: managersST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'managersCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

////////////////////////////////////////////////////	
var genButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',        
		iconCls: 'add',
		handler: function(){
			var rows=autohisoutmedMain.getSelectionModel().getSelections();
			var len = rows.length;
			if(len == 0){ 
				Ext.Msg.alert('ע��','����ѡ��������!');
			}else{
				var strBusino = '';
				for(var i=0;i <len;i++){ 
					if(i==0){
						strBusino = rows[i].get('No'); 
					}else{
						strBusino = strBusino + ',' + rows[i].get('No'); 
					}
				} 
				var yearPeriodId = accountingPeriodCB.getValue();
				var busiTypeId = businessTypeCB.getValue();
				var operator = session['LOGON.USERCODE'];
										
				Ext.Ajax.request({
					url: 'dhc.cs.autohisoutexe.csp?action=ACCTCreateVouch&yearPeriodId='+yearPeriodId+'&busiTypeId='+busiTypeId+'&strBusino='+strBusino+'&operator='+operator,
					waitMsg:'������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'ƾ֤���ɳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							autoHisOutMedSt.load();
/////////////////////				
//////overwrite//////
/////////////////////
							//alert(jsonData.info);
							//dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
							//window.close();
						}else{
							Ext.Msg.show({title:'����',msg:'ƾ֤����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
	});
	
var inquiryButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',        
		iconCls: 'add',
		handler: function(){
/////////////////////
//////overwrite//////
/////////////////////
			if((accountingPeriodCB.getValue()=='')||(locsCB.getValue()=='')||(businessTypeCB.getValue()=='')){
				Ext.Msg.alert('��ʾ','ѡ���Ϊ��!');
			}else{
				autoHisOutMedSt.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=CreateDataJson&yearPeriodId='+accountingPeriodCB.getValue()+'&locDesc='+locsCB.getValue()+'&busiTypeId='+businessTypeCB.getValue()});
				autoHisOutMedSt.load();			
			}
		}
	})

////////////////////////////////////////////////////
var tbar2 = new Ext.Toolbar({
		items : ['ҩ��ҩ����',pharmacyAndDrugStoreCB,'-','���ң�',locsCB,'-','�Ƿ��Ѿ�����ƾ֤��',genedCB]
	});
	
var tbar3 = new Ext.Toolbar({
		items : ['���ɷ�ʽ��',genTypeCB,'-','��Ӧ�̣�',suppliersCB,'-','�����ˣ�',managersCB,'-',genButton,inquiryButton]
	});
	
var autoHisOutMedSt = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=CreateDataJson&yearPeriodId='+accountingPeriodCB.getValue()+'&locDesc='+locsCB.getValue()+'&busiTypeId='+businessTypeCB.getValue()}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
				'No',
				'ProviderId',
				'ProviderDesc',
				'ReceiverId',
				'ReceiverDesc',
				'Date',
				'CreatUser',
				'AuditUser',
				'TempVouchNo'
			]),
		remoteSort: true
	});

//tmpColumnModel.setRenderer(1,function(value,meta,rec,rowIndex,colIndex,store){
//	var tmpValue=value.split("/");
//	var tmpY=tmpValue[2];
//	var tmpM=tmpValue[1];
//	var tmpD=tmpValue[0];
//	var tmpDate=null;
//	if(typeof(tmpY)=="undefined"){
//		return value
//	}else{
//		tmpDate=new Date(tmpY,tmpM-1,tmpD).format('Y-m-d');
//		return "<a href='dhc.cs.autohisclearingperson.csp?date="+tmpDate+"'>"+tmpDate+"</a>";
//	}
//});

var autoHisOutMedCSM = new Ext.grid.CheckboxSelectionModel();

autoHisOutMedCSM.on(
	'rowselect',
	function(t,index,r){
		var tmpTempVouchNo = r.get('TempVouchNo');
		if(tmpTempVouchNo!=''){
			//alert('��ʾ','����������������ʱƾ֤');
			t.deselectRow(index);
			//return true;
		}
		//return true;
	} 
);

var autoHisOutMedCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		autoHisOutMedCSM,
		{
			header: '���ݱ��',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "��Ӧ��",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "ժҪ",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "�ֿ�",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "����",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "������",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "�Ƶ���",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "�����",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '��ʱƾ֤���',
			dataIndex: 'TempVouchNo',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		}
	]);
	
var autoHisOutMedCm1 = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		autoHisOutMedCSM,
		{
			header: '���ݱ��',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "�������",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "ժҪ",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "�ֿ�",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "���ÿ���",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "������",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "�Ƶ���",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "�����",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '��ʱƾ֤���',
			dataIndex: 'TempVouchNo',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		}
	]);
	
var autoHisOutMedCm2 = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		autoHisOutMedCSM,
		{
			header: '���ݱ��',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "ҩ��",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "ժҪ",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "�ֿ�",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "����",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "������",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "�Ƶ���",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "�����",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '��ʱƾ֤���',
			dataIndex: 'TempVouchNo',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		}
	]);
	
var autoHisOutMedCm3 = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		autoHisOutMedCSM,
		{
			header: '���ݱ��',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "����",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "ժҪ",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "�ֿ�",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "����",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "������",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "�Ƶ���",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "�����",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '��ʱƾ֤���',
			dataIndex: 'TempVouchNo',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		}
	]);

var autohisoutmedMain = new Ext.grid.GridPanel({
		title: '�Զ�����ƾ֤��ҩƷ��',
		store: autoHisOutMedSt,
		cm: autoHisOutMedCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: autoHisOutMedCSM,
		loadMask: true,
		//tbar: ['����ڼ䣺',accountingPeriodCB,'-','���ݱ�ţ�',docNoCB,'��',docNoCB2,'-','ҵ�����ͣ�',businessTypeCB],
		tbar: ['����ڼ䣺',accountingPeriodCB,'-','���ң�',locsCB,'-','ҵ�����ͣ�',businessTypeCB,inquiryButton,genButton],
		listeners : {
			'render' : function() {
				//tbar2.render(this.tbar);
				//tbar3.render(this.tbar);
			},
			'cellclick' : function(grid, rowIndex, columnIndex, e){
				//alert(columnIndex);
				if(columnIndex==2){
					//alert("a");
					purchasestorageformFun(grid, rowIndex, columnIndex, e, businessTypeCB );
				}else if(columnIndex==8){
					//alert("a");
					autohisoutmedvouchFun(grid, rowIndex, columnIndex, e);
				}else{

				}
			}
		}
	});
	