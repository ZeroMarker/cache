var editIndex=undefined;
var modifyBeforeRow = {};
var objtbl=$('#tDHCEQCLocUser');
var delRow=[];
var Columns=getCurColumnsInfo('PLAT.G.CT.LocUser','','','');
var toolbar = [{
	iconCls: 'icon-add',
    text:'����',
    id:'BAdd',       
    handler: function(){
         insertRow();
    }},{
	iconCls: 'icon-close',
    text:'ɾ��',
    id:'BDelete',       
    handler: function(){
         deleteRow();
    }},{
	iconCls: 'icon-save',
    text:'����',
    id:'BSave',       
    handler: function(){
         BSave_Clicked();
    }}]
	            
var init = function () {
	initUserInfo();
	initMessage("");
	setEnabled();
	
	LocUserGrid = $HUI.datagrid('#tDHCEQCLocUser', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCEQ.Plat.CTLocUser',
			QueryName: 'LocUser',
			LocID:getElementValue("LocID"),
			UserType:getElementValue("UserType"),
			QXType:getElementValue("QXType")
		},
		columns: Columns,
		toolbar: toolbar,
	    border:true,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
	    pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[10,20,30,40,50],
        onClickRow:onClickRow
	});
}
$(init);

function BSave_Clicked()
{
	var UserType=getElementValue("UserType");
	var LocID=getElementValue("LocID");
	if (LocID==""){
		messageShow('alert','alert','��ʾ',"����ID����Ϊ��!");
		return;
	}
	var valList=GetTableInfo(); 	//��ϸ��Ϣ
  	if (valList=="-1")  return; 	//��ϸ��Ϣ����
  	var DelRowid=delRow.join(',')	//GetDelRowid();
  	var val=LocID;
  	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocUser","SaveData",val,valList,DelRowid,curUserID);
  	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','success','��ʾ',"����ɹ�!");
		LocUserGrid.reload();
		editIndex=undefined;		// MZY0094	2083246		2021-09-13
		websys_showModal("options").mth();	//ˢ�¸�����
	}
	else
	{
		messageShow('alert','error','��ʾ',jsonData.Data);
	}
}

function setEnabled()
{
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly==1)
	{
		disableElement("BAdd",true);
		disableElement("BDelete",true);
		disableElement("BSave",true);
	}
}

function onClickRow(index)
{
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly==1) return
	//if (setListEditable(objtbl)==-1) return	//�����Ƿ��б�ɱ༭�ֶι�������
	if (editIndex!=index)
	{
		if (endEditing())
		{
			objtbl.datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},objtbl.datagrid('getRows')[editIndex]);
		} else {
			objtbl.datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if (objtbl.datagrid('validateRow', editIndex))
	{
		objtbl.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

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
	if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = ""
	for (var i = 0; i < rows.length; i++) 
	{
		RowNo=i+1
		
		var LUUserDR=(typeof rows[i].LUUserDR == 'undefined') ? "" : rows[i].LUUserDR
		if(LUUserDR=="")
		{
			messageShow('alert','error','��ʾ',"��"+RowNo+"����Ա����Ϊ��")
			return -1
		}
		var LUUserType=(typeof rows[i].LUUserType == 'undefined') ? "" : rows[i].LUUserType
		if(LUUserType=="")
		{
			messageShow('alert','error','��ʾ',"��"+RowNo+"����Ա���Ͳ���Ϊ��")
			return -1
		}
		
		for(var j=i+1;j<rows.length;j++){
			if((rows[i].LUUserDR==rows[j].LUUserDR)&&(rows[i].LUUserType==rows[j].LUUserType))
			{
				messageShow('alert','error','��ʾ',t[-9249].replace('[RowNoi]',RowNo).replace('[RowNoj]',j+1))
				return -1;
			}
		}
		
		if (CheckInvalidData(i)) return -1;
		var RowData=JSON.stringify(rows[i]);
		if (valList=="")
		{
			valList=RowData;
		}
		else
		{
			valList=valList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (valList=="")
	{
		messageShow('alert','error','��ʾ',t[-9248]);	//"�б���ϸ����Ϊ��!"
		return -1;
	}
	return valList;
}

function CheckInvalidData(i)
{
	return false;
}

//ɾ����
function deleteRow()
{
	if (editIndex != undefined)
	{
		if(objtbl.datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"��ʾ",t[-9242]);	//��ǰ�в���ɾ��
			return
		}
		objtbl.datagrid('endEdit', editIndex);//�����༭������֮ǰ�༭����
		var LURowID=objtbl.datagrid('getRows')[editIndex].LURowID
		delRow.push(LURowID)
		objtbl.datagrid('deleteRow',editIndex);
	}
	else
	{
		messageShow("alert",'info',"��ʾ",t[-9243]);	//��ѡ��һ��
	}
	
}

function EQUser(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.LUUserDR=data.TRowID;
	var UserNameEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'LUUserDR_UName'}); 
	$(UserNameEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function EQUserType(index,data)
{
	var rowData = objtbl.datagrid('getSelected');
    rowData.LUUserType=data.TRowID;
	var UserTypeEdt = objtbl.datagrid('getEditor', {index:editIndex,field:'LUUserType_Desc'}); 
	$(UserTypeEdt.target).combogrid("setValue",data.TName);
	objtbl.datagrid('endEdit',editIndex);
	objtbl.datagrid('beginEdit',editIndex);
}

function clearData(elementID)
{
	setElement(elementID.split("_")[0],'');
}
