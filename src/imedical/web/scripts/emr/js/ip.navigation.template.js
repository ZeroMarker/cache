var g_returnData={};
//病种查询过的科室
var disSelectedLocId = "";
//病种数量
var _diseaseCount=0;
//初始化标志
var _flagInit = true;
var TempData = "";
$(function(){
    if ((action == "updateTitle")||(action == "modifyTitle"))
	{
		initChangeTitle();
	}
	else
	{
		//根据诊断取病种关联模板
		if (openDiseaseTemp=="Y"){
            if(_flagInit){
                initDisease(); 
                _flagInit=false;
            }
		}else{
			$("#selDiseaseSpecies").css("display","none");
			GetUserTemplate(locId,"");
		}
		initLoc();
	}
	
	$HUI.radio("[name='rdoLoc']",{
	    onChecked:function(e,value){
			var diseaseSpeciescode = ""; 
			var diseaseSpeciesGrid = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
			if(diseaseSpeciesGrid != null)
			{
				diseaseSpeciescode = diseaseSpeciesGrid.Code;
			}		    
            var ID = $(e.target).attr("id");    
			searchTempByDisease(diseaseSpeciescode,ID);
	    }
    });	 
    
    if (openWay=="personal")
	{
		$HUI.radio("#rdoPerson").setValue(true);
		getPersonalTreeData();
	} 
	
});
///病种
function initDisease(){
    //初始，选中患者本次就诊的病种
    var diseaseData = getPatDisease(episodeId);
    if (diseaseData !=""&&_flagInit){
        initDiseaseCom(diseaseData);
        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
        GetUserTemplate(locId,diseaseData[0].Code,_flagInit);
    }else{
        if(DiagnosInfo!="" &&_flagInit){
            if(DiagnosInfo.split("^")[1] == ""){
                diseaseData = getDiseaseByDiagnos("",locId,"");
                initDiseaseCom(diseaseData);
                GetUserTemplate(locId,"",false);
            }else{
                diseaseData = getDiseaseByDiagnos(DiagnosInfo,locId,"");
                initDiseaseCom(diseaseData);
                //诊断不为空  第一次时根据诊断关联的病种选中第一条
                if(diseaseData != ""){
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
                    GetUserTemplate(locId,diseaseData[0].Code,_flagInit);
                }else{
                    //诊断关联病种为空，直接加载模板
                    GetUserTemplate(locId,"",false);
                }
            }
        }else if(DiagnosInfo=="" && _flagInit){
            diseaseData = getDiseaseByDiagnos("",locId,"");
            initDiseaseCom(diseaseData);
            GetUserTemplate(locId,"",false);
        }
    }
}
///根据诊断获取病种
function getDiseaseByDiagnos(diagInfo,ctlocId,name){
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLUserTemplate",
            "Method":"getDiseaseByDiagnos",
            "p1":diagInfo,
            "p2":ctlocId,
            "p3":name
        },
        success: function(d) {
            result = eval(d);
        },
        error: function() { 
            alert("getDiseaseByDiagnos error");
        }
    });
    return result;
}
function initLoc()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplateCTLoc",
			"Method":"GetUserTemplateCTLoc",
			"p1":docId
		},
		success: function(d) {
			var data = eval(d);
				$("#selLocId").combobox({
					valueField:"RowID",
					textField:"Desc",
					data:data,
					onSelect:function(rec)
					{
						var selDiseaseSpecies="";
						if(openDiseaseTemp=="Y"){
							var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
							if(selected){
								selDiseaseSpecies=selected.Code;
							}	
						}
						searchSelect(rec.RowID,"",selDiseaseSpecies);
					},
				    onLoadSuccess:function(d){
				    	var data=eval(d);
				    	$.each(data,function(idx,val){
					    	//默认值为登录科室
					    	if (val.RowID == locId){
						    	$("#selLocId").combobox("setValue",locId);
						    	return;
						    }
						});
					}
			});
			
			//只有"知情告知"分类里面的模板，可以搜全院，其他分类只能搜本科室
			//alert("categoryId:" + categoryId);
			if ((Hospital == "CQZYY")&&(categoryId !== 11))
			{
				$("#selLocId").combobox('disable');
				//$("input[id='rdoAll']").attr("disabled",true);
				$HUI.radio("#rdoAll").disable();
			}
		},
		error : function(d) { 
			alert("getTemplate error");
		}
	});	
}

///查询卡片///////////////////////////////////////////////////////////////
$('#search').searchbox({ 
	searcher:function(value,name){ 
		if ($('#rdoPerson')[0].checked)
		{
            if (TempData == ""){
                return;
            }
            var tmpTemplateData = findTemplate(TempData, value);
            $('#templates').tree('loadData',tmpTemplateData);
		}
		else
		{
			var selLocId = "";
			if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
			var selDiseaseSpecies="";
			if(openDiseaseTemp=="Y"){
				var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
				if(selected){
					selDiseaseSpecies=selected.Code;
				}	
			}
			
			searchSelect(selLocId,value,selDiseaseSpecies);
		}

	}          
});

function searchSelect(sellocId,selvalue,selDiseaseSpecies)
{
	selvalue = selvalue.toUpperCase();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"GetUserTemplateTitlesJson",
			"p1":sellocId,
			"p2":docId,
			"p3":episodeId,
			"p4":selvalue,
			"p5":selDiseaseSpecies
		},
		success: function(d) {
			var data = eval("["+d+"]");
			setTree(data);
		},
		error : function(d) { 
			alert("getUserTemplate error");
		}
	});	
}

///目录树
function setTree(data)
{
	$('#templates').tree({  
		data:data,
		onDblClick:function(node){
			ztOnClick(node);
		}
	});
}

//ztree鼠标左键点击回调函数
function ztOnClick(treeNode)
{
	if ((treeNode.attributes.nodetype != "leaf")&&(treeNode.attributes.nodeType != "personal")) return
	if (treeNode.attributes.nodetype == "leaf")
	{
		g_returnData = 
		{
		 	"code":treeNode.attributes.Code,
		 	"titleCode":treeNode.attributes.TitleCode,
		 	"titleName":treeNode.name
		}
	}
	else
	{
		g_returnData = 
		{
		 	"code":treeNode.attributes.emrdocId,
		 	"titleCode":treeNode.attributes.titleCode,
		 	"titleName":treeNode.text,
		 	"exampleId":treeNode.id
		}
	}
	if (g_returnData.titleCode != "")
	{
		$("#list").css("display","none");
		$("#title").css("display","block");
		setTitle(g_returnData.titleCode);
		$.parser.parse(); 
	}
	else
	{
		window.returnValue = g_returnData;
		closeWindow();
	}
}
//加载病种下拉框
function initDiseaseCom(comData){ 
	$("#selDiseaseSpecies").combogrid({  
		panelWidth:390,
		panelHeight:200,
        data:comData,
        idField:'Code',  
	    textField:'Name',
	    fitColumns: true,
	    columns:[[  
	        {field:'Code',title:'Code',width:130,sortable:true},  
	        {field:'Name',title:'名称',width:230,sortable:true}  
		 ]],
		 keyHandler:{
			up: function() {
			    //取得选中行
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }	
			},
			down: function() {
              //取得选中行
                //取得选中行
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    //向下移动到最后一行为止
                    if (index < rows.length-1) 
                    {
                        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } 
                else 
                {
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
                }			
			},
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () {
				//按enter键 
				//文本框的内容为选中行的的字段内容
                var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$('#selDiseaseSpecies').combogrid("options").value = selected.Name;
			    }
                //选中后让下拉表格消失
                $('#selDiseaseSpecies').combogrid('hidePanel');
				$("#selDiseaseSpecies").focus();
            }, 
			query: function(q) {
				if(q==""){
					$("#icdlist").combogrid('clear');
					searchTempByDisease("","");	
				}
				var selLocId="";
				if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
 	            //动态搜索
                var diseaseData = getDiseaseByDiagnos("",selLocId,q);
                $("#selDiseaseSpecies").combogrid({data:diseaseData});
	            $('#selDiseaseSpecies').combogrid("setValue", q);  
	        }
	    },
	    onSelect:function (idnex,d){
            if (_flagInit){
                return;
            }
		    var selDiseaseSpecies = d.Code;
		    var selLocId = "";
			if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
			//选中后，存储患者类型
			saveAdmPatType(episodeId,d.Code,userID)
			// 选中病种后查询模板
			searchTempByDisease(selDiseaseSpecies,"");
			
		 },
	     onShowPanel:function(){
			var selLocId = "";
			if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
            if(($('#selDiseaseSpecies').combogrid('grid').datagrid('getRows').length==0)||(disSelectedLocId!=selLocId)){
                disSelectedLocId = selLocId
                var diseaseData = getDiseaseByDiagnos("",selLocId,"");
                $("#selDiseaseSpecies").combogrid({data:diseaseData});  
			}
		},
        onLoadSuccess:function(data){
        }
	});
}
//模板操作////////////////////////////////////////////////////////////
//取模板
function GetUserTemplate(tmpLocId,selDiseaseSpecies,flag)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"GetUserTemplateTitlesJson",
			"p1":tmpLocId,
			"p2":docId,
			"p3":episodeId,
			"p4":"",
			"p5":selDiseaseSpecies
		},
		success: function(d) {
			var data = eval("["+d+"]");
			if(data.length==0 && flag){
				// 不清空已设置的病种。
				// $('#selDiseaseSpecies').combogrid("setValue", "")
				GetUserTemplate(locId,"",false);
			}else{
				setTree(data);
			}
			if(data.length==1 && flag){
				
				//打开病历
				openDocument(data[0].id);
			}
		},
		error : function(d) { 
			alert("getUserTemplate error");
		}
	});
}
//自动加载病历
function openDocument(temID){
	if(_diseaseCount!=1 || isLoadDocument!="Y")return	
	var treeNode = $('#templates').tree('find',temID);
	ztOnClick(treeNode);
	
}
function selectLoc()
{
	$HUI.radio("#rdoLoc").setValue(true);
}

//初始化修改标题
function initChangeTitle()
{
	if (titleCode == "") return
	g_returnData = 
	{
	 	"code":"",
	 	"titleCode":titleCode,
	 	"titleName":""
	}
	$("#list").css("display","none");
	$("#title").css("display","block");
	setTitle(g_returnData.titleCode);
	$.parser.parse(); 
}

//关闭窗口
function closeWindow() {
	
		parent.closeDialog("temptitleDialog");
}

//获取患者就诊列表
function getPatDisease(episodeId)
{
    var result = "";
	jQuery.ajax({
		type: "get",
        dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLAdmPatType",
			"Method":"GetAdmPatType",
			"p1":episodeId
		},
		success: function(d) {
            if (d != "{}"){
                result = eval("["+d+"]");
            }
		},
		error : function(d) { 
            alert("getPatDisease error");
		}
	});	
	return result;
}



//获取患者就诊列表
function saveAdmPatType(episodeId,diseaseCode,userId)
{
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLAdmPatType",
			"Method":"SaveAdmPatType",
			"p1":episodeId,
			"p2":diseaseCode,
			"p3":userId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { 
			alert("initConfig error");
		}
	});	
	return result;
}

function getPersonalTreeData()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"GetDataTreeByDocID",
			"p1":userID,
			"p2":docId,
			"p3":locId,
			"p4":episodeId
		},
		success: function(d) {
			if (d == "") return;
			var data = eval("["+d+"]")[0];
			if (data.length != 0){
				setTree(data);
				TempData = data;
			}
		},
		error : function(d) { 
			alert("getPersonalTreeData error");
		}
	});
}

function findTemplate(data,value)
{
    var result = new Array();
    for (var i = 0; i < data.length; i++) 
    { 
        if ((data[i].children)&&(data[i].children.length >0))
        {
            var child = findTemplate(data[i].children,value)
            if ((child != "")&&(child.length >0))
            {
                var tmp = JSON.parse(JSON.stringify(data[i]));
                tmp.children = [];
                tmp.children = child;
                result.push(tmp);
            }
        }
        else
        {
            if (data[i].text.indexOf(value)!=-1){
                result.push(data[i]);
            }else if (data[i].attributes.py){
                value = value.toUpperCase();
                if (data[i].attributes.py.indexOf(value)!=-1){
                    result.push(data[i]);
                }
            }else if (data[i].attributes.SimpleSpel){
                value = value.toUpperCase();
                if (data[i].attributes.SimpleSpel.indexOf(value)!=-1){
                    result.push(data[i]);
                }
            }
        }
    }
    return result;
}

function searchTempByDisease(diseaseCode,RadioId)
{
	if (RadioId =="")
	{
		if($("input[name='rdoLoc']:checked"))
		{
			var Id=$("input[name='rdoLoc']:checked").val().trim();
			RadioId = Id;
		}
	}
	if(RadioId == "rdoAll")
	{

		GetUserTemplate("",diseaseCode);
	}			
	else if(RadioId == "rdoLoc")
	{
		GetUserTemplate(locId,diseaseCode);
	}
	else
	{
		getPersonalTreeData();
	}
	
}