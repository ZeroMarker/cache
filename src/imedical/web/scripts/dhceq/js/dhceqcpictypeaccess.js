//GR0033 extjs ͼƬ������Ȩ
//ͼƬ������Ȩ���沼�ִ���
//����csp��dhceq.process.pictypeaccess.csp
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#menudatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TAccess="N"
			else row.TAccess="Y"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#menudatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#menudatagrid').datagrid('selectRow',rowIndex)
			$('#menudatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
var CurrentSourceType=GetQueryString("CurrentSourceType")
var SourceType=GetQueryString("SourceType")

$(document).ready(function () {
	self.document.title =SourceType+"ҵ��ͼƬ������Ȩ"	//jquery����
var SelectedIndex=-1;
var preIndex=-1;
function menudatagrid_OnClickRow()
{
     var selected=$('#menudatagrid').datagrid('getSelected');
     if (selected)
     { 
     	SelectedIndex=$('#menudatagrid').datagrid('getRowIndex',  selected);
        if(preIndex!=SelectedIndex)
        {
             preIndex=SelectedIndex;
         }
         else
         {
             SelectedIndex = -1;
             preIndex=-1;
             $('#menudatagrid').datagrid('unselectAll')
         }
     }
}
/* jquery���ط���ʹ�Զ���check�ؼ����Բ�׽��
$.extend($.fn.datagrid.methods, {
getChecked: function (jq) {
var rr = [];
var rows = jq.datagrid('getRows');
jq.datagrid('getPanel').find('div.datagrid-cell input:checked').each(function () {
var index = $(this).parents('tr:first').attr('datagrid-row-index');
rr.push(rows[index]);
});
return rr;
}
});*/
$('#menudatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQ.Process.DHCEQCPicType",
        QueryName:"GetPicTypeAndAccess",
        Arg1:"",
        Arg2:CurrentSourceType,
        ArgCnt:2
    },
    border:'true',
    height:'100%',
    //layout:'fit',
    singleSelect:true,
    toolbar:[{
                text : "��ѯ",
                iconCls : "icon-search",
                handler : function() {
                    $('#menudatagrid').datagrid('load', {
        				ClassName:"web.DHCEQ.Process.DHCEQCPicType",
        				QueryName:"GetPicTypeAndAccess",
        				Arg1:$("#pictype").val(),
        				Arg2:CurrentSourceType,
        				ArgCnt:2
    				});
                }
            },{
                text : "����",
                iconCls : "icon-save",
                handler : function() {
                    var effectRow = new Object();
                    //IE�³��ְ�json����תΪjson�����ı��unicode�����⣬��󾭹��Ų飬������IE8����JSON.stringify()�����
                    var temp=$('#menudatagrid').datagrid('getRows')
                    effectRow["data"]=JSON.stringify(temp)
                    eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
                    $.post("dhceq.process.pictypeaccessaction.csp?&actiontype=updatepictypeaccess&CurrentSourceType="+CurrentSourceType, effectRow, function(text, status) {
                            if(status=="success"){
	                            //var temptext=JSON.parse(text)
	                            var temptext=eval('(' + text + ')'); //�ַ���תjson
                                $.messager.alert("��ʾ", temptext.result);
                                //$('#menudatagrid').datagrid('acceptChanges');
                                $('#menudatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                            $.messager.alert("��ʾ", "�ύ�����ˣ�");
                            $('#menudatagrid').datagrid('reload');
                        })
                }
            } ],
            
   
    columns:[[//����Ҫ������[,һ��ᱨ����
    	{field:'TCode',title:'ͼƬ���ʹ���',width:100,align:'center',editor : "validatebox",hidden:true},
        {field:'TDesc',title:'ͼƬ��������',width:100,align:'center',editor : "validatebox"},
    	{field:'TAccess',title:'��Ȩ',formatter:function(value,row,index){
			if(value=='N'){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" checked=true value="Y" >';
			}
			else{
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchange(this,'+index+')" value="N">';
			}
		}}       
    ]],
    
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    },
    pagination:true,
    pageSize:10,
    pageNumber:1,
    pageList:[10,20,30,40,50]   
});
}); 