//quote.js
//���ò���js
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
			if(title==$g("����")){
				initLis();
			}
			if(title==$g("���")){
				initPacs();
			}
			if(title==$g("ҽ��")){
				initOrder();
			}
			if(title==$g("���")){
				initDia();
			}
			if(title==$g("����")){
				initPatHology();
			}
	    }
	});
}

function initPage(type){
	if(type==2){
		
//		if(type==2){
//			//��ǰɸ��
//			$('input[name=queryPrenatal][value=Screening]').prop('checked', true);
//		}
//		if(type==6){
//			//��ǰ���
//			$('input[name=queryPrenatal][value=Diagnosis]').prop('checked', true);
//		}
		$("#quoteTab").tabs("select",$g("����"));
	}
	if(type==5){
		//NT
//		if(type==11){
//			$("input[name='queryPacsNT'][value=NT]").prop('checked', true);
//		}	
		$("#quoteTab").tabs("select",$g("���"));
	}
	if(type==8){
		$("#quoteTab").tabs("select",$g("ҽ��"));
	}

	if(type==9){
		$("#quoteTab").tabs("select",$g("���"));
	}
	if(type==10){
		$("#quoteTab").tabs("select",$g("����"));
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
//����(���飬��ǰɸ�飬��ǰ���)
function quoteLis(){
	
	var resultItems = new Array();
	var mainsItems=$('#LisDatagrid').datagrid('getChecked');
	var checkedSubItems=$('#LisSubDatagrid').datagrid('getChecked');
	if(checkedSubItems.length==0){
		//$.messager.alert('��ʾ','��ѡ��');
		//return;	
	}

	$.each(checkedSubItems, function(subIndex, subItem)
	{			
		//resultItems.push(subItem.OeordID+":"+subItem.Synonym);
		resultItems.push(subItem.ItemDesc + ":" + subItem.ItemResult + "" + subItem.ItemUnit);
	});
	
	//���ӵ���ϸ����
	appendTextareaStr(mainsItems[0].OEordItemDesc +" "+ resultItems.join("\r")+"\r");
	
//	var type=3;
//	var prenatal=$("input[name='queryPrenatal']:checked").val()
//	//��ǰ���
//    if(prenatal=="Screening"){type=1;}
//    //��ǰ���
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
//							//ˢ�¸������
//							if(window.parent.frames["review"].document==undefined){
//								window.parent.frames["review"].contentWindow.initValue();
//							}else{
//								obj=window.parent.frames["review"].initValue();
//							}
//							//���ӵ���ϸ����
//							appendTextareaStr(resultItems.join("\r")+"\r");
//							window.parent.commonCloseWin();	
//						}else{
//							$.messager.alert('��ʾ','����ʧ��'+data);	
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
		//$.messager.alert('��ʾ','��ѡ��');
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
					itm=itm+"\r�������: "+subItem.ExamDesc
				}
				if(pacsstrResult==1){
					itm=itm+"\r������:"+subItem.strResult;
				}
				if(pacsstrOrderName==1){
					itm=itm+"\r��鷽��: "+subItem.strOrderName
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

///���ò�����
function quotePatHology(){
	var resultItems = new Array(); 
	var PatHologyDate=$("input[name='PatHologyDate']:checked").length
	var PatHologySee=$("input[name='PatHologySee']:checked").length
	var PatHologyDia=$("input[name='PatHologyDia']:checked").length
	var PatHologyNo=$("input[name='PatHologyNo']:checked").length
	
	var checkedItems = $('#PatHologyDatagrid').datagrid('getChecked');
	var checkedSubItems=$('#PatHologySubDatagrid').datagrid('getChecked');
	if(checkedSubItems.length==0){
		//$.messager.alert('��ʾ','��ѡ��');
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
					itm=itm+"\r��������: "+subItem.RptDate
				}
				if(PatHologySee==1){
					itm=itm+"\r�������:"+subItem.Seeing;
				}
				if(PatHologyDia==1){
					itm=itm+"\r�������: "+subItem.Diagnosis
				}
				if(PatHologyNo==1){
					itm=itm+"\r�����: "+subItem.PathId
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
		//$.messager.alert('��ʾ','��ѡ��ҽ��');
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
		//$.messager.alert('��ʾ','��ѡ��ҽ��');
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


///��ʼ������tabǩ
function initLis(){
	if(lisFlag==0){
		lisFlag=1;
		initLisDatagrid();
	}
	
}
///��ʼ��PACStabǩ
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
///��ʼ��ҽ��tabǩ
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
///��ʼ�����tabǩ
function initDia(){
	var option=getComboGridOpt();
	var opt={ onChange : function(now, old) {searchDia();}}
	$.extend(option,opt);
	$('#admDiaListCombogrid').combogrid(option);
	initDiaDatagrid();	
}
///��ʼ������tabǩ
function initPatHology(){
	if (pathology==0){
		pathology=1;
		initPatHologyDatagrid();
	}
}
///////////////////////////////////////////////////////initDatagrid
///��ʼ������Ͳ�ǰɸ��
function initLisDatagrid(){
		
		$('#LisDatagrid').datagrid({
			title:$g('������Ŀ'),
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
				//����쳣
				if($("input[name='queryExceptionPrenatal']:checked").length>0){
		          param.Exception=1;
		        }
		        var prenatal=$("input[name='queryPrenatal']:checked").val()
		        //��ǰ���
		        if(prenatal=="Screening"){
		          param.PrenatalScreening=1;
		        }
		        //��ǰ���
		        if(prenatal=="Diagnosis"){
		          param.PrenatalScreening=2;
		        }
				param.type=type
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		        {field:'OEordItemDesc',title:'ҽ������',width:200},
		        {field:'SpecimenDesc',title:'�걾����',width:100},
		        {field:'LabEpisodeNo',title:'�걾��',width:100},
		        {field:'AuthorisationDate',title:'�������',width:100},
		        {field:'AuthorisationTime',title:'���ʱ��',width:60},
		        {field:'EpisodeDate',title:'��������',width:100},
		        {field:'DeptDesc',title:'�������',width:100}
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
		//������ϸdatagrid
		$('#LisSubDatagrid').datagrid({
			title:$g('������'),
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
		        {field:'ItemDesc',title:'����',width:200},
		        {field:'Synonym',title:'��д',width:100},
		        {field:'ItemResult',title:'���',width:100},
		        {field:'ItemUnit',title:'��λ',width:100},
		        {field:'AbnorFlag',title:'�쳣����',width:100},
		        {field:'ItemRanges',title:'��Χֵ',width:100}
		    ]],
		    rowStyler: function(index,row){
				if ((row.AbnorFlag != "")&&(row.AbnorFlag != "����")){
					return 'color:#FF0000;';
				}
			},
			onLoadSuccess:function(data){//�����ɹ�����ʱִ��               
	            var rowData = data.rows;
	            $.each(rowData,function(idx,val){//����JSON
		        //AbnorFlagCheck�������������쳣ֵĬ�Ϲ�ѡ
		        if( val.AbnorFlag != "" && val.AbnorFlag != "����"){
	                     $("#LisSubDatagrid").datagrid("selectRow", idx); //ѡ����
	             	}
	           });              
	        }
		});
}

///��ʼ��pacs
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
		        {field:'OrdCreateDate',title:'ҽ������',width:100},
		        {field:'OrdCreateTime',title:'ҽ��ʱ��',width:60},
		        {field:'ItemName',title:'ҽ������',width:200},
		        {field:'RrtDate',title:'��������',width:100},
		        {field:'RrtTime',title:'����ʱ��',width:60},
		        {field:'EpisodeDate',title:'��������',width:100},
		        {field:'DeptDesc',title:'�������',width:100}
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
		        {field:'ExamDesc',title:'�������',width:350},
		        {field:'strResult',title:'������',width:250},
		        {field:'strOrderName',title:'��鷽��',width:150}
		    ]]		
		});	
}
///��ʼ������Datagrid
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
		    	{field:'ordername',title:'ҽ������',width:200},
		        {field:'AppDate',title:'��������',width:100},
		        {field:'AppTime',title:'����ʱ��',width:60},
		        {field:'SpeInfo',title:'�걾��Ϣ',width:100}
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
		    	{field:'RptDate',title:'��������',width:150},
		        {field:'Seeing',title:'�������',width:350},
		        {field:'Diagnosis',title:'�������',width:350},
		        {field:'PathId',title:'�����',width:150}
		    ]]		
		});	
}
///��ʼ��ҽ��datagrid
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
						//$.messager.alert('��ʾ','��ѡ������¼');
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
		        {field:'OrdCreateDate',title:'ҽ������',width:80},
		        {field:'ArcimDesc',title:'ҽ������',width:250},
		        {field:'DoseQty',title:'����',width:50},
		        {field:'DoseUnit',title:'������λ',width:50},
		        {field:'Instr',title:'���÷���',width:100},
		        {field:'PHFreq',title:'Ƶ�� ',width:150},
		        {field:'OrdStatus',title:'״̬ ',width:100},
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

///��ʼ�����datagrid
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
						//$.messager.alert('��ʾ','��ѡ������¼');
						return;
					}
					EpisodeIDs=adm
				}
				param.EpisodeIDs=EpisodeIDs
				return param
			},
		    columns:[[
		    	{field:'ck',checkbox:true},
		    	{field:'ADiagnosName',title:'�������',width:250},
		        {field:'ADiagnosType',title:'�������',width:100},
		        {field:'AEvaluationDesc',title:'״̬���� ',width:50},
		        {field:'AICDCode',title:'��ϴ���',width:100},
		        {field:'AEffectsDesc',title:'ת������',hidden:true},
		        {field:'ALevel',title:'����',hidden:true},
		        {field:'AUserName',title:'ҽ��',width:100},
		        {field:'ADateTime',title:'ʱ�� ',width:100},
		        {field:'ADemo',title:'��ע',width:100},
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
			{field:'MedicareNo',title:'������',width:120},
			{field:'EpisodeDate',title:'��������',width:80},
			{field:'EpisodeTime',title:'����ʱ��',width:60},
			{field:'EpisodeDeptDesc',title:'����',width:120},
			{field:'Diagnosis',title:'���',width:120},
			{field:'MainDocName',title:'����ҽ��',width:80},
			{field:'EpisodeType',title:'��������',width:80}
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

/// ����
function quote(){
	
	var title = $("#quoteTab").tabs('getSelected').panel('options').title;
	if (title == $g("���")){
		quoteDia();
	}
	if (title == $g("����")){
		quoteLis();
	}
	if (title == $g("���")){
		quotePacs();
	}
	if (title == $g("ҽ��")){
		quoteOrder();
	}
	if (title == $g("����")){
		quotePatHology();
	}
}