/*
模块:住院药房
子模块:住院药房-退药申请
createdate:2016-06-07
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var thisUrl="dhcpha.inpha.request.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var currEditRow=undefined; //控制行编辑
$(function(){
	InitPhaLoc();
    InitAdmList()
	InitReqDetail();
   	$('#patNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			if (isNaN(patno)==true){
				$.messager.alert("提示","登记号需要为数字!","info");
				$("#patInfo").text("");
				return;
			}
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });	
    $('#btnFind').bind('click',function(){
		btnFindHandler();
    });
    $('#btnFindRequest').bind('click',function(){
		var lnk="dhcpha.seekpharetrequest.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    });
    $('#btnSave').bind('click',function(){
		btnSaveHandler();
    });
    $('#btnClear').bind('click',function(){
		btnClearHandler();
    });
    $('#btnSetDefault').bind('click',function(){
		btnSetDefaultHandler();
    })
    InitTitle();
})
function InitTitle(){
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//提交到那里 后他的服务  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
				var regNo=tkMakeServerCall("web.DHCSTKUTIL","GetRegNobyEpisodeID",EpisodeID);
				SetPatInfo(regNo);
			}   
		},    
		error:function(){        
			alert("获取登记号长度失败!");
		}
	});
}
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:150,
		panelWidth: 150,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
	            SetDefaultLoc(); 
            }            
	    }
	});
}
function SetDefaultLoc(){
	var defaultloc=tkMakeServerCall("web.DHCSTKUTIL","GetDefaultPhaLoc",gGroupId)
	$('#phaLoc').combobox('select', defaultloc.split("^")[0]);
}
//初始化就诊
function InitAdmList(){
	//定义columns
	var columns=[[
		{field:'Adm',title:'adm',width:60,hidden:true},
		{field:'CurrWard',title:'病区',width:150},
		{field:'AdmDate',title:'就诊日期',width:80},
		{field:'AdmTime',title:'就诊时间',width:80},
		{field:'AdmLoc',title:'就诊科室',width:150},
		{field:'CurrentBed',title:'床号',width:100}
	]]; 
	
   //定义datagrid	
   $('#admlist').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  selectOnCheck: true, 
	  checkOnSelect: false,
	  rownumbers:false,
      columns:columns,   
      pageSize:999,  // 每页显示的记录条数
	  loadMsg: '正在加载信息...',
	  onSelect:function(rowIndex,rowData){
		   currEditRow=undefined
		   QueryDetail();
	  },
	  onLoadSuccess: function(){
         	//选中第一
         	if ($('#admlist').datagrid("getRows").length>0){
	         	$('#admlist').datagrid("selectRow", 0)
         	}
         	else{
	        	$('#reqdetail').datagrid('loadData',{total:0,rows:[]}); 
				$('#reqdetail').datagrid('options').queryParams.params = ""; 
	        }
	  }  	     
  });
}

function InitReturnReason(){
	 retReasonEditor={  //设置其为可编辑
		type: 'combobox', //设置编辑格式
		options: {
			panelHeight:"auto",
			valueField: "value",  
			textField: "text",
			url:commonInPhaUrl+'?action=GetInRetReason&Type=gridcombobox',
			onSelect:function(option){
				var ed=$("#reqdetail").datagrid('getEditor',{index:currEditRow,field:'TReasonDR'});
				$(ed.target).val(option.value);  //设置ID
				var ed=$("#reqdetail").datagrid('getEditor',{index:currEditRow,field:'TReason'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
}

//初始化药品明细列表
function InitReqDetail(){
	InitReturnReason();
	//定义columns
	var columns=[[
	    {field:'TSelect',title:'<a id="AllSelect" href="#" style="font-weight:bold;color:black" onclick="SetSelectAll()">全选</a>',width:40,
	    	formatter:function(value,row,index){
				if (value=="Y"){
					return '<input type="checkbox" name="ReqDetailDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="ReqDetailDataGridCheckbox" >';
				}
			}
	    },
        {field:'TRegNo',title:'登记号',width:80},
        {field:'TName',title:'姓名',width:80},
        {field:'TPrescNo',title:'处方号',width:100},
        {field:'TDesc',title:'药品名称',width:200},
        {field:'TDispQty',title:'发药数量',width:75,align:'right'},
        {field:'TReqQty',title:'申请数量',width:75,align:'right',
        	editor:{
				type:'numberbox',
				options:{
					precision:2
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        },
        {field:'TReason',title:'退药原因',width:100,editor:retReasonEditor},
        {field:'TReasonDR',title:'TReasonDR',width:100,editor:{type:'text'},hidden:true},
        {field:'TUom',title:'单位',width:75},
        {field:'TStatus',title:'医嘱状态',width:60,align:'center'},
        {field:'Toedis',title:'Toedis',width:75,hidden:true},
        {field:'Tdspid',title:'Tdspid',width:75,hidden:true},
        {field:'TUserDept',title:'开单科室',width:125},
        {field:'Treqflag',title:'申请单状态',width:150},
        {field:'Titmcode',title:'药品代码',width:80,hidden:true},
        {field:'TEncryptLevel',title:'病人密级',width:80},
        {field:'TPatLevel',title:'病人等级',width:80},
        {field:'TRecLocDr',title:'TRecLocDr',width:80,hidden:true},
        {field:'TWardLocDr',title:'TWardLocDr',width:80,hidden:true}
   ]];  
	
   //定义datagrid	
   $('#reqdetail').datagrid({    
      url:'',
      fit:true,
	  border:false,
	  singleSelect:true,
	  //rownumbers:true,
	  checkOnSelect:false,
	  selectOnCheck:false,
      columns:columns,
      pageSize:999,  // 每页显示的记录条数
	  loadMsg: '正在加载信息...',
	  //pagination:true,    
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#reqdetail').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
	  },
  	  onClickCell: function (rowIndex, field, value) {
	  	if (field=="TSelect"){
			if (currEditRow!=undefined){
				$('#reqdetail').datagrid('endEdit', currEditRow);
				currEditRow=undefined;
			}
			var tmpcheckvalue=""
			if (value=="Y"){tmpcheckvalue="N"}
			else{tmpcheckvalue="Y"}
			$('#reqdetail').datagrid('updateRow',{
				index: rowIndex,
				row: {TSelect:tmpcheckvalue}
			})			
			return;	  
		}
		if ((field!="TReqQty")&&(field!="TReason")){return;}
		if (currEditRow!=undefined){
			$('#reqdetail').datagrid('endEdit', currEditRow);
		}
	  	if (rowIndex != currEditRow) {
			$("#reqdetail").datagrid('beginEdit', rowIndex);
			var editor = $('#reqdetail').datagrid('getEditor', {index:rowIndex,field:field});
     	    editor.target.focus();
     	    editor.target.select();
			$(editor.target).bind("blur",function(){
				CheckInputInfo();   
			})
			currEditRow=rowIndex;  
		}	  	  
  	  }  
   });
}
function CheckInputInfo(){
	if (currEditRow==undefined){return;}
    if ($('#reqdetail').datagrid('validateRow', currEditRow)) {
	    var ed = $('#reqdetail').datagrid('getEditor', { index: currEditRow, field: "TReqQty" });
	    var selecteddata = $('#reqdetail').datagrid('getRows')[currEditRow];
	    var dispid=selecteddata["Tdspid"];
	    var inputtxt = $(ed.target).numberbox('getValue');
	    var warnflag=""
	    if ((inputtxt<0)&&(warnflag=="")){
	    	$.messager.alert('错误提示',"数字不能小于0!","warning");
	    	warnflag=1;
	    }
	    if ((CheckReqQty(dispid,inputtxt)==false)&&(warnflag=="")){
		    $.messager.alert("提示","申请数量不能大于发药数量!","warning") 
		    warnflag=1;
		}
		if ((CheckRetParted(dispid,inputtxt)==false)&&(warnflag=="")){
		    $.messager.alert("提示","此记录有附加收费项目，不能部分退药!","warning") 
		    warnflag=1;
		}
		
    }
}
function CheckReqQty(dispid,reqqty){
	var checkret=tkMakeServerCall("web.DHCSTPHARETURN","AllowReturnByDodis","","",dispid,reqqty)
	if (checkret==0){
		return false;
	}else{
		return true;
	}	
}
//判断是否有附加项目
function CheckRetParted(dispid,reqqty){
  	var checkpartret=tkMakeServerCall("web.DHCSTPHARETURN2","GetRetParted",dispid,parseFloat(reqqty));
	if (checkpartret=="0"){
		return false;	
	}
	return true;
}
//设为默认科室
function btnSetDefaultHandler(){
	var phaLoc=$("#phaLoc").combobox("getValue");
	var phaLocDesc=$.trim($("#phaLoc").combobox("getText"))
	if (phaLocDesc==""){
		phaLoc="";
	}
	if (phaLoc==""){
		$.messager.alert("提示","请先选择发药科室!","info") ;	
		return;
	}
	$.messager.confirm('提示', "确认将 " + phaLocDesc +" 设置成默认科室吗?", function(r) {
		if(r==true){
	    	var ret=tkMakeServerCall("web.DHCSTRETREQUEST","SetDefaultPhaLoc",phaLoc,gGroupId)
	    	if (ret==0){
		    	$.messager.alert("提示","设置成功!") ;
		    }
	    }else{
			return;
		}
	});
}
function SetPatInfo(RegNo)
{    
	if (RegNo=="") {
		return;
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
	$.ajax({  
		type: 'POST',//提交方式 post 或者get  
		url: commonInPhaUrl+'?action=GetPatInfoByNo&patNo='+RegNo,//提交到那里 后他的服务  
		data: "",
		success:function(value){     
			if ($.trim(value)!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					$("#patName").val(painfoarr[0]);
					$("#patSex").val(painfoarr[1]);
					$("#patAge").val(painfoarr[2]+"("+painfoarr[3]+")")
				}
				btnFindHandler();
			} else{
				$.messager.alert("提示","不存在该病人!","info");
				$("#patName").val("");
				$("#patSex").val("");
				$("#patAge").val("");
				$('#admlist').datagrid('loadData',{total:0,rows:[]});
				$('#admlist').datagrid('options').queryParams.params = "";  
				$('#reqdetail').datagrid('loadData',{total:0,rows:[]});
				$('#reqdetail').datagrid('options').queryParams.params = ""; 
			}  
		},    
		error:function(){        
			alert("获取病人基础数据失败!");
		}
	});
}
//查询明细
function QueryDetail(){
	var selecteddata = $('#admlist').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('提示',"请选中就诊记录！","info");
		return;
	}
	var phaLoc=$("#phaLoc").combobox("getValue");
	var phaLocDesc=$.trim($("#phaLoc").combobox("getText"))
	if (phaLocDesc==""){
		phaLoc="";
	}
	var patNo=$.trim($("#patNo").val());
	var adm=selecteddata["Adm"];
	var params=patNo+"^"+adm+"^"+phaLoc+"^"+gLocId;
	$('#reqdetail').datagrid({
		url:thisUrl+'?action=QueryNeedReqList',	
		queryParams:{
			params:params}
	});
}
//查询就诊列表
function btnFindHandler(){
	var patNo=$("#patNo").val();
	var params=patNo
	$('#admlist').datagrid({
		url:commonInPhaUrl+'?action=QueryDispAdmList',	
		queryParams:{
			params:params}
	});
}
//清空
function btnClearHandler(){
	SetDefaultLoc();
	$("#patName").val("");
	$("#patNo").val("");
	$("#patSex").val("");
	$("#patAge").val("");
	$('#admlist').datagrid('loadData',{total:0,rows:[]});
	$('#admlist').datagrid('options').queryParams.params = "";  
	$('#reqdetail').datagrid('loadData',{total:0,rows:[]});
	$('#reqdetail').datagrid('options').queryParams.params = "";  
}
 //保存请求单
function btnSaveHandler(){
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		$.messager.alert('提示',"没有数据!","info");
		return;
	}
	$("#reqdetail").datagrid("acceptChanges");
	if (currEditRow!=undefined){
		$('#reqdetail').datagrid('endEdit', currEditRow);
	}	
	var requeststr="";
	var reclocdr="";
	var reqlocdr="";
	var quitFlag="";
	$.each(detailrowsdata, function(index, item){
		if (item["TSelect"]=="Y"){
			var reqqty=$.trim(item["TReqQty"]);
			var dspid=item["Tdspid"];
			var reasondesc=$.trim(item["TReason"]);
			var reason=item["TReasonDR"];
		    reclocdr=item["TRecLocDr"];
			reqlocdr=item["TWardLocDr"];
			var exist=tkMakeServerCall("web.DHCSTRETREQUEST","CheckReqExist",dspid)
			if(exist!=""){
				alert("第"+(index+1)+"行退药申请已经存在!");
				$("#reqdetail").datagrid('selectRow',index);
				quitFlag=1;
				return false;
			}
			if (reasondesc==""){
				reason="";
			}
			if ((reason=="")||(reason==null)){
				alert("第"+(index+1)+"行退药原因为空!");
				$("#reqdetail").datagrid('selectRow',index);
				quitFlag=1;
				return false;
			}
			if (reqqty<0){
				alert("第"+(index+1)+"行退药申请数量不能小于0!");
				$("#reqdetail").datagrid('selectRow',index);
				return false;
		    }
		    if (reqqty==""){
				alert("第"+(index+1)+"行退药申请数量不允许为空!");
				$("#reqdetail").datagrid('selectRow',index);
				quitFlag=1;
				return false;   
			}
		    if (CheckReqQty(dspid,reqqty)==false){
			    alert("第"+(index+1)+"行申请数量不能大于发药数量!") ;
			    $("#reqdetail").datagrid('selectRow',index);
			    quitFlag=1;
			    return false;
			}
			if (CheckRetParted(dspid,reqqty)==false){
			    alert("第"+(index+1)+"行有附加收费项目，不能部分退药!") ;
			    $("#reqdetail").datagrid('selectRow',index);
			    quitFlag=1;
			    return false;
			}
			if(requeststr==""){
				requeststr=dspid+"^"+reqqty+"^"+reason;
			}else{
				requeststr=requeststr+","+dspid+"^"+reqqty+"^"+reason;
			}
		} 	 
	});
	if(quitFlag==1){
		return;
	}
	if (requeststr==""){
		$.messager.alert('提示',"没有需要申请的数据!","info");
		return;	
	}
	/*
	if(reclocdr==""){
		$.messager.alert('提示',"无法获取记录中发药科室!","info");
		return;	
	}*/
	if(reqlocdr==""){
		$.messager.alert('提示',"无法获取记录中病区!","info");
		return;	
	}
	var saveret=tkMakeServerCall("web.DHCSTRETREQUEST","InsDetail2",gUserId,reqlocdr,requeststr)
	var savearr=saveret.split("^");
	if (savearr[0]=="success"){
		$.messager.alert('提示',"保存成功!申请单号:"+savearr[1]);
		$("#reqdetail").datagrid("reload");
	}else{
		$.messager.alert('提示',"保存失败,错误代码:"+savearr[1],"error");
	}
}
function SetSelectAll()
{
	var detailrowsdata=$('#reqdetail').datagrid("getRows");
	var detailrows=detailrowsdata.length;
	if (detailrows<=0){
		return;
	}
	var tmpSelectFlag=""
	if($("#AllSelect").text()=="全选"){
		$("#AllSelect").text("全消")
		tmpSelectFlag="Y"
	}else{
		$("#AllSelect").text("全选")
		tmpSelectFlag="N"
	}
	var columns = $('#reqdetail').datagrid("options").columns;
	var columnsstr=$('#reqdetail').datagrid('getColumnFields',false);
	var columni=columnsstr.indexOf("TSelect");
	$.each(detailrowsdata, function(index, item){
		detailrowsdata[index][columns[0][columni].field]=tmpSelectFlag;
		$('#reqdetail').datagrid('refreshRow', index);
	})
}
