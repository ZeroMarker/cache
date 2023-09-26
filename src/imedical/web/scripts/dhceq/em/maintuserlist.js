var editFlag="undefined";
var SelectRowID=""
var GlobalObj = {
	TypeValue : [{"value":"","text":""},{"value":"1","text":"��ʱ"},{"value":"2",text:"��ʽ"},{"value":"3","text":"ָ��"},{"value":"4","text":"����"}],
	SourceType : "",
	SourceID : "",
	Action : "",
	toolbar : "",
	UserIDs : "",
	GetData : function()
	{
		this.SourceType = getElementValue("SourceType");
		this.SourceID = getElementValue("SourceID");
		this.Action = getElementValue("Action");
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
				iconCls:'icon-remove',
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
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	defindTitleStyle();
	GlobalObj.GetData();
	initDHCEQMaintUserList();
}
function initDHCEQMaintUserList()
{
	$HUI.datagrid("#tDHCEQMaintUserList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQMaintUserList",
	        QueryName:"GetMaintUserList",
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
	    },
	    fit:true,
		singleSelect:true,
		toolbar:GlobalObj.toolbar,
		columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true,editor:texteditor},
				{field:'TSourceType',title:'',width:50,align:'center',hidden:true},
				{field:'TSourceID',title:'',width:50,align:'center',hidden:true},
				{field:'TUserID',title:'����ʦID',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TUser',title:'����ʦ',width:100,align:'center',editor:comboboxeditor},
				{field:'TWorkHour',title:'����ʱ��',width:100,align:'center',editor:texteditor},
				{field:'THold1',title:'THold1',width:100,align:'center',hidden:true,editor:texteditor},
				{field:'TTypeDesc',title:'Ա������',width:100,align:'center',editor:{
				type: 'combobox',
				options: {
					data: GlobalObj.TypeValue,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: true,
					onSelect:function(option){
						var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'THold1'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#tDHCEQMaintUserList").datagrid('getEditor',{index:editFlag,field:'TTypeDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
						}
					}
				}},
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
			},

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
		var tmp=rows[i].TRowID+"^"+GlobalObj.SourceType+"^"+GlobalObj.SourceID+"^"+rows[i].TUserID+"^"+rows[i].TWorkHour+"^"+rows[i].THold1+"^^^^";
		dataList.push(tmp);
	}
	var CombineData=dataList.join("&");
	alertShow(CombineData)
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
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
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
		required: true,
		url: 'dhceq.jquery.operationtype.csp?action=GetMaintUser',
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
