var dateFormat=tkMakeServerCall("web.DHCClinicCom","GetDateFormat");

function InitWinScreen(){
    var obj = new Object();
	//患者姓名*
	obj.txtPatname = new Ext.form.TextField({
	    id : 'txtPatname'
		,fieldLabel : '患者姓名'
		,labelSeparator: ''
		,anchor :'98%'
	});
	//登记号*
	obj.txtPatRegNo = new Ext.form.TextField({
	    id : 'txtPatRegNo'
		,fieldLabel : '登记号'
		,labelSeparator: ''
		,anchor :'98%'
	});
	//性别*
	obj.txtPatSex = new Ext.form.TextField({
	    id : 'txtPatSex'
		,fieldLabel : '性别'
		,labelSeparator: ''
		,anchor :'90%'
	});
	//年龄*
	obj.txtPatAge = new Ext.form.TextField({
	    id : 'txtPatAge'
		,fieldLabel : '年龄'
		,labelSeparator: ''
		,anchor :'90%'
	});
	// 病人科室*
	obj.txtPatLoc = new Ext.form.TextField({
	    id : 'txtPatLoc'
		,fieldLabel : '病人科室'
		,labelSeparator: ''
		,anchor :'98%'
	});
	//病区*
	obj.txtPatWard = new Ext.form.TextField({
	    id : 'txtPatWard'
		,fieldLabel : '病区'
		,labelSeparator: ''
		,anchor :'98%'
	});
	//床号*
	obj.txtPatBedNo = new Ext.form.TextField({
	    id : 'txtPatBedNo'
		,fieldLabel : '床号'
		,labelSeparator: ''
		,anchor :'90%'
	});
	//费别*
	obj.txtAdmReason = new Ext.form.TextField({
	    id : 'txtAdmReason'
		,fieldLabel : '费别'
		,labelSeparator: ''
		,anchor :'90%'
	});
	//病人密级
	obj.txtPatSecret = new Ext.form.TextField({
	    id : 'txtPatSecret'
		,fieldLabel : '病人密级'
		,labelSeparator: ''
		,anchor :'90%'
	});
	//病人级别*
	obj.txtPatLevel = new Ext.form.TextField({
	    id : 'txtPatLevel'
		,fieldLabel : '病人级别'
		,labelSeparator: ''
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
		,title : '<span style=\'font-size:14px;\'>病人信息</span>'
		,iconCls:'icon-patInfo'
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

/////////////////////////////////////病区填写项目///////////////////////////////////////	
	// 手术室*
	obj.comOperLocationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	/*
	function seltextLocdesc(v,record){
		return record.ctlocDesc.split('-')[1];
	}
	*/
	obj.comOperLocationStore = new Ext.data.Store({
	    proxy : obj.comOperLocationStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctlocId'
		},
		[
			//{name:'ctlocDesc',convert:seltextLocdesc}
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
		,labelSeparator: ''
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comOperLocationStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comOperLocation.getRawValue();
		param.Arg2 ='OUTOP^EMOP'
		param.Arg3 =""
		param.ArgCnt = 3;
	});
	obj.comOperLocationStore.load({})
	
	// 手术资源*
	obj.comOperResourceStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOperResourceStore = new Ext.data.Store({
	    proxy : obj.comOperResourceStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'rowId'
		},
		[
			{name:'resourceDesc',mapping:'resourceDesc'}
			,{name:'rowId',mapping:'rowId'}
			,{name:'asSessTime',mapping:'asSessTime'}
		])
	
	});
	obj.comOperResource = new Ext.form.ComboBox({
	    id : 'comOperResource'
		,store : obj.comOperResourceStore
		,minChars : 1
		,displayField : 'resourceDesc'
		,fieldLabel : '手术资源'
		,labelSeparator: ''
		,valueField : 'rowId'
		,mode:'local'
		,typeAhead: true
		,triggerAction : 'all'
		,anchor : '98%'
	});
	//手术日期*
	obj.dateOper = new Ext.form.DateField({
	    id : 'dateOper'
		,value : new Date()
		,format : dateFormat
		,fieldLabel : '<span style="color:red;">*</span>手术日期'
		,labelSeparator: ''
		,labelWidth:80
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
        ,fieldLabel : '申请医师'
        ,labelSeparator: ''
        ,mode:'remote'
        ,valueField : 'ctcpId'
        ,triggerAction : 'all'
        //,pageSize : 5
        ,disabled : true
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
		,labelSeparator: ''
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 ='INOPDEPT^OUTOPDEPT^EMOPDEPT'
		param.Arg3 =""
		param.ArgCnt = 3;
	});
		
	//申请医师*
    obj.comAppDoc = new Ext.form.TextField({
        id : 'comAppDoc'
    });
	
	//手术时间*
	obj.timeOper = new Ext.form.TimeField({
	    id : 'timeOper'
		,format : 'H:i'
		,increment : 30
		,fieldLabel : '手术时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//是否麻醉*
	obj.chkNeedAnaesthetist = new Ext.form.Checkbox({
	    id : 'chkNeedAnaesthetist'
		,fieldLabel : '麻醉'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//号源信息
	obj.lbNumResource=new Ext.form.Label(
	{
		id:'lbNumResource'
		,text:'号源信息'
		,height:15
		,style:'color:red;font-size:11px'
	})
	
	//号源
	obj.comNumResourceStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comNumResourceStore = new Ext.data.Store({
	    proxy : obj.comNumResourceStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'Id'
		},
		[
		    {name:'Desc',mapping:'Desc'}
			,{name:'Id',mapping:'Id'}
		])
	
	});	
	obj.comNumResource = new Ext.form.ComboBox({
	    id : 'comNumResource'
		,store : obj.comNumResourceStore
		,minChars : 0
		,displayField : 'Desc'
		,fieldLabel : '号源'
		,labelSeparator: ''
		,mode:'remote'
		,valueField : 'Id'
		,triggerAction : 'all'
		//,pageSize : 5
		,anchor : '95%'
	});
	
	//主诉
	obj.txtPatSelfReport = new Ext.form.TextField({
	    id : 'txtPatSelfReport'
		,fieldLabel : '主诉'
		,labelSeparator: ''
		,anchor :'98%'
	});
	//病人电话
	obj.txtPatTele = new Ext.form.TextField({
	    id : 'txtPatTele'
		,fieldLabel : '病人电话'
		,labelSeparator: ''
		,anchor :'95%'
	});

	//来院时间*
	var data=[
        ['1','7:00'],
        ['2','8:00'],
        ['3','9:00'],
        ['4','10:00'],
        ['5','11:00'],
        ['6','12:00'],
        ['7','13:00'],
        ['8','14:00'],
        ['9','15:00'],
        ['10','16:00'],
        ['11','17:00'],
        ['12','18:00'],
        ['13','19:00'],
        ['14','20:00'],
        ['15','21:00']
    ]
    obj.winComRowIdStoreProxy=data;
    obj.winComRowIdStore = new Ext.data.Store({
        proxy: new Ext.data.MemoryProxy(data),
        reader: new Ext.data.ArrayReader({}, 
        [
             {name: 'code'}
            ,{name: 'desc'}
        ])
    });
    obj.winComRowIdStore.load({});
    obj.comeHosTime = new Ext.form.ComboBox({
        id : 'comeHosTime'
        ,minChars : 1
        ,fieldLabel : '<span style="color:red;">*</span>来院时间'
        ,labelSeparator: ''
        ,triggerAction : 'all'
        ,mode:'local'
        ,store : obj.winComRowIdStore
        ,displayField : 'desc'
        ,valueField : 'code'
        ,anchor : '95%'
    });
	
	//备用耗材
	obj.comOpConsumableStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpConsumableStore = new Ext.data.Store({
	    proxy : obj.comOpConsumableStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'incitrRowId'
		},
		[
		    {name:'ancDesc',mapping:'ancDesc'}
			,{name:'count',mapping:'count'}
			,{name:'incitrRowId',mapping:'incitrRowId'}
		])
	
	});
	obj.comOpConsumable = new Ext.ux.form.LovCombo({
	    id : 'comOpConsumable'
		,store : obj.comOpConsumableStore
		,minChars : 1
		,value : ''
		,displayField : 'ancDesc'
		,fieldLabel : '备用耗材'
		,labelSeparator: ''
		,valueField : 'incitrRowId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comOpConsumableStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPStock';
		param.QueryName = 'FindANCStock';
		param.Arg1 = session['LOGON.CTLOCID'];
		param.Arg2 = obj.comOpConsumable.queryStr
		param.ArgCnt = 2;
	});
		
	//耗材说明
	obj.txtstockItemNote = new Ext.form.TextArea({
		id : 'txtstockItemNote'
		,fieldLabel : '耗材说明'
		,labelSeparator: ''
		,anchor : '97%'
		,height:45
		//,autoHeight : true
	});	
	obj.appDodPanel = new Ext.Panel({
		id : 'appDodPanel'
		,hidden:true
		,items:[obj.comAppDoc]
	})
	obj.Panel21 = new Ext.Panel({ //手术间
	    id : 'Panel21'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .35
		,layout : 'form'
		,items : [ 
			obj.comAppLoc
			,obj.comOperLocation 
			
		]
	});	
	obj.Panel22 = new Ext.Panel({ //手术资源，手术日期
	    id : 'Panel22'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.dateOper 
		    ,obj.txtPatTele
		]
	});
	obj.Panel23 = new Ext.Panel({ //有效资源，麻醉
	    id : 'Panel23'
		,buttonAlign : 'center'
		,labelWidth:80
		,columnWidth : .25
		,layout : 'form'
		,items : [
			obj.timeOper
			,obj.comeHosTime
		]
	});
	obj.Panel24 = new Ext.Panel({ //号源，手术时间
	    id : 'Panel24'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth:80
		,layout : 'form'
		,items : [
			obj.chkNeedAnaesthetist
		]
	});
	obj.Panel31 = new Ext.Panel({
	    id : 'Panel31'
		,columnWidth : .6
		,layout : 'form'
		,items : [
			obj.txtPatSelfReport
			,obj.comOpConsumable
		]
	});

	obj.Panel32 = new Ext.Panel({
	    id : 'Panel32'
		,columnWidth : .4
		,layout : 'form'
		,items : [
			obj.txtstockItemNote
		]
	});
	
	obj.fPanel1 = new Ext.form.FormPanel({
	    id : 'fPanel1'
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
	obj.fPanel2 = new Ext.form.FormPanel({
	    id : 'fPanel2'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel31
			,obj.Panel32
			//,obj.Panel33
			//,obj.appDodPanel
		]
	});
	obj.fPanel3 = new Ext.form.FormPanel({
	    id : 'fPanel3'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
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
		,fieldLabel : '<span style="color:red;">*</span>手术医生'
		,labelSeparator: ''
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

	
	//手术分类
	obj.comOpCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOpCatStore = new Ext.data.Store({
	    proxy : obj.comOpCatStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},
		[
		    {name:'ANCOC_Desc',mapping:'ANCOC_Desc'}
			,{name:'ID',mapping:'ID'}
			,{name:'ANCOC_Code',mapping:'ANCOC_Code'}
		])
	
	});
	obj.comOpCat = new Ext.form.ComboBox({
	    id : 'comOpCat'
		,store : obj.comOpCatStore
		,minChars : 1
		,value : ''
		,displayField : 'ANCOC_Desc'
		,fieldLabel : '手术类别'
		,labelSeparator: ''
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '98%'
		
	});
	obj.comOpCatStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPArrangeClinics';
		    param.QueryName = 'FindOperCat';
	    	param.ArgCnt = 0;
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
		,fieldLabel : '<span style="color:red;">*</span>手术名称'
		,labelSeparator: ''
		,valueField : 'rowid'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	/*obj.comOpNameStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPArrangeClinics';
		    param.QueryName = 'FindOPerByCat';
		    param.Arg1 = obj.comOpCat.getValue();
	    	param.ArgCnt = 1;
	    }); */
	obj.comOpNameStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'FindOrcOperation';
		    param.Arg1 =obj.comOpName.getRawValue();
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
		,fieldLabel : '手术级别'
		,labelSeparator: ''
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
		,labelSeparator: ''
		,valueField : 'BLDTPRowId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comOpBladeTypeStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetBladeType';
	    	param.ArgCnt = 0;
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
		,labelSeparator: ''
		,editable:false
		,valueField : 'BODS_RowId'
		,triggerAction : 'all'
		,hideTrigger:false
		,grow:true
		,lazyRender : true
		,hideOnSelect:false
		,anchor : '97%'
	});
	obj.comBodySiteStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
			param.QueryName = 'FindBodySite';
		    param.ArgCnt = 0;
	    });
		

	
	obj.Panel51 = new Ext.Panel({
	    id : 'Panel51'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .7
		,layout : 'form'
		,items : [
		    obj.comOpName
		]
	});
	obj.Panel55 = new Ext.Panel({
	    id : 'Panel55'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .3
		,layout : 'form'
		,items : [
			obj.comBodySite
		]
	});
	
	obj.fPanelOP = new Ext.form.FormPanel({
	    id : 'fPanelOP'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    obj.Panel51
			,obj.Panel55
		]
	});
	obj.Panel52 = new Ext.Panel({
	    id : 'Panel52'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .2
		,layout : 'form'
		,items : [
		    obj.comAnaOpLevel
		]
	});
	obj.Panel53 = new Ext.Panel({
	    id : 'Panel53'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .2
		,layout : 'form'
		,items : [
		    obj.comOpBladeType
		]
	});
	
	obj.txtOpNote = new Ext.form.TextField({
	    id : 'txtOpNote'
		,fieldLabel : '备注'
		,labelSeparator: ''
		,anchor :'95%'
	});
	obj.Panel54 = new Ext.Panel({
	    id : 'Panel54'
		,buttonAlign : 'center'
		,labelWidth:70
		,columnWidth : .3
		,layout : 'form'
		,items : [
		    obj.txtOpNote
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
		//,width : 570
		,anchor : '98%'
		,height : 95
		,frame:true
		,columnLines:true 
		,hideHeaders:false
		,bodyStyle :'overflow-x:hidden;overflow-y:auto'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,columns: [
		           {
		             header : '拟施手术'
                     ,dataIndex: 'operDesc'
					 ,width:150
                   },
				   {
				     header:'手术级别'
					 ,dataIndex: 'opLevelDesc'
					 ,width:60
				   },
				    {
				     header:'切口'
					 ,dataIndex: 'bldTypeDesc'
					 ,width:60
				   },
				     {
				     header:'备注'
					 ,dataIndex: 'operNotes'
					 ,width:100
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
		,labelWidth:10
		//,frame : true
		,items : [
		    obj.listOpName
		]
	});
	obj.Panel61 = new Ext.Panel({
	    id : 'Panel61'
		,buttonAlign : 'center'
		,columnWidth :.7
		,layout : 'form'
		,items : [
		    //obj.listPanel2
			obj.listOpName
		]
	});
		//手术说明
	obj.txtAreaOpMem= new Ext.form.TextArea({
		id : 'txtAreaOpMem'
		,fieldLabel : '手术要求'
		,labelSeparator: ''
		,anchor : '97%'
		,height : 93
	});	
	obj.Panel62 = new Ext.Panel({
	    id : 'Panel62'
		,buttonAlign : 'center'
		,columnWidth :.3
		,layout : 'form'
		,labelWidth:60
		,items : [
		    //obj.listPanel2
			//obj.lbOperNote
			obj.txtAreaOpMem
		]
	});
	
	/*obj.txtAreaOpMem = new Ext.form.TextArea({
	    id : 'txtAreaOpMem'
		,fieldLabel : '手术要求'
		,anchor :'95%'
		,autoHeight : true
	});*/
    obj.btnAdd = new Ext.Button({
	    id : 'btnAdd'
	    ,iconCls : 'icon-add'
		,text : '增加'
		,anchor :'90%'
	});
	obj.btnUpdate = new Ext.Button({
	    id : 'btnUpdate'
	    ,iconCls : 'icon-updateSmall'
		,text : '修改'
		,anchor :'90%'
	});
	obj.btnDelete = new Ext.Button({
	    id : 'btnDelete'
		,text : '删除'
		,iconCls : 'icon-delete'
		,anchor :'90%'
	});
	obj.Panel63 = new Ext.Panel({
	    id : 'Panel63'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:10px'
		,layout : 'form'
		,items : [
			obj.btnAdd
		]
	});
	obj.Panel64 = new Ext.Panel({
	    id : 'Panel64'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,style:'margin-left:5px'
		,items : [
			obj.btnUpdate
		]
	});
	obj.Panel65 = new Ext.Panel({
	    id : 'Panel65'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:5px'
		,layout : 'form'
		,items : [
			obj.btnDelete
		]
	});
	obj.fPanel4 = new Ext.form.FormPanel({
	    id : 'fPanel4'
		,buttonAlign : 'center'
		//,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			obj.Panel52
			,obj.Panel53
			,obj.Panel54
			,obj.Panel63
			,obj.Panel64
			,obj.Panel65
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
			,obj.Panel62
		]
	});
	obj.wPanel2 = new Ext.Panel({
	    id : 'wPanel2'
		,buttonAlign : 'center'
		,height : 250
		,title : '<span style=\'font-size:14px;\'>拟施手术</span>'
		,iconCls:'icon-operInfo'
		,autoScroll : true
		,region : 'center'
		,layout : 'form'
		,frame : true
		,items : [
			obj.fPanelOP 
			,obj.fPanel4
			,obj.fPanel5
		]
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
		,labelSeparator: ''
		,valueField : 'OPPOS_RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comOperPositionStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'GetOperPosition';
	    	param.ArgCnt = 0;
	    });
	/*obj.Panel61 = new Ext.Panel({
	    id : 'Panel61'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .5
		,layout : 'form'
		,items : [
			obj.txtAreaOpMem
		]
	});*/

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
	/*obj.fPanel6 = new Ext.form.FormPanel({
	    id : 'fPanel6'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
		    //obj.Panel61
			//,obj.Panel62
			//,obj.Panel63
		]
	});*/
	
	obj.chkIsolated = new Ext.form.Checkbox({
	    id : 'chkIsolated'
		,fieldLabel : '隔离'
		,cls:'BlueA'
		,labelSeparator: ''
		,anchor : '100%'
	});
	obj.chkIsExCirculation = new Ext.form.Checkbox({
	    id : 'chkIsExCirculation'
		,fieldLabel : '是否体外循环'
		,labelSeparator: ''
		,cls:'BlueA'
		,anchor : '100%'
	});
	obj.chkIsUseSelfBlood = new Ext.form.Checkbox({
	    id : 'chkIsUseSelfBlood'
		,fieldLabel : '自体血回输'
		,labelSeparator: ''
		,cls:'BlueA'
		,anchor : '100%'
	});
	obj.chkIsPrepareBlood = new Ext.form.Checkbox({
	    id : 'chkIsPrepareBlood'
		,fieldLabel : '是否备血'
		,cls:'BlueA'
		,labelSeparator: ''
		,anchor : '100%'
	});

	obj.Panel71 = new Ext.Panel({
	    id : 'Panel71'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.chkIsolated
		]
	});
	obj.Panel72 = new Ext.Panel({
	    id : 'Panel72'
		,buttonAlign : 'center'
		,labelWidth:90
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
		,columnWidth : .2
		//,style:'margin-left:20px;'
		,layout : 'form'
		,items : [
			obj.chkIsUseSelfBlood
		]
	});
	obj.Panel74 = new Ext.Panel({
	    id : 'Panel74'
		,buttonAlign : 'center'
		,labelWidth:80
		//,style:'margin-left:40px;'
		,columnWidth : .2
		,layout : 'form'
		,items : [
			obj.chkIsPrepareBlood
		]
	});
	obj.fPanel7 = new Ext.form.FormPanel({
	    id : 'fPanel7'
	    ,height:30
		,buttonAlign : 'center'
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
		,valueField : 'ord'
		,triggerAction : 'all'
		,anchor : '96%'
	});
	obj.comCheckQuStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.UDHCANOPArrange';
		    param.QueryName = 'checkqu';
	    	param.ArgCnt = 0;
	    });
	obj.txtOther = new Ext.form.TextField({
	    id : 'txtOther'
		,fieldLabel : '其他'
		,labelSeparator: ''
		,anchor :'99%'
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
		,columnWidth : .16
		,labelWidth:40
		,layout : 'form'
		,items : [
			obj.comRPR
		]
	});
	obj.Panel87 = new Ext.Panel({
	    id : 'Panel87'
		,buttonAlign : 'center'
		,labelWidth:40
		,columnWidth :1
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
		,height : 120
		,frame:true
		,region : 'north'
		,layout : 'form'
		,items : [
			obj.fPanel1
			,obj.fPanel2
		]
	});

	///病人须知
	obj.txtPatKnow = new Ext.form.TextArea({
	    id : 'txtPatKnow'
		,fieldLabel : '病人须知'
		,labelSeparator: ''
		,anchor :'98%'
		,height:80
	});
	
	obj.saveTempleteDoc=new Ext.Button({
		id: 'saveTempleteDoc',
		buttonAlign:'center',
		iconCls : 'icon-savepatknow',
		height:32,
		width:140,
		text: '<span style=\'color:blue;font-size:14px;\'>保存病人须知模板</span>'
		//iconCls:'icon-save',
    });
	
	 obj.PanelPatKnow=new Ext.Panel({
	   id:'PanelPatKnow'
	   ,columnWidth : .7
	   ,labelAlign:'right'
	   ,layout:'form' 
	   ,labelWidth:60
	   ,items:
	   [
		obj.txtPatKnow
	   ]
	  })
	 obj.btnSaveTempPanel=new Ext.Panel({
	   id:'btnSaveTempPanel'
	   ,columnWidth : .3
	   ,layout:'form' 
	   ,items:
	   [
			obj.saveTempleteDoc
	   ]
	  })
     obj.btnPanel=new Ext.form.FormPanel({
	   id:'btnPanel'
       ,layout:'column' 
      	,frame:true
		,height : 90
	   ,items:
	   [
	    obj.PanelPatKnow,
		obj.btnSaveTempPanel
	   ]
	})
	//-------------
		obj.btnSave = new Ext.Button({
	    id : 'btnSave'
	    ,iconCls : 'icon-save'
		,text : '确认'
		,height:32
		,width:80
	});
	obj.btnClose = new Ext.Button({
	    id : 'btnClose'
		,iconCls : 'icon-close'
		,text : '关闭'
		,height:32
		,width:80
	});

	obj.btnSavePanel=new Ext.Panel({
	   id:'btnSavePanel'
	   ,columnWidth : .2
	   ,layout:'form' 
	   ,items:
	   [
			obj.btnSave
	   ]
	  })
	  
	  obj.btnClosePanel=new Ext.Panel({
	   id:'btnClosePanel'
	   ,layout:'form' 
	   ,columnWidth : .2
	   ,items:
	   [
	    obj.btnClose
	   ]
	  })

	 obj.btnSpaceO1=new Ext.Panel({
	   id:'btnSpaceO1'
	   ,columnWidth : .1
	   ,width:280
	   ,items:
	   [
	   ]
	  })

	  obj.btnSpaceO2=new Ext.Panel({
	   id:'btnSpaceO2'
	   ,columnWidth : .1
	   ,width:80
	   ,items:
	   [
	   ]
	  })
	  obj.btnPanel2=new Ext.form.FormPanel({
	   id:'btnPanel2'
       ,layout:'column'   
      	,frame:true
		,height : 40
		,items:
		[
		]
	   ,buttons:
	   [
	    obj.btnSavePanel
	     ,obj.btnSpaceO2
		,obj.btnClosePanel
		,obj.btnSpaceO1
	   ]
	})
	obj.wPanel3 = new Ext.Panel({
	    id : 'wPanel3'
		,buttonAlign : 'center'
		,height :250
		,frame:true
		,region : 'south'
		,layout : 'form'
		,style:'margin-top:5px'
		,items : [
			 //obj.fPanel6
			obj.fPanel7
			,obj.examPanel
			,obj.btnPanel
			,obj.btnPanel2
		]
	});
	
	obj.tb=new Ext.Toolbar(
    {
		text:'newbar'
		,height:35
		,iconCls:'new-topic'
        ,items:[
			//obj.saveTempleteDoc
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
	
	//////////////////////////////麻醉科填写项目///////////////////////////////////////////
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '90%'
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
			//obj.comAnaMethod by lyn 门诊麻醉方式放到手术室填写项目中
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
	
	////////////////////////手术室填写项目///////////////////////
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.chkIfShift = new Ext.form.Checkbox({
	    id : 'chkIfShift'
		,fieldLabel : '交班'
		,labelSeparator: ''
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
		,labelSeparator: ''
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
		,labelSeparator: ''
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
	obj.comCirculNurse = new Ext.form.ComboBox({
	    id : 'comCirculNurse'
		,store : obj.comCirculNurseStore
		,minChars : 1
		,value : ''
		,displayField : 'ctcpDesc'
		,fieldLabel : '巡回护士'
		,labelSeparator: ''
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '96.5%'
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
		,labelSeparator: ''
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,anchor : '100%'
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
		,labelSeparator: ''
		,anchor :'95%'
	});
	obj.txtCirculNurseNote = new Ext.form.TextField({
	    id : 'txtCirculNurseNote'
		,fieldLabel : '巡回护士备注'
		,labelSeparator: ''
		,anchor :'95%'
	});
	obj.txtOpReq = new Ext.form.TextArea({
	    id : 'txtOpReq'
		,anchor :'98.5%'
		,fieldLabel : '备注'
		,labelSeparator: ''
		,autoHeight : true
	});
	obj.txtNote = new Ext.form.TextArea({
	    id : 'txtNote'
		,anchor :'98.5%'
		,fieldLabel : '注意事项'
		,labelSeparator: ''
	});
	obj.dateOpStt = new Ext.form.DateField({
	    id : 'dateOpStt'
		,value : obj.dateOper.getRawValue()
		,format : dateFormat
		,fieldLabel : '手术开始日期'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.dateOpEnd = new Ext.form.DateField({
	    id : 'dateOpEnd'
		,value : obj.dateOper.getRawValue()
		,format : dateFormat
		,fieldLabel : '手术结束日期'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.timeOpStt = new Ext.form.TimeField({
	    id : 'timeOpStt'
		,format : 'H:i'
		,increment : 5
		,fieldLabel : '手术开始时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.timeOpEnd = new Ext.form.TimeField({
	    id : 'timeOpEnd'
		,format : 'H:i'
		,increment : 5
		,fieldLabel : '手术结束时间'
		,labelSeparator: ''
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
		,columnWidth : .33
		,layout : 'form'
		,items : [
			//obj.comScrubNurse
			obj.comCirculNurse
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
		,columnWidth : 1
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
	///主刀医生 add by lyn  门诊
	obj.opSurgeonPanel= new Ext.Panel({
	    id : 'opSurgeonPanel'
		,buttonAlign : 'center'
		,columnWidth : .33
		,layout : 'form'
		,items : [
		    obj.comSurgeon
		]
	});
	///麻醉方式 add by lyn  门诊
	obj.opAnaMethodPanel = new Ext.Panel({
	    id : 'opAnaMethodPanel'
		,buttonAlign : 'center'
		,columnWidth : .34
		,layout : 'form'
		,items : [
			obj.comAnaMethod
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
	     //obj.Panel105  
		//,obj.Panel106 comment by lyn 门诊只有一个护士
		]
	});
	obj.opfPanel3 = new Ext.form.FormPanel({
		id : 'opfPanel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'column'
		,items : [
			// obj.Panel107
			//,obj.Panel108
			 obj.opSurgeonPanel
			,obj.opAnaMethodPanel
			,obj.Panel105
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
		,labelWidth : 100
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
		,iconCls : 'icon-save'
		,height:32
		,width:80
	});
	obj.btnOpClose=new Ext.Button({
		id : 'btnOpClose'
		,text : '关闭'
		,iconCls : 'icon-close'
		,height:32
		,width:80
	});
	obj.pnlOpButton1=new Ext.Panel({
		id : 'pnlOpButton1'
		,columnWidth : .1
		,width:280
		,items : [  	
		]
	});
	 obj.pnlOpButton4=new Ext.Panel({
	   id:'pnlOpButton4'
	   ,columnWidth : .1
	   ,width:80
	   ,items:
	   [
	   ]
	  })
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
    obj.opOtherPanel2 = new Ext.Panel({
		id : 'opOtherPanel2'
		,layout : 'column'
		 ,align:'center'
		,buttons : [
		 obj.pnlOpButton2
		 ,obj.pnlOpButton4
		 ,obj.pnlOpButton3
	     , obj.pnlOpButton1
		]
	});
	obj.pnlOpContent=new Ext.Panel({
	 id:'pnlOpContent'
	,layout : 'form'
	,frame : true
	,items:[
		//obj.opfPanel1
	   obj.opfPanel2
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
		//obj.opOtherPanel1,
		obj.opOtherPanel2
		]
	});

   obj.contentTab = new Ext.TabPanel({
		 header : true
		,autoScroll:true 
		,deferredRender:false
		,anchor : '95%'
		,activeTab: 0
		,items: [
		     obj.wardPanel
			//,obj.anPanel
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

	obj.comOperResourceStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrangeClinics';
			param.QueryName = 'FindOpResource';
			param.Arg1 = obj.comOperLocation.getValue();
			param.Arg2 = obj.dateOper.getValue();
			param.ArgCnt = 2;
		});
	obj.comOperResourceStore.load({});
	
	obj.comNumResourceStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrangeClinics';
			param.QueryName = 'FindNumResource';
			param.Arg1 = obj.comOperResource.getValue();
			param.ArgCnt = 1;
		});
	obj.comNumResourceStore.load({})
	
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
	//obj.comOperLocation.on('select',obj.comOperLocation_select,obj); (暂未使用)
	//obj.comOperResource.on('select',obj.comOperResource_select,obj); (暂未使用)
	obj.comOpCat.on('select',obj.comOpCat_select,obj);
	//obj.comNumResource.on('select',obj.comNumResource_select,obj); (暂未使用)
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
	//obj.dateOper.on('select',obj.dateOper_select,obj) (暂未使用)
	obj.saveTempleteDoc.on('click',obj.saveTempleteDoc_click,obj);
	obj.LoadEvent(arguments);
	return obj;

	

}