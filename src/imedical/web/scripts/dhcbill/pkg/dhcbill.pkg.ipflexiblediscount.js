/*
 * FileName:	dhcbill.pkg.ipcoupontemplate.js
 * User:		tianzj,DingSH
 * Date:		2019-11-13
 * Function:	
 * Description: 灵活折扣
 */
 
 var GV={
	ADM:'',
	BILL:'',
	PAPMI:'',
	PACKAGEID:'',
	editRowIndex:-1,
	FixFlag:'' ,//是否进行过灵活折扣 1 : 已经进行过灵活折扣
	deleteStr:'', // 删除的灵活折扣串
	OrdExItms:{}  ,//医嘱执行记录、
	DisOrdList:{},
	EditIndex: undefined,
	curRowIndex:-1,
    curRow:{},
    curVal:0.0,
    ed:{},
    CHANGE:"",
   GUser:session['LOGON.USERID'],
}
 
 
 $(function () {
	 
	//获取Rq参数
	initRqParam();
	
	//回车事件	 
    initKeyDown();
    
	//加载就诊记录
	initAdmList();
	
	//加载datagrid
	initDg();  
	
	//加载医嘱数据
	initPatOrdGrid();
	initPatShareGrid();
	$('#ArcItm').keydown(function (e) {
		var key = websys_getKey(e);
			if (key == 13) {
				initPatOrdGrid();
			}
	})
});



function initKeyDown()
{
	
	//登记号回车事件 
	$('#RegNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		patientNoKeydown(event);
  		}
	})
	//住院号回车事件
	$('#MedicalNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		medicalNoKeydown(event);
  		}
	})
	//已选自付回车事件
	$("#PatShareAmt").keydown(
	 function(e){
		 if (e.keyCode==13)
		 {
			  var tpAmt=$(this).val();
				if (tpAmt!="")
				{
				   calcAvgOrdDisRowsByPatShareAmt();
				}else{
					$.messager.alert('提示', '售价金额值非法。', 'error', function() {
						focusById("#PatShareAmt");
					});
				}
			}
		 
		 });
		 
	//折扣率回车事件	 
	$("#PatDisRate").keydown(
	 function(e){
		 if (e.keyCode==13)
		 {
			  var tpAmt=$(this).val();
				if (tpAmt!="")
				{
				   calcAvgOrdDisRowsByPatDisRate();
				}else{
					$.messager.alert('提示', '折扣率值非法。', 'error', function() {
						focusById("#PatShareAmt");
					});
				}
			}
		 
		 });
		 
		 
	   // 保存打折
       $HUI.linkbutton("#btnDisRate", {
            onClick: function () {
               IPOrdDisInfoSave();
            }
        });
        // 取消打折
        $HUI.linkbutton("#btnDisRateC", {
            onClick: function () {
               DleteFlexDisClick();
            }
        }); 
		 
	
}



/*
*获取Request传入参数
*/
function initRqParam() {
      GV.ADM = getParam('AdmDr');
      var patNo   = getParam('patNo');
      setValueById("RegNo",patNo)
       getPatInfo();
}



//获取已经医嘱打折项目信息
//output 总金额^自付金额^优惠金额
function  GetDisOrdedInfo()
{
	
	var PatToAmt=0 
	var PatShareAmt=0 
	var PatDisAmt=0
	

	//console.log(GV.ProdList)
	if (!(JSON.stringify(GV.DisOrdList) == "{}"))
	{
	$.each(GV.DisOrdList.getRows(), function (index, row) {
	    	var RowPatToAmt=0.0
			var RowPatShareAmt=0.0
		    var RowPatDisAmt=0.0
			if(row.FixFlag =="1")
			  {
				
				 RowPatToAmt=toNumber(row.billTotalAmt)	
				 RowPatShareAmt=toNumber(row.billPashareAmt);
			     RowPatDisAmt=toNumber(row.PatDisAmt);
			  }
			PatToAmt=toNumber(PatToAmt)+ RowPatToAmt;
		    PatShareAmt=toNumber(PatShareAmt)+ RowPatShareAmt
		    PatDisAmt=toNumber(PatDisAmt)+ RowPatDisAmt
		    
		});
	  }
	  return PatToAmt+"^"+PatShareAmt+"^"+PatDisAmt
	
}



/*
*根据指定已选自付金额计算每条医嘱的折扣率和优惠
*/
function calcAvgOrdDisRowsByPatShareAmt() {

    var rate = 0.00;
    var PatToAmt = 0.00;
    var PatShareAmt = 0.00;
    var SalesAmtH = 0.00
    var Mistake = 0.00;
    PatToAmt = toNumber(getValueById('PatToAmt'));
     if(PatToAmt==0)
     {
	     
	     $.messager.alert('提示', '已选金额不能等于0', 'info')
	     return ;
	     
	 }
	 
	 //获取已打折医嘱项目信息
	 var DisOrdedInfo= GetDisOrdedInfo()
	 var DisOrdedAry=DisOrdedInfo.split("^")
	 var DisedPatToAmt=toNumber(DisOrdedAry[0])
	 var DisedPatShareAmt=toNumber(DisOrdedAry[1])
	 var DisedPatDisAmt=DisOrdedAry[2]
	 
	 
	 
     //tProSalesAmt = toNumber(getValueById('ProSalesAmt'));
     PatShareAmt = toNumber($('#PatShareAmt').val());
     //alert("DisedPatShareAmt="+DisedPatShareAmt)
     if(PatShareAmt<toNumber(DisedPatShareAmt.toFixed(2)))
     {
	     
	     $.messager.alert('提示', '填写自付金额不能小于已打折自付金额：'+DisedPatShareAmt.toFixed(2), 'info',function(){
		     
		         setValueById('PatShareAmt', DisedPatShareAmt.toFixed(2))
		         //focusById("PatShareAmt");
		      
		     })
	     
	   
	     return ;
	     
	  }
     
    if (PatToAmt < PatShareAmt) {
        $.messager.alert('提示', '填写已选自付金额不能大于已选金额', 'info',function(){
	        
	         focusById("PatShareAmt");
	         setValueById('PatShareAmt', PatToAmt)
	         setValueById('PatDisAmt', 0)
	        });
       
        PatShareAmt=PatToAmt
    }
    
  
   
    //平均折扣率
    if (toNumber(PatToAmt-DisedPatToAmt)<0.00001){rate=0}
    else
    {
      rate = (PatShareAmt-DisedPatToAmt)/ (PatToAmt-DisedPatToAmt);
    }
    
    var MistakeAry=new Array(GV.DisOrdList.getRows().length);
    MistakeIndex=-1 ;
    $.each(GV.DisOrdList.getRows(),function(index,row){
 	      
 	        var RowTotalAmt = toNumber(row.billTotalAmt)
 	        var RowPatShareAmt=0
 	        var RowPatDisAmt=0
 	        if(row.FixFlag==1)
 	        {
	 	         RowPatShareAmt =toNumber(row.billPashareAmt).toFixed(2)
                 RowPatDisAmt= toNumber(row.PatDisAmt).toFixed(2)
                 
	 	    }
	 	    else
	 	    {
		 	     RowPatShareAmt =toNumber((RowTotalAmt *  rate  ).toFixed(2))
                 RowPatDisAmt= toNumber((RowTotalAmt -RowPatShareAmt).toFixed(2))
		 	    
		 	    
		 	}
 	        
            SalesAmtH = SalesAmtH + toNumber(RowPatShareAmt);
            
            MistakeAry[index]=PatShareAmt-toNumber(toNumber(SalesAmtH).toFixed(2))
	             
            if ((index == (GV.DisOrdList.getRows().length - 1))&&(rate!=0)) {
	            //alert("tProSalesAmt="+tProSalesAmt+"  SalesAmtH="+toNumber(toNumber(SalesAmtH).toFixed(2)))
               Mistake = PatShareAmt - toNumber(toNumber(SalesAmtH).toFixed(2))
                //alert("Mistake="+Mistake)
                if (Mistake != 0) {
                    RowPatShareAmt = toNumber(RowPatShareAmt) + Mistake
                    RowPatDisAmt= toNumber((RowTotalAmt -RowPatShareAmt).toFixed(2))
   
                }
            }
            
           
            if(row.FixFlag==0)
            {
	          HISUIDataGrid.setFieldValue('billPashareAmt', toNumber(RowPatShareAmt).toFixed(2), index, 'dgPatShareOrd');
              HISUIDataGrid.setFieldValue('DisRate', toNumber(rate).toFixed(4), index, 'dgPatShareOrd');
              HISUIDataGrid.setFieldValue('PatDisAmt', RowPatDisAmt, index, 'dgPatShareOrd');
            }
	        
	 
	   
	   });
	    for (var i=0;i<MistakeAry.length;i++)
	               {
		               var row= GV.DisOrdList.getRows()[i]
		               //alert("MistakeAry["+i+"]="+MistakeAry[i])
		               if ((toNumber(MistakeAry[i])<0))
		               {
			                HISUIDataGrid.setFieldValue('billPashareAmt', (0).toFixed(2), i, 'dgPatShareOrd');
                            HISUIDataGrid.setFieldValue('DisRate', (0).toFixed(4), i, 'dgPatShareOrd');
			                HISUIDataGrid.setFieldValue('PatDisAmt', (0).toFixed(2), i, 'dgPatShareOrd');
			               
			           }
		               
		           }	           
	  setValueById("PatDisRate",(rate).toFixed(4))
      setValueById("PatDisAmt",(PatToAmt-PatShareAmt).toFixed(2))
}

/*
*根据指定折扣率计算每条医嘱的自付金额和优惠
*/
function calcAvgOrdDisRowsByPatDisRate() 
{

    var rate = 0.00;
    var PatToAmt = 0.00;
    var PatShareAmt = 0.00;
    var SalesAmtH = 0.00
    var Mistake = 0.00;
    
     PatToAmt = toNumber(getValueById('PatToAmt'));
    
     if(PatToAmt==0)
     {
	     
	     $.messager.alert('提示', '已选金额不能等于0', 'info')
	     return ;
	     
	 }
     //tProSalesAmt = toNumber(getValueById('ProSalesAmt'));
      rate = toNumber($('#PatDisRate').val());
    if (1 < rate) {
        $.messager.alert('提示', '填写折扣率不能大于1', 'info',function(){
	         focusById("PatDisRate");
	         setValueById('PatDisRate', 1)
	         rate=1
	        });
       
        PatShareAmt=PatToAmt
       return ;
    }
    
     //获取已打折医嘱项目信息
	 var DisOrdedInfo= GetDisOrdedInfo()
	 var DisOrdedAry=DisOrdedInfo.split("^")
	 var DisedPatToAmt=toNumber(DisOrdedAry[0])
	 var DisedPatShareAmt=toNumber(DisOrdedAry[1])
	 var DisedPatDisAmt=DisOrdedAry[2]
    PatShareAmt= (PatToAmt-DisedPatToAmt) * rate+DisedPatShareAmt
    PatShareAmt=toNumber(PatShareAmt.toFixed(2))
    var MistakeAry=new Array(GV.DisOrdList.getRows().length);
    MistakeIndex=-1 ;
    $.each(GV.DisOrdList.getRows(),function(index,row){
 	      
	       var RowTotalAmt = toNumber(row.billTotalAmt)
           var RowPatShareAmt=0
 	        var RowPatDisAmt=0
 	        if(row.FixFlag==1)
 	        {
	 	         RowPatShareAmt =toNumber(row.billPashareAmt).toFixed(2)
                 RowPatDisAmt= toNumber(row.PatDisAmt).toFixed(2)
                 
	 	    }
	 	    else
	 	    {
		 	    
		 	     RowPatShareAmt =toNumber((RowTotalAmt *  rate  ).toFixed(2))
                 RowPatDisAmt= toNumber((RowTotalAmt -RowPatShareAmt).toFixed(2))
		 	    
		    }
 
            SalesAmtH = SalesAmtH + toNumber(RowPatShareAmt);
            
            MistakeAry[index]=PatShareAmt-toNumber(toNumber(SalesAmtH).toFixed(2))
	             
            if ((index == (GV.DisOrdList.getRows().length - 1))&&(rate!=0)) {
	            //alert("tProSalesAmt="+tProSalesAmt+"  SalesAmtH="+toNumber(toNumber(SalesAmtH).toFixed(2)))
               Mistake = PatShareAmt - toNumber(toNumber(SalesAmtH).toFixed(2))
                //alert("Mistake="+Mistake)
                if (Mistake != 0) {
                    RowPatShareAmt = toNumber(RowPatShareAmt) + Mistake
                    RowPatDisAmt= toNumber((RowTotalAmt -RowPatShareAmt).toFixed(2))
   
                }
            }
            if (row.FixFlag==0)
            {
              HISUIDataGrid.setFieldValue('billPashareAmt', toNumber(RowPatShareAmt).toFixed(2), index, 'dgPatShareOrd');
              HISUIDataGrid.setFieldValue('DisRate', toNumber(rate).toFixed(4), index, 'dgPatShareOrd');
	          HISUIDataGrid.setFieldValue('PatDisAmt', RowPatDisAmt, index, 'dgPatShareOrd');
            }
	 
	   
	   });
	   
	   
	   
	    for (var i=0;i<MistakeAry.length;i++)
	               {
		               var row= GV.DisOrdList.getRows()[i]
		               //alert("MistakeAry["+i+"]="+MistakeAry[i])
		               if ((toNumber(MistakeAry[i])<0))
		               {
			                HISUIDataGrid.setFieldValue('billPashareAmt', (0).toFixed(2), i, 'dgPatShareOrd');
                            HISUIDataGrid.setFieldValue('DisRate', (0).toFixed(4), i, 'dgPatShareOrd');
			                HISUIDataGrid.setFieldValue('PatDisAmt', (0).toFixed(2), i, 'dgPatShareOrd');
			           }
		               
		           }
	  setValueById("PatShareAmt",(PatShareAmt).toFixed(2))
      setValueById("PatDisAmt",(PatToAmt-PatShareAmt).toFixed(2))
}





/**
* 就诊下拉数据表格
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
		striped: true,
		fitColumns: false,
		editable: false,
		idField: "TadmId",
		textField: "TadmLoc",
		columns: [[
				   {field: 'TadmDate',	title: '就诊时间', width: 150},
				   {field: 'TadmLoc', title: '就诊科室', width: 90},
				   {field: 'TadmWard', title: '就诊病区', width: 130},
				   {field: 'TdisDate', title: '出院时间', width: 150},
				   {field: "TadmId", title: "TadmId", width: 150}
			]],
		onLoadSuccess:function(data) {
			var admGrid=$('#admList').combogrid('grid');
			if(admGrid.datagrid('getRows').length>0){
				admGrid.datagrid('selectRow',0)	
			}
	    },
		onSelect: function (rowIndex, rowData) {
			GV.ADM=rowData.TadmId;
			//initLoadGrid();
			//getAdmInfo();// 加载表单头 就诊信息
			//CheckPackage();
			initPatOrdGrid();
			initPatShareGrid();
			
			
		}
	});
}
/**
* 加载就诊列表
*/
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "searchAdm",
		papmi: GV.PAPMI
	}
	loadComboGridStore("admList", queryParams);
}
/*
 * 登记号回车
 */
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = $(e.target).val();
		if (!patientNo) {
			return;
		}
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: patientNo,
			HOSPID: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (rtn) {
			//clear_Click();
			$(e.target).val(rtn);
			getPatInfo();
		});
	}
}
/*
 * 住院号回车
 */
function medicalNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var medicalNo = $(e.target).val();
		if (!medicalNo) {
			return;
		}
		getPatInfo();
		
	}
}



/*
 * 获取患者基本信息
 */
function getPatInfo() {
	var patientNo = getValueById('RegNo');
	var medicalNo = getValueById('MedicalNo');
	$.m({
		ClassName: 'BILL.PKG.COM.PatInfo',
		MethodName: 'GetPatInfo',
		patNO: patientNo,
		Medical: medicalNo,
	}, function (rtn) {
		var myAry = rtn.split('^');
		if (!myAry[0]) {
			GV.PAPMI='';
			$.messager.alert('提示', '登记号错误', 'error');
		} else {
		   GV.PAPMI=myAry[0];
		   setValueById("RegNo",myAry[1])
		   setValueById("MedicalNo",myAry[2])
		   setValueById("PatName",myAry[3])
		  loadAdmList();
		}
	});
}
/*
 * 获取患者就诊信息
 */
function getAdmInfo() {
	try
	{
		$.m({
			ClassName: 'BILL.PKG.BL.PackageConfirmation',
			MethodName: 'GetPatInfo',
			AdmDr: GV.ADM
		}, function (rtn) {
			var myAry = rtn.split('^');
			if (myAry[0]=='101') {
				$.messager.alert('提示', '获取就诊信息失败'+rtn, 'error');
			} else {
				setValueById('Deposit',parseFloat(myAry[5]).toFixed(2));
				setValueById('OutPackageAmt',parseFloat(myAry[8]).toFixed(2));
				setValueById('InPackageAmt',parseFloat(myAry[7]).toFixed(2));
				setValueById('PackageAmt',parseFloat(myAry[9]).toFixed(2));
			}
		});
	}
	catch (e)
	{
		$.messager.alert('异常发生在dhcbill.pkg.ipconfirmation.js：getAdmInfo', e,'error');
	}
}



/*
 * 初始化datagrid
 */
function initDg() {
	
	//ind,arcimDesc,itmCatDesc,recDeptName,userDeptName,billed,billTotalAmt,billPashareAmt,FixFlag
	var dgColumns = [[
	        {field:'oeori',title:'医嘱Id',width:100,hidden:true},
			{field:'FixFlag',title:'折扣标志',width:100,hidden:true},
			{field:'arcimDesc',title:'医嘱名称',width:200},
			{field:'billTotalAmt',title:'医嘱金额',width:100},
			{field:'DisRate',title:'折扣率',width:150,hidden:true},
			{field:'billPashareAmt',title:'医嘱自付金额',width:100 ,align:'right'},
			{field:'PatDisAmt',title:'优惠金额',width:150,hidden:true},
			{field:'itmCatDesc',title:'医嘱大类',width:80,align:'right'},
			{field:'recDeptName',title:'接受科室',width:80},
			{field:'userDeptName',title:'开单科室',width:80},
			{field:'billed',title:'计费状态',width:100,align:'right'},
		    {field:'FixRowId',title:'FixRowId',width:150,hidden:true},
			
		]];
	$HUI.datagrid('#dgPatOrd',
	{
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect:true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		rowStyler:function(idnex,rowData){
		
		},
		columns: dgColumns,
		onDblClickRow: function (rowIndex, rowData) {
            MoveLeftClick(rowIndex)
        }
		
	});
	
	var dgShareColumns = [[
	        {field:'oeori',title:'医嘱Id',width:100,hidden:true},
			{field:'FixFlag',title:'折扣标志',width:100,
				formatter:function(value,data,row){
					return value=='1'?'已折扣':'未折扣';
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'arcimDesc',title:'医嘱名称',width:200},
			{field:'billTotalAmt',title:'医嘱金额',width:100},
			{field:'DisRate',title:'折扣率',width:100,
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						max:1,
						min:0		
					}

			}},
			{field:'billPashareAmt',title:'医嘱自付金额',width:100 ,align:'right',
			editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}
			},
			
			{field:'PatDisAmt',title:'优惠金额',width:100 ,align:'right'},
			{field:'itmCatDesc',title:'医嘱大类',width:80,align:'right'},
			{field:'recDeptName',title:'接受科室',width:80},
			{field:'userDeptName',title:'开单科室',width:100},
			{field:'billed',title:'计费状态',width:80,align:'right'},
			{field:'FixRowId',title:'FixRowId',width:150,hidden:true},
			{field:'FixSubRowId',title:'FixSubRowId',width:150,hidden:true},
		]];
	GV.DisOrdList=$HUI.datagrid('#dgPatShareOrd',{
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect:true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		rowStyler:function(idnex,rowData){
		
		},
		columns: dgShareColumns,
		onLoadSuccess: function (data) {
			//clearGlobal(); // 设置前先清空
			//LoadSuccessHandle(data);
			//if(GV.FixFlag=='1'){
			//	disableElement(); //已经进行折扣	
			//}
			CalcPatDisOrdAmt();
		},
		onSelect:function(index,rowData){
			if(GV.FixFlag=='1'){
				return;	
			}
			//datagridEditRow(index);
			//datagridAmtEnter();
			//datagridRateEnter();
		}
		,
		onDblClickRow: function (rowIndex, rowData) {
            MoveRightClick(rowIndex)
        }
		,
		 onBeginEdit: function (index, row) {
			   PatOrdDisBeginEdit(index, row);
    	},
		onAfterEdit:function(rowIndex, rowData, changes){
			PatOrdDisAfterEdit(rowIndex, rowData, changes);
			
		},
		onCheck:function(index,rowData){
		},
		onUncheck:function(index,rowData){
			clearDatagridDiscrate(index,rowData);
		}
		,
	    onClickCell: function (index, field, value) {
			   PatOrdDisEditCell(index, field, value);
		}
	});
	
}

/**
* 医嘱记录单元格编辑
*/
function PatOrdDisEditCell(index, field, value) {
	GV.DisOrdList.selectRow(index);   //选中设定行
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.DisOrdList.editCell({
			index: index,
			field: field
		});
		var ed = GV.DisOrdList.getEditor({
				index: index,
				field: field
			});
		if (ed) {
			$(ed.target).focus().select();
		}
		GV.EditIndex = index;
	}
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.DisOrdList.validateRow(GV.EditIndex)) {
		GV.DisOrdList.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}


/**
* 单元格是否可编辑
* true: 可编辑, false: 不可编辑 ,,
*/
function isCellAllowedEdit(index, field, value) {
	var row = GV.DisOrdList.getRows()[index];
	if ((field != "DisRate") && (field != "billPashareAmt")) {
	
			return false;
		
	}
	if((row.FixFlag==1)){
		return false
		}
	/*if(row.ProductFlag=='1'||row.ordCateType=='R')	{
		
			return false
		}*/
	return true;
}

/**
*开始编辑
*/
function PatOrdDisBeginEdit(index, row)
 {
     RowDisRateEnter(index, row);
     RowPatSalesAmtEnter(index, row);
     
}

/**
* 结束编辑
*/
function PatOrdDisAfterEdit(index, rowData, changes) {
	GV.DisOrdList.endEdit(index);
	GV.EditIndex = undefined;
	CalcPatDisOrdAmt()
}

/**
*单元格-根据折扣率计算实收金额
*/
function RowDisRateEnter(index, row)
{
	var ed = GV.DisOrdList.getEditor({index: index, field: "DisRate"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		GV.CHANGE =="DISRATE"
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowDisRateEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowDisRateEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowDisRateEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var PatToAmt=toNumber(row.billTotalAmt)
	 if (newVal=="") return ;
	 if (toNumber(newVal) > 1)
             {
               $.messager.alert('提示', '填写折扣率不能大于 1', 'error',function() {
	           $(ed.target).numberbox("setValue", 1);
				GV.DisOrdList.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	              var PashareAmt =  PatToAmt  * toNumber(newVal)
		        	if (PatToAmt<PashareAmt)
		       		 {
			        
			          	 $.messager.alert('提示', '自付金额不能大于医嘱金额：'+PashareAmt, 'error',function() {
			              $(ed.target).numberbox("setValue", 1);
			              GV.DisOrdList.endEdit(index);
				          GV.EditIndex = undefined;
				          //calcRowOrdExAmt(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('billPashareAmt', PashareAmt.toFixed(2), index, 'dgPatShareOrd');
				         GV.DisOrdList.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				     }
	             }
	             
	             
	
}






/**
*单元格-根据实收金额计算折扣率
*/
function RowPatSalesAmtEnter(index, row)
{
	var ed = GV.DisOrdList.getEditor({index: index, field: "billPashareAmt"});
	if (ed) {
		GV.CHANGE =="DISAMT"
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowPatSalesAmtEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowPatSalesAmtEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowPatSalesAmtEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var PatToAmt=toNumber(row.billTotalAmt) //billPashareAmt
	if (newVal=="") return ;
	 if (toNumber(newVal) > PatToAmt)
             {
               $.messager.alert('提示', '填写自付金额不能大于医嘱金额', 'error',function() {
	           $(ed.target).numberbox("setValue", PatToAmt);
				GV.DisOrdList.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	                   if (PatToAmt!=0)
	                   {
	                     var DisRate = toNumber(newVal) / PatToAmt 
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('DisRate', DisRate.toFixed(4), index, 'dgPatShareOrd');
				         GV.DisOrdList.endEdit(index);
				         GV.EditIndex = undefined;
	                   }else
	                   {
		                 var DisRate = 0
				         $(ed.target).numberbox("setValue", 0);
				         HISUIDataGrid.setFieldValue('DisRate', DisRate.toFixed(4), index, 'dgPatShareOrd');
				         GV.DisOrdList.endEdit(index);
				         GV.EditIndex = undefined;
		                   
		                }
				         //calcRowOrdExAmt(index)
				         
				    
	             }
	
}


/*
 * 患者医嘱grid
 */
function initPatOrdGrid(){
	///alert("GV.ADM="+GV.ADM+";;;;;;;;;"+getValueById('ArcItm'))
	var queryParams={
			ClassName:'BILL.PKG.BL.PackageConfirmation',
			QueryName:'FindProOrd',
			episodeId:GV.ADM,
			itmCateId:'',
			KeyCode:getValueById('ArcItm'),
			recDeptId:'',
			userDeptId:'',
			stDate:'',
			endDate:'',
			billStatus:'',
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,	
	}
	loadDataGridStore('dgPatOrd',queryParams);
}

/*
 * 灵活折扣grid
 */
function initPatShareGrid(){
	var queryParams={
			ClassName:'BILL.PKG.BL.Flexiblediscount',
			QueryName:'FindFleDisInfoByAdmDr',
			AdmDr:GV.ADM,
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			
			
	}
	loadDataGridStore('dgPatShareOrd',queryParams);
	GV.DisOrdList=$HUI.datagrid('#dgPatShareOrd')
}





/*
*选择医嘱从医嘱列表移动到已选医嘱列表
*/
function MoveLeftClick(index) {
    if (index > -1) {
        $('#dgPatOrd').datagrid('selectRow', index);
    }
    var Rows = $('#dgPatOrd').datagrid('getChecked');
    var RowsLen = Rows.length;
    if (RowsLen > 0) {
        for (var i = 0; i < RowsLen; i++) {
            if (MoveLeftRowChecked(Rows[i])) {
                var index = $('#dgPatOrd').datagrid('getRowIndex', Rows[i]);
                $('#dgPatOrd').datagrid('deleteRow', index);
                $('#dgPatShareOrd').datagrid('appendRow', Rows[i]);
               
            }


        }
    } else {
        $.messager.alert('提示', '请选择要打折的医嘱', 'info');
        return;
    }
   GV.DisOrdList=$HUI.datagrid('#dgPatShareOrd')
   GV.CHANGE=""
   CalcPatDisOrdAmt();
   
   
}

/*
*已经选择医嘱是否存在相同医嘱
*/
function MoveLeftRowChecked(Row) {

    var Rows = $('#dgPatShareOrd').datagrid('getRows');
    if (Rows !=null)
    {
    var RowsLen = Rows.length;
    var Flag = true
    var ExistInfo = ""
    if (RowsLen > 0) {
        for (var i = 0; i < RowsLen; i++) {
            if (Row.oeori == Rows[i].oeori) {
                ExistInfo = ExistInfo + "<br>" + Rows[i].arcimDesc
                Flag = false
            }
        }

        if (!Flag) {
            $.messager.alert('提示', '已选医嘱已经存在相同的医嘱' + ExistInfo, 'error');

        }
    }
    }
    return Flag
}

/*
*从已选医嘱列表移动到医嘱列表
*注意：已经完成折扣的不允许打折
*/
function MoveRightClick(index) 
{
	
	var PatToAmt=toNumber(getValueById('PatToAmt'));
	var PatShareAmt=toNumber(getValueById('PatShareAmt'));
    var PatDisAmt=toNumber(getValueById('PatDisAmt'));
                                                           
    if (index > -1) {
        $('#dgPatShareOrd').datagrid('selectRow', index);
    }
    var Flag=0
    var Rows = $('#dgPatShareOrd').datagrid('getChecked');
   if(Rows !=null){
    var RowsLen = Rows.length;
	if (RowsLen==1)
	{
	   	 var index = $('#dgPatShareOrd').datagrid('getRowIndex', Rows[0]);
	   	 if (Rows[0].FixFlag==1)
	   	 {
		   	 $.messager.alert("提示", "已经完成打折医嘱,不能单条删除", 'error')
		   	 return;
		 }
	   	 if (FormatVal(Rows[0].FixRowId) != "") 
	   	 {
		   	 
		   	 $.messager.alert("提示", "已经完成打折,不允许删除", 'error')
		   	 return;
			  
	   	  }	      
		   
		  else
		   {
	                $('#dgPatShareOrd').datagrid('deleteRow', index);
                    if ($('#dgPatOrd').datagrid('getData').total > 0)
                    {  
                       Rows[0].DisRate=""
                       Rows[0].PatShareAmt=""
                       $('#dgPatOrd').datagrid('appendRow', Rows[0])
                    };
                     PatToAmt = PatToAmt - toNumber(Rows[0].billTotalAmt)
                     PatShareAmt = PatShareAmt- toNumber(Rows[0].billPashareAmt);
                     setValueById('PatToAmt',PatToAmt);
                     setValueById('PatShareAmt',PatShareAmt);
                     setValueById('PatDisAmt',(PatToAmt-PatShareAmt));
                   
           
		    }
	   	
	}else
	{
		 $.messager.alert('提示', '只能选中一条医嘱移除', 'info');
	}	
  }
}




 /*
*计算自付金额和实售金额
 */
function CalcPatDisOrdAmt(){
	
	var PatToAmt=0 
	var PatShareAmt=0 
	
	

	//console.log(GV.ProdList)
	if (!(JSON.stringify(GV.DisOrdList) == "{}"))
	{
	$.each(GV.DisOrdList.getRows(), function (index, row) {
	    	var RowPatToAmt=0.0
			var RowPatShareAmt=0.0
			
			if(GV.CHANGE =="DISRATE")
			 {
				 PatToAmt = toNumber(row.billTotalAmt);
				 RowPatShareAmt=toNumber(row.billPashareAmt)
			  }
			  
			  
			 if(GV.CHANGE =="DISAMT")
			 {
			    var RowDisRate = toNumber(row.DisRate);
			     RowPatToAmt = toNumber(row.billTotalAmt);
			     RowPatShareAmt = RowPatShareAmt * RowDisRate;
			  }
			  
			  
			  
			if(GV.CHANGE =="")
			  {
				
				 RowPatToAmt=toNumber(row.billTotalAmt)	
				 RowPatShareAmt= toNumber(row.billPashareAmt);
			
			  }
			PatToAmt=toNumber(PatToAmt)+toNumber(RowPatToAmt);
		    PatShareAmt=toNumber(PatShareAmt)+toNumber(RowPatShareAmt)
		   
		    
		});
	  }
	    setValueById('PatToAmt', PatToAmt.toFixed(2));
	    setValueById('PatShareAmt', PatShareAmt.toFixed(2)); 
        setValueById('PatDisAmt', (PatToAmt-PatShareAmt).toFixed(2));  

}


	
//数值转换	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}
//取值格式
function FormatVal(value) {
    var OutV = value
    if (undefined == value) {
        OutV = "";
    }
    return OutV
}
//拼医嘱串
//格式:（医嘱RowId^医嘱金额^折扣金额^自付金额^折扣率）、多个串之间用$符号分割
function BuildDisOrdStr()
{
	
	var OrdStr=""
	if (!(JSON.stringify(GV.DisOrdList) == "{}"))
	{
		
		
		$.each(GV.DisOrdList.getRows(), function (index, row) {
	      if(row.FixFlag==0)
	    	{
			var RowOrdStr="" 
			RowOrdStr=row.oeori   //医嘱Id
			///RowOrdStr=RowOrdStr+"^"+row.billTotalAmt //医嘱金额
			//RowOrdStr=RowOrdStr+"^"+row.PatDisAmt    //优惠金额
			///RowOrdStr=RowOrdStr+"^"+row.billPashareAmt //医嘱自付金额
			///RowOrdStr=RowOrdStr+"^"+row.DisRate //折扣率
		   if (OrdStr==""){OrdStr=RowOrdStr}
		   else{OrdStr=OrdStr+"$"+RowOrdStr}
	    	}
		    
		});
			
   }
	
	return OrdStr
}

 
//灵活打折医嘱信息保存
function IPOrdDisInfoSave()
{
	var PatDisAmt=toNumber(getValueById('PatDisAmt'));
	var PatToAmt=toNumber(getValueById('PatToAmt'));
	var PatDisRate=toNumber(getValueById('PatDisRate'));

	
	//alert("PatDisAmt="+PatDisAmt+";;;"+PatToAmt)
	if (PatDisAmt <= 0){
		$.messager.alert('提示', '不允许打折', 'info')
		return ;
	}

	var AdmDr="", OrdStr="", DiscRate="",  SPDNo="", HospDr="", UserDr=""
	AdmDr=GV.ADM
	OrdStr=BuildDisOrdStr();
	//alert("OrdStr="+OrdStr)
	if (OrdStr=="")
	{
		$.messager.alert('提示', '没有需要打折的医嘱，请选择', 'info')
		return ;
	}
	SPDNo=getValueById("DisSPNo")
	if (SPDNo=="")
	{
		$.messager.alert('提示', '审批单号不能为空', 'info')
		return ;
	}
	HospDr=PUBLIC_CONSTANT.SESSION.HOSPID
    if (HospDr=="")
	{
		$.messager.alert('提示', '院区不能为空', 'info')
		return ;
	}
	UserDr=GV.GUser
	if (UserDr=="")
	{
		$.messager.alert('提示', '操作员不能为空', 'info')
		return ;
	}
	$.m({
		ClassName: "BILL.PKG.BL.Flexiblediscount",
		MethodName: "FlexibleIPdiscountSave",
		AdmDr:AdmDr,
		OrdStr:OrdStr,
		Acount:PatToAmt, 
		DiscRate:PatDisRate, 
		DiscAcount:PatDisAmt, 
		DiscReason:SPDNo,
		HospDr:HospDr,
		UserDr:UserDr
		},
	function(rtn)
	{
		var myAry = rtn.split('^');
		if (myAry[0]==0) 
		{
		  $.messager.alert('提示', '保存打折成功', 'info');
		  initPatShareGrid();
		
		}else
		{
		 $.messager.alert('提示', '保存打折失败'+rtn, 'error');
		 return;
		}	
        });
	
}

/*
 * 删除折扣
 */
function DleteFlexDisClick(){
	$.messager.confirm('提示','是否取消灵活折扣记录？',function(r){
		if(r){
			$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountIPDelete",
					AdmDr:GV.ADM,
					HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('提示','删除成功','info',function(){
							initPatShareGrid();
						});
					}else{
						$.messager.alert('提示','删除失败:'+rtn.split('^')[1],'info');
						
					}
				})
				
			}		
		})				
}
