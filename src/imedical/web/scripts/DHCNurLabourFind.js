//By    ljw20081230
var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	
	var regnoobj=document.getElementById('IPid');
	if (regnoobj){regnoobj.onkeydown=GetRegNo;}
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=UPDATED_click;
	var obj=document.getElementById('selectAll');
	if (obj) obj.onclick=SelectAll_Click;
	var objStatusE=document.getElementById('FindStatusE')
	var objtbs=document.getElementById("FindStatusIdE")
	if ((objtbs)&&(objtbs.value=="")) objtbs.value='L'
	if (objtbs.value=='L') 	{objStatusE.value="´ý²ú"}
	//var objtbs=document.getElementById("FindStatus")      //090717
	//objtbs.value=t['04']
	//var objtbs=document.getElementById("FindStatusId")
	//objtbs.value="C"
}
function GetRegNo()
{
   if (window.event.keyCode==13){ 
      var regnoobj=document.getElementById('IPid');
      var regno=regnoobj.value
      if ((regno!="")||(regno!=" ")){
        regno=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",regno) 
        regnoobj.value=regno  
      }
   }   	
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCNurLabourFind');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	}
	
	
function UPDATED_click(){
	var objtbl=document.getElementById('tDHCNurLabourFind');
	var Num=0;
	var con=confirm("OK?")
	if(!con) return;
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		if (sel.checked==true)
		{
		//var con=confirm("OK?")
		//if(con==true){
		var Num=Num+1
		var Rowid=document.getElementById('TRowIdz'+i).innerText;
		if(Rowid==""){
			alert(t['01']) 
			return
			}
		var obj=document.getElementById('FindStatusId')
		if(obj) var Status=obj.value;
		if(Status==""){
			alert(t['02']) 
			return;
			}
		var obj=document.getElementById('UPDATED')
		if(obj) var encmeth=obj.value;
		//alert(Rowid+'^'+Status)
   		if (cspRunServerMethod(encmeth,Rowid,Status)!='0')
			{alert(t['baulk']);
			return;}	
		try {		   
	    	//alert(t['succeed']);
	    	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurLabourFind&Rowid="+Rowid
			} catch(e) {};
		//}
		//else{
		//	return;
		//	}
		}
	}
	if(Num==0){
		alert(t['03'])
		return;}
	else {
		alert(t['succeed']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurLabourFind";
		}
	//window.location.reload();
	}
	
function GetFindStatus(str)
{
	var ret=str.split("^");
	var obj=document.getElementById("FindStatusId")
	obj.value=ret[0];
	var obj1=document.getElementById("FindStatus")
	obj1.value=ret[1];
}


function GetFindStatusE(str)
{
	var ret=str.split("^");
	var obj=document.getElementById("FindStatusIdE")
	obj.value=ret[0];
	var obj1=document.getElementById("FindStatusE")
	obj1.value=ret[1];
}

function getloc(str)
{
		var loc=str.split("^");
		var obj=document.getElementById("CTLocId")
		obj.value=loc[1];
		sch_click();
		//alert(loc[1]);	
}


function SelectAll_Click()
{
  var obj=document.getElementById("selectAll");
  var Objtbl=document.getElementById('tDHCNurLabourFind');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('SelItemz'+i);  
	selobj.checked=obj.checked;  
	}
}
document.body.onload=BodyLoadHandler;