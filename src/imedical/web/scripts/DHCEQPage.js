///Created By JDL 2011-8-30 JDL0095

///��ʼ������ҳ���ҳ����Ϣ
function InitPageNumInfo(Node,ComponentName)
{
	var Lnk=location.href;
	var Find=Lnk.indexOf("&TPAGCNT=");
	var RowsPerPage="";
	var Page="0"
	var TJob=GetElementValue("TJobz1");
	if (Find>0)
	{
		var Pre=Lnk.substring(0,Find);
		var End=Lnk.substring(Find+9);
		var List=End.split("&");
		Page=List[1];
	}
	
	if (Page=="0")
	{
		var objtbl=document.getElementById('t'+ComponentName);//+����� ������������ʾ Query ����Ĳ���
		var rows=objtbl.rows.length;
		if (rows>1) RowsPerPage=rows-1;
	}
	var encmeth=GetElementValue("GetPageInfo");
	var PagesNum=cspRunServerMethod(encmeth,Node,TJob,RowsPerPage);
	if (PagesNum>0)
	{
		SetElement("PagesNum",PagesNum);
		var obj=document.getElementById("BGo")
		if (obj) obj.onclick=BGo_Click;
	}
	else
	{
		SetElement("PagesNum","");
		DisableBElement("BGo",true);
	}
	///alertShow(Node+"&"+TJob+"&"+RowsPerPage+"&"+PagesNum);	
}

function BGo_Click()
{
	var PagesNum=GetElementValue("PagesNum");
	var ToPage=GetElementValue("Page");
	if ((PagesNum==""))
	{
		alertShow('û������!');
		return;
	}
	if ((ToPage=="")||(parseInt(ToPage)<1))
	{
		alertShow('��������ȷ��ҳ��!');
		return;
	}
	
	if (parseInt(ToPage)>parseInt(PagesNum))
	{
		alertShow('����ҳ�볬������ҳ��!');
		return;
	}
	
	ToPage=ToPage-1;
	var Lnk=location.href;
	var Find=Lnk.indexOf("&TPAGCNT=");
	if (Find>0)
	{
		var Pre=Lnk.substring(0,Find);
		var End=Lnk.substring(Find+9);
		var Find=End.indexOf("&");
		if (Find>0)
		{
			End=End.substring(Find);
		}
		else
		{
			End="";
		}
		Lnk=Pre+End;
	}
	if (Lnk.substring(Lnk.length-1)=="#")
	{
		Lnk=Lnk.substring(0,Lnk.length-1)
	}
	Lnk=Lnk+"&TPAGCNT="+ToPage;
	location.href=Lnk;
}
