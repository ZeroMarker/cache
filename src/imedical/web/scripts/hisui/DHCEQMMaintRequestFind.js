function BodyLoadHandler() 
{
	$("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQMMaintRequestFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui改造：隐藏翻页条内容
	InitUserInfo();	
	//SetBAddType();
	KeyUp("ExObj^RequestLoc");
	Muilt_LookUp("ExObj^RequestLoc");
	SetStatus();
	var obj=document.getElementById("BAdd");
	if(obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BAddNew");
	if(obj) obj.onclick=BAddNew_Clicked;
	SetBEnable()
	initButtonWidth();	//hisui改造 Add By DJ 2018-10-12
	initButtonColor(); //hisui改造 add by zyq 2023-01-31
	if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
	// 极简版
	$("#BAddNew").css({"background-color":"#28ba05","color":"#ffffff"})
	}
	initPanelHeaderStyle();//hisui改造 add by zyq 2023-01-31
	//SetBackGroupColor('tDHCEQMMaintRequestFind')	//Add By DJ 2015-08-17 DJ0156
	var NewFlag=GetElementValue("NewFlag")
	if (NewFlag=="1")
	{
		$('#Status').next(".combo").hide();
		HiddenObj("cStatus",1)
	}
	//add by CZF0075 2020-02-25 begin
	var TDetailObj=$('#tDHCEQMMaintRequestFind').datagrid('getColumnOption', 'TDetail');
    TDetailObj.formatter=function(value,row,index){
	    
		return '<a href="#" onclick=TDetail_Clicked("'+row.TRowID+'","'+row.TExObjDR+'","'+ row.TMaintType+'","'+ index +'","'+ row.TManageTypeDR+'");><img style="vertical-align: middle;" src="../images/../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" border="0"></a>'; //Modified By QW20211224
	}
	//add by CZF0075 2020-02-25 end
}

function BAddNew_Clicked()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) return;
	var url="dhceq.em.mmaintrequestsimple.csp?RowID=&Status=0&ExObjDR=&QXType="+GetElementValue("QXType");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}
function SetBAddType()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) {DisableBElement("BAdd",true);}
}
function GetRequestLocDR(value)
{
	GetLookUpID('RequestLocDR',value);
}
function GetExObj(value)
{
	GetLookUpID('ExObjDR',value);
	//alertShow(value);
}
//function GetModel(value)
//{
//	GetLookUpID('ModelDR',value);
//}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}

//add by CZF0075 2020-02-25
//详细点击事件
function TDetail_Clicked(RowID,ExObjDR,MaintType,index,ManageType)
{
	if (RowID=="") return;
	var Status=GetElementValue("Status");
	var CurRole=GetElementValue("ApproveRole");
	var MenuApproveRole=GetElementValue("MenuApproveRole");
	var EvaluateFlag=GetElementValue("EvaluateFlag");
	var EvaluateGroup=GetElementValue("EvaluateGroup");
	var ApproveRoleDR=GetElementValue("ApproveRole");
	var CheckPartFlag=GetElementValue("CheckPartFlag");
	var Action=GetElementValue("Action");
	var QXType=GetElementValue("QXType");
	var height="";
	var size="small"
	var src="dhceq.em.mmaintrequestsimple.csp?";
	//Modified By QW20211224
	var Data=tkMakeServerCall("web.DHCEQM.DHCEQMCManageType","GetData",ManageType);
	var Code=Data.split("^")[1];
	if (Code==2)
	{
		var src="dhceq.em.problemsimple.csp?";
	}else if (Code==3)
	{
		var src="dhceq.em.requirementsimple.csp?";
	}else if (Code==4)
	{
		var src="dhceq.em.hardwaremaintsimple.csp?";
	}else
	{
		if (MaintType==1)
		{
			size="large"
			///modified by ZY20230220 bug:   修改维修界面的csp链接
			src="dhceq.em.maintrequest.csp?";
		}
	}
	//Modified By QW20211224
	var str=src+"&RowID="+RowID+"&Status="+Status+"&ExObjDR="+ExObjDR+"&CurRole="+CurRole+"&MenuApproveRole="+MenuApproveRole+"&EvaluateFlag="+EvaluateFlag+"&EvaluateGroup="+EvaluateGroup+"&ApproveRoleDR="+ApproveRoleDR+"&CheckPartFlag="+CheckPartFlag+"&Action="+Action+"&QXType="+QXType+"&MaintType="+MaintType;
	showWindow(str,"设备维修单","",height,"icon-w-paper","modal","","",size);
}

document.body.onload = BodyLoadHandler;
