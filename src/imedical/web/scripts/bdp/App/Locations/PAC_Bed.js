// 病区床位维护
// 陈莹 2013-6-3修改
///ofy2 贵医附医 床管医生
//Ext.onReady(function() {

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var BedType_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedType&pClassQuery=GetDataForCmb1";
	var Room_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassQuery=GetDataForCmb1";
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACBed";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=DeleteData";
	
	var GetPanelInfo_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=GetPanelInfo";
	var Quick_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=QuickSetPACBedFloorInfo";
	var batchUpBed_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=batchUpBedType";
	var batchAddBed_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBed&pClassMethod=batchAddBed";
	
	var BindingLocC="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1&admtype=O";  //科室数据获取
	var BindingBedO="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedOrganization&pClassQuery=GetDataForCmb1";  //床位编制数据获取 
	
	Ext.QuickTips.init();
	var pagesize_PACBed=Ext.BDP.FunLib.PageSize.Pop;
	var limit = Ext.BDP.FunLib.PageSize.Main;

	///床位附加费用
    var BedFee_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeItem&pClassQuery=GetList";
    var BedFee_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeItem&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCPACBedFeeItem";
    var BedFee_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeItem&pClassMethod=DeleteData";
    var BedFee_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeItem&pClassMethod=OpenData";
    ///费用医嘱
	//var ARCIM_QUERY_ACTION ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	var ARCIM_QUERY_ACTION ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetDataForCmb2";
	///费用类型
	var BedType_FeeType_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCPACBedFeeType&pClassQuery=GetDataForCmb1";
	///患者费别
	var AdmReason_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmReason&pClassQuery=GetDataForCmb1";
	///床位费时制
	var BedFee_Time_QUERY_ACTION="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BedFeeTime&pClassQuery=GetDataForCmb1";	
	//////////////////////////////床位附加费用日志查看 ///////////////////////////////////////////////////////////
   var btnlogsub=Ext.BDP.FunLib.GetLogBtn("User.DHCPACBedFeeItem");
   var btnhislogsub=Ext.BDP.FunLib.GetHisLogBtn("User.DHCPACBedFeeItem");
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
   if (BedFeegrid.selModel.hasSelection()) {
       var rows = BedFeegrid.getSelectionModel().getSelections(); 
       RowID=rows[0].get('BEDIRowId');
       ParentDesc=tkMakeServerCall("web.DHCBL.CT.DHCPACBedFeeItem","GetParentDesc",rows[0].get('BEDIBEDParRef')); 
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

	//病区床位维护
	  
    var PACBedbtnDel = new Ext.Toolbar.Button({
        text: '删除',
        tooltip: '删除',
        iconCls: 'icon-delete',
        id:'pacbed_del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbed_del_btn'),
        handler: DelData=function () {
			if(PACBedgrid.selModel.hasSelection()){
				var gsm = PACBedgrid.getSelectionModel();//获取选择列
	            var rows = gsm.getSelections();//根据选择列获取到所有的行
	            if(rows.length!=1){
					
					//批量删除 likefan
					var str1="";
					for(var i=0;i<rows.length;i++){
						if (str1!=""){
							str1=str1+"^"
						}
						str1+=rows[i].get('BEDRowID');
					}
					//alert(str1);
					Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
						if(btn=='yes'){
							var delAllresult = tkMakeServerCall("web.DHCBL.CT.PACBed","batchDelete",str1);
							if (delAllresult==1){
								Ext.Msg.show({
									title:'提示',
									msg:'数据删除成功!',
									icon:Ext.Msg.INFO,
									buttons:Ext.Msg.OK,
									fn:function(btn){
										PACBedWinForm.getForm().reset();
										var startIndex = PACBedgrid.getBottomToolbar().cursor;
										var totalnum=PACBedgrid.getStore().getTotalCount();
										if(totalnum==1){   //修改添加后只有一条，返回第一页
											var startIndex=0
										}
										else if((totalnum-1)%pagesize_PACBed==0)//最后一页只有一条
										{
											var pagenum=PACBedgrid.getStore().getCount();
											if (pagenum==1){ startIndex=startIndex-pagesize_PACBed;}  //最后一页的时候,不是最后一页则还停留在这一页
										}
										PACBedgrid.getStore().load({params:{start:startIndex, limit:pagesize_PACBed,ParRef:Ext.getCmp("hidden_ref").getValue()}});
									}
								});
							}else if(delAllresult==2){
								Ext.Msg.show({
									title:'提示',
									msg:'删除成功，部分床位上有病人或被引用，无法删除',
									icon:Ext.Msg.INFO,
									buttons:Ext.Msg.OK,
									fn:function(btn){
										PACBedWinForm.getForm().reset();
										var startIndex = PACBedgrid.getBottomToolbar().cursor;
										var totalnum=PACBedgrid.getStore().getTotalCount();
										if(totalnum==1){   //修改添加后只有一条，返回第一页
											var startIndex=0
										}
										else if((totalnum-1)%pagesize_PACBed==0)//最后一页只有一条
										{
											var pagenum=PACBedgrid.getStore().getCount();
											if (pagenum==1){ startIndex=startIndex-pagesize_PACBed;}  //最后一页的时候,不是最后一页则还停留在这一页
										}
										PACBedgrid.getStore().load({params:{start:startIndex, limit:pagesize_PACBed,ParRef:Ext.getCmp("hidden_ref").getValue()}});
									}
								});
							}else{
								Ext.Msg.show({
									title:'提示',
									msg:'数据删除失败!',
									minWidth:200,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					},this);
					
					/*
	            	Ext.Msg.show({
						title:'提示',
						msg:'请选择一行删除!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
					return;
					*/
					
	            }else{
					Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
						if(btn=='yes'){
							Ext.MessageBox.wait('数据删除中,请稍候...','提示');
							Ext.Ajax.request({
								url:DELETE_ACTION_URL,
								method:'POST',
								params:{
										'id':rows[0].get('BEDRowID')
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
													PACBedWinForm.getForm().reset();
													var startIndex = PACBedgrid.getBottomToolbar().cursor;
													var totalnum=PACBedgrid.getStore().getTotalCount();
													if(totalnum==1){   //修改添加后只有一条，返回第一页
														var startIndex=0
													}
													else if((totalnum-1)%pagesize_PACBed==0)//最后一页只有一条
													{
														var pagenum=PACBedgrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize_PACBed;}  //最后一页的时候,不是最后一页则还停留在这一页
													}
													PACBedgrid.getStore().load({params:{start:startIndex, limit:pagesize_PACBed,ParRef:Ext.getCmp("hidden_ref").getValue()}});
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
				
			}else {
				Ext.Msg.show({
					title:'提示',
					msg:'请选择需要删除的行!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
			}
        }
    });
    var ds_BedType = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({ url : BedType_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'BEDTPRowId', 'BEDTPDesc' ])
		});
	var ds_Room = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({ url : Room_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'ROOMRowID', 'ROOMDesc' ])
		});
		
	
	 var CTLOCStore=new Ext.data.JsonStore({
			url:BindingLocC,
			autoLoad: true,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTLOCRowID',
			fields:['CTLOCRowID','CTLOCDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTLOCRowID', direction: 'ASC'}
	});
	
	 var PACBedOStore=new Ext.data.JsonStore({
			url:BindingBedO,
			//autoLoad: true,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'BEDORGZRowId',
			fields:['BEDORGZRowId','BEDORGZDesc'],
			remoteSort: true,
			sortInfo: {field: 'BEDORGZRowId', direction: 'ASC'}
	});
	
    var PACBedWinForm = new Ext.form.FormPanel({
	    id: 'form-PACBed-save',
        //title: '数据信息',
        // region: 'west',
        labelAlign: 'right',
        labelWidth : 75,
		split : true, 
		frame : true,	
		waitMsgTarget : true,
        baseCls : 'x-plain',//form透明,不显示框框
        defaults: { anchor : '85%', bosrder: false },
        defaultType: 'textfield',
        reader: new Ext.data.JsonReader({root:'list'},
	            [{name: 'BEDRowID',mapping:'BEDRowID',type:'string'},
	             {name: 'BEDCode',mapping:'BEDCode',type:'string'},
	             {name: 'BEDBedTypeDR',mapping:'BEDBedTypeDR',type:'string'},
	             {name: 'BEDRoomDR',mapping:'BEDRoomDR',type:'string'},
	             {name: 'BEDRcFlag',mapping:'BEDRcFlag',type:'string'},
	             {name: 'BEDDateFrom',mapping:'BEDDateFrom',type:'string'},
	             {name: 'BEDDateTo',mapping:'BEDDateTo',type:'string'},
	             {name: 'BEDPositionLeft',mapping:'BEDPositionLeft',type:'string'},
	             {name: 'BEDPositionTop',mapping:'BEDPositionTop',type:'string'},
	             {name: 'BEDPositionHeight',mapping:'BEDPositionHeight',type:'string'},
	             {name: 'BEDPositionWidth',mapping:'BEDPositionWidth',type:'string'},
	             {name: 'EXPLocDR',mapping:'EXPLocDR',type:'string'},
	             {name: 'EXPBedOrganizationDR',mapping:'EXPBedOrganizationDR',type:'string'},
	             {name: 'BEDSequence',mapping:'BEDSequence',type:'string'}
	             
	       ]),
        items: [{
				fieldLabel : 'BEDWARDParRef',
				hideLabel : 'True',
				hidden : true,
				readOnly : true,
				name : 'BEDWARDParRef'
			},{
                fieldLabel: 'BEDRowID',
                hideLabel:'True',
                hidden : true,
                name: 'BEDRowID'
             },{
				fieldLabel : '<font color=red>*</font>序号',
				xtype:'numberfield',
				id:'BEDSequence',
				allowBlank : false,
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDSequence'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDSequence')),
				minValue : 0,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				name : 'BEDSequence'	
            },{
                fieldLabel: '<font color=red>*</font>床代码',
                name: 'BEDCode',
                id:'BEDCodeF',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDCodeF'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDCodeF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDCodeF')),
				allowBlank : false,
				validationEvent : 'blur',  
				//enableKeyEvents:true, 
		        validator : function(thisText){
		            //Ext.Msg.alert(thisText);
			        if(thisText==""){	//当文本框里的内容为空的时候不用此验证
			             return true;
			         }
			        var className =  "web.DHCBL.CT.PACBed";	//后台类名称
			        var classMethod = "Validate";	//数据重复验证后台函数名	                            
			        var id="";
			        var ParentRowId=Ext.getCmp("hidden_ref").getValue();
			        if(PACBedwin.title=='修改'){	//如果窗口标题为'修改'则获取rowid
			               var _record = PACBedgrid.getSelectionModel().getSelected();
			               var id = _record.get('BEDRowID');	//此条数据的rowid
			        }
			        var flag = "";
			        var flag = tkMakeServerCall(className,classMethod,ParentRowId,id,thisText);	//用tkMakeServerCall函数实现与后台同步调用交互
			        //Ext.Msg.alert(flag);
			        if(flag == "1"){	//当后台返回数据位"1"时转换为相应的布尔值
			             return false;
			        }else{
			             return true;
			        }
		        },
		        invalidText : '该床代码已经存在',
				listeners : {
						'change' : Ext.BDP.FunLib.Component.ReturnValidResult
				}
            }, {
                fieldLabel: '<font color=red>*</font>床类型',
                name: 'BEDBedTypeDR',
                id:'BEDBedTypeDRF',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDBedTypeDRF'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDBedTypeDRF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDBedTypeDRF')),
   				xtype:'bdpcombo',
				loadByIdParam : 'rowid',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
   				hiddenName : 'BEDBedTypeDR',
				mode : 'remote',
				store : ds_BedType,
				queryParam : 'desc',
				//triggerAction : 'all',
				forceSelection : true,
				selectOnFocus : false,
				listWidth : 270,
				//typeAhead : true,
				//minChars : 1,
				valueField : 'BEDTPRowId',
				displayField : 'BEDTPDesc',
				allowBlank : false,
				listeners:{
					'beforequery': function(e){
						this.store.baseParams = {
							desc:e.query,
							hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
						};
						this.store.load({params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
						}})
					}
				}
            },  {
                fieldLabel: '<font color=red>*</font>房间',
                name: 'BEDRoomDR',
                id:'BEDRoomDRF',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDRoomDRF'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDRoomDRF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDRoomDRF')),
   				xtype:'bdpcombo',
				loadByIdParam : 'rowid',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
   				hiddenName : 'BEDRoomDR',
				mode : 'remote',
				store : ds_Room,
				queryParam : 'desc',
				//triggerAction : 'all',
				listWidth : 270,
				forceSelection : true,
				selectOnFocus : false,
				//typeAhead : true,
				//minChars : 1,
				valueField : 'ROOMRowID',
				displayField : 'ROOMDesc',
				allowBlank : false,
				listeners:{
					   'beforequery': function(e){
							this.store.baseParams = {
								desc:e.query,
								hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
							};
							this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
							}})
					
						}
				}
            },
             {
             	xtype : 'checkbox',
                fieldLabel: '激活',
                name: 'BEDRcFlag',
                id:'BEDRcFlagF',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDRcFlagF'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDRcFlagF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDRcFlagF')),
   				inputValue : 'Y',
   				checked:true
   		 }, {
                xtype: 'datefield',
                fieldLabel: '<font color=red>*</font>开始日期',
                name: 'BEDDateFrom',
                id:'BEDDateFromF',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDDateFromF'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDDateFromF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDDateFromF')),
				format : BDPDateFormat,
				enableKeyEvents : true,
				listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }},
				allowBlank : false
			
            }, {
                xtype:'datefield',
                fieldLabel: '结束日期',
                name: 'BEDDateTo',
                id:'BEDDateToF',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDDateToF'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDDateToF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDDateToF')),
				format : BDPDateFormat,
				enableKeyEvents : true,
				listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
           				},{            
				fieldLabel: '所属科室',
				name: 'EXPLocDR',
				id:'EXPLocDR1',
				xtype:'bdpcombo',
				//hidden : true,
				loadByIdParam : 'rowid',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXPLocDR'),
				style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXPLocDR')),
				hiddenName:'EXPLocDR',
				//triggerAction:'all',//query
				forceSelection: true,
				selectOcnFocus:false,
				//typeAhead:true,
				mode:'remote',
				pageSize:Ext.BDP.FunLib.PageSize.Combo,
				//minChars: 1,
				listWidth:270,
				valueField:'CTLOCRowID',
				displayField:'CTLOCDesc',
				store:CTLOCStore,
				listeners:{
					   'beforequery': function(e){
							this.store.baseParams = {
								desc:e.query,
								hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
							};
							this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
							}})
					
						}
				}
		

            },{            
				fieldLabel: '床位编制',
				name: 'EXPBedOrganizationDR',
				id:'EXPBedOrganizationDR1',
				xtype:'bdpcombo',
				//hidden : true,
				loadByIdParam : 'rowid',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXPBedOrganizationDR'),
				style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXPBedOrganizationDR')),
				hiddenName:'EXPBedOrganizationDR',
				//triggerAction:'all',//query
				forceSelection: true,
				selectOcnFocus:false,
				//typeAhead:true,
				mode:'remote',
				pageSize:Ext.BDP.FunLib.PageSize.Combo,
				//minChars: 1,
				listWidth:270,
				valueField:'BEDORGZRowId',
				displayField:'BEDORGZDesc',
				store:PACBedOStore
           
			},{
				fieldLabel : '<font color=red></font>床宽(cm)',
				xtype:'numberfield',
				id:'BEDPositionWidth',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionWidth'),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionWidth'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDPositionWidth')),
				minValue : 0,
				maxValue : 400,//床宽度最大值400
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				name : 'BEDPositionWidth'	
			},{
				fieldLabel : '<font color=red></font>床高(cm)',
				xtype:'numberfield',
				id:'BEDPositionHeight',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionHeight'),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionHeight'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDPositionHeight')),
				minValue : 0,
				maxValue : 400,//床高度最大值400
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				name : 'BEDPositionHeight'						
			 },{
				fieldLabel : '<font color=red></font>X坐标(cm)',
				xtype:'numberfield',
				id:'BEDPositionLeft',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionLeft'),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionLeft'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDPositionLeft')),
				minValue : 0,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				name : 'BEDPositionLeft'
			},{
				fieldLabel : '<font color=red></font>Y坐标(cm)',
				xtype:'numberfield',
				id:'BEDPositionTop',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionTop'),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDPositionTop'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDPositionTop')),
				minValue : 0,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				name : 'BEDPositionTop'
           
            }
        ]        
    });

	var PACBedwin = new Ext.Window({
			title:'',
			width:350,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			autoScroll: true,
			//collapsible:true,
			//hideCollapseTool:true,
			//titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide', 
			items: PACBedWinForm,
			buttons:[{
				text:'保存',
				id:'pacbed_save_btn',
				iconCls : 'icon-save',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbed_save_btn'),
				handler: function() {
					var BEDCode = Ext.getCmp("form-PACBed-save").getForm().findField("BEDCode").getValue();
					var BEDBedTypeDR = Ext.getCmp("form-PACBed-save").getForm().findField("BEDBedTypeDR").getValue();
					var BEDRoomDR = Ext.getCmp("form-PACBed-save").getForm().findField("BEDRoomDR").getValue();
					var startDate = Ext.getCmp("form-PACBed-save").getForm().findField("BEDDateFrom").getValue();
	    			var endDate = Ext.getCmp("form-PACBed-save").getForm().findField("BEDDateTo").getValue();
					var BEDSequence = Ext.getCmp("form-PACBed-save").getForm().findField("BEDSequence").getValue();
	    			if (BEDSequence=="") {
	    				Ext.Msg.show({ title : '提示', msg : '序号不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          			return;
	    			}
					if (BEDCode=="") {
	    				Ext.Msg.show({ title : '提示', msg : '床代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });//20130603LISEN
	          			return;
	    			}
	    			if (BEDBedTypeDR=="") {
	    				Ext.Msg.show({ title : '提示', msg : '床类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          			return;
	    			}
	    			if (BEDRoomDR=="") {
	    				Ext.Msg.show({ title : '提示', msg : '房间不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
					if(PACBedWinForm.form.isValid()==false){return;}
				    if(PACBedwin.title=="添加")
					{
						PACBedWinForm.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后...',
							waitTitle : '提示',
							url : SAVE_ACTION_URL,
							method : 'POST',
							/*params : {									  //-------请求带的参数
										BEDWARDParRef:Ext.getCmp("hidden_ref").getValue()
									},*/ //在form打开的时候已经有赋值
							success : function(form, action) {
								if (action.result.success == 'true') {
									PACBedwin.hide();
									var myrowid = action.result.id;
									// var myrowid = jsonData.id;
									Ext.Msg.show({
												title : '提示',
												msg : '添加成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													PACBedgrid.getStore().load({
																params : {
																	start : 0,
																	limit : 1,
																	rowid : myrowid
																	,ParRef:Ext.getCmp("hidden_ref").getValue()
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
					}
					else
					{
						Ext.MessageBox.confirm('提示','确定要修改该条数据吗?',function(btn){
							if(btn=='yes'){
								PACBedWinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											PACBedwin.hide();
											var myrowid = "rowid=" + action.result.id;
											Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													Ext.BDP.FunLib.ReturnDataForUpdate("PACBedgrid", ACTION_URL, myrowid)
													/*PACBedgrid.getStore().load({
																params : {
																	start : 0,
																	limit : 1,
																	rowid : myrowid
																	,ParRef:Ext.getCmp("hidden_ref").getValue()
																}
															});*/
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
						},this);
	                   // WinForm.getForm().reset();
                    }
					
			}
			},{
				text : '关闭',
				iconCls : 'icon-close',
				handler:function(){
					PACBedwin.hide();
				}
			}],
			listeners:{
				"show":function(){
				},
				"hide":function(){
					Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾
				},
				"close":function(){
				}
			}
		});
    var PACBedbtnAddwin = new Ext.Toolbar.Button({
        text: '添加',
        tooltip: '添加',
        iconCls: 'icon-add',
        id:'pacbed_add_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbed_add_btn'),
        handler: AddData=function () {
			PACBedwin.setTitle('添加');
			PACBedwin.setIconClass('icon-add');
			PACBedwin.show();
			PACBedWinForm.getForm().reset();
			PACBedWinForm.getForm().findField('BEDWARDParRef').setValue(Ext.getCmp("hidden_ref").getValue());//20130603LISEN
        },
        scope: this
    });
    var PACBedbtnEditwin = new Ext.Toolbar.Button({
        text: '修改',
        tooltip: '修改',
        iconCls: 'icon-update',
        id:'pacbed_update_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbed_update_btn'),
        handler:UpdateData=function () {
				PACBedWinForm.getForm().findField('BEDWARDParRef').setValue(Ext.getCmp("hidden_ref").getValue());
				if (PACBedgrid.selModel.hasSelection()) {
					var _record = PACBedgrid.getSelectionModel().getSelections();
					if (_record.length!=1){
						Ext.Msg.show({
							title : '提示',
							msg : '请选择一行修改!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}else {
			            PACBedwin.setTitle('修改');
						PACBedwin.setIconClass('icon-update');
						PACBedwin.show();
			            Ext.getCmp("form-PACBed-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record[0].get('BEDRowID'),
			                waitMsg : '正在载入数据...',
			                success : function(form,action) {
			                    //Ext.Msg.alert(action);
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
					}
					
		           
		        }else {
		        	 Ext.Msg.show({
						title : '提示',
						msg : '请选择需要修改的行!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
		        }
			}
    });
    var PACBedds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
		  [{ name: 'BEDRowID', mapping:'BEDRowID',type: 'string'},
           { name: 'BEDCode',mapping:'BEDCode', type: 'string' },
           { name: 'BEDBedTypeDR',mapping:'BEDBedTypeDR', type: 'string' },
           { name: 'BEDRoomDR', mapping:'BEDRoomDR',type: 'string'},
           { name: 'BEDRcFlag',mapping:'BEDRcFlag', type: 'string' },
           { name: 'BEDPositionLeft',mapping:'BEDPositionLeft', type: 'string' },
           { name: 'BEDPositionTop',mapping:'BEDPositionTop', type: 'string' },
           { name: 'BEDPositionHeight',mapping:'BEDPositionHeight', type: 'string' },
           { name: 'BEDPositionWidth',mapping:'BEDPositionWidth', type: 'string' },
              
           { name: 'BEDDateFrom', mapping:'BEDDateFrom',type: 'date', dateFormat: 'm/d/Y' },
           { name: 'BEDDateTo',mapping:'BEDDateTo', type: 'date', dateFormat: 'm/d/Y' },//列的映射
           
           { name: 'CTLOCDesc', mapping:'CTLOCDesc',type: 'string' },
           { name: 'BEDORGZDesc',mapping:'BEDORGZDesc', type: 'string' },
		   { name: 'BEDSequence',mapping:'BEDSequence', type: 'string' }
		  ]),
		  
		remoteSort: true
    });	
	/*PACBedds.load({
    	params:{start:0, limit:20,ParRef:Ext.getCmp("hidden_ref").getValue()},
    	callback: function(records, options, success){
    		//alert(options);
			//Ext.Msg.alert('info', '加载完毕, success  = '+ records.length);
		}
	});*/ //加载数据
	/*PACBedds.on('beforeload',function(){//20130603LISEN
		Ext.apply(PACBedds.lastOptions.params, {
				    	ParRef : Ext.getCmp("hidden_ref").getValue()
				    });
	});*/
	var PACBedpaging= new Ext.PagingToolbar({
            pageSize: pagesize_PACBed,
            store: PACBedds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_PACBed=this.pageSize;
					}
				}
        })		
    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
	

    //---------------------------------------------------------------------2020-2-6 by 钟荣枫  增加床位附加费用弹窗          
      /********************************床位费用删除按钮 *********************************************/
    var BedFee_btnDel = new Ext.Toolbar.Button({
            text : '删除',
            tooltip : '删除',
            iconCls : 'icon-delete',
            id:'BedFee_del_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('BedFee_del_btn'),
            handler : function BedFee_DelData() {
             if (BedFeegrid.selModel.hasSelection()) {
                Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗？', function(btn) {
                    if (btn == 'yes') {
                        Ext.MessageBox.wait('数据删除中，请稍候．．．', '提示');
                        var gsm =BedFeegrid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : BedFee_DELETE_ACTION_URL,
                            method : 'POST',
                            params : {
                                'id' : rows[0].get('BEDIRowId')
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
                                                 var startIndex = BedFeegrid.getBottomToolbar().cursor;
                                                 var totalnum=BedFeegrid.getStore().getTotalCount();
                                                 if((totalnum!=1)&&(totalnum/limit!=0)&&(totalnum%limit==1)){ startIndex-=limit; }
                                                 BedFeegrid.getStore().load({
                                                 params : {
                                                            ParRef:rows[0].get('BEDIRowId').split("||",1),
															hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue(),
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
     var BEDIIFeeType =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "<font color=red>*</font>费用类型",
        name: 'BEDIIFeeType',
        id:'BEDIIFeeTypeF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDIIFeeTypeF'),
        hiddenName:'BEDIIFeeType',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        //triggerAction : 'all',
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
    var BEDIARCIMDR =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "<font color=red>*</font>费用医嘱",
        name: 'BEDIARCIMDR',
        id:'BEDIARCIMDRF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDIARCIMDRF'),
        hiddenName:'BEDIARCIMDR',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        //triggerAction : 'all',
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
        }),
		listeners:{
			   'beforequery': function(e){
				   if (e.query=="") return false;
					this.store.baseParams = {
						desc:e.query,
						hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
					};
					this.store.load({params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
					}})
			
				}
		}
    });
    ///床位费时制
    var BEDIFeeTime =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "床位费时制",
        name: 'BEDIFeeTime',
        id:'BEDIFeeTimeF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDIFeeTimeF'),
        hiddenName:'BEDIFeeTime',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        triggerAction : 'all',
        selectOnFocus:false,
        mode:'remote',
        pageSize:Ext.BDP.FunLib.PageSize.Combo,
        listWidth:250,
        valueField:'BedFeeTimeRowId',
        displayField:'BedFeeTimeName',
        store:new Ext.data.JsonStore({
            url:BedFee_Time_QUERY_ACTION,
            root: 'data',
            totalProperty: 'total',
            idProperty: 'BedFeeTimeRowId',
            fields:['BedFeeTimeRowId','BedFeeTimeName'],
            remoteSort: true,
            sortInfo: {field: 'BedFeeTimeRowId', direction: 'ASC'}
        })
    });     

    //患者费别
    var BEDIAdmReasonDR =new Ext.BDP.Component.form.ComboBox({    
        fieldLabel: "费别",
        name: 'BEDIAdmReasonDR',
        id:'BEDIAdmReasonDRF',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDIAdmReasonDRF'),
        hiddenName:'BEDIAdmReasonDR',//不能与id相同
        forceSelection: true,
        queryParam:"desc",
        //triggerAction : 'all',
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
        }),
		listeners:{
			   'beforequery': function(e){
					this.store.baseParams = {
						desc:e.query,
						hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
					};
					this.store.load({params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Combo
					}})
			
				}
		}
    });
    var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'BEDIStartDate',
       id:'BEDIStartDateF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDIStartDateF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDIStartDateF')),
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
       name : 'BEDIEndDate',
       id:'BEDIEndDateF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDIEndDateF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDIEndDateF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
            Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
    });

    /**************************************床位费用增加、修改的Form ***************************/		//2020
    var BedFee_WinForm = new Ext.form.FormPanel({
                id : 'BedFee_form-save',
                labelAlign : 'right',
                width : 300,
                split : true,
                frame : true,
                defaults : { width : 200, border : false },
                reader:new Ext.data.JsonReader({root:'list'},
                     [{
                            name: 'BEDIRowId',
                            mapping:'BEDIRowId',
                            type:'string'
                        },{
                            name: 'BEDIBEDParRef',
                            mapping:'BEDIBEDParRef',
                            type:'string'
                        },{
                            name: 'BEDIBEDChildsub',
                            mapping:'BEDIBEDChildsub',
                            type:'string'
                        },{
                            name:'BEDIIFeeType',
                            mapping:'BEDIIFeeType',
                            type:'string'
                        },{
                            name:'BEDIARCIMDR',
                            mapping:'BEDIARCIMDR',
                            type:'string'
                        },{
                            name: 'BEDIFeeTime',
                            mapping:'BEDIFeeTime',
                            type:'string'
                        },{
                            name:'BEDIStartDate',
                            mapping:'BEDIStartDate',
                            type:'string'
                        },{
                            name: 'BEDIEndDate',
                            mapping:'BEDIEndDate',
                            type:'string'
                        },{
                            name: 'BEDIAdmReasonDR',
                            mapping:'BEDIAdmReasonDR',
                            type:'string'
                        },{
                            name: 'BEDIStartAge',
                            mapping:'BEDIStartAge',
                            type:'string'
                        },{
                            name: 'BEDIEndAge',
                            mapping:'BEDIEndAge',
                            type:'string'
                        }
                     ]),
                defaultType : 'textfield',
                items : [{
                          fieldLabel : 'BEDIRowId',
                          id : 'BEDIRowIdF',
                          hideLabel : 'True',
                          hidden : true,
                          name:'BEDIRowId'
                        }, 
						{
						   fieldLabel : 'BEDIBEDParRef',
                           xtype:'textfield',
                           name :'BEDIBEDParRef', 
                           id:'BEDIBEDParRefF',
						   hideLabel : 'True',
						   hidden : true
						},{
						   fieldLabel : 'BEDIBEDChildsub',
                           xtype:'textfield',
                           name :'BEDIBEDChildsub', 
                           id:'BEDIBEDChildsub',
						   hideLabel : 'True',
						   hidden : true
						},BEDIIFeeType,BEDIARCIMDR,BEDIFeeTime,BEDIAdmReasonDR,
						{
								fieldLabel : '开始年龄',
								xtype:'numberfield',
								id:'BEDIStartAge',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDIStartAge'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDIStartAge')),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'BEDIStartAge'						
						},{
								fieldLabel : '截止年龄',
								xtype:'numberfield',
								id:'BEDIEndAge',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDIEndAge'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDIEndAge')),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'BEDIEndAge'						
						},
						DateFromText,DateToText
						
						]
                });
    
    var BedFee_ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : BedFee_ACTION_URL }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                            name: 'BEDIRowId',
                            mapping:'BEDIRowId',
                            type:'string'
                        }, {
                            name: 'BEDIBEDParRef',
                            mapping:'BEDIBEDParRef',
                            type:'string'
                        },{
                            name: 'BEDIBEDChildsub',
                            mapping:'BEDIBEDChildsub',
                            type:'string'
                        },{
                            name: 'BEDIChildsub',
                            mapping:'BEDIChildsub',
                            type:'string'
                        }/*,{
							name: 'BEDIDesc',
                            mapping:'BEDIDesc',
                            type:'string'
						}*/,{
                            name:'BEDIIFeeType',
                            mapping:'BEDIIFeeType',
                            type:'string'
                        }, {
                            name:'BEDIARCIMDR',
                            mapping:'BEDIARCIMDR',
                            type:'string'
                        }, {
                            name:'BEDIFeeTime',
                            mapping:'BEDIFeeTime',
                            type:'string'
                        },{
                            name:'ARCIMPrice',
                            mapping:'ARCIMPrice',
                            type:'string'
                        },{
                            name:'BEDIStartDate',
                            mapping:'BEDIStartDate',
                            type:'string'
                        },{
                            name: 'BEDIEndDate',
                            mapping:'BEDIEndDate',
                            type:'string'
                        },{
                            name: 'BEDIAdmReasonDR',
                            mapping:'BEDIAdmReasonDR',
                            type:'string'
                        },{
                            name: 'BEDIStartAge',
                            mapping:'BEDIStartAge',
                            type:'string'
                        },{
                            name: 'BEDIEndAge',
                            mapping:'BEDIEndAge',
                            type:'string'
                        } 
                    ]) 
            });
    BedFee_ds.load({ params : { 
    
    start : 0, limit : pagesize_PACBed },
                callback : function(records, options, success) {
                }
            }); // 加载数据
    // 床位费用列表			2020
    var BedFeegrid = new Ext.grid.GridPanel({
                id : 'BedFeegrid',
                region : 'center',
                width : 900,
                height : 500,
                closable : true,
                store : BedFee_ds,
                trackMouseOver : true,
                columnLines : true, //在列分隔处显示分隔符
                // tools:Ext.BDP.FunLib.Component.HelpMsg,
                columns : [new Ext.grid.CheckboxSelectionModel({
                            width : 20
                        }),{
                            header : 'BEDIRowId',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDIRowId',
                            hidden : true
                        }, {
                            header : 'BEDIBEDParRef',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDIBEDParRef',
                            hidden : true
                        }, {
                            header : 'BEDIBEDChildsub',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDIBEDChildsub',
                            hidden : true
                        }, {
                            header : 'BEDIChildsub',
                            width : 80,
                            sortable : true,
                            dataIndex : 'BEDIChildsub',
                            hidden : true
                        }/*, {
                            header : '床位类型',
                            width : 120,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BEDIDesc',
                           
                        }*/, {
                            header : '费用类型',
                            width : 80,
                            sortable : true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex : 'BEDIIFeeType'
                        }, {
                            header:'费用医嘱',
                            width:250,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDIARCIMDR'
                        }, {
                            header:'医嘱项价格',
                            width:100,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'ARCIMPrice'
                        },{
                            header:'床位费时制',
                            width:100,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDIFeeTime'
                        }, {
                            header:'费别',
                            width:80,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDIAdmReasonDR'
                        }, {
                            header:'开始年龄',
                            width:80,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDIStartAge'
                        }, {
                            header:'截止年龄',
                            width:80,
                            sortable:true,
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            dataIndex:'BEDIEndAge'
                        },{
                            header : '开始日期',
                            width : 100,
                            sortable : true,
                           // renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex :'BEDIStartDate'
                        },{
                            header : '结束日期',
                            width : 100,
                            sortable : true,
                         //   renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
                            dataIndex : 'BEDIEndDate'
                        }],
                stripeRows : true ,
                stateful : true,
                viewConfig : {
                    forceFit : true,
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'"
                },
                sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
                bbar : new Ext.PagingToolbar({
                     pageSize: pagesize_PACBed,
                     store: BedFee_ds,
                     displayInfo: true,
                     displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                     emptyMsg : "没有记录",
                     plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                     listeners : {
                          "change":function (t,p)
                         { 
                             pagesize_PACBed=this.pageSize;
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
                            name : 'BEDIIFeeType',
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
                            name : 'BEDIARCIMDR',
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
                                'beforequery':function(e){
									if (e.query=="") return false;
									this.store.baseParams = {
										desc:e.query,
										hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
									};
                                    e.combo.store.load({
                                            params:{
                                                    start:0,
                                                    limit:10,
                                                    rowid:'',
                                                    desc:e.combo.getRawValue() 
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
                                            id:'BedFee_search_btn',
                                            disabled : Ext.BDP.FunLib.Component.DisableFlag('BedFee_search_btn'),
                                            handler : function() {
                                                            var gsm = PACBedgrid.getSelectionModel();// 获取选择列
                                                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                            var str=rows[0].get('BEDRowID').split('||');
									                        var ParRef=str[0];
									                        var BedChildsub=str[1];
                                                            BedFeegrid.getStore().baseParams={           
                                                                feetype : Ext.getCmp("TextFeeType").getValue(),
                                                                arcim : Ext.getCmp("TextArcim").getValue(),                                      
                                                                ParRef: ParRef,
																hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue(),
                                                                BedChildsub: BedChildsub
                                                            };
                                                
                                                            BedFeegrid.getStore().load({
                                                            params : {
                                                                        start : 0,
                                                                        limit : pagesize_PACBed
                                                                    }
                                                                });
                                                            }
 
                                            }),  '-',
                            new Ext.Button({ iconCls : 'icon-refresh',
                                                text : '重置',
                                                id:'BedFee_reset_btn',
                                                disabled : Ext.BDP.FunLib.Component.DisableFlag('BedFee_reset_btn'),
                                                handler : function() {
                                                  Ext.getCmp("TextFeeType").reset();                        //-----------将输入框清空
                                                    Ext.getCmp("TextArcim").reset(); 
                                                    var gsm = PACBedgrid.getSelectionModel();// 获取选择列
                                                    var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                                    var str=rows[0].get('BEDRowID').split('||');
								                    var ParRef=str[0];
								                    var BedChildsub=str[1];
                                                    BedFeegrid.getStore().baseParams={ ParRef: ParRef, BedChildsub: BedChildsub , hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()};
                                                    BedFeegrid.getStore().load({ params : { start : 0, limit : pagesize_PACBed } });
                                                     
                                                }
                                            })
                            ],
                            listeners : {
                                    render : function() {
                                    BedFee_tbbutton.render(BedFeegrid.tbar) 
                                    }
                            }
                        })
            });

        var BedFee_loadFormData = function(BedFeegrid){
		    var _record = BedFeegrid.getSelectionModel().getSelected(); 
		    if (!_record) {
		        Ext.Msg.alert('修改操作', '请选择要修改的一项!');
		    } else {
		            BedFee_WinForm.form.load( {
		            url : BedFee_OPEN_ACTION_URL + '&id='+ _record.get('BEDIRowId'),   
		            success : function(form,action) {
		        } 
		       });
		    }
        };
        BedFeegrid.on("rowdblclick", function(BedFeegrid, rowIndex, e) {
                var row = BedFeegrid.getStore().getAt(rowIndex).data;
                win_BedFee.setTitle('修改');      
                win_BedFee.setIconClass('icon-update');
                win_BedFee.show('');
                BedFee_loadFormData(BedFeegrid);
        });

	 //床位附加费用维护工具条	2020
    var BedFee_tbbutton = new Ext.Toolbar({
        enableOverflow : true,
        items : [new Ext.Button({text:'添加', tooltip : '添加', iconCls : 'icon-add',id:'BedFee_add_btn',
                                disabled:Ext.BDP.FunLib.Component.DisableFlag('BedFee_add_btn'),
                                handler : function BedFee_AddData() {
                                    var _record = PACBedgrid.getSelectionModel().getSelected();
	                            	
                        			var str=_record.get('BEDRowID').split('||');
                        			var ParRef=str[0];
                        			var BEDChildsub=str[1];
                                    win_BedFee.setTitle('添加');
                                    win_BedFee.setIconClass('icon-add');
                                    win_BedFee.show('new');
                                    BedFee_WinForm.getForm().reset();
                                    BedFee_WinForm.getForm().findField('BEDIBEDParRef').setValue(ParRef);
                                    var ParRef=BedFee_WinForm.getForm().findField('BEDIBEDParRef').getValue()
                                    BedFee_WinForm.getForm().findField('BEDIBEDChildsub').setValue(BEDChildsub);
                                    var BEDChildsub=BedFee_WinForm.getForm().findField('BEDIBEDChildsub').getValue()
                                },
                                scope : this
                            }), '-',
                new Ext.Button({text : '修改',tooltip : '修改',iconCls : 'icon-update',id:'BedFee_update_btn',
                                disabled:Ext.BDP.FunLib.Component.DisableFlag('BedFee_update_btn'),
                                handler : function BedFee_UpdateData() {
                                    if (BedFeegrid.selModel.hasSelection()) {
                                        win_BedFee.setTitle('修改');
                                        win_BedFee.setIconClass('icon-update');
                                        
                                        var record = BedFeegrid.getSelectionModel().getSelected(); 
                                        BedFee_WinForm.getForm().reset();
                                        win_BedFee.show();
                                        BedFee_loadFormData(BedFeegrid);
                                    } else {
                                        Ext.Msg.show({
                                                title : '提示',
                                                msg : '请选择需要修改的行！',
                                                icon : Ext.Msg.WARNING,
                                                buttons : Ext.Msg.OK
                                        });
                                    }
                                }
                    }), '-', BedFee_btnDel //]
                    ,'->',btnlogsub,'-',btnhislogsub] 
    });
    // 进入床位附加费用按钮	2020		钟荣枫
    var btn_BedFee = new Ext.Toolbar.Button({
                text : '费用设置',
                tooltip : '费用设置',
                iconCls : 'icon-DP',
                id:'BedFee_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('bedfeebtn'),
                handler : function() {
                    if (PACBedgrid.selModel.hasSelection()) {
                        var gsm = PACBedgrid.getSelectionModel();//获取选择列
           				var rows = gsm.getSelections();//根据选择列获取到所有的行 
						
						if(rows.length!=1){
							Ext.Msg.show({
                                    title : '提示',
                                    msg : '请选择要查看床位的一行数据！',
                                    icon : Ext.Msg.WARNING,
                                    buttons : Ext.Msg.OK
                                });
							return
						}
						
                        var str=rows[0].get('BEDRowID').split('||');
                        var ParRef=str[0];
                        var BedChildsub=str[1];
           				//CTLOCRowID
                        win_BedFeeList.setTitle(rows[0].get('BEDCode')+"-费用设置")
                        BedFeegrid.getStore().baseParams={ ParRef: ParRef, BedChildsub: BedChildsub, hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()}
                         
                        
                        BedFeegrid.getStore().load({ params : { start : 0, limit : pagesize_PACBed } });
                        win_BedFeeList.show();
                    } else {
                        Ext.Msg.show({
                                    title : '提示',
                                    msg : '请选择要查看床位的一行数据！',
                                    icon : Ext.Msg.WARNING,
                                    buttons : Ext.Msg.OK
                                });
                    }

                }
            });
    // 床位费用增加、修改窗口		2020-1-16
    var win_BedFee = new Ext.Window({
        width : 400,
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
        items : BedFee_WinForm,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'BedFee_save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('BedFee_save_btn'),
            handler : function() {
            var FeeType = Ext.getCmp("BedFee_form-save").getForm().findField("BEDIIFeeType").getValue();
            var ARCIMDR = Ext.getCmp("BedFee_form-save").getForm().findField("BEDIARCIMDR").getValue();
            var BEDIStartDate=Ext.getCmp("BedFee_form-save").getForm().findField("BEDIStartDate").getValue();
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
                                    Ext.getCmp("BedFee_form-save").getForm().findField("BEDIIFeeType").focus();
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
                                    Ext.getCmp("BedFee_form-save").getForm().findField("BEDIARCIMDR").focus();
                                }
                             });
                             return
                    } 
            if (BEDIStartDate=="") {
                Ext.Msg.show({ 
                                title : '<font color=blue>提示</font>',
                                msg : '开始日期不能为空!', 
                                minWidth : 200,
                                animEl: 'form-save',
                                icon : Ext.Msg.ERROR,
                                buttons : Ext.Msg.OK ,
                                fn:function()
                                {
                                    Ext.getCmp("BedFee_form-save").getForm().findField("BEDIStartDate").focus();
                                }
                             });
                             return
                    }               
        if(BedFee_WinForm.getForm().isValid()==false){
            Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
            return;
         } 
        if (win_BedFee.title == '添加') {
                    BedFee_WinForm.form.submit({
                        clientValidation : true, // 进行客户端验证
                        url : BedFee_SAVE_ACTION_URL,
                        method : 'POST',
                        success : function BedFee_AddData(form, action) {
                            if (action.result.success == 'true') {
                                win_BedFee.hide();
                                var myrowid = action.result.id;
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                var startIndex = BedFeegrid.getBottomToolbar().cursor;
                                                BedFeegrid.getStore().load({
                                                            params : {
                                                                start : 0,
                                                                limit : limit,
																hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue(),
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
                            BedFee_WinForm.form.submit({
                                clientValidation : true, // 进行客户端验证
                                waitMsg : '正在提交数据请稍后',
                                waitTitle : '提示',
                                url : BedFee_SAVE_ACTION_URL,
                                method : 'POST',
                                success : function(form, action) {
                                    if (action.result.success == 'true') {
                                        win_BedFee.hide();
                                        var myrowid = 'rowid='+action.result.id;
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '修改成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                            Ext.BDP.FunLib.ReturnDataForUpdate('BedFeegrid',BedFee_ACTION_URL,myrowid);
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
                win_BedFee.hide();
                Ext.getCmp("BedFee_form-save").getForm().reset();
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
	
	// 床位附加费用维护窗口   	2020
    var win_BedFeeList = new Ext.Window({
        title : '费用设置',
        width : 900,
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
        items : [BedFeegrid],
        listeners : {
                        "show" : function(){
                            Ext.getCmp("TextArcim").reset();
                            Ext.getCmp("TextFeeType").reset();
                            if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
                            {
                                keymap_main.disable();
                                keymap_pop = Ext.BDP.FunLib.Component.KeyMap(BedFee_AddData,BedFee_UpdateData,BedFee_DelData);
                            }                           
                        },
                        "hide" : function(){
                            BedFee_ds.removeAll();
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
    //-----------------------------------------------------------------------2020-2-6 钟荣枫
    
    //-----------------------批量添加、修改床位(以下)-------------------------2014-3-5 by lisen
    //批量修改床位类型window
    var win_batchUpBed = new Ext.Window({
					    	title : '批量修改床位类型',
					    	width : 300,
							layout : 'fit',
							height:150,
							iconCls:'icon-update',
							plain : true,//true则主体背景透明
							modal : true,
							frame : true,
							autoScroll : true,
							collapsible : true,
							constrain : true,
							hideCollapseTool : true,
							titleCollapse : true,
							buttonAlign : 'center',
							closeAction : 'hide',
							items : [{
								xtype:'form',
								labelAlign : 'right',
								labelWidth : 60,
								baseCls : 'x-plain',
								items : [{
									xtype : 'bdpcombo',
									loadByIdParam : 'rowid',
									pageSize : Ext.BDP.FunLib.PageSize.Combo,
									width : 190,
									fieldLabel : '床类型',
									id:'comb_batchUpBedType',
		   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('comb_batchUpBedType'),
									style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('comb_batchUpBedType')),
									allowBlank : false,
									store : new Ext.data.Store({
										//autoLoad : true,
										proxy : new Ext.data.HttpProxy({ url : BedType_ACTION_URL }),
										reader : new Ext.data.JsonReader({
													totalProperty : 'total',
													root : 'data',
													successProperty : 'success'
												}, [ 'BEDTPRowId', 'BEDTPDesc' ])
									}),
									mode : 'remote',
									queryParam : 'desc',
									//triggerAction : 'all',
									forceSelection : true,
									selectOnFocus : false,//true表示获取焦点时选中既有值
									//typeAhead : true,
									//minChars : 1,
									valueField : 'BEDTPRowId',
									displayField : 'BEDTPDesc',
									listeners:{
										   'beforequery': function(e){
												this.store.baseParams = {
													desc:e.query,
													hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
												};
												this.store.load({params : {
															start : 0,
															limit : Ext.BDP.FunLib.PageSize.Combo
												}})
										
											}
									}
								}]
							}],
							buttons : [{
								text : '保存',
								id:'save_btn_batchUpBed',
								iconCls : 'icon-save',
					   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_batchUpBed'),
								handler : function() {
									var tempBedType = Ext.getCmp("comb_batchUpBedType").getValue();
									if(tempBedType==""){
										Ext.Msg.show({ title : '提示', msg : '床类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          								return;
									}else{
										var _record = PACBedgrid.getSelectionModel().getSelections();
										var str="";
										for(var i=0;i<_record.length;i++){
											str+=_record[i].get('BEDRowID') + "^";
										}
										if (str!=="") {
											str=tempBedType + '#' + str;
											Ext.Ajax.request({
												url : batchUpBed_ACTION_URL,
												method : 'POST',
												params : {
													'str' : str
												},
												callback : function(options, success, response) {
													if (success) {
														var jsonData = Ext.util.JSON.decode(response.responseText);
														if (jsonData.success == 'true') {
															win_batchUpBed.hide();
															Ext.Msg.show({
																title : '提示',
																msg : '数据保存成功!',
																icon : Ext.Msg.INFO,
																buttons : Ext.Msg.OK,
																fn : function(btn) {
																	PACBedds.reload();
																}
															});
														}else {
															var errorMsg = '';
															if (jsonData.errorinfo) {
																errorMsg = '<br/>错误信息:' + jsonData.errorinfo
															}
															Ext.Msg.show({
																title : '提示',
																msg : '数据保存失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
														}
													}else {
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
									}
								}
							}, {
								text : '关闭',
								iconCls : 'icon-close',
								handler : function() {
									win_batchUpBed.hide();
								}
							}],
							listeners : {
								"show" : function() {
									Ext.getCmp("comb_batchUpBedType").focus(false,800);
								},
								"hide" : function() {
									Ext.getCmp("comb_batchUpBedType").reset();
								},
								"close" : function() {}
							}
					  })
    
	//批量添加床位frompanel
	var form_batchAddBed = new Ext.form.FormPanel({
							    id: 'form_batchAddBed',
							    columnWidth: '.4',
								frame : true,
								waitMsgTarget : true,
						        baseCls : 'x-plain',//form透明,不显示框框
						        defaults: { anchor : '100%', bosrder: false },
						        defaultType: 'textfield',
						        reader: new Ext.data.JsonReader({root:'list'},
						            [{name: 'batchBEDBedTypeDR',mapping:'BEDBedTypeDR',type:'string'},
						             {name: 'batchBEDRoomDR',mapping:'BEDRoomDR',type:'string'},
						             {name: 'batchBEDRcFlag',mapping:'BEDRcFlag',type:'string'},
						             {name: 'batchBEDDateFrom',mapping:'BEDDateFrom',type:'string'},
						             {name: 'batchBEDDateTo',mapping:'BEDDateTo',type:'string'},
						             {name: 'batchBEDHeight',mapping:'BEDHeight',type:'string'},
						             {name: 'batchBEDWidth',mapping:'BEDWidth',type:'string'},
						             {name: 'batchBEDX',mapping:'BEDX',type:'string'},
						             {name: 'batchBEDY',mapping:'BEDY',type:'string'},
						             {name: 'batchBEDNumber',mapping:'BEDNumber',type:'string'},
						             {name: 'batchBEDYGap',mapping:'BEDYGap',type:'string'},
						             {name: 'batchBEDXGap',mapping:'BEDXGap',type:'string'},
						             {name: 'batchBEDDigits',mapping:'BEDDigits',type:'string'},	//床代码位数
						             {name: 'batchBEDSuffix',mapping:'BEDSuffix',type:'string'}		//床代码后缀
						        ]),
						        items : [{
									xtype: 'fieldset',
									labelWidth:80,		
									labelAlign:'right',
									bodyStyle:'padding-top:10px;padding-right:10px;',
									autoHeight: true,
									//defaults: { anchor : '95%', bosrder: false },
									defaultType:'textfield',
									items:[{
						                fieldLabel: '<font color=red>*</font>床类型',
						                name: 'batchBEDBedTypeDR',
						                id:'batchBEDBedTypeDRF',
						   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('batchBEDBedTypeDRF'),
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDBedTypeDRF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDBedTypeDRF')),
						   				xtype:'bdpcombo',
										loadByIdParam : 'rowid',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
						   				hiddenName : 'BEDBedTypeDR',
										mode : 'remote',
										store : new Ext.data.Store({
													//autoLoad : true,
													proxy : new Ext.data.HttpProxy({ url : BedType_ACTION_URL }),
													reader : new Ext.data.JsonReader({
																totalProperty : 'total',
																root : 'data',
																successProperty : 'success'
															}, [ 'BEDTPRowId', 'BEDTPDesc' ])
												}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										listWidth : 270,
										valueField : 'BEDTPRowId',
										displayField : 'BEDTPDesc',
										allowBlank : false,
										listeners:{
											   'beforequery': function(e){
													this.store.baseParams = {
														desc:e.query,
														hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
													};
													this.store.load({params : {
																start : 0,
																limit : Ext.BDP.FunLib.PageSize.Combo
													}})
											
												}
										}
						            },{
						                fieldLabel: '<font color=red>*</font>房间',
						                name: 'batchBEDRoomDR',
						                id:'batchBEDRoomDRF',
						   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('batchBEDRoomDRF'),
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDRoomDRF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDRoomDRF')),
						   				xtype:'bdpcombo',
										loadByIdParam : 'rowid',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
						   				hiddenName : 'BEDRoomDR',
										mode : 'remote',
										store : new Ext.data.Store({
													//autoLoad : true,
													proxy : new Ext.data.HttpProxy({ url : Room_ACTION_URL }),
													reader : new Ext.data.JsonReader({
																totalProperty : 'total',
																root : 'data',
																successProperty : 'success'
															}, [ 'ROOMRowID', 'ROOMDesc' ])
												}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										listWidth : 270,
										valueField : 'ROOMRowID',
										displayField : 'ROOMDesc',
										allowBlank : false,
										listeners:{
											   'beforequery': function(e){
													this.store.baseParams = {
														desc:e.query,
														hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
													};
													this.store.load({params : {
																start : 0,
																limit : Ext.BDP.FunLib.PageSize.Combo
													}})
											
												}
										}
						            },{
						             	xtype : 'checkbox',
						                fieldLabel: '激活',
						                name: 'batchBEDRcFlag',
						                id:'batchBEDRcFlagF',
						   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('batchBEDRcFlagF'),
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDRcFlagF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDRcFlagF')),
						   				inputValue : 'Y',
						   				checked:true
						   		 	},{
						                xtype: 'datefield',
						                fieldLabel: '<font color=red>*</font>开始日期',
						                name: 'batchBEDDateFrom',
						                id:'batchBEDDateFromF',
						   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('batchBEDDateFromF'),
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDDateFromF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDDateFromF')),
										format : BDPDateFormat,
										enableKeyEvents : true,
										listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }},
										allowBlank : false
						            },{
						                xtype:'datefield',
						                fieldLabel: '结束日期',
						                name: 'batchBEDDateTo',
						                id:'batchBEDDateToF',
						   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('batchBEDDateToF'),
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDDateToF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDDateToF')),
										format : BDPDateFormat,
										enableKeyEvents : true,
										listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
									}]
								},{
									xtype: 'fieldset',
									labelWidth:100,		
									labelAlign:'right',
									bodyStyle:'padding-top:10px;padding-right:10px;',
									autoHeight: true,
									//defaults: { anchor : '95%', bosrder: false },
									defaultType:'textfield',
									items:[{
						                fieldLabel: '<font color=red>*</font>床代码位数',
						                xtype : 'numberfield',
						                name: 'batchBEDDigits',
						                minValue : 2,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDDigitsF',
						                readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDDigitsF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDDigitsF')),
						   				disabled : true,
										value : 3,
										allowBlank : false
						           }, {
										xtype: 'textfield',
										fieldLabel: "床代码后缀",
										name: 'batchBEDSuffix',
										id:'batchBEDSuffixF',
										style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDSuffixF')),	
										readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDSuffixF'),
										disabled : true
								   }, {
						                fieldLabel: '<font color=red>*</font>添加床位个数',
						                xtype : 'numberfield',
						                name: 'batchBEDCount',
						                minValue : 1,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDCountF',
						                readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDCountF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDCountF')),
						   				disabled : true,
										value : 30,
										allowBlank : false
						           }, {
						                fieldLabel: '<font color=red>*</font>每行床位个数',
						                xtype : 'numberfield',
						                name: 'batchBEDNumber',
						                minValue : 1,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDNumberF',
						                readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDNumberF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDNumberF')),
						   				disabled : true,
										value : 5,
										allowBlank : false
						           }, {
						                fieldLabel: '<font color=red>*</font>床宽度(cm)', 
						                xtype : 'numberfield',
						                name: 'batchBEDWidth',
						                minValue : 1,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDWidthF',
						   				disabled : true,
										value : 160,
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDWidthF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDWidthF')),
										allowBlank : false,
										enableKeyEvents : true,
										listeners : {
			            			        'keyup' : function(field, e){
			            			        	var newValue = field.getValue();
			            			        	document.getElementById("PreviewBed").style.width = newValue + 'px';
			            			        }
									    }
						            },{
						                fieldLabel: '<font color=red>*</font>床高度(cm)', 
						                xtype : 'numberfield',
						                name: 'batchBEDHeight',
						                minValue : 1,
						                //maxValue : 400,// 最大值400
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDHeightF',
						                readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDHeightF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDHeightF')),
						   				disabled : true,
										value : 120,
										allowBlank : false,
										enableKeyEvents : true,
										listeners : {
			            			        'keyup' : function(field, e){
			            			        	var newValue = field.getValue();
			            			        	document.getElementById("PreviewBed").style.height = newValue + 'px';
			            			        }
									    }
									}, {
						                fieldLabel: '<font color=red>*</font>起始坐标X(cm)',
						                xtype : 'numberfield',
						                name: 'batchBEDX',
						                minValue : 0,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDXF',
						   				disabled : true,
										value : 5,
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDXF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDXF')),
										allowBlank : false,
										enableKeyEvents : true,
										listeners : {
			            			        'keyup' : function(field, e){
			            			        	var newValue = field.getValue();
			            			        	document.getElementById("PreviewBed").style.left = newValue + 'px';
			            			        }
									    }
									 }, {
						                fieldLabel: '<font color=red>*</font>起始坐标Y(cm)',
						                xtype : 'numberfield',
						                name: 'batchBEDY',
						                minValue : 0,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
						                id:'batchBEDYF',
						   				disabled : true,
										value : 5,
						   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDYF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDYF')),
										allowBlank : false,
										enableKeyEvents : true,
										listeners : {
			            			        'keyup' : function(field, e){
			            			        	var newValue = field.getValue();
			            			        	document.getElementById("PreviewBed").style.top = newValue + 'px';
			            			        }
									    }
						            }, {
										fieldLabel : '<font color=red>*</font>行间距(cm)', //BEDYGap行间距,BEDXGap列间距
										xtype : 'numberfield',
										name : 'batchBEDYGap',
										id : 'batchBEDYGapF',
										disabled : true,
										value : 5,
										readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDYGapF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDYGapF')),
										minValue : 0,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数
										allowBlank : false
									}, {
										fieldLabel : '<font color=red>*</font>列间距(cm)',
										xtype : 'numberfield',
										id : 'batchBEDXGapF',
										name : 'batchBEDXGap',
										disabled : true,
										value : 5,
										readOnly : Ext.BDP.FunLib.Component.DisableFlag('batchBEDXGapF'),
										style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('batchBEDXGapF')),
										minValue : 0,
										allowNegative : false,// 不允许输入负数
										allowDecimals : false,// 不允许输入小数  
										allowBlank : false
									}, {
										xtype:'checkbox',
										fieldLabel:'自定义',
										listeners:{
											'check':function(com, checked){
												if(checked){
													Ext.getCmp('batchBEDCountF').enable();
													Ext.getCmp('batchBEDNumberF').enable();
													Ext.getCmp('batchBEDWidthF').enable();
													Ext.getCmp('batchBEDHeightF').enable();
													Ext.getCmp('batchBEDXF').enable();
													Ext.getCmp('batchBEDYF').enable();
													Ext.getCmp('batchBEDYGapF').enable();
													Ext.getCmp('batchBEDXGapF').enable();
													Ext.getCmp('batchBEDDigitsF').enable();
													Ext.getCmp('batchBEDSuffixF').enable();
												}else{
													Ext.getCmp('batchBEDCountF').disable();
													Ext.getCmp('batchBEDNumberF').disable();
													Ext.getCmp('batchBEDWidthF').disable();
													Ext.getCmp('batchBEDHeightF').disable();
													Ext.getCmp('batchBEDXF').disable();
													Ext.getCmp('batchBEDYF').disable();
													Ext.getCmp('batchBEDYGapF').disable();
													Ext.getCmp('batchBEDXGapF').disable();
													Ext.getCmp('batchBEDDigitsF').disable();
													Ext.getCmp('batchBEDSuffixF').disable();
												}
											}
										},
										id:'batchBEDCustom'
									}]
								}]
							})
					  
	//批量添加床位window
    var win_batchAddBed = new Ext.Window({
					    	title : '批量添加床位',
					    	width : 830,
					    	height: 650,
							layout:'column',
							split : true,
							iconCls:'icon-add',
							plain : true,//true则主体背景透明
							modal : true,
							frame : true,
							autoScroll : true,
							collapsible : true,
							constrain : true,
							hideCollapseTool : true,
							titleCollapse : true,
							buttonAlign : 'center',
							closeAction : 'hide',
							items : [form_batchAddBed,new Ext.Panel({
									title:'单个床位预览',
									columnWidth: '.6',
									layout:'fit',
									height:500,
									html:"<div id='PreviewDiv' style='background:url(../scripts/bdp/App/Locations/BedMap/grid.png);overflow:auto;width:100%;height:100%;'></div>",
									listeners:{
										'afterrender':function(com){
											var PW = Ext.getCmp('batchBEDWidthF').getValue();
											var PH = Ext.getCmp('batchBEDHeightF').getValue();
											var PLeft = Ext.getCmp('batchBEDXF').getValue();
											var PTop = Ext.getCmp('batchBEDYF').getValue();
											var BedDiv = document.createElement("div");
											BedDiv.id = 'PreviewBed';
											BedDiv.style.position = 'absolute';
											BedDiv.style.top = PTop+'px';
											BedDiv.style.left = PLeft+'px';
											BedDiv.style.width = PW+'px';
											BedDiv.style.height = PH+'px';
											BedDiv.style.borderStyle = 'solid';
											BedDiv.style.borderWidth = '1px';
											BedDiv.style.borderColor = '#6D739A';
											BedDiv.style.background = '#CCD9E8';
											BedDiv.innerHTML = '房间->床位代码';
											document.getElementById('PreviewDiv').appendChild(BedDiv);
										}
									}
								})],
							buttons : [{
								text : '保存',
								iconCls : 'icon-save',
								id:'save_btn_batchAddBed',
					   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_batchAddBed'),
								handler : function() {
									var tempBedType = Ext.getCmp("batchBEDBedTypeDRF").getValue();
									var tempRoomDR = Ext.getCmp("batchBEDRoomDRF").getValue();
									var tempDateFrom = Ext.getCmp("batchBEDDateFromF").getValue();
									if(tempBedType==""){
										Ext.Msg.show({ title : '提示', msg : '床类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          								return;
									}
									if(tempRoomDR==""){
										Ext.Msg.show({ title : '提示', msg : '房间不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          								return;
									}
									if(tempDateFrom==""){
										Ext.Msg.show({ title : '提示', msg : '开始日期不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          								return;
									}
									//如果选中自定义
									if(Ext.getCmp('batchBEDCustom').getValue()){
										var tempBEDCount = Ext.getCmp("batchBEDCountF").getValue();
										var tempBEDNumber = Ext.getCmp("batchBEDNumberF").getValue();
										var tempBEDWidth = Ext.getCmp("batchBEDWidthF").getValue();
										var tempBEDHeight = Ext.getCmp("batchBEDHeightF").getValue();
										var tempBEDX = Ext.getCmp("batchBEDXF").getValue();
										var tempBEDY = Ext.getCmp("batchBEDYF").getValue();
										var tempBEDYGap = Ext.getCmp("batchBEDYGapF").getValue();
										var tempBEDXGap = Ext.getCmp("batchBEDXGapF").getValue();
										if(tempBEDCount==""){
											Ext.Msg.show({ title : '提示', msg : '添加床位个数不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDNumber==""){
											Ext.Msg.show({ title : '提示', msg : '每行床位个数不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDWidth==""){
											Ext.Msg.show({ title : '提示', msg : '床宽度不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDHeight==""){
											Ext.Msg.show({ title : '提示', msg : '床高度不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDX==""){
											Ext.Msg.show({ title : '提示', msg : '起始坐标X不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDY==""){
											Ext.Msg.show({ title : '提示', msg : '起始坐标Y不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDYGap==""){
											Ext.Msg.show({ title : '提示', msg : '行间距不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
										if(tempBEDXGap==""){
											Ext.Msg.show({ title : '提示', msg : '列间距不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
	          								return;
										}
									}
									if(form_batchAddBed.form.isValid()==false){
										return;
									}else{
										if(Ext.getCmp("batchBEDDateFromF").getValue()){
											var fromDate = Ext.getCmp("batchBEDDateFromF").getValue().format("Y/m/d");
										}else{
											var fromDate = "";
										}
										if(Ext.getCmp("batchBEDDateToF").getValue()){
											var toDate = Ext.getCmp("batchBEDDateToF").getValue().format("Y/m/d");
										}else{
											var toDate = "";
										}
										var str = Ext.getCmp('hidden_ref').getValue() + '^'
												+ Ext.getCmp("batchBEDBedTypeDRF").getValue() + '^'
												+ Ext.getCmp("batchBEDRoomDRF").getValue() + '^'
												+ Ext.getCmp("batchBEDRcFlagF").getValue() + '^'
												+ Ext.getCmp("batchBEDDateFromF").getRawValue() + '^'
												+ Ext.getCmp("batchBEDDateToF").getRawValue() + '^'
												+ Ext.getCmp("batchBEDCountF").getValue() + '^'
												+ Ext.getCmp("batchBEDNumberF").getValue() + '^'
												+ Ext.getCmp("batchBEDWidthF").getValue() + '^'
												+ Ext.getCmp("batchBEDHeightF").getValue() + '^'
												+ Ext.getCmp("batchBEDXF").getValue() + '^'
												+ Ext.getCmp("batchBEDYF").getValue() + '^'
												+ Ext.getCmp("batchBEDYGapF").getValue() + '^'
												+ Ext.getCmp("batchBEDXGapF").getValue() + '^'
												+ Ext.getCmp("batchBEDDigitsF").getValue() + '^'
												+ Ext.getCmp("batchBEDSuffixF").getValue();
										if (str!=="") {
											Ext.Ajax.request({
												url : batchAddBed_ACTION_URL,
												method : 'POST',
												params : {
													'str' : str
												},
												callback : function(options, success, response) {
													if (success) {
														var jsonData = Ext.util.JSON.decode(response.responseText);
														if (jsonData.success == 'true') {
															win_batchAddBed.hide();
															Ext.Msg.show({
																title : '提示',
																msg : '数据保存成功!',
																icon : Ext.Msg.INFO,
																buttons : Ext.Msg.OK,
																fn : function(btn) {
																	PACBedds.reload();
																}
															});
														}else {
															var errorMsg = '';
															if (jsonData.errorinfo) {
																errorMsg = '<br/>错误信息:' + jsonData.errorinfo
															}
															Ext.Msg.show({
																title : '提示',
																msg : '数据保存失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
														}
													}else {
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
									}
								}
							}, {
								text : '关闭',
								iconCls : 'icon-close',
								handler : function() {
									win_batchAddBed.hide();
								}
							}],
							listeners : {
								"show" : function() {
									Ext.getCmp("batchBEDBedTypeDRF").focus(false,800);
								},
								"hide" : function() {
								},
								"close" : function() {}
							}
    				})
	
	//批量修改床位类型
    var btn_batchUpBed = new Ext.Button({
    	id:'btn_batchUpBed',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_batchUpBed'),
        iconCls:'icon-update',
        text:'批量修改床位类型',
        handler:function(){
        	var gsm = PACBedgrid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            if(rows.length==0){
            	Ext.Msg.show({
					title:'提示',
					msg:'请选择一行或多行后修改!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
            }else{
            	win_batchUpBed.show();
            }
        }
    })
    
    //批量添加床位
    var btn_batchAddBed = new Ext.Button({
    	id:'btn_batchAddBed',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_batchAddBed'),
        iconCls:'icon-add',
        text:'批量添加床位',
        handler:function(){
        	var parentid = Ext.getCmp('hidden_ref').getValue();
        	if(parentid=="") {
        		Ext.Msg.show({
					title:'提示',
					msg:'parentid为空,不能添加!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
				return;
        	}
        	var rtn = tkMakeServerCall("web.DHCBL.CT.PACBed","IfBedExist",parentid);
        	if(rtn=="yes"){
        		win_batchAddBed.show();
	        	form_batchAddBed.getForm().reset();
        	}else if(rtn=="no"){
	        	Ext.Msg.show({
					title:'提示',
					msg:'数据库非空,禁止批量添加!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
        	}
        }
    })
    //-----------------------批量添加、修改床位(以上)-------------------------2014-3-5 by lisen
    ///ofy2 床管医生
	/*var MANDOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedManageDoc&pClassQuery=GetList";
	var MANDOC_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACBedManageDoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACBedManageDoc";	
	var MANDOC_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBedManageDoc&pClassMethod=DeleteData";
	var MANDOC_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBedManageDoc&pClassMethod=OpenData";
	var MANDOC_CTPCP_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedManageDoc&pClassQuery=GetDataForCmb3";
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
 	//---------------------子表：床管医生-------------------------
	// 删除功能
	var MANDOCbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'MANDOCbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('MANDOCbtnDel'),
		handler : function() {
			if (gridPACBedManageDoc.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = gridPACBedManageDoc.getSelectionModel();
						var rows = gsm.getSelections();
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : MANDOC_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('MANDOCRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										// var myrowid = action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(gridPACBedManageDoc,pagesize1)
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
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
												msg : '异步通讯失败,请检查网络连接！',
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
	var CareProvDRds=new Ext.data.Store({
				//autoLoad : true,
				proxy : new Ext.data.HttpProxy({
							url : MANDOC_CTPCP_DR_QUERY_ACTION_URL
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RESCTPCPDR',
									mapping : 'RESCTPCPDR'
								}, {
									name : 'CTPCPDesc',
									mapping : 'CTPCPDesc'
								}])
			})
	
	// 增加修改的Form
	var MANDOCWinForm = new Ext.FormPanel({
		id : 'MANDOC-form-save',
		URL : MANDOC_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'MANDOCParRef',
							mapping : 'MANDOCParRef'
						}, {
							name : 'MANDOCCareProvDR',
							mapping : 'MANDOCCareProvDR'
						}, {
							name : 'MANDOCRowId',
							mapping : 'MANDOCRowId'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'MANDOCRowId',
					xtype : 'textfield',
					fieldLabel : 'MANDOCRowId',
					name : 'MANDOCRowId',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'MANDOCParRef',
					xtype : 'textfield',
					fieldLabel : 'MANDOCParRef',
					name : 'MANDOCParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					xtype : "bdpcombo",
					fieldLabel : '<font color=red>*</font>床管医生',
					allowBlank:false,
					queryParam : 'desc',
					loadByIdParam : 'rowid',
					id: 'MANDOCCareProvDR1',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MANDOCCareProvDR1'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MANDOCCareProvDR1')),
					hiddenName : 'MANDOCCareProvDR',
					listWidth : 300,
					store : CareProvDRds,
					mode : 'local',
					shadow : false,
					forceSelection : true,
					displayField : 'CTPCPDesc',
					valueField : 'RESCTPCPDR'
				}]
	});

	// 增加修改时弹出窗口
	var MANDOCwin = new Ext.Window({
		title : '',
		width : 460,
		height : 180,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : MANDOCWinForm,
		buttons : [{
			text : '保存',
			id : 'MANDOC_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('MANDOC_savebtn'),
			handler : function() {
				// -------添加----------
				if (MANDOCwin.title == "添加") {
					var gsm = PACBedgrid.getSelectionModel();//获取选择列
		            var rows = gsm.getSelections();//根据选择列获取到所有的行 
		            MANDOCWinForm.form.submit({
						url : MANDOC_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'MANDOCParRef' : rows[0].get('BEDRowID')
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								MANDOCwin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridPACBedManageDoc.getBottomToolbar().cursor;
												
												gridPACBedManageDoc.getStore().load({
															params : {
																start : 0,
																limit : pagesize1
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
				}
				// ---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							MANDOCWinForm.form.submit({
								url : MANDOC_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										MANDOCwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("gridPACBedManageDoc",MANDOC_QUERY_ACTION_URL,myrowid);
												
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'
													+ action.result.errorinfo
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
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
						}
					}, this);
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				MANDOCwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				MANDOCWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var MANDOCbtnAddwin = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'MANDOCbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('MANDOCbtnAdd'),
		handler : function() {
			CareProvDRds.baseParams={
					LOCDR :Ext.getCmp("CTLOCRowID_HIDDEN").getValue()
			};
			MANDOCwin.setTitle('添加');
			MANDOCwin.setIconClass('icon-add');
			MANDOCwin.show();
			MANDOCWinForm.getForm().reset();
			
					
		},
		scope : this
	});

	// 修改按钮
	var MANDOCbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'MANDOCbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnUpdate'),
				handler : function() {
					if (gridPACBedManageDoc.selModel.hasSelection()) {
						loadMANDOCFormData(gridPACBedManageDoc);
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
		// 刷新工作条
	var MANDOCbtnRefresh = new Ext.Button({
				id : 'MANDOCbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('MANDOCbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					var gsm = PACBedgrid.getSelectionModel();//获取选择列
		            var rows = gsm.getSelections();//根据选择列获取到所有的行 
		            gridPACBedManageDoc.getStore().baseParams={
								parref :rows[0].get('BEDRowID')
					};
					gridPACBedManageDoc.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	var MANDOCds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : MANDOC_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'MANDOCRowId',
								mapping : 'MANDOCRowId',
								type : 'string'
							}, {
								name : 'MANDOCCareProvDR',
								mapping : 'MANDOCCareProvDR',
								type : 'string'
							}, {
								name : 'MANDOCParRef',
								mapping : 'MANDOCParRef',
								type : 'string'
							}])
			
		});
	
	// 加载数据
	linkds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records,options, success) {
				}
			});

	// 分页工具条
	var MANDOCpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : MANDOCds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize1 = this.pageSize;
				         }
		        }
			});

	var MANDOCsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var MANDOCtbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [MANDOCbtnAddwin, '-', MANDOCbtnEditwin, '-',
						MANDOCbtnDel, '-',MANDOCbtnRefresh]
			});

	// 创建Grid
	var gridPACBedManageDoc = new Ext.grid.GridPanel({
				//title : '手术关联医嘱项',
				id : 'gridPACBedManageDoc',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : MANDOCds,
				trackMouseOver : true,
				columns : [MANDOCsm, {
							header : 'MANDOCRowId',
							width : 70,
							sortable : true,
							dataIndex : 'MANDOCRowId',
							hidden : true
						}, {
							header : 'MANDOCParRef', //MANDOCParRef
							width : 80,
							sortable : true,
							dataIndex : 'MANDOCParRef',
							hidden : true
						}, {
							header : '床管医生',
							width : 180,
							sortable : true,
							dataIndex : 'MANDOCCareProvDR'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : MANDOCpaging,
				tbar : MANDOCtbbutton,
				stateId : 'gridPACBedManageDoc'
			});
	
	// 载入被选择的数据行的表单数据
	var loadMANDOCFormData = function(gridPACBedManageDoc) {
		CareProvDRds.baseParams={
			LOCDR :Ext.getCmp("CTLOCRowID_HIDDEN").getValue()
		};
		MANDOCwin.setTitle('修改');
		MANDOCwin.setIconClass('icon-update');
		MANDOCwin.show();
		var _record = gridPACBedManageDoc.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			MANDOCWinForm.form.load({
						url : MANDOC_OPEN_ACTION_URL + '&id='+ _record.get('MANDOCRowId'),
						// waitMsg : '正在载入数据...',
						success : function(form, action) {
							// Ext.Msg.alert('编辑','载入成功！');
						},
						failure : function(form, action) {
							Ext.Msg.alert('编辑', '载入失败！');
						}
					});
		}
	};

	gridPACBedManageDoc.on("rowdblclick", function(grid, rowIndex, e) {
				
				loadMANDOCFormData(grid);
			});

			
	var btnPACBedManageDoc = new Ext.Toolbar.Button({
	    text: '床管医生',
	    id:'btnPACBedManageDoc',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPACBedManageDoc'),
        iconCls: 'icon-LinkLoc',
		tooltip: '床管医生',
        handler: function() {   
	    	var _record = PACBedgrid.getSelectionModel().getSelected();
	        if(_record){
	        	var winPACBedManageDoc = new Ext.Window({
					title:'床管医生',
					width:700,
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
					items: gridPACBedManageDoc,
					listeners:{
						"show":function(){
						},
						"hide":function(){
						},
						"close":function(){
						}
					}
				});
				winPACBedManageDoc.show('');
				var gsm = PACBedgrid.getSelectionModel();//获取选择列
	            var rows = gsm.getSelections();//根据选择列获取到所有的行 
	            var CTLOCRowID=rows[0].get('BEDRowID');
	            gridPACBedManageDoc.getStore().baseParams={parref:CTLOCRowID};
	           	gridPACBedManageDoc.getStore().load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});
	        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请先选择床位!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	*/
	//ofy2  end
	
	
	//增删改工具条			2020	钟荣枫
    var PACBedtbbutton=new Ext.Toolbar(
		{
			enableOverflow: true,			
			items:[PACBedbtnAddwin, '-', PACBedbtnEditwin, '-', PACBedbtnDel
			, '-', btn_batchAddBed, '-', btn_batchUpBed, '-',btn_BedFee
			//,'-',btnPACBedManageDoc  //OFY2
			]//,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		}
	)
    //搜索工具条
	var PACBedbtnSearch=new Ext.Button({
        id:'pacbed_search_btn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbed_search_btn'),
        iconCls:'icon-search',
        text:'搜索',
        handler:function(){
						
			/*
			
			Ext.getCmp("CTLOCRowID_HIDDEN").setValue(CTLOCRowID);
       		var WardRoomParRef = tkMakeServerCall("web.DHCBL.CT.PACWardRoom","GetWardRoomParRef",CTLOCRowID);
	        Ext.getCmp("hidden_ref").reset();
           	Ext.getCmp("hidden_ref").setValue(WARDParRef);
	        PACWardRoom_ds.baseParams={ROOMParRef:WardRoomParRef}
	        PACWardRoom_ds.load({params:{start:0, limit:12}});
	           	
        	PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
			STds.setBaseParam('ssgrprowid', grid.getSelectionModel().getSelected().get('SSGRPRowId')); 
			 * 
			 */
			PACBedds.baseParams={
						bedcode:Ext.getCmp("TextBedCode").getValue(),
						room:Ext.getCmp("TextBedRoomDR").getValue(),
						bedrcflag:Ext.getCmp("TextBedRcFlag").getValue(),
						ParRef:Ext.getCmp("hidden_ref").getValue()
			};
			
			PACBedds.load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize_PACBed	
									
								}
							});	
			
			
        }
    });
	//刷新工作条
	var PACBedbtnRefresh=new Ext.Button({
        id:'pacbed_refresh_btn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbed_refresh_btn'),
        iconCls:'icon-refresh',
        text:'重置',
        handler:function(){
		Ext.getCmp("TextBedCode").reset();
		Ext.getCmp("TextBedRoomDR").reset();
		Ext.getCmp("TextBedRcFlag").reset();
		PACBedds.baseParams={ParRef:Ext.getCmp("hidden_ref").getValue()};
		PACBedds.load({params:{start:0, limit:pagesize_PACBed}});
        }

    });
    
    
	
    
    
    
    
    
    
    
    
    //等候区--->
    
	var myPACWardRoom_Room_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACRoom&pClassQuery=GetDataForCmb1";
	var myPACWardRoom_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACWardRoom&pClassQuery=GetList";
	var myPACWardRoom_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACWardRoom&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACWardRoom";
	var myPACWardRoom_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACWardRoom&pClassMethod=OpenData";
	var myPACWardRoom_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACWardRoom&pClassMethod=DeleteData";
	var myPACWardRoom_pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;

	/** 删除按钮 */
	var myPACWardRoom_btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除',
					iconCls : 'icon-delete',
					id:'myPACWardRoom_del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_del_btn'),
					handler : function myPACWardRoom_DelData() {
						if (myPACWardRoom_grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = myPACWardRoom_grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									Ext.Ajax.request({
										url : myPACWardRoom_DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('ROOMRowId')
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
															var startIndex = myPACWardRoom_grid.getBottomToolbar().cursor;
															var totalnum=myPACWardRoom_grid.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%myPACWardRoom_pagesize_pop==0)//最后一页只有一条
															{
																var pagenum=myPACWardRoom_grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-myPACWardRoom_pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															myPACWardRoom_grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : myPACWardRoom_pagesize_pop
																			,ROOMParRef:Ext.getCmp("hidden_ref").getValue()
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
	var myPACWardRoom_ds_Room = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({ url : myPACWardRoom_Room_ACTION_URL }),
			reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [ 'ROOMRowID', 'ROOMDesc' ])
		});
	
		
	/** 创建Form表单 */
	var myPACWardRoom_WinForm = new Ext.form.FormPanel({
				id : 'myPACWardRoom-form-save',
				labelAlign : 'right',
				labelWidth : 85,
				baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ROOMRowId',mapping:'ROOMRowId',type:'string'},
                                         {name: 'ROOMRoomDR',mapping:'ROOMRoomDR',type:'string'},
                                         {name: 'ROOMDateFrom',mapping:'ROOMDateFrom',type:'string'},
                                         {name: 'ROOMDateTo',mapping:'ROOMDateTo',type:'string'},
                                          {name: 'ROOMPositionLeft',mapping:'ROOMPositionLeft',type:'string'},
	             							{name: 'ROOMPositionTop',mapping:'ROOMPositionTop',type:'string'},
	             							{name: 'ROOMPositionHeight',mapping:'ROOMPositionHeight',type:'string'},
	            							 {name: 'ROOMPositionWidth',mapping:'ROOMPositionWidth',type:'string'}
                                   ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ROOMParRef',
							hideLabel : 'True',
							hidden : true,
							name : 'ROOMParRef'
						}, {
							fieldLabel : 'ROOMRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ROOMRowId'
						}, {
							xtype : 'bdpcombo',
							loadByIdParam : 'rowid',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							fieldLabel : '<font color=red>*</font>房间',
							name : 'ROOMRoomDR',
							id:'ROOMRoomDRF',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMRoomDRF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMRoomDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMRoomDRF')),
							hiddenName : 'ROOMRoomDR',
							mode : 'remote',
							store : myPACWardRoom_ds_Room,
							queryParam : 'desc',
							//triggerAction : 'all',
							listWidth : 240,
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'ROOMRowID',
							displayField : 'ROOMDesc',
							allowBlank : false,
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
											desc:e.query,
											hospid:Ext.getCmp("hidden_PACBedHOSPDR").getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
								
									}
							}
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'ROOMDateFrom',
							id:'ROOMDateFromF',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMDateFromF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMDateFromF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMDateFromF')),
							format : BDPDateFormat,
							allowBlank : false,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'ROOMDateTo',
							id:'ROOMDateToF',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMDateToF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMDateToF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMDateToF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						},{
								fieldLabel : '<font color=red></font>X坐标(cm)',
								xtype:'numberfield',
								id:'ROOMPositionLeft',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionLeft'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionLeft'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionLeft')),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'ROOMPositionLeft'
						},{
								fieldLabel : '<font color=red></font>Y坐标(cm)',
								xtype:'numberfield',
								id:'ROOMPositionTop',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionTop'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionTop'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionTop')),
								minValue : 0,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'ROOMPositionTop'
						},{
								fieldLabel : '<font color=red></font>房间高度(cm)',
								xtype:'numberfield',
								id:'ROOMPositionHeight',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionHeight'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionHeight'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionHeight')),
								minValue : 1,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'ROOMPositionHeight'						
						},{
								fieldLabel : '<font color=red></font>房间宽度(cm)',
								xtype:'numberfield',
								id:'ROOMPositionWidth',
								//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionWidth'),
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionWidth'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMPositionWidth')),
								minValue : 1,
								allowNegative : false,//不允许输入负数
								allowDecimals : false,//不允许输入小数
								name : 'ROOMPositionWidth'
						}]
			});
	/** 增加修改时弹出窗口 */
	var myPACWardRoom_win = new Ext.Window({
					title : '',
					width : 300,
					height:	380,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : myPACWardRoom_WinForm,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'myPACWardRoom_save_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_save_btn'),
						handler : function () {
							var ROOMRoomDR = Ext.getCmp("myPACWardRoom-form-save").getForm().findField("ROOMRoomDR").getValue();
							var startDate = Ext.getCmp("myPACWardRoom-form-save").getForm().findField("ROOMDateFrom").getValue();
			    			var endDate = Ext.getCmp("myPACWardRoom-form-save").getForm().findField("ROOMDateTo").getValue();
			    			if (ROOMRoomDR=="") {
			    				Ext.Msg.show({ title : '提示', msg : '房间不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
			   			 	if(myPACWardRoom_WinForm.form.isValid()==false){return;}
							if (myPACWardRoom_win.title == "添加") {
								myPACWardRoom_WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : myPACWardRoom_SAVE_ACTION_URL,
									method : 'POST',
									/*params : {									  //-------请求带的参数
										ROOMParRef:Ext.getCmp("hidden_ref").getValue()
									},*/ //在form打开的时候已经有赋值
									success : function(form, action) {
										if (action.result.success == 'true') {
											myPACWardRoom_win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															myPACWardRoom_grid.getStore().load({
																		params : {
																			start : 0,
																			limit : 1,
																			rowid : myrowid
																			,ROOMParRef:Ext.getCmp("hidden_ref").getValue()
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
										myPACWardRoom_WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : myPACWardRoom_SAVE_ACTION_URL,
											method : 'POST',
											success : function(form, action) {
												// alert(action);
												if (action.result.success == 'true') {
													myPACWardRoom_win.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.BDP.FunLib.ReturnDataForUpdate("myPACWardRoom_grid", myPACWardRoom_QUERY_ACTION_URL, myrowid)
															/*myPACWardRoom_grid.getStore().load({
																		params : {
																			start : 0,
																			limit : 1,
																			rowid : myrowid
																			,ROOMParRef:Ext.getCmp("hidden_ref").getValue()
																		}
																	});*/
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
								// myPACWardRoom_WinForm.getForm().reset();
							}			
						}
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							myPACWardRoom_win.hide();
						}
					}],
					listeners : {
						"show" : function() {
						},
						"hide" : function() {
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var myPACWardRoom_btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'myPACWardRoom_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_add_btn'),
				handler : function myPACWardRoom_AddData() {
					myPACWardRoom_win.setTitle('添加');
					myPACWardRoom_win.setIconClass('icon-add');
					myPACWardRoom_win.show();
					myPACWardRoom_WinForm.getForm().reset();
					Ext.getCmp("myPACWardRoom-form-save").getForm().findField('ROOMParRef').setValue(Ext.getCmp('hidden_ref').getValue());
				},
				scope : this
			});
	/** 修改按钮 */
	var myPACWardRoom_btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'myPACWardRoom_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_update_btn'),
				handler : function myPACWardRoom_UpdateData() {
					if (myPACWardRoom_grid.selModel.hasSelection()) {
						var _record = myPACWardRoom_grid.getSelectionModel().getSelected();
						myPACWardRoom_win.setTitle('修改');
						myPACWardRoom_win.setIconClass('icon-update');
						myPACWardRoom_win.show();
			            Ext.getCmp("myPACWardRoom-form-save").getForm().load({
			                url : myPACWardRoom_OPEN_ACTION_URL + '&id=' + _record.get('ROOMRowId'),
			                waitMsg : '正在载入数据...',
			                success : function(form,action) {
			                    //Ext.Msg.alert(action);
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
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
	/** myPACWardRoom_grid数据存储 */
	var myPACWardRoom_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : myPACWardRoom_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ROOMRowId',
									mapping : 'ROOMRowId',
									type : 'string'
								}, {
									name : 'ROOMRoomDRCode',
									mapping : 'ROOMRoomDRCode',
									type : 'string'
								}, {
									name : 'ROOMRoomDR',
									mapping : 'ROOMRoomDR',
									type : 'string'
								}, {
									name : 'ROOMDateFrom',
									mapping : 'ROOMDateFrom',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'ROOMDateTo',
									mapping : 'ROOMDateTo',
									type : 'date',
									dateFormat : 'm/d/Y'},
								  { name: 'ROOMPositionLeft',mapping:'ROOMPositionLeft', type: 'string' },
             { name: 'ROOMPositionTop',mapping:'ROOMPositionTop', type: 'string' },
              { name: 'ROOMPositionHeight',mapping:'ROOMPositionHeight', type: 'string' },
               { name: 'ROOMPositionWidth',mapping:'ROOMPositionWidth', type: 'string' 
								}// 列的映射
						])
			});
	/** myPACWardRoom_grid数据加载遮罩 */
/*	var myPACWardRoom_loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : true,
						store : myPACWardRoom_ds
					});*/
	
	/** myPACWardRoom_grid分页工具条 */
	var myPACWardRoom_paging = new Ext.PagingToolbar({
				pageSize : myPACWardRoom_pagesize_pop,
				store : myPACWardRoom_ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						myPACWardRoom_pagesize_pop=this.pageSize;
					}
				}
			});
			
	
	
	/** 增删改工具条 */
	var myPACWardRoom_tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [myPACWardRoom_btnAddwin, '-', myPACWardRoom_btnEditwin, '-', myPACWardRoom_btnDel]
		});
	/** 搜索按钮 */
	var myPACWardRoom_btnSearch = new Ext.Button({
				id : 'myPACWardRoom_search_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_search_btn'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					//alert(Ext.getCmp("hidden_ref").getValue());
					myPACWardRoom_grid.getStore().baseParams={
							ROOMParRef : Ext.getCmp("hidden_ref").getValue(),
							ROOMRoomDesc : Ext.getCmp("myPACWardRoom_TextCode").getValue()
					};
					myPACWardRoom_grid.getStore().load({
						params : {
							start : 0,
							limit : myPACWardRoom_pagesize_pop
						}
					});
				}
			});
	/** 重置按钮 */
	var myPACWardRoom_btnRefresh = new Ext.Button({
				id : 'myPACWardRoom_refresh_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_refresh_btn'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("myPACWardRoom_TextCode").reset();
					myPACWardRoom_grid.getStore().baseParams={
					
					ROOMParRef:Ext.getCmp("hidden_ref").getValue()};
					myPACWardRoom_grid.getStore().load({
								params : {
									start : 0,
									limit : myPACWardRoom_pagesize_pop
								}
							});
				}
			});
	var myPACWardRoom_tb = new Ext.Toolbar({
				id : 'myPACWardRoom_tb',
				items : [{ //'病区ID:', 
							xtype : 'textfield',
							hidden:true,
							id:'myPACWardRoom_CTLocID'
						},'房间描述', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoom_TextCode'),
							id : 'myPACWardRoom_TextCode'
						}, '-', myPACWardRoom_btnSearch, '-', myPACWardRoom_btnRefresh, '->'
				],
				listeners : {
					render : function() {
						myPACWardRoom_tbbutton.render(myPACWardRoom_grid.tbar);
					}
				}
			});
	/** 创建myPACWardRoom_grid */
	var myPACWardRoom_grid = new Ext.grid.GridPanel({
				id : 'myPACWardRoom_grid',
				region : 'center',
				closable : true,
				store : myPACWardRoom_ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ROOMRowId',
							sortable : true,
							dataIndex : 'ROOMRowId',
							hidden : true
						}, {
							header : '房间代码',
							sortable : true,
							dataIndex : 'ROOMRoomDRCode'
						}, {
							header : '房间描述',
							sortable : true,
							dataIndex : 'ROOMRoomDR'
						}, {
							header : '开始日期',
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ROOMDateFrom'
						}, {
						header : '结束日期',
						sortable : true,
						renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
						dataIndex : 'ROOMDateTo'
					}, {
						header : 'X坐标(cm)',
						width : 100,
						sortable : true,
						dataIndex : 'ROOMPositionLeft'
					}, {
						header : 'Y坐标(cm)',
						width : 100,
						sortable : true,
						dataIndex : 'ROOMPositionTop'
					}, {
						header : '房间高度(cm)',
						width : 100,
						sortable : true,
						dataIndex : 'ROOMPositionHeight'
					}, {
						header : '房间宽度(cm)',
						width : 100,
						sortable : true,
						dataIndex : 'ROOMPositionWidth'
						}],
				stripeRows : true,
				viewConfig : {
					forceFit : true
				},
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : myPACWardRoom_paging,
				tbar : myPACWardRoom_tb,
				stateId : 'myPACWardRoom_grid'
			});
			
			Ext.BDP.FunLib.ShowUserHabit(myPACWardRoom_grid,"User.PACWardRoom");
			Ext.BDP.FunLib.ShowUserHabit(BedFeegrid,"User.DHCPACBedFeeItem");		//2020
	/** myPACWardRoom_grid双击事件 */
	myPACWardRoom_grid.on("rowdblclick", function(myPACWardRoom_grid, rowIndex, e) {
				var _record = myPACWardRoom_grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            myPACWardRoom_win.setTitle('修改');
					myPACWardRoom_win.setIconClass('icon-update');
					myPACWardRoom_win.show();
		            Ext.getCmp("myPACWardRoom-form-save").getForm().load({
		                url : myPACWardRoom_OPEN_ACTION_URL + '&id=' + _record.get('ROOMRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败!');
		                }
		            });
		        }
			});
			

		var winmyPACWardRoom = new Ext.Window({ //房间分配页面,修改数据window
			title:'',
			width:650,
            height:380,
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
			items: myPACWardRoom_grid,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
    
    
    
    
    
    
    
    
    
    
	var myPACWardRoombtn=new Ext.Button({
        id:'myPACWardRoombtn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('myPACWardRoombtn'),
        iconCls:'icon-wardroom',
        text:'房间分配',
        tooltip:'点击查看等候区',
        handler:function(){
        	myPACWardRoom_ds.baseParams={ROOMParRef:Ext.getCmp("hidden_ref").getValue()};
			myPACWardRoom_ds.load({params:{start:0, limit:myPACWardRoom_pagesize_pop}});
           	var CTLOCDesc=Ext.getCmp("CTLOCDesc_HIDDEN").getValue();
        	winmyPACWardRoom.setTitle('房间分配--'+CTLOCDesc);
			winmyPACWardRoom.show();
			Ext.getCmp("myPACWardRoom_TextCode").reset();
			
        }

    });
    //<---等候区
    var floorform = new Ext.form.FormPanel({
			// title: 'Absolute Layout',
    		width:880,
            height:470,
            region:'center',
			autoScroll : true,// 宽度、高度不够时自动加滚动条
			layout : 'absolute',
			// bodyStyle:'padding:50px 50px 50px 10px', //上 右 下 左
			// win里有用，form里没用？
			layoutConfig : {
				// 布局的配置项就在这里配置 layout-specific configs go here
				extraCls : 'x-abs-layout-item'
			},
			baseCls : 'x-plain',
			defaultType : 'panel', // textfield
			items : []
		});
   var FormInfoPanel = new Ext.form.FormPanel({
  			height:30,
           // baseCls : 'x-plain',//form透明,不显示框框
  			width:880,
  			split : true,
  			labelWidth:50,
  			labelAlign : 'right', //标签对齐方式
			//frame : true,//Panel具有全部阴影,若为false则只有边框有阴影
            region:'north',
			items : [{
					layout:'column',
					items:[{
						columnWidth:.25,
						layout:'form',
						//baseCls : 'x-plain',//form透明,不显示框框
						border:false,
						items:[{
							id : 'XPo',
							labelWidth : 80,
							fieldLabel : 'X坐标(cm)',
							xtype:'textfield',
							name : 'XPo'
						}]},
						{
						columnWidth:.25,
						layout:'form',
						//baseCls : 'x-plain',//form透明,不显示框框
						border:false,
						//style:'margin-right:20px',
						items:[{
							id : 'YPo',
							fieldLabel : 'Y坐标(cm)',
							xtype:'textfield',
							name : 'YPo'
						}]
						},
						{
						columnWidth:.25,
						layout:'form',
						//baseCls : 'x-plain',//form透明,不显示框框
						border:false,
						//style:'margin-right:20px',
						items:[{
							id : 'Height',
							fieldLabel : '高度(cm)',
							xtype:'textfield',
							name : 'Height'
						}]
						},
						{
						columnWidth:.25,
						layout:'form',
						border:false,
						baseCls : 'x-plain',//form透明,不显示框框
						//style:'margin-right:20px',
						items:[{
							id : 'Width',
							fieldLabel : '宽度(cm)',
							xtype:'textfield',
							name : 'Width'
						}]
						}
						]
			}]			
		});
		
		
	var PACBedfloorwin = new Ext.Window({
			title:'',
			width:Ext.getBody().getViewSize().width-50,
            height:Ext.getBody().getViewSize().height-50,
            layout : 'border',
			defaults:{split:true},
			//layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,//圆角边框
			// html:''',//面板内容
			//autoScroll: true,//滚动条
			collapsible:true,//显示收缩按钮
			hideCollapseTool:true,
			titleCollapse: true,//点击标题栏,收缩面板
			//bodyStyle:'padding:50px 50px 50px 10px',   //上  右  下  左,win里有用，form里没用？
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,   
			items: [FormInfoPanel,floorform
			],
			buttons:[{
				text:'确定',
				handler:function(){	
					PACBedfloorwin.hide();
				}
			}],
			listeners:{
				"show":function(){
				},
				"hide":function(){
					PACBedds.baseParams={ParRef:Ext.getCmp("hidden_ref").getValue()};
					PACBedds.load({params:{start:0, limit:pagesize_PACBed}});      
					
				},
				"close":function(){
				}
			}
		});
		
		
    //床位图--->
	var PACBedfloorbtn=new Ext.Button({
        id:'PACBedfloorbtn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('PACBedfloorbtn'),
        iconCls:'icon-AdmType',
        text:'查看床位图',
        handler:ShowBedPic=function(){
        	//----------------------------------------------------2013-11-04 by lisen
        	var ctloc=Ext.getCmp("CTLOCRowID_HIDDEN").getValue();
        	var CTLOCDesc=Ext.getCmp("CTLOCDesc_HIDDEN").getValue();
        	var win_width = screen.width;
        	var win_height = screen.height;
        	var encodectloc=encodeURIComponent(encodeURIComponent(ctloc));
			var encodeCTLOCDesc=encodeURIComponent(encodeURIComponent(CTLOCDesc));
        	var link="dhc.bdp.ext.default.csp?extfilename=App/Locations/BedMap/PAC_BedMap&ctloc="+encodectloc+"&CTLOCDesc="+encodeCTLOCDesc;
	        //var rtn = window.open(link,"newwindow","height=100%,width=100%,top="+(window.screen.availHeight-30-600)/2+",left="+(window.screen.availWidth-10-950)/2+",resizable=yes,scrollbars=yes");
	        //var rtn = window.showModalDialog(link,"","dialogWidth="+win_width+"px;dialogHeight="+win_height+"px;center=yes;");
        	//var rtn = window.open(link,"newwindow","width="+win_width+"px;height="+win_height+"px;center=yes;");
	        var rtn = window.open (link,'newwindow','width='+(window.screen.availWidth-110)+',height='+(window.screen.availHeight-120)+ ',top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no')
			if(rtn=="closed"){
	        	PACBedds.reload();
	        }
	        return;
	        //----------------------------------------------------------------------
	        
			floorform.removeAll();
			var CTLOCDesc=Ext.getCmp("CTLOCDesc_HIDDEN").getValue();
        	PACBedfloorwin.setTitle('床位图--'+CTLOCDesc);
			PACBedfloorwin.setIconClass('icon-AdmType');
			PACBedfloorwin.show();
			//var btnxy=PACBedfloorwin.getPosition();
			//alert(btnxy); ///111 53
			var PX=5;		//床位横向间隔
			var PY=5;		//床位纵向间隔
			var PW=160;		// 床宽
			var PH=60;		//床高
			var PColumn=7;	//每排的床数
			var PWW=160;	//等候区宽
			var PWH=PACBedfloorwin.getInnerHeight()-PX-PX	//等候区高，根据界面高度调节
			var WaitingItem = {
						itemId : 'PACWardRoomId',
						x:PX,
						y:PY,
						//frame:true,
						//html: PName,
						height:PWH,
						width:PWW,
						draggable:false,
						title : "等候区"
					};
			floorform.add(WaitingItem);
			//病区床位
			var ctloc=Ext.getCmp("CTLOCRowID_HIDDEN").getValue();
			var objPortlet = tkMakeServerCall("web.DHCBL.CT.PACBed","GetPACBedInfoAsSeq",ctloc);
			var arryTmp = objPortlet.split("<$C1>");
			for(var intRow = 0; intRow < arryTmp.length; intRow ++)
			{
				var myPortlet = arryTmp[intRow];
				if(myPortlet == "") continue;
				var arryField = myPortlet.split("^");
				var PId=arryField[0];
				var PName=arryField[1];
				var PRcFlag=arryField[2];
				
				if(PRcFlag=="Y") //床位激活时，显示该床位对应的textfield
				{
					//根据顺序计算坐标
					var PLeft=(PX+PW)*(intRow%PColumn)+PX;		//床位横坐标
					var PTop=(PY+PH)*parseInt(intRow/PColumn)+PY;		//床位纵坐标
					PLeft=PLeft+PWW+PX		//加上等候区宽
					
					var BedItem={
						itemId:'PACBed^'+PId,
						title:PName,
						x:PLeft,
						y:PTop,
						html:'111',
						//frame:true,
						//html: PName,
						height:PH,
						width:PW,
						draggable:false
					};
					floorform.add(BedItem);
				}
			
			}
			floorform.doLayout();
    
        }
    });
    
    
   //快速设置床位图
	var QuickPACBedfloorbtn=new Ext.Button({
        id:'QuickPACBedfloorbtn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('QuickPACBedfloorbtn'),
        iconCls:'icon-update',
        text:'快速设置床位图',
        tooltip:'床位根据序号排序',
        handler: function() {
			Quickwin.setTitle('快速设置床位图（床位根据序号排序）');
			Quickwin.setIconClass('icon-update');
			Quickwin.show();
			QuickWinForm.getForm().reset();
			QuickWinForm.getForm().findField('BEDWARDParRef').setValue(Ext.getCmp("hidden_ref").getValue());//20130603LISEN
			Ext.getCmp("BEDHeight").setValue(120);
			Ext.getCmp("BEDWidth").setValue(160);
			Ext.getCmp("BEDX").setValue(5);
			Ext.getCmp("BEDY").setValue(5);
			Ext.getCmp("BEDNumber").setValue(5);
			Ext.getCmp("BEDXGap").setValue(5);
			Ext.getCmp("BEDYGap").setValue(5);
			
        }
	});
 
    
	var PACBedtb=new Ext.Toolbar({
        id:'PACBedtb',
        items:['床代码',
            {
			xtype: 'textfield',
			width:80,
			disabled : Ext.BDP.FunLib.Component.DisableFlag('TextBedCode'),
			id: 'TextBedCode'
			},
            '-',
			'房间',
            {
			xtype: 'textfield',
			id: 'TextBedRoomDR',
			width:80,
			disabled : Ext.BDP.FunLib.Component.DisableFlag('TextBedRoomDR')
			},
			'-',
			'激活',
            {
						// fieldLabel : '<font color=red></font>激活',
						xtype : 'combo',
						id : 'TextBedRcFlag',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextBedRcFlag'),
						width : 80,
						mode : 'local',
						triggerAction : 'all',
						// forceSelection : true,
						// selectOnFocus : false,
						//typeAhead : true,
						//minChars : 1,
						listWidth : 140,
						shadow : false,
						valueField : 'value',
						displayField : 'name',
						// editable:false,
						store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												value : 'Y',
												name : 'Yes'
											}, {
												value : 'N',
												name : 'No'
											}]
								})
					},
			
			
            '-',PACBedbtnSearch,'-',PACBedbtnRefresh,'-',myPACWardRoombtn, '-',
            PACBedfloorbtn,'-',
            QuickPACBedfloorbtn ,'-',{ //医院id
							xtype : 'textfield',
							hidden:true,
							id:'hidden_PACBedHOSPDR'
						},
			
			
            '->'
            //btnHelp
        ],
		listeners:{
        render:function(){
        PACBedtbbutton.render(PACBedgrid.tbar)  //tbar.render(panel.bbar)这个效果在底部
        }
    }
	});

    var PACBedgrid = new Ext.grid.GridPanel({
		id:'PACBedgrid',
		region: 'center',
		width:700,
		height:400,
		closable:true,
	    store: PACBedds,
	    trackMouseOver: true,
	    columns: [
	        sm,
	       { header: '序号', width: 50, sortable: true, dataIndex: 'BEDSequence' },
	        { header: 'RowID', width: 100, sortable: true, dataIndex: 'BEDRowID', hidden : true},
	        { header: '床代码', width: 80, sortable: true, dataIndex: 'BEDCode' },
	        { header: '床类型', width: 120, sortable: true, dataIndex: 'BEDBedTypeDR' },
	        { header: '房间', width: 120, sortable: true, dataIndex: 'BEDRoomDR' },
	        { header: '激活', width:60, sortable: true, dataIndex: 'BEDRcFlag',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
	        
	        
	         { header: '床宽(cm)', width: 80, sortable: true, dataIndex: 'BEDPositionWidth' },
	         { header: '床高(cm)', width: 80, sortable: true, dataIndex: 'BEDPositionHeight' },
	         { header: 'X坐标(cm)', width: 100, sortable: true, dataIndex: 'BEDPositionLeft' },
	        { header: 'Y坐标(cm)', width: 100, sortable: true, dataIndex: 'BEDPositionTop' },
	        { header: '开始日期', width: 100, sortable: true, renderer: Ext.util.Format.dateRenderer(BDPDateFormat), dataIndex: 'BEDDateFrom' },  
	        { header: '结束日期', width: 100, sortable: true, renderer: Ext.util.Format.dateRenderer(BDPDateFormat), dataIndex: 'BEDDateTo' },
	        { header: '所属科室', width: 100, sortable: true, dataIndex: 'CTLOCDesc' },
	        { header: '床位编制', width: 100, sortable: true, dataIndex: 'BEDORGZDesc' }
	    ],
	    stripeRows: true,
	    //loadMask: { msg: '数据加载中,请稍候...' },
	    sm: new Ext.grid.CheckboxSelectionModel(),
	    //title: '病区床位维护',
	    //tools:Ext.BDP.FunLib.Component.HelpMsg,
	    stateful: true,
	    viewConfig: {
			forceFit: true
		},
		bbar:PACBedpaging ,
		tbar:PACBedtb,		
	    stateId: 'PACBedgrid'
    
	});
	
	Ext.BDP.FunLib.ShowUserHabit(PACBedgrid,"User.PACBed");
	
	/** 监听数据是否有变化,自动判断是否全选并选中或不选中表头的checkbox 20130711lisen */
	//ds.on('datachanged', function autoCheckGridHead(store){
	PACBedds.on('load', function autoCheckGridHead(store){
		var hd_checker = PACBedgrid.getEl().select('div.x-grid3-hd-checker'); 	//CompositeElementLite/CompositeElement
    	var hd = hd_checker.first();		//呵呵，终于搞定了，这句测了好久，才找对对象;
    	if(hd != null){
	    	if(PACBedgrid.getSelectionModel().getSelections().length != PACBedgrid.getStore().getCount()){    //没有全选的话
                //清空表格头的checkBox
                if(hd.hasClass('x-grid3-hd-checker-on')){
	                hd.removeClass('x-grid3-hd-checker-on');     //x-grid3-hd-checker-on
                	//grid.getSelectionModel().clearSelections();
	            }
            }else{
            	if(PACBedgrid.getStore().getCount() == 0){	//没有记录的话清空;
            		return;
            	}else{
	            	hd.addClass('x-grid3-hd-checker-on');
	                PACBedgrid.getSelectionModel().selectAll();
            	}
            }
        } 
	});
	
	PACBedgrid.on("rowdblclick",function(grid,rowIndex,e){
			PACBedWinForm.getForm().findField('BEDWARDParRef').setValue(Ext.getCmp("hidden_ref").getValue());
			var _record = grid.getSelectionModel().getSelected();
			if (!_record) {
	            Ext.Msg.show({
						title : '提示',
						msg : '请选择需要修改的行!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
	        } else {
	            PACBedwin.setTitle('修改');
				PACBedwin.setIconClass('icon-update');
				PACBedwin.show();
	            Ext.getCmp("form-PACBed-save").getForm().load({
	                url : OPEN_ACTION_URL + '&id=' + _record.get('BEDRowID'),
	                waitMsg : '正在载入数据...',
	                success : function(form,action) {
	                    //Ext.Msg.alert(action);
	                	//Ext.Msg.alert('编辑', '载入成功');
	                },
	                failure : function(form,action) {
	                	Ext.Msg.alert('编辑', '载入失败');
	                }
	            });
	        }
		});  
			
 
/*	
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [PACBedgrid]
    });*/
    var windowHight = document.documentElement.clientHeight;		//可获取到高度
 	  var windowWidth = document.documentElement.clientWidth;
 function getPacBedPanel(){
	var winPacBed = new Ext.Window({
			title:'',
			width:windowWidth*0.9,
      height:windowHight*0.9,
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
			items: PACBedgrid,
			listeners:{
				"show":function(){
				},
				"hide":function(){
					Ext.getCmp('TextBedCode').setValue('');
					Ext.getCmp('TextBedRoomDR').setValue('');
					Ext.getCmp('TextBedRcFlag').setValue('');
				},
				"close":function(){
				}
			}
		});
	//gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
  	return winPacBed;
}
    
 //PACBedgrid.setTitle('病区床位维护--'+CTLocDesc);//20130603LISEN
 

/*------------右键添加床位-------------------
  
	   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  		{
            grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
    		{
	            iconCls :'icon-add',
	            handler: pacbedAddData,
	            id:'pacbedAddData',
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('pacbedAddData'),
	            text: '添加床位'
	       
	        }]     	
		}); 
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
	     if(currRecord.json.CTLOCType!="W")//医嘱子类为空时，右键菜单灰化
		 {
			btnPacBed.setDisabled(true);
			btnPACWardRoom.setDisabled(true);
			btnCTLocSimilarDepartment.setDisabled(false);
			Ext.getCmp('menuPacBed').disable();
			Ext.getCmp('menuPACWardRoom').disable();
			Ext.getCmp('menuCTLocSimilarDepartment').enable();
		 }
		 else{
			btnPacBed.setDisabled(false);
			btnPACWardRoom.setDisabled(false);
			btnCTLocSimilarDepartment.setDisabled(true);
			Ext.getCmp('menuPacBed').enable();
			Ext.getCmp('menuPACWardRoom').enable();
			Ext.getCmp('menuCTLocSimilarDepartment').disable();
	     }
	     currGrid = grid; 
	     rightClick.showAt(e.getXY()); 
        }
    }	

*
*/	
//------------------快速设置床位图
 var QuickWinForm = new Ext.form.FormPanel({
	    id: 'form-Quick-save',
        labelAlign: 'right',
        labelWidth : 140,
		split : true, 
		frame : true,	
		waitMsgTarget : true,
        baseCls : 'x-plain',//form透明,不显示框框
        defaults: { anchor : '90%', bosrder: false },
        defaultType: 'textfield',
        reader: new Ext.data.JsonReader({root:'list'},
	            [{name: 'BEDWARDParRef',mapping:'BEDWARDParRef',type:'string'},
	             {name: 'BEDHeight',mapping:'BEDHeight',type:'string'},
	             {name: 'BEDWidth',mapping:'BEDWidth',type:'string'},
	             {name: 'BEDX',mapping:'BEDX',type:'string'},
	             {name: 'BEDY',mapping:'BEDY',type:'string'},
	             {name: 'BEDNumber',mapping:'BEDNumber',type:'string'},
	             {name: 'BEDXGap',mapping:'BEDXGap',type:'string'},
	             {name: 'BEDYGap',mapping:'BEDYGap',type:'string'}/*,
	             {name: 'BEDWaitingHeight',mapping:'BEDWaitingHeight',type:'string'},
	             {name: 'BEDWaitingWidth',mapping:'BEDWaitingWidth',type:'string'},
	             {name: 'BEDWaitingX',mapping:'BEDWaitingX',type:'string'},
	             {name: 'BEDWaitingY',mapping:'BEDWaitingY',type:'string'} */
	             
	       ]),
        items: [{
				fieldLabel : 'BEDWARDParRef',
				hideLabel : 'True',
				hidden : true,
				readOnly : true,
				name : 'BEDWARDParRef'
           
			},{
                fieldLabel: '<font color=red>*</font>床的宽度(cm)', 
                xtype : 'numberfield',
                name: 'BEDWidth',
                minValue : 1,
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数
                id:'BEDWidth',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDWidth'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDWidth'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDWidth')),
				allowBlank : false
			 },{
                fieldLabel: '<font color=red>*</font>床的高度(cm)', 
                xtype : 'numberfield',
                name: 'BEDHeight',
                minValue : 1,
                //maxValue : 400,// 最大值400
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数
                id:'BEDHeight',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDHeight'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDHeight')),
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDHeight'),
				allowBlank : false
            }, {
                fieldLabel: '<font color=red>*</font>起始坐标X(cm)',
                xtype : 'numberfield',
                name: 'BEDX',
                minValue : 0,
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数
                id:'BEDX',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDX'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDX'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDX')),
				allowBlank : false   //？？可以再改，当为空时，默认为0
			 }, {
                fieldLabel: '<font color=red>*</font>起始坐标Y(cm)',
                xtype : 'numberfield',
                name: 'BEDY',
                minValue : 0,
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数
                id:'BEDY',
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDY'),
   				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDY'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDY')),
				allowBlank : false   //？？可以再改，当为空时，默认为0
            },  {
                fieldLabel: '<font color=red>*</font>每行床位个数',
                xtype : 'numberfield',
                name: 'BEDNumber',
                minValue : 1,
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数
                id:'BEDNumber',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDNumber'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDNumber')),
   				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDNumber'),
				allowBlank : false
           }, {
				fieldLabel : '<font color=red>*</font>行与行间距(cm)', //BEDYGap行间距,BEDXGap列间距
				xtype : 'numberfield',
				name : 'BEDYGap',
				id : 'BEDYGap',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDYGap'),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDYGap'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDXGap')),
				minValue : 0,
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数
				allowBlank : false
			}, {
				fieldLabel : '<font color=red>*</font>列与列间距(cm)',
				xtype : 'numberfield',
				id : 'BEDXGap',
				name : 'BEDXGap',
				//disabled : Ext.BDP.FunLib.Component.DisableFlag('BEDXGap'),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('BEDXGap'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BEDYGap')),
				minValue : 0,
				allowNegative : false,// 不允许输入负数
				allowDecimals : false,// 不允许输入小数  
				allowBlank : false
			
					}]
		});

	var Quickwin = new Ext.Window({
			title:'',
			width:320,
            height:350,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			autoScroll: true,
			//collapsible:true,
			//hideCollapseTool:true,
			//titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide', 
			items: QuickWinForm,
			buttons:[{
				text:'保存',
				id:'Quick_save_btn',
				iconCls : 'icon-save',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('Quick_save_btn'),
				handler: function() {
					
					Ext.MessageBox.confirm('提示','确定要快速设置床位坐标吗？以前的床位坐标数据将清空！',function(btn){
					if(btn=='yes'){
						QuickWinForm.form.submit({
							clientValidation : true, // 进行客户端验证
							waitMsg : '正在提交数据请稍后...',
							waitTitle : '提示',
							url : Quick_SAVE_ACTION_URL,
							method : 'POST',
							success : function(form, action) {
								if (action.result.success == 'true') {
									Quickwin.hide();
									var myrowid = action.result.id;
									// var myrowid = jsonData.id;
									Ext.Msg.show({
												title : '提示',
												msg : '设置成功,请点击查看床位图!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													PACBedds.baseParams={ParRef:Ext.getCmp("hidden_ref").getValue()};
													PACBedgrid.getStore().load({params:{start:0, limit:pagesize_PACBed}});
													//ShowBedPic();
												}
									});
								} else {
									var errorMsg = '';
									if (action.result.errorinfo) {
										errorMsg = '<br/>错误信息:' + action.result.errorinfo
									}
									Ext.Msg.show({
												title : '提示',
												msg : '快速设置床位坐标失败!' + errorMsg,
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
					})
					
			}
			},{
				text : '关闭',
				iconCls : 'icon-close',
				handler:function(){
					Quickwin.hide();
				}
			}],
			listeners:{
				"show":function(){
				},
				"hide":function(){
					//Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾
				},
				"close":function(){
				}
			}
		});

//});
