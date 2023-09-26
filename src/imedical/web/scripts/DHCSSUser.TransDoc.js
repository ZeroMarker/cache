
var CurrentRow;
function BodyLoadHandler()
{	
   var doccode="";
   var obj=document.getElementById("find")
   if (obj) obj.onclick=Findclick;
   var obj=document.getElementById("doccode")
   if (obj) obj.onkeydown=Codeclick;
   var objtbl=document.getElementById("t"+"DHCSSUser_TransDoc")
   if (objtbl) objtbl.ondblclick=Savedata;
   ChangeRowStyle();
   
}

///查询数据
function Findclick()
{
	var doccode="";
	var obj=document.getElementById("doccode")
	if (obj) obj.value=trim(obj.value);
	find_click();
}

///代码查询
function Codeclick()
{
	if (window.event.keyCode==13){
	 Findclick();	
	} 
	
}

///保存数据
function Savedata()
{
	if (!CurrentRow) return;
	var code="" ;
	var objyes=document.getElementById("Tyes"+"z"+CurrentRow)
	if (objyes){
		objcode=document.getElementById("Trowid"+"z"+CurrentRow)
		if (objcode){
			code=objcode.value;
		}
		if (objyes.checked==true){
			var ret=DelSSDoc(code)
			if (ret!=0) alert("保存失败")
			objyes.checked=false;
		}
		else
		{
			var ret=AddToSSDoc(code)
			if (ret!=0) alert("保存失败")
			objyes.checked=true;
		}
		
	}
	
	//ReloadWinow();
}


function SelectRowHandler()
{
   var row=selectedRow(window)
   CurrentRow=row;

}

///增加标记
function AddToSSDoc(code)
{
  var obj=document.getElementById("madd")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var ret=cspRunServerMethod(encmeth,code)
  return ret 
}

///删除标记
function DelSSDoc(code)
{
  var obj=document.getElementById("mdel")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var ret=cspRunServerMethod(encmeth,code)
  return ret 
}


///刷新界面
function ReloadWinow()
{	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSUser.TransDoc" ;
	location.href=lnk;
}

function ChangeRowStyle()
{
	
	       var objtbl=document.getElementById("t"+"DHCSSUser_TransDoc")
	       var cnt=getRowcount(objtbl) ;
	       if (cnt<1)return;

	       for  (var i=1;i<=objtbl.rows.length-1; i++){

	       for  (var h=1;h<=objtbl.cells.length; h++)
	         {  
	            if (objtbl.rows(i).cells(h))
	              		{
		              			var Id=objtbl.rows(i).cells[h].firstChild.id;
			                    var arrId=Id.split("z");
			                    
			                    var objindex=arrId[1];
			                    var objwidth=objtbl.rows(i).cells[h].style.width;
								var objheight=objtbl.rows(i).cells[h].style.height;
								var IMGId="ldi"+Id;
								
		              			if (arrId[0]=="Txx"){
	
									var str="<A id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" onclick=\"AddRemarkClickhandler("+objindex+")\"></A>";
									str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/update.gif\"  onclick=\"AddRemarkClickhandler("+objindex+")\">";
					          		objtbl.rows(i).cells[h].innerHTML=str;
								}
		              	} 
	         }
	         
	         
	       }
}

function AddRemarkClickhandler(row)
{
	alert("开发中")
}



document.body.onload=BodyLoadHandler;