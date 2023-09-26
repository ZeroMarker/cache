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
		{header:'ҽ����Ŀrowid',dataIndex:'arcimRowid',hidden:true},
		{header:'ҽ����Ŀ',dataIndex:'arcimDesc'},
		{header:'����',dataIndex:'qty',editor:{xtype:'numberfield',minValue:1,allowBlank:false}},
		{header:'��ע',dataIndex:'comment',editor: {xtype:'field'}} ,
		{header:'����˵��Id',dataIndex:'priorRemarksId',hidden:true},
		{header:'����˵��',dataIndex:'priorRemarks'},
		{header:'��ʼ����',dataIndex:'startdate', editor: {xtype:'datefield',format:'d/m/Y'},renderer:formatDate},
		{header:'��ʼʱ��',dataIndex:'starttime', editor: {xtype:'field'} }
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
			displayMsg: '{0}-{1},��{2}��'
		}),*/
		/*bbar:  [new Ext.ProgressBar({
			id:'pbar1',
			width:300		
		})],*/
		tbar: ['->',{ id:'delOE',text:'ɾ��',handler:function (b, e){
			var records = arcimGrid.getSelectionModel().getSelections();
			ds.remove(records);
		}},'-',{ id:'saveOE',text:'���浽�Ⲣ�ر�',handler:function (b, e){
			var oeords = "";			
			var win = new Ext.Window({closable:false,modal:true,layout:'fit',items: new Ext.ProgressBar({id:'pbar1', width:300})});
			win.show();			
			Ext.getCmp("pbar1").wait({interval:200,text:'������...',increment:10});				
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
					Ext.Msg.alert("��ʾ","����ɹ�!");
					window.close();
				},
				failure: function(response,opt){
					Ext.Msg.alert("��ʾ","����ʧ��!");					
					Ext.getCmp("pbar1").reset(true);
					win.close();
				}
			});
		}}]
	});
	var arcimForm = new Ext.form.FormPanel({
		title:'������Ϣ',
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
                fieldLabel: 'ҽ����Ŀ��',
				allowBlank:false,
                name: 'arcimDesc'
            },{
				xtype:'numberfield',
                fieldLabel: '����',
				allowBlank:false,
				minValue:0,
				value:1,
                name: 'qty'
            },{
	           xtype:'combo',
	           fieldLabel:'����˵��',
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
                fieldLabel: '��ʼ����',
                format:'d/m/Y',
                disabled: stDateDisabled,
				minValue:parrefOrderStDate,
				value:parrefOrderStDate,
				name: 'startdate'
            },{
				fieldLabel: '��ʼʱ��',
				name: 'starttime',
				value:parrefOrderStTime
			},{
                fieldLabel: '��ע',
                name: 'comment'
            },			{
				//fieldLabel: 'ҽ����ĿRowid',
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
				text:'���µ��б�',
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