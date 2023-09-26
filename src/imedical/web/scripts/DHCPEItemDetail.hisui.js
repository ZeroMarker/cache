
//名称	DHCPEItemDetail.hisui.js
//功能	项目明细
//创建	2020-02-12
//创建人  sxt
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
          
               var objtbl = $(target).datagrid('getRows');
	           var rows=objtbl.length
	          // alert(rows+"rows")
	         for (var j=0;j<rows;j++) {
		        var index=j;
		      	var Status=objtbl[j].StatDesc;
		      	
		      	//alert(objtbl[j].Station+"Station")
		      	//alert(objtbl[j]+"objtbl[j]")
		      	var placerCode=objtbl[j].placerCode;
		      //alert(placerCode+"placerCode")
		        if(placerCode!="") { 
		      		 $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"ItemDesc"+"]").css({"background-color":objtbl[j].placerCode});
		     	 } 
		      
		 	   Status=Status.replace(" ","")
		 	   //alert(Status+"Status")
		 	   if(Status=="核实"){
			 	   //alert(2)
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"yellow"});
			 	  
		 	   }
		 	   if(Status=="执行"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#00CC66"});
			 	  
		 	   }
		 	   if(Status=="谢绝检查"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#FF0000"});
			 	  
		 	   }
		 	    if(Status=="停止"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#FF88FF"});
			 	  
		 	   }
		 	   
		 	   
				
			}

	           
            }
});
$(function(){
		//alert(AdmId+"AdmId")	
	InitDataGrid();  
     
    // 更新标本号
	$("#BUpdateSpec").click(function() {	
		BUpdateSpec_click();		
        });
      
    //不打印
	$("#BSaveNoPrint").click(function() {	
		BSaveNoPrint_click();		
        });
             
    // 谢绝检查
    $('#Refuse').click(function(e){
    	Refuse_click();
    });
    
    
   
   
})
function InitDataGrid()
{
	
	$HUI.datagrid("#ItemDetailGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect:true,
		striped: true,
		//selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.OEOrdItem",
			QueryName:"FindOItemStatusForAdm",
			AdmId:AdmId,
		   
		},
		
		columns:[[
			{
					title: '选择',
					field: 'Select',
					width: 70,
					checkbox:true,
					/*formatter:function(value,rowData,index){
						return "<input type='checkbox' onclick=\"GetSelectIds('" + value + "', '" + index + "')\"/>"; 
					}
					
                  */
				
				},
		
		    {field:'RowId',title:'TId',hidden: true},
			{field:'StatDesc',color:'red',width:80,title:'状态'},
			{field:'ItemId',title:'TId',hidden: true},
			{field:'ItemDesc',width:200,title:'名称'},
			{field:'Station',width:60,title:'站点'},
			{field:'ItemCode',width:100,title:'项目编号'},
			{field:'LabNo',width:120,title:'标本号'},
			{field:'BillStatus',width:80,title:'收费状态'},
			{field:'Diet',width:80,title:'注意事项'},
			{field:'TResultStatus',width:80,title:'检验状态'},
			{field:'AccountAmount',width:100,title:'应收价格',align:'rigth'},
			{field:'FactAmount',width:100,title:'优惠价格',align:'rigth'},
			{field:'TSpecName',width:100,title:'样本'},
			{field:'TNotPrint',width:120,title:'报告上不打印',formatter:function(value,row,index){
		
			if (value==0)
			{
				return "<input class='hisui-checkbox' type='checkbox' style='margin-left:40px;' "
				return "打印"
			
				}
			else{
				return "<input class='hisui-checkbox' type='checkbox' checked='true' style='margin-left:40px;' "
				return "不打印"
				
				}
			
			}
			},
			{field:'TBloodDate',width:120,title:'采血日期'},
			{field:'OEORIRowId',width:120,title:'医嘱ID'},	
			{field:'TRefuseReason',width:180,title:'谢绝原因'},
			{field:'TDrugStatus',width:100,title:'药品状态'},
			{field:'TChecked',width:90,title:'退药申请',
			formatter:function(value,row,index){
				if(value==1){
				return "<input class='hisui-checkbox' type='checkbox' checked='true' style='margin-left:30px;' onclick='Chk_Click(\""+row.RowId+"\")'/>"
					}
				else{
				return "<input class='hisui-checkbox' type='checkbox' style='margin-left:30px;'  onclick='Chk_Click(\""+row.RowId+"\")'/>"
				}
			}
			},
			{field:'Trans',title:'调试结果',width:80,
			formatter:function(value,row,index){
					
					var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsLisRisStation",row.ItemId)
					if(flag==1){

					return "<a href='#' onclick='TransTest(\""+row.OEORIRowId+"\")'>\
					<img style='padding-left:20px;' title='' src='../scripts_lib/hisui-0.1.0/dist/css/icons/search.png' border=0/>\
					</a>";
					}
					
			}},		
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			
				
				$("#Source").val(rowData.LabNo);	
				 var Status=rowData.StatDesc;
				if((Status=="取消体检")||(Status=="谢绝检查")||(Status=="执行")||(rowData.LabNo=="")){
						$("#BUpdateSpec").linkbutton('disable');
						$("#To").attr('disabled',true);
		
				}else{
					$("#BUpdateSpec").linkbutton("enable");
					$("#To").attr('disabled',false);
			             
				} 

		},
		onClickCell: function(rowIndex, field, value){
		if(field == 'TNotPrint'){
			// 保存不打印
			var eSrc = window.event.srcElement;
			if(eSrc.checked==true)
			{
				var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"Y")
				$.messager.alert("提示", "保存成功", 'success');
				$(this).datagrid('reload')
				}
			if(eSrc.checked==false)
			{
				var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"")
				$.messager.alert("提示", "保存成功", 'success');
				$(this).datagrid('reload')
				}
			
			
		}
		if(field == 'TChecked'){
			var FeeStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].BillStatus;
			
			// 保存退药申请
			var DrugStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TDrugStatus;
			if(DrugStatus!="已发药") return false;
			if(FeeStatus.indexOf("挂帐") == -1 )
			{
			
			$.messager.alert("提示", "付费药品请去退费申请界面", 'success');
			
			return false;
			}
			
			var FeeStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TDrugStatus;
			if(FeeStatus.indexOf("已发药") == -1 )
			{
			
			$.messager.alert("提示", "不是已发药医嘱不能申请退药", 'success');
			
			return false;
			}
			
			var eSrc = window.event.srcElement;
			if(eSrc.checked==true)
			{
				var feeid="1"+"^"+$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TPreItemID 
				var drugperm=tkMakeServerCall("web.DHCPE.ItemFeeList","DrugPermControl",feeid,0,"")
				//alert(drugperm+"drugperm")
				if(drugperm!=2)
				{
				//var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"Y")
				$.messager.alert("提示", "申请成功", 'success');
				$(this).datagrid('reload')
				}
				else{
				setColumnValue(rowIndex,"TChecked",0)
				$.messager.alert("提示", "申请失败,失败代码"+drugperm, 'success');
				return false;	
				}
			}
			if(eSrc.checked==false)
			{
				//  ##class(PHA.FACE.OUT.Com).DelOutPhReq("1909||3^200270||2")
				var OEID=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId
				var ret=tkMakeServerCall("web.DHCPE.ItemFeeList","CancelDrugApply",OEID)
				if(ret==0){
				$.messager.alert("提示", "取消申请成功", 'success');
				$(this).datagrid('reload')
				}
				else{
				setColumnValue(rowIndex,"TChecked",1)
				$.messager.alert("提示", "取消申请失败，失败代码"+ret, 'success');
				
				return false;
				}
			}
			
			
		}
		
		},
		onLoadSuccess: function(rowData){
			
			
			for ( var i = 0; i < rowData.rows.length; i++) {
				$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true;
			/*
		    if (rowData.rows[i].TDrugStatus!="已发药") {
					$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true
						//$(this)[i].TChecked.disabled = true;

					}
			 if (rowData.rows[i].BillStatus.indexOf("挂帐") == -1 ) {
					$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true
						//$(this)[i].TChecked.disabled = true;

					}
					*/




	     }
			
			
		}
		
			
	})

}
function TransTest(OEORI)
{
	
	var lnk="dhcpetesttransresult.csp"+"?OEID="+OEORI
			;
	
	var wwidth=800;
	var wheight=600;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	//var ret=window.showModalDialog(lnk, "", nwin); 
	var cwin=window.open(lnk,"_blank",nwin)	
	
	
	}
//撤销/谢绝检查 
function Refuse_click(){
	
	//var OEORIRowIdStr=GetId();
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//获取的是数组，多行数据
	//alert(selectrow.length+"selectrow.length")
	for(var i=0;i<selectrow.length;i++){
			if(selectrow[i].StatDesc=="停止"){
			
			$.messager.alert("提示","停止的医嘱不能谢绝检查","info");
			return false;
			}
		
	   
		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}



	if(OEORIRowIdStr==""){
		$.messager.alert("提示","请选择医嘱","info");
		return false;
	}
	
    var flag=""
	var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetReportStaus",OEORIRowIdStr);
	if((flag=="已复检")||(flag=="已发送")||(flag=="已打印"))
	{
		if (!confirm("报告状态是："+flag+", 确定要进行该操作吗")) return;
		
	} 
   
	var RefuseCodeStr="";
	var Arr=OEORIRowIdStr.split("^");
	var Length=Arr.length;
	for (var i=0;i<Length;i++)
	{ 
		var OEORIRowId=Arr[i];
		
		var obj=document.getElementById("RefuseReason");
		if (obj){OEORIRowId=OEORIRowId+"^"+obj.value;}
		//alert(OEORIRowId+"OEORIRowId")
		var RefuseCode=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEORIRowId)
	
	if(RefuseCodeStr==""){var RefuseCodeStr=RefuseCode;}
	else{var RefuseCodeStr=RefuseCodeStr+"^"+RefuseCode;}
	
	}
	
	var RefuseArr=RefuseCodeStr.split("^");
	var RefuseLength=RefuseArr.length;
	var j=0
	for (var ii=0;ii<RefuseLength;ii++)
	{ 
		if(RefuseArr[ii]=="0") {j++;} 
	
	}
	if(ii==j){var flag="0";}
	if(RefuseCodeStr.indexOf("-1")>=0){var flag="-1";}
	if (flag=='0') {
		
		$.messager.alert("提示","修改成功!","success");
		
		}
	else if(flag=="-1")
	{
		
		$.messager.alert("提示","已执行项目不能再进行操作","info");
		
	}else{
		
		$.messager.alert("提示","拒绝失败","info");
   		
}
	$("#RefuseReason").val("");
	 $("#ItemDetailGrid").datagrid('reload'); 
	
}
function BSaveNoPrint_click()
{
	var IDS=""
	var items = $("input[name='TNotPrint']:checked");
    var result = "";
    $.each(items, function (index, item) {
	   // alert(item)
 	IDS = IDS + "^" + item.RowId;
 	});
	//alert(IDS+"IDS")
	
	
	var selectrow = $("#ItemDetailGrid").datagrid("getRows");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		alert(selectrow[i].RowId)
	alert(selectrow[i].TNotPrint.is(':checked'))
	
	}
}
function Chk_Click(ID)
{
	//alert(Type)
	var eSrc = window.event.srcElement;
	//alert(eSrc.checked)
	//alert(ID)
}
function BUpdateSpec_click()
{
	
	var Source=$("#Source").val();
	var To=$("#To").val();
	if (Source=="")
	{
		top.$.messager.alert("提示","原标本号不能为空","info");
		return false;
	}
	if (To=="")
	{
		top.$.messager.alert("提示","更新标本号不能为空","info");
		return false;
	}
  if(Source==To){
		$.messager.alert("提示","原标本号和新标本号一样,无需更新","info");
		return false;
	}
	
	var flag=tkMakeServerCall("web.DHCPE.BarPrint","IsUpdateSpec",AdmId,To);
	if(flag!="1"){
		$.messager.alert("提示","新标本号不是本人没执行过的标本号,请重新输入","info");
		return false;
		
	}
	var ret=tkMakeServerCall("web.DHCPE.BarPrint","UpdateSpec",Source,To); 
	$.messager.alert("提示","更新标本号成功","success");
	$("#To").val("");
	$('#ItemDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.OEOrdItem",
			QueryName:"FindOItemStatusForAdm",
			AdmId:AdmId,
	
	});
	
	}
