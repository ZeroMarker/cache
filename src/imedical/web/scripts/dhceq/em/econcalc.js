
var editFlag="undefined";
var SelectRowID="";
var SourceType=getElementValue("SourceType");
var SourceID=getElementValue("SourceID"); 
var CalcFlag=getElementValue("CalcFlag");
var PurchaseTypeCode=getElementValue("PurchaseTypeCode");
var ComponentName="EM.G.BuyRequest.EconCalc"

if (CalcFlag=="N")
{
	//purchaseType��01:������02�����£�03�� ����
	if (PurchaseTypeCode=="01")
	{
		ComponentName="EM.G.BuyRequest.EconCalc01"
	}
	else if (PurchaseTypeCode=="02")
	{
		ComponentName="EM.G.BuyRequest.EconCalc02"
	}
}
var Columns=getCurColumnsInfo(ComponentName,'','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage("BuyRequest"); //��ȡ����ҵ����Ϣ
    //initLookUp();
	defindTitleStyle(); 
    //initButton();
    //initButtonWidth();
	$HUI.datagrid("#tDHCEQEconCalc",{   
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSEconCalc",
	        	QueryName:"GetEconCalc",
				SourceType:SourceType,
				SourceID:SourceID,
				CalcFlag:CalcFlag,
				PurchaseTypeCode:PurchaseTypeCode,
			},
			fit:true,
			//border:false,	//modified zy ZY0215 2020-04-01
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
			fitColumns : true,    //add by lmm 2020-06-04
			toolbar:[{
				iconCls:'icon-add',
				text:'����',
				id:'add',
				handler:function(){insertRow();}
			},
			{
				iconCls:'icon-save',
				text:'����',
				id:'save',
				handler:function(){SaveData();}
			},
			{
                iconCls: 'icon-cancel',
				text:'ɾ��',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
		    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQEconCalc').datagrid('endEdit', editFlag);
	                editFlag="undefined";
	            }
	            else
	            {
		            $('#tDHCEQEconCalc').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onSelect:function(index,row){ 
				//modified by zy ZY0223 2020-04-17
				if (SelectRowID!=index)
				{
					SelectRowID=index
				}
				else
				{
					SelectRowID=""
				}
			}
	});
	if (getElementValue("ReadOnly")==1)
	{
		$("#add").linkbutton("disable");
		$("#save").linkbutton("disable");
		$("#delete").linkbutton("disable");
	}
}

// ��������
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQEconCalc").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
    var rows = $("#tDHCEQEconCalc").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var ECYear = (typeof rows[lastIndex].ECYear == 'undefined') ? "" : rows[lastIndex].ECYear;
    var ECServiceIncome = (typeof rows[lastIndex].ECServiceIncome == 'undefined') ? "" : rows[lastIndex].ECServiceIncome;
    var ECWorkLoadNum = (typeof rows[lastIndex].ECWorkLoadNum == 'undefined') ? "" : rows[lastIndex].ECWorkLoadNum;
    var ECEquip = (typeof rows[lastIndex].ECEquip == 'undefined') ? "" : rows[lastIndex].ECEquip;
    if ((CalcFlag=="Y")&&(ECYear=="")&&(ECWorkLoadNum==""))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	    return
	}
	if ((PurchaseTypeCode=="01")&&(ECWorkLoadNum==""))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	    return
	}
	if ((PurchaseTypeCode=="02")&&(ECEquipDR==""))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	    return
	}
	$("#tDHCEQEconCalc").datagrid('insertRow', {index:newIndex,row:{}});
	editFlag=0;
}
// ����༭��
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQEconCalc').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQEconCalc').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		rows[i].ECSourceType=SourceType
		rows[i].ECSourceID=SourceID
		rows[i].ECCalcFlag=CalcFlag
		var oneRow=rows[i]
		if ((CalcFlag=="Y")&&((oneRow.ECYear=="")||(typeof(oneRow.ECYear)=="undefined")))
		{
			alertShow("��"+(i+1)+"�����ݲ���ȷ!")
			return "-1"
		}
		if ((PurchaseTypeCode=="01")&&((oneRow.ECWorkLoadNum=="")||(typeof(oneRow.ECWorkLoadNum)=="undefined")))
		{
			alertShow("��"+(i+1)+"�����ݲ���ȷ!")
			return "-1"
		}
		if ((PurchaseTypeCode=="02")&&((oneRow.ECEquipDR=="")||(typeof(oneRow.ECEquipDR)=="undefined")))
		{
			alertShow("��"+(i+1)+"�������豸����!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (dataList=="")
	{
		alertShow("��ϸ����Ϊ��!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","SaveData",dataList);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&SourceType="+SourceType+"&SourceID="+SourceID+"&CalcFlag="+CalcFlag+"&ReadOnly="+getElementValue("ReadOnly");
		url="dhceq.em.econcalc.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(CalcFlag);
	}
	else
    {
		$.messager.popover({msg:"������Ϣ:"+jsonData,type:'error'});
		return
    }
}

//modified by ZY0223 2020-04-17 ɾ���߼�bug
//modified by ZY0222 2020-04-16
function DeleteData()
{
	var rows = $('#tDHCEQEconCalc').datagrid('getSelected');  //ѡ��Ҫɾ������
	if(rows.length<=0){
		alertShow("��ѡ��Ҫɾ������.");
		return;
	}
	var RowID=(typeof rows.ECRowID == 'undefined') ? "" : rows.ECRowID
	if (RowID=="")
	{
		if(SelectRowID>="0"){
			$("#tDHCEQEconCalc").datagrid('endEdit', SelectRowID);//�����༭������֮ǰ�༭����
			if(Selectindex>="1")$("#tDHCEQEconCalc").datagrid('deleteRow',SelectRowID)
		}
		return
	}
	else
	{
		SelectRowID=RowID
		messageShow("confirm","","","ȷ��Ҫɾ����","",confirmFun,"")
	}
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	//modified by ZY0222 2020-04-16
	var RowData={"ECRowID":SelectRowID}; //add by zx 2019-09-12
	RowData = JSON.stringify(RowData);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","SaveDataList",RowData,"1");
	//jsonData=JSON.parse(jsonData)
	//if (jsonData.SQLCODE==0)
	if (jsonData==0)
	{
		var val="&SourceType="+SourceType+"&SourceID="+SourceID+"&CalcFlag="+CalcFlag+"&ReadOnly="+getElementValue("ReadOnly");
		url="dhceq.em.econcalc.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(CalcFlag);
	}
	else
    {
		$.messager.popover({msg:"������Ϣ:"+jsonData,type:'error'});
		return
    }
}
//hisui.common.js���������Ҫ
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}
 
// ��̭�豸
function getEquipDR(index,data)
{
	var rowData = $('#tDHCEQEconCalc').datagrid('getSelected');
	rowData.ECEquipDR=data.TRowID;
	var EquipEdt = $('#tDHCEQEconCalc').datagrid('getEditor', {index:editFlag,field:'TEquip'});
	$(EquipEdt.target).combogrid("setValue",data.TName);
	
	setElement("TModel",data.TRowID);
	setElement("TUseLoc",data.TUseLoc);
	setElement("TOriginalFee",data.TOriginalFee);
	//setElement("TLimitYearsNum",data.TLimitYearsNum);
	//setElement("TStartDate",data.TStartDate);
	setElement("TTransAssetDate",data.TTransAssetDate);
	setElement("TNo",data.TNo);
	$('#tDHCEQEconCalc').datagrid('endEdit',editFlag);
	$('#tDHCEQEconCalc').datagrid('beginEdit',editFlag);
}
