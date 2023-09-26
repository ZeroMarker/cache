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
	
    obj.mnuMenu = new Ext.menu.Menu({
        items : [
		   {
			   id : 'mnuBaseInfo',
			   text : '<B>ժҪ<B/>',
			   iconCls : ''
		   }
        ]
    })
	
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
	
	obj.radioDateType1 = new Ext.form.Radio({
		id : 'radioDateType1'
		,name : 'radioDateType'
		,boxLabel : '��������'
		,inputValue : '1'
	});
	obj.radioDateType2 = new Ext.form.Radio({
		id : 'radioDateType2'
		,name : 'radioDateType'
		,boxLabel : '�������'
		,inputValue : '2'
	});
	obj.radioDateType = new Ext.form.RadioGroup({
		id : 'radioDateType'
		,fieldLabel : '��������'
		,items:[
			obj.radioDateType1
			,obj.radioDateType2
		]
	});
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"NINF");
    obj.cboLoc = Common_ComboToLoc("cboLoc","����","E","","I","cboSSHosp");
    obj.cboWard = Common_ComboToLoc("cboWard","����","W","","I","cboSSHosp");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","��ʼ����");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","��������");
	
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
		,height : 220
		,items:[
			obj.cboSSHosp
			,obj.radioDateType
			,obj.dfDateFrom
			,obj.dfDateTo
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
		,title: '��ѡ��������...'
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
					'<td align="center" style="border:1 solid #FFFFFF;" width="3%">���</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">��Ŀ</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="30%">ժҪ</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">����Ա</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����</td>',
					//'<td align="center" style="border:1 solid #FFFFFF;" width="6%">�������</td>',
					//'<td align="center" style="border:1 solid #FFFFFF;" width="6%">��������</td>',
				'</tr>',
				'<tbody>',
					'<tpl for=".">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{ItemDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ItemGroup}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{Summary}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{DataTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActUser}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActLoc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActWard}</td>',
							//'<td align="center" style="border:1 solid #FFFFFF;">{ActDate} {ActTime}</td>',
							//'<td align="center" style="border:1 solid #FFFFFF;">{OccurDate} {OccurTime}</td>',
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
			idProperty: 'Ind' //Add By LiYang 2014-07-07 FixBug:2043 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�ۺϼ��-��ѯʱ���ڣ����߶��հ��������Ŀ����¼����ϼ�����ʾ����ͬ
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
			,{name: 'CtrlDtl', mapping: 'CtrlDtl'}
			,{name: 'Ind', mapping: 'Ind'}//Add By LiYang 2014-07-07 FixBug:2043 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�ۺϼ��-��ѯʱ���ڣ����߶��հ��������Ŀ����¼����ϼ�����ʾ����ͬ
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
			,{header: '�ǼǺ�', width: 100, dataIndex: 'PapmiNo', sortable: false}
			,{header: '��������', width: 100, dataIndex: 'PatName', sortable: false}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: false}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: false}
			,{header: '��Ժ����', width: 80, dataIndex: 'AdmitDate', sortable: false}
			,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: false}
			,{header: '��λ', width: 80, dataIndex: 'AdmBed', sortable: false}
			,{header: '����', width: 150, dataIndex: 'AdmLoc', sortable: true}
			,{header: '����', width: 150, dataIndex: 'AdmWard', sortable: true}
			,{header: '����ҽ��', width: 80, dataIndex: 'AdmDoc', sortable: false}
			,{header: '��������', width: 80, dataIndex: 'AdmType', sortable: false}
			,{header: '�����', width: 80, dataIndex: 'Paadm', sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
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
		param.ClassName = 'DHCMed.NINFService.BC.CtlResultSrv';
		param.QueryName = 'QryCtlPaadm';
		param.Arg1 = obj.QueryArgs.DateType;
		param.Arg2 = obj.QueryArgs.DateFrom;
		param.Arg3 = obj.QueryArgs.DateTo;
		param.Arg4 = obj.QueryArgs.CtrlItems;
		param.Arg5 = obj.QueryArgs.LocID;
		param.Arg6 = obj.QueryArgs.WardID;
		param.Arg7 = obj.QueryArgs.HospID;
		param.ArgCnt = 7;
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