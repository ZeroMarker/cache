
function initForm()
{

	var obj=document.getElementById("Regno");
	if(obj)
	{   
		obj.onkeydown=MyKeyDown;
	   }
	var obj1=document.getElementById("FindBill");
	if(obj1)
	{ 
	    obj1.onclick=ButtonOnClick;	
		}
} 
function MyKeyDown()
{   
    if (window.event.keyCode == 13){
	    
    
  
    	var obj=document.getElementById("Regno");
    	if(obj)
    	{   
    	var Regno1=obj.value;

    	}
    	var patrn=/^[0-9]{1,20}$/;
		if (!patrn.exec(Regno1)) 
		{
			alert("你输入的格式不合法");
			return;	
		}
		
    	
    	var strMethod = document.getElementById("Ins").value;
		var ret = cspRunServerMethod(strMethod,Regno1);
		document.getElementById("PatName").value=ret;
		document.getElementById("AdmId").value="";

    	
	}
}
function ButtonOnClick()
{
	var obj=document.getElementById("AdmId");
    	if(obj)
    	{   
    	var AdmId=obj.value;


    	}
    var strMethod = document.getElementById("Ins1").value;
		var ret = cspRunServerMethod(strMethod,AdmId);
		document.getElementById("TotalAmount").value=ret;
	
	}
document.body.onload=initForm;