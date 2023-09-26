var row; //line row  DHCNurOPOrdExec
var queryTypeCode,clicked=false;
var objWin=window.dialogArguments;
returnValue=false;

function BodyLoadHandler()
{   
	var ordstat=document.getElementById('ordstat');
	ordstat.options[0].selected=true;
	var obj=document.getElementById('butexcute');
	if (obj) {obj.onclick=ConfirmClick;}
	var exedateobj=document.getElementById("exedate");
	
	queryTypeCode=objWin.document.getElementById("queryTypeCode").value;
	//opener.document.getElementById("queryTypeCode").value;
	if (queryTypeCode!="SYDO"){
		var obj=document.getElementById("SeatNo");
		obj.style.visibility="hidden";
		var obj=document.getElementById("cSeatNo");
		obj.style.visibility="hidden";
	}
	//exedateobj.value=j;
	clicked=false;
}
function ConfirmClick()
{
   	var SeatNo="";
   	var objSeatNo=document.getElementById("SeatNo"); //seat no
   	if (objSeatNo) SeatNo=objSeatNo.value
   	var needSeatNo="N";
   	var objNeedSeatNo=document.getElementById("needSeatNo");
   	if (objNeedSeatNo) needSeatNo=objNeedSeatNo.value;
   	if ((needSeatNo=="Y")&&(queryTypeCode=="SYDO")&&(SeatNo=="")) { alert(t['alert:shouldFill']);return false;}
	var obj=document.getElementById("butexcute");
	if (obj){
		obj.disabled=true;
		obj.onclick=function(){return false;}
	}
	var arr=new Array();
	var item=new Array();
	var resStr,printed=false,exeResult=true;

	var sttDateTime,updateOrdGroup;
	updateOrdGroup=document.getElementById("UpdateOrdGroup").value;
	var userId=session['LOGON.USERID'];
	var ctlocId=session["LOGON.CTLOCID"];
	var stat=document.getElementById("ordstat");
	var index=stat.selectedIndex;
	if (index==-1){alert(t['alert:selectExecStat']);return false;}//select exec status
	var curExecStatDesc=stat.options[index].text;
	if ((curExecStatDesc.length==0)) {alert(t['alert:selAdminStatus']); return false;}//must set data col ypz 060430
	var data=document.getElementById("data").value;
	data=unescape(data)
	if (clicked==true) {alert(t['alert:repeatClick']);return;}
	clicked=true;
	
	arr=data.split("^");
	for (var i=1;i<arr.length;i++)
	{
		item=arr[i].split("!");
		var basedose=item[0];
		var oeoriId=item[1];
		row=item[3];
		//alert(item)
		var disposeStatCode=objWin.document.getElementById("disposeStatCodez"+row).innerText;
	    if ((disposeStatCode!="Immediate")&&(disposeStatCode!="LongNew")&&(disposeStatCode!="Temp")&&(disposeStatCode!="TempTest")&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="Needless"))
    	{
          	// {alert("no need to dispose!");return false}
      	}
      	else
      	{
			var ordstat=objWin.document.getElementById("ordStatDescz"+row).innerText;
			sttDateTime=objWin.document.getElementById("sttDateTimez"+row).innerText;
			if (ordstat!=t['val:stop']) //stop
			{
		  		var flag=1;
		  		//alert("last="+sttDateTime+","+oeoriId+"^"+SeatNo+","+userId+","+flag);return;
	  			resStr=cspRunServerMethod(updateOrdGroup,sttDateTime,oeoriId+"^"+SeatNo+"^"+ctlocId+"^^"+queryTypeCode,userId,flag);
		  		//alert("first="+resStr);//return;
		  		var OrdNote=document.getElementById("OrdNote").value;
		  		var not=document.getElementById("allergy").value;
	  			//alert(not);
	  			if (not!="") //write note 
	  			{
	  	 			resStr=cspRunServerMethod(OrdNote,oeoriId,not);
	  			}
	   			if (resStr=="0")  
	     		{	
	     			////exeResult=opener.parent.frames["OrdList"].PrintSingleClick(queryTypeCode,oeoriId);
			   	}
			   	else //error
		   		{
					alert(resStr);exeResult=false;//alert(t['alert:execErr']);}
		   		}
			}
	 	}	
	}
    if (exeResult){
	    alert(t['alert:success']);
    	//opener.parent.frames["OrdList"].PrintClick();
    }
    returnValue=exeResult
    self.close();
    //ypz//opener.location.reload();
}

function updaterow(ret) //update father window
{
	/*var dispose=document.getElementById("dispose").value;
	var userCode=session["LOGON.USERNAME"];
	if (ret==0)
	{
		var obj=opener.parent.frames["OrdList"].document.getElementById("tDHCNurOPExec");
		var str;
		var starr=new Array();
		var execCtcpDesc=opener.parent.frames["OrdList"].document.getElementById("execCtcpDescz"+row);
		execCtcpDesc.innerText=userCode;
		var disposeStatCode=opener.parent.frames["OrdList"].document.getElementById("disposeStatCodez"+row);
		disposeStatCode.innerText="Exec"; //ypz
		var dispdesc=opener.parent.frames["OrdList"].document.getElementById("disposeStatDescz"+row);
		str=cspRunServerMethod(dispose,"Exec")  //ypz????
		starr=str.split("|");
		dispdesc.innerText=starr[0];
		var exdate=opener.parent.frames["OrdList"].document.getElementById("execDateTimez"+row);
		exdate.innerText=starr[1];
		var selcheck=opener.parent.frames["OrdList"].document.getElementById("seleitemz"+row);
        selcheck.checked=false;
        var eSrc=obj.rows[row];
        var RowObj=getRow(eSrc);
        RowObj.className="Exec";
	}

	//  var eSrc=objtbl.rows[i];
	//  var RowObj=getRow(eSrc);
	
*/
}

function savecatdr(str)
{
	var obj=document.getElementById('catid');
	var tem=str.split("^");
	obj.value=tem[1];
}
document.body.onload = BodyLoadHandler;
