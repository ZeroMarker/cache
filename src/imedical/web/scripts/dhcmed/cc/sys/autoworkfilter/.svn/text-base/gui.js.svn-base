//筛选窗口
 function InitFilterRule(SubjectID){
	var obj = new Object();
	obj.SubjectID=SubjectID;
	obj.txtIncludeAbsolute = new Ext.form.Checkbox({
		id : 'txtIncludeAbsolute'
		,fieldLabel : '绝对项目'
});
	obj.txtMinSensitiveCount = new Ext.form.NumberField({
		name:'number'
		,fieldLabel : '敏感性项目触发数量'
    ,allowNegative: false       //不允许输入负数
    ,allowDecimals: false  //不允许输入小数
    ,nanText: "请输入有效数字" //无效数字提示
    ,minValue : 0
		,maxValue : 1500
		,minText : "输入的数字必须大于0"
		,maxText : "输入的数字必须小于150"
		,anchor : '99%'
});
	obj.txtMinSpecificityCount = new Ext.form.NumberField({
		name:'number'
		,fieldLabel : '特异性项目触发数量'
    ,allowNegative: false       //不允许输入负数
    ,allowDecimals: false  //不允许输入小数
    ,nanText: "请输入有效数字" //无效数字提示
    ,minValue : 0
		,maxValue : 1500
		,minText : "输入的数字必须大于0"
		,maxText : "输入的数字必须小于150"
		,anchor : '99%'
});
	obj.txtMinScore = new Ext.form.NumberField({
		name:'number'
		,fieldLabel : '单次触发分数'
		,allowNegative: false       //不允许输入负数
    ,allowDecimals: false  //不允许输入小数
    ,nanText: "请输入有效数字" //无效数字提示
    ,minValue : 0
		,maxValue : 1500
		,minText : "输入的数字必须大于0"
		,maxText : "输入的数字必须小于150"
		,anchor : '99%'
});
	obj.txtTotalScore = new Ext.form.NumberField({
		name:'number'
		,fieldLabel : '累计触发分数'
		,allowNegative: false       //不允许输入负数
    ,allowDecimals: false  //不允许输入小数
    ,nanText: "请输入有效数字" //无效数字提示
    ,minValue : 0
		,maxValue : 1500
		,minText : "输入的数字必须大于0"
		,maxText : "输入的数字必须小于150"
		,anchor : '99%'
});
	obj.txtTotalNoticedScore = new Ext.form.NumberField({
		name:'number'
		,fieldLabel : '累计已提示分数'
		,allowNegative: false       //不允许输入负数
    ,allowDecimals: false  //不允许输入小数
    ,nanText: "请输入有效数字" //无效数字提示
    ,minValue : 0
		,maxValue : 1500
		,minText : "输入的数字必须大于0"
		,maxText : "输入的数字必须小于150"
		,anchor : '99%'
});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-exit'
		,text : '取消'
	});
	obj.pnCtlFilterRule = new Ext.Window({
		id : 'pnCtlFilterRule'
		,buttonAlign : 'center'
		,height : 300
		,width : 250
		,title : '筛选过滤'
		,layout : 'form'
		,modal : true
		,labelAlign : 'right'
		,labelWidth : 130
		,items:[
			obj.txtIncludeAbsolute
			,obj.txtMinSensitiveCount
			,obj.txtMinSpecificityCount
			,obj.txtMinScore
			,obj.txtTotalScore
			,obj.txtTotalNoticedScore
		]
	,	buttons:[
			obj.btnSave
			,obj.btnCancel
			
		]
		});
		InitAutoWorkFilterEvent(obj);
		//事件处理代码
	//obj.gridResult.on("afteredit", obj.gridResult_afteredit, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}

