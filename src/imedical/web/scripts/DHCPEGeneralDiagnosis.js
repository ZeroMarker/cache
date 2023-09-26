/// DHCPEGeneralDiagnosis.js
var obj;
var DSelectedRow=0
function InitMe() {
	//var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	//if (SummaryForm) {
		var Audit=document.getElementById('DBAudit');
		var Audit2=document.getElementById('DBAudit2');
		var SumResult=document.getElementById('DBSumResult');
		var Update=document.getElementById('DBUpdate');
		var Sort=document.getElementById('DBSort');
		var AddResult=document.getElementById('DBAddResult');
		if (Audit) {Audit.onclick=Audit_click;}
		if (Audit2) {Audit2.onclick=Audit_click;}
		if (AddResult) {AddResult.onclick=AddResult_click;}
		var InsertED=document.getElementById('BInsertED');
		if (InsertED) {InsertED.onclick=InsertED_click;}
		var PrintReport=document.getElementById('BPrintReport');
		if (PrintReport) {PrintReport.onclick=PrintReport_click;}
		//add 2010
		var DiagnosisLog=document.getElementById('DiagnosisLog');
		if (DiagnosisLog) {DiagnosisLog.onclick=DiagnosisLog_click;}

		
		var GeneralED=document.getElementById('BGeneralED');
		if (GeneralED) {GeneralED.onclick=GeneralED_click;}
		if (SumResult) {SumResult.onclick=SumResult_click;}
		if (Update) {Update.onclick=Update_click;}
		if (Sort) {Sort.onclick=Sort_click;}
		var obj=document.getElementById('AddDiagnosis');
		if (obj) obj.onkeydown=AddDiagnosis_KeyDown;
		var SSIDObj=document.getElementById('DSSID');
		if (SSIDObj) var SSID=SSIDObj.value;
		var BUpdateDiagnosis=document.getElementById('BUpdateDiagnosis');
		if (BUpdateDiagnosis) {BUpdateDiagnosis.onclick=BUpdateDiagnosis_click;}
	
		if (SSID=="")
		{
			Audit.disabled=true;
			SumResult.disabled=true;
			Update.disabled=true;
			AddResult.disabled=true;
			InsertED.disabled=true;
		}
		websys_setfocus("AddDiagnosis");
	//}
	  var obj=document.getElementById('GetMainGroup')
	  if(obj) {var MainGroup=obj.value}                      //复检安全组
	  var CurGROUPID=session['LOGON.GROUPID']                      //当前安全组
 		var encmeth="",SSRID="";
 		var obj=document.getElementById("GetSSAdvice");
 		if (obj) encmeth=obj.value;
      var MainDoctor="";
      var obj=document.getElementById("MainDoctor");
      if (obj) MainDoctor=obj.value;
      var tbl=document.getElementById('tDHCPEGeneralDiagnosis');	//取表格元素?名称
      var row=tbl.rows.length;
      for (var j=1;j<row;j++) 
      {
	      var obj=document.getElementById("DTRowIdz"+j);
	      if (obj) SSRID=obj.value;
	      if (encmeth!=""){
		      var Advice=cspRunServerMethod(encmeth,SSRID);
		      obj=document.getElementById("DTResultz"+j);
		      if (obj) obj.value=Advice;
	      }
	      var RowObj=tbl.rows[j];
          for (k=0; k<RowObj.all.length; k++)	
          {var ItemObj=RowObj.all[k];
          	ItemObj.className="Green";   //add by lxl 20121203
          	if(ItemObj.id=="Diagnosisz"+j){
          		ItemObj.onclick=ResultSelect_Click;
          	}
            //当不是复检医生，则隐藏复检一列的勾
            if(ItemObj.id=="TReCheckz"+j)
            {
            	//if(MainGroup!=CurGROUPID)
               	if (MainDoctor!="Y")
               	{    
	            	//ItemObj.style.visibility = "hidden";
	            	ItemObj.disabled = "true";
		} 
              
            }
           }
           
      }
    var permision=PermissonSetting();
	var curTr = null; 
    var tb1 = document.getElementById('tDHCPEGeneralDiagnosis'); 
    var trs = tb1.getElementsByTagName('tr'); 
    tb1.onselectstart = function(){ 
        if(curTr){ 
            document.selection.empty(); return true; 
        } 
    }; 
    
    for(var i=1; i<trs.length; i++) { 
        var tds = trs[i].getElementsByTagName('td'); 
        var obj=tds[2]; //第二列
        obj.style.cursor = 'move'; 
        obj.onmousedown = function(){ 
            curTr = this.parentNode; 
            curTr.style.backgroundColor = '#eff'; 
        }; 
        obj.onmouseover = function() { 
            if(curTr && curTr != this.parentNode) { 
                this.parentNode.swapNode(curTr); 
            } 
        }
        var obj=tds[3];  //第三列
        obj.style.cursor = 'move'; 
        obj.onmousedown = function(){ 
            curTr = this.parentNode; 
            curTr.style.backgroundColor = '#eff'; 
        }; 
        obj.onmouseover = function() { 
            if(curTr && curTr != this.parentNode) { 
                this.parentNode.swapNode(curTr); 
            } 
        }  
    } 
      
    document.body.onmouseup = function(){ 
        if(curTr){ 
            curTr.style.backgroundColor = ''; 
            curTr = null; 
        } 
    }; 
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
	if (DisplayDesc==""||Result==""){
		alert(t["InfoNUll"]);
		return false;
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


function  ResultSelect_Click() { 
  	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEGeneralDiagnosis');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('DTRowIdz'+selectrow);	
	if (obj) {var GSID=obj.value;}
	var obj=document.getElementById("GetDiagnosis");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,GSID);
	alert(flag)
	
	

}
function AddDiagnosis_KeyDown()
{
	var key=websys_getKey(e);
	if (13==key) {
		var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
		var obj=SummaryForm.all['GDComponentID'];
		if (obj) var ComponentID=obj.value;
		var obj=SummaryForm.all['ld'+ComponentID+'iAddDiagnosis'];
		if (obj) obj.click();return false;
		}
		
}
function InsertED_click()
{
	var wwidth=450;
	var wheight=400; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.New&InsertType=User";
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)
	//window.open(lnk,'','',"dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;")
	
}

//add 2010
function DiagnosisLog_click()
{
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
		var SSIDObj=SummaryForm.document.getElementById("DSSID");
		if (SSIDObj) var SSID=SSIDObj.value;
		var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralDiagnosis');
	    var Dobj=SummaryForm.document;
		if (objtbl) { var rows=objtbl.rows.length; }
		var IDs="";
		for (i=1;i<rows;i++){
			var obj=Dobj.getElementById("TDeletez"+i) ;
			if (obj&&obj.checked){
				var obj=Dobj.getElementById("DTRowIdz"+i);
				if (IDs==""){
					IDs=obj.value;
				}
				else{
					IDs=IDs+"^"+obj.value;
				}
			}
		
		}
	}
	var wwidth=450;
	var wheight=400; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;

	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.Log&SSID="+SSID+"&IDs="+IDs;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
			
	window.open(lnk,"_blank",nwin)

}



function GeneralED_click()
{
	var wwidth=950;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.List&Code=&DiagnoseConclusion=&Alias=&vStationID=&ChartID=";
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;+
	window.open(lnk,"_blank",nwin)
	//window.open(lnk,'','',"dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;")
	
}
function BUpdateDiagnosis_click()
{
	var wwidth=650;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEExpertDiagnosis.Find";
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)
}
function AddDiagnosis(value){
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
	var Addobj=SummaryForm.document.getElementById("AddDiagnosis");
	if (Addobj) Addobj.value="";
	var ID=value.split("^")[0];
	var SSIDObj=SummaryForm.document.getElementById("DSSID");
	if (SSIDObj) var SSID=SSIDObj.value;
	var obj=SummaryForm.document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (SSID=="") {alert(t["NoSS"]);return false;}
	var flag=cspRunServerMethod(encmeth,SSID,ID,"0");
	
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;}
}
function Update_click(type){
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
		var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralDiagnosis');
	
		if (objtbl) { var rows=objtbl.rows.length; }
		
		var lastrowindex=rows - 1;
		var i,obj,ID,Remark,Strings;
		var ID,Remark,Strings="",Advice,EDCDesc="",OEItemId="",DisplayDesc="",ReCheck="N";
		for (i=1;i<rows;i++)
		{   
			obj=SummaryForm.document.getElementById("DTRowIdz"+i);
			if (obj) ID=obj.value;
			var tr = obj.parentNode.parentNode;
			Sort=tr.rowIndex;
			obj=SummaryForm.document.getElementById("LinkOrder"+ID);
			if (obj) OEItemId=obj.value;
			obj=SummaryForm.document.getElementById("DRemarkz"+i);
			if (obj) Remark=obj.value;
			obj=SummaryForm.document.getElementById("DTResultz"+i);
			if (obj) Advice=obj.value;
			/*
			obj=SummaryForm.document.getElementById("TSortz"+i);
			if (obj){
				Sort=obj.innerText;
				//if (Sort==undefined) Sort=obj.innerText
			}*/
			//Sort=i;
			obj=document.getElementById('TReCheckz'+i);
			if(obj){
		    if (obj.checked){ReCheck="Y" }
		    else{ReCheck="N"}
			}
            if (Sort=="")
			{
				alert(t["SortNull"]+i);
				return false;
			}
			EDCRowId="";
			obj=SummaryForm.document.getElementById("EDCDescz"+i);
			if (obj) EDCRowId=obj.value;
	        	obj=SummaryForm.document.getElementById("TDisplayDescz"+i);      //add 
			if (obj){
				DisplayDesc=obj.innerText;
				if (DisplayDesc=="undefined") DisplayDesc=obj.value;
				
			} 
			                              //add 
			if (Strings=="")
			{
				Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
			}
			else
			{
				Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
			}
		}
	
		if (Strings=="") return false;
		var obj=SummaryForm.document.getElementById("DUpdateBox");
		if (obj) var encmeth=obj.value;
		var MainDoctor="";
		var obj=SummaryForm.document.getElementById("MainDoctor");
		if (obj) MainDoctor=obj.value;
		var flag=cspRunServerMethod(encmeth,Strings,MainDoctor)
		if (type!="1"){
		alert(t[flag]);
		location.reload(true);
		return false;
		}
		
	}
}
function Sort_click(type){
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
		var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralDiagnosis');
	
		if (objtbl) { var rows=objtbl.rows.length; }
		
		var lastrowindex=rows - 1;
		var i,obj,ID,Remark,Strings;
		var ID,Remark,Strings="",Advice,EDCDesc="",OEItemId="",DisplayDesc="",ReCheck="N";
		for (i=1;i<rows;i++)
		{   
			obj=SummaryForm.document.getElementById("DTRowIdz"+i);
			if (obj) ID=obj.value;
			obj=SummaryForm.document.getElementById("LinkOrder"+ID);
			if (obj) OEItemId=obj.value;
			obj=SummaryForm.document.getElementById("DRemarkz"+i);
			if (obj) Remark=obj.value;
			obj=SummaryForm.document.getElementById("DTResultz"+i);
			if (obj) Advice=obj.value;
			obj=SummaryForm.document.getElementById("TSortz"+i);
			if (obj) Sort=obj.value;
			obj=document.getElementById('TReCheckz'+i);
			if(obj){
		    if (obj.checked){ReCheck="Y" }
		    else{ReCheck="N"}
			}
            if (Sort=="")
			{
				alert(t["SortNull"]+i);
				return false;
			}
			
			EDCRowId="";
			obj=SummaryForm.document.getElementById("EDCDescz"+i);
			if (obj) EDCRowId=obj.value;
	        obj=SummaryForm.document.getElementById("TDisplayDescz"+i);      //add 
			if (obj){
				DisplayDesc=obj.innerText;
				if (DisplayDesc=="") DisplayDesc=obj.value;
			}
			                              //add 
			if (Strings=="")
			{
				Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
			}
			else
			{
				Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
			}
		}
	
		if (Strings=="") return false;
		var obj=SummaryForm.document.getElementById("DUpdateSortBox");
		if (obj) var encmeth=obj.value;
	
		var flag=cspRunServerMethod(encmeth,Strings)
		if (type!="1"){
		alert(t[flag]);
		location.reload(true);
		return false;
		}
		
	}
}
function Audit_click() {
	Update_click(1);
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
	obj=SummaryForm.document.getElementById("DEpisodeID");
	if (obj) var PAADM=obj.value;
	obj=SummaryForm.document.getElementById("DAuditBox");
	if (obj) var encmeth=obj.value;
	
	var url="dhcpecustomconfirmbox.csp?Type=Audit&PAADM="+PAADM;
  	var  iWidth=600; //模态窗口宽度
  	var  iHeight=800;//模态窗口高度
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var ret=window.showModalDialog(url, "", "dialogwidth:600px;dialogheight:700px;center:1"); 
  	if(ret!=1){
		return false;
	}
	var MainDoctor="";
	obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,"Submit","0",MainDoctor);
	if (flag=="0")
	{
		PermissonSetting();
		if (session['LOGON.GROUPDESC']=="体检总检医生")
		{
			var obj=SummaryForm.document.getElementById("KillChecking");
			if (obj)
			{
				var encmeth=obj.value;
				var ret=cspRunServerMethod(encmeth,PAADM);
			}
		}
		try{
			if (parent.frames("result")){
				var obj=parent.frames("query").document.getElementById("RegNo");
				if (obj){
					obj.focus();
					obj.select();
				}
				//parent.frames("result").location.reload();
				//window.location.reload();
				return false;
			}
		}catch(e){
		
			parent.parent.location.href="epr.default.csp";
			return false;
		}
	}
	alert(t[flag]);
	return false;
	}
}
function Delete_Click()
{
	
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
	if (!confirm(t['Del'])) return false;
	
	var Dobj=SummaryForm.document;
	var obj=Dobj.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	//if (DSelectedRow==0) return false;
	
	var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralDiagnosis');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	var IDs=""
	for (i=1;i<rows;i++)
	{
		var obj=Dobj.getElementById("TDeletez"+i) ;
		if (obj&&obj.checked)
		{
			var obj=Dobj.getElementById("DTRowIdz"+i);
			if (IDs=="")
			{
				IDs=obj.value;
			}
			else
			{
				IDs=IDs+"^"+obj.value;
			}
		}
		
	}
	
	var obj=SummaryForm.document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (IDs=="") return false;
	var flag=cspRunServerMethod(encmeth,SSID,IDs,"1");
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;}
}
function SumResult_click(){

	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
	if (!confirm(t['Del'])) return false;
	
	var Dobj=SummaryForm.document;
	var obj=Dobj.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	//if (DSelectedRow==0) return false;
	
	var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralDiagnosis');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	var IDs=""
	for (i=1;i<rows;i++)
	{
		var obj=Dobj.getElementById("TDeletez"+i) ;
		if (obj&&obj.checked)
		{
			var obj=Dobj.getElementById("DTRowIdz"+i);
			if (IDs=="")
			{
				IDs=obj.value;
			}
			else
			{
				IDs=IDs+"^"+obj.value;
			}
		}
		
	}
	
	var obj=SummaryForm.document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (IDs=="") return false;
	var flag=cspRunServerMethod(encmeth,SSID,IDs,"1");
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;}
	/*
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	if (SummaryForm) {
	if (!confirm(t['Del'])) return false;
	
	var Dobj=SummaryForm.document;
	var obj=Dobj.getElementById("DSSID");
	if (obj) var SSID=obj.value;
	if (DSelectedRow==0) return false;
	var obj=Dobj.getElementById("DTRowIdz"+DSelectedRow);
	var ID=""
	if (obj) ID=obj.value;
	var obj=SummaryForm.document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"1");
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;}*/
	
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var SummaryForm=document.forms['fDHCPEGeneralDiagnosis'];
	var Dobj=SummaryForm.document;
	var objtbl=Dobj.getElementById('tDHCPEGeneralDiagnosis');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var obj;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	obj=Dobj.getElementById("DBSumResult");
	if (Row==DSelectedRow)
	{
		DSelectedRow=0
		//obj.disabled=true;
	}
	else
	{
		DSelectedRow=Row;
		//obj.disabled=false;
	}
}

function PrintReport_click()
{
	Audit_click()
	var iPAADMDR='',iPAPMIDR="",iReportID="",iprnpath=""
	obj=document.getElementById("EpisodeID");
	if (obj){ iPAADMDR=obj.value; }
	
	var flag=tkMakeServerCall("web.DHCPE.Report","GetReportStatus",iPAADMDR,"PAADM");
	if (flag!=0)
	{	var eSrc=window.event.srcElement;
		if (eSrc.id!="BPrintView")
		{
			if (!confirm(t[flag])) {
			return false;
			}
		}
	}
	obj=document.getElementById("ReportNameBox");
	if (obj) { var iReportName=obj.value; }
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
	var lnk=iReportName+"?PatientID="+iPAADMDR;
	
	open(lnk,"_blank",nwin);
	return true;
}
//return: "R"-Read, "W"-write.
function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod,MainDoctor
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("DEpisodeID", 0)
	ChartId=GetCtlValueById("DChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	MainDoctor=GetCtlValueById("MainDoctor", 1);
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 1, ChartId,MainDoctor)
	if (MyPermission=="R"){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
	    	DisabledCtls("select",true);
		return "R";
	}
	return "W";
	
}