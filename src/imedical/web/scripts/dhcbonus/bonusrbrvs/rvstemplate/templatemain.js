/*
* ��������ģ��
* 2016-05-05 guojing
*/

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}



var TemplateUrl = '../csp/dhc.bonus.rvstemplateexe.csp';
var TemplateProxy = new Ext.data.HttpProxy({url:TemplateUrl + '?action=templatelist&start=0&limit=10'});

var TemplateDs = new Ext.data.Store({
	proxy: TemplateProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        //'rvsTemplateMainID',
        'rowid',
		'templateCode',
		'templateName',
		'useMinuteRate',
		'workRiskRate',
		'techDifficultyRate',
		'workCostRate',
		'tempDesc',
		'createUser',
		'createDate'
		
	]),
    // turn on remote sorting
    //remoteSort: true     //����
    pruneModifiedRecords:true
});
 
 var TemplateCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: 'ģ�����',
        dataIndex: 'templateCode',
        width: 60,		  
        sortable: true
    },{
    	header: 'ģ������',
        dataIndex: 'templateName',
        width: 100,
        sortable: true
    },{
	    header: '��ʱȨ��',
        dataIndex: 'useMinuteRate',
        width: 45,
        sortable: true
	},{
    	header: '����Ȩ��',
        dataIndex: 'workRiskRate',
        width: 45,		  
        sortable: true
    },{
    	header: '�Ѷ�Ȩ��',
        dataIndex: 'techDifficultyRate',
        width: 45,
        sortable: true
    },{
	    header: '����Ȩ��',
        dataIndex: 'workCostRate',
        width: 50,
        sortable: true
	},{
    	header: '˵��',
        dataIndex: 'tempDesc',
        width: 190,		  
        sortable: true
    },{
    	header: '������Ա',
        dataIndex: 'createUser',
        width: 60,
        sortable: true
    },{
	    header: '��������',
        dataIndex: 'createDate',
        width: 100,
        sortable: true
	}
    
]);


//��ҳ������
var TemplatePagingToolbar = new Ext.PagingToolbar({
    store: TemplateDs,
	pageSize:10,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼"
	
});

//���
var addButton = new Ext.Toolbar.Button({
	text: '���',
	tooltip: '���',
	iconCls: 'add',
	handler: function(){
		templateAddFun();
		
	}
});

//�޸�
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
	tooltip: '�޸�',
	iconCls: 'option',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		templateEditFun();
	}
});



var copyButton = new Ext.Toolbar.Button({
	text: '����',
	tooltip: '����',
	iconCls: 'option',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
		templateCopytFun();
		
	}
});



//ɾ��
var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			
			Ext.MessageBox.confirm(
				'��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: TemplateUrl + '?action=templatedel&rowid='+tmpRowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									TemplateDs.load({params:{start:0, limit:TemplatePagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'����',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	}
});

var templateMain = new Ext.grid.EditorGridPanel({
	title:'��������ģ��',
	region:'north',
	//region:'center',
	height:230,
	//enableTabScroll : true,
	store: TemplateDs,
	cm: TemplateCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:[addButton,'-',editButton,'-',delButton,'-',copyButton],
	bbar:TemplatePagingToolbar
});

//Ĭ�ϼ������е����� 
TemplateDs.load({
	params:{start:0, limit:TemplatePagingToolbar.pageSize},
	callback:function(record,options,success ){
		templateMain.fireEvent('rowclick',this,0);
		
	}
});

var tmpSelectedTemplate='';

templateMain.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = TemplateDs.data.items[rowIndex];

	//������ģ�壬ˢ����ϸ��Ϣ
	//selectedRow.data['templateCode']  templateCode������grid�Ѿ������
	tmpSelectedTemplate=selectedRow.data['rowid'];
	DetailDs.proxy = new Ext.data.HttpProxy({url: DetailUrl + '?action=detaillist&template='+tmpSelectedTemplate});
	DetailDs.load({params:{start:0, limit:DetailPagingToolbar.pageSize}});
	
});	