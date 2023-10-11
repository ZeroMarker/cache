
var monId = "";
var monItmId = "";
var funId = "";
$(document).ready(function() {
	initParams();
    initDetailGrid();        //加载统计数据  
})
function initParams()
{
		monId = getParam("monId");
		monItmId = getParam("monItmId");
		funId = getParam("funId");
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
		
	///  定义columns
	var columns=[[
	
		{field:"monId",align:'center',width:100,title:"monId",hidden:true},
		{field:"monItmId",align:'center',width:100,title:"monItmId",hidden:true},
		{field:'check',title:'sel',checkbox:true,hidden:true},
		{field:"patName",align:'center',width:100,title:"姓名"},
		{field:"patNo",align:'center',width:100,title:"登记号"},
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
		{field:"exasign",align:'center',width:160,title:"审核标记"},
		{field:"funId",align:'center',width:60,title:"funId",hidden:true},
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
	
	var uniturl = $URL+"?ClassName=web.DHCCKBReviewDetails&MethodName=QueryRevDetails&monItmList="+monItmId+"&funId="+funId;
	new ListComponent('detailgrid', columns, uniturl, option).Init();

}
