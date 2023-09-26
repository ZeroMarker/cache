function InitWinScreen(){
    var obj = new Object();
	//患者姓名*
	obj.txtPatname = new Ext.form.TextField({
	    id : 'txtPatname'
		,fieldLabel : '患者姓名'
		,anchor :'98%'
	});
	//登记号*
	obj.txtPatRegNo = new Ext.form.TextField({
	    id : 'txtPatRegNo'
		,fieldLabel : '登记号'
		,anchor :'98%'
	});
	//性别*
	obj.txtPatSex = new Ext.form.TextField({
	    id : 'txtPatSex'
		,fieldLabel : '性别'
		,anchor :'90%'
	});
	//年龄*
	obj.txtPatAge = new Ext.form.TextField({
	    id : 'txtPatAge'
		,fieldLabel : '年龄'
		,anchor :'90%'
	});
	// 病人科室*
	obj.txtPatLoc = new Ext.form.TextField({
	    id : 'txtPatLoc'
		,fieldLabel : '病人科室'
		,anchor :'98%'
	});
	//病区*
	obj.txtPatWard = new Ext.form.TextField({
	    id : 'txtPatWard'
		,fieldLabel : '病区'
		,anchor :'98%'
	});
	//床号*
	obj.txtPatBedNo = new Ext.form.TextField({
	    id : 'txtPatBedNo'
		,fieldLabel : '床号'
		,anchor :'90%'
	});
	//费别*
	obj.txtAdmReason = new Ext.form.TextField({
	    id : 'txtAdmReason'
		,fieldLabel : '费别'
		,anchor :'90%'
	});
	//病人密级
	obj.txtPatSecret = new Ext.form.TextField({
	    id : 'txtPatSecret'
		,fieldLabel : '病人密级'
		,anchor :'90%'
	});
	//病人级别*
	obj.txtPatLevel = new Ext.form.TextField({
	    id : 'txtPatLevel'
		,fieldLabel : '病人级别'
		,anchor :'90%'
	});

	obj.Panel11 = new Ext.Panel({
	    id : 'Panel11'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.txtPatname
			,obj.txtPatLoc
		]
	});
	obj.Panel12 = new Ext.Panel({
	    id : 'Panel12'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.txtPatRegNo
			,obj.txtPatWard
		]
	});
	obj.Panel13 = new Ext.Panel({
	    id : 'Panel13'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.txtPatSex
			,obj.txtPatBedNo
		]
	});
	obj.Panel14 = new Ext.Panel({
	    id : 'Panel14'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .15
		,layout : 'form'
		,items : [
		    obj.txtPatAge
			,obj.txtAdmReason
		]
	});
	
	obj.Panel15 = new Ext.Panel({
	    id : 'Panel15'
		,buttonAlign : 'right'
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.txtPatSecret
			,obj.txtPatLevel
		]
	});
	obj.Panel16 = new Ext.Panel({
	    id : 'Panel16'
		,buttonAlign : 'right'
		,columnWidth : .01
		,layout : 'form'
		,items : [
		    //obj.btnSave
		]
	});
	obj.Panel17 = new Ext.Panel({
	    id : 'Panel17'
		,buttonAlign : 'right'
		,columnWidth : .01
		,layout : 'form'
		,items : [
			//obj.btnClose
		]
	});
	obj.admInfPanel = new Ext.form.FormPanel({
	    id : 'admInfPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,title : '病人信息'
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'column'
		,height : 85
		,frame : true
		,items : [
		     obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
			,obj.Panel15
		]
	});

	
	// 手术室*
	obj.comOperLocationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOperLocationStore = new Ext.data.Store({
	    proxy : obj.comOperLocationStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctlocId'
		},
		[
			{name:'ctlocDesc',mapping:'ctlocDesc'}
			,{name:'ctlocId',mapping:'ctlocId'}
		])
	
	});
	obj.comOperLocation = new Ext.form.ComboBox({
	    id : 'comOperLocation'
		,store : obj.comOperLocationStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '手术室'
		,valueField : 'ctlocId'
		,mode:'local'
		,typeAhead: true
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comOperLocationStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comOperLocation.getRawValue();
		param.Arg2 ='OP^OUTOP^EMOP'
		param.Arg3 =EpisodeID
		param.ArgCnt = 3;
	});
	obj.comOperLocationStore.load({})
	// 申请科室*
	obj.comAppLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppLocStore = new Ext.data.Store({
	    proxy : obj.comAppLocStoreProxy
		,reader : new Ext.data.JsonReader({
		     root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctlocId'
		},
		[
		    {name:'ctlocDesc',mapping:'ctlocDesc'}
			,{name:'ctlocId',mapping:'ctlocId'}
		])
	
	});
	obj.comAppLoc = new Ext.form.ComboBox({
	    id : 'comAppLoc'
		,store : obj.comAppLocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '申请科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 ='INOPDEPT^OUTOPDEPT^EMOPDEPT'
		param.Arg3 =EpisodeID
		param.ArgCnt = 3;
	});
	obj.Panel21 = new Ext.Panel({
	    id : 'Panel21'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .3
		,layout : 'form'
		,items : [
		    obj.comOperLocation
			,obj.comAppLoc		
		         ]
	});	
	//手术日期*
	obj.dateOper = new Ext.form.DateField({
	    id : 'dateOper'
		,value : new Date()
		,format : 'd/m/Y'
		,fieldLabel : '<span style="color:red;">*</span>手术日期'
		,anchor : '95%'
	});
	//医师*
	obj.comAppDocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppDocStore = new Ext.data.Store({
	    proxy : obj.comAppDocStoreProxy
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
	obj.comAppDoc = new Ext.form.ComboBox({
	    id : 'comAppDoc'
		,store : obj.comAppDocStore
		,minChars : 0
		,displayField : 'ctcpDesc'
		,fieldLabel : '医师'
		,mode:'remote'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		//,pageSize : 5
		,anchor : '95%'
	});
	obj.comAppDocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindCtcp';
		param.Arg1 = obj.comAppDoc.getRawValue();
		param.Arg2 ='INOPDEPT^OUTOPDEPT^EMOPDEPT'
		param.Arg3=obj.comAppLoc.getValue()
		param.Arg4 =EpisodeID
		param.Arg5 =opaId
		param.Arg6 ="Y"
		param.ArgCnt = 6;
	});
	obj.Panel22 = new Ext.Panel({
	    id : 'Panel22'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.dateOper
			,obj.comAppDoc
		]
	});
	obj.timeOper = new Ext.form.TimeField({
	    id : 'timeOper'
		,format : 'H:i'
		,increment : 30
		,fieldLabel : '时间'
		,anchor : '90%'
	});
	obj.chkOpType = new Ext.form.Checkbox({
	    id : 'chkOpType'
		,fieldLabel : '急诊'
		,anchor : '95%'
	});
	obj.Panel23 = new Ext.Panel({
	    id : 'Panel23'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .2
		,layout : 'form'
		,items : [
		    obj.timeOper
			,obj.chkOpType
		]
	});
	obj.timeOperPro =new Ext.form.TimeField({
	    id : 'timeOperPro'
		,format : 'H:i'
		,increment : 60
		,fieldLabel : '预计手术用时'
		,anchor : '95%'
	});
	obj.chkNeedAnaesthetist = new Ext.form.Checkbox({
	    id : 'chkNeedAnaesthetist'
		,fieldLabel : '麻醉否'
		,anchor : '95%'
	});
	obj.Panel24 = new Ext.Panel({
	    id : 'Panel24'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.timeOperPro,
		    obj.chkNeedAnaesthetist
		]
	});
	obj.Panel25 = new Ext.Panel({
	    id : 'Panel25'
		,buttonAlign : 'center'
		,columnWidth : .05
		,layout : 'form'
		,items : [
		]
	});
	obj.fPanel1 = new Ext.form.FormPanel({
	    id : 'fPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel21
			,obj.Panel22
			,obj.Panel23
			,obj.Panel24
		]
	});
	//术前诊断*
	obj.comOpPreDiagnosisStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpPreDiagnosisStore = new Ext.data.Store({
	    proxy : obj.comOpPreDiagnosisStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'rowid0'
		},
		[
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'DiagDes',mapping:'DiagDes'}
			,{name:'rowid0',mapping:'rowid0'}
		])
	
	});
	 obj.comOpPreDiagnosis = new Ext.ux.form.LovCombo({
	    id : 'comOpPreDiagnosis'
		,store : obj.comOpPreDiagnosisStore
		,minChars : 0
		,displayField : 'DiagDes'
		,fieldLabel : '<span style="color:red;">*</span>术前诊断'
		,valueField : 'rowid0'
		,triggerAction : 'all'
		,hideTrigger:false
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,anchor : '95%'
		,pageSize : 20
	});
	obj.comOpPreDiagnosisStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'LookUpMrcDiagnosis';
		    param.Arg1 =obj.comOpPreDiagnosis.queryStr   //obj.comOpPreDiagnosis.getRawValue()         //;
	    	param.ArgCnt = 1;
	 });
	obj.txtOpPreDiagMem = new Ext.form.TextField({
	    id : 'txtOpPreDiagMem'
		,fieldLabel : '诊断备注'
		,anchor :'95%'
	});
	obj.Panel3 = new Ext.Panel({
	    id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .8
		,layout : 'form'
		,items : [
		    obj.comOpPreDiagnosis
			,obj.txtOpPreDiagMem
		]
	});
	obj.fPanel2 = new Ext.form.FormPanel({
	    id : 'fPanel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel3
		]
	});
	//手术医师*
	obj.comSurgeonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comSurgeonStore = new Ext.data.Store({
	    proxy : obj.comSurgeonStoreProxy
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
	obj.comSurgeon = new Ext.form.ComboBox({
	    id : 'comSurgeon'
		,store : obj.comSurgeonStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '<span style="color:red;">*</span>手术医师'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comSurgeonStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comSurgeon.getRawValue();
		    param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT'; 
	    	param.Arg3 = obj.comAppLoc.getValue();
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y'; 
			param.Arg7 = 'Y';
	    	param.ArgCnt = 7;
	    });

	obj.Panel41 = new Ext.Panel({
	    id : 'Panel41'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.comSurgeon
		]
	});
	//一助*
	obj.comAssistDoc1StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAssistDoc1Store = new Ext.data.Store({
	    proxy : obj.comAssistDoc1StoreProxy
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
	obj.comAssistDoc1 = new Ext.form.ComboBox({
	    id : 'comAssistDoc1'
		,store : obj.comAssistDoc1Store
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '一助'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAssistDoc1StoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAssistDoc1.getRawValue();
		    param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT'; 
	    	param.Arg3 = obj.comAppLoc.getValue();
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y';
	    	param.ArgCnt = 6;
	    });
	//二助*
	obj.comAssistDoc2StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAssistDoc2Store = new Ext.data.Store({
	    proxy : obj.comAssistDoc2StoreProxy
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
	obj.comAssistDoc2 = new Ext.form.ComboBox({
	    id : 'comAssistDoc2'
		,store : obj.comAssistDoc2Store
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '二助'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAssistDoc2StoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAssistDoc2.getRawValue();
		    param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT'; 
	    	param.Arg3 = obj.comAppLoc.getRawValue();
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y';
	    	param.ArgCnt = 6;
	    });
	//三助*
	obj.comAssistDoc3StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAssistDoc3Store = new Ext.data.Store({
	    proxy : obj.comAssistDoc3StoreProxy
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
	obj.comAssistDoc3 = new Ext.form.ComboBox({
	    id : 'comAssistDoc3'
		,store : obj.comAssistDoc3Store
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '三助'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAssistDoc3StoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAssistDoc3.getRawValue();
		    param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT'; 
	    	param.Arg3 = obj.comAppLoc.getValue();
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y';
	    	param.ArgCnt = 6;
	    });
	
	obj.Panel42 = new Ext.Panel({
	    id : 'Panel42'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.comAssistDoc1
		]
	});
	obj.Panel43 = new Ext.Panel({
	    id : 'Panel43'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.comAssistDoc2
		]
	});
	obj.Panel44 = new Ext.Panel({
	    id : 'Panel44'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .25
		,layout : 'form'
		,items : [
		    obj.comAssistDoc3
		]
	});

	obj.panelOpDoc1=new Ext.Panel({
	    id : 'panelOpDoc1'
		,buttonAlign : 'center'
		,layout : 'column'
		,items : [
		    obj.Panel41
			,obj.Panel42
			,obj.Panel43
			,obj.Panel44
			//,obj.Panel45
		]
	});
	obj.txtOpDocNote = new Ext.form.TextField({
	    id : 'txtOpDocNote'
		,fieldLabel : '手术医师备注'
		,anchor :'95%'
	});
	obj.panelOpDocNote=new Ext.Panel({
	 id:'panelOpDocNote',
	 columnWidth : .5,
	 layout:'form',
	 items:[
	 obj.txtOpDocNote
	 ] 
	})
	//其他助手*
	obj.comAssistDocOStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAssistDocOStore = new Ext.data.Store({
	    proxy : obj.comAssistDocOStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctcpId'
		},
		[
		     {name: 'checked', mapping : 'checked'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
			,{name: 'ctcpDesc', mapping: 'ctcpDesc'}
			,{name: 'ctcpAlias', mapping: 'ctcpAlias'}
		])
	
	});
	obj.comAssistDocO = new Ext.ux.form.LovCombo({
	    id : 'comAssistDocO'
		,store : obj.comAssistDocOStore
		,minChars : 1
		,displayField : 'ctcpDesc'
		,fieldLabel : '其他助手'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
		,lazyRender : true
		,hideOnSelect:false
		,autoHeight:true
		,selectOnFocus:false
	});
	obj.comAssistDocOStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAssistDocO.queryStr;
		    param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT'; 
	    	param.Arg3 = obj.comAppLoc.getValue();
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y';
	    	param.ArgCnt = 6;
	    });
	obj.Panel45 = new Ext.Panel({
	    id : 'Panel45'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .3
		,layout : 'form'
		,items : [
		    obj.comAssistDocO
		]
	});
	obj.txtOpSeqNote=new Ext.form.TextField({
	    id : 'txtOpSeqNote'
		,fieldLabel : '手术编号'
		,anchor :'95%'
	});
	obj.pnlOpSeqNote=new Ext.Panel({
	    id : 'pnlOpSeqNote'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .2
		,layout : 'form'
		,items : [
		obj.txtOpSeqNote
		]
	});
	obj.panelOpDoc2=new Ext.Panel({
	    id : 'panelOpDoc2'
		,buttonAlign : 'center'
		,layout : 'column'
		,items : [
         obj.panelOpDocNote
		 ,obj.Panel45
		 ,obj.pnlOpSeqNote
		]
	});
	obj.fPanel3 = new Ext.form.FormPanel({
	    id : 'fPanel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		//,title : '手术医师'
		//,frame:true
		,labelAlign : 'right'
		,items : [
		    obj.panelOpDoc1,
			obj.panelOpDoc2
		         ]
	});
	//手术名称*
	obj.comOpNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpNameStore = new Ext.data.Store({
	    proxy : obj.comOpNameStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'rowid'
		},
		[
		    {name:'OPTypeDes',mapping:'OPTypeDes'}
			,{name:'rowid',mapping:'rowid'}
			,{name:'OPCategory',mapping:'OPCategory'}
		])
	
	});
	obj.comOpName = new Ext.form.ComboBox({
	    id : 'comOpName'
		,store : obj.comOpNameStore
		,minChars : 1
		,value : ''
		,displayField : 'OPTypeDes'
		,fieldLabel : '<span style="color:red;">*</span>拟施手术'
		,valueField : 'rowid'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comOpNameStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindOrcOperation';
		    param.Arg1 = obj.comOpName.getRawValue();
		    param.Arg2 = obj.comSurgeon.getValue();
	    	param.ArgCnt = 2;
	    });
	//手术级别*
	obj.comAnaOpLevelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaOpLevelStore = new Ext.data.Store({
	    proxy : obj.comAnaOpLevelStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ANCOPLRowId'
		},
		[
		    {name:'ANCPLDesc',mapping:'ANCPLDesc'}
			,{name:'ANCOPLRowId',mapping:'ANCOPLRowId'}
		])
	});
	obj.comAnaOpLevel = new Ext.form.ComboBox({
	    id : 'comAnaOpLevel'
		,store : obj.comAnaOpLevelStore
		,minChars : 1
		,value : ''
		,displayField : 'ANCPLDesc'
		,fieldLabel : '<span style="color:red;">*</span>手术级别'
		,valueField : 'ANCOPLRowId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comAnaOpLevelStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetOPLevel';
	    	param.ArgCnt = 0;
	    });
	//切口类型*
	obj.comOpBladeTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpBladeTypeStore = new Ext.data.Store({
	    proxy : obj.comOpBladeTypeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'BLDTPRowId'
		},
		[
		    {name:'BLDTPDesc',mapping:'BLDTPDesc'}
			,{name:'BLDTPRowId',mapping:'BLDTPRowId'}
		])
	});
	obj.comOpBladeType = new Ext.form.ComboBox({
	    id : 'comOpBladeType'
		,store : obj.comOpBladeTypeStore
		,minChars : 1
		,value : ''
		,displayField : 'BLDTPDesc'
		,fieldLabel : '切口'
		,valueField : 'BLDTPRowId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comOpBladeTypeStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetBladeType';
	    	param.ArgCnt = 0;
	    });
	obj.Panel51 = new Ext.Panel({
	    id : 'Panel51'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .45
		,layout : 'form'
		,items : [
		    obj.comOpName
		]
	});
	obj.Panel52 = new Ext.Panel({
	    id : 'Panel52'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .18
		,layout : 'form'
		,items : [
		    obj.comAnaOpLevel
		]
	});
	obj.Panel53 = new Ext.Panel({
	    id : 'Panel53'
		,buttonAlign : 'center'
		,labelWidth:35
		,columnWidth : .14
		,layout : 'form'
		,items : [
		    obj.comOpBladeType
		]
	});
	obj.txtOpNote = new Ext.form.TextField({
	    id : 'txtOpNote'
		,fieldLabel : '备注'
		,anchor :'95%'
	});
	obj.Panel54 = new Ext.Panel({
	    id : 'Panel54'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .23
		,layout : 'form'
		,items : [
		    obj.txtOpNote
		]
	});
	obj.fPanel4 = new Ext.form.FormPanel({
	    id : 'fPanel4'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel51
			,obj.Panel52
			,obj.Panel53
			,obj.Panel54
		]
	});
	obj.listOpNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.listOpNameStore = new Ext.data.Store({
		proxy: obj.listOpNameStoreProxy,
	    reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'operId'
		},
		[
		     {name:'operId',mapping:'operId'}
			,{name:'operDesc',mapping:'operDesc'}
			,{name:'opLevelId',mapping:'opLevelId'}
			,{name:'opLevelDesc',mapping:'opLevelDesc'}
			,{name:'bldTpId',mapping:'bldTpId'}
			,{name:'bldTypeDesc',mapping:'bldTypeDesc'}
			,{name:'operNotes',mapping:'operNotes'}
		])
	});
	obj.listOpNameStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPArrange';
		    param.QueryName = 'GetOpList';
			param.Arg1 = opaId;
	    	param.ArgCnt = 1;
	    });
	//手术列表*
	obj.listOpName = new Ext.grid.GridPanel({
	    id : 'listOpName'
		,store: obj.listOpNameStore
		,singleSelect : true
		,width : 580
		,height : 122
		,frame:true
		,columnLines:true 
		,hideHeaders:false
		,bodyStyle :'overflow-x:hidden;overflow-y:auto'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,columns: [
		           {
		             header : '拟施手术'
                     ,dataIndex: 'operDesc'
					 ,width:260
                   },
				   {
				     header:'手术级别'
					 ,dataIndex: 'opLevelDesc'
					 ,width:60
				   },
				    {
				     header:'切口'
					 ,dataIndex: 'bldTypeDesc'
					 ,width:40
				   },
				     {
				     header:'手术备注'
					 ,dataIndex: 'operNotes'
					 ,width:180
				   }
			]
		,viewConfig:
		{
		   forceFit: true
		}
    });
	obj.listPanel2 = new Ext.Panel({
	    id : 'listPanel2'
		,buttonAlign : 'center'
		,labelWidth:0
		//,frame : true
		,items : [
		    obj.listOpName
		]
	});
	obj.Panel61 = new Ext.Panel({
	    id : 'Panel61'
		,buttonAlign : 'center'
		,columnWidth :.8
		,layout : 'form'
		,items : [
		    //obj.listPanel2
			obj.listOpName
		]
	});
	obj.txtAreaOpMem = new Ext.form.TextArea({
	    id : 'txtAreaOpMem'
		,fieldLabel : '手术要求'
		,anchor :'95%'
		,autoHeight : true
	});
    obj.btnAdd = new Ext.Button({
	    id : 'btnAdd'
		,text : '增加'
		,anchor :'90%'
	});
	obj.btnUpdate = new Ext.Button({
	    id : 'btnUpdate'
		,text : '修改'
		,anchor :'90%'
	});
	obj.btnDelete = new Ext.Button({
	    id : 'btnDelete'
		,text : '删除'
		,anchor :'90%'
	});
	obj.Panel63 = new Ext.Panel({
	    id : 'Panel63'
		,buttonAlign : 'center'
		,columnWidth : .06
		,layout : 'form'
		,items : [
			obj.btnAdd
		]
	});
	obj.Panel64 = new Ext.Panel({
	    id : 'Panel64'
		,buttonAlign : 'center'
		,columnWidth : .06
		,layout : 'form'
		,items : [
			obj.btnUpdate
		]
	});
	obj.Panel65 = new Ext.Panel({
	    id : 'Panel65'
		,buttonAlign : 'center'
		,columnWidth : .06
		,layout : 'form'
		,items : [
			obj.btnDelete
		]
	});
	obj.fPanel5 = new Ext.form.FormPanel({
	    id : 'fPanel5'
		,buttonAlign : 'center'
		//,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			obj.Panel61
			,obj.Panel63
			,obj.Panel64
			,obj.Panel65
		]
	});
	obj.wPanel2 = new Ext.Panel({
	    id : 'wPanel2'
		,buttonAlign : 'center'
		//,height : 800
		,title : '拟施手术'
		,autoScroll : true
		,region : 'center'
		,layout : 'form'
		,frame : true
		,items : [
			 obj.fPanel4
			,obj.fPanel5
		]
	});
	//手术部位*
	obj.comBodySiteStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comBodySiteStore = new Ext.data.Store({
	    proxy : obj.comBodySiteStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'BODS_RowId'
		},
		[
		    {name:'BODS_Desc',mapping:'BODS_Desc'}
			,{name:'BODS_RowId',mapping:'BODS_RowId'}
		])
	});
	
	obj.comBodySite = new Ext.ux.form.LovCombo({
	    id : 'comBodySite'
		,store : obj.comBodySiteStore
		,minChars : 0
		,displayField : 'BODS_Desc'
		,fieldLabel : '手术部位'
		,editable:false
		,valueField : 'BODS_RowId'
		,triggerAction : 'all'
		,hideTrigger:false
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,anchor : '98%'
	});
	obj.comBodySiteStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'FindBodySite';
		    param.ArgCnt = 0;
	    });
	//手术体位*
	obj.comOperPositionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOperPositionStore = new Ext.data.Store({
	    proxy : obj.comOperPositionStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'OPPOS_RowId'
		},
		[
		    {name:'OPPOS_Desc',mapping:'OPPOS_Desc'}
			,{name:'OPPOS_RowId',mapping:'OPPOS_RowId'}
		])
	});
	obj.comOperPosition = new Ext.form.ComboBox({
	    id : 'comOperPosition'
		,store : obj.comOperPositionStore
		,minChars : 1
		,value : ''
		,displayField : 'OPPOS_Desc'
		,fieldLabel : '手术体位'
		,valueField : 'OPPOS_RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOperPositionStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetOperPosition';
	    	param.ArgCnt = 0;
	    });
	obj.Panel61 = new Ext.Panel({
	    id : 'Panel61'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .5
		,layout : 'form'
		,items : [
			obj.txtAreaOpMem
		]
	});
	obj.Panel62 = new Ext.Panel({
	    id : 'Panel62'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .3
		,layout : 'form'
		,items : [
			obj.comBodySite
		]
	});
	obj.Panel63 = new Ext.Panel({
	    id : 'Panel63'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.comOperPosition
		]
	});
	obj.fPanel6 = new Ext.form.FormPanel({
	    id : 'fPanel6'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel61
			,obj.Panel62
			,obj.Panel63
		]
	});
	
	obj.chkIsolated = new Ext.form.Checkbox({
	    id : 'chkIsolated'
		,fieldLabel : '隔离'
		,anchor : '95%'
	});
	obj.chkIsExCirculation = new Ext.form.Checkbox({
	    id : 'chkIsExCirculation'
		,fieldLabel : '是否体外循环'
		,anchor : '95%'
	});
	obj.chkIsUseSelfBlood = new Ext.form.Checkbox({
	    id : 'chkIsUseSelfBlood'
		,fieldLabel : '自体血回输'
		,anchor : '95%'
	});
	obj.chkIsPrepareBlood = new Ext.form.Checkbox({
	    id : 'chkIsPrepareBlood'
		,fieldLabel : '是否备血'
		,anchor : '95%'
	});

	obj.Panel71 = new Ext.Panel({
	    id : 'Panel71'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.chkIsolated
		]
	});
	obj.Panel72 = new Ext.Panel({
	    id : 'Panel72'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.chkIsExCirculation
		]
	});
	obj.Panel73= new Ext.Panel({
	    id : 'Panel73'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .3
		,layout : 'form'
		,items : [
			obj.chkIsUseSelfBlood
		]
	});
	obj.Panel74 = new Ext.Panel({
	    id : 'Panel74'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.chkIsPrepareBlood
		]
	});
	obj.fPanel7 = new Ext.form.FormPanel({
	    id : 'fPanel7'
		,buttonAlign : 'center'
		,labelWidth : 80
		,bodyStyle :'overflow-x:hidden;overflow-y:auto'
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel71
			,obj.Panel72
			,obj.Panel73
			,obj.Panel74
		]
	});
	//血型*
	obj.comBloodTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comBloodTypeStore = new Ext.data.Store({
	    proxy : obj.comBloodTypeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'BLDTRowId'
		},
		[
		    {name:'BLDTDesc',mapping:'BLDTDesc'}
			,{name:'BLDTRowId',mapping:'BLDTRowId'}
		])
	});
	obj.comBloodType = new Ext.form.ComboBox({
	    id : 'comBloodType'
		,store : obj.comBloodTypeStore
		,minChars : 1
		,editable:false
		,displayField : 'BLDTDesc'
		,fieldLabel : '<span style="color:red;">*</span>血型'
		,valueField : 'BLDTRowId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comBloodTypeStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetBlood';
	    	param.ArgCnt = 0;
	    });
   //RH血型*
	obj.comRHBloodTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comRHBloodTypeStore = new Ext.data.Store({
	    proxy : obj.comRHBloodTypeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'RHId'
		},
		[
		    {name:'RHDesc',mapping:'RHDesc'}
			,{name:'RHId',mapping:'RHId'}
		])
	});
	obj.comRHBloodType = new Ext.form.ComboBox({
	    id : 'comRHBloodType'
		,store : obj.comRHBloodTypeStore
		,minChars : 1
		,displayField : 'RHDesc'
		,editable:false
		,fieldLabel : '<span style="color:red;">*</span>RH血型'
		,valueField : 'RHId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comRHBloodTypeStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'RHBlood';
	    	param.ArgCnt = 0;
	    });
	//HBSAG*
	obj.comCheckQuStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comCheckQuStore = new Ext.data.Store({
	    proxy : obj.comCheckQuStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ord'
		},
		[
		    {name:'typ',mapping:'typ'}
			,{name:'ord',mapping:'ord'}
		])
	});
	obj.comHbsAg = new Ext.form.ComboBox({
	    id : 'comHbsAg'
		,store : obj.comCheckQuStore
		,minChars : 1
		,editable:false
		,displayField : 'typ'
		,fieldLabel : '<span style="color:red;">*</span>HbsAg'
		,valueField : 'ord'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	//HCVAB*
	obj.comHcvAb = new Ext.form.ComboBox({
	    id : 'comHcvAb'
		,store : obj.comCheckQuStore
		,minChars : 1
		,editable:false
		,displayField : 'typ'
		,fieldLabel : '<span style="color:red;">*</span>Hcv_Ab'
		,valueField : 'ord'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	//HIVAB*
	obj.comHivAb = new Ext.form.ComboBox({
	    id : 'comHivAb'
		,store : obj.comCheckQuStore
		,minChars : 1
		,editable:false
		,displayField : 'typ'
		,fieldLabel : '<span style="color:red;">*</span>Hiv_Ab'
		,valueField : 'ord'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	//RPR*
	obj.comRPR = new Ext.form.ComboBox({
	    id : 'comRPR'
		,store : obj.comCheckQuStore
		,minChars : 1
		,editable:false
		,displayField : 'typ'
		,fieldLabel : '<span style="color:red;">*</span>梅毒'
		,valueField : 'ord'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comCheckQuStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'checkqu';
	    	param.ArgCnt = 0;
	    });
	
	obj.txtOther = new Ext.form.TextField({
	    id : 'txtOther'
		,fieldLabel : '其他'
		,anchor :'98%'
	});
	obj.Panel81 = new Ext.Panel({
	    id : 'Panel81'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.comBloodType
		]
	});
	obj.Panel82 = new Ext.Panel({
	    id : 'Panel82'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .17
		,layout : 'form'
		,items : [
			obj.comRHBloodType
		]
	});obj.Panel83 = new Ext.Panel({
	    id : 'Panel83'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .16
		,layout : 'form'
		,items : [
			obj.comHbsAg
		]
	});
	obj.Panel84 = new Ext.Panel({
	    id : 'Panel84'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .18
		,layout : 'form'
		,items : [
			obj.comHcvAb
		]
	});
	obj.Panel85 = new Ext.Panel({
	    id : 'Panel85'
		,buttonAlign : 'center'
		,labelWidth:50
		,columnWidth : .18
		,layout : 'form'
		,items : [
			obj.comHivAb
		]
	});
	obj.Panel86 = new Ext.Panel({
	    id : 'Panel86'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth:40
		,layout : 'form'
		,items : [
			obj.comRPR
		]
	});
	obj.Panel87 = new Ext.Panel({
	    id : 'Panel87'
		,buttonAlign : 'center'
		,labelWidth:32
		,columnWidth :.5
		,layout : 'form'
		,items : [
			obj.txtOther
		]
	});
	obj.requisiteExamPanel=new Ext.Panel({
	    id : 'requisiteExamPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items : [
			 obj.Panel81
			,obj.Panel82
			,obj.Panel83
			,obj.Panel84
			,obj.Panel85
			,obj.Panel86
		]
	})
	obj.otherExamPanel=new Ext.Panel({
	    id : 'otherExamPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items : [
		obj.Panel87
		]
	})
	obj.examPanel = new Ext.form.FormPanel({
		id : 'examPanel'
		,buttonAlign : 'center'
		//,title : '血型及化验结果'
		,frame:true
		,height : 65
		,labelAlign : 'right'
		,items : [
		    obj.requisiteExamPanel
			,obj.otherExamPanel
		]	
	});
	obj.wPanel1 = new Ext.Panel({
	    id : 'wPanel1'
		,buttonAlign : 'center'
		,height : 176
		,frame:true
		,region : 'north'
		,layout : 'form'
		,items : [
			obj.fPanel1
			,obj.fPanel2
			,obj.fPanel3
		]
	});
	
	obj.btnSave = new Ext.Button({
	    id : 'btnSave'
		,text : '确认'
		,height:32
		,width:80
	});
	obj.btnClose = new Ext.Button({
	    id : 'btnClose'
		,text : '关闭'
		,height:32
		,width:80
	});
	 obj.btnSpace=new Ext.Panel({
	   id:'btnSpace'
	   ,autoScroll:true  
	   ,columnWidth : .6
	   ,items:
	   [
	   ]
	  })
	 obj.btnSavePanel=new Ext.Panel({
	   id:'btnSavePanel'
	   ,autoScroll:true  
	   ,columnWidth : .2
	   ,items:
	   [
	    obj.btnSave
	   ]
	  })
	  obj.btnClosePanel=new Ext.Panel({
	   id:'btnClosePanel'
	   ,autoScroll:true  
	   ,columnWidth : .2
	   ,items:
	   [
	    obj.btnClose
	   ]
	  })
     obj.btnPanel=new Ext.Panel({
	   id:'btnPanel'
	   ,height:35
       ,layout:'column'   
	   ,items:
	   [
	    obj.btnSpace,
	    obj.btnSavePanel,
		obj.btnClosePanel
	   ]
	})
	
	obj.wPanel3 = new Ext.Panel({
	    id : 'wPanel3'
		,buttonAlign : 'center'
		,height :175
		,frame:true
		,region : 'south'
		,layout : 'form'
		,items : [
			 obj.fPanel6
			,obj.fPanel7
			,obj.examPanel
			,obj.btnPanel
		]
	});

	obj.wardPanel = new Ext.Panel({
	    id : 'wardPanel'
		,buttonAlign : 'center'
		,title : '病区填写项目'
		,layout : 'border'
		,frame:true
		,items : [
			 obj.wPanel1
			,obj.wPanel2
			,obj.wPanel3
		]
		
	});
	
	//麻醉科填写项目///////////////////////////////////////////
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

	obj.comAnaDoc = new Ext.form.ComboBox({
	    id : 'comAnaDoc'
		,store : obj.comAnaDocStore
		,minChars : 1
		,displayField : 'ctcpDesc'
		,fieldLabel : '<span style="color:red;">*</span>麻醉主治医师'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAnaDocStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAnaDoc.getRawValue();
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'Y';
	    	param.ArgCnt = 5;
	    });
	obj.comAnaDocOStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaDocOStore = new Ext.data.Store({
	    proxy : obj.comAnaDocOStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctcpId'
		},
		[
		    {name: 'checked', mapping : 'checked'}
		    ,{name:'ctcpDesc',mapping:'ctcpDesc'}
			,{name:'ctcpId',mapping:'ctcpId'}
		])
	});
	obj.comAnaDocO = new Ext.ux.form.LovCombo({
	    id : 'comAnaDocO'
		,store : obj.comAnaDocOStore
		,minChars : 1
		,displayField : 'ctcpDesc'
		,fieldLabel : '麻醉助手'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
   obj.comAnaDocOStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAnaDocO.queryStr;
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'Y';
	    	param.ArgCnt = 5;
	    });
	obj.comSAnaDocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comSAnaDocStore = new Ext.data.Store({
	    proxy : obj.comSAnaDocStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctcpId'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'ctcpDesc',mapping:'ctcpDesc'}
			,{name:'ctcpId',mapping:'ctcpId'}
		])
	
	});
	obj.comSAnaDoc = new Ext.ux.form.LovCombo({
	    id : 'comSAnaDoc'
		,store : obj.comSAnaDocStore
		,minChars : 1
		,displayField : 'ctcpDesc'
		,fieldLabel : '交麻醉医师'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
   obj.comSAnaDocStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comSAnaDoc.queryStr;
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'Y';
	    	param.ArgCnt = 5;
	    });
	obj.comAnaNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaNurseStore = new Ext.data.Store({
	    proxy : obj.comAnaNurseStoreProxy
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
	obj.comAnaNurse = new Ext.form.ComboBox({
	    id : 'comAnaNurse'
		,store : obj.comAnaNurseStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '麻醉护士'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAnaNurseStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAnaNurse.getRawValue();
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'N';
	    	param.ArgCnt = 5;
	    });
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
	obj.comAnaMethod = new Ext.ux.form.LovCombo({
	    id : 'comAnaMethod'
		,store : obj.comAnaMethodStore
		,minChars : 1
		,value : ''
		,displayField : 'Des'
		,fieldLabel : '<span style="color:red;">*</span>麻醉方法'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAnaMethodStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindAnaestMethod';
		    param.Arg1 = obj.comAnaMethod.queryStr;
	    	param.ArgCnt = 1;
	    });
	obj.comAnaSupervisorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaSupervisorStore = new Ext.data.Store({
	    proxy : obj.comAnaSupervisorStoreProxy
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
	obj.comAnaSupervisor = new Ext.form.ComboBox({
	    id : 'comAnaSupervisor'
		,store : obj.comAnaSupervisorStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '麻醉指导医师'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comAnaSupervisorStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comAnaSupervisor.getRawValue();
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'Y';
	    	param.ArgCnt = 5;
	    });
	obj.comAnaLevelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAnaLevelStore = new Ext.data.Store({
	    proxy : obj.comAnaLevelStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ANCOPLRowId'
		},
		[
		    {name:'ANCPLDesc',mapping:'ANCPLDesc'}
			,{name:'ANCOPLRowId',mapping:'ANCOPLRowId'}
		])
	});
	obj.comAnaLevel = new Ext.form.ComboBox({
	    id : 'comAnaLevel'
		,store : obj.comAnaLevelStore
		,minChars : 1
		,value : ''
		,displayField : 'ANCPLDesc'
		,fieldLabel : '麻醉规模'
		,valueField : 'ANCOPLRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
   obj.comAnaLevelStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetOPLevel';
	    	param.ArgCnt = 0;
	    });
	obj.txtAnaDocNote = new Ext.form.TextField({
	    id : 'txtAnaDocNote'
		,fieldLabel : '麻醉医师备注'
		,anchor :'95%'
	});

	obj.Panel91 = new Ext.Panel({
	    id : 'Panel91'
		,buttonAlign : 'center'
		,labelWidth : 90
		,columnWidth : .33
		,layout : 'form'
		,items : [
			obj.comAnaDoc
		]
	});
	obj.Panel96 = new Ext.Panel({
	    id : 'Panel96'
		,buttonAlign : 'center'
		,labelWidth : 80
		,layout : 'form'
		,columnWidth : .33
		,items : [
			obj.comAnaSupervisor
		]
	});
	obj.Panel94 = new Ext.Panel({
	    id : 'Panel94'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .33
		,layout : 'form'
		,items : [
			obj.comAnaNurse
		]
	});
	obj.anafPanel1 = new Ext.Panel({
		id : 'anafPanel1'
		,buttonAlign : 'center'
		//,height : 30
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel91
			,obj.Panel96
			,obj.Panel94
		]
	});
	
	obj.Panel92 = new Ext.Panel({
	    id : 'Panel92'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items : [
			obj.comAnaDocO
		]
	});
	obj.Panel93 = new Ext.Panel({
	    id : 'Panel93'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items : [
			obj.comSAnaDoc
		]
	});

	obj.Panel95 = new Ext.Panel({
	    id : 'Panel95'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items : [
			obj.comAnaMethod
		]
	});

	obj.anafPanel2 = new Ext.form.FormPanel({
		id : 'anafPanel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		//,height : 30
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		         obj.Panel92
		        ,obj.Panel93
		        ]
	});
	obj.anafPanel3 = new Ext.form.FormPanel({
		id : 'anafPanel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		//,height : 30
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			 obj.Panel95
		      ]
	});
	obj.Panel97 = new Ext.Panel({
	    id : 'Panel97'
		,buttonAlign : 'center'
		,labelWidth : 80
		,columnWidth : .5
		,layout : 'form'
		,items : [
			obj.txtAnaDocNote
		]
	});
	obj.Panel98 = new Ext.Panel({
	    id : 'Panel98'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .3
		,layout : 'form'
		,items : [
			obj.comAnaLevel
		]
	});
	obj.Panel99 = new Ext.Panel({
	    id : 'Panel99'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .2
		,layout : 'form'
		,items : [
		]
	});
	obj.anafPanel4 = new Ext.form.FormPanel({
		id : 'anafPanel4'
		,buttonAlign : 'center'
		//,height : 30
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			 obj.Panel97
			,obj.Panel98
			,obj.Panel99
		]
	});
	obj.btnAnSave=new Ext.Button({
		id : 'btnAnSave'
		,text : '确认'
		,height:32
		,width:80
	});
	obj.btnAnClose=new Ext.Button({
		id : 'btnAnClose'
		,text : '关闭'
		,height:32
		,width:80
	});
	obj.pnlButton1=new Ext.Panel({
		id : 'pnlButton1'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items : [  	
		]
	});
	obj.pnlButton2=new Ext.Panel({
		id : 'pnlButton2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnAnSave		
		]
	});
	obj.pnlButton3=new Ext.Panel({
		id : 'pnlButton3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnAnClose	
		]
	});
	obj.anafPanel5 = new Ext.form.FormPanel({
		id : 'anafPanel5'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 40
		,labelAlign : 'right'
		,layout : 'column'
		,items : [    
		]
	});
    obj.anafPanel6 = new Ext.form.FormPanel({
		id : 'anafPanel6'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 40
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
	      obj.pnlButton1
		 ,obj.pnlButton2
		 ,obj.pnlButton3
		]
	});
	obj.pnlAnContent=new Ext.Panel({
	 id:'pnlAnContent'
	,layout : 'form'
	,frame : true
	,items:[
	  obj.anafPanel1
	  ,obj.anafPanel2
	  ,obj.anafPanel3
	  ,obj.anafPanel4  
	]
	})
	obj.anPanel = new Ext.Panel({
	    id : 'anPanel'
		,buttonAlign : 'center'
		,title : '麻醉科填写项目'
		//,height : 150
		//,layout : 'form'
		,frame : true
		,items : [
         obj.pnlAnContent
		 ,obj.anafPanel5 
		 ,obj.anafPanel6
		]
	});
	obj.comOperRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOperRoomStore = new Ext.data.Store({
	    proxy : obj.comOperRoomStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'oprId'
		},
		[
		     {name:'oprDesc',mapping:'oprDesc'}
			,{name:'oprId',mapping:'oprId'}
		])
	});
	obj.comOperRoom = new Ext.form.ComboBox({
	    id : 'comOperRoom'
		,store : obj.comOperRoomStore
		,minChars : 1
		,displayField : 'oprDesc'
		,fieldLabel : '手术间'
		,valueField : 'oprId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOperRoomStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindAncOperRoom';
	    	param.Arg1 = obj.comOperRoom.getRawValue();
		    param.Arg2 = obj.comOperLocation.getValue();
	    	param.Arg3 = 'OP^OUTOP^EMOP'; 
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = '';
			param.Arg7 = obj.comAppLoc.getRawValue();;
	    	param.ArgCnt = 7;
	    });
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
	obj.comOrdNo = new Ext.form.ComboBox({
	    id : 'comOrdNo'
		,fieldLabel : '台次'
		,anchor :'95%'
		,minChars : 1
		,displayField : 'desc'
		,valueField : 'code'
		,triggerAction : 'all'
		,anchor : '95%'
		,store:obj.ordNoStore
	});
	obj.timeArrOper = new Ext.form.TimeField({
	    id : 'timeArrOper'
		,format : 'H:i'
		,increment : 30
		,fieldLabel : '安排时间'
		,anchor : '95%'
	});
	obj.chkIfShift = new Ext.form.Checkbox({
	    id : 'chkIfShift'
		,fieldLabel : '交班'
		,anchor : '95%'
	});
	obj.comScrubNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comScrubNurseStore = new Ext.data.Store({
	    proxy : obj.comScrubNurseStoreProxy
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
	obj.comScrubNurse = new Ext.ux.form.LovCombo({
	    id : 'comScrubNurse'
		,store : obj.comScrubNurseStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '器械护士'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
 	obj.comScrubNurseStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comScrubNurse.queryStr;
		    param.Arg2 = 'OP^OUTOP^EMOP'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'N';
	    	param.ArgCnt = 5;
	    });

	
	obj.comShiftScrubNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comShiftScrubNurseStore = new Ext.data.Store({
	    proxy : obj.comShiftScrubNurseStoreProxy
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
	obj.comShiftScrubNurse = new Ext.ux.form.LovCombo({
	    id : 'comShiftScrubNurse'
		,store : obj.comShiftScrubNurseStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '交器械护士'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comShiftScrubNurseStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comShiftScrubNurse.queryStr;
		    param.Arg2 = 'OP^OUTOP^EMOP'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'N';
	    	param.ArgCnt = 5;
	    });
	obj.comCirculNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comCirculNurseStore = new Ext.data.Store({
	    proxy : obj.comCirculNurseStoreProxy
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
	obj.comCirculNurse = new Ext.ux.form.LovCombo({
	    id : 'comCirculNurse'
		,store : obj.comCirculNurseStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '巡回护士'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
    obj.comCirculNurseStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comCirculNurse.queryStr;
		    param.Arg2 = 'OP^OUTOP^EMOP'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'N';
	    	param.ArgCnt = 5;
	    });
	obj.comShiftCirculNurseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comShiftCirculNurseStore = new Ext.data.Store({
	    proxy : obj.comShiftCirculNurseStoreProxy
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
	obj.comShiftCirculNurse = new Ext.ux.form.LovCombo({
	    id : 'comShiftCirculNurse'
		,store : obj.comShiftCirculNurseStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '交巡回护士'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comShiftCirculNurseStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.comShiftCirculNurse.queryStr;
		    param.Arg2 = 'OP^OUTOP^EMOP'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'N';
	    	param.ArgCnt = 5;
	    });
	obj.txtScrubNurseNote = new Ext.form.TextField({
	    id : 'txtScrubNurseNote'
		,fieldLabel : '器械护士备注'
		,anchor :'95%'
	});
	obj.txtCirculNurseNote = new Ext.form.TextField({
	    id : 'txtCirculNurseNote'
		,fieldLabel : '巡回护士备注'
		,anchor :'95%'
	});
	obj.txtOpReq = new Ext.form.TextArea({
	    id : 'txtOpReq'
		,anchor :'95%'
		,fieldLabel : '备注'
		,autoHeight : true
	});
	obj.txtNote = new Ext.form.TextArea({
	    id : 'txtNote'
		,anchor :'95%'
		,fieldLabel : '注意事项'
	});
	obj.dateOpStt = new Ext.form.DateField({
	    id : 'dateOpStt'
		,value : obj.dateOper.getRawValue()
		,format : 'd/m/Y'
		,fieldLabel : '手术开始日期'
		,anchor : '95%'
	});
	obj.dateOpEnd = new Ext.form.DateField({
	    id : 'dateOpEnd'
		,value : obj.dateOper.getRawValue()
		,format : 'd/m/Y'
		,fieldLabel : '手术结束日期'
		,anchor : '95%'
	});
	obj.timeOpStt = new Ext.form.TimeField({
	    id : 'timeOpStt'
		,format : 'H:i'
		,increment : 5
		,fieldLabel : '手术开始时间'
		,anchor : '95%'
	});
	obj.timeOpEnd = new Ext.form.TimeField({
	    id : 'timeOpEnd'
		,format : 'H:i'
		,increment : 5
		,fieldLabel : '手术结束时间'
		,anchor : '95%'
	});
	obj.Panel101 = new Ext.Panel({
	    id : 'Panel101'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.comOperRoom
		]
	});
	obj.Panel102 = new Ext.Panel({
	    id : 'Panel102'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.comOrdNo
		]
	});
	obj.Panel103 = new Ext.Panel({
	    id : 'Panel103'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			 obj.timeArrOper
		]
	});
	obj.Panel104 = new Ext.Panel({
	    id : 'Panel104'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.chkIfShift
		]
	});
	obj.Panel105 = new Ext.Panel({
	    id : 'Panel105'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items : [
			obj.comScrubNurse
			,obj.comCirculNurse
		]
	});
	obj.Panel106 = new Ext.Panel({
	    id : 'Panel106'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items : [
		   obj.comShiftScrubNurse
		   ,obj.comShiftCirculNurse
		]
	});
	obj.Panel107 = new Ext.Panel({
	    id : 'Panel107'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items : [
			obj.txtScrubNurseNote
		]
	});
	obj.Panel108 = new Ext.Panel({
	    id : 'Panel108'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items : [
			obj.txtCirculNurseNote
		]
	});
	obj.Panel109 = new Ext.Panel({
	    id : 'Panel109'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items : [
			obj.txtOpReq
			,obj.txtNote
		]
	});
	obj.Panel110 = new Ext.Panel({
	    id : 'Panel110'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateOpStt
		]
	});
	obj.Panel111 = new Ext.Panel({
	    id : 'Panel111'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.timeOpStt
		]
	});
	obj.Panel112 = new Ext.Panel({
	    id : 'Panel112'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateOpEnd
		]
	});
	obj.Panel113 = new Ext.Panel({
	    id : 'Panel113'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.timeOpEnd
		]
	});
	obj.opfPanel1 = new Ext.form.FormPanel({
		id : 'opfPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		//,height : 60
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		     obj.Panel101
			,obj.Panel102
			,obj.Panel103
			,obj.Panel104
		]
	});
	obj.opfPanel2 = new Ext.form.FormPanel({
		id : 'opfPanel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
	     obj.Panel105
		,obj.Panel106
		]
	});
	obj.opfPanel3 = new Ext.form.FormPanel({
		id : 'opfPanel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			 obj.Panel107
			,obj.Panel108
		]
	});
	obj.opfPanel4 = new Ext.form.FormPanel({
		id : 'opfPanel4'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			obj.Panel109
		]
	});
	obj.opfPanel5 = new Ext.form.FormPanel({
		id : 'opfPanel5'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			 obj.Panel110
			,obj.Panel111
			,obj.Panel112
			,obj.Panel113
		]
	});
	
	
	obj.btnOpSave=new Ext.Button({
		id : 'btnOpSave'
		,text : '确认'
		,height:32
		,width:80
	});
	obj.btnOpClose=new Ext.Button({
		id : 'btnOpClose'
		,text : '关闭'
		,height:32
		,width:80
	});
	obj.pnlOpButton1=new Ext.Panel({
		id : 'pnlOpButton1'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items : [  	
		]
	});
	obj.pnlOpButton2=new Ext.Panel({
		id : 'pnlOpButton2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnOpSave		
		]
	});
	obj.pnlOpButton3=new Ext.Panel({
		id : 'pnlOpButton3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnOpClose	
		]
	});
	obj.opOtherPanel1 = new Ext.form.FormPanel({
		id : 'opOtherPanel1'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 40
		,labelAlign : 'right'
		,layout : 'column'
		,items : [    
		]
	});
    obj.opOtherPanel2 = new Ext.form.FormPanel({
		id : 'opOtherPanel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 40
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
	      obj.pnlOpButton1
		 ,obj.pnlOpButton2
		 ,obj.pnlOpButton3
		]
	});
	obj.pnlOpContent=new Ext.Panel({
	 id:'pnlOpContent'
	,layout : 'form'
	,frame : true
	,items:[
		obj.opfPanel1
	   ,obj.opfPanel2
	   ,obj.opfPanel3
	   ,obj.opfPanel4
	   ,obj.opfPanel5
	]
	})
	
	
	
	obj.opPanel = new Ext.Panel({
	    id : 'opPanel'
		,buttonAlign : 'center'
		,title : '手术室填写项目'
		,layout : 'form'
		,frame :true
		,items : [
		obj.pnlOpContent,
		obj.opOtherPanel1,
		obj.opOtherPanel2
		]
	});

   obj.contentTab = new Ext.TabPanel({
	    //renderTo: Ext.getBody()
		 header : true
		,autoScroll:true 
		,deferredRender:false
		,anchor : '95%'
		,activeTab: 0
		,items: [
		     obj.wardPanel
			,obj.anPanel
			,obj.opPanel
		]
	});	
	obj.contentPanel = new Ext.Panel({
	    id : 'contentPanel'
		,buttonAlign : 'center'
		,layout:'fit'
		//,height : 450
		,region : 'center'
		,items : [
		   obj.contentTab
		         ]
	});
	obj.hiddenPanel = new Ext.Panel({
	    id : 'hiddenPanel'
	    ,buttonAlign : 'center'
	    ,region : 'south'
	    ,hidden : true
	    ,items:[	
	    ]
    });

	obj.winScreen = new Ext.Viewport({
	    id : 'winScreen'
		,layout : 'border'
		,items : [
		    obj.admInfPanel
		    ,obj.contentPanel
			,obj.hiddenPanel
			     ]
	});

	InitWinScreenEvent(obj);
	//事件处理
	obj.comAppLoc.on('select',obj.comAppLoc_select,obj);
	obj.btnAdd.on('click',obj.btnAdd_click,obj);
	obj.btnUpdate.on('click',obj.btnUpdate_click,obj);
	obj.listOpName.on('rowclick',obj.listOpName_rowclick, obj)
	obj.btnDelete.on('click',obj.btnDelete_click,obj);
	obj.comOpName.on('select',obj.comOpName_select,obj);
	obj.btnSave.on('click',obj.btnSave_click,obj)
	obj.btnClose.on('click',obj.btnClose_click,obj)
	obj.btnAnSave.on('click',obj.btnSave_click,obj)
	obj.btnAnClose.on('click',obj.btnClose_click,obj)
	obj.btnOpSave.on('click',obj.btnSave_click,obj)
	obj.btnOpClose.on('click',obj.btnClose_click,obj)
	obj.LoadEvent(arguments);
	return obj;

	

}