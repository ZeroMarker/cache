var CurrentRow;

function BodyLoadHandler()
{
	 var obj=document.getElementById("t"+"DHCSSUser_LocTDoc")
     if (obj) {
	    obj.onkeydown=TableEnter;
	 }
	 ChangeRowStyle();

	 
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
		alert(obj.value)
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
	   Tdocgroup_lookuphandler();
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
		var obj=document.getElementById("Tdocgroup"+"z"+row);
		if(obj) obj.value=ss[0]; 
		var docgrpdr=ss[1];
		SaveNewDocGrp(row,docgrpdr);
	 }
 
}


///保存新安全组
function SaveNewGrp(row,grpdr)
{
		var ret=confirm("确认保存吗?");
		if (ret==true)
		{
			var rowid="";
			var obj=document.getElementById("Trowid"+"z"+row)
			if (obj) rowid=obj.value;
			var defaultfalg="";
			var obj=document.getElementById("Tdefault"+"z"+row)
			if (obj) defaultfalg=obj.innerText;
			if (defaultfalg=="是") var defaultfalg=1;
			var xx=document.getElementById("mSaveNewGrp");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,defaultfalg,rowid,grpdr) ;
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
			var obj=document.getElementById("Trowid"+"z"+row)
			if (obj) rowid=obj.value;
			var xx=document.getElementById("mSaveNewDocGrp");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,rowid,docgrpdr) ;
			if (result!=0){
				alert("保存失败");
				return;
			}
			


		}
		
}


function ChangeRowStyle()
{
	
       var objtbl=document.getElementById("t"+"DHCSSUser_LocTDoc")
       var cnt=getRowcount(objtbl) ;
       if (cnt<1)return;
       for  (var i=1;i<=objtbl.rows.length-1; i++){
	       if (objtbl.cells){
	         for  (var h=1;h<=objtbl.cells.length-1; h++){  
	            if (objtbl.rows(i).cells(h)){
          			var Id=objtbl.rows(i).cells[h].firstChild.id;
                    var arrId=Id.split("z");
                    
                    var objindex=arrId[1];
                    var objwidth=objtbl.rows(i).cells[h].style.width;
					var objheight=objtbl.rows(i).cells[h].style.height;
					var IMGId="ldi"+Id;
					
          			if (arrId[0]=="Tdelete"){
						var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"DeleteItmClickhandler("+objindex+")\"></A>";
						str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/delete.gif\"  onclick=\"DeleteItmClickhandler("+objindex+")\">";
		          		objtbl.rows(i).cells[h].innerHTML=str;
					}
					if (arrId[0]=="BtnCTMunit"){
						var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"BtnCTMunitClickhandler("+objindex+")\">分组</A>";
		          		objtbl.rows(i).cells[h].innerHTML=str;
					}
					if (arrId[0]=="BtnLocDel"){
						var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"DeleteItmClickhandler("+objindex+")\">出科</A>";
		          		objtbl.rows(i).cells[h].innerHTML=str;
					}
					if (arrId[0]=="BtnFindLog"){
						var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"BtnFindLogClickhandler("+objindex+")\">查看它科轮转权限</A>";
		          		objtbl.rows(i).cells[h].innerHTML=str;
					}
		          } 
	          }
	      }
       }
}


function DeleteItmClickhandler()
{
	        row=selectedRow(window)
			var rowid="";
			var obj=document.getElementById("Trowid"+"z"+row)
			if (obj) rowid=obj.value;
			var defaultfalg="";
			var obj=document.getElementById("Tdefault"+"z"+row)
			if (obj) defaultfalg=obj.innerText;
			if (defaultfalg=="是") var defaultfalg=1;
			
			var rtn=tkMakeServerCall("web.DHCSSDOCGROUPCONFIG", "CheckUnSaveOrd", defaultfalg,rowid);
			if (rtn==1){
				if (!dhcsys_confirm("该用户在出科的科室内存在未核实的医嘱"+",是否继续出科?")) return false;
			}
			
			
			var xx=document.getElementById("mDel");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var result=cspRunServerMethod(encmeth,defaultfalg,rowid) ;
				
			var loc="";
			var obj=document.getElementById("loc")
			if (obj) currloc=obj.value
		    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSUser.LocTDoc&loc="+currloc
	        parent.frames['DHCSSUser.LocTDoc'].location.href=lnk;
}
function BtnCTMunitClickhandler(){
	var UIConfigImgURL = "dhc.bdp.ext.default.csp?extfilename=App/Care/DHC_CTLoc_MedUnit"
    window.open(UIConfigImgURL, "", "status=1,scrollbars=1,top=100,left=100,width=1200,height=600");
}
function BtnFindLogClickhandler(){
	row=selectedRow(window)
	var rowid="";
	var obj=document.getElementById("Trowid"+"z"+row)
	if (obj) rowid=obj.value;
	var UserID=rowid.split("||")[0];
	var UIConfigImgURL = "Otherlogonpermission.csp?UserID="+UserID;
    window.open(UIConfigImgURL, "", "status=1,scrollbars=1,top=100,left=100,width=1200,height=600");
}
document.body.onload=BodyLoadHandler;