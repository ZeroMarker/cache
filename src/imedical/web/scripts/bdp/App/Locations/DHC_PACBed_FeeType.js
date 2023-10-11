/// 名称: 费用类型表
/// 编写者：基础数据平台-李可凡
/// 编写日期: 2021年6月29日

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');


Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var communityid=Ext.getUrlParam('communityid');

Ext.onReady(function() {
    
    var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeType&pClassMethod=OpenData";
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeType&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCPACBedFeeType";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeType&pClassMethod=DeleteData";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();	//启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip';	//设置消息提示方式为在下方直接显示
	
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "DHC_PACBed_FeeType"
	});
	
	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.DHCPACBedFeeType";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
	
	//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="DHC_PACBed_FeeType"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
    //////////////////////////////日志查看 ////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
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
       RowID=rows[0].get('FTRowId');
       Desc=rows[0].get('FTDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });


    DelData =function(){
		if(grid.selModel.hasSelection()){
			Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
				if(btn=='yes'){
					Ext.MessageBox.wait('数据删除中,请稍候...','提示');
					var gsm = grid.getSelectionModel();//获取选择列
					var rows = gsm.getSelections();//根据选择列获取到所有的行
					
					AliasGrid.DataRefer = rows[0].get('FTRowId');
					AliasGrid.delallAlias();
					
					Ext.Ajax.request({
						url:DELETE_ACTION_URL,
						method:'POST',
						params:{
								'id':rows[0].get('FTRowId')
						},
						callback:function(options, success, response){
							Ext.MessageBox.hide();
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if(jsonData.success == 'true'){
									Ext.Msg.show({
										title:'提示',
										msg:'数据删除成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){
											Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
										}
									});
								}
								else{
									var errorMsg ='';
									if(jsonData.info){
										errorMsg='<br />错误信息:'+jsonData.info
									}
									Ext.Msg.show({
										title:'提示',
										msg:'数据删除失败!'+errorMsg,
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
								}
							}
							else{
								Ext.Msg.show({
									title:'提示',
									msg:'异步通讯失败,请检查网络连接!',
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					},this);
				}
			},this);
		}
		else{
			Ext.Msg.show({
				title:'提示',
				msg:'请选择需要删除的行!',
				icon:Ext.Msg.WARNING,
				buttons:Ext.Msg.OK
			});
		}
    };
        
	var btnDel = new Ext.Toolbar.Button({
        text: '删除',
        tooltip: '删除',
        iconCls: 'icon-delete',
        id:'del_btn',
  		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
        handler: DelData
    });
    
    var WinForm = new Ext.form.FormPanel({
	    id: 'form-save',
		title : '基本信息',
		URL : SAVE_ACTION_URL,
		labelAlign : 'right',
		labelWidth : 100,
		split : true,
		frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
		waitMsgTarget : true,
		defaults : {
			anchor : '85%',
			bosrder : false
				},
		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'FTRowId',mapping:'FTRowId'},
										{name: 'FTCode',mapping:'FTCode'},
                                         {name: 'FTDesc',mapping:'FTDesc'},
                                         {name: 'FTStartDate',mapping:'FTStartDate'},
                                         {name: 'FTEndDate',mapping:'FTEndDate'}
                                        ]),
        defaultType: 'textfield',    
        items: [
            {
                fieldLabel: 'FTRowId',
                hideLabel:true,
                hidden : true,
                name: 'FTRowId'
            },{
                fieldLabel: "<span style='color:red;'>*</span>代码",
                name: 'FTCode',
                id:'FTCode',
                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FTCode')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('FTCode'),
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('FTCode'),
                allowBlank : false,
                blankText: '代码不能为空',
                enableKeyEvents:true, 
				validationEvent : 'blur',
                validator : function(thisText){
                    if(thisText==""){ //当文本框里的内容为空的时候不用此验证
                    	return true;
                    }
                    var className =  "web.DHCBL.CT.DHCPACBedFeeType";
                    var classMethod = "FormValidate";
                    var id="";
                    if(win.title=='修改'){
                    	var _record = grid.getSelectionModel().getSelected();
                    	var id = _record.get('FTRowId');
                    }
                    var flag = "";
                    var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
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
                fieldLabel: "<span style='color:red;'>*</span>描述",
                name: 'FTDesc',
                id:'FTDesc',
                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FTDesc')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('FTDesc'),
                //disabled : Ext.BDP.FunLib.Component.DisableFlag('FTDesc'),
                allowBlank : false,
                blankText: '描述不能为空'
            }, {
                xtype: 'datefield',
                fieldLabel: "<span style='color:red;'>*</span>开始日期",
                allowBlank : false,
                name: 'FTStartDate',
                id:'FTStartDate',
                //disabled : Ext.BDP.FunLib.Component.DisableFlag('FTStartDate'),
                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FTStartDate')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('FTStartDate'),
                dataIndex : 'FTStartDate',
				format: BDPDateFormat,
				enableKeyEvents : true,
				listeners : {
		       		'keyup' : function(field, e){
					Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
			        }
				}
            }, {
                xtype:'datefield',
                fieldLabel: '结束日期',
                name: 'FTEndDate',
                id:'FTEndDate',
             	//disabled : Ext.BDP.FunLib.Component.DisableFlag('FTEndDate'),
             	style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FTEndDate')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('FTEndDate'),
                dataIndex : 'FTEndDate',
				format: BDPDateFormat,
				enableKeyEvents : true,
				listeners : {
		       		'keyup' : function(field, e){
					Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
			        }
				}
            }
        ]        
    });
    
	var tabs = new Ext.TabPanel({
		 activeTab : 0,
		 frame : true,
		 border : false,
		 height : 500,
		 items : [WinForm, AliasGrid]
	 });
			 

	var win = new Ext.Window({
			title:'',
			width:380,
            height:300,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			//collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',   
			items: tabs,
			buttons:[{
				text:'保存',
				id:'save_btn',
				iconCls : 'icon-save',
  				disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
				handler: function() {
					if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
					}
					var startDate = Ext.getCmp("FTStartDate").getValue();
					var endDate = Ext.getCmp("FTEndDate").getValue();
					if (startDate != "" && endDate != "") {
						if (startDate > endDate) {
							Ext.Msg.show({
								title : '提示',
								msg : '开始日期不能大于结束日期！',
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
							return;
						}
					}
					if(win.title=="添加")
					{
						WinForm.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后',
							waitTitle : '提示',
							url : SAVE_ACTION_URL,
							method : 'POST',
							success : function(form, action) {
								if (action.result.success == 'true') {
									win.hide();
									
									//保存别名
									var myrowid = action.result.id;
									AliasGrid.DataRefer = myrowid;
									AliasGrid.saveAlias();
									
									Ext.Msg.show({
										title : '提示',
										msg : '添加成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											var startIndex = grid.getBottomToolbar().cursor;
											grid.getStore().load({
												params : {
													start : 0,
													limit : pagesize
												}
											});
										}
									});
								} else {
									var errorMsg = '';
									if (action.result.errorinfo) {
										errorMsg = '<br/>错误信息:'+ action.result.errorinfo
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
								Ext.Msg.alert('提示', '添加失败！');
							}
						})
					} else {
						Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
							if (btn == 'yes') {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										
										//保存别名
										AliasGrid.saveAlias();
											
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = "rowid="+ action.result.id;
											Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid);
												}
											});
										} 
										else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:'+ action.result.errorinfo						
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
										Ext.Msg.alert('提示', '修改失败');
									}
								})
							}
						}, this);				
					}
				}
			},{
				text:'关闭',
				iconCls : 'icon-close',
				handler:function(){
					win.hide();
				}
			}],
			listeners:{
				"show":function(){
					 Ext.getCmp("FTCode").focus(true,500);
				},
				"hide" : function() {
					Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾
				},
				"close":function(){
				}
			}
	});
		
	var btnAddwin = new Ext.Toolbar.Button({
        text: '添加',
        tooltip: '添加',
        iconCls: 'icon-add',
        id:'add_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
        handler: AddData=function () {
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
        scope: this
    });
	
    var btnEditwin = new Ext.Toolbar.Button({
        text: '修改',
        tooltip: '修改',
        iconCls: 'icon-update',
        id:'update_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
        handler: UpdateData=function() {
		 if(grid.selModel.hasSelection()){			
			win.setTitle('修改');
		    win.setIconClass('icon-update');
		    win.show();
		    
		    tabs.setActiveTab(0);
		    loadFormData(grid);
			
			//加载别名面板
            AliasGrid.DataRefer = _record.get('FTRowId');
    	    AliasGrid.loadGrid(); 
		}
        else
		{
			Ext.Msg.show({
						title:'提示',
						msg:'请选择需要修改的行!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}	
		}
    });	

    var fields = [{ name: 'FTRowId', mapping:'FTRowId',type: 'string'},
           { name: 'FTCode', mapping:'FTCode',type: 'string'},
           { name: 'FTDesc',mapping:'FTDesc', type: 'string' },
           { name: 'FTStartDate', mapping:'FTStartDate',type: 'string'},
           { name: 'FTEndDate',mapping:'FTEndDate', type: 'string'}
		];
    
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},fields),
		remoteSort: true
    });	
    
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);

	ds.load({
    	params:{start:0, limit:pagesize},
    	callback: function(records, options, success){
		}
	}); //加载数据
	
	var paging= new Ext.PagingToolbar({
        pageSize: pagesize,
        store: ds,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
		          "change":function (t,p)
		         { 
		             pagesize=this.pageSize;
		         }
        }
    })		
    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
	
	//增删改工具条
    var tbbutton=new Ext.Toolbar(
		{
			enableOverflow: true,			
			items:[btnAddwin, '-', btnEditwin, '-', btnDel, '-' ,btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]
		}
	);
	
    //搜索工具条
	var btnSearch=new Ext.Button({
        id:'btnSearch',
        iconCls:'icon-search',
        text:'搜索',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
        handler:function(){
        	grid.getStore().baseParams={			
				code:Ext.getCmp("TextCode").getValue(),
				desc:Ext.getCmp("TextDesc").getValue()					
			};
			grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize
				}
			});
        }
    });
    
	//刷新工作条
	var btnRefresh=new Ext.Button({
        id:'btnRefresh',
        iconCls:'icon-refresh',
        text:'重置',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
        handler:function(){
        	Ext.BDP.FunLib.SelectRowId =""; //翻译
        	
			Ext.getCmp("TextCode").reset();
			Ext.getCmp("TextDesc").reset();
			grid.getStore().baseParams={};
			grid.getStore().load({params:{start:0, limit:pagesize}});
   		}
    });
    
	var tb=new Ext.Toolbar({
        id:'tb',
        items:[
            '代码',
            {
				xtype: 'textfield',
				id: 'TextCode',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
			},
            '-',
			'描述',
            {
				xtype: 'textfield',
				id: 'TextDesc',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
			},'-',
			Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),
            '-',
            btnSearch,
			'-',
			btnRefresh
        ],
		listeners:{
			render:function(){
				tbbutton.render(grid.tbar)  //tbar.render(panel.bbar)这个效果在底部
			}
		}
	});
	
	var GridCM =[
            sm,
            { header: 'FTRowId', width: 120, sortable: true, dataIndex: 'FTRowId', hidden : true},
            { header: '代码', width: 120, sortable: true, dataIndex: 'FTCode' },
            { header: '描述', width: 120, sortable: true, dataIndex: 'FTDesc' },
            { header: '开始日期', width: 120, sortable: true, dataIndex: 'FTStartDate' },  
            { header: '结束日期', width: 120, sortable: true, dataIndex: 'FTEndDate' }
        ];

    var grid = new Ext.grid.GridPanel({
		id:'grid',
		region: 'center',
		width:900,
		height:500,
		closable:true,
		store: ds,
		trackMouseOver: true,
		columns: GridCM,	
		stripeRows: true,
		title: '费用类型',
		tools:Ext.BDP.FunLib.Component.HelpMsg, //右上角的小问号图标
		columnLines : true, //在列分隔处显示分隔符
		stateful: true,
		viewConfig: {
			forceFit: true
		},
		bbar:paging ,
		tbar:tb,	
		stateId: 'grid'
    });
  
  	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
  	
  	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
  	    
    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
    
       // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('FTRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };
    
	grid.on("rowdblclick",function(grid,rowIndex,e){  
        var row=grid.getStore().getAt(rowIndex).data;  
		win.setTitle('修改');
	    win.setIconClass('icon-update');
	    win.show(); 
	    loadFormData(grid);
	    //激活基本信息面板
        tabs.setActiveTab(0);
		//加载别名面板
        var _record = grid.getSelectionModel().getSelected();
        AliasGrid.DataRefer = _record.get('FTRowId');
        AliasGrid.loadGrid();
    });  
    
    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('FTRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	/************************************ 调用keymap*********************************************/
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid]
    });

});
