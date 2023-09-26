var g_returnData={};
//病种数量
var _diseaseCount=0;
//初始化标志
var _flagInit = true;
$(function(){
    if (action == "updateTitle")
	{
		initChangeTitle();
	}
	else
	{
		//根据诊断取病种关联模板
		if (openDiseaseTemp=="Y"){
			InitDiseaseCom(locId);
		}else{
			$("#selDiseaseSpecies").css("display","none");
			GetUserTemplate(locId,"");
		}
		initLoc();
	}
});

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
			"Method":"GetUserTemplateJson",
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
	if (treeNode.attributes.nodetype != "leaf") return
	g_returnData = 
	{
	 	"code":treeNode.attributes.Code,
	 	"titleCode":treeNode.attributes.TitleCode,
	 	"titleName":treeNode.name
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
function InitDiseaseCom(locId){ 
	$("#selDiseaseSpecies").combogrid({  
		panelWidth:278,
		panelHeight:200,
		url: "../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLUserTemplate&Method=getDiseaseByDiagnos&p1="+DiagnosInfo+"&p2="+locId,		
	    idField:'Id',  
	    textField:'Name',
	    fitColumns: true,
	    columns:[[  
	        {field:'Code',title:'Code',width:130,sortable:true},  
	        {field:'Name',title:'名称',width:130,sortable:true}  
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
				}
				var selLocId="";
				if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
 	            //动态搜索
	            $('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':selLocId,'p3':q});
	            $('#selDiseaseSpecies').combogrid("setValue", q);  
	        }
	    },
	    onSelect:function (idnex,d){
		    var selDiseaseSpecies = d.Code;
		    var selLocId = "";
			if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
			if(_flagInit){
				GetUserTemplate(locId,selDiseaseSpecies,_flagInit);	
			}else{
				searchSelect(selLocId,"",selDiseaseSpecies);
			}
			//选中后，存储患者类型
			saveAdmPatType(episodeId,d.Code,userID)
			
		 },
	     onShowPanel:function(){
			var selLocId = "";
			if ($('#rdoLoc')[0].checked) selLocId = $('#selLocId').combobox('getValue');
			if($('#selDiseaseSpecies').combogrid('grid').datagrid('getRows').length==0){
				$('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':selLocId ,'p3':""});	
			}
		},
		 onLoadSuccess:function(){
			  //初始，选中患者本次就诊的病种
			var diseaseCode = getPatDisease(episodeId)
			
			if (diseaseCode!=""&&_flagInit)
			{

				objDisease = eval(diseaseCode);
				$("#selDiseaseSpecies").combogrid("setValue",objDisease.Name);
	
				GetUserTemplate(locId,objDisease.Code,true);	
					
			}
			else
			{
				
				if(DiagnosInfo!="" &&_flagInit){
					//诊断不为空  第一次时根据诊断关联的病种选中第一条
					var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
					_diseaseCount=rows.length;
					if(_diseaseCount>0){
						$('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);	
					}else{
						//诊断关联病种为空，直接加载模板
						GetUserTemplate(locId,"",false);
					}
					
					
				}else if(DiagnosInfo=="" && _flagInit){
					//诊断为空 第一次加载时默认加载科室病种  不选中
					$('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId,'p3':""});
						GetUserTemplate(locId,"",false);	
				}
			}
			_flagInit=false;
		}
	});
}
//模板操作////////////////////////////////////////////////////////////
//取模板
function GetUserTemplate(tmpLocId,selDiseaseSpecies,flag)
{
	selectLoc(); 
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"GetUserTemplateJson",
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
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLAdmPatType",
			"Method":"GetAdmPatType",
			"p1":episodeId
		},
		success: function(d) {
			result = JSON.stringify(d)=="{}"? "":d;
		},
		error : function(d) { 
			alert("initConfig error");
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

