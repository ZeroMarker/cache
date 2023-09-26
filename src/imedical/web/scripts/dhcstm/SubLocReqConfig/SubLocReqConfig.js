// ����:
// ��д����:2012-05-8
//=========================����ȫ�ֱ���===============================
var SubLocReqConfigId = "";
//=========================����ȫ�ֱ���===============================
//=========================��������רҵ��=====================================
var logonLoc=session['LOGON.CTLOCID'];
var logonUserId=session['LOGON.USERID'];
var load1=false;
var load2=false;

var userLoad=false;
var grpLoad=false;
var scgLoad1=false;
var scgLoad2=false;

var currLoc=logonLoc;
var currGrp="",currGrpDesc="";
var configType="";

function addNewLocReqConfig() {
	if (currGrp=='') {
		Msg.info('warning','�������ѡ��һ��רҵ��!');
		return;
	}
	
	var xrecord = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		},{
			name:'UserGrp',
			type:'string'
		},{
			name:'UserGrpDesc',
			type:'string'
		},{
			name : 'SCG',
			type : 'string'
		},{
			name : 'SCGDesc',
			type : 'string'
		},{
			name : 'reqAmt',
			type : 'string'
		},{
			name : 'inci',
			type : 'string'
		},{
			name : 'desc',
			type : 'string'			
		},{
			name : 'reqQty',
			type : 'string'
		},{
			name : 'reqUom',
			type : 'string'
		},{
			name : 'reqAmtOfThisMon',
			type : 'string'
		}
	]);
					
	var NewRecord = new xrecord({
		RowId:'',
		UserGrp:currGrp,
		UserGrpDesc:currGrpDesc,
		SCG:'',
		SCGDesc:'',
		inci:'',
		reqAmt:'',
		reqQty:'',
		reqUom:'',
		reqAmtOfThisMon:''	
	});
					
	SubLocReqConfigGridDs.add(NewRecord);
	if(configType==0){
		var col=GetColIndex(SubLocReqConfigGrid,'SCG');
	}else{
		var col=GetColIndex(SubLocReqConfigGrid,'desc');
	}
	SubLocReqConfigGrid.startEditing(SubLocReqConfigGridDs.getCount() - 1, col);
}


var SubLocUserGrpGridUrl = 'dhcstm.sublocusergroupaction.csp';
var SubLocUserGrpGridProxy= new Ext.data.HttpProxy({url:SubLocUserGrpGridUrl+'?actiontype=getLocGroupList',method:'GET'});
var SubLocUserGrpGridDs = new Ext.data.Store({
	proxy:SubLocUserGrpGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results'
    }, [
		{name:'RowId'},
		{name:'Code',mapping:'grpCode'},
		{name:'Description',mapping:'grpDesc'}
	]),
    remoteSort:false,
    listeners:{'load':function(ds){
    		var allRec=Ext.data.Record.create([
    		{name:'RowId'},
    		{name:'Code'},
    		{name:'Description'}
    		]);
    		var allRec=new allRec({
    			RowId:'',
    			Code:'All',
    			Description:'����רҵ��'
    		});
    		ds.add(allRec) ;
    		
    	}
    }
});

 
SubLocUserGrpGridDs.load({params:{
	start:0,
	limit:15,
	sort:'',
	dir:'',
	SubLoc:logonLoc
}});



//��������Դ
var SubLocReqConfigGridUrl = 'dhcstm.sublocreqconfigaction.csp';
var SubLocReqConfigGridProxy= new Ext.data.HttpProxy({url:SubLocReqConfigGridUrl+'?actiontype=getSubLocReqConfig',method:'GET'});
var SubLocReqConfigGridDs = new Ext.data.Store({
	baseParams:{subLoc:logonLoc,sort:'',dir:''},
	proxy:SubLocReqConfigGridProxy,
	reader:new Ext.data.JsonReader({
	    	totalProperty:'results',
	        root:'rows',
	        id:'RowId'
	},[{
			name:'RowId'
		},{
			name:'UserGrp',
			type:'string'
		},{
			name:'UserGrpDesc',
			type:'string'
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
			name : 'desc',
			type : 'string',
			mapping :'incidesc'
		},{
			name : 'reqQty',
			type : 'number'
		},{
			name : 'reqUom',
			type : 'string'
		},{
			name : 'reqUomDesc',
			type : 'string'
		},{
			name : 'reqAmtOfThisMon',
			type : 'number'
		},{
			name : 'reqQtyOfThisMon',
			type : 'number'
		}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

SubLocReqConfigGridDs.on('load',function(){load1=true;})


var SubLocUserGrpGridCm =new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"רҵ�����",
        dataIndex:'Code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"רҵ������",
        dataIndex:'Description',
        width:200,
        align:'left',
        sortable:true
    }
]);


var stkgrpgrid=new Ext.ux.StkGrpComboBox({
	id:'groupField',
	UserId:logonUserId,
	StkType:App_StkTypeCode,			
	LocId:logonLoc,
  	listeners:{
  		specialkey:function(field,e){
  			if(e.getKey()==e.ENTER){
  				var row=SubLocReqConfigGrid.getSelectionModel().getSelectedCell()[0];
  				var col=GetColIndex(SubLocReqConfigGrid,'reqAmt');
  				SubLocReqConfigGrid.startEditing(row,col);
  			}
  		}
  	}
});

 stkgrpgrid.getStore().on('load',function(){
 	scgLoad1=true;
 	//loadData1();
 });
 
 
 var LUG=new Ext.form.ComboBox({
 	id:'LUG',	
 	name:'LUG',
 	store:new Ext.data.Store({
 		url:'dhcstm.sublocusergroupaction.csp?actiontype=getLocGroupList&SubLoc='+logonLoc,
 		reader:new Ext.data.JsonReader({
 			totalProperty : "results",
			root : 'rows'
 		},[{name:'Description',mapping:'grpDesc'}, 'RowId']),
 		listeners:{'load':function(ds){
 			grpLoad=true;
 			//loadData1();
 		}
 		}
 	}),
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	valueNotFound:''
 });
 
 LUG.getStore().load();
 
var CTUom = new Ext.form.ComboBox({
		width : 120,
		store : ItmUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false,
		triggerAction : 'all',
		emptyText : '��λ...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 10,
		listWidth : 250,
		valueNotFoundText : '',
		listeners:{
			'beforequery':function(e){
				var cell = SubLocReqConfigGrid.getSelectionModel().getSelectedCell();
				var record = SubLocReqConfigGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("inci");
				ItmUomStore.removeAll();
				if ((IncRowid!='')&&(IncRowid!=null)){
					ItmUomStore.load({params:{ItmRowid:IncRowid}});		
				}		
			}
		}
	});
			
 //ģ��
 var SubLocReqConfigGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
	 	header:'רҵ��',
	 	dataIndex:'UserGrp',
	 	width:100,
	 	sortable:true,
	 	readOnly:true,
	 	align:'left',
	 	renderer:Ext.util.Format.comboRenderer2(LUG,"UserGrp","UserGrpDesc")
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
		header:'������������Ŀ',
		dataIndex:'desc',
		id:'desc',
		editor:new Ext.form.TextField({
			id:'inciField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER){
						GetPhaOrderWindow(Ext.getCmp('inciField').getValue(), "", App_StkTypeCode, "", "N", "0", "",getDrug);
					}
				}
			}
		})
	},{
	    	header:'inci',
	    	dataIndex:'inci',
	    	hidden:true,
	    	readOnly:true	
	},{
		header:'��������������',
		id:'reqQty',
		dataIndex:'reqQty',
		align:'right',
		editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						var row=SubLocReqConfigGrid.getSelectionModel().getSelectedCell()[0];
						var col=GetColIndex(SubLocReqConfigGrid,'reqAmt');
						SubLocReqConfigGrid.startEditing(row,col);
					}
				}
			}
		})
	},{
		header:'��λ',
		id:'reqUom',
		dataIndex:'reqUom',
		align:'left',
		editor:new Ext.grid.GridEditor(CTUom),
		renderer:Ext.util.Format.comboRenderer2(CTUom,"reqUom","reqUomDesc")
	},{
	    header:'����������',
	    dataIndex:'reqAmt',
	    id:'reqAmt',
	    align:'right',
	    editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						addNewLocReqConfig();
					}
				}
			}
	    })
	},{
 		header:'��ǰ�¶�����������',
 		id:'reqQtyOfThisMon',
		width:120,
		dataIndex:'reqQtyOfThisMon',
		align:'right',
		readOnly:true	   
	},{
		header:'��ǰ�¶���������',
		width:120,
		dataIndex:'reqAmtOfThisMon',
		id:'reqQtyOfThisMon',
		align:'right',
		readOnly:true		
	}
]);

	//ItmUomStore.removeAll();		
	//ItmUomStore.load({params:{ItmRowid:IncRowid}});
					
					
function getDrug(record)
{
	if (record == null || record == "") {
		return false;
	}
	//alert(record.get("InciDr"))
	var cell = SubLocReqConfigGrid.getSelectionModel().getSelectedCell();
	// ѡ����
	var row = cell[0];
	var rowData = SubLocReqConfigGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("desc",record.get("InciDesc"));
	addComboData(ItmUomStore,record.get("PuomDr"),record.get("PuomDesc"));
	rowData.set("reqUom",record.get("PuomDr"));
	var col=GetColIndex(SubLocReqConfigGrid,'reqQty');
	SubLocReqConfigGrid.startEditing(row,col);
}

//��ʼ��Ĭ��������
SubLocReqConfigGridCm.defaultSortable = true;

var addSubLocReqConfig = new Ext.Toolbar.Button({
	text:'����һ��',
    tooltip:'����һ��',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewLocReqConfig();
	}
});

var saveSubLocReqConfig = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if (currLoc=='') {return;}
		if(SubLocReqConfigGrid.activeEditor != null){
			SubLocReqConfigGrid.activeEditor.completeEdit();
		} 
		//��ȡ���е��¼�¼
		var configtype=Ext.getCmp("SubLocReqConfigPanel").getForm().findField('configtype').getGroupValue();
		
		var mr=SubLocReqConfigGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var RowId=mr[i].data["RowId"];
			var inci=mr[i].data["inci"];
			var reqAmt=mr[i].data["reqAmt"];
			var reqUom=mr[i].data["reqUom"];
			var reqQty=mr[i].data["reqQty"];
			var SCG=mr[i].data["SCG"];
			var grp=mr[i].data["UserGrp"];	
			
			var row=SubLocReqConfigGridDs.indexOf(mr[i])+1;
			if((SCG=="")&&(inci=="")){
				continue;
			}else if((SCG!="")&&(reqAmt==0)){
				Msg.info("warning","��"+row+"�������������Ϊ0!");
				return;
			}else if((inci!="")&&(reqAmt==0)&&(reqQty==0)){
				Msg.info("warning","��"+row+"�������������������������������ͬʱΪ0!");
				return;
			}else if(inci!="" && reqUom==""){
				Msg.info("warning","��"+row+"�е�λ����Ϊ��!");
				return;
			}
				 
			var dataRow = RowId +"^"+ SCG +"^"+ reqAmt +"^"+ inci +"^"+ reqQty
					+"^"+ reqUom +"^"+currLoc +"^"+ grp +"^"+ configtype;			
			//alert(dataRow);			
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		
		if(data==""){
			Msg.info("warning","û���޸Ļ����������!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: SubLocReqConfigGridUrl+'?actiontype=SaveLocReq',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","������������!");
					SubLocReqConfigGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						SubLocReqConfigGridDs.reload();
					}else if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
						SubLocReqConfigGridDs.reload();
					}else{
						Msg.info("error","����ʧ��!"+jsonData.info);
						SubLocReqConfigGridDs.reload();
					}
					SubLocReqConfigGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});

var deleteSubLocReqConfig = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocReqConfigGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ������!");
			return false;
		}else{
			var record = SubLocReqConfigGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:SubLocReqConfigGridUrl+'?actiontype=DelLocReq&RowId='+RowId,
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
										SubLocReqConfigGrid.store.removeAll();
										SubLocReqConfigGrid.getView().refresh();
										SubLocReqConfigGridDs.reload();
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
				SubLocReqConfigGridDs.remove(record);
				SubLocReqConfigGrid.getView().refresh();
			}
		}
    }
});

	var rowSm = new Ext.grid.RowSelectionModel({
		singleSelected:true,
		listeners:{
			'rowselect':function(sm,row,rec){
				var rowid=rec.get('RowId');
				var userGrp=rowid ;
				currGrp=rowid;
				currGrpDesc=rec.get('Description');
				var configtype=Ext.getCmp("SubLocReqConfigPanel").getForm().findField('configtype').getGroupValue();
				//����
//				SubLocReqConfigGridDs.setBaseParam('subLoc',logonLoc);
				SubLocReqConfigGridDs.setBaseParam('userGrp',userGrp);
				SubLocReqConfigGridDs.setBaseParam('configtype',configtype);
//				SubLocReqConfigGridDs.setBaseParam('sort','');
//				SubLocReqConfigGridDs.setBaseParam('dir','');
				SubLocReqConfigGridDs.load({params:{start:0,limit:ConfigPagingToolbar.pageSize}});
				
				if (currGrp==''){
					addSubLocReqConfig.setDisabled(true);
					setGridColumnEditable(SubLocReqConfigGrid,false);
				}else{
					addSubLocReqConfig.setDisabled(false);
					setGridColumnEditable(SubLocReqConfigGrid,true);
				}
			}
		}
	});

//���
SubLocUserGrpGrid = new Ext.grid.GridPanel({
	store:SubLocUserGrpGridDs,
	cm:SubLocUserGrpGridCm,
	trackMouseOver:true,
	height:600,
	sm:rowSm
});

var ConfigPagingToolbar = new Ext.PagingToolbar({
    store:SubLocReqConfigGridDs,
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
SubLocReqConfigGrid = new Ext.grid.EditorGridPanel({
	store:SubLocReqConfigGridDs,
	cm:SubLocReqConfigGridCm,
	trackMouseOver:true,
	height:600,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
   // tbar:[addSubLocReqConfig,'-',saveSubLocReqConfig,'-',deleteSubLocReqConfig],
	clicksToEdit:1,
	listeners:{
		beforeedit:function(e){
			if(e.field=='SCG' || e.field=='desc'){
				if(e.record.get('RowId')!=""){
					e.cancel=true;
				}
			}
		}
	}
});

//=========================��������רҵ���û�===================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.sublocreqconfigaction.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

function loadData1()
{
	if (load1) return;  //�Ѿ�����
	//
	
	if ((scgLoad1)&&(grpLoad)) {	
		SubLocReqConfigGrid.getStore().load({params:{subLoc:logonLoc,start:0,limit:30,sort:'',dir:''}});
		
	}
}

/*�����еĿɱ༭����*/
function setGridColumnEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('reqQty');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('reqUom');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('reqAmt');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('SCG');	        
	grid.getColumnModel().setEditable(colId,b);		
}

function setNotDisplayColumnOfSCG(b)
{
	var colId=SubLocReqConfigGrid.getColumnModel().getIndexById('desc');	
	SubLocReqConfigGrid.getColumnModel().setHidden(colId,b);
	var colId=SubLocReqConfigGrid.getColumnModel().getIndexById('reqQty');	
	SubLocReqConfigGrid.getColumnModel().setHidden(colId,b)	;
	var colId=SubLocReqConfigGrid.getColumnModel().getIndexById('reqUom');	
	SubLocReqConfigGrid.getColumnModel().setHidden(colId,b);	
	var colId=SubLocReqConfigGrid.getColumnModel().getIndexById('reqQtyOfThisMon');	
	SubLocReqConfigGrid.getColumnModel().setHidden(colId,b);		
}

function setNotDisplayColumnOfItm(b)
{
	var colId=SubLocReqConfigGrid.getColumnModel().getIndexById('SCG');	
	SubLocReqConfigGrid.getColumnModel().setHidden(colId,b);
}


//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	
	var SubLocUserGrpPanel = new Ext.Panel({
		title:'����רҵ��',
		activeTab: 0,
		region:'west',
		//height:200,
		width:400,
		//collapsible: true,
        split: true,
		minSize: 0,
        maxSize:600,
        layout:'fit',
		items:[SubLocUserGrpGrid]                                 
	});
	
	var chkConfigBySCG=new Ext.form.Radio({
		boxLabel:'������',
		name:'configtype',
		id:'configbyscg',
		inputValue:0,
		checked:true,
		listeners:{
			'check':function(chk,b){
				if (b==true) {
					configType=this.inputValue;
					setNotDisplayColumnOfItm(false);
					setNotDisplayColumnOfSCG(true);
					SubLocReqConfigGridDs.removeAll();
					
					var GrpRecord=SubLocUserGrpGrid.getSelectionModel().getSelected();
					if(GrpRecord==undefined || GrpRecord==null){
						return;
					}else{
						var userGrp=GrpRecord.get('RowId')
					}
					SubLocReqConfigGridDs.setBaseParam('userGrp',userGrp);
					SubLocReqConfigGridDs.setBaseParam('configtype',this.inputValue);
					SubLocReqConfigGridDs.load({params:{start:0,limit:ConfigPagingToolbar.pageSize}});
				}
			}
		}
	});
	
	var chkConfigByItm=new Ext.form.Radio({
		name:'configtype',
		boxLabel:'��Ʒ��',
		id:'configbyitm',
		inputValue:1,
		listeners:{
			'check':function(chk,b){
				if (b==true){
					configType=this.inputValue;
					setNotDisplayColumnOfItm(true);
					setNotDisplayColumnOfSCG(false);
					SubLocReqConfigGridDs.removeAll();
					
					var GrpRecord=SubLocUserGrpGrid.getSelectionModel().getSelected();
					if(GrpRecord==undefined || GrpRecord==null){
						return;
					}else{
						var userGrp=GrpRecord.get('RowId')
					}
					SubLocReqConfigGridDs.setBaseParam('userGrp',userGrp);
					SubLocReqConfigGridDs.setBaseParam('configtype',this.inputValue);
					SubLocReqConfigGridDs.load({params:{start:0,limit:ConfigPagingToolbar.pageSize}});
				}
			}
		}
	})
	
	var dd=new Ext.Panel({
		layout:'column',
		frame:true,
		items:[{columnWidth:'.1',items:chkConfigBySCG},
		{columnWidth:.1,items:chkConfigByItm}]
	})
	var SubLocReqConfigPanel = new Ext.form.FormPanel({
		id:'SubLocReqConfigPanel',
		title:'��������',
		activeTab: 0,
		region:'center',
		collapsible: true,
        split: true,
        tbar:[addSubLocReqConfig,'-',saveSubLocReqConfig,'-',deleteSubLocReqConfig],
		items:[dd,SubLocReqConfigGrid],
		bbar:ConfigPagingToolbar
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[SubLocUserGrpPanel,SubLocReqConfigPanel/*,SubLocUserReqConfigPanel*/],
		renderTo: 'mainPanel'
	});
	
	if ( chkConfigBySCG.getValue()==true) {
		chkConfigBySCG.fireEvent('check',chkConfigBySCG,true);
	}
	if ( chkConfigByItm.getValue()==true) {
		chkConfigByItm.fireEvent('check',chkConfigByItm,true);}
});
//===========ģ����ҳ��===============================================