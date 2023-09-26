var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	
	obj.cboSurvNumberStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboSurvNumberStore = new Ext.data.Store({
		proxy : obj.cboSurvNumberStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'rowid'
		}, [
			{name: 'RowID', mapping: 'RowID'}
			,{name: 'SESurvNumber', mapping: 'SESurvNumber'}
			,{name: 'SEHospCode', mapping: 'SEHospCode'}
			,{name: 'SEHospDR', mapping: 'SEHospDR'}			
			,{name: 'SEHospDesc', mapping: 'SEHospDesc'}
			,{name: 'SESurvMethodDR', mapping: 'SESurvMethodDR'}
			,{name: 'SESurvMethod', mapping: 'SESurvMethod'}
			,{name: 'SESurvSttDate', mapping: 'SESurvSttDate'}
			,{name: 'SESurvEndDate', mapping: 'SESurvEndDate'}
		])
	});
	obj.cboSurvNumber = new Ext.form.ComboBox({
		id : 'cboSurvNumber'
		,store : obj.cboSurvNumberStore
		,fieldLabel : '������'
		,emptyText : '��ѡ��...'
		,editable : false
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>������</th>',
					'<th>ҽԺ</th>',
					'<th>���鷽��</th>',
					'<th>��ʼ����</th>',
					'<th>��������</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{SESurvNumber}</td>',
					'<td>{SEHospDesc}</td>',
					'<td>{SESurvMethod}</td>',
					'<td>{SESurvSttDate}</td>',
					'<td>{SESurvEndDate}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:500
		,valueField : 'RowID'
		,displayField : 'SESurvNumber'
		,loadingText: '��ѯ��,���Ե�...'
		,width : 80
		,anchor : '100%'
	});
	
	obj.cboHospital = Common_ComboToSSHospAA("cboHospital","ҽԺ",SSHospCode,"NINF");
    obj.cboLoc = Common_ComboToLoc("cboLoc","����","E","","I","cboHospital");
	
	obj.btnQuery =new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.btnExport =new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : "<font color='blue' size='3px'>��ӡ���ԵǼǱ�</font>"
	});
	
	obj.ViewPanel = new Ext.FormPanel({
		id : 'ViewPanel'
		,height : 60
		,region : 'north'
		,frame : true
		,title : '������������Ǽ�'
		,layout : 'column'
		,items:[
			{
				width : 200
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items: [obj.cboHospital]
			},{
				width : 200
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items: [obj.cboSurvNumber]
			},{
				width : 270
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 40
				,items: [obj.cboLoc]
			},{
				width : 10
			},{
				width : 160
				,layout : 'form'
				,items: [obj.btnQuery]
			}
		]
	});
	
	obj.bbar1 = new Ext.Toolbar({
		id:'bbar1',
		height: 25,
		items: []
		,style: 'font-size:18px;color:blue'
	});
	obj.bbar2 = new Ext.Toolbar({
		id:'bbar2',
		height: 25,
		items: [],
		style: 'font-size:18px;color:blue'
	});
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'RowID', mapping: 'RowID'}
			,{name: 'SurvNumber', mapping: 'SurvNumber'}
			,{name: 'SurvDate', mapping: 'SurvDate'}
			,{name: 'SurvDept', mapping: 'SurvDept'}
			,{name: 'SurvDeptDesc', mapping: 'SurvDeptDesc'}	
			,{name: 'SurvWard', mapping: 'SurvWard'}		
			,{name: 'SurvWardDesc', mapping: 'SurvWardDesc'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'IPMrNo', mapping: 'IPMrNo'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'LinkReport', mapping: 'LinkReport'}
			,{name: 'InfType', mapping: 'InfType'}
			,{name: 'InfPos', mapping: 'InfPos'}
		])
	});
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,store : obj.GridPanelStore
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '������', width: 100, dataIndex: 'SurvNumber', sortable: true}
			//,{header: '��������', width: 80, dataIndex: 'SurvDate', sortable: true}
			,{header: '�ǼǺ�', width: 80, dataIndex: 'PapmiNo', sortable: true, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'PatName', sortable: true, align: 'center'}
			,{header: '������', width: 70, dataIndex: 'IPMrNo', sortable: true, align: 'center'}
			,{header: '�Ա�', width: 40, dataIndex: 'PatSex', sortable: true, align: 'center'}
			,{header: '����', width: 40, dataIndex: 'PatAge', sortable: true, align: 'center'}
			,{header: '������', width: 90, dataIndex: 'LinkReport', align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var strRet = "";
					var PatientID=rd.get("PatientID");
					var EpisodeID=rd.get("EpisodeID");
					var reportID=rd.get("LinkReport");
					var SurvNumber=rd.get("SurvNumber");
					if ((reportID!="")&(reportID!=undefined)){
						strRet += "<A id='lnkDMReport' HREF='#' onClick='objScreen.OpenHDMReport(\"" + rd.get("RowID") + "\",\"" + reportID + "\")' >&nbsp;"+SurvNumber+'-'+reportID+"&nbsp;</A>";
					}else{
						strRet += "<A id='lnkDMReport' HREF='#' onClick='objScreen.NewHDMReport(\"" + rd.get("RowID") + "\",\"" + PatientID + "\",\"" + EpisodeID + "\")' >&nbsp;�½�&nbsp;</A>";
					}
					return strRet;
				}
			}
			,{
				header : '�������',
				width : 70,
				renderer : function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("EpisodeID");
					return " <a href='#' onclick='DisplayEPRView(\""+EpisodeID+"\",\"\");'>&nbsp;�������&nbsp; </a>";
				}
			}
			//,{header: '��Ⱦ����', width: 80, dataIndex: 'InfType', align: 'center'}
			,{header: '��Ⱦ��λ', width: 120, dataIndex: 'InfPos', align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '����', width: 150, dataIndex: 'SurvDeptDesc', sortable: true, align: 'left'}
			,{header: '����', width: 150, dataIndex: 'SurvWardDesc', sortable: true, align: 'left'}
		]
		,bbar:[obj.btnExport,'->',obj.bbar2,'->',obj.bbar1]
		,viewConfig: {
			forceFit: true
		}
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.ViewPanel,
			obj.GridPanel
		]
	});
	
	obj.cboSurvNumberStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.NINFService.CSS.Service';
		param.QueryName = 'QrySurvExec';
		param.Arg1 = Common_GetValue('cboHospital');
		param.ArgCnt = 1;
	});
	
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.CSS.Service';
			param.QueryName = 'QryBedSurvRec';
			param.Arg1 = Common_GetText('cboSurvNumber');
			param.Arg2 = Common_GetValue('cboLoc');
			param.ArgCnt = 2;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}


