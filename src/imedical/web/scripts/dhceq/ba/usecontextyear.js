function initUseContextYear()
{
	$('#tDHCEQUseContextYear').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQUseContext",
			QueryName:"GetUseContext",
			Arg1:GlobalObj.EquipDR,
			Arg2:"1",
			ArgCnt:2
			},
    	border:'true',
		//rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddUseContextYearData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){SaveUseContextYearData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteUseContextYearData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TYear',title:'���',width:100,align:'center',editor:texteditor},
			{field:'TExpectedSatis',title:'Ԥ�������',width:100,align:'center',editor:texteditor},
			{field:'TActualSatis',title:'ʵ�������',width:100,align:'center',editor:texteditor},
			{field:'TPatientSatis',title:'���������',width:100,align:'center',editor:texteditor},
			{field:'TBenefitAnalysis',title:'����Ч�����',width:200,align:'center',editor:texteditor},
		]],
		//onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQUseContextYear').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQUseContextYear').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }

	});
}

function AddUseContextYearData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	//��ָ����������ݣ�appendRow�������һ���������
	$('#tDHCEQUseContextYear').datagrid('appendRow', 
	{
		TRowID: '',
		TYear:'',
		TExpectedSatis: '',
		TActualSatis:'',
		TPatientSatis:'',
		TBenefitAnalysis:''
	});
	editFlag=0;
}
function SaveUseContextYearData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUseContextYear').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^^"+GlobalObj.EquipDR+"^"+rows[i].TYear+"^^"+rows[i].TExpectedSatis+"^"+rows[i].TActualSatis+"^"+rows[i].TPatientSatis+"^^^^^^^^"+rows[i].TBenefitAnalysis+"^^^^^^^^^^^^^^^^";
		//            1          2           3                4           5               6                    7                            8            9101112131415         16          17181920212223242526272829303132                                           
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQUseContext',
			MethodName:'SaveUseContext',
			Arg1:CombineData,
			Arg2:1,
			ArgCnt:2
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
				$('#tDHCEQUseContextYear').datagrid('reload');
			}
			else if(data=="-1000")
			{
				$.messager.alert('����ʧ�ܣ�','�������:'+data+',���е�������', 'warning');
				}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}

//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteUseContextYearData()
{
	var rows = $('#tDHCEQUseContextYear').datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		if(rows[0].TRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQUseContext',
							MethodName:'DeleteUseContextMonth',
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
								$('#tDHCEQUseContextYear').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQUseContextYear').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQUseContextYear').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/*
function DeleteUseContextYearData()
{
	if(getJQValue($("#RowID"))==""){$.messager.alert('��ʾ','��ѡ��һ�����ݣ�','warning');return;}
	var RowID=getJQValue($("#RowID"))
	$.messager.confirm('ȷ��', '��ȷ��Ҫɾ����ѡ������', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
					ClassName:'web.DHCEQUseContext',
					MethodName:'DeleteUseContextMonth',
					Arg1:rows[0].TRowID,
					ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data==0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					$('#tDHCEQUseContextYear').datagrid('reload');
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}
*/