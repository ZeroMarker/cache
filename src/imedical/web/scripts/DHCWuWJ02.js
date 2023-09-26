
function initForm()
{

	var obj=document.getElementById("Regno");
	if(obj)
	{   
		obj.onkeydown=MyKeyDown;
		
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
		var tmpList=ret.split("^");
		document.getElementById("PatName").value=tmpList[0];
		document.getElementById("Sex").value=tmpList[1];
    	
	}
}

document.body.onload=initForm;