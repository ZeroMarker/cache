 // Creator: yangyongtao
// CreateDate: 2018-11-26
// Descript: 不良事件按月按季度统计
var url = "dhcadv.repaction.csp";
var MonQuartCompare=""
var QuyTypeArr= [{"value":"MONTH","text":'按月统计'}, {"value":"QUART","text":'按季度统计'}];
$(function(){
	$("#qrytype").combobox("setValue", "MONTH"); 
	
   //初始化combox	 
   InitYearStr(); //获取年份字符串
   //不良事件按月按季度统计
   MonQuartCompare=echarts.init(document.getElementById('MonQuartCompare'));
   $("#FindByMon").click(function(){
	   query();
   })
   query(); 
   
    $("#ExportByMon").click(function(){
	   Export();  //导出
   })
    
   	//统计类型
	$('#qrytype').combobox({
		value:"MONTH",
		text:"按月统计",
		editable:false,
		data:QuyTypeArr
	});
	
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	
	//报告类型
	$('#typeevent').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelEventbyNew&param='+LgGroupID+"^"+LgCtLocID+"^"+LgUserID,
		
	});
})
// 点击查询
function query(){
	
	var CurrYear=$("#yearStr").combobox('getValue'); //当前年
	var yearStr=$("#yearStr").val()//combobox('getValue');
	if(yearStr==""){
		yearStr=CurrYear
    }
	
	var reptype=$('#typeevent').combobox('getValue');  //事件类型
	var locStr=$('#dept').combobox('getValue');        //科室
	var qrytype=$("#qrytype").combobox('getValue'); //统计类型
	var params=LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID; //hxy 2020-02-26
	//var data=serverCall("web.DHCADVREPBYMON","GetAdvStat",{"yearstr":year,"reptype":reptype,"replocstr":locStr,"qrytype":qrytype});
    runClassMethod("web.DHCADVREPBYMON","GetAdvStat",{yearstr:yearStr,reptype:reptype,replocstr:locStr,qrytype:qrytype,params:params},function(data){
    var TempArr=[],YearArr=[],DataArr=[]
     var yeatArr=yearStr.split(",");
		for(var i =0;i<yeatArr.length;i++){ 
           DataArr[i]=(data[yeatArr[i]]).split(",");  //字符串转数组
			var obj={}
			obj.name=yeatArr[i]
			obj.type='line'
			obj.data= DataArr[i]     
			TempArr.push(obj)
			YearArr.push(yeatArr[i])
		}
		if(qrytype=="MONTH"){
		  InitMonthCompare(YearArr,TempArr) // 按月统计
		  InitMonCompareTable(yearStr,data)

		}
		if(qrytype=="QUART"){
		   InitQuartCompare(YearArr,TempArr)  //按季度统计
		   InitQuartCompareTable(yearStr,data)
		}
		
		
	}) 
   
}

 //按月统计	
function InitMonthCompare(YearArr,TempArr){

	option = {
		//color: ['#003366', '#006699', '#4cabce', '#e5323e'],
    	title : {
        	text:'按月份统计',
        	x:'center'
       
    	},
	    tooltip: {
	        trigger: 'axis'
	    },
	    
	   legend: {
              data:YearArr, //['2017','2018']
              x:150,
              y:30
       },
	    toolbox: {
	        show: true,
	        feature: {
	            /* dataZoom: {
	                yAxisIndex: 'none'
	            },
	            dataView: {readOnly: false}, */
	            magicType: {type: ['line', 'bar']},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
    	calculable : true,
    	xAxis : [
        	{
	        	name:"月份",
            	type : 'category',
            	data : ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]  //,"合计"
        	}
    	],
    	yAxis : [
        {
            type : 'value',
            name:"发生例数",
            nameLocation:'middle',
            nameTextStyle:{
	            padding: [10,10,20,10]
	        }
        }
    	],
    	series :TempArr
   	 }
   	 MonQuartCompare.clear();
     MonQuartCompare.setOption(option);
	
}


 //按月统计	
function InitQuartCompare(YearArr,TempArr){
	option = {
		//color: ['#003366', '#006699', '#4cabce', '#e5323e'],
    	title : {
        	text:'按季度统计',
        	x:'center'
    	},
    	
       legend: {
              data:YearArr, //['2017','2018']
              x:150,
              y:30
       },
	    tooltip: {
	        trigger: 'axis'
	    },
	    toolbox: {
	        show: true,
	        feature: {
	            /* dataZoom: {
	                yAxisIndex: 'none'
	            },
	            dataView: {readOnly: false}, */
	            magicType: {type: ['line', 'bar']},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
    	calculable : true,
    	xAxis : [
        	{
	        	name:"季度",
            	type : 'category',
            	data : ["第1季度","第2季度","第3季度","第4季度"]  //,"合计"
        	}
    	],
    	yAxis : [
        {
            type : 'value',
            name:"发生例数",
            nameLocation:'middle',
            nameTextStyle:{
	            padding: [10,10,20,10]
	        }
        }
    	],
    	series :TempArr
   	 }
   	 MonQuartCompare.clear();
     MonQuartCompare.setOption(option);
	
}


//按月列表统计
function InitMonCompareTable(yearStr,data){
			var htmlStr="<table class='easyui-datagrid' style='width:100%'>";

			htmlStr=htmlStr+"<tr>"
			htmlStr=htmlStr+"<th style='background-color:#F0EDED'>年份</th>"
			for(j=1;j<=13;j++){
			    if(j==13){
				    htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+"合计"+"</th>"	
				}else{
				     htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+[j]+"月"+"</th>"
				}	

			}	
			htmlStr=htmlStr+"</tr>"
			
		   var yeatArr=yearStr.split(",");
		   for(var i =0;i<yeatArr.length;i++){
			   htmlStr=htmlStr+"<tr>"
			   htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+yeatArr[i]+"</td>"
               var DataArr=(data[yeatArr[i]]).split(",");  //字符串转数组
               for(var k =1;k<=13;k++){
			      htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+DataArr[k-1]+"</td>"			   
			   }
			}
			
			htmlStr=htmlStr+"</tr>"
			htmlStr=htmlStr+"</table>";
			$("#MonCompareTable").html(htmlStr)
	
}


//按季度列表统计
function InitQuartCompareTable(yearStr,data){
			var htmlStr="<table class='easyui-datagrid' style='width:100%'>";

			htmlStr=htmlStr+"<tr>"
			htmlStr=htmlStr+"<th style='background-color:#F0EDED'>年份</th>"
			for(j=1;j<=5;j++){
				if(j==5){
				    htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+"合计"+"</th>"	
			    }else{
				    htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+"第"+[j]+"季度"+"</th>"	
				}
				
			}	
			htmlStr=htmlStr+"</tr>"
			
		   var yeatArr=yearStr.split(",");
		   for(var i =0;i<yeatArr.length;i++){
			   htmlStr=htmlStr+"<tr>"
			   htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+yeatArr[i]+"</td>"
               var DataArr=(data[yeatArr[i]]).split(",");  //字符串转数组
               for(var k =1;k<=5;k++){
			      htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+DataArr[k-1]+"</td>"			   
			   }
			}
			
			htmlStr=htmlStr+"</tr>"
			htmlStr=htmlStr+"</table>";
			$("#MonCompareTable").html(htmlStr)
	
}

//hxy 回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}


//获取年份字符串
function  InitYearStr(){
	
	str=serverCall("web.DHCADVREPBYMON","GetCurrYear");
	strArr=str.split("-")
    var yearArr = [];//创建年度数组
    for(year= parseInt(strArr[0])-10;year<=parseInt(strArr[0]);year++)
	{
		 yearArr.push({"value":year,text:year});
	}
	
	var value = "";
	//加载下拉框复选框
	$("#yearStr").combobox({
		data:yearArr,
        //url:url+'?action=SelEventbyNew',
        panelHeight:200,//设置为固定高度，combobox出现竖直滚动条
        valueField:'value',
        textField:'text',
        multiple:true,
        formatter: function (row) { //formatter方法就是实现了在每个下拉选项前面增加checkbox框的方法
            var opts = $(this).combobox('options');
            return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField]
        },
        onLoadSuccess: function () {  //下拉框数据加载成功调用
            var opts = $(this).combobox('options');
            var target = this;
            var values = $(target).combobox('getValues');//获取选中的值的values
            $("#yearStr").combobox("setValue", strArr[0]); 
            $.map(values, function (value) {
                var el = opts.finder.getEl(target, value);
                el.find('input.combobox-checkbox')._propAttr('checked', true); 
            })
        },
        onSelect: function (row) { //选中一个选项时调用
            var opts = $(this).combobox('options');
            //获取选中的值的values
            $("#yearStr").val($(this).combobox('getValues'));
           
		   //设置选中值所对应的复选框为选中状态
            var el = opts.finder.getEl(this, row[opts.valueField]);
            el.find('input.combobox-checkbox')._propAttr('checked', true);
        },
        onUnselect: function (row) {//不选中一个选项时调用
            var opts = $(this).combobox('options');
            //获取选中的值的values
            $("#yearStr").val($(this).combobox('getValues'));
          
            var el = opts.finder.getEl(this, row[opts.valueField]);
            el.find('input.combobox-checkbox')._propAttr('checked', false);
        }
    });


}

//导出列表数据
function Export(){
	
	var CurrYear=$("#yearStr").combobox('getValue'); //当前年
	var yearStr=$("#yearStr").val()//combobox('getValue');
	if(yearStr==""){
		yearStr=CurrYear
    }
	
	var reptype=$('#typeevent').combobox('getValue');  //事件类型
	var locStr=$('#dept').combobox('getValue');        //科室
	var qrytype=$("#qrytype").combobox('getValue'); //统计类型
	var params=LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID; //hxy 2020-02-26
	//var data=serverCall("web.DHCADVREPBYMON","GetAdvStat",{"yearstr":year,"reptype":reptype,"replocstr":locStr,"qrytype":qrytype});
    runClassMethod("web.DHCADVREPBYMON","GetAdvStat",{yearstr:yearStr,reptype:reptype,replocstr:locStr,qrytype:qrytype,params:params},function(data){

		if(qrytype=="MONTH"){
		  InitMonExportTable(yearStr,data)

		}
		if(qrytype=="QUART"){
		   InitQuartExportTable(yearStr,data)
		}
		
		
	}) 
		
}

//按月导出数据
function InitMonExportTable(yearStr,data){
        var htmlStr="<table id='tableid'>";
        var htmlStr="";
		htmlStr=htmlStr+"<tr >"
		htmlStr=htmlStr+"<td colspan=14 style='font-size:20px;font-weight:bold;text-align:center;'>"
		htmlStr=htmlStr+"按月统计"
		htmlStr=htmlStr+"</td>"
		htmlStr=htmlStr+"</tr>"
		htmlStr=htmlStr+"<th>年份</th>"
		for(j=1;j<=13;j++){
		    if(j==13){
			      htmlStr=htmlStr+"<th >"+"合计"+"</th>"	
			}else{
			     htmlStr=htmlStr+"<th>"+[j]+"月"+"</th>"
			}	
		}	
		htmlStr=htmlStr+"</tr>"
		
	   var yeatArr=yearStr.split(",");
	   for(var i =0;i<yeatArr.length;i++){
		   htmlStr=htmlStr+"<tr>"
		   htmlStr=htmlStr+"<td>"+yeatArr[i]+"</td>"
           var DataArr=(data[yeatArr[i]]).split(",");  //字符串转数组
           for(var k =1;k<=13;k++){
		      htmlStr=htmlStr+"<td >"+DataArr[k-1]+"</td>"			   
		   }
		}
		
		htmlStr=htmlStr+"</tr>"
		htmlStr=htmlStr+"</table>";
        ExportTableToExcel("按月统计",htmlStr)
}


//按季度导出数据
function InitQuartExportTable(yearStr,data){
        var htmlStr="";
		htmlStr=htmlStr+"<tr >"
		htmlStr=htmlStr+"<td colspan=6 style='font-size:20px;font-weight:bold;text-align:center;'>"
		htmlStr=htmlStr+"按季度统计"
		htmlStr=htmlStr+"</td>"
		htmlStr=htmlStr+"</tr>"
		htmlStr=htmlStr+"<th>年份</th>"
		for(j=1;j<=5;j++){
			if(j==5){
			    htmlStr=htmlStr+"<th>"+"合计"+"</th>"	
		    }else{
			    htmlStr=htmlStr+"<th>"+"第"+[j]+"季度"+"</th>"	
			}
			
		}	
		htmlStr=htmlStr+"</tr>"
		
	   var yeatArr=yearStr.split(",");
	   for(var i =0;i<yeatArr.length;i++){
		   htmlStr=htmlStr+"<tr>"
		   htmlStr=htmlStr+"<td>"+yeatArr[i]+"</td>"
           var DataArr=(data[yeatArr[i]]).split(",");  //字符串转数组
           for(var k =1;k<=5;k++){
		      htmlStr=htmlStr+"<td>"+DataArr[k-1]+"</td>"			   
		   }
		}
		
		htmlStr=htmlStr+"</tr>"
        ExportTableToExcel("按季度统计",htmlStr)
}


