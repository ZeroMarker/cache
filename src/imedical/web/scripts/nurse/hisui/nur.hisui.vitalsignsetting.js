/**
* @author songchunli
* HISUI ����������������js
*/
$.extend($.fn.datagrid.methods, {
  getEditingRowIndexs: function(jq) {
    var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
    var indexs = [];
    rows.each(function(i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
          indexs.push(index);
      }
    });
    return indexs;
  }
});
var PageLogicObj={
	lastNum:"", //��¼���к�
	m_WardJson:"", //���в���json
	m_IsShowJson:"", //�ִ�ʱ�Ƿ���ʾjson
	m_ApplyPersonTypeJson:"", //������Ⱥ
	m_selRowId:"" //����������ѡ����rowid
}
var vitalsignList=[], yestVSList=[],vitalsignObj={};
var charCodeF = String.fromCharCode(129);
var docAdvicesObj = {}, daObj = {};
var docAdviceloader = function (param, success, error) {
	var q = param.q || "";
	var delimiter = String.fromCharCode(12);
	var key = q;
	if ("" === key) key = delimiter;
	if (!docAdvicesObj[key]) {
		var docAdvices = $cm(
			{
				ClassName: "Nur.NIS.Service.TaskOverview.Normal",
				QueryName: "GetDocAdvice",
				rows: 50,
				ARCIMDesc: q,
				hospDR: $HUI.combogrid('#_HospList').getValue(),
			},
			false
		);
		docAdvicesObj[key] = docAdvices.rows;
	}
	var id = daObj.id;
	if (id) {
		var exist = false;
		$.map(docAdvicesObj[key], function (e) {
			if (id == e.id) exist = true;
		});
		if (!exist)
			docAdvicesObj[key].push({
				id: daObj.id,
				desc: daObj.adviseDesc,
			});
		success(docAdvicesObj[key]);
		daObj = {};
	} else {
		success(docAdvicesObj[key]);
	}
};
function loadBasicDict(){
  $cm({
		ClassName: "Nur.NIS.Service.BasicDict.Config",
		QueryName: "GetBasicDict",
		rows: 9999,
		keyword:$("#values").combobox("getText"),
		hospDR: $HUI.combogrid('#_HospList').getValue(),
		groupFlag: 1,
	}, function (data) {
		$("#values").combobox({
			'panelHeight':data.rows.length>7?210:'auto',
			'data':data.rows
		});
		$("#specialSign").combobox({
			'panelHeight':(data.rows.length>7)?210:'auto',
			'data':data.rows
		});
	});
}
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
function addOeordRow() {
	var len=$('#oeordTable').datagrid('getRows').length;
	var row={
		obsItm: "",
		itmMast: "",
		textVal: "",
		id: ""
	}
	$('#oeordTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", len);
  editOeordRow(len,row)
}
function editOeordRow(curInd,row) {
	daObj={
		id:row.itmMast,
		adviseDesc:row.itmMastDesc,
	}
	$('#oeordTable').datagrid('beginEdit', curInd);
  var rowEditors=$('#oeordTable').datagrid('getEditors',curInd);
	$(rowEditors[0].target).combobox('loadData', vitalsignList);
	if (row.id) {
		$(rowEditors[0].target).combobox('setValue', row.obsItm);
		$(rowEditors[1].target).combobox('setValue', row.itmMast);
		$(rowEditors[2].target).val(row.textVal);
	}
}
function saveOeordRow() {
	var originLen=0,repeatObj={},repeatFlag=0;
	yestVSList.map(function (y) {
		if (y.id) {
			originLen++;
			repeatObj[y.id]=1;
		}
	})
	var indexes=$('#oeordTable').datagrid('getEditingRowIndexs');
	var n=0,m=0,submitFlag=true;
	var data=[];
	var rows=$('#oeordTable').datagrid('getRows');
	for (var i = 0; i < indexes.length; i++) {
		var index=indexes[i];
		var rowEditors=$('#oeordTable').datagrid('getEditors',index);
		var row=rows[index];
		var id=row.id;
		var obsItm=$(rowEditors[0].target).combobox('getValue');
		var itmMast=$(rowEditors[1].target).combobox('getValue');
		var textVal=$(rowEditors[2].target).val();
		if (''==obsItm) {
			return $.messager.popover({msg: "��ѡ�������",type:'alert'});
		}
		if (''==itmMast) {
			return $.messager.popover({msg: "��ѡ��ҽ���",type:'alert'});
		}
		if (textVal.length<1) {
			return $.messager.popover({msg: "����д�ı�����¼��������",type:'alert'});
		}
		if (textVal.length>500) {
			return $.messager.popover({msg: "�ı��������Ȳ�����500��",type:'alert'});
		}
		data.push({
			id:id,
			obsItm:obsItm,
			itmMast:itmMast,
			textVal:textVal,
			hospDR:$HUI.combogrid('#_HospList').getValue(),
		});
	}
	if (data.length<1) {
		return $.messager.popover({msg: "û��Ҫ��������ã�",type:'alert'});
	}
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
		MethodName: 'AddOrUpdateObsRelateItmMast',
		dataType: "text",
		data:JSON.stringify(data)
		// data:JSON.stringify(gradeData)
	}, function(res) {
		console.log(res);
		if (0==res) {
			$.messager.popover({msg: "����ɹ���",type:'success'});
			getOeordTableData();
		}else{
			$.messager.popover({msg: res,type:'alert'});
		}
	});
}
function deleteOeordRow(id,i) {
	var yvsObj = $('#oeordTable');
	if (!id) {
		yvsObj.datagrid('deleteRow',i);
		return;
	}
	$.messager.confirm("ɾ��", "ȷ��Ҫɾ�����е�����?", function (r) {
		if (r) {
			var res=$cm({
				ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
				MethodName: 'DeleteObsRelateItmMast',
				dataType: "text",
				id:id
			}, false);
			console.log(res);
			if (0==res) {
				$.messager.popover({msg: 'ɾ���ɹ���',type:'success'});
				getOeordTableData();
			} else {
				$.messager.popover({msg: res,type:'alert'});
				return false
			}
		}
	});
}
function getOeordTableData() {
	// ��ȡ�Ż�������ϵͳ����
  $cm({
      ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
      QueryName: 'GetObsRelateItmMast',
      rows: 999999999999999,
      hospId: $HUI.combogrid('#_HospList').getValue(),
  }, function (data) {
	  // $('#oeordTable').datagrid({data: data.rows});
		$('#oeordTable').datagrid({
			loadMsg : '������..',  
			data:data.rows,
			height:500,
			onLoadSuccess:function(data){
				updateModalPos("relateItmMast");
				$("#oeordTableInfo").popover({
					trigger:'hover',
					content:"<p>"+$g('��������ֵͨ��ִ��ҽ���Զ����롣')+"</p>",
					style:'inverse',
					position:'right',
				});
			},
			onClickRow:function(index,row){
			}
		});
  });
}
function openRelateItmMastModal() {
	updateModalPos("relateItmMast");
	getOeordTableData()
}
function addYestVSRow() {
	var len=$('#yestVSTable').datagrid('getRows').length;
	var row={
		desc: "",
		yestDesc: "",
		id: ""
	}
	$('#yestVSTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", len);
  editYestVSRow(len,row)
}
function editYestVSRow(curInd,row) {
	$('#yestVSTable').datagrid('beginEdit', curInd);
  var rowEditors=$('#yestVSTable').datagrid('getEditors',curInd);
	$(rowEditors[0].target).combobox('loadData', vitalsignList);
	if (row.id) {
		$(rowEditors[0].target).combobox('setValue', row.id).combo('disable');
	}
}
function saveYestVSRow() {
	var originLen=0,repeatObj={},repeatFlag=0;
	yestVSList.map(function (y) {
		if (y.id) {
			originLen++;
			repeatObj[y.id]=1;
		}
	})
	var indexes=$('#yestVSTable').datagrid('getEditingRowIndexs');
	var n=0,m=0,submitFlag=true;
	var data=[];
	for (var i = 0; i < indexes.length; i++) {
		var index=indexes[i];
		var rowEditors=$('#yestVSTable').datagrid('getEditors',index);
		var id=$(rowEditors[0].target).combobox('getValue');
		if ((index>=originLen)&&repeatObj[id]) {
			return $.messager.popover({msg: "�������ظ���",type:'alert'});
		}else{
			repeatObj[id]=1;
		}
		var yestDesc=$(rowEditors[1].target).val();
		if (''===id) {
			submitFlag=false;
			return $.messager.popover({msg: "��ѡ�������",type:'alert'});
		}
		if (yestDesc.length<1) {
			submitFlag=false;
			return $.messager.popover({msg: "����д��������¼��������",type:'alert'});
		}
		if (yestDesc.length>50) {
			submitFlag=false;
			return $.messager.popover({msg: "��������¼���������Ȳ�����50��",type:'alert'});
		}
		data.push({id:id,yestDesc:yestDesc});
	}
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
		MethodName: 'UpdateYestDesc',
		// dataType: "text",
		data:JSON.stringify(data)
		// data:JSON.stringify(gradeData)
	}, function(res) {
		console.log(res);
		if (0==res) {
			$.messager.popover({msg: "����ɹ���",type:'success'});
			yestVSList.map(function (y,i) {
				if (!data.length) return;
				if (y.id==data[0].id) {
					yestVSList[i].yestDesc=data[0].yestDesc;
					data.shift();
				}
				if (!y.id) {
					yestVSList[i].id=data[0].id;
					yestVSList[i].desc=vitalsignObj[data[0].id];
					yestVSList[i].yestDesc=data[0].yestDesc;
					data.shift();
				}
			})
			$('#yestVSTable').datagrid({data: yestVSList});
		}else{
			$.messager.popover({msg: res,type:'alert'});
		}
	});
}
function deleteYestVSRow(id,i) {
	var yvsObj = $('#yestVSTable');
	if (!id) {
		yvsObj.datagrid('deleteRow',i);
		return;
	}
	$.messager.confirm("ɾ��", "ȷ��Ҫɾ�����е�����?", function (r) {
		if (r) {
			var data=[{id:id,yestDesc:''}];
			var res=$cm({
				ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
				MethodName: 'UpdateYestDesc',
				data:JSON.stringify(data)
			}, false);
			console.log(res);
			if (0==res) {
				$.messager.popover({msg: 'ɾ���ɹ���',type:'success'});
				yestVSList.map(function(elem,index) {
					if (id==elem.id) {
						yestVSList.splice(index,1);
						$('#yestVSTable').datagrid({data: yestVSList});
					}
				});
			} else {
				$.messager.popover({msg: res,type:'alert'});
				return false
			}
		}
	});
}
function openYestVSModal() {
	updateModalPos("yestVSModal");
	for (let i = 0; i < yestVSList.length; i++) {
		if (!yestVSList[i].id) {
			yestVSList.splice(i,1);
			i--;
		}
	}
	$('#yestVSTable').datagrid({
		loadMsg : '������..',  
		data:yestVSList,
		height:300,
		onLoadSuccess:function(data){
			updateModalPos("yestVSModal");
			$("#yestVSInfo").popover({
				trigger:'hover',
				content:"<p>"+$g('ͬʱ������д����������������¼�룬��ʾ����������¼��������')+"</p>",
				style:'inverse',
				position:'right',
			});
		},
		onClickRow:function(index,row){
		}
	});
}
function editTPRow(curInd,row) {
	if (5==curInd) {
		return $.messager.popover({msg: "���һ����ֹʱ����ֹ�༭��",type:'alert'});
	}
	$('#timePointTable').datagrid('beginEdit', curInd);
}
function saveTPTable() {
	var indexes=$('#timePointTable').datagrid('getEditingRowIndexs');
	var rows=$('#timePointTable').datagrid('getRows');
	var preTime="00:00";
	var data=[];
	for (var i = 0; i < 6; i++) {
		var curTime=rows[i].endPoint;
		if (i==indexes[0]) {
			var rowEditors=$('#timePointTable').datagrid('getEditors',i);
			curTime=$(rowEditors[0].target).timespinner('getValue');
			indexes.shift();
		}
		if (curTime<=preTime) {
			return $.messager.popover({msg: "�밴˳��������ȷ��ֹʱ�䣬��һ��ʱ�����00:00��",type:'alert'});
		}else{
			preTime=curTime;
			data.push(curTime);
		}
	}
	updateVSGenelConfig(data.join());
}
function openTPModal() {
	updateModalPos("timePointModal");
	setTimeout(function() {
		updateModalPos("timePointModal");
	}, 200);
}
$(function(){ 
	InitHospList();
	InitEvent();
});
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabVitalSign").datagrid("load");
	});
 	$("#searchName").keydown(searchNameOnKeyDown);
	$("#BSaveVSign").click(SaveVitalSign);
 	$("#BCancel").click(function(){
	 	$("#QLAssessEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_MRCObservationItem","",{width:220});
	hospComp.jdata.options.onSelect = function(e,t){
		$("#searchName").val("");
		$("#tabVitalSign").datagrid("load");
		InitQLAssessEditWin();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//��ʼ�����⡢���ҡ���Ӧ��ʽ��json����
	InitIsShowJson();
	InitTypeJson();
	InitFlagJson();
	InitStausJson();
	InitFormulaJson();
	InitStatus();
	//��ʼ�������������б�
	InitQLAssessListDataGrid();
	//��ʼ������/�޸ĵ���
	InitEditWindow();
	InitQLAssessEditWin();
	InitTip();
}
function InitTip(){
	$("#desc").popover({
		trigger:'hover',
		content:"<p>"+$g('������Ŀ���ƣ���ʽ����Ŀ���ƣ���λ��')+"</p>",
		style:'inverse'
	});
	$("#observStatusDR").popover({
		trigger:'hover',
		content:"<p>"+$g('���������༭ҳ����Ŀ���򣬶��������ɼ�ҳ������������ѡ����')+"</p>",
		style:'inverse'
	});
	$("#rangeFrom").popover({
		trigger:'hover',
		content:"<p>"+$g('����ʼֵ����Ϊ����ֵ')+"</p>",
		style:'inverse'
	});
	$("#rangeTo").popover({
		trigger:'hover',
		content:"<p>"+$g('�ܽ�ֵֹ����Ϊ����ֵ')+"</p>",
		style:'inverse'
	});
	$("#alertRangeFrom").popover({
		trigger:'hover',
		content:"<p>"+$g('�ܵ�ֵ����ֵ����Ϊ����ֵ')+"</p>",
		style:'inverse'
	});
	$("#alertRangeTo").popover({
		trigger:'hover',
		content:"<p>"+$g('�ݸ�ֵ����ֵ����Ϊ����ֵ')+"</p>",
		style:'inverse'
	});
}
function InitIsShowJson(){
	var newData=[
		// {"value":"", "text":$g('����ʾ')},
		{"value":"S", "text":$g('��ʾ')},
		{"value":"R", "text":$g('����')}
	];
	PageLogicObj.m_IsShowJson=newData;
}
function InitTypeJson(){
	var newData=[
		{"value":"B", "text":$g('Ѫ��')},
		{"value":"I", "text":$g('����')},
		{"value":"O", "text":$g('����')},
		{"value":"N", "text":$g('�ǳ�����')},
		{"value":"T", "text":$g('����')}
	];
	PageLogicObj.m_TypeJson=newData;
}
function InitFlagJson(){
	var newData=[
		// {"value":"", "text":$g('��')},
		{"value":"0", "text":$g('����')},
		{"value":"1", "text":$g('Ӥ��')}
	];
	PageLogicObj.m_FlagJson=newData;
}
function InitStausJson(){
	var newData=[
		{"value":"Y", "text":$g('����')},
		{"value":"N", "text":$g('ͣ��')}
	];
	PageLogicObj.m_StausJson=newData;
}
function InitFormulaJson(){
	var newData=[
		// {"value":"", "text":$g('��')},
		{"value":"1", "text":"1"},
		{"value":"2", "text":"2"},
		{"value":"6", "text":"6"}
	];
	PageLogicObj.m_FormulaJson=newData;
}
function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		data:[
			{"id":"Y","text":$g('����')},
			{"id":"N","text":$g('ͣ��')}
		]
	});
}
function InitQLAssessListDataGrid(){
	var ToolBar = [{
    text: $g('����'),
    iconCls: 'icon-add',
    handler: function() {
			PageLogicObj.m_selRowId="";        
      $("#QLAssessEditWin").window('open');
			$("#code").attr('disabled',false);
			$("#observStatusDR").val(PageLogicObj.lastNum);
			$("#StartDate").datebox('setValue',ServerObj.CurrentDate);
      $("#DataSource").next('span').find('input').focus();
		  $HUI.window('#QLAssessEditWin').setTitle($g('��������������'));
			$('#status').combobox("setValue","Y");
    }
  },{
    text: $g('�޸�'),
    iconCls: 'icon-write-order',
    handler: function() {
      var selected = $("#tabVitalSign").datagrid("getSelected");
			if (!selected) {
				$.messager.alert($g('��ʾ'),$g('��ѡ����Ҫ�޸ĵļ�¼��'));
				return false;
			}
			SetVitalSignRowData(selected);
			$("#QLAssessEditWin").window('open');
			$("#DataSource").next('span').find('input').focus();
		  $HUI.window('#QLAssessEditWin').setTitle($g('�޸�����������'));
    }
  },{
    text: $g('ɾ��'),
    iconCls: 'icon-cancel',
    handler: function() {
      var selected = $("#tabVitalSign").datagrid("getSelected");
			if (!selected) {
				$.messager.alert($g('��ʾ'),$g('��ѡ��Ҫɾ���������'));
				return false;
			}
			$.messager.confirm($g('ȷ�϶Ի���'), $g('ȷ��Ҫɾ������������'), function(r){
				if (r) {
					$.messager.prompt($g('��ʾ'), $g('���������룺'), function (r1) {
						if (r1) {
							console.log(r1);
							$.m({
								ClassName:"Nur.NIS.Service.VitalSign.MRCObservationItem",
								MethodName:"VerifyDelPwd",
								p:r1
							},function(res) {
								if (1==res) {
									var rowId=selected.rowid;
									if (rowId) {
										var rtn=$.m({
											ClassName:"Nur.NIS.Service.VitalSign.MRCObservationItem",
											MethodName:"DeleteSignItem",
											id:rowId
										},false)
										if (rtn !=0) {
											$.messager.popover({msg:rtn,type:'error'});
											return false;
										}else{
											$.messager.popover({msg:$g('ɾ���ɹ���'),type:'success'});
										}
										$('#tabVitalSign').datagrid('reload');
									}
								} else {
									$.messager.popover({msg:$g('�������'),type:'error'});
								}
							})
						}
					});
				}
			});
	  }
  // },{
  //   text: '����',
		// iconCls: 'icon-copy',
		// handler: function(){
		// 	var selected = $("#tabVitalSign").datagrid("getSelected");
		// 	if (!selected) {
		// 		$.messager.popover({msg:'��ѡ����Ҫ���Ƶļ�¼��',type:'error'});
		// 		return false;
		// 	}
		// 	SetVitalSignRowData(selected);	
		// 	PageLogicObj.m_selRowId="";
		// 	$("#QLAssessEditWin").window('open');
		// 	$("#DataSource").next('span').find('input').focus();
		// }
	}];
	var frozenColumns=[[  
	  {title: "RowId", width: 60, field: "rowid"},
	  {title: $g('���������'), width: 120, field: "code"},
	  {title: $g('����������'), field: "desc", width: 120 }
  ]];
	var Columns=[[  
	  {title: $g('��д')+'<a href="#" id="abbrCodetip" class="hisui-linkbutton" data-options="iconCls:\'icon-help\',plain:true"></a>', field: "abbrCode", width: 70 },
	  {title: $g('����ֵ��ʼ��Χ'), field: "rangeFrom", width: 120 },
	  {title: $g('����ֵ��ֹ��Χ'), field: "rangeTo", width: 120 },
	  {title: $g('����ֵ��ֵ����'), field: "alertRangeFrom", width: 120 },
	  {title: $g('����ֵ��ֵ����'), field: "alertRangeTo", width: 120 },
	  {title: $g('����ֵ'), field: "values", width: 300,formatter: function(value,row,index){
			return row.valuesDesc;
		}},
	  {title: $g('˳���'), field: "observStatusDR", width: 64 },
	  {title: $g('�Ƿ�հ���'), field: "confirmation", width: 92 },
	  {title: $g('¼��Ƶ��/��'), field: "formula", width: 100 },
	  {title: $g('�������'), field: "specialSign", width: 120,formatter: function(value,row,index){
			return row.specialSignDesc;
		}},
	  {title: $g('����Ӥ����־'), field: "flag", width: 106 },
	  {title: $g('�ִ�ʱ�Ƿ���ʾ'), field: "isShow", width: 120 },
	  {title: $g('����'), field: "type", width: 120 },
	  {title: $g('״̬'), field: "status", width: 50,
			formatter: function(value,row,index){
				if ($g('����')==value) {
					return '<span style="color: green;">'+$g("����")+'</span>'
				} else {
					return '<span style="color: red;">'+value+'</span>'
				}
			}
		}
  ]];
	$('#tabVitalSign').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('������..'),  
		pagination : false, 
		// rownumbers : true,
		idField:"rowid",
		// pageSize: 1500,
		// pageList : [15,50,100,200],
		frozenColumns :frozenColumns,
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.VitalSign.MRCObservationItem&QueryName=FindALLSignItem&rows=9999",
		onBeforeLoad:function(param){
			PageLogicObj.m_selRowId="";
			$('#tabVitalSign').datagrid("unselectAll");
			var filterType=$("#filterType").combobox('getValues');
			console.log(filterType);
			filterType=filterType.join('');
			param = $.extend(param,{
				itemDesc:$("#searchName").val(),
				signType:filterType,
				HospitalID:$HUI.combogrid('#_HospList').getValue()
			});
		},
		onLoadSuccess:function(data){
			var rows=data.rows;
			if (rows.length) {
				PageLogicObj.lastNum=parseInt(rows[rows.length-1].observStatusDR)+1;
			} else {
				PageLogicObj.lastNum=1;
			}
			$("#abbrCodetip").linkbutton().popover({
				trigger:'hover',
				content:"<p>"+$g('���ڶ���������ʱ���¼��ģʽ')+"</p>",
				style:'inverse'
			});
			var filterType=$("#filterType").combobox('getValues');
			filterType=filterType.join('');
			if ((''==$("#searchName").val())&&(''==filterType)) {
				vitalsignList=[];
				yestVSList=[];
				data.rows.map(function (d) {
					if (d.yestDesc) {
						yestVSList.push({
							id:d.rowid,
							desc:d.desc,
							yestDesc:d.yestDesc,
						})
					}
					vitalsignObj[d.rowid]=d.desc;
					vitalsignList.push({
						id:d.rowid,
						desc:d.desc,
						yestDesc:d.yestDesc||'',
					})
				})
			}
		},
		onDblClickRow:function(index,row){
			SetVitalSignRowData(row);
			$("#QLAssessEditWin").window('open');
			$("#DataSource").next('span').find('input').focus();
		  $HUI.window('#QLAssessEditWin').setTitle($g('�޸�����������'));
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter})
}
function InitQLAssessEditWin(){
	loadBasicDict();
	docAdvicesObj = {};
	// �ִ�ʱ�Ƿ���ʾ
	InitIsShow();
	// ����
	InitType();
	// ����Ӥ����־
	InitFlag();
	InitStaus();
	InitFormula();
	$HUI.combobox("#timePoint",{
		valueField:'value',
		textField:'text',
		multiple:true,
		// panelHeight:'auto',
		data:[
			{value:"00:00",text:0},
			{value:"01:00",text:1},
			{value:"02:00",text:2},
			{value:"03:00",text:3},
			{value:"04:00",text:4},
			{value:"05:00",text:5},
			{value:"06:00",text:6},
			{value:"07:00",text:7},
			{value:"08:00",text:8},
			{value:"09:00",text:9},
			{value:"10:00",text:10},
			{value:"11:00",text:11},
			{value:"12:00",text:12},
			{value:"13:00",text:13},
			{value:"14:00",text:14},
			{value:"15:00",text:15},
			{value:"16:00",text:16},
			{value:"17:00",text:17},
			{value:"18:00",text:18},
			{value:"19:00",text:19},
			{value:"20:00",text:20},
			{value:"21:00",text:21},
			{value:"22:00",text:22},
			{value:"23:00",text:23},
		],
		defaultFilter:4,
		onSelect:updateVSGenelConfig
	});
	getVSGenelConfig();
}
// ��ȡѪ��ͨ������
function getVSGenelConfig() {
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
    MethodName: 'getVSGenelConfig',
    hospDR: $HUI.combogrid('#_HospList').getValue()
  }, function (data) {
  	$("#switch").switchbox('setValue',(data.modify&&(parseInt(data.modify)))?true:false);
  	$("#qcSwitch").switchbox('setValue',(data.QC&&(parseInt(data.QC)))?true:false);
		var timePoints=data.timePoint.split(",")
		var endPoints=data.endPoint.split(",")
		$('#timePoint').combobox('setValues',timePoints);
		var tableData=[];
		for (var i = 0; i < 6; i++) {
			tableData.push({
				timePoint:timePoints[i],
				endPoint:endPoints[i]
			});
		}


	  $('#timePointTable').datagrid({data: tableData});
		console.log($('td[field="endPoint"]>div #endTimeTip').length);
		if ($('td[field="endPoint"]>div #endTimeTip').length<1) {
			$('td[field="endPoint"]>div').append('<a href="#" id="endTimeTip" class="hisui-linkbutton" data-options="iconCls:\'icon-help\',plain:true"></a>')
			$("#endTimeTip").linkbutton().popover({
				trigger:'hover',
				content:"<p>"+$g('��������¼��Ĭ��������ʾ���ã���ֹʱ�䷶Χ����ʾ��Ӧ���㡣')+"</p>",
				style:'inverse'
			});
		}
  });
}
// ����Ѫ��ͨ������
function updateVSGenelConfig(endPoint) {
	var timePoints=$('#timePoint').combobox('getValues');
	if (timePoints.length<6) return;
	while(timePoints.length>6) {
		var time=timePoints.shift();
		$('#timePoint').combobox('unselect',time);
	}
	timePoints=timePoints.sort();
  var modify=$("#switch").switchbox('getValue')?1:0;
  var qcSwitch=$("#qcSwitch").switchbox('getValue')?1:0;
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.MRCObservationItem',
    MethodName: 'updateVSGenelConfig',
    hospDR: $HUI.combogrid('#_HospList').getValue(),
    modify: modify,
    QC: qcSwitch,
    timePoint: timePoints.join(),
    endPoint: "string"==typeof endPoint?endPoint:""
  }, function (data) {
  	if (0==data) {
			$.messager.popover({msg:$g('����ɹ���'),type:'success'});
			getVSGenelConfig();
  	} else {
			$.messager.alert($g('��ʾ'),$g('����ʧ�ܣ�') , "info");
  	}
  });
}
function InitIsShow(){
	$('#isShow').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		panelHeight: "auto",
		// editable:false,
		data:PageLogicObj.m_IsShowJson
	});
}
function InitType(){
	$('#filterType').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		panelHeight: "auto",
		editable:false,
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:PageLogicObj.m_TypeJson,
		onSelect:function(rec){
			$("#tabVitalSign").datagrid("load");
		},
		onUnselect:function(rec){
			$("#tabVitalSign").datagrid("load");
		}
	});
	$('#type').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		panelHeight: "auto",
		editable:false,
		data:PageLogicObj.m_TypeJson
	});
}
function InitFlag(){
	$('#flag').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		panelHeight: "auto",
		// editable:false,
		data:PageLogicObj.m_FlagJson
	});
}
function InitStaus(){
	$('#status').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		panelHeight: "auto",
		editable:false,
		data:PageLogicObj.m_StausJson
	});
}
function InitFormula(){
	$('#formula').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		panelHeight: "auto",
		// editable:false,
		data:PageLogicObj.m_FormulaJson
	});
}
function InitEditWindow(){
    $("#QLAssessEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   ClearVitalsignModal();
	   }
	});
}
function SaveVitalSign(){
	var code=$("#code").val();
	if (!code) {
		$.messager.popover({msg:$g('��������������룡'),type:'error'});
		$("#code").focus();
		return false;
	}
	var desc=$("#desc").val();
	if (!desc) {
		$.messager.popover({msg:$g('������������������'),type:'error'});
		$("#desc").focus();
		return false;
	}
	var observStatusDR=$("#observStatusDR").val();
	if (!observStatusDR) {
		$.messager.popover({msg:$g('������˳��ţ�'),type:'error'});
		$("#observStatusDR").focus();
		return false;
	}
	var type=$('#type').combobox("getValue");
	if (!type) {
		$.messager.popover({msg:$g('��ѡ�����ͣ�'),type:'error'});
		$("#type").next('span').find('input').focus();
		return false;
	}
	var formulaControl=$("#formulaControl").checkbox("getValue")?'Y':'N';
	var formula=$('#formula').combobox("getValue");
	if (('Y'==formulaControl)&&!formula) {
		$.messager.popover({msg:$g('��ѡ��¼��Ƶ��/�죡'),type:'error'});
		return false;
	}
	var titleLastWeek=$("#titleLastWeek").checkbox("getValue")?'Y':'N';
	var colWidth=$("#colWidth").val();
	if (colWidth&&(!colWidth.match(/^[1-9]\d{0,2}$/)||(colWidth<50)||(colWidth>300))) {
		$.messager.popover({msg:$g('���������п�������50��300����������'),type:'error'});
		$("#colWidth").focus();
		return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.VitalSign.MRCObservationItem",
		MethodName:"AddSignItem",
		RowId:PageLogicObj.m_selRowId,
		Code:code,
		Desc:desc,
		AbbrCode:$("#abbrCode").val(),
		ObservStatusDR:observStatusDR,
		ColWidth:colWidth,
		RangeFrom:$("#rangeFrom").val(),
		RangeTo:$("#rangeTo").val(),
		AlertRangeFrom:$("#alertRangeFrom").val(),
		AlertRangeTo:$("#alertRangeTo").val(),
		Values:$("#values").combobox("getValue"),
		Confirmation:$("#confirmation").checkbox("getValue")?'Y':'N',
		UDFlag:$("#udFlag").checkbox("getValue")?'Y':'N',
		FormulaControl:formulaControl,
		TitleLastWeek:titleLastWeek,
		Formula:formula,
		ITMGraphColor:$("#specialSign").combobox("getValue"),
		babyFlag:$('#flag').combobox("getValue"),
		isFirstShow:$('#isShow').combobox("getValue"),
		colour:"",
		character:"",
		smell:"",
		signType:type,
		valid:$('#status').combobox("getValue"),
		HospitalID: $HUI.combogrid('#_HospList').getValue()
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:$g('����ɹ���'),type:'success'});
			$("#QLAssessEditWin").window('close');
			$("#tabVitalSign").datagrid("reload");
		} else {
			$.messager.alert($g('��ʾ'),$g('����ʧ�ܣ�')+ rtn , "info");
			return false;
		}
	})
}
function SetVitalSignRowData(row){
	$("#code").val(row.code).attr('disabled',true);
	$("#desc").val(row.desc);
	$("#abbrCode").val(row.abbrCode);
	$("#observStatusDR").val(row.observStatusDR);
	$("#colWidth").val(row.colWidth);
	var typeObj={};
	typeObj[$g('Ѫ��')]="B";
	typeObj[$g('����')]="I";
	typeObj[$g('����')]="O";
	typeObj[$g('�ǳ�����')]="N";
	typeObj[$g('����')]="T";
	$('#type').combobox("setValue",typeObj[row.type]);
	$("#rangeFrom").val(row.rangeFrom)
	$("#rangeTo").val(row.rangeTo)
	$("#alertRangeFrom").val(row.alertRangeFrom)
	$("#alertRangeTo").val(row.alertRangeTo)
	$("#values").combobox("setValue",row.values)
	$("#confirmation").checkbox("setValue",'Y'==row.confirmation?true:false)
	$("#udFlag").checkbox("setValue",'Y'==row.udFlag?true:false)
	$("#formulaControl").checkbox("setValue",'Y'==row.formulaControl?true:false)
	$("#titleLastWeek").checkbox("setValue",'Y'==row.titleLastWeek?true:false)
	$('#formula').combobox("setValue",row.formula)
	var flagObj={};
	flagObj[$g('��')]="";
	flagObj[$g('����')]="0";
	flagObj[$g('Ӥ��')]="1";
	if (row.flag) $('#flag').combobox("setValue",flagObj[row.flag]);
	var isShowObj={};
	isShowObj[$g('����ʾ')]="";
	isShowObj[$g('��ʾ')]="S";
	isShowObj[$g('����')]="R";
	if (row.isShow) $('#isShow').combobox("setValue",isShowObj[row.isShow]);
	var statusObj={};
	statusObj[$g('����')]="Y";
	statusObj[$g('ͣ��')]="N";
	if (row.status) $('#status').combobox("setValue",statusObj[row.status]);
	var reg='/'+charCodeF+'/g'
	$("#specialSign").combobox("setValue",row.specialSign)
	PageLogicObj.m_selRowId=row.rowid;
}
function ClearVitalsignModal(){
	$("#code,#desc,#abbrCode,#observStatusDR,#colWidth,#rangeFrom,#rangeTo,#alertRangeFrom,#alertRangeTo").val("");
	$("#confirmation").checkbox("setValue",false);
	$("#udFlag").checkbox("setValue",false);
	$("#formulaControl").checkbox("setValue",false);
	$("#titleLastWeek").checkbox("setValue",false);
	$('#isShow,#type,#flag,#status,#formula,#values,#specialSign').combobox("clear");
}
function searchNameOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		$("#tabVitalSign").datagrid("load");
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	if(date2<date1){  
		return true;
	} 
	return false;
}
