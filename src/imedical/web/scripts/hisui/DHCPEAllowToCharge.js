
//����	DHCPEAllowToCharge.js
//���  DHCPEAllowToCharge
//����	�����ѹ���
//����	2018.09.11
//������  xy
function BodyLoadHandler(){
	var obj;
    
    //����
	obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }
	
	//����
	obj=document.getElementById("Save");
	if (obj) { obj.onclick=Save_Click; }
	
	//��ѯ
	obj=document.getElementById("btnQuery");
	if (obj) { obj.onclick=btnQuery_Click; }
	
		
    ///ȫѡ
	$('#SelectALL').checkbox({
		onCheckChange:function(e,vaule){
			SelectALL_Click(vaule);
			
			}
			
	});
	
	
	obj=document.getElementById("txtGroupName");
	if (obj) { obj.onchange=GroupName_Change; }
	
	obj=document.getElementById("txtItemName");
	if (obj) { obj.onchange=ItemName_Change; }
	
	obj=document.getElementById("txtAdmNo");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	
	obj=document.getElementById("txtPatName");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
    
	websys_setfocus("txtAdmNo");
	
	
}
function GroupName_Change()
{
	var obj=document.getElementById("txtGroupId");
	if (obj) { obj.value=""; }
}
function ItemName_Change()
{
	var obj=document.getElementById("txtItemId");
	if (obj) { obj.value=""; }
}

function Reg_No_keydown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		btnQuery_Click();
	}
}


function btnQuery_Click()
{ 

	var itxtPatName=getValueById("txtPatName");
	var itxtGroupId=getValueById("txtGroupId");
	var itxtAdmDate=getValueById("txtAdmDate");
	var itxtAdmNo=getValueById("txtAdmNo");
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	if (itxtAdmNo.length<RegNoLength&&itxtAdmNo.length>0) { itxtAdmNo=RegNoMask(itxtAdmNo);}
	var itxtItemId=getValueById("txtItemId");
	var iEndDate=getValueById("EndDate");
	var iHadAllowed=getValueById("HadAllowed");
	if(iHadAllowed){var iHadAllowed=1;}
	else{var iHadAllowed=0;}
	var iShowGroup=getValueById("ShowGroup");
	if(iShowGroup){var iShowGroup=1;}
	else{var iShowGroup=0;}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEAllowToCharge"
			+"&txtPatName="+itxtPatName
			+"&txtGroupId="+itxtGroupId
			+"&txtAdmDate="+itxtAdmDate
			+"&txtAdmNo="+itxtAdmNo
			+"&txtItemId="+itxtItemId
			+"&EndDate="+iEndDate
			+"&HadAllowed="+iHadAllowed
			+"&ShowGroup="+iShowGroup
           ;
           // alert(lnk)
    location.href=lnk; 
}

function Clear_click(){
	
	 setValueById("txtAdmNo","");
	 setValueById("txtGroupName","");
	 setValueById("txtGroupId","");
	 setValueById("txtItemName","");
	 setValueById("txtItemId","");
	 setValueById("txtPatName","");
	 setValueById("txtAdmDate","");
	 setValueById("EndDate","");	
	 $(".hisui-checkbox").checkbox('setValue',false);
	 btnQuery_Click(); 


}

function Save_Click()
{ 
  var objtbl = $("#tDHCPEAllowToCharge").datagrid('getRows');
	var Strings=GetAllowString();
	//alert(Strings)
	if (Strings=="") 
	{ 
	   $.messager.alert("��ʾ","����ѡ������õļ�¼","info");
		return false;
		}
	if (Strings=="") return;
	var encmethobj=document.getElementById("AllowToCharge");
	if (encmethobj) var encmeth=encmethobj.value;
	var Type="Person"
	
	var iGFlag=objtbl[0].TGDesc	;
	if(iGFlag=="��") {Type="Group";}
	//alert(Strings+"Type:"+Type)
	var ReturnStr=cspRunServerMethod(encmeth,Strings,Type);
	$.messager.alert("��ʾ","�޸ĳɹ�","success");
	
}
function GetAllowString()
{
	var retStr="";
	var objtbl = $("#tDHCPEAllowToCharge").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		var  pADM=objtbl[i].TPEIAdmId;
		var TSeclect=getCmpColumnValue(i,"TSeclect","DHCPEAllowToCharge");
	    if (TSeclect=="1"){var allowFlag="1";} 
	    else{var allowFlag="0"; }
	    if (retStr=="")
		{
			retStr=pADM+"^"+allowFlag;
		}
		else
		{
			retStr=retStr+"&"+pADM+"^"+allowFlag;
		}	
	}


	return retStr
}

//ȥ���ַ������˵Ŀո�
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function AfterGroupSelected(value){
	
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[0],true);
	SetCtlValueByID("txtGroupName",aiList[1],true);
	
}

function AfterItemSelected(value){
	if (""==value){return false}
	
	var aiList=value.split("^");
	SetCtlValueByID("txtItemId",aiList[1],true);
	SetCtlValueByID("txtItemName",aiList[0],true);
	
}

function SelectALL_Click(value)
{

	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl = $("#tDHCPEAllowToCharge").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		setColumnValue(i,"TSeclect",SelectAll)
	
	}	
}


document.body.onload = BodyLoadHandler;
