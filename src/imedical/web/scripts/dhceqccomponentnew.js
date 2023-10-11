var editFlag="undefined";
var GlobalObj = {
	DisplayTypeValue : [{"value":"","text":""},{"value":"0","text":"text"},{"value":"1","text":"link"},{"value":"2","text":"button"},{"value":"3","text":"checkbox"},{"value":"4","text":"combobox"},{"value":"5","text":"combogrid"}],	//json��ʽ,
	ComponentID : $("#ComponentID").val()
	/*
	ClearData : function(vElementID)
	{
		if (vElementID=="AssetType") {this.AssetTypeDR = "";}
	},
	ClearAll : function()
	{
		this.AssetTypeDR = "";
	},
	GetData: function()
	{
		this.ComponentID=$("#ComponentID").val()
	}
	*/
}
$(document).ready(function()
{
	initDocument();
	$('#DHCEQCComponent').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQCComponent",
			QueryName:"GetComponentItem",
			Arg1:GlobalObj.ComponentID,
			ArgCnt:1
			},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		toolbar:[
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){saveAllData();}
			},'-----------------------------------',
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){insertRow();}
			},'-----------------------------------',
			/*
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){deleteAllData();}
			}*/
		],
		columns:[[
			{field:'action',title:'����',width:50,align:'center',formatter:actionPanel},
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TName',title:'����',width:100,align:'center',editor:texteditor},
			{field:'TCaption',title:'����',width:100,align:'center',editor:texteditor},
			{field:'TCaptionStyle',title:'������ʽ',width:150,align:'center',hidden:true},
			{field:'TStyle',title:'��ʽ',width:150,align:'center',editor:texteditor},
			{field:'THidden',title:'����',width:50,align:'center',formatter:function(value,row,index){return checkBox(value,"checkboxHiddenChange","THidden",index)}},
			{field:'TDisplayType',title:'TDisplayType',width:50,align:'center',hidden:true,editor:texteditor},
			{field:'TDisplayTypeDesc',title:'Ԫ������',width:80,align:'center',editor:{
				type: 'combobox',
				options: {
					data: GlobalObj.DisplayTypeValue,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: true,
					onSelect:function(option){
						var ed=jQuery("#DHCEQCComponent").datagrid('getEditor',{index:editFlag,field:'TDisplayType'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#DHCEQCComponent").datagrid('getEditor',{index:editFlag,field:'TDisplayTypeDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
						}
					}
				}
			},
			{field:'TImage',title:'ͼ��',width:80,align:'center',editor:texteditor},
			{field:'TLinkUrl',title:'����URL',width:150,align:'center',editor:texteditor},
			{field:'TLinkExpression',title:'���ӱ��ʽ',width:150,align:'center',editor:texteditor},
			{field:'TShowInNewWindow',title:'�´���',width:50,align:'center',editor:texteditor},
			{field:'TLookupJavascriptFunction',title:'JSFunction',width:150,align:'center',editor:texteditor},
		]],
	    onSelect: function (rowIndex, rowData) {//������ȡ���༭
	    	if (editFlag!="undefined") 
	    	{
                jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag); 
            }
        },
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    	if (editFlag!="undefined")
	    	{
                jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag); 
            }
            jQuery("#DHCEQCComponent").datagrid('beginEdit', rowIndex);
            editFlag =rowIndex;
        },
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});
});
function initDocument()
{
	//GlobalObj.GetData();
	FillData();
}

function FillData()
{
	if (GlobalObj.ComponentID=="") return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		type:'POST',
		data:{
			ClassName:'web.DHCEQCComponent',
			MethodName:'GetOneComponent',
			Arg1:GlobalObj.ComponentID,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			setJQValue($('#Name'),list[0])
			setJQValue($('#Caption'),list[1])
			setJQValue($('#CaptionStyle'),list[2])
			setJQValue($('#ClassName'),list[3])
			setJQValue($('#QueryName'),list[4])
			setJQValue($('#Template'),list[5])
			setJQValue($('#Specification'),list[6])
			setJQValue($('#Remark'),list[7])
			setJQValue($('#Hold1'),list[12])
			setJQValue($('#Hold2'),list[13])
			setJQValue($('#Hold3'),list[14])
			setJQValue($('#Hold4'),list[15])
			setJQValue($('#Hold5'),list[16])
		}
	});
}

function CombineData()
{
	var val="";
	val=GlobalObj.ComponentID;
	val+="^"+getJQValue($("#Name"));
	val+="^"+getJQValue($("#Caption"));
	val+="^"+getJQValue($("#CaptionStyle"));
	val+="^"+getJQValue($("#ClassName"));
	val+="^"+getJQValue($("#QueryName"));
	val+="^"+getJQValue($("#Template"));
	val+="^"+getJQValue($("#Specification"));
	val+="^"+getJQValue($("#Remark"));
	val+="^"+getJQValue($("#Hold1"));
	val+="^"+getJQValue($("#Hold2"));
	val+="^"+getJQValue($("#Hold3"));
	val+="^"+getJQValue($("#Hold4"));
	val+="^"+getJQValue($("#Hold5"));
	return val;
}
function ListData()
{
	var ListData=""
	if(editFlag>="0"){
		jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag);
	}
	/*
	var rows = jQuery("#DHCEQCComponent").datagrid('getRows');
	if(rows.length<=0){
		return ListData;
	}
	*/
	var rows = jQuery("#DHCEQCComponent").datagrid('getChanges');
	if(rows.length<=0) return ListData;
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].TName=="") return -1;
		var tmp=""
		tmp=rows[i].TRowID
		tmp=tmp+"^"+rows[i].TName
		tmp=tmp+"^"+rows[i].TCaption
		tmp=tmp+"^"+rows[i].TCaptionStyle
		tmp=tmp+"^"	//+rows[i].TClassMethod
		tmp=tmp+"^"	//+rows[i].TClassMethodIfDirty
		tmp=tmp+"^"	//+rows[i].TCustomExpression
		tmp=tmp+"^"	//+rows[i].TDataType
		tmp=tmp+"^"	//+rows[i].TDefaultValueAlways
		tmp=tmp+"^"	//+rows[i].TDefaultValueExpression
		tmp=tmp+"^"	//+rows[i].TDescription
		tmp=tmp+"^"	//+rows[i].TDisabled
		tmp=tmp+"^"	//+rows[i].TDisplayOnly
		tmp=tmp+"^"+rows[i].TDisplayType
		tmp=tmp+"^"	//+rows[i].THelpUrl
		tmp=tmp+"^"+rows[i].THidden
		tmp=tmp+"^"+rows[i].TImage
		tmp=tmp+"^"	//+rows[i].TLinkComponent
		tmp=tmp+"^"	//+rows[i].TLinkConditionalExp
		tmp=tmp+"^"+rows[i].TLinkExpression
		tmp=tmp+"^"+rows[i].TLinkUrl
		tmp=tmp+"^"	//+rows[i].TLinkWorkFlow
		tmp=tmp+"^"	//+rows[i].TListCellStyle
		tmp=tmp+"^"	//+rows[i].TLookupBrokerMethod
		tmp=tmp+"^"	//+rows[i].TLookupClassName
		tmp=tmp+"^"	//+rows[i].TLookupCustomComponent
		tmp=tmp+"^"+rows[i].TLookupJavascriptFunction
		tmp=tmp+"^"	//+rows[i].TLookupProperties
		tmp=tmp+"^"	//+rows[i].TLookupQueryName
		tmp=tmp+"^"	//+rows[i].TLookupUserDefined
		tmp=tmp+"^"	//+rows[i].TLookupUserDefinedValues
		tmp=tmp+"^"	//+rows[i].TNestedComponent
		tmp=tmp+"^"	//+rows[i].TNestedCondExpr
		tmp=tmp+"^"	//+rows[i].TOrderMode
		tmp=tmp+"^"	//+rows[i].TPassword
		tmp=tmp+"^"	//+rows[i].TReadOnly
		tmp=tmp+"^"	//+rows[i].TReferencedObject
		tmp=tmp+"^"	//+rows[i].TRequired
		tmp=tmp+"^"	//+rows[i].TShortcutKey
		tmp=tmp+"^"+rows[i].TShowInNewWindow
		tmp=tmp+"^"+rows[i].TStyle
		tmp=tmp+"^"	//+rows[i].TTabSequence
		tmp=tmp+"^"	//+rows[i].TTooltip
		tmp=tmp+"^"	//+rows[i].TValueGet
		tmp=tmp+"^"	//+rows[i].TValueSet
		dataList.push(tmp);
	}
	var ListData=dataList.join("#");
	return ListData
}


function saveAllData()
{
	if (getJQValue($("#Name"))=="")
	{
		$.messager.alert('����ʧ�ܣ�','������Ʋ���Ϊ��', 'warning')
		return;
	}
	var Val=CombineData()
	var ValList=ListData()
	if (ValList=="-1")
	{
		$.messager.alert('����ʧ�ܣ�','��ϸ���Ʋ���Ϊ��', 'warning')
		return;
	}
	$.ajax({
	    async: false,
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQCComponent',
			MethodName:'SaveData',
			Arg1:Val,
			Arg2:ValList,
			Arg3:'0',
			ArgCnt:3
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			$.messager.progress('close');
			if(data>0)
			{
				$.messager.show({title: '��ʾ',msg: '���³ɹ�'});
				var url="dhceq.code.component.csp?&ComponentID="+data;
				if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
					url += "&MWToken="+websys_getMWToken()
				}
				window.location.href=url;
			}
			else
				$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
		}
	});
}

// ��������
function insertRow()
{
	if(editFlag>="0"){
		jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	jQuery("#DHCEQCComponent").datagrid('appendRow', {//��ָ����������ݣ�appendRow�������һ���������
	TRowID: '',TName:'',TCaption: '',TCaptionStyle:'',TStyle:'',THidden: ''}
	);
	//jQuery("#DHCEQCComponent").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editFlag=0;
}
function actionPanel(value,row,index)
{
	return '<a href="#" onclick="deleteRow('+index+')">ɾ��</a>'
}
function deleteRow(index){
    $.messager.confirm('ȷ��','ȷ��ɾ��?',function(r){
        if (r){
            
			var row = jQuery('#DHCEQCComponent').datagrid('getRows')[index];
			if (row.TRowID=="")
			{
				$('#DHCEQCComponent').datagrid('deleteRow', index);
			}
			else if (row.TRowID>0)
			{
				$.ajax({
					url:'dhceq.jquery.method.csp',
					type:'POST',
					data:{
						ClassName:'web.DHCEQCComponent',
						MethodName:'DeleteItemData',
						Arg1:row.TRowID,
						ArgCnt:1
					},
					success:function(data,response,status)
					{
						$.messager.progress('close');
						if(data==0)
						{
							$('#DHCEQCComponent').datagrid('deleteRow', index);
						}
						else if(data<0)
						{
							$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
						}
						else if(data>0)
						{
							$.messager.alert('ɾ��ʧ�ܣ�','��'+data+'���ط��õ���Ԫ��,����ɾ��.', 'warning');
						}
							
					}
				});
			}
        }
    });
}

function deleteAllData()
{
	if(GlobalObj.ComponentID==""){$.messager.alert('��ʾ','��ǰ���������','warning');return;}
	$.messager.confirm('ȷ��', '��ȷ��Ҫɾ����ѡ������', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
				ClassName:'web.DHCEQCComponent',
				MethodName:'DeleteData',
				Arg1:GlobalObj.ComponentID,
				ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data>=0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					$('#DHCEQCComponent').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			}
		});
        }
	});
}

function checkboxHiddenChange(THidden,rowIndex)
{
	var row = jQuery('#DHCEQCComponent').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (THidden==key)
			{
				if (((val=="N")||val=="")) row.THidden="Y"
				else row.THidden="N"
			}
		})
	}
}