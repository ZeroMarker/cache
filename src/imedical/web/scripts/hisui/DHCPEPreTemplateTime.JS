
//����	DHCPEPreTemplateTime.js
//����	ʱ�������
//���	DHCPEPreTemplateTime	
//����	2018.09.04
//������  xy
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

//�ж�������ַ����Ƿ�Ϊ�Ǹ�����
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
		$.messager.alert("��ʾ","��ʼʱ�䲻��Ϊ��","info");
		return false;
	}
	var EndTime=getValueById("EndTime");
	if (EndTime==""){
		$.messager.alert("��ʾ","����ʱ�䲻��Ϊ��","info");
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
		$.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ������(��)-����(Ů)�����磺10-20","info");
		return false;
		}
		 
   
 if(Num.indexOf("-")>=0){

	MaleNum = Num.split("-")[0];
	FemaleNum = Num.split("-")[1];
	if((MaleNum=="")||(MaleNum==undefined)||(FemaleNum=="")||(FemaleNum==undefined))
	 {
		  $.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ������(��)-����(Ů)�����磺10-20","info");
         return false;
	 }
	 
	if (!isNumber(MaleNum))
	{ 
		 $.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ������(��)-����(Ů)�����磺10-20","info");
        return false;
	}

	if(!isNumber(FemaleNum)) {
        $.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ������(��)-����(Ů)�����磺10-20","info");
        return false;
      }
    
   }

	var currentMale = 0;  ///����ԤԼ����
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

	var totalMaleNum = 0; ///��ʱ��������
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
		$.messager.alert("��ʾ","���Է�ʱ������������ԤԼ�޶����ʧ�ܣ����Ϊ��"+balance+" ��","info");
		return false;		
	
	}
	
	if(totalFemaleNum > currentFemale){
		var balance = totalFemaleNum - currentFemale;
		$.messager.alert("��ʾ","Ů�Է�ʱ������������ԤԼ�޶����ʧ�ܣ����Ϊ��"+balance+" ��","info");
		return false;	
		
	
	}
	
	
	var Info=StartTime+"^"+EndTime+"^"+MaleNum+"^"+FemaleNum;
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,ParRef,ID,Info);
	var ret=ret.split("^");
	if (ret[0]=="1"){
		$.messager.alert("��ʾ","���³ɹ�","success");
		 $("#tDHCPEPreTemplateTime").datagrid('load',{ComponentID:56124,Type:Type,ParRef:$("#ParRef").val()}); 
		//window.location.reload();
	}else if(ret[0]=="-1")
	{
		$.messager.alert("��ʾ",ret[1],"info");
	}else{		
		$.messager.alert("��ʾ","����ʧ��","error");
	}
}
/*
function BDelete_click()
{
	var obj,encmeth="";
	var Type=getValueById("Type");
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;	
	}
	obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,Type,ID);
	if (ret=="0"){
		window.location.reload();
	}else{
	
		$.messager.alert("��ʾ","ɾ��ʧ��:"+ret,"info");
	
	}
}
*/
function BDelete_click()
{
	var obj,encmeth="";
	var Type=getValueById("Type");
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;	
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.PreTemplate", MethodName:"DeleteTimeInfo",Type:Type,ID:ID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��:"+ret,"error");  
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ�","success"); 
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