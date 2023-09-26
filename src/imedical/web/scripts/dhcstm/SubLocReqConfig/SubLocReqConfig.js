// 名称:
// 编写日期:2012-05-8
//=========================定义全局变量===============================
var SubLocReqConfigId = "";
//=========================定义全局变量===============================
//=========================二级科室专业组=====================================
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
		Msg.info('warning','请在左边选择一个专业组!');
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
    			Description:'所有专业组'
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



//配置数据源
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
        header:"专业组代码",
        dataIndex:'Code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"专业组名称",
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
		emptyText : '单位...',
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
			
 //模型
 var SubLocReqConfigGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
	 	header:'专业组',
	 	dataIndex:'UserGrp',
	 	width:100,
	 	sortable:true,
	 	readOnly:true,
	 	align:'left',
	 	renderer:Ext.util.Format.comboRenderer2(LUG,"UserGrp","UserGrpDesc")
	},{
		header:"物资类组",
		dataIndex:'SCG',
		id:'SCG',
		width:100,
		align:'left',
		sortable:true,
		editor: stkgrpgrid,
		renderer:Ext.util.Format.comboRenderer2(stkgrpgrid,"SCG","SCGDesc")
	},{
		header:'限制请领库存项目',
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
		header:'限制请领总数量',
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
		header:'单位',
		id:'reqUom',
		dataIndex:'reqUom',
		align:'left',
		editor:new Ext.grid.GridEditor(CTUom),
		renderer:Ext.util.Format.comboRenderer2(CTUom,"reqUom","reqUomDesc")
	},{
	    header:'限制请领金额',
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
 		header:'当前月度已请领数量',
 		id:'reqQtyOfThisMon',
		width:120,
		dataIndex:'reqQtyOfThisMon',
		align:'right',
		readOnly:true	   
	},{
		header:'当前月度已请领金额',
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
	// 选中行
	var row = cell[0];
	var rowData = SubLocReqConfigGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("desc",record.get("InciDesc"));
	addComboData(ItmUomStore,record.get("PuomDr"),record.get("PuomDesc"));
	rowData.set("reqUom",record.get("PuomDr"));
	var col=GetColIndex(SubLocReqConfigGrid,'reqQty');
	SubLocReqConfigGrid.startEditing(row,col);
}

//初始化默认排序功能
SubLocReqConfigGridCm.defaultSortable = true;

var addSubLocReqConfig = new Ext.Toolbar.Button({
	text:'增加一条',
    tooltip:'增加一条',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewLocReqConfig();
	}
});

var saveSubLocReqConfig = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if (currLoc=='') {return;}
		if(SubLocReqConfigGrid.activeEditor != null){
			SubLocReqConfigGrid.activeEditor.completeEdit();
		} 
		//获取所有的新记录
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
				Msg.info("warning","第"+row+"行限制请领金额不可为0!");
				return;
			}else if((inci!="")&&(reqAmt==0)&&(reqQty==0)){
				Msg.info("warning","第"+row+"行限制请领金额和限制请领总数量不可同时为0!");
				return;
			}else if(inci!="" && reqUom==""){
				Msg.info("warning","第"+row+"行单位不可为空!");
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
			Msg.info("warning","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: SubLocReqConfigGridUrl+'?actiontype=SaveLocReq',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
					SubLocReqConfigGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						SubLocReqConfigGridDs.reload();
					}else if(jsonData.info==-11){
						Msg.info("error","数据重复!");
						SubLocReqConfigGridDs.reload();
					}else{
						Msg.info("error","保存失败!"+jsonData.info);
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
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocReqConfigGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = SubLocReqConfigGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:SubLocReqConfigGridUrl+'?actiontype=DelLocReq&RowId='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										SubLocReqConfigGrid.store.removeAll();
										SubLocReqConfigGrid.getView().refresh();
										SubLocReqConfigGridDs.reload();
									}else{
										Msg.info("error","删除失败!");
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
				//检索
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

//表格
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
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
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

//=========================二级科室专业组用户===================================
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
	if (load1) return;  //已经检索
	//
	
	if ((scgLoad1)&&(grpLoad)) {	
		SubLocReqConfigGrid.getStore().load({params:{subLoc:logonLoc,start:0,limit:30,sort:'',dir:''}});
		
	}
}

/*控制列的可编辑属性*/
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


//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	
	var SubLocUserGrpPanel = new Ext.Panel({
		title:'科室专业组',
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
		boxLabel:'按类组',
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
		boxLabel:'按品种',
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
		title:'请领设置',
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
//===========模块主页面===============================================