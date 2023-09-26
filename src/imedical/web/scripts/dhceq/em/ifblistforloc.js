
var url="dhceq.jquery.operationtype.csp";
var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('EM.G.IFB.IFBListForLoc','','','')

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
	$HUI.datagrid("#tDHCEQIFBList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSIFBList",
	        QueryName:"IFBListDetail",	        
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID")
			},
			fit:true,
			//border:'true',	//modified zy ZY0215 2020-04-01
			fitColumns : true,    //add by lmm 2020-06-04
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
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
				iconCls:'icon-cut',
				text:'ɾ��',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
			pageSize:20,  // ÿҳ��ʾ�ļ�¼����
			pageList:[20],   // ��������ÿҳ��¼�������б�
	        singleSelect:true,
			loadMsg: '���ڼ�����Ϣ...',
			pagination:true,
		    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQIFBList').datagrid('endEdit', editFlag);
	                editFlag="undefined";
	            }
	            else
	            {
		            $('#tDHCEQIFBList').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onSelect:function(index,row){ 
				if (SelectRowID!=row.IFBLRowID)
				{
					SelectRowID=row.IFBLRowID
				}
				else
				{
					SelectRowID=""
				}
			}
	});
	if (getElementValue("ReadOnly")==1||getElementValue("Status")==1||getElementValue("Status")==2)	//modified by csj 2020-03-03 ����ţ�1211902
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
		$("#tDHCEQIFBList").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
    var rows = $("#tDHCEQIFBList").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var IFBLModel = (typeof rows[lastIndex].IFBLModel == 'undefined') ? "" : rows[lastIndex].IFBLModel;
    var IFBLManuFactory = (typeof rows[lastIndex].IFBLManuFactory == 'undefined') ? "" : rows[lastIndex].IFBLManuFactory;
    if ((IFBLModel=="")&&(IFBLManuFactory==""))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	}
	else
	{
		$("#tDHCEQIFBList").datagrid('insertRow', {index:newIndex,row:{}});
		editFlag=0;
	}
}
// ����༭��
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQIFBList').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQIFBList').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		rows[i].IFBLSourceType=getElementValue("SourceType")
		rows[i].IFBLSourceID=getElementValue("SourceID")
		var oneRow=rows[i]
		if ((oneRow.IFBLModel=="")||(typeof(oneRow.IFBLModel)=="undefined"))
		{
			//modified by ZY0227 20200508
			messageShow("","","","��"+(i+1)+"��'�ͺ�'����Ϊ��!");//add by wl 2019-11-25 WL0014 
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
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","SaveData",dataList,"","");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID"); 
		var val="&SourceType="+SourceType+"&SourceID="+SourceID;
		url="dhceq.em.ifblistforloc.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth();
	}
	else
    {
		$.messager.popover({msg:"������Ϣ:"+jsonData,type:'error'});
		return
    }
}

//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteData()
{
	var rows = $('#tDHCEQIFBList').datagrid('getSelections'); //ѡ��Ҫɾ������
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","��ѡ��Ҫɾ������");
		return;
	}
	if(SelectRowID=="")
	{
		jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		return;
	}
	//��ʾ�Ƿ�ɾ��
	jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {
		if (res)
		{
			//modofied by zy ZY0206 begin
			if(typeof(SelectRowID)=="undefined")
			{
				if(editFlag>="0"){
					$("#tDHCEQIFBList").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
				}
				removeCheckBoxedRow("tDHCEQIFBList")
				return
			}
			else
			{
				var RowData={"IFBLRowID":SelectRowID}; //add by zx 2019-09-12
				RowData = JSON.stringify(RowData);
				var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","SaveDataList",RowData,"1");
				//jsonData=JSON.parse(jsonData)
				//if (jsonData.SQLCODE==0)
				if (jsonData==0)
				{
					var SourceType=getElementValue("SourceType");
					var SourceID=getElementValue("SourceID"); 
					var val="&SourceType="+SourceType+"&SourceID="+SourceID;
					url="dhceq.em.ifblistforloc.csp?"+val
				    window.location.href= url;
				    //modified by ZY0222 2020-04-16
				    websys_showModal("options").mth();
				}
				else
			    {
					$.messager.popover({msg:"������Ϣ:"+jsonData,type:'error'});
					return
			    }
			}
			//modofied by zy ZY0206 end
		}
	});
}
/*
var brandcomboboxeditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����
		url: url+'?action=GetBrand',
		filter: function(q,row){  //modify by JYP20160926
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q)>-1;
			},
		onSelect:function(option){
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TBrandDR'});
			jQuery(ed.target).val(option.id);  //����ID
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TBrand'});
			jQuery(ed.target).combobox('setValue', option.text);  //����Desc
		}
	}
}
var vendorcomboboxeditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����
		url: url+'?action=GetVendor',
		filter: function(q,row){  //modify by JYP20160926
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q)>-1;
			},
		onSelect:function(option){
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TVendorDR'});
			jQuery(ed.target).val(option.id);  //����ID
			var ed=$('#tDHCEQIFBList').datagrid('getEditor',{index:editFlag,field:'TVendor'});
			jQuery(ed.target).combobox('setValue', option.text);  //����Desc
		}
	}
}
*/
// add by zx 2019-09-12
// ������
function getVendor(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLVendorDR=data.TRowID;
	var iFBLVendorEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLVendor'});
	$(iFBLVendorEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}

// add by zx 2019-09-12
// ��������
function getManuFactory(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLManuFactoryDR=data.TRowID;
	var iFBLManuFactoryEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLManuFactory'});
	$(iFBLManuFactoryEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}

// add by zx 2019-09-12
// ����ͺ�
function getModel(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLModelDR=data.TRowID;
	var iFBLModelEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLModel'});
	$(iFBLModelEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}

// add by zx 2019-09-12
// Ʒ��
function getBrand(index,data)
{
	var rowData = $('#tDHCEQIFBList').datagrid('getSelected');
	rowData.IFBLBrandDR=data.TRowID;
	var iFBLBrandEdt = $('#tDHCEQIFBList').datagrid('getEditor', {index:editFlag,field:'IFBLBrand'});
	$(iFBLBrandEdt.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQIFBList').datagrid('endEdit',editFlag);
	$('#tDHCEQIFBList').datagrid('beginEdit',editFlag);
}