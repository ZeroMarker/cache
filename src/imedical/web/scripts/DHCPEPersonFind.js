 //DHCPEPersonFind.js
 // create by zhouli
 var SelectedRow="";
 var ComponentRows=0;
 var CurrentRow=0
function BodyLoadHandler()
{	
	var obj
	
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
	
 	obj=document.getElementById('RegNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
		
    obj=document.getElementById("GADMDR");
    if (obj) { iGADMDR=obj.value};
    
    obj=document.getElementById("TeamDesc");
	if (obj) {obj.onchange=TeamDesc_Change; }
	
	obj=document.getElementById("SelectAll");
	if (obj) {obj.onclick=SelectALL_Click;}
   
   
   
   InitListInfo();
	
}
function SelectALL_Click() 
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('tDHCPEPersonFind');	//取表格元素?名称
	var row=tbl.rows.length;

	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		var obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj) { obj.checked=Src.checked; }
	}
	
}

function InitListInfo()
{  
   var i,objChk;
	var objtbl=document.getElementById('tDHCPEPersonFind');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 

	for (i=1;i<=rows;i++)
	{
		objChk=document.getElementById('TSelectz'+i);

		if (objChk)
		{  
			objChk.disabled=false;
			
			objChk.onclick=check_Click;
			
		}
	}	
	
	}

function check_Click()
{   
    var SelectIds="",PatRegNo=""
	var eSrc = window.event.srcElement;
	var addflag=eSrc.checked;
	var rowObj=getRow(eSrc);
	var SelectIds=document.getElementById("SelectRows")
	var selectrow=rowObj.rowIndex;
	var PatRegNo=document.getElementById("TPatRegNoz"+selectrow);
	alert(PatRegNo)

	if (addflag)
	{
		if (SelectIds=="") SelectIds=SelectIds+"^"		
		SelectIds=SelectIds+PatRegNo+"^";
	}
   alert(SelectIds)
	
	SetCtlValueById("SelectRows",SelectIds,0);
}
function GetTeamID(value){
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj=document.getElementById('TeamID')
		 obj.value=temp[1]
		var obj=document.getElementById('TeamDesc')
    	 obj.value=temp[0]}
	} 


 function RegNo_keydown(e) {
	var key=websys_getKey(e);
	if (13==key) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"PatRegNo");
		if (obj) obj.click();}
	}
}	
	
function TeamDesc_Change()
{  
	var obj=document.getElementById("TeamID");
	if (obj) { obj.value=""; }
}	
	
function BFind_Click()
{ 
   var iTeamID="",iRegNo="",iGADMDR=""
   var obj
   obj=document.getElementById("TeamID");
    if (obj) { iTeamID=obj.value};
	
	obj=document.getElementById("RegNo");
    if (obj) { iRegNo=obj.value};
    
    obj=document.getElementById("GADMDR");
    if (obj) { iGADMDR=obj.value};
    
    
    if ((iTeamID=="")&&(iRegNo=="")){
		alert(t['01']);
		return false;	}
		alert(iTeamID+"^"+iRegNo+"^"+iGADMDR)
       
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPersonFind"
			+"&RegNo="+iRegNo
			+"&TeamID="+iTeamID
			+"&GADMDR="+iGADMDR
	
	
   	
 
    location.href=lnk; 
    
    objChk=document.getElementById('TSelectz'+i);
		if (objChk)
		{
			objChk.disabled=false;
			objChk.onclick=Chk_Click;
		}	

}	
	
	
	
	
	
	
	
	
	
	
function Print_Select()
{
  var Src=window.event.srcElement;

  var tbl=document.getElementById('tDHCPEPersonFind');//取表格元素?名称
  var row=tbl.rows.length;

  for (var iLLoop=1;iLLoop<=row;iLLoop++) {
  obj=document.getElementById('TSelect'+'z'+iLLoop);
  if (obj) { obj.checked=!obj.checked; }
  if (obj)
		{
			obj.disabled=false;
			obj.onclick=Chk_Click;
		}		
}
}	


function Chk_Click()
{
	var eSrc = window.event.srcElement;
	var addflag=eSrc.checked;
	var rowObj=getRow(eSrc);
	var SelectIds=GetCtlValueById("SelectRows")
	var selectrow=rowObj.rowIndex;
	
	var IADMDR=GetCtlValueById("TIADMDRz"+selectrow);
	var IADMInfos="";
	
	if ((""!=IADMDR)) IADMInfos=IADMDR;
	//alert(itemfeeinfos);
	if (addflag)
	{
		if (SelectIds=="") SelectIds=SelectIds+"^"		
		SelectIds=SelectIds+IADMInfos+"^";
	}
	else
	{
		SelectIds=SelectIds.replace("^"+IADMInfos+"^","^");
	}
	SetCtlValueById("SelectRows",SelectIds,0);
}	
	
	
/*
function ARCIMDESC_keydown(e) {
	var key=websys_getKey(e);
	if (13==key) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"iARCIMDESC");
		if (obj) obj.click();}
	}
}

function GroupName_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
}
function ARCIMDESC_Change()
{
	var obj=document.getElementById("ARCIMDescID");
	if (obj) { obj.value=""; }
}

function GetGroupID(value){
	
	var temp=value.split("^")
	if(""==value){return false}
	else{
		var obj=document.getElementById('GroupName')
		 obj.value=temp[1]
		var obj=document.getElementById('GroupID')
    	 obj.value=temp[0]}
	} 

function SearchOrdID(value){
	
	var temp=value.split("^")
	if(""==value){return false}
	else{
		 var obj=document.getElementById('ARCIMDescID')
		 obj.value=temp[1]
		 var obj=document.getElementById('ARCIMDESC')
		 obj.value=temp[0]}
		} 
		

function Find_Click()
{ 
   var iStdate="",iEnddate="",iSttime="",iEndtime="",iARCIMDescID="",iARCIMDESC="",iGroupID=""
   var obj
   obj=document.getElementById("DateFrom");
    if (obj) { iStdate=obj.value};
	
	obj=document.getElementById("TimeFrom");
    if (obj) { iSttime=obj.value};
    
    
    obj=document.getElementById("DateTo");
    if (obj) { iEnddate=obj.value};
	
	obj=document.getElementById("TimeTo");
    if (obj) { iEndtime=obj.value};
    
    obj=document.getElementById("ARCIMDescID");
    if (obj) { iARCIMDescID=obj.value};

    
    obj=document.getElementById("ARCIMDESC");
    if (obj) { iARCIMDESC=obj.value};
    
    obj=document.getElementById("GroupID");
    if (obj) { iGroupID=obj.value};
     
    alert(iGroupID)
   
    if ((""==iARCIMDESC)){
		alert(t['01']);
		return false;	}
  
     
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEBarFind"
			+"&DateFrom="+iStdate
			+"&TimeFrom="+iSttime
			+"&DateTo="+iEnddate
			+"&TimeTo="+iEndtime
			+"&ARCIMDescID="+iARCIMDescID
			+"&GroupID="+iGroupID

    location.href=lnk; 

}

 function DateTime(){
   var d, s ="";
   d = new Date();
   s += d.getYear() + "-";
   s += (d.getMonth()+1) + "-";
   s += d.getDate();
   var temp=d.getUTCMinutes()
   if((temp/10)<1)
   {   
	   temp="0"+temp
   }
   s += " "+d.getHours()+":"+temp;
   return(s);
}

     
function Print_Click()
{  var iStdate="",iEnddate="",iSttime="",iEndtime="",iARCIMDescID="",iARCIMDESC="",iGroupID=""
   var obj
    obj=document.getElementById("DateFrom");
    if (obj) { iStdate=obj.value};
	
	obj=document.getElementById("TimeFrom");
    if (obj) { iSttime=obj.value};
    
    
    obj=document.getElementById("DateTo");
    if (obj) { iEnddate=obj.value};
	
	obj=document.getElementById("TimeTo");
    if (obj) { iEndtime=obj.value};
    
    obj=document.getElementById("ARCIMDescID");
    if (obj) { iARCIMDescID=obj.value};

    
    obj=document.getElementById("ARCIMDESC");
    if (obj) { iARCIMDESC=obj.value};
    
    obj=document.getElementById("GroupID");
    if (obj) { iGroupID=obj.value};



    var obj
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEBarList.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
	var dt=DateTime();
	
	
	var DateFrom,DateTo

	var Ins=document.getElementById('DateBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }

	var value=encmeth;
	if (value=="") return;
	var tmp=value.split("^");
	
	var datefrom=tmp[0]
    var dateto=tmp[1]
    var timefrom=tmp[2]
    var timeto=tmp[3]
    var arcimdesc=tmp[4]
    var ordprice=tmp[5]
   
    xlsheet.cells(2,1).Value="打印日期时间:"+dt
    xlsheet.cells(3,1).Value="开始日期时间:"+datefrom+" "+timefrom
    xlsheet.cells(4,1).Value="结束日期时间:"+dateto+" "+timeto
    //xlsheet.cells(5,1).Value="医嘱名称:"+arcimdesc
    xlsheet.cells(5,1).Value="医嘱名称:"+arcimdesc+"      "+"医嘱价格:"+ordprice
    obj=document.getElementById("ClassBox")
	var strinfo=obj.value
	var DataArr=strinfo.split("!");
	var i=DataArr.length;
	for (j=1;j<i;j++)
	{
		var Data=DataArr[j]
		
		var DataStr=Data.split("^");
		
		///插入一行
		xlsheet.Rows(j+6).insert();
		
		
		for(var k=0;k<DataStr.length;k++)
		{	
		 xlsheet.cells(j+6,k+1).Value=DataStr[k]; //标本号
		// var row=document.getElementById(TSort+"z"+(k+1))
		 //if (CurrentRow) CurrentRow.innerText=AddRows+(+j)
		   // SetSort("tDHCPEBarFind","TSort",ComponentRows)
	      // xlsheet.cells(j+6,1).Value=CurrentRow.innerText;
	      // xlsheet.cells(j+6,k+2).Value=DataStr[k]; //标本号
		}
	   		
	}
	
	
	///删除最后的空行
	xlsheet.Rows(j+6).Delete;
	
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}

  function SetSort(TableName,ElementName,RowsOfPages)
{
	var obj=document.getElementsByTagName("SMALL");
	var Page=1
	if(obj[0]) Page=obj[0].innerText;
	var AddRows=(+Page-1)*RowsOfPages
	var obj=document.getElementById(TableName);	
	if (obj) { var rows=obj.rows.length; }
	for (var j=1;j<rows;j++)
	{
		CurrentRow=document.getElementById(ElementName+"z"+j)
		if (CurrentRow) CurrentRow.innerText=AddRows+(+j)
	
	}
	
}
function GetCompoentRows(ComponentName)
{
	var obj=document.getElementById("GetRowsClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return 0;
	}
	var ComponentRows=cspRunServerMethod(encmeth,session['CONTEXT'],ComponentName)
	if (ComponentRows=="") ComponentRows=25;
	return ComponentRows
}  
*/


document.body.onload = BodyLoadHandler;