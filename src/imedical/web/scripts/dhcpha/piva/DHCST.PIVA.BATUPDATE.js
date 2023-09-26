/**
 * 模块:静脉排批
 * createdate:2015-12-05
 * creator:LiangQiang
 * scripts/dhcpha/piva/DHCST.PIVA.BATUPDATE.js
 */
var url = "DHCST.PIVA.ACTION.csp";
var PhLocDr=session['LOGON.CTLOCID'];
var UserDr=session['LOGON.USERID'];
var CurWardID="";
var CurAdm="";
var CurKFlag=""; // 是否清除
var currEditRow="";currEditID=""
var serBatNoEditor;
$(function(){
	InitDateBox();
	initPhaLocGrp();
	InitWardList();
	InitPatNoList();
	InitOrdItmdgList();
	InitCurLabel();
	InitAllLabel();
	InitPhaLocBatBox(PhLocDr);
	$('#btnFind').bind("click",Query);  // 点击查询
    $('#btnOk').bind("click",UpdBatData);
    $('#ByPatNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
            GetPatAdmList(); // 调用查询
        }
    });
    $(".tabs-header").bind('click',function(){
		RefTab();
		CurKFlag=0; // 控制不刷新		
	})
	//离开
	window.onbeforeunload = function(){
		ClearTMP();
	};
});

function InitDateBox(){
	$("#DbSt").datebox("setValue", formatDate(0));  //Init起始日期
	$("#DBEnd").datebox("setValue", formatDate(0));  //Init结束日期	
}

//初始化药房科室组
function initPhaLocGrp(){
	$('#LocGrpCombo').combobox({  
		panelWidth: 200,
		url:url+'?action=GetLocListByGrp&Input='+PhLocDr,  
		valueField:'rowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#LocGrpCombo').combobox('getData');
            if (data.length > 0) {
                 // $('#LocGrpCombo').combobox('select', data[0].rowId);
			}     
	    }
	});
	$('#LocGrpCombo').combobox({
		onHidePanel: function() {			    
				 var valueField = $(this).combobox("options").valueField;
				 var val = $(this).combobox("getValue");  //当前combobox的值
				var allData = $(this).combobox("getData");   //获取combobox所有数据
				var result = true;      //为true说明输入的值在下拉框数据中不存在
				for (var i = 0; i < allData.length; i++) {
					 if (val == allData[i][valueField]) {
						 result = false;
					 }
				 }
				 if (result) {
					 $(this).combobox("clear");
					 $(this).combobox('setValue', '');
				 }
			}
	});
		
}

//初始化病区列表
function InitWardList(){
	//定义columns
	var columns=[[
		{field:"WardID",title:'WardID',hidden:true},
		{field:'WardDesc',title:'病区',width:200}
	]];
	
	//定义datagrid
	$('#warddg').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:100,  // 每页显示的记录条数
		pageList:[100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
		   CurWardID=rowData.WardID;
		   CurAdm="";
		   QueryDetail();
	   }
	});
    //initScroll("#warddg");
}
function InitPatNoList(){
	//定义columns
	var columnspat=[[
		{field:'Adm',title:'adm',hidden:true},
		{field:'AdmDate',title:'就诊日期',width:100},
		{field:'AdmTime',title:'就诊时间',width:100},
		{field:'AdmLoc',title:'就诊科室',width:100},
		{field:'CurrWard',title:'病区',width:100},
		{field:'CurrWardID',title:'病区ID',width:100},
		{field:'CurrBed',title:'床号',width:100},
		{field:'CurrDoc',title:'医生',width:100}
		
	]];
	
	//定义datagrid
	$('#admdg').datagrid({
		url:'',
		toolbar:'#admdgBar',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columnspat,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
		     CurAdm=rowData.Adm;
			 CurWardID="";
		     QueryDetail();

		   }
	});

	//initScroll("#admdg");
}

function InitOrditmDatagrid()
{

	 //批号
	 serBatNoEditor={  //设置其为可编辑
		type: 'combobox', //设置编辑格式
		options: {
			//required: true, //设置编辑规则属性
			panelHeight:"auto",
			valueField: "text",  //yunhaibao20160318,一般用不到批次id
			textField: "text",
			url:url+'?action=GetLocBatNoCombo&Input='+PhLocDr,
			onSelect:function(option){
					if(currEditID != ""){
						var rows=$('#'+currEditID).datagrid('getRows');//获取所有当前加载的数据行
						lastbatno=rows[currEditRow].TbBatNo;
						dsp=rows[currEditRow].TbMDsp;
					}

					$.messager.confirm('确认对话框', '确定要修改吗？', function(r){
					  if (r){
					  		var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'TbBatNoId'});
							$(ed.target).val(option.value);  //设置ID
							var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'TbBatNo'});
							$(ed.target).combobox('setValue', option.text);  //设置Desc

							var ret= tkMakeServerCall("web.DHCSTPIVABATUPDATE","UpdCurBatNo",UserDr,PhLocDr,dsp,option.text);
							if (ret<0) { $(batno.target).val(Currbat);}
						}
						else{
						    var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'TbBatNo'});
						    $(ed.target).combobox('setValue', lastbatno);  //设置Desc

						}
					});
			},
			onBeforeLoad: function(param){

			}
		}

	}

}

//医嘱明细列表
function InitOrdItmdgList(){	
	InitOrditmDatagrid();
	//定义columns
	var columnspat=[[		
        {field:"TbSttD",title:'用药时间',width:140},
		{field:'TbBatNo',title:'批次',width:50,editor:serBatNoEditor},
		{field:'TbBatNoId',title:'批次id',editor:'text',hidden:true},
		{field:"TbMDsp",title:'TbMDsp',hidden:true},
		{field:'TbBedNo',title:'床号',width:50},
		{field:"TbName",title:'姓名',width:60},
		{field:'TbItmDesc',title:'主药',width:230},
		{field:'TbItmDescSub',title:'溶媒',width:230},
		{field:'TbDosage',title:'剂量',width:50}, 
		{field:'TbFreq',title:'频次',width:50},
		{field:'TbQty',title:'数量',width:50},
		{field:'TbUomdesc',title:'单位',width:50},
		{field:'TbInstruc',title:'用法',width:80},
		{field:'TbDoctor',title:'医生',width:50},
		{field:"TbPatNo",title:'登记号',width:85},
		{field:'TbAdmcolor',title:'颜色',width:50,hidden:true},
		{field:'TbPID',title:'PID',width:50,hidden:true}
	]];
	                                                          
	//定义datagrid
	$('#ordtimdg').datagrid({
		url:'',
		fit:true,
		border:false,
		singleSelect:true,
		toolbar:'#orditmgbbar',
		rownumbers:false,  //放开会变慢 liangqiang
		columns:columnspat,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200],   // 可以设置每页记录条数的列表
		loadMsg: '正在加载信息...',
		pagination:true,
		rowStyler:function(index,row){  
			if (row.TbAdmcolor==1){  
				return 'background-color:C4FEFF;';  
			}    
		},   
		onClickRow:function(rowIndex,rowData){
		   var MDsp=rowData.TbMDsp;
		   var PID=rowData.TbPID;
		   GetCurBatInfo(MDsp);
		   var input=MDsp+"^"+PID
		   GetCurPatBatInfo(input); 
		   if ((currEditRow != "")||(currEditRow == "0")) {
				$("#"+currEditID).datagrid('endEdit', currEditRow);
				var tmpMDspInfo=tkMakeServerCall("web.DHCSTPIVABATUPDATE","GetCurBatInfo",MDsp)
				$('#ordtimdg').datagrid('updateRow',{
					index: rowIndex,
					row: {TbSttD:tmpMDspInfo.split("^")[7]}
				});
			} 
			$("#"+this.id).datagrid('beginEdit', rowIndex);
			currEditID=this.id;
			currEditRow=rowIndex;
	    },
	    onClickCell:function(rowIndex, field, value){
            if (field!="TbBatNo"){
				return;
            }
       }	
	});
	$('#ordtimdg').datagrid('loadData',{total:0,rows:[]}); /// 初始化页数
    //initScroll("#ordtimdg");
}

//当前瓶签
function InitCurLabel()
{
	
	//定义columns
	var columnspat=[[
	    {field:'drug',title:'药品',width:230},
		{field:'dose',title:'剂量',width:60},
		{field:'freq',title:'频次',width:50},
		{field:'oeorestat',title:'执行记录状态',width:50,hidden:true}
		
	]];
	
	//定义datagrid
	$('#curlabeldg').datagrid({
		url:url+'?action=GetCurPatBatDs',
		toolbar:'#curlabeldgbar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // 每页显示的记录条数
		//pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg:null,
		//loadMsg: '正在加载信息...',
		pagination:false,
		rowStyler: function(index,row){
			if (row.oeorestat=="0"){
				return 'color:#ff0066;font-weight:bold';
			}
		}
	});

	//initScroll("#curlabeldg");
}


//所有瓶签
function InitAllLabel()
{
	
	//定义columns
	var columnspat=[[
		{field:'print',title:'打印',width:30},
		{field:'batno',title:'批次',width:50},
	    {field:'incidesc',title:'药品',width:230},
		{field:'dosage',title:'剂量',width:60},
		{field:'freq',title:'频次',width:50},
		{field:'oestatus',title:'停止',width:50,hidden:true},
		{field:'xdate',title:'停止日期',width:80},
		{field:'xtime',title:'停止时间',width:80},
		{field:'xusername',title:'停止人',width:80},
		{field:'oestatusflag',title:'停止标志',hidden:true}
		
	]];
	
	//定义datagrid
	$('#alllabeldg').datagrid({
		url:'',
		toolbar:'#patnodgBar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // 每页显示的记录条数
		//pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:false,
	    onDblClickRow:function(rowIndex,rowData){
			//var pointer=rowData.CurrWardID;
			//QuerySubDb(inputs);
			//var AdmId=rowData.Adm;
			//QueryResult(pointer,AdmId)
		 },
		rowStyler:function(index,row){  
			if (row.oestatusflag==0){  
				return 'background-color:#FFB5C5;';  
			}    
		 }

	});

	//initScroll("#alllabeldg");
}

///查询
function Query()
{
	var params=GetParams();
	$('#warddg').datagrid({
		url:url+'?action=GetAdtWardList',	
		queryParams:{
			params:params}
	});
}

///获取入参
function GetParams()
{
	var StDate=$('#DbSt').datebox('getValue');   //起始日期
	var EndDate=$('#DBEnd').datebox('getValue'); //截止日期
	var params=PhLocDr+"^"+StDate+"^"+EndDate+"^"+CurWardID+"^"+CurAdm;
    var batlist="";  //批号

	$("input[type=checkbox][name=batbox]").each(function(){
		if($('#'+this.id).is(':checked')){
		    if (batlist=="")
		    {
			   batlist=this.value;
		    }else{
			   batlist=batlist+","+this.value;
		    }
		}
	})

	var LocGrpId=$('#LocGrpCombo').combobox('getValue');
	
	if ($('#LocGrpCombo').combobox('textbox').val().length==0)
	{
		LocGrpId="";
					 $('#LocGrpCombo').combobox("clear");
					 $('#LocGrpCombo').combobox('setValue', '');
	}
    
	var params=params+"^"+batlist+"^"+LocGrpId;
	return params;
		
}

///查询医嘱
function QueryDetail()
{
	ClearGrid();
	var params=GetParams();
	$('#ordtimdg').datagrid({
		url:url+'?action=GetAdtWardDetail',	
		queryParams:{
			params:params}
	});


}

//清空
function ClearGrid()
{
	ClearTMP(); 
	$('#CWard').val(''); //登记号
	$('#CBed').val(''); //病人名字 
	$('#CName').val('');
	$('#CSex').val('');
	$('#CAge').val('');
	$('#CWeight').val('');
	$('#CPatId').val('');
    $('#CDosDate').val('');
    $('#curlabeldg').datagrid('options').queryParams.params = "";  
    $('#alllabeldg').datagrid('options').queryParams.params = "";  
	$('#curlabeldg').datagrid('loadData',{total:0,rows:[]}); 
    $('#alllabeldg').datagrid('loadData',{total:0,rows:[]});
}
//获取当前签信息
function GetCurBatInfo(MDsp){

	//获取信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetCurBatInfo&Input="+MDsp,
       //dataType: "json",
       success: function(val){
	    var tmp=val.split("^");
		$('#CWard').val(tmp[0]); //登记号
		$('#CBed').val(tmp[1]); //病人名字 
		$('#CName').val(tmp[2]);
		$('#CSex').val(tmp[3]);
		$('#CAge').val(tmp[4]);
		$('#CWeight').val(tmp[5]);
		$('#CPatId').val(tmp[6]);
        $('#CDosDate').val(tmp[7]);
       }
    })

    /*
	$('#curlabeldg').datagrid({
		url:url+'?action=GetCurPatBatDs',	
		queryParams:{
			params:MDsp}
	});
	*/
    
	$('#curlabeldg').datagrid('load',  {  
			params:MDsp
    });	
}
///加载所有标签信息
function GetCurPatBatInfo(params){
	$('#alllabeldg').datagrid({
		url:url+'?action=GetCurPatBatInfo',	
		queryParams:{
			params:params}
	});
}
///按登记号查询就诊列表
function GetPatAdmList(){
	var RegNo=$('#ByPatNo').val();
   	var patLen = tkMakeServerCall("web.DHCSTPIVABATUPDATE", "GetPatRegNoLen");
    var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('提示','输入登记号错误!','warning');
		return;
	}		 	
    for (i=1;i<=patLen-plen;i++){
		 RegNo="0"+RegNo;  
	}
	var validnoret=tkMakeServerCall("web.DHCSTKUTIL", "ValidateRegNo",RegNo);
	if (validnoret==""){
		$.messager.alert('提示','登记号:'+RegNo+'不存在!','warning');
		$('#ByPatNo').val("");
		return;
	}
	 $('#ByPatNo').val(RegNo);
	 var params=RegNo;

	 $('#admdg').datagrid({
		url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:params}
	 });

}


//获取当前签信息
function InitPhaLocBatBox(PhLocDr){
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetPhaLocBatInfo&Input="+PhLocDr,
       //dataType: "json",
       success: function(val){
            var chkhtml="";
			var tmp=val.split("^");			
			for (i=1;i<=tmp.length;i++)
			 {
				 var batstr=tmp[i-1].split(",");
                 var batnoid=i ; //batstr[0];
                 var batnodesc=batstr[1];
				 //alert(batnoid)
				 
				 var tmphtml='<span style="margin-left:10px;"><input style="vertical-align: text-bottom;" id="'+batnoid+'" class="ui-checkbox" name="batbox" type="checkbox" value='+batstr[0]+'>'+batnodesc+'</input></span>'
				 if (chkhtml=="")
				 {
                    chkhtml=tmphtml;
				 }else{
					chkhtml=chkhtml+tmphtml;
				 }
			 }
			$("#DivBatNo").append(chkhtml);
       }
    })
}


//保存排批
function UpdBatData(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		return;
	}
    var input=pid+"^"+UserDr;
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=UpdBatData&Input="+input,
       //dataType: "json",
       success: function(val){
            QueryDetail();
       }
    })
}

//清除临时global
function ClearTMP(){	
	if (CurKFlag=="0"){
		CurKFlag="";
		return;
	}
	var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		return;
	}
	var ret = tkMakeServerCall("web.DHCSTPIVABATUPDATE", "ClearTMP",pid);
}

//刷新tab
function RefTab(){
	$('#admdg').datagrid({
		url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:''}
	});
}