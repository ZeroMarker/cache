Ext.onReady(LoadPage);
//Ext.BLANK_IMAGE_URL = 'pic/blank.gif';
var ListPanel;
var BeginDate;
var EndDate;
var store;
function LoadPage()
{
	Ext.BLANK_IMAGE_URL='../scripts/DHCCRM/Ext2/resources/images/default/s.gif';
	// turn on validation errors beside the field globally
    //Ext.form.Field.prototype.msgTarget = 'side';
	FindFlag="Y";
	CreateMainPanel()
	var gridPanel=CreateGridPanel();
	BeginDate=new Ext.form.DateField({
        fieldLabel: '开始日期',
        id: 'BeginDate',
		width:125,
		format:'Y-m-d'
	});
	EndDate=new Ext.form.DateField({
        fieldLabel: '结束日期',
        id: 'EndDate',
		width:125,
		format:'Y-m-d'
	});
	ListPanel=new Ext.Panel({
		title:'满意度调查记录',
		region:'west',
		layout:'form',
		split: true,
    	collapsible:true,
		width:250,
		frame:true,
        items: [BeginDate, EndDate, {
            xtype: 'button',
            text: '查找',
            handler: find_Click
        }, gridPanel]
	});
	
	
	View();
}
function find_Click()
{
	var BeginStr=BeginDate.getValue();
	if (BeginStr!='') BeginStr=BeginStr.dateFormat('Y-m-d');
	var EndStr=EndDate.getValue();
	if (EndStr!='') EndStr=EndStr.dateFormat('Y-m-d');
	var lnk='dhccrmfurecord.find1.csp?action=list&BeginDate='+BeginStr+'&EndDate='+EndStr;
	
	store.proxy.conn.url =lnk,
	store.load(true);
}
function View()
{
	mainView = new Ext.Viewport({
    
        layout: 'border',
        collapsible: true,
        items:[ListPanel,panel]
    });
	
}
function CreateGridPanel()
{
	store=new Ext.data.Store({
		url: 'dhcpecrmfurecord.dpext.csp?action=list',
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: "rows"
        }, [{
            name: 'RowID',mapping:'RowID'
        }, {
            name: 'Name',mapping:'Name'
        }, {
            name: 'Date',mapping:'Date'
        },{
            name: 'Demo',mapping:'Demo'
        }])
	});
	var cm=new Ext.grid.ColumnModel([
		{header: "RowID", width: 60, hidden: true,dataIndex:'RowID'},
		{header: "姓名", width: 120, sortable: true,dataIndex:'Name'},
		{header: "日期", width: 130, sortable: true,dataIndex:'Date'},
		{header: "录音", width: 150, sortable: true,dataIndex:'Demo',renderer: ValueDisplay}
	]);
	function ValueDisplay(value,cellID, record,rowIndex,columnIndex,store)
	{
		if (value!="") return "有"
		return ""
		return '<table width="100%"　border="0" cellspacing="0" cellpadding="0" style="TABLE-LAYOUT: fixed; WORD-BREAK: break-all">'
		+'<tr><td style="WORD-BREAK: break-all; WORD-WRAP: break-word">'
		+value
		+'</td></tr></table>'
	}
	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true,
		listeners: {
            rowselect: RowSelect
        }
	});
	var bottomBar=new Ext.PagingToolbar({
        pageSize: 10,
        store: store,
        displayInfo: true
    })
	var GridPanel=new Ext.grid.GridPanel(
	{
		//region:'west',
		//title:'调查记录',
		//frame:true,
		//collapsible:true,
		//draggable:true,
		autoScroll: true,
        //split: true,
		//autoHeight:true,
		width:245,
		height:600,
		viewConfig: {
	        forceFit: true
	    },
		store:store,
		cm:cm,
		sm:sm,
		bbar:bottomBar

	});
	store.load({
        params: {
            start: 0,
            limit: 10
        }
    });
	store.on("load",function(){
		sm.selectFirstRow();
	});
	return GridPanel;
}
function RowSelect(sm, row, rec)
{
	
    RecordID=rec.get("RowID");
	PlayName=rec.get("Demo");
	//PlayName=PlayName.replace("\\","\\\\");
	if (PlayName!="") PlayName=PlayName+RecordID+'.wav';
	//alert(PlayName)
	panel.destroy();
	CreateMainPanel();
	//
	mainView.add(panel);
	View();
	//mainView.doLayout(true);
            
	
}


