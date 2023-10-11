//===========================================================================================
// Author：      xww
// Date:		 2021-06-18
// Description:	 处方审核记录统计
//===========================================================================================
var field="";
var locName="";				
/// 页面初始化函数
function initPageDefault(){
	initPage();
	initDateBox()
	initDataGrid();		// 页面DataGrid初始化定义
	initButton();		// 按钮响应事件初始化
	initMethod();
	initSelectTabs();
}

function initPage(){

	var heightEchart = $("#getHeightDiv").height()-30;
	
	///图标的高度
	$(".echartBody").each(function (){
		$(this).height(heightEchart);	
	})
}

function initButton(){

	$("#searchBTN").bind("click",loadDataGrid);	// 重新加载
	
	$('#addBTN').bind("click",addLoc);      // 添加科室
	
	$('#FindLoc').bind("click",FindLoc);   //点击查询
	
	$('#LocAdd').bind("click",MemAdd);     
}

function initMethod(){
	$(".tdDiv").on("click",selOrdItm);
}

function selOrdItm(){
	$(this).toggleClass("selTdDiv");
	$(".tdDiv").not(this).each(function(){
		$(this).removeClass("selTdDiv");	
	})
	commonQuery();
}

function commonQuery(locName,field,type){
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var selOrdType = $(".selTdDiv").length==0?"":$(".selTdDiv").attr("data-type");
	var lnk = "";
	if((field!="")&&(field!=undefined)){
		selOrdType="";    //如果是从下方科室列表上选择的，不判断选中类型
	}
	if(locName==undefined){
		locName="";
	}
	locName = encodeURI(encodeURI(locName));
	if((selOrdType=="mandatoryAuditNum")||(field=="mandatoryauditNum")){
		var lnk = "dhcckb.mandatoryaudit.csp?stDate="+stdate+"&edDate="+enddate+"&locName="+locName+"&type="+type;		
	}
	if((selOrdType=="prescNum")||(field=="prescNum")||(field=="submitNum")){
		var lnk = "dhcckb.prescdetail.csp?stDate="+stdate+"&edDate="+enddate+"&locName="+locName+"&type="+type;	
	}
	if((selOrdType=="modifyNum")||(field=="modifyNum")){
		var lnk = "dhcckb.modifydetail.csp?stDate="+stdate+"&edDate="+enddate+"&locName="+locName+"&type="+type;	
	}
	if((selOrdType=="auditTotalNum")||(field=="auditNum")){
		var lnk = "dhcckb.auditdrugdetail.csp?stDate="+stdate+"&edDate="+enddate+"&locName="+locName+"&type="+type;	
	}
	if((selOrdType=="errorprescNum")||(field=="errorprescNum")||(field=="errorNum")){
		var lnk = "dhcckb.errorprescdetail.csp?stDate="+stdate+"&edDate="+enddate+"&locName="+locName+"&type="+type;	
	}
	if(lnk!=""){
		websys_showModal({
			width: screen.availWidth-150,
			height:screen.availHeight-150,
			url: lnk,
			iconCls:"icon-w-paper",
			title: '审查记录明细',
			closed: true,
			onClose:function(){}
		});
	}
}


///初始化事件控件
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(-60));
	$HUI.datebox("#endDate").setValue(formatDate(0));
	
}


function initDataGrid(){

	var diccolumns=[[ 
			{field:'locName',title:'科室名称',width:100,hidden:false},
			{field:'submitNum',title:'全部处方数量',width:100,hidden:false,formatter:setCellNum},
			{field:'errorNum',title:'不合理处方数量',width:100,hidden:false,formatter:setCellNum},
			{field:'errorRate',title:'不合理率',width:100,hidden:false},
			{field:'auditNum',title:'审核药品总数',width:100,hidden:false,formatter:setCellNum},
			//{field:'prescNum',title:'全部处方数量',width:100,hidden:false,formatter:setCellNum},
			{field:'errorprescNum',title:'不合理药品数量',width:100,hidden:false,formatter:setCellNum},
			//{field:'modifyNum',title:'处方修改次数',width:100,hidden:false,formatter:setCellNum},
			
			{field:'modifyNum',title:'医生修改数',width:100,hidden:false,formatter:setCellNum},
			{field:'modifyRate',title:'医生修改率',width:100,hidden:false},
			{field:'mandatoryauditNum',title:'强制审核次数',width:100,hidden:false,formatter:setCellNum},
			{field:'mandatoryauditRate',title:'强制审核率',width:100,hidden:false},
			//{field:'auditNum',title:'审核次数',width:100,align:'left',formatter:setCellAuditNum},
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:10,
		pageList:[10,30,60]	,
		onLoadSuccess: function (data) {			  	
			$("#auditTotalNum").html(data.auditTotalNum);
			$("#prescNum").html(data.submitTotalNum);
			$("#modifyNum").html(data.modifyNum);
			$("#errorprescNum").html(data.errorprescNum);
			$("#mandatoryAuditNum").html(data.mandatoryAuditNum);
			locprescEcharts(data.rows);   //Echarts图				  	  
		 }

	}

	var stdate = $HUI.datebox("#stDate").getValue()
	var enddate = $HUI.datebox("#endDate").getValue()
	var params = stdate + "^" + enddate+"^^"+"LOC";
	var uniturl = $URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=RecipeAuditStat&params="+params;
	new ListComponent('datagrid', diccolumns, uniturl, option).Init();
	
	
	var diccolumns=[[ 
			{field:'type',title:'提示类别',width:100,hidden:false},
			{field:'totalNum',title:'提示总数',width:100,hidden:false},
			{field:'modifyNum',title:'修改次数',width:100,hidden:false},
			{field:'mandatoryauditNum',title:'比例',width:100,hidden:false},
			{field:'modifyRate',title:'强制审核次数',width:100,hidden:false},
			{field:'mandatoryauditRate',title:'比例',width:100,hidden:false},
			//{field:'auditNum',title:'审核次数',width:100,align:'left',formatter:setCellAuditNum},
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:true,
		pageSize:10,
		pageList:[10,30,60]	,
		onLoadSuccess: function (data) {			  					  	  
		 }

	}
	var uniturl = $URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=RecipeAuditTypeStat&params="+params;
	new ListComponent('typedatagrid', diccolumns, uniturl, option).Init();
	
	runClassMethod("web.DHCCKBRecipeAuditStat","GetAnalysessData",{Params:params},function(data){
			showPageImg(data);
		},"json"	
	)
	
}

function loadDataGrid(){
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var selectTab = $('#statTabs').tabs('getSelected'); // 获取当前选中的页签
	var selectTabTitle = selectTab.panel('options').title; // 获取当前选中的页签的标题
	var locInput=$("#Loc").val()
	var type = "LOC"
	if(selectTabTitle == "按医生汇总"){
		type = "Doctor"
	}
	if(selectTabTitle == "按药品汇总"){
		type = "Drug"
	}
	var params = stdate + "^" + enddate + "^" + type + "^" + locInput;
	$('#datagrid').datagrid('load',{
		params:params
	}); 
	$('#typedatagrid').datagrid('load',{
		params:params
	});
	runClassMethod("web.DHCCKBRecipeAuditStat","GetAnalysessData",
		{
			Params:params	
		},
		function(data){
			showPageImg(data);
		},"json"		
	)

}

function showPageImg(data){
	var allNumData = data.GetCheckPatNum;
	
	//var GreenPatNum = data.GreenPatNum;
	showEchartPie("promptTypeEcharts",allNumData);
	
	var GetLocModifyNum= data.GetLocModifyNum;
	if(GetLocModifyNum!=""){
		var ModifyNum=GetLocModifyNum["ModifyNum"];
		var TempArr=[],LocArr=[];
        var ModifyNumData=ModifyNum.split(",");  //字符串转数组
		var obj={};
		obj.name="修改次数";
		obj.type='bar';
		obj.data= ModifyNumData.slice(0,ModifyNumData.length);  // slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		var MandatoryAuditNum=GetLocModifyNum["MandatoryAuditNum"];
		var MandatoryAuditData=MandatoryAuditNum.split(",");  // 字符串转数组
		var obj={};
		obj.name="强制审核次数";
		obj.type='bar';
		obj.data= MandatoryAuditData.slice(0,MandatoryAuditData.length);  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		
		var locDesc=GetLocModifyNum["locDesc"];
		var LocData=locDesc.split(","); 
		var obj={};
		obj.name="科室";
		obj.type='category';
		obj.data= LocData.slice(0,LocData.length);  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		LocArr.push(obj);
		var legendArr=['修改次数','强制审核次数'];
		InitCompareECharts("locEcharts",TempArr,LocArr,legendArr)
	}
	
	
	var GetDocModifyNum= data.GetDocModifyNum;
	if(GetDocModifyNum!=""){
		var ModifyNum=GetDocModifyNum["ModifyNum"];
		var TempArr=[],LocArr=[];
        var ModifyNumData=ModifyNum.split(",");  //字符串转数组
		var obj={};
		obj.name="修改次数";
		obj.type='bar';
		obj.data= ModifyNumData.slice(0,ModifyNumData.length);  // slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		var MandatoryAuditNum=GetDocModifyNum["MandatoryAuditNum"];
		var MandatoryAuditData=MandatoryAuditNum.split(",");  // 字符串转数组
		var obj={};
		obj.name="强制审核次数";
		obj.type='bar';
		obj.data= MandatoryAuditData.slice(0,MandatoryAuditData.length);  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		var legendArr=["修改次数","强制审核次数"];
		var locDesc=GetDocModifyNum["locDesc"];
		var LocData=locDesc.split(","); 
		var obj={};
		obj.name="医生";
		obj.type='category';
		obj.data= LocData.slice(0,LocData.length);  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		LocArr.push(obj);
		var legendArr=["修改次数","强制审核次数"];
		InitCompareECharts("docEcharts",TempArr,LocArr,legendArr)
	}
	
	var RecipeAuditYoYNum= data.RecipeAuditYoYNum;
	if((RecipeAuditYoYNum!="")&&(RecipeAuditYoYNum!=undefined)){
		var curData=RecipeAuditYoYNum["curData"]; 	//今年数据
		var TempArr=[],levArr=[];
        var curDataArr=curData.split(",");  		//字符串转数组
        var YearStrData=RecipeAuditYoYNum["YearStr"];
        var YearStrArr=YearStrData.split(",");
		var obj={};
		obj.name=YearStrArr[0];
		obj.type='bar';
		obj.data= curDataArr.slice(0,curDataArr.length); 	// slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		var lastData=RecipeAuditYoYNum["lastData"];  		// 去年数据
		var lastDataArr=lastData.split(",");  				// 字符串转数组
		var obj={};
		obj.name=YearStrArr[1];
		obj.type='bar';
		obj.data= lastDataArr.slice(0,lastDataArr.length);  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		var lastMonthData=RecipeAuditYoYNum["lastMonthData"];   	 	// 去年数据
		var lastMonthArr=lastData.split(","); 				 // 字符串转数组
		var obj={};
		obj.name=YearStrArr[2];
		obj.type='bar';
		obj.data= lastMonthArr.slice(0,lastMonthArr.length);  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempArr.push(obj);
		var levNum=RecipeAuditYoYNum["levNum"];
		var levData=levNum.split(","); 
		var obj={};
		obj.name="类别";
		obj.type='category';
		obj.data= levData.slice(0,levData.length);  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		levArr.push(obj);
		InitCompareECharts("YoYEcharts",TempArr,levArr,YearStrArr)
		
		
		//强制审核柱状图
		var curAuditData=RecipeAuditYoYNum["curAuditData"]; 	//今年数据
		var TempAuditArr=[];
        var curAuditDataArr=curAuditData.split(",");  		//字符串转数组
 
		var obj={};
		obj.name=YearStrArr[0];
		obj.type='bar';
		obj.data= curAuditDataArr.slice(0,curAuditDataArr.length); 	// slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempAuditArr.push(obj);
		var lastAuditData=RecipeAuditYoYNum["lastAuditData"];  		// 去年数据
		var lastAuditDataArr=lastData.split(",");  					// 字符串转数组
		var obj={};
		obj.name=YearStrArr[1];
		obj.type='bar';
		obj.data= lastAuditDataArr.slice(0,lastAuditDataArr.length);  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempAuditArr.push(obj);
		var lastMonthAuditData=RecipeAuditYoYNum["lastMonthAuditData"];   	 // 去年数据
		var lastMonthAuditArr=lastMonthAuditData.split(","); 				 // 字符串转数组
		var obj={};
		obj.name=YearStrArr[2];
		obj.type='bar';
		obj.data= lastMonthAuditArr.slice(0,lastMonthAuditArr.length); 		 //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempAuditArr.push(obj);
		InitCompareECharts("AuditTypeEcharts",TempAuditArr,levArr,YearStrArr)
	}
	
	var QuestionTypeNum= data.QuestionTypeNum;
	if(QuestionTypeNum!=""){
		var curData=QuestionTypeNum["ModifyData"]; 	//修改数据
		var TempArr=[],levArr=[];
        var curDataArr=curData.split(",");  			//字符串转数组
        var YearStrData=QuestionTypeNum["ProblemStr"];
        var YearStrArr=YearStrData.split(",");
        var ModifyLocData=QuestionTypeNum["ModifyLocStr"];
        var ModifyLocStr=ModifyLocData.split(",");
        var Modifylength=ModifyLocStr.length
        for(var i =0;i<YearStrArr.length;i++){ 
           	var obj={};
			obj.name=YearStrArr[i];
			obj.type='bar';
			obj.data= curDataArr.slice((i*Modifylength),((i+1)*Modifylength));  // slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
			TempArr.push(obj);
		}
         
		var obj={};
		obj.name="科室";
		obj.type='category';
		obj.data=ModifyLocStr;  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		levArr.push(obj);
		InitCompareECharts("questionTypeEcharts",TempArr,levArr,YearStrArr)
		
		
		var MandatoryAuditData=QuestionTypeNum["MandatoryAuditData"]; 	//修改数据
		var TempAuditArr=[],levAuditArr=[];
        var MandatoryAuditArr=MandatoryAuditData.split(",");  			//字符串转数组
        var YearStrData=QuestionTypeNum["ProblemStr"];
        var YearStrArr=YearStrData.split(",");
        var MandatoryAuditLocData=QuestionTypeNum["MandatoryAuditLocStr"];
        var MandatoryAuditLocStr=MandatoryAuditLocData.split(",");
        var ModifyAuditlength=MandatoryAuditLocStr.length
		for(var j =0;j<YearStrArr.length;j++){ 
           	var obj={};
			obj.name=YearStrArr[j];
			obj.type='bar';
			obj.data= MandatoryAuditArr.slice((j*ModifyAuditlength),((j+1)*ModifyAuditlength));  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
			TempAuditArr.push(obj);
		}
         
		var obj={};
		obj.name="科室";
		obj.type='category';
		obj.data=MandatoryAuditLocStr;  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		levAuditArr.push(obj);
		InitCompareECharts("questionAuditTypeEcharts",TempAuditArr,levAuditArr,YearStrArr)
		
		//强制审核柱状图
		/*var curAuditData=RecipeAuditYoYNum["curAuditData"]; 	//今年数据
		var TempAuditArr=[];
        var curAuditDataArr=curAuditData.split(",");  		//字符串转数组
 
		var obj={};
		obj.name=YearStrArr[0];
		obj.type='bar';
		obj.data= curAuditDataArr.slice(0,curAuditDataArr.length); 	// slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempAuditArr.push(obj);
		var lastAuditData=RecipeAuditYoYNum["lastAuditData"];  		// 去年数据
		var lastAuditDataArr=lastData.split(",");  					// 字符串转数组
		var obj={};
		obj.name=YearStrArr[1];
		obj.type='bar';
		obj.data= lastAuditDataArr.slice(0,lastAuditDataArr.length);  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempAuditArr.push(obj);
		var lastMonthAuditData=RecipeAuditYoYNum["lastMonthAuditData"];   	 // 去年数据
		var lastMonthAuditArr=lastMonthAuditData.split(","); 				 // 字符串转数组
		var obj={};
		obj.name=YearStrArr[2];
		obj.type='bar';
		obj.data= lastMonthAuditArr.slice(0,lastMonthAuditArr.length); 		 //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
		TempAuditArr.push(obj);
		InitCompareECharts("AuditTypeEcharts",TempAuditArr,levArr,YearStrArr)*/
	}
	
}


function showEchartBars(idName,data){
	var option = ECharts.ChartOptionTemplates.Bars(data); 
	option.title ={
		
	}
	
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(idName,data){
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}


function InitCompareECharts(idName,TempArr,DataArr,legendArr,title){

	option = {
		dataZoom: [
   
    {
        type: 'slider',
        show: true,
        realtime:true,
        xAxisIndex:[0],
        bottom:10,
        start: 0,
        end: 50
        
    }
],
    	title : {
        	text:title||'',
        	x:'center'
       
    	},
	    tooltip: {
	        trigger: 'axis'
	    },
	    
	   legend: {
              data:legendArr, /*['修改次数','强制审核次数'],*/
              x:100,
              y:20
       },
      
  
	    toolbox: {
	        show: true,
	        feature: {
		        mark : { show: true }, //画线
                    //dataView: { show: true, readOnly: false }, //数据预览
                    restore : { show: true }, //复原
                   // saveAsImage : { show: true } //是否保存图片
	            /* dataZoom: {
	                yAxisIndex: 'none'
	            },
	            dataView: {readOnly: false}, */
	            magicType: {show: true,type: ['line', 'bar']},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
    	calculable : true,
    	xAxis : DataArr,/*[
        	{
	        	name:$g("月份"),
            	type : 'category',
            	data : [$g("1月"),$g("2月"),$g("3月"),$g("4月"),$g("5月"),$g("6月"),$g("7月"),$g("8月"),$g("9月"),$g("10月"),$g("11月"),$g("12月")]  //,"合计"
        	}
    	],*/
    	yAxis : [
        {
            type : 'value',
            name:"数量",
            //nameLocation:'middle',
            nameTextStyle:{
	            padding: [-10,-10,-10,10]
	      }
        }
    	],
    	series :TempArr
   	 }
   	 //MonQuartCompare=echarts.init(document.getElementById('MonQuartCompare'));
	//MonQuartCompare.clear();
    // MonQuartCompare.setOption(option);
   	 var container = document.getElementById(idName);
   	 var opt=echarts.init(container);
   	 opt.clear();
   	 opt.setOption(option);
	 //opt = ECharts.ChartConfig(container, option);
	 //ECharts.Charts.RenderChart(opt);
   	 
	
}


//获取审核明细信息
/* function showAuditDetail(regNo,stDate,edDate,locName){ 			
	var lnk = "dhcckb.recipeauditdetail.csp?regNo="+regNo+"&stDate="+stDate+"&edDate="+edDate+"&locName="+encodeURI(encodeURI(locName));	
	websys_showModal({
		width: window.screen.availWidth-50,
		height:window.screen.availHeight-100,
		url: lnk,
		iconCls:"icon-w-paper",
		title: '审查记录明细',
		closed: true,
		onClose:function(){}
	});
	
}

function setCellAuditNum(value, rowData, rowIndex){
	return '<a href="#" style="text-decoration:underline" onclick="showAuditDetail(\''+rowData.regNo+'\',\''+rowData.stDate+'\',\''+rowData.endDate+'\',\''+rowData.locName+'\')">&nbsp;'+value+'&nbsp;</a>';

} */

//科室审核数量Echarts图
function locprescEcharts(data){
	var TempArr=[],LocArr=[];
	var submitNumArr=[],errorprescNumArr=[],locDescArr=[];
	for (var i=0;i<data.length;i++){		
		var LocDesc=data[i].locName;		 // 科室名称·
		var submitNum=data[i].submitNum;     // 全部提交的处方
		var errorprescNum=data[i].errorprescNum // 不合理处方 
		submitNumArr.push(submitNum);
		errorprescNumArr.push(errorprescNum);
		locDescArr.push(LocDesc);
	}
	var obj={};
	obj.name="处方总数";
	obj.type='bar';
	obj.data= submitNumArr;  // slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	var obj={};
	obj.name="不合理处方数";
	obj.type='bar';
	obj.data= errorprescNumArr;  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);

	var obj={};
	obj.name="科室";
	obj.type='category';
	obj.data= locDescArr;  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	
	LocArr.push(obj);
	var legendArr=['处方总数','不合理处方数'];
	InitCompareECharts("locprescEcharts",TempArr,LocArr,legendArr,"科室审核情况统计图")
}

function setCellNum(value, rowData, rowIndex){
	return '<a href="#" style="" onclick="commonQuery(\''+rowData.locName+'\',\''+this.field+'\',\''+'Loc'+'\')">&nbsp;'+value+'&nbsp;</a>';
}

function setDocCellNum(value, rowData, rowIndex){
	return '<a href="#" style="" onclick="commonQuery(\''+rowData.locName+'\',\''+this.field+'\',\''+'Doc'+'\')">&nbsp;'+value+'&nbsp;</a>';
}

function initSelectTabs(){
	
	$HUI.tabs("#statTabs",{
		onSelect:function(title){	
			if ((title=="按医生汇总")){				 		
				  initDocDatagrid();        
			}else if(title=="按药品汇总"){				
				  initDrugDatagrid();      
			}else{
				loadDataGrid();
			}
		}
	}); 
}

function initDocDatagrid(){

	var diccolumns=[[ 
			{field:'locName',title:'医生名称',width:100,hidden:false},
			{field:'submitNum',title:'全部处方数量',width:100,hidden:false,formatter:setDocCellNum},
			{field:'errorNum',title:'不合理处方数量',width:100,hidden:false,formatter:setDocCellNum},
			{field:'errorRate',title:'不合理率',width:100,hidden:false},
			{field:'auditNum',title:'审核药品总数',width:100,hidden:false,formatter:setDocCellNum},
			//{field:'prescNum',title:'全部处方数量',width:100,hidden:false,formatter:setCellNum},
			{field:'errorprescNum',title:'不合理药品数量',width:100,hidden:false,formatter:setDocCellNum},
			//{field:'modifyNum',title:'处方修改次数',width:100,hidden:false,formatter:setCellNum},
			
			{field:'modifyNum',title:'医生修改数',width:100,hidden:false,formatter:setDocCellNum},
			{field:'modifyRate',title:'医生修改率',width:100,hidden:false},
			{field:'mandatoryauditNum',title:'强制审核次数',width:100,hidden:false,formatter:setDocCellNum},
			{field:'mandatoryauditRate',title:'强制审核率',width:100,hidden:false},
			//{field:'auditNum',title:'审核次数',width:100,align:'left',formatter:setCellAuditNum},
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:10,
		pageList:[10,30,60]	,
		onLoadSuccess: function (data) {			  	
			docprescEcharts(data.rows);	  
		 }

	}

	var stdate = $HUI.datebox("#stDate").getValue()
	var enddate = $HUI.datebox("#endDate").getValue()
	var params = stdate + "^" + enddate+"^"+"Doctor";
	var uniturl = $URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=RecipeAuditStat&params="+params;
	new ListComponent('docdatagrid', diccolumns, uniturl, option).Init();
}

//医生审核数量Echarts图
function docprescEcharts(data){
	var TempArr=[],LocArr=[];
	var submitNumArr=[],errorprescNumArr=[],locDescArr=[],modifyNumArr=[],mandatoryauditNumArr=[];
	for (var i=0;i<data.length;i++){		
		var LocDesc=data[i].locName;		 	// 科室名称·
		var submitNum=data[i].submitNum;     	// 全部提交的处方
		var errorprescNum=data[i].errorprescNum // 不合理处方 
		var modifyNum=data[i].modifyNum;     	// 修改数
		var mandatoryauditNum=data[i].mandatoryauditNum // 强制审核次数 
		submitNumArr.push(submitNum);
		errorprescNumArr.push(errorprescNum);
		locDescArr.push(LocDesc);
		modifyNumArr.push(modifyNum);
		mandatoryauditNumArr.push(mandatoryauditNum);
	}
	var obj={};
	obj.name="处方总数";
	obj.type='bar';
	obj.data= submitNumArr;  // slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	var obj={};
	obj.name="不合理处方数";
	obj.type='bar';
	obj.data= errorprescNumArr;  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	var obj={};
	obj.name="修改数";
	obj.type='bar';
	obj.data= modifyNumArr;  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	var obj={};
	obj.name="强制审核数";
	obj.type='bar';
	obj.data= mandatoryauditNumArr;  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	var obj={};
	obj.name="医生";
	obj.type='category';
	obj.data= locDescArr;  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	LocArr.push(obj);
	var legendArr=['处方总数','不合理处方数','修改数','强制审核数'];
	InitCompareECharts("docprescEcharts",TempArr,LocArr,legendArr,"医生处方情况统计图")
}


function initDrugDatagrid(){

	var diccolumns=[[ 
			{field:'drugName',title:'药品名称',width:200,hidden:false},
			{field:'totalNum',title:'药品数量',width:100,hidden:false},
			{field:'errorNum',title:'不合理药品数量',width:100,hidden:false},
			{field:'errorRate',title:'不合理率',width:100,hidden:false},
			//{field:'auditNum',title:'不合理药品所在处方数',width:100,hidden:false,formatter:setCellNum},
			//{field:'prescNum',title:'全部处方数量',width:100,hidden:false,formatter:setCellNum},
			//{field:'errorprescNum',title:'不合理药品数量',width:100,hidden:false,formatter:setCellNum},
			//{field:'modifyNum',title:'处方修改次数',width:100,hidden:false,formatter:setCellNum},
			
			//{field:'modifyNum',title:'医生修改数',width:100,hidden:false,formatter:setCellNum},
			//{field:'modifyRate',title:'医生修改率',width:100,hidden:false},
			//{field:'mandatoryauditNum',title:'强制审核次数',width:100,hidden:false,formatter:setCellNum},
			//{field:'mandatoryauditRate',title:'强制审核率',width:100,hidden:false},
			//{field:'auditNum',title:'审核次数',width:100,align:'left',formatter:setCellAuditNum},
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:10,
		pageList:[10,30,60]	,
		onLoadSuccess: function (data) {			  	
			drugprescEcharts(data.rows);	  
		 }

	}

	var stdate = $HUI.datebox("#stDate").getValue()
	var enddate = $HUI.datebox("#endDate").getValue()
	var params = stdate + "^" + enddate+"^"+"Drug";
	var uniturl = $URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=RecipeAuditStat&params="+params;
	new ListComponent('drugdatagrid', diccolumns, uniturl, option).Init();
}

//医生审核数量Echarts图
function drugprescEcharts(data){
	var TempArr=[],LocArr=[];
	var totalNumArr=[],errorprescNumArr=[],locDescArr=[];
	for (var i=0;i<data.length;i++){		
		var LocDesc=data[i].drugName;		 	// 科室名称·
		var totalNum=data[i].totalNum;     	// 全部提交的处方
		var errorprescNum=data[i].errorNum // 不合理药品
		totalNumArr.push(totalNum);
		errorprescNumArr.push(errorprescNum);
		locDescArr.push(LocDesc);
	}
	var obj={};
	obj.name="药品总数";
	obj.type='bar';
	obj.data= totalNumArr;  // slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	var obj={};
	obj.name="不合理药品数";
	obj.type='bar';
	obj.data= errorprescNumArr;  //  slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	TempArr.push(obj);
	
	var obj={};
	obj.name="药品名称";
	obj.type='category';
	obj.data= locDescArr;  //   slice(start,end) 返回一个新的数组，包含从 start 到 end （不包括该元素）的数组中的元素。 
	obj.axisLabel = {//坐标轴刻度标签的相关设置。	
        formatter: function(params) {
        var newParamsName = ''
        var paramsNameNumber = params.length
        var provideNumber = 8
        var rowNumber = Math.ceil(paramsNameNumber / provideNumber)
        for (var row = 0; row <rowNumber; row++) {
          newParamsName +=
            params.substring(
              row * provideNumber,
              (row + 1) * provideNumber
            ) + '\n'
        }
        return newParamsName
      },
		interval:0
    }
	LocArr.push(obj);
	var legendArr=['药品总数','不合理药品数'];
	InitCompareECharts("drugprescEcharts",TempArr,LocArr,legendArr,"药品情况统计图")
}


//增加科室窗口
function addLoc()
{
	$('#locwin').show();
	$('#locwin').window({
	   title:'科室信息',
	   collapsible:true,
	   border:false,
	   closed:"true",
	   modal:true,
	   top:100,
	   width:500,
	   height:400
	 }); 
    $('#locwin').window('open');
    //$("#UserNames").val("");
    InitLocGrid() ;      
}

function InitLocGrid()
{
	//定义columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'LocID',title:'科室ID',width:100},
		 {field:'LocDesc',title:'科室名称',width:200}
		]];
	
	//定义datagrid
	$('#locTable').datagrid({
		url:$URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=GetAllLoc&hospID="+LgHospID+"&input="+"",
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,400],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		selectOnCheck:true,
		onUnselect:function(rowIndex, rowData)
		{
			var LocDesc=$("#LocDescStr").val();
			var Loc =rowData.LocDesc
             if(LocDesc.indexOf(Loc) != -1)
             {
	             LocDesc=LocDesc.replace(Loc+"，","")
	             $("#LocDescStr").val(LocDesc);
             }
		},
		 onSelect:function(rowIndex, rowData)
		 {
	       var LocDesc = rowData.LocDesc
	       MeetMember(LocDesc)
		 },	
	});	
	//$(".datagrid-header-check input[type=checkbox]").on("click",function(){ ///2018-04-13 cy 评价界面
	//	AllMember();
	//})
}

//选择参会人员
function MeetMember(name)
{
	if(name==""){
	  $("#LocDescStr").val("");
	}
	LocDesc=$("#LocDescStr").val();
    if(LocDesc.indexOf(name) != -1){
	    return true;  
    }
	if(LocDesc==""){
	  LocDesc=name+"，";
	}else{
	  LocDesc=LocDesc+name+"，";
	}
	$("#LocDescStr").val(LocDesc);		
}
function AllMember(){
	var rows = $("#user").datagrid('getSelections');
	if(rows.length==0){
		$("#UserNames").val("");
	}
	var userNames="";
	for(var i=0;i<rows.length;i++){
		if(userNames==""){
			userNames=rows[i].userName+"，";
		}else{
			userNames=userNames+rows[i].userName+"，";
		}
		
	}
	$("#UserNames").val(userNames);
	//MeetMember(userNames) ;
}

//查询
function FindLoc()
{
	//1、清空datagrid 
	$('#locTable').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var LocDesc=$("#LocDesc").val();
	$('#locTable').datagrid({
		url:$URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=GetAllLoc",
		queryParams:{
			hospID:LgHospID,
			input:LocDesc
		}	
	});
}

//添加到科室
function MemAdd()
{
  var LocDesc=$("#LocDescStr").val()
  $("#Loc").val(LocDesc)	
  $('#locwin').window('close');
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
