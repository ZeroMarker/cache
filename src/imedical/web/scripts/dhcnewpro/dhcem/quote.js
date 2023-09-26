//quote.js
//引用病历js
//zhouxin
//2019-03-17
var lisFlag=0;
var pacsFlag=0;
var orderFlag=0;
var diaFlag=0;
var pathology=0
$(function(){
	var type=$("#Type").val();
	initTab();
	initBTN();
	initRadio();
	initPage(type);
})

function initTab(){
	$('#quoteTab').tabs({
	    onSelect:function(title){
			if(title==$g("检验")){
				initLis();
			}
			if(title==$g("检查")){
				initPacs();
			}
			if(title==$g("医嘱")){
				initOrder();
			}
			if(title==$g("诊断")){
				initDia();
			}
			if(title==$g("病理")){
				initPatHology();
			}
	    }
	});
}

function initPage(type){
	if(type==2){
		
//		if(type==2){
//			//产前筛查
//			$('input[name=queryPrenatal][value=Screening]').prop('checked', true);
//		}
//		if(type==6){
//			//产前诊断
//			$('input[name=queryPrenatal][value=Diagnosis]').prop('checked', true);
//		}
		$("#quoteTab").tabs("select",$g("检验"));
	}
	if(type==5){
		//NT
//		if(type==11){
//			$("input[name='queryPacsNT'][value=NT]").prop('checked', true);
//		}	
		$("#quoteTab").tabs("select",$g("检查"));
	}
	if(type==8){
		$("#quoteTab").tabs("select",$g("医嘱"));
	}

	if(type==9){
		$("#quoteTab").tabs("select",$g("诊断"));
	}
	if(type==10){
		$("#quoteTab").tabs("select",$g("病理"));
	}
}

function initRadio(){
	  $('input[name=queryPacsNT]').change(function() {
          searchPacs(); 
      })
//	  $('input[name=queryPrenatal]').change(function() {
//          searchLis(); 
//      })
	  $('input[type=checkbox][name^=query]').change(function() {
          searchLis(); 
      })
	 $('input[type=radio][name=queryType]').change(function() {
          var type=$("input[name='queryType']:checked").val()
      	  if(type=="all"){
	      	  $("#admLitTD").show();
	      	  var option=getComboGridOpt();
			  var opt={ onChange : function(now, old) {searchLis();}}
			  $.extend(option,opt);
		      $('#admListCombogrid').combogrid(option);
	      }else{
		      $("#admLitTD").hide() 
		     searchLis(); 
		  }
      })
      $('input[type=radio][name=queryPacsType]').change(function() {
          var type=$("input[name='queryPacsType']:checked").val()
      	  if(type=="all"){
	      	  $("#admPacsListTD").show()
	      }else{
		      $("#admPacsListTD").hide() 
		      searchPacs(); 
		  }
      })
      $('input[type=radio][name=queryOrderType]').change(function() {
          var type=$("input[name='queryOrderType']:checked").val()
      	  if(type=="all"){
	      	  $("#admOrderListTD").show()
	      }else{
		      $("#admOrderListTD").hide() 
		      searchOrder(); 
		  }
      })
      	$('input[type=radio][name=queryDiaType]').change(function() {
          var type=$("input[name='queryDiaType']:checked").val()
      	  if(type=="all"){
	      	  $("#admDiaListTD").show()
	      }else{
		      $("#admDiaListTD").hide() 
		     searchDia(); 
		  }
      })
      $('input[type=radio][name=queryPatHologyType]').change(function() {
          var type=$("input[name='queryPatHologyType']:checked").val()
      	  if(type=="all"){
	      	  $("#admPatHologyTD").show();
	      	  var option=getComboGridOpt();
			  var opt={ onChange : function(now, old) {searchPatHology();}}
			  $.extend(option,opt);
		      $('#admPatHologyListCombogrid').combogrid(option);
	      }else{
		      $("#admPatHologyTD").hide() 
		      searchPatHology(); 
		  }
      })	
}




function initBTN(){

//	$("#quoteLisBTN").on('click',function(){quoteLis();});
//	$("#quotePacsBTN").on('click',function(){quotePacs();});
//	$("#quoteOrderBTN").on('click',function(){quoteOrder();});
//	$("#quoteDiaBTN").on('click',function(){quoteDia();});
//	$("#quotePatHologyBTN").on('click',function(){quotePatHology();});
}

function searchLis(){
	$('#LisDatagrid').datagrid('load');
}

function searchLisSub(){
	var OeordIDArr=[];
	var ids = $('#LisDatagrid').datagrid('getChecked');
	for(var i=0;i<ids.length;i++) {
		OeordIDArr.push(ids[i].OEordItemRowID);
	}
	$('#LisSubDatagrid').datagrid('load',{OeordIDs: OeordIDArr.join(",")});
}
function searchPacs(){
	$('#PacsDatagrid').datagrid('load');
}
function searchPacsSub(){
	$('#PacsSubDatagrid').datagrid('load');
}
function searchOrder(){
	$('#OrderDatagrid').datagrid('load');
}
function searchDia(){
	$('#DiaDatagrid').datagrid('load');
}
function searchPatHology(){
	$('#PatHologyDatagrid').datagrid('load');
}
function searchPatHologySub(){
	$('#PatHologySubDatagrid').datagrid('load');
}
//引用(检验，产前筛查，产前诊断)
function quoteLis(){
	
	var resultItems = new Array();
	var mainsItems=$('#LisDatagrid').datagrid('getChecked');
	var checkedSubItems=$('#LisSubDatagrid').datagrid('getChecked');
	if(checkedSubItems.length==0){
		//$.messager.alert('提示','请选择');
		//return;	
	}

	$.each(checkedSubItems, function(subIndex, subItem)
	{			
		//resultItems.push(subItem.OeordID+":"+subItem.Synonym);
		resultItems.push(subItem.ItemDesc + ":" + subItem.ItemResult + "" + subItem.ItemUnit);
	});
	
	//增加到明细界面
	appendTextareaStr(mainsItems[0].OEordItemDesc +" "+ resultItems.join("\r")+"\r");
	
//	var type=3;
//	var prenatal=$("input[name='queryPrenatal']:checked").val()
//	//产前检查
//    if(prenatal=="Screening"){type=1;}
//    //产前诊断
//    if(prenatal=="Diagnosis"){type=2; }
//	runClassMethod("web.DHCEMQuoteRecord",
//				   "quoteBySelect",
//				   {
//					   'type':type,
//					   'adm':$("#EpisodeID").val(),
//				   	   'ords':resultItems.join("^"),
//				   	   'user':LgUserID
//				   },function(data){
//						if(data==0){
//							//刷新复检界面
//							if(window.parent.frames["review"].document==undefined){
//								window.parent.frames["review"].contentWindow.initValue();
//							}else{
//								obj=window.parent.frames["review"].initValue();
//							}
//							//增加到明细界面
//							appendTextareaStr(resultItems.join("\r")+"\r");
//							window.parent.commonCloseWin();	
//						}else{
//							$.messager.alert('提示','保存失败'+data);	
//						}
//								
//	},'text')
}

function quotePacs(){
	var resultItems = new Array(); 
	var pacsExamDesc=$("input[name='pacsExamDesc']:checked").length
	var pacsstrResult=$("input[name='pacsstrResult']:checked").length
	var pacsstrOrderName=$("input[name='pacsstrOrderName']:checked").length

	var checkedItems = $('#PacsDatagrid').datagrid('getChecked');
	var checkedSubItems=$('#PacsSubDatagrid').datagrid('getChecked');
	if(checkedSubItems.length==0){
		//$.messager.alert('提示','请选择');
		//return;	
	}
	$.each(checkedItems, function(index, item)
	{
		var itm="";
		itm=item.RrtDate;
		itm=itm+"	"+item.ItemName+":";
		$.each(checkedSubItems, function(subIndex, subItem)
		{	
			if(subItem.OeordID==item.OEOrdItemDR){
				if(pacsExamDesc==1){
					itm=itm+"\r检查所见: "+subItem.ExamDesc
				}
				if(pacsstrResult==1){
					itm=itm+"\r诊断意见:"+subItem.strResult;
				}
				if(pacsstrOrderName==1){
					itm=itm+"\r检查方法: "+subItem.strOrderName
				}
			}
		});
		resultItems.push(itm)
	});	
	appendTextareaStr(resultItems.join("\r")+"\r");	
//	var paramArr=[];
//	paramArr.push("OtherPacs:"+resultItems.join("\r"));
//	paramArr.push("OtherPacsUser:"+LgUserName);
//	paramArr.push("OtherPacsDate:"+$("#date").val());
//	CommonSaveEmr('review',$("#EpisodeID").val(),function(ret){
//			if(ret==0){
//				$(getDocument()).find("#OtherPacsDiv").html(resultItems.join("\r"))
//				appendTextareaStr(resultItems.join("\r")+"\r");	
//				window.parent.commonCloseWin();	
//			}	
//	},'',paramArr.join("^"))
	
}

///引用病理结果
function quotePatHology(){
	var resultItems = new Array(); 
	var PatHologyDate=$("input[name='PatHologyDate']:checked").length
	var PatHologySee=$("input[name='PatHologySee']:checked").length
	var PatHologyDia=$("input[name='PatHologyDia']:checked").length
	var PatHologyNo=$("input[name='PatHologyNo']:checked").length
	
	var checkedItems = $('#PatHologyDatagrid').datagrid('getChecked');
	var checkedSubItems=$('#PatHologySubDatagrid').datagrid('getChecked');
	if(checkedSubItems.length==0){
		//$.messager.alert('提示','请选择');
		//return;	
	}
	$.each(checkedItems, function(index, item)
	{
		var itm="";
		itm=item.AppDate;
		itm=itm+"	"+item.ordername+":";
		$.each(checkedSubItems, function(subIndex, subItem)
		{	
			if(subItem.OeordID==item.OEOrdItemDR){
				if(PatHologyDate==1){
					itm=itm+"\r报告日期: "+subItem.RptDate
				}
				if(PatHologySee==1){
					itm=itm+"\r检查所见:"+subItem.Seeing;
				}
				if(PatHologyDia==1){
					itm=itm+"\r病理诊断: "+subItem.Diagnosis
				}
				if(PatHologyNo==1){
					itm=itm+"\r病理号: "+subItem.PathId
				}
			}
		});
		resultItems.push(itm)
	});
	appendTextareaStr(resultItems.join("\r")+"\r");	
//	var paramArr=[];
//	paramArr.push("TCT:"+resultItems.join("\r"));
//	var emrType=$("#emrType").val();
//	if(emrType=="firstpre"){
//		appendTextareaStr(resultItems.join("\r")+"\r");	
//		window.parent.commonCloseWin();	
//	}else{
//		CommonSaveEmr(emrType,$("#EpisodeID").val(),function(ret){
//			if(ret==0){
//				appendTextareaStr(resultItems.join("\r")+"\r");	
//				window.parent.commonCloseWin();	
//			}	
//	},'',paramArr.join("^"))
//	}

}

function quoteOrder(){
	var resultItems = new Array(); 
	var checkedItems = $('#OrderDatagrid').datagrid('getChecked');
	if(checkedItems.length==0){
		//$.messager.alert('提示','请选择医嘱');
		//return;	
	}
	$.each(checkedItems, function(index, item)
	{	
		var itm="";
		itm=item.OrdCreateDate;
		itm=itm+"	"+item.ArcimDesc;
		itm=itm+","+item.DoseQty;
		itm=itm+","+item.DoseUnit;
		itm=itm+","+item.Instr;
		itm=itm+","+item.PHFreq;
		resultItems.push(itm)
		
	});
	appendTextareaStr(resultItems.join("\r")+"\r");
	//window.parent.commonCloseWin()
}

function quoteDia(){
	var resultItems = new Array(); 
	var checkedItems = $('#DiaDatagrid').datagrid('getChecked');
	if(checkedItems.length==0){
		//$.messager.alert('提示','请选择医嘱');
		//return;	
	}
	$.each(checkedItems, function(index, item)
	{	
		var itm="";
		//itm=item.ADateTime;
		//itm=itm+"	"+item.ADiagnosName;
		itm=item.ADiagnosName;
		resultItems.push(itm)
		
	});
	appendTextareaStr(resultItems.join("\r")+"\r");
	//window.parent.commonCloseWin()
}
function appendTextareaStr(str){
	
	var val = window.parent.$("#EditPanel").val();
	if (str.replace(/(^\s*)|(\s*$)/g, "") != ""){
		window.parent.$("#EditPanel").val(val+str);
	}
	
//	var obj;
//	var emrType=$("#emrType").val();
//	if(window.parent.frames[""+emrType+""].document==undefined){
//		obj=window.parent.frames[""+emrType+""].contentWindow.document.body;
//	}else{
//		obj=window.parent.frames[""+emrType+""].document;
//	}
//	var ElementId=$("#ElementId").val()
//	if(ElementId!=""){
//		var val=$(obj).find("#"+ElementId+"").val()
//		$(obj).find("#"+ElementId+"").val(val+str)
//	}
}

function getDocument(){
	var obj;
	if(window.parent.frames["review"].document==undefined){
		obj=window.parent.frames["review"].contentWindow.document.body;
	}else{
		obj=window.parent.frames["review"].document;
	}
	return obj;
}


///初始化检验tab签
function initLis(){
	if(lisFlag==0){
		lisFlag=1;
		initLisDatagrid();
	}
	
}
///初始化PACStab签
function initPacs(){
	if(pacsFlag==0){
		pacsFlag=1;
		var option=getComboGridOpt();
		var opt={ onChange : function(now, old) {searchPacs();}}
		$.extend(option,opt);
		$('#admPacsListCombogrid').combogrid(option);
		initPacsDatagrid();
	}	
}
///初始化医嘱tab签
function initOrder(){
	if(orderFlag==0){
		orderFlag=1;
		var option=getComboGridOpt();
		var opt={ onChange : function(now, old) {searchOrder();}}
		$.extend(option,opt);
		$('#admOrderListCombogrid').combogrid(option);
		initOrderDatagrid();
	}	
}
///初始化诊断tab签
function initDia(){
	var option=getComboGridOpt();
	var opt={ onChange : function(now, old) {searchDia();}}
	$.extend(option,opt);
	$('#admDiaListCombogrid').combogrid(option);
	initDiaDatagrid();	
}
///初始化病理tab签
function initPatHology(){
	if (pathology==0){
		pathology=1;
		initPatHologyDatagrid();
	}
}
///////////////////////////////////////////////////////initDatagrid
///初始化检验和产前筛查
function initLisDatagrid(){
		
		$('#LisDatagrid').datagrid({
			title:$g('检验项目'),
			iconCls:'icon-paper',
			headerCls:'panel-header-gray',
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=listLis',
		    fit:true,
		    fitColumns:true,
		   	pageSize:10,
		    pageList:[10,20,30],
		   	rownumbers:true,
		    pagination:true,
		    singleSelect:true,
		    toolbar:"#LisDatagridTB",
			onBeforeLoad:function(param){
				var type=$("input[name='queryType']:checked").val()
				var EpisodeIDs=$("#EpisodeID").val()
				if(type=="all"){
					adm=$('#admListCombogrid').combogrid('getValue');
					
					if(adm==undefined){
						return;
					}
					EpisodeIDs=adm
				}
				//结果异常
				if($("input[name='queryExceptionPrenatal']:checked").length>0){
		          param.Exception=1;
		        }
		        var prenatal=$("input[name='queryPrenatal']:checked").val()
		        //产前检查
		        if(prenatal=="Screening"){
		          param.PrenatalScreening=1;
		        }
		        //产前诊断
		        if(prenatal=="Diagnosis"){
		          param.PrenatalScreening=2;
		        }
				param.type=type
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		        {field:'OEordItemDesc',title:'医嘱名称',width:200},
		        {field:'SpecimenDesc',title:'标本类型',width:100},
		        {field:'LabEpisodeNo',title:'标本号',width:100},
		        {field:'AuthorisationDate',title:'审核日期',width:100},
		        {field:'AuthorisationTime',title:'审核时间',width:60},
		        {field:'EpisodeDate',title:'就诊日期',width:100},
		        {field:'DeptDesc',title:'就诊科室',width:100}
		    ]],
		    onCheck:function(rowIndex,rowData){
			    searchLisSub();
		    },
		    onUncheck:function(rowIndex,rowData){
			    searchLisSub();
		    },
		    onCheckAll:function(rows){
				searchLisSub();
			},
			onUncheckAll:function(rows){
				searchLisSub();
			}		
		});
		//检验明细datagrid
		$('#LisSubDatagrid').datagrid({
			title:$g('检验结果'),
			iconCls:'icon-paper',
			headerCls:'panel-header-gray',
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=listLisSub',
		    fit:true,
		    fitColumns:true,
		   	rownumbers:true,
		    singleSelect:false,
		    columns:[[
		    	{field:'ck',checkbox:true},
		    	{field:'OeordID',hidden:true},
		        {field:'ItemDesc',title:'描述',width:200},
		        {field:'Synonym',title:'缩写',width:100},
		        {field:'ItemResult',title:'结果',width:100},
		        {field:'ItemUnit',title:'单位',width:100},
		        {field:'AbnorFlag',title:'异常提醒',width:100},
		        {field:'ItemRanges',title:'范围值',width:100}
		    ]],
		    rowStyler: function(index,row){
				if ((row.AbnorFlag != "")&&(row.AbnorFlag != "正常")){
					return 'color:#FF0000;';
				}
			},
			onLoadSuccess:function(data){//当表格成功加载时执行               
	            var rowData = data.rows;
	            $.each(rowData,function(idx,val){//遍历JSON
		        //AbnorFlagCheck检验数据启用异常值默认勾选
		        if( val.AbnorFlag != "" && val.AbnorFlag != "正常"){
	                     $("#LisSubDatagrid").datagrid("selectRow", idx); //选中行
	             	}
	           });              
	        }
		});
}

///初始化pacs
function initPacsDatagrid(){
		$('#PacsDatagrid').datagrid({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=listPacs',
		    fit:true,
		    fitColumns:true,
		   	pageSize:10,
		    pageList:[10,20,30],
		   	rownumbers:true,
		    pagination:true,
		    singleSelect:false,
		    toolbar:"#PacsDatagridTB",
			onBeforeLoad:function(param){
				var type=$("input[name='queryPacsType']:checked").val()
				var EpisodeIDs=$("#EpisodeID").val()
				if(type=="all"){
					adm=$('#admPacsListCombogrid').combogrid('getValue');
					
					if(adm==undefined){
						return;
					}
					EpisodeIDs=adm
				}
				//NT
				if($("input[name='queryPacsNT']:checked").length>0){
		          param.NT=7;
		        }
				param.type=type
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		        {field:'OrdCreateDate',title:'医嘱日期',width:100},
		        {field:'OrdCreateTime',title:'医嘱时间',width:60},
		        {field:'ItemName',title:'医嘱名称',width:200},
		        {field:'RrtDate',title:'报告日期',width:100},
		        {field:'RrtTime',title:'报告时间',width:60},
		        {field:'EpisodeDate',title:'就诊日期',width:100},
		        {field:'DeptDesc',title:'就诊科室',width:100}
		    ]],
		    onCheck:function(rowIndex,rowData){
			    searchPacsSub();
		    },
		    onUncheck:function(rowIndex,rowData){
			    searchPacsSub();
		    },
		    onCheckAll:function(rows){
				searchPacsSub();
			},
			onUncheckAll:function(rows){
				searchPacsSub();
			}		
		});
		
	
		$('#PacsSubDatagrid').datagrid({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=listPacsSub',
		    fit:true,
		   	rownumbers:true,
		    singleSelect:false,
		    fitColumns:true,
		    nowrap:false,
			onBeforeLoad:function(param){
				var OeordIDArr=[];
				var ids = $('#PacsDatagrid').datagrid('getChecked');
				for(var i=0;i<ids.length;i++) {
					OeordIDArr.push(ids[i].OEOrdItemDR);
				}
				param.OeordIDs=OeordIDArr.join("^");
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		        {field:'ExamDesc',title:'检查所见',width:350},
		        {field:'strResult',title:'诊断意见',width:250},
		        {field:'strOrderName',title:'检查方法',width:150}
		    ]]		
		});	
}
///初始化病理Datagrid
function initPatHologyDatagrid(){
		$('#PatHologyDatagrid').datagrid({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=ListPatHology',
		    fit:true,
		    fitColumns:true,
		   	pageSize:10,
		    pageList:[10,20,30],
		   	rownumbers:true,
		    pagination:true,
		    singleSelect:true,
		    toolbar:"#PatHologyDatagridTB",
			onBeforeLoad:function(param){
				var type=$("input[name='queryPatHologyType']:checked").val();
				//var TCT=$("input[name='queryPatHologyTCT']:checked");
				var EpisodeIDs=$("#EpisodeID").val()
				if(type=="all"){
					adm=$('#admPatHologyListCombogrid').combogrid('getValue');
					
					if(adm==undefined){
						return;
					}
					EpisodeIDs=adm
				}
				param.type=type
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		    	{field:'tmid',hidden:true},
		    	{field:'ordername',title:'医嘱名称',width:200},
		        {field:'AppDate',title:'申请日期',width:100},
		        {field:'AppTime',title:'申请时间',width:60},
		        {field:'SpeInfo',title:'标本信息',width:100}
		    ]],
		    onCheck:function(rowIndex,rowData){
			    searchPatHologySub();
		    },
		    onUncheck:function(rowIndex,rowData){
			    searchPatHologySub();
		    },
		    onCheckAll:function(rows){
				searchPatHologySub();
			},
			onUncheckAll:function(rows){
				searchPatHologySub();
			}		
		});
		
	
		$('#PatHologySubDatagrid').datagrid({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=ListPatHologySub',
		    fit:true,
		   	rownumbers:true,
		    singleSelect:false,
		    fitColumns:true,
		    nowrap:false,
			onBeforeLoad:function(param){
				var tmid="";
				var ids = $('#PatHologyDatagrid').datagrid('getChecked');
				for(var i=0;i<ids.length;i++) {
					tmid=ids[i].tmid;
				}
				param.Tmrowid=tmid;
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		    	{field:'RptDate',title:'报告日期',width:150},
		        {field:'Seeing',title:'检查所见',width:350},
		        {field:'Diagnosis',title:'病理诊断',width:350},
		        {field:'PathId',title:'病理号',width:150}
		    ]]		
		});	
}
///初始化医嘱datagrid
function initOrderDatagrid(){
		$('#OrderDatagrid').datagrid({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=listOrder',
		    fit:true,
		    fitColumns:true,
		   	pageSize:10,
		    pageList:[10,20,30],
		   	rownumbers:true,
		    pagination:true,
		    toolbar:"#OrderDatagridTB",
			onBeforeLoad:function(param){
				var type=$("input[name='queryOrderType']:checked").val()
				var EpisodeIDs=$("#EpisodeID").val()
				if(type=="all"){
					adm=$('#admOrderListCombogrid').combogrid('getValue');
					
					if(adm==undefined){
						//$.messager.alert('提示','请选择就诊记录');
						return;
					}
					EpisodeIDs=adm
				}
				if(type=="long"){
					param.type="S";
				}
				if(type=="short"){
					param.type="N";
				}
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		        {field:'OrdCreateDate',title:'医嘱日期',width:80},
		        {field:'ArcimDesc',title:'医嘱名称',width:250},
		        {field:'DoseQty',title:'剂量',width:50},
		        {field:'DoseUnit',title:'剂量单位',width:50},
		        {field:'Instr',title:'服用方法',width:100},
		        {field:'PHFreq',title:'频率 ',width:150},
		        {field:'OrdStatus',title:'状态 ',width:100},
		        {field:'mOeori',title:'mOeori ',width:100,hidden:true},
		        {field:'Oeori',title:'Oeori ',width:100,hidden:true}
		    ]],
		    onLoadSuccess:function(){
			  $(this).datagrid('clearChecked')
			},
		    onCheck:function(index,row){
				CheckLinkOrder(index, row,0);

			},
			onUncheck:function(index,row){
				CheckLinkOrder(index, row,1);
			}		
		});	
}

///初始化诊断datagrid
function initDiaDatagrid(){
		$('#DiaDatagrid').datagrid({
		    url:'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=ListDiagns',
		    fit:true,
		    fitColumns:true,
		   	pageSize:10,
		    pageList:[10,20,30],
		   	rownumbers:true,
		    pagination:true,
		    singleSelect:false,
		    toolbar:"#DiaDatagridTB",
			onBeforeLoad:function(param){
				var type=$("input[name='queryDiaType']:checked").val()
				var EpisodeIDs=$("#EpisodeID").val()
				if(type=="all"){
					adm=$('#admDiaListCombogrid').combogrid('getValue');
					
					if(adm==undefined){
						//$.messager.alert('提示','请选择就诊记录');
						return;
					}
					EpisodeIDs=adm
				}
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		    	{field:'ADiagnosName',title:'诊断名称',width:250},
		        {field:'ADiagnosType',title:'诊断类型',width:100},
		        {field:'AEvaluationDesc',title:'状态名称 ',width:50},
		        {field:'AICDCode',title:'诊断代码',width:100},
		        {field:'AEffectsDesc',title:'转归名称',hidden:true},
		        {field:'ALevel',title:'级别',hidden:true},
		        {field:'AUserName',title:'医生',width:100},
		        {field:'ADateTime',title:'时间 ',width:100},
		        {field:'ADemo',title:'备注',width:100},
		        {field:'mainMRID',title:'mainMRID',width:100}
		    ]],
		   onCheck:function(index,row){
				CheckLinkOrd(index, row,0);

			},
			onUncheck:function(index,row){
				CheckLinkOrd(index, row,1);
			}
		    		
		});	
}
function getComboGridOpt(){
	var option={
	    panelWidth:750,
	    mode: 'remote',
	    fitColumns:true,
	    url: 'dhcapp.broker.csp?ClassName=web.DHCEMQuote&MethodName=GetAdmList&EpisodeID='+$("#EpisodeID").val(),
	    idField: 'EpisodeID',
	    textField: 'EpisodeID',
	   	rownumbers:true,
	    pagination:true,
	    columns: [[
	    	{field:'EpisodeID',hidden:true},
			{field:'MedicareNo',title:'病案号',width:120},
			{field:'EpisodeDate',title:'就诊日期',width:80},
			{field:'EpisodeTime',title:'就诊时间',width:60},
			{field:'EpisodeDeptDesc',title:'科室',width:120},
			{field:'Diagnosis',title:'诊断',width:120},
			{field:'MainDocName',title:'就诊医生',width:80},
			{field:'EpisodeType',title:'就诊类型',width:80}
	    ]]   
	}
	return option;
}

function CheckLinkOrd(rowIndex, rowData,check){

	var rows = $("#DiaDatagrid").datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(i==rowIndex){
			continue;
		}
		if(rowData.mainMRID == rows[i].mainMRID){
			selects= $("#DiaDatagrid").datagrid('getSelections');
			selectFlag=0;
			for(j=0;j<selects.length;j++){
				if(selects[j].ARowID == rows[i].ARowID){ selectFlag = 1}
			}
			if(check==1){
				if(selectFlag==1){
					$("#DiaDatagrid").datagrid('uncheckRow',i);  //qx
				}
			}else{
				if(selectFlag==0){
					$("#DiaDatagrid").datagrid('checkRow',i);
				}
			}
		}
	}
}

/// 
function CheckLinkOrder(rowIndex, rowData,check){

	var rows = $("#OrderDatagrid").datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(i==rowIndex){
			continue;
		}
		if(rowData.mOeori == rows[i].mOeori){
			selects= $("#OrderDatagrid").datagrid('getSelections');
			selectFlag=0;
			for(j=0;j<selects.length;j++){
				if(selects[j].Oeori == rows[i].Oeori){ selectFlag = 1}
			}
			if(check==1){
				if(selectFlag==1){
					$("#OrderDatagrid").datagrid('uncheckRow',i);  //qx
				}
			}else{
				if(selectFlag==0){
					$("#OrderDatagrid").datagrid('checkRow',i);
				}
			}
		}
	}
}

/// 引用
function quote(){
	
	var title = $("#quoteTab").tabs('getSelected').panel('options').title;
	if (title == $g("诊断")){
		quoteDia();
	}
	if (title == $g("检验")){
		quoteLis();
	}
	if (title == $g("检查")){
		quotePacs();
	}
	if (title == $g("医嘱")){
		quoteOrder();
	}
	if (title == $g("病理")){
		quotePatHology();
	}
}