var dateFormat=tkMakeServerCall("web.DHCClinicCom","GetDateFormat");
function InitViewScreen(){
	var obj = new Object();
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : dateFormat
		,fieldLabel : '��ʼ����'
		,labelSeparator: ''	//�Ժ����ͳһ��label�����ð��ȥ��
		,anchor : '95%'
	});
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : dateFormat
		,fieldLabel : '��������'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.PanelS1 = new Ext.Panel({
		id : 'PanelS1'
		,labelWidth : 80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
	});
	//�ָ���
		  obj.gdPacuBedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gdPacuBedStore = new Ext.data.Store({
		proxy: obj.gdPacuBedStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprId'
		}, 
		[
			{name: 'oprId', mapping: 'oprId'}
			,{name: 'PacuBedDesc', mapping: 'PacuBedDesc'}
			,{name: 'PacuBedCode', mapping: 'PacuBedCode'}
		])
	});	
	
	
	obj.comAppLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppLocStore = new Ext.data.Store({
		proxy: obj.comAppLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});
	obj.comAppLoc = new Ext.form.ComboBox({
		id : 'comAppLoc'
		,store : obj.comAppLocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '�������'
		,labelSeparator: ''
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOperStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOperStatStore = new Ext.data.Store({
		proxy: obj.comOperStatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	obj.comOperStat = new Ext.form.ComboBox({
		id : 'comOperStat'
		,store : obj.comOperStatStore
		,minChars : 1
		,displayField : 'tDesc'
		,fieldLabel : '״̬'
		,labelSeparator: ''
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.PanelS2 = new Ext.Panel({
		id : 'PanelS2'
		,labelWidth : 80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.comAppLoc
			,obj.comOperStat
		]
	});
	obj.comPatWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comPatWardStore = new Ext.data.Store({
		proxy: obj.comPatWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'desc'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'rw', mapping: 'rw'}
		])
	});
	obj.comPatWard = new Ext.form.ComboBox({
		id : 'comPatWard'
		,store : obj.comPatWardStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '���˲���'
		,labelSeparator: ''
		,valueField : 'rw'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOprFloorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOprFloorStore = new Ext.data.Store({
		proxy: obj.comOprFloorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCF_RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ANCF_RowId', mapping: 'ANCF_RowId'}
			,{name: 'ANCF_Desc', mapping: 'ANCF_Desc'}
			,{name: 'ANCF_Code', mapping: 'ANCF_Code'}
		])
	});
	obj.comOprFloor = new Ext.form.ComboBox({
		id : 'comOprFloor'
		,store : obj.comOprFloorStore
		,minChars : 1
		,displayField : 'ANCF_Desc'
		,fieldLabel : '������¥��'
		,labelSeparator: ''
		,valueField : 'ANCF_RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.PanelS3 = new Ext.Panel({
		id : 'PanelS3'
		,labelWidth : 80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.comPatWard
			,obj.comOprFloor
		]
	});
	obj.txtMedCareNo = new Ext.form.TextField({
		id : 'txtMedCareNo'

		,fieldLabel : '������'
		,anchor : '95%'
		,labelSeparator: ''
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.comOpRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpRoomStore = new Ext.data.Store({
		proxy: obj.comOpRoomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'oprId', mapping: 'oprId'}
			,{name: 'oprDesc', mapping: 'oprDesc'}
			,{name: 'oprCode', mapping: 'oprCode'}
		])
	});
	obj.comOpRoom = new Ext.form.ComboBox({
		id : 'comOpRoom'
		,store : obj.comOpRoomStore
		,minChars : 1
		,value:'' //retRoomStr.split("^")[0]
		,displayField : 'oprDesc'
		,fieldLabel : '������'
		,labelSeparator: ''
        ,mode: 'local'
		,lazyRender : true
		,typeAhead: true
		,valueField : 'oprId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.PanelS4 = new Ext.Panel({
		id : 'PanelS4'
		,labelWidth : 80
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtMedCareNo
			,obj.comOpRoom
		]
	});
	obj.chkUnPaidOp = new Ext.form.Checkbox({
		id : 'chkUnPaidOp'
		,fieldLabel : '�շ�'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.chkIsAppT = new Ext.form.Checkbox({
		id : 'chkIsAppT'
		//,fieldLabel : '��������'
		,xtype:'checkbox'
		,boxLabel: '<span style=\'font-size:14px;\'>��������</span>'
		,autoWidth:true
		//,cls:'BlueA'
		,anchor : '100%'
	});
	obj.chkIfAllLoc = new Ext.form.Checkbox({
		id : 'chkIfAllLoc'
		,boxLabel : '<span style=\'font-size:14px;\'>ȫ������</span>'
		,autoWidth:true
		,anchor : '100%'
	});
		obj.chkOutOP = new Ext.form.Checkbox({
        id : 'chkOutOP'
        ,boxLabel : '<span style=\'font-size:14px;\'>��������</span>'
        ,autoWidth:true
        ,anchor : '100%'
    });

	obj.PanelS5 = new Ext.Panel({
		id : 'PanelS5'
		///,buttonAlign : 'center'
		,buttonAlign : 'left'
		,labelWidth:20
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.chkIsAppT
			,obj.chkIfAllLoc
			,obj.chkOutOP
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,iconCls : 'icon-find'
		,text : '��'+'&nbsp&nbsp&nbsp'+'ѯ'
		,width:100
		,height:30
	});
	obj.PanelS6 = new Ext.Panel({
		id : 'PanelS6'
		,buttonAlign : 'left'
		,columnWidth : .1
		,style:'margin-top:12px'
		,layout : 'column'
		,items:[
		]
		,buttons:[
			obj.btnSch
		]
	});
		obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.PanelS1
			,obj.PanelS2
			,obj.PanelS3
			,obj.PanelS4
			,obj.PanelS5
			,obj.PanelS6
		]
	});

	obj.labelApply=new Ext.form.Label(
	{
		id:'labColorApply'
		//,text:'����'
		,cls:'shenqingFU'
		,width:90
		,height:25
	})
	obj.labelEmergency=new Ext.form.Label(
	{
		id:'labelEmergency'
		//,text:'����'
		//,cls:'emergency'
		,cls:'jizhenFU'
		,width:90
		,height:25
	})
	obj.labelDecline=new Ext.form.Label(
	{
		id:'labelDecline'
		//,text:'�ܾ�'
		,cls:'jujueFU'
		,width:90
		,height:25
	})
	obj.labelReceive=new Ext.form.Label(
	{
		id:'labelReceive'
		//,text:'����'
		,cls:'anpaiFU'
		,width:90
		,height:25
	})
	obj.labelInRoom=new Ext.form.Label(
	{
		id:'labelInRoom'
		//,text:'����'
		,cls:'shuzhongFU'
		,width:90
		,height:25
	})
	obj.labelLeaveRoom=new Ext.form.Label(
	{
		id:'labelLeaveRoom'
		//,text:'����'
		,cls:'shubiFU'
		,width:90
		,height:25
	})
	obj.labelPACU=new Ext.form.Label(
	{
		id:'labelPACU'
		//,text:'�ָ���'
		,cls:'huifuFU'
		,width:90
		,height:25
	})
	obj.labelFinish=new Ext.form.Label(
	{
		id:'labelFinish'
		//,text:'���'
		,cls:'wanchengFU'
		,width:90
		,height:25
	})
obj.labelCancelOper=new Ext.form.Label(
	{
		id:'labelCancelOper'
		//,text:'����'
		,cls:'CancelOper'
		,width:90
		,height:25
	})
	obj.schSubChildPl3 = new Ext.Panel({
		id : 'schSubChildPl3'
		,buttonAlign : 'left'
		,columnWidth : .9
		,layout : 'column'
		,items:[
			obj.labelApply
			,obj.labelCancelOper
			,obj.labelEmergency
			,obj.labelDecline
			,obj.labelReceive
			,obj.labelInRoom
			,obj.labelLeaveRoom
			,obj.labelPACU
			,obj.labelFinish
		]
		,buttons:[]

	});
	obj.chkFormPanel = new Ext.form.FormPanel({
		id : 'chkFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		//,padding: 20
		,height : 35	//ԭ��48
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.schSubChildPl3
		]
	});
	//20160923
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 155
		,title : '<span style=\'font-size:14px;\'>�����б���ѯ</span>'
		,iconCls:'icon-find'	//��ѯ�ӱ�־
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.chkFormPanel
		]
	});
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	
	var sessLoc=session['LOGON.CTLOCID']
	var groupId=session['LOGON.GROUPID']
	var qx=true
	var qx1=true
	var qx3=true
	if(sessLoc==52){var qx=false}
	if(sessLoc==311){var qx1=false}	
	if(groupId==141){var qx3=false}
	
	//----------------------������----------
	obj.gdOpRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gdOpRoomStore = new Ext.data.Store({
		proxy: obj.gdOpRoomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'oprId', mapping: 'oprId'}
			,{name: 'oprDesc', mapping: 'oprDesc'}
			,{name: 'oprCode', mapping: 'oprCode'}
		])
	});
	//--------------------------------------------��е��ʿ
		obj.gdScrubNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	//20120606+dyl++1+ctcpId,ctcpDesc,ctcpAlias-------------------
	obj.gdScrubNurseStore = new Ext.data.Store({
		proxy: obj.gdScrubNurseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	///-------------------------------Ѳ�ػ�ʿ
	obj.gdCirculNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
	obj.gdCirculNurseStore = new Ext.data.Store({
		proxy: obj.gdCirculNurseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	});
	//---------------------------------��������
	obj.comAnaMethodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaMethodStore = new Ext.data.Store({
	    proxy : obj.comAnaMethodStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},
		[
		    {name: 'checked', mapping : 'checked'}
		    ,{name:'Des',mapping:'Des'}
			,{name:'ID',mapping:'ID'}
		])
	
	});

	//---------------------------------����ҽ��
		obj.comAnaDocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaDocStore = new Ext.data.Store({
	    proxy : obj.comAnaDocStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctcpId'
		},
		[    
		    {name:'ctcpDesc',mapping:'ctcpDesc'}
			,{name:'ctcpId',mapping:'ctcpId'}
		])
	
	});

	//-----------------------------
	var maxOrdNo=30;
	var data=new Array();
	for(var i=0;i<maxOrdNo;i++)
	{
		data[i]=new Array();
		for (var j=0;j<2;j++)
		{
			data[i][j]=i+1;
		}
	}
	obj.ordNoStoreProxy=data;
	obj.ordNoStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 


		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opaId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ordno', mapping: 'ordno'}
			,{name: 'status', mapping: 'status'}
			,{name: 'jzstat', mapping: 'jzstat'}
			,{name: 'opdate', mapping: 'opdate'}
			,{name: 'oproom', mapping: 'oproom'}
			,{name: 'opordno', mapping: 'opordno'}
			,{name: 'regno', mapping: 'regno'}
			,{name: 'patname', mapping: 'patname'}
			,{name: 'sex', mapping: 'sex'}
			,{name: 'age', mapping: 'age'}
			,{name: 'opname', mapping: 'opname'}
			,{name: 'diag', mapping: 'diag'}
			,{name: 'opdoc', mapping: 'opdoc'}
			,{name: 'loc', mapping: 'loc'}
			,{name: 'anmethod', mapping: 'anmethod'}
			,{name: 'andoc', mapping: 'andoc'}
			,{name: 'scrubnurse', mapping: 'scrubnurse'}
			,{name: 'circulnurse', mapping: 'circulnurse'}
			,{name: 'yy', mapping: 'yy'}
			,{name: 'opaId', mapping: 'opaId'}
			,{name: 'adm', mapping: 'adm'}
			,{name: 'opdatestr', mapping: 'opdatestr'}
			,{name: 'OpAppDateStr', mapping: 'OpAppDateStr'}
			,{name: 'opmem', mapping: 'opmem'}
			,{name: 'isAddInstrument', mapping: 'isAddInstrument'}
			,{name: 'instrument', mapping: 'instrument'}
			,{name: 'patWard', mapping: 'patWard'}
			,{name: 'anNurse', mapping: 'anNurse'}
			,{name: 'medCareNo', mapping: 'medCareNo'}
			,{name: 'opRoomId', mapping: 'opRoomId'}
			,{name: 'oprFloor', mapping: 'oprFloor'}
			,{name: 'estiOperDuration', mapping: 'estiOperDuration'}
			,{name: 'preDiscussDate', mapping: 'preDiscussDate'}
			,{name: 'isExCirculation', mapping: 'isExCirculation'}
			,{name: 'bloodType', mapping: 'bloodType'}
			,{name: 'opDocNote', mapping: 'opDocNote'}
			,{name: 'anDocNote', mapping: 'anDocNote'}
			,{name: 'opSeqNote', mapping: 'opSeqNote'}
			,{name: 'anCompDesc', mapping: 'anCompDesc'}
			,{name: 'AnaesthesiaID', mapping: 'AnaesthesiaID'}
			,{name: 'operPosition', mapping: 'operPosition'}
			,{name: 'OPCategory', mapping: 'OPCategory'}
			,{name: 'operInstrument', mapping: 'operInstrument'}
			,{name: 'NeedAnaesthetist', mapping: 'NeedAnaesthetist'}
			,{name: 'opsttime', mapping: 'opsttime'}
			,{name: 'mzsupdoc', mapping: 'mzsupdoc'}
			,{name: 'retReason', mapping: 'retReason'}
			,{name: 'anaDoctorOrd', mapping: 'anaDoctorOrd'}
			,{name: 'anaNurseOrd', mapping: 'anaNurseOrd'}
			,{name: 'opNurseOrd', mapping: 'opNurseOrd'}
			,{name: 'inPatNo', mapping: 'inPatNo'}
			,{name: 'admreason', mapping: 'admreason'}
			,{name: 'tPacuBed', mapping: 'tPacuBed'}
			,{name: 'PACUInDateTime', mapping: 'PACUInDateTime'}
			,{name: 'scNurNote', mapping: 'scNurNote'}
			,{name: 'cirNurNote', mapping: 'cirNurNote'}
			,{name: 'anDocAss', mapping: 'anDocAss'}
			,{name: 'bedCode', mapping: 'bedCode'}
			,{name: 'bodsDesc', mapping: 'bodsDesc'}
            ,{name: 'ico', mapping: 'ico'}
            ,{name: 'isUseSelfBlood', mapping: 'isUseSelfBlood'}
			,{name: 'ASA', mapping: 'ASA'}
			,{name: 'opUnPlanedOperation', mapping: 'opUnPlanedOperation'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PAADMMainMRADMDR', mapping: 'PAADMMainMRADMDR'}
			,{name: 'secretCode', mapping: 'secretCode'}
			,{name: 'patLevel', mapping: 'patLevel'}
			,{name: 'SecId', mapping: 'SecId'}
			,{name: 'selfReport', mapping: 'selfReport'} 		//��������
			,{name: 'operResource', mapping: 'operResource'} 	//�������Ű���Դ
			,{name: 'queueNo', mapping: 'queueNo'}				//��Դ
			,{name: 'operStock', mapping: 'operStock'} 			//����Ԥ���Ĳ�
			,{name: 'operStockNote', mapping: 'operStockNote'} 	//����Ԥ���Ĳı�ע
			,{name: 'patTel', mapping: 'patTel'}				//���ߵ绰
			,{name: 'appCtcpId', mapping: 'appCtcpId'}			//����ҽ��ID
			,{name: 'appDocDesc', mapping: 'appDocDesc'}		//����ҽ������
			,{name: 'transferFlag', mapping: 'transferFlag'}
		])
	});
	obj.retGridPanelCheckCol = new Ext.grid.CheckColumn({
		header:'ѡ��', 
		dataIndex: 'checked', 
		width: 40
	});

   obj.csm=new Ext.grid.CheckboxSelectionModel({
	 header:''
	 })

	var cm = new Ext.grid.ColumnModel({

		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,obj.csm
			,{
				header: '����'
				,width: 80
				,dataIndex: 'oproom'
				,sortable: true
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'oprDesc'
					,store : obj.gdOpRoomStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'oprId'
					,mode: 'local'
					,lazyRender : true
					,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
                })
          		,renderer: function(value,metadata,record){
					var index = obj.gdOpRoomStore.find('oprId',value);
					//obj.gdOpRoomStore.load({});
					if(index!=-1)
					{  
						return obj.gdOpRoomStore.getAt(index).data.oprDesc;
					}
					return value;	
				}
        	}

        	,{
		        header: '̨��'
				, width: 60
				, dataIndex: 'opordno'
				, sortable: true
				,editor: new Ext.form.ComboBox({
	      			minChars : 1
					,displayField : 'desc'
					,store : obj.ordNoStore
					,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'code'
					,mode: 'local'
					,lazyRender : true
					,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
	          	})
				,renderer: function(value,metadata,record){
					var index = obj.ordNoStore.find('code',value);
					if(index!=-1)
					{
						return obj.ordNoStore.getAt(index).data.desc;
					}
					return value;	
				}
			}

			,{
				header: '����̨��'
				, width: 60
				, dataIndex: 'opSeqNote'
				, sortable: true
				,renderer: function(value, meta, record) {     
	        		meta.attr = 'style="white-space:normal;"';      
	        		return value;      
	        	} 
			}			

			,{
				header: '����'
				, width: 70
				, dataIndex: 'loc'
				, sortable: true
				,renderer: function(value, meta, record) {     
	        		meta.attr = 'style="white-space:normal;"';      
	        		return value;      
	        	} 
			}
			,{header: '��е��ʿ'
			, width: 80
				, dataIndex: 'scrubnurse'
				, sortable: true
				,editor: new Ext.ux.form.LovCombo({
					id:'scrLovCombo'
      			, minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.gdScrubNurseStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'ctcpId'
					,mode: 'local'
					,grow:true
					,lazyRender : true
					,hideOnSelect:false
		      ,autoHeight:true
		      ,queryInFields:true
		      ,selectOnFocus:false
		      ,queryFields:['ctcpDesc','ctcpAlias'] //��������������趨��ѯ�ֶεġ�
          	})
          ,renderer: function(value,metadata,record){
	          metadata.attr = 'style="white-space:normal;"';
          var rv = value
		      var rva = rv.split(new RegExp(','+ ' *'));
		      var va = [];
		      var snapshot = obj.gdScrubNurseStore.snapshot || obj.gdScrubNurseStore.data;
		      Ext.each(rva, function(v) {
		      	var ex=0;
			    snapshot.each(function(r) {
				  if(v == r.get('ctcpId')) {
					va.push(r.get('ctcpDesc'));
					ex=1;
				  }
				  })
				  if(ex==0)
				  {
				  	va.push(v)
				  }
				 })
	       	 va.join(',');
          	return va;
        	}	
		}
		,{
				header: 'Ѳ�ػ�ʿ'
				, width: 80
				, dataIndex: 'circulnurse'
				, sortable: true
				,editor: new Ext.ux.form.LovCombo({

					id:'cirLovCombo'
      				, minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.gdCirculNurseStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'ctcpId'
					,mode: 'local'
					,grow:true
					,lazyRender : true
					,hideOnSelect:false
		      ,autoHeight:true
		      ,queryInFields:true
		      ,selectOnFocus:false
		      ,queryFields:['ctcpDesc','ctcpAlias'] //��������������趨��ѯ�ֶεġ�
          	})
          ,renderer: function(value,metadata,record){
          metadata.attr = 'style="white-space:normal;"';
          var rv = value
		      var rva = rv.split(new RegExp(','+ ' *'));
		      var va = [];
		      var snapshot = obj.gdCirculNurseStore.snapshot || obj.gdCirculNurseStore.data;
		      Ext.each(rva, function(v) {
		      var ex=0;
			    snapshot.each(function(r) {
				  if(v === r.get('ctcpId')) {
					va.push(r.get('ctcpDesc'));
					ex=1;
				  }
				  })
				  if(ex==0)
				  {
				  	va.push(v)
				  }
				 })
	       	 va.join(',');
          	return va;
        	}	
			}
			,{header: '�ǼǺ�'
			, width: 95
			, dataIndex: 'regno'
			, sortable: true
			,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
		        }
			,{header: '����'
				, width: 55
				, dataIndex: 'patname'
				, sortable: true
				,renderer: function(value, meta, record) {     
			        meta.attr = 'style="white-space:normal;"';      
		    	    return value;      
				} 
			}

			,{header: '�Ա�', width: 35, dataIndex: 'sex', sortable: true}
			,{header: '����', width: 45, dataIndex: 'age', sortable: true}
			,{
				header: '��ǰ���', 
				width: 60, 
				dataIndex: 'diag', 
				sortable: true,
				renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
			}
			,{
				header: '��������', 
				width: 105, 
				dataIndex: 'opname', 
				sortable: true,
				renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
			}
			,{
				header: '��λ', 
				width: 40, 
				dataIndex: 'bodsDesc', 
				sortable: true
			}
			//----------------------------------��������
			,{
				header: '������ʽ'
				, width: 80
				, dataIndex: 'anmethod'
				, sortable: true
				,editor: new Ext.ux.form.LovCombo({
					id:'anMLovCombo'
      				, minChars : 1
					,displayField : 'Des'
					,store : obj.comAnaMethodStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'ID'
					,mode: 'local'
					,grow:true
					,lazyRender : true
					,hideOnSelect:false
			      ,autoHeight:true
			      ,queryInFields:true
			      ,selectOnFocus:false
          	})
	          ,renderer: function(value,metadata,record)
	          {
		          metadata.attr = 'style="white-space:normal;"';
		          var rv = value
			      var rva = rv.split(new RegExp(','+ ' *'));
			      var va = [];
			      var snapshot = obj.comAnaMethodStore.snapshot || obj.comAnaMethodStore.data;
			      Ext.each(rva, function(v){
			      	var ex=0;
				    snapshot.each(function(r){
					  if(v === r.get('ID')) {
						va.push(r.get('Des'));
						ex=1;
					  }})
					  if(ex==0)
					  {
					  	va.push(v)
					  }
					 })
		       	 va.join(',');
	          	return va;
        		}	
			}

			//------------------------------------------
			,{
				header: 'Ѫ��'
			    , width: 40
				, dataIndex: 'bloodType'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '��Ⱦ'
				, width: 50
				, dataIndex: 'yy'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}

			,{
				header: '����ҽ��'
				, width: 60
				, dataIndex: 'opdoc'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '����ҽʦ��ע'
				, width: 60
				, dataIndex: 'opDocNote'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}

			,{
				header: '����Ҫ��'
				, width: 80

				, dataIndex: 'opmem'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '����ҽ��'
				,width: 80
				,dataIndex: 'andoc'
				,sortable: true
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.comAnaDocStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'ctcpId'
					,mode: 'local'
					,lazyRender : true
					,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
                })
		         ,renderer: function(value,metadata,record){
					var index = obj.comAnaDocStore.find('ctcpId',value);
					//obj.gdOpRoomStore.load({});
					if(index!=-1)
					{  
						return obj.comAnaDocStore.getAt(index).data.ctcpDesc;
					}
					return value;	
				}
			}//-----------------------------------end
			,{header: '����ҽ����ע', width: 100, dataIndex: 'anDocNote', sortable: true}
			,{header: '��ʼʱ��', width: 100, dataIndex: 'opdate', sortable: true
			,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   }
			,{header: '״̬', width: 40, dataIndex: 'status', sortable: true}
			,{header: '����', width: 40, dataIndex: 'jzstat', sortable: true}
			,{header: '��е��ʿ��ע', width: 100, dataIndex: 'scNurNote', sortable: true}
			,{header: 'Ѳ�ػ�ʿ��ע', width: 100, dataIndex: 'cirNurNote', sortable: true}
			,{header: 'opaId', width: 40, dataIndex: 'opaId', sortable: true}
			,{header: 'PatientID', width: 40, dataIndex: 'PatientID', sortable: true}
			,{header: 'PAADMMainMRADMDR', width: 40, dataIndex: 'PAADMMainMRADMDR', sortable: true}
			,{header: '��������', width: 60, dataIndex: 'secretCode', sortable: true}
			,{header: '���˼���', width: 60, dataIndex: 'patLevel', sortable: true}
			,{header: '��������ʱ��', width: 100, dataIndex: 'OpAppDateStr', sortable: true}
			,{header: '�����', width: 100, dataIndex: 'adm', sortable: true}
			,{header: '����Id', width: 60, dataIndex: 'secretCode',hidden : true,sortable: true}
			,{header: 'Flag'
				, width: 100
				, dataIndex: 'ico'
				, sortable: true
				,renderer: function(v)
				{		
					var strImg=""
          var ret=v.split("^");
          for (var i=0;i<ret.length;i++)
          {
          	if (!ret[i]) continue;
          	var imgShow=ret[i].split("#");
          	var ifShow=parseInt(imgShow[1]);
          	if(!ifShow) continue;
          	strImg += "<A HREF='#' onClick='ClickIcoHandler(" +"\""+imgShow[4]+"\""+ ")' ><img src='"+imgShow[2]+"' alt='"+imgShow[3]+ "' /></A>";
          }
          return strImg
				}
				}

			,{header: '������', width: 100, dataIndex: 'oppack', sortable: true}
			,{header: '�Ƿ񲹳���е', width: 100, dataIndex: 'isAddInstrument', sortable: true}
			,{header: '��е', width: 40, dataIndex: 'instrument', sortable: true}
			,{header: 'AnaesthesiaID', width: 80, dataIndex: 'AnaesthesiaID', sortable: false}
			,{header: '����', width: 100, dataIndex: 'patWard', sortable: true}
			,{header: '������', width: 80, dataIndex: 'medCareNo', sortable: true}
			,{header: '������¥��', width: 100, dataIndex: 'oprFloor', sortable: true}
			,{header: '����ʱ��', width: 100, dataIndex: 'opdatestr', sortable: true}
			,{header: 'Ԥ����ʱ', width: 100, dataIndex: 'estiOperDuration', sortable: true}
			,{header: '��ǰ��������', width: 100, dataIndex: 'preDiscussDate', sortable: true}
			,{header: '�Ƿ�����ѭ��', width: 80, dataIndex: 'isExCirculation', sortable: true}
			,{header: '�ϲ�����', width: 100, dataIndex: 'anCompDesc', sortable: true}
			,{header: '�Ƿ�����Ѫ����', width: 100, dataIndex: 'isUseSelfBlood', sortable: true}
			,{header: '��λ', width: 40, dataIndex: 'operPosition', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'OPCategory', sortable: true}
			,{header: '������е', width: 100, dataIndex: 'operInstrument', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'NeedAnaesthetist', sortable: true}
			,{header: '������ʼʱ��', width: 100, dataIndex: 'opsttime', sortable: true}
			,{header: '�ܾ�ԭ��', width: 100, dataIndex: 'retReason', sortable: true}
			,{header: '������ʿ�շ�״̬', width: 100, dataIndex: 'opNurseOrd', sortable: true}
			,{header: '����ʦ�շ�״̬', width: 100, dataIndex: 'anaDoctorOrd', sortable: true}
			,{header: '������ʿ�շ�״̬', width: 100, dataIndex: 'anaNurseOrd', sortable: true}
			,{
				header: '�ָ���λ'
				,width: 70
				,dataIndex: 'tPacuBed'
				,sortable: true
			    //,hidden:qx3?true:false            //����ҽԺȨ������
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'PacuBedDesc'
					,store : obj.gdPacuBedStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'PacuBedDesc'
					,mode: 'local'
					,lazyRender : true
					,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
					,border:true
                })
          		,renderer: function(value,metadata,record){
					var index = obj.gdPacuBedStore.find('PacuBedDesc',value);
					if(index!=-1)
					{  
						return obj.gdPacuBedStore.getAt(index).data.PacuBedDesc;
					}
					return value;
				}
        	}
			,{header: '��ָ���ʱ��', width: 100, dataIndex: 'PACUInDateTime', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'anDocAss', sortable: true}
			,{header: '������ʿ', width: 100, dataIndex: 'anNurse', sortable: true}
			,{header: '��������ӡ���', width: 100, dataIndex: 'topaAnSheetPrintAudit', sortable: true}
			,{header: '�������޸����', width: 100, dataIndex: 'topaAnSheetEditAudit', sortable: true}
			,{header: 'ASA�ȼ�', width: 60, dataIndex: 'ASA', sortable: true}
			,{header: '�ط�����', width: 60, dataIndex: 'opUnPlanedOperation', sortable: true}
			,{header: '����(������)', width: 60, dataIndex: 'selfReport', sortable: true}
			,{header: '����Ԥ���Ĳ�', width: 80, dataIndex: 'operStock', sortable: true}
			,{header: '����Ԥ���Ĳı�ע', width: 80, dataIndex: 'operStockNote', sortable: true}
			,{header: '����ҽ��', width: 70, dataIndex: 'appDocDesc', sortable: true}
		        ,{
	        	header:'����'
				,width:60
				,dataIndex: 'transferFlag'
				,sortable: true
				,align:'center'
				,renderer: function(value,metadata,record){
					var EpisodeID =record.get('adm');
					var url="dhcclinic.transfer.sch.csp?&dateFrm="+obj.dateFrm.getRawValue()+"&dateTo="+obj.dateTo.getRawValue()+"&EpisodeID="+EpisodeID+"!"+"dialogWidth:1150px;dialogHeight:760px;status:no;menubar:no;";
					if(value==1){
						 return '<img title=\'����\' src=\'../scripts/dhcclinic/img/recevice.gif\' onclick="ClickIcoHandler('+'\''+url+'\''+')"; style=\'cursor:pointer;\' />';
					}
					if(value==2){
						return '<img title=\'����\' src=\'../scripts/dhcclinic/img/send.gif\' onclick="ClickIcoHandler('+'\''+url+'\''+')" style=\'cursor:pointer;\' />';
					}
				}
			}
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		//,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
        ,sm:obj.csm
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm

		,viewConfig:
		{
			forceFit: false,
			//Return CSS class to apply to rows depending upon data values

			getRowClass: function(record, index)
			{
				var status = record.get('status');
				var type=record.get('jzstat');

				switch (status)
				{
					case '����':
					if(type=='����') return 'emergency';
						break;
					case '�ܾ�':
						return 'deepskyblue'; //blue /refuse
						break;
					case '����':

						return 'palegreen';  //green //arranged
						break;
					case '���':
						return 'yellow' ;//yellow //finish
						break;
					case '����':
						return 'red' ;//red 
						break;
					case '����':

						return 'lightblue' ;//light blue
						break;
					case '�ָ���':
						return 'resume';
						break;
					case '����':
						return 'canGray';
						break;
					default:
						return 'exec'; //
						break; 
				}
			}
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,plugins : obj.retGridPanelCheckCol
	});
	obj.chkSelAll = new Ext.form.Checkbox({
				id : 'chkSelAll'
				,cls:'BlueA'
				,boxLabel:'<span style=\'font-size:14px;\'>ȫ��</span>'
				,anchor : '100%'
			})
	obj.chkSelPrint = new Ext.form.Checkbox({
		id : 'chkSelPrint'
		,boxLabel:'<span style=\'font-size:14px;\'>ѡ���ӡ</span>'
		,cls:'BlueA'
		,anchor : '100%'
	})
	//----------
	obj.txtPatname = new Ext.form.TextField({
	    id : 'txtPatname'
		,fieldLabel : '��ǰ����:  ����'
		,labelSeparator: ''
		,width:100
		,anchor :'98%'
	});
		//�ǼǺ�*
	obj.txtPatRegNo = new Ext.form.TextField({
	    id : 'txtPatRegNo'
		,fieldLabel : '�ǼǺ�'
		,labelSeparator: ''
		,width:80
		,anchor :'100%'
	});
	//�Ա�*
	obj.txtPatSex = new Ext.form.TextField({
	    id : 'txtPatSex'
		,fieldLabel : '�Ա�'
		,labelSeparator: ''
		,width:60
		,anchor :'100%'
	});
	//����*
	obj.txtPatAge = new Ext.form.TextField({
	    id : 'txtPatAge'
		,fieldLabel : '����'
		,labelSeparator: ''
		,width:80
		,anchor :'100%'
	});
	obj.PanelP1 = new Ext.Panel({
	    id : 'PanelP1'
		,labelAlign : 'right'
		,labelWidth:100
		,columnWidth : .35
		,layout : 'form'
		,items : [
		    obj.txtPatname
		]
	});
	obj.PanelP2 = new Ext.Panel({
	    id : 'PanelP2'
		,labelAlign : 'right'
		,labelWidth:30
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.txtPatAge
		]
	});
	obj.PanelP3 = new Ext.Panel({
	    id : 'PanelP3'
		,labelAlign : 'right'
		,labelWidth:30
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.txtPatSex
		]
	});
	obj.PanelP4 = new Ext.Panel({
	    id : 'PanelP4'
		,labelAlign : 'right'
		,labelWidth:60
		,columnWidth : .35
		,layout : 'form'
		,items : [
			obj.txtPatRegNo
		]
	});
	//----------
	obj.opManageMenu=new Ext.menu.Menu({});
	obj.tb=new Ext.Toolbar(
	{
		items:[
			{   
			iconCls : 'icon-menu',
				text:'<span style=\'font-size:14px;\'>��������</span>',   
				menu:obj.opManageMenu 
			},
			{
				xtype: 'tbspacer', 
				width: 60
			},
			obj.chkSelAll,
			{
				xtype: 'tbspacer', 
				width: 20
			},
			obj.chkSelPrint,
			{
				xtype: 'tbspacer', 
				width: 20
			},
			new Ext.form.FormPanel({
				 id : 'patfPanel'
				 ,frame:true
				,labelWidth:60
				,labelAlign : 'right'
				,width : 500
				,height:35
				,layout : 'column'
				,items : [
				   obj.PanelP1
				   ,obj.PanelP2
				   ,obj.PanelP3
				   ,obj.PanelP4
				]
			})
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '<span style=\'font-size:14px;\'>������ѯ���</span>'
		,iconCls:'icon-result'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,tbar:obj.tb
		,items:[
			obj.Panel23
			,obj.Panel25
			,obj.retGridPanel
		]
	});

	obj.EpisodeID = new Ext.form.TextField({
		id : 'EpisodeID'
	});
	obj.PatientID = new Ext.form.TextField({
		id : 'PatientID'
	});
	obj.mradm = new Ext.form.TextField({
		id : 'mradm'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
	});
	obj.loc = new Ext.form.TextField({
		id : 'loc'
	});
	obj.userLocId = new Ext.form.TextField({
		id : 'userLocId'
	});
	obj.maxOrdNo = new Ext.form.TextField({
		id : 'maxOrdNo'
	});
	obj.logUserType = new Ext.form.TextField({
		id : 'logUserType'
	});
   obj.forComOpRoom = new Ext.form.TextField({
		id : 'forComOpRoom'
   });
   obj.PatWard = new Ext.form.TextField({
		id : 'PatWard'
   });

	obj.hiddenPanel = new Ext.Panel({
		id : 'hiddenPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,hidden : true
		,items:[
			obj.EpisodeID
			,obj.opaId
			,obj.loc
			,obj.userLocId
			,obj.maxOrdNo
			,obj.logUserType
            ,obj.forComOpRoom
            ,obj.PatientID
			,obj.mradm
			,obj.PatWard
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.schPanel
			,obj.resultPanel
			,obj.hiddenPanel
		]
	});
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;		
	});	
	//obj.comAppLocStore.load({});	 //��ʼ������ʱ�����غ�̨���ݣ�����ѡ�����б���ʱ�Զ����أ��Լ��ٳ�ʼ�������ʱ�䡣
	obj.comOperStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'OpaStatus';
		param.ArgCnt = 1;
	});
	//obj.comOperStatStore.load({});   //��ʼ������ʱ�����غ�̨���ݣ�����ѡ�����б���ʱ�Զ����أ��Լ��ٳ�ʼ�������ʱ�䡣
	obj.comPatWardStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'GetWard';
		param.Arg1 = obj.comPatWard.getRawValue();
		param.ArgCnt = 1;
	});
	//obj.comPatWardStore.load({});   //��ʼ������ʱ�����غ�̨���ݣ�����ѡ�����б���ʱ�Զ����أ��Լ��ٳ�ʼ�������ʱ�䡣
	obj.comOprFloorStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'GetAllOperFloor';
		param.ArgCnt = 0;
	});
	//obj.comOprFloorStore.load({});    //��ʼ������ʱ�����غ�̨���ݣ�����ѡ�����б���ʱ�Զ����أ��Լ��ٳ�ʼ�������ʱ�䡣
	
	var sessLoc=session['LOGON.CTLOCID'];
	obj.comOpRoomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindAncOperRoom';
		param.Arg1 = obj.comOpRoom.getRawValue();		
		param.Arg2 = ''; //sessLoc;
		param.Arg3 = 'OP^OUTOP^EMOP';
		param.Arg4 = obj.EpisodeID.getValue();
		param.Arg5 = ''
		param.Arg6 = 'T';
		param.Arg7 = obj.comAppLoc.getValue();
		param.ArgCnt = 7;
	});
	obj.comOpRoomStore.load({});   
	obj.gdOpRoomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindAncOperRoom';
		param.Arg1 = '';
		param.Arg2 = sessLoc;
		param.Arg3 = 'OP^OUTOP^EMOP';
		param.Arg4 = obj.EpisodeID.getValue();
		param.Arg5 = ''
		param.Arg6 = 'T';
		param.Arg7 = '';
		param.ArgCnt = 7;
	});
	obj.gdOpRoomStore.load();  
	obj.gdScrubNurseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'FindCtcp';
			param.Arg1 = '';
			param.Arg2 = 'OP^OUTOP^EMOP';
			param.Arg3 = sessLoc;
			param.Arg4 = obj.EpisodeID.getValue();
			param.Arg5 = obj.opaId.getValue();
			param.Arg6 = 'N';
			param.Arg7 = 'N';
			param.ArgCnt = 7;
	});
	obj.gdCirculNurseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'FindCtcp';
			param.Arg1 = '';
			param.Arg2 = 'OP^OUTOP^EMOP';
			param.Arg3 = sessLoc;
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'N';
			param.Arg7 = 'N';
			param.ArgCnt = 7;
	});
	//�ָ���
		obj.gdPacuBedStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindPacuRoom';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	obj.gdPacuBedStore.load({});
	
	
	//����ҽ��
	obj.comAnaDocStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = '';
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y';
			param.Arg7 = 'N';
			param.ArgCnt = 7;
	    });
	obj.comAnaDocStore.load(); 
	// ��������
	obj.comAnaMethodStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindAnaestMethod';
		    param.Arg1 = '';
	    	param.ArgCnt = 1;
	    });
	obj.comAnaMethodStore.load(); 
	Ext.getCmp('scrLovCombo').on("expand",scrLovCom_expand)
	Ext.getCmp('scrLovCombo').on("focus",scrLovCom_focus)
	Ext.getCmp('cirLovCombo').on("expand",cirLovCom_expand)
	Ext.getCmp('cirLovCombo').on("focus",cirLovCom_focus)
	Ext.getCmp('anMLovCombo').on("expand",anMLovCombo_expand)
	Ext.getCmp('anMLovCombo').on("focus",anMLovCombo_focus)
function anMLovCombo_expand(comb)
  { 
  	comb.setWidth(220); 
  }
	function anMLovCombo_focus()
	{	
	}
function scrLovCom_expand(comb)
  { 
  	comb.setWidth(160); 
  }
function scrLovCom_focus()
{	
}
	function cirLovCom_expand(comb)
  { 
  	comb.setWidth(220); 
  }
	function cirLovCom_focus()
	{
		
	}
	obj.gdScrubNurseStore.load()    
	obj.gdCirculNurseStore.load()    
    obj.ordNoStore.load({});
	obj.maxOrdNo.setValue(maxOrdNo);
	
	InitViewScreenEvent(obj);
	
	//�¼���������
	obj.comAppLoc.on("select", obj.comAppLoc_select, obj);
	obj.comAppLoc.on("keyup", obj.comAppLoc_keyup, obj);
	obj.comOpRoom.on("select", obj.comOpRoom_select, obj);
	obj.comOpRoom.on("keyup", obj.comOpRoom_keyup, obj);
  	obj.comPatWard.on("keyup", obj.comPatWard_keyup, obj);
    obj.comPatWard.on("select", obj.comPatWard_select, obj);
	obj.txtMedCareNo.on("keyup", obj.txtMedCareNo_keyup, obj);
	//obj.dateFrm.on("blur",obj.date_blur,obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	//obj.btnAnDocOrdered.on("click", obj.btnAnDocOrdered_click, obj);
	//obj.btnClearRoom.on("click",obj.btnClearRoom_click,obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.retGridPanel.on("beforeedit",obj.retGridPanel_beforeedit,obj);
	obj.retGridPanel.on("validateedit",obj.retGridPanel_validateedit,obj);
	obj.retGridPanel.on("afteredit",obj.retGridPanel_afteredit,obj);
	obj.chkSelAll.on("check",obj.chkSelAll_check,obj);
	//obj.btnOpRoomLimit.on("click",obj.btnOpRoomLimit_click,obj);
	//obj.btnOpRoomOpen.on("click",obj.btnOpRoomOpen_click,obj);
	//obj.btnDirAudit.on("click",obj.btnDirAudit_click,obj);
	obj.LoadEvent(arguments);
	return obj;

}
function ClickIcoHandler(_url)
	{
		var lnk=_url.split("!")[0];
		var nwin=_url.split("!")[1];
    var retValue = window.showModalDialog(lnk,"",nwin);
	}
