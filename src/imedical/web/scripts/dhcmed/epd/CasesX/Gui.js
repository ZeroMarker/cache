function InitCasesX(){
	var obj = new Object();
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"EPD");
	obj.cboLoc = Common_ComboToLoc("cboLoc","�������","E|EM","","","cboSSHosp");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","��ʼ����");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","��������");
	
	obj.cbgAdmType = new Ext.form.CheckboxGroup({
		id : 'cbgAdmType'
		,fieldLabel : '��������'
		,xtype : 'checkboxgroup'
		,columns : 3
		,height : 24
		,anchor : '99%'
		,items : [
			{id : 'I', boxLabel : 'סԺ', name : 'I', inputValue : 'I', checked : false}
			,{id : 'O', boxLabel : '����', name : 'O', inputValue : 'O', checked : false}
			,{id : 'E', boxLabel : '����', name : 'E', inputValue : 'E', checked : false}
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
		,text : '��ѯ'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,text : '����'
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">���</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">��Ŀ</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="30%">ժҪ</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">�������</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">����Ա</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">��������</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����</td>',
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
			,{header: '�ǼǺ�', width: 80, dataIndex: 'PapmiNo', sortable: false}
			,{header: '��������', width: 80, dataIndex: 'PatName', sortable: false}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: false}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: false}
			//,{header : '����<br>�ܼ�', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '����<br>����', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�������', width: 100, dataIndex: 'ActDiagnos', sortable: false, align: 'left'}
			,{header: '������ؽ��', width: 100, dataIndex: 'LnkResultsDesc', sortable: false, align: 'left'}
			,{header: '��ǰ״̬', width: 100, dataIndex: 'EpdStatusDesc', sortable: false
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
			,{header: 'ȷ�����', width: 100, dataIndex: 'EpdDiagnos', sortable: false, align: 'left'}
			,{header: '�������', width: 100, dataIndex: 'Opinion', sortable: false, align: 'left'}
		    ,{header: '��Ժ����', width: 80, dataIndex: 'AdmitDate', sortable: false}
			,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: false}
			,{header: '����', width: 120, dataIndex: 'AdmLoc', sortable: true}
			,{header: '����', width: 120, dataIndex: 'AdmWard', sortable: true}
			,{header: '�����', width: 80, dataIndex: 'EpisodeID', sortable: false}		
			]
			,bbar: new Ext.PagingToolbar({
			pageSize : 30,
			store : obj.gridCasesXStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
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

