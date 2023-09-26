//���ߣ�YHY
//ʱ�䣺2012-10-29
//���ܣ����Ӳ�����Ϣͬ��ѡ�
//Ŀ�ģ�Ϊ��ʹ���������������
function GetObserverUpData(pateintID, action, episodeID, userID,
				templateID){
	var store = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : '../web.eprajax.ajaxGetMessage.cls'}),
		baseParams: {EpisodeID:episodeID, PateintID: pateintID,Action:action,TemplateID:templateID},
		reader : new Ext.data.JsonReader({
			totalProperty : "TotalCount",
			root : 'data'
		}, ['Code','Desc','Current','Original','Glossary','Type','CodeAction'])
	});

    var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
    var addColsCM = new Ext.grid.ColumnModel([
		sm,
		{
			header:'��Ԫ����',
			dataIndex:'Desc',
			width:150
		},
		{
			header:'������',
			dataIndex:'Current',
			width:200
		},
		{
			header:'ԭ����',
			dataIndex:'Original',
			width:200
		}
	]);
    var MessageGrid = new Ext.grid.EditorGridPanel({
		id: 'MessageGrid',
		frame: true,
		region: 'center',
		autoScroll: true,
		height: 200,
		store: store,
		cm: addColsCM,
		sm: sm,
		stripeRows: true
    });
	var PaPatMasPanel = new Ext.TabPanel({
		id: 'PaPatMasPanel',
		name: 'PaPatMasPanel',
		frame: true,
		width: 580,
		height: 360,
		autoShow:true
	});
	var tab=PaPatMasPanel.add({
		title:'ͬ�����߻�����Ϣѡ�',
		layout:'fit',
		items:[MessageGrid]
	});
    PaPatMasPanel.activate(tab);

    var btnOK = new Ext.Button({
		id: 'btnOK',
		name: 'btnOK',
		minWidth: 50,
		text: '����',
		handler: function()
		{
			UpdateData(MessageGrid,caseSaveWin,pateintID,userID);
		}
	});
	var btnClose = new Ext.Button({
		id: 'btnClose',
		name: 'btnClose',
		minWidth: 50,
		text: '�ر�',
		handler: function()
		{
			caseSaveWin.close();
			setDllVisibility("visible");
		}
	});
	var caseSaveWin = new Ext.Window({
		id : 'caseSaveWin',
		height : 370,
		buttonAlign : 'right',
		width : 590,
		layout : 'fit',
		plain : true,
		animateTarget : 'btnReference',
		modal: true,
		frame: true,
		resizable:false,
		items:[
			PaPatMasPanel
			],
		buttons:[
			btnOK,
			btnClose
			],
		listeners: {
			'close': function() {
					setDllVisibility("visible");
				
			}
		}
	});

	store.load({
		callback:function(r,options,success){

			if (r.length == 0) return;
			
			var subjectLength = r.length;
			var hasSubjectWMRInfection = false;
			var hasSubjectPaPatMas = false;
			var urlSubjectWMRInfection = "";
			for (var i=0; i<subjectLength; i++)
			{
				if (r[i].data["Type"] == "WMRInfection") 
				{
					hasSubjectWMRInfection = true;
					urlSubjectWMRInfection = r[i].data["CodeAction"];
				}
				else if (r[i].data["Type"] == "PaPatMas")
				{
					hasSubjectPaPatMas = true;
				} 
			}
			
			if (hasSubjectWMRInfection)
			{
				//ȥ����Ⱦ���ϱ���ص���Ŀ
				for (var i=subjectLength-1; i>=0; i--)
				{
					if (r[i].data["Type"] == "WMRInfection") 
					{
						this.remove(this.getAt(i));
					}
				}
				
				ReportWMRInfection(urlSubjectWMRInfection);
			}
			
			if(hasSubjectPaPatMas)
			{
				caseSaveWin.show();
				setDllVisibility("hidden");
			}
		}
	});
}

//���ߣ�YHY
//���ܣ���ȡѡ��ͬ�������ݲ�����
function UpdateData(MessageGrid,caseSaveWin,pateintID,userID){
	var selections = MessageGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("��ѡ��ͬ��������!");
			return;
	}
	var IPaddress=GetLocalIPAddress()
	var ChangeData="";
	for (var i=0; i<selections.length; i++)
	{
		//debugger;
		var record = selections[i];
		var ItemCode=record.get("Code");
		var ItemCurrent=record.get("Current");
		var ItemOriginal=record.get("Original");
		if (ChangeData == "")
		{
			var ChangeData=ItemCode+'^'+ItemCurrent+'^'+ItemOriginal;
		}
		else
		{
			var ChangeData=ChangeData+'&'+ItemCode+'^'+ItemCurrent+'^'+ItemOriginal;
		}
	}	
	Ext.Ajax.request({
		url: '../web.eprajax.Observer.SaveCase.cls',
		params: {changedata:ChangeData,PateintID:pateintID,userid:userID,IPAddress:IPaddress},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==-1 )
			{
				alert("����ʧ�ܣ�");
				return;
			}
			else if (ret == 1)
			{
				alert("����ɹ���");
				caseSaveWin.close();
				setDllVisibility("visible");
			}
			
		}
	}) 
}

//���ߣ�YHY
//Ŀ�ģ���ȡ����IP��ַ
function GetLocalIPAddress()  
{  
    var obj = null;  
    var rslt = "";  
    try  
    {  
        obj = new ActiveXObject("rcbdyctl.Setting");  
        rslt = obj.GetIPAddress;  
        obj = null;  
    }
    catch(e)  
    {  
          
    }  
return rslt;
}  

// ��Ⱦ���ϱ�
function ReportWMRInfection(reportInfectionUrl)
{
	if (reportInfectionUrl == "") return;
	
	var c1 = String.fromCharCode(1);
	var arrReportInfection = reportInfectionUrl.split(c1);
	if (arrReportInfection[0] == "0")
	{
		alert(arrReportInfection[1]);
	}
	else if (arrReportInfection[0] == "1")
	{
		alert(arrReportInfection[1]);
		var c2 = String.fromCharCode(2);
		var arrReportInfectionUrl = arrReportInfection[2].split(c2);
		for (var i=0; i<arrReportInfectionUrl.length; i++)
		{
			if (arrReportInfectionUrl[i] == "") continue;
			try{
	        window.showModalDialog(arrReportInfectionUrl[i],"","dialogHeight:800px;dialogLeft:1px;dialogTop:1px;dialogWidth:800px;dialogHide:no;");
	    }catch(e){
	        alert(e.message);
	    }
  	}
  }
}
