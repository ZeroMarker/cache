var CurrentRow;

function BodyLoadHandler()
{
	 var obj=document.getElementById("t"+"DHCSSUser_LocDoc")
     if (obj) {
	 obj.onkeydown=TableEnter;
	 }
     SetCurLoc();
     if (getBodyLoaded()!="1"){
		setBodyLoaded();
		findclick();
		
	 }
     
	 
}

///选择安全组
function TssgroupLookUpSelect(str)
{	
	 var ss=str.split("^") ;	
	 if ( ss.length>0) 
	 {  
	    row=CurrentRow
		var obj=document.getElementById("Tssgroupdr"+"z"+row)
		if (obj) obj.value=ss[1] 
		var grpdr=ss[1];
		SaveNewGrp(row,grpdr);
	 }
 
}


///选择医生组
function TdocgroupLookUpSelect(str)
{	
	 var ss=str.split("^") ;	
	 if ( ss.length>0) 
	 {  
	    row=CurrentRow
	    var olddocgrpdr="";
		var obj=document.getElementById("Tdocgroupdr"+"z"+row)
		if (obj) {
			obj.value=ss[1] 
		}
		var obj=document.getElementById("Tdocgroup"+"z"+row)
		if (obj) {
			obj.value=ss[0] 
		}
		var docgrpdr=ss[1];
		SaveNewDocGrp(row,docgrpdr);
	 }
 
}

function SelectRowHandler()
{
   var row=selectedRow(window)
   CurrentRow=row;
   SelectTblRowClick();
}

///单击行激活放大镜
function SelectTblRowClick(e)
{
  var obj=websys_getSrcElement(e)
 
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")
  
  if (ss.length>0)	  
	   {	
	        if (ss[0]=="Tssgroup") { return} ;
            var findflag=ss[0].indexOf("Tssgroup")
		    if (findflag>=0)
			   {  
	             if (obj)  var poprow=CurrentRow;            
				 var obj=document.getElementById("Tssgroup"+"z"+poprow);
				 if (obj) 
					 { 
						  Tssgroup_lookuphandler();
					 }
			   }
			   
		    if (ss[0]=="Tdocgroup") { return} ; 
		    var findflag=ss[0].indexOf("Tdocgroup")
		   	   if (findflag>=0)
			   { 
	             if (obj)  var poprow=CurrentRow;
				 var obj=document.getElementById("Tssgroup"+"z"+poprow);
				 if (obj) 
					 { 
						  Tdocgroup_lookuphandler();
					 }
			   }
		 
	   }
 
}

function popTssgroup()
{ 
	if (window.event.keyCode==13) 
	{  
	   window.event.keyCode=117;
	   Tssgroup_lookuphandler();
	}
	
}

function popTdocgroup()
{
	if (window.event.keyCode==13) 
	{  
	   window.event.keyCode=117;
	   Tssgroup_lookuphandler();
	}
}

///table回车激活放大镜
function TableEnter()
{
  TableEnterFun();	
}


function TableEnterFun(e)
{
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")

  if (ss.length>0)	  
	   {	
		    if (ss[0]=="Tssgroup")
			 { 

	             var poprow=CurrentRow;
	             var obj=document.getElementById("Tssgroup"+"z"+poprow);
				 if (obj) 
				 { 
				    popTssgroup();
				 }
			 }
            if (ss[0]=="Tdocgroup")
			 { 

	             var poprow=CurrentRow;
	             var obj=document.getElementById("Tdocgroup"+"z"+poprow);
				 if (obj) 
				 { 
				    popTdocgroup();
				 }
			 }
		 
	   }
 
}

///显示当前科室
function SetCurLoc()
{
	var ctlocdr=session['LOGON.CTLOCID'] 
	var xx=document.getElementById("mGetCurLoc");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,ctlocdr) ;
	var obj=document.getElementById("cloc");
	if (obj){
		obj.innerText=result;
	}
	
	var obj=document.getElementById("loc");
	if (obj){
		obj.value=ctlocdr;
	}
	


	
			
}

///保存新安全组
function SaveNewGrp(row,grpdr)
{
		var ret=confirm("确认保存吗?");
		if (ret==true)
		{
			var rowid="";
			var obj=document.getElementById("Tssuser"+"z"+row)
			if (obj) ssuser=obj.value;
			var xx=document.getElementById("mSaveNewGrp");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,ssuser,grpdr) ;
			if (result!=0){
				alert("保存失败");
				return;
			}
			


		}
		
		
}

///保存新医生组
function SaveNewDocGrp(row,docgrpdr)
{
		var ret=confirm("确认保存吗?");
		if (ret==true)
		{
			
			var rowid="";
			var obj=document.getElementById("Tssuser"+"z"+row)
			if (obj) ssuser=obj.value;
			var xx=document.getElementById("mSaveNewDocGrp");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,ssuser,docgrpdr) ;
			if (result!=0){
				alert("保存失败");
				return;
			}
			


		}
		
}

///设置页面加载项
function setBodyLoaded()
{
	var obj=document.getElementById("bodyLoaded") ;
	if (obj) obj.value=1;
}

///取页面加载项
function getBodyLoaded()
{
	 var obj=document.getElementById("bodyloaded") ; 
	 if (obj) {
	 return obj.value ; }
}

///执行页面查询
function findclick()
{
		var ctlocdr=session['LOGON.CTLOCID'] 
		var objtbl=document.getElementById("t"+"DHCSSUser_LocDoc") 
	    if (objtbl) var cnt=getRowcount(objtbl) ;
	    if (cnt<1) {
		    	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSUser.LocDoc&loc="+ctlocdr+"&bodyloaded=1"	
		 		parent.frames['DHCSSUser.LocDoc'].location.href=lnk;
	    }
		 
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSUser.LocTDoc&loc="+ctlocdr	
		parent.frames['DHCSSUser.LocTDoc'].location.href=lnk;
}


document.body.onload=BodyLoadHandler;