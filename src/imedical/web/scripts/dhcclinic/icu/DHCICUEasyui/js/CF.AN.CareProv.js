var editIndex;
var clcpRowId;
var selectOperIndex;
var reg=/^[0-9]+.?[0-9]*$/; 
$(function(){
	InitFormItem();
	InitGroupData();
});
function InitFormItem()
{
	var datefrm=$HUI.datebox("#DateFrom",{
    });
    var datefrm=$HUI.datebox("#DateTo",{
    });
	    var appLoc=$HUI.combobox("#AppLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="";
            param.EpisodeID="";
        }   
    });
    var Type=$HUI.combobox("#Type",{
        url:$URL+"?ClassName=CIS.AN.BL.CareProvider&QueryName=LookUpCareProv&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        editable:false,
        panelHeight:'auto',
         onBeforeLoad:function(param)
        {
            param.type="UserType";
        }   
    })

    var yesno=$HUI.combobox("#IsLeave",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"是",'typecode':"Y"},{'typedesc':"否",'typecode':"N"}]
    }) 
    var yesno=$HUI.combobox("#IsDoc",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"手术",'typecode':"Y"},{'typedesc':"麻醉",'typecode':"N"}]
    }) 
	    var fLoc=$HUI.combobox("#FDocLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="";
            param.EpisodeID="";
        }   
    });
    var fType=$HUI.combobox("#FType",{
        url:$URL+"?ClassName=CIS.AN.BL.CareProvider&QueryName=LookUpCareProv&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        editable:false,
        panelHeight:'auto',
         onBeforeLoad:function(param)
        {
            param.type="UserType";
        }   
    });
    
    var fyesno=$HUI.combobox("#FIsLeave",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        panelHeight:'auto',
        editable:false,
        data:[{'typedesc':"是",'typecode':"Y"},{'typedesc':"否",'typecode':"N"}]
    });
    var fyesno=$HUI.combobox("#FIsDoc",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"Atypecode",
        textField:"Atypedesc",
        panelHeight:'auto',
        editable:false,
        data:[{'Atypedesc':"手术",'Atypecode':"Y"},{'Atypedesc':"麻醉",'Atypecode':"N"}]
    });


}
function InitGroupData()
{
	    $("#CareProvListData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"CIS.AN.BL.CareProvider",
            QueryName:"FindCareProv"
        },
        onBeforeLoad: function(param) {
	        param.descV=$("#Name").val();;
	        param.aliasV=$("#Alias").val();
	        param.ctlocId=$("#AppLoc").combobox('getValue');
	        param.clcpifdoc=$("#IsDoc").combobox('getValue');
	        param.clcptype=$("#Type").combobox('getValue');
	        param.clcpinActive=$("#IsLeave").combobox('getValue');
        },
        columns:[
            [
               {field: "clcpRowId", title: "人员Id", width: 60, sortable: true},
               {field: "Code", title: "代码", width: 60, sortable: true},
               {field: "ctlocdesc", title: "科室", width: 120, sortable: true},
               {field: "desc", title: "姓名", width: 60, sortable: true},
               {field: "alias", title: "别名", width: 60, sortable: true},
               {field: "ifDocDes", title: "是否为手术类型", width: 60, sortable: true},
               {field: "inActiveDes", title: "是否有效", width: 60, sortable: true},
               {field: "ifDoc", title: "是否医生代码", width: 60, sortable: true,hidden:true},
               {field: "typeDes", title: "类型", width: 60, sortable: true},
               {field: "fdate", title: "开始日期", width: 80, sortable: true},
               {field: "tdate", title: "结束日期", width: 80, sortable: true},
               {field: "hospitalDesc", title: "医院", width: 60, sortable: true},
               {field: "type", title: "类型代码", width: 60, sortable: true,hidden:true},
               {field: "inActive", title: "是否有效代码", width: 100, sortable: true,hidden:true},
               {field: "ctlocdr", title: "科室标识", width: 60, sortable: true,hidden:true},
               {field: "hospitalDr", title: "医院标识", width: 60, sortable: true,hidden:true}
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
			    text:'修改',
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
	        clcpRowId=rowData.clcpRowId;
	        
        }
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#CareProvListData").reload();
    });
}

function InitOperDiag()
{
	$('#FDocLoc').combobox("reload");
	$('#FIsDoc').combobox("reload");
	$('#FType').combobox("reload");
	
	$('#FIsLeave').combobox("reload");
}
//新增
function appendRow()
{
	    $("#operDialog").dialog({
        title: "新增医护人员",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");

}
function editRow()
{
	var selectRow=$("#CareProvListData").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "修改医护人员",
            iconCls: "icon-w-edit"
        });
        var desc=selectRow.desc;
        var alias=selectRow.alias;
        var ctlocdesc=selectRow.ctlocdesc;
        var ifDocDes=selectRow.ifDocDes;
        var inActiveDes=selectRow.inActiveDes;
        var ifDoc=selectRow.ifDoc;
        var typeDes=selectRow.typeDes;
        var fdate=selectRow.fdate;
        var tdate=selectRow.tdate;
        //var hospital=selectRow.hospital;
        var clcpRowId=selectRow.clcpRowId;
        var type=selectRow.type;
        var inActive=selectRow.inActive;
        var ctlocdr=selectRow.ctlocdr;
         var hospital=selectRow.hospitalDesc;
         var Code=selectRow.Code;
         $("#FCode").val(Code)
        $("#FDocLoc").combobox('setValue',ctlocdr)
        $("#FIsDoc").combobox('setValue',ifDoc)
        $("#FType").combobox('setValue',type)
        $("#FIsLeave").combobox('setValue',inActive)
       $("#FHosp").val(hospital)
        $("#FName").val(desc);
        $("#FAlias").val(alias);
        $HUI.datebox("#DateTo").setValue(tdate);
        $("#DateFrom").datebox('setValue',fdate);
        
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
	    //info,question,warning,error
        $.messager.alert("提示", "请先选择要修改的记录！", 'warning');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#CareProvListData").datagrid("getSelected");
    if(selectRow)
    {
	    var rowId=selectRow.clcpRowId;
	    var datas=$.m({
        ClassName:"CIS.AN.BL.CareProvider",
        MethodName:"DeleteCareProv",
        clcpRowId:rowId
    },false);
    if(datas==0)
    {
	    $.messager.alert("提示", "删除成功！", 'info');
	    $("#CareProvListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("提示", "请先选择要删除的记录！", 'warning');
        return;
    }	
}
function saveCareProv()
{
        var desc=$("#FName").val();
        var alias=$("#FAlias").val();
 	 	var ctlocdr=$("#FDocLoc").combobox('getValue');
 	 	 if(!reg.test(ctlocdr))
 	 	 {
	 	 	 $.messager.alert("提示","科室请从下拉框选择","error");
        	return;
           }
           //var Code=$("#Code").combobox('getText');
         var ctlocdesc=$("#FDocLoc").combobox('getText');
        var ifDoc=$("#FIsDoc").combobox('getValue');
        var ifDocDes=$("#FIsDoc").combobox('getText');
         var inActive=$("#FIsLeave").combobox('getValue');
       var inActiveDes=$("#FIsLeave").combobox('getText');
         var type=$("#FType").combobox('getValue');
        var typeDes=$("#FType").combobox('getText');
     var tdate=$("#DateTo").datebox('getValue');
        var fdate=$("#DateFrom").datebox('getValue');
        var hospital=$("#FHosp").val();
        var Code=$("#FCode").val();
      var rowdata={
          Code:Code,
         desc:desc,
         alias:alias,
        ctlocdesc:ctlocdesc,
          ctlocdr:ctlocdr,
      ifDocDes:ifDocDes,
        ifDoc:ifDoc,
        inActiveDes:inActiveDes,
        inActive:inActive,
        typeDes:typeDes,
        type:type,
        fdate:fdate,
        tdate:tdate,
        hospital:hospital,
        //hospitalDr:hospitalDr
    }
    //alert(rowdata.inActiveDes)
    //return;
     if( $("#EditOperation").val()=="Y")
    {
    	var datas=$.m({
        ClassName:"CIS.AN.BL.CareProvider",
        MethodName:"UpdateCareProv",
        clcpRowId:clcpRowId,
        Code:Code,
        ctlocdr:ctlocdr,
        desc:desc,
        alias:alias,
        fdate:fdate,
        tdate:tdate,
        inActive:inActive,
        ifDoc:ifDoc,
        type:type,
        hospital:hospital
    	},false);
       $HUI.datagrid("#CareProvListData").updateRow({index:selectOperIndex,row:rowdata});
		$.messager.alert("提示", "修改成功！", 'info');
    }
    else
    {
    	var datas=$.m({
        ClassName:"CIS.AN.BL.CareProvider",
        MethodName:"InsertCareProv",
        Code:Code,
         ctlocdr:ctlocdr,
        desc:desc,
        alias:alias,
        fdate:fdate,
        tdate:tdate,
        inActive:inActive,
        ifDoc:ifDoc,
        type:type,
        hospital:hospital
    	},false);
    	$HUI.datagrid("#CareProvListData").appendRow(rowdata);
    	$.messager.alert("提示", "添加成功！", 'info');
    }
     $("#CareProvListData").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	
}