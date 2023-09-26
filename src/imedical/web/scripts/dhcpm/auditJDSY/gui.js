//Create by dongzt
// 20150120
//�������
function InitviewScreen(){
	var obj = new Object();
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	var statuscoderet=objAudit.StatusCode();
	var DefaultDateRet=objAudit.SelectDefaultDate();
	var AllowApprovalRet=objAudit.AllowApproval();
	//******************************Start****************************
	obj.cboDateType = Common_ComboToDateType1("cboDateType","��������","��������");
	obj.cboStatisticType = Common_ComboStatisticType("cboStatisticType","ͳ��ά��","����ά��");
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		,format : 'Y-m-d'
		,width : 120
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date().add(Date.DAY, -DefaultDateRet)
	});
	
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��������'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date()
	});
	
	
	obj.textName = new Ext.form.TextField({
		id : 'textName'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	obj.textCode = new Ext.form.TextField({
		id : 'textCode'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	
	obj.cboDemStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDemStatusStore = new Ext.data.Store({
		proxy: obj.cboDemStatusStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.cboDemStatus = new Ext.form.ComboBox({
		id : 'cboDemStatus'
		,width : 100
		,store : obj.cboDemStatusStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����״̬'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.cboDemStatusStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryLookUp';
			param.QueryName = 'PMDicLookUp';
			param.Arg1 = obj.cboDemStatus.getRawValue();;
			param.Arg2 = 'Improvement';
			param.ArgCnt = 2;
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.btnBatch = new Ext.Button({
		id : 'btnBatch'
		,iconCls : 'icon-add'
		,text : '�������'
	});
	obj.btnBatchAll = new Ext.Button({
		id : 'btnBatchAll'
		,iconCls : 'icon-add'
		,hidden:true
		//,buttonAlign : 'left'
		,text : 'ȫ���'
	});
	obj.btnBatchNot = new Ext.Button({
		id : 'btnBatchNot'
		,iconCls : 'icon-add'
		//,buttonAlign : 'left'
		,text : '��˲�ͨ��'
		,anchor:'99%'
	});
	obj.toHandle = new Ext.form.Checkbox({
		id : 'toHandle'
		,checked : true
		,fieldLabel : '�账��'
		,anchor : '99%'
	});
	obj.toHandlePanel = new Ext.Panel({
		id : 'toHandlePanel'
		//,hidden:true
		//,buttonAlign : 'left'
		//,labelAlign : 'right'
		//,columnWidth : .1
		,layout : 'form'
		,width:150
		//,anchor : '99%'
		,items:[
			obj.toHandle
		]
	});
	
	obj.chkActive = new Ext.form.Checkbox({
		id : 'chkActive'
		
		,checked : false
		,fieldLabel : 'ȫѡ'
	});
obj.chkActivePanel = new Ext.Panel({
		id : 'chkActivePanel'
		//,hidden:true
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.chkActive
		]
	});
	
	
	//****************************** End ****************************
	obj.DtlDataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,method:'POST'
	}));
	obj.DtlDataGridPanelStore = new Ext.data.Store({
		proxy: obj.DtlDataGridPanelStoreProxy,
		reader : new Ext.data.JsonReader({
				root : 'record',
				totalProperty : 'total',
				idProperty : 'DemandID'
			}, [
				{ name : 'checked', mapping : 'checked' }
				,{ name : 'DemandID', mapping : 'DemandID' }
				, { name : 'DemandType', mapping : 'DemandType' }
				, { name : 'MenuName', mapping : 'MenuName' }
				, { name : 'UserName', mapping : 'UserName' }
				, { name : 'UserPhone', mapping : 'UserPhone' }
				, { name : 'LocName', mapping : 'LocName' }
				, { name : 'DemondCode', mapping : 'DemondCode' }
				, { name : 'DemandDesc', mapping : 'DemandDesc' }
				, { name : 'EmergDegree', mapping : 'EmergDegree' }
				, { name : 'DemandStatus', mapping : 'DemandStatus' }
				, { name : 'DCreateDate', mapping : 'DCreateDate' }
				, { name : 'DCreateTime', mapping : 'DCreateTime' }
				, { name : 'DEndDate', mapping : 'DEndDate' }
				, { name : 'DEndTime', mapping : 'DEndTime' }
				, { name : 'AdjunctFlag', mapping : 'AdjunctFlag' }
				, { name : 'PMModule', mapping : 'PMModule' }
				, { name : 'DemSituation', mapping : 'DemSituation' }
				, { name : 'Serious', mapping : 'Serious' }
				, { name : 'DemandResult', mapping : 'DemandResult' }
				, { name : 'Engineer', mapping : 'Engineer' }  //
				, { name : 'DemStatusCode', mapping : 'DemStatusCode' }
			]
		)
	});
	
	
	obj.gridPMQueryCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.DtlDataGridPanel = new Ext.grid.GridPanel({
		id : 'DtlDataGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'Loading...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridPMQueryCheckCol
		//,sm:new Ext.grid.CheckboxSelectionModel()
		//,editable: true
		,store : obj.DtlDataGridPanelStore
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.gridPMQueryCheckCol
			,{header : "����",width : 150,dataIndex : 'node',align : 'center'
			,renderer: function (value, metaData, record, rowIndex, colIndex, store) 
			{  
				//var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'><img src='../scripts/dhcmed/img/export.png'/></a>";  
				//var formatStr = formatStr+" "+"<a href='javascript:void({1});' onclick='javscript:return false;' class='PMEdit'><img src='../scripts/dhcmed/img/edit.gif'/></a>";
				var strRet = "";
				var flag=record.get("AdjunctFlag")
					switch (record.get("DemStatusCode")) {
						case statuscoderet.split("^")[0] : //��˲�ͨ��
							formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>����</a>";
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						case statuscoderet.split("^")[1]: //����
						var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>����</a> "; 
						if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
						if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
						strRet = "<div class='controlBtn'>" + formatStr + "</div>";
						break;
						
						case statuscoderet.split("^")[2] :  //����
						var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>����</a> "; 
						if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
						if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
						strRet = "<div class='controlBtn'>" + formatStr + "</div>";
						break;
						case statuscoderet.split("^")[3] :  //�ύ
							formatStr=checkLevel2();
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						case statuscoderet.split("^")[4] :  //���
						    formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>����</a>";
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
							case statuscoderet.split("^")[5] : //���1
							  formatStr=checkLevel1();
							  if (flag=="Y"){
							    formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							    };
							  if (AllowApprovalRet=="Y"){
							   formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							   };
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
							
						case statuscoderet.split("^")[6] : //���ͨ��
							formatStr=CheckHandler(record.get("DemandID"),record.get("DemStatusCode"));
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						case statuscoderet.split("^")[7] : //��Ϣ��ָ�������Ա
							//alert(record.get("DemandID"))
							formatStr=checktoAudi(record.get("DemandID"));
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						case statuscoderet.split("^")[7] : //ָ�������������
							//alert(record.get("DemandID"))
							formatStr=checkLevel2();
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						case statuscoderet.split("^")[8] : //������ָ�������Ա
							//alert(record.get("DemandID"))
							formatStr=checktoAudi(record.get("DemandID"));
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						default:
							formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>����</a>";
							if (flag=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>����</a>";
							};
							if (AllowApprovalRet=="Y"){
							formatStr=formatStr+" | <a href='javascript:void({4});' onclick='javscript:return false;' class='UpdateIPML'>�޸�</a>";
							};
							strRet = "<div class='controlBtn'>" + formatStr + "</div>";
							break;
						
						
					}
					return strRet;
 
			}
			}
			, { header : '�������', width : 80, dataIndex : 'DemondCode', sortable : false, align : 'center',editable: true }
			, { header : '��������', width : 200, dataIndex : 'DemandDesc', sortable : false ,align : 'center'}
			, { header : '��������', width : 80, dataIndex : 'DemandType', sortable : true, align : 'center' }
			, { header : '�˵�����', width : 120, dataIndex : 'MenuName',sortable : true,align : 'center' }
			, { header : '״̬', width : 150, dataIndex : 'DemandStatus',align : 'center'
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("DemandStatus")) {
						case "��˲�ͨ��" :
							strRet = "<div style='color:red';font-weight:bold>" + value + "</div>";
							break;
						case "���ͨ��" :
							strRet = "<div style='color:orange';font-weight:bold>" + value + "</div>";
							break;
						case "�ύ" :
							strRet = "<div style='color:green'>" + value + "</div>";
							break;
						case "����" :
							strRet = "<div style='color:orange'>" + value + "</div>";
							break;
						case "����" :
							strRet = "<div style='color:#8968CD'>" + value + "</div>";
							break;
						case "���1" :
							strRet = "<div style='color:blue'>" + value + "</div>";
							break;
						case "����" :
							strRet = "<div style='color:gray'>" + value + "</div>";
							break;
						default :
							strRet = "<div style='color:black'>" + value + "</div>";
							break;
					}
					return strRet;
				}
			
			
			}
			, { header : '������', width : 60, dataIndex : 'UserName', sortable : false, align : 'center' }
			, { header : '��ϵ�绰', width : 80, dataIndex : 'UserPhone', sortable : false, align : 'center' }
			, { header : '����', width : 120, dataIndex : 'LocName', sortable : false, align : 'center' }
			
			, { header : '�����̶�', width : 80, dataIndex : 'EmergDegree', sortable : false }
			
			, { header : '��������', width : 80, dataIndex : 'DCreateDate', sortable : false }
			, { header : '����ʱ��', width : 80, dataIndex : 'DCreateTime', sortable : false, align : 'center' } 
			, { header : '�������', width : 80, dataIndex : 'DEndDate', sortable : true, align : 'center' }
			, { header : '���ʱ��', width : 80, dataIndex : 'DEndTime', sortable : false, align : 'center' } 
			, { header : '������־', width : 80, dataIndex : 'AdjunctFlag', hidden:true,sortable : true, align : 'center' }
			, { header : '״̬����', width : 80, dataIndex : 'StatusChange', align : 'center'
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					var formatStr="";
					if(obj.toHandle.getValue())
					{
						formatStr=checkSuperAuth();}
					strRet = "<div class='controlBtn'>" + formatStr + "</div>";
					return strRet;
				}
			}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.DtlDataGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
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
	
	//function

	//--------------------------------------------------------------------
	obj.StaDetailPanal=new Ext.Panel({
			id : 'StaDetailPanal'
			,layout : 'fit'
			,width : '100%'
			//,height : 200
			//,height: '100%'
			,region : 'center'
			//,split: true
			,collapsible: true
			
			//,collapseDirection:'bottom'
			//,margins: '0 0 0 5'
			//,autoScroll : true
			//,animCollapse: true
			,border:true
			//,width : 300
			,items:[
			obj.DtlDataGridPanel
			
		]
			
		});
	
	
	
	//--------------------------------------------------------------------
	
	
		
	/* obj.DataGridPanel = new Ext.Panel({
		id : 'DataGridPanel'
		,buttonAlign : 'center'
		,layout : 'fit'
		,region : 'center'
		,items:[
		obj.StaDetailPanal
		]
	}); */
	//---------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [
			//obj.ConditionPanel
			//,obj.ConditionPanel2
			//obj.DataGridPanel,
			obj.StaDetailPanal,
			//,obj.ChartPanel
			{
				layout : 'form',
				region : 'north',
				height : 90,
				frame : true,
				buttonAlign : 'center',
				title : '�������',
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDateType
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.dtFromDate
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.dtToDate
								]
							},{
								columnWidth:.20,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								buttonAlign : 'center',
								items : [
									obj.btnQuery
								]  //obj.toHandle
							},obj.toHandlePanel
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.textName
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemStatus
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.textCode
								]
							},{
								columnWidth:.20,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [
									obj.btnBatch
								]
							},{
								columnWidth:.20,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [
									obj.btnBatchNot
								]
							},{
								columnWidth:.20,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 100,
								items : [
									obj.btnBatchAll
								]
							}							
						]
					}
				]
			}
		]
	});
	
	obj.DtlDataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Audit.PMAudit';
			param.QueryName = 'QryAuditorDemInfo';
			param.Arg1 = obj.cboDateType.getValue(); //"Common_GetValue('cboDateType');��
			param.Arg2 = obj.dtFromDate.getRawValue(); 
			param.Arg3 = obj.dtToDate.getRawValue(); 
			param.Arg4 = obj.textName.getValue();
			param.Arg5 = obj.cboDemStatus.getValue();
			param.Arg6 = obj.textCode.getValue();
			param.Arg7 = obj.toHandle.getValue();
			param.ArgCnt = 7;
	});
	obj.DtlDataGridPanelStore.removeAll();
	obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);
		
	//�¼��������
	obj.LoadEvent(arguments);
	
	
	return obj;
}
//��Ŀ�������������С����
function DistrSubScreen(){
	
	var obj = new Object();
		
 obj.cboDemUser = Common_ComboDemHandler("cboDemUser","��������","");
obj.winTPanelUser = new Ext.Panel({
		id : 'winTPanelUser'
		,buttonAlign : 'center'
		//,region : 'center'
		//,columnWidth : .3
		,layout : 'form'
		,anchor : '60%'
		,items:[
			obj.cboDemUser
		]
	}); 
	
	obj.winfDemResult = new Ext.form.TextArea({ 
		id : 'winfDemResult'
		,height : 100
		,fieldLabel : '����'
		,anchor : '90%'
	});
	obj.winTPanelResult = new Ext.Panel({
		//title: '����'
		id : 'winTPanelResult'
		,buttonAlign : 'center'
		,border: true
		//,margins: '{5000,0,0,5000}'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfDemResult
		]
	});
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
		});
		
		
	obj.btnDistribute = new Ext.Button({
		id : 'btnDistribute'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : '��ɷ���'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : 'ȡ��'
	});
	
	
obj.winTPanelName1 = new Ext.Panel({
		id : 'winTPanelName1'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		//,height:'80%'
		//,title : '������Ա'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,items:[
			obj.winTPanelUser
			,obj.winTPanelResult	
			,obj.DemandID
		]
		
	}); 
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 280
		,buttonAlign : 'center'
		,width : 500
		,modal : true
		,title : '��Ա����'
		,layout : 'border'
		,border:true
		,items:[
			obj.winTPanelName1
			//obj.winTPanelUser
		]
		,	buttons:[
			obj.btnDistribute
			,obj.btnCancel
			
		]
	});
	
	
	
	DistrSubScreenEvent(obj);
	
	
	
	//�¼��������
	obj.LoadEvent(arguments);
	
	return obj;
	
}


//��Ϣ�Ʒ����������С����
function toAuditSubScreen(){
	
	var obj = new Object();
		
 obj.cboAuditUser = Common_ComboUser("cboAuditUser","�������","");
obj.winAudiUserPanel = new Ext.Panel({
		id : 'winAudiUserPanel'
		,buttonAlign : 'center'
		//,region : 'center'
		//,columnWidth : .3
		,layout : 'form'
		,anchor : '60%'
		,items:[
			obj.cboAuditUser
		]
	}); 
	
	obj.winAudiResult = new Ext.form.TextArea({ 
		id : 'winAudiResult'
		,height : 100
		,fieldLabel : '˵��'
		,anchor : '90%'
	});
	obj.winexplainPanel = new Ext.Panel({
		//title: '����'
		id : 'winexplainPanel'
		,buttonAlign : 'center'
		,border: true
		//,margins: '{5000,0,0,5000}'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winAudiResult
		]
	});
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
		});
		
		
	obj.btnConfirm = new Ext.Button({
		id : 'btnConfirm'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : 'ȷ��'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : 'ȡ��'
	});
	
	
obj.winTPanelName1 = new Ext.Panel({
		id : 'winTPanelName1'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		//,height:'80%'
		,title : '������Ա'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,items:[
			obj.winAudiUserPanel
			,obj.winexplainPanel	
			,obj.DemandID
		]
		
	}); 
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 280
		,buttonAlign : 'center'
		,width : 500
		,modal : true
		,title : '�������Ա'
		,layout : 'border'
		,border:true
		,items:[
			obj.winTPanelName1
			//obj.winTPanelUser
			
		
	
		]
		,	buttons:[
			obj.btnConfirm
			,obj.btnCancel
			
		]
	});
	
	
	
	toAuditSubScreenEvent(obj);
	
	
	//�¼��������
	obj.LoadEvent(arguments);
	
	return obj;
	
}
// ~!!������
//��˲�ͬ����дԭ��С����
function toNotSubScreen(){
	
	var obj = new Object();
	obj.NotRowid = new Ext.form.TextField({
		id : 'NotRowid'
		,hidden : true
		});
    obj.WinNotMenuid=new Ext.form.HtmlEditor({
	    id:'WinNotMenuid'
	    ,xtype: "htmleditor",
        name: "content",
        //fieldLabel: "����",
        height: 300,
		enableSourceEdit: false
		
	    })
	//obj.WinNotMenuid={xtype:'htmleditor',id:'WinNotMenuid'};
	obj.WinNotMenuPanel = new Ext.Panel({
		//title: '����'
		id : 'WinNotMenu'
		,width:600,
		height:300,
		layout:'column',
		Resizable:'yes'
		,items:[obj.NotRowid,obj.WinNotMenuid]
	});
	obj.btnNotY = new Ext.Button({
		id : 'btnNotY'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : 'ȷ��'
	});
	
	obj.btnNotN = new Ext.Button({
		id : 'btnNotN'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : 'ȡ��'
	});
	
	
obj.winNotPanel = new Ext.Panel({
		id : 'winNotPanel'
		,labelAlign : 'lift'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		//,height:'80%'
		//,title : '��˲�ͨ��'
		,layout : 'column'
		,region : 'center'
		,frame : true
		,items:[obj.WinNotMenuPanel]
	}); 
	obj.winNot = new Ext.Window({
		id : 'winNot'
		,height : 300
		,buttonAlign : 'center'
		,width : 520
		,modal : true
		,title : '��˲�ͨ��'
		,layout : 'border'
		,border:true
		,items:[
			obj.winNotPanel
			//obj.winTPanelUser
		]
		,buttons:[
			obj.btnNotY
			,obj.btnNotN
		]
	});
	toNotSubScreenEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	
	return obj;
}

//disagree
function DisAgreeScreen(){
	
	var obj = new Object();
	
	
	obj.winfDemResult = new Ext.form.TextArea({ 
		id : 'winfDemResult'
		,height : 100
		,fieldLabel : '����'
		,anchor : '90%'
	});
	obj.winTPanelResult = new Ext.Panel({
		//title: '����'
		id : 'winTPanelResult'
		,buttonAlign : 'center'
		,border: true
		//,margins: '{5000,0,0,5000}'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfDemResult
		]
	});
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
		});
		
		
	obj.btnConfirm = new Ext.Button({
		id : 'btnDistribute'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : 'ȷ��'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : 'ȡ��'
	});
	
	
obj.winTPanelName1 = new Ext.Panel({
		id : 'winTPanelName1'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		//,height:'80%'
		,title : '�������'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,items:[
			
			obj.winTPanelResult	
			,obj.DemandID
		]
		
	}); 
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 280
		,buttonAlign : 'center'
		,width : 500
		,modal : true
		,title : '��Ա����'
		,layout : 'border'
		,border:true
		,items:[
			obj.winTPanelName1
			//obj.winTPanelUser
			
		
	
		]
		,	buttons:[
			obj.btnConfirm
			,obj.btnCancel
			
		]
	});
	
	
	
	DisAgreeScreenEvent(obj);
	
	
	
	//�¼��������
	obj.LoadEvent(arguments);
	
	return obj;
	
}

