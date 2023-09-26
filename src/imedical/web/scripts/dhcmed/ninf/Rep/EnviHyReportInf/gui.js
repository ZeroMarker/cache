var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	obj.txtDate = new Ext.form.DateField({
		id : 'txtDate'
		,fieldLabel : '检测月份'
		,plugins: 'monthPickerPlugin'
		,editable : false
		,format : 'Y-m'
		,width : 10
		,anchor : '100%'
		,value : new Date().dateFormat('Y-m')
	});
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"NINF");
	obj.cboLoc = Common_ComboToLoc("cboLoc","报告科室","E","","","cboSSHosp");
	//obj.cboLoc = Common_ComboToLoc("cboLoc","报告科室");
	obj.RepStatusDesc = Common_ComboRepStatus("RepStatusDesc","报告状态","NINFEnviHyReportStatus","^全部","90%");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,text : '查询'
	})
	obj.gridEnviHyReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridEnviHyReportStore = new Ext.data.Store({
		proxy: obj.gridEnviHyReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[ 
			{name: 'ReportID', mapping : 'ReportID'},
			{name: 'LocID', mapping : 'AskForLocID'},
			{name: 'LocDesc', mapping : 'AskForLocDesc'},
			{name: 'AskForUserDesc', mapping : 'AskForUserDesc'},
			{name: 'ItemID', mapping : 'ItemID'},
			{name: 'ItemDesc', mapping : 'ItemDesc'},
			{name: 'NormID', mapping : 'NormID'},
			{name: 'NormDesc', mapping : 'NormDesc'},
			{name: 'NormMax', mapping : 'NormMax'},
			{name: 'NormMin', mapping : 'NormMin'},
			{name: 'NormRange', mapping : 'NormRange'},
			{name: 'CenterNum', mapping : 'CenterNum'},
			{name: 'SurroundNum', mapping : 'SurroundNum'},
			{name: 'ItemObj', mapping : 'ItemObj'},
			{name: 'EHRDate', mapping : 'EHRDate'},
			{name: 'RepStatusCode', mapping : 'RepStatusCode'},
			{name: 'RepStatusDesc', mapping : 'RepStatusDesc'},
			{name: 'EHRResult', mapping : 'EHRResult'},
			{name: 'UnfinishCount', mapping : 'UnfinishCount'},
			{name: 'EHRPathogens', mapping : 'EHRPathogens'},
			{name: 'EHRAutoIsNorm', mapping : 'EHRAutoIsNorm'},
			{name: 'SpecimenTypeID', mapping : 'SpecimenTypeID'},
			{name: 'SpecimenTypeDesc', mapping : 'SpecimenTypeDesc'},
			{name: 'SpecimenNum', mapping : 'SpecimenNum'},
			{name: 'SpecIssueNum', mapping : 'SpecIssueNum'},
			{name: 'SpecUnissueNum', mapping : 'SpecUnissueNum'},
			{name: 'SpecReissueNum', mapping : 'AddSpecimenNum'},
			{name: 'RepResume', mapping : 'RepResume'},
			{name: 'EHRBarCode', mapping : 'EHRBarCode'},
			{name: 'EHICategID', mapping : 'EHICategID'},
			{name: 'EHICategDesc', mapping : 'EHICategDesc'},
			{name: 'EHRRepDate', mapping : 'EHRRepDate'},
			{name: 'EHRRepTime', mapping : 'EHRRepTime'},
			{name: 'EHRRepLocDesc', mapping : 'EHRRepLocDesc'},
			{name: 'EHRRepUserDesc', mapping : 'EHRRepUserDesc'}
		])
	});
	obj.gridEnviHyReport = new Ext.grid.EditorGridPanel({
		id : 'gridEnviHyReport'
		,store : obj.gridEnviHyReportStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer(),
			{header: '报告状态', width: 80, dataIndex: 'RepStatusDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 150, dataIndex: 'LocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '是否合格', width: 60, dataIndex: 'EHRAutoIsNorm', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value=="合格")
					{
						return "<b style='color:green;'>"+value+"</b>";
					}else{
					    return "<b style='color:red;'>"+value+"</b>";
					}
				}
			}
			,{header: '检测项目', width: 200, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '检测范围', width: 180, dataIndex: 'NormRange', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '项目对象', width: 100, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '标本<br>数量', width: 50, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var SpecIssueNum = rd.get('SpecIssueNum');
					SpecIssueNum = SpecIssueNum*1;
					var SpecimenNum = rd.get('SpecimenNum');
					SpecimenNum = SpecimenNum*1;
					if (SpecIssueNum == SpecimenNum){
						var str = '【' + rd.get('SpecIssueNum') + '】';
					} else if (SpecIssueNum>0) {
						var str = '【' + rd.get('SpecimenNum') + '/' + rd.get('SpecIssueNum') + '】';
					} else {
						var str = rd.get('SpecimenNum');
					}
					return str;
				}
			}
			,{header: '检测日期', width: 80, dataIndex: 'EHRDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '检测结果', width : 150,dataIndex: 'EHRResult',sortable: false,menuDisabled:true,align: 'left',
				renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value==""){
						//return " <a href='#' onclick='objScreen.ViewEnviHyReport(\""+(record.get('ReportID'))+"\")'>录入结果 </a>";
					}else{
						return " <a href='#' onclick='objScreen.ViewEnviHyReport(\""+(record.get('ReportID'))+"\")'><font size='2'>"+value+"</font></a>";
					}
				}
			}
			,{header: '未完成<br>数量', width: 50, dataIndex: 'UnfinishCount', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var UnfinishCount = rd.get('UnfinishCount');
					UnfinishCount = UnfinishCount*1;
					if (UnfinishCount < 0){
						var str = '【' + v + '】';
					}else{
						var str = '完成';
					}
					return str;
				}
			}
			,{header: '结果判定标准', width: 100, dataIndex: 'NormDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告日期', width: 80, dataIndex: 'EHRRepDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告时间', width: 70, dataIndex: 'EHRRepTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header : '报告科室',width : 150,dataIndex: 'EHRRepLocDesc', sortable: false,menuDisabled:true,align: 'left'}
			,{header: '报告人', width: 60, dataIndex: 'EHRRepUserDesc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridEnviHyReportStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						height: 35,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDate]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,boxMinWidth : 200
										,boxMaxWidth : 300
										,items: [obj.cboSSHosp]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,boxMinWidth : 200
										,boxMaxWidth : 300
										,items: [obj.cboLoc]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,boxMinWidth : 200
										,boxMaxWidth : 200
										,items: [obj.RepStatusDesc]
									},{
										width : 10
									},{
										width : 80
										,layout : 'form'
										,items: [obj.btnQuery]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.gridEnviHyReport
						]
					}
				]
			}
		]
	});
	
	obj.gridEnviHyReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.EnviHyReport';
		param.QueryName = 'QryEnviHyRep';
		param.Arg1 = Common_GetValue('txtDate');
		param.Arg2 = Common_GetValue('cboLoc');
		param.Arg3 = Common_GetValue('RepStatusDesc');
		param.Arg4 = Common_GetValue('cboSSHosp');
		param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

