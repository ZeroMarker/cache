var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","出院日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.DischAdmGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.DischAdmGridStore = new Ext.data.Store({
		proxy: obj.DischAdmGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		},[
			{name: 'VolID', mapping : 'VolID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'DoctorName', mapping: 'DoctorName'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'EstimDischDate', mapping: 'EstimDischDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'EprDocStatus', mapping: 'EprDocStatus'}
			,{name: 'EprDocStatusDesc', mapping: 'EprDocStatusDesc'}
			,{name: 'EprNurStatus', mapping: 'EprNurStatus'}
			,{name: 'EprNurStatusDesc', mapping: 'EprNurStatusDesc'}
			,{name: 'EprPdfStatus', mapping: 'EprPdfStatus'}
			,{name: 'EprPdfStatusDesc', mapping: 'EprPdfStatusDesc'}
			,{name: 'EprNurStatus', mapping: 'EprNurStatus'}
			,{name: 'EprNurStatusDesc', mapping: 'EprNurStatusDesc'}
			,{name: 'EprPdfStatus', mapping: 'EprPdfStatus'}
			,{name: 'EprPdfStatusDesc', mapping: 'EprPdfStatusDesc'}
		])
	});
	obj.DischAdmGrid = new Ext.grid.GridPanel({
		id : 'DischAdmGrid'
		,store : obj.DischAdmGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var EpisodeID = rd.get("EpisodeID");
					var ret = "<a href='#' onclick='objScreen.LnkEprEditPage(\"" + EpisodeID + "\",\"\")'><font size='3'>" + v + "</font></a>";
					return ret;
				}
			}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '医生<br>提交', width: 50, dataIndex: 'EprDocStatusDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					var EprDocStatusDesc  = rd.get("EprDocStatusDesc");
					if (EprDocStatusDesc != '是'){
						m.attr = 'style="background:#FF5151;"';
					}
					return v;
				}
			}
			,{header: '医疗结算时间', width: 120, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '护士<br>提交', width: 50, dataIndex: 'EprNurStatusDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					var EprNurStatusDesc  = rd.get("EprNurStatusDesc");
					if (EprNurStatusDesc != '是'){
						m.attr = 'style="background:#FF5151;"';
					}
					return v;
				}
			}
			,{header: '最终结算时间', width: 120, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 130, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '主治医师', width: 60, dataIndex: 'DoctorName', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '', width: 0, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.DischAdmGridStore,
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
				height: 40,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:250
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboHospital]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					},{
						width:10
					},{
						width:70
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.btnQuery]
					}
				]
			}
			,obj.DischAdmGrid
		]
	});
	
	obj.DischAdmGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.VolLocDisQry';
			param.QueryName = 'QryVolListByLoc';
			param.Arg1 = Common_GetValue("cboMrType");
			param.Arg2 = Common_GetValue("dfDateFrom");
			param.Arg3 = Common_GetValue("dfDateTo");
			param.Arg4 = CTLocID;
			param.ArgCnt = 4;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}