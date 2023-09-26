//����	DHCPEGiftManager.js
//����	��Ʒ����
//���	DHCPEGiftManager	
//����	2018.08.23
//������  xy

function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	obj=document.getElementById("BSend");
	if (obj){obj.onclick=BSend_click;}
	
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}
	
	obj=document.getElementById("RegNo");
	if (obj) {
		obj.onkeydown=RegNo_keydown;
	}

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }
	
}

function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
	var obj=document.getElementById("GroupDesc");
	if (obj) { obj.value=""; }

}
function AfterGroupSelected(value){
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("GroupID",aiList[0],true);
	SetCtlValueByID("GroupDesc",aiList[1],true);
	
}
function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}


function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}

function BSend_click()
{	
    var objtbl=$("#tDHCPEGiftManager").datagrid('getRows');
    if(selectrow=="-1"){
		$.messager.alert("��ʾ","��ѡ������ŵ���","info");
	     return false;
	     }
	var TPEADMID=objtbl[selectrow].TPEADM;
	if (TPEADMID=="")
	{
		$.messager.alert("��ʾ","��ѡ������ŵ���","info");
		return false;	
	}
	Update("0",TPEADMID);
	return false;
}

function Update(Type,TPEADMID)
{
	var obj=document.getElementById("UpdateClass");
	var encmeth="";
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var GiftName="";
	var obj=document.getElementById("GiftName");
	if (obj) GiftName=obj.value;
	if (GiftName=="")
	{
		$.messager.alert("��ʾ","��Ʒ����Ϊ��","info");
		return false;
	}
	var ReturnStr=cspRunServerMethod(encmeth,TPEADMID,Type,GiftName);
	if (ReturnStr=="Success")
	{
		$.messager.popover({msg: "��Ʒ���ųɹ�", type: "info"});
		BFind_click();
		return true;
	}
	if (ReturnStr=="HadGift")
	{
		$.messager.confirm("ȷ��", "�Ѿ�������Ʒ���Ƿ��ٴη��ţ�", function(r){
		if (r){
				Update("1",TPEADMID)
			}
		});
		
	}

	//alert(t[ReturnStr]);
	return false;
}
function BFind_click()
{
	var BeginDate="",EndDate="",GroupID="",RegNo="",GiftFlag="0",GiftName="";
	var BeginDate=getValueById("BeginDate")
	var EndDate=getValueById("EndDate")	
	var GroupID=getValueById("GroupID")
	var RegNo=getValueById("RegNo")
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	if (RegNo.length<RegNoLength&&RegNo.length>0) {
		RegNo=RegNoMask(RegNo);
		$("#RegNo").val(RegNo)
		}
	var GiftName=getValueById("GiftName")
	var GiftFlag=getValueById("GiftFlag")
	if(GiftFlag){GiftFlag="1";}
	else{GiftFlag="0";}

	var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEGiftManager"            //+targeURL
    +"&BeginDate="+BeginDate
    +"&EndDate="+EndDate
    +"&GroupID="+GroupID
    +"&RegNo="+RegNo
    +"&GiftFlag="+GiftFlag
	+"&GiftName="+GiftName		
		;

	//location.href=lnk;
	$("#tDHCPEGiftManager").datagrid('load',{ComponentID:55966,BeginDate:BeginDate,EndDate:EndDate,GroupID:GroupID,RegNo:RegNo,GiftFlag:GiftFlag,GiftName:GiftName});
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var TPEADMID=rowdata.TPEADM;
		
	}else
	{
		selectrow=-1;
	
	}

}

document.body.onload = BodyLoadHandler;