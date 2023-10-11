/**@function: 医疗单元-医护人员维护
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 */
 
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
    var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassQuery=MedUnitPerson";
    var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCCTLocMedUnitCareProv";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=DeleteData";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassMethod=OpenData";
    var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCCTLocMedUnitCareProv&pClassQuery=CTPCPDR";
    var doctordr;
    Ext.BDP.FunLib.TableName="DHC_CTLocMedUnit_CareProv"
    
     //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn("User.DHCCTLocMedUnitCareProv");
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn("User.DHCCTLocMedUnitCareProv");
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
   if (wingrid.selModel.hasSelection()) {
       var rows = wingrid.getSelectionModel().getSelections(); 
       RowID=rows[0].get('MUCPRowId');
       Desc=rows[0].get('CTPCPDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
 /*************************** 截止功能*************************************************/
    var childbtnDel = new Ext.Toolbar.Button({
        text : $g('截止'),
        tooltip : $g('截止'),
        iconCls : 'icon-delete',
        id:'child_del_btn',
		hidden : true,
        disabled : Ext.BDP.FunLib.Component.DisableFlag('child_del_btn'),
        handler : DelData=function() {
            var records =  wingrid.selModel.getSelections();
                var recordsLen= records.length;
                if(recordsLen == 0){
                        Ext.Msg.show({
                                        title:$g('提示'),
                                        minWidth:280,
                                        msg:$g('请选择需要截止的行!'),
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    }); 
                     return
                 } 
                 else{
                    Ext.MessageBox.confirm('<font color=blue>'+$g('提示')+'</font>','<font color=red>'+$g('确定要截止所选的数据吗?')+'</font>', function(btn) {
                    if (btn == 'yes') {
                        var gsm = wingrid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'MUCPRowid':rows[0].get('MUCPRowId') 
                            },
                            callback : function(options, success, response) {
                                Ext.MessageBox.hide();
                                if (success) {
                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                    if (jsonData.success == 'true') {
                                        Ext.Msg.show({
                                            title : '<font color=blue>'+$g('提示')+'</font>',
                                            msg : '<font color=red>'+jsonData.info+'</font>',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            animEl: 'form-save',
                                            fn : function(btn) {
                                                    //  Ext.BDP.FunLib.DelForTruePage(grid,limit);
                                                 childds.load({
                                                    params : {
                                                        ParRef:Ext.getCmp('HideRef').getValue(),
                                                        start : 0,
                                                        limit : limit
                                                    } 
                                                });
                                              }
                                          });
                                    } else {
                                        var errorMsg = '';
                                        if (jsonData.info) {
                                            errorMsg = '<br />'+$g('错误信息')+':' + jsonData.info
                                        }
                                        Ext.Msg.show({
                                                        title : '<font color=blue>'+$g('提示')+'</font>',
                                                        msg : '<font color=red>'+$g('数据截止失败!')+'</font>' + errorMsg,
                                                        minWidth : 200,
                                                        icon : Ext.Msg.ERROR,
                                                        animEl: 'form-save',
                                                        buttons : Ext.Msg.OK,
                                                        fn : function(btn) {
                                                          childds.load({
                                                                params : {
                                                                    ParRef:Ext.getCmp('HideRef').getValue(),
                                                                    start : 0,
                                                                    limit : limit
                                                                } 
                                                            });
                                                        }
                                                    });
                                            }
                                } else {
                                    Ext.Msg.show({
                                                    title : '<font color=blue>'+$g('提示')+'</font>',
                                                    msg : '<font color=red>'+$g('异步通讯失败,请检查网络连接!')+'</font>',
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
    
    
    var ChildjsonReaderE=new Ext.data.JsonReader({root:'list'},
                        [{
                            name: 'MUCPRowId',
                            mapping:'MUCPRowId',
                            type:'string'
                        },{
                            name: 'MUCPParRef',
                            mapping:'MUCPParRef',
                            type:'string'
                        },{
                            name:'MUCPDoctorDR',
                            mapping:'MUCPDoctorDR',
                            type:'string'
                         },{
                            name:'CTPCPCode',
                            mapping:'CTPCPCode',
                            type:'string'
                        },{
                            name:'CTPCPDesc',
                            mapping:'CTPCPDesc',
                            type:'string'
                        },{
                            name:'MUCPLeaderFlag',
                            mapping:'MUCPLeaderFlag',
                            type:'string'
                        },{
                            name: 'MUCPOPFlag',
                            mapping:'MUCPOPFlag',
                            type:'string'
                        },{
                            name:'MUCPIPFlag',
                            mapping:'MUCPIPFlag',
                            type:'string'
                         }, {
                            name: 'MUCPDateFrom',
                            mapping:'MUCPDateFrom',
                            type:'string'
                         },{
                            name:'MUCPTimeTo',
                            mapping:'MUCPTimeTo',
                            type:'string' 
                         },{
                            name: 'MUCPDateTo',
                            mapping:'MUCPDateTo',
                            type:'string'
                         } ,{
                            name:'MUCPTimeFrom',
                            mapping:'MUCPTimeFrom',
                            type:'string'
                         }                
                ]);
                
    var ChildRowidText=new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : 'MUCPRowId',
		  id : 'MUCPRowIdF',
          hideLabel : 'True',
          hidden : true,
          name:'MUCPRowId'
    });
     

	 
    /// DateFrom
    var Child_DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>'+$g('开始日期'),
       name :'MUCPDateFrom',
       id:'MUCPDateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPDateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPDateFromF')),
       format : BDPDateFormat,
       allowBlank:false,
       regexText:$g("开始日期不能为空"),
       editable:true,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });
    /// DateTo 
    var Child_DateToText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : $g('结束日期'),
       name : 'MUCPDateTo',
       id:'MUCPDateToF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPDateToF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPDateToF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });
  
    
    /****************************增加修改的Form*********************************************/
    var winDrug;
    var gridDrug;
    var CareProvDs = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url :  CTLOC_QUERY_ACTION_URL
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{ 
                                    name : 'MUCPRowid',
                                    mapping : 'MUCPRowid',
                                    type : 'string'
                                }, {
                                    name : 'CTPCPDesc',  
                                    mapping : 'CTPCPDesc',
                                    type : 'string'
                                }, {
                                    name : 'TCTPCPCode',
                                    mapping :'TCTPCPCode',
                                    type:'string'
                                },{
                                    name:'CTMUDesc',
                                    mapping:'CTMUDesc',
                                    type:'string'
                                },{
                                    name:'RESCTPCPDR',
                                    mapping:'RESCTPCPDR',
                                    type:'string'
                                } ,{
                                    name:'CTLOCDesc',
                                    mapping:'CTLOCDesc',
                                    type:'string'
                                }
                        ])
        });
    var CareProvSm= new Ext.grid.RowSelectionModel({singleSelect:true})
    var CareProvCm=new Ext.grid.ColumnModel([new Ext.grid.CheckboxSelectionModel(),  {
                            header : $g('姓名'),
                            width : 60,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'CTPCPDesc'
                        }, {
                            header : $g('工号'),
                            width : 85,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'TCTPCPCode'
                        },{
                            header : $g('所属医疗单元'),
                            width : 85,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'CTMUDesc'
                        },{
                            header : $g('所属科室'),
                            width : 85,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'CTLOCDesc'
                        }, {
                            header : 'RESCTPCPDR',
                            width : 65,
                            sortable : true,
                            hidden:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex :'RESCTPCPDR'
                        } ,{
                            header :'MUCPRowid',
                            width : 60,
                            sortable : true,
                            hidden:true,
                            dataIndex : 'MUCPRowid'
                      }]);
    var CarePrvpaging= new Ext.PagingToolbar({
            pageSize:limit,
            store: CareProvDs,
            displayInfo: true,
            displayMsg : $g('显示第 {0} 条到 {1} 条记录,一共 {2} 条'),
            emptyMsg : $g("没有记录"),
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                            "change":function (t,p)
                           { 
                               limit=this.pageSize;
                           }
                       }
        }); 
   
    ////////////////////////////////////药物搜索按钮 //////////////////////////////////////////
    var btnCareSearch = new Ext.Button({
                id : 'btnCareSearch',
                iconCls : 'icon-search',
                text : $g('搜索'),
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCareSearch'),
                handler : function() {
                    gridDrug.getStore().baseParams={     
                            MURowid:Ext.getCmp('HideRef').getValue() ,
                            code : Ext.getCmp("TextCode").getValue(),
                            desc : Ext.getCmp("TextDesc").getValue()
                    };
                    gridDrug.getStore().load({
                        params : {
                                    start : 0,
                                    limit : pagesize_pop
                                }
                        });
                    }
            });
            
           
   //////////////////////////////药物重置按钮 /////////////////////////////////////////////
   var resetGridCare=function() {
            Ext.getCmp("TextCode").reset();
            Ext.getCmp("TextDesc").reset();
            
            gridDrug.getStore().baseParams={MURowid:Ext.getCmp('HideRef').getValue() ,code:'',desc:''};
            gridDrug.getStore().load({
                params : {
                            start : 0,
                            limit : pagesize_pop
                        }
                });
            }
                    
    //////////////////////医嘱项 重置按钮//////////////////////////////////////////////////////////
    var btnCareRefresh = new Ext.Button({
            id : 'btnRefresh',
            iconCls : 'icon-refresh',
            text : $g('重置'),
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
            handler : resetGridCare 
    });
    /** 关联医护人员弹窗里的搜索工具条 */
    var drugSearchBar = new Ext.Toolbar({
                id : 'drugSearchBar',
                items : [$g('工号'), {
                            xtype : 'textfield',
                            id : 'TextCode',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
                        }, '-',
                        $g('姓名'), {
                            xtype : 'textfield',
                            id : 'TextDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
                        }, '-', btnCareSearch, '-', btnCareRefresh, '->'
                ]
            });
			
    var gridDrug = new Ext.grid.GridPanel({
                id : 'griddrug',
                region : 'center',
                width : 400,
                height : 300,
                closable : true,
                store : CareProvDs,
                trackMouseOver : true,
                singleSelect: true ,
                trackMouseOver : true,
                cm:CareProvCm ,
                sm :CareProvSm,  
                stripeRows : true,
                columnLines : true, 
                stateful : true,
                viewConfig : {
                                forceFit : true 
                            },
                bbar : CarePrvpaging,
                tbar:drugSearchBar,
                stateId : 'griddrug',
                 listeners:{
                     'dblclick': function(field,e){
                         var record=gridDrug.getSelectionModel().getSelected();
						 Ext.getCmp("MUCPDoctorDRF").setValue(record.get('RESCTPCPDR'));
                         Ext.getCmp("CTPCPDescF").setValue(record.get('CTPCPDesc'));
                         Ext.getCmp('CTPCPCodeF').setValue(record.get('TCTPCPCode'));
                         winDrug.hide();
                     }
                  }     
            }); 
        
    var ChildWinForm = new Ext.form.FormPanel({
                id : 'Childform-save',
                labelAlign : 'right',
                split : true,
                frame : true,
                title:$g('基本信息'),
                defaults : {
                anchor: '85%',
                border : false  
                },
                reader:ChildjsonReaderE,
                items : [ChildRowidText, 
						{
						   fieldLabel : 'MUCPParRef',
                           xtype:'textfield',
                           name :'MUCPParRef', 
                           id:'MUCPParRefF',
						   hideLabel : 'True',
						   hidden : true
						},{
						   fieldLabel : $g('医护人员DR'),
                           xtype:'textfield',
                           name :'MUCPDoctorDR', 
                           id:'MUCPDoctorDRF',
						   hideLabel : 'True',
						   hidden : true
						},{
                            id:'CTPCPDescF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTPCPDescF'),
                            fieldLabel:'<font color=red>*</font>'+$g('医生姓名'),
                            anchor: '85%',
                            editable:false,
                            allowBlank:false,
                            xtype:'trigger',
                            autoCreate:{tag:'input',type:'text',size:'13',autocomplete:'off'},
                            hideTrigger:false,
                            triggerClass:'elp-trigger', 
                            hiddenName:'CTPCPDesc',
                            onTriggerClick:function(e){
                                CareProvDs.load({ params: { MURowid:Ext.getCmp('HideRef').getValue() ,start: 0, limit: limit} });
                                if(!winDrug){
                                    winDrug = new Ext.Window({
                                        title:$g('医生姓名'),
                                        iconCls:'icon-find',
                                        width:620,
                                        height:260,
                                        layout:'fit',
                                        modal:true,
                                        buttonAlign:'center',
                                        closeAction:'hide',   
                                        items: gridDrug ,
                                        listeners : {
                                            "show" : function() {},
                                            "hide" : function() { 
                                                resetGridCare();
                                            },
                                            "close" : function() {}
                                        }
                                    });
                                }
                                winDrug.show(this);
                            }
                        },{
                           fieldLabel : '<font color=red>*</font>'+$g('医生工号'),
                           xtype:'displayfield',
                           allowBlank:false,
                           regexText:$g("医生工号不能为空"),
                           name :'CTPCPCode', 
                           id:'CTPCPCodeF',
                           readOnly : true, //Ext.BDP.FunLib.Component.DisableFlag('CTPCPCodeF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTPCPCodeF'))  
                        },Child_DateFromText,Child_DateToText,{
							fieldLabel: $g("开始时间"),
							hiddenName:'MUCPTimeFrom',
							dataIndex:'MUCPTimeFrom',
							id:'MUCPTimeFromF',
							labelWidth: 80,
							width: 150,
							xtype: "timefield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							maxValue: "23:00",
							minValue: "00:00",
							pickerMaxHeight: 100,
							increment: 30,
							format: "G:i:s"
						},{
							fieldLabel: $g("结束时间"),
							hiddenName:'MUCPTimeTo',
							dataIndex:'MUCPTimeTo',
							id:'MUCPTimeToF',
							labelWidth: 80,
							width: 150,
							xtype: "timefield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							maxValue: "23:00",
							minValue: "00:00",
							pickerMaxHeight: 100,
							increment: 30,
							format: "G:i:s"
						},{
                            xtype:'checkbox',
                            fieldLabel : $g('组长标志'),
                            id : 'MUCPLeaderFlagF',
                            name : 'MUCPLeaderFlag',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPLeaderFlagF'),
                            style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPLeaderFlagF')),
                            inputValue : 1 ,
                            listeners:{
                                'change':function(){
                                     var leaderdata=Ext.getCmp('MUCPLeaderFlagF').getValue()
                                     if (leaderdata=="1"){
                                         var flag = "";
                                         var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('HideRef').getValue(),"");
                                         if(flag == "1"){   
                                              Ext.Msg.alert($g("提示"),$g("此科室已分配组长!"))
                                          } 
                                     }
                                }
                            }
                        },{
                            xtype:'checkbox',
                            fieldLabel : $g('门诊出诊标志'),
                            id : 'MUCPOPFlagF',
                            name : 'MUCPOPFlag',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPOPFlagF'),
                            style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPOPFlagF')),
                            inputValue : 2  
                        },{
                            xtype:'checkbox',
                            fieldLabel : $g('住院出诊标志'),
                            id : 'MUCPIPFlagF',
                            name : 'MUCPIPFlag',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('MUCPIPFlagF'),
                            style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MUCPIPFlagF')),
                            inputValue : 3  
                        }]
            });
   
    
   /*********************************重置form的数据清空**************************************/
      var ChildClearForm = function()
      {
           Ext.getCmp("Childform-save").getForm().reset();   
      }
 
    /************************** 增加修改时弹出窗口*********************************************/
    var Childwin = new Ext.Window({
        width : 470,
        height : 390,
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
        closeAction : 'hide',
        labelWidth : 55,
        items : ChildWinForm,
        buttons : [{
            text : $g('保存'),
            iconCls : 'icon-save',
            id:'child_save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('child_save_btn'),
            handler : function() {
                var tempName = Ext.getCmp("CTPCPDescF").getValue();
                var tempCode = Ext.getCmp("CTPCPCodeF").getValue();
                var startDate = Ext.getCmp("MUCPDateFromF").getValue();
                var endDate = Ext.getCmp("MUCPDateToF").getValue();
                var popflag= Ext.getCmp("MUCPOPFlagF").getValue();
                var pipflag =Ext.getCmp("MUCPIPFlagF").getValue();
                if (tempName=="") {
                    Ext.Msg.show({
                                    title : '<font color=blue>'+$g('提示')+'</font>', 
                                    msg : '<font color=red>'+$g('医生姓名不能为空!')+'</font>', 
                                    minWidth : 200, 
                                    animEl: 'Childform-save',
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK ,
                                    fn:function()
                                    {
                                        Ext.getCmp("Childform-save").getForm().findField("CTPCPDescF").focus(true,true);
                                    }
                                 });
                    return;
                }
                 
            if (startDate=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>'+$g('提示')+'</font>',
                                msg : '<font color=red>'+$g('开始日期不能为空!')+'</font>',
                                minWidth : 200,
                                animEl: 'Childform-save',
                                icon : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("Childform-save").getForm().findField("MUCPDateFromF").focus(true,true);
                                }
                            });
                return;
            }
             var leaderdata=Ext.getCmp('MUCPLeaderFlagF').getValue()
                                     
            if (startDate != "" && endDate != "") {
                if (startDate > endDate) {
                    Ext.Msg.show({
                                    title : '<font color=blue>'+$g('提示')+'</font>',
                                    msg : '<font color=red>'+$g('开始日期不能大于结束日期!')+'</font>',
                                    minWidth : 200,
                                    animEl: 'Childform-save',
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                            return;
                    }
            }
           if (Childwin.title == $g("添加")) { 
            if ((popflag=="")&&(pipflag=="")){
                 Ext.Msg.confirm($g('系统提示'),$g('医生出诊标志为空,确定要添加数据吗?'),
                     function(btn){
                         if(btn=='yes'){
                            if (leaderdata=="1"){
                                var flag = "";
                                var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('HideRef').getValue(),"");
                                if(flag == "1"){   
                                     Ext.Msg.alert($g("提示"),$g("此单元组已经有组领导,不能再分配组领导!"))
                                     return;
                                 } 
                             }
                              ChildWinForm.form.submit({
                                        clientValidation : true,  
                                        url : SAVE_ACTION_URL_New,
                                        method : 'POST',
                                        success : function(form, action) {
                                         if (action.result.success == 'true') {
                                               var myrowid = action.result.id;
                                                Childwin.hide();
                                                Ext.Msg.show({
                                                                title : '<font color=blue>'+$g('提示')+'</font>',
                                                                msg : '<font color=green>'+$g('添加成功!')+'</font>',
                                                                animEl: 'Childform-save',
                                                                icon : Ext.Msg.INFO,
                                                                buttons : Ext.Msg.OK,
                                                                fn : function(btn) {
                                                                        var startIndex = wingrid.getBottomToolbar().cursor;
                                                                        wingrid.getStore().load({
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
                                                                            errorMsg = '<br/>'+$g('错误信息')+':' + action.result.errorinfo
                                                                        }
                                                                        Ext.Msg.show({
                                                                                        title : '<font color=blue>'+$g('提示')+'</font>',
                                                                                        msg : '<font color=red>'+$g('添加失败!')+errorMsg+'</font>' ,
                                                                                        minWidth : 200,
                                                                                        animEl: 'Childform-save',
                                                                                        icon : Ext.Msg.ERROR,
                                                                                        buttons : Ext.Msg.OK
                                                                                    });
                                                                }
                                            },
                                          failure : function(form, action) {
                                            Ext.Msg.show({
                                                            title : '<font color=blue>'+$g('提示')+'</font>',
                                                            msg : '<font color=red>'+$g('添加失败!')+'</font>' ,
                                                            minWidth : 200,
                                                            animEl: 'Childform-save',
                                                            icon : Ext.Msg.ERROR,
                                                            buttons : Ext.Msg.OK
                                                        });
                                                }
                                        })
                                     }else{
                                            Ext.getCmp('MUCPOPFlagF').focus();
                                         }
                                     
                                     },this);
                            }  
                        else{
                            if (leaderdata=="1"){
                                var flag = "";
                                var flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('HideRef').getValue(),"");
                                if(flag == "1"){   
                                     Ext.Msg.alert($g("提示"),$g("此单元组已经有组领导,不能再分配组领导!"))
                                     return;
                                 } 
                             }
                                    ChildWinForm.form.submit({
                                        clientValidation : true,  
                                        url : SAVE_ACTION_URL_New,
                                        method : 'POST',
                                        success : function(form, action) {
                                         if (action.result.success == 'true') {
                                               var myrowid = action.result.id;
                                                Childwin.hide();
                                                Ext.Msg.show({
                                                                title : '<font color=blue>'+$g('提示')+'</font>',
                                                                msg : '<font color=green>'+$g('添加成功!')+'</font>',
                                                                animEl: 'Childform-save',
                                                                icon : Ext.Msg.INFO,
                                                                buttons : Ext.Msg.OK,
                                                                fn : function(btn) {
                                                                        var startIndex = wingrid.getBottomToolbar().cursor;
                                                                        wingrid.getStore().load({
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
                                                                            errorMsg = '<br/>'+$g('错误信息')+':' + action.result.errorinfo
                                                                        }
                                                                        Ext.Msg.show({
                                                                                        title : '<font color=blue>'+$g('提示')+'</font>',
                                                                                        msg : '<font color=red>'+$g('添加失败!')+errorMsg+'</font>' ,
                                                                                        minWidth : 200,
                                                                                        animEl: 'Childform-save',
                                                                                        icon : Ext.Msg.ERROR,
                                                                                        buttons : Ext.Msg.OK
                                                                                    });
                                                                }
                                            },
                                          failure : function(form, action) {
                                            Ext.Msg.show({
                                                            title : '<font color=blue>'+$g('提示')+'</font>',
                                                            msg : '<font color=red>'+$g('添加失败!')+'</font>' ,
                                                            minWidth : 300,
                                                            animEl: 'Childform-save',
                                                            icon : Ext.Msg.ERROR,
                                                            buttons : Ext.Msg.OK
                                                        });
                                                }
                                        })
                                    }
                           //  }
                        } 
                        else {
                                var _record = wingrid.getSelectionModel().getSelected();  
                                var rowid=_record.get('MUCPRowId');
                                Ext.MessageBox.confirm('<font color=blue>'+$g('提示')+'</font>', '<font color=red>'+$g('确定要修改该条数据吗?')+'</font>', function(btn) {
                                    if (btn == 'yes') {
                                        var flag = "";
                                        if (leaderdata=="1"){
                                            flag = tkMakeServerCall("web.DHCBL.CT.DHCCTLocMedUnitCareProv","RequiredMUCPLeader",Ext.getCmp('HideRef').getValue(),rowid);
                                            if(flag == "1"){   
                                                 Ext.Msg.alert($g("提示"),$g("此单元组已经有组领导,不能再分配组领导!"))
                                                 return;
                                             } 
                                         }
                                       
                                          ChildWinForm.form.submit({
                                            clientValidation : true, // 进行客户端验证
                                            url : SAVE_ACTION_URL_New,
                                            method : 'POST',
                                            success : function(form, action) {
                                                if (action.result.success == 'true') {
                                                    var myrowid = 'rowid='+action.result.id;
                                                    Childwin.hide();
                                                    Ext.Msg.show({
                                                                  title : '<font color=blue>'+$g('提示')+'</font>',
                                                                  msg : '<font color=green> '+$g('修改成功!')+'</font>',
                                                                  animEl: 'Childform-save',
                                                                  icon : Ext.Msg.INFO,
                                                                  buttons : Ext.Msg.OK,
                                                                  fn : function(btn) {
                                                                    var startIndex = wingrid.getBottomToolbar().cursor;
                                                                    Ext.BDP.FunLib.ReturnDataForUpdate('wingrid',ACTION_URL,myrowid);
                                                                 }
                                                          }); 
                                                } else {
                                                    var errorMsg = '';
                                                    if (action.result.errorinfo) {
                                                        errorMsg = '<br/>'+$g('错误信息')+':' + action.result.errorinfo
                                                    }
                                                    Ext.Msg.show({
                                                                    title : '<font color=blue>'+$g('提示')+'</font>',
                                                                    msg : '<font color=red>'+$g('修改失败!')+errorMsg+'</font>' ,
                                                                    minWidth : 200,
                                                                    animEl: 'Childform-save',
                                                                    icon : Ext.Msg.ERROR,
                                                                    buttons : Ext.Msg.OK
                                                                });
                                                            }
                                                    },
                                            failure : function(form, action) {
                                                Ext.Msg.show({
                                                                title : '<font color=blue>'+$g('提示')+'</font>',
                                                                msg : '<font color=red>'+$g('修改失败!')+'</font>' ,
                                                                minWidth : 200,
                                                                animEl: 'Childform-save',
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
                            text : $g('关闭'),
                            iconCls : 'icon-close',
                            handler : function() {
                              Childwin.hide();   
                              ChildClearForm();
                            }
                        }],
                        listeners : {
                            "show" : function() {
                            },
                            "hide" : function(){
                                resetGridCare()
                               },
                            "close" : function() {
                            }
                        }
                    });
    /********************************增加按钮**********************************/
    var childbtnAddwin = new Ext.Toolbar.Button({
                text : $g('添加'),
                tooltip : $g('添加'),
                iconCls : 'icon-add',
                id:'add_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('child_add_btn'),
                handler : AddData=function() {
                    Childwin.setTitle($g('添加'));
                    Childwin.setIconClass('icon-add');
                    Childwin.show('');
                    ChildWinForm.getForm().reset();
					Ext.getCmp('MUCPParRefF').setValue(Ext.getCmp('HideRef').getValue()); //新增时给form表单赋值
                },
                scope : this
            });
    /********************************修改按钮**********************************/
    var childbtnEditwin = new Ext.Toolbar.Button({
                text : $g('修改'),
                tooltip : $g('修改'),
                iconCls : 'icon-update',
                id:'child_update_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('child_update_btn'),
                handler : UpdateData=function() {
                    var records =  wingrid.selModel.getSelections();
                    var recordsLen= records.length;
                    if(recordsLen == 0){
                            Ext.Msg.show({
                                            title:$g('提示'),
                                            minWidth:280,
                                            msg:$g('请选择需要修改的行!'),
                                            icon:Ext.Msg.WARNING,
                                            buttons:Ext.Msg.OK
                                        }); 
                         return
                     } 
                     else{
                            Childwin.setTitle($g('修改'));
                            Childwin.setIconClass('icon-update');
                            Childwin.show('');
                            ChildloadFormData(wingrid);
                         }
                 }
        });
    /***************************数据保存格式为json格式**********************************/
    var childds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : ACTION_URL
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        },[{
                            name: 'MUCPRowId',
                            mapping:'MUCPRowId',
                            type:'string'
                        }, {
                            name: 'MUCPParRef',
                            mapping:'MUCPParRef',
                            type:'string'
                        },{
                            name: 'CTMUChildsub',
                            mapping:'CTMUChildsub',
                            type:'string'
                        },{//将原本代表的医生姓名改为DR
							name: 'MUCPDoctorDR',
                            mapping:'MUCPDoctorDR',
                            type:'string'
						},{//添加医生姓名
                            name:'CTPCPDesc',
                            mapping:'CTPCPDesc',
                            type:'string'
                        }, {
                            name:'CTPCPCode',
                            mapping:'CTPCPCode',
                            type:'string'
                        },{
                            name:'MUCPLeaderFlag',
                            mapping:'MUCPLeaderFlag',
                            type:'string'
                        },{
                            name: 'MUCPOPFlag',
                            mapping:'MUCPOPFlag',
                            type:'string'
                        },{
                            name:'MUCPIPFlag',
                            mapping:'MUCPIPFlag',
                            type:'string'
                        },{
                            name: 'MUCPDateFrom',
                            mapping:'MUCPDateFrom',
                            type : 'date',
                            dateFormat : 'm/d/Y'
                        },{
                            name:'MUCPTimeFrom',
                            mapping:'MUCPTimeFrom',
                            type:'string' 
                         },{
                            name: 'MUCPDateTo',
                            mapping:'MUCPDateTo',   
                            type : 'date' ,
                            dateFormat : 'm/d/Y'
                        } ,{
                            name:'MUCPTimeTo',
                            mapping:'MUCPTimeTo',
                            type:'string' 
                         }    
                ]) 
        });
 
    /************************************数据分页************************************/
    var ChildPaging = new Ext.PagingToolbar({
            pageSize: limit,
            store: childds,
            displayInfo: true,
            displayMsg : $g('显示第')+' {0} '+$g('条到')+' {1} '+$g('条记录,一共')+' {2} '+$g('条'),
            emptyMsg : $g("没有记录"),
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p)
                { 
                   limit=this.pageSize;
                }
            }
        });
    /***************************增删改工具条*********************************/
    var childtbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [childbtnAddwin, '-', childbtnEditwin, '-', childbtnDel,'->',btnlog,'-',btnhislog] 
        })
    /*************************** 搜索工具条**********************************/
    var childbtnSearch = new Ext.Button({
                id : 'child_btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('child_btnSearch'),
                iconCls : 'icon-search',
                text : $g('搜索'),
                handler : function() {
                var code=Ext.getCmp('child_TextCode').getValue();
                var desc=Ext.getCmp('child_TextDesc').getValue();
				var leaderdata=Ext.getCmp('checkhistory').getValue();   
                wingrid.getStore().baseParams={
                        code:code,
                        desc:desc,
						checkhistory:leaderdata,
                        ParRef:Ext.getCmp('HideRef').getValue()
                };
                wingrid.getStore().load({
                    params : {
                                start : 0,
                                limit : limit
                            }
                        });
                    }
            });
    /******************************* 刷新工作条************************************/
    var childbtnRefresh = new Ext.Button({
                id : 'child_btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('child_btnRefresh'),
                iconCls : 'icon-refresh',
                text : $g('重置'),
                handler : function refresh() {
                    Ext.BDP.FunLib.SelectRowId="";
                    Ext.getCmp("child_TextCode").reset();
                    Ext.getCmp("child_TextDesc").reset();
					Ext.getCmp('checkhistory').reset();
                    wingrid.getStore().baseParams={ParRef:Ext.getCmp('HideRef').getValue()};
                    wingrid.getStore().load({
                    params : {
                                start : 0,
                                limit : limit
                            }
                        });
                  }
            });
    /**********************************将工具条放到一起*****************************/
    var child_tb = new Ext.Toolbar({
                id : 'child_tb',
                items : [{ 
                            xtype : 'textfield',
                            hidden:true,
                            id:'HideRef'
                        },$g('医生工号'), {
                            xtype : 'textfield',
                            id : 'child_TextCode',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('child_TextCode')
                },$g('医生姓名'), {
                            xtype : 'textfield',
                            id : 'child_TextDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('child_TextDesc')
                },$g('查看历史'),{
							 id:'checkhistory',
							 xtype:'checkbox' 
			

				} ,'-', childbtnSearch, '-', childbtnRefresh,'->'],
                listeners : {
                    render : function() {
                        childtbbutton.render(wingrid.tbar) 
                    }
                }
            });
/************************************create the Grid *************************************/
    var ChildSm=new Ext.grid.RowSelectionModel({singleSelect:true})
    var ChildCm=new Ext.grid.ColumnModel([
    new Ext.grid.CheckboxSelectionModel(), {
                            header : 'MUCPRowId',
                            width : 120,
                            sortable : true,
                            dataIndex : 'MUCPRowId',
                            hidden : true
                        }, {
                            header : 'MUCPParRef',
                            width : 120,
                            sortable : true,
                            dataIndex : 'MUCPParRef',
                            hidden : true
                        }, {
                            header : 'CTMUChildsub',
                            width : 120,
                            sortable : true,
                            dataIndex : 'CTMUChildsub',
                            hidden : true
                        }, {
                            header : 'MUCPDoctorDR',
                            width : 120,
                            sortable : true,
                            dataIndex : 'MUCPDoctorDR',
                            hidden : true
                        }, {
                            header : $g('医生姓名'),
                            width : 120,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'CTPCPDesc'
                        }, {
                            header:$g('医生工号'),
                            width:100,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'CTPCPCode'
                        }, {
                            header : $g('组长标志'),
                            width : 100,
                            sortable : true,
                            renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon,
                            dataIndex : 'MUCPLeaderFlag'
                        },{
                            header:$g('门诊出诊标志'),
                            width:120,
                            sortable:true,
                            dataIndex:'MUCPOPFlag',
                            renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon
                        },{
                            header:$g('住院出诊标志'),
                            width:120,
                            sortable:true,
                            dataIndex:'MUCPIPFlag',
                            renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon
                        },{
                            header : $g('开始日期'),
                            width : 100,
                            sortable : true,
                            renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex :'MUCPDateFrom'
                        }, {
                            header:$g('开始时间'),
                            width:100,
                            sortable:true,
                            dataIndex :'MUCPTimeFrom'
                        },{
                            header : $g('结束日期'),
                            width : 100,
                            sortable : true,
                            renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex : 'MUCPDateTo'
                        },{
                            header:$g('结束时间'),
                            width:100,
                            sortable:true,
                            dataIndex :'MUCPTimeTo'
                        }]);
    var wingrid = new Ext.grid.GridPanel({
                id : 'wingrid',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : childds,
                stripeRows:true,
                autoFill:true,
                trackMouseOver : true,
                singleSelect: true ,
                cm:ChildCm,
                sm:ChildSm, 
                stripeRows : true,
                columnLines : true,  
                stateful : true,
                viewConfig : {
                    forceFit : true
                },
                bbar : ChildPaging,
                tbar : child_tb,
                stateId : 'wingrid'
            });
 
/************************************双击事件*****************************************/
      var ChildloadFormData = function(wingrid){
            var _record = wingrid.getSelectionModel().getSelected();  
            if (!_record) {
                Ext.Msg.alert($g('修改操作'), $g('请选择要修改的一项!'));
            } else {
			Ext.getCmp('MUCPRowIdF').setValue(_record.get('MUCPRowId')); //添加MUCPRowId隐藏字段
			Ext.getCmp('MUCPParRefF').setValue(_record.get('MUCPParRef')); //添加MUCPParRef隐藏字段
			Ext.getCmp('MUCPDoctorDRF').setValue(_record.get('MUCPDoctorDR')); //添加医护人员DR隐藏字段
            Ext.getCmp('CTPCPDescF').setValue(_record.get('CTPCPDesc'));
            Ext.getCmp('CTPCPCodeF').setValue(_record.get('CTPCPCode'));
            Ext.getCmp('MUCPDateFromF').setValue(_record.get('MUCPDateFrom'));
            Ext.getCmp('MUCPDateToF').setValue(_record.get('MUCPDateTo'));
			Ext.getCmp('MUCPTimeFromF').setValue(_record.get('MUCPTimeFrom'));
			Ext.getCmp('MUCPTimeToF').setValue(_record.get('MUCPTimeTo'));
           if (_record.get('MUCPLeaderFlag')=='Y') {
                 Ext.getCmp("MUCPLeaderFlagF").setValue("1")
            }
            else {
                 Ext.getCmp("MUCPLeaderFlagF").setValue("0")
            }
            if (_record.get('MUCPOPFlag')=='Y') {
                 Ext.getCmp("MUCPOPFlagF").setValue("1")
            }
            else {
                 Ext.getCmp("MUCPOPFlagF").setValue("0")
            }
             
            if (_record.get('MUCPIPFlag')=='Y') {
                 Ext.getCmp("MUCPIPFlagF").setValue("1")
            }
            else {
                 Ext.getCmp("MUCPIPFlagF").setValue("0")
            }
         }
       };
       wingrid.on("rowdblclick", function(wingrid, rowIndex, e) {
            var row = wingrid.getStore().getAt(rowIndex).data;
            Childwin.setTitle($g('修改'));      ///双击后
            Childwin.setIconClass('icon-update');
            Childwin.show('');
            ChildloadFormData(wingrid)  
        }); 
    Ext.BDP.FunLib.ShowUserHabit(wingrid,"User.DHCCTLocMedUnitCareProv");
   // Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
 
function getResourcePanel(){
    var winDesignatedDepartment = new Ext.Window({
            width:1000,
            height:450,
            layout:'fit',
            plain:true, 
            modal:true,
            frame:true,
            collapsible:true,
            hideCollapseTool:true,
            titleCollapse: true,
            bodyStyle:'padding:1px',
            buttonAlign:'center',
            closeAction:'hide',
            labelWidth:55,
            items: wingrid,
            listeners:{
                "show":function(){
                },
                "hide":function(){
                },
                "close":function(){
                }
            }
        });
    //gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}}) 
    return winDesignatedDepartment;
}
    
 
 