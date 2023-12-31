// 初始化耗材套餐数据表格
function initChargeSet(){
    var columns=[[
        {field:"Code",title:"代码",width:120},
        {field:"Description",title:"名称",width:160}
    ]];

    var dataForm = new DataForm({
        datagrid: $("#chargeSetBox"),
        gridColumns: columns,
        gridTitle: "收费套餐",
        gridTool: "#chargeSetTools",
        form: $("#chargeSetForm"),
        modelType: ANCLS.Config.ChargeSet,
        queryType: ANCLS.BLL.ChargeRecord,
        queryName: "FindChargeSets",
        queryParams:{
            Arg1:session.DeptID,
            ArgCnt:1
        },
        dialog: null,
        addButton: $("#btnAddChargeSet"),
        editButton: $("#btnEditChargeSet"),
        delButton: $("#btnDelChargeSet"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack:selectChargeSet
    });
    dataForm.initDataForm();
}

function selectChargeSet(){
    $("#chargeSetItemBox").datagrid("reload");
}

// 初始化耗材套餐项目数据表格
function initChargeSetItem(){
    $("#Dept").val(session.DeptID);

    var columns=[[
        {field:"ChargeItemDesc",title:"项目",width:160},
        {field:"DefQty",title:"默认数量",width:80},
        {field:"Price",title:"单价",width:80},
        {field:"UomDesc",title:"单位",width:80},
        {field:"Seq",title:"序号",width:100,
        formatter:function(value,row,index){
            if(value!==""){
                return value;
            }else{
                return (10001+index);
            }
        }}
    ]];

    var dataForm = new DataForm({
        datagrid: $("#chargeSetItemBox"),
        gridColumns: columns,
        gridTitle: "收费套餐明细项",
        gridTool: "#chargeSetItemTools",
        form: $("#chargeSetItemForm"),
        modelType: ANCLS.Config.ChargeSetItem,
        queryType: ANCLS.BLL.ChargeRecord,
        queryName: "FindChargeSetItems",
        dialog: null,
        addButton: $("#btnAddChargeSetItem"),
        editButton: $("#btnEditChargeSetItem"),
        delButton: $("#btnDelChargeSetItem"),
        beforeAddCallBack:selectOrderSet,
        submitCallBack: null,
        onSubmitCallBack:changeChargeSetItemParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack:selectChargeSetItem
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        onBeforeLoad:function(param){
            var chargeSetId="";
            var selectedChargeSet=$("#chargeSetBox").datagrid("getSelected");
            if (selectedChargeSet){
                chargeSetId=selectedChargeSet.RowId;
            }
            param.Arg1=chargeSetId;
            param.ArgCnt=1;
        },
        onLoadSuccess:function(data){
            if(data && data.rows && data.rows.length>0){
                if(latestSelectedSetItem>=0){
                    $(this).datagrid("selectRow",latestSelectedSetItem);
                    latestSelectedSetItem=-1;
                }
            }
        }
    });

    $("#ChargeItem").combogrid({
        panelWidth:400,
        idField:'RowId',
        textField:'Description',
        url:ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindChargeItemByCondition";
            param.Arg1=session.DeptID;
            param.Arg2 = param.q ? param.q : "";
            param.ArgCnt = 2;
        },
        columns:[[
            {field:'Description',title:'项目名称',width:200},
            {field:'Price',title:'单价',width:80},
            {field:'UnitDesc',title:'单位',width:60}
            // {field:'Spec',title:'规格',width:80},
            // {field:'Manufacturer',title:'制造商',width:60},
            // {field:'Vendor',title:'供应商',width:60}
        ]],
        mode:"remote",
        onSelect:function(rowIndex,rowData){
            $("#Uom").combobox("setValue",rowData.Unit);
            $("#DefQty").numberbox("setValue",1);
        }
    });

    $("#Uom").combobox({
        valueField: "RowId",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        }
    });

    $("#btnMoveUp").linkbutton({
        onClick:function(){
            changeChargeSetItemSeq("up");
        }
    });

    $("#btnMoveDown").linkbutton({
        onClick:function(){
            changeChargeSetItemSeq("down");
        }
    });
}

function selectOrderSet(){
    var result=dhccl.hasRowSelected($("#chargeSetBox"),true,"收费套餐未选择，请先选择！");
    return result;
}

function changeChargeSetItemParam(param){
    var chargeSetId=$("#ChargeSet").val();
    if(!chargeSetId || chargeSetId===splitchar.empty){
        var selectedOrderSet=$("#chargeSetBox").datagrid("getSelected");
        $("#ChargeSet").val(selectedOrderSet.RowId);
    }
    if ($("#ChargeSetItemId").val()===""){
        param.CreateUser=session.UserID;
    }
    param.UpdateUser=session.UserID;
}

function selectChargeSetItem(){
    var selectedRow=$("#chargeSetItemBox").datagrid("getSelected");
    if(selectedRow){
        $("#ChargeItem").combogrid("setText",selectedRow.ChargeItemDesc);
    }
}


var latestSelectedSetItem=-1;
function changeChargeSetItemSeq(direction){
    if(dhccl.hasRowSelected($("#chargeSetItemBox"),true)){
        var selectedSetItem=$("#chargeSetItemBox").datagrid("getSelected");
        var dataRows=$("#chargeSetItemBox").datagrid("getRows");
        var selectedIndex=$("#chargeSetItemBox").datagrid("getRowIndex",selectedSetItem);
        var canMove=(direction==="up" && selectedIndex>0) || (direction==="down" && selectedIndex<dataRows.length-1);
        if(canMove){
            for(var i=0;i<dataRows.length;i++){
                var dataRow=dataRows[i];
                dataRow.SeqInfo=(10001+i);
            }
            for(var i=0;i<dataRows.length;i++){
                var dataRow=dataRows[i];
                if(dataRow===selectedSetItem){
                    var seqInfo=dataRow.SeqInfo;
                    if(direction==="up"){
                        var preDataRow=dataRows[i-1];
                        dataRow.SeqInfo=preDataRow.SeqInfo;
                        preDataRow.SeqInfo=seqInfo;
                    }else{
                        var postDataRow=dataRows[i+1];
                        dataRow.SeqInfo=postDataRow.SeqInfo;
                        postDataRow.SeqInfo=seqInfo;
                    }
                }
            }
            var dataList=[];
            for(var i=0;i<dataRows.length;i++){
                var dataRow=dataRows[i];
                dataList.push({
                    RowId:dataRow.RowId,
                    ClassName:ANCLS.Config.ChargeSetItem,
                    Seq:dataRow.SeqInfo
                });
            }
            dhccl.saveDatas(ANCSP.DataListService,{
                jsonData:dhccl.formatObjects(dataList)
            },function(data){
                $("#chargeSetItemBox").datagrid("reload");
                if(direction==="up"){
                    latestSelectedSetItem=selectedIndex-1;
                }else{
                    latestSelectedSetItem=selectedIndex+1;
                }
            });
        }
    }
}

$(document).ready(function(){
    initChargeSet();
    initChargeSetItem();
});