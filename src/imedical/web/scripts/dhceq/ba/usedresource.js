var columns=new Array();
function initUsedResource()
{
	initUsedResourceDataGrid();
	$('#tDHCEQUsedResource').datagrid({
	    url:'dhceq.jquery.csp',
	    queryParams:{
			ClassName:"web.DHCEQUsedResource",
			QueryName:"GetUsedResourceFee",
			Arg1:"1",
			Arg2:GlobalObj.EquipDR,
			ArgCnt:2
	    },
		fit:true,
		border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddUsedResourceData();}
			}/*
			,'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteUsedResourceData();}
			}*/
		],
		columns:[
				columns
			],
			pageSize:20,  // ÿҳ��ʾ�ļ�¼����
			pageList:[20],   // ��������ÿҳ��¼�������б�
	        singleSelect:true,
			loadMsg: '���ڼ�����Ϣ...',
			pagination:true,
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	        	var url='dhceq.process.usedresourcedetail.csp?Year='+rowData.TYear+'&Month='+rowData.TMonth+'&EquipDR='+GlobalObj.EquipDR;
				OpenNewWindow(url);
	        },
	         onLoadSuccess: function (data) {//˫��ѡ���б༭
	         for(i=0;i<data.total;i++)
	         {
		     $('#tDHCEQUsedResource').datagrid('beginEdit',i);
	         listinfo=data.rows[i].TTypeFee.split('&');
	         for(j=0;j<listinfo.length;j++)
	         {
		         list=listinfo[j].split('^');
		     	 var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:i,field:'Type'+list[0]});
			 	 jQuery(ed.target).val(list[1]);  //����ID
	         }
			 $('#tDHCEQUsedResource').datagrid('endEdit', i);
	         }
	        }
	});
}
function initUsedResourceDataGrid()
{
	var column={};
	column["title"]='���';
    column["field"]='TYear';
    column["align"]='center';
    column["width"]=50;	
    columns.push(column);
    var column={};
    column["title"]='�·�';
    column["field"]='TMonth';
    column["align"]='center';
    column["width"]=50;	
    columns.push(column);
    $.ajax({
	    async: false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQCResourceType',
			MethodName:'GetAllResourceType',
			ArgCnt:0
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var listInfo=data.split('&')
			for(i=0;i<listInfo.length;i++)
			{
				var column={};
				list=listInfo[i].split('^')
				column["title"]=list[2];
                column["field"]='Type'+list[0];
                column["align"]='center';
                column["width"]=80;	
                column["editor"]=texteditor;
                columns.push(column);
			}
		}
	});
	 var column={};
    column["title"]='TTypeFee';
    column["field"]='TTypeFee';
    column["align"]='center';
    column["width"]=50;	
    //column["formatter"]=SetTTypeFee;	
    column["hidden"]='ture';
    columns.push(column);
}
// ����༭��
function SaveUsedResourceData()
{
	if(editFlag>="0"){
		$('#tDHCEQUsedResource').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUsedResource').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+rows[i].Year+"^"+rows[i].Month+"^2^"+GlobalObj.EquipDR+"^"+rows[i].TTypeRowID+"^"+rows[i].TAmount;
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQUsedResource',
			MethodName:'SaveAllUsedResource',
			Arg1:CombineData,
			ArgCnt:1
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
			if(data==0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tDHCEQUsedResource').datagrid('reload');
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}
// ��������
function AddUsedResourceData()
{
	var url='dhceq.process.usedresourcedetail.csp?Year=&Month=&EquipDR='+GlobalObj.EquipDR;
	OpenNewWindow(url);
}
function SetTTypeFee(value,row,index)
{
	list=value.split('&')
	 $('#tDHCEQUsedResource').datagrid('beginEdit', index);
	for(i=0;i<list.length;i++)
	{
		listinfo=list[i].split('^');
		var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:row,field:'Type'+listinfo[0]});
		jQuery(ed.target).val(listinfo[1]);  //����ID
	}
	$('#tDHCEQUsedResource').datagrid('endEdit', editFlag);
	var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:editFlag,field:'TDevelopStatus'});
	return value;
}
//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteUsedResourceData()
{
	var rows = $('#tDHCEQUsedResource').datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQPC.DHCEQPCCCertInfo',
							MethodName:'DelCertInfo',
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
								$('#tDHCEQUsedResource').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQUsedResource').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQUsedResource').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
