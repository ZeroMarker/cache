/*
 * FileName:	dhcbill.pkg.confirmation.js
 * User:		TianZJ/tangzf/DingSH
 * Date:		2019-09-23
 * Function:	
 * Description: �����ײ�ȷ�� �ý���Ҳ���Խ�������ۿ۲���
 */
  var GV={
	 editRowIndex:-1,
	 PAPMI:'',
	 deleteStr:'', 
	 FixFlag:'',
	 PRODUCTFLAG:'', // 1 ��ʾ�Ѿ����й��ײ�ȷ��
	 NoDisFag:'',
	 OrdItms:{}  ,//ҽ��ִ�м�¼
	 EditIndex: undefined,
	 curRowIndex:-1,
     curRow:{},
     curVal:0.0,
     ed:{},
 };
 $(function () {
	// ��ʼ�����
	init_Panel();
	// ����������datagrid
	init_dg();
	// �ۿ�ԭ��
	///init_DiscReason();
	// �Ż�ȯģ��
	init_coupon();
	// �Ż�ȯdg
	init_CouponProDG();
	//�Ż�ȯ��Ʒ��ϸgrid
	initCouponDetails();
	// �ײ�ȷ����ϸdg
	init_ProConfirmDG();
	// �ײͲ�Ʒ��ϸdatagrid
	init_ProdoctOEDetails();
	// �ײ����ۿ۽���¼� (ֻ��δ���й��ۿ۵Ĳſ��Բ���)
	if(GV.FixFlag!='1'){
		$("#DiscAmt").keyup(function(e){ 
			if(e.keyCode===13){
				calDatagridRate(this.value);	
			}
		
		})
		$('#DiscAmt').bind('change',function(){
				calDatagridRate(this.value);
	  		
		})
	}
});
function init_Panel(){
	// ��ʼ��ֵ
	setValueById('RegNo',getParam('patNo'));
	if(getParam('patNo')){
		GV.PAPMI=tkMakeServerCall("web.DHCOPCashierIF","GetPAPMIByNo",getParam('patNo'),""); 
		var Name=tkMakeServerCall("web.DHCOPCashierIF","GetPatientByRowId",GV.PAPMI,"").split('^')[2]; 
		setValueById('PatName',Name);	
	}
	//��ʼ���ۿ۽��
	$('#DiscAmt').numberbox({
		precision:2,
		min:0
	})
	// ȡ��ȷ��
	$HUI.linkbutton("#btn-Delete", {
		onClick: function () {
			DeleteClick();
		}
	});
	// ȷ���ײ�
	$HUI.linkbutton("#btn-Save", {
		onClick: function () {
			loadProductOEDetails('');
			SaveClick();
		}
	});
	// �Զ�ƥ���Ż�ȯ
	$HUI.linkbutton("#btn-AutoCon", {
		onClick: function () {
			loadCouponOEDetails('');
			AutoConClick();
		}
	});
	// ȡ��ƥ���Ż�ȯ
	$HUI.linkbutton("#btn-deleteCoupon", {
		onClick: function () {
			deleteCouponClick();
		}
	});
	// ����
	$HUI.linkbutton("#btn-Clear", {
		onClick: function () {
			clearClick();
		}
	});
	// ����ۿ�
	$HUI.linkbutton("#btn-FlexDis", {
		onClick: function () {
			flexDisClick();
		}
	});
	// ɾ���ۿ�
	$HUI.linkbutton("#btn-dleteFlexDis", {
		onClick: function () {
			dleteFlexDisClick();
		}
	});
}
/*
 * ȡ��ƥ���Ż�ȯ
 */
function deleteCouponClick(){
	try{
		$.messager.confirm('��ʾ','�Ƿ�ȡ���Ż�ȯ�Զ�ƥ�䣿',function(r){
			if(r){
				$.m({
					ClassName: "BILL.PKG.BL.Coupon",
					MethodName: "UpdateCouponConfirmByOrdRowId",
					OrdStr:getParam('ordStr'),
					Guser:PUBLIC_CONSTANT.SESSION.USERID

				}, function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('��ʾ', "ȡ���ɹ�", 'info',function(){
							clearClick();	
						});
					}else{
						$.messager.alert('��ʾ', "ȡ��ʧ��:"+rtn, 'info',function(){
							clearClick();
						});	
					}
				});
			}
		})
	}catch(e){
		$.messager.alert('��ʾ', "�쳣������deleteCouponClick:" + e, 'info');	
	}	
}

/*
 * ����
 */
function clearClick(){
	initLoadGrid();
	var GV={
		editRowIndex:-1,
		PAPMI:'',
		deleteStr:'', 
		FixFlag:'',
		PRODUCTFLAG:'' // 1 ��ʾ�Ѿ����й��ײ�ȷ��
 	};		
}
/*
 * ȷ���ײ�
 */
function SaveClick(){
	showCounpConfirmWindow();
}
/*
 * ȡ��ȷ��
 */
function DeleteClick(){
	if(GV.PRODUCTFLAG!='1'){
		$.messager.alert('��ʾ', "ûҪ��Ҫȡ�����ײ�", 'info');	
		return;	
	}
	var OEORDStr=getCancleOEORDStr();
	if(OEORDStr=='out'||OEORDStr==''){
		$.messager.alert('��ʾ', "û����Ҫȡ����ҽ��,���߹�ѡ���ײ����ҽ��", 'info');	
		return;
	}else{
		$.messager.confirm('��ʾ','�Ƿ�ȡ��ȷ�Ϲ����ײͣ�',function(r){
			if(r){
				$.m({
					ClassName: "BILL.PKG.BL.Coupon",
					MethodName: "UpdatePatProductByOrdRowId",
					Guser:PUBLIC_CONSTANT.SESSION.USERID,
					OrdStr:OEORDStr
				}, function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('��ʾ', "ȡ���ɹ�", 'info',function(){
							clearClick();	
						});
					}else{
						$.messager.alert('��ʾ', "ȡ��ʧ��:"+rtn, 'info',function(){
							clearClick();
						});	
					}
				});
			}
		})		
	}	
}
/*
 * ��ȡҪȡ���ײ͵�ҽ����
 */
function getCancleOEORDStr(){
	var OEORDStr='';
	var selectRowData=$('#dg').datagrid('getChecked');
	$.each(selectRowData,function(index, row){
		OEORDStr==''?OEORDStr=row.OEOrdRowID:OEORDStr=OEORDStr+'^'+row.OEOrdRowID;
		if(row.ProductFlag==0){ // �ײ���Ĳ���Ҫȡ��
			OEORDStr='out';
			return false;
		}
	})
	return OEORDStr;	 
}
/*
 * �ײ�ȷ�������� datagrid
 */
function init_dg() {
	var dgColumns = [[
			{title: 'ck', field: 'ck', checkbox: true,
				styler:function(value,row,index){
					return true;
				}
			},
			{field:'ProductFlag',title:'�ײͱ�ʾ',width:100,
				formatter:function(value,data,row){
					return value=='1'?'�ײ���':'�ײ���';
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				}
			},
			{field:'FixFlag',title:'�ۿ۱�־',width:100,
				formatter:function(value,data,row){
					return value=='1'?'���ۿ�':'δ�ۿ�';
					 
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'NoDisFag',title:'�ܷ����',width:80,
				formatter:function(value,data,row){
					return value=='1'?'��':'��';
					 
				},
				styler:function(value,row,index){
					return value=='1'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'ArcDesc',title:'ҽ������',width:150},
			{field:'OrdPatPrice',title:'����',width:100,align:'right'},
			{field:'PackQty',title:'����',width:80},
			{field:'PackUOM',title:'��λ',width:80},
			{field:'Amount',title:'���',width:100,align:'right'},
			{field:'DisRate',title:'�ۿ���',width:150,
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						max:1,
						min:0		
					}

			}},
			{field:'Amt',title:'ʵ�ս��',width:150 ,align:'right',
				editor:{
					type:'numberbox',
					options:{
						precision:4	,
						min:0	
					}
				}
			},
			{field:'OrdPatPrice',title:'�Ը�����',width:150,align:'right'},
			{field:'OrdDiscPrice',title:'�ۿ۵���',width:150,align:'right'},
			{field:'DiscReason',title:'�ۿ�ԭ��',width:150},
			{field:'TArcicDesc',title:'ҽ������',width:100},
			{field:'ArcCatDesc',title:'ҽ������',width:100},
			{field:'OEOrdRowID',title:'OEOrdRowID',width:150,hidden:true},
			{field:'FixRowId',title:'FixRowId',width:150,hidden:true},
			{field:'FixSubRowId',title:'FixSubRowId',width:150,hidden:true},
			{field:'ordCateType',title:'ordCateType',width:150,hidden:true},
		]];
	GV.OrdItms=$HUI.datagrid('#dg',{
		fit: true,
		border: false,
		striped: true,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		singleSelect: false,
		rowStyler:function(idnex,rowData){
		
		},
		columns: dgColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			clearGlobal(); // ����ǰ�����
			LoadSuccessHandle(data);
		},
		onSelect:function(index,rowData){
			//if(GV.FixFlag!='1'){ // �Ѿ��ۿ۹��Ĳ������ۿ�
				 //datagridEditRow(index,rowData);
				 //datagridAmtEnter();
				 //datagridRateEnter();
			//}
		},
	   onClickCell: function (index, field, value) {
			   OrdEditCell(index, field, value);
		},
	   onBeginEdit: function (index, row) {
			   OrdBeginEdit(index, row);
    	},
	
		onAfterEdit:function(rowIndex, rowData, changes){
			//if(changes.DisRate){
				//setRowRate(changes.DisRate, rowIndex, rowData);
				//setValueById('DiscAmt','');

			//}else if(changes.Amt){	
				//calcRowRate(changes.Amt, rowIndex, rowData);
				//setValueById('DiscAmt','');
			//}
			//GV.editRowIndex=-1;	
			OrdAfterEdit(rowIndex, rowData, changes);
		}
		
	});
	initLoadGrid();
}
/*
 * ����
 */
$('#btn-Clear').bind('click', function () {
	clear_Click();
})
function clear_Click(){
	window.location.reload(true);
}
 /*
 * datagrid ��ʼ��һ�б༭��������һ�б༭
 * index ��Ҫ�༭���к�
 */ 
function datagridEditRow(index,rowData){
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}		
	GV.editRowIndex=index;
	if(rowData.ProductFlag=='1'||rowData.ordCateType=='R'){return;} // �ײ��ڲ��ܱ༭
	$('#dg').datagrid('beginEdit',GV.editRowIndex);	
}
/*
 * �ײ�ȷ��������query����
 */
function initLoadGrid(){
    var queryParams={
		ClassName:'BILL.PKG.BL.Coupon',
		QueryName:'FindCouponCharge',
		OrdStr:getParam('ordStr'),
		AdmInsType:getParam('curInsType'),
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
		ExpStr:''
	}
	$('#dg').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#dg').datagrid('load');
	
	GV.OrdItms=$HUI.datagrid('#dg') //DingSH
	
}

/*
 * grid���سɹ��� ��������ײ������� & ����ȫ�ֱ���
 * data datagrid����
 */
function LoadSuccessHandle(data){
		var inAmount=0; // �ײ���ҽ�����
		var outAmount=0; // �ײ���ҽ�����
		var InPashare=0; // �ײ����Ը����
		var OutPashare=0;// �ײ����ַ����
		$.each(data.rows, function (index, row) {
			if (row.ProductFlag=='1'){ // �ײ���
					inAmount=inAmount+parseFloat(row.Amount);
					InPashare=InPashare + parseFloat(row.OrdPatPrice) * parseFloat(row.PackQty);
			}else{
				outAmount=outAmount+parseFloat(row.Amount);
				OutPashare=OutPashare + parseFloat(row.OrdPatPrice) * parseFloat(row.PackQty);	
			}	
			setGlobal(row); //����ȫ�ֱ���
		})
		setValueById('InTotal',parseFloat(inAmount).toFixed(2));
		setValueById('OutTotal',parseFloat(outAmount).toFixed(2));
		setValueById('OutPashare',parseFloat(OutPashare).toFixed(2));
		setValueById('InPashare',parseFloat(InPashare).toFixed(2));
	
}
/*
 * 
 * ��ʼ���Ż�ȯ
 */
function init_coupon(){
	$("#CounNo").keyup(function(e){ 
		if(e.keyCode===13){
			checkCoupon();
		}
	})
	$('#CounNo').bind('change',function(){
		checkCoupon();
	})
				
}
/*
* ����ۿ�
*/
function flexDisClick(){
	if(GV.FixFlag=='1'){
		$.messager.alert('��ʾ','�û����Ѿ����й�����ۿ�','info');
		return;
	}
	if(getValueById('DiscReason')==''){
		$.messager.alert('��ʾ','�������Ų���Ϊ��','info');
		return;
	}
	$('#dg').datagrid('acceptChanges');
		var editRows=$('#dg').datagrid('getRows');
		var OrdStr='';
		$.each(editRows, function (index, row) {
			if(row.DisRate!=''&&row.DisRate&&row.ordCateType!='R'){
				var OrdPatPrice=parseFloat(row.OrdPatPrice)*parseFloat(row.DisRate); //ÿ��ҽ�����Ը�����
				var OrdDiscPrice=row.OrdPatPrice-OrdPatPrice;					// ÿ��ҽ�����ۿ۵���
				var OrdInfo=row.OEOrdRowID+'^'+formatAmt(row.OrdPatPrice)+'^'+formatAmt(OrdDiscPrice)+'^'+formatAmt(OrdPatPrice)+'^'+row.DisRate+'^'+formatAmt(row.Amt)+"^"+row.PackQty;
				if(OrdStr=='') OrdStr=OrdInfo;
				else OrdStr=OrdInfo+'$'+OrdStr;
			}
		});
		///alert("OrdStr="+OrdStr);
		//return;
		if(OrdStr==''){
			$.messager.alert('��ʾ','û�б����ҽ��','info');	
			return;
		}
		$.m({
				ClassName: "BILL.PKG.BL.Flexiblediscount",
				MethodName: "FlexiblediscountSave",
				AdmDr:getParam('myAdmstr'),
				OrdStr:OrdStr,
				OrdExcStr:'',
				Acount:getValueById('OutTotal'), 
				DiscRate:'', 
				DiscAcount:getValueById('DiscAmt'), 
				DiscReason:getValueById('DiscReason'),
				HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
				UserDr:PUBLIC_CONSTANT.SESSION.USERID
			},function(rtn){
				if(rtn.split('^')[0]==='0'){
					$.messager.alert('��ʾ','����ɹ�','info',function(){
						clear_Click();	
					});
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+rtn.split('^')[1],'info',function(){
						clear_Click();	
					});
				}
			})		
}
/*
 * �Ż�ȯ�Զ�ƥ�����
 *
 * ---------Start----------  
 */
function AutoConClick(){
	var CoupNo = getValueById('CounNo');
	if(CoupNo==''){
		$.messager.alert('��ʾ', "�Ż�ȯ�Ų���Ϊ��", 'info');
		return;	
	}
	var OutPashare = getValueById('OutPashare');
	if ((OutPashare == '')||(OutPashare == 0)){
		$.messager.alert('��ʾ', "�Ը����Ϊ0�����������", 'info');
		return;	
	}
	showCounpWindow(CoupNo,OutPashare);
}
function showCounpWindow(CoupNo,Total){
	$('#couponProDetails').window({
		width:1010,
		height:570,
		title:'�Ż�ȯ�ײ�ȷ��',
		iconCls: "icon-w-list",
	});
	$('#popCouponInfo').show();	
	loadProDetailsDG(CoupNo,Total);
}
/*
 * ��ʼ���Ż�ȯ�ײͲ�Ʒdg
 */
function init_CouponProDG(){
	var dgColumns = [[
			{field:'ProCode',title:'��Ʒ����',width:150,
				formatter:function(value, row, index){
					return "<a href='#' \
					onclick='ok_click("+JSON.stringify(row)+")'>\
					"+value+"</a>";
				}
			},
			{field:'ProDesc',title:'��Ʒ����',width:100},
			{field:'ProPrice',title:'�۸�',width:120,align:'right'},
			{field:'ProSalaPrice',title:'�ۼ�',width:120,align:'right'},
			{field:'ProCreatDate',title:'��������',width:150},
			{field:'ProCreatTime',title:'����ʱ��',width:150},
			{field:'ProType',title:'��Ʒ����',width:100},
			{field:'ProCreatUser',title:'������',width:100},
			{field:'ProStatus',title:'��Ʒ״̬',width:100,
				styler:function(value,row,index){
					return value=='�Ѳ���'?'color:green;font-weight:bold':'color:red;font-weight:bold';
				}
			},
			{field:'ProductRowId',title:'�ײͲ�Ʒ��RowId',width:150,hidden:true},
		]];
	$('#ProDetailsDG').datagrid({
		fit: true,
		border: false,
		striped: true,
		columns:dgColumns,
		pagination: true,
		rownumbers: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect:true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		rowStyler:function(idnex,rowData){
		},
		onDblClickRow:function(index,rowData){
			ok_click(rowData);
		},
		onSelect:function(index,rowData){
			loadCouponOEDetails(rowData.ProductRowId);	
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				loadProductOEDetails(data.rows[0].ProductRowId);
			}	
		}
		
	});	
}
/*
 * �����Ż�ȯ�ײ�dg����
 */ 
function loadProDetailsDG(CoupNo,Total){
	var queryParams={
			ClassName:'BILL.PKG.BL.Coupon',
			QueryName:'FindCouponByCode',
			ConCode:CoupNo,
			Total:Total
	}
	$('#ProDetailsDG').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#ProDetailsDG').datagrid('load');		
}
/*
 * ��ʼ���Ż�ȯ�ײͲ�Ʒ��ϸgrid
 */ 
function initCouponDetails(CoupNo,Total){
	var dgColumns = [[
		{field:'ArcimDesc',title:'ҽ������',width:120 },
		{field:'ItemPrice',title:'��׼����',width:90,align:'right' },
		{field:'ActualPrice',title:'ʵ�۵���',width:90,align:'right' },
		{field:'Qty',title:'����',width:70,align:'right' },
		{field:'TotalAmt',title:'���',width:80,align:'right' },
		{field:'SalesAmount',title:'ʵ�۽��',width:80,align:'right' },
		{field:'PRODDayNum',title:'��������',width:80,align:'right',hidden:true},
		{field:'PRODArcimCode',title:'ҽ������',width:100,hidden:true},
		{field:'PRODMutex',title:'�����ʶ',width:80,align:'right',hidden:true},
		{field:'ArcimRowID',title:'PRODArcimId',width:50,hidden:true},
		{field:'Rowid',title:'Rowid',width:50,hidden:true}
	]];
	$('#couponDetails').datagrid({
		headerCls:'panel-header-gray',
		fit: true,
		border: false,
		striped: true,
		rownumbers: true,
		columns: dgColumns,
		pagination: true
	});		
}
/*
 * �Ż�ȯ�ײ�ȷ��
 */ 
function ok_click(rowData){
	var OrdStr=getParam('ordStr');
	var Total=getValueById('OutTotal');
	var CoupNo = getValueById('CounNo');
	if(OrdStr==''){
		$.messager.alert('��ʾ', "ҽ��������Ϊ��", 'info');
		return;	
	}
	if(CoupNo==''){
		$.messager.alert('��ʾ', "�Ż�ȯ�Ų���Ϊ��", 'info');
		return;	
	}
	if(Total==''){
		$.messager.alert('��ʾ', "�ܽ���Ϊ��", 'info');
		return;	
	}
	$.m({
		ClassName: "BILL.PKG.BL.Coupon",
		MethodName: "CounponMatching",
		CoupNo: CoupNo,
		Hosptal:PUBLIC_CONSTANT.SESSION.HOSPID,
		OrdStr:OrdStr,
		Total:Total,
		ProductRowId:rowData.ProductRowId
	}, function(rtn){
		if(rtn=='0'){
			$.messager.alert('��ʾ', "ƥ��ɹ�", 'info',function(){
				$HUI.dialog("#couponProDetails",'close');
				clear_Click();	
			});
		}else{
			$.messager.alert('��ʾ', "ƥ��ʧ��:"+rtn, 'info',function(){
				$HUI.dialog("#couponProDetails",'close');
				clear_Click();
				
			});	
		}
	});		
}

/*
 * �Ż�ȯ�Զ�ƥ�����
 *
 * ---------End----------  
 */
 /*
 * �ײ�ȷ�����
 *
 * ---------Start----------  
 */
 function showCounpConfirmWindow(){
	$('#couponProConfirm').window({
		width:1010,
		height:570,
		title:'�ͻ��ײ�ȷ��',
		iconCls: "icon-w-list",
	});	
	$('#popPKGInfo').show();
	loadProConfirmDG();
}
/*
 * �����ײ�ȷ��dg����
 */ 
function loadProConfirmDG(){
	var queryParams={
			ClassName:'BILL.PKG.BL.PatientBill',
			QueryName:'FindProductInfoByPatDr',
			PatDr:GV.PAPMI,
			ProType:'Bill'
	}
	$('#ProConfirmDG').datagrid({
		queryParams:queryParams,
		url:$URL
	})
	$('#ProConfirmDG').datagrid('load');		
}
/*
 * ��ʼ���ײ�ȷ����ϸdg
 */
function init_ProConfirmDG(){
	var dgColumns = [[
			{field:'ProCode',title:'�ײͱ���',width:80,
				formatter:function(value, row, index){
					return "<a href='#' \
					onclick='proConfirm_click("+JSON.stringify(row)+")'>\
					"+value+"</a>";
				}
			},
			{field:'ProDesc',title:'�ײ�����',width:100},
			{field:'ProRefundStandard',title:'�˷ѱ�׼',width:80},
			{field:'ProCreatDate',title:'��������',width:120},
			{field:'ProCreateTime',title:'����ʱ��',width:120},
			{field:'ProType',title:'�ײ�����',width:100},
			{field:'Prolevel',title:'�ײ͵ȼ�',width:100},
			{field:'ProPrice',title:'��׼�۸�',width:100},
			{field:'ProSalesPrice',title:'�ۼ�',width:100},
			{field:'ProStatus',title:'�ײ�״̬',width:100},
			{field:'ProUser',title:'������',width:150,hidden:true},
			{field:'ProIsshare',title:'�Ƿ���',width:150,hidden:true},
			{field:'ProContractResponsibility',title:'�Ƿ����',width:100,hidden:true},
			{field:'Type',title:'�ײ�ʹ������',width:150,hidden:true},
			{field:'PatProRowId',title:'�ײ�ҽ����dr',width:150,hidden:true},
			{field:'ProIssellseparately',title:'�Ƿ񵥶�����',width:150,hidden:true},
			{field:'ProductRowId',title:'ProductRowId',width:150,hidden:true}
		]];
	$('#ProConfirmDG').datagrid({
		headerCls:'panel-header-gray',
		fit: true,
		striped: true,
		rownumbers: true,
		singleSelect:true,
		border:false,
		pagination: true,
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			proConfirm_click(rowData);
		},
		onSelect:function(index,rowData){
			loadProductOEDetails(rowData.PatProRowId);	
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				loadProductOEDetails(data.rows[0].PatProRowId);
			}	
		}
	});	
}
/*
 * ��ʼ���ײ�ȷ��  ��Ʒ��ϸdatagrid
 */
function init_ProdoctOEDetails(){
	var Columns = [[
		{field:'ArcDesc',title:'ҽ����Ŀ',width:150},
		{field:'TotalAmount',title:'�ܽ��',width:100,},
		{field:'DiscAmount',title:'�ۿ۽��',width:100,},
		{field:'RemainingQty',title:'ʣ������',width:100,
			styler:function(value,row,index){
				return value>0?'color:green;font-weight:bold':'color:red;font-weight:bold';
			}},
		{field:'PriceperUnit',title:'����',width:100,},
		{field:'PatshareAmount',title:'�Ը����',width:150,},
		{field:'Quantity',title:'��������',width:100},
		{field:'PatsharePrice',title:'�Ը�����',width:150,},
		{field:'DiscPrice',title:'�ۿ۵���',width:100,},
		{field:'ValidstartDate',title:'��ʼ����',width:150},
		{field:'ValidendDate',title:'��������',width:150}
		]];	
	$('#dgEast').datagrid({
		headerCls:'panel-header-gray',
		fit: true,
		border: false,
		striped: true,
		rownumbers: true,
		columns: Columns,
		pagination: true,
		onLoadSuccess: function (data) {
			
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
}
/*
 * �����Ż�ȯ��Ʒ��ϸ
 */ 
function loadCouponOEDetails(ProductRowId){
	var queryParams={
			ClassName:'BILL.PKG.BL.ProductDetails',
			QueryName:'QueryProductDetails',
			ProdDr:ProductRowId
	}
	$('#couponDetails').datagrid({
		queryParams:queryParams	,
		url:$URL
	})
	$('#couponDetails').datagrid('load');
}
/*
 * �����ײͲ�Ʒ��ϸ
 */ 
function loadProductOEDetails(ProductRowId){
	var queryParams={
			ClassName:'BILL.PKG.BL.PatientBill',
			QueryName:'FindPatProductOrderDetails',
			PatProRowId:ProductRowId, 
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			ExpStr:''
	}
	$('#dgEast').datagrid({
		queryParams:queryParams	,
		url:$URL
	})
	$('#dgEast').datagrid('load');
}
/*
 * �ײ�ȷ��
 * rowData �ײ�ȷ�Ͻ����row
 */ 
function proConfirm_click(rowData){
	var editRows=$('#dg').datagrid('getRows');
	var OrdStr='';
	$.each(editRows, function (index, row) {
			var OrdInfo=row.OEOrdRowID+'^'+row.PackQty;
			if(row.FixFlag!='1'){ //�Ѿ��ۿ۵Ĳ�����ȷ��
				if(OrdStr=='') OrdStr=OrdInfo;
				else OrdStr=OrdStr+PUBLIC_CONSTANT.SEPARATOR.CH2+OrdInfo;
			}
	});
	if(OrdStr!=''){
		$.m({
			ClassName: "BILL.PKG.BL.Coupon",
			MethodName: "PatProMatching",
			PatProRowId: rowData.PatProRowId,
			OrdStr:OrdStr,
			Hosptal:PUBLIC_CONSTANT.SESSION.HOSPID,
			Guser:PUBLIC_CONSTANT.SESSION.USERID
		}, function(rtn){
			if(rtn.split('^')[0]=='0'){
				$.messager.alert('��ʾ', "ȷ�ϳɹ�", 'info',function(){
					$HUI.dialog("#couponProConfirm",'close');
					clear_Click();
				});
			}else{
				$.messager.alert('��ʾ', "ȷ��ʧ��:"+rtn, 'info',function(){
					$HUI.dialog("#couponProConfirm",'close');
					clear_Click();
				});	
			}
		});
	}else{
		$.messager.alert('��ʾ', "û�з��ϵ�ҽ��", 'info');		
	}		
}
 /*
 * �ײ�ȷ�����
 *
 * ---------End----------  
 */


/*
 * ����ۿ����
 *
 * ---------Start----------  
 */
function init_DiscReason(){
	PKGLoadDicData('DiscReason','DiscountReason','','combobox');	 
}

/*
 * ͨ�����ʵ�ս�����datagrid�ۿ���
 * value ʵ�ս��
 */
function calDatagridRate(value)
{
	var OutTotal=parseFloat($('#OutTotal').val());
	
	var NoDisAmt=GetPordOutNoDisAmt() //��ȡ�ײ��ⲻ�ɴ��۵Ľ��ϼ� DingSH 
	             
    if(value<NoDisAmt)
    {
	    
	    $.messager.alert('��ʾ','ʵ�ս���С���ײ��ⲻ�ɴ��۽��: '+NoDisAmt.toFixed(2),'info');	
		setDatagridRate(0);
		return;   
	}
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('��ʾ','ʵ�ս��ܴ����ܽ��','info');	
		setDatagridRate(0);
		return;
	}
	if ((OutTotal-NoDisAmt)==0)
	{
		 $.messager.alert('��ʾ','û�пɴ���ҽ�� '+NoDisAmt.toFixed(2),'info');	
		 return
		
		
	}
	
	var rate=(value-NoDisAmt)/ (OutTotal-NoDisAmt);
	rate=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}




/*
    ��ȡ�ײ��ⲻ�ɴ��۽��
*/
function GetPordOutNoDisAmt()
{
	var total=0.0
	var dgObj=$('#dg').datagrid('getData');
	for(var index=0;index<dgObj.total;index++){
		if((dgObj.rows[index].NoDisFag==0)&& (dgObj.rows[index].ProductFlag!=1))
		{
		
		 var amt=dgObj.rows[index].Amount ;
		 total=total+toNumber(amt)
		 
		}
		
		
		
	}			   
	
	return total 
	
	
}
/*
 * ɾ���ۿ�
 */
function dleteFlexDisClick(){
	if(GV.FixFlag!='1'){
		$.messager.alert('��ʾ','û����Ҫɾ�����ۿۼ�¼','info');
		return;
	}
	$.messager.confirm('��ʾ','�Ƿ�ɾ������ۿۼ�¼��',function(r){
		if(r){
			$.m({
					ClassName: "BILL.PKG.BL.Flexiblediscount",
					MethodName: "FlexiblediscountDelete",
					FixRowIdStr:GV.deleteStr,
				},function(rtn){
					if(rtn.split('^')[0]=='0'){
						$.messager.alert('��ʾ','ɾ���ɹ�','info',function(){
							clear_Click();	
						});
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��:'+rtn.split('^')[1],'info',function(){
							clear_Click();
						});
					}
				})
				
			}		
		})				
}



/*
 * datagrid�ۿ۱����༭��س��¼�
 */
/*function datagridRateEnter(){
	$('td[field="DisRate"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		if(this.value>1) this.value=1;
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="DisRate"] .datagrid-editable-input').bind('change',function(){
	  		if(this.value>1) this.value=1;
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}*/

/*
 * datagridʵ�ս��༭��س��¼�
 */
/*function datagridAmtEnter(){
	$('td[field="Amt"] .datagrid-editable-input').keydown(function(event){
  		if(event.keyCode===13) {
	  		//calcRowRate(this.value);
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		}
	})
	$('td[field="Amt"] .datagrid-editable-input').bind('change',function(){
	  		$('#dg').datagrid('endEdit',GV.editRowIndex);
  		
	})
}*/
/*
 * ����ʵ�ս����㵥��ҽ���ۿ���
 * amt ����ҽ��ʵ�ս��
 */
function calcRowRate(amt, index, rowData){
	var amt=parseFloat(amt);
	var OERDAmt=rowData.Amount;
	if(OERDAmt<amt){
		$.messager.alert('��ʾ','��д���ܴ���ҽ�����','info');
			HISUIDataGrid.setFieldValue('Amt', 0, index, 'dg');	
			HISUIDataGrid.setFieldValue('DisRate', 0, index, 'dg');
		}else{
			var rate=amt/parseFloat(OERDAmt);
			HISUIDataGrid.setFieldValue('DisRate',parseFloat(rate).toFixed(4), index, 'dg');
		}
}
/*
 * ���ݵ���ҽ���ۿ��ʼ���ʵ�ս��
 * rate ����ҽ���ۿ���
 */
function setRowRate(rate,index,rowData){
	var amt=rowData.Amount * rate;
	HISUIDataGrid.setFieldValue('DiscAmt', rate, index, 'dg');	
	HISUIDataGrid.setFieldValue('Amt', parseFloat(amt).toFixed(2), index, 'dg');	
	$('#dg').datagrid('endEdit', GV.editRowIndex);
}

/*
 * ��дdatagrid�ۿ���
 * rate : �ۿ���
 */
function setDatagridRate(rate){
	var eachRowobj=$('#dg').datagrid('getData');
	for(var index=0;index<eachRowobj.total;index++){
		rate=parseFloat(rate).toFixed(4);
		if((eachRowobj.rows[index].ProductFlag!=1))
		{
		 
		 
		 
		if  (eachRowobj.rows[index].NoDisFag==1)
		 {
		  var amt=eachRowobj.rows[index].Amount * rate;
		  HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
		  HISUIDataGrid.setFieldValue('DisRate', parseFloat(rate).toFixed(4), index, 'dg');
		 
		 }
		 else
		 {
		  var amt=eachRowobj.rows[index].Amount ;	 
		  HISUIDataGrid.setFieldValue('Amt',parseFloat(amt).toFixed(4), index, 'dg');
		  HISUIDataGrid.setFieldValue('DisRate', (1).toFixed(4), index, 'dg');
			 
		 }
		
		
		  
		
		}
	}	
}
/*
 * ����datagrid�ۿ���
 * value ʵ�ս��
 * ����ʵ�ս����ײ���ҽ���������ۿ���
 */
function calDatagridRateOld(value){
	var OutTotal=parseFloat($('#OutTotal').val());
	value=parseFloat(value);
	if(OutTotal<value){
		$.messager.alert('��ʾ','ʵ�ս��ܴ����ײ���ҽ�����','info');	
		setDatagridRate(0);
		return;
	}
	var rate=value/OutTotal;
	value=parseFloat(rate).toFixed(4);
	setDatagridRate(rate);
}
/*
 * ����ۿ����
 *
 * ---------End----------  
 */
/*
 * ���ȫ�ֱ���
 */ 
function clearGlobal(){
	 GV.deleteStr='';
	 GV.FixFlag='';
	 PRODUCTFLAG='';
	 editRowIndex='';
}
/*
 * ����ȫ�ֱ���
 * productValue : �ײ���/���Ʒ��־
 * flexibleValue �� ����ۿ۱�־
 */ 
function setGlobal(row){
	(row.ProductFlag=='1')?GV.PRODUCTFLAG='1':true; //�Ѿ�ȷ�ϵĲ��ٽ���ȷ��
	if(row.FixFlag=='1') {
		if(GV.deleteStr==''){
			GV.deleteStr=row.FixSubRowId;
			GV.FixFlag='1';	
		}else{
			GV.deleteStr=GV.deleteStr+'^'+row.FixSubRowId; //�˴�ƴ������ ɾ������ۿ�ʱ�ٴ�ѭ��grid
		}
	}
}
/*
 * У���Ż�ȯ�Ƿ����
 */ 
function checkCoupon(){
	$.m({
		ClassName: "BILL.PKG.BL.Coupon",
		MethodName: "GetCouponInfo",
		CouponNo:getValueById('CounNo'),
		},function(rtn){
		switch(rtn){
		case '1': 
			AutoConClick();
			break;
		case '0' : 
			$.messager.alert('��ʾ','�Ż�ȯ��ʹ��','info',function(){
				setValueById('CounNo','');	
			});
			break;
		case '-1' : 
			$.messager.alert('��ʾ','�Ż�ȯ������','info',function(){
				setValueById('CounNo','');	
			});
			break;
		default:		
	   }
	})		
}


/**
* ҽ����¼��Ԫ��༭
*/
function OrdEditCell(index, field, value) {
	GV.OrdItms.selectRow(index);   //ѡ���趨��
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.OrdItms.editCell({
			index: index,
			field: field
		});
		var ed = GV.OrdItms.getEditor({
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
	if (GV.OrdItms.validateRow(GV.EditIndex)) {
		GV.OrdItms.endEdit(GV.EditIndex);
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
	var row = GV.OrdItms.getRows()[index];
	if ((field != "DisRate") && (field != "Amt")) {
	
			return false;
		
	}
	
	if((row.NoDisFag==0)||(row.NoDisFag=="��")){
		return false
		}
	if(row.ProductFlag=='1'||row.ordCateType=='R')	{
		
			return false
		}
	return true;
}

/**
*��ʼ�༭
*/
function OrdBeginEdit(index, row)
 {
     RowDisRateEnter(index, row);
     RowAmtEnter(index, row);
     
}

/**
* �����༭
*/
function OrdAfterEdit(index, rowData, changes) {
	GV.OrdItms.endEdit(index);
	GV.EditIndex = undefined;
	//CalcSalesAmt();
}


/**
*��ֵת��
*/	
function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}

/**
*��Ԫ��-�����ۿ��ʼ���ʵ�ս��
*/
function RowDisRateEnter(index, row)
{
	var ed = GV.OrdItms.getEditor({index: index, field: "DisRate"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
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
	var Amount=toNumber(row.Amount)
	 if (newVal=="") return ;
	 if (toNumber(newVal) > 1)
             {
               $.messager.alert('��ʾ', '��д�ۿ��ʲ��ܴ��� 1', 'error',function() {
	           $(ed.target).numberbox("setValue", 1);
				GV.OrdItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	              var SalesAmount = toNumber(newVal) *  Amount 
		        	if (Amount <SalesAmount)
		       		 {
			        
			          	 $.messager.alert('��ʾ', 'ʵ�ս��ܴ���ҽ����'+Amount, 'error',function() {
			              $(ed.target).numberbox("setValue", 1);
			              GV.OrdItms.endEdit(index);
				          GV.EditIndex = undefined;
				          //calcRowOrdExAmt(index)
			             
			            });
			         }
			         else
			         {
				         
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('Amt', SalesAmount.toFixed(2), index, 'dg');
				         GV.OrdItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
				         
				     }
	             }
	
}



/**
*��Ԫ��-����ʵ�ս������ۿ���
*/
function RowAmtEnter(index, row)
{
	var ed = GV.OrdItms.getEditor({index: index, field: "Amt"});
	if (ed) {
		GV.curRowIndex=index;
		GV.curRow=row;
		GV.ed=ed;
		$(ed.target).numberbox({
		 onChange:function(newVal,oldVal)
		{
			RowAmtEnterChange(newVal);
			
	    }});
	    
	    $(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) 
			{
			
				RowAmtEnterChange($(this).val());
			}
			});
	    
	    
		
	}
	
}
function RowAmtEnterChange(newVal)
{
    var index=GV.curRowIndex;
    var row=GV.curRow
    var ed=GV.ed
	var Amount=toNumber(row.Amount)
	if (newVal=="") return ;
	 if (toNumber(newVal) > Amount)
             {
               $.messager.alert('��ʾ', '��дʵ�ս��ܴ���ҽ�����', 'error',function() {
	           $(ed.target).numberbox("setValue", Amount);
				GV.OrdItms.endEdit(index);
				GV.EditIndex = undefined;
				//calcRowOrdExAmt(index)
	        });
     
            }
            else{
	            
	                     var DisRate = toNumber(newVal) / Amount 
				         $(ed.target).numberbox("setValue", newVal);
				         HISUIDataGrid.setFieldValue('DisRate', DisRate.toFixed(4), index, 'dg');
				         GV.OrdItms.endEdit(index);
				         GV.EditIndex = undefined;
				         //calcRowOrdExAmt(index)
	             }
	
}
