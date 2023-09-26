//GR0033 extjs 图片类型授权
//图片类型授权界面布局代码
//关联csp：dhceq.process.pictypeaccess.csp
function checkchange(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#menudatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			if(TAccessCheckbox.checked==true) row.TAccess="N"
			else row.TAccess="Y"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#menudatagrid').datagrid('updateRow',{	//在表格与某个具体列绑定相同事件时，先响应具体列事件，但是执行updateRow方法将导致表格onclick事件失效
			index:rowIndex,
			row:row})
			$('#menudatagrid').datagrid('selectRow',rowIndex)
			$('#menudatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
var CurrentSourceType=GetQueryString("CurrentSourceType")
var SourceType=GetQueryString("SourceType")

$(document).ready(function () {
	self.document.title =SourceType+"业务图片类型授权"	//jquery加载
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
/* jquery重载方法使自定义check控件可以捕捉到
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
                text : "查询",
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
                text : "保存",
                iconCls : "icon-save",
                handler : function() {
                    var effectRow = new Object();
                    //IE下出现把json对象转为json串中文变成unicode的问题，最后经过排查，发现是IE8内置JSON.stringify()引起的
                    var temp=$('#menudatagrid').datagrid('getRows')
                    effectRow["data"]=JSON.stringify(temp)
                    eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
                    $.post("dhceq.process.pictypeaccessaction.csp?&actiontype=updatepictypeaccess&CurrentSourceType="+CurrentSourceType, effectRow, function(text, status) {
                            if(status=="success"){
	                            //var temptext=JSON.parse(text)
	                            var temptext=eval('(' + text + ')'); //字符串转json
                                $.messager.alert("提示", temptext.result);
                                //$('#menudatagrid').datagrid('acceptChanges');
                                $('#menudatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON返回类型需要设置Content-Type属性？
                            $.messager.alert("提示", "提交错误了！");
                            $('#menudatagrid').datagrid('reload');
                        })
                }
            } ],
            
   
    columns:[[//这里要用两层[,一层会报错？？
    	{field:'TCode',title:'图片类型代码',width:100,align:'center',editor : "validatebox",hidden:true},
        {field:'TDesc',title:'图片类型描述',width:100,align:'center',editor : "validatebox"},
    	{field:'TAccess',title:'授权',formatter:function(value,row,index){
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