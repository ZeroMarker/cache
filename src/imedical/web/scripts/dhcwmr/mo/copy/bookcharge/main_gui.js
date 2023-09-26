var objScreen = new Object();
function InitViewport(){
	var obj = new Object();
	objScreen = obj;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","登记日期");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","至");
	
	var arrCopyStatus = [
		{id : 'cbgCopyStatus-RE', name : 'cbgCopyStatus-RE', boxLabel : '登记', inputValue : 'RE', checked : true}
		,{id : 'cbgCopyStatus-BO', name : 'cbgCopyStatus-BO', boxLabel : '装订', inputValue : 'BO', checked : true}
		,{id : 'cbgCopyStatus-CH', name : 'cbgCopyStatus-CH', boxLabel : '收费', inputValue : 'CH', checked : true}
		,{id : 'cbgCopyStatus-RF', name : 'cbgCopyStatus-RF', boxLabel : '退费', inputValue : 'RF', checked : false}
		,{id : 'cbgCopyStatus-U', name : 'cbgCopyStatus-U', boxLabel : '作废', inputValue : 'U', checked : false}
	]
	obj.cbgCopyStatus = new Ext.form.CheckboxGroup({
		id : 'cbgCopyStatus'
		,fieldLabel : '状态'
		,labelSeparator :''
		,xtype : 'checkboxgroup'
		,columns : 5
		,items : arrCopyStatus
		,width : 10
		,anchor : '100%'
	});
	
	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "病案号"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 130
	});
	
	obj.txtPapmiNo = new Ext.form.TextField({
		id : "txtPapmiNo"
		,fieldLabel : "登记号"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 130
	});
	
	obj.txtBarCode = new Ext.form.TextField({
		id : "txtBarCode"
		,fieldLabel : "登记条码"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 130
	});
	
	obj.txtInvNo = new Ext.form.TextField({
		id : "txtInvNo"
		,fieldLabel : "发票号"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 130
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.gridCopyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridCopyStore = new Ext.data.Store({
		proxy: obj.gridCopyStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CopyRecordID'
		}, 
		[
			{name: 'CopyRecordID', mapping: 'CopyRecordID'}
			,{name: 'MrType', mapping: 'MrType'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'RegDate', mapping: 'RegDate'}
			,{name: 'RegTime', mapping: 'RegTime'}
			,{name: 'ClientName', mapping: 'ClientName'}
			,{name: 'ClientRelation', mapping: 'ClientRelation'}
			,{name: 'ClientRelationDesc', mapping: 'ClientRelationDesc'}
			,{name: 'CardType', mapping: 'CardType'}
			,{name: 'CardTypeDesc', mapping: 'CardTypeDesc'}
			,{name: 'PersonalID', mapping: 'PersonalID'}
			,{name: 'Telephone', mapping: 'Telephone'}
			,{name: 'Address', mapping: 'Address'}
			,{name: 'PaperNumber', mapping: 'PaperNumber'}
			,{name: 'Purpose', mapping: 'Purpose'}
			,{name: 'PurposeDescs', mapping: 'PurposeDescs'}
			,{name: 'Content', mapping: 'Content'}
			,{name: 'ContentDescs', mapping: 'ContentDescs'}
			,{name: 'AdmInfos', mapping: 'AdmInfos'}
			,{name: 'SerialNumber', mapping: 'SerialNumber'}
			,{name: 'Note', mapping: 'Note'}
			,{name: 'InvNo', mapping: 'InvNo'}
		])
	});
	
	obj.gridCopy = new Ext.grid.GridPanel({
		id : 'gridCopy'
		,store : obj.gridCopyStore
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,tbar : [
			{id:'msggridCopy',text:'复印登记记录',style:'font-weight:bold;font-size:14px;width:200px;',xtype:'label'},'-'
			,{text:'登记条码：',style:'font-weight:bold;font-size:14px;',xtype:'label'},obj.txtBarCode,'-'
			,{text:'病案号：',style:'font-weight:bold;font-size:14px;',xtype:'label'},obj.txtMrNo,'-'
			,{text:'登记号：',style:'font-weight:bold;font-size:14px;',xtype:'label'},obj.txtPapmiNo,'-'
			,{text:'发票号：',style:'font-weight:bold;font-size:14px;',xtype:'label'},obj.txtInvNo,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '序号', width: 80, dataIndex: 'SerialNumber', align: 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', align: 'center'}
			,{header: '病案号', width: 60, dataIndex: 'MrNo', align: 'center'}
			,{header: '登记日期', width: 70, dataIndex: 'RegDate', align: 'center'}
			,{header: '登记时间', width: 60, dataIndex: 'RegTime', align: 'center'}
			,{header: '状态', width: 40, dataIndex: 'StatusDesc', align: 'center'}
			,{header: '就诊信息', width: 160, dataIndex: 'AdmInfos', align: 'left',
					renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var AdmInfos = rd.get('AdmInfos');
					return AdmInfos;
				}
			}
			,{header: '复印目的', width: 100, dataIndex: 'PurposeDescs', align: 'left',
					renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var AimDescs = rd.get('PurposeDescs');
					return AimDescs;
				}
			}
			,{header: '复印内容', width: 100, dataIndex: 'ContentDescs', align: 'center',
					renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var ContentDescs = rd.get('ContentDescs');
					return ContentDescs;
				}
			}
			,{header: '备注', width: 100, dataIndex: 'Note', align: 'center'}
			,{header: '收费记录', width: 70, dataIndex: '', align: 'center' ,
				renderer : function(v, m, rd, r, c, s){
					var RecordID  = rd.get("CopyRecordID");
					return " <a href='#' onclick='objScreen.DisplayDetailWindow(\""+RecordID+"\",\"\");'>收费记录</a>";
				}
			}
			,{header: '发票号', width: 80 , dataIndex: 'InvNo' , align: 'center'}
			,{header: '登记号', width: 80 , dataIndex: 'PapmiNo' , align : 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridCopyStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,view:new Ext.grid.GridView({
			forceFit : true
		})
	});
	obj.InitViewport = new Ext.Viewport({
		id: 'InitViewport'
		,layout: 'border'
		,frame: true
		,items:[
			{
				region:'north'
				,layout:'column'
				,height: 35
				,frame: true
				,items:[
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:140
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					},{
						width:300
						,layout:'form'
						,labelWidth : 40
						,labelAlign : 'right'
						,items:[obj.cbgCopyStatus]
					},{
						width: 5
						,height: 1
					},{
						width:80
						,layout : 'form'
						,items:[obj.btnQuery]
					}
				]
			}
			,obj.gridCopy	
		]
	});
	
	obj.gridCopyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MOService.CopyRecordSrv';
		param.QueryName = 'QryCopyRecord';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("txtMrNo");
		param.Arg6 = Common_GetValue("txtPapmiNo");
		param.Arg7 = Common_GetValue("txtBarCode");
		param.Arg8 = Common_GetValue("cbgCopyStatus");
		param.Arg9 =  Common_GetValue("txtInvNo");
		param.ArgCnt = 9;
	});
	
	InitViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}