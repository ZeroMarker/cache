// /����: �±���ϸ��ѯ
// /����: �±���ϸ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.23
Ext.grid.RowNumberer.prototype.width = 100;
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIncid="";
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl	+ 'stkmonaction.csp?';
	var today=new Date();
	var growid=""
	var activeTabtmp=""
	//GetGroupDeptStore.load();

	var PhaLoc = new Ext.ux.LocComboBox({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : '����',
		listWidth : 'auto',
		groupId:gGroupId,
		listeners : {
			'select' : function(e) {
                  var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                  StkGrpType.getStore().removeAll();
                  StkGrpType.getStore().setBaseParam("locId",SelLocId)
                  StkGrpType.getStore().setBaseParam("userId",gUserId)
                  StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                  StkGrpType.getStore().load();
			}
	}
	});


	var StYear=new Ext.form.TextField({
		fieldLabel:'�·�',
		id:'StYear',
		name:'StYear',
		//anchor:'90%',
		width:70,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		//anchor:'90%',
		width:50,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdYear',
		name:'EdYear',
		//anchor:'90%',
		width:70,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		//anchor:'90%',
		width:50,
		value:(today.getMonth()+1)
	});
	
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%',
		width : 200
	});
	StkGrpType.on('change',function(){
		Ext.getCmp("IncStkCat").setValue("");
	});
	
	var IncStkCat=new Ext.ux.ComboBox({
		id:'IncStkCat',
		name:'IncStkCat',
		store:StkCatStore,
		displayField:'Description',
		valueField:'RowId',
		emptyText:'������',
		params:{StkGrpId:'StkGrpType'}
	});
	
	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'ҩƷ����',
		width:220,
		listeners:{
			'specialkey':function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
					var stkgrp = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(field.getValue(), stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
				}
			}
		}
	});
	var HelpBT = new Ext.Button({
	��������id:'HelpBtn',
			text : '����',
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
		});
		// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '���ΪExcel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					var activeTab=tabPanel.getActiveTab();

					if(activeTab.id=="ReportDetailSp"){
						ExportAllToExcel(DetailGrid);
					}else if(activeTab.id=="ReportDetailRp"){
						ExportAllToExcel(DetailGridRp);
					}else if(activeTab.id=="ReportDetailLbSp"){
						ExportAllToExcel(DetailGridLB);
					}else if (activeTab.id=="ReportDetailLbRp"){
						ExportAllToExcel(DetailGridLBRp);
					}else if(activeTab.id=="ReportDetailSCGRp"){
						ExportAllToExcel(DetailGridSCGRp);
					}else if(activeTab.id=="ReportDetailSCG"){
						ExportAllToExcel(DetailGridSCG);
					}else if(activeTab.id=="ReportDetailCat"){
						ExportAllToExcel(DetailGridCat);
					}else if(activeTab.id=="ReportDetailCatRp"){
						ExportAllToExcel(DetailGridCatRp);
					}else{
						return;
					}					
				}
			});
	var Filter=new Ext.Toolbar.Button({
		id:'filter',
		text:'ɸѡ',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
				MonRepFilter();
			}
	});
	
	/**
	 * ���ط���
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		;
		Ext.getCmp("IncDesc").setValue(inciDesc);
		//Ext.getCmp('InciDr').setValue(inciDr);			
	}
	
	//��������,������,ҩƷ���Ƶı仯,  �����±���ϸ
	function MonRepFilter(){
		var record=MainGrid.getSelectionModel().getSelected();
		if(record){
			var rowid=record.get("smRowid");
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stkcatid=Ext.getCmp("IncStkCat").getValue();
			var incdesc=Ext.getCmp("IncDesc").getValue();
			
			var activeTab=tabPanel.getActiveTab();
			growid=rowid
			activeTabtmp=activeTab ;
			if(activeTab.id=="ReportDetailSp"){
				DetailStore.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(activeTab.id=="ReportDetailRp"){
				DetailStoreRp.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(activeTab.id=="ReportDetailLbSp" || activeTab.id=="ReportDetailLbRp"){
				DetailStoreLB.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(activeTab.id=="ReportDetailSCGRp"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:0}});
			}else if(activeTab.id=="ReportDetailSCG"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:1}});
			}else if(activeTab.id=="ReportDetailCat"){
				DetailStoreCat.load({params:{Parref:rowid,Type:1}});
			}else if(activeTab.id=="ReportDetailCatRp"){
				DetailStoreCat.load({params:{Parref:rowid,Type:0}});
			}else{
				DetailStore.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}
		}
	}
		// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {  
					Query();
				}
			});
		// ��ӡ�±���ϸ
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : '��ӡ',
	tooltip : '��ӡ�±���ϸ',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintStkMon(growid,activeTabtmp);
	}
});			
			
	
//��ѯ�±�
function Query(){
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	var stDate=stYear+'-'+stMonth+'-'+'01';
	var edYear=Ext.getCmp('EdYear').getValue();
	var edMonth=Ext.getCmp('EdMonth').getValue();
	var edDate=edYear+'-'+edMonth+'-'+'01';
	var Loc=Ext.getCmp('PhaLoc').getValue();
	if(Loc==""){
		Msg.info("warning","��ѡ����Ҫ��ѯ�±��Ŀ���!");
		return;
	}
	DetailGrid.store.removeAll();
	DetailGridRp.store.removeAll();
	DetailGridLB.store.removeAll();
	DetailGridLBRp.store.removeAll();
	DetailStoreSCG.removeAll();
	MainStore.removeAll();
	MainStore.load({params:{LocId:Loc,StartDate:stDate,EndDate:edDate}});
}

function renderRecQty(value, metaData, record, rowIndex, colIndex, store){
	var curUrl=window.location.href;
	var host=window.location.host;
	var pathName=window.location.pathname;
	var pos=pathName.indexOf("/csp");
	var commonPath=pathName.substring(0,pos);
	var Loc=Ext.getCmp('PhaLoc').getValue();
	var LocDesc=Ext.getCmp('PhaLoc').getRawValue();
	var selectRecord=MainGrid.getSelectionModel().getSelected();
	var startDate=selectRecord.get("frDate");
	var endDate=selectRecord.get("toDate");
	var incId=record.get("inci"),incDesc=record.get("inciDesc");
	var DateFlag=1;  //���������ͳ��
	var QueryParams=Loc+","+startDate+","+endDate+","+incId+","+incDesc+","+DateFlag+","+LocDesc;
	var newUrl="http://"+host+commonPath+"/csp/dhcst.ingdrecquery.csp?QueryParams={0}"
	//return String.format('<a href='+newUrl+' target="_blank">{1}',QueryParams,value);	
	
	var retINfo="<a onclick='websys_createWindow("+"\"dhcst.ingdrecquery.csp?QueryParams="+QueryParams+"\""+")'>"+"<font color='blue'>"+value+"</font>"+"</a>"
	return retINfo;

	
}
var nm = new Ext.grid.RowNumberer({width:30});
var DetailCm = new Ext.grid.ColumnModel([nm, {
			header : "rowid",
			dataIndex : 'Rowid',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : 'ҩƷ����',
			dataIndex : 'inciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : 'ҩƷ����',
			dataIndex : 'inciDesc',
			width : 220,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��λ",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ������",
			dataIndex : 'qty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "���ڽ����",
			dataIndex : 'amt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'���ڽ������',
			dataIndex:'lastQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ڽ����',
			dataIndex:'lastAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recQty',
			width:100,
			align:'right',
			sortable:'true',
			renderer:renderRecQty
		},{
			header:'�����',
			dataIndex:'recAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻����',
			dataIndex:'retAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת�����',
			dataIndex:'trOutAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trInQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת����',
			dataIndex:'trInAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'adjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'adjAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'csmQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���Ľ��',
			dataIndex:'csmAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'disposeQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'disposeAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'aspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��ҩ�������',
			dataIndex:'giftRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��ҩ�����',
			dataIndex:'giftRecAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��ҩ��������',
			dataIndex:'giftTrOutQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��ҩ������',
			dataIndex:'giftTrOutAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�������',
			dataIndex:'chgRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�����',
			dataIndex:'chgRecAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�˻�����',
			dataIndex:'chgRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ۻ�Ʊ�˻����',
			dataIndex:'chgRetAmt',
			width:100,
			align:'right',
			sortable:'true'
		},/*{   //��Ŀ���ⶨ�ƣ������ã�������  yangsj 2020-01-13
			header:'�Ƽ��������',
			dataIndex:'mRecQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ������',
			dataIndex:'mRecAmt',
			width:100,
			align:'right',
			sortable:'true'
		},*/{
			header:'�̵��������',
			dataIndex:'stktkAdjQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵�������',
			dataIndex:'stktkAdjAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ���������',
			dataIndex:'manuXQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ����Ľ��',
			dataIndex:'manuXAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ���������',
			dataIndex:'manuMQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�Ƽ����ɽ��',
			dataIndex:'manuMAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����',
			dataIndex:'phaInDspQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ���',
			dataIndex:'phaInDspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����',
			dataIndex:'phaInRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ���',
			dataIndex:'phaInRetAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ����',
			dataIndex:'phaOutDspQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ���',
			dataIndex:'phaOutDspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ����',
			dataIndex:'phaOutRetQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ���',
			dataIndex:'phaOutRetAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������(����)',
			dataIndex:'recAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����(����)',
			dataIndex:'retAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������(����)',
			dataIndex:'trInAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ����(����)',
			dataIndex:'phaOutRetAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����(����)',
			dataIndex:'phaRetAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ����(����)',
			dataIndex:'phaOutDispAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����(����)',
			dataIndex:'phaDispAspAmt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'diffAmt',
			width:100,
			align:'right',
			sortable:'true'
		}]);
function DiffQty(val,record){
	var diffqty=Number(record.lastQty)+Number(record.recQty)+Number(record.retQty)+Number(record.trOutQty)+Number(record.trInQty)+Number(record.adjQty)+Number(record.csmQty)+Number(record.disposeQty)+
	Number(record.giftRecQty)+Number(record.giftTrOutQty)+Number(record.chgRecQty)+Number(record.chgRetQty)+Number(record.mRecQty)+Number(record.stktkAdjQty)+Number(record.manuXQty)+Number(record.manuMQty)+
	Number(record.phaInDspQty)+Number(record.phaInRetQty)+Number(record.phaOutDspQty)+Number(record.phaOutRetQty)-Number(record.qty);
	return Math.round(diffqty*100)/100;
}

function DiffAmt(val,record){
	var diffamt=Number(record.lastAmt)+Number(record.recAmt)+Number(record.retAmt)+Number(record.trOutAmt)+Number(record.trInAmt)+Number(record.adjAmt)+Number(record.csmAmt)+Number(record.disposeAmt)+
	Number(record.giftRecAmt)+Number(record.giftTrOutAmt)+Number(record.chgRecAmt)+Number(record.chgRetAmt)+Number(record.mRecAmt)+Number(record.stktkAdjAmt)+Number(record.manuXAmt)+
	Number(record.manuMAmt)+Number(record.trInAspAmt)+Number(record.aspAmt)+Number(record.retAspAmt)+Number(record.phaInDspAmt)+Number(record.phaInRetAmt)+Number(record.phaOutDspAmt)+Number(record.phaOutRetAmt)+
	Number(record.recAspAmt)+Number(record.phaOutRetAspAmt)+Number(record.phaRetAspAmt)+Number(record.phaOutDispAspAmt)+Number(record.phaDispAspAmt)-
    Number(record.amt);
	
	return Math.round(diffamt*100)/100;
}

var DetailStore = new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url+"actiontype=QueryDetail",
    storeId: 'DetailStore',
    root: 'rows',
    totalProperty : "results",
    idProperty: 'Rowid',  
    fields: ['Rowid','inci','inciCode','inciDesc', 'spec', 'uomDesc','qty','amt','lastQty','lastAmt','recQty','recAmt','retQty',
    'retAmt','trOutQty','trOutAmt','trInQty','trInAmt','adjQty','adjAmt','csmQty','csmAmt','disposeQty','disposeAmt',
    'aspAmt','giftRecQty','giftRecAmt','giftTrOutQty','giftTrOutAmt','chgRecQty','chgRecAmt','chgRetQty','chgRetAmt',
    'retAspAmt','mRecQty','mRecAmt','stktkAdjQty','stktkAdjAmt','manuXQty','manuXAmt','manuMQty','manuMAmt','trInAspAmt',
	'phaInDspAmt','phaInDspQty','phaInRetQty','phaInRetAmt','phaOutDspQty','phaOutDspAmt','phaOutRetQty','phaOutRetAmt',
	'recAspAmt','phaOutRetAspAmt','phaRetAspAmt',,'phaOutDispAspAmt','phaDispAspAmt',
    {name:'diffQty',convert:DiffQty},{name:'diffAmt',convert:DiffAmt}]
});

var DetailGrid = new Ext.grid.GridPanel({
	id:'DetailGrid',
    store: DetailStore,
    cm:DetailCm,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 35,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    })
});

var DetailStoreRp=new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url+"actiontype=QueryDetailRp",
    storeId: 'DetailStoreRp',
    root: 'rows',
    totalProperty : "results",
    idProperty: 'Rowid',  
    fields: ['Rowid','inci','inciCode','inciDesc', 'spec', 'uomDesc','qty','amt','lastQty','lastAmt','recQty','recAmt','retQty',
    'retAmt','trOutQty','trOutAmt','trInQty','trInAmt','adjQty','adjAmt','csmQty','csmAmt','disposeQty','disposeAmt',
    'aspAmt','giftRecQty','giftRecAmt','giftTrOutQty','giftTrOutAmt','chgRecQty','chgRecAmt','chgRetQty','chgRetAmt',
    'retAspAmt','mRecQty','mRecAmt','stktkAdjQty','stktkAdjAmt','manuXQty','manuXAmt','manuMQty','manuMAmt','trInAspAmt',
	'phaInDspAmt','phaInDspQty','phaInRetQty','phaInRetAmt','phaOutDspQty','phaOutDspAmt','phaOutRetQty','phaOutRetAmt',
	'recAspAmt','phaOutRetAspAmt','phaRetAspAmt',,'phaOutDispAspAmt','phaDispAspAmt',
    {name:'diffQty',convert:DiffQty},{name:'diffAmt',convert:DiffAmt}]
});

var DetailGridRp = new Ext.grid.GridPanel({
	id:'DetailGridRp',
    store: DetailStoreRp,
    cm:DetailCm,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 35,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    })
});

function DiffQtyLB(val,record){
	var diffqty=Number(record.lastqty)+Number(record.recqty)+Number(record.retqty)+Number(record.trfoqty)
	+Number(record.trfiqty)+Number(record.adjqty)+Number(record.conqty)+Number(record.dispqty)+Number(record.dspretqty)
	+Number(record.phaoutdispqty)+Number(record.phaoutretqty)+Number(record.stktkqty)+Number(record.dspqty)
	-Number(record.qty);
	return Math.round(diffqty*100)/100;
}

function DiffAmtLB(val,record){
	var diffamt=Number(record.lastamt)+Number(record.recamt)+Number(record.retamt)+Number(record.trfoamt)
	+Number(record.trfiamt)+Number(record.adjamt)+Number(record.conamt)+Number(record.dispamt)+Number(record.dspamt)
	+Number(record.aspamt)+Number(record.phaoutdispamt)+Number(record.phaoutretamt)+Number(record.dspretamt)
	+Number(record.recaspamt)+Number(record.retaspamt)+Number(record.phaoutretaspamt)+Number(record.pharetaspamt)+
	+Number(record.trfinaspamt)+Number(record.phaoutdispaspamt)+Number(record.phadispaspamt)
	-Number(record.amt);	
	return Math.round(diffamt*100)/100;
}

function DiffAmtLbRp(val,record){
	var diffamt=Number(record.lastcoamt)+Number(record.reccoamt)+Number(record.retcoamt)+Number(record.trfocoamt)
	+Number(record.trficoamt)+Number(record.adjcoamt)+Number(record.concoamt)+Number(record.dispcoamt)+Number(record.dspcoamt)
	+Number(record.aspcoamt)+Number(record.phaoutdispcoamt)+Number(record.phaoutretcoamt)+Number(record.dspretcoamt)
	+Number(record.recaspcoamt)+Number(record.retaspcoamt)+Number(record.phaoutretaspcoamt)+Number(record.pharetaspcoamt)+
	+Number(record.trfinaspcoamt)
	-Number(record.coamt);	
	return Math.round(diffamt*100)/100;
}
//�ϲ�DetailGridLB����ͬ��ҩƷ��Ϣ
function cellMerge(value, meta, record, rowIndex, colIndex, store) {
	var lastRowCode="",lastRowDesc="",lastRowSpec="",lastRowUom="";
	if(rowIndex>0){
		lastRowCode=store.getAt(rowIndex - 1).get("incicode"),lastRowDesc=store.getAt(rowIndex - 1).get("incidesc"),
		lastRowSpec=store.getAt(rowIndex - 1).get("spec"),lastRowUom=store.getAt(rowIndex - 1).get("puomdesc");
	}
	var thisRowCode=store.getAt(rowIndex).get("incicode"),thisRowDesc=store.getAt(rowIndex).get("incidesc"),
	thisRowSpec=store.getAt(rowIndex).get("spec"),thisRowUom=store.getAt(rowIndex).get("puomdesc");
	var nextRowCode="",nextRowDesc="",nextRowSpec="",nextRowUom="";
	if(rowIndex<store.getCount()-1){
		nextRowCode=store.getAt(rowIndex+1).get("incicode"),nextRowDesc=store.getAt(rowIndex+1).get("incidesc"),
		nextRowSpec=store.getAt(rowIndex+1).get("spec"),nextRowUom=store.getAt(rowIndex+1).get("puomdesc");
	}
	
    var first = !rowIndex || (thisRowCode !==lastRowCode)||(thisRowDesc!==lastRowDesc)||(thisRowSpec!==lastRowSpec)||(thisRowUom!==lastRowUom),
    last = rowIndex >= store.getCount() - 1 || (thisRowCode !==nextRowCode)||(thisRowDesc!==nextRowDesc)||(thisRowSpec!==nextRowSpec)||(thisRowUom!==nextRowUom);
    meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && thisRowCode == store.getAt(i).get("incicode")
        &&thisRowDesc==store.getAt(i).get("incidesc")&&thisRowSpec==store.getAt(i).get("spec")&&thisRowUom==store.getAt(i).get("puomdesc")) {
            i++;
        }
        var rowHeight = 25, padding = 6,
            height = (rowHeight * (i - rowIndex) - padding) + 'px';
        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
    }
    return first ? value : '';
}

var DetailStoreLB = new Ext.data.JsonStore({
	autoDestroy: true,
    url: Url+"actiontype=QueryDetailLB",
    storeId: 'DetailStoreLB',
    root: 'rows',
    totalProperty : "results",
    fields: ['incicode','incidesc', 'spec', 'manf','puomdesc','IBNO','qty','amt','coamt','lastqty','lastamt','lastcoamt','recqty','recamt','reccoamt',
    'retqty','retamt','retcoamt','trfoqty','trfoamt','trfocoamt','trfiqty','trfiamt','trficoamt','adjqty','adjamt','adjcoamt','dispqty','dispamt','dispcoamt',
    'aspamt', 'aspcoamt','dspamt','dspqty','dspcoamt','dspretqty','dspretamt','dspretcoamt','phaoutdispqty','phaoutdispamt','phaoutdispcoamt','phaoutretqty','phaoutretamt','phaoutretcoamt','retaspamt',
    'retaspcoamt','recaspamt','recaspcoamt','pharetaspamt','pharetaspcoamt','trfinaspamt','trfinaspcoamt','phaoutretaspamt','phaoutretaspcoamt','stktkqty','stktkamt','stktkcoamt','phaoutdispaspamt','phadispaspamt',
    {name:'diffQty',convert:DiffQtyLB},{name:'diffAmt',convert:DiffAmtLB},{name:'diffAmtRp',convert:DiffAmtLbRp}]
});
var DetailGridLB = new Ext.grid.GridPanel({
	id:'DetailGridLB',
    store: DetailStoreLB,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    }),
	    //cls: 'grid-row-span',
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}),  {
			header : 'ҩƷ����',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true
			//renderer:cellMerge  //yunhaibao,20151207ע��,���粻�ϲ�Ч����
		}, {
			header : 'ҩƷ����',
			dataIndex : 'incidesc',
			width : 220,
			align : 'left',
			sortable : true
			//renderer:cellMerge
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
			//renderer:cellMerge
		},{
			header : "��λ",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true
			//renderer:cellMerge
		}, {
			header:'����',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "����",
			dataIndex : 'IBNO',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ������",
			dataIndex : 'qty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "���ڽ����",
			dataIndex : 'amt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'���ڽ������',
			dataIndex:'lastqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ڽ����',
			dataIndex:'lastamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true',
			renderer:renderRecQty
		},{
			header:'�����',
			dataIndex:'recamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻����',
			dataIndex:'retamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfoqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת�����',
			dataIndex:'trfoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfiqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת����',
			dataIndex:'trfiamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'adjqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'adjamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'dispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'dispamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'aspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����',
			dataIndex:'dspqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ���',
			dataIndex:'dspamt',
			width:100,
			align:'right',
			sortable:'true'
		} ,{
			header:'סԺ��ҩ����',
			dataIndex:'dspretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ���',
			dataIndex:'dspretamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ����',
			dataIndex:'phaoutdispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ���',
			dataIndex:'phaoutdispamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ����',
			dataIndex:'phaoutretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ���',
			dataIndex:'phaoutretamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵��������',
			dataIndex:'stktkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵�������',
			dataIndex:'stktkamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת���������',
			dataIndex:'trfinaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����',
			dataIndex:'pharetaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ����',
			dataIndex:'phaoutretaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ����',
			dataIndex:'phaoutdispaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����',
			dataIndex:'phadispaspamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'diffAmt',
			width:100,
			align:'right',
			sortable:'true'
		}])
});

var DetailGridLBRp = new Ext.grid.GridPanel({
	id:'DetailGridLBRp',
    store: DetailStoreLB,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    autoScroll:true,
    trackMouseOver : true,
    loadMask:true,
    view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    borderHeight:1,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		    getRowClass:function(record,index,rowParams,store){
				var diffQty=record.get("diffQty");
				var diffAmt=record.get("diffAmt");
				if((diffQty!=0)||(diffAmt!=0)){
					return 'my_row_Yellow';
				}
			}
	    }),
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}),  {
			header : 'ҩƷ����',
			dataIndex : 'incicode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : 'ҩƷ����',
			dataIndex : 'incidesc',
			width : 220,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header:'����',
			dataIndex : 'manf',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "��λ",
			dataIndex : 'puomdesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "����",
			dataIndex : 'IBNO',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ������",
			dataIndex : 'qty',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "���ڽ����",
			dataIndex : 'coamt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header:'���ڽ������',
			dataIndex:'lastqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���ڽ����',
			dataIndex:'lastcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recqty',
			width:100,
			align:'right',
			sortable:'true',
			renderer:renderRecQty
		},{
			header:'�����',
			dataIndex:'reccoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻����',
			dataIndex:'retcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfoqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת�����',
			dataIndex:'trfocoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת������',
			dataIndex:'trfiqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת����',
			dataIndex:'trficoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'adjqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'adjcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'dispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'dispcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'aspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ����',
			dataIndex:'dspqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ���',
			dataIndex:'dspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		} ,{
			header:'סԺ��ҩ����',
			dataIndex:'dspretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ���',
			dataIndex:'dspretcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ����',
			dataIndex:'phaoutdispqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'���﷢ҩ���',
			dataIndex:'phaoutdispcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ����',
			dataIndex:'phaoutretqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ���',
			dataIndex:'phaoutretcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵��������',
			dataIndex:'stktkqty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�̵�������',
			dataIndex:'stktkcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�������',
			dataIndex:'recaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'�˻�����',
			dataIndex:'retaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'ת���������',
			dataIndex:'trfinaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'סԺ��ҩ��������',
			dataIndex:'pharetaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������ҩ����',
			dataIndex:'phaoutretaspcoamt',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'��������',
			dataIndex:'diffQty',
			width:100,
			align:'right',
			sortable:'true'
		},{
			header:'������',
			dataIndex:'diffAmtRp',
			width:100,
			align:'right',
			sortable:'true'
		}])
});

var DetailStoreSCG = new Ext.data.JsonStore({
	autoDestroy:true,
	url:Url+"actiontype=QuerySumBySCG",
	totalProperty:'results',
	root:'rows',
	fields:['grpDesc','LastAmt','Amt','RecAmt','RetAmt','TroAmt',
		'TriAmt','AdjAmt','ConAmt','DisAmt','DspAmt',
		'AspAmt','PhaRetAmt','RetAspAmt','PhaRetAspAmt','GiftRecAmt',
		'giftTrfAmt','chgRecAmt','chgRetAmt','mRecAmt','stktkAdjAmt',
		'manuXAmt','manuMAmt','phoRetAspAmt','trfIAspAmt','recAspAmt',
		,'phaOutDispAspAmt','phaDispAspAmt','In','Out'
	]
});

var DetailGridSCG = new Ext.grid.GridPanel({
	id:'DetailGridSCG',
	store:DetailStoreSCG,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '����',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻����',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת�����',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���Ľ��',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��ҩ���',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����������',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ���',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ�����',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ������',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�����',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�˻����',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* { 
			header : '�Ƽ������',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, */{
			header : '�̵�������',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����Ľ��',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����ɽ��',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻�����',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ����',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ����',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת���������',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���﷢ҩ����',
			dataIndex : 'phaOutDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ����',
			dataIndex : 'phaDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});

var DetailGridSCGRp = new Ext.grid.GridPanel({
	id:'DetailGridSCGRp',
	store:DetailStoreSCG,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '����',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻����',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת�����',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���Ľ��',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��ҩ���',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����������',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ���',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻�����',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ����',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ�����',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ������',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�����',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�˻����',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* {
			header : '�Ƽ������',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, */{
			header : '�̵�������',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����Ľ��',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����ɽ��',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ����',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת���������',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});
var DetailStoreCat = new Ext.data.JsonStore({
	autoDestroy:true,
	url:Url+"actiontype=QuerySumByCat",
	totalProperty:'results',
	root:'rows',
	fields:['grpDesc','catdesc','LastAmt','Amt','RecAmt','RetAmt','TroAmt',
		'TriAmt','AdjAmt','ConAmt','DisAmt','DspAmt',
		'AspAmt','PhaRetAmt','RetAspAmt','PhaRetAspAmt','GiftRecAmt',
		'giftTrfAmt','chgRecAmt','chgRetAmt','mRecAmt','stktkAdjAmt',
		'manuXAmt','manuMAmt','phoRetAspAmt','trfIAspAmt','recAspAmt',
		'phaOutDispAspAmt','phaDispAspAmt','In','Out'
	]
});
var DetailGridCat = new Ext.grid.GridPanel({
	id:'DetailGridCat',
	store:DetailStoreCat,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '����',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'catdesc',
			width : 125,
			align : 'left',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻����',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת�����',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���Ľ��',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��ҩ���',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����������',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ���',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻�����',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ����',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ�����',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ������',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�����',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�˻����',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* {
			header : '�Ƽ������',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, */{
			header : '�̵�������',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����Ľ��',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����ɽ��',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ����',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת���������',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���﷢ҩ����',
			dataIndex : 'phaOutDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ����',
			dataIndex : 'phaDispAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});
var DetailGridCatRp = new Ext.grid.GridPanel({
	id:'DetailGridCatRp',
	store:DetailStoreCat,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	trackMouseOver : true,
	loadMask:true,
	cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer({width:30}), {
			header : '����',
			dataIndex : 'grpDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'catdesc',
			width : 125,
			align : 'left',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'LastAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ڽ����',
			dataIndex : 'Amt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'RecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻����',
			dataIndex : 'RetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת�����',
			dataIndex : 'TroAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת����',
			dataIndex : 'TriAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'AdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���Ľ��',
			dataIndex : 'ConAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'DisAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��ҩ���',
			dataIndex : 'DspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����������',
			dataIndex : 'AspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ���',
			dataIndex : 'PhaRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�˻�����',
			dataIndex : 'RetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'סԺ��ҩ����',
			dataIndex : 'PhaRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ�����',
			dataIndex : 'GiftRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '��Ʒ������',
			dataIndex : 'giftTrfAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�����',
			dataIndex : 'chgRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '���ۻ�Ʊ�˻����',
			dataIndex : 'chgRetAmt',
			width : 100,
			align : 'right',
			sortable : true
		},/* {
			header : '�Ƽ������',
			dataIndex : 'mRecAmt',
			width : 100,
			align : 'right',
			sortable : true
		},*/ {
			header : '�̵�������',
			dataIndex : 'stktkAdjAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����Ľ��',
			dataIndex : 'manuXAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�Ƽ����ɽ��',
			dataIndex : 'manuMAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '������ҩ����',
			dataIndex : 'phoRetAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : 'ת���������',
			dataIndex : 'trfIAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'recAspAmt',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'In',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Out',
			width : 100,
			align : 'right',
			sortable : true
		}
	])
});

var MainStore=new Ext.data.JsonStore({
	auroDestroy:true,
	url:Url+"actiontype=Query",
	sotreId:'MainStore',
	root:'rows',
	totalProperty:'results',
	idProperty:'smRowid',
	fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime']
});

var MainGrid=new Ext.grid.GridPanel({
	id:'MainGrid',
	store:MainStore,
	cm:new Ext.grid.ColumnModel([{
		header:'Rowid',
		dataIndex:'smRowid',
		width:100,
		align:'left',
		hidden:true
	},{
		header:'����',
		dataIndex:'locDesc',
		width:200,
		align:'left',
		sortable:true
	},{
		header:'�·�',
		dataIndex:'mon',
		width:75,
		align:'center',
		sortable:true
	},{
		header:'�±���ʼ����',
		dataIndex:'frDate',
		width:150,
		align:'center',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var StDateTime=value+" "+record.get('frTime');
			return StDateTime;
		}
	},{
		header:'�±���ֹ����',
		dataIndex:'toDate',
		width:150,
		align:'center',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var EdDateTime=value+" "+record.get('toTime');
			return EdDateTime;
		}
	}]),
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true
})

MainGrid.addListener('rowclick',function(grid,rowindex,e){
	MonRepFilter();
});
	var mainForm = new Ext.form.FormPanel({
        autoHeight:true,
		labelWidth : 60,
		tbar : [SearchBT,'-',printBT,'-',SaveAsBT,'-',HelpBT],
		labelAlign : 'right',
		frame : true,
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'��ѯ����',
			style:DHCSTFormStyle.FrmPaddingV,
			items:[{
				columnWidth: 1,
		    	xtype: 'fieldset',
		    	defaults: {width: 450, border:false},    // Default config options for child items
		    	defaultType: 'textfield',
		    	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		    	border: false,
		    	items: [
		    		PhaLoc,
		    		{
						xtype: 'fieldset',
						style:'margin-top:6px;padding-left:0px;padding-bottom:0px;',
						items:[{
							xtype: 'compositefield',						
							items : [
								StYear,
								{ xtype: 'displayfield', value: '��'},
								StMonth,
								{ xtype: 'displayfield', value: ' ������'},
								EdYear,
								{ xtype: 'displayfield', value: '��'},
								EdMonth,
								{xtype:'displayfield',value:'��'}
							 ]
						}]
					}
				]
			}]

		}]						
	});

	//Ext.getCmp('PhaLoc').select(gLocId);
	//SetStkMonStDate();
   var tabPanel=new Ext.TabPanel({
   		activeTab:0,
   		tbar:new Ext.Toolbar({items:[StkGrpType,IncStkCat,IncDesc,Filter,'<font color=blue>&nbsp;&nbsp������ϸ����ɸѡ</font>']}),
   		items:[{
   			title:'�±���ϸ(�ۼ�)',
   			id:'ReportDetailSp',
   			layout:'fit',
   			items:[DetailGrid]
   		},{
   			title:'�±���ϸ(����)',
   			id:'ReportDetailRp',
   			layout:'fit',
   			items:[DetailGridRp]
   		}/*,{
   			title:'�±���ϸ���Σ��ۼۣ�',
   			id:'ReportDetailLbSp',
   			layout:'fit',
   			items:[DetailGridLB]
   		},{
   			title:'�±���ϸ����(����)',
   			id:'ReportDetailLbRp',
   			layout:'fit',
   			items:[DetailGridLBRp]
   		}*/,{
   			title:'�������(����)',
   			id:'ReportDetailSCGRp',
   			layout:'fit',
   			items:[DetailGridSCGRp]
   		},{
   			title:'�������(�ۼ�)',
   			id:'ReportDetailSCG',
   			layout:'fit',
   			items:[DetailGridSCG]
   		},{
   			title:'�������(�ۼ�)',
   			id:'ReportDetailCat',
   			layout:'fit',
   			items:[DetailGridCat]
   		},{
   			title:'�������(����)',
   			id:'ReportDetailCatRp',
   			layout:'fit',
   			items:[DetailGridCatRp]
   		}]
   })
   
   tabPanel.addListener('tabchange',function(tabpanel,panel){
   		var record=MainGrid.getSelectionModel().getSelected();
		
		if(record){
			var rowid=record.get("smRowid");
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var stkcatid=Ext.getCmp("IncStkCat").getValue();
			var incdesc=Ext.getCmp("IncDesc").getValue();
			growid=rowid
			activeTabtmp=panel
	   		if((panel.id=="ReportDetailSp")&(DetailStore.getCount()==0)){
				DetailStore.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if((panel.id=="ReportDetailRp")&(DetailStoreRp.getCount()==0)){
				DetailStoreRp.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
			}else if(panel.id=="ReportDetailLbSp" || panel.id=="ReportDetailLbRp"){
				if(DetailStoreLB.getCount()==0){
					DetailStoreLB.load({params:{Parref:rowid,StkGrpId:stkgrpid,StkCatId:stkcatid,IncDesc:incdesc}});
				}
			}else if(panel.id=="ReportDetailSCGRp"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:0}});
			}else if(panel.id=="ReportDetailSCG"){
				DetailStoreSCG.load({params:{Parref:rowid,Type:1}});
			}
			else if(panel.id=="ReportDetailCat"){
				DetailStoreCat.load({params:{Parref:rowid,Type:1}});
			}
			else if(panel.id=="ReportDetailCatRp"){
				DetailStoreCat.load({params:{Parref:rowid,Type:0}});
			}
		}
	});
	
	var myPanel = new Ext.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [ 
		{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(2)+28,
			layout:'fit',
			title:'�±���ϸ��ѯ',
			layout: 'border', // specify layout manager for items
			items: [{
				region: 'west',
				split: false,
				width: document.body.clientWidth*0.4,                			
				layout: 'fit', // specify layout manager for items
				items: mainForm 				               
			},{
				region:'center',
				layout:'fit',
				items:MainGrid 
			}]
		},{ 
			region:'center',
			layout:'fit',
			items:tabPanel 
		}]
	});
  //Query();   
   new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 250,
        anchorOffset: 50,
		hideDelay : 90000,
        html: "<font size=2 color=#15428b ><p><b>����:</b>����ҵ�����ݽ��Ϊ���ĺϼ�</p><p><b>����:</b>����ҵ�����ݽ��Ϊ���ĺϼ�</p><p><b>����:</b>���ڽ���+����+����-���ڽ���</p></font>"
   });
    Ext.getCmp('HelpBtn').focus('',100); //��ʼ��ҳ���ĳ��Ԫ�����ý���	  
}) 