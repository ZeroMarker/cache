//DHCRisBookedEx.js

var gSchudleRowid="";
var gPaadmdr,gLocId,gOEOrdItemDr
var SelectedRow="-1"

function BodyLoadHandler()
{
	
	//获取科室ID 
	GetLocId();
	
	//查询资源信息
	GetResource()
	
	gPaadmdr=$('PaadmDR').value;
	gLocId=$('LocId').value;
	gOEOrdItemDr=$('OrditemRowid').value;
	//alert(gOEOrdItemDr);
	

	//获取当前日期
	var BookedDateObj=$("BookDate");
	if (BookedDateObj)
	{
		if (BookedDateObj.value=="")
			BookedDateObj.value=DateDemo();
	}
	//反色显示当前已预约记录
	InitCarrentBooked();
	
	GetSelect();
	
}

function GetLocId()
{
	var LocID=$("LocId");
    if (LocID.value=="")
    {
       var GetLocSessionFunction=$("GetLocSession").value;
	   var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	   if (Getlocicvalue=="")
         LocID.value=session['LOGON.CTLOCID'];
       else 
 		 LocID.value=Getlocicvalue;
	}
}


function GetResource()
{
	
	var ResourceObj=$("Resource");
    if (ResourceObj)
    {
	 	combo("Resource");
	 	var LocId=$("LocId").value;
		var GetWeekInfoFunction=$("GetResourceInfo").value;
		var Info1=cspRunServerMethod(GetWeekInfoFunction,LocId);
    	AddItem("Resource",Info1);
    	ResourceObj.onchange=changeResource;
    }
	
}

function changeResource()
{
	var ResourceObj=$("Resource");
	if (ResourceObj)
	{
		$("ResourceId").value=ResourceObj.value; 
		//alert($("ResourceId").value);
		SelResourceObj=$("SelResource");
		if (SelResourceObj)
		{
			SelResourceObj.value=ResourceObj.text;
		}
		Query_click();
 	}
}


function GetSelect()
{
	var ResourceIdObj=document.getElementById("ResourceId");
	if(ResourceIdObj)
	{
		var ResourceObj=document.getElementById("Resource");
	    if (ResourceObj.options.length>0)
	 	{
			 for (var i=ResourceObj.options.length-1; i>=0; i--)
			 {
				if(ResourceIdObj.value == ResourceObj.options[i].value)
				{
					ResourceObj.selectedIndex = i;
			    }
		     }
	     }
    }
}


function combo(cmstr)
{
	var obj=$(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=$(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[0],perInfo[1]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=$('tDHCRisBookedEx');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (SelectedRow!=selectrow)
	{
	    for (i=1;i<rows;i++)
	    {
		    var selectedobj=$("Selectz"+i);
		    if (selectrow!=i)
		    {
			   selectedobj.checked=false;
		    }
		    
	        if ((selectedobj)&&(selectedobj.checked))
	        {
		        var gMaxNumber=$("TMaxNumberz"+i).innerText;
		            gMaxNumber=Number(gMaxNumber);
		            
		        var gUseNumber=$("UseNumberz"+i).innerText;
		            gUseNumber=Number(gUseNumber);
		             
		        if(gMaxNumber==0)
		        {
			        alert("最大预约数为0不能预约!");
			        return;
			    }
			    if(gMaxNumber<=gUseNumber)
			    {
				    var ConFlag=confirm('已超过资源最大预约数,是否继续预约!');
				    if (ConFlag==false){return} 
				}
		        
		        gSchudleRowid=$("ResSchudleRowidz"+i).value;
		        //alert(gSchudleRowid)
		       	var gBookDate=$("TBookDatez"+i).innerText;
		        var gBookTime=$("TStartTimez"+i).innerText;
		        var gBookResource=$("TResourcez"+i).innerText;
	     
		        $("UpdateBookInfo").value=gBookDate+"^"+gBookTime+"^"+gBookResource;
		        
		        
			    var sel=SetSelRows();
			    if (sel=="false")
			    {
				    alert("请选择记录");
				    return;
				}
			
		        
		        SelectedRow = selectrow;
		        Lnk();
		    }

	    }
  }
  else
  {
	  SelectedRow="-1"
	  gLocId="";
	  gPaadmdr="";
	  gOEOrdItemDr=""
	  Lnk();
  }
       
}


function DateDemo()
{
   var d, s="";           // 声明变量?
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			// 获取日?
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;		// 获取月份?
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear();		// 获取年份?
   s = sDay + "/" + sMonth + "/" + sYear;
   return(s); 
   
}

function getRelaDate(offset)
{
	var obj=new Date();
	var ms=obj.getTime();
	var offsetms=60*60*24*offset*1000;
	var newms=ms+offsetms;
	var newdate=new Date(newms);
	return formatDate(newdate);
}

function formatDate(dateobj)
{
	var sep="/";
	var day=dateobj.getDate();
	if (day<10) day="0"+day;
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	return day+sep+mon+sep+year

}


function SetSelRows()
{
   var orddoc=parent.parent.parent.frames["DHCRisWorkBench"].document;
   var objtbl=orddoc.getElementById('tDHCRisWorkBenchEx');
   var rows=objtbl.rows.length;
   var sel="false";
   
   for (var j=1;j<rows;j++)
   {
	    
	     var selectedobj=orddoc.getElementById("TSelectedz"+j);
	     if ((selectedobj)&&(selectedobj.checked))
	     {
	        gPaadmdr=orddoc.getElementById("EpisodeIDz"+j).value;
	        gLocId=orddoc.getElementById("RecLocIdz"+j).value;
	        gOEOrdItemDr=orddoc.getElementById("OEOrdItemIDz"+j).value;
	        sel="true";
	         
	     }
   }
   
   return sel;
        
}     

function InitCarrentBooked()
{
	var tbl=document.getElementById("tDHCRisBookedEx");
	var row=tbl.rows.length;
	row=row-1;
	
	var getSchduleID=GetSchduleID()
	for (var j=1;j<row+1;j++)
	{
		var SelSchduleID=$("ResSchudleRowidz"+j).value;
		
		if (getSchduleID==SelSchduleID)
		{
           tbl.rows[j].style.backgroundColor="#FF99FF";	
           var selectedobj=$("Selectz"+j);
           selectedobj.checked=true;
           
           var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisPatRegisterEx"+"&LocDR="+gLocId+"&PaadmDR="+gPaadmdr+"&OeorditemID="+gOEOrdItemDr+"&ResSchudleDR="+getSchduleID;
	       parent.frames['PatRegisterEx'].location.href=lnk;
		} 
		
	 }
	 // 第一行当前可以预约的最近时间段
	 if ((getSchduleID=="")&&(row>0))
	 {
		   tbl.rows[1].style.backgroundColor="#009999";	
           var selectedobj=$("Selectz"+1);
           selectedobj.checked=true;
           
           var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisPatRegisterEx"+"&LocDR="+gLocId+"&PaadmDR="+gPaadmdr+"&OeorditemID="+gOEOrdItemDr+"&ResSchudleDR="+getSchduleID;
	       parent.frames['PatRegisterEx'].location.href=lnk;
			
	} 
}

function GetCurrentDate()
{
	var d, s="";         
    d = new Date(); 
    var sDay="",sMonth="",sYear="";
    sDay = d.getDate();		
    if(sDay < 10)
    sDay = "0"+sDay;
    
    sMonth = d.getMonth()+1;		
    if(sMonth < 10)
    sMonth = "0"+sMonth;
    
    sYear  = d.getYear();	
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    var sSeconds=d.getSeconds()
    	
    s=sYear +"-"+sMonth+"-"+sDay+" "+sHoure+":"+sMintues+":"+sSeconds ;
    
    return s;

}


function comptime(Time) 
{
	var endTime=GetCurrentDate();
	
    var beginTime = Time;
    
    var beginTimes = beginTime.substring(0, 10).split('-');
    var endTimes = endTime.substring(0, 10).split('-');

    beginTime = beginTimes[1] + '-' + beginTimes[2] + '-' + beginTimes[0] + ' ' + beginTime.substring(10, 19);
    endTime = endTimes[1] + '-' + endTimes[2] + '-' + endTimes[0] + ' ' + endTime.substring(10, 19);

    var a = (Date.parse(endTime) - Date.parse(beginTime)) / 3600 / 1000;
   
    if(a>=0)
    {
	    return "true"
	}
	else
	{
		return "false"
	}
	
}

function GetSchduleID()
{
	 var value=""
	 if (gOEOrdItemDr!="")
	 {
	    var SchduleIDFun=$("GetSchduleID").value;
	    value=cspRunServerMethod(SchduleIDFun,gOEOrdItemDr);
	 }
	 
	 return value;
}

function Lnk()
{
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisPatRegisterEx"+"&LocDR="+gLocId+"&PaadmDR="+gPaadmdr+"&OeorditemID="+gOEOrdItemDr+"&ResSchudleDR="+gSchudleRowid;
	 parent.frames['PatRegisterEx'].location.href=lnk;
}

document.body.onload = BodyLoadHandler;


