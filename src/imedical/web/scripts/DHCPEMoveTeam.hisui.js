//����    DHCPEMoveTeam.hisui.js
//����    ת��
//����    2023.02.17
//������  yupeng
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
            {field:'PGT_Desc',width:'150',title:'��������'},
            {field:'PGT_Sex_Desc',width:'130',title:'�Ա�'},
            {field:'PGT_UpperLimit',width:'150',title:'��������'},
            {field:'PGT_LowerLimit',width:'150',title:'��������'},
            {field:'PGT_Married_Desc',width:'150',title:'����״��'}            
        ]],
        onSelect: function (rowIndex, rowdata) {
        
        $.messager.confirm("ȷ��", "�Ƿ�ȷ��ת�Ƶ�����", function (r) {
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
                    $.messager.alert("��ʾ", MoveCanFlag[1] + ",����ת��", "info");
                    return false;

                }


                iPIADMRowIdArr = iPIADMRowId.split("^");
                for (var i = 0; i < iPIADMRowIdArr.length; i++) {
                    iPIADMRowId = iPIADMRowIdArr[i];

                    var Ret = tkMakeServerCall("web.DHCPE.PreIADM", "MoveTeam", iPIADMRowId, PGTeam)

                    if ('0' == Ret) {
                        $.messager.popover({msg:"ת��ɹ�",type:"success"});
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