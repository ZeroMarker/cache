var param = "";
var agree=0;
$(document).ready(function() {
			 initParams();
			 initDetailGrid();
			 initCombobox();
			 initButton();
})

//获取数据
function initParams()
{
		param = getParam("params");
}

//按钮绑定
function initButton()
{
	$('#find').bind("click",findPres);
	$('#reset').bind("click",resetPres);
}

//查询按钮
function findPres()
{
	initDetailGrid(); 
}

//重置按钮
function resetPres()
{
	$HUI.combobox("#sign").setValue("");
	initDetailGrid();
}

//绑定项目名称下拉框
function initCombobox(){
	 
	 $HUI.combobox("#sign",{
				url: $URL+"?ClassName=web.DHCCKBAltoFreQuery&MethodName=QueryHospList&params="+param,
				valueField:'value',
				textField:'text',
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				selectOnNavigation:false,
				panelHeight:"auto",
				editable:false,
				mode:'remote',
			 	onAllSelectClick:function(){
				 if(agree==0){
		    		agree=1;
				 }else{
					 agree=0;
				 }
	   }
	});
}


//加载结果数据
function initDetailGrid(){
	
	var HospList=$HUI.combobox("#sign").getValues()
	// 定义columns	
	var columns=[];
	runClassMethod("web.DHCCKBAltoFreQuery","GetColumns",{'HospList':HospList.toString(),'agree':agree},function(jsonString){
		var jsonObject = jsonString;
		var ret = jsonObject.ret;
		var pid = jsonObject.pid;
		columns.push(jsonObject.columns);
	
	///  定义datagrid
	var option = {
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		remoteSort:false,
		pageSize : [30],
		pageList : [30,60,90],
	};
	var params=param+"^"+encodeURI(HospList);
	var uniturl = $URL+"?ClassName=web.DHCCKBAltoFreQuery&MethodName=QueryRuleCat&params="+params;
	new ListComponent('addgrid', columns, uniturl, option).Init();
},'json','false')

}
