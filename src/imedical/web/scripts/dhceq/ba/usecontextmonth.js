function initUseContextMonth()
{
	$('#tDHCEQUseContextMonth').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:"web.DHCEQUseContext",
			QueryName:"GetUseContext",
			Arg1:GlobalObj.EquipDR,
			Arg2:"0",
			ArgCnt:2
			},
    	border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		toolbar:GlobalObj.UseContextMonth_toolbar,
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TYear',title:'���',width:60,align:'center'},
			{field:'TMonth',title:'�·�',width:60,align:'center'},
			{field:'TIncome',title:'����',width:80,align:'center',editor:texteditor},
			{field:'TPersonTime',title:'����˴�',width:80,align:'center',editor:texteditor},
			{field:'TActualWorkLoad',title:'ʵ�ʹ�����',width:80,align:'center',editor:texteditor},
			{field:'TPositiveCases',title:'��������',width:80,align:'center',editor:texteditor},
			{field:'TRunTime',title:'����ʱ��',width:80,align:'center',editor:texteditor},
			{field:'TFailureTimes',title:'���ϴ���',width:80,align:'center',editor:texteditor},
			{field:'TMaintTimes',title:'ά�޴���',width:80,align:'center',editor:texteditor},
			{field:'TPMTimes',title:'��������',width:80,align:'center',editor:texteditor},
			{field:'TDetectionTimes',title:'������',width:80,align:'center',editor:texteditor},
			{field:'TWaitingTimes',title:'ԤԼ�ȴ�ʱ��',width:80,align:'center',editor:texteditor},
			{field:'TAverageWorkHour',title:'ƽ������Сʱ/��',width:80,align:'center',editor:texteditor},
			{field:'TActualWorkDays',title:'ʵ�ʹ�������',width:80,align:'center',editor:texteditor},
			{field:'TFailureDays',title:'��������',width:80,align:'center',editor:texteditor},
			{field:'TUseEvaluation',title:'ʹ������',width:80,align:'center',editor:texteditor},
		]],
		//onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		loadMsg: '���ڼ�����Ϣ...',
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQUseContextMonth').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQUseContextMonth').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        }

	});
}
function AddUseContextMonthData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	//��ָ����������ݣ�appendRow�������һ���������
	$('#tDHCEQUseContextMonth').datagrid('appendRow', 
	{	TRowID: '',
		TYear:'',
		TMonth: '',
		TIncome:'',
		TPersonTime:'',
		TActualWorkLoad:'',
		TPositiveCases:'',
		TRunTime:'',
		TFailureTimes:'',
		TMaintTimes:'',
		TPMTimes:'',
		TDetectionTimes:'',
		TWaitingTimes:'',
		TAverageWorkHour:'',
		TActualWorkDays:'',
		TFailureDays:"",
		TUseEvaluation:""
	});
	editFlag=0;
}
function SaveUseContextMonthData()
{
	if(editFlag>="0"){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUseContextMonth').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^^"+GlobalObj.EquipDR+"^"+rows[i].TYear+"^"+rows[i].TMonth+"^^^^^^^^^^^^"+rows[i].TUseEvaluation+"^^^"+rows[i].TIncome+"^"+rows[i].TPersonTime+"^"+rows[i].TActualWorkLoad+"^"+rows[i].TPositiveCases+"^"+rows[i].TRunTime+"^"+rows[i].TFailureTimes+"^"+rows[i].TMaintTimes+"^"+rows[i].TPMTimes+"^"+rows[i].TDetectionTimes+"^"+rows[i].TWaitingTimes+"^"+rows[i].TAverageWorkHour+"^"+rows[i].TActualWorkDays+"^"+rows[i].TFailureDays;
		//            1          2           3                4                    5         678910111213141516  17                1819           20                  21                      22                          23                        24                   25                        26                     27                    28                         29                         30                           31                          32                                           
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
			Arg2:0,
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
				$('#tDHCEQUseContextMonth').datagrid('reload');
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
function DeleteUseContextMonthData()
{
	var rows = $('#tDHCEQUseContextMonth').datagrid('getSelections'); //ѡ��Ҫɾ������
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
								$('#tDHCEQUseContextMonth').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQUseContextMonth').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQUseContextMonth').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
