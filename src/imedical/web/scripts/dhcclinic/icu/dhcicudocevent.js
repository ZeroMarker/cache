var editIndex;
var clcpRowId;
var ICUCIIDr="";
var selectOperIndex;
var reg=/^[0-9]+.?[0-9]*$/; 
$(function(){
	InitFormItem();
	InitGroupData();
});
function InitFormItem()
{
	    var DECCode=$HUI.combobox("#CFICUDECCode",{
        url:$URL+"?ClassName=web.DHCICUDocEvent&QueryName=FindDocEventCatList&ResultSetType=array",
        valueField:"catCode",
        textField:"catDesc",
        onBeforeLoad:function(param)
        {
        }   
    });
    //##class(%ResultSet).RunQuery("web.DHCICUCInquiry","FindInquiryitem",45)
    var CIIDr=$HUI.combobox("#ICUCIIDr",{
        url:$URL+"?ClassName=web.DHCICUCInquiry&QueryName=FindInquiryitem&ResultSetType=array",
        valueField:"TRowid",
        textField:"TICUCIIDesc",
        onBeforeLoad:function(param)
        {
	        param.ICUCIRowid="40";
        }   
    });
    var FCII=$HUI.combobox("#FCII",{
        url:$URL+"?ClassName=web.DHCICUCInquiry&QueryName=FindInquiryitem&ResultSetType=array",
        valueField:"TRowid",
        textField:"TICUCIIDesc",
        onBeforeLoad:function(param)
        {
	        param.ICUCIRowid="40";
        }   
    });
    var FDocEventCat=$HUI.combobox("#FDocEventCat",{
        url:$URL+"?ClassName=web.DHCICUDocEvent&QueryName=FindDocEventCatList&ResultSetType=array",
        valueField:"catId",
        textField:"catDesc",
        onBeforeLoad:function(param)
        {
        }   
    });

}
function InitGroupData()
{
	    $("#DocEventListData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCICUDocEvent",
            QueryName:"GetDocEventList"
        },
        onBeforeLoad: function(param) {
	        param.code=$("#code").val();
	        param.desc=$("#desc").val();
        },
        columns:[
            [
             {field: "rowId", title: "Id", width: 60, sortable: true},
          	{field: "docEventCode", title: "代码", width: 60, sortable: true},
               {field: "docEventDesc", title: "描述", width: 120, sortable: true},
               {field: "docEventCat", title: "分类", width: 60, sortable: true},
               {field: "docEventCatId", title: "分类Id", width: 120, sortable: true, hidden:true},
               {field: "docEventCII", title: "关联统计项", width: 120, sortable: true},
               {field: "docEventCIIId", title: "关联统计项Id", width: 60, sortable: true, },
               {field: "docEventStartTime", title: "开始时间", width: 60, sortable: true}
               
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'新增',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'编辑',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'删除',
			    handler: function(){
                    deleteRow();
                }
            }
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	        clcpRowId=rowData.rowId;
	        ICUCIIDr=rowData.docEventCIIId;
	        $HUI.datagrid("#ICUInquiryListData").reload();
	        
        }
    })
    $("#ICUInquiryListData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        title:"条件项",
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCICUDocEvent",
            QueryName:"FindDocEventInquiryList"
        },
        onBeforeLoad: function(param) {
	        param.ICUCIIDr=ICUCIIDr;
        },
        columns:[
            [
             {field: "rowId", title: "Id", width: 60, sortable: true},
          	{field: "ICUCIIMainICUCIICode", title: "代码", width: 60, sortable: true},
               {field: "ICUCIIMainICUCIIDesc", title: "描述", width: 120, sortable: true},
               {field: "ICUCIIMainICUCIIType", title: "类型", width: 60, sortable: true},
               {field: "ICUCIIMainICUCIISearch", title: "查询项", width: 120, sortable: true},
               {field: "ICUCIIMainICUCIIDisplay", title: "显示项", width: 60, sortable: true}
               
            ]
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	        clcpRowId=rowData.rowId;
	        
        }
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#DocEventListData").reload();
    });
}

function InitOperDiag()
{
	$('#FDocEventCat').combobox("reload");
	$('#FCII').combobox("reload");
}
//新增
function appendRow()
{
	    $("#eventDialog").dialog({
        title: "新增危急事件",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#eventDialog").dialog("open");

}
function editRow()
{
	var selectRow=$("#DocEventListData").datagrid("getSelected");
    if(selectRow)
    {
        $("#eventDialog").dialog({
            title: "修改危急事件",
            iconCls: "icon-w-edit"
        });
        var code=selectRow.docEventCode;
        var desc=selectRow.docEventDesc;
        var cat=selectRow.docEventCatId;
        
        var CII=selectRow.docEventCIIId;
        var time=selectRow.docEventStartTime;
        
        $("#FDocEventCat").combobox('setValue',cat)
        $("#FCII").combobox('setValue',CII)
        
        $("#FCode").val(code);
        $("#FDesc").val(desc);
        //$HUI.datebox("#DateTo").setValue(tdate);
        //$("#DateFrom").datebox('setValue',fdate);
        $("#FStartTime").timespinner('setValue',time);
        $("#eventDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
	    //info,question,warning,error
        $.messager.alert("提示", "请先选择要修改的记录！", 'warning');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#DocEventListData").datagrid("getSelected");
    if(selectRow)
    {
	    var rowId=selectRow.rowId;
	    var datas=$.m({
        ClassName:"web.DHCICUDocEvent",
        MethodName:"DeleteDocEvent",
        rowId:rowId
    },false);
    if(datas==0)
    {
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#DocEventListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'warning');
        return;
    }	
}
function saveDocEvent()
{
	
        var code=$("#FCode").val();
        var time=$("#FStartTime").val();
        var desc=$("#FDesc").val();
 	 	var FCII=$("#FCII").combobox('getValue');
 	 	if(!reg.test(FCII.split("||")[0]))
 	 	 {
	 	 	 $.messager.alert("提示","关联项请从下拉框选择","error");
        	return;
 	 	 }
		var eventCat=$("#FDocEventCat").combobox('getValue');
        if(!reg.test(eventCat))
 	 	 {
	 	 	 $.messager.alert("提示","类型请从下拉框选择","error");
        	return;
 	 	 }

      var rowdata={
	     code:code,
         desc:desc,
         time:time,
         FCII:FCII,
         eventCat:eventCat
      
    }
     if( $("#EditOperation").val()=="Y")
    {
    	var datas=$.m({
        ClassName:"web.DHCICUDocEvent",
        MethodName:"UpdateDocEvent",
        rowId:clcpRowId,
        code:code,
        desc:desc,
        time:time,
        FCII:FCII,
        eventCat:eventCat
    	},false);
       $HUI.datagrid("#DocEventListData").updateRow({index:selectOperIndex,row:rowdata});
		$.messager.alert("提示", "修改成功！", 'info');
    }
    else
    {
    	var datas=$.m({
        ClassName:"web.DHCICUDocEvent",
        MethodName:"InsertDocEvent",
        code:code,
        desc:desc,
        time:time,
        FCII:FCII,
        eventCat:eventCat
    	},false);
    	$HUI.datagrid("#DocEventListData").appendRow(rowdata);
    	$.messager.alert("提示", "添加成功！", 'info');
    }
     $("#DocEventListData").datagrid("reload");
	$HUI.dialog("#eventDialog").close();
	
}