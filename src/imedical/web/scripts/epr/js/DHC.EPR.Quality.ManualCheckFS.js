function delet()
{
	var selections1 = MessageGrid1.getSelectionModel().getSelections();
	if (selections1.length == 0) 
	{
			alert("��ѡ��ɾ���ֹ�������!");
			return;
	}
	var DelData="";
	for (var i=0; i<selections1.length; i++)
	{
		//debugger;
		var record = selections1[i];
		
		var ResultID = record.get("ResultID");
		var DetailID = record.get("DetailID");
		if (DelData == "")
		{
			var DelData = ResultID + "||" + DetailID;
		}
		else
		{
			var DelData = DelData + '&' + ResultID + "||" + DetailID;
		}
	}
	Ext.Ajax.request({
		url: '../EPRservice.Quality.SaveManualResult.cls',
		params: {DelData:DelData},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == 0 )
			{
				alert("ɾ��ʧ�ܣ�");
				return;
			}
			else if (ret == 1)
			{
				alert("ɾ���ɹ���");
				Ext.getCmp('MessageGrid1').store.reload();
			}
			
		}
	}) 
}
var Bbar = ["->",{
					id:'btnSure',
					text:'ɾ��',
					cls: 'x-btn-text-icon',
					icon:'../scripts/epr/Pics/s.gif',
					pressed:false,
					handler:delet
				}];		
var store = new Ext.data.Store({
		url : '../EPRservice.Quality.GetQualityResult.cls',
		baseParams: {RuleID:RuleID,EpisodeID:EpisodeID,SSGroupID:SSGroupID,CTLocatID:CTLocatID},
		reader : new Ext.data.JsonReader({
			totalProperty : "TotalCount",
			root : 'data'
		}, ['CtLocName','EmployeeName','EntryName','SignUserName','ReportDate','EntryID','LocID','EmployeeID','ResultID','DetailID','SignUserID'])
	});
    var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
    var addColsCM = new Ext.grid.ColumnModel([
		sm,
		{
			header:'���ο���',
			dataIndex:'CtLocName',
			width:160
		},
		{
			header:'������',
			dataIndex:'EmployeeName',
			width:85
		},
		{
			header:'������Ŀ',
			dataIndex:'EntryName',
			width:300
		},
		{
			header:'������',
			dataIndex:'SignUserName',
		    width:85
		},
		{
			header:'��������',
			dataIndex:'ReportDate',
			width:100
		}
	]);
    var MessageGrid1 = new Ext.grid.EditorGridPanel({
	    	el:"ChangeFS",
			id: 'MessageGrid1',
			frame: true,
			region: 'center',
			//autoScroll: true,
			//height: 599,
			width: 770,
			store: store,
			cm: addColsCM,
			sm: sm,
			clicksToEdit:1,
			bbar: Bbar,
			stripeRows: true
    	});
	MessageGrid1.render();
	store.load();
