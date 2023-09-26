var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	obj.EnviHyRepQueryArg1 = "";
	obj.EnviHyRepQueryArg2 = "";
	obj.EnviHyRepQueryArg3 = "";
	obj.EnviHyRepQueryArg4 = "";
	obj.EnviHyRepQueryArg5 = "";
	
	obj.MaterialBills = new Object();
	obj.MaterialBills.LocIndex = new Array();
	obj.MaterialBills.LocData = new Array();
	obj.CurrBarCode = "";
	
    obj.mnuMenu = new Ext.menu.Menu({
        items : [
		   {
			   id : 'mnuReceive',
			   text : '<B>接收标本<B/>',
			   iconCls : ''
		   },{
			   id : 'mnuResult',
			   text : '<B>录入结果<B/>',
			   iconCls : ''
		   },{
			   id : 'mnuPrintReport',
			   text : '<B>打印报告<B/>',
			   iconCls : ''
		   }
        ]
    })
	
	var curDate = new Date();
	var mthFirstDay = curDate.format("Y") +"-" +curDate.format("m") + "-01";
	obj.txtDateFrom = new Ext.form.DateField({
		id : 'txtDateFrom'
		,fieldLabel : '开始日期'
		,editable : false
		,format : 'Y-m-d'
		,width : 10
		,anchor : '100%'
		,value : mthFirstDay
	});
	obj.txtDateTo = new Ext.form.DateField({
		id : 'txtDateTo'
		,fieldLabel : '结束日期'
		,editable : false
		,format : 'Y-m-d'
		,width : 10
		,anchor : '100%'
		,value : new Date().dateFormat('Y-m-d')
	});
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"NINF");
    obj.cboLoc = Common_ComboToLoc("cboLoc","科室","","","","cboSSHosp");
	
	obj.btnMDBat = new Ext.Button({
		id : 'btnMDBat'
		//,iconCls : 'icon-export'
		,width : 10
		,text : '材料发放'
		,anchor : '100%'
	});
	obj.btnRstBat = new Ext.Button({
		id : 'btnRstBat'
		//,iconCls : 'icon-export'
		,width : 10
		,text : '零值处理'
		,anchor : '100%'
	});
	obj.btnPrintBar = new Ext.Button({
		id : 'btnPrintBar'
		//,iconCls : 'icon-print'
		,width : 10
		,text : '打印条码'
		,anchor : '100%'
	});
	obj.txtAreaBar =  new Ext.form.TextField({
		id : 'txtAreaBar'
		,selectOnFocus:true
		,fieldLabel : '条码区'
		,style: 'font-weight:bold;font-size:16'
		,labelStyle: 'font-weight:bold;font-size:14'
		,width : 80
		,height : 22
		,anchor : '100%'
	});
	obj.txtEnviHyResult =  new Ext.form.TextField({
		id : 'txtEnviHyResult'
		,selectOnFocus:true
		,fieldLabel : '菌落数'
		,style: 'font-weight:bold;font-size:16'
		,labelStyle: 'font-weight:bold;font-size:14'
		,width : 80
		,height : 22
		,anchor : '100%'
	});
	obj.txtEnviHyPathogen =  new Ext.form.TextField({
		id : 'txtEnviHyPathogen'
		,selectOnFocus:true
		,fieldLabel : '致病菌'
		,style: 'font-weight:bold;font-size:16'
		,labelStyle: 'font-weight:bold;font-size:14'
		,width : 80
		,height : 22
		,anchor : '100%'
	});
	
	obj.cbBar = new Ext.form.RadioGroup({
		id:'cbBar'
		,columns:4
		,items: [
			{boxLabel: '<span style="font-weight:bold;font-size:15px">发放材料</span>', name: 'cb-col',inputValue: '1'},
			{boxLabel: '<span style="font-weight:bold;font-size:15px">接收标本</span>', name: 'cb-col',inputValue: '2'},
			{boxLabel: '<span style="font-weight:bold;font-size:15px">录入结果</span>', name: 'cb-col',inputValue: '3'},
			{boxLabel: '<span style="font-weight:bold;font-size:15px">查&nbsp;&nbsp;&nbsp;&nbsp;询</span>', name: 'cb-col',inputValue: '0', checked: true}
		]
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">条码号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">状态</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">时间</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作员</td>',
				'</tr>',
				'<tbody>',
					'<tpl for=".">',
						'<tpl if="CurrFlag==0">',
							'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
						'</tpl>',
						'<tpl if="CurrFlag==1">',
							'<tr  style="border-bottom:1px #BDBDBD solid;background-color:#FF00FF;">',
						'</tpl>',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{BarCode}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{StatusDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{LogDate}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{LogTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{LogUser}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	
	obj.RowExpander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.XTemplate(
			'<div id="divBarCodeDtl-{ReportID}"></div>'
        )
    });
	
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
			{name: 'RepBarCode', mapping : 'RepBarCode'},
			{name: 'RepStatusCode', mapping : 'RepStatusCode'},
			{name: 'RepStatusDesc', mapping : 'RepStatusDesc'},
			{name: 'AskForLocID', mapping : 'AskForLocID'},
			{name: 'AskForLocDesc', mapping : 'AskForLocDesc'},
			{name: 'AskForUserID', mapping : 'AskForUserID'},
			{name: 'AskForUserDesc', mapping : 'AskForUserDesc'},
			{name: 'ItemID', mapping : 'ItemID'},
			{name: 'ItemDesc', mapping : 'ItemDesc'},
			{name: 'ItemCategID', mapping : 'ItemCategID'},
			{name: 'ItemCategDesc', mapping : 'ItemCategDesc'},
			{name: 'NormID', mapping : 'NormID'},
			{name: 'NormDesc', mapping : 'NormDesc'},
			{name: 'NormMax', mapping : 'NormMax'},
			{name: 'NormMin', mapping : 'NormMin'},
			{name: 'NormRange', mapping : 'NormRange'},
			{name: 'ItemObj', mapping : 'ItemObj'},
			{name: 'ItemDate', mapping : 'ItemDate'},
			{name: 'SpecTypeID', mapping : 'SpecTypeID'},
			{name: 'SpecTypeDesc', mapping : 'SpecTypeDesc'},
			{name: 'SpecimenNum', mapping : 'SpecimenNum'},
			{name: 'CenterNum', mapping : 'CenterNum'},
			{name: 'SurroundNum', mapping : 'SurroundNum'},
			{name: 'IssueSpecNum', mapping : 'IssueSpecNum'},
			{name: 'UnissueSpecNum', mapping : 'UnissueSpecNum'},
			{name: 'AddSpecNum', mapping : 'AddSpecNum'},
			{name: 'UnfinishCount', mapping : 'UnfinishCount'},
			{name: 'Result', mapping : 'Result'},
			{name: 'Pathogens', mapping : 'Pathogens'},
			{name: 'AutoIsNorm', mapping : 'AutoIsNorm'},
			{name: 'RepDate', mapping : 'RepDate'},
			{name: 'RepTime', mapping : 'RepTime'},
			{name: 'RepLocID', mapping : 'RepLocID'},
			{name: 'RepLocDesc', mapping : 'RepLocDesc'},
			{name: 'RepUserID', mapping : 'RepUserID'},
			{name: 'RepUserDesc', mapping : 'RepUserDesc'},
			{name: 'RepResume', mapping : 'RepResume'},
			{name: 'ArgBarCode', mapping : 'ArgBarCode'}
		])
	});
	obj.gridEnviHyReport = new Ext.grid.GridPanel({
		id : 'gridEnviHyReport'
		,store : obj.gridEnviHyReportStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.RowExpander
			,{header: '申请号', width: 90, dataIndex: 'RepBarCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '检测项目', width: 160, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '申请科室', width: 120, dataIndex: 'AskForLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '状态', width: 80, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var str = rd.get('RepStatusDesc');
					return str;
				}
			}
			,{header: '完成情况', width: 60, dataIndex: 'UnfinishCount', sortable: false, menuDisabled:true, align: 'center',
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
			,{header: '检测范围', width: 150, dataIndex: 'NormRange', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '项目对象', width: 80, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '标本数量', width: 60, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IssueSpecNum = rd.get('IssueSpecNum');
					IssueSpecNum = IssueSpecNum*1;
					var SpecimenNum = rd.get('SpecimenNum');
					SpecimenNum = SpecimenNum*1;
					if ((IssueSpecNum>0)&&(IssueSpecNum<SpecimenNum)) {
						var str = '【' + rd.get('IssueSpecNum') + '/' + rd.get('SpecimenNum') + '】';
					} else {
						var str = rd.get('SpecimenNum');
					}
					return str;
				}
			}
			,{header: '检测日期', width: 80, dataIndex: 'ItemDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '检测结果', width : 60,dataIndex: 'Result',sortable: false,menuDisabled:true,align: 'center',
				renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value == ""){
						return "";
					}else{
						return "<a href='#' onclick='objScreen.ViewEnviHyReport(\""+(record.get('ReportID'))+"\")'><font size='2'>结果</font></a>";
					}
				}
			}
			,{header: '是否合格', width: 60, dataIndex: 'AutoIsNorm', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value=="合格")
					{
						return "<b style='color:green;'>"+value+"</b>";
					}else{
					    return "<b style='color:red;'>"+value+"</b>";
					}
				}
			}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.gridEnviHyReportStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins: obj.RowExpander
	    ,iconCls: 'icon-grid'
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
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1',
		layout : 'border',
		items:[
			{
				height:80,
				region: 'north',
				layout : 'form',
				items : [
					{
						layout:'column',
						frame: true,
						items:[
							{
								width:160,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 40,
								items:[obj.cboSSHosp]
							},{
								width:170,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 70,
								items:[obj.txtDateFrom]
							},{
								width:170,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 70,
								items:[obj.txtDateTo]
							},{
								width:240,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 40,
								items:[obj.cboLoc]
							},{
								width:5
							},{
								id : 'btnMDBatPn',
								width : 60,
								layout:'form',
								items:[obj.btnMDBat]
							//},{
							//	width:5
							//},{
							//	id : 'btnRstBatPn',
							//	width : 60,
							//	layout:'form',
							//	items:[obj.btnRstBat]
							},{
								width:5
							},{
								width : 60,
								layout:'form',
								items:[obj.btnPrintBar]
							}
						]
					},{
						layout:'column',
						frame: true,
						items:[
							{
								width:360,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 1,
								items:[obj.cbBar]
							},{
								width:200,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 60,
								items:[obj.txtAreaBar]
							},{
								id : 'txtEnviHyResultPn',
								width:100,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 60,
								items:[obj.txtEnviHyResult]
							},{
								id : 'txtEnviHyPathogenPn',
								width:220,
								layout:'form',
								labelAlign : 'right',
								labelWidth : 60,
								items:[obj.txtEnviHyPathogen]
							}
						]
					}
				]
			},{
				region: 'center'
				,layout : 'fit'
				,frame : true
				,items : [
					obj.gridEnviHyReport
				]
			}
		]
	});
	
	obj.gridEnviHyReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.EnviHyRepSrv';
		param.QueryName = 'QryEnviHyRep';
		param.Arg1 = obj.cbBar.getValue().inputValue;
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboLoc');
		param.Arg5 = Common_GetValue('txtAreaBar');
		param.ArgCnt = 5;
		
		obj.EnviHyRepQueryArg1 = param.Arg1;    //查询方式
		obj.EnviHyRepQueryArg2 = param.Arg2;    //开始日期
		obj.EnviHyRepQueryArg3 = param.Arg3;    //结束日期
		obj.EnviHyRepQueryArg4 = param.Arg4;    //科室
		obj.EnviHyRepQueryArg5 = param.Arg5;    //条码
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

