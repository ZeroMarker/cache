//===========================================================================================
// Author��      xww
// Date:		 2021-06-18
// Description:	 ������˼�¼ͳ��
//===========================================================================================
var field="";
var locName="";				
/// ҳ���ʼ������
function initPageDefault(){
	initPage();
	initDateBox()
	initDataGrid();		// ҳ��DataGrid��ʼ������
	initButton();		// ��ť��Ӧ�¼���ʼ��
	initMethod();
	initSelectTabs();
}

function initPage(){

	var heightEchart = $("#getHeightDiv").height()-30;
	
	///ͼ��ĸ߶�
	$(".echartBody").each(function (){
		$(this).height(heightEchart);	
	})
}

function initButton(){

	$("#searchBTN").bind("click",loadDataGrid);	// ���¼���
	
	$('#addBTN').bind("click",addLoc);      // ��ӿ���
	
	$('#FindLoc').bind("click",FindLoc);   //�����ѯ
	
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
		selOrdType="";    //����Ǵ��·������б���ѡ��ģ����ж�ѡ������
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
			title: '����¼��ϸ',
			closed: true,
			onClose:function(){}
		});
	}
}


///��ʼ���¼��ؼ�
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(-60));
	$HUI.datebox("#endDate").setValue(formatDate(0));
	
}


function initDataGrid(){

	var diccolumns=[[ 
			{field:'locName',title:'��������',width:100,hidden:false},
			{field:'submitNum',title:'ȫ����������',width:100,hidden:false,formatter:setCellNum},
			{field:'errorNum',title:'������������',width:100,hidden:false,formatter:setCellNum},
			{field:'errorRate',title:'��������',width:100,hidden:false},
			{field:'auditNum',title:'���ҩƷ����',width:100,hidden:false,formatter:setCellNum},
			//{field:'prescNum',title:'ȫ����������',width:100,hidden:false,formatter:setCellNum},
			{field:'errorprescNum',title:'������ҩƷ����',width:100,hidden:false,formatter:setCellNum},
			//{field:'modifyNum',title:'�����޸Ĵ���',width:100,hidden:false,formatter:setCellNum},
			
			{field:'modifyNum',title:'ҽ���޸���',width:100,hidden:false,formatter:setCellNum},
			{field:'modifyRate',title:'ҽ���޸���',width:100,hidden:false},
			{field:'mandatoryauditNum',title:'ǿ����˴���',width:100,hidden:false,formatter:setCellNum},
			{field:'mandatoryauditRate',title:'ǿ�������',width:100,hidden:false},
			//{field:'auditNum',title:'��˴���',width:100,align:'left',formatter:setCellAuditNum},
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
			locprescEcharts(data.rows);   //Echartsͼ				  	  
		 }

	}

	var stdate = $HUI.datebox("#stDate").getValue()
	var enddate = $HUI.datebox("#endDate").getValue()
	var params = stdate + "^" + enddate+"^^"+"LOC";
	var uniturl = $URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=RecipeAuditStat&params="+params;
	new ListComponent('datagrid', diccolumns, uniturl, option).Init();
	
	
	var diccolumns=[[ 
			{field:'type',title:'��ʾ���',width:100,hidden:false},
			{field:'totalNum',title:'��ʾ����',width:100,hidden:false},
			{field:'modifyNum',title:'�޸Ĵ���',width:100,hidden:false},
			{field:'mandatoryauditNum',title:'����',width:100,hidden:false},
			{field:'modifyRate',title:'ǿ����˴���',width:100,hidden:false},
			{field:'mandatoryauditRate',title:'����',width:100,hidden:false},
			//{field:'auditNum',title:'��˴���',width:100,align:'left',formatter:setCellAuditNum},
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
	var selectTab = $('#statTabs').tabs('getSelected'); // ��ȡ��ǰѡ�е�ҳǩ
	var selectTabTitle = selectTab.panel('options').title; // ��ȡ��ǰѡ�е�ҳǩ�ı���
	var locInput=$("#Loc").val()
	var type = "LOC"
	if(selectTabTitle == "��ҽ������"){
		type = "Doctor"
	}
	if(selectTabTitle == "��ҩƷ����"){
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
        var ModifyNumData=ModifyNum.split(",");  //�ַ���ת����
		var obj={};
		obj.name="�޸Ĵ���";
		obj.type='bar';
		obj.data= ModifyNumData.slice(0,ModifyNumData.length);  // slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		var MandatoryAuditNum=GetLocModifyNum["MandatoryAuditNum"];
		var MandatoryAuditData=MandatoryAuditNum.split(",");  // �ַ���ת����
		var obj={};
		obj.name="ǿ����˴���";
		obj.type='bar';
		obj.data= MandatoryAuditData.slice(0,MandatoryAuditData.length);  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		
		var locDesc=GetLocModifyNum["locDesc"];
		var LocData=locDesc.split(","); 
		var obj={};
		obj.name="����";
		obj.type='category';
		obj.data= LocData.slice(0,LocData.length);  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		LocArr.push(obj);
		var legendArr=['�޸Ĵ���','ǿ����˴���'];
		InitCompareECharts("locEcharts",TempArr,LocArr,legendArr)
	}
	
	
	var GetDocModifyNum= data.GetDocModifyNum;
	if(GetDocModifyNum!=""){
		var ModifyNum=GetDocModifyNum["ModifyNum"];
		var TempArr=[],LocArr=[];
        var ModifyNumData=ModifyNum.split(",");  //�ַ���ת����
		var obj={};
		obj.name="�޸Ĵ���";
		obj.type='bar';
		obj.data= ModifyNumData.slice(0,ModifyNumData.length);  // slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		var MandatoryAuditNum=GetDocModifyNum["MandatoryAuditNum"];
		var MandatoryAuditData=MandatoryAuditNum.split(",");  // �ַ���ת����
		var obj={};
		obj.name="ǿ����˴���";
		obj.type='bar';
		obj.data= MandatoryAuditData.slice(0,MandatoryAuditData.length);  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		var legendArr=["�޸Ĵ���","ǿ����˴���"];
		var locDesc=GetDocModifyNum["locDesc"];
		var LocData=locDesc.split(","); 
		var obj={};
		obj.name="ҽ��";
		obj.type='category';
		obj.data= LocData.slice(0,LocData.length);  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		LocArr.push(obj);
		var legendArr=["�޸Ĵ���","ǿ����˴���"];
		InitCompareECharts("docEcharts",TempArr,LocArr,legendArr)
	}
	
	var RecipeAuditYoYNum= data.RecipeAuditYoYNum;
	if((RecipeAuditYoYNum!="")&&(RecipeAuditYoYNum!=undefined)){
		var curData=RecipeAuditYoYNum["curData"]; 	//��������
		var TempArr=[],levArr=[];
        var curDataArr=curData.split(",");  		//�ַ���ת����
        var YearStrData=RecipeAuditYoYNum["YearStr"];
        var YearStrArr=YearStrData.split(",");
		var obj={};
		obj.name=YearStrArr[0];
		obj.type='bar';
		obj.data= curDataArr.slice(0,curDataArr.length); 	// slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		var lastData=RecipeAuditYoYNum["lastData"];  		// ȥ������
		var lastDataArr=lastData.split(",");  				// �ַ���ת����
		var obj={};
		obj.name=YearStrArr[1];
		obj.type='bar';
		obj.data= lastDataArr.slice(0,lastDataArr.length);  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		var lastMonthData=RecipeAuditYoYNum["lastMonthData"];   	 	// ȥ������
		var lastMonthArr=lastData.split(","); 				 // �ַ���ת����
		var obj={};
		obj.name=YearStrArr[2];
		obj.type='bar';
		obj.data= lastMonthArr.slice(0,lastMonthArr.length);  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempArr.push(obj);
		var levNum=RecipeAuditYoYNum["levNum"];
		var levData=levNum.split(","); 
		var obj={};
		obj.name="���";
		obj.type='category';
		obj.data= levData.slice(0,levData.length);  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		levArr.push(obj);
		InitCompareECharts("YoYEcharts",TempArr,levArr,YearStrArr)
		
		
		//ǿ�������״ͼ
		var curAuditData=RecipeAuditYoYNum["curAuditData"]; 	//��������
		var TempAuditArr=[];
        var curAuditDataArr=curAuditData.split(",");  		//�ַ���ת����
 
		var obj={};
		obj.name=YearStrArr[0];
		obj.type='bar';
		obj.data= curAuditDataArr.slice(0,curAuditDataArr.length); 	// slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempAuditArr.push(obj);
		var lastAuditData=RecipeAuditYoYNum["lastAuditData"];  		// ȥ������
		var lastAuditDataArr=lastData.split(",");  					// �ַ���ת����
		var obj={};
		obj.name=YearStrArr[1];
		obj.type='bar';
		obj.data= lastAuditDataArr.slice(0,lastAuditDataArr.length);  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempAuditArr.push(obj);
		var lastMonthAuditData=RecipeAuditYoYNum["lastMonthAuditData"];   	 // ȥ������
		var lastMonthAuditArr=lastMonthAuditData.split(","); 				 // �ַ���ת����
		var obj={};
		obj.name=YearStrArr[2];
		obj.type='bar';
		obj.data= lastMonthAuditArr.slice(0,lastMonthAuditArr.length); 		 //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempAuditArr.push(obj);
		InitCompareECharts("AuditTypeEcharts",TempAuditArr,levArr,YearStrArr)
	}
	
	var QuestionTypeNum= data.QuestionTypeNum;
	if(QuestionTypeNum!=""){
		var curData=QuestionTypeNum["ModifyData"]; 	//�޸�����
		var TempArr=[],levArr=[];
        var curDataArr=curData.split(",");  			//�ַ���ת����
        var YearStrData=QuestionTypeNum["ProblemStr"];
        var YearStrArr=YearStrData.split(",");
        var ModifyLocData=QuestionTypeNum["ModifyLocStr"];
        var ModifyLocStr=ModifyLocData.split(",");
        var Modifylength=ModifyLocStr.length
        for(var i =0;i<YearStrArr.length;i++){ 
           	var obj={};
			obj.name=YearStrArr[i];
			obj.type='bar';
			obj.data= curDataArr.slice((i*Modifylength),((i+1)*Modifylength));  // slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
			TempArr.push(obj);
		}
         
		var obj={};
		obj.name="����";
		obj.type='category';
		obj.data=ModifyLocStr;  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		levArr.push(obj);
		InitCompareECharts("questionTypeEcharts",TempArr,levArr,YearStrArr)
		
		
		var MandatoryAuditData=QuestionTypeNum["MandatoryAuditData"]; 	//�޸�����
		var TempAuditArr=[],levAuditArr=[];
        var MandatoryAuditArr=MandatoryAuditData.split(",");  			//�ַ���ת����
        var YearStrData=QuestionTypeNum["ProblemStr"];
        var YearStrArr=YearStrData.split(",");
        var MandatoryAuditLocData=QuestionTypeNum["MandatoryAuditLocStr"];
        var MandatoryAuditLocStr=MandatoryAuditLocData.split(",");
        var ModifyAuditlength=MandatoryAuditLocStr.length
		for(var j =0;j<YearStrArr.length;j++){ 
           	var obj={};
			obj.name=YearStrArr[j];
			obj.type='bar';
			obj.data= MandatoryAuditArr.slice((j*ModifyAuditlength),((j+1)*ModifyAuditlength));  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
			TempAuditArr.push(obj);
		}
         
		var obj={};
		obj.name="����";
		obj.type='category';
		obj.data=MandatoryAuditLocStr;  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		levAuditArr.push(obj);
		InitCompareECharts("questionAuditTypeEcharts",TempAuditArr,levAuditArr,YearStrArr)
		
		//ǿ�������״ͼ
		/*var curAuditData=RecipeAuditYoYNum["curAuditData"]; 	//��������
		var TempAuditArr=[];
        var curAuditDataArr=curAuditData.split(",");  		//�ַ���ת����
 
		var obj={};
		obj.name=YearStrArr[0];
		obj.type='bar';
		obj.data= curAuditDataArr.slice(0,curAuditDataArr.length); 	// slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempAuditArr.push(obj);
		var lastAuditData=RecipeAuditYoYNum["lastAuditData"];  		// ȥ������
		var lastAuditDataArr=lastData.split(",");  					// �ַ���ת����
		var obj={};
		obj.name=YearStrArr[1];
		obj.type='bar';
		obj.data= lastAuditDataArr.slice(0,lastAuditDataArr.length);  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
		TempAuditArr.push(obj);
		var lastMonthAuditData=RecipeAuditYoYNum["lastMonthAuditData"];   	 // ȥ������
		var lastMonthAuditArr=lastMonthAuditData.split(","); 				 // �ַ���ת����
		var obj={};
		obj.name=YearStrArr[2];
		obj.type='bar';
		obj.data= lastMonthAuditArr.slice(0,lastMonthAuditArr.length); 		 //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
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
              data:legendArr, /*['�޸Ĵ���','ǿ����˴���'],*/
              x:100,
              y:20
       },
      
  
	    toolbox: {
	        show: true,
	        feature: {
		        mark : { show: true }, //����
                    //dataView: { show: true, readOnly: false }, //����Ԥ��
                    restore : { show: true }, //��ԭ
                   // saveAsImage : { show: true } //�Ƿ񱣴�ͼƬ
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
	        	name:$g("�·�"),
            	type : 'category',
            	data : [$g("1��"),$g("2��"),$g("3��"),$g("4��"),$g("5��"),$g("6��"),$g("7��"),$g("8��"),$g("9��"),$g("10��"),$g("11��"),$g("12��")]  //,"�ϼ�"
        	}
    	],*/
    	yAxis : [
        {
            type : 'value',
            name:"����",
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


//��ȡ�����ϸ��Ϣ
/* function showAuditDetail(regNo,stDate,edDate,locName){ 			
	var lnk = "dhcckb.recipeauditdetail.csp?regNo="+regNo+"&stDate="+stDate+"&edDate="+edDate+"&locName="+encodeURI(encodeURI(locName));	
	websys_showModal({
		width: window.screen.availWidth-50,
		height:window.screen.availHeight-100,
		url: lnk,
		iconCls:"icon-w-paper",
		title: '����¼��ϸ',
		closed: true,
		onClose:function(){}
	});
	
}

function setCellAuditNum(value, rowData, rowIndex){
	return '<a href="#" style="text-decoration:underline" onclick="showAuditDetail(\''+rowData.regNo+'\',\''+rowData.stDate+'\',\''+rowData.endDate+'\',\''+rowData.locName+'\')">&nbsp;'+value+'&nbsp;</a>';

} */

//�����������Echartsͼ
function locprescEcharts(data){
	var TempArr=[],LocArr=[];
	var submitNumArr=[],errorprescNumArr=[],locDescArr=[];
	for (var i=0;i<data.length;i++){		
		var LocDesc=data[i].locName;		 // �������ơ�
		var submitNum=data[i].submitNum;     // ȫ���ύ�Ĵ���
		var errorprescNum=data[i].errorprescNum // �������� 
		submitNumArr.push(submitNum);
		errorprescNumArr.push(errorprescNum);
		locDescArr.push(LocDesc);
	}
	var obj={};
	obj.name="��������";
	obj.type='bar';
	obj.data= submitNumArr;  // slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	var obj={};
	obj.name="����������";
	obj.type='bar';
	obj.data= errorprescNumArr;  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);

	var obj={};
	obj.name="����";
	obj.type='category';
	obj.data= locDescArr;  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	
	LocArr.push(obj);
	var legendArr=['��������','����������'];
	InitCompareECharts("locprescEcharts",TempArr,LocArr,legendArr,"����������ͳ��ͼ")
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
			if ((title=="��ҽ������")){				 		
				  initDocDatagrid();        
			}else if(title=="��ҩƷ����"){				
				  initDrugDatagrid();      
			}else{
				loadDataGrid();
			}
		}
	}); 
}

function initDocDatagrid(){

	var diccolumns=[[ 
			{field:'locName',title:'ҽ������',width:100,hidden:false},
			{field:'submitNum',title:'ȫ����������',width:100,hidden:false,formatter:setDocCellNum},
			{field:'errorNum',title:'������������',width:100,hidden:false,formatter:setDocCellNum},
			{field:'errorRate',title:'��������',width:100,hidden:false},
			{field:'auditNum',title:'���ҩƷ����',width:100,hidden:false,formatter:setDocCellNum},
			//{field:'prescNum',title:'ȫ����������',width:100,hidden:false,formatter:setCellNum},
			{field:'errorprescNum',title:'������ҩƷ����',width:100,hidden:false,formatter:setDocCellNum},
			//{field:'modifyNum',title:'�����޸Ĵ���',width:100,hidden:false,formatter:setCellNum},
			
			{field:'modifyNum',title:'ҽ���޸���',width:100,hidden:false,formatter:setDocCellNum},
			{field:'modifyRate',title:'ҽ���޸���',width:100,hidden:false},
			{field:'mandatoryauditNum',title:'ǿ����˴���',width:100,hidden:false,formatter:setDocCellNum},
			{field:'mandatoryauditRate',title:'ǿ�������',width:100,hidden:false},
			//{field:'auditNum',title:'��˴���',width:100,align:'left',formatter:setCellAuditNum},
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

//ҽ���������Echartsͼ
function docprescEcharts(data){
	var TempArr=[],LocArr=[];
	var submitNumArr=[],errorprescNumArr=[],locDescArr=[],modifyNumArr=[],mandatoryauditNumArr=[];
	for (var i=0;i<data.length;i++){		
		var LocDesc=data[i].locName;		 	// �������ơ�
		var submitNum=data[i].submitNum;     	// ȫ���ύ�Ĵ���
		var errorprescNum=data[i].errorprescNum // �������� 
		var modifyNum=data[i].modifyNum;     	// �޸���
		var mandatoryauditNum=data[i].mandatoryauditNum // ǿ����˴��� 
		submitNumArr.push(submitNum);
		errorprescNumArr.push(errorprescNum);
		locDescArr.push(LocDesc);
		modifyNumArr.push(modifyNum);
		mandatoryauditNumArr.push(mandatoryauditNum);
	}
	var obj={};
	obj.name="��������";
	obj.type='bar';
	obj.data= submitNumArr;  // slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	var obj={};
	obj.name="����������";
	obj.type='bar';
	obj.data= errorprescNumArr;  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	var obj={};
	obj.name="�޸���";
	obj.type='bar';
	obj.data= modifyNumArr;  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	var obj={};
	obj.name="ǿ�������";
	obj.type='bar';
	obj.data= mandatoryauditNumArr;  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	var obj={};
	obj.name="ҽ��";
	obj.type='category';
	obj.data= locDescArr;  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	LocArr.push(obj);
	var legendArr=['��������','����������','�޸���','ǿ�������'];
	InitCompareECharts("docprescEcharts",TempArr,LocArr,legendArr,"ҽ���������ͳ��ͼ")
}


function initDrugDatagrid(){

	var diccolumns=[[ 
			{field:'drugName',title:'ҩƷ����',width:200,hidden:false},
			{field:'totalNum',title:'ҩƷ����',width:100,hidden:false},
			{field:'errorNum',title:'������ҩƷ����',width:100,hidden:false},
			{field:'errorRate',title:'��������',width:100,hidden:false},
			//{field:'auditNum',title:'������ҩƷ���ڴ�����',width:100,hidden:false,formatter:setCellNum},
			//{field:'prescNum',title:'ȫ����������',width:100,hidden:false,formatter:setCellNum},
			//{field:'errorprescNum',title:'������ҩƷ����',width:100,hidden:false,formatter:setCellNum},
			//{field:'modifyNum',title:'�����޸Ĵ���',width:100,hidden:false,formatter:setCellNum},
			
			//{field:'modifyNum',title:'ҽ���޸���',width:100,hidden:false,formatter:setCellNum},
			//{field:'modifyRate',title:'ҽ���޸���',width:100,hidden:false},
			//{field:'mandatoryauditNum',title:'ǿ����˴���',width:100,hidden:false,formatter:setCellNum},
			//{field:'mandatoryauditRate',title:'ǿ�������',width:100,hidden:false},
			//{field:'auditNum',title:'��˴���',width:100,align:'left',formatter:setCellAuditNum},
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

//ҽ���������Echartsͼ
function drugprescEcharts(data){
	var TempArr=[],LocArr=[];
	var totalNumArr=[],errorprescNumArr=[],locDescArr=[];
	for (var i=0;i<data.length;i++){		
		var LocDesc=data[i].drugName;		 	// �������ơ�
		var totalNum=data[i].totalNum;     	// ȫ���ύ�Ĵ���
		var errorprescNum=data[i].errorNum // ������ҩƷ
		totalNumArr.push(totalNum);
		errorprescNumArr.push(errorprescNum);
		locDescArr.push(LocDesc);
	}
	var obj={};
	obj.name="ҩƷ����";
	obj.type='bar';
	obj.data= totalNumArr;  // slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	var obj={};
	obj.name="������ҩƷ��";
	obj.type='bar';
	obj.data= errorprescNumArr;  //  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	TempArr.push(obj);
	
	var obj={};
	obj.name="ҩƷ����";
	obj.type='category';
	obj.data= locDescArr;  //   slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
	obj.axisLabel = {//������̶ȱ�ǩ��������á�	
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
	var legendArr=['ҩƷ����','������ҩƷ��'];
	InitCompareECharts("drugprescEcharts",TempArr,LocArr,legendArr,"ҩƷ���ͳ��ͼ")
}


//���ӿ��Ҵ���
function addLoc()
{
	$('#locwin').show();
	$('#locwin').window({
	   title:'������Ϣ',
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
	//����columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'LocID',title:'����ID',width:100},
		 {field:'LocDesc',title:'��������',width:200}
		]];
	
	//����datagrid
	$('#locTable').datagrid({
		url:$URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=GetAllLoc&hospID="+LgHospID+"&input="+"",
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,400],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		selectOnCheck:true,
		onUnselect:function(rowIndex, rowData)
		{
			var LocDesc=$("#LocDescStr").val();
			var Loc =rowData.LocDesc
             if(LocDesc.indexOf(Loc) != -1)
             {
	             LocDesc=LocDesc.replace(Loc+"��","")
	             $("#LocDescStr").val(LocDesc);
             }
		},
		 onSelect:function(rowIndex, rowData)
		 {
	       var LocDesc = rowData.LocDesc
	       MeetMember(LocDesc)
		 },	
	});	
	//$(".datagrid-header-check input[type=checkbox]").on("click",function(){ ///2018-04-13 cy ���۽���
	//	AllMember();
	//})
}

//ѡ��λ���Ա
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
	  LocDesc=name+"��";
	}else{
	  LocDesc=LocDesc+name+"��";
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
			userNames=rows[i].userName+"��";
		}else{
			userNames=userNames+rows[i].userName+"��";
		}
		
	}
	$("#UserNames").val(userNames);
	//MeetMember(userNames) ;
}

//��ѯ
function FindLoc()
{
	//1�����datagrid 
	$('#locTable').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var LocDesc=$("#LocDesc").val();
	$('#locTable').datagrid({
		url:$URL+"?ClassName=web.DHCCKBRecipeAuditStat&MethodName=GetAllLoc",
		queryParams:{
			hospID:LgHospID,
			input:LocDesc
		}	
	});
}

//��ӵ�����
function MemAdd()
{
  var LocDesc=$("#LocDescStr").val()
  $("#Loc").val(LocDesc)	
  $('#locwin').window('close');
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
