/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 医嘱项科室限制
 * @Created on 2018-06-12
 * @Updated on  
 * @LastUpdated on    by sunfengchao
 */
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
 /// 获取到表的 ID
var ParRef=Ext.getUrlParam('ParRef'); 
var hospid=Ext.getUrlParam('hospid');  //医院
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCArcItemAut&pClassQuery=GetList";
    var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCArcItemAut&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCArcItemAut";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCArcItemAut&pClassMethod=DeleteData";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCArcItemAut&pClassMethod=OpenData";   
    var COMBO_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCArcItemAut&pClassQuery=GetComboList&hospid="+hospid;
    var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
 
 /************************************ 删除功能*************************************************/
    var btnDel = new Ext.Toolbar.Button({
        text : '删除',
        tooltip : '删除',
        iconCls : 'icon-delete',
        id:'del_btn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
        handler : DelData=function() {
        var records =  grid.selModel.getSelections();
                var recordsLen= records.length;
                if(recordsLen == 0){
                    Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'请选择需要删除的行!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                    }); 
                    return false;
                 } 
                 else{
                    Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
                    if (btn == 'yes') { 
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id':rows[0].get('AUTRowID') 
                            },
                            callback : function(options, success, response) {
                                Ext.MessageBox.hide();
                                if (success) {
                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                    if (jsonData.success == 'true') {
                                        Ext.Msg.show({
                                            title : '<font color=blue>提示</font>',
                                            msg : '<font color=red>删除成功!</font>',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            animEl: 'form-save',
                                            fn : function(btn) {
                                                     Ext.BDP.FunLib.DelForTruePage(grid,limit);
                                                   }
                                               });
                                    } else {
                                        var errorMsg = '';
                                        if (jsonData.info) {
                                            errorMsg = '<br />错误信息:' + jsonData.info
                                        }
                                        Ext.Msg.show({
                                                        title : '<font color=blue>提示</font>',
                                                        msg : '<font color=red>数据删除失败!</font>' + errorMsg,
                                                        minWidth : 200,
                                                        icon : Ext.Msg.ERROR,
                                                        animEl: 'form-save',
                                                        buttons : Ext.Msg.OK
                                                    });
                                            }
                                } else {
                                    Ext.Msg.show({
                                                    title : '<font color=blue>提示</font>',
                                                    msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
                                                    icon : Ext.Msg.ERROR,
                                                    animEl: 'form-save',
                                                    buttons : Ext.Msg.OK
                                                });
                                        }
                                }
                            }, this);
                        }
                }, this);
            } 
        }
    });

   var JsonReaderE=new Ext.data.JsonReader({root:'list'},
   [{ 
         name : 'AUTRowID',
         mapping : 'AUTRowID',
         type : 'string'
      },{
         name:'ParRef',
         mapping:'ParRef',
         type:'string'
      }, {
         name : 'AUTRelation',
         mapping : 'AUTRelation',
         type : 'string'
        }, {
         name : 'AUTType',
         mapping :'AUTType',
         type:'string'
        },{
         name:'AUTOperate',
         mapping:'AUTOperate',
         type:'string'
        }, {
         name :'AUTPointer',
         mapping :'AUTPointer',
         type:'string'
        }, {
         name : 'AUTAddUserDr',
         mapping :'AUTAddUserDr',
         type:'string'
        },{
         name:'AUTDate',
         mapping:'AUTDate',
         type:'string'
        }, {
         name :'AUTTime',
         mapping :'AUTTime',
         type:'string' 
        } 
     ]);
    
     /// RowId  
    var RowIDText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : 'AUTRowID',
       hideLabel : 'True',
       hidden : true,
       name : 'AUTRowID'
    });
         /// RowId  
    var ParRefText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : 'ParRef',
       hideLabel : 'True',
       id:'ParRefF',
       hidden : true,
       name : 'ParRef'
    });
       
   /// Coed
   var RelationText=new Ext.BDP.FunLib.Component.BaseComboBox({
       fieldLabel : '关系',
       name : 'AUTRelation',
       id:'AUTRelationF',
       stripCharsRe : '',
       labelSeparator:"",
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('AUTRelationF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AUTRelationF')),
       store:new Ext.data.SimpleStore({
            fields:['AUTRelation','value'],
            data:[  
                      ['AND','并且'],
                      ['OR','或者']  
                 ]
        }),
        displayField:'value',
        valueField:'AUTRelation',
        mode:'local',
        triggerAction:'all',
        blankText:'请选择'
    });
    
   /// AUTType  
  var AUTTypeText=new Ext.BDP.FunLib.Component.BaseComboBox({
       fieldLabel : '<font color=red>*</font>类型', 
       hiddenName : 'AUTType',
	   allowBlank:false, 
       id:'AUTTypeF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('AUTTypeF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AUTTypeF')),
       store:new Ext.data.SimpleStore({
            fields:['AUTType','value'],
            data:[  
					  ['HP','医院'],
                      ['KS','科室'],
                      ['ZC','职称'],
                      ['YS','医生'],
                      ['JB','病人级别'] 
                 ]
        }),
        displayField:'value',
        valueField:'AUTType',
        mode:'local',
        triggerAction:'all',
        blankText:'请选择',
        listeners:{
            'select':function(){
                Ext.getCmp('AUTPointerF').reset();
            }
        }
    }); 
    
    /// AUTOperate 
  var AUTOperateText=new Ext.BDP.FunLib.Component.BaseComboBox({
       fieldLabel : '操作',
       name : 'AUTOperate',
       id:'AUTOperateF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('AUTOperateF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AUTOperateF')),
       store:new Ext.data.SimpleStore({
            fields:['AUTOperate','value'],
            data:[  
                      ['=','等于'],
                      ['<>','不等于'],
                      ['>=','大于等于']  
                 ]
        }),
        displayField:'value',
        valueField:'AUTOperate',
        mode:'local',
        triggerAction:'all',
        blankText:'请选择',
        listeners:{
            'select': function(field,e){
                var AUTType=Ext.getCmp('AUTTypeF').getValue();
                var AUTOperate =Ext.getCmp('AUTOperateF').getValue(); 
                if ((((AUTType=="ZC")||(AUTType=="JB")))&&(AUTOperate==">=")){ 
                        Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '【职称】或【病人级别】不能选择【大于等于】!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK  
                            });
                        Ext.getCmp('AUTOperateF').setValue('');
                        return false; 
                     }   
                }
         } 
    });
    
   
   /// 名称
  var AUTPointerText=new Ext.BDP.FunLib.Component.BaseComboBox({
       fieldLabel : '<font color=red>*</font>名称',
       allowBlank:false, 
       hiddenName:'AUTPointer',
       id:'AUTPointerF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('AUTPointerF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AUTPointerF')),
       store : new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : COMBO_QUERY_ACTION_URL }),
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [ 'RowId', 'QtyDesc'])
            }),
            queryParam : 'desc',
            listWidth:250,
            pageSize:Ext.BDP.FunLib.PageSize.Combo,  
            forceSelection : true,
            selectOnFocus : false, 
            minChars : 0,
            valueField : 'RowId',
            displayField : 'QtyDesc',
            listeners:{
                'beforequery': function(e){
                    if (Ext.getCmp("AUTTypeF").getValue()=="")
                    {
                        return false;   
                    } 
                    this.store.baseParams = {
                            desc:e.query,
                            Type:Ext.getCmp("AUTTypeF").getValue(),
                            hospid:hospid
                    };
                    this.store.load({params : {
                                start : 0,
                                limit : Ext.BDP.FunLib.PageSize.Combo
                    }})
                
                }
             }
    });
    
/************************************增加修改的Form********************************/
    var WinForm = new Ext.form.FormPanel({
                id : 'form-save',
                labelAlign : 'right',
                width : 200,
                split : true,
                frame : true, 
                defaults : {
                    anchor: '85%',
                    border : false  
                },
                reader:JsonReaderE,
                items : [RowIDText,ParRefText,RelationText,AUTTypeText,AUTOperateText,AUTPointerText]  
            });
   
   /*********************************重置form的数据清空**************************************/
      var ClearForm = function()
      {
          Ext.getCmp("form-save").getForm().reset();   
      }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
       var closepages= function (){
            win.hide();
            ClearForm();
      }   
 
/************************************增加修改时弹出窗口************************************/
    var win = new Ext.Window({
        width : 400,
        height : 300,
        layout : 'fit',
        frame : true,// true则主体背景透明
        modal : true,
        frame : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        labelWidth : 55,
        items : WinForm,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
            handler : function() {
                var AUTPointer=Ext.getCmp('AUTPointerF').getValue();
                var AUTOperate =Ext.getCmp('AUTOperateF').getValue();
                var AUTType=Ext.getCmp('AUTTypeF').getValue();
				if (AUTType==""){
                    Ext.Msg.show({ 
                            title : '<font color=blue>提示</font>',
                            msg : '类型不能为空!', 
                            minWidth : 200,
                            animEl: 'form-save',
                            icon : Ext.Msg.ERROR,
                            buttons : Ext.Msg.OK  
                        });
                    return;
                } 
                if (AUTPointer==""){
                    Ext.Msg.show({ 
                            title : '<font color=blue>提示</font>',
                            msg : '名称不能为空!', 
                            minWidth : 200,
                            animEl: 'form-save',
                            icon : Ext.Msg.ERROR,
                            buttons : Ext.Msg.OK  
                        });
                    return;
                } 
				
                if ((((AUTType=="ZC")||(AUTType=="JB")))&&(AUTOperate==">=")){ 
                        Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '【职称】或【病人级别】不能选择【大于等于】!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK  
                            });
                        Ext.getCmp('AUTOperateF').setValue('');
                        return false; 
                }    
             
                if (win.title == "添加") {
                    WinForm.form.submit({
                        clientValidation : true, // 进行客户端验证
                        url : SAVE_ACTION_URL_New,
                        method : 'POST',
                        success : function(form, action) {
                         if (action.result.success == 'true') {
                                  var myrowid = action.result.id;
                                  win.hide();
                                  Ext.Msg.show({
                                                title : '<font color=blue>提示</font>',
                                                msg : '<font color=green>添加成功!</font>',
                                                animEl: 'form-save',
                                                icon : Ext.Msg.INFO,
                                                buttons : Ext.Msg.OK,
                                                fn : function(btn) {
                                                        var startIndex = grid.getBottomToolbar().cursor;
                                                        grid.getStore().load({
                                                                       params : {
                                                                                    start : 0,
                                                                                    limit : limit,
                                                                                    rowid : myrowid
                                                                                }
                                                                            });
                                                                }
                                            });
                                } else {
                                    var errorMsg = '';
                                    if (action.result.errorinfo) {
                                        errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                    }
                                Ext.Msg.show({
                                                title : '<font color=blue>提示</font>',
                                                msg : '<font color=red>添加失败!</font>',
                                                minWidth : 200,
                                                animEl: 'form-save',
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                    }
                        },
                        failure : function(form, action) {
                            Ext.Msg.show({
                                            title : '<font color=blue>提示</font>',
                                            msg : '<font color=red>添加失败!</font>' ,
                                            minWidth : 200,
                                            animEl: 'form-save',
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                        }
                    })
                } else {
                    Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
                        if (btn == 'yes') {
                            WinForm.form.submit({
                                clientValidation : true, // 进行客户端验证
                                url : SAVE_ACTION_URL_New,
                                method : 'POST',
                                success : function(form, action) {
                                    if (action.result.success == 'true') {
                                         var myrowid = 'rowid='+action.result.id;
                                         win.hide();
                                         Ext.Msg.show({
                                              title : '<font color=blue>提示</font>',
                                              msg : '<font color=green> 修改成功!</font>',
                                              animEl: 'form-save',
                                              icon : Ext.Msg.INFO,
                                              buttons : Ext.Msg.OK,
                                                       fn : function(btn) {
                                                        var startIndex = grid.getBottomToolbar().cursor;
                                                        Ext.BDP.FunLib.ReturnDataForUpdate('grid',ACTION_URL,myrowid);
                                                    }
                                               }); 
                                    } else {
                                        var errorMsg = '';
                                        if (action.result.errorinfo) {
                                            errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                        }
                                        Ext.Msg.show({
                                                        title : '<font color=blue>提示</font>',
                                                        msg : '<font color=red>修改失败!</font>',
                                                        minWidth : 200,
                                                        animEl: 'form-save',
                                                        icon : Ext.Msg.ERROR,
                                                        buttons : Ext.Msg.OK
                                                    });
                                            }
                                },
                                failure : function(form, action) {
                                    Ext.Msg.show({
                                                    title : '<font color=blue>提示</font>',
                                                    msg : '<font color=red>修改失败!</font>' ,
                                                    minWidth : 200,
                                                    animEl: 'form-save',
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                }
                            })
                        }
                    }, this);
                }
            }
        }, {
              text : '关闭',
              iconCls : 'icon-close',
              handler : function() {
                win.hide();  
                ClearForm(); 
            }
        }],
        listeners : {
            "show" : function() {
                     
            },
            "hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
            "close" : function() {
            }
        }
    });
/************************************增加按钮************************************/
    var btnAddwin = new Ext.Toolbar.Button({
                text : '添加',
                tooltip : '添加',
                iconCls : 'icon-add',
                id:'add_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
                handler : AddData=function() {
                    WinForm.getForm().reset();
                    win.setTitle('添加');
                    win.setIconClass('icon-add');
                    win.show('new1');
                    Ext.getCmp('ParRefF').setValue(ParRef);
                },
                scope : this
            });
/************************************修改按钮***********************************/
    var btnEditwin = new Ext.Toolbar.Button({
                text : '修改',
                tooltip : '修改',
                iconCls : 'icon-update',
                id:'update_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
                handler : UpdateData=function() {
                var records =  grid.selModel.getSelections();
                var recordsLen= records.length;
                if(recordsLen == 0){
                        Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'请选择需要修改的行!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        }); 
                     return
                 } 
                 else{
                        win.setTitle('修改');
                        win.setIconClass('icon-update');
                        win.show('');
                        loadFormData(grid);
                     }
             }
    });
     
    /************************************数据存储************************************/
    var fields= [{ 
         name : 'AUTRowID',
         mapping : 'AUTRowID',
         type : 'string'
      }, {      
         name : 'AUTRelation',
         mapping : 'AUTRelation',
         type : 'string'
        }, {
         name : 'AUTType',
         mapping :'AUTType',
         type:'string'
        },{
         name:'AUTOperate',
         mapping:'AUTOperate',
         type:'string'
        }, {
         name :'AUTPointer',
         mapping :'AUTPointer',
         type:'string'
        },{
         name : 'AUTAddUserDr',
         mapping :'AUTAddUserDr',
         type:'string'
        },{
         name:'AUTDate',
         mapping:'AUTDate',
         type : 'date' ,
         dateFormat : 'm/d/Y'
        }, {
         name :'AUTTime',
         mapping :'AUTTime',
         type:'string' 
        } ] 
        
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : ACTION_URL
                        }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        },fields) 
        });
    /************************************数据加载************************************/
    ds.baseParams={ ParRef :ParRef};
    ds.load({
                params : {
                    start : 0,
                    limit : limit
                } 
            }); 
    /************************************数据分页************************************/
    var paging = new Ext.PagingToolbar({
            pageSize: limit,
            store: ds,
            displayInfo: true,
            displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
            emptyMsg : "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
             listeners : {
                            "change":function (t,p)
                           { 
                               limit=this.pageSize;
                           }
                       }
         }); 
    var sm = new Ext.grid.CheckboxSelectionModel({
         singleSelect : true,
         checkOnly : false,
         width : 20
    });
/************************************增删改工具条************************************/
    var tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [btnAddwin, '-', btnEditwin, '-', btnDel ] 
    });
    /************************************搜索工具条***********************************/
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                iconCls : 'icon-search',
                text : '搜索',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                handler : function() {
                grid.getStore().baseParams={
                        ParRef:ParRef,
                        code :  Ext.getCmp("TextCode").getValue() ,
                        desc :  Ext.getCmp("TextDesc").getValue() 
                };
                grid.getStore().load({
                    params : {
                                start : 0,
                                limit : limit
                            }
                        });
                    }
            });
    /************************************刷新工作条************************************/
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                iconCls : 'icon-refresh',
                text : '重置',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                handler : function refresh() {
                    Ext.BDP.FunLib.SelectRowId="";
                    Ext.getCmp("TextCode").reset();
                    Ext.getCmp("TextDesc").reset();
                    grid.getStore().baseParams={ParRef:ParRef};
                    grid.getStore().load({
                                    params : {
                                                start : 0,
                                                limit : limit
                                            }
                                    });
                                }
                        });
/************************************ 将工具条放到一起***********************************/
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['关系', {
                       xtype:'combo',
                       fieldLabel : '关系',
                       name : 'AUTRelation',
                       id:'TextCode',
                       stripCharsRe :  ' ',
                       labelSeparator:"",
                       store:new Ext.data.SimpleStore({
                            fields:['AUTRelation','value'],
                            data:[  
                                      ['AND','并且'],
                                      ['OR','或者']  
                                 ]
                        }),
                        displayField:'value',
                        valueField:'AUTRelation',
                        mode:'local',
                        triggerAction:'all',
                        blankText:'请选择'
                             
             }, '类型', {
                       xtype:'combo',
                       fieldLabel : '类型',
                       hiddenName : 'AUTType',
                       id:'TextDesc',
                       store:new Ext.data.SimpleStore({
                            fields:['AUTType','value'],
                            data:[  
									  ['HP','医院'],
                                      ['KS','科室'],
                                      ['ZC','职称'],
                                      ['YS','医生'],
                                      ['JB','病人级别'] 
                                 ]
                        }),
                        displayField:'value',
                        valueField:'AUTType',
                        mode:'local',
                        triggerAction:'all'  
                    } ,'-', btnSearch, '-', btnRefresh, '->'
                ],
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar) 
                    }
                }
            });
/************************************create the Grid**********************************/ 
    var sm=new Ext.grid.CheckboxSelectionModel({singleSelect:true})
    var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
                            header : 'AUTRowID',
                            width : 60,
                            sortable : true,
                            dataIndex :'AUTRowID',
                            hidden : true
                        } , {
                            header : '关系',
                            width : 120,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'AUTRelation'
                        }, {
                            header : '类型',
                            width : 120,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'AUTType'
                        }, {
                            header:'操作',
                            width:120,
                            sortable:true,
                            dataIndex:'AUTOperate',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow
                        }, {
                            header:'名称',
                            width:120,
                            sortable:true,
                            dataIndex:'AUTPointer',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow
                        } ,{  
                            header:'操作人',
                            width:140,
                            sortable:true,
                            dataIndex:'AUTAddUserDr',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow
                        },{
                            header : '操作日期',
                            width : 140,
                            sortable : true,
                            renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex :'AUTDate'
                        },{
                            header:'操作时间',
                            width:160,
                            sortable:true,
                            dataIndex:'AUTTime',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow
                        }]; 
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center', 
                height : 500,
                closable : true,
                store : ds,
                trackMouseOver : true,
                singleSelect: true , 
                columns:GridCM,
                sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
                stripeRows : true,
                columnLines : true, //在列分隔处显示分隔符 
                stateful : true,
                viewConfig : {
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
                    nableRowBody: true // 
                },
                bbar : paging,
                tbar : tb,
                stateId : 'grid'
            });
 
/************************************双击事件************************************/
      var loadFormData = function(grid){
            var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
            if (!_record) {
                Ext.Msg.alert('修改操作', '请选择要修改的一项!');
            } else {
                    WinForm.form.load( {
                    url : OPEN_ACTION_URL + '&id='+ _record.get('AUTRowID'),  //id 对应OPEN里的入参
                    success : function(form,action) {
                    },
                    failure : function(form,action) {
                    }
                });
            }
        };
        grid.on("rowdblclick", function(grid, rowIndex, e) {
                var row = grid.getStore().getAt(rowIndex).data;
                win.setTitle('修改');      ///双击后
                win.setIconClass('icon-update');
                win.show('');
                loadFormData(grid);
        });  
    /************************************键盘事件************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    var viewport = new Ext.Viewport({
            layout : 'border',
            items : [grid]
    });
});
