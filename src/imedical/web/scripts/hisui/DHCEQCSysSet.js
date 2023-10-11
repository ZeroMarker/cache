//�豸ϵͳ���ñ�
var Component="tDHCEQCSysSet"  //add by lmm 2018-09-05 hisui���죺���������
var editIndex=undefined;
var objtbl=$('#tDHCEQCSysSet');
function BodyLoadHandler() 
{	
	InitUserInfo();
	//initButtonWidth();  //add by lmm 2018-09-05 hisui���죺�޸İ�ť����
	$('#'+Component).datagrid({
		onClickRow:function (rowIndex, rowData) {
		    if (rowData.TCode!="990018")
		    {
			    $('#'+Component).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		    }
		    else
		    {
			    ///FTP����ά������
			    var url='dhceq.plat.ftpserver.csp?&SSRowID='+rowData.TRowID;	//CZF0138
			    showWindow(url,"FTPServer����","","6row","icon-w-paper","modal","","","small"); //modify by lmm 2020-06-05 UI
		    }
			},
		//onLoadSuccess:function(){}    //modify by lmm 2020-09-23 1514376 gen���Ѷ��壬�ظ�����		
	})
	initBDPHospComponent("DHC_EQCSysSet");	//CZF0138 ��Ժ������ begin
	var HospFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051")
	if (HospFlag!=2)
	{
		hiddenObj("BAdd",true);
		$("#tDHCEQCSysSet").datagrid('getColumnOption', 'TCode').editor = {};
		$("#tDHCEQCSysSet").datagrid('getColumnOption', 'TDesc').editor = {};
		$("#tDHCEQCSysSet").datagrid('getColumnOption', 'TRemark').editor = {};
	}										//CZF0138 ��Ժ������ end
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	initSysSetGrid();
}

//CZF0138
function initSysSetGrid()
{
	var HospDR=GetBDPHospValue("_HospList");
	$("#tDHCEQCSysSet").datagrid({
		url:$URL,
		queryParams:{
			ComponentID:GetElementValue("GetComponentID"),
			gHospId:curSSHospitalID,
			BDPHospId:HospDR
		},
		showRefresh:false,
		showPageList:false,
		afterPageText:'',
		beforePageText:''
	})
}

//CZF0138
//���ݹ���ҽԺ��ť����¼�
function HospitalHandle()
{
	var rows=$("#tDHCEQCSysSet").datagrid('getSelected');
	if (rows==null)
	{
		$.messager.alert("��ʾ", "��ѡ���豸����!", 'info');
		return
	}
	var SSRowID=rows.TRowID;
	if(SSRowID==""){
		$.messager.alert("��ʾ", "��ѡ���豸����!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCSysSet",SSRowID,function(){
		//�ص�����;
	});
}

///modify by lmm 2018-09-05
///������hisui���죺��д���·��������ݻ�ȡ
function BUpdate_Click()
{
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length
	if(RowCount<=0){
		alertShow("û�д���������");
		return;
	}
	var combindata=GetTableInfo();
	if (combindata==-1) return;
	SetData(combindata);//���ú���	
}
function SetData(combindata)
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata,curSSHospitalID,GetBDPHospValue("_HospList"));
	var plist=gbldata.split("^");
    //location.reload();
    $("#tDHCEQCSysSet").datagrid('reload');
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
    },{ 
    	id:'BAdd',
		iconCls: 'icon-add', 
        text:'����',          
        handler: function(){
            insertRow();
        }  
    }],
})

// ��������
function insertRow()
{
	if(editIndex>="0"){
		objtbl.datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
	}
    var rows = objtbl.datagrid('getRows');
    var newIndex=rows.length; 
    if(GetTableInfo()=="-1")
    {
	    return
	}
	else
	{
		objtbl.datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}


//��ȡ�б���ϸ
function GetTableInfo()
{
	var valList="";
	//if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = ""
	for (var i = 0; i < rows.length; i++) 
	{
		objtbl.datagrid('endEdit', i);
		RowNo=i+1;
		var TRowID=(typeof rows[i].TRowID == 'undefined') ? "" : rows[i].TRowID
		var TCode=(typeof rows[i].TCode == 'undefined') ? "" : rows[i].TCode
		var TDesc=(typeof rows[i].TDesc == 'undefined') ? "" : rows[i].TDesc
		if(TCode=="")
		{
			messageShow('alert','error','��ʾ',t[-9251].replace('[RowNo]',RowNo))	//"��[RowNo]�д��벻��Ϊ��!"
			return -1
		}
		if(TDesc=="")
		{
			messageShow('alert','error','��ʾ',t[-9251].replace('[RowNo]',RowNo))	//"��[RowNo]����������Ϊ��!"
			return -1
		}
		if ((TCode=="990018")&&(TRowID!="")) continue;			//ftp��Ϣ�ڵ�������д
		if ((TCode=="")||(TDesc=="")) continue;	
		var RowData=JSON.stringify(rows[i]);
		if (valList=="")
		{
			valList=RowData;
		}
		else
		{
			valList=valList+"$$"+RowData;
		}
	}
	if ((valList=="")&&(rows.length>0))
	{
		messageShow('alert','error','��ʾ',t[-9248]);	//"�б���ϸ����Ϊ��!"
		return -1;
	}
	return valList;
}

document.body.onload = BodyLoadHandler;