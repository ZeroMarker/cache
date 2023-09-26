//Create by dongzt
// 20150121
//������
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.cboDateType = Common_ComboToDateType1("cboDateType","��������","��������");
	
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date()
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
	obj.cboDemStatus = Common_ComboToDic("cboDemStatus","����״̬","Improvement");
	/* obj.cboDemStatus = new Ext.form.ComboBox({
		id : 'cboDemStatus'
		,width : 100
		,store : obj.cboDemStatusStore
		//,minChars : 1
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
	}); */
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		//,buttonAlign : 'center'
		,columnWidth : .3
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.btnUpStatus = new Ext.Button({
		id : 'btnUpStatus'
		//,buttonAlign : 'center'
		,columnWidth : .3
		,iconCls : 'icon-find'
		,text : '״̬����'
	});
	
	
	obj.FromDatePanel = new Ext.Panel({
		id : 'FromDatePanel'
		
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		//,anchor : '100%'
		,items:[
			//obj.dtFromDate
		
		]
	});
	
	
obj.ToDatePanel = new Ext.Panel({
		id : 'ToDatePanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			//obj.dtToDate
		]
	});
	
	obj.winFPanelbtn = new Ext.form.FormPanel({
		id : 'winFPanelbtn'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.FromDatePanel
			,obj.btnQuery
			,obj.btnUpStatus
			,obj.ToDatePanel
			
		]
	});
	
	
	obj.btnBatch = new Ext.Button({
		id : 'btnBatch'
		,iconCls : 'icon-add'
		,text : '�������'
	});
	obj.btnBatchAll = new Ext.Button({
		id : 'btnBatchAll'
		,iconCls : 'icon-add'
		,text : 'ȫ���'
	});
	
	
	obj.toHandle = new Ext.form.Checkbox({
		id : 'toHandle'
		
		,checked : true
		,fieldLabel : '�账��'
	});
obj.chkActivePanel = new Ext.Panel({
		id : 'chkActivePanel'
		//,hidden:true
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			//obj.chkActive
		]
	});
	
	
	obj.ConditionPanal=new Ext.Panel({
			id : 'ConditionPanal'
			,title:'��ѯ����'
			,layout : 'form'
			,region:'west'
			,frame : true
			,border:true
			,width : 270
			//,height:250
			//,height : 200
			//,height: 514
			,region : 'east'
			,split: true
			//,columnWidth: 0.20
			,collapsible: true
			
			//,collapseDirection:'bottom'
			,collapseDirection:'left'      //'top', 'bottom', 'left' or 'right'
			//,margins: '0 0 0 50'
			//,autoScroll : true
			,animCollapse: true
			
			//,width : 300
			,items:[
			obj.cboDateType
			,obj.dtFromDate
			,obj.dtToDate
			,obj.textName
			,obj.textCode
			,obj.cboDemStatus
			,obj.toHandle 
			,obj.winFPanelbtn
			/* obj.winDemName
			,obj.winFPanel1
			,obj.winFPanel2
			,obj.winTPanelDesc
			,obj.winFPanel3
			,obj.winFPanel4
			,obj.winHosStr
			,obj.winPrjStr
			,obj.winOtherStr
			,obj.winComNote
			,obj.winFPanel5 */
			
			
			
		]/* ,	buttons:[
			
			
			
		] */
			
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
				, { name : 'Engineer', mapping : 'Engineer' }
				, { name : 'InHanderName', mapping : 'InHanderName' }
				, { name : 'EditDemDesc', mapping : 'EditDemDesc' }
				, { name : 'EditUser', mapping : 'EditUser' }
				
			]
		)
	});
	
	
	obj.gridPMQueryCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 50,checked:true });  //checkbox
	obj.DtlDataGridPanel = new Ext.grid.GridPanel({
		id : 'DtlDataGridPanel'
		,title: '�����б�' 
		,loadMask : true
		,region : 'center'
		//,region : 'center'
		,buttonAlign : 'center'
		,loadMask : {text:'Loading...'}
		//,region : 'west'
		//,autoHeight:true
		,height:250
		,width:'70%'
		//,collapseDirection:'bottom'
		//,split: true
		//,collapsible: true
		//,width : 300
		//,height: 514
		//,columnWidth: 0.80
		//,minHeight: 10
        //,maxHeight: 500
		,border: true
		,collapsible: true
		//,collapsed:true
		
		,plugins : obj.gridPMQueryCheckCol
		,sm: new Ext.grid.RowSelectionModel({ singleSelect: true })
		//,sm:new Ext.grid.CheckboxSelectionModel()
		//,editable: true
		,store : obj.DtlDataGridPanelStore
		,columns: [
			//new Ext.grid.RowNumberer()
			//,obj.gridPMQueryCheckCol
			{header : "����",width : 50,dataIndex : 'node',align : 'center'
			,renderer: function (value, metaData, record, rowIndex, colIndex, store) 
			{  
				//var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'><img src='../scripts/dhcmed/img/export.png'/></a>";  
				//var formatStr = formatStr+" "+"<a href='javascript:void({1});' onclick='javscript:return false;' class='PMEdit'><img src='../scripts/dhcmed/img/edit.gif'/></a>";
				var strRet = "";
				
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>����</a>";
	
							strRet = "<div class='controlBtn' >" + formatStr + "</div>";
				
					return strRet;
 
			}
			}
			,{header : "��Ӽ�¼",width : 80,dataIndex : 'addRec',align : 'center'
			,renderer: function (value, metaData, record, rowIndex, colIndex, store) 
			{  
				//var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'><img src='../scripts/dhcmed/img/export.png'/></a>";  
				//var formatStr = formatStr+" "+"<a href='javascript:void({1});' onclick='javscript:return false;' class='PMEdit'><img src='../scripts/dhcmed/img/edit.gif'/></a>";
				var strRet = "";
				
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false; ' class='PMRecInsert'>��Ӽ�¼</a>";
	
							strRet = "<div style='color:red;font-weight:bold' class='RecInsert' >" + formatStr + "</div>";
				
					return strRet;
 
			}
			}
			,{ header : '��������', width : 80, dataIndex : 'DemandType', sortable : true, align : 'center' }
			, { header : '��������', width : 200, dataIndex : 'DemandDesc', sortable : false ,align : 'center'}
			, { header : '�账����', width : 80, dataIndex : 'Engineer', sortable : false ,align : 'center'
				,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					
							
							strRet = "<div style='color:red;font-weight:bold'>" + value + "</div>";
						
					
					return strRet;
				}
			
			
			
			
			
			
			}
			
			, { header : '״̬', width : 80, dataIndex : 'DemandStatus', sortable : false
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("DemandStatus")) {
						case "��˲�ͨ��" :
							strRet = "<div style='color:red';font-weight:bold>" + value + "</div>";
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
			, { header : '������', width : 80, dataIndex : 'UserName', sortable : false, align : 'center' }
			, { header : '��ϵ�绰', width : 80, dataIndex : 'UserPhone', sortable : false, align : 'center' }
			, { header : '����', width : 120, dataIndex : 'LocName', sortable : false, align : 'center' }
			, { header : '�˵�����', width : 120, dataIndex : 'MenuName',sortable : true,align : 'center' }
			
			, { header : '�������', width : 80, dataIndex : 'DemondCode', sortable : false, align : 'center',editable: true }
			
			, { header : '�����̶�', width : 80, dataIndex : 'EmergDegree', sortable : false }
			
			, { header : '��������', width : 80, dataIndex : 'DCreateDate', sortable : false }
			, { header : '����ʱ��', width : 80, dataIndex : 'DCreateTime', sortable : false, align : 'center' }
			/* , { header : '�������', width : 80, dataIndex : 'DEndDate', sortable : true, align : 'center' }
			, { header : '���ʱ��', width : 80, dataIndex : 'DEndTime', sortable : false, align : 'center' } */
			//, { header : '������־', width : 80, dataIndex : 'AdjunctFlag', sortable : true, align : 'center' }
			
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
			enableTextSelection:true
			//forceFit : true
			,enableRpwBody : true
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
	
	obj.txtDemName = new Ext.form.TextField({
		id : 'txtDemName'
		,fieldLabel : '��������'
		//,columnWidth : .5
		,anchor : '100%'
});


obj.winDemName = new Ext.form.FormPanel({
		id : 'winDemName'
		,buttonAlign : 'center'
		//,width:'100%'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'form'
		
		//,frame : true
		,items:[
			obj.txtDemName
			
		]
	});


	//Common_ComboDemModule
	obj.cboDemModule = Common_ComboDemModule("cboDemModule","����ģ��");
	obj.cmbStatus = Common_ComboToDic("cmbStatus","����״̬","Improvement");
	
	
	obj.ModulePanel = new Ext.Panel({
		id : 'ModulePanel'
		
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		//,anchor : '100%'
		,items:[
			obj.cboDemModule
		
		]
	});
	
	
obj.winDDemStatus = new Ext.Panel({
		id : 'winDDemStatus'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.cmbStatus
		]
	});
	
	obj.winFPanel1 = new Ext.form.FormPanel({
		id : 'winFPanel1'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.ModulePanel
			//,obj.winDDemStatus
			
		]
	});
	
	obj.txtDuration = new Ext.form.TextField({
		id : 'txtDuration'
		,fieldLabel : 'Ԥ����ʱ'
		,columnWidth : .5
		,anchor : '100%'
});

obj.winDDemDuration = new Ext.Panel({
		id : 'winDDemDuration'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtDuration
		]
	});
   obj.SelectKFStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=SelectKF'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.SelectKFStore.load();
	obj.txtdeveloper = new Ext.form.ComboBox({
		id : 'txtdeveloper'
		,fieldLabel : '������Ա'
		,store : obj.SelectKFStore
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,triggerAction : 'all'
		,Width : 80
		,anchor : '99%'
});
obj.winDDemdeveloper = new Ext.Panel({
		id : 'winDDemdeveloper'
		,buttonAlign : 'center'
		,layout : 'form'
		,items:[
			obj.txtdeveloper
		]
	});



obj.winFPanel2 = new Ext.form.FormPanel({
		id : 'winFPanel2'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'form'
		//,frame : true
		,items:[
			obj.winDDemDuration
		   ,obj.winDDemdeveloper
			
		]
	});
	obj.winHandRec = new Ext.form.TextArea({ //winfPIconClass
		id : 'winHandRec'
		,height : 100
		,fieldLabel : '�����¼'
		,anchor : '90%'
	});
	
	obj.winHandRecPanel = new Ext.Panel({
		id : 'winHandRecPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winHandRec
		]
	});
	//********************************************************
	obj.btnRecSubmit = new Ext.Button({
		id : 'btnRecSubmit'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : '�ύ'
	});
	
	obj.btnRecUpdate = new Ext.Button({
		id : 'btnRecUpdate'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : '����'
	});
	
	obj.winRecSubmit = new Ext.Panel({
		id : 'winSubmit'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		//,layout : 'form'
		,items:[obj.btnRecSubmit]
		
	});
	obj.winRecUpdate = new Ext.Panel({
		id : 'winUpdate'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		//,layout : 'form'
		,items:[obj.btnRecUpdate]
		
	});
	obj.winblank3 = new Ext.Panel({
		id : 'winblank3'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .4
		
		
	});
	obj.winblank4 = new Ext.Panel({
		id : 'winblank4'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .4
		
		
	});
	obj.winFPanel8 = new Ext.form.FormPanel({
		id : 'winFPanel5'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winblank3
			,obj.winRecSubmit
			,obj.winRecUpdate
			,obj.winblank4
			
			
		]
	});
	
	
	//********************************************************
	
	
	//------------------------------------------
	obj.ComDate = new Ext.form.DateField({
		id : 'ComDate'
		,format : 'Y-m-d'
		//,width : 100
		//,columnWidth : .3
		,fieldLabel : '<font color=red>��ͨ����</font>'
		,anchor : '100%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	});
	
	obj.winDComDate = new Ext.Panel({
		id : 'winDComDate'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ComDate
		]
	});
	
	obj.ComTime = new Ext.form.TimeField({
		id : 'ComTime'
		//,format : 'Y-m-d'
		//,width : 100
		//,columnWidth : .3
		,fieldLabel : '<font color=red>��ͨʱ��</font>'
		,increment:5 
		,invalidText:'���ڸ�ʽ��Ч����ѡ��ʱ���������Ч��ʽ��ʱ��'
		,format:'H:i:s'
		,anchor : '100%'
		//,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Time()
	});
	
	obj.winDComTime = new Ext.Panel({
		id : 'winDComTime'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ComTime
		]
	});
	
	
	obj.winFPanel3 = new Ext.form.FormPanel({
		id : 'winFPanel3'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winDComDate
			,obj.winDComTime
			
		]
	});
	
	obj.txtComDuration = new Ext.form.TextField({
		id : 'txtComDuration'
		,fieldLabel : '��ͨʱ��'
		,columnWidth : .5
		,anchor : '100%'
});

obj.winComDuration = new Ext.Panel({
		id : 'winComDuration'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtComDuration
		]
	}); 

obj.cmbComWay = Common_ComboToDic("cmbComWay","��ͨ��ʽ","Communication");	//Communication
obj.winComWay = new Ext.Panel({
		id : 'winComWay'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.cmbComWay
		]
	});

	obj.winFPanel4 = new Ext.form.FormPanel({
		id : 'winFPanel4'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winComDuration
			,obj.winComWay
			
		]
	});
	
	obj.cboHosUser = Common_ComboUser("cboHosUser","Ժ�������","");
	obj.cboProUser = Common_ComboDemHandler("cboProUser","��˾�����","");
	obj.txtHosStr = new Ext.form.TextField({
		id : 'txtHosStr'
		,fieldLabel : 'Ժ��'
		//,columnWidth : .6
		,anchor : '100%'
});


obj.winHosStr = new Ext.Panel({
		id : 'winHosStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtHosStr
		]
	}); 
		obj.txtPrjStr = new Ext.form.TextField({
		id : 'txtPrjStr'
		,fieldLabel : '��˾'
		//,columnWidth : .6
		,anchor : '100%'
});
	obj.winPrjStr = new Ext.Panel({
		id : 'winPrjStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtPrjStr
		]
	});
	
	obj.txtOtherStr = new Ext.form.TextField({
		id : 'txtOtherStr'
		,fieldLabel : '����'
		//,columnWidth : .6
		,anchor : '100%'
});
	obj.winOtherStr = new Ext.Panel({
		id : 'winOtherStr'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtOtherStr
		]
	});
	
		obj.txtLocation = new Ext.form.TextField({
		id : 'txtLocation'
		,fieldLabel : '�ص�'
		//,columnWidth : .6
		,anchor : '100%'
		});
		
		obj.winLocation = new Ext.Panel({
		id : 'winLocation'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.txtLocation
		]
	});
	
	obj.winNewFPanel = new Ext.Panel({
		id : 'winNewFPanel'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		//,columnWidth : .5
		,layout : 'column'
		,items:[
			obj.winOtherStr
			,obj.winLocation
		]
	});
	
	
	obj.txtComNote = new Ext.form.TextArea({ //winfPIconClass
		id : 'txtComNote'
		,height : 90
		,fieldLabel : '<font color=red>��ͨ����</font>'
		,anchor : '90%'
	});
	
	obj.winComNote = new Ext.Panel({
		id : 'winComNote'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtComNote
		]
	});
	
	obj.btnSubmit = new Ext.Button({
		id : 'btnSubmit'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : '�ύ'
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : '����'
	});
	
	obj.winSubmit = new Ext.Panel({
		id : 'winSubmit'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		//,layout : 'form'
		,items:[obj.btnSubmit]
		
	});
	obj.winUpdate = new Ext.Panel({
		id : 'winUpdate'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		//,layout : 'form'
		,items:[obj.btnUpdate]
		
	});
	obj.winblank1 = new Ext.Panel({
		id : 'winblank1'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .4
		
		
	});
	
	
	obj.winblank2 = new Ext.Panel({
		id : 'winblank2'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .4
		
		
	});
	obj.winFPanel5 = new Ext.form.FormPanel({
		id : 'winFPanel5'
		,buttonAlign : 'center'
		//,height: 300
		,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winblank1
			,obj.winSubmit
			,obj.winUpdate
			,obj.winblank2
			
			
		]
	});
	
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
});	

obj.HandlePanal0=new Ext.Panel({
			id : 'HandlePanal0'
			,title:'�����¼'
			,height: 270
			,bodyStyle:"border-width:1px 10px 1px 1px;"
			,style:{border:'2px solid'}
			,layout : 'form'
			//,autoScroll : true
			,animCollapse: true
			,columnWidth: 0.40
			,region:'left'
			//,width : 300
			,items:[
			 obj.winDemName
			,obj.winFPanel1
			,obj.winFPanel2
			,obj.winHandRecPanel 
			,obj.winFPanel8
			
			
			
		]
			
		});
		
		obj.HandlePanal3=new Ext.Panel({
			id : 'HandlePanal3'
			//,title:'��ͨ��¼'
			,layout : 'form'
			
			//,autoScroll : true
			//,animCollapse: true
			,columnWidth: 0.1
			,region:'center'
			//,width : 300
			
		
			
		});
		obj.HandlePanalbk1=new Ext.Panel({
			id : 'HandlePanalbk1'
			//,title:'��ͨ��¼'
			,layout : 'form'
			
			//,autoScroll : true
			//,animCollapse: true
			,columnWidth: 0.05
			,region:'center'
			//,width : 300
			
		
			
		});
		
obj.HandlePanal1=new Ext.Panel({
			id : 'HandlePanal1'
			,title:'��ͨ��¼'
			,layout : 'form'
			,style:{border:'3px solid'}
			//,autoScroll : true
			//,animCollapse: true
			,columnWidth: 0.4
			,region:'right'
			//,width : 300
			//,collapsible: true
			,items:[
			/* obj.winDemName
			,obj.winFPanel1
			,obj.winFPanel2
			,obj.winHandRecPanel */
			obj.winFPanel3
			,obj.winFPanel4
			,obj.winHosStr
			,obj.winPrjStr
			//,obj.winOtherStr
			,obj.winNewFPanel
			,obj.winComNote
			,obj.winFPanel5
			//,obj.DemandID
			
			
			
		]
			
		});
		
obj.HandlePanal2=new Ext.Panel({
			id : 'HandlePanal2'
			//,title:'�����¼'
			,layout : 'column'
			,region:'south'
			//,frame : true
			,border:true
			//,width:'70%'
			,height:300
			,collapsed:true
			//,autoHeight:true
			//,width : '100%'
			//,height : 200
			//,height: 614
			//,autoHeight:true
			
			,split: true
			//,columnWidth: 0.40
			,collapsible: true
			
			//,collapseDirection:'bottom'
			//,collapseDirection:'left'      //'top', 'bottom', 'left' or 'right'
			//,margins: '0 0 0 50'
			,autoScroll : true
			//,animCollapse: true
			
			//,width : 300
			,items:[
			obj.HandlePanalbk1
			,obj.HandlePanal0
			,obj.HandlePanal3
			,obj.HandlePanal1
			,obj.DemandID
			
			
			
		]
			
		});
		obj.hidPanal=new Ext.Panel({
			id:'hidPanal'
			,region:'center'
			,hidden:true
			
		});
		
		obj.StaDetailPanal=new Ext.Panel({
			id : 'StaDetailPanal'
			//,title : '����'
			,layout : 'border'
			,region:'center'
			,split: true
			,collapsible: true
			,autoScroll : true
			,animCollapse: true
			,border:true
			,items:[
			//obj.StaDetailPanal
			obj.ConditionPanal
			,obj.DtlDataGridPanel
			,obj.HandlePanal2
			
		]
		
			
		});
	//---------------------------------------------------------------------------------------------
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,region : 'center'
		,items : [
		obj.StaDetailPanal
		/* obj.ConditionPanal
			,obj.DtlDataGridPanel
			,obj.HandlePanal2 */
		]
	});
	
	obj.DtlDataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Handle.PMHandle';
			param.QueryName = 'QryHandleDemInfo';
			param.Arg1 = obj.cboDateType.getValue(); //"Common_GetValue('cboDateType');��
			param.Arg2 = obj.dtFromDate.getRawValue(); 
			param.Arg3 = obj.dtToDate.getRawValue(); 
			param.Arg4 = obj.textName.getValue();
			param.Arg5 = obj.cboDemStatus.getValue();
			param.Arg6 = obj.textCode.getValue();
			/* alert(obj.toHandle.getValue());
			if (obj.toHandle.getValue())
			{
				param.Arg7 ='Y';
			}
			else
			{
				param.Arg7 ='N';
			} */
			param.Arg7 = obj.toHandle.getValue();
			param.ArgCnt = 7;
	});
	
	obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);
	
		
	//�¼��������
	obj.LoadEvent(arguments);
	
	
	return obj;
}


