///qqa
///2017-12-14
///
$(function (){
	initParam();
	
	initCombobox();
	
	initDateBox();
	
	initMehtod();
	
	initDatagrid();
	
	initPageDomDis();
})

///初始化所有参数
function initParam(){
	//存放图像加载的数据
	globleImgData={
		dataX:"",
		dataY:"",
		data:""	
	};
	
	globleTableData={rows:[],totle:0};	
	
	globleAllTableData=[];   //存放数据
	
	///数据统计中全部统计设计全局变量
	statAllDataObj={
		column:[],
		data:[],
		exportData:[],
		stDate:"",
		endDate:""
	}
	
	statDataType="";  //当前统计标志
	
	runClassMethod("web.DHCADVStatisticsDhcadv","InitColumnData",{},
		function (data){
						
		}
	)
}

///初始化table
function initDatagrid(){
	
	
		
}

function initDataGrid(params){

	var pid = params.split("^")[0];
	var columNum= params.split("^")[1];
	var colArray=[];
	for(i=1;i<=columNum;i++){
		dymObj={};
		dymObj.field="field"+i;
		dymObj.align="center";
		dymObj.title="值"+(i-1);
		colArray.push(dymObj);
	}
	
	var columns=[];
	columns.push(colArray);
	
	// 定义datagrid
	$('#reportDataTable').datagrid({
		title:'',
		url:LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=GetTabeData", //huaxiaoying 2017-1-4 规范名字
		queryParams:{
			pid:pid
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    showHeader:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onLoadSuccess:function(data){
			globleTableData = data;
		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
           
        }
	});
}

function initMehtod(){
	//$("a:contains('生成报表')").on("click",initReportDatagrid);
	
	//$("a:contains('导出报表')").on("click",exportExcelStatic);
	
	$("#createRep").on("click",initReportDatagrid);//hxy 2018-03-07
	$("#exportRep").on("click",exportExcelStatic); //hxy
	
	$(".statImgType").on("click",setSelImgType);
}

function setSelImgType(){
	$(".statImgType").not(this).each(function(){
		$(this).removeClass("selStatImgType");	
	})
	if(!$(this).hasClass("selStatImgType")){
		$(this).toggleClass("selStatImgType");	
	}
	
	showEchart($(".selStatImgType").attr("data-type"))
	
}
//getBeforeYearDate()
///初始化下拉款
function initDateBox(){
	$("#stDate").datebox("setValue",getBeforeYearDate());
	
	$("#endDate").datebox("setValue",getCurrentDate());	
}

function initCombobox(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			resetTableAndComboBox();
			setDisOrEnaDom(option.value);			
	    }
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       setBtnDisOrEnab();
	    }
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statTypeX",url,'',option).init();
	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       setBtnDisOrEnab();
	    }
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statTypeY",url,'',option).init();
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       reloadComboboxDataType(option.value);
	    },
	    onChange:function(newValue,oldValue){
		    if(newValue==""){
			   //设置第四个未人次
			   reloadComboboxDataType("");
			}
		}
	};
	
	var url = uniturl+"JsonGetComboDataForStatFieldNoDate&FormNameID=''";
	new ListCombobox("statData",url,'',option).init();
	
	var uniturl = "";
	var option = {
		valueField:'value',
		textField:'text',
		onLoadSuccess:function(){
			var val = $(this).combobox("getData");
			$(this).combobox("select",val[0].value);
		}
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statType",url,'',option).init();
	
	
	reloadComboboxDataType("");
}

//这个是核心方法：
//分为获取column和数据
function initReportDatagrid(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?0:$("#reportType").combobox("getValue"));
	
	/*
	if(formNameID==0){
		//这个是全部的情况,统计的内容为Master表中的数据
		initAllReportTable();
		statDataType="ALL";    //这个决定导出数据是全部还是特定的类型
	}else{
		//这个是单一类型生成统计报表
		initReportTable();
		statDataType="";	
	}
	*/
	
	initAllReportTable();
	statDataType="ALL";    //这个决定导出数据是全部还是特定的类型
}

function getValue(statTypeID,allNumber,value){
	if(allNumber!=0){
		if(statTypeID==2){
			value = parseInt(value/allNumber*100)+"%";
		}else if(statTypeID==3){
			value = value+"/"+parseInt(value/allNumber*100)+"%";
		}
	}else{
		value=0;
	}	
	return value;
}

///点击某个单元格的时候统计出左侧的图表
function allReportClickStat(fieldName){
	globleImgData.dataX="";
	globleImgData.dataY="";
	globleImgData.data="";
	var statData = statAllDataObj.data;
	statCellObj={};
	for (i in statData){
		var data = 	statData[i];
		var fieldValue = (data[fieldName]==""?"":data[fieldName]);
		var fieldValue = (data[fieldName]==undefined?"":data[fieldName]);
		if(statCellObj[fieldValue]==undefined){
			statCellObj[fieldValue]=1;	
		}else{
			statCellObj[fieldValue] = statCellObj[fieldValue]+1;	
		}
		//statCellObj[fieldValue]="";   //这个对象用来记录并生成datagrid的column
	}
	
	globleImgData.dataX = [];
	
	for (var objName in statCellObj){
		var dymObj = {};
		dymObj["name"] =objName;
		dymObj["group"] ="";
		dymObj["value"] =statCellObj[objName];
		globleImgData.dataX.push(dymObj);
	}
	showEchart("X");
}


///初始化统计所有数据表格内容** 所有统计走前台控制，并不多次走后台
///
function initAllReportTable(){
	var statData = statAllDataObj.data; 
	var stDate = statAllDataObj.stDate;    //开始时间
	var endDate = statAllDataObj.endDate;  //结束时间
	var statDataID = ($("#statData").combobox("getValue")==undefined?"":$("#statData").combobox("getValue"));   //统计数据
	var statTypeInfo = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));   //人次、率、人次+率
	
	var statTypeDesc = ""
	var statTypeID=1
	if(statTypeInfo!="") statTypeID=statTypeInfo.split("^")[1];
	if(statTypeInfo!="") statTypeDesc=statTypeInfo.split("^")[0];    //最后一项
	
	if( statData.length==0){
		$.messager.alert("提示","没有待统计数据！");
		return;
	}
	
	var dateXString="",dateXArr="",dateYString="",dateYArr="";
	
	
	///获取统计类型，需要区分是否是时间类型
	var statTypeXInfo = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue"));  //这个是X,json对象的name
	var statTypeXDesc = ($("#statTypeX").combobox("getText")==undefined?"":$("#statTypeX").combobox("getText"));  //X描述
	var statTypeX = statTypeXInfo.split("^")[0];
	var statTypeXDate="";
	if(statTypeXInfo.indexOf("^")!="-1"){
		statTypeXDate = statTypeXInfo.split("^")[1];	   //X选中内容为时间类型
	}
	var statTypeYInfo = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue"));  //这个是Y
	var statTypeYDesc = ($("#statTypeY").combobox("getText")==undefined?"":$("#statTypeY").combobox("getText"));  //Y描述
	var statTypeY = statTypeYInfo.split("^")[0];
	var statTypeYDate = "";
	if(statTypeYInfo.indexOf("^")!="-1"){
		statTypeYDate = statTypeYInfo.split("^")[1];	
	}
	if((statTypeX=="")||(statTypeY=="")) {
		$.messager.alert("提示","统计横向和纵向不能为空！");
		return;	
	};
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));
	var datagridColumX={},datagridColumY={},datagridColumNum = {},datagridData=[];  ///datagridColum作用:用来记录datagrid的column生成列内容
	
	//过滤用来获取column非时间元素
	if(statTypeXDate===""){
		for (i in statData){
			var data = 	statData[i];    
			var typeX = ((data[statTypeX]==""||data[statTypeX]==undefined)?"":data[statTypeX]);
			datagridColumX[typeX]="";   //这个对象用来记录并生成datagrid的column
		}
	}else if(statTypeXDate!==""){
		dateXString = getDateInterval(stDate,endDate,statTypeXDate);   //开始时间，结束时间，时间间隔
		dateXArr = dateXString.split("^");   //获取时间数组
		for (var i in dateXArr){
			var typeX = dateXArr[i];
			datagridColumX[typeX]="";   //这个对象用来记录并生成datagrid的column
		}
		
		
	}

	//Y时间元素获取
	if(statTypeYDate!==""){
		dateYString = getDateInterval(stDate,endDate,statTypeYDate);   //开始时间，结束时间，时间间隔
		dateYArr = dateYString.split("^");
	}
	

	//获取columns
	var allDataColumns=[],allDataArray=[],count=1,myDymObj={};
	myDymObj.field="field"+count;  //这个push用来设置第一个位置保留给统计
	myDymObj.align="center";
	myDymObj.title="";
	allDataArray.push(myDymObj);
	count=count+1
	for (objName in datagridColumX){
		var myDymObj={};
		myDymObj.field="field"+count;
		myDymObj.align="center";
		myDymObj.title=objName;
		
		if((objName=="undefined")&&(statTypeX=="")){    //X未选内容,只统计合计
			myDymObj.hidden=true;
		}
		allDataArray.push(myDymObj);
		count=count+1;
	}
	var myDymObj={};			//最后一列为统计
	myDymObj.field="field"+count;
	myDymObj.align="center";
	myDymObj.title="合计";
	allDataArray.push(myDymObj);
	allDataColumns.push(allDataArray);   //这个就是datagrid的columns

	//Y轴时间操作,显示Y轴列操作
	for(i in dateYArr){
		datagridColumY[dateYArr[i]]={};
		datagridColumNum[dateYArr[i]]={};
	}
	
	//过滤用来获取column
	for (i in statData){
		var data = 	statData[i];
		var typeY = (data[statTypeY]==""?"":data[statTypeY]);
		var typeX = (data[statTypeX]==""?"":data[statTypeX]);   //XY确定一个单元格
		var typeY = (data[statTypeY]==undefined?"":data[statTypeY]);
		var typeX = (data[statTypeX]==undefined?"":data[statTypeX]);   //XY确定一个单元格
		if(statTypeYDate!==""){						//时间Y轴获取
			typeY=formatDateType(typeY,dateYString)
		}
		
		//必须设置对象，不然undefined报错
		if(datagridColumNum[typeY]==undefined){
			datagridColumNum[typeY]={};   //设置成对象
		}
	
		datagridColumY[typeY]="";    //列
		
		if((statDataID==="")|((statDataID!=="")&(isHasData(data,statTypeDesc)))){
			if(statTypeXDate===""){      //非时间
				if(datagridColumNum[typeY][typeX]==undefined){
					datagridColumNum[typeY][typeX]=1;
				}else{
					datagridColumNum[typeY][typeX]=datagridColumNum[typeY][typeX]+1;   //这个数量是走单元格数量
				}
			}else if(statTypeXDate!==""){ //时间
				typeX = formatDateType(typeX,dateXString);   //qqa方法返回按照时间统计的,时间存在位置
				if(datagridColumNum[typeY][typeX]==undefined){
					datagridColumNum[typeY][typeX]=1;
				}else{
					datagridColumNum[typeY][typeX]=datagridColumNum[typeY][typeX]+1;   //这个数量是走单元格数量
				}
			}
		}
	}
	
	datagridColumY["合计"]="";
	datagridColumNum["合计"]={};

	//获取合计列数据
	var dataNumberXYX={},dataNumberXYY={},allNumber=0;    //用来记录合计数量,allNumber(所有数量)
	for (typeYName in datagridColumY){
		for (typeXName in datagridColumX){
			//判断众多undefined的情况
			if(dataNumberXYY[typeYName]==undefined) dataNumberXYY[typeYName]=0;
			if(dataNumberXYX[typeXName]==undefined) dataNumberXYX[typeXName]=0;
			if(datagridColumNum[typeYName][typeXName]==undefined) {
				datagridColumNum[typeYName][typeXName]=0;	
			}
			allNumber = allNumber+datagridColumNum[typeYName][typeXName];
			dataNumberXYX[typeXName] = dataNumberXYX[typeXName]+datagridColumNum[typeYName][typeXName];  //某列的合计
			dataNumberXYY[typeYName] = dataNumberXYY[typeYName]+datagridColumNum[typeYName][typeXName];  //行的合计
		}
	}
	dataNumberXYY["合计"] = allNumber;
	//设置加载数据
	var datas=[];  //dataNumberXY 用来记录X方向合计合Y方向合计
	for (typeYName in datagridColumY){           
		var dymObj={},count=1;									   //Y没有选择,统计合计
		dymObj["field"+count] = typeYName;
		count = count+1;
		for (typeXName in datagridColumX){			
			if(typeYName==="合计"){
				dymObj["field"+count] = getValue(statTypeID,allNumber,dataNumberXYX[typeXName]);  //最后一行的值
				count = count+1;		
			}else{
				dymObj["field"+count] = getValue(statTypeID,allNumber,datagridColumNum[typeYName][typeXName]);
				count = count+1
			}
		}
		
		dymObj["field"+count] = getValue(statTypeID,allNumber,dataNumberXYY[typeYName]);  //最后一列的值
		datas.push(dymObj);
	}
	
	//设置导出数据
	statAllDataObj.exportData = datas.slice(0,datas.length); //浅copy
	var exportDymObj={},count=1;
	exportDymObj["field"+count] = "";
	count=count+1;
	for (objName in datagridColumX){
		exportDymObj["field"+count] = objName;
		count=count+1;
	}
	exportDymObj["field"+count] = "合计";
	statAllDataObj.exportData.unshift(exportDymObj); //第一行就是表格的表头
	
	
	//ALL设置右侧图表显示数据,数据格式[{"name":"否","group":"此事件是否有堵漏行为","value":"1"},{"name":"是","group":"此事件是否有堵漏行为","value":"1"}]
	globleImgData.dataX=[];
	globleImgData.dataY=[];
	
	for (objName in datagridColumX){
		//objName = (objName=="undefined"?"合计":objName);
		var dymObj={};
		if (objName=="undefined") continue;
		
		dymObj["name"] =objName;
		//if(objName=="undefined"){
		//	dymObj["name"] = "合计";
		//}
		dymObj["group"] =statTypeXDesc;
		dymObj["value"] =dataNumberXYX[objName];
		globleImgData.dataX.push(dymObj);
	}
	
	for (objName in datagridColumY){
		if("合计"==objName) continue;
		var dymObj={};
		dymObj["name"] =objName;
		dymObj["group"] =statTypeYDesc;
		dymObj["value"] =dataNumberXYY[objName];
		globleImgData.dataY.push(dymObj);	

	}
		
	showEchart("X");  //显示图形
	
	
	//显示数据
	showAllReport(allDataColumns,datas);
	
	return ;
}

function isHasData(data,itmNames){
	var ret=false;
	if(itmNames=="") ret = true;
	var fieldName = "";
	for(var i =0;i<itmNames.split("#").length;i++){
		fieldName  = itmNames.split("#")[i];
		if((data[fieldName]!="")&&(data[fieldName]!=undefined)){
			ret = true;	
		}
	}
	return ret;
}

///初始化统计数据表格
function initReportTable(){
	$("#dataTableAll").hide();
	$("#dataTablePort").show();
	
	var formID = $("#reportType").datebox("getValue")
	var stDate = $("#stDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	var statTypeX = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue"));
	var statTypeY = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue"));
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	var statData = ($("#statData").combobox("getValue")==undefined?"":$("#statData").combobox("getValue"));
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));
	
	if(formID==""){
		$.messager.alert("提示","报告类型不能为空");
		return ;
	}
	
	if(statTypeX==""){
		$.messager.alert("提示","统计X轴数据类型不能为空");
		return ;
	}
	
	//if(statTypeY==""){
	//	$.messager.alert("提示","统计Y轴数据类型不能为空");
	//	return ;
	//}
	
	if(statType=="") {
		$.messager.alert("提示","统计类型不能为空");
		return ;	
	}
	
	var Params = stDate+"#"+endDate+"#"+statTypeY+"#"+statTypeX+"#"+formNameID+"#"+statType  //这个column就是你二次循环内容
	
	runClassMethod("web.DHCADVStatisticsDhcadv","JsonListDataTable",{Params:Params},
		function(ret){
			initDataGrid(ret);
			initEchart(ret.split("^")[0],$("#statTypeX").combobox("getText"),$("#statTypeY").combobox("getText"));
		},
	"text",false) 	
}



function initEchart(pid,DicXDesc,DicYDesc){
	alert(pid+":"+DicXDesc+":"+DicYDesc);
	runClassMethod("web.DHCADVStatisticsDhcadv","GetTabeImgDataAll",{pid:pid,DicXDesc:DicXDesc,DicYDesc:DicYDesc},
		function(ret){
			globleImgData.dataX=ret.DataX;
			globleImgData.dataY=ret.DataY;
			globleImgData.data=ret.Data;
			showEchart($(".selStatImgType").attr("data-type"));
		},
	"json",false) 	
}

function showEchart(param){

	var data="";
	if(param==="X"){
		data = globleImgData.dataX;
	}
	
	if(param==="Y"){
		data = globleImgData.dataY;
	}
	
	if(param==="XY"){
		data = globleImgData.data;
	}

	showEchartPie(data);
	showEchartBars(data);
}

	
function showEchartBars(data){
	var option = ECharts.ChartOptionTemplates.Bars(data); 
	option.title ={
		
	}
	var container = document.getElementById('typechartsbar');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(data){
	
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById('typechartspie');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

//操作  评论
function SetCellOpUrl(value, rowData, rowIndex)
{   var RepID=rowData.RepID;         //报表ID
	var RepTypeCode=rowData.RepTypeCode; //报告类型代码
	var RepShareStatus=rowData.RepShareStatus  //分享状态
	var html = "";
	if (RepShareStatus == "分享"){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>查看回复列表</a>";
	}else{
		  html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\">查看回复列表</a>";
		}
    return html;
}

function showAllReport(columns,datas){
	destoryDataTable();
	$('#reportDataAll').datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:columns,
		data:datas,
		pageSize:10,  		// 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:false,
		onLoadSuccess:function(data){
			
		},
		onClickCell:function(index,field,value){
		
		}
	});	
}

function destoryDataTable(){
	//$('#reportDataAll').datagrid("destroy");	
}

///显示rec表数据
function showDataTable(value){
	destoryDataTable();
	
	$("#dataTableAll").show();
	$("#dataTablePort").hide();        //切换显示的表格
	
	
	var stDate = $("#stDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	if(value==0){
		value="";	
	}
	var params = stDate+"^"+endDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^"+value+"^^";
	
	
	var jsonColumn= [
			{field:"RepStaus",title:'报告状态',align:'center',hidden:false},
			{field:'RepDate',title:'报告日期',align:'center'},
			{field:'PatID',title:'登记号',hidden:true},
			{field:'AdmNo',title:'病案号',align:'center'},
			{field:'PatName',title:'姓名',align:'center'},
			{field:'PatSex',title:'性别',align:'center'},
			{field:'PatAge',title:'年龄',align:'center'},
			{field:'RepType',title:'报告类型',align:'center'},
			{field:'OccurDate',title:'发生日期',align:'center'},
			{field:'OccurLoc',title:'发生科室',align:'center'},
			{field:'RepLoc',title:'报告科室',align:'center'},
			{field:'LocDep',title:'系统',align:'center',hidden:true},	
			{field:'RepUser',title:'报告人',align:'center'}
			/*
			{field:"ck",checkbox:true,width:20,hidden:true},
			{field:'StatusLastID',title:'上一状态ID',width:100,align:'center',hidden:true},
			{field:'LkDetial',title:'操作',width:100,align:'center',formatter:SetCellOpUrl,hidden:true},
			{field:"RepID",title:'RepID',width:80,hidden:true},
			{field:"recordID",title:'recordID',width:80,align:'center',hidden:true},
			{field:'RepShareStatus',title:'分享状态',width:80,align:'center',align:'center',hidden:true},
			{field:'StatusLast',title:'上一状态',align:'center',width:100,hidden:true},
			{field:'Medadrreceive',title:'接收状态',width:100,hidden:true},
			{field:'Medadrreceivedr',title:'接收状态dr',align:'center',width:80,hidden:true},
			{field:'RepTypeCode',title:'报告类型代码',hidden:true},
			{field:'RepImpFlag',title:'重点关注',hidden:true},
			{field:'RepSubType',title:'报告子类型',hidden:true},
			{field:'RepLevel',title:'不良事件级别',hidden:true},
			{field:'RepInjSev',title:'伤害严重度',hidden:true},
			{field:'RepTypeDr',title:'报告类型Dr',hidden:true}	
			*/
		]
	
	if(value!==""){
		runClassMethod("web.DHCADVStatisticsDhcadv","GetColumnsByFormNameID",{ForNameID:value},
			function (data){
				
				for(var i=0;i<data.length;i++){
					jsonColumn.push(data[i]);
				}			
			},'json',false
		)
	}
	
	
	var columns=[]
	columns.push(jsonColumn);
	setColumnCombo(columns[0]);  //通过前台数据做出统计 **统计用
	
	// 定义datagrid
	$('#reportDataAll').datagrid({
		title:'',
		data:null,
		url:LINK_CSP+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepStatList", //huaxiaoying 2017-1-4 规范名字
		queryParams:{
			StrParam:params
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  		// 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:false,
		onLoadSuccess:function(data){
			globleAllTableData =data.rows;   //
			statAllDataObj.data = data.rows; //上面处理数据前后天下面这个处理数据在前台
		},
		onClickCell:function(index,field,value){
			allReportClickStat(field);
		}
	});	
	return;
}

///统计combobox初始化 **决定下拉combobox的下拉值
function setColumnCombo(jsonColumn){
	statAllDataObj.column=[];
	dateColumn=[];
	for (i in jsonColumn){
		var jsonObj = jsonColumn[i];
		var comboObj={};
		//if(jsonObj.hidden) continue;   //隐藏的字段不统计
		if(jsonObj.field==""||jsonObj.field==undefined) continue;   //没有或者field为空退出
		if(jsonObj.title==""||jsonObj.title==undefined) continue;	//没有或者title为空退出
		if(jsonObj.hidden) continue;
		comboObj.value = jsonObj.field;
		comboObj.text = jsonObj.title;
		if(jsonObj.title.indexOf("日期")!=-1){
			dateColumn.push(comboObj);	
		}else{
			statAllDataObj.column.push(comboObj);  //这个就是最终统计X和Y的数据	
		}
	}
	

	for(j in dateColumn){
		var dateColumnObj = dateColumn[j];
		var comboDateObj={};
		for(i=1;i<=6;i++){
			comboDateObj={};
			comboDateObj.value = dateColumnObj.value+"^"+i;
			comboDateObj.text = dateColumnObj.text+"("+i+"月)";	
			statAllDataObj.column.push(comboDateObj);
		}
		
		comboDateObj={};
		comboDateObj.value = dateColumnObj.value+"^季度";   //季度
		comboDateObj.text = dateColumnObj.text+"(季度)";
		statAllDataObj.column.push(comboDateObj);
		
		comboDateObj={};
		comboDateObj.value = dateColumnObj.value+"^半年";   //半年
		comboDateObj.text = dateColumnObj.text+"(半年)";
		statAllDataObj.column.push(comboDateObj);
		
		comboDateObj={};
		comboDateObj.value = dateColumnObj.value+"^年度";
		comboDateObj.text = dateColumnObj.text+"(年度)";
		statAllDataObj.column.push(comboDateObj);
	}
}

function reloadAllCombobox(){
	$("#statTypeX").combobox("setValue","");
	$("#statTypeY").combobox("setValue","");
	$("#statData").combobox("setValue","");
	$("#statTypeX").combobox("loadData",statAllDataObj.column);
	$("#statTypeY").combobox("loadData",statAllDataObj.column);
	$("#statData").combobox("loadData",statAllDataObj.column);
	//$("#statType").combobox("loadData",statAllDataObj.column);
}

///重新加载
function reloadCombobox(value){
	
	$("#statTypeX").combobox("setValue","");
	$("#statTypeY").combobox("setValue","");
	$("#statData").combobox("setValue","");
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataForStatField&FormNameID="+value;
	$("#statTypeX").combobox("reload",uniturl);	
	$("#statTypeY").combobox("reload",uniturl);	
	
	
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataForStatFieldNoDate&FormNameID="+value;
	$("#statData").combobox("reload",uniturl);	
}

function reloadComboboxDataType(value){
	$("#statType").combobox("setValue","");
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataTypeByField&FieldName="+value;
	$("#statType").combobox("reload",uniturl);	
		
}

///获取上一年时间
function getBeforeYearDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}
///获取当前时间
function getCurrentDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}



var LINK_CSP="dhcapp.broker.csp";
//当前索引
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
}


function serverCallJson(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"json",false)
	return ret.responseText
}

///导出数据
function exportExcelStatic(){
	if(statDataType=="ALL"){
		exportExcelStat(statAllDataObj.exportData);
	}else{
		exportExcelStat(globleTableData.rows);
	}
}

///不良事件朝阳导出excel统计
function exportExcelStat(exportData)
{ 
	var dataLen = exportData.length;
	if(dataLen==0){
		$.messager.alert("提示","没有导出数据!");
		return;
	}
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add("");
	var objSheet = xlBook.ActiveSheet;
	//判断有没有undefined
	var dataObjLen=0;
	for (var dataName in exportData[0]){
		dataObjLen++;
	}

	gridlist(objSheet,1,dataLen,1,dataObjLen);
	
	var row=0;
	for (i=0;i<dataLen;i++){
		row=row+1;
		col=0;
		var dataObj = exportData[i];  //导出数据
		for (var dataName in dataObj){
			col=col+1;
			objSheet.Cells(row,col).value=dataObj[dataName];
		}
	}
	//gridlist(objSheet,1,2,1,5);
	
	xlApp.Visible=true;
	objSheet=null;
}

///时间间隔串:这里按照月走
function getDateInterval(stDate,endDate,intervalValue){
	var ret="";
	if((intervalValue=="季度")||(intervalValue=="半年")||(intervalValue=="年度")){
		ret = getDateIntervalString(stDate,endDate,intervalValue);
	}else{
		ret = getDateIntervalNum(stDate,endDate,intervalValue);
	}
	return ret;
}

///字符串季度和半年
function getDateIntervalString(stDate,endDate,intervalValue){
	var ret = ""; 
	var mYear = parseInt(stDate.split("-")[0]);
	var mMonth = parseInt(stDate.split("-")[1]);
	var mDay = parseInt(stDate.split("-")[2]);
	var eYear = parseInt(endDate.split("-")[0]);
	var date="";
	if(intervalValue=="季度"){
		if((mMonth<4)&&(mMonth>=1)){
			date = mYear+"-01-01";
		}else if((mMonth<7)&&(mMonth>=4)){
			date = mYear+"-04-01";
		}else if((mMonth<10)&&(mMonth>=7)){
			date = mYear+"-07-01";
		}else if((mMonth<=12)&&(mMonth>=10)){
			date = mYear+"-10-01";
		}
		var lsDateString = getDateIntervalNum(date,endDate,3);  //季度嘛3个月一个季度

		var lsDateArray =  lsDateString.split("^");
		
		
		for(i=0;i<lsDateArray.length;i++){
			var mYear = parseInt(lsDateArray[i].split("-")[0]);
			var mMonth = parseInt(lsDateArray[i].split("-")[1]);
			if(mMonth==1){
				if(ret!=="") ret = ret+"^"+mYear+"年第一季度";
				if(ret==="") ret = mYear+"年第一季度";
			}else if(mMonth==4){
				if(ret!=="") ret = ret+"^"+mYear+"年第二季度";
				if(ret==="") ret = mYear+"年第二季度";
			}else if(mMonth==7){
				if(ret!=="") ret = ret+"^"+mYear+"年第三季度";
				if(ret==="") ret = mYear+"年第三季度";	
			}else if(mMonth==10){
				if(ret!=="") ret = ret+"^"+mYear+"年第四季度";
				if(ret==="") ret = mYear+"年第四季度";
			}
		}
	}else if(intervalValue=="半年"){
		if((mMonth<7)&&(mMonth>=1)){
			date = mYear+"-01-01";
		}else if((mMonth<=12)&&(mMonth>=7)){
			date = mYear+"-07-01";
		}
		var lsDateString = getDateIntervalNum(date,endDate,6);  //季度嘛3个月一个季度

		var lsDateArray =  lsDateString.split("^");
		
		
		for(i=0;i<lsDateArray.length;i++){
			var mYear = parseInt(lsDateArray[i].split("-")[0]);
			var mMonth = parseInt(lsDateArray[i].split("-")[1]);
			if(mMonth==1){
				if(ret!=="") ret = ret+"^"+mYear+"上半年";
				if(ret==="") ret = mYear+"上半年";
			}else if(mMonth==7){
				if(ret!=="") ret = ret+"^"+mYear+"下半年";
				if(ret==="") ret = mYear+"下半年";
			}
		}
	}else if(intervalValue=="年度"){
		for(date=mYear;date<=eYear;date++){
			if(ret!=="") ret = ret+"^"+date+"年度";
			if(ret==="") ret = date+"年度";
		}
	}
	return ret;
}


///1-12个月获取
function getDateIntervalNum(stDate,endDate,intervalValue){
	var ret = ""; 
	var date=stDate;
 	if((intervalValue<1)||(intervalValue>12)) return;
 	//String类型强行转换为number
	if(typeof intervalValue=="string"){
		intervalValue = parseInt(intervalValue);
	}
	
	var mYear = parseInt(stDate.split("-")[0]);
	var mMonth = parseInt(stDate.split("-")[1]);
	var mDay = parseInt(stDate.split("-")[2]);
	var date = stDate;
	while(date<endDate){
		if(ret!=="") ret = ret+"^"+date;
		if(ret==="") ret = date;
		
		mMonth = mMonth+intervalValue;
		if(mMonth>12){
			mMonth = mMonth-12;
			mYear = mYear+1;
		}
		
		date = mYear+"-"+(mMonth<10?"0"+mMonth:mMonth)+"-"+(mDay<10?"0"+mDay:mDay);
	}
	return ret;	
}

//** 比对时间，获取统计时间段问题中时间存在位置
function formatDateType(date,dateInterval){

	var dateIntervalArr = dateInterval.split("^");
	for (i=0;i<dateIntervalArr.length;i++){
		
		
		if(i==(dateIntervalArr.length-1)){
			if(formatterDate(dateIntervalArr[i])<=date){
				date = dateIntervalArr[i];
				return date;
			}
		}else{
			if((formatterDate(dateIntervalArr[i])<=date)&&(date<formatterDate(dateIntervalArr[i+1]))){
				date = dateIntervalArr[i];
				return date; 	
			}	
		}
	}
	return "";
}

///** 季度、半年等时间转换
function formatterDate(date){

	var ret="";
	ret = date.replace(/年第一季度/g,"-01-01");
	ret = ret.replace(/年第二季度/g,"-04-01");
	ret = ret.replace(/年第三季度/g,"-07-01");
	ret = ret.replace(/年第四季度/g,"-10-01");
	ret = ret.replace(/上半年/g,"-01-01");
	ret = ret.replace(/下半年/g,"-07-01");
	ret = ret.replace(/年度/g,"-01-01");
	return ret;
}

///设置excel导出边框
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2;
}

function resetTableAndComboBox(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	
	statAllDataObj.stDate = $("#stDate").datebox("getValue");
	statAllDataObj.endDate = $("#endDate").datebox("getValue");
	
	showDataTable(formNameID);
	reloadAllCombobox();  //完全走前台控制
	showEchartBars("");
	showEchartPie("");
}

function initPageDomDis(){
	$("#statTypeX").combobox("disable");
	$("#statTypeY").combobox("disable");
	$("#statData").combobox("disable");
	$("#statType").combobox("disable");	
	$("#createRep").attr("disabled","disabled");
	$("#exportRep").attr("disabled","disabled");
	return;
}

function setBtnDisOrEnab(){
	$("#createRep").removeAttr("disabled");
	$("#exportRep").removeAttr("disabled");
	
}

function setDisOrEnaDom(){
	$("#stDate").datebox("disable");
	$("#endDate").datebox("disable");
	$("#statTypeX").combobox("enable");
	$("#statTypeY").combobox("enable");
	$("#statData").combobox("enable");
	$("#statType").combobox("enable");
	return;
}


///重置界面
function commonReload(){
	window.location.reload();
	return;
	//resetTableAndComboBox();
}
//hxy 回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
