///DHCDoc.OP.BillInfo.js
var BillInfoDataGrid;
var BillInfoDataSelectedRow;
var Chart1;
var LoadStopOrd="";
var tabExecDetailsDataGrid;
$(function(){
	///���ر���ҽ���ķ�����Ϣ
	InitBillInfoList();
	InitKeyWord();
	/*
	LoadEchart();
	
	window.setTimeout(function(){
			LoadLocChartData();
		},1000);
	*/
});
function InitKeyWord(){
	$("#OrdComStatusKeyWord").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'ȫ��',id:'All',selected:true},
	        {text:'�ѳ���',id:'Stop'},
	        {text:'δ�շ�',id:'UnPay'},
	        {text:'���շ�',id:'Payed'},
	        {text:'�ѷ�ҩ',id:'Dispensing'},
	        {text:'δ��ҩ',id:'UnDispensing'}
	    ],
	    onClick:function(v){
			LoadBillInfoList();
		}
	});
	
}

function ReLoadLabInfo(){
	LoadBillInfoList();
	LoadChartData();
}
var selRowIndex="";
function InitBillInfoList(){
	
		/*var BillInfoColumns=[[
		{ field: 'IsCNMedItem',checkbox:true}
		,{ field: 'ReportLinkInfo',hidden:true}
		,{field: 'SeqNo', title: '���', width: 70}
		,{field: 'OrdBilled', title: '�Ʒ�״̬', width: 70}
		,{field: 'OrderSum', title: unescape('�ܼ�'), width: 70}
		,{field: 'Desc', title: 'ҽ������', width: 250,
			formatter: function(value,row,index){
				if(row.SignFlag=='1'){
					value='<img src="../skin/default/images/ca_icon_green.png"/>'+value;
				}
				return value;
			}
		}
		,{field:'InsuNationCode',title:'����ҽ������',align:'center',width:180,auto:false,
			formatter:function(value,rec){  
			   var btn=""
			   if (value!=""){
               var btn = '<a class="editcls" onclick="InsuNationShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
		       
			   }
			   return btn;
            }
		},
		{field:'InsuNationName',title:'����ҽ������',align:'center',width:180,auto:false,
			formatter:function(value,rec){  
			   var btn=""
			   if (value!=""){
               var btn = '<a class="editcls" onclick="InsuNationShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
		       
			   }
			   return btn;
            }
		}
		,{field: 'DoseQty', title: '���μ���', width: 80}	
		,{field: 'Instr', title: '�÷�', width: 60}
		,{field: 'PHFreq', title: 'Ƶ��', width: 60}
		,{field: 'Dura', title: '�Ƴ�', width: 50}
		,{field: 'PackQty', title: '����', width: 60}
		,{field: 'OrdStatus', title: 'ҽ��״̬', width: 80,
			formatter:function(value,row,index){
				var btn =""; 
			 	if (row.OrderViewFlag=="Y"){
	    			var btn = '<a style="color: #ff7f24;text-decoration: underline;" onclick="OpenOrderView(\''+row.OEItemID +'\')">'+value+'\</a>';
	    		}else{
	 				btn=value;
	 			}
	    		return btn;
	    		
      	}}
		,{field: 'DrugActiveQty', title: 'ʵ������', width: 80}
		,{field: 'ReLoc', title: '���տ���', width: 100}
		,{field: 'OrdDepProcNotes', title: '��ע', width: 60}
		,{field: 'Price', title: '����', width: 70,align:'right'}
		,{field: 'PrescNo', title: '������', width: 150}
		,{field: 'ExeDetails', title: 'ִ�����', width: 80,sortable: false,align:'center',hidden:true,
			formatter:function(value,row,index){
				if (row.OEItemID ==""){
					return "";
				}
	    		var btn = '<a style="color: #ff7f24;text-decoration: underline;" onclick="OpenExeDetails(\''+row.OEItemID +'\',\''+row.Desc+'\')">'+$g("��ϸ")+'</a>';
	    		return btn;
      	}}
		,{field: 'UserDep', title: '����', width: 150}
		,{field: 'Doctor', title: 'ҽʦ', width: 80}
		
		,{field: 'OrdStartDate', title: '��ʼʱ��', width: 180}
		,{field: 'OEDStatus', title: '��ҩ״̬', width: 80}
		,{field: 'AdmReason', title: '�ѱ�', width: 60}
		,{field: 'CoverMainInsur', title: 'ҽ��', width: 60}
		,{field: 'MaterialBarCode', title: '��ֵ����', width: 80}
		,{field: 'LabNo', title: '�����', width: 150}
		,{field: 'OrdLabSpec', title: '�걾', width: 60}
		,{field: 'OrdSkinTest', title: 'Ƥ��', width: 60}
		,{field: 'OrdAction', title: 'Ƥ�Ա�ע', width: 80}
		,{field: 'OrdSkinTestResult', title: 'Ƥ�Խ��', width: 80}
		//,{field: 'OEDStatus', title: '��ҩ״̬', width: 60}
		//,{field: 'OEItemID', title: 'ҽ������', width: 150,sortable: true}
		,{field: 'Priority', title: '���ȼ�', width: 100,sortable: true}
		,{field: 'OrdXDate', title: 'ֹͣ����', width: 80,sortable: true}
		,{field: 'OrdXTime', title: 'ֹͣʱ��', width: 80,sortable: true}
		
		,{field: 'OrderUsableDays', title: '��������', width: 80,sortable: true}
		,{field: 'OrderNotifyClinician', title: '�Ӽ�', width: 60,sortable: true}
		,{field: 'OrdSpeedFlowRate', title: '��Һ����', width: 80,sortable: true}
		,{field: 'OrderFlowRateUnitdesc', title: '���ٵ�λ', width: 80,sortable: true}
		,{field: 'OrderNeedPIVAFlag', title: '��Ҫ��Һ', width: 80,sortable: true}
		,{field: 'OrderLocalInfusionQty', title: '��Һ����', width: 60,sortable: true}
		,{field: 'ExceedReasonDesc', title: '�Ƴ̳���ԭ��', width: 80,sortable: true}
		,{field: 'OrderStage', title: 'ҽ���׶�', width: 80,sortable: true}
		,{field: 'OrderPilotPro', title: 'ҩ����Ŀ', width: 80,sortable: true}
		,{field: 'OrderOperation', title: '�����б�', width: 80,sortable: true}
		,{field: 'BindSource', title: '����Դ', width: 160,sortable: true}
		,{field: 'OrderDIACat', title: '�ز�����', width: 80,sortable: true}
		,{field:'OrderViewFlag',hidden:true}
		,{ field: 'OrderChronicDiagCode', title: '��������', width: 80,sortable: true}
		,{ field: 'OEItemID', title: '���', width: 80,sortable: true,
			formatter:function(value,rec){  
				var btn = '<a class="editcls" onclick="ordDetailInfoShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
				return btn;
			}
		}
		
		
	]];*/
	
	BillInfoDataGrid=$('#tabBillInfoList').datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		remoteSort: false,
		pagination : false,  
		rownumbers : false,  
		//pageSize: 150,
		//pageList : [150,100,200],
		idField:'SeqNo', //OEItemID
		//columns :BillInfoColumns,
		className:"web.DHCDocOPOrdInfo",
		queryName:"GetOrdByAdm",
		onColumnsLoad:function(cm){
			for (var i=0;i<cm.length;i++){
				if(cm[i]['field']=="InsuNationCode"){
					cm[i].formatter = function(value,rec){
						var btn=""
		 				   if (value!=""){
		                   var btn = '<a class="editcls" onclick="InsuNationShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
					       
		 				   }
		 				   return btn;
					}
				}
				if(cm[i]['field']=="InsuNationName"){
					cm[i].formatter = function(value,rec){
						var btn=""
		 				   if (value!=""){
		                   var btn = '<a class="editcls" onclick="InsuNationShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
					       
		 				   }
		 				   return btn;
					}
				}
				if(cm[i]['field']=="Desc"){
					cm[i].formatter = function(value,rec){
						if(rec.SignFlag=='1'){
							value='<img src="../skin/default/images/ca_icon_green.png"/>'+value;
						}
						return value;
					}
				}
				if(cm[i]['field']=="OrdStatus"){
					cm[i].formatter = function(value,rec){
						var btn =""; 
					 	if (rec.OrderViewFlag=="Y"){
			    			var btn = '<a text-decoration: underline;" onclick="OpenOrderView(\''+rec.OEItemID +'\')">'+value+'\</a>';
			    		}else{
			 				btn=value;
			 			}
			    		return btn;
					}
				}
				if(cm[i]['field']=="ExeDetails"){
					cm[i].formatter = function(value,rec){
						if (rec.OEItemID ==""){
							return "";
						}
			    		var btn = '<a style="color: #ff7f24;text-decoration: underline;" onclick="OpenExeDetails(\''+rec.OEItemID +'\',\''+rec.Desc+'\')">'+$g("��ϸ")+'</a>';
			    		return btn;
					}
				}
				if(cm[i]['field']=="OEItemID"){
					cm[i].formatter = function(value,rec){
						var btn = '<a class="editcls" onclick="ordDetailInfoShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
						return btn;
					}
				}
				if(cm[i]['field']=="OrdSpecDiagnosForm"){
					cm[i].formatter = function(value,rec){
						if(value==""){
							return "";
						}
						var btn = '<a class="editcls" onclick="OrdSpecDiagnosShow(\'' + value + '\',\'' + rec.OrdSpecLocDiagCatCode + '\',\'' + rec.OrdSerialNum + '\')">'+value+'</a>';
						return btn;
					}
				}
				if(cm[i]['field']=="OrdSkinTestResult"){
					cm[i].styler=function(value,row,index){
						if (value=="����"){
							return 'color:green';
						}else{
							return 'color:red';
						}
					}
				}
				if ((typeof cm[i].width == "undefined") || (cm[i].width == "")){
					if(cm[i]['field']=="SeqNo"){cm[i].width=70};
					if(cm[i]['field']=="OrdBilled"){cm[i].width=70};
					if(cm[i]['field']=="OrderSum"){cm[i].width=70};
					if(cm[i]['field']=="Desc"){cm[i].width=150};
					if(cm[i]['field']=="InsuNationCode"){cm[i].width=180};
					if(cm[i]['field']=="DoseQty"){cm[i].width=80};
					if(cm[i]['field']=="Instr"){cm[i].width=60};
					if(cm[i]['field']=="PHFreq"){cm[i].width=60};
					if(cm[i]['field']=="Dura"){cm[i].width=50};
					if(cm[i]['field']=="PackQty"){cm[i].width=60};
					if(cm[i]['field']=="OrdStatus"){cm[i].width=80};
					if(cm[i]['field']=="DrugActiveQty"){cm[i].width=80};
					if(cm[i]['field']=="ReLoc"){cm[i].width=100};
					if(cm[i]['field']=="OrdDepProcNotes"){cm[i].width=60};
					if(cm[i]['field']=="Price"){cm[i].width=70};
					if(cm[i]['field']=="PrescNo"){cm[i].width=150};
					if(cm[i]['field']=="ExeDetails"){cm[i].width=80};
					if(cm[i]['field']=="UserDep"){cm[i].width=150};
					if(cm[i]['field']=="Doctor"){cm[i].width=80};
					if(cm[i]['field']=="OrdStartDate"){cm[i].width=180};
					if(cm[i]['field']=="OEDStatus"){cm[i].width=80};
					if(cm[i]['field']=="AdmReason"){cm[i].width=60};
					if(cm[i]['field']=="CoverMainInsur"){cm[i].width=60};
					if(cm[i]['field']=="MaterialBarCode"){cm[i].width=60};
					if(cm[i]['field']=="LabNo"){cm[i].width=150};
					if(cm[i]['field']=="OrdLabSpec"){cm[i].width=60};
					if(cm[i]['field']=="OrdSkinTest"){cm[i].width=60};
					if(cm[i]['field']=="OrdAction"){cm[i].width=80};
					if(cm[i]['field']=="OrdSkinTestResult"){cm[i].width=80};
					if(cm[i]['field']=="Priority"){cm[i].width=100};
					if(cm[i]['field']=="OrdXDate"){cm[i].width=80};
					if(cm[i]['field']=="OrdXTime"){cm[i].width=80};
					if(cm[i]['field']=="OrderUsableDays"){cm[i].width=80};
					if(cm[i]['field']=="OrderNotifyClinician"){cm[i].width=60};
					if(cm[i]['field']=="OrdSpeedFlowRate"){cm[i].width=80};
					if(cm[i]['field']=="OrderFlowRateUnitdesc"){cm[i].width=80};
					if(cm[i]['field']=="OrderNeedPIVAFlag"){cm[i].width=80};
					if(cm[i]['field']=="OrderLocalInfusionQty"){cm[i].width=60};
					if(cm[i]['field']=="ExceedReasonDesc"){cm[i].width=80};
					if(cm[i]['field']=="OrderStage"){cm[i].width=80};
					if(cm[i]['field']=="OrderPilotPro"){cm[i].width=80};
					if(cm[i]['field']=="OrderOperation"){cm[i].width=80};
					if(cm[i]['field']=="BindSource"){cm[i].width=160};
					if(cm[i]['field']=="OrderDIACat"){cm[i].width=80};
					if(cm[i]['field']=="OrderChronicDiagCode"){cm[i].width=80};
					if(cm[i]['field']=="OEItemID"){cm[i].width=80};
				}
			}
			},
		frozenColumns:[[
				{field:'CheckOrd',title:'ѡ��',checkbox:'true',align:'center',width:70,auto:false},
			]],
		onClickRow:function(rowIndex, rowData){
			BillInfoDataSelectedRow=rowIndex;
            var OrderId=rowData.OEItemID;
			if (OrderId.indexOf("||")>-1){
				if (websys_getAppScreenIndex()==0){
					websys_emit("onSelectOrdInDoc",{OrderId:OrderId});
				}
			}
		},
		rowStyler: function(index,row){
			if (row.OrdStatus==$g("ֹͣ")){
				return 'background-color:#BDBEC2;color:#000000;';
			}else if (row.OEItemID!=""){
				return '';
			}else{
				return 'background-color:#C8FEC0;color:#000000;';
			}
		}
		,onLoadSuccess:function(data){ 
			if (LoadStopOrd==""){
				BillInfoDataGrid.datagrid('hideColumn', 'OrdXDate');
	            BillInfoDataGrid.datagrid('hideColumn', 'OrdXTime');
            }else{
	            BillInfoDataGrid.datagrid('showColumn', 'OrdXDate');
	            BillInfoDataGrid.datagrid('showColumn', 'OrdXTime');
	        }
	    },
		onCheck:function(rowIndex, rowData){
			var OEItemID=rowData.OEItemID;
			if ((selRowIndex!=="")||(OEItemID.indexOf("||")<0)){
				return false;
			}
			var SeqNo=rowData.SeqNo;
			var IsCNMedItem=rowData.IsCNMedItem;
	        var rows = BillInfoDataGrid.datagrid('getRows');
			//��ѡ��ҽ��
			if (SeqNo.indexOf(".")<0){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var mySeqNo=rows[idx].SeqNo;
					var myIsCNMedItem=rows[idx].IsCNMedItem;
					if (myIsCNMedItem!=IsCNMedItem) continue;
					if (mySeqNo.split(".")[0]==SeqNo){
						selRowIndex=idx;
						BillInfoDataGrid.datagrid('checkRow',idx);
					}
				}
			}else if (SeqNo.indexOf(".")>=0){ //��ѡ��ҽ�� ���ڿ��е����
				var MasterrowIndex=BillInfoDataGrid.datagrid('getRowIndex',SeqNo.split(".")[0]);
				if (MasterrowIndex>=0){
					var myIsCNMedItem=rows[MasterrowIndex].IsCNMedItem;
					if (myIsCNMedItem==IsCNMedItem) {
						BillInfoDataGrid.datagrid('checkRow',MasterrowIndex);
					}
				}
			}
			selRowIndex="";
		},
		onUncheck:function(rowIndex, rowData){
			var OEItemID=rowData.OEItemID;
			if ((selRowIndex!=="")||(OEItemID.indexOf("||")<0)) return false;
			var SeqNo=rowData.SeqNo;
			var IsCNMedItem=rowData.IsCNMedItem;
	        var rows = BillInfoDataGrid.datagrid('getRows');
			//ȡ����ѡ��ҽ��
			if (SeqNo.indexOf(".")<0){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var mySeqNo=rows[idx].SeqNo;
					var myIsCNMedItem=rows[idx].IsCNMedItem;
					if (myIsCNMedItem!=IsCNMedItem) continue;
					if (mySeqNo.split(".")[0]==SeqNo){
						selRowIndex=idx;
						BillInfoDataGrid.datagrid('uncheckRow',idx);
					}
				}
			}else if (SeqNo.indexOf(".")>=0){ //��ѡ��ҽ��
				var MasterrowIndex=BillInfoDataGrid.datagrid('getRowIndex',SeqNo.split(".")[0]);
				if (MasterrowIndex>=0){
					var myIsCNMedItem=rows[MasterrowIndex].IsCNMedItem;
					if (myIsCNMedItem==IsCNMedItem) {
						BillInfoDataGrid.datagrid('uncheckRow',MasterrowIndex);
					}
				}
			}
			selRowIndex="";
		},
		onBeforeLoad:function(param){
			BillInfoDataGrid.datagrid("uncheckAll");
		}
	});
	LoadBillInfoList();
}

function LoadBillInfoList(){
	var SelOrderTypeList="";
	if ($("#OrdReSubCatKeyWord").has("ul").length>0){
		$.each($("#OrdReSubCatKeyWord").keywords("getSelected"),function(i,obj){
			if (obj.id=="All"){
				return true;
			}
			if (SelOrderTypeList==""){
				SelOrderTypeList=obj.id;
			}else{
				SelOrderTypeList=SelOrderTypeList+"^"+obj.id;
			}
		});
	}
	var OrdComStatus="";
	if ($("#OrdComStatusKeyWord").has("ul").length>0){
		$.each($("#OrdComStatusKeyWord").keywords("getSelected"),function(i,obj){
			if (obj.id=="All"){
				return true;
			}
			if (OrdComStatus==""){
				OrdComStatus=obj.id;
			}else{
				OrdComStatus=OrdComStatus+"^"+obj.id;
			}
		});
	}	
	$.q({
	    ClassName : "web.DHCDocOPOrdInfo",
	    QueryName : "GetOrdByAdm",
	    EpisodeID:EpisodeID,
	    UserID:"",BillType:"",
	    OrdComStatus:OrdComStatus,
	    SelOrderTypeList:SelOrderTypeList,
	    //Pagerows:BillInfoDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		BillInfoDataGrid.datagrid("unselectAll").datagrid('loadData',GridData);
		InitOrdTypeSeachInfo();
	}); 
}
function InitOrdTypeSeachInfo(){
	if ($("#OrdReSubCatKeyWord").has("ul").length>0){
		return;
	}
	$.cm({
	    ClassName : "web.DHCDocOPOrdInfo",
	    MethodName : "GetOrdCalInfoByAdm",
	    EpisodeID:EpisodeID,
	    UserID:""
	},function(OrdCalInfo){
		//ҽ�����ط�����Ϣչʾ
		$("#OrdReSubCatKeyWord").keywords({
		    singleSelect:true,
		    labelCls:'red',
		    items:OrdCalInfo.OrdTypeList,
		    onClick:function(v){
			    LoadBillInfoList();
			}
		});
		//����������Ϣչʾ
		$("#PatFeeInfoKeyWord").keywords({
		    singleSelect:false,
		    labelCls:'blue',
		    items:OrdCalInfo.AdmInfo
		}).off("click");
	}); 
}
function OrderTypeCheckChangeHandler(event,value){
	LoadBillInfoList();
}
function GetOrdTypeCheckList(){
	var CheckBoxList=$("div.datagrid-toolbar tr .checked", BillInfoDataGrid.datagrid("getPanel"));
	var Length=CheckBoxList.length;
	var CheckBoxID;
	var SelOrderTypeList="";
	for (var i=0;i<Length;i++) {
		CheckBoxID=$(CheckBoxList[i]).prev()[0].id;
		//if ($(CheckBoxList[i]).checkbox("getValue")){
			
			if (SelOrderTypeList==""){
				SelOrderTypeList=CheckBoxID.split("_")[0];
			}else{
				SelOrderTypeList=SelOrderTypeList+"_"+CheckBoxID.split("_")[0];
			}
		//}
	}
	return SelOrderTypeList;
}
function LoadEchart(){
	/*
	var option = {
	    title : {
	        text: '������ϸ',
	        x:'left'
	    },
	    tooltip : {
	        trigger: 'item',
	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	    },
	    legend: {
	        x : 'left',
	        pading: 10,
	        y : 'bottom'
	    },
	    calculable : true,
	    series : [{
	            name:'���β���',
	            type:'pie',
	            center : ['25%', '50%'],
	            startAngle:10,       
	            data:[]
	        },{
	            name:'���ս��ﲡ��',
	            type:'pie',
	            center : ['75%', '50%'],
	            startAngle:10,
	            radius: ['70%', '90%'],
	            minAngle: 2,
	            data:[]
	        },{
	            name:'���ձ���',
	            type:'pie',
	            center : ['75%', '50%'],
	            radius: [0, '55%'],
	            label: {
	                normal: {
	                    position: 'inner'
	                }
	            },
	            startAngle:10,
	            data:[]
	        }
	    ]
	};
	*/
	//�ѵ�����ͼ
	var option = {
	    title: {
	        text: '',
	        textStyle: {
		        fontSize:13
	        },
	    },
	    legend: {
	        textStyle: {
	            color: "#20CF56"
	        }
	    },
	    tooltip: {
		    position: ['50%','10%'],
	        formatter: function(params, ticket, callback) {
	            return params.seriesName;
	        }
	    },
	    xAxis: {
	        data: [],
	        type: 'value',
	        max: 1000,
	        show: false,
	        axisTick: {
	            show: false
	        }
	    },
	    yAxis: {
	        type: 'category',
	        show: false,
	        axisTick: {
	            show: false
	        }
	    },
	    color:  ["#FE4343", "#F59747", "#F5D44E", "#45DAF6", "#4977F3", "#5247F4", "#AD48F1"],
	    series: []
	};
	option.title.text=$g("���β���");
	Chart1 = echarts.init(document.getElementById('BillCat1'),'macarons');
	Chart1.setOption(option);
	option.title.text=$g("���ս���");
	Chart2 = echarts.init(document.getElementById('BillCat2'),'macarons');
	Chart2.setOption(option);
	option.title.text=$g("���ձ���");
	Chart3 = echarts.init(document.getElementById('BillCat3'),'macarons');
	Chart3.setOption(option);
	LoadChartData();
}
function LoadChartData(){
		$.ajax({
			type: 'POST',
	        dataType: 'json',
	        url: '../web.DHCDocAdmBillInfo.cls',
	        async: true,
	        cache: false,
	        data: {
	            action: 'GetAdmBillInfo',
	            EpisodeID: EpisodeID,
	            UserID: ""
	        },
			success: function (result){
				if (result==null){return}
				if (result) { 
					var seriesList=formatData(result);
					var options = Chart1.getOption();  
	                //options.series[1].data = result;  
	                options.series= seriesList;
	                Chart1.hideLoading();  
	                Chart1.setOption(options);   
	            } 
			},  
	        error : function(errorMsg) {  
	            $.messager.alert("��ʾ","ͼ����������ʧ��","info",function(){
		            Chart1.hideLoading();  
		        });  
	        } 
		});
	}
function LoadLocChartData(){
	$.ajax({
		type: 'POST',
        dataType: 'json',
        url: '../web.DHCDocAdmBillInfo.cls',
        async: true,
        cache: false,
        data: {
            action: 'GetDateAdmBillInfo',
            UserID: session['LOGON.USERID'],
            LogonLoc: session['LOGON.CTLOCID'],
            StDate: '',
            EdDate: '',
            AdmType:''
        },
		success: function (result){
			if (result==null){return}
			if (result) { 
				var seriesList=formatData(result);
				var options = Chart2.getOption();  
                //options.series[1].data = result;  
                options.series= seriesList;
                Chart2.hideLoading();  
                Chart2.setOption(options);   
            } 
		},  
        error : function(errorMsg) {  
            $.messager.alert("��ʾ","ͼ����������ʧ��","info",function(){
		        Chart2.hideLoading();  
		    });  
        } 
	});
	$.ajax({
		type: 'POST',
        dataType: 'json',
        url: '../web.DHCDocAdmBillInfo.cls',
        async: true,
        cache: false,
        data: {
            action: 'GetInsunSumInfo',
            UserID: session['LOGON.USERID'],
            LogonLoc: session['LOGON.CTLOCID'],
            StDate: '',
            EdDate: '',
            AdmType:''
        },
		success: function (result){
			if (result==null){return}
			if (result) { 
				var seriesList=formatData(result);
				var options = Chart3.getOption();  
                //options.series[1].data = result;  
                options.series= seriesList;
                Chart3.hideLoading();  
                Chart3.setOption(options);   
            } 
		},  
        error : function(errorMsg) {  
            $.messager.alert("��ʾ","ͼ����������ʧ��","info",function(){
		        Chart1.hideLoading();  
		    }); 
        } 
	});
}

function formatData(result){
	var total = 0;
	for (var i = 0; i < result.length; i++) {
	    total += parseFloat(result[i].value);
	}
	if (total==0){
		total=1000;
	}
	var seriesList=[];
	var Diff=0;
	for (var i = 0; i < result.length; i++) {
		var per=parseFloat(result[i].value)/parseFloat(total);
		seriesList.push({
			type: 'bar',
	        name: result[i].name+" "+result[i].value+" "+(per*100).toFixed(2)+"%",
	        barMinHeight:20,
	        data: [(function(){
		        var data=(per*1000);
		        if (data<20){
			        Diff=parseFloat(per*1000)-20;
			    	data=20;
			    }else{
				    if (data>300){
						data=parseFloat(data)+Diff;
						Diff=0;
					}
			    }
		        return data;
		    })()],
	        stack: 'income',
	        barWidth: 15,
	        itemStyle: {
	            emphasis: {
	                shadowColor: 'rgba(0, 0, 0, 0.5)',
	                shadowBlur: 10,
	                opacity: 0.8
	            }
	        }
		});
	}
	return seriesList
}
function OpenReportLink(ReportLinkInfo){
	if (ReportLinkInfo=="") {return;}
	var ReportLinkInfoArr=ReportLinkInfo.split("!");
	var ReportType=ReportLinkInfoArr[0];
	var Param=ReportLinkInfoArr[1];
	if (ReportType=="L"){
		//var path = "oeorder.labreport.csp?Param=" + Param; 
		var path = "jquery.easyui.dhclabreport.csp?VisitNumberReportDR=" + Param;
        websys_createWindow(path, "ReportLink", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=100,width=800,height=600")
	}else if (ReportType=="Ris") {
		var RptParm=tkMakeServerCall("web.DHCRisCommFunctionEx","GetReportUrl",ReportLinkInfoArr[1],ReportLinkInfoArr[2],session['LOGON.USERID'])
		if (RptParm!=""){
			var Item=RptParm.split(":")
		    if (Item[0]=="http"){
		       websys_createWindow(RptParm, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
		    }else{
			 	var curRptObject = new ActiveXObject("wscript.shell");
				curRptObject.run(RptParm);
		    }
		}
	}
    return
}

///ִ�м�¼ִ����ϸ
function OpenExeDetails(OEItemID,ItemDesc){
   destroyDialog("ExecDetailsDiag");
   var Content="<table id='tabExecDetails' cellpadding='5' style='margin:5px;border:none;'></table>";
   var iconCls="";
   createModalDialog("ExecDetailsDiag",ItemDesc, 550, 350,iconCls,"",Content,"");
    
   var ExecFeeColumns=[[ 
   				{field:'TExStDate',title:'Ҫ��ִ��ʱ��',width:120},
	 			{field:'TRealExecDate',title:'ִ��ʱ��',width:120},
	 			{field:'TExecState',title:'״̬',width:80,
	 				styler: function(value,row,index){
		 				if (row.TExecStateCode){
			 				if( ["δִ��","D","C"].indexOf(row.TExecStateCode) > -1 ){
				 				return "background-color: yellow;"
				 			}
		 				}
		 			}
	 			},
	 			{field:'TExecRes',title:'ִ��ԭ��',width:100},
	 			{field:'TExecUser',title:'������',width:80},
	 			{field:'ExecPart',title:'��鲿λ',width:180},
	 			{field:'Notes',title:'��ע',width:100},
	 			{field:'OrderExecId',title:'ִ�б��',width:100}
	]]
	tabExecDetailsDataGrid=$("#tabExecDetails").datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 10,
		pageList : [10,100,200],
		idField:'FeeId',
		columns :ExecFeeColumns
	});
	$.q({
	    ClassName : "web.DHCDocInPatPortalCommon",
	    QueryName : "FindOrderExecDet",
	    orderId : OEItemID,
	    Pagerows:tabExecDetailsDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		tabExecDetailsDataGrid.datagrid('loadData',GridData);
	});
}

function destroyDialog(id){
   $("body").remove("#"+id); //�Ƴ����ڵ�Dialog
   $("#"+id).dialog('destroy');
}

/**
 * ����һ��ģ̬ Dialog
 * @param id divId
 * @param _url Div����
 * @param _title ����
 * @param _width ���
 * @param _height �߶�
 * @param _icon ICONͼ��
 * @param _btntext ȷ����ťtext
*/
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
   if(_btntext==""){
	   var buttons=[{
		   text:$g('�ر�'),
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
	   }]
   }else{
	   var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		}]
   }
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        buttons:buttons
    });
}
function OpenOrderView(OEItemID){
	websys_showModal({
		url:"dhc.orderview.csp?ord=" + OEItemID,
		title:$g('ҽ���鿴'),
		//width:screen.availWidth-200,height:screen.availHeight-300,
        width:"90%",height:screen.availHeight-300,
		iconCls:'icon-w-paper'
	});
}
function getRefData(){
   var rtnObj= {data:"",toTitle:"",msg:"",success:true};
   var SelRowListRowData=BillInfoDataGrid.datagrid('getSelections');
   if (SelRowListRowData.length==0){
	   $.extend(rtnObj, { msg: "δѡ����Ҫ������������!",success:false});
	   return rtnObj;
   }
   var ARCOSFormulaExistFlag=0,NotARCOSFormulaFlag=0;
   var oeoris="",CMoeoris="";
   for (var i=0;i<SelRowListRowData.length;i++){
	   if (SelRowListRowData[i].OEItemID==""){
		   continue;
	   }
	   var OrderId=SelRowListRowData[i].OEItemID;
	   if (SelRowListRowData[i].IsCNMedItem==1) {
		   if (CMoeoris=="") CMoeoris=OrderId;
		   else CMoeoris=CMoeoris+"^"+OrderId;
		   var ArcimARCOSRowId=SelRowListRowData[i].ArcimARCOSRowId;
		   if (ArcimARCOSRowId!=""){
				var IsARCOSFormula=$.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:ArcimARCOSRowId
				},false);
				if (IsARCOSFormula=="1") ARCOSFormulaExistFlag=1;
				else NotARCOSFormulaFlag=1;
			}else{
				NotARCOSFormulaFlag=1;
			}
	   }else{
		   if (oeoris=="") oeoris=OrderId;
		   else oeoris=oeoris+"^"+OrderId;
	   }
   }
   if ((oeoris=="")&&(CMoeoris=="")){
	   $.extend(rtnObj, { msg: "δѡ����Ҫ������������!",success:false});
	   return rtnObj;
   }
   if ((oeoris!="")&&(CMoeoris!="")) {
	   $.extend(rtnObj, { msg: "��ҩ�Ͳ�ҩ����ͬʱ����!",success:false});
	   return rtnObj;
   }
   var toTitle=$g("ҽ��¼��");
   if (oeoris=="") {
	   if ((ARCOSFormulaExistFlag=="1")&&(NotARCOSFormulaFlag=="1")&&(FormulaCanAppendItem=="0")){
			$.extend(rtnObj, { msg: "Э����������������ҽ��һ����!",success:false});
	   		return rtnObj;
	   }
	   oeoris=CMoeoris,toTitle=$g("��ҩ¼��");
   }
   oeoris=oeoris.split("^").sort(function(num1,num2){
       return parseFloat(num1.split("||")[1])-parseFloat(num2.split("||")[1]);
   }).join("^");
   $.extend(rtnObj, { data: oeoris,toTitle:toTitle});
   return rtnObj;
} 
function ordDetailInfoShow(OrdRowID){
	websys_showModal({
		url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
		title:'ҽ����ϸ',
		width:400,height:screen.availHeight-200,
		iconCls:'icon-w-trigger-box'
	});
}
function InsuNationShow(OEItemID){
	websys_showModal({
		url:"dhc.orderinsudetail.csp?OrderId=" + OEItemID+"&EpisodeID="+EpisodeID,
		title:'����ҽ���鿴',
		width:640,height:250,
		iconCls:'icon-w-list'
	});
}

function OrdSpecDiagnosShow(SpecLocDiagCatName,SpecLocDiagCatCode,SerialNum){
	var url="opdoc.specloc.diag.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&SpecLocDiagCatCode="+SpecLocDiagCatCode+"&SerialNum=ord|"+SerialNum;
	websys_showModal({
		iconCls:'icon-w-edit',
		url:url,
		title:SpecLocDiagCatName+$g(' ��д'),
		width:SpecLocDiagCatCode=='KQMB'?1200:400,
		height:700,
		closable:true,
		callBackRetVal:"",
		onBeforeClose:function(){
			// if (parseInt(websys_showModal("options").callBackRetVal)>0) {
			// 	ReturnObj.SuccessFlag=true;
			// }else{
			// 	$.messager.alert("��ʾ", $g("δ��дת�Ʊ�"),"info",function(){
			// 		ReturnObj.SuccessFlag=false;
			// 	});
			// }
		},
		CallBackFunc:function(retval){
			if (typeof retval=="undefined") retval="";
			websys_showModal("options").callBackRetVal=retval;
			websys_showModal("close");
		}
	})
}
