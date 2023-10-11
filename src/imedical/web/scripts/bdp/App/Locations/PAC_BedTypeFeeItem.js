/**@function: 床位类型-床位类型附加费用
 * @Title: 基础数据平台-基础数据
 * @Author: 钟荣枫
 * @date: 2020-1-23
 */
					

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	Ext.QuickTips.init();//悬浮提示,tooltip：'***'
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var limit = Ext.BDP.FunLib.PageSize.Main;
    //var pagesize_pop = Ext.BDP.FunLib.PageSize.P
    var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop; 

    var Query_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedTypeFeeItem&pClassQuery=GetList";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedTypeFeeItem&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCPACBedTypeFeeItem";
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedTypeFeeItem&pClassMethod=DeleteData";
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedTypeFeeItem&pClassMethod=OpenData";
	
	//combo使用
	///费用医嘱
	var ARCIM_QUERY_ACTION ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	///费用类型
	var BedType_FeeType_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeType&pClassQuery=GetDataForCmb1";
	///患者费别
	var AdmReason_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmReason&pClassQuery=GetDataForCmb1";
	

	
//////////////////////////////床位类型附加费用日志查看 ///////////////////////////////////////////////////////////
   var btnlogsub=Ext.BDP.FunLib.GetLogBtn("User.DHCPACBedTypeFeeItem");
   var btnhislogsub=Ext.BDP.FunLib.GetHisLogBtn("User.DHCPACBedTypeFeeItem");
     ///日志查看按钮是否显示
   var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
   if (btnlogflag==1)
   {
      btnlogsub.hidden=false;
    }
    else
    {
       btnlogsub.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
   var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
   if (btnhislogflag==1)
   {
      btnhislogsub.hidden=false;
    }
    else
    {
       btnhislogsub.hidden=true;
    }  
   btnhislogsub.on('click', function(btn,e){    
   var RowID="",Desc="",ParentDesc="";
   if (gridBedTypeFee.selModel.hasSelection()) {
       var rows = gridBedTypeFee.getSelectionModel().getSelections(); 
       RowID=rows[0].get('BEDTPIRowId');
       ParentDesc=tkMakeServerCall("web.DHCBL.CT.DHCPACBedTypeFeeItem","GetParentDesc",rows[0].get('BEDTPIBEDTPParRef')); 
       if (ParentDesc!=""){
         Desc=ParentDesc;
       }
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

	
	// 数据存储		
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : Query_ACTION_URL }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                            name: 'BEDTPIRowId',
                            mapping:'BEDTPIRowId',
                            type:'string'
                        }, {
                            name: 'BEDTPIBEDTPParRef',
                            mapping:'BEDTPIBEDTPParRef',
                            type:'string'
                        },{
                            name: 'BEDTPIChildsub',
                            mapping:'BEDTPIChildsub',
                            type:'string'
                        },{
							name: 'BEDTPIDesc',
                            mapping:'BEDTPIDesc',
                            type:'string'
						},{
                            name:'BEDTPIFeeType',
                            mapping:'BEDTPIFeeType',
                            type:'string'
                        }, {
                            name:'BEDTPIARCIMDR',
                            mapping:'BEDTPIARCIMDR',
                            type:'string'
                        }, {
                            name:'ARCIMPrice',
                            mapping:'ARCIMPrice',
                            type:'string'
                        },{
                            name:'BEDTPIStartDate',
                            mapping:'BEDTPIStartDate',
                            type:'string'
                        },{
                            name: 'BEDTPIEndDate',
                            mapping:'BEDTPIEndDate',
                            type:'string'
                        },{
                            name: 'BEDTPIAdmReasonDR',
                            mapping:'BEDTPIAdmReasonDR',
                            type:'string'
                        },{
                            name: 'BEDTPIStartAge',
                            mapping:'BEDTPIStartAge',
                            type:'string'
                        },{
                            name: 'BEDTPIEndAge',
                            mapping:'BEDTPIEndAge',
                            type:'string'
                        }   
                    ]) 
            });

	 /********************************床位类型费用删除按钮 *********************************************/
    var btnDel = new Ext.Toolbar.Button({
            text : '删除',
            tooltip : '删除',
            iconCls : 'icon-delete',
            id:'link_del_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('link_del_btn'),
            handler : function DelData() {
             if (gridBedTypeFee.selModel.hasSelection()) {
                Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗？', function(btn) {
                    if (btn == 'yes') {
                        Ext.MessageBox.wait('数据删除中，请稍候．．．', '提示');
                        var gsm =gridBedTypeFee.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id' : rows[0].get('BEDTPIRowId')
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
                                                 var startIndex = gridBedTypeFee.getBottomToolbar().cursor;
                                                 var totalnum=gridBedTypeFee.getStore().getTotalCount();
                                                 if((totalnum!=1)&&(totalnum/limit!=0)&&(totalnum%limit==1)){ startIndex-=limit; }
                                                 gridBedTypeFee.getStore().load({
                                                 params : {
                                                            ParRef:rows[0].get('BEDTPIRowId').split("||",1),
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
	
	 //费用类型
     var BEDTPIFeeType =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "<font color=red>*</font>费用类型",
        name: 'BEDTPIFeeType',
        id:'BEDTPIFeeTypeF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIFeeTypeF'),
        hiddenName:'BEDTPIFeeType',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        triggerAction : 'all',
        selectOnFocus:false,
        mode:'remote',
        pageSize:Ext.BDP.FunLib.PageSize.Combo,
        listWidth:250,
        valueField:'FTRowId',
        displayField:'FTDesc',
        store:new Ext.data.JsonStore({
            url:BedType_FeeType_QUERY_ACTION,
            root: 'data',
            totalProperty: 'total',
            idProperty: 'FTRowId',
            fields:['FTRowId','FTDesc'],
            remoteSort: true,
            sortInfo: {field: 'FTRowId', direction: 'ASC'}
        })
    });   
    
    
    //费用医嘱
    var BEDTPIARCIMDR =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "<font color=red>*</font>费用医嘱",
        name: 'BEDTPIARCIMDR',
        id:'BEDTPIARCIMDRF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIARCIMDRF'),
        hiddenName:'BEDTPIARCIMDR',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        triggerAction : 'all',
        selectOnFocus:false,
        mode:'remote',
        pageSize:Ext.BDP.FunLib.PageSize.Combo,
        listWidth:250,
        valueField:'ARCIMRowId',
        displayField:'ARCIMDesc',
        store:new Ext.data.JsonStore({
            url:ARCIM_QUERY_ACTION,
            root: 'data',
            totalProperty: 'total',
            idProperty: 'ARCIMRowId',
            fields:['ARCIMRowId','ARCIMDesc'],
            remoteSort: true,
            sortInfo: {field: 'ARCIMRowId', direction: 'ASC'}
        })
    });

    //患者费别
    var BEDTPIAdmReasonDR =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "费别",
        name: 'BEDTPIAdmReasonDR',
        id:'BEDTPIAdmReasonDRF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIAdmReasonDRF'),
        hiddenName:'BEDTPIAdmReasonDR',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        triggerAction : 'all',
        selectOnFocus:false,
        mode:'remote',
        pageSize:Ext.BDP.FunLib.PageSize.Combo,
        listWidth:250,
        valueField:'REARowId',
        displayField:'READesc',
        store:new Ext.data.JsonStore({
            url:AdmReason_QUERY_ACTION,
            root: 'data',
            totalProperty: 'total',
            idProperty: 'REARowId',
            fields:['REARowId','READesc'],
            remoteSort: true,
            sortInfo: {field: 'REARowId', direction: 'ASC'}
        })
    });

    var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'BEDTPIStartDate',
       id:'BEDTPIStartDateF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIStartDateF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDTPIStartDateF')),
       format : BDPDateFormat,
       allowBlank:false,
       regexText:"开始日期不能为空",
       editable:true,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });
    /// DateTo 
    var DateToText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '结束日期',
       name : 'BEDTPIEndDate',
       id:'BEDTPIEndDateF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIEndDateF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDTPIEndDateF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });
	/**************************************床位类型费用增加、修改的Form ***************************/		
    var WinForm = new Ext.form.FormPanel({
                id : 'btf-form-save',
                labelAlign : 'right',
                width : 300,
                split : true,
                frame : true,
                defaults : { width : 200, border : false },
                reader:new Ext.data.JsonReader({root:'list'},
                     [{
                            name: 'BEDTPIRowId',
                            mapping:'BEDTPIRowId',
                            type:'string'
                        },{
                            name: 'BEDTPIBEDTPParRef',
                            mapping:'BEDTPIBEDTPParRef',
                            type:'string'
                        },{
                            name:'BEDTPIFeeType',
                            mapping:'BEDTPIFeeType',
                            type:'string'
                        },{
                            name:'BEDTPIARCIMDR',
                            mapping:'BEDTPIARCIMDR',
                            type:'string'
                        },{
                            name:'BEDTPIStartDate',
                            mapping:'BEDTPIStartDate',
                            type:'string'
                        },{
                            name: 'BEDTPIEndDate',
                            mapping:'BEDTPIEndDate',
                            type:'string'
                        },{
                            name: 'BEDTPIAdmReasonDR',
                            mapping:'BEDTPIAdmReasonDR',
                            type:'string'
                        },{
                            name: 'BEDTPIStartAge',
                            mapping:'BEDTPIStartAge',
                            type:'string'
                        },{
                            name: 'BEDTPIEndAge',
                            mapping:'BEDTPIEndAge',
                            type:'string'
                        }
                     ]),
                defaultType : 'textfield',
                items : [{
                          fieldLabel : 'BEDTPIRowId',
                          id : 'BEDTPIRowIdF',
                          hideLabel : 'True',
                          hidden : true,
                          name:'BEDTPIRowId'
                        }, 
						{
						   fieldLabel : 'BEDTPIBEDTPParRef',
                           xtype:'textfield',
                           name :'BEDTPIBEDTPParRef', 
                           id:'BEDTPIBEDTPParRefF',
						   hideLabel : 'True',
						   hidden : true
						},BEDTPIFeeType,BEDTPIARCIMDR,BEDTPIAdmReasonDR,
						{
								fieldLabel : '开始年龄',
								xtype:'numberfield',
								id:'BEDTPIStartAge',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIStartAge'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDTPIStartAge')),
								minValue : 1,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'BEDTPIStartAge'						
						},{
								fieldLabel : '截止年龄',
								xtype:'numberfield',
								id:'BEDTPIEndAge',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDTPIEndAge'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDTPIEndAge')),
								minValue : 1,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'BEDTPIEndAge'						
						},
						DateFromText,DateToText

						]
                });
			
	
	
	
	// 床位类型费用增加、修改窗口		
    var winBedTypeFee = new Ext.Window({
        width : 440,
        height : 330,
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
        items : WinForm,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'sub_savebtn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
            handler : function() {
            var FeeType = Ext.getCmp("btf-form-save").getForm().findField("BEDTPIFeeType").getValue();
            var ARCIMDR = Ext.getCmp("btf-form-save").getForm().findField("BEDTPIARCIMDR").getValue();
            var BEDTPIStartDate= Ext.getCmp("btf-form-save").getForm().findField("BEDTPIStartDate").getValue();
            if (FeeType=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '费用类型不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("btf-form-save").getForm().findField("BEDTPIFeeType").focus();
                                }
                             });
                             return
                    }
            if (ARCIMDR=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '费用医嘱不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("btf-form-save").getForm().findField("BEDTPIARCIMDR").focus();
                                }
                             });
                             return
                    } 
            if (BEDTPIStartDate=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '开始日期不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("btf-form-save").getForm().findField("BEDTPIStartDate").focus();
                                }
                             });
                             return
                    }         
        if(WinForm.getForm().isValid()==false){
            Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
            return;
         } 
        if (winBedTypeFee.title == '添加') {
                    WinForm.form.submit({
                        clientValidation : true, // 进行客户端验证
                        url : SAVE_ACTION_URL,
                        method : 'POST',
                        success : function AddData(form, action) {
                            if (action.result.success == 'true') {
                                winBedTypeFee.hide();
                                var myrowid = action.result.id;
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                var startIndex = gridBedTypeFee.getBottomToolbar().cursor;
                                                gridBedTypeFee.getStore().load({
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
                            WinForm.form.submit({
                                clientValidation : true, // 进行客户端验证
                                waitMsg : '正在提交数据请稍后',
                                waitTitle : '提示',
                                url : SAVE_ACTION_URL,
                                method : 'POST',
                                success : function(form, action) {
                                    if (action.result.success == 'true') {
                                        winBedTypeFee.hide();
                                        var myrowid = 'rowid='+action.result.id;
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '修改成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                            Ext.BDP.FunLib.ReturnDataForUpdate('gridBedTypeFee',Query_ACTION_URL,myrowid);
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
                winBedTypeFee.hide();
                Ext.getCmp("btf-form-save").getForm().reset();
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
	
	
	
    ds.load({ params : { 
    
    	start : 0, limit : pagesize_pop },
                callback : function(records, options, success) {
                }
            }); // 加载数据

            
    // 床位类型费用列表			
    var gridBedTypeFee = new Ext.grid.GridPanel({
                id : 'gridBedTypeFee',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : ds,
                trackMouseOver : true,
                columnLines : true, //在列分隔处显示分隔符
                // tools:Ext.BDP.FunLib.Component.HelpMsg,
                columns : [new Ext.grid.CheckboxSelectionModel({
                            width : 20
                        }),{
                            header : 'BEDTPIRowId',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDTPIRowId',
                            hidden : true
                        }, {
                            header : 'BEDTPIBEDTPParRef',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDTPIBEDTPParRef',
                            hidden : true
                        }, {
                            header : 'BEDTPIChildsub',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDTPIChildsub',
                            hidden : true
                        }, {
                            header : '床位类型',
                            width : 120,
                            sortable : true,
                            dataIndex : 'BEDTPIDesc',
                            hidden : true
                        }, {
                            header : '费用类型',
                            width : 80,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BEDTPIFeeType'
                        }, {
                            header:'费用医嘱',
                            width:250,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDTPIARCIMDR'
                        }, {
                            header:'医嘱项价格',
                            width:100,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'ARCIMPrice'
                        }, {
                            header:'费别',
                            width:80,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDTPIAdmReasonDR'
                        }, {
                            header:'开始年龄',
                            width:80,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDTPIStartAge'
                        }, {
                            header:'截止年龄',
                            width:80,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDTPIEndAge'
                        },{
                            header : '开始日期',
                            width : 100,
                            sortable : true,
                            renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex :'BEDTPIStartDate'
                        },{
                            header : '结束日期',
                            width : 100,
                            sortable : true,
                            renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex : 'BEDTPIEndDate'
                        }],
                stripeRows : true ,
                stateful : true,
                viewConfig : {
                    forceFit : true,
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'"
                },
                sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
                bbar : new Ext.PagingToolbar({
                     pageSize: pagesize_pop,
                     store: ds,
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
                     	'费用类型', {
                            xtype : 'textfield',
                            id : 'TextFeeType' ,
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFeeType'),
                            xtype : 'combo',
                            fieldLabel : '<font color=red>*</font>费用类型',
                            name : 'BEDTPIFeeType',
                            stripCharsRe :  ' ',
                            store : new Ext.data.Store({
                            //autoLoad: true,
                            proxy : new Ext.data.HttpProxy({ url : BedType_FeeType_QUERY_ACTION }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'FTRowId', 'FTDesc' ])
                       		 }),
                            queryParam : 'desc',
                            triggerAction : 'all',
                            selectOnFocus : false,
                        //  typeAhead : true,
                            minChars : 0,
                            listWidth : 250,
                            valueField : 'FTRowId',
                            displayField : 'FTDesc',
                            pageSize : Ext.BDP.FunLib.PageSize.Combo,
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
                            }
                        }
                        ,'费用医嘱', {
                            xtype : 'textfield',
                            id : 'TextArcim' ,
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextArcim'),
                            xtype : 'combo',
                            fieldLabel : '<font color=red>*</font>费用医嘱',
                            name : 'BEDTPIARCIMDR',
                            stripCharsRe :  ' ',
                            store : new Ext.data.Store({
                           // autoLoad: true,
                            proxy : new Ext.data.HttpProxy({ url : ARCIM_QUERY_ACTION }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'ARCIMRowId', 'ARCIMDesc' ])
                       		 }),
                            queryParam : 'desc',
                            triggerAction : 'all',
                            selectOnFocus : false,
                        //  typeAhead : true,
                            minChars : 0,
                            listWidth : 250,
                            valueField : 'ARCIMRowId',
                            displayField : 'ARCIMDesc',
                            pageSize : Ext.BDP.FunLib.PageSize.Combo,
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
                            }
                        },
                            new Ext.Button(
                                        {   
                                            iconCls :'icon-search',
                                            text : '搜索',
                                            id:'searchbtn',
                                            disabled : Ext.BDP.FunLib.Component.DisableFlag('searchbtn'),
                                            handler : function() {
                                                            var gsm = Ext.getCmp("grid").getSelectionModel();// 获取选择列
                                                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                            gridBedTypeFee.getStore().baseParams={           
                                                                feetype : Ext.getCmp("TextFeeType").getValue(),
                                                                arcim : Ext.getCmp("TextArcim").getValue(),                                      
                                                                ParRef: rows[0].get('BEDTPRowId') 
                                                            };
                                                
                                                            gridBedTypeFee.getStore().load({
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
                                                  Ext.getCmp("TextFeeType").reset();                        //-----------将输入框清空
                                                    Ext.getCmp("TextArcim").reset();    
                                                    var gsm = Ext.getCmp("grid").getSelectionModel();// 获取选择列
                                                    var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                    gridBedTypeFee.getStore().baseParams={ ParRef: rows[0].get('BEDTPRowId') };
                                                    gridBedTypeFee.getStore().load({ params : { start : 0, limit : pagesize_pop } });
                                                     
                                                }
                                            })
                            ],
                            listeners : {
                                    render : function() {
                                    tbbutton.render(gridBedTypeFee.tbar) 
                                    }
                            }
                        })
            });

        var loadFormData = function(gridBedTypeFee){
		        var _record = gridBedTypeFee.getSelectionModel().getSelected(); 
		        if (!_record) {
		            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
		        } else {
		                WinForm.form.load( {
		                url : OPEN_ACTION_URL + '&id='+ _record.get('BEDTPIRowId'),   
		                success : function(form,action) {
		            } 
		           });
		        }
        };
        gridBedTypeFee.on("rowdblclick", function(gridBedTypeFee, rowIndex, e) {
                var row = gridBedTypeFee.getStore().getAt(rowIndex).data;
                winBedTypeFee.setTitle('修改');      
                winBedTypeFee.setIconClass('icon-update');
                winBedTypeFee.show('');
                loadFormData(gridBedTypeFee);
        }); 
        
        
    // 床位类型附加费用维护窗口    
    var win = new Ext.Window({
        title : '费用设定',
        width : 900,
        height : 500,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        autoScroll : true,
        collapsible : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        constrain : true,
        closeAction : 'hide',
        items : [gridBedTypeFee],
        listeners : {
                        "show" : function(){
                            Ext.getCmp("TextArcim").reset();
                            Ext.getCmp("TextFeeType").reset();
                            if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
                            {
                                keymap_main.disable();
                                keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
                            }                           
                        },
                        "hide" : function(){
                            ds.removeAll();
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
   
            
    //床位类型附加费用维护工具条	
    var tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [new Ext.Button({text:'添加', tooltip : '添加', iconCls : 'icon-add',id:'subadd',
                                disabled:Ext.BDP.FunLib.Component.DisableFlag('subadd'),
                                handler : function AddData() {

                                    var _record = Ext.getCmp("grid").getSelectionModel().getSelected();
	                            	var ParentRowId = _record.get('BEDTPRowId'); //此条数据的rowid
                                    winBedTypeFee.setTitle('添加');
                                    winBedTypeFee.setIconClass('icon-add');
                                    winBedTypeFee.show('new1');
                                    WinForm.getForm().reset();
                                    WinForm.getForm().findField('BEDTPIBEDTPParRef').setValue(ParentRowId);
                                    var ParRef=WinForm.getForm().findField('BEDTPIBEDTPParRef').getValue()
                                },
                                scope : this
                            }), '-',
                new Ext.Button({text : '修改',tooltip : '修改',iconCls : 'icon-update',id:'subupdate',
                                disabled:Ext.BDP.FunLib.Component.DisableFlag('subupdate'),
                                handler : function UpdateData() {
                                    if (gridBedTypeFee.selModel.hasSelection()) {
                                        winBedTypeFee.setTitle('修改');
                                        winBedTypeFee.setIconClass('icon-update');
                                        
                                        var record = gridBedTypeFee.getSelectionModel().getSelected(); 
                                        WinForm.getForm().reset();
                                        winBedTypeFee.show();
                                        loadFormData(gridBedTypeFee);
                                    } else {
                                        Ext.Msg.show({
                                                title : '提示',
                                                msg : '请选择需要修改的行！',
                                                icon : Ext.Msg.WARNING,
                                                buttons : Ext.Msg.OK
                                        });
                                    }
                                }
                    }), '-', btnDel //]
                    ,'->',btnlogsub,'-',btnhislogsub] 
    });

 
	
	Ext.BDP.FunLib.ShowUserHabit(gridBedTypeFee,"User.DHCPACBedTypeFeeItem");  
    

	function getFeePanel(){
		var winBedTypeFee = new Ext.Window({
				title:'',
				width:900,
	            height:500,
				layout:'fit',
				plain:true,//true则主体背景透明
				modal:true,
				frame:true,
				//autoScroll: true,
				collapsible:true,
				hideCollapseTool:true,
				titleCollapse: true,
				bodyStyle:'padding:3px',
				buttonAlign:'center',
				closeAction:'hide',
	            labelWidth:55,
				items: gridBedTypeFee,
				listeners:{
					"show":function(){
					},
					"hide":function(){
					},
					"close":function(){
					}
				}
			});
	  	return winBedTypeFee;
	}

