var editFlag="undefined";
var url="dhceq.jquery.operationtype.csp";
var SelectRowID=""
var GlobalObj = {
	SourceType : "",
	SourceID : "",
	Action : "",
	toolbar : "",
	UserIDs : "",
	GetData : function()
	{
		this.SourceType = getJQValue(jQuery("#SourceType"));
		this.SourceID = getJQValue(jQuery("#SourceID"));
		this.Action = getJQValue(jQuery("#Action"));
		if ((this.Action=="WX_Maint")||(this.Action=="WX_Finish"))
		{
			this.toolbar=[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddData();}
			},
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){SaveData();}
			},
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteData();}
			}
			]
			
		}
	},
	SetUserIDs : function(UserID)
	{
		if (this.UserIDs=="")
		{
			this.UserIDs=UserID;
		}
		else
		{
			this.UserIDs=this.UserIDs+","+UserID;
		}
	},
	CheckUserIDs : function(UserID)
	{
		if (this.UserIDs == "") return -1;
		var tempStr =","+this.UserIDs+"," ; 
    	return tempStr.indexOf(","+UserID+","); //���ش��ڵ���0������ֵ����������"Text"�򷵻�"-1��
	}
}
jQuery(document).ready(function()
{
	initDocument();
})

function initDocument()
{
	GlobalObj.GetData();
	initTable()
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

function initTable()
{
	$('#tDHCEQMaintUserList').datagrid({
	    url:'dhceq.jquery.csp',
	    queryParams:{
			ClassName:"web.DHCEQMaintUserList",
			QueryName:"GetMaintUserList",
			Arg1:GlobalObj.SourceType,
			Arg2:GlobalObj.SourceID,
			ArgCnt:2
	    },
		fit:true,
		border:'true',
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		toolbar:GlobalObj.toolbar,
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true,editor:texteditor},
				{field:'TSourceType',title:'',width:50,align:'center',hidden:true},
				{field:'TSourceID',title:'',width:50,align:'center',hidden:true},
				{field:'TUserID',title:'����ʦID',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TUser',title:'����ʦ',width:100,align:'center',editor:comboboxeditor},
				{field:'TWorkHour',title:'����ʱ��',width:100,align:'center',editor:texteditor},
				{field:'THold1',title:'',width:60,align:'center',hidden:true},
				{field:'THold2',title:'',width:60,align:'center',hidden:true},
				{field:'THold3',title:'',width:60,align:'center',hidden:true},
				{field:'THold4',title:'',width:60,align:'center',hidden:true},
				{field:'THold5',title:'',width:60,align:'center',hidden:true},
				
			]],
			loadMsg: '���ڼ�����Ϣ...',
		    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQMaintUserList').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQMaintUserList').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onLoadSuccess:function(data){
				var rows = $("#tDHCEQMaintUserList").datagrid("getRows"); //��δ����ǻ�ȡ��ǰҳ�������С�
				for(var i=0;i<rows.length;i++)
				{
					//������ObjCertInfo��ֵ
					GlobalObj.SetUserIDs(rows[i].TUserID);			
				}
			},
			onSelect:function(index,row){ 
				if (SelectRowID!=row.TRowID)
				{
					SelectRowID=row.TRowID
				}
				else
				{
					SelectRowID=""
				}
			}
	});
}
// ����༭��
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQMaintUserList').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQMaintUserList').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		var tmp=rows[i].TRowID+"^"+GlobalObj.SourceType+"^"+GlobalObj.SourceID+"^"+rows[i].TUserID+"^"+rows[i].TWorkHour+"^^^^^";
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	messageShow("","","",CombineData)
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQMaintUserList',
			MethodName:'SaveData',
			Arg1:CombineData,
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			$.messager.progress('close');
			if(data==0)
			{
				$.messager.show({title: '��ʾ',msg: '����ɹ�'});
				$('#tDHCEQMaintUserList').datagrid('reload');
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}
// ��������
function AddData()
{
	var SourceType=GlobalObj.SourceType;
	var SourceID=GlobalObj.SourceID;
	if(editFlag>="0"){
		$('#tDHCEQMaintUserList').datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	//��ָ����������ݣ�appendRow�������һ���������
	$('#tDHCEQMaintUserList').datagrid('appendRow', 
	{
		TRowID: '',
		TUserID:'',
		TUser:'',
		TWorkHour:''
	});
	editFlag=0;
}
//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
function DeleteData()
{
	var rows = $('#tDHCEQMaintUserList').datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		if(SelectRowID!=""){//Add by JYP 20160901
			jQuery.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
				if (res) {
					$.ajax({
						url:'dhceq.jquery.method.csp',
						Type:'POST',
						data:{
							ClassName:'web.DHCEQMaintUserList',
							MethodName:'DeleteData',
							Arg1:SelectRowID,
							ArgCnt:1
						},
						beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
						error:function(XMLHttpRequest,textStatus,errorThrown){
							messageShow("","","",XMLHttpRequest.status);
							messageShow("","","",XMLHttpRequest.readyState);
							messageShow("","","",textStatus);
						},
						success:function(data,response,status)
						{
							$.messager.progress('close');
							data=data.replace(/\ +/g,"")	//ȥ���ո�
							data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
							if(data==0)
							{
								$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
								$('#tDHCEQMaintUserList').datagrid('reload');
							}
							else
								$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
							}	
						});
				
						}
			});
		//Add by JYP 20160901
		}else{  
			var index = $('#tDHCEQMaintUserList').datagrid('getRowIndex',rows[0]);
			$('#tDHCEQMaintUserList').datagrid('deleteRow',index);
        }
        //End by JYP 20160901
	}else{
		 jQuery.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

///����combobox�༭
var comboboxeditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		valueField: "id", 
		textField: "text",
		panelHeight:"auto",  //���������߶��Զ�����
		url: url+'?action=GetMaintUser',
		onSelect:function(option){
			var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'TUserID'});
			if (GlobalObj.CheckUserIDs(option.id)>=0)
			{
				jQuery.messager.alert("��ʾ","����ʦ��Ա�����ظ�!");
			}else
			{
				jQuery(ed.target).val(option.id);  //����ID
				var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'TUser'});
				jQuery(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
			}
		}
	}
}