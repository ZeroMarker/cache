// ����:���󵥾ܾ�ԭ�����
// ��д����:2016-5-20

//=========================���󵥾ܾ�ԭ��=============================    
function addNewRow() {
    var record = Ext.data.Record.create([
        {
            name : 'RowId',
            type : 'int'
        }, {
            name : 'Code',
            type : 'string'
        }, {
            name : 'Desc',
            type : 'string'
        }
    ]);
                    
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:''
    });
                    
    ReasonForRefuseRequestGridDs.add(NewRecord);
    ReasonForRefuseRequestGrid.startEditing(ReasonForRefuseRequestGridDs.getCount() - 1, 1);
}
    
var ReasonForRefuseRequestGrid="";
//��������Դ
var ReasonForRefuseRequestGridUrl = 'dhcstm.reasonforrefuserequestaction.csp';
var ReasonForRefuseRequestGridProxy= new Ext.data.HttpProxy({url:ReasonForRefuseRequestGridUrl+'?actiontype=query',method:'GET'});
var ReasonForRefuseRequestGridDs = new Ext.data.Store({
    proxy:ReasonForRefuseRequestGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'RowId'},
        {name:'Code'},
        {name:'Desc'}
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var ReasonForRefuseRequestGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"����",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'codeField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        ReasonForRefuseRequestGrid.startEditing(ReasonForRefuseRequestGridDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },{
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
ReasonForRefuseRequestGridCm.defaultSortable = true;

var addReasonForRefuseRequest = new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveReasonForRefuseRequest = new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //��ȡ���е��¼�¼ 
        var mr=ReasonForRefuseRequestGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
                if(data==""){
                    data = dataRow;
                }else{
                    data = data+xRowDelim()+dataRow;
                }
            }
        }
        
        if(data==""){
            Msg.info("error", "û���޸Ļ����������!");
            return false;
        }else{
            var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
            Ext.Ajax.request({
                url: ReasonForRefuseRequestGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                     mask.hide();
                    Msg.info("error", "������������!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success", "����ɹ�!");
                        ReasonForRefuseRequestGridDs.load();
                    }else{
                        var date=jsonData.info
                        if(date==-5){
                        Msg.info("error", "�����ظ�!");}
                        else if(date==-6){
                        Msg.info("error", "�����ظ�!" );}
                        else{
                        Msg.info("error", "����ʧ�ܣ�" );}
                        ReasonForRefuseRequestGridDs.load();
                    }
                },
                scope: this
            });
        }
    }
});


var deleteReasonForRefuseRequest = new Ext.Toolbar.Button({
    text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = ReasonForRefuseRequestGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error", "��ѡ������!");
            return false;
        }else{
            var record = ReasonForRefuseRequestGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
                    function(btn) {
                        if(btn == 'yes'){
                            var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
                            Ext.Ajax.request({
                                url:ReasonForRefuseRequestGridUrl+'?actiontype=delete&rowid='+RowId,
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
                                        ReasonForRefuseRequestGridDs.load();
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
                Msg.info("error", "�����д�,û��RowId!");
            }
        }
    }
});

//���
ReasonForRefuseRequestGrid = new Ext.grid.EditorGridPanel({
    id : 'ReasonForRefuseRequestGrid',
    store:ReasonForRefuseRequestGridDs,
    cm:ReasonForRefuseRequestGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    tbar:[addReasonForRefuseRequest,'-',saveReasonForRefuseRequest],    //,'-',deleteReasonForRefuseRequest
    clicksToEdit:1
});

ReasonForRefuseRequestGridDs.load();
//=========================���󵥾ܾ�ԭ��=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
        title:'���󵥾ܾ�ԭ��',
        activeTab:0,
        region:'center',
        layout:'fit',
        items:[ReasonForRefuseRequestGrid]                                 
    });
    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[panel],
        renderTo:'mainPanel'
    });
});
//===========ģ����ҳ��===============================================