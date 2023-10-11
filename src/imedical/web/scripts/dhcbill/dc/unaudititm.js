/**
 * 数据核查免审核项目
 * FileName: dhcbill\dc\unaudititm.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.DC.BL.UnAuditItmCtl"	 
}
//全局变量
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var PassWardFlag = "N";
var PublicDataSwitchBox = "";
var defendbypro="Y"; //按项目维护Y/分类维护N
//var projectaddshow=false;
$(function(){
	var tableName ="CF_BILL_DC.UnAuditItm"; //"User.INSUTarContrast";
	var defHospId = session['LOGON.HOSPID'];
	$("#hospital").combobox({
		panelHeight: 150,
		
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue,oldValue){
			if(oldValue!="")
			{
				Querydic();    
			}
			clearform("");
	    },
	});
	var dicSelid=0
	//初始化combobox
	$HUI.combobox("#autFlag",{
		valueField:'cCode',
    	textField:'cCode',
    	panelHeight:100
	});

	//初始化datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		rownumbers:true,
		striped:true,
		fitColumns:true,
		toolbar: '#toolbar',
		singleSelect: true,
		autoRowHeight:false,
		checkbox:true,
		columns:[[
			{field:'ConfigDesc',title:'备注',width:150,showTip:true,tipPosition:"top"},
			{field:'CateCode',title:'分类代码',width:50,hidden:true},
			{field:'CateDesc',title:'分类描述',width:100,hidden:true},
			{field:'CateDataSrc',title:'分类数据集合',width:80,hidden:true},
			{field:'ActiveFlag',title:'审核标志',width:80,
				formatter: function(value,row,index){
	                if (row.ActiveFlag=="Y"){
	                    return "审核通过";
	                } 
	                else if((row.ActiveFlag=="N")&&(row.AuditId!="")) {
	                    return "审核拒绝";
	                }
	                else{
		                return "未审核";
		            }
	            }
			}, 
			{field:'AuditId',title:'审核人'}, 
			{field:'AuditMemo',title:'审核备注',width:150},
			{field:'AuditDateTime',title:'审核时间',width:100,
				formatter: function(value,row,index){
	                    return row.AuditDate+" "+row.AuditTime;
	            }
			},
			{field:'ConfigValue',title:'配置值',width:80},
			{field:'BusinessTypeName',title:'业务类型',width:80,
				formatter: function(value,row,index){
					var BusinessTypeName=row.BusinessTypeName;
	                if (BusinessTypeName==""){
	                    BusinessTypeName="全部";
	                }
	                return BusinessTypeName;
	            }},
			{field:'IndicatorId',title:'指标代码',width:50,hidden:true}, //,sortable:true,order:'asc'
			{field:'IndicatorName',title:'指标名称',width:130,
				formatter: function(value,row,index){
					var IndicatorName=row.IndicatorName;
	                if (IndicatorName==""){
	                    IndicatorName="全部";
	                }
	                return IndicatorName;
	            }},
			{field:'CRTER',title:'创建人'}, 
			{field:'CRTEDATE',title:'创建时间',width:100,
				formatter: function(value,row,index){
	                    return row.CRTEDATE+" "+row.CRTETIME;
	            }
			}, // CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME
			{field:'UPDTID',title:'更新人'}, 
			{field:'UPDTDATE',title:'更新时间',width:100,
				formatter: function(value,row,index){
	                    return row.UPDTDATE+" "+row.UPDTTIME;
	            }
			},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}

		]],
		pageSize: 30,
		pagination:true,
        onSelect: function(rowIndex, rowData) {
	        if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    fillform(rowIndex,rowData)
			    tmpselRow=rowIndex;
			}
            
        },
	});
	
	//登记号回车查询事件
	$("#dicKey").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	
	$("#btnCopy").popover({
		trigger:'hover',
		content:'将选中的免审费用项目添加到选定指标。'
	});
	$("#btnAllCopy").popover({
		trigger:'hover',
		content:'将选中指标下的<font color=\'#f16e57\'>所有</font>免审项目添加到选定指标。'
	});
	$("#btnTip").popover({
		trigger:'hover',
		content:initTipInfo()
	});
	init_BusinessTypeQ();
	init_IndexQ('');
	Querydiccbx();
	init_BusinessTypeIdCB();
	init_CateCode();
	init_ConfigValue();
	init_ActiveFlagCB();
	init_defendbyproQ();
});
function init_defendbyproQ(val){
	$HUI.combobox("#defendbypro", {
		panelHeight: 150,
		valueField: 'Code',
		textField: 'Desc',
		mode:'local',
		data:[{"Code":"Y","Desc":"免费项目维护"},{"Code":"N","Desc":"数据核查指标维护"}],
		editable: false,
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].Code);
			}
		},
	    onChange: function(newValue,oldValue){
			oneprojectadd();
	    },

	});
}
//按项目维护
function oneprojectadd()
{
 	if($('#defendbypro').combobox('getValue')=="Y")
	{
		defendbypro="Y";
		$(".addproject").hide();
	}
	else
	{
		defendbypro="N";
		$(".addproject").show();
	} 
}
function initTipInfo(){
	var tipinfo="<ul class='tip_class'><li style='font-weight:bold'>免审核项目配置使用说明</li>" +
		'<li>1、应用场景：在指标核查过程中，如果想对某一项目进行过滤处理，既可在指定指标配置上该项目，达到该项目免审效果。</li>' +
		'<li>--------------------------------------------------------------------------------------------------------------------</li>'+
		'<li>2、按项目维护：点击按项目维护，此项目将保存到所有指标下面。</li>' +
		'<li>--------------------------------------------------------------------------------------------------------------------</li>';
	return tipinfo;
}

function init_BusinessTypeQ(){
	$HUI.combobox("#BusinessTypeCodeQ", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID ="G";
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
	});
}
function init_BusinessTypeIdCB(){
	$HUI.combobox("#BusinessTypeCode", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "G";
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
		onSelect:function(val){
			init_IndicatorId(val.DicCode);
		}
	});
}
function init_IndexQ(val){
	$HUI.combobox("#IndicatorIdQ", {
		panelHeight: 200,
		url: $URL,
		editable: true,
		valueField: 'Code',
		textField: 'Name',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.IndicatorDefCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "G";
			param.KeyCode="";
			param.PCheckType= "";
			param.QBusinessType= val;//"";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
			}
		},
	});
}
function init_IndicatorId(val){
	$HUI.combobox("#IndicatorId", {
		panelHeight: 200,
		url: $URL,
		editable: true,
		valueField: 'Code',
		textField: 'Name',
		rowStyle:'checkbox',
		multiple:true,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.IndicatorDefCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "";
			param.KeyCode="";
			param.PCheckType= "";
			param.QBusinessType= val;//"";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
			}
		},
	 	onChange:function(val){
		} 
	});
}

function init_CateCode(){
	$HUI.combobox("#CateCode", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = 'G';//getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="N||Y";
			param.PDicType="UnAuditType";
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
	    onSelect:function(val){
			init_ConfigValue();
			$("#projectvalue")[0].innerHTML="<label class='Redword'>*</label>"+($('#CateCode').combobox("getText"));

		} 
	});
}

function init_ConfigValue(){
	$HUI.combobox("#ConfigValue", {
		panelHeight: 150,
		url: $URL,
		editable: true,
		valueField: 'TARIRowid',
		textField: 'TARIDesc',
		mode:"remote",
		onBeforeLoad: function (param) {
			param.ClassName = GV.CLASSNAME;
			param.QueryName = "QueryDHCTarItem";
			param.Key=param.q;
			
			if($('#CateCode').combobox('getValue')=="ArcItm"){
				param.QueryName = "QueryARCItmMast";
			}
			param.HospID = getValueById("hospital");
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
	    onSelect:function(val){
		} 
	});
}


function init_ConfigDesc(){
	$HUI.combobox("#ConfigDesc", {
		panelHeight: 150,
		url: $URL,
		editable: true,
		valueField: 'TARIRowid',
		textField: 'TARIDesc',
		onBeforeLoad: function (param) {
			param.ClassName = GV.CLASSNAME;
			param.QueryName = "QueryDHCTarItem";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
	    onSelect:function(val){
		} 
	});
}

function init_ActiveFlagCB(){
	$HUI.combobox("#ActiveFlag", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "G";
			param.KeyCode="";
			param.PDicType= "ActiveFlag";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			}
		}
	});
}


//查询字典数据
function Querydic(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryUnAuditItm',
		KeyCode: getValueById('dicKey'),
		HospID : getValueById("hospital")==""?"2":getValueById("hospital"),
		BusinessType : getValueById('BusinessTypeCodeQ'),
		IndexCode :  getValueById('IndicatorIdQ'),
		CateCode:$('#diccbx').combobox('getValue'),
		ExamineFlag:$('#ExamineFlag').combobox('getValue')
	}
	seldictype=$('#diccbx').combobox('getValue');
	loadDataGridStore('dg',QueryParam);
}

//停用保存记录
function StopDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){
		$.messager.alert('提示','请选择要停用的项目!','info'); 
		return;  
	}
	if(getValueById('ActiveFlag')=="N")
	{
		if($('#dg').datagrid('getRows')[tmpselRow]['AuditId']!="")
		{
			$.messager.alert('提示','审核拒绝的项目不需要停用!','info'); 
		}
		else
		{
			$.messager.alert('提示','未审核的项目不需要停用!','info'); 
		}
		return;
	}
	$.messager.confirm("提示", "是否停用？", function (r) { // prompt 此处需要考虑为非阻塞的
	if (r) {
				var savecode=tkMakeServerCall(GV.CLASSNAME,"Stop",selRowid,session['LOGON.USERID'])
				if(eval(savecode)==0){
					$.messager.alert('提示','停用成功!','info');   
					$("#dg").datagrid('reload')
					selRowid="";
					$("#dg").datagrid("getPager").pagination('refresh');
					$("#dg").datagrid('unselectAll');
				}else{
					$.messager.alert('提示','停用失败!','info');   
				}
			} else {
		return false;
	}
	})

}
//启用保存记录
function OpenDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){
		$.messager.alert('提示','请选择要启用的项目!','info'); 
		return;  
	}
	if(getValueById('ActiveFlag')=="Y")
	{
		$.messager.alert('提示','未停用的项目不需要启用!','info'); 
		return;
	}
	else if(getValueById('ActiveFlag')=="N")
	{
		if($('#dg').datagrid('getRows')[tmpselRow]['AuditMemo']!="停用")
		{
			$.messager.alert('提示','未停用的项目不需要启用!','info'); 
			return;
		}
	}
	$.messager.confirm("提示", "是否启用？", function (r) { // prompt 此处需要考虑为非阻塞的
	if (r) {
				var savecode=tkMakeServerCall(GV.CLASSNAME,"Open",selRowid,session['LOGON.USERID'])
				if(eval(savecode)==0){
					$.messager.alert('提示','启用成功!','info');   
					$("#dg").datagrid('reload')
					selRowid="";
					$("#dg").datagrid("getPager").pagination('refresh');
					$("#dg").datagrid('unselectAll');
				}else{
					$.messager.alert('提示','启用失败!','info');   
				}
			} else {
		return false;
	}
	})

}
//特殊字符处理
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}
//更新保存记录
function UpdateDic(){  
	var BusinessTypeCode=getValueById('BusinessTypeCode');
	var ChooseDesc=$("#IndicatorId").combobox('getText');
	var CateCode = getValueById('CateCode');
	var CateDesc = getValueById('CateDesc');
	var CateDataSrc = getValueById('CateDataSrc');
	var ConfigValue = getValueById('ConfigValue');//$("#ConfigValue").combobox('getText');
	var ConfigDesc = $("#ConfigValue").combobox('getText');//getValueById('ConfigDesc');
	var ActiveFlag = "N";//修改之后要求审核后才启用
	var HospDr = getValueById("hospital");
	var ChooseID=$("#IndicatorId").combobox('getValues');
	if(defendbypro=="Y")//按项目维护,只存一条为ALL的指标
	{
		
		var IndicatorId ="ALL";
		var saveinfo="^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
		saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
		saveinfo=saveinfo.replace(/请输入信息/g,"")
		var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
		if(eval(savecode)>0){
			$("#dg").datagrid('reload');
			$("#dg").datagrid('unselectAll');
			clearform("");
			$.messager.alert('提示','保存成功!','info');   
		}else if (savecode='-1'){
			$.messager.alert('提示','保存失败:项目已存在！项目：'+ConfigDesc,'info');   
		}
		else {
			$.messager.alert('提示','保存失败!rtn=' + savecode,'info');  
		}
		$("#dg").datagrid('reload');
		$("#dg").datagrid('unselectAll');
		clearform("");
		return;
	}
	else if (ChooseID.length===1) 
	{
		var IndicatorId = BusinessTypeCode+'||'+ getValueById('IndicatorId');
		selRowid = selRowid<0?"":selRowid;
		var saveinfo=selRowid+"^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
		saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
		saveinfo=saveinfo.replace(/请输入信息/g,"");
		var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
		if(eval(savecode)>0){
			//$.messager.alert('提示','保存成功!');  
			$("#dg").datagrid('reload');
			$("#dg").datagrid('unselectAll');
			clearform("");
			$.messager.alert('提示','保存成功!','info');   
		}else if (savecode=='-1'){
			$.messager.alert('提示','保存失败！项目：' + ChooseDesc+'-'+ConfigDesc,'info');   
		}
	}
	else
	{
		var DescList=$("#IndicatorId").combobox('getText').split(',');
		for (var i=0; i<ChooseID.length; i++)
		{
			var IndicatorId = BusinessTypeCode + '||' + ChooseID[i];
			selRowid = selRowid<0?"":selRowid;
			var saveinfo=selRowid+"^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
			saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
			saveinfo=saveinfo.replace(/请输入信息/g,"");
			var SuccsessCount=0;
			var FialdCount=0;
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
			if(eval(savecode)>0){
				SuccsessCount+=1; 
			
			}else{
				FialdCount+=1; 
			}
		}
		$.messager.alert('提示','保存成功:'+SuccsessCount+"条,失败:"+FialdCount+"条!",'info');   
		$("#dg").datagrid('reload');
		$("#dg").datagrid('unselectAll');
		clearform("");
	}
}
//删除记录
function DelDic(){
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('提示','您无权限,请联系管理员授权!');return;}
	if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('提示','请选择要删除的记录!','info');return;}
	$.messager.confirm('请确认','你确认要删除这条记录吗?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",selRowid)
			if(eval(savecode)==0){
				$.messager.alert('提示','删除成功!','info');   
				$("#dg").datagrid('reload');
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll');
			}else{
				$.messager.alert('提示','删除失败!','info');   
			}
		}else{
			return;	
		}
	});
}
//填充下边的form
function fillform(rowIndex,rowData){
	selRowid=rowData.Rowid;
	// IndicatorId,CateCode,CateDesc,CateDataSrc,ConfigValue,ConfigDesc,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid
	if(rowData.IndicatorId.split('||')[0]!="ALL")
	{
		$("#BusinessTypeCode").combobox("select", rowData.IndicatorId.split('||')[0]);
		setValueById('IndicatorId',rowData.IndicatorId.split('||')[1]);
	}
	$("#CateCode").combobox("select",rowData.CateCode);
	setValueById('CateDesc',rowData.CateDesc);
	setValueById('CateDataSrc',rowData.CateDataSrc);
	setValueById('ConfigValue',rowData.ConfigValue);
	setValueById('ConfigDesc',rowData.ConfigDesc);
	setValueById('ActiveFlag',rowData.ActiveFlag);
}
//清除下边的form
function clearform(inArgs){
	
	$('.editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
	setValueById("CateDataSrc","");
	init_BusinessTypeIdCB();
	init_CateCode();
	init_ConfigValue();
	setValueById("ConfigDesc","");
	init_ActiveFlagCB();
}
//改变下边显示框的编辑状态
function disinput(tf){
	$('#code').attr("disabled",tf);
	$('#insucode').attr("disabled",tf);
	$('#desc').attr("disabled",tf);
	$('#insudesc').attr("disabled",tf);
	$('#note').attr("disabled",tf);
	$('#note2').attr("disabled",tf);
	
	$('#autFlag').attr("disabled",tf);
	$('#defUserFlag').attr("disabled",tf);
	$('#opIPFlag').attr("disabled",tf);
	$('#userFlag').attr("disabled",tf);
	$('#relUserFlag').attr("disabled",tf);

}
//免审核项目配置字典导出
function Export()
{
   try
   {
	   var KeyCodeValue=getValueById('dicKey')
		$.messager.progress({
	         title: "提示",
			 msg: '正在导出免费'+$('#diccbx').combobox('getText')+'配置字典',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:'免费'+$('#diccbx').combobox('getText')+'配置字典',		  
			PageName:"QueryInfo",      
			ClassName: GV.CLASSNAME,
			QueryName: 'QueryUnAuditItm',
			KeyCode: getValueById('dicKey'),
			HospID : getValueById("hospital")==""?"2":getValueById("hospital"),
			BusinessType : getValueById('BusinessTypeCodeQ'),
			IndexCode :  getValueById('IndicatorIdQ'),
			CateCode:$('#diccbx').combobox('getValue'),
			ExamineFlag:$('#ExamineFlag').combobox('getValue')
			
			
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   }; 
}
//zjb 2023/11/11 原来的导入选择文件筐不是置顶状态，新增
function Import()
{
	ImportObj.ImportFile(
		{
			FileSuffixname: /^(.xls)|(.xlsx)$/,///^(.txt)$/,
			harset: 'utf-8'
		}, function(arr){
			SaveArr(arr);
		}
	);
}
//循环调保存方法
function SaveArr(arr)
{
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
	var rowCnt=arr.length
	try{
		$.messager.progress({
            title: "提示",
            msg: '免费收费/医嘱项目配置字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
		for (i = 1; i < rowCnt; i++) 
		{
			var rowArr=arr[i];
			var IndicatorId = rowArr.IndicatorId?rowArr.IndicatorId:"";
			//var IndicatorName = rowArr.IndicatorName?rowArr.IndicatorName:"";
			var CateCode = rowArr.CateCode?rowArr.CateCode:"";
			var CateDesc = rowArr.CateDesc?rowArr.CateDesc:"";
			var CateDataSrc = rowArr.CateDataSrc?rowArr.CateDataSrc:"";
			var ConfigValue = rowArr.ConfigValue?rowArr.ConfigValue:"";
			var ConfigDesc = rowArr.ConfigDesc?rowArr.ConfigDesc:"";
			var ConfigCODE=rowArr.ConfigCODE?rowArr.ConfigCODE:""; //2023-05-11新增医嘱项目/收费项目code维护	
			var ActiveFlag = rowArr.ActiveFlag?rowArr.ActiveFlag:""; 
			var HospDr = rowArr.HospDr?rowArr.HospDr:"";
			/* var CRTER = rowArr.CRTER?rowArr.CRTER:"";
			var CRTEDATE = rowArr.CRTEDATE?rowArr.CRTEDATE:"";
			var CRTETIME = rowArr.CRTETIME?rowArr.CRTETIME:"";
			var UPDTID = rowArr.UPDTID?rowArr.UPDTID:"";
			var UPDTDATE = rowArr.UPDTDATE?rowArr.UPDTDATE:"";
			var UPDTTIME = rowArr.UPDTTIME?rowArr.UPDTTIME:"";
			var Rowid = rowArr.Rowid?rowArr.Rowid:"";
			var BusinessTypeName = rowArr.BusinessTypeName?rowArr.BusinessTypeName:""; */
			var saveinfo="^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
			saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr+"^"+ConfigCODE;	
			saveinfo=saveinfo.replace(/请输入信息/g,"");
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
            if (savecode == null || savecode == undefined) savecode = -1;
            if (savecode >= 0) {
	        	sucRowNums = sucRowNums + 1;
	        } 
	        else {
		        errRowNums = errRowNums + 1;
		        if (ErrMsg == "") {
			        ErrMsg = i+":"+savecode+"已存在！";;
			    }
			    else {
                    ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"已存在！";
                }
        	}
		}
		if (ErrMsg == "") {
        	$.messager.progress("close");
        	$.messager.alert('提示', '数据正确导入完成');
        } else {
            $.messager.progress("close");
            var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
            tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
            $.messager.alert('提示', tmpErrMsg,'info');
        }
	}
	catch(ex)
	{
		$.messager.progress("close");
		$.messager.alert('提示', '保存数据异常：'+ex.message,'error');
	}
}

//免费项目配置字典导入
function Import2()
{
	var filePath=""
	var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	           +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	           +'if (!fName){fName="";}'
	           +'xlApp.Quit();'
               +'xlSheet=null;'
               +'xlApp=null;'
	           +'return fName;}());'
	  CmdShell.notReturn = 0;
      var rs=CmdShell.EvalJs(exec);
      if(rs.msg == 'success'){
        filePath = rs.rtn;
        importItm(filePath);
      }else{
         $.messager.alert('提示', '打开文件错误！'+rs.msg,'error');
      }				   
}
function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('提示', '请选择文件！','info')
        return ;
    }
   $.messager.progress({
         title: "提示",
         msg: '免费收费/医嘱项目配置字典导入',
         text: '数据读取中...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//读取Excel数据
function ReadItmExcel(filePath)
{
	
   //读取excel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('提示', '调用websys_ReadExcel异常：'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: "提示",
            msg: '免费收费/医嘱项目配置字典导入',
            text: '导入中，共：'+(rowCnt-1)+'条'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//异常代码字典数据保存
function ItmArrSave(arr)
{
	//读取保存数据
	var ErrMsg = "";     //错误数据
    var errRowNums = 0;  //错误行数
    var sucRowNums = 0;  //导入成功的行数
	var rowCnt=arr.length
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i]	
			 var IndicatorId = rowArr[0];		 
			 var ChooseDesc=rowArr[1];
			 var CateCode = rowArr[2];
			 var CateDesc = rowArr[3];
			 var CateDataSrc =rowArr[4];
			 var ConfigValue = rowArr[5];
			 var ConfigDesc =rowArr[6];
			 var ActiveFlag = rowArr[7];
			 var HospDr =rowArr[8];
			 var SelRow ="";// rowArr[15];
			 var saveinfo=SelRow+"^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
			 saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
			 saveinfo=saveinfo.replace(/请输入信息/g,"");
			 var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
             if (savecode == null || savecode == undefined) savecode = -1;
             if (savecode >= 0) {
	             sucRowNums = sucRowNums + 1;
	             } 
	        else {
		         errRowNums = errRowNums + 1;
		         if (ErrMsg == "") {
			         ErrMsg = i+":"+savecode;
			         } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"已存在！";
                        }
                    }
		 }
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "导入成功："+sucRowNums +"条，失败："+errRowNums+"条。";
                     tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>"+ ErrMsg;
                    $.messager.alert('提示', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('提示', '保存数据异常：'+ex.message,'error');
	          return ;
	      }
  return ;
	
}


function Querydiccbx(){
	$HUI.combobox("#diccbx", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = 'G';//getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="N||Y";
			param.PDicType="UnAuditType";
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
	    onSelect:function(val){
			Querydic();
			var option = $('#dg').datagrid("getColumnOption", "ConfigDesc")
			if(option!=null)
			{
				 option.title = $('#diccbx').combobox("getText")+"名称";
				 $('#dg').datagrid();
			}
			var option = $('#dg').datagrid("getColumnOption", "ConfigValue")
			if(option!=null)
			{
				 option.title = $('#diccbx').combobox("getText")+"ID";
				 $('#dg').datagrid();
			}
		} 
	});
}
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnUpdate" : // 保存
	    	var ChooseID=$("#IndicatorId").combobox('getValues');
	    	var CateCode = getValueById('CateCode');
	    	var ConfigValue = $("#ConfigValue").combobox('getText');
			if((ChooseID.length===0||CateCode==""||ConfigValue=="")&&defendbypro=="N")//  //默认所有指标
			{
				$.messager.alert('提示','带星号为必填项，请检查是否都选好!','info');  
				return false; 
			}
	    	$.messager.confirm("提示", "是否继续保存？", function (r) { // prompt 此处需要考虑为非阻塞的
				if (r) {
					UpdateDic();
				} else {
					return false;
				}
			})
	    	break;
	    case "btnDelete" : //删除
			DelDic(); 	
	    	break;
	    case "btnClear" :
	    	clearform();
	    	break;	
	    case "btnStop" : // 停用
	    	StopDic();
	    	break;
	    case "btnOpen" : // 启用
	    	OpenDic();
	    	break;
	    case "btnClearCho" :
	    	$('#BusinessTypeCodeQ').combobox("select", "");
	    	var defHospId = session['LOGON.HOSPID'];
	    	$('#hospital').combobox('select', defHospId);
	    	$('#ExamineFlag').combobox('select', '');
	    	setValueById('dicKey','');
	    	Querydiccbx();
	    	//$('#IndicatorIdQ').combobox("select", "");
	    	break;
	    default :
	    	break;
	    }
		
}) 
