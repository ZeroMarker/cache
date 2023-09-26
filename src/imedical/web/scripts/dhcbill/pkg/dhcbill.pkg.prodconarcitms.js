
/*
 * FileName:	dhcbill.pkg.prodconarcitms.js
 * User:		DingSH
 * Date:		2019-09-25
 * Function:	
 * Description: �ײͲ�Ʒ����ҽ��ά��
 */
 
 /*
 *��չ��֤����
 */
 $.extend($.fn.validatebox.defaults.rules, {
	checkMinAmount: {   
	    validator: function(value) {
		    return +value >= +GV.MinSalesAmount;
		},
		message: '���ۼ۲���С������ۼ�:'
	},
	checkMaxAmount: {    
	    validator: function(value) {
		    return +value <= +getValueById("ProTotalAmt");
		},
		message: '���ۼ۲��ܴ����ܽ��'
	}
	,
	checkMinSalesMinAmount: {   
	    validator: function(value) {
		    return +value >= +GV.MinSalesAmount;
		},
		message: '����ۼ۲���С��:0'
	},
	checkMinSalesMaxAmount: {    
	    validator: function(value) {
		    return +value <= +getValueById("ProSalesAmt");
		},
		message: '����ۼ۲��ܴ������ۼ�'
	}
	
	
	
});
 

var GV=
{
    EditIndex: undefined,
    ProdList:{},
    PRICEPRECISION:4 ,        // ����С���㱣��λ��,
    MAXQTY:100,               // �������������
    CHANGE:"" ,               // �仯����
    IsCalcProAmt:1 ,          // �Ƿ��� �ܽ������ۼ�
    MinRowSalesAmount:0.01,   // ҽ����С���
    MinRowActualPrice:0.0001, // ҽ����Сʵ�۵���
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
    PROTypeDesc:"",           //�ײ�����
    PROStatusDesc:"",         //�ײ�״̬����
    PROProdTypeDesc:"",       //�ײ�ʹ������
    PROIsshareDesc:"",        //�ײ��Ƿ���
    PROIndepDesc:"",          //�ײ��Ƿ���������
    PROLevelDesc:"",          //�ײ͵ȼ�
    PROIssellspDesc:"",       //�ײ��Ƿ��������
    GUser:session['LOGON.USERID'],
    curRowIndex:-1,
    curRow:{},
    curVal:0.0,
    ed:{},
    HOSPID:PUBLIC_CONSTANT.SESSION.HOSPID //HOSPID:session['LOGON.HOSPID'],
    
};
    
   
$(function () 
{
    init_RqParam();  	 //��ȡRq��ֵ
    init_ProdSpan();     //���ز�Ʒ��Ϣ
    init_BigLnkBtn();
    init_ArcItmsDG();   // ��ʼ��grid
    //�ؼ��ֻس��¼�
    $('#ArcKeyWords').keydown(function (e) {
        if (e.keyCode == 13) {
            loadWestGridData();
        }
    });
    init_ProSalesAmt();
    loadEastGridData(); // �����Ѿ���ѡ��ҽ��
    init_OrdCat();      // ҽ������	
    init_OrdSubCat();   // ҽ������
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
					$.messager.alert('��ʾ', '�ۼ۽��ֵ�Ƿ���', 'error', function() {
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
	
	   // ����
       $HUI.linkbutton("#btn-Save", {
            onClick: function () {
                saveConClick();
            }
        });
        // ����
        $HUI.linkbutton("#btn-trans", {
            onClick: function () {
                transClick(-1);
            }
        });
        // �Ƴ�
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
*��ȡRequest�������
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
*��ʼ��Banner
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
*ѡ��ҽ����ҽ���б��ƶ�����ѡҽ���б�
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
        $.messager.alert('��ʾ', '��ѡ��Ҫ������ҽ��', 'info');
        return;
    }
   GV.CHANGE=""
   CalcProdAmt();
   
   
}

/*
*�Ѿ�ѡ��ҽ���Ƿ������ͬҽ��
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
            $.messager.alert('��ʾ', '��ѡҽ���Ѿ�������ͬ��ҽ��' + ExistInfo, 'error');

        }
    }
    }
    return Flag
}

/*
*ѡ��ҽ������ѡҽ���б��ƶ���ҽ���б�
*ע�⣺�ݸ�״̬�Ĳ�Ʒ����ҽ����Ҫѯ��ɾ��
*/
function returnClick(index) {
	
	
	  GV.ProAmt=parseFloat(getValueById('ProTotalAmt'));
      GV.ProSalesAmt=parseFloat(getValueById('ProSalesAmt'));
                                                            
                                  
	if (!((GV.PROStatus=="5")||(GV.PROStatus=="7"))) return ; //�ǲݸ�򲵻�״̬������༭

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
		   	 
		   	 $.messager.confirm("ɾ��", "�˲�Ʒ�Ѿ�������ҽ����ϸ,ȷ������ɾ��?", function(r) {
			   	 if(r){
				   	  $.m({
                            ClassName: "BILL.PKG.BL.ProductDetails",
                            MethodName: "DelProConByProSubDr",
                            ProDr:GV.ProdDr,
                            ProSubDr: SelectedRow[0].ProSubDr,
                            UserDr: GV.GUser,
                        }, function (rtn) {
	                       
                            if (parseInt(rtn.split("^")[0]) > 0) {
                                $.messager.alert('��ʾ', 'ɾ���ɹ�', 'info');
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
                                $.messager.alert('��ʾ', 'ɾ��ʧ��,Error=' + rtn, 'info');
                               
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
		 $.messager.alert('��ʾ', 'ֻ��ѡ��һ��ҽ���Ƴ�', 'info');
	}	
  }
}
/*
* �ײ͹���ҽ��ά������datagrid
*/
function init_ArcItmsDG() {
    var dgColumns = [[
        //{field:'PROCode',title:'ҽ�������',width:140},
        { field: 'ArcimDesc', title: 'ҽ��������', width: 150 },
        { field: 'ItemPrice', title: '�۸�', width: 90 },
        { field: 'ActualPrice', title: 'ʵ�۵���', width: 90, hidden: true },
        { field: 'Qty', title: '����', width: 60, hidden: true },
        { field: 'TotalAmt', title: '���', width: 100, hidden: true },
        { field: 'SalesAmount', title: 'ʵ�۽��', width: 90, hidden: true },
        {field: 'IsDiscnt', title: '�ɷ����', width: 80, align: 'center',
             formatter: function(value,row,index){
				if (row.IsDiscnt==1){
					return "��";
				    } else {
					return "��";
				    }
			   } 
			   },
	    { field: 'billuom', title: '�Ƽ۵�λ', width: 80 },  
        {field: 'PRODRestrictiontype', title: '��������', width: 80, align: 'center',hidden: true },	       
        {field: 'PRODDayNum', title: '��������', width: 80, align: 'center',hidden: true },	
        { field: 'subcatdesc', title: '����', width: 75 },
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
        //{field:'PROCode',title:'ҽ�������',width:140},
        { field: 'ArcimDesc', title: 'ҽ��������', width: 150 },
        { field: 'ItemPrice', title: '�۸�', width: 90 },
        {
            field: 'ActualPrice', title: 'ʵ�۵���', width: 90,
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
            field: 'Qty', title: '����', width: 60,
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
        { field: 'TotalAmt', title: '���', width: 100 },
        {
            field: 'SalesAmount', title: 'ʵ�۽��', width: 90,
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
         {field: 'IsDiscnt', title: '�ɷ����', width: 80, align: 'center',
             formatter: function(value,row,index){
	             //alert("row.IsDiscnt="+row.IsDiscnt)
				if (row.IsDiscnt==1)
				    {
					 return "��";
				    }
				    else if(row.IsDiscnt=="") {
					    
					return "*";
				    }
				   else {
					return "��";
				    }
			   }

          },
          { field: 'billuom', title: '�Ƽ۵�λ', width: 80 },
		 {field: 'PRODRestrictiontype', title: '��������', width: 100, align: 'center',
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
         {field: 'PRODDayNum', title: '��������', width: 80, align: 'center',
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
        { field: 'subcatdesc', title: '����', width: 105, hidden: true },
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
*ƴ�ײͲ�Ʒ��Ϣ��
*/
function BuildProInfo() {
    var InStr = GV.ProdDr + "^" + getValueById('ProTotalAmt') + "^" + getValueById('ProSalesAmt') + "^" + getValueById('ProMinSalesAmt')
    return InStr
}
/*
*ƴ�ײͲ�Ʒҽ����ϸ��Ϣ��
*/
function BuildProSubInfo(Row) {
    //rowid^�ײͲ�ƷDr^������ҽ��^����^�Ƽ۵�λ
    var InStr = Row.ProSubDr + "^" + GV.ProdDr + "^" + Row.ArcimRowID + "^" + Row.Qty + "^" + FormatVal(Row.billuomId)
    //^��׼����^ʵ�ʵ���^���^�ۼ�^�����Ʒ(,Y,N)
    InStr = InStr + "^" + Row.ItemPrice + "^" + Row.ActualPrice + "^" + Row.TotalAmt + "^" + Row.SalesAmount + "^" + "Y"
    //^��������^����ʱ��^�޸�����^�޸�ʱ��^������
    InStr = InStr + "^" + FormatVal(Row.PRODCreatDate) + "^" + FormatVal(Row.PRODCreatTime) + "^" + "" + "^" + "" + "^" + FormatVal(Row.PRODCreatUserDr)
    //^�޸���^��������^��������^�����־
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
*У���ײͲ�Ʒ����ҽ������
*/
function checkProBalance()
{
	//#1 �� ¼��� �ײ��ܽ��/���ۼ�/����ۼ۵�У��
	var tProTotalAmt=getValueById('ProTotalAmt')
	var tProSalesAmt=getValueById('ProSalesAmt')
	var tProMinSalesAmt=getValueById('ProMinSalesAmt')
	if (toNumber(tProTotalAmt)<toNumber(tProSalesAmt))
	{
		$.messager.alert("��ʾ","У�飺�ܽ��С�����ۼ�,���޸�","error")
		focusById("ProSalesAmt");
		return false 
    }
    if (toNumber(tProSalesAmt)<toNumber(tProMinSalesAmt))
	{
		$.messager.alert("��ʾ","У�飺����ۼ۴������ۼ�,���޸�","error")
		focusById("ProMinSalesAmt");
		return false 
    }
    //#2 У������ʵ�۵���*���� �� ʵ�۽���ƽ���ϵ
    var RowsTotalAmt=0.0 ;           //ͨ���ۼӽ�� ���� �ܽ��
    var RowsSalesAmount=0.0 ;        //ͨ���ۼ��ۼ� ����  �ܼ��ۼ�
    var RowsCalcTotalAmt=0.0 ;       //ͨ�� �ۼ� * ���� ���� �ܽ�� 
    var RowsCalcSalesAmount=0.0 ;    //ͨ�� ʵ�۵��� * ���� ���� ���ۼ� 
    
    
    
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
		  $.messager.alert("��ʾ","У�飺(�۸� * ����=���)���ۼ�֮��:"+RowsCalcTotalAmt+"������ͨ���ۼӱ����[���]�ĺϼ�:"+ RowsTotalAmt+" ,���޸�","error")
		  return false;
		  
	   }
	   
	   
	  if(RowsSalesAmount!=RowsCalcSalesAmount)
	  {
		  $.messager.alert("��ʾ","У�飺(ʵ�۵��� * ����=ʵ�۽��)���ۼ�֮��:"+RowsCalcSalesAmount+ "������ͨ���ۼӱ����[ʵ�۽��]�ĺϼ�"+ RowsSalesAmount +" ,���޸�","error")
		  return false;
	   }
	   if (tProTotalAmt!=toNumber(toNumber(RowsTotalAmt).toFixed(2)))
	   {
		    $.messager.alert("��ʾ","У�飺�������ܽ�����ͨ���ۼӱ���� [���] �ĺϼ�:"+RowsTotalAmt+" ,���޸�","error")
		    return false;
		}
		
	   if (tProSalesAmt!=toNumber(toNumber(RowsSalesAmount).toFixed(2)))
	   {
		   
		    $.messager.alert("��ʾ","У�飺���������ۼ۲�����ͨ���ۼӱ���� [ʵ�۽��] �ĺϼ�:"+RowsSalesAmount+" ,���޸�","error")
		    return false;
		}
     
    return true  
	
}


/*
*�ײͲ�Ʒ����ҽ������
*/
function saveConClick() {
	if (!((GV.PROStatus=="5")||(GV.PROStatus=="7"))) return ; //�ǲݸ�򲵻�״̬������༭
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
                $.messager.alert('��ʾ', '��Ʒ����ҽ������ɹ�', 'info');
                loadEastGridData();
            } else {
                $.messager.alert('��ʾ', '����ʧ��,Error=' + rtn, 'info');
            }
        });
        //websys_showModal('close');
    } else {
        $.messager.alert('��ʾ', 'û��Ҫ���������', 'info')

    }
}
/*
*����ҽ������
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
*����ҽ������
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
*ҽ���б��ѯ
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
*�ײͲ�Ʒ�ѹ���ҽ������
*/
function loadEastGridData() {
    var url = $URL + "?ClassName=BILL.PKG.BL.ProductDetails&QueryName=QueryProductDetails" + '&ProdDr=' + GV.ProdDr;
    $('#dgEast').datagrid('options').url = url
    $('#dgEast').datagrid('reload');
}

/**
 * Grid��Ԫ�񵥻��¼�
 */
function ProdClickCell(index, field, value) {
	ProdEditCell(index, field, value);
}

/**
* ��Ʒ��Ԫ��༭
*/
function ProdEditCell(index, field, value) {
	GV.ProdList.selectRow(index);   //ѡ���趨��
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
* ��Ԫ���Ƿ�ɱ༭
* true: �ɱ༭, false: ���ɱ༭ ,,
*/
function isCellAllowedEdit(index, field, value) {
	var row = GV.ProdList.getRows()[index];
	//alert("IsDiscnt="+row.IsDiscnt)
	//������ ֧����ʽ���ܱ༭
	if ((field != "SalesAmount") && (field != "ActualPrice")&& (field != "Qty")&& (field != "PRODRestrictiontype")&& (field != "PRODDayNum")) {
	
			return false;
		
	}
	
    if ((field == "PRODRestrictiontype")|| (field == "PRODDayNum")) {
	
			return true;;
		
	}
	
	if(((row.IsDiscnt==0)||(row.IsDiscnt=="��")||((row.IsDiscnt=="*")))&&(field != "Qty")){
		return false
		}
	return true;
}



/**
*��ʼ�༭
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
* �����༭
*/
function ProdAfterEdit(index, rowData, changes) {
	GV.ProdList.endEdit(index);
	GV.EditIndex = undefined;
	CalcProdAmt();
}

 /*
*�����ܽ������ۼ�
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
	
//��ֵת��	
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
               $.messager.alert('��ʾ', '��дҽ���������ܴ������������'+GV.MAXQTY, 'error',function() {
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
*����ҽ����������ҽ�������ۼ�
*/
function calcArcRowTotalAmt(index,OldQty) {
    //var selectRow = $('#dgEast').datagrid('getSelected');
    //var selectRow=$HUI.datagrid('#dgEast','getSelected')
    //alert("��������")
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
               $.messager.alert('��ʾ', '��дҽ��ʵ�۽���С����С��'+GV.MinRowSalesAmount, 'error',function() {
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
		             		$.messager.alert('��ʾ', 'ͨ������ʵ�۵��۲���С����ʵ�۵��ۣ�'+GV.MinRowActualPrice, 'error',function() {
			  
			              	$(ed.target).numberbox("setValue", OldSalesAmount);
			              	GV.ProdList.endEdit(index);
				          	GV.EditIndex = undefined;
				          	calcArcRowActualPrice(index)
			             
			             });
		       		}
		         
		        	if  (TotalAmt <toNumber(newVal))
		       		 {
			        
			          	 $.messager.alert('��ʾ', 'ʵ�۽��ܴ��ڽ�'+TotalAmt, 'error',function() {
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
*����ҽ���ۼۼ���ҽ��ʵ�۵���
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

        $.messager.alert('��ʾ', '��д��������С����', 'info');
        HISUIDataGrid.setFieldValue('Qty', 1, index, 'dgEast');

     }
    else {
        if (RowTotalAmt < RowSalesAmount) {
            $.messager.alert('��ʾ', '��дʵ�۽��ܴ���ҽ�����', 'info');
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
               $.messager.alert('��ʾ', '��дҽ��ʵ�۵��۲���С�ڣ�'+GV.MinRowActualPrice, 'error',function() {
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
			        
			          	 $.messager.alert('��ʾ', 'ʵ�۽��ܴ��ڽ�'+TotalAmt, 'error',function() {
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
*����ҽ��ʵ�۵��ۼ���ҽ���ۼ�
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
        $.messager.alert('��ʾ', 'ʵ�۵���*�������ܴ��ڴ�ҽ�����', 'info');
        HISUIDataGrid.setFieldValue('ActualPrice', OldActualPrice, index, 'dgEast');
        SalesAmount = 0;
    }

    HISUIDataGrid.setFieldValue('SalesAmount', RowSalesAmount.toFixed(2), index, 'dgEast');

    
    }
}


//��ȡ���ɴ���ҽ����Ŀ�ܽ��
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
*����ָ�����ۼۼ���ÿ��ҽ���� ʵ�ʵ���,��ʵ��ʵ���ۼ�
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
	     
	     $.messager.alert('��ʾ', '�ܽ��ܵ���0', 'info')
	     return ;
	     
	 }
     //tProSalesAmt = toNumber(getValueById('ProSalesAmt'));
     tProSalesAmt = toNumber($('#ProSalesAmt').val());
    if (tProAmt < tProSalesAmt) {
        $.messager.alert('��ʾ', '��д���ۼ۲��ܴ����ܽ��', 'info',function(){
	        
	         focusById("ProSalesAmt");
	         setValueById('ProSalesAmt', tProAmt)
	        });
       
        tProSalesAmt=tProAmt
    }
    
     var NoArcAmt=getNoDisArcAmt()
     if (tProSalesAmt < NoArcAmt) {
        $.messager.alert('��ʾ', '��д���ۼ۲���С�ڲ�����ҽ����Ŀ֮�ͣ�'+NoArcAmt, 'info',function(){
	        
	         focusById("ProSalesAmt");
	         setValueById('ProSalesAmt', tProAmt)
	        });
       
        return ;
    }
   
    //ƽ���ۿ���
    rate = (tProSalesAmt -NoArcAmt)/ (tProAmt-NoArcAmt);
    
    var MistakeAry=new Array(GV.ProdList.getRows().length);
    MistakeIndex=-1 ;
    $.each(GV.ProdList.getRows(),function(index,row){
 	      
	      var RowItemPrice = toNumber(row.ItemPrice)
          var RowQty = toNumber(row.Qty)               //ѡ����ʵ������
          var RowActualPrice =toNumber(RowItemPrice)   //ѡ����ʵ�۵���
          if (row.IsDiscnt==1)
          {
	          
	        RowItemPrice = toNumber(row.ItemPrice)
            RowQty = toNumber(row.Qty)            //ѡ����ʵ������
            RowActualPrice = (toNumber(RowItemPrice * rate)).toFixed(GV.PRICEPRECISION)  //ѡ����ʵ�۵���
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