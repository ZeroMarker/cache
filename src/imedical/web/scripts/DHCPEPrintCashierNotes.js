/// ����	DHCPEPrintCashierNotes.js
/// ����ʱ��		
/// ������		zl
/// ��Ҫ����   ��������?��������շ�Ʊ�ݴ�ӡ�A���ڸ��� �������ϵͳ��		
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���

function BodyLoadHandler() {

	var obj;
	
	//����
	obj=document.getElementById("Print");
	if (obj){ obj.onclick=Print_click; }
	

       
 
     init()
	
} 
function init()  
  
{    
      var Name=""
      var obj=document.getElementById("Name");
      
      if (obj){  alert(obj.value)
      Name=obj.value
	   document.getElementById("cPatName").innerText=Name
	   }
      

	
	
	}

function Print_click()
{  
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPECashierNotesForFC.xls';
		}else{
			alert("��Чģ��·��");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1"); 
		var user=session['LOGON.USERCODE'] 
		obj=document.getElementById('ID');
		if(obj){var ADM=obj.value

		
		obj=document.getElementById('Amount');
		if(obj){
			var Amount=obj.value
			if (Amount==0)
			{alert(t["NoAmount"])
			  return;}
			
			}
		 obj=document.getElementById('Type');
		 if(obj){var Type=obj.value}
		 var Ins=document.getElementById('Save');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		 var DataStr=cspRunServerMethod(encmeth,Type,ADM,Amount);
		obj=document.getElementById('Name');
		if(obj){var Name=obj.value}
	    obj=document.getElementById('CurDate');
		if(obj){var CurDate=obj.value}
		
		        xlsheet.cells(3,2)=Name
		     	xlsheet.cells(4,2)=Amount+"Ԫ"
		     	xlsheet.cells(5,2)=user
			    xlsheet.cells(5,4)=CurDate 
		
			
			   
		
	
   		//var SaveDir="d:\\���ҹ�����ͳ��.xls";
   		//xlsheet.SaveAs(SaveDir);
   		xlsheet.Print
   		xlApp.Visible = true;
   		xlApp.UserControl = true;  
   		window.close();
   	}
    }
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}


document.body.onload = BodyLoadHandler;

