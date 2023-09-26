function sure()
{
	var selections = MessageGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择手工评分项");
			return;
	}
	var ChangeData="";
	for (var i=0; i<selections.length; i++)
	{
		//debugger;
		var record = selections[i];
		var EntryID = record.get("EntryID");
		var LocName = record.get("LocName");
		if (isNaN(LocName))
		{
			var LocID = record.get("LocID");
		}
		else
		{
			var LocID = record.get("LocName");
		}
		var EmployeeName = record.get("EmployeeName")
		if (isNaN(EmployeeName))
		{
			var EmployeeID = record.get("EmployeeID");
		}
		else
		{
			var EmployeeID = record.get("EmployeeName");
		}
		var Number = record.get("Number");
		

		if (ChangeData == "")
		{
			var ChangeData=EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate;
		}
		else
		{
			var ChangeData=ChangeData+'&'+EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate;
		}
	}
		Ext.Ajax.request({
		url: '../EPRservice.Quality.SaveManualResult.cls',
		params: {ChangeData:ChangeData},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==0 )
			{
				alert("评价失败！");
				return;
			}
			else if (ret == 1)
			{
				alert("评价成功！");
				Ext.getCmp('MessageGrid1').store.reload();
			}
			
		}
	}) 	
}
var Bbar = ["->",{
					id:'btnSure',
					text:'确认',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/s.gif',
					pressed:false,
					handler:sure
				}];
				
				
	var store = new Ext.data.Store({
		url : '../EPRservice.Quality.entryGrid.cls',
		baseParams: {RuleID:RuleID,EpisodeID:EpisodeID},
		reader : new Ext.data.JsonReader({
			totalProperty : "TotalCount",
			root : 'data'
		}, ['EprStruct','EntryDesc','EntryID','LocID','LocName','EmployeeID','EmployeeName','Number'])
	});
	
	
	var getLocStore = new Ext.data.JsonStore({
		autoLoad: false,
		url: '../web.eprajax.query.getDicList.cls',
		fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
		root: 'data',
		totalProperty: 'TotalCount',
		baseParams: { start: 0, limit: 12},
		listeners: {
			'beforeload': function() {
				var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
				getLocStore.removeAll();
				getLocStore.baseParams = { DicCode: 'S07', DicQuery: txtValueText};
			}
		}
	});
	var getEmployeeStore = new Ext.data.JsonStore({
		autoLoad: false,
		url: '../web.eprajax.query.getDicList.cls',
		fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
		root: 'data',
		totalProperty: 'TotalCount',
		baseParams: { start: 0, limit: 12},
		listeners: {
			'beforeload': function() {
				var txtValueText = Ext.getCmp("cbxEmployee").getRawValue();
				getEmployeeStore.removeAll();
				getEmployeeStore.baseParams = { DicCode: 'S50', DicQuery: txtValueText};
			}
		}
	});
	
    var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
    var addColsCM = new Ext.grid.ColumnModel([
		sm,
		{
			header:'病历结构',
			dataIndex:'EprStruct',
			width:160
		},
		{
			header:'评估条目',
			dataIndex:'EntryDesc',
			width:160
		},
		{
			header:'责任科室',
			dataIndex:'LocName',
			width:160,
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
				id: 'cbxLoc',
				store:getLocStore,
				minChars: 1,
				listWidth: 240,
				selectOnFocus: true,
				pageSize: 12,
				mode : 'remote',
				valueField:'DicCode',
				displayField:'DicDesc',
				triggerAction: 'all',
				listeners:{
					'expand' : function(){
						getLocStore.load();
					}
				}
			})),
			renderer:function(value){
				var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
			    if (txtValueText==""){
				    return value
				}
				else{
					return txtValueText;
				}
			}
		},
		{
			header:'责任医师',
			dataIndex:'EmployeeName',
		    width:160,
		    editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
				id: 'cbxEmployee',
				store:getEmployeeStore,
				minChars: 1,
				listWidth: 240,
				selectOnFocus: true,
				pageSize: 12,
				mode : 'remote',
				valueField:'DicCode',
				displayField:'DicDesc',
				triggerAction: 'all',
				listeners:{
					'expand' : function(){
					getEmployeeStore.load();
					}
				}
			})),
			renderer:function(value){
				var txtValueText = Ext.getCmp("cbxEmployee").getRawValue();
			    if (txtValueText==""){
				    return value
				}
				else{
					return txtValueText;
				}
			} 
		},
		{
			header:'触发次数',
			dataIndex:'Number',
			editor:new Ext.grid.GridEditor(new Ext.form.NumberField({
				allowBlank:false,
				allowNegative:false,
				maxValue:100
			})),
			width:75
		}
	]);

    var MessageGrid = new Ext.grid.EditorGridPanel({
	    	el:"currentDocs",
			id: 'MessageGrid',
			frame: true,
			region: 'center',
			autoScroll: true,
			//height: 599,
			width: 770,
			store: store,
			cm: addColsCM,
			sm: sm,
			clicksToEdit:1,
			bbar: Bbar,
			stripeRows: true
    	});
	MessageGrid.render();
	store.load();
