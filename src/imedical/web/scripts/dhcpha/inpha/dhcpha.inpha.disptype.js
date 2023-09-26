/**
 * 模块:住院药房
 * 子模块:住院药房-首页-侧菜单-发药类别维护
 * createdate:2016-06-21
 * creator: yunhaibao
 */

var commonOutPhaUrl = "DHCST.INPHA.ACTION.csp";
var url = "dhcpha.inpha.disptype.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var HospId=session['LOGON.HOSPID'];
var gridChkIcon='<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>'
$(function(){
	InitHospCombo(); //加载医院
	InitDispTypeGrid();	
	InitArcItemCatGrid();	
	$('#btnAdd').on('click',function(){
		$('#disptypewin').window('open');
		$("input[type=checkbox][name=chkcondition]").prop('checked',false);
		$("input[type=text][name=txtcondition]").val("");
	});
	$('#btnSaveCat').on('click',btnSaveCatHandler);
	$('#btnCancel').on('click',function(){
		$('#disptypewin').window('close');
	});
	$('#btnDelete').on('click', btnDeleteHandler);//点击删除
	$('#btnUpdate').on('click', btnUpdateHandler);//点击修改
});

//初始化发药类别列表
function InitDispTypeGrid(){
	//定义columns
	var columns=[[
        {field:'tCode',title:'代码',width:100},
        {field:'tDesc',title:'名称',width:100},
        {field:'tRowid',title:'tRowid',width:100,hidden:true},
        {field:'tOrdType',title:'类型',width:100,hidden:true},
        {field:'tPrtDetail',title:'打印明细',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtTotal',title:'打印汇总',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtOther',title:'打印其他',width:100},
        {field:'tReserve',title:'冲减退药',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tIsPreView',title:'预览打印',width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tIsPack',title:'分散包装发药',width:80,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tReqFlag',title:'自动建退药申请',width:90,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtResRet',title:'打印冲减退药单',width:90,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	//return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'tPrtNoStock',title:'打印库存不足',width:80,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        }
	]];  
	
   //定义datagrid	
   $('#disptypegrid').datagrid({    
        url:url+'?action=QueryDispType',
        queryParams: {
	        params: HospId
	    },
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
	    singleSelect:true,
	    fit:true,
	    loadMsg: '正在加载信息...',
	    fitColumns:true,
	    onSelect:function(rowIndex,rowData){
		    var chkArcItemCat=""
		    if ($('#chkArcItemCat').is(':checked')){
		    	chkArcItemCat=1
		    }
			$('#arcitemcatgird').datagrid('options').queryParams.params = rowData.tRowid+"^"+chkArcItemCat+"^"+HospId;//传递值  
    		$("#arcitemcatgird").datagrid('reload');//重新加载table  
		},
		onLoadSuccess: function(){
         	var txtrowindex=$("#txtRowIndex").val();
         	if (txtrowindex!=""){
	         	$('#disptypegrid').datagrid("selectRow", txtrowindex)
         	}
         	else{
	        	$('#arcitemcatgird').datagrid('loadData',{total:0,rows:[]}); 
				$('#arcitemcatgird').datagrid('options').queryParams.params = ""; 
	        }
         	
	    } 
   });
}
//初始化医嘱子类列表
function InitArcItemCatGrid(){
	//定义columns
	var columns=[[
        {field:'tOrdCatRowid',title:'tOrdCatRowid',width:100,hidden:true},
        {field:'tOrdCatCode',title:'医嘱子类代码',width:100},
        {field:'tOrdCatDesc',title:'医嘱子类名称',width:300},
        {field:'tDispCat',title:'所属发药类别',width:200},
        {field:'tSelect',title:'选择',width:50,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
	    },
        {field:'tWholeDisp',title:'满整支发药',width:100,align:'center',
        	formatter:function(value,row,index){
	        	if (value=="1"){
	        		return gridChkIcon;
	        	}else{
		        	///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        }
	]];  
	
   //定义datagrid	
   $('#arcitemcatgird').datagrid({    
        url:url+'?action=QueryArcItemCat',
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
	    singleSelect:true,
	    fit:true,
	    loadMsg: '正在加载信息...',
	    onClickRow:function(rowIndex,rowData){

		},
		onDblClickCell: function (rowIndex, field, value) {
			if ((field!="tSelect")&&(field!="tWholeDisp")){return;}
			var disptypeselect=$("#disptypegrid").datagrid('getSelected');
			if (disptypeselect==null){
				return;
			}
			var disptypedesc=disptypeselect["tDesc"];
			var disptypeid=disptypeselect["tRowid"];
			var arccatselect=$('#arcitemcatgird').datagrid('getData').rows[rowIndex];			
			var arcitemcat=arccatselect["tOrdCatDesc"];
			var olddisptype=arccatselect["tDispCat"];
			var arcitemcatid=arccatselect["tOrdCatRowid"];
			var wholedisp=arccatselect["tWholeDisp"];
			if ((olddisptype=="")||(olddisptype==undefined)){
				olddisptype="";
			}
			if (field=="tSelect"){
				if (olddisptype==disptypedesc){
					$.messager.alert("提示","改后类别与原类别一致,无需修改!","info")
					return;
				}
				var msginfo="<p>医嘱子类:<font color=blue><b>"+arcitemcat+"</b></font></p>"+
							"<p>发药类别:<font color=blue><b>"+olddisptype+"=>"+disptypedesc+"</b></font></p>"
				$.messager.confirm('是否确认修改?', msginfo, function(r) {
			    	if(r==true){
				    	var insret=tkMakeServerCall("web.DHCINPHA.DispType","SaveCatSub",disptypeid,arcitemcatid)
				    	if (insret<0){
							$.messager.alert("提示","修改失败,错误代码:"+insret,"warning")
							return;
					    }else{
						    var columns = $('#arcitemcatgird').datagrid("options").columns;
						    var columnsstr=$('#arcitemcatgird').datagrid('getColumnFields',false);
   							var selectNum=columnsstr.indexOf("tSelect");
   							var dispcatNum=columnsstr.indexOf("tDispCat");
							arccatselect[columns[0][dispcatNum].field]=disptypedesc;
							arccatselect[columns[0][selectNum].field]=1;
							$('#arcitemcatgird').datagrid('refreshRow', rowIndex);							
						}
				    }else{
						return;
					}
				});
			}else if (field=="tWholeDisp"){
				if (arccatselect.tSelect==0){
					$.messager.alert("提示","医嘱子类不在当前选中的发药类别中!","info")
					return;					
				}				
				var msginfo="<p>医嘱子类:<font color=blue><b>"+arcitemcat+"</b></font></p>"
				var msginfo1="<p>将修改为:<font color=blue><b>满整支发药</b></font></p>"
				if (wholedisp=="1"){
					msginfo1="<p>取　　消:<font color=blue><b>满整支发药</b></font></p>"
					wholedisp="0"
				}else{
					wholedisp="1"
				}
				msginfo=msginfo+msginfo1
				$.messager.confirm('是否确认修改?', msginfo, function(r) {
			    	if(r==true){
				    	var insret=tkMakeServerCall("web.DHCINPHA.DispType","SaveWholeDispConfig",arcitemcatid,wholedisp)
				    	if (insret<0){
					    	if (insret=="-1"){
						    	$.messager.alert("提示","请先维护医嘱子类的发药类别!","info")
								return;
						    }else{					    	
								$.messager.alert("提示","修改失败,错误代码:"+insret,"warning")
								return;
						    }
					    }else{
						    var columns = $('#arcitemcatgird').datagrid("options").columns;
						    var columnsstr=$('#arcitemcatgird').datagrid('getColumnFields',false);
   							var wholeNum=columnsstr.indexOf("tWholeDisp");
							arccatselect[columns[0][wholeNum].field]=wholedisp;
							$('#arcitemcatgird').datagrid('refreshRow', rowIndex);							
						}
				    }else{
						return;
					}
				});

			}
		}
  
   });
}

///发药类别删除
function btnDeleteHandler(){
	var seletcted = $("#disptypegrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('提示',"请先选中需删除的行!","info");
		return;
	}
	var disptypeid=seletcted.tRowid;
	var disptypedesc=seletcted.tDesc;
	var msginfo="<p>发药类别:<font color=blue><b>"+disptypedesc+"</b></font></p>"+
				"<p><font color=red><b>请确保该发药类别尚未下医嘱,谨慎操作!</b></font></p>"	
	$.messager.confirm('确认删除吗？',msginfo,function(r){
		if(r){
			$.messager.confirm('再次确认是否需要删除？','发药类别为住院发药核心数据!',function(r1){
				if (r1){
					var delret=tkMakeServerCall("web.DHCSTPHADRUGGROUP","DeleteMast",disptypeid,HospId);
					if(delret>0){
						$('#disptypegrid').datagrid('reload');
					}
					else{
						$.messager.alert('提示',"删除失败!");
					}
				}
			})
			
		}
	});
}
//保存发药类别
function btnSaveCatHandler(){
	var rowid=$.trim($("#txtRowId").val());
	var code=$.trim($("#txtCode").val());
	var desc=$.trim($("#txtDesc").val()); 
	if (code==""){
		$.messager.alert('提示',"代码为空!","info");
		return;
	}
	if(desc==""){
		$.messager.alert('提示',"名称为空!","info");
		return;
	}
	var prtOther=$.trim($("#txtPrtOther").val());
  	var prtTotal=0;prtDetail=0;ispack=0;reserve=0,reqflag=0;
  	var prtResRet=0,isPreView=0,prtNoStock=0;
	if ($("#chkPrtTotal").is(':checked')){
		prtTotal="1"
	}
	if ($("#chkPrtDetail").is(':checked')){
		prtDetail="1"
	}
	if ($("#chkIsPack").is(':checked')){
		ispack="1"
	}
	if ($("#chkReserve").is(':checked')){
		reserve="1"
	}
	if ($("#chkReqFlag").is(':checked')){
		reqflag="1"
	}
	if ($("#chkPrtResRet").is(':checked')){
		prtResRet="1"
	}
	if ($("#chkIsPreView").is(':checked')){
		isPreView="1"
	}
	if ($("#chkPrtNoStock").is(':checked')){
		prtNoStock="1"
	}
	var ConfigStr=code+"^"+prtDetail+"^"+prtTotal+"^"+prtOther+"^"+prtResRet+"^"+isPreView+"^"+prtNoStock
	var ConfigStr=ConfigStr+"@"+ispack+"@"+reserve+"@"+reqflag+"@"+HospId;
	var ret=""
	if (rowid>0){
		ret=tkMakeServerCall("web.DHCSTPHADRUGGROUP","UpdateMast",rowid,code,desc,ConfigStr)
	}else{
		ret=tkMakeServerCall("web.DHCSTPHADRUGGROUP","InsertMast",code,desc,ConfigStr)
	}
	var retArr=ret.split("^");
	if (retArr[0]<0) {
		if ((retArr[1]!="")&&(retArr[1]!=undefined)){
			$.messager.alert('提示',retArr[1],"warning");
		}else{
			$.messager.alert('提示',"保存失败,错误代码:"+ret,"error");
		}
		return ;	
	}else{
		$('#disptypewin').window('close');
		$('#disptypegrid').datagrid('reload');
	}	

}
//修改发药类别
function btnUpdateHandler(){
	var seletcted = $("#disptypegrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('提示',"请先选中需修改的行!","info");
		return;
	}
	var selectrow=$('#disptypegrid').datagrid("getRowIndex",seletcted);
	$('#disptypewin').window('open');
	$("input[type=checkbox][name=chkcondition]").prop('checked',false);
	$("input[type=text][name=txtcondition]").val("");
	$("#txtRowId").val(seletcted.tRowid);
	$("#txtCode").val(seletcted.tCode);
	$("#txtDesc").val(seletcted.tDesc);
	$("#txtRowIndex").val(selectrow);
	$("#txtPrtOther").val(seletcted.tPrtOther);
	if (seletcted.tPrtTotal=="1"){
		$('#chkPrtTotal').prop('checked',true); 
	}
	if (seletcted.tPrtDetail=="1"){
		$('#chkPrtDetail').prop('checked',true); 
	}
	if (seletcted.tIsPack=="1"){
		$('#chkIsPack').prop('checked',true); 
	}
	if (seletcted.tReserve=="1"){
		$('#chkReserve').prop('checked',true); 
	}
	if (seletcted.tReqFlag=="1"){
		$('#chkReqFlag').prop('checked',true); 
	}
	if (seletcted.tPrtResRet=="1"){
		$('#chkPrtResRet').prop('checked',true); 
	}
	if (seletcted.tIsPreView=="1"){
		$('#chkIsPreView').prop('checked',true); 
	}
	if (seletcted.tPrtNoStock=="1"){
		$('#chkPrtNoStock').prop('checked',true); 
	}
}


function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'DHCStkDrugGroup'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#disptypegrid').datagrid({    
			        queryParams: {
				        params: HospId
				    }
				});				
				$('#arcitemcatgird').datagrid('loadData',[]);				
			}
        };
	}
}