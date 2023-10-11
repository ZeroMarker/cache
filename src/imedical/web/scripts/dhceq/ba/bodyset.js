
$(function(){
	initDocument();
	//$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
    initMessage("ba"); //获取所有业务消息
    //initLookUp();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    initPartGroupList();  
    $('#PartGroup').combobox('options').onSelect=function(){
    	initPartList();
	}
}
///modified by ZY0284 20211123
function initPartGroupList()
{
	var ArcimRowid=$("#ServiceID").val()
	var BodyPartStr=tkMakeServerCall("web.DHCDocBodyPartSet","GetArcimMRCBodyGroup2",ArcimRowid)
	if (BodyPartStr=="")
	{
		alertShow("该服务项无需维护部位信息!");
		disableElement("BSave",true);
		return;

	}
	else
	{
		//var BodyPartStr="tou!1^ssd!2"
		var data=[];
		var BodyPartStr=BodyPartStr.split("^")
		for(var i=0;i<BodyPartStr.length;i++){
			var oneDataArr=	BodyPartStr[i].split("!")
			data.push({'id':oneDataArr[0],'text':oneDataArr[1]})
		}
		$('#PartGroup').combobox({
		    url:null,
		    valueField:'id',  
		    textField:'text', 
		    data:data

		    });	
	}
}

function initPartList()
{
	var ArcimRowid=$("#ServiceID").val()
	var BodyValue=$("#PartGroup").combobox("getValue")
	//alert("BodyValue"+BodyValue)
	var BodyStr=tkMakeServerCall("web.DHCDocBodyPartSet","GetBodyByGroup",ArcimRowid,BodyValue)
	//var BodyStr="tou!1^ssd!2"
	var partdata=[];
	var BodyStr=BodyStr.split("^")
	for(var i=0;i<BodyStr.length;i++){
		var oneDataArr=	BodyStr[i].split("!")
		partdata.push({'id':oneDataArr[0],'text':oneDataArr[1]})
	}	
    $('#Part').combobox({
		url:null,
		valueField:'id',  
		textField:'text', 
		data:partdata
	});	
	$('#Part').combobox('options').onSelect=function(){
		initCheckMethodList(); 
		initCheckExecList(); 				
	}

}

function initCheckMethodList()
{
	var ArcimRowid=$("#ServiceID").val()
	var PartValue=$("#Part").combobox("getValue")
	PartStr=tkMakeServerCall("web.DHCDocBodyPartSet","GetCheckLimitByPart",ArcimRowid,PartValue)
	//var PartStr="tou!1^ssd!2"
	PartStrArr=PartStr.split(",")

	PartStr=PartStrArr[0]
	//CheckExecStr=PartStrArr[1]
	var checkmethoddata=[];
	checkmethoddata.push({'id':'','text':'无'})
	var PartStr=PartStr.split("^")
	for(var i=0;i<PartStr.length;i++){
		var oneDataArr=	PartStr[i].split("!")
		checkmethoddata.push({'id':oneDataArr[0],'text':oneDataArr[1]})
	}	
    $('#CheckMethod').combobox({
        url:null,
        valueField:'id',  
        textField:'text', 
        data:checkmethoddata
	});	
}
function initCheckExecList()
{
	var ArcimRowid=$("#ServiceID").val()
	var PartValue=$("#Part").combobox("getValue")
	PartStr=tkMakeServerCall("web.DHCDocBodyPartSet","GetCheckLimitByPart",ArcimRowid,PartValue)
	//var PartStr="tou!1^ssd!2"
	PartStrArr=PartStr.split(",")
	PartStr=PartStrArr[1]
	var checkexecdata=[];
	checkexecdata.push({'id':'','text':'无'})
	var PartStr=PartStr.split("^")
	for(var i=0;i<PartStr.length;i++){
		var oneDataArr=	PartStr[i].split("!")
		checkexecdata.push({'id':oneDataArr[0],'text':oneDataArr[1]})
	}	
    $('#CheckExec').combobox({
        url:null,
        valueField:'id',  
        textField:'text', 
        data:checkexecdata

    });	
}

function BSave_Clicked()
{
	var RowID=$("#RowID").val()
	var PartValue=$("#Part").combobox("getValue")
	var PartDesc=$("#Part").combobox("getText")
	var CheckMethodValue=$("#CheckMethod").combobox("getValue")
	var CheckMethodDesc=$("#CheckMethod").combobox("getText")
	var CheckExecValue=$("#CheckExec").combobox("getValue")
	var CheckExecDesc=$("#CheckExec").combobox("getText")
	
	if ((PartValue=="")&&((CheckMethodValue=="")||(CheckExecValue=="")))
	{
		alertShow("请填写部位,检查方法或检查处理信息！")
		return;
	}
	if ((CheckExecValue!="")&&(CheckMethodValue!=""))
	{
		alertShow("检查方法,检查处理只填写一项信息！")
		return;
	}
	if ((CheckExecValue!="")&&(CheckMethodValue==""))
	{	
		var CheckMethodValue=CheckExecValue
	}
	var CheckDealValue=""
	var SubKey=PartValue+","+CheckMethodValue+","+CheckDealValue
	Result=tkMakeServerCall("web.DHCEQCServiceConsumable","SavePartData",RowID,SubKey)
	var Result=Result.split("^");
	if (Result[0]==0)
	{
		alertShow("更新成功！")
		var val="&ServiceID="+ArcimRowid;
		val=val+"&Part="+PartValue;
		val=val+"&CheckMethod="+CheckMethodValue;
		val=val+"&PartDR="+PartDesc;
		val=val+"&CheckMethodDR="+CheckMethodDesc;
		url="dhceq.ba.bodyset.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.reload(url);
	}
	else
	{
		alertShow("更新失败！")
		return;	
	}
	
}
