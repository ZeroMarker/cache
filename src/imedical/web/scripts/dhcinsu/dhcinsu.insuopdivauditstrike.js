/* 
 * FileName:	dhcinsu.insuopdivauditstrike.js
 * User:		HanZH
 * Date:		2022-10-17
 * Function:	
 * Description: ҽ�������˷����
*/

var Guser=session['LOGON.USERID'];
$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	//setElementEvent(); //ҳ���¼���ʼ��
});

//ҳ�沼�ֳ�ʼ��
function setPageLayout(){
	
	// Ĭ������
	$('#StartDate').datebox('setValue', getDefStDate(-1)); 	// getDefStDate() -> ��Ҫ���� <DHCBILL/>
	$('#EndDate').datebox('setValue', getDefStDate(0));
	
	$('#RegNo').on('keydown', function (e) {
		findPatKeyDownRegNo(e);
	});				
	
	//��ѯ
	$HUI.linkbutton("#btnQuery", {
		onClick: function () {
			loadDivDataGrid();
		}
	});
	
	//ҽ������
	$HUI.linkbutton("#btn-InsuDivCancel", {
		onClick: function () {
			InsuOPDivideStrikeForAudit();
		}
	});
	
	
	//��ӡҽ�����㵥
	$HUI.linkbutton("#btn-InsuDivPrint", {
		onClick: function () {
			InsuDivPrint();
		}
	});
	
	
	//Ԥ���㵥
	$HUI.linkbutton("#btn-InsuPreDivPrint", {
		onClick: function () {
			InsuPreDivPrint();
		}
	});

	
	//��Ʊ��ϸ�б�
	$HUI.datagrid('#DivGrid',{
		//title:'ҽ��������ϸ',
		border:false,
		iconCls:'icon-apply-check',
		headerCls:'panel-header-gray',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		//checkOnSelect:false,
		singleSelect:true,
		pagination:true,
		toolbar: '#InvToolBar', // ������ ��Ӧcsp�е�id
		pageSize:30,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
				//{field:'checkbox',checkbox:true},
				{field:'TRowid',title:'����ID',width:100},
				{field:'TFlag',title:'�����־',width:80},
				{field:'TRegNo',title:'�ǼǺ�',width:100},
				{field:'TPatName',title:'��������',width:100},
				{field:'TPatID',title:'�������֤��',width:140},
				{field:'Tdjlsh',title:'���ݺ�',width:80},
				{field:'TAmt',title:'������',width:80,align:'right'},
				{field:'TDate',title:'��������',width:100},
				{field:'TTime',title:'����ʱ��',width:100},
				{field:'Tjjzfe',title:'����֧��',width:80,align:'right'},
				{field:'Tzhzfe',title:'�˻�֧��',width:80,align:'right'},
				{field:'Tgrzfe',title:'�ֽ�֧��',width:80,align:'right'},
				{field:'TUserID',title:'������ID',width:80,hidden:true},
				{field:'TUserName',title:'������',width:80}
		]],
		onLoadSuccess:function(){
		},
		onSelect:function(rowIndex,rowData){
			//loadOEDataGrid(rowIndex,rowData);
		}
	});
	
	var a =document.getElementsByClassName("layout-button-up");
	//a[0].style.display="none";
}


///�ǼǺŻس�
function findPatKeyDownRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNo();
		loadDivDataGrid();
	}
}

//�ǼǺŲ���  
function GetRegNo(){
	var RegNo=$('#RegNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	$('#RegNo').val(RegNo);	
}

///���ط�Ʊ�б���Ϣ
function loadDivDataGrid(){
	
	var StartDate = $('#StartDate').datebox('getValue');
	var EndDate = $('#EndDate').datebox('getValue');
	var RegNo=$('#RegNo').val();
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPDivInfo',
		StartDate:StartDate, 
		EndDate:EndDate, 
		RegNo:RegNo,
		Guser:Guser
	}
	$('#DivGrid').datagrid('options').url = $URL;
	$('#DivGrid').datagrid('load',queryParams);
	
}


///����ҽ������
function InsuOPDivideStrikeForAudit(){
	
	var rows = $('#DivGrid').datagrid('getSelected'); //�м�¼
	if(!rows){
		$.messager.alert('��ʾ','��ѡ����Ҫ����ļ�¼','info');
		return;
	}
	var DivRowid=rows.TRowid;
	var ExpString="S^^^^"
	var CPPFlag=""
	var AdmReasonId=tkMakeServerCall("web.INSUDicDataCom","GetDicDataDescByCode","HISPROPerty00A","OpChrgChkSetlAdmReasonId",session['LOGON.HOSPID']);
	if(AdmReasonId==""){
		$.messager.alert('��ʾ','���ʵ�Ƿ�ά����HISPROPerty00A�µ�OpChrgChkSetlAdmReasonId�ֵ����ã�','info');
		return;
	}
	var DivideStr=InsuOPDivideStrikeAudit(0,Guser,DivRowid,"1",AdmReasonId,ExpString,CPPFlag)
	$('#DivGrid').datagrid('reload');
}


function getDefStDate(space) {
	if (isNaN(space)) {
		space = -30;
	}
	var dateObj = new Date();
	dateObj.setDate(dateObj.getDate() + space);
	var myYear = dateObj.getFullYear();
	var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
	var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
	var dateStr = "";
	var sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false); //ͬ������ȡϵͳ�������ڸ�ʽ
	if (sysDateFormat == 1) {
		dateStr = myMonth + '/' + myDay + '/' + myYear;
	} else if (sysDateFormat == 3) {
		dateStr = myYear + '-' + myMonth + '-' + myDay;
	} else {
		dateStr = myDay + '/' + myMonth + '/' + myYear;
	}

	return dateStr;
}

///�ǼǺŻس�
function findPatKeyDownRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNo();
		loadDivDataGrid();
	}
}

//�ǼǺŲ���  
function GetRegNo(){
	var RegNo=$('#RegNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	$('#RegNo').val(RegNo);	
}

function InsuDivPrint(){
	var StrInvDrStr=""
	var DivRowid=""
	var rows = $('#DivGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(DivRowid==""){DivRowid=rows[i].TRowid;}
			else{DivRowid=DivRowid+"^"+rows[i].TRowid}
		}
		
	}else{
		$.messager.alert('��ʾ','��ѡ����Ҫ����ļ�¼','info');
		return;
	}
	
	var GroupDR=session['LOGON.GROUPID'];
	var Guser=session['LOGON.USERID'];
	//DivRowid=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivRowidByInvprt",rows[i].TInvId);
	var AdmReasonId=tkMakeServerCall("web.INSUDicDataCom","GetDicDataDescByCode","HISPROPerty00A","OpChrgChkSetlAdmReasonId",session['LOGON.HOSPID']);
	if(AdmReasonId==""){
		$.messager.alert('��ʾ','���ʵ�Ƿ�ά����HISPROPerty00A�µ�OpChrgChkSetlAdmReasonId�ֵ����ã�','info');
		return;
	}
	var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"1",AdmReasonId,"00A^^^^^")
	
}


///Ԥ���㵥
function InsuPreDivPrint(){
	var StrInvDrStr=""
	var DivRowid=""
	var rows = $('#DivGrid').datagrid('getChecked'); //�м�¼
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(DivRowid==""){DivRowid=rows[i].TRowid;}
			else{DivRowid=DivRowid+"^"+rows[i].TRowid}
		}
		
	}else{
		$.messager.alert('��ʾ','��ѡ����Ҫ����ļ�¼','info');
		return;
	}
	DHCINVRowid=tkMakeServerCall("web.DHCINSUDivideCtl","GetInvprtByDivRowid",DivRowid);
	//var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"","","")
	filename="dhcinsu.mzmbyjsd.rpx&INVPrt="+DHCINVRowid
	DHCCPM_RQPrint(filename)
}


