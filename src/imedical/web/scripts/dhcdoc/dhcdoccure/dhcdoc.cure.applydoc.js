var cureApplyDataGrid;
var cureAdmDataGrid;
var SelectApplyData="-1"

$(function(){
	//��ʼ����ѯDatagride
	try{
		IntDataGride()
	}catch(e){}
	
})

function IntLod()
{
	loadAdmDataGrid() //���ؾ�����Ϣ��ѯ 
	loadApplyDataDataGrid() //����ԤԼ����Ϣ
	IntPatMesage() //���ػ��߻�����Ϣ
	IntPAADMMesage() //���ؽ��������Ϣ
	IntDCAMesage() //���ض�Ӧ���뵥��Ϣ
	$("#ApplyUser").prop("innerText",session['LOGON.USERNAME']); //����ҽ��
	$('#ApplyDate').datebox('setValue',NowDate)
	$('#OrderArcim').keydown(lookupArcim)
	$('#OrderArcim').keyup(keyupArcim)
	$('#ImgOrderArcim').click(lookArcim)
	$('#btnSave').click(btnSave)
	IntCardType() //��ʼ��������
	$('#btnReadCard').click(ReadCard)
	$('#patNoIn').keydown(patNoInKeyDown)
	$('#patNoIn').keyup(patNoInkeyup)
	$('#cardNo').keydown(cardNoKeyDown)
	$('#btnCancel').click(btnCancelClick)
	$('#btnPrint').click(btnPrint)		
	
	
}
function btnPrint()
{
	
		var DCARowId=$('#DCARowId').val()
		if (DCARowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�����뵥��")
			return false
		}
		var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
	
		var Template=getpath+"DHCDocCurApplay.xls";
		var xlApp,xlsheet,xlBook
	 
		//���ұ߾�
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	 
		
		var xlsrow=2; //����ָ��ģ��Ŀ�ʼ����λ��
		var xlsCurcol=1;  //����ָ����ʼ������λ��
		
		
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
		var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ
		
		
		
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		
		var AdmID=CureApplyArr[15]
		var AppLoc=CureApplyArr[16]
		var AppInsertDate=CureApplyArr[17]
		var AppInsertTime=CureApplyArr[18]
		var ArcimID=CureApplyArr[20]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var InsertDate=CureApplyArr[17]
		var InsertTime=CureApplyArr[18]
		var DocCurNO=CureApplyArr[19]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var ArcimDesc=CureApplyArr[0]
		var AppLocDr=CureApplyArr[22]
		var RelocID=CureApplyArr[5]
		var AppReloc=CureApplyArr[4]
		
		
		xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
		xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
		xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
		xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppLoc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyUser
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ArcimDesc
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyDate
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyRemarks
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyPlan
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+6)=AppInsertDate+" "+AppInsertTime
	
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    xlBook.printout()
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	
}
//��excel����л��ߵķ�����
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

//�������뵥
function btnCancelClick()
{
	
	var DCARowId=$('#DCARowId').val()
	if (DCARowId==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ���������뵥��¼");
		return false
	}
	var Ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","CancelCureApply",DCARowId,session['LOGON.USERID'])
	if (Ret!=0){
		$.messager.alert("��ʾ","���뵥��¼����ʧ��"+Ret);
	}else{
		$.messager.alert("��ʾ","�����ɹ�");
		loadApplyDataDataGrid();	
	}
	
	
}
//���ػ������뵥�б�
function loadApplyDataDataGrid()
{
	try{
	var PatientID=$('#PatientID').val()
	if (PatientID=="") return
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindCureApplyList';
	queryParams.Arg1 ="";
	queryParams.Arg2 =PatientID;
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.ArgCnt =4;
	var opts = cureApplyDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureApplyDataGrid.datagrid('load', queryParams);
	cureApplyDataGrid.datagrid('unselectAll');
	}catch(e){}

	
}
//�ֹ����뿨�Ų�ѯ
function cardNoKeyDown(e)
{
	 if(e.keyCode==13)
	 {  
		      $("#patNo").val("");
		      var cardType=$("#cardType").combobox('getValue');
		      if (cardType=="") return;
		      var cardTypeInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetCardTypeInfo",cardType);
			  if (cardTypeInfo=="") return;
			  var cardNoLength=cardTypeInfo.split("^")[16];
			  var cardNo=$("#cardNo").val();
			  if(cardNo=="") return;
			  if ((cardNo.length<cardNoLength)&&(cardNoLength!=0)) {
					for (var i=(cardNoLength-cardNo.length-1); i>=0; i--) {
						cardNo="0"+cardNo;
					}
				}
			 $("#cardNo").val(cardNo);
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",cardNo,cardType)
			 if(PatientID=="")
			 {
				 alert("����Ч");
				 $("#cardNo").val('');
				 return;
			 }
			 ChangePerson(PatientID)
			 
	}	
}

///
function patNoInkeyup()
{
	IntPAADMMesage()
}

///�ǼǺŲ�ѯ������Ϣ
function patNoInKeyDown(e)
{

	if(e.keyCode==13)
	{
		 $("#cardNo").val("");
		  var patNo=$("#patNoIn").val();
		  if(patNo=="") return;
		  for (var i=(10-patNo.length-1); i>=0; i--) {
			patNo="0"+patNo;
		}
		$("#patNoIn").val(patNo);
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
		ChangePerson(PatientID)
	}
	
	
}
//����
function ReadCard()
{
	$("#cardType").combobox('setValue',2)
	var cardType=$("#cardType").combobox('getValue');
	var ret=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',cardType);
    var CardInform=DHCACC_GetAccInfo(cardType,ret)
    var myary=CardInform.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "-200": //����Ч
			alert("����Ч");
			$('#cardNo').val('')
			break;
		default:
			$('#cardNo').val(myary[1])
			 var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",myary[1],cardType)
			 if(PatientID=="")
			 {
				 alert("��δ��ѯ����Ч�Ļ�����Ϣ");
				 $("#cardNo").val('');
				 return;
			 }
			 ChangePerson(PatientID)
			 break;
	}
}

//�л�������Ϣ
function ChangePerson(PatientID)
{
	$("#PatientID").val(PatientID);
	$("#EpisodeID").val('');
	IntPatMesage()
	loadAdmDataGrid();
	loadApplyDataDataGrid()
	
}

//�����ͳ�ʼ��
function IntCardType()
{
	
		//�������б�
    $('#cardType').combobox({      
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'FindCardType'
						param.ArgCnt =0;
		}  
	});	
	

     $('#cardNo').bind('keydown', function(event){
		  
    });
    $('#cardNo').bind('change', function(event){
		   if ($("#cardNo").val()==""){$("#PatientID").val("");}
    });
	
	
	
}
//�������뵥
function btnSave()
{
	var AdmDr=$("#EpisodeID").val();
	if (AdmDr==""){$.messager.alert("��ʾ","��ѡ���߶�Ӧ�����¼");return false}
	var AppUserID=session['LOGON.USERID'];
	var AppLocDR=session['LOGON.CTLOCID'];
	var DCAAppDate= $("#ApplyDate").datebox("getValue") 
	if (DCAAppDate==""){$.messager.alert("��ʾ","���߶�Ӧ��ԤԼ����ʼ���ڲ���Ϊ��");return false}
	var Remark=$("#ApplyRemark").val()
	var ApplyPlan=$("#ApplyPlan").val()
	var OrderArcimID=$("#OrderArcimID").val()
	if (OrderArcimID==""){$.messager.alert("��ʾ","��ѡ���Ӧ��ԤԼ��Ŀ");return false}
	var ArcimReloc=$("#OrderReloc").combobox('getValue')
	if (ArcimReloc==""){$.messager.alert("��ʾ","��ѡ��ԤԼ��Ŀ��Ӧ�Ľ��տ���");return false}
	var DCANum=""
	
	
	var DCARowId=$('#DCARowId').val()
	if (DCARowId==""){
			var Insr=AdmDr+"^"+AppUserID+"^"+AppLocDR+"^"+DCAAppDate+"^"+Remark+"^"+ApplyPlan+"^"+OrderArcimID+"^"+ArcimReloc+"^"+DCANum;
			var OtherDesc=""
			var retNum=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","CheckData","","A",Insr);
			if (retNum=="Y"){
				OtherDesc="�����Ѿ�������ͬ���տ��ҵ���ЧԤԼ��,"
			}	
		
		  //���뵥Ϊ��-�����½�����
		  $.messager.confirm("��ʾ",OtherDesc+"����Ҫ�������������Ƿ����?",function(r){
			if (r){
				var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","CreateCureApplyNew",Insr);
				var RtnArry=ret.split("^")
				if (RtnArry[0]!=0){$.messager.alert("��ʾ","���뵥����ʧ��"+ret);return false}
				else {
					$('#DCARowId').val(RtnArry[1]);
					loadApplyDataDataGrid()
					IntDCAMesage()
					$.messager.alert("��ʾ","�����ɹ�");
					return true
			   }		
			}
			
		})
	}else{
		//���뵥ѡ��֮����е��Ǹ��µĲ���
		$.messager.confirm("��ʾ","��Ҫ����,�Ƿ����?",function(r){
				var UpStr=Remark+"^"+ApplyPlan+"^"+DCAAppDate+"^"+OrderArcimID+"^"+ArcimReloc
				var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","UpdateCureApply",DCARowId,AppUserID,UpStr);
				if (ret==0){
					$.messager.alert("��ʾ","�޸ĳɹ�");
					loadApplyDataDataGrid()
					return true
				}else{
					$.messager.alert("��ʾ","�޸�ʧ��"+ret);
					return false
			
				}
		})
		
    }
	
}
///��ʼ��һ�����뵥����Ϣ��������
function IntDCAMesage()
{
	$("#ApplyStatus").prop("innerText","  ");
	var DCARowId=$('#DCARowId').val()
	if (DCARowId!=""){
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
		var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ
		
		var PatID=PatientArr[0]
		var AdmID=CureApplyArr[15]
		var ArcimID=CureApplyArr[20]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var InsertDate=CureApplyArr[17]
		var InsertTime=CureApplyArr[18]
		var DocCurNO=CureApplyArr[19]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var ArcimDesc=CureApplyArr[0]
		var AppLocDr=CureApplyArr[22]
		var RelocID=CureApplyArr[5]
		
		$("#PatientID").val(PatID)
		$("#EpisodeID").val(AdmID);
		$("#ApplyDate").datebox("setValue",ApplyDate)
		$("#ApplyUser").prop("innerText",ApplyUser);
		$("#ApplyStatus").prop("innerText",ApplyStatus); 
		$("#ApplyRemark").prop("innerText",ApplyRemarks); 
		$("#ApplyPlan").prop("innerText",ApplyPlan); 
		$("#InsertDate").prop("innerText",InsertDate+" 	"+InsertTime+"	 ���뵥���:"+DocCurNO); 
		$("#OrderArcim").val(ArcimDesc)
		$("#OrderArcimID").val(ArcimID)
		IntCombReloc(AppLocDr)
		$('#OrderReloc').combobox('setValue',RelocID)
		IntPatMesage()
		IntPAADMMesage()
		loadAdmDataGrid();
		
	}
	
}
//��Ӧ�ľ�����Ϣ ����ľ���ų�ʼ��
function IntPAADMMesage()
{
	var EpisodeID=$("#EpisodeID").val()
	$("#PAADMNO").prop("innerText",EpisodeID);
	
}

function keyupArcim()
{
	var ArcimDesc=$('#OrderArcim').val().replace(/(^\s*)|(\s*$)/g,'')
	if (ArcimDesc==""){
		$('#OrderArcimID').val('')
	}
}

//����ԤԼ��Ŀ�س�ѡ��ԤԼ��Ŀ
function lookupArcim(e)
{
	try{
		var obj=websys_getSrcElement(e);
		var type=websys_getType(e);
		var key=websys_getKey(e);
		if ((type=='click')||((type=='keydown')&&(key==117))||(type=='keydown')&&(key==13)){
			lookArcim()	
		}
	}
	catch(e){
			
		
	}
	
}

function lookArcim()
{

	var ArcimDesc=$('#OrderArcim').val().replace(/(^\s*)|(\s*$)/g,'')
	var url='websys.lookup.csp';
	url += "?ID=20170511OrderArcim";
	url += "&CONTEXT=KDHCDoc.DHCDocCure.Apply:FindArcim";
	url += "&TLUJSF=ArcimLookUpSelect";
	url += "&P1=" + ArcimDesc;
	websys_lu(url,1,'');
	return websys_cancel();
}

///��Ŀ�Ŵ�
function ArcimLookUpSelect(Intext)
{

	if (Intext!=""){
		var IntextArry=	Intext.split("^")
		$('#OrderArcim').val(IntextArry[0])
		$('#OrderArcimID').val(IntextArry[1])
		IntCombReloc(session['LOGON.CTLOCID'])
		
	}

}
///��Ŀ��Ӧ�Ľ��տ���
function IntCombReloc(LocID)
{
		$('#OrderReloc').combobox('loadData',{})
		$('#OrderReloc').combobox('setValue','')
		var OrderArcimID=$('#OrderArcimID').val()
		$('#OrderReloc').combobox({
			
		valueField:'Reloc',
		textField:'RelocDesc',
		url:"./dhcdoc.cure.query.combo.easyui.csp",
		onBeforeLoad:function(param){
			param.ClassName="DHCDoc.DHCDocCure.Apply";
			param.QueryName="FindArcimReloc"
			param.Arg1=OrderArcimID;
			param.Arg2="";
			param.Arg3="";
			param.Arg4=LocID;
			param.ArgCnt=4;
			
			}
		})
		
	
}
//ѡ�����뵥��ʼ����
function DateChange(date)
{
	
	var y=date.getFullYear();
	var m=date.getMonth()+1;
	var d=date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	return y+'-'+m+'-'+d;
}

//��ʼ�����߻�����Ϣ
function IntPatMesage()
{
	var PatientID=$('#PatientID').val()
	if (PatientID!=""){
		//���ػ��߻�����Ϣ
		var ret=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByRowid",PatientID);
		if (ret!=""){
			var RetArry=ret.split("^")
			$("#patNo").prop("innerText",RetArry[1]);
			$("#patName").prop("innerText",RetArry[2]);
			$("#patSex").prop("innerText",RetArry[3]);
			$("#patAge").prop("innerText",RetArry[4]);
			$("#patAge").prop("innerText",RetArry[4]);
			$("#patType").prop("innerText",RetArry[6]);
			$("#patTel").prop("innerText",RetArry[24]);
			$("#patAddress").prop("innerText",RetArry[10]);
		}
	}
	
}

//���ؾ����¼��Ϣ
function loadAdmDataGrid()
{
	try{
	var PatientID=$('#PatientID').val()
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Apply';
	queryParams.QueryName ='FindAdm';
	queryParams.Arg1 =PatientID;
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.ArgCnt =3;
	var opts = cureAdmDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureAdmDataGrid.datagrid('load', queryParams);
	cureAdmDataGrid.datagrid('unselectAll');
	}catch(e){}
}

//��ʼ��DataFride
function IntDataGride(){
	
	// �����¼
	cureAdmDataGrid=$('#Admlist').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"PAAdm",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :[[ 
					
					{field:'RowCheck',checkbox:true}, 
					{field:'PAAdm',title:'�����',width:100,align:'center',hidden:false},  
					{field:'DCANum',title:'��ЧԤԼ��',width:100,align:'center',hidden:false},  
        			{field:'Name',title:'����',width:100,align:'center'},
        			{field:'PAPMINO',title:'�ǼǺ�',width:100,align:'center'},
        			{field:'Sex',title:'�Ա�',width:80,align:'center'}, 
        			{field:'Phone',title:'��ϵ�绰',width:100,align:'center'}, 
        			{field:'Age',title:'����',width:80,align:'center'},   
        			{field:'AdmDate',title:'��������',width:100,align:'center'},
        			{field:'AdmLoc',title:'�������',width:150,align:'center'},
        			{field:'AdmDoc',title:'����ҽ��',width:150,align:'center'},
        			{field:'DiaDesc',title:'���',width:100,align:'center'},
					{field:'AdmType',title:'��������',width:80,align:'center'},
        			{field:'PatientID',title:'PatientID',width:100,hidden:true}	   
    			 ]] ,
		onClickRow:function(rowIndex, rowData){
			$("#EpisodeID").val(rowData.PAAdm)
			IntPAADMMesage()
		}
	});
	//���뵥Grid
	cureApplyDataGrid=$('#Applist').datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		pageNumber:0,
		pageSize : 0,
		pageList : [10,50,100,200],
		//frozenColumns : FrozenCateColumns,
		//DCARowId:%String,ArcimDesc:%String,OrdStatus:%String,OrdQty:%String,OrdBillUOM:%String,
		//OrdReLoc:%String,OrdReLocId:%String,ApplyStatus:%String,ApplyUser:%String,
		//ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,
		//ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,ApplyRemarks:%String,
		//ApplyPlan:%String,Adm:%String,AppLoc:%String,InsertDate:%String,InsertTime:%String,DocCurNO:%String
		columns :[[ 
					{field:'RowCheck',checkbox:true}, 
					{field:'Adm',title:'�����',width:100,align:'center'},    
        			{field:'ArcimDesc',title:'��������',width:100,align:'center'},
        			{field:'OrdStatus',title:'����ҽ��״̬',width:100,align:'center'},
        			{field:'OrdBillUOM',title:'�Ƽ۵�λ',width:150,align:'center'},
        			{field:'OrdReLoc',title:'������տ���',width:150,align:'center'},
        			{field:'OrdReLocId',title:'OrdReLocId',width:80,align:'center',hidden:true}, 
        			{field:'ApplyStatus',title:'���뵥״̬',width:80,align:'center',
        				styler:function(value,row,index){
	        				if (value=="ȡ��"){
		        				return 'color:red'	
		        			}
	        			}
        			}, 
        			{field:'ApplyUser',title:'����Ǽ���',width:80,align:'center'}, 
        			{field:'AppLoc',title:'����Ǽǿ���',width:100,align:'center'},
        			{field:'ApplyDateTime',title:'���뿪ʼ����',width:80,align:'center'}, 
        			{field:'OrdQty',title:'��������',width:80,align:'center'},
        			{field:'ApplyAppedTimes',title:'ԤԼ����',width:80,align:'center'},   
        			{field:'ApplyNoAppTimes',title:'ʣ�����',width:100,align:'center'},
        			{field:'ApplyFinishTimes',title:'�����ƴ���',width:100,align:'center'},
        			{field:'ApplyNoFinishTimes',title:'δ���ƴ���',width:100,align:'center'},
        			{field:'ApplyRemarks',title:'���뵥��ע',width:100,align:'center'},
        			{field:'ApplyPlan',title:'���Ƽƻ�',width:100,align:'center'},
        			{field:'InsertDate',title:'�Ǽ�����',width:100,align:'center'},
        			{field:'InsertTime',title:'�Ǽ�ʱ��',width:100,align:'center'},
        			{field:'DocCurNO',title:'������',width:150,align:'center'},
        			{field:'DCARowId',title:'DCARowId',width:100,hidden:true}	   
    			 ]] ,
		onClickRow:function(rowIndex, rowData){
			if (SelectApplyData==rowIndex){
				SelectApplyData="-1"
				$('#DCARowId').val('')
				$(this).datagrid('unselectRow',rowIndex)
				
			}else{
				SelectApplyData=rowIndex
				$('#DCARowId').val(rowData.DCARowId)
				IntDCAMesage()
			}
			
			//alert()
			//loadTabData()
		}
	});
}