var dict={
    init:function(){
        dict.initDictBox();
        dict.initDictDataBox();
    },

    initDictBox:function(){
        $("#dictBox").datagrid({
            title:"字典",
            iconCls:"icon-paper",
            toolbar:"#dictTool",
            headerCls:"panel-header-gray",
            fit:true,
            singleSelect:true,
            url:ANCSP.DataQuery,
            columns:[[
                {field:"Code",title:"代码",width:100},
                {field:"Description",title:"名称",width:200},
            ]],
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.CodeQueries;
                param.QueryName="FindDictionary";
                param.ArgCnt=0;
            },
            onSelect:function(rowIndex,rowData){
                $("#dictForm").form("load",rowData);
                $("#dictDataBox").datagrid("reload");
            }
        });

        $("#btnAddDict").linkbutton({
            onClick:function(){
                var formData=$("#dictForm").serializeJson();
                formData.RowId="";
                formData.ClassName=ANCLS.Code.Dictionary;
                var jsonDataStr=dhccl.formatObject(formData);
                var res=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:jsonDataStr
                });

                if(res.indexOf("S^")===0){
                    $.messager.popover({type:"success",msg:"新增字典成功。",timeout:1500});
                    $("#dictBox").datagrid("reload");
                    $("#dictForm").form("clear");
                }else{
                   if((res.indexOf("#5659"))!=-1)
                    {
                        res="代码不能为空";
                    }
                    if((res.indexOf("#5808"))!=-1)
					{
						res="代码重复";
					}
                    $.messager.alert("提示","新增字典失败，原因："+res,"error");
                }
            }
        });

        $("#btnEditDict").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择字典后，再进行修改。","warning");
                    return;
                }
                var formData=$("#dictForm").serializeJson();
                formData.ClassName=ANCLS.Code.Dictionary;
                var jsonDataStr=dhccl.formatObject(formData);
                var res=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:jsonDataStr
                });

                if(res.indexOf("S^")===0){
                    $.messager.popover({type:"success",msg:"修改字典成功。",timeout:1500});
                    $("#dictBox").datagrid("reload");
                    $("#dictForm").form("clear");
                }else{
                    if((res.indexOf("#5659"))!=-1)
                    {
                        res="代码不能为空";
                    }
					if((res.indexOf("#5808"))!=-1)
					{
						res="代码重复";
					}
                    $.messager.alert("提示","修改字典失败，原因："+res,"error");
                }
            }
        });

        $("#btnDelDict").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择字典后，再删除。","warning");
                    return;
                }

                $.messager.confirm("提示","是否删除字典，删除字典后相应的字典数据也将被删除？",function(r){
                    if(r){
                        var res=dhccl.removeData(ANCLS.Code.Dictionary,selectedDict.RowId);
                        if(res.indexOf("S^")===0){
                            $.messager.popover({type:"success",msg:"删除字典成功。",timeout:1500});
                            $("#dictBox").datagrid("reload");
                            $("#dictForm").form("clear");
                        }else{
                            $.messager.alert("提示","删除字典失败，原因："+res,"error");
                        }
                    }
                });
            }
        });
    },

    initDictDataBox:function(){
        $("#dictDataBox").datagrid({
            title:"字典数据",
            iconCls:"icon-paper",
            toolbar:"#dictDataTool",
            headerCls:"panel-header-gray",
            fit:true,
            singleSelect:true,
            url:ANCSP.DataQuery,
            columns:[[
                {field:"Code",title:"代码",width:100},
                {field:"Description",title:"描述",width:100},
                {field:"Alias",title:"拼音码",width:100},
                {field:"Uom",title:"单位",width:100},
                {field:"Score",title:"分值",width:100},
                {field:"DataItem1",title:"项目1",width:100},
                {field:"DataItem2",title:"项目2",width:100},
                {field:"DataItem3",title:"项目3",width:100},
            ]],
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.CodeQueries;
                param.QueryName="FindDictData";
                var selectedDict=$("#dictBox").datagrid("getSelected");
                param.Arg1=selectedDict?selectedDict.RowId:"";
                param.ArgCnt=1;
            },
            onSelect:function(rowIndex,rowData){
                $("#dictDataForm").form("load",rowData);
            }
        });

        $("#btnAddDictData").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选选择字典，再操作。","warning");
                    return;
                }
                var formData=$("#dictDataForm").serializeJson();
                formData.RowId="";
                formData.ClassName=ANCLS.Code.DictData;
                formData.Dictionary=selectedDict.RowId;
                var jsonDataStr=dhccl.formatObject(formData);
                var res=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:jsonDataStr
                });

                if(res.indexOf("S^")===0){
                    $.messager.popover({type:"success",msg:"新增字典数据成功。",timeout:1500});
                    $("#dictDataBox").datagrid("reload");
                    $("#dictDataForm").form("clear");
                }else{
                    $.messager.alert("提示","新增字典数据失败，原因："+res,"error");
                }
            }
        });

        $("#btnEditDictData").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictDataBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择字典后，再进行修改。","warning");
                    return;
                }
                var formData=$("#dictDataForm").serializeJson();
                formData.ClassName=ANCLS.Code.DictData;
                var jsonDataStr=dhccl.formatObject(formData);
                var res=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:jsonDataStr
                });

                if(res.indexOf("S^")===0){
                    $.messager.popover({type:"success",msg:"修改字典成功。",timeout:1500});
                    $("#dictDataBox").datagrid("reload");
                    $("#dictDataForm").form("clear");
                }else{
                    $.messager.alert("提示","修改字典失败，原因："+res,"error");
                }
            }
        });

        $("#btnDelDictData").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictDataBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择字典数据后，再删除。","warning");
                    return;
                }

                $.messager.confirm("提示","是否删除字典数据？",function(r){
                    if(r){
                        var res=dhccl.removeData(ANCLS.Code.DictData,selectedDict.RowId);
                        if(res.indexOf("S^")===0){
                            $.messager.popover({type:"success",msg:"删除字典数据成功。",timeout:1500});
                            $("#dictDataBox").datagrid("reload");
                            $("#dictDataForm").form("clear");
                        }else{
                            $.messager.alert("提示","删除字典数据失败，原因："+res,"error");
                        }
                    }
                });
            }
        });
    }
}

$(document).ready(dict.init);