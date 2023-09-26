//装载页面  函数名称固定
function BodyLoadHandler() {
	InitEvent();	//初始化
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function BUpdate_Click() //修改
{
	var value=CombinData(); //函数调用
	var str=value.split("^");
	var plist=str[0];
	var Amount=str[1];
	opener.parent.DHCEQChangeAccount.SetElement("CAAffixIDS",plist);
	var AddChange=GetElementValue("AddChange");
	if (AddChange=="true")
	{
		AddChange=1
		opener.parent.DHCEQChangeAccount.SetElement("ChangeReasonRemark","增值调账");
	}
	else
	{
		AddChange=0
		opener.parent.DHCEQChangeAccount.SetElement("ChangeReasonRemark","减值调账");
		Amount=0-Amount
	}
	opener.parent.DHCEQChangeAccount.SetChkElement("AddChangeDR",AddChange);
	opener.parent.DHCEQChangeAccount.SetElement("ChangeFee",Amount);
	opener.parent.DHCEQChangeAccount.ChangeFee_Changed();
	window.close()
	/*var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,plist,GetElementValue("ChangeAccountDR"));
	result=result.replace(/\\n/g,"\n")
	if(result<0) 
	{
		alertShow(t["01"]);
	}
	if (result>0) location.reload();	*/
}

function CombinData()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCAAffix');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var IDS=""
	var sum=0
	for (var i=1;i<=lastrowindex;i++)
	{
		var ID=GetElementValue("TAffixDRz"+i)
		var Flag=GetChkElementValue("TFlagz"+i)
		var obj=document.getElementById("TAmountz"+i)
		if (obj)
		{
			var Amount=parseFloat(obj.innerText)
		}
		if (Flag==true)
		{
			Flag="Y"
			sum=sum+Amount
		}
		else
		{
			Flag="N"
		}
		IDS=IDS+ID+":"+Flag+","
	}
	IDS=","+IDS;
	return IDS+"^"+sum
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
