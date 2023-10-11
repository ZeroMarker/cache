/**
 * @Author: 孙凤超 DHC-BDP
 * @Description: 国家/地区标准数据源类别
 * @CreateDate：2016-4-8  
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
    Ext.QuickTips.init(); 
    Ext.form.Field.prototype.msgTarget = 'side';
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataType&pClassMethod=OpenData"; 
    var ACTION_URL ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataType&pClassQuery=GetList";
    var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPNationalDataType";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataType&pClassMethod=DeleteData";
    var limit = Ext.BDP.FunLib.PageSize.Main;
    Ext.BDP.FunLib.TableName="BDP_NationalDataType";
  /************************************ 删除功能************************************/
    var btnDel = new Ext.Toolbar.Button({
        text : '删除',
        id:'del_btn',
        tooltip : '删除',
        iconCls : 'icon-delete',
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
                     return
                 } 
                 else{
                    Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
                    if (btn == 'yes') {
                        var gsm = grid.getSelectionModel(); 
                        var rows = gsm.getSelections(); 
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id':rows[0].get('BDPStandardRowId') 
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
 /*********************************重置form的数据清空**************************************/
   var ClearForm = function()
  {
     Ext.getCmp("form-save").getForm().reset()   
  }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
   var closepages= function ()
   {
     win.hide();
     ClearForm();
   }  
                            
  /***********************************winform的jsonreader*********************************/
   var JsonReaderE=new Ext.data.JsonReader({root:'list'},
          [{name: 'BDPStandardRowId',mapping:'BDPStandardRowId',type:'string'},
           {name: 'BDPStandardCode',mapping:'BDPStandardCode',type:'string'},
           {name: 'BDPStandardDesc',mapping:'BDPStandardDesc',type:'string'},
           {name: 'BDPStandardSearchCode',mapping:'BDPStandardSearchCode',type:'string'},
           {name:'BDPStandardDomainCode',mapping:'BDPStandardDomainCode',type:'string'},
           {name:'BDPStandardDomainDesc',mapping:'BDPStandardDomainDesc',type:'string'}
      ]);
   /// RowId  
    var RowIdText=new Ext.form.TextField({
             fieldLabel : 'BDPStandardRowId',
             hideLabel : 'True',
             hidden : true,
             name : 'BDPStandardRowId'
    });
     /// Code代码
      var codeText=new Ext.form.TextField({
                fieldLabel : '<font color=red>*</font>代码',
                allowBlank:false,
                anchor: '85%',
                regexText:"代码不能为空",
                labelSeparator : "",
                name : 'BDPStandardCode',
                id:'BDPStandardCodeF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardCodeF'),
                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardCodeF')) /*,
                enableKeyEvents : true,
                validationEvent : 'blur',  
                validator : function(thisText){
                 if(thisText==""){ 
                    return true;
                 }
                 var className =  "web.DHCBL.CT.BDPNationalDataType";   
                 var classMethod = "FormValidate";                           
                 var id="";
                 if(win.title=='修改'){  
                  var _record = grid.getSelectionModel().getSelected();
                  var id = _record.get('BDPStandardRowId');  
                 }
                 var flag = "";
                 var flag = tkMakeServerCall(className,classMethod,id,thisText,"");   
                 if(flag == "1"){   
                   return false;
                  }else{
                   return true;
                  }
                },
                invalidText : '该代码已经存在',
                listeners : {
                    'change' : Ext.BDP.FunLib.Component.ReturnValidResult
              } */
     });
   /// 描述
    var DescText=new Ext.form.TextField({
               fieldLabel : '<font color=red>*</font>描述',
               anchor: '85%',
               labelSeparator : "",
               allowBlank:false,
               regexText:"描述不能为空",
               name : 'BDPStandardDesc',
               id:'BDPStandardDescF',
               readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDescF'),
               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDescF')) /*,
               enableKeyEvents : true,
               validationEvent : 'blur',
               validator : function(thisText){
               if(thisText==""){  
                    return true;
                }
               var className =  "web.DHCBL.CT.BDPNationalDataType"; //后台类名称
               var classMethod = "FormValidate"; //数据重复验证后台函数名
               var id="";
               if(win.title=='修改'){ 
                  var _record = grid.getSelectionModel().getSelected();
                  var id = _record.get('BDPStandardRowId');  
               }
               var flag = "";
               var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
               if(flag == "1"){   
                   return false;
                }else{
                     return true;
                 }
               },
              invalidText : '该描述已经存在',
              listeners : {
                'change' : Ext.BDP.FunLib.Component.ReturnValidResult
            } */
  });
 /// 检索码
  var BDPStandardSearchCodeText=new Ext.form.TextField({
         fieldLabel : '检索码',
         anchor: '85%',
         labelSeparator : "",
         name :'BDPStandardSearchCode',
         id:'BDPStandardSearchCodeF',
         readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardSearchCodeF'),
         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardSearchCodeF'))
  });
   /// 国家/地区标准编码源值域代码 
  var BDPStandardDomainCodeText=new Ext.form.TextField({
         fieldLabel : '源值域代码',
         labelSeparator : "",
         anchor: '85%',
         name :'BDPStandardDomainCode',
         id:'BDPStandardDomainCodeF',
         readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainCodeF'),
         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainCodeF'))
  });
   ///  国家/地区标准编码源值域名称
  var BDPStandardDomainDescFText=new Ext.form.TextField({
         labelSeparator : "",
         fieldLabel : '源值域名称',
         anchor: '85%',
         name :'BDPStandardDomainDesc',
         id:'BDPStandardDomainDescF',
         readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainDescF'),
         style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainDescF'))
  });
/************************************增加修改时弹出的Form***********************************/
    var WinForm = new Ext.form.FormPanel({
                id : 'form-save',
                labelAlign : 'right',
                width : 200,
                split : true,
                frame : true,
                defaults : {
                    border : false   
                },
                buttonAlign:'center',
                reader:JsonReaderE,
                items : [RowIdText,codeText,DescText,BDPStandardSearchCodeText,BDPStandardDomainCodeText,BDPStandardDomainDescFText]
           });
 
/************************************增加修改时弹出窗口**********************************/
    var win = new Ext.Window({
        width : 450,
        height : 310,
        layout : 'fit',
        plain : true,// true则主体背景透明
        modal : true,
        frame : true,
        autoScroll : false,
        collapsible : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closable:true,
        autoDestroy:true,
        closeAction : 'hide',
        labelWidth : 65,
        items : WinForm,
         buttons : [{
         text : '保存',
         iconCls : 'icon-save',
         id:'save_btn',
         disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
         handler : function() {
         var tempCode = Ext.getCmp("form-save").getForm().findField("BDPStandardCode").getValue();
         var tempDesc = Ext.getCmp("form-save").getForm().findField("BDPStandardDesc").getValue();
              if (tempCode=="") {
              Ext.Msg.show({
                             title : '提示',
                             msg : '代码不能为空!', 
                             minWidth : 200, 
                             animEl: 'form-save',
                             icon : Ext.Msg.ERROR,
                             buttons : Ext.Msg.OK,
                             fn:function()
                             {
                              Ext.getCmp("form-save").getForm().findField("BDPStandardCode").focus(true,true);
                             }
                         });
                       return;
                   }
        if (tempDesc=="") {
          Ext.Msg.show({ 
                         title : '提示',
                         msg : '描述不能为空!', 
                         minWidth : 200,
                         animEl: 'form-save',
                         icon : Ext.Msg.ERROR,
                         buttons : Ext.Msg.OK,
                         fn:function()
                         {
                           Ext.getCmp("form-save").getForm().findField("BDPStandardDesc").focus(true,true);
                         }
                       });
                    return;
                  }
            if(WinForm.getForm().isValid()==false){
               Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
               return;
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
                                        msg : '<font color= green>添加成功!</font>',
                                        animEl: 'form-save',
                                        icon : Ext.Msg.INFO,
                                        buttons : Ext.Msg.OK,
                                        fn : function(btn) {
                                        var startIndex = grid.getBottomToolbar().cursor;
                                        grid.getStore().load({
                                                       params :{
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
                                                               msg : '<font color=red>添加失败!</font>' ,
                                                               animEl: 'form-save',
                                                               minWidth : 200,
                                                               icon : Ext.Msg.ERROR,
                                                               buttons : Ext.Msg.OK
                                                            });
                                                      }
                                                },
                                              failure : function(form, action) {
                                                Ext.Msg.show({
                                                                  title : '<font color=blue>提示</font>',
                                                                  msg : '<font color=red>添加失败!</font>' ,
                                                                  animEl: 'form-save',
                                                                  minWidth : 200,
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
                                                                 msg : '<font color=red>修改失败!</font>' ,
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
                                            },{
                                                    text : '关闭',
                                                    iconCls : 'icon-close',
                                                    handler :closepages
                                              }],
                                    listeners : {
                                        "show" : function() {
                                            Ext.getCmp("form-save").getForm().findField("BDPStandardCode").focus(true,300);
                                        },
                                        "hide" : function(){
                                             Ext.BDP.FunLib.Component.FromHideClearFlag();
                                             closepages();
                                           },
                                        "close" : function() {
                                                   
                                                }
                                            }
                                        });
/************************************增加按钮***********************************/
    var btnAddwin = new Ext.Toolbar.Button({
                text : '添加',
                tooltip : '添加',
                iconCls : 'icon-add',
                id:'add_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
                handler : AddData=function() {
                    win.setTitle('添加');
                    win.setIconClass('icon-add');
                    win.show('new1');
                    WinForm.getForm().reset();
                 }
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
    
   /*********************************数据存储格式*********************************/
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : ACTION_URL
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                                    
                           }, [{     
                                    name : 'BDPStandardRowId',
                                    mapping :'BDPStandardRowId',
                                    type : 'int'
                                }, {
                                    name : 'BDPStandardCode',
                                    mapping : 'BDPStandardCode',
                                    type : 'string'
                                }, {
                                    name : 'BDPStandardDesc',
                                    mapping :'BDPStandardDesc',  
                                    type:'string'
                                },{
                                    name:'BDPStandardSearchCode',
                                    mapping:'BDPStandardSearchCode',
                                    type:'string'
                                } , {
                                    name : 'BDPStandardDomainCode',
                                    mapping :'BDPStandardDomainCode',  
                                    type:'string'
                                },{
                                    name:'BDPStandardDomainDesc',
                                    mapping:'BDPStandardDomainDesc',
                                    type:'string'
                                } 
                        ]) 
            });
    /***********************************数据加载************************************/
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
        })
    var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect : true,
                checkOnly : false,
                width : 20
            });
 
/************************************增删改工具条***********************************/
    var tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [btnAddwin, '-', btnEditwin, '-', btnDel ] 
        })
    /*******************************搜索工具条用于进行数据检索*******************************/
    var search=function() {
        grid.getStore().baseParams={            
            code : Ext.getCmp("TextCode").getValue(),
            desc : Ext.getCmp("TextDesc").getValue(),
            NationalCode:Ext.getCmp('TextNationalCode').getValue(),
			NationalDesc:Ext.getCmp("TextNationalDesc").getValue()  
        };
    grid.getStore().load({
        params : {
                    start : 0,
                    limit : limit
                 }
            });
     }
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                iconCls : 'icon-search',
                text : '搜索',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                handler : search 
            });
/************************************刷新工作条************************************/
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                iconCls : 'icon-refresh',
                text : '重置',
                handler : function refresh() {
                    Ext.BDP.FunLib.SelectRowId="";
                    Ext.getCmp("TextCode").reset();
                    Ext.getCmp("TextDesc").reset();
					Ext.getCmp('TextNationalCode').reset();
                    Ext.getCmp("TextNationalDesc").reset(); 
                    grid.getStore().baseParams={};
                    grid.getStore().load({
                                params : {
                                            start : 0,
                                            limit : limit
                                        }
                                    });
                                }
                            });
    
    /******************************* 将工具条放到一起**********************************/
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['代码', {
                            xtype : 'textfield',
                            id : 'TextCode',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode') 
                             
				},'描述/检索码', {
                            xtype : 'textfield',
                            id : 'TextDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc') 
                },'国家/地区标准编码源值域代码', {
							xtype : 'textfield',
							id : 'TextNationalCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextNationalCode') 
				},'国家/地区标准编码源值域名称', {
                            xtype : 'textfield',
                            id : 'TextNationalDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextNationalDesc') 
					},'-', btnSearch, '-', btnRefresh
                ],
                listeners : {
                    'render' : function() {
                        tbbutton.render(grid.tbar)  
                    } 
                }
            });

/************************************create the Grid***********************************/
    
    var cm=new Ext.grid.ColumnModel( [new Ext.grid.CheckboxSelectionModel(),
                      {
                            header :'BDPStandardRowId',
                            width : 160,
                            sortable : true,
                            hidden:true,
                            dataIndex : 'BDPStandardRowId'
                      }, {
                            header : '代码',
                            width : 160,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BDPStandardCode'
                        }, {
                            header : '描述',
                            width : 160,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BDPStandardDesc'
                        },{
                            header : '检索码',
                            width : 160,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BDPStandardSearchCode'
                        }, {
                            header : '国家/地区标准编码源值域代码',
                            width : 160,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BDPStandardDomainCode'
                        },{
                            header : '国家/地区标准编码源值域名称',
                            width : 160,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BDPStandardDomainDesc'
                        }]);
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : ds,
                trackMouseOver : true,
                singleSelect: true ,
                tools:Ext.BDP.FunLib.Component.HelpMsg,
                cm:cm,
                sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
                stripeRows : true,
                columnLines : true,  
                title : '国家/地区标准数据源类别',
                stateful : true,
                viewConfig : {
                                forceFit : true,
                                emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
                                enableRowBody: true 
                            },
                bbar : paging,
                tbar : tb,
                stateId : 'grid'
            });
     
/************************************双击事件***********************************/
      var loadFormData = function(grid){
            var _record = grid.getSelectionModel().getSelected();   
            if (!_record) {
               Ext.Msg.alert('修改操作', '<font color=red>请选择要修改的一项!</font>');
            } else {
                    WinForm.form.load({
                    url : OPEN_ACTION_URL + '&id='+ _record.get('BDPStandardRowId'),   
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
                loadFormData(grid)
        }); 
    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
     /************************************键盘事件，按A键弹出添加窗口************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    var viewport = new Ext.Viewport({
            layout : 'border',
            items : [grid]
        });
    });
