
var drugId = "";
var catId = "";
var drug = "";
var pid = "";
var editRow = "";
var signArr = [{"value":"未处理","text":'未处理'},{"value":"complet","text":'规则错误，已完成'},{"value":"uwcomplet","text":'规则错误，未完成'},{"value":"partcomp","text":'规则错误，部分完成'},{"value":"partcompcon","text":'规则错误，部分完成，需用户确认'},{"value":"partcompproame","text":'规则错误，部分完成，需修正程序'}, {"value":"partcompruleimp","text":'规则错误，部分完成，需完善规则'},{"value":"partcompdicimp","text":'规则错误，部分完成，需完善字典'},{"value":"verifycorrect","text":'规则正确，需验证'},{"value":"affirmcorrect","text":'规则正确，需用户确认'},{"value":"achievecorrect","text":'规则正确，已完成'}];
$(document).ready(function() {
	initParams();
    initDetailGrid();        //加载统计数据 
    initCombobox();
    initButton(); 
})
function initParams()
{
		drugId = getParam("drugId");
		catId = getParam("catId");
		drug = getParam("drug");
		pid = getParam("pid");
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
		{field:'check',title:'sel',checkbox:true,hidden:false},
		{field:"patName",align:'center',width:100,title:"姓名",hidden:true},
		{field:"patNo",align:'center',width:100,title:"登记号",hidden:true},
		{field:"sex",align:'center',width:80,title:"性别",hidden:true},
		{field:"age",align:'center',width:100,title:"年龄",hidden:true},
		{field:"weight",align:'center',width:80,title:"体重",hidden:true},
		{field:"hisAllergyList",align:'center',width:100,title:"过敏源",hidden:true},
		{field:"diagList",align:'center',width:300,title:"诊断",hidden:true},
		{field:"drugName",align:'center',width:300,title:"药品名称"},
		{field:"drugNum",align:'center',width:80,title:"处方药品数量"},
		{field:"groupiden",align:'center',width:60,title:"组"},
		{field:"formProp",align:'center',width:80,title:"药品剂型",hidden:true},
		{field:"onceDose",align:'center',width:80,title:"单次剂量",hidden:true},
		{field:"unit",align:'center',width:80,title:"剂量单位",hidden:true},
		{field:"drugFreq",align:'center',width:80,title:"频次",hidden:true},
		{field:"drugPreMet",align:'center',width:80,title:"服药途径",hidden:true},
		{field:"treatment",align:'center',width:80,title:"疗程",hidden:true},
		{field:"drugOutParam",align:'left',width:450,title:"审查结果"},
		{field:"exasign",align:'center',width:160,title:"审核标记",editor:signeditor},
		{field:"remarks",align:'center',width:200,title:"备注",editor:textEditor},
		{field:"exasignval",align:'center',width:100,title:"exasignval",editor:textEditor,hidden:true},
		{field:"funId",align:'center',width:60,title:"funId",hidden:true},
		{field:"deal",align:'center',width:115,title:"详情",formatter:linkPrescdetails}
		
		
									
									
	]];
	
	///  定义datagrid
	var option = {
		//fitColumn:true,
		rownumbers : true,
		singleSelect : false,
		
		nowrap:false,  
		//fit : true,
		pageSize : [30],
		pageList : [30,60,90],
	 onDblClickRow: function (rowIndex, rowData) {
		       if (editRow != ""||editRow === 0){
			       			 
             $("#detailgrid").datagrid('endEdit', editRow); 

         } 
         $("#detailgrid").datagrid('beginEdit', rowIndex); 
         
         editRow = rowIndex;   
  },
  onLoadSuccess:function(data){
	  	
	 }
	    
	};
	var params = drugId +"^"+ catId +"^"+ $HUI.combobox("#sign").getValue()+"^"+ $HUI.combobox("#exares").getText();
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryPrescDetails&pid="+pid+"&params="+params;
	new ListComponent('detailgrid', columns, uniturl, option).Init();

}

function initCombobox()
{
	
	 //审核标记
		$HUI.combobox("#sign",{
					valueField:'value',
					textField:'text',
					panelHeight:"260",
					mode:'remote',
					data:signArr,
					onSelect:function(ret){
										
				 }
		 	})	
		 	
		 	//审核内容
		 	$HUI.combobox("#exares",{
					valueField:'value',
					textField:'text',
					panelHeight:"260",
					mode:'remote',
					onShowPanel:function(){
							var unitUrl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=GetCheckRes&pid="+pid;
							$("#exares").combobox('reload',unitUrl);
				}		   
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
				if(rowsData[i].monItmId==""){continue;}
				var tmp=rowsData[i].monItmId +"^"+ rowsData[i].remarks +"^"+ rowsData[i].exasignval ;
				dataList.push(tmp);
			} 
			var data=dataList.join("$$");
			console.log(data)
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
	var params = drugId +"^"+ catId +"^"+ $HUI.combobox("#sign").getValue() +"^"+ $HUI.combobox("#exares").getText();
	$('#detailgrid').datagrid('load',{'pid':pid,"params":params}); 
}
function resetPres()
{
	$HUI.combobox("#sign").setValue("");
	$HUI.combobox("#exares").setValue("");
	var params = drugId +"^"+ catId +"^"+ "" +"^"+ "" ;
	$('#detailgrid').datagrid('load',{'pid':pid,"params":params}); 
}

///药品明细
function linkPrescdetails(value, rowData, rowIndex)
{
	
	var btn = "<img class='mytooltip' title='详情' onclick=\"LoadPrescDetailsWin('"+rowData.monId+"','"+rowData.monItmId+"','"+rowData.funId+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
}
function LoadPrescDetailsWin(monId,monItmId,funId){	
	if($('#windel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="windel"></div>');
	
	$('#windel').window({
		title:'审查详情信息',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		width: window.screen.availWidth-80,
		height:window.screen.availHeight-150
	});
	
	var src= "dhcckb.reviewdetails.csp?monId="+monId+"&monItmId="+ monItmId+"&funId="+funId;
	var iframe='<iframe scrolling="yes" width=100% height=98%  frameborder="0" src='+src+'></iframe>';
	$('#windel').html(iframe);
	$('#windel').window('open'); 
	
}