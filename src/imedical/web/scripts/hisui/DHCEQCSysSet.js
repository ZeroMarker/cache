//�豸ϵͳ���ñ�
var Component="tDHCEQCSysSet"  //add by lmm 2018-09-05 hisui���죺���������
function BodyLoadHandler() 
{	
	InitUserInfo();
	initButtonWidth();  //add by lmm 2018-09-05 hisui���죺�޸İ�ť����
	$('#'+Component).datagrid({
		onClickRow:function (rowIndex, rowData) {
		    if (rowData.TCode!="990018")
		    {
			    $('#'+Component).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		    }
		    else
		    {
			    ///FTP����ά������
			    var url='dhceq.plat.ftpserver.csp?';
			    showWindow(url,"FTPServer����","","6row","icon-w-paper","modal","","","small"); //modify by lmm 2020-06-05 UI
		    }
			},
		onLoadSuccess:function(){}		
	})
}
///modify by lmm 2018-09-05
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
		$('#'+Component).datagrid('selectRow', i).datagrid('endEdit', i);
		//FTP����������Ҫ����������Ҫ˫�����浥��ά��.
		if (rows[i].TCode!="990018")
		{
			combindata=combindata+"^"+rows[i].TRowID;
			combindata=combindata+"^"+rows[i].TValue; ;//ֵ
			combindata=combindata+"^"+rows[i].TDesc; ;//����
			combindata=combindata+"^"+rows[i].TRemark; ;//��ע
			combindata=combindata+"^"+rows[i].TAddValue; ;//ֵ
			combindata=combindata+"^"+"$$"  //modify by lmm 2020-02-25 1198217  ����ʹ��;�ҳ������ʸ�Ϊ$$
		}
	}		
	var len=RowCount+1	
	SetData(combindata,len);//���ú���	
}
function SetData(combindata,rows)
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata,rows);
	var plist=gbldata.split("^");
    location.reload();
}
///add by lmm 2018-10-28
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