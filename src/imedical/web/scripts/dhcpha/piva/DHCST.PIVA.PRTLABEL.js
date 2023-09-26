/**
 * 模块:静脉打印标签
 * createdate:2015-12-15
 * creator:LiangQiang
 * scripts/dhcpha/piva/DHCST.PIVA.PRTLABEL.js
 */
var url = "DHCST.PIVA.ACTION.csp";
var PhLocDr=session['LOGON.CTLOCID'];
var UserDr=session['LOGON.USERID'];
var CurWardID="";
var CurAdm="";
var CurKFlag=""; // 是否清除
$(function(){
	InitDateBox();
	InitPhaLocGrp();
	InitPhInstList();
	InitWardList();
	InitPatNoList();
	InitOrdItmdgList();
	InitOrdItmSmdg();
	InitCurLabel();
	InitPhaLocBatBox(PhLocDr);
	$('#btnFind').bind("click",Query);  // 点击查询
    //$('#btnOk').bind("click",UpdBatData);
	$('#btnRef').bind("click",QueryDetail);
    $('#btnOk').bind("click",SaveDisp);
	$('#btnPack').bind("click",btnPackHandler);
	$('#btnCancelPack').bind("click",btnCancelPackHandler);
	//登记号
    $('#ByPatNo').bind('keypress',function(event){
        if(event.keyCode == "13")    {
            GetPatAdmList(); //调用查询
        }
    });
    $(".tabs-header").bind('click',function(){
		RefTab();
		CurKFlag=0; //控制不刷新
	})
    //离开
	window.onbeforeunload = function(){
		ClearTMP();
	}
});

function InitDateBox(){
	$("#DbSt").datebox("setValue", formatDate(0));  //Init起始日期
	$("#DBEnd").datebox("setValue", formatDate(0));  //Init结束日期
}

/// 初始化药房科室组
function InitPhaLocGrp(){	
	$('#LocGrpCombo').combobox({  
		panelWidth: 200,
		url:url+'?action=GetLocListByGrp&Input='+PhLocDr,  
		valueField:'rowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#LocGrpCombo').combobox('getData');
            if (data.length > 0) {
                  //$('#LocGrpCombo').combobox('select', data[0].rowId);
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

/// 初始化用法列表
function InitPhInstList(){
	$('#InstCombo').combobox({  
		panelWidth: 140,
		url:url+'?action=GetPhInstList',  
		valueField:'rowId',  
		textField:'Desc'
	});	
}

//初始化药品列表
function InitDrugDescDs(){	
	$('#InciCombo').combobox({  
		panelWidth: 140,
		valueField:'rowId',  
		textField:'Desc'
	});	
}

//初始化病人列表
function InitWardList(){
	//定义columns
	var columns=[[
		{field:'Select',checkbox:true },
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
		//pageSize:100,  // 每页显示的记录条数
		//pageList:[100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
		   CurWardID=rowData.WardID;
		   CurAdm="";
		   //QueryDetail();
        },
		singleSelect: false,
		selectOnCheck: true, 
		checkOnSelect: true

	});
    //initScroll("#warddg");
}

function InitPatNoList(){
	//定义columns
	var columnspat=[[
	    {field:'RegNo',title:'登记号',width:60},
	    {field:'CurrWard',title:'病区',width:100},
		{field:'Adm',title:'adm',width:60,hidden:true},
		{field:'AdmDate',title:'就诊日期',width:100},
		{field:'AdmTime',title:'就诊时间',width:100},
		{field:'AdmLoc',title:'就诊科室',width:100},		
		{field:'CurrWardID',title:'病区ID',width:100,hidden:true},
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

/// 初始化明细列表
function InitOrdItmdgList(){
	var columnspat=[[
		//{field:'TbSelect',checkbox:true },
        {field:"TbSttD",title:'用药时间',width:140},
		{field:'TbBatNo',title:'批次',width:50,
		  editor:{type:'validatebox',options:{required:'true'} }
		 },	
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
		{field:'TbPackState',title:'打包状态',width:60},
		{field:"TbPatNo",title:'登记号',width:85,hidden:true},
		{field:"TbMDsp",title:'TbMDsp',width:50,hidden:true},
		{field:'TbAdmcolor',title:'颜色',width:50,hidden:true},
		{field:'TbPID',title:'PID',width:50,hidden:true},
		{field:'TbDspStr',title:'TbDspStr',width:200,hidden:true}
	]];
	                                                          
	$('#ordtimdg').datagrid({
		url:'',
		fit:true,
		border:false,
		singleSelect:true,
		checkOnSelect: true,
		rownumbers:false,
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
		   GetCurBatInfo(MDsp);
	    }
	
	});
	$('#ordtimdg').datagrid('loadData',{total:0,rows:[]});
    //initScroll("#ordtimdg");
}

/// 初始化汇总列表
function InitOrdItmSmdg(){
	//定义columns
	var columnssum=[[
		{field:'TbDesc',title:'药品',width:230},
		{field:'TbQty',title:'数量',width:50},
		{field:'TbUom',title:'单位',width:50}
	]];
	                                                          
	//定义datagrid
	$('#ordtimsumdg').datagrid({
		url:'',
		fit:true,
		border:false,
		singleSelect:true,
		rownumbers:true,
		columns:columnssum,
		pageSize:300,  // 每页显示的记录条数
		pageList:[300,600],   // 可以设置每页记录条数的列表
		loadMsg: '正在加载信息...',
		pagination:true
	
	});
    //initScroll("#ordtimsumdg");
}

/// 当前瓶签
function InitCurLabel(){
	//定义columns
	var columnspat=[[
	    {field:'drug',title:'药品',width:180},
		{field:'freq',title:'频次',width:50},
		{field:'dose',title:'剂量',width:60},
		{field:'oeorestat',title:'执行记录状态',width:50,hidden:true}
		
	]];
	
	//定义datagrid
	$('#curlabeldg').datagrid({
		url:'',
		border:false,
		toolbar:'#curlabeldgbar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // 每页显示的记录条数
		//pageList:[40,80,120,160],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:false,
		rowStyler: function(index,row){
			if (row.oeorestat=="0"){
				return 'color:#ff0066;font-weight:bold';
			}
		},
	    onDblClickRow:function(rowIndex,rowData){
			//var pointer=rowData.CurrWardID;
			//QuerySubDb(inputs);
			//var AdmId=rowData.Adm;
			//QueryResult(pointer,AdmId)
		}
	});
	//initScroll("#curlabeldg");
}

/// 获取当前签信息
function InitPhaLocBatBox(PhLocDr){
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetPhaLocBatInfo&Input="+PhLocDr,
       //dataType: "json",
       success: function(val){
            var chkhtml="";
			var tmp=val.split("^");			
			for (i=1;i<=tmp.length;i++){
				 var batstr=tmp[i-1].split(",");
                 var batnoid=i ; //batstr[0];
                 var batnodesc=batstr[1];
				 var tmphtml='<span style="margin-left:10px;"><input style="vertical-align: text-bottom;" id="'+batnoid+'" class="ui-checkbox" name="batbox" type="checkbox" value='+batstr[0]+'>'+batnodesc+'</input></span>'
				 if (chkhtml==""){
                    chkhtml=tmphtml;
				 }else{
					chkhtml=chkhtml+tmphtml;
				 }
			}
			$("#DivBatNo").append(chkhtml);
       }
    })
}


/// 按登记号查询就诊列表
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
	$('#ByPatNo').val(RegNo);
	var params=RegNo;
	$('#admdg').datagrid({
	url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:params
		}
	});
}

/// 查询
function Query(){
	var params=GetParams();
	$('#warddg').datagrid({
		url:url+'?action=GetPrtWardList',	
		queryParams:{
			params:params
		}
	});
}

///获取入参
function GetParams(){
	var WardList="";
	var StDate=$('#DbSt').datebox('getValue');   //起始日期
	var EndDate=$('#DBEnd').datebox('getValue'); //截止日期
	var checkedItems = $('#warddg').datagrid('getChecked');
	$.each(checkedItems, function(index, item){
		if (WardList==""){
			WardList=item.WardID;
		}else{
			WardList=WardList+","+item.WardID;
		}	 
	}); 
    var LocGrpDr=$('#LocGrpCombo').combobox("getValue"); //科室组
	var InstId=$('#InstCombo').combobox("getValue"); //用法
	if (InstId==0){
		InstId=""
	}
	var params=PhLocDr+"^"+StDate+"^"+EndDate+"^"+WardList+"^"+CurAdm+"^"+LocGrpDr+"^"+InstId;
    var batlist="";  //批号
	$("input[type=checkbox][name=batbox]").each(function(){
		if($('#'+this.id).is(':checked')){
		    if (batlist==""){
			   batlist=this.value;
		    }else{
			   batlist=batlist+","+this.value;
		    }
		}
	})
	var prtedflag="";  //已打
	$("input[type=checkbox][name=PrtedBox]").each(function(){
		if($('#'+this.id).is(':checked')){
			prtedflag=this.value;
		}
	})
	var params=params+"^"+batlist+"^"+prtedflag;
	return params;
}

/// 查询医嘱
function QueryDetail(){
	ClearGrid();
	var params=GetParams();
	$('#ordtimdg').datagrid({
		url:url+'?action=GetPrtWardDetail',	
		queryParams:{
			params:params
		},
		onLoadSuccess: function(){
          	QuerySum();
	    }
	});
}

/// 查询医嘱
function QuerySum(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		return;
	}
	$('#ordtimsumdg').datagrid({
		url:url+'?action=GetPreStatData',	
		queryParams:{
			params:pid
		}
	});
}

/// 清空
function ClearGrid(){
    ClearTMP();
	$('#curlabeldg').datagrid('loadData',{total:0,rows:[]}); 
	$('#ordtimsumdg').datagrid('loadData',{total:0,rows:[]}); 
	//$('#ordtimdg').datagrid('loadData',{total:0,rows:[]}); 
	$('#CWard').val(''); //登记号
	$('#CBed').val(''); //病人名字 
	$('#CName').val('');
	$('#CSex').val('');
	$('#CAge').val('');
	$('#CWeight').val('');
	$('#CPatId').val('');
    $('#CDosDate').val('');
}

/// 获取当前签信息
function GetCurBatInfo(MDsp){
	/// 获取信息
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
	$('#curlabeldg').datagrid({
		url:url+'?action=GetCurPatBatDs',	
		queryParams:{
			params:MDsp
		}
	});	
}

/// 清除临时global
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
	var ret = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "ClearTMP",pid);
}

/// 打印标签
function SaveDisp(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		$.messager.alert('提示', '没有数据!', 'info'); 
		return;
	}
	if($('#PrtedBox').is(':checked')){
		$.messager.alert('提示', '补打标签请进入配液综合查询进行!', 'info'); 
		return;
	}
	$.messager.confirm('确认对话框', '确定打印吗？', function(r){
	  if (r){
		  ExeSave();
	    }
    });
}

/// 执行打印
function ExeSave(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	var prtedflag="";  //已打
	var arrChk=$("input[name='PrtedBox'][checked]");
	$(arrChk).each(function(){
	    prtedflag=this.value;	   
	});
    if (prtedflag=="Y"){
		var phac = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "GetPhacForRePrt",pid);
    }else{
		var input=pid+"^"+UserDr;
		var phac = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "SaveDisp",input);	
		QueryDetail();
	}
	if (phac!=""){
		PrintLabelDetail(phac);		
	}
}
/// 打印明细
function PrintLabelDetail(phac){
    var Hospname=tkMakeServerCall("web.DHCSTKUTIL","HospName");
    var retstr=tkMakeServerCall("web.DHCSTPIVAPRTLABEL","GetPrintItm",phac);
    if (retstr=="") return;
    var vstr=retstr.split("^")
    if (vstr.length<1) return;
    var pid=vstr[0]
    var pognums=vstr[1]
    if (pognums==0) return;
    if (pid=="") return;
    var i,j;
    var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
    for (i=1;i<=pognums;i++){
	    var pogstr=tkMakeServerCall("web.DHCSTPIVAPRINTLABEL","GetPogList",pid,i)
	    if (pogstr=="") return;
	    var pogistr=tkMakeServerCall("web.DHCSTPIVAPRINTLABEL","GetPogItmList",pid,i)
	    if (pogistr=="") return;
	    Bar.Device="PIVA";
	    Bar.PageWidth=65;
		Bar.PageHeight=90;
		Bar.HeadFontSize=12;
		Bar.FontSize=10;
		Bar.Title=Hospname+"输液单";
		Bar.HeadType="";
		Bar.IfPrintBar="true";
		Bar.BarFontSize=25;
		Bar.BarTop=5;
		Bar.BarLeftMarg=67;
		Bar.PageSpaceItm=2;
		Bar.ItmFontSize=10;
		Bar.ItmCharNums=30; //药名每行显示的字符数
		Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
		Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
		Bar.PageItmStr=pogistr;	// 打印标签药品信息
		Bar.PageLeftMargine=1;
		Bar.PageSpace = 1;
		Bar.BarWidth=14;
		Bar.BarHeight=14;
		//Bar.PageSpace = 1;
		if(i==pognums){
			Bar.PrintDPage("1");
		}else{
			Bar.PrintDPage("0");
		}	
    }
    return pid;
 }
//打包
function btnPackHandler(){
	UpdatePogFlag("P")
}
//取消打包
function btnCancelPackHandler(){
	UpdatePogFlag("N")
}
function UpdatePogFlag(pogflag){
	var selecteddata = $('#ordtimdg').datagrid('getSelected');
	var selectedrow=$('#ordtimdg').datagrid("getRowIndex",selecteddata);
	if (selecteddata==null){
		$.messager.alert("提示","请先选中数据!");
		return;
	}
	var dspstr=selecteddata["TbDspStr"];
	var tbpogstate=selecteddata["TbPackState"];
	var tmppogdesc=""
	if (pogflag=="P"){
		if (tbpogstate.indexOf("打包")>0){
			$.messager.alert("提示","当前为"+tbpogstate+"状态,无需再次打包!");
			return;
		}
		tmppogdesc="静配打包"
	}else if(pogflag=="N"){
		if (tbpogstate==""){
			$.messager.alert("提示","当前为未打包状态,无需取消!");
			return;
		}else if (tbpogstate=="护士打包"){
			$.messager.alert("提示","当前为护士打包状态,如需取消请护士登录系统操作!");
			return;
		}else if (tbpogstate=="二次打包"){
			$.messager.alert("提示","当前为二次打包状态,如需取消请护士登录系统操作!");
			return;
		}	
	}
	var packret=tkMakeServerCall("web.DHCSTPIVAPRTLABEL","UpdPogFlag",dspstr,pogflag); //根据打包表主id更新	
	if (packret=="0"){
		if (pogflag=="P"){			
			$.messager.alert("提示","打包成功!");
		}else if(pogflag=="N"){
			$.messager.alert("提示","取消打包成功!");	
		}
		$('#ordtimdg').datagrid('updateRow',{
			index: selectedrow,
			row: {TbPackState:tmppogdesc}
		})
	}else{
		$.messager.alert("提示",packret);
	}
}
//刷新tab
function RefTab(){
	$('#admdg').datagrid({
		url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:''
		}
	});
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		pid="-9"
	}
	$('#ordtimsumdg').datagrid({
		url:url+'?action=GetPreStatData',	
		queryParams:{
			params:pid
		}
	});
}