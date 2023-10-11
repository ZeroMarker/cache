$(function(){
	$("#Active").checkbox("setValue", true);
	//////////////////--1
	/*var Loc = $HUI.combobox("#Loc",{	///����
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
		     {id:'210',text:'ICU����'}
		     ,{id:'234',text:'ICU����'}
		     ,{id:'60',text:'SCBU'}
			,{id:'61',text:'NICU'}
			,{id:'236',text:'CCU'}
			,{id:'558',text:'PICU'}	
		]
	})*/
	var Loc = $HUI.combobox("#Loc",{	///����
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindICULoc&ResultSetType=array",
		valueField:'ctlocId',
		textField:'ctlocDesc',
        //panelHeight:'auto',
        panelHeight:400,
        editable:true,
		onBeforeLoad:function(param){
			//param.desc=param.q,
            //param.locListCodeStr="",
            //param.EpisodeID=""
		}
	})
	$("#CategoryIn").combobox({	///����
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        panelHeight:400,
        editable:true,
        onBeforeLoad:function(param){}
	})
	//////////////////--1
	//////////////////--2
	$("#Category").combobox({	///��������
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        editable:true,
        onBeforeLoad:function(param){}
	})
	$("#DefaultPos").combobox({	///Ĭ�ϲ�λ
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterPosition&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        editable:true,
        onBeforeLoad:function(param){}
	})
	$("#ICURecordItem").combobox({	///����ҽ��
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindRecordItem&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        editable:true,
        onBeforeLoad:function(param){
	       param.RDesc=param.q 
	    }
	})
	//////////////////--2
	var catheterDatagrid=$("#catheter_datagrid").datagrid({	///�б�����
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        title:"���ܻ�������ά��",
        pageSize: 20,
        pageList: [20, 50, 100],
		border:false,			 
        url:$URL,
        queryParams:{
            ClassName:"Clinic.ICU.Catheter",
            QueryName:"FindCatheter"
        },
        onBeforeLoad:function(param){
            param.locId=$("#Loc").combobox('getValue');
	    	param.CatId=$("#CategoryIn").combobox('getValue');
            param.CatherDesc=$("#CatherDesc").val();
            param.status=$("#Active").checkbox('getValue')?"Y":"N";
            
	    },
        columns:[[
        	{ field: "RowId", title: "ID", width: 60, sortable: true },
        	{ field: "Code", title: "����", width: 200, sortable: true },
        	{ field: "Description", title: "����", width: 250, sortable: true },
        	{ field: "CategoryID", title: "����ID", width: 250, sortable: true ,hidden:true},
        	{ field: "CategoryDesc", title: "����", width: 120, sortable: true },
        	{ field: "DefaultPosID", title: "Ĭ���ù�λ��ID", width: 120, sortable: true ,hidden:true},
        	{ field: "DefaultPosDesc", title: "Ĭ���ù�λ��", width: 120, sortable: true },
        	{ field: "RecordItemID", title: "ҽ��ID", width: 80, sortable: true },
        	{ field: "LinkRecordItem", title: "ҽ��", width: 200, sortable: true },
        	{ field: "LinkRecordItemCatID", title: "����ID", width: 80, sortable: true },
        	{ field: "LinkRecordItemCat", title: "����", width: 150, sortable: true },
        	{ field: "Status", title: "״̬", width: 80, sortable: true }
        	
       	]],
		onClickRow:function(){
            var row=$("#catheter_datagrid").datagrid('getSelected');
			$("#CatherDesc").val(row.Description);
		},
       	toolbar:[
            {
                iconCls:'icon-add',
                text:'����',
                handler:function(){
                    saveGroupCaptionHandler("")
                }
            },
            {
                iconCls:'icon-write-order',
                text:'�޸�',
                handler:function(){
                    var selectRow=$("#catheter_datagrid").datagrid('getSelected');
                    if(selectRow)
                    {
	                    saveGroupCaptionHandler(selectRow)
	                }else{
		             	$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ��У�','warning')
		            }
                }
            },
            {
                iconCls:'icon-cancel',
                text:'ɾ��',
                handler:function(){
                    var selectRow=$("#catheter_datagrid").datagrid('getSelected');
                    if(selectRow)
                    {
	                    $.messager.confirm("ȷ��","ȷ��ɾ������"+selectRow.CategoryDesc+"���еġ�"+selectRow.Description+"��",function(r)
	                    {
		                    if(r)
		                    {
			                    var result=$.m({
				                	ClassName:"Clinic.ICU.Catheter",
				                	MethodName:"RemoveCatheter",
				                	rowId:selectRow.RowId
				                },false);
				                if(result=='0')
				                {
					             
									$.messager.alert('��ʾ','��Ϣɾ���ɹ�','info');
		 							$("#Loc").combobox('setValue',"");
		 							$("#CategoryIn").combobox('setValue',"");
		 							$("#CatherDesc").val("");
		 							$("#catheter_datagrid").datagrid('reload');
					            }else{
						            $.messager.alert('����','��Ϣɾ��ʧ�ܣ�','warning');
						            return;
						        }
			                }
		                });
	                }
	                else{
		                $.messager.alert('����','��ѡ��һ�����ݣ�','warning');
						return;
	                }
                }
            }
        ]
	});
	$("#btnSearch").click(function(){
		$("#catheter_datagrid").datagrid('reload');
	})
	$HUI.linkbutton("#btnRefresh",{
		onClick: function(){
			//$("#catheter_datagrid").datagrid('reload');
			$("#Loc").combobox('setValue',"");
			$("#Loc").combobox('setText',"");
			$("#CategoryIn").combobox('setValue',"");
			$("#CategoryIn").combobox('setText',"");
			$("#CatherDesc").val("");
			$("#Active").checkbox("setValue", true);
        }
	})
	$HUI.linkbutton("#btnActive",{
		onClick: function(){
			var selectRow=$("#catheter_datagrid").datagrid('getSelected');
            if(selectRow)
            {
	            if(selectRow.Status!="Disable")
	            {
		            $.messager.alert('����','������Ϣ���Ǽ���״̬������Ҫ�ٽ��м��','warning');
		            return;
	            }
	            $.messager.confirm("ȷ��","ȷ�ϼ����"+selectRow.CategoryDesc+"���еġ�"+selectRow.Description+"��",function(r)
                {
                    if(r)
                    {
	                    var result=$.m({
		                	ClassName:"Clinic.ICU.Catheter",
		                	MethodName:"ActiveCatheter",
		                	rowId:selectRow.RowId
		                },false);
		                if(result=='0')
		                {
							$.messager.alert('��ʾ','��Ϣ����ɹ�','info');
 							$("#Loc").combobox('setValue',"");
 							$("#CategoryIn").combobox('setValue',"");
 							$("#CatherDesc").val("");
 							$("#catheter_datagrid").datagrid('reload');
			            }else{
				            $.messager.alert('����','��Ϣ����ʧ�ܣ�','warning');
				            return;
				        }
	                }
                });
            }
            else{
                $.messager.alert('����','��ѡ��һ�����ݣ�','warning');
				return;
            }
        }
	})
	
})

function saveGroupCaptionHandler(selectRow){
	var titleName="����������Ϣ";
	if(selectRow)
	{
		titleName="�޸ĵ�����Ϣ";
		//alert("selectRow.RowId="+selectRow.RowId);
		$("#dlgRowId").val(selectRow.RowId);
		$("#Code").val(selectRow.Code);
		$("#Description").val(selectRow.Description);
		$("#Category").combobox('setValue',selectRow.CategoryID);
		$("#Category").combobox('setText',selectRow.CategoryDesc);
		$("#DefaultPos").combobox('setValue',selectRow.DefaultPosID);
		$("#DefaultPos").combobox('setText',selectRow.DefaultPosDesc);
		$("#ICURecordItem").combobox('setValue',selectRow.RecordItemID);
		$("#ICURecordItem").combobox('setText',selectRow.LinkRecordItem);
		
	}					
	$("#CaptionDialog").show();
	$("#CaptionDialog").dialog({
        iconCls:'icon-w-save',
        title:titleName,
        resizable:true,
        modal:true,
        buttons:[
            {
				text:'����',
				handler:function(){
                    saveCatheterData();
                }
            },
            {
				text:'�ر�',
				handler:function(){
					
                    $("#CaptionDialog").dialog('close');
                }
            }
        ],
        onBeforeClose:function(){
	       	$("#conditionForm").form('clear');
	    },
	    onBeforeOpen:function(){
			$('#Category').combobox("reload");
			$('#DefaultPos').combobox("reload");
			$('#ICURecordItem').combobox("reload");
		}
    })
    $('#CaptionDialog').window('center')
}

function saveCatheterData(){
	var winRowId=$("#dlgRowId").val();
	var Code=$("#Code").val();
	var Description=$("#Description").val();
	
	var Category=$("#Category").combobox('getValue');
	var DefaultPos=$("#DefaultPos").combobox('getValue');
	var ICURecordItem=$("#ICURecordItem").combobox('getValue');
	
	if(Code=="")
	{
		$.messager.alert('��ʾ','���벻��Ϊ�գ�','warning');
		return;
	}
	if(Description=="")
	{
		$.messager.alert('��ʾ','��������Ϊ�գ�','warning');
		return;
	}
	if(Category=="")
	{
		$.messager.alert('��ʾ','���಻��Ϊ�գ�','warning');
		return;
	}
	var result=0;
	result=$.m({
		ClassName:"Clinic.ICU.Catheter",
		MethodName:"SaveCatheter",
		rowId:winRowId,
		code:Code, 
		description:Description,
		category:Category,
		defaultPos:DefaultPos,
		recordItem:ICURecordItem
		
	},false);
	if(result>0)
	{
		$.messager.alert('�ɹ�',"�ɹ�:"+result,'warning');
		$("#CaptionDialog").dialog('close');
		$("#catheter_datagrid").datagrid('reload');
		return ;
	}
}
//���ҵ�ǰֵ���������index
function findIndexDatas(datas,code,value)
{
	var index=-1;
	for(var i=0;i<datas.length;i++)
	{
		for(var key in datas[i])
		{
			if(key==code)
			{
				if(datas[i][key]==value)
				{
					index=i;
					break;
				}
			}
		}
		if(index!=-1) break;
	}
	return index;
}
//ɾ�������е�Ԫ��
function deleteElementbyIndex(tArray,index)
{
	 try{
			var newArray=[],index=index-0;
			for(var i=0;i<tArray.length;i++){
				if(i!=index){
					newArray.push(tArray[i]);
				}else{
					continue;
				}
			
			}
		}catch(e){
			console.error("ɾ������:",e) 
		}
	 return newArray;
} 