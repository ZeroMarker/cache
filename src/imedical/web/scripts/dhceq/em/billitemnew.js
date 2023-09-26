var editFlag="undefined";
var GlobalObj = {
	SourceType : "",
	SourceID : "",
	ReadOnly : "",
	CurRole : "",
	Status : "",
	toolbar : "",
	ElementID : "",
	TemplateID : "",
	IsFunction : "",
	GetData : function()
	{
		this.SourceType = getElementValue("#SourceType");
		this.SourceID = getElementValue("#SourceID");
		this.ReadOnly = getElementValue("#ReadOnly");
		this.CurRole = getElementValue("#CurRole");
		this.Status = getElementValue("#Status");
		this.ElementID = getElementValue("#ElementID");
		this.TemplateID = getElementValue("#TemplateID");
		this.IsFunction = getElementValue("#IsFunction");
		if (this.ReadOnly==0)
		{
			this.toolbar=[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddBillItemData();}
			},
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){SaveBillItemData();}
			},
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteBillItemData();}
			}
			]
			
		}
	}
}
jQuery(document).ready(function()
{
	initDocument();
})

function initDocument()
{
	GlobalObj.GetData();
	alertShow("aaa")
	initBillItem()
	if (GlobalObj.ReadOnly=="1")
	{
		jQuery('#BSvae').hide();
		jQuery('#BDelete').hide();
	}
	else
	{
		$('#BSvae').show();
		$('#BDelete').show();
	}
}

function initBillItem()
{
	$HUI.datagrid("#tDHCEQBillItem",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQBillItem",
	        	QueryName:"GetBillItem",
				InStockID:GlobalObj.SourceType,
				InStockID:GlobalObj.SourceID,
				InStockID:GlobalObj.IsFunction,
		},
		fit:true,
		border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		toolbar:GlobalObj.toolbar,
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
				{field:'TCode',title:'����',width:100,align:'center',editor:texteditor,hidden:true},
				{field:'TDesc',title:'������Ŀ����',width:100,align:'center',editor:texteditor},
				{field:'TSourceType',title:'��Դ����',width:100,align:'center',hidden:true},
				{field:'TSourceID',title:'��Դ',width:100,align:'center',hidden:true},
				{field:'TPrice',title:'�շѱ�׼',width:100,align:'center',editor:texteditor},
				{field:'TWorkLoadNum',title:'Ԥ�ƹ�����',width:100,align:'center',editor:texteditor},
				{field:'TTotalFee',title:'Ԥ������',width:100,align:'center'}

				
			]],
			pageSize:20,  // ÿҳ��ʾ�ļ�¼����
			pageList:[20],   // ��������ÿҳ��¼�������б�
	        singleSelect:true,
			loadMsg: '���ڼ�����Ϣ...',
			pagination:true,
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	                if((rowData.TPrice!="")&&(rowData.TWorkLoadNum!=""))
             		{
		             	var TotalFee=parseFloat(rowData.TPrice)*parseFloat(rowData.TWorkLoadNum) 
		             	alertShow(TotalFee)
		             	alertShow(TotalFee.toFixed(2))
		             	rowData.TTotalFee = TotalFee.toFixed(2)
	        			$('#tDHCEQBillItem').datagrid('refreshRow',editFlag)
	       			 }
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQBillItem').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }
	});
}
// ����༭��
function SaveBillItemData()
{
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQBillItem').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	var flag=0
	for(var i=0;i<rows.length;i++)
	{
		if ((rows[i].TDesc=="")||(rows[i].TPrice=="")||(rows[i].TWorkLoadNum==""))   flag=flag+1;
		var tmp=rows[i].TRowID+"^"+rows[i].TCode+"^"+rows[i].TDesc+"^"+GlobalObj.SourceType+"^"+GlobalObj.SourceID+"^"+rows[i].TPrice+"^"+rows[i].TCost+"^"+rows[i].TWorkLoadNum+"^^^"+GlobalObj.IsFunction;
		dataList.push(tmp);
	}
	if (flag>0)
	{
		jQuery.messager.alert("��ʾ","��"+flag+"��������Ŀ��Ϣ��д��ȫ��");
		return;
	}
	var CombineData=dataList.join("&");
	var AllInFee=0
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		async:false,
		data:{
			ClassName:'web.DHCEQBillItem',
			MethodName:'SaveBillItem',
			Arg1:CombineData,
			Arg2:GlobalObj.ElementID,
			Arg3:GlobalObj.TemplateID,
			Arg4:GlobalObj.SourceType,
			Arg5:GlobalObj.SourceID,
			ArgCnt:5
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			$.messager.progress('close');
			if(list[0]==0)
			{
				alertShow(list[1]);
				AllInFee=list[1]
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tDHCEQBillItem').datagrid('reload');
				
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
	opener.document.getElementById("24").value=AllInFee
	window.opener.AllOutFee()
}
// ��������
function AddBillItemData()
{
	var SourceType=$("#SourceType").val();
	var SourceID=$("#SourceID").val();
	if(editFlag>="0"){
		$('#tDHCEQBillItem').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	//��ָ����������ݣ�appendRow�������һ���������
	$('#tDHCEQBillItem').datagrid('appendRow', 
	{
		TRowID: '',
		TCode:'',
		TDesc: '',
		TPrice:'',
		TCost:'',
		TWorkLoadNum:''
	});
	editFlag=0;
}
//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteBillItemData()
{
	var rows = $('#tDHCEQBillItem').datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQBillItem',
							MethodName:'DeleteBillItem',
							Arg1:rows[0].TRowID,
							ArgCnt:1
						},
						beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alertShow(XMLHttpRequest.status);
							alertShow(XMLHttpRequest.readyState);
							alertShow(textStatus);
						},
						success:function(data,response,status)
						{
							$.messager.progress('close');
							data=data.replace(/\ +/g,"")	//ȥ���ո�
							data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
							if(data==0)
							{
								$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
								$('#tDHCEQBillItem').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQBillItem').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQBillItem').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
