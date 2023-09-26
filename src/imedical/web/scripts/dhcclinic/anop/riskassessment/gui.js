function InitViewScreen(){
    var obj=new Object();
    //病人姓名
    obj.txtPatname=new Ext.form.TextField({
	    id:'txtPatname'
	    ,fieldLabel:'姓名'
	    ,labelSeparator: ''
	    ,anchor:'98%'
    });
    //性别
    obj.txtPatSex=new Ext.form.TextField({
	    id:'txtPatSex'
	    ,fieldLabel:'性别'
	    ,labelSeparator: ''
	    ,anchor:'95%'
    });
    //年龄
    obj.txtPatAge=new Ext.form.TextField({
	    id:'txtPatAge'
	    ,fieldLabel:'年龄'
	    ,labelSeparator: ''
	    ,anchor:'90%'
    });
    //科别
    obj.txtPatCtloc=new Ext.form.TextField({
	    id:'txtPatCtloc'
	    ,fieldLabel:'科别'
	    ,labelSeparator: ''
	    ,anchor:'95%'
    });
    //床号
    obj.txtPatBedNo=new Ext.form.TextField({
	    id:'txtPatBedNo'
	    ,fieldLabel:'床号'
	    ,labelSeparator: ''
	    ,anchor:'90%'
    });
    //住院号
    obj.txtMedCareNo=new Ext.form.TextField({
	    id:'txtMedCareNo'
	    ,fieldLabel:'住院号'
	    ,labelSeparator: ''
	    ,anchor:'95%'
    });
    obj.Panel11=new Ext.Panel({
	    id:'Panel11'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.15
	    ,layout:'form'
	    ,items:[
	        obj.txtPatname
	    ]
    });
    obj.Panel12=new Ext.Panel({
	    id:'Panel12'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.1
	    ,layout:'form'
	    ,items:[
	        obj.txtPatSex
	    ]
    });
    obj.Panel13=new Ext.Panel({
	    id:'Panel13'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.1
	    ,layout:'form'
	    ,items:[
	        obj.txtPatAge
	    ]
    });
    obj.Panel14=new Ext.Panel({
	    id:'Panel14'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:50
	    ,columnWidth:.25
	    ,layout:'form'
	    ,items:[
	        obj.txtPatCtloc
	    ]
    });
    obj.Panel15=new Ext.Panel({
	    id:'Panel15'
	    ,buttonAlign:'center'
	    ,labelAlign:'right'
	    ,labelWidth:40
	    ,columnWidth:.15
	    ,layout:'form'
	    ,items:[
	        obj.txtPatBedNo
	    ]
    });
	obj.Panel16=new Ext.Panel({
		id:'Panel16'
		,buttonAlign:'center'
		,labelAlign:'right'
		,labelWidth:60
		,columnWidth:.15
		,layout:'form'
		,items:[
		    obj. txtMedCareNo
		]
	});
	obj.admInfPanel=new Ext.form.FormPanel({
		id:'admInfPanel'
		,buttonAlign:'center'
		,labelWidth:80
		,title:'<span style=\'font-size:14px;\'>手术风险评估</span>'
		,labelAlign:'center'
		,iconCls:'icon-safetycheck'
		//,region:'north'
		,layout:'column'
		,height:68
		,frame:true
		,items:[
		     obj.Panel11
		    ,obj.Panel12
		    ,obj.Panel13
		    ,obj.Panel14
		    ,obj.Panel15
		    ,obj.Panel16
		 ]
	});
	//拟施手术名称
	obj.patOpNameStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url:ExtToolSetting.RunQueryPageURL
	}));
	obj.patOpNameStore=new Ext.data.Store({
		proxy:obj.patOpNameStoreProxy
		,reader:new Ext.data.JsonReader({
			root:'record'
			,totalProperty:'total'
			,idProperty:'rowid'
		},
		[
		     {name:'OPTypeDes',mapping:'OPTypeDes'}
			,{name:'rowid',mapping:'rowid'}
			,{name:'OPCategory',mapping:'OPCategory'}
		])
	});
	obj.patOpName=new Ext.form.ComboBox({
		id:'patOpName'
		,store:obj.patOpNameStore
		,minChars:1
		,value:''
		,fieldLabel:'拟施手术名称'
		,labelSeparator: ''
		,displayField:'OPTypeDes'
		,valueField:'rowid'
		,triggerAction:'all'
		,anchor:'94%'
	});
	obj.patOpNameStoreProxy.on('beforeload',function(objProxy,param){
		param.ClassName='web.UDHCANOPArrange';
		param.QueryName='FindOrcOperation';
		param.Arg1=obj.patOpName.getRawValue();
		param.Arg2=obj.opDoc.getValue;
		param.ArgCnt=2;
	});
	
	
	obj.fPanel1=new Ext.Panel({
		id:'fPanel1'
		,buttonAlign:'center'
		,labelWidth:100
		,columnWidth:.4
		,layout:'form'
		,items:[
		     obj.patOpName
		]
	});
	obj.preOPPanel=new Ext.form.FormPanel({
		id:'preOPPanel'
		,buttonAlign:'center'
		,title:'<span style=\'font-size:14px;\'>手术信息</span>'
		,iconCls:'icon-operInfo'
		,labelAlign:'right'
		,layout:'column'
		,height:65
		,frame:true
		,items:[
		     obj.fPanel1
		 ]
	});
	
	//手术切口清洁度
	obj.opBladeTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opBladeTypeStore = new Ext.data.Store({
	    proxy : obj.opBladeTypeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'TypeId'
		},
		[    
		    {name:'TypeId',mapping:'TypeId'}
			,{name:'TypeDesc',mapping:'TypeDesc'}
			,{name:'TypeValue',mapping:'TypeValue'}
		])
	
	});
	//20160922+yl
	obj.opBladeType = new Ext.form.ComboBox({
	    id : 'opBladeType'
		,store : obj.opBladeTypeStore
		,minChars : 1
		,displayField : 'TypeDesc'
		,fieldLabel : '手术切口清洁度'
		,labelSeparator: ''
		,valueField : 'TypeId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.opBladeTypeStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPRiskAssessment';
		    param.QueryName = 'OPIncisionType';
	    	param.ArgCnt = 0;
	    });
	
	obj.opBladeTypelabel=new Ext.form.Label(
	{
		id:'opBladeTypelabel'
		,width:420
		,html:'<font color="red"><strong>I 类手术切口: 手术无污染; 手术切口周边无炎症; 患者没有进行气道、食道或尿道插管; 患者没有意识障碍;<br></strong></font>'
	});
	obj.opBladeTypelabel2=new Ext.form.Label(
	{
		id:'opBladeTypelabel2'
		,width:420
		,html:'<font color="red"><strong> II 类手术切口: 上、下呼吸道,上、下消化道,泌尿生殖道或经以上器官的手术; 患者进行气道、食道或尿道插管; 患者病情稳定; 行胆囊、阴道、阑尾、耳鼻手术的患者;<br></strong></font>'
	});
	obj.opBladeTypelabel3=new Ext.form.Label(
	{
		id:'opBladeTypelabel3'
		,width:420
		,html:'<font color="red"><strong> III 类手术切口: 开放、新鲜且不干净的伤口,前次手术后感染的切口; 手术中需采取消毒措施的切口;<br></strong></font>'
	});
	obj.opBladeTypelabel4=new Ext.form.Label(
	{
		id:'opBladeTypelabel4'
		,width:420
		,html:'<font color="red"><strong> IV 类手术切口: 严重的外伤,手术切口有炎症、组织坏死,或有内脏引流管;</strong></font>'
	});
	obj.opDocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opDocStore = new Ext.data.Store({
	    proxy : obj.opDocStoreProxy
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
	obj.opDoc = new Ext.form.ComboBox({
	    id : 'opDoc'
		,store : obj.opDocStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '手术医生'
		,labelSeparator: ''
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '95%'
		,hidden:true
		,hideLabel:true
	});
	obj.opDocStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = obj.opDoc.getRawValue();
		    param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT'; 
	    	param.Arg3 = ""
			param.Arg4 = '';
			param.Arg5 = '';
			param.Arg6 = 'Y'; 
			param.Arg7 = 'Y';
	    	param.ArgCnt = 7;
	    });
	
	obj.Panel321 = new Ext.Panel({
	    id : 'Panel321'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,labelWidth:100
		,width:450
		,columnWidth : .35
		,layout : 'form'
		,items : [
			obj.opBladeType
			,obj.opBladeTypelabel
			,obj.opBladeTypelabel2
			,obj.opBladeTypelabel3
			,obj.opBladeTypelabel4
			,obj.opDoc
		]
	});
	
	obj.ASAClassStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ASAClassStore = new Ext.data.Store({
	    proxy : obj.ASAClassStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'TypeId'
		},
		[    
		    {name:'TypeId',mapping:'TypeId'}
			,{name:'TypeDesc',mapping:'TypeDesc'}
			,{name:'TypeValue',mapping:'TypeValue'}
		])
	
	});

	obj.ASAClass = new Ext.form.ComboBox({
	    id : 'ASAClass'
		,store : obj.ASAClassStore
		,minChars : 1
		,displayField : 'TypeDesc'
		,fieldLabel : '麻醉分级(ASA分级)'
		,labelSeparator: ''
		,valueField : 'TypeId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.ASAClassStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPRiskAssessment';
		    param.QueryName = 'OPASAClass';
	    	param.ArgCnt = 0;
	    });
	/*
	obj.ASAClasslabel=new Ext.form.Label(
	{
		id:'ASAClasslabel'
		,html:'<font color="red"><strong style="padding:5px">P1：正常的患者；除局部病变外，无系统性病变<br>P2：患者有轻微的临床症状；有轻度或中度系统性疾病<br>
		P3：有严重系统性疾病，日常活动受限，但未丧失工作能力<br>
		P4：有严重系统性疾病，已丧失工作能力，威胁生命安全<br>
		P5：病情危重，生命难以维持的濒死病人<br>
		P6：脑死亡的患者</strong></font>'
	});
	*/
	obj.ASAClasslabel1=new Ext.form.Label(
	{
		id:'ASAClasslabel1'
		,html:'<font color="red">P1: 正常的患者:除局部病变外,无系统性病变;<br></font>'
	});
	obj.ASAClasslabel2=new Ext.form.Label(
	{
		id:'ASAClasslabel2'
		,html:'<font color="red">P2: 患者有轻微的临床症状:有轻度或中度系统性疾病;<br></font>'
	});
	obj.ASAClasslabel3=new Ext.form.Label(
	{
		id:'ASAClasslabel3'
		,html:'<font color="red">P3: 有严重系统性疾病,日常活动受限,但未丧失工作能力;<br></font>'
	});
	obj.ASAClasslabel4=new Ext.form.Label(
	{
		id:'ASAClasslabel4'
		,html:'<font color="red">P4: 有严重系统性疾病,已丧失工作能力,威胁生命安全;<br></font>'
	});
	obj.ASAClasslabel5=new Ext.form.Label(
	{
		id:'ASAClasslabel5'
		,html:'<font color="red">P5: 病情危重,生命难以维持的濒死病人;<br></font>'
	});
	obj.ASAClasslabel6=new Ext.form.Label(
	{
		id:'ASAClasslabel6'
		,html:'<font color="red">P6: 脑死亡的患者;</font>'
	});
	obj.ASAClasslabel = new Ext.Panel({
	    id : 'ASAClasslabel'
		,layout : 'form'
		,width:350
		,style:"margin-left:17px"
		,items : [
			obj.ASAClasslabel1
			,obj.ASAClasslabel2
			,obj.ASAClasslabel3
			,obj.ASAClasslabel4
			,obj.ASAClasslabel5
			,obj.ASAClasslabel6
		]
	});
	
	obj.OpTimesStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OpTimesStore = new Ext.data.Store({
	    proxy : obj.OpTimesStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[    
		    {name:'Desc',mapping:'Desc'}
			,{name:'Id',mapping:'Id'}
			,{name:'Value',mapping:'Value'}
		])
	
	});

	obj.OpTimes = new Ext.form.ComboBox({
	    id : 'OpTimes'
		,store : obj.OpTimesStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '手术持续时间'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.OpTimesStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPRiskAssessment';
		    param.QueryName = 'OpTimes';
	    	param.ArgCnt = 0;
	    });
	/*
	obj.OpTimeslabel=new Ext.form.Label(
	{
		id:'OpTimeslabel'
		,html:'<font color="red"><strong>T1：手术在3小时内完成<br>T2：完成手术超过3小时</strong></font>'
	});
	*/
	obj.OpTimeslabel1=new Ext.form.Label(
	{
		id:'OpTimeslabel1'
		,html:'<font color="red"><strong>T1: 手术在3小时内完成;</strong><br></font>'
	});
	obj.OpTimeslabel2=new Ext.form.Label(
	{
		id:'OpTimeslabel2'
		,html:'<font color="red"><strong>T2: 完成手术超过3小时;</strong><br></font>'
	});
	obj.OpTimeslabel = new Ext.Panel({
	    id : 'OpTimeslabel'
		,layout : 'form'
		,width:250
		,style:"margin-left:7px"
		,items : [
			obj.OpTimeslabel1
			,obj.OpTimeslabel2
		]
	});
	//手术类别
	obj.comOPTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOPTypeStore = new Ext.data.Store({
	    proxy : obj.comOPTypeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[
		    {name: 'checked', mapping : 'checked'}
		    ,{name:'Desc',mapping:'Desc'}
			,{name:'Id',mapping:'Id'}
		])
	
	});

	 obj.comOPType = new Ext.ux.form.LovCombo({
	    id : 'comOPType'
		,store : obj.comOPTypeStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '手术类别'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,hideTrigger:false
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,anchor : '98%'
		,pageSize : 20
	});
	obj.comOPTypeStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPRiskAssessment';
		    param.QueryName = 'GetOPType';
	    	param.ArgCnt = 0;
	    });
	/*
	obj.comOPTypelabel=new Ext.form.Label(
	{
		id:'comOPTypelabel'
		,html:'<font color="red"><strong>1：浅层组织手术<br>2：深部组织手术<br>3：器官手术<br>4：腔隙手术</strong></font>'
	});
	*/
	obj.comOPTypelabel1=new Ext.form.Label(
	{
		id:'comOPTypelabel1'
		,html:'<font color="red"><strong>1: 浅层组织手术;</strong><br></font>'
	});
	obj.comOPTypelabel2=new Ext.form.Label(
	{
		id:'comOPTypelabel2'
		,html:'<font color="red"><strong>2: 深部组织手术;</strong><br></font>'
	});

	obj.comOPTypelabel3=new Ext.form.Label(
	{
		id:'comOPTypelabel3'
		,html:'<font color="red"><strong>3: 器官手术;</strong><br></font>'
	});
	obj.comOPTypelabel4=new Ext.form.Label(
	{
		id:'comOPTypelabel4'
		,html:'<font color="red"><strong>4: 腔隙手术;</strong><br></font>'
	});
	obj.comOPTypelabel = new Ext.Panel({
	    id : 'comOPTypelabel'
		,layout : 'form'
		,width:120
		,style:"margin-left:7px"
		,items : [
			obj.comOPTypelabel1
			,obj.comOPTypelabel2
			,obj.comOPTypelabel3
			,obj.comOPTypelabel4
		]
	});

	obj.Panel323 = new Ext.Panel({
	    id : 'Panel323'
		,labelAlign : 'right'
		,labelWidth:90
		,style:"margin-left:20px"
		,columnWidth : .3
		,layout : 'form'
		,items : [
			obj.OpTimes
			,obj.OpTimeslabel
			,obj.comOPType
		    ,obj.comOPTypelabel
		]
	});
	
	//切口愈合与感染情况
	obj.InfectedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.InfectedStore = new Ext.data.Store({
	    proxy : obj.InfectedStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[    
		    {name:'Id',mapping:'Id'}
			,{name:'Desc',mapping:'Desc'}
		])
	
	});

	obj.Infected = new Ext.form.ComboBox({
	    id : 'Infected'
		,store : obj.InfectedStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '切口愈合与感染情况'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.InfectedStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPRiskAssessment';
		    param.QueryName = 'GetInfected';
	    	param.ArgCnt = 0;
	    });
	
		obj.Panel322 = new Ext.Panel({
	    id : 'Panel322'
		,labelAlign : 'right'
		,labelWidth:140
		,columnWidth : .35
		,style:"margin-left:10px"
		,layout : 'form'
		,items : [
			obj.ASAClass
			,obj.ASAClasslabel
			,obj.Infected
		]
	});

	obj.fPanel301=new Ext.Panel({
		id:'fPanel301'
		,buttonAlign:'center'
		,layout:'column'
		,items:[
		    obj.Panel321
		    ,obj.Panel322
		    ,obj.Panel323
		]
	});
	
	obj.OPSurgeonPanel=new Ext.form.FormPanel({
		id:'OPSurgeonPanel'
		,buttonAlign:'center'
		,labelWidth:80
		,title:'<span style=\'font-size:14px;\'>手术风险评估项目</span>'
		,iconCls:'icon-safetycheckitem'
		,labelAlign:'center'
		//,region:'north'
		//,layout:'border'
		,height:265
		,frame:true
		,items:[
		         obj.fPanel301
		 ]
	}); 
	
	//手术医生签名
	obj.opDocSignStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opDocSignStore = new Ext.data.Store({
	    proxy : obj.opDocSignStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctcpId'
		},
		[
			{name:'tOperationDoc',mapping:'tOperationDoc'}
			,{name:'tOperationDocCat',mapping:'tOperationDocCat'}
			,{name:'tDocId',mapping:'tDocId'}
		])
	
	});
	obj.opDocSign = new Ext.form.ComboBox({
	    id : 'opDocSign'
		,store : obj.opDocSignStore
		,minChars : 1
		,value : ''
		,displayField : 'tOperationDoc'
		,fieldLabel : '手术医生签名'
		,labelSeparator: ''
		,valueField : 'tDocId'
		,triggerAction : 'all'
		,anchor : '85%'
	});
	obj.opDocSignStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANCDocOperation';
		    param.QueryName = 'FindOperationDoc'; 
	    	param.Arg1 = obj.txtPatCtloc.getValue();
		    param.ArgCnt = 1;
	    });
	
	obj.Panel325 = new Ext.Panel({
	    id : 'Panel325'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,labelWidth:120
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.opDocSign
		]
	});
	
    //麻醉医师签名
    obj.anDocSignStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.anDocSignStore = new Ext.data.Store({
	    proxy : obj.anDocSignStoreProxy
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

	obj.anDocSign = new Ext.form.ComboBox({
	    id : 'anDocSign'
		,store : obj.anDocSignStore
		,minChars : 1
		,displayField : 'ctcpDesc'
		,fieldLabel : '麻醉医师签名'
		,labelSeparator: ''
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '85%'
	});
	obj.anDocSignStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = '';
		    param.Arg2 = 'AN^OUTAN^EMAN'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'Y';
	    	param.ArgCnt = 5;
	    });
	
	obj.Panel326 = new Ext.Panel({
	    id : 'Panel326'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,labelWidth:120
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.anDocSign
		]
	});
	
	//巡回护士签名
	obj.circleNurseSignStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.circleNurseSignStore = new Ext.data.Store({
	    proxy : obj.circleNurseSignStoreProxy
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
	obj.circleNurseSign = new Ext.ux.form.LovCombo({
	    id : 'circleNurseSign'
		,store : obj.circleNurseSignStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '巡回护士签名'
		,labelSeparator: ''
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '85%'
	});
	obj.circleNurseSignStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindCtcp';
		    param.Arg1 = '';
		    param.Arg2 = 'OP^OUTOP^EMOP'; 
			param.Arg3 = '';
			param.Arg4 = '';
			param.Arg5 = 'N';
	    	param.ArgCnt = 5;
	    });
	
	obj.Panel327 = new Ext.Panel({
	    id : 'Panel327'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,labelWidth:120
		,columnWidth : .20
		,layout : 'form'
		,items : [
			obj.circleNurseSign
		]
	});
	
	obj.fPanel302=new Ext.Panel({
		id:'fPanel302'
		,buttonAlign:'center'
		,layout:'column'
		,items:[
		    obj.Panel325
		    ,obj.Panel326
		    ,obj.Panel327
		]
	});
	
	obj.PostOPCarePanel=new Ext.form.FormPanel({
		id:'PostOPCarePanel'
		,buttonAlign:'center'
		,labelWidth:80
		,iconCls:'icon-buttonshow'
		,title:'<span style=\'font-size:14px;\'>医护人员签名</span>'
		,iconCls:'icon-sign'
		,labelAlign:'center'
		//,region:'north'
		,layout:'form'
		,height:65
		,frame:true
		,items:[
		         obj.fPanel302
		 ]
	});  
	
	obj.Infectedscore = new Ext.form.TextField({
	    id : 'Infectedscore'
		,fieldLabel : '手术切口清洁度(分)'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.Panel331 = new Ext.Panel({
	    id : 'Panel331'
		,buttonAlign : 'center'
		,labelWidth:130
		,labelAlign:'right'
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.Infectedscore
		]
	});
	
	obj.ASAscore = new Ext.form.TextField({
	    id : 'ASAscore'
		,fieldLabel : '<span style="color:red;">+</span>麻醉ASA分级(分)'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.Panel332 = new Ext.Panel({
	    id : 'Panel332'
		,buttonAlign : 'center'
		,labelWidth:130
		,labelAlign:'right'
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.ASAscore
		]
	});
	
	obj.OpTimesScore = new Ext.form.TextField({
	    id : 'OpTimesScore'
		,fieldLabel : '<span style="color:red;">+</span>手术持续时间(分)'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.Panel333 = new Ext.Panel({
	    id : 'Panel333'
		,buttonAlign : 'center'
		,labelWidth:130
		,labelAlign:'right'
		,columnWidth : .15
		,layout : 'form'
		,items : [
			obj.OpTimesScore
		]
	});
	
	obj.SumScore = new Ext.form.TextField({
	    id : 'SumScore'
		,fieldLabel : '<span style="color:red;">=</span>总分'
		,labelSeparator: ''
		,anchor : '70%'
	});
	obj.Panel334 = new Ext.Panel({
	    id : 'Panel334'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .10
		,layout : 'form'
		,items : [
			obj.SumScore
		]
	});
	
	obj. NNISRate = new Ext.form.TextField({
	    id : 'NNISRate'
		,fieldLabel : 'NNIS级数'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel335 = new Ext.Panel({
	    id : 'Panel335'
		,buttonAlign : 'center'
		,labelWidth:70
		,labelAlign:'right'
		,columnWidth : .18
		,layout : 'form'
		,items : [
			obj.NNISRate
		]
	});
	
	obj.fPanel303=new Ext.Panel({
		id:'fPanel308'
		,buttonAlign:'center'
		,layout:'column'
		,items:[
		    obj.Panel331
		    ,obj.Panel332
		    ,obj.Panel333
		    ,obj.Panel334
		    ,obj.Panel335
		]
	}); 	
	 
	obj.opscorePanel=new Ext.form.FormPanel({
		id:'opscorePanel'
		,buttonAlign:'center'
		,labelWidth:80
		,title:'<span style=\'font-size:14px;\'>手术风险评分</span>'
		,iconCls:'icon-riskscore'
		,labelAlign:'center'
		//,region:'north'
		,layout:'form'
		,height:65
		,frame:true
		,items:[
		     obj.fPanel303
		 ]
	});

	obj.btnSave=new Ext.Button({
		id : 'btnSave'
		,text : '确认'
		,iconCls : 'icon-save'
		,height:32
		,width:120
	});
	obj.btnClose=new Ext.Button({
		id : 'btnClose'
		,text : '关闭'
		,iconCls : 'icon-close'
		,height:32
		,width:120
	});
	obj.btnPrint=new Ext.Button({
		id : 'btnPrint'
		,text : '打印'
		,iconCls : 'icon-print'
		,height:32
		,width:120
	});

	obj.pnlButton1=new Ext.Panel({
		id : 'pnlButton1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnSave		
		]
	});
	obj.pnlButton2=new Ext.Panel({
		id : 'pnlButton2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnClose	
		]
	});
	obj.pnlButton3=new Ext.Panel({
		id : 'pnlButton3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items : [  
         obj.btnPrint	
		]
	});
		obj.pnlButtonS1=new Ext.Panel({
		id : 'pnlButtonS1'
		,buttonAlign : 'center'
		,columnWidth : .1
		,width:100
		,layout : 'form'
		,items : [  
		]
	});
	obj.pnlButtonS2=new Ext.Panel({
		id : 'pnlButtonS2'
		,buttonAlign : 'center'
		,columnWidth : .1
		,width:100
		,layout : 'form'
		,items : [  
		]
	});
	obj.pnlButtonS3=new Ext.Panel({
		id : 'pnlButtonS3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,width:60
		,layout : 'form'
		,items : [  
		]
	});
	obj.fPanel304=new Ext.Panel({
		id:'fPanel304'
		,buttonAlign:'center'
		,layout:'column'
		,buttons:[
		      obj.pnlButton1
		      ,obj.pnlButtonS1
		      //,obj.pnlButton3
		      ,obj.pnlButtonS2
		      ,obj.pnlButton2
		      ,obj.pnlButtonS3
		]
	});
	
	obj.OPCareNurseSignaturePanel=new Ext.form.FormPanel({
		id:'OPCareNurseSignaturePanel'
		,buttonAlign:'center'
		,labelWidth:80
		,labelAlign:'center'
		//,region:'north'
		,layout:'form'
		,height:100
		,frame:true
		,items:[
		     obj.fPanel304
		 ]
	});
	
	obj.ViewScreen=new Ext.Viewport({
		id:'ViewScreen'
		,autoScroll:true
		,layout:'form'
		,items:[
		    obj.admInfPanel
		    ,obj.preOPPanel
		    ,obj.OPSurgeonPanel
		    ,obj.PostOPCarePanel
		    ,obj.opscorePanel
		    ,obj.OPCareNurseSignaturePanel
		]
	});
	InitViewScreenEvent(obj);
	
	obj.btnSave.on('click',obj.btnSave_click,obj)
	obj.btnClose.on('click',obj.btnClose_click,obj)
	obj.btnPrint.on('click',obj.btnPrint_click,obj)
	obj.opBladeType.on('select',obj.opBladeType_select,obj)
	obj.ASAClass.on('select',obj.ASAClass_select,obj)
	obj.OpTimes.on('select',obj.OpTimes_select,obj)
	obj.LoadEvent(arguments);
	return obj;
}