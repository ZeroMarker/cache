// 名称:科室人员请领设置
// 编写日期:2012-05-8
//=========================定义全局变量===============================
var SubLocReqConfigId = "";
//=========================定义全局变量===============================
//=========================二级科室=====================================
var logonLoc=session['LOGON.CTLOCID'];
var logonUserId=session['LOGON.USERID'];
var currLoc=logonLoc;

var stkgrpgrid2=new Ext.ux.StkGrpComboBox({
	id:'groupField2',
	UserId:logonUserId,
	StkType:App_StkTypeCode,			
	LocId:logonLoc,
	listeners:{
		specialkey:function(field,e){
			if(e.getKey()==e.ENTER){
				var row=SubLocUserReqConfigGrid.getSelectionModel().getSelectedCell()[0];
				var col=GetColIndex(SubLocUserReqConfigGrid,'reqAmt');
				SubLocUserReqConfigGrid.startEditing(row,col);
			}
		}
	}
});

function getDrug2(record)
{
	if (record == null || record == "") {
		return false;
	}
	//alert(record.get("InciDr"))
	var cell = SubLocUserReqConfigGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
	var rowData = SubLocUserReqConfigGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("desc",record.get("InciDesc"));
	addComboData(ItmUomStore,record.get('PuomDr'),record.get('PuomDesc'));
	rowData.set('reqUom',record.get('PuomDr'));
	var col=GetColIndex(SubLocUserReqConfigGrid,'reqAmt');
	SubLocUserReqConfigGrid.startEditing(row,col);
}


//=========================二级科室用户===================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.sublocreqconfigaction.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
function addNewLocUserReqConfig() {
	var NewRecord = CreateRecordInstance(SubLocUserReqConfigGridDs.fields);
	SubLocUserReqConfigGridDs.add(NewRecord);
	SubLocUserReqConfigGrid.startEditing(SubLocUserReqConfigGridDs.getCount() - 1, 1);
}

//配置数据源
var SubLocUserReqConfigGridUrl = 'dhcstm.sublocreqconfigaction.csp';
var SubLocUserReqConfigGridProxy= new Ext.data.HttpProxy({url:SubLocUserReqConfigGridUrl+"?actiontype=getSubLocUserReqConfig",method:'GET'});
var SubLocUserReqConfigGridDs = new Ext.data.Store({
	proxy:SubLocUserReqConfigGridProxy,
    reader:new Ext.data.JsonReader({
    	totalProperty:'results',
        root:'rows',
        id:'RowId'
    }, [
  		'RowId','SCG','ScgDesc',{name:'user',mapping:'xuser'},'userName','reqAmt',
		'inci',{name:'desc',mapping :'incidesc'},
		'reqQty','reqUom','reqUomDesc','reqAmtOfThisMonth','reqQtyOfThisMonth'
	]),
    remoteSort:true,
    pruneModifiedRecords:true,
    baseParams:{subLoc:logonLoc,sort:'',dir:''},
    listeners:{
    	beforeload:function(store,options){
	    	var configType=Ext.getCmp("configPanel").getForm().findField('configtype').getGroupValue();
	    	this.setBaseParam('configType',configType);
    	}
    }
});

var UCG = new Ext.ux.ComboBox({
	fieldLabel : '名称',
	id : 'UCG',
	anchor : '90%',
	store : UStore,
	valueParams : {locId : logonLoc},
	filterName : 'name',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var configType=configPanel.getForm().findField('configtype').getGroupValue();
				var row=SubLocUserReqConfigGrid.getSelectionModel().getSelectedCell()[0];
				if(configType==0){
					//按类组
					var col=GetColIndex(SubLocUserReqConfigGrid,'SCG');
				}else{
					var col=GetColIndex(SubLocUserReqConfigGrid,'desc');
				}
				SubLocUserReqConfigGrid.startEditing(row,col);
			}
		}
	}
});	

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
				var cell = SubLocUserReqConfigGrid.getSelectionModel().getSelectedCell();
				var record = SubLocUserReqConfigGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("inci");
				this.store.removeAll();
				if ((IncRowid!='')&&(IncRowid!=null)){
					ItmUomStore.load({params:{ItmRowid:IncRowid}});		
				}		
			}
		}
	});

//模型
var SubLocUserReqConfigGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
    {
 	    header:'请领人',
	    dataIndex:'user',
	    align:'left',
	    renderer:Ext.util.Format.comboRenderer2(UCG,"user","userName"),
		editor:new Ext.grid.GridEditor(UCG)
    },{
        header:"物资类组",
        dataIndex:'SCG',
        id:'SCG',
        width:100,
        align:'left',
        sortable:true,
		editor: stkgrpgrid2,
		renderer:Ext.util.Format.comboRenderer2(stkgrpgrid2,"SCG","ScgDesc")		
    },{
    	header:'inci',
    	dataIndex:'inci',
    	hidden:true,
    	readOnly:true	
	},{
    	header:'限制请领项目',
    	dataIndex:'desc',
    	id:'desc',
    	//renderer:
    	editor:new Ext.form.TextField({
			//id:'inciField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//var stkGrp=Ext.getCmp("groupField2").getValue();
						GetPhaOrderWindow(field.getValue(), "", App_StkTypeCode, "", "N", "0", "",getDrug2);
					}
				}
			}
        })
    },{
	    header:'限制请领金额',
	    id:'reqAmt',
	    dataIndex:'reqAmt',
	    align:'right',
	    editor:new Ext.form.NumberField({
	    	listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						var configType=configPanel.getForm().findField('configtype').getGroupValue();
						if(configType==0){
							addNewLocUserReqConfig();
						}else{
							var row=SubLocUserReqConfigGrid.getSelectionModel().getSelectedCell()[0];
							var col=GetColIndex(SubLocUserReqConfigGrid,'reqQty');
							SubLocUserReqConfigGrid.startEditing(row,col);
						}
					}
				}
	    	}
	  	})
	},{
		header:'限制请领总数量',
		id:'reqQty',
		dataIndex:'reqQty',
		align:'right',
		editor:new Ext.form.NumberField({
			listeners:{
				specialkey:function(field,e){
					if(e.getKey()==e.ENTER){
						addNewLocUserReqConfig();
					}
				}
			}
		})
    },{
		header:'单位',
		dataIndex:'reqUom',
		id:'reqUom',
		align:'left',
		editor:new Ext.grid.GridEditor(CTUom),			
		renderer:Ext.util.Format.comboRenderer2(CTUom,"reqUom","reqUomDesc") 
    },{
		header:'当前月度已领用数量',
		id:'reqQtyOfThisMonth',
		dataIndex:'reqQtyOfThisMonth',
		align:'right',
		readOnly:true,
		width:150
    },{
		header:'当前月度已领用金额',
		dataIndex:'reqAmtOfThisMonth',
		id:'reqAmtOfThisMonth',
		align:'right',
		readOnly:true,
		width:150
    } 
]);

//初始化默认排序功能
SubLocUserReqConfigGridCm.defaultSortable = true;


	var chkConfigBySCG=new Ext.form.Radio({
		boxLabel:'按类组',
		name:'configtype',
		id:'configbyscg',
		inputValue:0,
		checked:true,
		listeners:{
			'check':function(chk,b){
				if (b==true) {
					setNotDisplayColumnOfItm(false);
					setNotDisplayColumnOfSCG(true);
					SubLocUserReqConfigGridDs.removeAll();
					SubLocUserReqConfigGridDs.load({params:{start:0,limit:ConfigPagingToolBar.pageSize}});
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
					setNotDisplayColumnOfItm(true);
					setNotDisplayColumnOfSCG(false);
					SubLocUserReqConfigGridDs.removeAll();
					SubLocUserReqConfigGridDs.load({params:{start:0,limit:ConfigPagingToolBar.pageSize}});
				}
			}
		}
	});
	
	var configPanel=new Ext.form.FormPanel({
		id:'configPanel',
		layout:'column',
		frame:true,
		items:[{columnWidth:'.1',items:chkConfigBySCG},
		{columnWidth:.1,items:chkConfigByItm}]
	})
	
var addSubLocUserReqConfig = new Ext.Toolbar.Button({
	text:'增加一条',
    tooltip:'增加一条',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewLocUserReqConfig();
	}
});

var saveSubLocUserReqConfig = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(SubLocUserReqConfigGrid.activeEditor != null){
			SubLocUserReqConfigGrid.activeEditor.completeEdit();
		} 
		if (currLoc=='') {return;}
		var configtype=Ext.getCmp("configPanel").getForm().findField('configtype').getGroupValue();
		//获取所有的新记录 
		var mr=SubLocUserReqConfigGridDs.getModifiedRecords();
		var data="";
		for (var i=0;i<mr.length;i++){ 
			var RowId=mr[i].data["RowId"];
			var inci=mr[i].data["inci"];
			var reqAmt=mr[i].data["reqAmt"];
			var reqUom=mr[i].data["reqUom"];
			var reqQty=mr[i].data["reqQty"];
			var SCG=mr[i].data["SCG"];			 
			var user=mr[i].data["user"];			 
				 
			var dataRow = RowId +"^"+ SCG +"^"+ reqAmt +"^"+ inci +"^"+ reqQty
					+"^"+ reqUom +"^"+ currLoc +"^"+ user +"^"+ configtype;
				
			var row=SubLocUserReqConfigGridDs.indexOf(mr[i])+1;
			if ((SCG=="")&&(inci=='')) {
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
			
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
			 
		}		
	
		if(data==""){
			Msg.info("error","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: SubLocUserReqConfigGridUrl+'?actiontype=SaveLocUserReq',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
					}else if(jsonData.info==-11){
						Msg.info("error","数据重复!");
					}else{
						Msg.info("error",jsonData.info+"保存失败!");
					}
					SubLocUserReqConfigGridDs.reload();
				},
				scope: this
			});
		}
    }
});

var deleteSubLocUserReqConfig = new Ext.Toolbar.Button({
	text:'删除一条',
    tooltip:'删除一条',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = SubLocUserReqConfigGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = SubLocUserReqConfigGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除一条选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:SubLocUserReqConfigGridUrl+'?actiontype=DelLocUserReq&RowId='+RowId,
								waitMsg:'删除一条中...',
								failure: function(result, request) {
									mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除一条成功!");
										SubLocUserReqConfigGridDs.reload();
									}else{
										Msg.info("error","删除一条失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				SubLocUserReqConfigGridDs.remove(record);
				SubLocUserReqConfigGrid.getView().refresh();
			}
		}
    }
});

var ConfigPagingToolBar = new Ext.PagingToolbar({
    store:SubLocUserReqConfigGridDs,
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
SubLocUserReqConfigGrid = new Ext.grid.EditorGridPanel({
	store:SubLocUserReqConfigGridDs,
	cm:SubLocUserReqConfigGridCm,
	trackMouseOver:true,
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	listeners:{
		beforeedit:function(e){
			if(e.field=="user" || e.field=='SCG' || e.field=='desc'){
				if(e.record.get('RowId')!=""){
					e.cancel=true;
				}
			}
		}
	}
});

function setNotDisplayColumnOfSCG(b)
{
	var colId=SubLocUserReqConfigGrid.getColumnModel().getIndexById('desc');	
	SubLocUserReqConfigGrid.getColumnModel().setHidden(colId,b);
	var colId=SubLocUserReqConfigGrid.getColumnModel().getIndexById('reqQty');	
	SubLocUserReqConfigGrid.getColumnModel().setHidden(colId,b)	;
	var colId=SubLocUserReqConfigGrid.getColumnModel().getIndexById('reqUom');	
	SubLocUserReqConfigGrid.getColumnModel().setHidden(colId,b);	
	var colId=SubLocUserReqConfigGrid.getColumnModel().getIndexById('reqQtyOfThisMonth');	
	SubLocUserReqConfigGrid.getColumnModel().setHidden(colId,b);			
}
function setNotDisplayColumnOfItm(b)
{
	var colId=SubLocUserReqConfigGrid.getColumnModel().getIndexById('SCG');	
	SubLocUserReqConfigGrid.getColumnModel().setHidden(colId,b);
}

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var SubLocUserReqConfigPanel = new Ext.Panel({
		title:'科室人员请领设置',
		activeTab: 0,
		region:'center',
		//collapsible: true,
		split: true,
//		width:200,	
        tbar:[addSubLocUserReqConfig,'-',saveSubLocUserReqConfig,'-',deleteSubLocUserReqConfig],
		items:[configPanel,SubLocUserReqConfigGrid],
		bbar:ConfigPagingToolBar
	});
	
	
	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[SubLocUserReqConfigPanel],
		renderTo: 'mainPanel'
	});
	
	if ( chkConfigBySCG.getValue()==true) {
		chkConfigBySCG.fireEvent('check',chkConfigBySCG,true);
	}
	if ( chkConfigByItm.getValue()==true) {
		chkConfigByItm.fireEvent('check',chkConfigByItm,true);
	}	
});
//===========模块主页面===============================================