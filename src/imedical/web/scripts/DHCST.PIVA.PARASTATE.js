// DHCST.PIVA.PARASTATE
function BodyLoadHandler()
{
	SetRowDisabled();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=UpdPSState;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=Add;
	websys_sckeys['N']=Add; //zhouyg 20151013

	/// var objtbl=document.getElementById("t"+"DHCST_PIVA_PARASTATE");
    /// if (objtbl) cnt=getRowcount(objtbl);
    
    InitTpye();
    

}

function InitTpye()
{
	var obj=document.getElementById("tFlag");
	    	
	if (obj)
	{
		obj.size=1; 
	 	obj.multiple=false;
	 	obj.options[1]=new Option("门诊","O");
	 	obj.options[2]=new Option("住院","I");
    }
    
}

function Add()
{
	//var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PARASTATEADD"
	//window.open(link,"_TARGET","height=500,width=800,menubar=no,status=yes,toolbar=no")
	var plocdr="" ;
	var obj=document.getElementById("tPLocID");
	if (obj){
		plocdr=obj.value;
	}
	var ps="";
	var obj=document.getElementById("PSRowID");
	if (obj){
		ps=obj.value;
	}
	
	if (plocdr==""){
		alert("配液科室不能为空!")
		return;
	}
	if (ps==""){
		alert("配液标识不能为空!")
		return;
	}
	
	var typeflag="";
	var obj=document.getElementById("tFlag")
	if (obj){
		typeflag=obj.value;
	}
	if (typeflag==""){
		alert("配液类型不能为空!")
		return;
	}
	var obj=document.getElementById("mInsPsFlag");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,ps,plocdr,typeflag);
	if (result==-99)
	{
		alert("此流程已经存在!")
		return;
	}
	self.location.reload();
	//return false;
}
function UpdPSState()
{
	var row=0;
	var cnt=0
	var tbl=document.getElementById("t"+"DHCST_PIVA_PARASTATE") ;	
	if (tbl) cnt=getRowcount(tbl);
	else return ;
	if (cnt<1) return ;
	var psnumflag=0 ;
	for (var i=0;i<tbl.rows.length;i++)
	{
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="")
		{
			var arcicdr="";
			var cell=document.getElementById("TPSDrz"+row);
			if (cell) psdr=cell.value;
			if (psdr!="")
			{
				var flag=false;
				var cell=document.getElementById("TPSFlagz"+row);
				if (cell) flag=cell.checked;
				if (flag==true) flag="Y";
				else flag="N";
				var retflag=false;
				var cell=document.getElementById("TPSRetFlagz"+row);
				if (cell) retflag=cell.checked;
				if (retflag==true) retflag="Y";
				else retflag="N";
				var dispflag="N" ;
				var objdisp=document.getElementById("TPSDispFlagz"+row);
				if (objdisp) 
				{
					dispflag=objdisp.checked;
					if (dispflag==true) dispflag="Y";
					else dispflag="N" ;
				}
				var psnumflag="N";
                var objpsnum=document.getElementById("TPSNumberz"+row);
                if (objpsnum) 
                {
	                if (objpsnum.innerText=="40") psnumflag="Y"
                }
                
                var pssinflag="N";
                var objsin=document.getElementById("TPSSinFlagz"+row);
                if (objsin)
                {
	                if (objsin.checked) pssinflag="Y" ;
                }
                

                
                
				var result=cspRunUpdPS(psdr,flag,retflag,dispflag,pssinflag);
				if (result!=0)
				{
					alert(t['UpdERR']+row+"^"+result);
				 	return ;
				}
				
				
				
			}
		}
		row++;
	}
	
	
	alert(t['UpdOK']);
	self.location.reload();
}
function cspRunUpdPS(psdr,flag,retflag,dispflag,pssinflag)
{
	var obj=document.getElementById("mUpdPsFlag");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,psdr,flag,retflag,dispflag,pssinflag);
	return result;
}

function SetRowDisabled()
{
	var row=0;
	var cnt=0
	var tbl=document.getElementById("t"+"DHCST_PIVA_PARASTATE") ;	
	if (tbl) cnt=getRowcount(tbl);
	else return ;
	if (cnt<1) return ;
	for (var i=0;i<tbl.rows.length;i++)
	{
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="")
		{
			var flag=false;
			var cell=document.getElementById("TPSSysFlagz"+row);
			if (cell) flag=cell.checked;
			if ((flag==false))
			{
				var cell=document.getElementById("TPSFlagz"+row);
				if (cell) cell.disabled=false;
			}
			
			var number="";
			var objnum=document.getElementById("TPSNumberz"+row);
			if (objnum) {number=objnum.innerText ; }
			
			if ((number==10)||(number==60))
			{
				var objdisp=document.getElementById("TPSDispFlagz"+row);
			    if (objdisp) objdisp.disabled=false;
				
			}
			
			//var retflag=false;
			//var cell=document.getElementById("TPSRetFlagz"+row);
			//if (cell) retflag=cell.checked;
			if ((number==30)||(number==60))
			{
				var objsin=document.getElementById("TPSSinFlagz"+row);
			    if (objsin) objsin.disabled=false;
				
			}

			//if ((flag==true))
			//{
			//	var cell=document.getElementById("TPSFlagz"+row);
			//	if (cell) cell.disabled=true;
			//}
		}
		row++;
	}
}

function DispLocLookUpSelect(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("tPLocID");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;
	}
}

function PSNumberLookUpSelect(str)
{
	var arr=str.split("^");
	var obj=document.getElementById("PSRowID");
	if (obj)
	{if (arr.length>0)   obj.value=arr[1] ;
		else	obj.value="" ;
	}
}



document.body.onload=BodyLoadHandler;
