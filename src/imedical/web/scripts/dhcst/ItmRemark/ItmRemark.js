/**
 *  ����:	 ��׼�ĺ�ǰ׺ά��
 *  ��д��:  yunhaibao
 *  ��д����:2018-01-18
*/

function addNewRow() {
	var record = Ext.data.Record.create([{
			name : 'Desc',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		Desc:''
	});
					
	ItmRemarkGridDs.add(NewRecord);
	ItmRemarkGrid.startEditing(ItmRemarkGridDs.getCount() - 1, 1);
}
	
var ItmRemarkGrid="";
//��������Դ
var ItmRemarkUrl = 'dhcst.itmremark.action.csp';
var ItmRemarkGridProxy= new Ext.data.HttpProxy({url:ItmRemarkUrl+'?actiontype=Query',method:'POST'});
var ItmRemarkGridDs = new Ext.data.Store({
	proxy:ItmRemarkGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'Desc'}
	]),
    remoteSort:false
});

//ģ��
var ItmRemarkGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    }
]);

//��ʼ��Ĭ��������
ItmRemarkGridCm.defaultSortable = true;
var addItmRemark = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmRemark = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:Save
});

function Save(){
	//��ȡ���е��¼�¼ 
	var records=ItmRemarkGridDs.getCount();
	var dataArr=[];
	for(var i=0;i<records;i++){
		var desc = ItmRemarkGridDs.getAt(i).get("Desc").trim();
		if(desc!=""){
			if (dataArr.indexOf(desc)<0){
				dataArr.push(desc);
			}
		}
	}
	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
	Ext.Ajax.request({
		url: ItmRemarkUrl+'?actiontype=Save',
		params:{listData:dataArr.join("^")},
		failure: function(result, request) {
			mask.hide();
			Msg.info("error", "������������!");
			ItmRemarkGridDs.commitChanges();
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			 mask.hide();
			if (jsonData.success=='true') {
				Msg.info("success", "����ɹ�!");
			}else{
			}
			ItmRemarkGridDs.commitChanges();
			ItmRemarkGridDs.load();
		},
		scope: this
	});
}

var deleteItmRemark = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ItmRemarkGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning", "��ѡ������!");
			return false;
		}else{
			var record = ItmRemarkGrid.getStore().getAt(cell[0]);
			ItmRemarkGridDs.remove(record);
			Save();
		}
    }
});

//���
ItmRemarkGrid = new Ext.grid.EditorGridPanel({
	store:ItmRemarkGridDs,
	cm:ItmRemarkGridCm,
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmRemark,'-',saveItmRemark,'-',deleteItmRemark],
	clicksToEdit:1,
	height:770
});

ItmRemarkGridDs.load();

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'��׼�ĺ�ǰ׺ά��',
		region:'center',
		items:[ItmRemarkGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
});