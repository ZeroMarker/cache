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
			   text : '<B>���ձ걾<B/>',
			   iconCls : ''
		   },{
			   id : 'mnuResult',
			   text : '<B>¼����<B/>',
			   iconCls : ''
		   },{
			   id : 'mnuPrintReport',
			   text : '<B>��ӡ����<B/>',
			   iconCls : ''
		   }
        ]
    })
	
	var curDate = new Date();
	var mthFirstDay = curDate.format("Y") +"-" +curDate.format("m") + "-01";
	obj.txtDateFrom = new Ext.form.DateField({
		id : 'txtDateFrom'
		,fieldLabel : '��ʼ����'
		,editable : false
		,format : 'Y-m-d'
		,width : 10
		,anchor : '100%'
		,value : mthFirstDay
	});
	obj.txtDateTo = new Ext.form.DateField({
		id : 'txtDateTo'
		,fieldLabel : '��������'
		,editable : false
		,format : 'Y-m-d'
		,width : 10
		,anchor : '100%'
		,value : new Date().dateFormat('Y-m-d')
	});
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"NINF");
    obj.cboLoc = Common_ComboToLoc("cboLoc","����","","","","cboSSHosp");
	
	obj.btnMDBat = new Ext.Button({
		id : 'btnMDBat'
		//,iconCls : 'icon-export'
		,width : 10
		,text : '���Ϸ���'
		,anchor : '100%'
	});
	obj.btnRstBat = new Ext.Button({
		id : 'btnRstBat'
		//,iconCls : 'icon-export'
		,width : 10
		,text : '��ֵ����'
		,anchor : '100%'
	});
	obj.btnPrintBar = new Ext.Button({
		id : 'btnPrintBar'
		//,iconCls : 'icon-print'
		,width : 10
		,text : '��ӡ����'
		,anchor : '100%'
	});
	obj.txtAreaBar =  new Ext.form.TextField({
		id : 'txtAreaBar'
		,selectOnFocus:true
		,fieldLabel : '������'
		,style: 'font-weight:bold;font-size:16'
		,labelStyle: 'font-weight:bold;font-size:14'
		,width : 80
		,height : 22
		,anchor : '100%'
	});
	obj.txtEnviHyResult =  new Ext.form.TextField({
		id : 'txtEnviHyResult'
		,selectOnFocus:true
		,fieldLabel : '������'
		,style: 'font-weight:bold;font-size:16'
		,labelStyle: 'font-weight:bold;font-size:14'
		,width : 80
		,height : 22
		,anchor : '100%'
	});
	obj.txtEnviHyPathogen =  new Ext.form.TextField({
		id : 'txtEnviHyPathogen'
		,selectOnFocus:true
		,fieldLabel : '�²���'
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
			{boxLabel: '<span style="font-weight:bold;font-size:15px">���Ų���</span>', name: 'cb-col',inputValue: '1'},
			{boxLabel: '<span style="font-weight:bold;font-size:15px">���ձ걾</span>', name: 'cb-col',inputValue: '2'},
			{boxLabel: '<span style="font-weight:bold;font-size:15px">¼����</span>', name: 'cb-col',inputValue: '3'},
			{boxLabel: '<span style="font-weight:bold;font-size:15px">��&nbsp;&nbsp;&nbsp;&nbsp;ѯ</span>', name: 'cb-col',inputValue: '0', checked: true}
		]
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">���</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">�����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">״̬</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">ʱ��</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����Ա</td>',
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
			,{header: '�����', width: 90, dataIndex: 'RepBarCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�����Ŀ', width: 160, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '�������', width: 120, dataIndex: 'AskForLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '״̬', width: 80, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var str = rd.get('RepStatusDesc');
					return str;
				}
			}
			,{header: '������', width: 60, dataIndex: 'UnfinishCount', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var UnfinishCount = rd.get('UnfinishCount');
					UnfinishCount = UnfinishCount*1;
					if (UnfinishCount < 0){
						var str = '��' + v + '��';
					}else{
						var str = '���';
					}
					return str;
				}
			}
			,{header: '��ⷶΧ', width: 150, dataIndex: 'NormRange', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '��Ŀ����', width: 80, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '�걾����', width: 60, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IssueSpecNum = rd.get('IssueSpecNum');
					IssueSpecNum = IssueSpecNum*1;
					var SpecimenNum = rd.get('SpecimenNum');
					SpecimenNum = SpecimenNum*1;
					if ((IssueSpecNum>0)&&(IssueSpecNum<SpecimenNum)) {
						var str = '��' + rd.get('IssueSpecNum') + '/' + rd.get('SpecimenNum') + '��';
					} else {
						var str = rd.get('SpecimenNum');
					}
					return str;
				}
			}
			,{header: '�������', width: 80, dataIndex: 'ItemDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�����', width : 60,dataIndex: 'Result',sortable: false,menuDisabled:true,align: 'center',
				renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value == ""){
						return "";
					}else{
						return "<a href='#' onclick='objScreen.ViewEnviHyReport(\""+(record.get('ReportID'))+"\")'><font size='2'>���</font></a>";
					}
				}
			}
			,{header: '�Ƿ�ϸ�', width: 60, dataIndex: 'AutoIsNorm', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(value,cellmeta,record,rowIndex,columnIndex,store){
					if (value=="�ϸ�")
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
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
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
		
		obj.EnviHyRepQueryArg1 = param.Arg1;    //��ѯ��ʽ
		obj.EnviHyRepQueryArg2 = param.Arg2;    //��ʼ����
		obj.EnviHyRepQueryArg3 = param.Arg3;    //��������
		obj.EnviHyRepQueryArg4 = param.Arg4;    //����
		obj.EnviHyRepQueryArg5 = param.Arg5;    //����
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

