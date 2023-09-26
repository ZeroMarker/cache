/// dhcpha.phaward1.js
var catpid=0;
function BodyLoadHandler()

{
  SetTableTitle();
  document.onkeydown=OnKeyDownHandler;
  //SetChecked();
  SetDisabled()//设置勾选框默认格式
  //obj=document.getElementById("t"+"dhcpha_phaward1") ;
  //if (obj) obj.ondblclick=wardDblClick;
  obj=document.getElementById("FindAllWard") ;
  if (obj) obj.onclick=FindClick;
}


function OnKeyDownHandler(e)
{
       var key=websys_getKey(e);
       if (key==115){ReadHFMagCard_Click();}	//F4 
}
 
function ReadHFMagCard_Click()
{
	 var docu=parent.frames['dhcpha.phadisp'].document
     if (docu){
	     var objBReadCard=docu.getElementById("BReadCard") ;
	     if (objBReadCard){
		     objBReadCard.click()
	     }
     }
}
 
function SelectRowHandler(e){
	 var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  ss=selindex.split("z")
  if (ss[0]=="TSelect")return;
	KillTmp();
	var row=selectedRow(window);
	var obj=document.getElementById("CurrentRow") ;
	if (obj) obj.value=row
	if (row<1) return ; //
	var sd="",ed="",ward="",wardid="",disploc="",displocrowid="",pri="";
	var docu=parent.frames['dhcpha.phaward'].document
	if (docu){
		var obj=docu.getElementById("displocrowid")
		if (obj) displocrowid=obj.value;
		var obj=docu.getElementById("DispLoc")
		if (obj) disploc=obj.value;
		var obj=docu.getElementById("StartDate")
		if (obj) sd=obj.value;
		var obj=docu.getElementById("EndDate")
		if (obj) ed=obj.value;
		var obj=docu.getElementById("StartTime")
		if (obj) st=obj.value;
		var obj=docu.getElementById("EndTime")
		if (obj) et=obj.value;
		var obj=docu.getElementById("pri");
		if (obj) pri=obj.value;
 }
 //row++;   //老版显示用?新版不用 Liang Qiang 
 var obj=document.getElementById("t"+"dhcpha_phaward1")
 var cnt=getRowcount(obj);
 var wardidstr=""
 catpid=GetPid();
 
 
	 var obj=document.getElementById("TWardRowid"+"z"+row)
     if (obj) wardid=obj.value;
     var obj=document.getElementById("TWard"+"z"+row)
     if (obj) ward=obj.innerText;
     catlist=getCheckedCats(row);
     SaveCatListByWard(wardid,catlist,catpid); //不知道干什么的暂时注释，类里没有这个方法wyx 2014-11-12
     wardidstr=wardid
	 
 //var obj=document.getElementById("TWardRowid"+"z"+row)
 //if (obj) wardid=obj.value;
 //var obj=document.getElementById("TWard"+"z"+row)
 //if (obj) ward=obj.innerText;
 
 //pass the info into dispensing interface
 var docu=parent.frames['dhcpha.phadisp'].document
 if (docu){
	  var obj=docu.getElementById("StartDate")
	  if (obj) obj.value=sd;
	  var obj=docu.getElementById("EndDate")
	  if (obj) obj.value=ed;
	  var obj=docu.getElementById("Ward")
	  if (obj) obj.value=ward
	  var obj=docu.getElementById("wardrowid")
	  if (obj) obj.value=wardidstr
	  var obj=docu.getElementById("DispLoc")
	  if (obj) obj.value=disploc
	  var obj=docu.getElementById("displocrowid")
	  if (obj) obj.value=displocrowid
	  var st=""
	  var et=""
	  var obj=docu.getElementById("StartTime")
	  if (obj) obj.value=st;
	  var obj=docu.getElementById("EndTime")
	  if (obj) obj.value=et;
	  var obj=docu.getElementById("onlypivaflag")
	  if (obj) obj.value="";
	  var obj=docu.getElementById("pri");
	  if (obj) obj.value=pri;
		//GetInitPack();  //本地设置?仅整包装?,"仅散包装"
	  
	  //catlist=getCheckedCats(row);
	  if (catlist=="") {alert("请选择一个类别");} //return;}
	  catlist=catlist+"#"+pri+"#"+catpid;
	  var obj=docu.getElementById("DispCat")
	  if (obj) obj.value=catlist;
	  
	  
	  //zhouyg 20141217 
	  var objpara=docu.getElementById("ParaStr")
	  if(objpara) var para=objpara.value;
	  var paraArray=para.split("^");
	  var DispDefault=paraArray[8];
	  if ((DispDefault!=2))
	  {	
		if (DispDefault==0)
			{
			     var objShortOrd=docu.getElementById("ShortOrd");
			     var objb=docu.getElementById("ShortOrdFlag");
	             if (objShortOrd)
	             {
					objShortOrd.checked=true;
					objb.value=1;
	             }	
	             var obj1=docu.getElementById("LongOrd");
	             var obj3=docu.getElementById("LongOrdFlag");
	             if (obj1) {obj1.checked=false};
			     if (obj3) {obj3.value=0 }
			}
		if (DispDefault==1)
			{
			     var objLongOrd=docu.getElementById("LongOrd");
			     var obja=docu.getElementById("LongOrdFlag");
	             if (objLongOrd)
	             {
		             objLongOrd.checked=true;
		             obja.value=1;
	             }
	             var obj2=docu.getElementById("ShortOrd");
	             var obj4=docu.getElementById("ShortOrdFlag");
	             if (obj2) {obj2.checked=false};
			     if (obj4) {obj4.value=0 }
			}
			var obj5=docu.getElementById("OutWithDrugOrd");
	        var obj6=docu.getElementById("OutWithDrugFlag");
	        var obj7=docu.getElementById("EmOrd");
	        if (obj5) {obj5.checked=false};
			if (obj6) {obj6.value=0}
	        if (obj7) {obj7.checked=false;}
		}
	  var obj=docu.getElementById("Collect")
	  if (obj) {obj.click()}
 }
}

function GetInitPack()
{
	//Description:取本地设置?仅整包装?,"仅散包装"
	//return -1
	
	var arr=GetHeader("C:\\WINDOWS\\DHCSTPHASETUP.txt").split("\r\n");
	
	for(var i=1;i<arr.length-1;i++)
	{
		var tmpcode=arr[i]
        if (tmpcode.indexOf("ISPACK")!=-1)
		{
			var docu=parent.frames['dhcpha.phadisp'].document
			var arr=tmpcode.split("=")
			var ispack=arr[1]
			if (ispack==1)
			{
				var obj=docu.getElementById("ISPACK");
				if (obj){if (!obj.checked){obj.click()} } 
				
			}
			if (ispack==0)
			{	
			    var obj=docu.getElementById("NOPACK");
				if (obj){if (!obj.checked){obj.click()} }
			}
			
		}
	
     }
      
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
	var docu=parent.frames['dhcpha.phaward'].document
	
	var obj=docu.getElementById("displocrowid");
	if (obj) 
	{
		var cnt=0;
		var disploc=obj.value;
	
		var dispcats=GetLocDispType(disploc);
		if(dispcats!="")
		{
			var cats=dispcats.split("^")
			var cnt=cats.length
		}
		
		var strcats=""
		var i=0		
		for(i=0;i<cnt;i++)
		{
		  
			var cat=cats[i].split("@");
			var catdesc=cat[1];
			var catcode=cat[0];
	
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
			
	var objTable=document.getElementById("t"+"dhcpha_phaward1");
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
			var objCell=document.getElementById("TCat"+col+"z"+j);
			//alert("Cat"+col+"||"+j);
			if(objCell)objCell.style.display="none";	
		}
		
		//隐藏标题列
		//alert(i);
		var obj=document.getElementById(i);
		if (obj) obj.style.display="none";
	}
 
}

function SetChecked()
{
	var obj=document.getElementById("t"+"dhcpha_phaward1")
	var cnt=getRowcount(obj);
	
	var i=0;
	var j=0;
	for(i=1;i<=cnt;i++)
	{
		for(j=0;j<10;j++)
		{
            
            var objTCat=document.getElementById("TCat"+j+"z"+i)

			var varChecked=getVal("TCat"+j,i);
			
			if (varChecked=="1")
			{
				var objcol=document.getElementById("Cat"+j+"z"+i)
				if (objcol) {objcol.checked=true; }
			}
		}
		
		//var varChecked=getVal("TCat1",i);
	}

}

function getVal(colname,row)
{
	var result="";
	var obj=document.getElementById(colname+"z"+row)
	if (obj) {result=obj.value;}
	
	return result 

}


function getCheckedCats(currrow)
{
	var i=0;
	var checkedcats="";
	
	for(i=0;i<10;i++)
	{
		var objCheck=document.getElementById("TCat"+i+"z"+currrow);
		if (objCheck)
		{	
		    
			if(objCheck.checked==true)
			{  
			    
				var objCat=document.getElementById("Cat"+i+"RowID");
	
				if(objCat) 
				{checkedcats=checkedcats+"^"+objCat.value; }
				 
			}
		}
	}
	checkedcats.Trim;
	return checkedcats.substring(1,checkedcats.length);

}

function GetPhaConfig(item)
{
  ///Description:取住院药房配置
  ///Input:item
  ///Return:config
  ///Creator:LQ 2009-01-20
  var docu=parent.frames['dhcpha.getphaconfig'].document
  var obj=docu.getElementById("GetPhaConfig")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var config=cspRunServerMethod(encmeth,item)
  return config
  
}

function GetInitLimitCats(code)
{
	//return -1
	
	var arr=GetHeader("C:\\WINDOWS\\DHCSTPHASETUP.txt").split("\r\n");
	
	for(var i=1;i<arr.length-1;i++)
	{
		var tmpcode=arr[i]
		if (tmpcode.indexOf(code)!=-1)
		{
			return 1
		}
	  //alert("第"+(i+1)+"行数据为:"+arr[i]);
     }
     return 0

} 
/*
			var config=GetPhaConfig("Con_DispTypeLocal")//取本地设置
			if (config=1)
			{
				var ret=GetInitLimitCats(catcode) 
		        if (ret==1)
		        {
			        
			    }
			}
*/
function HideTypeColsByLocal()
{
	var obj=document.getElementById("t"+"dhcpha_phaward1")
	var cnt=getRowcount(obj);
	
	for(i=0;i<10;i++)
	{
		var objCheck=document.getElementById("TCat"+i+"z"+currrow);
	}

}
function SaveCatListByWard(wardid,catlist,pid)
{
	var obj=document.getElementById("mSaveCatListByWard")
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var config=cspRunServerMethod(encmeth,wardid,catlist,pid)
}
function GetPid()
{
	var obj=document.getElementById("mGetPid")
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var pid=cspRunServerMethod(encmeth)
    return pid
}
function KillTmp()
{
	var obj=document.getElementById("mKillTmp")
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var ret=cspRunServerMethod(encmeth,catpid)
}
function SetDisabled()
{
	var obj=document.getElementById("t"+"dhcpha_phaward1")
	var cnt=getRowcount(obj);
	var SelectCatFlag="";
	var objpara=parent.frames['dhcpha.phaward'].window.document.getElementById("ParaStr");
	if (objpara) parastr=objpara.value;
	if (parastr!="")
	{
	 var tmparr=parastr.split("^");
	 var SelectCatFlag=tmparr[25];
	}
	var i=0;
	var j=0;
	for(i=1;i<=cnt;i++)
	{
		for(j=0;j<10;j++)
		{
            
            var objTCat=document.getElementById("TCat"+j+"z"+i)
			//alert("TCat"+j+"z"+i)
			//alert(objTCat.checked)
			if (objTCat.checked==true){
				     if (SelectCatFlag!="Y"){objTCat.checked=false;}
				}
			else{
				objTCat.disabled=true;
				}
		}
	}
}

function FindClick()
{
		KillTmp();
	var row=selectedRow(window);
	var obj=document.getElementById("CurrentRow") ;
	if (obj) obj.value=row
	//if (row<1) return ; //
	var sd="",ed="",ward="",wardid="",disploc="",displocrowid="",pri="";
	var docu=parent.frames['dhcpha.phaward'].document
	if (docu){
		var obj=docu.getElementById("displocrowid")
		if (obj) displocrowid=obj.value;
		var obj=docu.getElementById("DispLoc")
		if (obj) disploc=obj.value;
		var obj=docu.getElementById("StartDate")
		if (obj) sd=obj.value;
		var obj=docu.getElementById("EndDate")
		if (obj) ed=obj.value;
		var obj=docu.getElementById("StartTime")
		if (obj) st=obj.value;
		var obj=docu.getElementById("EndTime")
		if (obj) et=obj.value;
		var obj=docu.getElementById("pri");
		if (obj) pri=obj.value;
 }
 //row++;   //老版显示用?新版不用 Liang Qiang 
 var obj=document.getElementById("t"+"dhcpha_phaward1")
 var cnt=getRowcount(obj);
 var wardidstr=""
 catpid=GetPid();
 
 for(i=1;i<=cnt;i++){
	 var objsel=document.getElementById("TSelect"+"z"+i)
	 if(objsel.checked==true){
	 var obj=document.getElementById("TWardRowid"+"z"+i)
     if (obj) wardid=obj.value;
     var obj=document.getElementById("TWard"+"z"+i)
     if (obj) ward=obj.innerText;
     catlist=getCheckedCats(i);
     SaveCatListByWard(wardid,catlist,catpid); //不知道干什么的暂时注释，类里没有这个方法wyx 2014-11-12
     if(wardidstr!=""){wardidstr=wardidstr+"^"+wardid}
     else{wardidstr=wardid}
	 }
 }
 //var obj=document.getElementById("TWardRowid"+"z"+row)
 //if (obj) wardid=obj.value;
 //var obj=document.getElementById("TWard"+"z"+row)
 //if (obj) ward=obj.innerText;
 
 //pass the info into dispensing interface
 var docu=parent.frames['dhcpha.phadisp'].document
 if (docu){
	  var obj=docu.getElementById("StartDate")
	  if (obj) obj.value=sd;
	  var obj=docu.getElementById("EndDate")
	  if (obj) obj.value=ed;
	  var obj=docu.getElementById("Ward")
	  if (obj) obj.value=ward
	  var obj=docu.getElementById("wardrowid")
	  if (obj) obj.value=wardidstr
	  var obj=docu.getElementById("DispLoc")
	  if (obj) obj.value=disploc
	  var obj=docu.getElementById("displocrowid")
	  if (obj) obj.value=displocrowid
	  var st=""
	  var et=""
	  var obj=docu.getElementById("StartTime")
	  if (obj) obj.value=st;
	  var obj=docu.getElementById("EndTime")
	  if (obj) obj.value=et;
	  var obj=docu.getElementById("onlypivaflag")
	  if (obj) obj.value="";
	  var obj=docu.getElementById("pri");
	  if (obj) obj.value=pri;
		//GetInitPack();  //本地设置?仅整包装?,"仅散包装"
	  
	  //catlist=getCheckedCats(row);
	  if (catlist=="") {alert("请选择一个类别");return;}
	  catlist=catlist+"#"+pri+"#"+catpid;
	  var obj=docu.getElementById("DispCat")
	  if (obj) obj.value=catlist;
	  
	  
	  //zhouyg 20141217 
	  var objpara=docu.getElementById("ParaStr")
	  if(objpara) var para=objpara.value;
	  var paraArray=para.split("^");
	  var DispDefault=paraArray[8];
	  if ((DispDefault!=2))
	  {	
		if (DispDefault==0)
			{
			     var objShortOrd=docu.getElementById("ShortOrd");
			     var objb=docu.getElementById("ShortOrdFlag");
	             if (objShortOrd)
	             {
					objShortOrd.checked=true;
					objb.value=1;
	             }	
	             var obj1=docu.getElementById("LongOrd");
	             var obj3=docu.getElementById("LongOrdFlag");
	             if (obj1) {obj1.checked=false};
			     if (obj3) {obj3.value=0 }
			}
		if (DispDefault==1)
			{
			     var objLongOrd=docu.getElementById("LongOrd");
			     var obja=docu.getElementById("LongOrdFlag");
	             if (objLongOrd)
	             {
		             objLongOrd.checked=true;
		             obja.value=1;
	             }
	             var obj2=docu.getElementById("ShortOrd");
	             var obj4=docu.getElementById("ShortOrdFlag");
	             if (obj2) {obj2.checked=false};
			     if (obj4) {obj4.value=0 }
			}
			var obj5=docu.getElementById("OutWithDrugOrd");
	        var obj6=docu.getElementById("OutWithDrugFlag");
	        var obj7=docu.getElementById("EmOrd");
	        if (obj5) {obj5.checked=false};
			if (obj6) {obj6.value=0}
	        if (obj7) {obj7.checked=false;}
		}
	  var obj=docu.getElementById("Collect")
	  if (obj) {obj.click()}
 }
}


document.body.onload=BodyLoadHandler;
