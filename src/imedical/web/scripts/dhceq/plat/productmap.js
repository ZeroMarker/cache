///add by ZY   2826780  20220926
///hisui���� add by zc 2018-09-30  jQuery̨��ҳ��hisui����
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
    initMessage("InStock"); //��ȡ����ҵ����Ϣ
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
        rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
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
                {field:'PDesc',title:'��Ʒ',width:200,align:'left'},
                {field:'PModels',title:'�ͺ�',width:150,align:'left'},
                {field:'PSpecs',title:'���',hidden:true}
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
        messageShow("","","","����ѡ����Ҫ����ļ�¼");
        return
    }
    return
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SaveProductMapList",datalist);
    jsonData=JSON.parse(jsonData)
    
    if (jsonData.SQLCODE==0)
    {
        messageShow("","","","�����ɹ�!");
        websys_showModal("options").mth();
        findServiceItem()
    }
    else
    {
        messageShow("","","","������Ϣ:"+jsonData.Data);
        return
    }
}


function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#tDHCEQEquipList').datagrid('selectRecord', selectItems[i]); //����idѡ���� 
        }
}

//��ѡ�м�¼��ID�Ǵ洢checkedItems���������
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
        // modfied by ZY0306 20220711  ̨��ѡ���д�ֵ��������
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

//�ж�ѡ�м�¼��ID�Ƿ��Ѵ���checkedItems���������
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
