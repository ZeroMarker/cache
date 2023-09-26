var objScreen = new Object();
function InitSpeCheckList(){
	var obj = objScreen;
	obj.InputObj = new Object();
	obj.InputObj.OperTpCode = OperTpCode;
	obj.SelectRow = new Object();
	obj.SelectRow.SepID = '';
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"SPE");
	obj.cboLoc = Common_ComboToLoc("cboLoc","���ο���","E","","","cboSSHosp");
	obj.cboQryStatus = Common_ComboToDic("cboQryStatus","״̬","SPECheckStatus",'^');
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","��ѯ����");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","��");
	obj.txtRegNo = Common_TextField("txtRegNo","�ǼǺ�");
	obj.txtPatName = Common_TextField("txtPatName","��������");
	// �������,�س��Զ����� 
	obj.txtRegNo.on('specialKey', function(field, e){   
	 // �����س�����   
    	if (e.getKey() == Ext.EventObject.ENTER) {//��Ӧ�س�  
        	obj.txtRegNoENTER();//����س��¼�  
        }
     });  
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
		,width : 80
		,anchor : '98%'
	});
	
	obj.cboPatTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPatTypeStore = new Ext.data.Store({
		proxy: obj.cboPatTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTSID'
		}, 
		[
			{name: 'PTSID', mapping: 'PTSID'}
			,{name: 'PTSDesc', mapping: 'PTSDesc'}
			
		])
	});
    obj.cboPatType = new Ext.form.ComboBox({
		id : 'cboPatType'
		,minChars : 1
		,valueField:'PTSID'
		,displayField : 'PTSDesc'
		,fieldLabel : '��������'
		,emptyText: '��ѡ��'
		,store : obj.cboPatTypeStore
		,triggerAction : 'all'
		,width : 10
		,anchor : '98%'
		,editable : true
		,mode: 'local'
	});
	/*
	obj.RowTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<tpl if="this.isNull(ArryNews)==0">',
				'<div style="background-color:#FFFFFF;">',
					'<table border=0 cellpadding=0 cellspacing=0 style="margin-left:25px;border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:900px;word-break:break-all; word-wrap:break-all;">',
						'<tr style="font-size:18px;height:30px;">',
							'<td align="center" style="border:1 solid #FFFFFF;" width="5%">���</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="8%">����</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="30%">��Ϣ</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="8%">�Ķ�״̬</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="14%">����ʱ��</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="8%">������</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="14%">�Ķ�ʱ��</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="8%">�Ķ���</td>',
							'<td align="center" style="border:1 solid #FFFFFF;" width="5%">����</td>',
						'</tr>',
						'<tbody>',
							'<tpl for="ArryNews">',
								'<tr style="border-bottom:0px #BDBDBD solid;">',
									'<td align="center" style="border:1 solid #FFFFFF;">{#}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;">{NewsTypeDesc}</td>',
									'<td align="left" style="border:1 solid #FFFFFF;">{Opinion}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;">{ReadStatus}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;">{ActDate} {ActTime}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;">{ActUserDesc}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;">{ReadDate} {ReadTime}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;">{ReadUserDesc}</td>',
									'<td align="center" style="border:1 solid #FFFFFF;"><span onclick="objScreen.btnDeleteNews_Click(\'{SpeLogID}\');" style="color:#CE0000;text-decoration:underline;cursor:pointer;" align="center">ɾ��</span></td>',
								'</tr>',
							'</tpl>',
						'</tbody>',
					'</table>',
				'</div>',
			'</tpl>',
			'<div style="background-color:#FFFFFF;">',
				'<span>',
				'<span><input type="text" id="txtOpinion-{SpeID}" style="margin-left:25px;width:500px;height:24px;font-size:14px;text-align:left;"/></span>',
				'&nbsp;&nbsp;&nbsp;&nbsp;',
				'<span onclick="objScreen.btnSendNews_Click({SpeID});" style="width:80px;height:24px;font-size:16px;color:#CE0000;text-decoration:underline;cursor:pointer;" align="center">������Ϣ</span>',
				'&nbsp;&nbsp;&nbsp;&nbsp;',
				'<span onclick="objScreen.btnReadNews_Click({SpeID});" style="width:80px;height:24px;font-size:16px;color:#CE0000;text-decoration:underline;cursor:pointer;" align="center">�Ķ���Ϣ</span>',
				'</span>',
			'</div>',
		'</tpl>',
		{
			isNull : function(arr){
				return (arr.length < 1);
			}
		}
	);
	
	obj.RowExpander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.XTemplate(
			'<div id="divNewsDtl-{SpeID}"></div>'
        )
    });
	*/
	//�����б�
	obj.gridSpeCheckListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridSpeCheckListStore = new Ext.data.Store({
		proxy: obj.gridSpeCheckListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SpeID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SpeID', mapping : 'SpeID'}
			,{name: 'PatTypeID', mapping : 'PatTypeID'}
			,{name: 'PatTypeDesc', mapping : 'PatTypeDesc'}
			,{name: 'StatusCode', mapping : 'StatusCode'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
			,{name: 'DutyUserID', mapping : 'DutyUserID'}
			,{name: 'DutyUserDesc', mapping : 'DutyUserDesc'}
			,{name: 'DutyDeptID', mapping : 'DutyDeptID'}
			,{name: 'DutyDeptDesc', mapping : 'DutyDeptDesc'}
			,{name: 'MarkDate', mapping : 'MarkDate'}
			,{name: 'MarkTime', mapping : 'MarkTime'}
			,{name: 'Note', mapping : 'Note'}
			,{name: 'Opinion', mapping : 'Opinion'}
			,{name: 'CheckDate', mapping : 'CheckDate'}
			,{name: 'CheckTime', mapping : 'CheckTime'}
			,{name: 'CheckOpinion', mapping : 'CheckOpinion'}
			,{name: 'ReadStatus', mapping : 'ReadStatus'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'RegNo', mapping : 'RegNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'PatientAge', mapping : 'PatientAge'}
			,{name: 'AdmDate', mapping : 'AdmDate'}
			,{name: 'AdmTime', mapping : 'AdmTime'}
			,{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping : 'LocDesc'}
			,{name: 'WardID', mapping : 'WardID'}
			,{name: 'WardDesc', mapping : 'WardDesc'}
			,{name: 'Bed', mapping : 'Bed'}
			,{name: 'DoctorID', mapping : 'DoctorID'}
			,{name: 'DoctorName', mapping : 'DoctorName'}
		])
	});
	obj.gridSpeCheckList = new Ext.grid.GridPanel({
		id : 'gridSpeCheckList'
		,store : obj.gridSpeCheckListStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}
		,tbar : ['->','-',obj.btnQuery]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�ǼǺ�', width: 70, dataIndex: 'RegNo', sortable: true}
			,{header: '��������', width: 70, dataIndex: 'PatName', sortable: true}
			,{header: '�Ա�', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '����', width: 50, dataIndex: 'PatientAge', sortable: true}
			,{header: '��Ժ����', width: 70, dataIndex: 'AdmDate', sortable: true}
			,{header: '��������', width: 80, dataIndex: 'PatTypeDesc', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					if (v == "") return "";
					var SpeID = rd.get('SpeID');
					var strRet = "";
					strRet += "<A href='#' onmousedown='return objScreen.DisplaySpeCheckWin(" + SpeID + ");'>" + v + "</A>";
					m.attr = 'style="white-space:normal;"';
					return strRet;
				}
			}
			,{header: '״̬', width: 50, dataIndex: 'StatusDesc', sortable: true}
			,{header: '��Ϣ', width: 70, dataIndex: 'ReadStatus', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					if (v == "") return "";
					var SpeID = rd.get('SpeID');
					var strRet = "";
					strRet += "<A href='#' onmousedown='return objScreen.OpenSpeNewsWin(" + SpeID + ");'>" + v + "</A>";
					m.attr = 'style="white-space:normal;"';
					return strRet;
				}
			}
			,{header: '���˵��', width: 150, dataIndex: 'Note', sortable: true}
			,{header: '�������', width: 70, dataIndex: 'MarkDate', sortable: true}
			,{header: '������', width: 150, dataIndex: 'CheckOpinion', sortable: true}
			,{header: '�������', width: 70, dataIndex: 'CheckDate', sortable: true}
			,{header: '�������', width: 120, dataIndex: 'LocDesc', sortable: true}
			,{header: '����', width: 120, dataIndex: 'WardDesc', sortable: true}
			,{header: '����', width: 60, dataIndex: 'Bed', sortable: true}
			,{header: 'ҽ��', width: 70, dataIndex: 'DoctorName', sortable: true}
			,{header: '�����', width: 50, dataIndex: 'EpisodeID', sortable: true}
		]
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
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridSpeCheckListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
	});
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.gridSpeCheckList
			,{
				layout : 'form'
				,region : 'north'
				,height : 65
				,frame : true
				,items :[
					{
						layout : 'column'
						,items : [
							{
								width: 250
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboSSHosp]
							},{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateFrom]
							},{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateTo]
							},{
								width: 180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboQryStatus]
							},{
								width : 180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboPatType]
							}
						]
					},{
						layout : 'column'
						,items : [
							{
								width : 250
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboLoc]
							},{
								width : 180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtRegNo]
							},{
								width : 180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtPatName]
							}
						]
					}
				]
			}
		]
	});
	
	obj.gridSpeCheckListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCMed.SPEService.PatientsQry"
		param.QueryName = "QrySpeCheckList"
		param.Arg1 = obj.GetStatusCode("cboQryStatus");
		param.Arg2 = obj.InputObj.OperTpCode;
		param.Arg3 = Common_GetValue("cboSSHosp");
		param.Arg4 = Common_GetValue("txtDateFrom");
		param.Arg5 = Common_GetValue("txtDateTo");
		param.Arg6 = Common_GetValue("cboPatType");
		param.Arg7 = Common_GetValue("cboLoc");
		param.Arg8 = Common_GetValue("txtRegNo");
		param.Arg9 = Common_GetValue("txtPatName");
		param.ArgCnt = 9;
	});
	
	obj.cboPatTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SPEService.PatTypeSub';
		param.QueryName = 'QryAllPatTypeSub';
		param.ArgCnt = 0;
	});
	
	InitSpeCheckListEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}