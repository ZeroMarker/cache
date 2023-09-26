function setLocClaGrp(loc,locDesc ){
var Url="dhcstm.locclagrpaction.csp"
var GrpRowId=null
//���ҷ�����
var AddButton=new Ext.ux.Button({
	text:'����',
	iconCls:'page_add',
	handler:function(){
		AddNewRow()
	} 
})
function AddNewRow(){
	var record=Ext.data.Record.create([
		{
			name:'GrpId',
			type:'int'
		},{
			name:'GrpCode',
			type:'string'
		},{
			name:'GrpDesc',
			type:'string'
		}
	]);
	var NewRecord=new record({
		GrpId:'',
		GrpCode:'',
		GrpDesc:''
	});
	LocClaGrpStore.add(NewRecord);
	LocClaGrpGrid.startEditing(LocClaGrpStore.getCount()-1,2)
}
var SaveButton=new Ext.ux.Button({
	text:'����',
	iconCls:'page_save',
	handler:function(){
		Save()
	}
})
function Save(){
	var ListDetail="";
	var rowCount=LocClaGrpGrid.getStore().getCount();
	for(i=0;i<rowCount;i++){
		var rowData=LocClaGrpStore.getAt(i);
		//���������ݷ����仯ʱִ����������
		if(rowData.data.newRecord||rowData.dirty){
		var RowId=rowData.get("GrpId"); 
		var Code=rowData.get("GrpCode");
		var Desc=rowData.get("GrpDesc")
		if (Code==""){
		    Msg.info("warning","���벻��Ϊ��!");
		    return;
		}	
		if (Desc==""){
		    Msg.info("warning","���Ʋ���Ϊ��!");
		    return;
		}
		var str=RowId+"^"+Code+"^"+Desc+"^"+loc
		 
		if(ListDetail==""){
		  ListDetail=str
		}else{
		  ListDetail=ListDetail+xRowDelim()+str
		}     
		}
	}
	
	if(ListDetail==""){
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var url = Url+"?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
							.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					LocClaGrpStore.load();
				}else{
					var ret=jsonData.info;
					if (ret=="-10"){
					Msg.info("error", "�����ظ���");
					}else if (ret=="-11"){
					Msg.info("error", "�����ظ���");
					}else{
					Msg.info("error", "���治�ɹ���"+ret);
					}
					
				}
			},
			scope : this
		});
	}

}
var DeleteButton=new Ext.ux.Button({
	text:'ɾ��',
	iconCls:'page_delete',
	handler:function(){
		Delele()
	}
})
function Delele(){
	var cell=LocClaGrpGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","��ѡ������!");
		return false;
		}else{
			var record=LocClaGrpGrid.getStore().getAt(cell[0]);
			var RowId=record.get("GrpId")
			if (RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ�����в�ɾ��������ϸ?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:Url+'?actiontype=Delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										LocClaGrpGrid.getStore().load()
										refresh()
									}else{
										Msg.info("error", "ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
				
				}else{
					var rowInd=cell[0];
					if(rowInd>=0){
						LocClaGrpGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}

}
var LocClaGrpCm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
    	header:'GrpId',
    	dataIndex:'GrpId',
    	align:'left',
    	width:100,
    	sortable:true, 
 	    hidden:true
    },{
    	header:'�������',
    	dataIndex:'GrpCode',
    	align:'left',
    	width:100,
    	editor:new Ext.form.TextField({
    		id:'GrpCode',
    		allowBlank:false,
    		listeners:{
			    specialKey:function(field,e){
    	   	 if(e.getKey()==Ext.EventObject.ENTER){
    	   	   LocClaGrpGrid.startEditing(LocClaGrpStore.getCount()-1,3);
    	   	     }
    	        }	    
			   }
    	})
    },{
    	header:'��������',
    	dataIndex:'GrpDesc',
    	align:'left',
    	width:100,
    	editor:new Ext.form.TextField({
    		id:'GrpDesc',
    		allowBlank:false,
    		listeners:{
			    specialKey:function(field,e){
    	   	 if(e.getKey()==Ext.EventObject.ENTER){
    	   	       AddNewRow()
    	   	     }
    	        }	    
			   }
    	})
    
    }

 
])
//��ʼ��Ĭ��������
LocClaGrpCm.defaultSortable=true
//��������Դ
var Proxy=new Ext.data.HttpProxy({url:Url+'?actiontype=Query&Loc='+loc,method:'GET'});
var LocClaGrpStore=new Ext.data.Store({
    proxy:Proxy,
    autoLoad:true,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pagesize:300
    },[
     {name:'GrpId'},
     {name:'GrpCode'},
     {name:'GrpDesc'}
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
})
var	LocClaGrpGrid=new Ext.grid.EditorGridPanel({
	id:'LocClaGrpGrid',
	title:'����ά��',
	store:LocClaGrpStore,
	draggable:true,
	cm:LocClaGrpCm,
	tbar:[AddButton,SaveButton,DeleteButton],
	//sm:new Ext.grid.RowSelectionModel({rowSelect:'single'}),
	sm:new Ext.grid.CellSelectionModel({}),
	//stripeRows:true,
	//trackMouseOver:true,
	//clicksToEdit:1,
    loadMask:true
})
//���ҷ����鵥���¼�
LocClaGrpGrid.addListener("rowclick",function(grid,rowindex,e){
	var SelectRow=LocClaGrpStore.getAt(rowindex);
	GrpRowId=SelectRow.get("GrpId");
	ChooseStore.setBaseParam('rowid',GrpRowId);
	ChooseStore.load({params:{start:0,limit:PagingToolbar.pageSize}});


})
//���ҷ�����	

//��ѡ����

var url=Url+"?actiontype=QueryChoose"
var ChooseStore=new Ext.data.Store({
 	url:url,
 	pruneModifiedRecords:true,
 	reader:new Ext.data.JsonReader(
 	{
 	   root:'rows',
		totalProperty:'results',
		id:'LcGiId'
 	},['LcGiId','Incidr','INCICode','INCIDesc','Spec'])
  	
 }) ;

var Choosecm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
 	{
 	header:'LcGiId',
 	dataIndex:'LcGiId',
 	align:'left',
 	width:100,
 	hidden:true
 },{
 	header:'Incidr',
 	dataIndex:'Incidr',
 	align:'left',
 	width:100,
 	hidden:true
 },{
 	header:'���ʴ���',
 	dataIndex:'INCICode',
 	align:'left',
 	width:90
 },{
 	header:'��������',
 	dataIndex:'INCIDesc',
 	align:'left',
 	width:165
 },{
 	header:'���',
 	dataIndex:'Spec',
 	align:'left',
 	width:50
 }
 ]
 );

var closeWin=new Ext.Button({
	text:'�رմ���',
	iconCls : 'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		window.close();
	}
});
var PagingToolbar = new Ext.PagingToolbar({
    store:ChooseStore,
    pageSize:30,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}����һ�� {2} ��',
    emptyMsg:"û�м�¼"
});
var ChooseGrid = new Ext.grid.GridPanel({
    id:'ChooseGrid',
    title:'��ѡ����(˫��ɾ��)..',
    //autoHeight:true,
    store:ChooseStore,
    draggable:true,
    cm:Choosecm,
    tbar : [closeWin],
    bbar:PagingToolbar,
    //sm:new Ext.grid.RowSelectionModel({rowSelect:'single'}),
    sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
    loadMask:true,
    listeners:{
 	   'rowdblclick':function(grid,ind){
 	   	   var reselectrow=grid.getSelectionModel().getSelected();
	 	   var rowid=reselectrow.get('LcGiId');
	 	   if (rowid=='') return;
	 	   DeleteGrpInci(rowid);		
 	}
 }
});



var LocFilter = new Ext.form.TextField({
    id:'LocFilter',
    fieldLabel:'����',
    allowBlank:true,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var FilterButton = new Ext.Toolbar.Button({
    text : '����',
    tooltip : '����',
    iconCls : 'page_gear',
    width : 70,
    height : 30,
    handler:function(){
    	var FilterDesc = Ext.getCmp("LocFilter").getValue();
		NotChooseGrid.getStore().setBaseParam('FilterDesc',FilterDesc);
		NotChooseGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
    }
});

var NotChoosecm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
	{
		header:'InRowId',
		hidden:true,
		dataIndex:'InRowId'
	},{
		header:'���ʴ���',
		dataIndex:'InCode',
		width:90,
		tooltip:'˫����ѡ��'
	},{
		header:'��������',
		dataIndex:'InDesc',
		width:160,
		tooltip:'˫����ѡ��'
	},{
		header:'���',
		dataIndex:'Inspec',
		width:80,
		tooltip:'˫����ѡ��'
	}
]);


var NotChooseurl=Url+"?actiontype=NotChoose&Loc="+loc;
var NotChoosestore = new Ext.data.Store({
	url:NotChooseurl,
	//autoLoad:true,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	},['InRowId',"InCode","InDesc","Inspec"])
});

var PagingToolbar2 = new Ext.PagingToolbar({
    store:NotChoosestore,
    pageSize:30,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}����һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

var NotChooseGrid = new Ext.grid.GridPanel({
	title:'��ѡ����(˫��ѡ��)...',
	autoHeigth:true,
	store:NotChoosestore,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	cm:NotChoosecm,
	bbar:PagingToolbar2,
	tbar:[LocFilter,FilterButton],
	listeners:{
		'rowdblclick':function(grid,ind){
			if(GrpRowId==null){
				Msg.info("warning","��ѡ�����!");
				return
			}
			var rec=grid.getStore().getAt(ind);
			var InRowId=rec.get('InRowId');
			Add(GrpRowId,InRowId);
		}
	}
});
NotChooseGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});

function Add(GrpRowId,InRowId){
	Ext.Ajax.request({
		url:Url+'?actiontype=addGrpInci&rowid='+GrpRowId+"&Inci="+InRowId,
		success:function(){
			refresh();
			Msg.info('success','���ӳɹ�!');
		},
		failure:function(){
			Msg.info('error','����ʧ��!');
		}
	})
}

function DeleteGrpInci(rowid)
{
	Ext.Ajax.request({
		url:Url+'?actiontype=deleteGrpInci&GrpiId='+rowid,
		success:function(){
			refresh();
			Msg.info('success','ɾ���ɹ�!');
		},
		failure:function(){
			Msg.info('error','ɾ��ʧ��!');
		}	
	})
}

function refresh()
{
	ChooseGrid.getStore().reload();
	NotChooseGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
	//NotChooseGrid.getStore().reload();
}
LocClaGrpGrid.getStore().load()
var window=new Ext.Window({
	title:'ά��������Ŀ����'+"("+locDesc+")",
	width:960,
	height:550,
	layout:'border',
	modal:true,
	resizable:false,
	items:[{region:'west',width: 230,layout:'fit',items:LocClaGrpGrid},
		{region:'center',layout:'fit',items:ChooseGrid},
		{region:'east',width: 380,layout:'fit',items:NotChooseGrid}]
})
 
window.show();
}