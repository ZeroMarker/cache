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
            { field: 'BedCode', title: '����', width: 100 },
            { field: 'BedSexDesc', title: '��λ�Ա�', width: 100 },
            { field: 'BedTypeDesc', title: '��λ����', width: 100 },
            { field: 'BedBill', title: '��λ��', width: 100, align: 'right' },
            { field: 'BEDRcDesc', title: '״̬', width: 100},
            { field: 'BedOper', title: '����', width: 100,formatter:bedGridRowOper}
        ]],        
        singleSelect:true,
        headerCls:'panel-header-gray',
        pagination:true,
        toolbar:'#custtb'
    });
}

function bedGridRowOper(val, row, index) {    
    var btns="";
    if(row.BEDRcDesc=="δ���"){
        btns = '<a href="#"class="hisui-linkbutton hover-dark" onclick="addBedBtnClick(\'' + String(row.BedId)+ '\',\'' +'Y' + '\')">�Ӵ�</a>';
    }else if(row.BEDRcDesc=="�����"){
        btns = '<a href="#"class="hisui-linkbutton hover-dark" onclick="addBedBtnClick(\'' + String(row.BedId)+ '\',\'' +'N' + '\')">ɾ��</a>';
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
            $.messager.popover({msg:'�����ɹ�!',type:'success'});
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