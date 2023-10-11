///add by ZY   2826780  20220926
///hisui改造 add by zc 2018-09-30  jQuery台帐页面hisui改造
/*
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
*/
var selectItems = new Array();

var PAAuthorizer=getElementValue("PAAuthorizer");
var PAAuthorized=getElementValue("PAAuthorized");
var PMSourceType=getElementValue("PMSourceType");
var PMSourceID=getElementValue("PMSourceID");
$(function(){
    initDocument();
});
function initDocument(){
    initUserInfo();
    initMessage("InStock"); //获取所有业务消息
    initButton();
    initButtonWidth();
    $HUI.datagrid("#tDHCEQProductMap",{
        url:$URL,
        queryParams:{
                ClassName:"web.DHCEQ.Plat.CTProduct",
                QueryName:"GetProductMap",
                PAAuthorizer:PAAuthorizer,
                PAAuthorized:PAAuthorized,
                SourceType:PMSourceType,
                SourceID:PMSourceID,
                Desc:""
        },
        rownumbers: true,  //如果为true，则显示一个行号列。
        singleSelect:false,
        fit:true,
        border:false,
        //striped : true,
        //cache: false,
        //fitColumns:true,
        columns:[[
                /*
                {field:'checked',checkbox:'true',formatter:function(value,row,index){ 
                if(row.checked){
                    return '<input type="checkbox" name="DataGridCheckbox" checked="checked">'; 
                }
                else{
                    return '<input type="checkbox" name="DataGridCheckbox">'; 
                }
                }},
                */
                {field:'PARowID',hidden:true},
                {field:'PRowID',hidden:true},
                {field:'PDesc',title:'产品',width:200,align:'left'},
                {field:'PModels',title:'型号',width:150,align:'left'},
                {field:'PSpecs',title:'规格',hidden:true}
            ]],
        //PARowID,PRowID,PDesc,PModels,PSpecs
        //onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);},
        onClickRow:function(rowIndex,rowData){addselectItem(rowIndex,rowData);},
        pagination:true,
        pageSize:25,
        pageNumber:1,
        pageList:[25,50,75,100]
    });
};

function BSave_Clicked()
{
    var SelectRowIDs=""
    var rows = $('#tDHCEQProductMap').datagrid('getRows');
    var rows = $('#tDHCEQProductMap').datagrid('getChecked');
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        if(oneRow.checked)
        //if (oneRow.Opt=="Y")
        {
            SelectRowIDs=SelectRowIDs+","+oneRow.PARowID+","+oneRow.PRowID
        }
        var names = [];
        $.each(checkedItems, function(index, item){
            names.push(item.productname);
        });                
        console.log(names.join(","));
    }
    if (SelectRowIDs=="")
    {
        messageShow("","","","请先选择需要保存的记录");
        return
    }
    return
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SaveProductMapList",datalist);
    jsonData=JSON.parse(jsonData)
    
    if (jsonData.SQLCODE==0)
    {
        messageShow("","","","操作成功!");
        websys_showModal("options").mth();
        findServiceItem()
    }
    else
    {
        messageShow("","","","错误信息:"+jsonData.Data);
        return
    }
}


function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#tDHCEQEquipList').datagrid('selectRecord', selectItems[i]); //根据id选中行 
        }
}

//将选中记录的ID是存储checkedItems这个数组里
function addselectItem(rowIndex, rowData) {
        //var row = jQuery('#tDHCEQEquipList').datagrid('getSelections');
        var rowid=rowData.PRowID;
        /// modefied by by zc 2017-06-25 ZC0031 begin
        var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowid,'','','Y');
        var ret=res.split("^");
        if (ret[0]!="0")
        {
            $.messager.popover({msg:ret[1],type:'alert'});
            $('#tDHCEQEquipList').datagrid('unselectRow', rowIndex);
        }
        // modfied by ZY0306 20220711  台帐选择行存值到数组中
        else
        {
            var findindex=findSelectItem(rowid)
            if (findindex == -1) {
                    selectItems.push(rowid);
                }
            else
            {
                selectItems.splice(findindex, 1);
            }
        }
}

//判断选中记录的ID是否已存在checkedItems这个数组里
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
