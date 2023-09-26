/*
模块:门诊药房
子模块:门诊药房-发药查询
createdate:2016-05-25
creator:dinghongying,yunnaibao
*/
var url = "dhcpha.outpha.dispquery.action.csp";
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var inciRowId="";
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitCondition(); //初始化查询条件
	InitCardType();
	var pyUserCombo=new ListCombobox("pyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	pyUserCombo.init(); //初始化配药人		
	var fyUserCombo=new ListCombobox("fyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	fyUserCombo.init(); //初始化发药人
	$('#dispStat').combobox("setValue",1)
	InitDispMainList();	
	InitDispDetailList();
	$('#invNo').bind('keypress',function(event){
	 	if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				var input=gLocId+"^"+patno+"^"+$("#startDate").datebox("getValue")+"^"+$("#endDate").datebox("getValue")
				var mydiv = new InvNoDivWindow($("#invNo"), input,getInvReturn);
	            mydiv.init();
			}else{
				
		 	}	
	 	}
	});	
	$('#inciDesc').bind('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#inciDesc").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#inciDesc"), input,getDrugList);
            mydiv.init();
		 }else{
		 }	
	 }
	});
	$('#patNo').bind('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (patno!=""){
				GetWholePatID(patno);
			}else{
				$("#patName").val("");
			}	
		}
	});
	//点击查询
	$('#btnRetrieve').bind('click', Query);	
	$('#btnClear').bind('click',btnClearHandler);
	$('#btnExport').bind('click',function(){
		ExportAllToExcel("DispMain")
	});
	$('#DispMain').datagrid('loadData',{total:0,rows:[]});
	$('#DispMain').datagrid('options').queryParams.params = ""; 
});
function InitCondition()
{
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
	$("#startDate").datebox("setValue", formatDate(0)+" "+"00:00:00");  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0)+" "+"23:59:59"); //Init结束日期
}
//初始化发药查询列表
function InitDispMainList(){
	//定义columns
	var columns=[[
        {field:'TPerName',title:'姓名',width:80},
        {field:'TPmiNo',title:'登记号',width:80},  
        {field:'TPrtDate',title:'收费日期',width:80},
        {field:'TPyDate',title:'配药日期',width:80},
        {field:'TDispDate',title:'发药日期',width:80},
        {field:'TPhMoney',title:'药费',width:80,align:'right'},
        {field:'TPyName',title:'配药人',width:80},
        {field:'TFyName',title:'发药人',width:80},
        {field:'TPrescNo',title:'处方号',width:100},
        {field:'TPrescType',title:'处方类型',width:80},
        {field:'TPrtTime',title:'收费时间',width:70},
        {field:'TPyTime',title:'配药时间',width:70},
        {field:'TDispTime',title:'发药时间',width:70},
        {field:'TDocloc',title:'科室',width:120},
        {field:'TDoctor',title:'医生',width:80,hidden:true},
        {field:'TOrdate',title:'医嘱日期',width:80},
        {field:'TOrdremark',title:'医嘱备注',width:80},
        {field:'TDiag',title:'诊断',width:120},
        {field:'TRpAmt',title:'进价金额',width:100,align:'right'},
        {field:'TEncryptLevel',title:'病人密级',width:80},
        {field:'TPatLevel',title:'病人级别',width:80},
        {field:'tphd',title:'tphd',width:80,hidden:true},
        {field:'TPrtID',title:'TPrtID',width:80,hidden:true},

         ]];  
	
   //定义datagrid	
   $('#DispMain').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
      columns:columns,
      nowrap:false,
      pageSize:50,  // 每页显示的记录条数
	  pageList:[50,100,300],   // 可以设置每页记录条数的列表
	  singleSelect:true,
	  loadMsg: '正在加载信息...',
	  pagination:true,
	  onLoadSuccess: function(){
         	//选中第一
         	if ($('#DispMain').datagrid("getRows").length>0){
	         	$('#DispMain').datagrid("selectRow", 0)
	         	QueryDetail();
         	}         	
	    },
	    onSelect:function(rowIndex,rowData){
		   QueryDetail();		   
	    }	 
   });
   $('#DispMain').gridupdown($('#DispMain'));
}


//初始化发药明细列表
function InitDispDetailList(){
	//定义columns
	var columns=[[
        {field:'TPhDesc',title:'药品',width:200},    
        {field:'TPhUom',title:'单位',width:80},
        {field:'TPrice',title:'价格',width:80,align:'right'},
        {field:'TPhQty',title:'数量',width:80,align:'right'},
        {field:'TPhMoney',title:'金额',width:80,right:'right'},
        {field:'TStatus',title:'状态',width:60},
        {field:'TJL',title:'剂量',width:70},
        {field:'TPC',title:'频次',width:70},
        {field:'TYF',title:'用法',width:70},
        {field:'TLC',title:'疗程',width:70},
        {field:'TDoctor',title:'医师',width:70},
        {field:'TIncPC',title:'批次',width:90},
        {field:'TIncHW',title:'货位',width:100},
        {field:'TRetQty',title:'退药',width:70}
         ]];  
	
   //定义datagrid	
   $('#DispDetail').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  nowrap:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
      pageSize:100,  // 每页显示的记录条数
	  singleSelect:true,
	  loadMsg: '正在加载信息...',
	  rowStyler: function(index,row){
			if (row.TStatus!="核实"){
                return 'color:#ff0066;font-weight:bold';
            }
	  }	 
   });
}



///发药查询
function Query(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('错误提示',"请输入开始日期!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('错误提示',"请输入开始日期!","info");
		return;
	}
	var patNo=$.trim($('#patNo').val());
	var patName=$("#patName").val();
	if ($.trim($("#inciDesc").val())==""){
		inciRowId=""
	}
	var pyUser=$("#pyUser").combobox("getValue");
	if ($.trim($("#pyUser").combobox("getText"))==""){
		pyUser="";
	}
	var fyUser=$("#fyUser").combobox("getValue");
	if ($.trim($("#fyUser").combobox("getText"))==""){
		fyUser="";
	}
	var dispStat=$("#dispStat").combobox("getValue");
	if ($.trim($("#dispStat").combobox("getValue"))==""){
		$.messager.alert('错误提示',"请选择发药状态!","info");
		return;
	}
	var manaFlag=""
	if ($('#checkedMan').is(':checked')){manaFlag=1;}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var invNo=$.trim($("#invNo").val());
	var depcode="";
	var doctor="";
	var params=startDate+"^"+endDate+"^"+gLocId+"^"+patNo+"^"+patName+"^"
			  +invNo+"^"+inciRowId+"^"+pyUser+"^"+fyUser+"^"+dispStat+"^"
			  +startTime+"^"+endTime+"^"+manaFlag+"^"+depcode+"^"+doctor
	$('#DispMain').datagrid({
     	url:url+'?action=QueryDispList',
     	queryParams:{
			params:params
		}
	});
}



///发药明细查询
function QueryDetail(){
	var params=""
	var selecteddata = $('#DispMain').datagrid('getSelected');
	if(selecteddata==null){
		return;	
	}
	var phdRowId=selecteddata["tphd"];
	var pyUser=selecteddata["TPyName"];
	var fyFlag="1";
	if (pyUser=="W"){fyFlag="2";}
	var prescNo=selecteddata["TPrescNo"];
	var prtId=selecteddata["TPrtID"];
	params=phdRowId+"^"+fyFlag+"^"+gLocId+"^"+prescNo;
	$('#DispDetail').datagrid({
     	url:url+'?action=QueryDispDetailList',
     	queryParams:{
			params:params
		}
	});
	
}
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#inciDesc").val(returndata["InciDesc"]);
		inciRowId=returndata["Inci"]
	}
	else{
		$("#inciDesc").val("");
		inciRowId=""
	}
}
function getInvReturn(returndata)
{
	var tmpnewinvid=returndata["newInvId"]
	if (tmpnewinvid>0){
		$("#invNo").val(returndata["newInvNo"]);
	}else{
	}
}
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = hisPatNoLen;
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('错误提示',"登记号输入错误！");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patNo").val(RegNo);
	SetPatInfo(RegNo);
	  
}
function SetPatInfo(patno){
	var patinfo=tkMakeServerCall("web.DHCSTPharmacyCommon","GetPatInfoByNo",patno)
	var patname=patinfo.split("^")[0];
	$("#patName").val(patname);
}
//初始化卡类型
function InitCardType()
{
	$('#cardType').combobox({  
		width:100,
		panelHeight:'auto',
		panelWidth: '150',
		width:'150',
		url:commonOutPhaUrl+'?action=GetCardType',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#cardType').combobox('getData');
            if (data.length > 0) {
                  $('#cardType').combobox('select', data[0].RowId);
                  for (var i=0;i<data.length;i++){
						var tmpcardvalue = data[i].RowId;
						var tmpcardarr = tmpcardvalue.split("^");
						var defaultflag = tmpcardarr[8];
						if (defaultflag == "Y") {
							$('#cardType').combobox('select', data[i].RowId);
						}
	              }
              }            
	    },
       onSelect:function(record){  
       		if (record.Desc=="条形码"){
	       		//$("#cardNo").attr("disabled", true);	
	       	}
	       	else{
		      // $("#cardNo").attr("disabled", true);	
		    }  
        } 
	    
	});
}
function btnClearHandler(){
	$("#startDate").datebox("setValue", formatDate(0)+" "+"00:00:00");  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0)+" "+"23:59:59"); //Init结束日期
	inciRowid="";
	$('#dispStat').combobox("setValue",1);
	$('#fyUser').combobox("setValue","");
	$('#pyUser').combobox("setValue","");
	$('#inciDesc').val("");
	$('#invNo').val("");
	$('#patNo').val("");
	$('#patName').val("");
	$('#startTime').timespinner('setValue',"");
	$('#endTime').timespinner('setValue',"");
	$('#checkedMan').attr('checked',false); 
	$('#DispDetail').datagrid('loadData',{total:0,rows:[]}); 
	$('#DispMain').datagrid('loadData',{total:0,rows:[]});
	$('#DispDetail').datagrid('options').queryParams.params = "";  
	$('#DispMain').datagrid('options').queryParams.params = ""; 
}