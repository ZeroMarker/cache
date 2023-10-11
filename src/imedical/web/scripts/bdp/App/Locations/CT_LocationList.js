/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于科室列表维护。
 * @Created on 2012-8-4
 * @Updated on 2013-5-11
 * @LastUpdated on 2013-6-24 by sunfengchao
 */
  
   document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
   document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');   
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
   Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
    var comboPage=Ext.BDP.FunLib.PageSize.Combo;
    ///科室列表使用
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocationList&pClassQuery=GetList";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocationList&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocationList";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocationList&pClassMethod=DeleteData";
    var OPEN__URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocationList&pClassMethod=OpenData";    
    
    ///Combo 使用
    var HOSPITAL_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
    var LOC_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
    
    ///关联科室使用
    var ACTION_URL2 = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocationListLocations&pClassQuery=GetList";
    var SAVE_ACTION_URL_New2 = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocationListLocations&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocationListLocations";
    var DELETE_ACTION_URL2 = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocationListLocations&pClassMethod=DeleteData";  
    var CHILD_SAVE_ACTION_URL =  "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocationListLocations&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocationListLocations";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocationListLocations&pClassMethod=OpenData"; 
    
    /*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.CTLocationList";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
  //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "CT_LocationList"
  });

     Ext.BDP.FunLib.TableName="CT_LocationList";
     /// 获取查询配置按钮 
     var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名  
     var btnTrans=Ext.BDP.FunLib.TranslationBtn;
     var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
     if (TransFlag=="false")
     {
        btnTrans.hidden=false;
      }
     else
     {
        btnTrans.hidden=true;
     }
//////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName);
     ///日志查看按钮是否显示
   var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogflag==1)
   {
      btnlog.hidden=false;
    }
    else
    {
       btnlog.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogflag==1)
   {
      btnhislog.hidden=false;
    }
    else
    {
       btnhislog.hidden=true;
    }  
   btnhislog.on('click', function(btn,e){    
   var RowID="",Desc="";
   if (grid.selModel.hasSelection()) {
       var rows = grid.getSelectionModel().getSelections(); 
       RowID=rows[0].get('LLRowId');
       Desc=rows[0].get('LLDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
   //////////////////////////////子表日志查看 ///////////////////////////////////////////////////////////
   var btnlogsub=Ext.BDP.FunLib.GetLogBtn("User.CTLocationListLocations");
   var btnhislogsub=Ext.BDP.FunLib.GetHisLogBtn("User.CTLocationListLocations");
     ///日志查看按钮是否显示
   var btnlogflag2=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogflag2==1)
   {
      btnlogsub.hidden=false;
    }
    else
    {
       btnlogsub.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogflag2= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogflag2==1)
   {
      btnhislogsub.hidden=false;
    }
    else
    {
       btnhislogsub.hidden=true;
    }  
   btnhislogsub.on('click', function(btn,e){    
   var RowID2="",Desc2="",ParentDesc="";
   if (grid2.selModel.hasSelection()) {
       var rows = grid2.getSelectionModel().getSelections(); 
       RowID2=rows[0].get('LOCRowId');
       ParentDesc=tkMakeServerCall("web.DHCBL.CT.CTLocationListLocations","GetParentDesc",rows[0].get('ParRef')); 
       if (ParentDesc!=""){
         Desc2=ParentDesc+"->"+rows[0].get('CTLOCDR');
       }
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID2,Desc2);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
    /**************************************科室列表删除按钮*******************************************/
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
                        //删除所有别名
                        AliasGrid.DataRefer=records[0].get('LLRowId') ;
                        AliasGrid.delallAlias();
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id':rows[0].get('LLRowId') 
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
                                                 var startIndex = grid.getBottomToolbar().cursor;
                                                 var totalnum=grid.getStore().getTotalCount();
                                                  if(totalnum==1){   //修改添加后只有一条，返回第一页
                                                var startIndex=0
                                               }
                                               else if((totalnum-1)%limit==0)//最后一页只有一条
                                               {
                                                var pagenum=grid.getStore().getCount();
                                                if (pagenum==1){ startIndex=startIndex-limit;}  //最后一页的时候,不是最后一页则还停留在这一页
                                               }
                                                 grid.getStore().load({
                                                 params : {
                                                            start : startIndex,
                                                            limit : limit
                                                           }
                                                       });
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
    
    /********************************关联科室删除按钮 *********************************************/
    var btnDel2 = new Ext.Toolbar.Button({
            text : '删除',
            tooltip : '删除',
            iconCls : 'icon-delete',
            id:'link_del_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('link_del_btn'),
            handler : function DelData2() {
             if (grid2.selModel.hasSelection()) {
                Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗？', function(btn) {
                    if (btn == 'yes') {
                        Ext.MessageBox.wait('数据删除中，请稍候．．．', '提示');
                        var gsm =grid2.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL2,
                            method : 'POST',
                            params : {
                                'id' : rows[0].get('LOCRowId')
                            },
                            callback : function(options, success, response) {
                                Ext.MessageBox.hide();
                                if (success) {
                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                    if (jsonData.success == 'true') {
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '数据删除成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                 var startIndex = grid2.getBottomToolbar().cursor;
                                                 var totalnum=grid2.getStore().getTotalCount();
                                                 if((totalnum!=1)&&(totalnum/limit!=0)&&(totalnum%limit==1)){ startIndex-=limit; }
                                                 grid2.getStore().load({
                                                 params : {
                                                            ParRef:rows[0].get('LOCRowId').split("||",1),
                                                            start : startIndex,
                                                            limit : limit
                                                           }
                                                       });
                                                   }
                                               });
                                    } else {
                                        var errorMsg = '';
                                        if (jsonData.info) {
                                            errorMsg = '<br/>错误信息:' + jsonData.info
                                        }
                                        Ext.Msg.show({
                                                    title : '提示',
                                                    msg : '数据删除失败！' + errorMsg,
                                                    minWidth : 200,
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                    }
                                } else {
                                    Ext.Msg.show({
                                                title : '提示',
                                                msg : '异步通讯失败，请检查网络连接！',
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                }
                            }
                        }, this);
                    }
                }, this);
            } else {
                Ext.Msg.show({
                            title : '提示',
                            msg : '请选择需要删除的行！',
                            icon : Ext.Msg.WARNING,
                            buttons : Ext.Msg.OK
                        });
                }
            }
        });
    
    /******************************科室列表增加、修改的Form***************************************/
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
                title:'基本信息',
                defaultType : 'textfield',
                reader:new Ext.data.JsonReader({root:'list'},
                         [ 
                               {
                                    name : 'LLRowId',
                                    mapping : 'LLRowId' 
                                }, {
                                    name : 'LLCode',
                                    mapping :'LLCode' 
                                }, {
                                    name : 'LLDesc',
                                    mapping :'LLDesc' 
                                } 
                         ]),
                items : [{
                            fieldLabel : 'LLRowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'LLRowId'
                        }, {
                            name : 'LLCode',
                            allowBlank : false,
                            blankText : '此项必填',
                            fieldLabel : '<font color=red>*</font>代码',
                            allowBlank:false,
                            regexText:"代码不能为空",
                            id:'LLCodeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('LLCodeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LLCodeF')),
                            enableKeyEvents : true,
                            validationEvent : 'blur',  
                            validator : function(thisText){
                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                            return true;
                           }
                            var className =  "web.DHCBL.CT.CTLocationList";   
                            var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                            var id="";
                            if(win.title=='修改'){  
                            var _record = grid.getSelectionModel().getSelected();
                            var id = _record.get('LLRowId');  
                          }
                            var flag = "";
                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
                            
                            if(flag == "1"){   
                            return false;
                           }else{
                            return true;
                            }
                         },
                            invalidText : '该代码已经存在',
                            listeners : {
                                'change' : Ext.BDP.FunLib.Component.ReturnValidResult
                            }
                        }, {
                            name : 'LLDesc',
                            allowBlank : false,
                            fieldLabel : '<font color=red>*</font>描述',
                            id:'LLDescF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('LLDescF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LLDescF')),
                            enableKeyEvents : true,
                            validationEvent : 'blur',
                            validator : function(thisText){
                            if(thisText==""){  
                               return true;
                             }
                             var className =  "web.DHCBL.CT.CTLocationList"; //后台类名称
                             var classMethod = "FormValidate"; //数据重复验证后台函数名
                             var id="";
                             if(win.title=='修改'){ 
                             var _record = grid.getSelectionModel().getSelected();
                             var id = _record.get('LLRowId');  
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
                            }
                        }]
            });
        
    var LocStore=new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : LOC_QUERY_ACTION }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        });
    /**************************************关联科室增加、修改的Form ***************************/
    var WinForm2 = new Ext.form.FormPanel({
                id : 'form-save2',
                labelAlign : 'right',
                width : 200,
                split : true,
                frame : true,
                defaults : { width : 140, border : false },
                    reader:new Ext.data.JsonReader({root:'list'},
                         [ 
                               {
                                    name : 'LOCRowId',
                                    mapping : 'LOCRowId' 
                                }, {
                                    name : 'HospitalCTDR',
                                    mapping :'HospitalCTDR' 
                                }, {
                                    name : 'CTLOCDR',
                                    mapping :'CTLOCDR' 
                                } 
                         ]),
                defaultType : 'textfield',
                items : [{
                            fieldLabel : '关联科室ID',
                            hideLabel : 'True',
                            hidden : true,
                            readOnly : true,
                            name : 'ParentRowId'
                        },{
                            fieldLabel : 'LOCRowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'LOCRowId'
                        }, {
                            xtype : 'bdpcombo',
                            hiddenName : 'HospitalCTDR',
                            fieldLabel : '医院',
                            id:'HospitalCTDRF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('HospitalCTDRF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HospitalCTDRF')),
                            allowBlank : true,
                            store : new Ext.data.Store({
                                proxy : new Ext.data.HttpProxy({ url : HOSPITAL_QUERY_ACTION }),
                                reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'HOSPRowId', 'HOSPDesc' ])
                        }),
                        queryParam : 'desc',
                        selectOnFocus : false,
                        //typeAhead : true,
                        listWidth : 250,
                        valueField : 'HOSPRowId',
                        displayField : 'HOSPDesc',
                        forceSelection : true,
                        triggerAction : 'all',
                        pageSize :comboPage,
                        listeners:{
                         'select': function(field,e){
                                Ext.getCmp("CTLOCDRF").reset();
                            }
                        }           
                    }, {
                            xtype : 'bdpcombo',
                            fieldLabel : '<font color=red>*</font>科室',
                            hiddenName : 'CTLOCDR',
                            id:'CTLOCDRF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLOCDRF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLOCDRF')),
                            loadByIdParam:'rowid',
                            selectOnFocus : true,
                            store :new Ext.data.Store({
                                proxy : new Ext.data.HttpProxy({ url : LOC_QUERY_ACTION }),
                                reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }) ,
                            queryParam : 'desc',
                            forceSelection : true,
                            minChars : 0,
                            listWidth : 250,
                            valueField : 'CTLOCRowID',
                            displayField : 'CTLOCDesc',
                            pageSize : comboPage,
                            enableKeyEvents : true,
                            validationEvent : 'blur'  ,
                            validator : function(thisText){
                            if(thisText==""){  
                               return true;
                           }
                            var className =  "web.DHCBL.CT.CTLocationListLocations";   
                            var classMethod = "FormValidate";                              
                            var id="";
                            var ParRef=""
                            if(win2.title=='添加'){
                            var thisText=Ext.getCmp("form-save2").getForm().findField("HospitalCTDR").getValue();
                            var thisText2=Ext.getCmp("form-save2").getForm().findField("CTLOCDR").getValue();
                            var gsm = grid.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            ParRef=rows[0].get('LLRowId') 
                           }
                           if(win2.title=='修改'){  
                            var thisText=Ext.getCmp("form-save2").getForm().findField("HospitalCTDR").getValue();
                            var thisText2= Ext.getCmp("form-save2").getForm().findField("CTLOCDR").getValue();
                            var _record = grid2.getSelectionModel().getSelected();
                            var id = _record.get('LOCRowId'); 
                          }
                            
                            var flag = "";
                            var flag = tkMakeServerCall(className,classMethod,id,ParRef,thisText,thisText2);//用tkMakeServerCall函数实现与后台同步调用交互
                            if(flag == "1"){   
                                return false;
                           }else{
                              return true;
                            }
                          },
                            invalidText : '该科室已经存在',
                            listeners : {
                                'change' : function(){
                                    Ext.BDP.FunLib.Component.ReturnValidResult; 
                                },
                                'beforequery':function(obj){
                                    obj.combo.store.baseParams = {
                                        start:0,
                                        limit:comboPage,
                                        desc:obj.combo.getRawValue(),
                                        hospid:Ext.getCmp("HospitalCTDRF").getValue()
                                };
                                    obj.combo.store.load();
                                    return false;               
                                }
                            }  
                    }]
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
  
 /*******************************定义‘基本信息’框*******************************************/
 var tabs=new Ext.TabPanel({
      id:'basic',
      activeTab: 0,
      frame:true,
      items:[WinForm,AliasGrid]
 });
 Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
    /*************************************科室列表增加、修改窗口*************************************/
   var win = new Ext.Window({
        width :460,
        height :310,
        layout : 'fit',
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        labelWidth : 55,
        items : tabs,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
            handler : function() {
            var tempCode = Ext.getCmp("form-save").getForm().findField("LLCode").getValue();
            var tempDesc = Ext.getCmp("form-save").getForm().findField("LLDesc").getValue();
         
            if (tempCode=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '代码不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK,
                                fn:function()
                                {
                                    Ext.getCmp("form-save").getForm().findField("LLCode").focus(true,true);
                                }
                            });
                            return
                }
            if (tempDesc=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '描述不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("form-save").getForm().findField("LLDesc").focus(true,true);
                                }
                             });
                             return
                    }
                if (win.title == '添加') {
                    WinForm.form.submit({
                        clientValidation : true,  
                        url : SAVE_ACTION_URL,
                        method : 'POST',
                        success : function(form, action) {
                            if (action.result.success == 'true') {
                                 var myrowid = action.result.id;
                                 win.hide(); 
                                 Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加成功！',
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
                                        AliasGrid.DataRefer = myrowid;
                                        AliasGrid.saveAlias(); 
                                } else {
                                        var errorMsg = '';
                                        if (action.result.errorinfo) {
                                        errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                }
                                Ext.Msg.show({
                                                title : '提示',
                                                msg : '添加失败！' + errorMsg,
                                                minWidth : 200,
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                }
                        },
                        failure : function(form, action) {
                                Ext.Msg.alert('提示', '异步通讯失败，请检查网络连接！');
                            }
                    })
                } else {
                    Ext.MessageBox.confirm('提示', '确定要修改该条数据吗？', function(btn) {
                        if (btn == 'yes') {
                            WinForm.form.submit({
                                clientValidation : true,  
                                url : SAVE_ACTION_URL,
                                method : 'POST',
                                success : function(form, action) {
                                    AliasGrid.saveAlias(); 
                                    if (action.result.success == 'true') {
                                         var myrowid = 'rowid='+action.result.id;
                                         win.hide();
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '修改成功！',
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
                                                    title : '提示',
                                                    msg : '修改失败！' + errorMsg,
                                                    minWidth : 200,
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                    }

                                },
                                failure : function(form, action) {
                                    Ext.Msg.alert('提示', '异步通讯失败，请检查网络连接！');
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
                Ext.getCmp("form-save").getForm().reset();
            }
        }],
        listeners : {
            'show' : function() {
                    Ext.getCmp("form-save").getForm().findField("LLCode").focus(true,300);
            },
            "hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
            'close' : function() {
            }
        }
    });
    
    // 关联科室增加、修改窗口
    var win2 = new Ext.Window({
        width : 330,
        height : 200,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        labelWidth : 55,
        items : WinForm2,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'sub_savebtn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
            handler : function() {
            var tempCode2 = Ext.getCmp("form-save2").getForm().findField("HospitalCTDR").getValue();
            var tempDesc2 = Ext.getCmp("form-save2").getForm().findField("CTLOCDR").getValue();
            if (tempDesc2=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '科室不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("form-save2").getForm().findField("CTLOCDR").focus();
                                }
                             });
                             return
                    }
        if(WinForm2.getForm().isValid()==false){
            Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
            return;
         } 
        if (win2.title == '添加') {
                    WinForm2.form.submit({
                        clientValidation : true, // 进行客户端验证
                        url : SAVE_ACTION_URL_New2,
                        method : 'POST',
                        success : function AddData2(form, action) {
                            if (action.result.success == 'true') {
                                win2.hide();
                                var myrowid = action.result.id;
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                var startIndex = grid2.getBottomToolbar().cursor;
                                                grid2.getStore().load({
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
                                            title : '提示',
                                            msg : '添加失败！' + errorMsg,
                                            minWidth : 200,
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                            }

                        },
                        failure : function(form, action) {
                            Ext.Msg.alert('提示', '添加失败！');
                        }
                    })
                } else {
                    Ext.MessageBox.confirm('提示', '确定要修改该条数据吗？', function(btn) {
                        if (btn == 'yes') {
                            WinForm2.form.submit({
                                clientValidation : true, // 进行客户端验证
                                waitMsg : '正在提交数据请稍后',
                                waitTitle : '提示',
                                url : SAVE_ACTION_URL_New2,
                                method : 'POST',
                                success : function(form, action) {
                                    if (action.result.success == 'true') {
                                        win2.hide();
                                        var myrowid = 'rowid='+action.result.id;
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '修改成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                            Ext.BDP.FunLib.ReturnDataForUpdate('grid2',ACTION_URL2,myrowid);
                                      }
                                 });
                                    } else {
                                        var errorMsg = '';
                                        if (action.result.errorinfo) {
                                            errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                        }
                                        Ext.Msg.show({
                                                    title : '提示',
                                                    msg : '修改数据失败！' + errorMsg,
                                                    minWidth : 200,
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                    }
                                },
                                failure : function(form, action) {
                                    Ext.Msg.alert('提示', '修改数据失败！');
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
                win2.hide();
                Ext.getCmp("form-save2").getForm().reset();
            }
        }],
        listeners : {
            'show' : function() {
                 
            },
            "hide" : function(){
                Ext.BDP.FunLib.Component.FromHideClearFlag
            } ,
            'close' : function() {
            }
        }
    });
    
    // 科室列表 增加按钮
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
                    tabs.setActiveTab(0);
                    //清空别名面板grid
                    AliasGrid.DataRefer = "";
                    AliasGrid.clearGrid();
                },
                scope : this
            });
            
    //  科室列表 修改按钮
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
                 };
                if(recordsLen > 1){
                        Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'修改时每次只能选择一条数据,请重新选择!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK,
                            fn:function(btn){
                            var view = grid.getView();
                            var sm = grid.getSelectionModel();
                            if(sm){
                                    sm.clearSelections();
                                    var hd = Ext.fly(view.innerHd);
                                    var c = hd.query('.x-grid3-hd-checker-on');
                                    if(c && c.length>0){
                                                            Ext.fly(c[0]).removeClass('x-grid3-hd-checker-on')
                                                        }
                                 }
                            }
                        });
                  }     
                  
                 else{
                        win.setTitle('修改');
                        win.setIconClass('icon-update');
                        win.show();
                        loadFormData(grid);
                     }
             }
    });
	
	/****************************批量关联科室按钮 树形 likefan 2020-12-07***************************/
	
	var STOCKTREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocationListLocations&pClassMethod=GetTreeJson";
	var DEPGROUP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCDepartmentGroup&pClassQuery=GetDataForCmb1";
	/** 菜单面板 */
	var StockmenuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentGRPID"
			});
	
	//检索栏医院
	var LinkLocHosp = new Ext.BDP.Component.form.ComboBox({
    	width:150,
    	loadByIdParam : 'rowid',
		fieldLabel: '医院',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkLocHosp'),
		id:'LinkLocHosp',
		//triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:230,
		valueField:'HOSPRowId',
		displayField:'HOSPDesc',
		store:new Ext.data.JsonStore({
			url:HOSPITAL_QUERY_ACTION,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'HOSPRowId',
			fields:['HOSPRowId','HOSPDesc']
		}),
		listeners:{
			'select': function(field,e){
				StockmenuTreeLoader.dataUrl = STOCKTREE_QUERY_ACTION_URL+ '&loclistid='+Ext.getCmp("Hidden_GroupID").getValue()+'&hospid='+LinkLocHosp.getValue()+'&depgrpid='+LinkLocDepGrp.getValue();
				StockmenuPanel.root.reload();
				findByKeyWordFiler(Ext.getCmp('FindTreeText'),"");
			}
		}
	});
	//检索栏科室部门组
	var LinkLocDepGrp = new Ext.BDP.Component.form.ComboBox({
    	width:150,
    	loadByIdParam : 'rowid',
		fieldLabel: '科室部门组',
		emptyText: '请先选择医院',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkLocDepGrp'),
		id:'LinkLocDepGrp',
		//triggerAction:'all',//query
		forceSelection: true,
		selectOnFocus:false,
		mode:'remote',
		pageSize:Ext.BDP.FunLib.PageSize.Combo,
		listWidth:230,
		valueField:'DEPRowId',
		displayField:'DEPDesc',
		store:new Ext.data.JsonStore({
			url:DEPGROUP_QUERY_ACTION_URL,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'DEPRowId',
			fields:['DEPRowId','DEPDesc']
		}),
		listeners:{
			'beforequery': function(e){
				this.store.baseParams = {
					desc:e.query,
					hospid:LinkLocHosp.getValue()
				};
				this.store.load({params : {
							start : 0,
							limit : Ext.BDP.FunLib.PageSize.Combo
				}})

			},
			'select': function(field,e){
				StockmenuTreeLoader.dataUrl = STOCKTREE_QUERY_ACTION_URL+ '&loclistid='+Ext.getCmp("Hidden_GroupID").getValue()+'&hospid='+LinkLocHosp.getValue()+'&depgrpid='+LinkLocDepGrp.getValue();
				StockmenuPanel.root.reload();
				findByKeyWordFiler(Ext.getCmp('FindTreeText'),"");
			}
		}
	});
	
	//******************** 菜单树级联设置 ****************************//
	function cascadeParent(){
		var pn = this.parentNode;
		if (!pn || !Ext.isBoolean(this.attributes.checked)) return;
		if (this.attributes.checked) { //级联选中
			pn.getUI().toggleCheck(true);
		}else {//级联未选中
			var b = true;
			Ext.each(pn.childNodes, function(n){
				if (n.getUI().isChecked()){
					return b = false;
				}
				return true;
			});
			if (b) pn.getUI().toggleCheck(false);
		}
		pn.cascadeParent();
	}        
	function cascadeChildren(){
		var ch = this.attributes.checked;
		if (!Ext.isBoolean(ch)) return;
		Ext.each(this.childNodes, function(n){
			n.getUI().toggleCheck(ch);
			n.cascadeChildren();
		});
	}
	Ext.apply(Ext.tree.TreeNode.prototype, {
		cascadeParent: cascadeParent,
		cascadeChildren: cascadeChildren
	});
	Ext.override(Ext.tree.TreeNodeUI,{
					onDblClick: function(e){
						e.preventDefault();
						if(this.disabled){
							return;
						}
						if(!this.animating && this.node.isExpandable()){
							this.node.toggle();
						}
						this.fireEvent("dblclick", this.node, e);
					}
				});
	Ext.override(Ext.tree.TreeEventModel, {
		onCheckboxClick: Ext.tree.TreeEventModel.prototype.onCheckboxClick.createSequence(function(e, node){
			node.cascadeParent();
			node.cascadeChildren();
		})
	});
//****************************************************************//
	
	var StockmenuPanel = new Ext.tree.TreePanel({
			region: 'center',
			id: 'StockTreePanel',
			expanded:true,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"StockTreeRoot",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
					
				}),
			loader: StockmenuTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,
			tbar:[{xtype: 'textfield',id: 'Hidden_GroupID',hidden : true},
					'医院',LinkLocHosp,'部门组',LinkLocDepGrp,
					'科室',
					new Ext.form.TextField({
						id:'FindTreeText',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('FindTreeText'),
						width:150,
						emptyText:'请输入查找内容',
						enableKeyEvents: true,
						listeners:{
							keyup:function(node, event) {
								findByKeyWordFiler(node, event);
							},
							scope: this
						}
					}), '-', {
						text:'清空',
						id:'Textrefresh',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('Textrefresh'),
						iconCls:'icon-refresh',
						handler:function(){clearFind();} //清除树过滤
					}] 
	});
	
	var savedeletearr=[];	//定义保存删除数组

	StockmenuPanel.on("checkchange",function (node, checked){
		
		if (node.id.split("^").length==2){	//包含一个"^",是子节点
			var locid=node.id.split("^")[0];	//科室id
			var listid=node.id.split("^")[1];	//科室列表id
			savedeletearr[locid]=listid+"^"+checked;
		}
		/*
		if (checked==true){//添加
			var ID=node.id;
			var arryTmpRowId = ID.split("^");
			var STCTLOCDR=arryTmpRowId[0];
			var STParRef = arryTmpRowId[1];
			var SaveTreePanelResult = tkMakeServerCall("web.DHCBL.CT.CTLocationListLocations","SaveTreePanel",STParRef,STCTLOCDR);
		}
		else{//删除
			var ID=node.id;
			var arryTmpRowId = ID.split("^");
			var STCTLOCDR=arryTmpRowId[0];
			var STParRef = arryTmpRowId[1];
			var DeleteTreePanelResult = tkMakeServerCall("web.DHCBL.CT.CTLocationListLocations","DeleteTreePanel",STParRef,STCTLOCDR);
		}
		*/
	},this,{stopEvent:true});
		
	var winCTLocGroupStock = new Ext.Window({
			title:'',
			width:700,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: StockmenuPanel,
			buttons:[{
				text:'保存',
				id:'saveGroupStock_btn',
				iconCls : 'icon-save',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
				handler:function(){
					//获取所有变动的数据
					var savestr=""
					for (var i = 0; i < savedeletearr.length; i++) {
						if (savedeletearr[i]!=undefined){
							if (savestr!="") savestr=savestr+"$";
							savestr=savestr+i+"^"+savedeletearr[i];
						}
					}
					//alert(savestr);
					var saveResult = tkMakeServerCall("web.DHCBL.CT.CTLocationListLocations","UpdateTree",savestr);
					//winCTLocGroupStock.hide();
					Ext.Msg.show({
						title : '提示',
						msg : '保存成功！',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK,
						fn : function(btn) {
							clearFind();
						}
					});
				}
			}, {
				text : '关闭',
				iconCls : 'icon-close',
				handler : function() {
					winCTLocGroupStock.hide();
				}
			}],
			listeners:{
				"show":function(){
					Ext.getCmp('FindTreeText').reset();
					Ext.getCmp('LinkLocHosp').reset();
					Ext.getCmp('LinkLocDepGrp').reset();
					hiddenPkgs = [];
					savedeletearr = [];		//清空保存删除数组
				},
				"hide":function(){
					Ext.getCmp('FindTreeText').reset();
					Ext.getCmp('LinkLocHosp').reset();
					Ext.getCmp('LinkLocDepGrp').reset();
					hiddenPkgs = [];
					savedeletearr = [];		//清空保存删除数组
				},
				"close":function(){
				}
			}
		});

	/*******************************检索功能********************************/	
	
	var timeOutId = null;
	var treeFilter = new Ext.tree.TreeFilter(StockmenuPanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node) {
		clearTimeout(timeOutId);// 清除timeOutId
		StockmenuPanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				if (n.ui!=null)
				{
					n.ui.show();
				}
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					return !n.isLeaf() || re.test(n.text);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				StockmenuPanel.root.cascade(function(n) {
					if((n.id!='0')&&(n.id!='StockTreeRoot')){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				//clearFind();
				return;
			}
		}, 500);
	}
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			if(n1.isLeaf()){
				if(re.test(n1.text)){ str=true;return; }
			} else {
				if(re.test(n1.text)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		Ext.getCmp('LinkLocHosp').reset();
		Ext.getCmp('LinkLocDepGrp').reset();
		StockmenuPanel.root.cascade(function(n) {
				if(n.id!='StockTreeRoot'){
					n.ui.show();
				}
				n.ui.show(); /// 清空后重新加载
		});
		StockmenuTreeLoader.dataUrl = STOCKTREE_QUERY_ACTION_URL+ '&loclistid='+Ext.getCmp("Hidden_GroupID").getValue();
		StockmenuPanel.root.reload();
	}
	/*******************************检索功能完********************************/	
	
	var btnCTLocGroupStock = new Ext.Toolbar.Button({
	    text: '批量关联科室',
	    id:'btnCTLocGroupStock',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocGroupStock'),
        iconCls: 'icon-DP',
		tooltip: '批量关联科室',
        handler: CTLocGroupStockWinEdit =function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 Hidden_GroupStock_CTLocID
            var SSGRPRowIdForStock=rows[0].get('LLRowId');
            Ext.getCmp("Hidden_GroupID").reset();
           	Ext.getCmp("Hidden_GroupID").setValue(SSGRPRowIdForStock);
           	StockmenuTreeLoader.dataUrl = STOCKTREE_QUERY_ACTION_URL+ '&loclistid='+Ext.getCmp("Hidden_GroupID").getValue();
			StockmenuPanel.root.reload();
			winCTLocGroupStock.setTitle('批量关联科室');
			winCTLocGroupStock.setIconClass('icon-DP');
			winCTLocGroupStock.show('');
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择科室列表数据!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	
	/****************************批量关联科室按钮 树形 完***************************/
	
    //关联科室 数据存储
    var child_ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : ACTION_URL2 }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                                    name : 'LOCRowId',
                                    mapping : 'LOCRowId',
                                    type : 'string'
                                }, {
                                    name : 'ParRef',
                                    mapping : 'ParRef2',
                                    type : 'string'
                                },{
                                    name : 'HospitalCTDR',
                                    mapping : 'HospitalCTDR',
                                    type : 'string'
                                }, {
                                    name : 'CTLOCDR',
                                    mapping : 'CTLOCDR',
                                    type : 'string'
                                } 
                        ]) 
            });
    child_ds.load({ params : { 
    
    start : 0, limit : pagesize_pop },
                callback : function(records, options, success) {
                }
            }); // 加载数据
            
    // 账单子组表格
    var grid2 = new Ext.grid.GridPanel({
                id : 'grid2',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : child_ds,
                trackMouseOver : true,
                columnLines : true, //在列分隔处显示分隔符
                // tools:Ext.BDP.FunLib.Component.HelpMsg,
                columns : [new Ext.grid.CheckboxSelectionModel({
                            width : 20
                        }),{
                            header : 'LOCRowId',
                            width : 160,
                            sortable : true,
                            dataIndex : 'LOCRowId',
                            hidden : true
                        }, {
                            header : 'ParRef',
                            width : 160,
                            sortable : true,
                            dataIndex : 'ParRef',
                            hidden : true
                        },{
                            header : '医院',
                            width : 160,
                            sortable : true,
                            dataIndex : 'HospitalCTDR'
                        }, {
                            header : '科室',
                            width : 160,
                            sortable : true,
                            dataIndex : 'CTLOCDR'
                        }],
                stripeRows : true ,
                // config options for stateful behavior
                stateful : true,
                viewConfig : {
                    forceFit : true,
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'"
                },
                sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
                bbar : new Ext.PagingToolbar({
                     pageSize: pagesize_pop,
                     store: child_ds,
                     displayInfo: true,
                     displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                     emptyMsg : "没有记录",
                     plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                     listeners : {
                          "change":function (t,p)
                         { 
                             pagesize_pop=this.pageSize;
                         }
                       }
                    }),
                  tbar : new Ext.Toolbar({
                     items : [ 
                        '科室', {
                            id : 'TextDesc2' ,
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2'),
                            xtype : 'bdpcombo',
                            fieldLabel : '<font color=red>*</font>科室',
                            name : 'CTLOCDR2',
                            stripCharsRe :  ' ',
                            store : new Ext.data.Store({
                            autoLoad: true,
                            proxy : new Ext.data.HttpProxy({ url : LOC_QUERY_ACTION }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                            queryParam : 'desc',
                            //triggerAction : 'all',
                            selectOnFocus : false,
                        //  typeAhead : true,
                            minChars : 0,
                            listWidth : 250,
                            valueField : 'CTLOCRowID',
                            displayField : 'CTLOCDesc',
                            pageSize : comboPage/*,
                           listeners : {
                                'beforequery':function(obj){
                                    obj.combo.store.load({
                                            params:{
                                                    start:0,
                                                    limit:10,
                                                    rowid:'',
                                                    desc:obj.combo.getRawValue() 
                                                }
                                            });
                                    return false;
                                }
                            }*/
                        },
                                    new Ext.Button(
                                                {   
                                                    iconCls :'icon-search',
                                                    text : '搜索',
                                                    id:'searchbtn',
                                                    disabled : Ext.BDP.FunLib.Component.DisableFlag('searchbtn'),
                                                    handler : function() {
                                                                    var gsm = grid.getSelectionModel();// 获取选择列
                                                                    var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                                    grid2.getStore().baseParams={           
                                                                        //code : Ext.getCmp("TextCode2").getValue(),
                                                                        desc : Ext.getCmp("TextDesc2").getValue(),                                      
                                                                        ParRef: rows[0].get('LLRowId') 
                                                                    };
                                                        
                                                                    grid2.getStore().load({
                                                                    params : {
                                                                                start : 0,
                                                                                limit : pagesize_pop
                                                                            }
                                                                        });
                                                                    }
         
                                                    }),  '-',
                                    new Ext.Button({ iconCls : 'icon-refresh',
                                                        text : '重置',
                                                        id:'resbtn',
                                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('resbtn'),
                                                        handler : function() {
                                                        //  Ext.getCmp("TextCode2").reset();                        //-----------将输入框清空
                                                            Ext.getCmp("TextDesc2").reset();    
                                                            var gsm = grid.getSelectionModel();// 获取选择列
                                                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                            grid2.getStore().baseParams={ ParRef: rows[0].get('LLRowId') };
                                                            grid2.getStore().load({ params : { start : 0, limit : pagesize_pop } });
                                                             
                                                        }
                                                    })
                                    ],
                            listeners : {
                                    render : function() {
                                    tbbutton2.render(grid2.tbar) 
                                    }
                            }
                        })
            });

            var loadFormData2 = function(grid2){
            var _record2 = grid2.getSelectionModel().getSelected(); 
            if (!_record2) {
                Ext.Msg.alert('修改操作', '请选择要修改的一项!');
            } else {
                    WinForm2.form.load( {
                    url : OPEN_ACTION_URL + '&sid='+ _record2.get('LOCRowId'),   
                    success : function(form,action) {
                } 
               });
            }
        };
        grid2.on("rowdblclick", function(grid2, rowIndex, e) {
                var row = grid2.getStore().getAt(rowIndex).data;
                win2.setTitle('修改');      
                win2.setIconClass('icon-update');
                win2.show('');
                loadFormData2(grid2);
        }); 
        
        
    // 关联科室维护窗口     
    var win3 = new Ext.Window({
        title : '关联科室',
        width : 800,
        height : 500,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        //autoScroll : true,
        collapsible : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        constrain : true,
        closeAction : 'hide',
        items : [grid2],
        listeners : {
                        "show" : function(){
                            Ext.getCmp("TextDesc2").reset();
                            if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
                            {
                                keymap_main.disable();
                                keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData2,UpdateData2,DelData2);
                            }                           
                        },
                        "hide" : function(){
                            child_ds.removeAll();
                            if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
                            {
                                keymap_pop.disable();
                                keymap_main.enable();
                            }
                        },
                        "close" : function(){
                        }
                    }
    });
    
    // 进入关联科室维护按钮
    var btnD = new Ext.Toolbar.Button({
                text : '关联科室',
                tooltip : '关联科室',
                iconCls : 'icon-DP',
                id:'billbtn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('billbtn'),
                handler : function() {
                    if (grid.selModel.hasSelection()) {
                         
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                         win3.setTitle(rows[0].get('LLDesc')+"-关联科室")
                        grid2.getStore().baseParams={ ParRef: rows[0].get('LLRowId') 
                         
                        };
                        grid2.getStore().load({ params : { start : 0, limit : pagesize_pop } });
                        win3.show();
                    } else {
                        Ext.Msg.show({
                                    title : '提示',
                                    msg : '请选择要查看关联科室的一行数据！',
                                    icon : Ext.Msg.WARNING,
                                    buttons : Ext.Msg.OK
                                });
                    }

                }
            });
            
    //关联科室维护工具条
    var tbbutton2 = new Ext.Toolbar({
        enableOverflow : true,
        items : [new Ext.Button({text:'添加', tooltip : '添加', iconCls : 'icon-add',id:'subadd',
                                                    disabled:Ext.BDP.FunLib.Component.DisableFlag('subadd'),
                                                    handler : function AddData2() {
                                                        var gsm = grid.getSelectionModel();// 获取选择列
                                                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                        var ParentRowId = rows[0].get('LLRowId')
                                                        win2.setTitle('添加');
                                                        win2.setIconClass('icon-add');
                                                        win2.show('new1');
                                                        WinForm2.getForm().reset();
                                                        WinForm2.getForm().findField('ParentRowId').setValue(ParentRowId);
                                                    },
                                                    scope : this
                                                }), '-',
                                    new Ext.Button({text : '修改',tooltip : '修改',iconCls : 'icon-update',id:'subupdate',
                                                    disabled:Ext.BDP.FunLib.Component.DisableFlag('subupdate'),
                                                    handler : function UpdateData2() {
                                                        if (grid2.selModel.hasSelection()) {
                                                            win2.setTitle('修改');
                                                            win2.setIconClass('icon-update');
                                                            
                                                            var record = grid2.getSelectionModel().getSelected(); 
                                                            WinForm2.getForm().reset();
                                                            win2.show();
                                                            loadFormData2(grid2);
                                                        } else {
                                                            Ext.Msg.show({
                                                                    title : '提示',
                                                                    msg : '请选择需要修改的行！',
                                                                    icon : Ext.Msg.WARNING,
                                                                    buttons : Ext.Msg.OK
                                                            });
                                                        }
                                                    }
                                        }), '-', btnDel2,'->',btnlogsub,'-',btnhislogsub] 
                });
        
    // 科室ds
    var fields= [{
                    name : 'LLRowId',
                    mapping : 'LLRowId',
                    type : 'int'
                }, {
                    name : 'LLCode',
                    mapping : 'LLCode',
                    type : 'string'
                }, {
                    name : 'LLDesc',
                    mapping : 'LLDesc',
                    type : 'string'
                }]
    
    var ds = new Ext.data.Store({
            proxy : new Ext.data.HttpProxy({ url : ACTION_URL }), 
            reader : new Ext.data.JsonReader({
                        totalProperty : 'total',
                        root : 'data',
                        successProperty : 'success'
                    },fields) 
        });
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);  
    ds.load({ params : { start : 0, limit : limit },
                callback : function(records, options, success) {
                }
            });  
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
            
    // 科室增删改工具条
    var tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-', btnD,'-', btnCTLocGroupStock,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
    });

    // 科室搜索工具条
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                iconCls : 'icon-search',
                text : '搜索',
                handler : function() {
                    grid.getStore().baseParams={            
                        code : Ext.getCmp('TextCode').getValue(),
                        desc : Ext.getCmp('TextDesc').getValue()
                    };
                    grid.getStore().load({ params : { start : 0, limit : limit } });
                }
            });
            
    // 科室刷新工作条
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                iconCls : 'icon-refresh',
                text : '重置',
                handler : function() {
                    Ext.BDP.FunLib.SelectRowId="";
                    Ext.getCmp('TextCode').reset();
                    Ext.getCmp('TextDesc').reset();
                    grid.getStore().baseParams={};
                    grid.getStore().load({ params : { start : 0, limit : limit } });
                }
            });
            
    // 将工具条放到一起
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['代码', { xtype : 'textfield', id : 'TextCode' ,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},
                        '描述/别名', { xtype : 'textfield', id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc') }, 
                        '-',LookUpConfigureBtn,'-',btnSearch, '-', btnRefresh, '->'
                ],
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
                    }
                }
            });
            
    // 科室信息create the Grid
    var GridCM=[sm, {
                            header : 'LLRowId',
                            width : 160,
                            sortable : true,
                            dataIndex : 'LLRowId',
                            hidden : true
                        }, {
                            header : '代码',
                            width : 160,
                            sortable : true,
                            dataIndex : 'LLCode'
                        }, {
                            header : '描述',
                            width : 160,
                            sortable : true,
                            dataIndex : 'LLDesc'
                        }];
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : ds,
                trackMouseOver : true,
                columnLines : true, 
                tools:Ext.BDP.FunLib.Component.HelpMsg,
                columns : GridCM,
                stripeRows : true,
                title : '科室列表',
                stateful : true,
                viewConfig : { 
                forceFit : true ,
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'"
                },
                sm: new Ext.grid.RowSelectionModel({ singleSelect : true }),
                bbar : paging,
                tbar : tb,
                stateId : 'grid'
            });
    Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
    btnTrans.on("click",function(){
        if (grid.selModel.hasSelection())
        {
          var _record=grid.getSelectionModel().getSelected();
          var selectrow=_record.get('LLRowId');
         }
        else
        {
          var selectrow=""
         }
        Ext.BDP.FunLib.SelectRowId=selectrow
  });       
      var loadFormData = function(grid){
            var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
            if (!_record) {
                Ext.Msg.alert('修改操作', '请选择要修改的一项!');
            } else {
                    WinForm.form.load( {
                    url : OPEN__URL + '&id='+ _record.get('LLRowId'),  //id 对应OPEN里的入参
                    success : function(form,action) {
                   },
                    failure : function(form,action) {
                    }
                });
                //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('LLRowId');
               AliasGrid.loadGrid();
            }
        };
        grid.on("rowdblclick", function(grid, rowIndex, e) {
			if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
                var row = grid.getStore().getAt(rowIndex).data;
                win.setTitle('修改');      
                win.setIconClass('icon-update');
                win.show();
                loadFormData(grid);
			}
        }); 
      Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
      Ext.BDP.FunLib.ShowUserHabit(grid2,"User.CTLocationListLocations");
      /**************************************调用keymap ***********************************************/
     var keymap_main = Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    var viewport = new Ext.Viewport({
            layout : 'border',
            items : [grid]
    });
  });
