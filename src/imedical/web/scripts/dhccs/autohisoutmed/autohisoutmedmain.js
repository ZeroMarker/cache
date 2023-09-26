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
		emptyText:'选择会计期间...',
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
		emptyText:'选择...',
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
		emptyText:'选择...',
		allowBlank: false,
		name:'docNoCB2',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});
	
/////////////////////////////////////////////////////
//var businessTypeST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['1','1.采购入库'],
//				['2','2.自制药品入库'],
//				['3','3.药库出库'],
//				['4','4.有价调拨'],
//				['5','5.物价调拨'],
//				['6','6.制剂室领药'],
//				['7','7.制剂室退药'],
//				['8','8.科室领用'],
//				['9','9.盘盈'],
//				['10','10盘亏'],
//				['11','11退货']]
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
		emptyText:'选择...',
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
		data : [['1','西药库'],
				['2','中药库']]
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
		emptyText:'选择...',
		allowBlank: false,
		name:'pharmacyAndDrugStoreCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

////////////////////////////////////////////////////
//var locsST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['1','物质科']]
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
		//typeAhead:true,  注意删除
		pageSize:10,
		minChars:1,
		width:250,
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择...',
		allowBlank: false,
		name:'locsCB',
		selectOnFocus: true,
		//mode:'local',
		forceSelection: true
	});

//////////////////////////////////////////////////
var genedST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','是'],
				['2','否']]
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
		emptyText:'选择...',
		allowBlank: false,
		name:'genedCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

//////////////////////////////////////////////////
var genTypeST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','单张生成'],
				['2','汇总生成'],
				['3','按月生成']]
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
		emptyText:'选择...',
		allowBlank: false,
		name:'genTypeCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

///////////////////////////////////////////////////	
var suppliersST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','北京同仁堂制药厂']]
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
		emptyText:'选择...',
		allowBlank: false,
		name:'suppliersCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

/////////////////////////////////////////////////
var managersST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['1','张三']]
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
		emptyText:'选择...',
		allowBlank: false,
		name:'managersCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

////////////////////////////////////////////////////	
var genButton = new Ext.Toolbar.Button({
		text: '生成',
		tooltip: '生成',        
		iconCls: 'add',
		handler: function(){
			var rows=autohisoutmedMain.getSelectionModel().getSelections();
			var len = rows.length;
			if(len == 0){ 
				Ext.Msg.alert('注意','请先选择数据行!');
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
					waitMsg:'保存中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'凭证生成成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							autoHisOutMedSt.load();
/////////////////////				
//////overwrite//////
/////////////////////
							//alert(jsonData.info);
							//dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
							//window.close();
						}else{
							Ext.Msg.show({title:'错误',msg:'凭证生成失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
	});
	
var inquiryButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',        
		iconCls: 'add',
		handler: function(){
/////////////////////
//////overwrite//////
/////////////////////
			if((accountingPeriodCB.getValue()=='')||(locsCB.getValue()=='')||(businessTypeCB.getValue()=='')){
				Ext.Msg.alert('提示','选项不能为空!');
			}else{
				autoHisOutMedSt.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=CreateDataJson&yearPeriodId='+accountingPeriodCB.getValue()+'&locDesc='+locsCB.getValue()+'&busiTypeId='+businessTypeCB.getValue()});
				autoHisOutMedSt.load();			
			}
		}
	})

////////////////////////////////////////////////////
var tbar2 = new Ext.Toolbar({
		items : ['药库药房：',pharmacyAndDrugStoreCB,'-','科室：',locsCB,'-','是否已经生成凭证：',genedCB]
	});
	
var tbar3 = new Ext.Toolbar({
		items : ['生成方式：',genTypeCB,'-','供应商：',suppliersCB,'-','经办人：',managersCB,'-',genButton,inquiryButton]
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
			//alert('提示','该数据行已生成临时凭证');
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
			header: '单据编号',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "单据日期",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "供应商",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "摘要",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "仓库",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "科室",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "经办人",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "制单人",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "审核人",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '临时凭证编号',
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
			header: '单据编号',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "单据日期",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "出库科室",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "摘要",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "仓库",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "领用科室",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "经办人",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "制单人",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "审核人",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '临时凭证编号',
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
			header: '单据编号',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "单据日期",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "药房",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "摘要",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "仓库",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "病区",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "经办人",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "制单人",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "审核人",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '临时凭证编号',
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
			header: '单据编号',
			dataIndex: 'No',
			width: 150,
			align: 'left',
			renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
			sortable: true
		},
		{
			header: "单据日期",
			dataIndex: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "科室",
			dataIndex: 'ProviderDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "摘要",
		//	dataIndex: 'summary',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		//{
		//	header: "仓库",
		//	dataIndex: 'warehouse',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "科室",
			dataIndex: 'ReceiverDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		//{
		//	header: "经办人",
		//	dataIndex: 'managers',
		//	width: 100,
		//	align: 'left',
		//	sortable: true
		//},
		{
			header: "制单人",
			dataIndex: 'CreatUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "审核人",
			dataIndex: 'AuditUser',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: '临时凭证编号',
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
		title: '自动生成凭证（药品）',
		store: autoHisOutMedSt,
		cm: autoHisOutMedCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: autoHisOutMedCSM,
		loadMask: true,
		//tbar: ['会计期间：',accountingPeriodCB,'-','单据编号：',docNoCB,'至',docNoCB2,'-','业务类型：',businessTypeCB],
		tbar: ['会计期间：',accountingPeriodCB,'-','科室：',locsCB,'-','业务类型：',businessTypeCB,inquiryButton,genButton],
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
	