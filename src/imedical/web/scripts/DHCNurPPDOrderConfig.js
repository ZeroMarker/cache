var CONST_HOSPID=""; 

function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	CONST_HOSPID=getHospID();
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurPPDOrderConfig&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}
function BodyLoadHandler()
{
	//alert('ssss');
	//var obj=document.getElementById("btnup");
    //if (obj){obj.onclick=upcos;}
	var obj=document.getElementById('Add');
	if(obj) obj.onclick=ADD_click;
	var BtnSave=document.getElementById('BtnSave');
	if(BtnSave) BtnSave.onclick=BtnSave_click;
	CONST_HOSPID=getHospID();
	
}
function ADD_click(){
	//alert("test");
	var obj=document.getElementById("arcimrow");
	var obj1=document.getElementById("arcimDesc");
	var configValue = document.getElementById("ConfigStr");
	if (obj)
	{
		var arcimId = obj.value;
		var arcimDesc=obj1.value;
		if(configValue.value==""){
			configValue.value=arcimDesc;
		}else{
			configValue.value+="^"+arcimDesc;
		}
		if(arcimId==""){
			alert("请选择医嘱项!");
			return;
		}
		tkMakeServerCall("web.DHCNurSkinTestList", "InsertPPDConfig",arcimId,CONST_HOSPID);
		//alert("sc");
	}		
	
	//=strValue[1];
	
}
//孙肖肖修改
function BtnSave_click(){
	var configValue = document.getElementById("ConfigStr");
	if(configValue.value==""){
		alert("无可删除数据")
		}else{
		var r=confirm("确认删除?");	
		if (r==true)
		{
				//var configValue = document.getElementById("ConfigStr");
				var ret = tkMakeServerCall("web.DHCNurSkinTestList", "UpdatePPDConfig","",CONST_HOSPID);//configValue.value
				if(ret==0){		
				configValue.value="";
				alert("删除成功！");
				}	
		}	
	}
	
	
}
function LookUpMasterItem(value){
var temp
 temp=value.split("^")
 arcimId=temp[1]
 document.getElementById('arcimrow').value=arcimId
}

function GetAppArcimId1(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("arcimDesc");
	if (obj) obj.value=strValue[0];
	var obj=document.getElementById("arcimrow");
	if (obj) obj.value=strValue[1];
}

document.body.onload = BodyLoadHandler;