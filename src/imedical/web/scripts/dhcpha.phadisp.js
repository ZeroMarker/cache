// dhcpha.phadisp.js
// 住院发药
var xscroll	=1
var CurrentRow;
var m_SelectCardTypeDR="";
var m_CardNoLength=0;

function BodyLoadHandler()
{	
	var obj;
    obj=document.getElementById("ByRegNo");
	if (obj) obj.onclick=setRegNoVisible;
	obj=document.getElementById("CLear");
	if (obj) obj.onclick=ClearClick;
	obj=document.getElementById("DispQuery");
	if (obj) obj.onclick=DispQueryClick;
	
	obj=document.getElementById("Print");
	if (obj) obj.onclick=PrintClick;
	obj=document.getElementById("Collect");
	if (obj)  obj.onclick=CollectClick;
	obj=document.getElementById("RegNo");
	if (obj) obj.onblur=RegNoBlur;
	obj=document.getElementById("Exit");
	if (obj) obj.onclick=ExitClick;
	
	
	obj=document.getElementById("RegNo");
	if (obj) obj.readOnly=true;
	
	var obj=document.getElementById("LongOrd")
	if (obj) obj.onclick=setLongOrd;
	var obj=document.getElementById("ShortOrd")
	if (obj) obj.onclick=setShortOrd;
	var obj=document.getElementById("OutWithDrugOrd")
	if (obj) obj.onclick=setOutWithDrug;
	var obj=document.getElementById("EmOrd");
	if (obj) obj.onclick=setEmOrd;
	var obj=document.getElementById("ISPACK");
	if (obj) obj.onclick=setISPACK;
	var obj=document.getElementById("NOPACK");
	if (obj) obj.onclick=setNOPACK;
	var obj=document.getElementById("scroll");
	if (obj) obj.onclick=SetFrame;
	
	var obj=document.getElementById("selectAll");          //dyd selectAll
	if (obj) obj.onclick=SetSelectAll; 
	var obj=document.getElementById("cancelAll");          //dyd cancelAll
	if (obj) obj.onclick=CancelSelectAll;
	obj=document.getElementById("PaInfo");
	if (obj) obj.readOnly=true;
	
	objtbl=document.getElementById("t"+"dhcpha_phadisp");
	if (objtbl) objtbl.ondblclick=setrefusedisp;
	
	var obj=document.getElementById("RefuseDisp");
	if (obj) obj.onclick=RefuseClick;

	var obj=document.getElementById("Ward"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=wardCheck;
	} //2005-05-26
	
	var obj=document.getElementById("DispLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;
	} //2005-05-26
	
	var obj=document.getElementById("CollectUser"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popCollectUser;
	 obj.onblur=CollectUserCheck;
	} //2005-05-26
	
	var obj=document.getElementById("Alias"); //2007-08-21,zdm
	if (obj) 
	{	
		obj.onkeydown=popAlias;
	 	obj.onblur=AliasCheck;
	} 
	var obj=document.getElementById("bddCollect");
	if (obj) obj.onclick=setBddCollect;
	var obj=document.getElementById("bddDisp");
	if (obj) obj.onclick=setBddDisp;
	///读卡
	var  ReadCardobj=document.getElementById("BReadCard");
    if (ReadCardobj) ReadCardobj.onclick= ReadHFMagCard_Click;
    
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
    loadCardType();
    CardTypeDefine_OnChange();
    ///
	obj=document.getElementById("BodyLoaded");
	
	if (obj.value!=1)
	{
		//GetDefLoc();  //2007-03-20
		
		/* SetDefaultVal();          2007-01-12 rem  */
		
		//setDefaultValByLoc();     //2007-01-12 
	}
	
	setBodyLoaded();
	
	obj=document.getElementById("DispLoc");
	//if (obj) obj.focus();
	
	getAdmAtStart();
    MakeDispItmTotalize();
    //InitForm();
    //getNoStkColor();  /// lq  08-10-27
    setDefaultValByLoc(); 
	//setDefaultCancel(); //Savetofitler(row)
	//SetSelectAll();///zhouxin 2012-01-19
	
	document.onkeydown=OnKeyDownHandler; 

}



function OnKeyDownHandler(e)
{
       var key=websys_getKey(e);
       if (key==115){ReadHFMagCard_Click();}	//F4 
       
}

//zdm,2012-03-28,将设置颜色和设置全选合在一个方法里处理，
//减少循环
function InitForm()   
{
	///如果" TinciQty "列等于0 ,则为库存不足,上色 
	var objtbl=document.getElementById("t"+"dhcpha_phadisp")
	if (objtbl)
	{ 
	     var cnt=objtbl.rows.length-1;
	     for (var i=1;i<=cnt; i++) 
	          {
		     
		           var objNostk=document.getElementById("TinciQty"+"z"+i)
		           if  (objNostk.value==0){
			     
					//var obj=document.getElementById("TWard"+"z"+1) ;
					//if (obj){
					//	obj.style.backgroundColor="#80f0c0";	}
					//objtbl.rows(1).cells(j).style.display="none";
					objtbl.rows(i).style.backgroundColor="#80f0c0"; }
					

					var objarcEndDateFlag=document.getElementById("TarcEndDateFlag"+"z"+i)
		            if  (objarcEndDateFlag.value==1)
		            {
					  objtbl.rows(i).style.backgroundColor="deepskyblue"; 
	                }      
	               
	                //设置全选
	                var obj=document.getElementById("Tselect"+"z"+i)
		  	 		if (obj) obj.checked=true ;
	          }
  
    }

}

//not select
function setDefaultCancel()   
{
	var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_phadisp")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
    }
  if (rowcnt>0)
  {
	  	for (i=1;i<=rowcnt;i++)
	  	{
		 	 var obj=document.getElementById("TSelect"+"z"+i)
		  	 if (obj) obj.checked=false ;
		  	 Savetofitler(i);
	 	 }	  	
  }
  MakeDispItmTotalize();
}

function AliasCheck()
{
	//2007-8-21,zdm
	var obj=document.getElementById("Alias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";	}
	
}

function popAlias()
{ 
	// 2007-08-21,zdm
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Alias_lookuphandler();
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
//全选
function SetSelectAll(){
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_phadisp")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
    }
  if (rowcnt>0)
  {
	  	for (i=1;i<=rowcnt;i++)
	  	{
		 	 var obj=document.getElementById("Tselect"+"z"+i)
		  	 if (obj) obj.checked=true ;
		  	 Savetofitler(i);  //zdm,2012-03-28,不需要？
	 	 }	  	
  }
  MakeDispItmTotalize();
}
//取消全选
function CancelSelectAll(){
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_phadisp")
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

function popWard()     
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
	}//2006-05-26

function popDispLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}//2006-05-26
function wardCheck()
{// 2006-05-26
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

	}// 2006-05-26
function DispLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
	
function popCollectUser()
{
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  CollectUser_lookuphandler();
	}// 2006-05-26
}

function CollectUserCheck()
{	// 2006-05-26
    
	var obj=document.getElementById("CollectUser");
	var obj2=document.getElementById("CollectUserRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	}	

function popDoctorLoc()
{
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DoctorLoc_lookuphandler();
	}// 2006-05-26
}
function DoctorLocCheck()
{	// 2006-05-26
	var obj=document.getElementById("DoctorLoc");
	var obj2=document.getElementById("DoctorLocRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
}

function getAdmAtStart()
{
	//this function is used to avoid losing
	//the administrative info when loading
	//
	var obj1=document.getElementById("ByRegNo");
  	var obj2=document.getElementById("RegNo") ;
  	
  	if ((obj1)&&(obj2)) 
  	{
	 if ((obj1.checked==true)&&(obj2.value!="")) 	
	  	{
		  	RegNoBlur();
		  	setAdmInfosDisplay(true)}
	 else
	  {setAdmInfosDisplay(false) ;}
  	}	
}



function SaveRefuseMod(oedis,userid,refreason)
{
	var tmp=oedis+"^"+userid+"^"+refreason;
	var xx=document.getElementById("mSaveRefuse");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,'','',oedis,userid,refreason) ;
	return  result
	
}

function ChangeColor(k,resondesc)
{
	   k = parseInt(k)
	   var objtbl=document.getElementById("t"+"dhcpha_phadisp") 
	   if (objtbl) objtbl.rows(k).style.backgroundColor="#ffc0c0";
	   
	   var objdesc=document.getElementById("TRefuseReasonDesc"+"z"+k)
	   if (objdesc) {objdesc.innerText=resondesc; }
      
         
}

function setrefusedisp()
{
	
	var row=CurrentRow;
	//var row=selectedRow(window)
	if (!row) {alert("请选择需要拒绝的明细后重试！"); return;}
	if (row<1) {alert("请选择需要拒绝的明细后重试！"); return;}
    
	var refuseFlag=getRefuseFlag(row)
    var objtbl=document.getElementById("t"+"dhcpha_phadisp") 
	var ret=confirm(t['IF_REFUSE']);
	if (ret==true)
	{
			var obj=document.getElementById("TRefuseFlagz"+row)
			//if (obj) obj.innerText="Y"
				
            // ------  控制关联医嘱
			var retstr=CheckLink(row).split("%");
			var rowcnt=retstr[0] ;
			if (rowcnt>1)
			{
				 var ret2=true; //confirm("是否拒绝关联医嘱?");
			
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
 //此处已不用,yunhaibao20160305
 /*
function setRefuse()
{
	var objtbl=document.getElementById("t"+"dhcpha_phadisp")
	var row=selectedRow(window)
	
	
	if (!row) return;
	if (row<1) return
    
	var refuseFlag=getRefuseFlag(row)
	if (refuseFlag!="Y") {
		var ret=confirm(t['IF_REFUSE']);
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
	                     if ((a>=0)){ obj.innerText="Y";
	                                 row=row+"^"+i; }                  					
						}
					}
				  else{rowcnt=1;}
			  
			 }
			 
			 var row=rowcnt+"^"+row
			 
			 // ------
			 
			 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason&MainRow="+row
			 window.open(lnk,"_blank","height=300,width=300,menubar=no,status=yes,toolbar=no,resizable=yes") ;
			
		}
	}
	else
		{
		var ret=confirm(t['CANCEL_REFUSE']);
		if (ret==true)
		{
			// ------  控制关联医嘱
			var retstr=CheckLink(row).split("%");
			
			if (retstr[0]>1){
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
		                    
		                    for  (var h=1;h<=objtbl.cells.length; h++)
					         {  
					            if (objtbl.rows(i).cells(h))
					              		{
						              		objtbl.rows(i).cells(h).style.backgroundColor="#FBFFFD";
						              	} 
					         }
	             
	                    
	                    }
                    

     
                   }                  					

	     }
			
			//------
					
			
			var obj=document.getElementById("TRefuseFlagz"+row)
			if (obj) obj.innerText=""
			var obj=document.getElementById("TRefuseReasonDescz"+row)
            if (obj) obj.innerText=""
            
		    for  (var h=1;h<=objtbl.cells.length; h++)
             {  
              	if (objtbl.rows(row).cells(h))
              		{
	              		objtbl.rows(row).cells(h).style.backgroundColor="#FBFFFD";
	              	} 
             }
		     			
		 }
		 
		}
 
}
*/
function saveRefuse()
{   
	var objtbl=document.getElementById("t"+"dhcpha_phadisp") 
	if (objtbl) var cnt=getRowcount(objtbl) ;
	if (cnt<1) return ;
	for (var i=1;i<=cnt;i++)
	{  	if (getRefuseFlag(i)=="Y" )
		{
			var obj=document.getElementById("Toedisz"+i)
			var oedis=obj.value;
			var userid=session['LOGON.USERID'] ;
			var refreason;
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
function DispQueryClick()
{OpenDispQuery();
	} 
function DispStatClick()
{OpenDispStat();
	}
function ParaSetupClick()
{
	OpenParaSetup();}


function setRegNoVisible()
{   
	var obj=document.getElementById("ByRegNo");
	var obj1=document.getElementById("RegNo");
	//var obj2=document.getElementById("Adms");
	if ((obj.checked))
	{  if (obj1) 	obj1.readOnly=false;
	   obj1.value="" ;
	// if (obj2)	obj2.style.display="inline";
		var obj3=document.getElementById("Ward") ;
		if (obj3) { obj3.value="" ;
			obj3.disabled=true ;
			 }
		var obj4=document.getElementById("wardrowid") ;
		//if (obj4) obj4.value=""; //yunhaibao20161031
		
		setAdmInfosDisplay(true);
		obj1.focus();
	}
	else	 
	{
	   if (obj1) obj1.readOnly=true ;
	   obj1.value="" ;
   	   RegNoBlur();
	   var obj=document.getElementById("Ward") ;
	   if (obj) { obj.disabled=false ;
	   			 obj.readOnly=false ;
	   			 obj.focus();  } 
	   
		setAdmInfosDisplay(false);
	}
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

function PrintClick(printflag)
{
	// ---获取打印方式,如发药前必须选一项,则放开	 
	// var retPrnType=GetPrnType();
	// if (retPrnType==-1){ return;}
	 var phacrowidStr="";
	 var parastr="";
	 var dispuserflag=""; 
	 var operaterflag="";
	// 1 - save dispensing data 
    // 2 - handle the stock data
    // 3 - print dispensing list 
    // 
	//var dispcats=getCatSelected();   以前的版本用;
	//
	
	obj=document.getElementById("Dispensing");
	if (obj) var printflag=0 ;
	obj=document.getElementById("Print");
	if (obj) var printflag=1 ;
	
	
	 var objtbl=document.getElementById("t"+"dhcpha_phadisp") ;
	 if (objtbl) var cnt=getRowcount(objtbl) ;
	 else var cnt=0 ;
	 var pid="" ;
	 if (cnt>0) 
		 {  
			  var obj=document.getElementById("TPIDz"+1) ;
			  if (obj) pid=obj.value;    
		 }
	 else
		 {
			   alert(t['NO_ANY_ROWS']) ;
			   return;	
		 }		
	 if (pid=="")
		 {	
		    alert(t['NO_PID']) ;
		 	return ;   
		 }
    var objregno=document.getElementById("RegNo") ;
	var regno="";
	if (objregno) regno=objregno.value ;
	if(regno!="")
	{
     	var getadm=document.getElementById('mGetAdm');
		if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'SetAdm','',regno)=='0') {}
		var objadm=document.getElementById("Adms") ;
		if(objadm)var adm=objadm.value;
		     var ret=RetBillControl(pid,adm);        //欠费控制
		}
	if(ret=="N"){
		alert("已欠费");
		return;
	}
	 //取发药类别
     var obj=document.getElementById("DispCat");
     var dispcatsStr=obj.value;
     dispcatArr=dispcatsStr.split("#");
     var dispcats=dispcatArr[0];
	 if ( dispcats==""){
		    alert(t['NO_ANY_DISPCAT']) ;
		    return ;
	}
	
	 var catarr=dispcats.split("^");
     //取是否录入发药人配置
     var objpara=document.getElementById("ParaStr");
	 if (objpara) parastr=objpara.value;
	 if (parastr!="")
	 {
		 var tmparr=parastr.split("^");
		 dispuserflag=tmparr[0];
		 operaterflag=tmparr[1];
	 }
	 if (confirm("是否确认发药?")==false)  return ;
     if (dispuserflag=="Y")
     {
		 if (showUserDialog()==""){return;}  //录入发药人
     }
     //取是否录入摆药人配置
     if (operaterflag=="Y")
     {
	     if (showOperaterDialog()==""){return;}  //录入摆药人
	 }
	 // -----  出院带药
	 var objdrugout=document.getElementById("OutWithDrugFlag")
	 var lks=objdrugout.value
	 if (objdrugout.value=="1")
		{  
			PrintOutDrug(); 
			return;
		}
	 // -----	
	 //saveRefuse()  ; // Save the refused drug  zhouyg 2013-05-14注释，拒绝时直接保存了

	 /*var objret=document.getElementById("RetFlag");
	 if( (objret)&&(objret.checked==true))
	  {
		  ExeRetBeforeDisp();  //Exe the Return Before Disp
	  }
	  */
	 //发药
     var ss=[];
	 var obj=document.getElementById("wardrowid")
	 var wardstr=obj.value
	 var wardlist=wardstr.split("^")
     var catid=dispcatArr[2]
	 //发药前判断发药类别重新界面获取,yunhaibao2016025
	 var TopFrame=parent.frames['dhcpha.phaward1'];
	 var checkobj=TopFrame.document.getElementById("t"+"dhcpha_phaward1")
	 var checkcnt=getRowcount(checkobj);
	 for(var tmpk=0;tmpk<=checkcnt;tmpk++){
		 var obj=TopFrame.document.getElementById("TWardRowid"+"z"+tmpk)
	     var tmpwardid=""
	     if (obj) var tmpwardid=obj.value;
	     if (wardlist.indexOf(tmpwardid)>=0)
	     {
			var tmpj=0;
			var checkedcats="";	
			for(tmpj=0;tmpj<10;tmpj++)
			{
				var objCheck=TopFrame.document.getElementById("TCat"+tmpj+"z"+tmpk);
				if (objCheck)
				{			    
					if(objCheck.checked==true)
					{  			    
						var objCat=TopFrame.document.getElementById("Cat"+tmpj+"RowID");	
						if(objCat){checkedcats=checkedcats+"^"+objCat.value; }				 
					}
				}
			}
			checkedcats.Trim;
			var checkedcatsstr=checkedcats.substring(1,checkedcats.length)
		 	var resavecheckcats=tkMakeServerCall("web.DHCSTPCHCOLLS","SaveCatListByWard",tmpwardid,checkedcatsstr,catid);
		 }
     
	 }
	 //wyx 增加wardid选择多病区时发药控制
     for (var j=0;j<wardlist.length;j++)
     {
	   var wardid=wardlist[j]
	   if(regno==""){
		    var catstr=tkMakeServerCall("web.DHCSTPCHCOLLS","GetWardDispType",catid,wardid); //js里直接调用类的方法
	   		var catarr=catstr.split("^");
	   } 	   
	   for (var i=0;i<catarr.length;i++)
	   {
		   		var cat=catarr[i];
				if (cat==""){alert("选择的第"+(j+1)+"条病区记录发药类别为空,请本次发药完成后重试!");continue;}
				var PhacRowid=SaveDispensing(cat,pid,wardid) ;
				if (PhacRowid!=0 )
				{  //if (OutDrugFlag!=1) PrintReport(PhacRowid,cat) ;
						if(phacrowidStr!="")
						{	phacrowidStr=phacrowidStr+"A"+PhacRowid;		}
						else
						{	phacrowidStr=PhacRowid;					}
				}
				
				if (PhacRowid<0)
				{	
				 alert(getDispCatName(cat) + t['SAVE_FAILED']+PhacRowid) ;
				} 
	  }
    }
    if (phacrowidStr==""){alert("未发出药品!");return;}
	var objret=document.getElementById("RetFlag");
	if (objret){
		if(objret.checked==true){
			ExeRetAfterDisp(pid,phacrowidStr);  //Exe the Return After Disp zhouyg 2012-8-8
		}
	}
    if (confirm("是否打印"))
	{
		PrintReport(phacrowidStr,pid);
	}
 	GetTipsOfNoStock(pid);
	SendOrderToMechine(phacrowidStr);
	killTmpAfterSave(pid);

	CollectClick();
	

}
//左侧刷新
function PhaWard_Click()
{
 parent.frames['dhcpha.phaward'].Find_Click();
}
///Description: 发药后退药
///Creator:		zhouyg
///CreatDate:	2011-08-08
///Input:		phacstr-发药主表ID的字符串
function ExeRetAfterDisp(pid,phacstr)
{
      var colluser="";
	  var obj=document.getElementById("CollectUserRowid") ;
	  if (obj) colluser=obj.value ;
	  if (colluser=="") var colluser=session['LOGON.USERID'] ;
      var xx=document.getElementById("mExeRetAfterDisp");
	  if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	  var PhacRowid=cspRunServerMethod(encmeth,pid,phacstr,colluser) ;    
}
function WaitSomeTime()
{
	var n=20000;
	while(n>0)
	{n--;}
}

function killTmpAfterSave(pid)
{
	var xx=document.getElementById("mKillTmpAfterSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var PhacRowid=cspRunServerMethod(encmeth,'','',pid) ;
}
function getDispCatName(cat)
{
	var obj=document.getElementById("DispCatList");
	if (obj) 
	{
		var ss=obj.value ;
		var catlist=ss.split("^");
		var i=0
		while (i<=catlist.length)
		 {
			if (catlist[i]==cat)
			{var obj=document.getElementById("c"+"cat"+i);
				if (obj) catname=obj.innerText;	 }
		 }
	}
	return catname
}
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
	var obj=document.getElementById("DispCat");
	var DispCat=obj.value
	PrintRep(phac,reprintflag,pid,DispCat);  //打印
}

function SaveDispensing1(dispcat,pid)
{ 
   //
	var colluser ;
	
	var obj=document.getElementById("CollectUserRowid") ;
	if (obj) colluser=obj.value ;
	var xx=document.getElementById("mSaveDisp");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var obj=document.getElementById("displocrowid");
	if(obj) var loc=obj.value;
	var PhacRowid=cspRunServerMethod(encmeth,'','',dispcat,pid,colluser,"") ;
	return PhacRowid ;  
}
function isSaveOk(value)
{	if (value<=0) alert(t['SAVE_FAILED']) ; 
}	
function ClearClick()
{
	// var obj=document.getElementById("t"+"dhcpha_phadisp")
	//if (obj) DelAllRows(obj)

	KillTmpGlobalBeforeRetrieve();
	ReloadWinow();
}
function ReloadWinow()
{	
 	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadisp";
	location.href=lnk;
}
function OpenDispQuery()
{ var lnk="dhcpha.dispquery.csp";
   window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	}
function OpenDispStat()
{var lnk="dhcpha.dispstat.csp";
   //location.href=lnk;
  window.open(lnk,"_target","height=600,width=1000,menubar=no,status=no,toolbar=no") ;
  // window.open(lnk,"_target");
   }
function OpenParaSetup()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispparameter"
   window.open(lnk,"_BLANK") ;}

function CollectClick()
{ //发药
	 var obj=document.getElementById("DispCat")

	
	if (CheckConditionBeforeDisp()==false) return 
	
	KillTmpGlobalBeforeRetrieve();
	//
	//var DispCat=getCatSelected();
	
	var obj=document.getElementById("DispCat");
	var DispCat=obj.value
	//if (obj) obj.value=DispCat ;
	
	//
	//Adm Value Set
	//
	var obj=document.getElementById("ByRegNo");
	if ((obj)&&(obj.checked==true))
	{	var objadm=document.getElementById("Adms");
		if ((objadm)&&(objadm.options.selectedIndex>=0)) var Adm=objadm.value ;
			
			var DispCat=getCatSelected();
			
			var docu=parent.frames['dhcpha.phaward'].document
			
			var pri="";
			var objpri=docu.getElementById("pri");
			if(objpri) {pri=objpri.value;}

			var DispCat=DispCat+"#"+pri
			
			var obj=document.getElementById("DispCat");
			if (obj) obj.value=DispCat ;
			
			
	}
	else
	
	{var Adm=""}
	var obj=document.getElementById("Adm");
	if (obj) obj.value=Adm ;
	
  	Collect_click();
 }

function CheckConditionBeforeDisp()
{ 

   var obj;
   obj=document.getElementById("displocrowid") ;
   if (obj) 
     {if (obj.value=="")
	   	 {alert(t["NO_DISPLOC"]) ;
	   	    return false;	   	 } 
     }
   obj=document.getElementById("wardrowid") ;
   objbyadm=document.getElementById("ByRegNo") ;
   
   if (objbyadm)
   {
	   if (objbyadm.checked==true)
	   {	var objregno=document.getElementById("RegNo");
		   if (objregno.value=="")
		   {alert(t['NO_REGNO']) ; 
		    return false;}
		}
    
  }

    var docu=parent.frames['dhcpha.phaward'].document
   
	var obj1=docu.getElementById("StartDate") ;
	if (obj1.value=="" )
	{alert(t['NO_STARTDATE']) ;
	  return false ;	} 
	var obj2=docu.getElementById("EndDate") ;
	if (obj2.value=="" )
	{alert(t['NO_ENDDATE']) ;
	  return false  ;	} 
    if (DateStringCompare(obj1.value,obj2.value )==1) 
    {alert(t['INVALID_DATESCOPE']);
     return  false ;}
     
     var objsd=document.getElementById("StartDate") ;
     objsd.value=obj1.value
     var objed=document.getElementById("EndDate") ;
     objed.value=obj2.value
     
     
     //if select category for dispensing .
     //
    // --------以前的版式本用------
	//if (DispCatSelected()==false) 
	//{alert(t['NO_DISPCATS']);
	//	return  false ;	}
	//------------

    //One type of order priority must be selected, for ShaoGuan YueBei Hospital
	//order priority -2006-09-27
	var obja=document.getElementById("LongOrdFlag")
	var objb=document.getElementById("ShortOrdFlag")
	var objc=document.getElementById("OutWithDrugFlag")
	var objpara=document.getElementById("ParaStr")
	if(objpara) var para=objpara.value;
	var paraArray=para.split("^");
	var DispDefault=paraArray[8];
	var lsflag=paraArray[6];
	var ss;
	ss=objb.value.split("||")
	
	//if ((obja.value!='1')&&(objb.value!='1')&&(objc.value!='1'))
	//zhouyg 20141217 只有长临嘱必选其一的时候才强制按默认值设置
	if ((lsflag=="Y")&&(DispDefault!=2)&&(obja.value!='1')&&(ss[0]!='1')&&(objc.value!='1'))
	{
		
		//1.--One type of order priority must be selected, for ShaoGuan YueBei Hospital
		//alert(t['NOPRIORITY']) ;
		//return false;  //      
		
		//2.--不选的情况下默认值
		//var config=GetPhaConfig("Con_DispDefault")		
		if (DispDefault==0)
			{
			     var objShortOrd=document.getElementById("ShortOrd")
	             if (objShortOrd)
	             {
					objShortOrd.checked=true;
					setShortOrd();
		         	//objShortOrd.click();
	             }	
			}
		if (DispDefault==1)
			{
			     var objLongOrd=document.getElementById("LongOrd")
	             if (objLongOrd)
	             {
		             objLongOrd.checked=true;
		             setLongOrd();
		             //objLongOrd.click(); 
	             }
			}

	}
	//order priority -2006-09-27
 
	
	return true ;
}	
   
function DispCatSelected()
{ // check if the disp cat has been selected 
	var catlist=getCatSelected();
	if (catlist=="") return false;
	return true ;
	}
function ExitClick()
{history.back();}
function ClearAdm()
{ obj=document.getElementById("PaInfo") ;
	   if (obj) obj.value="" ;
	   obj=document.getElementById("Adms") ;
	   if (obj) obj.options.length=0 ;
	}

function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	var objregno=document.getElementById("RegNo") ;
	var regno,displocrowid ;
	if (objregno) regno=objregno.value ;
	if (regno=="")
	{ 	ClearAdm();
		 return ;
	}
	else
	{ 
	  regno=getRegNo(regno) ;
	  objregno.value=regno
		}
	//obj=document.getElementById("displocrowid")
	//if (obj) displocrowid=obj.value ;
	//if (displocrowid=="") {
	//	alert(t['NO_DISPLOC']) ;
	//	return ;
//		}
	ClearAdm();
	//set patient info
    var getpa=document.getElementById('mRetrievePa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
    //var getadm=document.getElementById('mGetAdm');
	//if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	//if (cspRunServerMethod(encmeth,'SetAdm','',regno)=='0') {}  
    var getadm=document.getElementById('mGetAdm');
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetAdm','',regno)=='0') {}  

}
function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("PaInfo");
	if (obj)
	{if (painfo.length >0)
		obj.value=painfo[0]+" -- " +painfo[1] + " -- " +painfo[2] ;
	 else
	 	{alert(t['INVALID_REGNO']) ;
	 	 return ;
	 	}
	}
}
function SetAdm(value)
{ 
	var ss=value.split("^") ;
	if (ss.length<1) return ;
	var obj=document.getElementById("Adms") ;
	var i;
	var xx ;
	var info;
	for (i=0;i<ss.length;i++) 
	{
		xx=ss[i] ;
		info=xx.split("&") ;

		if (obj)
		{obj.options[i]=new Option (info[1],info[0]) ;
			}
		}
	if (obj.options.length>0)
	{obj.options.selectedIndex=0 ;}
	}
function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
	
	}
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("wardrowid");
	if (obj)
	{if (ward.length>0)   obj.value=ward[1] ;
		else  obj.value="" ;  
	 }	
}
function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
	if (BodyLoaded!=1)
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

function SetDefaultVal()
	{	//init of date scope
	var group=session['LOGON.GROUPID'] 
	var getdisppara=document.getElementById("mGetGrpDispPara") ;
	if (getdisppara) {var encmeth=getdisppara.value;} else {var encmeth='';}
	var s=cspRunServerMethod(encmeth,'','',group) ;
	
	if (s=="")
	{	}
	else  //按参数设定初始化
	{	
	 var tmparr=s.split("^");
	 var disptype=tmparr[0] ;
	 var dispdate=tmparr[1]	;
	 var disptypeArr=disptype.split("&") ;
	 
	 var obj=document.getElementById("DispCatList")
	 if (obj) {
		 var ss=obj.value ;
		 var catlist=ss.split("^") ;
	 }
	for (i=0;i<disptypeArr.length;i++)
	{
		for (j=0;j<=catlist.length;j++)
		{if (disptypeArr[i]==catlist[j]){
			var obj=document.getElementById("cat"+j) ;
			obj.checked=true; }
		}		
	}	 
	 
	 var dispdateArr=dispdate.split("&");
	 var sd=dispdateArr[0] ;
	 var ed=dispdateArr[1] ;
	 sd=CalcuDate(sd) ;
	 ed=CalcuDate(ed);

	 var startdate=document.getElementById("StartDate");
	 var enddate=document.getElementById("EndDate");
 	 startdate.value=sd
 	 enddate.value=ed
	
	}
//	var currdate=#server(web.DHCSTCOMMONSRV.GetSysDate())#;
//	window.Startdate.value=currdate;
//	window.Enddate.value=currdate;
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
function setLongOrd()
{
	var obj1=document.getElementById("LongOrd");
	var obj2=document.getElementById("ShortOrd");
	var obj3=document.getElementById("LongOrdFlag");
	var obj4=document.getElementById("ShortOrdFlag");
	var obj5=document.getElementById("OutWithDrugOrd");
	var obj6=document.getElementById("OutWithDrugFlag");
	var obj7=document.getElementById("EmOrd");
	var obj8=document.getElementById("ISPACK");
	var obj9=document.getElementById("NOPACK");
	var objpara=document.getElementById("ParaStr");
	//var objonlypiva=document.getElementById("OnlyPiva");
	//var objonlypivaflag=document.getElementById("onlypivaflag");

	if (obj1.checked) 
	{
		if (obj3) {obj3.value=1}
		//--------
		if (obj2) {obj2.checked=false;}
		//if (obj4) {obj4.value=0+"||"+""+"||"+""} 
		//-----
		if (obj5) {obj5.checked=false;}
		if (obj6) {obj6.value=0}
		//if(obj7){obj7.checked=false};
			var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
			if (obj7.checked) {EmFlag="EmOrd"} 
			else {EmFlag="NOEmOrd"}
			
		var PackFlag="";
		if (obj8.checked) {PackFlag="ISPACK"}
		if (obj9.checked) {PackFlag="NOPACK"}
		if (obj4) obj4.value=0+"||"+EmFlag+"||"+PackFlag;
	}
	else	 
	{ 
		if (obj3){obj3.value=0;}
		//取消长嘱时同时选中临嘱		
		//if (GetPhaConfig("Con_LS")==1)
		if(objpara) var para=objpara.value;
		paraArray=para.split("^");
		var lsflag=paraArray[6];
		if(lsflag=="Y")
		{
			//if (obj4) obj4.value=1 +"||"+""+"||"+"" ;
			if (obj2) obj2.checked=true;
			var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
			if (obj7.checked) {EmFlag="EmOrd"} 
			else {EmFlag="NOEmOrd"}
			
			var PackFlag="";
			if (obj8.checked) {PackFlag="ISPACK"}
			if (obj9.checked) {PackFlag="NOPACK"}
			if (obj4) obj4.value=1+"||"+EmFlag+"||"+PackFlag;
		}
	}
	//if(objonlypiva.checked){
	//	if(objonlypivaflag){objonlypivaflag.value=1;}
	//	}
    //else{
	//    if(objonlypivaflag){objonlypivaflag.value=0;}
	//    }
	var obj=document.getElementById("Collect")
	if (obj) obj.click();
}
function setShortOrd()
{
	var obj1=document.getElementById("LongOrd");
	var obj2=document.getElementById("ShortOrd");
	var obj3=document.getElementById("LongOrdFlag");
	var obj4=document.getElementById("ShortOrdFlag");
	var obj5=document.getElementById("OutWithDrugOrd");
	var obj6=document.getElementById("OutWithDrugFlag");
	var obj7=document.getElementById("EmOrd");
	var obj8=document.getElementById("ISPACK");
	var obj9=document.getElementById("NOPACK");
	var objpara=document.getElementById("ParaStr");
	if (obj2.checked) 
			{
			//if (obj4) {obj4.value=1 +"||"+""+"||"+""}
			//--------
			if (obj1) {obj1.checked=false};
			if (obj3) {obj3.value=0 }
	        //----
			if (obj5) {obj5.checked=false};
			if (obj6) {obj6.value=0}
			//if (obj7) {obj7.checked=false;}
			var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
			if (obj7.checked) {EmFlag="EmOrd"} 
			else {EmFlag="NOEmOrd"}
			
			var PackFlag="";
			if (obj8.checked) {PackFlag="ISPACK"}
			if (obj9.checked) {PackFlag="NOPACK"}
			if (obj4) obj4.value=1+"||"+EmFlag+"||"+PackFlag;
			}
		 else	 { 
  
			//if (obj4) {obj4.value=0 + "||" +""+"||"+""}
			var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
			if (obj7.checked) {EmFlag="EmOrd"} 
			else {EmFlag="NOEmOrd"}
			
			var PackFlag="";
			if (obj8.checked) {PackFlag="ISPACK"}
			if (obj9.checked) {PackFlag="NOPACK"}
			if (obj4) obj4.value=0+"||"+EmFlag+"||"+PackFlag;
			//if (GetPhaConfig("Con_LS")==1)
			if(objpara) var para=objpara.value;
			paraArray=para.split("^");
			var lsflag=paraArray[6];
			if(lsflag=="Y")
			{
				//--------如果长临互斥(自动必选一项)则放开, 
				if (obj1) {obj1.checked=true;} //--当取消临嘱时?同时选中长嘱
				if (obj3) {obj3.value=1}       //--当取消临嘱时?同时选中长嘱
				//--------
			}
		  }
	var obj=document.getElementById("Collect")
	if (obj) obj.click();
}
function setOutWithDrug()
{
	var obj1=document.getElementById("LongOrd");
	var obj2=document.getElementById("ShortOrd");
	var obj3=document.getElementById("LongOrdFlag");
	var obj4=document.getElementById("ShortOrdFlag");
	var obj5=document.getElementById("OutWithDrugOrd");
	var obj6=document.getElementById("OutWithDrugFlag");
	var obj7=document.getElementById("EmOrd");
	var obj8=document.getElementById("ISPACK");
	var obj9=document.getElementById("NOPACK");
	if (obj5.checked) 
			{
			if (obj6) obj6.value=1
			if (obj1) obj1.checked=false;
			if (obj3) obj3.value=0 
			if (obj2) obj2.checked=false;
			//if (obj4) obj4.value=0 
			//if (obj7) {obj7.checked=false;}
			var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
			if (obj7.checked) {EmFlag="EmOrd"} 
			else {EmFlag="NOEmOrd"}
			var PackFlag="";
			if (obj8.checked) {PackFlag="ISPACK"}
			if (obj9.checked) {PackFlag="NOPACK"}
			if (obj4) obj4.value=0+"||"+EmFlag+"||"+PackFlag;
			SetAllCatsSelected(); //select all the cats 
			}
		 else	 { 
			if (obj6) obj6.value=0
		  }
	var obj=document.getElementById("Collect")
	if (obj) obj.click();
}
function setEmOrd()
{
	var obj1=document.getElementById("LongOrd");
	var obj2=document.getElementById("ShortOrd");
	var obj3=document.getElementById("LongOrdFlag");
	var obj4=document.getElementById("ShortOrdFlag");
	var obj5=document.getElementById("OutWithDrugOrd");
	var obj6=document.getElementById("OutWithDrugFlag");
	var obj7=document.getElementById("EmOrd");
	var obj8=document.getElementById("ISPACK");
	var obj9=document.getElementById("NOPACK");
	if (obj7)
	{
	if (obj7.checked) 
			{
			//if (obj2) obj2.checked=false; //wyx 2015-01-12
			if (obj2.checked){var ShortOrd=1}else{var ShortOrd=0}
			if (obj4) obj4.value=0
			//if (obj1) obj1.checked=false; //wyx 2015-01-12
			//if (obj3) obj3.value=0  //wyx 2015-01-12
			//if (obj5) obj5.checked=false; //wyx 2015-01-12
			//if (obj6) obj6.value=0  //wyx 2015-01-12
			//if (obj8) {obj8.checked=false;}
			//if (obj9) {obj9.checked=false;}
			var PackFlag="";
			if (obj8.checked) {PackFlag="ISPACK"}
			if (obj9.checked) {PackFlag="NOPACK"}
			if (obj4) obj4.value=0 + "||" + "EmOrd" +"||"+ PackFlag
			}
		 else	 { 
			if (obj4) obj4.value=0 + "||" + "NOEmOrd" +"||"+ PackFlag
			
		  }
	var obj=document.getElementById("Collect")
	if (obj) obj.click();
	}
}


function setISPACK()
{
	var obj1=document.getElementById("LongOrd");
	var obj2=document.getElementById("ShortOrd");
	var obj3=document.getElementById("LongOrdFlag");
	var obj4=document.getElementById("ShortOrdFlag");
	var obj5=document.getElementById("OutWithDrugOrd");
	var obj6=document.getElementById("OutWithDrugFlag");
	var obj7=document.getElementById("EmOrd");
	var obj8=document.getElementById("ISPACK");
	var obj9=document.getElementById("NOPACK");
	var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
	if (obj7.checked) {EmFlag="EmOrd"} 
	else {EmFlag="NOEmOrd"}	
	if (obj8.checked) 
			{
			//obj2.checked=false;
			if (obj2.checked){var ShortOrd=1}else{var ShortOrd=0}
			//if (obj1.checked){var LongOrd=1}else{var LongOrd=0}
			obj4.value=ShortOrd+"||"+EmFlag+"||"+"ISPACK"
			//obj1.checked=false;
			//obj3.value=0 
			//obj5.checked=false;
			//obj6.value=0
			//obj7.checked=false;
			obj9.checked=false;
			}
		 else	 {
			//obj2.checked=false;
			//obj1.checked=false;
			//obj4.value=0
			if (obj2.checked){var ShortOrd=1}else{var ShortOrd=0}
			obj4.value=ShortOrd+"||"+EmFlag+"||"+""
		  }	  
	var obj=document.getElementById("Collect")
	if (obj) obj.click();
}


function setNOPACK()
{
	var obj1=document.getElementById("LongOrd");
	var obj2=document.getElementById("ShortOrd");
	var obj3=document.getElementById("LongOrdFlag");
	var obj4=document.getElementById("ShortOrdFlag");
	var obj5=document.getElementById("OutWithDrugOrd");
	var obj6=document.getElementById("OutWithDrugFlag");
	var obj7=document.getElementById("EmOrd");
	var obj8=document.getElementById("ISPACK");
	var obj9=document.getElementById("NOPACK");
	var EmFlag="" //wyx modify 急煎标记改为类似 “仅整包装(片剂)”或者 “仅散包装(片剂)”
	if (obj7.checked) {EmFlag="EmOrd"} 
	else {EmFlag="NOEmOrd"}  
     if (obj9.checked) 
			{
			if (obj2.checked){var ShortOrd=1}else{var ShortOrd=0}
			//if (obj1.checked){var LongOrd=1}else{var LongOrd=0}
			obj4.value=ShortOrd+"||"+EmFlag+"||"+"NOPACK"
			//obj2.checked=false;
			//obj1.checked=false;
			//obj3.value=0 
			//obj5.checked=false;
			//obj6.value=0
			//obj7.checked=false;
			obj8.checked=false;
			}
		 else	 { 
		    //obj2.checked=false;
		    //obj1.checked=false;
			//obj4.value=0
			if (obj2.checked){var ShortOrd=1}else{var ShortOrd=0}
			obj4.value=ShortOrd+"||"+EmFlag+"||"+""
		  }
   
	var obj=document.getElementById("Collect")
	if (obj) obj.click();
}

function SetAllCatsSelected()
{	for (i=0;i<10;i++)
	{  
		var obj2=document.getElementById("cat"+i);
		if (obj2) {
			if (window.document.all("cat"+i).style.display=='none'){}
			else 	obj2.checked=true
		}
	}	
}

function setCatList()
{   //according to definition,display the dispensing category and description
	var obj=document.getElementById("mGetDrugType") ;
	if (obj) {var encmeth=obj.value}
	else {var encmeth=''};
	
	var result=cspRunServerMethod(encmeth)  ;
	var drugGrps=result.split("!")
	var cnt=drugGrps.length
	var objDispCatList=document.getElementById("DispCatList")
	if (objDispCatList) objDispCatList.value=""

	for (i=0;i<cnt;i++)
	{
		var drugGrpCode=drugGrps[i].split("^");
		var code=drugGrpCode[0];
		var desc=drugGrpCode[1];
		
		var obj=document.getElementById("c"+"cat"+i) ;
		if (obj) 
		{
			obj.innerText=desc;
		}

		if (objDispCatList.value=="") objDispCatList.value=code ;
	    else
		    {objDispCatList.value=objDispCatList.value+"^"+code } ;
	}

	var xx=cnt
	var j;
	for (j=xx;j<=9;j++)
	{
		var obj=document.getElementById("c"+"cat"+j) ;
		if (obj) 
		{
			window.document.all("cat"+j).style.display='none'   
			window.document.all("c"+"cat"+j).style.display='none'   ;         //not display
			}
		}	
}

function getCatSelected()
{
	/* 2007-01-12 rem 
	var result="" ;
	var obj=document.getElementById("DispCatList"); 
	if (obj)
	{
		var catlist=obj.value;
		var cat=catlist.split("^");
	}
		
	for (i=0;i<10;i++)
	{
		var obj2=document.getElementById("cat"+i);
		if (obj2)
		{
			if (obj2.checked==true)
			{
				if (result=="") result=cat[i];
				else
				{result=result+"^"+cat[i] ; }
			}
		}
	}	
	return result */
    
    var obj=document.getElementById("displocrowid");
    if (obj) var loc=obj.value;
    var result;
    if (loc=="") {result=""}
    else
    {
	 
	 result=getPhaLocDispType(loc)
     
     //filer limit cats 
     //result=LimitCatsFiltered(result)
      
     
     }
	return result

}
function OperUserLookUpSelect(str)
{
	var ss=str.split("^") ;
	if (ss.length>0) {
		var obj=document.getElementById("CollectUserRowid");
		if (obj) obj.value=ss[1] ;
		else obj.value="" ;
		}
}

function PrintOutDrug()
{ 

	// 1 - save dispensing data 
  	// 2 - handle the stock data
  	// 3 - print dispensing list 
  	
  	
    var objdrugout=document.getElementById("OutWithDrugFlag")
    if (objdrugout) {
	    if (objdrugout.value==0)
	    { 	alert(t['ONLY_DRUGOUT_CANDOTHIS'])
	    	return ;  }
	    }
	//var obj=document.getElementById("DispCat");
    //var dispcats=obj.value;
    var dispcats=getCatSelected();
	
    if ( dispcats=="") 
    {	alert(t['NO_ANY_DISPCAT']) ;
	    return ; }
    
    var catarr=dispcats.split("^");
    
    var objtbl=document.getElementById("t"+"dhcpha_phadisp") ;
    if (objtbl) var cnt=getRowcount(objtbl) ;
    else var cnt=0 ;
    var pid="" ;
    if (cnt>0) 
    {   var obj=document.getElementById("TPIDz"+1) ;
	    if (obj) pid=obj.value;    }
	else
	{	alert(t['NO_ANY_ROWS']) ;
		return;
		}
    if (pid=="")
    {	alert(t['NO_PID']) ;
    	return ;   	}

	//if (confirm(t['CONFIRM_PRINT'])==false)  
	//{return ; }  
  
	//saveRefuse()  ; // Save the refused drug   //zhouyg 2013-05-14注释，拒绝时直接保存了 
    
   // var printCount=0;
    //------------------------------
    
    var ss=[];
    var outdrugPhacs;
    var outdrugPhacs=""
    var outdrugPhastr=""
    var obj=document.getElementById("wardrowid")
    var wardstr=obj.value
    var wardlist=wardstr.split("^")
  for (var j=0;j<wardlist.length;j++)
   {
	   var wardid=wardlist[j]
    for (var i=0;i<catarr.length;i++)
    {
		var cat=catarr[i];
		var PhacRowid=SaveDispensing(cat,pid,wardid) ;
		
	 
		if (PhacRowid>0 )
		{  
			if (outdrugPhacs=="") {outdrugPhacs=PhacRowid}
			else {outdrugPhacs=outdrugPhacs+"^"+PhacRowid }
		}
		if (PhacRowid<0)
		{	
		    alert(getDispCatName(cat) + t['SAVE_FAILED']) ;
		} 
    }
   }
    GetTipsOfNoStock(pid);
	killTmpAfterSave(pid);
	if (outdrugPhacs==""){CollectClick();
	return;}
	var pcods=InsertOutDrug(outdrugPhacs) ;
	if (pcods=="") return ;

	
	//1.-------- 按单个患者打印出印带药 ----------------
	/*	
		var pxx=pcods.split("^")
		if (pxx.length>=0)
		{
			for (var j=0;j<pxx.length;j++)
			{
			    pOut(pxx[j])  ;
			}
		}
	
    */
	//2.------- 按病区打印出印带药汇总 ----------------
	//creator : lq  08-10-10
	   /*
	   if (outdrugPhastr=="") {outdrugPhastr=pcods}
	   
	   pOut(outdrugPhastr)
	   */
	//--------
	
	//3.-------和病区发药保持一致打印则
	//
	
	var OutString=""
	var pxx=outdrugPhacs.split("^")
	if (pxx.length>=0)
	{
		for (var j=0;j<pxx.length;j++)
		{
			if (OutString==""){OutString=pxx[j]}
			else{OutString=OutString+"A"+pxx[j]}
	  
		}
		
		pOut(OutString,pid)  ; 
	}
	
	 //------------
  	CollectClick();	

}

//add by myq 20140521
//Function : 只发药出院带药,不打印
function OnlyDispOutDrug()
{ 

	// 1 - save dispensing data 
  	// 2 - handle the stock data
  	// 3 - print dispensing list 
  	
  	
    var objdrugout=document.getElementById("OutWithDrugFlag")
    if (objdrugout) {
	    if (objdrugout.value==0)
	    { 	alert(t['ONLY_DRUGOUT_CANDOTHIS'])
	    	return ;  }
	    }
	//var obj=document.getElementById("DispCat");
    //var dispcats=obj.value;
    var dispcats=getCatSelected();
	
    if ( dispcats=="") 
    {	alert(t['NO_ANY_DISPCAT']) ;
	    return ; }
    
    var catarr=dispcats.split("^");
    
    var objtbl=document.getElementById("t"+"dhcpha_phadisp") ;
    if (objtbl) var cnt=getRowcount(objtbl) ;
    else var cnt=0 ;
    var pid="" ;
    if (cnt>0) 
    {   var obj=document.getElementById("TPIDz"+1) ;
	    if (obj) pid=obj.value;    }
	else
	{	alert(t['NO_ANY_ROWS']) ;
		return;
		}
    if (pid=="")
    {	alert(t['NO_PID']) ;
    	return ;   	}

	//if (confirm(t['CONFIRM_PRINT'])==false)  
	//{return ; }  
  
	//saveRefuse()  ; // Save the refused drug   //zhouyg 2013-05-14注释，拒绝时直接保存了 
    
   // var printCount=0;
    //------------------------------
    
    var ss=[];
    var outdrugPhacs;
    var outdrugPhacs=""
    var outdrugPhastr=""
    var obj=document.getElementById("wardrowid")
    var wardstr=obj.value
    var wardlist=wardstr.split("^")
  for (var j=0;j<wardlist.length;j++)
   {
       var wardid=wardlist[j]
    for (var i=0;i<catarr.length;i++)
    {
		var cat=catarr[i];
		var PhacRowid=SaveDispensing(cat,pid,wardid) ;
		
	 
		if (PhacRowid>0 )
		{  
			if (outdrugPhacs=="") {outdrugPhacs=PhacRowid}
			else {outdrugPhacs=outdrugPhacs+"^"+PhacRowid }
		}
		if (PhacRowid<0)
		{	
		    alert(getDispCatName(cat) + t['SAVE_FAILED']) ;
		} 
    }
   }
	killTmpAfterSave(pid);
	if (outdrugPhacs==""){CollectClick();
	return;}
	var pcods=InsertOutDrug(outdrugPhacs) ;
	if (pcods=="") return ;

	
	//1.-------- 按单个患者打印出印带药 ----------------
	/*	
		var pxx=pcods.split("^")
		if (pxx.length>=0)
		{
			for (var j=0;j<pxx.length;j++)
			{
			    pOut(pxx[j])  ;
			}
		}
	
    */
	//2.------- 按病区打印出印带药汇总 ----------------
	//creator : lq  08-10-10
	   /*
	   if (outdrugPhastr=="") {outdrugPhastr=pcods}
	   
	   pOut(outdrugPhastr)
	   */
	//--------
	
	//3.-------和病区发药保持一致打印则
	//
	
	var OutString=""
	var pxx=outdrugPhacs.split("^")
	if (pxx.length>=0)
	{
		for (var j=0;j<pxx.length;j++)
		{
			if (OutString==""){OutString=pxx[j]}
			else{OutString=OutString+"A"+pxx[j]}
	  
		}
		
		//pOut(OutString,pid)  ; 
	}
	
	 //------------
  	CollectClick();	

}

function pOut(pcod,pid)
{
	    var detailprn=0;totalprn=0;
	    // 获取打印方式
	    var objDetailPrn=document.getElementById("DetailPrn");
	    var objTotalPrn=document.getElementById("TotalPrn");
	    if (objDetailPrn) {
		    if (objDetailPrn.checked==true){var detailprn=1}
	    }
	    if  (objTotalPrn) {
	    	if (objTotalPrn.checked==true){var totalprn=1} 
	    }
		//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintoutdrug&PCODROWID="+pcod+"&DetailPrn="+detailprn+"&TotalPrn="+totalprn+"&RePrintFlag="+0;
		//parent.frames['dhcpha.dispprintoutdrug'].window.document.location.href=lnk;
		//--------------
		var prthz=0
		
		//PrintRep(pcod);
		PrintReport(pcod,pid)
		/*
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintBJFC"+"&Phac="+pcod+"&PrtHz="+prthz+"&RePrintFlag="+0+"&DetailPrn="+detailprn+"&TotalPrn="+totalprn+"&PID="+pid
	    parent.frames['dhcpha.dispprintBJFC'].window.document.location.href=lnk;
   */
}

function InsertOutDrug(phacs)
{
	//var Adm;
    var Locdr;
	//var objadm=document.getElementById("Adms");
	//if ((objadm)&&(objadm.options.selectedIndex>=0)) Adm=objadm.value 
	var obj=document.getElementById("displocrowid");
	if (obj) Locdr=obj.value;
	var user=session['LOGON.USERID']
	var xx=document.getElementById("mInsertOutDrug");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,Locdr,user,phacs) ;	
	return result
}

function PopWardDispensing()
{	
   var loc,sd,ed,DispLoc;
   var obj=document.getElementById("displocrowid")
   if (obj) loc=obj.value;
   var obj=document.getElementById("StartDate")
   if (obj) sd=obj.value;
   var obj=document.getElementById("EndDate")
   if (obj) ed=obj.value;
   var obj=document.getElementById("DispLoc")
   if (obj) DispLoc=obj.value;  
   
   
    //var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaward"
    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaward?displocrowid="+loc+"&StartDate="+sd+"&EndDate="+ed+"&DispLoc="+DispLoc
   
     
     window.open(lnk,"_target","height=400,width=800,menubar=no,status=no,toolbar=no") ;
 }

function getPhaLocation(loc)
{ 
    var exe;
   
	var obj=document.getElementById("mGetPhaLocSet")
	if (obj) exe=obj.value;
	else exe='';
	
	var sss=cspRunServerMethod(exe,loc);

	return sss;	 
}

function getPhaLocDispType(loc)
{
	//
    var exe
	var obj=document.getElementById("mGetPhaLocDisType")
	if (obj) exe=obj.value;
	else exe='';
	var sss=cspRunServerMethod(exe,loc)
	return sss;
}

///获取发送摆药机标志
function GetSendMachine()
{
	var SendMachine=""
	var loc
	var obj=document.getElementById("displocrowid")
	
	if ((obj)&&(obj.value!=""))
	{
	 
		 loc=obj.value ;	
		 var sets=getPhaLocation(loc);
		
	     if (sets!="")
	     {
		     var ss=sets.split("^")
		     SendMachine=ss[31];
	     }
	}
	     
	return SendMachine
}

function setDefaultValByLoc()
{
	var loc
	var obj=document.getElementById("displocrowid")
	
	if ((obj)&&(obj.value!=""))
	{
	 
		 loc=obj.value ;	
		 var sets=getPhaLocation(loc);
		
	     if (sets!="")
	     {
			     var ss=sets.split("^")
			     var sd ;
			     var ed;
			     var notwardrequired ;
			     var auditneed ;
			      
			     sd=ss[2];
			     ed=ss[3] ;
			     //st=ss[4];
			     //et=ss[5];
			     notwardrequired=ss[0];
				 auditneed=ss[10];
				 retflag=ss[11]; 
				 dispuserflag=ss[17];
				 operaterflag=ss[21];
				 aduitBillflag=ss[22];
				 disptypelocalflag=ss[23];
				 displayemyflag=ss[24];
				 displayoutflag=ss[25];
				 lsflag=ss[26];
				 reqwardflag=ss[27];
				 dispdefaultflag=ss[28];
				 var startdate=CalcuDate(sd)
				 var enddate=CalcuDate(ed)
				 //var starttime=CalcuDate(ed)
				
				 var obj=document.getElementById("StartDate");
				 //if (obj) obj.value=startdate;
				 var obj=document.getElementById("EndDate");
				 //if (obj) obj.value=enddate;

			     if (retflag=="Y")
			     {
				     var objret=document.getElementById("RetFlag");
				     objret.checked=true;
				     window.document.all('RetFlag').style.display="inline"  ;
				     window.document.all('cRetFlag').style.display="inline" ;  
			     }
			     else
			     {
				     var objret=document.getElementById("RetFlag");
				     objret.checked=false;
				     window.document.all('cRetFlag').style.display="none"  ;
				     window.document.all("RetFlag").style.display="none"   ;
			     }
			     
			     var objpara=document.getElementById("ParaStr");
			     if (objpara) objpara.value=dispuserflag+"^"+operaterflag+"^"+aduitBillflag+"^"+disptypelocalflag+"^"+displayemyflag+"^"+displayoutflag+"^"+lsflag+"^"+reqwardflag+"^"+dispdefaultflag;
			     
			     
		     
	     }
	}
}
function MakeDispItmTotalize()
{
	
	var obj=document.getElementById("TPID"+"z"+"1")
	if (obj)
	{
		var pid=obj.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadispitmtotal&PID="+pid
		parent.frames['dhcpha.phadispitmtotal'].window.document.location.href=lnk;
	}
	else 
	{
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phadispitmtotal&PID="
		parent.frames['dhcpha.phadispitmtotal'].window.document.location.href=lnk;
	}

}
function setAdmInfosDisplay(b)
{  if (b==false)
   	{ // window.document.all("c"+"RegNo").style.display="none"
	   	//window.document.all("RegNo").style.display="none"
	   	
	   	//window.document.all("PaInfo").style.display="none"
	   	//window.document.all("Adms").style.display="none"
	   	window.document.all("RegNo").style.visibility="hidden"
	   	window.document.all("PaInfo").style.visibility="hidden"
	   	window.document.all("Adms").style.visibility="hidden"
	 //	window.document.all("c"+"Adms").style.display="none"
	    
     }
   else
   {  
   // window.document.all("c"+"RegNo").style.display="inline"
   	//window.document.all("RegNo").style.display="inline"
   	//window.document.all("PaInfo").style.display="inline"
   //	window.document.all("Adms").style.display="inline"
   	window.document.all("RegNo").style.visibility="visible"
   	window.document.all("PaInfo").style.visibility="visible"
    window.document.all("Adms").style.visibility="visible"
 //	window.document.all("c"+"Adms").style.display="inline"

 	}
}

function LimitCatsFiltered(s)
{
  var docu=parent.frames['dhcpha.phaward'].window.document
  var obj=docu.getElementById("Limit")
  if (obj.checked==false) return s
  var obj2=docu.getElementById("LimitCats")
  
  var ss=s.split("^")
  var cnt=ss.length	
  var newstr="";
  for (var i=0;i<=cnt-1;i++)
  {  
     var cc=ss[i]
  	  for (var j=0;j<=obj2.options.length-1;j++)
  	  { 
	  	  if (obj2.options[j].value==cc)
	  	  {  
		  	  if (obj2.options[j].selected==true)
				{
				  if (newstr=="") {newstr=cc}
				  else {newstr=newstr+"^"+cc} 
				}
	  	  }
  	  }
  }
  return newstr;	
}
function getNoStkColor()
{
	///如果" TinciQty "列等于0 ,则为库存不足,上色
 
	var objtbl=document.getElementById("t"+"dhcpha_phadisp")
	if (objtbl)
	{ 
	     var cnt=objtbl.rows.length-1;
	     for (var i=1;i<=cnt; i++) 
	          {
		     
		           var objNostk=document.getElementById("TinciQty"+"z"+i)
		           if  (objNostk.value==0){
			     
					//var obj=document.getElementById("TWard"+"z"+1) ;
					//if (obj){
					//	obj.style.backgroundColor="#80f0c0";	}
					//objtbl.rows(1).cells(j).style.display="none";
					objtbl.rows(i).style.backgroundColor="#80f0c0"; }
					

					var objarcEndDateFlag=document.getElementById("TarcEndDateFlag"+"z"+i)
		            if  (objarcEndDateFlag.value==1)
		            {
					  objtbl.rows(i).style.backgroundColor="deepskyblue"; 
	                }      
	               
	          }
  
    }
}
function   SetFrame()   
  {   
   
   xscroll=xscroll+1
   if (xscroll%2==0){
	   parent.document.getElementById('x').cols='0,*';}
	   else {parent.document.getElementById('x').cols='25,75';}
	   
	objtbl=document.getElementById("scroll");
	if (objtbl) 
	{
		if(objtbl.innerText=="全屏显示")
		{objtbl.innerText="撤销全屏";}
		else
		{
			objtbl.innerText="全屏显示";
		}
	}
 
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

function SelectRowHandler()
{
    var row=selectedRow(window)
    Savetofitler(row)
    CurrentRow=row;
  	//关联医嘱同时勾选,按用药日期,yunhaibao20160328
	var retstr=CheckLink(row).split("%");
	var oeoricnt=retstr[0] 
	if (oeoricnt>1){
		var selectchecked=document.getElementById("Tselectz"+row).checked;
		var objtbl=document.getElementById("t"+"dhcpha_phadisp")
		var mainoeori=document.getElementById("TMainOrdz"+row).value; //主医嘱id
		var dodisdate=document.getElementById("TTimeAddz"+row).innerText;
		var mainindex=mainoeori+"^"+dodisdate
		var tablerows=0
		if (objtbl)
		{
			tablerows=objtbl.rows.length-1;
		}
		var linki=row
		for (linki=row;linki<=tablerows;linki++)
		{
			var linkmainoeori=document.getElementById("TMainOrdz"+linki).value; //主医嘱id
			var linkdodisdate=document.getElementById("TTimeAddz"+linki).innerText;
			var linkmainindex=linkmainoeori+"^"+linkdodisdate
			if (linkmainindex==mainindex)
			{
				var downselect=document.getElementById("Tselectz"+linki);
				downselect.checked=selectchecked
				Savetofitler(linki)
			}
			else
			{
				break;
			}	
		}
		linki=row
		for (linki=row;linki>0;linki--)
		{
			var linkmainoeori=document.getElementById("TMainOrdz"+linki).value; //主医嘱id
			var linkdodisdate=document.getElementById("TTimeAddz"+linki).innerText;
			var linkmainindex=linkmainoeori+"^"+linkdodisdate
			if (linkmainindex==mainindex)
			{
			    var upselect=document.getElementById("Tselectz"+linki);
				upselect.checked=selectchecked
				Savetofitler(linki)
			}
			else
			{
				break;
			}
		}		
	}
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

function SaveDispensing(dispcat,pid,wardid)
{ 
   //
	var colluser ;
	//wyx 增加wardid选择多病区时发药控制
	var obj=document.getElementById("CollectUserRowid") ;
	if (obj) colluser=obj.value ;
	var obj=document.getElementById("CollectOperaterRowid");
	if (obj) colloperater=obj.value;
	var obj=document.getElementById("displocrowid");
	if (obj) var locrowid=obj.value;
	var xx=document.getElementById("mSaveDisp");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	
	var PhacRowid=cspRunServerMethod(encmeth,'','',dispcat,pid,colluser,colloperater,'',locrowid,wardid) ;
	return PhacRowid ;  
}

///Description:发药前退药
///Creator:Liang Qiang
///CreatDate:2009-08-05
function ExeRetBeforeDisp()
{
	  var colluser="";
	  var obj=document.getElementById("CollectUserRowid") ;
	  if (obj) colluser=obj.value ;
	  var obj=document.getElementById("TPIDz"+1) ;
      if (obj) pid=obj.value;
      var xx=document.getElementById("mExeRet");
	  if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	  var RetStr=cspRunServerMethod(encmeth,pid,colluser) ;
}

///Description:发药前弹出录入发药人窗口
///Creator:Liang Qiang
///CreatDate:2010-05-05
function  showUserDialog()
{   
    var userdr="";
    var grp=session['LOGON.GROUPID']
    var userdr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phauserdialog&grp='+grp,'','dialogHeight:450px;dialogWidth:350px;center:yes;help:no;resizable:no;status:no;scroll:no')
    if (userdr!="") {
    	var objuserdr=document.getElementById("CollectUserRowid") ;
        objuserdr.value=userdr ;} 
    else
    {
	    alert("请选择发药人后再重试...");
    }
    return userdr ;
}
///Description:发药前弹出录入摆药人窗口
///Creator:Cao Ting
///CreatDate:2011-03-02
function  showOperaterDialog()
{   
    var operaterdr="";
    var grp=session['LOGON.GROUPID']
    var operaterdr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaoperaterdialog&grp='+grp,'','dialogHeight:450px;dialogWidth:350px;center:yes;help:no;resizable:no;status:no;scroll:no')
    if (operaterdr!="") {
    	var objuserdr=document.getElementById("CollectOperaterRowid") ;
        objuserdr.value=operaterdr ;} 
    else
    {
	    alert("请选择摆药人后再重试...");
    }
    return operaterdr ;
}
document.body.onbeforeunload=function(){
	
   var objtbl=document.getElementById("t"+"dhcpha_phadisp")
   if(objtbl){
	   var cnt=objtbl.rows.length-1;
	   if (cnt>0){
	   var objPid= document.getElementById("TPID"+"z"+1)
	   pid=objPid.value
       var exe
	   var obj=document.getElementById("mKillBeforeLoad")
	   if (obj) {exe=obj.value;} else {exe='';}
	   var sss=cspRunServerMethod(exe,pid)
	            }
       }
  } 
  
function GetGrpPara()
{	
    var group=session['LOGON.GROUPID'] 
	var getdisppara=document.getElementById("mGetGrpDispPara") ;
	if (getdisppara) {var encmeth=getdisppara.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,'','',group) ;
	return str;
}

function setBddCollect()
{
	//var lnk="dhcpha.transreqquerycoll.csp"
	//showModelessDialog(lnk,"","dialogHeight:600;dialogWidth:800;center:yes;menubar:no;status:yes;toolbar:no;resizable:yes") ;
     var lnk="dhcpha.transreqquerycoll.csp";
     window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;

	}
function setBddDisp()
{	//var lnk="dhcpha.transreqquerydisp.csp"
	//showModelessDialog(lnk,"","dialogHeight:200;dialogWidth:800;center:yes;menubar:no;status:yes;toolbar:no;resizable:yes") ;
     var lnk="dhcpha.transreqquerydisp.csp";
     window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	}



function SaveRefuseMod(oedis,userid,refreason)
{
	var xx=document.getElementById("mSaveRefuse");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,'','',oedis,userid,refreason) ;
	return  result
	
}

function ChangeColor(k,resondesc)
{
	   k = parseInt(k)
	   var objtbl=document.getElementById("t"+"dhcpha_phadisp") 
	   if (objtbl) objtbl.rows(k).style.backgroundColor="#ffc0c0";
	   
	   var objdesc=document.getElementById("TRefuseReasonDesc"+"z"+k)
	   if (objdesc) {objdesc.innerText=resondesc; }
       var objrefuseflag=document.getElementById("TRefuseFlag"+"z"+k)
	   if (objrefuseflag) {objrefuseflag.innerText="Y"; }
         
}
function ReadHFMagCard_Click()
{
	var obj=document.getElementById("ByRegNo");
	if(obj.checked==false){
		obj.checked=true;
	    setRegNoVisible();
	}
	
	var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");

	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
		
		
	}

	if (myrtn==-200){
		alert("无效读卡")
		return;
	}
	var myary=myrtn.split("^");
	var rtn=myary[0];
	if (rtn=="-1") {alert("不能读卡");return ;}
	else
	{	
		var obj=document.getElementById("RegNo");
		if (obj) obj.value=myary[5];
		Find_click();
	}
	
}
function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=document.getElementById("ReadCardTypeEncrypt").value;		
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
		
	}
}
function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("BReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("BReadCard");
		if (obj){
			//obj.disabled=false;
			//obj.onclick=ReadHFMagCard_Click;
			DHCWeb_AvailabilityBtnA(obj,ReadHFMagCard_Click)
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		//DHCMZYF_setfocus("CardNo");
	}else{
		//DHCMZYF_setfocus("BReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}
function RetBillControl(pid,adm)
{
	var encmeth=document.getElementById("mRetBillControl").value;
	var ret;
	if (encmeth!=""){
		ret=cspRunServerMethod(encmeth,pid,adm);
		
	}
	return ret;
}
///发送医嘱信息
function SendOrderToMechine(phacStr)
{
	if (GetSendMachine()!='Y') return;
    var err=0
	phacArr=phacStr.split("A");	
	for(i=0;i<phacArr.length;i++)
	{
		phac=phacArr[i].split("B");
	    var pharowid=phac[0]

	    var getadm=document.getElementById('mSendOrderToMechine');
	    if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	    var ret=cspRunServerMethod(encmeth,pharowid)
	    if (ret!=0)
	    {
		    var retString=ret
		    var err=1
	    }
		
	}
	
	
	if (err!=0)
	{
		alert("发送包药机失败!请注意核实!"+retString)
	}
	
	else
	{
		//alert("发送包药机成功!")
		
	}
	
   
}
function GetTipsOfNoStock(pid)
{
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLS","GetTipsOfNoStock",pid);
	if (ret!=""){alert(ret+"  库存不足,导致对应关联医嘱无法发药！")}
}

//拒绝发药
//zhouxin
//2015-12-29 
function RefuseClick(){
  var rowcnt=0;
  var linkFlag=1;	
  var table=document.getElementById("t"+"dhcpha_phadisp")
  if (table) rowcnt=table.rows.length-1;
  if(rowcnt==0){
	  alert("没有明细！");
	  return;
  } 
  var userid=session['LOGON.USERID']
         
  var ordArr = new Array(); 	
  var linkArr=new Array(); 
  for (i=1;i<=rowcnt;i++)
  {
	   var obj=document.getElementById("Tselect"+"z"+i)
	   if (obj.checked==true)
	     {
	             dispIdStr=document.getElementById("TDispIdStrz"+i).value;
	             mainOrd=document.getElementById("TMainOrdz"+i).value; //主医嘱id
	             /*
	             if (!linkArr.contains(mainOrd)){  //添加关联医嘱提示yunhaibao20160307
				    var retstr=CheckLink(i).split("%");
					var oeoricnt=retstr[0] ;
					if (oeoricnt>1){
						var patname=document.getElementById("TPaNamez"+i).innerText;
						var patbedno=document.getElementById("TBedNoz"+i).innerText;
						var incidesc=document.getElementById("TDescz"+i).innerText;
						var patinfo="床号:"+patbedno+"\t病人姓名:"+patname+"\n"+"药品名称:"+incidesc
						var confirmtext=patinfo+"\n\n"+"是否拒绝该病人对应的关联医嘱?"
						if (confirm(confirmtext))
						{
							linkFlag=1
						}
					}
					linkArr.push(mainOrd);
		         }*/
	             if(!ordArr.contains(dispIdStr)){
	             	ordArr.push(dispIdStr);
	             	if(linkFlag==1){
						for (var j=1;j<=rowcnt;j++)
						{
							tmpMainOrd=document.getElementById("TMainOrdz"+j).value;
							tmpDispId=document.getElementById("TDispIdStrz"+j).value;
							if((mainOrd==tmpMainOrd)&&(!ordArr.contains(tmpDispId))){
								ordArr.push(tmpDispId);
							}
						}	
		            }
		            
	             }
	             linkFlag=0
	     };
   }
   if(ordArr.length==0){
   	 alert("请选择！");
   	 return;
   }
   if(!confirm(t['IF_REFUSE'])) return;
   var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason','','dialogHeight:550px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
   if (!resondr) return;
   if (resondr!=""){
	   var restmp=resondr.split("^")
	   resondr=restmp[0]
	   resondesc=restmp[1]
   }
   tkMakeServerCall("web.DHCSTPCHCOLLS","InsertDrugRefuse",ordArr.join("^"),userid,resondr)
   CollectClick();	
}
//判断数组中是否包含元素
Array.prototype.contains = function (obj) {  
    var i = this.length;  
    while (i--) {  
        if (this[i] === obj) {  
            return true;  
        }  
    }  
    return false;  
}  
document.body.onload=BodyLoadHandler;
