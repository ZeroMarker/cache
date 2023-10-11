var init = function () {
    initCondition();
    initEvent();
}
$(init)
/*-----------------------------------------------------------------------------*/
function initCondition() {
    $('#bedTypeBox').combobox({
        url: $URL + "?1=1&ClassName=Nur.CommonInterface.Bed&QueryName=bedType&ResultSetType=array",
        valueField: 'ID',
        textField: 'BedType',
        defaultFilter: 4,
        onLoadSuccess: function () {
            var array = $(this).combobox("getData");
            for (var item in array[0]) {
                if (item == "ID") {
                    $(this).combobox('select', array[0][item]);
                    break;
                }
            }            
            initTempBedGrid();
        }
    });
}
function initEvent(){
    $("#findTempBedBtn").click(reloadTempBedGrid);
}

function initTempBedGrid() {
    var wardID = session['LOGON.WARDID'];
    var bedType = $('#bedTypeBox').combobox('getValue');
    var bedState = $('#bedStateBox').combobox('getValue');
    $('#tempBedGrid').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.CommonInterface.Bed',
            QueryName: 'FindTempBed',
            WardID: wardID,
            BedType: bedType,
            BedState:bedState
        },
        columns: [[
            { field: 'BedCode', title: '床号', width: 100 },
            { field: 'BedSexDesc', title: '床位性别', width: 100 },
            { field: 'BedTypeDesc', title: '床位类型', width: 100 },
            { field: 'BedBill', title: '床位费', width: 100, align: 'right' },
            { field: 'BEDRcDesc', title: '状态', width: 100},
            { field: 'BedOper', title: '操作', width: 100,formatter:bedGridRowOper}
        ]],        
        singleSelect:true,
        headerCls:'panel-header-gray',
        pagination:true,
        toolbar:'#custtb'
    });
}

function bedGridRowOper(val, row, index) {    
    var btns="";
    if(row.BEDRcDesc=="未添加"){
        btns = '<a href="#"class="hisui-linkbutton hover-dark" onclick="addBedBtnClick(\'' + String(row.BedId)+ '\',\'' +'Y' + '\')">加床</a>';
    }else if(row.BEDRcDesc=="已添加"){
        btns = '<a href="#"class="hisui-linkbutton hover-dark" onclick="addBedBtnClick(\'' + String(row.BedId)+ '\',\'' +'N' + '\')">删除</a>';
    }
    return btns;
}

function addBedBtnClick(bedID,flag){
    $cm({
        ClassName:'Nur.CommonInterface.Bed',
        MethodName:'activateOperBed',
        bedID:bedID,
        activeFlag:flag
    },function(textData){
        if(textData==0){
            $.messager.popover({msg:'操作成功!',type:'success'});
            reloadTempBedGrid();
        }
        else{
            $.messager.popover({msg:textData,type:'error'});
        }
    })
    
}

function reloadTempBedGrid() {
    var wardID = session['LOGON.WARDID'];
    var bedType = $('#bedTypeBox').combobox('getValue');
    var bedState = $('#bedStateBox').combobox('getValue');
    $('#tempBedGrid').datagrid('load', {
        ClassName: 'Nur.CommonInterface.Bed',
        QueryName: 'FindTempBed',
        WardID: wardID,
        BedType: bedType,
        BedState: bedState
    });
}