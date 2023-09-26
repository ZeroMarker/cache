// 名称:定价类型
// 编写日期:2012-06-5
//=========================定义全局变量=================================
var MarkTypeId = "";
//=========================定义全局变量=================================
//=========================定价类型=================================

var UFlag = new Ext.grid.CheckColumn({
    header:'是否使用',
    dataIndex:'UseFlag',
    width:150,
    sortable:true,
    renderer:function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
});

var ZFlag = new Ext.grid.CheckColumn({
    header:'是否中标',
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
//配置数据源
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

//模型
var MarkTypeGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"代码",
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
        header:"名称",
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

//初始化默认排序功能
MarkTypeGridCm.defaultSortable = true;

var addMarkType = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveMarkType = new Ext.Toolbar.Button({
    text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //获取所有的新记录 
        var mr=MarkTypeGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){ 
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            if (code==""){
	        	Msg.info("warning","代码为空");
	        	return;
	        }
            if (desc==""){
	        	Msg.info("warning","名称为空");
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
            Msg.info("warning","没有修改或添加新数据!");
            return false;
        }else{
        	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
            Ext.Ajax.request({
                url: MarkTypeGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                	 mask.hide();
                    Msg.info("error","请检查网络连接!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success","保存成功!");
                        MarkTypeGridDs.load();
                    }else{
	                    if(jsonData.info==-1){
							Msg.info("warning", "代码重复!");
						}else if(jsonData.info==-2){
							Msg.info("warning", "名称重复!");
						}else{
							Msg.info("error", "保存失败!");
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
    text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = MarkTypeGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error","请选择数据!");
            return false;
        }else{
            var record = MarkTypeGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('提示','确定要删除选定的行?',
                    function(btn) {
                        if(btn == 'yes'){
                        	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
                            Ext.Ajax.request({
                                url:MarkTypeGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'删除中...',
                                failure: function(result, request) {
                                	 mask.hide();
                                    Msg.info("error","请检查网络连接!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                    if (jsonData.success=='true') {
                                        Msg.info("success","删除成功!");
                                        MarkTypeGridDs.load();
                                    }else{
                                        Msg.info("error","删除失败!");
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                )
            }else{
                //Msg.info("error","数据有错!");
                var rowInd=cell[0];      
                if (rowInd>=0) MarkTypeGrid.getStore().removeAt(rowInd);                        
            }
        }
    }
});

//表格
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
//=========================定价类型=================================

//===========模块主页面=================================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
   
    var MarkTypePanel = new Ext.Panel({
	    id:"MarkTypePanel",
        title:'定价类型',
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
//===========模块主页面=================================================