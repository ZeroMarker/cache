//名称    DHCPEMoveTeam.hisui.js
//功能    转组
//创建    2023.02.17
//创建人  yupeng
$(function(){
     
    InitMoveTeamDataGrid();
    
       
})


function InitMoveTeamDataGrid()
{
    $HUI.datagrid("#MoveTeamGrid",{
        url:$URL,
        fit : true,
        border : false,
        striped : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  
        pageSize: 20,
        pageList : [20,100,200],
        
        queryParams:{
            ClassName:"web.DHCPE.PreGTeam",
            QueryName:"SearchPreGTeam",
            ParRef:ParRef
                
        },
        columns:[[
            {field:'PGT_RowId',title:'PGT_RowId',hidden: true},
            {field:'PGT_Desc',width:'150',title:'分组名称'},
            {field:'PGT_Sex_Desc',width:'130',title:'性别'},
            {field:'PGT_UpperLimit',width:'150',title:'年龄上限'},
            {field:'PGT_LowerLimit',width:'150',title:'年龄下限'},
            {field:'PGT_Married_Desc',width:'150',title:'婚姻状况'}            
        ]],
        onSelect: function (rowIndex, rowdata) {
        
        $.messager.confirm("确认", "是否确定转移到该组", function (r) {
        if (r) {
            
                var PGTeam = rowdata.PGT_RowId;
                var Sex = rowdata.PGT_Sex_Desc;
                var UpperLimit = rowdata.PGT_UpperLimit;
                var LowerLimit = rowdata.PGT_LowerLimit;

                var Married = rowdata.PGT_Married_Desc;

                var iParRef = ParRef;
                var iPIADMRowId = PIADMRowId;
                var iPGTeam = PGTeam;
                var string = Sex + "^" + Married + "^" + UpperLimit + "^" + LowerLimit;
               
                var MoveFlag = tkMakeServerCall("web.DHCPE.PreIADM", "IsAllSatisfyTeamInfo", iPIADMRowId, PGTeam, string)
                var MoveCanFlag = MoveFlag.split("^")
                if (MoveCanFlag[0] !== '0') {
                    $.messager.alert("提示", MoveCanFlag[1] + ",不能转组", "info");
                    return false;

                }


                iPIADMRowIdArr = iPIADMRowId.split("^");
                for (var i = 0; i < iPIADMRowIdArr.length; i++) {
                    iPIADMRowId = iPIADMRowIdArr[i];

                    var Ret = tkMakeServerCall("web.DHCPE.PreIADM", "MoveTeam", iPIADMRowId, PGTeam)

                    if ('0' == Ret) {
                        $.messager.popover({msg:"转组成功",type:"success"});
                    } else {
                        $.messager.popover({msg:Ret.split("^")[1],type:"error"}); 
                        return false;
                    }
                }
                
                opener.$("#TeamGrid").datagrid('load', { ClassName: "web.DHCPE.PreGTeam", QueryName: "SearchGTeam", ParRef: iParRef });

                opener.$("#TeamPersonGrid").datagrid('load', { ClassName: "web.DHCPE.PreIADM", QueryName: "SearchGTeamIADM", GTeam: iPGTeam, RegNo: "", Name: "", DepartName: "", OperType: "", Status: "" });




        }
    });
                    
        }
            
    })
}