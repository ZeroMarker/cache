var objScreen = new Object();
function InitViewPort(){
    var obj = objScreen;
	obj.AdmType = AdmType;
	obj.AdmTypeDesc = AdmTypeDesc;
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","就诊日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	obj.cboLoc = Common_ComboToLoc("cboLoc","科室","E","",obj.AdmType,"cboHospital");
	obj.txtAdmType = Common_TextField("txtAdmType","就诊类型");
	
	//obj.txtRegNo = Common_TextField("txtRegNo","登记号");
	obj.txtRegNo = new Ext.form.TextField({
		id : "txtRegNo"
		,fieldLabel : "登记号"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	obj.btnQry = new Ext.Button({
		id : 'btnQry'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 70
		,anchor : '100%'
		,text : '导出Excel'
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">病案类型</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">病案号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作类别</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="20%">操作科室</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作员</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">操作时间</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">卷号</td>',
				'</tr>',
				'<tbody>',
					'<tpl for="Record">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{MrTypeDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{MrNo}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{OperType}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{RecLoc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{RecUser}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{RecDate} {RecTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{VolumeID}</td>',
						'</tr>',
					'</tpl>',
					'{[this.displayEpisodeID(values)]}',
				'</tbody>',
			'</table>',
		'</div>',
		{
			displayEpisodeID : function(values){
				var tabEv = '';
				var row = values.length;
				var EpisodeID = values.EpisodeID;
				tabEv += '<tr  class="' + ((row + 1) % 2 == 1 ? 'RowEven' : 'RowOdd') + '" style="border-bottom:1px #BDBDBD solid;">',
				tabEv += 	'<td colspan="8" align="left">&nbsp;&nbsp;就诊号：' + EpisodeID + '</td>'
				tabEv += '</tr>'
				return tabEv;
			}
		}
	);
	
	obj.RowExpander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.XTemplate(
			'<div id="divCtrlDtl-{EpisodeID}"></div>'
        )
    });
	
	obj.ReceiptGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ReceiptGridStore = new Ext.data.Store({
		proxy: obj.ReceiptGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EpisodeID'
		}, 
		[
			{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'AdmLocID', mapping: 'AdmLocID'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'AdmTime', mapping: 'AdmTime'}
			,{name: 'VolumeID', mapping : 'VolumeID'}
			,{name: 'MrTypeID', mapping: 'MrTypeID'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'MrClass', mapping: 'MrClass'}
			,{name: 'ReceiptType', mapping: 'ReceiptType'}
			,{name: 'MainID', mapping: 'MainID'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.ReceiptGrid = new Ext.grid.GridPanel({
		id : 'ReceiptGrid'
		,store : obj.ReceiptGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [
			{id:'msgReceiptGrid',text:'接诊日志查询',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->',{text:'登记号：',style:'font-weight:bold;font-size:18px;',xtype:'label'},obj.txtRegNo,{text:'',width:50,xtype:'label'}
			,'-',obj.btnQry,'-',obj.btnExport,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID  = rd.get("VolumeID");
					var MrClass   = rd.get("MrClass");
					var ReceiptType = rd.get("ReceiptType");
					var MainID    = rd.get("MainID");
					if (VolumeID == ''){
						if ((MrClass == 'O')&&(ReceiptType == 'M')&&(MainID != '')){
							//门诊病案按病人分号，不需要重复接诊
						} else {
							m.attr = 'style="background:#FF5151;"';
						}
					}
					return v;
				}
			}
			,{header: '操作', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID  = rd.get("VolumeID");
					var EpisodeID = rd.get("EpisodeID");
					var MrNo      = rd.get("MrNo");
					var MrClass   = rd.get("MrClass");
					var ReceiptType = rd.get("ReceiptType");
					var MainID    = rd.get("MainID");
					if (VolumeID == ''){
						if ((MrClass == 'O')&&(ReceiptType == 'M')&&(MainID != '')){
							return "";
						} else {
							return "<a href='#' onclick='objScreen.GroupReceipt(\"" + EpisodeID + "\",\"" + MrNo + "\");'><b>接诊</b></a>";
						}
					} else {
						return "<a href='#' onclick='objScreen.GroupUnReceipt(\"" + EpisodeID + "\");'>取消接诊</a>";
					}
				}
			}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '就诊类型', width: 60, dataIndex: 'AdmType', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '就诊时间', width: 60, dataIndex: 'AdmTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 150, dataIndex: 'AdmLoc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 150, dataIndex: 'AdmWard', sortable: false, menuDisabled:true, align: 'left'}
		]
		,plugins: obj.RowExpander
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.ReceiptGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 35,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				items : [
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.txtAdmType]
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
						width:240
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboLoc]
					}
					/*,{
						width:15
					},{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,items: [obj.txtRegNo]
					}*/
				]
			}
			,obj.ReceiptGrid
		]
	});
	
	obj.ReceiptGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.ReceiptQry';
			param.QueryName = 'QuryReceiptByDate';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = obj.AdmType;
			param.Arg3 = Common_GetValue("dfDateFrom");
			param.Arg4 = Common_GetValue("dfDateTo");
			param.Arg5 = Common_GetValue("cboLoc");
			param.Arg6 = Common_GetValue("txtRegNo");
			param.ArgCnt = 6;
	});
	
	InitViewPortEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}