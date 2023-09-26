/*
模块:住院药房
子模块:住院药房-发药
createdate:2016-05-04
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var The_Time;
var dispCatPid=0;
var dispCatArr;
var wardIdStr="";
var paramStr=""; //住院药房配置
var phaLocDispCat=""; //本药房对应的类别
var CurKFlag=""; //处理切换标签触发onbeforeunload会清除global问题
$(function(){
	InitComputerMac();
	InitTitle();
	InitPhaLoc();
	InitWardList();
	InitLocGroup();
	InitDispWardList(); //初始化发药病区列表
	InitDispAdmList(); //初始化按登记号的列表
	InitDispList(); //初始化发药明细
	InitDispTotalList(); //初始化发药汇总
	InitCondition();
	$('#textInci').on('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#textInci").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#textInci"), input,getDrugList);
            mydiv.init();
		 }else{
			$("#textInciRowId").val("");	
		 }	
	 }
	});
	$('#patNo').on('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });
    $('#checkedTime').on('click',function(){
		$("input[type=checkbox][id=checkedTime]").each(function(){
			if($('#'+this.id).is(':checked')){
				The_Time=setInterval("QueryDispWardList();", 30000);
			}
			else{
				clearInterval(The_Time) 
			}
		})
    });
    $('#checkedLocal').on('click',function(){
		$("input[type=checkbox][id=checkedLocal]").each(function(){
			SetLocalConfig(this.id)
		})
    });
    $("input[type=checkbox][name=checkedCondition]").on('click',function(){
		SetConditionCheck(this.id)		
    });
	$('#btnFind').on("click",QueryDispWardList); 
	$('#btnFindSum').on("click",QuerySelectDispList); 
	$('#btnRefuse').on("click",btnRefuseHandler); 
	$('#btnDisp').on("click",btnDispHandler);
	$('#btnCollect').on("click",function(){
		CollectHandler();
	}); 
	$('#btnFindDisped').on("click",function(){
		var lnk="dhcpha.dispquery.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$('#tabsone').tabs({   
      border:false,   
      onSelect:function(title){   
          if (title=="发药汇总"){
		  	RefTabOne();
	      }
	      CurKFlag=0;
      }   
  	});  
	$('#tabstwo').tabs({   
      border:false,   
      onSelect:function(title){   
		  RefTabTwo();
		  ClearDispGrid();
      }   
  	}); 
});
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){
		    var selectLoc=$('#phaLoc').combobox("getValue")
			var newcolumns=getPhaLocDispType(selectLoc);
	        var options = $("#dispwardgrid").datagrid("options");                   //取出当前datagrid的配置     
	        options.columns =[newcolumns];    
	        options.queryParams.params = "";                                            
	        $("#dispwardgrid").datagrid(options);                                        
	        $("#dispwardgrid").datagrid("reload");
	        $('#locGroup').combobox('reload',commonInPhaUrl+'?action=GetLocGroupDs&locId='+selectLoc); 
	        GetPhaLocConfig(selectLoc);  
		}
	});
}
function InitWardList()
{
	$('#wardLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetWardLocDs',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	});

}
function InitLocGroup()
{
	$('#locGroup').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetLocGroupDs&locId='+gLocId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	});

}
function InitDispWardList(){
	//定义columns
	var newcolumns=getPhaLocDispType(gLocId)
	//定义datagrid
	$('#dispwardgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		nowrap:false,
		columns:[newcolumns],
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:30,  // 每页显示的记录条数
		pageList:[30,50,100],   // 可以设置每页记录条数的列表
		//pagination:true,
		onLoadSuccess: function(){
 	
	    },
		onClickCell: function (rowIndex, field, value) {
			if (field!="TSelect"){
				if (field!="TWard"){
					var tmpcheck=""
					if (value=="Y"){tmpcheck="N"}
					else{tmpcheck="Y"}
					// 得到columns对象
					var columns = $('#dispwardgrid').datagrid("options").columns;
					var columnsstr=$('#dispwardgrid').datagrid('getColumnFields',false);
					var columni=columnsstr.indexOf(field);
					// 得到rows对象
					var rows = $('#dispwardgrid').datagrid("getRows"); // 对某个单元格赋值
					rows[rowIndex][columns[0][columni].field]=tmpcheck;
					$('#dispwardgrid').datagrid('refreshRow', rowIndex);
				}
				wardIdStr=""
				dispCatArr=""
				var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmp",dispCatPid);
				dispCatPid=tkMakeServerCall("web.DHCSTPCHCOLLS","NewPid");
				var selecteddata=$('#dispwardgrid').datagrid('getData').rows[rowIndex];
				SaveCatList(selecteddata)
				wardIdStr=selecteddata["TWardRowid"]
				var params=GetQueryDispParams(selecteddata)
				var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
				var tabtwotitle=tabtwoselect.panel('options').title;
				if (tabtwotitle=="按病区"){
					if (dispCatArr==""){
						$.messager.alert('提示',"请至少选择一个发药类别!");
						params=""
					}
				}
				QueryDisp(params);
			}
			else{
				var tmpcheck=""
				if (value=="Y"){tmpcheck="N"}
				else{tmpcheck="Y"}
				$('#dispwardgrid').datagrid('updateRow',{
					index: rowIndex,
					row: {TSelect:tmpcheck}
				})
			}
		}
	});
	//$('#dispwardgrid').gridupdown($('#dispwardgrid'));
}
function renderAsCheckBox(value,row,index){
	if (value=="Y"){	
		return '<input type="checkbox" name="DataGridCheckbox" checked="checked">';
	}
	else{
		return '<input type="checkbox" name="DataGridCheckbox">';
	}
}
function InitDispList(){
	//定义columns
	var columns=[[
		{field:'TSelect',title:'<a id="TDispSelect" href="#" onclick="SetSelectAll()">全消</a>',width:30,
			formatter:function(value,row,index){
				if ((value=="")||(value=="Y")||(value==undefined)){
					return '<input type="checkbox" name="DispDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="DispDataGridCheckbox" >';
				}
			}
		},
		{field:"TPID",title:'TPID',width:80,hidden:true},		
		{field:"TAdmLoc",title:'科室',width:125,
			formatter:function(value,row,index){
				if (value.indexOf("-")){
					return value.split("-")[1];
				}else{
					return value;
				}
			}
		},	
		{field:"TBedNo",title:'床号',width:80},	
		{field:"TUrgent",title:'加急',width:35,align:'center',
			formatter:function(value,row,index){
				if (value=="Y"){
					return '<font color="red" size="3"><b>' + value + '</b></font>';
				}
			}
		},
		{field:"TPaName",title:'姓名',width:80},
		{field:"TRegNo",title:'登记号',width:80,
			formatter:function(value,row,index){
				return "<a href='#' onclick='showSkinTestWindow("+index+")'>"+value+"</a>";
			}},
		{field:"TDesc",title:'药品名称',width:200},		
		{field:"TQty",title:'数量',width:50},		
		{field:"TUom",title:'单位',width:50},		
		{field:"TSalePrice",title:'售价',width:70,align:'right'},		
		{field:"TOrdStatus",title:'医嘱状态',width:60},		
		{field:"TPhaCat",title:'类别',width:80},		
		{field:"TDoseQty",title:'剂量',width:60},		
		{field:"TFreq",title:'频率',width:60},		
		{field:"TInstruction",title:'用法',width:80},	
		{field:"TDuration",title:'疗程',width:80},		
		{field:"TPrescNo",title:'处方号',width:90},		
		{field:"TAudited",title:'医嘱审核',width:80},		
		{field:"TGeneric",title:'通用名',width:150},		
		{field:"TForm",title:'剂型',width:100},	
		{field:"TBarcode",title:'规格',width:80},		
		{field:"TManufacture",title:'厂家',width:150,
			formatter:function(value,row,index){
				if (value.indexOf("-")){
					return value.split("-")[1];
				}else{
					return value;
				}
			}
		},
		{field:"TIncStk",title:'货位',width:100},	
		{field:"TAmt",title:'金额',width:80,align:'right'},	
		{field:"TUserAdd",title:'开方医生',width:60},			
		{field:"TTimeAdd",title:'计划用药时间',width:130},		
		{field:"TDiagnose",title:'诊断',width:200},	
		{field:"TAge",title:'年龄',width:60},			
		{field:"Tsex",title:'性别',width:60},	
		{field:"Taction",title:'备注',width:80},			
		{field:"TEncryptLevel",title:'病人密级',width:80},	
		{field:"TPatLevel",title:'病人级别',width:80},	
		{field:"TTimeDosing",title:'分发时间',width:80},	
		{field:"Tcooktype",title:'煎药方式',width:80},
		{field:"Tseqno",title:'医嘱关联',width:80},
		{field:"Tbill",title:'是否欠费',width:80},
		{field:"TInsuType",title:'医保类别',width:75},
		{field:"TinciQty",title:'库存不足',width:60,hidden:true},		
		{field:"Tstr",title:'Tstr',width:80,hidden:true},
		{field:"TMainOrd",title:'TMainOrd',width:80,hidden:true},
		{field:"TDispIdStr",title:'TDispIdStr',width:80,hidden:true},
		{field:"TColType",title:'TColType',width:80,hidden:true},
		{field:"Toedis",title:'Toedis',width:80,hidden:true},
		{field:"TBatchNo",title:'批号',width:80,hidden:true},
		{field:"TarcEndDate",title:'医嘱截止日期',width:80,hidden:true},
		{field:"TarcEndDateFlag",title:'TarcEndDateFlag',width:80,hidden:true}								
	]];
	//定义datagrid
	$('#dispgrid').datagrid({
		border:false,
		url:commonInPhaUrl+'?action=jsQueryDispList',
		fit:true,
		//rownumbers:true,
		nowrap:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//chectOnCheck: true, 
		//checkOnSelect: true,
		pageSize:100,  // 每页显示的记录条数
		pageList:[100,300,500],   // 可以设置每页记录条数的列表
		pagination:true,
		onLoadSuccess: function(){
 			$("#TDispSelect").text("全消")
	    },
	    onBeforeLoad:function(param){
			KillTmpBeforeLoad();
		},
		rowStyler: function(index,row){
		        if (row.TarcEndDateFlag=="1"){
                    return 'color:#ff0066;font-weight:bold';
                }
				if (row.TinciQty!="1"){
                    return 'color:#00cc00;font-weight:bold';
                }

		},
	    onSelect:function(rowIndex,rowData){
	    },
	  	onClickCell: function (rowIndex, field, value) {
			if (field=="TSelect"){
				var tmpcheckvalue=""
				if (value=="Y"){tmpcheckvalue="N"}
				else{tmpcheckvalue="Y"}
				$('#dispgrid').datagrid('updateRow',{
					index: rowIndex,
					row: {TSelect:tmpcheckvalue}
				})				
				var selecteddata=$('#dispgrid').datagrid('getData').rows[rowIndex];
				Savetofitler(selecteddata)
				//关联医嘱选中
				SelectLinkOrder(rowIndex)
			}
		}

	});

	initScroll("#dispgrid"); //此初始化会导致默认行数是1
	//$('#dispwardgrid').gridupdown($('#dispwardgrid'));
}

function SetSelectAll()
{
	var dispgridrowsdata=$('#dispgrid').datagrid("getRows");
	var dispgridrows=dispgridrowsdata.length;
	if (dispgridrows<=0){
		return;
	}
	var tmpSelectFlag=""
	if($("#TDispSelect").text()=="全选"){
		$("#TDispSelect").text("全消")
		tmpSelectFlag="Y"
		//$("input[type=checkbox][name=DispDataGridCheckbox]").attr('checked',true)
	}else{
		$("#TDispSelect").text("全选")
		tmpSelectFlag="N"
		//$("input[type=checkbox][name=DispDataGridCheckbox]").attr('checked',false)
	}
	var columns = $('#dispgrid').datagrid("options").columns;
	var columnsstr=$('#dispgrid').datagrid('getColumnFields',false);
	var columni=columnsstr.indexOf("TSelect");
	$.each(dispgridrowsdata, function(index, item){
		dispgridrowsdata[index][columns[0][columni].field]=tmpSelectFlag;
		$('#dispgrid').datagrid('refreshRow', index);
		var selecteddata=$('#dispgrid').datagrid('getData').rows[index];
		Savetofitler(selecteddata)
	})
}
function InitDispTotalList(){
	//定义columns
	var columns=[[
		{field:"TDesc",title:'药品名称',width:200},
		{field:"TQty",title:'数量',width:60},
		{field:"TUom",title:'单位',width:60},
		{field:"TSp",title:'售价',width:80,align:'right'},
		{field:"TAmt",title:'金额',width:80,align:'right'},
		{field:"TDrugForm",title:'剂型',width:100},
		{field:"TQtyBed",title:'数量/床号',width:80},
		{field:"TBarcode",title:'规格',width:100},
		{field:"TManufacture",title:'厂家',width:150,
			formatter:function(value,row,index){
				if (value.indexOf("-")){
					return value.split("-")[1];
				}else{
					return value;
				}
			}
		},
		{field:"TIncstk",title:'货位',width:100},
		{field:"TGeneric",title:'通用名',width:150}
		
	]];
	//定义datagrid
	$('#disptotalgrid').datagrid({
		border:false,
		url:commonInPhaUrl+'?action=jsQueryDispTotalList',
		fit:true,
		rownumbers:true,
		nowrap:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:100,  // 每页显示的记录条数
		pageList:[100,300,500],   // 可以设置每页记录条数的列表
		pagination:true,
		onLoadSuccess: function(){
 	
	    },
	    onSelect:function(rowIndex,rowData){
		   
	    }

	});
	//$('#dispwardgrid').gridupdown($('#dispwardgrid'));
}
function InitDispAdmList()
{
	
	//定义columns
	var columnspat=[[
		{field:'Adm',title:'adm',width:60,hidden:true},
		{field:'CurrWard',title:'病区',width:150},
		{field:'AdmDate',title:'就诊日期',width:80},
		{field:'AdmTime',title:'就诊时间',width:80},
		{field:'AdmLoc',title:'就诊科室',width:150},
		{field:'CurrentBed',title:'床号',width:100}
	]];
	
	//定义datagrid
	$('#dispadmgrid').datagrid({
		url:commonInPhaUrl+'?action=QueryDispAdmList',
		toolbar:'#patconditiondiv',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columnspat,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
				var selecteddata=$('#dispadmgrid').datagrid('getData').rows[rowIndex];
				var params=GetQueryDispParams(selecteddata)
				QueryDisp(params);
		}
	});
}

function getPhaLocDispType(phaLocId)
{
	phaLocDispCat=""
	var columns=new Array();
	var column={};
	column.title="TWardRowid";
	column.field="TWardRowid";
	column.hidden=true;
	columns.push(column);
	column={};
	column.title="病区";
	column.field="TWard";
	column.width=150;
	columns.push(column);
	column={};
	column.title="选择";
	column.field="TSelect";
	//column.checkbox=true;
	//ormatter:function(value,row,index){
	column.formatter=renderAsCheckBox
	column.width=35;
	
	columns.push(column);
	column={};
	var dispcatsstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaLocDispType",phaLocId);
	var dispcatsarr=dispcatsstr.split("^");
	var dispcatslength=dispcatsarr.length;
	var dispcatsi=0
	for (dispcatsi=0;dispcatsi<dispcatslength;dispcatsi++){
		column={};
		var dispcatsdescarr=dispcatsarr[dispcatsi].split("@");
		var dispcatsdesc=dispcatsdescarr[1];
		if (dispcatsdesc=="") {continue;}
		var newdispcatdesc=dispcatsdesc.substring(0,2)+"</br>"+dispcatsdesc.substring(2,4)
		if(dispcatsdesc.length>4){
			var newdispcatdesc=newdispcatdesc+"</br>"+dispcatsdesc.substring(4,6)
		}
		var dispcatscode=dispcatsdescarr[0];
		if (phaLocDispCat==""){phaLocDispCat=dispcatscode}
		else{phaLocDispCat=phaLocDispCat+"^"+dispcatscode}
		column.title=newdispcatdesc;
		column.field=dispcatscode;
		column.formatter=renderAsCheckBox
		columns.push(column);
	}
	return columns
}
function InitCondition(){
	//$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	//$("#endDate").datebox("setValue", formatDate(0));  //Init结束日期 
}
function InitTitle(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//提交到那里 后他的服务  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
			}   
		},    
		error:function(){        
			alert("获取登记号长度失败!");
		}
	});
	GetPhaLocConfig(gLocId);

}
function GetPhaLocConfig(locRowId){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonInPhaUrl+'?action=GetInPhaConfig&gLocId='+locRowId,//提交到那里 后他的服务  
		data: "",
		success:function(value){   
			if (value!=""){
				SetPhaLocConfig(value)
			}   
		},    
		error:function(){        
			alert("获取住院药房配置数据失败!");
		}
	});
}
function QueryDispWardList(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var phaLoc=$('#phaLoc').combobox("getValue")
	if ($('#phaLoc').combobox("getText")==""){phaLoc=""}
	if (phaLoc==""){
		$.messager.alert('错误提示',"药房不允许为空!");
		return;
	}
	var wardLoc=$('#wardLoc').combobox("getValue");
	if ($('#wardLoc').combobox("getText")==""){wardLoc=""}
	var locGroupId=$('#locGroup').combobox("getValue");
	if ($.trim($('#locGroup').combobox("getText"))==""){
		locGroupId=""
	}
	var priority=$("#priority").val();
	var params=startDate+"!!"+startTime+"!!"+endDate+"!!"+endTime+"!!"+phaLoc+"!!"+wardLoc+"!!"+locGroupId+"!!"+priority;
	$('#dispwardgrid').datagrid({
		url:commonInPhaUrl+'?action=QueryDispWardList',	
		queryParams:{
			params:params}
	});
}
 //查询选择病区的发药明细
function QuerySelectDispList(){
	var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
	var tabtwotitle=tabtwoselect.panel('options').title;
	if (tabtwotitle=="按病区"){
		var dispwardgridrowsdata=$('#dispwardgrid').datagrid("getRows");
		var dispwardgridrows=dispwardgridrowsdata.length;
		if (dispwardgridrows<=0){
			return;
		}
		var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmp",dispCatPid);
		dispCatPid=tkMakeServerCall("web.DHCSTPCHCOLLS","NewPid");
		wardIdStr=""
		$.each(dispwardgridrowsdata, function(index, item){
			if(item["TSelect"]=="Y"){
				if (wardIdStr==""){wardIdStr=item["TWardRowid"];}
				else{wardIdStr=wardIdStr+"^"+item["TWardRowid"];}
				SaveCatList(item)				
			}
		})
		var params=GetQueryDispParams(dispwardgridrowsdata[0])  //传过去值判断不是按登记号
		QueryDisp(params);
	}
	else{
		$.messager.alert('提示',"仅按病区发药时可以选择!");
		return;	
	}

}
//查询发药就诊信息
function QueryDispAdmList(){
	var patNo=$("#patNo").val();
	var params=patNo
	$('#dispadmgrid').datagrid({
		queryParams:{
			params:params}
	});
}
//查询发药信息
function QueryDisp(params){
	$('#dispgrid').datagrid('loadData',{total:0,rows:[]}); 
    $('#dispgrid').datagrid('options').queryParams.params = params;//传递值  
    $("#dispgrid").datagrid('reload');//重新加载table  
}
function GetQueryDispParams(selecteddata){
	var wardLoc=wardIdStr;
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入开始日期!");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var phaLoc=$('#phaLoc').combobox("getValue")
	if ($('#phaLoc').combobox("getText")==""){phaLoc=""}
	if (phaLoc==""){
		$.messager.alert('错误提示',"药房不允许为空!");
		return;
	}
	var inciRowId=$("#textInciRowId").val()
	if ($.trim($("#textInci").val())==""){inciRowId=""}
	var ByWardFlag=""
	var pri=$("#priority").val();
	var dispCats=dispCatArr+"#"+pri+"#"+dispCatPid;
	var adm=selecteddata["Adm"]
	if(adm==undefined){adm=""} //按病区
	else{
		wardLoc=""
		if (phaLocDispCat==""){
			$.messager.alert('错误提示',"药房发药类别为空,请重进!");
			return;
		}
		dispCats=phaLocDispCat+"#"+pri
	}
	var DoctorLocRowid=""
	var NotAudit=""
	var OutOrdFlag=0,longOrdFlag=0,shortOrdFlag=0,isPackFlag="",emOrdFlag="NOEmOrd"
	if ($('#checkedOut').is(':checked')){OutOrdFlag=1}
	if ($('#checkedLong').is(':checked')){longOrdFlag=1}
	if ($('#checkedShort').is(':checked')){shortOrdFlag=1}
	if ($('#checkedIsPack').is(':checked')){isPackFlag="ISPACK"}
	if ($('#checkedNotPack').is(':checked')){isPackFlag="NOPACK"}
	if ($('#checkedEMY').is(':checked')){emOrdFlag="EmOrd"}
	var shortOrdFlagStr=shortOrdFlag+"||"+emOrdFlag+"||"+isPackFlag
	var params=phaLoc+"!!"+wardLoc+"!!"+startDate+"!!"+endDate+"!!"+gUserId+"!!"+
			   ByWardFlag+"!!"+longOrdFlag+"!!"+shortOrdFlagStr+"!!"+OutOrdFlag+"!!"+dispCats+"!!"+
			   adm+"!!"+DoctorLocRowid+"!!"+NotAudit+"!!"+startTime+"!!"+endTime+"!!"+inciRowId
	return 	params;

}
function SaveCatList(selecteddata){				
	var wardLoc=selecteddata["TWardRowid"];
	var columnsstr=$('#dispwardgrid').datagrid('getColumnFields',false);
	var dispcatsstr=""
	var columnslength=columnsstr.length;
	for (var columni=0;columni<columnslength;columni++){
		var columnname=columnsstr[columni]
		if ((columnname=="TWardRowid")||(columnname=="TWard")||(columnname=="TSelect")){
			continue;
		}
		if (selecteddata[columnname]=="Y"){
			if (dispcatsstr==""){dispcatsstr=columnname}
			else{dispcatsstr=dispcatsstr+"^"+columnname}
		}
	}
	dispCatArr=dispcatsstr
	var savecatret=tkMakeServerCall("web.DHCSTPCHCOLLS","SaveCatListByWard",wardLoc,dispcatsstr,dispCatPid);
	
}
function SetPatInfo(RegNo)
{    
	if (RegNo=="") {
		return;
	}
	var patLen = hisPatNoLen;
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('提示',"登记号输入错误！","warning");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patNo").val(RegNo);
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonInPhaUrl+'?action=GetPatInfoByNo&patNo='+RegNo,//提交到那里 后他的服务  
		data: "",
		success:function(value){     
			if ($.trim(value)!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					var patInfoText="姓名:"+painfoarr[0]+"　性别:" +painfoarr[1] + "　出生日期:" +painfoarr[2]+"("+painfoarr[3]+")";
					$("#patInfo").text(patInfoText)
				}
				QueryDispAdmList();
			}else{
				$.messager.alert('提示',"不存在该病人！","info");
				return;
			}   
		},    
		error:function(){        
			alert("获取病人基础数据失败!");
		}
	});
}
function Savetofitler(selectrowdata)
{
	//暂时保存发药时没有选择的医嘱Rowid
	var tdispstr=selectrowdata["TDispIdStr"];
	var tpid=selectrowdata["TPID"];
	var selected=selectrowdata["TSelect"];
	if (selected=="Y"){selected="D";}
	else{selected="S";}
	if ((tpid!="")&&(tpid!=undefined)){
		var saveret=tkMakeServerCall("web.DHCSTPCHCOLLS","SaveToFilter",tpid,tdispstr,selected)
	}
}
 //关联医嘱选中
function SelectLinkOrder(selectrow){
	var selecteddata=$('#dispgrid').datagrid('getData').rows[selectrow];
	var tmpselect=selecteddata["TSelect"]
	var toedis=selecteddata["Toedis"];
	var orderlinkret=CheckOrderLink(toedis).split("%");
	var oeoricnt=orderlinkret[0] 
	if (oeoricnt>0){
		var mainoeori=selecteddata["TMainOrd"]; //主医嘱id
		var dodisdate=selecteddata["TTimeAdd"]
		var mainindex=mainoeori+"^"+dodisdate
		var dispgridselect=$('#dispgrid').datagrid("getRows");
		var dispgridrows=dispgridselect.length;
		for(var i=0;i<dispgridrows;i++){
			var tmpselecteddata=dispgridselect[i];
			var tmpmainoeori=tmpselecteddata["TMainOrd"]
			var tmpdodisdate=tmpselecteddata["TTimeAdd"]
			var tmpmainindex=tmpmainoeori+"^"+tmpdodisdate;
			if (mainindex==tmpmainindex){
				$('#dispgrid').datagrid('updateRow',{
					index: i,
					row: {TSelect:tmpselect}
				})
				var newselectdata=$('#dispgrid').datagrid('getData').rows[i];
				Savetofitler(tmpselecteddata)
			}
		}
	}
}
 //判断是否为关联医嘱
function CheckOrderLink(oedisstr){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLS","CheckLinkOeord",oedisstr)
	return ret;
}
//拒绝发药
function btnRefuseHandler(){
	var taboneselect=$('#tabsone').tabs('getSelected'); 
	var tabonetitle=taboneselect.panel('options').title;
	if (tabonetitle!="发药明细"){
		$.messager.alert('提示',"请在选项卡选择发药明细后选择拒绝发药!!");
		return;
	}
	var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
	if(selecteddata["TPID"]==""){
		$.messager.alert('提示',"没有明细!");
		return;
	}
	if (!confirm("是否确认拒绝发药?")){return;}
	var ordArr = new Array(); 	
	var dispgridselect=$('#dispgrid').datagrid("getRows");
	var dispgridrows=dispgridselect.length;
	for(var i=0;i<dispgridrows;i++){
		var tmpselecteddata=dispgridselect[i];
		var tmpselect=tmpselecteddata["TSelect"];
		if (tmpselect!="Y"){continue;}
		var tmpdispidstr=tmpselecteddata["TDispIdStr"];
		if(!ordArr.contains(tmpdispidstr)){
			ordArr.push(tmpdispidstr)
		}
	}
	if (ordArr.length==0){
		$.messager.alert('提示',"请选择需要拒绝发药的明细!");
		return;
	}
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason','','dialogHeight:550px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
	if (!resondr) return;
	if (resondr!="")
	{
	   var restmp=resondr.split("^")
	   resondr=restmp[0]
	   resondesc=restmp[1]
	}
	tkMakeServerCall("web.DHCSTPCHCOLLS","InsertDrugRefuse",ordArr.join("^"),gUserId,resondr)
	$("#dispgrid").datagrid("reload");
	
}
//发药
function btnDispHandler(){
	var dispuser=""
	var operateuser=""
	var phaLoc=$('#phaLoc').combobox("getValue")
	var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
	var tabtwotitle=tabtwoselect.panel('options').title;
	var taboneselect=$('#tabsone').tabs('getSelected'); 
	var tabonetitle=taboneselect.panel('options').title;
	if (tabonetitle!="发药明细"){
		$.messager.alert('提示',"请在选项卡选择发药明细后选择发药!!");
		return;
	}
	var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
	var pid=selecteddata["TPID"]
	if(pid==""){
		$.messager.alert('提示',"没有明细!");
		return;
	}
	if (phaLocDispCat==""){
		$.messager.alert('提示',"药房发药类别为空,请重进!");
		return;
	}
	if (!confirm("是否确认发药?")){return;}
	if (tabtwotitle!="按病区"){
		var selectedadmdata = $('#dispadmgrid').datagrid('getSelected');
		var adm=selectedadmdata["Adm"]
		var billret=tkMakeServerCall("web.DHCSTPCHCOLLS","RetBillControl",pid,adm)
		if (billret=="N"){
			$.messager.alert('提示',"该病人已欠费!");
			return;
		}
	}
	//取是否录入发药人配置
	if (paramStr!="")
	{
		var tmparr=paramStr.split("^");
		var dispuserflag=tmparr[17];
		var operaterflag=tmparr[21];
		if (dispuserflag=="Y"){
			var dispuser=window.showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phauserdialog&grp='+gGroupId,"_target",'dialogHeight:450px;dialogWidth:350px;center:yes;help:no;resizable:no;status:no;scroll:no;')
			if (dispuser==""){
				$.messager.alert('提示',"请选择发药人后重试!");
				return;
			}
	    }
	   	if (operaterflag=="Y"){
		   	var operateuser=window.showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaoperaterdialog&grp='+gGroupId,"_target",'dialogHeight:450px;dialogWidth:350px;center:yes;help:no;resizable:no;status:no;scroll:no;')
			if (operateuser==""){
				$.messager.alert('提示',"请选择摆药人后重试!");
				return;
			} 
	    }
	}
	//出院带药发药
	if ($('#checkedOut').is(':checked')){
		DispOutOrder(pid,dispuser,operateuser,phaLoc);
		return;
	}
	//正常发药
	catarr=phaLocDispCat.split("^")
   	var phacrowidStr=""
   	var wardArr=wardIdStr.split("^");
 	for (var wardi=0;wardi<wardArr.length;wardi++){
	   	var wardid=wardArr[wardi]
	   	if (tabtwotitle=="按病区"){
			var catstr=tkMakeServerCall("web.DHCSTPCHCOLLS","GetWardDispType",dispCatPid,wardid); //js里直接调用类的方法
   		    catarr=catstr.split("^");
		}
		for (var cati=0;cati<catarr.length;cati++){
			var cat=catarr[cati];
			if(cat==""){return;}
			var PhacRowid=SaveDispensing(cat,pid,phaLoc,wardid,dispuser,operateuser) ;
			if (PhacRowid>0){
				if(phacrowidStr!=""){
					phacrowidStr=phacrowidStr+"A"+PhacRowid;		
				}else{
					phacrowidStr=PhacRowid;					
				}
			}else if (PhacRowid<0){
				alert("发药类别:"+GetDispCatNameByCode(cat) + ","+PhacRowid) ;
			}
		}
 	}
 	GetTipsOfNoStock(pid);
 	if ((phacrowidStr=="")||(phacrowidStr==0)){
 		alert("未发出药品!") ;
 		return;
 	}
 	//冲减退药
	if ($('#checkedReserve').is(':checked')){
		var reserveret=tkMakeServerCall("web.DHCSTPCHCOLLS","ExeRetAfterDisp",pid,phacrowidStr,gUserId)
	}
	if (confirm("是否打印"))
	{
		PrintReport(phacrowidStr,pid);
	}
	//发药机
	SendOrderToMachine(phacrowidStr);
	killTmpAfterSave(pid);
	$("#TDispSelect").text("全消")
	$("#dispgrid").datagrid("reload");
}
 //出院带药发药
function DispOutOrder(pid,dispuser,operateuser,phaLoc){
	if (pid==""){return;}
	var ss=[];
    var outdrugPhacs=""
    var outdrugPhastr=""
	var wardArr=wardIdStr.split("^");
	var catarr=phaLocDispCat.split("^")
	for (var wardi=0;wardi<wardArr.length;wardi++){
	   	var wardid=wardArr[wardi]
		for (var cati=0;cati<catarr.length;cati++){
			var cat=catarr[cati];
			var PhacRowid=SaveDispensing(cat,pid,phaLoc,wardid,dispuser,operateuser) ;
			if (PhacRowid>0 ){  
				if (outdrugPhacs=="") {outdrugPhacs=PhacRowid}
				else {outdrugPhacs=outdrugPhacs+"^"+PhacRowid }
			}
			if (PhacRowid<0){	
			    alert("发药类别:"+GetDispCatNameByCode(cat) + ",发药失败,错误代码:"+PhacRowid) ;
			} 
		}
   	}
   	GetTipsOfNoStock(pid);
	killTmpAfterSave(pid);
	if (outdrugPhacs==""){
		$("#dispgrid").datagrid("reload");
		return;
	}
	var pcods=tkMakeServerCall("web.DHCSTPCHCOLLOUT","CreateOutDrugRecords",phaLoc,gUserId,outdrugPhacs)
	if (pcods==""){return ;}
	var outdrugPhastr=""
	var outdrugPhacsArr=outdrugPhacs.split("^")
	if (outdrugPhacsArr.length>=0){
		for (var outi=0;outi<outdrugPhacsArr.length;outi++){
			if (outdrugPhastr==""){OutString=outdrugPhacsArr[outi]}
			else{outdrugPhastr=outdrugPhastr+"A"+outdrugPhacsArr[outi]}
		}
		PrintReport(outdrugPhastr,pid)  ; 
	}
	$("#dispgrid").datagrid("reload");
}
function SaveDispensing(dispcat,pid,phaLoc,wardid,dispuser,operateuser){
	var PhacRowid=tkMakeServerCall("web.DHCSTPCHCOLLS","SAVEDATA","","",dispcat,pid,dispuser,operateuser,'',phaLoc,wardid) ;
	return PhacRowid ;  
}
function SendOrderToMachine(phacStr){
	if (paramStr!=""){
		var tmparr=paramStr.split("^");
		var sendflag=tmparr[31];
		if (sendflag=="Y"){
			var senderr=0
			phacArr=phacStr.split("A");	
			for(var phaci=0;phaci<phacArr.length;phaci++){
				var phac=phacArr[phaci].split("B");
			    var pharowid=phac[0]
				var sendret=tkMakeServerCall("web.DHCSTInterfacePH","SendOrderToMechine",pharowid)
			    if (sendret!=0){
				    var retString=sendret
				    var senderr=1
			    }
			}
			if (senderr=="1"){
				$.messager.alert("错误提示","发送包药机失败!请注意核实!"+retString)
				return;
			}
		}
	}
}
function GetDispCatNameByCode(catcode){
	var dispcatname=tkMakeServerCall("web.DHCINPHA.InfoCommon","GetDispCatDescByCode",catcode)
	return dispcatname;
}
function GetTipsOfNoStock(pid){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLS","GetTipsOfNoStock",pid);
	if (ret!=""){alert(ret+"  库存不足,导致对应关联医嘱无法发药！")}
}
function killTmpAfterSave(pid)
{
	tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmpAfterSave","","",pid)
}
function PrintReport(phacstr,pid){
	PrintRep(phacstr,"",pid,"")
}
//加载药房配置
function SetPhaLocConfig(configstr){
	paramStr=configstr
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	var notwardrequired=configarr[0];
	var auditneed=configarr[10];
	var retflag=configarr[11]; 
	var dispuserflag=configarr[17];
	var operaterflag=configarr[21];
	var aduitBillflag=configarr[22];
	var disptypelocalflag=configarr[23];
	var displayemyflag=configarr[24];
	var displayoutflag=configarr[25];
	var lsflag=configarr[26];
	var reqwardflag=configarr[27];
	var dispdefaultflag=configarr[28];
	InitDateBox("startDate",startdate)
	InitDateBox("endDate",enddate)
	if(retflag=="Y"){
		$('#checkedReserve').attr('checked',true); 
	}else{
		$('#checkedReserve').attr('checked',false); 
	}
	if(dispdefaultflag=="0"){
		$('#checkedShort').attr('checked',true); 
	}else if(dispdefaultflag=="1"){
		$('#checkedLong').attr('checked',true);
	}else{
		$('#checkedShort').attr('checked',false); 
		$('#checkedLong').attr('checked',false);
	}
}
 //登记号链接,yunhaibao,20160615,直接传value不知道传过来的是什么
function showSkinTestWindow(indexrow){
	var dispselectdata=$('#dispgrid').datagrid('getData').rows[indexrow];
	var regNo=dispselectdata["TRegNo"];
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.getskintest&RegNo="+regNo;
	window.open(lnk,"皮试记录","height=300,width=400,menubar=no,status=yes,toolbar=no,resizable=yes") ;
}
function InitDateBox(dateid,datenum){
	var newdatenum=0;
	datenum=datenum.toUpperCase();
	if (datenum.indexOf("T")>=0){
		if (datenum=="T"){newdatenum=0}
		else{
			newdatenum=datenum.substring(1,datenum.length)
		}
	}
	$("#"+dateid).datebox("setValue", formatDate(newdatenum));
} 
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#textInci").val(returndata["InciDesc"]);
		$("#textInciRowId").val(returndata["Inci"]);
	}
	else{
		$("#textInci").val("");
		$("#textInciRowId").val("");
	}
}
 //处理勾选
function SetConditionCheck(checkboxid){
	var boolchecked=""
	if ($('#'+checkboxid).is(':checked')){
		boolchecked="1"
	}
	if (boolchecked=="1"){
		if(checkboxid=="checkedOut"){
			$('#checkedLong').attr('checked',false); 
			$('#checkedShort').attr('checked',false); 
		}else if (checkboxid=="checkedLong"){
			$('#checkedOut').attr('checked',false); 
			$('#checkedShort').attr('checked',false);
		}else if (checkboxid=="checkedShort"){
			$('#checkedLong').attr('checked',false); 
			$('#checkedOut').attr('checked',false);
		}else if (checkboxid=="checkedIsPack"){
			$('#checkedNotPack').attr('checked',false); 
		}else if (checkboxid=="checkedNotPack"){
			$('#checkedIsPack').attr('checked',false); 
		}
	}
	CollectHandler();
}
function CollectHandler(){
	var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
	var tabtwotitle=tabtwoselect.panel('options').title;
	var tmpselectdata=null;
	if (tabtwotitle=="按病区"){
		tmpselectdata=$('#dispwardgrid').datagrid("getSelected");
	}
	else if (tabtwotitle=="登记号"){
		tmpselectdata=$('#dispadmgrid').datagrid("getSelected");
	}
	if (tmpselectdata==null){
		return;
	}
	var params=GetQueryDispParams(tmpselectdata)
	QueryDisp(params);
}
//刷新发药汇总tab
function RefTabOne(){
	var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
	var params;
	if (selecteddata==null){
		params="";	
	}else{
		params=selecteddata["TPID"]; 
	}
	//$('#disptotalgrid').datagrid('options').queryParams.params = params;//传递值  
    //$("#disptotalgrid").datagrid('reload');//重新加载table  
	$('#disptotalgrid').datagrid({
		url:commonInPhaUrl+'?action=jsQueryDispTotalList',	
		queryParams:{
			params:params}
	});
}
//刷新病区登记号tab
function RefTabTwo(){
	$('#dispadmgrid').datagrid({
		queryParams:{
			params:''}
	});
}
//清空发药明细
function ClearDispGrid(){
	var params=""
	$('#dispgrid').datagrid({
	url:commonInPhaUrl+'?action=jsQueryDispList',	
	queryParams:{
		params:params}
	});
}
function KillTmpBeforeLoad(){
	var dispgridrowsdata=$('#dispgrid').datagrid("getRows");
	var dispgridrows=dispgridrowsdata.length;
	if (dispgridrows>0){
		var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
		var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillBeforeLoad",selecteddata["TPID"])
	}
}
//mac地址
///
function InitComputerMac(){
   var macAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //连接本机服务器
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled =True");  //查询使用SQL标准 
   var e = new Enumerator (properties);
   var p = e.item ();
   for (;!e.atEnd();e.moveNext ())  
   {
	  	var p = e.item ();  
	  	if(p.MACAddress==null){
			continue;
		}
		macAddr=p.MACAddress;
		if(macAddr) break;
	}
	$("#macAddr").val(macAddr)
}
//客户端配置取优先级
function SetLocalConfig(checkboxid){
	var checkedflag=""
	if ($('#'+checkboxid).is(':checked')){
		checkedflag="1"
	}
	if(checkedflag!="1"){
		$("#priority").val("");
		return;
	}else{
		var phaLoc=$('#phaLoc').combobox("getValue")
		var mac="**"+$("#macAddr").val();
		var retval=tkMakeServerCall("web.DHCSTPHACONFIG", "GetPhaLocConfigByLoc",phaLoc,mac,gUserId);
		$("#priority").val(retval);
	}
}
//判断数组中是否包含元素
Array.prototype.contains = function (obj) {  
    var i = this.length;  
    while (i--) {  
        if (this[i] === obj) {  
            return true;  
        }  
    }  
    return false;  
} 

window.onbeforeunload = function (){
	if (CurKFlag=="0"){
		CurKFlag="";
		return;
	}
	KillTmpBeforeLoad();
	var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmp",dispCatPid);
}
