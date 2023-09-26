var init = function (){
	var ch1 = String.fromCharCode(1);
	Ext.QuickTips.init();
	var GroupID = session['LOGON.GROUPID'];
	var UserRowId = session['LOGON.USERID'];
	var lookup;	
	var genLookup  = function (){
		if(lookup&&lookup.store){
			lookup.doSearch([document.getElementById('arcimDesc').value,GroupID,"","","","","",EpisodeID,"","",UserRowId]);
		}else{
			lookup  = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				//resizeColumn: true,
				lookupPage: 'DHCDocBillOrderRecord',
				lookupName: 'arcimDesc',
				listClassName: 'web.DHCDocOrderEntry',
				listQueryName: 'LookUpItem',
				displayField: 'ARCIMDesc',
				displayCM: ['ARCIMDesc'],
				//Item, GroupID, Category , SubCategory, TYPE, OrderDepRowId , OrderPriorRowId, EpisodeID, BillingGrp, BillingSubGrp, UserRowId , OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String
				listProperties: [document.getElementById('arcimDesc').value,GroupID,"","","","","",EpisodeID,"","",UserRowId],
				listeners: {
					selectRow: function(str){
						Ext.getCmp("arcimRowid").setValue(str.split("^")[1]);														
					}
				}
			});
		}
	}
	var recordFields = [
		{name:'arcimRowid',allowBlank:false},
		{name:'arcimDesc',allowBlank:false},
		{name:'qty',type:'int'},
		{name:'comment'},
		{name:'startdate'},
		{name:'starttime'},
		{name:'priorRemarksId'},
		{name:'priorRemarks'}
	];
	var OeoriRecord = Ext.data.Record.create(recordFields);
	var ds = new Ext.data.JsonStore({fields: recordFields});
	var formatDate = function (value){
		if(!value) return '';
        return 'string' == typeof value ? value : value.dateFormat('d/m/Y');
    }
	var cms = [
		{header:'医嘱项目rowid',dataIndex:'arcimRowid',hidden:true},
		{header:'医嘱项目',dataIndex:'arcimDesc'},
		{header:'数量',dataIndex:'qty',editor:{xtype:'numberfield',minValue:1,allowBlank:false}},
		{header:'备注',dataIndex:'comment',editor: {xtype:'field'}} ,
		{header:'附加说明Id',dataIndex:'priorRemarksId',hidden:true},
		{header:'附加说明',dataIndex:'priorRemarks'},
		{header:'开始日期',dataIndex:'startdate', editor: {xtype:'datefield',format:'d/m/Y'},renderer:formatDate},
		{header:'形始时间',dataIndex:'starttime', editor: {xtype:'field'} }
	];
	//var pbar1 = new Ext.ProgressBar({ id:'pbar1', width:300,renderTo:Ext.getBody()});
	var arcimGrid = new Ext.grid.EditorGridPanel({
		title: arcimtitle,
		id: "arcimGrid",
		name: "arcimGrid",
		region: 'center',
		columnLines: true,
		loadMask: true,
		sm:	new Ext.grid.RowSelectionModel({singleSelect:false}),
		colModel: new Ext.grid.ColumnModel({columns:cms, defaults:{sortable:false, menuDisabled:true}}),
		store: ds,		
		clicksToEdit: 1,
		/*bbar: new Ext.PagingToolbar({
			pageSize: 20, 
			store: ds, 
			displayInfo: true , 
			displayMsg: '{0}-{1},共{2}条'
		}),*/
		/*bbar:  [new Ext.ProgressBar({
			id:'pbar1',
			width:300		
		})],*/
		tbar: ['->',{ id:'delOE',text:'删除',handler:function (b, e){
			var records = arcimGrid.getSelectionModel().getSelections();
			ds.remove(records);
		}},'-',{ id:'saveOE',text:'保存到库并关闭',handler:function (b, e){
			var oeords = "";			
			var win = new Ext.Window({closable:false,modal:true,layout:'fit',items: new Ext.ProgressBar({id:'pbar1', width:300})});
			win.show();			
			Ext.getCmp("pbar1").wait({interval:200,text:'保存中...',increment:10});				
			ds.each(function(r){
				var item = r.data['arcimRowid']+"^"+r.data["qty"]+"^"+r.data["priorRemarksId"]+"^"+r.data["startdate"]+"^"+r.data["starttime"]+"^"+r.data["comment"];
				if(oeords=="") {oeords = item}else{oeords += ch1 + item;}
			});
			Ext.Ajax.request({
				url:'dhcdoc.request.csp',
				params:{act:'AddBillOrder',parrefRowid:parrefRowid, oeords:oeords},
				success: function(response,opt){
					Ext.getCmp("pbar1").reset(true);
					win.close();
					Ext.Msg.alert("提示","保存成功!");
					window.close();
				},
				failure: function(response,opt){
					Ext.Msg.alert("提示","操作失败!");					
					Ext.getCmp("pbar1").reset(true);
					win.close();
				}
			});
		}}]
	});
	var arcimForm = new Ext.form.FormPanel({
		title:'数据信息',
		id:'arcimForm',
		region: 'east', //'south',
		//layout:'table',
        //layoutConfig: {columns:3},
		labelAlign: 'left',
		width: 400,
		split: true,
		frame: true,
		//layout:'column',
		//autoHeight:true,
		defaults:{width:240,bosrder:false},
		defaultType:'textfield',
		items:[			
			{
				xtype:'trigger',
				enableKeyEvents: true,
				onTriggerClick:genLookup,
				triggerClass:'x-form-search-trigger',
				listeners: {
					specialkey: function(field, e){									
						if (e.getKey() == e.ENTER) {
							genLookup();
						}
					}
				},
				id:'arcimDesc',
                fieldLabel: '医嘱项目名',
				allowBlank:false,
                name: 'arcimDesc'
            },{
				xtype:'numberfield',
                fieldLabel: '数量',
				allowBlank:false,
				minValue:0,
				value:1,
                name: 'qty'
            },{
	           xtype:'combo',
	           fieldLabel:'附加说明',
	           name:"priorRemarks",
	           id:"priorRemarks",
	           mode:'local',
	           displayField: 'priorRemarksDesc',
			   valueField:'priorRemarksId',
			   triggerAction: 'all',
    			lazyRender:true,
			   store: new Ext.data.ArrayStore({
					fields: ['priorRemarksId','priorRemarksDesc'],
					data:PriorData
				}),
				listeners: {
					change: function(t,n,o){
						Ext.getCmp("priorRemarksId").setValue(n);														
					}
				}
	         },{
                xtype: 'datefield',
                fieldLabel: '开始日期',
                format:'d/m/Y',
                disabled: stDateDisabled,
				minValue:parrefOrderStDate,
				value:parrefOrderStDate,
				name: 'startdate'
            },{
				fieldLabel: '开始时间',
				name: 'starttime',
				value:parrefOrderStTime
			},{
                fieldLabel: '备注',
                name: 'comment'
            },			{
				//fieldLabel: '医嘱项目Rowid',
				allowBlank:false,
                id: 'arcimRowid',
                hidden:true
			},{
				//fieldLabel:'priorRemarksId',
				id:'priorRemarksId',
                hidden:true
			}
		],
		buttons:[{
				xtype: 'button',
				text:'更新到列表',
				id:'update1',
				handler:function(b,e){				
					var bf = Ext.getCmp("arcimForm").getForm();
					var data,record;
					if(bf.isValid()){
						data = bf.getValues();
						record = new OeoriRecord(data);
						record.markDirty();
						ds.add(record);					
						bf.reset();
					}
				}
			}]
	});
	var view = new Ext.Viewport({
		layout:'border',
		items:[arcimGrid,arcimForm]
	});
}
Ext.onReady(init);