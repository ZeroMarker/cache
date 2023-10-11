
$(document).ready(function(){
	initParams();
	
	initPage();
	
	initCombobox();

	initDatagrid();
	
	initMethod();
	
	initBtndrop();
})

function initParams(){
	//colorArr=["red","blue","yellow","orange","green","#fff60b","#ccc","#eac","#666","#888"]
	colorArr=["#ff32a1","#d952d1","#9152d9","#494dee","#327eb2","#449be2","#39c6c8","#2ab66a","#aade5f","#ffb746","#ff793e","#ff5252","#f16e57"] //hxy 2018-10-31
	
	//PatientID==""?EpisodeID="":"";
}

function initPage(){
	if(EpisodeID==""){
		$(".amount").hide()	
	}
}

function initCombobox(){
	$HUI.combobox("#histAdm",{
		url:LINK_CSP+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonAdms&PatID="+PatientID+"&LgHospID="+HospID+"&AdmId="+EpisodeID, //hxy 2020-06-18 HospID //hxy 2022-10-17 AdmId
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#noAdmTip").length?$("#noAdmTip").hide():"";
			$(".amount").show();
	        EpisodeID = option.value;
	        $HUI.combobox("#Type",{"url":LINK_CSP+"?ClassName=web.DHCEMPatThisOrd&MethodName=QueryOrderTypeNew&AdmId="+EpisodeID+"&InHospID="+HospID})
	        search();
	    }	
	})
	
	if(EpisodeID!="") $HUI.combobox("#histAdm").setValue(EpisodeID);
	
	$HUI.combobox("#Type",{//hxy 2018-11-01 医嘱子类
		url:LINK_CSP+"?ClassName=web.DHCEMPatThisOrd&MethodName=QueryOrderTypeNew&AdmId="+EpisodeID+"&InHospID="+HospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        search();
	    }	
	})
	$HUI.combobox("#Type").setValue($g("全部"));
	$HUI.combobox("#Type").setText($g("全部"));
	
	$HUI.combobox("#StopOrAll",{//hxy 2018-11-01 医嘱子类
		url:"",
		data:[{value:1,text:$g("未停止")},{value:2,text:$g("已停止")}],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        search();
	    }	
	})
	$HUI.combobox("#StopOrAll").setValue("1");

}

function initDatagrid(){
	var columns=[[
		{field: 'ActiveQtySum',title: '总价',width:100},
		{field: 'ArcPrice',title: '单价',width:110},
		{field: 'OrdBilled',title: '收费状态',width:95,cellStyle:'billDescCellStyle'},
		{field: 'OrdCreateDate',title: '下嘱日期',width:100}, 
		{field: 'OrdCreateTime',title: '下嘱时间',width:80},
		{field: 'OrdStartDate',title: '开始日期',width:100},
		{field: 'OrdStartTime',title: '开始时间',width:90},
		{field: 'ArcimDesc',title: '医嘱名称',width:300},
		{field: 'DoseQty',title: '剂量',width:50},
		{field: 'DoseUnit',title: '单位',width:50},
		{field: 'PHFreq',title: '频次',width:50},
		{field: 'Priority',title: '优先级',width:110},
		{field: 'Instr',title: '用法',width:110},
		{field: 'Doctor',title: '医生',width:60},
		{field: 'Dura',title: '疗程',width:60},
		{field: 'OrdStatus',title: '医嘱状态',width:60},
		{field: 'OrdAction',title: '皮试备注',width:110},
		{field: 'OrdDepProcNotes',title: '备注',width:110},
		{field: 'OEItemID',title: 'OEORI_RowId',width:60},
		{field: 'OrdXDate',title: '停止日期',width:110},
		{field: 'EndDate',title: '预停时间',width:110},
		{field: 'BillType',title: '费别',width:60},
		{field: 'ActiveQty',title: '实发数量',width:60},
		{field: 'LabEpisodeNo',title: '标本号',width:110},
		{field: 'MaterialBarCode',title: '高值条码',width:110}, 
		//{field: 'ToInpatient',title: '医嘱来源'}, 
		{field: 'OrderPackQty',title: '数量',width:60},
		{field: 'PrescNo',title: '处方号',width:110},
		{field: 'OrdSkinTestResult',title: '皮试结果',width:60}
		]];	
		
		var params  = EpisodeID+"^^"+HospID 
		$HUI.datagrid("#showOrderTable",{
	        url:'dhcapp.broker.csp?ClassName=web.DHCEMPatThisOrd&MethodName=GetOrdByAdmDataToJsonNew&Params='+params,
			fit:true,
			rownumbers:true,
			columns:columns,
			pageSize:60,  
			pageList:[30,60,120], 
			autoSizeColumn:false,
			loadMsg: $g('正在加载信息...'),
			rownumbers : true,
			pagination:true,
			singleSelect:true,
			selectOnCheck: false,
			checkOnSelect: false,
			bodyCls:'panel-header-gray', //hxy 2018-10-29
			toolbar:"#toolBar", //hxy 2023-01-11 st
			border:false, //ed
	        rowStyler: function(index,row){
				if((row.OrdCreateDate=="")||(row.OrdCreateDate==undefined)){
					return 'background-color:#6293BB;color:#fff;'; // return inline style
				}
			},
			onLoadSuccess:function (data){
				var typeDesc = $HUI.combobox("#Type").getValue();
				//if(typeDesc!=="全部") return;
				var obj1=document.getElementById("TotalAmount");	//总费用
				var obj2=document.getElementById("PayedAmount");	//已缴费合计
				var obj3=document.getElementById("NotPayedAmount");	//未缴费合计
				var obj4=document.getElementById("ObservedAmount"); //留观押金
				//根据就诊号返回病人费用信息 
		    	if(data.AllPrice!=""){
			    	$(".pricePart").show();
				    if(obj1) obj1.innerHTML=$g("总")+":"+data.TotalAmount;
				    if(obj2) obj2.innerHTML=$g("已缴")+":"+data.PayedAmount;
				    if(obj3) obj3.innerHTML=$g("未缴")+":"+data.NotPayedAmount;
			    }else{
				    $(".pricePart").show();
				    if(obj1) obj1.innerHTML=$g("总")+":0.00";
				    if(obj2) obj2.innerHTML=$g("已缴")+":0.00";
				    if(obj3) obj3.innerHTML=$g("未缴")+":0.00";
				}
				
				showImgView(data.ItmPriceScale);
			}
    });
}
function initMethod (){
	$("#queryBtn").on('click',function(){	//查询按钮事件
		search();
	})	
}

function showImgView(datas){
	if(datas.length==0) return;
	var imgViewWidth = $("#imgView").width();
	$("#imgView").html("");
	$("#imgViewDesc").html("");
	var len = datas.length;
	for (var i=0;i<len;i++){
		var itmData = datas[i];
		var orderTypeDesc=itmData.OrderTypeDesc;
		var scale = itmData.Scale;
		var itmWidth =imgViewWidth*scale;
		addViewItm(orderTypeDesc,scale,itmWidth);
		
	}
	
}

function addViewItm(desc,scale,itmWidth){
	var viewItmNum = $(".viewItm").length;
	var itmColor = colorArr[viewItmNum];
	var itmHtml = '<div class="viewItm"  style="display:inline-block;width:'+itmWidth+';height:10px;background:'+itmColor+'"></div>'
	
	var imgViewDescItm = '<div style="display:inline-block;width:10px;height:10px;background:'+itmColor+';border-radius:10px"></div>';
		imgViewDescItm=imgViewDescItm+'<div style="display:inline-block;padding-right:20px">'+desc+(scale*100).toFixed(1)+'%</div>';
	
	$("#imgView").append(itmHtml);
	$("#imgViewDesc").append(imgViewDescItm);
}

//lvpeng 2016-12-02
function initBtndrop(){
	//初始化医嘱大类
	runClassMethod("web.DHCEMPatThisOrd","QueryOrderType",{'AdmId':EpisodeID,"InHospID":HospID},
	function(data){
		addAllMenuItm(data);
	},"text",false);
	
}
function addAllMenuItm(data){
	for(var i in data.split("^")){
		addMenuItm(data.split("^")[i]);
	}	
}
function addMenuItm(title){
	$('#mm3').menu('appendItem', {
		text: title,
		iconCls: '',
		onclick: menuItmClick
	});	
}
function menuItmClick(){
	$("#sb").find(".l-btn-text").text($(this).text());  //设置上面文字
	search();
}
/// 初始化并查找触发事件
function search(){
	
	var type =  $HUI.combobox("#Type").getValue();
	var stopOrd = $HUI.combobox("#StopOrAll").getValue();
	var params = EpisodeID+"^"+type+"^"+HospID+"^"+stopOrd
	$HUI.datagrid('#showOrderTable').load({
		"Params":params
	})
	
}
