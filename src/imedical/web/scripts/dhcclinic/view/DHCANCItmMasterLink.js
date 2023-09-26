//20170303+dyl
$(document).ready(function () {
    $("#itmMaster_add").dialog({
        width: 400,
        title: "新增",
        modal: true,
        closed: true,
        closable: true,
        iconCls: "icon-add",
		onBeforeOpen:function(){
			InitFormItem();
		},
        onClose:function(){
            $('#itmMasterForm').form("reset");
        },
        buttons: [{
            text: "保存",
            style:{"float":"left","margin":"5px 50px 0 100px"},
            iconCls: "icon-save",
            handler: function () {
	         
                if ($("#itmMaster_add").form("validate")) {
                    $.ajax({
                        url: "dhcclinic.jquery.method.csp",
                        type: "post",
                        data: {
							ClassName:"web.DHCANCItmMasterLink",
							MethodName:"SaveItmMasterLink",
                            Arg1:$("#id").val(),
                            Arg2: $("#arcim").combogrid("getValue"),
                            Arg3: $("#arcos").combogrid("getValue"),
                            Arg4: $("#commonOrd").combogrid("getValue"),
                            Arg5: $("#anaestMethod").combogrid("getValue"),
                            Arg6: $("#eventDetailCode").val(),
                            Arg7: $("#eventDetailValue").val(),
                            Arg8: $("#available").combobox("getValue"),
                            Arg9: $("#dateFrom").datebox("getValue"),
                            Arg10: $("#dateTo").datebox("getValue"),
							ArgCnt:10
                        },
                        beforeSend: function () {
                            $.messager.progress({
                                text: '正在保存中...'
                            });
                        },
                        success: function (data, response, status) {
                            $.messager.progress('close');

                            if (data == 0) {
                                $.messager.show({
                                    title: '提示',
                                    msg: '保存麻醉关联医嘱项(套)成功'
                                });
                                $('#itmMasterForm').form("reset");
                                $("#itmMaster_add").dialog("close");
                                $('#itmMaster').datagrid('reload');
                            } else {
                                $.messager.alert('保存失败！', data, 'warning');
                            }
                        }
                    });

                }
            }
        }, {
            text: "取消",
            style:{"float":"left","margin":"5px 20px 0 100px"},
            iconCls: "icon-cancel",
            handler: function () {
                $('#itmMasterForm').form("reset");
                $("#itmMaster_add").dialog("close");
            }
        }
        ]
    });

    

    $("#itmMaster").datagrid({
        title: "麻醉关联医嘱项(套)",
        iconCls: "icon-ordermanage",
        singleSelect:true,
        rownumbers: true,
        border: false,
        pagination: true,
        pageSize: 10,
        pageList: [10, 20, 30, 40, 50],
        pageNumber:1,
        fit: true,
        method: "post",
        url:"dhcclinic.jquery.csp",
		queryParams:{
			ClassName:"web.DHCANCItmMasterLink",
			QueryName:"FindItemMasterLink",
			ArgCnt:"0"
		},
        toolbar: [{
            iconCls: "icon-add",
            text:'新增', 
            
            handler: function () {
                $("#itmMaster_add").dialog({
                    iconCls: "icon-add"
                });
                $("#id").val("");
                $("#itmMaster_add").dialog("open").dialog("setTitle","新增关联项");
            }
        }, {
            iconCls: "icon-edit",
            text:'修改', 
            handler: function () {
                var row = $("#itmMaster").datagrid("getSelected");
                if (row)
                {
                    
                    $("#itmMaster_add").dialog({
                        iconCls: "icon-edit"
                    });
                    $("#itmMaster_add").dialog("open").dialog("setTitle", "修改关联项");
                    $("#arcim").combogrid("setValue", row.ArcimId);
                    $("#arcim").combogrid("setText", row.ArcimDesc);
                    $("#arcos").combogrid("setValue", row.ArcosId);
                    $("#arcos").combogrid("setText", row.ArcosDesc);
                    $("#commonOrd").combogrid("setValue", row.CommonOrdId);
                    $("#commonOrd").combogrid("setText", row.CommonOrdDesc);
                    $("#anaestMethod").combogrid("setValue", row.AnaestMethodId);
                    $("#anaestMethod").combogrid("setText", row.AnaestMethodDesc);
                    $("#eventDetailCode").textbox("setValue",row.EventDetailCode);
                    $("#eventDetailValue").textbox("setValue",row.EventDetailValue);
                    $("#available").combobox("setValue", row.Available);
                    $("#dateFrom").datebox("setValue", row.DateFrom);
                    $("#dateTo").datebox("setValue", row.DateTo);
                    $("#id").val(row.Id);
                }
                
            }
        }
        ],
        columns: [[
            { field: "Id", title: "ID", width: 100 },
            { field: "ArcimId", title: "医嘱项ID", width: 100, hidden: true },
            { field: "ArcimDesc", title: "医嘱项", width: 100 },
            { field: "ArcosId", title: "医嘱套ID", width: 100, hidden: true },
            { field: "ArcosDesc", title: "医嘱套", width: 100 },
            { field: "CommonOrdId", title: "常用医嘱ID", width: 100, hidden: true },
            { field: "CommonOrdDesc", title: "常用医嘱", width: 100 },
            { field: "AnaestMethodId", title: "麻醉方法ID", width: 100, hidden: true },
            { field: "AnaestMethodDesc", title: "麻醉方法", width: 100 },
            { field: "EventDetailCode", title: "事件明细代码", width: 150 },
            { field: "EventDetailValue", title: "事件明细值", width: 100 },
            { field: "Available", title: "可用状态", width: 100 },
            { field: "DateFrom", title: "开始日期", width: 100 },
            { field: "DateTo", title: "结束日期", width: 100 }
        ]]
    });
});

function InitFormItem(){
	$("#arcim").combogrid({
        panelWidth: 400,
        loadMsg:"正在加载中...",
        width: 160,
        rownumbers: true,
        idField: "Id",
        textField: "Desc",
        method:"post",
        url:JQueryToolSetting.RunQueryPageURL,
		queryParams:{
			ClassName:"web.DHCClinicAdmission",
			QueryName:"FindArcim",
			Arg1:"QueryFilter",
			Arg2:"1",
			ArgCnt:"2"
		},
        mode: "remote",
        columns: [[
            { field: "Id", title: "ID", width: 60 },
            { field: "Desc", title: "名称", width: 300 }
        ]],
        onHidePanel: function () {
               OnHidePanel("#arcim");
            }
    });
	
	$("#arcim").combogrid("textbox").change(function () {
        var text = $("#arcim").combogrid("getText");
        if (text == "")
        {
            $("#arcim").combogrid("setValue", "");
        }
    });

    $("#arcos").combogrid({
        panelWidth: 400,
        loadMsg: "正在加载中...",
        width: 160,
        rownumbers: true,
        idField: "arcosId",
        textField: "arcosDesc",
        method: "post",
        url: JQueryToolSetting.RunQueryPageURL,
		queryParams:{
			ClassName:"web.DHCANOrder",
			QueryName:"FindARCOrdSets",
			Arg1:"1",
			ArgCnt:1
		},
        mode: "remote",
        columns: [[
            { field: "arcosId", title: "ID", width: 60 },
            { field: "arcosDesc", title: "名称", width: 300 }
        ]],
        onHidePanel: function () {
               OnHidePanel("#arcos");
            }
    });

    $("#arcos").combogrid("textbox").change(function () {
        var text = $("#arcos").combogrid("getText");
        if (text == "")
        {
            $("#arcos").combogrid("setValue", "");
        }
    });

    $("#commonOrd").combogrid({
        panelWidth: 400,
        loadMsg: "正在加载中...",
        width: 160,
        rownumbers: true,
        idField: "Id",
        textField: "Description",
        method: "post",
         url: JQueryToolSetting.RunQueryPageURL,
		queryParams:{
			ClassName:"web.DHCANCCommonOrd",
			QueryName:"GetANCommonOrdList",
			ArgCnt:0
		}, 
        mode: "remote",
        columns: [[
            { field: "Id", title: "ID", width: 60 },
            { field: "Description", title: "名称", width: 300 }
        ]],
        onHidePanel: function () {
               OnHidePanel("#commonOrd");
            }
    });
	
	$("#commonOrd").combogrid("textbox").change(function () {
        var text = $("#commonOrd").combogrid("getText");
        if (text == "")
        {
            $("#commonOrd").combogrid("setValue", "");
        }
    });

    $("#anaestMethod").combogrid({
        panelWidth: 400,
        loadMsg: "正在加载中...",
        width: 160,
        rownumbers: true,
        idField: "Id",
        textField: "Desc",
        method: "post",
        url: JQueryToolSetting.RunQueryPageURL,
		queryParams:{
			ClassName:"web.DHCClinicAdmission",
			QueryName:"FindAnaestMethod",
			Arg1:"",
			ArgCnt:1
		},
        mode: "remote",
        columns: [[
            { field: "Id", title: "ID", width: 60 },
            { field: "Desc", title: "名称", width: 300 }
        ]],
        onHidePanel: function () {
               OnHidePanel("#anaestMethod");
            }
    });
	
	$("#anaestMethod").combogrid("textbox").change(function () {
        var text = $("#anaestMethod").combogrid("getText");
        if (text == "")
        {
            $("#anaestMethod").combogrid("setValue", "");
        }
    });

    $("#eventDetailCode").textbox({
        width: 160
    });

    $("#eventDetailValue").textbox({
        width: 160
    });

    var availableOptions = [{ "id": 1, "text": "Y" }, { "id": 2, "text": "N" }];
    $("#available").combobox({
        width: 160,
        editable:false,
    });
	$("#available").combobox("setValue","");
    $("#dateFrom").datebox({
        width: 160
    });

    $("#dateTo").datebox({
        width: 160
    });
}
    ///
    function OnHidePanel(item)
	{
		var valueField = $(item).combogrid("getText");
	    var val = $(item).combogrid("getValue");  //当前combobox的值
	    if((valueField==val)&&(valueField!="")&&(typeof valueField!="undefined"))
	    {
		    alert("请从下拉框选择")	    
		    $(item).combogrid("setValue","");

		    return;
	    } 	
	}
