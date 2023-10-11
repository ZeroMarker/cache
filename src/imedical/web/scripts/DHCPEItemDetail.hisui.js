
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
	          
	         for (var j=0;j<rows;j++) {
		        var index=j;
		      	var Status=objtbl[j].StatDesc;
		      	var placerCode=objtbl[j].placerCode;

		        //alert(placerCode+"placerCode")
		        if(placerCode!="") { 
		      		 $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"ItemDesc"+"]").css({"background-color":objtbl[j].placerCode});
		     	 } 
		      
		 	   Status=Status.replace(" ","")
		 	   //alert(Status+"Status")
		 	   if(Status==$g("核实")){
			 	   //alert(2)
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#F1C516"});
			 	  
		 	   }
		 	   if(Status==$g("执行")){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#4A991A"});
			 	  
		 	   }
		 	   if(Status==$g("谢绝检查")){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#B5A99B"});
			 	  
		 	   }
		 	    if(Status==$g("停止")){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"StatDesc"+"]").css({"background-color":"#EF4E38"});
			 	  
		 	   }
		 	  				
			}  
            }
});


$(function(){
		
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
    
    // 取消延期
    $('#CancelDelayDate').click(function(e){
    	CancelDelayDate_click();
    });
    
    
   
   
})
function InitDataGrid()
{
	
	$HUI.datagrid("#ItemDetailGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect:true,
		//selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.OEOrdItem",
			QueryName:"FindOItemStatusForAdm",
			AdmId:AdmId,
			CSPName:"dhcpeitemdetail.hisui.csp"   
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
			{field:'ARCICOrderType',title:'ARCICOrderType',hidden: true},
			{field:'StatDesc',width:80,title:'状态',align:'center',
			 formatter:function(value,row,index){
				return  '<span style="color:#FBFDFA">'+value+'</span>';
 			}},
			{field:'ItemId',title:'TId',hidden: true},
			{field:'ItemDesc',width:200,title:'名称'},
			{field:'Station',width:60,title:'站点'},
			{field:'IsYQ',width:60,title:'是否延期'},
			{field:'YQDate',width:120,title:'延期日期'},
			{field:'ItemCode',width:100,title:'项目编号'},
			{field:'LabNo',width:120,title:'标本号'},
			{field:'BillStatus',width:80,title:'收费状态'},
			{field:'Diet',width:80,title:'注意事项'},
			{field:'TResultStatus',width:80,title:'检验状态'},
			{field:'AccountAmount',width:100,title:'应收价格',align:'right'},
			{field:'FactAmount',width:100,title:'优惠价格',align:'right'},
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
			{field:'RecLocDesc',width:120,title:'接收科室'},
			{field:'Trans',title:'调试结果',width:80,
			formatter:function(value,row,index){
					
					var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsLisRisStation",row.ItemId,session['LOGON.CTLOCID'])
					if(flag==1){

					return "<a href='#' onclick='TransTest(\""+index+"\")'>\
					<img style='padding-left:20px;' title='' src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' border=0/>\
					</a>";
					}
					
			}},		
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			
				
				$("#Source").val(rowData.LabNo);	
				 var Status=rowData.StatDesc;
				if((Status==$g("取消体检"))||(Status==$g("谢绝检查"))||(Status==$g("执行"))||(rowData.LabNo=="")){
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
			if(DrugStatus!=$g("已发药")) return false;
			if(FeeStatus.indexOf($g("挂帐")) == -1 )
			{
			
			$.messager.alert("提示", "付费药品请去退费申请界面", 'success');
			
			return false;
			}
			
			var FeeStatus=$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TDrugStatus;
			if(FeeStatus.indexOf($g("已发药")) == -1 )
			{
			
			$.messager.alert("提示", "不是已发药医嘱不能申请退药", 'success');
			
			return false;
			}
			
			var eSrc = window.event.srcElement;
			if(eSrc.checked==true)
			{
				var feeid="1"+"^"+$('#ItemDetailGrid').datagrid('getRows')[rowIndex].TPreItemID 
				var drugperm=tkMakeServerCall("web.DHCPE.ItemFeeList","DrugPermControl",feeid,0,"",session['LOGON.CTLOCID'],session['LOGON.USERID'])
				//alert(drugperm+"drugperm")
				if(drugperm!=2)
				{
					//var ret=tkMakeServerCall("web.DHCPE.OEOrdItem","SaveOneNoPrint",$('#ItemDetailGrid').datagrid('getRows')[rowIndex].OEORIRowId,"Y")
					$.messager.alert("提示", "申请成功", 'success');
					$(this).datagrid('reload')
				}
				else{
					setColumnValue(rowIndex,"TChecked",0)
					$.messager.alert("提示", "申请失败,失败代码"+drugperm, 'error');
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
					$.messager.alert("提示", "取消申请失败，失败代码"+ret, 'error');
				
				return false;
				}
			}
			
			
		}
		
		},
		onLoadSuccess: function(rowData){
			
			
			for ( var i = 0; i < rowData.rows.length; i++) {
				//$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true;
			
		    if (rowData.rows[i].TDrugStatus!=$g("已发药")) {
					$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true
						//$(this)[i].TChecked.disabled = true;

					}
			 if (rowData.rows[i].BillStatus.indexOf($g("挂帐")) == -1 ) {
					$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[2].disabled = true
						//$(this)[i].TChecked.disabled = true;

					}
					


	     }
			
			
		}	
			
	})

}

/*
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
	//var cwin=window.open(lnk,"_blank",nwin)	
	websys_lu(lnk,false,'width=870,height=600,hisui=true,title=调试结果')
	
	}
*/
function TransTest(index)
{
	
	var selectrow =$('#ItemDetailGrid').datagrid('getRows')[index];
	var OEORI=selectrow. OEORIRowId ;
	var Status=selectrow.StatDesc;
	var ItemDesc=selectrow.ItemDesc;
	var LabNo=selectrow.LabNo
	
	var lnk="dhcpetransresultdetail.csp"+"?OEID="+OEORI+"&Status="+Status+"&ItemDesc="+ItemDesc+"&LabNo="+LabNo
		;
	//alert(lnk)
	websys_lu(lnk,false,'width=1200,height=600,hisui=true,title='+ItemDesc+$g("--调试结果"))
	
	
	}




// 撤销延期
function CancelDelayDate_click()
{
	
	var UserID=session['LOGON.USERID'];
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//获取的是数组，多行数据
	//alert(selectrow.length+"selectrow.length")
  	if(selectrow.length=="0"){
	  	$.messager.alert("提示","请选择待撤销延期的医嘱！","info");
		return false;
  	}
  	
	for(var i=0;i<selectrow.length;i++){	
	    if(selectrow[i].IsYQ==$g("否")) continue;
		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}

	if(OEORIRowIdStr==""){
		$.messager.alert("提示","没有满足撤销延期的项目！","info");
		return false;
	}
	
	var DelayRet=tkMakeServerCall("web.DHCPE.OrderPostPoned","CancelDelay",OEORIRowIdStr,UserID);
	if(DelayRet<0){
		$.messager.alert("提示","撤销延期项目失败！","info");
		return false;
	}else{
		$.messager.alert("提示","撤销延期项目成功！","info");
		$("#ItemDetailGrid").datagrid('reload'); 
		return false;
		}
	
}


//撤销/谢绝检查 
function Refuse_click(){
	
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//获取的是数组，多行数据
	//alert(selectrow.length+"selectrow.length")

	for(var i=0;i<selectrow.length;i++){

		if(selectrow[i].StatDesc==$g("停止")){
			$.messager.alert("提示","停止的医嘱不能谢绝检查!","info");
			return false;
		}

       if(selectrow[i].TResultStatus==$g("已采")){
			
			$.messager.alert("提示","该医嘱已采集，不能谢绝检查!","info");
			return false;
		
		}

		if(selectrow[i].ARCICOrderType=="R"){
			
			$.messager.alert("提示","药品类医嘱不用谢绝检查!","info");
			return false;
		}
		
	   if(selectrow[i].ARCICOrderType=="M"){
			
			$.messager.alert("提示","材料类医嘱不用谢绝检查!","info");
			return false;
		}

		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}



	if(OEORIRowIdStr==""){
		$.messager.alert("提示","请选择医嘱!","info");
		return false;
	}
	
    var flag=""
	var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetReportStaus",OEORIRowIdStr);
	if((flag==$g("已复检"))||(flag==$g("已发送"))||(flag==$g("已打印")))
	{
		
		$.messager.confirm('确定', $g("报告状态是：")+flag+$g(", 确定要进行该操作吗?"), function(t) {
		if (t) {
				RefuseCommon(OEORIRowIdStr);

		}else{
			return false;
		}
		
	});
		
	}else{
		RefuseCommon(OEORIRowIdStr);
	}
	
}


function RefuseCommon(OEORIRowIdStr)
{
	   
    var UserID=session['LOGON.USERID'];
	var RefuseCodeStr="";
	var Arr=OEORIRowIdStr.split("^");
	var Length=Arr.length;
	for (var i=0;i<Length;i++)
	{ 
		var OEORIRowId=Arr[i];
		var RefuseReason=$("#RefuseReason").val();
    	var OEORIRowId=OEORIRowId+"^"+RefuseReason;
		//alert(OEORIRowId+"OEORIRowId")
		var RefuseCode=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEORIRowId,"",UserID);
	
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
		
		$.messager.alert("提示","已执行项目不能再进行操作!","info");
		
	}else{
		
		$.messager.alert("提示","拒绝失败!","error");
   		
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


///获取选中的医嘱串 
function GetSelectOEORIStr() 
{ 
	var OEORIRowIdStr="";
	var SelectIds=""
	var selectrow = $("#ItemDetailGrid").datagrid("getChecked");//获取的是数组，多行数据
  
	for(var i=0;i<selectrow.length;i++){
		if(selectrow[i].StatDesc==$g("停止")){
			
			$.messager.alert("提示","停止的医嘱不能修改","info");
			return false;
			}
		
	   
		if (OEORIRowIdStr==""){
				OEORIRowIdStr=selectrow[i].OEORIRowId;
			}else{
				OEORIRowIdStr=OEORIRowIdStr+"^"+selectrow[i].OEORIRowId;
			} 
	}
	return OEORIRowIdStr;
	
}


function BUpdateSpec_click()
{
	var OEORIStr=GetSelectOEORIStr()
	
	if(OEORIStr==""){
			$.messager.alert("提示","未选择待更新的医嘱!","info");
		    return false;
		}
	if(OEORIStr.split("^").length>1){
		
		$.messager.alert("提示","只能操作一个医嘱更新标本!","info");
		return false;
	} 
	var OEORIRowID=OEORIStr.split("^")[0];
	var Source=$("#Source").val();
	var To=$("#To").val();
	if (Source=="")
	{
		top.$.messager.alert("提示","原标本号不能为空!","info");
		return false;
	}
	if (To=="")
	{
		top.$.messager.alert("提示","更新标本号不能为空!","info");
		return false;
	}
  if(Source==To){
		$.messager.alert("提示","原标本号和新标本号一样,无需更新!","info");
		return false;
	}
	
	var flag=tkMakeServerCall("web.DHCPE.BarPrint","IsUpdateSpec",AdmId,To,OEORIRowID);
	
  if(flag=="2"){
		$.messager.alert("提示","待修改医嘱的接收科室和新标本的接收科室不一致,请重新输入!","info");
		return false;
		
	}
	if(flag=="3"){
		$.messager.alert("提示","待修改医嘱的样本和新标本的样本不一致,请重新输入!","info");
		return false;
		
	}
	if(flag!="1"){
		$.messager.alert("提示","新标本号不是本次就诊没执行过的标本号,请重新输入!","info");
		return false;
		
   }
	
    var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.BarPrint","UpdateSpec",Source,To,UserID,OEORIRowID); 
	$.messager.alert("提示","更新标本号成功!","success");
	$("#To").val("");
	$("#ItemDetailGrid").datagrid('reload'); 
	}
