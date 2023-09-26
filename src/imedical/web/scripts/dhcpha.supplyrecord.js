var Currentrow;
function BodyLoadHandler()
{
	var obj=document.getElementById("OK");
	if (obj) obj.onclick=OkClick; 
	var obj=document.getElementById("Confirm");
	if (obj) obj.onclick=ConfirmClick;
	CreateSupplyDate();
}

function OkClick()
{
    if (!Currentrow){alert("请先选择一行记录后再试");return;}
	if (Currentrow<1) {return;}
	var obj=document.getElementById("Twardz"+Currentrow)
	if(obj) var ward=obj.innerText
	var obj=document.getElementById("Twarddrz"+Currentrow)
	if(obj) var warddr=obj.value	
	var obj=document.getElementById("Tlocz"+Currentrow);
	if (obj) var disploc=obj.innerText;
	var obj=document.getElementById("Tsdatez"+Currentrow);
    if (obj) var sdate=obj.innerText;
	var obj=document.getElementById("Tedatez"+Currentrow);
	if (obj) var edate=obj.innerText;
	var obj=document.getElementById("Tstimez"+Currentrow);
	if (obj) var stime=obj.innerText;
	var obj=document.getElementById("Tetimez"+Currentrow);
	if (obj) var etime=obj.innerText;
	var obj=document.getElementById("Tdisplocrowidz"+Currentrow);
	if (obj) var displocrowid=obj.value;
	

    var maindocu=window.opener.document
  
	if (maindocu) 
	{
	  	var obj=maindocu.getElementById("StartDate")
	  	if (obj){obj.value=formatDate3(sdate)}
	  	var obj=maindocu.getElementById("EndDate")
	  	if (obj){obj.value=formatDate3(edate)}
	  	var obj=maindocu.getElementById("DispLoc")
	  	if (obj){obj.value=disploc}
	  	var obj=maindocu.getElementById("Ward")
	  	if (obj){obj.value=ward}
	  	var obj=maindocu.getElementById("StartTime")
	  	if (obj){obj.value=stime}
	  	var obj=maindocu.getElementById("EndTime")
	  	if (obj){obj.value=etime}
	  	var obj=maindocu.getElementById("wardrowid")
	  	if (obj){obj.value=warddr}
	  	var obj=maindocu.getElementById("displocrowid")
	  	if (obj){obj.value=displocrowid}
	  	
	}
    ClearOpenerTable();
	window.close();
	
}
function ConfirmClick()
{
	var objConfirm=document.getElementById("Confirm")
	if (objConfirm.disabled) {return;}
	var obj=document.getElementById("Sdate")
	if (obj){sdate=obj.value}
	var obj=document.getElementById("Stime")
	if (obj){stime=obj.value}
	
	
    var maindocu=window.opener.document
	if (maindocu) 
	{
		var obj=maindocu.getElementById("StartDate")
	  	if (obj){obj.value=sdate;obj.disabled=true;}
	  	var obj=maindocu.getElementById("ld51083iStartDate");
		if (obj) obj.disabled=true;
	  	var obj=maindocu.getElementById("StartTime")
	  	if (obj){obj.value=stime;obj.disabled=true;}
	  	var obj=maindocu.getElementById("Supply")
	  	if (obj)
	  	{
		  	obj.checked=true;
		  	obj.disabled=true;
		}
	  	var obj=maindocu.getElementById("ShowRecord")
	  	if (obj){obj.disabled=true;}
	  	
	  		
	}
    ClearOpenerTable();
	window.close();
	
}

function CreateSupplyDate()
{ 
    var objConfirm=document.getElementById("Confirm")
	
	var maindocu=window.opener.document
	if (maindocu) 
		{
			var obj=maindocu.getElementById("wardrowid")
			if (obj)
				{
					if (obj.value=="")
					{
						alert("请选择病区后再试...");
						objConfirm.disabled=true;
						return;
					}
					warddr=obj.value
				}
				
			var obj=maindocu.getElementById("displocrowid")
			if (obj)
				{	
					if (obj.value=="")
					{
						alert("请选择发药科室后再试...");
						objConfirm.disabled=true;
						return;
					}
					displocrowid=obj.value
				}
		}
	
	var saverecord=document.getElementById('mCreateDate');
	if (saverecord) {var encmeth=saverecord.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth,displocrowid,warddr) ;
	str=ret.split("^")
	var flag=str[0]
	var sdate=str[1]
	var stime=str[2]

	var obj=document.getElementById("Sdate")
	if (obj)
		{
			obj.value=sdate
			if (flag==1)
				{
				  obj.disabled=true;
				  var obj=document.getElementById("ld51138iSdate")
				  obj.disabled=true;
				}
		}
	
	var obj=document.getElementById("Stime")
	if (obj)
		{
			obj.value=stime
		    if (flag==1)
				{
				  obj.disabled=true;
				}
		}

	
}
function SelectRowHandler()
{
	Currentrow=selectedRow(window);
}

function ClearOpenerTable()
{
	var maindocu=window.opener.document
	var objtbl=maindocu.getElementById("t"+"dhcpha_dispquerygenerally")
	DelAllRows(objtbl);
}
	
document.body.onload=BodyLoadHandler;