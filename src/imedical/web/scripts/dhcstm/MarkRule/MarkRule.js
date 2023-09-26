// ����:���۹���
// ��д����:2012-06-5
var mrId = "";

var SDCommStore = new Ext.data.JsonStore({
	url : 'dhcstm.drugutil.csp?actiontype=StkDecimal',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
});

var SDComm = new Ext.form.ComboBox({
	fieldLabel : 'С������',
	id : 'SDComm',
	name : 'SDComm',
	anchor : '90%',
	width : 120,
	store : SDCommStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : 'С������...',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 10);			
			}
		}
	}
});

var MTCommStore = new Ext.data.JsonStore({
	url : 'dhcstm.drugutil.csp?actiontype=MarkType',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
});

var MTComm = new Ext.form.ComboBox({
	fieldLabel : '��������',
	id : 'MTComm',
	name : 'MTComm',
	anchor : '90%',
	width : 120,
	store : MTCommStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '��������...',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 12);			
			}
		}
	}
});

var UFlag = new Ext.grid.CheckColumn({
	header:'�Ƿ�ʹ��',
	dataIndex:'UseFlag',
	width:100,
	sortable:true
});

var MarkRuleGrid="";
//��������Դ
var MarkRuleGridUrl = 'dhcstm.markruleaction.csp';
var MarkRuleGridProxy= new Ext.data.HttpProxy({url:MarkRuleGridUrl+'?actiontype=selectAll',method:'GET'});
var MarkRuleGridDs = new Ext.data.Store({
	pruneModifiedRecords : true,
	proxy:MarkRuleGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'MinRp'},
		{name:'MaxRp'},
		{name:'Margin'},
		{name:'MPrice'},
		{name:'MaxMargin'},
		{name:'MaxMPrice'},
		{name:'SdDr'},
		{name:'SdDesc'},
		{name:'MtDr'},
		{name:'MtDesc'},
		{name:'UseFlag'},
		{name:'Remark'}
	]),
	pruneModifiedRecords:true,
	remoteSort:false
});

//ģ��
var MarkRuleGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����",
		dataIndex:'Code',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
			allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 2);
					}
				}
			}
		})
	},{
		header:"����",
		dataIndex:'Desc',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
			selectOnFocus:true,
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 3);
					}
				}
			}
		})
	},{
		header:"��������",
		dataIndex:'MinRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'minRpField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 4);
					}
				}
			}
		})
	},{
		header:"��������",
		dataIndex:'MaxRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxRpField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 5);
					}
				}
			}
		})
	},{
		header:"�ӳ���",
		dataIndex:'Margin',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'marginField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 6);
					}
				}
			}
		})
	},{
		header:"�ӳɶ�",
		dataIndex:'MPrice',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'mPriceField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 7);
					}
				}
			}
		})
	},{
		header:"��߼ӳɱ�",
		dataIndex:'MaxMargin',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxMarginField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 8);
					}
				}
			}
		})
	},{
		header:"��߼ӳɶ�",
		dataIndex:'MaxMPrice',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxMPriceField',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 9);
					}
				}
			}
		})
	},{
		header:"С������",
		//dataIndex:'SdDesc',
		dataIndex:'SdDr',
		width:80,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(SDComm,"SdDr","SdDesc"),
		editor:new Ext.grid.GridEditor(SDComm)
	},{
		header:"��������",
		//dataIndex:'MtDesc',
		dataIndex:'MtDr',
		width:80,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(MTComm,"MtDr","MtDesc"),
		editor:new Ext.grid.GridEditor(MTComm)
	},UFlag,{
		header:"��ע",
		dataIndex:'Remark',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'remarkField',
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
		})
	}
]);

//��ʼ��Ĭ��������
MarkRuleGridCm.defaultSortable = true;

var addMarkRule = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

function addNewRow() {
	var NewRecord = CreateRecordInstance(MarkRuleGridDs.fields);
	MarkRuleGridDs.add(NewRecord);
	MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 1);
}

var saveMarkRule = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()!=false){
			//��ȡ���е��¼�¼ 
			var mr=MarkRuleGridDs.getModifiedRecords();
			var data="";
			var rows="";
			for(var i=0;i<mr.length;i++){
				var rowid = mr[i].data["RowId"].trim();
				var code = mr[i].data["Code"].trim();
				var desc = mr[i].data["Desc"].trim();
				var minRp = mr[i].data["MinRp"];
				var maxRp = mr[i].data["MaxRp"];
				
				var margin = mr[i].data["Margin"];			//�ӳ���
				var mPrice = mr[i].data["MPrice"];			//�ӳɶ�
				var maxMargin = mr[i].data["MaxMargin"];	//��߼ӳ���
				var maxMPrice = mr[i].data["MaxMPrice"];	//��߼ӳɶ�	
				var sd = mr[i].data["SdDr"].trim();
				var mt = mr[i].data["MtDr"].trim();
				var rows=MarkRuleGridDs.indexOf(mr[i])+1;
				if(parseFloat(minRp)>parseFloat(maxRp) && parseFloat(maxRp)!=0){
					Msg.info("warning",'��'+rows+'�й������޲���С�ڹ������ޣ�'); 
					return;
				}
				if(margin!=""&&maxMargin!=""&&maxMargin!=0&&parseFloat(margin)>parseFloat(maxMargin)){
					Msg.info("warning",'��'+rows+'�мӳ��ʲ��ܴ�����߼ӳ��ʣ�');
					return;
				}
				if(mPrice!=""&&maxMPrice!=""&&maxMPrice!=0&&parseFloat(mPrice)>parseFloat(maxMPrice)){
					Msg.info("warning",'��'+rows+'�мӳɶ�ܴ�����߼ӳɶ');
					return;
				}
				if(code==""||desc==""){
					Msg.info("warning",'��'+rows+'�д�������Ʋ���Ϊ�գ�');
					return;
				}
				if(sd==""||mt==""){
					Msg.info("warning",'��'+rows+'��С������Ͷ������Ͳ���Ϊ�գ�');
					return;
				}
				var remark = mr[i].data["Remark"].trim();
				var useFlag = mr[i].data["UseFlag"];
				var dataRow = rowid+"^"+code+"^"+desc+"^"+maxRp+"^"+minRp
						+"^"+margin+"^"+mt+"^"+remark+"^"+useFlag+"^"+maxMPrice
						+"^"+maxMargin+"^"+mPrice+"^"+sd;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			
			if(data!=""){
				var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
					url: MarkRuleGridUrl+'?actiontype=save',
					params: {data:data},
					failure: function(result, request) {
						mask.hide();
						Msg.info("error","������������!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success","����ɹ�!");
							MarkRuleGridDs.reload();
						}else{
							Msg.info("error","����ʧ��,"+jsonData.info);
						}
					},
					scope: this
				});
			}
		}
	}
});

// �任����ɫ
function changeBgColor(row, color) {
	MarkRuleGrid.getView().getRow(row).style.backgroundColor = color;
}

function CheckDataBeforeSave(){
	//=====�жϴ���������Ƿ��ظ�����===
	var rowCount = MarkRuleGrid.getStore().getCount();
	for (i=0;i<rowCount-1;i++){
		for(j=i+1;j<rowCount;j++){
			var item_i=MarkRuleGridDs.getAt(i).get("Code");
			var item_j=MarkRuleGridDs.getAt(j).get("Code");
			var item_di=MarkRuleGridDs.getAt(i).get("Desc");
			var item_dj=MarkRuleGridDs.getAt(j).get("Desc");
			if(item_i!=""&&item_j!=""&&item_i==item_j){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","���������ظ�!");
				return false;
			}
			if(item_di!=""&&item_dj!=""&&item_di==item_dj){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","���������ظ�!");
				return false;
			}
		}
	}
}

var deleteMarkRule = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = MarkRuleGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var record = MarkRuleGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			//alert(RowId);
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:MarkRuleGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										MarkRuleGridDs.load();
									}else{
										Msg.info("error","ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Msg.info("error","�����д�!");
				var rowInd=cell[0];
				if (rowInd>=0) MarkRuleGrid.getStore().removeAt(rowInd);
			}
		}
	}
});

//���
MarkRuleGrid = new Ext.grid.EditorGridPanel({
	title : '���۹���',
	store:MarkRuleGridDs,
	cm:MarkRuleGridCm,
	trackMouseOver:true,
	height:350,
	stripeRows:true,
	plugins:UFlag,
	clicksToEdit:1,
	region:'north',
	sm:new Ext.grid.CellSelectionModel({
		listeners:{
			cellselect : function(sm,rowIndex,colIndex){
				var selectedRow = MarkRuleGridDs.data.items[rowIndex];
				mrId = selectedRow.data['RowId'];
				if(mrId==""){
					MarkRuleAddGridDs.removeAll();
					return;
				}
				MarkRuleAddGridDs.load({params:{parref:mrId}});
			}
		}
	}),
	loadMask:true,
	tbar:[addMarkRule,'-',saveMarkRule,'-',deleteMarkRule],
	bbar:[{
			xtype:'label',
			text:'�ۼ�=����*(1+�ӳ���)+�ӳɶ�; ����������:�����ۼ������ݵĽ������䷶Χ; ��߼ӳɱ�:�б��ڼӳ���,ָ��߼ӳɱ���; ���ޡ��ӳɶ��߼ӳɱȡ���߼ӳɶ�Ϊ0��ʾ������.'
		}
	]
});


var MarkRuleAddGrid="";
//��������Դ
var MarkRuleAddGridProxy= new Ext.data.HttpProxy({url:MarkRuleGridUrl+'?actiontype=selectChild',method:'GET'});
var MarkRuleAddGridDs = new Ext.data.Store({
	proxy:MarkRuleAddGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'MinRp'},
		{name:'MaxRp'},
		{name:'Margin'},
		{name:'UseFlag'},
		{name:'Remark'}
	]),
	pruneModifiedRecords : true,
	remoteSort:false
});

var UseFlag = new Ext.grid.CheckColumn({
	header:'�Ƿ�ʹ��',
	dataIndex:'UseFlag',
	width:100,
	sortable:true
});

//ģ��
var MarkRuleAddGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"����",
		dataIndex:'Code',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField1',
			allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 2);
					}
				}
			}
		})
	},{
		header:"����",
		dataIndex:'Desc',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'descField1',
			allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 3);
					}
				}
			}
		})
	},{
		header:"����",
		dataIndex:'MinRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'minRpField1',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 4);
					}
				}
			}
		})
	},{
		header:"����",
		dataIndex:'MaxRp',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'maxRpField1',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 5);
					}
				}
			}
		})
	},{
		header:"�ӳ���",
		dataIndex:'Margin',
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'marginField1',
			selectOnFocus:true,
			decimalPrecision:4,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 6);
					}
				}
			}
		})
	},{
		header:"��ע",
		dataIndex:'Remark',
		width:80,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'remarkField1',
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addRow();
					}
				}
			}
		})
	},UseFlag
]);

//��ʼ��Ĭ��������
MarkRuleGridCm.defaultSortable = true;

var addMarkRuleAdd = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(mrId==""){
			Msg.info("warning","����ѡ�񶨼۹���!");
			return;
		}
		addRow();
	}
});

function addRow() {
	var NewRec = CreateRecordInstance(MarkRuleAddGridDs.fields);
	MarkRuleAddGridDs.add(NewRec);
	MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 1);
}

var saveMarkRuleAdd = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave2()!=false){
			//��ȡ���е��¼�¼ 
			var mr=MarkRuleAddGridDs.getModifiedRecords();
			var data="";
			var row="";
			for(var i=0;i<mr.length;i++){
				var rowid = mr[i].data["RowId"].trim();
				var code = mr[i].data["Code"].trim();
				var desc = mr[i].data["Desc"].trim();
				var minRp = mr[i].data["MinRp"];
				var maxRp = mr[i].data["MaxRp"];
				var margin = mr[i].data["Margin"];
				var remark = mr[i].data["Remark"].trim();
				var useFlag = mr[i].data["UseFlag"];
				row=MarkRuleAddGridDs.indexOf(mr[i])+1;
				if(code==""){
					Msg.info('warning', '��'+row+'�д��벻��Ϊ�գ�'); 
					break;
				}else if(desc==""){
					Msg.info('warning', '��'+row+'�����Ʋ���Ϊ�գ�'); 
					break;
				}else if(parseFloat(minRp)>parseFloat(maxRp) && maxRp!==0){
					Msg.info('warning', '��'+row+'�����޲��ܸ������ޣ�'); 
					break;
				}
				
				var dataRow = rowid+"^"+mrId+"^"+code+"^"+desc+"^"+maxRp+"^"+minRp+"^"+margin+"^"+remark+"^"+useFlag;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			
			if(data!=""){
				var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
					url: MarkRuleGridUrl+'?actiontype=saveChild',
					params: {data:data},
					failure: function(result, request) {
						 mask.hide();
						Msg.info("error","������������!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success","����ɹ�!");
							MarkRuleAddGridDs.load({params:{parref:mrId}});
						}else{
							Msg.info("error","����ʧ��!");
						}
					},
					scope: this
				});
			}
		}
	}
});

function CheckDataBeforeSave2(){
	if(mrId==""){
		return false;
	}
	//=====�жϴ���������Ƿ��ظ�����===
	var rowCount = MarkRuleAddGrid.getStore().getCount();
	for (i=0;i<rowCount-1;i++){
		for(j=i+1;j<rowCount;j++){
			var item_i=MarkRuleAddGridDs.getAt(i).get("Code");
			var item_j=MarkRuleAddGridDs.getAt(j).get("Code");
			var item_di=MarkRuleAddGridDs.getAt(i).get("Desc");
			var item_dj=MarkRuleAddGridDs.getAt(j).get("Desc");
			if(item_i!=""&&item_j!=""&&item_i==item_j){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","���������ظ�!!!!");
				return false;
			}
			if(item_di!=""&&item_dj!=""&&item_di==item_dj){
				changeBgColor(i, "yellow");
				changeBgColor(j, "yellow");
				Msg.info("warning","���������ظ�!!!!");
				return false;
			}
		}
	}
}

var deleteMarkRuleAdd = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = MarkRuleAddGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var record = MarkRuleAddGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:MarkRuleGridUrl+'?actiontype=deleteChild&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										MarkRuleAddGridDs.load({params:{parref:mrId}});
									}else{
										Msg.info("error","ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				//Msg.info("error","�����д�!");
				var rowInd=cell[0];
				if (rowInd>=0) MarkRuleAddGrid.getStore().removeAt(rowInd);
				
			}
		}
	}
});

//���
MarkRuleAddGrid = new Ext.grid.EditorGridPanel({
	id : 'MarkRuleAddGrid',
	title : '���ݼӳ�',
	store:MarkRuleAddGridDs,
	cm:MarkRuleAddGridCm,
	trackMouseOver:true,
	height:350,
	stripeRows:true,
	plugins:UseFlag,
	region:'center',
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addMarkRuleAdd,'-',saveMarkRuleAdd,'-',deleteMarkRuleAdd],
	bbar:[{
			xtype:'label',
			text:'�ۼ�=����*(1+�ӳ���); ����������:�����ۼ������ݵĽ������䷶Χ; ����Ϊ0��ʾ������.'
		}
	],
	clicksToEdit:1
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[MarkRuleGrid,MarkRuleAddGrid],
		renderTo:'mainPanel'
	});
	MarkRuleGridDs.load();
});