
/*
 * FileName:	dhcbill.pkg.prodconarcitms.js
 * User:		DingSH
 * Date:		2019-09-25
 * Function:	
 * Description: 套餐产品关联医嘱维护
 */
 
 /*
 *扩展验证函数
 */
 $.extend($.fn.validatebox.defaults.rules, {
	checkMinAmount: {   
	    validator: function(value) {
		    return +value >= +GV.MinSalesAmount;
		},
		message: '总售价不能小于最低售价:'
	},
	checkMaxAmount: {    
	    validator: function(value) {
		    return +value <= +getValueById("ProTotalAmt");
		},
		message: '总售价不能大于总金额'
	}
	,
	checkMinSalesMinAmount: {   
	    validator: function(value) {
		    return +value >= +GV.MinSalesAmount;
		},
		message: '最低售价不能小于:0'
	},
	checkMinSalesMaxAmount: {    
	    validator: function(value) {
		    return +value <= +getValueById("ProSalesAmt");
		},
		message: '最低售价不能大于总售价'
	}
	
	
	
});
 

var GV=
{
    EditIndex: undefined,
    ProdList:{},
    PRICEPRECISION:4 ,        // 单价小数点保留位数,
    MAXQTY:100,               // 最大配置数量，
    CHANGE:"" ,               // 变化类型
    IsCalcProAmt:1 ,          // 是否金额 总金额和总售价
    MinRowSalesAmount:0.01,   // 医嘱最小金额
    MinRowActualPrice:0.0001, // 医嘱最小实售单价
    MinSalesAmount:0,
    ProAmt:0.0,
    ProSalesAmt:0.0,
    ProdDr:'',
    PROCode:'',
    PROName:'',
    PROPrice:'',
    PROSalesPrice:'',
    PROMimuamout:'',
    PROStatus:'',
    PROTypeDesc:"",           //套餐类型
    PROStatusDesc:"",         //套餐状态描述
    PROProdTypeDesc:"",       //套餐使用类型
    PROIsshareDesc:"",        //套餐是否共享
    PROIndepDesc:"",          //套餐是否自主定价
    PROLevelDesc:"",          //套餐等级
    PROIssellspDesc:"",       //套餐是否独立售卖
    GUser:session['LOGON.USERID'],
    curRowIndex:-1,
    curRow:{},
    curVal:0.0,
    ed:{},
    HOSPID:PUBLIC_CONSTANT.SESSION.HOSPID //HOSPID:session['LOGON.HOSPID'],
    
};
    
   
$(function () 
{
    init_RqParam();  	 //获取Rq传值
    init_ProdSpan();     //加载产品信息
    init_BigLnkBtn();
    init_ArcItmsDG();   // 初始化grid
    //关键字回车事件
    $('#ArcKeyWords').keydown(function (e) {
        if (e.keyCode == 13) {
            loadWestGridData();
        }
    });
    init_ProSalesAmt();
    loadEastGridData(); // 加载已经勾选的医嘱
    init_OrdCat();      // 医嘱大类	
    init_OrdSubCat();   // 医嘱子类
});

function init_ProSalesAmt()
{
	
$("#ProSalesAmt").keydown(
	 function(e){
		 if (e.keyCode==13)
		 {
			  var tpAmt=$(this).val();
				if (tpAmt!="")
				{
				   calcAvgArcRows();
				}else{
					$.messager.alert('提示', '售价金额值非法。', 'error', function() {
						focusById("ProSalesAmt");
					});
				}
			}
		 
		 });
    setValueById('ProTotalAmt', parseFloat(GV.ProAmt).toFixed(2));
    setValueById('ProSalesAmt', parseFloat(GV.ProAmt).toFixed(2));
	setValueById('ProMinSalesAmt', parseFloat(GV.PROMimuamout).toFixed(2));
	
}

function init_BigLnkBtn()
{
	//alert("PROStatus="+PROStatus)
	
	   // 保存
       $HUI.linkbutton("#btn-Save", {
            onClick: function () {
                saveConClick();
            }
        });
        // 新增
        $HUI.linkbutton("#btn-trans", {
            onClick: function () {
                transClick(-1);
            }
        });
        // 移除
        $HUI.linkbutton("#btn-return", {
            onClick: function () {
                returnClick(-1);
            }
        });
	
    if (!((GV.PROStatus=="5")||(GV.PROStatus=="7")))
	{
		
		 $("#btn-Save").linkbutton("disable");
		 $("#btn-trans").linkbutton("disable");
		 $("#btn-return").linkbutton("disable");
		
    }
   	
	
}

/*
*获取Request传入参数
*/
function init_RqParam() {
    GV.ProdDr = getParam('ProdDr');
    GV.PROCode = getParam('PROCode');
    GV.PROName = ascTransChar(getParam('PROName'));
    GV.PROPrice = getParam('PROPrice');
    GV.PROSalesPrice = getParam('PROSalesPrice');
    GV.PROMimuamout = getParam('PROMimuamout');
    GV.PROStatus =getParam('PROStatus');
    GV.PROTypeDesc =ascTransChar(getParam('PROTypeDesc'));
    GV.PROStatusDesc =ascTransChar(getParam('PROStatusDesc'));
    GV.PROProdTypeDesc =ascTransChar(getParam('PROProdTypeDesc'));
    GV.PROIsshareDesc =ascTransChar(getParam('PROIsshareDesc'));
    GV.PROIndepDesc =ascTransChar(getParam('PROIndepDesc'));
    GV.PROLevelDesc =ascTransChar(getParam('PROLevelDesc'));
    GV.PROIssellspDesc=ascTransChar(getParam('PROIssellspDesc'));
}
/*
*初始化Banner
*/
function init_ProdSpan() {
    $('#cpProCode').text(GV.PROCode)
    $('#cpProDesc').text(GV.PROName)
    $('#cpPrice').text(GV.PROPrice)
    $('#cpSalesPrice').text(GV.PROSalesPrice)
    $('#cpMimuamout').text(GV.PROMimuamout)
    $('#cpTypeDesc').text(GV.PROTypeDesc)
    $('#cpStatusDesc').text(GV.PROStatusDesc)
    $('#cpProdTypeDesc').text(GV.PROProdTypeDesc)
    $('#cpIsshareDesc').text(GV.PROIsshareDesc)
    $('#cpIndepDesc').text(GV.PROIndepDesc)
    $('#cpLevelDesc').text(GV.PROLevelDesc)  
    $('#cpIssellspDesc').text(GV.PROIssellspDesc)   
}

/*
*选择医嘱从医嘱列表移动到已选医嘱列表
*/
function transClick(index) {
    if (index > -1) {
        $('#dgWest').datagrid('selectRow', index);
    }
    var SelectedRow = $('#dgWest').datagrid('getChecked');
   
    var SelectedRowLen = SelectedRow.length;
    if (SelectedRowLen > 0) {
        for (var i = 0; i < SelectedRowLen; i++) {
            if (transRowChecked(SelectedRow[i])) {
                var index = $('#dgWest').datagrid('getRowIndex', SelectedRow[i]);
                $('#dgWest').datagrid('deleteRow', index);
                $('#dgEast').datagrid('appendRow', SelectedRow[i]);
               
            }


        }
    } else {
        $.messager.alert('提示', '请选择要新增的医嘱', 'info');
        return;
    }
   GV.CHANGE=""
   CalcProdAmt();
   
   
}

/*
*已经选择医嘱是否存在相同医嘱
*/
function transRowChecked(Row) {

    var SelectedRow = $('#dgEast').datagrid('getRows');
    if (SelectedRow !=null)
    {
    var SelectedRowLen = SelectedRow.length;
    var Flag = true
    var ExistInfo = ""
    if (SelectedRowLen > 0) {
        for (var i = 0; i < SelectedRowLen; i++) {
            if (Row.ArcimRowID == SelectedRow[i].ArcimRowID) {
                ExistInfo = ExistInfo + "<br>" + SelectedRow[i].ArcimDesc
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
*选择医嘱从已选医嘱列表移动到医嘱列表
*注意：草稿状态的产品关联医嘱需要询问删除
*/
function returnClick(index) {
	
	
	  GV.ProAmt=parseFloat(getValueById('ProTotalAmt'));
      GV.ProSalesAmt=parseFloat(getValueById('ProSalesAmt'));
                                                            
                                  
	if (!((GV.PROStatus=="5")||(GV.PROStatus=="7"))) return ; //非草稿或驳回状态不允许编辑

    if (index > -1) {
        $('#dgEast').datagrid('selectRow', index);
    }
    var Flag=0
    var SelectedRow = $('#dgEast').datagrid('getChecked');
   if(SelectedRow !=null){
    var SelectedRowLen = SelectedRow.length;
    //alert("SelectedRowLen="+SelectedRowLen)
	if (SelectedRowLen==1)
	{
	   	var index = $('#dgEast').datagrid('getRowIndex', SelectedRow[0]);
	   	//alert("SelectedRow[0].ProSubDr)="+SelectedRow[0].ProSubDr);
	   	//alert("index="+index)
	   	 if (FormatVal(SelectedRow[0].ProSubDr) != "") 
	   	 {
		   	 
		   	 $.messager.confirm("删除", "此产品已经包含此医嘱明细,确定进行删除?", function(r) {
			   	 if(r){
				   	  $.m({
                            ClassName: "BILL.PKG.BL.ProductDetails",
                            MethodName: "DelProConByProSubDr",
                            ProDr:GV.ProdDr,
                            ProSubDr: SelectedRow[0].ProSubDr,
                            UserDr: GV.GUser,
                        }, function (rtn) {
	                       
                            if (parseInt(rtn.split("^")[0]) > 0) {
                                $.messager.alert('提示', '删除成功', 'info');
                                 $('#dgEast').datagrid('deleteRow', index);
                                 SelectedRow[0].ProSubDr=""
                                 if ($('#dgWest').datagrid('getData').total > 0) $('#dgWest').datagrid('appendRow', SelectedRow[0]);
                                  GV.ProAmt = GV.ProAmt - SelectedRow[0].TotalAmt;
                                  GV.ProSalesAmt = GV.ProSalesAmt - SelectedRow[0].SalesAmount
                                  setValueById('ProTotalAmt', parseFloat(GV.ProAmt).toFixed(2));
                                  setValueById('ProSalesAmt', parseFloat(GV.ProSalesAmt).toFixed(2));
                                  init_ProdSpan();
                                  loadEastGridData();
                                
                            } else {
                                $.messager.alert('提示', '删除失败,Error=' + rtn, 'info');
                               
                            }
                        });
				   	 }
			   	 });
		   	      
		   	 }
		   	 else{
	                $('#dgEast').datagrid('deleteRow', index);
                    if ($('#dgWest').datagrid('getData').total > 0) $('#dgWest').datagrid('appendRow', SelectedRow[0]);
                     GV.ProAmt = GV.ProAmt - SelectedRow[0].TotalAmt;
                     GV.ProSalesAmt = GV.ProSalesAmt - SelectedRow[0].SalesAmount
                     setValueById('ProTotalAmt', parseFloat(GV.ProAmt).toFixed(2));
                     setValueById('ProSalesAmt', parseFloat(GV.ProSalesAmt).toFixed(2));
                     init_ProdSpan();
		   }
	   	
	}else
	{
		 $.messager.alert('提示', '只能选中一条医嘱移除', 'info');
	}	
  }
}
/*
* 套餐关联医嘱维护弹窗datagrid
*/
function init_ArcItmsDG() {
    var dgColumns = [[
        //{field:'PROCode',title:'医嘱项编码',width:140},
        { field: 'ArcimDesc', title: '医嘱项名称', width: 150 },
        { field: 'ItemPrice', title: '价格', width: 90 },
        { field: 'ActualPrice', title: '实售单价', width: 90, hidden: true },
        { field: 'Qty', title: '数量', width: 60, hidden: true },
        { field: 'TotalAmt', title: '金额', width: 100, hidden: true },
        { field: 'SalesAmount', title: '实售金额', width: 90, hidden: true },
        {field: 'IsDiscnt', title: '可否打折', width: 80, align: 'center',
             formatter: function(value,row,index){
				if (row.IsDiscnt==1){
					return "可";
				    } else {
					return "否";
				    }
			   } 
			   },
	    { field: 'billuom', title: '计价单位', width: 80 },  
        {field: 'PRODRestrictiontype', title: '限制类型', width: 80, align: 'center',hidden: true },	       
        {field: 'PRODDayNum', title: '限制天数', width: 80, align: 'center',hidden: true },	
        { field: 'subcatdesc', title: '子类', width: 75 },
        { field: 'ProSubDr', title: 'ProSubDr', width: 50, hidden: true },
        { field: 'billuomId', title: 'billuomId', width: 50, hidden: true },
        { field: 'ArcimRowID', title: 'ArcimRowID', width: 50, hidden: true },
        { field: 'PRODCreatDate', title: 'PRODCreatDate', width: 50, hidden: true },
        { field: 'PRODCreatTime', title: 'ArcimRowID', width: 50, hidden: true },
        { field: 'PRODCreatUserDr', title: 'ArcimRowID', width: 50, hidden: true }
    ]];
    $HUI.datagrid('#dgWest',{
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 30, 40, 50],
        url: $URL,
        toolbar: '#tToolBar',
        onBeforeLoad: function (param) {

        },
        frozenColumns: [[{ title: 'ck', field: 'ck', checkbox: true }]],
        columns: dgColumns,
        onLoadSuccess: function (data) {
            EditIndex = -1;
        },
        onDblClickRow: function (rowIndex, rowData) {
            transClick(rowIndex)
        }
    });


    var eastdgColumns = [[
        //{field:'PROCode',title:'医嘱项编码',width:140},
        { field: 'ArcimDesc', title: '医嘱项名称', width: 150 },
        { field: 'ItemPrice', title: '价格', width: 90 },
        {
            field: 'ActualPrice', title: '实售单价', width: 90,
            editor: {
                type: 'numberbox',
                options: {
                    min: 0,
                    precision: 4,
                    //isKeyupChange: true,
                    onChange: function (newValue, oldValue) {

                    }
                }
            }
        },
        { 
            field: 'Qty', title: '数量', width: 60,
            editor: 
            {
                type: 'numberbox',
                options: 
                { 
                    min: 0,
                    precision: 0,
                
                 }
             }
        },
        { field: 'TotalAmt', title: '金额', width: 100 },
        {
            field: 'SalesAmount', title: '实售金额', width: 90,
            editor: {
                type: 'numberbox',
                options: {
                    min: 0,
                    precision: 2,
                    //isKeyupChange: true,
                    onChange: function (newValue, oldValue) {
                        //Code=newValue;

                    }
                }
            }
        },
         {field: 'IsDiscnt', title: '可否打折', width: 80, align: 'center',
             formatter: function(value,row,index){
	             //alert("row.IsDiscnt="+row.IsDiscnt)
				if (row.IsDiscnt==1)
				    {
					 return "可";
				    }
				    else if(row.IsDiscnt=="") {
					    
					return "*";
				    }
				   else {
					return "否";
				    }
			   }

          },
          { field: 'billuom', title: '计价单位', width: 80 },
		 {field: 'PRODRestrictiontype', title: '限制类型', width: 100, align: 'center',
			editor:{
					  type: 'combobox',
						options: {
						panelHeight: 'auto',
					   	valueField:'Code',
						textField:'Desc',
						limitToList:true,
						method:'remote',
						url:$URL,
						onBeforeLoad:function(para){
						para.ClassName='BILL.PKG.BL.Dictionaries'
						para.QueryName='QueryDic'
						para.DictType="ResType"
					    para.DicCode=""
						para.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID
						para.ResultSetType='Array';
						},	
						onSelect:function(data){
							if(data.Code==0){
								$(thisEd.target).combobox('clear'); 
								}
						   

						},	
						onChange:function(oldVal,newVal)
						  {
							

		                  }
						}
					}
			}
			,	       
         {field: 'PRODDayNum', title: '限制天数', width: 80, align: 'center',
				editor: 
                {
                type: 'numberbox',
                options: 
                { 
                    min: 0,
                    precision: 0,
                
                 }
              }
			},	
        { field: 'subcatdesc', title: '子类', width: 105, hidden: true },
        { field: 'ProSubDr', title: 'ProSubDr', width: 50, hidden: true },
        { field: 'billuomId', title: 'billuomId', width: 50, hidden: true },
        { field: 'ArcimRowID', title: 'ArcimRowID', width: 50, hidden: true },
        { field: 'PRODCreatDate', title: 'PRODCreatDate', width: 50, hidden: true },
        { field: 'PRODCreatTime', title: 'ArcimRowID', width: 50, hidden: true },
        { field: 'PRODCreatUserDr', title: 'ArcimRowID', width: 50, hidden: true }

    ]];
 GV.ProdList= $HUI.datagrid('#dgEast', {
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        pagination: true,
        rownumbers: true,
        pageSize: 100000,
        pageList: [100000],
        data: [],
        toolbar: '#tToolBar',
        frozenColumns: [[{ title: 'ck', field: 'ck', checkbox: true }]],
        columns: eastdgColumns,
        onDblClickRow: function (rowIndex, rowData) {
        },
        onClickRow: function (rowIndex, rowData) 
        {
	        //alert("IsDiscnt="+rowData.IsDiscnt)
        },
        onClickCell: function (index, field, value) {
	         if ((GV.PROStatus=="5")||(GV.PROStatus=="7"))
	         {
			   ProdClickCell(index, field, value);
	         }
		},
		onBeginEdit: function (index, row) {
			if ((GV.PROStatus=="5")||(GV.PROStatus=="7"))
	         {
			   ProdBeginEdit(index, row);
			}
    	},
		onAfterEdit: function (index, rowData, changes) {
			if ((GV.PROStatus=="5")||(GV.PROStatus=="7"))
	         {
			   ProdAfterEdit(index, rowData, changes);
	         }
		},
        
        onLoadSuccess: function (data) {
            GV.CHANGE=""
           CalcProdAmt();

        },

    });
}

/*
*拼套餐产品信息串
*/
function BuildProInfo() {
    var InStr = GV.ProdDr + "^" + getValueById('ProTotalAmt') + "^" + getValueById('ProSalesAmt') + "^" + getValueById('ProMinSalesAmt')
    return InStr
}
/*
*拼套餐产品医嘱明细信息串
*/
function BuildProSubInfo(Row) {
    //rowid^套餐产品Dr^关联的医嘱^数量^计价单位
    var InStr = Row.ProSubDr + "^" + GV.ProdDr + "^" + Row.ArcimRowID + "^" + Row.Qty + "^" + FormatVal(Row.billuomId)
    //^标准单价^实际单价^金额^售价^必须产品(,Y,N)
    InStr = InStr + "^" + Row.ItemPrice + "^" + Row.ActualPrice + "^" + Row.TotalAmt + "^" + Row.SalesAmount + "^" + "Y"
    //^创建日期^创建时间^修改日期^修改时间^创建人
    InStr = InStr + "^" + FormatVal(Row.PRODCreatDate) + "^" + FormatVal(Row.PRODCreatTime) + "^" + "" + "^" + "" + "^" + FormatVal(Row.PRODCreatUserDr)
    //^修改人^限制类型^限制天数^互斥标志
    InStr = InStr + "^" + GV.GUser + "^" + FormatVal(Row.PRODRestrictiontype) + "^" + FormatVal(Row.PRODDayNum) + "^" + ""
    return InStr
}


function FormatVal(value) {
    var OutV = value
    if (undefined == value) {
        OutV = "";
    }
    return OutV
}

/*
*校验套餐产品关联医嘱保存
*/
function checkProBalance()
{
	//#1 对 录入框 套餐总金额/总售价/最低售价的校验
	var tProTotalAmt=getValueById('ProTotalAmt')
	var tProSalesAmt=getValueById('ProSalesAmt')
	var tProMinSalesAmt=getValueById('ProMinSalesAmt')
	if (toNumber(tProTotalAmt)<toNumber(tProSalesAmt))
	{
		$.messager.alert("提示","校验：总金额小于总售价,请修改","error")
		focusById("ProSalesAmt");
		return false 
    }
    if (toNumber(tProSalesAmt)<toNumber(tProMinSalesAmt))
	{
		$.messager.alert("提示","校验：最低售价大于总售价,请修改","error")
		focusById("ProMinSalesAmt");
		return false 
    }
    //#2 校验表格中实售单价*数量 和 实售金额的平衡关系
    var RowsTotalAmt=0.0 ;           //通过累加金额 计算 总金额
    var RowsSalesAmount=0.0 ;        //通过累加售价 计算  总计售价
    var RowsCalcTotalAmt=0.0 ;       //通过 价价 * 数量 计算 总金额 
    var RowsCalcSalesAmount=0.0 ;    //通过 实售单价 * 数量 计算 总售价 
    
    
    
    if (!(JSON.stringify(GV.ProdList) == "{}"))
	{
	     $.each(GV.ProdList.getRows(), function (index, row) {
			    var RowItemPrice = toNumber(toNumber(row.ItemPrice).toFixed(GV.PRICEPRECISION));
			    var RowActualPrice = toNumber(toNumber(row.ActualPrice).toFixed(GV.PRICEPRECISION));
			    var RowQty = toNumber(toNumber(row.Qty).toFixed(2));
			    
		     RowsTotalAmt=toNumber(RowsTotalAmt)+toNumber(row.TotalAmt)
		     RowsSalesAmount=toNumber(RowsSalesAmount)+toNumber(toNumber(row.SalesAmount).toFixed(2));
		     
		     
		     RowsCalcTotalAmt=toNumber(RowsCalcTotalAmt)+ toNumber((RowItemPrice * RowQty).toFixed(2))
		     RowsCalcSalesAmount=toNumber(RowsCalcSalesAmount)+ toNumber((RowActualPrice * RowQty).toFixed(2))
		    
		});
	  }
	  
	  if(RowsTotalAmt!=RowsCalcTotalAmt)
	  {
		  $.messager.alert("提示","校验：(价格 * 数量=金额)的累加之和:"+RowsCalcTotalAmt+"不等于通过累加表格列[金额]的合计:"+ RowsTotalAmt+" ,请修改","error")
		  return false;
		  
	   }
	   
	   
	  if(RowsSalesAmount!=RowsCalcSalesAmount)
	  {
		  $.messager.alert("提示","校验：(实售单价 * 数量=实售金额)的累加之和:"+RowsCalcSalesAmount+ "不等于通过累加表格列[实售金额]的合计"+ RowsSalesAmount +" ,请修改","error")
		  return false;
	   }
	   if (tProTotalAmt!=toNumber(toNumber(RowsTotalAmt).toFixed(2)))
	   {
		    $.messager.alert("提示","校验：输入框的总金额不等于通过累加表格列 [金额] 的合计:"+RowsTotalAmt+" ,请修改","error")
		    return false;
		}
		
	   if (tProSalesAmt!=toNumber(toNumber(RowsSalesAmount).toFixed(2)))
	   {
		   
		    $.messager.alert("提示","校验：输入框的总售价不等于通过累加表格列 [实售金额] 的合计:"+RowsSalesAmount+" ,请修改","error")
		    return false;
		}
     
    return true  
	
}


/*
*套餐产品关联医嘱保存
*/
function saveConClick() {
	if (!((GV.PROStatus=="5")||(GV.PROStatus=="7"))) return ; //非草稿或驳回状态不允许编辑
    var inStr = '';
    
    var Flag=checkProBalance();
    if (!Flag) return;
    
    var SelectedRow = $('#dgEast').datagrid('getRows');
    var SelectedRowLen = SelectedRow.length;
    var ProInfo = BuildProInfo();

    var ProSubStr = ""

    if (SelectedRowLen > 0) {
        for (var i = 0; i < SelectedRowLen; i++) {
            if (ProSubStr == '') ProSubStr = BuildProSubInfo(SelectedRow[i]);
            else ProSubStr = ProSubStr + "$" + BuildProSubInfo(SelectedRow[i]);

        }

        $.m({
            ClassName: "BILL.PKG.BL.ProductDetails",
            MethodName: "SaveProConProSub",
            ProInfo: ProInfo,
            ProSubStr: ProSubStr,
            UserDr: GV.GUser
        }, function (rtn) {
            if (parseInt(rtn.split("^")[0]) > 0) {
                 GV.PROPrice = getValueById('ProTotalAmt');
                 GV.PROSalesPrice = getValueById('ProSalesAmt');
                 GV.PROMimuamout = getValueById('ProMinSalesAmt');
                init_ProdSpan();
                $.messager.alert('提示', '产品关联医嘱保存成功', 'info');
                loadEastGridData();
            } else {
                $.messager.alert('提示', '保存失败,Error=' + rtn, 'info');
            }
        });
        //websys_showModal('close');
    } else {
        $.messager.alert('提示', '没有要保存的数据', 'info')

    }
}
/*
*加载医嘱大类
*/
function init_OrdCat() {
    $('#OrdCat').combobox({
        valueField: 'Id',
        textField: 'Desc',
        url: $URL,
        mode: 'remote',
        onSelect: function (data) {
            init_OrdSubCat();
            loadWestGridData();

        },
        onBeforeLoad: function (param) {
            param.ClassName = 'BILL.PKG.BL.NoDiscountsConfig';
            param.QueryName = 'QueryOrderCategory';
            param.ResultSetType = 'Array';
            param.KeyWords = param.q;
            //param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
        }


    })
}

/*
*加载医嘱子类
*/
function init_OrdSubCat() {
    var OrdCatDr = getValueById('OrdCat');
    if (OrdCatDr == 0) OrdCatDr = ""
    $('#OrdSubCat').combobox({
        valueField: 'Id',
        textField: 'Desc',
        url: $URL,
        mode: 'remote',
        onSelect: function (data) {
            loadWestGridData();
        },
        onBeforeLoad: function (param) {
            param.ClassName = 'BILL.PKG.BL.NoDiscountsConfig';
            param.QueryName = 'QueryARCItemCat';
            param.ResultSetType = 'Array';
            param.KeyWords = param.q;
            param.OrdCatDr = OrdCatDr;
            //param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
        }


    })
}

/*
*医嘱列表查询
*/
function loadWestGridData() {
    var OrdCatDr = getValueById('OrdCat');
    var OrdSubCatDr = getValueById('OrdSubCat');
    if (OrdCatDr == 0) OrdCatDr = ""
    if (OrdSubCatDr == 0) OrdSubCat = ""
    getValueById('OrdSubCat')
    var queryParams = {
        ClassName: 'BILL.PKG.BL.NoDiscountsConfig',
        QueryName: 'FindAllItem',
        Alias: getValueById('ArcKeyWords'),
        GroupDr: '29',
        OrdCatDr: OrdCatDr,
        OrdCatSubDr: OrdSubCatDr,
        HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
    }
    $('#dgWest').datagrid({
        queryParams: queryParams
    })
    $('#dgWest').datagrid('reload');
}

/*
*套餐产品已关联医嘱加载
*/
function loadEastGridData() {
    var url = $URL + "?ClassName=BILL.PKG.BL.ProductDetails&QueryName=QueryProductDetails" + '&ProdDr=' + GV.ProdDr;
    $('#dgEast').datagrid('options').url = url
    $('#dgEast').datagrid('reload');
}

/**
 * Grid单元格单击事件
 */
function ProdClickCell(index, field, value) {
	ProdEditCell(index, field, value);
}

/**
* 产品单元格编辑
*/
function ProdEditCell(index, field, value) {
	GV.ProdList.selectRow(index);   //选中设定行
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.ProdList.editCell({
			index: index,
			field: field
		});
		var ed = GV.ProdList.getEditor({
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
	if (GV.ProdList.validateRow(GV.EditIndex)) {
		GV.ProdList.endEdit(GV.EditIndex);
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
	var row = GV.ProdList.getRows()[index];
	//alert("IsDiscnt="+row.IsDiscnt)
	//走配置 支付方式不能编辑
	if ((field != "SalesAmount") && (field != "ActualPrice")&& (field != "Qty")&& (field != "PRODRestrictiontype")&& (field != "PRODDayNum")) {
	
			return false;
		
	}
	
    if ((field == "PRODRestrictiontype")|| (field == "PRODDayNum")) {
	
			return true;;
		
	}
	
	if(((row.IsDiscnt==0)||(row.IsDiscnt=="否")||((row.IsDiscnt=="*")))&&(field != "Qty")){
		return false
		}
	return true;
}



/**
*开始编辑
*/
function ProdBeginEdit(index, row)
 {
     RowArcQtyEnter(index, row);
     RowArcSalesAmountEnter(index, row);
     RowArcActualPriceEnter(index, row);
     
}

function getNextEditRow() {
	var nextIndex = GV.EditIndex + 1;
	return nextIndex;
}


/**
* 结束编辑
*/
function ProdAfterEdit(index, rowData, changes) {
	GV.ProdList.endEdit(index);
	GV.EditIndex = undefined;
	CalcProdAmt();
}

 /*
*计算总金额和总售价
 */
function CalcProdAmt(){
	var TotalAmt=0 
	var SalesAmount=0 
	//console.log(GV.ProdList)
	if (!(JSON.stringify(GV.ProdList) == "{}"))
	{
	$.each(GV.ProdList.getRows(), function (index, row) {
			var RowTotalAmt=0.0
			var RowSalesAmount=0.0
			if(GV.CHANGE =="ROWQTY")
			 {
			    var RowItemPrice = toNumber(row.ItemPrice);
			    var RowActualPrice = toNumber(row.ActualPrice);
			    var RowQty = toNumber(row.Qty);
			    RowTotalAmt=RowItemPrice *  RowQty
			    RowSalesAmount = RowActualPrice * RowQty
			  }
			if(GV.CHANGE =="ROWSALESAMT")
			  {
				RowTotalAmt=toNumber(row.TotalAmt)
				RowSalesAmount=toNumber(row.SalesAmount)
			  }
			if(GV.CHANGE =="ACTUALP")
			  {
				var ActualPrice = toNumber(row.ActualPrice);
				var RowQty = toNumber(row.Qty);
				RowTotalAmt=toNumber(row.TotalAmt)
				RowSalesAmount=ActualPrice * RowQty 
			   }
			if(GV.CHANGE =="")
			  {
				
				 RowTotalAmt = toNumber(row.TotalAmt);
				 RowSalesAmount=toNumber(row.SalesAmount)	
			  }
		    TotalAmt=toNumber(TotalAmt)+toNumber(RowTotalAmt)
		    SalesAmount=toNumber(SalesAmount)+toNumber(RowSalesAmount);
		    
		});
	  }
	    setValueById('ProTotalAmt', TotalAmt.toFixed(2)); 
        setValueById('ProSalesAmt', SalesAmount.toFixed(2));

}
	
//数值转换	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}





function RowArcQtyEnter(index, row)
{
	var ed = GV.ProdList.getEditor({index: index, field: "Qty"});
	if (ed) {
		GV.CHANGE="ROWQTY"
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowArcQtyEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowArcQtyEnterChange($(this).val());
			}
			});
	}
	
}

function RowArcQtyEnterChange(newVal)
{
	
	 var index=GV.curRowIndex;
     var row=GV.curRow
     var ed=GV.ed
     var OldQty=row.Qty
	 if (toNumber(newVal) > GV.MAXQTY) 
        {
               $.messager.alert('提示', '填写医嘱数量不能大于最大数量：'+GV.MAXQTY, 'error',function() {
	           $(ed.target).numberbox("setValue", OldQty);
				GV.ProdList.endEdit(index);
				GV.EditIndex = undefined;
				calcArcRowTotalAmt(index)
	     });
     
         }else
         {
	            
	         $(ed.target).numberbox("setValue", toNumber(newVal));
		      GV.ProdList.endEdit(index);
				GV.EditIndex = undefined;
				calcArcRowTotalAmt(index)
	            
	   }
	
}





/*
*根据医嘱数量计算医嘱金额和售价
*/
function calcArcRowTotalAmt(index,OldQty) {
    //var selectRow = $('#dgEast').datagrid('getSelected');
    //var selectRow=$HUI.datagrid('#dgEast','getSelected')
    //alert("根据数量")
    //var selectRow=$('#dgEast').datagrid('getSelected');
    var selectRow=GV.ProdList.getSelected();
    //alert(selectRow+"=selectRow")
    if(selectRow !=null)
    {
    var Qty = toNumber(selectRow.Qty);
    var ItemPrice = toNumber(selectRow.ItemPrice);
    var ActualPrice = toNumber(selectRow.ActualPrice);
    var RowTotalAmt = ItemPrice * Qty;
    var RowSalesAmount = ActualPrice * Qty;
    //GV.ProdList.getRows()[index].TotalAmt=RowTotalAmt.toFixed(2)
    //GV.ProdList.getRows()[index].SalesAmount=RowSalesAmount
    HISUIDataGrid.setFieldValue('TotalAmt', RowTotalAmt.toFixed(2), index, 'dgEast');
    HISUIDataGrid.setFieldValue('SalesAmount', RowSalesAmount.toFixed(2), index, 'dgEast');
    if (RowTotalAmt < RowSalesAmount) {
	    //GV.ProdList.getRows()[index].ActualPrice=ItemPrice
        //GV.ProdList.getRows()[index].SalesAmount=RowTotalAmt
        HISUIDataGrid.setFieldValue('ActualPrice', ItemPrice, index, 'dgEast');
        HISUIDataGrid.setFieldValue('SalesAmount', RowTotalAmt.toFixed(2), index, 'dgEast');
    }
    
    }
}





function RowArcSalesAmountEnter(index, row)
{
	var ed = GV.ProdList.getEditor({index: index, field: "SalesAmount"});
	if (ed) {
		GV.CHANGE="ROWSALESAMT"
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowArcSalesAmountEnterChange(newVal);
			
	    }});
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowArcSalesAmountEnterChange($(this).val());
			}
			});
		
	}
	
}


function RowArcSalesAmountEnterChange(newVal)
{
	var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var RowQty=toNumber(row.Qty)
	var OldSalesAmount=toNumber(row.SalesAmount)
	var TotalAmt=toNumber(row.TotalAmt)
	//alert("newVal"+newVal)
	    if ((toNumber(newVal) < GV.MinRowSalesAmount)&& (toNumber(newVal) > 0))
             {
               $.messager.alert('提示', '填写医嘱实售金额不能小于最小金额：'+GV.MinRowSalesAmount, 'error',function() {
	            $(ed.target).numberbox("setValue", OldSalesAmount);
				GV.ProdList.endEdit(index);
				GV.EditIndex = undefined;
				calcArcRowActualPrice(index)
	        });
     
            }
            else{
	            
	              if(RowQty!=0)
	               {
	             	 var ActualPrice= toNumber(newVal) / RowQty
	           		 if (ActualPrice < GV.MinRowActualPrice)
	           			 {
		             		$.messager.alert('提示', '通过计算实售单价不能小于最实售单价：'+GV.MinRowActualPrice, 'error',function() {
			  
			              	$(ed.target).numberbox("setValue", OldSalesAmount);
			              	GV.ProdList.endEdit(index);
				          	GV.EditIndex = undefined;
				          	calcArcRowActualPrice(index)
			             
			             });
		       		}
		         
		        	if  (TotalAmt <toNumber(newVal))
		       		 {
			        
			          	 $.messager.alert('提示', '实售金额不能大于金额：'+TotalAmt, 'error',function() {
			              $(ed.target).numberbox("setValue", OldSalesAmount);
			              GV.ProdList.endEdit(index);
				          GV.EditIndex = undefined;
				          calcArcRowActualPrice(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", toNumber(newVal));
				         GV.ProdList.endEdit(index);
				         GV.EditIndex = undefined;
				         calcArcRowActualPrice(index)
				         
				     }
	             }
	             else
	             {
		            	$(ed.target).numberbox("setValue", 0);
		            	GV.ProdList.endEdit(index);
				        GV.EditIndex = undefined;
				        calcArcRowActualPrice(index)
		           	 
		          }

	            }
	
	
	}




/*
*根据医嘱售价计算医嘱实售单价
*/
function calcArcRowActualPrice(index,OldSalesAmount) {
  
    var selectRow=GV.ProdList.getSelected();
    if(selectRow !=null)
    {
    var RowQty = toNumber(selectRow.Qty);
    var ItemPrice = toNumber(selectRow.ItemPrice);
    var RowTotalAmt=toNumber(selectRow.TotalAmt)
    var RowSalesAmount =toNumber(selectRow.SalesAmount)
    if (RowQty < 0) 
    {

        $.messager.alert('提示', '填写数量不能小于零', 'info');
        HISUIDataGrid.setFieldValue('Qty', 1, index, 'dgEast');

     }
    else {
        if (RowTotalAmt < RowSalesAmount) {
            $.messager.alert('提示', '填写实售金额不能大于医嘱金额', 'info');
            HISUIDataGrid.setFieldValue('SalesAmount', OldSalesAmount, index, 'dgEast');

        }
        else {

            var RowActualPrice = RowSalesAmount / RowQty;
            HISUIDataGrid.setFieldValue('ActualPrice', RowActualPrice.toFixed(GV.PRICEPRECISION), index, 'dgEast');

        }
    }
    }
}




function RowArcActualPriceEnter(index, row)
{
	var ed = GV.ProdList.getEditor({index: index, field: "ActualPrice"});
	if (ed) {
		GV.CHANGE="ACTUALP"
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowArcActualPriceEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowArcActualPriceEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowArcActualPriceEnterChange(newVal)
{
   var index=GV.curRowIndex;
   var row=GV.curRow
   var ed=GV.ed
	var RowQty=toNumber(row.Qty)
	var OldArcActualPrice=toNumber(row.ActualPrice)
	var TotalAmt=toNumber(row.TotalAmt)
	 if ((toNumber(newVal) < GV.MinRowActualPrice)&& (toNumber(newVal) > 0))
             {
               $.messager.alert('提示', '填写医嘱实售单价不能小于：'+GV.MinRowActualPrice, 'error',function() {
	           $(ed.target).numberbox("setValue", OldArcActualPrice);
				GV.ProdList.endEdit(index);
				GV.EditIndex = undefined;
				calcArcRowSalesAmount(index)
	        });
     
            }
            else{
	            
	              var SalesAmount = toNumber(newVal) *  RowQty 
		         
		        	if (TotalAmt <SalesAmount)
		       		 {
			        
			          	 $.messager.alert('提示', '实售金额不能大于金额：'+TotalAmt, 'error',function() {
			              $(ed.target).numberbox("setValue", OldArcActualPrice);
			              GV.ProdList.endEdit(index);
				          GV.EditIndex = undefined;
				          calcArcRowSalesAmount(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", newVal);
				         GV.ProdList.endEdit(index);
				         GV.EditIndex = undefined;
				         calcArcRowSalesAmount(index)
				         
				     }
	             }
	
}

/*
*根据医嘱实售单价计算医嘱售价
*/
function calcArcRowSalesAmount(index,OldActualPrice) {
  
    var selectRow=GV.ProdList.getSelected();
    if(selectRow !=null)
    {
    var RowQty = toNumber(selectRow.Qty);
    var RowActualPrice = toNumber(selectRow.ActualPrice);
    
    var RowTotalAmt=toNumber(selectRow.TotalAmt)
    var RowSalesAmount = RowActualPrice *  RowQty
    
   
    if (RowTotalAmt < RowSalesAmount) {
        $.messager.alert('提示', '实售单价*数量不能大于此医嘱金额', 'info');
        HISUIDataGrid.setFieldValue('ActualPrice', OldActualPrice, index, 'dgEast');
        SalesAmount = 0;
    }

    HISUIDataGrid.setFieldValue('SalesAmount', RowSalesAmount.toFixed(2), index, 'dgEast');

    
    }
}


//获取不可打折医嘱项目总金额
function getNoDisArcAmt()
{
	var NoArcAmt=0.0
	 $.each(GV.ProdList.getRows(),function(index,row)
	    {
		 if (row.IsDiscnt==0)
		 {
		   NoArcAmt=NoArcAmt+toNumber(row.TotalAmt)
		 }
		 
		 });
	return NoArcAmt ;
		
}



/*
*根据指定总售价计算每条医嘱的 实际单价,和实际实际售价
*/
function calcAvgArcRows() {
	//alert(123)
    var rate = 0.00;
    var tProAmt = 0.00;
    var tProSalesAmt = 0.00;
    var SalesAmtH = 0.00
    var Mistake = 0.00;
    
     tProAmt = toNumber(getValueById('ProTotalAmt'));
     if(tProAmt==0)
     {
	     
	     $.messager.alert('提示', '总金额不能等于0', 'info')
	     return ;
	     
	 }
     //tProSalesAmt = toNumber(getValueById('ProSalesAmt'));
     tProSalesAmt = toNumber($('#ProSalesAmt').val());
    if (tProAmt < tProSalesAmt) {
        $.messager.alert('提示', '填写总售价不能大于总金额', 'info',function(){
	        
	         focusById("ProSalesAmt");
	         setValueById('ProSalesAmt', tProAmt)
	        });
       
        tProSalesAmt=tProAmt
    }
    
     var NoArcAmt=getNoDisArcAmt()
     if (tProSalesAmt < NoArcAmt) {
        $.messager.alert('提示', '填写总售价不能小于不打折医嘱项目之和：'+NoArcAmt, 'info',function(){
	        
	         focusById("ProSalesAmt");
	         setValueById('ProSalesAmt', tProAmt)
	        });
       
        return ;
    }
   
    //平均折扣率
    rate = (tProSalesAmt -NoArcAmt)/ (tProAmt-NoArcAmt);
    
    var MistakeAry=new Array(GV.ProdList.getRows().length);
    MistakeIndex=-1 ;
    $.each(GV.ProdList.getRows(),function(index,row){
 	      
	      var RowItemPrice = toNumber(row.ItemPrice)
          var RowQty = toNumber(row.Qty)               //选中行实售数量
          var RowActualPrice =toNumber(RowItemPrice)   //选中行实售单价
          if (row.IsDiscnt==1)
          {
	          
	        RowItemPrice = toNumber(row.ItemPrice)
            RowQty = toNumber(row.Qty)            //选中行实售数量
            RowActualPrice = (toNumber(RowItemPrice * rate)).toFixed(GV.PRICEPRECISION)  //选中行实售单价
	      if(rate == 0)
          {
	          RowActualPrice=0
	      } 
	      }
           var RowSalesAmount = (toNumber(RowActualPrice) * RowQty).toFixed(2)
          
      
            SalesAmtH = SalesAmtH + toNumber(RowSalesAmount);
            
            MistakeAry[index]=tProSalesAmt-toNumber(toNumber(SalesAmtH).toFixed(2))
	             
	     
            if ((index == (GV.ProdList.getRows().length - 1))&&(rate!=0)) {
	            //alert("tProSalesAmt="+tProSalesAmt+"  SalesAmtH="+toNumber(toNumber(SalesAmtH).toFixed(2)))
               Mistake = tProSalesAmt - toNumber(toNumber(SalesAmtH).toFixed(2))
                //alert("Mistake="+Mistake)
                if ((Mistake != 0)&&(RowQty!=0)) {
                    RowSalesAmount = toNumber(RowSalesAmount) + Mistake
                    RowActualPrice=toNumber(RowSalesAmount).toFixed(2) / RowQty
                
   
                }
            }
            HISUIDataGrid.setFieldValue('ActualPrice', toNumber(RowActualPrice).toFixed(GV.PRICEPRECISION), index, 'dgEast');
            HISUIDataGrid.setFieldValue('SalesAmount', toNumber(RowSalesAmount).toFixed(2), index, 'dgEast');
	        HISUIDataGrid.setFieldValue('Qty', RowQty, index, 'dgEast');
	 
	   
	   });
	   
	   
	   
	    for (var i=0;i<MistakeAry.length;i++)
	               {
		               var row= GV.ProdList.getRows()[i]
		               //alert("MistakeAry["+i+"]="+MistakeAry[i])
		               if ((toNumber(MistakeAry[i])<0)&&(row.IsDiscnt==1))
		               {
			                HISUIDataGrid.setFieldValue('ActualPrice', (0).toFixed(GV.PRICEPRECISION), i, 'dgEast');
                            HISUIDataGrid.setFieldValue('SalesAmount', (0).toFixed(2), i, 'dgEast');
			               
			           }
		               
		           }
	  

}