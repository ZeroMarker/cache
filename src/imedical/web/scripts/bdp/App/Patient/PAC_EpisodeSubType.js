/// 名称: 就诊子类型维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组- sunfengchao
/// 编写日期: 2012-8-30

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
    var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACEpisodeSubType&pClassQuery=GetList";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACEpisodeSubType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACEpisodeSubType";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACEpisodeSubType&pClassMethod=OpenData";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACEpisodeSubType&pClassMethod=DeleteData";
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    
    /*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.PACEpisodeSubType";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    //初始化“别名”维护面板
    var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
        TableN : "PAC_EpisodeSubType"
    });
    Ext.BDP.FunLib.TableName="PAC_EpisodeSubType";
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
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName) ;
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
       RowID=rows[0].get('SUBTRowId');
       Desc=rows[0].get('SUBTDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
    /*************************** 删除按钮 ******************************/
    var btnDel = new Ext.Toolbar.Button({
        text : '删除',
        tooltip : '请选择一行后删除(Shift+D)',
        iconCls : 'icon-delete',
        id:'del_btn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
        handler : DelData=function() {
            if (grid.selModel.hasSelection()) {
                Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
                    if (btn == 'yes') {
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        
                        //删除所有别名
                        AliasGrid.DataRefer = rows[0].get('SUBTRowId');
                        AliasGrid.delallAlias();
                        
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id' : rows[0].get('SUBTRowId')
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
                                                                 Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
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
    /** 创建Form表单 */
    var WinForm = new Ext.form.FormPanel({
                id : 'form-save',
                labelAlign : 'right',
                labelWidth : 160,
                title : '基本信息',
                frame : true,
                reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'SUBTRowId',mapping:'SUBTRowId',type:'int'},
                                         {name: 'SUBTCode',mapping:'SUBTCode',type:'string'},
                                         {name: 'SUBTDesc',mapping:'SUBTDesc',type:'string'},
                                         {name: 'SUBTAdmType',mapping:'SUBTAdmType',type:'string'},
                                         {name:'SUBTDaySurgery',mapping:'SUBTDaySurgery',type:'string'},
                                         {name:'SUBTFirstRegDayNight',mapping:'SUBTFirstRegDayNight',type:'string',inputValue : true?'Y':'N'},
                                         {name: 'SUBTDateFrom',mapping:'SUBTDateFrom',type:'string'},
                                         {name: 'SUBTDateTo',mapping:'SUBTDateTo',type:'string'}
                                   ]),
                defaults : {
                    anchor : '80%',
                    border : false
                },
                defaultType : 'textfield',
                items : [{
                            fieldLabel : 'SUBTRowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'SUBTRowId'
                        }, {
                            fieldLabel : '<font color=red>*</font>代码',
                            labelSeparator:"",
                            name : 'SUBTCode',
                            id:'SUBTCodeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTCodeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTCodeF')),
                            allowBlank : false,
                            validationEvent : 'blur',  
                            validator : function(thisText){
                                if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                                    return true;
                                }
                                var className =  "web.DHCBL.CT.PACEpisodeSubType";  //后台类名称
                                var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                                var id="";
                                if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
                                    var _record = grid.getSelectionModel().getSelected();
                                    var id = _record.get('SUBTRowId'); //此条数据的rowid
                                }
                                var flag = "";
                                var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
                                if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
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
                            fieldLabel : '<font color=red>*</font>描述',
                            labelSeparator:"",
                            name : 'SUBTDesc',
                            id:'SUBTDescF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTDescF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTDescF')),
                            allowBlank : false,
                            validationEvent : 'blur',
                            validator : function(thisText){
                                if(thisText==""){ //当文本框里的内容为空的时候不用此验证
                                    return true;
                                }
                                var className =  "web.DHCBL.CT.PACEpisodeSubType"; //后台类名称
                                var classMethod = "FormValidate"; //数据重复验证后台函数名
                                var id="";
                                if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
                                    var _record = grid.getSelectionModel().getSelected();
                                    var id = _record.get('SUBTRowId'); //此条数据的rowid
                                }
                                var flag = "";
                                var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
                                if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
                                    return false;
                                 }else{
                                    return true;
                                 }
                            },
                            invalidText : '该描述已经存在',
                            listeners : {
                                'change' : Ext.BDP.FunLib.Component.ReturnValidResult
                            }
                        }, {
                            fieldLabel : '<font color=red>*</font>就诊类型',
                            labelSeparator:"",
                            hiddenName : 'SUBTAdmType',
                            id:'SUBTAdmTypeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTAdmTypeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTAdmTypeF')),
                            xtype : 'combo',
                            allowBlank : false,
                            mode : 'local',
                            store : new Ext.data.SimpleStore({
                                fields : ['value', 'text'],
                                data : [
                                            ['O', '门诊'],
                                            ['I', '住院'],
                                            ['E', '急诊'],
                                            ['H', '体检']
                                        ]
                            }),
                            triggerAction : 'all',
                            forceSelection : true,
                            selectOnFocus : false,
                            minChars : 1,
                            valueField : 'value',
                            displayField : 'text'
                        }, {
                            xtype:'checkbox',
                            labelSeparator:"",
                            fieldLabel:'SUBTDaySurgery',
                            name:'SUBTDaySurgery',
                            id:'SUBTDaySurgeryF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTDaySurgeryF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTDaySurgeryF')),
                            hideLabels:true,
                            autoHeight:'true',
                            inputValue : true?'Y':'N'
                        },{
                            fieldLabel : 'SUBTFirstRegDayNight',
                            labelSeparator:"",
                            name : 'SUBTFirstRegDayNight',
                            id:'SUBTFirstRegDayNightF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTFirstRegDayNightF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTFirstRegDayNightF')) 
                        },{
                            xtype : 'datefield',
                            labelSeparator:"",
                            fieldLabel : '<font color=red>*</font>开始日期',
                            name : 'SUBTDateFrom',
                            id:'SUBTDateFromF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTDateFromF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTDateFromF')),
                            format : BDPDateFormat,
                            allowBlank : false,
                            enableKeyEvents : true,
                            listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                        }, {
                            xtype : 'datefield',
                            labelSeparator:"",
                            fieldLabel : '结束日期',
                            name : 'SUBTDateTo',
                            id:'SUBTDateToF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('SUBTDateToF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SUBTDateToF')),
                            format : BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                        }]
            });
    
    var tabs = new Ext.TabPanel({
                 activeTab : 0,
                 frame : true,
                 border : false,
                 height : 250,
                 items : [WinForm, AliasGrid]
             });
    Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
    /** 增加修改时弹出窗口 */
    var win = new Ext.Window({
        width : 450,
        height:400,
        layout : 'fit',
        frame : true,
        constrain : true,
        buttonAlign : 'center',
        closeAction : 'hide',
        items : tabs,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
            handler : function() {
                var tempCode = Ext.getCmp("form-save").getForm().findField("SUBTCode").getValue();
                var tempDesc = Ext.getCmp("form-save").getForm().findField("SUBTDesc").getValue();
                var tempType = Ext.getCmp("form-save").getForm().findField("SUBTAdmType").getValue();
                var tempCheck= Ext.getCmp('SUBTDaySurgeryF').getValue();
                var startDate = Ext.getCmp("form-save").getForm().findField("SUBTDateFrom").getValue();
                var endDate = Ext.getCmp("form-save").getForm().findField("SUBTDateTo").getValue();
                if (tempCode=="") {
                    Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                    return;
                }
                if (tempDesc=="") {
                    Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                    return;
                }
                if (tempType=="") {
                    Ext.Msg.show({ title : '提示', msg : '就诊类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                    return;
                }
                if (startDate=="") {
                    Ext.Msg.show({ title : '提示', msg : '开始日期不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                    return;
                }
                if (startDate != "" && endDate != "") {
                    if (startDate > endDate) {
                        Ext.Msg.show({
                                        title : '提示',
                                        msg : '开始日期不能大于结束日期!',
                                        minWidth : 200,
                                        icon : Ext.Msg.ERROR,
                                        buttons : Ext.Msg.OK
                                    });
                        return;
                    }
                }
                if(WinForm.form.isValid()==false){return;}
                if (win.title == "添加") {
                    WinForm.form.submit({
                        clientValidation : true, // 进行客户端验证
                        waitMsg : '正在提交数据请稍后...',
                        waitTitle : '提示',
                        url : SAVE_ACTION_URL,
                        method : 'POST',
                        success : function(form, action) {
                            if (action.result.success == 'true') {
                                win.hide();
                                var myrowid = action.result.id;
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
                                
                                //保存别名
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
                    })
                } else {
                    Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
                        if (btn == 'yes') {
                            WinForm.form.submit({
                                clientValidation : true, // 进行客户端验证
                                url : SAVE_ACTION_URL,
                                method : 'POST',
                                success : function(form, action) {
                                    //保存别名
                                    AliasGrid.saveAlias();
                                    
                                    if (action.result.success == 'true') {
                                        win.hide();
                                        var myrowid = "rowid=" + action.result.id;
                                        Ext.Msg.show({
                                                        title : '提示',
                                                        msg : '修改成功!',
                                                        icon : Ext.Msg.INFO,
                                                        buttons : Ext.Msg.OK,
                                                        fn : function(btn) {
                                                            Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
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
            }
        }],
        listeners : {
            "show" : function() {
                Ext.getCmp("form-save").getForm().findField("SUBTCode").focus(true,800);
            },
            "hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
            "close" : function() {}
        }
    });
    /** 添加按钮 */
    var btnAddwin = new Ext.Toolbar.Button({
                text : '添加',
                tooltip : '添加一条数据(Shift+A)',
                iconCls : 'icon-add',
                id:'add_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
                handler : AddData=function() {
                    win.setTitle('添加');
                    win.setIconClass('icon-add');
                    win.show('new1');
                    WinForm.getForm().reset();
                    //激活基本信息面板
                    tabs.setActiveTab(0);
                    //清空别名面板grid
                    AliasGrid.DataRefer = "";
                    AliasGrid.clearGrid();
                },
                scope : this
            });
    /** 修改按钮 */
    var btnEditwin = new Ext.Toolbar.Button({
                text : '修改',
                tooltip : '请选择一行后修改(Shift+U)',
                iconCls : 'icon-update',
                id:'update_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
                handler : UpdateData=function() {
                    var _record = grid.getSelectionModel().getSelected();
                    if (!_record) {
                        Ext.Msg.show({
                            title : '提示',
                            msg : '请选择需要修改的行!',
                            icon : Ext.Msg.WARNING,
                            buttons : Ext.Msg.OK
                        });
                    } else {
                        win.setTitle('修改');
                        win.setIconClass('icon-update');
                        win.show('');
                        Ext.getCmp("form-save").getForm().reset();
                        Ext.getCmp("form-save").getForm().load({
                            url : OPEN_ACTION_URL + '&id=' + _record.get('SUBTRowId'),
                            success : function(form,action) {
                            },
                            failure : function(form,action) {
                                Ext.Msg.alert('编辑', '载入失败');
                            }
                        });
                        //激活基本信息面板
                        tabs.setActiveTab(0);
                        //加载别名面板
                        AliasGrid.DataRefer = _record.get('SUBTRowId');
                        AliasGrid.loadGrid();
                    }

                }
            });
    /** grid数据存储 */
    var fields= [{
                    name : 'SUBTRowId',
                    mapping : 'SUBTRowId',
                    type : 'int'
                }, {
                    name : 'SUBTCode',
                    mapping : 'SUBTCode',
                    type : 'string'
                }, {
                    name : 'SUBTDesc',
                    mapping : 'SUBTDesc',
                    type : 'string'
                }, {
                    name : 'SUBTAdmType',
                    mapping : 'SUBTAdmType',
                    type : 'string'
                }, {
                    name : 'SUBTDaySurgery',
                    mapping : 'SUBTDaySurgery',
                    type : 'string'
                },{
                    name : 'SUBTFirstRegDayNight',
                    mapping : 'SUBTFirstRegDayNight',
                    type : 'string'
                },{
                    name : 'SUBTDateFrom',
                    mapping : 'SUBTDateFrom',
                    type : 'date' ,
                    dateFormat : 'm/d/Y'
                }, {
                    name : 'SUBTDateTo',
                    mapping : 'SUBTDateTo',
                    type : 'date' ,
                    dateFormat : 'm/d/Y'
                }]  
                        
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        },fields)
            });
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
    /** grid数据加载遮罩 */
    var loadMarsk = new Ext.LoadMask(document.body,{
                        disabled : false,
                        store : ds
                    });
    /** grid加载数据 */
    ds.load({
                params : {
                    start : 0,
                    limit : pagesize_main
                } 
            });
    /** grid分页工具条 */
    var paging = new Ext.PagingToolbar({
                pageSize : pagesize_main,
                store : ds,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                emptyMsg : "没有记录",
                plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                    "change":function (t,p) {
                        pagesize_main=this.pageSize;
                    }
                }
            });
    /** 增删改工具条 */
    var tbbutton = new Ext.Toolbar({
            enableOverflow : true,
            items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
        });
    /** 搜索按钮 */
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                iconCls : 'icon-search',
                text : '搜索',
                handler : function() {
                grid.getStore().baseParams={            
                        code : Ext.getCmp("TextCode").getValue(),
                        desc : Ext.getCmp("TextDesc").getValue(),
                        AdmType : Ext.getCmp("TextType").getValue()
                };
                grid.getStore().load({
                    params : {
                                start : 0,
                                limit : pagesize_main
                            }
                        });
                }
            });
    /** 重置按钮 */
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                iconCls : 'icon-refresh',
                text : '重置',
                handler : function() {
                    Ext.BDP.FunLib.SelectRowId="";
                    Ext.getCmp("TextCode").reset();
                    Ext.getCmp("TextDesc").reset();
                    Ext.getCmp("TextType").reset();
                    grid.getStore().baseParams={};
                    grid.getStore().load({
                        params : {
                                    start : 0,
                                    limit : pagesize_main
                                }
                            });
                }
            });
    /** 搜索工具条 */
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['代码', {
                            xtype : 'textfield',
                            id : 'TextCode',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
                        }, '-', '描述/别名', {
                            xtype : 'textfield',
                            id : 'TextDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
                        }, '-', '就诊类型', {
                            id : 'TextType',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextType'),
                            xtype : 'combo',
                            width : 140,
                            mode : 'local',
                            store : new Ext.data.SimpleStore({
                                fields : ['value', 'text'],
                                data : [
                                            ['O', '门诊'],
                                            ['I', '住院'],
                                            ['E', '急诊'],
                                            ['H', '体检']
                                        ]
                            }),
                            triggerAction : 'all',
                            forceSelection : true,
                            selectOnFocus : false,
                            minChars : 1,
                            listWidth : 140,
                            valueField : 'value',
                            displayField : 'text'
                        },'-',LookUpConfigureBtn, '-', btnSearch, '-', btnRefresh, '->'
                ],
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar) 
                    }
                }
            });
    /** 创建grid */
    var GridCM=[new Ext.grid.CheckboxSelectionModel(), // 单选列
                {
                    header : 'SUBTRowId',
                    sortable : true,
                    dataIndex : 'SUBTRowId',
                    hidden : true
                }, {
                    header : '代码',
                    sortable : true,
                    dataIndex : 'SUBTCode'
                }, {
                    header : '描述',
                    sortable : true,
                    dataIndex : 'SUBTDesc'
                }, {
                    header : '就诊类型',
                    sortable : true,
                    dataIndex : 'SUBTAdmType',
                    renderer : function(v){
                        if(v=='O'){ return '门诊'; }
                        if(v=='I'){ return '住院'; }
                        if(v=='E'){ return '急诊'; }
                        if(v=='H'){ return '体检'; }
                    }
                },{
                    header : 'SUBTDaySurgery',
                    sortable : true,
                    dataIndex : 'SUBTDaySurgery',
                    renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
                },{
                    header : 'SUBTFirstRegDayNight',
                    sortable : true,
                    dataIndex : 'SUBTFirstRegDayNight' 
                },{
                    header : '开始日期',
                    sortable : true,
                    renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                    dataIndex : 'SUBTDateFrom'
                }, {
                    header : '结束日期',
                    sortable : true,
                    renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                    dataIndex : 'SUBTDateTo'
                }];
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center',
                closable : true,
                store : ds,
                trackMouseOver : true,
                columns : GridCM,
                stripeRows : true,
                title : '就诊子类型',
                //stateful : true,
                viewConfig : {
                    forceFit : true
                },
                columnLines : true, //在列分隔处显示分隔符
                sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
                bbar : paging,
                tbar : tb,
                tools:Ext.BDP.FunLib.Component.HelpMsg,
                stateId : 'grid'
            });
    Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
        /// 单击事件：翻译要用到
    btnTrans.on("click",function(){
    if (grid.selModel.hasSelection())
    {
      var _record=grid.getSelectionModel().getSelected();
      var selectrow=_record.get('SUBTRowId');
     }
    else
    {
      var selectrow=""
     }
    Ext.BDP.FunLib.SelectRowId=selectrow
  });
    /** grid双击事件 */
    grid.on("rowdblclick", function(grid, rowIndex, e) {
                var _record = grid.getSelectionModel().getSelected();
                if (!_record) {
                    Ext.Msg.show({
                            title : '提示',
                            msg : '请选择需要修改的行!',
                            icon : Ext.Msg.WARNING,
                            buttons : Ext.Msg.OK
                        });
                } else {
                    win.setTitle('修改');
                    win.setIconClass('icon-update');
                    win.show('');
                    Ext.getCmp("form-save").getForm().reset();
                    Ext.getCmp("form-save").getForm().load({
                        url : OPEN_ACTION_URL + '&id=' + _record.get('SUBTRowId'),
                        success : function(form,action) {
                            Ext.getCmp('SUBTDaySurgeryF').setValue(_record.get('SUBTDaySurgery')=='Y'?true:false);
                        },
                        failure : function(form,action) {
                            Ext.Msg.alert('编辑', '载入失败');
                        }
                    });
                    
                    //激活基本信息面板
                    tabs.setActiveTab(0);
                    //加载别名面板
                    AliasGrid.DataRefer = _record.get('SUBTRowId');
                    AliasGrid.loadGrid();
                }
            });
     Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
     Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
     /** 布局 */
    var viewport = new Ext.Viewport({
        layout : 'border',
        items : [grid]
    });
});
