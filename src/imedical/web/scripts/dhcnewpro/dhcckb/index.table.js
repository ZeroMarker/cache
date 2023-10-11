/**
	zhouxin
	2019-06-28
*/
var condArray= [{ "value": "and", "text": "并且" },{ "value": "or", "text": "或者" }]; //逻辑关系
var curCondRow=1;
var stateBoxArray= [{ "val": "=", "text": "等于" },{ "val": ">", "text": "大于" },{ "val": ">=", "text": "大于等于" },{ "val": "<=", "text": "小于等于" },{ "val": "<", "text": "小于" }]; //条件
$(function(){
	initCrumbs();
	initDataGrid();
	initCombobox();
	initButton();
})

function initCrumbs(){
	
	var catId=$("#catId").val(),crumbHtml=getCrumbs(catId,"","");
	///组织动态查询条件
	crumbHtml = crumbHtml+'<div><span style="margin:0 10 0 10"><span onclick="toggleExecInfo(this);" class="toggle-btn">更多查询</span></span>'
	crumbHtml = crumbHtml+'<span><a href="#" class="hisui-linkbutton"  iconCls="icon-w-find" id="serchtbdt" >查询</a></span></div>'
	crumbHtml = crumbHtml+'<table style="display:none" id="condTable"></table></div>'
	$("#tableTb").html(crumbHtml);
	addCondition();
}
// 点击事件
function toggleExecInfo(obj){
	
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html("更多查询");
		$("#condTable").hide();
		$("#dashline").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html("隐藏");
		$("#condTable").show();
		$("#dashline").show();
	}
	//setHeight();
}
///设置高度
function setHeight(){
    var tableHeight=$('#condTable')[0].offsetHeight
    var divHeight=tableHeight+150;
    var centertop=divHeight+50;
    var maindgHeight=$(window).height()-divHeight-130;
}
// 增加行
function addCondition(){
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:10px;padding-right:10px;">查询条件</b>';
	html+=getLookUpHtml(curCondRow,1);
	//html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;" ><b>等于</b></span>'
	html+='<span style="padding-left:20px;" ><input id="QueCond'+curCondRow+"-"+1+'" style="width:120" class="easyui-combobox"/></span>';
	html+='<span style="padding-left:20px;" id="condTd">逻辑关系<input id="condCombox'+curCondRow+"-"+1+'" style="width:70"/></span>'
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>增加行</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>删除行</span></td></tr>';
	}
	$("#condTable").append(html);
	//条件
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	//条件值
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCCKKBIndex&MethodName=QueryDrugAttr',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option) {
			var netxId=this.id.split("LookUp")[1];
			var unitUrl = $URL+"?ClassName=web.DHCCKKBIndex&MethodName=QueryAttrData&Parref="+option.value
			$("input[id=QueCond"+netxId+"]").combobox('reload',unitUrl);
		}
		
	})
	$("input[id^=QueCond"+curCondRow+"-]").combobox({
		url:'',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option) {
			
			
		}
	})
	//逻辑关系
	$("input[id^=condCombox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//setHeight();
}
// 删除行
function removeCond(row){
	$("#"+row+"Tr").remove();
}
// 查询条件 输入框加载
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span>'
	html+='<input id="LookUp'+key+'" style="width:120;" class="easyui-combobox" />'	
	html+='</span>'
	return html;
}
// 条件语句
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" />'
	html+='</span>'
	return html;
}
function initCombobox(){
	
}
///初始化按钮
function initButton(){
	$("#addCondBTN").on('click',addCondition); // 高级查询条件增加
	
	$("#serchtbdt").on('click',query); // 高级查询条件增加
	
}
function initDataGrid(){
	
	var columns=[[ 
			/*{field:'dic',hidden:true},
			{field:'incDesc',title:'商品名',width:150,align:'center',formatter:FormatterIncName},
			{field:'GenerName',title:'通用名',width:50,align:'center'},
			{field:'3',title:'规格',width:50,align:'center'},
			{field:'FormType',title:'剂型',width:50,align:'center'},
			{field:'Manufacturer',title:'生产企业',width:50,align:'center'},
			{field:'Ingredient',title:'成分',width:50,align:'center'},	// ,sortable :true
			{field:'6',title:'批准文号',width:50,align:'center'},
			{field:'7',title:'校准日期',width:50,align:'center'}*/
			{field:'GenerName',title:'通用名称',width:50,align:'center'},
			{field:'incDesc',title:'商品名称',width:150,align:'center',formatter:FormatterIncName},
			{field:'Indication',title:'规格',width:50,align:'center'},
			{field:'FormType',title:'剂型',width:50,align:'center'},
			{field:'AproNum',title:'批准文号',width:50,align:'center'},
			{field:'Ingredient',title:'成分',width:50,align:'center'},	// ,sortable :true
			{field:'Manufacturer',title:'厂家',width:70,align:'center'},
			{field:'HospUsed',title:'本院在用',width:40,align:'center'}
			//{field:'7',title:'校准日期',width:50,align:'center',hidden:true}	
		 ]];
		 
	$('#datagrid').datagrid({
		toolbar:"#tableTb",  //kml 2020-03-06 add 'userInfo'
		url:LINK_CSP+"?ClassName=web.DHCCKKBIndex&MethodName=List&queryCat="+$("#catId").val()+"&userInfo="+userInfo+"&code="+$("#code").val(), 
		columns:columns,
		headerCls:'panel-header-gray', 
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		striped: false, 
		pagination:true,
		rownumbers:true,
		//sortName : 'CDCode',
		//remoteSort:false, 
        //sortOrder : 'desc',
		pageSize:15,
		pageList:[15,60,90],
		onBeforeLoad:function(param){
             param.queryCat=$("#catId").val();
        },
        onLoadSuccess: function(data) {
	       
			//window.parent.resize();	
        }
	});	
}

function FormatterIncName(value,row){
	return "<a href='javascript:void(0);' onclick='goCrumbWiki("+row.id+","+$("#catId").val()+")' style='cursor: pointer;text-decoration:none;'>"+value+"</a>"
}
///查询
function query()
{
	var parStr=getParStr()
	$('#datagrid').datagrid('load',{"queryCat":$("#catId").val(),"parStr":parStr}); 
}
function getParStr(){
	var retArr=[];
	var cond=""  //$("#condCombox").combobox('getValue');
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// 条件下拉值（列名 代码）
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		
		// 输入判断值 （具体的数据）
		var columnValue=$(obj).children().eq(3).find("input")[2];
		if(columnValue!=undefined){
			columnValue=columnValue.value;
		}else{
			columnValue="";
		}
		if(columnValue==""){
			return true;	
		}
		// 取逻辑关系
		var oper=$(obj).children().eq(4).find("input")[2];
		if(oper!=undefined){
			oper=oper.value;
		}else{
			oper="";
		}
		// 列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系
		var par=column;
		par+="$"+columnValue;
		par+="$"+oper;
		//par+="$"+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}