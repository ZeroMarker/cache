function initPage(){
    resizeRegion();
    initInstrumentsBox();
    
    initSurgicalKitOptions();
    initOperActions();
}

function resizeRegion(){
    console.log(window.innerWidth);
    var eastPanel=$("body").layout("panel","east");
    var marginWidth=30;
    var panelWidth=(window.innerWidth-marginWidth)/2;
    $(eastPanel).panel("resize",{
        width:panelWidth
    });
    $("body").layout("resize");
}
var lastselctrowindex="";
var selRowId="";
function initInstrumentsBox(){
    $("body").resize(function(){
        resizeRegion();
    });
    var columns=[[
        {field:"CheckStatus",title:"选择",checkbox:true},
        {field:"MaterialPackId",title:"手术包ID",hidden:true},
        {field:"MaterialPackNote",title:"手术包",width:300},
        {field:"MaterialNumber",title:"数量",width:100},
        {field:"MPackRowId",title:"rowid",hidden:true},
         {field:"RecordSheet",title:"RecordSheetId",hidden:true}
    ]];

    $("#MaterialData").datagrid({
        fit: true,
        title:"手术包登记",
        headerCls:"panel-header-gray",
        checkOnSelect:true,
        selectOnCheck:true,
        singleSelect: true,
        pagination: false,
        iconCls:"icon-paper",
        url: ANCSP.DataQuery,
        toolbar: "#instrumentsTool",
        columns: columns,
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindMaterialPack",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        onClickRow: function(rowIndex, rowData) {
	        if((rowIndex===lastselctrowindex))
	        {
		        $('#MaterialData').datagrid('clearSelections');
		        $("#MaterialPack").combobox('setValue','')
				$("#MPackNumber").val("");
				lastselctrowindex="";
	        }
	        else
	        {
		     var cssdr=rowData["MaterialPackId"];
		     var number=rowData["MaterialNumber"];
             selRowId=rowData["MPackRowId"];
	        $("#MaterialPack").combobox('setValue',cssdr)
			$("#MPackNumber").val(number);
			lastselctrowindex=rowIndex;
	        }
 			
       },
        onLoadSuccess: function(data) {
            $(this).datagrid("clearChecked");
        }
    });

    //$("#MaterialData").datagrid("enableCellEditing");
}

/**
 * 初始化手术包和手术物品可选项。
 */
function initSurgicalKitOptions(){
    $("#MaterialPack").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalKits";
            param.Arg1 = "N";
            param.Arg2 = "Y";
            param.Arg3=param.q?param.q:"";
            param.ArgCnt = 3;
        },
        mode: "remote",
        onSelect:function(record){
            var id=$(this).attr("id");
            if(id==="MaterialPack"){
                //selectedSurgicalKit(id,"手术包",record,"MaterialData");
            }else{
                //selectedSurgicalKit(id,"手术包",record,"dressingsBox");
            }
            
        }
    });

}

/**
 * 初始化操作功能按钮
 */
function initOperActions(){
    $('#btnAdd').linkbutton({
        onClick:function(){
            saveMaterialDatas();
        }
    });
    $('#btnEdit').linkbutton({
        onClick:function(){
            editMaterialDatas();
        }
    });
    $('#btnDel').linkbutton({
        onClick:function(){
            delMaterialDatas();
        }
    });
}
/*
*/
function saveMaterialDatas()
{
    var allRows=$("#MaterialData").datagrid("getData");
    var count=allRows.total;
    var selectRows=allRows.rows;
    var packIdStr="";
    for (var i = 0; i < count; i++) 
    {
        var record=selectRows[i];
        var curPackId = record.MaterialPackId;
        if(packIdStr=="")
        {
            packIdStr=curPackId;
        }
        else{
            packIdStr=packIdStr+"^"+curPackId;
        }
    }
   
    var saveDatas=[];
    var MaterialPackId=$("#MaterialPack").combobox('getValue');
    var MaterialNumber=$("#MPackNumber").val();
    if(("^"+packIdStr+"^").indexOf(("^"+MaterialPackId+"^"))!=-1)
    {
        var errorinfo="该手术包已经存在，请在原有基础上修改数据";
        $.messager.alert("提示","添加失败，原因："+errorinfo,"error");
        return;
    }
    var surgicalCount={
        MaterialPackId:MaterialPackId,
        RecordSheet:session.RecordSheetID,
        MaterialNumber:MaterialNumber,
        ClassName:ANCLS.Model.MaterialPack
    }
    
    saveDatas.push(surgicalCount);
   
    var jsonData = dhccl.formatObjects(saveDatas);
    var data = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(result) {
        if(result.indexOf("S^")===0){
            $('#MaterialData').datagrid("reload");
        }else{
            $.messager.alert("保存清点数据失败，原因："+result);
        }
        
    });
}
function editMaterialDatas()
{
    //alert(selRowId);
   // return;
   var countDatas=$('#MaterialData').datagrid("getChecked");
   if(countDatas.length==0)
   {
        $.messager.alert("警告","请先选择一行，再修改！");
        return;
   }
   var allRows=$("#MaterialData").datagrid("getData");
   var count=allRows.total;
   var selectRows=allRows.rows;
   var packIdStr="";
   for (var i = 0; i < count; i++) 
   {
       var record=selectRows[i];
       var curPackId = record.MaterialPackId;
       if(packIdStr=="")
       {
           packIdStr=curPackId;
       }
       else{
           packIdStr=packIdStr+"^"+curPackId;
       }
   }
  
   var saveDatas=[];
   var MaterialPackId=$("#MaterialPack").combobox('getValue');
   var MaterialNumber=$("#MPackNumber").val();
   if(("^"+packIdStr+"^").indexOf(("^"+MaterialPackId+"^"))!=-1 &&countDatas[0].MaterialPackId !=MaterialPackId)
   {
       var errorinfo="该手术包已经存在，请在原有基础上修改数据";
       $.messager.alert("提示","添加失败，原因："+errorinfo,"error");
       return;
   }

    var saveDatas=[];
    var MaterialPackId=$("#MaterialPack").combobox('getValue');
    var MaterialNumber=$("#MPackNumber").val();
    var surgicalCount={
        RowId:selRowId,
        MaterialPackId:MaterialPackId,
        RecordSheet:session.RecordSheetID,
        MaterialNumber:MaterialNumber,
        ClassName:ANCLS.Model.MaterialPack
    }
    
    saveDatas.push(surgicalCount);
   
    var jsonData = dhccl.formatObjects(saveDatas);
    var data = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(result) {
        if(result.indexOf("S^")===0){
            $('#MaterialData').datagrid("reload");
        }else{
            $.messager.alert("保存数据失败，原因："+result);
        }
        
    });
}
function delMaterialDatas()
{
    var countDatas=$('#MaterialData').datagrid("getChecked");
    var boxId="MaterialData";
    var saveDatas=[],delDatas=[];
    for (var i = 0; i < countDatas.length; i++) {
        const element = countDatas[i];
        var rowIndex=$("#"+boxId).datagrid("getRowIndex",element);
        var dto={
            ClassName:ANCLS.Model.MaterialPack,
            RowId:element.MPackRowId
        };
        var delObj={
            RowIndex:rowIndex,
            RowData:element
        }
        if(dto.RowId){
            saveDatas.push(dto);
        }
        delDatas.push(delObj);
    }
    if(saveDatas.length>0){
        var jsonStr=dhccl.formatObjects(saveDatas);
        var delResult=dhccl.removeDatas(jsonStr);
        if(delResult.indexOf("S^")===0){
            for (var i = 0; i < delDatas.length; i++) {
                const element = delDatas[i];
                var rowIndex=$("#"+boxId).datagrid("getRowIndex",element.RowData);
                $("#"+boxId).datagrid("deleteRow",rowIndex);
            }
            $("#"+boxId).datagrid("clearChecked");
        }else{
            $.messager.alert("提示","删除失败，原因："+delResult,"error");
        }
    }else{
	    if(delDatas.length==0)
   		{
        	$.messager.alert("警告","请先选择一行，再删除！");
        	return;
   		}
        for (var i = 0; i < delDatas.length; i++) {
            const element = delDatas[i];
            var rowIndex=$("#"+boxId).datagrid("getRowIndex",element.RowData);
            $("#"+boxId).datagrid("deleteRow",rowIndex);
        }
        $("#"+boxId).datagrid("clearChecked");
    }
}
$(document).ready(initPage);

