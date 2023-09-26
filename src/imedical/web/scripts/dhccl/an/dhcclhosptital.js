//2018
var editIndex;
$(function(){
	    $("#HospitalData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        iconCls:'icon-paper',
        bodyCls:'panel-body-gray',
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCCLHospital",
            QueryName:"FindHospital"
        },
        onBeforeLoad: function(param) {
	        param.code="";
	        param.name="";
        },
        columns:[
            [
               {field: "RowId", title: "RowId", width: 60, sortable: true },
               {field: "Code", title: "代码", width: 60, sortable: true,editor:{
                        type:'validatebox',
                        options:{
                            required:true
                        }
                    }
                },
               {field: "Name", title: "描述", width: 60, sortable: true,editor:{
                        type:'validatebox',
                        options:{
                            required:true
                        }
                    }
                }
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'新增',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'编辑',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-save',
			    text:'保存',
			    handler: function(){
                    saveRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'删除',
			    handler: function(){
                    deleteRow();
                }
            }
        ]
    });
});

function endEditing(){
    if(editIndex==undefined) {return true;}
    if($("#HospitalData").datagrid('validateRow',editIndex)){
        $("#HospitalData").datagrid('endEdit',editIndex);
        editIndex==undefined;
        return true;
    }else{
        return false;
    }
}

function appendRow(){
    if(endEditing()){
        console.log($("#HospitalData").datagrid('options'));
        var paginationObj=$("#HospitalData").datagrid('getPager').data("pagination" ).options;
        var lastPageNumber=parseInt(paginationObj.total/paginationObj.pageSize);
        if(paginationObj.total%paginationObj.pageSize!=0)
        {
            lastPageNumber+=1;
        }
        $("#HospitalData").datagrid('getPager').pagination("refresh",{pageNumber:lastPageNumber});
        $('#HospitalData').datagrid('gotoPage', {
            page: lastPageNumber,
            callback: function(page){
                $("#HospitalData").datagrid('appendRow',{});
                editIndex= $("#HospitalData").datagrid('getRows').length-1;
                $("#HospitalData").datagrid("selectRow",editIndex).datagrid('beginEdit',editIndex);
            }
        })
        
        
       
    }
}
function editRow(){
    var selectRow=$("#HospitalData").datagrid('getSelected');
    if(selectRow)
    {
        editIndex=$("#HospitalData").datagrid('getRowIndex',selectRow);
        $("#HospitalData").datagrid("selectRow",editIndex).datagrid('beginEdit',editIndex);
    }else{
        $.messager.alert("提示","请先选择要修改的行！","warning")
    }
}
function saveRow(){
    if (endEditing()&&(editIndex!=undefined)){
        editIndex==undefined;
        $('#HospitalData').datagrid('acceptChanges');
        var selectRow=$("#HospitalData").datagrid('getSelected');
        saveHospInfo(selectRow.RowId,selectRow.Code,selectRow.Name);
    }
}
function deleteRow(){
    var validateRow=$("#HospitalData").datagrid('validateRow',editIndex);
    if(validateRow)
    {
        var selectRow=$("#HospitalData").datagrid('getSelected');
        if(selectRow)
        {
           	    var result=$.m({
        	ClassName:"web.DHCCLHospital",
        	MethodName:"DeleteHospital",
        	rowId:selectRow.RowId
   			 },false);

            if(result==0)
            {
                $("#HospitalData").datagrid('reload');
            }else{
                $.messager.alert("错误","错误代码："+result,"error");
            }
        }else{
            $.messager.alert("提示","提示请选择要删除的行！","warning");
        }
    }else{
        $("#HospitalData").datagrid('deleteRow',editIndex);
    }
}

function saveHospInfo(rowId,code,desc)
{
    var result;
    if(rowId==undefined||rowId=="")
    {
        result=$.m({
            ClassName:"web.DHCCLHospital",
            MethodName:"InsertHospital",
            code:code,
            name:desc
        },false)
    }else{
        result=$.m({
            ClassName:"web.DHCCLHospital",
            MethodName:"UpdateHospital",
            rowId:rowId,
            code:code,
            name:desc
        },false)
    }
    if(result==0)
    {
       $("#HospitalData").datagrid('reload');
    }else{
         $.messager.alert("错误","错误代码："+result,"error");
    }
}

$.extend($.fn.datagrid.methods, {    
    gotoPage:function(jq,_208)
    {
        return jq.each(function(){
            var _209=this;
            var page,cb;
            if(typeof _208=="object"){
                page=_208.page;
                cb=_208.callback;
            }else{
                page=_208;
            }
            $(_209).datagrid("options").pageNumber=page;
            $(_209).datagrid("getPager").pagination("refresh",{pageNumber:page});
            _bf(_209,null,function(){
                if(cb){
                    cb.call(_209,page);
                }
            });
        });
    }
});
function _bf(_1a9,_1aa,cb){
var opts=$.data(_1a9,"datagrid").options;
if(_1aa){
opts.queryParams=_1aa;
}
var _1ab=$.extend({},opts.queryParams);
if(opts.pagination){
$.extend(_1ab,{page:opts.pageNumber||1,rows:opts.pageSize});
}
if(opts.sortName){
$.extend(_1ab,{sort:opts.sortName,order:opts.sortOrder});
}
if(opts.onBeforeLoad.call(_1a9,_1ab)==false){
return;
}
$(_1a9).datagrid("loading");
var _1ac=opts.loader.call(_1a9,_1ab,function(data){
$(_1a9).datagrid("loaded");
$(_1a9).datagrid("loadData",data);
if(cb){
cb();
}
},function(){
$(_1a9).datagrid("loaded");
opts.onLoadError.apply(_1a9,arguments);
});
if(_1ac==false){
$(_1a9).datagrid("loaded");
}
};

