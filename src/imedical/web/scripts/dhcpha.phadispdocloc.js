// dhcpha.phadispdocloc.js
// 医生科室发药
function BodyLoadHandler()
{	
	var obj;

	obj=document.getElementById("Clear");
	if (obj) obj.onclick=ClearClick;
 	obj=document.getElementById("Print");
	if (obj) obj.onclick=PrintClick;
	obj=document.getElementById("Collect");
	if (obj)  obj.onclick=CollectClick;
	obj=document.getElementById("Exit");
	if (obj) obj.onclick=ExitClick;
	obj=document.getElementById("RefuseBTN");
	if (obj) obj.onclick=RefuseClick;
	obj=document.getElementById("DispCat") ;
	if (obj) obj.onchange=DispCatonChanged; 
	objtbl=document.getElementById("t"+"dhcpha_phadispdocloc"); //lq
    if (objtbl) objtbl.ondblclick=setrefusedisp;
    var obj=document.getElementById("IncAlias"); //2007-08-21,zdm
	if (obj) 
	{	
		obj.onkeydown=popAlias;
	 	obj.onblur=AliasCheck;
	} 
	
	//发药科室
	var obj=document.getElementById("DispLoc"); 
	if (obj) 
	{
		obj.onkeydown=popDispLoc;
	 	obj.onblur=DispLocCheck;
	} 
	
	//第二发药人
	var obj=document.getElementById("CollectUser"); 
	if (obj) 
	{
		obj.onkeydown=popCollectUser;
	 	obj.onblur=CollectUserCheck;
	}
	
	//医生科室
	var obj=document.getElementById("DoctorLoc");
	if (obj) 
	{
		obj.onkeydown=popDoctorLoc;
	 	obj.onblur=DoctorLocCheck;
	} 
	
	obj=document.getElementById("RegNo");
	if (obj) 
	{
		obj.onblur=RegNoBlur;
		obj.onkeypress=RegNoBlur;
		
	}
	
	obj=document.getElementById("bodyloaded");
	if (obj.value!=1)
	{
		//GetDefLoc();
		//setDispCat();
		//setDefaultDate();    
	}
	
	setBodyLoaded();
	
	obj=document.getElementById("DispLoc");
	//if (obj) obj.focus();
	
	//设置发药类别
	
	//setObjectDisplay(false);
	
	getDocTotal();
   MakeDispItmTotalize();
	//setDispCat();
      var obj=document.getElementById("selectAll");          //add by hulihua 20140108
	if (obj) obj.onclick=SetSelectAll; 
	var obj=document.getElementById("cancelAll");          //add by hulihua 20140108
	if (obj) obj.onclick=CancelSelectAll;
      
  var objTotalPrn=document.getElementById("TotalPrn");    //汇总
  var objDetailPrn=document.getElementById("DetailPrn") ; //明细
  if(objTotalPrn){objTotalPrn.checked=true}
  if(objDetailPrn){objDetailPrn.checked=true}
}
function AliasCheck()
{
	//2007-8-21,zdm
	var obj=document.getElementById("IncAlias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";	}	
}
function popAlias()
{ 
	// 2007-08-21,zdm
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	    ////Alias_lookuphandler();
	    //IncAlias_lookuphandler();
	    window.event.isLookup=true;
	  	IncAlias_lookuphandler(window.event);  ///bianshuai 2015-12-02 修改 IE11无法弹出放大镜
	  	return false;
	}
	
}
function AliasLookupSelect(str)
{	
	//2007-8-21,zdm
	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}
}
function SelectRowHandler()
{
   var row=selectedRow(window)
  
   Savetofitler(row)
   CurrentRow=row;
    MakeDispItmTotalize();
}
function Savetofitler(row)
{
	//暂时保存发药时没有选择的医嘱Rowid

	var objsel=document.getElementById("Tselectz"+row)
	if (objsel.checked){var flag="D"}
	else{var flag="S"}
	var objoedis=document.getElementById("TDispIdStrz"+row)
	var oeori=objoedis.value;
	var objpid=document.getElementById("TPIDz"+row)
	var pid=objpid.value;
    //SAVE

	var xx=document.getElementById("mSavetoFilter");
    if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pid,oeori,flag) ;
	
}
//全选
function SetSelectAll(){
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
    }
  if (rowcnt>0)
  {
	  	for (i=1;i<=rowcnt;i++)
	  	{
		 	 var obj=document.getElementById("Tselect"+"z"+i)
		  	 if (obj) obj.checked=true ;
		  	 Savetofitler(i);
	 	 }	  	
  }
  MakeDispItmTotalize();
}
//取消全选
function CancelSelectAll(){
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
    }
  if (rowcnt>0)
  {
	  	for (i=1;i<=rowcnt;i++)
	  	{
		 	 var obj=document.getElementById("Tselect"+"z"+i)
		 	
		  	 if (obj) obj.checked=false ;
		  	 Savetofitler(i);
	 	 }	  	
  }
  MakeDispItmTotalize();
}
function popDispLoc()
{ 
	//回车弹出发药科室选择列表
	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	DispLoc_lookuphandler();
	  	
	}
}
function MakeDispItmTotalize()
{
	
	var obj=document.getElementById("TPID"+"z"+"1")
	if (obj)
	{
		var pid=obj.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadocloctotal&PID="+pid
		parent.frames['dhcpha.phadocloctotal'].window.document.location.href=lnk;
	}
	else 
	{
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadocloctotal&PID="
		parent.frames['dhcpha.phadocloctotal'].window.document.location.href=lnk;
	}

}
function DispLocCheck()
{
	
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{	if (obj.value=="") 
		{
			obj2.value="";
		}		
	}

	//发药科室失去焦点时设置发药类别
	//setDispCat();	
}
	
function popCollectUser()
{
	//回车弹出发药人选择列表
	
	if (window.event.keyCode==13) 
	{
		window.event.keyCode=117;
	  	CollectUser_lookuphandler();
	}
}

function CollectUserCheck()
{	
	var obj=document.getElementById("CollectUser");
	var obj2=document.getElementById("collectuserrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
}	

function popDoctorLoc()
{
	//回车弹出医生科室选择列表
	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	DoctorLoc_lookuphandler();
	}
}

function DoctorLocCheck()
{	
	var obj=document.getElementById("DoctorLoc");
	var obj2=document.getElementById("doctorlocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
}

function PrintClick()
{ 
	// 1 - save dispensing data 
  	// 2 - handle the stock data
  	// 3 - print dispensing list
  	// 
  	// ---获取打印方式,如发药前必须选一项,则放开
  	//var retPrnType=GetPrnType();
    //if (retPrnType==-1){ return;}
    //
     
  	var phacrowidStr=""
	var dispcats=document.getElementById("dispcatlist");
    if (dispcats)
    {
	    if ( dispcats.value=="") 
    	{	alert(t['NO_ANY_DISPCAT']) ;
	    	return ; 
		}
    }
    
    var catarr=dispcats.value.split("^");
    var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc") ;
    if (objtbl) var cnt=getRowcount(objtbl) ;
    else var cnt=0 ;
    var pid="" ;
   
    if (cnt>0) 
    {   var obj=document.getElementById("TPIDz"+1) ;   //process id
	    if (obj) pid=obj.value;    
	   //alert(pid)
	}
	else
	{	alert(t['NO_ANY_ROWS']) ;
		return;
	}
	
    if (pid=="")
    {	alert(t['NO_PID']) ;
    	return ;   	
    }
    
	if (confirm("是否确认发药?")==false)  return ;   
   
    //saveRefuse()  ; // Save the refused drug //zhouyg 20130514注释，拒绝时直接保存了
   
    var ss=[];
    for (var i=0;i<catarr.length;i++)
    {
		var cat=catarr[i];
		//alert(cat)

		var PhacRowid=SaveDispensing(cat,pid) ;
        
		if (PhacRowid>0 )
		{   
			//PrintReport(PhacRowid,cat) ;
         if(phacrowidStr!="") //2007-10-31
         {
           phacrowidStr=phacrowidStr+"A"+PhacRowid;}
           else
         { phacrowidStr=PhacRowid;	}

			
		}
		if (PhacRowid<0)
		{	
		 alert(getDispCatName(cat) + t['SAVE_FAILED']) ;
		} 
    }
    
   	
   //PrintReport(phacrowidStr,pid);	
     if(confirm("是否打印发药单？")){
 	PrintReport(phacrowidStr,pid);	
  }
      
	killTmpAfterSave(pid);

  	CollectClick();
  	PhaWard_Click()
}
//左侧刷新
function PhaWard_Click()
{
 parent.frames['dhcpha.phadocloc'].FindClick();
}
function killTmpAfterSave(pid)
{
	var xx=document.getElementById("mKillTmpAfterSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var PhacRowid=cspRunServerMethod(encmeth,'','',pid) ;
}

/*
function PrintReport(phac,pid)//lq
{

	var detailprn=0;totalprn=0;
	var objDetailPrn=document.getElementById("DetailPrn");
	var objTotalPrn=document.getElementById("TotalPrn");
	if (objDetailPrn.checked==true){var detailprn=1} 
	if (objTotalPrn.checked==true){var totalprn=1} // 获取打印方式
	
	
	var prthz=0
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintBJFC"+"&Phac="+phac+"&PrtHz="+prthz+"&RePrintFlag="+0+"&DetailPrn="+detailprn+"&TotalPrn="+totalprn+"&PID="+pid
	parent.frames['dhcpha.dispprintBJFC'].window.document.location.href=lnk;
}
*/
function PrintReport(phac,pid)
{
 
	var detailprn=0;totalprn=0;
	var objDetailPrn=document.getElementById("DetailPrn");
	var objTotalPrn=document.getElementById("TotalPrn");
	if (objTotalPrn)
	{
	    if (objDetailPrn.checked==true){var detailprn=1} 
	}
	if (objTotalPrn)
	{
		if (objTotalPrn.checked==true){var totalprn=1} // 获取打印方式
	}
	var prthz=0
	var reprintflag=""
	//var dispcats=document.getElementById("dispcatlist");
	//var catarr=dispcats.value.split("^");
	//var DispCat=""
       //for (var i=0;i<catarr.length;i++)
         //{
	//	var cat=catarr[i];
         //     if (DispCat==""){DispCat=cat}
         //     else {DispCat=DispCat+cat}
         //}
	
	//var DispCat=obj.value
	PrintRep(phac,reprintflag,pid,"");  //打印
	
}
function SaveDispensing(dispcat,pid)
{ 
	var colluser ;
	var obj=document.getElementById("collectuserrowid") ;
	if (obj) colluser=obj.value ;

	var xx=document.getElementById("mSaveDisp");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	
	var PhacRowid=cspRunServerMethod(encmeth,'','',dispcat,pid,colluser) ;

	return PhacRowid ;  
}

function isSaveOk(value)
{	
	if (value<=0) alert(t['SAVE_FAILED']) ; 
}
	
function ClearClick()
{
	// var obj=document.getElementById("t"+"dhcpha_phadisp")
	//if (obj) DelAllRows(obj)
	
	KillTmpGlobalBeforeRetrieve();
	ReloadWinow();
}

function ReloadWinow()
{	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadispdocloc" ;
	location.href=lnk;
}

function CollectClick()
{ 	
	//查找待发药品
	//
	if (CheckConditionBeforeDisp()==false) return
	
	KillTmpGlobalBeforeRetrieve();
	
  	Collect_click(); 
  	   
}

function CheckConditionBeforeDisp()
{ 
   	//发药科室不能为空
   
   	var obj;
   	obj=document.getElementById("displocrowid") ;
   	if (obj) 
   	{
	   	if (obj.value=="")
	   	 	{ 
	   	 		alert(t["NO_DISPLOC"]) ;
	   	    	return false;	   	 
	   	 	} 
   	}
  	
  	//医生科室不能为空
  	var objdoctorloc=document.getElementById("doctorlocrowid")
	if(objdoctorloc)
	{	
		if (objdoctorloc.value=="")
		{
			alert(t["PLEASE_SELECT_DOCTORLOC"]);
			return false;
		}
	}
	
	//起始日期不能为空
	var obj1=document.getElementById("StartDate") ;
	if (obj1.value=="" )
	{
		alert(t['NO_STARTDATE']) ;
	  	return false ;	
	} 
	
	//截止日期不能为空
	var obj2=document.getElementById("EndDate") ;
	if (obj2.value=="" )
	{
		alert(t['NO_ENDDATE']) ;
	  	return false  ;	
	} 
	
	//起始日期不能等于截止日期
    if (DateStringCompare(obj1.value,obj2.value )==1) 
    {
	    alert(t['INVALID_DATESCOPE']);
     	return  false ;
    }
  
    //该科室对应的发药类别不能为空
    var objDispCat=document.getElementById("dispcatlist");
    if(objDispCat)
	{
		
		if (objDispCat.value=="") 
		{
			alert(t['NO_DISPCATS']);
			//return  false ;	
		}
	}
	
	return true ;
}	
	
function ExitClick()
{
	history.back();
}

function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
	{
		if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
	
	setDispCat();
}

function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("bodyloaded") ;
	
	if (objBodyLoaded.value!=1)
	{
		var userid=session['LOGON.USERID'] ;
		var obj=document.getElementById("mGetDefaultLoc") ;
		
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
		objBodyLoaded.value=1;
	}
}

function setDefLoc(value)
{
	//设置默认发药科室
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=locdr
	
}

function CalcuDate(ss)
{	var obj=document.getElementById("mGetDate");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var date=cspRunServerMethod(encmeth,'','',ss) ;
	return date	
}
function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}
function KillTmpGlobalBeforeRetrieve()
{
	var pid=""; 
	var obj=document.getElementById("TPIDz"+1) ;
    if (obj) pid=obj.value;
    
    if (pid>0)
    {killTmpAfterSave(pid);
	    }
}

function DoctorLocLookUpSelect(str)
{
	var doctorloc=str.split("^")
	if (doctorloc.length>0)
	{
		var obj=document.getElementById("doctorlocrowid")
		if (obj) obj.value=doctorloc[1]
	}
}

function CollectUserLookUpSelect(str)
{
	var collectuser=str.split("^")
	if (collectuser.length>0)
	{
		var obj=document.getElementById("collectuserrowid")
		if (obj) obj.value=collectuser[1]
	}
}

function getPhaLocation(loc)
{ 
    var exe
	var obj=document.getElementById("mGetDispLocSet")
	if (obj) exe=obj.value;
	else exe='';
	
	var sss=cspRunServerMethod(exe,loc)
	return sss;
}

function setDefaultDate()
{
	var loc
	var obj=document.getElementById("displocrowid")
	if ((obj)&&(obj.value!=""))
	{
		loc=obj.value ;
	 	var sets=getPhaLocation(loc)
	 	//set
     	if (sets!="")
     	{
     		var ss=sets.split("^")
     		var sd ;
     		var ed;
     		         
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

function setDispCat()
{
	var loc;
	var obj=document.getElementById("displocrowid");
	if (obj) loc=obj.value
	else loc='';
	
	setDispCatList(loc);
	setListSelected();  
	DispCatonChanged();
}

function setDispCatList(loc)
{   
	//显示指定科室的发药类别
	
	var objloc=document.getElementById("mGetLocDispType");
	if (objloc) {var encmeth=objloc.value;}
	else {var encmeth=''};

	var result=cspRunServerMethod(encmeth,loc)  ;
	
	var disptype=result.split("!")
	var cnt=disptype.length
	
	var objDispCat=document.getElementById("DispCat") 
	if (objDispCat)
	{
		objDispCat.options.length=0;
		//objDispCat.options[0]=new Option ("","") ;
		for (i=0;i<cnt;i++) 
		{
			var drugGrp=disptype[i].split("^");
			var rowid=drugGrp[0];
			var desc=drugGrp[1];
		
			objDispCat.options[i]=new Option (desc,rowid) ;
		}
	}
}

function setListSelected()
{
	//设置listbox的所有项选中
	
	var objList=document.getElementById("DispCat");
	
	if(objList)
	{	
		for (i=0;i<objList.length;i++)
		{
			objList.options[i].selected=true;
		} 
	}

	
}

function DispCatonChanged()
{	
	var objlist=document.getElementById("DispCat");
	var obj=document.getElementById("dispcatlist");
	
	if (obj)obj.value=''
	else return;
	
	if(objlist)
	{
		for (i=0;i<objlist.length;i++)
		{
			if (objlist.options[i].selected==true)
			{
				if (obj.value=="")
				{	obj.value=objlist[i].value;}
				else
				{	obj.value=obj.value+"^"+objlist[i].value;}				
			}
		}
	}
}

function CalcuDate(ss)
{	var obj=document.getElementById("mGetDate");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var date=cspRunServerMethod(encmeth,'','',ss) ;
	return date	
}




function setRefuse()
{
	var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc")
	var row=selectedRow(window)
	
	if (!row) return;
	if (row<1) return
    
	var refuseFlag=getRefuseFlag(row)
	if (refuseFlag!="Y") {
		var ret=confirm("拒绝发放吗?");
		if (ret==true)
		{
			var obj=document.getElementById("TRefuseFlagz"+row)
			if (obj) obj.innerText="Y"
				
            // ------  控制关联医嘱
			var retstr=CheckLink(row).split("%");
			var rowcnt=retstr[0] ;
			if (rowcnt>1)
			{
				 var ret2=confirm("是否拒绝关联医嘱?");
			
				 if (ret2==true)
				   {
					 var cnt=getRowcount(objtbl) ;
					 for (var i=1;i<=cnt;i++)
					   {
						 var objoe=document.getElementById("Toedisz"+i)					
	                     a=retstr[1].indexOf(objoe.value)
	                     var obj=document.getElementById("TRefuseFlagz"+i)
	                     if ((a>=0)){  obj.innerText="Y";
	                                 row=row+"^"+i; }                  					
						}
					}
				  else{rowcnt=1;}
			  
			 }
			 
			 var row=rowcnt+"^"+row
			 
			 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason&MainRow="+row
			 window.open(lnk,"_blank","height=300,width=300,menubar=no,status=yes,toolbar=no,resizable=yes") ;
			 
			
		}
		
	}
	else
	{
		var ret=confirm("取消拒绝发放吗");
		if (ret==true)
		{
			// ------  控制关联医嘱
			var retstr=CheckLink(row).split("%");
			if (retstr[0]>1)
			{
				var cnt=getRowcount(objtbl) ;
				for (var i=1;i<=cnt;i++)
				{
					var objoe=document.getElementById("Toedisz"+i)					
					a=retstr[1].indexOf(objoe.value)
	                    if (a>=0)
	                    {
		                    var obj=document.getElementById("TRefuseFlagz"+i)
					        if (obj) obj.innerText=""
					        var obj=document.getElementById("TRefuseReasonDescz"+i)
		                    if (obj) obj.innerText=""

	                    
	                    }
     
                   }                  					

	     }

			
			var obj=document.getElementById("TRefuseFlagz"+row)
			if (obj) obj.innerText=""
			var obj=document.getElementById("TRefuseReasonDescz"+row)
            if (obj) obj.innerText=""
            

		     			
		 }
		 
		}
 
}
function setrefusedisp()
{
	
	//var row=CurrentRow
	var row=selectedRow(window)
	
	if (!row) return;
	if (row<1) return
    
	var refuseFlag=getRefuseFlag(row)
    var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc") 
	var ret=confirm("拒绝发放吗?");
	if (ret==true)
	{
			var obj=document.getElementById("TRefuseFlagz"+row)
			//if (obj) obj.innerText="Y"
				
            // ------  控制关联医嘱
			var retstr=CheckLink(row).split("%");
			var rowcnt=retstr[0] ;
			if (rowcnt>1)
			{
				 var ret2=confirm("是否拒绝关联医嘱?");
			
				 if (ret2==true)
				   {
					 var cnt=getRowcount(objtbl) ;
					 for (var i=1;i<=cnt;i++)
					   {
						 var objoe=document.getElementById("Toedisz"+i)					
	                     a=retstr[1].indexOf(objoe.value)
	                     var obj=document.getElementById("TRefuseFlagz"+i)
	                     if ((a>=0)){ //obj.innerText="Y";
	                                 row=row+"^"+i; }                  					
						}
					}
			
			  
			 }
			 
			 // ------
			 
			 var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason','','dialogHeight:550px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
			 if (!resondr) return;
			 if (resondr!="")
			 {
				 var restmp=resondr.split("^")
				 resondr=restmp[0]
				 resondesc=restmp[1]
			 }
			 
             if (!(resondr>0)) return;
             
             var userid=session['LOGON.USERID']
              
             if (row>0)
             {
	             
	                 var objoe=document.getElementById("TDispIdStrz"+row)
				     var oedis=objoe.value;
				     
	            	 var ret=SaveRefuseMod(oedis,userid,resondr)

	                 if (ret!=0)
			         {
				         alert("拒绝失败")
			         }
			         else
			         {
				         //alert("拒绝成功")
				         ChangeColor(row,resondesc);
			         }
             }
             
	         else
	         {
			         var rowarr=row.split("^");
			         var rowcnt=rowarr.length;
		         
			         for (var l=0;l<rowcnt;l++)
			         {
				         var tmprow=rowarr[l]
				         var objoe=document.getElementById("TDispIdStrz"+tmprow)   //zdm,2012-03-05,参数传dhc_oedispensing表id
				         var oedis=objoe.value;
				         ret=0
				         var ret=SaveRefuseMod(oedis,userid,resondr)
				         
				         if (ret!=0)
				         {
					         alert("拒绝失败")
				         }
				         else
				         {
					         //alert("拒绝成功")
					         ChangeColor(tmprow,resondesc);
				         }
			          }
	         }
		}
}
function ChangeColor(k,resondesc)
{
	   k = parseInt(k)
	   var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc") 
	   if (objtbl) objtbl.rows(k).style.backgroundColor="#ffc0c0";
	   
	   var objdesc=document.getElementById("TRefuseReasonDesc"+"z"+k)
	   if (objdesc) {objdesc.innerText=resondesc; }
	   var objFlag=document.getElementById("TRefuseFlagz"+k);
	   if (objFlag) {objFlag.innerText="Y"}
}

function CheckLink(row)
{
	///Description:判断是否关联医嘱
	var objoedis=document.getElementById("Toedisz"+row)
	var oedis=objoedis.value
	var xx=document.getElementById("mChecklink");
    if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,oedis) ;
    return result
} 
function SaveRefuseMod(oedis,userid,refreason)
{
	var xx=document.getElementById("mSaveRefuse");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,'','',oedis,userid,refreason) ;
	return  result
	
}

function saveRefuse()
{   
	//lq
	var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc") 
	
	if (objtbl) var cnt=getRowcount(objtbl) ;
	
	if (cnt<1) return ;
	for (var i=1;i<=cnt;i++)
	{  	if (getRefuseFlag(i)=="Y" )
		{
			var obj=document.getElementById("TDispIdStrz"+i)
			var oedis=obj.value;
			var userid=session['LOGON.USERID'] ;
			
			var obj=document.getElementById("TRefuseReason"+"z"+i)
			
			if (obj) refreason=obj.value;			
			var xx=document.getElementById("mSaveRefuse");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,'','',oedis,userid,refreason) ;
		    
		}
	}
}

function getRefuseFlag(row)
{
	var obj=document.getElementById("TRefuseFlagz"+row)
	return obj.innerText
	}
function GetPrnType()
{
	///descrition:获取打印方式
	///return?-1 -- 如果没有选择打印方式,则退出不执行
	///creator:lq 08-10-10
	var objDetailPrn=document.getElementById("DetailPrn");
	var objTotalPrn=document.getElementById("TotalPrn");
	if ((objDetailPrn.checked==false)&&(objTotalPrn.checked==false))
	{   alert("请选择打印方式<打印汇总> <打印明细>")
		return -1;} 
}

function setObjectDisplay(b)
{  if (b==false)
   	{ 
	   window.document.all("Collect").style.display="none" 
     }
   else
   {  
   	window.document.all("RegNo").style.display="inline"

 	}
}
function getDocTotal()
{
	var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc") ;
    if (objtbl) var cnt=getRowcount(objtbl) ;
    if (cnt<1)
    { var pid="" }
    else
    {
		var objPID=document.getElementById("TPID"+"z"+1);
		pid=objPID.value;
    }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadocloctotal"+"&PID="+pid
	parent.frames['dhcpha.phadocloctotal'].window.document.location.href=lnk
}

function RegNoBlur()
{
	if (window.event.keyCode==13)
	{ 
		var objregno=document.getElementById("RegNo") ;
		var regno,displocrowid ;
		if (objregno) regno=objregno.value ;
		if (regno=="")
		{ 
			 return ;
		}
		else
		{ 
		  regno=getRegNo(regno) ;
		  objregno.value=regno
		  CollectClick();
	    }
	    
	}
}
function IncAlias_lookupsel(value) {
	try {
		var obj=document.getElementById('IncAlias');
		if (obj) {
  			obj.value=unescape(value);
			if (obj.readOnly) {obj.className='clsReadOnly'} else {obj.className=''}
			if (doneInit) websys_nextfocusElement(obj);
		}
	} catch(e) {};
}
function RefuseClick(){
	var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_phadispdocloc")
  if (objtbl)
  {
      rowcnt=getRowcount(objtbl)
  }
  var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason','','dialogHeight:550px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
  if (!resondr) return;
  if (resondr!="")
  {
       var restmp=resondr.split("^")
       resondr=restmp[0]
       resondesc=restmp[1]
  }
  var userid=session['LOGON.USERID']           
  if (rowcnt>0)
  {
        for (i=1;i<=rowcnt;i++)
        {
             var obj=document.getElementById("Tselect"+"z"+i)
             if (obj.checked==true)
             {
                     var objoe=document.getElementById("TDispIdStrz"+i)
                     var oedis=objoe.value;
                     tkMakeServerCall("web.DHCSTPCHCOLLS2","InsertDrugRefuse","","",oedis,userid,resondr)
             };
         }      
  }
  CollectClick();	
}
document.body.onload=BodyLoadHandler;


