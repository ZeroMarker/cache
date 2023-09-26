var projUrl = '../csp/dhc.qm.checkpointmakeexe.csp';

var itemGridProxy= new Ext.data.HttpProxy({url:projUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
			proxy : itemGridProxy,
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'schemcode','schemname','linker','schemeType','importType','checkType','active']),
					remoteSort: true
		});

///ҽ����		
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Rowid', 'name'])
		});
		

//��Ӹ�ѡ��
var sm = new Ext.grid.CheckboxSelectionModel();

RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :projUrl+'?action=Listcheckproj', 
                        method:'POST'
					});
		});


  
var addButton = new Ext.Toolbar.Button({
		text: '���',
    	tooltip: '����µ���Ŀ',        
    	iconCls: 'add',
		handler: function(){
			addProjFun(itemGridDs,itemGrid);}
});
/////////////////�޸İ�ť/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ������Ŀ',
		iconCls: 'option',
		handler: function(){
		editProjFun();}
		});


////////////////ɾ����ť//////////////////////////
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){

		//var selectedRow = itemGridDs.data.items[rowIndex];
		
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���ļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.qm.checkpointmakeexe.csp?action=delleft&rowid='+rowObj[0].get("rowid"),
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGridDs.load({params:{start:0,limit:25,sort:"rowid",dir:"asc"}});
								}else{
									Ext.Msg.show({title:'��ʾ',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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

		

var itemGridCm = new Ext.grid.ColumnModel([
		    
		new Ext.grid.RowNumberer(),
        {
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'schemcode',
            header: '��Ŀ����',
			allowBlank: true,
			//width:100,
			     
            dataIndex: 'schemcode'
        },{
            id:'schemname',
            header: '��Ŀ����',
			allowBlank: true,
			//width:100,    
            dataIndex: 'schemname'
        },{
            id:'schemeType',
            header: '��Ŀ����',
			allowBlank: true,
			//width:100,
            dataIndex: 'schemeType'
        },{
            id:'importType',
            header: '������Դ',
			allowBlank: true,
			//width:100,
            dataIndex: 'importType'
        },{
            id:'checkType',
            header: '���ϸ�����',
			allowBlank: true,
			//width:100,
            dataIndex: 'checkType'
        },{
            id:'linker',
            header: '����ҽ��', 
            allowBlank:true,
           // width:300,
            align:'right',            
            //type:RelyUnitCombo,
            dataIndex: 'linker'
        },{
            id:'active',
            header: '�Ƿ�����',
			allowBlank: true,
			//width:100,
            dataIndex: 'active'
        }]
);

var AuditPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"

})

var itemGrid = new Ext.grid.GridPanel({
			//title: '��Ч��λ��¼',
	        region: 'west',
            width: '60%',
	       // minSize: 350,
	       // maxSize: 700,
	        split: true,
	        collapsible: true,
	        containerScroll: true,
	        xtype: 'grid',
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			viewConfig: {forceFit:true},
			tbar: [addButton,'-',editPatentInfoButton,'-',delButton],
			bbar:AuditPagingToolbar
});

 itemGridDs.load({	
			params:{start:0, limit:AuditPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){
	//������Ч��Ԫ��ˢ�ڲ���Ա��¼
	
	if (rowIndex !=='0')
	{ 
	//alert (rowIndex);
	//personGrid.getSelectionModel().getSelections()
	var selectedRow = itemGridDs.data.items[rowIndex];
	//alert(itemGridDs.data.items);
    rowid = selectedRow.data['rowid'];
    itemID=rowid;
	personDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=listright&schemcode='+rowid});
	personDs.load({params:{start:0, limit:AuditPagingToolbar.pageSize}});
	}
});   

itemGrid.load({params:{start:0,limit:25}});
