var hospComp="",hospID = (typeof REQUEST_WAY==="undefined") ? session['LOGON.HOSPID'] : "2",dictList=[];
var config={
	tableConfig:{
		header:{image:"", imageName:"", height:"", width:"", xAxis:"", yAxis:""},
		special:{dateFormatFlag:"", ruleFlag:"", recentlyNums:"", officeRuleFlag:"", showDirection:""},
		page:{ifColorPrint:""}
	},
	textConfig:{TwoBPInSameCol: "", intervalTime: "", intervalTimeAM: "", intervalTimePM: "", intervalTimeAM2: "", intervalTimePM2: "", bpShowNums:"", ifSequence: "", texts:[]},
	contentConfig:{timing:"", days:"", redTiming:"", ifPointCellCenter:"", sheet:[], curve:[]},
	printRuleConfig:{
		eventRule:[],
		afterDrop:[],
		suddenFever:[],
		retest:[],
		scaleRule:[],
		showRule:{
			ifEventPortrait:"",
			ifDeathEventDelay:"",
			ifBreakTransLoc:"",
			eventDr:"",
			day:"",
			number:"",
			operNumAfterDay:"",
			operNumAfterEvent:"",
			separator:"",
			connector:"",
			operChangePage:"",
			OnlyLastOperDay:"",
			OperDayCalcZero:"",
			OnlyTwoOperDay:"",
			FirstDayZero:"",
			OnlyCurOperDayOutMD:"",
			OnlyRecentOperDayFD:"",
			childbirthEvent:"",
			birthInOperDays:"",
			birthNotCalcOperNum:"",
			status:"",
			heartCode:"",
			pluseCode:"",
			fillStyle:"",
			color:"",
			onlySamePointHPConnect:"",
			skinTestYText:"",
			skinTestYColor:"",
			skinTestNText:"",
			skinTestNColor:"",
			ifShowMultMed:""
		}
	}
}
$(function() {
	if(typeof REQUEST_WAY==="undefined"){
		hospComp = GenHospComp("Nur_IP_ChartPrint",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
		/*hospID=hospComp.getValue();
		hospComp.options().onSelect = function(i,d){
			// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
			// HOSPRowId: "2"
			console.log(arguments);
			switchHosp(d)
		}  ///ѡ���¼� */
	}else{
		hospComp=GenHospComp();
	}
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		console.log(arguments);
		switchHosp(d)
	}  ///ѡ���¼�

	initTable();
})

/// �л�Ժ��
function switchHosp(data){
	hospID=data.HOSPRowId;
	reloadChartData("chartList"); /// ����������µ�ģ���б�
	getDictList(); /// ��ȡ�ֵ�ά������
}

/// ��ʼ������table
function initTable(){
	getDictList();
	/// ��������
	initTextTable()
	/// �����������
	initContentTable();
	/// ��ӡ��������
	initPrintRuleTable();
	/// ������µ�ģ��
	initChart("chartList");
	reloadChartData("chartList");
}

/// �������µ�ģ���б�table
function initChart(tableId,option){
	$('#'+tableId).datagrid({
		fit : true,
		idField:"rowID",
		columns :[[
			{field:'courtyardArea',title:'Ժ��',width:220,hidden:option ? false : true},
			{field:'status',title:'״̬',width:50,formatter:function(value,row,index){
		    	return value=="N" ? "ͣ��" : "����";
		    },styler:function(value,row,index){
				return value=="N" ? "color:#F16E57" : "color:#3FBD79";
			},hidden:option ? true : false},
		    {field:'IfBaby',title:'������',width:60,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    }},
	    	{field:'name',title:'������',width:150},
	    	{field:'applyArea',title:'���÷�Χ',width:120,formatter:function(value,row,index){
		    	return value.join("");
		    }},
	    	{field:'notApplyArea',title:'�����÷�Χ',width:120,formatter:function(value,row,index){
		    	return value.join("");
		    }},
	    	{field:'NewBabyAge',title:'����',width:100,formatter:function(value,row,index){
		    	return value ? value+"��" : "";
		    }}
		]],
		toolbar:option ? "" : "#toolbar",
		singleSelect : true,
		loadMsg : '������..',
 		onClickRow:function(rowIndex,rowData){
			if(tableId=="chartList") getChartConfig(rowData.rowID);
		},
	});
}

/// �������µ�ģ������
function reloadChartData(tableId,option,chartId){
	if(typeof REQUEST_WAY==="undefined"){
		runClassMethod("Nur.NIS.Service.Chart.PrintSetting","getTemperatureChartList",{"HospID":hospID,"Event":option ? option : ""},function(res){
			if(res.code==0){
				handleChartData(res.data,tableId,chartId)
			}
		},'json',false)
	}else{
		$.ajax({
			url: API_BASE_URL+"/config/v1/nrChart/selectNrChartListByHospDr",
			type: 'GET',
			data:{chartHospDr: hospID},
			dataType: 'json',
			success: function(response) {
				if(response.code==200){
					handleChartData(response.data,tableId,chartId)
				}
			},
			error: function(xhr, status, error) {
				$.messager.popover({msg:"���µ�ģ���ѯʧ�ܣ�", type:'error'});
			}
		});
	}
}

/// ���µ�ģ�����ݴ���
function handleChartData(data,tableId,chartId){
	$("#"+tableId).datagrid('loadData',data);
	if(data.length>0){
		if(tableId=="chartList"){
			var rowId=chartId ? chartId : data[0].rowID;
			var index=$("#"+tableId).datagrid("getRowIndex",rowId);
			$("#"+tableId).datagrid("selectRow",index);
			getChartConfig(rowId);
		}
	}
}

/// ����/�޸����µ�ģ��
function openChart(flag){
	var selectChart=$("#chartList").datagrid("getSelections");
	if(flag && selectChart.length==0){
		return $.messager.popover({ msg: '��ѡ��Ҫ�޸ĵ����µ���', type:'info' });
	}
	$("#chart-dialog").dialog({title:(flag ? "�޸�" : "����")+"���µ���������"}).dialog("open");
	$("#chartType").combobox({
		panelWidth:249,
		panelHeight:100,
		valueField:"value",
		textField:"label",
		data: [{value: "T",label: "���µ�"},{value: "P",label: "��ʹ��"}]
	}).combobox("setValue","T");
	getLocList(flag,selectChart);
	if(flag){ /// �޸����ݻ���
        $('#chart-form').form("load",{
	 		chartId: flag ? selectChart[0].rowID : "",
	 		chartType: selectChart[0].chartType ? selectChart[0].chartType : "T",
	 		chartName: selectChart[0].name,
	 		childAge: selectChart[0].NewBabyAge
 		});
 		if(selectChart[0].status == "Y"){
	 		$("#ifActive").checkbox("check");
	 	}else{
		 	$("#ifActive").checkbox("uncheck");
		}
		if(selectChart[0].IfBaby == "Y"){
	 		$("#ifNewBaby").checkbox("check");
	 	}else{
		 	$("#ifNewBaby").checkbox("uncheck");
		}
	}else{
		$('#chart-form').form("clear");
		$("#ifActive").checkbox("check");
	}
}

/// ��ȡԺ�������б�
function getLocList(flag,selChart){
	if(typeof REQUEST_WAY==="undefined"){
		$.cm({
			ClassName:"Nur.NIS.Service.Base.Loc",
			QueryName:"FindLocItem",
			HospID:hospID,
			LocType:"E",
			LocDesc:"",
			CongfigName:"Nur_IP_ChartPrint",
			rows:999999
		},function(data){
			handleLocData(data.rows,flag,selChart);
		})
	}else{
		handleLocData([]);
	}
}

/// �����صĿ�������
function handleLocData(data,flag,selChart){
	$("#applyArea,#notApplyArea").combobox({
		panelWidth:249,
		multiple:true,
		valueField:"rowid",
		textField:"desc",
		data: data
	})
	if(flag){
		var applyArea=getApplyLoc(selChart[0].applyAreaObj);
		$("#applyArea").combobox("setValues",applyArea);
		var notApplyArea=getApplyLoc(selChart[0].notApplyAreaObj);
		$("#notApplyArea").combobox("setValues",notApplyArea);
	}
}

/// ��ȡѡ��ģ������÷�Χ�������÷�Χ
function getApplyLoc(data){
	var arr=[];
	if (data.length > 0) {
		data.forEach(function(val,index){
			arr.push(val.locID);
		});
    }
    return arr;
}

/// �������µ�ģ��
function saveChart(data,option){
	var chartId=data ? "" : $("#chartId").val();
	var chartName=data ? data.name+"-����" : $.trim($("#chartName").val());
	if(chartName=="") return $.messager.popover({ msg: '�����Ʋ���Ϊ�գ�', type:'error' });
	loading(data ? "���ڸ������µ�" : "���ڱ������µ�ģ��")
	var applyLoc = data ? getApplyLoc(data.applyAreaObj) : $("#applyArea").combobox("getValues");
	var notApplyLoc= data ? getApplyLoc(data.notApplyAreaObj) : $("#notApplyArea").combobox("getValues")
	var ifActive= data ? "Y" : ($("#ifActive").radio('getValue') ? "Y" : "N");
	var ifNewBaby= data ? data.IfBaby : ($("#ifNewBaby").radio('getValue') ? "Y" : "N");
	var childAge= data ? data.NewBabyAge : $("#childAge").numberbox("getValue");
	var chartType= data ? data.chartType : $("#chartType").combobox("getValue");
	var importChartId=option=="hospCopy" ? data.rowID : "";
	if(typeof REQUEST_WAY==="undefined"){
		$.cm({
			ClassName:"Nur.NIS.Service.Chart.PrintSetting",
			MethodName:"saveTemperatureChart",
			RowID:chartId,
			Name:chartName,
			HospID:hospID,
			ApplyLoc:applyLoc.join("^"),
			NotApplyLoc:notApplyLoc.join("^"),
			IsActive:ifActive,
			StareDate:"",
			EndDate:"",
			IfBaby: ifNewBaby,
			NewBabyAge:childAge,
			ChartType:chartType
		},function(res){
			if(res.code==0){
				handleChartResponse(res,option,importChartId);
			}else{
				return $.messager.popover({ msg: res.error, type:'error' });
			}
		})
	}else{
		var nrChart = {
			id: chartId,
			chartHospDr: hospID,
			chartName: chartName,
			chartIfactive: ifActive,
			chartIfbaby: ifNewBaby,
			chartNewbabyage: childAge,
			chartType:chartType
		};
		$.ajax({
			url: API_BASE_URL+"/config/v1/nrChart/saveorupdate",
			type: 'POST',
			data: JSON.stringify(nrChart),
			dataType: 'json',
			contentType: 'application/json',
			success: function(response) {
				// ����ɹ��Ļص�����
				// �����ﴦ����Ӧ���ݣ������丳ֵ��datagrid
				if(response.code==200){
					handleChartResponse(response,option,importChartId);
				}else{
					return $.messager.popover({ msg: "����ʧ�ܣ�", type:'error' });
				}
			},
			error: function(xhr, status, error) {
				$.messager.popover({msg:"����ʧ�ܣ�", type:'error'});
			}
		});
	}
}

/// �������µ�ģ��
function copyChart(tableId){
	var selChart=$("#"+tableId).datagrid("getSelections");
	if(selChart.length==0){
		return $.messager.popover({ msg: '��ѡ��Ҫ���Ƶ����µ���', type:'info' });
	}
	var option=tableId=="chartList" ? "copy" : "hospCopy";
	saveChart(selChart[0],option);
}

/// ɾ�����µ�ģ��
function deleteChart(){
	var selectChart=$("#chartList").datagrid("getSelections");
	if(selectChart.length==0){
		return $.messager.popover({ msg: '��ѡ��Ҫɾ�������µ���', type:'info' });
	}
	$.messager.confirm("����ʾ", "ȷ��Ҫɾ�������µ���������", function (r) {
		if (r) {
			loading("����ɾ�����µ�ģ��")
			if(typeof REQUEST_WAY==="undefined"){
				$.cm({
					ClassName:"Nur.NIS.Service.Chart.PrintSetting",
					MethodName:"deleteTemperatureChart",
					"RowID":selectChart[0].rowID
				},function testget(data){
					if(data.code==0){
						handleChartResponse(data);
					}else{
						return $.messager.popover({ msg: data.error, type:'error' });
					}
				});
			}else{
				$.ajax({
					url: API_BASE_URL+"/config/v1/nrChart/deleteById",
					type: 'POST',
					data:{id: selectChart[0].rowID},
					//data: JSON.stringify(nrChartdict),
					dataType: 'json',
					//contentType: 'application/json',
					success: function(response) {
						// ����ɹ��Ļص�����
						// �����ﴦ����Ӧ���ݣ������丳ֵ��datagrid
						if(response.code==200){
							handleChartResponse(response);
						}else{
							return $.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });
						}
					},
					error: function(xhr, status, error) {
						// ����ʧ�ܵĻص�����
						console.error('��������ʧ�ܣ�', error);
						// ��������
						$.messager.popover({msg:"ɾ��ʧ�ܣ�", type:'error'});
					}
				});
			}
		}
	});
}

/// ������/ɾ��ģ�巵�صĽ��
function handleChartResponse(res,option,importChartId){
	if(!option) {
		disLoad();
		$("#chart-dialog").dialog("close");
	}else{
		$("#otherHospChart-dialog").dialog("close");
	}
	var chartId=res.data ? res.data : "";
	if(option){
		saveChartConfig(chartId,option,importChartId);
	}else{
		/// getChartConfig(chartId);
		reloadChartData("chartList","",chartId);
	}
}

/// ��Ժ������
function openHospChart(){
	$("#otherHospChart-dialog").dialog("open");
	initChart("otherHospChartList","copy");
	reloadChartData("otherHospChartList","copy")
}

/// �Ҳ����µ�ģ������
/// ��ȡ���µ�Ԥ�������ֵ�ά������
function getDictList(){
	if(typeof REQUEST_WAY==="undefined"){
		dictList=$.cm({
			ClassName:"Nur.NIS.Service.Chart.PrintSetting",
			MethodName:"getConfigDictList",
			"HospID":hospID
		},false)
		handleDictData(dictList);
	}else{
		$.ajax({
			url: API_BASE_URL+"/config/v1/nrChartdict/getDictInfo",
			type: 'POST',
			data:{hospID: hospID},
			//data: JSON.stringify(nrChartdict),
			dataType: 'json',
			//contentType: 'application/json',
			success: function(response) {
				// ����ɹ��Ļص�����
				// �����ﴦ����Ӧ���ݣ������丳ֵ��datagrid
				if(response.code==200){
					dictList=response.data;
					handleDictData(response.data);
				}
			},
			error: function(xhr, status, error) {
				// ����ʧ�ܵĻص�����
				console.error('��������ʧ�ܣ�', error);
				// ��������
				$.messager.popover({msg:"��ȡ�ֵ�ά������ʧ�ܣ�", type:'error'});
			}
		});
	}
}

/// ��ʼ���ֵ�����������
function handleDictData(data){
	for(var key in data) {
		var index=key.toLowerCase();
		var res=data[key];
		if(index=="allergyresult"){
			$("#skinTestY").combobox({
				valueField:"value",
				textField:"label",
				data: getAllergyResultList(res,"Y")
			})
			$("#skinTestN").combobox({
				valueField:"value",
				textField:"label",
				data: getAllergyResultList(res,"N")
			})
		}else{
			$("."+index).combobox({
				valueField:"value",
				textField:"label",
				data: res
			})			
		}
	}
}

/// ���������ʾ�������������⴦��
function getAllergyResultList(data,flag){
	var arr = [];
    data.forEach(function(item,index){
      if (flag == "Y") {
        if (item.label == "����" || item.label == "+") arr.push(item);
      } else {
        if (item.label == "����" || item.label == "-") arr.push(item);
      }
    });
    return arr;
}

/// ��ȡģ����������
function getChartConfig(chartId){
	if(typeof REQUEST_WAY==="undefined"){
		$.cm({
			ClassName:"Nur.NIS.Service.Chart.PrintSetting",
			MethodName:"getTemperatureConfigInfo",
			"RowID":chartId
		},function testget(res){
			if(res.code===0){
				handleChartConfig(res.data);
			}
		});
	}else{
		$.ajax({
			url: API_BASE_URL+"/config/v1/nrChart/getTemperatureConfigInfo",
			type: 'POST',
			data:{id: chartId},
			//data: JSON.stringify(nrChartdict),
			dataType: 'json',
			//contentType: 'application/json',
			success: function(response) {
				// ����ɹ��Ļص�����
				// �����ﴦ����Ӧ���ݣ������丳ֵ��datagrid
				//var category = $("#category").combobox("getValue");
				if(response.code==200){
					handleChartConfig(response.data);
				}
			},
			error: function(xhr, status, error) {
				// ����ʧ�ܵĻص�����
				console.error('��������ʧ�ܣ�', error);
				// ��������
				$.messager.popover({msg:"���µ����ò�ѯʧ�ܣ�", type:'error'});
			}
		});
	}
}

/// ������������
function handleChartConfig(data){
	/// �������������
	var tableConfig=data.tableConfig ? (typeof REQUEST_WAY==="undefined" ? JSON.parse(data.tableConfig) : data.tableConfig) : config.tableConfig;
	reloadOuterConfig(tableConfig);
	/// ��������
	var textConfig=data.textConfig ? (typeof REQUEST_WAY==="undefined" ? JSON.parse(data.textConfig) : data.textConfig) : config.textConfig;
	reloadTextConfig(textConfig);
	/// �����������
	var contentConfig=data.contentConfig ? (typeof REQUEST_WAY==="undefined" ? JSON.parse(data.contentConfig) : data.contentConfig) : config.contentConfig;
	reloadContentConfig(contentConfig)
	/// ��ӡ��������
	var printRuleConfig=data.printRuleConfig ? (typeof REQUEST_WAY==="undefined" ? JSON.parse(data.printRuleConfig) : data.printRuleConfig) : config.printRuleConfig;
	console.log(printRuleConfig)
	reloadPrintRuleConfig(printRuleConfig);
}

/////////////////////////////�������������////////////////////////
/// ���ر������������
function reloadOuterConfig(data){
	if(data.header.image) {
		$(".show-img").show();
	}else{
		$(".show-img").hide();
	}
	$(".show-img img").attr("src",data.header.image);
	$("#logo").filebox("setText",data.header.imageName);
	$("#height").numberbox("setValue",data.header.height);
	$("#width").numberbox("setValue",data.header.width);
	$("#xAxis").numberbox("setValue",data.header.xAxis);
	$("#yAxis").numberbox("setValue",data.header.yAxis);
	$("#dateformat").combobox("setValue",data.special.dateFormatFlag);
	$("#changebedrules").combobox({
		onSelect:function(record){
			if(record.label=="��ʾ�������X�λ�������"){
				$("#recentlyNums").numberbox("setValue",data.special.recentlyNums);
				$("#recentlyNums,.unit").show();
			}else{
				$("#recentlyNums").numberbox("setValue","");
				$("#recentlyNums,.unit").hide();
			}
		}
	}).combobox("setValue",data.special.ruleFlag);
	var changebedrules=getDictLabel(data.special.ruleFlag,dictList.CHANGEBEDRULES);
	if(changebedrules=="��ʾ�������X�λ�������"){
		$("#recentlyNums").numberbox("setValue",data.special.recentlyNums);
		$("#recentlyNums,.unit").show();
	}else{
		$("#recentlyNums").numberbox("setValue","");
		$("#recentlyNums,.unit").hide();
	}
	$("#changedeptrules").combobox("setValue",data.special.officeRuleFlag);
	$("#bedlocextdirec").combobox("setValue",data.special.showDirection);
	$("#ifColorPrint").radio("setValue",data.page.ifColorPrint=="Y" ? true : false);
}

/////////////////////////////��������////////////////////////
/// ��������table
var editTextRowIndex=undefined;
function initTextTable(){
	$('#text-dg').datagrid({
		// fit : true,
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'item',title:'��Ŀ����',width:100,editor:{type:'validatebox',options:{required:true}}},
			{field:'content',title:'����',width:120,editor:{type:'text'}},
			{field:'font',title:'����',width:70,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTFAMILY);
		    },editor:{type:'combobox',options:{
			    width:70,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTFAMILY
		    }}},
		    {field:'wordsize',title:'�ֺ�',width:70,editor:{type:'numberbox',options:{precision:0,min:5,required:true}}},
		    {field:'alignStyle',title:'���뷽ʽ',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.ALIGNTYPE);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.ALIGNTYPE
		    }}},
		    {field:'color',title:'��ɫ',width:70,editor:{type:'validatebox'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
		    {field:'boldtype',title:'�Ӵ�����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTSTYLE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTSTYLE
		    }}},
		    {field:'locateMode',title:'��λ��ʽ',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.LOCATEMODE);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.LOCATEMODE,
				onSelect:function(record){

				},
		    }}},
		    {field:'xAxis',title:'X(��)',width:60,formatter:function(value,row,index){
				return row.orient[0];
			},editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'yAxis',title:'Y(��)',width:60,formatter:function(value,row,index){
				return row.orient[1];
			},editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'width',title:'���',width:60,editor:{type:'numberbox',options:{precision:0,min:0}}},
			{field:'bindingItem',title:'��Ԫ��',width:120,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.BINDINGITEM);
		    },editor:{type:'combobox',options:{
			    width:120,
		    	valueField:'value',
				textField:'label',
				data:dictList.BINDINGITEM,
				onSelect:function(record){
					var editors = $('#text-dg').datagrid('getEditors', editTextRowIndex);
					$(editors[12].target).numberbox("enable",true);
					$(editors[13].target).numberbox("enable",true);
					$(editors[14].target).color("enable",true);
					$(editors[15].target).combobox("enable",true);
					$(editors[16].target).combobox("enable",true);
					$(editors[17].target).radio("enable",true);
				},
		    }}},
		    {field:'itemWidth',title:'Ԫ�ؿ��',width:80,editor:{type:'numberbox',options:{precision:1,min:0}}},
		    {field:'itemFontSize',title:'Ԫ�������С',width:90,editor:{type:'numberbox',options:{precision:0,min:5}}},
			{field:'itemColor',title:'Ԫ��������ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'itemBoldType',title:'Ԫ�ؼӴ�����',width:90,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTSTYLE);
		    },editor:{type:'combobox',options:{
			    width:90,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTSTYLE,
				onSelect:function(record){

				},
		    }}},
		    {field:'itemAlign',title:'Ԫ�ض��뷽ʽ',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.ALIGNTYPE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.ALIGNTYPE,
				onSelect:function(record){

				},
		    }}},
		    {field:'underline',title:'�Ƿ���º���',width:90,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    }}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addTextRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copyTextRow();
	            }
	        },
	        /*{
            	iconCls: 'icon-write-order',
            	text: '�޸�����',
            	handler: function () {
                	modifyAxis();
            	}
         	},*/
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("text-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("text-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("text-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			//if((editTextRowIndex!=undefined)&&(editTextRowIndex!=rowIndex)&&!saveTextRow()) return;
			//$('#text-dg').datagrid("endEdit",editTextRowIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			if((editTextRowIndex!=undefined)&&(editTextRowIndex!=rowIndex)&&!saveTextRow()) return;
			//$('#text-dg').datagrid("endEdit",editTextRowIndex);
			editTextRowIndex=rowIndex;
			$('#text-dg').datagrid("beginEdit", editTextRowIndex);
			var textDict={"font": "FONTFAMILY","alignStyle":"ALIGNTYPE","boldtype":"FONTSTYLE","locateMode":"LOCATEMODE","bindingItem":"BINDINGITEM","itemBoldType":"FONTSTYLE","itemAlign":"ALIGNTYPE"};
			var editors = $('#text-dg').datagrid('getEditors', editTextRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						disabled:(rowData.bindingItem=="" && (editors[i].field=="itemBoldType" || editors[i].field=="itemAlign")) ? true : false,
						valueField:"value",
						textField:"label",
						data: dictList[textDict[editors[i].field]]
					}).combobox("setValue",rowData[editors[i].field]);
				}
				if(editors[i].field=="color" || editors[i].field=="itemColor"){
					var disabled=(rowData.bindingItem=="" && editors[i].field=="itemColor") ? true : false;
					var required=editors[i].field=="color" ? true : false;
					$(editors[i].target).color({
						editable:true,
						disabled:disabled,
						required:required,
						width:70,
						height:30
					});
				}
				if(editors[i].field=="xAxis"){
					$(editors[i].target).numberbox("setValue",rowData.orient[0])
				}
				if(editors[i].field=="yAxis"){
					$(editors[i].target).numberbox("setValue",rowData.orient[1])
				}
			}
			if(rowData.bindingItem==""){
				$(editors[12].target).numberbox({disabled:true});
				$(editors[13].target).numberbox("disable",true);
				$(editors[17].target).radio("disable",true);
			}
		}
	});
}

/// ��ȡ��Ӧ���ֵ��ı�
function getDictLabel(id,data){
	var desc="";
	if(id){
		var idStr=id.toString();
		var idArr=idStr.split(",")
		data.forEach(function(val,index){
		if(idArr.indexOf(val.value.toString())>-1){
			desc=desc=="" ? val.label : desc+";"+val.label;
		}
	})}
	return desc;
}

/// ����������������
function reloadTextConfig(data){
	var nums="";
	if(data.bpShowNums){
		$("#bpShowNums").combobox("setValue",data.bpShowNums);
		nums=parseInt(getDictLabel(data.bpShowNums,dictList["BPSHOWNUMS"]));
	}else{
		$("#bpShowNums").combobox("setValue",dictList["BPSHOWNUMS"][0].value);
		nums=parseInt(dictList["BPSHOWNUMS"][0].label);	
	}
	if(nums==2){
		$(".bpShowRule2, .twoBPInSameCol").hide();
	}
	if(nums==4){
		$(".bpShowRule2, .twoBPInSameCol").show();
		$(".am-point2, .pm-point2").hide();
	}
	if(nums==6){
		$(".bpShowRule2, .twoBPInSameCol, .am-point2, .pm-point2").show();
	}	
	$("#intervalTimeAM").combobox("setValue",data.intervalTimeAM);
	$("#intervalTimeAM2").combobox("setValue",data.intervalTimeAM2 ? data.intervalTimeAM2 : "");
	$("#intervalTime").combobox("setValue",data.intervalTime);
	$("#intervalTimePM").combobox("setValue",data.intervalTimePM);
	$("#intervalTimePM2").combobox("setValue",data.intervalTimePM2 ? data.intervalTimePM2 : "");
	$("#twoBPInSameCol").radio("setValue",data.TwoBPInSameCol=="Y" ? true : false);
	$("#ifSequence").radio("setValue",data.ifSequence=="Y" ? true : false);
	$("#text-dg").datagrid("loadData",data.texts);
}

/// ������������
function addTextRow(){
	if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
	//$('#text-dg').datagrid("endEdit",editTextRowIndex);
	editTextRowIndex=$('#text-dg').datagrid('getRows').length;
	var row={
		rowKey: "text"+(editTextRowIndex+1),
        item: "",
		content: "",
		font: 1,
		wordsize: "",
		alignStyle : "",
		color: "",
		boldtype:  6,
		locateMode: 25,
		orient: [],
		width: "",
		bindingItem: "",
		itemWidth: "",
		itemAlign: "",
		itemFontSize: "",
		itemColor: "",
		underline: "N",
		itemBoldType: ""
	};
	var textDict={"font": "FONTFAMILY","alignStyle":"ALIGNTYPE","boldtype":"FONTSTYLE","locateMode":"LOCATEMODE","bindingItem":"BINDINGITEM","itemBoldType":"FONTSTYLE","itemAlign":"ALIGNTYPE"};
	$('#text-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editTextRowIndex).datagrid("selectRow",editTextRowIndex);
	var editors = $('#text-dg').datagrid('getEditors', editTextRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				disabled:(editors[i].field=="itemBoldType" || editors[i].field=="itemAlign") ? true : false,
				valueField:"value",
				textField:"label",
				data: dictList[textDict[editors[i].field]]
			})
			if(editors[i].field!="bindingItem" && editors[i].field!="itemBoldType" && editors[i].field!="itemAlign"){
				$(editors[i].target).combobox("setValue",dictList[textDict[editors[i].field]][0].value)
			}
		}
		if(editors[i].field=="color" || editors[i].field=="itemColor"){
			var disabled=editors[i].field=="itemColor" ? true : false;
			var required=editors[i].field=="color" ? true : false;
			$(editors[i].target).color({
				editable:true,
				disabled:disabled,
				required:required,
				width:70,
				height:30
			});
		}
	}
	$(editors[12].target).numberbox("disable",true);
	$(editors[13].target).numberbox("disable",true);
	$(editors[17].target).radio("disable",true);
}

/// ������������
function copyTextRow(){
	var selRow=$("#text-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
	var curIndex=$("#text-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editTextRowIndex=curIndex+1;
	var rows=$('#text-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="text"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#text-dg').datagrid("loadData",rows).datagrid("beginEdit", editTextRowIndex).datagrid("selectRow",editTextRowIndex);
	var textDict={"font": "FONTFAMILY","alignStyle":"ALIGNTYPE","boldtype":"FONTSTYLE","locateMode":"LOCATEMODE","bindingItem":"BINDINGITEM","itemBoldType":"FONTSTYLE","itemAlign":"ALIGNTYPE"};
	var editors = $('#text-dg').datagrid('getEditors', editTextRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				disabled:(newRow.bindingItem=="" && (editors[i].field=="itemBoldType" || editors[i].field=="itemAlign")) ? true : false,
				valueField:"value",
				textField:"label",
				data: dictList[textDict[editors[i].field]]
			}).combobox("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="color" || editors[i].field=="itemColor"){
			var disabled=(newRow.bindingItem=="" && editors[i].field=="itemColor") ? true : false;
			var required=editors[i].field=="color" ? true : false;
			$(editors[i].target).color({
				editable:true,
				disabled:disabled,
				required:required,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="xAxis"){
			$(editors[i].target).numberbox("setValue",newRow.orient[0]);
		}
		if(editors[i].field=="yAxis"){
			$(editors[i].target).numberbox("setValue",newRow.orient[1]);
		}
	}
	if(newRow.bindingItem==""){
		$(editors[12].target).numberbox("disable",true);
		$(editors[13].target).numberbox("disable",true);
		$(editors[17].target).radio("disable",true);
	}
}

/// �޸�Ѫѹ��ʾ����
function changeBPShowNums(record){
	var nums=parseInt(record.label);
	if(nums==2){
		$(".bpShowRule2, .twoBPInSameCol").hide();	
		$("#intervalTimeAM,#intervalTimeAM2,#intervalTimePM,#intervalTimePM2").combobox("setValue","");
		$("#twoBPInSameCol").radio("setValue",false);
	}
	if(nums==4){
		$(".bpShowRule2, .twoBPInSameCol").show();	
		$(".am-point2, .pm-point2").hide();
		$("#intervalTimeAM2,#intervalTimePM2").combobox("setValue","");		
	}
	if(nums==6){
		$(".bpShowRule2, .twoBPInSameCol, .am-point2, .pm-point2").show();		
	}
}

/// ������������
function textMoveUp(){
	var selRow=$("#text-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ�����Ƶ������', type:'info' });
	}
	if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
	editTextRowIndex=undefined;
	var index=$("#text-dg").datagrid("getRowIndex",selRow[0].rowKey);
	var rows=$('#text-dg').datagrid('getRows');
	if(index>0){
		var prevIndex = index - 1;
        rows.splice(index,1)
        rows.splice(prevIndex,0,selRow[0]);
        console.log(rows);
        $("#text-dg").datagrid("loadData",rows);
	}
}

/// ������������
function textMoveDown(){
	var selRow=$("#text-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ�����Ƶ������', type:'info' });
	}
	if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
	editTextRowIndex=undefined;
	var index=$("#text-dg").datagrid("getRowIndex",selRow[0].rowKey);
	var rows=$('#text-dg').datagrid('getRows');
	if(index<rows.length){
		var nextIndex = index + 1;
        rows.splice(index,1)
        rows.splice(nextIndex,0,selRow[0]);
        console.log(rows);
        $("#text-dg").datagrid("loadData",rows);
	}
}

/// �����������ñ༭������
function saveTextRow() {
	if (editTextRowIndex==undefined) return;
	var rowEditors=$('#text-dg').datagrid('getEditors',editTextRowIndex);
	var color=$(rowEditors[5].target).color("getValue");
	var xAxis=$(rowEditors[8].target).numberbox("getValue");
	var yAxis=$(rowEditors[9].target).numberbox("getValue");
	var bindingItem=$(rowEditors[11].target).combobox("getValue");
	var itemWidth=$(rowEditors[12].target).numberbox("getValue");
	var itemFontSize=$(rowEditors[13].target).numberbox("getValue");
	var itemColor=$(rowEditors[14].target).color("getValue");
	if(color=="") return;
	if(xAxis==""){
		$(rowEditors[8].target).numberbox({required:true})
		return;
	}
	if(yAxis==""){
		$(rowEditors[9].target).numberbox({required:true})
		return;
	}
	if(bindingItem!="" && (itemWidth=="" || itemFontSize==""))
	{
		$(rowEditors[12].target).numberbox({enabled:true,required:true})
		$(rowEditors[13].target).numberbox({enabled:true,required:true})
		return;
	}

	if(bindingItem==""){
		$(rowEditors[12].target).numberbox("disable",true)
		$(rowEditors[13].target).numberbox("disable",true)
	}

	var rows=$("#text-dg").datagrid("getRows");
	rows[editTextRowIndex].orient[0]=xAxis;
	rows[editTextRowIndex].orient[1]=yAxis;
	$('#text-dg').datagrid("endEdit",editTextRowIndex);
	rows[editTextRowIndex].color=color;
	rows[editTextRowIndex].itemColor=itemColor;
	$('#text-dg').datagrid("loadData",rows);
	return true;
}

/////////////////////////////�����������////////////////////////
var editSheetRowIndex=undefined, editCurveRowIndex=undefined;
function initContentTable(){
	$('#sheet-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'positionDesc',title:'λ��˵��',width:180,editor:{type:'text'}},
			{field:'xAxis',title:'����X(mm)',width:90,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'yAxis',title:'����Y(mm)',width:90,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'height',title:'���߶�(mm)',width:110,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'width',title:'�����(mm)',width:110,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'border',title:'�߿���',width:70,formatter: function(value, row, index){
				return "<a class='icon icon-big-split-cells' style='cursor:pointer;width:28px;height:25px;display:inline-block;' onclick='openLineModel(" + index + ", " + JSON.stringify(value) + ")'></a>"
			},styler: function(value,row,index){
				return "text-align:center;"
			}},
			{field:'cols',title:'�����',width:60,editor:{type:'numberbox',options:{precision:0,min:1,required:true}}},
			{field:'rows',title:'�����',width:60,editor:{type:'numberbox',options:{precision:0,min:1,required:true}}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addSheetRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copySheetRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("sheet-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("sheet-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("sheet-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editSheetRowIndex!=undefined)&&(editSheetRowIndex!=rowIndex)&&!saveSheetRow()) return;
			editSheetRowIndex=rowIndex;
			$('#sheet-dg').datagrid("beginEdit", editSheetRowIndex);
		}
	});

	/// ��������
	$('#curve-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'signCode',title:'������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		    {field:'color',title:'��ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'xAxis',title:'����X(mm)',width:90,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'yAxis',title:'����Y(mm)',width:90,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'cWidth',title:'��С������(mm)',width:110,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'cHeight',title:'��С����߶�(mm)',width:110,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'minScaleValue',title:'��С�̶�ֵ',width:60,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'maxValue',title:'���ֵ',width:60,editor:{type:'numberbox',options:{precision:1,min:1,required:true}}},
			{field:'minValue',title:'��Сֵ',width:60,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'linetype',title:'�߿�',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.LINETYPE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.LINETYPE
		    }}},
		    {field:'icon',title:'ͼ��',width:60,editor:{type:'validatebox',options:{required:true}}},
			{field:'iconSize',title:'ͼ����С',width:80,editor:{type:'numberbox',options:{precision:0,min:0,required:true}}},
		    {field:'boldtype',title:'�Ӵ�����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTSTYLE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTSTYLE
		    }}},
		   	{field:'overIcon',title:'�غ�ͼ��',width:60,editor:{type:'validatebox'}},
			{field:'overIconSize',title:'�غ�ͼ����С',width:80,editor:{type:'numberbox',options:{precision:0,min:0}}},
		    {field:'teamCode',title:'������',width:70,editor:{type:'validatebox'}},
			{field:'valueTrans',title:'ֵת��',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.VALUETRANSFORM);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.VALUETRANSFORM
		    }}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addCurveRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copyCurveRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("curve-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("curve-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("curve-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editCurveRowIndex!=undefined)&&(editCurveRowIndex!=rowIndex)&&!saveCurveRow()) return;
			editCurveRowIndex=rowIndex;
			$('#curve-dg').datagrid("beginEdit", editCurveRowIndex);
			var curveDict={"signCode": "tempDict","linetype":"LINETYPE","boldtype":"FONTSTYLE","valueTrans":"VALUETRANSFORM"};
			var editors = $('#curve-dg').datagrid('getEditors', editCurveRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						valueField:"value",
						textField:"label",
						data: dictList[curveDict[editors[i].field]]
					}).combobox("setValue",rowData[editors[i].field]);
				}
				if(editors[i].field=="color"){
					$(editors[i].target).color({
						editable:true,
						width:70,
						height:30
					});
				}
			}
		}
	});
}

/// ���ر��������������
function reloadContentConfig(data){
	$("#timing").val(data.timing);
	$("#days").numberbox("setValue",data.days);
	$("#redTime").val(data.redTiming);
	$("#ifPointCellCenter").radio("setValue",data.ifPointCellCenter=="Y" ? true : false);
	$("#sheet-dg").datagrid("loadData",data.sheet);
	$("#curve-dg").datagrid("loadData",data.curve);
}

/// �����������
function addSheetRow(){
	if((editSheetRowIndex!=undefined)&&!saveSheetRow()) return;
	editSheetRowIndex=$('#sheet-dg').datagrid('getRows').length;
	var row={
        rowKey: "sheet"+(editSheetRowIndex+1),
        positionDesc: "",
        xAxis: "",
		yAxis: "",
        height: "",
        width: "",
        border: {
          top: {
            color: "",
            linetype: "",
            flag: "N"
          },
          bottom: {
            color: "",
            linetype: "",
            flag: "N"
          },
          left: {
            color: "",
            linetype: "",
            flag: "N"
          },
          right: {
            color: "",
            linetype: "",
            flag: "N"
          },
          horizontal: {
            color: "",
            linetype: "",
            flag: "N"
          },
          vertical: {
            color: "",
            linetype: "",
            flag: "N"
          },
          leftDiagonal: {
            color: "",
            linetype: "",
            flag: "N"
          },
          rightDiagonal: {
            color: "",
            linetype: "",
            flag: "N"
          }
        },
        cols: "",
        rows: ""
    };
	$('#sheet-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editSheetRowIndex).datagrid("selectRow",editSheetRowIndex);
}

/// ��������߿���
function openLineModel(index,value){
	console.log(index);
	console.log(value);
	$("#line-dialog").dialog("open");
	$("#lineColor").color({
		editable:true,
		width:162,
		height:30
	}).color("setValue","#000");
	var lineType=dictList.LINETYPE;
	var html="";
	lineType.forEach(function(item,key){
		var className=key==0 ? "active" : ""
		html+='<li class="'+className+'" data-value="'+item.value+'" onclick="chooseLine(event)"><span></span></li>';
	})
	$("#line-dialog ul").html(html);
	/// �Ҳ��߿���ʾЧ������
	createEffectArea(value);
}

/// �Ҳ��߿���ʾЧ������
var curLine={};
function createEffectArea(value){
	curLine=value;
	var lines={
		left:["top","horizontal","bottom","rightDiagonal"],
		bottom:["left","vertical","right","leftDiagonal"]
	};
	var lines2={
		border:["left","right","top","bottom"],
		diagonal:["leftDiagonal","rightDiagonal"],
		center:["horizontal","vertical"]
	}
	var html2="",html3='<div class="text">';
	for(var key in lines){
		lines[key].forEach(function(item,ind){
			var className=value[item].flag=="Y" ? item+"Active" : "";
			html2+='<a class="'+key+' btn-'+item+" "+className+'" onclick="drawLine(event,\'' + item + '\')"></a>';
		})
	}
	for (var key in lines2){
		lines2[key].forEach(function(item,ind){
			var className=value[item].flag=="Y" ? (getDictLabel(value[item].linetype,dictList.LINETYPE)=="�Ӵ�" ? "boldActive" : "active") : "";
			var color=(value[item].flag=="Y" && value[item].color!="") ? value[item].color : "";
			html3+='<span class="'+key+' line-'+item+" "+className+'" style="border-color:'+color+'"></span>';
		})
	}
	html3+='</div>';
	html2=html2+html3;
	$(".effectArea").html(html2);
}

/// �л��߿��ϸ
function chooseLine(e){
	$(e.target).addClass("active").siblings().removeClass("active");
}

/// �߿�Ч��
function drawLine(e,item){
	var color=$.trim($("#lineColor").color("getValue"))
	var lineType=$(".mainCon li.active").data("value");
	if($(e.target).hasClass(item+"Active")){
		if(curLine[item].color!=color || curLine[item].linetype!=lineType){
			curLine[item].color=color;
			curLine[item].linetype=lineType;
		}else{
			curLine[item].flag="N";
			curLine[item].color="";
			curLine[item].linetype="";
		}
	}else{
		curLine[item].flag="Y";
		curLine[item].color=color!="" ? color : "";
		curLine[item].linetype=lineType;
	}
	createEffectArea(curLine);
}

/// �����߿���
function saveLines(){
	var selRow=$("#sheet-dg").datagrid("getSelections");
	var rows=$("#sheet-dg").datagrid("getRows");
	var index=$("#sheet-dg").datagrid("getRowIndex",selRow[0].rowKey);
	rows[index].border=curLine;
	//if((editSheetRowIndex===index)&&!saveSheetRow()) return;
	///$("#sheet-dg").datagrid("loadData",rows);
	if (editSheetRowIndex===index) {
		var rowEditors=$('#sheet-dg').datagrid('getEditors',editSheetRowIndex);
		var positionDesc=$.trim($(rowEditors[0].target).val());
		var xAxis=$(rowEditors[1].target).numberbox("getValue");
		var yAxis=$(rowEditors[2].target).numberbox("getValue");
		var height=$(rowEditors[3].target).numberbox("getValue");
		var width=$(rowEditors[4].target).numberbox("getValue");
		var cols=$(rowEditors[5].target).numberbox("getValue");
		var rowNums=$(rowEditors[6].target).numberbox("getValue");
		rows[index].xAxis=xAxis;
		rows[index].yAxis=yAxis;
		rows[index].height=height;
		rows[index].width=width;
		rows[index].positionDesc=positionDesc;
		rows[index].cols=cols;
		rows[index].rows=rowNums;
	}
	$("#sheet-dg").datagrid("updateRow",{index:index,row:rows[index]});
	if(editSheetRowIndex!=="undefined") $('#sheet-dg').datagrid("beginEdit", editSheetRowIndex);
	$HUI.dialog('#line-dialog').close();
}

/// ���Ʊ������
function copySheetRow(){
	var selRow=$("#sheet-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editSheetRowIndex!=undefined)&&!saveSheetRow()) return;
	var curIndex=$("#sheet-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editSheetRowIndex=curIndex+1;
	var rows=$('#sheet-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="sheet"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#sheet-dg').datagrid("loadData",rows).datagrid("beginEdit", editSheetRowIndex).datagrid("selectRow",editSheetRowIndex);
}

/// ���������ñ༭������
function saveSheetRow() {
	if (editSheetRowIndex==undefined) return;
	var rowEditors=$('#sheet-dg').datagrid('getEditors',editSheetRowIndex);
	var xAxis=$(rowEditors[1].target).numberbox("getValue");
	var yAxis=$(rowEditors[2].target).numberbox("getValue");
	var height=$(rowEditors[3].target).numberbox("getValue");
	var width=$(rowEditors[4].target).numberbox("getValue");
	var cols=$(rowEditors[5].target).numberbox("getValue");
	var rows=$(rowEditors[6].target).numberbox("getValue");
	if(xAxis=="" || yAxis=="" || height=="" || width=="" || cols=="" || rows=="") return;
	$('#sheet-dg').datagrid("endEdit",editSheetRowIndex);
	editSheetRowIndex=undefined;
	return true;
}

/// ������������
function addCurveRow(){
	if((editCurveRowIndex!=undefined)&&!saveCurveRow()) return;
	editCurveRowIndex=$('#curve-dg').datagrid('getRows').length;
	var row={
		rowKey: "curve"+(editCurveRowIndex+1),
        signCode: "",
		color: "#000000",
		xAxis: "",
        yAxis: "",
        cWidth: "",
        cHeight: "",
		minScaleValue: "",
		maxValue: "",
		minValue: "",
		icon: "",
		iconSize: "",
		boldtype: "",
		overIcon: "",
		overIconSize: "",
		teamCode: "",
		valueTrans: "",
		linetype: ""
	};
	var curveDict={"signCode": "tempDict","linetype":"LINETYPE","boldtype":"FONTSTYLE","valueTrans":"VALUETRANSFORM"};
	$('#curve-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editCurveRowIndex).datagrid("selectRow",editCurveRowIndex);
	var editors = $('#curve-dg').datagrid('getEditors', editCurveRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[curveDict[editors[i].field]]
			})
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			});
		}
	}
}

/// ������������
function copyCurveRow(){
	var selRow=$("#curve-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editCurveRowIndex!=undefined)&&!saveCurveRow()) return;
	var curIndex=$("#curve-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editCurveRowIndex=curIndex+1;
	var rows=$('#curve-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="curve"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#curve-dg').datagrid("loadData",rows).datagrid("beginEdit", editCurveRowIndex).datagrid("selectRow",editCurveRowIndex);
	var curveDict={"signCode": "tempDict","linetype":"LINETYPE","boldtype":"FONTSTYLE","valueTrans":"VALUETRANSFORM"};
	var editors = $('#curve-dg').datagrid('getEditors', editCurveRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[curveDict[editors[i].field]]
			}).combobox("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
	}
}

/// �����������ñ༭������
function saveCurveRow() {
	if (editCurveRowIndex==undefined) return;
	var rowEditors=$('#curve-dg').datagrid('getEditors',editCurveRowIndex);
	var signCode=$(rowEditors[0].target).combobox("getValue");
	var color=$(rowEditors[1].target).color("getValue");
	var xAxis=$(rowEditors[2].target).numberbox("getValue");
	var yAxis=$(rowEditors[3].target).numberbox("getValue");
	var cWidth=$(rowEditors[4].target).numberbox("getValue");
	var cHeight=$(rowEditors[5].target).numberbox("getValue");
	var minScaleValue=$(rowEditors[6].target).numberbox("getValue");
	var maxValue=$(rowEditors[7].target).numberbox("getValue");
	var minValue=$(rowEditors[8].target).numberbox("getValue");
	var icon=$.trim($(rowEditors[10].target).val());
	var iconSize=$(rowEditors[11].target).numberbox("getValue");
	if(signCode=="" || xAxis=="" || yAxis=="" || cWidth=="" || cHeight=="" || minScaleValue=="" || maxValue=="" || minValue=="" || icon=="" || iconSize=="") return;
	$('#curve-dg').datagrid("endEdit",editCurveRowIndex);
	var rows=$('#curve-dg').datagrid("getRows");
	rows[editCurveRowIndex].color=color;
	$('#curve-dg').datagrid("loadData",rows);
	return true;
}

/// ����
function moveUp(tableId){
	var selRow=$("#"+tableId).datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ�����Ƶ������', type:'info' });
	}
	if(tableId=="text-dg"){
		if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
		editTextRowIndex=undefined;
	}
	if(tableId=="sheet-dg"){
		if((editSheetRowIndex!=undefined)&&!saveSheetRow()) return;
		editSheetRowIndex=undefined;
	}
	if(tableId=="curve-dg"){
		if((editCurveRowIndex!=undefined)&&!saveCurveRow()) return;
		editCurveRowIndex=undefined;
	}
	var index=$("#"+tableId).datagrid("getRowIndex",selRow[0].rowKey);
	var rows=$("#"+tableId).datagrid('getRows');
	if(index>0){
		var prevIndex = index - 1;
        rows.splice(index,1)
        rows.splice(prevIndex,0,selRow[0]);
        $("#"+tableId).datagrid("loadData",rows);
	}
}

/////////////////////////////��ӡ��������////////////////////////
var editEventRowIndex=undefined, editAfterDropRowIndex=undefined,editSuddenFeverRowIndex=undefined,editRetestRowIndex=undefined,editOverScaleRowIndex=undefined;
function initPrintRuleTable(){
	$('#event-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'eventName',title:'�¼�����',width:90,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempEventDict);
		    },editor:{type:'combobox',options:{
			    width:90,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempEventDict
		    }}},
		    {field:'showName',title:'����',width:80,editor:{type:'text'}},
			{field:'timeFlag',title:'ʱ����ʾ',width:80,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    }},
		    {field:'timeFormat',title:'ʱ����ʽ',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.TIMEFORMAT);
		    },editor:{type:'combobox',options:{
			    width:100,
		    	valueField:'value',
				textField:'label',
				data:dictList.TIMEFORMAT
		    }}},
		    {field:'intervalMode',title:'�����ʽ',width:90,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.INTERVALMODE);
		    },editor:{type:'combobox',options:{
			    width:90,
		    	valueField:'value',
				textField:'label',
				data:dictList.INTERVALMODE
		    }}},
		    {field:'cellWidth',title:'С����',width:90,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'cellHeight',title:'С��߶�',width:90,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'locateMode',title:'��ʼ��λ��ʽ',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.LOCATEMODE);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.LOCATEMODE
		    }}},
		    {field:'xAxis',title:'X(��)',width:60,formatter:function(value,row,index){
				return row.orient[0];
			},editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'yAxis',title:'Y(��)',width:60,formatter:function(value,row,index){
				return row.orient[1];
			},editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
		    {field:'font',title:'����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTFAMILY);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTFAMILY
		    }}},
		    {field:'wordsize',title:'�ֺ�',width:60,editor:{type:'numberbox',options:{precision:0,min:0,required:true}}},
			{field:'color',title:'������ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'boldtype',title:'�Ӵ�����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTSTYLE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTSTYLE
		    }}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addEventRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copyEventRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("event-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("event-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("event-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editEventRowIndex!=undefined)&&(editEventRowIndex!=rowIndex)&&!saveEventRow()) return;
			editEventRowIndex=rowIndex;
			$('#event-dg').datagrid("beginEdit", editEventRowIndex);
			var eventDict={"eventName": "tempEventDict","timeFormat":"TIMEFORMAT","intervalMode":"INTERVALMODE","locateMode":"LOCATEMODE","font":"FONTFAMILY","boldtype":"FONTSTYLE"};
			var editors = $('#event-dg').datagrid('getEditors', editEventRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						valueField:"value",
						textField:"label",
						data: dictList[eventDict[editors[i].field]]
					}).combobox("setValue",rowData[editors[i].field]);
				}
				if(editors[i].field=="color"){
					$(editors[i].target).color({
						editable:true,
						width:70,
						height:30
					});
				}
				if(editors[i].field=="xAxis"){
					$(editors[i].target).numberbox("setValue",rowData.orient[0])
				}
				if(editors[i].field=="yAxis"){
					$(editors[i].target).numberbox("setValue",rowData.orient[1])
				}
			}
		}
	});

	/// ������������
	$('#afterDrop-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'signCode',title:'������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		   	{field:'afterDropDesc',title:'��������',width:80,editor:{type:'validatebox',options:{required:true}}},
			{field:'color',title:'��ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'linkSignCode',title:'����������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		    {field:'cables',title:'������ʽ',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.CABLESRULE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.CABLESRULE
		    }}},
		    {field:'showRule',title:'������ʾ����',width:90,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.AFTERDROPRULE);
		    },editor:{type:'combobox',options:{
			    width:90,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.AFTERDROPRULE
		    }}},
		    {field:'linetype',title:'�߿�',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.LINETYPE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.LINETYPE
		    }}},
		    {field:'condition',title:'����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.CONDITION);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.CONDITION
		    }}},
		    {field:'number',title:'ͼ����С',width:80,editor:{type:'numberbox',options:{precision:0,min:0,required:true}}},
			{field:'offset',title:'����ƫ��',width:80,editor:{type:'numberbox',options:{precision:1}}},
			{field:'xAxis',title:'����X(mm)',width:90,editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'yAxis',title:'����Y(mm)',width:90,editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'cWidth',title:'��С������(mm)',width:110,editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'cHeight',title:'��С����߶�(mm)',width:110,editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'minScaleValue',title:'��С�̶�ֵ',width:60,editor:{type:'numberbox',options:{precision:1,min:0}}},
			{field:'maxValue',title:'���ֵ',width:60,editor:{type:'numberbox',options:{precision:1,min:1}}},
			{field:'minValue',title:'��Сֵ',width:60,editor:{type:'numberbox',options:{precision:1,min:0}}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addAfterDropRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copyAfterDropRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("afterDrop-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("afterDrop-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("afterDrop-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editAfterDropRowIndex!=undefined)&&(editAfterDropRowIndex!=rowIndex)&&!saveAfterDropRow()) return;
			editAfterDropRowIndex=rowIndex;
			$('#afterDrop-dg').datagrid("beginEdit", editAfterDropRowIndex);
			var afterDropDict={"signCode": "tempDict","linkSignCode":"tempDict","cables":"CABLESRULE","showRule":"AFTERDROPRULE","linetype":"LINETYPE","condition":"CONDITION"};
			var editors = $('#afterDrop-dg').datagrid('getEditors', editAfterDropRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						valueField:"value",
						textField:"label",
						data: dictList[afterDropDict[editors[i].field]]
					}).combobox("setValue",rowData[editors[i].field]);
				}
				if(editors[i].field=="color"){
					$(editors[i].target).color({
						editable:true,
						width:70,
						height:30
					});
				}
			}
		}
	});

	/// ͻȻ���ȹ�������
	$('#suddenFever-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'signCode',title:'������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		   	{field:'suddenFeverDesc',title:'��������',width:80,editor:{type:'validatebox',options:{required:true}}},
			{field:'color',title:'��ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'linkSignCode',title:'����������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		    {field:'cables',title:'������ʽ',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.CABLESRULE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.CABLESRULE
		    }}},
		    {field:'showRule',title:'������ʾ����',width:90,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.AFTERDROPRULE);
		    },editor:{type:'combobox',options:{
			    width:90,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.AFTERDROPRULE
		    }}},
		    {field:'linetype',title:'�߿�',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.LINETYPE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.LINETYPE
		    }}},
		    {field:'condition',title:'����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.CONDITION);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.CONDITION
		    }}},
		    {field:'number',title:'ͼ����С',width:80,editor:{type:'numberbox',options:{precision:0,min:0,required:true}}},
			{field:'offset',title:'����ƫ��',width:80,editor:{type:'numberbox',options:{precision:1}}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addSuddenFeverRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copySuddenFeverRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("suddenFever-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("suddenFever-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("suddenFever-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editSuddenFeverRowIndex!=undefined)&&(editSuddenFeverRowIndex!=rowIndex)&&!saveSuddenFeverRow()) return;
			editSuddenFeverRowIndex=rowIndex;
			$('#suddenFever-dg').datagrid("beginEdit", editSuddenFeverRowIndex);
			var suddenFeverDict={"signCode": "tempDict","linkSignCode":"tempDict","cables":"CABLESRULE","showRule":"AFTERDROPRULE","linetype":"LINETYPE","condition":"CONDITION"};
			var editors = $('#suddenFever-dg').datagrid('getEditors', editSuddenFeverRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						valueField:"value",
						textField:"label",
						data: dictList[suddenFeverDict[editors[i].field]]
					}).combobox("setValue",rowData[editors[i].field]);
				}
				if(editors[i].field=="color"){
					$(editors[i].target).color({
						editable:true,
						width:70,
						height:30
					});
				}
			}
		}
	});

	/// �����������
	$('#retest-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'signCode',title:'������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		   	{field:'retestDesc',title:'��������',width:80,editor:{type:'validatebox',options:{required:true}}},
			{field:'color',title:'��ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'upMinValue',title:'������Сֵ',width:100,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'downMinValue',title:'�½���Сֵ',width:100,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'iconSize',title:'ͼ����С',width:80,editor:{type:'numberbox',options:{precision:0,min:0,required:true}}},
			{field:'offsetX',title:'����ƫ��',width:80,editor:{type:'numberbox',options:{precision:1}}},
			{field:'offsetY',title:'����ƫ��',width:80,editor:{type:'numberbox',options:{precision:1}}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addRetestRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copyRetestRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("retest-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("retest-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("retest-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editRetestRowIndex!=undefined)&&(editRetestRowIndex!=rowIndex)&&!saveRetestRow()) return;
			editRetestRowIndex=rowIndex;
			$('#retest-dg').datagrid("beginEdit", editRetestRowIndex);
			var retestDict={"signCode": "tempDict"};
			var editors = $('#retest-dg').datagrid('getEditors', editRetestRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						valueField:"value",
						textField:"label",
						data: dictList[retestDict[editors[i].field]]
					}).combobox("setValue",rowData[editors[i].field]);
				}
				if(editors[i].field=="color"){
					$(editors[i].target).color({
						editable:true,
						width:70,
						height:30
					});
				}
			}
		}
	});

	/// ������߹��򼰶�������
	$('#overScale-dg').datagrid({
		rownumbers:true,
		idField:"rowKey",
		columns :[[
			{field:'signCode',title:'������',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		    {field:'linkSignCode',title:'����������',width:150,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.tempDict);
		    },editor:{type:'combobox',options:{
			    width:150,
			    multiple:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.tempDict
		    }}},
		    {field:'condition',title:'����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.CONDITION);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.CONDITION
		    }}},
		   	{field:'number',title:'��ֵ',width:80,editor:{type:'validatebox',options:{required:true}}},
			{field:'showMode',title:'��ʾ��ʽ',width:90,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.OVERSHOWMODE);
		    },editor:{type:'combobox',options:{
			    width:90,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.OVERSHOWMODE
		    }}},
		    {field:'icon',title:'ͼ��',width:80,editor:{type:'validatebox',options:{required:true}}},
			{field:'iconOffsetX',title:'ͼ��ƫ����X',width:120,editor:{type:'numberbox',options:{precision:1}}},
			{field:'iconOffsetY',title:'ͼ��ƫ����Y',width:120,editor:{type:'numberbox',options:{precision:1}}},
			{field:'isCables',title:'�Ƿ����',width:80,editor:{type:'icheckbox',options:{on:'Y',off:'N'}},formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    }},
		    {field:'cellWidth',title:'С����',width:80,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
		    {field:'cellHeight',title:'С��߶�',width:80,editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'locateMode',title:'��ʼ��λ��ʽ',width:100,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.LOCATEMODE);
		    },editor:{type:'combobox',options:{
			    width:100,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.LOCATEMODE
		    }}},
		    {field:'xAxis',title:'X(��)',width:60,formatter:function(value,row,index){
				return row.orient[0];
			},editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
			{field:'yAxis',title:'Y(��)',width:60,formatter:function(value,row,index){
				return row.orient[1];
			},editor:{type:'numberbox',options:{precision:1,min:0,required:true}}},
		    {field:'font',title:'����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTFAMILY);
		    },editor:{type:'combobox',options:{
			    width:80,
			    required:true,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTFAMILY
		    }}},
		    {field:'wordsize',title:'�ֺ�',width:60,editor:{type:'numberbox',options:{precision:0,min:0,required:true}}},
			{field:'color',title:'������ɫ',width:70,editor:{type:'text'},styler: function(value,row,index){
				return 'background-color:'+value;
			}},
			{field:'boldtype',title:'�Ӵ�����',width:80,formatter:function(value,row,index){
		    	return getDictLabel(value,dictList.FONTSTYLE);
		    },editor:{type:'combobox',options:{
			    width:80,
		    	valueField:'value',
				textField:'label',
				data:dictList.FONTSTYLE
		    }}},
		    {field:'valueFontSize',title:'ֵ�ֺ�',width:80,editor:{type:'numberbox',options:{precision:0,min:0}}},
		   	{field:'offsetX',title:'ֵƫ����(X)',width:90,editor:{type:'numberbox',options:{precision:1}}},
		    {field:'offsetY',title:'ֵƫ����(Y)',width:90,editor:{type:'numberbox',options:{precision:1}}}
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                addOverScaleRow();
	            }
			},
			{
	            iconCls: 'icon-copy',
	            text: '����',
	            handler: function () {
	                copyOverScaleRow();
	            }
	        },
         	{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteChartConfig("overScale-dg");
            	}
         	},
         	{
            	iconCls: 'icon-top-green',
            	text: '����',
            	handler: function () {
                	moveUp("overScale-dg");
            	}
         	},
         	{
            	iconCls: 'icon-down-blue',
            	text: '����',
            	handler: function () {
                	moveDown("overScale-dg");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex, rowData){
			if((editOverScaleRowIndex!=undefined)&&(editOverScaleRowIndex!=rowIndex)&&!saveOverScaleRow()) return;
			editOverScaleRowIndex=rowIndex;
			$('#overScale-dg').datagrid("beginEdit", editOverScaleRowIndex);
			var overScaleDict={"signCode": "tempDict","linkSignCode":"tempDict","condition":"CONDITION","showMode":"OVERSHOWMODE","locateMode":"LOCATEMODE","font":"FONTFAMILY","boldtype":"FONTSTYLE"};
			var editors = $('#overScale-dg').datagrid('getEditors', editOverScaleRowIndex);
			for(var i=0;i<editors.length;i++){
				if(editors[i].type=="combobox"){
					$(editors[i].target).combobox({
						valueField:"value",
						textField:"label",
						multiple:editors[i].field=="linkSignCode" ? true : false,
						data: dictList[overScaleDict[editors[i].field]]
					})
					if(editors[i].field=="linkSignCode"){
						$(editors[i].target).combobox("setValues",rowData[editors[i].field] ? rowData[editors[i].field].split(",") : "");
					}else{
						$(editors[i].target).combobox("setValue",rowData[editors[i].field]);
					}
				}
				if(editors[i].field=="color"){
					alert(1);
					$(editors[i].target).color({
						editable:true,
						width:70,
						height:30
					});
				}
				if(editors[i].field=="xAxis"){
					$(editors[i].target).numberbox("setValue",rowData.orient[0])
				}
				if(editors[i].field=="yAxis"){
					$(editors[i].target).numberbox("setValue",rowData.orient[1])
				}
			}
		}
	});
}

/// ���ش�ӡ������������
function reloadPrintRuleConfig(data){
	/// �¼���������
	$("#ifEventPortrait").radio("setValue",data.showRule ? (data.showRule.ifEventPortrait=="Y" ? true : false) :"");
	$("#ifDeathEventDelay").radio("setValue",data.showRule ? (data.showRule.ifDeathEventDelay=="Y" ? true : false) :"");
	$("#ifBreakTransLoc").radio("setValue",data.showRule ? (data.showRule.ifBreakTransLoc=="Y" ? true : false) :"");
	/// ����������ʾ��������
	$("#operEvent").combobox("setValue",data.showRule ? data.showRule.eventDr : "");
	$("#operDays").numberbox("setValue",data.showRule ? data.showRule.day : "");
	$("#operNumStyle").combobox("setValue",data.showRule ? data.showRule.number : "");
	$("#operNumAfterDay").radio("setValue",data.showRule ? (data.showRule.operNumAfterDay=="Y" ? true : false) : "");
	$("#operNumAfterEvent").radio("setValue",data.showRule ? (data.showRule.operNumAfterEvent=="Y" ? true : false) : "");
	$("#separator").val(data.showRule ? data.showRule.separator : "");
	$("#connector").val(data.showRule ? data.showRule.connector : "");
	$("#operChangePage").radio("setValue",data.showRule ? (data.showRule.operChangePage=="Y" ? true : false) : "");
	$("#onlyLastOperDay").radio("setValue",data.showRule ? (data.showRule.OnlyLastOperDay=="Y" ? true : false) : "");
	$("#operDayCalcZero").radio("setValue",data.showRule ? (data.showRule.OperDayCalcZero=="Y" ? true : false) : "");
	$("#onlyTwoOperDay").radio("setValue",data.showRule ? (data.showRule.OnlyTwoOperDay=="Y" ? true : false) : "");
	$("#firstDayZero").radio("setValue",data.showRule ? (data.showRule.FirstDayZero=="Y" ? true : false) : "");
	$("#onlyCurOperDayOutMD").radio("setValue",data.showRule ? (data.showRule.OnlyCurOperDayOutMD=="Y" ? true : false) : "");
	$("#onlyRecentOperDayFD").radio("setValue",data.showRule ? (data.showRule.OnlyRecentOperDayFD=="Y" ? true : false) : "");
	/// ����������ʾ��������
	$("#deliverEvent").combobox("setValue",data.showRule ? data.showRule.childbirthEvent : "");
	$("#birthInOperDays").radio("setValue",data.showRule ? (data.showRule.birthInOperDays=="Y" ? true : false) : "");
	$("#birthNotCalcOperNum").radio("setValue",data.showRule ? (data.showRule.birthNotCalcOperNum=="Y" ? true : false) : "");
	/// ������穹�������
	$("#ifShowMissBeat").radio("setValue",data.showRule ? (data.showRule.status=="Y" ? true : false) : "");
	$("#heartBeat").combobox("setValue",data.showRule ? data.showRule.heartCode : "");
	$("#pluse").combobox("setValue",data.showRule ? data.showRule.pluseCode : "");
	$("#fillStyle").combobox("setValue",data.showRule ? (data.showRule.fillStyle ? data.showRule.fillStyle : data.showRule.style) : "");
	$("#onlySamePointHPConnect").radio("setValue",data.showRule ? (data.showRule.onlySamePointHPConnect=="Y" ? true : false) : "");
	$("#fillColor,#skinTestYColor,#skinTestNColor").color({
		editable:true,
		width:90,
		height:30
	})
	$("#fillColor").color("setValue",data.showRule.color ? data.showRule.color : "#000000");
	/// ���������ʾ����
	$("#skinTestY").combobox("setValue",data.showRule ? data.showRule.skinTestYText : "");
	$("#skinTestYColor").color("setValue",data.showRule ? (data.showRule.skinTestYColor ? data.showRule.skinTestYColor : "#000000") : "#000");
	$("#skinTestN").combobox("setValue",data.showRule ? data.showRule.skinTestNText : "");
	$("#skinTestNColor").color("setValue",data.showRule ? (data.showRule.skinTestNColor ? data.showRule.skinTestNColor : "#000000") : "#000");
	$("#ifShowMultMed").radio("setValue",data.showRule ? (data.showRule.ifShowMultMed=="Y" ? true : false) : "");

	$("#event-dg").datagrid("loadData",data.eventRule ? data.eventRule : []);
	$("#afterDrop-dg").datagrid("loadData",data.afterDrop ? data.afterDrop : []);
	$("#suddenFever-dg").datagrid("loadData",data.suddenFever ? data.suddenFever : []);
	$("#retest-dg").datagrid("loadData",data.retest ? data.retest : []);
	$("#overScale-dg").datagrid("loadData",data.scaleRule ? data.scaleRule : []);
}

/// �����¼���������
function addEventRow(){
	if((editEventRowIndex!=undefined)&&!saveEventRow()) return;
	editEventRowIndex=$('#event-dg').datagrid('getRows').length;
	var row={
        rowKey: "event"+(editEventRowIndex+1),
        eventName: "",
        showName:"",
		timeFlag: "",
		intervalMode: "",
		cellWidth: "",
		cellHeight: "",
		locateMode: "",
		orient: [],
		font: "",
		wordsize: "",
		color: "#000000",
		boldtype: ""
    };
	var eventDict={"eventName": "tempEventDict","timeFormat":"TIMEFORMAT","intervalMode":"INTERVALMODE","locateMode":"LOCATEMODE","font":"FONTFAMILY","boldtype":"FONTSTYLE"};
	$('#event-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editEventRowIndex).datagrid("selectRow",editEventRowIndex);
	var editors = $('#event-dg').datagrid('getEditors', editEventRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[eventDict[editors[i].field]]
			})
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			});
		}
	}
}

/// �����¼���������
function copyEventRow(){
	var selRow=$("#event-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editEventRowIndex!=undefined)&&!saveEventRow()) return;
	var curIndex=$("#event-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editEventRowIndex=curIndex+1;
	var rows=$('#event-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="event"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#event-dg').datagrid("loadData",rows).datagrid("beginEdit", editEventRowIndex).datagrid("selectRow",editEventRowIndex);
	var eventDict={"eventName": "tempEventDict","timeFormat":"TIMEFORMAT","intervalMode":"INTERVALMODE","locateMode":"LOCATEMODE","font":"FONTFAMILY","boldtype":"FONTSTYLE"};
	var editors = $('#event-dg').datagrid('getEditors', editEventRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[eventDict[editors[i].field]]
			}).combobox("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="xAxis"){
			$(editors[i].target).numberbox("setValue",newRow.orient[0]);
		}
		if(editors[i].field=="yAxis"){
			$(editors[i].target).numberbox("setValue",newRow.orient[1]);
		}
	}
}

/// �����¼��������ñ༭������
function saveEventRow() {
	if (editEventRowIndex==undefined) return;
	var rowEditors=$('#event-dg').datagrid('getEditors',editEventRowIndex);
	var eventName=$(rowEditors[0].target).combobox("getValue");
	var cellWidth=$(rowEditors[5].target).numberbox("getValue");
	var cellHeight=$(rowEditors[6].target).numberbox("getValue");
	var locateMode=$(rowEditors[7].target).combobox("getValue");
	var xAxis=$(rowEditors[8].target).numberbox("getValue");
	var yAxis=$(rowEditors[9].target).numberbox("getValue");
	var font=$(rowEditors[10].target).combobox("getValue");
	var wordsize=$(rowEditors[11].target).numberbox("getValue");
	var color=$(rowEditors[12].target).color("getValue");
	if(eventName=="" || cellWidth=="" || cellHeight=="" || locateMode=="" || xAxis=="" || font=="" || yAxis=="" || wordsize=="") return;
	var rows=$("#event-dg").datagrid("getRows");
	rows[editEventRowIndex].orient[0]=xAxis;
	rows[editEventRowIndex].orient[1]=yAxis;
	$('#event-dg').datagrid("endEdit",editEventRowIndex);
	rows[editEventRowIndex].color=color;
	$('#event-dg').datagrid("loadData",rows);
	return true;
}

/// ����������������
function addAfterDropRow(){
	if((editAfterDropRowIndex!=undefined)&&!saveAfterDropRow()) return;
	editAfterDropRowIndex=$('#afterDrop-dg').datagrid('getRows').length;
	var row={
		rowKey: "afterDrop"+(editAfterDropRowIndex+1),
        signCode: "",
		afterDropDesc: "",
		color: "#000000",
		linkSignCode: "",
		cables: "",
		showRule: "",
		linetype: "",
		condition: "",
		number: "",
		offset: "",
		xAxis: "",
		yAxis: "",
		cWidth: "",
		cHeight: "",
		minScaleValue: "",
		maxValue: "",
		minValue: ""
	};
	var afterDropDict={"signCode": "tempDict","linkSignCode":"tempDict","cables":"CABLESRULE","showRule":"AFTERDROPRULE","linetype":"LINETYPE","condition":"CONDITION"};
	$('#afterDrop-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editAfterDropRowIndex).datagrid("selectRow",editAfterDropRowIndex);
	var editors = $('#afterDrop-dg').datagrid('getEditors', editAfterDropRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[afterDropDict[editors[i].field]]
			})
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			});
		}
	}
}

/// ���Ƹ�����������
function copyAfterDropRow(){
	var selRow=$("#afterDrop-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editAfterDropRowIndex!=undefined)&&!saveAfterDropRow()) return;
	var curIndex=$("#afterDrop-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editAfterDropRowIndex=curIndex+1;
	var rows=$('#afterDrop-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="afterDrop"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#afterDrop-dg').datagrid("loadData",rows).datagrid("beginEdit", editAfterDropRowIndex).datagrid("selectRow",editAfterDropRowIndex);
	var afterDropDict={"signCode": "tempDict","linkSignCode":"tempDict","cables":"CABLESRULE","showRule":"AFTERDROPRULE","linetype":"LINETYPE","condition":"CONDITION"};
	var editors = $('#afterDrop-dg').datagrid('getEditors', editAfterDropRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[afterDropDict[editors[i].field]]
			}).combobox("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
	}
}

/// ���渴���������ñ༭������
function saveAfterDropRow() {
	if (editAfterDropRowIndex==undefined) return;
	var rowEditors=$('#afterDrop-dg').datagrid('getEditors',editAfterDropRowIndex);
	var signCode=$(rowEditors[0].target).combobox("getValue");
	var afterDropDesc=$.trim($(rowEditors[1].target).val());
	var color=$(rowEditors[2].target).color("getValue");
	var linkSignCode=$(rowEditors[3].target).combobox("getValue");
	var showRule=$(rowEditors[5].target).combobox("getValue");
	var condition=$(rowEditors[7].target).combobox("getValue");
	var number=$(rowEditors[8].target).numberbox("getValue");
	if(signCode=="" || afterDropDesc=="" || linkSignCode=="" || showRule=="" || condition=="" || number=="") return;
	$('#afterDrop-dg').datagrid("endEdit",editAfterDropRowIndex);
	var rows=$('#afterDrop-dg').datagrid("getRows");
	rows[editAfterDropRowIndex].color=color;
	$('#afterDrop-dg').datagrid("loadData",rows);
	return true;
}

/// ����ͻȻ���ȹ�������
function addSuddenFeverRow(){
	if((editSuddenFeverRowIndex!=undefined)&&!saveSuddenFeverRow()) return;
	editSuddenFeverRowIndex=$('#suddenFever-dg').datagrid('getRows').length;
	var row={
		rowKey: "suddenFever"+(editSuddenFeverRowIndex+1),
        signCode: "",
		afterDropDesc: "",
		color: "#000000",
		linkSignCode: "",
		cables: "",
		showRule: "",
		linetype: "",
		condition: "",
		number: "",
		offset: ""
	};
	var suddenFeverDict={"signCode": "tempDict","linkSignCode":"tempDict","cables":"CABLESRULE","showRule":"AFTERDROPRULE","linetype":"LINETYPE","condition":"CONDITION"};
	$('#suddenFever-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editSuddenFeverRowIndex).datagrid("selectRow",editSuddenFeverRowIndex);
	var editors = $('#suddenFever-dg').datagrid('getEditors', editSuddenFeverRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[suddenFeverDict[editors[i].field]]
			})
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			});
		}
	}
}

/// ����ͻȻ���ȹ�������
function copySuddenFeverRow(){
	var selRow=$("#suddenFever-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editSuddenFeverRowIndex!=undefined)&&!saveSuddenFeverRow()) return;
	var curIndex=$("#suddenFever-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editSuddenFeverRowIndex=curIndex+1;
	var rows=$('#suddenFever-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="suddenFever"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#suddenFever-dg').datagrid("loadData",rows).datagrid("beginEdit", editSuddenFeverRowIndex).datagrid("selectRow",editSuddenFeverRowIndex);
	var suddenFeverDict={"signCode": "tempDict","linkSignCode":"tempDict","cables":"CABLESRULE","showRule":"AFTERDROPRULE","linetype":"LINETYPE","condition":"CONDITION"};
	var editors = $('#suddenFever-dg').datagrid('getEditors', editSuddenFeverRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[suddenFeverDict[editors[i].field]]
			}).combobox("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
	}
}

/// ����ͻȻ���ȹ������ñ༭������
function saveSuddenFeverRow() {
	if (editSuddenFeverRowIndex==undefined) return;
	var rowEditors=$('#suddenFever-dg').datagrid('getEditors',editSuddenFeverRowIndex);
	var signCode=$(rowEditors[0].target).combobox("getValue");
	var afterDropDesc=$.trim($(rowEditors[1].target).val());
	var color=$(rowEditors[2].target).color("getValue");
	var linkSignCode=$(rowEditors[3].target).combobox("getValue");
	var showRule=$(rowEditors[5].target).combobox("getValue");
	var condition=$(rowEditors[7].target).combobox("getValue");
	var number=$(rowEditors[8].target).numberbox("getValue");
	if(signCode=="" || afterDropDesc=="" || linkSignCode=="" || showRule=="" || condition=="" || number=="") return;
	$('#suddenFever-dg').datagrid("endEdit",editSuddenFeverRowIndex);
	var rows=$('#suddenFever-dg').datagrid("getRows");
	rows[editSuddenFeverRowIndex].color=color;
	$('#suddenFever-dg').datagrid("loadData",rows);
	return true;
}

/// ���������������
function addRetestRow(){
	if((editRetestRowIndex!=undefined)&&!saveRetestRow()) return;
	editRetestRowIndex=$('#retest-dg').datagrid('getRows').length;
	var row={
		rowKey: "retest"+(editRetestRowIndex+1),
        signCode: "",
		retestDesc: "",
		color: "#000000",
		upMinValue: "",
		downMinValue: "",
		iconSize: "",
		offsetX: "",
		offsetY: ""
	};
	var retestDict={"signCode": "tempDict"};
	$('#retest-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editRetestRowIndex).datagrid("selectRow",editRetestRowIndex);
	var editors = $('#retest-dg').datagrid('getEditors', editRetestRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[retestDict[editors[i].field]]
			})
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			});
		}
	}
}

/// ���Ƹ����������
function copyRetestRow(){
	var selRow=$("#retest-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editRetestRowIndex!=undefined)&&!saveRetestRow()) return;
	var curIndex=$("#retest-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editRetestRowIndex=curIndex+1;
	var rows=$('#retest-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="retest"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#retest-dg').datagrid("loadData",rows).datagrid("beginEdit", editRetestRowIndex).datagrid("selectRow",editRetestRowIndex);
	var retestDict={"signCode": "tempDict"};
	var editors = $('#retest-dg').datagrid('getEditors', editRetestRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				data: dictList[retestDict[editors[i].field]]
			}).combobox("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
	}
}

/// ���渴��������ñ༭������
function saveRetestRow() {
	if (editRetestRowIndex==undefined) return;
	var rowEditors=$('#retest-dg').datagrid('getEditors',editRetestRowIndex);
	var signCode=$(rowEditors[0].target).combobox("getValue");
	var retestDesc=$.trim($(rowEditors[1].target).val());
	var color=$(rowEditors[2].target).color("getValue");
	var upMinValue=$(rowEditors[3].target).numberbox("getValue");
	var downMinValue=$(rowEditors[4].target).numberbox("getValue");
	var iconSize=$(rowEditors[5].target).numberbox("getValue");
	if(signCode=="" || retestDesc=="" || upMinValue=="" || downMinValue=="" || iconSize=="") return;
	$('#retest-dg').datagrid("endEdit",editRetestRowIndex);
	var rows=$('#retest-dg').datagrid("getRows");
	rows[editRetestRowIndex].color=color;
	$('#retest-dg').datagrid("loadData",rows);
	return true;
}

/// ����������߹��򼰶�������
function addOverScaleRow(){
	if((editOverScaleRowIndex!=undefined)&&!saveOverScaleRow()) return;
	editOverScaleRowIndex=$('#overScale-dg').datagrid('getRows').length;
	var row={
        rowKey: "overScale"+(editOverScaleRowIndex+1),
        signCode: "",
          linkSignCode: "",
          condition: "",
          number: "",
          showMode: "",
          icon: "",
          iconOffsetX: "",
          iconOffsetY: "",
          isCables: "",
          cellWidth: "",
          cellHeight: "",
          locateMode: "",
          orient: [],
          font: "",
          wordsize: "",
          color: "#000000",
          boldtype: "",
          valueFontSize: "",
          offsetX: "",
          offsetY: ""
    };
	var overScaleDict={"signCode": "tempDict","linkSignCode":"tempDict","condition":"CONDITION","showMode":"OVERSHOWMODE","locateMode":"LOCATEMODE","font":"FONTFAMILY","boldtype":"FONTSTYLE"};
	$('#overScale-dg').datagrid("insertRow", {row: row}).datagrid("beginEdit", editOverScaleRowIndex).datagrid("selectRow",editOverScaleRowIndex);
	var editors = $('#overScale-dg').datagrid('getEditors', editOverScaleRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				multiple:editors[i].field=="linkSignCode" ? true : false,
				data: dictList[overScaleDict[editors[i].field]]
			})
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			});
		}
	}
}

/// ���Ƴ�����߹��򼰶�������
function copyOverScaleRow(){
	var selRow=$("#overScale-dg").datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ���踴�Ƶ������', type:'info' });
	}
	if((editOverScaleRowIndex!=undefined)&&!saveOverScaleRow()) return;
	var curIndex=$("#overScale-dg").datagrid("getRowIndex",selRow[0].rowKey);
	editOverScaleRowIndex=curIndex+1;
	var rows=$('#overScale-dg').datagrid('getRows');
	var newRow=JSON.parse(JSON.stringify(selRow[0]));
	newRow.rowKey="overScale"+(rows.length+1);
	rows.splice(curIndex+1,0,newRow);
	$('#overScale-dg').datagrid("loadData",rows).datagrid("beginEdit", editOverScaleRowIndex).datagrid("selectRow",editOverScaleRowIndex);
	var overScaleDict={"signCode": "tempDict","linkSignCode":"tempDict","condition":"CONDITION","showMode":"OVERSHOWMODE","locateMode":"LOCATEMODE","font":"FONTFAMILY","boldtype":"FONTSTYLE"};
	var editors = $('#overScale-dg').datagrid('getEditors', editOverScaleRowIndex);
	for(var i=0;i<editors.length;i++){
		if(editors[i].type=="combobox"){
			$(editors[i].target).combobox({
				valueField:"value",
				textField:"label",
				multiple:editors[i].field=="linkSignCode" ? true : false,
				data: dictList[overScaleDict[editors[i].field]]
			})
			if(editors[i].field=="linkSignCode"){
				$(editors[i].target).combobox("setValues",newRow[editors[i].field]);
			}else{
				$(editors[i].target).combobox("setValue",newRow[editors[i].field]);
			}
		}
		if(editors[i].field=="color"){
			$(editors[i].target).color({
				editable:true,
				width:70,
				height:30
			}).color("setValue",newRow[editors[i].field]);
		}
		if(editors[i].field=="xAxis"){
			$(editors[i].target).numberbox("setValue",newRow.orient[0]);
		}
		if(editors[i].field=="yAxis"){
			$(editors[i].target).numberbox("setValue",newRow.orient[1]);
		}
	}
}

/// ���泬����߹��򼰶������ñ༭������
function saveOverScaleRow() {
	if (editOverScaleRowIndex==undefined) return;
	var rowEditors=$('#overScale-dg').datagrid('getEditors',editOverScaleRowIndex);
	var signCode=$(rowEditors[0].target).combobox("getValue");
	var condition=$(rowEditors[2].target).combobox("getValue");
	var number=$.trim($(rowEditors[3].target).val());
	var showMode=$(rowEditors[4].target).combobox("getValue");
	var icon=$.trim($(rowEditors[5].target).val());
	var cellWidth=$(rowEditors[9].target).numberbox("getValue");
	var cellHeight=$(rowEditors[10].target).numberbox("getValue");
	var locateMode=$(rowEditors[11].target).combobox("getValue");
	var xAxis=$(rowEditors[12].target).numberbox("getValue");
	var yAxis=$(rowEditors[13].target).numberbox("getValue");
	var font=$(rowEditors[14].target).combobox("getValue");
	var wordsize=$(rowEditors[15].target).numberbox("getValue");
	var color=$(rowEditors[16].target).color("getValue");
	if(signCode=="" || condition=="" || number=="" || showMode=="" || icon=="" || cellWidth=="" || cellHeight=="" || locateMode=="" || xAxis=="" || font=="" || yAxis=="" || wordsize=="") return;
	var rows=$("#overScale-dg").datagrid("getRows");
	rows[editOverScaleRowIndex].orient[0]=xAxis;
	rows[editOverScaleRowIndex].orient[1]=yAxis;
	$('#overScale-dg').datagrid("endEdit",editOverScaleRowIndex);
	rows[editOverScaleRowIndex].color=color;
	$('#overScale-dg').datagrid("loadData",rows);
	return true;
}

/// ����
function moveUp(tableId){
	var selRow=$("#"+tableId).datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ�����Ƶ������', type:'info' });
	}
	if(tableId=="text-dg"){
		if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
		editTextRowIndex=undefined;
	}
	if(tableId=="sheet-dg"){
		if((editSheetRowIndex!=undefined)&&!saveSheetRow()) return;
		editSheetRowIndex=undefined;
	}
	if(tableId=="curve-dg"){
		if((editCurveRowIndex!=undefined)&&!saveCurveRow()) return;
		editCurveRowIndex=undefined;
	}
	if(tableId=="event-dg"){
		if((editEventRowIndex!=undefined)&&!saveEventRow()) return;
		editEventRowIndex=undefined;
	}
	if(tableId=="afterDrop-dg"){
		if((editAfterDropRowIndex!=undefined)&&!saveAfterDropRow()) return;
		editAfterDropRowIndex=undefined;
	}
	if(tableId=="suddenFever-dg"){
		if((editSuddenFeverRowIndex!=undefined)&&!saveSuddenFeverRow()) return;
		editSuddenFeverRowIndex=undefined;
	}
	if(tableId=="retest-dg"){
		if((editRetestRowIndex!=undefined)&&!saveRetestRow()) return;
		editRetestRowIndex=undefined;
	}
	if(tableId=="overScale-dg"){
		if((editOverScaleRowIndex!=undefined)&&!saveOverScaleRow()) return;
		editOverScaleRowIndex=undefined;
	}
	var index=$("#"+tableId).datagrid("getRowIndex",selRow[0].rowKey);
	var rows=$("#"+tableId).datagrid('getRows');
	if(index>0){
		var prevIndex = index - 1;
        rows.splice(index,1)
        rows.splice(prevIndex,0,selRow[0]);
        $("#"+tableId).datagrid("loadData",rows);
	}
}

/// ����
function moveDown(tableId){
	var selRow=$("#"+tableId).datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ�����Ƶ������', type:'info' });
	}
	if(tableId=="text-dg"){
		if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
		editTextRowIndex=undefined;
	}
	if(tableId=="sheet-dg"){
		if((editSheetRowIndex!=undefined)&&!saveSheetRow()) return;
		editSheetRowIndex=undefined;
	}
	if(tableId=="curve-dg"){
		if((editCurveRowIndex!=undefined)&&!saveCurveRow()) return;
		editCurveRowIndex=undefined;
	}
	if(tableId=="event-dg"){
		if((editEventRowIndex!=undefined)&&!saveEventRow()) return;
		editEventRowIndex=undefined;
	}
	if(tableId=="afterDrop-dg"){
		if((editAfterDropRowIndex!=undefined)&&!saveAfterDropRow()) return;
		editAfterDropRowIndex=undefined;
	}
	if(tableId=="suddenFever-dg"){
		if((editSuddenFeverRowIndex!=undefined)&&!saveSuddenFeverRow()) return;
		editSuddenFeverRowIndex=undefined;
	}
	if(tableId=="retest-dg"){
		if((editRetestRowIndex!=undefined)&&!saveRetestRow()) return;
		editRetestRowIndex=undefined;
	}
	if(tableId=="overScale-dg"){
		if((editOverScaleRowIndex!=undefined)&&!saveOverScaleRow()) return;
		editOverScaleRowIndex=undefined;
	}
	var index=$("#"+tableId).datagrid("getRowIndex",selRow[0].rowKey);
	var rows=$("#"+tableId).datagrid('getRows');
	if(index<rows.length){
		var nextIndex = index + 1;
        rows.splice(index,1)
        rows.splice(nextIndex,0,selRow[0]);
        $("#"+tableId).datagrid("loadData",rows);
	}
}

/// ѡ���ͷͼƬ
function chooseImg() {
	var files = $("#logo").next().find('input[type=file]')[0].files[0]
	var size = files.size / 1024 / 1024;
	console.log(size)
	console.log(files)
	if (size <= 1) {
		var reader = new FileReader();
		reader.readAsDataURL(files);
		reader.onload = function(event) {
		  var imgFile = event.target.result;
		  $(".show-img").show();
		  $(".show-img img").attr("src",imgFile);
		};
	} else {
		return $.messager.popover({ msg: 'ͼƬ��С���ܳ���1M', type:'info' });
	}
}

/// Ԥ����ͷͼƬ
function deleteImg(){
	$(".show-img img").attr("src","");
	$("#logo").filebox("setText","");
	$(".show-img").hide();
}

/// �������µ�ģ����������
function saveChartConfig(chartId,option,importChartId){
	if(!chartId){
		var selChart=$("#chartList").datagrid("getSelections");
		if(selChart.length==0){
			return $.messager.popover({ msg: '��ѡ��ҪҪ��������µ�ģ�壡', type:'info' });
		}
		chartId=selChart[0].rowID;
	}

	if((editTextRowIndex!=undefined)&&!saveTextRow()) return;
	editTextRowIndex=undefined;

	if((editSheetRowIndex!=undefined)&&!saveSheetRow()) return;
	editSheetRowIndex=undefined;

	if((editCurveRowIndex!=undefined)&&!saveCurveRow()) return;
	editCurveRowIndex=undefined;

	if((editEventRowIndex!=undefined)&&!saveEventRow()) return;
	editEventRowIndex=undefined;

	if((editAfterDropRowIndex!=undefined)&&!saveAfterDropRow()) return;
	editAfterDropRowIndex=undefined;

	if((editSuddenFeverRowIndex!=undefined)&&!saveSuddenFeverRow()) return;
	editSuddenFeverRowIndex=undefined;

	if((editRetestRowIndex!=undefined)&&!saveRetestRow()) return;
	editRetestRowIndex=undefined;

	if((editOverScaleRowIndex!=undefined)&&!saveOverScaleRow()) return;
	editOverScaleRowIndex=undefined;

	loading("���ڱ�������");
	if(option && option=="hospCopy"){
		var configData={};
		if(typeof REQUEST_WAY==="undefined") {
			configData = $.cm({
				ClassName: "Nur.NIS.Service.Chart.PrintSetting",
				MethodName: "getTemperatureConfigInfo",
				"RowID": importChartId
			}, false);

		}else{
			$.ajax({
				url: API_BASE_URL+"/config/v1/nrChart/getTemperatureConfigInfo",
				type: 'POST',
				data:{id: importChartId},
				dataType: 'json',
				async:false,
				success: function(response) {
					// ����ɹ��Ļص�����
					// �����ﴦ����Ӧ���ݣ������丳ֵ��datagrid
					//var category = $("#category").combobox("getValue");
					if(response.code==200){
						configData=response.data;
					}
				},
				error: function(xhr, status, error) {
					// ����ʧ�ܵĻص�����
					console.error('��������ʧ�ܣ�', error);
					// ��������
					$.messager.popover({msg:"���µ����ò�ѯʧ�ܣ�	", type:'error'});
				}
			});
		}
		var tableConfig = JSON.parse(configData.data.tableConfig);
		var textConfig = JSON.parse(configData.data.textConfig);
		var contentConfig = JSON.parse(configData.data.contentConfig);
		var printConfig = JSON.parse(configData.data.printRuleConfig);
		/// ȥ�������еĹؼ��֣������̨���ղ�����Ӧ�Ĳ���
		if (!printConfig.showRule.hasOwnProperty("fillStyle")) {
			if (printConfig.showRule.hasOwnProperty("style")) {
				printConfig.showRule.fillStyle = printConfig.showRule.style;
				delete printConfig.showRule.style;
			} else {
				printConfig.showRule.fillStyle = "";
			}
		}
		var printRuleConfig = printConfig;
	}else{
		/// �������������
		var tableConfig={
			header:{
				image:$(".show-img img").attr("src"),
				imageName:$("#logo").next().find(".filebox-text").val(),
				height:$("#height").numberbox("getValue"),
				width:$("#width").numberbox("getValue"),
				xAxis:$("#xAxis").numberbox("getValue"),
				yAxis:$("#yAxis").numberbox("getValue")
			},
			special:{
				dateFormatFlag:$("#dateformat").combobox("getValue"),
				ruleFlag:$("#changebedrules").combobox("getValue"),
				recentlyNums:$("#recentlyNums").numberbox("getValue"),
				officeRuleFlag:$("#changedeptrules").combobox("getValue"),
				showDirection:$("#bedlocextdirec").combobox("getValue")
			},
			page:{
				ifColorPrint:$("#ifColorPrint").radio("getValue") ? "Y" : "N"
			}
		};
		/// �����������
		var textConfig={
			TwoBPInSameCol:$("#twoBPInSameCol").radio("getValue") ? "Y" : "N",
			bpShowNums:$("#bpShowNums").combobox("getValue"),
			intervalTime:$("#intervalTime").combobox("getValue"),
			intervalTimeAM:$("#intervalTimeAM").combobox("getValue"),
			intervalTimeAM2:$("#intervalTimeAM2").combobox("getValue"),
			intervalTimePM:$("#intervalTimePM").combobox("getValue"),
			intervalTimePM2:$("#intervalTimePM2").combobox("getValue"),
			ifSequence:$("#ifSequence").radio("getValue") ? "Y" : "N",
			texts:$("#text-dg").datagrid("getRows")
		};
		/// �����������
		var contentConfig={
			timing:$("#timing").val(),
			days:$("#days").numberbox("getValue"),
			redTiming:$("#redTime").val(),
			ifPointCellCenter:$("#ifPointCellCenter").radio("getValue") ? "Y" : "N",
			sheet:$("#sheet-dg").datagrid("getRows"),
			curve:$("#curve-dg").datagrid("getRows")
		}
		/// ��ӡ��������
		var printRuleConfig={
			showRule:{
				ifEventPortrait:$("#ifEventPortrait").radio("getValue") ? "Y" : "N",
				ifDeathEventDelay:$("#ifDeathEventDelay").radio("getValue") ? "Y" : "N",
				ifBreakTransLoc:$("#ifBreakTransLoc").radio("getValue") ? "Y" : "N",
				eventDr:$("#operEvent").combobox("getValue"),
				day:$("#operDays").numberbox("getValue"),
				number:$("#operNumStyle").combobox("getValue"),
				operNumAfterDay:$("#operNumAfterDay").radio("getValue") ? "Y" : "N",
				operNumAfterEvent:$("#operNumAfterEvent").radio("getValue") ? "Y" : "N",
				separator:$("#separator").val(),
				connector:$("#connector").val(),
				operChangePage:$("#operChangePage").radio("getValue") ? "Y" : "N",
				OnlyLastOperDay:$("#onlyLastOperDay").radio("getValue") ? "Y" : "N",
				OperDayCalcZero:$("#operDayCalcZero").radio("getValue") ? "Y" : "N",
				OnlyTwoOperDay:$("#onlyTwoOperDay").radio("getValue") ? "Y" : "N",
				FirstDayZero:$("#firstDayZero").radio("getValue") ? "Y" : "N",
				OnlyCurOperDayOutMD:$("#onlyCurOperDayOutMD").radio("getValue") ? "Y" : "N",
				OnlyRecentOperDayFD:$("#onlyRecentOperDayFD").radio("getValue") ? "Y" : "N",
				childbirthEvent:$("#deliverEvent").combobox("getValue"),
				birthInOperDays:$("#birthInOperDays").radio("getValue") ? "Y" : "N",
				birthNotCalcOperNum:$("#birthNotCalcOperNum").radio("getValue") ? "Y" : "N",
				status:$("#ifShowMissBeat").radio("getValue") ? "Y" : "N",
				heartCode:$("#heartBeat").combobox("getValue"),
				pluseCode:$("#pluse").combobox("getValue"),
				fillStyle:$("#fillStyle").combobox("getValue"),
				color:$("#fillColor").color("getValue"),
				onlySamePointHPConnect:$("#onlySamePointHPConnect").radio("getValue") ? "Y" : "N",
				skinTestYText:$("#skinTestY").combobox("getValue"),
				skinTestYColor:$("#skinTestYColor").color("getValue"),
				skinTestNText:$("#skinTestN").combobox("getValue"),
				skinTestNColor:$("#skinTestNColor").color("getValue"),
				ifShowMultMed:$("#ifShowMultMed").radio("getValue") ? "Y" : "N"
			},
			eventRule:$("#event-dg").datagrid("getRows"),
			afterDrop:$("#afterDrop-dg").datagrid("getRows"),
			suddenFever:$("#suddenFever-dg").datagrid("getRows"),
			retest:$("#retest-dg").datagrid("getRows"),
			scaleRule:$("#overScale-dg").datagrid("getRows")
		};
	}

	if(typeof REQUEST_WAY==="undefined"){
		$.cm({
			ClassName:"Nur.NIS.Service.Chart.PrintSetting",
			MethodName:"saveConfig",
			p1:chartId,
			p2:JSON.stringify(tableConfig),
			p3:JSON.stringify(contentConfig),
			p4:JSON.stringify(printRuleConfig),
			p5:JSON.stringify(textConfig)
		},function(data){
			disLoad();
			if(data.code===0){
				handleConfigResponse(chartId,option);
			}else{
				return $.messager.popover({ msg: data.error, type:'error' });
			}
		})
	}else{
		var temperaturePrintConfigVo={
			chartid: chartId,
			tableConfig:tableConfig,
			contentConfig:contentConfig,
			printRuleConfig:printRuleConfig,
			textConfig:textConfig
		}
		$.ajax({
			url: API_BASE_URL+"/config/v1/nrChart/saveTemperatureConfigInfo",
			type: 'POST',
			//data:temperaturePrintConfigVo,
			data: JSON.stringify(temperaturePrintConfigVo),
			//dataType: 'json',
			contentType: 'application/json;chartset=UTF-8',
			success: function(response) {
				// ����ɹ��Ļص�����
				// �����ﴦ����Ӧ���ݣ������丳ֵ��datagrid
				disLoad();
				if(response.code==200){
					handleConfigResponse(chartId,option);
				}else{
					return $.messager.popover({ msg: "����ʧ�ܣ�", type:'error' });
				}
			},
			error: function(xhr, status, error) {
				// ����ʧ�ܵĻص�����
				console.error('��������ʧ�ܣ�', error);
				// ��������
				$.messager.popover({msg:"����ʧ�ܣ�", type:'error'});
			}
		});
	}
}

/// ���������÷��صĽ��
function handleConfigResponse(chartId,option){
	$.messager.popover({ msg: "����ɹ���", type:'success' });
	reloadChartData("chartList","",chartId);
	/*if(option){
		reloadChartData("chartList","",chartId);
	}else{
		/// getChartConfig(chartId);
	}*/
}

/// ɾ�����ñ�����
function deleteChartConfig(tableId){
	var selRow=$("#"+tableId).datagrid("getSelections");
	if(selRow.length==0){
		return $.messager.popover({ msg: '��ѡ��Ҫɾ�������ã�', type:'info' });
	}
	var selChart=$("#chartList").datagrid("getSelections");
	$.messager.confirm("����ʾ", "ȷ��Ҫɾ����������", function (r) {
		if (r) {
			var rowKey=tableId=="event-dg" ? selRow[0].eventName : selRow[0].rowKey;
			var index=$("#"+tableId).datagrid("getRowIndex",selRow[0].rowKey);
			if(typeof REQUEST_WAY==="undefined"){
				if(tableId!="sheet-dg"){
					var ret=$.cm({
						ClassName:"Nur.NIS.Service.Chart.PrintSetting",
						MethodName:"deleteChartConfig",
						chartID:selChart[0].rowID,
						rowKey:rowKey,
						module:tableId
					},false);
					if(ret==0) $("#"+tableId).datagrid("deleteRow",index);
				}else{
					$("#"+tableId).datagrid("deleteRow",index);
				}
			}else{
				$("#"+tableId).datagrid("deleteRow",index);
			}
			if(tableId=="text-dg") editTextRowIndex=undefined;
			if(tableId=="sheet-dg") editSheetRowIndex=undefined;
			if(tableId=="curve-dg") editCurveRowIndex=undefined;
			if(tableId=="event-dg") editEventRowIndex=undefined;
			if(tableId=="afterDrop-dg") editAfterDropRowIndex=undefined;
			if(tableId=="suddenFever-dg") editSuddenFeverRowIndex=undefined;
			if(tableId=="retest-dg") editRetestRowIndex=undefined;
			if(tableId=="overScale-dg") editOverScaleRowIndex=undefined;
			saveChartConfig();
		}
	});
}

/// �������ز�
function loading(msg) {
	$.messager.progress({
		title: "��ʾ",
		msg: msg,
		text: '�����ĵȴ�....'
	});
}

/// ȡ�����ز�
function disLoad() {
	$.messager.progress("close");
}


