function BodyLoadHandler() 
{
	$("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-���� ȥ��y�� ������
	$("#tDHCEQMMaintRequestFind").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui���죺���ط�ҳ������
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
	initButtonWidth();	//hisui���� Add By DJ 2018-10-12
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
	    
		return '<a href="#" onclick=TDetail_Clicked("'+row.TRowID+'","'+row.TExObjDR+'","'+ row.TMaintType+'","'+ index +'");><img style="vertical-align: middle;" src="../images/../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" border="0"></a>';
	}
	//add by CZF0075 2020-02-25 end
}

function BAddNew_Clicked()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) return;
	window.location.href= "dhceq.em.mmaintrequestsimple.csp?RowID=&Status=0&ExObjDR=&QXType="+GetElementValue("QXType");
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
//��ϸ����¼�
function TDetail_Clicked(RowID,ExObjDR,MaintType,index)
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
	if (MaintType==1)
	{
		size="large"
		src="dhceq.em.mmaintrequest.csp?";
	}
	var str=src+"&RowID="+RowID+"&Status="+Status+"&ExObjDR="+ExObjDR+"&CurRole="+CurRole+"&MenuApproveRole="+MenuApproveRole+"&EvaluateFlag="+EvaluateFlag+"&EvaluateGroup="+EvaluateGroup+"&ApproveRoleDR="+ApproveRoleDR+"&CheckPartFlag="+CheckPartFlag+"&Action="+Action+"&QXType="+QXType+"&MaintType="+MaintType;
	showWindow(str,"�豸ά�޵�","",height,"icon-w-paper","modal","","",size);
}

document.body.onload = BodyLoadHandler;