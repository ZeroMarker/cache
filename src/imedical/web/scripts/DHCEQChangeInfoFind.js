//�豸�䶯��Ϣ 

function BodyLoadHandler() 
{
	KeyUp("EquipName^ChangeType")	//���ѡ��
	Muilt_LookUp("EquipName^ChangeType");
	SetLink();
	//ChangeTypelnk();
//var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFeeFind'	
//var obj=document.getElementById('tDHCEQChangeInfoFind');
//	if (obj) {obj.ondblclick=DB_Clicked;}//˫��
 //var obj=document.getElementById('tDHCEQChangeInfoFind');
	//if (obj) obj.onclick=ChangeTypelnk;//����	
	
}

function KeyUp1(Value)
{
	var value=Value.split("^")
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) {obj.onchange=Standard_KeyUp1;}
		else{
		alertShow(value[i])}
	}
}
function Standard_KeyUp1()
{
	var eSrc=window.event.srcElement;
	var objDR=document.getElementById(eSrc.id+"DR");
	var obj=document.getElementById(eSrc.id);
	objDR.value="";	
	obj.value="";

}
function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQChangeInfoFind');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TChangeTypez'+i);
		SelRowObj.onclick=lnk_Click;//����
		SelRowObj.href="#";
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//��ȡ�¼�Դͷ
	var row=GetRowByColName(eSrc.id);//����
	var lnk=GetHref(row);//����
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)//TChangeTypez TRowIDz
{
	var SelRowObj=document.getElementById('TEquipDRz'+row);
	var TypeObj=document.getElementById('TEquipNameDRz'+row);
	var TypeObjid=document.getElementById('TChangeTypeidDRz'+row);
	var para="RowID"
	var lnk="";
	if(TypeObjid.value==1)//����DHCEQStart
	{ComponentName="DHCEQStart"}
	else if(TypeObjid.value==2)//���DHCEQStop
	{ComponentName="DHCEQStop"}
	else if(TypeObjid.value==3)//����DHCEQMove
	{ComponentName="DHCEQMove"}
	else if(TypeObjid.value==4)//����DHCEQMoveOut
	{ComponentName="DHCEQMoveOut"}
 	else if(TypeObjid.value==5)//����DHCEQChangeAccount
	{ComponentName="DHCEQChangeAccount"	}
 	else if(TypeObjid.value==6)//����DHCEQDisuseRequest
	{ComponentName="DHCEQDisuseRequest"	;
	 para="EquipDR";	}
 	else if(TypeObjid.value==7)//���ޱ��
	{ComponentName="DHCEQChangeYears"	}
	
	lnk=ComponentName+'.csp?'+'&'+para+'='+SelRowObj.value;//+'&ChangeType='+ChangeType+'&EquipNameDR='+EquipNameDR;
	return lnk;
}
/*
function ChangeTypelnk()
{
	alertShow("33");
	var eSrc=window.event.srcElement;
	alertShow("eSrc"+"/"+eSrc);
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TEquipNameDRz'+selectrow);//�䶯���ʹ���
	alertShow("obj.value"+"/"+obj.value);
	var EquipNameDR=obj.value;//����
	alertShow("EquipNameDR"+"/"+EquipNameDR);
	var obj=document.getElementById('TEquipDRz'+selectrow);//�豸���ƴ���
	var EquipDR=obj.value;//����
	if(EquipNameDR==1)//����DHCEQStart
	{
	ComponentName="DHCEQStart"
	}
	else if(EquipNameDR==2)//���DHCEQStop
	{
		ComponentName="DHCEQStop"
	}
	else if(EquipNameDR==3)//����DHCEQMove
	{
		ComponentName="DHCEQMove"
		}
	else if(EquipNameDR==4)//����DHCEQMoveOut
	{
		ComponentName="DHCEQMoveOut"
		}
 	else if(EquipNameDR==5)//����DHCEQChangeAccount
	{
		ComponentName="DHCEQChangeAccount"
		}
 	else if(EquipNameDR==6)//����DHCEQDisuseRequest
	{
		ComponentName="DHCEQDisuseRequest"
		}
 	else if(EquipNameDR==7)//���ޱ��
	{
		ComponentName="DHCEQChangeYears"
		}
		
	alertShow("ComponentName"+ComponentName);
var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+omponentName
        +"&EquipDR="+iEquipDR
 window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');

	}
/*
function DB_Clicked()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TEquipNameDRz'+selectrow);
	var EquipNameDR=obj.value;//����
	var obj=document.getElementById('TChangeTypez'+selectrow);//�䶯����
	var ChangeType=obj.innerText;//��ʾ
	var obj=document.getElementById('TEquipNameDRz'+selectrow);//�䶯���ʹ���
	var EquipNameDR=obj.value;//����
	var obj=document.getElementById('TEquipDRz'+selectrow);//�豸���ƴ���
	var EquipDR=obj.value;//����
	if(EquipNameDR==1)//����DHCEQStart
	{ComponentName="DHCEQStart"	}
	else if(EquipNameDR==2)//���DHCEQStop
	{	ComponentName="DHCEQStop"	}
	else if(EquipNameDR==3)//����DHCEQMove
	{	ComponentName="DHCEQMove"		}
	else if(EquipNameDR==4)//����DHCEQMoveOut
	{	ComponentName="DHCEQMoveOut"		}
 	else if(EquipNameDR==5)//����DHCEQChangeAccount
	{	ComponentName="DHCEQChangeAccount"		}
 	else if(EquipNameDR==6)//����DHCEQDisuseRequest
	{	ComponentName="DHCEQDisuseRequest"		}
 	else if(EquipNameDR==7)//���ޱ��
	{	ComponentName="DHCEQChangeYears"	}
 	var str='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&EquipDR='+EquipDR;//+'&ChangeType='+ChangeType+'&EquipNameDR='+EquipNameDR;
     window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}
*/
function ChangeTypeDR(value) // �䶯����
{
	//alertShow(value);
	var obj=document.getElementById("ChangeTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function EquipNameDR(value) // �䶯����
{
	//alertShow(value);
	var obj=document.getElementById("EquipNameDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
document.body.onload = BodyLoadHandler;