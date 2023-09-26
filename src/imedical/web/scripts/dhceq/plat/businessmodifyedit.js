$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
    initButtonWidth();
    initInputStyle();
    getUniteBussNos();
    getDealBuss()
}

/// add by zx 2019-08-30
/// ����ԭ�޸�Ԫ�����Ըı���ֵԪ�ص�����
function initInputStyle()
{
	var inputType=getElementValue("InputType");
	switch (inputType) {
		case "5":
			// ��������������ʽ��������Ⱦ
            $("#NewValue").addClass("hisui-datebox");
            $.parser.parse();
            break;
        case "9":
        	// �Ŵ�Ԫ������
            var inputProperty=getElementValue("InputProperty");
    		if (inputProperty=="") return;
    		singlelookup("NewValue",inputProperty);
            break;
     	default:
            break;
    }
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="NewValue") {setElement("NewValueDR",rowData.TRowID)}
}

function BSave_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var inputID=getElementValue("InputID");
	var newValue=getElementValue("NewValue");
	if (getElementValue("InputType")=="9") newValue=getElementValue("NewValueDR");
	var dealTypes=getDealBuss();
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","UpdateBusinessByType",bussType,bussID,inputID,newValue,mainFlag,dealTypes);
	var RtnObj=JSON.parse(jsonData)
	if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    else
    {
		websys_showModal("options").mth(inputID,newValue);
		closeWindow('modal');
    }
}

function getUniteBussNos()
{
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var inputID=getElementValue("InputID");
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBBusinessModify","GetUniteBuss",bussType,bussID,inputID,mainFlag);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;};
	for (var key in jsonData.Data)
	{
		$("#"+key).text(jsonData.Data[key]);
		$("#"+key).parent().css('display','block');
		$("#"+key).parent().find(".hisui-checkbox").checkbox("setValue",true);
	}
}

function getDealBuss()
{
	var bussTypes="";
	$(":checkbox").each(function(){
		var obj=$(this)
		if (obj.checkbox("getValue"))
		{
			if (bussTypes!="") bussTypes=bussTypes+",";
			bussTypes=bussTypes+obj.parent().parent().attr("id");
		}
	});
	return bussTypes;
}