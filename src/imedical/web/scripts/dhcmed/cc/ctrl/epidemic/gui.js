function InitWinControl(SubjectID)
{
	var obj = new Object();
	obj.SubjectID = SubjectID;
	obj.ConfigCode = ConfigCode; //Add By LiYang 2013-04-03
	obj.SelectNode=null;
	obj.loadParamArg1="";
	obj.loadParamArg2="";
	obj.loadParamArg3="";
	obj.loadParamArg4="";
	obj.loadParamArg5="";
	obj.loadParamArg6="";
    
    obj.selLocDr = "";
    obj.selWardDr = "";
	
    obj.mnuMenu = new Ext.menu.Menu({
        items : [
               {
                   id : 'mnuEva',
                   text : '<B>����<B/>',
                   iconCls : ''
               },
                "-",
               {
                   id : 'mnuSendMsg',
                   text : '<B>������Ϣ<B/>',
                   iconCls : ''                   
               }
        ]
    })


	
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '��������'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
	});
    obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : 'סԺ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = obj.cboWard.getValue();
			param.ArgCnt = 3;
	});
	obj.cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboWardStore = new Ext.data.Store({
		proxy: obj.cboWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,store : obj.cboWardStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : 'סԺ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = obj.cboLoc.getValue();
			param.ArgCnt = 3;
	});  
	
	obj.TreeControlsTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter : 'Arg1',
		dataUrl : "dhcmed.cc.sys.ctrlitemtree.csp",
		baseParams : {
			ConfigCode : ConfigCode
			,Loc : ''
			,Ward: ''
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
	obj.radioTypeOP = new Ext.form.Radio({
		id : 'radioTypeOP'
		,name : 'radioType'
		,boxLabel : '����'
		,inputValue : 'O'
	});
	obj.radioTypeEP = new Ext.form.Radio({
		id : 'radioTypeEP'
		,name : 'radioType'
		,boxLabel : '����'
		,inputValue : 'E'
	});
	obj.radioTypeIP = new Ext.form.Radio({
		id : 'radioTypeIP'
		,name : 'radioType'
		,boxLabel : '��Ժ'
		,inputValue : 'I'
	});
	obj.radioTypeDP = new Ext.form.Radio({
		id : 'radioTypeDP'
		,name : 'radioType'
		,boxLabel : '��Ժ'
		,inputValue : 'D'
	});
	obj.radioType = new Ext.form.RadioGroup({
		id : 'radioType'
		,fieldLabel : '��������'
		,items:[
			obj.radioTypeOP
			,obj.radioTypeEP
			,obj.radioTypeIP
			,obj.radioTypeDP
		]
	});
	
	//Modified By LiYang 2012-03-19 ���ӳ������ѯ����
	obj.chkRevisitFlag = new Ext.form.CheckboxGroup({
			columns: 2,
			fieldLabel : '���︴��',
			items : [
				{boxLabel: '����', name: 'chkFirstVisitFlag', checked : true},
				{boxLabel: '����', name: 'chkReVisitFlag'}
			]
		
		});
	
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '��ѯ'
		,height: 25
	});
    obj.btnExport = new Ext.Button({
		id:'btnExport'
		,iconCls:'icon-export'
		,anchor:'95%'
		,text:'����'
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
		,height : 230 //Modified By LiYang 2012-03-19 ��Ӧ�¸߶�
		,items:[
			obj.radioType
			,obj.chkRevisitFlag  //Modified By LiYang 2012-03-19 ���ӳ������ѯ����
			,obj.dfDateFrom
			,obj.dfDateTo
			,obj.cboLoc
			,obj.cboWard
		]
		,buttons:[
			obj.btnQuery
			,obj.btnExport
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id: 'ConditionPanel'
		,title: '������סԺ���߼��'
		,autoScroll : true
		,collapsible : true
		,split:true
		,border:true
		,width:320
		,minSize: 320
		,maxSize: 320
		,layoutConfig: {animate: true}
		,region: 'east'
		,layout: 'border'
		,items:[
			obj.ConditionPanel1
			,obj.ConditionPanel2
		]
	});
	obj.expCtrlDetail = new Ext.ux.grid.RowExpander({
        tpl : new Ext.Template(
            '<p>{CtrlDtl}</p><br>'
        )
    });
	obj.DataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout: 3000000
			,method:'POST'
	}));
	obj.DataGridPanelStore = new Ext.data.Store({
		proxy: obj.DataGridPanelStoreProxy,
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
			,{name: 'AdmDiagnos', mapping: 'AdmDiagnos'}
			,{name: 'Score', mapping: 'Score'}
			,{name: 'CtrlDtl', mapping: 'CtrlDtl'}
			,{name: 'EpdTypes', mapping: 'EpdTypes'}
			,{name: 'EvalInfo', mapping: 'EvalInfo'}
			,{name: 'MRAdm', mapping: 'MRAdm'}
			,{name: 'ReAdm', mapping: 'ReAdm'}
		])
	});
	obj.DataGridPanel = new Ext.grid.GridPanel({
		id : 'DataGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,region : 'center'
         ,contextMenu : obj.mnuMenu
		,store : obj.DataGridPanelStore
		,columns: [
			obj.expCtrlDetail
			//,new Ext.grid.RowNumberer()
			,{header: '��ֵ', width: 40, dataIndex: 'Score', sortable: false}
			,{
				header: '����'
				, width : 40
				, dataIndex : 'EvalInfo'
				, renderer: function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("Paadm");
					var SubjectID = obj.SubjectID;
					var strRet = "";
					if(v!==''){
						strRet += "<A id='lnkCCEval1' HREF='#' onClick='EvaluationLookUpHeader(" + SubjectID + "," + EpisodeID + ")' ><img name='lnkCCEval' src='../images/webemr/recovery.gif' alt='" + v + "' /></A>";
					}else{
						strRet += "<A id='lnkCCEval2' HREF='#' onClick='EvaluationLookUpHeader(" + SubjectID + "," + EpisodeID + ")' ><img name='lnkCCEval' src='../images/webemr/recreate.gif' alt='" + v + "' /></A>";
					}
					return strRet;
				}
			}
			,{
				header: '�½�<br>����'
				,width : 40
				,dataIndex : 'EpdTypes'
				,renderer: function(v, m, rd, r, c, s){
					var strRet = "";

					var PatientID=rd.get("PatientID");
					var EpisodeID=rd.get("Paadm");
					var strRet = "<A HREF='#' onClick='NewEpdReportLookUpHeader(" + PatientID + "," + EpisodeID + "," + EpdVersion + ")' ><img src='../images/webemr/reg.gif' alt='�½���Ⱦ������' /></A>";
					return strRet;
				}
			}
			//,{header: '�����', width: 80, dataIndex: 'Paadm', sortable: false}
			//Modified By LiYang 2012-03-19 ���ӳ������ѯ����
			,{header: '����', width: 40, dataIndex: 'ReAdm', sortable: false, 
				renderer: function(value)
				{
					if(value == "R")
						return "��";
				}
			}
			,{header: '�ǼǺ�', width: 80, dataIndex: 'PapmiNo', sortable: false}
			,{header: '��������', width: 80, dataIndex: 'PatName', sortable: false}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: false}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: false}
			,{
				header: '����ͼ��'
				,width : 80
				,dataIndex : 'EpdTypes'
				,renderer: function(v, m, rd, r, c, s){
					var strRet = "";
					var arrRet = v.split(String.fromCharCode(1));
					var PatientID=rd.get("PatientID");
					var EpisodeID=rd.get("Paadm");
					for (var iV=0;iV<arrRet.length;iV++){
						if (!arrRet[iV]) continue;
						if(arrRet[iV].indexOf("��Ⱦ������V2.0") > -1){
							var strList = arrRet[iV].split("/");
							if (strList.length>1){
								strRet += "<A HREF='#' onClick='EpdReportLookUpHeader(" + PatientID + "," + EpisodeID + "," + strList[0] + ",2)' ><img src='../images/webemr/theatretomorrow.gif' alt='" + strList[1] + "' /></A>";
							}else{
								strRet += "<img src='../images/webemr/theatretomorrow.gif' alt='" + arrRet[iV] + "' />";
							}
						}else if(arrRet[iV].indexOf("��Ⱦ������V1.0") > -1){
							var strList = arrRet[iV].split("/");
							if (strList.length>1){
								strRet += "<A HREF='#' onClick='EpdReportLookUpHeader(" + PatientID + "," + EpisodeID + "," + strList[0] + ",1)' ><img src='../images/webemr/theatretomorrow.gif' alt='" + strList[1] + "' /></A>";
							}else{
								strRet += "<img src='../images/webemr/theatretomorrow.gif' alt='" + arrRet[iV] + "' />";
							}
						}else if(arrRet[iV].indexOf("��Ⱦ������") > -1){
							strRet += "<img src='../images/webemr/theatretomorrow.gif' alt='" + arrRet[iV] + "' />";
						}
					}
					return strRet;
				}
			}
			,{header: '���', width: 150, dataIndex: 'AdmDiagnos', sortable: false}
			,{header: '��������', width: 80, dataIndex: 'AdmitDate', sortable: false}
			//,{header: '����ʱ��', width: 60, dataIndex: 'AdmitTime', sortable: false}
			,{header: '����', width: 120, dataIndex: 'AdmLoc', sortable: true}
			,{header: '����ҽ��', width: 80, dataIndex: 'AdmDoc', sortable: false}
			,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: false}
			//,{header: '��Ժʱ��', width: 60, dataIndex: 'DisTime', sortable: false}
			,{header: '����', width: 120, dataIndex: 'AdmWard', sortable: true}
			,{header: '����', width: 100, dataIndex: 'AdmRoom', sortable: false}
			,{header: '��λ', width: 80, dataIndex: 'AdmBed', sortable: false}
			//,{header: 'סԺ��', width: 60, dataIndex: 'AdmDays', sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 400,
			store : obj.DataGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,plugins: obj.expCtrlDetail
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
	obj.DataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Ctrl.Epidemic';
			param.QueryName = 'QryByPaadm';
			param.Arg1 = obj.loadParamArg1;
			param.Arg2 = obj.loadParamArg2;
			param.Arg3 = obj.loadParamArg3;
			param.Arg4 = obj.loadParamArg4;
			param.Arg5 = obj.loadParamArg5;
			param.Arg6 = obj.loadParamArg6;
			param.Arg7 = obj.SubjectID;
			//Modified By LiYang 2012-03-19 ���ӳ������ѯ����
			param.Arg8 = obj.loadParamArg8;
			param.ArgCnt = 8;
	});
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.ConditionPanel
			,obj.DataGridPanel
		]
	});
	
	InitWinControlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function EpdReportLookUpHeader(PatientID,EpisodeID,ReportID,EpdVersion)
{
	if (EpdVersion==2){
        var strUrl = "./dhcmed.epd.report.csp?" + "PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=" + ReportID;
		//window.open(strUrl, "_blank" ,"height=680,width=880,left=10,top=10,status=yes,toolbar=no,menubar=no,location=no");
		var retValue = window.showModalDialog(strUrl,"","dialogHeight: 650px; dialogWidth: 900px");
	}else{
		var strUrl = "./websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&MepdRowid=" + ReportID;
		//window.open(strUrl, "_blank" ,"height=680,width=880,left=10,top=10,status=yes,toolbar=no,menubar=no,location=no");
		var retValue = window.showModalDialog(strUrl,"","dialogHeight: 650px; dialogWidth: 900px");
	}
}

function NewEpdReportLookUpHeader(PatientID,EpisodeID,EpdVersion)
{
	if (EpdVersion==2){
        var strUrl = "./dhcmed.epd.report.csp?" + "PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&ReportID=";
		//window.open(strUrl, "_blank" ,"height=680,width=880,left=10,top=10,status=yes,toolbar=no,menubar=no,location=no");
		var retValue = window.showModalDialog(strUrl,"","dialogHeight: 650px; dialogWidth: 900px");
	}else{
		var strUrl = "./websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&MepdRowid=";
		//window.open(strUrl, "_blank" ,"height=680,width=880,left=10,top=10,status=yes,toolbar=no,menubar=no,location=no");
		var retValue = window.showModalDialog(strUrl,"","dialogHeight: 650px; dialogWidth: 900px");
	}
}
