/**
* Description: ���ҵ��������
* FileName: dhcpe.lockmanager.js
* Creator: wangguoying
* Date: 2021-12-21
*/

/** ������� */
var _SrvObj = {
    className : "web.DHCPE.Lock"
}

function init() {
    init_element();
    init_event();
}

function init_event() {
    /** ��ѯ */
    $("#SearchBtn").on("click",function () {
        $("#LockList").datagrid("load",{
            ClassName : _SrvObj.className,
            QueryName : "QueryLock",
            Type : $("#BusType").combobox("getValue"),
            BusID : $("#BusID").val(),
            ComputerIP : $("#ComputerIP").val(),
            UserID : $("#UserID").combogrid("getValue")
        })
    });

    /** ���� */
    $("#CleanBtn").on("click",function () {
        $("#BusType").combobox("setValue","");
        $("#BusID").val("");
        $("#ComputerIP").val("");
        $("#UserID").combogrid("setValue","");
    });
}

/**
* [��Ԫ������]  
* @Author wangguoying
* @Date 2021-12-21
*/
function  init_element() {
    /**ҵ������ */
    $HUI.combobox("#BusType",{
        url:$URL+"?ClassName="+ _SrvObj.className +"&QueryName=QueryBusType&ResultSetType=array",
        valueField:'id',
        textField:'desc'
    });

    /**�û� */
    $HUI.combogrid("#UserID", {
        panelWidth: 480,
        url: $URL + "?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
        mode: 'remote',
        delay: 200,
        idField: 'HIDDEN',
        textField: '����',
        onBeforeLoad: function(param) {
            param.Desc = param.q;
        },
        columns: [
            [
                { field: 'HIDDEN', hidden: true },
                { field: '����', title: '����', width: 100 },
                { field: '����', title: '����', width: 200 }
            ]
        ],
        pageSize: 20,
        fitColumns: true,
        pagination: true
    });

    /**�б� */
    $HUI.datagrid("#LockList",{
        url:$URL,
        queryParams:{
            ClassName:_SrvObj.className,
            QueryName:"QueryLock"
        },
        columns:[[
            {field:'TID',hidden:true},
            {field:'TOperation',width:60,title:'�ͷ���',align:'center',
                formatter : function (value, rowData, rowIndex) {
                    return "<a href='#' onclick='clean_lock(\""+rowData.TID+"\")'>\
					<img style='padding-top:4px;' title='�ͷ�' alt='�ͷ�' src='../scripts_lib/hisui-0.1.0/dist/css/icons/unlock.png' border=0/>\
					</a>";
                }
            },
            {field:'TBusDesc',width:100,title:'ҵ������'},
            {field:'TBusId',width:100,title:'ҵ��ID'},
            {field:'TComputerIP',width:100,title:'����IP'},
            {field:'TsessionId',width:100,title:'SessionID'},
            {field:'TLockUserName',width:100,title:'�û�'},
            {field:'TLockLocDesc',width:100,title:'��¼����'},
            {field:'TLockDateTime',width:100,title:'����ʱ��',
                formatter : function (value, rowData, rowIndex) {
                    return rowData.TLockDate + ' ' + rowData.TLockTime;
                }
            }
        ]],	
        fit : true,
        fitColumns : true,
        pagination : true,  
        rownumbers : true,  
        pageSize: 20,
        pageList : [20,100,200]
    });
}

/**
* [�ͷ���]
* @param    {[String]}    id    [DHC_PE_Lock]   
* @Author wangguoying
* @Date 2021-12-21
*/
function clean_lock(id) {
    $.messager.confirm("��ʾ","ȷ���ͷŸ�����",function(r){
        if(r){
            var ret = tkMakeServerCall("User.DHCPELock","Delete",id)
            if(parseInt(ret) == 0){
                $.messager.popover({type:"success",msg:"���ͷ�"});
                $("#LockList").datagrid("reload");
            }else{
                $.messager.popover({type:"error",msg:ret.split("^")[1]}); 
            } 
        }
    }); 
}

$(init);