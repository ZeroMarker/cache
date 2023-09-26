function InitCasesX(){
	var obj = new Object();
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"EPD");
	obj.cboLoc = Common_ComboToLoc("cboLoc","就诊科室","E|EM","","","cboSSHosp");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	
	obj.cbgAdmType = new Ext.form.CheckboxGroup({
		id : 'cbgAdmType'
		,fieldLabel : '就诊类型'
		,xtype : 'checkboxgroup'
		,columns : 3
		,height : 24
		,anchor : '99%'
		,items : [
			{id : 'I', boxLabel : '住院', name : 'I', inputValue : 'I', checked : false}
			,{id : 'O', boxLabel : '门诊', name : 'O', inputValue : 'O', checked : false}
			,{id : 'E', boxLabel : '急诊', name : 'E', inputValue : 'E', checked : false}
		]
	});
	
	 obj.GetAdmType= function() {
		var cbgAdmType = obj.cbgAdmType.getValue(), selStatus = "";
		for (var i=0; i<cbgAdmType.length; i++) {
			selStatus = selStatus + cbgAdmType[i].getName() + ",";
		}
		if (selStatus!="") { selStatus = selStatus.substring(0, selStatus.length-1); }
		return selStatus;
	}
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'	
		,iconCls : 'icon-find'
		,width : 80
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出'
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">项目</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">级别</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="30%">摘要</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">结果日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">操作员</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">发生日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">科室</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">病区</td>',
				'</tr>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{ItemDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ItemGroup}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{Summary}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActDate} {ActTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActUser}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{OccurDate} {OccurTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActLoc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActWard}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	obj.RowExpander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.XTemplate(
			'<div id="divCtrlDtl-{EpisodeID}"></div>'
        )
    });
	
	obj.gridCasesXStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridCasesXStore = new Ext.data.Store({
		proxy: obj.gridCasesXStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
		
			{name: 'CasesXID', mapping : 'CasesXID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Birthday', mapping: 'Birthday'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'PersonalID', mapping: 'PersonalID'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'AdmitTime', mapping: 'AdmitTime'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'DisTime', mapping: 'DisTime'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmRoom', mapping: 'AdmRoom'}
			,{name: 'AdmBed', mapping: 'AdmBed'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
			,{name: 'ActDate', mapping: 'ActDate'}
			,{name: 'ActLoc', mapping: 'ActLoc'}
			,{name: 'ActDiagnos', mapping: 'ActDiagnos'}
			,{name: 'LnkResults', mapping: 'LnkResults'}
			,{name: 'LnkResultsDesc', mapping: 'LnkResultsDesc'}
			,{name: 'EpdStatusCode', mapping: 'EpdStatusCode'}
			,{name: 'EpdStatusDesc', mapping: 'EpdStatusDesc'}
			,{name: 'EpdDiagnos', mapping: 'EpdDiagnos'}
			,{name: 'Opinion', mapping: 'Opinion'}
			
		])
		
	});
	obj.gridCasesX = new Ext.grid.GridPanel({
		id : 'gridCasesX'
		,store : obj.gridCasesXStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
		    obj.RowExpander
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false}
			,{header: '患者姓名', width: 80, dataIndex: 'PatName', sortable: false}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '触发诊断', width: 100, dataIndex: 'ActDiagnos', sortable: false, align: 'left'}
			,{header: '关联监控结果', width: 100, dataIndex: 'LnkResultsDesc', sortable: false, align: 'left'}
			,{header: '当前状态', width: 100, dataIndex: 'EpdStatusDesc', sortable: false
				,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					if (value=="") return "";
					var CasesXID = record.get('CasesXID');
					var EpisodeID =record.get('EpisodeID')
					var strRet = "";
					strRet += "<A href='#' onclick='DisplayCasesHandle(" + CasesXID +","+EpisodeID+");'>" + value + "</A>";
					metaData.attr = 'style="white-space:normal;"';
					return strRet;
					
				}
			}
			,{header: '确诊诊断', width: 100, dataIndex: 'EpdDiagnos', sortable: false, align: 'left'}
			,{header: '处置意见', width: 100, dataIndex: 'Opinion', sortable: false, align: 'left'}
		    ,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: false}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: false}
			,{header: '科室', width: 120, dataIndex: 'AdmLoc', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'AdmWard', sortable: true}
			,{header: '就诊号', width: 80, dataIndex: 'EpisodeID', sortable: false}		
			]
			,bbar: new Ext.PagingToolbar({
			pageSize : 30,
			store : obj.gridCasesXStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		    })
		  ,plugins: obj.RowExpander
	});
	
		obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'center'
				,frame : true
				,items:[obj.gridCasesX]
			},{
				layout : 'form'
				,region : 'north'
				,height : 75
				,frame : true
				,buttonAlign : 'center'
				,items :[
					{
						layout : 'column'
						,items : [
							{
								width: 180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.cboSSHosp]
							},{
								width:160
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateFrom]
							},{
								width:160
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateTo]
							},{
								width: 270
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cbgAdmType]
							},{
								width : 270
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboLoc]
							}
						]
					}
				]
				,buttons : [obj.btnQuery,obj.btnExport]
			}
		]
	});
	obj.gridCasesXStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.CasesXSrv';
			param.QueryName = 'QryCasesXByDate';
			param.Arg1 = SubjectCode;
			param.Arg2 = obj.txtDateFrom.getRawValue();
			param.Arg3 = obj.txtDateTo.getRawValue();
			param.Arg4 = Common_GetValue("cboLoc");
			param.Arg5 = Common_GetValue("cboSSHosp");
			param.Arg6 = obj.GetAdmType();
			param.ArgCnt = 6;
	});
	InitCasesXEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

