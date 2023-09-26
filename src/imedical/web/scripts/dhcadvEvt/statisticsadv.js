///qqa
///2017-12-14
///
$(function (){
	initParam();
	
	initCombobox();
	
	initDateBox();
	
	initMehtod();
	
	initDatagrid();
	
	setStatComboDis();  //界面统计项目初始化为默认状态
})
///初始化所有参数
function initParam(){
	
	imgResizeFlag=false;
	
	setParams={
		showNoItm:false,      //是否显示无选项
	}
	
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
		endDate:"",
		columnItm:[]
	}
	
	statDataType="";  //当前统计标志
	
	
	
	runClassMethod("web.DHCADVStatisticsDhcadv","InitColumnData",{},
		function (data){
						
		}
	)
}

///初始化table
function initDatagrid(){
	
	var columns = [[
    {
        field: 'StRowID',
        title: 'ID',
        hidden:true
    },{
        field: 'StTempName',
        title: '模板名称',
        width: 100
    },{
        field: 'StatTypeXVal',
        title: 'XValue',
        hidden:true
    },{
        field: 'StatTypeXText',
        title: '统计横向',
        width: 50
    },{
        field: 'StatTypeYVal',
        title: 'YValue',
        hidden:true
    },{
        field: 'StatTypeYText',
        title: '统计纵向',
        width: 50
    },{
        field: 'StatDataVal',
        title: 'DataValue',
        hidden:true
    },{
        field: 'StatDatText',
        title: '统计数据',
        width: 50
    },{
        field: 'StatTypeVal',
        title: 'TypeValue',
        hidden:true
    },{
        field: 'StatTypeText',
        title: '统计类型',
        width: 50
    },{
	 	field: 'delete1',
        title: '操作',
        formatter:function(value, rowData, rowIndex){
	    	return "<a href='#' onclick='deleteTemp(\""+rowData.StRowID+"\")'>删除</a>";    
	    }   
	 },{
	 	field: 'cite1',
        title: '操作',
        formatter:function(value, rowData, rowIndex){
	        var tempData = rowData.StatTypeXVal+"!!"+rowData.StatTypeYVal+"!!"+rowData.StatDataVal+"!!"+rowData.StatTypeVal+"!!"+rowData.StatTypeText;
	    	return "<a href='#' onclick='setStatCombTemp(\""+tempData+"\")'>引用</a>";    
	    }   
	 }]]

	$("#tmpDataTable").datagrid({
		url: 'dhcapp.broker.csp?ClassName=web.DHCADVStatTemp&MethodName=GetJsonList',
		fit:true,
		fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		headerCls:'panel-header-gray', //ed
		onDblClickRow:function(index,row){
			
		}
	})		
}


function deleteTemp(stRowId){
	
	if (stRowId != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				var ret=serverCall("web.DHCADVStatTemp","Delete",{"StRowID":stRowId});
				if(ret!=0) $.messager.alert("提示","删除失败！");
				if(ret==0) $.messager.alert("提示","删除成功！","info",function(){
						$("#tmpDataTable").datagrid("reload");
				});
				return;
			}
		});
	}else{
		 return;
	}
	
	
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
	return;
	
}

function initMehtod(){
	$("a:contains('生成报表')").on("click",initReportDatagrid);
	
	$(".statImgType").on("click",setSelImgType);
	
	$(".statImgType1").on("click",setSelImgType1);
}

function setSelImgType(){
	$(".statImgType").not(this).each(function(){
		$(this).removeClass("selStatImgType");	
	})
	if(!$(this).hasClass("selStatImgType")){
		$(this).toggleClass("selStatImgType");	
	}
	
	showEchartsPar();
	
}
function setSelImgType1(){
	$(".statImgType1").not(this).each(function(){
		$(this).removeClass("selStatImgType1");	
	})
	if(!$(this).hasClass("selStatImgType1")){
		$(this).toggleClass("selStatImgType1");	
	}
	
	showEchartsPar();
	
}
//getBeforeYearDate()
///初始化下拉款:初始化时间
function initDateBox(){
	$("#stDate").datebox("setValue",getBeforeYearDate());
	
	$("#endDate").datebox("setValue",getCurrentDate());	
}

function initCombobox(){
	
	//模板下拉框选中后设置其他combobox值
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			setStatCombTemp(option.value);	
	    },
	    filter:function(q,row){
			var options = $("#reportTemplate").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	var url = LINK_CSP+"?ClassName=web.DHCADVStatTemp&MethodName=GetTempList&FormNameID=";;
	new ListCombobox("reportTemplate",url,'',option).init();
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			resetTableAndComboBox();
			setStatComboEna();				
	    },
	    filter:function(q,row){
			var options = $("#reportType").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    filter:function(q,row){
			var options = $("#statTypeX").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	
	//var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	var url="";
	new ListCombobox("statTypeX",url,'',option).init();
	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    filter:function(q,row){
			var options = $("#statTypeY").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	
	//var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	var url ="";
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
		},
	    filter:function(q,row){
			var options = $("#statData").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
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
		var fieldValue = (data[fieldName]==""?"无":data[fieldName]);
		var fieldValue = (data[fieldName]==undefined?"无":data[fieldName]);
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
	showEchartsPar();
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
		$.messager.alert("提示","没有待统计数据,检查是否选择了报告类型！");
		return;
	}
	
	var dateXString="",dateXArr="",dateYString="",dateYArr="";
	//statData:待统计数据
	//statTypeX:x field
	//statTypeY: y field
	//statTypeXDate,statTypeYDate :时间类型时间间隔
	//statRadioXList,statRadioYList:radio类型取所有子元素
	///获取统计类型，需要区分是否是时间类型
	var statTypeXInfo = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue"));  //这个是X,json对象的name
	var statTypeXDesc = ($("#statTypeX").combobox("getText")==undefined?"":$("#statTypeX").combobox("getText"));  //X描述
	var statTypeX = statTypeXInfo.split("^")[0];
	var statTypeXDate="";
	if(statTypeXInfo.indexOf("^")!="-1"){
		statTypeXDate = statTypeXInfo.split("^")[1];	   //X轴时间单位，即日月年间隔
	}
	var statTypeYInfo = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue"));  //这个是Y
	var statTypeYDesc = ($("#statTypeY").combobox("getText")==undefined?"":$("#statTypeY").combobox("getText"));  //Y描述
	var statTypeY = statTypeYInfo.split("^")[0];
	var statTypeYDate = "";
	if(statTypeYInfo.indexOf("^")!="-1"){
		statTypeYDate = statTypeYInfo.split("^")[1];     //Y轴时间单位，即日月年间隔	
	}
	
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));
	var datagridColumX={},datagridColumY={},datagridColumNum = {},datagridData=[];  ///datagridColum作用:用来记录datagrid的column生成列内容
	
	var statRadioXList="",statRadioYList="";            //radio格式这个位置会获取到radio下面的子元素
	if(statTypeX!="") statRadioXList = statAllDataObj.columnItm[statTypeX]==undefined?"":statAllDataObj.columnItm[statTypeX];
	if(statTypeY!="") statRadioYList = statAllDataObj.columnItm[statTypeY]==undefined?"":statAllDataObj.columnItm[statTypeY];   
	
	if((statTypeX==="")&&(statTypeX=="")){
		$.messager.alert("提示","请先确定统计横向和统计纵向的项目！");
		$("#statXLable").css("color","red");
		$("#statYLable").css("color","red");
		return;
	}else{
		$("#statXLable").css("color","#000");
		$("#statYLable").css("color","#000");	
	}
	
	//过滤用来获取column非时间元素:普通元素和radio父元素
	if(statTypeXDate===""){   
		if(statRadioXList===""){
			for (i in statData){
				var data = 	statData[i];    
				var typeX = ((data[statTypeX]==""||data[statTypeX]==undefined)?"无":data[statTypeX]);
				datagridColumX[typeX]="";   //这个对象用来记录并生成datagrid的column
			}
		}else{
			dateXArr = statRadioXList.split("^");   //获取radioParef数组
			for (var i in dateXArr){
				var typeX = dateXArr[i];
				datagridColumX[typeX]="";   //这个对象用来记录并生成datagrid的column
			}	
		}
	}else if(statTypeXDate!==""){
		dateXString = getDateInterval(stDate,endDate,statTypeXDate);   //开始时间，结束时间，时间间隔
		dateXArr = dateXString.split("^");   //获取时间数组
		for (var i in dateXArr){
			var typeX = dateXArr[i];
			datagridColumX[typeX]="";   //这个对象用来记录并生成datagrid的column
		}
		
		
	}

	//获取columns：这里根据上方方法获取统计后columns,就是X方向的列数据:
	var allDataColumns=[],allDataArray=[],count=1,myDymObj={};
	var noValueFlag=false,noValueObj={};  //这是让无选项位于最后方
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
		if(objName=="无"){
			noValueFlag=true;
			noValueObj = myDymObj;
		}else{
			allDataArray.push(myDymObj);
		}
		count=count+1;
	}

	if((noValueFlag)&&(setParams.showNoItm)) allDataArray.push(noValueObj);  //为了排序，无放在最后
	
	var myDymObj={};			//最后一列为统计
	myDymObj.field="field"+count;
	myDymObj.align="center";
	myDymObj.title="合计";
	allDataArray.push(myDymObj);           //这个就是datagrid的columns
	//allDataColumns.push(allDataArray);   
	
	//Y轴时间操作,显示Y轴列操作
	if(statTypeYDate!==""){
		dateYString = getDateInterval(stDate,endDate,statTypeYDate);   //开始时间，结束时间，时间间隔
		dateYArr = dateYString.split("^");
	}
	//Y轴radioParef操作,显示Y轴列操作
	if(statRadioYList!==""){
		dateYArr = statRadioYList.split("^");  //radio子元素列表
	}
	
	for(i in dateYArr){
		datagridColumY[dateYArr[i]]={};    //Y轴方向显示的行标题
		datagridColumNum[dateYArr[i]]={};  //
	}
	
	//过滤用来获取column
	for (i in statData){
		var data = 	statData[i];
		var typeY = (data[statTypeY]==""?"无":data[statTypeY]);
		var typeX = (data[statTypeX]==""?"无":data[statTypeX]);   //XY确定一个单元格
		var typeY = (data[statTypeY]==undefined?"无":data[statTypeY]);
		var typeX = (data[statTypeX]==undefined?"无":data[statTypeX]);   //XY确定一个单元格
		//statTypeYDate 是时间间隔单位
		//formatDateType 是单元格时间属于时间间隔中某个时间
		if(statTypeYDate!==""){						//时间Y轴获取
			typeY=formatDateType(typeY,dateYString)
		}
		
		//必须设置对象，不然undefined报错
		//datagridColumNum:就是统计后的数据数组:原理（二维数组，第一维度为y,第二维度为x，维度中存放数据值，二维数组结果为数量）
		//qqa:2018-12-04:考虑到数据的多选框统计需要分开这里需要遍历循环
		//limit:checkbox多个内容分隔符
		//typeYLen:内容长度
		//typeYArr:内容数组
		var limit = String.fromCharCode(10);
		var typeYLen = typeY.split(limit).length;
		var typeYArr = typeY.split(limit);
		var typeXLen = typeX.split(limit).length;
		var typeXArr = typeX.split(limit);
		for(var i=0;i<typeYLen;i++){    
			typeY = typeYArr[i]==""?"无":typeYArr[i];
			if((!setParams.showNoItm)&&(typeY=="无")) continue;
			if(datagridColumNum[typeY]==undefined){   
				datagridColumNum[typeY]={};   //设置成对象：
			}
	
			datagridColumY[typeY]="";    //列
			
			//isHasData():判断统计数据在当前报告中是否有数据
			if((statDataID==="")|((statDataID!=="")&(isHasData(data,statTypeDesc)))){
				if(statTypeXDate===""){      //非时间
					for(var j=0;j<typeXLen;j++){ //循环写在了这里是因为时间元素不需要循环
						var typeItmX = typeXArr[j]==""?"无":typeXArr[j];
						if((!setParams.showNoItm)&&(typeItmX=="无")) continue;
						
						if(datagridColumNum[typeY][typeItmX]==undefined){
							datagridColumNum[typeY][typeItmX]=1;
						}else{
							datagridColumNum[typeY][typeItmX]=datagridColumNum[typeY][typeItmX]+1;   //这个数量是走单元格数量
						}
					}
				}else if(statTypeXDate!==""){ //时间
					var typeItmX = formatDateType(typeX,dateXString);   //qqa方法返回按照时间统计的,时间存在位置
					if(datagridColumNum[typeY][typeItmX]==undefined){
						datagridColumNum[typeY][typeItmX]=1;
					}else{
						datagridColumNum[typeY][typeItmX]=datagridColumNum[typeY][typeItmX]+1;   //这个数量是走单元格数量
					}
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
		dymObj["name"] =objName;
		if(objName=="undefined"){
			dymObj["name"] = "合计";
		}
		
		dymObj["group"] =statTypeXDesc;
		dymObj["value"] =dataNumberXYX[objName];
		globleImgData.dataX.push(dymObj);
	}
	for (objName in datagridColumY){
		if(objName!="undefined"){
			var dymObj={};
			dymObj["name"] =objName;
			dymObj["group"] =statTypeYDesc;
			dymObj["value"] =dataNumberXYY[objName];
			globleImgData.dataY.push(dymObj);	
		}
	}
	showEchartsPar();  //显示图形
	
	
	//显示数据
	showAllReport(allDataArray,datas);
	
	return ;
}

///
function ordArrLis(arrayList){
	var dymArray=[];
	var hasNoFlag=false;
	for (name in arrayList){
		if(name=="无") hasNoFlag = true;
		if(name=="合计"){
			if(hasNoFlag) dymArray["无"]="";	
		}
		
		if(name!="无"){
			//取消无选项的显示
			//dymArray[name]=""  
		}
	}
	return dymArray;
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
			showEchartsPar();
		},
	"json",false) 	
}

function showEchart(param,type){

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
	
	if(type=="pie"){
		showEchartPie(data);
	}else if(type=="bar"){
		showEchartBars(data);
	}else{
		showEchartBars(data);
	}
}


function showEchartsPar(){
	var selStatImgType = $(".selStatImgType").attr("data-type");
	var selStatImgType1 = $(".selStatImgType1").attr("data-type");
	showEchart(selStatImgType,selStatImgType1);
	return;	
}


	
function showEchartBars(data){
	debugger;
	var is_stack={
		grid:{		
			y2:110	
		},
		axisLabel: {
			show: true,
            interval: 0,
            rotate: 45,
            margion: 0,
            formatter:function(val){
	            return val;
           		//return val.split("").join("\n");
            }
        }
	}
	
	var option = ECharts.ChartOptionTemplates.Bars(data,'',is_stack); 
	option.title ={
		
	}
	var container = document.getElementById('typecharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(data){
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById('typecharts');
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

//这里需要写一个table
function showAllReport(columns,datas){

	$('#reportDataAll').easyTable("destroy");
	
	//速度太慢，用table试试
	$('#reportDataAll').easyTable({
		url:"",
		nowrap:true,
		columns:columns,
		data:datas,
		rownumbers:false,
		singleSelect:true,
		onLoadSuccess:function(data){
			//globleAllTableData =data;   //
			//statAllDataObj.data = data; //上面处理数据前后天下面这个处理数据在前台
		},
		onClickCell:function(field){
			//console.log(field);
			//allReportClickStat(field);
		}
	})
	
	return;
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
	//var params = stDate+"^"+endDate+"^^^^^^^"+value+"^^";
	var params = stDate+"^"+endDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^"+value+"^^";
	
	var jsonColumn= [
			{field:"RepStaus",title:'*报告状态',align:'left',hidden:false},
			{field:'RepDate',title:'*报告日期',align:'left',type:'dateTime'},
			//{field:'PatID',title:'*登记号',hidden:true},
			{field:'AdmNo',title:'*病案号',align:'left'},
			{field:'PatName',title:'*姓名',align:'left'},
			{field:'PatSex',title:'*性别',align:'left'},
			{field:'PatAge',title:'*年龄',align:'left'},
			{field:'RepType',title:'*报告类型',align:'left'},
			{field:'OccurDate',title:'*发生日期',align:'left',type:'dateTime'},
			{field:'OccurLoc',title:'*发生科室',align:'left'},
			{field:'RepLoc',title:'*报告科室',align:'left'},
			{field:'LocDep',title:'*系统',align:'left'},	
			{field:'RepUser',title:'*报告人',align:'left'}
		]
	if(value!=0) jsonColumn=[{field:'LocDep',title:'*系统',align:'left'}];
	
	if(value!==""){
		runClassMethod("web.DHCADVStatisticsDhcadv","GetColumnsByFormNameID",{ForNameID:value},
			function (data){
				
				for(var i=0;i<data.length;i++){
					jsonColumn.push(data[i]);
				}			
			},'json',false
		)
	}
	
	setColumnCombo(jsonColumn);  //通过前台数据做出统计 **统计用
	
	//速度太慢，用table试试
	$('#reportDataAll').easyTable({
		columns:jsonColumn,
		url:LINK_CSP+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepStatList", //huaxiaoying 2017-1-4 规范名字
		singleSelect:true,
		nowrap:true,
		queryParams:{
			StrParam:params
		},
		onLoadSuccess:function(data){
			globleAllTableData =data;   //
			statAllDataObj.data = data; //上面处理数据前后天下面这个处理数据在前台
		},
		onClickCell:function(field){
			allReportClickStat(field);
		}
		
	})
	
	return;
}

///统计combobox初始化 **决定下拉combobox的下拉值
///时间元素出现暗日月年统计这个地方做的控制
function setColumnCombo(jsonColumn){
	statAllDataObj.column=[];
	statAllDataObj.columnItm=[];  //radioParef子元素列表存储
	dateColumn=[];
	for (i in jsonColumn){
		var jsonObj = jsonColumn[i];
		var comboObj={};
		//if(jsonObj.hidden) continue;   //隐藏的字段不统计
		if(jsonObj.field==""||jsonObj.field==undefined) continue;   //没有或者field为空退出
		if(jsonObj.title==""||jsonObj.title==undefined) continue;	//没有或者title为空退出
		
		comboObj.value = jsonObj.field;
		comboObj.text = jsonObj.title;
		if(jsonObj.type=="dateTime"){    //这里可按照后台给与的类型判断：web.DHCADVStatisticsDhcadv.GetColumnsByFormNameID
			dateColumn.push(comboObj);	 //事件的特殊处理是在下方进行日月年分类显示
		}else if(jsonObj.type=="radioParef"){ //这里针对radio的父元素进行特殊处理:记录下选中类型的子元素
			comboObj.type = jsonObj.type;
			statAllDataObj.columnItm[jsonObj.field]=jsonObj.itmList;
			if(setParams.showNoItm) statAllDataObj.columnItm[jsonObj.field]=statAllDataObj.columnItm[jsonObj.field]+"^无";   //在统计的时候，获取子元素,这里需增加一个无统计没有选中元素的表单：记住你很牛逼		
			statAllDataObj.column.push(comboObj);
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
	$("#statTypeX").combobox("loadData",statAllDataObj.column);   //这里已经对时间元素进行了特殊处理
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

	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataTypeByField&FieldName="+value;
	$("#statType").combobox("reload",uniturl);	
		
}

///获取上一年时间
function getBeforeYearDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ 
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ 
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ 
			return Month+"/"+Day+"/"+Year;
		}else{ 
			return Year+"-"+Month+"-"+Day;
		}
	} 
	//return Year+"-"+Month+"-"+Day;
}
///获取当前时间
function getCurrentDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(typeof(DateFormat)=="undefined"){ 
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ 
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ 
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ 
			return Month+"/"+Day+"/"+Year;
		}else{ 
			return Year+"-"+Month+"-"+Day;
		}
	}
	//return Year+"-"+Month+"-"+Day;
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

function saveTemplate(){
	
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	if(formNameID=="") {
		$.messager.alert("提示","报告类型不能为空！");
		return;
	}
	
	var statTypeXInfo = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue")); 
	var statTypeYInfo = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue")); 
	var statTypeXText = $("#statTypeX").combobox("getText");
	var statTypeYText = $("#statTypeY").combobox("getText");
	if((statTypeXInfo=="")&&(statTypeYInfo=="")) {
		$.messager.alert("提示","请先确定统计横向和统计纵向的项目！");
		return;
	}
	
	var statData = ($("#statData").combobox("getValue")==undefined?"":$("#statData").combobox("getValue")); 
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue")); 
	var statDataText = $("#statData").combobox("getText");
	var statTypeText = $("#statType").combobox("getText");
	if(statType=="") {
		$.messager.alert("提示","统计类型不能为空！");
		return;
	}
			
	$.messager.prompt("提示","请输入模板的名字",function(tmpName){
		if(tmpName==undefined) return;
		if(tmpName=="") {
			$.messager.alert("提示","模板名字不能为空！");
			return;
		}
		var params=""+"#$"+formNameID+"#$"+tmpName+"#$"+statTypeXInfo+"##"+statTypeXText;
		params = params+"!!"+statTypeYInfo+"##"+statTypeYText+"!!"+statData+"##"+statDataText;
		params = params+"!!"+statType+"##"+statTypeText;
		var ret=serverCall("web.DHCADVStatTemp","Save",{"Params":params});
		if(ret!=0) {
			if(ret=="-1"){
				$.messager.alert("提示","该名称已存在！");
			}else{
				$.messager.alert("提示","保存失败！");
			}
			return;
		}
		if(ret==0) $.messager.alert("提示","保存成功！","info",function(){
			//relTempComb();	
		});
		return;
	})
	
	
	return;
}

///不良事件朝阳导出excel统计
function exportExcelStat(exportData)
{ 
	
	var dataLen = exportData.length;
	if(dataLen==0){
		$.messager.alert("提示","没有导出数据,必须先生成需导出的报表!");
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
	var topRow=2;				 //留下第一行显示统计时间已经统计内容是啥
	dataLen = dataLen+topRow;		
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,dataObjLen)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,dataObjLen)).MergeCells = true; //合并单元格
	gridlist(objSheet,1,dataLen,1,dataObjLen);
	
	var statTypeX = $("#statTypeX").combobox("getText");
	var statTypeY = $("#statTypeY").combobox("getText");
	objSheet.Cells(1,1)="时间:"+statAllDataObj.stDate+"至"+statAllDataObj.endDate;
	objSheet.Cells(2,1)="统计:"+statTypeX+"/"+statTypeY;
	var row=topRow;
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
	//relTempComb();  //模板combobox重新加载
	showDataTable(formNameID);
	reloadAllCombobox();  //完全走前台控制
	
	//qqa 2018-11-19 修改流程必须先选中日期和类型才能统计，并且查询后日期设置为不可编辑状态
	
	$("#stDate").datebox("disable");
	$("#endDate").datebox("disable");
	
	/*
	if(formNameID==0){
		reloadAllCombobox();
	}else{
		reloadCombobox(formNameID);	
	}
	*/
}

///模板重新加载
function relTempComb(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatTemp&MethodName=GetTempList&FormNameID="+formNameID;
	$("#reportTemplate").combobox("reload",uniturl);
	return;	
}

function setStatCombTemp(tmpData){	
	var tmpDataArr = tmpData.split("!!");
	$("#statTypeX").combobox("setValue",tmpDataArr[0]);
	$("#statTypeY").combobox("setValue",tmpDataArr[1]);
	$("#statData").combobox("setValue",tmpDataArr[2]);
	$("#statType").combobox("setValue",tmpDataArr[3]);
	$("#statType").combobox("setText",tmpDataArr[4]);
	$("#tmpWin").window("close");
	return;
}

function citeTemplate(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	if(formNameID==""){
		$.messager.alert("提示","必须选中一个表单类型！");
		return;	
	}
	$("#tmpWin").window("open");
	$("#tmpDataTable").datagrid("load",{
		"ForNameID":formNameID	
	})
}

function echartsResize(){
	if(typeof(imgResizeFlag)=="undefined") return;
	if(!imgResizeFlag) {
		showEchartsPar();
		imgResizeFlag=true;
	}
	if(imgResizeFlag) {
		setTimeout(function(){imgResizeFlag=false},200);
	}
}

function setStatComboDis(){
	$("#statTypeX").combobox("disable");
	$("#statTypeY").combobox("disable");
	$("#statData").combobox("disable");
	$("#statType").combobox("disable");
	return;
}
function setStatComboEna(){
	
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
