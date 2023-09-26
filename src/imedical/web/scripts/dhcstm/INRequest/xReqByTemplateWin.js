xReqByTemplateWin=function (reqType,HVflag)
{
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var URL = 'dhcstm.inrequestaction.csp';

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.RowSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(selmod,rowindex,record){
				
					var record=temGrid1.getStore().getAt(rowindex);
					var req=record.get("req");
					temStore2.load({
						params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req},
						callback: function(r,options,success){
							  if (r.length>0)
							  {temGrid2.getSelectionModel().selectAll();}
							}
					});
				
			}
		}
	});
	var temCm=new Ext.grid.ColumnModel([nm,
		{
			header:'req',
			dataIndex:'req',
			hidden:true
		},
		{
		 header:"模板名称(备注)",
		 dataIndex:'Remark',
		 width:150
		}
		,
		{	header:'单号',
			dataIndex:'reqNo',
			width:150
		},
		{
			header:'日期',
			dataIndex:'Date'
			,width:70
		},
		{
			header:'时间',
			dataIndex:'Time',
			width:70
		},
		{	header:'制单人',
			dataIndex:'User'
		},
		{
			header:'完成',
			dataIndex:'completed',
			width:50,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);
 	temCm.defaultSortable = true;
	var temStore=new Ext.data.Store({
		url:URL+'?actiontype=GetTemplate',
		baseParams:{
			locId:Ext.getCmp('LocField').getValue(),
			reqType:reqType,
			HVflag:HVflag
		},
		autoLoad:true,
		reader:new Ext.data.JsonReader({
			totalProperty:'result',
			root:'rows',
			fields:['req','reqNo','Date','Time','User','Remark','completed']
		}),
		listeners:{
			load : function(store,records,options){
				if (records.length>0){
					temGrid1.getSelectionModel().selectFirstRow();
					temGrid1.getView().focusRow(0);
				}
			}
		}
	});

	var temGrid1=new Ext.grid.GridPanel({
	 	store:temStore,
	 	cm:temCm,
	 	sm:sm,
	 	trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		deferRowRender : false,
	 	listeners:{
			'rowdblclick':function(){
				makeReqByTemp();
			}
		}
	});
	
	var nm2 = new Ext.grid.RowNumberer();
	var sm2 = new Ext.grid.CheckboxSelectionModel({});
	var temCm2=new Ext.grid.ColumnModel([nm2,sm2,
		{
        header:"reqitid",
        dataIndex:'rowid',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资rowid",
        dataIndex:'inci',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"规格",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"申领数量",
        dataIndex:'qty',
        id:'colQty',
		xtype:'numbercolumn',
		format:'0',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"零售单价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
    	header:'进价',
    	dataIndex:'rp',
    	width:100,
    	aligh:'right'
    },{
        header:"单位",
        dataIndex:'uom',
        width:100,
        align:'left',
        hidden:true
    }]);
 	temCm2.defaultSortable = true;
	var temStore2=new Ext.data.Store({
		url:URL+'?actiontype=queryDetail',
		method:'GET',
		reader:new Ext.data.JsonReader({
			totalProperty:'result',
			root:'rows'
		},['rowid','inci','code','desc','spec','manf','qty','sp','rp','uom'])
	});
	
	var temGrid2=new Ext.grid.GridPanel({
	 	store:temStore2,
	 	cm:temCm2,
	 	sm:sm2,//多选   //new Ext.grid.RowSelectionModel({singleSelect:true}),
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
	 	deferRowRender : false
	});
	
	var win2=new Ext.Window({
	   	title:'按模板制单',
	   	width:720,
	   	height:500,
	   	modal:true,
	   	layout:'border',
	   	tbar:[{xtype:'button',id:'makeReqByTemp',text:'按模板制单',iconCls:'page_add',handler:function(){
			var rec = temGrid1.getSelectionModel().getSelected();
			if (rec == null) {
				Msg.info("warning", "请选择一条模板记录！");
				return;
			}
			var Reqitmidstr="";
			var rowDataArr = temGrid2.getSelectionModel().getSelections();
			if (Ext.isEmpty(rowDataArr)) {
				Msg.info("warning", "请选择明细!");
				return;
			}
			for(i=0;i<rowDataArr.length;i++)
				{
				var rowData=rowDataArr[i];
				var reqitmid = rowData.get("rowid");
				if (Reqitmidstr=="")
				{
				Reqitmidstr=reqitmid;
				}else{
				Reqitmidstr=Reqitmidstr+"^"+reqitmid;
				}
				}
			if(Reqitmidstr==""){Msg.info("warning", "请选择明细信息!");return}
			Ext.Msg.show({
				title:'提示',
				msg:'是否确定按模板制单？',
				buttons:Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn:function(b,txt){
					if (b=='no') return;
					var comp=rec.get('completed');
					if (!comp)
					{
						Msg.info('error','该模板处于未"完成"状态，不可使用，请使用<模板编辑>完成后再使用。');
						return;
					}

			 		var req=rec.get('req');
			 		importReqTem(req,Reqitmidstr);
			 		win2.close();  
				}
   			})
	   	}}],
	   	items:[{
				region:'north',
				height:200,
				split:true,
				layout:'fit',
				items:temGrid1
			},{
				region:'center',
				layout:'fit',
				items:temGrid2
			}]
	 });
 
	 win2.show();
	 
	function makeReqByTemp()
	{
		Ext.getCmp('makeReqByTemp').handler();
	}

}