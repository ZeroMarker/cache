/// huaxiaoying
/// 2016-05-31
/// 分级指标主题库
var themeID=""
var pos="";
$(function(){
    //主题面板初始显示
	$('#ThemeTree').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListLevTree', 
		//checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			if (node.attributes=="1")
			{
				themeID=node.id;
				//函数对应主题显示
				$('#CatLib').tree({
						url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListCatLibTree&themeID='+themeID, 
						//checkbox:true,
						multiple: true,
						lines:true,
						animate:true,   
						required: true,
						onClick:function(node, checked){
							var str=""
							var LEXText=$("#LEXText").val();
							if(node.id==1)
							{
								str="";
							}else
							{
				
								if(LEXText.charAt(LEXText.length - 1) == ".")
								{
					
									str="(#"+node.attributes+"())";
								}
								if (LEXText=="")
								{
									str="(#"+node.attributes+"())";
								}
				
							}	
							big(str);
		
						}
					});
				$('#queryForm').form('clear');
				var box = document.getElementsByName("LEXActiveFlag");
	            box[0].checked = true;
	            $("#themeHidden").val(themeID);//隐藏主题id赋值
	            var SelectLTILev= $("#SelectLTILev").combobox("getValue");//get option值
	            if(SelectLTILev=="0"){SelectLTILev=""} 
				$("#LTILev").val(SelectLTILev);//给分级赋值
				commonQuery({'datagrid':'#datagrid1','formid':'#queryForm'})
				$("#LTILev").val("");//给分级赋空
			}else{
				$('#tabs').tabs('select', 1);
				$('#queryForm').form('clear');
				var box = document.getElementsByName("LEXActiveFlag");
	            box[0].checked = true;
				$("#LEXDesc").val(node.text);
				commonQuery({'datagrid':'#datagrid1','formid':'#queryForm'})
				$("#LEXDesc").val("");
			}
			
		}
	});
	//函数初始显示
	$('#CatLib').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevExpress&MethodName=ListCatLibTreeFirst', 
		//checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			var str=""
			var LEXText=$("#LEXText").val();
			if(node.id==1)
			{
				str="";
			}else
			{
				
				if(LEXText.charAt(LEXText.length - 1) == ".")
				{
					
					str="(#"+node.attributes+"())";
				}
				if (LEXText=="")
				{
					str="(#"+node.attributes+"())";
				}
				
			}	
			big(str);
		
		}
	});
	///主题关键字
    $("#SelectT").on('click', function() {
	    if (themeID==""){
		    $.messager.alert("提示","请选择主题"); 
		}else{             //2016-10-28 add else
		    pos=$("#LEXText").getFieldPos();   
			$('#detail').dialog('open');
			$('#detail').dialog('move',{
					left:280,
					top:180
				});
		    $('#detailgrid').datagrid({  
		    	    url:LINK_CSP+'?ClassName=web.DHCEMLevKey&MethodName=ListLevKeyY&themeID='+themeID,
		    	    method:'get',
		    	    fit:true,
		    	    loadMsg:'加载数据中.....',
		    	    pagination:true,
		    	    fitColumns:true,
		    	    rownumbers:true,
		    	    //onClickRow:detailonClickRow,
		    	    onDblClickRow:onDblClickRow,
		    	    columns:[[ 
				            {field:'LKCode',title:'代码',width:100},
				            {field:'LKDesc',title:'描述',width:120},
				            {field:'ID',title:'id',hidden:true,width:50}
		    	  	        ]]
	    	  	
			    });   
		} //2016-10-28 add else
 	}); //主题关键字END
 	
	$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed
  
})

///主题关键字调用
function onDblClickRow(rowIndex, rowData){
	var currRow =$('#detailgrid').datagrid('getSelected');
	$("#LEXText").insertPos(pos,"["+rowData.LKDesc+"]")
	$('#detail').window('close');
	}
	
///按钮事件
function big(type){
	var str=$("#LEXText").val();
	$("#LEXText").val(str+type);
	}
///清除
function Clear(){
	$("#LEXText").val("");
	}
///新增主题
function newT(){
	$('#tabs').tabs('select', 0);
	}

///新增主题项目(表达式)
function newP(){
	$('#tabs').tabs('select', 1);
	}
	
///新增主题_Tab
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LTHActiveFlag':'Y','LTHHospDr':LgHospID,'LTHRemark':''}})
}
//双击编辑
function onClickRow(index,row){
	
	CommonRowClick(index,row,"#datagrid");
	$("#a").attr("formatter",row.LTHHospDr.HOSPDesc);
	
}

function save(){
	saveByDataGrid("web.DHCEMLevTheme","SaveLevTheme","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
				$('#ThemeTree').tree('reload')   
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMLevTheme","RemoveLevTheme",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
		 $('#ThemeTree').tree('reload')  
    }    
    }); 
}

///新增主题项目_Tab
function addRowLib(){
	$('#queryForm').form('clear');
	var box = document.getElementsByName("LEXActiveFlag");
	box[0].checked = true;
	//$('#datagrid1').datagrid('selectRow', '');
	//$("#datagrid1").datagrid('reload')
}

function onClickRowE()
{
	var row =$("#datagrid1").datagrid('getSelected');
	$("#LEXCode").val(row.LEXCode);
	$("#LEXDesc").val(row.LEXDesc);
	$("#LEXRemark").val(row.LEXRemark);
	$("#LEXText").val(row.LEXText);
	$("#LTILev").val(row.LTILev);
	if(row.LEXActiveFlag=="Y"){
		var box = document.getElementsByName("LEXActiveFlag");
	    box[0].checked = true;	
	}else{
		var box = document.getElementsByName("LEXActiveFlag");
	    box[0].checked = false;
		}
	
	
}
function saveExpress(){
	if((themeID=="")&&($("#datagrid1").datagrid('getSelections').length != 1)){
		$.messager.alert('提示','请选择左侧主题');
		return;
	}else if($("#LEXCode").val()==""){
		$.messager.alert('提示','请填写 代码');
		return;
	}else if($("#LEXDesc").val()==""){
		$.messager.alert('提示','请填写 描述');
		return;
	//}else if($("#LEXRemark").val()==""){
	//	$.messager.alert('提示','请填写 备注');
	//	return;
	}else if($("#LEXText").val()==""){
		$.messager.alert('提示','请填写 表达式');
		return;
	}else if($("#LTILev").val()==""){
		$.messager.alert('提示','请填写 分级');
		return;
	}//else if(($("#LTILev").val()!=1)&&($("#LTILev").val()!=2)&&($("#LTILev").val()!=3)&&($("#LTILev").val()!=4)){
	 //	$.messager.alert('提示','请填写数字：1/2/3/4 (分级有且仅有1 2 3 4)');
	 //	return;
	 //	} //2017-1-5
	
    var text=$("#LEXText").val()
    if(text.length>500){
	    $.messager.alert("提示","字符串超长!"); 
	    return;
	    }
    
	var str=""
	str=str+themeID+"^";
    str=str+$("#LEXCode").val()+"^";
	str=str+$("#LEXDesc").val()+"^";
	str=str+$("#LEXRemark").val()+"^";
	str=str+$("#LEXText").val()+"^";
	str=str+$("#LTILev").val()+"^";
	if($('#LEXActiveFlag').is(':checked')){
		str=str+encodeURI("Y");
    }else{
	     str=str+encodeURI("N");
	}
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		var ID=0
	}else{
		var row =$("#datagrid1").datagrid('getSelected');
		var ID=row.ID;
	}
	str=str+"^"+ID;	
	//var str=str.replace("#","!"); 
	str=str.replace(/#/g,"!");

	runClassMethod("web.DHCEMLevExpress","SaveLevExpress",
					{'str':str},
					function(data){ 
						if(data==0){
		       				$('#queryForm').form('clear');
		       				//$('#LEXActiveFlag').checked = true;
		       				var box = document.getElementsByName("LEXActiveFlag");
		       				box[0].checked = true;
							$("#datagrid1").datagrid('reload')
							$('#ThemeTree').tree('reload')  
						}else if(data==1){
							$.messager.alert("提示","代码已存在,不能重复保存!"); 
						}else{	
							$.messager.alert('提示','保存失败:'+data)
				
						} 
					 });

	
}

function cancelExpress(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMLevExpress","RemoveLevExpress",{'Id':row.ID},function(data){ 
		    $('#queryForm').form('clear');
		    var box = document.getElementsByName("LEXActiveFlag");
	       	box[0].checked = true;
            $("#datagrid1").datagrid('load');
		    $('#ThemeTree').tree('reload')    })
         	 
    }    
    }); 
    
}