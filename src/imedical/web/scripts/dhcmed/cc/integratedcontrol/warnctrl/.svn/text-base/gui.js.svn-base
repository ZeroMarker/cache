function InitviewScreen(){
	var obj = new Object();
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '预警日期'
});
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '至'
});
	obj.pnDate = new Ext.Panel({
		id : 'pnDate'
		,buttonAlign : 'center'
		,width : 200
		,layout : 'form'
		,items:[
			obj.dtFromDate
			,obj.dtToDate
		]
	});
	obj.chkTemp = new Ext.form.Checkbox({
		id : 'chkTemp'
		//,boxLabel : '同科室体温异常>'
		,checked : true
});
	obj.chkDepGerm = new Ext.form.Checkbox({
		id : 'chkDepGerm'
		//,boxLabel : '同科室检出微生物者>'
		,checked : true
});
	obj.chkPersonalGermKind = new Ext.form.Checkbox({
		id : 'chkPersonalGermKind'
		//,boxLabel : '一次就诊检出微生物类别>'
		,checked : true
});
	obj.chkDepGermKind = new Ext.form.Checkbox({
		id : 'chkDepGermKind'
		,checked : true
});

	obj.pnChkCondition = new Ext.Panel({
		id : 'pnChkCondition'
		,buttonAlign : 'center'
		,width : 50
		,labelWidth : 10
		,layout : 'form'
		,labelStyle: 'text-align:right;'
		,items:[
			obj.chkTemp
			,obj.chkDepGerm
			,obj.chkPersonalGermKind
			,obj.chkDepGermKind
		]
	});
	obj.txtTemp = new Ext.form.NumberField({
		id : 'txtTemp'
		,width : 30
		,value : 1
		,fieldLabel:'同科室体温异常>'
});
	obj.txtDepGerm = new Ext.form.NumberField({
		id : 'txtDepGerm'
		,width : 30
		,value : 1
		,fieldLabel : '同科室检出微生物者>'
});
	obj.txtPeronalGerm = new Ext.form.NumberField({
		id : 'txtPeronalGerm'
		,width : 30
		,value : 1
		,fieldLabel : '一次就诊检出微生物类别>'
});
	obj.txtDepGermKind = new Ext.form.NumberField({
		id : 'txtDepGermKind'
		,width : 30
		,value : 1
		,fieldLabel : '科室同种病原体发生数量>'
});
	obj.pnCondition = new Ext.Panel({
		id : 'pnCondition'
		,buttonAlign : 'center'
		,width : 210
		,layout : 'form'
		,labelWidth : 160
		,items:[
			obj.txtTemp
			,obj.txtDepGerm
			,obj.txtPeronalGerm
			,obj.txtDepGermKind
		]
	});
	obj.Label17 = new Ext.form.Label({
		id : 'Label17'
		,text : '人'
		,witdh : 10
});
	obj.Label18 = new Ext.form.Label({
		id : 'Label18'
		,text : '人'
});
	obj.Label19 = new Ext.form.Label({
		id : 'Label19'
		,text : '种'
});
	obj.pnUnit = new Ext.Panel({
		id : 'pnUnit'
		,buttonAlign : 'center'
		,width : 10
		,layout : 'form'
		,items:[
			obj.Label17
			,obj.Label18
			,obj.Label19
		]
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,text : '查询'
		,iconCls : 'icon-find'
	});
	
	obj.frmCondition = new Ext.form.FormPanel({
		id : 'frmCondition'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 160
		,region : 'north'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pnDate
			,obj.pnChkCondition
			,obj.pnCondition
			,obj.pnUnit
		],
		buttons : [obj.btnQuery]
	});
	obj.pnResult = new Ext.Panel({
		id : 'pnResult'
		,buttonAlign : 'center'
		,region : 'center'
		,autoScroll : true
		,items:[
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.frmCondition
			,obj.pnResult
		]
	});
	InitviewScreenEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

