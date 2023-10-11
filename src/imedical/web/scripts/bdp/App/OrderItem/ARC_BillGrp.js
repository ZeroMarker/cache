/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于账单组（子组）维护。
 * @Created on 2012-8-4
 * @Updated on 2013-5-11
 * @LastUpdated on 2013-6-24 by sunfengchao
 */
    /// 调用 别名维护 的后台类方法
    document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
    Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassQuery=GetList";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCBillGrp";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassMethod=DeleteData";
    var ACTION_URL2 = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassQuery=GetList";
    
    var SAVE_ACTION_URL_New2 = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCBillSub";
    var DELETE_ACTION_URL2 = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassMethod=DeleteData";  
    var CHILD_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCBillSub";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassMethod=OpenData";  
 
     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "ARC_BillGrp"
    });
     Ext.BDP.FunLib.TableName="ARC_BillGrp";
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
    /*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.ARCBillGrp";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
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
       RowID=rows[0].get('ARCBGRowId');
       Desc=rows[0].get('ARCBGDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
    //////////////////////////////账单子表日志查看 ///////////////////////////////////////////////////////////
   var btnlogsub=Ext.BDP.FunLib.GetLogBtn("User.ARCBillSub");
   var btnhislogsub=Ext.BDP.FunLib.GetHisLogBtn("User.ARCBillSub");  
   ///日志查看按钮是否显示
   var btnlogsubflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogsubflag==1)
   {
      btnlogsub.hidden=false;
    }
    else
    {
       btnlogsub.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogsubflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogsubflag==1)
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
       RowID2=rows[0].get('ARCSGRowId');
       ParentDesc=tkMakeServerCall("web.DHCBL.CT.ARCBillSub","GetParentDesc",rows[0].get('ParRef'));  
       Desc2=ParentDesc+"->"+rows[0].get('ARCSGDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID2,Desc2);        
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
         grid.getStore().baseParams = {
            code : Ext.getCmp("TextCode").getValue(),
            desc : Ext.getCmp("TextDesc").getValue(),
            hospid:hospComp.getValue()
        };
        grid.getStore().load({
                    params : {
                        start : 0,
                        limit : pagesize_main
                    }
                });
        
    });
    //多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
                var rowid=grid.getSelectionModel().getSelections()[0].get("ARCBGRowId");
                GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
            }
            else
            {
                alert('请选择需要授权的记录!')
            }        
    });

    /**************************************账单组删除按钮**********************************************/
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
                                 return
                             } 
                 else{
                    Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
                    if (btn == 'yes') {
                         //删除所有别名
                        AliasGrid.DataRefer=records[0].get('ARCBGRowId');
                        AliasGrid.delallAlias();
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id':rows[0].get('ARCBGRowId') 
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
                                                      Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
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
    
    /************************************* 账单子组删除按钮****************************************/
    var btnDel2 = new Ext.Toolbar.Button({
            text : '删除',
            tooltip : '删除',
            iconCls : 'icon-delete',
            id:'child_del_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('child_del_btn'),
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
                                'id' : rows[0].get('ARCSGRowId')
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
                                                  if(totalnum==1){   //修改添加后只有一条，返回第一页
                                                         var startIndex=0
                                                    }
                                                   
                                                   else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
                                                   {
                                                     var pagenum=grid2.getStore().getCount();
                                                    
                                                     if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
                                                   }
                                                 grid2.getStore().load({
                                                 params : {
                                                            start : startIndex,
                                                            limit : pagesize_pop
                                                           }
                                                       });  
                                                    //  Ext.BDP.FunLib.DelForTruePage(gridResource,Ext.BDP.FunLib.PageSize.Pop);
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
    
    /********************************账单组增加、修改的Form**********************************************/
    var WinForm = new Ext.form.FormPanel({
                id : 'form-save',
                labelAlign : 'right',
                width : 200,
                split : true,
                frame : true,
                defaults : {
                    anchor:'85%',
                    border : false
                },
                title:'基本信息',
                defaultType : 'textfield',
                reader:new Ext.data.JsonReader({root:'list'},
                         [ 
                               {
                                    name : 'ARCBGRowId',
                                    mapping : 'ARCBGRowId' 
                                }, {
                                    name : 'ARCBGCode',
                                    mapping :'ARCBGCode' 
                                }, {
                                    name : 'ARCBGDesc',
                                    mapping :'ARCBGDesc' 
                                },{
                                    name:'ARCBGAbbrev',
                                    mapping:'ARCBGAbbrev' 
                                } 
                         ]),
                items : [{
                            fieldLabel : 'ARCBGRowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'ARCBGRowId'
                        }, {
                            name : 'ARCBGCode',
                            allowBlank : false,
                            labelSeparator:"",
                            blankText : '此项必填',
                            fieldLabel : '<font color=red>*</font>代码',
                            allowBlank:false,
                            regexText:"代码不能为空",
                            id:'ARCBGCodeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCBGCodeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCBGCodeF')),
                            enableKeyEvents : true,
                            validationEvent : 'blur',  
                            validator : function(thisText){
                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                            return true;
                           }
                            var className =  "web.DHCBL.CT.ARCBillGrp";   
                            var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                            var id="";
                            if(win.title=='修改'){  
                            var _record = grid.getSelectionModel().getSelected();
                            var id = _record.get('ARCBGRowId');  
                          }
                            var flag = "";
                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
                            
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
                            name : 'ARCBGDesc',
                            allowBlank : false,
                            labelSeparator:"",
                            fieldLabel : '<font color=red>*</font>描述',
                            id:'ARCBGDescF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCBGDescF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCBGDescF')),
                            enableKeyEvents : true,
                            validationEvent : 'blur',
                            validator : function(thisText){
                            if(thisText==""){  
                               return true;
                             }
                             var className =  "web.DHCBL.CT.ARCBillGrp"; //后台类名称
                             var classMethod = "FormValidate"; //数据重复验证后台函数名
                             var id="";
                             if(win.title=='修改'){ 
                             var _record = grid.getSelectionModel().getSelected();
                             var id = _record.get('ARCBGRowId');  
                          }
                             var flag = "";
                             var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
                        },{
                            fieldLabel : '缩写',
                            labelSeparator:"",
                            name : 'ARCBGAbbrev',
                            id:'ARCBGAbbrevF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCBGAbbrevF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCBGAbbrevF')),
                            stripCharsRe :  ' '
                        }]
            });
            
    /************************************账单子组增加、修改的Form****************************************/
    var WinForm2 = new Ext.form.FormPanel({
                id : 'form-save2',
                labelAlign : 'right',
                width : 200,
                split : true,
                frame : true,
                defaults : {
                  anchor: '85%',
                  border : false  
               },
                defaultType : 'textfield',
                items : [{
                            fieldLabel : '账单组ID',
                            hideLabel : 'True',
                            hidden : true,
                            readOnly : true,
                            name : 'ParentRowId'
                        },{
                            fieldLabel : 'ARCSGRowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'ARCSGRowId'
                        }, {
                            fieldLabel : '<font color=red>*</font>代码',
                            name : 'ARCSGCode',
                            stripCharsRe : ' ',
                            labelSeparator:"",
                            allowBlank : false,
                            id:'ARCSGCodeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCSGCodeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCSGCodeF')),
                            allowBlank:false      ,
                            enableKeyEvents : true,
                            validationEvent : 'blur',  
                            validator : function(thisText){
                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                            return true;
                           }
                            var className =  "web.DHCBL.CT.ARCBillSub";   
                            var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                            var id="";
                            var ParRef=""
                            if(win2.title=='添加'){
                            var gsm = grid.getSelectionModel();// 获取选择列
                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                            ParRef=rows[0].get('ARCBGRowId') 
                           }
                            if(win2.title=='修改'){  
                            var _record = grid2.getSelectionModel().getSelected();
                            var id = _record.get('ARCSGRowId'); 
                            
                             }
                            var flag = "";
                            var flag = tkMakeServerCall(className,classMethod,id,ParRef,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
                            fieldLabel : '<font color=red>*</font>描述',
                            name : 'ARCSGDesc',
                            labelSeparator:"",
                            id:'ARCSGDescF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCSGDescF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCSGDescF')),
                            allowBlank : false        ,
                            enableKeyEvents : true,
                            validationEvent : 'blur'  ,
                            validator : function(thisText){
                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                            return true;
                           }
                            var className =  "web.DHCBL.CT.ARCBillSub";   
                            var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                            var id="";
                            var ParRef=""
                            if(win2.title=='添加'){
                            var gsm = grid.getSelectionModel();// 获取选择列
                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                            ParRef=rows[0].get('ARCBGRowId') 
                           }
                            if(win2.title=='修改'){  
                            var _record = grid2.getSelectionModel().getSelected();
                            var id = _record.get('ARCSGRowId'); 
                             }
                            var flag = "";
                            var flag = tkMakeServerCall(className,classMethod,id,ParRef,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
                        }, {
                            fieldLabel : '缩写',
                            labelSeparator:"",
                            name : 'ARCSGAbbrev',
                            id:'ARCSGAbbrevF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCSGAbbrevF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCSGAbbrevF')),
                            stripCharsRe :  ' '
                        }]
            });
            
    /*********************************重置form的数据清空**************************************/
        var ClearForm = function()
      {
     
           //Ext.BDP.FunLib.SelectRowId="";
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
 
   /**************************帐单组增加、修改窗口***********************************************/
   var win = new Ext.Window({
        width : 390,
        height : 280,
        layout : 'fit',
        plain : true,// true则主体背景透明
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
            var tempCode = Ext.getCmp("form-save").getForm().findField("ARCBGCode").getValue();
            var tempDesc = Ext.getCmp("form-save").getForm().findField("ARCBGDesc").getValue();
            if (tempCode=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '代码不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("form-save").getForm().findField("ARCBGCode").focus(true,true);
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
                                buttons : Ext.Msg.OK,
                                fn:function()
                                {
                                    Ext.getCmp("form-save").getForm().findField("ARCBGDesc").focus(true,true);
                                }
                             });
                             return
                    }
                 if(WinForm.getForm().isValid()==false){
                   Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
                   return;
                } 
                if (win.title == '添加') {
                    WinForm.form.submit({
                        clientValidation : true, // 进行客户端验证
                        url : SAVE_ACTION_URL,
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
                                                msg : '添加成功！',
                                                icon : Ext.Msg.INFO,
                                                buttons : Ext.Msg.OK,
                                                fn : function(btn) {
                                                    var startIndex = grid.getBottomToolbar().cursor;
                                                    grid.getStore().load({
                                                                params : {
                                                                    start : 0,
                                                                    limit : pagesize_main,
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
                                            msg : '添加失败！' + errorMsg,
                                            minWidth : 200,
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                            }

                        },
                        failure : function(form, action) {
                            Ext.Msg.alert('提示', '添加数据失败！');
                        }
                    })
                } else {
                    Ext.MessageBox.confirm('提示', '确定要修改该条数据吗？', function(btn) {
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
                win.hide();
                Ext.getCmp("form-save").getForm().reset();
            }
        }],
        listeners : {
            'show' : function() {
                    Ext.getCmp("form-save").getForm().findField("ARCBGCode").focus(true,300);
            },
            "hide" :function()
               { 
                   Ext.BDP.FunLib.Component.FromHideClearFlag();
                   closepages();
               },
            'close' : function() {
            }
        }
    });
    
    // 帐单子组增加、修改窗口
    var win2 = new Ext.Window({
        width : 330,
        height : 240,
        layout : 'fit',
        plain : true,// true则主体背景透明
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
            var tempCode2 = Ext.getCmp("form-save2").getForm().findField("ARCSGCode").getValue();
            var tempDesc2 = Ext.getCmp("form-save2").getForm().findField("ARCSGDesc").getValue();
            
            if (tempCode2=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '代码不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("form-save2").getForm().findField("ARCSGCode").focus(true,true);
                                }
                            });
                            return
                }
            if (tempDesc2=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '描述不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                fn:function()
                                {
                                    Ext.getCmp("form-save2").getForm().findField("ARCSGDesc").focus(true,true);
                                },
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK 
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
                        params : {                                   
                            'LinkHospId' :hospComp.getValue()         
                        },
                        success : function(form, action) {
                            if (action.result.success == 'true') {
                                win2.hide();
                                var myrowid = action.result.id;
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加数据成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                var startIndex = grid2.getBottomToolbar().cursor;
                                                grid2.getStore().load({
                                                            params : {
                                                                start : 0,
                                                                limit : pagesize_main,
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
                                            msg : '添加数据失败！' + errorMsg,
                                            minWidth : 200,
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                            }

                        },
                        failure : function(form, action) {
                            Ext.Msg.alert('提示', '添加数据失败！');
                        }
                    })
                } else {
                    Ext.MessageBox.confirm('提示', '确定要修改该条数据吗？', function(btn) {
                        if (btn == 'yes') {
                            WinForm2.form.submit({
                                clientValidation : true, // 进行客户端验证
                                url : SAVE_ACTION_URL_New2,
                                method : 'POST',
                                success : function(form, action) {
                                    if (action.result.success == 'true') {
                                        win2.hide();
                                        var myrowid = 'rowid='+action.result.id;
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '修改数据成功！',
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
                Ext.getCmp("form-save2").getForm().findField("ARCSGCode").focus(true,300);
            },
            "hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
            'close' : function() {
            }
        }
    });
    
    // 账单组增加按钮
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
            
    // 账单组修改按钮
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
    // 账单子组数据存储
    var child_ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : ACTION_URL2 }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                                    name : 'ARCSGRowId',
                                    mapping : 'ARCSGRowId',
                                    type : 'string'
                                }, {
                                    name : 'ParRef',
                                    mapping : 'ParRef2',
                                    type : 'string'
                                
                                },{
                                    name : 'ARCSGCode',
                                    mapping : 'ARCSGCode',
                                    type : 'string'
                                }, {
                                    name : 'ARCSGDesc',
                                    mapping : 'ARCSGDesc',
                                    type : 'string'
                                }, {
                                    name : 'ARCSGAbbrev',
                                    mapping : 'ARCSGAbbrev',
                                    type : 'string'
                                } 
                        ])
            });
    child_ds.load({ 
                    params : { 
                                start : 0, 
                                limit : pagesize_main 
                             },
                                callback : function(records, options, success) {
                             }
                  }); // 加载数据
            
    // 账单子组表格

	/**帮助信息tool**/
	/**使用方法 在主Grid下添加tools:Ext.BDP.FunLib.Component.HelpMsg **/
	//蔡昊哲  2012-12-4
	/*var btnhelp  = new Ext.Button({
	        id:"help3",
	        icon:'icon-help',
	        handler:Ext.Msg.alert('帮助','<img src="'+Ext.BDP.FunLib.Path.URL_Img+'HelpMsg.jpg" width="300px" height="250px"/>')
	}); */             
    //var btnhelp =  Ext.BDP.FunLib.Component.HelpMsg;
    var grid2 = new Ext.grid.GridPanel({
                id : 'grid2',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                tools: Ext.BDP.FunLib.Component.HelpMsg,
                store : child_ds,
                trackMouseOver : true,
                columnLines : true, //在列分隔处显示分隔符
                // tools:Ext.BDP.FunLib.Component.HelpMsg,
                columns : [new Ext.grid.CheckboxSelectionModel({
                            width : 20
                        }),{
                            header : 'ARCSGRowId',
                            width : 160,
                            sortable : true,
                            dataIndex : 'ARCSGRowId',
                            hidden : true
                        }, {
                            header : 'ParRef',
                            width : 160,
                            sortable : true,
                            dataIndex : 'ParRef',
                            hidden : true
                        },{
                            header : '代码',
                            width : 160,
                            sortable : true,
                            dataIndex : 'ARCSGCode'
                        }, {
                            header : '描述',
                            width : 160,
                            sortable : true,
                            dataIndex : 'ARCSGDesc'
                        }, {
                            header : '缩写',
                            width : 160,
                            sortable : true,
                            dataIndex : 'ARCSGAbbrev'
                        }],
                stripeRows : true,
             
                // config options for stateful behavior
                stateful : true,
                viewConfig : {
                    forceFit : true,
                    emptyText:""
                },
                sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
                bbar : new Ext.PagingToolbar({
                        pageSize : pagesize_pop,
                        store : child_ds,
                        displayInfo : true,
                        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                        listeners : {
                                       "change":function (t,p)
                                      { 
                                          pagesize_pop=this.pageSize;
                                      }
                                   },
                        displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
                        emptyMsg : '没有记录'
                    }),
                   tbar : new Ext.Toolbar({
                          items : [ '代码', { xtype : 'textfield', id : 'TextCode2' ,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2')},
                                    '描述', { xtype : 'textfield', id : 'TextDesc2' ,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2')},
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
                                                                        code : Ext.getCmp("TextCode2").getValue(),
                                                                        desc : Ext.getCmp("TextDesc2").getValue(),                                      
                                                                        ParRef: rows[0].get('ARCBGRowId'),
                                                                        hospid:hospComp.getValue()
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
                                                     
                                                            Ext.getCmp("TextCode2").reset();                        //-----------将输入框清空
                                                            Ext.getCmp("TextDesc2").reset();    
                                                            var gsm = grid.getSelectionModel();// 获取选择列
                                                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                            grid2.getStore().baseParams={ ParRef: rows[0].get('ARCBGRowId'),hospid:hospComp.getValue()};
                                                            grid2.getStore().load({ params : { start : 0, limit : pagesize_pop } });
                                                             
                                                        }
                                                    })
                                   
                                   
                                    ],
                            listeners : {
                                    render : function() {
                                    tbbutton2.render(grid2.tbar) // tbar.render(panel.bbar)这个效果在底部
                                    }
                            }
                        })
            });
            
    //grid2双击事件
    grid2.on('rowdblclick', function() {
                win2.setTitle('修改');
                win2.setIconClass('icon-update');
                win2.show('');
                var record = grid2.getSelectionModel().getSelected();// records[0]
                WinForm2.getForm().reset();
                Ext.getCmp('form-save2').getForm().loadRecord(record);
            });
    
    // 账单子组维护窗口     
    var win3 = new Ext.Window({
        title : '账单子组',
        width : 800,
        height : 500,
        layout : 'fit',
        plain : true,// true则主体背景透明
        modal : true,
        frame : true,
        autoScroll : false,
        collapsible : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        constrain : true,
        closeAction : 'hide',
        items : [grid2],
        listeners : {
                        "show" : function(){
                             Ext.getCmp("TextCode2").reset();      //-----------将输入框清空
                             Ext.getCmp("TextDesc2").reset();  
                            if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
                            {
                                keymap_main.disable();
                                keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData2,UpdateData2,DelData2);
                            }                           
                        },
                        "hide" : function(){
                            Ext.getCmp("TextCode2").reset();      //-----------将输入框清空
                            Ext.getCmp("TextDesc2").reset();  
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
    
    Ext.BDP.FunLib.Component.stopDefaultEsc(win3);
    // 进入账单子组维护按钮
    var btnD = new Ext.Toolbar.Button({
                text : '账单子组',
                tooltip : '账单子组',
                iconCls : 'icon-DP',
                id:'billbtn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('billbtn'),
                handler : function() {
                    if (grid.selModel.hasSelection()) {
                         
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        win3.setTitle(rows[0].get('ARCBGDesc')+"-账单子组")
                        grid2.getStore().baseParams={ ParRef: rows[0].get('ARCBGRowId'),hospid:hospComp.getValue()
                        };
                        grid2.getStore().load({ params : { start : 0, limit : pagesize_pop } });
                        win3.show();
                    } else {
                        Ext.Msg.show({
                                    title : '提示',
                                    msg : '请选择要查看账单子组的一行账单！',
                                    icon : Ext.Msg.WARNING,
                                    buttons : Ext.Msg.OK
                                });
                    }

                }
            });
            
    // 账单子组维护工具条
    var tbbutton2 = new Ext.Toolbar({
        enableOverflow : true,
        items : [new Ext.Button({text:'添加', tooltip : '添加', iconCls : 'icon-add',id:'subadd',
         disabled: Ext.BDP.FunLib.Component.DisableFlag('subadd') ,
                                                    handler : function AddData2() {
                                                        var gsm = grid.getSelectionModel();// 获取选择列
                                                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                        var ParentRowId = rows[0].get('ARCBGRowId')
                                                        win2.setTitle('添加');
                                                        win2.setIconClass('icon-add');
                                                        win2.show('new1');
                                                        WinForm2.getForm().reset();
                                                        WinForm2.getForm().findField('ParentRowId').setValue(ParentRowId);
                                                    },
                                                    scope : this
                                                }), '-',
                                    new Ext.Button({text : '修改',tooltip : '修改',iconCls : 'icon-update',id:'subupdate',
                                                    disabled: Ext.BDP.FunLib.Component.DisableFlag('subupdate') ,
                                                    handler : function UpdateData2() {
                                                        if (grid2.selModel.hasSelection()) {
                                                            win2.setTitle('修改');
                                                            win2.setIconClass('icon-update');
                                                            win2.show('');
                                                            var record = grid2.getSelectionModel().getSelected();// records[0]
                                                            WinForm2.getForm().reset();
                                                            Ext.getCmp('form-save2').getForm().loadRecord(record);
                                                        } else {
                                                            Ext.Msg.show({
                                                                    title : '提示',
                                                                    msg : '请选择需要修改的行！',
                                                                    icon : Ext.Msg.WARNING,
                                                                    buttons : Ext.Msg.OK
                                                            });
                                                        }
                                                    }
                                                }), '-', btnDel2 ,'->',btnlogsub,'-',btnhislogsub]  
        });
        
    // 账单组
    var fields= [{
                    name : 'ARCBGRowId',
                    mapping : 'ARCBGRowId',
                    type : 'int'
                }, {
                    name : 'ARCBGCode',
                    mapping : 'ARCBGCode',
                    type : 'string'
                }, {
                    name : 'ARCBGDesc',
                    mapping : 'ARCBGDesc',
                    type : 'string'
                }, {
                    name : 'ARCBGAbbrev',
                    mapping : 'ARCBGAbbrev',
                    type : 'string'
                }];
    var ds = new Ext.data.Store({
            proxy : new Ext.data.HttpProxy({ url : ACTION_URL }),// 调用的动作
            reader : new Ext.data.JsonReader({
                        totalProperty : 'total',
                        root : 'data',
                        successProperty : 'success'
                    },fields)
        });
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);      
    
    var paging = new Ext.PagingToolbar({
            pageSize: pagesize_main,
            store: ds,
            displayInfo: true,
            displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
            emptyMsg : "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
             listeners : {
              "change":function (t,p)
             { 
                 pagesize_main=this.pageSize;
             }
           }
        })
    var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect : true,
                checkOnly : false,
                width : 20
            });
            
    // 账单组增删改工具条
    var tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',HospWinButton   //多院区医院
        , '-', btnD,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
            // ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
        });

    // 账单组搜索工具条
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                iconCls : 'icon-search',
                text : '搜索',
                handler : function() {
                    grid.getStore().baseParams={            
                        code : Ext.getCmp('TextCode').getValue(),
                        desc : Ext.getCmp('TextDesc').getValue(),
                        hospid:hospComp.getValue()
                    };
                    grid.getStore().load({ params : { start : 0, limit : pagesize_main } });
                }
            });
            
    // 账单组刷新工作条
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                iconCls : 'icon-refresh',
                text : '重置',
                handler : function() {
                    Ext.BDP.FunLib.SelectRowId="";
                    Ext.getCmp('TextCode').reset();
                    Ext.getCmp('TextDesc').reset();
                    grid.getStore().baseParams={hospid:hospComp.getValue()};
                    grid.getStore().load({ params : { start : 0, limit : pagesize_main } });
                }
            });
            
    // 将工具条放到一起
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['代码', { xtype : 'textfield', id : 'TextCode' ,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},
                        '描述/别名', { xtype : 'textfield', id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc') },'-',LookUpConfigureBtn, btnSearch, '-', btnRefresh, '->'
                ],
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
                    }
                }
            });
            
    // 账单组create the Grid
    var GridCM=[sm, {
                    header : 'ARCBGRowId',
                    width : 160,
                    sortable : true,
                    dataIndex : 'ARCBGRowId',
                    hidden : true
                }, {
                    header : '代码',
                    width : 160,
                    sortable : true,
                    dataIndex : 'ARCBGCode'
                }, {
                    header : '描述',
                    width : 160,
                    sortable : true,
                    dataIndex : 'ARCBGDesc'
                }, {
                    header : '缩写',
                    width : 160,
                    sortable : true,
                    dataIndex : 'ARCBGAbbrev'
            }];
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : ds,
                trackMouseOver : true,
                columnLines : true, //在列分隔处显示分隔符
                tools:Ext.BDP.FunLib.Component.HelpMsg,
                columns : GridCM,
                stripeRows : true,
                title : '帐单组',
                // config options for stateful behavior
                stateful : true,
                viewConfig : { 
                forceFit : true ,
                emptyText:""
                },
                sm: new Ext.grid.RowSelectionModel({ singleSelect : true }),
                bbar : paging,
                tbar : tb,
                stateId : 'grid'
            });
        Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
   
      /**********************************右键菜单************************************/
     if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
     {
       grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
       var rightClick = new Ext.menu.Menu({
            id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
            disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
            items: [
            {
             id: 'rMenu1',
             iconCls :'icon-delete',
             handler: DelData,//点击后触发的事件
             disabled : true, //Ext.BDP.FunLib.Component.DisableFlag('rMenu1'),
             text: '删除数据'
            }, {
             id: 'rMenu2',
             iconCls :'icon-add',
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu2'),
             handler: AddData,
             text: '添加数据'
             },{
             id: 'rMenu3',
             iconCls :'icon-update',
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu3'),
             handler:UpdateData ,
             text: '修改数据'
            },{
             id:'rMenu4',
            iconCls :'icon-refresh',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu4'),
            handler:function(){
               Ext.getCmp("grid").store.reload();
             },
            text:'刷新'
         }
     ]
 }); 
 
  /****************************************右键菜单的关键代码，右键可以选中一行***************************************************/
  function rightClickFn(grid,rowindex,e){
      e.preventDefault();
      var currRecord = false; 
      var currRowindex = false; 
      var currGrid = false; 
         if (rowindex < 0) { 
         return; 
   } 
     grid.getSelectionModel().selectRow(rowindex); 
     currRowIndex = rowindex; 
     currRecord = grid.getStore().getAt(rowindex); 
     currGrid = grid; 
     rightClick.showAt(e.getXY()); 
  }
}
grid.on("rowclick",function(grid,rowIndex,e){
    if (grid.selModel.hasSelection())
    {
      var _record=grid.getSelectionModel().getSelected();
      var selectrow=_record.get('ARCBGRowId');
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
                    url : OPEN_ACTION_URL + '&id='+ _record.get('ARCBGRowId'),  //id 对应OPEN里的入参
                    success : function(form,action) {
                    },
                    failure : function(form,action) {
                    }
                });
                //激活基本信息面板
                tabs.setActiveTab(0);
                //加载别名面板
                AliasGrid.DataRefer = _record.get('ARCBGRowId');
                AliasGrid.loadGrid();
            }
        };
        grid.on("rowdblclick", function(grid, rowIndex, e) {
            var row = grid.getStore().getAt(rowIndex).data;
            win.setTitle('修改');      ///双击后
            win.setIconClass('icon-update');
            win.show('');
            loadFormData(grid);
        }); 
    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
    Ext.BDP.FunLib.ShowUserHabit(grid2,"User.ARCBillsub");
    
     /************************************ 调用keymap*********************************************/
    var keymap_main = Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    var viewport = new Ext.Viewport({
        layout : 'border',
        items : [GenHospPanel(hospComp),grid]
    });

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
                limit : pagesize_main
            },
            callback : function(records, options, success) {
            }
        });
    
    }
  });
 
