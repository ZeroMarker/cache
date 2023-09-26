// ����: ���Ҷ����������
// ��д����: 20181226

var logonLoc=session['LOGON.CTLOCID'];
var logonUserId=session['LOGON.USERID'];
var CurrentLRLRowid="";
function getLoclimitamt(rowid){
	var Loclimitamt=tkMakeServerCall("web.DHCSTM.LocLimitAmt","GetLocLimitAmt",rowid);
	return Loclimitamt;
}
function addNewLocReqConfig() {
	var Cell = LocConfigGrid.getSelectionModel().getSelectedCell();
	if(Ext.isEmpty(Cell)){
		Msg.info('warning','�������ѡ��һ������!');
		return false; 
	}
	var record=LocConfigGrid.getStore().getAt(Cell[0]);
	var LRLrowid=record.get("LRLrowid");
	var LocReqAmt=record.get("LocReqAmt");
	var StartDate=record.get("StartDate");  
	var EndDate=record.get("EndDate");
	if(Ext.isEmpty(LRLrowid)||(StartDate=="")||(EndDate=="")||(Ext.isEmpty(LocReqAmt)||(LocReqAmt==0))){
		Msg.info('warning','���������ά������������!');
		return false; 
	}
	var DataRecord = CreateRecordInstance(ConfigGridDs.fields, "");
					
					
	ConfigGridDs.add(DataRecord);
	var configtab=ConfigTabPanel.getActiveTab().getId();
	var configType=0;
	if (configtab=="CatGridPanel"){
		configType=1;
	}else if (configtab=="InciGridPanel"){
		configType=2;
	}
	if(configType==0){
		var col=GetColIndex(ScgGrid,'SCG');
		ScgGrid.startEditing(ConfigGridDs.getCount() - 1, col);
	}else if (configType==1){
		var col=GetColIndex(CatGrid,'CatId');
		CatGrid.startEditing(ConfigGridDs.getCount() - 1, col);
	}else if (configType==2){
		var col=GetColIndex(InciGrid,'INCIDesc');
		InciGrid.startEditing(ConfigGridDs.getCount() - 1, col);
	}
	
}

//���Ҵ���
var locCode = new Ext.form.TextField({
		id: 'locCode',
		allowBlank: true,
		anchor: '90%',
		width: 70
});
//�������� 
var locName = new Ext.form.TextField({
		id: 'locName',
		allowBlank: true,
		anchor: '90%',
		width: 70
});
var LocConfigGridUrl = 'dhcstm.loclimitamtaction.csp';
var LocConfigGridProxy= new Ext.data.HttpProxy({url:LocConfigGridUrl+'?actiontype=AllLoc',method:'GET'});
var LocConfigGridDs = new Ext.data.Store({
	proxy:LocConfigGridProxy,
    pruneModifiedRecords:true,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results'
    }, [
		{name:'LocId'},
		{name:'LocCode'},
		{name:'LocDesc'}  ///,mapping:'grpCode'
		,'StartDate','EndDate','LocReqAmt','LocUsedAmt','LRLrowid','SumTypeId','SumTypeDesc'
	]),
    remoteSort:false,
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			var strFilter = Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
			store.setBaseParam('strFilter',strFilter);
		}
	}
});
//��������Դ
var ConfigGridUrl = 'dhcstm.loclimitamtaction.csp';
var ConfigGridProxy= new Ext.data.HttpProxy({url:ConfigGridUrl+'?actiontype=getLocLimitAmtConfig',method:'GET'});
var ConfigGridDs = new Ext.data.Store({
	baseParams:{sort:'',dir:''},
	proxy:ConfigGridProxy,
	reader:new Ext.data.JsonReader({
	    	totalProperty:'results',
	        root:'rows',
	        id:'RowId'
	},[{
			name:'RowId'
		},{
			name : 'SCG',
			type : 'string'
		},{
			name : 'SCGDesc',
			type : 'string'
		},{
			name : 'reqAmt',
			type : 'number'
		},{
			name : 'inci',
			type : 'string'
		},{
			name : 'INCIDesc',
			type : 'string'
		},{
			name : 'UsedAmt',
			type : 'number'
		},'CatId','CatDesc','Incicode','spec','Uomid','UomDesc','ReqQty','OnceReqQty','AddReqQty'
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

var stkgrpgrid=new Ext.ux.StkGrpComboBox({
	id:'groupField',
	UserId:logonUserId,
	StkType:App_StkTypeCode,			
	Rowid:logonLoc,
  	listeners:{
  		specialkey:function(field,e){
  			if(e.getKey()==e.ENTER){
  				var row=ScgGrid.getSelectionModel().getSelectedCell()[0];
  				var col=GetColIndex(ScgGrid,'reqAmt');
  				ScgGrid.startEditing(row,col);
  			}
  		},
  		select:function(cb){
			var ScgId=cb.getValue();
			var IfAllowDo=tkMakeServerCall("web.DHCSTM.LocLimitAmt","IfNearestScg",ScgId);
			if (IfAllowDo!=0)
			{
				Msg.info("warning","������ǵײ�����,����ѡ!");
				cb.setValue("");
				return false;
			}
		}
  	}
});
var INCStkCat=new Ext.ux.StkCatComboBox({
	id:'INCStkCat',
	allowBlank : false,
	filterName : 'Desc',
	StkType:"M"
})		
 // ����ģ��
 var ScgGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"RowId",
        dataIndex:'RowId',
        width:100,
        align:'left',
        hidden:true
    },{
		header:"��������",
		dataIndex:'SCG',
		id:'SCG',
		width:100,
		align:'left',
		sortable:true,
		editor: stkgrpgrid,
		renderer:Ext.util.Format.comboRenderer2(stkgrpgrid,"SCG","SCGDesc")
	},{
	    header:'������',
	    dataIndex:'reqAmt',
	    id:'reqAmt',
	    align:'right',
	    editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						var LocLimitAmt=getLoclimitamt(CurrentLRLRowid);
						var sumlimitamt=getConfigSumLimitAmt(ScgGrid);
						var diffAmt=sumlimitamt-LocLimitAmt;
						if (sumlimitamt>LocLimitAmt){
							Msg.info("warning","������������ƽ�������ά�������ƽ��:"+diffAmt);
							return false;
						}else{
							addNewLocReqConfig();
						}
					}
				}
			}
	    })
	},{
		header:'��ǰ������',
		width:120,
		dataIndex:'UsedAmt',
		id:'UsedAmt',
		align:'right',
		readOnly:true		
	}
]);
// ������ģ��
 var CatGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"RowId",
        dataIndex:'RowId',
        width:100,
        align:'left',
        hidden:true
    },{
		header:"������",
		dataIndex:'CatId',
		id:'CatId',
		width:100,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(INCStkCat,'CatId','CatDesc'),
		editor:INCStkCat
	},{
	    header:'������',
	    dataIndex:'reqAmt',
	    id:'reqAmt',
	    align:'right',
	    editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						var LocLimitAmt=getLoclimitamt(CurrentLRLRowid);
						var sumlimitamt=getConfigSumLimitAmt(CatGrid);
						var diffAmt=sumlimitamt-LocLimitAmt;
						if (Number(sumlimitamt)>Number(LocLimitAmt)){
							Msg.info("warning","��������������ƽ�������ά�������ƽ��:"+diffAmt);
							return false;
						}else{
							addNewLocReqConfig();
						}
					}
				}
			}
	    })
	},{
		header:'��ǰ������',
		width:120,
		dataIndex:'UsedAmt',
		id:'UsedAmt',
		align:'right',
		readOnly:true		
	}
]);
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
			"0", gHospId, getDrug, "", "",
			"", "", "", "", "Y",
			"", "N");
	}
}
// Ʒ��ģ��
 var InciGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
        width:100,
        align:'left',
        hidden:true
    },{
		header:'��������',
		dataIndex:'INCIDesc',
		id:'INCIDesc',
		editor:new Ext.grid.GridEditor(new Ext.form.TextField({
			allowBlank:false,
			id:'inciField',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER){
						GetPhaOrderWindow(Ext.getCmp('inciField').getValue(), "", App_StkTypeCode, "", "N", "0", "",getDrug);
					}
				}
			}
		})
		)
	},{
    	header:'���ʴ���',
    	dataIndex:'Incicode',
    	width: 100,
		align: 'left'	
	},{
    	header:'���',
    	dataIndex:'spec',
    	width: 100,
		align: 'left'	
	},{
    	header:'inci',
    	dataIndex:'inci',
    	hidden:false,
    	readOnly:true	
	},{
	    header:'������',
	    dataIndex:'reqAmt',
	    id:'reqAmt',
	    align:'right',
	    editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						var LocLimitAmt=getLoclimitamt(CurrentLRLRowid);
						var sumlimitamt=getConfigSumLimitAmt(InciGrid);
						var diffAmt=sumlimitamt-LocLimitAmt;
						if (sumlimitamt>LocLimitAmt){
							Msg.info("warning","��Ʒ�ֻ������ƽ�������ά�������ƽ��:"+diffAmt);
							return false;
						}else{
							addNewLocReqConfig();
						}
					}
				}
			}
	    })
	},{
		header:'��ǰ������',
		width:120,
		dataIndex:'UsedAmt',
		id:'UsedAmt',
		align:'right',
		readOnly:true		
	},{
    	header:'Uomid',
    	dataIndex:'Uomid',
    	width: 100,
        hidden:true	
	},{
    	header:'������λ',
    	dataIndex:'UomDesc',
    	width: 100,
		align: 'left'	
	},{
    	header:'����������',
    	dataIndex:'ReqQty',
    	width: 100,
		align: 'right',
	    editor:new Ext.form.NumberField()	
	},{
    	header:'������������',
    	dataIndex:'OnceReqQty',
    	width: 100,
		align: 'right',
	    editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						var cell = InciGrid.getSelectionModel().getSelectedCell();
						var record = InciGrid.getStore().getAt(cell[0]);
						var OnceReqQty=field.getValue();
						var ReqQty = record.ReqQty;
						if (OnceReqQty>ReqQty){
							Msg.info("warning","��������������������������");
							return false;
						}else{
							addNewLocReqConfig();
						}
					}
				}
			}
	    })	
	},{
    	header:'��������',
    	dataIndex:'AddReqQty',
    	width: 100,
		align: 'right'	
	}
]);					
function getDrug(records)
{
	records = [].concat(records);
	if (records == null || records == "") {
	return;
	}
	Ext.each(records,function(record,index,allItems){
		var inciDr = record.get("InciDr");
		var cell = InciGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var findIndex = ConfigGridDs.findExact('inci',inciDr);
		if(findIndex>=0){
			InciGrid.getView().getRow(findIndex).style.backgroundColor = "yellow";
			Msg.info("warning",record.get("InciDesc")+"�Ѵ����ڵ�"+(findIndex+1)+"��!");
			return false;
		}
		
		var rowData = ConfigGridDs.getAt(row);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("INCIDesc",record.get("InciDesc"));
		rowData.set("Incicode",record.get("InciCode"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("Uomid",record.get("BuomDr"));
		rowData.set("UomDesc",record.get("BuomDesc"));
		addNewLocReqConfig();
	})	
	
}

//��ʼ��Ĭ��������
ScgGridCm.defaultSortable = true;
CatGridCm.defaultSortable = true;
InciGridCm.defaultSortable = true;
var addConfig = new Ext.Toolbar.Button({
	text:'����һ��',
    tooltip:'����һ��',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewLocReqConfig();
	}
});
var SumTypeData=[['����','0'],['������','1'],['Ʒ��','2']];
var SumTypeStore=new Ext.data.SimpleStore({
		fields:['Description','Rowid'],
		data:SumTypeData
	});
var SumType=new Ext.form.ComboBox({
		id:'SumTypeBox',
		store:SumTypeStore,
		displayField:'Description',
		valueField:'Rowid',
		triggerAction:'all',
		mode: 'local', 
		anchor : '90%',
		emptyText:''
		
	});
var LocConfigGridCm =new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"LocId",
        dataIndex:'LocId',
        width:100,
        align:'left',
        hidden:true
    },{
        header:"���Ҵ���",
        dataIndex:'LocCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'LocDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"LRLrowid",
        dataIndex:'LRLrowid',
        width:100,
        align:'left',
        hidden:true
    },{
        header:"��ʼ����",
        dataIndex:'StartDate',  
        width:100,
        align:'left',
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true
		})
    },{
        header:"��ֹ����",
        dataIndex:'EndDate',
        width:100,
        align:'left',
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true
		})
    },{
	    header:'������',
	    dataIndex:'LocReqAmt',
	    id:'LocReqAmt',
	    align:'right',
	    editor:new Ext.form.NumberField({
		    allowNegative : false
		    })
	},{
		header:'��ǰ������',
		width:120,
		dataIndex:'LocUsedAmt',
		id:'LocUsedAmt',
		align:'right',
		readOnly:true		
	},{
		header:"���ܷ�ʽ",
		dataIndex:'SumTypeId',
		id:'SumTypeId',
		width:100,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(SumType,'SumTypeId','SumTypeDesc'),
		editor:SumType
	}
]);
var ScgPagingToolbar = new Ext.PagingToolbar({
    store:ConfigGridDs,
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});
// ������
ScgGrid = new Ext.grid.EditorGridPanel({
	id:'ScgGrid',
	store:ConfigGridDs,
	cm:ScgGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:ScgPagingToolbar
});
var CatPagingToolbar = new Ext.PagingToolbar({
    store:ConfigGridDs,
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});
// ��������
CatGrid = new Ext.grid.EditorGridPanel({
	id:'CatGrid',
	store:ConfigGridDs,
	cm:CatGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:CatPagingToolbar
});
var InciPagingToolbar = new Ext.PagingToolbar({
    store:ConfigGridDs,
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});
// Ʒ�ֱ��
InciGrid = new Ext.grid.EditorGridPanel({
	id:'InciGrid',
	store:ConfigGridDs,
	cm:InciGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InciPagingToolbar
});
// ���ұ��
LocConfigGrid = new Ext.grid.EditorGridPanel({
	id:'LocConfigGrid',
	store:LocConfigGridDs,
	cm:LocConfigGridCm,
	trackMouseOver:true,
	stripeRows:true,
	loadMask:true,
	clicksToEdit:1,
	sm:new Ext.grid.CellSelectionModel({})
});
LocConfigGrid.addListener('rowclick',function(grid,rowindex,e){
		ConfigTabPanel.fireEvent('tabchange',ConfigTabPanel,ConfigTabPanel.getActiveTab());
	});
var saveConfig = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		var Cell = LocConfigGrid.getSelectionModel().getSelectedCell();
		if(Ext.isEmpty(Cell)){
			Msg.info('warning','�������ѡ��һ������!');
			return false; 
		}
		var record=LocConfigGrid.getStore().getAt(Cell[0]);
		var LRLrowid=record.get("LRLrowid");
		var LocReqAmt=record.get("LocReqAmt");
		var StartDate=record.get("StartDate");  
		var EndDate=record.get("EndDate");
		if(Ext.isEmpty(LRLrowid)||(StartDate=="")||(EndDate=="")||(Ext.isEmpty(LocReqAmt)||(LocReqAmt==0))){
			Msg.info('warning','���������ά������������!');
			return false; 
		}
		var grid=ScgGrid;
		var configtab=ConfigTabPanel.getActiveTab().getId();
		var configtype=0;
		if (configtab=="CatGridPanel"){
			configtype=1;
			grid=CatGrid;
		}else if (configtab=="InciGridPanel"){
			configtype=2;
			grid=InciGrid;
		}
		if(grid.activeEditor != null){
			grid.activeEditor.completeEdit();
		}
		
		var mr=ConfigGridDs.getModifiedRecords();
		var data="",RowId="",SCG="",CatId="",reqAmt="",inci="",Uomid="",OnceReqQty=0,ReqQty=0;
		for(var i=0;i<mr.length;i++){ 
			var RowId=mr[i].data["RowId"];
			var reqAmt=mr[i].data["reqAmt"];
			var row=ConfigGridDs.indexOf(mr[i])+1;
			if (configtype==0){
				var SCG=mr[i].data["SCG"];
				if(SCG==""){
					continue;
				}else if((SCG!="")&&(reqAmt==0)){
					Msg.info("warning","��"+row+"�������������Ϊ0!");
					return;
				}
			}
			if (configtype==1){
				var CatId=mr[i].data["CatId"];
				if(CatId==""){
					continue;
				}else if((CatId!="")&&(reqAmt==0)){
					Msg.info("warning","��"+row+"�������������Ϊ0!");
					return;
				}
			}
			if (configtype==2){
				var inci=mr[i].data["inci"];
				var Uomid=mr[i].data["Uomid"];  
				var OnceReqQty=mr[i].data["OnceReqQty"];
				var ReqQty=mr[i].data["ReqQty"];
				
				if(inci==""){
					continue;
				}else if((inci!="")&&(reqAmt==0)){
					Msg.info("warning","��"+row+"�������������Ϊ0!");
					return;
				}
			}
							 
			var dataRow = LRLrowid+"^"+RowId +"^"+ SCG +"^"+ CatId +"^"+ reqAmt +"^"+ inci +"^"+ configtype +"^"+ Uomid +"^"+ OnceReqQty  +"^"+ ReqQty;			
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		var LocLimitAmt=getLoclimitamt(LRLrowid);
		var sumlimitamt=getConfigSumLimitAmt(grid);
		var diffAmt=sumlimitamt-LocLimitAmt;
		if (Number(sumlimitamt)>Number(LocLimitAmt)){
			Msg.info("warning","�������ƽ�������ά�������ƽ��:"+diffAmt);
			return false;
		}
		if(data==""){
			Msg.info("warning","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: ConfigGridUrl+'?actiontype=SaveLocLimitAmt',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
					ConfigGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						ConfigGridDs.reload();
					}else if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
						ConfigGridDs.reload();
					}else{
						Msg.info("error","����ʧ��!"+jsonData.info);
						ConfigGridDs.reload();
					}
					ConfigGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});
var deleteConfig = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var configtab=ConfigTabPanel.getActiveTab().getId();
		var configtype=0;
		if (configtab=="CatGridPanel"){
			configtype=1;
		}else if (configtab=="InciGridPanel"){
			configtype=2;
		}
		var grid=ScgGrid;
		if (configtype==1){grid=CatGrid;}
		else if (configtype==2){grid=InciGrid;}
		var cell = grid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var record = ConfigGridDs.getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:ConfigGridUrl+'?actiontype=DelLocReq&RowId='+RowId,
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
										grid.store.removeAll();
										grid.getView().refresh();
										ConfigGridDs.reload();
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
				ConfigGridDs.remove(record);
				grid.getView().refresh();
			}
		}
    }
});

var queryCTLoc = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			LocConfigGridDs.load({
				params: {
					start: 0,
					limit: 9999,
					sort: 'Rowid',
					dir: 'desc'
				}
			});
		}
	});
var ControlTypeData=[['���','0'],['����','1'],['�¶�','2']];
var ControlTypeStore=new Ext.data.SimpleStore({
		fields:['Description','Rowid'],
		data:ControlTypeData
	});
var ControlTypeBox=new Ext.form.ComboBox({
		fieldLabel:'���Ʒ�ʽ',
		id:'ControlTypeBox',
		store:ControlTypeStore,
		displayField:'Description',
		valueField:'Rowid',
		triggerAction:'all',
		mode: 'local', 
		anchor : '90%',
		emptyText:''
		
	});
// ���ڴ���
/**
* ��ȡ���켸���º��ж�����
*/
function getDays(n){
	var Days=0;
	var Nowdate=new Date();
	var currentMonDays=Number(Nowdate.format("Y-m-d").split("-")[2]);
	var CurrentMonthDays=Nowdate.getDaysInMonth();
	var currentMonth=Nowdate.getMonth()+1;  ///��ȡ��ǰ��
	var nextMonth=++currentMonth;
	Days=CurrentMonthDays-currentMonDays;
	for (var i=0;i<n-1;i++){
		var nextAndnextMonthFirstDay=new Date(Nowdate.getFullYear(),nextMonth,1);
		var oneDay=1000*60*60*24;
		var nextDays=(new Date(nextAndnextMonthFirstDay-oneDay)).getDaysInMonth();
		Days=Days+nextDays;
		nextMonth=nextAndnextMonthFirstDay.getMonth()+1;
	}
	return Days;
}
/**
* ��ȡ���켸���º��·����һ��
*/
function getMonsLastDay(n){
	var MonsLastDay="";
	var Nowdate=new Date();
	var currentMonth=Nowdate.getMonth()+1;  ///��ȡ��ǰ��
	var nextMonth=++currentMonth;
	var currentYear=Nowdate.getFullYear();
	for (var i=0;i<n;i++){
		if (nextMonth==12){
			currentYear=currentYear+1;
		}
		var nextAndnextMonthFirstDay=new Date(currentYear,nextMonth,1);
		var oneDay=1000*60*60*24;
		if (nextMonth==12){
			nextAndnextMonthFirstDay=new Date(currentYear+"-01-01");
		}
		MonsLastDay=new Date(nextAndnextMonthFirstDay-oneDay);
		nextMonth=nextAndnextMonthFirstDay.getMonth()+1;
		if (nextMonth==13){
			nextMonth=1;
		}
	}
	return MonsLastDay;
}
var saveDateConfig = new Ext.Toolbar.Button({
	text:'���·�ʽ',
    tooltip:'<font color=red>���ݷ�ʽ��������,����������Ϊ��</font>',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		var rowcount=LocConfigGrid.getStore().getCount();
		var controltype=Ext.getCmp("ControlTypeBox").getValue();
		var StartDate=new Date().getFirstDateOfMonth();
		var EndDate="";
		var days=0;
		if (controltype==0){
			EndDate=getMonsLastDay(12);
		}else if (controltype==1){
			EndDate=getMonsLastDay(3);
		}else if (controltype==2){
			EndDate=new Date().getLastDateOfMonth();
		}
		//var rowcount=2;
		if (controltype==""){
			var StartDate=""
			var EndDate="";
		}
		var LocStr="";
		for(var i=0;i<rowcount;i++){ 
			var Rowdata=LocConfigGrid.getStore().getAt(i);
			Rowdata.set("StartDate",StartDate);
			Rowdata.set("EndDate",EndDate);
			var Locid=Rowdata.get("LocId");
			if (LocStr==""){
				LocStr=Locid;
			}else{
				LocStr=LocStr+"^"+Locid;
			}
		}
		if (LocStr==""){
			Msg.info("warning","û����Ҫ����Ŀ���!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url:ConfigGridUrl+"?actiontype=ClearUsedAmtQty",
				params:{LocStr:LocStr},
				failure:function(result,request){
					mask.hide();
					Msg.info("error","������������!");
					/// ConfigGridDs
				},
				success:function(result, request) {
					mask.hide();
					var jsoninfo=Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						Msg.info("success","�ϸ�ʱ������ö������ɹ�!");
						ConfigGridDs.reload();
					}else{
						Msg.info("error","���ö������ʧ��!");
						ConfigGridDs.reload();
					}
				},
				scope:this
			});
		}
    }
});
var saveLocConfig = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'<font color=red>����������</font>',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(LocConfigGrid.activeEditor != null){
			LocConfigGrid.activeEditor.completeEdit();
		}
		var mr=LocConfigGrid.getStore().getModifiedRecords();
		var dataStr="";
		for(var i=0;i<mr.length;i++){ 
			var LocId=mr[i].data["LocId"];
			var LocDesc=mr[i].data["LocDesc"];
			var LocReqAmt=mr[i].data["LocReqAmt"];
			var LRLrowid=mr[i].data["LRLrowid"];
			var StartDate=mr[i].data["StartDate"];
			var StartDate =Ext.util.Format.date(StartDate,ARG_DATEFORMAT);
			var EndDate=mr[i].data["EndDate"];
			var EndDate =Ext.util.Format.date(EndDate,ARG_DATEFORMAT);
			var SumTypeId=mr[i].data["SumTypeId"];
			var row=ConfigGridDs.indexOf(mr[i])+1;
			if((LRLrowid=="")&&((LocReqAmt=="")||(LocReqAmt==0))){
				Msg.info("warning","��Ϊ"+LocDesc+"��д������!");
				continue;
			}
			if((LRLrowid=="")&&((StartDate=="")||(EndDate==""))){
				Msg.info("warning","��Ϊ"+LocDesc+"ѡ��ʼ���ںͽ�ֹ����!");
				continue;
			}
			if (SumTypeId==""){
				Msg.info("warning","��Ϊ"+LocDesc+"ѡ����ܷ�ʽ!");
				continue;
			}
			var dataRow = LocId+"^"+LRLrowid +"^"+ LocReqAmt +"^"+ StartDate +"^"+ EndDate +"^"+ SumTypeId;			
			if(dataStr==""){
				dataStr = dataRow;
			}else{
				dataStr = dataStr+xRowDelim()+dataRow;
			}
		}
		if(dataStr==""){
			Msg.info("warning","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: ConfigGridUrl+'?actiontype=SaveLocLimitAmtsum',
				params: {dataStr:dataStr},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error","������������!");
					LocConfigGridDs.commitChanges();
				},
				success: function(result, request) {
					mask.hide();
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						LocConfigGridDs.reload();
					}else if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
						LocConfigGridDs.reload();
					}else{
						Msg.info("error","����ʧ��!"+jsonData.info);
						LocConfigGridDs.reload();
					}
					LocConfigGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});
var LocPanel = new Ext.Panel({
	title:'����',
	activeTab: 0,
	region:'west',
	width:700,
    split: true,
	minSize: 0,
    maxSize:600,
    layout:'fit',
    tbar:[saveLocConfig,'-',ControlTypeBox,'-',saveDateConfig,'-','���Ҵ���',locCode,'-','��������',locName,'-',queryCTLoc],
	items:[LocConfigGrid]                                 
});	
var ScgGridPanel = new Ext.Panel({
	title : '������',
	id : 'ScgGridPanel',
	layout:'fit',
	items : ScgGrid
});

var CatGridPanel = new Ext.Panel({
	title : '��������',
	id : 'CatGridPanel',
	layout:'fit',
	items : CatGrid
});

var InciGridPanel = new Ext.Panel({
	title : '��Ʒ��',
	id : 'InciGridPanel',
	layout:'fit',
	items : InciGrid
});
var ConfigTabPanel = new Ext.TabPanel({
	region: 'center',
	activeTab : 0,
	deferredRender : true,
	items : [ScgGridPanel,CatGridPanel,InciGridPanel],
	listeners : {
		tabchange : function(tabpanel,panel){
			var cell = LocConfigGrid.getSelectionModel().getSelectedCell();
			if(Ext.isEmpty(cell)){
				return false; 
			}
			var LocRec = LocConfigGrid.getStore().getAt(cell[0]);
			var LRLrowid=LocRec.get('LRLrowid');
			CurrentLRLRowid=LRLrowid;
			if(panel.id == 'ScgGridPanel'){
				ConfigGridDs.removeAll();
				ConfigGridDs.load({params:{start:0,limit:ScgPagingToolbar.pageSize,sort:'Rowid',dir:'Desc',LRLrowid:CurrentLRLRowid,configtype:0}});
			}else if(panel.id == 'CatGridPanel'){
				ConfigGridDs.removeAll();
				ConfigGridDs.load({params:{start:0,limit:CatPagingToolbar.pageSize,sort:'Rowid',dir:'Desc',LRLrowid:CurrentLRLRowid,configtype:1}});
			}else if(panel.id == 'InciGridPanel'){
				ConfigGridDs.removeAll();
				ConfigGridDs.load({params:{start:0,limit:InciPagingToolbar.pageSize,sort:'Rowid',dir:'Desc',LRLrowid:CurrentLRLRowid,configtype:2}});
			}
		}
	}
});
var DetailConfigPanel = new Ext.form.FormPanel({
	id:'DetailConfigPanel',
	title:'�޶�����',
	activeTab: 0,
	region:'center',
	collapsible: true,
    split: true,
    height:600,
    tbar:[addConfig,'-',saveConfig,'-',deleteConfig],
    layout:'fit',
	items:[ConfigTabPanel]
});
function getConfigSumLimitAmt(grid){
	var Sumlimitamt=0;
	var RowCount=grid.getStore().getCount();
	for (var i=0;i<RowCount;i++){
		var rec=grid.getStore().getAt(i);
		var tmpamt=rec.get("reqAmt");
		if (Sumlimitamt==0){
			Sumlimitamt=tmpamt;
		}else{
			Sumlimitamt=Sumlimitamt+tmpamt;
		}
	}
	return Sumlimitamt;
}
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[LocPanel,DetailConfigPanel],
		renderTo: 'mainPanel'
	});
	queryCTLoc.handler();
});
//===========ģ����ҳ��===============================================