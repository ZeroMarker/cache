//scripts/pha/in/v3/Budget/Store.js
var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

var _BudgetSaveFlag  = ""
var _BudgetCompFlag  = ""
var _BudgetAuditFlag = ""

var BudgetProStore = new Ext.data.SimpleStore({
    fields: ['RowId', 'Description'],
    data: [
        ['', 'HRP预算系统接口暂未开通！！！！']
    ]
});


// 预算项目
 var BudgetProComb = new Ext.form.ComboBox({
    fieldLabel: '预算项目',
    id: 'BudgetProComb',
    name: 'BudgetProComb',
    anchor: '90%',
    width: 100,
    store: BudgetProStore,
    triggerAction: 'all',
    mode: 'local',
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: true,
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    editable: true,
    valueNotFoundText: ''
});
Ext.getCmp('BudgetProComb').setValue("");


///nodeArr 业务节点数组 1,2,3 分别代表 保存/完成/审核，需要验证那几个就传哪几个，比如 验证 保存+审核 传[1,3]
function SetBudgetPro(Loc,BusiType,nodeArr,limitButton)
{
	var BudgetFlag = PurPlanParam.Budget
	if (BudgetFlag != "Y") 
	{
		Ext.getCmp("BudgetProComb").hide();
		return;
	}
	///测试开关接口，如果想测试科室先放开下面两行
	Msg.info("warning","HRP预算系统错误:接口暂未开通！！！");
	return;
	
	if (Loc == "") 
	{
		Msg.info("warning","HRP预算系统错误:加载预算项目科室不能为空");
		return;
	}
	var ParamsObj = {
		loc_id      : Loc,           //科室id
		business    : BusiType       //业务类型
	}
	var Params = JSON.stringify(ParamsObj)
	var Ret = tkMakeServerCall("PHA.IN.Budget.Client.Interface","GetBusiCtrl",Params)
	var RetObj = JSON.parse(Ret); 
	var code = RetObj.code
	if(code < 0)
	{
		Msg.info("warning",RetObj.msg);
		Ext.getCmp(limitButton).disable();
		return;
	}
	_BudgetSaveFlag  = RetObj.CtrlSave
	_BudgetCompFlag  = RetObj.CtrlComp
	_BudgetAuditFlag = RetObj.CtrlAudit

	var BudgetNodeFalgArr = [
		_BudgetSaveFlag,
		_BudgetCompFlag,
		_BudgetAuditFlag
	]
	
	var _BudgetProject  = RetObj.budgetObj
	var BudSize = RetObj.BudSize
	
	var NodeCheck = NeedCheckNode(nodeArr,BudgetNodeFalgArr)
	
	if(BudSize == 0 && NodeCheck)
	{
		Msg.info("warning","HRP预算系统错误:无有效预算组合");
		Ext.getCmp(limitButton).disable();
		return;
	}
	BudgetProStore.loadData(_BudgetProject)

}

/// 验证传入的业务节点是否需要控制
function NeedCheckNode(nodeArr,BudgetNodeFalgArr)
{
	var Check = false
	var len = nodeArr.length
	for (var i =0;i<len;i++)
	{
		var node = nodeArr[i]
		var nodeVal = BudgetNodeFalgArr[node]
		if (nodeVal != "ALLOW") 
		{
			Check = true;
			break;
		}
	}
	return Check;
}


/// 发送业务数据
function SendBusiData(Pointer,BusiType,BusiNode)
{
	if(!Pointer){
		Msg.info("warning","核对HRP预算数据需要业务表ID");
		return false;
	}
	if(!BusiType){
		Msg.info("warning","核对HRP预算数据需要业务类型");
		return false;
	}
	if(!BusiNode){
		Msg.info("warning","核对HRP预算数据需要业务节点类型");
		return false;
	}
	var CtrlType = ""
	if (BusiNode == "SAVE") 
		CtrlType = _BudgetSaveFlag
	else if (BusiNode == "COMP") 
		CtrlType = _BudgetCompFlag
	else if (BusiNode == "AUDIT") 
		CtrlType = _BudgetAuditFlag
	if (CtrlType != "LIMIT" && CtrlType != "WARN") return true;
	var budgetId = Ext.getCmp('BudgetProComb').getRawValue();
	if(!budgetId) {
		Msg.info("warning","保存数据需核对HRP预算系统，请选择一个预算项目!");
		return false;
	}
	var MianObj = {
		project_id  : budgetId,        //项目id
		main_id     : Pointer,			//业务主表id
		business	: BusiType, 
		businode    : BusiNode,           //业务节点  
	}
	var BusiData = JSON.stringify(MianObj)
	var ret = tkMakeServerCall("PHA.IN.Budget.Client.Interface","SendBusiData",BusiData)
	var RetJson = JSON.parse(ret);
	var code = RetJson.code
	var msg = RetJson.msg
	if(code < 0 )
	{
		Msg.info("error",msg);
		return false;
	}
	else if(ret.code == 1)
	{
		Msg.info("warning",msg);
	}
	Msg.info("success","符合HRP预算控制");
	return true;
}
