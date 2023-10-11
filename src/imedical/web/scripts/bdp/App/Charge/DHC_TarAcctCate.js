/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 会计费用子类 维护 
 * @Created on 2016-12-2
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    var limit = Ext.BDP.FunLib.PageSize.Main;
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassQuery=GetList";
    var SAVE_ACTION_URL_New ="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCTarAcctCate";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassMethod=DeleteData";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassMethod=OpenData";
   
    /*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.DHCTarAcctCate";
    var btnSort = Ext.BDP.FunLib.SortBtn;
 
    //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "DHC_TarAcctCate"
  });
     Ext.BDP.FunLib.TableName="DHC_TarAcctCate";
     /// 获取查询配置按钮 
     var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
     var btnTrans=Ext.BDP.FunLib.TranslationBtn;
     var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation","DHC_TarAcctCate");
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
           RowID=rows[0].get('TARACRowId');
           Desc=rows[0].get('TARACDesc');
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
		 Ext.getCmp("TextTarCate").setValue("");
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
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
				var rowid=grid.getSelectionModel().getSelections()[0].get("TARACRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
  
 /************************************删除功能************************************/
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
                        AliasGrid.DataRefer=records[0].get('TARACRowId') ;
                        AliasGrid.delallAlias();
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id':rows[0].get('TARACRowId') 
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
 
  /***********************JSON 解析**********************************************/
    var jsonReaderE=new Ext.data.JsonReader({root:'list'},
    [{
         name : 'TARACRowId',
         mapping : 'TARACRowId',
         type : 'int'
        }, {
         name : 'TARACCode', 
         mapping : 'TARACCode',
         type : 'string'
        }, {
         name : 'TARACDesc',
         mapping :'TARACDesc',
         type:'string'
        },{
         name:'TARACTARTACDR',
         name:'TARACTARTACDR',
         type:'string'
        }
     ]);
   /// RowID
    var RowIDText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : 'TARACRowId',
        hideLabel : 'True',
        hidden : true,
        name : 'TARACRowId'
    });
   /// Code 
   var CodeText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : '<font color=red>*</font>项目代码',
        name : 'TARACCode',
        id:'TARACCodeF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARACCodeF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARACCodeF')),
        allowBlank : false,
        enableKeyEvents : true,
        validationEvent : 'blur',  
        validator : function(thisText){
            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
               return true;
         }
         var className =  "web.DHCBL.CT.DHCTarAcctCate";   
         var classMethod = "FormValidate"; //数据重复验证后台函数名                             
         var id="";
         if(win.title=='修改'){  
           var _record = grid.getSelectionModel().getSelected();
           var id = _record.get('TARACRowId');  
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
   });
   /// desc
   var DescText= new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : '<font color=red>*</font>项目名称',
          name : 'TARACDesc',
          id:'TARTECDescF',
          readOnly : Ext.BDP.FunLib.Component.DisableFlag('TARTECDescF'),
          style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TARTECDescF')),
          allowBlank : false,
          enableKeyEvents : true,
          validationEvent : 'blur',
          validator : function(thisText){
         if(thisText==""){  
              return true;
         }
        var className =  "web.DHCBL.CT.DHCTarAcctCate"; //后台类名称
        var classMethod = "FormValidate"; //数据重复验证后台函数名
        var id="";
        if(win.title=='修改'){ 
           var _record = grid.getSelectionModel().getSelected();
           var id = _record.get('TARACRowId');  
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
   });
   //   会计费用大类 combo  
     var BindingLoc="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarAC&pClassQuery=GetDataForCmb1";
     var TAROCTARTOCDRCombo =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "<font color=red>*</font>会计费用大类",
        name: 'TARACTARTACDR',
        id:'TARACTARTACDRF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('TARACTARTACDRF'),
        hiddenName:'TARACTARTACDR',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        //triggerAction : 'all',
        selectOnFocus:false,
        mode:'remote',
        pageSize:Ext.BDP.FunLib.PageSize.Combo,
        listWidth:250,
        valueField:'TARTACRowId',
        displayField:'TARTACDesc',
        store:new Ext.data.JsonStore({
            url:BindingLoc,
            root: 'data',
            totalProperty: 'total',
            idProperty: 'TARTACRowId',
            fields:['TARTACRowId','TARTACDesc'],
            remoteSort: true,
            sortInfo: {field: 'TARTACRowId', direction: 'ASC'}
        }),
		 listeners:{
			   'beforequery': function(e){
					this.store.baseParams = {
						desc:e.query,
						hospid:hospComp.getValue()
					};
					this.store.load({params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
					}})
			
				}
		 }
    });   
/************************************增加修改的Form***********************************/
    var WinForm = new Ext.form.FormPanel({
                id : 'form-save',
                labelAlign : 'right',
                width : 300,
                split : true,
                frame : true,
                title:'基本信息',
                defaults : {
                    anchor: '85%',
                    border : false 
                },
                reader:jsonReaderE,
                items : [RowIDText,CodeText,DescText,TAROCTARTOCDRCombo]
            });
         
   /*********************************重置form的数据清空**************************************/
      var ClearForm = function()
      {
           Ext.getCmp("form-save").getForm().reset()      
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
/************************************增加修改时弹出窗口***********************************/
    var win = new Ext.Window({
        width : 410,
        height : 270,
        layout : 'fit',
        plain : true,
        modal : true,
        frame : true,
        autoScroll : false,
        collapsible : true,
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
            var tempCode = Ext.getCmp("TARACCodeF").getValue();
            var tempDesc = Ext.getCmp("TARTECDescF").getValue();
            var tempCate=Ext.getCmp('TARACTARTACDRF').getValue();
            if (tempCode=="") {
                Ext.Msg.show({
                                title : '提示',
                                msg : '项目代码不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("TARACCodeF").focus(true,true);
                                }
                            });
                return;
            }
            if (tempDesc=="") {
                Ext.Msg.show({ 
                                title : '提示', 
                                msg : '项目名称不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("TARTECDescF").focus(true,true);
                                }
                            });
                    return;
            }
            if (tempCate=="") {
                Ext.Msg.show({
                                title : '提示',
                                msg : '会计费用大类不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("TARACCodeF").focus(true,true);
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
						params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
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
                                   AliasGrid.DataRefer = myrowid;
                                   AliasGrid.saveAlias(); 
                            } else {
                                var errorMsg = '';
                                if (action.result.errorinfo) {
                                    errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                }
                                Ext.Msg.show({
                                                title : '<font color=blue>提示</font>',
                                                msg : '<font color=red>添加失败!</font>' ,
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
                Ext.getCmp("TARACCodeF").focus(true,300);
            },
            "hide" :  function(){
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
                id:'add_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
                iconCls : 'icon-add',
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
    var fields=[{
                    name : 'TARACRowId',
                    mapping : 'TARACRowId',
                    type : 'int'
                }, {
                    name : 'TARACCode',  
                    mapping : 'TARACCode',
                    type : 'string'
                }, {
                    name : 'TARACDesc',
                    mapping :'TARACDesc',
                    type:'string'
                },{
                    name:'TARACTARTACDR',
                    mapping:'TARACTARTACDR',
                    type:'string'
                }] 
                        
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : ACTION_URL
                        }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, fields)
        });
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
 
    /************************************数据分页***********************************/
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
        items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',HospWinButton  ///多院区医院
		,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]   
        })
/************************************搜索工具条************************************/
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                iconCls : 'icon-search',
                text : '搜索',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                handler : function () {
                grid.getStore().baseParams={            
                        code : Ext.getCmp("TextCode").getValue(),
                        desc : Ext.getCmp("TextDesc").getValue(),
                        taremcdr:Ext.getCmp("TextTarCate").getValue(),
						hospid:hospComp.getValue()    ///多院区医院
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
                    Ext.getCmp("TextTarCate").reset();
                    grid.getStore().baseParams={
						hospid:hospComp.getValue()    ///多院区医院
					};
                    grid.getStore().load({
                                params : {
                                            start : 0,
                                            limit : limit
                                        }
                                });
                            }
                        });
       ///   经济核算大类  coombox
    var TextResource = new Ext.BDP.Component.form.ComboBox({
        fieldLabel: '经济核算大类',                         
        id: 'TextTarCate',
        loadByIdParam : 'rowid',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('TextTarCateF'),
        hiddenName:'TAROCTARTOCDR', 
        //triggerAction:'all', 
        queryParam:"desc",
        forceSelection: true,
        selectOcnFocus:false,
        mode:'remote',
        pageSize:Ext.BDP.FunLib.PageSize.Combo,
        listWidth:250,
        valueField:'TARTACRowId',
        displayField:'TARTACDesc',
         store:new Ext.data.JsonStore({
            url:BindingLoc,
            root: 'data',
            totalProperty: 'total',
            autoLoad: true,
            idProperty: 'TARTACRowId',
            fields:['TARTACRowId','TARTACDesc'],
            remoteSort: true,
            sortInfo: {field: 'TARTACRowId', direction: 'ASC'}
        }),
        listeners:{
            'select': function(){
                grid.getStore().baseParams={            
                     taremcdr: Ext.getCmp("TextTarCate").getValue(),
					 hospid:hospComp.getValue()    ///多院区医院
            };
            grid.getStore().load({
                params : {
                            start : 0,
                            limit : limit
                        }
                    }); 
            },
			'beforequery': function(e){
					this.store.baseParams = {
						desc:e.query,
						hospid:hospComp.getValue()
					};
					this.store.load({params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
					}})
			
				}
        }
    });
/************************************ 将工具条放到一起***********************************/
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['项目代码', {
                            xtype : 'textfield',
                            id : 'TextCode',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
                    },'项目名称/别名', {
                            xtype : 'textfield',
                            id : 'TextDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
                    } ,'会计费用大类',TextResource,'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
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
                            header : 'TARACRowId',
                            width : 160,
                            sortable : true,
                            dataIndex : 'TARACRowId',
                            hidden : true
                        }, {
                            header : '项目代码',
                            width : 160,
                            sortable : true,
                            stripeRows: true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'TARACCode'
                        }, {
                            header : '项目名称',
                            width : 160,
                            sortable : true,
                            stripeRows: true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'TARACDesc'
                        },{
                            header : '会计费用大类',
                            width : 160,
                            sortable : true,
                            stripeRows: true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'TARACTARTACDR'
                        }];
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
                columns:GridCM,
                sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
                stripeRows : true,
                columnLines : true, //在列分隔处显示分隔符
                title : '会计费用子类 ',
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
        Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
             //单击事件（翻译按钮要用到）
        btnTrans.on("click",function(){
            if (grid.selModel.hasSelection()) {     
                var _record = grid.getSelectionModel().getSelected();
                var selectrow = _record.get('TARACRowId');              
             } else {
                var selectrow="";
             }
             Ext.BDP.FunLib.SelectRowId = selectrow
        }); 
/************************************双击事件************************************/
      var loadFormData = function(grid){
            var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
            if (!_record) {
                Ext.Msg.alert('修改操作', '请选择要修改的一项!');
            } else {
                    WinForm.form.load( {
                    url : OPEN_ACTION_URL + '&id='+ _record.get('TARACRowId') 
                });
             //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('TARACRowId');
               AliasGrid.loadGrid();
            }
        };
        grid.on("rowdblclick", function(grid, rowIndex, e) {
                var row = grid.getStore().getAt(rowIndex).data;
                win.setTitle('修改');      ///双击后
                win.setIconClass('icon-update');
                win.show();
                loadFormData(grid);
        }); 
        Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
        /************************************键盘事件************************************/
        Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
        var viewport = new Ext.Viewport({
            layout : 'border',
            items : [GenHospPanel(hospComp),grid]  //多院区医院
         });
		 
		 ///多院区医院
	var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		grid.disable();
	}
	else
	{
     ds.load({
                params : {
                    start : 0,
                    limit : limit
                } 
            });
	}
		 
    });
