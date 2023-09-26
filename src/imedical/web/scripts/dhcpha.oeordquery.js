
//create by lq 2008-03-12
function BodyLoadHandler()
{
	var obj=document.getElementById("ward"); 
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=wardCheck;
	} 
	obj=document.getElementById("admno") ;
	{    
 	if (obj) obj.onblur=admnoBlur; 
 	if (obj) obj.onkeydown=admnoEnter;
 	}
 	//var obj=document.getElementById("Find")
	//if (obj) obj.onclick=FindData;

 	setcolor();
 	
}
function setcolor()
{
	var objtbl=document.getElementById("T"+"dhcpha_oeordquery")
	if (objtbl)
	{   
		 for (var i=1; i < objtbl.rows.length; i++) 
        {   
            
            var objtype=document.getElementById("Tqtypez"+i);
            if (objtype.value=="ins1")
            {var flag="#80f0c0";}
            if (objtype.value=="ins2")
            {var flag="#ffc0c0";}
            var objxdate=document.getElementById("Txdatez"+i);
            if  (objxdate.value!="")
            { var xflag="Gray";}
            
            var objdate0=document.getElementById("Tdate0z"+i);
            var objdate1=document.getElementById("Tdate1z"+i);
            var objdate2=document.getElementById("Tdate2z"+i);
            var objdate3=document.getElementById("Tdate3z"+i);
            var objdate4=document.getElementById("Tdate4z"+i);
            var objdate5=document.getElementById("Tdate5z"+i);
            var objdate6=document.getElementById("Tdate6z"+i);
            
            var objqsdate=document.getElementById("Tqsdatez"+i);
            var objqxdate=document.getElementById("Tqxdatez"+i);

       
            
            if(objdate0.innerText>=objqsdate.value)  
            {
	            if(objdate0.innerText<=objqxdate.value)
                {
	               objdate0.style.backgroundColor=flag
	               if ((objxdate.value!="")&&(objdate0.innerText>=objxdate.value))
	               {objdate0.style.backgroundColor=xflag}
                 }
                
            }
            
             if(objdate1.innerText>=objqsdate.value)  
            {
	            if(objdate1.innerText<=objqxdate.value)
                {
	               objdate1.style.backgroundColor=flag
	               if ((objxdate.value!="")&&(objdate1.innerText>=objxdate.value))
	               {objdate1.style.backgroundColor=xflag}
                 }
            }
            
              if(objdate2.innerText>=objqsdate.value)  
            {
	            if(objdate2.innerText<=objqxdate.value)
                {
	               objdate2.style.backgroundColor=flag
	               if ((objxdate.value!="")&&(objdate2.innerText>=objxdate.value))
	               {objdate2.style.backgroundColor=xflag}
                 }
            }
            
               if(objdate3.innerText>=objqsdate.value)  
            {
	            if(objdate3.innerText<=objqxdate.value)
                {
	               objdate3.style.backgroundColor=flag
	               if ((objxdate.value!="")&&(objdate3.innerText>=objxdate.value))
	               {objdate3.style.backgroundColor=xflag}
                 }
            }
            
                if(objdate4.innerText>=objqsdate.value)  
            {
	            if(objdate4.innerText<=objqxdate.value)
                {
	               objdate4.style.backgroundColor=flag
	               if ((objxdate.value!="")&&(objdate4.innerText>=objxdate.value))
	               {objdate4.style.backgroundColor=xflag}
                 }
            }
               
                if(objdate5.innerText>=objqsdate.value)  
            {

	            if(objdate5.innerText<=objqxdate.value)
                {
	                
	               objdate5.style.backgroundColor=flag
	               
	               if ((objxdate.value!="")&&(objdate5.innerText>=objxdate.value)) 
	               {objdate5.style.backgroundColor=xflag}
                 }
            }
                 if(objdate6.innerText>=objqsdate.value)  
            {
	            if(objdate6.innerText<=objqxdate.value)
                {
	               objdate6.style.backgroundColor=flag
	               if ((objxdate.value!="")&&(objdate6.innerText>=objxdate.value))
	               {objdate6.style.backgroundColor=xflag}
	               
                 }
            }
            
        }
		
		
	}
}
function popWard()     
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ward_lookuphandler();
		}
	}
function wardCheck()
{
	var obj=document.getElementById("ward");
	var obj2=document.getElementById("wardid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

	}

function WardLookUpSelect(str)
{ 
  var ward=str.split("^");
  var obj=document.getElementById("wardid");
  var objflag=document.getElementById("queryflag");
  if (obj)
  {if (ward.length>0)   {obj.value=ward[1] ;
  objflag.value=1;}
    else
       {obj.value="" ; 
       objflag.value=""; }
  	 }
}

function admnoBlur()
{
	var obj=document.getElementById("admno") ;
	var regno ;
	if (obj)
	{ 
	 	regno=obj.value ;
	 	
	 	if (regno=="")
	 	{			
	 		return ;
	 	}
	 	else
	 	{
		 	obj.value=getRegNo(regno) ;
	  		regno=obj.value ; 
	  		
	  	}
	}  	
		
 }
 
 function admnoEnter()
{ 
	if (window.event.keyCode==13) 
		{admnoBlur();}
	else
		{var obj=document.getElementById("admno")
		 if(isNaN(obj.value)==true)  { obj.value="" ;}
			}
}

function FindData()
{
	//Find_click();
}

document.body.onload=BodyLoadHandler;
