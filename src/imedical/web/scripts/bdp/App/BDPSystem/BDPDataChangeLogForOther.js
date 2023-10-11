/// 名称: 码表数据日志管理
/// 编写者: 基础数据平台组  sunfengchao  
/// 编写日期: 2013-1-29
///   增加查看日志时双击弹出窗口，动态生成列表功能
 //******************** 菜单树级联设置 ****************************//
document.write('<style> .x-grid3-cell-inner {white-space:normal; !important;} </style>'); //内容长的时候换行  
document.write('<script type="text/javascript" src="../scripts/bdp/App/BDPSystem/RowExpander.js"> </script>');
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
 /// 获取到表的 ID
var UserClass=Ext.getUrlParam('UserClass'); 
var ClassN=Ext.getUrlParam('ClassN');
var OBJDESC=Ext.getUrlParam('OBJDESC');
var ObjectId=Ext.getUrlParam('ObjectId'); /// 字典数据id
Ext.onReady(function() {
    Ext.QuickTips.init();
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLogForOther&pClassMethod=GetList";
    
    /*************************************grid数据存储 *****************************************/ 
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : QUERY_ACTION_URL  
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                                    name : 'ID',
                                    mapping : 'ID',
                                    type : 'string'
                                }, {
                                    name : 'IpAddress',
                                    mapping : 'IpAddress',
                                    type : 'string'
                                } ,{
                                    name : 'TableName',
                                    mapping : 'TableName',
                                    type : 'string'
                                }, {
                                    name : 'ClassName',
                                    mapping : 'ClassName',
                                    type : 'string'
                                }, {
                                    name : 'ClassNameDesc',
                                    mapping : 'ClassNameDesc',
                                    type : 'string'
                                }, {
                                    name : 'ObjectReference',
                                    mapping : 'ObjectReference',
                                    type : 'string'
                                }, {
                                    name : 'ObjectDesc',
                                    mapping : 'ObjectDesc',
                                    type : 'string'
                                }, {
                                    name : 'UpdateUserDR',
                                    mapping : 'UpdateUserDR',
                                    type : 'string'
                                }, {
                                    name : 'UpdateUserName',
                                    mapping : 'UpdateUserName',
                                    type : 'string'
                                }, {
                                    name : 'UpdateDate',
                                    mapping : 'UpdateDate',
                                    type : 'date',
                                    dateFormat : 'm/d/Y'
                                }, {
                                    name : 'UpdateTime',
                                    mapping : 'UpdateTime',
                                    type : 'time'
                                }, {
                                    name : 'OperateType',
                                    mapping : 'OperateType',
                                    type : 'string'
                                } ,{
                                    name:'RelevantKey',
                                    mapping:'RelevantKey',
                                    type:'string'
                                }
                        ])
            });
 
    /***************************************grid加载数据 ********************************/
    ds.load({
        params : {  
                    ClassN:ClassN, 
                    OBJDESC : OBJDESC, 
                    UserClass:UserClass,
                    ObjectId:ObjectId,
                    start : 0,
                    limit : pagesize_main
                } 
        });
    /****************************************grid分页工具条******************************/
    var paging = new Ext.PagingToolbar({
                pageSize : pagesize_main,
                store : ds,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                emptyMsg : "没有记录",
                //plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                    "change":function (t,p) {
                        pagesize_main=this.pageSize;
                          grid.getStore().baseParams={            
                            UserClass : UserClass,
                            ClassN:ClassN,
                            OBJDESC :OBJDESC,
                            ObjectId:ObjectId
                        };
                    }
                }
            });
   
/******************************数据生命周期********************************************/
    var DataLiftBtn=new Ext.Button({
                id:'DataLiftBtn',
                disabled:Ext.BDP.FunLib.Component.DisableFlag('DataLiftBtn'),
                text:'数据生命周期' ,
                icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',
                handler:function(){
                    var gsm = grid.getSelectionModel(); 
                    var rows = gsm.getSelections(); 
                    if(rows.length>0){
                        var ObjectReference1= rows[0].get('ObjectReference');
                        var ClassName1=rows[0].get('ClassName');
                        var ObjectDesc1=rows[0].get('ObjectDesc');   
                        var Log_Win = new Ext.Window({
                                        title:'数据生命周期->'+ObjectDesc1,
                                        width :1000,
                                        height :420,
                                        layout : 'fit',
                                        plain : true, 
                                        modal : true,
                                        frame : true,
                                        constrain : true,
                                        closeAction : 'hide'  
                            });
						var url="dhc.bdp.bdp.timeline.csp?actiontype=timeline&ClassN="+ClassName1+"&OBJDESC="+ObjectReference1+"&ObjectDesc="+ObjectDesc1;
						if ('undefined'!==typeof websys_getMWToken)
						{
							url += "&MWToken="+websys_getMWToken() //增加token
						}
						var url=encodeURI(url) 
                        Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
                        Log_Win.show();
					}
					else{
                        Ext.Msg.show({
                                        title:'提示',
                                        minWidth:280,
                                        msg:'请选择需要查看的数据行!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    }); 
                        }
                    }
            });
            
    var datadetailbtn=new Ext.Button({
            id:'LookUpDataDetail',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('LookUpDataDetail'),
            text:'查看数据详情' ,
            iconCls : 'icon-DP',
            handler:function()
            {
                var gsm = grid.getSelectionModel(); 
                var rows = gsm.getSelections(); 
                if(rows.length>0)
                {
                    var ClassUserName=grid.selModel.getSelections()[0].get('ClassName');
                    var ClassUserNameDesc=grid.selModel.getSelections()[0].get('ClassNameDesc');
                    var Operation=grid.selModel.getSelections()[0].get('OperateType');
                    if(Operation=="U"){
                        Operation="修改操作"            
                    }
                    if(Operation=="A"){
                        Operation="添加操作"            
                    }
                    if(Operation=="D"){
                        Operation="删除操作"            
                    }
                    if ((ClassUserName!="User.BDPTableList")&&(ClassUserName!="User.BDPPreferences"))
                    {  
                        var Log_Win = new Ext.Window
                        ({
                                    title:ClassUserNameDesc+'->'+Operation,
                                    width :990,
                                    height :400,
                                    layout : 'fit',
                                    plain : true, 
                                    modal : true,
                                    frame : true, 
                                    constrain : true,
                                    closeAction : 'hide'  
                            });
							var url="dhc.bdp.bdp.timeline.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('ID');
							if ('undefined'!==typeof websys_getMWToken)
							{
								url += "&MWToken="+websys_getMWToken() //增加token
							} 
							var url=encodeURI(url) 
                            Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
                            Log_Win.show();
                        }
                        else
                        { 
                             try
                             {
                                var OldValueJson=""
                                var redata =""
                                var id=grid.selModel.getSelections()[0].get('ID');
                                var ShowOperate=grid.selModel.getSelections()[0].get('OperateType'); 
                                var UserClass=grid.selModel.getSelections()[0].get("ClassName");
                                var ClassNameDesc = grid.selModel.getSelections()[0].get('ClassNameDesc');
                                var showTitleName=ClassNameDesc 
                                var returnJson=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetDataDetail",id);
                                var objectJson=eval('(' + returnJson + ')');
                                var newdata =objectJson.NewValue    
                                /// 再次调用后台json数据 
                                /// 正常情况下,NewValue 是非空的 
                                if (newdata!=""){
                                    var jsondata = eval('(' + newdata + ')');
                                    var newjson = "{";
                                    var oldjson2="{";
                                    var olddata= objectJson.OldValue            
                                     /// 原始数据存在  undefined 情况未处理？？捕获异常后抛出异常
                                    if (olddata!=""){ 
                                        //修改 :存在一种情况：操作是修改，但是没有OldValue,只有 NewValue
                                         var oldjson= eval('('+olddata+')')
                                         redata = [oldjson,jsondata]
                                    }
                                    else{
                                        ////olddata 为空
                                         redata = [jsondata]
                                    }
                                for(var x in jsondata)
                                {
                                    if (newjson!= "{")
                                    {
                                        newjson = newjson + ","
                                    }
                                    if (oldjson2!= "{")
                                    {
                                        oldjson2 = oldjson2 + ","
                                    }
                                    /// 获取属性
                                    var Property=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropDescByCode",UserClass,x);
                                    var PropertyData=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,jsondata[x]);
                                    PropertyData=PropertyData.substring(1,(PropertyData.length-1));
                                    var res = {fields:[{name:""+x+""}],columns:[{header:""+Property+"",dataIndex:""+x+"",width:130,sortable:true}]};  
                                    var columns = res.columns;
                                    var fields = res.fields;
                                    for (var i = 0; i < fields.length; i++) {
                                        Detailfd.push(fields[i].name);
                                        DetailCM.push(columns[i]);
                                    }
                                    if(olddata!=""){
                                        var PropertyDataY=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,oldjson[x]);
                                        PropertyDataY=PropertyDataY.substring(1,(PropertyDataY.length-1));
                                        // 原始数据与现数据进行比较
                                        if(PropertyDataY!=PropertyData)
                                        { ///bordeR-bottom:20px solid blue;   bordeR-bottom:20px solid red; 
                                            newjson = newjson + x+":"+'"<span style='+"'color:Red;bold:true;text-decoration:none'"+'>'+PropertyData +'</span>"' 
                                            oldjson2= oldjson2 + x+":"+'"<span style='+"'color:blue;bold:true; text-decoration:none'"+'>'+PropertyDataY +'</span>"' 
                                        }
                                        else
                                        {
                                            newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                            oldjson2= oldjson2+ x+":"+'"'+PropertyDataY +'"'    
                                        }       
                                    }
                                    else{ /// 如果是 添加或者删除时，进行拼串
                                        newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                    }
                                }
                            var newjson = newjson + "}";
                            var newjsondata = eval('(' + newjson + ')');
                            
                            var oldjson = oldjson2 + "}";
                            var oldjson = eval('(' + oldjson + ')');
                            win.show();
                        }
                        else{
                            ///  newdata为空的情况 : 直接进入 异常捕获了，没有进行下一步的执行。  
                            Ext.getCmp('UpdateDataText').setValue(OldValue);
                        }
                     
                        var ss=new Ext.data.JsonStore({ 
                            fields:Detailfd  
                        })  
                        DetailGrid.reconfigure(ss,new Ext.grid.ColumnModel(DetailCM));
                        if(olddata!=""){
                            ss.loadData([oldjson,newjsondata]);  
                            win.setIconClass("icon-update")
                            win.setTitle(showTitleName+"      "+"修改数据：第一行为原始数据，第二行为修正后数据")
                        }
                        else{
                            if(ShowOperate=="U"){
                                ss.loadData([newjsondata])
                                win.setTitle(showTitleName+"     "+"修改数据：修正后数据")
                                win.setIconClass("icon-update")
                            }
                            
                            if (ShowOperate=="A"){
                                ss.loadData([newjsondata])
                                win.setTitle(showTitleName+"     "+"添加数据")
                                win.setIconClass("icon-add")
                            }
                           if (ShowOperate=="D"){
                                ss.loadData([newjsondata])
                                win.setTitle(showTitleName+"      "+"删除数据")
                                win.setIconClass("icon-delete")
                            }  
                          } 
                     }
                        catch (e) 
                        {
                        /// 捕获异常后
                            if((newdata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata);
                            }
                            if((olddata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata); 
                            }
                            if((ShowOperate=="A")||(ShowOperate=="D")){
                                if(newdata!=""){
                                    Ext.getCmp('UpdateDataText').setValue(newdata); 
                            }
                        }
                          win2.show()  
                        }
                    }
                }
                else{
                    Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'请选择需要查看的数据行!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        }); 
                    }
                }
            });
            
     
/** ****************************************搜索按钮 ********************************/
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                iconCls : 'icon-search',
                text : '搜索',
                handler :search=function() {
                    grid.getStore().baseParams={ 
                            OBJDESC : OBJDESC,  // 数据rowid
							ObjectId:ObjectId,
                            UserClass:UserClass 
                    };
                    grid.getStore().load({
                        params : { 
                                    UserDR : Ext.getCmp("UpdateUserDR").getValue(),
                                    datefrom : Ext.getCmp("datefrom").getValue()===""?"":Ext.getCmp("datefrom").getValue().format(BDPDateFormat),
                                    dateto : Ext.getCmp("dateto").getValue()===""?"":Ext.getCmp("dateto").getValue().format(BDPDateFormat),
                                    OperateTypeD:Ext.getCmp('OperateType').getValue(),
                                    start : 0,
                                    limit : pagesize_main
                                }
                        });
                    }
            });
    
    /** ************************************重置按钮 ********************************************/
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                iconCls : 'icon-refresh',
                text : '重置',
                handler : refresh=function() {  
                    Ext.getCmp("UpdateUserDR").reset();
                    Ext.getCmp("datefrom").reset();
                    Ext.getCmp("dateto").reset(); 
                    Ext.getCmp('OperateType').reset();
                    str="";
                    grid.getStore().baseParams={            
                            UserClass : UserClass,
                            ClassN:ClassN,
                            OBJDESC :OBJDESC,
							ObjectId:ObjectId,
                        };
                    grid.getStore().load({
                        params : { 
                                    start : 0,
                                    limit : pagesize_main
                                }
                            });
                    }
            });
  
    /** **********************************搜索工具条 **************************************/
    var tbbutton = new Ext.Toolbar({
            enableOverflow : true 
        });
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : [ 
                        '操作日期', {
                            width : 80,
                            xtype : 'datefield',
                            id : 'datefrom', 
                            format :BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
                        },
                        '到', {
                            width : 80,
                            xtype : 'datefield',
                            id : 'dateto', 
                            format :BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
                        }, '操作人ID/操作人', {
                            width :77,
                            xtype : 'textfield',
                            id : 'UpdateUserDR', 
                            listeners: {
                                specialkey: function(f,e){
                                         if (e.getKey() == e.ENTER) {
                                             search();
                                         }
                                          if (e.getKey() == e.ESC) {
                                            refresh()
                                         }
                                }
                             } 
                        },'-',
                        '操作类型',{
                             width : 80,
                             xtype:'combo',
                             id:'OperateType',
                             store:new Ext.data.SimpleStore({
                             fields:['OperateType','value'],
                             data:[
                                  ['A','添加'],
                                  ['D','删除'],
                                  ['U','修改']
                                ]
                           }),
                           displayField:'value',
                           valueField:'OperateType',
                           mode:'local',
                           triggerAction:'all',
                           listeners:{
                            'select':search
                           }
                    } ,btnSearch, '-', btnRefresh, '-',datadetailbtn,'-',DataLiftBtn  
                ] ,
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar);
                    }
                }
            }); 
    /** ***********************************创建grid ****************************************/
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center', 
                trackMouseOver : true,  
                columnLines : true,
                store : ds,
                stripeRows : true,
                stateful : true,
                viewConfig : {
                    forceFit: true,  
                    scrollOffset: 0 , 
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
                    autoFill:true,
                    enableRowBody: true  
                },
                sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
                columns : [new Ext.grid.CheckboxSelectionModel(),  
                         {
                            header : 'ID',
                            sortable : true,
                            dataIndex : 'ID',
                            width : 20,
                            hidden : true
                        },{
                            header:'关联key',
                            sortable:true,
                            dataIndex:'RelevantKey',
                            width :50
                        },{
                            header : '功能描述',
                            sortable : true,
                            dataIndex : 'ClassNameDesc', 
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width : 70
                        },{
                            header : '表名称',
                            hidden:true,
                            sortable : true,
                            dataIndex : 'TableName',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width : 60
                        }, {
                            header : '类名称',
                            sortable : true,
                            hidden:true,
                            dataIndex : 'ClassName',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width :70
                        },{
                            header : '对象ID',
                            sortable : true,
                            dataIndex : 'ObjectReference',
                            width : 30
                        },{
                            header : '对象描述',
                            sortable : true,
                            width:70,
                            dataIndex : 'ObjectDesc'
                        }, {
                            header : '操作人 ',
                            sortable : true,
                            dataIndex : 'UpdateUserName',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width:55
                        }, {
                            header : '操作类型',
                            sortable : true,
                            dataIndex : 'OperateType',
                            width : 40,
                            renderer : function(v){ 
                                if(v=='U'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"update.gif''>"+"   修改";}
                                if(v=='D'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"delete.gif''>"+"   删除";}
                                if(v=='A'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"add.gif''>"+"   添加";}
                            }
                        } , {
                            header : '操作人IP',
                            sortable : true,
                            dataIndex : 'IpAddress',
                            width : 60
                        },  {
                            header : '操作人ID',
                            sortable : true,
                            hidden:true,
                            width:35,
                            dataIndex : 'UpdateUserDR'
                        }, {
                            header : '操作日期',
                            sortable : true,
                            renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex : 'UpdateDate',
                            width:65
                        }, {
                            header : '操作时间',
                            sortable : true,
                            dataIndex : 'UpdateTime',
                            width:65
                        }],
                monitorResize: true,
                doLayout: function() {
                    this.setSize(Ext.get(this.getEl().dom.parentNode).getSize(true));
                    Ext.grid.GridPanel.prototype.doLayout.call(this);
               },
                bbar : paging,
                tbar : tb,
                stateId : 'grid'
            });
 
 /*******************************动态生成列表格******************************************/
    var DetailCM=[] 
    var Detailfd = [];
    var DetailsDs=new Ext.data.JsonStore({
        fields:Detailfd
  });
 
 var DetailGrid=new Ext.grid.GridPanel({
       columns:DetailCM,
       store:DetailsDs,
       width:1000,
       height:400,
       autoScroll:true
    });
 
    var win = new Ext.Window({
        width : 1000,
        layout : 'fit',
        plain : true,
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        buttonAlign : 'center',
        closeAction : 'hide',
        items :[DetailGrid],
        viewConfig : {
                    forceFit: true, // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化(比如你resize了它)时不会自动调整column的宽度
                    scrollOffset: 0 ,//不加这个的话,会在grid的最右边有个空白,留作滚动条的位置
                    autoFill:true,
                    enableRowBody: true  
                },
        listeners : {
                "show" : function() {
                                 
                },
                "hide" : function(){
                          DetailCM = [] 
                          Detailfd = [];  
                          win.hide()
                    }
                }    
            });
            
////无法解析json时的弹出窗口
var win2 = new Ext.Window({
        title : '修正的数据',
        width : 600,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        autoScroll : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        buttonAlign : 'center',
        closeAction : 'hide',
        items : [new Ext.form.TextArea({
                id : 'UpdateDataText',
                readOnly : true,
                width : 600,
                height : 300
        })]
    });
    
/*********************日志的原始数据与修正数据进行比对，颜色显示**********************************************/
    grid.on("rowdblclick", function(grid, rowIndex, e){
        var gsm = grid.getSelectionModel(); 
        var rows = gsm.getSelections(); 
        var Operation=grid.selModel.getSelections()[0].get('OperateType');
        if(Operation=="U"){
            Operation="修改操作"            
        }
        if(Operation=="A"){
            Operation="添加操作"            
        }
        if(Operation=="D"){
            Operation="删除操作"            
        }
        if(rows.length>0)
        {
            var ClassUserName=grid.selModel.getSelections()[0].get('ClassName');
            if ((ClassUserName!="User.BDPPreferences")&&(ClassUserName!="User.BDPTableList"))
            {
               
                
                var Log_Win = new Ext.Window
                ({
                    title:grid.selModel.getSelections()[0].get('ClassNameDesc')+"->"+Operation,
                    width :990,
                    height :400,
                    layout : 'fit',
                    plain : true, 
                    modal : true,
                    frame : true,
                    // autoScroll : true,
                    constrain : true,
                    closeAction : 'hide'  
                    });
					var url="dhc.bdp.bdp.timeline.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('ID');
					if ('undefined'!==typeof websys_getMWToken)
					{
						url += "&MWToken="+websys_getMWToken() //增加token
					}
					var url=encodeURI(url)
                    Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
                    Log_Win.show();
                }
                else
                {
                    try
                    {
                        var OldValueJson=""
                        var redata =""
                        var record = grid.getSelectionModel().getSelected();
                        var id=record.get('ID');
                        var ShowOperate=record.get('OperateType'); 
                        var UserClass=record.get("ClassName");
                        var ClassNameDesc = record.get('ClassNameDesc');
                        var showTitleName=ClassNameDesc 
                        var returnJson=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDataDetail",id);
                        var objectJson=eval('(' + returnJson + ')');
                        var newdata =objectJson.NewValue    
                        /// 再次调用后台json数据 
                        
                        /// 正常情况下,NewValue 是非空的 
                        if (newdata!=""){
                            var jsondata = eval('(' + newdata + ')');
                            var newjson = "{";
                            var oldjson2="{";
                            var olddata= objectJson.OldValue     /// record.get('OldValue');        
                       
                             /// 原始数据存在  undefined 情况未处理？？捕获异常后抛出异常
                            if (olddata!=""){ 
                                //修改 :存在一种情况：操作是修改，但是没有OldValue,只有 NewValue
                                 var oldjson= eval('('+olddata+')')
                                 redata = [oldjson,jsondata]
                            }
                            else{
                                ////olddata 为空
                                 redata = [jsondata]
                            }
                            for(var x in jsondata)
                            {
                                
                                if (newjson!= "{")
                                {
                                    newjson = newjson + ","
                                }
                                if (oldjson2!= "{")
                                {
                                    oldjson2 = oldjson2 + ","
                                }
                                /// 获取属性
                                var Property=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropDescByCode",UserClass,x);
                                var PropertyData=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,jsondata[x]);
                                
                                PropertyData=PropertyData.substring(1,(PropertyData.length-1));
                             
                                var res = {fields:[{name:""+x+""}],columns:[{header:""+Property+"",dataIndex:""+x+"",width:130,sortable:true}]};  
                                var columns = res.columns;
                                var fields = res.fields;
                                for (var i = 0; i < fields.length; i++) {
                                    Detailfd.push(fields[i].name);
                                    DetailCM.push(columns[i]);
                                }
                                if(olddata!=""){
                                    var PropertyDataY=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,oldjson[x]);
                                    PropertyDataY=PropertyDataY.substring(1,(PropertyDataY.length-1));
                                    // 原始数据与现数据进行比较
                                    if(PropertyDataY!=PropertyData)
                                    { ///bordeR-bottom:20px solid blue;   bordeR-bottom:20px solid red; 
                                        newjson = newjson + x+":"+'"<span style='+"'color:Red;bold:true;text-decoration:none'"+'>'+PropertyData +'</span>"' 
                                        oldjson2= oldjson2 + x+":"+'"<span style='+"'color:blue;bold:true; text-decoration:none'"+'>'+PropertyDataY +'</span>"' 
                                    }
                                    else
                                    {
                                        newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                        oldjson2= oldjson2+ x+":"+'"'+PropertyDataY +'"'    
                                    }       
                                }
                                else{ /// 如果是 添加或者删除时，进行拼串
                                    newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                }
                            }
                                var newjson = newjson + "}";
                                var newjsondata = eval('(' + newjson + ')');
                                
                                var oldjson = oldjson2 + "}";
                                var oldjson = eval('(' + oldjson + ')');
                                win.show();
                            }
                            else{
                                ///  newdata为空的情况 : 直接进入 异常捕获了，没有进行下一步的执行。  
                                Ext.getCmp('UpdateDataText').setValue(OldValue);
                            }
                         
                            var ss=new Ext.data.JsonStore({ 
                                fields:Detailfd  
                            })  
                            DetailGrid.reconfigure(ss,new Ext.grid.ColumnModel(DetailCM));
                            Ext.BDP.FunLib.Newline(DetailGrid);
                            if(olddata!=""){
                                ss.loadData([oldjson,newjsondata]);  
                                win.setIconClass("icon-update")
                                win.setTitle(showTitleName+"      "+"修改数据：第一行为原始数据，第二行为修正后数据")
                            }
                            else{
                                if(ShowOperate=="U"){
                                    ss.loadData([newjsondata])
                                    win.setTitle(showTitleName+"     "+"修改数据：修正后数据")
                                    win.setIconClass("icon-update")
                                }
                                
                                if (ShowOperate=="A"){
                                    ss.loadData([newjsondata])
                                    win.setTitle(showTitleName+"     "+"添加数据")
                                    win.setIconClass("icon-add")
                                }
                               if (ShowOperate=="D"){
                                    ss.loadData([newjsondata])
                                    win.setTitle(showTitleName+"      "+"删除数据")
                                    win.setIconClass("icon-delete")
                                } 
                              }
                         }
                        catch (e) 
                        {
                            /// 捕获异常后
                            if((newdata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata);
                            }
                            if((olddata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata); 
                            }
                            if((ShowOperate=="A")||(ShowOperate=="D")){
                                if(newdata!=""){
                                    Ext.getCmp('UpdateDataText').setValue(newdata); 
                            }
                        }
                          win2.show()  
                     }
                }
             }
    }); 
Ext.BDP.FunLib.ShowUserHabit(grid,"User.BDPDataChangeLog");
/***********************************定义viewport容器*******************************/
var viewport = new Ext.Viewport({
        layout : 'border',
        items : [grid]
    });
});
