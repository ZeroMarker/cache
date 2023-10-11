/**
 * @description:
 * @author: ouzilin
 * @date: 2020-07-02 18:30:52
*/
var GV = {
    editRow: undefined,
	tableName: "Nur_IP_Quality.AuditPageColumn"
}

$(function() {
    initUI()
})
/**
* @description: ��ʼ��
*/
function initUI(){
	
	if (IsManyHosps == 1) //��Ժ��ҵ��
    {
        //��ʼ��ҽԺ
        //var hospComp = GenUserHospComp();
        var sessionStr = [session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']]
        var hospComp = GenHospComp(GV.tableName, sessionStr.join("^"))
	    hospComp.jdata.options.onSelect = function(e,t){
			
			 var queryParams = $('#auditPageColumnTable').datagrid('options').queryParams
    		queryParams.HospId = getHospId()
    		$('#auditPageColumnTable').datagrid('options').queryParams = queryParams;
    		$('#auditPageColumnTable').datagrid('load');

        }
        hospComp.jdata.options.onLoadSuccess= function(data){
		    
	    }
    }

    initAuditPageColumnTable()  //��ʼ�������б�
}
/**
* @description: �����б�
*/
function initAuditPageColumnTable()
{
    var columnArray = $cm({
        ClassName:"Nur.Quality.Service.AuditPageColumn",
		MethodName:"getAllPageColumns",
    },false)

    var alignArray = [
        {id:"left",text:"����"},
        {id:"right",text:"����"},
        {id:"center",text:"����"},
    ]

    $('#auditPageColumnTable').datagrid({
        url: $URL,
        queryParams:{
             ClassName: 'Nur.Quality.Service.AuditPageColumn',
             QueryName: 'getPageColumnList',
             HospId: getHospId()
        },
        method: 'post',
        rownumbers : true,
        loadMsg: '����װ����......',
        striped: true,
        fitColumns: false,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            { field: 'columnCode', title: '����', width: 200,   
            formatter:function(value){
                for(var index in columnArray)
                {
                    if (columnArray[index].key == value){
                        return columnArray[index].description
                    }
                }
                return value
            },
            editor:{
                type:'combobox',
                options:{
                    valueField : 'key',
                    textField :'description',
                    data : columnArray,
                    required : true,
                    onSelect: function(newValue, oldValue){
                        var editor=$("#auditPageColumnTable").datagrid("getEditor",{index:GV.editRow,field:'columnName'})
                        $(editor.target).val(newValue.description)
                    }
                }
            }},
            { field: 'columnName', title: '����', width: 200,  editor:"text"},
            { field: 'columnWidth', title: '���', width: 200, editor:"numberbox"},
            { field: 'columnAlign', title: 'λ��', width: 200,
            formatter:function(value){
                for(var index in alignArray)
                {
                    if (alignArray[index].id == value){
                        return alignArray[index].text
                    }
                }
                return value
            },
            editor:{
                type:'combobox',
                options:{
                    valueField : 'id',
                    textField :'text',
                    data : alignArray,
                    required : true
                }
            }
            },
            { field: 'handler', title: '����', width: 200, align:"center" ,formatter:showHandler },
        ]],
        toolbar: [{
            iconCls: 'icon-add',
            text: '�½�',
            handler: function() {
                $('#auditPageColumnTable').datagrid("rejectChanges");
                $('#auditPageColumnTable').datagrid("unselectAll");
                var rowsLength = $('#auditPageColumnTable').datagrid("getRows").length
                $('#auditPageColumnTable').datagrid("insertRow", {
                    index: rowsLength,
                    row: {}
                });
                $('#auditPageColumnTable').datagrid("beginEdit",rowsLength);
                $('#auditPageColumnTable').datagrid("selectRow",rowsLength);
                GV.editRow=rowsLength;
            }
            },{
            iconCls: 'icon-up',
            text: '����',
            handler: function() {
                wardItemHandler("up")
            }
            },{
                iconCls: 'icon-down',
                text: '����',
                handler: function() {
                    wardItemHandler("down")
                }
            },{
                iconCls: 'icon-save',
                text: '����',
                handler: function() {
                    save("save")
                }
            }
        ],
        onDblClickRow: function(rowIndex, rowData){
            $('#auditPageColumnTable').datagrid("rejectChanges");
            $('#auditPageColumnTable').datagrid("unselectAll");
            $('#auditPageColumnTable').datagrid("beginEdit", rowIndex);
            $('#auditPageColumnTable').datagrid("selectRow",rowIndex);
            GV.editRow=rowIndex;
        },
    })
}

/**
* @description:���水ť
*/
function save(type){
    var editors = $('#auditPageColumnTable').datagrid('getEditors', GV.editRow);
    if (editors.length !=0 ){
	    $('#auditPageColumnTable').datagrid('endEdit', GV.editRow);
	    var curRows=$('#auditPageColumnTable').datagrid('getRows')
	    debugger
	    if (!((curRows[GV.editRow].columnCode)&&(curRows[GV.editRow].columnAlign))){
		    $.messager.popover({msg: '��δ���',type:'error',timeout: 1000});
		    $('#auditPageColumnTable').datagrid('beginEdit', GV.editRow);
		    return
		}
    // $.messager.popover({msg: '�����ɹ�!',type:'error',timeout: 1000});
        //return false;
    } 
    var selectedRow=$('#auditPageColumnTable').datagrid("getSelected");
    if ((selectedRow == undefined)&&(type=="save"))
    {
	    $.messager.popover({msg: 'û��Ҫ��������ݣ�',type:'error',timeout: 1000});
        return
	}
    var data = []
   var rows = $('#auditPageColumnTable').datagrid("getRows");
   for (var index in rows){
        var curObj={}
        curObj.field = rows[index].columnCode
        curObj.title = rows[index].columnName
        curObj.width = rows[index].columnWidth
        curObj.align = rows[index].columnAlign
        data.push(curObj)
   }
   runClassMethod("Nur.Quality.Service.AuditPageColumn","save",
   {
        parameter1: JSON.stringify(data),
        parameter2: getHospId
   }
   ,function(data)
    {
        if (data=="0")
        {
            $.messager.popover({msg: '�����ɹ�!',type:'success',timeout: 1000});
            $('#auditPageColumnTable').datagrid("reload")

        }else{
	        $.messager.popover({msg: data.responseText,type:'success',timeout: 1000});
	    }
    })
}

/**
* @description: ���밴ť�Ĳ�������
*/
function importItemBtn(){
    var selectRecordList = $('#arcitmItemTable').datagrid("getSelections")
    var selectIDList = []
    for (var i in selectRecordList){
        selectIDList.push(selectRecordList[i]["arcItmID"])
        runClassMethod("","",{},function(data){
            if (data == "0"){
                $('#auditPageColumnTable').datagrid('reload')
            }
        })
    }
}
/**
* @description: ��ѯ��ť
*/
function searchBtn(){
    var queryParams = $('#arcitmItemTable').datagrid('options').queryParams
    queryParams.inputItem = $('#inputARCIMItem').val()
    $('#arcitmItemTable').datagrid('options').queryParams = queryParams;
    $('#arcitmItemTable').datagrid('load');
}

/**
 * 
 * �����������õ���Ŀ
 * @param {any} action ��Ϊ
 */
function wardItemHandler(action){
    var selectRow = $('#auditPageColumnTable').datagrid('getSelected')
    if (selectRow == null){
        $.messager.popover({msg: '��ѡ��һ����¼',type:'error',timeout: 1000});
        return
    }
    var rows=$('#auditPageColumnTable').datagrid('getRows');
    var rowlength=rows.length

    var rowIndex=$('#auditPageColumnTable').datagrid('getRowIndex',selectRow);
    if (action=="up")
    {
        if (rowIndex==0)
        {
            $.messager.popover({msg: '�����޷�����!',type:'error',timeout: 1000});
            return
        }
        $('#auditPageColumnTable').datagrid('deleteRow', rowIndex);//ɾ��һ��
        rowIndex--;
    }else if(action=="down"){
        if (rowIndex==rowlength-1)
        {
            $.messager.popover({msg: '�����޷�����!',type:'error',timeout: 1000});
            return
        }
        $('#auditPageColumnTable').datagrid('deleteRow', rowIndex);//ɾ��һ��
        rowIndex++;
    }
    $('#auditPageColumnTable').datagrid('insertRow', {
        index:rowIndex,
        row:selectRow
    });
    $('#auditPageColumnTable').datagrid('selectRow', rowIndex);

}

function showHandler(value, row, index){
    return  "<a onclick='deleteRow("+ index +")' class='icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
}
/**
* @description: ɾ����
*/
function deleteRow(rowIndex){
    delConfirm(function(){
        $('#auditPageColumnTable').datagrid('deleteRow', rowIndex)
        save("delete")
    })
}

function getHospId()
{
	return (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
}