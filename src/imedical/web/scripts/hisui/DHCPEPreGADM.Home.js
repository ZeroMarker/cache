
//����	DHCPEPreGADM.Home.js
//����	��������
//���	DHCPEPreGADM.Home	
//����	2018.09.04
//������  xy

document.body.onload=BodyLoaderHandler;
function BodyLoaderHandler() {
	var obj;
	
	//����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }

	//ɾ��
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//���� 
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=ClearValue; }
	
}

function Update_click(){
	var DrId=getValueById("PGADMDr");
	if(DrId==""){
		return false;
		}
	
	
	var Type=getValueById("Type");
	DrId=DrId+"^"+Type;
	var iRemark=getValueById("Remark");
	var RowId=getValueById("RowId");
	var BeginDate=getValueById("BeginDate");
	var EndDate=getValueById("EndDate");
	if(BeginDate == "" || BeginDate == null
		|| EndDate == "" || EndDate == null){
		$.messager.alert("��ʾ","��ʼ�������������Ϊ�����","info");
		return false;
	}
	var BeginDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",BeginDate);
	var EndDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate);
	if(Type=="C"){
		var value=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",getValueById("PGADMDr"));
		var SighDate=value.split("^")[3];
		 if(SighDate!=""){var SighDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",SighDate);}
		 if(BeginDateLogical<SighDate){
			$.messager.alert("��ʾ","��ʼ���ڲ���С�ں�ͬǩ������","info");
			return false;
		}
   }

    if(EndDateLogical<SighDate){
	   $.messager.alert("��ʾ","�������ڲ���С�ں�ͬǩ������","info");
	    return false;
   }
	var Num=getValueById("Num");
	if(Num.indexOf("-")<=-1){
		$.messager.alert("��ʾ","ÿ��������ʽӦΪ��ÿ������(��)-ÿ������(Ů)��:���硰10-10��","info");
	    return false;
	    }

	if(Num.indexOf("-")>=0)
	   {
		   
		   var Data=Num.split("-");
			if((Data[0]=="")||(Data[1]=="")){
			    $.messager.alert("��ʾ","ÿ������-ǰ��ӦΪ����","info");
			    return false;
		   }
		   
		   var reg = /^[0-9]+.?[0-9]*$/; 
		   if(!(reg.test(Data[1]))||!(reg.test(Data[0]))) 
		   {
			   $.messager.alert("��ʾ","ÿ������-ǰ��ӦΪ����","info");
			    return false; 
		   }
	   }

	if(Num == "" || Num == null || Num == undefined || Num == "-"){
		$.messager.alert("��ʾ","��������Ϊ�գ�","info");
		return false;
	}
	var ins = document.getElementById('UpdateClass');
	var methodAddress;
	if(ins){
		methodAddress = ins.value;	
	} else {
		methodAddress = '';
	}
     
     //alert(DrId+"^"+RowId+"^"+BeginDate+"^"+EndDate+"^"+Num+"^"+iRemark)
	var rnt = cspRunServerMethod(methodAddress,DrId,RowId,BeginDate,EndDate,Num,iRemark);
	if(rnt == "1"){
		$.messager.alert("��ʾ","�����е������������ص�������ʧ�ܣ�","info");
	} else if(rnt == "2"){
		$.messager.alert("��ʾ","���������󣬸���ʧ�ܣ�","info");
	} else if (rnt == "4"){
		$.messager.alert("��ʾ","��ʼ���ڲ������ڽ������ڣ�����ʧ�ܣ�","info");
	}else if (rnt == "5"){
		$.messager.alert("��ʾ","�������ڲ��ܴ��������ԤԼʱ�䣬����ʧ�ܣ�","info");
	}else if (rnt == "8"){
		$.messager.alert("��ʾ","��ʼ���ڲ���С�������ԤԼʱ�䣬����ʧ�ܣ�","info");
	}else if (rnt == "6"){
		$.messager.alert("��ʾ","������������С���������Գ�Ա����������ʧ�ܣ�","info");
	}else if (rnt == "7"){
		$.messager.alert("��ʾ","����Ů������С������Ů�Գ�Ա����������ʧ�ܣ�","info");
	}else if (rnt == "3"){
		$.messager.alert("��ʾ","���³ɹ�","success");
		$("#tDHCPEPreGADM_Home").datagrid('load',{ComponentID:56439,PGADMDr:$("#PGADMDr").val(),Type:$("#Type").val()});
		//window.location.reload();
	} 


}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{
		var HomeRowID=rowdata.THomeRowID;
	    setValueById("RowId",HomeRowID);
	    
		var Date=rowdata.TDate;
		setValueById("BeginDate",Date);
		
		var Date=rowdata.TDate;
		setValueById("EndDate",Date);
		
		var MaleNum=rowdata.TMaleNum;
		var FemaleNum=rowdata.TFemaleNum;
		var num=MaleNum+"-"+FemaleNum;
		setValueById("Num",num);
		
	   var Remark=rowdata.TRemark;
	   setValueById("Remark",Remark);
				
	}else
	{
		selectrow=-1;
		ClearValue();
	
	}	

}


/*
function Delete_click(){
	var RowId = document.getElementById('RowId').value;
	if(RowId == null || RowId=="" || RowId==undefined){
		$.messager.alert("��ʾ","��ѡ���ɾ��������","info");
		return false;	
	}
	var ins = document.getElementById('DeleteClass');
	var methodAddress;
	if(ins){
		methodAddress = ins.value;	
	} else {
		methodAddress = '';
	}
	var rnt = cspRunServerMethod(methodAddress,RowId);
	if(rnt == "1"){
		$.messager.alert("��ʾ","���ݲ����ڣ�ɾ��ʧ��","info");	
	} else if(rnt == "2"){
		$.messager.alert("��ʾ","����������ɾ��ʧ��","info");
	} else if (rnt == "3"){
		$.messager.alert("��ʾ","ɾ���ɹ�","success");
		window.location.reload();
	}
}
*/
function Delete_click(){
	var RowId = document.getElementById('RowId').value;
	if(RowId == null || RowId=="" || RowId==undefined){
		$.messager.alert("��ʾ","��ѡ���ɾ��������","info");
		return false;	
	}
	
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.PreHome", MethodName:"DeleteMethod",RowId:RowId},function(ReturnValue){
				if (ReturnValue=='1') {
					$.messager.alert("��ʾ","���ݲ����ڣ�ɾ��ʧ��","error");  
				}else if((ReturnValue=='2')){
					$.messager.alert("��ʾ","����������ɾ��ʧ��","error"); 
				}else if((ReturnValue=='3')){
					$.messager.alert("��ʾ","ɾ���ɹ�","success"); 
					 $("#tDHCPEPreGADM_Home").datagrid('load',{ComponentID:56439,PGADMDr:$("#PGADMDr").val(),Type:$("#Type").val()}); 
					 $("#RowId").val("");
					  ClearValue()
					
				}
			});	
		}
	});
	
}
function ClearValue(){
	   setValueById("RowId","");
	   setValueById("BeginDate","");
	   setValueById("EndDate","");
	   setValueById("Num","");
	   setValueById("Remark","");
	

}