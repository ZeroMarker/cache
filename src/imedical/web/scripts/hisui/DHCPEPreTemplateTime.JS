
//名称	DHCPEPreTemplateTime.js
//功能	时间段设置
//组件	DHCPEPreTemplateTime	
//创建	2018.09.04
//创建人  xy
function BodyLoadHandler()
{
	var obj;
	
	var tableWidth = $("#tDHCPEPreTemplateTime").parent().width();
	//alert(tableWidth)
    var  tableWidth=680;
    $("#tDHCPEPreTemplateTime").datagrid("getPanel").panel('resize',{width:tableWidth});

	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
}

//判断输入的字符串是否为非负整数
function isNumber(elem){
 var pattern= /^\d+$/;
 if(pattern.test(elem)){
  return true;
 }else{
  return false;
 }
}

function BUpdate_click()
{
	var obj,encmeth="";

	var Type=getValueById("Type");
	var ParRef=getValueById("ParRef");
	var ID=getValueById("ID");
	var StartTime=getValueById("StartTime");
	if (StartTime==""){
		$.messager.alert("提示","开始时间不能为空","info");
		return false;
	}
	var EndTime=getValueById("EndTime");
	if (EndTime==""){
		$.messager.alert("提示","结束时间不能为空","info");
		return false;
	}
	var Num=getValueById("Num");
	if (Num=="" || Num=="-"){
		MaleNum = 0;
		FemaleNum = 0;
	} else {
		MaleNum = Num.split("-")[0];
		FemaleNum = Num.split("-")[1];	
	}
if(Num.indexOf("-")<0){
		$.messager.alert("提示","数量维护格式不正确,格式应为：数量(男)-数量(女)，例如：10-20","info");
		return false;
		}
		 
   
 if(Num.indexOf("-")>=0){

	MaleNum = Num.split("-")[0];
	FemaleNum = Num.split("-")[1];
	if((MaleNum=="")||(MaleNum==undefined)||(FemaleNum=="")||(FemaleNum==undefined))
	 {
		  $.messager.alert("提示","数量维护格式不正确,格式应为：数量(男)-数量(女)，例如：10-20","info");
         return false;
	 }
	 
	if (!isNumber(MaleNum))
	{ 
		 $.messager.alert("提示","数量维护格式不正确,格式应为：数量(男)-数量(女)，例如：10-20","info");
        return false;
	}

	if(!isNumber(FemaleNum)) {
        $.messager.alert("提示","数量维护格式不正确,格式应为：数量(男)-数量(女)，例如：10-20","info");
        return false;
      }
    
   }

	var currentMale = 0;  ///可以预约人数
	var currentFemale = 0;
	obj=document.getElementById("SearchPeopleCount");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ParRef,Type);
	currentMale = (ret.split("-"))[0];
	currentFemale = (ret.split("-"))[1];
	if(currentMale == null || currentMale == "" || currentMale == undefined){
		currentMale = 0;	
	}
	if(currentFemale == null || currentFemale == "" || currentFemale == undefined){
		currentFemale = 0;	
	}
	currentMale = parseInt(currentMale);
	currentFemale = parseInt(currentFemale);

	var totalMaleNum = 0; ///分时段总人数
	var totalFemaleNum = 0;
	var rows;
	 var objtbl = $("#tDHCPEPreTemplateTime").datagrid('getRows');
    var rows=objtbl.length

		for (var i=0;i<rows;i++){
			
		var TID=objtbl[i].TID;
		var tobjMale=objtbl[i].TNumMale;
		var tobjFemale=objtbl[i].TNumFemale;
		tobjMale = parseInt(tobjMale);
		tobjFemale = parseInt(tobjFemale);
		if(TID != ID){
			totalMaleNum = totalMaleNum + tobjMale;
			totalFemaleNum = totalFemaleNum + tobjFemale;
		}
	}

	MaleNum = parseInt(MaleNum);
	FemaleNum = parseInt(FemaleNum);
	
	totalMaleNum = totalMaleNum + MaleNum;
	totalFemaleNum = totalFemaleNum + FemaleNum;
	
	if(totalMaleNum > currentMale){
		var balance = totalMaleNum - currentMale;
		$.messager.alert("提示","男性分时段总人数大于预约限额，更新失败！差额为："+balance+" 人","info");
		return false;		
	
	}
	
	if(totalFemaleNum > currentFemale){
		var balance = totalFemaleNum - currentFemale;
		$.messager.alert("提示","女性分时段总人数大于预约限额，更新失败！差额为："+balance+" 人","info");
		return false;	
		
	
	}
	
	
	var Info=StartTime+"^"+EndTime+"^"+MaleNum+"^"+FemaleNum;
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,ParRef,ID,Info);
	var ret=ret.split("^");
	if (ret[0]=="1"){
		$.messager.alert("提示","更新成功","success");
		 $("#tDHCPEPreTemplateTime").datagrid('load',{ComponentID:56124,Type:Type,ParRef:$("#ParRef").val()}); 
		//window.location.reload();
	}else if(ret[0]=="-1")
	{
		$.messager.alert("提示",ret[1],"info");
	}else{		
		$.messager.alert("提示","更新失败","error");
	}
}
/*
function BDelete_click()
{
	var obj,encmeth="";
	var Type=getValueById("Type");
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;	
	}
	obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,ID);
	if (ret=="0"){
		window.location.reload();
	}else{
	
		$.messager.alert("提示","删除失败:"+ret,"info");
	
	}
}
*/
function BDelete_click()
{
	var obj,encmeth="";
	var Type=getValueById("Type");
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("提示","请选择待删除的记录","info");
		return false;	
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.PreTemplate", MethodName:"DeleteTimeInfo",Type:Type,ID:ID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败:"+ret,"error");  
				}else{
					$.messager.alert("提示","删除成功","success"); 
					 $("#tDHCPEPreTemplateTime").datagrid('load',{ComponentID:56124,Type:Type,ParRef:$("#ParRef").val()}); 
					 $("#ID,#StartTime,#EndTime,#Num").val("");
					//window.location.reload(); 
					
				}
			});	
		}
	});
	
}



var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{
		var ID=rowdata.TID;
	    setValueById("ID",ID);
	    
		var StartTime=rowdata.TStartTime;
		setValueById("StartTime",StartTime);
		
		var EndTime=rowdata.TEndTime;
		setValueById("EndTime",EndTime);
		
		var MaleNum=rowdata.TNumMale;
		var FemaleNum=rowdata.TNumFemale;
		var num=MaleNum+"-"+FemaleNum;
		setValueById("Num",num);
		
	   
				
	}else
	{
		selectrow=-1;
		ClearValue();
	
	}	

}
function ClearValue()
{
	setValueById("ID","");
	setValueById("StartTime","");
	setValueById("EndTime","");
	setValueById("Num","");
	
}



document.body.onload = BodyLoadHandler;