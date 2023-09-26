//creat by zhouli
//DHCPEILLExplainList.js


var CurRow=0
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("Save");
	if (obj) {obj.onclick=Save_Click;}
	

}

                    

function Save_Click(){
        
		var objtbl=document.getElementById('tDHCPEILLExplainList');
		if (objtbl) { var rows=objtbl.rows.length; }
		var lastrowindex=rows - 1;
		var obj;
	
		var IllRowID,GSRowID,IllExplain="",IllSportGuide="",IllDietGuide="",IllPrint="Y",Strings="",PAADM="";
		obj=document.getElementById("PAADM");
		if (obj) PAADM=obj.value;
		for (i=1;i<rows;i++)
		{   
		
			obj=document.getElementById("TILLIDz"+i);
			if (obj) IllRowID=obj.value;
			obj=document.getElementById("TILLExplainz"+i);
			if (obj) IllExplain=obj.value;

			obj=document.getElementById("TILLSportGuidez"+i);
			if (obj) IllSportGuide=obj.value;
			obj=document.getElementById("TILLDietGuidez"+i);
			if (obj) IllDietGuide=obj.value;
		  	obj=document.getElementById("GSRowIdz"+i);
			if (obj) GSRowID=obj.value;
            obj=document.getElementById("TPrintz"+i);
			if (obj.checked){IllPrint="Y" }
		    else{IllPrint="N"}
     
	
			if (Strings=="")
			{
				Strings=PAADM+"&&"+IllRowID+"&&"+IllExplain+"&&"+IllSportGuide+"&&"+IllDietGuide+"&&"+IllPrint;
			}
			else
			{
				Strings=Strings+"^^"+PAADM+"&&"+IllRowID+"&&"+IllExplain+"&&"+IllSportGuide+"&&"+IllDietGuide+"&&"+IllPrint;
			}
		}
			
		if (Strings=="") return false;

		var obj=document.getElementById("SaveBox");
		if (obj) var encmeth=obj.value;
	
		var flag=cspRunServerMethod(encmeth,Strings)
	

		 parent.close();
	
	
}


document.body.onload = BodyLoadHandler;