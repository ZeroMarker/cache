function sure()
{
	//alert(InstanceId);
	var EntryScores = 0
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
		var Remark = record.get("Remark");
		var EntryScore = record.get("EntryScore");
		var Action = action
		var EmrDocId = emrDocId
		if (ChangeData == "")
		{
			var ChangeData=EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate + "^" + Remark + "^" +  Action + "^" + InstanceId + "^" + EmrDocId;
		}
		else
		{
			var ChangeData=ChangeData+'&'+EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate + "^" + Remark + "^" +  Action + "^" + InstanceId + "^" + EmrDocId;
		}
		var EntryScores = EntryScores*1+EntryScore*1
	}
		//alert(SignUserID);
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
				//alert("评价成功！");
				var text = Ext.getCmp('btnScore').getText();
				var score =  text.slice(5);
				Ext.getCmp('MessageGrid1').store.reload();
				Ext.getCmp('btnScore').setText("病案得分:"+(score-EntryScores));
				
				if (Action =="D")
				{
					SetDisManualFlag();
				}
			}
			
		}
	}) 	
}

if (action=="A")
{
	var prm = true; 
	var pro = true; 
	var pre = false;
}
else if (action=="D")
{
	var prm = true; 
	var pre = true; 
	var pro = false;
}
else if (action=="O")
{
	var pro = true; 
	var pre = true; 
	var prm = false;
}
var Text = "病案得分:"+Score;
var Bbar = [{
					id:'btnScore',
					text:Text,
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/s.gif',
					pressed:true
				},"->",{
					id:'btnSure',
					text:'评分',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/eprwrite.gif',
					pressed:false,
					handler:sure
				},{
					id:'btnSure1',
					text:'确认本次环节质控无缺陷',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/save.png',
					pressed:false,
					hidden : pre?true:false,
					handler:SetAdmManualFlag
				},{
					id:'btnSure1',
					text:'确认本次终末质控无缺陷',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/save.png',
					pressed:false,
					hidden : pro?true:false,
					handler:SetDisManualFlag
				},{
					id:'btnSure1',
					text:'确认本次门诊质控无缺陷',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/save.png',
					pressed:false,
					hidden : prm?true:false,
					handler:SetOutManualFlag
				}
				];
	var StructStore	= new Ext.data.JsonStore({
		autoLoad: false,
		url: '../EPRservice.Quality.GetStructResult.cls',
		fields: ['StructID', 'StructName'],
		root: 'data',
		totalProperty : "TotalCount"
		
    });		
				
	var store = new Ext.data.Store({
		url : '../EPRservice.Quality.entryGrid.cls',
		baseParams: {RuleID:RuleID,EpisodeID:EpisodeID,StructID:33},
		reader : new Ext.data.JsonReader({
			totalProperty : "TotalCount",
			root : 'data'
		}, ['EprStruct','EntryDesc','StructID','EntryID','EntryScore','LocID','LocName','EmployeeID','EmployeeName','Number','Remark']),
		sortInfo: {
        field: 'StructID',
        direction: 'desc'
    }

	});
	var getLocStore = new Ext.data.JsonStore({
		autoLoad: false,
		url: '../web.eprajax.query.getDicList.cls',
		fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
		root: 'data',
		totalProperty: 'TotalCount',
		baseParams: { start: 0, limit: 30},
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
				getEmployeeStore.baseParams = { DicCode: 'S11', DicQuery: txtValueText};
			}
		}
	});
	
    var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
    var addColsCM = new Ext.grid.ColumnModel([
		sm,
		/*{
			header:'病历结构',
			dataIndex:'EprStruct',
			sortable:true,
			width:60
		},*/
		
		{
			header:'评估条目',
			dataIndex:'EntryDesc',
			width:230,
			renderer: function(value, meta, record) {
				meta.attr = 'style="white-space:normal;word-wrap:break-word;word-break:break-all;"';
            	return value;
    		//var max = 30;  //显示多少个字符
   		 	//meta.tdAttr = 'data-qtip="' + value + '"';
    		//return value.length < max ? value :value.substring(0, max - 3) + '...';
			}
		},
		{
			header:'扣分',
			dataIndex:'EntryScore',
			width:40
		},
		{
			header:'缺陷数',
			dataIndex:'Number',
			editor:new Ext.grid.GridEditor(new Ext.form.NumberField({
				allowBlank:false,
				allowNegative:false,
				maxValue:100
			})),
			width:50
		},
		{
			header:'备注(可修改)',
			dataIndex:'Remark',
			editor:new Ext.grid.GridEditor(new Ext.form.TextField({
			})),
			width:200
		}
		/*{
			header:'科主任',
			dataIndex:'DirectorDoc',
			editor:new Ext.grid.GridEditor(new Ext.form.TextField({
				//allowBlank:false
			})),
			width:50
		},
		{
			header:'主治医师',
			dataIndex:'Attend',
			editor:new Ext.grid.GridEditor(new Ext.form.TextField({
				//allowBlank:false
			})),
			width:60
		},
		{
			header:'住院医师',
			dataIndex:'Resident',
			editor:new Ext.grid.GridEditor(new Ext.form.TextField({
				//allowBlank:false
			})),
			width:60
		},*/
		/*
		{
			header:'责任科室',
			dataIndex:'LocName',
			width:70,
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
				id: 'cbxLoc',
				store:getLocStore,
				minChars: 1,
				listWidth: 100,
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
		    width:60,
		    editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
				id: 'cbxEmployee',
				store:getEmployeeStore,
				minChars: 1,
				listWidth: 100,
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
		}*/
	]);
	var combo = new Ext.form.ComboBox({
			el:"combo",
			id:'combo',
			emptyText: '评估病历',
			store: StructStore,
			listWidth: 253,
		    valueField: 'StructID',
		    displayField: 'StructName',
		    mode : 'remote',
			enable:true,
			triggerAction: 'all',
			width: 253,
			listeners:{
					'expand' : function(){
						StructStore.removeAll();
						StructStore.load();
					},
					'select' : function(c,b){
						var StructID = Ext.getCmp("combo").getValue();
						Ext.getCmp('MessageGrid').store.baseParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID}
						Ext.getCmp('MessageGrid').store.reload();
					}
				}
	});
	combo.render();
    var MessageGrid = new Ext.grid.EditorGridPanel({
	    	el:"currentDocs",
			id: 'MessageGrid',
			frame: true,
			region: 'center',
			//autoScroll: true,
			store: store,
			cm: addColsCM,
			sm: sm,
			clicksToEdit:1,
			bbar: Bbar,
			stripeRows: true
    	});
	MessageGrid.render();
	store.load();
	
	
	
	store.on('load', function(){
		if('IE11.0'==isIE()){
			Ext.getCmp('MessageGrid').addClass('ext-ie');
		}
    //OutGridChangeRowBackColor(Ext.getCmp('dgResultGrid'));
	});
function SetAdmManualFlag() {
	//alert(SignUserID)
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Set",Status:"A",SSGroupID:SSGroupID},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("确认成功！");
				window.parent.parent.doSearch();
				return;
			}
		}
	}) 		
}
function SetDisManualFlag() {
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Set",Status:"D"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("确认成功！");
				window.parent.parent.doSearch();
				return;
			}
		}
	}) 		
}
function SetOutManualFlag() {
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Set",Status:"O"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("确认成功！");
				window.parent.parent.doSearch();
				return;
			}
		}
	}) 		
}

function GetProblemList(){
	if (Action=="A")
	{
		window.open("dhc.epr.quality.qualityresult.csp?EpisodeID=" + EpisodeID+ "&RuleID=" + 2); 
		//window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCEPRQuality.JITProblemList&AEpisodeID=" + EpisodeID+ "&ARuleID=" + 2); 
	}
	else if (Action=="D")
	{
		window.open("emr.qualitylist.csp?EpisodeID=" + EpisodeID+ "&RuleID=" + 2); 
		//window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.QualityDetail&AEpisodeID=" + EpisodeID+ "&ARuleID=" + "7"); 
	}
}

function isIE(){
	var userAgent = navigator.userAgent, 
	rMsie = /(msie\s|trident.*rv:)([\w.]+)/; 
	var browser; 
	var version; 
	var ua = userAgent.toLowerCase(); 
	function uaMatch(ua){ 
		var match = rMsie.exec(ua); 
		if(match != null){ 
			return { browser : "IE", version : match[2] || "0" }; 
		}
	} 
	var browserMatch = uaMatch(userAgent.toLowerCase()); 
	if (browserMatch.browser){ 
		browser = browserMatch.browser; 
		version = browserMatch.version; 
	} 
	return(browser+version);
}

function setRevision(status)
{
	if (window.parent.Left.frames["frameBrowsepage"].frames["frameBrowseInEpisode"].frames["frameBrowseEPRorEMR"].frames["frameBrowseCategory"])
	{
		window.parent.Left.frames["frameBrowsepage"].frames["frameBrowseInEpisode"].frames["frameBrowseEPRorEMR"].frames["frameBrowseCategory"].setViewRevision(status);
	}
}

function changeRevisionStatus()
{
 	if (document.getElementById("revision").innerHTML == "显示留痕")
 	{
	 	document.getElementById("revision").innerHTML = "关闭留痕";
	 	setRevision("true");
	}
	else
	{
		document.getElementById("revision").innerHTML = "显示留痕";
		setRevision("false");
	}
}

function initRevisionStatus()
{
	document.getElementById("revision").innerHTML = "关闭留痕";
}