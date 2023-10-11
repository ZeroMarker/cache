//scripts/pha/in/v3/Budget/Store.js
var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

var _BudgetSaveFlag  = ""
var _BudgetCompFlag  = ""
var _BudgetAuditFlag = ""

var BudgetProStore = new Ext.data.SimpleStore({
    fields: ['RowId', 'Description'],
    data: [
        ['', 'HRPԤ��ϵͳ�ӿ���δ��ͨ��������']
    ]
});


// Ԥ����Ŀ
 var BudgetProComb = new Ext.form.ComboBox({
    fieldLabel: 'Ԥ����Ŀ',
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


///nodeArr ҵ��ڵ����� 1,2,3 �ֱ���� ����/���/��ˣ���Ҫ��֤�Ǽ����ʹ��ļ��������� ��֤ ����+��� ��[1,3]
function SetBudgetPro(Loc,BusiType,nodeArr,limitButton)
{
	var BudgetFlag = PurPlanParam.Budget
	if (BudgetFlag != "Y") 
	{
		Ext.getCmp("BudgetProComb").hide();
		return;
	}
	///���Կ��ؽӿڣ��������Կ����ȷſ���������
	Msg.info("warning","HRPԤ��ϵͳ����:�ӿ���δ��ͨ������");
	return;
	
	if (Loc == "") 
	{
		Msg.info("warning","HRPԤ��ϵͳ����:����Ԥ����Ŀ���Ҳ���Ϊ��");
		return;
	}
	var ParamsObj = {
		loc_id      : Loc,           //����id
		business    : BusiType       //ҵ������
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
		Msg.info("warning","HRPԤ��ϵͳ����:����ЧԤ�����");
		Ext.getCmp(limitButton).disable();
		return;
	}
	BudgetProStore.loadData(_BudgetProject)

}

/// ��֤�����ҵ��ڵ��Ƿ���Ҫ����
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


/// ����ҵ������
function SendBusiData(Pointer,BusiType,BusiNode)
{
	if(!Pointer){
		Msg.info("warning","�˶�HRPԤ��������Ҫҵ���ID");
		return false;
	}
	if(!BusiType){
		Msg.info("warning","�˶�HRPԤ��������Ҫҵ������");
		return false;
	}
	if(!BusiNode){
		Msg.info("warning","�˶�HRPԤ��������Ҫҵ��ڵ�����");
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
		Msg.info("warning","����������˶�HRPԤ��ϵͳ����ѡ��һ��Ԥ����Ŀ!");
		return false;
	}
	var MianObj = {
		project_id  : budgetId,        //��Ŀid
		main_id     : Pointer,			//ҵ������id
		business	: BusiType, 
		businode    : BusiNode,           //ҵ��ڵ�  
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
	Msg.info("success","����HRPԤ�����");
	return true;
}
