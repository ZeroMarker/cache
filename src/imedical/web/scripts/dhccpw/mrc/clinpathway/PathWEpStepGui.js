
function PathWEpStep(StepRowid,IsReadOnly){
	//window.alert("STEP:" + StepRowid);
	var obj = new Object();
	var tmpList=StepRowid.split("||");
	if (tmpList.length>=2) {
		obj.EpRowid=tmpList[0]+"||"+tmpList[1];
		obj.StepRowid1=StepRowid;
		obj.StepRowid="";
	}else{
		obj.EpRowid="";
		obj.StepRowid1=StepRowid;
		obj.StepRowid="";
	}
	obj.PathWEpStepGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathWEpStepGridStore = new Ext.data.Store({
		proxy: obj.PathWEpStepGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StepRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'StepRowid', mapping: 'StepRowid'}
			,{name: 'StepDay', mapping: 'StepDay'}
			,{name: 'StepDayUnit', mapping: 'StepDayUnit'}
			,{name: 'StepDayUnitDesc', mapping: 'StepDayUnitDesc'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StepDayNum', mapping: 'StepDayNum'}
			,{name: 'StepTypeCode', mapping: 'StepTypeCode'}
			,{name: 'StepTypeDesc', mapping: 'StepTypeDesc'}
		])
	});
	obj.PathWEpStepGrid = new Ext.grid.GridPanel({
		id : 'PathWEpStepGrid'
		,store : obj.PathWEpStepGridStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			{header: '时间', width: 100, dataIndex: 'StepDay', sortable: true}
			,{header: '时间单位', width: 100, dataIndex: 'StepDayUnitDesc', sortable: true}
			,{header: '步骤描述', width: 200, dataIndex: 'StepDesc', sortable: true}
			,{header: '步骤类型', width: 100, dataIndex: 'StepTypeDesc', sortable: true}
			,{header: '步骤序号', width: 100, dataIndex: 'StepDayNum', sortable: true}
		]
		,stripeRows : true
                ,autoExpandColumn : 'StepDesc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
	});
	obj.StepDay = new Ext.form.NumberField({
		id : 'StepDay'
		,fieldLabel : '时间',
		enableKeyEvents: true
		,anchor : '95%'
	});
	
	obj.cboStepDayUnitStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboStepDayUnitStore = new Ext.data.Store({
		proxy: obj.cboStepDayUnitStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboStepDayUnit = new Ext.form.ComboBox({
		id : 'cboStepDayUnit'
		,width : 300
		,store : obj.cboStepDayUnitStore
		,displayField : 'DicDesc'
		,fieldLabel : '时间单位'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DicCode'
	});
	
	obj.cboStepDayUnitStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseConfig';
			param.QueryName = 'QryBaseDic';
			param.Arg1 = "EpStepDayUnit";
			param.ArgCnt = 1;
	});
	obj.cboStepDayUnitStore.load({});
	
	//add by wuqk --begin 2011-07-25
	
	obj.cboStepTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboStepTypeStore = new Ext.data.Store({
		proxy: obj.cboStepTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BD_RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'BD_Code'}
			,{name: 'DicDesc', mapping: 'BD_Desc'}
		])
	});
	obj.cboStepType = new Ext.form.ComboBox({
		id : 'cboStepType'
		,width : 300
		,store : obj.cboStepTypeStore
		,displayField : 'DicDesc'
		,fieldLabel : '步骤类型'
		,mode : 'local' 
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DicCode'
	});
	
	obj.cboStepTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDictionary';
			param.QueryName = 'QryDicBySubCatDesc';
			param.Arg1 = "STEPTYPE";
			param.Arg2 = "Y";               //add by wuqk 2011-11-03 Only get active data  //by wuqk 2012-04-24 fixed bug
			param.ArgCnt = 2;
	});
	
	obj.cboStepTypeStore.load({});
	//add by wuqk --end
	
	obj.StepDesc = new Ext.form.TextField({
		id : 'StepDesc'
		,fieldLabel : '步骤描述'
		,anchor : '95%'
	});
	obj.StepDayNum = new Ext.form.NumberField({
		id : 'StepDayNum'
		,fieldLabel : '步骤序号'
		,anchor : '95%'
		,allowDecimals:false
		,nanText : '只允许输入整数!'
	});
	obj.PathWEpStepAdd = new Ext.Button({
		id : 'PathWEpStepAdd'
		,text : '添加',
		iconCls : 'icon-add'
		,disabled : IsReadOnly
	});
	obj.PathWEpStepUpdate = new Ext.Button({
		id : 'PathWEpStepUpdate'
		,text : '保存',
		iconCls : 'icon-save'
		,disabled : IsReadOnly
	});
	obj.PathWEpStepDelete = new Ext.Button({
		id : 'PathWEpStepDelete'
		,text : '删除',
		iconCls : 'icon-delete'
		,disabled : IsReadOnly
	});
	obj.PathWEpStepClear = new Ext.Button({
		id : 'PathWEpStepClear'
		,text : '清空',
		iconCls : 'icon-cancel'
		,disabled : IsReadOnly
	});
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items:[
				obj.StepDay
				,obj.cboStepDayUnit
				,obj.StepDesc
				,obj.cboStepType //add by wuqk 2011-07-25
				,obj.StepDayNum
		]
	});
	obj.pathWayEpStep=new Ext.form.FormPanel({
		id : 'pathWayEpStep'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,height : 180   //modify by wuqk 2011-07-25
		,layout:'column'
		,frame : true
		,region : 'south'
		,items:[
			obj.SubPanel1,
			obj.SubPanel2,
			obj.SubPanel3
					]	
					,	buttons:[
						obj.PathWEpStepAdd
						,obj.PathWEpStepUpdate
						,obj.PathWEpStepDelete
						,obj.PathWEpStepClear
		]
	})
	obj.PathWEpStepWindow = new Ext.Viewport({ //Modified By LiYang 2010-12-26 改造为嵌入式
		id : 'win_PathWEpStep'
		,height : 455
		,buttonAlign : 'center'
		,width : 500
		//,title : stepStr //Modified By LiYang 2010-12-26
		,modal:true
		,resizable:false
		,layout : 'border'
		,items:[
						obj.PathWEpStepGrid,
						obj.pathWayEpStep
		]

	});
	obj.PathWEpStepGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MRC.PathWEpStep';
		param.QueryName = 'GetPathEpStep';
		param.Arg1 = obj.EpRowid;
		param.Arg2=obj.StepRowid1;
		param.ArgCnt = 2;
	});
	obj.PathWEpStepGridStore.load({});
	PathWEpStepEvent(obj);
	obj.PathWEpStepAdd.on('click',obj.AddStep)
	obj.PathWEpStepClear.on('click',obj.ClearStep)
	obj.PathWEpStepGrid.getSelectionModel().on('rowselect',obj.PathWEpStepSelect)
	obj.setStepDayNum();
	obj.PathWEpStepUpdate.on('click',obj.UpdateStep)
	obj.PathWEpStepDelete.on('click',obj.DeleteStep)
	//事件处理代码
	obj.LoadEvent();
	return obj;
}

