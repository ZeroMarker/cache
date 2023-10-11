/**
 * FileName: insueprulmain.js
 * Anchor: Jiang
 * Date: 2021-03-15
 * Description: 患者结算清单查询
 */
var DateFlag=0
var PUBLIC_CONSTANT = {
	INFNO:'4101A',         // 请按照项目情况4101或4101A，修改此处全局变量。
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		CTLOC_ROWID: session['LOGON.CTLOCID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	}
}
var GV={
	print_invStyle:"",
	InfoFormatterStyle:""
   }
$(document).ready(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	var HospIdTdWidth=$("#HospIdTd").width() 
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row){
			initQueryMenu();
			loadChargeDtlList();
	        //setTimeout("loadChargeDtlList();",200)
		},
		onLoadSuccess: function(data){
			initQueryMenu();
	        initChargeDtlList();
		}
		});
	
});

function initQueryMenu() {

	if(HISUIStyleCode == "lite") {
		GV.print_invStyle="<p class='print_invlite' style='padding:0 24px' title='清单预览' "
		GV.InfoFormatterStyle="linkinfolite"
	}else{
		GV.print_invStyle="<img style='padding: 0 24px' title='清单预览' src='../scripts_lib/hisui-0.1.0/dist/css/icons/print_inv.png'"
		GV.InfoFormatterStyle="linkinfo"
	}

	$('#SDate, #EDate').datebox();
	
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadChargeDtlList();
		}
	});

	//登记号回车查询事件
	$('#PatNo').keydown(function (e) {
		patientNoKeyDown(e);
	});
	
	//病案号回车查询事件
	$('#MedNo').keydown(function (e) {
		MedicareNoKeyDown(e);
	});
	
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: '未上传',
				'selected':true
			}
			,{
				value: '3',
				text: '上传失败'
			}
			, {
				value: '2',
				text: '已上传'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {	
		   if((data.value=="2")||(data.value=="3")){
			  $('#DateFlag').combobox('select',4);
			}	
				
		}
	});

    

	///业务类型
	$HUI.combobox('#OptType', {
		panelHeight: 'auto',
		data: [{
				value: '',
				text: '全部',				
			},
		    {
				value: 'OP',
				text: '门诊',				
			},{
				value: 'IP',
				text: '住院',
				'selected':true
			}
		],
		valueField: 'value',
		textField: 'text',		
	});
	//DateFlag DateFlag 0不按日期，1入院日期，2出院日期，3财务日期，4上传日期，5 病案编目 ，4病历提交 
	$HUI.combobox('#DateFlag', {
		panelHeight: 'auto',
		data: [
		     {
				value: '5',
				text: '病案编目',
				'selected':true
			 },{
				value: '6',
				text: '病历提交'
			}, {
			    value: '3',
				text:'财务结算'
			},{
				value: '4',
				text: '上传日期',				
			}
		],
		valueField: 'value',
		textField: 'text'
	});
	
	//清单状态分类 0:未提交，1:已提交，2:审核通过，3:审核不通过
	$HUI.combobox('#StasType', {
		panelHeight: 'auto',
		data: [
		     {
				value: '0',
				text: '未提交',
				'selected':true
			 },{
				value: '1',
				text: '已提交'
			},{
				value: '2',
				text: '审核通过'
			},{
				value: '3',
				text: '审核不通过'
			}
		],
		valueField: 'value',
		textField: 'text'
	});

	/*$HUI.combobox('#InsuType', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCINSUEprUl&QueryName=ReadInsuType&ResultSetType=array',
		valueField: 'INDID_DicCode',
		textField: 'INDID_DicDesc',
		//defaultFilter: 4,
		editable:false,
		    onLoadSuccess: function(){
            $('#InsuType').combobox('select', "00A");
        }
	});*/
	
	var Options = {
		defaultFlag:'Y'	,
		hospDr:PUBLIC_CONSTANT.SESSION.HOSP_ROWID
	}
   INSULoadDicData('InsuType','TariType',Options); 	

   //参保类型  省本级，市医保和省异地 upt 2023/03/16 JinS1010
	INSULoadDicData("CenterType", 'center_type00A', Options);                    
   $('#InsuType').combobox({
	   onLoadSuccess: function(){
            $('#InsuType').combobox('select', "00A");
	   }
	   });
	
	$('#SDate').datebox('setValue', getDefStDate(-6));
	$('#EDate').datebox('setValue', getDefStDate(0));
	$("#btn-up").click(BUpClickHandle);
	$("#btn-del").click(BDelClickHandle);	
	
	//清单提交	+20230228 HanZH
	$("#btn-submit").click(BSubmitClickHandle);	
	//查询质控结果 +20230228 HanZH
	$("#btn-qltctrlFind").click(qltctrlQry);	
	//清单信息查询 +20230228 HanZH
	$("#btn-seltFind").click(EPRInfoQry);
	
	$("#info").select();
	$('#InfoWin').dialog({
		buttons:[{
			text:'关闭',
			handler:function(){
				$('#InfoWin').dialog('close');
			}
		},
		{
			text:'复制',
			handler: function(){
				//copyText($("#copyInfo").text());
				//upt HanZH 20220707
				var pre = document.getElementById("copyInfo")
				var text = pre.innerText;
				var input =$("<textarea></textarea>");
		    	input.text(text); // 修改文本框的内容
		    	input.appendTo(pre);
		    	input.select(); // 选中文本
		    	document.execCommand("copy"); // 执行浏览器复制命令
		    	input.remove();
		    	//$.messager.alert("提示", "复制成功!", 'info');
		    	$.messager.popover({
					msg: '复制成功：' ,
					type: 'info',
					timeout: 1000, 		//0不自动关闭。3000s
					showType: 'slide'  
				});
			}
		}]
		})	
}


function patientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: $(e.target).val()
		}, function (PatNo) {
			$(e.target).val(PatNo);
			loadChargeDtlList();
		});
	}
}

//病案号回车事件
function MedicareNoKeyDown(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		var MedNo = jQuery("#MedNo").val();
		loadChargeDtlList();
	}
}

function initChargeDtlList() {
	$HUI.datagrid('#mainDtlList', {
		fit: true,
		border: false,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		frozenColumns: [[{
					title: 'ck',
					field: 'ck',
					checkbox: true
				}
			]],
		columns: [[{
					title: '清单详情',
					field: 'ListDtl',
					align: 'center',
					//hidden:false,
					width: 80,
					formatter: function (value, row, index) {
						if(row.DivDr>0){
							//var Infno="4101"
							var Infno=PUBLIC_CONSTANT.INFNO;
							if(row.TOptType=="OP"){
								 //Infno="4101-OP";
								 Infno=PUBLIC_CONSTANT.INFNO+"-OP";
								}
							//var btnstr="<input type='button' value='打印预览' onclick=\"EprPrintDetail(\'" + row.DivDr +"','"+ row.Eid +"\')\"  class='easyui-linkbutton'  plain='true' style='width:60px;height:25px;font-size:14px'>";
							//var btnstr = "<a href='javascript:;' class='datagrid-cell-img' title='清单预览' style='padding:0 24px' onclick=\"EprPrintDetail(\'" + row.DivDr +"','"+row.AdmDr+"','"+ row.Eid +"','"+ row.TOptFlag+"','"+ index+"','"+ Infno +"\')\" ><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/print_inv.png'/></a>";
							//var btnstr=btnstr+"<input type='button' value='清单预览' onclick=\"EprDetail(\'" + row.DivDr + "\')\"  class='easyui-linkbutton'  plain='true' style='width:60px;height:25px;font-size:14px;margin-left:10px'>";
							//var btnstr=btnstr+"<input type='button' value='前清单' onclick=\"EprListDetail(\'" + row.DivDr + "\')\"  class='easyui-linkbutton'  plain='true' style='width:60px;height:25px;font-size:14px;margin-left:10px'>";
							var btnstr = GV.print_invStyle+"onclick=\"EprPrintDetail(\'" + row.DivDr +"','"+row.AdmDr+"','"+ row.Eid +"','"+ row.TOptFlag+"','"+ index+"','"+ Infno +"\')\" >";
						}
					 /*if(row.Eid>0){
							if(btnstr==""){
								var btnstr="<input type='button' value='后清单' onclick=\"ListDetail(\'" + row.Eid + "\')\" class='easyui-linkbutton'  plain='true' style='width:60px;height:25px;font-size:14px'>";
							}else{
								var btnstr=btnstr+"<input type='button' value='后清单' onclick=\"ListDetail(\'" + row.Eid + "\')\" class='easyui-linkbutton'  plain='true' style='width:60px;height:25px;font-size:14px;margin-left:10px'>";
							}
						}*/
						return btnstr ;
					}
				},{
					title: '变更详情',
					field: 'ChangeDtl',
					//align: 'center',
					hidden:true,
					width: 90,
					formatter: function (value, row, index) {
						btnstr="<input type='button' value='变更记录' onclick=\"Eprchangedtl(\'" + row.DivDr + "\')\"  class='easyui-linkbutton'  plain='true' style='width:70px;height:25px;font-size:14px'>";
						return btnstr						
					}
				},{
					title: '上传标志',
					field: 'TOptFlag',
					//align: 'center',
					width: 80,
					styler:UpFlagStyle
				}, {
					title: '分类状态',
					field: 'TStasTypeDesc',
					//align: 'center',
					width: 80,
					styler:StasTypeStyle
				},{
					title: '发票状态',
					field: 'TPrtActStus',
					//align: 'center',
					width: 80,
					styler: function(value,row,index){
				        var rtnStyle="";
					    switch (value)
					    { 
					      case "N" :
	    		                rtnStyle= 'color:red';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }		
					return rtnStyle
				},
				formatter: function(value,row,index){
				if (value == "Y"){
					return "有效";
				} else {
					return "无效";
				}
			   }
				},
				{
					title: '姓名',
					field: 'TPatName',
					//align: 'center',
					width: 80
				},{
					title: '登记号',
					field: 'TPatRegNo',
					//align: 'center',
					width: 100
				},  {
					title: '病案号',
					field: 'TMedcasNo',
					//align: 'center',
					width: 100
				}, {
					title: '住院科室',
					field: 'TDepDesc',
					//align: 'center',
					width: 120
				}, {
					title: '入院日期',
					field: 'TAdmDate',
					//align: 'center',
					width: 100
				}, {
					title: '出院日期',
					field: 'TOutDate',
					//align: 'center',
					width: 100
				}, {
					title: '结算日期',
					field: 'TDisDate',
					//align: 'center',
					width: 100
				},
				{
					title: '病案编目日期',
					field: 'TIPMRDate',
					//align: 'center',
					width: 110
				},
				{
					title: '病历提交日期',
					field: 'TEMRDate',
					//align: 'center',
					width: 110
				},
				{
				   field:'InptPara',
				   title:'入参',
				   width:50,
				   formatter:setInputInfoFormatter  //DingSH 20211121
				 },
			    {
				    field:'OutPara',
			        title:'出参',
			        width:50,
			         formatter:setResponseInfoFormatter
			    }
				
				, {
					title: '医保卡号',
					field: 'TInsuNo',
					//align: 'center',
					width: 120
				}, {
					title: '医保登记id',
					field: 'TInsuZylsh',
					//align: 'center',
					width: 160
				}, {
					title: '医保结算id',
					field: 'TInsuDjlsh',
					//align: 'center',
					width: 160
				}, {
					title: '上传人员',
					field: 'TOpter',
					//align: 'center',
					width: 100
				}, {
					title: '上传日期',
					field: 'TOptDate',
					//align: 'center',
					width: 150
				}, {
					title: '医保清单号',
					field: 'TListId',
					//align: 'center',
					width: 100
				}, {
					title: 'Rowid',
					field: 'Eid',
					//align: 'center',
					width: 60
				}, {
					title: 'AdmDr',
					field: 'AdmDr',
					align: 'center',
					width: 60
				}, {
					title: 'DivDr',
					field: 'DivDr',
					//align: 'center', 
					width: 60
				}, {
					title: '医保状态',
					field: 'DivFlag',
					//align: 'center',
					width: 80
				}
				, {
					title: 'TPrtDr',
					field: 'TPrtDr',
					width: 80
				}
				,{
					title: 'TOptType',
					field: 'TOptType',
					hidden:true,
					width: 60
				}
			]],
			onLoadSuccess: function(){
			    $(".datagrid-cell-img").tooltip();
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
				//$("a[name='view']").linkbutton({});
			},
			onSelect : function(rowIndex, rowData) {
				if(rowData.TStasType=="0"){
					$('#btn-del').linkbutton('disable');
					var obj=$('#btn-submit').linkbutton("options")
					if (obj.disabled==true){$('#btn-submit').linkbutton('enable');}
			 	}
			   	if(rowData.TStasType=="1"){
					$('#btn-submit').linkbutton('disable');
					var obj=$('#btn-del').linkbutton("options")
					if (obj.disabled==true){$('#btn-del').linkbutton('enable');}
				}
				if(rowData.TStasType=="2"){
					$('#btn-submit').linkbutton('disable');
					$('#btn-del').linkbutton('disable');
			 	}
				if(rowData.TStasType=="3"){
					var obj=$('#btn-submit').linkbutton("options")
					if (obj.disabled==true){$('#btn-submit').linkbutton('enable');}
					var obj=$('#btn-del').linkbutton("options")
					if (obj.disabled==true){$('#btn-del').linkbutton('enable');}
			 	}
			}
	});
}
function setInputInfoFormatter(value,row,index){
	 var Eid=row.Eid||"";
	 //var Infno="4101";
	 var Infno=PUBLIC_CONSTANT.INFNO;
	 if (row.TOptType =="OP"){
		 //Infno="4101-OP";
		 Infno=PUBLIC_CONSTANT+"-OP";
		 }
	 var nfhml="<span class="+GV.InfoFormatterStyle+" onclick='showInputJson("+row.DivDr+","+row.AdmDr+","+"\""+Eid+"\""+","+"\""+row.TOptFlag+"\""+","+"\""+index+"\""+","+"\""+Infno+"\""+")'>详情</span>";
	return nfhml;
}
		    
function setResponseInfoFormatter(value,row,index)
{
    var Eid=row.Eid||"";
	var nfhml="<span class="+GV.InfoFormatterStyle+" onclick='showResponseJson("+row.DivDr+","+row.AdmDr+","+"\""+Eid+"\""+","+"\""+row.TOptFlag+"\""+")'>详情</span>";
	return nfhml;
}
function showInputJson(InDivDr,AdmDr,EId,UpFag,index,Infno){
	$("#info").html("");
     
     var ckval=false;
     if((index)&&($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked'))){
	     ckval=true;
	     }
	if((UpFag=="上传成功")||(((UpFag=="上传失败"))&&(!ckval)))
	{
		var options={
		ClassName:"web.DHCINSUEprUl",
		MethodName:"GetErpiInargInfo",
		DivDr: InDivDr,
		UploadId: EId,
	   }
	}
	else
	{
	var InputInfo="00A^"+Infno+"^"+PUBLIC_CONSTANT.SESSION.HOSP_ROWID+"^"+PUBLIC_CONSTANT.SESSION.GUSER_ROWID+"^0^^1^"+AdmDr+"^"+InDivDr; //医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID
	var InArgType="STR"; //入参类型(JSON、STR)
	var OutArgType="JSON"     //出参格式(JSON,XML,STR)
	var options={
		ClassName:"INSU.OFFBIZ.BL.BIZ00A",
		MethodName:"InsuSettlementUL",
		InputInfo: InputInfo,
		InArgType: InArgType,
		OutArgType:OutArgType
		
	 }
	}
	var ret=$m(options,false);
	try{
		ret=JSON.stringify(JSON.parse(ret), null, 4);
	}catch(ex){}
	$("#info").html("<pre id='copyInfo'>"+ret+"</pre>");
	$('#InfoWin').dialog("setTitle",PUBLIC_CONSTANT.INFNO+"-交易入参");
	$('#InfoWin').dialog("open");
}			
function showResponseJson(InDivDr,AdmDr,EId,UpFag){
	$("#info").html("");
	var options={
		ClassName:"web.DHCINSUEprUl",
		MethodName:"GetErpiOutargInfo",
		DivDr: InDivDr,
		UploadId: EId,
	   }
	var ret=$m(options,false);
	try{
		ret=JSON.stringify(JSON.parse(ret), null, 4);
	}catch(ex){}
	$("#info").html("<pre id='copyInfo'>"+ret+"</pre>");
	$('#InfoWin').dialog("setTitle",PUBLIC_CONSTANT.INFNO+"-交易出参");
	$('#InfoWin').dialog("open");
}
function UpFlagStyle(value,row,index){
	if (value=="上传失败") return "color:red;";
	if (value=="上传成功") return "color:green;";
}

function StasTypeStyle(value,row,index){
	if (value=="未提交") return "color:blue;";
	if (value=="已提交") return "color:green;";
	if (value=="审核通过") return "color:green;";
	if (value=="审核不通过") return "color:red;";
}
function loadChargeDtlList() {
	$("#mainDtlList").datagrid('loadData',{total:0,rows:[]});
	var stDate = $('#SDate').datebox('getValue');
	var endDate = $('#EDate').datebox('getValue');
    var UpFlag=$('#UpFlag').combobox('getValue')

	var queryParams = {
		ClassName: 'web.DHCINSUEprUl',
		QueryName: 'QueryPat',
		MedNo: $('#MedNo').val(),
		PatNo: $('#PatNo').val(),
		Zylsh: $('#Zylsh').val(),
		Djlsh: $('#Djlsh').val(),
		SDate: stDate,
		EDate: endDate,
		PatType: "", /// $('#PatType').combobox('getValue') || '',
		UpFlag: $('#UpFlag').combobox('getValue') || '',		
		InsuType: $('#InsuType').combobox('getValue') || '', 
		HospId: PUBLIC_CONSTANT.SESSION.HOSP_ROWID,
		OptType: $('#OptType').combobox('getValue') || '',
		DateFlag: $('#DateFlag').combobox('getValue') || '',
		CenterType:  $('#CenterType').combobox('getValue') || '',
		StasType: $('#StasType').combobox('getValue') || ''
	};
	loadDataGridStore('mainDtlList', queryParams);
}
///后清单，上传医保的清单数据
function ListDetail(RowId) {
	websys_showModal({
		url: 'insuepruldtl.csp?Rowid='+RowId+"&Flag=A",
		title: '医疗保障基金结算清单信息',
		iconCls: 'icon-w-list'
	});
	/*var lnk="insuepruldtl.csp?Rowid="+RowId
	window.open(lnk,"医疗保障基金结算清单信息","height=800,width=1600,top=20,left=30,scrollbars=yes,resizeable=yes")
	*/	
}

function Eprchangedtl(RowId){
	websys_showModal({
		url: 'insueprchangedtl.csp?Rowid='+RowId,
		title: '变更记录',
		iconCls: 'icon-w-list',
		height:600,
		width:930
	});			
}
///前清单，上传医保的清单数据
function EprListDetail(RowId){
	websys_showModal({
		url: 'insuepruldtl.csp?Rowid='+RowId+"&Flag=B",
		title: '医疗保障基金结算清单信息',
		iconCls: 'icon-w-list'
	});		
}
///清单预览
function EprDetail(RowId){
	websys_showModal({
		url: 'insueprdtl.csp?Rowid='+RowId+"&Flag=B",
		title: '医疗保障基金结算清单信息',
		iconCls: 'icon-w-list',
		height:700,
		width:1100
	});		
}
///打印预览
/*
function EprPrintDetail(RowId){
	websys_showModal({
		url: 'insueprulprintdtl.csp?Rowid='+RowId+"&Flag=B",
		title: '医疗保障基金结算清单信息',
		iconCls: 'icon-w-list',
		height:700,
		width:1100
	});		
}
*/
function EprPrintDetail(InDivDr,AdmDr,EId,UpFag,index,Infno){
		/*websys_showModal({
		url: 'insuepruldtlprint.csp?Rowid='+RowId+"&Flag=B&EId="+EId,
		title: '医疗保障基金结算清单信息',
		iconCls: 'icon-w-list',
		height:700,
		width:1100
	});	*/
	var CkVal=false;
    var InputInfo=""     //医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID
	var InArgType="";     //入参类型(JSON、STR)
	var OutArgType=""     //出参格式(JSON,XML,STR)
    if((index)&&($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked'))){
	     CkVal=true;
	     }
	if(!((UpFag=="上传成功")||(((UpFag=="上传失败"))&&(!CkVal))))
	{
	 var InputInfo="00A^"+Infno+"^"+PUBLIC_CONSTANT.SESSION.HOSP_ROWID+"^"+PUBLIC_CONSTANT.SESSION.GUSER_ROWID+"^0^^1^"+AdmDr+"^"+InDivDr; //医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID
	 var InArgType="STR";       //入参类型(JSON、STR)
	 var OutArgType="JSON"     //出参格式(JSON,XML,STR)
	}
	websys_showModal({
		url: 'dhcinsu.hibill.csp?InDivDr='+InDivDr+"&AdmDr="+AdmDr+"&EId="+EId+"&UpFag="+encodeURIComponent(UpFag)+"&CkVal="+CkVal+"&Infno="+Infno+"&InputInfo="+InputInfo+"&InArgType="+InArgType+"&OutArgType="+OutArgType,
		//url: 'insuepruldtlprint.csp?Rowid='+RowId+"&Flag=B&EId="+EId,
		title: '医疗保障基金结算清单信息',
		iconCls: 'icon-w-list',
		height:700,
		width:980
	});		
}
function BUpClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	var unpmstr=""  //未编目
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if (Flag==1){
			///上传接口
			//alert("xuyao写上传接口")
			//var Infno="4101";
			var Infno=PUBLIC_CONSTANT.INFNO
			if(myRows[i].TIPMRDate==""){
				    //记录未编目条数
				    if (unpmstr ==""){
					     unpmstr=myRows[i].TMedcasNo
				     }else{
					     unpmstr=unpmstr+"/"+myRows[i].TMedcasNo
					 }
				}
			else{
				if(myRows[i].TOptType=="OP"){
					 //Infno="4101-OP";
					 Infno=PUBLIC_CONSTANT.INFNO+"-OP";
					}
				InsuEPRInfoUL(0,session['LOGON.USERID'],myRows[i].AdmDr,myRows[i].DivDr,Infno,"","00A^^^^");
			}
			
		}				
	}
	if(unpmstr!="")
	  {
		$.messager.alert("温馨提示","病案号为:"+unpmstr+"的清单未编目，请先编目。","info",function(){loadChargeDtlList()})
		return;
	 }
	loadChargeDtlList();	
}

function BDelClickHandle()
{
	// var myRows = $("#mainDtlList").datagrid('getRows');
	// var outstr="",Flag="", n=1 ,UploadIdStr="",UploadId=""
	// for(var i=0;i<myRows.length;i++){
	// 	if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
	// 	else Flag=0;
	// 	if (Flag==1){
	// 		///撤销接口
	// 		//alert("医保暂不支持撤销！")
	// 		if(UploadIdStr==""){
	// 			UploadIdStr=myRows[i].Eid
	// 		}else{
	// 			UploadIdStr=UploadIdStr+"$"+myRows[i].Eid
	// 		}
	// 	}
	// 	InsuEPRStasModi(UploadIdStr,"0");	
	// }
	var obj=$('#btn-del').linkbutton("options")
	if (obj.disabled==true){return reject();}
	var UploadId=""	
	var myRows = $("#mainDtlList").datagrid('getRows');
	var Flag="";
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if (Flag==1) {
			///撤销接口
			if(myRows[i].StasType=="2"){
				$.messager.alert('温馨提示', '审核通过记录不可撤销！');
				return;
			}
			if(UploadId==""){
				UploadId=myRows[i].Eid
			}else{
				$.messager.alert('温馨提示', '每次撤销只能选择一条记录！');
				return;
			}
		}				
	}
	if(UploadId==""){
		$.messager.alert("温馨提示","请选择一条清单记录!")	
		return;
	}
	InsuEPRStasModi(UploadId,"0^N");
}

//清单提交	+20230228 HanZH
function BSubmitClickHandle(){
	var obj=$('#btn-submit').linkbutton("options")
	if (obj.disabled==true){return reject();}

	var myRows = $("#mainDtlList").datagrid('getRows');
	var Flag="";
	var UploadIdStr=""	//结算单RowiD串
	// if(myRows.length==0){
	// 	$.messager.alert("温馨提示","请选择一条清单记录!")	
	// 	return;
	// }
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if ((Flag==1) && (myRows[i].TStasType!="1")&& (myRows[i].TStasType!="2")) {
			///撤销接口
			//alert("医保暂不支持撤销！")
			if(UploadIdStr==""){
				UploadIdStr=myRows[i].Eid
			}else{
				UploadIdStr=UploadIdStr+"$"+myRows[i].Eid
			}
		}				
	}
	if(UploadIdStr==""){
		$.messager.alert("温馨提示","请选择一条可提交清单记录!")	
		return;
	}
	InsuEPRStasModi(UploadIdStr,"1^Y");
}

//医疗保障基金结算清单信息状态修改	+20230228 HanZH
function InsuEPRStasModi(UploadIdStr,StasTypeStr)
{
	var rtnStr = "";
	var rtnStr= InsuEPRInfoULStasModi(0,session['LOGON.USERID'],UploadIdStr,"00A^"+StasTypeStr);
	if((rtnStr=="-1")||(rtnStr=="")){
		$.messager.alert("温馨提示","清单分类状态变更失败!")
	}else{
		$.messager.alert("温馨提示","清单分类状态变更成功!总条数："+rtnStr.split("^")[0]+",成功条数："+rtnStr.split("^")[1]+",失败条数："+rtnStr.split("^")[2])	
	}
	loadChargeDtlList();
}

//质控结果查询	+20230302 HanZH
function qltctrlQry()
{
	var selectedRow = $('#mainDtlList').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('提示', '请选择一条记录！');
		return;
	}
	var SetlYm="",PsnNo="",ErrLv="",RetnFlag="",PageNum="1",PageSize="10"
	if (selectedRow.TOptDate==""){
		$.messager.alert("温馨提示","该记录没有上传日期，请核实是否为已上传的清单!")	
		return;
	}
	SetlYm=selectedRow.TOptDate.split("-")[0]+selectedRow.TOptDate.split("-")[1]		//结算年月
	SetlId=selectedRow.TInsuDjlsh		//结算ID
	websys_showModal({
		url: 'dhcinsu.qltctrlrsltqry.csp?SetlYm='+SetlYm+"&SetlId="+SetlId+"&PsnNo="+PsnNo+"&ErrLv="+ErrLv+"&RetnFlag="+RetnFlag+"&PageNum="+PageNum+"&PageSize="+PageSize,
		title: '质控结果明细',
		iconCls: 'icon-w-list',
		height:700,
		width:1400
	});	
}

//清单信息查询	+20230302 HanZH
function EPRInfoQry()
{
	var selectedRow = $('#mainDtlList').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('提示', '请选择一条记录！');
		return;
	}
	if (selectedRow.TOptDate==""){
		$.messager.alert("温馨提示","该记录没有上传日期，请核实是否为已上传的清单!")	
		return;
	}
	var rtnStr = "";
	var rtnStr= InsuEPRInfoQuery(0,session['LOGON.USERID'],selectedRow.Eid,"00A^"+selectedRow.TStasType);
	if((rtnStr=="-1")||(rtnStr=="")){
		$.messager.alert("温馨提示","清单信息查询失败!")
	}else{
		$.messager.alert("温馨提示","清单信息查询成功!")	
	}
	loadChargeDtlList();
}

