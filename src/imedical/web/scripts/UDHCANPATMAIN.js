var RowId;
var myData=new Array();
var myColumns=new Array();
var EpisodeID=document.getElementById('EpisodeID').value;
var opdateDate="",opdateNoSeq="";
var combo_RoomList=new Array();
var combo_opaSeqList=new Array();
var preRowInd=0;
var fullFlag=0;
var opnameList=new Array();
var opdocnamelist=new Array();
var combo_selectPrint=new Array();
var combo_andocList=new Array();
var preRow="";
var AnOpAccess="";
var scrNurStr="",cirNurStr="",andocStr="",supdocStr="",assdocStr="",hisRowId="",anDocNoteStr="",anDocAssStr="";
var pacuOpaId=""

function BodyLoadHandler() {
	var chkShowInfectious=document.getElementById('chkShowInfectious');
    if(chkShowInfectious){
		chkShowInfectious.onclick =ShowInfectious;
		ShowInfectious();
	}	
	var objtbl=document.getElementById('tUDHCANPATMAIN');
    var i;
   	var obj=document.getElementById('Save');
	if (obj)
	{
		obj.onclick = Save_Click;
		obj.disabled=true;
	}
	var obj=document.getElementById('MoveUp');
	if (obj)
	{
		obj.onclick = MoveUp_Click;
		obj.disabled=true;
	}	
	var obj=document.getElementById('MoveDown');
	if (obj)
	{
		obj.onclick = MoveDown_Click;
		obj.disabled=true;
	}		
	var obj=document.getElementById("Arrange")
	if(obj) 
	{
		obj.onclick = Arrange_Click;
	}
	var obj=document.getElementById("Leave")
	if(obj)
	{
		obj.onclick=Leave_Click;
	}
	var obj=document.getElementById("Resume")
	if(obj)
	{
		obj.onclick=Resume_Click;
	}
	var obj=document.getElementById("InRoom")
	if(obj)
	{
		obj.onclick=InRoom_Click;
	}
	var obj=document.getElementById("SaveOpTime")
	if(obj) 
	{
		obj.disabled=true;
		obj.onclick = SaveOpTime_Click;
	}
	
    var obj=document.getElementById('InOptPlan');
	if (obj) obj.onclick = InsertOptPlan_Click; //dj070628
    var obj=document.getElementById('btnAuditArrange');
	if (obj) obj.onclick =AuditArrange;
    var obj=document.getElementById('selectAll');
	if (obj) obj.onclick =SelectAll_Click;
	var obj=document.getElementById("TimeCalculation")
	if (obj) obj.onclick =TimeCalculation_Click;
	//var frm =dhcsys_getmenuform();
	var obj=document.getElementById("btnTranToPacuBed")
	if (obj) obj.onclick =TranToPacuBed_Click;
	var obj=document.getElementById("btnAnaDoctorOrdered")
	if (obj) obj.onclick =BtnAnaDoctorOrdered_Click;
	var obj=document.getElementById("btnSetDocArriveTime");
	if(obj) obj.onclick = SetDocArriveTime_Click;
  var isSet=false
    var win=top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
        if (frm) {
	        EpisodeID=frm.EpisodeID.value; ///ypz 070312
	        isSet=true
        }
	}
	if (isSet==false)
	{
    	var frm =dhcsys_getmenuform();
   		if (frm) { EpisodeID=frm.EpisodeID.value;}
	}

    //var obj=document.getElementById('EpisodeID');
    //if (obj) EpisodeID=obj.value;
    //alert(obj+"/"+EpisodeID);
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
	   var item=document.getElementById("statusz"+i);
	   var item1=document.getElementById("jzstatz"+i).innerText;
	   var item2=document.getElementById("ordnoz"+i);
	   item2.innerText=i;
	   var promptObj=document.getElementById("yyz"+i);
	   if(promptObj)
	   {promptObj.style.color="red"}
	  // alert (item2.innerText);
	   //alert (RowObj.rowIndex);
	   switch (item.innerText)
	   {
		   case t['val:apply']:
		//   RowObj.className="Discontinue";
		     if (item1==t['val:emergency'])  RowObj.className="LongNew"; //
		   break;
		   case t['val:refuse']:
		    RowObj.className="Discontinue"; //blue /refuse
		   break;
		   case t['val:arrange']:
		    RowObj.className="Immediate" ;//green //arranged
		   break;
		   case t['val:finish']:
		    RowObj.className="Temp" ;//yellow //finish
		   break;
		   case t['val:inRoom']:
		    RowObj.className="Skintest" ;//red 
		   break;
		   case t['val:leaveRoom']:
		    RowObj.className="UnPaid" ;//light blue
		   break;
		   case t['val:resume']:
		    RowObj.className="LongUnnew";
		   break;
		   default:
		   //RowObj.className="Exec"; //
		   break 
	   }
	   ObjIfUseCombox=document.getElementById("ifUseCombox");
	   if ((ObjIfUseCombox)&&(ObjIfUseCombox.checked==true)) // + wxl 090316
	   {
	   		enableOpaSeq(i);
	   		enableOpRoom(i);
	   }
	   //fill Nurses manually
	   var	obj=document.getElementById('scNurNotez'+i);
       if (obj) obj.onkeydown=UpdateKeyDown;
       var	obj=document.getElementById('cirNurNotez'+i);
       if (obj) obj.onkeydown=UpdateKeyDown;   
	}
	if (parent.frames[0].sendToScreen) {
		InsertOptPlan_Click();
		parent.frames[0].sendToScreen=false;
	}
	var	obj=document.getElementById("FullScreen");
	if (obj) obj.onclick=SetFrame;
}
function SetFrame()
{
	if (!parent.MainFrameSet) return;
	var	objFullScreen=document.getElementById("FullScreen");
	if (fullFlag==0){
		parent.MainFrameSet.rows="0,*"
		fullFlag=1;
		if (objFullScreen) objFullScreen.innerText=t['val:cancelfullscreen'];
	}
	else {
		parent.MainFrameSet.rows="27%,*"
		fullFlag=0;
		if (objFullScreen) objFullScreen.innerText=t['val:fullsreen'];
	}
	return;
}
function MoveUp_Click()
{ 
  //var aa;  
  //aa= new ActiveXObject("Project1.Qse");
   JHData("up");
  //aa.m1();
}
function JHData(typ)
{
   try{
   var i;
   var ObjTbl=document.getElementById('tUDHCANPATMAIN');
   var i=document.getElementById("selrow").value;
   var OldRow=i;
   var OpDate=document.getElementById("opdatez"+i).innerText;
   var Age=document.getElementById("agez"+i).innerText;
   var Locs=document.getElementById("locz"+i).innerText;
   var OpName=document.getElementById("opnamez"+i).innerText;
   var OpRoom=document.getElementById("oproomz"+i).innerText;
   var OpOrdNo=document.getElementById("opordnoz"+i).innerText;
   var RegNo=document.getElementById("regnoz"+i).innerText;
   var PatName=document.getElementById("patnamez"+i).innerText;
   var Sex=document.getElementById("sexz"+i).innerText;
   var YY=document.getElementById("yyz"+i).innerText;
   var JZStat=document.getElementById("jzstatz"+i).innerText;
   var OpDoc=document.getElementById("opdocz"+i).innerText;
   var AnDoc=document.getElementById("andocz"+i).innerText;
   var AnMethod=document.getElementById("anmethodz"+i).innerText;
   var Scr=document.getElementById("scrubnursez"+i).innerText;
   var Cir=document.getElementById("circulnursez"+i).innerText;
   var OpPack=""; 
   var objOpPack=document.getElementById("oppackz"+i)
   if (objOpPack) OpPack=objOpPack.innerText;
   var Rw=document.getElementById("opaIdz"+i).innerText;
   var Status=document.getElementById("statusz"+i).innerText;
   var Diag=document.getElementById("diagz"+i).innerText;
   //alert (i);
   if (typ=="up") i=--i;
   if (typ=="down") i=++i;
   //alert(i);
    PutRowData(OldRow,i)   
    document.getElementById("opdatez"+i).innerText=OpDate;
    document.getElementById("agez"+i).innerText=Age;
    document.getElementById("locz"+OldRow).innerText=Locs;
    document.getElementById("opnamez"+i).innerText=OpName;
    document.getElementById("oproomz"+i).innerText=OpRoom;
    document.getElementById("opordnoz"+i).innerText=OpOrdNo;
    document.getElementById("regnoz"+i).innerText=RegNo;
    document.getElementById("patnamez"+i).innerText=PatName;
    document.getElementById("sexz"+i).innerText=Sex;
    document.getElementById("yyz"+i).innerText=YY;
    document.getElementById("jzstatz"+i).innerText=JZStat;
    document.getElementById("opdocz"+i).innerText=OpDoc;
    document.getElementById("andocz"+i).innerText=AnDoc;
    document.getElementById("anmethodz"+i).innerText=AnMethod;
    document.getElementById("scrubnursez"+i).innerText=Scr;
    document.getElementById("circulnursez"+i).innerText=Cir;
    if (objOpPack) document.getElementById("oppackz"+i).innerText=OpPack;
    document.getElementById("statusz"+i).innerText=Status;
    document.getElementById("diagz"+i).innerText=Diag;
    document.getElementById("opaIdz"+i).innerText=Rw;
    document.getElementById("selrow").value=i;
    var selrow= document.getElementById("selrow").value;
	RSColor(i,ObjTbl,selrow);
    RSColor(OldRow,ObjTbl,selrow);   
   }
    catch(e)
   {
	  alert(e.toString());
   }
}
function PutRowData(OldRow,i)
{
    document.getElementById("opdatez"+OldRow).innerText=document.getElementById("opdatez"+i).innerText;
    document.getElementById("agez"+OldRow).innerText=document.getElementById("agez"+i).innerText;
    document.getElementById("locz"+OldRow).innerText=document.getElementById("locz"+OldRow).innerText;
    document.getElementById("opnamez"+OldRow).innerText=document.getElementById("opnamez"+i).innerText
    document.getElementById("oproomz"+OldRow).innerText=document.getElementById("oproomz"+i).innerText;
    document.getElementById("opordnoz"+OldRow).innerText=document.getElementById("opordnoz"+i).innerText;
    document.getElementById("regnoz"+OldRow).innerText=document.getElementById("regnoz"+i).innerText;
    document.getElementById("patnamez"+OldRow).innerText=document.getElementById("patnamez"+i).innerText;
    document.getElementById("sexz"+OldRow).innerText=document.getElementById("sexz"+i).innerText;
    document.getElementById("yyz"+OldRow).innerText=document.getElementById("yyz"+i).innerText;
    document.getElementById("jzstatz"+OldRow).innerText=document.getElementById("jzstatz"+i).innerText;
    document.getElementById("opdocz"+OldRow).innerText=document.getElementById("opdocz"+i).innerText;
    document.getElementById("andocz"+OldRow).innerText=document.getElementById("andocz"+i).innerText;
    document.getElementById("anmethodz"+OldRow).innerText=document.getElementById("anmethodz"+i).innerText;
    document.getElementById("scrubnursez"+OldRow).innerText=document.getElementById("scrubnursez"+i).innerText;
    document.getElementById("circulnursez"+OldRow).innerText=document.getElementById("circulnursez"+i).innerText;
    var objOpPack=document.getElementById("oppackz"+i)
    if (objOpPack) document.getElementById("oppackz"+OldRow).innerText=document.getElementById("oppackz"+i).innerText;
    document.getElementById("opaIdz"+OldRow).innerText=document.getElementById("opaIdz"+i).innerText;
    document.getElementById("statusz"+OldRow).innerText=document.getElementById("statusz"+i).innerText;
    document.getElementById("diagz"+OldRow).innerText=document.getElementById("diagz"+i).innerText;

}
function RSColor(Row,ObjTbl,selrow)
{
    var eSrc=ObjTbl.rows[Row];
	var RowObj=getRow(eSrc);
    var JZ=document.getElementById("jzstatz"+Row).innerText
	var Status=document.getElementById("statusz"+Row).innerText;
	switch (Status)
	{
		   case t['val:apply']:
		//   RowObj.className="Discontinue";
		     if (JZ==t['val:emergency'])  RowObj.className="LongNew"//"LongNew"; //red 
		     else  RowObj.className="RowEven";
		   break;
		   case t['val:refuse']:
		    RowObj.className="Discontinue"//"Discontinue"; //blue /resu
		   break;
		   case t['val:arrange']:
		    RowObj.className="Immediate";//green //arrange
		   break;
		   case t['val:finish']:
		    RowObj.className="Temp" ;//yellow //finish
		   break;
		   case t['val:inRoom']:
		    RowObj.className="Skintest" ;//red 
		   break;
		   case t['val:leaveRoom']:
		    RowObj.className="UnPaid" ;//light blue
		   break;
		   case t['val:resume']:
		    RowObj.className="LongUnnew";
		   break;
		   default:
		     RowObj.className="RowEven"; //
		   break 
	}
//	alert(selrow+" "+Row);
    if (selrow==Row)
    {
	   RowObj.className="clsRowSelected";
	}
}
function MoveDown_Click()
{
	//alert(MaxRows+"^"+CurRow);
  JHData("down");
}
function Save_Click() //save arrange status
{
    var objtbl=document.getElementById('tUDHCANPATMAIN');
    var i;
   	var str="";
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
	   var item1=document.getElementById("opaIdz"+i).innerText;
	   var item=document.getElementById("statusz"+i);
	   if (item.innerText!=t['val:refuse'])
	   {
	   str=str+item1+"^"
	   }
	}
	var UpdateSeq=document.getElementById("UpdateSeq").value;
	var res=cspRunServerMethod(UpdateSeq,str)
	//alert(res);   //alert (RowObj.rowIndex);
	window.location.reload();
}

function oparrange(lnk,nwin)  //operation arrange
{
    // if (Adm==""||BillNo=="") {{alert(t['01']);return;}}
    //lnk+="&EpisodeID="+Adm+"&BillNo="+BillNo;
    var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
    var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:apply'])&&(Status!=t['val:arrange'])) {
		alert(t['alert:canOper']+t['val:apply']+","+t['val:arrange']);
		return;
	}
   if (selrow.value!="")
     opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   else
    opaId=""
   var appType="op";
  if (opaId=="")
  {
   alert(t['alert:selectOne']);
   return;
  }
  lnk+="&opaId="+opaId+"&appType="+appType;
   window.open(lnk,'_blank',nwin);

}
function opcancelrefuse()  //cancel opertion application
{
	var selrow=document.getElementById("selrow");
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if (Status!=t['val:refuse']) {
		alert(t['alert:canOper']+t['val:refuse']);
		return;
	}

   var ChangeAnopStat=document.getElementById("ChangeAnopStat").value;
   var opaId;
   opaId="";
   if (selrow.value!="")
     opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   if (opaId=="")
   {
    alert(t['alert:selectOne']);
    return;
   }

   if (opaId!="")
   {
	  var ret=cspRunServerMethod(ChangeAnopStat,"A",opaId);
	  
   }
   //alert(ret);
   self.location.reload();
	
}

function oprefuse()  //refuse operation application
{
    var selrow=document.getElementById("selrow");
    var opaId="";
    if (selrow.value!="")
   	{
		var Status=document.getElementById("statusz"+selrow.value).innerText;
		if ((Status!=t['val:apply'])&&(Status!=t['val:arrange'])) {
			alert(t['alert:canOper']+t['val:apply']+","+t['val:arrange']);
			return;
		}
   		var ChangeAnopStat=document.getElementById("ChangeAnopStat").value;
     	opaId=document.getElementById("opaIdz"+selrow.value).innerText;
     	
     	var objtbl=document.getElementById('tUDHCANPATMAIN');
		var selectedRowNumber=0;
		for (var i=1;i<objtbl.rows.length;i++)
		{
			var sel=document.getElementById("SelItemz"+i);
			if (sel.checked==true)
			{
				selectedRowNumber=selectedRowNumber+1;
			}
		}
		if(selectedRowNumber>1)
		{
			alert(t['alert:selectOne']);
		}
		else
		{
   			if (opaId=="")
   			{
    			alert(t['alert:selectOne']);
    			return;
   			}
   			if (opaId!="")
   			{
	   			var ret=cspRunServerMethod(ChangeAnopStat,"D",opaId);
	  			//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSuspend&opaId="+opaId;
	  			//window.showModalDialog(lnk,"UDHCANOPAppRetReason","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
	  			//window.open(lnk,"DHCANOPSuspend","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=700,top=100,left=300");
   			}
		}
   	}
   	else
   	{
	   	alert(t['alert:selectOne']);
	}
   	//alert(ret);
   	self.location.reload(); 
}
function AnArrange(lnk,nwin)	//anaesthesia arrange 
{
  /// if (Adm==""||BillNo=="") {{alert(t['01']);return;}}
    var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
 	var Status=document.getElementById("statusz"+selrow.value).innerText;
	/*if (Status!=t['val:apply']) {   //for JST
		alert(t['alert:canOper']+t['val:apply']);
		return;
	}*/
  if (selrow.value!="")
     opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   else
    opaId=""
   var appType="anaes";
  if (opaId=="")
  {
   alert(t['alert:selectOne']);
   return;
  }
   lnk+="&opaId="+opaId+"&appType="+appType;
   window.open(lnk,'_blank',nwin);	
}
function opapp(lnk,nwin)  //operation application Update: pat doc update
{
  var opaId
  var selrow=document.getElementById("selrow");
  if (selrow.value!="")
     opaId=document.getElementById("opaIdz"+selrow.value).innerText;
  else
    opaId=""
  if (opaId=="")
  {
   alert(t['alert:selectOne']);
   return;
  }
  var stat=document.getElementById("statusz"+selrow.value).innerText;
  //if (stat!=t['val:apply']) return;
  if ((stat==t['val:refuse'])||(stat==t['val:arrange'])||(stat==t['val:finish'])) return;
   var appType="ward";
   lnk+="&opaId="+opaId+"&appType="+appType;
   window.open(lnk,'_blank',nwin)	
}
function NewAnopapp(lnk,nwin)	//pat doctor new application
{
	//alert(session['LOGON.GROUPID']);
	var opaId
	opaId=""
	var appType="ward";
	lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID;
	window.open(lnk,'_blank',nwin)	
}
/*
function NewAnopappRetReason(lnk,nwin)
{
	var opaId="";
	var appType="ward";
	lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID;
	window.open(lnk,'_blank',nwin)
}
*/
function NoPaid(lnk,nwin)
{
	var opaId
	var selrow=document.getElementById("selrow");
	var admNum="";
	if (selrow.value!="")
	{
		opaId=document.getElementById("opaIdz"+selrow.value).innerText;
		admNum=document.getElementById("admz"+selrow.value).innerText;
	}
	else
	{
	    opaId=""
	}
	//alert(opaId);
	if (opaId=="")
	{
	   alert(t['alert:selectOne']);
	   return;
	}
	else
	{
		var userId=session['LOGON.USERID'];
		var ctlocId=session['LOGON.CTLOCID'];
		//var appType="ward"; //EpisodeID As %String, DHCANORowid As %String, UserID As %String, CTloc 
		//alert(userId);
		//alert(ctlocId);
		//alert(admNum);
		lnk+="&EpisodeID="+admNum+"&DHCANORowid="+opaId+"&UserID="+userId+"&CTloc="+ctlocId;
		window.open(lnk,'_blank',nwin)	
	}
}
 function SelectRowHandler()
 {
    var i;
    var selrow=document.getElementById("selrow");
    var resList=new Array();
    var objtbl=document.getElementById('tUDHCANPATMAIN');
     selrow.value=DHCWeb_GetRowIdx(window);
   // var opaId=document.getElementById("opaIdz"+selrow.value).innerText;
    var adm=document.getElementById("admz"+selrow.value).innerText;
    var objEpisodeID=document.getElementById("EpisodeID");
    objEpisodeID.value=adm;
    EpisodeID=adm;
    RowId=document.getElementById("opaIdz"+selrow.value).innerText;
  // var aa= parent.frames[0].document.getElementById("EpisodeID").value
  	var AnaesthesiaID="";
  	var obj=document.getElementById("AnaesthesiaIDz"+selrow.value)
  	if (obj) AnaesthesiaID=obj.innerText; // wxl 090411
  	var win=top.frames['eprmenu'];
  	//var opdatetime=document.getElementById("opdatez"+selrow.value).innerText;
	var opdatestr=document.getElementById("opdatestrz"+selrow.value).innerText;
	var Lopopdatestr=opdatestr.split(" ");
    opdateDate=Lopopdatestr[0];
    var opdateStr=opdatestr.split("~");
	opdateNoSeq=opdateStr[0];
	var isSet=false;
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
        if (frm) {
			frm.PatientID.value = "";
			frm.EpisodeID.value =adm;
			if(frm.AnaesthesiaID) frm.AnaesthesiaID.value =AnaesthesiaID;// +wxl 090411
			isSet=true;
        }
	}
	if (isSet==false)
	{
		var frm =dhcsys_getmenuform();
		if (frm) 
		{
		   frm.EpisodeID.value=adm;
		   EpisodeID=adm
		   if(frm.AnaesthesiaID) frm.AnaesthesiaID.value =AnaesthesiaID;
		}
	}
  // alert(parent.parent.frames[1].document.getElementById("EpisodeID").value);
   	var obj=document.getElementById('Save');
   	if(obj)
   	{
		 if (obj.disabled==false)
		 {
			 for (i=1;i<objtbl.rows.length;i++)
	         {
		         RSColor(i,objtbl,selrow.value)
		     }
	 
	     }
   	}
   	var logUserLocType=parent.frames[0].fLogUserLocType
   	//alert(LogUserType)
   	var ObjIfUseCombox=document.getElementById("ifUseCombox");
	if ((ObjIfUseCombox)&&(ObjIfUseCombox.checked==true)&&(logUserLocType=="OP")){
		enableOpaSeq(selrow.value);
		enableOpRoom(selrow.value);
		//enableOpmem(selrow.value);
		enableScrubnurse(selrow.value);
		enableCirculnurse(selrow.value);
	}
	if ((ObjIfUseCombox)&&(ObjIfUseCombox.checked==true)&&(logUserLocType=="AN")){
		enableAnDoc(selrow.value)
		enableAnDocNote(selrow.value)
		enableAnDocAss((selrow.value))
	}
	//Send Value to UDHCANOPSCH Component	
	if (preRowInd!=selrow.value){
		var opaId=document.getElementById("opaIdz"+selrow.value).innerText; // ljw 091108
		var status=document.getElementById("statusz"+selrow.value).innerText;
		preRowInd=selrow.value;
	}
	else{
		var opaId=""
		var status=""
		preRowInd=0
	}
  	var win=parent.frames['anoptop'];
	if (win) {
		var frm = win.document.getElementById('opaId');
		if (frm) frm.value =opaId;
		var frm1 = win.document.getElementById('status');
        if (frm1) frm1.value =status;
	}
 }
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
//anpatprn
function anpatprn()  //Anaesthesia patient print, status:arranged
{  
  var fileName,path;
  var xlsExcel,xlsBook,xlsSheet;
  var row=1;
  var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
  var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
  var objtbl=document.getElementById('tUDHCANPATMAIN');
  //fileName=path+ fileName;
  //
  path=GetFilePath();
  fileName=path+"oppatlist.xls";
  //fileName="C:\\oppatlist.xls";
  xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
  xlsBook = xlsExcel.Workbooks.Add(fileName) ;//;Open(fileName)
  xlsSheet = xlsBook.ActiveSheet; //  Worksheets(1)
  	for (i=1;i<objtbl.rows.length;i++)
	{
	    var stat=document.getElementById("statusz"+i).innerText;
        if (stat==t['val:arrange'])  //arranged pat
        {
	      var opd=document.getElementById("opdatez"+i).innerText;
	      var oparr=opd.split(" ");
	      var age=document.getElementById("agez"+i).innerText;
	      var agarr=age.split("Y");
	      var locs=document.getElementById("locz"+i).innerText;
	      var locarr=locs.split("-");
	      var ops=document.getElementById("opnamez"+i).innerText;
	      var opsrr=ops.split("-");
	      row=row+1;
	      xlsSheet.cells(row,1)=row-1;
	      xlsSheet.cells(row,2)=oparr[1];
	      xlsSheet.cells(row,3)=document.getElementById("oproomz"+i).innerText;
	      xlsSheet.cells(row,4)=document.getElementById("opordnoz"+i).innerText;
	      xlsSheet.cells(row,5)=locarr[1];
	      xlsSheet.cells(row,6)=document.getElementById("regnoz"+i).innerText;
	      xlsSheet.cells(row,7)=document.getElementById("patnamez"+i).innerText;
	      xlsSheet.cells(row,8)=document.getElementById("sexz"+i).innerText;
	      xlsSheet.cells(row,9)=agarr[0];
	      xlsSheet.cells(row,10)=document.getElementById("yyz"+i).innerText;
	      xlsSheet.cells(row,11)=document.getElementById("jzstatz"+i).innerText;
	      xlsSheet.cells(row,12)=opsrr[1];
	      xlsSheet.cells(row,13)=document.getElementById("opdocz"+i).innerText;
	      xlsSheet.cells(row,14)=document.getElementById("andocz"+i).innerText;
	      xlsSheet.cells(row,15)=document.getElementById("anmethodz"+i).innerText;
	      xlsSheet.cells(row,16)=document.getElementById("scrubnursez"+i).innerText;
	      xlsSheet.cells(row,17)=document.getElementById("circulnursez"+i).innerText;
	      var objOpPack=document.getElementById("oppackz"+i)
    	  if (objOpPack) xlsSheet.cells(row,18)=document.getElementById("oppackz"+i).innerText;
        }
	}
	   var dat=document.getElementById("opdatez"+1).innerText;
	   var arr=dat.split(" ");
       var CenterHeader = "&12anaesth Fee Sheet"+"\r"+arr[0];
       var LeftHead="";
        titleRows=1;
        titleCols=1;
        RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        AddGrid(xlsSheet,0,0,row,18,1,1);
        FrameGrid(xlsSheet,0,0,row,18,1,1);
	    xlsExcel.Visible = true
        xlsSheet.PrintPreview 
        //xlsSheet.PrintOut(); 

        //xlsSheet = null;
        xlsBook.Close(savechanges=false)
        xlsBook = null;
        xlsExcel.Quit();
       // xlsExcel = null;

}
function PrintRP()  //operation patient print,status:arranged
{  
  var fileName,path;
  var xlsExcel,xlsBook,xlsSheet;
  var row=1;
  var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
  var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
  var objtbl=document.getElementById('tUDHCANPATMAIN');
  //fileName=path+ fileName;
  path=GetFilePath();
  fileName=path+"oppatlist.xls";
  //alert(fileName)
  //fileName="C:\\oppatlist.xls";
  xlsExcel = new ActiveXObject("Excel.Application");
	 //   alert("also ok")
  xlsBook = xlsExcel.Workbooks.Add(fileName) ;//;Open(fileName)
  xlsSheet = xlsBook.ActiveSheet; //  Worksheets(1)
  //add by weiguoxin ------------------------
  var Printyyz=false
  if (document.getElementById('chkShowInfectious')) Printyyz= confirm(t['alert:ifPrintSpecInfect']);
  if(Printyyz==false)
	{
		xlsSheet.cells(21).ColumnWidth=0; 
	}
  //-------------------------------------------	      
  var oproom1=""       //080104
  var oproom=""
  	for (i=1;i<objtbl.rows.length;i++)
	{
	    var stat=document.getElementById("statusz"+i).innerText;
        if (stat==t['val:arrange'])
        { 
	      var opd=document.getElementById("opdatez"+i).innerText;
	      var oparr=opd.split(" ");
	      var age=document.getElementById("agez"+i).innerText;
	      var agarr=age.split("Y");
	      var locs=document.getElementById("locz"+i).innerText;
	      var locarr=locs.split("-");
	      var locrec=locarr[0].split("/");
	      var ops=document.getElementById("opnamez"+i).innerText;
	      var opsrr=ops.split("-");
	      var oproom=document.getElementById("oproomz"+i).innerText;    //080104
	  
	      row=row+1;
	      xlsSheet.cells(row,1)=row-1;
	   // xlsSheet.cells(row,2)=oparr[1];
	  	xlsSheet.cells(row,2)=document.getElementById("opdatez"+i).innerText;	
	     // xlsSheet.cells(row,2)=document.getElementById("jzstatz"+i).innerText;
	      //xlsSheet.cells(row,3)=oparr[1];
	     //xlsSheet.cells(row,3)=document.getElementById("oproomz"+i).innerText;
	      if  (oproom1==oproom){                                      //080104
		     //xlsSheet.cells(row,3)=t['val:sameroom']
	      }
	      else{
		      //xlsSheet.cells(row,3)=oparr[1];
	      }
	      xlsSheet.cells(row,3)=document.getElementById("oproomz"+i).innerText;
	      
	      xlsSheet.cells(row,4)=document.getElementById("opordnoz"+i).innerText;
	      xlsSheet.cells(row,5)=locrec[0];//+"-"+locrec[1];
	      xlsSheet.cells(row,6)=document.getElementById("regnoz"+i).innerText;
	      xlsSheet.cells(row,7)=document.getElementById("patnamez"+i).innerText;
	      xlsSheet.cells(row,8)=document.getElementById("sexz"+i).innerText;
	      xlsSheet.cells(row,9)=agarr[0];
	      xlsSheet.cells(row,10)=document.getElementById("yyz"+i).innerText;
	      //xlsSheet.cells(row,11)=document.getElementById("diagz"+i).innerText;
	      xlsSheet.cells(row,11)=document.getElementById("jzstatz"+i).innerText;
	      xlsSheet.cells(row,12)=opsrr[0];
	      var opdoc=document.getElementById("opdocz"+i).innerText;
	      var opdocdes=opdoc.split(",");
	      xlsSheet.cells(row,13)=document.getElementById("andocz"+i).innerText;//opdocdes[0];
	      var Lopdocdes=opdocdes[1].split(" ");
	      //alert(Lopdocdes[1]+"^"+Lopdocdes[2]+"^"+Lopdocdes[3])
	      xlsSheet.cells(row,14)=document.getElementById("circulnursez"+i).innerText;
	      xlsSheet.cells(row,15)=document.getElementById("anmethodz"+i).innerText; //ypz 061206 form16
	      xlsSheet.cells(row,16)=document.getElementById("scrubnursez"+i).innerText;  //ypz 061206 form15
	      xlsSheet.cells(row,17)=document.getElementById("circulnursez"+i).innerText;
	      //xlsSheet.cells(row,18)=document.getElementById("circulnursez"+i).innerText;
	      //xlsSheet.cells(row,19)=document.getElementById("yyz"+i).innerText;
	     
	      xlsSheet.cells(row,18)="";
        }
        oproom1=oproom         //080104
	}
	    var dat=document.getElementById("opdatez"+1).innerText;
	    var arr=dat.split(" ");
	 
	    var objGetWenDay=document.getElementById("TranDat");
	    var TWenDay="";
	    if (objGetWenDay) {
	   		var WenDay=cspRunServerMethod(objGetWenDay.value,arr[0]);   //cjb Modify 2007-05-15 for show the WenDay
	   		var TWenDay=" "+TranDat(WenDay);
	    }
	    //alert(TWenDay)
	    var hospitalDesc=document.getElementById("hospital").value
        var CenterHeader = "&15"+hospitalDesc+t['val:operArrangeSheet']+"\r"+arr[0]+TWenDay;
        var LeftHead="";
        titleRows=1;
        titleCols=1;
        RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        AddGrid(xlsSheet,0,0,row,19,1,1);
        FrameGrid(xlsSheet,0,0,row,19,1,1);
	    //xlsExcel.Visible = true
        //xlsSheet.PrintPreview 
        xlsSheet.PrintOut(); 

        xlsSheet = null;
        xlsBook.Close(savechanges=false)
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;

}
function PrintRPatList()  //operation patient print,status:arranged
{
	var fileName,path;
	var xlsExcel,xlsBook,xlsSheet;
	var row=1;
	var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	path=GetFilePath();
	fileName=path+"OpRPatList.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) ;
	xlsSheet = xlsBook.ActiveSheet;
	var printObj=document.getElementById("getPrint");
	if(printObj)
	{
		var printStr=printObj.value;
		var strList=printStr.split("^")
		var printLen=strList.length;
		for (var i=0;i<printLen;i++)
		{
			xlsSheet.cells(1,i+1)=strList[i].split("!")[1];
		}
		var row=1
		for (var i=1;i<objtbl.rows.length;i++)
		{
			var stat=document.getElementById("statusz"+i).innerText;
			var sel=document.getElementById("SelItemz"+i);
			if ((stat==t['val:arrange'])||(sel.checked==true))
			{
				row=row+1
				for(var j=0;j<printLen;j++)
				{
					var colName=strList[j].split("!")[0];
					xlsSheet.cells(row,j+1)=document.getElementById(colName+"z"+i).innerText;
				}
			}
		}
	}
	else {return }
	var hospitalDesc=document.getElementById("hospital").value
	var CenterHeader = "&15"+hospitalDesc+t['val:operArrangeSheet']+"\r";
	var LeftHead="";
	titleRows=1;
	titleCols=1;
	RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	AddGrid(xlsSheet,0,0,row-1,printLen-1,1,1);
	FrameGrid(xlsSheet,0,0,row-1,printLen-1,1,1);
	//xlsExcel.Visible = true;
	//xlsSheet.PrintPreview;
	xlsSheet.PrintOut(); 
	xlsSheet = null;
 	xlsBook.Close(savechanges=false)
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}
 function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }
function AnOPPaiBan()  //operation room seqno adjust
{
	var obj=document.getElementById('Save');
	if (obj) obj.disabled=false;
	var obj=document.getElementById('MoveUp');
	if (obj) obj.disabled=false;
	var obj=document.getElementById('MoveDown');
    if (obj) obj.disabled=false;
}
function AnPrice(lnk,nwin)
{
	var selrow=document.getElementById("selrow");
	if (selrow.value!="")
	{
		alert(t['alert:selectOne']);
   		return;
	}
	var objPatInfo=document.getElementById("PatInfo");
	if (! objPatInfo) return;
	OpDate=document.getElementById("opdatez"+selrow.value).innerText;
    EpisodeID=document.getElementById("admz"+selrow.value).innerText
    var str=cspRunServerMethod(objPatInfo.value,EpisodeID);
    if (str=="") return;
    var Dep="214"; //anaesth loc
    var Res=str.split("^");
    lnk+="&EpisodeID="+EpisodeID+"&Dep="+Dep+"&PatName="+Res[4]+"&BedCode="+Res[6]+"&appType=anaesthFee"+"&OpDate="+OpDate;
    window.open(lnk,'_blank',nwin);	
}
function OpPrice(lnk,nwin)	{  //inpatient operation 211
	var selrow=document.getElementById("selrow");
	if (selrow.value!="")
	{
		alert(t['alert:selectOne']);
   		return;
	}
	var objPatInfo=document.getElementById("PatInfo");
	if (! objPatInfo) return;
	OpDate=document.getElementById("opdatez"+selrow.value).innerText;
    EpisodeID=document.getElementById("admz"+selrow.value).innerText
    var str=cspRunServerMethod(objPatInfo.value,EpisodeID);
    if (str=="") return;
    var Res=str.split("^");
    var Dep=session['LOGON.CTLOCID'];
    lnk+="&EpisodeID="+EpisodeID+"&Dep="+Dep+"&PatName="+Res[4]+"-"+Res[0]+"&BedCode="+Res[6]+"&appType=OperationFee"+"&OpDate="+OpDate;
   //alert(lnk) 
   window.open(lnk,'_blank',nwin);	
}
function OPREG(lnk,nwin)
{
 	var opaId;
 	var selrow=document.getElementById("selrow");
 	if (selrow.value=="")  return;
 	//var flag=document.getElementById("flagz"+selrow.value).innerText;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}

 	if (selrow.value!=""){opaId=document.getElementById("opaIdz"+selrow.value).innerText;}
  	else opaId="";
  	if (opaId=="")
  	{
   		alert(t['alert:selectOne']);
   		return;
  	}
  	var selrow=document.getElementById("selrow")
  	if (selrow)
  	{ 
		/*for med doc check//if(document.getElementById("oprFloorz"+selrow.value))
		{
			var anNote=document.getElementById("oprFloorz"+selrow.value).innerText;
			if (anNote.length>4) 
			{
			alert(anNote);
			return;
			}
		}*/
  	}

   	var appType="RegOp";
   	lnk+="&opaId="+opaId+"&appType="+appType;
   	window.open(lnk,'_blank',nwin)
}
function OPREGAB(lnk,nwin)
{
 var opaId
 var selrow=document.getElementById("selrow");
 var stat;
 if (selrow.value!=""){
    opaId=document.getElementById("opaIdz"+selrow.value).innerText;
    stat=document.getElementById("statusz"+selrow.value).innerText;
    if (stat!=t['val:unAppoint'])  //change at message!! ypz
    {
	 return;    
	}
 }
 else
    opaId=""
 var appType="RegNotApp";  //"&appType=RegNotApp"
   lnk+="&opaId="+opaId+"&appType="+appType;
   window.open(lnk,'_blank',nwin)
}
function NotOpAppSch() //un preApply search
{
  var appDate=parent.frames[0].document.getElementById("opdate").value;
  var endDate=parent.frames[0].document.getElementById("enddate").value;
  var RoomId=parent.frames[0].document.getElementById("RoomId").value;
  var loc=parent.frames[0].document.getElementById("loc").value;
  var Dept=parent.frames[0].document.getElementById("Dept").value;
  if (Dept=="") loc="";
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=UDHCANPATMAIN&stdate="+appDate+"&enddate="+endDate+"&oproom="+RoomId+"&Dept="+loc+"&appType=RegNotApp";
	   // al ert (lnk);
  window.location.href=lnk; 
  
}
function opcalling()//operation calling
{
   var selrow=document.getElementById("selrow");
   var GetDocList=document.getElementById("GetDocList").value;
   var opaId,Stat;
   opaId="";
   if (selrow.value!=""){
     opaId=document.getElementById("opaIdz"+selrow.value).innerText;
     Stat=document.getElementById("statusz"+selrow.value).innerText; 
   }
   
   if (opaId=="")
   {
    alert(t['alert:selectOne']);
    return;
   }
   if (Stat!=t['val:arrange'])
   {
	   alert(t['alert:canOper']+t['val:arrange']);
	   return;
   }
   if (opaId!="")
   {
	  var ret=cspRunServerMethod(GetDocList,opaId,session['LOGON.USERID']);
      var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPCALLING&opaId="+opaId+"&User="+session['LOGON.USERID'];
      window.open(lnk,'_blank',"toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,top=0,left=0,height=200,width=450");	
   }
	
}
function AuditArrange()
{
//	var opaId=2,opordno="ordno",opname="opname",opdate="0706",optime="8:00",oproom="room1",anmethod="body",patname="test",age="16",sex="女",locrec="5",regno="0002",diag="fever",opdocdes="doc1",Lopdocdes1="first",Lopdocdes2="second",Lopdocdes3="three",andoc="aneath",scrubnurse="nur",circulnurse="nur2"
//	var sqlInsert="INSERT INTO OPPLAN(OperateCode,OptNo,OperateName,StartDate,StartTime,OperateRoom,Opiumize,PatientName,PatientAge,PatientSex,PatientBedNo,Patientzhuyuanhao,PatientZhenDuan,ZhuChiYiSheng,YiZhu,ErZhu,SanZhu,MaYi,XiShou,XunHui) VALUES ('"+opaId+"','"+opordno+"','"+opname+"','"+opdate+"','"+optime+"','"+oproom+"','"+anmethod+"','"+patname+"','"+age+"','"+sex+"','"+locrec+"','"+regno+"','"+diag+"','"+opdocdes+"','"+Lopdocdes1+"','"+Lopdocdes2+"','"+Lopdocdes3+"','"+andoc+"','"+scrubnurse+"','"+circulnurse+"')"
//alert(sqlInsert);
//	var sqlUpDate="UPDATE OPPLAN SET (OptNo='"+opordno+"',OperateName='"+opname+"',StartDate='"+opdate+"',StartTime='"+optime+"',OperateRoom='"+oproom+"',Opiumize='"+anmethod+"',PatientName='"+patname+"',PatientAge='"+age+"',PatientSex='"+sex+"',PatientBedNo='"+locrec+"',Patientzhuyuanhao='"+regno+"',PatientZhenDuan='"+diag+"',ZhuChiYiSheng='"+opdocdes+"',YiZhu='"+Lopdocdes1+"',ErZhu='"+Lopdocdes2+"',SanZhu='"+Lopdocdes3+"',MaYi='"+andoc+"',XiShou='"+scrubnurse+"',XunHui='"+circulnurse+"' where OperateCode='"+opaId+"')"
//alert(sqlUpDate);return;
	
	var i,objCheck,opaId,retStr=0,audited=false,objOproom;
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	var auditArrange=document.getElementById('AuditArrange').value;	
  	var rows=objtbl.rows.length;
 	for (var i=1;i<rows;i++)
 	{
 		var appStatus=document.getElementById("statusz"+i).innerText;
	 	objCheck=document.getElementById("SelItemz"+i);
 		if ((appStatus==t['val:apply'])&&(objCheck))
 		{
	 		opRoomDesc=""
	 		objOpRoom=document.getElementById("oproomz"+i);
	 		if (objOpRoom) opRoomDesc=objOpRoom.innerText;
	 		if (opRoomDesc==t['val:none']) continue;
	 		if (objCheck.checked==true){	
 				opaId=document.getElementById("opaIdz"+i).innerText;   //rowid
 				retStr=cspRunServerMethod(auditArrange,opaId);
 				if (retStr!=0) {alert(retStr);return;}
 				audited=true;
	 		}
 		}
 	}
    if ((retStr==0)&&(audited)) alert(t['alert:auditSuccess']);
    parent.frames[0].sendToScreen=true;
    self.location.reload();
 }	
//cjb add for 2007-06-11 big screen display dj070628
function InsertOptPlan_Click()
{
	var objtbl=document.getElementById('tUDHCANPATMAIN');	
  	var rows=objtbl.rows.length;
  	var Str="",displayed=false;
  	var IsUrgent=""
  	var InOPTempDataMethod=document.getElementById('InOPTempData').value;
  	var RepOPDataMethod=document.getElementById('RepOPData').value;
 	for (var i=1;i<rows;i++)
 	{
 		var status=document.getElementById("statusz"+i).innerText;
 		if (status==t['val:arrange'])
 		{
	 		var opaId=document.getElementById("opaIdz"+i).innerText;   //rowid
	 		var opname=document.getElementById("opnamez"+i).innerText;    //operation name
	 		var opdatetime=document.getElementById("opdatez"+i).innerText;
	 		var Lopdatetime=opdatetime.split(" ")
	 		//alert(opdatetime)
  			var opdate=Lopdatetime[0]
		    
		    
  		    //ypz 070721 begin
  			//var optime=Lopdatetime[1]      //time format need:8AM
  			var tmpList=Lopdatetime[1].split(":")
  			var optime="";
  			if (tmpList.length>0){
	  			if (tmpList[0]>12) {
		  			optime=tmpList[0]-12;
		  			optime=optime+"PM"
	  			}
	  			else optime=+tmpList[0]+"AM"
  			}
  			//ypz 070721 end	
  			
	 		var oproom=document.getElementById("oproomz"+i).innerText;		//perroom
	 		var anmethod=document.getElementById("anmethodz"+i).innerText;	//Anaest method
	 		var patname=document.getElementById("patnamez"+i).innerText;	//pat name
	 		var sex=document.getElementById("sexz"+i).innerText;			//sex
	 		var age=document.getElementById("agez"+i).innerText;			//age
	 		if (age)
	 		{var age=age.split("Y");
		 	 var age=age[0]
		 		}                //dj070629
	 		var opordno=document.getElementById("opordnoz"+i).innerText;	//oper room seq
	 		var regno=document.getElementById("regnoz"+i).innerText;		//regno
	 		var locs=document.getElementById("locz"+i).innerText;	
	 		var locarr=locs.split("-");
	        var locrec=locarr[1].split("/");    //loc bed
	        var diag=document.getElementById("diagz"+i).innerText;		//diag
	        var opdoc=document.getElementById("opdocz"+i).innerText;
	      	var opdocdes=opdoc.split(",");	 //oper doc,assist 1,2,3	var Lopdocdes=opdocdes[1].split(" ");
	 		var andoc=document.getElementById("andocz"+i).innerText;  //Anaest doc
	        var scrubnurse=document.getElementById("scrubnursez"+i).innerText;  //Scrub Nurse
	        var circulnurse=document.getElementById("circulnursez"+i).innerText;  //Circul nurse
	        var jzstat=document.getElementById("jzstatz"+i).innerText;   //if Emergency
	        if (jzstat==t['val:selDate'])
	        {IsUrgent="No"
	        }
	        if (jzstat==t['val:emergency'])
	        {IsUrgent="Yes"
	        }
	 		//Str=opaId+"^"+opname+"^"+opordno+"^"+opdate+"^"+optime+"^"+oproom+"^"+anmethod+"^"+patname+"^"+age+"^"+sex+"^"+locrec[1]+"^"+regno+"^"+diag+"^"+opdocdes[0]+"^"+Lopdocdes[1]+"^"+Lopdocdes[2]+"^"+Lopdocdes[3]+"^"+andoc+"^"+scrubnurse+"^"+circulnurse
	 		//alert(Str)
	 		/*//ypz for update//var RepFlag=cspRunServerMethod(RepOPDataMethod,opaId)
	 		if (RepFlag=="Y")
	 		{
		 		alert("already display  !"+opaId);
		 		return;
		 	}
	 		cspRunServerMethod(InOPTempDataMethod,opaId,Str)*/
	 		ConnSQLServer(opaId,opname,opordno,opdate,optime,oproom,anmethod,patname,age,sex,locrec[1],regno,diag,opdocdes[0],Lopdocdes[1],Lopdocdes[2],Lopdocdes[3],andoc,scrubnurse,circulnurse)
	 		displayed=true;
	 	}
	}
	if (displayed) alert(t['alert:ScreenDisplayed']);
}
function ConnSQLServer(opaId,opname,opordno,opdate,optime,oproom,anmethod,patname,age,sex,locrec,regno,diag,opdocdes,Lopdocdes1,Lopdocdes2,Lopdocdes3,andoc,scrubnurse,circulnurse)
{
    var sqlSelect="SELECT * FROM OPPLAN where OperateCode='"+opaId+"'"
//alert(sqlSelect);
	var sqlInsert="INSERT INTO OPPLAN(OperateCode,OptNo,OperateName,StartDate,StartTime,OperateRoom,Opiumize,PatientName,PatientAge,PatientSex,PatientBedNo,Patientzhuyuanhao,PatientZhenDuan,ZhuChiYiSheng,YiZhu,ErZhu,SanZhu,MaYi,XiShou,XunHui) VALUES ('"+opaId+"','"+opordno+"','"+opname+"','"+opdate+"','"+optime+"','"+oproom+"','"+anmethod+"','"+patname+"','"+age+"','"+sex+"','"+locrec+"','"+regno+"','"+diag+"','"+opdocdes+"','"+Lopdocdes1+"','"+Lopdocdes2+"','"+Lopdocdes3+"','"+andoc+"','"+scrubnurse+"','"+circulnurse+"')"
//alert(sqlInsert);
	var sqlUpdate="UPDATE OPPLAN SET OptNo='"+opordno+"',OperateName='"+opname+"',StartDate='"+opdate+"',StartTime='"+optime+"',OperateRoom='"+oproom+"',Opiumize='"+anmethod+"',PatientName='"+patname+"',PatientAge='"+age+"',PatientSex='"+sex+"',PatientBedNo='"+locrec+"',Patientzhuyuanhao='"+regno+"',PatientZhenDuan='"+diag+"',ZhuChiYiSheng='"+opdocdes+"',YiZhu='"+Lopdocdes1+"',ErZhu='"+Lopdocdes2+"',SanZhu='"+Lopdocdes3+"',MaYi='"+andoc+"',XiShou='"+scrubnurse+"',XunHui='"+circulnurse+"' where OperateCode='"+opaId+"'"
//alert(sqlUpdate);return;
	try
	{
	var ip="10.1.9.211"
	var usercode="sa"
	var userpass="123456"
	var objdbConn = new ActiveXObject("ADODB.Connection");
	var strdsn = "Driver={SQL Server};SERVER="+ip+";UID="+usercode+";PWD="+userpass+";DATABASE=OptPlan";
	//var strdsn="dsn=AHHF;uid=cydf;pwd=cydf;DATABASE=ahsl_jiaohao";
	//var strdsn = "Driver={MySQL ODBC 3.51 Driver};SERVER="+ip+";UID="+usercode+";PWD="+userpass+";DATABASE=范宏伟";
	/*//ypz for update//objdbConn.Open(strdsn);
	objdbConn.Execute(sqlInsert);
	objdbConn.Close();
	objdbConn=null;
	*/
	objdbConn.Open(strdsn);
	var rs=objdbConn.Execute(sqlSelect);
	if (rs.eof){objdbConn.Execute(sqlInsert);}
	else{objdbConn.Execute(sqlUpdate);}
	objdbConn.Close();
	objdbConn=null;
	}
	catch(e)
	{
		alert(e.message);
	}
}
function TranDat(day){
    var TWebDay
    switch (day){
		case "Monday":
		  	TWebDay=t['val:monday'];
		  	break;
		case "Tuesday":
		  	TWebDay=t['val:tuesday'];
		  	break;
		case "Wednesday":
		  	TWebDay=t['val:wednesday'];
		  	break;
		case "Thursday":
		  	TWebDay=t['val:thursday'];
		  	break;
		case "Friday":
		  	TWebDay=t['val:friday'];
		  	break;
		case "Saturday":
		  	TWebDay=t['val:saturday'];
		  	break;
		case "Sunday":
		  	TWebDay=t['val:sunday'];
		  	//break;
		}
    return TWebDay
}
function SelectAll_Click()
{
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tUDHCANPATMAIN');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('SelItemz'+i);  
	selobj.checked=obj.checked;  
	}
}

function AnAtOperation()
{
    var selrow=document.getElementById("selrow");
   
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";
    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }	//
    if (RowId=="") { alert(t[1]);  return;  }
  	if (selrow)
  	{	  
		/*for med doc check//if(document.getElementById("oprFloorz"+selrow.value))
		{
			var anNote=document.getElementById("oprFloorz"+selrow.value).innerText;
			//alert(anNote.length)
			if (anNote.length>4)
			{
				alert(anNote);
				//return;
			}
		}*/
  	}
    //var userId=session['LOGON.USERID'];
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	/*var curEPRObject = new ActiveXObject("ANMonLib.ANMonObject");	
	//alert(RowId+","+UserId+","+connectStr+","+false);
	curEPRObject.ShowANForm(opaId,userId,connectStr,false);*/
	//FormAna.SetVal(opaId, userId,connectStr,false);  
	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&opaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false;
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"AN";
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
	//window.open(lnk,"DHCAna","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,resizable=no,height=1024,width=1280,top=0,left=0");
	//var lnk= "http://127.0.0.1/trakcare/web/anop/DHCANDisplay.html";
	//window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,resizable=no,height=1024,width=1280,top=0,left=0");

}

function AnaesthesiaConsent()
{
    var selrow=document.getElementById("selrow");
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";

    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }
    if ((opaId==" ")||(opaId=="")) { alert(t[1]);  return;  }
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"AC";  
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
}

function PreOperativeAssessment()
{
    var selrow=document.getElementById("selrow");
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";

    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }
    if ((opaId==" ")||(opaId=="")) { alert(t[1]);  return;  }
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"AMT";  
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
}

function PostOperativeRecord()
{
    var selrow=document.getElementById("selrow");
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";
    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }
    if ((opaId==" ")||(opaId=="")) { alert(t[1]);  return;  }
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"PAV";  
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
}
function AnaestRecord()
{
    var selrow=document.getElementById("selrow");
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";
    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }
    if ((opaId==" ")||(opaId=="")) { alert(t[1]);  return;  }
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"ANI";  
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
}

function PACURecord()
{
    var selrow=document.getElementById("selrow");
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	//alert(Status)
	if ((Status!=t['val:PACU'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:PACU']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";
    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }
    if ((opaId==" ")||(opaId=="")) { alert(t[1]);  return;  }
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"PACU";  
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
}

function WatchOper()
{
    var selrow=document.getElementById("selrow");
   
   	if (selrow.value=="")  return;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:inRoom'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:inRoom']+","+t['val:leaveRoom']+","+t['val:finish']);
		return;
	}
    var str="";
    var opaId="";
    if (selrow.value!="")  {  opaId=document.getElementById("opaIdz"+selrow.value).innerText;  }	//
    if (RowId=="") { alert(t[1]);  return;  }
	var getConnectStr=document.getElementById("getConnectStr").value;
	var connectStr=cspRunServerMethod(getConnectStr);
	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&opaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+true;
	var userCTLOCId=session['LOGON.CTLOCID'];
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCICUDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+true+"&userCTLOCId="+userCTLOCId+"&documentType="+"AN";  
	showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");

}

function AnAfterOperation()
{
   /*
   var selrow=document.getElementById("selrow");
   var AdmInfo=document.getElementById("GetAdmInfo").value;
   var str="";
   var RowId="";
   if (selrow.value!="")
  {  
      RowId=document.getElementById("opaIdz"+selrow.value).innerText;
      str=cspRunServerMethod(AdmInfo,RowId);

  }	//
  if (str=="")
  {
   alert(t[1]);
   return;
  }
  var Res=str.split("^");
  var Adm=Res[0];
  var PatName=Res[2];
  var UserId=session['LOGON.USERID'];
  var curEPRObject = new ActiveXObject("EPRLib.EPRObject");	
  //alert(Adm+" "+ PatName+" "+RowId+" "+ UserId); 
//ypz 060116 start
  var SetAnInfoEmth=document.getElementById("SetAnaInfo").value;
  var ret=cspRunServerMethod(SetAnInfoEmth,UserId,RowId);
//ypz 060116 end
//
  curEPRObject.ShowANMONForm(Adm, PatName,RowId, UserId);
	 //Sub ShowANMONForm(ByVal paadm As String, ByVal patName As String, ByVal opeID As String, ByVal userID As String)
	//
	//var curEPRObject = new ActiveXObject("ANMonLib.ANMonObject");	
	//curEPRObject.ShowANForm("1", "1") ;	
	*/
}
function ShowInfectious()
{
    var i=0;
    var objtbl=document.getElementById('tUDHCANPATMAIN');
    //alert(objtbl.rows.length);
    for (i=1;i<objtbl.rows.length;i++)
	{
	   
	   var yy=document.getElementById("yyz"+i);

           var chkShowInfectious=document.getElementById('chkShowInfectious');
	  
	 if (chkShowInfectious.checked  == true)
         {
		yy.style.visibility  =  "visible";;
	    }
	  else
	 {
		yy.style.visibility   ="hidden" ;
	 }
	    
	}
}

function SetAnPara(lnk,nwin)
{
 	var opaId;
 	var selrow=document.getElementById("selrow");
 	if (selrow.value=="")  return;
 	//var flag=document.getElementById("flagz"+selrow.value).innerText;
	var Status=document.getElementById("statusz"+selrow.value).innerText;
	if (Status!=t['val:arrange']) {alert(t['alert:canOper']+t['val:arrange']);return;}

 	if (selrow.value!=""){opaId=document.getElementById("opaIdz"+selrow.value).innerText;}
  	else opaId="";
  	if (opaId=="")
  	{
   		alert(t['alert:selectOne']);
   		return;
  	}
   	var appType="RegOp";
   	lnk+="&ANPOPADr="+opaId+"&appType="+appType;
   	window.open(lnk,'_blank',nwin)
}

document.body.onload = BodyLoadHandler;


function SortListByCol(list,col,ascendBool)
{   //sort list by number col,ascendBool:ascend or descend order
	var tmpList=[],i,j;
	for (i=0;i<list.length-1;i++)
	{
	    for (j=i+1;j<list.length;j++)
	    {
		    if ((list[i][col]>list[j][col])==ascendBool)
		    {
		    	var tmpList=list[i];list[i]=list[j];list[j]=tmpList;
		    }		     
	    }
	}
}

function GetArrayIndex(varArray,val)
{
	for (i=0;i<varArray.length;i++)
	{
		if (varArray[i]==val) {return i;}
	}
	return -1;
}


function PrintApplyList()  //operation patient print,status:apply
{
	var fileName,path,i,j,tmpStr,retStr;
	var xlsExcel,xlsBook,xlsSheet;
	var row=1;
	var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	var tmpList=new Array();
     
	path=GetFilePath();
	fileName=path+"OpApplyList.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) ;
	xlsSheet = xlsBook.ActiveSheet;
	 
	var printObj=document.getElementById("getPrint");
	if (!printObj) return;
	var printStr=printObj.value;
	var strList=printStr.split("^")
	var printLen=strList.length;
	for (var i=0;i<printLen;i++)
	{
		xlsSheet.cells(1,i+1)=strList[i].split("!")[1];
	}
	
	//Get data
	var objtbl=document.getElementById('tUDHCANPATMAIN');
    myData=[];
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var stat=document.getElementById("statusz"+i).innerText;
		var sel=document.getElementById("SelItemz"+i);
		if ((stat==t['val:apply'])||(sel.checked==true))
		{	
			tmpList=[];
	    	for (j=0;j<printLen;j++)
	    	{   
	    	  	var colName=strList[j].split("!")[0];
	    	  	tmpStr=document.getElementById(colName+"z"+i).innerText;
	            tmpList[j]=tmpStr;	
			}
			myData[myData.length]=tmpList;
		}
	}

	 
	//sort 
	var col=GetArrayIndex(strList,t['val:orderItem']);
	
	var ascendBool=1;
	SortListByCol(myData,col,ascendBool);

     
	//output
	//alert("/");
	row=1
	for (var i=0;i<myData.length;i++)
	{
		row=row+1
		if(i>0)
		{
			//alert(myData[i][col].split("/")[0]+myData[i-1][col].split("/")[0]);
			if(myData[i][col].split("/")[0]!=myData[i-1][col].split("/")[0])
			{
				row=row+1;
			}
		}
		for(var j=0;j<printLen;j++)
		{
			//var colName=strList[j].split("!")[0];
			xlsSheet.cells(row,j+1)=myData[i][j];
		}
	}
	 
	var hospitalDesc=document.getElementById("hospital").value
	var CenterHeader = "&15"+hospitalDesc+t['val:operApplySheet']+"\r";
	var LeftHead="";
	titleRows=1;
	titleCols=1;
	RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	AddGrid(xlsSheet,0,0,row-1,printLen-1,1,1);
	FrameGrid(xlsSheet,0,0,row-1,printLen-1,1,1);
	//xlsExcel.Visible = true;
	//xlsSheet.PrintPreview;
	xlsSheet.PrintOut(); 
	xlsSheet = null;
 	xlsBook.Close(savechanges=false)
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}

function PrintSQD()  //print operation apply list
{
	PrintOPANList("SQD","N")
}

function PrintSSD()  //print operation arrange sheet list
{
	PrintOPANList("SSD","N")
}

function PrintMZD()  //print anaesthesia arrange sheet list
{
	PrintOPANList("MZD","N")
}

function PrintBBDJD()  //print lab specimen reg sheet
{
	PrintOPANList("BBDJD","N")
}
function ExportSSD()  //Export Data
{
	PrintOPANList("DCD","Y")
}

function PrintSSTZD()  //print single patient operation arrange sheet
{
	var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var path,fileName,fso;
    var objtbl=document.getElementById('tUDHCANPATMAIN');
    var GetQtPrintData=document.getElementById("GetQtPrintData").value;
    var curNum=0;
    path=GetFilePath();
    fileName=path+"SSTZD.xls";
    //fileName="C:\\SSTZD.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	var hospitalDesc=document.getElementById("hospital").value
   	for (i=1;i<objtbl.rows.length;i++)  
	{   
        var stat=document.getElementById("statusz"+i).innerText;
        var SelItem=document.getElementById("SelItemz"+i);
        if ((stat==t['val:arrange'])&&(SelItem.checked==true))
        { 
             var posRow,posCol,startRow,startCol;
             startRow=10*curNum;
             if ((curNum>=3)&&(curNum<=6)) {startCol=6;startRow=10*(curNum-3);}
             else startCol=1;
             //alert("curNum="+curNum +" "+ "startCol="+startCol);
             posRow=startRow+1;var row=posRow;
             posCol=startCol;var col=posCol;
             //alert("row="+row +" "+ "col="+col);
             mergcell(xlsSheet,row,col,col+3);
             xlcenter(xlsSheet,row,col,col+3);
             fontcell(xlsSheet,row,col,col,16);
             xlsSheet.cells(row,col)=hospitalDesc+t['val:operArrangeSheet'];
             
             var OperStartDate= parent.frames[0].document.getElementById("opdate").value
             var OperStartTime=document.getElementById("opdatez"+i).innerText;
             var OperRoom=document.getElementById("oproomz"+i).innerText;
             var PatLoc=document.getElementById("locz"+i).innerText;
             if (PatLoc.split("-").length>1) PatLoc=PatLoc.split("-")[0];
             var PatName=document.getElementById("patnamez"+i).innerText;
             var PatWard=document.getElementById("patWardz"+i).innerText; 
             if (PatWard.split("-").length>1) PatWard=PatWard.split("-")[1];
             var PatSex=document.getElementById("sexz"+i).innerText; 
             var PatAge=document.getElementById("agez"+i).innerText; 
             
             posRow=posRow+1;row=posRow;
             
             xlsSheet.cells(row,col)=t['val:operDate'];
  			 xlsSheet.cells(row,col+1)=OperStartDate;
  			 //xlsSheet.cells(row,col+2)="time";
  			 xlsSheet.cells(row,col+3)=OperStartTime;
  			 posRow=posRow+1;row=posRow;
             xlsSheet.cells(row,col)=t['val:operRoom'];
  			 xlsSheet.cells(row,col+1)=OperRoom;
  			 xlsSheet.cells(row,col+2)=t['val:loc'];
  			 xlsSheet.cells(row,col+3)=PatLoc;
  			 posRow=posRow+1;row=posRow;
             xlsSheet.cells(row,col)=t['val:name'];
             fontcell(xlsSheet,row,col+1,col+1,16);
  			 xlsSheet.cells(row,col+1)=PatName;
  			 xlsSheet.cells(row,col+2)=t['val:patWard'];
  			 fontcell(xlsSheet,row,col+3,col+3,16);
  			 xlsSheet.cells(row,col+3)=PatWard;
   			 posRow=posRow+1;row=posRow;
             xlsSheet.cells(row,col)=t['val:sex'];
  			 xlsSheet.cells(row,col+1)=PatSex;
  			 xlsSheet.cells(row,col+2)=t['val:age'];
  			 xlsSheet.cells(row,col+3)=PatAge;
  			 //alert("startRow="+startRow +" "+ "col="+col);
             AddOutFrame(xlsSheet,startRow+1,col,startRow+5,col+3)
             curNum=curNum+1;
             
        }
        //xlsSheet.PrintOut();
        if (curNum==6){
	 		curNum=0;
	 		xlsSheet.PrintOut();
	 		ClearContents(xlsSheet,"A1:I30");
	 		KillGrid(xlsSheet,1,1,30,9,1,1);
	 	}
	 	else {
		 	 if (i+1==objtbl.rows.length){
			 	xlsSheet.PrintOut();
			 }
		}
	}
	//xlsSheet.PrintOut(); 
	xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
function PrintOPANList(PrnTyp,ExportFlag)  //public operation print
{
	if (PrnTyp=="") return;
	var name,fileName,path,operStat,printTitle,operNum;
	var xlsExcel,xlsBook,xlsSheet;
	var row=3;
	var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	if (objtbl.rows.length<2) return;
	path=GetFilePath();
	var printTitleObj=document.getElementById("getPrintTile");
	if (printTitleObj){
		printTitle=cspRunServerMethod(printTitleObj.value,PrnTyp);
	}
	else {
		return;
	}
	var printStr=printTitle.split("!");
	if (printTitle.length<4) return;
	name=printStr[0];	
	fileName=printStr[1];
	fileName=path+fileName;
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) ;
	xlsSheet = xlsBook.ActiveSheet;
	operStat=printStr[2];
	var strList=printStr[3].split("^")
	var printLen=strList.length;
	for (var i=0;i<printLen;i++)
	{
		xlsSheet.cells(row,i+1)=strList[i].split("|")[0];
	}
	var row=3
	operNum=0;
	var chkSelPrint="N";
	var objChkSelPrint=document.getElementById("chkSelPrint");
	if((objChkSelPrint)&&(objChkSelPrint.checked==true)) chkSelPrint="Y";
	var preLoc="";
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var stat=document.getElementById("statusz"+i).innerText;
		var sel=document.getElementById("SelItemz"+i);
		if (((chkSelPrint=="N")&&((stat==operStat)||(operStat=="")))||((chkSelPrint=="Y")&&(sel.checked==true)))
		{
			row=row+1;
			operNum=operNum+1;
			//Sort by loc, insert empty row between different loc 
			var loc=document.getElementById("locz"+i).innerText;
			var locarr=loc.split("/");
			if (locarr.length>1) loc=locarr[0];
			/*if ((preLoc!="")&&(preLoc!=loc)){lhw20101217
				for(var j=0;j<printLen;j++){
					xlsSheet.cells(row,j+1)="";
				}
				row=row+1;
			}*/
			for(var j=0;j<printLen;j++)
			{
				var colName=strList[j].split("|")[1];
				var objColName=document.getElementById(colName+"z"+i);
				if (objColName){
					if ((colName=="oproom")||(colName=="opordno")){
						if ((objColName.value==t['val:none'])||(objColName.value==t['val:unarrange'])){
							xlsSheet.cells(row,j+1)="";
						}
						else {
							xlsSheet.cells(row,j+1)=objColName.value;	
						}
		   			}
	   				else if(colName=="opname")
	   				{
		   				var colName=objColName.innerText;
		   				var opname=colName.split(";");
		   				var colNameLen=colName.length;
		   				var firstnameLen=opname[0].length;
		   				xlsSheet.cells(row,j+1).FormulaR1C1=objColName.innerText;
		   				xlsSheet.cells(row,j+1).Characters(1,firstnameLen).Font.Name="宋体";
		   				xlsSheet.cells(row,j+1).Characters(firstnameLen+2,colNameLen-firstnameLen).Font.Italic=true;
		   				//xlsSheet.cells(row,j+1).Characters(1,firstnameLen).Font.Italic=true;
	   				}
		   			else {	
						xlsSheet.cells(row,j+1)=objColName.innerText;
		   			}
				}
				else {
				    xlsSheet.cells(row,j+1)="";
				}
			}
			preLoc=loc;
		}
	}
	PrintTitle(xlsSheet,PrnTyp,printStr,operNum);
	titleRows=3;
	titleCols=1;
	LeftHeader = " ",CenterHeader = " ",RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = " &N - &P ";
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	AddGrid(xlsSheet,3,0,row,printLen-1,3,1);
	FrameGrid(xlsSheet,3,0,row,printLen-1,3,1);
	if (ExportFlag=="N")
	{
		 //xlsExcel.Visible = true;
		 //xlsSheet.PrintPreview;
		 xlsSheet.PrintOut(); 
	}
	else  {
		if (ExportFlag=="Y"){
			var savefileName="C:\\Documents and Settings\\";
			var objGetExportParth=document.getElementById("GetExportParth");
    		if (objGetExportParth) savefileName=objGetExportParth.value;
			var d = new Date();
   	 		savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xls"
    		xlsSheet.SaveAs(savefileName);	
		}	
	}
	xlsSheet = null;
 	xlsBook.Close(savechanges=false)
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}
function PrintTitle(objSheet,PrnTyp,printStr,operNum)
{
	var sheetName=printStr[0];	
	var setList=printStr[3].split("^")
	var colnum=setList.length;
	var hospitalDesc=document.getElementById("hospital").value
	mergcell(objSheet,1,1,colnum);
    xlcenter(objSheet,1,1,colnum);
    fontcell(objSheet,1,1,colnum,16);
    objSheet.cells(1,1)=hospitalDesc+sheetName;
	var OperStartDate= parent.frames[0].document.getElementById("opdate").value;
	var tmpOperStartDate=OperStartDate.split("/");
    if (tmpOperStartDate.length>2) OperStartDate=tmpOperStartDate[2]+" 年 "+tmpOperStartDate[1]+" 月 "+tmpOperStartDate[0]+" 日";
	mergcell(objSheet,2,1,colnum);
    fontcell(objSheet,2,1,colnum,10);
	objSheet.cells(2,1)=OperStartDate;
	if (PrnTyp=="SSD") objSheet.cells(2,1)=OperStartDate+"                    "+t['val:totalOperation']+" "+operNum;
	if (PrnTyp=="MZD") objSheet.cells(2,1)=OperStartDate;
}
function SeqNoOnKeyDown()
{
	if (event.keyCode==13)
	{
    	var eSrc=window.event.srcElement;
    	var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
    	if (eSrc.value!="")
    	{
	    	var opaSeqNo=eSrc.value
    		var opaIdObj=document.getElementById("opaIdz"+selectrow)
    		if(opaIdObj) var opaId=opaIdObj.innerText;
    		else var opaId=""
   			var updateOpaSeqNoObj=document.getElementById("UpdateOpaSeqNo")
   			if(updateOpaSeqNoObj)
   			{
	   			var updateOpaSeqNo=updateOpaSeqNoObj.value;
		   		var resStr=cspRunServerMethod(updateOpaSeqNo,opaId,opaSeqNo,opdateDate)
		   		if(resStr!="") 
		   		{
			   		alert(resStr);
			   		eSrc.value="";
		   		}
		   		//else self.location.reload();
   			}
		}
	}  
}

function ScrNurOnKeyDown()
{	
	if ((event.keyCode==13)||(event.keyCode==0))  //1
	{   
		var eSrc=window.event.srcElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;	
		var scrubnurse=eSrc.value;
		//alert(scrubnurse)
		var retStrNur="";
		if(scrubnurse.length==1)
		{
			alert("请检查输入!");
		}
		else  //2
		{
		    for(var j=0;j<scrubnurse.split(" ").length;j++)
		    {   
			    var devNurse=scrubnurse.split(" ")[j];
			    var GetIdByDescOrAlias=document.getElementById("GetIdByDescOrAlias").value;
				var retStr=cspRunServerMethod(GetIdByDescOrAlias,devNurse);
				if(retStr!="")
				{
					if(retStrNur=="") retStrNur=retStr;
					else retStrNur=retStrNur+";"+retStr;
				}
			}
			var devNurDescStr="",devNurIdStr="";
			if(retStrNur!="")
			{
				for(var i=0;i<retStrNur.split(";").length;i++)
				{
					var nurDescAndId=retStrNur.split(";")[i];
					if(devNurDescStr=="") devNurDescStr=nurDescAndId.split("^")[0];
					else devNurDescStr=devNurDescStr+" "+nurDescAndId.split("^")[0];
					if(devNurIdStr=="") devNurIdStr=nurDescAndId.split("^")[1];
					else devNurIdStr=devNurIdStr+"^"+nurDescAndId.split("^")[1];
				}
			}			
			//var roomId=document.getElementById("opRoomIdz"+selectrow).value;
			var opId=document.getElementById("opaIdz"+selectrow).innerText;
			var GetRoomIdByOpaId=document.getElementById("GetRoomIdByOpaId").value;
			var retStrRoomIdAndSeq=cspRunServerMethod(GetRoomIdByOpaId,opId);
			if(retStrRoomIdAndSeq=="")
			{
				alert("提交失败,请刷新界面.未安排手术间或台次");
				return;
			}
			else
			{
			var roomId=retStrRoomIdAndSeq.split("^")[0];
			var andocid="",ctcpAnDocO="",ctcpAnDocJ="",ansupervisid="",anNur="",ctcpDevNurJ="",ctcpTourNur="",ctcpTourNurJ="",anDocNote="";
			//var opordno=document.getElementById("opordnoz"+selectrow).value;
				//document.getElementById("scrubnursez"+selectrow).value=devNurDescStr;
				if(devNurDescStr!=scrNurStr)
				{
				var UpdateANArr=document.getElementById("UpdateANArr").value;
				//if(devNurIdStr=="") return;
				var retStrArr=cspRunServerMethod(UpdateANArr,roomId,opId,andocid,ctcpAnDocO,ctcpAnDocJ,ansupervisid,anNur,devNurIdStr,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,anDocNote,opdateDate,"ND");
				//alert(retStrArr);
				if(retStrArr!="")
				{
					alert(retStrArr+"-3");
					document.getElementById("scrubnursez"+selectrow).value="";
					//self.location.reload();
				}
				else 
				{   
					var UpdateAllArrObj=document.getElementById("UpdateAllOpArr");
					if(UpdateAllArrObj)
					{   
						var UpdateAllOpArr=UpdateAllArrObj.value;
						var retStrAllArr=cspRunServerMethod(UpdateAllOpArr,roomId,opId,opdateDate);
						//alert(retStrAllArr);
						if(retStrAllArr!="0")
						{
							alert(retStrAllArr+"-4");
							document.getElementById("scrubnursez"+selectrow).value="";
							//self.location.reload();
						}
						else
						{   alert("安排成功?")
							document.getElementById("scrubnursez"+selectrow).value=devNurDescStr;
						}
					}
				}
				}
				else
				{
					document.getElementById("scrubnursez"+selectrow).value=devNurDescStr;
				}
			}
		}  //2
	}  //1
}
function CirNurOnKeyDown()
{
	if ((event.keyCode==13)||(event.keyCode==0))  //1
	{
    	var eSrc=window.event.srcElement;
    	var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
	    var circulnurse=eSrc.value;
	    var retStrNur="";
	    if(circulnurse.length==1)
		{
			alert("请检查输入!");
		}
		else  //2
		{
	    	for(var j=0;j<circulnurse.split(" ").length;j++)
	    	{
		    	var tourNurse=circulnurse.split(" ")[j];
		    	var GetIdByDescOrAlias=document.getElementById("GetIdByDescOrAlias").value;
				var retStr=cspRunServerMethod(GetIdByDescOrAlias,tourNurse);
				if(retStr!="")
				{
					if(retStrNur=="") retStrNur=retStr;
					else retStrNur=retStrNur+";"+retStr;
				}
				//else retStrNur=""
		    }
			var tourNurDescStr="",tourNurIdStr="";
			if(retStrNur!="")
			{
				for(var i=0;i<retStrNur.split(";").length;i++)
				{
					var nurDescAndId=retStrNur.split(";")[i];
					if(tourNurDescStr=="") tourNurDescStr=nurDescAndId.split("^")[0];
					else tourNurDescStr=tourNurDescStr+" "+nurDescAndId.split("^")[0];
					if(tourNurIdStr=="") tourNurIdStr=nurDescAndId.split("^")[1];
					else tourNurIdStr=tourNurIdStr+"^"+nurDescAndId.split("^")[1];
				}
			}
			//var roomId=document.getElementById("opRoomIdz"+selectrow).value;
			var opId=document.getElementById("opaIdz"+selectrow).innerText;
			var GetRoomIdByOpaId=document.getElementById("GetRoomIdByOpaId").value;
			var retStrRoomIdAndSeq=cspRunServerMethod(GetRoomIdByOpaId,opId);
			if(retStrRoomIdAndSeq=="")
			{
				alert("提交失败?请刷新界面?手术间或台次未安排");
				return;
			}
			else
			{
			var roomId=retStrRoomIdAndSeq.split("^")[0];
			var andocid="",ctcpAnDocO="",ctcpAnDocJ="",ansupervisid="",anNur="",ctcpDevNur="",ctcpDevNurJ="",ctcpTourNurJ="",anDocNote="";
				//document.getElementById("circulnursez"+selectrow).value=tourNurDescStr;	
				if(tourNurDescStr!=cirNurStr)
				{
				var UpdateANArr=document.getElementById("UpdateANArr").value;
				//if(tourNurIdStr=="") return;
				var retStrArr=cspRunServerMethod(UpdateANArr,roomId,opId,andocid,ctcpAnDocO,ctcpAnDocJ,ansupervisid,anNur,ctcpDevNur,ctcpDevNurJ,tourNurIdStr,ctcpTourNurJ,anDocNote,opdateDate,"NT");
				//alert(retStrArr);
				if(retStrArr!="")
				{
					alert(retStrArr+"-1");
					document.getElementById("circulnursez"+selectrow).value="";
					//self.location.reload();
				}
				else 
				{
					var UpdateAllArrObj=document.getElementById("UpdateAllOpArr");
					if(UpdateAllArrObj)
					{
						var UpdateAllOpArr=UpdateAllArrObj.value;
						var retStrAllArr=cspRunServerMethod(UpdateAllOpArr,roomId,opId,opdateDate);
						if(retStrAllArr!="0")
						{
							alert(retStrAllArr+"-2");
							document.getElementById("circulnursez"+selectrow).value="";
							//self.location.reload();
						}
						else
						{   
						    alert("安排成功?")
							document.getElementById("circulnursez"+selectrow).value=tourNurDescStr;
						}
					}
				}
				}
				else
				{
					document.getElementById("circulnursez"+selectrow).value=tourNurDescStr;
				}
			}
		}  //2
	}  //1
}
function AnDocAssOnKeyDown()
{
	if ((event.keyCode==13)||(event.keyCode==0))  //1
	{
    	var eSrc=window.event.srcElement;
    	var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
	    var anDocAssSrc=eSrc.value;
	    var retStrAss="";
	    if(anDocAssSrc.length==1)
		{
			alert("请检查输入!");
		}
		else  //2
		{
	    	for(var j=0;j<anDocAssSrc.split(" ").length;j++)
	    	{
		    	var anDocAss=anDocAssSrc.split(" ")[j];
		    	var GetIdByDescOrAlias=document.getElementById("GetIdByDescOrAlias").value;
				var retStr=cspRunServerMethod(GetIdByDescOrAlias,anDocAss);
				if(retStr!="")
				{
					if(retStrAss=="") retStrAss=retStr;
					else retStrAss=retStrAss+";"+retStr;
				}
				//else retStrAss=""
		    }
			var anDocAssDescStr="",anDocAssIdStr="";
			if(retStrAss!="")
			{
				for(var i=0;i<retStrAss.split(";").length;i++)
				{
					var assDescAndId=retStrAss.split(";")[i];
					if(anDocAssDescStr=="") anDocAssDescStr=assDescAndId.split("^")[0];
					else anDocAssDescStr=anDocAssDescStr+" "+assDescAndId.split("^")[0];
					if(anDocAssIdStr=="") anDocAssIdStr=assDescAndId.split("^")[1];
					else anDocAssIdStr=anDocAssIdStr+"^"+assDescAndId.split("^")[1];
				}
			}
			//var roomId=document.getElementById("opRoomIdz"+selectrow).value;
			var opId=document.getElementById("opaIdz"+selectrow).innerText;
			var GetRoomIdByOpaId=document.getElementById("GetRoomIdByOpaId").value;
			var retStrRoomIdAndSeq=cspRunServerMethod(GetRoomIdByOpaId,opId);
			if(retStrRoomIdAndSeq=="")
			{
				alert("提交失败,请刷新界面,未安排手术间或台次");
				return;
			}
			else
			{
			var roomId=retStrRoomIdAndSeq.split("^")[0];
			var andocid="",ctcpAnDocJ="",ansupervisid="",anNur="",ctcpDevNur="",ctcpDevNurJ="",ctcpTourNur="",ctcpTourNurJ="",anDocNote="";
				//document.getElementById("circulnursez"+selectrow).value=tourNurDescStr;	
				if(anDocAssDescStr!=anDocAssStr)
				{
				var UpdateANArr=document.getElementById("UpdateANArr").value;
				//if(tourNurIdStr=="") return;
				var retStrArr=cspRunServerMethod(UpdateANArr,roomId,opId,andocid,anDocAssIdStr,ctcpAnDocJ,ansupervisid,anNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,anDocNote,opdateDate,"DO");
				//alert(retStrArr);
				if(retStrArr!="")
				{
					alert(retStrArr+"-1");
					document.getElementById("tAnDocAssz"+selectrow).value="";
					self.location.reload();
				}
				else 
				{
					var UpdateAllArrObj=document.getElementById("UpdateAllOpArr");
					if(UpdateAllArrObj)
					{
						var UpdateAllOpArr=UpdateAllArrObj.value;
						var retStrAllArr=cspRunServerMethod(UpdateAllOpArr,roomId,opId,opdateDate);
						if(retStrAllArr!="0")
						{
							alert(retStrAllArr+"-2");
							document.getElementById("tAnDocAssz"+selectrow).value="";
							self.location.reload();
						}
						else
						{   
						    alert("安排成功?")
							document.getElementById("tAnDocAssz"+selectrow).value=anDocAssDescStr;
						}
					}
				}
				}
				else
				{
					document.getElementById("tAnDocAssz"+selectrow).value=anDocAssDescStr;
				}
			}
		}  //2
	}  //1
}
function combo_andocListKeyenterhandler()
{
	if(window.event)
	{
		var eSrc=window.event.srcElement
		if(eSrc)
		{
			var eSrcName=eSrc.name;
			if(eSrcName) 
			{
				var selRow=eSrcName.replace("andocz","")
				var selrowObj=document.getElementById("selrow");
				if(selrowObj) selrowObj.value=selRow;
			}
		}
	}
}

function combo_andocListKeydownhandler()
{
	
	var eSrc=window.event.srcElement;
	var eSrcName=eSrc.name;
	var selrowObj=document.getElementById("selrow");
	if(selrowObj) var selectRow=selrowObj.value;
	else var selectRow=""
	if(selectRow=="")
	{
		alert(t['alert:selectOne']);
	}
	else
	{
		var andocId=combo_andocList[selectRow].getActualValue();
    	var andocDescOld=document.getElementById("andocz"+selectRow).value;
		var Status=document.getElementById("statusz"+selectRow).innerText;
		if ((Status!=t['val:arrange'])&&(Status!=t['val:apply'])) {
			alert(t['alert:canOper']+t['val:arrange']+","+t['val:apply']);
			combo_andocList[selectRow].closeAll();
			document.getElementById("andocz"+selectRow).value=andocDescOld;
			return;
		}
	}			
	 var opdatestr=document.getElementById("opdatestrz"+selectRow).innerText;
	 var Lopopdatestr=opdatestr.split(" ");
     opdateDate=Lopopdatestr[0];
     var opIdObj=document.getElementById("opaIdz"+selectRow);
     if(opIdObj) var opId=opIdObj.innerText;
     else var opId=""
     if (opId=="")
  	 {
   		alert(t['alert:selectOne']);
   		return;
  	 }
	
	 var GetRoomIdByOpaId=document.getElementById("GetRoomIdByOpaId").value;
	 var retStrRoomIdAndSeq=cspRunServerMethod(GetRoomIdByOpaId,opId);
	 if(retStrRoomIdAndSeq=="")
     {
       alert("提交失败,请刷新界面.未安排手术间或台次!");
       return;
     }
     else
     {
        var roomId=retStrRoomIdAndSeq.split("^")[0];
        var ctcpAnDocO="",ctcpAnDocJ="",ansupervisid="",anNur="",ctcpDevNur="",ctcpDevNurJ="",ctcpTourNur="",ctcpTourNurJ="",anDocNote="";
        var opordno=document.getElementById("opordnoz"+selectRow).value;
        if(opordno!="未排")
      {	
        var UpdateANArr=document.getElementById("UpdateANArr").value;
        var retStrArr=cspRunServerMethod(UpdateANArr,roomId,opId,andocId,ctcpAnDocO,ctcpAnDocJ,ansupervisid,anNur,ctcpDevNur,ctcpDevNurJ,ctcpTourNur,ctcpTourNurJ,anDocNote,opdateDate,"DA");
        if(retStrArr!="")
        {
           alert(retStrArr);
           document.getElementById("andocz"+selectrow).value="";
           self.location.reload();
        }
     else 
     {
       var UpdateAllArrObj=document.getElementById("UpdateAllOpArr");
       if(UpdateAllArrObj)
       {
         var UpdateAllOpArr=UpdateAllArrObj.value;
         var retStrAllArr=cspRunServerMethod(UpdateAllOpArr,roomId,opId,opdateDate);
         if(retStrAllArr!="0")
         {
          alert(retStrAllArr);
          document.getElementById("andocz"+selectrow).value="";
          //self.location.reload();
         }
       }
	}
	}
  else
   {
      alert("该手术未安排!");
      document.getElementById("andocz"+selectrow).value="";
   }
		} 
} 


//ck 091112
function combo_opaSeqListKeyenterhandler()
{
	if(window.event)
	{
		var eSrc=window.event.srcElement
		if(eSrc)
		{
			var eSrcName=eSrc.name;
			if(eSrcName) 
			{
				var selRow=eSrcName.replace("opordnoz","")
				var selrowObj=document.getElementById("selrow");
				if(selrowObj) selrowObj.value=selRow;
			}
		}
	}
}
function combo_opaSeqListKeydownhandler()
{
	var eSrc=window.event.srcElement;
	var eSrcName=eSrc.name;
	var selrowObj=document.getElementById("selrow");
	if(selrowObj) var selectRow=selrowObj.value;
	else var selectRow=""
	if(selectRow=="")
	{
		alert(t['alert:selectOne']);
	}
	else
	{
		var opaSeqNo=combo_opaSeqList[selectRow].getActualValue();
    	var opaSeqNoOld=document.getElementById("opordnoz"+selectRow).value;
		var Status=document.getElementById("statusz"+selectRow).innerText;
		if ((Status!=t['val:arrange'])&&(Status!=t['val:apply'])) {
			alert(t['alert:canOper']+t['val:arrange']+","+t['val:apply']);
			combo_opaSeqList[selectRow].closeAll();
			document.getElementById("opordnoz"+selectRow).value=opaSeqNoOld;
			return;
		}
	    var opdatestr=document.getElementById("opdatestrz"+selectRow).innerText;
		var Lopopdatestr=opdatestr.split(" ");
    	opdateDate=Lopopdatestr[0];
    	var opaIdObj=document.getElementById("opaIdz"+selectRow);
    	if(opaIdObj) var opaId=opaIdObj.innerText;
    	else var opaId=""
    	if (opaId=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
   		var updateOpaSeqNoObj=document.getElementById("UpdateOpaSeqNo");
   		if(updateOpaSeqNoObj)
   		{
	   		var updateOpaSeqNo=updateOpaSeqNoObj.value;
		   	var resStr=cspRunServerMethod(updateOpaSeqNo,opaId,opaSeqNo,opdateDate);
		   	if(resStr!="") 
		   	{
			   	combo_opaSeqList[selectRow].closeAll();
			   	if(opaSeqNoOld=="未排")
			   	{combo_opaSeqList[selectRow].DOMelem_hidden_input.value="";}
			   	//combo_opaSeqList[selectRow].unSelectOption();
			    document.getElementById("opordnoz"+selectRow).value=opaSeqNoOld;
			   	var index=combo_opaSeqList[selectRow].getIndexByValue(opaSeqNoOld)
			   	combo_opaSeqList[selectRow].selectOption(index)
			   	alert(resStr);
			   	return;
			   	//alert(combo_opaSeqList[selectRow].getActualValue())
			   	
		   	}
		   	else
		   	{
			   	if(opaSeqNo==1)
			   	{
				   	document.getElementById("opdatez"+selectRow).innerText="8:30";
				}
				else
				{
			   		document.getElementById("opdatez"+selectRow).innerText="接台"+(opaSeqNo-1);
				}
				var RowObj=getRow(eSrc);
				document.getElementById("statusz"+selectRow).innerText=t['val:arrange'];    ///"安排"
				RowObj.className="Immediate";
				return;
		   	}
   		}
	}
}//ck 091112
function combo_RoomListKeyenterhandler()
{   
	if(window.event)
	{
		var eSrc=window.event.srcElement
		if(eSrc)
		{
			var eSrcName=eSrc.name;
			if(eSrcName) 
			{
				var selRow=eSrcName.replace("oproomz","")
				var selrowObj=document.getElementById("selrow");
				if(selrowObj) selrowObj.value=selRow;
			}
		}
	}
}
function combo_RoomListKeydownhandler()
{   
	var eSrc=window.event.srcElement;
	var eSrcName=window.event.srcElement.name;
	var selrowObj=document.getElementById("selrow");
	if(selrowObj) var selectRow=selrowObj.value;
	else var selectRow=""
	if(eSrcName)
	{
		if(selectRow=="") var selectRow=eSrcName.replace("oproomz","")
	}
	if(selectRow=="")
	{
		alert("Please select a row!");
	}
	else
	{
		var roomId=combo_RoomList[selectRow].getActualValue();
		var roomText=document.getElementById("oproomz"+selectRow).value;
		var Status=document.getElementById("statusz"+selectRow).innerText;
		if ((Status!=t['val:arrange'])&&(Status!=t['val:apply'])) {
			alert(t['alert:canOper']+t['val:arrange']+","+t['val:apply']);
			combo_RoomList[selectRow].closeAll();
			document.getElementById("oproomz"+selectRow).value=roomText;
			return;
		}
		var opdatestr=document.getElementById("opdatestrz"+selectRow).innerText;
		var Lopopdatestr=opdatestr.split(" ");
    	opdateDate=Lopopdatestr[0];
		
		var opaId=document.getElementById("opaIdz"+selectRow).innerText;
		if (opaId=="")
  		{
   			alert(t['alert:selectOne']);
   			return;
  		}
  		var opaSeqNo=combo_opaSeqList[selectRow].getActualValue();
  		//alert(opaSeqNo)
  		var GetFlagRoomSeqNoObj=document.getElementById("GetFlagRoomSeqNo")
  		if(GetFlagRoomSeqNoObj)
  		{GetFlagRoomSeqNo=GetFlagRoomSeqNoObj.value;}
  		var ret0=cspRunServerMethod(GetFlagRoomSeqNo,roomId,opaSeqNo,opdateDate)
  		if(ret0==1)
  		{alert(t['alert:opSeqRepeat'])
  		 combo_RoomList[selectRow].closeAll();
  		 self.location.reload();
         return;
        }
		var updateANOpArr=document.getElementById("UpdateANOpArr").value;
		var retStr=cspRunServerMethod(updateANOpArr,roomId,opaId,opdateDate,"N");
		if(retStr!="0") 
		{
			alert(retStr);
			self.location.reload();
		}
		else
		{
			var opaSeqNo="";
			var opordnoStr=document.getElementById("opordnoz"+selectRow).value;
			if(opordnoStr!="未排")
			{
				var updateOpaSeqNoObj=document.getElementById("UpdateOpaSeqNo");
	   			if(updateOpaSeqNoObj)
	   			{
		   			var updateOpaSeqNo=updateOpaSeqNoObj.value;
			   		var resStr=cspRunServerMethod(updateOpaSeqNo,opaId,opaSeqNo,opdateDate);
			   		if(resStr!="") 
			   		{
				   		//alert(resStr);
				   		combo_RoomList[selectRow].closeAll();
				   		return;
				   		alert(1)
			   		}
			   		else
			   		{   alert(2)
				   		document.getElementById("opordnoz"+selectRow).value="未排";
				   		document.getElementById("opdatez"+selectRow).innerText=opdateNoSeq;
				   		var RowObj=getRow(eSrc);
				   		document.getElementById("statusz"+selectRow).innerText=t['val:apply'];  ///"未排"
				   		RowObj.className="LongNew";
				   		combo_RoomList[selectRow].closeAll();
				   		return;
			   		}
	   			}
   			}
			//return;
			//self.location.reload();
		}
	}
}
function TimeCalculation_Click()
{
	var rowIdStr=""
	var opaIdStr=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		if (sel.checked==true)
		{
			var objOpaId=document.getElementById("opaIdz"+i);
			if(objOpaId) 
			{
				var opaId=objOpaId.innerText;
				if(rowIdStr=="") rowIdStr=i;
				else rowIdStr=rowIdStr+"^"+i;
				if(opaIdStr=="") opaIdStr=opaId
				else opaIdStr=opaIdStr+"^"+opaId
			}
		}
	}

	var objGetArrangeTime=document.getElementById("GetArrangeTime")
	if(objGetArrangeTime)
	{
		GetArrangeTime=objGetArrangeTime.value;
		if((opaIdStr!="")&(rowIdStr!=""))
		{
			var retStr=cspRunServerMethod(GetArrangeTime,rowIdStr,opaIdStr);
			if(retStr!="") alert(retStr)
			var objSaveOpTime=document.getElementById("SaveOpTime")
			if(objSaveOpTime) objSaveOpTime.disabled=false;
		}
	}
}
function SetTableElementValue(elementName,str)
{
	var obj=document.getElementById(elementName)
	if(obj)
	{
		obj.innerText=str;
	}
}
function SaveOpTime_Click()
{
	var rowIdStr=""
	var opaIdStr=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		if (sel.checked==true)
		{
			var objOpaId=document.getElementById("opaIdz"+i);
			if(objOpaId) 
			{
				var opaId=objOpaId.innerText;
				if(rowIdStr=="") rowIdStr=i;
				else rowIdStr=rowIdStr+"^"+i;
				if(opaIdStr=="") opaIdStr=opaId
				else opaIdStr=opaIdStr+"^"+opaId
			}
		}
	}

	var objUpdateArrangeTime=document.getElementById("UpdateArrangeTime")
	if(objUpdateArrangeTime)
	{
		UpdateArrangeTime=objUpdateArrangeTime.value;
		if((opaIdStr!="")&(rowIdStr!=""))
		{
			var retStr=cspRunServerMethod(UpdateArrangeTime,rowIdStr,opaIdStr);
			if(retStr!="") alert(retStr)
			else self.location.reload();
		}
	}
}
function Arrange_Click()
{
	var opaIdStr=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		var stat=document.getElementById("statusz"+i).innerText;
		if ((stat!=t['val:arrange'])&&(sel.checked==true))
		{
			var objOpaId=document.getElementById("opaIdz"+i);
			if(objOpaId) 
			{
				var opaId=objOpaId.innerText;
				if(opaIdStr=="") opaIdStr=opaId
				else opaIdStr=opaIdStr+"^"+opaId
			}
		}
	}
	var obj=document.getElementById("UpdateAnOpStatus")
	if(obj)
	{
		var UpdateAnOpStatus=obj.value;
		if(opaIdStr!="")
		{
			var retStr=cspRunServerMethod(UpdateAnOpStatus,opaIdStr,"R");
			if(retStr=="0") self.location.reload();
			else alert(retStr)
		}
	}	
}
function Leave_Click()
{
	var opaIdStr=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		var stat=document.getElementById("statusz"+i).innerText;
		if ((stat==t['val:inRoom'])&&(sel.checked==true))
		{
			var objOpaId=document.getElementById("opaIdz"+i);
			if(objOpaId) 
			{
				var opaId=objOpaId.innerText;
				if(opaIdStr=="") opaIdStr=opaId
				else opaIdStr=opaIdStr+"^"+opaId
			}
		}
		
		if((stat!=t['val:inRoom'])&&(sel.checked==true))
		{ 
		   alert(t['alert:canOper']+t['val:inRoom'])
		   return;
		}
	}
	var obj=document.getElementById("UpdateAnOpStatus")
	if(obj)
	{
		var UpdateAnOpStatus=obj.value;
		if(opaIdStr!="")
		{
			var retStr=cspRunServerMethod(UpdateAnOpStatus,opaIdStr,"L");
			if(retStr=="0") self.location.reload();
			else alert(retStr)
		}
	}	
}
function Resume_Click()
{
    var opaIdStr=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		var stat=document.getElementById("statusz"+i).innerText;
		if (((stat==t['val:inRoom'])||(stat==t['val:leaveRoom']))&&(sel.checked==true))
		{
			var objOpaId=document.getElementById("opaIdz"+i);
			if(objOpaId) 
			{
				var opaId=objOpaId.innerText;
				if(opaIdStr=="") opaIdStr=opaId
				else opaIdStr=opaIdStr+"^"+opaId
			}
		}
		if((stat!=t['val:inRoom'])&&(stat!=t['val:leaveRoom'])&&(sel.checked==true))
		{
			alert(t['alert:canOper']+t['val:inRoom']+","+t['val:leaveRoom']);
			return;
		}	
	}
	var obj=document.getElementById("UpdateAnOpStatus")
	if(obj)
	{
		var UpdateAnOpStatus=obj.value;
		if(opaIdStr!="")
		{
			var retStr=cspRunServerMethod(UpdateAnOpStatus,opaIdStr,"P");
			if(retStr=="0") self.location.reload();
			else alert(retStr)
		}
	}		
}
function InRoom_Click()
{
	var opaIdStr=""
	var opRoomIdStr=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	for (var i=1;i<objtbl.rows.length;i++)
	{   
		var sel=document.getElementById("SelItemz"+i);
		var stat=document.getElementById("statusz"+i).innerText;
		var objOpRoomId=document.getElementById("opRoomIdz"+i);
		if(objOpRoomId) {var opRoomId=objOpRoomId.value}
		if ((stat==t['val:arrange'])&&(sel.checked==true)&&(opRoomId!=""))
		{   
		   
			var objOpaId=document.getElementById("opaIdz"+i);
			if(objOpaId)
			{
				var opaId=objOpaId.innerText;
				if(opaIdStr=="")opaIdStr=opaId;
				else opaIdStr=opaIdStr+"^"+opaId;
			}
			
			if(opRoomIdStr=="")opRoomIdStr=opRoomId;
			else opRoomIdStr=opRoomIdStr+"^"+opRoomId;
		}
		if((stat!=t['val:arrange'])&&(sel.checked==true))
		{
			alert(t['alert:canOper']+t['val:arrange'])
			return;
		}
		if((opRoomId=="")&&(sel.checked==true))alert("shoushujianweikongdeshoushubunengzhuanweishuzhong")
	}	
		var objGetEditStatus=document.getElementById("GetEditStat")
		if(objGetEditStatus)
		{
			var GetEditStatus=objGetEditStatus.value;
			if(opaIdStr!=""&&opRoomIdStr!="")
			{
				var retStr=cspRunServerMethod(GetEditStatus,opaIdStr,opRoomIdStr);
				if(retStr!="1")
				{
					alert(retStr);
					return;
				}
			}
		}
		var obj=document.getElementById("UpdateAnOpStatus")
	   if(obj)
	   {
		   var UpdateAnOpStatus=obj.value;
		   if((opaIdStr!="")&&(opRoomIdStr!=""))
		 {
			var retStr=cspRunServerMethod(UpdateAnOpStatus,opaIdStr,"I");
			if(retStr=="0") self.location.reload();
			else alert(retStr)
		 }	
	    }		
}

function ANChargeInWeb()
{
	var objOpaId=""
	var adm=""
	var rowIdStr=""
	var opaIdStr=""
	var status="",stat="",timeDifference="",opaId=""
	var objtbl=document.getElementById('tUDHCANPATMAIN');
	var selrow=document.getElementById("selrow");
	if(selrow.value=="") return;
	if(selrow.value!="")
	{
		objOpaId=document.getElementById("opaIdz"+selrow.value);
		adm=document.getElementById("admz"+selrow.value);
		status=document.getElementById("statusz"+selrow.value).innerText;
		if(status==t['val:apply']) stat="A"       //shenqing
		if(status==t['val:arrange']) stat="R"     //anpai
		if(status==t['val:unAppoint']) stat="N"   //feiyuyue
		if(status==t['val:inRoom']) stat="I"      //shuzhong
		if(status==t['val:leaveRoom']) stat="L"   //shubi-lishi
		if(status==t['val:refuse']) stat="D"      //jujue
		if(status==t['val:finish']) stat="F"      //wancheng
	}
	if(objOpaId.innerText=="")
	{
		alert(t['alert:selectOne']);
		return;
	}
	else
	{
		opaId=objOpaId.innerText;
		if((status==t['val:arrange'])||(status==t['val:inRoom'])||(status==t['val:leaveRoom']))
		{
			var getRefundUserType=document.getElementById("GetRefundUserType").value;
			var retRefundType=cspRunServerMethod(getRefundUserType);
			var getChargeUserType=document.getElementById("GetChargeUserType").value;
			var retChargeType=cspRunServerMethod(getChargeUserType);
			var getTimeDifference=document.getElementById("getTimeDifference").value
			var timeDifference=cspRunServerMethod(getTimeDifference,opaId);
			if((retRefundType=="0")&&(retChargeType=="0"))
			{
				var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText+"&stat="+stat;
				window.open(lnk,'','');	
			}
			else if((retRefundType=="0")&&(retChargeType=="-1"))
			{
				var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText+"&stat="+stat+"&timeDifference="+timeDifference;
				window.open(lnk,'','');	
			}
			else if((retRefundType=="-1")&&(retChargeType=="0"))
			{
				var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText+"&stat="+stat+"&isRefund="+retRefundType;
				window.open(lnk,'','');
			}
			else
			{
				var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText+"&stat="+stat+"&isRefund="+retRefundType+"&timeDifference="+timeDifference;
				window.open(lnk,'','');
			}
		}
		else if(status==t['val:finish'])
		{
			//var retChargeType=0;
			//var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText+"&timeDifference="+timeDifference+"&isRefund="+retRefundType+"&retChargeType="+retChargeType;
			var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText+"&stat="+stat;
			window.open(lnk,'','');
		}
		else
		{
			alert("cizhuangtaibunengduifeiyongcaozuo!");
		}
		//var lnk= "http://192.168.11.238/trakcare/csp/dhcoperprice.csp?EpisodeID="+adm.innerText+"&OPERNo="+objOpaId.innerText;
		//showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no");
   	 	//window.open(lnk,'','');
	}
	
}
function enableOpaSeq(rowIndex)
{
	var opaSeqObj=document.getElementById("opordnoz"+rowIndex);
	if(opaSeqObj)
	{
		//opaSeqObj.onkeydown=SeqNoOnKeyDown;
		//ck091112
		var GetOpaSeqNoStr="1"+String.fromCharCode(1)+"1"+"-"+"1";
		for(var j=2;j<=20;j++)
		{
			GetOpaSeqNoStr=GetOpaSeqNoStr+"^"+j+String.fromCharCode(1)+j+"-"+j;
		}
		if (!combo_opaSeqList[rowIndex]){
			combo_opaSeqList[rowIndex]=dhtmlXComboFromStr("opordnoz"+rowIndex,GetOpaSeqNoStr);
			combo_opaSeqList[rowIndex].enableFilteringMode(true);
			combo_opaSeqList[rowIndex].setComboText(opaSeqObj.value)
			var OpaSeqNoObj=document.getElementById("opordnoz"+rowIndex);
			if(OpaSeqNoObj) var OpaSeqNo=OpaSeqNoObj.value;
			else var OpaSeqNo=""
			combo_opaSeqList[rowIndex].setComboValue(OpaSeqNo);
			combo_opaSeqList[rowIndex].selectHandle=combo_opaSeqListKeydownhandler;
			combo_opaSeqList[rowIndex].keyenterHandle=combo_opaSeqListKeyenterhandler;
			combo_opaSeqList[rowIndex].attachEvent("onKeyPressed",combo_opaSeqListKeyenterhandler);  //ck091112
		}
	}
}
function enableOpRoom(rowIndex)
{
	 var oproomObj=document.getElementById("oproomz"+rowIndex);
	 if(oproomObj)
	 {
		var GetAllOperRoomStr=document.getElementById("GetAllOperRoomStr").value
		if (!combo_RoomList[rowIndex]){
			combo_RoomList[rowIndex]=dhtmlXComboFromStr("oproomz"+rowIndex,GetAllOperRoomStr);
			combo_RoomList[rowIndex].enableFilteringMode(true);
			combo_RoomList[rowIndex].setComboText(oproomObj.value)
			var opRoomIdObj=document.getElementById("opRoomIdz"+rowIndex);
			if(opRoomIdObj) var opRoomId=opRoomIdObj.value;
			else var opRoomId=""
			combo_RoomList[rowIndex].setComboValue(opRoomId)
			combo_RoomList[rowIndex].selectHandle=combo_RoomListKeydownhandler;
			combo_RoomList[rowIndex].keyenterHandle=combo_RoomListKeyenterhandler;
			combo_RoomList[rowIndex].attachEvent("onKeyPressed",combo_RoomListKeyenterhandler)
		}
	}
}
function enableAnDoc(rowIndex)
{
	 var andocObj=document.getElementById("andocz"+rowIndex);
	 if(andocObj)
	 {
		var GetAnDocStr=document.getElementById("GetAnDocStr").value
		if (!combo_andocList[rowIndex]){
			combo_andocList[rowIndex]=dhtmlXComboFromStr("andocz"+rowIndex,GetAnDocStr);
			combo_andocList[rowIndex].enableFilteringMode(true);
			combo_andocList[rowIndex].setComboText(andocObj.value)
			var anDocDrObj=document.getElementById("tAnDocDrz"+rowIndex);
			if(anDocDrObj) var anDocDr=anDocDrObj.value;
			else var anDocDr=""
			combo_andocList[rowIndex].setComboValue(anDocDr)
			combo_andocList[rowIndex].selectHandle=combo_andocListKeydownhandler;
			combo_andocList[rowIndex].keyenterHandle=combo_andocListKeyenterhandler;
			combo_andocList[rowIndex].attachEvent("onKeyPressed",combo_andocListKeyenterhandler)
		}
	}
}
function enableAnDocNote(rowIndex)
{
 var anDocNoteObj=document.getElementById("anDocNotez"+rowIndex)
 if(anDocNoteObj)
 { 
    anDocNoteStr=anDocNoteObj.value;
	anDocNoteObj.onkeydown=AnDocNoteOnKeyDown 
 }	
}
function enableOpmem(rowIndex)
{
	 var opmemObj=document.getElementById("opmemz"+rowIndex);	 
	 if(opmemObj)
	 {
		 opmemObj.onchange=OpmemOnKeyDown;
	 }
}

function enableScrubnurse(rowIndex)
{
	var scrubnurseObj=document.getElementById("scrubnursez"+rowIndex);
	if(document.getElementById("scrubnursez"+rowIndex)) scrNurStr=document.getElementById("scrubnursez"+rowIndex).value;

	if(scrubnurseObj)
	{
		//scrubnurseObj.onblur=ScrNurOnKeyDown;
		scrubnurseObj.onkeydown=ScrNurOnKeyDown;
	}
}
function enableCirculnurse(rowIndex)
{
	var circulnurseObj=document.getElementById("circulnursez"+rowIndex);
	if(document.getElementById("circulnursez"+rowIndex)) cirNurStr=document.getElementById("circulnursez"+rowIndex).value;

	if(circulnurseObj)
	{
		//circulnurseObj.onblur=CirNurOnKeyDown;
		circulnurseObj.onkeydown=CirNurOnKeyDown;
	}
}
function enableAnDocAss(rowIndex)
{
	var anDocAssObj=document.getElementById("tAnDocAssz"+rowIndex);
	if(document.getElementById("tAnDocAssz"+rowIndex)) anDocAssStr=document.getElementById("tAnDocAssz"+rowIndex).value;

	if(anDocAssObj)
	{
		//andocObj.onblur=AndocOnKeyDown;
		anDocAssObj.onkeydown=AnDocAssOnKeyDown;
	}
}

//get PACU bed
function GetPacuBed(str)
{
	var ret=str.split("^");
	var obj=document.getElementById("PacuBedId");
	obj.value=ret[0];
	var obj=document.getElementById("PacuBed");
	obj.value=ret[1];
}
function TranToPacuBed_Click()
{
	var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
  	if (selrow.value!="") opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   	else  opaId="";
  	if (opaId=="")
  	{
   		alert(t['alert:selectOne']);
   		return;
  	}
  	var status=document.getElementById("statusz"+selrow.value).innerText;
  	if (status!=t['val:leaveRoom']) {alert(t['alert:notleavestatus']);return;}
	var PacuBedId="";
	var obj=document.getElementById("PacuBedId");
	if (obj) PacuBedId=obj.value;
  	if (PacuBedId=="")
  	{
   		alert(t['alert:enterpacubed']);
   		return;
  	}
	var obj=document.getElementById("TranToPacuBed");
	if (obj) {
		var retStr=cspRunServerMethod(obj.value,PacuBedId,opaId);
		if(retStr=="0") {alert(t['alert:success']);self.location.reload();}
		else  {alert(t['alert:success']);return;}
	}	
}
function ANOPCareRecord(lnk,nwin)	//operation care record 
{
    var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
  	if (selrow.value!="") opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   	else  opaId="";
  	if (opaId=="")
  	{
   		alert(t['alert:selectOne']);
   		return;
  	}
  	else
  	{
  		var IsPaidOrNoObj=document.getElementById("IsPaidOrNo");
		if(IsPaidOrNoObj)
		{
			var IsPaidOrNo=IsPaidOrNoObj.value;
			var retStr=cspRunServerMethod(IsPaidOrNo,opaId);
			if(retStr!="")
			{
				alert(retStr);
				return;
			}
		}
		lnk+="&opaId="+opaId+"&EpisodeID="+EpisodeID;
		window.open(lnk,'_blank',nwin);
	}
}
function ANOPCount(lnk,nwin)	//count 
{
    var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
  	if (selrow.value!="") opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   	else  opaId="";
  	if (opaId=="")
  	{
   		alert(t['alert:selectOne']);
   		return;
  	}
   	lnk+="&opaId="+opaId+"&EpisodeID="+EpisodeID;
   	window.open(lnk,'_blank',nwin);	
}

function UpdateKeyDown()
{
	if (window.event.keyCode!=13) return;
	var sessloc=session['LOGON.CTLOCID'];
	var obj=document.getElementById('ifloc');
	if(obj){ 
		var ret=cspRunServerMethod(obj.value,sessloc);
		//opLoc:ret=1,anLoc:ret=2
		if (ret!=1)	return;
	}
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var opaId="",scrubnurse="",circulnurse="";
	opaId=document.getElementById('opaIdz'+selectrow).innerText;
	scrubnurse=document.getElementById('scNurNotez'+selectrow).value;
	circulnurse=document.getElementById('cirNurNotez'+selectrow).value;
	if((opaId=="")||(opaId==" ")) return;
	var obj=document.getElementById('UpdateOpNurse')
	if(obj){
		//alert(opaId+"^"+scrubnurse+"^"+circulnurse)
		var ret=cspRunServerMethod(obj.value,opaId,scrubnurse,circulnurse);
		if (ret!='0')
		{
			alert(t['alert:error']);
			return;
		}	
	    alert(t['alert:success']);
	    return;
	}
	else return;
}
function OpmemOnKeyDown()
{
	if(event.keyCode==0)
	{
		var eSrc=window.event.srcElement;
    	var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		var opmemStr=eSrc.value;
		var opaIdObj=document.getElementById("opaIdz"+selectrow);
		
		if(opaIdObj)
		{
			var opaId=opaIdObj.innerText;
		}
		else var opaId="";
		if(opaId=="")
		{
			alert("qingxuanzebingren");
		}
		else
		{
			var UpdateOpmemObj=document.getElementById("UpdateOpmem");
			if(UpdateOpmemObj)
			{
				var UpdateOpmem=UpdateOpmemObj.value;
				var resStr=cspRunServerMethod(UpdateOpmem,opaId,opmemStr);
				if(resStr!=0)
		   		{
			   		alert("gengxinshoushuyaoqiushibai");
			   		eSrc.value="";
			   		self.location.reload();
		   		}
		   		//self.location.reload();
			}
		}
		//self.location.reload();
	}
}
function cancelReg()
{
	var clclogId="",logRecordId="",preValue="",preAddNote="",postValue="",postAddNote="",userId=""
    var selrow=document.getElementById("selrow");
    alert(selrow.value);
    if (selrow.value=="") return;
  	if (selrow.value!="") opaId=document.getElementById("opaIdz"+selrow.value).innerText;
   	else  opaId="";
  	if (opaId=="")
  	{
   		alert(t['alert:selectOne']);
   		return;
  	}
  	else
  	{
	  	var status=document.getElementById("statusz"+selrow.value).innerText;
	  	if(status==t['val:finish'])
	  	{
			clclogId=4;
			logRecordId=opaId;
			preValue="F";
			preAddNote="quxiaodengji"
			postValue="L";
			postAddNote="quxiaodengjichenggong,bianchengshubizhuangtai";
			var userId=session['LOGON.USERID'];
			var InsertCLLogObj=document.getElementById("InsertCLLog");
			if(InsertCLLogObj)
			{
				var InsertCLLog=InsertCLLogObj.value;
				var retCllog=cspRunServerMethod(InsertCLLog,clclogId,logRecordId,preValue,preAddNote,postValue,postAddNote,userId);
				alert(retCllog);
				alert(retCllog.replace(/\d/g,"").length);
				if(retCllog.replace(/\d/g,"").length==0)
				{
					var cancelRegObj=document.getElementById("CancelReg");
					if(cancelRegObj)
					{
						var cancelReg=cancelRegObj.value;
						var retStr=cspRunServerMethod(cancelReg,opaId);
						if(retStr!="")
						{
							alert(retStr);
						}
						else
						{
							alert("quxiaodengjichenggong");
						}
					}
					//return;
				}
				else
				{
					alert(retCllog);
				}
			}
	  	}
	  	else
	  	{
		  	alert("zhinengduiyijingdengjideshoushucaozuo!");	
		}
	}
}
function BtnAnaDoctorOrdered_Click()
{
	var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
    var Status=document.getElementById("statusz"+selrow.value).innerText;
	if ((Status!=t['val:arrange'])&&(Status!=t['val:leaveRoom'])&&(Status!=t['val:PACU'])&&(Status!=t['val:finish'])) {
		alert(t['alert:canOper']+t['val:arrange']+","+t['val:leaveRoom']+","+(Status!=t['val:PACU'])+","+(Status!=t['val:finish']));
		return;
	}
	var opaId="";
    if (selrow.value!="") opaId=document.getElementById("opaIdz"+selrow.value).innerText;
    if (opaId=="") return;
    //alert(opaId)
    
	var objUpdateAnaDoctorOrdered=document.getElementById("UpdateAnaDoctorOrdered");
	if(objUpdateAnaDoctorOrdered)
	{
		var retStr=cspRunServerMethod(objUpdateAnaDoctorOrdered.value,opaId);
		if (retStr!=0) alert(retStr);
		else alert(t['alert:success']);
	}
}
function SetDocArriveTime_Click()
{
	var selrow=document.getElementById("selrow");
    if (selrow.value=="") return;
    var Status=document.getElementById("statusz"+selrow.value).innerText;
	if (Status!=t['val:arrange']) {
		alert(t['alert:canOper']+t['val:arrange']);
		return;
	}
	var opaId="";
    if (selrow.value!="") opaId=document.getElementById("opaIdz"+selrow.value).innerText;
    if (opaId=="") return;

	var objSetDocArriveTime=document.getElementById("SetDocArriveTime");
	if(objSetDocArriveTime)
	{
		var arriveTime="",isSuper="";
		var objArriveTime=document.getElementById("arriveTime");
		if (objArriveTime)
		{
			arriveTime=objArriveTime.value;
			isSuper="Y";
		}
		var retStr=cspRunServerMethod(objSetDocArriveTime.value,opaId,arriveTime,isSuper);
		if (retStr!=0) alert(retStr);
		else alert(t['alert:success']);
	}
}
