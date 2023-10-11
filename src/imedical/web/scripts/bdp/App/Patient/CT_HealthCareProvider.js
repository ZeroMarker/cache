/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 病人管理-合同单位维护
 * @Created on 2015-03-04
 * @Updated on  
 * @LastUpdated on 
 */ 
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    var limit = Ext.BDP.FunLib.PageSize.Main;
    var comboPage=Ext.BDP.FunLib.PageSize.Combo;
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
    var ALGDrugMastDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassQuery=GetDataForCmb1";
    var ALGAllergyDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassQuery=GetDataForCmb1";
   
    var HCPRegionDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTRegion&pClassQuery=GetDataForCmb1";
    var HCPInternAgreemDR_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTInternatAgreem&pClassQuery=GetDataForCmb1";
    var HCPHCADR_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareArea&pClassQuery=GetDataForCmb1";
    /// 调用过敏源维护的后台类方法
    var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassQuery=GetList";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassMethod=OpenData";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHealthCareProvider";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassMethod=DeleteData";
     
    /*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.CTHealthCareProvider";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    var GETTAG_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareProvider&pClassMethod=FindTagByType";
      //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
        TableN : "CT_HealthCareProvider"
     });
     Ext.BDP.FunLib.TableName="CT_HealthCareProvider";
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
           RowID=rows[0].get('HCPRowId');
           Desc=rows[0].get('HCPDesc');
           var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
        }
        else
        {
           var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
        }
  });
   //多院区医院下拉框
    var hospComp=GenHospComp(Ext.BDP.FunLib.TableName); 
    //医院下拉框选择一条医院记录后执行此函数   
    hospComp.on('select',function (){
         grid.enable();
         grid.getStore().baseParams={           
                code : Ext.getCmp("TextCode").getValue() ,
                desc :Ext.getCmp("TextDesc").getValue(),
                hospid:hospComp.getValue()                  
        };
        grid.getStore().load({
                    params : {
                        start : 0,
                        limit : limit
                    }
                });
        
    });
    //多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
                var rowid=grid.getSelectionModel().getSelections()[0].get("HCPRowId");
                GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
            }
            else
            {
                alert('请选择需要授权的记录!')
            }        
    });
    /*****************************删除功能***************************************************/
    var btnDel = new Ext.Toolbar.Button({
          text : '删除',
          tooltip : '删除',
          iconCls : 'icon-delete',
          id : 'del_btn',
          disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
          handler : DelData=function() {   
            if (grid.selModel.hasSelection()) {
                var gsm = grid.getSelectionModel();
                var rows = gsm.getSelections();
                Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
                    if (btn == 'yes') {
                        //删除所有别名
                        AliasGrid.DataRefer=rows[0].get('HCPRowId') ;
                        AliasGrid.delallAlias();
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id' : rows[0].get('HCPRowId')
                            },
                            callback : function(options, success, response) {
                                if (success) {
                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                    if (jsonData.success == 'true') {
                                        Ext.Msg.show({
                                                title : '提示',
                                                msg : '数据删除成功!',
                                                icon : Ext.Msg.INFO,
                                                buttons : Ext.Msg.OK,
                                                fn : function(btn) {
                                                   Ext.BDP.FunLib.DelForTruePage(grid,limit);
                                                 }
                                           });
                                    } else {
                                        var errorMsg = '';
                                        if (jsonData.info) {
                                            errorMsg = '<br/>错误信息:' + jsonData.info
                                        }
                                        Ext.Msg.show({
                                                       title : '提示',
                                                       msg : '数据删除失败!' + errorMsg,
                                                       minWidth : 200,
                                                       icon : Ext.Msg.ERROR,
                                                       buttons : Ext.Msg.OK
                                                    });
                                        }
                                } else {
                                    Ext.Msg.show({
                                                   title : '提示',
                                                   msg : '异步通讯失败,请检查网络连接!',
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
                                msg : '请选择需要删除的行!',
                                icon : Ext.Msg.WARNING,
                                buttons : Ext.Msg.OK
                           });
                 }
             }
     });

    /***************************** 增加修改的Form*****************************************/
    var WinForm = new Ext.FormPanel({
                id : 'form-save',
                URL : SAVE_ACTION_URL,
                labelAlign : 'right',
                labelWidth : 85,
                title:'基本信息',
                split : true,
                frame : true,           
                reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'HCPCode',mapping:'HCPCode'},
                                         {name: 'HCPDesc',mapping:'HCPDesc'},
                                         {name: 'HCPHCADR',mapping:'HCPHCADR'},
                                         {name: 'HCPInternAgreemDR',mapping:'HCPInternAgreemDR'},
                                         {name: 'HCPRegionDR',mapping:'HCPRegionDR'},
										 {name: 'HCPActiveFlag',mapping:'HCPActiveFlag'},
                                         {name: 'HCPRowId',mapping:'HCPRowId'}
                                        ]),
                defaults : {
                    anchor : '85%',
                    border : false
                },
                items : [{
                            id:'HCPRowId',
                            xtype:'textfield',
                            fieldLabel : 'HCPRowId',
                            name : 'HCPRowId',
                            hideLabel : 'True',
                            hidden : true
                        }, {
                            labelSeparator:"",
                            fieldLabel : '<font color=red>*</font>代码',
                            xtype:'textfield',
                            id:'HCPCodeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCPCodeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCPCodeF')),
                            name : 'HCPCode',
                            allowBlank:false,
                            enableKeyEvents:true, 
                            validationEvent : 'blur',  
                            validator : function(thisText){
                                if(thisText==""){
                                    return true;
                                }
                                var className =  "web.DHCBL.CT.CTHealthCareProvider";
                                var classMethod = "FormValidate";                           
                                var id="";
                                if(win.title=='修改'){
                                    var _record = grid.getSelectionModel().getSelected();
                                    var id = _record.get('HCPRowId');
                                }
                                var flag = "";
                                var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());
                                if(flag == "1"){
                                    return false;
                                 }else{
                                    return true;
                                 }
                            },
                            invalidText : '该代码已经存在',
                            listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
                        }, {
                            fieldLabel : '<font color=red>*</font>描述',
                            xtype:'textfield',
                            labelSeparator:"",
                            id:'HCPDescF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCPDescF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCPDescF')),
                            name : 'HCPDesc',
                            allowBlank:false,
                            enableKeyEvents:true, 
                            validationEvent : 'blur',
                            validator : function(thisText){
                                if(thisText==""){
                                    return true;
                                }
                                var className =  "web.DHCBL.CT.CTHealthCareProvider";
                                var classMethod = "FormValidate";
                                var id="";
                                if(win.title=='修改'){
                                    var _record = grid.getSelectionModel().getSelected();
                                    var id = _record.get('HCPRowId');
                                }
                                var flag = "";
                                var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hospComp.getValue());
                                if(flag == "1"){
                                    return false;
                                 }else{
                                    return true;
                                 }
                            },
                            invalidText : '该描述已经存在',
                            listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
                            
                        }, {  
                            xtype : "bdpcombo",
                            labelSeparator:"",
                            fieldLabel : '健康保护区域',
                            loadByIdParam:'rowid',
                            hiddenName : 'HCPHCADR',
                            id:'HCPHCADRF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCPHCADRF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCPHCADRF')),
                            store : new Ext.data.Store({
                                        autoLoad: true,
                                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
                                        proxy : new Ext.data.HttpProxy({ url :HCPHCADR_ACTION_URL  }),
                                        reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [{ name:'HCARowId',mapping:'HCARowId'},
                                        {name:'HCADesc',mapping:'HCADesc'} ])
                                }),
                            mode : 'local',
                            shadow:false,
                            pageSize: comboPage ,
                            listWidth : 250,
                            forceSelection : true,
                            selectOnFocus : false,
                            queryParam : 'desc',
                            displayField : 'HCADesc',
                            valueField : 'HCARowId'  
                        }, {
                            xtype : "bdpcombo",
                            labelSeparator:"",
                            fieldLabel : '国际协定',
                            loadByIdParam:'rowid',
                            hiddenName : 'HCPInternAgreemDR',
                            id:'HCPInternAgreemDRF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCPInternAgreemDRF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCPInternAgreemDRF')),
                            store : new Ext.data.Store({
                                        autoLoad: true,
                                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
                                        proxy : new Ext.data.HttpProxy({ url :HCPInternAgreemDR_ACTION_URL  }),
                                        reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [{ name:'INAGRowId',mapping:'INAGRowId'},
                                        {name:'INAGDesc',mapping:'INAGDesc'} ])
                                }),
                            mode : 'local',
                            shadow:false,
                            pageSize: comboPage ,
                            listWidth : 250,
                            forceSelection : true,
                            selectOnFocus : false,
                            queryParam : 'desc',
                            displayField : 'INAGDesc',
                            valueField : 'INAGRowId'  
                        }, {
                            xtype : "bdpcombo",
                            labelSeparator:"",
                            fieldLabel : '区域',
                            loadByIdParam:'rowid',
                            hiddenName : 'HCPRegionDR',
                            id:'HCPRegionDRF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCPRegionDRF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCPRegionDRF')),
                            store : new Ext.data.Store({
                                        autoLoad: true,
                                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
                                        proxy : new Ext.data.HttpProxy({ url : HCPRegionDR_QUERY_ACTION_URL }),
                                        reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [{ name:'CTRGRowId',mapping:'CTRGRowId'},
                                        {name:'CTRGDesc',mapping:'CTRGDesc'} ])
                                }),
                            mode : 'local',
                            shadow:false,
                            pageSize: comboPage ,
                            listWidth : 250,
                            forceSelection : true,
                            selectOnFocus : false,
                            queryParam : 'desc',
                            displayField : 'CTRGDesc',
                            valueField : 'CTRGRowId'
                        },{
							xtype:'checkbox',
							fieldLabel : '有效标志',
							id : 'HCPActiveFlagF',
							name : 'HCPActiveFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCPActiveFlagF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCPActiveFlagF')),
							inputValue : true ? 'Y' : 'N',
							checked : true
						} ] 
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
    /**************************************增加修改时弹出窗口*********************************/
    var win = new Ext.Window({
        width : 460,
        height: 330,
        layout : 'fit',
        closeAction : 'hide',
        plain : true,
        modal : true,
        frame : true,
        autoScroll : true,
        collapsible : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        items : tabs,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
            handler : function() {
            var tempCode = Ext.getCmp("form-save").getForm().findField("HCPCodeF").getValue();
            var tempDesc = Ext.getCmp("form-save").getForm().findField("HCPDescF").getValue();
            
            if (tempCode=="") {
                Ext.Msg.show({ 
                                title : '提示', 
                                msg : '代码不能为空!',
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                 Ext.getCmp("form-save").getForm().findField("HCPCodeF").focus(true,true);
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
                                    buttons : Ext.Msg.OK ,
                                    fn:function()
                                    {
                                     Ext.getCmp("form-save").getForm().findField("HCPDescF").focus(true,true);
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
                        url : SAVE_ACTION_URL,
                        clientValidation : true,
                        method : 'POST', 
                        params : {                                   
                            'LinkHospId' :hospComp.getValue()         
                        },
                        success : function(form, action) {
                            if (action.result.success == 'true') {
                                var myrowid = action.result.id;
                                 win.hide();
                                 Ext.Msg.show({
                                                title : '提示',
                                                msg : '添加成功!',
                                                icon : Ext.Msg.INFO,
                                                buttons : Ext.Msg.OK,
                                                fn : function(btn) {
                                                    grid.getStore().load({
                                                            params : {
                                                                        start : 0,
                                                                        limit : 1,
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
                                               msg : '添加失败!' + errorMsg,
                                               minWidth : 200,
                                               icon : Ext.Msg.ERROR,
                                              buttons : Ext.Msg.OK
                                          });
                               }
                         },
                        failure : function(form, action) {
                            Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
                         }
                     });
                 } 
         else {
            Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
                if (btn == 'yes') {
                    WinForm.form.submit({
                            clientValidation : true, // 进行客户端验证
                            url : SAVE_ACTION_URL,
                            method : 'POST',
                             success : function(form, action) {
                                AliasGrid.saveAlias(); 
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
                                                        Ext.BDP.FunLib.ReturnDataForUpdate('grid',QUERY_ACTION_URL,myrowid);
                                                    }
                                               }); 
                                    } else {
                                        var errorMsg = '';
                                        if (action.result.errorinfo) {
                                            errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                        }
                                        Ext.Msg.show({
                                                      title : '提示',
                                                      msg : '修改失败!' + errorMsg,
                                                      minWidth : 200,
                                                      icon : Ext.Msg.ERROR,
                                                      buttons : Ext.Msg.OK
                                                 });
                                        }
                                },
                                failure : function(form, action) {
                                    Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
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
                Ext.getCmp("form-save").getForm().findField("HCPCode").focus(true,300);
            },
            "hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
            "close" : function() {
            }
        }
    });
    
    /***********************************增加按钮**************************************************/
    var btnAddwin = new Ext.Toolbar.Button({
                text : '添加',
                tooltip : '添加',
                iconCls : 'icon-add',
                id:'add_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
                handler : AddData=function() {
                    win.setTitle('添加');
                    win.setIconClass('icon-add');
                    win.show();
                    WinForm.getForm().reset();
                    tabs.setActiveTab(0);
                    //清空别名面板grid
                    AliasGrid.DataRefer = "";
                    AliasGrid.clearGrid();
                },
                scope: this
      });
    
    /**************************************修改按钮********************************************/
    var btnEditwin = new Ext.Toolbar.Button({
                text : '修改',
                tooltip : '修改',
                iconCls : 'icon-update',
                id:'update_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
                handler : UpdateData=function() {
                    if (grid.selModel.hasSelection()) {
                        loadFormData(grid);
                    } else {
                            Ext.Msg.show({
                                            title : '提示',
                                            msg : '请选择需要修改的行！',
                                            icon : Ext.Msg.WARNING,
                                            buttons : Ext.Msg.OK
                                        });
                            }
                 }
        });
    var fields=[{
                    name : 'HCPRowId',
                    mapping : 'HCPRowId',
                    type : 'number'
                }, {
                    name : 'HCPCode',
                    mapping : 'HCPCode',
                    type : 'string'
                }, {
                    name : 'HCPDesc',
                    mapping : 'HCPDesc',
                    type : 'string'
                }, {
                    name : 'HCPHCADR',
                    mapping : 'HCPHCADR',
                    type : 'string'
                },{
                    name : 'HCPInternAgreemDR',
                    mapping : 'HCPInternAgreemDR',
                    type : 'string' 
                }, {
                    name : 'HCPRegionDR',
                    mapping : 'HCPRegionDR',
                    type : 'string' 
                },{
					name:'HCPActiveFlag',
					mapping:'HCPActiveFlag',
					type:'string'
				}] 
                        
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        },fields) 
         });
   Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);       
    // 加载数据
   ds.load({
              params : { start : 0, limit : limit },
              callback : function(records, options, success) { 
             }
        });
    
    /** **************************grid分页工具条**************************************/
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

    /*************************************增删改工具条******************************************/
    var tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',HospWinButton ,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
    });
    
    /****************************************搜索工具条*************************************/
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                tooltip : '搜索',
                iconCls : 'icon-search',
                text : '搜索',
                handler : function() {
                grid.getStore().baseParams={
                        code :  Ext.getCmp("TextCode").getValue(),
                        desc :  Ext.getCmp("TextDesc").getValue(),
                        hospid:hospComp.getValue()      
                };
        grid.getStore().load({
                    params : {
                                start : 0,
                                limit : limit
                            }
                });
          }
    });
    
    // 刷新工作条
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                tooltip : '重置',
                iconCls : 'icon-refresh',
                text : '重置',
                handler : function() {
                            Ext.BDP.FunLib.SelectRowId="";
                            Ext.getCmp("TextCode").reset();
                            Ext.getCmp("TextDesc").reset();
                                grid.getStore().baseParams={hospid:hospComp.getValue()};
                            grid.getStore().load({
                                    params : {
                                               start : 0,
                                               limit : limit
                                            }
                        });
                  }
        });
    
    // 将工具条放到一起
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['代码', {xtype : 'textfield',id : 'TextCode',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
                },'-', '描述/别名', {xtype : 'textfield',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-',LookUpConfigureBtn,'-',btnSearch,'-', btnRefresh,'-' 
                    ],
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar)
                    }
                }
    });

    // 创建Grid
    var GridCM=[new Ext.grid.CheckboxSelectionModel(),  {
                            header : 'HCPRowId',
                            width : 70,
                            sortable : true,
                            dataIndex : 'HCPRowId',
                            hidden : true
                        }, {
                            header : '代码',
                            width : 80,
                            sortable : true,
                            dataIndex : 'HCPCode'
                        }, {
                            header : '描述',
                            width : 100,
                            sortable : true,
                            dataIndex : 'HCPDesc'
                        }, {
                            header : '健康保护区域',
                            width : 100,
                            sortable : true,
                            dataIndex : 'HCPHCADR'
                        },{
							header:'有效标志',
							sortable:true,
							dataIndex:'HCPActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
                            header : '国际协定',
                            width : 80,
                            sortable : true,
                            dataIndex : 'HCPInternAgreemDR'
                        }, {
                            header : '区域',
                            width : 80,
                            sortable : true,
                            dataIndex : 'HCPRegionDR'
                        }];
    var grid = new Ext.grid.GridPanel({
                title : '合同单位',
                id : 'grid',
                region : 'center',
                width : 900,
                height : 500,
                tools:Ext.BDP.FunLib.Component.HelpMsg,
                closable : true,
                store : ds,
                trackMouseOver : true,
                sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
                columns :GridCM,
                stripeRows : true,
                stateful : true,
                viewConfig : {
                    forceFit : true
                },
                bbar : paging,
                tbar : tb,
                stateId : 'grid'    
    });
    Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
    /// 单击事件：翻译要用到
    btnTrans.on("click",function(){
        if (grid.selModel.hasSelection())
        {
          var _record=grid.getSelectionModel().getSelected();
          var selectrow=_record.get('HCPRowId');
         }
        else
        {
          var selectrow=""
         }
        Ext.BDP.FunLib.SelectRowId=selectrow
  });
   /********************************载入被选择的数据行的表单数据*******************************************/
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
        } else {
            win.setTitle('修改');
            win.setIconClass('icon-update');
            win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('HCPRowId'),
                success : function(form,action) {
                   
                },
                failure : function(form,action) {
                }
            });
             //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('HCPRowId');
               AliasGrid.loadGrid();
        }
    };
    
    grid.on("rowdblclick", function(grid, rowIndex, e) {
        loadFormData(grid);
    }); 
    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
     /*********************************IE下的快捷键操作*******************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
        ///多院区医院
    var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
    if (flag=="Y"){
        grid.disable();
    }
    else
    {
        /** grid加载数据 */
        ds.load({
            params : {
                start : 0,
                limit : limit
            },
            callback : function(records, options, success) {
            }
        });
    
    }
    // 创建viewport
    var viewport = new Ext.Viewport({
         layout : 'border',
          items : [GenHospPanel(hospComp),grid]
    });
});