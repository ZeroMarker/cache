$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //按钮初始化
    initButtonWidth();
    initInputStyle();
    getUniteBussNos();
    getDealBuss()
}

/// add by zx 2019-08-30
/// 根据原修改元素属性改变新值元素的属性
function initInputStyle()
{
	var inputType=getElementValue("InputType");
	switch (inputType) {
		case "5":
			// 日期类型增加样式并重新渲染
            $("#NewValue").addClass("hisui-datebox");
            $.parser.parse();
            break;
        case "9":
        	// 放大镜元素生成
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