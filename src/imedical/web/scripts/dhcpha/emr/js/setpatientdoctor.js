$(function(){
	getDoctor("practice","PRACTICE");
	getDoctor("resident","resident");
	getDoctor("attending","attending");
	getDoctor("chief","chief");
	initPatientDoctor();
});

function getDoctor(ctrName,carPrvTp)
{
	$("#"+ctrName).combogrid({  
		url: "../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLPatientDoctor&Method=GetDoctors&p1="+userLoc+"&p2=&p3="+carPrvTp,		
	    idField:'userId',  
	    textField:'userName',
	    fitColumns: true,
	    columns:[[  
	        {field:'userCode',title:'代码',width:100},  
	        {field:'userName',title:'名称',width:220}  
		 ]],
	    keyHandler:{
			up: function() {
			    //取得选中行
                var selected = $("#"+ctrName).combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $("#"+ctrName).combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $("#"+ctrName).combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $("#"+ctrName).combogrid('grid').datagrid('getRows');
                    $("#"+ctrName).combogrid('grid').datagrid('selectRow', rows.length - 1);
                }	
			},
			down: function() {
              //取得选中行
                var selected = $("#"+ctrName).combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $("#"+ctrName).combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $("#"+ctrName).combogrid('grid').datagrid('getData').rows.length - 1) 
                    {
                        $("#"+ctrName).combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } 
                else 
                {
                    $("#"+ctrName).combogrid('grid').datagrid('selectRow', 0);
                }				
			},
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $("#"+ctrName).combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$("#"+ctrName).combogrid("options").value=selected.userId;
			    }
                //选中后让下拉表格消失
                $("#"+ctrName).combogrid('hidePanel');
				$("#"+ctrName).focus();
            }, 
			query: function(q) {
 	            //动态搜索
	            $("#"+ctrName).combogrid("grid").datagrid("reload", {'p1':userLoc,'p2':q,'p3':carPrvTp});
	            //$("#"+ctrName).combogrid("setValue", q);
	        }
	    }
	});
}

function initPatientDoctor()
{
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPatientDoctor",
			"Method":"GetCurrentPatientDoctor",			
			"p1":episodeID
		},
		success: function(d){
			if (d == null) return;
			$('#practice').combogrid('setValue', d[0].practiceId);
			$('#resident').combogrid('setValue', d[0].residentId);
			$('#attending').combogrid('setValue', d[0].attendingId);
			$('#chief').combogrid('setValue', d[0].chiefId);
		},
		error: function(d){alert("error");}
	});
}

$("#btsure").click(function(){
	var practiceId = $('#practice').combogrid('getValue');
	var residentId = $('#resident').combogrid('getValue');
	var attendingId = $('#attending').combogrid('getValue');
	var chiefId = $('#chief').combogrid('getValue');
	if ((practiceId == "")&&(residentId == "")&&(attendingId == "")&&(chiefId == ""))
	{
		alert("请设置患者医师");
		return;
	}
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPatientDoctor",
			"Method":"SetPatientDoctor",
			"p1":episodeID,		
			"p2":userID,
			"p3":userLoc,
			"p4":practiceId,
			"p5":residentId,
			"p6":attendingId,
			"p7":chiefId
		},
		success: function(d){

			if (d == "1")
			{
				alert("保存成功");
				CloseWindow();
			}
			else
			{
				alert("保存失败");
			}
			 
		},
		error: function(d){alert("error");}
	});
});


$("#btclose").click(function(){
	CloseWindow();
});

//关闭窗口
function CloseWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}