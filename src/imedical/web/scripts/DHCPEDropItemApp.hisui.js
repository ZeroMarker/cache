
//名称	DHCPEDropItemApp.hisui.js
//功能  体检退费申请
//创建	2018.10.11
//创建人  xy

$(function(){
	 
	InitCombobox();
	
	initInvList();
	
	initOrdItmList();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏 
    $("#Bclear").click(function() {	
		 Bclear_click();		
        }); 
      
	$HUI.linkbutton('#BReadCard', {
		onClick: function () {
			ReadCardClickHandle();
		}
	});


	//卡号回车查询事件
	$('#CardNo').keydown(function (e) {
		CardNoKeydownHandler(e);
	});
     
	//登记号回车查询事件
	$('#RegNo').keydown(function (e) {
		RegNoKeyDown(e);
	});
	
	//发票回车查询事件
	$('#InvNo').keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
		var invNo=$("#InvNo").val();
		if (invNo=="") return false;
		BFind_click();
		}
	});
	
	//全退申请
	$("#BAllRefundApp").click(function() {	
		 BAllRefundApp_Click();		
    }); 
	
	//打印退费单
	$("#BPrint").click(function() {	
		 BPrint_Click();		
    }); 
    
    //卡类型
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL,
		editable: false,
		multiple: false,
		valueField: 'value',
		textField: 'caption',
		onBeforeLoad: function (param) {
			param.ClassName = 'web.DHCBillOtherLB';
			param.QueryName = 'QCardTypeDefineList';
			param.ResultSetType = 'array';
		},
		
		onLoadSuccess: function () {
			var cardType = $(this).combobox('getValue');
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
	
})



function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardNoKeyDownCallBack);
		
		return false;
	}
}

function CardNoKeyDownCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			event.keyCode=13;
			break;
		default:
	}
}


function InitCombobox()
{
	// 日结标记	
	var RPObj = $HUI.combobox("#RPFlag",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRPFlag&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
		
}

//清屏
function Bclear_click()
{
	$("#RegNo,#PatName,#InvNo,#User,#CardTypeNew,#CardNo").val("");
	$(".hisui-combobox").combobox('select','');
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	BFind_click();
}


// 查询
function BFind_click(){

	$HUI.datagrid("#invList",{
		
		queryParams:{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			User:$("#User").val(),
			RPFlag:$("#RPFlag").combobox('getValue'),
			isApply:"0"
			
		}
	});
	$('#ordItmList').datagrid('loadData', {
				total: 0,
				rows: []
			});
	$("#InvPrtId").val("");
	$("#RefundRmark").val("");
	
}


function loadOrdItmList(row) {
	 RefundAmount=[];
    SelectItems=[];

	$('#ordItmList').datagrid('load', {
		ClassName: 'web.DHCPE.ItemFeeList',
		QueryName: 'FindItemFeeList',
		InvPrtId: row.TRowId
		
	});
	if(row.TRowId!=$('#InvPrtId').val()){$("#RefundRmark").val("");}
	//$('#InvPrtId').val(row.TRowId);
	//inti();
}

function RegNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var RegNo=$("#RegNo").val();	
 		if(RegNo!="") {
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#RegNo").val(RegNo)
		}

		if (RegNo=="") return false;
		
			BFind_click();
		
	}
}

function initInvList() {
	$HUI.datagrid('#invList', {
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		rownumbers : true, 
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			User:$("#User").val(),
			RPFlag:$("#RPFlag").combobox('getValue'),
			isApply:"0"
			
		},
		columns: [[{
					title: '发票号',
					field: 'TInvNo',
					width: 120
				}, {
					title: '登记号',
					field: 'TRegNo',
					width: 120
				}, {
					title: '姓名',
					field: 'TPatName',
					width: 100
				}, {
					title: '金额',
					field: 'TAmount',
					align: 'right',
					width: 100
				}, {
					title: '收费员',
					field: 'TUser',
					width: 100
				}, {
					title: '收费日期',
					field: 'TInvDate',
					width: 180
				},{
					title: '日结标记',
					field: 'TRPFlag',
					width: 30
				}, {
					title: 'TRowId',
					field: 'TRowId',
					hidden: true
				}
			]],
		onSelect: function (rowIndex, rowData) {
			$('#InvPrtId').val(rowData.TRowId);
			$('#ordItmList').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadOrdItmList(rowData);
		}
	});
}


function initOrdItmList() {
	$HUI.datagrid('#ordItmList', {	
		fit: true,
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect:false,
		autoRowHeight: false,
		showFooter: true,
		url: $URL,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 20,
		pageList: [20, 30, 40, 50],
	    queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
				
		},
		columns: [[{
					title: '选择',
					field: 'Select',
					width: 70,
					checkbox:true,
					/*formatter:function(value,rowData,index){
						return "<input type='checkbox' onclick=\"GetSelectIds('" + value + "', '" + index + "')\"/>"; 
					}
					
                  */
				
				}, {
					title: '医嘱名称',
					field: 'ItemName',
					width: 120
				}, {
					title: '医嘱状态',
					field: 'OrdStatusDesc',
					width: 100
				}, {
					title: '销售金额',
					field: 'FactAmount',
					align: 'right',
					width: 100
				}, {
					title: '优惠形式',
					field: 'PrivilegeMode',
					width: 100
				}, {
					title: '优惠内容',
					field: 'Privilege',
					hidden: true
					//width: 100
				}, {
					title: 'RowId',
					field: 'RowId',
					hidden: true
				},{
					title: 'FeeType',
					field: 'FeeType',
					hidden: true
				},{
					title: '姓名',
					field: 'PatName',
					width: 100
				},
				{
					title: '登记号',
					field: 'PatRegNo',
					width: 100
				}

			]],
			
	
	//取消选中行函数	
	onUncheck:function(rowIndex,rowData){
				//GetSelectIds();
				RemoveSelectItem(rowIndex,rowData);
			},
			
	//选中行函数
	onCheck:function(rowIndex,rowData){
	//if ((rowData.OrdStatusDesc == "执行")||(rowData.OrdStatusDesc == "已发药")) {
	if ((rowData.OrdStatusDesc == "执行")) {
		            //设置datagrid中某行不能被选中
					$('#ordItmList').datagrid('unselectRow', rowIndex);
				}
				//GetSelectIds();
				AddSelectItem(rowIndex,rowData); 
			},		
			
	onLoadSuccess: function (rowData) { 
	  $('#ordItmList').datagrid('unselectAll');
	   //$('#ordItmList').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选中
	   $("#ordItmList").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
		
		var invPrtId=$("#InvPrtId").val();
		//alert(invPrtId)
		if (invPrtId==""){
		//alert("没有退费申请发票");
		return false;
		}
		var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",invPrtId);
		//alert(info)
		for ( var i = 0; i < rowData.rows.length; i++) {
			// if(info.indexOf(objtbl[index].RowId)>=0)
		    if (info.indexOf(rowData.rows[i].RowId)>=0) {
					//$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].checked = true
						//$(this)[i].TChecked.disabled = true;

					}
			 



	     }
		
		
		
	  /*
	   //第一种：设置datagrid里面checkbox变灰
	   for ( var i = 0; i < rowData.rows.length; i++) {
		   if ((rowData.rows[i].OrdStatusDesc=="执行")||(rowData.rows[i].OrdStatusDesc=="已发药")) {

						$("input[type='checkbox']")[i + 1].disabled = true;

					}



	   }
	   */
	   	
        var invPrtId=$("#InvPrtId").val();
		if (invPrtId==""){
			return false;
		} 
		$("#BackAmount").val(0);
	
        var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",invPrtId);
       
	    var objtbl = $("#ordItmList").datagrid('getRows');
	              
		if (rowData) { 
		   
		  //遍历datagrid的行            
		 $.each(rowData.rows, function (index) {
			    
			 	//if((objtbl[index].OrdStatusDesc=="执行")||(objtbl[index].OrdStatusDesc=="已发药")){	
			 	// 改为 已发药医嘱颓废申请自动产生退药申请
			 	if((objtbl[index].OrdStatusDesc=="执行")){	
			 		//第二种：设置datagrid里面checkbox变灰	 
			  		$(".datagrid-row[datagrid-row-index="+index+"] input[type='checkbox']").attr('disabled','disabled');
				 } else{ 
			 			if(info.indexOf(objtbl[index].RowId)>=0){
				 			//加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 			$('#ordItmList').datagrid('checkRow',index);
				 		}
			 	}
		 });
		 
		 
		 }
		}
		            
	});
	
	
}



var backAmount=0;
var RefundAmount=[];
var SelectItems=[];

function FindSelectItem(ID) { 
 //alert("SelectItems.length:"+SelectItems.length)
      for (var i = 0; i < SelectItems.length; i++) { 
            if (SelectItems[i] == ID) return i; 
         } 
       return -1; 
  } 

function AddSelectItem(rowIndex,rowData)
{
	
	 var invPrtId=$("#InvPrtId").val();
	 var SelectIds=","
	  backAmount=0

     if (FindSelectItem(rowData.FeeType+"^"+rowData.RowId) == -1) { 
         	SelectItems.push(rowData.FeeType+"^"+rowData.RowId); 
         	RefundAmount.push(rowData.FactAmount);
         

         }
                
      for (var i = 0; i < SelectItems.length; i++) { 
               var SelectIds=SelectIds+SelectItems[i]+","    
       }
                  
      for (var j = 0; j< RefundAmount.length; j++) { 
       		 backAmount = parseFloat(backAmount) + parseFloat(RefundAmount[j]); 
       }
       
      backAmount= parseFloat(backAmount).toFixed(2);
       $("#BackAmount").val(backAmount); 
    var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount)
	  
}

function RemoveSelectItem(rowIndex, rowData) { 
	var invPrtId=$("#InvPrtId").val();
	 backAmount=0
    var SelectIds=","
    var k = FindSelectItem(rowData.FeeType+"^"+rowData.RowId); 
    if (k != -1) { 
             SelectItems.splice(k,1); 
             RefundAmount.splice(k,1);
      } 
      
     
    for (var i = 0; i < SelectItems.length; i++) { 
             var SelectIds=SelectIds+SelectItems[i]+","    
      }
      
     for (var j = 0; j< RefundAmount.length; j++) { 
       		 backAmount = parseFloat(backAmount) + parseFloat(RefundAmount[j]); 
       }
       
      backAmount= parseFloat(backAmount).toFixed(2); 
     $("#BackAmount").val(backAmount);
     var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount)
	
                        
  } 
 

//实时计算退费金额并将退费申请信息写到global:^DHCPEDataEx("DHCPERefundApply","SelectIds",invPrtId)
function GetSelectIds()
{
	
	var backAmount=0;
	
	var invPrtId=$("#InvPrtId").val();
	//alert(invPrtId)
	if (invPrtId==""){
		alert("没有退费申请发票");
		return false;
	}
 	
   $("#BackAmount").val(backAmount);
	var SelectIds=""
	var selectrow = $("#ordItmList").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){

		 backAmount=backAmount+Number(selectrow[i].FactAmount);
	     $("#BackAmount").val(backAmount);
	   
		if (SelectIds==""){
				SelectIds=","+selectrow[i].FeeType+"^"+selectrow[i].RowId+",";
			}else{
				SelectIds=SelectIds+","+selectrow[i].FeeType+"^"+selectrow[i].RowId+",";
			} 
	}

	//退费申请的记录写到global中
	//alert(invPrtId+","+SelectIds+","+backAmount)
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,SelectIds,"temp",backAmount)
	//alert(flag+"flag")
	if(flag==1)
	{
	//$.messager.alert("提示", "申请成功", 'success');
	//$(this).datagrid('reload')
	}
	else if(flag==-1)
	{
		$.messager.alert("提示", "申请失败,退药申请失败", 'success');
		$(this).datagrid('reload')
		}
	//alert(SelectIds)
}

//全退申请
function BAllRefundApp_Click()
{
	
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("提示","没有退费申请发票","info");
		return false;
	}
	//退费申请的记录写到global中
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetApplyRefund",invPrtId,"AllRefund")
	if(flag==1){
		$.messager.alert("提示","全退申请成功!","success");
	}else{
		$.messager.alert("提示","全退申请失败!","error");
		
	}
}

//打印退费单lodop打印
function BPrint_Click() 
{
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		$.messager.alert("提示","没有退费申请发票","info");
		return false;
	}
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId);
	
	if (info==""){
		$.messager.alert("提示","还没有做退费申请，请选择退费项目或者点击全退申请","info");
		return false;
	}
	var RefundRmark=$("#RefundRmark").val();
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","SetRefundRemark",invPrtId,RefundRmark);
	var PrinterName="" //打印机名称
	TFDCreatePrintPage(PrinterName,invPrtId);
}

function TFDCreatePrintPage(PrinterName,invPrtId)
{
	LODOP=getLodop(); 
	LODOP.PRINT_INIT(invPrtId+"的退费申请单"); //打印任务的名称
	if (PrinterName!=""){ //指定打印机名称
		LODOP.SET_PRINTER_INDEX(PrinterName);
	}
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetTFDPrintInfo",invPrtId,"Header");
	//alert(PrintURL)
	//增加打印基本信息，做为页眉打印，每页都有
	LODOP.ADD_PRINT_URL("12mm","12mm","RightMargin:6mm","80mm",PrintURL); //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT","Full-Page");
	
		//增加打印项目信息
	var PrintURL=tkMakeServerCall("web.DHCPE.GetLodopPrintPath","GetTFDPrintInfo",invPrtId,"Body");
	LODOP.ADD_PRINT_URL("60mm","12mm","RightMargin:6mm","BottomMargin:20mm",PrintURL); //Top,Left,Width,Height,strURL
	LODOP.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);
	
	LODOP.PRINT();
}


/*
//打印退费单
function BPrint_Click()
{
	
	var idTmr="";
	var invPrtId=$("#InvPrtId").val();
	if (invPrtId==""){
		alert("没有退费申请发票");
		return false;
	}
	
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId);
	if (info==""){
		alert("还没有做退费申请，请选择退费项目或者点击全退申请");
		return false;
	}
	
	var char_1=String.fromCharCode(1);
	var char_2=String.fromCharCode(2);
	var infoArr=info.split(char_1);
	var patientInfo=infoArr[0];
	var patientArr=patientInfo.split("^");
	var orditemInfo=infoArr[1];
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEDropItemRequest.xls';

	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	
	xlsheet.cells(1,1).Value=HosName;

	xlsheet.cells(4,2).Value=patientArr[0];
	xlsheet.cells(4,5).Value=patientArr[1];
	xlsheet.cells(5,2).Value=patientArr[2];
	xlsheet.cells(6,2).Value=patientArr[3];
	xlsheet.cells(6,6).Value=patientArr[4];
	var orditemArr=orditemInfo.split(char_2);
	var row=9;
	var i=orditemArr.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++){
		var oneOrdItem=orditemArr[iLLoop];
		var oneOrdArr=oneOrdItem.split("^");
		xlsheet.cells(row+iLLoop,1).Value=oneOrdArr[0];
		xlsheet.cells(row+iLLoop,5).Value=oneOrdArr[1];
	}
	
	
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
	idTmr   =   window.setInterval("Cleanup();",1); 
	
	
}
*/

function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}