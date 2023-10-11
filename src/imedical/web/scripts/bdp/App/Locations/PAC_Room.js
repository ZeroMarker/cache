//房间维护
	//自定义一个cKData的vtype的表单验证，用来验证结束日期是否大约开始日期
	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();
    		var v2 = Ext.getCmp ("date2").getValue();
    		if(v1=="" || v2=="") return true;//有日期为空的情况要排除在外
    		return v2 > v1;//通过判断返回一个boolean值类型
		},
		cKDateText:'开始日期不能大于结束日期'//当判断错误时显示的错误提示信息
	});
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACRoom";
	var QUERY_ACTION= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACRoomType&pClassQuery=GetDataForCmb1";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassMethod=OpenData";
	var Floor_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocBuildingFloor&pClassQuery=GetDataForCmb1";
	var pagesize=Ext.BDP.FunLib.PageSize.Main;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
 /************************************键盘事件，按A键弹出添加窗口*************************/

  
  	//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PAC_Room"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
  
  //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PAC_Room"
	});
	
		/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.PACRoom";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
    
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
       RowID=rows[0].get('ROOMRowID');
       Desc=rows[0].get('ROOMDesc');
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
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
		
	});
	//多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
				var rowid=grid.getSelectionModel().getSelections()[0].get("ROOMRowID");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });

 /************************************工具条删除按钮**********************************/
    var btnDel = new Ext.Toolbar.Button({
        text: '删除',
        tooltip: '删除',
        iconCls: 'icon-delete',
        id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
        handler: DelData=function() {
			if(grid.selModel.hasSelection()){
			Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
				if(btn=='yes'){
					Ext.MessageBox.wait('数据删除中,请稍候...','提示');
					var gsm = grid.getSelectionModel();//获取选择列
                    var rows = gsm.getSelections();//根据选择列获取到所有的行
                    AliasGrid.DataRefer = rows[0].get('ROOMRowID');
					AliasGrid.delallAlias();
						
					Ext.Ajax.request({
						url:DELETE_ACTION_URL,
						method:'POST',
						params:{
						        'id':rows[0].get('ROOMRowID')
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
        }
    });
    
 
	/************************************ 增加修改的Form************************************/
    var WinForm = new Ext.form.FormPanel({
	    id: 'form-save',
        labelAlign: 'right',
        split: true,
        frame: true,
        title : '基本信息',
        labelWidth:125,
        defaults: { anchor: '85%', bosrder: false },
        reader: new Ext.data.JsonReader({root:'list'},
          [{ name: 'ROOMRowID', mapping:'ROOMRowID',type: 'string'},
           { name: 'ROOMCode', mapping:'ROOMCode',type: 'string'},
           { name: 'ROOMDesc',mapping:'ROOMDesc', type: 'string' },
           { name: 'ROOMRoomTypeDR', mapping:'ROOMRoomTypeDR',type: 'string'},
           { name: 'ROOMDifferentSexPatients',mapping:'ROOMDifferentSexPatients', type: 'string' },
           { name: 'ROOMQuery', mapping:'ROOMQuery',type: 'string'},
           { name: 'ROOMNoOfRows',mapping:'ROOMNoOfRows', type: 'string' },
		   { name: 'ROOMFloorDR',mapping:'ROOMFloorDR', type: 'string' },
           { name: 'ROOMDateFrom', mapping:'ROOMDateFrom',type: 'string'},
           { name: 'ROOMDateTo',mapping:'ROOMDateTo', type: 'string'}//列的映射
		]),
       defaultType : 'textfield',
        items: [
            {
                fieldLabel: 'ROOMRowID',
                hideLabel:'True',
                hidden : true,
                name: 'ROOMRowID'
            },{
                fieldLabel: '<font color=red>*</font>代码',
                name: 'ROOMCode',
                id:'ROOMCodeF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMCodeF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMCodeF')),
                allowBlank:false,
                blankText: '不能为空',
                validationEvent : 'blur',
                validator : function(thisText){
                    if(thisText==""){ //当文本框里的内容为空的时候不用此验证
                    	return true;
                    }
                    var className =  "web.DHCBL.CT.PACRoom"; //后台类名称
                    var classMethod = "Validate"; //数据重复验证后台函数名
                    var id="";
                    if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
                    	var _record = grid.getSelectionModel().getSelected();
                    	var id = _record.get('ROOMRowID'); //此条数据的rowid
                    }
                    var flag = "";
                    var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
                fieldLabel: '<font color=red>*</font>描述',
                name: 'ROOMDesc',
                id:'ROOMDescF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMDescF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMDescF')),
                allowBlank:false,
                blankText: '描述不能为空',
                validationEvent : 'blur',
                	validator : function(thisText){
                    if(thisText==""){ //当文本框里的内容为空的时候不用此验证
                    	return true;
                    }
                    var className =  "web.DHCBL.CT.PACRoom"; //后台类名称
                    var classMethod = "Validate"; //数据重复验证后台函数名
                    var id="";
                    if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
                    	var _record = grid.getSelectionModel().getSelected();
                    	var id = _record.get('ROOMRowID'); //此条数据的rowid
                    }
                    var flag = "";
                    var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
                fieldLabel: '<font color=red>*</font>房间类型',
                name:'ROOMRoomTypeDR',
                id:'ROOMRoomTypeDRF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMRoomTypeDRF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMRoomTypeDRF')),
                hiddenName:'ROOMRoomTypeDR',
                allowBlank:false,
                blankText: '不能为空',
                xtype : 'bdpcombo',
				store : new Ext.data.Store({
					//autoLoad: true,
					proxy : new Ext.data.HttpProxy({ url :QUERY_ACTION }),
					reader : new Ext.data.JsonReader({
								totalProperty : 'total',
								root : 'data',
								successProperty : 'success'
							}, [ 'ROOMTRowId', 'ROOMTDesc' ])
				}),
				mode : 'remote',
				queryParam : 'desc',
				loadByIdParam : 'rowid',
				//triggerAction : 'all',
				forceSelection : true,
				selectOnFocus : false,
				//typeAhead : true,
				//minChars : 1,
				listWidth : 250,
				valueField : 'ROOMTRowId',
				displayField : 'ROOMTDesc',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
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
            }, {
                fieldLabel: '医院楼层',
                name:'ROOMFloorDR',
                id:'ROOMFloorDRF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMFloorDRF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMFloorDRF')),
                hiddenName:'ROOMFloorDR',
                //allowBlank:false,
                //blankText: '不能为空',
                xtype : 'bdpcombo',
				store : new Ext.data.Store({
					//autoLoad: true,
					proxy : new Ext.data.HttpProxy({ url :Floor_QUERY_ACTION_URL }),
					reader : new Ext.data.JsonReader({
								totalProperty : 'total',
								root : 'data',
								successProperty : 'success'
							}, [ 'CTLBFRowId', 'CTLBFFloor' ])
				}),
				mode : 'remote',
				queryParam : 'desc',
				loadByIdParam : 'rowid',
				//triggerAction : 'all',
				forceSelection : true,
				selectOnFocus : false,
				//typeAhead : true,
				//minChars : 1,
				listWidth : 250,
				valueField : 'CTLBFRowId',
				displayField : 'CTLBFFloor',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
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
            }, {
                fieldLabel: '不同性别的病人在同一房间',
                name: 'ROOMDifferentSexPatients',
                id:'ROOMDifferentSexPatientsF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMDifferentSexPatientsF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMDifferentSexPatientsF')),
                xtype:'combo',
                hiddenName:'ROOMDifferentSexPatients',
				store:new Ext.data.SimpleStore({
				fields:['ROOMDifferentSexPatients','value'],
				data:[
					      ['D','Does Not Matter'],
					      ['W','Warning'],
					      ['N','Not Allowed']
					   ]
				}),
				displayField:'value',
				valueField:'ROOMDifferentSexPatients',
				mode:'local',
				readonly:true,
				triggerAction:'all',
				blankText:'请选择'
            }, 
             {
                fieldLabel: 'Query',
                name: 'ROOMQuery',
                id:'ROOMQueryF',
                hiddenName:'ROOMQuery',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMQueryF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMQueryF')),
                xtype:'combo',
				store: new Ext.data.JsonStore({
					fields : ['name', 'value'],
					data : [{
								name : '急诊等候区',//Waiting Area Edinburgh
								value : 'WE'
							}, {
								name : '病区等候区',//Booked Area
								value : 'BA'
							}, {
								name : '多人病房',//Multi Patient Room
								value : 'MPR'
							}, {
								name : '空房',//Spare Room
								value : 'SR'
							}]
				}),
				displayField:'name',
				valueField:'value',
				mode:'local',
				readonly:true,
				triggerAction:'all',
				blankText:'请选择'
            },  
             {
             	xtype : 'numberfield',
                fieldLabel: '等待区显示人数',
                name: 'ROOMNoOfRows',
                id:'ROOMNoOfRowsF',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMNoOfRowsF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMNoOfRowsF')),
                minValue : 0,
				minText : '人数不能小于0',
				nanText : '人数只能是数字'
            }, 
            	{
                xtype: 'datefield',
                fieldLabel: '<font color=red>*</font>开始日期',
                name: 'ROOMDateFrom',
                id:'date1',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
                allowBlank:false,
                blankText: '不能为空',
				format: BDPDateFormat,
                vtype:'cKDate',
				enableKeyEvents : true,
				listeners : {
		       		'keyup' : function(field, e){
					Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
			        }
				}
            }, {
                xtype:'datefield',
                fieldLabel: '结束日期',
                id:'date2',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
                name: 'ROOMDateTo',
				format: BDPDateFormat,
                 vtype:'cKDate',
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
		 height : 200,
		 items : [WinForm, AliasGrid]
	 });
		 
	var win = new Ext.Window({
			width:400,
            height:420,
			layout:'fit',
			plain:true, 
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
				  
					if (win.title == "添加") {
					
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						params : {									 
							'LinkHospId' :hospComp.getValue()         
						},
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
												var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
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
								url : SAVE_ACTION_URL_New,
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
												// salert(action.result);
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid);
												
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
									Ext.Msg.alert('提示', '修改失败');
								}
							})
						}
					}, this);
				}
			}
		},{
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
				"show" : function() {
				Ext.getCmp("form-save").getForm().findField("ROOMCode").focus(true,50);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
			},
			"close" : function() {
			}
		}
	});
	
    var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler :  AddData=function() {
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
    /************************************ 修改按钮************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				iconCls : 'icon-update',
				handler :  UpdateData=function() {
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						loadFormData(grid);
	        			var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        			tabs.setActiveTab(0);
			     		//加载别名面板
		           	 	AliasGrid.DataRefer = _record.get('ROOMRowID');
			        	AliasGrid.loadGrid(); 
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				}
			});
	var fields= [{ name: 'ROOMRowID', mapping:'ROOMRowID',type: 'string'},
           { name: 'ROOMCode', mapping:'ROOMCode',type: 'string'},
           { name: 'ROOMDesc',mapping:'ROOMDesc', type: 'string' },
           { name: 'ROOMRoomTypeDR', mapping:'ROOMRoomTypeDR',type: 'string'},
           { name: 'ROOMDifferentSexPatients',mapping:'ROOMDifferentSexPatients', type: 'string' },
           { name: 'ROOMQuery', mapping:'ROOMQuery',type: 'string'},
		   { name: 'ROOMFloorDR', mapping:'ROOMFloorDR',type: 'string'},
           { name: 'ROOMNoOfRows',mapping:'ROOMNoOfRows', type: 'string' },
           { name: 'ROOMDateFrom', mapping:'ROOMDateFrom',type: 'date', dateFormat: 'm/d/Y' },
           { name: 'ROOMDateTo',mapping:'ROOMDateTo', type: 'date', dateFormat: 'm/d/Y' }//列的映射
		  ];
    var ds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},fields
		  ),
		remoteSort: true
    });	
    
    Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
    
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
			items:[btnAddwin, '-', btnEditwin, '-', btnDel, '-' ,HospWinButton,'-' ,btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
		}
		)
    //搜索工具条
	var btnSearch=new Ext.Button({
                    id:'btnSearch',
                    iconCls:'icon-search',
                    text:'搜索',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                    handler:function(){
						grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue(),
							hospid:hospComp.getValue()
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
					grid.getStore().baseParams={
						hospid:hospComp.getValue()
					};
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
                        //'-',
						'描述',
                        {
						xtype: 'textfield',
						id: 'TextDesc',
						emptyText : '描述/别名',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},
						'-',
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),
			            '-',
                        btnSearch,
						'-',
						btnRefresh,
                        '->'
                        //btnHelp
                    ],
					listeners:{
                    render:function(){
                    tbbutton.render(grid.tbar)  //tbar.render(panel.bbar)这个效果在底部
                    }
                }
				});
// create the Grid
	
	var GridCM = [
            sm,
            { header: 'ROOMRowID',
              width: 160, 
              sortable: true,  
          	  dataIndex: 'ROOMRowID',
          	  hidden : true
          	 },
          	 { 
          	  header: '代码',
          	  width: 160,
          	  sortable: true, 
          	  dataIndex: 'ROOMCode'
          	  },
            {
            	header: '描述', 
            	width: 160, 
            	sortable: true, 
            	dataIndex: 'ROOMDesc' 
            },
            { 	header: '房间类型', 
            	width: 160,
            	sortable: true,
            	dataIndex: 'ROOMRoomTypeDR'
            },
            { 	header: '医院楼层',
            	width: 160, 
            	sortable: true,
            	dataIndex: 'ROOMFloorDR' 
            },
            {
            	header: '不同性别的病人在同一房间', 
            	width: 160, 
            	sortable: true,
            	dataIndex: 'ROOMDifferentSexPatients',
            	renderer:function(value)
            	{
            		if (value=="D")
            		{
            			value="Does Not Matter "
            			return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            		if (value=="W")
            		{
            		    value="Warning"
            		    return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            		if (value=="N")
            		{
            		   value="Not Allowed"
            		   return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            	}
            },
            { 
            	header: 'Query',
            	width: 160,
            	sortable: true,
            	dataIndex: 'ROOMQuery',
            	renderer:function(value)
            	{
            		if (value=="WE")
            		{
            		   value="急诊等候区"
            		   return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            		if (value=="BA")
            		{
            		   value="病区等候区"
            		   return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            		if (value=="MPR")
            		{
            		   value="多人病房"
            		   return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            		if (value=="SR")
            		{
            		   value="空房"
            		   return "<span style='color:black;<font size=15>;'>"+value+"</span>";
            		}
            	}
            },
            { 	header: '等待区显示人数',
            	width: 160, 
            	sortable: true,
            	dataIndex: 'ROOMNoOfRows' 
            },
            { 	header: '开始日期',
            	width: 85,
            	sortable: true,
            	renderer: Ext.util.Format.dateRenderer(BDPDateFormat),
            	dataIndex: 'ROOMDateFrom' 
            },  
            { 	header: '结束日期', 
            	width: 85, 
            	sortable: true,
            	renderer: Ext.util.Format.dateRenderer(BDPDateFormat), 
                dataIndex: 'ROOMDateTo' 
            }
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
    loadMask: { msg: '数据加载中,请稍候...' },
    tools:Ext.BDP.FunLib.Component.HelpMsg,
    title: '房间维护',
    // config options for stateful behavior
    stateful: true,
    viewConfig: {
			forceFit: true
		},
		bbar:paging ,
		tbar:tb,
		
    stateId: 'grid'
    
});
Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
  	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);		
Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
/*********************************双击事件***********************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('ROOMRowID'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	        		
	        	},
	                failure : function(form,action) {
	              
	                }
	            });
	            
	             
			        
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
	        	loadFormData(grid);
	        	var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        	tabs.setActiveTab(0);
			     //加载别名面板
		            AliasGrid.DataRefer = _record.get('ROOMRowID');
			        AliasGrid.loadGrid();
	    });	
	    
	      	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ROOMRowID');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	    
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
					limit : pagesize
				},
				callback : function(records, options, success) {
				}
			});
	}			
	
});

