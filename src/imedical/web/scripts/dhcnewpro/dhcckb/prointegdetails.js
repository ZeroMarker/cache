var drugId = "";
var field = "";
var drug = "";
var itmId = "";
var editRow = "";    
var signArr = [{"value":"complet","text":'规则错误，已完成'},{"value":"uwcomplet","text":'规则错误，未完成'},{"value":"partcomp","text":'规则错误，部分完成'},{"value":"partcompcon","text":'规则错误，部分完成，需用户确认'},{"value":"partcompproame","text":'规则错误，部分完成，需修正程序'}, {"value":"partcompruleimp","text":'规则错误，部分完成，需完善规则'},{"value":"partcompdicimp","text":'规则错误，部分完成，需完善字典'},{"value":"verifycorrect","text":'规则正确，需验证'},{"value":"affirmcorrect","text":'规则正确，需用户确认'},{"value":"achievecorrect","text":'规则正确，已完成'}];
$(document).ready(function() {
			 initParams();
    initDetailGrid();        //加载统计数据 
    initCombobox();            //加载下拉框数据
    initButton();              //加载按钮
})

function initParams()
{
		drugId = getParam("drugid");     //药品id
		field = getParam("field");       //医院id
		drug = getParam("drug");         //药品名称
		itmId = getParam("itmId");       //项目id
		$("#checkdrug").html(drug)
}


//加载结果数据
function initDetailGrid(){

	/// 文本编辑格
		var textEditor={
				type: 'text',//设置编辑格式
				options: {
					required: true //设置编辑规则属性
				}
		}
	/// 标记
	var signeditor={  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					data:signArr,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //设置容器高度自动增长
					onSelect:function(option){
								///设置类型值
								var ed=$("#detailgrid").datagrid('getEditor',{index:editRow,field:'exasign'});
								$(ed.target).combobox('setValue', option.text);  //设置是否可用
								var ed=$("#detailgrid").datagrid('getEditor',{index:editRow,field:'exasignval'});
								$(ed.target).val(option.value); 
					} 
		}
	}
	///  定义columns
	var columns=[[
			      {field:"monId",align:'center',width:100,title:"monId",hidden:true},
			      {field:"monItmId",align:'center',width:100,title:"monItmId",hidden:true},
			      {field:'check',title:'sel',checkbox:true},
		       {field:"patName",align:'center',width:100,title:"姓名"},
		       {field:"sex",align:'center',width:80,title:"性别"},
		       {field:"age",align:'center',width:100,title:"年龄"},
			      {field:"weight",align:'center',width:80,title:"体重"},
									{field:"hisAllergyList",align:'center',width:100,title:"过敏源"},
									{field:"diagList",align:'center',width:300,title:"诊断"},
									{field:"drugNum",align:'center',width:80,title:"处方药品数量"},
									{field:"groupiden",align:'center',width:60,title:"组"},
									{field:"drugName",align:'center',width:300,title:"药品名称"},
									{field:"formProp",align:'center',width:80,title:"药品剂型"},
									{field:"onceDose",align:'center',width:80,title:"单次剂量"},
									{field:"unit",align:'center',width:80,title:"剂量单位"},
									{field:"drugFreq",align:'center',width:80,title:"频次"},
									{field:"drugPreMet",align:'center',width:80,title:"服药途径"},
									{field:"treatment",align:'center',width:80,title:"疗程"},
									{field:"drugOutParam",align:'left',width:450,title:"审查结果"},
									{field:"remarks",align:'center',width:200,title:"备注",editor:textEditor},
									{field:"exasignval",align:'center',width:100,title:"exasignval",editor:textEditor,hidden:true},
									{field:"exasign",align:'center',width:160,title:"审核标记",editor:signeditor},
	]];
	
	///  定义datagrid
	var option = {
		rownumbers : true,
		singleSelect : false,
		nowrap:false,  
		pageSize : [30],
		pageList : [30,60,90],
	 onDblClickRow: function (rowIndex, rowData) {
		       if (editRow != ""||editRow === 0){
             $("#detailgrid").datagrid('endEdit', editRow); 
         } 
         $("#detailgrid").datagrid('beginEdit', rowIndex); 
         editRow = rowIndex;   
   },    	
	};
	
	var params = drugId +"^"+ field +"^"+ itmId  + "^" + $HUI.combobox("#sign").getValue();
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryProComplist&params="+params;
	new ListComponent('detailgrid', columns, uniturl, option).Init();

}

function initCombobox()
{
		$HUI.combobox("#sign",{
									valueField:'value',
									textField:'text',
									panelHeight:"260",
									mode:'remote',
									data:signArr,
									onSelect:function(ret){}
		 	})	
}

function initButton()
{
	$('#save').bind("click",saveRemark);
	$('#synchron').bind("click",synchron);
	$('#cancel').bind("click",cancelRemark);
	$('#find').bind("click",findPres);
	$('#reset').bind("click",resetPres);
}

//审批同步
function synchron(){
	 var rows = $('#detailgrid').datagrid('getSelections');  //取得所有选中行数据，返回元素记录的数组数据
		if(rows.length>0)
		{
			   var remarks="";
			   var exasign="";
			   var exasignval="";
			   for(var i=0; i<rows.length; i++){
								  if(remarks==""){
								     remarks=rows[i].remarks;
								  }
								  if(exasignval==""){
								     exasignval=rows[i].exasignval;
								  }
								  if(exasign==""){
								     exasign=rows[i].exasign;
								  }
							}
							if(remarks==""&&exasign==""&&exasignval==""){
													   $.messager.alert("提示","请填写一条数据");
													   return;
						 }else{
								  for(var i=0; i<rows.length; i++){
									   
								     rows[i].remarks=remarks;
								     rows[i].exasign=exasign;
								     rows[i].exasignval=exasignval;
								     $("#detailgrid").datagrid('beginEdit', i); 
								     editRow = i;
								  }
						}	
		} 
		saveRemarksel();
}

function saveRemarksel()
{
	
			var rowsData = $("#detailgrid").datagrid('getSelections');
			
			for(var i=0; i<rowsData.length; i++){
				 $("#detailgrid").datagrid('endEdit', i);
				}
			
			
			if(rowsData.length<=0){
				$.messager.alert("提示","没有待保存数据!");
				return;
			}
			var dataList = [];
			for(var i=0;i<rowsData.length;i++){
				var tmp=rowsData[i].monItmId +"^"+ rowsData[i].remarks +"^"+ rowsData[i].exasignval ;
				dataList.push(tmp);
			} 
			var data=dataList.join("$$");
			//保存数据
			runClassMethod("web.DHCCKBCalculateval","saveRemark",{"dataList":data},function(jsonString){
						$('#detailgrid').datagrid('reload'); //重新加载
			});
}

function saveRemark()
{
	
			if(editRow>="0"){
				$("#detailgrid").datagrid('endEdit', editRow);
			}

			var rowsData = $("#detailgrid").datagrid('getChanges');
			if(rowsData.length<=0){
				$.messager.alert("提示","没有待保存数据!");
				return;
			}
			var dataList = [];
			for(var i=0;i<rowsData.length;i++){
				var tmp=rowsData[i].monItmId +"^"+ rowsData[i].remarks +"^"+ rowsData[i].exasignval ;
				dataList.push(tmp);
			} 
			var params=dataList.join("$$");
			//保存数据
			runClassMethod("web.DHCCKBCalculateval","saveRemark",{"dataList":params},function(jsonString){
						$('#detailgrid').datagrid('reload'); //重新加载
			});
}

function cancelRemark()
{
	var rowsData = $("#detailgrid").datagrid('getSelected'); //选中要删除的行
}

function findPres()
{
	var params = drugId +"^"+ field +"^"+ itmId  + "^" + $HUI.combobox("#sign").getValue();
	$('#detailgrid').datagrid('load',{"params":params}); 
}
function resetPres()
{
	$HUI.combobox("#sign").setValue("");
	var params = drugId +"^"+ field +"^"+ itmId  + "^" + $HUI.combobox("#sign").getValue();
	$('#detailgrid').datagrid('load',{"params":params}); 
}