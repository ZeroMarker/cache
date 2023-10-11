/*var signArr = [{"value":"","text":'全部院区'},{"value":"东华标准版数字化医院总院","text":'东华标准版数字化医院[总院]'},{"value":"东华标准版数字化医院分院","text":'东华标准版数字化医院[分院]'},{"value":"哈尔滨医科大学第一附属医院","text":'哈尔滨医科大学第一附属医院'},{"value":"哈尔滨医科大学第一附属医院20201203","text":'哈尔滨医科大学第一附属医院(20201203)'},{"value":"武汉市第一医院","text":'武汉市第一医院'},{"value":"江苏盐城中医","text":'江苏盐城中医'},{"value":"哈尔滨医科大学第一附属医院20201215","text":'哈尔滨医科大学第一附属医院(20201215)'},{"value":"哈尔滨医科大学第一附属医院20201221","text":'哈尔滨医科大学第一附属医院(20201221)'}];
signArr.push({"value":"哈尔滨医科大学第一附属医院20201224","text":'哈尔滨医科大学第一附属医院(20201224)'});
signArr.push({"value":"哈尔滨医科大学第一附属医院202102010209","text":'哈尔滨医科大学第一附属医院(20210201-0209)'});
signArr.push({"value":"江苏盐城中医20210225","text":'江苏盐城中医(20210225)'});
signArr.push({"value":"上海美中嘉和医院","text":'上海美中嘉和医院'});
signArr.push({"value":"上海美中嘉和医院20210203","text":'上海美中嘉和医院202102-03'});
signArr.push({"value":"北京惠兰医院","text":'北京惠兰医院'});
signArr.push({"value":"内蒙赛罕二院","text":'内蒙赛罕二院'});
signArr.push({"value":"北京惠兰医院20210419","text":'北京惠兰医院20210419'});
signArr.push({"value":"北京惠兰医院新","text":'北京惠兰医院新'});
signArr.push({"value":"增城中医处方","text":'增城中医处方'});
signArr.push({"value":"赛罕二院20210317","text":'赛罕二院20210317'});
signArr.push({"value":"榆林市第二医院","text":'榆林市第二医院'});
signArr.push({"value":"包医二附院","text":'包医二附院'});
signArr.push({"value":"包医二附院第二批","text":'包医二附院第二批'});
signArr.push({"value":"南京医科大学第四附属医院","text":'南京医科大学第四附属医院'});
signArr.push({"value":"南京医科大学第四附属医院202106010615","text":'南京医科大学第四附属医院20210601-0615'});
signArr.push({"value":"盐城中医202108","text":'盐城中医(202108)'});
signArr.push({"value":"蚌埠一院091308150831","text":'蚌埠一院0913(08150831)'});
signArr.push({"value":"安徽蚌埠妇幼","text":'安徽蚌埠妇幼'});
signArr.push({"value":"安徽蚌埠妇幼第二批","text":'安徽蚌埠妇幼第二批'});
signArr.push({"value":"黄冈浠水人民","text":'黄冈浠水人民'});
signArr.push({"value":"泰安市中心医院高新院区","text":'泰安市中心医院高新院区'});
signArr.push({"value":"珠海市人民医院","text":'珠海市人民医院'});
signArr.push({"value":"马鞍山市中医医院","text":'马鞍山市中医医院'});
signArr.push({"value":"四川宜宾三院","text":'四川宜宾三院'});
signArr.push({"value":"北海合浦卫校","text":'北海合浦卫校'});
signArr.push({"value":"泸县人民医院","text":'泸县人民医院'});
*/
$(document).ready(function() {
    initResGrid();        //加载统计数据 
    initDetailGrid();
    initButton();
    initCombobox();
    initChart("");
})
//加载结果数据
function initResGrid(){
	

	///  定义columns
	var columns=[[
		{field:"pid",width:10,title:"pid",hidden:true},	
		{field:"drugId",width:10,title:"drugId",hidden:true},
		{field:"monId",width:10,title:"monId",hidden:true},
		{field:"drugDesc",width:400,title:"药品名称"},
		{field:"comDosageNum",align:'center',width:115,title:"用法",newtitle:'ComDosage',formatter:linkPrescdetails},
		{field:"ruleUsageNum",align:'center',width:115,title:"用法用量",newtitle:'RuleUsage',formatter:linkPrescdetails},
		{field:"interEachNum",align:'center',width:115,title:"相互作用",newtitle:'InterEach',formatter:linkPrescdetails},
		{field:"tabooNum",align:'center',width:115,title:"配伍禁忌",newtitle:'Taboo',formatter:linkPrescdetails},
		{field:"drugIrriNum",align:'center',width:115,title:"药物过敏",newtitle:'DrugIrri',formatter:linkPrescdetails},
		{field:"ruleIndicNum",align:'center',width:115,title:"适应症",newtitle:'RuleIndic',formatter:linkPrescdetails},
		{field:"ruleContrNum",align:'center',width:115,title:"禁忌症",newtitle:'RuleContr',formatter:linkPrescdetails},
		{field:"ruleMatNeAtNum",align:'center',width:115,title:"注意事项",newtitle:'RuleMatNeAt',formatter:linkPrescdetails,hidden:true},
		{field:"ruleContrTwoNum",align:'center',width:115,title:"禁忌",newtitle:'RuleContrTwo',formatter:linkPrescdetails,hidden:true},
		{field:"funIndicatNum",align:'center',width:115,title:"功能主治",newtitle:'FunIndicat',hidden:true},
		{field:"repeatNum",align:'center',width:115,title:"重复用药",newtitle:'Repeat',formatter:linkPrescdetails},
		{field:"skinTestRuleNum",align:'center',width:115,title:"皮试用药",newtitle:'SkinTestRule',formatter:linkPrescdetails},
		{field:"drugInterEachNum",align:'center',width:115,title:"药物相互作用",newtitle:'DrugInterEach',formatter:linkPrescdetails,hidden:true},
		{field:"warnNum",align:'center',width:115,title:"警告",newtitle:'DrugNotification',formatter:linkPrescdetails,hidden:true},
		{field:"liquidConfigNum",align:'center',width:115,title:"液体配置",newtitle:'LiquidConfig',formatter:linkPrescdetails},
		{field:"repeatIngNum",align:'center',width:115,title:"成分重复",newtitle:'RepeatIngr',formatter:linkPrescdetails},
		{field:"transNum",align:'center',width:115,title:"片剂给药途径",newtitle:'LiquidConfig',formatter:linkPrescdetails},
		{field:"eighteenTabooNum",align:'center',width:115,title:"十八反",newtitle:'EighteenTaboo',formatter:linkPrescdetails},
		{field:"nineteenTabooNum",align:'center',width:115,title:"十九畏",newtitle:'NineteenTaboo',formatter:linkPrescdetails},
		{field:"bpgmNum",align:'center',width:115,title:"本品过敏",newtitle:'bsgm',formatter:linkPrescdetails},
		
		
	]];
	
	///  定义datagrid
	var option = {
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		remoteSort:false,
		//fit : true,
		pageSize : [30],
		pageList : [30,60,90],
	 	onClickRow: function (rowIndex, rowData) {
					        
 	 	},
		onLoadSuccess:function(data){			  	
			$("#presnum").html(data.prescNum);
			$("#errpresnum").html(data.errorprescNum);
			$("#errDrugnum").html(data.total);
			$("#errpresrate").html((data.errRate===undefined)?"":data.errRate+"%");	
			if(data.total!=0)
			{
				$("#propNum").html("提示："+data.propNum+"%   "+"提醒："+data.tipsNum+"%   "+"警示："+data.warnnNum+"%   "+"禁止："+data.forbidNum+"%");			  	  
			}
			//initDistri(data);
			initChart("");
		 }	    
	};
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var params = fromdate +"^"+ todate +"^^^^^"
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryErrRuleCat&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

function initDistri(data){
	  var myChart = echarts.init(document.getElementById('cgcharts'));
	  
	  var option = {
	  //  title: {
	  //      text: '合理用药目录分布占比图',
	  //      left: 'center'
	  //  },
    tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    series: [
        {
            name: '访问来源',
            type: 'pie',
            radius: '60%',
            center: ['50%', '50%'],
            data: [
                {value: data.comDosageNums, name: '用法'},
                {value: data.ruleUsageNums, name: '用法用量'},
                {value: data.interEachNums, name: '相互作用'},
                {value: data.tabooNums, name: '配伍禁忌'},
                {value: data.drugIrriNums, name: '药物过敏'},
				{value: data.ruleIndicNums, name: '适应症'},
                {value: data.ruleContrNums, name: '禁忌症'},
                {value: data.ruleMatNeAtNums, name: '注意事项'},
                {value: data.ruleContrTwoNums, name: '禁忌'},
                {value: data.funIndicatNums, name: '功能主治'}
            ],
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    	]
	};  
	 
   // 使用刚指定的配置项和数据显示图表。
   myChart.setOption(option);
	
}


function Query()
{
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var drugId = $HUI.combobox('#drugDesc').getValue();
	var conId = $HUI.combobox('#catDesc').getValue();
	var switchs =   $HUI.switchbox('#switchs').getValue();
	var loc = $HUI.combobox("#ctLoc").getText();
	//var hosp = $HUI.combobox("#hosp").getValue();
	var hosp = $HUI.combobox("#hosp").getText();
	var manLevel = $HUI.combobox("#manLevel").getValue();
	var params = fromdate +"^"+ todate +"^"+ drugId +"^"+ conId+"^"+ switchs +"^"+ loc + "^" + hosp + "^"+ manLevel; 
	$("#maingrid").datagrid('load',{'params':params});

}

function QueryRuleCat(){
	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'药品高频数据',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		width: window.screen.availWidth-50,
		height:window.screen.availHeight-100
	});
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var params = fromdate +"^"+ todate;
	var src= "dhcckb.altofrequency.csp?params="+params;
	var iframe='<iframe scrolling="yes" width=100% height=98%  frameborder="0" src='+src+'></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
	
}

function QueryAudit(){
	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'审核标记统计图',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		width: window.screen.availWidth-50,
		height:window.screen.availHeight-100
	});
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var params = fromdate +"^"+ todate+"^"+$HUI.combobox("#hosp").getText();
	
	var src= "dhcckb.dhcckbaudit.csp?params="+encodeURI(encodeURI(params));
	var iframe='<iframe scrolling="yes" width=100% height=85%  frameborder="0" src='+src+'><head><meta http-equiv="Content-Type" content="text/html; charset=gb2312" /></head></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
	
}


function fixWidth(percent)   
{   

	return (document.body.clientWidth - 5) * percent ;    
}
function initButton()
{
	$(".item-errnum").bind('click',OpenProCenter);	// 点击数字，弹出问题明细  
	
	$("span[name='item-icon']").click(function(){
		var type = $(this).attr("data-value")
		initChart(type);	
	});
	
		
	$("#gridtitle").panel({
   		onCollapse:function(){
     		var myChart = echarts.init(document.getElementById('LocCharts'));
   			myChart.resize();  
   		},
   		onExpand:function(){
	   		//$("LocCharts").style.height="180px"
	   		setTimeout(function(){ 
	   			var myChart = echarts.init(document.getElementById('LocCharts'));
   				myChart.resize();  
	   		 }, 800);
	   		  			
   			
   		}
  	});
}
function OpenProCenter()
{
	$("#details").show()
	if($('#details').is(":hidden")){
		$('#details').window('open');
	return;
	}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
	collapsible:true,
	border:true,
	closed:"true"
	};
	initDetailGrid()
	new WindowUX('错误药品排行', 'details', '1100', '600', option).Init();
}
function initDetailGrid()
{
	///  定义columns
	var columns=[[
	       {field:"itemDesc",width:fixWidth(0.5),title:"药品名称"},
	       {field:"errNum",width:fixWidth(0.1),title:"错误数",sortable:'true'},
	       {field:"rate",width:fixWidth(0.1),title:"错误比率"}
	]];

	///  定义datagrid
	var option = {
	fitColumn:true,
	rownumbers : true,
	singleSelect : true,
	remoteSort:false,  
	sortOrder:'asc',
	fit : true,
	pageSize : [30],
	pageList : [30,60,90],
	onClickRow: function (rowIndex, rowData) {
				        
	},
	onLoadSuccess:function(data){

	}

	};
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryDrugRankDetails";
	new ListComponent('detailgrid', columns, uniturl, option).Init();
}
///药品明细
function linkPrescdetails(value, rowData, rowIndex)
{
	
	if(value!=0){
		html = "<a href='#' onclick=\"LoadPrescDetailsWin('"+rowData.drugId+"','"+this.title+"','"+rowData.drugDesc+"','"+rowData.pid+"','"+this.newtitle+"')\">"+value+"</a>";				
		return html;
	}
}
function LoadPrescDetailsWin(drugId,filed,drug,pid,newtitle){	

	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'药品明细列表',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		width: window.screen.availWidth-50,
		height:window.screen.availHeight-100
	});
	catId = serverCall("web.DHCCKBCalculateval","getCatIdByCode",{"desc":newtitle})
	debugger;
	var src= "dhcckb.drugrankdetails.csp?drugId="+drugId+"&catId="+ catId +"&drug="+escape(drug)+"&pid="+pid;
	var iframe='<iframe scrolling="yes" width=100% height=98%  frameborder="0" src='+src+'></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
	
}
///初始化combobox
function initCombobox()
{
	var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryDrugList"  

	$HUI.combobox("#drugDesc",{
		url:uniturl+"&flag=1",
		valueField:'value',
		textField:'text',
		panelHeight:"260",
		mode:'remote',
		onSelect:function(ret){
			Query();
		 }
	})	

	$HUI.combobox("#catDesc",{
 		url:uniturl+"&flag=5",
		valueField:'value',
		textField:'text',
		panelHeight:"260",
		mode:'remote',
		onSelect:function(ret){
			Query();
		 }
	})	
	
	// 科室
	$HUI.combobox("#ctLoc",{
		url: $URL+"?ClassName=web.DHCCKBCommonCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			//Query();
		}
	})
 
 // 院区
	$HUI.combobox("#hosp",{
		url:$URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryHospList",
		//data:signArr,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			//Query();
		}
	})
	
	// 管理级别
	$HUI.combobox("#manLevel",{
 		url:$URL+"?ClassName=web.DHCCKBCalculateval&MethodName=GetManLevel",
		valueField:'value',
		textField:'text',
		panelHeight:"260",
		mode:'remote',
		onSelect:function(ret){
			//Query();
		 }
	})	
	
}

///初始化ehart
function initChart(type)
{
	var stDate = $("#fromdate").datebox('getValue');
	var endDate = $("#todate").datebox('getValue');
	if(type == ""){
		type = "month";	// 默认是月
	}
	runClassMethod("web.DHCCKBDrugRank","JsIntRevMonTrend",{"stDate":stDate,"endDate":endDate,"type":type},function(jsonString){
		initheiChart(jsonString)
	},'json','false')	
}

///月份/数量
function initheiChart(data)
	{
		
		var month = data.month;
		var titleArr = data.title;
		var seriesArr = []
		
		var titleCodeArr = data.titleCode;
		for (i = 0; i < titleCodeArr.length; i++){
			var key = titleCodeArr[i];
			var itmArr = data[key];
			var itmObj = {}
			itmObj.type = "line";
			itmObj.name = titleArr[i];
			itmObj.color = "";
			itmObj.data = itmArr;
			//itmObj.connectNulls="false";
			//itmObj.symbol="none";
			///itmObj.smooth="false";	
			seriesArr.push(itmObj);				
		} 

		var option = {
			color: ["#60C0DD","#C6E579","#F4E001","#F0805A","#ADFF2F","#48D1CC","#800080","#FF4500","#FF00FF","#FFFF00"],
			title: {
		        //text: '科室统计'
		    },
		    tooltip : {
		        trigger: 'axis'
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    }, 
		    toolbox: {
		       //show : true,
		       feature : {
		           	mark : {show: true},
		           // dataView : {show: true, readOnly: false},
		            magicType : {show: true, type: ['line']},
		            restore : {},
		            saveAsImage : {}
		        } 
		    },
		    legend: {
		        data:data.title
		    },
		  
		    xAxis : [
		        {
		            type : 'category',
		            boundaryGap : false,  
		           /*  name:'时间', */
		            data :data.xState,
		            axisTick: {
                      //alignWithLabel: true
                    },
                    axisLabel: {
                      //interval:1,
                    }
		        }
		    ],
		    yAxis : [
		        {
			       /*  name:"数量", */
		            type: "value",
			        splitLine: {show: false},
			        axisLabel: {
                      //interval:1,
                    },
                    axisTick: {
                      //alignWithLabel: true
                    }
		        }
		    ],
		    series :seriesArr
		};		
	
		var myChart = echarts.init(document.getElementById('LocCharts'));
		// 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
	}


///按照目录导出
function expExcel()
{
	var hosp = $("#hosp").combobox('getText');
	var stDate = $("#fromdate").datebox('getValue');
	var endDate = $("#todate").datebox('getValue');
	
}