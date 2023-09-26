//名称	DHCPEPreIADMReplace.js
//功能	病人基本信息替换
//组件  DHCPEPreIADMReplace	
//创建	2018.08.30
//创建人  xy

function BodyLoadHandler() {
   
	var obj;

	Info();

	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	
	obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	
	
	obj=document.getElementById("RegNo");
	if (obj){
		obj.onchange=RegNo_change;
	}
	
 
	$("#RegNo").keydown(function (e) {
		RegNo_keydown(e);
	});
}
function Info(){
	var HospID=session['LOGON.HOSPID']
	var PreIADM=$("#PreIADM").val()
	var BaseInfo=tkMakeServerCall("web.DHCPE.PreIADMReplace","GetPreInfo",PreIADM,HospID);
	var Arr=BaseInfo.split("^");
		
	$("#Status").val(Arr[0]);
	$("#GDesc").val(Arr[1]);
	$("#TeamDesc").val(Arr[2]);
	$("#VIPLevel").val(Arr[3]);
	$("#HPNo").val(Arr[4]);
	$("#OldPatID").val(Arr[6]);
	$("#OldRegNo").val(Arr[7]);
	$("#OldName").val(Arr[8]);
	$("#OldSex").val(Arr[9]);
	$("#OldMarital").val(Arr[10]);
	$("#OldIDCard").val(Arr[11]);		
	
} 

function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		RegNo_change();
	}
}

function RegNo_change()
{
	var obj,RegNo="",encmeth="";
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var RegNo=$("#RegNo").val();
	if(RegNo==""){
		// $.messager.popover({msg: "替换后的信息不能为空,请输入替换人的登记号按回车", type: "info"});
		return false;
	}
	if (RegNo.length<RegNoLength && RegNo.length>0) { 
			RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
			$("#RegNo").val(RegNo)
		};
   
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",RegNo)
	
	
	var HospID=session['LOGON.HOSPID']	
	var BaseInfo=tkMakeServerCall("web.DHCPE.PreIADMReplace","GetBaseInfoByRegNo",RegNo,HospID)
	var Arr=BaseInfo.split("^");
	obj=document.getElementById("PatID");
	if (obj) obj.value=Arr[0];
	obj=document.getElementById("RegNo");
	if (obj) obj.value=Arr[1];
	obj=document.getElementById("Name");
	if (obj) obj.value=Arr[2];
	obj=document.getElementById("Sex");
	//if (obj) obj.value=Arr[3].split("")[0];
	if((Arr[3]==""&&obj)) obj.value="";
	//if (obj&&Arr[3]!="") obj.value=Arr[3];
	if ((obj&&Arr[3]!="")&&(flag!="G")) obj.value=Arr[3];
	obj=document.getElementById("Marital");
	if (obj) obj.value=Arr[4];
	obj=document.getElementById("IDCard");
	if (obj) obj.value=Arr[5];
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function BSave_click() { 
    var obj,PreIADM="",RegNo="",Remark="",encmeth="";
    obj=document.getElementById("PreIADM");
    if (obj) PreIADM=obj.value;
    obj=document.getElementById("RegNo");
    if (obj) RegNo=obj.value;
    if (""==RegNo) {
		obj=document.getElementById("RegNo")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		
		$.messager.alert("提示","替换后的信息不能为空,请输入替换人的登记号按回车","info");
		return false;
	}
   var OldRegNo=$("#OldRegNo").val()
    if(OldRegNo==RegNo){
	    $.messager.alert("提示","替换后的登记号与替换前的登记号相同","info");
	    return false    
    }
	var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",RegNo)
	if(flag=="G"){
		$.messager.alert("提示","该登记号属于团体信息,不能替换","info");
	    	return false;
		}
    obj=document.getElementById("Remark");
    if (obj) Remark=obj.value;
    var UserID=session['LOGON.USERID'];
    var Str=PreIADM+"^"+RegNo+"^"+Remark+"^"+UserID;
    var ret=tkMakeServerCall("web.DHCPE.PreIADMReplace","Save",Str);
    var Arr=ret.split("^");
   
     if (Arr[0]<0){
	    alert(Arr[1])
	    return false;
    }else{
	     $.messager.alert("提示","替换成功","success",function(){
		    parent.document.TRAK_main.$("#tDHCPEPreIADM_Find").datagrid("reload");
		    location.reload();
	    });
	
    }

   // if (opener) opener.location.reload();
   // BClose_click();
}
function BClose_click()
{
	//if (opener) opener.location.reload();
	window.close();
}

document.body.onload = BodyLoadHandler;