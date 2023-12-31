var dict={
    init:function(){
        dict.initDictItem();
        dict.initDictBox();
        dict.initDictDataBox();
    },
    initDictItem:function(){
        $("#TICUCICtlocDr").combobox({
            valueField: 'RowId',
            textField: 'Description',
            url: ANCSP.DataQuery,
            onBeforeLoad: function(param) {
                param.ClassName = CLCLS.BLL.Admission;
                param.QueryName = "FindLocationOld";
                param.Arg1 = param.q?param.q:"";
                param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
                param.ArgCnt = 2;
            }
        });
        $("#ICUCVI_IcuriId").combobox({
            textField: "tICUCRIDesc",
            valueField: "tRowId",
            url: ANCSP.DataQuery,
            onBeforeLoad: function(param) {
                param.ClassName = "web.DHCICUCRecordItem";
                param.QueryName = "FindICUCRecordItem";
                param.Arg1 = $("#ICUCVI_IcuriId").combobox('getValue');
                param.Arg2 = "";
                param.Arg3 = "";
                param.Arg4 = "";
                param.Arg5 = "";
                param.Arg6 = "N";
                param.ArgCnt = 6;
            }
        });
        $("#ICUCVI_Arcim").combobox({
            textField: "ARCIMastDesc",
            valueField: "ARCIMastRowID",
            url: ANCSP.DataQuery,
            onBeforeLoad: function(param) {
                param.ClassName = "web.DHCICUCode";
                param.QueryName = "FindOrcItmMast";
                param.Arg1 = $("#ICUCVI_Arcim").combobox('getValue');
                param.Arg2 = "";
                param.ArgCnt = 2;
            }
        });
        $("#ICUCVI_MainItemLink").combobox({
            textField: "ICUCVI_Desc",
            valueField: "ICUCVI_RowId",
            url: ANCSP.DataQuery,
            onBeforeLoad: function(param) {
                param.ClassName = "web.DHCICUCVitalSignWarn";
                param.QueryName = "FindVitalSignWarn";
                param.Arg1 = $("#TRowid").val();
                param.ArgCnt = 1;
            }
        });
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
                {field:"TICUCICode",title:"代码",width:100},
                {field:"TICUCIDesc",title:"描述",width:200},
                {field:"TICUCICtloc",title:"科室",width:150},
                {field:"TICUCIType",title:"类型",width:80}
            ]],
            onBeforeLoad:function(param){
                param.ClassName="web.DHCICUCVitalSignWarn";
                param.QueryName="FindICUCInquiry";
                param.Arg1= $("#TICUCIDesc").val();
                param.Arg2= $("#TICUCICtlocDr").val();
                param.ArgCnt=2;
            },
            onSelect:function(rowIndex,rowData){
                $("#dictForm").form("load",rowData);
                $("#dictDataBox").datagrid("reload");
                $("#TRowid").val(rowData.TRowid);
                $("#ICUCVI_MainItemLink").combobox("reload");
            }
        });

        $("#btnAddDict").linkbutton({
            onClick:function(){
                var formData=$("#dictForm").serializeJson();
                var ret = dhccl.runServerMethodNormal("web.DHCICUCVitalSignWarn", "InsertICUCInquiry",formData.TICUCICode,formData.TICUCIDesc,formData.TICUCICtlocDr,"","","","","",formData.TICUCIType);
                if(ret==="0"){
                    $.messager.popover({type:"success",msg:"新增字典成功。",timeout:1500});
                    $("#dictForm").form("clear");
                    $("#dictDataForm").form("clear");
                    $("#dictBox").datagrid("reload");
                    $("#dictDataBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","新增字典失败，原因："+ret,"error");
                }
            }
        });

        $("#btnEditDict").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择数据后，再进行修改。","warning");
                    return;
                }
                var formData=$("#dictForm").serializeJson();
                var ret = dhccl.runServerMethodNormal("web.DHCICUCVitalSignWarn", "UpdateICUCInquiry",formData.TRowid,formData.TICUCICode,formData.TICUCIDesc,formData.TICUCICtlocDr,"","","","",formData.TICUCIType);
                if(ret==="0"){
                    $.messager.popover({type:"success",msg:"修改字典成功。",timeout:1500});
                    $("#dictForm").form("clear");
                    $("#dictDataForm").form("clear");
                    $("#dictBox").datagrid("reload");
                    $("#dictDataBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","修改字典失败，原因："+ret,"error");
                }
            }
        });

        $("#btnDelDict").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择数据后，再删除。","warning");
                    return;
                }
                $.messager.confirm("提示","是否删除字典，删除字典后相应的字典数据也将被删除？",function(r){
                    if(r){
				        var ret = dhccl.runServerMethodNormal("web.DHCICUCVitalSignWarn", "DeleteICUCInquiry",selectedDict.TRowid);
                        if(ret==="0"){
                            $.messager.popover({type:"success",msg:"删除字典成功。",timeout:1500});
                            $("#dictForm").form("clear");
                            $("#dictDataForm").form("clear");
                            $("#dictBox").datagrid("reload");
                            $("#dictDataBox").datagrid("reload");
                        }else{
                            $.messager.alert("提示","删除字典失败，原因："+ret,"error");
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
                {field:"ICUCVI_Code",title:"代码",width:100},
                {field:"ICUCVI_Desc",title:"描述",width:100},
                {field:"ICUCVI_ConfigTypeDesc",title:"配置类型",width:100},
                {field:"ICUCVI_MainItemLinkDesc",title:"关联主项",width:100},
                {field:"ICUCVI_MainItem",title:"主项描述",width:200},
                {field:"ICUCVI_TypeDesc",title:"数据类型",width:100},
                {field:"ICUCVI_IcuriDesc",title:"常用医嘱",width:100},
                {field:"ICUCVI_ArcimDesc",title:"关联医嘱",width:200},
                {field:"ICUCVI_MaxQty",title:"最大值",width:100},
                {field:"ICUCVI_MinQty",title:"最小值",width:100},
                {field:"ICUCVI_Duration",title:"持续时间",width:100},
                {field:"ICUCVI_SeqNo",title:"子项个数",width:100}
            ]],
            onBeforeLoad:function(param){
                param.ClassName="web.DHCICUCVitalSignWarn";
                param.QueryName="FindVitalSignWarn";
                param.Arg1=$("#TRowid").val();
                param.ArgCnt=1;
            },
            onSelect:function(rowIndex,rowData){
                $("#dictDataForm").form("load",rowData);
                $("#RowId").val(rowData.ICUCVI_RowId);
            }
        });

        $("#btnAddDictData").linkbutton({
            onClick:function(){
                var selectedDict=$("#dictBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请先左侧选择一条数据再进行操作。","warning");
                    return;
                }
                var formData=$("#dictDataForm").serializeJson();
                if(!formData.ICUCVI_IsMainItem) formData.ICUCVI_IsMainItem="";
                if(!formData.ICUCVI_IsSearch) formData.ICUCVI_IsSearch="";
                if(!formData.ICUCVI_IsDisplay) formData.ICUCVI_IsDisplay="";
                var dataArr=[];
                dataArr.push(formData);
                var dataPara=dhccl.formatObjects(dataArr);
                var ret = dhccl.runServerMethodNormal("web.DHCICUCVitalSignWarn", "InsertVitalSignWarn",selectedDict.TRowid,dataPara);
                if(ret=="0"){
                    $.messager.popover({type:"success",msg:"新增数据成功。",timeout:1500});
                    $("#dictDataBox").datagrid("reload");
                    $("#dictDataForm").form("clear");
                    $("#ICUCVI_MainItemLink").combobox("reload");
                }else{
                    $.messager.alert("提示","新增数据失败，原因："+ret,"error");
                }
            }
        });

        $("#btnEditDictData").linkbutton({
            onClick:function(){
                var selectedDictBox=$("#dictBox").datagrid("getSelected");
                if(!selectedDictBox){
                    $.messager.alert("提示","请先选中左侧数据再进行操作。","warning");
                    return;
                }
                var selectedDict=$("#dictDataBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请先选择一条数据再进行修改。","warning");
                    return;
                }
                var formData=$("#dictDataForm").serializeJson();
                if(!formData.ICUCVI_IsMainItem) formData.ICUCVI_IsMainItem="";
                if(!formData.ICUCVI_IsSearch) formData.ICUCVI_IsSearch="";
                if(!formData.ICUCVI_IsDisplay) formData.ICUCVI_IsDisplay="";
                var dataArr=[];
                dataArr.push(formData);
                var dataPara=dhccl.formatObjects(dataArr);
                var ret = dhccl.runServerMethodNormal("web.DHCICUCVitalSignWarn", "UpdateVitalSignWarn",selectedDictBox.TRowid,selectedDict.ICUCVI_RowId,dataPara);
                if(ret=="0"){
                    $.messager.popover({type:"success",msg:"修改数据成功。",timeout:1500});
                    $("#dictDataBox").datagrid("reload");
                    $("#dictDataForm").form("clear");
                    $("#ICUCVI_MainItemLink").combobox("reload");
                }else{
                    $.messager.alert("提示","修改数据失败，原因："+ret,"error");
                }
            }
        });

        $("#btnDelDictData").linkbutton({
            onClick:function(){
                var selectedDictBox=$("#dictBox").datagrid("getSelected");
                if(!selectedDictBox){
                    $.messager.alert("提示","请先选中左侧数据再进行操作。","warning");
                    return;
                }
                var selectedDict=$("#dictDataBox").datagrid("getSelected");
                if(!selectedDict){
                    $.messager.alert("提示","请选择数据后，再删除。","warning");
                    return;
                }
                $.messager.confirm("提示","是否删除数据？",function(r){
                    if(r){
                        var ret = dhccl.runServerMethodNormal("web.DHCICUCVitalSignWarn", "DeleteVitalSignWarn",selectedDictBox.TRowid,selectedDict.ICUCVI_RowId);
                        if(ret=="0"){
                            $.messager.popover({type:"success",msg:"删除数据成功。",timeout:1500});
                            $("#dictDataBox").datagrid("reload");
                            $("#dictDataForm").form("clear");
                            $("#ICUCVI_MainItemLink").combobox("reload");
                        }else{
                            $.messager.alert("提示","删除数据失败，原因："+ret,"error");
                        }
                    }
                });
            }
        });
    }
}

$(document).ready(dict.init);