/// DHCST.PIVA.QUERY1
var rcnumber=70;
function BodyLoadHandler()
{     
  	InitForm();
       
  	SetObjHandler();
	//SetTblColor();
	//SelectAll;
}
function InitForm()
{     
	setDefaultValByLoc();
       
	setPassAudit();

	setSpecStat();
       
	setDlabPrint();
	
	setPIVAType();
	
	//GetRecord();
	setDlabPogFlag();
}
function setDefaultValByLoc()
{
	var locid = "";
	var docu=parent.frames['DHCST.PIVA.QUERY1'].document
    if (docu){
	    	var objlocid = docu.getElementById("tPLocID");
			if (objlocid) locid = objlocid.value;
			if (locid == "") return;
			
			var objPloc = document.getElementById("tPLocID");
			if (objPloc) objPloc.value=locid ;
    }

	var strsets = cspRunGetLocSet(locid);
	if (strsets != "")
	{
		var arrset = strsets.split("^")
		var sdate = arrset[6];
		var edate = arrset[7];
		var stdate = GetCalDate("mGetDate",sdate);
		var eddate = GetCalDate("mGetDate",edate);
		var objsd = document.getElementById("tStartDate");
		if (objsd){
			if (objsd.value=="") objsd.value = stdate;
		}
		var objed = document.getElementById("tEndDate");
		if (objed){
			if (objed.value=="") objed.value = eddate;
		}
		var objsdo = document.getElementById("tOrdStDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tOrdEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = eddate;
		}
		var objsdo = document.getElementById("tCPrintStartDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tCPrintEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = stdate;
		}
		var objst = document.getElementById("tCPrintStartTime");
		if (objst){
			if (objst.value=="") objst.value = "00:00";
		}
		var objet = document.getElementById("tCPrintEndTime");
		if (objet){
			if (objet.value=="") objet.value = "23:59";
		}

	}
}
function setPIVAType()
{
		
	var obj = document.getElementById("tOecType");
	if (obj){
		setOecType();
		obj.onchange=OecTypeSelect;
	}
}
/// /// tDlabPrint
function setDlabPrint()
{
	var listobj=document.getElementById("tDlabPrint");
	if (listobj){
		listobj.size=1; 
	 	listobj.multiple=false;
	 	listobj.options[1]=new Option("��","1");
	 	listobj.options[2]=new Option("��","0");
	}
	var objindex=document.getElementById("tDlabPrintIndex");
	if (objindex) listobj.selectedIndex=objindex.value;
}
function DlabPrintSelect()
{
	var objindex=document.getElementById("tDlabPrintIndex");
	if(objindex){
		var obj=document.getElementById("tDlabPrint");
		objindex.value=obj.selectedIndex;
	}
}
function setPassAudit()
{
	var obj=document.getElementById("tPassAudit");
	if (obj) InitPassAudit(obj);
	var objindex=document.getElementById("PassAuditIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
function setSpecStat()
{    
   
	var obj=document.getElementById("tSpecStat");
	if (obj) InitSpecStat(obj);
	
	var objindex=document.getElementById("SpecStatIndex");
	
	if (objindex.value!="")
	{
	    if (objindex) obj.selectedIndex=objindex.value;
	}

}
function GetRecord()
{
	var obj=document.getElementById("mGetRecord");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	var pid="";
	var str="";
	var recordnum=0;
	var pnums=0;
    var obj=document.getElementById("tbPIDz"+1);
	if (obj) pid=obj.value;
	if (pid!=""){
		str=cspRunServerMethod(encmeth,pid);
	}
	var strarr=str.split("^")
	if (strarr.length>1){
		recordnum=strarr[0];
		pnums=strarr[1];
	}
	var obj=document.getElementById("clCnt");
	if (obj){
		obj.innerText="��¼��:"+recordnum+" "+"����:"+pnums
	}
}
function SetTblColor()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt>0){
		/*for (var i=1;i<objtbl.rows.length; i++) {
			var cell=document.getElementById("tbSelectz"+i);
			if (cell){cell.onclick=tbSelectClick;}
    	}*/
    	SetTblRowsColor(objtbl,2);
	}
}
function SetObjHandler()
{     
	var obj = document.getElementById("tBatNo");
	if (obj) {
		//obj.onblur = BatNoLostFocus;
		obj.onfocus = BatNoOnFocus;
		obj.onkeydown = BatNoKeyDown;
	}
	//if (obj) obj.readOnly = true;
	var obj = document.getElementById("tOecpr");
	if (obj) {
		obj.onblur = OecprLostFocus;
		obj.onfocus = OecprOnFocus;
		obj.onkeydown = OecprKeyDown;
	}
	//if (obj) obj.readOnly = true;
	//if (obj) obj.readOnly=true;
	var obj = document.getElementById("tRegNo");
	if (obj) {
		obj.onblur = RegNoLostFocus;
		obj.onfocus = RegNoOnFocus;
		obj.onkeydown = RegNoKeyDown;
	}
	var obj=document.getElementById("tPLoc");
	if (obj){
		obj.onkeydown=PLocKeyDown;
		obj.onfocus=PLocOnFocus;
	 	obj.onblur=PLocLostFocus;
	}
	var obj=document.getElementById("tWard");
	if (obj){
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
		obj.onkeydown=WardKeyDown;
	}
	var obj = document.getElementById("tItmDesc");
	if (obj){
		obj.onblur=ItmLostFocus;
		obj.onfocus=ItmOnFocus;
		obj.onkeydown=ItmKeyDown;
	}
	var obj = document.getElementById("tPassAudit");
	if (obj){
		obj.onchange=PassAuditSelect;
	}
	var obj = document.getElementById("tPrintNo");
	if (obj){
		obj.onblur=PrintNoLostFocus;
		obj.onfocus=PrintNoOnFocus;
		obj.onkeydown=PrintNoKeyDown;
	}
	var listobj=document.getElementById("tDlabPrint");
	if (listobj) {
		listobj.onclick=DlabPrintSelect;
	}
	var listobj=document.getElementById("tSpecStat");
	if (listobj) {
		listobj.onclick=SpecSelect;
	}	
	//var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    //if (objtbl) objtbl.ondblclick=tbDbClick;
	var objtbl=document.getElementById("cSelectAll");
	if (objtbl) objtbl.onclick = SelectClick;
	//var objtbl=document.getElementById("cClearAll");
	//if (objtbl) objtbl.onclick = ClearAll;
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bRePrintLabel");
	if (obj) obj.onclick=RePrintLab;
	var obj=document.getElementById("bPrintDLabel");
	if (obj) obj.onclick=PrintDLab;
	var obj=document.getElementById("bPrintPresc");
	if (obj) obj.onclick=PrintDetaill;

}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
}
/// tPLoc Handler
function PLocKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tPLoc_lookuphandler();
	}
}
function PLocOnFocus()
{
	var obj=document.getElementById("tPLoc");
	if (obj) obj.select();
}
function PLocLostFocus()
{
	var obj=document.getElementById("tPLoc");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPLocID");
			if (obj) obj.value=""
		}
	}
}
function DispLocLookUpSelect(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("tPLocID");
	if (obj){
		if (loc.length>0) obj.value=loc[1];
		else obj.value="";
	}
}
/// tWard Handler
function WardOnFocus()
{
	var obj=document.getElementById("tWard");
	if (obj) obj.select();
}
function WardLostFocus()
{
	var obj=document.getElementById("tWard");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tWardID");
			if (obj) obj.value=""
		}
	}
}
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj){
		if (ward.length>0)   obj.value=ward[1];
		else  obj.value="" ;
	 }
}
function WardKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tWard_lookuphandler();
	}
}
/// tRegNo Handler
function RegNoKeyDown()
{
	var key=websys_getKey();
	if (key==13)
	{
		RegNoLostFocus();
	}
	
}
function RegNoOnFocus()
{
	var obj=document.getElementById("tRegNo");
	if (obj) obj.select();
}
function RegNoLostFocus()
{
	var regno;
	var objregno=document.getElementById("tRegNo");
	if (objregno) regno=objregno.value;
	if (regno==""){
		return;
	}
	else{
		regno=getRegNo(regno);
		objregno.value=regno
	}
}
/// tItmDesc Handler
function ItmLostFocus()
{
	var obj=document.getElementById("tItmDesc");
	if (obj){
		if (obj.value == ""){
			var obj=document.getElementById("tItmID");
			if (obj) obj.value = ""
		}
	}
}
function ItmOnFocus()
{
	var obj=document.getElementById("tItmDesc");
	if (obj) obj.select();
}
function ItmKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tItmDesc_lookuphandler();
	}
}
function ItmLookupSelect(str)
{	
	var inci=str.split("^");
	var obj=document.getElementById("tItmID");	
	if (obj){
		if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}

}
/// tBatNo
function BatNoOnFocus()
{
	var obj=document.getElementById("tBatNo");
	if (obj) obj.select();
}
function BatNoKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tBatNo_lookuphandler();
	}
}
/// tOecpr
function OecprLostFocus()
{
	var obj = document.getElementById("tOecpr");
	if (obj.value=="") {
		var objid=document.getElementById("tOecprID");
		objid.value="";
	}
}
function OecprOnFocus()
{
	var obj = document.getElementById("tOecpr");
	obj.select();
}
function OecprKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		tOecpr_lookuphandler();
	}
}
function OecprLookupSelect(str)
{	
	var cpr=str.split("^");
	var obj=document.getElementById("tOecprID");
	if (obj){
		if (cpr.length>0)   obj.value=cpr[2] ;
		else  obj.value="" ;  
	}

}
/// tPassAudit
function PassAuditSelect()
{
	var obj=document.getElementById("PassAuditIndex");
	if(obj){
		var objpass=document.getElementById("tPassAudit");
		obj.value=objpass.selectedIndex;
	}
}
/// tSpecStat
function SpecSelect()
{
	var obj=document.getElementById("SpecStatIndex");
	if(obj){
		var objspec=document.getElementById("tSpecStat");
		obj.value=objspec.selectedIndex;
	}
}
/// tPrintNo
function PrintNoLostFocus()
{
	var obj=document.getElementById("tPrintNo");
	if (obj){
		if (obj.value!=""){
			
			obj.value=FormatNo(obj.value)
			
		}
	}
}
function PrintNoOnFocus()
{
	var obj=document.getElementById("tPrintNo");
	if (obj) obj.select();
}
function PrintNoKeyDown()
{
	if (window.event.keyCode==13){
	  	PrintNoLostFocus();
	}
}

///��Һ��������
function setOecType()
{
	var obj=document.getElementById("tOecType");
	if (obj) PInitOecType(obj);
	var objindex=document.getElementById("OecTypeIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
///��ʼ����Һ����
function PInitOecType(listobj)
{
	var obj=document.getElementById("mGetPivaType");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			///��ʼ����Һ����
			if (listobj)
			{
				listobj.size=1; 
			 	listobj.multiple=false;

			 	listobj.options[i+1]=new Option(type,typeindex);
		    }
			
		}
		
	}
	

}
/// tOecType
function OecTypeSelect()
{
	var obj=document.getElementById("OecTypeIndex");
	if(obj){
		var objpass=document.getElementById("tOecType");
		obj.value=objpass.selectedIndex;
	}
}

/// cmd handler
function Clear()
{
	var obj;
	//KillTmpBeforeFind();
	setDefaultValByLoc();
	var objward = document.getElementById("tWard");
	if (objward) objward.value = "";
	var objwardid = document.getElementById("tWardID");
	if (objwardid) objwardid.value = "";
	var objno = document.getElementById("tRegNo");
	if (objno) objno.value = "";
	obj=document.getElementById("tBatNo");
	if (obj) obj.value="";
	obj=document.getElementById("tOecprID");
	if (obj) obj.value="";
	obj=document.getElementById("tOecpr");
	if (obj) obj.value="";
	obj=document.getElementById("tItmID");
	if (obj) obj.value="";
	obj=document.getElementById("tItmDesc");
	if (obj) obj.value="";
	obj=document.getElementById("tPrintNo");
	if (obj) obj.value="";
	obj=document.getElementById("tState");
	if (obj) obj.value="";
	obj=document.getElementById("tPassAudit");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("tSpecStat");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("tDlabPrint");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="��¼��:0"+" "+"����:0";
}
function FindClick()
{
	if (ChkFindCondition()==false) return;	
	
	ReFind();
}
function ReFind()
{
		KillTmpBeforeFind();
		var sdate="";
		var edate="";
		var stime="";
		var etime="";
		var pstime="";
		var petime="";
		var pnostr="";
		var cpstr="";
		var pst="";
		var pet="";
		var ptype="";
		var locgrp="";
		var prtno="";
		var prtstr="";
		var warddr="";
	
	    var docu=parent.frames['DHCST.PIVA.QUERY'].document
	    
	    //��ǩ��ʼ���� 
	    var objsdate= document.getElementById("tStartDate");
		if (objsdate){
			psdate=objsdate.value;
			var objsdate1 = docu.getElementById("tStartDate");
			if (objsdate1) {objsdate1.value=psdate ;}
		}
	    //��ǩ�������� 
	    var objedate = document.getElementById("tEndDate");
	    if (objedate){pedate=objedate.value;
	    	var objedate1 = docu.getElementById("tEndDate");
			if (objedate1) {objedate1.value=pedate ;}
	    
	    }
	    //ҽ����ʼ����
	    var objosdate = document.getElementById("tOrdStDate");
	    if (objosdate){osdate=objosdate.value;
	        var objosdate1 = docu.getElementById("tOrdStDate");
			if (objosdate1) {objosdate1.value=osdate ;}
	    }
	    //ҽ����������
	    var objoedate = document.getElementById("tOrdEndDate");
	    if (objoedate){oedate=objoedate.value;
	        var objoedate1 = docu.getElementById("tOrdEndDate");
			if (objoedate1) {objoedate1.value=oedate ;}
	    }
	    //��Һ״̬
	    var objstate = document.getElementById("tState");
	    if (objstate){State=objstate.value;
	    	var objstate1 = docu.getElementById("tState");
			if (objstate1) {objstate1.value=State ;}
	    }
	    //�ǼǺ�
	    var objregno = document.getElementById("tRegNo");
	    if (objregno){regno=objregno.value;
	      	var objregno1 = docu.getElementById("tRegNo");
			if (objregno1) {objregno1.value=regno ;}
	    }
	    //ҩƷ����
	    var objinci = document.getElementById("tItmID");
	    if (objinci){inci=objinci.value;
	    	var objinci1 = docu.getElementById("tItmID");
			if (objinci1) {objinci1.value=inci ;}
		}
	    //��Һ���
	    var objpass = document.getElementById("tPassAudit");
	    if (objpass){audit=objpass.value;
	    	var objpass1 = docu.getElementById("tPassAudit");
			if (objpass1) {objpass1.value=audit ;}
		}
		
	    //����״̬
	    var objspec = document.getElementById("tSpecStat");
	    if (objspec){spec=objspec.value;
	    	var objspec1 = docu.getElementById("tSpecStat");
			if (objspec1) {objspec1.value=spec ;}
	    }
	    
	    //ֹͣ��ǩ
	    var objdlab = document.getElementById("tDlabPrint");
	    if (objdlab){dlab=objdlab.value;
	    	var objdlab1 = docu.getElementById("tDlabPrint");
			if (objdlab1) {objdlab1.value=dlab ;}
	    }
	    
	    //��Һ״̬
	    var objstate = document.getElementById("tState");
	    if (objstate){state=objstate.value;
	    
	    	var objstate1 = docu.getElementById("tState");
			if (objstate1) {
				
				objstate1.value=state ;}
	    }
	    
	    


        var objsdo = document.getElementById("tCPrintStartDate");
		if (objsdo){
			sdate=objsdo.value;
		}
		var objedo = document.getElementById("tCPrintEndDate");
		if (objedo){
			edate=objedo.value;
		}
		var objst = document.getElementById("tCPrintStartTime");
		if (objst){
			stime=objst.value;
		}
		var objet = document.getElementById("tCPrintEndTime");
		if (objet){
			etime=objet.value;
		}
    
      	  var objpst=document.getElementById("tStartDateTime")
		  if (objpst) pst=objpst.value ;
		  
		  var objpet=document.getElementById("tEndDateTime")
		  if (objpet) pet=objpet.value ;
		  
		  var objtype=document.getElementById("tOecType")
		  if (objtype) ptype=objtype.value ;
		  var objprtno=document.getElementById("tPrintNo")
		  if (objprtno) prtno=objprtno.value ;
		  
		  var objprtstr=document.getElementById("tPrintNoStr")
		  if (objprtstr) prtstr=objprtstr.value
		
		  var objward=document.getElementById("tWardID")
		  if (objward) warddr=objward.value ; //����or������
		  
		  var objploc=document.getElementById("tPLocID")
		  if (objploc) ploc=objploc.value ;
		  
		  var objpr=document.getElementById("tOecprID")
		  if (objpr) prdr=objpr.value ;
		  
		  var objbt=document.getElementById("tBatNo")
		  if (objbt) btno=objbt.value ;
		  
		   //�����ʽ
		  plogflag = document.getElementById("tDlabPogFlag").value;


		  
		  var tmpstr1=pst+"^"+pet+"^"+ptype+"^"+prtno+"^"+prtstr+"^"+warddr+"^"+ploc+"^"+prdr+"^"+btno+"^"+plogflag
		
		  var objcp = document.getElementById("tCPStr");
		  if (objcp){
				var tmpstr=sdate+"^"+edate+"^"+stime+"^"+etime
				var tmpstr=tmpstr+"^"+tmpstr1 ;
				objcp.value=tmpstr ;
				var objcp1 = docu.getElementById("tCPStr");
                if (objcp1){objcp1.value=tmpstr ;}
			}
    
 
        var objfind1 = docu.getElementById("bFind");
	    if (objfind1) { objfind1.click();}
	  	//bFind_click();
	  	//KillTmpBeforeFind();
}
function KillTmpAfterFind(pid)
{
	var objktmp=document.getElementById("mKTmpAfterFind");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	cspRunServerMethod(encmeth,pid);
}
function KillTmpBeforeFind()
{
	var pid=""; 
	var obj=document.getElementById("tbPIDz"+1);
    if (obj) pid=obj.value;
    if (pid>0) KillTmpAfterFind(pid);
}
 /// ����ѯ����
function ChkFindCondition()
{ 
	var obj;
	obj=document.getElementById("tPLocID") ;
	if (obj){
		if (obj.value==""){
		    alert(t["NO_DISPLOC"]);
	   	    return false;
	   	}
	}
	var obj1=document.getElementById("tStartDate") ;
	if (obj1.value=="" ){
		alert(t['NO_STARTDATE']);
	  	return false;
	} 
	var obj2=document.getElementById("tEndDate") ;
	if (obj2.value=="" ){
		alert(t['NO_ENDDATE']) ;
	  	return false;
	}
    if (DateStringCompare(obj1.value,obj2.value )==1){
	    alert(t['INVALID_DATESCOPE']);
     	return  false ;
	}
	var tPrintNoVal=document.getElementById("tPrintNo").value;
	var tPrintNoStrVal=document.getElementById("tPrintNoStr").value;
	if ((tPrintNoStrVal!="")&&(tPrintNoVal=="")){
		alert("���ݴ�ӡ��Ų�ѯʱ,��ӡ���ݺű���!");
		return;
	}
	var objward=document.getElementById("tWardID");
	var objreg=document.getElementById("tRegNo");
	if ((objward.value=="")&&(objreg.value=="")) {
		if (confirm("��û��ѡ�����͵ǼǺ�,��ѯ���ܻ����,ȷ�ϼ�����?")) {return true;} else {return false;}
		//if (confirm(t['NO_SELECT'])) {return true;} else {return false;}
	}

	return true ;
}

/// �ش�ǩ
function RePrintLab()
{
	//if (!confirm(t['CONFIRM_REPRINT'])) {return;}
	if (!confirm("ȷ���ش��ǩ��?")) {return;}
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;	
	var document=parent.frames['DHCST.PIVA.QUERY'].document
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) {
		alert("û����ϸ��¼!");
		return;
	}
	var printed="";
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			var pog=document.getElementById("tbPogIDz"+i).value;
			if (pog!=ppog){
				ppog=pog;
				ret=CspRunSavePogState(ppog);
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				var ret=PrintLabel(ppog,"��");
				if (ret==false) {return;}
			}
			printed="1";	
		}
	}
	if (printed==""){
		alert("����ѡ�м�¼,���ش��ǩ!");
		return;
	}
	ReFind();
	
}

/// �ش��ǩʱ�������Ǹ��˲�ͨ�����������Һ״̬
function CspRunSavePogState(pog)
{
	var obj=document.getElementById("mSavePogState");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pog);
	return ret;
}
var ccc=0
/// ��ӡ��ǩ
function PrintLabel(pog,stype)
{
	var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
	if (!Bar) return false;
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var Hospname=cspRunServerMethod(encmeth,'','');
	var pogstr=CspRunGetPogPrintM(pog)
	if (pogstr==""){
		alert(t['ERR_GETPRINTM']);
		return false;
	}
	var pogistr=CspRunGetPogPrintI(pog)
	if (pogistr==""){
		alert(t['ERR_GETPRINTI']);
		return false;
	}
	//pogstr = "1009^295800000||339998888888888899999^1^GREKHLDY-��Ⱦ���ƻ���Ԫ^J0809220016^3^1^^20^����ҽ��^Qd^TPN��������^2008-09-22 08:00:00^100ml^^^2-2�]�߼�^^�˽���^0000114877^46��^��^ͣ^155kg^��һ������^�й���^����˼����^3^1"
	//pogistr = "������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||������ע��Һ[����][5%100ml]^100ml^[5%100ml]^1^1^1^^^��||ע���û�ԭ�͹��׸���[����Ī��][1.2g]^1.2g^[1.2g]^1^1^1^^^��||�ȵ���ע��Һ[����][10ml:400iu]^2IU^[10ml:400iu]^0^2^2^^^��"
	Bar.Device="PIVA";
	Bar.PageWidth=65;
	Bar.PageHeight=90;
	Bar.HeadFontSize=12;
	Bar.FontSize=10;
	//Bar.FontName = "����";
	Bar.Title=Hospname+"��Һ��";
	Bar.HeadType=stype;
	Bar.IfPrintBar="true";
	Bar.BarFontSize=25;
	Bar.BarTop=5;
	Bar.BarLeftMarg=67;
	Bar.PageSpaceItm=2;	
	Bar.ItmFontSize=10;
	Bar.ItmCharNums=30; //30//ҩ��ÿ����ʾ���ַ���
	Bar.ItmOmit="false";	//ҩƷ�����Ƿ�ȡ��ֻ��ӡһ��
	Bar.PageMainStr=pogstr;	// ��ӡ��ǩҽ����Ϣ
	Bar.PageItmStr=pogistr;	// ��ӡ��ǩҩƷ��Ϣ
	Bar.PageLeftMargine=1;
	Bar.PageSpace = 1;
	Bar.BarWidth=14;
	Bar.BarHeight=14;
	var printFlag="1";
	//ccc=ccc+1
	//if (ccc==3){printFlag="1",ccc=0}
	//Bar.LabelQty = 1;
	Bar.PrintDPage(printFlag)
	return true;
}

/// ȡ��ӡ����Ϣ
function CspRunGetPogPrintM(pog)
{
	var objktmp=document.getElementById("mGetPrintPog");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,pog);
	return str;
}
/// ȡ��ӡ��ϸ��Ϣ�ַ���
function CspRunGetPogPrintI(pog)
{
	var objktmp=document.getElementById("mGetPrintPogItm");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,pog);
	return str;
}

/// cSelectAll
function SelectClick()
{
	var obj=document.getElementById("cSelectAll");
    if (obj){
	    if (obj.checked==true){SelectAll();}
	    else {ClearAll();}
    }
}
/// ѡ��������
function SelectAll()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell) cell.checked=true;
	}
}
/// ���������
function ClearAll()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell) cell.checked=false;
	}
}
/// ѡ����������
function tbSelectClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var setvalue;
 	var cell=document.getElementById("tbSelectz"+row);
 	var pog=document.getElementById("tbPogIDz"+row).value;
	if (cell){
		if (cell.checked==false) {setvalue=false;}
		else {setvalue=true;}
	}
	var pogflag=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var objpog=document.getElementById("tbPogIDz"+i)
		if (objpog) pogid=objpog.value;
		if (pogid==pog){
			var objsel=document.getElementById("tbSelectz"+i);
			objsel.checked=setvalue;
			pogflag=1
		}
		if ((pogid!=pog)&&(pogflag==1)) break;
	}
}

function PrintDetaill()
{
	if (!confirm("ȷ��Ҫ��ӡ��ϸ��?")) {return;}
	var cnt=0;
	var ppog="";
	var num=0;

	var document=parent.frames['DHCST.PIVA.QUERY'].document
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var gPrnpath=getPrnPath();
		if (gPrnpath=="") 
		{
			  alert(t["CANNOT_FIND_TEM"]) ;
			  return ;                
	    }
	var Template=gPrnpath+"DHCST_PIVA_PRTDETAIL.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    if (xlsheet==null) 
	    {       
	    	alert(t["CANNOT_CREATE_PRNOBJ"]);
	        return ;                
	    }
	    
	var startNo=3 ;
	var serialNo=0;
	var tmppog="" ;
	var patTotal=0;	
    
    var gProcessID=document.getElementById("tbPIDz"+1).value;
    
    var obj=document.getElementById("mListPrtDetail")
    if (obj) exe=obj.value;
    else  exe="" ;
    //
    var docu=parent.frames['DHCST.PIVA.QUERY1'].document
    
    var bat="",ward="";
    var objbat=docu.getElementById("tBatNo");
    if (objbat) {bat=objbat.value} ;
    
    var objward=docu.getElementById("tWard");
    if (objward) {ward=objward.value} ;
    
    var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	//gHospname=cspRunServerMethod(encmeth,'','') ;
	//alert(gHospname)
	gHospname=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])

    xlsheet.Cells(1, 1).Value =gHospname+"��Һ�嵥";
    if (ward=="") ward="ȫ��"
    if (bat=="") bat="ȫ��"
    xlsheet.Cells(2, 1).Value ="����:"+ward+"    "+"����:"+bat;

	var str=""		
    do 
        {

	    	datas=cspRunServerMethod(exe,gProcessID,str);
	        if (datas!="")
            {
	            
	             var datas=datas.split("^")
				 var ward=datas[0];
				 var bedcode=datas[3];
				 var name=datas[1];
				 var paregno=datas[2];
		         var orddate=datas[4];
		         var prtno=datas[5];
		         var orditemdesc=datas[6]
		         var dosqty=datas[7];
		         var doctor=datas[8];
	             var bat=datas[9];
	             var pog=datas[10];
	             var pogsub=datas[11];
	             var freq=datas[12];
	             
	             str=ward+"/"+bedcode+"/"+paregno+"/"+bat+"/"+pog+"/"+pogsub
	         
	             
	             serialNo++;
	             
	             
	             if ((tmppog!="")&&(pog!=tmppog) )
	             { 
		      	     // setBottomLine(xlsheet,startNo+serialNo,1,3);
		         }   
	             
	             
		        if (tmppog=="")
		        {   
		        	xlsheet.Cells(startNo+serialNo, 1).Value =paregno;    
		            xlsheet.Cells(startNo+serialNo, 2).Value =bedcode;
		            xlsheet.Cells(startNo+serialNo, 3).Value =name; 
		            
		            patTotal=patTotal+1;
		        }
		        else
		        {if (tmppog!=pog)
		            {  
		             xlsheet.Cells(startNo+serialNo, 1).Value =paregno;
		             xlsheet.Cells(startNo+serialNo, 2).Value =bedcode;
		             xlsheet.Cells(startNo+serialNo, 3).Value =name;
		              
		             patTotal=patTotal+1;
		             
		             setBottomLine(xlsheet,startNo+serialNo-1,1,6)
		            }
		        }
		        
		        xlsheet.Cells(startNo+serialNo, 4).Value =orditemdesc; 
				xlsheet.Cells(startNo+serialNo, 5).Value =dosqty;
				xlsheet.Cells(startNo+serialNo, 6).Value =freq
	
			    tmppog=pog
            }
            else {str=""}
            
        } while (str!="")
                       
	setBottomLine(xlsheet,startNo+serialNo,1,6)
		
	xlsheet.Cells(startNo+serialNo+1, 1).Value="����:"+patTotal+"��      ��ӡʱ��:"+ getPrintDateTime()+"    "+"��ӡ��:"+session['LOGON.USERNAME'];
	
	
	
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet);
	//KillTmpAfterPrint(gProcessID);

}





function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
        
}
//�˴�����,yunhaibao20160613,ͳһ������ʱglobal
function KillTmpAfterPrint(pid)
{
	var document=parent.frames['DHCST.PIVA.QUERY'].document
    var obj=document.getElementById("mKillPrt") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gHospname=cspRunServerMethod(encmeth,pid) ;
        
}

function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}


function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	if(prnpath.substring(prnpath.length,prnpath.length-1)!="\\"){prnpath=prnpath+"\\"}
	return prnpath
}


/// ��ӡֹͣ��ǩ
function PrintDLab()
{
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;	
	var document=parent.frames['DHCST.PIVA.QUERY'].document
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) {
		alert("û����ϸ��¼!");
		return;
	}
	if (!confirm("ȷ��Ҫ��ӡ��")) {return;}
	var pcp="";
	var printed="";
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			if (pcp==""){
				pcp=CspRunInsCprint();
				if (pcp<0){
					return;
				}
			}
			var pog=document.getElementById("tbPogIDz"+i).value;
			//var oest=document.getElementById("tbOeStatusz"+i).innerText;
			//var spest=document.getElementById("tbSpecStatz"+i).innerText;
			//var pogst=document.getElementById("tbStatez"+i).innerText;
			//var cprintno=trim(document.getElementById("tbCPrintNoz"+i).innerText);
			//
			var oest=document.getElementById("tbOeStatusHiddenz"+i).value;
			var spest=document.getElementById("tbSpecStatHidz"+i).value;
			var pogst=document.getElementById("tbCnumberz"+i).value;
			var cprintno=document.getElementById("tbCPrintNoHiddenz"+i).value;
			
			pogst=10
			if (((oest=="ֹͣ")||(spest!="N"))&&(pog!=ppog)&&(cprintno=="")&&(pogst<60)){
				ppog=pog;
				/// ������Һҽ��������ȡ����ӡ��Ϣ
				num=num+1;
				//alert(num)
				//return;
				ret=CspRunSavePogCprint(ppog,pcp,num);
				//alert(ret)
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				var ret=PrintLabel(ppog,"")
				if (ret==false) {return;}
				printed="1";
			}
		}
	}
	if (num>0){
		//var ret=PrintH(pcp); /// ��ӡ��ҳ
	}
	if (printed==""){
		alert("����ѡ��ִ�м�¼ֹͣ�ļ�¼,���ش�ֹͣ��ǩ!");
		return;
	}
	//if(ret==false) return;
	ReFind();
}

/// ����ȡ����ӡ��
function CspRunInsCprint()
{
	var objktmp=document.getElementById("mInsCPrint");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var pcp=cspRunServerMethod(encmeth);
	return pcp;
}
/// ȡ����ӡʱ������Һҽ��������
function CspRunSavePogCprint(pog,pcpdr,number)
{
	var objktmp=document.getElementById("mSavePogCprint");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pog,pcpdr,number);
	return ret;
}
 //hulihua
 //zhouxinxin 2015-12-31(�Ͳ����齨(*^__^*) ����) 
 //yunhaibao,���ò���
 /*
function setDlabPogFlag()
{
	try{
		var tables=document.getElementsByTagName("table");
		var ttd=document.getElementsByTagName("td");
		var ttr=document.getElementsByTagName("tr");
		var tables=document.getElementsByTagName("table");
		var tr = document.createElement("tr");
		trhtml = "<td align=right><P align=right>�����ʽ</P></td><td><select id='tDlabPogFlag'   style='WIDTH: 100px; HEIGHT: 28px'>"; 
		trhtml=trhtml+"<option value='0'></option>";
		trhtml=trhtml+"<option value='Y'>��ʿ���</option>";
		trhtml=trhtml+"<option value='E'>���δ��</option>";
		trhtml=trhtml+"<option value='P'>������</option>";
		trhtml=trhtml+"<option value='A'>ȫ�����</option>";
		trhtml=trhtml+"</select></td><td></td>"
		tr.innerHTML =trhtml
		row=tables[1].rows.length-3
		ttr[6].insertBefore(tr,ttr[6].childNodes[0])
    
	}catch(e){alert(e.message)} 
}*/
function setDlabPogFlag()
{
	var listobj=document.getElementById("tDlabPogFlag");
	if (listobj){
		listobj.size=1; 
	 	listobj.multiple=false;
	 	listobj.options[1]=new Option("��ʿ���","Y");
	 	listobj.options[2]=new Option("���δ��","E");
	 	listobj.options[3]=new Option("������","P");
	 	listobj.options[4]=new Option("ȫ�����","A");
	}
}
document.body.onload=BodyLoadHandler;