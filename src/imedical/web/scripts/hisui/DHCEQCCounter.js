//�豸������
var Component="tDHCEQCCounter"  //add by lmm 2018-10-10 hisui���죺���������
function BodyLoadHandler() 
{  
    initPanelHeaderStyle() //added by LMH 20230210 UI �������������������ʽ
    initButtonColor(); //added by LMH 20230210 UI ��ʼ����ť��ɫ
	initButtonWidth();  //add by lmm 2018-09-05 hisui���죺�޸İ�ť����
	InitUserInfo();
	//InitEvent();     //modify by lmm 2018-10-18 hisui���죺�ݲ�����
	//SetDisable();    //modify by lmm 2018-10-18 hisui���죺�ݲ�����
}

function InitEvent()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{		
		var obj=document.getElementById("TGroupFlagz"+i);
		if (obj) obj.onclick=BGroupFlag_Click;
	}
	
}
///modify by lmm 2018-10-10
///������hisui���죺��д���·��������ݻ�ȡ
function BUpdate_Click()
{
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length
	if(RowCount<=0){
		jQuery.messager.alert("û�д���������");
		return;
	}
	
		var combindata="";
	for (i=0;i<RowCount;i++)
	{
		if($('#'+Component).datagrid('getEditor',{index:i,field:'TGroupFlag'}).target.checkbox("getValue")==true)
		{
			var TGroupFlag=1
		}
		else
		{
			var TGroupFlag=0
			
		}
		combindata=combindata+"^"+rows[i].TRowID;
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TCounterNum'}).target.val();  //ֵ
		combindata=combindata+"^"+rows[i].TypeDR;       //����
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TLength'}).target.val();      //��ע
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TPrefix'}).target.val();		//ǰ׺
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TSuffix'}).target.val();   		//��׺
		combindata=combindata+"^"+TGroupFlag            //�Ƿ����
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TGroup'}).target.val();		//�����ַ���
		combindata=combindata+"^"+rows[i].THold1;		//����1
		combindata=combindata+"^"+rows[i].THold2;		//����2
		combindata=combindata+"^"+rows[i].THold3;		//����3
		combindata=combindata+"^"+";"
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata);
	if (gbldata!=0)
	{
		messageShow("","","",t[-2201])
		return
	}
	else
	{
		location.reload();
	}
}
function BGroupFlag_Click()
{
	var i=GetTableCurRow();
	var obj=document.getElementById("TGroupFlagz"+i);
	if (obj.checked==true)
	{
		DisableElement("TCounterNumz"+i,true)
		DisableElement("TGroupz"+i,false)
	}
	else
	{
		DisableElement("TCounterNumz"+i,false)
		DisableElement("TGroupz"+i,true)
	}
	
}
function SetDisable()
{	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var combindata="";
	for (i=1;i<rows;i++)
	{		
		var GroupFlag=GetChkElementValue("TGroupFlagz"+i)
		if (GroupFlag==true)
		{
			DisableElement("TCounterNumz"+i,true)
		}
		else
		{
			DisableElement("TGroupz"+i,true)
		}
	}
}

///add by lmm 2018-10-10
///hisui���죺���ӿɱ༭�б�ť
$('#'+Component).datagrid({
	toolbar:[{  
		iconCls: 'icon-save', 
        text:'����',          
        handler: function(){
            BUpdate_Click();
        }  
    }],
})

document.body.onload = BodyLoadHandler;
