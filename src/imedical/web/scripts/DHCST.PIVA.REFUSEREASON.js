var currRow="";

function BodyLoadHandler()
{
  iniForm()
  var obj=document.getElementById("Update")
  if (obj) obj.onclick=setReason;
  var obj=document.getElementById("bFind")
  if (obj) obj.onclick=bFind_click; 
  var obj = document.getElementById("type");
	if (obj){
		setOecType();
		obj.onchange=OecTypeSelect;
	}
  
     
}

function SelectRowHandler()
{
	currRow=selectedRow(window)
	setItem(currRow)
}
function iniForm(){

	var obj=document.getElementById("type");
	if (obj){
		obj.size=1; 
	 	obj.multiple=false;
	 	obj.options[0]=new Option('�ܾ�',"R");
	 	obj.options[1]=new Option('ȡ��',"C");
	 	obj.options[2]=new Option('��˾ܾ�',"P");
	 	obj.options[3]=new Option('',"");
	}
}
function setItem(currRow)
{
   
   var objcode=document.getElementById("Tcode"+"z"+currRow)
   if (objcode) var code=objcode.innerText;
   var objdesc=document.getElementById("Tdesc"+"z"+currRow)
   if (objdesc) var desc=objdesc.innerText
   var objtype=document.getElementById("Ttype"+"z"+currRow)
   if (objtype) var type=objtype.innerText
   var objflag=document.getElementById("Tflag"+"z"+currRow)

   var objcode=document.getElementById("code")
    objcode.value=code
   var objdesc=document.getElementById("desc")
    objdesc.value=desc
   var objtype=document.getElementById("type")
    if (type=="�ܾ�"){objtype.value="R"}
    if (type=="ȡ��"){objtype.value="C"}
    if (type=="��˾ܾ�"){objtype.value="P"}
   var objset=document.getElementById("set")
   objset.checked=false;
   if (objflag.checked==true){objset.checked=true}

}
function setReason()
{

    if (currRow!=""){var flag=2
    	var objrowid=document.getElementById("Trowid"+"z"+currRow)
        var rowid=objrowid.value;}
    if (currRow=="") {
	      flag=1
          rowid=""}   //flag 1:����   2:����
	var objcode=document.getElementById("code")
	var code=objcode.value
	if (code==""){alert("����û����д")
	              return;}
	var objdesc=document.getElementById("desc")
	var desc=objdesc.value
	if (desc==""){alert("����û����д")
	              return;}
	var objtype=document.getElementById("type")
	var type=objtype.value
	if (type=="")
	{
		alert("���Ͳ���Ϊ��!");
		return;
	}
	var objset=document.getElementById("set")
	if(objset.checked==true){var set="Y"}
	else{var set="N"}
    var xx=document.getElementById("mSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,code,desc,type,set,flag,rowid)
	if (result==-1){alert("������ʧ��!")}
	else if (result==-11){alert("�����ظ�!");return;}
	else if (result==-12){alert("�����ظ�!");return;}
	else {alert("OK")}
	self.location.reload();
	
}

///Type
function OecTypeSelect()
{
	var obj=document.getElementById("TypeIndex");
	if(obj){
		var objtype=document.getElementById("type");
		obj.value=objtype.selectedIndex;
	}
}
function setOecType()
{
	var obj=document.getElementById("type");
	var objindex=document.getElementById("TypeIndex");
	//�״μ���Ĭ��
	if (objindex.value=="")
	{
		objindex.value=3
	}
	if (objindex) obj.selectedIndex=objindex.value;
}
document.body.onload=BodyLoadHandler