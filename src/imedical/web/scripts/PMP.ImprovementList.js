//PMP.ImprovementList.js

function BodyLoadHandler()
{
	var obj=document.getElementById("DeleteOne"); 
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById("Find"); 
	if (obj) obj.onclick = Find_Click;
	var obj=document.getElementById("Updata"); 
	if (obj) obj.onclick = Update_Click;
	
	var obj=document.getElementById("Progress"); 
	if (obj) obj.onclick = Progress_Click;
	//var obj=document.getElementById("isDelete"); 
	//obj.checked=true;
}
function Progress_Click(){
	
	var obj=document.getElementById("HRowId");
	var HRowId=obj.value
	
	if(HRowId==""){
		alert("��ѡ��һ����¼!")
		return false;
	}
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=PMP_ImprovementProgress&HRowId="+HRowId;
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=520,left=100,top=100')
		
	
}	
function Update_Click(){
	var obj=document.getElementById("HRowId");
	var HRowId=obj.value
	
	if(HRowId==""){
		alert("��ѡ��һ����¼!")
		return false;
	}
	
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=PMP_ImprovementUpdate&HRowId="+HRowId;
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=520,left=100,top=100')

	//var lnk='websys.default.csp?WEBSYS.TCOMPONENT=PMP.NewImp'
   // window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=520,left=100,top=100')

	
}	
function Find_Click(){
	
	var IPMLName=document.getElementById("IPMLName").value;
	var SDate=document.getElementById("SDate").value;
	var EDate=document.getElementById("EDate").value;
	var isDelete=document.getElementById("isDelete").checked;

	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=PMP_ImprovementList&IPMLName="+IPMLName+"&SDate="+SDate+"&EDate="+EDate;
	window.location.href=lnk;
	
}

//�Ƿ�ȷ�ϵ���
function delcfm() {
        if (!confirm("ȷ��Ҫɾ����")) {
            window.event.returnValue = false;
        }
}

function Delete_Click(){
	
	var obj=document.getElementById("HRowId");
	var RowId=obj.value

		//ɾ��					
			rs=confirm("ȷ��Ҫɾ����") 	
     		if(rs){
	     		var obj=document.getElementById("HIPMLOStatus");
				if (obj.value=="�ύ"){
					alert("�Ѿ��ύ������ɾ��")
					return false;
				}
	     		
	     		var obj=document.getElementById('deleteFunction');
     			if (obj) {var encmeth=obj.value} else {var encmeth=''};
	     		var ret=cspRunServerMethod(encmeth,RowId)
	    		if (ret==""){
		   			alert("ɾ���ɹ���")
	    		}else{alert(ret);}	
	     	}
     	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMP_ImprovementList";
 		window.location.href=lnk;
}	

function SelectRowHandler()	{

	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc)
	var selectrow=rowObj.rowIndex;

	var obj=document.getElementById("RowIdz"+selectrow);
	var RowId=obj.innerText
	var tmpRowId=document.getElementById("HRowId");
	tmpRowId.value=RowId
	
	var obj=document.getElementById("IPMLOStatusz"+selectrow);
	var tmpIPMLOStatus=document.getElementById("HIPMLOStatus");
	tmpIPMLOStatus.value=obj.innerText
	
	var submitlink="submitz"+selectrow
	var deletelink="deletez"+selectrow
	//var progresslink="progressz"+selectrow
	if (selectrow !=0) {
		
		//��ѯ����
		//if (eSrc.id==progresslink){    								//

			//var obj=document.getElementById('progressFunction');
     		//if (obj) {var encmeth=obj.value} else {var encmeth=''};	
     		//var ret=cspRunServerMethod(encmeth,RowId)
     		
     	//	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=PMP_ImprovementProgress&HRowId="+RowId;
     	//	alert(lnk)
		//	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=520,left=100,top=100')
		//}
		
		//ɾ��
		if (eSrc.id==deletelink){    								//
     		var obj=document.getElementById("IPMLOStatusz"+selectrow);
				if (obj.innerText=="�ύ"){
					alert("�Ѿ��ύ������ɾ��")
					return false;
				}
			var obj=document.getElementById('deleteFunction');
     		if (obj) {var encmeth=obj.value} else {var encmeth=''};	
     		var ret=cspRunServerMethod(encmeth,RowId)
	    	if (ret==""){
		   		alert("ɾ���ɹ���")
	    	}else{alert(ret);}
		}
		//�ύ
		if (eSrc.id==submitlink){    								//
     		var obj=document.getElementById("IPMLOStatusz"+selectrow);
				if (obj.innerText=="�ύ"){
					alert("�Ѿ��ύ������Ҫ���ύ")
					return false;
				}
			var obj=document.getElementById('submitFunction');
     		if (obj) {var encmeth=obj.value} else {var encmeth=''};	
     		var ret=cspRunServerMethod(encmeth,RowId)
	    	if (ret==""){
		   		alert("�����ύ�ɹ���")
	    	}else{alert(ret);}
		}
	}
	
		
	
}	

function NewOnet_Click(){
	
	//var str='websys.default.csp?WEBSYS.TCOMPONENT=PMP.NewImp'
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=520,left=100,top=100')
}
document.body.onload=BodyLoadHandler;