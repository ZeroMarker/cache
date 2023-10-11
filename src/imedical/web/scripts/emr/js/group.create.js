function getElementInfo()
{
    var result = {};
    $("#framEmrdoc").contents().find("#PageContent textarea,input").each(function(i){
	    var id = $(this).attr("id");
		result[id] = $(this).val();
    });
    return JSON.stringify(result);
}

$(function(){

	$("#cbox").combobox({  
		url:"../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLGroupCreate&Method=GetGroupCreateList",
		valueField:'ID',  
	    textField:'RecordDesc',
		onSelect:function(item){  
			$("#framEmrdoc").attr("src","websys.default.hisui.csp?WEBSYS.TCOMPONENT="+item.FormCode);
		}
	});

/*
$('#cbox').combogrid({  
    panelWidth:300,     
    idField:'ID',  
    textField:'RecordDesc',
    multiple:true,  
    url:'../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLGroupCreate&Method=GetGroupCreateList',  
    columns:[[  
    	{field:'ck',checkbox:true},
        {field:'RecordDesc',title:'病历名称',width:268}
    ]],
    onSelect:function(index,rowData){   
    	$("#framEmrdoc").attr("src","websys.default.hisui.csp?WEBSYS.TCOMPONENT="+rowData.FormCode);
    }
     
});	
*/
	
	//设置右对齐
$("#btCreate").click(function () {
     var result = getElementInfo(); 
     var id = $('#cbox').combobox('getValue');
     //var id = $('#cbox').combogrid('grid').datagrid('getSelected').ID;;
     var seleAdm = parent.GetSelPatAdm();
     var episodeIds = seleAdm.join(",");
     jQuery.ajax({
		type : "Post", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls", 
		async : true,
		data : {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLGroupCreate",
			"Method":"GroupCreate",
			"p1":episodeIds,
			"p2":userId,
			"p3":id,
			"p4":result,
			"p5":ipAddress
		},
		success : function(d) {
			if (d !== '1') 
			{
				$.messager.alert("提示信息", "保存失败", 'error');
			}
			else
			{
				$.messager.popover({msg: '保存成功！',type: 'success',timeout: 2000,showType: 'slide'});
			}
		}
	});	
});
});