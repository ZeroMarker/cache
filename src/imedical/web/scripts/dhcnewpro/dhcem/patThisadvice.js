
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
	
	$HUI.combobox("#Type",{//hxy 2018-11-01 ҽ������
		url:LINK_CSP+"?ClassName=web.DHCEMPatThisOrd&MethodName=QueryOrderTypeNew&AdmId="+EpisodeID+"&InHospID="+HospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        search();
	    }	
	})
	$HUI.combobox("#Type").setValue($g("ȫ��"));
	$HUI.combobox("#Type").setText($g("ȫ��"));
	
	$HUI.combobox("#StopOrAll",{//hxy 2018-11-01 ҽ������
		url:"",
		data:[{value:1,text:$g("δֹͣ")},{value:2,text:$g("��ֹͣ")}],
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
		{field: 'ActiveQtySum',title: '�ܼ�',width:100},
		{field: 'ArcPrice',title: '����',width:110},
		{field: 'OrdBilled',title: '�շ�״̬',width:95,cellStyle:'billDescCellStyle'},
		{field: 'OrdCreateDate',title: '��������',width:100}, 
		{field: 'OrdCreateTime',title: '����ʱ��',width:80},
		{field: 'OrdStartDate',title: '��ʼ����',width:100},
		{field: 'OrdStartTime',title: '��ʼʱ��',width:90},
		{field: 'ArcimDesc',title: 'ҽ������',width:300},
		{field: 'DoseQty',title: '����',width:50},
		{field: 'DoseUnit',title: '��λ',width:50},
		{field: 'PHFreq',title: 'Ƶ��',width:50},
		{field: 'Priority',title: '���ȼ�',width:110},
		{field: 'Instr',title: '�÷�',width:110},
		{field: 'Doctor',title: 'ҽ��',width:60},
		{field: 'Dura',title: '�Ƴ�',width:60},
		{field: 'OrdStatus',title: 'ҽ��״̬',width:60},
		{field: 'OrdAction',title: 'Ƥ�Ա�ע',width:110},
		{field: 'OrdDepProcNotes',title: '��ע',width:110},
		{field: 'OEItemID',title: 'OEORI_RowId',width:60},
		{field: 'OrdXDate',title: 'ֹͣ����',width:110},
		{field: 'EndDate',title: 'Ԥͣʱ��',width:110},
		{field: 'BillType',title: '�ѱ�',width:60},
		{field: 'ActiveQty',title: 'ʵ������',width:60},
		{field: 'LabEpisodeNo',title: '�걾��',width:110},
		{field: 'MaterialBarCode',title: '��ֵ����',width:110}, 
		//{field: 'ToInpatient',title: 'ҽ����Դ'}, 
		{field: 'OrderPackQty',title: '����',width:60},
		{field: 'PrescNo',title: '������',width:110},
		{field: 'OrdSkinTestResult',title: 'Ƥ�Խ��',width:60}
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
			loadMsg: $g('���ڼ�����Ϣ...'),
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
				//if(typeDesc!=="ȫ��") return;
				var obj1=document.getElementById("TotalAmount");	//�ܷ���
				var obj2=document.getElementById("PayedAmount");	//�ѽɷѺϼ�
				var obj3=document.getElementById("NotPayedAmount");	//δ�ɷѺϼ�
				var obj4=document.getElementById("ObservedAmount"); //����Ѻ��
				//���ݾ���ŷ��ز��˷�����Ϣ 
		    	if(data.AllPrice!=""){
			    	$(".pricePart").show();
				    if(obj1) obj1.innerHTML=$g("��")+":"+data.TotalAmount;
				    if(obj2) obj2.innerHTML=$g("�ѽ�")+":"+data.PayedAmount;
				    if(obj3) obj3.innerHTML=$g("δ��")+":"+data.NotPayedAmount;
			    }else{
				    $(".pricePart").show();
				    if(obj1) obj1.innerHTML=$g("��")+":0.00";
				    if(obj2) obj2.innerHTML=$g("�ѽ�")+":0.00";
				    if(obj3) obj3.innerHTML=$g("δ��")+":0.00";
				}
				
				showImgView(data.ItmPriceScale);
			}
    });
}
function initMethod (){
	$("#queryBtn").on('click',function(){	//��ѯ��ť�¼�
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
	//��ʼ��ҽ������
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
	$("#sb").find(".l-btn-text").text($(this).text());  //������������
	search();
}
/// ��ʼ�������Ҵ����¼�
function search(){
	
	var type =  $HUI.combobox("#Type").getValue();
	var stopOrd = $HUI.combobox("#StopOrAll").getValue();
	var params = EpisodeID+"^"+type+"^"+HospID+"^"+stopOrd
	$HUI.datagrid('#showOrderTable').load({
		"Params":params
	})
	
}
