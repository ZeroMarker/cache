function BodyLoadHandler()
{   
var objExcute=document.getElementById('butExcute');
if (objExcute) objExcute.onclick=OK_Click;
Setdefaultvalue();

}
function Setdefaultvalue()
{
   var objSeeTypeId=document.getElementById('SeeTypeId');
   if (objSeeTypeId) objSeeTypeId.value="A";
   var objSeeType=document.getElementById('SeeType');
   if(objSeeType) objSeeType.value="����"
	}
function getSeeTypeRowid(Str)
{
	var objSeeTypeId=document.getElementById('SeeTypeId');
	var StrArr=Str.split("^");
	if (objSeeTypeId) objSeeTypeId.value=StrArr[1]
	}
function OK_Click()
{
  var objtbl=opener.document.getElementById('tDHCNURSEXCUTE');
  if(!objtbl) var objtbl=opener.document.getElementById('tDHCNurIPExec');
  var rowid="",count=0;
  var result="error"
  var oeoriStrArr=[];
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=opener.document.getElementById("seleitemz"+i);
	   if (item.checked==true)
       {
	        count=count+1;
           	var arcimDesc=opener.document.getElementById("arcimDescz"+i).innerText; 
			//if (arcimDesc.indexOf("____")>-1) continue;	
            var oeoriId=opener.document.getElementById("oeoriIdz"+i).innerText;
            oeoriStrArr[oeoriStrArr.length]=oeoriId
       }
	}
	var objSeeTypeId=document.getElementById('SeeTypeId');
	var SeeDate=document.getElementById('SeeDate').value;
	if (!IsValidDate(document.getElementById('SeeDate'))){
		alert("��������ȷ������")
		return;
	}
	var SeeTime=document.getElementById('SeeTime').value;
	if (!IsValidTime(document.getElementById('SeeTime'))){
		alert("��������ȷ��ʱ��")
		return;
	}
	var SeeNote=document.getElementById('SeeNote').value;
	var userId=session['LOGON.USERID'];
	for (j=0;j<oeoriStrArr.length;j++)
	{
		var oeoriId=oeoriStrArr[j];
		var ret=tkMakeServerCall("web.DHCLCNUREXCUTE","SeeOrder",oeoriId,userId,objSeeTypeId.value,SeeNote,SeeDate,SeeTime);
		if (ret!="0")
		{
			alert(ret)
			return false;
			}
		else
		{
			result="success"
			}
	}
    if (result=="success")
    {
	   alert("�����ɹ�!");
       self.close();
       opener.location.reload();
       }
}
document.body.onload = BodyLoadHandler;