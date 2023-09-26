// 名称:请求单拒绝原因管理
// 编写日期:2016-5-20

//=========================请求单拒绝原因=============================    
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
//配置数据源
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

//模型
var ReasonForRefuseRequestGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"代码",
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
        header:"名称",
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

//初始化默认排序功能
ReasonForRefuseRequestGridCm.defaultSortable = true;

var addReasonForRefuseRequest = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveReasonForRefuseRequest = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //获取所有的新记录 
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
            Msg.info("error", "没有修改或添加新数据!");
            return false;
        }else{
            var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
            Ext.Ajax.request({
                url: ReasonForRefuseRequestGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                     mask.hide();
                    Msg.info("error", "请检查网络连接!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success", "保存成功!");
                        ReasonForRefuseRequestGridDs.load();
                    }else{
                        var date=jsonData.info
                        if(date==-5){
                        Msg.info("error", "代码重复!");}
                        else if(date==-6){
                        Msg.info("error", "名称重复!" );}
                        else{
                        Msg.info("error", "保存失败！" );}
                        ReasonForRefuseRequestGridDs.load();
                    }
                },
                scope: this
            });
        }
    }
});


var deleteReasonForRefuseRequest = new Ext.Toolbar.Button({
    text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = ReasonForRefuseRequestGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error", "请选择数据!");
            return false;
        }else{
            var record = ReasonForRefuseRequestGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('提示','确定要删除选定的行?',
                    function(btn) {
                        if(btn == 'yes'){
                            var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
                            Ext.Ajax.request({
                                url:ReasonForRefuseRequestGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'删除中...',
                                failure: function(result, request) {
                                     mask.hide();
                                    Msg.info("error", "请检查网络连接!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                    if (jsonData.success=='true') {
                                        Msg.info("success", "删除成功!");
                                        ReasonForRefuseRequestGridDs.load();
                                    }else{
                                        Msg.info("error", "删除失败!");
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                )
            }else{
                Msg.info("error", "数据有错,没有RowId!");
            }
        }
    }
});

//表格
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
//=========================请求单拒绝原因=============================

//===========模块主页面===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var panel = new Ext.Panel({
        title:'请求单拒绝原因',
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
//===========模块主页面===============================================