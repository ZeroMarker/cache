var objScreen = new Object();
var ExpAll = false;
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
	
	var arrItem = new Array();
	var strDicList = '1^Ӧ��,2^ʵ��,3^��Ⱦ';
	var dicList = strDicList.split(',');
	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split('^');
		var chkItem = {
			id : 'cbgCategory-' + dicSubList[0],
			boxLabel : dicSubList[1],
			name : 'cbgCategory-' + dicSubList[0],
			inputValue : dicSubList[0],
			checked : false,
			listeners : {
				check : function(checkbox, checked) {
					if (checked) {
						var chkBoxId = checkbox.id;
						var chkBoxValue = checkbox.inputValue;
						var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
						var chkGrp = Ext.getCmp(chkGrpId);
						if (chkGrp) {
							for (idx = 0; idx < chkGrp.items.length; idx++) {
								var cbId=chkGrp.items.items[idx].id;
								if (cbId!=chkBoxId) {
									chkGrp.setValue(cbId,false);
								}
							}
						}
					}
				}
			}
		}
		arrItem.push(chkItem);
	}
	obj.cbgCategory = new Ext.form.CheckboxGroup({
		id : 'cbgCategory'
		,fieldLabel : '����'
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : arrItem
		,width : 10
		,anchor : '100%'
	});
	
	obj.btnQuery =new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor : '100%'
		,text : '��ѯ'
	});
	obj.btnExport =new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,anchor : '100%'
		,text : "����EXCEL"
	});
	
	obj.btnExportToMK = new Ext.Button({
		id : 'btnExportToMK'
		,iconCls : 'icon-export'
		,anchor : '100%'
		,text : '�����ӿڡ���ѡ��'
	});
	
	obj.btnExportToMKAll = new Ext.Button({
		id : 'btnExportToMKAll'
		,iconCls : 'icon-export'
		,anchor : '100%'
		,text : '�����ӿڡ�ȫ����'
	});
	
	obj.ViewPanel = new Ext.FormPanel({
		id : 'ViewPanel'
		,height : 60
		,region : 'north'
		,frame : true
		,title : '�������鱨���ѯ'
		,layout : 'column'
		,items:[
			{
				width : 150
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 40
				,items: [obj.cboHospital]
			},{
				width : 180
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items: [obj.cboSurvNumber]
			},{
				width : 200
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 40
				,items: [obj.cboLoc]
			},{
				width : 240
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 40
				,items: [obj.cbgCategory]
			},{
				width : 5
			},{
				width : 60
				,layout : 'form'
				,items: [obj.btnQuery]
			},{
				width : 5
			},{
				width : 85
				,layout : 'form'
				,items: [obj.btnExport]
			}
		]
	});
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		,timeout : 18000  //3���ӳ�ʱ
	}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BedSurvID'
		}, 
		[
			{name: 'BedSurvID', mapping: 'BedSurvID'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'SurvDate', mapping: 'SurvDate'}
			,{name: 'SurvLoc', mapping: 'SurvLoc'}	
			,{name: 'SurvUser', mapping: 'SurvUser'}		
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Name', mapping: 'Name'}
			,{name: 'MRNo', mapping: 'MRNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'LinkReport', mapping: 'LinkReport'}
			,{name: 'ExportFlg', mapping: 'ExportFlg'}
			,{name: 'Loc', mapping: 'Loc'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'Diagnos', mapping: 'Diagnos'}
			,{name: 'IsInfection', mapping: 'IsInfection'}
			,{name: 'InfPos1', mapping: 'InfPos1'}
			,{name: 'InfDate1', mapping: 'InfDate1'}
			,{name: 'Pathogen1', mapping: 'Pathogen1'}
			,{name: 'InfPos2', mapping: 'InfPos2'}
			,{name: 'InfDate2', mapping: 'InfDate2'}
			,{name: 'Pathogen2', mapping: 'Pathogen2'}
			,{name: 'InfPos3', mapping: 'InfPos3'}
			,{name: 'InfDate3', mapping: 'InfDate3'}
			,{name: 'Pathogen3', mapping: 'Pathogen3'}
			,{name: 'Anti1', mapping: 'Anti1'}
			,{name: 'Anti2', mapping: 'Anti2'}
			,{name: 'Anti3', mapping: 'Anti3'}
			,{name: 'Anti4', mapping: 'Anti4'}
			,{name: 'Oper1', mapping: 'Oper1'}
			,{name: 'Oper2', mapping: 'Oper2'}
			,{name: 'Oper3', mapping: 'Oper3'}
			,{name: 'Oper4', mapping: 'Oper4'}
			,{name: 'AddOns1', mapping: 'AddOns1'}
			,{name: 'AddOns2', mapping: 'AddOns2'}
			,{name: 'AddOns3', mapping: 'AddOns3'}
			,{name: 'AddOns4', mapping: 'AddOns4'}
			,{name: 'checked', mapping: 'checked'}
		])
	});
	
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 35 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,store : obj.GridPanelStore
		,plugins : obj.GridPanelCheckCol
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,frame : true
		,tbar : [obj.btnExportToMK,obj.btnExportToMKAll,"��ܰ��ʾ���ӿڵ�������������ĺ�������ǼǱ�δ��Ĳ��ܵ�����"]
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.GridPanelCheckCol
			,{header: '�ǼǺ�', width: 80, dataIndex: 'PapmiNo', align: 'center'}
			,{header: '����', width: 70, dataIndex: 'Name', align: 'center'}
			,{header: '������', width: 70, dataIndex: 'MRNo', align: 'center'}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', align: 'center'}
			,{header: '����', width: 60, dataIndex: 'Age', align: 'center'}
			,{header: '����', width: 120, dataIndex: 'Loc', align: 'left'}
			,{
				header : '�������',
				width : 70,
				renderer : function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("EpisodeID");
					return " <a href='#' onclick='DisplayEPRView(\""+EpisodeID+"\",\"\");'>&nbsp;�������&nbsp; </a>";
				}
			}
			,{header: '��λ', width: 60, dataIndex: 'Bed', align: 'center'}
			,{header: '��Ժ����', width: 80, dataIndex: 'AdmDate', align: 'center'}
			,{header: '�����������', width: 150, dataIndex: 'Diagnos', align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��ȥ24Сʱ���Ƿ��С�3�εĸ�к', width: 120, dataIndex: 'AddOns4', align: 'center'}
			,{header: '�Ƿ��Ⱦ', width: 70, dataIndex: 'IsInfection', align: 'center'}
			,{header: '��Ⱦ��λ1', width: 100, dataIndex: 'InfPos1', align: 'center'}
			,{header: '��Ⱦ����1', width: 80, dataIndex: 'InfDate1', align: 'center'}
			,{header: '��ԭ��1', width: 180, dataIndex: 'Pathogen1', align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��Ⱦ��λ2', width: 100, dataIndex: 'InfPos2', align: 'center'}
			,{header: '��Ⱦ����2', width: 80, dataIndex: 'InfDate2', align: 'center'}
			,{header: '��ԭ��2', width: 180, dataIndex: 'Pathogen2', align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��Ⱦ��λ3', width: 100, dataIndex: 'InfPos3', align: 'center'}
			,{header: '��Ⱦ����3', width: 80, dataIndex: 'InfDate3', align: 'center'}
			,{header: '��ԭ��3', width: 180, dataIndex: 'Pathogen3', align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '����ҩ��ʹ��', width: 120, dataIndex: 'Anti1', align: 'center'}
			,{header: 'Ŀ��', width: 60, dataIndex: 'Anti2', align: 'center'}
			,{header: '����', width: 60, dataIndex: 'Anti3', align: 'center'}
			,{header: '������ҩǰ����ϸ������', width: 120, dataIndex: 'Anti4', align: 'center'}
			,{header: '����', width: 80, dataIndex: 'Oper1', align: 'center'}
			,{header: '��ǰӦ�ÿ���ҩ��', width: 120, dataIndex: 'Oper2', align: 'center'}
			,{header: '�����пڵȼ�', width: 120, dataIndex: 'Oper3', align: 'center'}
			,{header: '�񡢢��п�Χ��������ҩ', width: 120, dataIndex: 'Oper4', align: 'center'}
			,{header: '���������', width: 120, dataIndex: 'AddOns1', align: 'center'}
			,{header: '��������', width: 120, dataIndex: 'AddOns2', align: 'center'}
			,{header: 'ʹ�ú�����', width: 120, dataIndex: 'AddOns3', align: 'center'}
			,{header: '��������', width: 80, dataIndex: 'SurvDate', align: 'center'}
			,{header: '�������', width: 180, dataIndex: 'SurvLoc', align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '������', width: 60, dataIndex: 'SurvUser', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.GridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,viewConfig: {
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
				if (record.data.ExportFlg=='1') {
					return 'x-grid-record-font-green';
				} else {
					return '';
				}
			}
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
			param.ClassName = 'DHCMed.NINFService.CSS.ClinRepSrv';
			param.QueryName = 'QryCSSSurvRec';
			param.Arg1 = Common_GetText('cboSurvNumber');
			param.Arg2 = Common_GetValue('cboLoc');
			param.Arg3 = Common_GetValue('cboHospital');
			param.Arg4 = Common_GetValue('cbgCategory');
			param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}


