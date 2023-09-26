
function InitWarningDtlWin(aConfigCode, aWarningDate, aHospID, aDayCode, aLocID, aDataValue){
	var obj = new Object();
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">项目</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">级别</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="30%">摘要</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">时间</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">科室</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">病区</td>',
				'</tr>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{ItemDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ItemGroup}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{Summary}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActDate}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActDept}</td>',
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
	
	obj.WarningDtlGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.WarningDtlGridPanelStore = new Ext.data.Store({
		proxy: obj.WarningDtlGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EpisodeID'
		},[
			{name : 'EpisodeID', mapping : 'EpisodeID'}
			,{name : 'PatientID', mapping : 'PatientID'}
			,{name : 'CtrlDtl', mapping : 'CtrlDtl'}
			,{name : 'RegNo', mapping : 'RegNo'}
			,{name : 'PatName', mapping : 'PatName'}
			,{name : 'MrNo', mapping : 'MrNo'}
			,{name : 'Sex', mapping : 'Sex'}
			,{name : 'Age', mapping : 'Age'}
			,{name : 'AdmDate', mapping : 'AdmDate'}
			,{name : 'AdmTime', mapping : 'AdmTime'}
			,{name : 'LocID', mapping : 'LocID'}
			,{name : 'LocDesc', mapping : 'LocDesc'}
			,{name : 'LocGrp', mapping : 'LocGrp'}
			,{name : 'WardID', mapping : 'WardID'}
			,{name : 'WardDesc', mapping : 'WardDesc'}
			,{name : 'WardGrp', mapping : 'WardGrp'}
			,{name : 'RoomID', mapping : 'RoomID'}
			,{name : 'Room', mapping : 'Room'}
			,{name : 'BedID', mapping : 'BedID'}
			,{name : 'Bed', mapping : 'Bed'}
			,{name : 'BedPos', mapping : 'BedPos'}
			,{name : 'DocID', mapping : 'DocID'}
			,{name : 'DocName', mapping : 'DocName'}
			,{name : 'DisDate', mapping : 'DisDate'}
			,{name : 'DisTime', mapping : 'DisTime'}
			,{name : 'AdmStatus', mapping : 'AdmStatus'}
			,{name : 'InHospLocDesc', mapping : 'InHospLocDesc'}
			,{name : 'InHospWardDesc', mapping : 'InHospWardDesc'}
			,{name : 'InHospDays', mapping : 'InHospDays'}
			,{name : 'InLocDate', mapping : 'InLocDate'}
			,{name : 'InLocTime', mapping : 'InLocTime'}
			,{name : 'InWardDate', mapping : 'InWardDate'}
			,{name : 'InWardTime', mapping : 'InWardTime'}
		])
	});
	obj.WarningDtlGridPanel = new Ext.grid.GridPanel({
		id : 'WarningDtlGridPanel'
		,store : obj.WarningDtlGridPanelStore
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.RowExpander
			,{header: '登记号', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: true}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: true}
			,{header: '入院日期', width: 80, dataIndex: 'AdmDate', sortable: true}
			,{header: '科室', width: 150, dataIndex: 'LocDesc', sortable: true}
			,{header: '病区', width: 150, dataIndex: 'WardDesc', sortable: true}
			//,{header: '病房', width: 80, dataIndex: 'Room', sortable: true}
			,{header: '床位', width: 80, dataIndex: 'Bed', sortable: true}
			,{header: '床位置', width: 80, dataIndex: 'BedPos', sortable: true}
			,{header: '主管医生', width: 80, dataIndex: 'DocName', sortable: true}
			,{header: '状态', width: 50, dataIndex: 'AdmStatus', sortable: true}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
			,{header: '住院<br>天数', width: 50, dataIndex: 'InHospDays', sortable: true}
			,{header: '就诊号', width: 50, dataIndex: 'EpisodeID', sortable: true}
		]
		,plugins: obj.RowExpander
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	obj.WarningDtlWin = new Ext.Window({
		id : 'WarningDtlWin'
		,plain : true
		,maxinizable : true
		,maximized : true
		,collapsed : true
		,resizable : false
		,title : '暴发预警病人列表'
		,layout : 'fit'
		,height : 350
		,width : 800
		,modal: true
		,items:[
			obj.WarningDtlGridPanel
		]
	});
	obj.WarningDtlGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.BC.WarningSrv';
		param.QueryName = 'QryWarningDtl';
		param.Arg1 = aConfigCode;
		param.Arg2 = aWarningDate;
		param.Arg3 = aHospID;
		param.Arg4 = aDayCode;
		param.Arg5 = aLocID;
		param.Arg6 = aDataValue;
		
		param.ArgCnt = 6;
	});
	
	InitWarningDtlWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

