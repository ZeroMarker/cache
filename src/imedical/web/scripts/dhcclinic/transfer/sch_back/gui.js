function InitViewScreen(){
	var obj = new Object();
	
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '开始日期'
		,labelSeparator: ''	//以后界面统一把label后面的冒号去掉
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

		,fieldLabel : '病案号'
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
		,fieldLabel : '手术间'
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
	obj.chkIfAllLoc = new Ext.form.Checkbox({
		id : 'chkIfAllLoc'
		,boxLabel : '<span style=\'font-size:14px;\'>全部科室</span>'
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
			obj.chkIfAllLoc
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,iconCls : 'icon-find'
		,text : '查'+'&nbsp&nbsp&nbsp'+'询'
		,width:100
		,height:30
	});
	
	obj.PanelS6 = new Ext.Panel({
		id : 'PanelS6'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.btnSch
		]
		,buttons:[
			
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
	
	//查询条件框
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 108
		,title : '<span style=\'font-size:14px;\'>手术列表查询</span>'
		,iconCls:'icon-find'	//查询加标志
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
		]
	});
	
	obj.ReceviceSure = new Ext.Button({
		id : 'ReceviceSure'
		,iconCls : 'recevice'
		,text : '护工报到'
		,width:120
		,height:30
	});
	obj.SendSure = new Ext.Button({
		id : 'SendSure'
		,iconCls : 'send'
		,text : '护工报到'
		,width:120
		,height:30
	});
	obj.PatInRoom = new Ext.Button({
		id : 'PatInRoom'
		,iconCls : 'recevice'
		,text : '入手术间'
		,width:120
		,height:30
		,hidden:true
	});
	obj.PatOutRoom = new Ext.Button({
		id : 'PatOutRoom'
		,iconCls : 'send'
		,text : '出手术间'
		,width:120
		,height:30
		,hidden:true
	});
	
	obj.tb=new Ext.Toolbar(
	{
		items:[
			{
				xtype: 'tbspacer', 
				width: 60
			}
			,obj.ReceviceSure
			,{
				xtype: 'tbspacer', 
				width: 60
			}
			,obj.PatInRoom
			,{
				xtype: 'tbspacer', 
				width: 60
			}
			,obj.SendSure
			,{
				xtype: 'tbspacer', 
				width: 60
			}
			,obj.PatOutRoom
			]
	});
	
	obj.sendUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.sendUserStore = new Ext.data.Store({
		proxy: obj.sendUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
		])
	});
	obj.receiveUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url: ExtToolSetting.RunQueryPageURL
		}));
	obj.receiveUserStore = new Ext.data.Store({
		proxy: obj.receiveUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}	
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
			,{name: 'oproomdes', mapping: 'oproomdes'}
			,{name: 'opaId', mapping: 'opaId'}
			,{name: 'patName', mapping: 'patName'}
			,{name: 'age', mapping: 'age'}
			,{name: 'sex', mapping: 'sex'}
			,{name: 'regNo', mapping: 'regNo'}
			,{name: 'opstdate', mapping: 'opstdate'}
			,{name: 'opsttime', mapping: 'opsttime'}
			,{name: 'status', mapping: 'status'}
			,{name: 'receiveAppDate', mapping: 'receiveAppDate'}
			,{name: 'receiveAppTime', mapping: 'receiveAppTime'}
			,{name: 'receiveAppUser', mapping: 'receiveAppUser'}
			,{name: 'receiveAssDate', mapping: 'receiveAssDate'}
			,{name: 'receiveAssTime', mapping: 'receiveAssTime'}
			,{name: 'receiveBackDate', mapping: 'receiveBackDate'}
			,{name: 'receiveBackTime', mapping: 'receiveBackTime'}
			,{name: 'receiveDate',type:'date',dateFormat:'j/n/Y',mapping: 'receiveDate'}
			,{name: 'receiveTime', mapping: 'receiveTime'}
			,{name: 'receiveUser', mapping: 'receiveUser'}
			,{name: 'sendAppDate', mapping: 'sendAppDate'}
			,{name: 'sendAppTime', mapping: 'sendAppTime'}
			,{name: 'sendAppUser', mapping: 'sendAppUser'}
			,{name: 'sendDate',type:'date',dateFormat:'j/n/Y', mapping: 'sendDate'}
			,{name: 'sendTime', mapping: 'sendTime'}
			,{name: 'sendUser', mapping: 'sendUser'}
			,{name: 'sendAssDate', mapping: 'sendAssDate'}
			,{name: 'sendAssTime', mapping: 'sendAssTime'}
			,{name: 'sendBackDate', mapping: 'sendBackDate'}
			,{name: 'sendBackTime', mapping: 'sendBackTime'}
			
		])
	});
	var cm = new Ext.grid.ColumnModel({

		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer({height:30}),
			{header: '术间', width: 80, dataIndex: 'oproomdes', sortable: true}
	        ,{header: 'opaId', width: 40, dataIndex: 'opaId', sortable: true,hidden:true}
			,{header: '姓名', width: 60, dataIndex: 'patName', sortable: true}
			,{header: '年龄', width: 40, dataIndex: 'age', sortable: true}
			,{header: '性别', width: 40, dataIndex: 'sex', sortable: true}
			,{header: '登记号', width: 100, dataIndex: 'regNo', sortable: true}
			,{header: '手术开始日期', width: 90, dataIndex: 'opstdate', sortable: true}
			,{header: '手术开始时间', width: 80, dataIndex: 'opsttime', sortable: true,hidden:true}
			,{header: '状态', width: 50, dataIndex: 'status', sortable: true}
			,{header: '接病人日期' 
			    ,width: 80
			    ,dataIndex: 'receiveDate'
			    ,sortable: true
			    ,editor: new Ext.form.DateField({ format : 'j/n/Y'})
				,renderer: function(value){
				 if (Ext.isEmpty(value)) {//判断是否是日期类型的数据  
                         return '';  
                 } else {  
                       if (Ext.isDate(value))  
                           return Ext.util.Format.date(value, 'Y-m-d');// 用于时间控件返回值  
                      else  
                           return Ext.util.Format.date(new Date(value), 'Y-m-d');// 转换为Date类型  
						   }  
				}
				,hidden:true
		     }
			,{header: '接病人时间', width: 80, dataIndex: 'receiveTime', sortable: true
			 ,editor: new Ext.form.TimeField({
		      format : 'H:i'
		      ,increment : 30
		      ,anchor : '90%'
	          })
	          ,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="font-size:18px;color:green;"';      
		        	return value;      
		        } 
	          }
			,{header: '接人者', width: 60, dataIndex: 'receiveUser', sortable: true
			 ,editor: new Ext.ux.form.LovCombo({
					id:'receiveUserLovCombo'
      				, minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.receiveUserStore
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
		      //,queryFields:['ctcpDesc'] //这个数组是用来设定查询字段的。
          	})
          	 ,renderer: function(value,metadata,record)
          	 {
	           metadata.attr = 'style="white-space:normal;"';
	           //alert("value="+value);
               var rv = value;
		      var rva = rv.split(new RegExp(','+ ' *'));
		      var va = [];
		      var snapshot = obj.receiveUserStore.snapshot ||  obj.receiveUserStore.data;
		      Ext.each(rva, function(v)
		       {
			      //alert("v="+v);
		      var ex=0;
			    snapshot.each(function(r)
			     {
				  if(v === r.get('ctcpId')) 
				  {
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
        	}}
        	,{header: '接病人护工报到日期', width: 40, dataIndex: 'receiveAssDate', sortable: true,hidden:true}
        	,{header: '接病人护工报到', width: 100, dataIndex: 'receiveAssTime', sortable: true}
        	,{header: '入手术室日期', width: 40, dataIndex: 'receiveBackDate', sortable: true,hidden:true}
        	,{header: '入手术室时间', width: 90, dataIndex: 'receiveBackTime', sortable: true}
			,{header: '送病人日期', width: 80, dataIndex: 'sendDate', sortable: true
			    //,renderer: Ext.util.Format.dateRenderer("j/n/Y")
			    ,editor: new Ext.form.DateField({format : 'j/n/Y' })
				,renderer: function(value){
				 if (Ext.isEmpty(value)) {//判断是否是日期类型的数据  
                         return '';  
                 } else {  
                       if (Ext.isDate(value))  
                           return Ext.util.Format.date(value, 'Y-m-d');// 用于时间控件返回值  
                      else  
                           return Ext.util.Format.date(new Date(value), 'Y-m-d');// 转换为Date类型  
						   }  
				}
			,hidden:true
			 }
			,{header: '送病人时间', width: 80, dataIndex: 'sendTime', sortable: true
			 ,editor: new Ext.form.TimeField({
		      format : 'H:i'
		      ,increment : 30
		      ,anchor : '90%'
	          })
	          ,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="font-size:18px;color:blue;"';      
		        	return value;      
		        } 
	          }
			,{header: '送人者', width: 60, dataIndex: 'sendUser', sortable: true
			,editor: new Ext.ux.form.LovCombo({
					id:'sendUserLovCombo'
      				, minChars : 1
					,displayField : 'ctcpDesc'
					,store : obj.sendUserStore
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
          	})
          	 ,renderer: function(value,metadata,record){
	          	metadata.attr = 'style="white-space:normal;"';
              var rv = value;
		      var rva = rv.split(new RegExp(','+ ' *'));
		      var va = [];
		      var snapshot = obj.sendUserStore.snapshot ||  obj.sendUserStore.data;
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
            ,{header: '送人者回日期', width: 40, dataIndex: 'sendBackDate', sortable: true,hidden:true}
            ,{header: '送病人护工报到日期', width: 40, dataIndex: 'sendAssDate', sortable: true,hidden:true}
        	,{header: '送病人护工报到', width: 100, dataIndex: 'sendAssTime', sortable: true}
            ,{header: '出手术间时间', width: 90, dataIndex: 'sendBackTime', sortable: true}
			,{header: '申请接病人日期', width: 100, dataIndex: 'receiveAppDate', sortable: true,hidden:true}
			,{header: '申请接病人时间', width: 100, dataIndex: 'receiveAppTime', sortable: true}
			,{header: '接病人申请人', width: 90, dataIndex: 'receiveAppUser', sortable: true}
			,{header: '申请送病人日期', width: 100, dataIndex: 'sendAppDate', sortable: true,hidden:true}
			,{header: '申请送病人时间', width: 100, dataIndex: 'sendAppTime', sortable: true}
			,{header: '送病人申请人', width: 90, dataIndex: 'sendAppUser', sortable: true}
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
        //,sm:obj.csm
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});

	//手术列表显示
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
			//obj.Panel23
			//,obj.Panel25
			obj.retGridPanel
		]
	});
	obj.ViewScreen=new Ext.Viewport({
		id:'ViewScreen'
		,layout:'border'
		,items:[
			obj.schPanel
			,obj.resultPanel
		]
	});
	
	
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;		
	});	
	obj.comOperStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'OpaStatus';
		param.ArgCnt = 1;
	});
	obj.comPatWardStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'GetWard';
		param.Arg1 = obj.comPatWard.getRawValue();
		param.ArgCnt = 1;
	});
	obj.comOprFloorStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'GetAllOperFloor';
		param.ArgCnt = 0;
	});
	obj.comOpRoomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindAncOperRoom';
		param.Arg1 = obj.comOpRoom.getRawValue();		
		param.Arg2 = '';
		param.Arg3 = 'OP^OUTOP^EMOP';
		param.Arg4 = '';
		param.Arg5 = ''
		param.Arg6 = 'T';
		param.Arg7 = obj.comAppLoc.getValue();
		param.ArgCnt = 7;
	});
	obj.comOpRoomStore.load({});
	
	obj.sendUserStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPTransfer';
			param.QueryName = 'GetTempGroup';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	obj.sendUserStore.load({}); 
	
	obj.receiveUserStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPTransfer';
			param.QueryName = 'GetTempGroup';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	obj.receiveUserStore.load({});  
	
	var sessWardId=session['LOGON.WARDID'];
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPTransfer';
			param.QueryName = 'GetANOPTransferList';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comOperStat.getValue();
			param.Arg4 = obj.comOpRoom.getValue();
			param.Arg5 = obj.comAppLoc.getValue();
			param.Arg6 = obj.txtMedCareNo.getValue();	
			param.Arg7 = sessWardId;
			param.Arg8 = obj.comOprFloor.getValue();
			param.Arg9 = obj.chkIfAllLoc.getValue()?'Y':'N';
			param.ArgCnt = 9;
		});
	obj.retGridPanelStore.load({});
	Ext.getCmp('receiveUserLovCombo').on("expand",lovCom_expand)
	Ext.getCmp('receiveUserLovCombo').on("focus",lovCom_focus)
	Ext.getCmp('sendUserLovCombo').on("expand",lovCom_expand)
	Ext.getCmp('sendUserLovCombo').on("focus",lovCom_focus)
	
	function lovCom_expand(comb)
    { 
  	    comb.setWidth(120); 
    }
	function lovCom_focus(comb)
    { 
    }
	InitViewScreenEvent(obj);
	
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.ReceviceSure.on("click", obj.ReceviceSure_click, obj);
	obj.SendSure.on("click", obj.SendSure_click, obj);
	obj.PatInRoom.on("click", obj.PatInRoom_click, obj);
	obj.PatOutRoom.on("click", obj.PatOutRoom_click, obj);
	obj.retGridPanel.on("beforeedit",obj.retGridPanel_beforeedit,obj);
	obj.retGridPanel.on("validateedit",obj.retGridPanel_validateedit,obj);
	obj.retGridPanel.on("afteredit",obj.retGridPanel_afteredit,obj);
	obj.LoadEvent(arguments);
	return obj;
}