/// DHCPEStationSDiagnosis.js
var obj;
var DSelectedRow=0
var CurEDDesc="";
function InitMe() {
	var obj=document.body;
	if (obj) obj.onmouseup=Body_click;
	obj=document.getElementById("ShowEDInfo");
	if (obj) obj.onchange=ShowEDInfo_change;
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
		var Audit=SummaryForm.all['DBAudit'];
		var RAudit=SummaryForm.all['DBRAudit'];
		var SumResult=SummaryForm.all['DBSumResult'];
		var Update=SummaryForm.all['DBUpdate'];
		var AddResult=SummaryForm.all['DBAddResult'];
		var InsertED=SummaryForm.all['BInsertED'];
		if (InsertED) {InsertED.onclick=InsertED_click;}
     
		var StationED=SummaryForm.all['BStationED'];
		if (StationED) {StationED.onclick=StationED_click;}

		if (Audit) {Audit.onclick=Audit_click;}
		if (RAudit) {RAudit.onclick=StationSCancelSub;}
		if (SumResult) {SumResult.onclick=SumResult_click;SumResult.disabled=true;}
		
		
		//if (Update) {Update.onclick=Update_click;}
		if (Update) {Update.onclick=DBUpdate_click;}
		
		var obj=SummaryForm.all['AddDiagnosis'];
		if (obj) obj.onkeydown=AddDiagnosis_KeyDown;
		if (AddResult) {AddResult.onclick=AddResult_click;}
		var SSIDObj=SummaryForm.all['DSSID'];
		if (SSIDObj) var SSID=SSIDObj.value;
		/*
		if (SSID=="")
		{
			Audit.disabled=true;
			SumResult.disabled=true;
			Update.disabled=true;
			AddResult.disabled=true;
			InsertED.disabled=true;
		}*/
		PermissonSetting();
		websys_setfocus("AddDiagnosis");
	}
}
/*
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}*/
function Body_click()
{
	oEvent=window.event;
	if (oEvent.button==2) {
		
		document.body.oncontextmenu=function(event){  //屏蔽右键菜单
			return false;
		}
		//关闭打开的DIV
		var div=document.getElementById("editBehaviorDiv");  
    		if(div!=null) document.body.removeChild(div);
    		return false;
	}

	 
}
function ShowEDInfo_change()
{
	var obj,ShowInfo=0,encmeth="";
	obj=document.getElementById("ShowEDInfo");
	if (obj&&obj.checked) ShowInfo=1;
	obj=document.getElementById("ShowEDInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ShowInfo)
	window.location.reload();
}
function AddResult_click()
{
	var obj,DefaultEDID="",DisplayDesc="",Result="",encmeth="";
	obj=document.getElementById("DefaultEDID");
	if (obj) DefaultEDID=obj.value;
	if (DefaultEDID==""){
		alert(t["DefaultEDID"]);
		return false;
	}
	obj=document.getElementById("DisplayDesc");
	if (obj) DisplayDesc=obj.value;
	obj=document.getElementById("Result");
	if (obj) Result=obj.value;
	if (DisplayDesc==""){
		DisplayDesc="默认"
	}
	if (Result==""){
		Result="默认"
	}
	obj=document.getElementById("UpdateDefaultEDInfo");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var ret=cspRunServerMethod(encmeth,DefaultEDID,DisplayDesc,Result);
	if (ret=="0"){
		AddDiagnosis(DefaultEDID);
	}else{
		alert(t["AddErr"]+ret)
	}
}
function InsertED_click()
{
	var wwidth=450;
	var wheight=550; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.New&InsertType=User";
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)
	//window.open(lnk,'','',"dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;")
	
}
function StationED_click()
{
	var wwidth=950;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var ChartIDobj=document.getElementById("DChartID");;
	if (ChartIDobj) {ChartID=ChartIDobj.value;}
	//alert("ChartID:"+ChartID);
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.List&Code=&DiagnoseConclusion=&Alias=&vStationID=&ChartID="+ChartID;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)
	//window.open(lnk,'','',"dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;")
	
}
function AddDiagnosis_KeyDown()
{
	var key=websys_getKey(e);
	if (13==key) {
		var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
		var obj=SummaryForm.all['GDComponentID'];
		if (obj) var ComponentID=obj.value;
		var obj=SummaryForm.all['ld'+ComponentID+'iAddDiagnosis'];
		if (obj) obj.click();return false;
		}
}
function AddDiagnosis(value){
	/*
	var PayStatus=GetPayStatus();
	
	if (PayStatus==""){
		var obj=document.getElementById("AddDiagnosis");
	    if (obj) obj.value=""
		alert(t['NoPay'])
		
		return;
	}
	*/
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
	var obj=SummaryForm.document.getElementById("AddDiagnosis");
	if (obj) obj.value=""
	var ID=value.split("^")[0];
	var obj=SummaryForm.document.getElementById("DChartID");
	if (obj) var ChartID=obj.value;
	obj=SummaryForm.document.getElementById("DEpisodeID");
	if (obj) var EpisodeID=obj.value;
	obj=SummaryForm.document.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	var obj=SummaryForm.document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	//if (SSID=="") {alert(t["NoSS"]);return false;}
	var flag=cspRunServerMethod(encmeth,SSID,ID,"0",ChartID,EpisodeID);
	
	if (flag==0)
	{ 
	 var obj=SummaryForm.document.getElementById("GetEDInfoBox");
	  if (obj) var encmeth=obj.value;
	 
	  var Info=cspRunServerMethod(encmeth,ID,ChartID,EpisodeID);

	
	  var objtbl=SummaryForm.document.getElementById('tDHCPEStationSDiagnosis');
     	  if (objtbl.rows.length==2) { 
			var DTRowId=DHCC_GetColumnData("DTRowId",1)
			if (DTRowId!=''){DHCC_InsertRowToTable(objtbl);}
		}else{
			DHCC_InsertRowToTable(objtbl);
		}
        
		var Row=objtbl.rows.length-1;
	  	var Row=GetRow(Row);
	   
	    var TItemName=Info.split("^")[3];
	    var DTResult=Info.split("^")[6];
	    
	    var DTRowId=Info.split("^")[0];
	      
	    var DTRLTDR=Info.split("^")[1];
	    var User=Info.split("^")[2];
	    var Date=Info.split("^")[4];
	    var DRemark=Info.split("^")[5];
	    var EDCDesc=Info.split("^")[7];
	    var EDCDR=Info.split("^")[8];

	    var Str="DTResult"+"^"+DTResult+"@TItemName^"+TItemName+"@DRemark^"+DRemark+"@DTRLTDR^"+DTRLTDR+"@DTRowId^"+DTRowId+"@TDisplayDesc^"+TItemName+"@EDCDesc^"+EDCDR
	    DHCC_SetColumnData(objtbl,Str);
	    /*DHCC_SetColumnData("TItemName",Row,TItemName);
		DHCC_SetColumnData("DTRowId",Row,DTRowId);
		DHCC_SetColumnData("DRemark",Row,DRemark);
		DHCC_SetColumnData("DTRLTDR",Row,DTRLTDR);
		DHCC_SetColumnData("User",Row,User);
		DHCC_SetColumnData("Date",Row,Date);
		DHCC_SetColumnData("EDCDesc",Row,EDCDesc);*/
		
	//if (flag==0){ document.forms['fDHCPEStationSDiagnosis'].reset(); return false;}
	
}
//alert(t[flag]);
return false;}
}


function DHCC_AddItemToListByStr(ListName,str) {
	var obj=document.getElementById(ListName);
	if (obj){
		var ary=str.split("$");
		if (ary.length>0) {
			for (var i=0;i<ary.length;i++) {
				var arytxt=ary[i].split(String.fromCharCode(1));
				obj.options[obj.length] = new Option(arytxt[0],arytxt[1]); 
				if (arytxt[1]==1){obj.selected="true";}
			}
		}
		
	}
}
function GetRow(Rowindex){
	var objtbl=document.getElementById('tDHCPEStationSDiagnosis');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("*");
	for (var j=0;j<rowitems.length;j++) {

		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}
function DHCC_InsertRowToTable(objtbl){
	
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only

	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
		
	for (var j=0;j<rowitems.length;j++) {
		
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			//rowitems[j].value="";
			if ((rowitems[j].tagName=='LABEL')||(rowitems[j].tagName=='TEXTAREA')){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	
		
	objtbody=tk_getTBody(objlastrow);
	objnewrow=objtbody.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
}

function DHCC_GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){
		if ((CellObj.tagName=='LABEL')||(CellObj.tagName=='TEXTAREA')){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value;
			}
		}
	}
	return "";
}
function DHCC_SetColumnData(objtbl,Str){
  
  var row=objtbl.rows.length;
  var objnewrow=objtbl.rows[row-1]
  var rowitems=objnewrow.all; //IE only
  
  if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
		
	for (var j=0;j<rowitems.length;j++) {
		
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
		     var Str1=Str.split("@")
		     for (var i=0;i<Str1.length;i++){
			     var Str2=Str1[i].split("^")
			     if (Str2[0]==arrId[0]) {
				     
				 if ((rowitems[j].tagName=='LABEL')||(rowitems[j].tagName=='TEXTAREA')){
			            rowitems[j].innerText=Str2[1] 
			     }else{
				         rowitems[j].value=Str2[1] 
			     }		
				     
				     
				     }
			     
			     }
		     
		     
				}
	}
  
  
	
	   
}

function DHCC_ClearTableRow(objrow){
		var rowitems=objrow.all; //IE only
	if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			if ((rowitems[j].tagName=='LABEL')||(rowitems[j].tagName=='TEXTAREA')){
			  rowitems[j].innerText=""
			}else{
				rowitems[j].value="";
			}		
		}
	}	
}


function RemoveOPAdmRegDblRow(selectrow){
	var objtbl=document.getElementById('tDHCPEStationSDiagnosis');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	if ((lastrowindex==1)) {
		DHCC_ClearTableRowByIndex(objtbl,1);
		return;
	}
	if (selectrow!=0) {
		objtbl.deleteRow(selectrow);
		DHCC_ResetRowItems(objtbl);
		//DeleteRow(objtbl.rows[selectrow],false)
	}
}
function DHCC_ClearTableRowByIndex(objtbl,Rowindex){
	var objrow=objtbl.rows[Rowindex];
	DHCC_ClearTableRow(objrow);
}

function DHCC_ClearTableRow(objrow){
	var rowitems=objrow.all; //IE only
	if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			if ((rowitems[j].tagName=='LABEL')||(rowitems[j].tagName=='TEXTAREA')){
			  rowitems[j].innerText=""
			}else{
				rowitems[j].value="";
			}		
		}
	}	
}
function DHCC_ResetRowItems(objtbl) {
	//alert(objtbl.rows.length);
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var k=0;k<rowitems.length;k++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[k].id) {
				var arrId=rowitems[k].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i;
				rowitems[k].id=arrId.join("z");
				rowitems[k].name=arrId.join("z");
			}
		}
	}
}

 function ComputeExp(tabSubfix, strExpression){
	try{
		if (parent.frames("result")){
			var TblObj=parent.frames("result").document.getElementById("tDHCPEResultItemEdit");
		}
	}catch(e){
		var TblObj=GetCurTab(tabSubfix);
	}
	
	for(var j=1;j<TblObj.rows.length;j++){ 
		var RowObj=TblObj.rows[j]; 
		var CellItemDesc;
		var CellSel;
		var CellItemCode;
		for (k=0; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id=='ItemDescz'+j) {CellItemDesc=ItemObj};
			if (ItemObj.id=='ItemCodez'+j) {CellItemCode=ItemObj};
			if (ItemObj.id=='ItemSelz'+j) {CellSel=ItemObj};
			if (ItemObj.id=='ResultTypez'+j) {CellResultType=ItemObj};			
		}  
		while(strExpression.indexOf("["+CellItemCode.value+"]")>=0){
			if (CellSel.value=="") return "";
 
			strExpression=MyReplace(strExpression,"["+CellItemCode.value+"]", Val(CellSel.value));
		}
	}
	var ret=0;
	if (strExpression!="") {
		strExpression="ret="+strExpression;
		eval(strExpression);
		if (!eval(strExpression)) {ret=0};
	}
	//ret=ret*10000
	ret=(parseInt((ret*100)+0.5))/100
	return ret;

}

function SumResult_click(){
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
	if (!confirm(t['Del'])) return false;
	
	var Dobj=SummaryForm.document;
	var obj=Dobj.getElementById("DChartID");       //add by zl
	if (obj) var ChartID=obj.value;               //add by zl
	var obj=Dobj.getElementById("DEpisodeID");    //add by zl
	if (obj) var EpisodeID=obj.value;              //add by zl
	var obj=Dobj.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	if (DSelectedRow==0) return false;
	var obj=Dobj.getElementById("DTRowIdz"+DSelectedRow);
	var ID="";
	if (obj) ID=obj.value;
	var obj=SummaryForm.document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"1",ChartID,EpisodeID);
    if (flag==0){
	RemoveOPAdmRegDblRow(DSelectedRow)}
	else{alert(t[flag])}
	return false;}
	
}


//function Update_click(){
function DBUpdate_click(){	
	Update(1);
}
function Update(AlertFlag)
{
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
		var objtbl=SummaryForm.document.getElementById('tDHCPEStationSDiagnosis');
	
		if (objtbl) { var rows=objtbl.rows.length; }
		
		var lastrowindex=rows - 1;
		var i,obj,ID,Remark,Strings;
		var ID,Remark,Strings="",Advice,DisplayDesc;
		for (i=1;i<rows;i++)
		{
			obj=SummaryForm.document.getElementById("DTRowIdz"+i);
			if (obj) ID=obj.value;
			obj=SummaryForm.document.getElementById("DRemarkz"+i);
			if (obj) Remark=obj.value;
			obj=SummaryForm.document.getElementById("DTResultz"+i);
			if (obj) Advice=obj.value;
		    obj=SummaryForm.document.getElementById("TDisplayDescz"+i);  //Add 20080728
	
            if (obj) DisplayDesc=obj.innerText;     
                               //Add 20080728
            obj=SummaryForm.document.getElementById("EDCDescz"+i);  
            if (obj) var EDCDesc=obj.value;  
                                    
			if (Strings=="")
			{
				Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+""+"&&"+DisplayDesc+"&&"+EDCDesc
			}
			else
			{
				Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+""+"&&"+DisplayDesc+"&&"+EDCDesc
			}
		}
	
		if (Strings=="") return false;
		var obj=SummaryForm.document.getElementById("DUpdateBox");
		if (obj) var encmeth=obj.value;
		var flag=cspRunServerMethod(encmeth,Strings)
		if (AlertFlag=="1") {alert(t[flag]);}
		return false;
		
		
	}
}
/*
function Audit_click() {
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
	obj=SummaryForm.document.getElementById("DChartID");
	if (obj) var ChartID=obj.value;
	obj=SummaryForm.document.getElementById("DEpisodeID");
	if (obj) var PAADM=obj.value;
	obj=SummaryForm.document.getElementById("DAuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,ChartID,"Submit");
	alert(t[flag]);
	return false;
	}
}
*/
function StationSCancelSub()
{
	StatusChange("Cancel");
}
function Audit_click() {
	StatusChange("Submit");
}
/*
function StatusChange(Type)
{   var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	if (SummaryForm) {
	obj=SummaryForm.document.getElementById("DChartID");
	//if (obj) var ChartID=obj.value;
	obj=SummaryForm.document.getElementById("DEpisodeID");
	if (obj) var PAADM=obj.value;
	obj=SummaryForm.document.getElementById("DAuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,ChartID,Type);
	if (flag=="0")
	{
		if (Type=="Submit")
		{
			
			parent.parent.location.href="epr.default.csp";
		}
		else if (Type=="Cancel")
		{
			window.location.reload();
		}
		return false;
	}
	alert(t[flag]);
	return false;
	}
}
*/
function SaveResult()
{
	if (parent.frames("result")){
		var UObj=parent.frames("result").document.getElementsByTagName('A');
		var ButtonLength=UObj.length;
		for (var i=0;i<ButtonLength;i++)
		{
			var ButtonID=UObj[i].id;
			if (ButtonID.split("Update").length>1) UObj[i].click();
			if (ButtonID=="BSave") UObj[i].click();
		}
		var UObj=parent.frames("result").document.getElementsByTagName('button');
		var ButtonLength=UObj.length;
		for (var i=0;i<ButtonLength;i++)
		{
			var ButtonID=UObj[i].name;
			
			if (ButtonID.split("Update").length>1) UObj[i].click();
			if (ButtonID=="BSave") UObj[i].click();
		}
	}
}
function StatusChange(Type)
{  	
  	/*
  	var PayStatus=GetPayStatus();
	if (PayStatus==""){
		var obj=document.getElementById("AddDiagnosis");
	    if (obj) obj.value=""
		alert(t['NoPay'])
		
	return;
	}
	*/
   	 var UpdateCode="1"
   	 var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
   	 if (SummaryForm){
    	 obj=SummaryForm.document.getElementById("DEpisodeID");
	 	if (obj) var PAADM=obj.value;
	 }
	 var UpdateCodeFlag=1   //用于一个科室多条医嘱判断能否提交
		var UserID="";
		if (Type=="Submit"){
			var obj=document.getElementById("AuditUser");
			if (obj) UserID=obj.value;
			Update(0);
			SaveResult();
		}
	//if (UpdateCodeFlag=="1") 
	//{
		if (SummaryForm) {
		obj=SummaryForm.document.getElementById("DChartID");
		if (obj) ChartID=obj.value;
		obj=SummaryForm.document.getElementById("DAuditBox");
		if (obj) var encmeth=obj.value;
		var flag=cspRunServerMethod(encmeth,PAADM,ChartID,Type,UserID);
		if (flag=="0")
		{
			try{
			if (parent.frames("result")){
				if (Type=="Submit")
				{
					parent.ShowNextPage();
				}else{
					window.location.reload();
					parent.frames("result").location.reload();
				}
				return false;
			}
			}catch(e){
				
			}
			if (Type=="Submit")
			{
				parent.parent.location.href="epr.default.csp";
			}
			else if (Type=="Cancel")
			{
				window.location.reload();
								
			}
			return false;
		}
	alert(t[flag]);
	return false;
	}
	//}
}



function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var SummaryForm=document.forms['fDHCPEStationSDiagnosis'];
	var Dobj=SummaryForm.document;
	var objtbl=Dobj.getElementById('tDHCPEStationSDiagnosis');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var obj;
	var rowObj=getRow(eSrc);
	
	var Row=rowObj.rowIndex;
	obj=Dobj.getElementById("DBSumResult");
	if (Row==DSelectedRow)
	{
		DSelectedRow=0
		obj.disabled=true;
	}
	else
	{
		DSelectedRow=Row;
		obj.disabled=false;
	}
}

function GetPayStatus()
{ var TblArr=document.getElementsByName('tDHCPEResultItemEdit');
     for (var h=0; h<TblArr.length; h++)	
     {
	    if (TblArr[h].Name=='tDHCPEResultItemEdit')	
	    {
	    TblArr[h].Name=TblArr[h].Name+ItemArr[h].value;
		}
	
		}
	 var OEORIRowIdStr=""
     for (var z=0; z<TblArr.length; z++)	
     {  
        var Table=TblArr[z].Name
		var Tblsuffix=Table.split('tDHCPEResultItemEdit')
	    var TblObj=TblArr[z];
		
		for(var v=1;v<TblObj.rows.length;v++){
		var RowObj=TblObj.rows[v];
		
		var ItemDesc="";
		var ItemSel="";
		var ItemID="";
		var rowStr="";
		var strComputeExp="";
		var CellSel;
		for (l=0; l<RowObj.all.length; l++)	{
			var ItemObj=RowObj.all[l];
			if (ItemObj.id=='OEORIRowIdz'+v) {OEORIRowId=ItemObj.value};
			}
	
	      }
	      if (OEORIRowIdStr=="")  OEORIRowIdStr= OEORIRowId
	      else  OEORIRowIdStr=OEORIRowIdStr+"^"+OEORIRowId
	     }
	    return OEORIRowIdStr
}
function EDClick()
{
	var eSrc=window.event.srcElement;
	var eSrcID=eSrc.id;
	var InfoArr=eSrcID.split("^");
	var StationID=InfoArr[0];
	var Desc=InfoArr[1];
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	CurEDDesc=Desc;
	var Info=cspRunServerMethod(encmeth,StationID,Desc);
	if (Info=="") return false;
	CreateDiv(eSrc,Info)
}
function CreateDiv(obj,Info){  
    var div=document.getElementById("editBehaviorDiv");  
    if(div!=null)  
        document.body.removeChild(div);  
    div = document.createElement("div");   
    div.id="editBehaviorDiv";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+30;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=200><TR align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(0)'>关闭</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' value='"+OneArr[0]+"' ondblclick=EDDblClick()>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function RemoveAllDiv(Type)
{
	var div=document.getElementById("editBehaviorDiv");  
    if(div!=null)  
        document.body.removeChild(div);
}
function getoffset(e)   
{   
	var t=e.offsetTop;   
	var l=e.offsetLeft;   
	while(e=e.offsetParent)   
	{   
		t+=e.offsetTop;   
		l+=e.offsetLeft;   
	}   
	var rec = new Array(1);   
	rec[0] = t;   
	rec[1] = l;   
	return rec   
}
function EDDescDBLClick(e)
{
	if (parent.frames("result"))
	{
		var EDDesc=e.innerText;
		parent.frames("result").EDDescDBLClick(EDDesc);
	}
}
function EDDblClick()
{
	var eSrc=window.event.srcElement;
	var EDID=eSrc.value;
	if (parent.frames("result"))
	{
		parent.frames("result").EDDescDBLClick(CurEDDesc);
	}
	AddDiagnosis(EDID);
	var div=document.getElementById("editBehaviorDiv");  
    	if(div!=null)  
        	document.body.removeChild(div);  
}
function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("DEpisodeID", 0)
	ChartId=GetCtlValueById("DChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 0, ChartId)
	if (MyPermission=="R"){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
	    DisabledCtls("select",true);
	    if (parent.frames("query")){
	    	var obj=parent.frames("query").document.getElementById("RegNo");
			if (obj){
				
				obj.select();
				obj.focus();
			}
		}
		return "R";
	}
	return "W";
	
}
