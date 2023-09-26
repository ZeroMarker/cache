function InitViewScreen(){
	var obj = new Object();
	//anPatInfoCheck^anopMethodCheck^anopSiteCheck^opKnowCheck^anKnowCheck^anSafeCheck

	//anPatInfoCheck
	//anopMethodCheck
	obj.anopMethodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.anopMethodStore= new Ext.data.Store({
		proxy: obj.anopMethodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anopMethodId'
		}, 
		[
			{name: 'anopMethodId', mapping : 'chooseId'}
			,{name: 'anopMethodDesc', mapping: 'chooseDesc'}
		])
	});
	//anopSiteCheck
	obj.anopSiteStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.anopSiteStore= new Ext.data.Store({
		proxy: obj.anopSiteStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anopSiteId'
		}, 
		[
			{name: 'anopSiteId', mapping : 'chooseId'}
			,{name: 'anopSiteDesc', mapping: 'chooseDesc'}
		])
	});
	
	//opKnowCheck
	obj.opKnowStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opKnowStore= new Ext.data.Store({
		proxy: obj.opKnowStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opKnowId'
		}, 
		[
			{name: 'opKnowId', mapping : 'chooseId'}
			,{name: 'opKnowDesc', mapping: 'chooseDesc'}
		])
	});
	
	//anKnowCheck
	obj.anKnowStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.anKnowStore= new Ext.data.Store({
		proxy: obj.anKnowStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anKnowId'
		}, 
		[
			{name: 'anKnowId', mapping : 'chooseId'}
			,{name: 'anKnowDesc', mapping: 'chooseDesc'}
		])
	});
	
	//anSafeCheck
	obj.anSafeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.anSafeStore= new Ext.data.Store({
		proxy: obj.anSafeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anSafeId'
		}, 
		[
			{name: 'anSafeId', mapping : 'chooseId'}
			,{name: 'anSafeDesc', mapping: 'chooseDesc'}
		])
	});
	//^patSkinCheck^patSkinReadyCheck^veinPassCheck^allergyCheck^antibiosisCheck
	//patSkinCheck
	obj.patSkinStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.patSkinStore= new Ext.data.Store({
		proxy: obj.patSkinStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'patSkinId'
		}, 
		[
			{name: 'patSkinId', mapping : 'chooseId'}
			,{name: 'patSkinDesc', mapping: 'chooseDesc'}
		])
	});
	
	//Airway
	obj.AirwayStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AirwayStore= new Ext.data.Store({
		proxy: obj.AirwayStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AirwayId'
		}, 
		[
			{name: 'AirwayId', mapping : 'chooseId'}
			,{name: 'AirwayDesc', mapping: 'chooseDesc'}
		])
	});
	obj.OxygenMonitorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OxygenMonitorStore= new Ext.data.Store({
		proxy: obj.OxygenMonitorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OxygenMonitorId'
		}, 
		[
			{name: 'OxygenMonitorId', mapping : 'chooseId'}
			,{name: 'OxygenMonitorDesc', mapping: 'chooseDesc'}
		])
	});
	
	//patSkinReadyCheck
	obj.patSkinReadyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.patSkinReadyStore= new Ext.data.Store({
		proxy: obj.patSkinReadyStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'patSkinReadyId'
		}, 
		[
			{name: 'patSkinReadyId', mapping : 'chooseId'}
			,{name: 'patSkinReadyDesc', mapping: 'chooseDesc'}
		])
	});
	//veinPassCheck
	obj.veinPassStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.veinPassStore= new Ext.data.Store({
		proxy: obj.veinPassStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'veinPassId'
		}, 
		[
			{name: 'veinPassId', mapping : 'chooseId'}
			,{name: 'veinPassDesc', mapping: 'chooseDesc'}
		])
	});
	//allergyCheck
	obj.allergyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.allergyStore= new Ext.data.Store({
		proxy: obj.allergyStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'allergyId'
		}, 
		[
			{name: 'allergyId', mapping : 'chooseId'}
			,{name: 'allergyDesc', mapping: 'chooseDesc'}
		])
	});
	//antibiosisCheck
	obj.antibiosisStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.antibiosisStore= new Ext.data.Store({
		proxy: obj.antibiosisStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'antibiosisId'
		}, 
		[
			{name: 'antibiosisId', mapping : 'chooseId'}
			,{name: 'antibiosisDesc', mapping: 'chooseDesc'}
		])
	});
	//preOpBloodCheck
	obj.preOpBloodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.preOpBloodStore= new Ext.data.Store({
		proxy: obj.preOpBloodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'preOpBloodId'
		}, 
		[
			{name: 'preOpBloodId', mapping : 'chooseId'}
			,{name: 'preOpBloodDesc', mapping: 'chooseDesc'}
		])
	});
	//tpreOpBloodCheck
	obj.tpreOpBloodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.tpreOpBloodStore= new Ext.data.Store({
		proxy: obj.tpreOpBloodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tpreOpBloodId'
		}, 
		[
			{name: 'tpreOpBloodId', mapping : 'chooseId'}
			,{name: 'tpreOpBloodDesc', mapping: 'chooseDesc'}
		])
	});	
	//Prosthesis
	obj.ProsthesisStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ProsthesisStore= new Ext.data.Store({
		proxy: obj.ProsthesisStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ProsthesisId'
		}, 
		[
			{name: 'ProsthesisId', mapping : 'chooseId'}
			,{name: 'ProsthesisDesc', mapping: 'chooseDesc'}
		])
	});
	//Implants
	obj.ImplantsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ImplantsStore= new Ext.data.Store({
		proxy: obj.ImplantsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ImplantsId'
		}, 
		[
			{name: 'ImplantsId', mapping : 'chooseId'}
			,{name: 'ImplantsDesc', mapping: 'chooseDesc'}
		])
	});
	//Metal
	obj.MetalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.MetalStore= new Ext.data.Store({
		proxy: obj.MetalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MetalId'
		}, 
		[
			{name: 'MetalId', mapping : 'chooseId'}
			,{name: 'MetalDesc', mapping: 'chooseDesc'}
		])
	});
	
	//AutologousBlood
	obj.AutologousBloodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AutologousBloodStore= new Ext.data.Store({
		proxy: obj.AutologousBloodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AutologousBloodId'
		}, 
		[
			{name: 'AutologousBloodId', mapping : 'chooseId'}
			,{name: 'AutologousBloodDesc', mapping: 'chooseDesc'}
		])
	});	
	//tAutologousBlood
	obj.tAutologousBloodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.tAutologousBloodStore= new Ext.data.Store({
		proxy: obj.tAutologousBloodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tAutologousBloodId'
		}, 
		[
			{name: 'tAutologousBloodId', mapping : 'chooseId'}
			,{name: 'tAutologousBloodDesc', mapping: 'chooseDesc'}
		])
	});	
	//"PatInfoCheck^opMethodCheck^opSiteCheck^anDocState^imageCheck"
	//PatInfoCheck
	obj.PatInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PatInfoStore= new Ext.data.Store({
		proxy: obj.PatInfoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PatInfoId'
		}, 
		[
			{name: 'PatInfoId', mapping : 'chooseId'}
			,{name: 'PatInfoDesc', mapping: 'chooseDesc'}
		])
	});
	//opMethodCheck
	obj.opMethodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opMethodStore= new Ext.data.Store({
		proxy: obj.opMethodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opMethodId'
		}, 
		[
			{name: 'opMethodId', mapping : 'chooseId'}
			,{name: 'opMethodDesc', mapping: 'chooseDesc'}
		])
	});
	//opSiteCheck
	obj.opSiteStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opSiteStore= new Ext.data.Store({
		proxy: obj.opSiteStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opSiteId'
		}, 
		[
			{name: 'opSiteId', mapping : 'chooseId'}
			,{name: 'opSiteDesc', mapping: 'chooseDesc'}
		])
	});
	//opPosition
	obj.opPositionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opPositionStore= new Ext.data.Store({
		proxy: obj.opPositionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opPositionId'
		}, 
		[
			{name: 'opPositionId', mapping : 'chooseId'}
			,{name: 'opPositionDesc', mapping: 'chooseDesc'}
		])
	});	

	//imageCheck
	obj.imageStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.imageStore= new Ext.data.Store({
		proxy: obj.imageStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'imageId'
		}, 
		[
			{name: 'imageId', mapping : 'chooseId'}
			,{name: 'imageDesc', mapping: 'chooseDesc'}
		])
	});
	//Antibiotic
	obj.AntibioticStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AntibioticStore= new Ext.data.Store({
		proxy: obj.AntibioticStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AntibioticId'
		}, 
		[
			{name: 'AntibioticId', mapping : 'chooseId'}
			,{name: 'AntibioticDesc', mapping: 'chooseDesc'}
		])
	});	
	//"opDocState^opNurseState"
	//opDocState
	obj.opDocStateStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opDocStateStore= new Ext.data.Store({
		proxy: obj.opDocStateStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opDocStateId'
		}, 
		[
			{name: 'opDocStateId', mapping : 'chooseId'}
			,{name: 'opDocStateDesc', mapping: 'chooseDesc'}
		])
	});
	
	//opNurseState
	obj.opNurseStateStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opNurseStateStore= new Ext.data.Store({
		proxy: obj.opNurseStateStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opNurseStateId'
		}, 
		[
			{name: 'opNurseStateId', mapping : 'chooseId'}
			,{name: 'opNurseStateDesc', mapping: 'chooseDesc'}
		])
	});
	//anDocState
	obj.anDocStateStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.anDocStateStore= new Ext.data.Store({
		proxy: obj.anDocStateStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anDocStateId'
		}, 
		[
			{name: 'anDocStateId', mapping : 'chooseId'}
			,{name: 'anDocStateDesc', mapping: 'chooseDesc'}
		])
	});
	//"prePatInfoCheck^factMethodCheck^opDrugCheck^opGoodsCheck^tpatSkinCheck^patGo"
	//prePatInfoCheck
	obj.prePatInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.prePatInfoStore= new Ext.data.Store({
		proxy: obj.prePatInfoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'prePatInfoId'
		}, 
		[
			{name: 'prePatInfoId', mapping : 'chooseId'}
			,{name: 'prePatInfoDesc', mapping: 'chooseDesc'}
		])
	});
	//factMethodCheck
	obj.factMethodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.factMethodStore= new Ext.data.Store({
		proxy: obj.factMethodStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'factMethodId'
		}, 
		[
			{name: 'factMethodId', mapping : 'chooseId'}
			,{name: 'factMethodDesc', mapping: 'chooseDesc'}
		])
	});
	//opDrugCheck
	obj.opDrugStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opDrugStore= new Ext.data.Store({
		proxy: obj.opDrugStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opDrugId'
		}, 
		[
			{name: 'opDrugId', mapping : 'chooseId'}
			,{name: 'opDrugDesc', mapping: 'chooseDesc'}
		])
	});
	//Equipment
	obj.EquipmentStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.EquipmentStore= new Ext.data.Store({
		proxy: obj.EquipmentStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EquipmentId'
		}, 
		[
			{name: 'EquipmentId', mapping : 'chooseId'}
			,{name: 'EquipmentDesc', mapping: 'chooseDesc'}
		])
	});	
	//opGoodsCheck
	obj.opGoodsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opGoodsStore= new Ext.data.Store({
		proxy: obj.opGoodsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opGoodsId'
		}, 
		[
			{name: 'opGoodsId', mapping : 'chooseId'}
			,{name: 'opGoodsDesc', mapping: 'chooseDesc'}
		])
	});
	//opSpecimen
	obj.opSpecimenStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opSpecimenStore= new Ext.data.Store({
		proxy: obj.opSpecimenStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opSpecimenId'
		}, 
		[
			{name: 'opSpecimenId', mapping : 'chooseId'}
			,{name: 'opSpecimenDesc', mapping: 'chooseDesc'}
		])
	});
	//tpatSkinCheck
	obj.tpatSkinStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.tpatSkinStore= new Ext.data.Store({
		proxy: obj.tpatSkinStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tpatSkinId'
		}, 
		[
			{name: 'tpatSkinId', mapping : 'chooseId'}
			,{name: 'tpatSkinDesc', mapping: 'chooseDesc'}
		])
	});
	//patGo
	obj.patGoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.patGoStore= new Ext.data.Store({
		proxy: obj.patGoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'patGoId'
		}, 
		[
			{name: 'patGoId', mapping : 'chooseId'}
			,{name: 'patGoDesc', mapping: 'chooseDesc'}
		])
	});
	
	//"everyCanal"
	obj.everyCanalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.everyCanalStore= new Ext.data.Store({
		proxy: obj.everyCanalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'everyCanalId'
		}, 
		[
			{name: 'everyCanalId', mapping : 'chooseId'}
			,{name: 'everyCanalDesc', mapping: 'chooseDesc'}
		])
	});
	obj.comAppLoc = new Ext.form.TextField({
		id : 'comAppLoc'
		,fieldLabel : '科室'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});
	obj.txtMedCareNo = new Ext.form.TextField({
		id : 'txtMedCareNo'
		,fieldLabel : '住院号'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:10}
	});
	obj.patName = new Ext.form.TextField({
		id : 'patName'
		,fieldLabel : '姓名'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:10}
	});
	obj.patSex = new Ext.form.TextField({
		id : 'patSex'
		,fieldLabel : '性别'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});
	obj.patAge = new Ext.form.TextField({
		id : 'patAge'
		,fieldLabel : '年龄'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});
	

	
	/*obj.anMethod = new Ext.form.TextField({
		id : 'anMethod'
		,fieldLabel : '麻醉方式'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});*/
	obj.patPanel11 = new Ext.Panel({
		id : 'patPanel11'
		,buttonAlign : 'left'
		,width:120
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.comAppLoc
		]
	});
	obj.patPanel12 = new Ext.Panel({
		id : 'patPanel12'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.txtMedCareNo
		]
	});
	obj.patPanel13 = new Ext.Panel({
		id : 'patPanel13'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.patName
		]
	});
	obj.patPanel14 = new Ext.Panel({
		id : 'patPanel14'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 50
		,layout : 'form'
		,items:[
			obj.patSex
		]
	});
	obj.patPanel15 = new Ext.Panel({
		id : 'patPanel15'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 50
		,layout : 'form'
		,items:[
			obj.patAge
		]
	});

	/*obj.patPanel16 = new Ext.Panel({
		id : 'patPanel16'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.anMethod
		]
	});
	*/
	
	obj.patPanel1 = new Ext.Panel({
		id : 'patPanel1'
		,buttonAlign : 'center'
		,region : 'north'
		,height : 40
		,layout : 'column'
		,frame : true
		,items:[
		    obj.patPanel11
			,obj.patPanel12
			,obj.patPanel13
			,obj.patPanel14
			,obj.patPanel15
			//,obj.patPanel16
			
		]
	});
	
	obj.opName = new Ext.form.TextField({
		id : 'opName'
		,fieldLabel : '手术名称'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});
	/*
	obj.opDoctor = new Ext.form.TextField({
		id : 'opDoctor'
		,fieldLabel : '术者'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});
	*/
	obj.opTime = new Ext.form.TextField({
		id : 'opTime'
		,fieldLabel : '手术时间'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:5}
	});
	
	obj.patPanel21 = new Ext.Panel({
		id : 'patPanel21'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items:[
			obj.opName
		]
	});
	
	/*obj.patPanel22 = new Ext.Panel({
		id : 'patPanel22'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
            obj.opDoctor
		]
	});*/
	
	obj.patPanel23 = new Ext.Panel({
		id : 'patPanel23'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			//obj.opTime
		]
	});
	obj.patPanel2 = new Ext.Panel({
		id : 'patPanel2'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,frame : true
		,items:[
			obj.patPanel21
			//,obj.patPanel22
			,obj.patPanel23
			
		]
	});
	obj.patPanel = new Ext.Panel({
		id : 'patPanel'
		,buttonAlign : 'center'
		,height : 120
		,title : '手术安全核查表'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.patPanel1
			,obj.patPanel2
		]
	});
	
	
	obj.anPatInfoDesc = new Ext.form.TextField({
		id : 'anPatInfoDesc'
		,fieldLabel : '病人姓名'
		,valueField : 'anPatInfoId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.anSurgueDesc = new Ext.form.TextField({
		id : 'anSurgueDesc'
		,fieldLabel : '手术医生'
		,valueField : 'anSurgueId'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.anAnDocDesc = new Ext.form.TextField({
		id : 'anAnDocDesc'
		,fieldLabel : '麻醉医生'
		,valueField : 'anAnDocId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.anOpNurseDesc = new Ext.form.TextField({
		id : 'anOpNurseDesc'
		,fieldLabel : '手术护士'
		,valueField : 'anOpNurseId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.patPanelA1 = new Ext.Panel({
		id : 'patPanelA1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anPatInfoDesc
		]
	});
	obj.patPanelA2 = new Ext.Panel({
		id : 'patPanelA2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anSurgueDesc
		]
	});

	obj.patPanelA3 = new Ext.Panel({
		id : 'patPanelA3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anAnDocDesc
		]
	});
	obj.patPanelA4 = new Ext.Panel({
		id : 'patPanelA4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anOpNurseDesc
		]
	});
	obj.patPanelA = new Ext.Panel({
		id : 'patPanelA'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelA1
			,obj.patPanelA2
			,obj.patPanelA3
			,obj.patPanelA4
		]
	});
	
	obj.anopMethodCheck = new Ext.form.ComboBox({
		id : 'anopMethodCheck'
		,store : obj.anopMethodStore
		,minChars : 1
		,displayField : 'anopMethodDesc'
		,fieldLabel : '手术方式'
		,valueField : 'anopMethodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	

	obj.anopSiteCheck = new Ext.form.ComboBox({
		id : 'anopSiteCheck'
		,store : obj.anopSiteStore
		,minChars : 1
		,displayField : 'anopSiteDesc'
		,fieldLabel : '手术部位与标识'
		,valueField : 'anopSiteId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.opKnowCheck = new Ext.form.ComboBox({
		id : 'opKnowCheck'
		,store : obj.opKnowStore
		,minChars : 1
		,displayField : 'opKnowDesc'
		,fieldLabel : '手术知情同意'
		,valueField : 'opKnowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.anKnowCheck = new Ext.form.ComboBox({
		id : 'anKnowCheck'
		,store : obj.anKnowStore
		,minChars : 1
		,displayField : 'anKnowDesc'
		,fieldLabel : '麻醉知情同意'
		,valueField : 'anKnowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.anSafeCheck = new Ext.form.ComboBox({
		id : 'anSafeCheck'
		,store : obj.anSafeStore
		,minChars : 1
		,displayField : 'anSafeDesc'
		,fieldLabel : '麻醉安全检查完成'
		,valueField : 'anSafeId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.patPanelB1 = new Ext.Panel({
		id : 'patPanelB1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.anopMethodCheck
		]
	});
	obj.patPanelB2 = new Ext.Panel({
		id : 'patPanelB2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.anopSiteCheck
		]
	});
	obj.patPanelB3 = new Ext.Panel({
		id : 'patPanelB3'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.opKnowCheck
		]
	});	
	obj.patPanelB4 = new Ext.Panel({
		id : 'patPanelB4'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.anKnowCheck
		]
	});
	obj.patPanelB5 = new Ext.Panel({
		id : 'patPanelB5'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.anSafeCheck
		]
	});	
	obj.patPanelB = new Ext.Panel({
		id : 'patPanelB'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelB1
			,obj.patPanelB2
			,obj.patPanelB3
			,obj.patPanelB4
			,obj.patPanelB5
		]
	});
	
	obj.OxygenMonitor = new Ext.form.ComboBox({
		id : 'OxygenMonitor'
		,store : obj.OxygenMonitorStore
		,minChars : 1
		,displayField : 'OxygenMonitorDesc'
		,fieldLabel : '血氧监测建立'
		,valueField : 'OxygenMonitorId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.allergyCheck = new Ext.form.ComboBox({
		id : 'allergyCheck'
		,store : obj.allergyStore
		,minChars : 1
		,displayField : 'allergyDesc'
		,fieldLabel : '患者过敏史'
		,valueField : 'allergyId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.Airway = new Ext.form.ComboBox({
		id : 'Airway'
		,store : obj.AirwayStore
		,minChars : 1
		,displayField : 'AirwayDesc'
		,fieldLabel : '气道(呼吸功能)障碍'
		,valueField : 'AirwayId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.veinPassCheck = new Ext.form.ComboBox({
		id : 'veinPassCheck'
		,store : obj.veinPassStore
		,minChars : 1
		,displayField : 'veinPassDesc'
		,fieldLabel : '静脉通道建立完成'
		,valueField : 'veinPassId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.patSkinCheck = new Ext.form.ComboBox({
		id : 'patSkinCheck'
		,store : obj.patSkinStore
		,minChars : 1
		,displayField : 'patSkinDesc'
		,fieldLabel : '皮肤完整性检查'
		,valueField : 'patSkinId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.patPanelC1 = new Ext.Panel({
		id : 'patPanelC1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.OxygenMonitor
		]
	});
	obj.patPanelC2 = new Ext.Panel({
		id : 'patPanelC2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.allergyCheck
		]
	});
	obj.patPanelC3 = new Ext.Panel({
		id : 'patPanelC3'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Airway
		]
	});
	
	obj.patPanelC4 = new Ext.Panel({
		id : 'patPanelC4'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.veinPassCheck
		]
	});
	obj.patPanelC5 = new Ext.Panel({
		id : 'patPanelC5'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.patSkinCheck
		]
	});
	obj.patPanelC = new Ext.Panel({
		id : 'patPanelC'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelC1
			,obj.patPanelC2
			,obj.patPanelC3
			,obj.patPanelC4
			,obj.patPanelC5
		]
	});	
	
	obj.AutologousBlood = new Ext.form.ComboBox({
		id : 'AutologousBlood'
		,store : obj.AutologousBloodStore
		,minChars : 1
		,displayField : 'AutologousBloodDesc'
		,fieldLabel : '计划自体输血'
		,valueField : 'AutologousBloodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.preOpBloodCheck = new Ext.form.ComboBox({
		id : 'preOpBloodCheck'
		,store : obj.preOpBloodStore
		,minChars : 1
		,displayField : 'preOpBloodDesc'
		,fieldLabel : '计划异体输血'
		,valueField : 'preOpBloodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	
	obj.Prosthesis = new Ext.form.ComboBox({
		id : 'Prosthesis'
		,store : obj.ProsthesisStore
		,minChars : 1
		,displayField : 'ProsthesisDesc'
		,fieldLabel : '假体'
		,valueField : 'ProsthesisId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.Implants = new Ext.form.ComboBox({
		id : 'Implants'
		,store : obj.ImplantsStore
		,minChars : 1
		,displayField : 'ImplantsDesc'
		,fieldLabel : '植入物'
		,valueField : 'ImplantsId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.Metal = new Ext.form.ComboBox({
		id : 'Metal'
		,store : obj.MetalStore
		,minChars : 1
		,displayField : 'MetalDesc'
		,fieldLabel : '金属'
		,valueField : 'MetalId'
		,triggerAction : 'all'
		,anchor : '95%'
	});			
	
	/*obj.patSkinReadyCheck = new Ext.form.ComboBox({
		id : 'patSkinReadyCheck'
		,store : obj.patSkinReadyStore
		,minChars : 1
		,displayField : 'patSkinReadyDesc'
		,fieldLabel : '手术皮肤是否准备'
		,valueField : 'patSkinReadyId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	



	obj.antibiosisCheck = new Ext.form.ComboBox({
		id : 'antibiosisCheck'
		,store : obj.antibiosisStore
		,minChars : 1
		,displayField : 'antibiosisDesc'
		,fieldLabel : '抗菌药物皮试结果'
		,valueField : 'antibiosisId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	*/

	obj.patPanelD1 = new Ext.Panel({
		id : 'patPanelD1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.AutologousBlood
		]
	});
	obj.patPanelD2 = new Ext.Panel({
		id : 'patPanelD2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.preOpBloodCheck
		]
	});
	obj.patPanelD3 = new Ext.Panel({
		id : 'patPanelD3'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Prosthesis
		]
	});
	obj.patPanelD4 = new Ext.Panel({
		id : 'patPanelD4'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Implants
		]
	});
	obj.patPanelD5 = new Ext.Panel({
		id : 'patPanelD5'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Metal
		]
	});
	obj.patPanelD = new Ext.Panel({
		id : 'patPanelD'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelD1
			,obj.patPanelD2
			,obj.patPanelD3
			,obj.patPanelD4
			,obj.patPanelD5
		]
	});
	obj.anOther = new Ext.form.TextField({
		id : 'anOther'
		,fieldLabel : '其他'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.patPanelE1 = new Ext.Panel({
		id : 'patPanelE1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.anOther
		]
	});	
	obj.patPanelE = new Ext.Panel({
		id : 'patPanelE'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelE1
		]
	});
	
	obj.ANBeforePane = new Ext.Panel({
		id : 'ANBeforePane'
		,buttonAlign : 'center'
		,height : 220
		,title : '麻醉实施前'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.patPanelA
			,obj.patPanelB
			,obj.patPanelC
			,obj.patPanelD
			,obj.patPanelE
		]
	});
	
	obj.opPatInfoDesc = new Ext.form.TextField({
		id : 'opPatInfoDesc'
		,fieldLabel : '病人姓名'
		,valueField : 'opPatInfoId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.opSurgueDesc = new Ext.form.TextField({
		id : 'opSurgueDesc'
		,fieldLabel : '手术医生'
		,valueField : 'opSurgueId'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.opAnDocDesc = new Ext.form.TextField({
		id : 'opAnDocDesc'
		,fieldLabel : '麻醉医生'
		,valueField : 'opAnDocId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.opOpNurseDesc = new Ext.form.TextField({
		id : 'opOpNurseDesc'
		,fieldLabel : '手术护士'
		,valueField : 'opOpNurseId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.patPanelH1 = new Ext.Panel({
		id : 'patPanelH1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opPatInfoDesc
		]
	});
	obj.patPanelH2 = new Ext.Panel({
		id : 'patPanelH2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opSurgueDesc
		]
	});

	obj.patPanelH3 = new Ext.Panel({
		id : 'patPanelH3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opAnDocDesc
		]
	});
	obj.patPanelH4 = new Ext.Panel({
		id : 'patPanelH4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opOpNurseDesc
		]
	});
	obj.patPanelH = new Ext.Panel({
		id : 'patPanelH'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelH1
			,obj.patPanelH2
			,obj.patPanelH3
			,obj.patPanelH4
		]
	});

	obj.opMethodCheck = new Ext.form.ComboBox({
		id : 'opMethodCheck'
		,store : obj.opMethodStore
		,minChars : 1
		,displayField : 'opMethodDesc'
		,fieldLabel : '手术方式'
		,valueField : 'opMethodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.opSiteCheck = new Ext.form.ComboBox({
		id : 'opSiteCheck'
		,store : obj.opSiteStore
		,minChars : 1
		,displayField : 'opSiteDesc'
		,fieldLabel : '手术部位'
		,valueField : 'opSiteId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.opPosition = new Ext.form.ComboBox({
		id : 'opPosition'
		,store : obj.opPositionStore
		,minChars : 1
		,displayField : 'opPositionDesc'
		,fieldLabel : '手术体位'
		,valueField : 'opPositionId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	/*obj.operTime = new Ext.form.TextField({
		id : 'operTime'
		,fieldLabel : '手术时间'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:5}
	});*/
	obj.anopWarn = new Ext.form.TextField({
		id : 'anopWarn'
		,fieldLabel : '手术风险预警'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:5}
	});
	obj.patPanelI1 = new Ext.Panel({
		id : 'patPanelI1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opMethodCheck
		]
	});
	obj.patPanelI2 = new Ext.Panel({
		id : 'patPanelI2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opSiteCheck
		]
	});
	obj.patPanelI3 = new Ext.Panel({
		id : 'patPanelI3'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opPosition
		]
	});
	obj.patPanelI4 = new Ext.Panel({
		id : 'patPanelI4'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anopWarn
		]
	});
	obj.patPanelI = new Ext.Panel({
		id : 'patPanelI'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelI1
			,obj.patPanelI2
			,obj.patPanelI3
			,obj.patPanelI4
		]
	});
	
	obj.opDocState = new Ext.ux.form.LovCombo({
		id : 'opDocState'
		,store : obj.opDocStateStore
		,minChars : 1
		,displayField : 'opDocStateDesc'
		,fieldLabel : '手术医生陈述'
		,valueField : 'opDocStateId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.anDocState = new Ext.ux.form.LovCombo({
		id : 'anDocState'
		,store : obj.anDocStateStore
		,minChars : 1
		,displayField : 'anDocStateDesc'
		,fieldLabel : '麻醉医生陈述'
		,valueField : 'anDocStateId'
		,mode: 'local'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	//obj.opNurseStore=[['0','物品灭菌合格'],['1','仪器设备、植入物'],['2','术前术中特殊用药'],['3','其他']]
	obj.opNurseState = new Ext.ux.form.LovCombo({
		id : 'opNurseState'
		,store : obj.opNurseStateStore
		,minChars : 1 
		//,renderTo:'lovcomboct' 
		,displayField : 'opNurseStateDesc'
		,fieldLabel : '手术护士陈述'
		,valueField : 'opNurseStateId'
		,mode: 'local'
		,triggerAction : 'all'
		,anchor : '95%'
		
	});	
	obj.patPanelJ1 = new Ext.Panel({
		id : 'patPanelJ1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .33
		,layout : 'form'
		,items:[
			obj.opDocState
		]
	});
	obj.patPanelJ2 = new Ext.Panel({
		id : 'patPanelJ2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .33
		,layout : 'form'
		,items:[
			obj.anDocState
		]
	});
	obj.patPanelJ3 = new Ext.Panel({
		id : 'patPanelJ3'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .33
		,layout : 'form'
		,items:[
			obj.opNurseState
		]
	});
	obj.patPanelJ = new Ext.Panel({
		id : 'patPanelJ'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelJ1
			,obj.patPanelJ2
			,obj.patPanelJ3
		]
	});
	obj.Antibiotic = new Ext.form.ComboBox({
		id : 'Antibiotic'
		,store : obj.AntibioticStore
		,minChars : 1
		,displayField : 'AntibioticDesc'
		,fieldLabel : '围手术期给予防御性抗生素'
		,valueField : 'AntibioticId'
		,triggerAction : 'all'
		,anchor : '95%'
		,checkField: 'checked'
        ,multi: true
	});
	obj.imageCheck = new Ext.form.ComboBox({
		id : 'imageCheck'
		,store : obj.imageStore
		,minChars : 1
		,displayField : 'imageDesc'
		,fieldLabel : '需要相关影像资料'
		,valueField : 'imageId'
		,triggerAction : 'all'
		,anchor : '95%'
		,checkField: 'checked'
        ,multi: true
	});
	obj.opOther = new Ext.form.TextField({
		id : 'opOther'
		,fieldLabel : '其他'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.patPanelK1 = new Ext.Panel({
		id : 'patPanelK1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.Antibiotic
		]
	});
	obj.patPanelK2 = new Ext.Panel({
		id : 'patPanelK2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.imageCheck
		]
	});
	obj.patPanelK3 = new Ext.Panel({
		id : 'patPanelK3'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.opOther
		]
	});
	obj.patPanelK = new Ext.Panel({
		id : 'patPanelK'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelK1
			,obj.patPanelK2
			,obj.patPanelK3
		]
	});	
	obj.OPBeforePane = new Ext.Panel({
		id : 'OPBeforePane'
		,buttonAlign : 'center'
		,height : 180
		,title : '手术实施前'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.patPanelH
			,obj.patPanelI
			,obj.patPanelJ
			,obj.patPanelK

		]
	});
	
	obj.prePatInfoDesc = new Ext.form.TextField({
		id : 'prePatInfoDesc'
		,fieldLabel : '病人姓名'
		,valueField : 'prePatInfoId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.preSurgueDesc = new Ext.form.TextField({
		id : 'preSurgueDesc'
		,fieldLabel : '手术医生'
		,valueField : 'preSurgueId'
		,labelWidth : 2
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.preAnDocDesc = new Ext.form.TextField({
		id : 'preAnDocDesc'
		,fieldLabel : '麻醉医生'
		,valueField : 'preAnDocId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.preOpNurseDesc = new Ext.form.TextField({
		id : 'preOpNurseDesc'
		,fieldLabel : '手术护士'
		,valueField : 'preOpNurseId'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.patPanelO1 = new Ext.Panel({
		id : 'patPanelO1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.prePatInfoDesc
		]
	});
	obj.patPanelO2 = new Ext.Panel({
		id : 'patPanelO2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.preSurgueDesc
		]
	});

	obj.patPanelO3 = new Ext.Panel({
		id : 'patPanelO3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.preAnDocDesc
		]
	});
	obj.patPanelO4 = new Ext.Panel({
		id : 'patPanelO4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.preOpNurseDesc
		]
	});
	obj.patPanelO = new Ext.Panel({
		id : 'patPanelO'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelO1
			,obj.patPanelO2
			,obj.patPanelO3
			,obj.patPanelO4
		]
	});
	
	obj.factMethodCheck = new Ext.form.ComboBox({
		id : 'factMethodCheck'
		,store : obj.factMethodStore
		,minChars : 1
		,displayField : 'factMethodDesc'
		,fieldLabel : '实施手术名称'
		,valueField : 'factMethodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.opGoodsCheck = new Ext.form.ComboBox({
		id : 'opGoodsCheck'
		,store : obj.opGoodsStore
		,minChars : 1
		,displayField : 'opGoodsDesc'
		,fieldLabel : '清点手术用物'
		,valueField : 'opGoodsId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.opSpecimen = new Ext.form.ComboBox({
		id : 'opSpecimen'
		,store : obj.opSpecimenStore
		,minChars : 1
		,displayField : 'opSpecimenDesc'
		,fieldLabel : '手术标本'
		,valueField : 'opSpecimenId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.tpatSkinCheck = new Ext.form.ComboBox({
		id : 'tpatSkinCheck'
		,store : obj.tpatSkinStore
		,minChars : 1
		,displayField : 'tpatSkinDesc'
		,fieldLabel : '皮肤完整性'
		,valueField : 'tpatSkinId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.patPanelP1 = new Ext.Panel({
		id : 'patPanelP1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.factMethodCheck
		]
	});
	obj.patPanelP2 = new Ext.Panel({
		id : 'patPanelP2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opGoodsCheck
		]
	});
	obj.patPanelP3 = new Ext.Panel({
		id : 'patPanelP3'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opSpecimen
		]
	});
	obj.patPanelP4 = new Ext.Panel({
		id : 'patPanelP4'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.tpatSkinCheck
		]
	});
	obj.patPanelP = new Ext.Panel({
		id : 'patPanelP'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelP1
			,obj.patPanelP2
			,obj.patPanelP3
			,obj.patPanelP4
		]
	});	
	obj.Equipment = new Ext.form.ComboBox({
		id : 'Equipment'
		,store : obj.EquipmentStore
		,minChars : 1
		,displayField : 'EquipmentDesc'
		,fieldLabel : '仪器设备需要检修'
		,valueField : 'EquipmentId'
		,triggerAction : 'all'
		,anchor : '95%'
	});		
	obj.patGo = new Ext.form.ComboBox({
		id : 'patGo'
		,store : obj.patGoStore
		,minChars : 1
		,displayField : 'patGoDesc'
		,fieldLabel : '患者去向'
		,valueField : 'patGoId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	
	obj.tAutologousBlood = new Ext.form.ComboBox({
		id : 'tAutologousBlood'
		,store : obj.tAutologousBloodStore
		,minChars : 1
		,displayField : 'tAutologousBloodDesc'
		,fieldLabel : '实施自体输血'
		,valueField : 'tAutologousBloodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.tpreOpBloodCheck = new Ext.form.ComboBox({
		id : 'tpreOpBloodCheck'
		,store : obj.tpreOpBloodStore
		,minChars : 1
		,displayField : 'tpreOpBloodDesc'
		,fieldLabel : '实施异体输血'
		,valueField : 'tpreOpBloodId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.patPanelQ1 = new Ext.Panel({
		id : 'patPanelQ1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.Equipment
		]
	});
	obj.patPanelQ2 = new Ext.Panel({
		id : 'patPanelQ2'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.patGo
		]
	});
	obj.patPanelQ3 = new Ext.Panel({
		id : 'patPanelQ3'
		,buttonAlign : 'center'
		,width:160
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.tAutologousBlood
		]
	});
	obj.patPanelQ4 = new Ext.Panel({
		id : 'patPanelQ4'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.tpreOpBloodCheck
		]
	});
	obj.patPanelQ = new Ext.Panel({
		id : 'patPanelQ'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelQ1
			,obj.patPanelQ2
			,obj.patPanelQ3
			,obj.patPanelQ4
		]
	});	
	obj.everyCanal = new Ext.ux.form.LovCombo({
		id : 'everyCanal'
		,store : obj.everyCanalStore
		,minChars : 1
		,displayField : 'everyCanalDesc'
		,fieldLabel : '各种管路'
		,valueField : 'everyCanalId'
		,triggerAction : 'all'
		,anchor : '95%'
	});		
	obj.anopOther = new Ext.form.TextField({
		id : 'anopOther'
		,fieldLabel : '其他'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.patPanelR1 = new Ext.Panel({
		id : 'patPanelR1'
		,buttonAlign : 'center'
		,width:60
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.everyCanal
		]
	});	
	obj.patPanelR2 = new Ext.Panel({
		id : 'patPanelR2'
		,buttonAlign : 'center'
		,width:160
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.anopOther
		]
	});	
	obj.patPanelR = new Ext.Panel({
		id : 'patPanelR'
		,buttonAlign : 'center'
		,height : 40
		,layout : 'column'
		,items:[
			obj.patPanelR1
			,obj.patPanelR2
		]
	});	
	/*obj.opDrugCheck = new Ext.form.ComboBox({
		id : 'opDrugCheck'
		,store : obj.opDrugStore
		,minChars : 1
		,displayField : 'opDrugDesc'
		,fieldLabel : '手术用药,输血的核查'
		,valueField : 'opDrugId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	*/

	obj.OutBeforePane = new Ext.Panel({
		id : 'OutBeforePane'
		,buttonAlign : 'center'
		,height : 180
		,title : '患者离开手术室前'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.patPanelO
			,obj.patPanelP
			,obj.patPanelQ
			,obj.patPanelR
		]
	});
	
	obj.checkPanel = new Ext.Panel({
		id : 'checkPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,frame : true
		,items:[
			obj.ANBeforePane
			,obj.OPBeforePane
			,obj.OutBeforePane
		]
	});

	obj.EpisodeID = new Ext.form.TextField({
		id : 'EpisodeID'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
	});
	obj.appType = new Ext.form.TextField({
		id : 'appType'
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
		,region : 'east'
		,hidden : true
		,items:[
			obj.EpisodeID
			,obj.opaId
			,obj.appType
			,obj.loc
			,obj.userLocId
			,obj.maxOrdNo
			,obj.logUserType
		]
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,text : '保存'
	});	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,text : '打印'
	});	
	obj.btnSavePanel1 = new Ext.Panel({
		id : 'btnSavePanel1'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'column'
		,items:[
		]
		,buttons:[
			obj.btnSave
		]
	});
	obj.btnSavePanel2 = new Ext.Panel({
		id : 'btnSavePanel2'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'column'
		,items:[
		]
		,buttons:[
			//obj.btnPrint
		]
	});
	
	obj.opDocName = new Ext.form.TextField({
		id : 'opDocName'
		,fieldLabel : '手术医师签名'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:10}
	});
	
	obj.anDocName = new Ext.form.TextField({
		id : 'anDocName'
		,fieldLabel : '麻醉医师签名'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:10}
	});
	
	obj.opNurseName = new Ext.form.TextField({
		id : 'opNurseName'
		,fieldLabel : '手术室护士签名'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,readOnly:true
		,lengthRange:{min:0,max:10}
	});
	obj.anopPanel1 = new Ext.Panel({
		id : 'anopPanel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.opDocName
		]
	});
	obj.anopPanel2 = new Ext.Panel({
		id : 'anopPanel2'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.anDocName
		]
	});
	obj.anopPanel3 = new Ext.Panel({
		id : 'anopPanel3'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.opNurseName
		]
	});
	
	obj.btnPanel1 = new Ext.Panel({
		id : 'btnPanel1'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,height : 60
		,hidden : true
		,frame : true
		,items:[
			obj.anopPanel1
			,obj.anopPanel2
			,obj.anopPanel3
		]
	});
	obj.btnPanel2 = new Ext.Panel({
		id : 'btnPanel2'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,frame : true
		,items:[
			obj.btnSavePanel1
			,obj.btnSavePanel2
		]
	});
	
	obj.btnPanel = new Ext.Panel({
		id : 'btnPanel'
		,buttonAlign : 'center'
		,height : 90
		,region : 'south'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.btnPanel1
			,obj.btnPanel2
		]
	});

	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.patPanel
			,obj.checkPanel
			,obj.hiddenPanel
			,obj.btnPanel
		]
	});

	//anopMethodCheck
	obj.anopMethodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "anopMethodCheck";
		param.ArgCnt = 2;
	});
	obj.anopMethodStore.load({});
	//anopSiteCheck
	obj.anopSiteStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "anopSiteCheck";
		param.ArgCnt = 2;
	});
	obj.anopSiteStore.load({});
	
	//opKnowCheck
	obj.opKnowStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "opKnowCheck";
		param.ArgCnt = 2;
	});
	obj.opKnowStore.load({});
	
	//anKnowCheck
	obj.anKnowStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "anKnowCheck";
		param.ArgCnt = 2;
	});
	obj.anKnowStore.load({});
	
	//anSafeCheck
	obj.anSafeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "anSafeCheck";
		param.ArgCnt = 2;
	});
	obj.anSafeStore.load({});
	
	//patSkinCheck
	obj.patSkinStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "patSkinCheck";
		param.ArgCnt = 2;
	});
	obj.patSkinStore.load({});
	//OxygenMonitor
	obj.OxygenMonitorStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "OxygenMonitor";
		param.ArgCnt = 2;
	});
	obj.OxygenMonitorStore.load({});
	
	//Airway
	obj.AirwayStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "Airway";
		param.ArgCnt = 2;
	});
	obj.AirwayStore.load({});
	
	//patSkinReadyCheck
	obj.patSkinReadyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "patSkinReadyCheck";
		param.ArgCnt = 2;
	});
	obj.patSkinReadyStore.load({});
	
	//veinPassCheck
	obj.veinPassStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "veinPassCheck";
		param.ArgCnt = 2;
	});
	obj.veinPassStore.load({});
	
	//allergyCheck
	obj.allergyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "allergyCheck";
		param.ArgCnt = 2;
	});
	obj.allergyStore.load({});
	
	//antibiosisCheck
	obj.antibiosisStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "antibiosisCheck";
		param.ArgCnt = 2;
	});
	obj.antibiosisStore.load({});
	
	//preOpBloodCheck
	obj.preOpBloodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "preOpBloodCheck";
		param.ArgCnt = 2;
	});
	obj.preOpBloodStore.load({});
	
	
	//Prosthesis
	obj.ProsthesisStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "Prosthesis";
		param.ArgCnt = 2;
	});
	obj.ProsthesisStore.load({});
	//Implants
	obj.ImplantsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "Implants";
		param.ArgCnt = 2;
	});
	obj.ImplantsStore.load({});
	//Metal
	obj.MetalStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "Metal";
		param.ArgCnt = 2;
	});
	obj.MetalStore.load({});
	//AutologousBlood
	obj.AutologousBloodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Anaesthetist"
		param.Arg2 = "AutologousBlood";
		param.ArgCnt = 2;
	});
	obj.AutologousBloodStore.load({});
	//"PatInfoCheck^opMethodCheck^opSiteCheck^anDocState^imageCheck"
	//PatInfoCheck
	obj.PatInfoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "PatInfoCheck";
		param.ArgCnt = 2;
	});
	obj.PatInfoStore.load({});
	
	//opMethodCheck
	obj.opMethodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "opMethodCheck";
		param.ArgCnt = 2;
	});
	obj.opMethodStore.load({});
	
	//opSiteCheck
	obj.opSiteStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "opSiteCheck";
		param.ArgCnt = 2;
	});
	obj.opSiteStore.load({});
	//opPosition
	obj.opPositionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "opPosition";
		param.ArgCnt = 2;
	});
	obj.opPositionStore.load({});	
	//imageCheck
	obj.imageStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "imageCheck";
		param.ArgCnt = 2;
	});
	obj.imageStore.load({});
	//Antibiotic
	obj.AntibioticStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "Antibiotic";
		param.ArgCnt = 2;
	});
	obj.AntibioticStore.load({});
	//"opDocState^opNurseState"
	//opDocState
	obj.opDocStateStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "opDocState";
		param.ArgCnt = 2;
	});
	obj.opDocStateStore.load({});
	//opNurseState
	obj.opNurseStateStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "opNurseState";
		param.ArgCnt = 2;
	});
	obj.opNurseStateStore.load({});
	//anDocState
	obj.anDocStateStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Surgeon"
		param.Arg2 = "anDocState";
		param.ArgCnt = 2;
	});
	obj.anDocStateStore.load({});
	//"prePatInfoCheck^factMethodCheck^opDrugCheck^opGoodsCheck^tpatSkinCheck^patGo"
	//prePatInfoCheck
	obj.prePatInfoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "prePatInfoCheck";
		param.ArgCnt = 2;
	});
	obj.prePatInfoStore.load({});
	
	//factMethodCheck
	obj.factMethodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "factMethodCheck";
		param.ArgCnt = 2;
	});
	obj.factMethodStore.load({});
	//Equipment
	obj.EquipmentStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "Equipment";
		param.ArgCnt = 2;
	});
	obj.EquipmentStore.load({});	
	//opDrugCheck
	obj.opDrugStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "opDrugCheck";
		param.ArgCnt = 2;
	});
	obj.opDrugStore.load({});
	
	//opGoodsCheck
	obj.opGoodsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "opGoodsCheck";
		param.ArgCnt = 2;
	});
	obj.opGoodsStore.load({});
	//opSpecimen
	obj.opSpecimenStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "opSpecimen";
		param.ArgCnt = 2;
	});
	obj.opSpecimenStore.load({});	
	//tpatSkinCheck
	obj.tpatSkinStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "tpatSkinCheck";
		param.ArgCnt = 2;
	});
	obj.tpatSkinStore.load({});
	
	//patGo
	obj.patGoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "patGo";
		param.ArgCnt = 2;
	});
	obj.patGoStore.load({});
	
	//"everyCanal"
	
	obj.everyCanalStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "everyCanal";
		param.ArgCnt = 2;
	});
	obj.everyCanalStore.load({});
	//tAutologousBlood
	obj.tAutologousBloodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "tAutologousBlood";
		param.ArgCnt = 2;
	});
	obj.tAutologousBloodStore.load({});
	//tpreOpBloodCheck
	obj.tpreOpBloodStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'CheckChoose';
		param.Arg1= "Nurse"
		param.Arg2 = "tpreOpBloodCheck";
		param.ArgCnt = 2;
	});
	obj.preOpBloodStore.load({});	
	InitViewScreenEvent(obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnPrint.on("click", obj.btnPrint_click, obj);
	obj.anPatInfoDesc.on("keydown", obj.PatInfoDesc_keydown, obj);
	obj.anSurgueDesc.on("keydown", obj.SurgueDesc_keydown, obj);
	obj.anAnDocDesc.on("keydown", obj.AnDocDesc_keydown, obj);
	obj.anOpNurseDesc.on("keydown", obj.OpNurseDesc_keydown, obj);
	
	obj.opPatInfoDesc.on("keydown", obj.PatInfoDesc_keydown, obj);
	obj.opSurgueDesc.on("keydown", obj.SurgueDesc_keydown, obj);
	obj.opAnDocDesc.on("keydown", obj.AnDocDesc_keydown, obj);
	obj.opOpNurseDesc.on("keydown", obj.OpNurseDesc_keydown, obj);

	obj.prePatInfoDesc.on("keydown", obj.PatInfoDesc_keydown, obj);
	obj.preSurgueDesc.on("keydown", obj.SurgueDesc_keydown, obj);
	obj.preAnDocDesc.on("keydown", obj.AnDocDesc_keydown, obj);
	obj.preOpNurseDesc.on("keydown", obj.OpNurseDesc_keydown, obj);

	obj.LoadEvent(arguments);
	return obj;

}