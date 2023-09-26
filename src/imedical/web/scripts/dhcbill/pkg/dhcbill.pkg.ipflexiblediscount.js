/*
 * FileName:	dhcbill.pkg.ipcoupontemplate.js
 * User:		tianzj,DingSH
 * Date:		2019-11-13
 * Function:	
 * Description: ����ۿ�
 */
 
 var GV={
	ADM:'',
	BILL:'',
	PAPMI:'',
	PACKAGEID:'',
	editRowIndex:-1,
	FixFlag:'' ,//�Ƿ���й�����ۿ� 1 : �Ѿ����й�����ۿ�
	deleteStr:'', // ɾ��������ۿ۴�
	OrdExItms:{}  ,//ҽ��ִ�м�¼��
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
	 
	//��ȡRq����
	initRqParam();
	
	//�س��¼�	 
    initKeyDown();
    
	//���ؾ����¼
	initAdmList();
	
	//����datagrid
	initDg();  
	
	//����ҽ������
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
	
	//�ǼǺŻس��¼� 
	$('#RegNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		patientNoKeydown(event);
  		}
	})
	//סԺ�Żس��¼�
	$('#MedicalNo').keydown(function(event){
  		if(event.keyCode===13) {
	  		medicalNoKeydown(event);
  		}
	})
	//��ѡ�Ը��س��¼�
	$("#PatShareAmt").keydown(
	 function(e){
		 if (e.keyCode==13)
		 {
			  var tpAmt=$(this).val();
				if (tpAmt!="")
				{
				   calcAvgOrdDisRowsByPatShareAmt();
				}else{
					$.messager.alert('��ʾ', '�ۼ۽��ֵ�Ƿ���', 'error', function() {
						focusById("#PatShareAmt");
					});
				}
			}
		 
		 });
		 
	//�ۿ��ʻس��¼�	 
	$("#PatDisRate").keydown(
	 function(e){
		 if (e.keyCode==13)
		 {
			  var tpAmt=$(this).val();
				if (tpAmt!="")
				{
				   calcAvgOrdDisRowsByPatDisRate();
				}else{
					$.messager.alert('��ʾ', '�ۿ���ֵ�Ƿ���', 'error', function() {
						focusById("#PatShareAmt");
					});
				}
			}
		 
		 });
		 
		 
	   // �������
       $HUI.linkbutton("#btnDisRate", {
            onClick: function () {
               IPOrdDisInfoSave();
            }
        });
        // ȡ������
        $HUI.linkbutton("#btnDisRateC", {
            onClick: function () {
               DleteFlexDisClick();
            }
        }); 
		 
	
}



/*
*��ȡRequest�������
*/
function initRqParam() {
      GV.ADM = getParam('AdmDr');
      var patNo   = getParam('patNo');
      setValueById("RegNo",patNo)
       getPatInfo();
}



//��ȡ�Ѿ�ҽ��������Ŀ��Ϣ
//output �ܽ��^�Ը����^�Żݽ��
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
*����ָ����ѡ�Ը�������ÿ��ҽ�����ۿ��ʺ��Ż�
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
	     
	     $.messager.alert('��ʾ', '��ѡ���ܵ���0', 'info')
	     return ;
	     
	 }
	 
	 //��ȡ�Ѵ���ҽ����Ŀ��Ϣ
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
	     
	     $.messager.alert('��ʾ', '��д�Ը�����С���Ѵ����Ը���'+DisedPatShareAmt.toFixed(2), 'info',function(){
		     
		         setValueById('PatShareAmt', DisedPatShareAmt.toFixed(2))
		         //focusById("PatShareAmt");
		      
		     })
	     
	   
	     return ;
	     
	  }
     
    if (PatToAmt < PatShareAmt) {
        $.messager.alert('��ʾ', '��д��ѡ�Ը����ܴ�����ѡ���', 'info',function(){
	        
	         focusById("PatShareAmt");
	         setValueById('PatShareAmt', PatToAmt)
	         setValueById('PatDisAmt', 0)
	        });
       
        PatShareAmt=PatToAmt
    }
    
  
   
    //ƽ���ۿ���
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
*����ָ���ۿ��ʼ���ÿ��ҽ�����Ը������Ż�
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
	     
	     $.messager.alert('��ʾ', '��ѡ���ܵ���0', 'info')
	     return ;
	     
	 }
     //tProSalesAmt = toNumber(getValueById('ProSalesAmt'));
      rate = toNumber($('#PatDisRate').val());
    if (1 < rate) {
        $.messager.alert('��ʾ', '��д�ۿ��ʲ��ܴ���1', 'info',function(){
	         focusById("PatDisRate");
	         setValueById('PatDisRate', 1)
	         rate=1
	        });
       
        PatShareAmt=PatToAmt
       return ;
    }
    
     //��ȡ�Ѵ���ҽ����Ŀ��Ϣ
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
* �����������ݱ��
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
				   {field: 'TadmDate',	title: '����ʱ��', width: 150},
				   {field: 'TadmLoc', title: '�������', width: 90},
				   {field: 'TadmWard', title: '���ﲡ��', width: 130},
				   {field: 'TdisDate', title: '��Ժʱ��', width: 150},
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
			//getAdmInfo();// ���ر�ͷ ������Ϣ
			//CheckPackage();
			initPatOrdGrid();
			initPatShareGrid();
			
			
		}
	});
}
/**
* ���ؾ����б�
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
 * �ǼǺŻس�
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
 * סԺ�Żس�
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
 * ��ȡ���߻�����Ϣ
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
			$.messager.alert('��ʾ', '�ǼǺŴ���', 'error');
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
 * ��ȡ���߾�����Ϣ
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
				$.messager.alert('��ʾ', '��ȡ������Ϣʧ��'+rtn, 'error');
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
		$.messager.alert('�쳣������dhcbill.pkg.ipconfirmation.js��getAdmInfo', e,'error');
	}
}



/*
 * ��ʼ��datagrid
 */
function initDg() {
	
	//ind,arcimDesc,itmCatDesc,recDeptName,userDeptName,billed,billTotalAmt,billPashareAmt,FixFlag
	var dgColumns = [[
	        {field:'oeori',title:'ҽ��Id',width:100,hidden:true},
			{field:'FixFlag',title:'�ۿ۱�־',width:100,hidden:true},
			{field:'arcimDesc',title:'ҽ������',width:200},
			{field:'billTotalAmt',title:'ҽ�����',width:100},
			{field:'DisRate',title:'�ۿ���',width:150,hidden:true},
			{field:'billPashareAmt',title:'ҽ���Ը����',width:100 ,align:'right'},
			{field:'PatDisAmt',title:'�Żݽ��',width:150,hidden:true},
			{field:'itmCatDesc',title:'ҽ������',width:80,align:'right'},
			{field:'recDeptName',title:'���ܿ���',width:80},
			{field:'userDeptName',title:'��������',width:80},
			{field:'billed',title:'�Ʒ�״̬',width:100,align:'right'},
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
	        {field:'oeori',title:'ҽ��Id',width:100,hidden:true},
			{field:'FixFlag',title:'�ۿ۱�־',width:100,
				formatter:function(value,data,row){
					return value=='1'?'���ۿ�':'δ�ۿ�';
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'arcimDesc',title:'ҽ������',width:200},
			{field:'billTotalAmt',title:'ҽ�����',width:100},
			{field:'DisRate',title:'�ۿ���',width:100,
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						max:1,
						min:0		
					}

			}},
			{field:'billPashareAmt',title:'ҽ���Ը����',width:100 ,align:'right',
			editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}
			},
			
			{field:'PatDisAmt',title:'�Żݽ��',width:100 ,align:'right'},
			{field:'itmCatDesc',title:'ҽ������',width:80,align:'right'},
			{field:'recDeptName',title:'���ܿ���',width:80},
			{field:'userDeptName',title:'��������',width:100},
			{field:'billed',title:'�Ʒ�״̬',width:80,align:'right'},
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
			//clearGlobal(); // ����ǰ�����
			//LoadSuccessHandle(data);
			//if(GV.FixFlag=='1'){
			//	disableElement(); //�Ѿ������ۿ�	
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
* ҽ����¼��Ԫ��༭
*/
function PatOrdDisEditCell(index, field, value) {
	GV.DisOrdList.selectRow(index);   //ѡ���趨��
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
* ��Ԫ���Ƿ�ɱ༭
* true: �ɱ༭, false: ���ɱ༭ ,,
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
*��ʼ�༭
*/
function PatOrdDisBeginEdit(index, row)
 {
     RowDisRateEnter(index, row);
     RowPatSalesAmtEnter(index, row);
     
}

/**
* �����༭
*/
function PatOrdDisAfterEdit(index, rowData, changes) {
	GV.DisOrdList.endEdit(index);
	GV.EditIndex = undefined;
	CalcPatDisOrdAmt()
}

/**
*��Ԫ��-�����ۿ��ʼ���ʵ�ս��
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
               $.messager.alert('��ʾ', '��д�ۿ��ʲ��ܴ��� 1', 'error',function() {
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
			        
			          	 $.messager.alert('��ʾ', '�Ը����ܴ���ҽ����'+PashareAmt, 'error',function() {
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
*��Ԫ��-����ʵ�ս������ۿ���
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
               $.messager.alert('��ʾ', '��д�Ը����ܴ���ҽ�����', 'error',function() {
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
 * ����ҽ��grid
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
 * ����ۿ�grid
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
*ѡ��ҽ����ҽ���б��ƶ�����ѡҽ���б�
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
        $.messager.alert('��ʾ', '��ѡ��Ҫ���۵�ҽ��', 'info');
        return;
    }
   GV.DisOrdList=$HUI.datagrid('#dgPatShareOrd')
   GV.CHANGE=""
   CalcPatDisOrdAmt();
   
   
}

/*
*�Ѿ�ѡ��ҽ���Ƿ������ͬҽ��
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
            $.messager.alert('��ʾ', '��ѡҽ���Ѿ�������ͬ��ҽ��' + ExistInfo, 'error');

        }
    }
    }
    return Flag
}

/*
*����ѡҽ���б��ƶ���ҽ���б�
*ע�⣺�Ѿ�����ۿ۵Ĳ��������
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
		   	 $.messager.alert("��ʾ", "�Ѿ���ɴ���ҽ��,���ܵ���ɾ��", 'error')
		   	 return;
		 }
	   	 if (FormatVal(Rows[0].FixRowId) != "") 
	   	 {
		   	 
		   	 $.messager.alert("��ʾ", "�Ѿ���ɴ���,������ɾ��", 'error')
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
		 $.messager.alert('��ʾ', 'ֻ��ѡ��һ��ҽ���Ƴ�', 'info');
	}	
  }
}




 /*
*�����Ը�����ʵ�۽��
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


	
//��ֵת��	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}
//ȡֵ��ʽ
function FormatVal(value) {
    var OutV = value
    if (undefined == value) {
        OutV = "";
    }
    return OutV
}
//ƴҽ����
//��ʽ:��ҽ��RowId^ҽ�����^�ۿ۽��^�Ը����^�ۿ��ʣ��������֮����$���ŷָ�
function BuildDisOrdStr()
{
	
	var OrdStr=""
	if (!(JSON.stringify(GV.DisOrdList) == "{}"))
	{
		
		
		$.each(GV.DisOrdList.getRows(), function (index, row) {
	      if(row.FixFlag==0)
	    	{
			var RowOrdStr="" 
			RowOrdStr=row.oeori   //ҽ��Id
			///RowOrdStr=RowOrdStr+"^"+row.billTotalAmt //ҽ�����
			//RowOrdStr=RowOrdStr+"^"+row.PatDisAmt    //�Żݽ��
			///RowOrdStr=RowOrdStr+"^"+row.billPashareAmt //ҽ���Ը����
			///RowOrdStr=RowOrdStr+"^"+row.DisRate //�ۿ���
		   if (OrdStr==""){OrdStr=RowOrdStr}
		   else{OrdStr=OrdStr+"$"+RowOrdStr}
	    	}
		    
		});
			
   }
	
	return OrdStr
}

 
//������ҽ����Ϣ����
function IPOrdDisInfoSave()
{
	var PatDisAmt=toNumber(getValueById('PatDisAmt'));
	var PatToAmt=toNumber(getValueById('PatToAmt'));
	var PatDisRate=toNumber(getValueById('PatDisRate'));

	
	//alert("PatDisAmt="+PatDisAmt+";;;"+PatToAmt)
	if (PatDisAmt <= 0){
		$.messager.alert('��ʾ', '���������', 'info')
		return ;
	}

	var AdmDr="", OrdStr="", DiscRate="",  SPDNo="", HospDr="", UserDr=""
	AdmDr=GV.ADM
	OrdStr=BuildDisOrdStr();
	//alert("OrdStr="+OrdStr)
	if (OrdStr=="")
	{
		$.messager.alert('��ʾ', 'û����Ҫ���۵�ҽ������ѡ��', 'info')
		return ;
	}
	SPDNo=getValueById("DisSPNo")
	if (SPDNo=="")
	{
		$.messager.alert('��ʾ', '�������Ų���Ϊ��', 'info')
		return ;
	}
	HospDr=PUBLIC_CONSTANT.SESSION.HOSPID
    if (HospDr=="")
	{
		$.messager.alert('��ʾ', 'Ժ������Ϊ��', 'info')
		return ;
	}
	UserDr=GV.GUser
	if (UserDr=="")
	{
		$.messager.alert('��ʾ', '����Ա����Ϊ��', 'info')
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
		  $.messager.alert('��ʾ', '������۳ɹ�', 'info');
		  initPatShareGrid();
		
		}else
		{
		 $.messager.alert('��ʾ', '�������ʧ��'+rtn, 'error');
		 return;
		}	
        });
	
}

/*
 * ɾ���ۿ�
 */
function DleteFlexDisClick(){
	$.messager.confirm('��ʾ','�Ƿ�ȡ������ۿۼ�¼��',function(r){
		if(r){
			$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountIPDelete",
					AdmDr:GV.ADM,
					HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('��ʾ','ɾ���ɹ�','info',function(){
							initPatShareGrid();
						});
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��:'+rtn.split('^')[1],'info');
						
					}
				})
				
			}		
		})				
}
