//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitEvent();	//��ʼ��
	initButtonWidth()  //hisui���죺�޸Ľ��水ť���� add by lmm 2018-08-20
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}

function BUpdate_Click() //�޸�
{
	var value=CombinData(); //��������
	var str=value.split("^");
	var plist=str[0];
	var Amount=str[1];
	websys_showModal("options").mth("CAAffixIDS",plist,"1");  //modify by lmm 2019-02-20
	var AddChange=GetElementValue("AddChange");
	if (AddChange=="true")
	{
		AddChange=1
		websys_showModal("options").mth("ChangeReasonRemark","��ֵ����","1");  //modify by lmm 2019-02-20
	}
	else
	{
		AddChange=0
		websys_showModal("options").mth("ChangeReasonRemark","��ֵ����","1");  //modify by lmm 2019-02-20
		Amount=0-Amount
	}
	websys_showModal("options").mth("AddChange",AddChange,"2");  //modify by csj 2020-02-17	1190919
	websys_showModal("options").mth("AddChangeDR",AddChange,"1");  //add by csj 2020-02-17	1190919
	websys_showModal("options").mth("ChangeFee",Amount,"1");  //modify by lmm 2019-02-20
	websys_showModal("options").mth("","","3");  //modify by lmm 2019-02-20
	closeWindow("modal")  //modify by lmm 2019-02-20
	
	/*var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,plist,GetElementValue("ChangeAccountDR"));
	result=result.replace(/\\n/g,"\n")
	if(result<0) 
	{
		messageShow("","","",t["01"]);
	}
	if (result>0) location.reload();	*/
}
///modify by lmm 2018-09-10 
///������hisui���죺�޸ĵ�ǰҳֵ��ȡ
function CombinData()
{
	var objtbl = $('#tDHCEQCAAffix').datagrid('getRows');
	var rows=objtbl.length
	
	
	var IDS=""
	var sum=0
	for (var i=0;i<rows;i++)
	{
		var ID=objtbl[i].TAffixDR  
		var Flag=getColumnValue(i,"TFlag") 
		var obj=objtbl[i].TAmount  
		
		var Amount=parseFloat(obj)
		if (Flag==1)
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

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
