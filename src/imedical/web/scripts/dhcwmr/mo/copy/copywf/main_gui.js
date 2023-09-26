var objScreen = new Object();
function InitViewport()
{
	var obj = objScreen;
	obj.QryFlag = 0;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","查询日期");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","至");
	
	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "病案号"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,text : '查找'
	});
	
	obj.btnRegedit = new Ext.Button({
		id : 'btnRegedit'
		,iconCls : 'icon-save'
		,width : 80
		,anchor : '100%'
		,text : '登记'
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
			,{name: 'Money', mapping: 'Money'}
		])
	});
	obj.gridCopy = new Ext.grid.GridPanel({
		id : 'gridCopy'
		,store : obj.gridCopyStore
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,tbar : [
			{id:'msggridCopy',text:'复印记录',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->',{text:'病案号',style:'font-weight:bold;font-size:15px;',xtype:'label'},obj.txtMrNo,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '序号', width: 80, dataIndex: 'SerialNumber', align: 'center'}
			,{header: '姓名', width: 80, dataIndex: 'PatName', align: 'center'}
			,{header: '病案号', width: 60, dataIndex: 'MrNo', align: 'center'}
			,{header: '复印日期', width: 70, dataIndex: 'RegDate', align: 'center'}
			,{header: '复印时间', width: 70, dataIndex: 'RegTime', align: 'center'}
			,{header: '复印状态', width: 70, dataIndex: 'StatusDesc', align: 'center'}
			,{header: '复印目的', width: 120, dataIndex: 'PurposeDescs', align: 'left',
					renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var AimDescs = rd.get('PurposeDescs');
					return AimDescs;
				}
			}
			,{header: '复印内容', width: 120, dataIndex: 'ContentDescs', align: 'center',
					renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var ContentDescs = rd.get('ContentDescs');
					return ContentDescs;
				}
			}
			,{header: '备注', width: 100, dataIndex: 'Note', align: 'center'}
			,{header: '退费',  id : 'RetFee', width: 80, dataIndex: '', align: 'center' ,
				renderer : function(v, m, rd, r, c, s){
					var RecordID  = rd.get("CopyRecordID");
					var Status = rd.get("Status");
					if (Status=="CH")
						return " <a href='#' onclick='objScreen.RetFee(\""+RecordID+"\",\"\");'>退费</a>";
					else return "";
				}
			},{header: '作废',  id : 'Canecl', width: 80, dataIndex: '', align: 'center' ,
				renderer : function(v, m, rd, r, c, s){
					var RecordID  = rd.get("CopyRecordID");
					var Status = rd.get("Status");
					if ((Status=="RE")||(Status=="BO")||(Status=="RF"))
						return " <a href='#' onclick='objScreen.cancel(\""+RecordID+"\",\"\");'>作废</a>";
					else return "";
				}
			}
			,{header: '金额', id :'Money', width: 80 , dataIndex: 'Money' , align: 'center'}
			,{header: '发票号',id :'InvNo', width: 80 , dataIndex: 'InvNo' , align: 'center'}
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
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			{
				region:'north'
				,height: 35
				,layout:'column'
				,frame: true
				,items:[
					{
						width: 210
						,layout:'form'
						,labelWidth : 40
						,labelAlign : 'right'
						,items:[obj.cboHospital]
					},{
						width: 160
						,layout:'form'
						,labelWidth : 70
						,labelAlign : 'right'
						,items:[obj.cboMrType]
					},{
						width: 180
						,layout:'form'
						,labelWidth : 70
						,labelAlign : 'right'
						,items:[obj.dfDateFrom]
					},{
						width: 140
						,layout:'form'
						,labelWidth : 30
						,labelAlign : 'right'
						,items:[obj.dfDateTo]
					},{
						width: 5
						,height:1
					},{
						width: 80
						,layout:'form'
						,items:[obj.btnQuery]
					}
				]
			},obj.gridCopy
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
		param.Arg6 = '';
		param.Arg7 = '';
		param.Arg8 = '';
		param.Arg9 = '';
		param.ArgCnt = 9;
	});
	InitViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}