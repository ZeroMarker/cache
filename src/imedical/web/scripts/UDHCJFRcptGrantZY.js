var SelectedRow = 0;
var maxrowid ;
var stno;
var endno;
var guser;
function BodyLoadHandler() {
	guser=session['LOGON.USERID']
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=Add_click;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_click;
	document.getElementById('stno').readOnly=true
   
    document.getElementById('userid').value=guser;
    StartNo()    
    
}
function StartNo()
{  
    var getstno=document.getElementById('getstno');
	if (getstno) {var encmeth=getstno.value} else {var encmeth=''};	
	if (cspRunServerMethod(encmeth,'SetNo','',guser)=='0') {
			}
}
function SetNo(value)
{   str=value
    str=str.split("^")
	var obj=document.getElementById('stno');
	obj.value=str[0];
	obj1=document.getElementById('endno');
	obj1.value=str[1];
	obj2=document.getElementById('kyendno');
	obj2.value=str[1];
}
function Add_click()	
{
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
    var kyendno=document.getElementById('kyendno').value;
    if (endno>kyendno) 
    {  alert(t['04'])
       return
    }
   if (parseInt(endno,10)<parseInt(stno,10))
	{  alert(t['11'])
	   return ;
	}
    
    var lquserid=document.getElementById('lquserid').value;
    if (lquserid=="") {
		alert(t['05']);
		return;}
    var title=document.getElementById('title').value;
    userid=session['LOGON.USERID']
    var Ins=document.getElementById('Ins');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPid','',stno,endno,kyendno,userid,lquserid,title)=='0') {
			}
}
function Delete_click()
{
	selectrow=SelectedRow;
	var grantrowid=document.getElementById('grantrowid').value;
	//判断是否为最后一条并且是未发放的?可以删除
	//删除时更新购入表的当前号码
	if (grantrowid=="") {
		alert(t['06'])
		return;}
	//到表里去最后一笔记录
	var del=document.getElementById('maxrowid');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'MaxRowId','')=='0') {
			}
   
	if (grantrowid!=maxrowid)
	{   alert(t['07'])
	    return;
	}  		
	if ((grantrowid=maxrowid)&(stno!=curno))
	{  alert(t['08'])
	   return ;
	}
	del=document.getElementById('del');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'SetPid','',grantrowid)=='0') {
			}
}
function MaxRowId(value)
{
   var str=value
   str=str.split("^")
   maxrowid=str[0]
   stno=str[1]
   curno=str[2]
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCJFRcptGrant');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
  
	if (!selectrow) return;
	var obj=document.getElementById('grantrowid');
	var SelRowObj=document.getElementById('Tgrantrowidz'+selectrow);
	var grantrowid=SelRowObj.innerText;

	obj.value=grantrowid
	SelectedRow = selectrow;
}

function SetPid(value) 
{   
	if (value!="0")
	{alert(t['09']);
	return;}
	if (value=="0")	
	{   alert(t['10']);
	    Find_click();
	}
}
function LookUpUser(str)
{
	var obj=document.getElementById('lquserid');
	var tem=str.split("^");
	obj.value=tem[1];
}

document.body.onload = BodyLoadHandler;