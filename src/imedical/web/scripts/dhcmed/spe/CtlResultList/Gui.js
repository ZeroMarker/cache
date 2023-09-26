var objScreen = new Object();
function InitWinControl(){
	var obj = new Object();
	objScreen = obj;
	
	obj.SelectNode = null;
	obj.QueryArgs = new Object();
	obj.QueryArgs.DateFrom = '';
	obj.QueryArgs.DateTo = '';
	obj.QueryArgs.CtrlItems = '';
	obj.QueryArgs.LocID = '';
	obj.QueryArgs.WardID = '';
	obj.QueryArgs.HospID = '';
	//���⻼�߱��Ȩ��
	if (typeof tDHCMedMenuOper=="undefined") {
		ExtTool.alert("��ʾ","��û�в���Ȩ�ޣ����������Ա����Ȩ��!");
		return;
	}
	//�����Ŀ��
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
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"SPE");
    obj.cboLoc = Common_ComboToLoc("cboLoc","����","E","","I","cboSSHosp");
    obj.cboWard = Common_ComboToLoc("cboWard","����","W","cboLoc","I","cboSSHosp");
	obj.DateFrom = Common_DateFieldToDate("DateFrom","��ʼ����");
	obj.DateTo = Common_DateFieldToDate("DateTo","��������");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor:'100%'
		,text : '��ѯ'
		,height: 25
	});
    obj.btnExport = new Ext.Button({
		id:'btnExport'
		,iconCls:'icon-export'
		,anchor:'100%'
		,text:'����'
		,height: 25
    });
	
    obj.btnControl = new Ext.Button({
		id:'btnControl'
		,iconCls:'icon-update'
		,anchor:'100%'
		,text:'���'
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
		,height : 200
		,items:[
			obj.cboSSHosp
			,obj.DateFrom
			,obj.DateTo
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
		,title: '��ѡ��ɸ������...'
		,autoScroll : true
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
			'<div id="divCtrlDtl-{Paadm}-{CtrlDtl}"></div>'
			//fix bug 148479 ����һ�����������ͬһ���˶�����¼ֻ�ܴ�һ�ε����
        )
    });
	
	//�����б�
	obj.CtlPaadmGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CtlPaadmGridStore = new Ext.data.Store({
		proxy: obj.CtlPaadmGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Ind'
		}, 
		[
			{name: 'Ind', mapping: 'Ind'}
			,{name: 'CtrlCont', mapping: 'CtrlCont'}
			,{name: 'CtrlDtl', mapping: 'CtrlDtl'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'Room', mapping: 'Room'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'LocID', mapping: 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'WardID', mapping: 'WardID'}
			,{name: 'WardDesc', mapping: 'WardDesc'}
			,{name: 'DoctorID', mapping: 'DoctorID'}
			,{name: 'DoctorName', mapping: 'DoctorName'}
			,{name: 'PatTypes', mapping: 'PatTypes'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.CtlPaadmGrid = new Ext.grid.GridPanel({
		id : 'CtlPaadmGrid'
		,store : obj.CtlPaadmGridStore
		,region : 'center'
		,buttonAlign : 'center'
		,frame : true
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.RowExpander
			,{header: '�ǼǺ�', width: 80, dataIndex: 'RegNo', sortable: true, align: 'center'}
			,{header: '��������', width: 80, dataIndex: 'PatientName', sortable: true, align: 'center'}
			,{header: '�Ա�', width: 50, dataIndex: 'Sex', sortable: true, align: 'center'}
			,{header: '����', width: 50, dataIndex: 'Age', sortable: true, align: 'center'}
			,{header : '����<br>�ܼ�', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����<br>����', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��Ժ����', width: 80, dataIndex: 'AdmitDate', sortable: true, align: 'center'}
			,{header: 'ɸ������', width: 80, dataIndex: 'CtrlCont', sortable: false, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��������', width: 80, dataIndex: 'PatTypes', sortable: true, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					if (v == "") return "";
					var arryRows = v.split(String.fromCharCode(1));
					var strRet = "";
					var arryFields = null;
					for (var i = 0; i < arryRows.length; i ++){
						if(arryRows[i] == "") continue;
						arryFields = arryRows[i].split("^");
						if (arryFields[1] == '0') continue;  //����״̬
						strRet += "<A href='#' onmousedown='return objScreen.DisplaySpeMarkWin(" + arryFields[0] + ");'>"
						strRet += "<img src='../scripts/dhcmed/img/spe/" + arryFields[4] + "' width='16' height='16' alt='" + arryFields[3] + "-" + arryFields[2]+"'  title='" + arryFields[3] + "-" + arryFields[2]+"'/>"
						strRet += "</A>";
					}
					m.attr = 'style="white-space:normal;"';
					return strRet;
				}
			}
			,{header: '����', width: 100, dataIndex: 'LocDesc', sortable: true, align: 'left'}
			,{header: '����', width: 100, dataIndex: 'WardDesc', sortable: true, align: 'left'}
			,{header: '����', width: 80, dataIndex: 'Bed', sortable: true, align: 'center'}
			,{header: '����ҽ��', width: 80, dataIndex: 'DoctorName', sortable: true, align: 'center'}
			,{header: '�����', width: 80, dataIndex: 'Paadm', sortable: true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 15,
			store : obj.CtlPaadmGridStore,
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
	
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.ConditionPanel
			,obj.CtlPaadmGrid
		]
	});
	
	obj.CtlPaadmGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCMed.SPEService.PatientsQry";
		param.QueryName = 'QryCtlPaadm';
		param.Arg1 = obj.QueryArgs.DateFrom;
		param.Arg2 = obj.QueryArgs.DateTo;
	    param.Arg3 = obj.QueryArgs.CtrlItems;
		param.Arg4 = obj.QueryArgs.LocID;
		param.Arg5 = obj.QueryArgs.WardID;
	    param.Arg6 = obj.QueryArgs.HospID;
		param.ArgCnt = 6;
	});
	
	InitWinControlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}