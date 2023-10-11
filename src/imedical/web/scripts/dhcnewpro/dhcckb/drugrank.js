/*var signArr = [{"value":"","text":'ȫ��Ժ��'},{"value":"������׼�����ֻ�ҽԺ��Ժ","text":'������׼�����ֻ�ҽԺ[��Ժ]'},{"value":"������׼�����ֻ�ҽԺ��Ժ","text":'������׼�����ֻ�ҽԺ[��Ժ]'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ","text":'������ҽ�ƴ�ѧ��һ����ҽԺ'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201203","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201203)'},{"value":"�人�е�һҽԺ","text":'�人�е�һҽԺ'},{"value":"�����γ���ҽ","text":'�����γ���ҽ'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201215","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201215)'},{"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201221","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201221)'}];
signArr.push({"value":"������ҽ�ƴ�ѧ��һ����ҽԺ20201224","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20201224)'});
signArr.push({"value":"������ҽ�ƴ�ѧ��һ����ҽԺ202102010209","text":'������ҽ�ƴ�ѧ��һ����ҽԺ(20210201-0209)'});
signArr.push({"value":"�����γ���ҽ20210225","text":'�����γ���ҽ(20210225)'});
signArr.push({"value":"�Ϻ����мκ�ҽԺ","text":'�Ϻ����мκ�ҽԺ'});
signArr.push({"value":"�Ϻ����мκ�ҽԺ20210203","text":'�Ϻ����мκ�ҽԺ202102-03'});
signArr.push({"value":"��������ҽԺ","text":'��������ҽԺ'});
signArr.push({"value":"����������Ժ","text":'����������Ժ'});
signArr.push({"value":"��������ҽԺ20210419","text":'��������ҽԺ20210419'});
signArr.push({"value":"��������ҽԺ��","text":'��������ҽԺ��'});
signArr.push({"value":"������ҽ����","text":'������ҽ����'});
signArr.push({"value":"������Ժ20210317","text":'������Ժ20210317'});
signArr.push({"value":"�����еڶ�ҽԺ","text":'�����еڶ�ҽԺ'});
signArr.push({"value":"��ҽ����Ժ","text":'��ҽ����Ժ'});
signArr.push({"value":"��ҽ����Ժ�ڶ���","text":'��ҽ����Ժ�ڶ���'});
signArr.push({"value":"�Ͼ�ҽ�ƴ�ѧ���ĸ���ҽԺ","text":'�Ͼ�ҽ�ƴ�ѧ���ĸ���ҽԺ'});
signArr.push({"value":"�Ͼ�ҽ�ƴ�ѧ���ĸ���ҽԺ202106010615","text":'�Ͼ�ҽ�ƴ�ѧ���ĸ���ҽԺ20210601-0615'});
signArr.push({"value":"�γ���ҽ202108","text":'�γ���ҽ(202108)'});
signArr.push({"value":"����һԺ091308150831","text":'����һԺ0913(08150831)'});
signArr.push({"value":"���հ�������","text":'���հ�������'});
signArr.push({"value":"���հ������׵ڶ���","text":'���հ������׵ڶ���'});
signArr.push({"value":"�Ƹ��ˮ����","text":'�Ƹ��ˮ����'});
signArr.push({"value":"̩��������ҽԺ����Ժ��","text":'̩��������ҽԺ����Ժ��'});
signArr.push({"value":"�麣������ҽԺ","text":'�麣������ҽԺ'});
signArr.push({"value":"��ɽ����ҽҽԺ","text":'��ɽ����ҽҽԺ'});
signArr.push({"value":"�Ĵ��˱���Ժ","text":'�Ĵ��˱���Ժ'});
signArr.push({"value":"����������У","text":'����������У'});
signArr.push({"value":"��������ҽԺ","text":'��������ҽԺ'});
*/
$(document).ready(function() {
    initResGrid();        //����ͳ������ 
    initDetailGrid();
    initButton();
    initCombobox();
    initChart("");
})
//���ؽ������
function initResGrid(){
	

	///  ����columns
	var columns=[[
		{field:"pid",width:10,title:"pid",hidden:true},	
		{field:"drugId",width:10,title:"drugId",hidden:true},
		{field:"monId",width:10,title:"monId",hidden:true},
		{field:"drugDesc",width:400,title:"ҩƷ����"},
		{field:"comDosageNum",align:'center',width:115,title:"�÷�",newtitle:'ComDosage',formatter:linkPrescdetails},
		{field:"ruleUsageNum",align:'center',width:115,title:"�÷�����",newtitle:'RuleUsage',formatter:linkPrescdetails},
		{field:"interEachNum",align:'center',width:115,title:"�໥����",newtitle:'InterEach',formatter:linkPrescdetails},
		{field:"tabooNum",align:'center',width:115,title:"�������",newtitle:'Taboo',formatter:linkPrescdetails},
		{field:"drugIrriNum",align:'center',width:115,title:"ҩ�����",newtitle:'DrugIrri',formatter:linkPrescdetails},
		{field:"ruleIndicNum",align:'center',width:115,title:"��Ӧ֢",newtitle:'RuleIndic',formatter:linkPrescdetails},
		{field:"ruleContrNum",align:'center',width:115,title:"����֢",newtitle:'RuleContr',formatter:linkPrescdetails},
		{field:"ruleMatNeAtNum",align:'center',width:115,title:"ע������",newtitle:'RuleMatNeAt',formatter:linkPrescdetails,hidden:true},
		{field:"ruleContrTwoNum",align:'center',width:115,title:"����",newtitle:'RuleContrTwo',formatter:linkPrescdetails,hidden:true},
		{field:"funIndicatNum",align:'center',width:115,title:"��������",newtitle:'FunIndicat',hidden:true},
		{field:"repeatNum",align:'center',width:115,title:"�ظ���ҩ",newtitle:'Repeat',formatter:linkPrescdetails},
		{field:"skinTestRuleNum",align:'center',width:115,title:"Ƥ����ҩ",newtitle:'SkinTestRule',formatter:linkPrescdetails},
		{field:"drugInterEachNum",align:'center',width:115,title:"ҩ���໥����",newtitle:'DrugInterEach',formatter:linkPrescdetails,hidden:true},
		{field:"warnNum",align:'center',width:115,title:"����",newtitle:'DrugNotification',formatter:linkPrescdetails,hidden:true},
		{field:"liquidConfigNum",align:'center',width:115,title:"Һ������",newtitle:'LiquidConfig',formatter:linkPrescdetails},
		{field:"repeatIngNum",align:'center',width:115,title:"�ɷ��ظ�",newtitle:'RepeatIngr',formatter:linkPrescdetails},
		{field:"transNum",align:'center',width:115,title:"Ƭ����ҩ;��",newtitle:'LiquidConfig',formatter:linkPrescdetails},
		{field:"eighteenTabooNum",align:'center',width:115,title:"ʮ�˷�",newtitle:'EighteenTaboo',formatter:linkPrescdetails},
		{field:"nineteenTabooNum",align:'center',width:115,title:"ʮ��η",newtitle:'NineteenTaboo',formatter:linkPrescdetails},
		{field:"bpgmNum",align:'center',width:115,title:"��Ʒ����",newtitle:'bsgm',formatter:linkPrescdetails},
		
		
	]];
	
	///  ����datagrid
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
				$("#propNum").html("��ʾ��"+data.propNum+"%   "+"���ѣ�"+data.tipsNum+"%   "+"��ʾ��"+data.warnnNum+"%   "+"��ֹ��"+data.forbidNum+"%");			  	  
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
	  //      text: '������ҩĿ¼�ֲ�ռ��ͼ',
	  //      left: 'center'
	  //  },
    tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    series: [
        {
            name: '������Դ',
            type: 'pie',
            radius: '60%',
            center: ['50%', '50%'],
            data: [
                {value: data.comDosageNums, name: '�÷�'},
                {value: data.ruleUsageNums, name: '�÷�����'},
                {value: data.interEachNums, name: '�໥����'},
                {value: data.tabooNums, name: '�������'},
                {value: data.drugIrriNums, name: 'ҩ�����'},
				{value: data.ruleIndicNums, name: '��Ӧ֢'},
                {value: data.ruleContrNums, name: '����֢'},
                {value: data.ruleMatNeAtNums, name: 'ע������'},
                {value: data.ruleContrTwoNums, name: '����'},
                {value: data.funIndicatNums, name: '��������'}
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
	 
   // ʹ�ø�ָ�����������������ʾͼ��
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
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'ҩƷ��Ƶ����',
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
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'��˱��ͳ��ͼ',
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
	$(".item-errnum").bind('click',OpenProCenter);	// ������֣�����������ϸ  
	
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
	}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
	collapsible:true,
	border:true,
	closed:"true"
	};
	initDetailGrid()
	new WindowUX('����ҩƷ����', 'details', '1100', '600', option).Init();
}
function initDetailGrid()
{
	///  ����columns
	var columns=[[
	       {field:"itemDesc",width:fixWidth(0.5),title:"ҩƷ����"},
	       {field:"errNum",width:fixWidth(0.1),title:"������",sortable:'true'},
	       {field:"rate",width:fixWidth(0.1),title:"�������"}
	]];

	///  ����datagrid
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
///ҩƷ��ϸ
function linkPrescdetails(value, rowData, rowIndex)
{
	
	if(value!=0){
		html = "<a href='#' onclick=\"LoadPrescDetailsWin('"+rowData.drugId+"','"+this.title+"','"+rowData.drugDesc+"','"+rowData.pid+"','"+this.newtitle+"')\">"+value+"</a>";				
		return html;
	}
}
function LoadPrescDetailsWin(drugId,filed,drug,pid,newtitle){	

	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'ҩƷ��ϸ�б�',
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
///��ʼ��combobox
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
	
	// ����
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
 
 // Ժ��
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
	
	// ������
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

///��ʼ��ehart
function initChart(type)
{
	var stDate = $("#fromdate").datebox('getValue');
	var endDate = $("#todate").datebox('getValue');
	if(type == ""){
		type = "month";	// Ĭ������
	}
	runClassMethod("web.DHCCKBDrugRank","JsIntRevMonTrend",{"stDate":stDate,"endDate":endDate,"type":type},function(jsonString){
		initheiChart(jsonString)
	},'json','false')	
}

///�·�/����
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
		        //text: '����ͳ��'
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
		           /*  name:'ʱ��', */
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
			       /*  name:"����", */
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
		// ʹ�ø�ָ�����������������ʾͼ��
        myChart.setOption(option);
	}


///����Ŀ¼����
function expExcel()
{
	var hosp = $("#hosp").combobox('getText');
	var stDate = $("#fromdate").datebox('getValue');
	var endDate = $("#todate").datebox('getValue');
	
}