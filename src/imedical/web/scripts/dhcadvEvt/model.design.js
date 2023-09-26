//model.design.js
//�����¼��������
//zhouxin
//2019-07-15
$(function(){ 
	
	initTree();
	initDataGrid();
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'dicDatagrid':'#datagrid','formid':'#dicToolbar'})
     	}
	}
	
});

function initTree(){
	var modelId=$("#modelId").val();
	$("#dimensionTree").tree({
		dnd:true,
		checkbox:true,
		onClick: function(node){
			if(typeof node.id=="number"){
				runClassMethod("web.DHCADVModel","EntityToJson",{entity:"User.DHCADVModelAttr",id:node.id},function(data){
					
					for(key in data){
						var radioFlag=checkIsRadio(key)
						if(radioFlag==1){
							$HUI.radio("input[name='"+key+"'][type=radio][value='"+data[key]+"']").setValue(true);
						}else{
							$("#"+key).val(data[key])
						}
					}
					$("#attrKeyWord").html("<li style='list-style: none'><a>"+node.text+"</a></li>")
				},"json")
			}
			runClassMethod("web.DHCADVModel","EntityToJson",{entity:"User.DHCADVModelAttr",id:node.id},function(data){
				
				for(key in data){
					var radioFlag=checkIsRadio(key)
					if(radioFlag==1){
						$HUI.radio("input[name='"+key+"'][type=radio][value='"+data[key]+"']").setValue(true);
					}else{
						$("#"+key).val(data[key])
					}
				}
				$("#attrKeyWord").html("<li style='list-style: none'><a>"+node.text+"</a></li>");
			},"json");
			
			
		},
    	url:LINK_CSP+'?ClassName=web.DHCADVModelDesign&MethodName=DimensionTree&model='+modelId
	});
}

function initDataGrid(){
	$('#tableColumnDatagrid').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVModelDesign&MethodName=ListColumnByTable&table=User.DHCAdvMaster",
		columns:[[
			{field:'ck',checkbox:true}, 
			{field:'Name',title:'�ֶ���',width:60,align:'center'},
			{field:'Description',title:'�ֶ�ע��',width:100,align:'center'}		
		 ]],
		toolbar:"#columnToolbar",
		fit:true,
		title:' ',
		headerCls:'panel-header-gray',
		border:false,
		fitColumns:true,	
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:true
	});	
}







function checkIsRadio(key){
	var radioFlag=0
	var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", $("#modelAttrTable"));
	if (ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			if(name==key){
				radioFlag=1;
				return false;
			}
		});
	}
	return radioFlag;
}


function removeModelAttr(){
	
	var trees=$("#dimensionTree").tree('getChecked')
	if(trees.length==0){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ����ά��!");
		return;
	}
	var ids=[];
	for(var i=0;i<trees.length;i++){
		ids.push(trees[i].id)
	}
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ����", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVModel",
				    "removeBath",
					{
		 				'idStr':ids.join("^"),
		 				'entity':'User.DHCADVModelAttr'
		 			},
		 			function(data){
			 			$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
						$("#dimensionTree").tree('reload') 
					},"text");
            } 
    });
}

//����ά������
function saveModelAttr(){
	
	var par=[];
	
	$("#modelAttrTable").find("input[type=hidden],input[type=input],textarea").each(function(){
			var id=$(this).attr("id");
			var val=$(this).val();
			par.push(id+String.fromCharCode(1)+val);
	})
	
	var displayRate= $("input[name='displayRate']:checked").val();
	if(displayRate==undefined){
		$.messager.alert("��ʾ","��ѡ����ʾ���ʣ�");
		return false;
	}
	par.push("displayRate"+String.fromCharCode(1)+displayRate);
    
    var measureType= $("input[name='measureType']:checked").val();
	if(measureType==undefined){
		$.messager.alert("��ʾ","��ѡ��������ͣ�");
		return false;
	}
	par.push("measureType"+String.fromCharCode(1)+measureType);
	
	var extendType= $("input[name='extendType']:checked").val();
	if(extendType==undefined){
		$.messager.alert("��ʾ","��ѡ����չ��ʽ��");
		return false;
	}
	par.push("extendType"+String.fromCharCode(1)+extendType);
	
	var extendType= $("input[name='hidden']:checked").val();
	if(extendType==undefined){
		$.messager.alert("��ʾ","��ѡ�����أ�");
		return false;
	}
	par.push("hidden"+String.fromCharCode(1)+extendType);
	
	var type= $("input[name='type']:checked").val();
	if(type==undefined){
		$.messager.alert("��ʾ","��ѡ��ά�ȣ�");
		return false;
	}
	par.push("type"+String.fromCharCode(1)+type);

	var displayTotal= $("input[name='displayTotal']:checked").val();
	if(displayTotal==undefined){
		$.messager.alert("��ʾ","��ѡ����ʾ�ϼ��У�");
		return false;
	}
	par.push("displayTotal"+String.fromCharCode(1)+displayTotal);	
	
    runClassMethod(
	"web.DHCADVModel",
    "Save",
	{
		'entity':'User.DHCADVModelAttr',
		'params':par.join(String.fromCharCode(2)),
		'saveType':2
	},
	function(data){
		if(data==0){
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
			$("#dimensionTree").tree('reload')
		}else{
			if(data=="-98")
			{
				$.messager.alert("��ʾ","�������������ɾ��!");
			}else{
				$.messager.alert("��ʾ","����!+"+data);
			}
			
		}
	},"text");
}


function saveModelAttrCom(columType){
	


	var modelId=$("#modelId").val();
	var axis="";
	var idArr=[];
	var dateValue=$("#dataValInput").numberbox('getValue');
	
	if(columType=="dic"){
		axis=$("input[name='axisDicLabel']:checked").val();
		
		var rowsData = $("#dicDatagrid").datagrid('getSelections');
		if(rowsData.length<=0){
			$.messager.alert("��ʾ","��ѡ���ֵ�!");
			return;
		}
		for(var i=0;i<rowsData.length;i++){
			idArr.push(rowsData[i].ID)
		}
	}else if(columType=="dateRange"){
		axis=$("input[name='axisDateLabel']:checked").val();
		idArr.push($("input[name='measure']:checked").val())
	}else{
		axis=$("input[name='axisColumnLabel']:checked").val();
		
		var rowsData = $("#tableColumnDatagrid").datagrid('getSelections');
		if(rowsData.length<=0){
			$.messager.alert("��ʾ","��ѡ��Master���ֶ�!");
			return;
		}
		for(var i=0;i<rowsData.length;i++){
			idArr.push(rowsData[i].Name)
		}
	}
	
	if(axis==undefined){
		$.messager.alert("��ʾ","��ѡ��x,y��!");
		return;	
	}
	
	runClassMethod(
	"web.DHCADVModelDesign",
    "SaveModelAttr",
	{
		'columType':columType,
		'par':idArr.join("^"),
		'model':modelId,
		'axis':axis,
		'dateValue':dateValue
		
	},
	function(data){
		if(data==0){
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
			$("#dimensionTree").tree('reload')
		}else{
			if(data=="-1"){
				$.messager.alert("��ʾ","���ֶ�����ӣ����ʵ!");
			}else{
				$.messager.alert("��ʾ","����!+"+data);
			}
		}
	},"text");
}

function addDic(){
	
	var rowsData = $("#dicDatagrid").datagrid('getSelections');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","��ѡ���ֵ�!");
		return;
	}
	$('#dicDia').dialog('open');	
	$("#dicTree").tree({
		checkbox:true,
		url:LINK_CSP+'?ClassName=web.DHCADVModelDesign&MethodName=listTree&id='+rowsData[0].ID

	})
}

function saveDic(){
	var modelId=$("#modelId").val();
	var nodes = $('#dicTree').tree('getChecked');
	if(nodes.length==0){
		$.messager.alert("��ʾ","��ѡ���ֵ�!");
		return;
	}
	var par=[];
	for(var i=0; i<nodes.length; i++){
		par.push(nodes[i].id);
	}
	var root = $('#dicTree').tree('getRoot');
	
	var axis=$("input[name='axisDicLabel']:checked").val();
	runClassMethod(
	"web.DHCADVModelDesign",
    "saveAttrByDic",
	{
		'par':par.join(String.fromCharCode(1)),
		'model':modelId,
		'axis':axis,
		'root':root.id
		
	},
	function(data){
		if(data==0){
			$.messager.popover({msg: '����ɹ�!',type:'success',timeout: 1000});
			$("#dimensionTree").tree('reload');
			$('#dicDia').dialog('close');
		}else{
			$.messager.alert("��ʾ","����!+"+data);
		}
	},"text");
}