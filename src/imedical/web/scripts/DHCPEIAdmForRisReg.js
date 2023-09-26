/// DHCPEIAdmForRisReg.js
var TFORM="DHCPEIAdmForRisReg";
var SelectedRow=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("btnQuery");
	if (obj) {obj.onclick=BFind_Click;}
	
	obj=document.getElementById("RegFlag_Y");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("RegFlag_U");
	if (obj) { obj.onclick=DateType_click; }
	
		
	obj=document.getElementById("SelectALL");
	if (obj) { obj.onclick=SelectALL_Click; }
	
	obj=document.getElementById("RisRegister");
	if (obj) { obj.onclick=RisRegister_Click; }
	
		obj=document.getElementById("txtGroupName");
	if (obj) { obj.onchange=GroupName_Change; }
	
	obj=document.getElementById("txtItemName");
	if (obj) { obj.onchange=ItemName_Change; }
	ShowCurRecord(1)
}

function SelectALL_Click() 
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);

		if (obj) { obj.checked=Src.checked; }
	}
	
}
function DateType_click() {
	
	var src=window.event.srcElement;
	obj=document.getElementById('RegFlag_Y');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById('RegFlag_U');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	
	var srcId=src.id.split('_');
	obj=document.getElementById('RegFlag');
	if (obj) { obj.value=srcId[1]; }

}


function BFind_Click()
{  
   var itxtAdmNo="",itxtPatName="",itxtAdmDate="",iEndDate="",itxtGroupId="",itxtItemId="",iRegFlag=""
   var obj
    obj=document.getElementById("txtAdmNo");
    if (obj) { itxtAdmNo=obj.value};
	obj=document.getElementById("txtPatName");
    if (obj) { itxtPatName=obj.value};
      obj=document.getElementById("txtAdmDate");
    if (obj) { itxtAdmDate=obj.value};
      obj=document.getElementById("EndDate");
    if (obj) { iEndDate=obj.value};
      obj=document.getElementById("txtGroupId");
    if (obj) { itxtGroupId=obj.value};
	obj=document.getElementById("txtItemId");
    if (obj) { itxtItemId=obj.value};
    
    obj=document.getElementById('RegFlag_Y');
	if (obj && obj.checked==true) {iRegFlag="Y"; }
	obj=document.getElementById('RegFlag_U');
	if (obj && obj.checked==true) { iRegFlag="U"; }
     obj=document.getElementById("RegFlag");
     if (obj) { obj.value=iRegFlag};
     var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmForRisReg "
			+"&txtAdmNo="+itxtAdmNo
			+"&txtPatName="+itxtPatName
	        +"&txtAdmDate="+itxtAdmDate
            +"&EndDate="+iEndDate
			+"&txtGroupId="+itxtGroupId
	        +"&txtItemId="+itxtItemId 
	        +"&RegFlag="+iRegFlag 
	 
    location.href=lnk; 

    //var targetFrame="DHCPEIAdmItemForRisReg";
	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmItemForRisReg";
    //parent.frames[targetFrame].location.href=lnk;
   // parent.frames["DHCPEIAdmItemForRisReg"].location.reload();

}
function SelectRowHandler()	
{		
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEIAdmForRisReg');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;

	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    ///此处之前较为固定?除了修改document.getElementById('tINSUPatTypeC
    
    if (!selectrow) return;
	ChangeCheckStatus("TSeclect");
	ShowCurRecord(selectrow)
}	
function ShowCurRecord(CurRecord) {
	var SelRowObj
	var obj	
	var selectrow=CurRecord;
	
    var PAADM="",PEIAdmId="",RegFlag="",lnk=""
	
	SelCellObj=document.getElementById('TAdmIdz'+selectrow);	
	if (SelCellObj) {
		PAADM=SelCellObj.value;	
			
	}
	
	SelCellObj=document.getElementById('TPEIAdmIdz'+selectrow);
	if (SelCellObj) {
		PEIAdmId=SelCellObj.value;
	}
	SelCellObj=document.getElementById('TRegFlagz'+selectrow);
	if (SelCellObj) {
		RegFlag=SelCellObj.value;	
	}
	

    var targetFrame="DHCPEIAdmItemForRisReg";
  
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmItemForRisReg"+"&IADM="+PEIAdmId+"&RegFlag="+RegFlag;
  
    parent.frames[targetFrame].location.href=lnk;
	
}
function ChangeCheckStatus(ItemName)
{
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById(ItemName+"z"+selectrow);
	if (obj) obj.checked=!obj.checked;
}
function RisRegister_Click()
{
 
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val=""
	var PEIAdmId="",RegFlag=""
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) {
			
		obj=document.getElementById('TPEIAdmId'+'z'+iLLoop);
		if (obj){ PEIAdmId=obj.value; }
		
		obj=document.getElementById('TRegFlag'+'z'+iLLoop);
		if (obj){ RegFlag=obj.value; }
		
	    RisReg(PEIAdmId,RegFlag)
	    
	    var vals=vals+PEIAdmId+";"
		
	}
	}
	if (""==vals) { alert("未选择受检人,操作中止!");
	 return;}
	
}
function RisReg(IADM,Flag)
{
   
	var obj;
	if (Flag=="Y"){alert("体检者已登记!")
	 return;}
	var ARCIMIDStr=parent.frames["DHCPEIAdmItemForRisReg"].GetARCIMID();

	  var Ins=document.getElementById('RegestBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,IADM,ARCIMIDStr);
	if (value!=""){
		alert(value);	
		return;}
     else{
	     alert("登记成功!")
	  
	      
        location.reload();
        var targetFrame="DHCPEIAdmItemForRisReg"
        var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmItemForRisReg";
       parent.frames[targetFrame].location.href=lnk;}

}
function AfterGroupSelected(value){
	
	if (""==value){return false}
	var aiList=value.split("^");
	var obj=document.getElementById("txtGroupId");
	if (obj) obj.value=aiList[0];
	var obj=document.getElementById("txtGroupName");
	if (obj) obj.value=aiList[1];
}
function AfterItemSelected(value){
	if (""==value){return false}
	
	var aiList=value.split("^");
		var obj=document.getElementById("txtItemId");
	if (obj) obj.value=aiList[1];
	var obj=document.getElementById("txtItemName");
	if (obj) obj.value=aiList[0];

	
}
function GroupName_Change()
{
	var obj=document.getElementById("txtGroupId");
	if (obj) { obj.value=""; }
}
function ItemName_Change()
{
	var obj=document.getElementById("txtItemId");
	if (obj) { obj.value=""; }
}
document.body.onload = BodyLoadHandler;

