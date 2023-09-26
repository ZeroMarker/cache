var g_diagnosetypes = new Array(); 
var g_refScheme,g_separate,g_schemetype,g_interpunction,g_memosep,g_infectionsource,g_hasCheck;
var obj = window.dialogArguments;
$(function(){	
	//obj = {"Url":{"name":"diagnosesLayer","type":"DIS,PRE","level":"Attending"}}; 
	//obj = {"Url":{"name":"diagnosesLayer","type":"PRE"}}
	//obj = {"Url":{"name":"diagnosesLayer","type":"M,M-3-XZZD,M-5-BCZD,M-4-SWZD","level":"Attending"}};
	if (obj.Url.type) 
	{
		g_diagnosetypes = obj.Url.type.split(",");
	}
	getScheme(obj)
	getOpDiagnoses();
	initDiagnoses();
	getDiagnoes();
	initICDList();
	initsyndrome();
	getDiagnoseType();
	getDiagnoseStatus();
	initHistoryDiagnoes();
	initModel();
	initModelDetail();	
	//加载完默认选中添加诊断框
	icdlistfocus();
	$("#iptpinyin").attr("checked",true);
	$("#iptfuzzymatch").attr("checked",true);
	initInfection();
	initPosition();
},0);

///取引用加载格式
function getScheme(operations)
{
	var name = "";
	if (operations.Url.name)
	{
		name = operations.Url.name;
	}
	else
	{
		name = operations.Url;
	}
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.HyperLink",
			"Method":"GetUnitScheme",
			"p1":name
		},
		success: function(d) {
			if (d == "") return;
			g_xml = convertToXml(d);
		},
		error : function(d) {alert(" error");}
	});		
}

function initInfection()
{
	g_infectionsource = $(g_xml).find("scheme>infectionsource").text();
    if (g_infectionsource != "his")
    {
	    $("#diagnoseReport").css("display","block");
		$("#diagnoseReport").click(function(){
			var InWardNum=tkMakeServerCall("web.DHCMRDiagnos","GetCRBLinkInfo",episodeID)
			try{
			 	var Link="C:\\YYYNGR\\HICS_crb.exe"+" "+InWardNum
			    new ActiveXObject("WScript.Shell").Run(Link); 
			}
			catch(e){
			    alert("请联系信息科在C盘目录安装对应院感程序!")
			}
		  }); 	    
	}
}

///初始化诊断字典
function initICDList()
{
	$("#icdlist").combogrid({  
		panelWidth:500,
		panelHeight:200,
		url: "../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLMRDiagnose&Method=GetICDDX",		
	    idField:'Id',  
	    textField:'Desc',
	    fitColumns: true,
	    columns:[[  
	        {field:'Desc',title:'描述',width:400,sortable:true},  
	        {field:'Code',title:'代码',width:120,sortable:true}  
		 ]],
	    keyHandler:{
			up: function() {
			    //取得选中行
                var selected = $('#icdlist').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#icdlist').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $('#icdlist').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $('#icdlist').combogrid('grid').datagrid('getRows');
                    $('#icdlist').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }	
			},
			down: function() {
              //取得选中行
                var selected = $('#icdlist').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#icdlist').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#icdlist').combogrid('grid').datagrid('getData').rows.length - 1) 
                    {
                        $('#icdlist').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } 
                else 
                {
                    $('#icdlist').combogrid('grid').datagrid('selectRow', 0);
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
                var selected = $('#icdlist').combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$('#icdlist').combogrid("options").value = selected.Id;
			    }
                //选中后让下拉表格消失
                $('#icdlist').combogrid('hidePanel');
				$("#icdlist").focus();
            }, 
			query: function(q) {
				var diagnoscat = $('#diagnoscat option:selected').val();
                var picd = $('#iptpicd')[0].checked;
                var cicd = $('#iptcicd')[0].checked;
                var icdtype = "";
                if (diagnoscat == "0")
                {
	                icdtype = "0";
	            }
	            else if(picd)
	            {
		            icdtype = "1";
		        }
		        else
		        {
			        icdtype ="2";
			    }
                var match = "";
                var condition = "";
                if ($('#iptcode')[0].checked)
                {
	                condition = "Code";
	            }
	            else if($('#iptname')[0].checked)
	            {
		            condition = "Desc";
		        }
		        else
		        {
			        condition = "ALIAS";
			    }
			    if ($('#iptleftmatch')[0].checked)
			    {
				    match = "1";
				}
				else
				{
					match = "0";
				}
 	            //动态搜索
	            $('#icdlist').combogrid("grid").datagrid("reload", {'p1':q,'p2':icdtype,'p3':match,'p4':condition});
	            $('#icdlist').combogrid("setValue", q);
	        }
	    }
	});
	$("#icdlist").combogrid('textbox').keydown(function(e)
	{
		if (e.keyCode == 13)
		{
			if ($('#diagnoscat option:selected').val()==0)
			{
				memofocus();
			}
			else
			{
				syndromefocus();
			}
		}
	});	
}


$('#memo').keydown(function(e){
	if(e.keyCode == 13)
	{
		$('#addDiagnose').focus();
	}
})

///初始化诊断字典
function initsyndrome()
{
	$("#syndromelist").combogrid({  
		panelWidth:500,
		panelHeight:200,
		url: "../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLMRDiagnose&Method=GetICDDX",		
	    idField:'Id',  
	    textField:'Desc',
	    fitColumns: true,
	    selectOnFocus: true, 
		changetextField: true,
	    columns:[[  
	        {field:'Desc',title:'描述',width:400,sortable:true},  
	        {field:'Code',title:'代码',width:120,sortable:true}  
		 ]],
	    keyHandler:{
			up: function() {
			    //取得选中行
                var selected = $('#syndromelist').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#syndromelist').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $('#syndromelist').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $('#syndromelist').combogrid('grid').datagrid('getRows');
                    $('#syndromelist').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }	
			},
			down: function() {
              //取得选中行
                var selected = $('#syndromelist').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#syndromelist').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#syndromelist').combogrid('grid').datagrid('getData').rows.length - 1) 
                    {
                        $('#syndromelist').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } 
                else 
                {
                    $('#syndromelist').combogrid('grid').datagrid('selectRow', 0);
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
                var selected = $('#syndromelist').combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$('#syndromelist').combogrid("options").value = selected.Id;
			    }
                //选中后让下拉表格消失
                $('#syndromelist').combogrid('hidePanel');
				$("#syndromelist").focus();
            }, 
			query: function(q) {
                var icdtype = "2";
                var match = "";
                var condition = "";
                if ($('#iptcode')[0].checked)
                {
	                condition = "Code";
	            }
	            else if($('#iptname')[0].checked)
	            {
		            condition = "Desc";
		        }
		        else
		        {
			        condition = "ALIAS";
			    }
			    if ($('#iptleftmatch')[0].checked)
			    {
				    match = "1";
				}
				else
				{
					match = "0";
				}
 	            //动态搜索
	            $('#syndromelist').combogrid("grid").datagrid("reload", {'p1':q,'p2':icdtype,'p3':match,'p4':condition});
	            $('#syndromelist').combogrid("setValue", q);
	        }
	    }
	});
	$("#syndromelist").combogrid('textbox').keydown(function(e)
	{
		if (e.keyCode == 13)
		{
			memofocus();
		}
	});	
}


///门诊诊断
function getOpDiagnoses()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"GetOPDiagnos",
			"p1":episodeID
		},
		success: function(d) {
			if (d == "") return;
			var tmpd = d.split("^");
			$("#opdignos").innerHTML(tmpd[2]);
			
		},
		error : function(d) { alert(" error");}
	});		
}

///初始化诊断
function initDiagnoses()
{
	g_hasCheck = $(g_xml).find("scheme>hascheck").text();
	var checkbox = g_hasCheck == "1"?true:false;
	$('#diagnoses').treegrid({    
 		fit:true,
		rownumbers: true,
		lines:true,
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    idField: 'ID',
        treeField: 'ICDDesc',
        checkbox:checkbox,
	    columns:getColumnScheme(g_xml,"scheme>show>item","0")
	});	
}

//加载诊断数据
function getDiagnoes()
{
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"GetDiagnos",
			"p1":episodeID
		},
		success: function(d) {
			if (d == "") return;
			$('#diagnoses').treegrid("loadData",d);
		},
		error : function(textStatus, errorThrown) { alert(" error"+textStatus);}
	});		
}

///历史诊断
function initHistoryDiagnoes()
{
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"GetHistoryDiagnose",
			"p1":patientID
		},
		success: function(d) {
			if (d == "") return;
			$('#historydiagnoses').datagrid({   
				data:d, 
				singleSelect:true,
			    columns:[[ 
					{title:'描述',field:'Desc'},					
			    	{title:'医生',field:'DoctDesc'},  
					{title:'日期',field:'MRDate'}  
			    ]]  
			});
		},
		error : function(d) { alert(" error");}
	});
}


///初始化个人模板组
function initModel()
{
	$('#modelgroup').datalist({
		url: '../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLMRDiagnose&Method=GetModleGroups&p1='+userID,    
		lines: true,
		fit:true,
		title: "模板组",
		valueField: "Id",
		textField: "Desc",
		onClickRow: function(index,row)
		{
			$('#modeldetial').datagrid('load',{
				p1: row.Id
			});
		},
		onLoadSuccess: function(data){
			if (data.total >0)
			{
				$('#modeldetial').datagrid('load',{
					p1: data.rows[0].Id
				});
			}
		}
	});
}
///初始化个人模版组明细
function initModelDetail(groupId)
{
	$('#modeldetial').datalist({
		url: '../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLMRDiagnose&Method=GetDiagnoseDetail&p1='+groupId,    
		lines: true,
		fit:true,
		title: "模板明细",
		valueField: "ICDId",
		textField: "ICDDesc",
		onClickRow: function(index,row)
		{
			addDiagnoses(row.ICDId,row.ICDDesc,"","","1","","");
		    getDiagnoes();
			clearInputDiagnos();	
		}
	});	
}

function initPosition()
{
	$('#position').combobox({  
	    url:'../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLMRDiagnose&Method=GetPosition',  
	    valueField:'RowId',  
	    textField:'Desc'  
	}); 	
}

///加载诊断类型
function getDiagnoseType()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"GetDiagnoseType"
		},
		success: function(d) {
			if (d == "") return;
			var data = eval("("+d+")");
			for (var i=0;i<data.length;i++)
			{
				if (g_diagnosetypes.length>0 && $.inArray(data[i].Code, g_diagnosetypes)< 0) continue; 
				var redio = '<input type="radio" id="'+data[i].Id+'" name="diagnosetype">'+data[i].Desc+'</input>';
				$("#diagnosetype").append(redio);
			}
			$("input[name='diagnosetype']").get(0).checked=true; 
			setDiagnosetypeList(data);
		},
		error : function(d) { alert(" error");}
	});		
}

function setDiagnosetypeList(data)
{
	var sele = "";
	for (var i=0;i<data.length;i++)
	{
		sele = sele + '<option value ="'+data[i].Id+'">'+data[i].Desc+'</option>';
	}
	$("#seleFromType").append(sele);
}

///加载诊断状态
function getDiagnoseStatus()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"GetDiagnoseStatus"
		},
		success: function(d) {
			if (d == "") return;
			var data = eval("("+d+")");
			for (var i=0;i<data.length;i++)
			{
				var redio = '<input type="radio" id="'+data[i].Id+'" name="status" value="'+data[i].Desc+'">'+data[i].Desc+'</input>';
				$("#status").append(redio);
			}
			$("input[value='确诊']").attr("checked", true);
		},
		error : function(d) { alert(" error");}
	});		
}

$("#left").click(function(){
	
	moveleft("#diagnoses");
})


$("#right").click(function(){
	
	moveright("#diagnoses");
})


$("#up").click(function(){
	
	 move("up") 
})


$("#down").click(function(){
	move("down");
})

function move(type) 
{ 
    var n = $("#diagnoses").treegrid("getSelected");
	if (n == null)
	{
		alert("无法移动！");
		return;
	};  
    var selectRow = $('#datagrid-row-r1-2-'+n.ID);  
    if(type == "up") 
    {  
        var pre = selectRow.prev();
        if (pre[0] && pre[0].className == "treegrid-tr-tree"){pre = pre.prev();}
        if (typeof(pre.attr("node-id"))=="undefined" || pre.attr("node-id").indexOf("L")==0)
		{  
			alert("无法移动！");  
		}
		else 
		{
			var preId = pre.attr("node-id");
			var pren = $("#diagnoses").treegrid("find",preId);
			/*
			if (n.TypeID != pren.TypeID)
			{
				alert("不是同一类型,不能移动");
				return;
			}
			*/
			var Id1 = n.PID + "||" + n.SubID ;
			var Id2 = pren.PID + "||" + pren.SubID;	
			if (ModifySequence(Id1,Id2) == "1")
			{		
				getDiagnoes();
				$("#diagnoses").treegrid("select",n.ID);
			}
		}  
    }
    else if (type == "down") 
    {  
        var next = selectRow.next();
        if (next[0] && next[0].className == "treegrid-tr-tree"){next = next.next();}
        if (typeof(next.attr("node-id"))=="undefined" || next.attr("node-id").indexOf("L")==0) 
        {  
            alert("无法移动！")  
        }
        else 
        {  
            var nextId = next.attr("node-id");  
            var nextn = $("#diagnoses").treegrid("find",nextId);
            /*
        	if (n.TypeID != nextn.TypeID)
			{
				alert("不是同一类型,不能移动");
				return;
			}
			*/
			var Id1 = n.PID + "||" + n.SubID ;
			var Id2 = nextn.PID + "||" + nextn.SubID ;
			
			if (ModifySequence(Id1,Id2) == "1")
			{		
                getDiagnoes();
                $("#diagnoses").treegrid("select",n.ID);
			} 
        }  
    }  
}

///增大级别
function moveleft(dg)
{
	var treegrid = $(dg);
	var node = treegrid.treegrid("getSelected");
	if (node == null ||node == undefined)
	{
		alert("请选中节点");
		return;	
	}	
	var pnode = treegrid.treegrid("getParent",node.ID)
	if (pnode)
	{
		var pId = pnode.MRDIA;
		var cId = node.PID + "||" + node.SubID;
		var level = treegrid.treegrid("getLevel",node.ID) - 1;
		if (ModifyLevel(pId,cId,level) == "1")
		{
			getDiagnoes();
			treegrid.treegrid("select",node.ID);
		}
	}
	else
	{
		alert("不能增大级别");
	}	
}

///减小级别
function moveright(dg)
{
	var treegrid = $(dg);
	var node = treegrid.treegrid("getSelected");
	if (node == null ||node == undefined)
	{
		alert("请选中节点");
		return;
	}
	var selectRow = $('#datagrid-row-r1-2-'+ node.ID); 
	var prow = selectRow.prev(); 
	if (prow[0] && prow[0].className == "treegrid-tr-tree"){prow = prow.prev();}
	if (typeof(prow.attr("node-id"))== "undefined" || prow.attr("node-id").indexOf("L")==0)
	{  
		alert("不能减小级别");  
	}
	else
	{
		var pnodeId = prow.attr("node-id");
		var pnode = treegrid.treegrid("find",pnodeId);
		if (pnode.TypeID != node.TypeID)
		{
			alert("诊断类型不一致,不能调为子诊断");
			return;
		}
		var pId = pnode.PID + "||" + pnode.SubID;
		var cId = node.PID + "||" + node.SubID;
		var level = treegrid.treegrid("getLevel",node.ID)+1;
		if (ModifyLevel(pId,cId,level) == "1")
		{
			getDiagnoes();
			treegrid.treegrid("select",node.ID);			
		}
	}
}

///左右移动保存后台数据
function updateData(param,type)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"ModifiyDiagnos",
			"p1":param,
			"p2":type
		},
		success: function(d) {
			if (d == "") return;
			result = d;
		},
		error : function(d) { alert(" error");}
	});	
	return result;	
}

//修改顺序
function ModifySequence(id1,id2)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"ModifiySequence",
			"p1":id1,
			"p2":id2
		},
		success: function(d) {
			if (d == "") return;
			result = d;
		},
		error : function(d) { alert(" error");}
	});	
	return result;	
}

//修改级别
function ModifyLevel(pId,cId,level)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"ModifiyLevel",
			"p1":pId,
			"p2":cId,
			"p3":level
		},
		success: function(d) {
			if (d == "") return;
			result = d;
		},
		error : function(d) { alert(" error");}
	});	
	return result;	
}

function DiagnosCatChange()
{
	$('#icdlist').combogrid("clear"); 
	if ($('#diagnoscat option:selected').val()==1)
	{
		$("#radiobox").css("display","none");	
		$("#syndromebox").css("display","block");	
	}
	else
	{
		$("#radiobox").css("display","block");	
		$("#syndromebox").css("display","none");		
		
	}
	$("#iptpicd").attr("checked",true);
	
	icdlistfocus();
}

function CheckBind()
{
	if ($('#diagnoses').treegrid('getSelected') == null)
	{
		alert("请选中父诊断");	
	}
}

$("#btCopyTo").click(function()
{
	var fromType =  $("#seleFromType option:selected").val();
	var toType = $('input[name="diagnosetype"]:checked')[0].id;
	if (fromType == toType)
	{
		alert("诊断类型相同，不能复制");
		return;
	}
	var Items = $('#diagnoses').treegrid('getData');
	var copyItems =  new Array(); 
	$.each(Items, function(index, item){
		if (item.TypeID == fromType)
		{
			copyItems.push(item);
		}
	});
	if (copyItems.lenght <=0)
	{
		alert("没有数据可拷贝");
	}
	else
	{
		setCopy(copyItems,"");
		alert("复制完毕");
	}

});

//复制诊断
function setCopy(Items,parentId)
{
	$.each(Items, function(index, item){
		var result = addDiagnoses(item.ICDID,item.ICDDescBak,item.MemoDesc,parentId,item.Level,item.Position,"");
		if (result == "") return;
		var tmpresult = result.split("&");
		if (typeof(item.children) != "undefined")
		{
			setCopy(item.children,tmpresult[0]);
		}
	});
}

///添加诊断
$("#addDiagnose").click(function()
{
	var objDiagnos = $('#icdlist').combogrid('grid').datagrid('getSelected');
	var position = $('#position').combobox('getText');  
	var datetime = $('#datetime').datetimebox('getValue');
	if ($('#diagnoscat option:selected').val()==0)
	{
		if ($('#iptcicd')[0].checked) 
		{
			addSubDiagnose(objDiagnos,position,datetime);
		}
		else
		{
			addDiagnose(objDiagnos,position,datetime);
		}
	}
	else
	{
		var syndrome = $('#syndromelist').combogrid('grid').datagrid('getSelected');
		if ((objDiagnos != null)&&(objDiagnos != undefined))
		{
			if ((syndrome == null)||(syndrome == undefined))
			{
				alert("请填写证候");
				return;
			}
			else
			{
				var tmp = addDiagnose(objDiagnos,position,datetime);
				tmp = tmp.split("&");
				if (tmp[0]!="0")
				{
					var tmp = tmp[0].split("||");
					var Id = tmp[0]+tmp[1];
					$("#diagnoses").treegrid("select",Id);
					addSubDiagnose(syndrome,"",datetime);
				}
			}
		}
		else
		{
			addSubDiagnose(syndrome,"",datetime);
		}
	}
	
});

///添加诊断
function addDiagnose(objDiagnos,position,datetime)
{
	var result = "";
	//var objDiagnos = $('#icdlist').combogrid('grid').datagrid('getSelected');
	var icdId = "";
	var icdDesc = "";	
	var memo = $("#memo").val();
	if (((objDiagnos == null)||(objDiagnos == undefined))&&(memo == "")) return;
	if ((objDiagnos != null)&&(objDiagnos != undefined))
	{
		icdId = objDiagnos.Id;
		icdDesc = objDiagnos.Desc;
	}
	var parentId = "";
	result = addDiagnoses(icdId,icdDesc,memo,parentId,"1",position,datetime);
	return result;
}

//子诊断
function addSubDiagnose(objDiagnos,position,datetime)
{
	//var objDiagnos = $('#icdlist').combogrid('grid').datagrid('getSelected');
	var memo = $("#memo").val();
	var icdId = "";
	var icdDesc = "";	
	if (((objDiagnos == null)||(objDiagnos == undefined))&&(memo == "")) return;
	if ((objDiagnos != null)&&(objDiagnos != undefined))
	{
		memo = $("#memo").val();
	    icdId = objDiagnos.Id;
	    icdDesc = objDiagnos.Desc;	
	}
	var node = $('#diagnoses').treegrid('getSelected');
	if ((node == null)&&(node == undefined)) 
	{
		alert("请选择父节点");
		return;
	}
	var type = $('input[name="diagnosetype"]:checked')[0].id;
	if (node.TypeID != type) 
	{
		alert("类型不一直,不能添加");
		return;
	}
	var parentId = "";
	var level = $("#diagnoses").treegrid("getLevel",node.ID); 
	level = level + 1;
	parentId = node.PID + "||" + node.SubID;
	addDiagnoses(icdId,icdDesc,memo,parentId,level,position,datetime);		
}

///清除输入框
function clearInputDiagnos()
{
	$("#memo").attr("value","");
	$("#icdlist").combogrid('clear');
	$("#syndromelist").combogrid('clear');
	$("#position").combobox('clear');
}

///保存增加诊断信息
function addDiagnoses(icdId,icdDesc,memo,parentId,level,position,datetime)
{
	if (typeof(obj.Url.level != "undefined") && obj.Url.level == "Attending" && $.inArray(userLevel, ["Attending","Chief"])<=-1)
	{
		alert("主治及以上医师才可以下最后诊断");
		return; 
	}
	
	var result = ""
	if (icdId == "" && memo == "") return result;
	var type = $('input[name="diagnosetype"]:checked')[0].id;
	var status = $('input[name="status"]:checked')[0].id;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLMRDiagnose",
			"Method":"UpdateOrInsertDiagnos",
			"pa":episodeID,
			"pb":"",
			"pc":"",
			"pd":type,
			"pe":icdId,
			"pf":icdDesc,
			"pg":status,
			"ph":"",
			"pi":userID,
			"pj":"",
			"pk":memo,
			"pl":parentId,
			"pm":level,
			"pn":position,
			"po":datetime
		},
		success: function(d) {
			if (d == "") return result;
			var tmpd = d.split("&");
			if (tmpd[2] == "T")
			{
				alert("列表中已经存在此诊断");
				return result;
			}
			if (tmpd[0] == "0")
			{
				alert("保存失败");
				return result;
			}
			if ((tmpd[1] != "")&&(g_infectionsource == "his"))
			{
				var tmpMeg = tmpd[1].split("^"); 
				if (window.confirm(tmpMeg[2]))
				{
					window.open("dhcmed.epd.reportportal.csp?EpisodeID="+episodeID+"&LocID="+locID+"&UserID="+userID,"",""); 
				}
			} 
			result = d;			
			///刷新
			getDiagnoes();
			clearInputDiagnos();
			icdlistfocus();
		},
		error : function(d) { alert(" error");}
	});	
	return result;
}


$("#btQuote").click(function(){	

	if (typeof(obj.Url.level != "undefined") && obj.Url.level == "Attending" && $.inArray(userLevel, ["Attending","Chief"])<=-1)
	{
		alert("主治及以上医师才可以引用诊断到病历");
		return; 
	}
	var diagnosesData = $('#diagnoses').treegrid('getData');
	var selectedItems = $.grep(diagnosesData,function(item,i)
	{
		if (g_hasCheck == "1")
		{
			return (item._checked == true)
		}
		else
		{
			if (g_diagnosetypes.length>0)
			{
				return $.inArray(item.TypeCode, g_diagnosetypes)>-1
			}
			else
			{
				return;
			}			
		}
	});	
	alert(selectedItems);
	g_refScheme = getRefScheme(g_xml,"scheme>reference>items>item")
	g_separate = $(g_xml).find("scheme>reference>separate").text();
	g_separate = g_separate=="enter"?"\n":g_separate;
	g_schemetype = $(g_xml).find("scheme>reference>style").text();
	g_memosep = $(g_xml).find("scheme>reference>memosep").text();
	var interpunction = $(g_xml).find("scheme>reference>interpunction").text();
	g_interpunction = interpunction.split("^");
	var displaycategory = $(g_xml).find("scheme>reference>category>display").text();
	var categoryseparate = $(g_xml).find("scheme>reference>category>separate").text();
	categoryseparate = categoryseparate=="enter"?"\n":categoryseparate;
	var displaytype = $(g_xml).find("scheme>reference>type>display").text();
	var typeseparate = $(g_xml).find("scheme>reference>type>separate").text();
	typeseparate = typeseparate=="enter"?"\n":typeseparate;
	var tmpnamedate = $(g_xml).find("scheme>reference>namedate").text();
	var result = "";
	if (selectedItems.length >0)
	{
		var typeList = new Array();
		$.each(selectedItems, function(index, item){if ($.inArray(item.TypeDesc,typeList)== -1) typeList.push(item.TypeDesc);});
		for (var i=0;i<typeList.length;i++)
		{
			var type = ""
			var typeItems = $.grep(selectedItems,function(item,a){return item.TypeDesc == typeList[i]});
			if (typeItems.length>0 && displaytype == "y")
			{
				type = typeList[i];
				result = result + type + ":" + typeseparate;
			}
			var categoryList = new Array();
			$.each(typeItems, function(index, item){if ($.inArray(item.BillFlag,categoryList)== -1) categoryList.push(item.BillFlag);});	
			
			for (var j=0;j< categoryList.length;j++)
			{
				var category = "";
				var categoryItems = $.grep(typeItems,function(item,a){return item.BillFlag == categoryList[j]});
				if (categoryList.length >1 && displaycategory == "y") 
				{
					if (type !="") result = result + "    ";
					if (categoryList[j]=="0") 
					{
						result = result + "西医诊断:";
					}
					else
					{
						result = result + "中医诊断:";
					}
					category = categoryList[j];
					result = result + categoryseparate;
				}
				if (tmpnamedate == "y")
				{
					result = result + getDiagnosesDataByDateName(categoryItems,type,category);
				}
				else
				{
					result = result + getDiagnosesData(categoryItems,type,category);	
				}			
			}	
		}
	}
	window.returnValue = result;
	closeFlag = "Y";
	closeWindow();
});

///按分类输出诊断
function getDiagnosesData(Items,type,category)
{
	var result = "";
	var seq = "";
	for (var i=0;i< Items.length;i++)
	{
		if (type != "") result = result + "    ";
		if (category != "") result = result + "    ";
		if (Items.length > 1) seq = i +1; 
		result = result + seq
		if (seq != "" && g_interpunction.length >0) result = result + g_interpunction[0];
		result = result + Items[i].ICDDesc;
		if (Items[i].EvaluationDesc == "疑诊")
		{
			result = result + "?";
		}
		if (Items[i].MemoDesc != "")
		{
			if (g_memosep == "()")
			{
				if (Items[i].ICDID == "")
				{
					result = result + Items[i].MemoDesc;
				}
				else
				{
					result = result + "("+Items[i].MemoDesc+")";
				}
			}
			else
			{
				result = result + g_memosep + Items[i].MemoDesc;
			}
		}
		var child = getSubData(Items[i].children,Items[i].BillFlag)
		if (Items[i].BillFlag == 1 && child != "") 
		{
			result = result +"("+child+")";
		}
		else
		{
			if (g_schemetype == "layer" && child != "")
			{
				result = result + "\n" +child;
			}
			else if(g_schemetype == "row")
			{
				result = result +  child;
			}
		}
		result = result + g_separate;		
	}
	return result;
}

///按日期医生输出诊断
function getDiagnosesDataByDateName(Items,type,category)
{
	var result = "";
	var dateList = new Array();
	$.each(Items, function(index, item){if ($.inArray(item.Date,dateList)== -1) dateList.push(item.Date);});	

	for (var k=0;k< dateList.length;k++)
	{
		var dateItems = $.grep(Items,function(item,a){return item.Date == dateList[k]});
		var nameList = new Array();
		$.each(dateItems, function(index, item){if ($.inArray(item.UserName,nameList)== -1) nameList.push(item.UserName);});	
		
		for (var l=0;l<nameList.length;l++)
		{
			var nameItems = $.grep(dateItems,function(item,a){return item.UserName == nameList[l]});
		    var seq = "";
		    var date = "";
		    var name = "";
		    for (var m=0;m<nameItems.length;m++)
		    {
			    if (type != "") result = result + "    ";
		    	if (category != "") result = result + "    ";

			    if (nameItems.length > 1) seq = m +1; 
			    result = result + seq
			    if (seq != "" && g_interpunction.length >0) result = result + g_interpunction[0];
			    result = result + nameItems[m].ICDDesc;
			    if (nameItems[m].EvaluationDesc == "疑诊")
			    {
				     result = result + "?";
				}
		 		if (nameItems[m].MemoDesc != "")
				{
					if (g_memosep == "()")
					{
						if (nameItems[m].ICDID == "")
						{
							result = result + nameItems[m].MemoDesc;
						}
						else
						{
							result = result + "("+nameItems[m].MemoDesc+")";
						}
					}
					else
					{
						result = result + nameItems[m].MemoDesc;
					}
				}
			    var child = getSubData(nameItems[m].children,nameItems[m].BillFlag)
			    if (nameItems[m].BillFlag == 1 && child != "") 
			    {
				    result = result +"("+child+")";
				}
				else
				{
					if (g_schemetype == "layer" && child != "")
					{
						result = result + "\n" + child;
					}
					else if(g_schemetype == "row")
					{
						result = result +  child;
					}
				}
				result = result + g_separate;
			}
			if (nameItems.length>0)
			{
				date = "                      " + nameItems[0].Date + "\n";
				name = "                      " + nameItems[0].UserName +"\n";
				result = result + name + date;
			}
		}					
	}
	return result;	
}

//取子诊断
function getSubData(childrenItems,type)
{
	var result = "";
	if (typeof(childrenItems)== 'undefined') return result;
	var space = "";
	$.each(childrenItems, function(index, item)
	{
		var tmpValue = "";
		var level = $('#diagnoses').treegrid("getLevel",item.ID);
		if (type !=1) space = getSpace(level);
		tmpValue = item.ICDDesc;
		if (item.EvaluationDesc == "疑诊")
		{
			tmpValue += "?"; 
		}
		if (item.MemoDesc != "")
		{
			if (g_memosep == "()")
			{
				tmpValue = tmpValue + "("+item.MemoDesc+")";
			}
			else
			{
				tmpValue = tmpValue + item.MemoDesc;				
			}
		}
		var child = getSubData(item.children,type);
		if (child != "")
		{
			if (type == 1 && child != "")
			{
				tmpValue = tmpValue + "," +child;
			}
			else
			{
				if (g_schemetype == "layer" && child != "")
				{
					tmpValue = tmpValue + "\n" + child;
				}
				else if(g_schemetype == "row")
				{
					tmpValue = tmpValue +  child;
				}
			}
		}
		result = result + space; 
		var seq = "";
		if (childrenItems.length >1) seq = index +1; 
		result = result + seq ;
		if (seq != "" && g_interpunction.length >=level)
		{
			result = result + g_interpunction[level-1];
		}
		result = result + tmpValue;
		if (type == 1)
		{
			 result = result + ",";
		}
		else
		{
			result = result + g_separate;
		}
	});
	if (result.substring(result.length-g_separate.length)== g_separate)
	result = result.substring(0,result.length-g_separate.length);
	if (result.substring(result.length-1)== ",") result = result.substring(0,result.length-1);
	return result;	
}

function getSpace(level)
{
	var result = "";
	if (level == 1) return result;
	result = "    ";
	for (var i=1;i<level;i++ )
	{
		result += "      ";
	}
	return result
}


///删除病历
$("#delete").click(function(){
	var node = $('#diagnoses').treegrid('getSelected');
	if (typeof(node)=="undefined" || node == null)
	{
		alert("请选中诊断删除");
		return;
	}
	var tipMsg = "是否确定删除此诊断?";
	if (window.confirm(tipMsg))
	{
		jQuery.ajax({
			type: "get",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			async: true,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLMRDiagnose",
				"Method":"DiagnosDelete",
				"p1":node.PID,
				"p2":node.SubID
			},
			success: function(d) {
				if (d == "0")
				{
					alert("删除失败");
				}
				else
				{
					alert("删除成功");
					$('#diagnoses').treegrid('remove',node.ID);
				}
				
			},
			error : function(d) { alert(" error");}
		});			
	}
});

//添加诊断获得焦点
function icdlistfocus()
{
	$("#icdlist").combogrid("textbox").focus();
}

//备注获得焦点
function memofocus()
{
	$("#memo").focus();
}
//证候获取焦点
function syndromefocus()
{
	$("#syndromelist").combogrid("textbox").focus();
}
//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

//取消按钮
$("#btCancel").click(function(){
	closeFlag = "N";
	closeWindow();
});

window.onbeforeunload = function(){    
	/*if (closeFlag == "")
	{
		var tipMsg = "直接关闭将不会引用诊断到病历中，是否引用？";
		if (window.confirm(tipMsg))
		{
			$("#btQuote").click();
		}
	}*/
}