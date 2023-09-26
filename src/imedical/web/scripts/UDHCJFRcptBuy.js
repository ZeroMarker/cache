var SelectedRow = 0;
var typeobj,userobj
var comment1,tbRows=0,rowid
function BodyLoadHandler() {
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=Add_click;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_click;
	typeobj=document.getElementById("type");
	typeobj.onkeydown=gettype;
	userobj=document.getElementById("gruser");
	userobj.onkeydown=getuser;
	var resumeGrantobj=document.getElementById("resumeGrant");
	resumeGrantobj.onclick=resumeGrant_click;
	var numobj=document.getElementById('number');
	if (numobj) numobj.onkeyup = celendno;
	//document.getElementById('grp').value="A"
	//document.getElementById('type').value="I"
	//document.getElementById('stno').readOnly=true
    StartNo()
}
function StartNo()
{  
    var type
    type=document.getElementById('type').value
    selectrow=SelectedRow;
    var UserID=session['LOGON.USERID'];
    var HospDr=session['LOGON.HOSPID'];
	var getstno=document.getElementById('getstno');
	if (getstno) {var encmeth=getstno.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetNo','',type,UserID,HospDr)=='0') {
			}
}
function SetNo(value)
{
	var obj=document.getElementById('stno');
	obj.value=value;
	
}
function Add_click()	
{   
	//selectrow=SelectedRow;
	var stno=document.getElementById('stno').value;
		
	if (stno=="") {
		alert(t['01'])
		return;}
    var endno=document.getElementById('endno').value;
    if (endno=="") {
		alert(t['02']);
		return;}
    if ((stno.length)!=(endno.length))
    {
	    alert(t['03'])
	    return
    }
    if (!checkno(stno)) {
		  alert(t['16']); 
		  websys_setfocus('stno');
		  return false;
		  }
	if (!checkno(endno)) {
		  alert(t['17']);
	      websys_setfocus('endno');
		  return false;
	       }
	if (parseInt(endno,10)<parseInt(stno,10))
	{  alert(t['10'])
	   return ;
	}

    var gruser=document.getElementById('gruser').value;
    if (gruser=="") {
		alert(t['04']);
		return;}
    var buynote=document.getElementById('getbuynote');
    //if (buynote) {var encmeth=buynote.value} else {var encmeth=''};
    //var buynum=cspRunServerMethod(encmeth,'','',stno,endno)    
   // if (eval(buynum)>0) {
	//    alert(t['14']);
	//	return;
    //}
    var title=document.getElementById('title').value;
    var type=document.getElementById('type').value;
    if (type=="")
    {   alert(t['15'])
        return
    }
    var userid=document.getElementById('userid').value;
    var HospDr=session['LOGON.HOSPID'];
    var Ins=document.getElementById('Ins1');

	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'SetPid','',stno,endno,userid,title,type,HospDr)=='0') {
			}
}
function Delete_click()
{  
	selectrow=SelectedRow;
	var buyrowid=document.getElementById('buyrowid').value;
	if (buyrowid=="") {
		alert(t['05'])
		return;}
	
	var del=document.getElementById('maxrowid');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'MaxRowId','')=='0') {
			}
	if (buyrowid!=maxrowid)
	{   alert(t['06'])
	    return;
	}  		
	if ((buyrowid=maxrowid)&(stno!=curno))
	{  alert(t['07'])
	   return ;
	}
	
    del=document.getElementById('del');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'SetPid','',buyrowid)=='0') {
			}
}
function MaxRowId(value)
{
   str=value
   str=str.split("^")
   maxrowid=str[0]
   stno=str[1]
   curno=str[2]
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCJFRcptBuy');
	var rows=objtbl.rows.length;
	tbRows=rows-1
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
  
	if (!selectrow) return;
	var obj=document.getElementById('buyrowid');
	var SelRowObj=document.getElementById('Tbuyrowidz'+selectrow);
	var buyrowid=SelRowObj.innerText;
	rowid =buyrowid
	var SelRowObj=document.getElementById('comment1z'+selectrow);
	comment1=SelRowObj.innerText;
	obj.value=buyrowid
	SelectedRow = selectrow;
}

function SetPid(value) 
{  
	if (value==-505)
	{
		alert("不能重复购入押金收据.")
		return
	}
	else if (value!="0")
	{   	    
		alert(t['08']);
	    return;
	}
	else{	
	    alert(t['09']);
	}
	var findobj=document.getElementById('Find');
    if (findobj) findobj.click()
}
function LookUpUser(str)
{  
	var obj=document.getElementById('userid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function checkno(inputtext) {
        var checktext="1234567890"
        for (var i = 0; i < inputtext.length; i++) {
            var chr = inputtext.charAt(i);
            var indexnum=checktext.indexOf(chr);
            if (indexnum<0)  return false;
        }
        return true;
    }
function gettype()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  type_lookuphandler();
		}
	}
function getuser()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  gruser_lookuphandler();
		}
	}
	
	
//恢复发放
function resumeGrant_click()
{
	var userFlag="",num=0
	if(SelectedRow==0)
	{
		alert("请选择一行!")
		return
	}
	if(comment1==" ")
	{
		alert("所选的行不是恢复发放的类型!")
		return
	}
	if(comment1!="Return")
	{
		alert("该收据已经恢复发放过了!")
		return
	}
	for(var i=1;i<=tbRows;i++)
	{
		var SelRowObj=document.getElementById('Tuseflagz'+i);
	    var tuseflag=SelRowObj.innerText;
		if(tuseflag=="可用")
		  userFlag=""
		if(tuseflag=="已发完")
		  num=num+1
	}
	if(num==tbRows)
	{
		userFlag="1"
	}
	var grantToObj=document.getElementById('grantTo');
	if(grantToObj){var encmeth=grantToObj.value} else {var encmeth=''};
	
	var rs=cspRunServerMethod(encmeth,'','',rowid,userFlag)
	if(rs==0)
	{
		alert("恢复发放成功!")
		window.location.reload();
		return
	}
	else
	{
		alert("恢复发放失败!")
		return
	}
}
function celendno()
{
   var numobj=document.getElementById('number');
   if (numobj) var num=numobj.value
   var snoobj=document.getElementById('stno');
   if (snoobj) var sno=snoobj.value
   var ssno=""
   var ssno1,slen,sslen
   if (num==""||(parseInt(num,10)==0)) return;
   if (checkno(num)&&(sno!="")&&checkno(sno)) 
   {
      ssno1=parseInt(sno,10)+parseInt(num,10)-1;
      ssno=ssno1.toString()
      slen=sno.length
      sslen=ssno.length
      for (i=slen;i>sslen;i--){
         ssno="0"+ssno
      }
      var endnoobj=document.getElementById('endno');
      if (endnoobj) endnoobj.value=ssno;
   }
}
document.body.onload = BodyLoadHandler;