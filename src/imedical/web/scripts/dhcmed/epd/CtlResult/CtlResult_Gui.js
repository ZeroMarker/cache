var objScreen = new Object();

function InitWinControl()
{
	var obj = new Object();
	objScreen = obj;
	
	obj.SelectNode = null;
	obj.QueryArgs = new Object();
	obj.QueryArgs.DateType = '';
	obj.QueryArgs.DateFrom = '';
	obj.QueryArgs.DateTo = '';
	obj.QueryArgs.CtrlItems = '';
	obj.QueryArgs.LocID = '';
	obj.QueryArgs.WardID = '';
	obj.QueryArgs.HospID = '';
	obj.QueryArgs.AdmType = '';
	
    obj.mnuMenu = new Ext.menu.Menu({
        items : [
		   {
			   id : 'mnuEPDReport',
			   text : '<B>传染病报告<B/>',
			   iconCls : ''
		   }
        ]
    })
	
	//监控项目树
	obj.TreeControlsTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter : 'Arg1',
		dataUrl : "dhcmed.cc.sys.ctrlitemtree.csp",
		baseParams : {
			ConfigCode : SubjectCode
			,Loc : obj.QueryArgs.LocID
			,Ward: obj.QueryArgs.WardID
		}
	});
	obj.TreeControls = new Ext.tree.TreePanel({
		buttonAlign : 'center'
		,region : 'center'
		,width:300
		,rootVisible:false
		,autoScroll:true
		,loader : null  //obj.TreeControlsTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'root',text:'root'})
	});
	obj.ConditionPanel1 = new Ext.form.FormPanel({
		id : 'ConditionPanel1'
		,layout : 'fit'
		,region: 'center'
		,items:[
			obj.TreeControls
		]
	});
	
	obj.radioDateType1 = new Ext.form.Radio({
		id : 'radioDateType1'
		,name : 'radioDateType'
		,boxLabel : '发生日期'
		,inputValue : '1'
	});
	obj.radioDateType2 = new Ext.form.Radio({
		id : 'radioDateType2'
		,name : 'radioDateType'
		,boxLabel : '结果日期'
		,inputValue : '2'
	});
	obj.radioDateType = new Ext.form.RadioGroup({
		id : 'radioDateType'
		,fieldLabel : '日期类型'
		,items:[
			obj.radioDateType1
			,obj.radioDateType2
		]
	});
	
	obj.cbgAdmType = new Ext.form.CheckboxGroup({
		id : 'cbgAdmType'
		,fieldLabel : '就诊类型'
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : [
			{id : 'cbgAdmType-I', boxLabel : '住院', name : 'cbgAdmType-I', inputValue : 'I', checked : false}
			,{id : 'cbgAdmType-O', boxLabel : '门诊', name : 'cbgAdmType-O', inputValue : 'O', checked : false}
			,{id : 'cbgAdmType-E', boxLabel : '急诊', name : 'cbgAdmType-E', inputValue : 'E', checked : false}
		]
		,width : 200
		,height : 25
	});
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"EPD");
	obj.cboLoc = Common_ComboToLoc("cboLoc","科室","E|EM","","","cboSSHosp");
    obj.cboWard = Common_ComboToLoc("cboWard","病区","W","cboLoc","I","cboSSHosp");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","开始日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","结束日期");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor:'100%'
		,text : '查询'
		,height: 25
	});
    obj.btnExport = new Ext.Button({
		id:'btnExport'
		,iconCls:'icon-export'
		,anchor:'100%'
		,text:'导出'
		,height: 25
    });
	
    obj.btnControl = new Ext.Button({
		id:'btnControl'
		,iconCls:'icon-update'
		,anchor:'100%'
		,text:'监控'
		,height: 25
    });
	
	obj.ConditionPanel2 = new Ext.form.FormPanel({
		id : 'ConditionPanel2'
		,buttonAlign : 'center'
		,layout : 'form'
		,frame:true
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,region : 'south'
		,height : 270
		,items:[
			obj.cboSSHosp
			,obj.radioDateType
			,obj.dfDateFrom
			,obj.dfDateTo
			,obj.cbgAdmType
			,obj.cboLoc
			,obj.cboWard
		]
		,buttons:[
			obj.btnQuery
			,obj.btnExport
			,obj.btnControl
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id: 'ConditionPanel'
		,title: '请选择监控条件...'
		//,autoScroll : true
		,collapsible : true
		,split:true
		,border:true
		,width:300
		,minSize: 300
		,maxSize: 300
		,layoutConfig: {animate: true}
		,region: 'east'
		,layout: 'border'
		,items:[
			obj.ConditionPanel1
			,obj.ConditionPanel2
		]
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
			'<div id="divCtrlDtl-{Paadm}"></div>'
        )
    });
	
	obj.CtlPaadmGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout: 300000
			,method:'POST'
	}));
	obj.CtlPaadmGridStore = new Ext.data.Store({
		proxy: obj.CtlPaadmGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Paadm'
		}, 
		[
			{name: 'Paadm', mapping : 'Paadm'}
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
			,{name: 'CtrlCont', mapping: 'CtrlCont'}
			,{name: 'CtrlDtl', mapping: 'CtrlDtl'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
			,{name: 'IsFirst', mapping: 'IsFirst'}
			,{name: 'HisReportInfo', mapping: 'HisReportInfo'}
			,{name: 'IsRepEpdDesc', mapping: 'IsRepEpdDesc'}
		])
	});
	obj.CtlPaadmGrid = new Ext.grid.GridPanel({
		id : 'CtlPaadmGrid'
		,loadMask : true
		,buttonAlign : 'center'
		,region : 'center'
         ,contextMenu : obj.mnuMenu
		,store : obj.CtlPaadmGridStore
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.RowExpander
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false}
			,{header: '患者姓名', width: 80, dataIndex: 'PatName', sortable: false}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false}
			,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '传染病诊断', width: 100, dataIndex: 'CtrlCont', sortable: false, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			//,{header: '是否<br>报卡', width: 50, dataIndex: 'IsRepEpdDesc', sortable: false}
			//,{header: '是否<br>复诊', width: 50, dataIndex: 'IsFirst', sortable: false}
			//,{header: '历次报告信息', width: 150, dataIndex: 'HisReportInfo', sortable: false}
			,{header: '就诊类型', width: 80, dataIndex: 'AdmType', sortable: false}
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: false}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: false}
			,{header: '科室', width: 120, dataIndex: 'AdmLoc', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'AdmWard', sortable: true}
			,{header: '床位', width: 80, dataIndex: 'AdmBed', sortable: false}
			,{header: '主管医生', width: 80, dataIndex: 'AdmDoc', sortable: false}
			,{header: '就诊号', width: 80, dataIndex: 'Paadm', sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.CtlPaadmGridStore,
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
			,getRowClass : function(record,rowIndex,rowParams,store){
				if (record.data.Points=="1") {
					return 'x-grid-record-green';
				} else if (record.data.ErrFlag=="2") {
					return 'x-grid-record-red';
				} else {
					return '';
				}
			}
		}
	});
	obj.CtlPaadmGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.CtlResultSrv';
		param.QueryName = 'QryCtlPaadm';
		param.Arg1 = obj.QueryArgs.DateType;
		param.Arg2 = obj.QueryArgs.DateFrom;
		param.Arg3 = obj.QueryArgs.DateTo;
		param.Arg4 = obj.QueryArgs.CtrlItems;
		param.Arg5 = obj.QueryArgs.LocID;
		param.Arg6 = obj.QueryArgs.WardID;
		param.Arg7 = obj.QueryArgs.HospID;
		param.Arg8 = obj.QueryArgs.AdmType;
		param.ArgCnt = 8;
	});
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.ConditionPanel
			,obj.CtlPaadmGrid
		]
	});
	
	InitWinControlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}