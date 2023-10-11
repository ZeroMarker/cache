/**
 * FileName: interfacedebugdetail.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: 接口管理
 */
 var GV = {
	CLASSNAME:"INSU.MI.ClassMethodArgsCom",
	CLSName:"INSU.MI.ClassMethodCom"	 
}
var treegridobj="";
var id="";
var InterfaceCode="";
var tmpobj={};
var MethodtypeIn="";
var methodstr="";
var treegridTrArr=[""];
var ProductLine="";
var treegridObjData={total:0,rows:[],curPage: 1};
$(function() {
	EditDescDialog();//初始化编辑弹窗
	InitInputDetail();//初始化treegrid
	$("#debugBtn").click(methoddebug); //调试按钮绑定事件
	$("#inputDetailSaveBtn").click(inputDetailSaveBtn); //填入调试值按钮绑定事件
	var Rq = INSUGetRequest();
	$('#debugCode').val(Rq["debugcode"]);
	$('#debugName').val(Rq["debugdesc"]);
	MethodtypeIn=Rq["methodtype"];
	ProductLine=Rq["ProductLine"];
	InitInputDescDialog();//初始化入参备注弹框
	//$('#debugNameTxt').popover({content: decodeURI(Rq["debugdesc"]), placement: 'bottom-right', trigger: 'hover'});
	if(Rq["methodtype"]=="METHOD")
	{
		methodstr="set result=##class("+Rq["classname"]+")."+Rq["methodname"]+"(";
	}
	if(Rq["methodtype"]=="QUERY")
	{
		methodstr='result=##class(%ResultSet).RunQuery("'+Rq["classname"]+'","'+Rq["methodname"]+'",';
	}
	id = Rq["inputid"];
	InterfaceCode=Rq["InterfaceCode"];
	loadDebugInputDetail(methodstr,Rq["inputid"]);
});

function ChangedebugMethodStr(){
	var inputstr="";
	var a = $('#inputListTabD').datagrid('getRows');
	$.each(a,function(index,row){
		var debugvalue=INSUMIDataGrid.getCellVal("inputListTabD",index,'value');
		debugvalue=debugvalue.replaceAll('"',"'");
		if(debugvalue==""||debugvalue=='undefine')
        {
	        if(inputstr=="")
	        {
		      inputstr='"'+inputstr;  
	        }
            inputstr=inputstr+a[index]['ARGCODE']+" AS %"+a[index]['ARGTYPE'];
            if(a[index]['MustFlag']=='Y')
            {
	            inputstr=inputstr+" 必填"
	        }
	        inputstr=inputstr+'"';
	        if(index<a.length-1)
	        {
	        	inputstr=inputstr+',"';
	        }
        }
        else
        {
	        if(inputstr=="")
	        {
		      inputstr='"'+inputstr;  
	        }
	        inputstr=inputstr+debugvalue+'"';
	        if(index<a.length-1)
	        {
	        	inputstr=inputstr+',"';
	        }  
	    }
		
	})
	if(MethodtypeIn!=" ")
	{
		inputstr=methodstr+inputstr+")";
	}
	$('#debugMethod').val(inputstr)
    
}
function loadDebugInputDetail(methodstr,rowId) {
    $('#inputListTabD').datagrid({
        nowrap: false,
        singleSelect: true,
        idField: 'code',
        fit: true,
        width: '100%',
        striped:true,
		fitColumns:true,
		autoRowHeight:false,
        columns: [
            [
            	{ field:'ROWID',title:'Rowid',width:100,hidden:true},
	    		{ field:'ARGCODE',title:'参数名',width:100,},
                { field: 'ARGTYPE', title: '数据类型', width: 70
                },
                { field: 'MustFlag', title: '是否必填', width: 70, align: 'center' },
                { field: 'ARGNAME', title: '字段说明', width: 230},
                { field:'Memo',title:'备注',width:100,hidden:true,
	                formatter: function(value, row, index) {
	            		if(typeof(row["Memo"])!="undefined"&&row["Memo"]!="")
	                    {
                        	row["value"]=row["Memo"];
                        }
                    }
            	},
                { field: 'value', title: '调试值', width: 200,editor: 'text',showTip:true},
                { field:'ParamFormatterbtn',title:'',width:100,align:'center',
            	formatter: function(value, row, index) {
	            		if(row["ParamType"]!="")//参数格式
	                    {
                        	return '<a class="editcls" onclick="showinputdetailtree(\'' + index + '\')">可视化</a>';
                        }
                    }
            	},
            	{ field:'format',title:'',width:100,align:'center',
            	formatter: function(value, row, index) {
	            		if(row["ParamType"]!="")//参数格式
	                    {
                        	return '<a class="formatcls" onclick="showinputdetail(\'' + index + '\')">格式化</a>';
                        }
                    }
            	},
            ]
        ],
        onBeforeEdit: function(index, row) {
            row.editing = true;
        },
        onAfterEdit: function(index, row) {
            row.editing = false;
        },
        onClickRow: function(index, row) {
        },
        onLoadSuccess: function(data) {
			ChangedebugMethodStr();
			var data = $('#inputListTabD').datagrid('getData');
            var total = data.total;
            for (i = 0; i < total; i++) {
                $('#inputListTabD').datagrid('beginEdit', i);
            } 
        }
    });
    $.cm({
		ClassName:GV.CLASSNAME,
		QueryName: "QueryClassMethodArgs",
		ParamInput:rowId+"||||"+"input", //获取出参参数
		rows:999999

	},function(jsonData){	
		$('#inputListTabD').datagrid('loadData',jsonData);
		AddChangEevent();
	}) 
}
//输入文本提示框
function InitInputDescDialog() {
    $('#inputDescDialog').dialog({
        autoOpen: false,
        title: '参数格式化',
        iconCls: 'icon-w-edit',
        width: 850,
        height: 600,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        buttons: [{
            text: '关闭',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#inputDescDialog').dialog('close');
            }
        }, {
            text: '保存',
            iconCls: 'icon-w-save',
            handler: function() {
				var tVal = $('#inputDescDialog textarea').val();
				var result=fitinputListTabDvalue(tVal);
				if(result)
				{
	            	$('#inputDescDialog').dialog('close');
				}
	           }
        	}
        ]
    });
}
//格式化按钮
function showinputdetail(index) {
	$("#inputListTabD").datagrid('selectRow', index);
	var data = $('#inputListTabD').datagrid('getData');
	var tVal=data.rows[index].ParamFormatter;
	var debugvalue=INSUMIDataGrid.getCellVal("inputListTabD",index,'value');
	if(debugvalue!=""&&debugvalue!='undefine')
	{
		tVal=debugvalue;
	}
	tVal=replaceTextarea2(tVal);
	var ParamType=data.rows[index].ParamType;
	if(ParamType=="json")
	{

/* 		if(checkjson(tVal))
		{ 
			tVal=formatJson(tVal);
 		}
		else
		{
			$.messager.alert('提示', "json格式错误,请修改或清空调试值后重新点击!", "info", function() {
			});
			return false;
		} */
	}
	else if(ParamType=="xml")
	{
/* 		if(checkxml(tVal))
		{ */
			tVal=formatXml(tVal);
/* 		}
		else
		{
			$.messager.alert('提示', "xml格式错误,请修改或清空调试值后重新点击!", "info", function() {
			});
			return false;
		} */
	}
    $('#inputDescDialog textarea').val(tVal);
    $('#inputDescDialog').dialog("open");
    $('#inputDescDialog textarea').focus();
}
//格式化输入数据,inputId=0是格式化，inputId=1是压缩
function dataformat(inputId)
{
	var rows = $('#inputListTabD').datagrid('getSelected');
	var index = $('#inputListTabD').datagrid('getRowIndex', rows);
	var datatype=rows['ParamType'];
	if(inputId==0)//格式化
	{
		if(datatype=="xml")
		{
			var xmldata=$("#inputDescDialog textarea").val();
			if(checkxml(xmldata))
			{
				xmldata=formatXml(xmldata);
				$("#inputDescDialog textarea").val(xmldata);
			}
			else
			{
				$.messager.alert('提示', "xml格式错误!", "info", function() {
	        	});
			}
		}
		if(datatype=="json")
		{
			var jsondata=$("#inputDescDialog textarea").val();
			if(checkjson(jsondata))
			{
				jsondata=JSON.stringify(eval("("+jsondata+")"));
				jsondata=formatJson(jsondata);
				$("#inputDescDialog textarea").val(jsondata);
			}
			else
			{
				$.messager.alert('提示', "json格式错误!", "info", function() {
	        	});
			}
		}
	}
	if(inputId==1)//压缩
	{
		var data=$("#inputDescDialog textarea").val();
		data=data.replaceAll(" ","").replaceAll("\r\n$1\r\n","").replaceAll("\r\n","").replaceAll("\r","").replaceAll("\n","");
		$("#inputDescDialog textarea").val(data);
	}
}
//处理参数特殊字符
function replaceTextarea2(str) {
    var reg = new RegExp("<br>", "g");
    var reg1 = new RegExp("<p>", "g");
    str = str.replace(reg, "\n");
    str = str.replace(reg1, " ");
    return str;
}
//填入调试值事件
function AddChangEevent()
{
	var griddata=$('#inputListTabD').datagrid('getRows');
	for(i=0;i<griddata.length;i++)
	{
		var indexrow=$('#inputListTabD').datagrid("getRowIndex",griddata[i]);
		//var html='<input type="text" class="datagrid-editable-input" style="width: 193px; height: 28px" onblur="ChangedebugMethodStr()">';
		$(GetDataGrid.GetGridInfo(0,"td",indexrow,"value")).find("input")[0].onblur=ChangedebugMethodStr;
	}	
}

//调试
function methoddebug() {
	var inputJson = {};
	var a = $('#inputListTabD').datagrid('getRows');
	$.each(a,function(index,row){
		inputJson[row.ARGCODE]=	INSUMIDataGrid.getCellVal("inputListTabD",index,'value');
	})
	var inputJsonStr = JSON.stringify(inputJson);
	var savecode=tkMakeServerCall(GV.CLSName,"DoMethod",InterfaceCode,inputJsonStr);
	setValueById('outputListTabD',savecode);	
}

//可视化按钮
function showinputdetailtree(index) {
	$('#interfaceinputDetail').window("open");
    $("#inputListTabD").datagrid('selectRow', index);
	var data = $('#inputListTabD').datagrid('getData');
	var ParamFormatter=data.rows[index].ParamFormatter;
	//可视化填入调试值
	var debugvalue=INSUMIDataGrid.getCellVal("inputListTabD",index,'value');
	var ParamType=data.rows[index].ParamType;
	treegridObjData={total:0,rows:[],curPage: 1}; //全局变量初始化
	if(ParamType=="json")
	{
		if(debugvalue!=""&&debugvalue!='undefine')
		{
			ParamFormatter=debugvalue;
		} 
/* 		if(checkjson(ParamFormatter))
		{ */
			var Paramobj=eval("("+ParamFormatter+")");
			var test1=JSON.parse(ParamFormatter);
			tmpobj=Paramobj;
			treegridjson(Paramobj,"");
/* 		}
		else
		{
			$.messager.alert('提示', "json格式错误,请修改或清空调试值后重新点击!", "info", function() {
			});
			return false;
		} */
	}
	else if(ParamType=="xml")
	{
		if(debugvalue!=""&&debugvalue!='undefine')
		{
			ParamFormatter=debugvalue;
		} 
/* 		if(checkxml(ParamFormatter))
		{ */
			ParamFormatter="<root>"+ParamFormatter+"</root>";//xml添加一个根节点，转换时根节点丢失
			var Paramobj=$.xml2json(ParamFormatter);
			tmpobj=Paramobj;
			treegridjson(Paramobj,"");
/* 		}
		else
		{
			$.messager.alert('提示', "xml格式错误,请修改或清空调试值后重新点击!", "info", function() {
			});
			return false;
		} */
	}
	else if(ParamType!="")
	{
		var ParamArr=ParamFormatter.split(ParamType);
		for(i=0;i<ParamArr.length;i++)
		{
			var jsonobj={};
			jsonobj["Rowid"]=i.toString();
			jsonobj["_parentId"]="";
			jsonobj["inputname1"]=ParamArr[i];
			jsonobj["inputcode1"]="";
			treegridObjData.rows.push(jsonobj)
		}
		if(debugvalue!=""&&debugvalue!='undefine')
		{
			var ParamValueArr=debugvalue.split(ParamType);
			for(i=0;i<ParamValueArr.length;i++)
			{
				treegridObjData.rows[i]["inputcode1"]=ParamValueArr[i]
			}
		} 
	}
	treegridObjData.total = treegridObjData.rows.length;
	$('#inputListTabDetail').treegrid('loadData',treegridObjData);
	for (i=0;i<treegridObjData.rows.length;i++){
		if(ParamType=="json"||ParamType=="xml")//json和xml的树状图根节点不允许赋值
		{
			if(treegridObjData.rows[i]["haschild"]=="false")
			{
				$('#inputListTabDetail').treegrid('beginEdit',treegridObjData.rows[i]["Rowid"]);
			}
		}
		else  //字符串分割都可以输入并且没子节点
		{
			$('#inputListTabDetail').treegrid('beginEdit',treegridObjData.rows[i]["Rowid"]);
		}
	}; 

}
//初始化treegrid页面
function InitInputDetail()
{
	$HUI.treegrid("#inputListTabDetail", {
	idField:'Rowid',
	treeField:'inputname1',
	onDblClickRow:function(index,row){
		if(row.state == "closed"){
			$(this).treegrid('expand',index);
		}else{
			$(this).treegrid('collapse',index);
		}
	},
	fit: true,
	border: false,
	singleSelect: true,
	pagination: false,
	columns: [[
		{title: 'Rowid', field: 'Rowid', width: 80,hidden: true},
		{title: '字段名', field: 'inputname1', width: 200,
		formatter: function(value, row, index) {
				if(value=="")
				{
				 	 return '<a id="'+value+'">'+'<input type="text" class="datagrid-editable-input" style="width: 193px; height: 28px;">'+'</a>'; 
				}
				else if(row["_parentId"]!=""&&row["_parentId"]!=null)//参数格式
				{
					var tmpvalue=$('#inputListTabDetail').treegrid('find',row["_parentId"]).inputname1;
					return '<a id="'+tmpvalue+value+'">'+value+'</a>';
				}
				else
				{
					return '<a id="'+value+'">'+value+'</a>';
				}
			}
		},
		{title: '输入值', field: 'inputcode1', width: 200,editor: 'text'}
	]],
	onLoadSuccess: function(data) {
	},
	onClickRow: function(index, row) {
    },
	onLoadError:function(a){
	}
});
}

//treegrid填入调试值
function inputDetailSaveBtn()
{
	for (i=0;i<treegridObjData.rows.length;i++){  //取消编辑，获取填入值
		if(typeof(treegridObjData.rows[i]["children"])=="undefined")
		{
			$('#inputListTabDetail').treegrid('endEdit',treegridObjData.rows[i]["Rowid"]);
		}
	}; 
	var rows = $('#inputListTabD').datagrid('getSelected');
	var index = $('#inputListTabD').datagrid('getRowIndex', rows);
	var datatype=rows['ParamType'];//出来的字符串都是json，组织参数
	var debugjson="";
	if(datatype=="xml")
	{
		treegridTrArr=[""];
		treegriddatatojson(tmpobj,0);
		debugjson=$.json2xml(tmpobj);
		debugjson=debugjson.replace("<root>","").replace("</root>","");
	}
	else if(datatype=="json")
	{
		treegridTrArr=[""];
		treegriddatatojson(tmpobj,0);
		debugjson=JSON.stringify(tmpobj);
	}
	else
	{
		var treeGridData=$('#inputListTabDetail').treegrid('getData');
		$.each(treeGridData,function(index,key){
			if(typeof(key["inputcode1"])=="undefined")
			{
				key["inputcode1"]="";
			}
			if(debugjson=="")
			{
				debugjson=key["inputcode1"];
			}
			else
			{
				debugjson=debugjson+datatype+key["inputcode1"];
			}
		});
	}
	if(fitinputListTabDvalue(debugjson))
	{
		$('#interfaceinputDetail').window("close");
	}
}

//填入调试值
function fitinputListTabDvalue(tVal,type)
{
	var rows = $('#inputListTabD').datagrid('getSelected');
	var index = $('#inputListTabD').datagrid('getRowIndex', rows);
	var datatype=rows['ParamType'];
	if(datatype=="xml")
	{
		if(checkxml(tVal))
		{
			//tVal=formatXml(tVal);
		}
		else
		{
			$.messager.alert('提示', "xml格式错误!", "info", function() {
			});
			return false;
		}
	}
	if(datatype=="json")
	{
		if(checkjson(tVal))
		{
			//tVal=JSON.stringify(eval("("+tVal+")"))
			//tVal=formatJson(tVal);
		}
		else
		{
			$.messager.alert('提示', "json格式错误!", "info");
			return false;
		}
	}
	rows["value"]=replaceTextarea2(tVal);
	$('#inputListTabD').datagrid('updateRow',{
		index: index,
		row:rows
	});	
	$('#inputListTabD').datagrid('beginEdit',index);
	$(GetDataGrid.GetGridInfo(0,"td",index,"value")).find("input")[0].focus();	
	$(GetDataGrid.GetGridInfo(0,"td",index,"value")).find("input")[0].onblur=ChangedebugMethodStr;
	return true;
}
//将修改后的treegrid转换为json对象
function treegriddatatojson(testjsonobj,parentId)
{
	try
	{
		for (key in testjsonobj)
		{
			if(typeof(testjsonobj[key])=="object")//如果是对象,代表json第2层
			{
				parentId=parentId+1;
				treegridTrArr[parentId]=key;
				treegriddatatojson(testjsonobj[key],parentId);
				parentId=parentId-1;
			}
			else
			{
				var stringA=treegridTrArr[parentId];
				var rowid=$("#"+stringA+key).parent().parent().parent().parent().attr("node-id");
				var tmpvalue=$('#inputListTabDetail').treegrid('find',rowid).inputcode1;
				testjsonobj[key]=tmpvalue;
			}
		}
	}catch(e){
		return "";
	}
}
//将对象转换为treegrid参数
function treegridjson(Paramobj,parentId)
{
	var treegridcount=0;
	$.each(Paramobj,function(name,value){
			var jsonobj={};
			jsonobj["Rowid"]=parentId+"A"+treegridcount.toString();
			jsonobj["_parentId"]=parentId;
			jsonobj["inputname1"]=name;
			jsonobj["inputcode1"]=value;
			jsonobj["haschild"]="false"
			if(typeof(value)=="object") //如果是对象,代表下一层
			{
				jsonobj["inputcode1"]="";
				jsonobj["haschild"]="true"
				treegridObjData.rows.push(jsonobj);
				treegridcount=treegridcount+1;
				treegridjson(value,jsonobj["Rowid"]);
			}
			else
			{
				treegridObjData.rows.push(jsonobj);
				treegridcount=treegridcount+1;
			}
	});
}

function EditDetail()
{
	$('#interfaceinputDetail').dialog("close");
	var rows = $('#inputListTabD').datagrid('getSelected');
	var tVal=rows.ParamFormatter
	if(rows.ParamType=="json"||rows.ParamType=="xml")
	{
		$('#datatype').combobox('select',rows.ParamType);
	}
	else if(typeof(rows.ParamType)!="undefined"&&rows.ParamType!="")//分隔符直接存的分隔符
	{
		$('#datatype').combobox('select', "separator");
		$('#datatypeinput').val(rows.ParamType);
	}
	else
	{
		$('#datatype').combobox('select', "");
		$('#datatypeinput').val(rows.ParamType);
	}
    $('#EditDescDialog textarea').val(tVal);
    $('#EditDescDialog').dialog("open");
    $('#EditDescDialog textarea').focus();
}

function EditDescDialog() {
    $('#EditDescDialog').dialog({
        autoOpen: false,
        title: '修改参数模板',
        iconCls: 'icon-w-edit',
        width: 850,
        height: 600,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        buttons: [{
            text: '取消',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#EditDescDialog').dialog('close');
            }
        }, {
            text: '确定',
            iconCls: 'icon-w-save',
            handler: function() {
		       		$.messager.confirm("操作提示", "是否保存模板?", function(r){
	        		if (r) {
		            var tVal = $('#EditDescDialog textarea').val();
		            var rows = $('#inputListTabD').datagrid('getSelected');
		            var index = $('#inputListTabD').datagrid('getRowIndex', rows);
		        	var datatype=getValueById("datatype");
					if(datatype=="xml")
					{
						if(checkxml(tVal))
						{
							rows["ParamType"]=getValueById("datatype");
						}
						else
						{
							$.messager.alert('提示', "xml格式错误!", "info", function() {
				        	});
				        	return
						}
					}
					if(datatype=="json")
					{
						if(checkjson(tVal))
						{
							rows["ParamType"]=getValueById("datatype");
						}
						else
						{
							$.messager.alert('提示', "json格式错误!", "info", function() {
				        	});
				        	return
						}
					}
			        if(datatype=="separator")
			        {
				        rows["ParamType"]=getValueById("datatypeinput");
				    }
				    if(datatype=="")
			        {
				        rows["ParamType"]="";
				    }
		            rows["ParamFormatter"]=replaceTextarea2(tVal);
					$('#inputListTabD').datagrid('updateRow',{
					    index: index,
					    row:rows
					});
					SaveMethodArgsCom(index);
		            }
	       		})
            }
        }]
    });
}
//修改模板数据类型下拉框改变
function datatypechange()
{
	//$("#inputDescDialog textarea").val('');
	var datatype=getValueById("datatype");
	if(datatype=="separator")	
	{
		$("#dataformat").empty();//移除元素
		$("#datacompress").empty();//移除元素
		$("#datatypeinput").css("display",'block');//分割字符输入框显示
		$("#dataformat").append('<lable>分割字符</lable>');
	}
	if(datatype=="xml"||datatype=="json")	
	{
		$("#dataformat").empty();//移除元素
		$("#datacompress").empty();//移除元素
		$("#datatypeinput").val();//分割字符输入框清空
		$("#datatypeinput").css("display",'none');//分割字符输入框隐藏
		$("#dataformat").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="Editdataformat(0)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">格式化</span></span></a>');
		$("#datacompress").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="Editdataformat(1)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">压缩</span></span></a>');
	}
	if(datatype=="")	
	{
		$("#dataformat").empty();//移除元素
		$("#datacompress").empty();//移除元素
		$("#datatypeinput").css("display",'none');//分割字符输入框隐藏
		$("#datatypeinput").val();//分割字符输入框清空
	}
}

//修改模板,inputId=0是格式化，inputId=1是压缩
function Editdataformat(inputId)
{
	var datatype=getValueById("datatype");
	if(inputId==0)//格式化
	{
		if(datatype=="xml")
		{
			var xmldata=$("#EditDescDialog textarea").val();
			if(checkxml(xmldata))
			{
				xmldata=formatXml(xmldata);
				$("#EditDescDialog textarea").val(xmldata);
			}
			else if(checkjson(xmldata))
			{
				var xmldata=JSON.parse(xmldata);
				xmldata=$.json2xml(xmldata);
				xmldata=formatXml(xmldata);
				$("#EditDescDialog textarea").val(xmldata);
			}
			else
			{
				$.messager.alert('提示', "xml格式错误!", "info", function() {
	        	});
			}
		}
		if(datatype=="json")
		{
			var jsondata=$("#EditDescDialog textarea").val();
			if(checkjson(jsondata))
			{
				jsondata=JSON.stringify(eval("("+jsondata+")"));
				jsondata=formatJson(jsondata);
				$("#EditDescDialog textarea").val(jsondata);
			}
			else if(checkxml(jsondata))
			{
				jsondata=$.xml2json(jsondata);
				jsondata=formatJson(jsondata);
				$("#EditDescDialog textarea").val(jsondata);
			}
			else
			{
				$.messager.alert('提示', "json格式错误!", "info", function() {
	        	});
			}
		}
	}
	if(inputId==1)//压缩
	{
		var data=$("#EditDescDialog textarea").val();
		data=data.replaceAll(" ","").replaceAll("\r\n$1\r\n","").replaceAll("\r\n","").replaceAll("\r","").replaceAll("\n","");
		$("#EditDescDialog textarea").val(data);
	}
}

//修改后的模板保存
function SaveMethodArgsCom(index)
{	
	var inputdata = $('#inputListTabD').datagrid('getSelected');
	inputdata['PARID']=id;
	inputdata['PARNODETYPE']="input";
	saveinfo = JSON.stringify(inputdata);
	savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID'])
	if(savecode!="0")
	{
		$.messager.alert('提示','保存失败!rtn=' + savecode,'info');
		return;
	}
	$('#inputListTabD').datagrid('beginEdit', index);
	$('#EditDescDialog').dialog('close');
	showinputdetailtree(index);
}

//---舍弃可视化插入行 0代表上方插入同级，1代表下方插入同级，2代表插入子级节点
function insertinputListTabD(id)
{
	var node = $('#inputListTabDetail').treegrid('getSelected');
	var data = $('#inputListTabDetail').treegrid('getData');
	if(node==null)
	{
		$.messager.alert('提示', "请选择添加节点的位置!", "info");
		return;
	}
	switch(id)
	{ 
		case 0: //上方插入同级
			$('#inputListTabDetail').treegrid('insert', {
		        before: node.Rowid,
		        data: {
			        Rowid:node.Rowid+"up", 
		            inputname1:'',
		            inputcode1:'',
		            haschild:"false",
		        }
		    }); 
		    $('#inputListTabDetail').treegrid('beginEdit',node.Rowid+"up");
			break;
		case 1:
			$('#inputListTabDetail').treegrid('insert', {
		        after: node.Rowid,
		        data: {
			        Rowid:node.Rowid+"down", 
		            inputname1:'',
		            inputcode1:'',
		            haschild:"false",
		        }
		    }); 
		    $('#inputListTabDetail').treegrid('beginEdit',node.Rowid+"down");
		  break;
		 case 2:  //添加子节点
		    $('#inputListTabDetail').treegrid('append', {
		        parent: node.Rowid,
		        data:  [{
			        _parentId:node.Rowid, 
		            inputname1:'',
		            inputcode1:'',
		            haschild:"false",
		            Rowid:node.Rowid+"Chlid"
		        }]
		    });
			$('#inputListTabDetail').treegrid('beginEdit',node.Rowid+"Chlid");
			break;
	}
}
//可视化删除行 --舍弃
function deleteinputListTabD()
{
	var node = $('#inputListTabDetail').treegrid('getSelected');
	if(node==null)
	{
		$.messager.alert('提示', "请选择删除节点的位置!", "info");
	}
	else
	{
		$('#inputListTabDetail').treegrid('remove',node.Rowid);
	}
}