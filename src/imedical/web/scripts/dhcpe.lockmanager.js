/**
* Description: 体检业务锁管理
* FileName: dhcpe.lockmanager.js
* Creator: wangguoying
* Date: 2021-12-21
*/

/** 服务对象 */
var _SrvObj = {
    className : "web.DHCPE.Lock"
}

function init() {
    init_element();
    init_event();
}

function init_event() {
    /** 查询 */
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

    /** 清屏 */
    $("#CleanBtn").on("click",function () {
        $("#BusType").combobox("setValue","");
        $("#BusID").val("");
        $("#ComputerIP").val("");
        $("#UserID").combogrid("setValue","");
    });
}

/**
* [绑定元素数据]  
* @Author wangguoying
* @Date 2021-12-21
*/
function  init_element() {
    /**业务类型 */
    $HUI.combobox("#BusType",{
        url:$URL+"?ClassName="+ _SrvObj.className +"&QueryName=QueryBusType&ResultSetType=array",
        valueField:'id',
        textField:'desc'
    });

    /**用户 */
    $HUI.combogrid("#UserID", {
        panelWidth: 480,
        url: $URL + "?ClassName=web.DHCPE.PreIADM&QueryName=UserList",
        mode: 'remote',
        delay: 200,
        idField: 'HIDDEN',
        textField: '姓名',
        onBeforeLoad: function(param) {
            param.Desc = param.q;
        },
        columns: [
            [
                { field: 'HIDDEN', hidden: true },
                { field: '工号', title: '工号', width: 100 },
                { field: '姓名', title: '姓名', width: 200 }
            ]
        ],
        pageSize: 20,
        fitColumns: true,
        pagination: true
    });

    /**列表 */
    $HUI.datagrid("#LockList",{
        url:$URL,
        queryParams:{
            ClassName:_SrvObj.className,
            QueryName:"QueryLock"
        },
        columns:[[
            {field:'TID',hidden:true},
            {field:'TOperation',width:60,title:'释放锁',align:'center',
                formatter : function (value, rowData, rowIndex) {
                    return "<a href='#' onclick='clean_lock(\""+rowData.TID+"\")'>\
					<img style='padding-top:4px;' title='释放' alt='释放' src='../scripts_lib/hisui-0.1.0/dist/css/icons/unlock.png' border=0/>\
					</a>";
                }
            },
            {field:'TBusDesc',width:100,title:'业务类型'},
            {field:'TBusId',width:100,title:'业务ID'},
            {field:'TComputerIP',width:100,title:'电脑IP'},
            {field:'TsessionId',width:100,title:'SessionID'},
            {field:'TLockUserName',width:100,title:'用户'},
            {field:'TLockLocDesc',width:100,title:'登录科室'},
            {field:'TLockDateTime',width:100,title:'锁定时间',
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
* [释放锁]
* @param    {[String]}    id    [DHC_PE_Lock]   
* @Author wangguoying
* @Date 2021-12-21
*/
function clean_lock(id) {
    $.messager.confirm("提示","确定释放该锁吗？",function(r){
        if(r){
            var ret = tkMakeServerCall("User.DHCPELock","Delete",id)
            if(parseInt(ret) == 0){
                $.messager.popover({type:"success",msg:"已释放"});
                $("#LockList").datagrid("reload");
            }else{
                $.messager.popover({type:"error",msg:ret.split("^")[1]}); 
            } 
        }
    }); 
}

$(init);