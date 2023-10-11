$(function(){
	$("#Active").checkbox("setValue", true);
	//////////////////--1
	/*var Loc = $HUI.combobox("#Loc",{	///科室
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
		     {id:'210',text:'ICU二区'}
		     ,{id:'234',text:'ICU三区'}
		     ,{id:'60',text:'SCBU'}
			,{id:'61',text:'NICU'}
			,{id:'236',text:'CCU'}
			,{id:'558',text:'PICU'}	
		]
	})*/
	var Loc = $HUI.combobox("#Loc",{	///科室
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
	$("#CategoryIn").combobox({	///类型
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        panelHeight:400,
        editable:true,
        onBeforeLoad:function(param){}
	})
	//////////////////--1
	//////////////////--2
	$("#Category").combobox({	///导管类型
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterCategory&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        editable:true,
        onBeforeLoad:function(param){}
	})
	$("#DefaultPos").combobox({	///默认部位
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindCatheterPosition&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        editable:true,
        onBeforeLoad:function(param){}
	})
	$("#ICURecordItem").combobox({	///常用医嘱
		url:$URL+"?ClassName=Clinic.ICU.Catheter&QueryName=FindRecordItem&ResultSetType=array",
        valueField:"RowId",
        textField:"Description",
        editable:true,
        onBeforeLoad:function(param){
	       param.RDesc=param.q 
	    }
	})
	//////////////////--2
	var catheterDatagrid=$("#catheter_datagrid").datagrid({	///列表数据
		fit: true,
        fitColumns:true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        title:"导管基础数据维护",
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
        	{ field: "Code", title: "代码", width: 200, sortable: true },
        	{ field: "Description", title: "名称", width: 250, sortable: true },
        	{ field: "CategoryID", title: "类型ID", width: 250, sortable: true ,hidden:true},
        	{ field: "CategoryDesc", title: "类型", width: 120, sortable: true },
        	{ field: "DefaultPosID", title: "默认置管位置ID", width: 120, sortable: true ,hidden:true},
        	{ field: "DefaultPosDesc", title: "默认置管位置", width: 120, sortable: true },
        	{ field: "RecordItemID", title: "医嘱ID", width: 80, sortable: true },
        	{ field: "LinkRecordItem", title: "医嘱", width: 200, sortable: true },
        	{ field: "LinkRecordItemCatID", title: "分类ID", width: 80, sortable: true },
        	{ field: "LinkRecordItemCat", title: "分类", width: 150, sortable: true },
        	{ field: "Status", title: "状态", width: 80, sortable: true }
        	
       	]],
		onClickRow:function(){
            var row=$("#catheter_datagrid").datagrid('getSelected');
			$("#CatherDesc").val(row.Description);
		},
       	toolbar:[
            {
                iconCls:'icon-add',
                text:'新增',
                handler:function(){
                    saveGroupCaptionHandler("")
                }
            },
            {
                iconCls:'icon-write-order',
                text:'修改',
                handler:function(){
                    var selectRow=$("#catheter_datagrid").datagrid('getSelected');
                    if(selectRow)
                    {
	                    saveGroupCaptionHandler(selectRow)
	                }else{
		             	$.messager.alert('提示','请选择要修改的行！','warning')
		            }
                }
            },
            {
                iconCls:'icon-cancel',
                text:'删除',
                handler:function(){
                    var selectRow=$("#catheter_datagrid").datagrid('getSelected');
                    if(selectRow)
                    {
	                    $.messager.confirm("确认","确认删除：“"+selectRow.CategoryDesc+"”中的“"+selectRow.Description+"”",function(r)
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
					             
									$.messager.alert('提示','信息删除成功','info');
		 							$("#Loc").combobox('setValue',"");
		 							$("#CategoryIn").combobox('setValue',"");
		 							$("#CatherDesc").val("");
		 							$("#catheter_datagrid").datagrid('reload');
					            }else{
						            $.messager.alert('错误','信息删除失败！','warning');
						            return;
						        }
			                }
		                });
	                }
	                else{
		                $.messager.alert('错误','请选择一条数据！','warning');
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
		            $.messager.alert('错误','该条信息已是激活状态，不需要再进行激活！','warning');
		            return;
	            }
	            $.messager.confirm("确认","确认激活：“"+selectRow.CategoryDesc+"”中的“"+selectRow.Description+"”",function(r)
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
							$.messager.alert('提示','信息激活成功','info');
 							$("#Loc").combobox('setValue',"");
 							$("#CategoryIn").combobox('setValue',"");
 							$("#CatherDesc").val("");
 							$("#catheter_datagrid").datagrid('reload');
			            }else{
				            $.messager.alert('错误','信息激活失败！','warning');
				            return;
				        }
	                }
                });
            }
            else{
                $.messager.alert('错误','请选择一条数据！','warning');
				return;
            }
        }
	})
	
})

function saveGroupCaptionHandler(selectRow){
	var titleName="新增导管信息";
	if(selectRow)
	{
		titleName="修改导管信息";
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
				text:'保存',
				handler:function(){
                    saveCatheterData();
                }
            },
            {
				text:'关闭',
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
		$.messager.alert('提示','代码不能为空！','warning');
		return;
	}
	if(Description=="")
	{
		$.messager.alert('提示','描述不能为空！','warning');
		return;
	}
	if(Category=="")
	{
		$.messager.alert('提示','分类不能为空！','warning');
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
		$.messager.alert('成功',"成功:"+result,'warning');
		$("#CaptionDialog").dialog('close');
		$("#catheter_datagrid").datagrid('reload');
		return ;
	}
}
//查找当前值所在数组的index
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
//删除数组中的元素
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
			console.error("删除错误:",e) 
		}
	 return newArray;
} 