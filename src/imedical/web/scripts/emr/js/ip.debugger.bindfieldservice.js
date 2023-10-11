var peraccPanelID=""

$(function(){
	
	$HUI.datagrid('#dgresult',{
		autoSizeColumn:true,
		fitColumns:true,
		idField:'id',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		fitColumns : true,
		title:'测试结果列表',
		titleNoWrap:false,
		nowrap:false,
		fontSize:12,
		lineHeight:12,
		columns:[[
			{field:'key',title:'输出字段',width:40},
			{field:'keydesc',title:'输出字段名称',width:80},
			{field:'value',title:'输出值',width:200}  /*列上设置字体大小*/
		]],
	})
	load();
	$("#dgresult").datagrid("resize");
})
function load()
{
	$.ajax({
		type : "GET", 
		dataType : "json",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.debugger.BL.BLDebuggerService",
				"Method":"GetBindQueryData"
			},
		success : function(d) {
	    	initList(d)
		},
		error : function(d) { 
			//alert("Debugger GetBindQueryData error");
			$.messager.popover({msg: "GetBindQueryData:"+d ,type:'alert'});
		}
	});	
}

function initList(data)
{
	for (i=0;i<data.length;i++)
	{
		var name = data[i].name
		var code = data[i].code
		var desc = data[i].description
		var parames = data[i].parames
		
		//console.log(itemPanelStyle)
		var panel = $('<div id="pnl'+code+'" class="hisui-panel" title="'+name+'" style="height:160px;width:260px;padding:5px;margin-bottom:10px" data-options="headerCls:\'panel-header-gray\'" onclick="focusDebuggerPanel(this.id,\''+parames+'\')">'+desc+'</div>')
		var button = $('<div id="btn'+code+'" class="hisui-linkbutton" style="float:right;" onclick="DebuggerInterface(\''+code+'\')">测试接口</div>')
		$(panel).append(button)
		$("#interfacelist").append(panel)
		

	}
	$.parser.parse();	
}
///激活状态panel
function focusDebuggerPanel(panelId,parames)
{
	//清空参数div
	cleanArgDiv();
	
	//初始化panel对应参数
	var paramesArray =parames.split(",")
		
	for(i=0;i<paramesArray.length;i++)
	{
		showArgDiv(i);
			
		var argdescprefix = paramesArray[i].split(":")[0]
		var argdesc = paramesArray[i].split(":")[1]
		$("#arg"+i+"descprefix").text(argdescprefix);
		$("#arg"+i+"desc").text("*"+argdesc);
		
	}
	
	if (peraccPanelID!=panelId)
	{
		$("#"+peraccPanelID).panel({
			headerCls:"panel-header-gray"
		})
		
		$("#"+panelId).panel({
			headerCls:"panel-header-acc"
		})
		peraccPanelID = panelId
		
	}

	
}
///接口返回值
function DebuggerInterface(InterfaceCode)
{	
	paramesValue = getParamesValue();
	
	$.ajax({
		type : "GET", 
		dataType : "json",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.debugger.BL.BLDebuggerService",
				"Method":"GetBindResultData",
				"p1":InterfaceCode,
				"p2":paramesValue
			},
		success : function(d) {
	    	initResult(d)
		},
		error : function(d) { 
			//alert("Debugger GetBindQueryData error");
			$.messager.popover({msg: "GetBindResultData:"+d ,type:'alert'});
		}
	});	
}

function getParamesValue()
{
	var paramesValueString=""
	for(i=0;i<6;i++)
	{
		if($("#arg"+i).val()==undefined) continue;
		
		value = $("#arg"+i).val()
		if (value=="") value="@"
		paramesValueString==""?paramesValueString=value:paramesValueString = paramesValueString+","+value
			

		
	}
	return paramesValueString;
}


function initResult(data)
{
	$("#dgresult").datagrid("loadData",data)

}


function showArgDiv(num)
{
	var argdiv=$('<div id="arg"'+num+'"div" style = "width:400px; height:30px; float:left; padding:10px"><div>');
	var argspan1 = $('<span id="arg'+num+'descprefix">参数1</span>:')
	var arginput = $('<input id="arg'+num+'" class="hisui-validatebox textbox"/>')
	var argspan2 = $('<span id="arg'+num+'desc">参数1说明信息</span>')
	
	$(argdiv).append(argspan1)
	$(argdiv).append(arginput)
	$(argdiv).append(argspan2)
	$("#arglayoutnorth").append(argdiv)
		
}

function cleanArgDiv()
{
	$("#arglayoutnorth").empty();
		
}
