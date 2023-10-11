/**
 * FileName: interfacedebugdetail.js
 * Author: lizhi
 * Date: 2022-06-6
 * Description: �ӿڹ���
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
	EditDescDialog();//��ʼ���༭����
	InitInputDetail();//��ʼ��treegrid
	$("#debugBtn").click(methoddebug); //���԰�ť���¼�
	$("#inputDetailSaveBtn").click(inputDetailSaveBtn); //�������ֵ��ť���¼�
	var Rq = INSUGetRequest();
	$('#debugCode').val(Rq["debugcode"]);
	$('#debugName').val(Rq["debugdesc"]);
	MethodtypeIn=Rq["methodtype"];
	ProductLine=Rq["ProductLine"];
	InitInputDescDialog();//��ʼ����α�ע����
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
	            inputstr=inputstr+" ����"
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
	    		{ field:'ARGCODE',title:'������',width:100,},
                { field: 'ARGTYPE', title: '��������', width: 70
                },
                { field: 'MustFlag', title: '�Ƿ����', width: 70, align: 'center' },
                { field: 'ARGNAME', title: '�ֶ�˵��', width: 230},
                { field:'Memo',title:'��ע',width:100,hidden:true,
	                formatter: function(value, row, index) {
	            		if(typeof(row["Memo"])!="undefined"&&row["Memo"]!="")
	                    {
                        	row["value"]=row["Memo"];
                        }
                    }
            	},
                { field: 'value', title: '����ֵ', width: 200,editor: 'text',showTip:true},
                { field:'ParamFormatterbtn',title:'',width:100,align:'center',
            	formatter: function(value, row, index) {
	            		if(row["ParamType"]!="")//������ʽ
	                    {
                        	return '<a class="editcls" onclick="showinputdetailtree(\'' + index + '\')">���ӻ�</a>';
                        }
                    }
            	},
            	{ field:'format',title:'',width:100,align:'center',
            	formatter: function(value, row, index) {
	            		if(row["ParamType"]!="")//������ʽ
	                    {
                        	return '<a class="formatcls" onclick="showinputdetail(\'' + index + '\')">��ʽ��</a>';
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
		ParamInput:rowId+"||||"+"input", //��ȡ���β���
		rows:999999

	},function(jsonData){	
		$('#inputListTabD').datagrid('loadData',jsonData);
		AddChangEevent();
	}) 
}
//�����ı���ʾ��
function InitInputDescDialog() {
    $('#inputDescDialog').dialog({
        autoOpen: false,
        title: '������ʽ��',
        iconCls: 'icon-w-edit',
        width: 850,
        height: 600,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        buttons: [{
            text: '�ر�',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#inputDescDialog').dialog('close');
            }
        }, {
            text: '����',
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
//��ʽ����ť
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
			$.messager.alert('��ʾ', "json��ʽ����,���޸Ļ���յ���ֵ�����µ��!", "info", function() {
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
			$.messager.alert('��ʾ', "xml��ʽ����,���޸Ļ���յ���ֵ�����µ��!", "info", function() {
			});
			return false;
		} */
	}
    $('#inputDescDialog textarea').val(tVal);
    $('#inputDescDialog').dialog("open");
    $('#inputDescDialog textarea').focus();
}
//��ʽ����������,inputId=0�Ǹ�ʽ����inputId=1��ѹ��
function dataformat(inputId)
{
	var rows = $('#inputListTabD').datagrid('getSelected');
	var index = $('#inputListTabD').datagrid('getRowIndex', rows);
	var datatype=rows['ParamType'];
	if(inputId==0)//��ʽ��
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
				$.messager.alert('��ʾ', "xml��ʽ����!", "info", function() {
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
				$.messager.alert('��ʾ', "json��ʽ����!", "info", function() {
	        	});
			}
		}
	}
	if(inputId==1)//ѹ��
	{
		var data=$("#inputDescDialog textarea").val();
		data=data.replaceAll(" ","").replaceAll("\r\n$1\r\n","").replaceAll("\r\n","").replaceAll("\r","").replaceAll("\n","");
		$("#inputDescDialog textarea").val(data);
	}
}
//������������ַ�
function replaceTextarea2(str) {
    var reg = new RegExp("<br>", "g");
    var reg1 = new RegExp("<p>", "g");
    str = str.replace(reg, "\n");
    str = str.replace(reg1, " ");
    return str;
}
//�������ֵ�¼�
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

//����
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

//���ӻ���ť
function showinputdetailtree(index) {
	$('#interfaceinputDetail').window("open");
    $("#inputListTabD").datagrid('selectRow', index);
	var data = $('#inputListTabD').datagrid('getData');
	var ParamFormatter=data.rows[index].ParamFormatter;
	//���ӻ��������ֵ
	var debugvalue=INSUMIDataGrid.getCellVal("inputListTabD",index,'value');
	var ParamType=data.rows[index].ParamType;
	treegridObjData={total:0,rows:[],curPage: 1}; //ȫ�ֱ�����ʼ��
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
			$.messager.alert('��ʾ', "json��ʽ����,���޸Ļ���յ���ֵ�����µ��!", "info", function() {
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
			ParamFormatter="<root>"+ParamFormatter+"</root>";//xml���һ�����ڵ㣬ת��ʱ���ڵ㶪ʧ
			var Paramobj=$.xml2json(ParamFormatter);
			tmpobj=Paramobj;
			treegridjson(Paramobj,"");
/* 		}
		else
		{
			$.messager.alert('��ʾ', "xml��ʽ����,���޸Ļ���յ���ֵ�����µ��!", "info", function() {
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
		if(ParamType=="json"||ParamType=="xml")//json��xml����״ͼ���ڵ㲻����ֵ
		{
			if(treegridObjData.rows[i]["haschild"]=="false")
			{
				$('#inputListTabDetail').treegrid('beginEdit',treegridObjData.rows[i]["Rowid"]);
			}
		}
		else  //�ַ����ָ�������벢��û�ӽڵ�
		{
			$('#inputListTabDetail').treegrid('beginEdit',treegridObjData.rows[i]["Rowid"]);
		}
	}; 

}
//��ʼ��treegridҳ��
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
		{title: '�ֶ���', field: 'inputname1', width: 200,
		formatter: function(value, row, index) {
				if(value=="")
				{
				 	 return '<a id="'+value+'">'+'<input type="text" class="datagrid-editable-input" style="width: 193px; height: 28px;">'+'</a>'; 
				}
				else if(row["_parentId"]!=""&&row["_parentId"]!=null)//������ʽ
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
		{title: '����ֵ', field: 'inputcode1', width: 200,editor: 'text'}
	]],
	onLoadSuccess: function(data) {
	},
	onClickRow: function(index, row) {
    },
	onLoadError:function(a){
	}
});
}

//treegrid�������ֵ
function inputDetailSaveBtn()
{
	for (i=0;i<treegridObjData.rows.length;i++){  //ȡ���༭����ȡ����ֵ
		if(typeof(treegridObjData.rows[i]["children"])=="undefined")
		{
			$('#inputListTabDetail').treegrid('endEdit',treegridObjData.rows[i]["Rowid"]);
		}
	}; 
	var rows = $('#inputListTabD').datagrid('getSelected');
	var index = $('#inputListTabD').datagrid('getRowIndex', rows);
	var datatype=rows['ParamType'];//�������ַ�������json����֯����
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

//�������ֵ
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
			$.messager.alert('��ʾ', "xml��ʽ����!", "info", function() {
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
			$.messager.alert('��ʾ', "json��ʽ����!", "info");
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
//���޸ĺ��treegridת��Ϊjson����
function treegriddatatojson(testjsonobj,parentId)
{
	try
	{
		for (key in testjsonobj)
		{
			if(typeof(testjsonobj[key])=="object")//����Ƕ���,����json��2��
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
//������ת��Ϊtreegrid����
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
			if(typeof(value)=="object") //����Ƕ���,������һ��
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
	else if(typeof(rows.ParamType)!="undefined"&&rows.ParamType!="")//�ָ���ֱ�Ӵ�ķָ���
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
        title: '�޸Ĳ���ģ��',
        iconCls: 'icon-w-edit',
        width: 850,
        height: 600,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        buttons: [{
            text: 'ȡ��',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#EditDescDialog').dialog('close');
            }
        }, {
            text: 'ȷ��',
            iconCls: 'icon-w-save',
            handler: function() {
		       		$.messager.confirm("������ʾ", "�Ƿ񱣴�ģ��?", function(r){
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
							$.messager.alert('��ʾ', "xml��ʽ����!", "info", function() {
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
							$.messager.alert('��ʾ', "json��ʽ����!", "info", function() {
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
//�޸�ģ����������������ı�
function datatypechange()
{
	//$("#inputDescDialog textarea").val('');
	var datatype=getValueById("datatype");
	if(datatype=="separator")	
	{
		$("#dataformat").empty();//�Ƴ�Ԫ��
		$("#datacompress").empty();//�Ƴ�Ԫ��
		$("#datatypeinput").css("display",'block');//�ָ��ַ��������ʾ
		$("#dataformat").append('<lable>�ָ��ַ�</lable>');
	}
	if(datatype=="xml"||datatype=="json")	
	{
		$("#dataformat").empty();//�Ƴ�Ԫ��
		$("#datacompress").empty();//�Ƴ�Ԫ��
		$("#datatypeinput").val();//�ָ��ַ���������
		$("#datatypeinput").css("display",'none');//�ָ��ַ����������
		$("#dataformat").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="Editdataformat(0)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">��ʽ��</span></span></a>');
		$("#datacompress").append('<a class="hisui-linkbutton l-btn l-btn-small" data-options="" onclick="Editdataformat(1)" group="" id=""><span class="l-btn-left"><span class="l-btn-text">ѹ��</span></span></a>');
	}
	if(datatype=="")	
	{
		$("#dataformat").empty();//�Ƴ�Ԫ��
		$("#datacompress").empty();//�Ƴ�Ԫ��
		$("#datatypeinput").css("display",'none');//�ָ��ַ����������
		$("#datatypeinput").val();//�ָ��ַ���������
	}
}

//�޸�ģ��,inputId=0�Ǹ�ʽ����inputId=1��ѹ��
function Editdataformat(inputId)
{
	var datatype=getValueById("datatype");
	if(inputId==0)//��ʽ��
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
				$.messager.alert('��ʾ', "xml��ʽ����!", "info", function() {
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
				$.messager.alert('��ʾ', "json��ʽ����!", "info", function() {
	        	});
			}
		}
	}
	if(inputId==1)//ѹ��
	{
		var data=$("#EditDescDialog textarea").val();
		data=data.replaceAll(" ","").replaceAll("\r\n$1\r\n","").replaceAll("\r\n","").replaceAll("\r","").replaceAll("\n","");
		$("#EditDescDialog textarea").val(data);
	}
}

//�޸ĺ��ģ�屣��
function SaveMethodArgsCom(index)
{	
	var inputdata = $('#inputListTabD').datagrid('getSelected');
	inputdata['PARID']=id;
	inputdata['PARNODETYPE']="input";
	saveinfo = JSON.stringify(inputdata);
	savecode=tkMakeServerCall('INSU.MI.ClassMethodArgsCom',"Save",saveinfo,session['LOGON.USERID'])
	if(savecode!="0")
	{
		$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');
		return;
	}
	$('#inputListTabD').datagrid('beginEdit', index);
	$('#EditDescDialog').dialog('close');
	showinputdetailtree(index);
}

//---�������ӻ������� 0�����Ϸ�����ͬ����1�����·�����ͬ����2��������Ӽ��ڵ�
function insertinputListTabD(id)
{
	var node = $('#inputListTabDetail').treegrid('getSelected');
	var data = $('#inputListTabDetail').treegrid('getData');
	if(node==null)
	{
		$.messager.alert('��ʾ', "��ѡ����ӽڵ��λ��!", "info");
		return;
	}
	switch(id)
	{ 
		case 0: //�Ϸ�����ͬ��
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
		 case 2:  //����ӽڵ�
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
//���ӻ�ɾ���� --����
function deleteinputListTabD()
{
	var node = $('#inputListTabDetail').treegrid('getSelected');
	if(node==null)
	{
		$.messager.alert('��ʾ', "��ѡ��ɾ���ڵ��λ��!", "info");
	}
	else
	{
		$('#inputListTabDetail').treegrid('remove',node.Rowid);
	}
}