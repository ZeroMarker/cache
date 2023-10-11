/// 名称: 其它登录科室维护
/// 描述: 其它登录科室维护，用户维护的子JS
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2013-4-20

	
	/**----------------------------------其它登录科室部分--------------------------------------**/	

	var ACTION_URL_SSUserOtherLogonLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassQuery=GetList";
	var SAVE_URL_OtherLogonLoc = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSUserOtherLogonLoc"
	var DELETE_OtherLogonLoc_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSUserOtherLogonLoc&pClassMethod=DeleteData"
	var BindingLoc = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var BindingGroup = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";
	var BindingHospital = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";

	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBResource&pClassMethod=OpenData";
	
	var GroupId = session['LOGON.GROUPID'];   //获取GroupId
	
	var pageSize_LogonLoc = Ext.BDP.FunLib.PageSize.Pop;
	
	/*	if(session['LOGON.GROUPDESC']!="Demo Group")  //判断用户是否是demo,不是demo就走授权
    {
    	BindingGroup ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassQuery=GetGroupList";
    	BindingLoc ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassQuery=GetLocList";
    }*/
	
 	var dsOtherLogonLoc = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_SSUserOtherLogonLoc}),//调用的动作  pClassName=web.DHCBL.CT.RBOtherLogonLoc&pClassQuery=GetList
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'OTHLLRowId', mapping:'OTHLLRowId',type: 'string'},
        { name: 'OTHLLParRef', mapping:'OTHLLParRef',type: 'string'},
	    { name: 'SSUSRName', mapping:'SSUSRName',type: 'string'},
	    { name: 'OTHLLCTLOCDR', mapping:'OTHLLCTLOCDR',type: 'string'},
        { name: 'CTLOCDesc',mapping:'CTLOCDesc', type: 'string' },   
        { name: 'OTHLLUserGroupDR', mapping:'OTHLLUserGroupDR',type: 'string'},
        { name: 'SSGRPDesc', mapping:'SSGRPDesc',type: 'string'},
        { name: 'OTHLLHospitalDR', mapping:'OTHLLHospitalDR',type: 'string'},
        { name: 'HOSPDesc', mapping:'HOSPDesc',type: 'string'}
		]),
		remoteSort: true
    });	
    
	var pagingOtherLogonLoc= new Ext.PagingToolbar({
            pageSize: pageSize_LogonLoc,
            store: dsOtherLogonLoc,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_LogonLoc=this.pageSize;
				         }
		        }
        })		
    
    var comboxOtherLogonLoc = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '登录科室',							
		id: 'comboxOtherLogonLoc',
		loadByIdParam : 'rowid',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('comboxOtherLogonLoc'),
		//hiddenName:'RESCTLOCDR',//不能与id相同
		allQuery:'',
		forceSelection: true,
		selectOcnFocus:false,
		typeAhead:true,
		mode:'remote',
		pageSize:10,
		minChars: 0,
		listWidth:250,
		valueField:'CTLOCRowID',
		displayField:'CTLOCDesc',
		store:new Ext.data.JsonStore({
			autoLoad: true,
			url:BindingLoc,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'CTLOCRowID',
			fields:['CTLOCRowID','CTLOCDesc'],
			remoteSort: true,
			sortInfo: {field: 'CTLOCRowID', direction: 'ASC'}
		})
	});
	
	var comboGroup = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '安全组',							
		id: 'comboGroup',
		loadByIdParam : 'rowid',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('comboGroup'),
		//hiddenName:'RESCTLOCDR',//不能与id相同
		allQuery:'',
		forceSelection: true,
		selectOcnFocus:false,
		typeAhead:true,
		queryParam:"desc",
		mode:'remote',
		pageSize:10,
		minChars: 0,
		listWidth:250,
		valueField:'SSGRPRowId',
		displayField:'SSGRPDesc',
		store:new Ext.data.JsonStore({
			autoLoad: true,
			url:BindingGroup,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'SSGRPRowId',
			fields:['SSGRPRowId','SSGRPDesc'],
			remoteSort: true,
			sortInfo: {field: 'SSGRPRowId', direction: 'ASC'}
		})
	});
	
	var comboHospital = new Ext.BDP.Component.form.ComboBox({
		fieldLabel: '医院',							
		id: 'comboHospital',
		loadByIdParam : 'rowid',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('comboHospital'),
		//hiddenName:'RESCTLOCDR',//不能与id相同
		allQuery:'',
		forceSelection: true,
		selectOcnFocus:false,
		typeAhead:true,
		mode:'remote',
		pageSize:10,
		queryParam:"desc",
		minChars: 0,
		listWidth:250,
		valueField:'HOSPRowId',
		displayField:'HOSPDesc',
		store:new Ext.data.JsonStore({
			autoLoad: true,
			url:BindingHospital,
			root: 'data',
			totalProperty: 'total',
			idProperty: 'HOSPRowId',
			fields:['HOSPRowId','HOSPDesc'],
			remoteSort: true,
			sortInfo: {field: 'HOSPRowId', direction: 'ASC'}
		})
	});
		
    var btnOtherLogonLoc = new Ext.Button({
        id:'btnOtherLogonLoc',
        iconCls:'icon-add',
        text:'增加',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnOtherLogonLoc'),
        handler:function(){
        	 if(Ext.getCmp("comboxOtherLogonLoc").getValue()=="")
        	 {
        	 	Ext.Msg.show({
					title:'提示',
					msg:'请选择登录科室!',
					minWidth:200,
					icon:Ext.Msg.ERROR,
					buttons:Ext.Msg.OK
				});
        	 }
        	 else{
        	 		//Ext.MessageBox.wait('正在关联中,请稍候...','提示');
					Ext.Ajax.request({
						url:SAVE_URL_OtherLogonLoc,
						method:'POST',
						params:{
							'OTHLLParRef':Ext.getCmp("hidden_SSUSRRowId").getValue(),
							'OTHLLCTLOCDR':Ext.getCmp("comboxOtherLogonLoc").getValue(),
							'OTHLLUserGroupDR':Ext.getCmp("comboGroup").getValue(),
							'OTHLLHospitalDR':Ext.getCmp("comboHospital").getValue()
						},
						callback:function(options, success, response){
							//Ext.MessageBox.hide();
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								
								if(jsonData.success == 'true'){
									Ext.Msg.show({
										title:'提示',
										msg:'新增成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){
											gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc,OTHLLParRef:Ext.getCmp("hidden_SSUSRRowId").getValue()}});
											Ext.getCmp("comboxOtherLogonLoc").reset();
											Ext.getCmp("comboGroup").reset();
											Ext.getCmp("comboHospital").reset();
										}
									});
									
								}
								else{
									var errorMsg ='';
									if(jsonData.errorinfo){
										errorMsg='<br />错误信息:'+jsonData.errorinfo
									}
									Ext.Msg.show({
										title:'提示',
										msg:errorMsg,
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
        }
    });
    var OtherLogonLocEditwin = new Ext.Toolbar.Button({
		text : '修改',
		tooltip : '修改',
		iconCls : 'icon-update',
        id:'update_btn2',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn2'),
		handler : function() {
		if(gridOtherLogonLoc.selModel.hasSelection()){
        	 if(Ext.getCmp("comboxOtherLogonLoc").getValue()=="")
        	 {
        	 	Ext.Msg.show({
					title:'提示',
					msg:'请选择登录科室!',
					minWidth:200,
					icon:Ext.Msg.ERROR,
					buttons:Ext.Msg.OK
				});
        	 }
        	 else{
        	 		
					Ext.Ajax.request({
						url:SAVE_URL_OtherLogonLoc,
						method:'POST',
						params:{
							'OTHLLRowId':Ext.getCmp("hidden_OTHLLRowId").getValue(),
							'OTHLLParRef':Ext.getCmp("hidden_SSUSRRowId").getValue(),
							'OTHLLCTLOCDR':Ext.getCmp("comboxOtherLogonLoc").getValue(),
							'OTHLLUserGroupDR':Ext.getCmp("comboGroup").getValue(),
							'OTHLLHospitalDR':Ext.getCmp("comboHospital").getValue()
						},
						callback:function(options, success, response){
							//Ext.MessageBox.hide();
							if(success){
								var jsonData = Ext.util.JSON.decode(response.responseText);
								
								if(jsonData.success == 'true'){
									Ext.Msg.show({
										title:'提示',
										msg:'修改成功!',
										icon:Ext.Msg.INFO,
										buttons:Ext.Msg.OK,
										fn:function(btn){
											gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc,OTHLLParRef:Ext.getCmp("hidden_SSUSRRowId").getValue()}});
											Ext.getCmp("comboxOtherLogonLoc").reset();
											Ext.getCmp("comboGroup").reset();
											Ext.getCmp("comboHospital").reset();
										}
									});
									
								}
								else{
									var errorMsg ='';
									if(jsonData.errorinfo){
										errorMsg='<br />错误信息:'+jsonData.errorinfo
									}
									Ext.Msg.show({
										title:'提示',
										msg:errorMsg,
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
		}
		else{
			Ext.Msg.show({
						title:'提示',
						msg:'请选择需要修改的行!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
			});
		}
		}
	});
	var OtherLogonLocDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
        id:'del_btn2',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn2'),
		handler : function() {
			if(gridOtherLogonLoc.selModel.hasSelection()){
			Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
			if(btn=='yes'){
				Ext.MessageBox.wait('数据删除中,请稍候...','提示');
				var gsm = gridOtherLogonLoc.getSelectionModel();//获取选择列
                var rows = gsm.getSelections();//根据选择列获取到所有的行
				Ext.Ajax.request({
					url:DELETE_OtherLogonLoc_URL,
					method:'POST',
					params:{
					        'id':rows[0].get('OTHLLRowId')
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
										Ext.getCmp("comboxOtherLogonLoc").reset();
										Ext.getCmp("comboGroup").reset();
										Ext.getCmp("comboHospital").reset();
										/*var startIndex = gridOtherLogonLoc.getBottomToolbar().cursor;
										gridOtherLogonLoc.getStore().load({params:{start:startIndex, limit:pagesize}});*/
										Ext.BDP.FunLib.DelForTruePage(gridOtherLogonLoc,pageSize_LogonLoc);
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
		
	var btnRefresh=new Ext.Button({
        id:'btnRefresh2',
        iconCls:'icon-refresh',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh2'),
        text:'重置',
        handler:function(){
			Ext.getCmp("comboxOtherLogonLoc").reset();
			Ext.getCmp("comboGroup").reset();
			Ext.getCmp("comboHospital").reset();
			gridOtherLogonLoc.getStore().load({params:{start:0, limit:pageSize_LogonLoc}});
			//grid.getStore().load({params:{start:0, limit:pagesize}});
        }
	});
	var tbbutton=new Ext.Toolbar(
		{
			enableOverflow: true,			
			items:[
			btnOtherLogonLoc,
            '-',
			OtherLogonLocEditwin,
            '-',
            OtherLogonLocDel,
            '-',
            btnRefresh,
            '->'
            ]
		}
	);
	

		
    var tbOtherLogonLoc=new Ext.Toolbar({
        id:'tbOtherLogonLoc',
        items:[
        	'登录科室:',
            comboxOtherLogonLoc,
            '-',
            '安全组:',
            comboGroup,
            '-',
            '医院:',
            comboHospital,
            '-',               
            {
				xtype: 'textfield',
				id: 'hidden_SSUSRRowId',
				hidden : true
			},
			{
				xtype: 'textfield',
				id: 'hidden_OTHLLRowId',
				hidden : true
			},
            '->'
            //btnHelp
        ],
		listeners:{
        render:function(){
        	 tbbutton.render(gridOtherLogonLoc.tbar)  //tbar.render(panel.bbar)这个效果在底部
        }
    }
	});
	
	// 关联科室修改按钮
			
	var smOtherLogonLoc = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    var gridOtherLogonLoc = new Ext.grid.GridPanel({
	id:'gridOtherLogonLoc',
	region: 'center',
	width:700,
	height:400,
	//border:false,
	//hideHeaders:true,
	closable:true,
    store: dsOtherLogonLoc,
    trackMouseOver: true,
    columns: [
            smOtherLogonLoc,
            { header: 'OTHLLRowId', width: 160, sortable: true, dataIndex: 'OTHLLRowId', hidden : true},
            //{ header: '科室', width: 160, sortable: true, dataIndex: 'OTHLLParRef' },
			{ header: '用户名', width: 100, sortable: true, dataIndex: 'SSUSRName' },   
            { header: '登录科室', width: 120, sortable: true, dataIndex: 'CTLOCDesc' },
			{ header: '安全组', width: 120, sortable: true, dataIndex: 'SSGRPDesc' },
            { header: '医院', width: 120, sortable: true, dataIndex: 'HOSPDesc'},
            { header: '登录科室ID', width: 120, sortable: true, dataIndex: 'OTHLLCTLOCDR', hidden : true },
			{ header: '安全组ID', width: 120, sortable: true, dataIndex: 'OTHLLUserGroupDR', hidden : true },
            { header: '医院ID', width: 120, sortable: true, dataIndex: 'OTHLLHospitalDR', hidden : true }
        ],
    stripeRows: true,
    loadMask: { msg: '数据加载中,请稍候...' },
    //title: '所在科室',
    // config options for stateful behavior
    stateful: true,
    viewConfig: {
			forceFit: true
	},
	bbar:pagingOtherLogonLoc ,
	tbar:tbOtherLogonLoc,
		
    stateId: 'gridOtherLogonLoc'
    
});

gridOtherLogonLoc.on("rowclick",function(grid,rowIndex,e){
	var _record = gridOtherLogonLoc.getSelectionModel().getSelected();//records[0]
	Ext.getCmp("hidden_OTHLLRowId").reset();
    Ext.getCmp("hidden_OTHLLRowId").setValue(_record.get('OTHLLRowId'));
	Ext.getCmp("comboxOtherLogonLoc").reset();
    Ext.getCmp("comboxOtherLogonLoc").setValue(_record.get('OTHLLCTLOCDR'));
    Ext.getCmp("comboGroup").reset();
    Ext.getCmp("comboGroup").setValue(_record.get('OTHLLUserGroupDR'));
    Ext.getCmp("comboHospital").reset();
    Ext.getCmp("comboHospital").setValue(_record.get('OTHLLHospitalDR'));
    
});	

function getOtherLogonLocPanel(){
	var winOtherLogonLocPanel = new Ext.Window({
			title:'',
			width:800,
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
			items: gridOtherLogonLoc,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
	//gridOtherLogonLoc.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
  	return winOtherLogonLocPanel;
}
	
	
		
	/**--------------------↑其它登录科室部分---------------------------**/	
