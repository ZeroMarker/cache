document.body.onload=BodyLoaderHandler;
var SelectedRow = 0;
function BodyLoaderHandler() {
	var obj;
	
	//��ť ����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }

	//��ť ɾ��
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	//��� ɾ��
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=ClearValue; }
	
}

function Update_click(){
	var PADMDr = document.getElementById('PADMDr');
	
	if(PADMDr){
		var DrId = PADMDr.value;
	} else {
		return false;	
	}
	
	var Type=document.getElementById('Type').value;
	DrId=DrId+"^"+Type;
	var RowId = document.getElementById('RowId').value;
	var BeginDate = document.getElementById('BeginDate').value;
	var EndDate = document.getElementById('EndDate').value;
	if(BeginDate == "" || BeginDate == null
		|| EndDate == "" || EndDate == null){
		alert("��ʼ�������������Ϊ�����");
		return false;
	}
	
	/*
	if(BeginDate > EndDate){
		alert("��ʼ���ڲ������ڽ������ڣ�");
		return false;	
	}*/
	
	var Num = document.getElementById('Num').value;
	
	if(Num.indexOf("-")<=-1){
	    alert("ÿ��������ʽӦΪ:���硰1-100��")
	    return false;
	    }

	if(Num.indexOf("-")>0)
	   {
		   
		   var Data=Num.split("-");
		   var reg = /^[0-9]+.?[0-9]*$/; 
		   if(!(reg.test(Data[1]))||!(reg.test(Data[0]))) 
		   {
			   alert("ÿ������-ǰ��ӦΪ����");
			    return false; 
		   }
	   }

	if(Num == "" || Num == null || Num == undefined || Num == "-"){
		alert("��������Ϊ�գ�");
		return false;
	}
	var ins = document.getElementById('UpdateClass');
	var methodAddress;
	if(ins){
		methodAddress = ins.value;	
	} else {
		methodAddress = '';
	}
	var iRemark="";
	var obj=document.getElementById("Remark");
    if(obj){var iRemark=obj.value;}

	var rnt = cspRunServerMethod(methodAddress,DrId,RowId,BeginDate,EndDate,Num,iRemark);
	if(rnt == "1"){
		alert("�����е������������ص�������ʧ�ܣ�"); 
	} else if(rnt == "2"){
		alert("���������󣬸���ʧ�ܣ�");
	} else if (rnt == "4"){
		alert("��ʼ���ڲ������ڽ������ڣ�����ʧ�ܣ�");
	}else if (rnt == "5"){
		alert("����ʱ�䲻�ܴ��������ԤԼʱ�䣬����ʧ�ܣ�");
	}else if (rnt == "6"){
		alert("������������С���������Գ�Ա����������ʧ�ܣ�");
	}else if (rnt == "7"){
		alert("����Ů������С������Ů�Գ�Ա����������ʧ�ܣ�");
	}else if (rnt == "3"){
		alert("���³ɹ�");
		window.location.reload();
	} 


}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEPreGADM_Home');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var obj=document.getElementById('RowId');
		if (obj){
			var SelRowObj=document.getElementById('THomeRowIDz'+selectrow);
			obj.value=SelRowObj.value;	//����Ԫ����value
		}
		
		var obj=document.getElementById('BeginDate');
		if (obj){
			var SelRowObj=document.getElementById('TDatez'+selectrow);
			obj.value=SelRowObj.innerText;
		}
		
		var obj=document.getElementById('EndDate');
		if (obj){
			var SelRowObj=document.getElementById('TDatez'+selectrow);
			obj.value=SelRowObj.innerText;
			
		}
		
		var obj=document.getElementById('Num');
		if (obj){
			var SelRowObj=document.getElementById('TMaleNumz'+selectrow);
			obj.value=SelRowObj.innerText;
			
			var SelRowObj=document.getElementById('TFemaleNumz'+selectrow);
			obj.value=obj.value+"-"+SelRowObj.innerText;
		}
			var obj=document.getElementById('Remark');
			if (obj){
			var SelRowObj=document.getElementById('TRemarkz'+selectrow);
			obj.value=SelRowObj.innerText;

		}

		
	}else{
		SelectedRow=0;
		ClearValue();
	}
	
}

function Delete_click(){
	var RowId = document.getElementById('RowId').value;
	if(RowId == null || RowId=="" || RowId==undefined){
		alert("��ѡ������");
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
		alert("���ݲ����ڣ�ɾ��ʧ��");	
	} else if(rnt == "2"){
		alert("����������ɾ��ʧ��");
	} else if (rnt == "3"){
		alert("ɾ���ɹ�");
		window.location.reload();
	}
}

function ClearValue(){
	var obj=document.getElementById('RowId');
	if(obj){obj.value="";}
	var obj=document.getElementById('BeginDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('EndDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('Num');
	if(obj){obj.value="";}
	var obj=document.getElementById('Remark');
	if(obj){obj.value="";}

}