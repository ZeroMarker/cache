//alert("the table date is loaded?");
//
var SelectedRow=0
var Rows
function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEIAdmItemStatusDetail');	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById('TStatusz'+j);
		var sTD=sLable.parentElement;
		var strCell=sLable.innerText;
		strCell=strCell.replace(" ","")
		if ((strCell=='执行')||(strCell=="Executed")) {
			//sTD.className="Govement";
			sTD.bgColor="#00CC66"
		}
		else if (strCell=='谢绝检查') {
			sTD.bgColor="#FF0000"
			}
		 	else if ((strCell=='停止')||(strCell=="D/C(Discontinued)")){
			 	sTD.bgColor="#FF88FF"
				}
		    	else {
					sTD.className="DentalSel";
		 		}
	var obj=document.getElementById('TLabNoz'+j);
	if ((obj&&obj.innerText==" ")||(obj&&strCell=="停止"))
	{ 
		obj=document.getElementById('TPlacerNoz'+j);
		if (obj) obj.disabled=true;
	}
	else if (obj)
	{
		obj=document.getElementById('TPlacerNoz'+j);
		if (obj) obj.onkeydown = SetPlacer;
	}
	var objArcim=document.getElementById('TItemNamez'+j).parentElement;
	var objPlacerCode=document.getElementById('placerCodez'+j);
	var placerCode="";
	if (objPlacerCode) {placerCode=objPlacerCode.value;}
	objArcim.bgColor=placerCode;
	/*
	switch (placerCode)  
	{
	   case "A":objArcim.className="Purple";break;//"Black"; break;
	   case "C":objArcim.className="Gray";break;
	   case "R":objArcim.className="Red";break;//objArcimDesc.style.color="Red";break;
	   case "P":objArcim.className="Fuchsia";break;
	   case "Y":objArcim.className="Yellow";break;//"#ffff80";objArcimDesc.style.FONTWEIGHT="bold";break;//"Yellow";break;
	   case "G":objArcim.className="Green";break;
	   case "H":objArcim.className="Black";break;
	   case "B":objArcim.className="Blue";break;
	   case "W":objArcim.className="White";break;
	   //case "O":objArcim.className="Maroon";break;
	   case "O":objArcim.className="Brown";break;
	   case "Q":objArcim.className="Orange";break;
	   default:  //"Exec"
	   //RowObj.className="Exec";//AH "Needless";
	}
	*/
	
	}
}
function SendInfo(e)
{
	//var OEORIID=e.id;
	var eSrc=window.event.srcElement;
	var OEORIID=eSrc.id.split("^")[0];
	//alert(OEORIID)
	var obj,encmeth="";
	obj=document.getElementById("SendInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,OEORIID);
	if(ret.split("^")[0]="-1")
	{
		alert(ret.split("^")[1])
	}
	return false;
}

function CancelSendInfo(e)
{
	//var OEORIID=e.id;
	var eSrc=window.event.srcElement;
	var OEORIID=eSrc.id.split("^")[0];
	//alert(OEORIID)
	var obj,encmeth="";
	obj=document.getElementById("CancelSendInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,OEORIID);
	if(ret.split("^")[0]="-1")
	{
		alert(ret.split("^")[1])
	}
	return false;

}


function Ini(){
	ColorTblColumn();
	Rows=GetTotalRows();
	SetChoiceSpecName();
	var obj=document.getElementById("BUpdateSpec");
	if (obj) obj.onclick=BUpdateSpec_click;
	var obj=document.getElementById("BSaveNoPrint");
	if (obj) {
		obj.onclick=Save_Click;
		obj.ondbclick=Save_Click;
	}
	var obj=document.getElementById("BPrintBChao");
	if (obj) obj.onclick=BPrintBChao_Click;

	var tbl=document.getElementById('tDHCPEIAdmItemStatusDetail'); 
	var row=tbl.rows.length;
	for (var i=1;i<row;i++) {
		var obj=document.getElementById("TIdz"+i);
	    if(obj){ var OEORIID=obj.value}
		var obj=document.getElementById(OEORIID+"^send");
	    if(obj){ obj.onclick=SendInfo;}
	    var obj=document.getElementById(OEORIID+"^cancel");
	    if(obj){ obj.onclick=CancelSendInfo;} 
	    
	}
	

	
}
function BUpdateSpec_click()
{
	var obj,Source="",To="",encemth="";
	obj=document.getElementById("Source");
	if (obj) Source=obj.value;
	obj=document.getElementById("To");
	if (obj) To=obj.value;
	if (Source=="")
	{
		alert("原标本号不能为空");
		return false;
	}
	if (To=="")
	{
		alert("更新标本号不能为空");
		return false;
	}

	obj=document.getElementById("UpdateSpecClass");
	if (obj) encemth=obj.value;
	var ret=cspRunServerMethod(encemth,Source,To);
	window.location.reload();
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEIAdmItemStatusDetail');	
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	

     
    ///此处之前较为固定?除了修改document.getElementById('tINSUPatTypeC
    
    if (!selectrow) return;

	if (selectrow!=SelectedRow)
	{
		SelectedRow=selectrow
	}
	else
	{
		SelectedRow=0
	}
}
function GetOneSpecNo()
{
	if (SelectedRow==0) return "^"
	var obj,OneLabNo="",IAdmId="";
	obj=document.getElementById("TLabNoz"+SelectedRow)
	if (obj) OneLabNo=obj.innerText;
	obj=document.getElementById("txtIAdmId");
	if (obj) IAdmId=obj.value;
	return IAdmId+"^"+OneLabNo
}
function GetOneOrdItem()
{
	var obj,OneLabNo="",IAdmId="",RetStr="";
	for (var j=1;j<Rows+1;j++) {
		obj=document.getElementById('TSelectz'+j);
		if (obj&&obj.checked)
		{
			obj=document.getElementById('TIdz'+j);
			if (obj) OneLabNo=obj.value;
			obj=document.getElementById("txtIAdmId");
			if (obj) IAdmId=obj.value;
			if (RetStr=="")
			{
				RetStr=IAdmId+"^"+OneLabNo
			}
			else
			{
				RetStr=RetStr+"&"+IAdmId+"^"+OneLabNo
			}
		}
	}
	if (RetStr=="")
	{
		//if (RetStr=="")  RetStr="^"
		//return RetStr
		if (SelectedRow==0) return "^"
		var obj,OneLabNo="",IAdmId="";
		obj=document.getElementById("TIdz"+SelectedRow)
		if (obj) OneLabNo=obj.value;
		obj=document.getElementById("txtIAdmId");
		if (obj) IAdmId=obj.value;
		return IAdmId+"^"+OneLabNo
	}
	return RetStr
}

function GetTotalRows() {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEIAdmItemStatusDetail');	
	if (objtbl) { var rows=objtbl.rows.length; }
	return rows-1
}
function SetChoiceSpecName()
{
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TSpecNamez'+j);
		var ItemStatobj=document.getElementById('TStatusz'+j);
		var ItemStat="执行";
		if (ItemStatobj) ItemStat=trim(ItemStatobj.innerText);
		var obj=document.getElementById('TLabNoz'+j);
		
		var ItemID="";
		if (obj) ItemID=trim(obj.innerText);
		if ((ItemID!="")&&(ItemStat=="核实"))
		{
			
			if (sLable) sLable.onkeydown = ChoiceSpecName;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
	}
}

function ChoiceSpecName()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;
		row=payModeName.substr(10,payModeName.length)
		if (row==0) return;
		var obj=document.getElementById('TItemIdz'+row);
		var ItemID="";
		if (obj) ItemID=obj.value;
		if (ItemID=="") return;
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.BarPrint:SerchSpecName";
		url += "&TLUJSF=SetSpecName";
		url += "&P1="+ItemID;
		websys_lu(url,1,"");
		return websys_cancel();
	}

}
function SetSpecName(value)
{
	var RecStr=value.split("^");
	var SpecID=RecStr[0];
	var SpecName=RecStr[1];
	var obj=document.getElementById('TPreItemIDz'+row);
	if (obj) var RowID=obj.value;
	obj=document.getElementById('UpdateSpecName');
	if (obj) var encmeth=obj.value;
	var Flag=cspRunServerMethod(encmeth,SpecID+"^"+SpecName,RowID,"PERSON")
	if (Flag!=0)
	{
		//alert(Flag);
		return;
	}
	var obj=document.getElementById('TSpecNamez'+row);
	if (obj) obj.value=SpecName;
}

function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}

function SetPlacer()
{
	if (event.keyCode==13)
	{   
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;
		row=payModeName.substr(10,payModeName.length)
		alert(row)
		if (row==0) return;
		var sLable=document.getElementById('TPlacerNoz'+row);
		var labNo=document.getElementById('TLabNoz'+row).innerText
		var strCell=trim(sLable.value);
		if (strCell=="") return;
		var obj=document.getElementById('TIdz'+row);
		var OEID=""
		if (obj) OEID=trim(obj.value);
		if (OEID!=""){
			var	Strings=OEID+";"+strCell+";"+labNo
			
		}
	 
		TObj=parent.frames["DHCPEIAdmItemStatusAdms"];
		var obj=TObj.document.getElementById("GetBillStatus");
	    if (obj) var encmethobj=obj.value;
        var flag=cspRunServerMethod(encmethobj,Strings);
        if (flag==6)
        { 
            alert(t[flag])
            location.reload();
             return false}
           
		var encmethobj=TObj.document.getElementById("UpdateBarInfo");
		if (encmethobj) var encmeth=encmethobj.value;
		var ReturnStr=cspRunServerMethod(encmeth,Strings,"N");
		if (ReturnStr!=0) alert(ReturnStr)
	
		// location.reload();
		// by zhouli 焦点自动换行 start 
		var labNo=document.getElementById("TLabNoz"+row).innerText;
		var placerNo=document.getElementById("TPlacerNoz"+row).value;
         for (i=1;i<=Rows;i++)
              
	    	{ 
		    	var curLabNo=document.getElementById("TLabNoz"+i).innerText;
		    
		    	if ((i!=row)&&(curLabNo==labNo))
		    	{
		    	
	    		 document.getElementById("TPlacerNoz"+i).innerText=placerNo;
	    		 
			   		}}
		   var row=parseInt(row)
		   for (i=row+1;i<=Rows;i++)
			{	
				placerNo=document.getElementById("TPlacerNoz"+i).value; 
		        if (document.getElementById("TPlacerNoz"+i).disabled==true){continue;}
	            //if (document.getElementById("TPlacerNoz"+i).innerText!=""){continue;}
				if (placerNo.length<1)
				{  
					var obj=document.getElementById("TPlacerNoz"+i);
					
					obj.focus();
					return;
				}
	    	}
		// by zhouli end
	}

}


//得到检验项目的RowId  Added by zhouyong
/*
function GetId(){
	if (SelectedRow==0) return "";
	var obj=document.getElementById("TIdz"+SelectedRow);
	if(obj){
		return obj.value;
	}
	return "";
}
*/
function GetId(){
	
	if (SelectedRow==0) return "";
	var rows,IDStr="";
	var objtbl=document.getElementById("tDHCPEIAdmItemStatusDetail");
	if (objtbl){
		rows=objtbl.rows.length;
	}
	for (var i=1;i<rows;i++)
	{ 
		var chkobj=document.getElementById("TSelectz"+i); 
		if ((chkobj)&&(chkobj.checked))
		{
			var obj=document.getElementById("TIdz"+i);
			if(obj){var ID=obj.value;} 
			if(IDStr==""){var IDStr=ID;}
			else{var IDStr=IDStr+"^"+ID;}
		}
		
	}
 
	return IDStr;	
	
}


//得到单个检查标签
 //2008-07-01
function GetOneRisInfo()
{  
	if (SelectedRow==0) return ""
	var obj,IAdmId="",ItmMastDR="",ItmMastDesc="",Status="";OEItemID=""
	
	obj=document.getElementById("TItemIdz"+SelectedRow)
	if (obj) ItmMastDR=obj.value
	
	obj=document.getElementById("TIdz"+SelectedRow)
	if (obj) OEItemID=obj.value
	
	obj=document.getElementById("TItemNamez"+SelectedRow)
	if (obj) ItmMastDesc=obj.innerText;
	
	obj=document.getElementById("TStatusz"+SelectedRow)
	if (obj) Status=obj.innerText;
	
	obj=document.getElementById("txtIAdmId");
	if (obj) IAdmId=obj.value;
	return IAdmId+"^"+ItmMastDR+"^"+ItmMastDesc+"^"+Status+"^"+OEItemID
}
function InitListInfo()
{
	var status,i,objChk;
	
	var objtbl=document.getElementById('tDHCPEIAdmItemStatusDetail');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{
		
		var statusobj=document.getElementById('TDrugStatusz'+i);
		if(statusobj) status=statusobj.innerText;
		
		if (status=="已发药")
		{
			
			objChk=document.getElementById('TCheckedz'+i);
			if (objChk)
			{
			objChk.disabled=false;
			objChk.onclick=Chk_Click;
			}
		}		
	}	
}


function Chk_Click()
{
	var eSrc = window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var BillStatus;
	
	var BillStatusObj=document.getElementById('TBillStatusz'+selectrow)
	if(BillStatusObj){
		BillStatus=BillStatusObj.innerText;
	}
	//已付费药品请去退费申请界面
	if(BillStatus !="挂帐")
	{
		alert(t['HadPayed'])
		return false;
		
	}
	var addflag=eSrc.checked;
	
	
	var feeid="1"+"^"+GetCtlValueById('TPreItemIDz'+selectrow);
	//药品权限控制 如果已退药不允许取消申请
	var enControl=document.getElementById("DrugPermControl");
	if(enControl){
		var encmeth=enControl.value;
	}
	var flag=cspRunServerMethod(encmeth,feeid,"0")
	
	if (flag=="1") 
	{alert(t['HadDropDrug']);
	 return false;}
	var SelectId;
	if (addflag)
	{			
		SelectId=feeid;
		
	}
	else
	{	
		SelectId=""
	}
	//alert(SelectId)
	
	
	//将selectId保存到临时的global中
	
	var encache=document.getElementById("SetApplyDrug");
	if(encache){
		encache=encache.value;
	}
	var oeori=GetCtlValueById('TIdz'+selectrow);
	var flag=cspRunServerMethod(encache,SelectId,oeori);
	if(flag==1){
		if(addflag)
		alert("申请成功")
		else(alert("取消申请成功"))
	}
	
}
 //zl 2008-03-25
function Save_Click()
{ 
	var Strings=GetNotPrintInfo();
	if (Strings=="") return;
	var encmethobj=document.getElementById("NoPrintClass");
	if (encmethobj) var encmeth=encmethobj.value;
	var ReturnStr=cspRunServerMethod(encmeth,Strings);
	if (ReturnStr==0)
	{   
		window.location.reload();
	}
	else
	{
		alert(ReturnStr); 
	}
}
function GetNotPrintInfo()
{   var  isPrint=""
	var Strings=""
	var CurRow=0;
	var tbl=document.getElementById('tDHCPEIAdmItemStatusDetail');	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sPrint=document.getElementById('TNotPrintz'+j);
		if (sPrint)
		{
			if (true==sPrint.checked){var isPrint="Y";}
			else{var isPrint="N"; }	
			var sTD=isPrint.parentElement;
			var strCell=isPrint
		}  
		if (CurRow!=j&&CurRow!=0) continue;
		if (strCell!=""){
			var OEID="";
			var obj=document.getElementById('TIdz'+j);
				
			if (obj) OEID=obj.value;
			if (OEID!=""){
				if (Strings==""){
					Strings=OEID+";"+strCell;
				}
				else{
					Strings=Strings+"^"+OEID+";"+strCell;
				}
			}
		}
	}
	
	return Strings;
}
function BPrintBChao_Click()
{
	var obj,IAdmId="",OEID="";
	obj=document.getElementById("txtIAdmId");
	if (obj) IAdmId=obj.value;
	OEID=GetId();
	if (OEID==""){
		alert("请选择打印项目")
		return false;
	}
	//alert(IAdmId+"^"+OEID)
	PrintBChaoReport(IAdmId,OEID);
}
document.body.onload = Ini;