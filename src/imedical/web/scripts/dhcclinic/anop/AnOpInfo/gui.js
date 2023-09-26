function InitViewScreen(){
	var obj = new Object();
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '开始日期'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '结束日期'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
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
		,fieldLabel : '申请科室'
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
		,fieldLabel : '状态'
		,labelSeparator: ''
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
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
		,fieldLabel : '病人病区'
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
		,fieldLabel : '手术间楼层'
		,labelSeparator: ''
		,valueField : 'ANCF_RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
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
		,fieldLabel : '病案号'
		,labelSeparator: ''
		,anchor : '95%'
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
		,fieldLabel : '手术间'
		,labelSeparator: ''
		,valueField : 'oprId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtMedCareNo
			,obj.comOpRoom
		]
	});
	
	//20160921+8.0.1
	obj.chkIsAppT = new Ext.form.Checkbox({
		id : 'chkIsAppT'
		,cls:'BlueA'
		,boxLabel : '<span style=\'font-size:12px;\'>申请日期</span>'
		,anchor : '100%'
	});
	obj.chkIfAllLoc = new Ext.form.Checkbox({
		id : 'chkIfAllLoc'
		,cls:'BlueA'
		,boxLabel : '<span style=\'font-size:12px;\'>全部科室</span>'
		,anchor : '95%'
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		///,buttonAlign : 'center'
		,buttonAlign : 'left'
		,labelWidth:20
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.chkIsAppT
			,obj.chkIfAllLoc
		]
	});
		//-------20160921+dyl
		//默认高度
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '查'+'&nbsp&nbsp&nbsp&nbsp&nbsp'+'询'
		,iconCls : 'icon-find'
		,width:120
		,height:25
		
	});
	obj.OpEquipment= new Ext.Button({
		id : 'OpEquipment'
		,iconCls : 'icon-scrubSearch'
		,text : '手术器械查询'
		,style:'margin-top:5px'
		,width:120
		,height:25
	});
	obj.Panel6 = new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'column'
		,items:[
			obj.btnSch
			,obj.OpEquipment
		]
		,buttons:[
		]
	});
//------------

	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
			,obj.Panel6
		]
	});

	obj.labelApply=new Ext.form.Label(
	{
		id:'labColorApply'
		//,text:'申请'
		//,cls:'white'
		,cls:'shenqingFU'
		,width:90
		,height:25
	})
	obj.labelEmergency=new Ext.form.Label(
	{
		id:'labelEmergency'
		//,text:'急诊'
		//,cls:'emergency'
		,cls:'jizhenFU'
		,width:90
		,height:25
	})
	obj.labelDecline=new Ext.form.Label(
	{
		id:'labelDecline'
		//,text:'拒绝'
		//,cls:'deepskyblue'
		,cls:'jujueFU'
		,width:90
		,height:25
	})
	obj.labelReceive=new Ext.form.Label(
	{
		id:'labelReceive'
		//,text:'安排'
		//,cls:'palegreen'
		//,cls:'anpaiFU'
		,cls:'anpaiFU'
		,width:90
		,height:25
	})
	obj.labelInRoom=new Ext.form.Label(
	{
		id:'labelInRoom'
		//,text:'术中'
		//,cls:'red'
		,cls:'shuzhongFU'
		,width:90
		,height:25
	})
	obj.labelLeaveRoom=new Ext.form.Label(
	{
		id:'labelLeaveRoom'
		//,text:'术毕'
		//,cls:'lightblue'
		,cls:'shubiFU'
		,width:90
		,height:25
	})
	obj.labelPACU=new Ext.form.Label(
	{
		id:'labelPACU'
		//,text:'恢复室'
		//,cls:'resume'
		,cls:'huifuFU'
		,width:90
		,height:25
	})
	obj.labelFinish=new Ext.form.Label(
	{
		id:'labelFinish'
		//,text:'完成'
		//,cls:'yellow'
		,cls:'wanchengFU'
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
		,height :35
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.schSubChildPl3
		]
	});
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 142
		,title : '<span style=\'font-size:14px;\'>手术列表查询</span>'
		,iconCls:'icon-find'
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
		//--------------------------------------------
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
			,{name: 'tDocArriveTime', mapping: 'tDocArriveTime'}
			,{name: 'bodsDesc', mapping: 'bodsDesc'}
			,{name: 'ASA', mapping: 'ASA'}
			,{name: 'opUnPlanedOperation', mapping: 'opUnPlanedOperation'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PAADMMainMRADMDR', mapping: 'PAADMMainMRADMDR'}
			,{name: 'weight', mapping: 'weight'}
		])
	});
	obj.retGridPanelCheckCol = new Ext.grid.CheckColumn({
		header:'选择', 
		dataIndex: 'checked', 
		hidden:true,
		width: 40
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,obj.retGridPanelCheckCol
			,{
				header: '术间'
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
		        header: '台次'
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
					obj.ordNoStore.load({});
					if(index!=-1)
					{
						return obj.ordNoStore.getAt(index).data.desc;
					}
					return value;	
				}
			}
			
			,{
				header: '申请台次'
				, width: 60
				, hidden:true
				, dataIndex: 'opSeqNote'
				, sortable: true
				,renderer: function(value, meta, record) {     
	        		meta.attr = 'style="white-space:normal;"';      
	        		return value;      
	        	} 
			}			
			,{
				header: '科室'
				, width: 70
				, dataIndex: 'loc'
				, sortable: true
				,renderer: function(value, meta, record) {     
	        		meta.attr = 'style="white-space:normal;"';      
	        		return value;      
	        	} 
			}
			
			//------2012-11-20---dongjingjing----start---
			,{header: '病案号', width: 80, dataIndex: 'medCareNo', sortable: true}
			//------2012-11-20---dongjingjing----end---
			,{header: '登记号', width: 95, dataIndex: 'regno', sortable: true}
			,{header: '姓名'
				, width: 55
				, dataIndex: 'patname'
				, sortable: true
				,renderer: function(value, meta, record) {     
			        meta.attr = 'style="white-space:normal;"';      
		    	    return value;      
				} 
			}
			,{header: '性别', width: 35, dataIndex: 'sex', sortable: true}
			,{header: '年龄', width: 45, dataIndex: 'age', sortable: true}
			,{header: '体重', width: 35, dataIndex: 'weight', sortable: true}
			,{
				header: '术前诊断', 
				width: 60, 
				dataIndex: 'diag', 
				sortable: true,
				renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
			}
			///------------ljr--------
			,{	
				header: '手术医生'
			  , width: 60
		      , dataIndex: 'opdoc'
			  , sortable: true
				,renderer: function(value, meta, record) {     
		    	meta.attr = 'style="white-space:normal;"';      
		      	return value;      
		      } 
			  }
			
			,{
				header: '手术名称', 
				width: 105, 
				dataIndex: 'opname', 
				sortable: true,
				renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
			}
			///----2012-11-20-----dongjingjing--start-----
			,{header: '手术申请时间', width: 100, dataIndex: 'OpAppDateStr', sortable: true}
			,{header: '手术时间', width: 100, dataIndex: 'opdatestr', sortable: true}
			,{header: '手术开始时间', width: 100, dataIndex: 'opsttime', sortable: true}
			,{
				header: '麻醉医生'
				, width: 80
				, dataIndex: 'andoc'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
				,{
				header: '麻醉方法'
				, width: 60
				, dataIndex: 'anmethod'
			, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		     } 
			}
		
			,{header: '麻醉医生备注', width: 100, dataIndex: 'anDocNote', sortable: true}
			///	-----2012-11-20--dongjingjing--end-------------------		
			//-----------ljr
			,{header: '器械护士'
				, width: 80
				, dataIndex: 'scrubnurse'
				, sortable: true
				,editor: new Ext.ux.form.LovCombo({
					id:'LovCombo'
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
		      ,queryFields:['ctcpDesc','ctcpAlias'] //这个数组是用来设定查询字段的。
          	})
          ,renderer: function(value,metadata,record){
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
				header: '巡回护士'
				, width: 80
				, dataIndex: 'circulnurse'
				, sortable: true
				,editor: new Ext.ux.form.LovCombo({
					id:'LovCombo2'
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
		      ,queryFields:['ctcpDesc','ctcpAlias'] //这个数组是用来设定查询字段的。
          	})
          ,renderer: function(value,metadata,record){
          var rv = value
		      var rva = rv.split(new RegExp(','+ ' *'));
		      var va = [];
		      var snapshot = obj.gdScrubNurseStore.snapshot || obj.gdScrubNurseStore.data;
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
			,{header: '重返手术', width: 60, dataIndex: 'opUnPlanedOperation', sortable: true}
			///---------------
			,{
				header: '部位', 
				width: 40, 
				dataIndex: 'bodsDesc', 
				sortable: true
			}
			,{
				header: '血型'
				, width: 40
				, dataIndex: 'bloodType'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '感染'
				, width: 50
				, hidden:true
				, dataIndex: 'yy'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '其他手术人员'
				, width: 60
				, hidden:true
				, dataIndex: 'opDocNote'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '手术要求'
				, width: 80
				, hidden:true
				, dataIndex: 'opmem'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			
			,{header: '开始时间', width: 100, dataIndex: 'opdate', sortable: true},{header: '状态', width: 40, dataIndex: 'status', sortable: true}
			,{header: '类型', width: 40, dataIndex: 'jzstat', sortable: true}
			,{header: '器械护士备注', width: 100, dataIndex: 'scNurNote', hidden: true}
			,{header: '巡回护士备注', width: 100, dataIndex: 'cirNurNote', hidden: true}
			,{header: 'opaId', width: 40, dataIndex: 'opaId', sortable: true}
			,{header: 'PatientID', width: 40, dataIndex: 'PatientID', hidden: true}
			,{header: 'PAADMMainMRADMDR', width: 40, dataIndex: 'PAADMMainMRADMDR', hidden: true}
			,{header: '就诊号', width: 100, dataIndex: 'adm', hidden: true}
			//,{header: '病案号', width: 80, dataIndex: 'medCareNo', sortable: true}
			,{header: 'Flag', width: 100, dataIndex: 'ico', hidden: true}
			,{header: '手术包', width: 100, dataIndex: 'oppack', hidden: true}
			,{header: '是否补充器械', width: 100, dataIndex: 'isAddInstrument', hidden: true}
			,{header: '器械', width: 40, dataIndex: 'instrument', sortable: true}
			,{header: 'AnaesthesiaID', width: 80, dataIndex: 'AnaesthesiaID', hidden: true}
			,{header: '病区', width: 100, dataIndex: 'patWard', sortable: true}
			//,{header: '病案号', width: 80, dataIndex: 'medCareNo', sortable: true}
			,{header: '就诊号', width: 100, dataIndex: 'adm', sortable: true}
			,{header: '手术间楼层', width: 100, dataIndex: 'oprFloor', hidden: true}
			
			,{header: '预计手术时间', width: 100, dataIndex: 'estiOperDuration', sortable: true}
			,{header: '术前讨论日期', width: 100, dataIndex: 'preDiscussDate', sortable: true}
			,{header: '是否体外循环', width: 80, dataIndex: 'isExCirculation', hidden: true}
			,{header: '合并疾病', width: 100, dataIndex: 'anCompDesc', hidden : true}
			,{header: '是否自体血回输', width: 100, dataIndex: 'isUseSelfBlood', hidden: true}
			,{header: '体位', width: 40, dataIndex: 'operPosition', sortable: true}
			,{header: '手术分类', width: 100, dataIndex: 'OPCategory', sortable: true}
			,{header: '特殊器械', width: 100, dataIndex: 'operInstrument', sortable: true}
			,{header: '麻醉会诊', width: 100, dataIndex: 'NeedAnaesthetist', sortable: true}
			
			,{header: '拒绝原因', width: 100, dataIndex: 'retReason', sortable: true}
			,{header: '手术护士收费状态', width: 100, dataIndex: 'opNurseOrd', hidden: true}
			,{header: '麻醉师收费状态', width: 100, dataIndex: 'anaDoctorOrd', hidden: true}
			,{header: '麻醉护士收费状态', width: 100, dataIndex: 'anaNurseOrd', hidden: true}
			,{header: '恢复床位', width: 100, dataIndex: 'tPacuBed', sortable: true}
			,{header: '入恢复室时间', width: 100, dataIndex: 'PACUInDateTime', sortable: true}
			,{header: '麻醉助手', width: 100, dataIndex: 'anDocAss', sortable: true}
			,{header: '麻醉护士', width: 100, dataIndex: 'anNurse', sortable: true}
			,{header: '医生到达时间', width: 100, dataIndex: 'tDocArriveTime', hidden: true}
			,{header: '麻醉单打印审核', width: 100, dataIndex: 'topaAnSheetPrintAudit', hidden: true}
			,{header: '麻醉单修改审核', width: 100, dataIndex: 'topaAnSheetEditAudit', hidden: true}
			,{header: 'ASA等级', width: 60, dataIndex: 'ASA', hidden: true}
			
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
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
					case '申请':
						if(type=='急诊') return 'emergency';
						break;
					case '拒绝':
						return 'deepskyblue'; //blue /refuse
						break;
					case '安排':
						return 'palegreen';  //green //arranged
						break;
					case '完成':
						return 'yellow' ;//yellow //finish
						break;
					case '术中':
						return 'red' ;//red 
						break;
					case '术毕':
						return 'lightblue' ;//light blue
						break;
					case '恢复室':
						return 'resume';
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
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
	});
	obj.chkSelAll = new Ext.form.Checkbox({
		id : 'chkSelAll'
		,fieldLabel : ''
		,anchor : '95%'
	})
	obj.chkSelPrint = new Ext.form.Checkbox({
		id : 'chkSelPrint'
		,fieldLabel : ''
		,anchor : '95%'
	})
	obj.opManageMenu=new Ext.menu.Menu({});
	obj.timebtn=new Ext.Button({
	    id : 'timebtn'
	    ,iconCls:'icon-buttonshow'
		,style:'margin:0 3px;'
		,text : '手术时间'
	});
	obj.tb=new Ext.Toolbar(
	{
		height: 35
		//,hidden:true
		,width: 500
		,items:[
		   obj.timebtn
			
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '<span style=\'font-size:14px;\'>手术查询结果</span>'
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
			,obj.PatientID
			,obj.mradm
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
	obj.comAppLocStore.load({});	
	obj.comOperStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'OpaStatus';
		param.ArgCnt = 1;
	});
	obj.comOperStatStore.load({});
	obj.comPatWardStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'GetWard';
		param.Arg1 = obj.comPatWard.getRawValue();
		param.ArgCnt = 1;
	});
	obj.comPatWardStore.load({});
	obj.comOprFloorStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'GetAllOperFloor';
		param.ArgCnt = 0;
	});
	obj.comOprFloorStore.load({});
	
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
			param.Arg3 = '';
			param.Arg4 = obj.EpisodeID.getValue();
			param.Arg5 = obj.opaId.getValue();
			param.Arg6 = 'N';
			param.Arg7 = 'N';
			param.ArgCnt = 7;
	});
	Ext.getCmp('LovCombo').on("expand",lovCom_expand)
	Ext.getCmp('LovCombo').on("focus",lovCom_focus)
	Ext.getCmp('LovCombo2').on("expand",lovCom_expand)
	Ext.getCmp('LovCombo2').on("focus",lovCom_focus)

  function lovCom_expand(comb)
  { 
  	//obj.gdScrubNurseStore.load();
  	comb.setWidth(220);  
  }
	function lovCom_focus()
	{
		
	}
	obj.gdScrubNurseStore.load()

	//obj.ordNoStore.load({});
	obj.maxOrdNo.setValue(maxOrdNo);
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.comAppLoc.on("select", obj.comAppLoc_select, obj);
	obj.comAppLoc.on("keyup", obj.comAppLoc_keyup, obj);
	obj.txtMedCareNo.on("keyup", obj.txtMedCareNo_keyup, obj);
	obj.dateFrm.on("blur",obj.date_blur,obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.OpEquipment.on("click", obj.OpEquipment_click, obj);
	obj.timebtn.on("click", obj.timebtn_click, obj);
	//obj.btnAnDocOrdered.on("click", obj.btnAnDocOrdered_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.retGridPanel.on("rowdblclick", obj.retGridPanel_rowdblclick, obj);
	obj.retGridPanel.on("beforeedit",obj.retGridPanel_beforeedit,obj);
	obj.retGridPanel.on("validateedit",obj.retGridPanel_validateedit,obj);
	obj.retGridPanel.on("afteredit",obj.retGridPanel_afteredit,obj);
	obj.chkSelAll.on("check",obj.chkSelAll_check,obj);
	obj.LoadEvent(arguments);
	return obj;
}
