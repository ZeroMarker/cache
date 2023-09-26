///dhcpha.phadocloc
///医生科室发药
var timer;
function BodyLoadHandler()
{
  	var obj=document.getElementById("StartTimer");
	if (obj) obj.onclick=TimerHandler;
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClick; 
	var obj=document.getElementById("DispLoc"); 
	if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;
	 obj.onchange=SetTableTitle;
	} 
	 
  	SetTableTitle();	
	if (getBodyLoaded()!="1")
	{	
		setBodyLoaded();
		setDefaultValByLoc();
		
	}
  	RefreshWin(1);
  	if (getTimerFlag()==1) 	{Start(); } 
  	
}

function popDispLoc()
{ 
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
		window.event.isLookup=true;
	  	DispLoc_lookuphandler(window.event);
	}
}

function DispLocCheck()
{
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj){
		if (obj.value=="") obj2.value=""		
	}	
} 
	
function FindClick()
{
	if (CheckCondition()==true) 
	{			
		SetSeeked(1);
		
		Find_click();
		
	}
}

function RefreshWin(val)
{	
	//重新设置表格标题?并查找数据
	
	var objseek=document.getElementById("Seeked");
	if (objseek) findseek=objseek.value;
	
	if(findseek==1)
	{SetChecked();}
	else
	{	
		
		var objfind=document.getElementById("Find")
		if(objfind)objfind.click();
		SetChecked();
		
		
	}
}

function CheckCondition()
{
	var obj=document.getElementById("displocrowid")
	if (obj)
	{if (obj.value=="") 
	{alert(t['DISPLOC_NEEDED'])
	  return false 	}
	}
	
	var obj1=document.getElementById("StartDate")
	if (obj1)
	{if (obj1.value=="") 
	  {alert(t['INVALID_SD']) ;
	   return false;    } }
	var obj2=document.getElementById("EndDate")
	if (obj2)
	{if (obj2.value=="") 
	  {alert(t['INVALID_ED']) ;
	   return  false;    } }
	
	if (DateStringCompare(obj1.value,obj2.value )==1)
	{alert(t['INVALID_DATESCOPE']);
	 return false;}
	
	return true ;
}

function SetSeeked(val)
{
   var obj=document.getElementById("Seeked")
   if (obj) {obj.value =val;}
}

function SetFindClicked(val)
{
   var obj=document.getElementById("findclicked")
   if (obj) obj.value =val
}

function BodyBeforeUnLoadHandler()
{Stop();	}
function ExitClick()
{
	window.close();	
	}
function TimerHandler()
{	
	var obj=document.getElementById("StartTimer") ;
	if (obj)
	 {
		 if (obj.checked==true)
			 {Start(); }
		 else
			  {Stop(); }
	 }
}

function Start()
{
	setTimerFlag(1);
	timer=setInterval("OnTimer()",30000); 
}
function Stop()
{	
	clearInterval(timer);
	setTimerFlag(0);
}
	
function getDefDateScope()
{
	var obj=document.getElementById("StartDate");
	if (obj) obj.value=today()
	var obj=document.getElementById("EndDate");
	if (obj) obj.value=today()
	
}
function OnTimer(){ 

   if (getTimerFlag()!=1) return ;
   
   var obj=document.getElementById("displocrowid");
   if (obj) var xdisplocrowid=obj.value;
   var obj=document.getElementById("DispLoc");
   if (obj) var xDispLoc=obj.value;
   var obj=document.getElementById("StartDate");
   if (obj) var xStartDate=obj.value;
   var obj=document.getElementById("EndDate");
   if (obj) var xEndDate=obj.value;
   var obj=document.getElementById("timerflag");
   if (obj) var xtimerflag=obj.value;
  var obj=document.getElementById("bodyloaded");
   if (obj) var xbodyloaded=obj.value;
   
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadocloc&DispLoc="+xDispLoc+"&displocrowid="+xdisplocrowid+"&StartDate="+xStartDate+"&EndDate="+xEndDate+"&timerflag="+xtimerflag+"&bodyloaded="+xbodyloaded
	document.location.href=lnk ;
  
}

function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;
	if (obj) obj.value="1"
	
}


function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
//	alert(obj.value)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
	RefreshWin(0);
}

function setTimerFlag(b)
{
	var obj=document.getElementById("timerflag") ;
	if (obj) {obj.value=b; }
}
function getTimerFlag()
{
	var obj=document.getElementById("timerflag") ;
	if (obj) 
	{ 
	return obj.value}
}
function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;	
	if (obj) 
	{obj.value="1" ;

	}
}
function getBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;	
	if (obj) {
	return obj.value ; }
}


function SelectRowHandler()
 {  
	var row=selectedRow(window);
	if (row<1) return ; 
	var sd,ed,docloc,doclocrowid,disploc,displocrowid,catlist;	
	var obj=document.getElementById("displocrowid")
	if (obj) displocrowid=obj.value;	
	var obj=document.getElementById("DispLoc")
	if (obj) disploc=obj.value;
	var obj=document.getElementById("StartDate")
	if (obj) sd=obj.value;
	var obj=document.getElementById("EndDate")
	if (obj) ed=obj.value;	
	catlist=getCheckedCats(row);	
	var obj=document.getElementById("TDocLocRowID"+"z"+row)
	if (obj) doclocrowid=obj.value;
	var obj=document.getElementById("TDocLoc"+"z"+row)
	if (obj) docloc=obj.innerText;
	//pass the info into dispensing interface
	var docu=parent.frames['dhcpha.phadispdocloc'].document	
	if (docu){

		var obj=docu.getElementById("StartDate")
		if (obj) obj.value=sd
		var obj=docu.getElementById("EndDate")
		if (obj) obj.value=ed
		var obj=docu.getElementById("DoctorLoc")
		if (obj) obj.value=docloc
		var obj=docu.getElementById("doctorlocrowid")
		if (obj) obj.value=doclocrowid

		var obj=docu.getElementById("DispLoc")
		if (obj) obj.value=disploc

		var obj=docu.getElementById("displocrowid")
		if (obj) obj.value=displocrowid

	  	var obj=docu.getElementById("dispcatlist")
		if (obj) obj.value=catlist
		var obj=docu.getElementById("Collect")
		if (obj)
		{obj.click() }		
		
 	}
} 

function getCheckedCats(currrow)
{
	var i=0;
	var checkedcats="";
	
	for(i=0;i<10;i++)
	{
		var objCheck=document.getElementById("Cat"+i+"z"+currrow);
		if (objCheck)
		{	
			if(objCheck.checked==true)
			{  
				var objCat=document.getElementById("Cat"+i+"RowID");
				if(objCat) 
				{checkedcats=checkedcats+"^"+objCat.value; }
				//alert(objCat.value)
			}
		}
	}
	checkedcats.Trim;
	return checkedcats.substring(1,checkedcats.length);
}
	
function getPhaLocation(loc)
{ 
    var exe
	var obj=document.getElementById("mGetPhaLocSet")
	if (obj) exe=obj.value;
	else exe='';
	
	var sss=cspRunServerMethod(exe,loc)
	return sss;
}


function setDefaultValByLoc()
{
	var loc
	var obj=document.getElementById("displocrowid")
	
	if ((obj)&&(obj.value!=""))
	{	
		loc=obj.value ;
	    sets=getPhaLocation(loc)
		
     	if (sets!="")
     	{
     		var ss=sets.split("^")
     		var sd ;
     		var ed;
     		var notwardrequired ;
     		var auditneed ;
         
     		sd=ss[2];
     		ed=ss[3] ;
   
	 		var startdate=CalcuDate(sd)
	 		var enddate=CalcuDate(ed)
	 		var obj=document.getElementById("StartDate");
	 		if (obj) obj.value=startdate;
	 		var obj=document.getElementById("EndDate");
	 		if (obj) obj.value=enddate;
     	}
	}
}

function CalcuDate(ss)
{	var obj=document.getElementById("mGetDate");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var date=cspRunServerMethod(encmeth,'','',ss) ;
	return date	
}

function SetChecked()
{
	var obj=document.getElementById("t"+"dhcpha_phadocloc")
	var cnt=getRowcount(obj);
	
	var i=0;
	var j=0;
	for(i=1;i<=cnt;i++)
	{
		for(j=0;j<10;j++)
		{
			var varChecked=getVal("TCat"+j,i);
			var objcol=document.getElementById("Cat"+j+"z"+i);	
			if (varChecked=="1"){						
				if (objcol) {objcol.checked=true; }
			}
			else{
				if (objcol) {objcol.disabled=true; }
			}
		}
	}
}

function getVal(colname,row)
{
	var result="";
	var obj=document.getElementById(colname+"z"+row)
	if (obj) {result=obj.value;}
	
	return result 
}
function GetLocDispType(displocid)
{	
	
	var obj=document.getElementById("mGetLocDispType");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var disptype=cspRunServerMethod(encmeth,displocid) ;
	return disptype	
}

function SetTableTitle()
{
	var obj=document.getElementById("displocrowid");
	if (obj) 
	{
		var cnt=0;
		var disploc=obj.value;
	
		var dispcats=GetLocDispType(disploc);
		if(dispcats!="")
		{
			var cats=dispcats.split("!")
			var cnt=cats.length
		}
		
		var strcats=""
		var i=0		
		for(i=0;i<cnt;i++)
		{
			var cat=cats[i].split("^");
			var catdesc=cat[1];
			
			var obj=document.getElementById("Cat"+i+"RowID")
			if(obj) 
			{
				obj.value=cat[0];
				strcats=strcats+"^"+cat[0];
				
			}
		    
			var obj=document.getElementById(i+2)
			if (obj)obj.innerText=catdesc ;
		}
		
		strcats.Trim;
		
		var objdisptype=document.getElementById("dispcats");
		if(objdisptype)objdisptype.value=strcats.substring(1,strcats.length)
		//设置列隐藏
		HideCols(i+2);
	}
}

function HideCols(startcol)
{
	var i=0;
	var rows=0;
			
	var objTable=document.getElementById("t"+"dhcpha_phadocloc");
	if (objTable) rows=getRowcount(objTable);
	
	//显示有数据的列
	for(i=2;i<startcol;i++)
	{
		//显示标题行
		var obj=document.getElementById(i);
		if (obj) obj.style.display="";
		
		//显示数据行
		var j=0;		
		var col=i-2
		for(j=1;j<=rows;j++)
		{
			var objCell=document.getElementById("Cat"+col+"z"+j);
			if(objCell)objCell.style.display="";	
		}
	}
	
	//隐藏没有数据的列
	
	for(i=startcol;i<12;i++)
	{		
		//隐藏数据列
		var j=0;		
		var col=i-2
		for(j=1;j<=rows;j++)
		{
			var objCell=document.getElementById("Cat"+col+"z"+j);
			//alert(col+"||"+j);
			if(objCell)objCell.style.display="none";	
		}
		
		//隐藏标题列
		//alert(i);
		var obj=document.getElementById(i);
		if (obj) obj.style.display="none";
	}
}

document.body.onload=BodyLoadHandler;
document.body.onbeforeunload=BodyBeforeUnLoadHandler;
