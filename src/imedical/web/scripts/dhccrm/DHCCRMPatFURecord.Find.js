Ext.onReady(LoadPage);
//Ext.BLANK_IMAGE_URL = 'pic/blank.gif';
var ListPanel;
var BeginDate;
var EndDate;
var store;
var User;
var fuPersonstore;
function LoadPage()
{		
	

	fuPersonstore=new Ext.data.Store({
	url : 'dhccrmsetplan1.csp?action=fupersonlist',
	reader : new Ext.data.JsonReader({
	totalProperty : "results",
	root : "rows"}, ['RowID',  'Name'])
	})
 	
	fuPersonstore.on('beforeload', function() {
		var UserDesc=Ext.getCmp('fupersoncombo').getValue();
		if (UserDesc=="") return;
		fuPersonstore.proxy.conn.url = 'dhccrmsetplan1.csp?action=fupersonlist&UserDesc='+UserDesc;

	})
       
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
	User= new Ext.form.ComboBox({
		enableKeyEvents : true,
		fieldLabel : '随访人',
		width : 125,
		id : 'fupersoncombo',
		name : 'fupersoncombo',
		store : fuPersonstore,
		valueField : 'RowID',
		displayField : 'Name',
		triggerAction : 'all',
		id : 'fupersoncombo',
		mode : 'local',
		//listWidth:200,
		listeners : {'specialkey':function(obj,e){
						if (e.getKey()==e.ENTER){
						var UserDesc=Ext.getCmp('fupersoncombo').getRawValue();
						obj.store.proxy.conn.url = 'dhccrmsetplan1.csp?action=fupersonlist&UserDesc='+UserDesc;
						//alert(this.store.proxy.conn.url)
						obj.store.load();
						//obj.expand();
						}
					
					}}
	})
     

	ListPanel=new Ext.Panel({
		title:'随访记录',
		region:'west',
		layout:'form',
		split: true,
    	collapsible:true,
		width:250,
		frame:true,
        items: [BeginDate, EndDate, User,{
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
	var UserID=Ext.getCmp('fupersoncombo').getValue();
	var lnk='dhccrmfurecord.find1.csp?action=list&BeginDate='+BeginStr+'&EndDate='+EndStr+'&Type=0'+'&UserID='+UserID;
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
        },{
            name: 'RegNo',mapping:'RegNo'
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
		{header: "登记号", width: 150, sortable: true,dataIndex:'RegNo'},
		{header: "姓名", width: 120, sortable: true,dataIndex:'Name'},
		{header: "日期", width: 130, sortable: true,dataIndex:'Date'},
		{header: "Demo", width: 60, hidden: true,dataIndex:'Demo'}
		
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
	
	panel.destroy();
	
	CreateMainPanel();
	//
	mainView.add(panel);
	View();
	//mainView.doLayout(true);
            
	
}


