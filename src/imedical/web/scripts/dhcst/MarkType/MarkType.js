// ����:��������
// ��д����:2012-06-5
//=========================����ȫ�ֱ���=================================
var MarkTypeId = "";
//=========================����ȫ�ֱ���=================================
//=========================��������=================================

var UFlag = new Ext.grid.CheckColumn({
    header:'�Ƿ�ʹ��',
    dataIndex:'UseFlag',
    width:150,
    sortable:true,
    renderer:function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
});

var ZFlag = new Ext.grid.CheckColumn({
    header:'�Ƿ��б�',
    dataIndex:'ZbFlag',
    width:150,
    sortable:true,
    renderer:function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
});

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
        }, {
            name : 'ZbFlag',
            type : 'string'
        }, {
            name : 'UseFlag',
            type : 'string'
        }
    ]);
    
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:'',
        ZbFlag:'',
        UseFlag:''
    });
                    
    MarkTypeGridDs.add(NewRecord);
    MarkTypeGrid.startEditing(MarkTypeGridDs.getCount() - 1, 1);
}

var MarkTypeGrid="";
//��������Դ
var MarkTypeGridUrl = 'dhcst.marktypeaction.csp';
var MarkTypeGridProxy= new Ext.data.HttpProxy({url:MarkTypeGridUrl+'?actiontype=selectAll',method:'GET'});
var MarkTypeGridDs = new Ext.data.Store({
    proxy:MarkTypeGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
        {name:'RowId'},
        {name:'Code'},
        {name:'Desc'},
        {name:'ZbFlag'},
        {name:'UseFlag'}
    ]),
    pruneModifiedRecords : true,
    remoteSort:false
});

//ģ��
var MarkTypeGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"����",
        dataIndex:'Code',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'codeField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkTypeGrid.startEditing(MarkTypeGridDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },{
        header:"����",
        dataIndex:'Desc',
        width:150,
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
    },ZFlag,UFlag
]);

//��ʼ��Ĭ��������
MarkTypeGridCm.defaultSortable = true;

var addMarkType = new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveMarkType = new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //��ȡ���е��¼�¼ 
        var mr=MarkTypeGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){ 
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            if (code==""){
	        	Msg.info("warning","����Ϊ��");
	        	return;
	        }
            if (desc==""){
	        	Msg.info("warning","����Ϊ��");
	        	return;
	        }
            var useFlag = mr[i].data["UseFlag"];
            var zbFlag = mr[i].data["ZbFlag"];
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+zbFlag+"^"+useFlag;
                if(data==""){
                    data = dataRow;
                }else{
                    data = data+xRowDelim()+dataRow;
                }
            }
        }
        
        if(data==""){
            Msg.info("warning","û���޸Ļ����������!");
            return false;
        }else{
        	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
            Ext.Ajax.request({
                url: MarkTypeGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                	 mask.hide();
                    Msg.info("error","������������!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success","����ɹ�!");
                        MarkTypeGridDs.load();
                    }else{
	                    if(jsonData.info==-1){
							Msg.info("warning", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("warning", "�����ظ�!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
						MarkTypeGridDs.load();
                    }
                },
                scope: this
            });
        }
    }
});

var deleteMarkType = new Ext.Toolbar.Button({
    text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = MarkTypeGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error","��ѡ������!");
            return false;
        }else{
            var record = MarkTypeGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
                    function(btn) {
                        if(btn == 'yes'){
                        	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
                            Ext.Ajax.request({
                                url:MarkTypeGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                	 mask.hide();
                                    Msg.info("error","������������!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                    if (jsonData.success=='true') {
                                        Msg.info("success","ɾ���ɹ�!");
                                        MarkTypeGridDs.load();
                                    }else{
                                        Msg.info("error","ɾ��ʧ��!");
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                )
            }else{
                //Msg.info("error","�����д�!");
                var rowInd=cell[0];      
                if (rowInd>=0) MarkTypeGrid.getStore().removeAt(rowInd);                        
            }
        }
    }
});

//���
MarkTypeGrid = new Ext.grid.EditorGridPanel({
    store:MarkTypeGridDs,
    cm:MarkTypeGridCm,
    trackMouseOver:true,
    height:770,
    stripeRows:true,
    plugins:[UFlag,ZFlag],
    clicksToEdit:0,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    tbar:[addMarkType,'-',saveMarkType,'-',deleteMarkType],
    clicksToEdit:1
});

MarkTypeGridDs.load();

var HospPanel = InitHospCombo('DHC_MarkType',function(combo, record, index){
	HospId = this.value; 
	MarkTypeGridDs.reload();
});
//=========================��������=================================

//===========ģ����ҳ��=================================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
   
    var MarkTypePanel = new Ext.Panel({
	    id:"MarkTypePanel",
        title:'��������',
        activeTab: 0,
        region:'center',
        items:[MarkTypeGrid]                                 
    });
    var mainPanel = new Ext.Viewport({
        layout:'border',
        items:[HospPanel, MarkTypePanel],
        renderTo:'mainPanel'
    });
	
});
//===========ģ����ҳ��=================================================